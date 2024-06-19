#define MAX_COURT_OFFERS 100 // Максимальное количество заявок

enum e_CourtStatus {
    COURT_STATUS_NONE, // Не существует
    COURT_STATUS_WAITING, // В ожидании
    COURT_STATUS_REVIEW, // Рассматривается
    COURT_STATUS_DONE // Рассмотрено
};

enum e_CourtDecision {
    COURT_CLASS_DECLINE, // Отклонение заявки
    COURT_CLASS_FREE_PAROLE, // УДО
    COURT_CLASS_PAROLE, // УДО + Залог
    COURT_CLASS_JAIL_REDUCE_PAROLE, // Сокращение срока в два раза + Залог
    COURT_CLASS_WORKING_OUT_PAROLE // УДО + Отработка
};

#define COURT_MINIMAL_DEPOSIT   10_000    // Минимальная сумма залога (суммы исправительных работ)
#define COURT_MAXIMAL_DEPOSIT   1_000_000 // Максимальная сумма залога (суммы исправительных работ)

#define COURT_MINIMAL_PERIOD    1         // Минимальное количество дней, в течение которых подсудимому нельзя совершать правонарушения
#define COURT_MAXIMAL_PERIOD    7         // Максимальное количество дней, в течение которых подсудимому нельзя совершать правонарушения

stock CourtMovePlayerToDock(playerid) {
    S_SetPlayerVirtualWorld(playerid, 172, 0);
    PPSetPlayerInterior(playerid, 0);
    PPSetPlayerPos(playerid, -2776.8091, 417.6989, 12.6403);
    PPSetPlayerFacingAngle(playerid, 90.0);
    return 1;
}

stock CourtMovePlayerToTerminal(playerid) {
    S_SetPlayerVirtualWorld(playerid, WORLD_PRISON_CELLS, INT_PRISON_CELLS);
    PPSetPlayerInterior(playerid, INT_PRISON_CELLS);
    PPSetPlayerPos(playerid, 1032.6429, 2443.3469, 10.8509);
    PPSetPlayerFacingAngle(playerid, 120.0);
    return 1;
}

enum courtsInfo
{
    courtsPlayerId, // playerid Создателя заявки
    courtsTakeUserId, // playerid Судьи
    e_CourtStatus: courtsStatus, // Статус заявки
    e_CourtDecision: courtsDecision // Решение судебного заседания
}
new CourtsInfo[MAX_COURT_OFFERS][courtsInfo];

// Отправить сообщение всем находящимся в зале суда
stock CourtMessage(color, const message[]) {
    foreach (new playerid : Player) {
        if (!IsPlayerInRangeOfPoint(playerid, 150.0, -2776.8091, 417.6989, 12.6403)) continue; // Не в зале суда
        if (GetPlayerVirtualWorld(playerid) != 172) continue; // Не в правительстве
        
        SendClientMessage(playerid, color, message);
    }

    return 1;
}

// Получить данные о судебном деле
stock GetCourtProcessData(courtid, &prisonerid, &arbiterid, &e_CourtStatus: status, &e_CourtDecision: decision) {
    if (courtid < 0 || courtid > MAX_COURT_OFFERS) return 0;

    prisonerid = CourtsInfo[courtid][courtsPlayerId];
    arbiterid = CourtsInfo[courtid][courtsTakeUserId];
    status = CourtsInfo[courtid][courtsStatus];
    decision = CourtsInfo[courtid][courtsDecision];

    return 1;
}

stock GoCourtsProcess(playerid, targetid)
{
    CourtMovePlayerToDock(playerid);
    new courtid = OnlineInfo[playerid][oCourtsID] - 1;
    CourtsInfo[courtid][courtsStatus] = COURT_STATUS_REVIEW;
    CourtsInfo[courtid][courtsTakeUserId] = targetid;

    return courtid;
}

stock CloseCourtsProcess(courtid, deposit = -1, period = -1)
{
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    GetCourtProcessData(courtid, prisonerid, arbiterid, courtStatus, courtDecision);

    if(courtStatus != COURT_STATUS_REVIEW) return 0;

    new log_message[64], court_message[144];
    new pretty_deposit[30]; format(pretty_deposit, sizeof(pretty_deposit), "%s", FormatNumberWithCommas(deposit));
    new pretty_period[10]; format(pretty_period, sizeof(pretty_period), "%d %s", period, PluralToText(period, "день", "дня", "дней"));

    if(courtDecision != COURT_CLASS_DECLINE && courtDecision != COURT_CLASS_JAIL_REDUCE_PAROLE)
    {
        PlayerInfo[prisonerid][pCourtsStatus] = 0;
        PPSetPlayerPos(prisonerid, -2780.8091, 417.6989, 12.6403);
        PPSetPlayerFacingAngle(prisonerid, 90.0);
        PlayerInfo[prisonerid][pHodka]++;
        PlayerInfo[prisonerid][pJailed] = 0; PlayerInfo[prisonerid][pJailTime] = 0;
        PlayerInfo[prisonerid][pRab] = 0;
        ClearAllWantedPlayer(prisonerid);
        TempGive(prisonerid);
        GameTextForPlayer(prisonerid, RusToGame("~w~Вы ~g~Свободны"), 5000, 3);
        SetPlayerToTeamColor(prisonerid);
        GF_OnPlayerUpdate(prisonerid);
    } else {
        CourtMovePlayerToTerminal(prisonerid);
    }

    switch (courtDecision) {
        case COURT_CLASS_DECLINE: { // Отклонение заявки
            PlayerInfo[prisonerid][pCourtsStatus] = 2;

            ErrorMessage(prisonerid, "{ff6347}Вам отказали в предоставлении УДО. Вы возвращены в тюрьму");
            
            strcat(log_message, "Отклонил заявку на УДО");
            format(court_message, sizeof(court_message), "* Судья %s отклонил заявку %s {ff6347}[ Заключённый возвращается в тюрьму ]", rpplayername(arbiterid), rpplayername(prisonerid));
        }
        case COURT_CLASS_FREE_PAROLE: { // УДО
            SuccessMessage(prisonerid, "{44ff99}Вас отпустили по УДО. Теперь вы свободны!");
            
            strcat(log_message, "Одобрил заявку на УДО");
            format(court_message, sizeof(court_message), "* Судья %s отпустил заключённого %s по УДО", rpplayername(arbiterid), rpplayername(prisonerid));
        }
        case COURT_CLASS_PAROLE, COURT_CLASS_JAIL_REDUCE_PAROLE: { // УДО + Залог, Сокращение срока вдвое + Залог
            if(PlayerInfo[prisonerid][pMoney] < deposit)
            {
                return ErrorMessage(arbiterid, "{ff6347}У заключенного не хватает денег на руках для оплаты залога");
            }
            else oGivePlayerMoney(prisonerid, -deposit);

            if (courtDecision == COURT_CLASS_PAROLE) {
                format(log_message, sizeof(log_message), "Одобрил заявку на УДО [Залог %d$ | Срок: %s]", deposit, pretty_period);
            
                format(court_message, sizeof(court_message),
                    "{44ff99}Вас отпустили по УДО. Сумма залога составила: %s$. Теперь вы свободны!\n\n" \
                    "Судья назначил вам срок исправления размером в %s." \
                    //"Если в течение этого времени вы не совершите ни одного правонарушения - вы сможете вернуть 75%% от суммы залога обратно"
                , pretty_deposit, pretty_period);
                SuccessMessage(prisonerid, court_message);

                format(court_message, sizeof(court_message), "* Судья %s отпустил заключённого %s по УДО {99ff66}[Залог: %s$ | Срок: %s]", rpplayername(arbiterid), rpplayername(prisonerid), pretty_deposit, pretty_period);
            } else {
                format(log_message, sizeof(log_message), "Сократил срок [Залог %d$]", deposit);

                PlayerInfo[prisonerid][pJailTime] /= 2;
                PlayerInfo[prisonerid][pCourtsStatus] = 2;

                SuccessMessage(prisonerid,"{44ff99}Вам вдвое сократили срок за залог. Вы возвращены в тюрьму"); 

                format(court_message, sizeof(court_message), "* Судья %s сократил срок заключения %s {99ff66}[ Залог: %s$ ]", rpplayername(arbiterid), rpplayername(prisonerid), pretty_deposit);
            }
        }
        case COURT_CLASS_WORKING_OUT_PAROLE: { // УДО + Отработка
            PlayerInfo[prisonerid][pCourtsDeposit] += deposit;

            new text[512];
            format(text, sizeof(text),
                "{44ff99}Вас отпустили по УДО и назначали исправительные работы. Вы обязаны их отработать.\
                \n{cccccc}Сумма исправительных работ: %s$\n\n\
                В случае неотработки работ в ближайшее время, вас снова могут посадить в тюрьму\
                \n{684F7D}Отработать нужно на работе в Клининговой Компании\
                \n{684F7D}Посмотреть сумму отработки можно в Банке", \
                \
                pretty_deposit
            );
            SuccessMessage(prisonerid, text);

            format(log_message, sizeof(log_message), "Отпустил по УДО [Сумма отработки: %d$ | Срок: %s]", PlayerInfo[prisonerid][pCourtsDeposit]);
            format(court_message, sizeof(court_message), "* Судья %s отпустил заключённого %s по УДО {99ff66}[Сумма отработки: %s$ | Срок: %s]", rpplayername(arbiterid), rpplayername(prisonerid), pretty_deposit, pretty_period);
        }
    }
    CourtMessage(COLOR_GREY, court_message);

    GiveUnit(arbiterid, 13);
    OrgLog(7, "CloseCourtsProcess", PlayerInfo[prisonerid][pID], PlayerInfo[prisonerid][pName], PlayerInfo[prisonerid][pPlaIP], PlayerInfo[arbiterid][pID], PlayerInfo[arbiterid][pName], PlayerInfo[arbiterid][pPlaIP], 0, log_message);
    DeleteOrderToCourts(prisonerid);

    if (deposit > -1 && period > 0) {
        // TODO: Выдаем новое решение суда и записываем его в базу
    }

    return 1;
}

stock CourtsList(playerid)
{
    new line[100], lines[4048];
    format(line, sizeof(line),"№ Человек\tВремя заключения\tУровень Преступности\tСтатус"), strcat(lines, line);
    new quan,timemake[20],targetid;
    for(new z = 0; z < MAX_COURT_OFFERS; z++) 
    {
        targetid = CourtsInfo[z][courtsPlayerId];
        timemake = fine_time(PlayerInfo[targetid][pJailTime]);

        if (PlayerInfo[targetid][pJailTime] < 600) continue;
        if (IsPlayerAfk(targetid)) continue;

        switch (CourtsInfo[z][courtsStatus]) {
            case COURT_STATUS_WAITING: format(line, sizeof(line), "\n%d. %s\t%s\t%d\tВ ожидании", quan + 1, rpplayername(targetid), timemake, PlayerInfo[targetid][pCrimes]), strcat(lines, line);
            case COURT_STATUS_REVIEW: format(line, sizeof(line), "\n%d. %s\t%s\t%d\tВ процессе рассмотрения", quan + 1, rpplayername(targetid), timemake,PlayerInfo[targetid][pCrimes]), strcat(lines, line);
            case COURT_STATUS_DONE: format(line, sizeof(line), "\n%d. %s\t%s\t%d\tРассмотрено", quan+1, rpplayername(targetid), timemake, PlayerInfo[targetid][pCrimes]), strcat(lines, line);
            default: continue;
        }

        List[z][playerid] = quan;
        quan++;
    }
    if(quan == 0) return ErrorMessage(playerid, "{FF6347}В данный момент нет заявок в суд");
    else ShowDialog(playerid, COURT_DIALOG_OFFERS, DIALOG_STYLE_TABLIST_HEADERS, "{ff9000}Список заявок в суд", lines, "Выбрать", "Выход");
    return 1;
}

stock CreateNewOrderToCourts(playerid, bool: message = true)
{
    if(OnlineInfo[playerid][oCourtsID] > 0 && message) return ErrorMessage(playerid,"{ff6347}У вас уже есть активная заявка, ожидайте вызова в суд!");
    if(!(PlayerInfo[playerid][pJailTime] > 0 && PlayerInfo[playerid][pJailed] == 1)) return 0;
    new courtid = -1;
    for(new i; i < MAX_COURT_OFFERS; i++)
    {
        if(CourtsInfo[i][courtsStatus] == COURT_STATUS_NONE)
        {
            courtid = i;
            break;
        }
    }
    if(courtid == -1)
    {
        if(message == true) ErrorMessage(playerid,"{ff6347}В данный момент нельзя создать заявку в суд [ Количество максимальных заявок превышено ]");
        return 1;
    }
    CourtsInfo[courtid][courtsStatus] = COURT_STATUS_WAITING;
    PlayerInfo[playerid][pCourtsStatus] = 1;
    CourtsInfo[courtid][courtsPlayerId] = playerid;
    OnlineInfo[playerid][oCourtsID] = courtid + 1;
    if(message == true) SuccessMessage(playerid,"{44ff99}Вы успешно отправили заявку в суд для рассмотрения дела");
    return 1;
}

stock DeleteOrderToCourts(playerid)
{
    new courtid = OnlineInfo[playerid][oCourtsID] - 1;
    if (courtid < 0) return 1;

    OnlineInfo[playerid][oCourtsID] = 0;
    CourtsInfo[courtid][courtsStatus] = COURT_STATUS_NONE;
    CourtsInfo[courtid][courtsPlayerId] = 0;

    return 1;
}

stock CourtEnterDeposit(courtid) {
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    GetCourtProcessData(courtid, prisonerid, arbiterid, courtStatus, courtDecision);

    #pragma unused courtStatus
    #pragma unused courtDecision

    new dialog_text[512];
    format(dialog_text, sizeof(dialog_text),
        "{ffffff}Укажите сумму для залога {99ff66}(%s$ - %s$)\n" \
        "{ffffff}Доступная сумма на руках у заключённого: {99ff66}%s$\n\n{ffffff}" \
        "Указанная вами сумма будет начислена на счёт казны\n" \
        "Если заключённый не будет нарушать правопорядок в течение указанного вами времени, ему будет возмещено 75%% от суммы залога\n\n" \
        "{cccccc}Укажите данные через пробел: Сумма Количество дней (%d - %d)", \
        \
        FormatNumberWithCommas(COURT_MINIMAL_DEPOSIT), FormatNumberWithCommas(COURT_MAXIMAL_DEPOSIT),
        FormatNumberWithCommas(PlayerInfo[prisonerid][pMoney]),
        COURT_MINIMAL_PERIOD, COURT_MAXIMAL_PERIOD
    );

    return ShowDialog(arbiterid, COURT_DIALOG_ENTER_DEPOSIT, DIALOG_STYLE_INPUT, "{ff9000}Назначение суммы залога", dialog_text, "Принять", "Назад");
}

stock CloseCourtsProcessAccept(courtid, deposit = -1, period = -1) {
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    GetCourtProcessData(courtid, prisonerid, arbiterid, courtStatus, courtDecision);

    #pragma unused courtStatus

    static const courtClasses[][] = {
        "{FF6347}Отказать в выдаче УДО",
        "{99FF66}Отпустить по УДО",
        "{99FF66}Отпустить по УДО и назначить залог",
        "{99FF66}Сократить срок заключения и назначить залог",
        "{99FF66}Отпустить по УДО и назначить исправительные работы"
    };

    new dialog_text[256];
    format(dialog_text, sizeof(dialog_text), \
        "{ffffff}Вы действительно хотите закрыть это судебное разбирательство?\n\n" \
        "{ff9000}Выбранное действие: %s\n" \
        "{ff9000}Заключённый: %s[%d]", \
        \
        courtClasses[courtDecision],
        rpplayername(prisonerid), prisonerid
    );
    
    DP[5][arbiterid] = deposit; DP[6][arbiterid] = period;
    return ShowDialog(arbiterid, COURT_DIALOG_PROCESS_ACCEPT, DIALOG_STYLE_MSGBOX, "{FF9000}Вынесение вердикта", dialog_text, "Принять", "Назад");
}

stock CourtShowArbiterOfferCall(courtid) {
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    GetCourtProcessData(courtid, prisonerid, arbiterid, courtStatus, courtDecision);

    #pragma unused courtStatus
    #pragma unused courtDecision

    if(IsPlayerAfk(prisonerid)) 
    {
        ErrorText(arbiterid, "{ff6347}Игрок в AFK, попробуйте чуть позже или выберите другую заявку");
        return CourtsList(arbiterid);
    }
    SuccessMessage(arbiterid,"{44ff99}Вы отправили заявку на рассмотрение дела заключённого");

    new str[512];
    format(str, sizeof(str), "{cccccc}Судья %s, вызывает вас на рассмотрение дела \
        \n\n{684F7D}Что это такое? \
        {cccccc}- Во время рассмотрения дела судья может:\n \
        {cccccc}- 1) Уменьшить ваш срок заключения\n \
        {cccccc}- 2) Назначить вам исправительные работы вместо заключения\n \
        {cccccc}- 3) Выпустить вас под залог, обязав вас оплатить сумму на месте \
        {ff6347}Хотите, чтобы ваше дело рассмотрели?", rpplayername(arbiterid));

    return ShowDialog(prisonerid, COURT_DIALOG_OFFER_CALL, DIALOG_STYLE_MSGBOX, "Суд", str, "Да", "Нет");
}

stock CourtShowOfferReview(courtid) {
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    GetCourtProcessData(courtid, prisonerid, arbiterid, courtStatus, courtDecision);

    new string[110];
    switch(courtStatus) {
        case COURT_STATUS_DONE: {
            format(string, sizeof(string), "Дело: %s. Заявку принял: %s.\nСтатус: Рассмотрено", rpplayername(prisonerid), rpplayername(arbiterid));
            ShowDialog(arbiterid, COURT_DIALOG_OFFER_DONE_INFO, DIALOG_STYLE_MSGBOX, "Информация о деле", string, "Закрыть", "");
        }
        case COURT_STATUS_REVIEW: {
            static const lines[] = \
            "{ff9000}Действие\t{cccccc}Мера наказания" \
            "\n{ff6347}Отказать в заявке\t{cccccc}[Вернёт заключённого в тюрьму]" \
            "\n{ff9000}Предоставить УДО\t{cccccc}[Выпустит заключённого на свободу]" \
            "\n{ff9000}Предоставить УДО под залог\t{cccccc}[Выпустит заключённого и назначит залог]" \
            "\n{ff9000}Сокращение срока под залог\t{cccccc}[Уменьшит срок заключения и назначит залог]" \
            "\n{ff9000}Предоставить УДО и исправительные работы\t{cccccc}[Выпустит и назначит сумму для отработки]";

            ShowDialog(arbiterid, COURT_DIALOG_OFFER_REVIEW, DIALOG_STYLE_TABLIST_HEADERS, "{ff9000}Судебное заседание", lines, "Выбор", "Отмена");
        }
        case COURT_STATUS_WAITING: {
            format(string, sizeof(string), "{FFFFFF}Дело: %s. Статус: Ожидание\n\nВы хотите предложить рассмотреть его дело?", rpplayername(prisonerid));
            ShowDialog(arbiterid, COURT_DIALOG_OFFER_WAITING_INFO, DIALOG_STYLE_MSGBOX, "Информация о деле", string, "Принять", "Назад");
        }
        default: {}
    }

    return 1;
}

stock dialogCase_CourtsSystem(playerid, dialogid, response, listitem, const inputtext[])
{
    switch (dialogid) {
        case COURT_DIALOG_OFFERS: {
            if(response)
            {
                if(listitem < 0 || listitem > MAX_COURT_OFFERS) return ErrorMessage(playerid, "{ff6347}Выбрана не правильная строка.");
                new courtid = DP[4][playerid] = List[listitem][playerid];
                CourtsInfo[courtid][courtsTakeUserId] = playerid;

                return CourtShowOfferReview(courtid);
            }
            else return pc_cmd_goverment(playerid);
        }
        case COURT_DIALOG_OFFER_DONE_INFO: {
            if (!response) return 1;
            return CourtsList(playerid);
        }
        case COURT_DIALOG_OFFER_WAITING_INFO: {
            new courtid = DP[4][playerid];
            if (!response) return CourtShowOfferReview(courtid);
            
            DP[1][CourtsInfo[courtid][courtsPlayerId]] = playerid;

            CourtShowArbiterOfferCall(courtid);
        }
        case COURT_DIALOG_OFFER_CALL: {
            if (response) return GoCourtsProcess(playerid, DP[1][playerid]);

            DeleteOrderToCourts(playerid);
            PlayerInfo[playerid][pCourtsStatus] = 0;
            SendClientMessage(DP[1][playerid], COLOR_GREY, "Заключенный %s отказался от рассмотрения дела", rpplayername(playerid));
        }
        case COURT_DIALOG_OFFER_REVIEW: {
            if (!response) return 1;

            new courtid = DP[4][playerid];
            if(courtid < 0 || courtid >= MAX_COURT_OFFERS) return false;
            if(CourtsInfo[courtid][courtsStatus] != COURT_STATUS_REVIEW) return 0;
            new e_CourtDecision: courtDecision = CourtsInfo[courtid][courtsDecision] = e_CourtDecision: listitem;

            if (courtDecision == COURT_CLASS_JAIL_REDUCE_PAROLE || courtDecision == COURT_CLASS_PAROLE || courtDecision == COURT_CLASS_WORKING_OUT_PAROLE) {
                return CourtEnterDeposit(courtid);
            }
            return CloseCourtsProcessAccept(courtid);
        }
        case COURT_DIALOG_ENTER_DEPOSIT: {
            new courtid = DP[4][playerid];
            if (!response) return CourtShowOfferReview(courtid);

            new deposit, period;
            if (!sscanf(inputtext, "dd", deposit, period)) {
                if (deposit >= COURT_MINIMAL_DEPOSIT && deposit <= COURT_MAXIMAL_DEPOSIT) {
                    if (period >= COURT_MINIMAL_PERIOD && period <= COURT_MAXIMAL_PERIOD) {
                        return CloseCourtsProcessAccept(courtid, deposit, period);
                    } else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Количество дней не меньше %d и не больше %d", COURT_MINIMAL_PERIOD, COURT_MAXIMAL_PERIOD);
                } else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сумма не меньше %s$ и не больше %s$", COURT_MINIMAL_DEPOSIT, COURT_MAXIMAL_DEPOSIT);
            }

            return CourtEnterDeposit(courtid);
        }
        case COURT_DIALOG_PROCESS_ACCEPT: {
            new courtid = DP[4][playerid];
            if (!response) return CourtShowOfferReview(courtid);

            new deposit = DP[5][playerid], period = DP[6][playerid];
            return CloseCourtsProcess(courtid, deposit, period);
        }
    }

    return 1;
}
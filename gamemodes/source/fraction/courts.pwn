// Минимальная и максимальная сумма для залога
#define COURT_MINIMAL_DEPOSIT       10_000
#define COURT_MAXIMAL_DEPOSIT       1_000_000

// Минимальная и максимальная суммы для отработки
#define COURT_MINIMAL_WORKING_OUT   10_000
#define COURT_MAXIMAL_WORKING_OUT   100_000

// Минимальное и максимальное количество дней, в течение которых подсудимому нельзя совершать правонарушения (или нужно отработать за этот срок)
#define COURT_MINIMAL_PERIOD        1
#define COURT_MAXIMAL_PERIOD        14

#define MAX_COURT_OFFERS 100 // Максимальное количество заявок
#define MAX_COURT_PLAYER_DECISIONS 25 // Максимальное количество закрепленных за игроком активных судебных решений

// Типы заявок на суд
enum e_CourtStatus {
    COURT_STATUS_NONE, // Не существует
    COURT_STATUS_WAITING, // В ожидании
    COURT_STATUS_REVIEW, // Рассматривается
    COURT_STATUS_DONE // Рассмотрено
};

// Типы судебных решений
enum e_CourtDecision {
    COURT_CLASS_DECLINE, // Отклонение заявки
    COURT_CLASS_FREE_PAROLE, // УДО
    COURT_CLASS_PAROLE, // УДО + Залог
    COURT_CLASS_JAIL_REDUCE_PAROLE, // Сокращение срока в два раза + Залог
    COURT_CLASS_WORKING_OUT_PAROLE // УДО + Отработка
};

enum e_CourtInfo
{
    courtsPlayerId, // playerid Создателя заявки
    courtsTakeUserId, // playerid Судьи
    e_CourtStatus: courtsStatus, // Статус заявки
    e_CourtDecision: courtsDecision // Решение судебного заседания
}
new CourtInfo[MAX_COURT_OFFERS][e_CourtInfo];

// Судебные решения, закрепленные за игроком
enum e_PlayerCourtDecison {
    pcdID, // ID судебного решения
    pcdSuspectID, // ID аккаунта преступника
    pcdArbiterID, // ID аккаунта судьи
    pcdLawyerID, // ID аккаунта адвоката
    e_CourtDecision: pcdType, // Вынесенное решение
    pcdPrice, // Цена (Залог/Стоимость исправительных работ)
    pcdTime, // Время вынесения приговора (UNIX)
    pcdPeriod, // Количество назначенных дней (для запрета правонарушений / отработки долга)
    e_WantedInfo: pcdWantedInfo // Информация о статьях, которые были закреплены за игроком на момент вынесения приговора
};
new PlayerCourtDecision[MAX_REALPLAYERS][MAX_COURT_PLAYER_DECISIONS][e_PlayerCourtDecison];
new PlayerCourtDecisionWanted[MAX_REALPLAYERS][MAX_COURT_PLAYER_DECISIONS][e_WantedInfo];

// ============================================= Работа с судебными решениями =============================================

stock CreateJSONCourtWantedInfo(playerid, desicionid, &JsonNode: crimes) {
    #define info PlayerCourtDecisionWanted[playerid][desicionid]

    if (info[wanUnix] == 0 && info[wanTicketUnix] == 0) {
        crimes = JSON_INVALID_NODE;
        return 1;
    }

    for (new i = 0; i < MAX_CRIME_PLAYER; i++) {
        new JsonNode: crime_info = JSON_Object(
            "crime", JSON_Int(info[wanCrime][i]),
            "subentry", JSON_Int(info[wanSubentry][i]),
            "policeid", JSON_Int(info[wanPoliceId][i]),
            "unix", JSON_Int(info[wanUnix][i])
        );

        new JsonNode: ticket_info = JSON_Object(
            "crime", JSON_Int(info[wanTicketCrime][i]),
            "subentry", JSON_Int(info[wanTicketSubentry][i]),
            "policeid", JSON_Int(info[wanTicketPoliceId][i]),
            "unix", JSON_Int(info[wanTicketUnix][i])
        );
        
        new JsonNode: crime_json = JSON_Object(
            "crime", crime_info,
            "ticket", ticket_info
        );

        JSON_ArrayAppendEx(crimes, crime_json);
    }

    #undef info

    return 1;
}

stock LoadJSONCourtWantedInfo(playerid, desicionid, JsonNode: crimes) {
    if (crimes == JSON_INVALID_NODE) return 0;

    #define info PlayerCourtDecisionWanted[playerid][desicionid]

    new allWantedLen; JSON_ArrayLength(crimes, allWantedLen);
    for (new i = 0; i < allWantedLen; i++) {
        new JsonNode: curWanted;
        new JsonCallResult: res = JSON_ArrayObject(crimes, i, curWanted);
        if (res != JSON_CALL_NO_ERR) continue;

        new JsonNode: crime, JsonNode: ticket;
        JSON_GetArray(curWanted, "crime", crime);
        JSON_GetArray(curWanted, "ticket", ticket);

        new crimeLen; JSON_ArrayLength(crime, crimeLen);
        for (new index = 0; index < crimeLen; index++) {
            JSON_GetInt(crime, "crime", info[wanCrime][index]);
            JSON_GetInt(crime, "subentry", info[wanSubentry][index]);
            JSON_GetInt(crime, "policeid", info[wanPoliceId][index]);
            JSON_GetInt(crime, "unix", info[wanUnix][index]);

            JSON_GetInt(ticket, "crime", info[wanTicketCrime][index]);
            JSON_GetInt(ticket, "subentry", info[wanTicketSubentry][index]);
            JSON_GetInt(ticket, "policeid", info[wanTicketPoliceId][index]);
            JSON_GetInt(ticket, "unix", info[wanTicketUnix][index]);
        }
    }

    #undef info

    return 1;
}

stock CourtIsPlayerDesicionEnd(playerid, desicionid) {
    return gettime() >= (PlayerCourtDecision[playerid][desicionid][pcdTime] + PlayerCourtDecision[playerid][desicionid][pcdPeriod] * 86400);
}

function LoadPlayerCourtDesicionInfo(playerid, desicionid) {
    new rows;
    cache_get_field_count(rows);

    if (rows == 0) return 1;

    #define info PlayerCourtDecision[playerid][desicionid]

    // Загрузка основной информации
    cache_get_value_name_int(0, "id", info[pcdID]);
    cache_get_value_name_int(0, "suspect", info[pcdSuspectID]);
    cache_get_value_name_int(0, "arbiter", info[pcdArbiterID]);
    cache_get_value_name_int(0, "lawyer", info[pcdLawyerID]);
    cache_get_value_name_int(0, "type", info[pcdType]);
    cache_get_value_name_int(0, "price", info[pcdPrice]);
    cache_get_value_name_int(0, "time", info[pcdTime]);

    // Загрузка информации по статьям
    new wanted_info[1024], JsonNode: data;
    cache_get_value_name(0, "wanted", wanted_info);
    JSON_Parse(wanted_info, data);
    LoadJSONCourtWantedInfo(playerid, desicionid, data);

    #undef info

    return 1;
}

stock CourtGetFreePlayerDesicionSlot(playerid) {
    for (new = 0; i < MAX_COURT_PLAYER_DECISIONS; i++)
        if (PlayerCourtDecision[playerid][i][pcdID] < 1) return i;

    // TODO: Реализовать механизм стека, заменять более старые судебные решения новыми

    return -1;
}

// TODO: При заходе игрока проверять его судебные решения, и удалять все истекшие (CourtIsPlayerDesicionEnd)

// =================================================== Работа с судами ====================================================

// Перемещение игрока к скамье подсудимых
stock CourtMovePlayerToDock(playerid) {
    S_SetPlayerVirtualWorld(playerid, 172, 0);
    PPSetPlayerInterior(playerid, 0);
    PPSetPlayerPos(playerid, -2776.8091, 417.6989, 12.6403);
    PPSetPlayerFacingAngle(playerid, 90.0);
    return 1;
}

// Перемещение игрока к терминалу в тюрьме
stock CourtMovePlayerToTerminal(playerid) {
    S_SetPlayerVirtualWorld(playerid, WORLD_PRISON_CELLS, INT_PRISON_CELLS);
    PPSetPlayerInterior(playerid, INT_PRISON_CELLS);
    PPSetPlayerPos(playerid, 1032.6429, 2443.3469, 10.8509);
    PPSetPlayerFacingAngle(playerid, 120.0);
    return 1;
}

// Отправление сообщения всем находящемся в зале суда
stock CourtMessage(color, const message[]) {
    foreach (new playerid : Player) {
        if (!IsPlayerInRangeOfPoint(playerid, 150.0, -2776.8091, 417.6989, 12.6403)) continue; // Не в зале суда
        if (GetPlayerVirtualWorld(playerid) != 172) continue; // Не в правительстве
        
        SendClientMessage(playerid, color, message);
    }

    return 1;
}

// Получение данных о судебном деле
stock CourtGetProcessData(courtid, &prisonerid, &arbiterid, &e_CourtStatus: status, &e_CourtDecision: decision) {
    if (courtid < 0 || courtid > MAX_COURT_OFFERS) return 0;

    prisonerid = CourtInfo[courtid][courtsPlayerId];
    arbiterid = CourtInfo[courtid][courtsTakeUserId];
    status = CourtInfo[courtid][courtsStatus];
    decision = CourtInfo[courtid][courtsDecision];

    return 1;
}

// Начало судебного процесса
stock CourtStartProcess(playerid, targetid)
{
    CourtMovePlayerToDock(playerid);
    new courtid = OnlineInfo[playerid][oCourtsID] - 1;
    CourtInfo[courtid][courtsStatus] = COURT_STATUS_REVIEW;
    CourtInfo[courtid][courtsTakeUserId] = targetid;

    return courtid;
}

// Окончание судебного процесса, вынесение решения по делу
stock CourtCloseProcess(courtid, deposit = -1, period = -1)
{
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    CourtGetProcessData(courtid, prisonerid, arbiterid, courtStatus, courtDecision);

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
    OrgLog(7, "CourtCloseProcess", PlayerInfo[prisonerid][pID], PlayerInfo[prisonerid][pName], PlayerInfo[prisonerid][pPlaIP], PlayerInfo[arbiterid][pID], PlayerInfo[arbiterid][pName], PlayerInfo[arbiterid][pPlaIP], 0, log_message);
    CourtDeleteOrder(prisonerid);

    if (deposit > -1 && period > 0) {
        // TODO: Выдаем новое решение суда и записываем его в базу
    }

    return 1;
}

// Отображение диалога со списком активных судебных заседаний
stock CourtShowList(playerid)
{
    new line[100], lines[4048];
    format(line, sizeof(line),"№ Человек\tВремя заключения\tУровень Преступности\tСтатус"), strcat(lines, line);
    new quan,timemake[20],targetid;
    for(new z = 0; z < MAX_COURT_OFFERS; z++) 
    {
        targetid = CourtInfo[z][courtsPlayerId];
        timemake = fine_time(PlayerInfo[targetid][pJailTime]);

        if (PlayerInfo[targetid][pJailTime] < 600) continue;
        if (IsPlayerAfk(targetid)) continue;

        switch (CourtInfo[z][courtsStatus]) {
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

// Создание заявки на рассмотрение дела заключённого
stock CourtCreateOrder(playerid, bool: message = true)
{
    if(OnlineInfo[playerid][oCourtsID] > 0 && message) return ErrorMessage(playerid,"{ff6347}У вас уже есть активная заявка, ожидайте вызова в суд!");
    if(!(PlayerInfo[playerid][pJailTime] > 0 && PlayerInfo[playerid][pJailed] == 1)) return 0;
    new courtid = -1;
    for(new i; i < MAX_COURT_OFFERS; i++)
    {
        if(CourtInfo[i][courtsStatus] == COURT_STATUS_NONE)
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
    CourtInfo[courtid][courtsStatus] = COURT_STATUS_WAITING;
    PlayerInfo[playerid][pCourtsStatus] = 1;
    CourtInfo[courtid][courtsPlayerId] = playerid;
    OnlineInfo[playerid][oCourtsID] = courtid + 1;
    if(message == true) SuccessMessage(playerid,"{44ff99}Вы успешно отправили заявку в суд для рассмотрения дела");
    return 1;
}

// Удаление заявки на суд
stock CourtDeleteOrder(playerid)
{
    new courtid = OnlineInfo[playerid][oCourtsID] - 1;
    if (courtid < 0) return 1;

    OnlineInfo[playerid][oCourtsID] = 0;
    CourtInfo[courtid][courtsStatus] = COURT_STATUS_NONE;
    CourtInfo[courtid][courtsPlayerId] = 0;

    return 1;
}

// Отображение диалога для ввода суммы залога (количества дней*)
stock CourtEnterDeposit(courtid) {
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    CourtGetProcessData(courtid, prisonerid, arbiterid, courtStatus, courtDecision);

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

// Отображение диалога с возможными вариантами решений
stock CourtShowProcessAccept(courtid, deposit = -1, period = -1) {
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    CourtGetProcessData(courtid, prisonerid, arbiterid, courtStatus, courtDecision);

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

// Уведомление о вызове на суд
stock CourtShowArbiterOfferCall(courtid) {
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    CourtGetProcessData(courtid, prisonerid, arbiterid, courtStatus, courtDecision);

    #pragma unused courtStatus
    #pragma unused courtDecision

    if(IsPlayerAfk(prisonerid)) 
    {
        ErrorText(arbiterid, "{ff6347}Игрок в AFK, попробуйте чуть позже или выберите другую заявку");
        return CourtShowList(arbiterid);
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

// Выбор выносимого решения
stock CourtShowOfferReview(courtid) {
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    CourtGetProcessData(courtid, prisonerid, arbiterid, courtStatus, courtDecision);

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
                CourtInfo[courtid][courtsTakeUserId] = playerid;

                return CourtShowOfferReview(courtid);
            }
            else return pc_cmd_goverment(playerid);
        }
        case COURT_DIALOG_OFFER_DONE_INFO: {
            if (!response) return 1;
            return CourtShowList(playerid);
        }
        case COURT_DIALOG_OFFER_WAITING_INFO: {
            new courtid = DP[4][playerid];
            if (!response) return CourtShowOfferReview(courtid);
            
            DP[1][CourtInfo[courtid][courtsPlayerId]] = playerid;

            CourtShowArbiterOfferCall(courtid);
        }
        case COURT_DIALOG_OFFER_CALL: {
            if (response) return CourtStartProcess(playerid, DP[1][playerid]);

            CourtDeleteOrder(playerid);
            PlayerInfo[playerid][pCourtsStatus] = 0;
            SendClientMessage(DP[1][playerid], COLOR_GREY, "Заключенный %s отказался от рассмотрения дела", rpplayername(playerid));
        }
        case COURT_DIALOG_OFFER_REVIEW: {
            if (!response) return 1;

            new courtid = DP[4][playerid];
            if(courtid < 0 || courtid >= MAX_COURT_OFFERS) return false;
            if(CourtInfo[courtid][courtsStatus] != COURT_STATUS_REVIEW) return 0;
            new e_CourtDecision: courtDecision = CourtInfo[courtid][courtsDecision] = e_CourtDecision: listitem;

            if (courtDecision == COURT_CLASS_JAIL_REDUCE_PAROLE || courtDecision == COURT_CLASS_PAROLE || courtDecision == COURT_CLASS_WORKING_OUT_PAROLE) {
                return CourtEnterDeposit(courtid);
            }
            return CourtShowProcessAccept(courtid);
        }
        case COURT_DIALOG_ENTER_DEPOSIT: {
            new courtid = DP[4][playerid];
            if (!response) return CourtShowOfferReview(courtid);

            new deposit, period;
            if (!sscanf(inputtext, "dd", deposit, period)) {
                if (deposit >= COURT_MINIMAL_DEPOSIT && deposit <= COURT_MAXIMAL_DEPOSIT) {
                    if (period >= COURT_MINIMAL_PERIOD && period <= COURT_MAXIMAL_PERIOD) {
                        return CourtShowProcessAccept(courtid, deposit, period);
                    } else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Количество дней не меньше %d и не больше %d", COURT_MINIMAL_PERIOD, COURT_MAXIMAL_PERIOD);
                } else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сумма не меньше %s$ и не больше %s$", COURT_MINIMAL_DEPOSIT, COURT_MAXIMAL_DEPOSIT);
            }

            return CourtEnterDeposit(courtid);
        }
        case COURT_DIALOG_PROCESS_ACCEPT: {
            new courtid = DP[4][playerid];
            if (!response) return CourtShowOfferReview(courtid);

            new deposit = DP[5][playerid], period = DP[6][playerid];
            return CourtCloseProcess(courtid, deposit, period);
        }
    }

    return 1;
}
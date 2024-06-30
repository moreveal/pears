// ============================================= Работа с судебными решениями =============================================

stock CreateJSONCourtWantedInfo(playerid, decisionid, &JsonNode: crimes) {
    #define info PlayerCourtDecisionWanted[playerid][decisionid]

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

stock LoadJSONCourtWantedInfo(playerid, decisionid, JsonNode: crimes) {
    if (crimes == JSON_INVALID_NODE) return 0;

    #define info PlayerCourtDecisionWanted[playerid][decisionid]

    new index = -1; new JsonNode: curWanted = JSON_INVALID_NODE;
    while (!JSON_ArrayIterate(crimes, index, curWanted)) {
        if (index >= MAX_CRIME_PLAYER) break;

        new JsonNode: crime, JsonNode: ticket;
        JSON_GetObject(curWanted, "crime", crime);
        JSON_GetObject(curWanted, "ticket", ticket);

        JSON_GetInt(crime, "crime", info[wanCrime][index]);
        JSON_GetInt(crime, "subentry", info[wanSubentry][index]);
        JSON_GetInt(crime, "policeid", info[wanPoliceId][index]);
        JSON_GetInt(crime, "unix", info[wanUnix][index]);

        JSON_GetInt(ticket, "crime", info[wanTicketCrime][index]);
        JSON_GetInt(ticket, "subentry", info[wanTicketSubentry][index]);
        JSON_GetInt(ticket, "policeid", info[wanTicketPoliceId][index]);
        JSON_GetInt(ticket, "unix", info[wanTicketUnix][index]);
    }

    #undef info

    return 1;
}

stock CourtIsPlayerDecisionEnd(playerid, decisionid) {
    return  PlayerCourtDecision[playerid][decisionid][pcdTime] != 0 &&
            gettime() >= (PlayerCourtDecision[playerid][decisionid][pcdTime] + PlayerCourtDecision[playerid][decisionid][pcdPeriod] * 86400);
}

stock CourtSetCrimeFromDecision(playerid, decisionid) {
    #define info PlayerCourtDecisionWanted[playerid][decisionid]

    for (new i = 0; i < MAX_CRIME_PLAYER; i++) {
        if (info[wanUnix][i] == 0 && info[wanTicketUnix][i] == 0) continue;

        new uk = info[wanCrime][i] - 1, p = info[wanSubentry][i];
        SetPlayerCriminal(playerid, _:COP_TYPE_COURT, CriminalCodeInfo[uk][p][ccName], CriminalCodeInfo[uk][p][ccLevel], uk, p);
    }
    PlayerCourtDecision[playerid][decisionid][pcdWantedReturn] = true;

    #undef info

    return 1;
}

function LoadPlayerCourtDecisions(playerid, race_check) {
    new rows;
    cache_get_row_count(rows);

    if (rows == 0) return 1;
    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);

    #define info PlayerCourtDecision[playerid][slot]

    for (new i = 0; i < min(rows, MAX_COURT_PLAYER_DECISIONS); i++) {
        // Загрузка основной информации
        new slot = 0; cache_get_value_name_int(i, "slot", slot);

        cache_get_value_name_int(i, "suspect", info[pcdSuspectID]);
        cache_get_value_name_int(i, "arbiter", info[pcdArbiterID]);
        cache_get_value_name_int(i, "lawyer", info[pcdLawyerID]);
        cache_get_value_name_int(i, "type", info[pcdType]);
        cache_get_value_name_int(i, "deposit", info[pcdDeposit]);
        cache_get_value_name_int(i, "time", info[pcdTime]);
        cache_get_value_name_int(i, "period", info[pcdPeriod]);
        cache_get_value_name_int(i, "wanted_return", info[pcdWantedReturn]);

        // Если судебное решение истекло
        if (CourtIsPlayerDecisionEnd(playerid, slot)) {
            new notify_str[144];
            if (info[pcdType] == COURT_CLASS_WORKING_OUT_PAROLE) {
                // Возвращаем игроку прежний розыск, если он не успел отработать
                format(notify_str, sizeof(notify_str),
                    "Вы не успели отработать сумму, назначенную вам решением суда, за %d %s\nТеперь вы снова объявлены в розыск!",
                    info[pcdPeriod], PluralToText(info[pcdPeriod], "день", "дня", "дней")
                );
                notify(0, "", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], notify_str, .ingame_message = false);

                CourtSetCrimeFromDecision(playerid, slot);
            }

            // Удаляем решение
            CourtDeleteDecision(playerid, slot);
            continue;
        }

        // Загрузка информации по статьям
        new wanted_info[4096];
        new bool: is_null;
        cache_is_value_name_null(i, "wanted", is_null);

        if (!is_null) {
            cache_get_value_name(i, "wanted", wanted_info);

            new JsonNode: data = JSON_INVALID_NODE;
            if (JSON_Parse(wanted_info, data) == JSON_CALL_NO_ERR) {
                LoadJSONCourtWantedInfo(playerid, slot, data);
            }
        }
    }

    #undef info

    return 1;
}

stock SavePlayerCourtDecisions(playerid) {
    new mysql_string[4096];
    
    mysql_tquery(pearsq, "START TRANSACTION;");

    new JsonNode: crimes = JSON_Array(), wanted_json[4096];
    for (new decisionid = 0; decisionid < MAX_COURT_PLAYER_DECISIONS; decisionid++) {
        if (!PlayerCourtDecision[playerid][decisionid][pcdType]) continue;
        
        CreateJSONCourtWantedInfo(playerid, decisionid, crimes);

        if (crimes != JSON_INVALID_NODE) {
            if (JSON_Stringify(crimes, wanted_json) == JSON_CALL_NO_ERR) {
                mysql_format(pearsq, mysql_string, sizeof(mysql_string),
                    "REPLACE INTO `court_decisions` \
                    (`slot`, `suspect`, `arbiter`, `lawyer`, `type`, `deposit`, `time`, `period`, `wanted_return`, `wanted`) \
                    VALUES (%d, %d, %d, %d, %d, %d, %d, %d, %d, '%e');", \
                    \
                    decisionid,
                    PlayerCourtDecision[playerid][decisionid][pcdSuspectID],
                    PlayerCourtDecision[playerid][decisionid][pcdArbiterID],
                    PlayerCourtDecision[playerid][decisionid][pcdLawyerID],
                    _:PlayerCourtDecision[playerid][decisionid][pcdType],
                    PlayerCourtDecision[playerid][decisionid][pcdDeposit],
                    PlayerCourtDecision[playerid][decisionid][pcdTime],
                    PlayerCourtDecision[playerid][decisionid][pcdPeriod],
                    PlayerCourtDecision[playerid][decisionid][pcdWantedReturn],
                    wanted_json
                );
                query_empty(pearsq, mysql_string);
            }
        }
    }

    mysql_tquery(pearsq, "COMMIT;");
}

// Возвращаем ближайший свободный слот
// Если все слоты заняты, берём и заменяем тот, который хранит в себе наименьшее количество долга
stock CourtGetFreePlayerDecisionSlot(playerid) {
    for (new slot = 0, i = 0; i < MAX_COURT_PLAYER_DECISIONS; i++) {
        if (PlayerCourtDecision[playerid][i][pcdDeposit] < PlayerCourtDecision[playerid][slot][pcdDeposit])
            slot = i;

        if (i == MAX_COURT_PLAYER_DECISIONS - 1 // Последняя итерация
        || PlayerCourtDecision[playerid][slot][pcdDeposit] <= 0 // Нулевая сумма залога / отработки
        || CourtIsPlayerDecisionEnd(playerid, slot)) return slot; // Истекший срок
    }

    return 0;
}

// Узнает, является ли указанный decisionid свободным для игрока
stock CourtIsFreePlayerDecisionSlot(playerid, decisionid) {
    if (decisionid < 0 || decisionid >= MAX_COURT_PLAYER_DECISIONS) return 0;
    return PlayerCourtDecision[playerid][decisionid][pcdDeposit] <= 0 && PlayerCourtDecision[playerid][decisionid][pcdTime] <= 0;
}

// Выносит судебное решение для указанного игрока
stock CourtCreateDecision(playerid, arbiterid, lawyerid, e_CourtDecision: type, deposit, period) {
    if (deposit < 0 || period < COURT_MINIMAL_PERIOD) return 1;
    #pragma unused lawyerid // Временно, т.к. не реализована система для адвокатов
    
    new decisionid = CourtGetFreePlayerDecisionSlot(playerid);

    // Основные данные
    PlayerCourtDecision[playerid][decisionid][pcdSuspectID] = PlayerInfo[playerid][pID];
    PlayerCourtDecision[playerid][decisionid][pcdArbiterID] = PlayerInfo[arbiterid][pID];
    PlayerCourtDecision[playerid][decisionid][pcdLawyerID] = 0;
    PlayerCourtDecision[playerid][decisionid][pcdType] = type;
    PlayerCourtDecision[playerid][decisionid][pcdDeposit] = deposit;
    PlayerCourtDecision[playerid][decisionid][pcdTime] = gettime();
    PlayerCourtDecision[playerid][decisionid][pcdPeriod] = period;
    
    // Данные о текущем розыске
    for (new i = 0; i < MAX_CRIME_PLAYER; i++) {
        PlayerCourtDecisionWanted[playerid][decisionid][wanCrime][i] = WantedInfo[playerid][wanCrime][i];
        PlayerCourtDecisionWanted[playerid][decisionid][wanSubentry][i] = WantedInfo[playerid][wanSubentry][i];
        PlayerCourtDecisionWanted[playerid][decisionid][wanPoliceId][i] = WantedInfo[playerid][wanPoliceId][i];
        PlayerCourtDecisionWanted[playerid][decisionid][wanUnix][i] = WantedInfo[playerid][wanUnix][i];

        PlayerCourtDecisionWanted[playerid][decisionid][wanTicketCrime][i] = WantedInfo[playerid][wanTicketCrime][i];
        PlayerCourtDecisionWanted[playerid][decisionid][wanTicketSubentry][i] = WantedInfo[playerid][wanTicketSubentry][i];
        PlayerCourtDecisionWanted[playerid][decisionid][wanTicketPoliceId][i] = WantedInfo[playerid][wanTicketPoliceId][i];
        PlayerCourtDecisionWanted[playerid][decisionid][wanTicketUnix][i] = WantedInfo[playerid][wanTicketUnix][i];
    }

    return decisionid;
}

// Удаляет указанное судебное решение
stock CourtDeleteDecision(playerid, decisionid) {
    PlayerCourtDecision[playerid][decisionid][pcdType] = COURT_CLASS_NONE;
    PlayerCourtDecision[playerid][decisionid][pcdDeposit] = 0;
    PlayerCourtDecision[playerid][decisionid][pcdTime] = 0;

    return 1;
}

// Возвращает общую сумму долга для отработок
stock CourtGetWorkoutDeposit(playerid) {
    new deposit = 0;
    for (new i = 0; i < MAX_COURT_PLAYER_DECISIONS; i++) {
        if (PlayerCourtDecision[playerid][i][pcdType] != COURT_CLASS_WORKING_OUT_PAROLE) continue;
        deposit += PlayerCourtDecision[playerid][i][pcdDeposit];
    }
    return deposit;
}

// Вычитает необходимую сумму из общей суммы долгов
stock CourtSubtractWorkoutDeposit(playerid, deposit) {
    new slot;
    for (new i = 0; i < MAX_COURT_PLAYER_DECISIONS; i++) {
        if (PlayerCourtDecision[playerid][i][pcdType] != COURT_CLASS_WORKING_OUT_PAROLE || CourtIsFreePlayerDecisionSlot(playerid, i)) continue;
        if (PlayerCourtDecision[playerid][i][pcdDeposit] == 0) continue;

        if (PlayerCourtDecision[playerid][i][pcdDeposit] <= PlayerCourtDecision[playerid][slot][pcdDeposit])
            slot = i + 1;
    }

    slot--;
    if (slot > -1) {
        if (deposit > PlayerCourtDecision[playerid][slot][pcdDeposit]) {
            deposit -= PlayerCourtDecision[playerid][slot][pcdDeposit];
            PlayerCourtDecision[playerid][slot][pcdDeposit] = 0;
            CourtDeleteDecision(playerid, slot); // Закрываем судебное решение после выплаты
            return CourtSubtractWorkoutDeposit(playerid, deposit);
        } else {
            PlayerCourtDecision[playerid][slot][pcdDeposit] -= deposit;
        }
    }

    // Возвращаем общую сумму для выплаты
    return CourtGetWorkoutDeposit(playerid);
}

// Получает decisionid самого нового решения (-1 - не найдено)
stock CourtGetNewestPlayerDecision(playerid, startid = 0) {
    new slot;
    for (new i = startid; i < MAX_COURT_PLAYER_DECISIONS; i++) {
        if (PlayerCourtDecision[playerid][slot][pcdTime] == 0) continue;
        
        if (PlayerCourtDecision[playerid][i][pcdTime] >= PlayerCourtDecision[playerid][slot][pcdTime])
            slot = i + 1;
    }

    return slot - 1;
}

// Узнает, является ли переданный тип судебного решения выпусканием по УДО
stock CourtIsParoleType(e_CourtDecision: type) {
    return type == COURT_CLASS_FREE_PAROLE || type == COURT_CLASS_PAROLE || type == COURT_CLASS_WORKING_OUT_PAROLE || type == COURT_CLASS_JAIL_REDUCE_PAROLE;
}

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
stock CourtGetProcessData(courtofferid, &prisonerid, &arbiterid, &e_CourtStatus: status, &e_CourtDecision: decision) {
    if (courtofferid < 0 || courtofferid > MAX_COURT_OFFERS) return 0;

    prisonerid = CourtInfo[courtofferid][ciPlayerID];
    arbiterid = CourtInfo[courtofferid][ciTakeUserID];
    status = CourtInfo[courtofferid][ciStatus];
    decision = CourtInfo[courtofferid][ciDecision];

    return 1;
}

// Начало судебного процесса
stock CourtStartProcess(playerid, targetid)
{
    CourtMovePlayerToDock(playerid);
    new courtofferid = OnlineInfo[playerid][oCourtsID] - 1;
    CourtInfo[courtofferid][ciStatus] = COURT_STATUS_REVIEW;
    CourtInfo[courtofferid][ciTakeUserID] = targetid;

    return courtofferid;
}

// Окончание судебного процесса, вынесение решения по делу
stock CourtCloseProcess(courtofferid, deposit = -1, period = -1)
{
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    CourtGetProcessData(courtofferid, prisonerid, arbiterid, courtStatus, courtDecision);

    if(courtStatus != COURT_STATUS_REVIEW) return 0;

    PlayerInfo[prisonerid][pCourtsStatus] = 0;
    if (deposit > -1 && period > -1) {
        // Создаем и закрепляем за игроком судебное решение
        CourtCreateDecision(prisonerid, arbiterid, 0, courtDecision, deposit, period);

        // Помещаем залог в казну
        if (courtDecision != COURT_CLASS_WORKING_OUT_PAROLE)
            putkazna(0, deposit);
    }

    new log_message[64], court_message[512];
    new pretty_deposit[30]; format(pretty_deposit, sizeof(pretty_deposit), "%s", FormatNumberWithCommas(deposit));
    new pretty_period[10]; format(pretty_period, sizeof(pretty_period), "%d %s", period, PluralToText(period, "день", "дня", "дней"));

    if(courtDecision != COURT_CLASS_DECLINE && courtDecision != COURT_CLASS_JAIL_REDUCE_PAROLE)
    {
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
                    "Судья назначил вам срок исправления размером в %s.\n" \
                    "Если в течение этого времени вы совершите правонарушение - вы вновь будете объявлены в розыск по предыдущим статьям"
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
            new text[512];
            format(text, sizeof(text),
                "{44ff99}Вас отпустили по УДО и назначали исправительные работы. Вы обязаны их отработать.\
                \n{cccccc}Сумма исправительных работ: %s$\
                \
                \n\nВ случае неотработки работ в течение %s, или в случае совершения правонарушения, вы снова будете объявлены в розыск\
                \
                \n\n{684F7D}Отработать нужно на работе в Клининговой Компании\
                \n{684F7D}Посмотреть сумму отработки можно в Банке", \
                \
                pretty_deposit,
                pretty_period
            );
            SuccessMessage(prisonerid, text);

            format(log_message, sizeof(log_message), "Отпустил по УДО [Сумма отработки: %d$ | Срок: %s]", deposit, pretty_period);
            format(court_message, sizeof(court_message), "* Судья %s отпустил заключённого %s по УДО {99ff66}[Сумма отработки: %s$ | Срок: %s]", rpplayername(arbiterid), rpplayername(prisonerid), pretty_deposit, pretty_period);
        }
        default: {}
    }
    CourtMessage(COLOR_GREY, court_message);

    GiveUnit(arbiterid, 13);
    OrgLog(7, "CourtCloseProcess", PlayerInfo[prisonerid][pID], PlayerInfo[prisonerid][pName], PlayerInfo[prisonerid][pPlaIP], PlayerInfo[arbiterid][pID], PlayerInfo[arbiterid][pName], PlayerInfo[arbiterid][pPlaIP], 0, log_message);
    CourtDeleteOrder(prisonerid);

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
        targetid = CourtInfo[z][ciPlayerID];
        timemake = fine_time(PlayerInfo[targetid][pJailTime]);

        if (PlayerInfo[targetid][pJailTime] < COURT_MINIMAL_JAILTIME) continue;
        if (IsPlayerAfk(targetid)) continue;

        switch (CourtInfo[z][ciStatus]) {
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
    if (message) {
        if (PlayerInfo[playerid][pJailTime] < COURT_MINIMAL_JAILTIME) return ErrorMessage(playerid, "{ff6347}Вам осталось совсем немного для конца заключения");
        if (OnlineInfo[playerid][oCourtsID] > 0) return ShowDialog(playerid, _:COURT_DIALOG_CANCEL_OFFER, DIALOG_STYLE_MSGBOX, "{cccccc}Заявка в суд", "{ff6347}У вас уже есть активная заявка в суд, желаете её отменить?", "Да", "Закрыть");
    }

    if(!(PlayerInfo[playerid][pJailTime] > 0 && PlayerInfo[playerid][pJailed] == 1)) return 0;
    new courtofferid = -1;
    for(new i; i < MAX_COURT_OFFERS; i++)
    {
        if(CourtInfo[i][ciStatus] == COURT_STATUS_NONE)
        {
            courtofferid = i;
            break;
        }
    }
    if(courtofferid == -1)
    {
        if(message == true) ErrorMessage(playerid,"{ff6347}В данный момент нельзя создать заявку в суд [ Количество максимальных заявок превышено ]");
        return 1;
    }
    CourtInfo[courtofferid][ciStatus] = COURT_STATUS_WAITING;
    PlayerInfo[playerid][pCourtsStatus] = 1;
    CourtInfo[courtofferid][ciPlayerID] = playerid;
    OnlineInfo[playerid][oCourtsID] = courtofferid + 1;
    if(message == true) SuccessMessage(playerid,"{44ff99}Вы успешно отправили заявку в суд для рассмотрения дела");
    return 1;
}

// Удаление заявки на суд
stock CourtDeleteOrder(playerid)
{
    new courtofferid = OnlineInfo[playerid][oCourtsID] - 1;
    if (courtofferid < 0) return 1;

    OnlineInfo[playerid][oCourtsID] = 0;
    CourtInfo[courtofferid][ciStatus] = COURT_STATUS_NONE;
    CourtInfo[courtofferid][ciPlayerID] = 0;

    return 1;
}

// Отображение диалога для ввода суммы залога (количества дней*)
stock CourtEnterDeposit(courtofferid) {
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    CourtGetProcessData(courtofferid, prisonerid, arbiterid, courtStatus, courtDecision);

    #pragma unused courtStatus

    new dialog_text[512], dialog_header[64];
    if (courtDecision == COURT_CLASS_PAROLE || courtDecision == COURT_CLASS_JAIL_REDUCE_PAROLE) {
        format(dialog_text, sizeof(dialog_text),
            "{ffffff}Укажите сумму для залога {99ff66}(%s$ - %s$)\n" \
            "{ffffff}Доступная сумма на руках у заключённого: {99ff66}%s$\n\n{ffffff}" \
            \
            "Указанная вами сумма будет начислена на счёт казны\n" \
            "Если заключённый совершит правонарушение в указанный срок, он вновь будет объявлен в розыск по предыдущим статьям\n\n" \
            \
            "{cccccc}Укажите данные через пробел: Сумма, Количество дней (%d - %d)",

            FormatNumberWithCommas(COURT_MINIMAL_DEPOSIT), FormatNumberWithCommas(COURT_MAXIMAL_DEPOSIT),
            FormatNumberWithCommas(PlayerInfo[prisonerid][pMoney]),
            COURT_MINIMAL_PERIOD, COURT_MAXIMAL_PERIOD
        );
        strcat(dialog_header, "{ff9000}Назначение суммы залога");
    } else if (courtDecision == COURT_CLASS_WORKING_OUT_PAROLE) {
        format(dialog_text, sizeof(dialog_text),
            "{ffffff}Укажите сумму для отработки {99ff66}(%s$ - %s$)\n" \
            "{ffffff}Доступная сумма на руках у заключённого: {99ff66}%s$\n\n{ffffff}" \
            \
            "Указанная вами сумма будет начислена на счёт казны\n" \
            "Если заключённый не успеет отработать эту сумму в указанный срок, он вновь будет объявлен в розыск по предыдущим статьям\n\n" \
            \
            "{cccccc}Укажите данные через пробел: Сумма, Количество дней (%d - %d)",

            FormatNumberWithCommas(COURT_MINIMAL_DEPOSIT), FormatNumberWithCommas(COURT_MAXIMAL_DEPOSIT),
            FormatNumberWithCommas(PlayerInfo[prisonerid][pMoney]),
            COURT_MINIMAL_PERIOD, COURT_MAXIMAL_PERIOD
        );
        strcat(dialog_header, "{ff9000}Назначение суммы отработки");
    }

    return ShowDialog(arbiterid, COURT_DIALOG_ENTER_DEPOSIT, DIALOG_STYLE_INPUT, "{ff9000}Назначение суммы залога", dialog_text, "Принять", "Назад");
}

// Отображение диалога с возможными вариантами решений
stock CourtShowProcessAccept(courtofferid, deposit = -1, period = -1) {
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    CourtGetProcessData(courtofferid, prisonerid, arbiterid, courtStatus, courtDecision);

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
stock CourtShowArbiterOfferCall(courtofferid) {
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    CourtGetProcessData(courtofferid, prisonerid, arbiterid, courtStatus, courtDecision);

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
stock CourtShowOfferReview(courtofferid) {
    new prisonerid, arbiterid, e_CourtStatus: courtStatus, e_CourtDecision: courtDecision;
    CourtGetProcessData(courtofferid, prisonerid, arbiterid, courtStatus, courtDecision);

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
                new courtofferid = DP[4][playerid] = List[listitem][playerid];
                CourtInfo[courtofferid][ciTakeUserID] = playerid;

                return CourtShowOfferReview(courtofferid);
            }
            else return pc_cmd_goverment(playerid);
        }
        case COURT_DIALOG_OFFER_DONE_INFO: {
            if (!response) return 1;
            return CourtShowList(playerid);
        }
        case COURT_DIALOG_OFFER_WAITING_INFO: {
            new courtofferid = DP[4][playerid];
            if (!response) return CourtShowList(courtofferid);
            
            DP[1][CourtInfo[courtofferid][ciPlayerID]] = playerid;

            CourtShowArbiterOfferCall(courtofferid);
        }
        case COURT_DIALOG_OFFER_CALL: {
            if (response) return CourtStartProcess(playerid, DP[1][playerid]);

            CourtDeleteOrder(playerid);
            PlayerInfo[playerid][pCourtsStatus] = 0;
            SendClientMessage(DP[1][playerid], COLOR_GREY, "Заключенный %s отказался от рассмотрения дела", rpplayername(playerid));
        }
        case COURT_DIALOG_OFFER_REVIEW: {
            if (!response) return 1;

            new courtofferid = DP[4][playerid];
            if(courtofferid < 0 || courtofferid >= MAX_COURT_OFFERS) return false;
            if(CourtInfo[courtofferid][ciStatus] != COURT_STATUS_REVIEW) return 0;
            new e_CourtDecision: courtDecision = CourtInfo[courtofferid][ciDecision] = e_CourtDecision: listitem;

            if (courtDecision == COURT_CLASS_JAIL_REDUCE_PAROLE || courtDecision == COURT_CLASS_PAROLE || courtDecision == COURT_CLASS_WORKING_OUT_PAROLE) {
                return CourtEnterDeposit(courtofferid);
            }
            return CourtShowProcessAccept(courtofferid);
        }
        case COURT_DIALOG_ENTER_DEPOSIT: {
            new courtofferid = DP[4][playerid];
            if (!response) return CourtShowOfferReview(courtofferid);

            new deposit, period;
            if (!sscanf(inputtext, "dd", deposit, period)) {
                if (deposit >= COURT_MINIMAL_DEPOSIT && deposit <= COURT_MAXIMAL_DEPOSIT) {
                    if (period >= COURT_MINIMAL_PERIOD && period <= COURT_MAXIMAL_PERIOD) {
                        return CourtShowProcessAccept(courtofferid, deposit, period);
                    } else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Количество дней не меньше %d и не больше %d", COURT_MINIMAL_PERIOD, COURT_MAXIMAL_PERIOD);
                } else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сумма не меньше %s$ и не больше %s$", COURT_MINIMAL_DEPOSIT, COURT_MAXIMAL_DEPOSIT);
            }

            return CourtEnterDeposit(courtofferid);
        }
        case COURT_DIALOG_PROCESS_ACCEPT: {
            new courtofferid = DP[4][playerid];
            if (!response) return CourtShowOfferReview(courtofferid);

            new deposit = DP[5][playerid], period = DP[6][playerid];
            return CourtCloseProcess(courtofferid, deposit, period);
        }
        case COURT_DIALOG_CANCEL_OFFER: {
            if (!response) return 1;

            CourtDeleteOrder(playerid);
            SuccessMessage(playerid, "{99ff66}Вы успешно удалили заявку!");
        }
    }

    return 1;
}
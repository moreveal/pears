
//=================================================================
//======================= Личная Гонка ============================
//=================================================================

#define MAX_PLAYER_RACE_POINT 100
new Float:RacePointPlayer_X[MAX_REALPLAYERS][MAX_PLAYER_RACE_POINT];
new Float:RacePointPlayer_Y[MAX_REALPLAYERS][MAX_PLAYER_RACE_POINT];
new Float:RacePointPlayer_Z[MAX_REALPLAYERS][MAX_PLAYER_RACE_POINT];
new RacePointPlayerQuan[MAX_REALPLAYERS];
new RacePickupCheckStatus[MAX_REALPLAYERS];

// Загружаем поинты гонки для игрока (общая система личных поинтов)
stock CreatePlayerRacePoint(playerid, raceid, typerace)
{
    OnlineInfo[playerid][oStatusRace] = raceid; // Статус запущенного маршрута
    OnlineInfo[playerid][oQuanPointRace] = 0; // Сбрасываем поинты
    OnlineInfo[playerid][oTypeRace] = typerace; // Тип гонки (0 обычная, 1 для самолётов)
    OnlineInfo[playerid][oTimerStartRace] = 0; // Сбрасываем таймер для отсчёта старта гонки

    // Гонка с домиником
    new pointQuan;
    if(raceid == 1)
    {
        for(new i = 0; i < sizeof(DominicRace_One); i++)
        {
            RacePointPlayer_X[playerid][i] = DominicRace_One[i][Dominic_X];
            RacePointPlayer_Y[playerid][i] = DominicRace_One[i][Dominic_Y];
            RacePointPlayer_Z[playerid][i] = DominicRace_One[i][Dominic_Z];
            pointQuan ++;
        }
    }
    else if(raceid == 2)
    {
        for(new i = 0; i < sizeof(DominicRace_Two); i++)
        {
            RacePointPlayer_X[playerid][i] = DominicRace_Two[i][Dominic_X];
            RacePointPlayer_Y[playerid][i] = DominicRace_Two[i][Dominic_Y];
            RacePointPlayer_Z[playerid][i] = DominicRace_Two[i][Dominic_Z];
            pointQuan ++;
        }
    }
    else if(raceid == 3)
    {
        for(new i = 0; i < sizeof(DominicRace_Three); i++)
        {
            RacePointPlayer_X[playerid][i] = DominicRace_Three[i][Dominic_X];
            RacePointPlayer_Y[playerid][i] = DominicRace_Three[i][Dominic_Y];
            RacePointPlayer_Z[playerid][i] = DominicRace_Three[i][Dominic_Z];
            pointQuan ++;
        }
    }
    /*
    Сюда добавлять дальше другие маршруты и гонки (система всё расчитает и четко отработает)
    else if(raceid == 1)
    {
    }
    */
    RacePointPlayerQuan[playerid] = pointQuan; // Записываем количество поинтов на маршруте гонки
    return 1;
}

// Даём старт гонке
stock StartRacePlayer(playerid)
{
    if(OnlineInfo[playerid][oStatusRace] == 0) return 1;
    TogglePlayerControllable(playerid, false); // Временно морозим игрока
    OnlineInfo[playerid][oTimerStartRace] = 4; // Отсчёт для старта гонки
    return 1;
}

// Процесс таймера для старта гонки
stock ProcessStartRacePlayer(playerid)
{
    OnlineInfo[playerid][oTimerStartRace] --;
    if(OnlineInfo[playerid][oTimerStartRace] > 0)
    {
        new string[6];
        format(string,sizeof(string),"~y~%d", OnlineInfo[playerid][oTimerStartRace]);
        GameTextForPlayer(playerid, string, 2000, 6);
        PlayerPlaySound(playerid,1056,0,0,0);
    }
    else
    {
        RacePickupCheckStatus[playerid] = 0; // Сбрасываем шняги для проверки активности гонки
        OnlineInfo[playerid][oTimerStartRace] = -1; // Информация о том, что старт был дан и гонка уже идёт
        TogglePlayerControllable(playerid, true); // Размораживаем челика
        GameTextForPlayer(playerid, "~g~GO!", 2000, 6);
        PlayerPlaySound(playerid,3201,0,0,0);
        ShowRaceCheckpoint(playerid); // Отображаем поинты, куда надо ехать

        // Запускаем доминика
        if(OnlineInfo[playerid][oDominicRace] > 0) Dominic_StartRace(NPCInfo[5][npcID]);

        // Сюда можно добавлять другие обработчики для старта гонок
    }
    return 1;
}

// Проверяем процесс активности гонки (вдруг игрок отошёл или встал в афк)
stock ProcessCheckRacePlayer(playerid)
{
    RacePickupCheckStatus[playerid] ++;
    if(RacePickupCheckStatus[playerid] >= 60) // Игрок в течении минуты не подбирал чекпоинты (значит сбрасываем гонку)
    {
        ClearPlayerRace(playerid);

        ErrorMessage(playerid, "{FF6347}Маршрут или активная гонка была отключена\n{ffcc66}Вы не подбирали чекпоинты маршрута в течении минуты");
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не выполнял%s маршрут и для меня гонка завершилась", gender(playerid));
    }
    return 1;
}

// Подбираем чекпоинт во время гонки
stock PickupRaceCheckpoint(playerid)
{
    if(OnlineInfo[playerid][oTimerStartRace] > 0) return 1; // Блокируем подбор поинтов во время отсчёта

    new i = OnlineInfo[playerid][oQuanPointRace]; // Текущий поинт
    if(IsPlayerInRangeOfPoint(playerid,10.0, RacePointPlayer_X[playerid][i], RacePointPlayer_Y[playerid][i], RacePointPlayer_Z[playerid][i]))
    {
        RacePickupCheckStatus[playerid] = 0;
        PlayerPlaySound(playerid,1150,0,0,0);
	    DisablePlayerRaceCheckpoint(playerid);

        OnlineInfo[playerid][oQuanPointRace] ++; // Считаем поинты
        if(OnlineInfo[playerid][oQuanPointRace] >= RacePointPlayerQuan[playerid]) // Приехали на последний поинт
        {
            ClearPlayerRace(playerid); // Очищаем гонку
            if(OnlineInfo[playerid][oDominicRace] > 0) Dominic_FinishPlayer(playerid); // Инфа о том, что мы выиграли гонку
        }
        else ShowRaceCheckpoint(playerid); // Отображаем следующий RaceCheckPoint
    }
    return 1;
}

// Отображаем следующий чекпоинт
stock ShowRaceCheckpoint(playerid)
{
    new i = OnlineInfo[playerid][oQuanPointRace]; // Текущий поинт
    if(i + 1 >= RacePointPlayerQuan[playerid]) // Финиш
    {
        new typeRace;
        if(OnlineInfo[playerid][oTypeRace] == 0) typeRace = 1; // Обычная
        else typeRace = 4; // Самолёты
        SetPlayerRaceCheckpoint(playerid,CP_TYPE:typeRace,RacePointPlayer_X[playerid][i], RacePointPlayer_Y[playerid][i], RacePointPlayer_Z[playerid][i], 0.0, 0.0, 0.0,7.0);
    }
    else
    {
        new typeRace;
        if(OnlineInfo[playerid][oTypeRace] == 0) typeRace = 0; // Обычная
        else typeRace = 3; // Самолёты
        SetPlayerRaceCheckpoint(playerid,CP_TYPE:typeRace, RacePointPlayer_X[playerid][i], RacePointPlayer_Y[playerid][i], RacePointPlayer_Z[playerid][i], RacePointPlayer_X[playerid][i + 1], RacePointPlayer_Y[playerid][i + 1], RacePointPlayer_Z[playerid][i + 1],7.0);
    }
    return 1;
}

// Очищаем гонку
stock ClearPlayerRace(playerid, bool:clear = true)
{
    if(OnlineInfo[playerid][oStatusRace] > 0)
    {
        DisablePlayerRaceCheckpoint(playerid);
        OnlineInfo[playerid][oStatusRace] = 0;
        OnlineInfo[playerid][oTimerStartRace] = 0;
    }

    // Финиш в гонке с домиником
    if(clear == true && OnlineInfo[playerid][oDominicRace] > 0 && playerid == DominicPlayeridRace) Dominic_ExtPlayerRace();

    // Сюда дальше можно добавлять другие обработчики финиширования в системах
    return 1;
}



// Отображаем последний чекпоинт доминику для гонки
stock Dominic_ShowLastPoint(playerid, botid)
{
    new i = RacePointPlayerQuan[playerid] - 1;
    SetPlayerRaceCheckpoint(botid,CP_TYPE:1,RacePointPlayer_X[playerid][i], RacePointPlayer_Y[playerid][i], RacePointPlayer_Z[playerid][i], 0.0, 0.0, 0.0,7.0);
    return 1;
}


#define MAX_CELL_PRISON 8

new Kpz[MAX_CELL_PRISON]; // id объектов дверей
new KpzDoorStatus[MAX_CELL_PRISON]; // статус дверей
new KpzDoorStatusBreaking[MAX_CELL_PRISON]; // Статус взлома дверей
new OpenCells[2]; // какая сторона камер открыта
new PrisonAlarm; // Статус тревоги в тюрьме
new PrisonAlarmCD; // Кд для запуска тревоги
new PrisonAlarmTime; // Время для автоматического отключения тревоги
new PrisonAlarmObject[2]; // id объектов красной лампы тревоги
new PrisonTabloObject[2]; // id объектов табло оповещения в тюрьме
new OpenBlock[2]; // Какая часть тюрьмы сейчас доступна для посещения
new BlockDoorPrison[3]; // Двери внутри тюрьмы (Блоки)
new BlockDoorPrisonStatus[3]; // Статус дверей тюрьмы (блоки)
new PrisonPoster[MAX_CELL_PRISON];
new PrisonSand[MAX_CELL_PRISON];
new PrisonBeton[MAX_CELL_PRISON];
new PrisonBetonHP[MAX_CELL_PRISON];
new PrisonSandStatus[MAX_CELL_PRISON];
new PrisonPosterStatus[MAX_CELL_PRISON];

stock ReopenPrison(side) // Каждые 10 минут переключаем стороны блоков
{
    if(PrisonAlarm == 1) return 1; // Если включена тревога, мы не меняем никакие стороны

    if(side == 0) 
    {
        OpenPrisonCells(0); // Открываем левые камеры
        SwitchPrisonBlock(0); // Открываем блок с кухней, улкой и прачкой
    }
    else 
    {
        OpenPrisonCells(1); // Открываем правые камеры
        SwitchPrisonBlock(1); // Открываем блок с изолятором, рабочей зоной и игровой
    }
    return 1;
}

stock SwitchPrisonBlock(block)
{
    if(block == 0)
    {
        OpenBlock[0] = 1;
        OpenBlock[1] = 0;
        OpenBlockDoorPrison(0);
        OpenBlockDoorPrison(1);
        CloseBlockDoorPrison(2);
        UpdateTabloPrisonInfo(0, 20);
        UpdateTabloPrisonInfo(1, 10);
    }
    else
    {
        OpenBlock[0] = 0;
        OpenBlock[1] = 1;
        CloseBlockDoorPrison(0);
        CloseBlockDoorPrison(1);
        OpenBlockDoorPrison(2);
        UpdateTabloPrisonInfo(0, 10);
        UpdateTabloPrisonInfo(1, 20);
    }
    return 1;
}
stock OpenBlockDoorPrison(blockdoor)
{
    if(BlockDoorPrisonStatus[blockdoor] == 1) return 1; // Дверь уже открыта
    if(blockdoor == 0) MoveDynamicObject(BlockDoorPrison[0], 1070.021606, 2451.000244, 11.100864, 1.5);
    else if(blockdoor == 1) MoveDynamicObject(BlockDoorPrison[1], 1060.468505, 2450.999267, 11.100864, 1.5);
    else if(blockdoor == 2) MoveDynamicObject(BlockDoorPrison[2], 1031.276977, 2445.879882, 11.100864, 1.5);
    BlockDoorPrisonStatus[blockdoor] = 1;
    return 1;
}
stock CloseBlockDoorPrison(blockdoor)
{
    if(BlockDoorPrisonStatus[blockdoor] == 0) return 1; // Дверь уже закрыта
    if(blockdoor == 0) MoveDynamicObject(BlockDoorPrison[0], 1070.021606, 2449.308593, 11.100864, 1.5);
    else if(blockdoor == 1) MoveDynamicObject(BlockDoorPrison[1], 1060.468505, 2449.308593, 11.100864, 1.5);
    else if(blockdoor == 2) MoveDynamicObject(BlockDoorPrison[2], 1031.276977, 2447.560791, 11.100864, 1.5);
    BlockDoorPrisonStatus[blockdoor] = 0;
    return 1;
}
stock SwitchPrisonBlockDoor(blockdoor) // Переключаем состояние двери блоков
{
    if(BlockDoorPrisonStatus[blockdoor] == 1) CloseBlockDoorPrison(blockdoor);
    else OpenBlockDoorPrison(blockdoor);
    return 1;
}
stock IsPlayerBlockDoorNearby(playerid) // Получаем номер камеры, у которой стоим
{
    if(GetPlayerVirtualWorld(playerid) == WORLD_PRISON_CELLS && GetPlayerInterior(playerid) == INT_PRISON_CELLS)
    {
        if(IsPlayerInRangeOfPoint(playerid,2.0, 1070.021606, 2449.308593, 11.100864)) return 1;
        else if(IsPlayerInRangeOfPoint(playerid,2.0, 1060.468505, 2449.308593, 11.100864)) return 2;
        else if(IsPlayerInRangeOfPoint(playerid,2.0, 1031.276977, 2447.560791, 11.100864)) return 3;
    }
    return 0;
}
stock BreakingOrOpenBlockDoor(playerid, blockdoor) // Открываем дверь блока или запускаем процесс взлома
{
    if(IsAPolice(fraction(playerid)) && PlayerInfo[playerid][pJailed] == 0) // Если мы мент и не в заключении, просто можем переключать дверь
    {
        if(Afunix[playerid] > gettime()) return ErrorMessage(playerid, "{FF6347}Пожалуйста.. не флудите\n{cccccc}Повторите попытку через несколько секунд");
        Afunix[playerid] = gettime() + 2;
        PlayerPlaySound(playerid,6400,0,0,0);
        SwitchPrisonBlockDoor(blockdoor);
    }
    else
    { 
        if(get_invent4(playerid,203,0) > 0) 
        {
            if(Afunix[playerid] > gettime()) return ErrorMessage(playerid, "{FF6347}Пожалуйста.. не флудите\n{cccccc}Повторите попытку через несколько секунд");
            Afunix[playerid] = gettime() + 2;
            PlayerPlaySound(playerid,6400,0,0,0);
            SwitchPrisonBlockDoor(blockdoor);
        }
    }
    return 1;
}


stock OpenPrisonCells(side) // Открываем целую сторону и закрываем другую
{
    if(side == 0)
    {
        OpenCells[0] = 1;
        OpenDoorPrison(0);
        OpenDoorPrison(1);
        OpenDoorPrison(2);
        OpenDoorPrison(3);

        OpenCells[1] = 0;
        CloseDoorPrison(4);
        CloseDoorPrison(5);
        CloseDoorPrison(6);
        CloseDoorPrison(7);
    }
    else
    {
        OpenCells[1] = 1;
        OpenDoorPrison(4);
        OpenDoorPrison(5);
        OpenDoorPrison(6);
        OpenDoorPrison(7);

        OpenCells[0] = 0;
        CloseDoorPrison(0);
        CloseDoorPrison(1);
        CloseDoorPrison(2);
        CloseDoorPrison(3);
    }
    return 1;
}
stock OpenDoorPrison(cell) // Открываем одну камеру
{
    if(KpzDoorStatus[cell] == 1) return 1; // Дверь уже открыта
    if(cell == 0) MoveDynamicObject(Kpz[0], 1056.869873, 2441.006347, 11.100864, 1.5);
    else if(cell == 1) MoveDynamicObject(Kpz[1], 1050.146850, 2441.006347, 11.100864, 1.5);
    else if(cell == 2) MoveDynamicObject(Kpz[2], 1043.406127, 2441.006347, 11.100864, 1.5);
    else if(cell == 3) MoveDynamicObject(Kpz[3], 1036.673339, 2441.006347, 11.100864, 1.5);
    else if(cell == 4) MoveDynamicObject(Kpz[4], 1035.089355, 2455.818115, 11.100864, 1.5);
    else if(cell == 5) MoveDynamicObject(Kpz[5], 1041.802612, 2455.818115, 11.100864, 1.5);
    else if(cell == 6) MoveDynamicObject(Kpz[6], 1048.543457, 2455.818115, 11.100864, 1.5);
    else if(cell == 7) MoveDynamicObject(Kpz[7], 1055.267376, 2455.818115, 11.100864, 1.5);
    KpzDoorStatus[cell] = 1;
    return 1;
}
stock CloseDoorPrison(cell) // Закрываем одну камеру
{
    if(KpzDoorStatus[cell] == 0) return 1; // Дверь уже закрыта
    if(cell == 0) MoveDynamicObject(Kpz[0], 1055.199462, 2441.006347, 11.100864, 1.5);
    else if(cell == 1) MoveDynamicObject(Kpz[1], 1048.466918, 2441.006347, 11.100864, 1.5);
    else if(cell == 2) MoveDynamicObject(Kpz[2], 1041.735351, 2441.006347, 11.100864, 1.5);
    else if(cell == 3) MoveDynamicObject(Kpz[3], 1035.002685, 2441.006347, 11.100864, 1.5);
    else if(cell == 4) MoveDynamicObject(Kpz[4], 1036.740234, 2455.818115, 11.100864, 1.5);
    else if(cell == 5) MoveDynamicObject(Kpz[5], 1043.472778, 2455.818115, 11.100864, 1.5);
    else if(cell == 6) MoveDynamicObject(Kpz[6], 1050.204345, 2455.818115, 11.100864, 1.5);
    else if(cell == 7) MoveDynamicObject(Kpz[7], 1056.937011, 2455.818115, 11.100864, 1.5);
    KpzDoorStatus[cell] = 0;
    return 1;
}
stock SwitchPrisonDoorCell(cell) // Переключаем состояние двери камеры
{
    if(KpzDoorStatus[cell] == 1) CloseDoorPrison(cell);
    else if(KpzDoorStatus[cell] == 0) OpenDoorPrison(cell);
    return 1;
}
stock IsPlayerDoorPrisonCellNearby(playerid) // Получаем номер камеры, у которой стоим
{
    if(GetPlayerVirtualWorld(playerid) == WORLD_PRISON_CELLS && GetPlayerInterior(playerid) == INT_PRISON_CELLS)
    {
        if(IsPlayerInRangeOfPoint(playerid,2.0, 1055.199462, 2441.006347, 11.100864)) return 1;
        else if(IsPlayerInRangeOfPoint(playerid,2.0, 1048.466918, 2441.006347, 11.100864)) return 2;
        else if(IsPlayerInRangeOfPoint(playerid,2.0, 1041.735351, 2441.006347, 11.100864)) return 3;
        else if(IsPlayerInRangeOfPoint(playerid,2.0, 1035.002685, 2441.006347, 11.100864)) return 4;
        else if(IsPlayerInRangeOfPoint(playerid,2.0, 1036.740234, 2455.818115, 11.100864)) return 5;
        else if(IsPlayerInRangeOfPoint(playerid,2.0, 1043.472778, 2455.818115, 11.100864)) return 6;
        else if(IsPlayerInRangeOfPoint(playerid,2.0, 1050.204345, 2455.818115, 11.100864)) return 7;
        else if(IsPlayerInRangeOfPoint(playerid,2.0, 1056.937011, 2455.818115, 11.100864)) return 8;
    }
    return 0;
}
stock BreakingOrOpenPrisonCell(playerid, cell) // Открываем дверь камеры или запускаем процесс взлома
{
    if(IsAPolice(fraction(playerid)) && PlayerInfo[playerid][pJailed] == 0) // Если мы мент и не в заключении, просто можем переключать дверь
    {
        if(Afunix[playerid] > gettime()) return ErrorMessage(playerid, "{FF6347}Пожалуйста.. не флудите\n{cccccc}Повторите попытку через несколько секунд");
        Afunix[playerid] = gettime() + 2;
        PlayerPlaySound(playerid,6400,0,0,0);
        SwitchPrisonDoorCell(cell);
    }
    else
    {
        if(OnlineInfo[playerid][oPrsionCellBreaking][cell] == 1)
        {
            if(Afunix[playerid] > gettime()) return ErrorMessage(playerid, "{FF6347}Пожалуйста.. не флудите\n{cccccc}Повторите попытку через несколько секунд");
            Afunix[playerid] = gettime() + 2;
            PlayerPlaySound(playerid,6400,0,0,0);
            SwitchPrisonDoorCell(cell);
            return 1;
        }
        DP[0][playerid] = cell;
        new str[84], sctring[504];
        format(str,sizeof(str),"{FF6347}Камера заперта!"), strcat(sctring,str);
        format(str,sizeof(str),"{cccccc}\n\nТребования для взлома:"), strcat(sctring,str);
        format(str,sizeof(str),"{cccccc}\n- Отмычка [ Крафтится из вилки на станке ]"), strcat(sctring,str);
        format(str,sizeof(str),"{cccccc}\n- Отсутствие рядом копов"), strcat(sctring,str);
        format(str,sizeof(str),"{FF6347}\n\nВнимание! {cccccc}Взлом камер сохраняется на активную сессию"), strcat(sctring,str);
        format(str,sizeof(str),"{cccccc}\n\nХотите взломать дверь?"), strcat(sctring,str);
        ShowDialog(playerid,1481,DIALOG_STYLE_MSGBOX,"{ff9000}Дверь",sctring,"Да","Нет");
    }
    return 1;
}

stock TimePrisonAlarm()
{
    PrisonAlarmTime --;
    if(PrisonAlarmTime <= 0) StopPrisonAlarm();
    return 1;
}

stock CreatePrisonAlarm(playerid, status) // Запускаем режим тревоги в тюрьме
{
    if(PrisonAlarm == 1) return 1;

    if(status == 1) // Ручной запуск тревоги
    {
        new unix = gettime();
        if(PrisonAlarmCD > unix)
        {
            new string[70];
            format(string,sizeof(string),"{FF6347}Ручной запуск тревоги возможен только через %s", fine_time(PrisonAlarmCD - unix));
            ErrorText(playerid, string);
            return 0;
        }
        PrisonAlarmCD = unix + 1800;
    }

    PrisonAlarmTime = 600; // 10 минуту на отключение тревоги
    PrisonAlarm = 1; // По этой переменной будем смотреть, включён режим тревоги или нет (Для доступа к обыску тумбочек)
    SetDynamicObjectMaterial(PrisonAlarmObject[0], 0, 19063, "xmasorbs", "sphere", 0xFFFF0000);
    SetDynamicObjectMaterial(PrisonAlarmObject[1], 0, 19063, "xmasorbs", "sphere", 0xFFFF0000);

    // Закрываем стороны
    OpenCells[0] = 0;
    OpenCells[1] = 0;

    // Закрываем блоки
    OpenBlock[0] = 0;
    OpenBlock[1] = 0;

    // Закрываем камеры
    CloseDoorPrison(0);
    CloseDoorPrison(1);
    CloseDoorPrison(2);
    CloseDoorPrison(3);
    CloseDoorPrison(4);
    CloseDoorPrison(5);
    CloseDoorPrison(6);
    CloseDoorPrison(7);

    // Закрываем двери блоков
    CloseBlockDoorPrison(0);
    CloseBlockDoorPrison(1);
    CloseBlockDoorPrison(2);

    // Обновляем табло
    UpdateTabloPrisonInfo(0, 0);
    UpdateTabloPrisonInfo(1, 0);

    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 1 && GetPVarInt(i,"afksystem") <= 4 && IsPlayerInPrison(i)) 
        {
            ShowDialog(i,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{FF6347}Внимание! На территории тюрьмы объявлен режим тревоги\n{ffcc66}Все камеры и блоки были закрыты","*","");
            SendClientMessage(i, COLOR_GREY, "[ Мысли ]: На территории тюрьмы объявлен режим тревоги");
            PlayerPlaySound(i,42801,0,0,0);

            StopAudio(i, 4, 42799); // Офаем звук через 4 сек
        }
    }
    return 1;
}
stock IsPlayerInPrison(playerid)
{
    new worldid = GetPlayerVirtualWorld(playerid), interiorid = GetPlayerInterior(playerid);
    if(IsPlayerInDynamicArea(playerid, prison_zone) // На улице тюрьмы
            || worldid == WORLD_PRISON_CELLS && interiorid == INT_PRISON_CELLS // Камеры
            || worldid == WORLD_PRISON_1LVL && interiorid == INT_PRISON_1LVL // 1 Этаж
            || worldid == WORLD_PRISON_2LVL && interiorid == INT_PRISON_2LVL // 2 Этаж
            || worldid == WORLD_PRISON_LAUNDY && interiorid == INT_PRISON_LAUNDY // Прачечная
            || worldid > 0 && interiorid == INT_PRISON_IZOL // Изолятор
            || worldid == WORLD_PRISON_KITCHEN && interiorid == INT_PRISON_KITCHEN  // Кухня
            || worldid == WORLD_PRISON_WORKING && interiorid == INT_PRISON_WORKING // Рабочая зона
            ) return 1;
    return 0;
}
stock StopPrisonAlarm() // Выключаем режим тревоги в тюрьме
{
    if(PrisonAlarm == 0) return 1;

    PrisonAlarm = 0;

    // Красную лампу вырубаем
    SetDynamicObjectMaterial(PrisonAlarmObject[0], 0, 11751, "enexmarkers", "enexmarker4-2", 0x00FFFFFF);
    SetDynamicObjectMaterial(PrisonAlarmObject[1], 0, 11751, "enexmarkers", "enexmarker4-2", 0x00FFFFFF);

    // Надпись на табло офаем
    SetDynamicObjectMaterialText(PrisonTabloObject[0], 0, " ", 130, "Arial", 27, 1, 0xFFAAAAAA, 0x00000000, 1);
    SetDynamicObjectMaterialText(PrisonTabloObject[1], 0, " ", 130, "Arial", 27, 1, 0xFFAAAAAA, 0x00000000, 1);
    return 1;
}
stock UpdateTabloPrisonInfo(side, plusmin) // Обновляем инфу на табло
{
    if(PrisonAlarm == 1) SetDynamicObjectMaterialText(PrisonTabloObject[side], 0, "{FF6347}РЕЖИМ ТРЕВОГИ!", 130, "Arial", 27, 1, 0xFFAAAAAA, 0x00000000, 1);
    else
    {
        new string[34], nextonehour, nextoneminute;
        new tmphour, tmpminute;
        if(plusmin == 10)
        {
            NextHourandMinute(plusmin, tmphour, tmpminute, nextonehour, nextoneminute);
            format(string,sizeof(string), "Open %02d:%02d - %02d:%02d", tmphour, tmpminute, nextonehour, nextoneminute);
            SetDynamicObjectMaterialText(PrisonTabloObject[side], 0, string, 130, "Arial", 27, 1, 0xFFAAAAAA, 0x00000000, 1);
        }
        else if(plusmin == 20)
        {
            new nexttwohour, nexttwominute;
            NextHourandMinute(plusmin - 10, tmphour, tmpminute, nextonehour, nextoneminute);
            NextHourandMinute(plusmin, tmphour, tmpminute, nexttwohour, nexttwominute);

            format(string,sizeof(string), "Open %02d:%02d - %02d:%02d", nextonehour, nextoneminute, nexttwohour, nexttwominute);
            SetDynamicObjectMaterialText(PrisonTabloObject[side], 0, string, 130, "Arial", 27, 1, 0xFFAAAAAA, 0x00000000, 1);
        }
    }
    return 1;
}
stock NextHourandMinute(plusmin, &tmphour, &tmpminute, &nexthour, &nextmin)
{
    new tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);

    nextmin = tmpminute + plusmin;
    nexthour = tmphour;

    if(nextmin >= 60)
    {
        if(plusmin == 10) nextmin = 0;
        else if(plusmin == 20) nextmin = 10;
        nexthour = tmphour + 1;
        if(nexthour >= 24) nexthour = 0;
    }
    return 1;
}
stock showDialogMenuPrison(playerid)
{
    if(PlayerInfo[playerid][pJailed] > 0) return ErrorMessage(playerid, "{FF6347}Управление тюрьмой недоступно заключённым");
    new g = fraction(playerid);
	if(!IsAFunctionOrganization(72, g, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать терминал управления тюрьмой");
	if(!GetAccessRankOrg(playerid, g, 72, NO_FBI)) return 1;

    new line[80],lines[80];
    format(line, sizeof(line), "{cccccc}Режим Тревоги \t%s", PrisonAlarm == 0 ? "{FF6347}[ Off ]" : "{99ff66}[ On ]"), strcat(lines, line);
    format(line, sizeof(line), "\n{555555}Команды >> \t"), strcat(lines, line);
	ShowDialog(playerid,529,DIALOG_STYLE_TABLIST,"Тюрьма",lines,"Выбрать","Выход");
    return 1;
}

// Система Конвоя
stock IsAKonvoiMenu(playerid)
{
    if((IsPlayerInRangeOfPoint(playerid,1.0,1574.794311, -1661.598388, 6.796917)
        || IsPlayerInRangeOfPoint(playerid,1.0,1574.794311, -1666.269653, 6.796917))
            && GetPlayerVirtualWorld(playerid) == 257 && GetPlayerInterior(playerid) == 0) return 1; // LSPD
    else if((IsPlayerInRangeOfPoint(playerid,1.0,-1622.575805, 722.354003, -4.340224)
        || IsPlayerInRangeOfPoint(playerid,1.0,-1617.905517, 722.354003, -4.340224))
            && GetPlayerVirtualWorld(playerid) == 208 && GetPlayerInterior(playerid) == 0) return 2; // SFPD
    return 0;
}

stock PrisonKonvoi(playerid, konvoiId)
{
    if(PlayerInfo[playerid][pJailed] != 3 && PlayerInfo[playerid][pJailed] != 9 && server > 0 // Разные проверки для основного и тестового сервера
        || PlayerInfo[playerid][pJailed] == 0 && server == 0) return ErrorMessage(playerid, "{FF6347}Вы не заключённый в КПЗ");
    showDialogMenuKonvoi(playerid, konvoiId);
    return 1;
}

stock showDialogMenuKonvoi(playerid, konvoiId)
{
    new line[50],lines[150];
    DP[0][playerid] = konvoiId;

	if(GetPrisonBusLocation(konvoiId)) format(line,sizeof(line),"{cccccc}Автобус: {99ff66}Ожидает отправления"), strcat(lines,line);
    else format(line,sizeof(line),"{cccccc}Автобус: {FF6347}Выполняет конвой"), strcat(lines,line);

	format(line,sizeof(line),"\n{ff9000}Отправиться в Областную Тюрьму >>"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Что такое конвой? {ff9000}>>"), strcat(lines,line);
	ShowDialog(playerid,532,DIALOG_STYLE_TABLIST_HEADERS,"Конвой",lines,"Выбрать","Выход");
    return 1;
}

stock GetPrisonBusLocation(konvoiId)
{
    if(konvoiId == 1) 
    {
        if(NPCInfo[0][npcStart] == false) return prisonbus_LS; // Автобус на месте
    }
    else if(konvoiId == 2) 
    {
        if(NPCInfo[1][npcStart] == false) return prisonbus_SF; // Автобус на месте
    }
    return 0;
}

// Считаем количество игроков, которые отправляются в конвой
stock GetPlayersInKonvoi(playerid, konvoiId, vehicleid)
{
    new quan;
    foreach(Player,i)
	{
        if(OnlineInfo[i][oLogged] == 1 && GetPlayerVirtualWorld(i) == 0 && GetPlayerInterior(i) == 0)
        {
            if(!IsPlayerAfk(i) || IsPlayerInVehicle(playerid, vehicleid))
            {
                if(konvoiId == 1 && IsPlayerInRangeOfPoint(i,50.0,1604.8387,-1611.0654,13.5175) && PlayerInfo[i][pJailed] == 3) quan ++;
                else if(konvoiId == 2 && IsPlayerInRangeOfPoint(i,50.0,-1580.0209,686.4322,7.1875) && PlayerInfo[i][pJailed] == 9) quan ++;
            }
        }
    }
    return quan;
}

stock dialogCase_Prison(playerid, dialogid, response, listitem)
{
    if(dialogid == 532)
    {
        if(response)
        {
            if(listitem == 0)
            {
                if(PlayerInfo[playerid][pJailTime] <= 600) return ErrorMessage(playerid, "{FF6347}Ваш срок заключения меньше 10 минут\n{cccccc}Нет необходимости конвоировать вас в областную тюрьму");
                
                new konvoiId = DP[0][playerid];
                new vehicleid = GetPrisonBusLocation(konvoiId);
                if(!vehicleid) return ErrorMessage(playerid, "{FF6347}Тюремный автобус в данный момент выполняет конвой\n{cccccc}Пожалуйста, подождите. Он прибудет обратно примерно через 10 минут");
                if(GetPlayersInKonvoi(playerid, konvoiId, vehicleid) >= 8) return ErrorMessage(playerid, "{FF6347}В конвой отправлено максимальное количество заключенных\n{cccccc}К сожалению, вы не успели. Дождитесь следующего конвоя");

                CuffedPlayer(playerid, 9999);
                S_SetPlayerVirtualWorld(playerid,0,0);
		        PPSetPlayerInterior(playerid,0);

                if(vehicleid == prisonbus_LS)
                {
                    if(TimerPrisonBusLS == 0) 
                    {
                        if(!IsVehicleInRangeOfPoint(prisonbus_LS, 8.0, 1601.9716,-1618.8732,13.7368)) PP_SetVehicleToRespawn(prisonbus_LS);
                        TimerPrisonBusLS = SetTimerEx("PrisonGo", 30000, false, "d", prisonbus_LS);
                    }
                    switch(random(3))
                    {
                        case 0: PPSetPlayerPos(playerid,1604.8387,-1611.0654,13.5175);
                        case 1: PPSetPlayerPos(playerid,1603.3575,-1611.1398,13.5016);
                        default: PPSetPlayerPos(playerid,1605.9177,-1611.5446,13.5291);
                    }
                    PPSetPlayerFacingAngle(playerid,180.0);
                }
                else if(vehicleid == prisonbus_SF)
                {
                    if(TimerPrisonBusSF == 0) 
                    {
                        if(!IsVehicleInRangeOfPoint(prisonbus_SF, 8.0, -1577.3430,679.9337,7.4451)) PP_SetVehicleToRespawn(prisonbus_SF);
                        TimerPrisonBusSF = SetTimerEx("PrisonGo", 30000, false, "d", prisonbus_SF);
                    }
                    switch(random(3))
                    {
                        case 0: PPSetPlayerPos(playerid,-1580.0209,686.4322,7.1875);
                        case 1: PPSetPlayerPos(playerid,-1580.8610,686.3076,7.1875);
                        default: PPSetPlayerPos(playerid,-1579.2289,685.9234,7.1875);
                    }
                    PPSetPlayerFacingAngle(playerid,180.0);
                }
                ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Садитесь в тюремный автобус\n\n{FF6347}Внимание! {ffcc66}Если вы выйдете из автобуса, то вернётесь обратно в КПЗ!","*","");
                SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Мне нужно сесть в автобус [ Отправление через 30 секунд ]");
                SetCameraBehindPlayer(playerid);
            }
            if(listitem == 1)
            {
                new line[80],lines[480];
                format(line,sizeof(line),"{ff9000}Что такое конвой?"), strcat(lines,line);
                format(line,sizeof(line),"\n{cccccc}- Вас доставят на тюремном автобусе в областную тюрьму"), strcat(lines,line);
                format(line,sizeof(line),"\n\n{ff9000}Зачем ехать в тюрьму?"), strcat(lines,line);
                format(line,sizeof(line),"\n{cccccc}- Там вы сможете получить юридическую помощь и уменьшить свой срок"), strcat(lines,line);
                format(line,sizeof(line),"\n{cccccc}- Есть возможность побега"), strcat(lines,line);
                format(line,sizeof(line),"\n{cccccc}- В тюрьме веселее, чем в КПЗ :)"), strcat(lines,line);
                ShowDialog(playerid,531,DIALOG_STYLE_MSGBOX,"Конвой",lines,"*","");
            }
        }
    }
    else if(dialogid == 531) showDialogMenuKonvoi(playerid, DP[0][playerid]);
    else if(dialogid == 529)
    {
        if(response)
        {
            if(listitem == 0)
            {
                if(PrisonAlarm == 0) CreatePrisonAlarm(playerid, 1);
                else 
                {
                    StopPrisonAlarm();
                    showDialogMenuPrison(playerid);
                }
            }
            else if(listitem == 1)
            {
                new str[70],sctring[210];
                format(str,sizeof(str),"{0088ff}/izol {ffffff}- посадить в изолятор"), strcat(sctring,str);
                format(str,sizeof(str),"\n{0088ff}/unizol {ffffff}- освободить из изолятора"), strcat(sctring,str);
                format(str,sizeof(str),"\n{0088ff}/kam {ffffff}- пересадить заключенного в другую камеру"), strcat(sctring,str);
                ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"Команды",sctring,"*","");
            }
        }
    }
    else if(dialogid == 1481)
    {
        if(response)
        {
            if(get_invent2(playerid, 19, 0) == 0) return ErrorMessage(playerid,"{ff6347} У вас нет отмычек\n{cccccc}Вы можете сделать их на станке из вилки");
            CreateBreaking(playerid, 4, DP[0][playerid], 0);
        }
    }
    else if(dialogid == 1482)
    {
        if(response)
        {
            if(listitem < 0 || listitem > 200) return ErrorMessage(playerid,"{ff6743}Ошибка выбора строки");
            ShowPlayerWanted(playerid, List[listitem][playerid]);
        }
    }
    return 1;
}


stock PrisonMovingPoster(playerid,number)
{
    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, Afclick[playerid]);
    if(interval < 500) return 0;
    Afclick[playerid] = current_tick;

    if(IsACop(playerid) && PlayerInfo[playerid][pJailed] == 0)
    {
        if(PrisonPosterStatus[number] == 0 && PrisonSandStatus[number] == 0) return ErrorMessage(playerid,"{ff6347}Нет никаких следов попытки побега\n{cccccc}Постер висит на стене, на полу всё чисто");
        PrisonMovingBackPoster(number);
        PrisonBetonHP[number] = 3000;
        PrisonMovingBeton(number, 0);
	    SuccessMessage(playerid, "{99ff66}Вы закрыли дырку в стене и предотвратили побег");
    }

    if(PrisonPosterStatus[number] == 0) 
    {
        if(OnlineInfo[playerid][oPrisonInforamtion] < 3) OnlineInfo[playerid][oPrisonInforamtion]++, EscapeInfo(playerid);
        PrisonPosterStatus[number] = 1;
        PrisonMovingDownPoster(number);
        PlayerPlaySound(playerid,5601,0,0,0);
    }
    else if(PrisonPosterStatus[number] == 1) PrisonPosterStatus[number] = 0,PrisonMovingBackPoster(number), PlayerPlaySound(playerid,5602,0,0,0);
    return 1;
}

CMD:posterinfo(playerid)
{
    if(PlayerInfo[playerid][pJailTime] < 1) return 1;
    else return EscapeInfo(playerid);
}

stock EscapeInfo(playerid)
{
	new line[214],lines[4096];
	format(line,sizeof(line),"{684F7D}Что за постер?"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Постер это объект, который закрывает дырку в стене которую вы можете продолбить"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Вы можете вешать и убирать его на ALT, помните, охранники сразу увидят если постер снят"), strcat(lines,line);

	format(line,sizeof(line),"\n\n{684F7D}Что даёт дырка в стене?"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}- Если вы полностью пробьете стену то вы сможете сбежать из тюрьмы!"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Вы можете начать долбить стену монитровкой, которую можно скрафтить в рабочей секции из трубы"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}или пронести с собой, если вам повезет с археалогии."), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Сняв постер, и взяв в руки монтировку, подойдите к стене и нажимайте ПКМ, чтобы долбить стену"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}- При разрушение стены, под ней будет образовываться песок, который нужно убирать шваброй"), strcat(lines,line);

	format(line,sizeof(line),"\n\n{684F7D}Где взять швабру и как выйти из камеры?"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Шфабра лежит в блоке камер, что бы её взять нужно выйти из камеры"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Из камер вы можете выйти когда дверь открывается автоматически, либо скрафтив/найдя отмычку"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}- Отмычки появляются в рандомное время в тумбочках, а скрафтить их можно из вилки, которую"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}можно взять в столовой, после придя на станок в рабочей секции скрафтить отмычку из неё"), strcat(lines,line);

	format(line,sizeof(line),"\n\n{684F7D}Что за тумбочка?"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- В ней вы можете хранить запрещенные вещи, которые могут отнять тюремщики"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Доступ к тумбочки они могут получить во время тревоги в тюрьме"), strcat(lines,line);

	format(line,sizeof(line),"\n\n{684F7D}Я продолбил стену, что дальше?"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Нажать еще раз ALT рядом с постером и вы сбежите"), strcat(lines,line);
	format(line,sizeof(line),"\n{ff6347}- ВАЖНО!! {cccccc}Сразу после этого по всей тюрьме включится тревога"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- В одну дырку может сбежать только один человек"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- После того как вы покинете камеру тюрьмы через дырку, розыск останется, и добавится еще статья"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}за побег из тюрьмы, ну а дальше вам просто нужно выбраться из туннеля"), strcat(lines,line);
    format(line,sizeof(line),"\n{ff6347}- ВАЖНО!! {cccccc}Туннель соединен с базой NGSA, вам нужно будет выйти в другой стороне по трубе"), strcat(lines,line);

	format(line,sizeof(line),"\n\n{684F7D}Как избавиться от розыска?"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Есть много вариантов. Одна из систем связанна со SWAT, вам нужно проникнуть на их базу"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}и взломать сервер с базой данных, после чего убрать себя из розыска"), strcat(lines,line);

    format(line,sizeof(line),"\n\n{684F7D}Повторно вызвать эту информацию можно коммандой /posterinfo"), strcat(lines,line);

	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{684F7D}Побег из тюрьмы",lines,"*","");
	return 1;
}

CMD:movingbeton(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20 && server != 0) return 0;
    new moving,number;
    sscanf(params, "ii",number,moving);
    if(number < 0 || number >= 8) return 1;
    PrisonMovingBeton(number,moving);
    PrisonMovingSand(number,moving);
    PrisonBetonHP[number]-=moving*75;
    return 1;
}

stock PrisonMovingDownPoster(number)
{
    if(number == 0) SetDynamicObjectPos(PrisonPoster[number],1057.385375, 2435.324707, 11.073853);
    if(number == 1) SetDynamicObjectPos(PrisonPoster[number],1050.642700, 2435.324707, 11.073857);
    if(number == 2) SetDynamicObjectPos(PrisonPoster[number],1043.931396, 2435.324707, 11.073857);
    if(number == 3) SetDynamicObjectPos(PrisonPoster[number],1037.208251, 2435.324707, 11.083859);
    if(number == 4) SetDynamicObjectPos(PrisonPoster[number],1034.543579, 2461.499755, 11.083859);
    if(number == 5) SetDynamicObjectPos(PrisonPoster[number],1041.306152, 2461.499755, 11.083861);
    if(number == 6) SetDynamicObjectPos(PrisonPoster[number],1048.008422, 2461.499755, 11.083857);
    if(number == 7) SetDynamicObjectPos(PrisonPoster[number],1054.750854, 2461.499755, 11.083860);
    return 1;
}

stock PrisonMovingBackPoster(number)
{
    if(number == 0) SetDynamicObjectPos(PrisonPoster[number], 1056.074340, 2435.324707, 11.373860);
	if(number == 1) SetDynamicObjectPos(PrisonPoster[number], 1049.342407, 2435.324707, 11.413865);
	if(number == 2) SetDynamicObjectPos(PrisonPoster[number], 1042.610839, 2435.324707, 11.413865);
	if(number == 3) SetDynamicObjectPos(PrisonPoster[number], 1035.878173, 2435.324707, 11.413865);
	if(number == 4) SetDynamicObjectPos(PrisonPoster[number], 1035.864746, 2461.499755, 11.413865);
	if(number == 5) SetDynamicObjectPos(PrisonPoster[number], 1042.597290, 2461.499755, 11.413865);
	if(number == 6) SetDynamicObjectPos(PrisonPoster[number], 1049.328857, 2461.499755, 11.413865);
	if(number == 7) SetDynamicObjectPos(PrisonPoster[number], 1056.061523, 2461.499755, 11.413865);
    return 1;
}

stock PrisonMovingBeton(number,degree)
{
    if(number == 0) SetDynamicObjectPos(PrisonBeton[number],1056.106689, 2434.759033-(degree*0.001051025), 12.263865);
    if(number == 1) SetDynamicObjectPos(PrisonBeton[number],1049.374145, 2434.759033-(degree*0.001051025), 12.263865);
    if(number == 2) SetDynamicObjectPos(PrisonBeton[number],1042.642578, 2434.759033-(degree*0.001051025), 12.263865);
    if(number == 3) SetDynamicObjectPos(PrisonBeton[number],1035.909912, 2434.759033-(degree*0.001051025), 12.263865);
    if(number == 4) SetDynamicObjectPos(PrisonBeton[number],1035.833007, 2462.065429+(degree*0.0010761625), 12.263865);
    if(number == 5) SetDynamicObjectPos(PrisonBeton[number],1042.565551, 2462.065429+(degree*0.0010761625), 12.263865);
    if(number == 6) SetDynamicObjectPos(PrisonBeton[number],1049.297119, 2462.065429+(degree*0.0010761625), 12.263865);
    if(number == 7) SetDynamicObjectPos(PrisonBeton[number],1056.029785, 2462.065429+(degree*0.0010761625), 12.263865);
    return 1;
}

stock PrisonMovingSand(number,sand)
{
    if(number == 0) SetDynamicObjectPos(PrisonSand[number],1055.898559, 2434.780029, 4.45+(sand*0.001));
    if(number == 1) SetDynamicObjectPos(PrisonSand[number],1049.177124, 2434.780029, 4.45+(sand*0.001));
    if(number == 2) SetDynamicObjectPos(PrisonSand[number],1042.404785, 2434.780029, 4.45+(sand*0.001));
    if(number == 3) SetDynamicObjectPos(PrisonSand[number],1035.724365, 2434.780029, 4.45+(sand*0.001));
    if(number == 4) SetDynamicObjectPos(PrisonSand[number],1036.041137, 2462.044433, 4.45+(sand*0.001));
    if(number == 5) SetDynamicObjectPos(PrisonSand[number],1042.762573, 2462.044433, 4.45+(sand*0.001));
    if(number == 6) SetDynamicObjectPos(PrisonSand[number],1049.534912, 2462.044433, 4.45+(sand*0.001));
    if(number == 7) SetDynamicObjectPos(PrisonSand[number],1056.215332, 2462.044433, 4.45+(sand*0.001));
    return 1;
}

stock PrisonEditingBeton(playerid,number)
{
    if(PrisonPosterStatus[number] == 0) return 0;
    if(PrisonBetonHP[number] <= 0) return 0;

    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, Afclick[playerid]);
    if(interval < 500) return 0;
    Afclick[playerid] = current_tick;

    new mod,string[60];
    PrisonBetonHP[number]--;
    mod = PrisonBetonHP[number] % 75;

    SetPlayerChatBubble(playerid,"ударяет по стене монтировкой",COLOR_PURPLE,10.0,2000);
    if(mod == 0)
    {
        new count;
        count = 40-(PrisonBetonHP[number]/75);
        PrisonSandStatus[number]++;
        PrisonMovingBeton(number,count);
        PrisonMovingSand(number,PrisonSandStatus[number]);
        SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Чёрт, тут много песка, нужно бы убрать его метлой!");
    }
    format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Ђe¦o®: ~w~%d/3000",PrisonBetonHP[number]);
	GameTextForPlayer(playerid,string, 1500, 3);
    ApplyAnimation(playerid,"PED","FightA_M",2.0, false, false, false, false, false);

    if(PrisonBetonHP[number] <= 0)
    {
        SuccessMessage(playerid, "{99ff66}Вы продолбили дырку в стене и можете сбежать из тюрьмы [ ALT ]");
        SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Свободаааа! Теперь я могу сбежать [ ALT ]");
    }
    return 1;
}

stock IsABeton(playerid)
{
    if(GetPlayerVirtualWorld(playerid) != WORLD_PRISON_CELLS || GetPlayerVirtualWorld(playerid) != INT_PRISON_CELLS) return -1;
    if(IsPlayerInRangeOfPoint(playerid,2.0,1056.106689, 2434.759033, 12.263865)) return 0;
    else if(IsPlayerInRangeOfPoint(playerid,2.0,1049.374145, 2434.759033, 12.263865)) return 1;
    else if(IsPlayerInRangeOfPoint(playerid,2.0,1042.642578, 2434.759033, 12.263865)) return 2;
    else if(IsPlayerInRangeOfPoint(playerid,2.0,1035.909912, 2434.759033, 12.263865)) return 3;
    else if(IsPlayerInRangeOfPoint(playerid,2.0,1035.833007, 2462.065429, 12.263865)) return 4;
    else if(IsPlayerInRangeOfPoint(playerid,2.0,1042.565551, 2462.065429, 12.263865)) return 5;
    else if(IsPlayerInRangeOfPoint(playerid,2.0,1049.297119, 2462.065429, 12.263865)) return 6;
    else if(IsPlayerInRangeOfPoint(playerid,2.0,1056.029785, 2462.065429, 12.263865)) return 7;
    else return -1;
}

stock PrisonClearSand(playerid,number)
{
    if(GetPlayerVirtualWorld(playerid) != WORLD_PRISON_CELLS || GetPlayerVirtualWorld(playerid) != INT_PRISON_CELLS) return -1;
    if(PrisonSandStatus[number] == 0) return 0;
    PrisonSandStatus[number] = 0;
    PrisonMovingSand(number,PrisonSandStatus[number]);
    ApplyAnimation(playerid,"PED","flee_lkaround_01",4.0, false, false, false, false, false);
    SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я убрал песок, надо вернуть швабру на место!");
    return 1;
}

stock PrisonEscape(playerid)
{
    if(PlayerInfo[playerid][pJailed] == 0) return ErrorMessage(playerid, "{FF6347}Вы не заключённый");

    // Сюда счётчик на побег только двух игроков в одну дырку
    new cell = IsABeton(playerid);
    PrisonMovingBackPoster(cell);
    PrisonBetonHP[cell] = 3000;
    PrisonMovingBeton(cell,0);
    if(Dei[playerid] == 2) Dei[playerid] = 0, RemovePlayerAttachedObject(playerid,1), PlayerPlaySound(playerid,5601,0,0,0);
    PlayerInfo[playerid][pJailed] = 0;
    PlayerInfo[playerid][pJailTime] = 0;

    new string_mysql[90];
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_igroki` SET `Jailed`='0', `JailTime`='0' WHERE `user_id`='%d'", PlayerInfo[playerid][pID]);
    query_empty(pearsq, string_mysql);

    keep(playerid);
    S_SetPlayerVirtualWorld(playerid,241,241), PPSetPlayerInterior(playerid,241);
    PPSetPlayerPos(playerid,299.2186,2164.9827,942.0348);
    PPSetPlayerFacingAngle(playerid,173.2588);
    SetPlayerCriminal(playerid, -1, CriminalCodeInfo[0][0][ccName], CriminalCodeInfo[0][0][ccLevel], 0, 0);
    SuccessMessage(playerid, "{99ff66}Вы сбежали из тюрьмы");

    CreatePrisonAlarm(playerid, 0);
    return 1;
}

stock PrisonGivePipe(playerid)
{
    if(PlayerInfo[playerid][pPrisonPipeUnix]+1800 > gettime()) 
    {
        new line[100];
        format(line,sizeof(line),"\n{ff6347} Трубу можно брать раз в 30 минут. Следующую можно взять через %s",fine_time(PlayerInfo[playerid][pPrisonPipeUnix]+1800-gettime()));
        return ErrorMessage(playerid,line);
    }
    new put_inva = GiveThingPlayer(playerid, 201, 1, 0, 0, 0, 0, 9999);
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");
    PlayerInfo[playerid][pPrisonPipeUnix] = gettime();
    new string[100];
    mysql_format(pearsq, string,sizeof(string),"UPDATE `pp_igroki` SET `PrisonPipeUnix` = '%d' WHERE `user_id` = '%d'",PlayerInfo[playerid][pPrisonPipeUnix], PlayerInfo[playerid][pID]);
    query_empty(pearsq, string);
    SuccessMessage(playerid,"{66ff99}Вы взяли трубу, из неё вы можете сделать монтировку на станке");
    ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0, false, true, true, false, false);
    return 1;
}

stock PrisonGiveSpoon(playerid)
{
    if(PlayerInfo[playerid][pPrisonSpoonUnix]+1800 > gettime()) 
    {
        new line[100];
        format(line,sizeof(line),"\n{ff6347} Вилку можно брать раз в 30 минут. Следующую можно взять через %s",fine_time(PlayerInfo[playerid][pPrisonSpoonUnix]+1800-gettime()));
        return ErrorMessage(playerid,line);
    }
    new put_inva = GiveThingPlayer(playerid, 202, 1, 0, 0, 0, 0, 9999);
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");
    PlayerInfo[playerid][pPrisonSpoonUnix] = gettime();
    new string[100];
    mysql_format(pearsq, string,sizeof(string),"UPDATE `pp_igroki` SET `PrisonSpoonUnix` = '%d' WHERE `user_id` = '%d'",PlayerInfo[playerid][pPrisonSpoonUnix], PlayerInfo[playerid][pID]);
    query_empty(pearsq, string);
    SuccessMessage(playerid,"{66ff99}Вы взяли вилку, из неё вы можете сделать заточку на станке");
    ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0, false, true, true, false, false);
    return 1;
}

stock IsAPrisonBedTable(playerid) // Получаем id прикроватного столика в тюряге
{
    if(GetPlayerVirtualWorld(playerid) != WORLD_PRISON_CELLS || GetPlayerVirtualWorld(playerid) != INT_PRISON_CELLS) return -1;
	if(IsPlayerInRangeOfPoint(playerid,1.0,1057.384277, 2435.860351, 10.385841)) return 0;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1054.723022, 2435.860351, 10.385841)) return 1;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1050.653198, 2435.860351, 10.385841)) return 2;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1047.991943, 2435.860351, 10.385841)) return 3;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1043.912353, 2435.860351, 10.385841)) return 4;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1041.251098, 2435.860351, 10.385841)) return 5;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1037.192138, 2435.860351, 10.385841)) return 6;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1034.530883, 2435.860351, 10.385841)) return 7;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1034.530883, 2460.949951, 10.385841)) return 8;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1037.192138, 2460.949951, 10.385841)) return 9;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1041.251098, 2460.949951, 10.385841)) return 10;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1043.912353, 2460.949951, 10.385841)) return 11;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1047.991943, 2460.949951, 10.385841)) return 12;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1050.653198, 2460.949951, 10.385841)) return 13;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1054.723022, 2460.949951, 10.385841)) return 14;
	else if(IsPlayerInRangeOfPoint(playerid,1.0,1057.384277, 2460.949951, 10.385841)) return 15;
    return -1;
}

stock showprisontable(playerid, i) // Открываем меню прикроватного столика
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || howstun(playerid)) return 1;
	if(PlayerInfo[playerid][pJailed] == 0 && PrisonAlarm == 0) return ErrorMessage(playerid, "{FF6347}Прикроватный столик могут открывать только заключённые\n{cccccc}Вы можете открыть столик только во время тревоги");

    if(OnlineInfo[playerid][oPrisonTableMessage] == false)
	{
		OnlineInfo[playerid][oPrisonTableMessage] = true;
        new line[100],lines[400];
        format(line,sizeof(line),"{ff9000}Тумба"), strcat(lines,line);
        format(line,sizeof(line),"\n{ffcc66}- Надзиратели могут обыскать эту тумбу только во время тюремной тревоги"), strcat(lines,line);
        format(line,sizeof(line),"\n{ffcc66}- Предметы, которые положили вы, не смогут взять другие заключённые"), strcat(lines,line);
        format(line,sizeof(line),"\n{FF6347}Внимание! После перезагрузки сервера все предметы исчезнут"), strcat(lines,line);
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
	}

	OnlineInfo[playerid][oShowTabs] = i;
	i_tabs(playerid, 4, 1);
	for(new inva = 0; inva < MAX_PRISON_TABLE_SLOTS; inva++) item_second(playerid, PrisonTableInfo[i][ptInvent][inva], PrisonTableInfo[i][ptInv][inva], inva, 0, PrisonTableInfo[i][ptInvPara][inva], PrisonTableInfo[i][ptInvType][inva], PrisonTableInfo[i][ptInvPack][inva], 0);
	return 1;
}

stock use_prisontable(playerid, i, inva, useinva)
{
    i_resettabs(playerid);
	i_resetveshi(playerid);
	
	if(OnlineInfo[playerid][oShowTabs] != i) return 1;
	if(Veshi[playerid] >= 1) return 1;
	if(gRedakt[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя перекладывать предметы во время использования редактора объектов");
 		
	if(useinva != 9999)
	{
 		if(PlayerInfo[playerid][pInven][useinva] != PrisonTableInfo[i][ptInvent][inva] && PlayerInfo[playerid][pInven][useinva] != 0) return 1;
	}
    if(IsAPrisonBedTable(playerid) == -1) return ErrorMessage(playerid, "{FF6347}Вы далеко от тумбы"), closetab(playerid, 1);

    if(IsACop(playerid) && PlayerInfo[playerid][pJailed] == 0) {}
    else
    {
        if(PrisonTableInfo[i][ptInvPlayer][inva] > 0 && PrisonTableInfo[i][ptInvPlayer][inva] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid, "{FF6347}Это чужой предмет и вы не можете его взять\n\n{cccccc}Предметы, которые положил другой игрок, невозможно взять"), i_resettabs(playerid);
    }

	new thingId = PrisonTableInfo[i][ptInvent][inva];
    new thingQuan = PrisonTableInfo[i][ptInv][inva];
    new thingPara = PrisonTableInfo[i][ptInvPara][inva];
    new thingQara = PrisonTableInfo[i][ptInvQara][inva];
    new thingType = PrisonTableInfo[i][ptInvType][inva];
    new thingPack = PrisonTableInfo[i][ptInvPack][inva];
	
	// Забираем предмет из дома
	if(thingType == 0 && thingPack == 0)
	{
	    if(CheckThingQuan(thingId) == 1)
		{
		    DP[0][playerid] = inva;
			new string[120];
			format(string,sizeof(string),"{cccccc}Чтобы взять {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(0, thingId, thingType, thingPack));
			ShowDialog(playerid,939,DIALOG_STYLE_INPUT,"{ff9000}Тумба",string,"Принять","Отмена");
			return 1;
		}
	}
	
	// Проверка на наличие особых аксессуаров (Каска и Броня)
	if(IsArmor(thingId) && thingType == 2 && PlayerInfo[playerid][pArmor] >= 1) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет\n\n{cccccc}Учитывается надетая броня");
	
	// Проверка на одиночный предмет
	if(JustOneThingInventory(thingId, thingType) && get_invent(playerid, thingId, thingType) > 0) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров");
	
	new string[160];
	if(thingType == 0)
	{
	    if(CheckThingQuan(thingId) == 1)
		{
			new getQuan, getLimit;
    		i_limit(playerid, thingId, getQuan, getLimit);
    		if(getQuan + thingQuan > getLimit) return format(string,sizeof(string),"{FF6347}У вас нет места в инвентаре\nЛимит для этого предмета: %d\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров", getLimit), ErrorMessage(playerid, string);
 		}
	}
	
	new put_inva = GiveThingPlayer(playerid, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, useinva);
	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
    TakePrisonTable(i, thingId, thingQuan, thingType, inva);
	
    format(string,sizeof(string),"Взял %d: %s", i, GetNameThing(1, thingId, thingType, thingPack));
	UserLog("gtable", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", thingQuan, string);
	return 1;
}

stock TakePrisonTable(i, thingId, thingQuan, thingType, dopinf)
{
	new plalit;
	if(dopinf == 999)
	{
		for(new inva = 0; inva < 80; inva++)
		{
			if(PrisonTableInfo[i][ptInvent][inva] == thingId && PrisonTableInfo[i][ptInvType][inva] == thingType)
			{
				if(PrisonTableInfo[i][ptInv][inva]-thingQuan <= 0) 
                {
                    PrisonTableInfo[i][ptInvent][inva] = 0;
                    PrisonTableInfo[i][ptInv][inva] = 0;
                    PrisonTableInfo[i][ptInvPara][inva] = 0;
                    PrisonTableInfo[i][ptInvQara][inva] = 0;
                    PrisonTableInfo[i][ptInvType][inva] = 0;
                    PrisonTableInfo[i][ptInvPack][inva] = 0;
                    PrisonTableInfo[i][ptInvPlayer][inva] = 0;
                }
				else PrisonTableInfo[i][ptInv][inva] -= thingQuan;
				plalit = inva;
				break;
			}
		}
	}
	else
	{
		if(PrisonTableInfo[i][ptInvent][dopinf] == thingId && PrisonTableInfo[i][ptInvType][dopinf] == thingType)
		{
			if(PrisonTableInfo[i][ptInv][dopinf]-thingQuan <= 0) 
            {
                PrisonTableInfo[i][ptInvent][dopinf] = 0;
                PrisonTableInfo[i][ptInv][dopinf] = 0;
                PrisonTableInfo[i][ptInvPara][dopinf] = 0;
                PrisonTableInfo[i][ptInvQara][dopinf] = 0;
                PrisonTableInfo[i][ptInvType][dopinf] = 0;
                PrisonTableInfo[i][ptInvPack][dopinf] = 0;
                PrisonTableInfo[i][ptInvPlayer][dopinf] = 0;
            }
			else PrisonTableInfo[i][ptInv][dopinf] -= thingQuan;
		}
		plalit = dopinf;
	}
	foreach(Player,p)
	{
		if(Tabs_Load[p] != 14) continue;
		if(OnlineInfo[p][oLogged] == 1 && OnlineInfo[p][oShowInterface] == 1 && OnlineInfo[p][oShowTabs] == i) item_second(p, PrisonTableInfo[i][ptInvent][plalit], PrisonTableInfo[i][ptInv][plalit], plalit, 0, PrisonTableInfo[i][ptInvPara][plalit], PrisonTableInfo[i][ptInvType][plalit], PrisonTableInfo[i][ptInvPack][plalit], 0);
	}
	return 1;
}

stock get_prisontable(pt, thingId, thingType) // Поиск предмета в тумбе
{
	new quan = 0;
	for(new i = 0; i < MAX_PRISON_TABLE_SLOTS; i++)
	{
		if(PrisonTableInfo[pt][ptInvent][i] == thingId 
            && PrisonTableInfo[pt][ptInv][i] > 0 
            && PrisonTableInfo[pt][ptInvType][i] == thingType) quan += PrisonTableInfo[pt][ptInv][i];
	}
	return quan;
}

stock pt_limit(pt, thingId, &getQuan, &getLimit) // Проверяем лимиты тумбы в тюрьме
{
	new lim[sizeof(friskName)];
	for(new i = 0; i < sizeof(friskName); i++) lim[i] = 1;
	lim[8] = 100, lim[19] = 1000, lim[41] = 1000, lim[25] = 999000000; // Аптечки, Отмычки, Бенгальские Свечи, Деньги 999кк
	lim[4] = 100000, lim[5] = 100000, lim[6] = 100000, lim[7] = 100000, lim[9] = 20, lim[18] = 10000, lim[20] = 10000, lim[27] = 50000, lim[28] = 50000, lim[29] = 50000, lim[30] = 50000;
	lim[46] = 1000, lim[47] = 1000, lim[55] = 100, lim[60] = 1000, lim[61] = 500, lim[64] = 10000, lim[65] = 10000, lim[66] = 10000, lim[67] = 10000;
    lim[70] = 100;
    lim[71] = 1000;
	lim[72] = 1000, lim[73] = 1000, lim[74] = 1000, lim[75] = 1000, lim[76] = 1000, lim[77] = 1000, lim[78] = 1000, lim[79] = 1000, lim[80] = 1000, lim[81] = 1000;
	lim[82] = 1000, lim[83] = 1000, lim[84] = 1000, lim[85] = 1000, lim[86] = 1000, lim[87] = 1000, lim[88] = 1000, lim[89] = 10000, lim[106] = 1000, lim[108] = 1000, lim[109] = 1000, lim[110] = 1000;
	lim[140] = 10000, lim[141] = 10000, lim[142] = 1000, lim[180] = 1000, lim[181] = 1000, lim[197] = 100, lim[198] = 1000, lim[225] = 100;

    getQuan = get_prisontable(pt, thingId, 0);
    getLimit = lim[thingId];
	return 1;
}

stock put_prisontable(playerid, inva, i, thingId, thingQuan, binva, thingType, thingPack)
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || binva == 9999 || OnlineInfo[playerid][oShowTabs] == 9999
	|| PlayerInfo[playerid][pInven][inva] == 0 || PlayerInfo[playerid][pInven][inva] != thingId || PlayerInfo[playerid][pInvenQuan][inva] < thingQuan) return i_resetveshi(playerid);
	if(gRedakt[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя перекладывать предметы во время использования редактора объектов"), i_resetveshi(playerid);
	
	if(IsAPrisonBedTable(playerid) == -1) return ErrorMessage(playerid, "{FF6347}Вы далеко от тумбы"), closetab(playerid, 1);
	
	if(NotGiveInflatabelBoat(playerid, thingId, thingType)) return i_resetveshi(playerid);
	if(NotGiveThing(thingId, thingType, PlayerInfo[playerid][pInvenQuan][inva])) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя передавать, продавать или убирать"), i_resetveshi(playerid);
	
    // Кейс нельзя выбрасывать на 3 уровне и ниже
	if(IsNotGiveCase(playerid, thingPack)) return i_resetveshi(playerid);

	new string[100];
	new quanThing;
	if(thingType == 0)
	{
		if(CheckThingQuan(thingId) == 1)
		{
		    if(PrisonTableInfo[i][ptInvent][binva] != 0 && PrisonTableInfo[i][ptInvent][binva] != PlayerInfo[playerid][pInven][inva]) return ErrorMessage(playerid, "{FF6347}Эта ячейка занята"), i_resetveshi(playerid);
		    if(thingPack == 0) quanThing = 1;
		    if(PlayerInfo[playerid][pInvenQuan][inva] < thingQuan) return ErrorMessage(playerid, "{FF6347}У вас нет такого количества в этой ячейке"), i_resetveshi(playerid);
		    new getQuan, getLimit;
		    pt_limit(i, thingId, getQuan, getLimit);
		    if(getQuan+thingQuan > getLimit)
		    {
		        format(string,sizeof(string),"{FF6347}В тумбе нет места\n\nЛимит для этого предмета: %d", getLimit);
		        ErrorMessage(playerid, string);
				i_resetveshi(playerid);
				i_resettabs(playerid);
				return 1;
		    }
		}
	}
	if(PrisonTableInfo[i][ptInvent][binva] > 0 && quanThing == 0) return ErrorMessage(playerid, "{FF6347}Эта ячейка занята"), i_resetveshi(playerid);
	
	new put_inva = put_thing_prisontable(i, playerid, thingId, thingQuan, PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenQara][inva], thingType, thingPack, binva);
	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}В доме нет места"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
	
	if(quanThing == 1) take_away(playerid, thingQuan, inva); // Отнимаем предмет (по количеству)
 	else i_del(playerid, inva); // Отнимаем предмет (целиком)
	
    format(string,sizeof(string),"Положил %d: %s", i, GetNameThing(1, thingId, thingType, thingPack));
	UserLog("ptable", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", thingQuan, string);
	
	i_resetveshi(playerid);
	i_resettabs(playerid);
	return put_inva;
}
stock PutThingPrisonTable(pt, playerid, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, useinva) // Кладём предмет в тумбу
{
    new inva = -1;
	if(thingId == 0) return inva; // Малоли где то ошибка может быть (0 - не пропускаем выдачу предмета)
	if(useinva == 999) // Не знаем в какую ячейку класть
	{
	    if(thingType == 0 && thingPack == 0) // Обычный предмет
		{
		    if(CheckThingQuan(thingId) == 1) // Предмет имеет количество (Складывается в одну ячейку)
		    {
		        new find;
		    	for(new i = 0; i < MAX_PRISON_TABLE_SLOTS; i++)
				{
					if(PrisonTableInfo[pt][ptInvent][i] == thingId && PrisonTableInfo[pt][ptInvType][i] == thingType && PrisonTableInfo[pt][ptInvPack][i] == thingPack) // Ищем тот, где уже предмет лежит
					{
					    inva = i;
		  				put_thing_prisontable(pt, playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
		  				find = 1;
			   			break;
					}
				}
				if(find == 0) // Если не нашли, ищем пустую
				{
					for(new i = 0; i < MAX_PRISON_TABLE_SLOTS; i++)
					{
						if(PrisonTableInfo[pt][ptInvent][i] == 0) // Ищем пустую ячейку
						{
						    inva = i;
			  				put_thing_prisontable(pt, playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
				   			break;
						}
					}
				}
			}
			else if(CheckThingQuan(thingId) == 0) // Объект не имеет количество
			{
			    for(new i = 0; i < MAX_PRISON_TABLE_SLOTS; i++)
				{
					if(PrisonTableInfo[pt][ptInvent][i] == 0) // Ищем пустую ячейку
					{
					    inva = i;
		  				put_thing_prisontable(pt, playerid, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, i);
			   			break;
					}
				}
			}
		}
		else // Все остальные предметы не имеют количества или возможности складываться в одну ячейку
		{
		    for(new i = 0; i < MAX_PRISON_TABLE_SLOTS; i++)
			{
				if(PrisonTableInfo[pt][ptInvent][i] == 0) // Ищем пустую ячейку
				{
				    inva = i;
	  				put_thing_prisontable(pt, playerid, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, i);
		   			break;
				}
			}
		}
	}
	else inva = put_thing_prisontable(pt, playerid, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, useinva); // Знаем в какую ячейку класть
	return inva;
}

stock put_thing_prisontable(pt, playerid, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, i)
{
	if(PrisonTableInfo[pt][ptInvent][i] != 0 && PrisonTableInfo[pt][ptInvent][i] != thingId) return -1; // Защита от ошибки, на всякий случай

	PrisonTableInfo[pt][ptInvent][i] = thingId; // Ставим предмет в слот
	PrisonTableInfo[pt][ptInv][i] += thingQuan; // Ставим количество в слот

	// (Техника сломана или нет, Одежда какой организации принадлежит, Unix время свежести продуктов, Изношенность оружия, Прнадлежность лицензии к ID игрока, Тип крепления аксессуара)
	if(PerishableThing(thingId, thingType)) // Проверка на портящиеся продукты - у них используется Unix (Добавляя испорченный продукт к свежему, портиться должно всё)
	{
	    if(PrisonTableInfo[pt][ptInvPara][i] > 0)
		{
			if(PrisonTableInfo[pt][ptInvPara][i] > thingPara) PrisonTableInfo[pt][ptInvPara][i] = thingPara;
		}
		else PrisonTableInfo[pt][ptInvPara][i] = thingPara;
	}
	else PrisonTableInfo[pt][ptInvPara][i] = thingPara;
	PrisonTableInfo[pt][ptInvQara][i] = thingQara; // Статус краденного предмета
	PrisonTableInfo[pt][ptInvType][i] = thingType; // Тип предмета
	PrisonTableInfo[pt][ptInvPack][i] = thingPack; // Упаковка предмета

    if(playerid == -1) PrisonTableInfo[pt][ptInvPlayer][i] = -1;
    else PrisonTableInfo[pt][ptInvPlayer][i] = PlayerInfo[playerid][pID];
	
	foreach(Player,x)
	{
		if(Tabs_Load[x] != 14) continue;
		if(OnlineInfo[x][oLogged] == 1 && OnlineInfo[x][oShowInterface] == 1 && OnlineInfo[x][oShowTabs] == pt) item_second(x, thingId, PrisonTableInfo[pt][ptInv][i], i, 0, PrisonTableInfo[pt][ptInvPara][i], thingType, thingPack, 0);
	}
	return i;
}

stock shift_prisontable(playerid, pt, getinva, putinva) //  Перемещение предметов внутри инвентаря (с одной ячейки на другую)
{
	if(OnlineInfo[playerid][oShowTabs] != 9999)
	{
		if(PrisonTableInfo[pt][ptInvent][getinva] == 0) return i_resettabs(playerid);
		else if(PrisonTableInfo[pt][ptInvent][putinva] != 0) return 1;
        if(PrisonTableInfo[pt][ptInvPlayer][getinva] > 0 && PrisonTableInfo[pt][ptInvPlayer][getinva] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid, "{FF6347}Это не ваш предмет и вы не можете его перекладывать"), i_resettabs(playerid);
		if(PrisonTableInfo[pt][ptInvPlayer][putinva] > 0 && PrisonTableInfo[pt][ptInvPlayer][putinva] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid, "{FF6347}Это не ваш предмет и вы не можете его перекладывать"), i_resettabs(playerid);

        new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 14) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			new string[80];
			format(string, sizeof(string), "{FF6347}Тумбу просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, string);
			i_resettabs(playerid);
			return 1;
		}
		PrisonTableInfo[pt][ptInvent][putinva] = PrisonTableInfo[pt][ptInvent][getinva];
		PrisonTableInfo[pt][ptInv][putinva] = PrisonTableInfo[pt][ptInv][getinva];
		PrisonTableInfo[pt][ptInvPara][putinva] = PrisonTableInfo[pt][ptInvPara][getinva];
		PrisonTableInfo[pt][ptInvQara][putinva] = PrisonTableInfo[pt][ptInvQara][getinva];
		PrisonTableInfo[pt][ptInvType][putinva] = PrisonTableInfo[pt][ptInvType][getinva];
		PrisonTableInfo[pt][ptInvPack][putinva] = PrisonTableInfo[pt][ptInvPack][getinva];
        PrisonTableInfo[pt][ptInvPlayer][putinva] = PrisonTableInfo[pt][ptInvPlayer][getinva];
		PrisonTableInfo[pt][ptInvent][getinva] = 0;
		PrisonTableInfo[pt][ptInv][getinva] = 0;
		PrisonTableInfo[pt][ptInvPara][getinva] = 0;
		PrisonTableInfo[pt][ptInvQara][getinva] = 0;
		PrisonTableInfo[pt][ptInvType][getinva] = 0;
		PrisonTableInfo[pt][ptInvPack][getinva] = 0;
        PrisonTableInfo[pt][ptInvPlayer][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, 0, 0, getinva, 0, 0, 0, 0, 0);
		item_second(playerid, PrisonTableInfo[pt][ptInvent][putinva], PrisonTableInfo[pt][ptInv][putinva], putinva, 0, PrisonTableInfo[pt][ptInvPara][putinva], PrisonTableInfo[pt][ptInvType][putinva], PrisonTableInfo[pt][ptInvPack][putinva], 0);
	}
	return 1;
}

stock mix_prisontable(playerid, pt, getinva, putinva)
{
	if(OnlineInfo[playerid][oShowTabs] != 9999)
	{
		if(PrisonTableInfo[pt][ptInvent][getinva] == 0) return i_resettabs(playerid);
		if(PrisonTableInfo[pt][ptInvent][putinva] != PrisonTableInfo[pt][ptInvent][getinva]) return i_resettabs(playerid);
        if(PrisonTableInfo[pt][ptInvPlayer][getinva] != PrisonTableInfo[pt][ptInvPlayer][putinva]) return i_resettabs(playerid);

		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 14) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			new string[80];
			format(string, sizeof(string), "{FF6347}Тумбу просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, string);
			i_resettabs(playerid);
			return 1;
		}
		PrisonTableInfo[pt][ptInv][putinva] += PrisonTableInfo[pt][ptInv][getinva];
		if(PrisonTableInfo[pt][ptInvPara][putinva] > PrisonTableInfo[pt][ptInvPara][getinva]) PrisonTableInfo[pt][ptInvPara][putinva] = PrisonTableInfo[pt][ptInvPara][getinva];
		PrisonTableInfo[pt][ptInvQara][putinva] = PrisonTableInfo[pt][ptInvQara][getinva];
		PrisonTableInfo[pt][ptInvType][putinva] = PrisonTableInfo[pt][ptInvType][getinva];
		PrisonTableInfo[pt][ptInvPack][putinva] = PrisonTableInfo[pt][ptInvPack][getinva];
        PrisonTableInfo[pt][ptInvPlayer][putinva] = PrisonTableInfo[pt][ptInvPlayer][getinva];
		PrisonTableInfo[pt][ptInvent][getinva] = 0;
		PrisonTableInfo[pt][ptInv][getinva] = 0;
		PrisonTableInfo[pt][ptInvPara][getinva] = 0;
		PrisonTableInfo[pt][ptInvQara][getinva] = 0;
		PrisonTableInfo[pt][ptInvType][getinva] = 0;
		PrisonTableInfo[pt][ptInvPack][getinva] = 0;
        PrisonTableInfo[pt][ptInvPlayer][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, PrisonTableInfo[pt][ptInvent][getinva], PrisonTableInfo[pt][ptInvent][getinva], getinva, 0, PrisonTableInfo[pt][ptInvPara][getinva], PrisonTableInfo[pt][ptInvType][getinva], PrisonTableInfo[pt][ptInvPack][getinva], 0);
		item_second(playerid, PrisonTableInfo[pt][ptInvent][putinva], PrisonTableInfo[pt][ptInv][putinva], putinva, 0, PrisonTableInfo[pt][ptInvPara][putinva], PrisonTableInfo[pt][ptInvType][putinva], PrisonTableInfo[pt][ptInvPack][putinva], 0);
	}
	return 1;
}

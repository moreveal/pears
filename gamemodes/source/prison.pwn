
#define MAX_CELL_PRISON 8

new Kpz[MAX_CELL_PRISON]; // id объектов дверей
new KpzDoorStatus[MAX_CELL_PRISON]; // статус дверей
new KpzDoorStatusBreaking[MAX_CELL_PRISON]; // Статус взлома дверей
new OpenCells[2]; // какая сторона камер открыта
new PrisonAlarm; // Статус тревоги в тюрьме
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


stock CreatePrisonAlarm() // Запускаем режим тревоги в тюрьме
{
    if(PrisonAlarm == 1) return 1;

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
    if(!IsAPolice(fraction(playerid))) return ErrorMessage(playerid, "{FF6347}Управление тюрьмой доступно только полицейским");
    if(PlayerInfo[playerid][pJailed] > 0) return ErrorMessage(playerid, "{FF6347}Управление тюрьмой недоступно заключённым");
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
    new vehicleid;
    if(konvoiId == 1) vehicleid = prisonbus_LS; // LS
    else if(konvoiId == 2) vehicleid = prisonbus_SF; // SF

    if(IsVehicleInRangeOfPoint(vehicleid, 10.0, 1601.9800,-1618.8779,13.6866)
        || IsVehicleInRangeOfPoint(vehicleid, 10.0, -1577.3424,679.9330,7.3882)) return vehicleid; // Автобусы на месте
    return 0;
}

stock dialogCase_Prison(playerid, dialogid, response, listitem)
{
    if(dialogid == 532)
    {
        if(response)
        {
            new konvoiId = DP[0][playerid];
            if(listitem == 0)
            {
                if(PlayerInfo[playerid][pJailTime] <= 600) return ErrorMessage(playerid, "{FF6347}Ваш срок заключения меньше 10 минут\n{cccccc}Нет необходимости конвоировать вас в областную тюрьму");
                
                new vehicleid = GetPrisonBusLocation(konvoiId);
                if(!vehicleid) return ErrorMessage(playerid, "{FF6347}Тюремный автобус в данный момент выполняет конвой\n{cccccc}Пожалуйста, подождите. Он прибудет обратно примерно через 10 минут");

                CuffedPlayer(playerid, 9999);
                S_SetPlayerVirtualWorld(playerid,0,0);
		        SetPlayerInterior(playerid,0);

                if(vehicleid == prisonbus_LS)
                {
                    if(!TimerPrisonBusLS && PrisonBusRouteLS == 0) TimerPrisonBusLS = SetTimerEx("PrisonGo", 30000, false, "dd", NpcPrisonLS, prisonbus_LS);
                    switch(random(3))
                    {
                        case 0: PPSetPlayerPos(playerid,1604.8387,-1611.0654,13.5175);
                        case 1: PPSetPlayerPos(playerid,1603.3575,-1611.1398,13.5016);
                        default: PPSetPlayerPos(playerid,1605.9177,-1611.5446,13.5291);
                    }
                    SetPlayerFacingAngle(playerid,180.0);
                }
                else if(vehicleid == prisonbus_SF)
                {
                    if(!TimerPrisonBusSF && PrisonBusRouteSF == 0) TimerPrisonBusSF = SetTimerEx("PrisonGo", 30000, false, "dd", NpcPrisonSF, prisonbus_SF);
                    switch(random(3))
                    {
                        case 0: PPSetPlayerPos(playerid,-1580.0209,686.4322,7.1875);
                        case 1: PPSetPlayerPos(playerid,-1580.8610,686.3076,7.1875);
                        default: PPSetPlayerPos(playerid,-1579.2289,685.9234,7.1875);
                    }
                    SetPlayerFacingAngle(playerid,180.0);
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
                if(PrisonAlarm == 0) CreatePrisonAlarm();
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
            if(get_invent2(playerid, 19, 0) == 0) return ErrorMessage(playerid,"{ff6347} У вас нет отмычек [Вы можете сделать их на станке из вилки]");
            CreateBreaking(playerid, 4, DP[0][playerid], 0);
        }
    }
    return 1;
}


stock PrisonMovingPoster(playerid,number)
{
    if(IsACop(playerid)) 
    {
        PrisonMovingBackPoster(number);
        PrisonBetonHP[number] = 3000;
        PrisonMovingBeton(number,0);
    }
    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, a_flood[2][playerid]);
    a_flood[2][playerid] = current_tick;
    if(interval < 500) return 0;
    if(PrisonPosterStatus[number] == 0) PrisonPosterStatus[number] = 1,PrisonMovingDownPoster(number);
    else if(PrisonPosterStatus[number] == 1) PrisonPosterStatus[number] = 0,PrisonMovingBackPoster(number);
    return 1;
}

CMD:movingbeton(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return 0;
    new moving,number;
    sscanf(params, "ii",number,moving);
    PrisonMovingBeton(number,moving*75);
    PrisonMovingSand(number,moving*75);
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
    new interval = GetTickDiff(current_tick, a_flood[2][playerid]);
    a_flood[2][playerid] = current_tick;
    if(interval < 500) return 0;
    new mod,string[60];
    PrisonBetonHP[number]--;
    mod = PrisonBetonHP[number] % 75;
    if(mod != 0)
    {
        format(string, sizeof(string), RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Бетон: ~w~%d/3000"),PrisonBetonHP[number]);
	 	GameTextForPlayer(playerid,string, 1500, 3);
        ApplyAnimation(playerid,"SWORD","sword_4",2.0,0,0,0,0,0,1);
    }
    else
    {
        new count;
        count = 40-(PrisonBetonHP[number]/75);
        PrisonSandStatus[number]++;
        PrisonMovingBeton(number,count);
        PrisonMovingSand(number,PrisonSandStatus[number]);
        format(string, sizeof(string), RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Бетон: ~w~%d/3000"),PrisonBetonHP[number]);
	 	GameTextForPlayer(playerid,string, 1500, 3);
        SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Чёрт, тут много песка, нужно бы убрать его метлой!");
        ApplyAnimation(playerid,"SWORD","sword_4",2.0,0,0,0,0,0,1);
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
    ApplyAnimation(playerid,"PED","flee_lkaround_01",4.0,0,0,0,0,0,1);
    SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я убрал песок, надо вернуть швабру на место!");
    return 1;
}

stock PrisonEscape(playerid)
{
    if(PlayerInfo[playerid][pJailed] > 0) return 0;
    new cell = IsABeton(playerid);
    PrisonMovingBackPoster(cell);
    PrisonBetonHP[cell] = 3000;
    PrisonMovingBeton(cell,0);
    CreatePrisonAlarm();
    keep(playerid);
    PPSetPlayerPos(playerid,233.1846,1874.0150,929.6272);
    S_SetPlayerVirtualWorld(playerid,241,0), SetPlayerInterior(playerid,241);
    SetPlayerFacingAngle(playerid,327.5);
    SetPlayerCriminal(0,playerid, -1,"Побег из тюрьмы",6, 0);
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
    new string[86];
    format(string,sizeof(string),"UPDATE `pp_igroki` SET `PrisonPipeUnix` = '%d' WHERE `id` = '%d'",PlayerInfo[playerid][pPrisonPipeUnix], PlayerInfo[playerid][pID]);
    query_empty(pearsq, string);
    SuccessMessage(playerid,"{66ff99}Вы взяли трубу, из неё вы можете сделать монтировку на станке");
    ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0,0,1,1,0,0);
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
    new string[86];
    format(string,sizeof(string),"UPDATE `pp_igroki` SET `PrisonSpoonUnix` = '%d' WHERE `id` = '%d'",PlayerInfo[playerid][pPrisonSpoonUnix], PlayerInfo[playerid][pID]);
    query_empty(pearsq, string);
    SuccessMessage(playerid,"{66ff99}Вы взяли вилку, из неё вы можете сделать заточку на станке");
    ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0,0,1,1,0,0);
    return 1;
}
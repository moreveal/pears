
#define MAX_CELL_PRISON 8

new Kpz[MAX_CELL_PRISON]; // id объектов дверей
new KpzDoorStatus[MAX_CELL_PRISON]; // статус дверей
new OpenCells[2]; // какая сторона камер открыта
new PrisonAlarm; // Статус тревоги в тюрьме
new PrisonAlarmObject[2]; // id объектов красной лампы тревоги
new PrisonTabloObject[2]; // id объектов табло оповещения в тюрьме
new OpenBlock[2]; // Какая часть тюрьмы сейчас доступна для посещения
new BlockSwitch;
new BlockDoorPrison[3]; // Двери внутри тюрьмы (Блоки)
new BlockDoorPrisonStatus[3]; // Статус дверей тюрьмы (блоки)

stock ReopenPrison(side) // Каждые 10 минут переключаем стороны блоков
{
    if(PrisonAlarm == 0) return 1; // Если включена тревога, мы не меняем никакие стороны

    if(side == 0) OpenPrisonCells(0); // Открываем левые камеры
    else OpenPrisonCells(1); // Открываем правые камеры

    // Меняем стороны тюремных блоков
    SwitchPrisonBlock();
    return 1;
}

stock SwitchPrisonBlock()
{
    if(BlockSwitch == 0)
    {
        BlockSwitch = 1;
        OpenBlock[0] = 1;
        OpenBlock[1] = 0;
        UpdateTabloPrisonInfo(0, 10);
        UpdateTabloPrisonInfo(1, 20);
    }
    else
    {
        BlockSwitch = 0;
        OpenBlock[0] = 0;
        OpenBlock[1] = 1;
        UpdateTabloPrisonInfo(0, 20);
        UpdateTabloPrisonInfo(1, 10);
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
    if(GetPlayerVirtualWorld(playerid) == 181 && GetPlayerInterior(playerid) == 181)
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
        if(BlockDoorPrisonStatus[blockdoor] == 1) return 1; // Если дверь и так открыта, то нам не нужно с ней взаимодействовать
        // Сюда вставляем проверки на наличие ключ карты
        // Если есть ключ карта, открываем дверь (Две верхние строчки берём Sound и SwitchPrisonBlockDoor)
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
    else OpenDoorPrison(cell);
    return 1;
}
stock IsPlayerDoorPrisonCellNearby(playerid) // Получаем номер камеры, у которой стоим
{
    if(GetPlayerVirtualWorld(playerid) == 181 && GetPlayerInterior(playerid) == 181)
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
        if(KpzDoorStatus[cell] == 1) return 1; // Если дверь и так открыта, то нам не нужно с ней взаимодействовать
        // Сюда вставляем диалоговое окно типо: Вы хотите взломать дверь?
        // После того как чел нажал да, узнаём есть ли у него отмычки и отправляем его в CreateBreaking
    }
    return 1;
}


stock PisonAlarm() // Запускаем режим тревоги в тюрьме
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
    return 1;
}
stock PrisonStopAlarm() // Выключаем режим тревоги в тюрьме
{
    if(PrisonAlarm == 0) return 1;

    PrisonAlarm = 0;
    SetDynamicObjectMaterial(PrisonAlarmObject[0], 0, 11751, "enexmarkers", "enexmarker4-2", 0x00FFFFFF);
    SetDynamicObjectMaterial(PrisonAlarmObject[1], 0, 11751, "enexmarkers", "enexmarker4-2", 0x00FFFFFF);
    return 1;
}
stock UpdateTabloPrisonInfo(side, plusmin) // Обновляем инфу на табло
{
    new string[34], nextonehour, nextoneminute;
    new tmphour, tmpminute;
    if(plusmin == 10)
    {
        NextHourandMinute(plusmin, tmphour, tmpminute, nextonehour, nextoneminute);
        format(string,sizeof(string), "Open %d:%d - %d:%d", tmphour, tmpminute, nextonehour, nextoneminute);
        SetDynamicObjectMaterialText(PrisonTabloObject[side], 0, string, 130, "Arial", 27, 1, 0xFFAAAAAA, 0x00000000, 1);
    }
    else if(plusmin == 20)
    {
        new nexttwohour, nexttwominute;
        NextHourandMinute(plusmin - 10, tmphour, tmpminute, nextonehour, nextoneminute);
        NextHourandMinute(plusmin, tmphour, tmpminute, nexttwohour, nexttwominute);

        format(string,sizeof(string), "Open %d:%d - %d:%d", nextonehour, nextoneminute, nexttwohour, nexttwominute);
        SetDynamicObjectMaterialText(PrisonTabloObject[side], 0, string, 130, "Arial", 27, 1, 0xFFAAAAAA, 0x00000000, 1);
    }
    return 1;
}
stock NextHourandMinute(plusmin, &tmphour, &tmpminute, &nexthour, &nextmin)
{
    new tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);

    nextmin = tmpminute + plusmin;
    if(nextmin >= 60)
    {
        nextmin = 0;
        nexthour = tmphour + 1;
        if(nexthour >= 24) nexthour = 0;
    }
    return 1;
}




/*
Создай объекты плаката, бетона и песка - в том же месте в моде, где я поставил создание дверей. Например ищи по Kpz[0] = 

Плакат смещаем с помощью SetDynamicObjectPos в другую точку
// Тут стартовые позиции плакатов, где они и должны висеть
tmpobjid = CreateDynamicObject(2587, 1056.074340, 2435.324707, 11.373860, 0.000000, 0.000000, 180.000000, 181, 181, -1, 300.00, 300.00); // plakat_camera1
tmpobjid = CreateDynamicObject(2587, 1049.342407, 2435.324707, 11.413865, 0.000000, -0.000007, 179.999954, 181, 181, -1, 300.00, 300.00); // plakat_camera2
tmpobjid = CreateDynamicObject(2587, 1042.610839, 2435.324707, 11.413865, 0.000000, -0.000014, 179.999908, 181, 181, -1, 300.00, 300.00); // plakat_camera3
tmpobjid = CreateDynamicObject(2587, 1035.878173, 2435.324707, 11.413865, 0.000000, -0.000022, 179.999862, 181, 181, -1, 300.00, 300.00); // plakat_camera4
tmpobjid = CreateDynamicObject(2587, 1035.864746, 2461.499755, 11.413865, 0.000000, 0.000007, -0.000014, 181, 181, -1, 300.00, 300.00); // plakat_camera5
tmpobjid = CreateDynamicObject(2587, 1042.597290, 2461.499755, 11.413865, 0.000000, 0.000000, -0.000060, 181, 181, -1, 300.00, 300.00); // plakat_camera6
tmpobjid = CreateDynamicObject(2587, 1049.328857, 2461.499755, 11.413865, 0.000000, -0.000007, -0.000105, 181, 181, -1, 300.00, 300.00); // plakat_camera7
tmpobjid = CreateDynamicObject(2587, 1056.061523, 2461.499755, 11.413865, 0.000000, -0.000014, -0.000151, 181, 181, -1, 300.00, 300.00); // plakat_camera8

// Тут координаты куда плакаты нужно ставить, когда мы их снимаем со стены
tmpobjid = CreateDynamicObject(2587, 1057.385375, 2435.324707, 11.073853, 0.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00); // plakat_camera1
tmpobjid = CreateDynamicObject(2587, 1050.642700, 2435.324707, 11.073857, 0.000000, -0.000007, 179.999954, object_world, object_int, -1, 300.00, 300.00); // plakat_camera2
tmpobjid = CreateDynamicObject(2587, 1043.931396, 2435.324707, 11.073857, 0.000000, -0.000021, 179.999862, object_world, object_int, -1, 300.00, 300.00); // plakat_camera3
tmpobjid = CreateDynamicObject(2587, 1037.208251, 2435.324707, 11.083859, 0.000000, -0.000022, 179.999862, object_world, object_int, -1, 300.00, 300.00); // plakat_camera4
tmpobjid = CreateDynamicObject(2587, 1034.543579, 2461.499755, 11.083859, 0.000000, 0.000007, -0.000014, object_world, object_int, -1, 300.00, 300.00); // plakat_camera5
tmpobjid = CreateDynamicObject(2587, 1041.306152, 2461.499755, 11.083861, -0.000000, 0.000007, -0.000060, object_world, object_int, -1, 300.00, 300.00); // plakat_camera6
tmpobjid = CreateDynamicObject(2587, 1048.008422, 2461.499755, 11.083857, 0.000000, -0.000007, -0.000105, object_world, object_int, -1, 300.00, 300.00); // plakat_camera7
tmpobjid = CreateDynamicObject(2587, 1054.750854, 2461.499755, 11.083860, 0.000000, -0.000014, -0.000151, object_world, object_int, -1, 300.00, 300.00); // plakat_camera8


Бетон внутри стены сдвигаем по Y координате (Когда долбим стену монтировкой)
2434.759033 - это дефолтная позиция левых камер (1 - 4)
2434.338623 - это позиция, когда бетона уже не видно, значит всю дырку раздолбили
tmpobjid = CreateDynamicObject(2068, 1056.106689, 2434.759033, 12.263865, 90.000000, 0.000000, 0.000000, 181, 181, -1, 300.00, 300.00); // beton_camera1 (y sdvig)
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(2068, 1049.374145, 2434.759033, 12.263865, 89.999992, 89.999992, -89.999992, 181, 181, -1, 300.00, 300.00); // beton_camera2
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(2068, 1042.642578, 2434.759033, 12.263865, 89.999992, 89.999992, -89.999977, 181, 181, -1, 300.00, 300.00); // beton_camera3
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(2068, 1035.909912, 2434.759033, 12.263865, 89.999992, 90.000000, -89.999969, 181, 181, -1, 300.00, 300.00); // beton_camera4
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);

2462.065429 - это дефолтная позиция правых камер (5 - 8)
2462.495894 - позиция, когда бетона не видно
tmpobjid = CreateDynamicObject(2068, 1035.833007, 2462.065429, 12.263865, 89.999992, 224.971710, -44.971794, 181, 181, -1, 300.00, 300.00); // beton_camera5
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(2068, 1042.565551, 2462.065429, 12.263865, 89.999992, 224.950515, -44.950569, 181, 181, -1, 300.00, 300.00); // beton_camera6
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(2068, 1049.297119, 2462.065429, 12.263865, 89.999992, 224.934020, -44.934055, 181, 181, -1, 300.00, 300.00); // beton_camera7
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(2068, 1056.029785, 2462.065429, 12.263865, 89.999992, 224.934020, -44.934055, 181, 181, -1, 300.00, 300.00); // beton_camera8
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);


Песок под поднимаем из под пола по Z координате. И опускаем обратно, когда моем пол шваброй
tmpobjid = CreateDynamicObject(16302, 1055.898559, 2434.780029, 4.45, 0.000000, 0.000000, 0.000000, 181, 181, -1, 300.00, 300.00); // sand_camera1 (min 4.45) (max 4.85) plus 0.001 (do 0.40)
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(16302, 1049.177124, 2434.780029, 4.45, 0.000000, 0.000000, 0.000000, 181, 181, -1, 300.00, 300.00); // sand_camera2
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(16302, 1042.404785, 2434.780029, 4.45, 0.000000, 0.000000, 0.000000, 181, 181, -1, 300.00, 300.00); // sand_camera3
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(16302, 1035.724365, 2434.780029, 4.45, 0.000000, 0.000000, 0.000000, 181, 181, -1, 300.00, 300.00); // sand_camera4
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(16302, 1036.041137, 2462.044433, 4.45, 0.000000, -0.000007, 179.999847, 181, 181, -1, 300.00, 300.00); // sand_camera5
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(16302, 1042.762573, 2462.044433, 4.45, 0.000000, -0.000007, 179.999847, 181, 181, -1, 300.00, 300.00); // sand_camera6
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(16302, 1049.534912, 2462.044433, 4.45, 0.000000, -0.000007, 179.999847, 181, 181, -1, 300.00, 300.00); // sand_camera7
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
tmpobjid = CreateDynamicObject(16302, 1056.215332, 2462.044433, 4.45, 0.000000, -0.000007, 179.999847, 181, 181, -1, 300.00, 300.00); // sand_camera8
SetDynamicObjectMaterial(tmpobjid, 0, 10755, "airportrminl_sfse", "ws_rotten_concrete1", 0x00000000);
*/

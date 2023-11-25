
new NpcArmy;
new npcarmyid;
new TrainRoadID;
new NextTrainRoadID;
new Float:speedTrain;
new Float:speedGo;
new TrainStoped = 1;
new TrainGear;
new TrainGearDelay;
new TrainMoved;
new MoveStatus; // 0 Разгон, 1 Торможение
new ruinsOnTrainRoad;

stock CreateNPC()
{
    NpcArmy = FCNPC_Create("John");
    npcarmyid = GetMaxPlayers() - 1; // id бота
    FCNPC_Spawn(NpcArmy, 287, 53.8143,1275.7471,16.7148);
    SetPlayerColor(npcarmyid, 0x336633FF);
    FCNPC_SetInvulnerable(NpcArmy, true); // Неубиваемый
    FCNPC_PutInVehicle(NpcArmy, train, 0);
    return 1;
}

public FCNPC_OnUpdate(npcid)
{
    if(GetPlayerState(npcid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(npcid);
		new Float:vhp, Float:maxhp = MaxVehicleHealth(VehInfo[vehicleid][vModel]);
		GetVehicleHealth(vehicleid, vhp);
        if(vhp < maxhp) VehInfo[vehicleid][vHealth] = maxhp, SetVehicleHealth(vehicleid, maxhp);
    }
    return 1;
}

CMD:traingo(playerid)
{
    if(TrainMoved == 1) return ErrorMessage(playerid, "{FF6347}Остановите поезд /trainstop");
    if(TrainStoped == 0) return ErrorMessage(playerid, "{FF6347}Дождитесь остановки поезда");

    TrainGear = 0;
    TrainGearSet(1);

    MoveStatus = 0;
    TrainStoped = 0;
    TrainMoved = 1;
    TrainGearDelay = 0;

    FindNextTrainRoad();
    GoTrainRoad();

    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Поихали","*","");
    return 1;
}

CMD:trainstop(playerid)
{
    if(TrainMoved == 0) return ErrorMessage(playerid, "{FF6347}Поезд стоит на месте");
    if(MoveStatus == 1) return ErrorMessage(playerid, "{FF6347}Поезд уже останавливается");
    if(TrainStoped == 1) return ErrorMessage(playerid, "{FF6347}Дождитесь остановки поезда");
    MoveStatus = 1;
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}останавливаем поезд","*","");
    return 1;
}
// /npcgo -0.3150 1.7
stock FindNextTrainRoad()
{
    new maxTrainRoad = sizeof(TrainRoad);
    new plus;

    if(MoveStatus == 1) // При остановке прыгаем по меньшему количеству поинтов
    {
        if(TrainGear >= 5) plus = 5;
        else plus = 2;
    }
    else plus = 5;

    NextTrainRoadID = TrainRoadID + plus;
    if(NextTrainRoadID >= maxTrainRoad)
    {
        NextTrainRoadID = 0;
    }
    TrainRoadID = NextTrainRoadID;
    return 1;
}

stock GoTrainRoad()
{
    FCNPC_GoTo(NpcArmy, TrainRoad[TrainRoadID][TrainRoad_X], TrainRoad[TrainRoadID][TrainRoad_Y], TrainRoad[TrainRoadID][TrainRoad_Z], FCNPC_MOVE_TYPE_AUTO, speedGo);
    FCNPC_SetVehicleTrainSpeed(NpcArmy, speedTrain);
    return 1;
}

public FCNPC_OnReachDestination(npcid)
{
    if(TrainStoped == 1)
    {
        TrainMoved = 0;
        FCNPC_SetVehicleTrainSpeed(NpcArmy, 0.0);
        FCNPC_Stop(NpcArmy);
        FindPointSideTrain();
    }
    else
    {
        if(MoveStatus == 0) // Разгоняем поезд
        {
            TrainGearDelay ++;
            if(TrainGear == 1 || TrainGear == 2
                ||TrainGear == 3 && TrainGearDelay >= 1
                || TrainGear == 4 && TrainGearDelay >= 2
                || TrainGear == 5 && TrainGearDelay >= 4
                || TrainGear == 6 && TrainGearDelay >= 6
                || TrainGear == 7 && TrainGearDelay >= 8
                || TrainGear == 8 && TrainGearDelay >= 10) TrainGearSet(1);
        }
        else if(MoveStatus == 1) // Тормозим поезд
        {
            TrainGearSet(0);
        }

        if(MoveStatus == 0)
        {
            ruinsOnTrainRoad = IsRuinsOnTrainRoad(); // Ищем руины бомбы на путях перед поездом
            if(ruinsOnTrainRoad >= 0) // Нашли, спереди есть руины
            {
                new pointsToRuins = ruinsOnTrainRoad - TrainRoadID; // Считаем точки до руин
                if(pointsToRuins <= GetPointToStopTrain() - 4) // Точек до руин столько-же сколько до полной остановки - Начинаем тормозить
                {
                    MoveStatus = 1;

                    // Пишем сообщение всем, кто едет на поезде
                    foreach(Player,i)
                    {
                        if(OnlineInfo[i][oLogged] == 0) continue;
                        if(GetPlayerState(i) != PLAYER_STATE_ONFOOT) continue;

                        new surf = GetPlayerSurfingVehicleID(i);
                        if(surf != INVALID_VEHICLE_ID) // Сёрфим
                        {
                            new model = GetVehicleModel(surf);
                            if(IsATrain(model)) MessageTrainStop(i);
                        }
                    }
                }
            }
        }

        FindNextTrainRoad();
        GoTrainRoad();
    }
    return 1;
}

stock GetPointToStopTrain()
{
    new point;
    if(TrainGear == 9) point = 5 * 5 + 4 * 2;
    else if(TrainGear == 8) point = 4 * 5 + 4 * 2;
    else if(TrainGear == 7) point = 3 * 5 + 4 * 2;
    else if(TrainGear == 6) point = 2 * 5 + 4 * 2;
    else if(TrainGear == 5) point = 1 * 5 + 4 * 2;
    else if(TrainGear <= 4) point = TrainGear * 2;
    return point;
}

stock TrainGearSet(stat)
{
    if(stat == 1) // Повышаем передачу
    {
        if(TrainGear == 0) TrainGear = 1, speedTrain = -0.0200, speedGo = 0.1;
        else if(TrainGear == 1) TrainGear = 2, speedTrain = -0.0600, speedGo = 0.3;
        else if(TrainGear == 2) TrainGear = 3, speedTrain = -0.0980, speedGo = 0.5;
        else if(TrainGear == 3) TrainGear = 4, speedTrain = -0.1730, speedGo = 0.9;
        else if(TrainGear == 4) TrainGear = 5, speedTrain = -0.2450, speedGo = 1.3;
        else if(TrainGear == 5) TrainGear = 6, speedTrain = -0.3135, speedGo = 1.7;
        else if(TrainGear == 6) TrainGear = 7, speedTrain = -0.4130, speedGo = 2.3;
        else if(TrainGear == 7) TrainGear = 8, speedTrain = -0.4950, speedGo = 2.8;
        else if(TrainGear == 8) TrainGear = 9, speedTrain = -0.5930, speedGo = 3.5;
    }
    else if(stat == 0) // Понижаем передачу
    {
        if(TrainGear == 9) TrainGear = 8, speedTrain = -0.4950, speedGo = 2.8;
        else if(TrainGear == 8) TrainGear = 7, speedTrain = -0.4130, speedGo = 2.3;
        else if(TrainGear == 7) TrainGear = 6, speedTrain = -0.3135, speedGo = 1.7;
        else if(TrainGear == 6) TrainGear = 5, speedTrain = -0.2450, speedGo = 1.3;
        else if(TrainGear == 5) TrainGear = 4, speedTrain = -0.1730, speedGo = 0.9;
        else if(TrainGear == 4) TrainGear = 3, speedTrain = -0.0980, speedGo = 0.5;
        else if(TrainGear == 3) TrainGear = 2, speedTrain = -0.0600, speedGo = 0.3, TrainStoped = 1;
        else if(TrainGear == 2) TrainGear = 1, speedTrain = -0.0200, speedGo = 0.1, TrainStoped = 1;
        else if(TrainGear == 1) TrainStoped = 1;
    }
    TrainGearDelay = 0;

    format(store,sizeof(store),"машинист переключает поезд на %d передачу", TrainGear);
	SetPlayerChatBubble(npcarmyid, store, COLOR_PURPLE, 30.0, 3000);
    return 1;
}

stock IsRuinsOnTrainRoad() // Ищем руины по пути поезда
{
    new trainPoint = -1;
    for(new r; r < MAX_OBJECT_RUINS; ++r)
	{
        if(RuinsInfo[r][boStat] == 0) continue;
        if(RuinsInfo[r][boTrainRoad] <= 0) continue; // Пропускаем, если руины лежат не на жд путях

        if(RuinsInfo[r][boTrainRoad]-1 > TrainRoadID) // Руины только где-то впереди пути
        {
            trainPoint = RuinsInfo[r][boTrainRoad] - 1;
        }
    }
    return trainPoint;
}

stock MessageTrainStop(playerid)
{
    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"{FF6347}Внимание! {336633}Впереди обнаружено повреждение железнодорожных путей"), strcat(lines,line);
    format(line,sizeof(line),"\n\n{cccccc}- Поезд плавно остановится перед препятствием"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}- Вы не можете продолжить движение, пока не устраните причину"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}- Вероятно это было устроено намеренно, с целью остановить поезд"), strcat(lines,line);
    format(line,sizeof(line),"\n\n{336633}Защищайте груз любой ценой!"), strcat(lines,line);
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");

    SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ Train ]: {ffcc66}Впереди обнаружено повреждение путей. Защищайте груз!");
    PlayerPlaySound(playerid,6001,0,0,0);

    SetTimerEx("around_audiostop", 5000, false, "dd", playerid, 6004); // Таймер на выключение сирены
    return 1;
}
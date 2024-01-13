
// Army Train
new NpcArmy;
new NextTrainRoadID;
new Float:speedTrain;
new Float:speedGo;
new TrainStoped = 1;
new TrainGearDelay;
new MoveStatus; // 0 Разгон, 1 Торможение

// Prison Bus
new NpcPrisonLS;
new npcprisonid_ls;
new prisonbus_LS; // Тюремный Автобус
new PrisonBusRouteLS;
new TimerPrisonBusLS;

new NpcPrisonSF;
new npcprisonid_sf;
new prisonbus_SF; // Тюремный Автобус
new PrisonBusRouteSF;
new TimerPrisonBusSF;

stock IsARealNPC(playerid)
{
    if(playerid == npcarmyid 
        || playerid == npcprisonid_ls
        || playerid == npcprisonid_sf) return 1;
    return 0;
}
stock IsAVehicleNPC(vehicleid) // Транспорт, который запрещено мочить
{
    if(vehicleid == train
        || vehicleid == prisonbus_LS
        || vehicleid == prisonbus_SF) return 1;
    return 0;
}

stock CreateNPC()
{
    // Первый NPC
    NpcArmy = FCNPC_Create("John");
    npcarmyid = GetMaxPlayers() - 1; // id бота
    FCNPC_Spawn(NpcArmy, 287, 53.8143,1275.7471,16.7148);
    SetPlayerColor(npcarmyid, 0x336633FF);
    FCNPC_SetInvulnerable(NpcArmy, true); // Неубиваемый
    FCNPC_PutInVehicle(NpcArmy, train, 0);

    // Второй NPC
    NpcPrisonLS = FCNPC_Create("Tim");
    npcprisonid_ls = GetMaxPlayers() - 2; // id бота
    FCNPC_Spawn(NpcPrisonLS, 310, 1541.5563,-1652.7074,13.5574);
    SetPlayerColor(npcprisonid_ls, 0x0066ffFF);
    FCNPC_SetInvulnerable(NpcPrisonLS, true); // Неубиваемый
    FCNPC_PutInVehicle(NpcPrisonLS, prisonbus_LS, 0);

    // Третий NPC
    NpcPrisonSF = FCNPC_Create("Bert");
    npcprisonid_sf = GetMaxPlayers() - 3; // id бота
    FCNPC_Spawn(NpcPrisonSF, 310, -1582.6615,678.2233,7.1875);
    SetPlayerColor(npcprisonid_sf, 0x122faaFF);
    FCNPC_SetInvulnerable(NpcPrisonSF, true); // Неубиваемый
    FCNPC_PutInVehicle(NpcPrisonSF, prisonbus_SF, 0);
    return 1;
}

CMD:gotim(playerid)
{
    if(server != 0) return 0;

    if(PrisonBusRouteLS > 0) return ErrorMessage(playerid, "{FF6347}Этот автобус уже едет");
    PrisonGo(NpcPrisonLS, prisonbus_LS);
    return 1;
}

CMD:gobert(playerid)
{
    if(server != 0) return 0;

    if(PrisonBusRouteSF > 0) return ErrorMessage(playerid, "{FF6347}Этот автобус уже едет");
    PrisonGo(NpcPrisonSF, prisonbus_SF);
    return 1;
}

public FCNPC_OnFinishPlayback(npcid)
{
    if(npcid == NpcPrisonLS)
    {
        if(PrisonBusRouteLS == 1)
        {
            PrisonBusRouteLS = 2;
            MoveDynamicObject(Vorota[88], 1546.0299, -1624.0844, 14.3144, 2), MoveDynamicObject(Vorota[89], 1546.0299, -1636.8300, 14.3144, 2), Statvorota[13] = 10;
            FCNPC_StartPlayingPlayback(NpcPrisonLS, "prison_ls0");
        }
        else if(PrisonBusRouteLS == 2)
        {
            PrisonBusRouteLS = 3;
            MoveDynamicObject(Vorota[0], 901.646667, 2405.245605, 7.121364, 1.5), Statvorota[35] = 10;
            FCNPC_StartPlayingPlayback(NpcPrisonLS, "prison_ls2");
        }
        else if(PrisonBusRouteLS == 3)
        {
            PrisonBusRouteLS = 4;
            MoveDynamicObject(Vorota[2], 901.646667, 2447.422851, 7.121364, 1.5), Statvorota[36] = 10;
            FCNPC_StartPlayingPlayback(NpcPrisonLS, "prison_ls3");
        }
        else if(PrisonBusRouteLS == 4)
        {
            PrisonBusRouteLS = 0;
            SetTimerEx("ComeBackPrisonBus", 10000, false, "dd", npcid, prisonbus_LS); // Таймер для возврата автобуса на место
            ExitPrisonersFromBus(prisonbus_LS);
        }
    }
    else if(npcid == NpcPrisonSF)
    {
        if(PrisonBusRouteSF == 1)
        {
            PrisonBusRouteSF = 2;
            MoveDynamicObject(Vorota[23], -1701.8699, 675.8107, 25.6501, 2), MoveDynamicObject(Vorota[111], -1701.8699, 687.5685, 25.6501, 2), Statvorota[51] = 10;
            FCNPC_StartPlayingPlayback(NpcPrisonSF, "prison_sf2");
        }
        else if(PrisonBusRouteSF == 2)
        {
            PrisonBusRouteSF = 3;
            MoveDynamicObject(Vorota[0], 901.646667, 2405.245605, 7.121364, 1.5), Statvorota[35] = 10;
            FCNPC_StartPlayingPlayback(NpcPrisonSF, "prison_ls2");
        }
        else if(PrisonBusRouteSF == 3)
        {
            PrisonBusRouteSF = 4;
            MoveDynamicObject(Vorota[2], 901.646667, 2447.422851, 7.121364, 1.5), Statvorota[36] = 10;
            FCNPC_StartPlayingPlayback(NpcPrisonSF, "prison_ls3");
        }
        else if(PrisonBusRouteSF == 4)
        {
            PrisonBusRouteSF = 0;
            SetTimerEx("ComeBackPrisonBus", 10000, false, "dd", npcid, prisonbus_SF); // Таймер для возврата автобуса на место
            ExitPrisonersFromBus(prisonbus_SF);
        }
    }
    return 1;
}
function ComeBackPrisonBus(npcid, vehicleid) // Возвращаем автобус на место
{
    ReloadVehicleNPC(vehicleid);
    FCNPC_PutInVehicle(npcid, vehicleid, 0);

    // Оповещение всем, кто сидит в КПЗ
    new line[70],lines[140];
    format(line,sizeof(line),"{ff9000}Тюремный Автобус готов доставить вас в Областную Тюрьму"), strcat(lines,line);
    format(line,sizeof(line),"{ffcc66}Подойдите и нажмите красную кнопку"), strcat(lines,line);

    foreach(Player,i)
	{
        if(GetPVarInt(i,"afksystem") >= 5) continue;
        if(PlayerInfo[i][pJailTime] <= 600) continue;
        if(vehicleid == prisonbus_LS && PlayerInfo[i][pJailed] == 3 // КПЗ LS
            || vehicleid == prisonbus_SF && PlayerInfo[i][pJailed] == 9) // КПЗ SF
        {
            ShowDialog(i,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
            SendClientMessage(i, COLOR_GREY,"[ Мысли ]: Что мне тут делать? Я могу отправиться в областную тюрьму");
        }
    }
    return 1;
}
function PrisonGo(npcid, vehicleid) // Запускаем автобус
{
    if(vehicleid == prisonbus_LS)
    {
        TimerPrisonBusLS = 0;
        PrisonBusRouteLS = 1;
        GetVehicleParamsEx(prisonbus_LS, engine, lights, alarm, doors, bonnet, boot, objective);
	    SetVehicleParamsEx(prisonbus_LS, true, true, alarm, doors, bonnet, boot, objective);

        FCNPC_StartPlayingPlayback(NpcPrisonLS, "prison_ls1");
    }
    else if(vehicleid == prisonbus_SF)
    {
        TimerPrisonBusSF = 0;
        PrisonBusRouteSF = 1;
        GetVehicleParamsEx(prisonbus_SF, engine, lights, alarm, doors, bonnet, boot, objective);
	    SetVehicleParamsEx(prisonbus_SF, true, true, alarm, doors, bonnet, boot, objective);

        FCNPC_StartPlayingPlayback(NpcPrisonSF, "prison_sf1");
    }
    return 1;
}
stock ExitPrisonersFromBus(vehicleid)
{
    foreach(Player,i)
	{
        if(PlayerInfo[i][pJailed] == 0) continue;
        if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == vehicleid)
        {
            PlayerInfo[i][pJailed] = 1;
            PPSpawnPlayer(i);
            SuccessMessage(i, "{99ff66}Вас конвоировали в областную тюрьму San Andreas");
        }
    }
    return 1;
}
stock ReloadVehicleNPC(vehicleid)
{
    PP_SetVehicleToRespawn(vehicleid);
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, false, false, alarm, doors, bonnet, boot, objective);
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

CMD:gettrainpoint(playerid) // VREMENNO
{
    SendClientMessagef(playerid, -1, "Train Point: %d", TrainRoadID);
    return 1;
}

CMD:traingo(playerid, const params[])
{
    if(server != 0) return 0;
    if(TrainMoved == 1) return ErrorMessage(playerid, "{FF6347}Остановите поезд /trainstop");

    if(sscanf(params, "i", params[0])) return ErrorMessage(playerid, "{FF6347}/traingo TrainRoadDestination (В какую точку едем)");
    if(TrainRoadID == params[0]) return ErrorMessage(playerid, "{FF6347}Поезд уже в этой точке");

    if(BoxInTrain <= 0) BoxInTrain = 1; // Типо есть ящики
    TrainRoadDestination = params[0]; // 311 SF, 807 LS, 1181 LV, 0 NGSA

    TrainStart();
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Движение поезда запущено","*","");
    return 1;
}

function TrainStart()
{
    if(TrainMoved == 1) return 1;

    DestroyTrainBox();

    ReasonToStopTrain = 0;
	TrainGear = 0;
    TrainGearSet(1);

    MoveStatus = 0;
    TrainStoped = 0;
    TrainMoved = 1;
    TrainGearDelay = 0;

    FindNextTrainRoad();
    GoTrainRoad();
	return 1;
}

CMD:trainstop(playerid)
{
    if(server != 0) return 0;
    if(TrainMoved == 0) return ErrorMessage(playerid, "{FF6347}Поезд стоит на месте");
    if(MoveStatus == 1) return ErrorMessage(playerid, "{FF6347}Поезд уже останавливается");
    if(TrainStoped == 1) return ErrorMessage(playerid, "{FF6347}Дождитесь остановки поезда");
    MoveStatus = 1;
    ReasonToStopTrain = 0;
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Останавливаем поезд","*","");
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
    if(npcid == NpcArmy)
    {
        // Ставим поезд на новую позицию
        if(TrainRoadID <= 290 || TrainRoadID >= 320) SetVehiclePos(train, TrainRoad[TrainRoadID][TrainRoad_X], TrainRoad[TrainRoadID][TrainRoad_Y], TrainRoad[TrainRoadID][TrainRoad_Z]);

        if(TrainStoped == 1)
        {
            TrainMoved = 0;
            TrainGoing = 0;
            FCNPC_Stop(NpcArmy);
            FCNPC_SetVehicleTrainSpeed(NpcArmy, 0.0);
            FCNPC_SetSpeed(NpcArmy, 0.0);

            if(ReasonToStopTrain > 0) CreateTrainBox();
            else
            {
                // Пишем сообщение всем, кто едет в поезде
                foreach(Player,i)
                {
                    if(OnlineInfo[i][oLogged] == 0) continue;
                    if(GetPlayerVirtualWorld(i) == 180 && GetPlayerInterior(i) == 179 
                        || OnlineInfo[i][oWindowTrain] > 0) MessageTrainStopInfo(i);
                }
            }
            DestroyObjectTrain();
            CreateObjectTrain();
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
                // Проверка наличия ящиков при движении
                if(TrainRoadDestination != 0 && BoxInTrain <= 0) TrainRoadDestination = 0; // Если мы едет не на базу и в поезде нет ящиков - отправляем на базу

                // Ищем остановку на нужной станции
                new pointsToStop;
                if(TrainRoadDestination == 0) pointsToStop = sizeof(TrainRoad) - TrainRoadID + 1;
                else
                {
                    if(TrainRoadID < TrainRoadDestination) pointsToStop = TrainRoadDestination - TrainRoadID; 
                }
                if(pointsToStop <= GetPointToStopTrain() + 2)
                {
                    MoveStatus = 1;
                    ReasonToStopTrain = 0;
                }
                
                // Ищем руины бомбы на путях перед поездом
                if(BoxInTrain > 0 && server > 0 || server == 0) // Только если в поезде есть ящики (Если нет, нам насрать на развалины, поезд должен вернуться to NGSA Station)
                {
                    new ruinsOnTrainRoad = IsRuinsOnTrainRoad();
                    if(ruinsOnTrainRoad >= 0) // Нашли, спереди есть руины
                    {
                        // Считаем точки до руин
                        new pointsToRuins = GetPointToRuinsOnTrain(ruinsOnTrainRoad);

                        if(pointsToRuins <= GetPointToStopTrain() + 6  // Точек до руин столько-же сколько до полной остановки - Начинаем тормозить
                            && pointsToRuins >= GetPointToStopTrain() / 2) // Но не меньше половины, ибо нахер нам стопать поезд, если руины появились перед еблом слишком резко
                        {
                            SetDynamicObjectMaterial(TrainLampObject, 0, 19063, "xmasorbs", "sphere", 0xFFFF0000);

                            MoveStatus = 1;
                            ReasonToStopTrain = ruinsOnTrainRoad + 1; // Тормозим по причине конкретного id руин

                            // Пишем сообщение всем, кто едет в поезде
                            foreach(Player,i)
                            {
                                if(OnlineInfo[i][oLogged] == 0) continue;
                                if(GetPlayerVirtualWorld(i) == 180 && GetPlayerInterior(i) == 179 
                                    || OnlineInfo[i][oWindowTrain] > 0) MessageTrainStop(i);
                            }
                        }
                    }
                }
            }

            FindNextTrainRoad();
            GoTrainRoad();
        }
    }
    return 1;
}

stock GetPointToRuinsOnTrain(ruinsOnTrainRoad)
{
    new pointsToRuins;
    if(ruinsOnTrainRoad > TrainRoadID) pointsToRuins = ruinsOnTrainRoad - TrainRoadID;
    else
    {
        new tempFinalPoint = sizeof(TrainRoad) - TrainRoadID; // Сколько осталось точек до завершения кольца маршрута
        pointsToRuins += tempFinalPoint + ruinsOnTrainRoad;
    }
    return pointsToRuins;
}

stock GetPointToStopTrain()
{
    new point;
    if(TrainGear == 9) point = 5 * 5 + 3 * 2;
    else if(TrainGear == 8) point = 4 * 5 + 3 * 2;
    else if(TrainGear == 7) point = 3 * 5 + 3 * 2;
    else if(TrainGear == 6) point = 2 * 5 + 3 * 2;
    else if(TrainGear == 5) point = 1 * 5 + 3 * 2;
    else if(TrainGear <= 4) point = TrainGear * 2; // Последняя передача не считается при торможении (-2)
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
        else if(TrainGear == 3) TrainGear = 2, speedTrain = -0.0600, speedGo = 0.3, TrainStoped = 1; // Останавливаем, после завершения цикла 2-ой передачи
        else if(TrainGear == 2) TrainGear = 1, speedTrain = -0.0200, speedGo = 0.1, TrainStoped = 1;
        else if(TrainGear == 1) TrainStoped = 1;
    }
    TrainGearDelay = 0;

    new string[50];
    format(string,sizeof(string),"машинист переключает поезд на %d передачу", TrainGear);
	SetPlayerChatBubble(npcarmyid, string, COLOR_PURPLE, 30.0, 3000);
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
        else // Спереди нет руин
        {
            if(TrainRoadID >= 1480 && RuinsInfo[r][boTrainRoad]-1 <= 100)  // Только если текущая позиция поезда находится в завершении, а руины где-то в начале
            {
                trainPoint = RuinsInfo[r][boTrainRoad] - 1;
            }
        }
    }
    return trainPoint;
}

stock MessageTrainStop(playerid)
{
    new line[90],lines[450];
    format(line,sizeof(line),"{FF6347}Внимание! {336633}Впереди обнаружено повреждение железнодорожных путей"), strcat(lines,line);
    format(line,sizeof(line),"\n\n{cccccc}- Поезд плавно остановится перед препятствием"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}- Вы не можете продолжить движение, пока не устраните причину"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}- Вероятно это было устроено намеренно, с целью остановить поезд"), strcat(lines,line);
    format(line,sizeof(line),"\n\n{336633}Защищайте груз любой ценой!"), strcat(lines,line);
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");

    SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Впереди обнаружено повреждение путей. Защищайте груз!");
    PlayerPlaySound(playerid,6001,0,0,0);
    StopAudio(playerid, 4, 6004); // Офаем звук через 4 сек
    return 1;
}

stock MessageTrainStopInfo(playerid)
{
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{336633}Поезд остановился\n{cccccc}Прямо сейчас вы можете выйти из поезда","*","");
    return 1;
}
/*
Как добавить новый NPC?
1. Добавляем его имя в npcNames
2. Добавляем его спавн, вирт мир и инт в NpcPositionSpawn
3. Создаём подключение в stock ConnectOneNpc
4. Устанавливаем id транспорта в stock SetNpcSpawn(playerid)
5. Добавляем скин и цвет после спавна stock OnNpcSpawn(playerid)
*/

// Имена NPC
new npcNames[][] =
{
    "Tim_Johnson", "Bert_Robinson", "Jack_Dawson", "Mr_Winston", "Danny_Devito", "Dominic_Torpeda"
};

// Информация об NPC, спавны, вирт мир и т.д.
enum NPCPOSENUM { Float:Npc_X, Float:Npc_Y, Float:Npc_Z, Float:Npc_A, Npc_World, Npc_Interior }
new NpcPositionSpawn[][NPCPOSENUM] =
{
	{ 1599.4426,-1607.5927,13.4568,180.0, 0, 0 }, // Водитель тюремного автобуса LS
    { -1584.4108,678.7656,7.1875,180.0, 0, 0 }, // Водитель тюремного автобуса SF
    { 747.1211,1706.9492,6.2659,0.0, 0, 0 }, // Водитель поезда NGSA
    { 1100.9181,-1186.2133,18.3424,180.0, 0, 0 }, // Икассатор
    { 2042.4969,-2613.1316,13.5469,0.0078, HIDE_WORLD_PLANE, HIDE_INTERIOR_PLANE }, // Пилот
    { -2406.4172,-606.0099,132.6484,41.3329, 0, 0 } // Dominic
};

enum npcInfo
{
	bool:npcStart, // Статус, запущен ли NPC по своему сценарию
    bool:npcConnected, // Статус, подключен ли NPC к серверу
    npcID,
    npcVehicle, // К какому транспорту принадлежит NPC
    npcReconnectUnix // Кд на повторное переподключение NPC
};
new NPCInfo[sizeof(npcNames)][npcInfo];
new ConnectNpcQuan;
new ConnectNpcUnix;
new Text3D: NpcLabel[sizeof(npcNames)]; // Лейблы NPC

// Подключаем всех NPC
stock CreateNPCsamp()
{
    SendRconCommand("password 0"); // Снимаем пароль, чтобы NPC могли подключиться
    for(new i = 0; i < sizeof(npcNames); i++) ConnectOneNpc(i);

    print("[MODE]: NPC_Create");
    return 1;
}

// Подключаем одного NPC
stock ConnectOneNpc(id)
{
    if(id == 0) ConnectNPC(npcNames[0], "prison_ls");
    else if(id == 1) ConnectNPC(npcNames[1], "prison_sf");
    else if(id == 2) ConnectNPC(npcNames[2], "train_ngsa");
    else if(id == 3) ConnectNPC(npcNames[3], "collector");
    else if(id == 4) ConnectNPC(npcNames[4], "plane_fly");
    else if(id == 5) ConnectNPC(npcNames[5], "dominic_race");
    return 1;
}

// Процесс подключения NPC
stock OnNpcConnect(playerid)
{
    new ip_addr_npc[64+1];
    new ip_addr_server[64+1];
    GetPlayerIp(playerid,ip_addr_npc,64);
    
    ip_addr_server = "127.0.0.1";
    if(strcmp(ip_addr_npc,ip_addr_server,true) != 0) 
    {
        printf("NPC: Got a remote NPC connecting from %s and I'm kicking it.",ip_addr_npc);
        Kickx(playerid);
        return 0;
    }

    OnlineInfo[playerid][oLogged] = 1;

    // Получаем id NPC по имени
    new id = GetIDNpcFromName(playerid);
    OnlineInfo[playerid][oNpcID] = id;

    NPCInfo[id][npcID] = playerid;
    NPCInfo[id][npcConnected] = true;
    printf("[MODE]: OnNpcConnect %d", NPCInfo[id][npcID]);
    ConnectNpcQuan ++;

    // Крепим лейбл с именем (Только для доминика)
    new string[34];
    if(id == 5) format(string, sizeof(string), "{FFFFFF}%s [ ALT ]", npcNames[id]); // Кнопка ALT, только у доминика
    else format(string, sizeof(string), "{FFFFFF}%s", npcNames[id]);
    NpcLabel[id] = CreateDynamic3DTextLabel(string,0xA9C4E4FF, 0.0, 0.0, 0.12, 5.0, playerid, INVALID_VEHICLE_ID, 1);

    // Спавним (внутри стока сначала настраиваем спавн, потом спавним)
    PPSpawnPlayer(playerid);

    // Все подрубились, возвращаем пароль
    if(ConnectNpcQuan >= sizeof(npcNames) && (server > 0 || serverType == 1)) 
    {
        SetPearsPassword();
        ConnectNpcUnix = gettime();
    }
    return 1;
}

stock OnNpcDisconnect(playerid)
{
    new id = OnlineInfo[playerid][oNpcID];
    if(id >= 0) 
    {
        NPCInfo[id][npcConnected] = false;
        DestroyDynamic3DTextLabel(NpcLabel[id]);// Удаляем лейбл с именем (Только для доминика)
    }
    return 1;
}

// Получаем id NPC по имени
stock GetIDNpcFromName(playerid)
{
    new id = -1;
    for(new i = 0; i < sizeof(npcNames); i++)
    {
        if(IsNameNpc(playerid, npcNames[i]))
        {
            id = i;
            break;
        }
    }
    return id;
}

// Настраиваем спавн для NPC
stock SetNpcSpawn(playerid)
{
    new id = OnlineInfo[playerid][oNpcID];
    ProtectSetSpawnInfo(playerid, DEFAULT_PLAYER_TEAM, PlayerInfo[playerid][pModel], NpcPositionSpawn[id][Npc_X],NpcPositionSpawn[id][Npc_Y],NpcPositionSpawn[id][Npc_Z],NpcPositionSpawn[id][Npc_A], 0, 0, 0, 0, 0, 0);

    if(id == 0) NPCInfo[id][npcVehicle] = prisonbus_LS; // Водитель тюремного автобуса LS
    else if(id == 1) NPCInfo[id][npcVehicle] = prisonbus_SF; // Водитель тюремного автобуса SF
    else if(id == 2) NPCInfo[id][npcVehicle] = train; // Водитель поезда NGSA
    else if(id == 3) NPCInfo[id][npcVehicle] = collectorveh; // Икассатор
    else if(id == 4) NPCInfo[id][npcVehicle] = flyveh; // Пилот
    else if(id == 5) NPCInfo[id][npcVehicle] = dominicveh; // Доминик
    return 1;
}

// Че делаем с ботом после спавна
stock OnNpcSpawn(playerid)
{
    new id = OnlineInfo[playerid][oNpcID];
    PlayerInfo[playerid][pModel2] = 0;
    PlayerInfo[playerid][pModel3] = 0;

    if(id == 0) PlayerInfo[playerid][pModel] = 310, SetPlayerColor(playerid, COLOR_LSPD); // Водитель тюремного автобуса LS
    else if(id == 1) PlayerInfo[playerid][pModel] = 310, SetPlayerColor(playerid, COLOR_SFPD); // Водитель тюремного автобуса SF
    else if(id == 2) PlayerInfo[playerid][pModel] = 287, SetPlayerColor(playerid, COLOR_ARMY); // Водитель поезда NGSA
    else if(id == 3) PlayerInfo[playerid][pModel] = 71, SetPlayerColor(playerid, INV_COLOR); // Инкассатор
    else if(id == 4) PlayerInfo[playerid][pModel] = 61, SetPlayerColor(playerid, INV_COLOR); // Пилот
    else if(id == 5) PlayerInfo[playerid][pModel] = 453, SetPlayerColor(playerid, INV_COLOR); // Доминик

    S_SetPlayerVirtualWorld(playerid, NpcPositionSpawn[id][Npc_World], NpcPositionSpawn[id][Npc_Interior]);
    PPSetPlayerInterior(playerid, NpcPositionSpawn[id][Npc_Interior]);
    m_custom_sync_SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
    RemovePlayerFromVehicle(playerid);
    SetPlayerPos(playerid, NpcPositionSpawn[id][Npc_X],NpcPositionSpawn[id][Npc_Y],NpcPositionSpawn[id][Npc_Z]);
    PPSetPlayerFacingAngle(playerid, NpcPositionSpawn[id][Npc_A]);
    NPCInfo[id][npcStart] = false;
    return 1;
}

stock StartNpc(id)
{
    if(NPCInfo[id][npcStart] == true || NPCInfo[id][npcConnected] == false) return 0;

    new vehicleid = NPCInfo[id][npcVehicle];
    S_SetPlayerVirtualWorld(NPCInfo[id][npcID],0,0);
    PPSetPlayerInterior(NPCInfo[id][npcID],0);

    // Отображаем самолёт в общем мире
    if(id == 4) ShowPlane();

    Protect_PutPlayerInVehicle(NPCInfo[id][npcID], vehicleid, 0);
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, true, true, alarm, doors, bonnet, boot, objective);
    NPCInfo[id][npcStart] = true;
    return 1;
}


// Команда переподключения на случай отключившихся NPC
alias:reloadnpc("rnpc")
CMD:reloadnpc(playerid)
{
    if(PlayerInfo[playerid][pSoska] <= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    new quanDisconnect, quanReconnect, unix = gettime(), timeReload;
    for(new i = 0; i < sizeof(npcNames); i++)
    {
        if(NPCInfo[i][npcConnected] == false)
        {
            quanDisconnect ++;
            if(unix >= NPCInfo[i][npcReconnectUnix]) // Только если мы его уже переподключали
            {
                quanReconnect ++;
                ConnectOneNpc(i);
                NPCInfo[i][npcReconnectUnix] = unix + 60;
            }
            else timeReload = NPCInfo[i][npcReconnectUnix] - unix;
        }
    }
    if(quanDisconnect == 0) return ErrorMessage(playerid, "{FF6347}Все NPC подключены");

    new string[120];
    if(quanReconnect == 0) return format(string, sizeof(string), "{FF6347}Внимание! На сервере есть %d отключенных NPC\n{ffcc66}Повторите команду через %d секунд", 
        quanDisconnect, timeReload), ErrorMessage(playerid, string);

    format(string, sizeof(string), " [ ADM ]: %s переподключил NPC [ Количество: %d ]", PlayerInfo[playerid][pName], quanReconnect);
	ABroadCast(COLOR_ADM,string,2);
    return 1;
}

CMD:gotim(playerid)
{
    if(server != 0) return 0;

    if(!StartNpc(0)) return ErrorMessage(playerid, "{FF6347}Этот NPC уже запущен или он отсутствует");
    return 1;
}

CMD:gobert(playerid)
{
    if(server != 0) return 0;

    if(!StartNpc(1)) return ErrorMessage(playerid, "{FF6347}Этот NPC уже запущен или он отсутствует");
    return 1;
}

CMD:gojack(playerid, const params[])
{
    if(server != 0) return 0;

    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Запустить поезд [ /gojack id города ]");
    if(TrainGoing == 1) return ErrorMessage(playerid, "{FF6347}Поезд скоро поедет");
    UpdateDestinationTrain(params[0]);
    if(!StartNpc(2)) return ErrorMessage(playerid, "{FF6347}Этот NPC уже запущен или он отсутствует");
    return 1;
}

CMD:govinni(playerid, const params[])
{
    if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Запустить инкассатора [ /govinni id города ]");
    if(params[0] < 0 || params[0] > 2) return ErrorMessage(playerid, "{FF6347}0 LS, 1 SF, 2 LV");
    if(NPCInfo[3][npcStart] == true) return ErrorMessage(playerid, "{FF6347}Этот NPC уже запущен");
    if(NPCInfo[3][npcConnected] == false) return ErrorMessage(playerid, "{FF6347}Этот NPC отключился от сервера [ /reloadnpc ]");
    CollectorStart(params[0], true);
    return 1;
}

CMD:godeny(playerid)
{
    if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(NPCInfo[4][npcStart] == true) return ErrorMessage(playerid, "{FF6347}Этот NPC уже запущен");
    if(NPCInfo[4][npcConnected] == false) return ErrorMessage(playerid, "{FF6347}Этот NPC отключился от сервера [ /reloadnpc ]");
    PlaneStart();
    return 1;
}

// Поиск имён NPC, чтобы игрок не мог занять это имя
stock Check_NpcName(playerid)
{
    new bool:Findname;
    new PlayerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
    for(new i = 0; i < sizeof(npcNames); i++)
    {
        if(strfind(npcNames[i], PlayerName, true) != -1)
        {
            Findname = true;
            break;
        }
    }
    if(Findname == true) return 1;
    return 0;    
}

// Проверка по имени
stock IsNameNpc(playerid, const name[])
{
    if(IsPlayerNPC(playerid))
    {
        new npcname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, npcname, sizeof(npcname));

        if(strfind(npcname, name, true) != -1) return 1; // Поиск похожего имени (нужно для добавления деталей имени)
        // if(!strcmp(npcname, name, true)) return 1; // Поиск точного совпадения имени
    }
    return 0;
}

stock IsAVehicleNPC(vehicleid)
{
    if(vehicleid == prisonbus_LS || vehicleid == prisonbus_SF || vehicleid == train || vehicleid == collectorveh
        || vehicleid == flyveh || vehicleid == dominicveh) return 1;

    for (new i = 0; i < sizeof(narcovehs); i++) if(vehicleid == narcovehs[i]) return 1;
    
    return 0;
}

stock NpcStatus(id)
{
    if(NPCInfo[id][npcStart] == true) return 1;
    return 0;
}

stock ReloadVehicleNPC(vehicleid)
{
    PP_SetVehicleToRespawn(vehicleid);
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, false, false, alarm, doors, bonnet, boot, objective);
    return 1;
}


// Не пускаем игрока, если он подключается раньше всех NPC
stock BlockConnectBeforeNPC(playerid)
{
    if(ConnectNpcQuan < sizeof(npcNames) || gettime() - ConnectNpcUnix < 2)
    {
        TextDrawShowForPlayer(playerid, Chernifon);
		ShowDialog(playerid,2017,DIALOG_STYLE_MSGBOX,"{FF6347}*","{FF6347}Системы сервера не были окончательно запущены\n{cccccc}Пожалуйста, перезайдите {FF6347}/q или ESC >> Выход","Ок","");
		Kickx(playerid);
        return true;
    }
    return false;
}

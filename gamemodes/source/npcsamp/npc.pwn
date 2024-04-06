

// Имена NPC
new npcNames[][] =
{
    "Tim_Johnson", "Bert_Robinson", "Jack_Dawson"
};

enum npcInfo
{
	bool:npcStart,
    npcID,
    npcDestination, // У train есть несколько вариантов маршрута
    npcVehicle // К какому транспорту принадлежит NPC
};
new NPCInfo[sizeof(npcNames)][npcInfo];
new ConnectNpcQuan;

// Подключаем NPC
stock CreateNPCsamp()
{
    SendRconCommand("password 0"); // Снимаем пароль, чтобы NPC могли подключиться

    ConnectNPC(npcNames[0], "prison_ls");
    ConnectNPC(npcNames[1], "prison_sf");
    ConnectNPC(npcNames[2], "prison_sf");

    print("[MODE]: NPC_Create");
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

    new id;
    if(IsNameNpc(playerid, npcNames[0])) id = 0;
    else if(IsNameNpc(playerid, npcNames[1])) id = 1;
    else if(IsNameNpc(playerid, npcNames[2])) id = 2;

    NPCInfo[id][npcID] = playerid;
    printf("[MODE]: OnNpcConnect %d", NPCInfo[id][npcID]);

    ConnectNpcQuan ++;

    // Спавним (внутри стока сначала настраиваем спавн, потом спавним)
    PPSpawnPlayer(playerid);

    // Все подрубились, возвращаем пароль
    if(ConnectNpcQuan >= sizeof(npcNames) && (server > 0 || serverType == 1)) SetPearsPassword();
    return 1;
}

// Настраиваем спавн для NPC
stock SetNpcSpawn(playerid)
{
    // Водитель тюремного автобуса LS
    if(IsNameNpc(playerid, npcNames[0]))
    {
        ProtectSetSpawnInfo(playerid, 2, PlayerInfo[playerid][pModel], 1599.4426,-1607.5927,13.4568,180.0, 0, 0, 0, 0, 0, 0);
        NPCInfo[0][npcVehicle] = prisonbus_LS;
    }

    // Водитель тюремного автобуса SF
    else if(IsNameNpc(playerid, npcNames[1]))
    {
        ProtectSetSpawnInfo(playerid, 2, PlayerInfo[playerid][pModel], -1584.4108,678.7656,7.1875,180.0, 0, 0, 0, 0, 0, 0);
        NPCInfo[1][npcVehicle] = prisonbus_SF;
    }

    // Водитель поезда NGSA
    else if(IsNameNpc(playerid, npcNames[2]))
    {
        ProtectSetSpawnInfo(playerid, 2, PlayerInfo[playerid][pModel], 747.1211,1706.9492,6.2659,0.0, 0, 0, 0, 0, 0, 0);
        NPCInfo[2][npcVehicle] = train;
    }
    return 1;
}

// Че делаем с ботом после спавна
stock OnNpcSpawn(playerid)
{
    PlayerInfo[playerid][pModel2] = 0;
    PlayerInfo[playerid][pModel3] = 0;

    // Водитель тюремного автобуса LS
    if(IsNameNpc(playerid, npcNames[0]))
    {
        PlayerInfo[playerid][pModel] = 310;
        
        S_SetPlayerVirtualWorld(playerid,0,0);
        SetPlayerInterior(playerid,0);
        m_custom_sync_SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);

        RemovePlayerFromVehicle(playerid);
        SetPlayerPos(playerid, 1599.4426,-1607.5927,13.4568);
        SetPlayerFacingAngle(playerid, 180.0);
        SetPlayerColor(playerid, COLOR_LSPD);
        NPCInfo[0][npcStart] = false;
    }

    // Водитель тюремного автобуса SF
    else if(IsNameNpc(playerid, npcNames[1]))
    {
        PlayerInfo[playerid][pModel] = 310;
        
        S_SetPlayerVirtualWorld(playerid,0,0);
        SetPlayerInterior(playerid,0);
        m_custom_sync_SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);

        RemovePlayerFromVehicle(playerid);
        SetPlayerPos(playerid, -1584.4108,678.7656,7.1875);
        SetPlayerFacingAngle(playerid, 180.0);
        SetPlayerColor(playerid, COLOR_SFPD);
        NPCInfo[1][npcStart] = false;
    }

    // Водитель поезда NGSA
    else if(IsNameNpc(playerid, npcNames[2]))
    {
        PlayerInfo[playerid][pModel] = 287;
        
        S_SetPlayerVirtualWorld(playerid,0,0);
        SetPlayerInterior(playerid,0);
        m_custom_sync_SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);

        RemovePlayerFromVehicle(playerid);
        SetPlayerPos(playerid, 747.1211,1706.9492,6.2659);
        SetPlayerFacingAngle(playerid, 0.0);
        SetPlayerColor(playerid, COLOR_ARMY);
        NPCInfo[2][npcStart] = false;
    }
    return 1;
}

stock StartNpc(id, destination = 0)
{
    if(NPCInfo[id][npcStart] == true) return 0;

    new vehicleid = NPCInfo[id][npcVehicle];

    Protect_PutPlayerInVehicle(NPCInfo[id][npcID], vehicleid, 0);
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, true, true, alarm, doors, bonnet, boot, objective);
    NPCInfo[id][npcStart] = true;
    NPCInfo[id][npcDestination] = destination;
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

CMD:gojack(playerid)
{
    if(server != 0) return 0;

    if(!StartNpc(2)) return ErrorMessage(playerid, "{FF6347}Этот NPC уже запущен или он отсутствует");
    return 1;
}

stock IsAVehicleNPC(vehicleid)
{
    if(vehicleid == prisonbus_LS || vehicleid == prisonbus_SF || vehicleid == train) return 1;
    return 0;
}

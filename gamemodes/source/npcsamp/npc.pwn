
#define MAX_NPC_SAMP 2

enum npcInfo
{
	bool:npcStart,
    npcID
};
new NPCInfo[MAX_NPC_SAMP][npcInfo];
new ConnectNpcQuan;

// Подключаем NPC
stock CreateNPCsamp()
{
    SendRconCommand("password 0"); // Снимаем пароль, чтобы NPC могли подключиться

    ConnectNPC("Tim", "prison_ls");
    ConnectNPC("Bert", "prison_sf");

    print("[MODE]: NPC_Create");
    return 1;
}

// Процесс подключения NPC
stock OnNpcConnect(playerid)
{
    new ip_addr_npc[64+1];
    new ip_addr_server[64+1];
    GetServerVarAsString("bind",ip_addr_server,64);
    GetPlayerIp(playerid,ip_addr_npc,64);
    
    if(!strlen(ip_addr_server)) ip_addr_server = "127.0.0.1";
    
    if(strcmp(ip_addr_npc,ip_addr_server,true) != 0) 
    {
        printf("NPC: Got a remote NPC connecting from %s and I'm kicking it.",ip_addr_npc);
        Kick(playerid);
        return 0;
    }

    OnlineInfo[playerid][oLogged] = 1;
    NPCInfo[ConnectNpcQuan][npcID] = playerid;
    printf("[MODE]: OnNpcConnect %d", NPCInfo[ConnectNpcQuan][npcID]);

    ConnectNpcQuan ++;

    // Спавним (внутри стока сначала настраиваем спавн, потом спавним)
    PPSpawnPlayer(playerid);

    // Все подрубились, возвращаем пароль
    if(ConnectNpcQuan >= MAX_NPC_SAMP && (server > 0 || serverType == 1)) SendRconCommand("password 5ye5ynsfbjey4TBFgg");
    return 1;
}

// Настраиваем спавн для NPC
stock SetNpcSpawn(playerid)
{
    // Водитель тюремного автобуса LS
    if(IsNameNpc(playerid, "Tim"))
    {
        ProtectSetSpawnInfo(playerid, 2, PlayerInfo[playerid][pModel], 1599.4426,-1607.5927,13.4568,180.0, 0, 0, 0, 0, 0, 0);
    }

    // Водитель тюремного автобуса SF
    else if(IsNameNpc(playerid, "Bert"))
    {
        ProtectSetSpawnInfo(playerid, 2, PlayerInfo[playerid][pModel], -1584.4108,678.7656,7.1875,180.0, 0, 0, 0, 0, 0, 0);
    }
    return 1;
}

// Че делаем с ботом после спавна
stock OnNpcSpawn(playerid)
{
    PlayerInfo[playerid][pModel2] = 0;
    PlayerInfo[playerid][pModel3] = 0;

    // Водитель тюремного автобуса LS
    if(IsNameNpc(playerid, "Tim"))
    {
        PlayerInfo[playerid][pModel] = 310;
        
        S_SetPlayerVirtualWorld(playerid,0,0);
        SetPlayerInterior(playerid,0);
        m_custom_sync_SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);

        RemovePlayerFromVehicle(playerid);
        SetPlayerPos(playerid, 1599.4426,-1607.5927,13.4568);
        SetPlayerFacingAngle(playerid, 180.0);
        SetPlayerColor(playerid, COLOR_LSPD);
    }

    // Водитель тюремного автобуса SF
    else if(IsNameNpc(playerid, "Bert"))
    {
        PlayerInfo[playerid][pModel] = 310;
        
        S_SetPlayerVirtualWorld(playerid,0,0);
        SetPlayerInterior(playerid,0);
        m_custom_sync_SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);

        RemovePlayerFromVehicle(playerid);
        SetPlayerPos(playerid, -1584.4108,678.7656,7.1875);
        SetPlayerFacingAngle(playerid, 180.0);
        SetPlayerColor(playerid, COLOR_SFPD);
    }
    return 1;
}

stock StartNpc(playerid)
{
    if(IsNameNpc(playerid, "Tim"))
    {
        if(NPCInfo[0][npcStart] == true) return 0;
        Protect_PutPlayerInVehicle(playerid, prisonbus_LS, 0);
        GetVehicleParamsEx(prisonbus_LS, engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(prisonbus_LS, true, true, alarm, doors, bonnet, boot, objective);
        NPCInfo[0][npcStart] = true;
    }
    else if(IsNameNpc(playerid, "Bert"))
    {
        if(NPCInfo[1][npcStart] == true) return 0;
        Protect_PutPlayerInVehicle(playerid, prisonbus_SF, 0);
        GetVehicleParamsEx(prisonbus_SF, engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(prisonbus_SF, true, true, alarm, doors, bonnet, boot, objective);
        NPCInfo[1][npcStart] = true;
    }
    else return 0;
    return 1;
}

// Проверка по имени
stock IsNameNpc(playerid, const name[])
{
    if(IsPlayerNPC(playerid))
    {
        new npcname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, npcname, sizeof(npcname));

        if(!strcmp(npcname, name, true)) return 1;
    }
    return 0;
}

CMD:gotim(playerid)
{
    if(server != 0) return 0;

    if(!StartNpc(NPCInfo[0][npcID])) return ErrorMessage(playerid, "{FF6347}Этот NPC уже запущен или он отсутствует");
    return 1;
}

CMD:gobert(playerid)
{
    if(server != 0) return 0;

    if(!StartNpc(NPCInfo[1][npcID])) return ErrorMessage(playerid, "{FF6347}Этот NPC уже запущен или он отсутствует");
    return 1;
}

stock IsAVehicleNPC(vehicleid)
{
    if(vehicleid == prisonbus_LS || vehicleid == prisonbus_SF || vehicleid == train) return 1;
    return 0;
}

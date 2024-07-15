
#define MAX_NPC 100

enum NPCINFO
{
	NPC:npcID
}
new NpcINfo[MAX_NPC][NPCINFO];

alias:createnpc("npc")
CMD:createnpc(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] <= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Создать NPC /createnpc ID Скина");

    new Float:f_pos[4];
	frontme(playerid, 4.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);

    new npcid = GetFreeSlotNPC();
    if(npcid == -1) return ErrorMessage(playerid, "{FF6347}Нет свободных слотов для создания NPC");
    NpcINfo[npcid][npcID] = CreateNpc(params[0], f_pos[0], f_pos[1], f_pos[2]);
    SetNpcVirtualWorld(NpcINfo[npcid][npcID], GetPlayerVirtualWorld(playerid));
    return true;
}

alias:destroynpc("delnpc", "dnpc")
CMD:destroynpc(playerid, const params[])
{
    if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Удалить NPC /destroynpc NpcID");
    if(!PermissionNPC(playerid, params)) return false;

    DestroyNpc(NpcINfo[params[0]][npcID]);

    new string[80];
    format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~NPC %d DELETED", params[0]);
	GameTextForPlayer(playerid,string,4000,3);
    return true;
}

CMD:gonpc(playerid, const params[])
{
    if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Сказать NPC идти в точку перед вашим лицом /gonpc NpcID");
    if(!PermissionNPC(playerid, params)) return false;

    new Float:f_pos[4];
	frontme(playerid, 4.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
    TaskNpcGoToPoint(NpcINfo[params[0]][npcID], f_pos[0], f_pos[1], f_pos[2], NPC_MOVE_MODE_RUN);
    return true;
}

alias:stopnpc("npcstop")
CMD:stopnpc(playerid, const params[])
{
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Остановить NPC на месте /stopnpc NpcID");
    if(!PermissionNPC(playerid, params)) return false;

    TaskNpcStandStill(NpcINfo[params[0]][npcID]);
    return true;
}

alias:npcattack("npcatak", "npcatack", "npckill")
CMD:npcattack(playerid, const params[])
{
    if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Приказать NPC атаковать игрока /npcattack NpcID playerid");
    if(!PermissionNPC(playerid, params)) return false;
    if(!IsOnline(params[1])) return ErrorMessage(playerid, "{FF6347}Этого игрока нет в сети");

    TaskNpcAttackPlayer(NpcINfo[params[0]][npcID], params[1]);
    return true;
}

CMD:npcgun(playerid, const params[])
{
    if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Выдать оружие NPC /npcgun NpcID weaponid");
    if(!PermissionNPC(playerid, params)) return false;
    if(params[1] < 0 || params[1] > 46) return ErrorMessage(playerid, "{FF6347}Неверный id оружия");

    SetNpcWeapon(NpcINfo[params[0]][npcID], WEAPON:params[1]);
    return true;
}

stock PermissionNPC(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] <= 1)
    {
        ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
        return false;
    }
    if(params[0] < 0 || params[0] >= MAX_NPC)
    {
        ErrorMessage(playerid, "{FF6347}Несуществующий ID");
        return false;
    }
    if(!IsValidNpc(NpcINfo[params[0]][npcID])
        || NpcINfo[params[0]][npcID] == INVALID_NPC)
    {
        ErrorMessage(playerid, "{FF6347}Этого NPC не существует");
        return false;
    }
    return true;
}

stock GetFreeSlotNPC()
{
    for(new i = 0; i < MAX_NPC; i++)
    {
        if(NpcINfo[i][npcID] == INVALID_NPC)
        {
            return i;
        }
    }
    return -1;
}

stock ClearNPCID()
{
    for(new i = 0; i < MAX_NPC; i++)
    {
        NpcINfo[i][npcID] = INVALID_NPC;
    }
    return true;
}

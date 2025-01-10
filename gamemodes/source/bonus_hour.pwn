
CMD:rbonus(playerid, const params[])
{
    if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сбросить часы в игре для получения бонуса [ /rbonus ID ]");
    if(!IsOnline(params[0])) return ErrorMessage(playerid, "{FF6347}Игрок не в сети");

    PlayerInfo[params[0]][pBonHour] = 0;
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "** Вы очистили часы в игре для получения бонуса %s **", PlayerInfo[params[0]][pName]);
    if(playerid != params[0]) SendClientMessage(params[0], COLOR_LIGHTBLUE, "** %s очистил вам часы в игре для получения бонуса **", PlayerInfo[playerid][pName]);

    AdminLog("rbonus", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[params[0]][pID], PlayerInfo[params[0]][pName], PlayerInfo[params[0]][pPlaIP], 0, "");
    return 1;
}

stock BonusCheck(playerid)
{
	new Days = getdate();
	if(PlayerInfo[playerid][pToday] == Days)
	{
	    PlayerInfo[playerid][pBonHour] ++;
        CompleteBattlePassTask(playerid, 3, 0, 1);
	    if(PlayerInfo[playerid][pBonHour] == ServerInfo[10])
	    {
            SendClientMessage(playerid, COLOR_GREY, "  {0088ff}%d Часов в игре: {99ff66}Шкатулка", ServerInfo[10]);
            GiveGiftQuest(playerid, false);
            return true;
	    }
        else if(PlayerInfo[playerid][pBonHour] > ServerInfo[10]) return true;
	}
	else PlayerInfo[playerid][pToday] = Days, PlayerInfo[playerid][pBonHour] = 1;

    SendClientMessage(playerid, COLOR_GREY, "  {0088ff}%d Часов из %d до получения шкатулки", PlayerInfo[playerid][pBonHour], ServerInfo[10]);
	return true;
}

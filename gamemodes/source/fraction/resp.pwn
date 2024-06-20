
// Игрок проник на зону 51
stock PlayerInArea51(playerid)
{
    if(!IsADepart(playerid) // Не сотрудник департамента
				&& (Onli[3] > 0 || server == 0) // Армейцы Online
				&& GetPVarInt(playerid, "endorse") != 3 // Нет доступа к респе
				&& GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
    {
        new findUk, findP;
        if (FindCriminalArticle("Проникновение", findUk, findP, .ignorecase = false)) 
        {
            if(GetPlayerCriminalSlot(playerid, findUk, findP) == -1)
            {
                SetPlayerCriminal(playerid, -1, CriminalCodeInfo[findUk][findP][ccName], CriminalCodeInfo[findUk][findP][ccLevel], findUk, findP);
            }
            return true;
        }
    }
	return false;
}

// Записываем id организации, на респе которой находится игрок
stock CheckPlayerInResp(playerid)
{
    new orgid = IsASpawn(playerid);
    if(orgid > 0)
    {
        // Впервые оказались на этой терре
        if(Iamterr[playerid] != orgid)
        {
            // Игрок оказался на зоне 51
			if(orgid == 3) PlayerInArea51(playerid);
        }
        Iamterr[playerid] = orgid;
    }
    else if(Iamterr[playerid] > 0) Iamterr[playerid] = 0;
    return true;
}

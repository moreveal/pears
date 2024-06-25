
// Игрок проник на зону 51
stock PlayerInArea51(playerid)
{
    if(!IsADepart(playerid) // Не сотрудник департамента
				&& (Onli[3] > 0 || server == 0) // Армейцы Online
				&& GetPVarInt(playerid, "endorse") != 3 // Нет доступа к респе
                && GetPlayerVirtualWorld(playerid) == 0 // В общем виртуальном мире
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

stock IsAArabianLift(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid,2.0,1364.3219,-33.4613,1000.9297) 
        && GetPlayerVirtualWorld(playerid) == WORLD_ARABIAN_1LVL && GetPlayerInterior(playerid) == INT_ARABIAN_1LVL
			
    || IsPlayerInRangeOfPoint(playerid,2.0,1386.8922,-47.7762,1000.9336)
        && GetPlayerVirtualWorld(playerid) == WORLD_ARABIAN_2LVL && GetPlayerInterior(playerid) == INT_ARABIAN_2LVL

    || IsPlayerInRangeOfPoint(playerid,2.0,910.8951,1378.9348,1029.4417)
        && GetPlayerVirtualWorld(playerid) == WORLD_ARABIAN_M1LVL && GetPlayerInterior(playerid) == INT_ARABIAN_M1LVL

    || IsPlayerInRangeOfPoint(playerid,2.0,915.1874,1385.5457,1029.3643)
        && GetPlayerVirtualWorld(playerid) >= 1 && GetPlayerInterior(playerid) == INT_ARABIAN_KORIDOR
    ) return true;

    return false;
}

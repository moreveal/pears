// Есть ли у игрока легальный доступ к Зоне 51
stock IsPlayerHaveAccessArea51(playerid)
{
    if (IsADepart(playerid)) return 1;
    if (GetPVarInt(playerid, "endorse") == 3) return 1;
    if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return 1;

    return 0;
}

// Игрок проник на зону 51
stock PlayerInArea51(playerid)
{
    if(!IsPlayerHaveAccessArea51(playerid) // Нет доступа
		&& (Onli[3] > 0 || server == 0) // Армейцы Online
        && GetPlayerVirtualWorld(playerid) == 0) // В общем виртуальном мире
    {
        // Выдача розыска за проникновение, если он ещё не выдавался
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
        // Если мы на респе нгса, копим время, чтобы выдать звёзды
        if(orgid == 3)
        {
            if(OnlineInfo[playerid][oPauseInArea] == 300) PlayerInArea51(playerid); // Через 5 минут выдаём розыск
            else OnlineInfo[playerid][oPauseInArea] ++;
        }
        Iamterr[playerid] = orgid;
    }
    else if(Iamterr[playerid] > 0) Iamterr[playerid] = 0;

    if(orgid == 0) ClearAreaTime(playerid);
    return true;
}

stock ClearAreaTime(playerid)
{
    if(OnlineInfo[playerid][oPauseInArea] > 0) OnlineInfo[playerid][oPauseInArea] --;
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

stock IsACnnLift(playerid)
{
    // Крыша
    if(IsPlayerInRangeOfPoint(playerid,2.0,1425.9067,-1217.1545,195.0469) 
        && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0
			
    // 1 этаж
    || IsPlayerInRangeOfPoint(playerid,2.0,965.0433,1450.9865,1029.3549)
        && GetPlayerVirtualWorld(playerid) == WORLD_CNN_1LVL && GetPlayerInterior(playerid) == INT_CNN_1LVL

    // 2 Этаж
    || IsPlayerInRangeOfPoint(playerid,2.0,1425.7341,-1218.1085,124.1885)
        && GetPlayerVirtualWorld(playerid) == WORLD_CNN_2LVL && GetPlayerInterior(playerid) == INT_CNN_2LVL

    ) return true;

    return false;
}

// Въезд на склад Yakuza
stock EnterYakuzaSklad(playerid)
{
    if(Stopeee[playerid] == 1 && Stopee[playerid] > 0) return true; //  Если keep (заморозка) всё ещё активна, не позволяем прыгать по интам (условный антифлуд)

    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || Protect_Veh[playerid] == 9999) return true;
    new vehicleid = Protect_Veh[playerid];

    if(GetPVarInt(playerid,"endorse") != 6 && PlayerInfo[playerid][pMember] != 6) return ErrorMessage(playerid, "{FF6347}У вас нет ключей от этих ворот");
    if(IsPlayerHavePursuit(playerid)) return ErrorMessage(playerid, "{FF6347}Вас преследует полиция, сейчас вы не можете заехать в ворота");
	if(VehInfo[vehicleid][vTrailerID] > 0) return ErrorMessage(playerid, "{FF6347}Открепите трейлер, прежде чем заезжать в ворота");
    if(CheckEnterVehicleInterior(playerid, vehicleid)) return true;

    // Останавливаем следование игрока за нами
    StopPlayerFollowForMe(playerid);

    keep(playerid);
    ACSetVehiclePos(vehicleid, 931.2459,1397.7351,1030.0206);
    SetVehicleZAngle(vehicleid, 90.7436);
    SetVehicleVirtualWorld(vehicleid, WORLD_YAKUZA_GARAGE);
    LinkVehicleToInterior(vehicleid, INT_YAKUZA_GARAGE);

    // Меняем вирт мир и инт пассажирам транспорта
    PassengerWorldVehicle(vehicleid, WORLD_YAKUZA_GARAGE, INT_YAKUZA_GARAGE);

    S_SetPlayerVirtualWorld(playerid, WORLD_YAKUZA_GARAGE, INT_YAKUZA_GARAGE);
    PPSetPlayerInterior(playerid, INT_YAKUZA_GARAGE);
    SetCameraBehindPlayer(playerid);

    // Выключаем коллизию
	NoCollisionForAll(playerid, 0);
	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы заехали в помещение\n{ff9000}Для вас отключены столкновения с другими игроками в транспорте на 20 секунд","*","");
    return true;
}

// Выезд со склада Yakuza
stock ExitYakuzaSklad(playerid)
{
    if(Stopeee[playerid] == 1 && Stopee[playerid] > 0) return true; //  Если keep (заморозка) всё ещё активна, не позволяем прыгать по интам (условный антифлуд)

    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || Protect_Veh[playerid] == 9999) return true;
    new vehicleid = Protect_Veh[playerid];

    if(IsPlayerHavePursuit(playerid)) return ErrorMessage(playerid, "{FF6347}Вас преследует полиция, сейчас вы не можете заехать в ворота");
	if(VehInfo[vehicleid][vTrailerID] > 0) return ErrorMessage(playerid, "{FF6347}Открепите трейлер, прежде чем заезжать в ворота");
    if(CheckEnterVehicleInterior(playerid, vehicleid)) return true;

    // Останавливаем следование игрока за нами
    StopPlayerFollowForMe(playerid);

    keep(playerid);
    ACSetVehiclePos(vehicleid, 1434.9194,781.2708,-4.7084);
    SetVehicleZAngle(vehicleid, 75.0368);
    SetVehicleVirtualWorld(vehicleid, 0);
    LinkVehicleToInterior(vehicleid, 0);

    // Меняем вирт мир и инт пассажирам транспорта
    PassengerWorldVehicle(vehicleid, 0, 0);

    S_SetPlayerVirtualWorld(playerid, 0, 0);
    PPSetPlayerInterior(playerid, 0);
    SetCameraBehindPlayer(playerid);

    // Выключаем коллизию
	NoCollisionForAll(playerid, 0);
	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы выехали их помещения\n{ff9000}Для вас отключены столкновения с другими игроками в транспорте на 20 секунд","*","");
    return true;
}

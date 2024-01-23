
enum deathInfo
{
    bool:deathStatus, // Статус смерти
    deathTime, // Время валяния на земле
    deathUnix, // unix предыдущей смерти
    bool:deathFall, // статус падения с высоты
    deathReason // id причина смерти
};
new DeathInfo[MAX_REALPLAYERS][deathInfo];

stock SetPlayerDeath(playerid, reason)
{
    if(NoDeath(playerid)) return 0;

    if(OnlineInfo[playerid][oShowInterface] == 1) CloseFrisk(playerid), CancelSelectTextDraw(playerid);
    if(OnlineInfo[playerid][oShowInterface] == 2) CloseSmartfon(playerid), CancelSelectTextDraw(playerid);

    GetPlayerPos(playerid,PlayerInfo[playerid][pLastPos][0],PlayerInfo[playerid][pLastPos][1],PlayerInfo[playerid][pLastPos][2]);
	GetPlayerFacingAngle(playerid,PlayerInfo[playerid][pLastPos][3]);

    //new Float:zpos;
    //CA_FindZ_For2DCoord(PlayerInfo[playerid][pLastPos][0],PlayerInfo[playerid][pLastPos][1], zpos);
    //PlayerInfo[playerid][pLastPos][2] = zpos + 1.0;

    PlayerInfo[playerid][pLastWorld] = GetPlayerVirtualWorld(playerid);
    PlayerInfo[playerid][pLastInt] = GetPlayerInterior(playerid);

    new unix = gettime(), timeDeath, timeDeathTwo;
    DeathInfo[playerid][deathStatus] = true;
    DeathInfo[playerid][deathReason] = reason;

    timeDeath = 180, timeDeathTwo = 300;
    if(DeathInfo[playerid][deathUnix] >= unix) DeathInfo[playerid][deathTime] = timeDeathTwo; // 5 min
    else DeathInfo[playerid][deathTime] = timeDeath; // 3 min
    DeathInfo[playerid][deathUnix] = unix + 3600;

    NoAnim[playerid] = 1;
    ShowInterfaceDeath(playerid);
    UpdateDeathProcess(playerid);

    new line[130],lines[520];
   	format(line,sizeof(line),"{FF6347}Ваш персонаж получил тяжёлую травму"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Госпитализация через {FF6347}%s", fine_time(DeathInfo[playerid][deathTime])), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}В течении ожидания к вам может прибыть скорая помощь, чтобы вылечить вас"), strcat(lines,line);
    if(PlayerInfo[playerid][pSoska] > 0) format(line,sizeof(line),"\n{ff9000}Для администрации: /hp"), strcat(lines,line);

    format(line,sizeof(line),"\n\n{555555}Смерть, чаще чем один раз в час, увеличивает время ожидания"), strcat(lines,line);
  	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ff9000}*",lines,"*","");

    TempTake(playerid, 0);
    return 1;
}

stock NoDeath(playerid) // Не запускать систему смерти
{
    if(DeathInfo[playerid][deathStatus] // Уже мертв
    || PlayerInfo[playerid][pJailed] == 4 || PlayerInfo[playerid][pJailed] == 7 || PlayerInfo[playerid][pJailed] == 8 // В больке
    || MPGO[playerid] > 0 // На мп
    || Kapt[fraction(playerid)] > 0 && IsAGhetto(playerid) // Капт + На территории гетто
    || Zahvat[fraction(playerid)] > 0 // Порт
    || PlayerInfo[playerid][pBkyrenie] >= 2 // Луна, Марс
    || gSkafandr[playerid] > 0 && (GetPlayerInterior(playerid) == 221 && GetPlayerVirtualWorld(playerid) == 221 || GetPlayerInterior(playerid) == 222 && GetPlayerVirtualWorld(playerid) == 222) // В скафандре
    || peoInfo[playerid][peoInEditor] // personal editor
    || VehShopInfo[playerid][vsTest] // test drive
    || computerClubPlayerInfo[playerid][ccpiInGame] // Компьютерный клуб
    || CA_IsPlayerNearWater(playerid, 1.0, 1.0)) return 1;
    return 0;
}

stock NoHospital(playerid) // Не отправлять в госпиталь при смерти
{
    if(PlayerInfo[playerid][pJailed] == 4 || PlayerInfo[playerid][pJailed] == 7 || PlayerInfo[playerid][pJailed] == 8 // В больке
    || MPGO[playerid] > 0 // На мп
    || Kapt[fraction(playerid)] > 0 && IsAGhetto(playerid) // Капт + На территории гетто
    || Zahvat[fraction(playerid)] > 0 // Порт
    || PlayerInfo[playerid][pBkyrenie] >= 2 // Луна, Марс
    || gSkafandr[playerid] > 0 && (GetPlayerInterior(playerid) == 221 && GetPlayerVirtualWorld(playerid) == 221 || GetPlayerInterior(playerid) == 222 && GetPlayerVirtualWorld(playerid) == 222) // В скафандре
    || peoInfo[playerid][peoInEditor] // personal editor
    || VehShopInfo[playerid][vsTest] // test drive
    || ADUTY[playerid] == 1
    || computerClubPlayerInfo[playerid][ccpiInGame]) return 1;
    return 0;
}

// Возвращаем позицию игрока после спавна для смерти
stock WeReturnToDeathPosition(playerid)
{
    PPSpawn[playerid] = false;
    NoAnim[playerid] = 1;

	S_SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pLastWorld], PlayerInfo[playerid][pLastInt]), SetPlayerInterior(playerid, PlayerInfo[playerid][pLastInt]);
	if(PlayerInfo[playerid][pBeret] == 0) Protect_MyWeapon(playerid); // Возвращаем оружие
	SetPlayerToTeamColor(playerid); // Возвращаем цвет

    if(DeathInfo[playerid][deathReason] == 54) PlayerInfo[playerid][pLastPos][2] -= 1.0;

    PPSetPlayerPos(playerid, PlayerInfo[playerid][pLastPos][0],PlayerInfo[playerid][pLastPos][1],PlayerInfo[playerid][pLastPos][2]);
    SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pLastPos][3]);

	// Возвращаем аксессуары
	if(PlayerInfo[playerid][pOdet][0] > 0) Odet(playerid, 5);
	if(PlayerInfo[playerid][pOdet][1] > 0) Odet(playerid, 6);
    if(PlayerInfo[playerid][pOdet][2] > 0) Odet(playerid, 7);
	if(PlayerInfo[playerid][pOdet][3] > 0) Odet(playerid, 8);
	if(PlayerInfo[playerid][pOdet][4] > 0) Odet(playerid, 9);

    UpdateDeathProcess(playerid);
    ACSetPlayerHealth(playerid, 10.0);
    return 1;
}

stock UpdateDeathProcess(playerid)
{
    UpdateDeathDrawProcess(playerid);

    new string[24];
    TogglePlayerControllable(playerid, 0);
    ApplyAnimation(playerid,"CRACK","crckidle2",3.0,0,1,1,1,1,1);
    format(string, sizeof(string), "без сознания [%s]", fine_time(DeathInfo[playerid][deathTime]));
    SetPlayerChatBubble(playerid,string, COLOR_LIGHTRED,20.0,1500);

    if(!IsPlayerInRangeOfPoint(playerid,0.8,PlayerInfo[playerid][pLastPos][0],PlayerInfo[playerid][pLastPos][1],PlayerInfo[playerid][pLastPos][2]))
    {
        PPSetPlayerPos(playerid,PlayerInfo[playerid][pLastPos][0],PlayerInfo[playerid][pLastPos][1],PlayerInfo[playerid][pLastPos][2]);
        SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pLastPos][3]);
    }
    return 1;
}

stock DeathEnd(playerid, stat)
{
    DeathInfo[playerid][deathStatus] = false;
    for(new i = 0; i < 9; i++) TextDrawHideForPlayer(playerid, DeathDraw[i]);
    PlayerTextDrawHide(playerid, DeathDraw1);
    NoAnim[playerid] = 0;

    if(stat == 0) // Время вышло
    {
        if(PlayerInfo[playerid][pJailed] == 0) // Только если не сидим уже в тюрьме
        {
            PlayerInfo[playerid][pJailed] = 4;
            PlayerInfo[playerid][pJailTime] = 600;
        }
        gYda[playerid] = 2;
  	    PPSpawnPlayer(playerid);
    } 
    else if(stat == 1) // Вылечили
    {
        TempGive(playerid);
        TogglePlayerControllable(playerid, 1);
        ClearAnim(playerid), ClearAnimations(playerid);
	    ApplyAnimation(playerid,"PED","facanger",4.1,0,1,1,1,1,1);
    }
    return 1;
}

stock ShowInterfaceDeath(playerid)
{
    for(new i = 0; i < 9; i++) TextDrawShowForPlayer(playerid, DeathDraw[i]);
    return 1;
}

stock UpdateDeathDrawProcess(playerid)
{
    new string[24];
    format(string, sizeof(string), "%s", fine_time(DeathInfo[playerid][deathTime]));
    PlayerTextDrawSetString(playerid, DeathDraw1, string);
    PlayerTextDrawShow(playerid, DeathDraw1);
    return 1;
}


enum deathInfo
{
    bool:deathStatus, // Статус смерти
    Float:deathPos[4], //  Точка смерти
    deathInt, // int
    deathWorld, // wolrd
    deathTime, // Время валяния на земле
    deathUnix, // unix предыдущей смерти
    bool:deathFall, // статус падения с высоты
    deathReason // id причина смерти
};
new DeathInfo[MAX_REALPLAYERS][deathInfo];

stock SetPlayerDeath(playerid, reason)
{
    if(NoDeath(playerid)) return 1;

    if(OnlineInfo[playerid][oShowInterface] == 1) CloseFrisk(playerid), CancelSelectTextDraw(playerid);
    if(OnlineInfo[playerid][oShowInterface] == 2) CloseSmartfon(playerid), CancelSelectTextDraw(playerid);

    GetPlayerPos(playerid,DeathInfo[playerid][deathPos][0],DeathInfo[playerid][deathPos][1],DeathInfo[playerid][deathPos][2]);
	GetPlayerFacingAngle(playerid,DeathInfo[playerid][deathPos][3]);

    new Float:zpos;
    CA_FindZ_For2DCoord(DeathInfo[playerid][deathPos][0],DeathInfo[playerid][deathPos][1], zpos);
    DeathInfo[playerid][deathPos][2] = zpos + 1.0;

    DeathInfo[playerid][deathWorld] = GetPlayerVirtualWorld(playerid);
    DeathInfo[playerid][deathInt] = GetPlayerInterior(playerid);

    new unix = gettime(), timeDeath, timeDeathTwo;
    DeathInfo[playerid][deathStatus] = true;
    DeathInfo[playerid][deathReason] = reason;

    if(server == 0) timeDeath = 20, timeDeathTwo = 30;
    else timeDeath = 180, timeDeathTwo = 300;

    if(DeathInfo[playerid][deathUnix] >= unix) DeathInfo[playerid][deathTime] = timeDeathTwo; // 5 min
    else DeathInfo[playerid][deathTime] = timeDeath; // 3 min
    DeathInfo[playerid][deathUnix] = unix + 3600;

    ShowInterfaceDeath(playerid);
    UpdateDeathProcess(playerid);

    format(lines,sizeof(lines),""); // Очищаем Lines
   	format(line,sizeof(line),"{FF6347}Ваш персонаж получил тяжёлую травму"), strcat(lines,line);
	if(server == 0) format(line,sizeof(line),"\n{cccccc}Госпитализация через {FF6347}%s {555555}(Время уменьшено для тестового сервера)", fine_time(DeathInfo[playerid][deathTime])), strcat(lines,line);
    else format(line,sizeof(line),"\n{cccccc}Госпитализация через {FF6347}%s", fine_time(DeathInfo[playerid][deathTime])), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}В течении ожидания к вам может прибыть скорая помощь, чтобы вылечить вас"), strcat(lines,line);

    format(line,sizeof(line),"\n\n{555555}Смерть, чаще чем один раз в час, увеличивает время ожидания"), strcat(lines,line);
  	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ff9000}*",lines,"*","");
    return 1;
}

stock NoDeath(playerid)
{
    if(DeathInfo[playerid][deathStatus] // Уже мертв
    || PlayerInfo[playerid][pJailed] == 4 || PlayerInfo[playerid][pJailed] == 7 || PlayerInfo[playerid][pJailed] == 8 // В больке
    || MPGO[playerid] > 0 // На мп
    || Kapt[fraction(playerid)] > 0 || Zahvat[fraction(playerid)] > 0 // Капт, Порт
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

	S_SetPlayerVirtualWorld(playerid, DeathInfo[playerid][deathWorld], DeathInfo[playerid][deathInt]), SetPlayerInterior(playerid, DeathInfo[playerid][deathInt]);
	if(PlayerInfo[playerid][pBeret] == 0) Protect_MyWeapon(playerid); // Возвращаем оружие
	SetPlayerToTeamColor(playerid); // Возвращаем цвет

    //if(DeathInfo[playerid][deathReason] == 54) DeathInfo[playerid][deathPos][2] -= 1.4;

    PPSetPlayerPos(playerid, DeathInfo[playerid][deathPos][0],DeathInfo[playerid][deathPos][1],DeathInfo[playerid][deathPos][2]);
    SetPlayerFacingAngle(playerid, DeathInfo[playerid][deathPos][3]);

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
    ApplyAnimation(playerid,"CRACK","crckdeth2",4.1,0,1,1,1,1,1);
    format(string, sizeof(string), "без сознания [%s]", fine_time(DeathInfo[playerid][deathTime]));
    SetPlayerChatBubble(playerid,string, COLOR_LIGHTRED,20.0,1500);

    if(!IsPlayerInRangeOfPoint(playerid,0.8,DeathInfo[playerid][deathPos][0],DeathInfo[playerid][deathPos][1],DeathInfo[playerid][deathPos][2]))
    {
        PPSetPlayerPos(playerid,DeathInfo[playerid][deathPos][0],DeathInfo[playerid][deathPos][1],DeathInfo[playerid][deathPos][2]);
        SetPlayerFacingAngle(playerid, DeathInfo[playerid][deathPos][3]);
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
        TempTake(playerid, 0);
        PlayerInfo[playerid][pJailed] = 4;
        PlayerInfo[playerid][pJailTime] = 600;
        gYda[playerid] = 2;
  	    PPSpawnPlayer(playerid);
    } 
    else if(stat == 1) // Вылечили
    {
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

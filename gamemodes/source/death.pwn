
enum deathInfo
{
    bool:deathStatus, // Статус смерти
    deathTime, // Время валяния на земле
    deathUnix, // unix предыдущей смерти
    deathReason // id причина смерти
};
new DeathInfo[MAX_REALPLAYERS][deathInfo];

stock SetPlayerDeath(playerid, reason)
{
    new bool:nodeath;
    if(NoDeath(playerid)) nodeath = true;

    if(nodeath == true)
    {
        //SendClientMessageToAllf(-1, "SetPlayerDeath %d (reason %d) {ff0000}nodeath system", playerid, reason);
        return 0;
    }
    //else SendClientMessageToAllf(-1, "SetPlayerDeath %d (reason %d)", playerid, reason);

    // Отключаем процесс разных систем после смерти
    PlayerDeathSystems(playerid);

    GetPlayerPos(playerid,PlayerInfo[playerid][pLastPos][0],PlayerInfo[playerid][pLastPos][1],PlayerInfo[playerid][pLastPos][2]);
	GetPlayerFacingAngle(playerid,PlayerInfo[playerid][pLastPos][3]);

    //new Float:zpos;
    //CA_FindZ_For2DCoord(PlayerInfo[playerid][pLastPos][0],PlayerInfo[playerid][pLastPos][1], zpos);
    //PlayerInfo[playerid][pLastPos][2] = zpos + 1.0;

    PlayerInfo[playerid][pLastWorld] = GetPlayerVirtualWorld(playerid);
    PlayerInfo[playerid][pLastInt] = GetPlayerInterior(playerid);

    new unix = gettime();
    DeathInfo[playerid][deathStatus] = true;
    DeathInfo[playerid][deathReason] = reason;

    new timeDeath = 180, timeDeathTwo = 300;
    if(DeathInfo[playerid][deathUnix] >= unix) DeathInfo[playerid][deathTime] = timeDeathTwo; // 5 min
    else DeathInfo[playerid][deathTime] = timeDeath; // 3 min
    DeathInfo[playerid][deathUnix] = unix + 3600;

    ShowPlayerDeath(playerid);
    return 1;
}

stock ShowPlayerDeath(playerid)
{
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

    AutoMakeCreate(2,2,playerid);
    TempTake(playerid, 0);
    return 1;
}

stock NoDeath(playerid) // Не запускать систему смерти
{
    if(DeathInfo[playerid][deathStatus] // Уже мертв
    || PlayerInfo[playerid][pJailed] == 4 || PlayerInfo[playerid][pJailed] == 7 || PlayerInfo[playerid][pJailed] == 8 // В больке
    || MPGO[playerid] > 0 // На мп
    || (Kapt[fraction(playerid)] > 0 && IsAGhetto(playerid)) // Капт + На территории гетто
    || Zahvat[fraction(playerid)] > 0 // Порт
    || PlayerInfo[playerid][pBkyrenie] >= 2 // Луна, Марс
    || gSkafandr[playerid] > 0 && (GetPlayerInterior(playerid) == 221 && GetPlayerVirtualWorld(playerid) == 221 || GetPlayerInterior(playerid) == 222 && GetPlayerVirtualWorld(playerid) == 222) // В скафандре
    || peoInfo[playerid][peoInEditor] // personal editor
    || VehShopInfo[playerid][vsTest] // test drive
    || computerClubPlayerInfo[playerid][ccpiInGame] // Компьютерный клуб
    ||  IsPlayerInDynamicArea(playerid, zone_lava) || IsPlayerInDynamicArea(playerid, zone_lava2) // Умер в лаве
    || CA_IsPlayerNearWater(playerid, 1.0, 1.0)) return 1; // В воде
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
    NoAnim[playerid] = 1;

	S_SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pLastWorld], PlayerInfo[playerid][pLastInt]), SetPlayerInterior(playerid, PlayerInfo[playerid][pLastInt]);
	if(PlayerInfo[playerid][pBeret] == 0) Protect_MyWeapon(playerid); // Возвращаем оружие
	SetPlayerToTeamColor(playerid); // Возвращаем цвет

    if(DeathInfo[playerid][deathReason] == 54) PlayerInfo[playerid][pLastPos][2] -= 1.0;

    PPSetPlayerPos(playerid, PlayerInfo[playerid][pLastPos][0],PlayerInfo[playerid][pLastPos][1],PlayerInfo[playerid][pLastPos][2]);
    SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pLastPos][3]);

    UpdateDeathProcess(playerid);
    ACSetPlayerHealth(playerid, 90.0);
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
    if(!IsOnline(playerid)) return 1; // Проверка на online игрока

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
    AutoCloseMake(playerid);
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

stock UseRevival(playerid,targetid)
{
    if(DeathInfo[targetid][deathStatus] == false) return 0;
    new Float:x,Float:y,Float:z;
    GetPlayerPos(targetid,x,y,z);
    if(!IsPlayerInRangeOfPoint(playerid,1.0,x,y,z)) return ErrorMessage(playerid,"{ff6347}Вы слишком далеко от человека, которого хотели реанимировать. Повторите запрос.");
    if(fraction(playerid) == 4)
    {
        new wheretakemoney;
        if(PlayerInfo[targetid][pMoney] > friskPrice[8]*3) wheretakemoney = 0;
        else if(PlayerInfo[targetid][pAccount] > friskPrice[8]*3) wheretakemoney = 1;
        else
        {
            new string[65];
            format(string,sizeof(string),"{ff6347}У вас недостаточно средств для реанимации. Нужно %d$",friskPrice[8]*3);
            ErrorMessage(playerid,"{ff6347}У пациента недостаточно средств для реанимации");
            ErrorMessage(targetid,string);
            return 1;
        }
        if(wheretakemoney == 0) PlayerInfo[targetid][pMoney] -= friskPrice[8]*3;
        else PlayerInfo[targetid][pAccount] -= friskPrice[8]*3;
        mysql_save(targetid,0);
    }
    
    TakeInvent(playerid,8,1,0,999);
    OnlineInfo[targetid][oTimerAnimationRevival] = 7;
    ApplyAnimation(playerid,"MEDIC","CPR",4.0,0,1,1,0,0);
    update_ability(playerid, 10, 10 + random(5));

    around_player_audio(playerid, 5204, 0, 10.0, 1);
    return 1;
}

stock FindTargetRevival(playerid)
{
    new Float:x,Float:y,Float:z;
    GetPlayerPos(playerid,x,y,z);
    new otmena = -1;
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 0) continue;
        if(DeathInfo[i][deathStatus] == false) continue;
        if(IsPlayerInRangeOfPoint(i,1.0,x,y,z))
        {
            Moiplayer[playerid] = i;
            otmena = 1;
            break;
        }
    }
    if(otmena == -1) return ErrorMessage(playerid,"{ff6347}В радиусе 1 метра нет нуждающегося в реанимации человека.");
    else AcceptRevial(playerid);
    return 1;
}

stock AcceptRevial(playerid)
{
    if(fraction(playerid) == 4)
    {
        new string[160];
        format(string,sizeof(string),"Медик %s, хочет вас реанимировать. Стоимость: %d",rpplayername(playerid),friskPrice[8]*3);
        Moiplayer[Moiplayer[playerid]] = playerid;
        ShowDialog(Moiplayer[playerid],1483,DIALOG_STYLE_MSGBOX,"{ff9000}Лечение",string,"Принять","Отклонить");
        format(string,sizeof(string),"{66ff99}Вы отправили запрос на лечение %s. Ожидайте...",rpplayername(Moiplayer[playerid]));
        keep(playerid);
        SuccessMessage(playerid,string);
    }
    else
    {
        if(get_ability(playerid, 10) < 2 && !IsACop(playerid))
        {
            new stro[90],sctringo[450];
            format(stro,sizeof(stro),"\n{ff9000}Информация по системе реанимации:"), strcat(sctringo,stro);
            format(stro,sizeof(stro),"\n\n\n{cccccc}- Для лечения человека вам нужна аптечка"), strcat(sctringo,stro);
            format(stro,sizeof(stro),"\n{cccccc}- А так же 2 уровень навыка Медик или же быть участником ПД или МЗ"), strcat(sctringo,stro);
            format(stro,sizeof(stro),"\n{cccccc}- Каждая реанимация добавляет определенное количество очков в скилл"), strcat(sctringo,stro);
            format(stro,sizeof(stro),"\n{cccccc}- Для повышения навыка требуется трудоустроиться в ПД или МЗ"), strcat(sctringo,stro);
            ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Реанимация",sctringo,"Ок","");
        }
        UseRevival(playerid,Moiplayer[playerid]);
    }
    return 1;
}
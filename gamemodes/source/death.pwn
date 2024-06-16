
enum deathInfo
{
    bool:deathStatus, // Статус смерти
    deathTime, // Время валяния на земле
    deathUnix, // unix предыдущей смерти
    deathReason, // id причина смерти
    bool:deathCut // сокращённое время смерти
};
new DeathInfo[MAX_REALPLAYERS][deathInfo];

CMD:deathcut(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "Вы не можете использовать эту команду");
    if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Изменить время для реанимации [ /deathcut ID ]");
    if(!IsOnline(params[0])) return ErrorMessage(playerid, "Игрока нет в сети");

    new string[100];
    if(DeathInfo[params[0]][deathCut] == false) 
    {
        DeathInfo[params[0]][deathCut] = true;
        format(string, sizeof(string), "Вы включили сокращённое время для реанимации игроку %s", PlayerInfo[params[0]][pName]);
	    SendClientMessage(playerid, COLOR_WHITE, string);
    }
    else 
    {
        DeathInfo[params[0]][deathCut] = false;
        format(string, sizeof(string), "Вы отключили сокращённое время для реанимации игроку %s", PlayerInfo[params[0]][pName]);
	    SendClientMessage(playerid, COLOR_WHITE, string);
    }

    if(params[0] != playerid)
    {
        format(string, sizeof(string), "Администратор %s изменил ваше время для реанимации", PlayerInfo[playerid][pName]);
        SendClientMessage(params[0], COLOR_WHITE, string);
    }
    return 1;
}

stock SetPlayerDeath(playerid, reason)
{
    new bool:nodeath;
    if(NoDeath(playerid)) nodeath = true;

    if(nodeath == true) // Если сдох от взрыва, тогда в пизду не умираем
    {
        //SendClientMessageToAllf(-1, "SetPlayerDeath %d (reason %d) {ff0000}nodeath system", playerid, reason);
        return 0;
    }
    //else SendClientMessageToAllf(-1, "SetPlayerDeath %d (reason %d)", playerid, reason);

    // Отключаем процесс разных систем после смерти
    PlayerDeathSystems(playerid);

    if(MPGO[playerid] == 0) PlayerInfo[playerid][pDeaths] ++; // Засчитываем Смерть

    GetPlayerPos(playerid,PlayerInfo[playerid][pLastPos][0],PlayerInfo[playerid][pLastPos][1],PlayerInfo[playerid][pLastPos][2]);
	GetPlayerFacingAngle(playerid,PlayerInfo[playerid][pLastPos][3]);

    // Корректируем игрока по высоте
    new Float:zpos;
    CA_FindZ_For2DCoord(PlayerInfo[playerid][pLastPos][0],PlayerInfo[playerid][pLastPos][1], zpos);
    if(PlayerInfo[playerid][pLastPos][2] > zpos + 1.0) PlayerInfo[playerid][pLastPos][2] = zpos + 1.0;

    // Сразу ставим игрока в новую Z координату
    if(reason != 51) ReturnPositionDeath(playerid); // Только если умер не от взрыва

    PlayerInfo[playerid][pLastWorld] = GetPlayerVirtualWorld(playerid);
    PlayerInfo[playerid][pLastInt] = GetPlayerInterior(playerid);

    new unix = gettime();
    DeathInfo[playerid][deathStatus] = true;
    DeathInfo[playerid][deathReason] = reason;

    new timeDeath = 180, timeDeathTwo = 300;
    if(DeathInfo[playerid][deathCut] == true) timeDeath = 10, timeDeathTwo = 10;
    
    if(DeathInfo[playerid][deathUnix] >= unix) DeathInfo[playerid][deathTime] = timeDeathTwo; // 5 min
    else DeathInfo[playerid][deathTime] = timeDeath; // 3 min
    DeathInfo[playerid][deathUnix] = unix + 3600;

    ShowPlayerDeath(playerid);

    #if defined SAMPVOICE_COMPILE_3
    SampvoiceStopTalking(playerid);
    #endif
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
    new g = fraction(playerid);
    if(DeathInfo[playerid][deathStatus] // Уже мертв
    || PlayerInfo[playerid][pJailed] == 4 || PlayerInfo[playerid][pJailed] == 7 || PlayerInfo[playerid][pJailed] == 8 // В больке
    || MPGO[playerid] > 0 // На мп
    || (Kapt[g] > 0) // && IsAGhetto(playerid)) // Капт + На территории гетто
    || ChutC[g] >= 1 // Добив после капта
    || Zahvat[g] > 0 // Порт
    || PlayerInfo[playerid][pBkyrenie] >= 2 // Луна, Марс
    || gSkafandr[playerid] > 0 && (GetPlayerInterior(playerid) == 221 && GetPlayerVirtualWorld(playerid) == 221 || GetPlayerInterior(playerid) == 222 && GetPlayerVirtualWorld(playerid) == 222) // В скафандре
    || peoInfo[playerid][peoInEditor] // personal editor
    || VehShopInfo[playerid][vsTest] // test drive
    || computerClubPlayerInfo[playerid][ccpiInGame] // Компьютерный клуб
    || IsPlayerInDynamicArea(playerid, zone_lava) || IsPlayerInDynamicArea(playerid, zone_lava2) // Умер в лаве
    || CA_IsPlayerNearWater(playerid, 1.0, 1.0) // В воде
    || (bespilot[playerid] != 0 || GetTickCount() - bespilotejecttick[playerid] < 1000)) return 1; // NGSA беспилотник
    return 0;
}

stock NoHospital(playerid) // Не отправлять в госпиталь при смерти
{
    new g = fraction(playerid);
    if(PlayerInfo[playerid][pJailed] == 4 || PlayerInfo[playerid][pJailed] == 7 || PlayerInfo[playerid][pJailed] == 8 // В больке
    || MPGO[playerid] > 0 // На мп
    || Kapt[g] > 0 && IsAGhetto(playerid) // Капт + На территории гетто
    || ChutC[g] >= 1 // Добив после капта
    || Zahvat[g] > 0 // Порт
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
	S_SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pLastWorld], PlayerInfo[playerid][pLastInt]), PPSetPlayerInterior(playerid, PlayerInfo[playerid][pLastInt]);
	if(PlayerInfo[playerid][pBeret] == 0) Protect_MyWeapon(playerid); // Возвращаем оружие
	SetPlayerToTeamColor(playerid); // Возвращаем цвет

    ReturnPositionDeath(playerid);
    UpdateDeathProcess(playerid);
    ACSetPlayerHealth(playerid, 90.0);
    return 1;
}

stock UpdateDeathProcess(playerid)
{
    UpdateDeathDrawProcess(playerid);

    new string[24];
    //TogglePlayerControllable(playerid, false);
    ApplyAnimation(playerid,"CRACK","crckidle2",3.0, false, true, true, true, true, SYNC_ALL);
    format(string, sizeof(string), "без сознания [%s]", fine_time(DeathInfo[playerid][deathTime]));
    SetPlayerChatBubble(playerid,string, COLOR_LIGHTRED,20.0,1500);

    if(!IsPlayerInRangeOfPoint(playerid,0.8,PlayerInfo[playerid][pLastPos][0],PlayerInfo[playerid][pLastPos][1],PlayerInfo[playerid][pLastPos][2]))
    {
        ReturnPositionDeath(playerid);
    }
    return 1;
}

stock ReturnPositionDeath(playerid)
{
    PPSetPlayerPos(playerid,PlayerInfo[playerid][pLastPos][0],PlayerInfo[playerid][pLastPos][1],PlayerInfo[playerid][pLastPos][2]);
    PPSetPlayerFacingAngle(playerid, PlayerInfo[playerid][pLastPos][3]);
    return true;
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
        TogglePlayerControllable(playerid, true);
        ClearAnimations(playerid);
    }

    DestroyMake(playerid);
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

stock UseRevival(playerid, targetid)
{
    if(DeathInfo[targetid][deathStatus] == false) return 0;
    new Float:x,Float:y,Float:z;
    GetPlayerPos(targetid,x,y,z);
    if(!IsPlayerInRangeOfPoint(playerid,1.0,x,y,z)) return ErrorMessage(playerid,"{ff6347}Вы слишком далеко от человека, которого хотели реанимировать. Повторите запрос.");
    if(fraction(playerid) == 4)
    {
        if(PlayerInfo[targetid][pAccount] < friskPrice[8]*3 && PlayerInfo[targetid][pMoney] < friskPrice[8]*3)
        {
            new string[65];
            format(string,sizeof(string),"{ff6347}У вас недостаточно средств для реанимации. Нужно %d$",friskPrice[8]*3);
            ErrorMessage(playerid,"{ff6347}У пациента недостаточно средств для реанимации");
            ErrorMessage(targetid,string);
            return 1;
        }
    }
    
    OnlineInfo[targetid][oTimerAnimationRevival] = 7;
    ApplyAnimation(playerid,"MEDIC","CPR",4.0, false, true, true, false, false, SYNC_ALL);
    return 1;
}

stock CloseRevival(playerid,targetid)
{
    if(playerid == 9999) return 0;
    if(DeathInfo[targetid][deathStatus] == false) return 0;
    new Float:x,Float:y,Float:z;
    GetPlayerPos(targetid,x,y,z);
    if(!IsPlayerInRangeOfPoint(playerid,1.0,x,y,z)) return ErrorMessage(playerid,"{ff6347}Вы слишком далеко от человека, которого хотели реанимировать");

    if(fraction(playerid) == 4)
    {
        new price = friskPrice[8]*3;
        new wheretakemoney;
        if(PlayerInfo[targetid][pMoney] > price) wheretakemoney = 0;
        else if(PlayerInfo[targetid][pAccount] > price) wheretakemoney = 1;
        else
        {
            new string[65];
            format(string,sizeof(string),"{ff6347}У вас недостаточно средств для реанимации. Нужно %d$",price);
            ErrorMessage(targetid,string);
            ErrorMessage(playerid,"{ff6347}У пациента недостаточно средств для реанимации");
            return 1;
        }
        if(wheretakemoney == 0) PlayerInfo[targetid][pMoney] -= price;
        else PlayerInfo[targetid][pAccount] -= price;
        mysql_save(targetid,0);

        // Кладём деньги на счет ASGH
        OrganInfo[4][glave] += price;
	    OrganInfo[4][gUpdate] = true;

        // Выдаём медику юниты за реанимацию
        GiveUnit(playerid, 21);
    }
    
    // Закрываем вызов и сообщаем, что мы вылечили пострадавшего
    RevivalCloseMake(targetid, playerid);

    TakeInvent(playerid,8,1,0,999);
    update_ability(playerid, 10, 10 + random(5));
    ACSetPlayerHealth(targetid, 100);
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
        Moiplayer[Moiplayer[playerid]] = playerid;
        if (!IsPlayerAfk(Moiplayer[playerid]))
        {
            new string[160];
            format(string,sizeof(string),"{cccccc}Медик %s хочет вас реанимировать. Стоимость: %d$",rpplayername(playerid),friskPrice[8]*3);
            ShowDialog(Moiplayer[playerid],1483,DIALOG_STYLE_MSGBOX,"{ff9000}Лечение",string,"Принять","Отклонить");
            format(string,sizeof(string),"{66ff99}Вы предложили %s оказание медицинской помощи. Ожидайте ответа...",rpplayername(Moiplayer[playerid]));
            keep(playerid);
            SuccessMessage(playerid,string);
        }
        else
        {
            UseRevival(playerid, Moiplayer[playerid]);
        }
    }
    else
    {
        if(get_ability(playerid, 10) < 2 && !IsPoliceMember(playerid))
        {
            new stro[90],sctringo[450];
            format(stro,sizeof(stro),"\n{ff9000}Как реанимировать пострадавшего?"), strcat(sctringo,stro);
            format(stro,sizeof(stro),"\n\n{cccccc}- Для реанимации вам нужна аптечка"), strcat(sctringo,stro);
            format(stro,sizeof(stro),"\n{cccccc}- Аптечку можно приобрести в любой аптеке [ Y >> GPS >> Услуги >> Аптека ]"), strcat(sctringo,stro);
            format(stro,sizeof(stro),"\n{cccccc}- Если вы не полицейский и не доктор, вам потребуется 2 уровень Навыка Медка"), strcat(sctringo,stro);
            format(stro,sizeof(stro),"\n{cccccc}- Чтобы прокачать навык вам потребуется стать доктором и реанимировать пострадавших"), strcat(sctringo,stro);
            format(stro,sizeof(stro),"\n{cccccc}- Так-же вы можете приобрести навык [ Y >> Donate ]"), strcat(sctringo,stro);
            return ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Реанимация",sctringo,"Ок","");
        }
        Moiplayer[Moiplayer[playerid]] = playerid;
        UseRevival(playerid, Moiplayer[playerid]);
    }
    return 1;
}

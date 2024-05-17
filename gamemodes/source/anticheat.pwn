
#define CHEAT_HISTORY 30 // количество записей варнингов у каждого игрока
#define TRIG_DGUN 5 // количество триггеров на dgun
#define TRIG_DISTANCE_DAMAGE 5 // количество триггеров на dgun
#define TIME_TO_SPAWN 10 // Игроку даётся время в секундх на выполнение спавна от сервера, иначе кик

new cheatName[][] =
{
    "Rvanka", "DGun", "Distance Damage"
};

enum achInfo
{
    achWarnings, // Количество варнингов в целом
	achTrigger[CHEAT_HISTORY], // ID чита, который тригерится на игрока
    achPing[CHEAT_HISTORY], // Пинг в момент триггера
    achUnix[CHEAT_HISTORY], // Время в момент триггер
    Float:achLoss[CHEAT_HISTORY], // Loss в момент триггера
    achFakeafk // Fake AFK
};
new AnticheatInfo[MAX_REALPLAYERS][achInfo];

new AnticheatTriggers[MAX_REALPLAYERS][sizeof(cheatName)];
new AnticheatTick[MAX_REALPLAYERS][sizeof(cheatName)];

stock ShowMenuTriggers(playerid) // Меню всех игроков с триггерами онлайн
{
    new line[214],lines[4096],quan;
	    
    // Триггеры на какие читы выводим в меню
    new kolimn0 = 0; // Rvanka
    new kolimn1 = 1; // DGun
    new kolimn2 = 2; // Distance Damage

    format(line,sizeof(line),"Имя\t%s\t%s\t%s", cheatName[kolimn0], cheatName[kolimn1], cheatName[kolimn2]), strcat(lines,line);
    foreach (Player, i)
	{
        if(AnticheatInfo[i][achWarnings] > 0)
        {
            List[quan][playerid] = i;
            quan ++;
            format(line,sizeof(line),"\n%s[%d] \t %d \t %d \t %d", PlayerInfo[i][pName], i, AnticheatTriggers[i][kolimn0], AnticheatTriggers[i][kolimn1], AnticheatTriggers[i][kolimn2]), strcat(lines,line);
        }
    }
    ShowDialog(playerid,830,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Триггеры Античита",lines,"Выбор","Отмена");
    return 1;
}

// Обработка триггера (записываем, кикаем и так далее)
stock TriggerCheat(playerid, cheatid)
{
    new unix = gettime();

    if(AnticheatTriggers[playerid][cheatid] > 0) // Если варнинг уже был, перекидываем историю на строку ниже
    {
        for(new i = CHEAT_HISTORY - 1; i > 0; i--)
        {
            if(AnticheatInfo[playerid][achTrigger][i - 1] == 0) continue;

            if(unix - AnticheatInfo[playerid][achUnix][i - 1] >= 300 && cheatid == 0 // Устаревший триггер более 5 минут
                || unix - AnticheatInfo[playerid][achUnix][i - 1] >= 180 && (cheatid == 1 || cheatid == 2)) // Устаревший триггер более 3 минут
            {
                // Очищаем устаревший триггер
                ClearTrigger(playerid, cheatid, i);
            }
            else
            {
                AnticheatInfo[playerid][achTrigger][i] = AnticheatInfo[playerid][achTrigger][i - 1];
                AnticheatInfo[playerid][achPing][i] = AnticheatInfo[playerid][achPing][i - 1];
                AnticheatInfo[playerid][achUnix][i] = AnticheatInfo[playerid][achUnix][i - 1];
                AnticheatInfo[playerid][achLoss][i] = AnticheatInfo[playerid][achLoss][i - 1];
            }
        }
    }

    AnticheatTriggers[playerid][cheatid] ++; // Считаем количество триггеров на конкретный чит
    AnticheatInfo[playerid][achWarnings] ++; // Считаем общее количество триггеров у игрока

    // Записываем в первую строку историю варнинга
    AnticheatInfo[playerid][achTrigger][0] = cheatid + 1; // id триггера
    AnticheatInfo[playerid][achPing][0] = GetPlayerPing(playerid); // пинг
    AnticheatInfo[playerid][achUnix][0] = unix; // unix
    AnticheatInfo[playerid][achLoss][0] = NetStats_PacketLossPercent(playerid); // loss

    // Rvanka
    if(cheatid == 0)
    {
        new string[140];
        format(string, sizeof(string), " [ ADM ]: %s[%d] Подозрение на {FF6347}Rvanka (ping %d) {cccccc}(warning)", PlayerInfo[playerid][pName],playerid, GetPlayerPing(playerid));
		MessageCheat(0, string);
    }

    // DGun
    else if(cheatid == 1)
    {
        if(AnticheatTriggers[playerid][cheatid] >= TRIG_DGUN)
        {
            printf("[SProtect Kick]: DGun %s",PlayerInfo[playerid][pName]);
            SendClientMessage(playerid, COLOR_LIGHTRED, "* {0066ff}Protect Project: {FF6347}Вы были кикнуты по подозрению в читерстве [DGun]");
            ShowDialog(playerid,11002,DIALOG_STYLE_MSGBOX,"{ff0000}Protect Project","{ff0000}Вы были кикнуты по подозрению в читерстве [DGun]","*","");
            Kickx(playerid);
        }
        else
        {
            new string[140];
            format(string, sizeof(string), " [ ADM ]: %s[%d] Подозрение на {FF6347}DGun (ping %d) {cccccc}(warning)", PlayerInfo[playerid][pName],playerid, GetPlayerPing(playerid));
            MessageCheat(0, string);
        }
    }

    // Distance Damage
    else if(cheatid == 2)
    {
        if(AnticheatTriggers[playerid][cheatid] >= TRIG_DISTANCE_DAMAGE)
        {
            printf("[SProtect Kick]: Distance Damage %s",PlayerInfo[playerid][pName]);
            SendClientMessage(playerid, COLOR_LIGHTRED, "* {0066ff}Protect Project: {FF6347}Вы были кикнуты по подозрению в читерстве [Distance Damage]");
            ShowDialog(playerid,11002,DIALOG_STYLE_MSGBOX,"{ff0000}Protect Project","{ff0000}Вы были кикнуты по подозрению в читерстве [Distance Damage]","*","");
            Kickx(playerid);
        }
    }
    return 1;
}

// Собираем варнинги на DGun
stock AnticheatGunTrigger(playerid, weaponid)
{
    new slot = Protect_Slot(weaponid), unix = gettime();
    if(ResetWeaponUnix[playerid][slot] <= unix)
	{
        if(ProtectInfo[playerid][prWeapon][slot] != weaponid
            || weaponid > 0 && ProtectInfo[playerid][prAmmo][slot] <= 0)
        {
            new current_tick = GetTickCount();
            new interval = GetTickDiff(current_tick, AnticheatTick[playerid][1]);
            if(interval > 400)
            {
                AnticheatTick[playerid][1] = current_tick;

                RemovePlayerWeapon(playerid, WEAPON:weaponid); // Отнимаем оружие у засранца
                if(ResetAmmoUnix[playerid][slot] == 1) return ResetAmmoUnix[playerid][slot] = 0;

                // Записываем тригер
                TriggerCheat(playerid, 1);
            }
		}
    }
    return 1;
}

// Кикаем сразу, если игрок стреляет из читерского оружия
stock AnticheatGunKick(playerid, weaponid)
{
    new slot = Protect_Slot(weaponid), unix = gettime();
    if(ResetWeaponUnix[playerid][slot] <= unix)
	{
        if(ProtectInfo[playerid][prWeapon][slot] != weaponid)
        {
            RemovePlayerWeapon(playerid, WEAPON:weaponid); // Отнимаем оружие у засранца
            if(ResetAmmoUnix[playerid][slot] == 1) return ResetAmmoUnix[playerid][slot] = 0; // Защита при последнем выстреле

            printf("[SProtect Kick]: DGun Bullet %s weaponid %d (ping: %d)",PlayerInfo[playerid][pName], weaponid, GetPlayerPing(playerid));
            SendClientMessage(playerid, COLOR_LIGHTRED, "* {0066ff}Protect Project: {FF6347}Вы были кикнуты по подозрению в читерстве [DGun Bullet]");
            ShowDialog(playerid,11002,DIALOG_STYLE_MSGBOX,"{ff0000}Protect Project","{ff0000}Вы были кикнуты по подозрению в читерстве [DGun Bullet]","*","");
            Kickx(playerid);
        }
    }
    return 1;
}

stock AnticheatDistanceDamage(playerid, damagedid, weaponid)
{
    if(weaponid <= 15 || weaponid == 41 || weaponid == 42) // Нестреляющее оружие, Spraycan, огнетушитель
    {
        if(!ProxDetectorS(4.0, playerid, damagedid)) // Игроки находятся дальше 8 метров друг от друга
        {
            // Записываем тригер
            TriggerCheat(playerid, 2);
        }
    }
    return 1;
}


// Тестовая команда выдачи оружия в обход античита (по сути, как игрок выдаёт себе читом)
/*CMD:triggun(playerid)
{
    if(server != 0) return 0;
    GivePlayerWeapon(playerid, WEAPON:38, 3000);
    return 1;
}*/


// ===========================================================
// Внизу нехер менять при добавлении новой записи для античита
// ===========================================================
alias:trigger("triger", "trigers", "triggers", "trig")
CMD:trigger(playerid)
{
    if(PlayerInfo[playerid][pSoska] == 0 && PlayerInfo[playerid][pHidden] == 0 && PlayerInfo[playerid][pMedia] != 3) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    ShowMenuTriggers(playerid);
    return 1;
}

stock ShowPlayerTriggers(playerid, targetid) // Меню конкретного игрока с триггерами
{
    if(!IsOnline(targetid)) return ErrorMessage(playerid, "{FF6347}Ошибка! Игрока нет в сети");

    new line[100],lines[100 * CHEAT_HISTORY];
    format(line,sizeof(line),"Триггер\tПинг\tLoss\tВремя"), strcat(lines,line);
    for(new i = 0; i < CHEAT_HISTORY; i++)
	{
        if(AnticheatInfo[targetid][achTrigger][i] > 0)
        {
            new cheatid = AnticheatInfo[targetid][achTrigger][i] - 1;
            new tyear, tmonth, tday, thour, tminute, tsecond;
			stamp2datetime(AnticheatInfo[targetid][achUnix][i], tyear, tmonth, tday, thour, tminute, tsecond, 3);

            format(line,sizeof(line),"\n%s \t %d \t %f \t %02d:%02d:%02d", cheatName[cheatid], AnticheatInfo[targetid][achPing][i], AnticheatInfo[targetid][achLoss][i], thour, tminute, tsecond), strcat(lines,line);
        }
    }
    format(line,sizeof(line),"{ff9000}Триггеры %s[%d]: %d", PlayerInfo[targetid][pName], targetid, AnticheatInfo[targetid][achWarnings]);
    ShowDialog(playerid,828,DIALOG_STYLE_TABLIST_HEADERS,line,lines,"Выбор","Отмена");
    return 1;
}

stock dialogCase_Anticheat(playerid, dialogid, response, listitem)
{
    if(dialogid == 830)
    {
        if(response)
        {
            if(listitem < 0 || listitem >= 200) return 1;

            new targetid = List[listitem][playerid];
            if(!IsOnline(targetid)) return ShowMenuTriggers(playerid); // Игрок offline

            DP[0][playerid] = targetid;
            ShowPlayerTriggers(playerid, targetid);
        }
    }
    else if(dialogid == 828) ShowMenuTriggers(playerid);
    return 1;
}

// Удаляем один триггер
stock ClearTrigger(playerid, cheatid, i)
{
    AnticheatTriggers[playerid][cheatid] --;
    AnticheatTick[playerid][cheatid] = 0;

    AnticheatInfo[playerid][achTrigger][i] = 0;
    AnticheatInfo[playerid][achPing][i] = 0;
    AnticheatInfo[playerid][achUnix][i] = 0;
    AnticheatInfo[playerid][achLoss][i] = 0;
    return 1;
}

stock MessageCheat(cheat, const string[]) // Сообщение о читере в чат админу
{
	if(cheat == 0) // /rvanka
	{
		foreach (Player, i)
		{
			if(PlayerInfo[i][pSoska] >= 1 && GetPVarInt(i,"Readcheat") == 1 && OnlineInfo[i][oLogged] == 1)
			{
				SendClientMessage(i, COLOR_ADM, string);
			}
		}
	}
	return 1;
}

// Кд античита на оружие
stock GivePlayerResetWeaponUnix(playerid)
{
    for(new i = 0; i < MAX_WEAPON_SLOTS; i++)
    {
        if(ProtectInfo[playerid][prWeapon][i] >= 0 && ProtectInfo[playerid][prAmmo][i] >= 0) ResetWeaponUnix[playerid][i] = gettime() + 5;
    }
    return 1;
}

// Защита от игнора спавна
stock AntiIgnoreSpawn(playerid)
{
    if(OnlineInfo[playerid][oSpawnUnix] > 0 
        && gettime() - OnlineInfo[playerid][oSpawnUnix] >= TIME_TO_SPAWN)
    {
        printf("[SProtect Kick]: Ignore Spawn %s (ping: %d)",PlayerInfo[playerid][pName], GetPlayerPing(playerid));
        SendClientMessage(playerid, COLOR_LIGHTRED, "* {0066ff}Protect Project: {FF6347}Вы были кикнуты по подозрению в читерстве [Ignore Spawn]");
        ShowDialog(playerid,11002,DIALOG_STYLE_MSGBOX,"{ff0000}Protect Project","{ff0000}Вы были кикнуты по подозрению в читерстве [Ignore Spawn]","*","");
        Kickx(playerid);
    }
    return 1;
}

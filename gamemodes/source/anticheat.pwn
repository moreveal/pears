
#define MAX_CHEATS 1 // Количество читов, на которые срабатывает античит
#define CHEAT_HISTORY 20 // количество записей варнингов у каждого игрока

new cheatName[][] =
{
    "Rvanka"
};



enum achInfo
{
    achWarnings, // Количество варнингов в целом
	achTrigger[CHEAT_HISTORY], // ID чита, который тригерится на игрока
    achPing[CHEAT_HISTORY], // Пинг в момент триггера
    achUnix[CHEAT_HISTORY], // Время в момент триггер
    Float:achLoss[CHEAT_HISTORY] // Loss в момент триггера
};
new AnticheatInfo[MAX_REALPLAYERS][achInfo];

new AnticheatTriggers[MAX_REALPLAYERS][MAX_CHEATS];

CMD:triggers(playerid) return cmd_trigger(playerid);
CMD:trigers(playerid) return cmd_trigger(playerid);
CMD:triger(playerid) return cmd_trigger(playerid);
CMD:trigger(playerid)
{
    if(PlayerInfo[playerid][pSoska] == 0 && PlayerInfo[playerid][pHidden] == 0) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

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

stock ShowMenuTriggers(playerid) // Меню всех игроков с триггерами онлайн
{
    new line[214],lines[4096],quan;
	    
    new kolimn0 = 0; // Отображаем количество срабатываний рванки в первой колонке

    format(line,sizeof(line),"Имя\t%s", cheatName[kolimn0]), strcat(lines,line);
    foreach (Player, i)
	{
        if(AnticheatInfo[i][achWarnings] > 0)
        {
            List[quan][playerid] = i;
            quan ++;
            format(line,sizeof(line),"\n%s[%d] \t %d", PlayerInfo[i][pName], i, AnticheatTriggers[i][kolimn0]), strcat(lines,line);
        }
    }
    ShowDialog(playerid,830,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Триггеры Античита",lines,"Выбор","Отмена");
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
            DP[0][playerid] = targetid;
            ShowPlayerTriggers(playerid, targetid);
        }
    }
    else if(dialogid == 828) ShowMenuTriggers(playerid);
    return 1;
}

stock TriggerCheat(playerid, cheatid) // Записываем триггер в список
{
    AnticheatTriggers[playerid][cheatid] ++; // Считаем количество триггеров на конкретный чит
    AnticheatInfo[playerid][achWarnings] ++; // Считаем общее количество триггеров у игрока

    if(AnticheatInfo[playerid][achWarnings] > 0) // Если варнинг уже был, перекидываем историю на строку ниже
    {
        for(new i = CHEAT_HISTORY - 1; i > 0; i--)
        {
            if(AnticheatInfo[playerid][achTrigger][i - 1] > 0)
            {
                new tempi = i;
                if(i - 1 <= 0) tempi = 0;
                AnticheatInfo[playerid][achTrigger][tempi] = AnticheatInfo[playerid][achTrigger][i - 1];
                AnticheatInfo[playerid][achPing][tempi] = AnticheatInfo[playerid][achPing][i - 1];
                AnticheatInfo[playerid][achUnix][tempi] = AnticheatInfo[playerid][achUnix][i - 1];
                AnticheatInfo[playerid][achLoss][tempi] = AnticheatInfo[playerid][achLoss][i - 1];
            }
        }
    }

    // Записываем в первую строку историю варнинга
    AnticheatInfo[playerid][achTrigger][0] = cheatid + 1; // id триггера
    AnticheatInfo[playerid][achPing][0] = GetPlayerPing(playerid); // пинг
    AnticheatInfo[playerid][achUnix][0] = gettime(); // unix
    AnticheatInfo[playerid][achLoss][0] = NetStats_PacketLossPercent(playerid); // loss

    if(cheatid == 0)
    {
        new string[140];
        format(string, sizeof(string), " [ ADM ]: %s[%d] Подозрение на {FF6347}Rvanka (ping %d) {cccccc}(warning)", PlayerInfo[playerid][pName],playerid, GetPlayerPing(playerid));
		MessageCheat(0, string);
    }
    return 1;
}

stock MessageCheat(cheat, const string[]) // Сообщение о читере в чат админу
{
	if(cheat == 0) // /rvanka
	{
		foreach (Player, i)
		{
			if(PlayerInfo[i][pSoska] >= 1 && GetPVarInt(i,"Readrvanka") == 1 && OnlineInfo[i][oLogged] == 1)
			{
				SendClientMessage(i, COLOR_ADM, string);
			}
		}
	}
	return 1;
}

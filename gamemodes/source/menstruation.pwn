
new MenstruationDestroy[MAX_REALPLAYERS];
new bool:MenstruanionDayInfo[MAX_REALPLAYERS];

// Процесс запуска или создания даты менструации
stock TimeMenstruation(playerid)
{
    if(PlayerInfo[playerid][pSex] == 2) // Только женщины
    {
        new unix = gettime();
        if(PlayerInfo[playerid][pMenstrDay] == 0 || unix > PlayerInfo[playerid][pMenstrDay]) // День не создан или уже прошёл (назначаем новый)
        {
            PlayerInfo[playerid][pMenstrDay] = unix + 1814400;
            PlayerInfo[playerid][pMenstrProkl] = 0;
            SaveMenstruation(playerid);
        }
        else if(unix <= PlayerInfo[playerid][pMenstrDay] && unix >= PlayerInfo[playerid][pMenstrDay] - TIME_MENSTRUATION) // Настал тот самый день
        {
            if(PlayerInfo[playerid][pMenstrProkl] == 0) ShowMenstruation(playerid); // Запускаем менструацию (если не применены прокладки на сегодняшний день)
        }
    }
    return true;
}

stock SaveMenstruation(playerid)
{
    // Сохраняем
    new string_mysql[140];
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_igroki` SET `pMenstrDay` = '%d', `pMenstrProkl` = '%d' WHERE `user_id` = '%d'", 
        PlayerInfo[playerid][pMenstrDay], PlayerInfo[playerid][pMenstrProkl], PlayerInfo[playerid][pID]);
    query_empty(pearsq, string_mysql);
    return true;
}

stock ShowMenstruation(playerid)
{
    if(MenstruanionDayInfo[playerid] == false)
    {
        new lines[280];
		format(lines,sizeof(lines),"{B21515}Красавица, у тебя начались месячные\
		                        \n{99ff66}Отправляйся в аптеку и купи прокладки\
		                        \n\n{cccccc}- Месячные будут длиться в течении %d дней\
                                \n{cccccc}- В это время у тебя будет происходить кровотечение", TIME_MENSTRUATION / 86400);
		ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
      	SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Блин! У меня начались {B21515}месячные {cccccc}[ Мне нужно купить прокладки в аптеке ]");

        MenstruanionDayInfo[playerid] = true;
    }
    SetPlayerAttachedObject(playerid, 0, 18668, 1, -0.991000, 0.211000, -0.223999, 0.000000, 0.000000, 0.000000, 0.111999, 0.101999, 0.120000, 0, 0);
    MenstruationDestroy[playerid] = SetTimerEx("DestroyMenstruation", 300, false, "d", playerid);
    return true;
}

function DestroyMenstruation(playerid)
{
    KillTimer(MenstruationDestroy[playerid]);
    MenstruationDestroy[playerid] = 0;
    RemovePlayerAttachedObject(playerid, 0);
    return true;
}

stock ClearMenstruation(playerid)
{
    MenstruanionDayInfo[playerid] = false;
    return true;
}

CMD:menstruation(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 15) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу использовать эту команду");
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Запустить менструацию сегодня [ /menstuation ID ]");
	if(IsOnline(params[0]))
	{
        if(PlayerInfo[params[0]][pSex] != 2) return ErrorMessage(playerid, "{FF6347}Менструацию можно запустить только для женщины");
        SendClientMessage(params[0], COLOR_LIGHTBLUE, "* Администратор %s запустил вам менструацию.", PlayerInfo[playerid][pName]);
        SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы запустили менструацию для %s.", PlayerInfo[params[0]][pName]);
        PlayerInfo[params[0]][pMenstrDay] = gettime() + TIME_MENSTRUATION - 60;
        PlayerInfo[params[0]][pMenstrProkl] = 0;
        TimeMenstruation(params[0]);
        SaveMenstruation(playerid);
	}
	else ErrorMessage(playerid, "{FF6347}Этого игрока нет в сети");
	return 1;
}


/*
- Использовать прокладки
- Положить прокладк в аптеку + покупка
*/
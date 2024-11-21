
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
        new lines[420];
		format(lines,sizeof(lines),"{B21515}Красавица, у тебя начались месячные\
		                        \n{99ff66}Отправляйся в аптеку и купи прокладки\
		                        \n\n{cccccc}- Месячные будут длиться в течении %d дней\
                                \n{cccccc}- В это время у тебя будет происходить кровотечение\
                                \n{cccccc}- Кровотечение влияет на гигиену и персонажу нужно будет помыться\
                                \n{cccccc}- О цикле менструации вы можете узнавать в мед. карте", TIME_MENSTRUATION / 86400);
		ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
      	SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Блин! У меня начались {B21515}месячные {cccccc}[ Мне нужно купить прокладки в аптеке ]");

        MenstruanionDayInfo[playerid] = true;
    }
    SetPlayerAttachedObject(playerid, 0, 18668, 1, -1.106999, 0.171000, -0.043000, 0.000000, 87.399993, 0.000000, 0.302000, 0.296000, 0.281999, 0, 0);
    MenstruationDestroy[playerid] = SetTimerEx("DestroyMenstruation", 300, false, "d", playerid);

    // Уменьшаем гигиену
    if(PlayerInfo[playerid][pInfoload] >= 50) PlayerInfo[playerid][pInfoload] -= 50;
    return true;
}

function DestroyMenstruation(playerid)
{
    KillTimer(MenstruationDestroy[playerid]);
    MenstruationDestroy[playerid] = 0;
    RemovePlayerAttachedObject(playerid, 0);

    // Включаем мух, если игрок грязный
    if(PlayerInfo[playerid][pInfoload] <= 50) SetPlayerAttachedObject(playerid,0,18698,1,0.388000,0.000000,-1.475000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000); // Мухи
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

CMD:usepads(playerid, const params[])
{
    if(PlayerInfo[playerid][pSex] != 2) return ErrorMessage(playerid, "{FF6347}Использовать прокладки могут только женщины");

    new unix = gettime();
    if(unix <= PlayerInfo[playerid][pMenstrDay] && unix >= PlayerInfo[playerid][pMenstrDay] - TIME_MENSTRUATION) // Настал тот самый день
    {
        if(PlayerInfo[playerid][pMenstrProkl] != 0) return ErrorMessage(playerid, "{FF6347}Вы уже использовали прокладки\n{ffcc66}Вы сможете использовать эту упаковку во время следующего цикла");
        new slot = 999;
        if(!sscanf(params, "i", params[0])) // Указан слот
        {
            if(PlayerInfo[playerid][pInven][params[0]] != 249) return ErrorMessage(playerid, "{FF6347}У вас нет прокладок\n{ffcc66}Приобретите прокладки в любой аптеке");
            slot = params[0];
        }
        else
        {
            if(get_invent4(playerid, 249, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет прокладок\n{ffcc66}Приобретите прокладки в любой аптеке");
        }

        new lines[200];
		format(lines,sizeof(lines),"{B21515}Вы использовали прокладки!\
		                        \n{99ff66}Теперь эти месячные не будут вас беспокоить");
		ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
      	SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я использовала {B21515}прокладки");

        TakeInvent(playerid, 249, 1, 0, slot); // Забираем
        if(NoAnim[playerid] == 0) ApplyAnimation(playerid,"OTB","betslp_loop",4.0, false, true, true, false, false, SYNC_ALL);
        SetPlayerChatBubble(playerid,"использует прокладки",COLOR_PURPLE,30.0,5000);
        PlayerInfo[playerid][pMenstrProkl] = 1;
        SaveMenstruation(playerid);
        PlayerPlaySound(playerid,20802,0,0,0);
    }
	return true;
}

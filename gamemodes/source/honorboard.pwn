function Call_myHB(playerid)
{
	new rows, datad1[24], datad4, str[80],sctring[4096], quan;
	cache_get_row_count(rows);
	if(rows == 0) return ErrorMessage(playerid,"{ff6347}Доска Почета пуста");
	format(str,sizeof(str),"{cccccc}Доска почета\t \n"), strcat(sctring,str);
	for(new i = 0; i < rows; i++)
	{
	    cache_get_value_name(i, "playerName", datad1, 24);
	    cache_get_value_name_int(i, "org", datad4);
		List[quan][playerid] = datad4;
		quan ++;
		format(str, sizeof(str), "%s \t %s\n", frakeasyName[datad4],datad1), strcat(sctring,str);
	}
	ShowDialog(playerid,1388,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Доска Почета",sctring,"Выбрать","Выход");
	return 1;
}
CMD:showhb(playerid, const params[])
{
	if(sscanf(params, "i", params[0]))
	{
		stop_dialog(playerid);
		ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Сообщения","{cccccc}Загрузка личной Доски Почета...","*","");
		new string[120];
		mysql_format(pearsq, string,sizeof(string),"SELECT * FROM `honorboard` WHERE `playerid` = '%d' ORDER BY `org` LIMIT 30", PlayerInfo[playerid][pID]);
		mysql_tquery(pearsq, string, "Call_myHB", "d", playerid);
	}
	else
	{
		if(!IsOnline(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Его вообще нет..");
		if(IsARealNPC(params[0])) return ErrorMessage(playerid, "{FF6347}Это NPC");
		if(!ProxDetectorS(5.0, playerid,params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я слишком далеко..");
		stop_dialog(params[0]);
		ShowDialog(params[0],1996,DIALOG_STYLE_MSGBOX,"{ff9000}Сообщения","{cccccc}Загрузка личной Доски Почета...","*","");
		new string[120];
		mysql_format(pearsq, string,sizeof(string),"SELECT * FROM `honorboard` WHERE `playerid` = '%d' ORDER BY `org` LIMIT 30", PlayerInfo[playerid][pID]);
		mysql_tquery(pearsq, string, "Call_myHB", "d", params[0]);
	}
	return 1;
}

CMD:checkhb(playerid,const params[])
{
	if(PlayerInfo[playerid][pSoska] == 0) return 0;
	if(sscanf(params, "s[121]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Посмотреть ДП игрока [ /checkhb ID/NickName ]");
	if(strlen(params[0]) > 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Длинна никнейма не больше 20-ти символов");
	new giveplayerid;
	giveplayerid = ReturnUser(params[0], 1);
	new string[120];
	if(IsOnline(giveplayerid))
	{
		mysql_format(pearsq, string,sizeof(string),"SELECT * FROM `honorboard` WHERE `playerid` = '%d' ORDER BY `org` LIMIT 30", PlayerInfo[giveplayerid][pID]);
		mysql_tquery(pearsq, string, "Call_myHB", "d", playerid);
	}
	else
	{
		if(!CheckRP_Nickname(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
		mysql_format(pearsq, string,sizeof(string),"SELECT user_id FROM `pp_igroki` WHERE `Name` = '%e'", params[0]);
		mysql_tquery(pearsq, string, "Call_HonorBoardName", "ds", playerid, params[0]);
	}
	return 1;
}

function Call_HonorBoardName(playerid, const parama)
{
	new string[310];
	new rows, datad1;
	cache_get_row_count(rows);
	if(rows)
	{
		cache_get_value_name_int(0, "user_id", datad1);
		mysql_format(pearsq, string,sizeof(string),"SELECT * FROM `honorboard` WHERE `playerid` = '%d' ORDER BY `org` LIMIT 30", datad1);
		mysql_tquery(pearsq, string, "Call_myHB", "d", playerid);
	}
	else ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
	return 1;
}

CMD:honorboard(playerid)
{
    stop_dialog(playerid);
	new g = fraction(playerid);
	if(g == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");
	ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Сообщения","{cccccc}Загрузка фракционной Доски Почета...","*","");
	new string[120];
	mysql_format(pearsq, string,sizeof(string),"SELECT * FROM `honorboard` WHERE `org` = '%d' ORDER BY `Unix` LIMIT 70", g);
	mysql_tquery(pearsq, string, "Call_frakHB", "dd", playerid,g);
	return 1;
}
function Call_frakHB(playerid, g)
{
	new rows, datad1[24], datad4, str[80],sctring[4096], tyear, tmonth, tday, thour, tminute, tsecond;
	cache_get_row_count(rows);
	if(!rows) return ErrorMessage(playerid,"{ff6347}Доска Почета пуста");
	for(new i = 0; i < rows; i++)
	{
	    cache_get_value_name_int(i, "playerid", List[i][playerid]);
	    cache_get_value_name(i, "playerName", datad1, 24);
	    cache_get_value_name_int(i, "Unix", datad4);
		stamp2datetime(datad4, tyear, tmonth, tday, thour, tminute, tsecond, 3);

		format(str, sizeof(str), "%s \tЗанесен: %02d.%02d.%d \n", datad1, tday, tmonth, tyear), strcat(sctring,str);
	}
	ShowDialog(playerid,1389,DIALOG_STYLE_TABLIST,"{ff9000}Доска Почета",sctring,"Выбрать","Выход");
	return 1;
}

function is_a_hb(playerid, g, const tmp[])
{
    new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    info_hb(playerid, g);
	}
	return 1;
}
CMD:inhb(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 15) return ErrorMessage(playerid, "{FF6347}Вы не ответственный Администратор");
	new tmpName[24], g;
    if(sscanf(params, "s[24]i",tmpName,g)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Занести человека в Доску Почета [ NickName, ID орг.]");
	if(g < 1 || g > 24) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: ID организации не меньше 1 и не больше 24"), PlayerPlaySound(playerid,4203,0,0,0);
    new unix = gettime();
	new tmpTPlayerID = PlayerInfo[playerid][pID];
	new para = ReturnUser(tmpName, 1);

	new string_mysql[140];
    if(IsOnline(para))
    {
		if(IsARealNPC(para)) return ErrorMessage(playerid, "{FF6347}Это NPC");
		
		new tmpPlayerID = PlayerInfo[para][pID];
	  	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"SELECT * FROM `honorboard` WHERE `playerid`='%d' AND `org`='%d'", PlayerInfo[para][pID], g);
      	mysql_tquery(pearsq, string_mysql, "in_honorboard", "dddsdsdd", playerid, g, tmpPlayerID, PlayerInfo[para][pName], tmpTPlayerID, PlayerInfo[playerid][pName], unix, para);
    }
    else
    {
        if(!CheckRP_Nickname(tmpName)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
		mysql_format(pearsq, string_mysql,sizeof(string_mysql),"SELECT user_id FROM `pp_igroki` WHERE `Name` = '%e'", tmpName);
		mysql_tquery(pearsq, string_mysql, "get_inhonorboard", "ddsdsd", playerid, g,tmpName, tmpTPlayerID, PlayerInfo[playerid][pName], unix);
    }
	return 1;
}
stock info_hb(playerid, g)
{
    new datad1, datad2[24], datad3, datad4[24],datad5, datad6, string[256];
    cache_get_value_name_int(0, "playerid", datad1);
    cache_get_value_name(0, "playerName", datad2, 24);
    cache_get_value_name_int(0, "Tplayerid", datad3);
	cache_get_value_name(0, "TplayerName", datad4, 24);
    cache_get_value_name_int(0, "org", datad5);
    cache_get_value_name_int(0, "Unix", datad6);
    new tyear, tmonth, tday, thour, tminute, tsecond;
	stamp2datetime(datad6, tyear, tmonth, tday, thour, tminute, tsecond, 3);
	format(string,sizeof(string),"{FF6347}В Доске почета %s\nПод именем: %s [ %d ]\nЗанес: %s [ %d ] |  [%02d.%02d.%d %02d:%02d]",frakeasyName[g], datad2, datad1, datad4,datad3, tday, tmonth, tyear, thour, tminute);
	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ff0000}*",string,"*","");
	return 1;
}
function get_inhonorboard(playerid, g, const tmpName[], tmpTPlayerID,const tmpTName[], unix)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new plaid;
	    cache_get_value_name_int(0, "user_id", plaid);
		new string_mysql[120];
	    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"SELECT * FROM `honorboard` WHERE `playerid`='%d' AND `org`='%d'", plaid, g);
      	mysql_tquery(pearsq, string_mysql, "in_honorboard", "dddsdsd", playerid, g, plaid, tmpName, tmpTPlayerID, tmpTName, unix);
	}
	else ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
	return 1;
}
function in_honorboard(playerid, g, plaid, const tmpName[], tmpTPlayerID,const tmpTName[], unix, targetid)
{
    new rows,query[512];
	cache_get_row_count(rows);
	if(rows)
	{
		if(targetid >= 0) info_hb(targetid, g);
	}
	else
	{
		if(targetid >= 0 && OnlineInfo[targetid][oLogged] == 1)
		{
			format(query, sizeof(query),"{99ff66}[ %s ]: поместил вас в Доску Почета %s\n",tmpTName, frakName[g]);
			SendClientMessage(targetid, COLOR_GREY, query);
			if(playerid >= 0) format(query, sizeof(query),"\n{99ff66}%s поместил вас в Доску Почета %s\n", tmpTName, frakName[g]), ShowDialog(targetid,1012,DIALOG_STYLE_MSGBOX,"{ff0000}*", query,"*","");
			PlayerPlaySound(targetid, 31202, 0,0,0);
			if(PlayerInfo[targetid][pDrawVisible][2] == false) PlayerTextDrawShow(targetid, PlayerSiteDraw[2][targetid]);
		}
	    if(playerid >= 0)
	    {
		    PlayerPlaySound(playerid, 6401, 0,0,0);
		    SendClientMessage(playerid, COLOR_GREY,"{ffcc66}Вы занесли {99ff66}%s {ffcc66}в Доску Почета %s",tmpName,frakName[g]);
		    format(query, sizeof(query),"\n{cccccc}Вы занесли %s в Доску почета %s",tmpName,frakName[g]);
			ShowDialog(playerid,1012,DIALOG_STYLE_MSGBOX, "{ff0000}*", query, "Ок", "");
		}
        mysql_format(pearsq, query, sizeof(query), "INSERT INTO `honorboard` (`org`, `playerid`, `playerName`, `Tplayerid`, `TplayerName`, `Unix`) VALUES ( '%d', '%d', '%e', '%d', '%e', '%d' )",
    	g, plaid, tmpName, tmpTPlayerID, tmpTName, unix);
    	mysql_tquery(pearsq, query, "", "");
    	
    	format(query, sizeof(query), "Вы занесены в Доску почета %s", frakeasyName[g]);
		notify(tmpTPlayerID, tmpTName, plaid, tmpName, query);
		
		format(query, sizeof(query), "Занес в ДП %s", frakeasyName[g]), OrgLog(g, "inhb", tmpTPlayerID, tmpTName,PlayerInfo[playerid][pPlaIP], plaid, tmpName,PlayerInfo[plaid][pPlaIP],0, query);
	}
	return 1;
}
CMD:outhb(playerid, const params[])
{
	new tmpName[24], g;
    if(sscanf(params, "s[24]i",tmpName,g)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вынести человека в Доску Почета [ NickName, ID орг.]");
	if(g < 1 || g > 24) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: ID организации не меньше 1 и не больше 24"), PlayerPlaySound(playerid,4203,0,0,0);
    new unix = gettime();
	new tmpTPlayerID = PlayerInfo[playerid][pID];
	new para = ReturnUser(tmpName, 1);

	new string_mysql[140];
    if(IsOnline(para))
    {
		new tmpPlayerID = PlayerInfo[para][pID];
	  	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"SELECT * FROM `honorboard` WHERE `playerid`='%d' AND `org`='%d'", tmpPlayerID, g);
      	mysql_tquery(pearsq, string_mysql, "out_honorboard", "dddddd",  playerid, g, tmpPlayerID, tmpTPlayerID, unix,para);
		printf("%d %d %d %d %d %d",playerid, g, tmpPlayerID, tmpTPlayerID, unix,para);
    }
    else
    {
        if(!CheckRP_Nickname(tmpName)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
		mysql_format(pearsq, string_mysql,sizeof(string_mysql),"SELECT user_id FROM `pp_igroki` WHERE `Name` = '%e'", tmpName);
		mysql_tquery(pearsq, string_mysql, "get_outhonorboard", "dddd", playerid, g, tmpTPlayerID, unix);
    }
	return 1;
}
function get_outhonorboard(playerid, g, tmpTPlayerID, unix)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new plaid;
	    cache_get_value_name_int(0, "user_id", plaid);
		new string_mysql[120];
	    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"SELECT * FROM `honorboard` WHERE `playerid`='%d' AND `org`='%d'", plaid, g);
      	mysql_tquery(pearsq, string_mysql, "out_honorboard", "dddddd",  playerid, g, plaid, tmpTPlayerID, unix,-1);
	}
	else ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
	return 1;
}
function out_honorboard(playerid, g, plaid, tmpTPlayerID, unix,target)
{
    new rows, string[160], NickName[24];
	cache_get_row_count(rows);
	if(rows)
	{
		cache_get_value_name(0, "playerName", NickName, 24);
		if(target != -1)
		{
			if(OnlineInfo[target][oLogged] == 0) return 0;
			format(string, sizeof(string),"{FF6347}[ %s ]: {cccccc}вынес вас из доски почета %s\n",rpplayername(playerid), frakName[g]);
			SendClientMessage(target, COLOR_GREY, string);
			format(string, sizeof(string),"{FF6347}%s {cccccc}вынес вас из доски почета %s", rpplayername(target), frakName[g]);
			ShowDialog(target,1012,DIALOG_STYLE_MSGBOX,"{ff0000}*", string,"*","");
			if(PlayerInfo[target][pDrawVisible][2] == false) PlayerTextDrawShow(target, PlayerSiteDraw[2][target]);
		}
		PlayerPlaySound(playerid, 6401, 0,0,0);
	    SendClientMessage(playerid, COLOR_GREY,"{ffcc66}Вы вынесли {FF6347}%s {ffcc66}из доски почета %s",NickName,frakName[g]);
	    format(string, sizeof(string),"\n{cccccc}Вы вынесли %s из доски почета %s",NickName,frakName[g]);
		ShowDialog(playerid,1012,DIALOG_STYLE_MSGBOX, "{ff0000}*", string, "Ок", "");
	    mysql_format(pearsq, string,sizeof(string),"DELETE FROM `honorboard` WHERE `playerid`='%d' AND `org`='%d'", plaid, g);
		query_empty(pearsq, string);
	    
	    format(string, sizeof(string), "Вас вынесли из доски почета %s", frakeasyName[g]);
		notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], plaid, NickName, string);
	
		format(string, sizeof(string), "вынес с ДП %s", frakeasyName[g]);
		OrgLog(g, "outhb", tmpTPlayerID, PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], plaid, NickName,PlayerInfo[plaid][pPlaIP],0, string);
	}
	else format(string,sizeof(string),"{FF6347}Выбранный человек не находится в доске почета %s",frakeasyName[g]), ErrorMessage(playerid, string);
	return 1;
}

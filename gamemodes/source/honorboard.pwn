function Call_myHB(playerid)
{
	new rows, datad1[24], datad4, str[64],sctring[6400], quan;
	cache_get_row_count(rows);
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
CMD:myhonorboard(playerid)
{
    Login[2][playerid] = 0, stop_dialog(playerid);
	ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Сообщения","{cccccc}Загрузка личной Доски Почета...","*","");
	new string[101];
	format(string,sizeof(string),"SELECT * FROM `honorboard` WHERE `playerid` = '%d' ORDER BY `org` LIMIT 30", PlayerInfo[playerid][pID]);
	mysql_tquery(pearsq, string, "Call_myHB", "d", playerid);
	return 1;
}
CMD:honorboard(playerid)
{
    Login[2][playerid] = 0, stop_dialog(playerid);
	new g = fraction(playerid);
	if(g == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");
	ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Сообщения","{cccccc}Загрузка фракционной Доски Почета...","*","");
	new string[101];
	format(string,sizeof(string),"SELECT * FROM `honorboard` WHERE `org` = '%d' ORDER BY `Unix` LIMIT 70", g);
	mysql_tquery(pearsq, string, "Call_frakHB", "dd", playerid,g);
	return 1;
}
function Call_frakHB(playerid, g)
{
	new rows, datad1[24], datad4, str[64],sctring[6400], tyear, tmonth, tday, thour, tminute, tsecond;
	cache_get_row_count(rows);
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

	new string_mysql[100];
    if(IsPlayerConnected(para))
    {
		new tmpPlayerID = PlayerInfo[para][pID];
	  	format(string_mysql,sizeof(string_mysql),"SELECT * FROM `honorboard` WHERE `playerid`='%d' AND `org`='%d'", PlayerInfo[para][pID], g);
      	mysql_tquery(pearsq, string_mysql, "in_honorboard", "dddsdsd", playerid, g, tmpPlayerID, PlayerInfo[para][pName], tmpTPlayerID, PlayerInfo[playerid][pName], unix);
    }
    else
    {
        if(!CheckRP_Nickname(tmpName)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
		format(string_mysql,sizeof(string_mysql),"SELECT * FROM `pp_igroki` WHERE `Name` = '%s'", tmpName);
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
		new string_mysql[100];
	    format(string_mysql,sizeof(string_mysql),"SELECT * FROM `honorboard` WHERE `playerid`='%d' AND `org`='%d'", plaid, g);
      	mysql_tquery(pearsq, string_mysql, "in_honorboard", "dddsdsd", playerid, g, plaid, tmpName, tmpTPlayerID, tmpTName, unix);
	}
	else ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
	return 1;
}
function in_honorboard(playerid, g, plaid, const tmpName[], tmpTPlayerID,const tmpTName[], unix)
{
    new rows,query[512];
	cache_get_row_count(rows);
	if(rows)
	{
		if(plaid >= 0) info_hb(plaid, g);
	}
	else
	{
		if(OnlineInfo[plaid][oLogged] == 1)
		{
			format(query, sizeof(query),"{FF6347}[ %s ]: поместил вас в Доску Почета %s\n",tmpTName, frakName[g]);
			SendClientMessage(plaid, COLOR_GREY, query);
			if(playerid >= 0) format(query, sizeof(query),"\n{FF6347}%s поместил вас в Доску Почета %s\n", tmpTName, frakName[g]), ShowDialog(plaid,1012,DIALOG_STYLE_MSGBOX,"{ff0000}*", query,"*","");
			PlayerPlaySound(plaid, 31202, 0,0,0);
			if(PlayerInfo[plaid][pDrawVisible][2] == false) PlayerTextDrawShow(plaid, PlayerSiteDraw[2][plaid]);
		}
	    if(playerid >= 0)
	    {
		    PlayerPlaySound(playerid, 6401, 0,0,0);
		    SendClientMessagef(playerid, COLOR_GREY,"{ffcc66}Вы занесли {FF6347}%s {ffcc66}в Доску Почета %s",tmpName,frakName[g]);
		    format(query, sizeof(query),"\n{cccccc}Вы занесли %s в Доску почета %s",tmpName,frakName[g]);
			ShowDialog(playerid,1012,DIALOG_STYLE_MSGBOX, "{ff0000}*", query, "Ок", "");
		}
        format(query, sizeof(query), "INSERT INTO `honorboard` (`org`, `playerid`, `playerName`, `Tplayerid`, `TplayerName`, `Unix`) VALUES ( '%d', '%d', '%s', '%d', '%s', '%d' )",
    	g, plaid, tmpName, tmpTPlayerID, tmpTName, unix);
    	mysql_tquery(pearsq, query, "", "");
    	
    	format(query, sizeof(query), "Вы занесены в Доску почета %s", frakeasyName[g]);
		notify(tmpTPlayerID, tmpTName, plaid, tmpName, query);
		
		format(query, sizeof(query), "Занес в ДП %s", frakeasyName[g]), OrgLog(g, "inhb", tmpTPlayerID, tmpTName,PlayerInfo[tmpTPlayerID][pPlaIP], plaid, tmpName,PlayerInfo[plaid][pPlaIP],0, query);
	}
	return 1;
}
CMD:outhb(playerid, const params[])
{
	new tmpName[24], g;
    if(sscanf(params, "s[24]i",tmpName,g)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вынести человека в Доску Почета [ NickName, ID орг.]");
	if(g < 1 || g > 24) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: ID организации не меньше 1 и не больше 24"), PlayerPlaySound(playerid,4203,0,0,0);
    new unix = gettime();
	new tmpTPlayerID = PlayerInfo[playerid][pID], tmpTName = PlayerInfo[playerid][pName];
	new para = ReturnUser(tmpName, 1);

	new string_mysql[120];
    if(IsPlayerConnected(para))
    {
		new tmpPlayerID = PlayerInfo[para][pID];
	  	format(string_mysql,sizeof(string_mysql),"SELECT * FROM `honorboard` WHERE `playerid`='%d' AND `org`='%d'", PlayerInfo[para][pID], g);
      	mysql_tquery(pearsq, string_mysql, "out_honorboard", "dddsdsd", playerid, g, tmpPlayerID, tmpName, tmpTPlayerID, tmpTName, unix);
    }
    else
    {
        if(!CheckRP_Nickname(tmpName)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
		format(string_mysql,sizeof(string_mysql),"SELECT * FROM `pp_igroki` WHERE `Name` = '%s'", tmpName);
		mysql_tquery(pearsq, string_mysql, "get_outhonorboard", "ddsdsd", playerid, g, tmpName, tmpTPlayerID, tmpTName, unix);
    }
	return 1;
}
function get_outhonorboard(playerid, g, tmpPlayerID, const tmpName[], tmpTPlayerID,const tmpTName[], unix)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new plaid;
	    cache_get_value_name_int(0, "user_id", plaid);
		new string_mysql[120];
	    format(string_mysql,sizeof(string_mysql),"SELECT * FROM `honorboard` WHERE `playerid`='%d' AND `org`='%d'", plaid, g);
      	mysql_tquery(pearsq, string_mysql, "out_honorboard", "dsdd", playerid, tmpName, plaid, g);
	}
	else ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
	return 1;
}
function out_honorboard(playerid, g, plaid, const tmpName[], tmpTPlayerID,const tmpTName[], unix)
{
    new rows, string[160];
	cache_get_row_count(rows);
	if(rows)
	{
		if(OnlineInfo[plaid][oLogged] == 1)
		{
			format(string, sizeof(string),"{99ff66}[ %s ]: {cccccc}вынес вас из доски почета %s\n",PlayerInfo[playerid][pName], frakName[g]);
			SendClientMessage(plaid, COLOR_GREY, string);
			format(string, sizeof(string),"{99ff66}%s {cccccc}вынес вас из доски почета %s", PlayerInfo[playerid][pName], frakName[g]);
			ShowDialog(plaid,1012,DIALOG_STYLE_MSGBOX,"{ff0000}*", string,"*","");
			if(PlayerInfo[plaid][pDrawVisible][2] == false) PlayerTextDrawShow(plaid, PlayerSiteDraw[2][plaid]);
		}
		PlayerPlaySound(playerid, 6401, 0,0,0);
	    SendClientMessagef(playerid, COLOR_GREY,"{ffcc66}Вы вынесли {99ff66}%s {ffcc66}из доски почета",tmpName,frakName[g]);
	    format(string, sizeof(string),"\n{cccccc}Вы вынесли %s из доски почета %s",tmpName,frakName[g]);
		ShowDialog(playerid,1012,DIALOG_STYLE_MSGBOX, "{ff0000}*", string, "Ок", "");
	    format(string,sizeof(string),"DELETE FROM `honorboard` WHERE `playerid`='%d' AND `org`='%d'", plaid, g);
		query_empty(pearsq, string);
	    
	    format(string, sizeof(string), "Вас вынесли из доски почета %s", frakeasyName[g]);
		notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], plaid, tmpName, string);
	
		format(string, sizeof(string), "вынес с ДП %s", frakeasyName[g]);
		OrgLog(g, "outhb", tmpTPlayerID, tmpTName,PlayerInfo[tmpTPlayerID][pPlaIP], plaid, tmpName,PlayerInfo[plaid][pPlaIP],0, string);
	}
	else format(string,sizeof(string),"{FF6347}%s не находится в доске почета %s",tmpName,frakeasyName[g]), ErrorMessage(playerid, string);
	return 1;
}

function Call_HB(playerid, g)
{
	new rows, datad1[24], datad4, str[64],sctring[6400], tyear, tmonth, tday, thour, tminute, tsecond, quan;
	cache_get_row_count(rows);
	format(str,sizeof(str),"{cccccc}Доска почета\t \n"), strcat(sctring,str);
	for(new i = 0; i < rows; i++)
	{
	    cache_get_value_name_int(i, "playerid", List[quan][playerid]);
	    quan ++;
	    cache_get_value_name(i, "player", datad1, 24);
	    cache_get_value_name_int(i, "term", datad4);
		stamp2datetime(datad4, tyear, tmonth, tday, thour, tminute, tsecond, 3);

		format(str, sizeof(str), "%s \t До %02d.%02d.%d \n", datad1, tday, tmonth, tyear), strcat(sctring,str);
	}
	ShowDialog(playerid,1210,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Черный Список",sctring,"Выбрать","Выход");
	return 1;
}
CMD:blacklist(playerid)
{
    Login[2][playerid] = 0, stop_dialog(playerid);
	if(BL[playerid] > 0) g = BL[playerid];
    if(g == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");
    if(g == 28)
    {
    	if(PlayerInfo[playerid][pRank] < OrganInfo[3][gAcc][23]) return format(store,sizeof(store),"{FF6347}Добавлять в черный список можно с %d ранга",OrganInfo[3][gAcc][23]), ErrorMessage(playerid, store);
	}
	else if(g == 34)
	{
	    if(PlayerInfo[playerid][pRank] < OrganInfo[gw][gAcc][41] && PlayerInfo[playerid][pSoska] == 0) return format(store, sizeof(store), "{FF6347}У вас нет доступа к внесению в чёрный список О.Ц. {FF6347}[ %d+ Ранг ]", OrganInfo[gw][gAcc][41]), ErrorMessage(playerid, store);
	}
	else if(g != 28 && g != 30)
	{
    	if(PlayerInfo[playerid][pRank] < OrganInfo[g][gAcc][23]) return format(store,sizeof(store),"{FF6347}Добавлять в черный список можно с %d ранга",OrganInfo[g][gAcc][23]), ErrorMessage(playerid, store);
	}
	DP[0][playerid] = g;
	ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Сообщения","{cccccc}Загрузка черного списка...","*","");
	new string[101];
	format(string,sizeof(string),"SELECT * FROM `honorboard` WHERE `org` = '%d' AND `term` > '%d' ORDER BY `term` LIMIT 30", g, gettime());
	mysql_tquery(pearsq, string, "Call_HB", "d", playerid);
	return 1;
}
CMD:inbl(playerid, const params[])
{
    new g = fraction(playerid);
    new gw = g;
	if(BL[playerid] > 0) g = BL[playerid];
    if(g == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");
    if(g == 28)
    {
    	if(PlayerInfo[playerid][pRank] < OrganInfo[3][gAcc][23]) return format(store,sizeof(store),"{FF6347}Добавлять в черный список можно с %d ранга",OrganInfo[3][gAcc][23]), ErrorMessage(playerid, store);
	}
	else if(g == 34)
	{
	    if(PlayerInfo[playerid][pRank] < OrganInfo[gw][gAcc][41] && PlayerInfo[playerid][pSoska] == 0) return format(store, sizeof(store), "{FF6347}У вас нет доступа к внесению в чёрный список О.Ц. {FF6347}[ %d+ Ранг ]", OrganInfo[gw][gAcc][41]), ErrorMessage(playerid, store);
	}
	else if(g != 28 && g != 30)
	{
    	if(PlayerInfo[playerid][pRank] < OrganInfo[g][gAcc][23]) return format(store,sizeof(store),"{FF6347}Добавлять в черный список можно с %d ранга",OrganInfo[g][gAcc][23]), ErrorMessage(playerid, store);
	}
    new tmp[24], term, bailed, reason[64];
    if(sscanf(params, "s[24]iis[64]", tmp, term, bailed, reason)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Занести в черный список [ /inbl ID Срок Залог Причина ]");
    if(term < 1 || term > 1000) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Срок не меньше 1 дня и не больше 1000 дней"), PlayerPlaySound(playerid,4203,0,0,0);
    if(bailed < 0 || bailed > 100000000) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Залог не меньше 0 и не больше 100кк [ 0 - досрочный выход невозможен ]"), PlayerPlaySound(playerid,4203,0,0,0);
    new para = ReturnUser(tmp, 1);
    if(IsPlayerConnected(para))
    {
	  	format(store,sizeof(store),"SELECT * FROM `blacklist` WHERE `playerid`='%d' AND `org`='%d'", PlayerInfo[para][pID], g);
      	mysql_tquery(pearsq, store, "in_blacklist", "dsdddsdd", playerid, PlayerInfo[para][pName], para, term, bailed, reason, g, 1);
    }
    else
    {
        if(!CheckRP_Nickname(tmp)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
        format(store,sizeof(store),"SELECT * FROM `pp_igroki` WHERE `Name` = '%s'", tmp);
		mysql_tquery(pearsq, store, "get_inblacklist", "dsdddsdd", playerid, tmp, para, term, bailed, reason, g, 0);
    }
	return 1;
}
stock info_bl(playerid, g, const tmp[], stat)
{
    new datad1[24], datad2[24], datad3[24], datad4, datad5, string[256];
    cache_get_value_name(0, "player", datad1, 24);
    cache_get_value_name(0, "reason", datad2, 24);
    cache_get_value_name(0, "sender", datad3, 24);
    cache_get_value_name_int(0, "term", datad4);
    cache_get_value_name_int(0, "bailed", datad5);
    new tyear, tmonth, tday, thour, tminute, tsecond;
	stamp2datetime(datad4, tyear, tmonth, tday, thour, tminute, tsecond, 3);
	if(stat == 0) format(string,sizeof(string),"{FF6347}%s в черном списке %s под именем: %s\n\nЗанес: %s | Залог: %d$\nПричина: %s\n{cccccc}До: %02d.%02d.%d %02d:%02d", tmp, frakeasyName[g], datad1, datad3, datad5 ,datad2, tday, tmonth, tyear, thour, tminute), ErrorMessage(playerid, string);
	else
	{
		format(string,sizeof(string),"{FF6347}%s | Черный список %s\n\nЗанес: %s | Залог: %d$\nПричина: %s\n{cccccc}До: %02d.%02d.%d %02d:%02d", datad1, frakeasyName[g], datad3, datad5 ,datad2, tday, tmonth, tyear, thour, tminute);
		ShowDialog(playerid,1213,DIALOG_STYLE_MSGBOX,"{ffcc00}*",string,"Ок","");
	}
	return 1;
}
function get_inblacklist(playerid, const tmp[], para, term, bailed, const reason[], g, stat)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new plaid;
	    cache_get_value_name_int(0, "id", plaid);
	    format(store,sizeof(store),"SELECT * FROM `blacklist` WHERE `playerid`='%d' AND `org`='%d'", plaid, g);
      	mysql_tquery(pearsq, store, "in_blacklist", "dsdddsdd", playerid, tmp, plaid, term, bailed, reason, g, stat);
	}
	else format(store,sizeof(store),"{FF6347}Такого аккаунта не существует [ %s ]", tmp), ErrorMessage(playerid, store);
	return 1;
}
function in_blacklist(playerid, const tmp[], para, term, bailed, const reason[], g, stat)
{
    new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		if(playerid >= 0) info_bl(playerid, g, tmp, 0);
	}
	else
	{
	    new plaid, plaip[24], unix = gettime(), query[512], name[24], admid, admip[24];
	    if(playerid >= 0) format(name, sizeof(name),"%s",PlayerInfo[playerid][pName]), admid = PlayerInfo[playerid][pID], format(admip, sizeof(admip),"%s", PlayerInfo[playerid][pPlaIP]);
	    else if(playerid == -1) format(name, sizeof(name),"Сервер"), admid = 0, format(admip, sizeof(admip)," ");
	    
	    if(stat == 1)
		{
			plaid = PlayerInfo[para][pID], format(plaip, 24, PlayerInfo[para][pPlaIP]);
			if(OnlineInfo[para][oLogged] == 1)
			{
				format(query, sizeof(query),"{FF6347}[ %s ]: поместил вас в черный список %s {FF6347}на %d дней | {ffcc66}Причина: %s\n",name, frakName[g], term, reason);
   				SendClientMessage(para, COLOR_GREY, query);
   				if(playerid >= 0) format(query, sizeof(query),"\n{FF6347}%s поместил вас в черный список %s {FF6347}на %d дней\n\n{ffcc66}Причина: %s\n", name, frakName[g], term, reason), ShowDialog(para,1012,DIALOG_STYLE_MSGBOX,"{ff0000}*", query,"*","");
		    	PlayerPlaySound(para, 31202, 0,0,0);
		    	if(PlayerInfo[para][pDrawVisible][2] == false) PlayerTextDrawShow(para, PlayerSiteDraw[2][para]);
			}
		}
	    else plaid = para, format(plaip, 24, " ");
	    if(playerid >= 0)
	    {
		    PlayerPlaySound(playerid, 6401, 0,0,0);
		    SendClientMessagef(playerid, COLOR_GREY,"{ffcc66}Вы занесли {FF6347}%s {ffcc66}в черный список %s {ffcc66}на %d дней | {FF6347}Причина: %s",tmp,frakName[g],term,reason);
		    format(query, sizeof(query),"\n{cccccc}Вы занесли %s в черный список %s {cccccc}на %d дней\n{FF6347}Залог: %d$\nПричина: %s",tmp,frakName[g],term,bailed,reason);
			ShowDialog(playerid,1012,DIALOG_STYLE_MSGBOX, "{ff0000}*", query, "Ок", "");
		}
        format(query, sizeof(query), "INSERT INTO `blacklist` (`org`, `playerid`, `player`, `playerip`, `unix`, `term`, `reason`, `bailed`, `senderid`, `sender`, `senderip`) VALUES ( '%d', '%d', '%s', '%s', '%d', '%d', '%s', '%d', '%d', '%s', '%s' )",
    	g, plaid, tmp, plaip, unix, unix+(86400*term), reason, bailed, admid, name, admip);
    	mysql_tquery(pearsq, query, "", "");
    	
    	format(query, sizeof(query), "Вы занесены в чёрный список %s на %d дней. Причина: %s", frakeasyName[g], term, reason);
		notify(admid, name, plaid, tmp, query);
		
		if(g == 28) format(query, sizeof(query), "ЧС %s | Причина: %s", frakeasyName[g], reason), OrgLog(3, "inbl", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], plaid, tmp, plaip, term, query);
		else if(g == 30) format(query, sizeof(query), "ЧС %s | Причина: %s", frakeasyName[g], reason), AdminLog("inbl", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], plaid, tmp, plaip, term, query);
		else format(query, sizeof(query), "ЧС %s | Причина: %s", frakeasyName[g], reason), OrgLog(g, "inbl", admid, name, admip, plaid, tmp, plaip, term, query);
	}
	return 1;
}
CMD:outbl(playerid, const params[])
{
    new g = fraction(playerid);
    new gw = g;
	if(BL[playerid] > 0) g = BL[playerid];
    if(g == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");
	if(g == 28)
    {
    	if(PlayerInfo[playerid][pRank] < OrganInfo[3][gAcc][24]) return format(store,sizeof(store),"{FF6347}Выносить из черного списка можно с %d ранга",OrganInfo[3][gAcc][24]), ErrorMessage(playerid, store);
	}
	else if(g == 34)
	{
	    if(PlayerInfo[playerid][pRank] < OrganInfo[gw][gAcc][42] && PlayerInfo[playerid][pSoska] == 0) return format(store, sizeof(store), "{FF6347}У вас нет доступа к исключению из чёрного списка О.Ц. {FF6347}[ %d+ Ранг ]", OrganInfo[gw][gAcc][42]), ErrorMessage(playerid, store);
	}
	else if(g != 28 && g != 30)
	{
    	if(PlayerInfo[playerid][pRank] < OrganInfo[g][gAcc][24]) return format(store,sizeof(store),"{FF6347}Выносить из черного списка можно с %d ранга",OrganInfo[g][gAcc][24]), ErrorMessage(playerid, store);
	}
    new tmp[24];
    if(sscanf(params, "s[24]", tmp)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вынести из чёрного списка [ /outbl ID ]");
    new para = ReturnUser(tmp, 1);
    if(IsPlayerConnected(para))
    {
	  	format(store,sizeof(store),"SELECT * FROM `blacklist` WHERE `playerid`='%d' AND `org`='%d'", PlayerInfo[para][pID], g);
      	mysql_tquery(pearsq, store, "out_blacklist", "dsddd", playerid, PlayerInfo[para][pName], para, g, 1);
    }
    else
    {
        if(!CheckRP_Nickname(tmp)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
        format(store,sizeof(store),"SELECT * FROM `pp_igroki` WHERE `Name` = '%s'", tmp);
		mysql_tquery(pearsq, store, "get_outblacklist", "dsddd", playerid, tmp, para, g, 0);
    }
	return 1;
}
function get_outblacklist(playerid, const tmp[], para, g, stat)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new plaid;
	    cache_get_value_name_int(0, "id", plaid);
	    format(store,sizeof(store),"SELECT * FROM `blacklist` WHERE `playerid`='%d' AND `org`='%d'", plaid, g);
      	mysql_tquery(pearsq, store, "out_blacklist", "dsddd", playerid, tmp, plaid, g, stat);
	}
	else format(store,sizeof(store),"{FF6347}Такого аккаунта не существует [ %s ]", tmp), ErrorMessage(playerid, store);
	return 1;
}
function out_blacklist(playerid, const tmp[], para, g, stat)
{
    new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new plaid, plaip[24], query[256];
	    if(stat == 1)
		{
		    plaid = PlayerInfo[para][pID], format(plaip, 24, PlayerInfo[para][pPlaIP]);
		    if(OnlineInfo[para][oLogged] == 1)
			{
	    		if(OnlineInfo[para][oListenRadioPears] == 0) StopAudioStreamForPlayer(para), PlayAudioStreamForPlayer(para, "https://pears-project.ru/music/hallelujah.mp3");
	    		format(query, sizeof(query),"{99ff66}[ %s ]: {cccccc}вынес вас из черного списка %s\n",PlayerInfo[playerid][pName], frakName[g]);
   				SendClientMessage(para, COLOR_GREY, query);
   				format(query, sizeof(query),"\n{99ff66}%s {cccccc}вынес вас из черного списка %s\n", PlayerInfo[playerid][pName], frakName[g]);
		    	ShowDialog(para,1012,DIALOG_STYLE_MSGBOX,"{ff0000}*", query,"*","");
		    	if(PlayerInfo[para][pDrawVisible][2] == false) PlayerTextDrawShow(para, PlayerSiteDraw[2][para]);
 			}
		}
		else plaid = para, format(plaip, 24, " ");
		PlayerPlaySound(playerid, 6401, 0,0,0);
	    SendClientMessagef(playerid, COLOR_GREY,"{ffcc66}Вы вынесли {99ff66}%s {ffcc66}из черного списка",tmp,frakName[g]);
	    format(query, sizeof(query),"\n{cccccc}Вы вынесли %s из черного списка %s",tmp,frakName[g]);
		ShowDialog(playerid,1012,DIALOG_STYLE_MSGBOX, "{ff0000}*", query, "Ок", "");
	    format(query,sizeof(query),"DELETE FROM `blacklist` WHERE `playerid`='%d' AND `org`='%d'", plaid, g), query_empty(pearsq, query);
	    
	    format(query, sizeof(query), "Вас вынесли из черного списка %s", frakeasyName[g]);
		notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], plaid, tmp, query);
	
	    if(g == 28) format(query, sizeof(query), "Вынес из чс %s", frakeasyName[g]), OrgLog(3, "outbl", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], plaid, tmp, plaip, 0, query);
		else if(g == 30) format(query, sizeof(query), "Вынес из чс %s", frakeasyName[g]), AdminLog("outbl", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], plaid, tmp, plaip, 0, query);
		else format(query, sizeof(query), "Вынес из чс %s", frakeasyName[g]), OrgLog(g, "outbl", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], plaid, tmp, plaip, 0, query);
	}
	else format(store,sizeof(store),"{FF6347}%s не находится в черном списке %s",tmp,frakeasyName[g]), ErrorMessage(playerid, store);
	return 1;
}

CMD:top(playerid)
{
   	PlayerPlaySound(playerid,40405,0,0,0);
   	new str[24],sctring[240];
   	format(str,sizeof(str),"Достижения\n"), strcat(sctring,str);
   	format(str,sizeof(str),"Репутация\n"), strcat(sctring,str);
   	format(str,sizeof(str),"Уровень\n"), strcat(sctring,str);
  	format(str,sizeof(str),"Часы в Игре\n"), strcat(sctring,str);
	format(str,sizeof(str),"Убийств Маньяка\n"), strcat(sctring,str);
	format(str,sizeof(str),"Убийств Деревенских\n"), strcat(sctring,str);
	format(str,sizeof(str),"Убийств Зомби\n"), strcat(sctring,str);
	format(str,sizeof(str),"Убийства\n"), strcat(sctring,str);
	format(str,sizeof(str),"Смерти\n"), strcat(sctring,str);
	format(str,sizeof(str),"Ходок на Зону\n"), strcat(sctring,str);
	ShowDialog(playerid,51,DIALOG_STYLE_LIST,"{ff9000}Топ Игроков",sctring,"Выбор","Отмена");
	return 1;
}

forward Call_top(playerid, top);
public Call_top(playerid, top)
{
	new rows, str[64], sctring[1264], qwer[50];
	new atext[40],btext[40];
	switch(top)
 	{
 		case 0:{ atext = "Достижения"; btext = "Achievequan"; }
		case 1:{ atext = "Репутация"; btext = "Repaa"; }
		case 2:{ atext = "Уровень"; btext = "Level"; }
		case 3:{ atext = "Часы в Игре"; btext = "ConnectTime"; }
		case 4:{ atext = "Убийств Маньяка"; btext = "pKilledManiac"; }
		case 5:{ atext = "Убийств Деревенских"; btext = "pKilledVillage"; }
		case 6:{ atext = "Убийств Зомби"; btext = "pKilledZombie"; }
		case 7:{ atext = "Убийства"; btext = "Kills"; }
		case 8:{ atext = "Смерти"; btext = "Deaths"; }
		case 9:{ atext = "Ходок на Зону"; btext = "Hodka"; }
		default: { return 1; }
	}
	new year, month,day;
 	getdate(year, month, day);
	format(str,sizeof(str),"{FFFFFF}***   {0088ff}Дата   {FFFFFF}%d.%d.%d\n",day,month,year);
 	strcat(sctring,str);
	cache_get_row_count(rows);
	for(new i = 0; i < rows; i++)
	{
		new datad2[24],datad1;
		cache_get_value_name(i, "Name", datad2, 24);
		cache_get_value_name_int(i, btext, datad1);
		format(str,sizeof(str),"{cccccc}%d. %s {ff9000}[%d]\n", i+1, datad2, datad1);
		strcat(sctring,str);
    }
    format(qwer,sizeof(qwer),"{ff9000}Топ 20 {0088ff}[%s]",atext);
    ShowDialog(playerid,55,DIALOG_STYLE_MSGBOX,qwer,sctring,"Ок","");
	return true;
}

// Загружаем всю статистику
function Call_OnPlayerTopLoad(playerid, race_check)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);

        cache_get_value_name_int(0, "pKilledManiac", PlayerInfo[playerid][pStatistics][0]);
        cache_get_value_name_int(0, "pKilledVillage", PlayerInfo[playerid][pStatistics][1]);
        cache_get_value_name_int(0, "pKilledZombie", PlayerInfo[playerid][pStatistics][2]);
	}
	else // Если не нашли в таблице, тогда создаём
	{
		new string[100];
		mysql_format(pearsq, string, sizeof(string), "INSERT INTO `pp_igroki_top` SET `user_id`= '%d',`Name`= '%e'", PlayerInfo[playerid][pID],PlayerInfo[playerid][pName]);
		mysql_tquery(pearsq, string);
	}
	OnlineInfo[playerid][oTopLoad] = 1;
	return true;
}

// Сохраняем всю статистику
stock SavePlayerTop(playerid)
{
    new string[200];
    mysql_format(pearsq, string, sizeof(string),"UPDATE `pp_igroki_top` SET `Name`= '%e', `pKilledManiac` = '%d',`pKilledVillage` = '%d',`pKilledZombie` = '%d' WHERE `user_id` = '%d'", 
        PlayerInfo[playerid][pName],PlayerInfo[playerid][pStatistics][0],PlayerInfo[playerid][pStatistics][1],PlayerInfo[playerid][pStatistics][2], PlayerInfo[playerid][pID]);
	query_empty(pearsq, string);
    return true;
}

static Float:JobBusDepo[3][3] = { // Координаты работы в автобусном депо
	{992.3076,-1343.8839,13.6369}, // 0 ls
	{-1654.2604,1288.7062,7.2908}, // 1 sf
	{1065.5687,2306.5149,11.0953} // 2 lv
};

stock DynamicPickupJobBus()
{
    CreateDynamicPickup(1210, 1, JobBusDepo[0][0],JobBusDepo[0][1],JobBusDepo[0][2], 0, 0); // автобусное депо ls
    CreateDynamicPickup(1210, 1, JobBusDepo[1][0],JobBusDepo[1][1],JobBusDepo[1][2], 0, 0); // автобусное депо sf
    CreateDynamicPickup(1210, 1, JobBusDepo[2][0],JobBusDepo[2][1],JobBusDepo[2][2], 0, 0); // автобусное депо lv
    CreateDynamic3DTextLabel("{ff9000}Автобусное Депо\n{cccccc}[ ALT ]",-1,JobBusDepo[0][0],JobBusDepo[0][1],JobBusDepo[0][2],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    CreateDynamic3DTextLabel("{ff9000}Автобусное Депо\n{cccccc}[ ALT ]",-1,JobBusDepo[1][0],JobBusDepo[1][1],JobBusDepo[1][2],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    CreateDynamic3DTextLabel("{ff9000}Автобусное Депо\n{cccccc}[ ALT ]",-1,JobBusDepo[2][0],JobBusDepo[2][1],JobBusDepo[2][2],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	return 1;
}

stock IsAJobBusDepoPos(playerid)
{
    if((IsPlayerInRangeOfPoint(playerid,2.0,JobBusDepo[0][0],JobBusDepo[0][1],JobBusDepo[0][2]) || IsPlayerInRangeOfPoint(playerid,2.0,JobBusDepo[1][0],JobBusDepo[1][1],JobBusDepo[1][2])
	|| IsPlayerInRangeOfPoint(playerid,2.0,JobBusDepo[2][0],JobBusDepo[2][1],JobBusDepo[2][2])) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT
	&& GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) return 1;
	return 0;
}

stock jobbus(playerid)
{
	if(PlayerInfo[playerid][pPlacement] >= 1 && PlayerInfo[playerid][pPlacement] != 10) return StopJob(playerid);
	
	format(lines,sizeof(lines),""); // Очищаем Lines
	
	if(ServerInfo[53] == 9) format(line,sizeof(line),"{99ff66}Повышенная Оплата: Активна \t \n"), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}Стандартная Оплата \t \n"), strcat(lines,line);
	format(line,sizeof(line),"{0088ff}Как заработать? \t \n"), strcat(lines,line);
	if(GetPVarInt(playerid,"job_stat") != 12) format(line,sizeof(line),"{ff9000}Начать Работу \t \n"), strcat(lines,line);
	else if(GetPVarInt(playerid,"job_stat") == 12) format(line,sizeof(line),"{ff9000}Завершить Работу \t \n"), strcat(lines,line);
	format(line,sizeof(line),"{99ff66}Получить Зарплату \t {00cc00}[ %d$ ]\n", PlayerInfo[playerid][pSalary]), strcat(lines,line);
	ShowDialog(playerid,1190,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Автобусное Депо",lines,"Выбор","Отмена");
	return 1;
}

CMD:busstation(playerid)
{	
	if(PlayerInfo[playerid][pLeader] == 7 || PlayerInfo[playerid][pMember] == 7)
	{
	    PlayerPlaySound(playerid,40405,0,0,0);
		ShowDialog(playerid,1300,DIALOG_STYLE_INPUT,"{333333}Установка Остановки","{cccccc}Введите название для Остановки\n\n{333333}Примеры: Госпиталь, LSPD","Принять","Отмена");
	}
	else SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Я не сотрудник Правительства");
	return 1;
}

CMD:allbusstation(playerid)
{
	if(PlayerInfo[playerid][pLeader] == 7 || PlayerInfo[playerid][pMember] == 7)
	{
		if(bsrows < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: В данный момент не установлено ни одной Остановки"), cmd_overhear(playerid);
		new str[34],sctring[3400], listid = 0;
		for(new cam = 0; cam < MAX_BUSSTATION; cam++)
			{
			if(BusStationInfo[cam][bsActive] >= 1)
				{
					format(str,sizeof(str),"[%d] {cccccc}%s\n",listid+1,BusStationInfo[cam][bsName]), strcat(sctring,str);
					List[listid][playerid] = cam;
					listid ++;
				}
			}
		ShowDialog(playerid,1301,DIALOG_STYLE_LIST,"{cccccc}Остановки",sctring,"Выбрать","Отмена");
	}
	else SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Я не сотрудник Правительства"), stop_dialog(playerid);
	return 1;
}

function Call_getidBusStation(idx)
{
	new rows;
	cache_get_row_count(rows);
	if(rows) cache_get_value_name_int(0, "idbusstation", BusStationInfo[idx][idbusstation]);
	return 1;
}

stock InsertBusStation(idx)
{
	new f_str1[24], f_str2[34], string[144];
	mysql_escape_string(BusStationInfo[idx][bsPlayerName], f_str1, sizeof(f_str1));
	mysql_escape_string(BusStationInfo[idx][bsName], f_str2, sizeof(f_str2));
	format(big_query, sizeof(big_query), "INSERT INTO `pp_busstation` SET `bsActive`='%d',`bsVlad`='%d',`bsPlayerName`='%s',`bsName`='%s',`bsUnix`='%d',`bsCordX`='%f',`bsCordY`='%f',`bsCordZ`='%f',`bsCordRX`='%f',`bsCordRY`='%f',`bsCordRZ`='%f'",
	BusStationInfo[idx][bsActive],BusStationInfo[idx][bsVlad],f_str1,f_str2,BusStationInfo[idx][bsUnix],BusStationInfo[idx][bsCordX],BusStationInfo[idx][bsCordY],BusStationInfo[idx][bsCordZ],BusStationInfo[idx][bsCordRX],BusStationInfo[idx][bsCordRY],BusStationInfo[idx][bsCordRZ]);
	query_empty(pearsq, big_query);
	format(string,sizeof(string),"SELECT * FROM `pp_busstation` WHERE `bsUnix`='%d' AND `bsVlad`='%d'",BusStationInfo[idx][bsUnix],BusStationInfo[idx][bsVlad]);
	mysql_tquery(pearsq, string, "Call_getidBusStation", "d", idx);
	return 1;
}

stock UpdateBusStation(idx)
{
	new f_str[84];
	format(f_str, sizeof(f_str), "SELECT * FROM `pp_busstation` WHERE `idbusstation` = '%d'", BusStationInfo[idx][idbusstation]);
	mysql_tquery(pearsq, f_str, "Call_UpdateBusStation", "d", idx);
	return 1;
}
function Call_UpdateBusStation(idx)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new f_str1[24], f_str2[34];
		mysql_escape_string(BusStationInfo[idx][bsPlayerName], f_str1, sizeof(f_str1));
		mysql_escape_string(BusStationInfo[idx][bsName], f_str2, sizeof(f_str2));
		format(big_query, sizeof(big_query), "UPDATE `pp_busstation` SET `bsACtive`='%d',`bsVlad`='%d',`bsPlayerName`='%s',`bsName`='%s',`bsUnix`='%d',`bsCordX`='%f',`bsCordY`='%f',`bsCordZ`='%f',`bsCordRX`='%f',`bsCordRY`='%f',",
		BusStationInfo[idx][bsActive],BusStationInfo[idx][bsVlad],f_str1,f_str2,BusStationInfo[idx][bsUnix],BusStationInfo[idx][bsCordX],BusStationInfo[idx][bsCordY],BusStationInfo[idx][bsCordZ],BusStationInfo[idx][bsCordRX],BusStationInfo[idx][bsCordRY]);
		format(big_query, sizeof(big_query), "%s`bsCordRZ`='%f' WHERE `idbusstation` = '%d'", big_query,
		BusStationInfo[idx][bsCordRZ],BusStationInfo[idx][idbusstation]);
		query_empty(pearsq, big_query);
	}
	return 1;
}
function Call_DelBusStation(idx)
{
	new rows, f_str[84];
	cache_get_row_count(rows);
	if(rows) format(f_str,sizeof(f_str),"DELETE FROM `pp_busstation` WHERE `idbusstation` = '%d'",BusStationInfo[idx][idbusstation]), query_empty(pearsq, f_str);
	return 1;
}

stock busstationcreate(f)
{
	BusStationInfo[f][bsObject] = CreateDynamicObject(1257, BusStationInfo[f][bsCordX], BusStationInfo[f][bsCordY], BusStationInfo[f][bsCordZ], BusStationInfo[f][bsCordRX], BusStationInfo[f][bsCordRY], BusStationInfo[f][bsCordRZ]);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject], 0, 4552, "ammu_lan2", "sunsetammu2", 0x00000000);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject], 1, 18065, "ab_sfammumain", "shelf_glas", 0x00000000);
	BusStationInfo[f][bsObject] = CreateDynamicObject(18762, BusStationInfo[f][bsCordX]-5.3733, BusStationInfo[f][bsCordY]-1.0489, BusStationInfo[f][bsCordZ]-1.7713, 89.999992, BusStationInfo[f][bsCordRZ], BusStationInfo[f][bsCordRZ], 0, 0, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject], 0, 17079, "cuntwland", "ws_freeway4", 0x00000000);
	BusStationInfo[f][bsObject] = CreateDynamicObject(18762, BusStationInfo[f][bsCordX]+5.3628, BusStationInfo[f][bsCordY]-1.0489, BusStationInfo[f][bsCordZ]-1.7713, 89.999992, BusStationInfo[f][bsCordRZ]-3, BusStationInfo[f][bsCordRZ]-3, 0, 0, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject], 0, 17079, "cuntwland", "ws_freeway4", 0x00000000);
	BusStationInfo[f][bsObject] = CreateDynamicObject(19483, BusStationInfo[f][bsCordX]-4.117187, BusStationInfo[f][bsCordY]-0.664596, BusStationInfo[f][bsCordZ]-1.2330021, 0.000001, -90.000000, 179.900238, 0, 0, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(BusStationInfo[f][bsObject], 0, "Автобусная\nОстановка", 130, "Century Gothic", 95, 1, 0xFFFFFFFF, 0x00000000, 2);
	BusStationInfo[f][bsObject] = CreateDynamicObject(19482, BusStationInfo[f][bsCordX]-0.131, BusStationInfo[f][bsCordY]-0.0489, BusStationInfo[f][bsCordZ]-1.7713, 89.999992, BusStationInfo[f][bsCordRZ]-3, BusStationInfo[f][bsCordRZ]-3);
	SetDynamicObjectMaterialText(BusStationInfo[f][bsObject], 0, "с", 130, "Wingdings", 120, 1, 0xFFFFFFFF, 0x00000000, 1);
	BusStationInfo[f][bsObject] = CreateDynamicObject(19447, -2683.911865, -218.537658, 3.310067, 0.000000, 89.999984, -90.099983, 0, 0, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject], 0, 16640, "a51", "plaintarmac1", 0x00000000);
	BusStationInfo[f][bsObject] = CreateDynamicObject(19447, -2683.909423, -217.026748, 3.302062, 0.000000, 89.999984, -90.099983, 0, 0, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject], 0, 16640, "a51", "plaintarmac1", 0x00000000);
}
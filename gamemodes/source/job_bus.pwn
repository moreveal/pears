#define MAX_OBJECTS_BUSSTATION 17 // Количество объектов остановки

enum busstationInfo //  Переменные автобусных остановок
{
    idbusstation, // id в базе
	bsActive, // установлена ли остановка
    bsName[34], // название остановки
	bsObject, // ID динамик объекта
    Float:bsCordX, // координаты автобусной остановки
    Float:bsCordY, // координаты автобусной остановки
    Float:bsCordZ, // координаты автобусной остановки
	Float:bsCordRX, // координаты автобусной остановки
    Float:bsCordRY, // координаты автобусной остановки
    Float:bsCordRZ, // координаты автобусной остановки
    bsVlad[24], // Номер Аккаунта
	bsPlayerName[24], // имя игрока, который установил или редактировал остановку
    bsUnix, // unix дата и время или последнего редактирования остановки
	bsCity, // Город
};
new BusStationInfo[MAX_BUSSTATION][busstationInfo];

static Float:JobBusDepo[3][3] = { // Координаты работы в автобусном депо
	{992.3076,-1343.8839,13.6369}, // 0 ls
	{-2059.7725,-85.7708,35.4489}, // 1 sf
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
		ShowDialog(playerid,1300,DIALOG_STYLE_INPUT,"{444444}Установка Остановки","{cccccc}Введите название для Остановки\n\n{444444}Примеры: Госпиталь, LSPD","Принять","Отмена");
	}
	else SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Я не сотрудник Правительства");
	return 1;
}

CMD:allbusstation(playerid)
{
	if(PlayerInfo[playerid][pLeader] == 7 || PlayerInfo[playerid][pMember] == 7)
	{
		if(bsrows < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: В данный момент не установлено ни одной Остановки"), cmd_allbusstation(playerid);
		new str[34],sctring[3400], listid = 0;
		for(new bss = 0; bss < MAX_BUSSTATION; bss++)
			{
			if(BusStationInfo[bss][bsActive] >= 1)
				{
					format(str,sizeof(str),"[%d] {cccccc}%s\n",listid+1,BusStationInfo[bss][bsName]), strcat(sctring,str);
					List[listid][playerid] = bss;
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
	// Объект остановка
	BusStationInfo[f][bsObject] = CreateDynamicObject(1257, BusStationInfo[f][bsCordX], BusStationInfo[f][bsCordY], BusStationInfo[f][bsCordZ], BusStationInfo[f][bsCordRX], BusStationInfo[f][bsCordRY], BusStationInfo[f][bsCordRZ]);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject], 0, 4552, "ammu_lan2", "sunsetammu2", 0x00000000);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject], 1, 18065, "ab_sfammumain", "shelf_glas", 0x00000000);
	busstation_label[f] = CreateDynamic3DTextLabel(" ",-1,BusStationInfo[f][bsCordX], BusStationInfo[f][bsCordY], BusStationInfo[f][bsCordZ],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
	busstation_pickup[f] = CreateDynamicPickup(2485, 1, BusStationInfo[f][bsCordX], BusStationInfo[f][bsCordY], BusStationInfo[f][bsCordZ],0,0);
	UpdateBusStations(f);
}

CMD:scp(playerid)
{
	SaveCheckPoint(playerid,-1);
	return 1;
}

CMD:scpa(playerid)
{
	ShowCheckPointAll(playerid);
	return 1;
}

stock SaveCheckPoint(playerid, i)
{
	if(fraction(playerid) != 7) return ErrorMessage(playerid, "Я не сотрудник правительства");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x,y,z);
	new slot;
	if (i == -1)
	{
		if(PlayerInfo[playerid][pCheckPointCount] == -1) slot = 0;
		else slot = PlayerInfo[playerid][pCheckPointCount];
	}
	else
	{
		slot = i;
	}
	if(slot > 49) return ErrorMessage(playerid, "У меня сохраненно больше 50 точек маршрута");
	PlayerInfo[playerid][CheckPointX][slot] = x;
	PlayerInfo[playerid][CheckPointY][slot] = y;
	PlayerInfo[playerid][CheckPointZ][slot] = z;
	PlayerInfo[playerid][pCheckPointCount] += 1;
	return 1;
}

stock ShowCheckPointAll(playerid)
{
	format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"№ \tX\tY\tZ"), strcat(lines,line);
    new quan;
    for(new i = 0; i < 50; i++) 
    {
		if(PlayerInfo[playerid][CheckPointX][i] != 0.0 || PlayerInfo[playerid][CheckPointY][i] != 0.0)
		{
			format(line,sizeof(line),"\n%d. \t%f\t%f\t%f", quan+1,PlayerInfo[playerid][CheckPointX][i],PlayerInfo[playerid][CheckPointY][i],PlayerInfo[playerid][CheckPointZ][i]), strcat(lines,line);
			quan++;
		}
    }
    if(quan == 0) return ErrorMessage(playerid,"{FF6347}Вы не сохранили не один чекпоинт");
    ShowDialog(playerid,1444,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список чекпоинтов",lines,"Выбрать","Выход");
	return 1;
}
stock ShowPlayerSettingCheckPoint(playerid,i)
{
	if(PlayerInfo[playerid][pCheckPointCount] == -1) return 0;
	format(lines,sizeof(lines),""); // Очищаем Lines
	format(line,sizeof(line),"\tX:%f\tY:%f\tZ:%f",PlayerInfo[playerid][CheckPointX][i],PlayerInfo[playerid][CheckPointY][i],PlayerInfo[playerid][CheckPointZ][i]), strcat(lines,line);
	format(line,sizeof(line),"\nПерезаписать чекпоинт[На текущую позицию]\t\t\t"), strcat(lines,line);
	format(line,sizeof(line),"\nПоказать позицию чекпоинта\t\t\t"), strcat(lines,line);
	format(line,sizeof(line),"\nУдалить чекпоинт\t\t\t"), strcat(lines,line);
	DP[0][playerid] = i;
	ShowDialog(playerid,1445,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Настройка чекпоинта",lines,"Выбрать","Выход");
	return 1;
}
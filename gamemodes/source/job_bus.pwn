#define MAX_OBJECTS_BUSSTATION 17 // Количество объектов остановки
#define MAX_ROUT 50 // Количество маршрутов

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

enum routInfo //  Переменные автобусных остановок
{
    brId, // id в базе
	brStatus, // активный ли Маршрут
    brType, // Тип маршрута(0 правительство, 1 стриты)
	brNameCreator[24], // Тип маршрута(0 правительство, 1 стриты)
	brNameEditor[24], // Тип маршрута(0 правительство, 1 стриты)
	brNameRout[40], // Тип маршрута(0 правительство, 1 стриты)
	brIdCreator,
	brIdEditor,
	brUnix,
	brUnixEditor,
    Float:brCordX[60], // координаты автобусной остановки
    Float:brCordY[60], // координаты автобусной остановки
    Float:brCordZ[60] // координаты автобусной остановки
};
new FullRout[MAX_ROUT][routInfo];

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

CMD:showrout0(playerid)
{
	ShowAllRout(playerid, 0);
	return 1;
}

CMD:showrout1(playerid)
{
	ShowAllRout(playerid, 1);
	return 1;
}


stock SaveCheckPoint(playerid, i)
{
	if(fraction(playerid) != 7) return ErrorMessage(playerid, "Я не сотрудник правительства");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x,y,z);
	new slot = -1;
	if (i == -1)
	{
		for(new za; za < 60; za++)
		{
			if(PlayerInfo[playerid][pCheckPointCount][za] == 0) 
			{
				slot = za;
				break;
			}
		}
		if(slot == -1) return ErrorMessage(playerid, "У меня сохраненно больше 50 точек маршрута");
	}
	else
	{
		slot = i;
	}
	if(slot > 59) return ErrorMessage(playerid, "У меня сохраненно больше 50 точек маршрута");
	PlayerInfo[playerid][CheckPointX][slot] = x;
	PlayerInfo[playerid][CheckPointY][slot] = y;
	PlayerInfo[playerid][CheckPointZ][slot] = z;
	PlayerInfo[playerid][pCheckPointCount][slot] = 1;
	return 1;
}

stock ShowCheckPointAll(playerid)
{
	format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"№ \tX\tY\tZ"), strcat(lines,line);
	format(line,sizeof(line),"\nСохранить маршрут\t\t\t"), strcat(lines,line);
    for(new i = 0; i < 60; i++) 
    {
		if(PlayerInfo[playerid][pCheckPointCount][i] == 1)
		{
			format(line,sizeof(line),"\n%d. \t%f\t%f\t%f", i+1,PlayerInfo[playerid][CheckPointX][i],PlayerInfo[playerid][CheckPointY][i],PlayerInfo[playerid][CheckPointZ][i]), strcat(lines,line);
		}
		else if(PlayerInfo[playerid][pCheckPointCount][i] == 0)
		{
			format(line,sizeof(line),"\n{FF6347}%d.\t\t\t", i+1), strcat(lines,line);
		}
    }
    ShowDialog(playerid,1444,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список чекпоинтов",lines,"Выбрать","Выход");
	return 1;
}

stock SaveNewRout(playerid,who,const Name[])
{
	new quan = -1;
	new slot = -1;
	for(new i = 0; i < 60; i++) 
	{
		if(PlayerInfo[playerid][pCheckPointCount][i] == 1) quan++;
	}
	if(quan < 20) return ErrorMessage(playerid,"{FF6347}В вашем маршруте меньше 20 чекпоинтов");
	for(new i = 0; i < 50; i++) 
	{
		if(FullRout[i][brIdCreator] == 0)
		{
			slot = i;
			break;
		}
	}
	if(slot == -1) return ErrorMessage(playerid,"{FF6347}Не найденно свободного слота под маршрут. Обратитесь к администрации [/report]");
	FullRout[slot][brType] = who;
	format(FullRout[slot][brNameCreator], 24, "%s", rpplayername(playerid));
	format(FullRout[slot][brNameRout], 40, "%s",Name);
	for(new z = 0; z < 60; z++)
	{
		FullRout[slot][brCordX][z] = PlayerInfo[playerid][CheckPointX][z];
		PlayerInfo[playerid][CheckPointX][z] = 0;
		FullRout[slot][brCordY][z] = PlayerInfo[playerid][CheckPointY][z];
		PlayerInfo[playerid][CheckPointY][z] = 0;
		FullRout[slot][brCordZ][z] = PlayerInfo[playerid][CheckPointZ][z];
		PlayerInfo[playerid][CheckPointZ][z] = 0;
		PlayerInfo[playerid][pCheckPointCount][z] = 0;
	}
	SaveRout(slot);
	SuccessMessage(playerid,"{99ff66} Маршрут сохранен")
	return 1;
}

stock SaveRout(slot)
{
	new escapeName[40];
	mysql_escape_string(FullRout[slot][brNameRout], escapeName, sizeof(escapeName));
	// Формируем запросы в переменную
    format(big_query,sizeof(big_query),"UPDATE `pp_rout` SET `status` = '%d', `type` = '%d', `brNameCreator` = '%s', `brNameEditor` = '%s', `brNameRout` = '%s'",FullRout[slot][brStatus], FullRout[slot][brType],FullRout[slot][brNameCreator],FullRout[slot][brNameEditor], escapeName);

    format(big_query,sizeof(big_query),"%s, `brIDEditor` = '%d', `brIDCreator` = '%d', `brUnixEditor` = '%d', `brUnix` = '%d' WHERE `newid` = '%d'", big_query,FullRout[slot][brIdEditor],FullRout[slot][brIdCreator], FullRout[slot][brUnixEditor], FullRout[slot][brUnix], slot);

    // Отправляем запрос
    query_empty(pearsq, big_query);

	format(big_query,sizeof(big_query),"UPDATE `pp_rout` SET `brCordX0` = '%d', `brCordY0` = '%d', `brCordZ0` = '%d'",FullRout[slot][brCordX][0], FullRout[slot][brCordY][0], FullRout[slot][brCordZ][0]);
	for(new i = 1; i < 20; i++) format(big_query,sizeof(big_query),"%s, `brCordX%d` = '%d', `brCordY%d` = '%d', `brCordZ%d` = '%d'", big_query,i, FullRout[slot][brCordX][i], i, FullRout[slot][brCordY][i], i, FullRout[slot][brCordZ][i]);
    format(big_query,sizeof(big_query),"%s WHERE `newid` = '%d'", big_query, slot);
	query_empty(pearsq, big_query);

	format(big_query,sizeof(big_query),"UPDATE `pp_rout` SET `brCordX20` = '%d', `brCordY20` = '%d', `brCordZ20` = '%d'",FullRout[slot][brCordX][20], FullRout[slot][brCordY][20], FullRout[slot][brCordZ][20]);
	for(new i = 21; i < 40; i++) format(big_query,sizeof(big_query),"%s, `brCordX%d` = '%d', `brCordY%d` = '%d', `brCordZ%d` = '%d'", big_query,i, FullRout[slot][brCordX][i], i, FullRout[slot][brCordY][i], i, FullRout[slot][brCordZ][i]);
    format(big_query,sizeof(big_query),"%s WHERE `newid` = '%d'", big_query, slot);
	query_empty(pearsq, big_query);

	format(big_query,sizeof(big_query),"UPDATE `pp_rout` SET `brCordX40` = '%d', `brCordY40` = '%d', `brCordZ40` = '%d'",FullRout[slot][brCordX][40], FullRout[slot][brCordY][40], FullRout[slot][brCordZ][40]);
	for(new i = 41; i < 59; i++) format(big_query,sizeof(big_query),"%s, `brCordX%d` = '%d', `brCordY%d` = '%d', `brCordZ%d` = '%d'", big_query,i, FullRout[slot][brCordX][i], i, FullRout[slot][brCordY][i], i, FullRout[slot][brCordZ][i]);
    format(big_query,sizeof(big_query),"%s WHERE `newid` = '%d'", big_query, slot);
	query_empty(pearsq, big_query);
	return 1;
}

stock ShowPlayerSettingCheckPoint(playerid,i)
{
	format(lines,sizeof(lines),""); // Очищаем Lines
	format(line,sizeof(line),"Chekpont:%d         X:%f Y:%f Z:%f",PlayerInfo[playerid][pCheckPointCount][i],PlayerInfo[playerid][CheckPointX][i],PlayerInfo[playerid][CheckPointY][i],PlayerInfo[playerid][CheckPointZ][i]), strcat(lines,line);
	format(line,sizeof(line),"\nПерезаписать чекпоинт[На текущую позицию]"), strcat(lines,line);
	format(line,sizeof(line),"\nПоказать позицию чекпоинта"), strcat(lines,line);
	format(line,sizeof(line),"\nУдалить чекпоинт"), strcat(lines,line);
	DP[0][playerid] = i;
	ShowDialog(playerid,1445,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Настройка чекпоинта",lines,"Выбрать","Выход");
	return 1;
}

stock ShowAllRout(playerid, type)
{
	format(lines,sizeof(lines),""); // Очищаем Lines
	new tyear, tmonth, tday, thour, tminute, tsecond, quan;
	if(type == 0)
	{
		format(line,sizeof(line),"№ Название\tАвтор\tВремя редактирования\tСтатус"), strcat(lines,line);
		for(new i = 0; i < MAX_ROUT; i++) 
		{
			List[i][playerid] = 0;
			stamp2datetime(FullRout[i][brUnixEditor], tyear, tmonth, tday, thour, tminute, tsecond, 3);
			if(FullRout[i][brStatus] == 0)
			{
				format(line,sizeof(line),"\n%d.%s\t%s\t[ %02d.%02d.%d %02d:%02d ]\t{FF6347}Неактивен", i+1,FullRout[i][brNameRout],FullRout[i][brNameCreator],tyear, tmonth, tday, thour, tminute, tsecond), strcat(lines,line);
			}
			else if(FullRout[i][brStatus] == 1)
			{
				format(line,sizeof(line),"\n%d.%s\t%s\t[ %02d.%02d.%d %02d:%02d ]\t{99ff66}Активен", i+1,FullRout[i][brNameRout],FullRout[i][brNameCreator],tyear, tmonth, tday, thour, tminute, tsecond), strcat(lines,line);
			}
			quan++;
			List[quan][playerid] = i;
		}
	}
	else if(type == 1)
	{
		format(line,sizeof(line),"№ Название\tАвтор\tВремя редактирования"), strcat(lines,line);
		for(new i = 0; i < MAX_ROUT; i++) 
		{
			stamp2datetime(FullRout[i][brUnixEditor], tyear, tmonth, tday, thour, tminute, tsecond, 3);
			format(line,sizeof(line),"\n%d.%s\t%s\t[ %02d.%02d.%d %02d:%02d ]", i+1,FullRout[i][brNameRout],FullRout[i][brNameCreator],tyear, tmonth, tday, thour, tminute, tsecond), strcat(lines,line);
		}
	}
    ShowDialog(playerid,1447,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список чекпоинтов",lines,"Выбрать","Выход");
	return 1;
}

stock SettingRout(playerid,number)
{

	return ErrorMessage(playerid,"ХУЙ СОСАМБА НЕ ДОДЕЛАЛ");
}


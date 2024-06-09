#define MAX_OBJECTS_BUSSTATION 9 // Количество объектов остановки

enum busstationInfo //  Переменные автобусных остановок
{
    idbusstation, // id в базе
	bsActive, // установлена ли остановка
    bsName[34], // название остановки
	bsObject[MAX_OBJECTS_BUSSTATION], // ID динамик объекта
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
	bsRouts[60],
};
new BusStationInfo[MAX_BUSSTATION][busstationInfo];

enum routInfo //  Переменные маршрутов
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
    Float:brCordZ[60], // координаты автобусной остановки
	brBusSta[60] // Номер остановки в маршруте
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
	for(new i; i < 3; i++)
	{
		if((IsPlayerInRangeOfPoint(playerid,2.0,JobBusDepo[i][0],JobBusDepo[i][1],JobBusDepo[i][2])) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT
		&& GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) return 1;
	}
	return 0;
}

stock FindBusDep(playerid) // Ищем ближайшее автобусное депо
{
	new Float:dist, Float:findpos, kakoi, quan;
	dist = GetPlayerDistanceFromPoint(playerid, JobBusDepo[0][0], JobBusDepo[0][1], JobBusDepo[0][2]);
	for(new i = 0; i < 3; i++)
	{
		quan ++;
		findpos = GetPlayerDistanceFromPoint(playerid, JobBusDepo[i][0], JobBusDepo[i][1], JobBusDepo[i][2]);
		if(findpos <= dist) dist = findpos, kakoi = i;
	}
	CreateGps(playerid, JobBusDepo[kakoi][0], JobBusDepo[kakoi][1], JobBusDepo[kakoi][2], 0, 0, 5.0);
	return 1;
}

stock jobbus(playerid)
{
	if(blockwork[2] == 1) return ErrorMessage(playerid,"{ff6347}Работа временна отключена Администрацией");
	if(PlayerInfo[playerid][pPlacement] >= 1 && PlayerInfo[playerid][pPlacement] != 10) return StopJob(playerid);
	new line[100],lines[400];
	
	if(ServerInfo[53] == 9) format(line,sizeof(line),"{99ff66}Повышенная Оплата: Активна \t \n"), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}Стандартная Оплата \t \n"), strcat(lines,line);
	format(line,sizeof(line),"{0088ff}Как заработать? \t \n"), strcat(lines,line);
	if(GetPVarInt(playerid,"job_stat") != 12) format(line,sizeof(line),"{ff9000}Начать Работу \t \n"), strcat(lines,line);
	else if(GetPVarInt(playerid,"job_stat") == 12) format(line,sizeof(line),"{ff9000}Завершить Работу \t \n"), strcat(lines,line);
	format(line,sizeof(line),"{99ff66}Получить Зарплату \t {99ff66}[ %d$ ]\n", PlayerInfo[playerid][pSalary]), strcat(lines,line);
	ShowDialog(playerid,1190,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Автобусное Депо",lines,"Выбор","Отмена");
	return 1;
}

CMD:busstop(playerid)
{
	new g = fraction(playerid);
	if(!IsAFunctionOrganization(61, g, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не сотрудник Правительства");
	if(!GetAccessRankOrg(playerid, g, 61, NO_FBI)) return 1;

	new quan;
	new line[214],lines[4096];
	format(line,sizeof(line),"{ff9000}Добавить Остановку {99ff66}>>"), strcat(lines,line);

	for(new bss = 0; bss < MAX_BUSSTATION; bss++)
	{
		if(BusStationInfo[bss][bsActive] >= 1)
		{
			format(line,sizeof(line),"\n%d. {cccccc}%s",quan+1,BusStationInfo[bss][bsName]), strcat(lines,line);
			List[quan][playerid] = bss;
			quan ++;
		}
	}
	ShowDialog(playerid,1301,DIALOG_STYLE_LIST,"{ff9000}Автобусные Остановки",lines,"Выбрать","Отмена");
	return 1;
}


function Call_getidBusStation(idx) {
    BusStationInfo[idx][idbusstation] = cache_insert_id();
    return 1;
}
stock InsertBusStation(idx)
{
	new string_mysql[500];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "INSERT INTO `pp_busstation` SET `bsActive`='%d',`bsVlad`='%d',`bsPlayerName`='%e',`bsName`='%e',`bsUnix`='%d',\
		`bsCordX`='%f',`bsCordY`='%f',`bsCordZ`='%f',`bsCordRX`='%f',`bsCordRY`='%f',`bsCordRZ`='%f'",
	BusStationInfo[idx][bsActive],BusStationInfo[idx][bsVlad],BusStationInfo[idx][bsPlayerName],BusStationInfo[idx][bsName],BusStationInfo[idx][bsUnix],BusStationInfo[idx][bsCordX],BusStationInfo[idx][bsCordY],
	BusStationInfo[idx][bsCordZ],BusStationInfo[idx][bsCordRX],BusStationInfo[idx][bsCordRY],BusStationInfo[idx][bsCordRZ]); // 208 + 33 + 24 + 34 + 120
	mysql_tquery(pearsq, string_mysql, "Call_getidBusStation", "d", idx); // 419
	return 1;
}

stock UpdateBusStation(idx)
{
	new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT * FROM `pp_busstation` WHERE `idbusstation` = '%d'", BusStationInfo[idx][idbusstation]);
	mysql_tquery(pearsq, string_mysql, "Call_UpdateBusStation", "d", idx);
	return 1;
}
function Call_UpdateBusStation(idx)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new string_mysql[500];
		mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_busstation` SET `bsACtive`='%d',`bsVlad`='%d',`bsPlayerName`='%e',`bsName`='%e',`bsUnix`='%d',\
		`bsCordX`='%f',`bsCordY`='%f',`bsCordZ`='%f',`bsCordRX`='%f',`bsCordRY`='%f',`bsCordRZ`='%f' WHERE `idbusstation` = '%d'",
		BusStationInfo[idx][bsActive],BusStationInfo[idx][bsVlad],BusStationInfo[idx][bsPlayerName],BusStationInfo[idx][bsName],BusStationInfo[idx][bsUnix],
		BusStationInfo[idx][bsCordX],BusStationInfo[idx][bsCordY],
		BusStationInfo[idx][bsCordZ],BusStationInfo[idx][bsCordRX],BusStationInfo[idx][bsCordRY],BusStationInfo[idx][bsCordRZ],
		BusStationInfo[idx][idbusstation]); // 231 + 44 + 24 + 34 + 120
		query_empty(pearsq, string_mysql);
	}
	return 1;
}
function Call_DelBusStation(idx)
{
	new rows;
	cache_get_row_count(rows);
	if(rows) 
	{
		new string_mysql[56 + 11];
		mysql_format(pearsq, string_mysql,sizeof(string_mysql),"DELETE FROM `pp_busstation` WHERE `idbusstation` = '%d'",BusStationInfo[idx][idbusstation]);
		query_empty(pearsq, string_mysql);
	}
	return 1;
}

stock busstationcreate(f)
{
	// Объект остановка
	new object_world = 17, object_int = 228; // Временно скрываем созданные объекты

	BusStationInfo[f][bsObject][0] = CreateDynamicObject(1257, 1338.824340, 1567.324584, 11.124113, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][0], 0, 4552, "ammu_lan2", "sunsetammu1", 0x00000000);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][0], 1, 18065, "ab_sfammumain", "shelf_glas", 0x00000000);
	gadd(BusStationInfo[f][bsObject][0], 0, 0);
	BusStationInfo[f][bsObject][1] = CreateDynamicObject(19447, 1338.012084, 1567.185791, 9.763391, 0.000000, 90.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][1], 0, 8409, "gnhotel1", "ap_tarmac", 0x00000000);
	gadd(BusStationInfo[f][bsObject][1], 0, 0);
	BusStationInfo[f][bsObject][2] = CreateDynamicObject(2388, 1336.756591, 1570.206909, 9.846875, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][2], 0, 19467, "speed_bumps", "speed_bump01", 0x00000000);
	gadd(BusStationInfo[f][bsObject][2], 0, 0);
	BusStationInfo[f][bsObject][3] = CreateDynamicObject(2388, 1339.746215, 1564.995239, 9.846875, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][3], 0, 19467, "speed_bumps", "speed_bump01", 0x00000000);
	gadd(BusStationInfo[f][bsObject][3], 0, 0);
	BusStationInfo[f][bsObject][4] = CreateDynamicObject(19483, 1337.679565, 1563.141113, 9.876096, -0.000015, -90.000000, -89.999954, object_world, object_int, -1, 300.00, 300.00); 
	SetDynamicObjectMaterialText(BusStationInfo[f][bsObject][4], 0, "BUS\nSTOP", 130, "Century Gothic", 70, 1, 0xFF888888, 0x00000000, 2);
	gadd(BusStationInfo[f][bsObject][4], 0, 0);
	BusStationInfo[f][bsObject][5] = CreateDynamicObject(19482, 1337.719116, 1563.443603, 9.874356, -0.000015, -90.000000, -89.999954, object_world, object_int, -1, 300.00, 300.00); 
	SetDynamicObjectMaterialText(BusStationInfo[f][bsObject][5], 0, "v", 130, "Webdings", 90, 1, 0xFF888888, 0x00000000, 1);
	gadd(BusStationInfo[f][bsObject][5], 0, 0);
	BusStationInfo[f][bsObject][6] = CreateDynamicObject(2388, 1336.756591, 1564.995239, 9.846875, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][6], 0, 19467, "speed_bumps", "speed_bump01", 0x00000000);
	gadd(BusStationInfo[f][bsObject][6], 0, 0);
	BusStationInfo[f][bsObject][7] = CreateDynamicObject(2388, 1339.747070, 1570.206909, 9.846875, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][7], 0, 19467, "speed_bumps", "speed_bump01", 0x00000000);
	gadd(BusStationInfo[f][bsObject][7], 0, 0);
	BusStationInfo[f][bsObject][8] = CreateDynamicObject(2388, 1336.756591, 1567.596069, 9.846875, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][8], 0, 19467, "speed_bumps", "speed_bump01", 0x00000000);
	gadd(BusStationInfo[f][bsObject][8], 0, 0);

	// Смещаем координаты
	TSInfo[tsOffset][0] = -0.572509;
	TSInfo[tsOffset][1] = -0.650512;
	TSInfo[tsOffset][2] = -0.680360;

	// Расчитываем, куда ставить все объекты
	MatrixDynamicObjectPos(0, BusStationInfo[f][bsCordX], BusStationInfo[f][bsCordY], BusStationInfo[f][bsCordZ], BusStationInfo[f][bsCordRX], BusStationInfo[f][bsCordRY], BusStationInfo[f][bsCordRZ]);

	new string[94];
	format(string,sizeof(string),"{ff9000}Автобусная Остановка № %d {cccccc}\n[ ALT ]", f + 1);
	busstation_label[f] = CreateDynamic3DTextLabel(string,-1,BusStationInfo[f][bsCordX], BusStationInfo[f][bsCordY], BusStationInfo[f][bsCordZ],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
	busstation_pickup[f] = CreateDynamicPickup(2485, 1, BusStationInfo[f][bsCordX], BusStationInfo[f][bsCordY], BusStationInfo[f][bsCordZ],0,0);
}

stock DestroyObjectsBusStation(f)
{
	for(new i = 0; i < MAX_OBJECTS_BUSSTATION; i++)
	{
		if(IsValidDynamicObject(BusStationInfo[f][bsObject][i])) DestroyDynamicObject(BusStationInfo[f][bsObject][i]), BusStationInfo[f][bsObject][i] = 0;
	}
	return 1;
}

CMD:scp(playerid)
{
	new fam = PlayerInfo[playerid][pFamily];
	if(fraction(playerid) != 7 && FamilyInfo[fam][fType] != 4) return ErrorMessage(playerid,"{ff6347} Вы не состоите в правительстве или Семье типа: Street Racers");
	if(PlayerInfo[playerid][pSCP] == 0)
	{
		PlayerInfo[playerid][pSCP] = 1;
		PlayerPlaySound(playerid,17803,0,0,0);
		new stro[90],sctringo[720];
		format(stro,sizeof(stro),"\n{ff9000}Информация по системе:"), strcat(sctringo,stro);
		format(stro,sizeof(stro),"\n\n\n{cccccc}- Это система позволяет записывать вашу позицию в специальный список"), strcat(sctringo,stro);
		format(stro,sizeof(stro),"\nзапись происходит когда вы сидите в транспорте и нажимаете кнопку [ CAPS LOCK ]"), strcat(sctringo,stro);
		format(stro,sizeof(stro),"\n{cccccc}- Редактировать координаты можно написав команду [ /scpa ]"), strcat(sctringo,stro);
		format(stro,sizeof(stro),"\n{cccccc}- После записи координат обязательно загрузите их в базу что бы не потерять"), strcat(sctringo,stro);
		format(stro,sizeof(stro),"\n{cccccc}- По окончанию записи, отключите её написав команду [ /scp ]"), strcat(sctringo,stro);
		if(fraction(playerid) == 7)format(stro,sizeof(stro),"\n\n{FF6347}ВАЖНО!! {cccccc}- Автобусные маршруты должны быть кольцевыми"), strcat(sctringo,stro);
		if(fraction(playerid) == 7)format(stro,sizeof(stro),"\n - Последний чекпоинт должен находится рядом с первым!"), strcat(sctringo,stro);
		ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Запись координат",sctringo,"Ок","");
	}
	else if(PlayerInfo[playerid][pSCP] == 1)
	{
		PlayerInfo[playerid][pSCP] = 0;
		SuccessMessage(playerid,"{ff9000}Вы выключили запись чекпоинтов на авто на CAPS LOCK");
	}
	return 1;
}

CMD:scpa(playerid)
{
	ShowCheckPointAll(playerid);
	return 1;
}

CMD:showrout0(playerid)
{
	ShowAllRout(playerid);
	return 1;
}


stock SaveCheckPoint(playerid, i)
{
	if(fraction(playerid) != 7 && FamilyInfo[PlayerInfo[playerid][pFamily]][fType] != 4) return ErrorMessage(playerid,"{ff6347} Вы не состоите в правительстве или Семье типа: Street Racers");
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
		if(slot == -1) return ErrorMessage(playerid, "У меня нет свободного слота для точки маршрута");
	}
	else
	{
		slot = i;
	}
	if(slot > 59) return ErrorMessage(playerid, "У меня нет свободного слота для точки маршрута");
	PlayerInfo[playerid][CheckPointX][slot] = x;
	PlayerInfo[playerid][CheckPointY][slot] = y;
	PlayerInfo[playerid][CheckPointZ][slot] = z;
	PlayerInfo[playerid][pCheckPointCount][slot] = 1;
	SuccessMessage(playerid,"{99ff66}Чекпоинт сохранен!");
	return 1;
}

stock ShowCheckPointAll(playerid)
{
	new line[214],lines[4096];
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
	FullRout[slot][brIdCreator] = PlayerInfo[playerid][pID];
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
	FullRout[slot][brUnix] = gettime();
	SaveRout(slot);
	GiveUnit(playerid, 14);
	SuccessMessage(playerid,"{99ff66} Маршрут сохранен");
	return 1;
}
forward LoadRout(); // Загрузка из базы
public LoadRout()
{
	new time = GetTickCount();
	new rows,string[34];
	cache_get_row_count(rows);
	for(new f; f<rows; ++f)
	{
    	cache_get_value_name_int(f, "newid", FullRout[f][brId]);
    	cache_get_value_name_int(f, "status", FullRout[f][brStatus]);
		cache_get_value_name_int(f, "type", FullRout[f][brType]);
		cache_get_value_name(f, "brNameCreator", FullRout[f][brNameCreator],24);
		cache_get_value_name(f, "brNameEditor", FullRout[f][brNameEditor],24);
		cache_get_value_name(f, "brNameRout", FullRout[f][brNameRout],24);
		cache_get_value_name_int(f, "brIDEditor", FullRout[f][brIdEditor]);
    	cache_get_value_name_int(f, "brIDCreator", FullRout[f][brIdCreator]);
		cache_get_value_name_int(f, "brUnixEditor", FullRout[f][brUnixEditor]);
		cache_get_value_name_int(f, "brUnix", FullRout[f][brUnix]);
		for(new i = 0; i < MAX_CHECKPOINT; i++)
		{
			format(string,sizeof(string),"brCordX%d", i), cache_get_value_name_float(f, string, FullRout[f][brCordX][i]);
			format(string,sizeof(string),"brCordY%d", i), cache_get_value_name_float(f, string, FullRout[f][brCordY][i]);
			format(string,sizeof(string),"brCordZ%d", i), cache_get_value_name_float(f, string, FullRout[f][brCordZ][i]);
		}
		if(FullRout[f][brStatus] > 0) CheckingBusStationInRout(f);
	}
	printf("[MODE]: Автобусные Маршруты [%d Quan][%d ms]",rows,GetTickCount() - time);
	return 1;
}

stock SaveRout(slot)
{
	new string_mysql[3600];
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_rout` SET `status` = '%d', `type` = '%d', `brNameCreator` = '%e', `brNameEditor` = '%e', `brNameRout` = '%e'",
		FullRout[slot][brStatus], FullRout[slot][brType],FullRout[slot][brNameCreator],FullRout[slot][brNameEditor], FullRout[slot][brNameRout]); // 121 + 22 + 24 + 24 + 40
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s, `brIDEditor` = '%d', `brIDCreator` = '%d', `brUnixEditor` = '%d', `brUnix` = '%d' WHERE `newid` = '%d'", string_mysql,
		FullRout[slot][brIdEditor],FullRout[slot][brIdCreator], FullRout[slot][brUnixEditor], FullRout[slot][brUnix], FullRout[slot][brId]); // 107 + 55
    query_empty(pearsq, string_mysql); // 393

	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_rout` SET `brCordX0` = '%f', `brCordY0` = '%f', `brCordZ0` = '%f'",FullRout[slot][brCordX][0], 
	FullRout[slot][brCordY][0], FullRout[slot][brCordZ][0]); // 77 + 60
	for(new i = 1; i < 20; i++) 
	{
		mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s, `brCordX%d` = '%f', `brCordY%d` = '%f', `brCordZ%d` = '%f'", string_mysql,i, FullRout[slot][brCordX][i], 
		i, FullRout[slot][brCordY][i], i, FullRout[slot][brCordZ][i]); // 63 + 33 + 60
	}
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s WHERE `newid` = '%d'", string_mysql, FullRout[slot][brId]); // 24 + 11
	query_empty(pearsq, string_mysql);


	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_rout` SET `brCordX20` = '%f', `brCordY20` = '%f', `brCordZ20` = '%f'",FullRout[slot][brCordX][20], 
	FullRout[slot][brCordY][20], FullRout[slot][brCordZ][20]); // 80 + 60
	for(new i = 21; i < 40; i++) 
	{
		mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s, `brCordX%d` = '%f', `brCordY%d` = '%f', `brCordZ%d` = '%f'", string_mysql,i, FullRout[slot][brCordX][i], 
		i, FullRout[slot][brCordY][i], i, FullRout[slot][brCordZ][i]); // 64 + 33 + 60
	}
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s WHERE `newid` = '%d'", string_mysql, FullRout[slot][brId]); // 24 + 11
	query_empty(pearsq, string_mysql);


	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_rout` SET `brCordX40` = '%f', `brCordY40` = '%f', `brCordZ40` = '%f'",FullRout[slot][brCordX][40], 
	FullRout[slot][brCordY][40], FullRout[slot][brCordZ][40]); // 80 + 60
	for(new i = 41; i < 60; i++) 
	{
		mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s, `brCordX%d` = '%f', `brCordY%d` = '%f', `brCordZ%d` = '%f'", string_mysql,i, FullRout[slot][brCordX][i], 
		i, FullRout[slot][brCordY][i], i, FullRout[slot][brCordZ][i]); // 64 + 33 + 60
	}
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s WHERE `newid` = '%d'", string_mysql, FullRout[slot][brId]); // 24 + 11
	query_empty(pearsq, string_mysql);
	return 1;
}

stock ShowPlayerSettingCheckPoint(playerid,i)
{
	new line[120],lines[480];
	format(line,sizeof(line),"Chekpont:%d         X:%f Y:%f Z:%f",PlayerInfo[playerid][pCheckPointCount][i],PlayerInfo[playerid][CheckPointX][i],PlayerInfo[playerid][CheckPointY][i],PlayerInfo[playerid][CheckPointZ][i]), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Перезаписать чекпоинт[На текущую позицию]"), strcat(lines,line);
	format(line,sizeof(line),"\nПоказать позицию чекпоинта"), strcat(lines,line);
	format(line,sizeof(line),"\n{ff6347}Удалить чекпоинт"), strcat(lines,line);
	DP[0][playerid] = i;
	ShowDialog(playerid,1445,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Настройка чекпоинта",lines,"Выбрать","Выход");
	return 1;
}

stock ShowAllRout(playerid)
{
	new g = fraction(playerid);
	if(!IsAFunctionOrganization(61, g, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не сотрудник Правительства");

	new line[214],lines[4096];
	new tyear, tmonth, tday, thour, tminute, tsecond, quan;
	format(line,sizeof(line),"№ Название\tАвтор\tПоследнее Изменение\tСтатус"), strcat(lines,line);
	for(new i = 0; i < MAX_ROUT; i++) 
	{
		List[i][playerid] = 0;
		if(FullRout[i][brUnixEditor] > 0) stamp2datetime(FullRout[i][brUnixEditor], tyear, tmonth, tday, thour, tminute, tsecond, 3);
		else if(FullRout[i][brUnixEditor] == 0) stamp2datetime(FullRout[i][brUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
		if(FullRout[i][brStatus] == 0 && FullRout[i][brIdCreator] != 0)
		{
			format(line,sizeof(line),"\n{ff9000}%d. %s\t{cccccc}%s\t{666666}%02d.%02d.%d %02d:%02d\t{FF6347}Неактивен", i+1,FullRout[i][brNameRout],FullRout[i][brNameCreator], tday, tmonth, tyear, thour, tminute), strcat(lines,line);
		}
		else if(FullRout[i][brStatus] == 1  && FullRout[i][brIdCreator] != 0)
		{
			format(line,sizeof(line),"\n{ff9000}%d. %s\t{cccccc}%s\t{666666}%02d.%02d.%d %02d:%02d\t{99ff66}Активен", i+1,FullRout[i][brNameRout],FullRout[i][brNameCreator],tday, tmonth, tyear, thour, tminute), strcat(lines,line);
		}
		List[quan][playerid] = i;
		quan++;
	}
	if(quan == 0) return ErrorMessage(playerid,"Нет созданных маршрутов");
    ShowDialog(playerid,1447,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список маршрутов",lines,"Выбрать","Выход");
	return 1;
}

stock SettingRout(playerid, number, author)
{
	DP[0][playerid] = number;
	if(author == 0)
	{
		new tyear, tmonth, tday, thour, tminute, tsecond;
		new line[80],lines[240];
		stamp2datetime(FullRout[number][brUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
		format(line,sizeof(line),"{ff9000}%s %s", FullRout[number][brNameRout], FullRout[number][brNameCreator]), strcat(lines,line);

		stamp2datetime(FullRout[number][brUnixEditor], tyear, tmonth, tday, thour, tminute, tsecond, 3);
		format(line,sizeof(line),"\n{ffcc66}Последние Изменения:"), strcat(lines,line);
		format(line,sizeof(line),"\n{666666}%s", FullRout[number][brNameEditor]), strcat(lines,line);
		format(line,sizeof(line),"\n{666666}%s %02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute), strcat(lines,line);

		format(line,sizeof(line),"\n\n{ffcc66}Вы можете загрузить чекпоинты этого маршрута на свой аккаунт"), strcat(lines,line);
		format(line,sizeof(line),"\n{ffcc66}для дальнейшего редактирования [ /scp /scpa ]"), strcat(lines,line);
		format(line,sizeof(line),"\n\n{ff9000}Хотите загрузить чекпоинты маршрута?"), strcat(lines,line);
		ShowDialog(playerid,1448,DIALOG_STYLE_MSGBOX,"{ff9000}Маршрут",lines,"Да","Нет");
	}
	else if(author == 1)
	{
		new line[90],lines[630];
		format(line,sizeof(line),"{ff9000}%s", FullRout[number][brNameRout]), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}Переименовать маршрут"), strcat(lines,line);
		format(line,sizeof(line),"\nЗагрузить маршрут себе в чекпоинты"), strcat(lines,line);
		format(line,sizeof(line),"\nОбновить маршрут (загрузит ваши текущие координаты в него)"), strcat(lines,line);
		format(line,sizeof(line),"\n{ff6347}Удалить маршрут из базы"), strcat(lines,line);
		format(line,sizeof(line),"\n{66ff99}Активировать{cccccc}/{ff6347}Деактивировать {cccccc}маршрут"), strcat(lines,line);
		ShowDialog(playerid,1449,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Маршрут",lines,"Выбрать","Назад");
	}
	return 1;
}

stock CreateBusDriver(playerid)
{
	for(new i = 0; i < MAX_BUSDRIVER; i++)
	{
	    if(busdriverid[i] == 0)
	    {
	        busdriverid[i] = playerid+1;
	        busdriverstat[i] = 1;
	        driverid[playerid] = i+1;
	        break;
	    }
 	}
 	busdrivers[busrout[playerid]] ++;
    bus[playerid] = 0, bustime[playerid] = 0, busstation[playerid] = 0;
	if(busroutetime > gettime())
	{
	    new string[254];
		format(string,sizeof(string),"{FF6347}Следующий автобус может отправиться на маршрут через: %d секунд\n{cccccc}Необходимо, чтобы автобусы прибывали на остановки с интервалом\n\n{ff9000}Сядьте в автобус повторно немного позже, чтобы запустить маршрут!", busroutetime-gettime()), ErrorMessage(playerid, string);
		return 1;
	}
	busroutetime = gettime()+60;
	return 1;
}

stock ExitBusDriver(playerid)
{
	new i = driverid[playerid];

    busdriverid[i] = 0;
    busdriverstat[i] = 0;
	driverid[playerid] = 0;
	bus[playerid] = 0, bustime[playerid] = gettime(), busstation[playerid] = 0;

	if(busrout[playerid] > 0)
	{
    	if(busdrivers[busrout[playerid]] > 0) busdrivers[busrout[playerid]]--;
	}
    
    SetPVarInt(playerid,"job_stat",0), RemovePlayerAttachedObject(playerid,0), DisablePlayerRaceCheckpoint(playerid);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    new v = GetPlayerVehicleID(playerid);
	    if(VehInfo[playerid][vModel] == 431 && VehInfo[v][v3dstat] == 7000) DestroyDynamic3DTextLabel(VehLabel[v]), VehInfo[v][v3dstat] = 0;
	}
	busrout[playerid] = -1;
	return 1;
}
stock BusRouterEnd(playerid)
{
	if(PlayerInfo[playerid][pPlacement] == 0 || PlayerInfo[playerid][pPlacement] == 10)
	{
		new v = GetPlayerVehicleID(playerid);
		new rout = busrout[playerid];
		bus[playerid] = 0;
		bustime[playerid] = gettime();
		busstation[playerid] = 0;
		DisablePlayerRaceCheckpoint(playerid);
		if(VehInfo[v][v3dstat] == 7000) UpdateLabelBus(playerid, v);
		PlayerInfo[playerid][pPlacement] = 10;
		new zp;
		if(ServerInfo[63] <= 0) zp = 10;
		else zp = ServerInfo[63];
		new Float:distance;
		for(new i; i< MAX_CHECKPOINT; i++)
		{
			if(i + 1 >= MAX_CHECKPOINT) break;
			if(FullRout[rout][brCordX][i+1] == 0.0 && FullRout[rout][brCordY][i+1] == 0.0) break;
			distance += GetDistancePoint(FullRout[rout][brCordX][i],FullRout[rout][brCordY][i],FullRout[rout][brCordZ][i],FullRout[rout][brCordX][i+1],FullRout[rout][brCordY][i+1],FullRout[rout][brCordZ][i+1]);
		}
		zp = floatround(distance, floatround_round)/100*zp;
		PlayerInfo[playerid][pSalary] += zp;
		new string[100];
		format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~+%d$~n~~w~JOB: ~g~%d$",zp,PlayerInfo[playerid][pSalary]);
		GameTextForPlayer(playerid,string,7000,3);
		format(string,sizeof(string),"{ff9000}Конечная!\n{99ff66}Зарплата: %d$\n\n{ff9000}Вы хотите продолжить работу?", zp);
		ShowDialog(playerid,1194,DIALOG_STYLE_MSGBOX,"{ff9000}Автобусное Депо",string,"Да","Нет");
		mysql_save(playerid, 58);
		SetVehicleVelocity(v, 0.0, 0.0, 0.0);
		if(PlayerInfo[playerid][pAchieve][100] == 0) AchievePlayer(playerid, 100, 1);

		// Работать водителем автобуса
		CompletingDaily(playerid, 21, 1);
	}
	return 1;
}

stock BusRouter(playerid, v)
{
    if(VehInfo[v][v3dstat] >= 1 && VehInfo[v][v3dstat] <= 900) return ErrorMessage(playerid, "{FF6347}Этот автобус сейчас в такси");
	new slot = busrout[playerid];
	new r = bus[playerid];
	if(r == 0)
	{
	    if(busdrivers[busrout[playerid]] >= MAX_BUSDRIVER && driverid[playerid] == 0) return ErrorMessage(playerid, "{FF6347}Сейчас на дежурстве 30 водителей автобусов\n{cccccc}Вы можете дождаться свободное место или отправиться на другую работу");
	    if(driverid[playerid] == 0) CreateBusDriver(playerid);
	}
	if(driverid[playerid] > 0) busdriverstat[driverid[playerid]-1] = 1;
	DisablePlayerRaceCheckpoint(playerid);

	new bool:Finish;
	if(r >= 60) Finish = true; // Заехали на последний
	else
	{
		if(FullRout[slot][brCordX][r] == 0.0 && FullRout[slot][brCordY][r] == 0.0) Finish = true; // Следующий последний
		else
		{
			// Следующий чекпоинт не существует (значит отображаем финишный)
			if(r + 1 >= 60) SetPlayerRaceCheckpoint(playerid,CP_TYPE:1,FullRout[slot][brCordX][r], FullRout[slot][brCordY][r], FullRout[slot][brCordZ][r], 0.0, 0.0, 0.0,6.0);
			else
			{
				// Следующий чекпоинт пустой (значит отображаем финишный)
				if(FullRout[slot][brCordX][r + 1] == 0.0 && FullRout[slot][brCordY][r + 1] == 0.0) SetPlayerRaceCheckpoint(playerid,CP_TYPE:1,FullRout[slot][brCordX][r], FullRout[slot][brCordY][r], FullRout[slot][brCordZ][r], 0.0, 0.0, 0.0,6.0);
				else SetPlayerRaceCheckpoint(playerid,CP_TYPE:0,FullRout[slot][brCordX][r], FullRout[slot][brCordY][r], FullRout[slot][brCordZ][r], FullRout[slot][brCordX][r + 1], FullRout[slot][brCordY][r + 1], FullRout[slot][brCordZ][r + 1],6.0);
			}
		}
	}


	// Финиш маршрута
	if(Finish == true) return BusRouterEnd(playerid);
	
	if(VehInfo[v][v3dstat] > 1) UpdateLabelBus(playerid, v);
	else
	{
		ReloadVehicleLabel(v); // Перезагружаем лейбл на тс
		
	    VehInfo[v][v3dstat] = 7000;
		new Float:v_pos[3];
		GetVehiclePos(v, v_pos[0],v_pos[1],v_pos[2]);
		VehLabel[v] = CreateDynamic3DTextLabel(" ",-1,v_pos[0],v_pos[1],v_pos[2], 15.0, INVALID_PLAYER_ID, v);
		UpdateLabelBus(playerid, v);
	}
	return 1;
}

stock IsPlayerCity(playerid)
{
  if(IsPlayerInSquare(playerid,-1236, -372, -133, 542) || IsPlayerInSquare(playerid,-133, -3000, 3000, 542)) return 1; // LS
  else if(IsPlayerInSquare(playerid,-3000, -3000, -1236.015625, 1544) || IsPlayerInSquare(playerid,-1236.0625, -3000, -133.0625, -372)) return 2; // SF
  else if(IsPlayerInSquare(playerid,-1236, 542, 3000, 3000) || IsPlayerInSquare(playerid,-3000, 1544, -1236, 3000)) return 3; // LV
  return 1;
}

stock ShowRoutCity(playerid)
{
	new line[214],lines[4096];
	format(line,sizeof(line),"№ Маршрут\tВодителей"), strcat(lines,line);
	new quan, Float:x,Float:y, Float:x2,Float:y2,Float:x3,Float:y3,Float:x4,Float:y4;
	if(IsPlayerCity(playerid) == 3) x = -1236,y= 542, x2 = 3000.0,y2=3000.0,x3 =-3000 , y3 =1544 ,x4 =-1236 , y4 =3000; // lv
	else if(IsPlayerCity(playerid)  == 2) x = -3000.0, y= -3000.0, x2 = -1236.0, y2 = 1544.0,x3 = -1236.0625, y3 = -3000.0,x4 = -133.0625 ,y4= -372.0;//sf
	else if(IsPlayerCity(playerid)  == 1) x = -1236.0, y = -372.0, x2 = -133.0, y2 = 542.0, x3 = -133.0625, y3 = -3000, x4 = 3000, y4 = 542; //ls
	// СЮДА ФОРЕЧ
	for(new i; i < 50; i++)
	{	
		List[i][playerid] = 0;
		if((IsPosInSquare(FullRout[i][brCordX][0],FullRout[i][brCordY][0],x,y,x2,y2) || IsPosInSquare(FullRout[i][brCordX][0],FullRout[i][brCordY][0],x3,y3,x4,y4)) && FullRout[i][brStatus] == 1)
		{
			format(line,sizeof(line),"\n%d.%s\t %d", quan+1,FullRout[i][brNameRout],busdrivers[i]), strcat(lines,line);
			List[quan][playerid] = i + 1;
			quan ++;
		}
	}
	if(quan > 0) ShowDialog(playerid,1450,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Маршрут",lines,"Выбрать","Закрыть");
	else if (quan == 0) ErrorMessage(playerid,"В этом городе нет ни одного маршрута автобуса! Обратитесь в правительство что бы они активировали/создали маршурт. Либо отправляйтесь в депо другого города");
	return 1;
}
stock showDialogMenuBusStation(playerid, cam)
{
	if(BusStationInfo[cam][bsActive] == 0) return ErrorText(playerid,"[ Мысли ]: Остановки не существует"), pc_cmd_busstop(playerid);
	new header[80];
	format(header,sizeof(header),"{ff9000}%s", BusStationInfo[cam][bsName]);
	ShowDialog(playerid,1302,DIALOG_STYLE_LIST,header,"{444444}Об остановке..\n{cccccc}Найти\n{cccccc}Изменить название\n{FF6347}Удалить","Выбор","Отмена");
	return 1;
}

stock infoBusStation(playerid, cam)
{
	if(BusStationInfo[cam][bsActive] >= 1)
	{
		new line[100],lines[300];
		new tyear, tmonth, tday, thour, tminute, tsecond;
		stamp2datetime(BusStationInfo[cam][bsUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
	 	format(line,sizeof(line),"{cccccc}Остановка {ff9000}%s",BusStationInfo[cam][bsName]), strcat(lines,line);
	 	format(line,sizeof(line),"\n\n{cccccc}Установил: {ff9000}%s",BusStationInfo[cam][bsPlayerName]), strcat(lines,line);
	 	format(line,sizeof(line),"\n{cccccc}Дата и время установки: %02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute), strcat(lines,line);
		ShowDialog(playerid,1303,DIALOG_STYLE_MSGBOX,"{ff9000}Автобусные Остановки",lines,"*","");
	}
	return 1;
}

CMD:gotobusstop(playerid, const params[])
{	
	if(PlayerInfo[playerid][pSoska] <= 0) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Телепорт к остановке [ /gotobusstop ID ]");
	if(params[0] < 1 || params[0] > 100) return ErrorMessage(playerid, "{FF6347}Номер не меньше 1 и не больше 100");
	S_SetPlayerVirtualWorld(playerid, 0, 0);
	PPSetPlayerInterior(playerid, 0);
	PPSetPlayerPos(playerid, BusStationInfo[params[0] - 1][bsCordX], BusStationInfo[params[0] - 1][bsCordY], BusStationInfo[params[0] - 1][bsCordZ]);
	PPSetPlayerFacingAngle(playerid,0.0);
	return 1;
}

stock CheckingBusStationInRout(rout)
{
	if(FullRout[rout][brStatus] == 0) return 1;
	for(new r;r<60;r++)
	{
		if(FullRout[rout][brCordX][r] == 0.0 && FullRout[rout][brCordY][r] == 0.0) break;
		for(new i;i<MAX_BUSSTATION;i++)
		{
			if(GetDistancePoint(BusStationInfo[i][bsCordX],BusStationInfo[i][bsCordY],BusStationInfo[i][bsCordZ],FullRout[rout][brCordX][r],FullRout[rout][brCordY][r],FullRout[rout][brCordZ][r]) > 10) continue;
			for(new slot;slot<60;slot++)
			{
				if(BusStationInfo[i][bsRouts][slot] != 0) continue;
				BusStationInfo[i][bsRouts][slot] = rout+1;
				break;
			}
			break;
		}
	}
	return 1;
}

stock DeactivBusStationInRout(rout)
{
	for(new i;i<MAX_BUSSTATION;i++)
	{
		for(new slot;slot<60;slot++)
		{
			if(FullRout[rout][brCordX][slot] == 0.0 && FullRout[rout][brCordY][slot] == 0.0) break;
			if(BusStationInfo[i][bsRouts][slot] == 0) continue;
			BusStationInfo[i][bsRouts][slot] = 0;
			break;
		}
	}
	return 1;
}

#define MAX_OBJECTS_BUSSTATION 17 // Количество объектов остановки

enum busstationInfo // Переменные автобусных остановок
{
    idbusstation, // id в базе
	bsActive, // установлена ли остановка
    bsName[34], // название остановки
	bsObject[17], // ID динамик объекта
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



/*static Float:BusStaionObjectPosition[MAX_OBJECTS_BUSSTATION][6] = { // Дефолтные координаты расположения объектов остановки
	{645.922241, -1554.572143, 15.758572, 0.0, 0.0, 0.0}, // Остановка
	{644.873657, -1559.954223, 14.055287, 90.0, 90.0, 0.0}, // 450 было
	{644.894287, -1549.843139, 14.002370, 90.0, 90.0, 0.0}, // 450 было
	{645.257934, -1558.695556, 14.547038, 0.0, -90.0, -90.0},
	{643.157775, -1558.519409, 14.545808, 0.0, -90.0, -90.0},
	{645.650512, -1554.710937, 14.425846, 0.0, 90.0, 0.0},
	{644.139343, -1554.708374, 14.417606, 0.0, 90.0, 0.0},
	{645.045776, -1557.234497, 13.233481, 0.0, 0.0, 0.0},
	{642.615295, -1557.230468, 13.233103, 0.0, 0.0, 0.0},
	{642.619628, -1554.728393, 13.220008, 0.0, 0.0, 0.0},
	{642.624450, -1551.987792, 13.205666, 0.0, 0.0, 0.0},
	{645.024475, -1551.981933, 13.205986, 0.0, 0.0, 0.0},
	{642.641662, -1557.241577, 15.052589, 0.0, 0.0, 0.0},
	{642.650817, -1551.960449, 15.024950, 0.0, 0.0, 0.0},
	{645.074096, -1557.245727, 15.052967, 0.0, 0.0, 0.0},
	{645.083190, -1551.940795, 15.025201, 0.0, 0.0, 0.0},
	{642.646118, -1554.713012, 15.039356, 0.0, 0.0, 0.0}
};*/


// Функция для вычисления положения всех объектов относительно первого
/*stock CalculateObjectPositions(f)
{
    // Координаты и углы первого объекта
    new Float:refX, refY, refZ;
    new Float:refRX, refRY, refRZ;
    
    // Получаем координаты и углы первого объекта
    refX = BusStationInfo[f][bsCordX];
    refY = BusStationInfo[f][bsCordY];
    refZ = BusStationInfo[f][bsCordZ];
    refRX = BusStationInfo[f][bsCordRX];
    refRY = BusStationInfo[f][bsCordRY];
    refRZ = BusStationInfo[f][bsCordRZ];
    
    // Вычисляем положение остальных объектов относительно первого
    for (new i = 1; i < MAX_OBJECTS_BUSSTATION; i++)
    {
        // Координаты и углы текущего объекта
        new Float:objX, objY, objZ;
        new Float:objRX, objRY, objRZ;
        
        // Получаем координаты и углы текущего объекта
        GetDynamicObjectPos(BusStationInfo[f][bsObject][i], objX, objY, objZ);
		GetDynamicObjectRot(BusStationInfo[f][bsObject][i], objRX, objRY, objRZ);
        
        // Вычисляем разницу координат между объектами
        new Float:diffX = objX - refX;
        new Float:diffY = objY - refY;
        new Float:diffZ = objZ - refZ;
        
        // Вычисляем новые координаты текущего объекта с учетом углов поворота первого объекта
        new Float:newX = diffX * cos(refRZ * M_PI / 180.0) - diffY * sin(refRZ * M_PI / 180.0);
        new Float:newY = diffX * sin(refRZ * M_PI / 180.0) + diffY * cos(refRZ * M_PI / 180.0);
        new Float:newZ = diffZ;
        
        // Вычисляем новые углы текущего объекта относительно углов первого объекта
        new Float:newRX = objRX - refRX;
        new Float:newRY = objRY - refRY;
        new Float:newRZ = objRZ - refRZ;
        
        // Выводим результаты
		SetDynamicObjectPos(BusStationInfo[f][bsObject][i], newX, newY, newZ);
	    SetDynamicObjectRot(BusStationInfo[f][bsObject][i], newRX, newRY, newRZ);

        printf("Объект %d: Новые координаты - %f, %f, %f", i, newX, newY, newZ);
        printf("Объект %d: Новые углы - %f, %f, %f", i, newRX, newRY, newRZ);
    }
}*/

stock busstationcreate(f)
{
	// Объект остановка
	BusStationInfo[f][bsObject][0] = CreateDynamicObject(1257, BusStationInfo[f][bsCordX], BusStationInfo[f][bsCordY], BusStationInfo[f][bsCordZ], BusStationInfo[f][bsCordRX], BusStationInfo[f][bsCordRY], BusStationInfo[f][bsCordRZ]);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][0], 0, 4552, "ammu_lan2", "sunsetammu2", 0x00000000);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][0], 1, 18065, "ab_sfammumain", "shelf_glas", 0x00000000);
	BusStationInfo[f][bsObject][1] = CreateDynamicObject(18762, BusStationInfo[f][bsCordX]-5.3733, BusStationInfo[f][bsCordY]-1.0489, BusStationInfo[f][bsCordZ]-1.7713, 89.999992, BusStationInfo[f][bsCordRZ], BusStationInfo[f][bsCordRZ], 0, 0, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][1], 0, 17079, "cuntwland", "ws_freeway4", 0x00000000);
	BusStationInfo[f][bsObject][2] = CreateDynamicObject(18762, BusStationInfo[f][bsCordX]+5.3628, BusStationInfo[f][bsCordY]-1.0489, BusStationInfo[f][bsCordZ]-1.7713, 89.999992, BusStationInfo[f][bsCordRZ]-3, BusStationInfo[f][bsCordRZ]-3, 0, 0, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][2], 0, 17079, "cuntwland", "ws_freeway4", 0x00000000);
	BusStationInfo[f][bsObject][3] = CreateDynamicObject(19483, BusStationInfo[f][bsCordX]-4.117187, BusStationInfo[f][bsCordY]-0.664596, BusStationInfo[f][bsCordZ]-1.2330021, 0.000001, -90.000000, 179.900238, 0, 0, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(BusStationInfo[f][bsObject][3], 0, "Автобусная\nОстановка", 130, "Century Gothic", 95, 1, 0xFFFFFFFF, 0x00000000, 2);
	BusStationInfo[f][bsObject][4] = CreateDynamicObject(19482, BusStationInfo[f][bsCordX]-0.131, BusStationInfo[f][bsCordY]-0.0489, BusStationInfo[f][bsCordZ]-1.7713, 89.999992, BusStationInfo[f][bsCordRZ]-3, BusStationInfo[f][bsCordRZ]-3);
	SetDynamicObjectMaterialText(BusStationInfo[f][bsObject][4], 0, "с", 130, "Wingdings", 120, 1, 0xFFFFFFFF, 0x00000000, 1);
	BusStationInfo[f][bsObject][5] = CreateDynamicObject(19447, -2683.911865, -218.537658, 3.310067, 0.000000, 89.999984, -90.099983, 0, 0, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][5], 0, 16640, "a51", "plaintarmac1", 0x00000000);
	BusStationInfo[f][bsObject][6] = CreateDynamicObject(19447, -2683.909423, -217.026748, 3.302062, 0.000000, 89.999984, -90.099983, 0, 0, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(BusStationInfo[f][bsObject][6], 0, 16640, "a51", "plaintarmac1", 0x00000000);
}
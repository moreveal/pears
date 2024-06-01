#define MAX_APPLICATION_THEFT 100
#define MAX_CRIME 100

enum crimeenumInfo
{
    crmID, // newid в базе данных
	crmStatus, // 0 - угон тс, 1 - ограбления дома.
    crmType, // 0 - Неизвестно, 1- данные о персонаже известны
    crmStatusCrime, // В каком процессе дело
    crmSenderID, // Преступник
    crmSenderName[24], //
    crmTargetID, // Над кем наругались
    crmTargetName[24], //
    crmTargetZalupa, // Номер кара в БД, Номер ДОМА
    crmTargetZalupaParam,
    crmSklad,
    crmUnix // Время преступления
};
new crimeInfo[MAX_CRIME][crimeenumInfo];

new crimeStatusName[][] =
{
    "Угон т/с", "Ограбление Дома"
};

forward LoadCrime(); // Загрузка из базы
public LoadCrime()
{
	new time = GetTickCount();
	for(new f; f < MAX_CRIME; ++f)
	{
    	cache_get_value_name_int(f, "newid", crimeInfo[f][crmID]);
    	cache_get_value_name_int(f, "Status", crimeInfo[f][crmStatus]);
        cache_get_value_name_int(f, "Type", crimeInfo[f][crmType]);
    	cache_get_value_name_int(f, "SenderID", crimeInfo[f][crmSenderID]);
        cache_get_value_name(f, "SenderName", crimeInfo[f][crmSenderName], 24);
        cache_get_value_name_int(f, "TargetID", crimeInfo[f][crmTargetID]);
        cache_get_value_name(f, "TargetName", crimeInfo[f][crmTargetName], 24);
        cache_get_value_name_int(f, "TargetZalupa", crimeInfo[f][crmTargetZalupa]);
        cache_get_value_name_int(f, "TargetZalupaParam", crimeInfo[f][crmTargetZalupaParam]);
        cache_get_value_name_int(f, "Sklad", crimeInfo[f][crmSklad]);
        cache_get_value_name_int(f, "Unix", crimeInfo[f][crmUnix]);
	}
	printf("[MODE]: Преступления [%d ms]", GetTickCount() - time);
	return 1;
}

stock FindCarInWareHouse(playerid)
{
    ClearAnimations(playerid);
    ApplyAnimation(playerid,"PED","flee_lkaround_01",4.0, false, false, false, false, false, SYNC_ALL);
    new world = GetPlayerVirtualWorld(playerid)-80, i =-1;
    new g = fraction(playerid);
    if(PlayerInfo[playerid][pTheft] != -1) i = PlayerInfo[playerid][pTheft];
    if(i == -1) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы осмотрели склад.\nВ нем было несколько подозрительных машин, но вы не взяли заявку на угон.\n\nВозьмите заявку и повторите проверку","*","");
    if(crimeInfo[i][crmSklad] == world)
    {   
        new string[120];
        mysql_format(pearsq, string,sizeof(string),"UPDATE `pp_cars` SET `Sklad` = '-1' WHERE `newid` = '%d'",crimeInfo[i][crmTargetZalupa]);
        query_empty(pearsq, string);
        crimeInfo[i][crmSenderID] = 0;
        SuccessMessage(playerid,"{99ff66}Вы нашли угнанную машину\n{ffcc66}Можно взять новое дело и проверить этот же склад на другой транспорт");
        format(string, sizeof(string), "Угнанный %s был найден полицей",GetVehicleName(crimeInfo[i][crmTargetZalupaParam]));
        notify(0, "",crimeInfo[i][crmTargetID], crimeInfo[i][crmTargetName], string);
        OrganInfo[g][glave] += 5000;

        GiveUnit(playerid, 12);
        PlayerInfo[playerid][pTheft] = -1;
        crimeInfo[i][crmSklad] = -1;
        SaveCrime(i);
    }
    else return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы осмотрели склад.\nНа этом складе нет нужного транспорта. Поищите на других складах","*","");
    return 1;
}

stock ListCrime(playerid)
{
    new line[120],lines[4048];
	format(line,sizeof(line),"{cccccc}№.Тип\tПреступник\tПостродавший[Дата]\tСтатус"), strcat(lines,line);
    new quan;
    new tyear, tmonth, tday, thour, tminute, tsecond;
    format(line,sizeof(line),"\n{ff6347}Отказаться от заявки\t\t\t"), strcat(lines,line);
	for(new i = 0; i < MAX_CRIME; i++)
	{
		List[i][playerid] = 0; // Очищаем листы
        if(crimeInfo[i][crmSenderID] == 0) continue;
        stamp2datetime(crimeInfo[i][crmUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
        if(crimeInfo[i][crmType] == 0)
        {   
            if(crimeInfo[i][crmStatusCrime] == 0) format(line,sizeof(line),"\n{cccccc}№ %d.%s\tНеизвестен\t%s[ %02d.%02d.%d %02d:%02d ]\t{FF6347}Не принят", i + 1,crimeStatusName[crimeInfo[i][crmStatus]],crimeInfo[i][crmTargetName],tday, tmonth, tyear, thour, tminute), strcat(lines,line);
            else format(line,sizeof(line),"\n{cccccc}№ %d.%s\tНеизвестен\t%s[ %02d.%02d.%d %02d:%02d ]\t{99ff66}Принят", i + 1,crimeStatusName[crimeInfo[i][crmStatus]],crimeInfo[i][crmTargetName],tday, tmonth, tyear, thour, tminute), strcat(lines,line);
        }
        else if(crimeInfo[i][crmType] == 1)
        {
            if(crimeInfo[i][crmStatusCrime] == 0) format(line,sizeof(line),"\n{cccccc}№ %d.%s\t%s\t%s[ %02d.%02d.%d %02d:%02d ]\t{FF6347}Не принят", i + 1,crimeStatusName[crimeInfo[i][crmStatus]],crimeInfo[i][crmSenderName],crimeInfo[i][crmTargetName],tday, tmonth, tyear, thour, tminute), strcat(lines,line);
            else format(line,sizeof(line),"\n{cccccc}№ %d.%s\t%s\t%s[ %02d.%02d.%d %02d:%02d ]\t{99ff66}Принят", i + 1,crimeStatusName[crimeInfo[i][crmStatus]],crimeInfo[i][crmSenderName],crimeInfo[i][crmTargetName],tday, tmonth, tyear, thour, tminute), strcat(lines,line);
        }
        List[quan][playerid] = i;
        quan ++;
	}
    if(quan == 0) return ErrorMessage(playerid, "{FF6347}Нет никаких совершенных преступлений");
    ShowDialog(playerid,1351,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список Преступлений",lines,"Выбрать","Отмена");
    return 1;
}

stock IsPlayerRangeOfCamer(playerid)
{
    if(IsHideEbalo(playerid)) return 0;
    new Float:pos[3];
    for(new i; i < 100; i++)
    {
        if(CamInfo[i][cStat] > 0)
        {
		    GetDynamicObjectPos(CamInfo[i][cObject], pos[0], pos[1], pos[2]);
            if(IsPlayerInRangeOfPoint(playerid,100.0,pos[0], pos[1], pos[2])) return 1;
        }
    }
    return 0;
}

stock IsHideEbalo(playerid)
{
    for(new i; i < 5; i++)
    {
        if(IsAOpenEbalo(PlayerInfo[playerid][pOdet][i]))
        {
            return 1;
        }
    }
    return 0;
}

stock InputCarToRent(playerid,wh,car)
{
    if(Cars[car] != 88) return ErrorMessage(playerid, "{FF6347}На склад можно поместить только угнанный личный т/c");
	if(WhInfo[wh][wStat] <= 0) return ErrorMessage(playerid, "{FF6347}Этот склад никем не арендован");
	new string[144], g = fraction(playerid);
	if(WhInfo[wh][wStat] != g) return format(string, sizeof(string), "{FF6347}Этот склад принадлежит %s", frakName[WhInfo[wh][wStat]]), ErrorMessage(playerid, string);
	if(VehInfo[car][vSost] == PlayerInfo[playerid][pID]) return ErrorMessage(playerid, "Это мой личный транспорт\nЯ не могу его поместить на склад");
    
	PlayerPlaySound(playerid,40405,0,0,0);
	new slot = -1;
	for (new i; i < MAX_CRIME; i++)
	{
		if(crimeInfo[i][crmSenderID] == 0)
		{
			slot = i;
			break;
		}
	}
	if(slot == -1) return ErrorMessage(playerid, "{FF6347} Не найден свободный слот преступления. Сообщите администрации!");
    if(GetPVarInt(playerid,"stopload") >= 1) return 1;
    SetPVarInt(playerid,"stopload",1);
	mysql_format(pearsq, string, sizeof(string), "SELECT Name FROM `pp_igroki` WHERE `user_id` = '%d'", VehInfo[car][vSost]);
	mysql_tquery(pearsq, string, "CrimeCar", "ddddd", playerid,wh,car,slot, g_MysqlRaceCheck[playerid]);
	return 1;
}

function CrimeCar(playerid,wh,car,slot,zalupa)
{
	if(g_MysqlRaceCheck[playerid] != zalupa) return Kickx(playerid);
	new rows,tempname[24];
	cache_get_row_count(rows);
	if(!rows)
	{
		ErrorMessage(playerid, "{FF6347}Ошибка! Владелец транспорта не найден\n\n{cccccc}Обратитесь к администрации [ /report ]");
		return 0;
	}
    new g = fraction(playerid);
    new string[40];
	cache_get_value_name(0, "Name", tempname, 24);
	format(crimeInfo[slot][crmTargetName], 24, "%s", tempname); // Записываем имя чела
    format(crimeInfo[slot][crmSenderName], 24, "%s", PlayerInfo[playerid][pName]); // Записываем имя чела
	crimeInfo[slot][crmStatus] = 0; 
    crimeInfo[slot][crmType] = PlayerInfo[playerid][pFixCamera];
    crimeInfo[slot][crmStatusCrime] = 0;
    crimeInfo[slot][crmSenderID] = PlayerInfo[playerid][pID];
    crimeInfo[slot][crmTargetID] = VehInfo[car][vSost];
    crimeInfo[slot][crmTargetZalupa] = VehInfo[car][vNewid];
    crimeInfo[slot][crmTargetZalupaParam] = VehInfo[car][vModel];
    crimeInfo[slot][crmSklad] = wh+1;
    crimeInfo[slot][crmUnix] = gettime();
	VehInfo[car][vSklad] = wh+1;
    OrganInfo[g][glave] += 5000;
    format(string,sizeof(string), "Фрак: %d, Склад: %d", fraction(playerid), wh);
    GiveUnit(playerid, 11);
    CarLog("inwh", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], VehInfo[car][vModel], wh, string);
	SaveCar(car);
    SaveCrime(slot);
	ACDestroyVehicle(car);
    SetPVarInt(playerid,"stopload",0);
	return 1;
}

stock SaveCrime(slot)
{
    new string_mysql[500];
    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_Crime` SET `Status`='%d',`Type`='%d',`SenderID`='%d',`SenderName`='%e',\
    `TargetID`='%d',`TargetName`='%e',`TargetZalupa`='%d',`TargetZalupaParam`='%d',`Sklad`='%d',`Unix`='%d' WHERE `newid`='%d'",
    crimeInfo[slot][crmStatus],crimeInfo[slot][crmType],crimeInfo[slot][crmSenderID],crimeInfo[slot][crmSenderName],crimeInfo[slot][crmTargetID],
    crimeInfo[slot][crmTargetName],crimeInfo[slot][crmTargetZalupa],crimeInfo[slot][crmTargetZalupaParam],crimeInfo[slot][crmSklad],crimeInfo[slot][crmUnix],
    crimeInfo[slot][crmID]);
    query_empty(pearsq, string_mysql); // 205 + 99 + 24 + 24 (352)
	return 1;
}
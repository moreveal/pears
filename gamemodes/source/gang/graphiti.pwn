
#define GRAFFITY_PRECENT 20 // Сколько процентов даёт или отнимает каждое граффити

enum graphitiEnum
{
    graphitiID,
    Float:graphitiPos[6], // Координаты
    graphitiUnix, // Время создания граффити
    graphitiPlayer, // номер акка игрока
    graphitiOrg, // номер организации
    graphitiStatus, // Статус 0 - не установлена, 1 установлена
    graphitiZone, // Зона где граффити
    graphitiName[24], // Никнейм игрока.
}
new GraphitiInfo[GZONES][graphitiEnum];
new GraphitiPos[6][8];
new GraphitiObject[GZONES];
new GraphitiPickUp[GZONES];
new Text3D: GraphitiLabel[GZONES];
new QuanGraffity;

forward LoadGraphiti(); // Загрузка из базы
public LoadGraphiti()
{
	new time = GetTickCount();
	new rows;
    new stroca[48];
	cache_get_row_count(rows);
	for(new f; f<rows; ++f)
	{
    	cache_get_value_name_int(f, "gnewid", GraphitiInfo[f][graphitiID]);
    	cache_get_value_name_int(f, "gunix", GraphitiInfo[f][graphitiUnix]);
		cache_get_value_name_int(f, "gplayernumber", GraphitiInfo[f][graphitiPlayer]);
        cache_get_value_name_int(f, "gorg", GraphitiInfo[f][graphitiOrg]);
        cache_get_value_name_int(f, "gStatus", GraphitiInfo[f][graphitiStatus]);
        if(GraphitiInfo[f][graphitiStatus] == 1)
        {
            cache_get_value_name(f, "gstring", stroca, 48);
            cache_get_value_name(f, "gName", GraphitiInfo[f][graphitiName], 24);
            split(stroca,GraphitiPos,'_');
            for(new i;i<6;i++)
            {
                GraphitiInfo[f][graphitiPos][i] = floatstr(GraphitiPos[i]);
            }
            format(stroca,sizeof(stroca),""); // Очищаем stroca
            GraphitiUpdateElement(f);
            QuanGraffity ++;
        }
	}
	printf("[MODE]: Граффити [%d Quan][%d ms]",rows,GetTickCount() - time);
	return 1;
}

stock ShowAllGraphiti(playerid)
{
	new line[100],lines[4096];
	new tyear, tmonth, tday, thour, tminute, tsecond, quan,g;
	format(line,sizeof(line),"№ Банда\tСоздал\tВремя редактирования/создания"), strcat(lines,line);
	for(new i = 0; i < GZONES; i++)
	{
		List[i][playerid] = 0;
		stamp2datetime(GraphitiInfo[i][graphitiUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
		if(GraphitiInfo[i][graphitiStatus] != 0)
		{
            g = GraphitiInfo[i][graphitiOrg];
            format(line,sizeof(line),"\n%d. %s\t{cccccc}%s\t{cccccc}[ %02d.%02d.%d %02d:%02d ]", i+1,fraklastName[g], GraphitiInfo[i][graphitiName],tday, tmonth, tyear, thour, tminute), strcat(lines,line);
		}
		else
		{
			format(line,sizeof(line),"\n%d. Пусто\t\t", i+1), strcat(lines,line);
        }
        List[quan][playerid] = i;
		quan++;
	}
    ShowDialog(playerid,1476,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список Граффити",lines,"Выбрать","Выход");
	return 1;
}

stock CreateGraphiti(playerid)
{
    if(gRedakt[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Ваш персонаж уже наносит граффити или редактирует какой-то объект");
    if(get_invent4(playerid, 197, 0) <= 0) return ErrorMessage(playerid, "{FF6347}Вам нужен баллончик с краской\n{cccccc}Вы можете приобрести его в любом супермаркете");
    if(Hold[playerid] != 197) return ErrorMessage(playerid, "{FF6347}Возьмите в руки баллончик с краской\n{cccccc}Откройте инвентарь и нажмите на него два раза");

    new g = fraction(playerid);
    new objectid;
    if(g == 13) objectid = 1528; // grove
    else if(g == 14) objectid = 1529; // ballas
    else if(g == 15) objectid = 1530; // vagos
    else objectid = 1531; // aztec
    new Float:f_pos[4];
    frontme(playerid, 1.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
    CreateEditPlayerObject(playerid, 27, 0, 0, 0, objectid, f_pos[0], f_pos[1], f_pos[2], 0.0, 0.0, f_pos[3] + 90.0);
    return 1;
}

stock GraphitiUpdateElement(graphiti)
{
    new g = GraphitiInfo[graphiti][graphitiOrg],text[16],objectid;
    if(g == 13) text = "{00cc00}Grove",objectid = 1528; // grove
    else if(g == 14) text = "{9900cc}Ballas",objectid = 1529; // ballas
    else if(g == 15) text = "{ffcc33}Vagos",objectid = 1530; // vagos
    else text = "{00ffff}Aztecas",objectid = 1531; // aztec
    new Float:x,Float:y,Float:z;
    GraphitiObject[graphiti] = CreateDynamicObject(objectid, GraphitiInfo[graphiti][graphitiPos][0],GraphitiInfo[graphiti][graphitiPos][1],GraphitiInfo[graphiti][graphitiPos][2],GraphitiInfo[graphiti][graphitiPos][3],GraphitiInfo[graphiti][graphitiPos][4],GraphitiInfo[graphiti][graphitiPos][5],0,0);
    backtobject(GraphitiObject[graphiti],1.0,x,y,z,GraphitiInfo[graphiti][graphitiPos][5]);
    GraphitiPickUp[graphiti] = CreateDynamicPickup(365,1,x,y,z,0,0);

    new string[100];
    format(string,sizeof(string),"{cccccc}Граффити\n%s\n\n{ff9000}[ Баллончик или Канистра в руках + ALT ]",text);
    GraphitiLabel[graphiti] = CreateDynamic3DTextLabel(string,0xA9C4E4FF,GraphitiInfo[graphiti][graphitiPos][0], GraphitiInfo[graphiti][graphitiPos][1], GraphitiInfo[graphiti][graphitiPos][2],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
    return 1;
}

stock GetZone(playerid) // Получение территории в гетто
{
    new yesGhetto = -1;
	for(new g = 0; g < GZONES; g++)
	{
		if(IsPlayerInSquare(playerid,GangZone[g][gzMinX],GangZone[g][gzMinY],GangZone[g][gzMaxX],GangZone[g][gzMaxY]))
        {
            yesGhetto = g;
            break;
        }
	}
    return yesGhetto;
}

stock GetZoneXYZ(Float:x,Float:y) // Получение территории в гетто
{
    new yesGhetto = -1;
	for(new g = 0; g < GZONES; g++)
	{
		if(IsPosInSquare(x,y,GangZone[g][gzMinX],GangZone[g][gzMinY],GangZone[g][gzMaxX],GangZone[g][gzMaxY]))
        {
            yesGhetto = g;
            break;
        }
	}
    return yesGhetto;
}


stock SaveGraphiti(slot)
{
    new part[150];
    format(part,sizeof(part),"%.2f_%.2f_%.2f_%.2f_%.2f_%.2f",GraphitiInfo[slot][graphitiPos][0],GraphitiInfo[slot][graphitiPos][1], 
    GraphitiInfo[slot][graphitiPos][2],GraphitiInfo[slot][graphitiPos][3],GraphitiInfo[slot][graphitiPos][4], GraphitiInfo[slot][graphitiPos][5]); // 30 + 120

    new string_mysql[600];
    format(string_mysql, sizeof(string_mysql), "UPDATE `pp_graphiti` SET `gstring`='%s',`gunix`='%d',`gplayernumber`='%d',`gZone`='%d',`gStatus`='%d',`gorg`='%d',`gName`='%s' WHERE `gnewid`='%d'",
    part,GraphitiInfo[slot][graphitiUnix],GraphitiInfo[slot][graphitiPlayer],GraphitiInfo[slot][graphitiZone],GraphitiInfo[slot][graphitiStatus],GraphitiInfo[slot][graphitiOrg],GraphitiInfo[slot][graphitiName],GraphitiInfo[slot][graphitiID]);
    query_empty(pearsq, string_mysql); // 147 + 66 + 24 (237) + 150
}

CMD:spray(playerid)
{
	if(get_invent4(playerid, 197, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет балончика с краской\n{cccccc}Его можно купить в любом супермаркете");
    if(Hold[playerid] == 197)
    {
   		RemovePlayerAttachedObject(playerid,1), Hold[playerid] = 0;
    	if(NoAnim[playerid] == 0) ApplyAnimation(playerid,"PED","phone_out",4.0,0,1,1,0,0);
  		SetPlayerChatBubble(playerid,"убирает балончик",COLOR_PURPLE,30.0,8000); 
        PlayerPlaySound(playerid,5601,0,0,0);
	}
	else
	{
		if(Hold[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вашего персонажа заняты руки");
  		RemovePlayerAttachedObject(playerid,1);
  		Hold[playerid] = 197;
  		SetPlayerAttachedObject(playerid, 1, 365, 6, 0.098999, 0.039999, 0.000000, 85.700012, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
  		SetPlayerChatBubble(playerid,"достаёт балончик",COLOR_PURPLE,30.0,8000);
        PlayerPlaySound(playerid,5600,0,0,0);
    }
	return 1;
}

stock clearspray(playerid, zone)
{
    if(get_invent4(playerid, 9, 0) <= 0) return ErrorMessage(playerid, "{FF6347}Вам нужна канистра с бензином\n{cccccc}Отправляйтесь на ближайшую заправку и приобретите канистру");
    if(Dei[playerid] != 8) return ErrorMessage(playerid, "{FF6347}Возьмите в руки канистру с бензином\n{cccccc}Откройте инвентарь и нажмите на канистру два раза");

    DestroyDynamicObject(GraphitiObject[zone]);
    DestroyDynamicPickup(GraphitiPickUp[zone]);
    DestroyDynamic3DTextLabel(GraphitiLabel[zone]);
    GraphitiInfo[zone][graphitiPos][0] = 0.0, GraphitiInfo[zone][graphitiPos][1] = 0.0, GraphitiInfo[zone][graphitiPos][2] = 0.0;
    GraphitiInfo[zone][graphitiPos][3] = 0.0, GraphitiInfo[zone][graphitiPos][4] = 0.0, GraphitiInfo[zone][graphitiPos][5] = 0.0;
    GraphitiInfo[zone][graphitiOrg] = fraction(playerid);
    GraphitiInfo[zone][graphitiUnix] = gettime();
    GraphitiInfo[zone][graphitiStatus] = 0;
    GraphitiInfo[zone][graphitiZone] = zone;
    GraphitiInfo[zone][graphitiPlayer] = PlayerInfo[playerid][pID];
    TakeInvent(playerid, 9, 1, 0, 999); // Отнимаем 1 литр из канистры
    if(NoAnim[playerid] == 0) ApplyAnimation(playerid,"SPRAYCAN","spraycan_full",3.0,0,1,1,0,0);
    PlayerPlaySound(playerid,20802,0,0,0);
    SuccessMessage(playerid,"{99ff66}Вы стёрли граффити");
    SaveGraphiti(zone);
    QuanGraffity --;
    return 1;
}

stock MenuGraffity(playerid, zone)
{
    DP[0][playerid] = zone;
    new tyear, tmonth, tday, thour, tminute, tsecond;
    stamp2datetime(GraphitiInfo[zone][graphitiUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);

    new line[100],lines[300];
    format(line,sizeof(line),"%s {cccccc}| %s | {666666}%02d.%02d.%d %02d:%02d\t", frakName[GraphitiInfo[zone][graphitiOrg]], GraphitiInfo[zone][graphitiName], tday, tmonth, tyear, thour, tminute), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Перекрасить {ff9000}>>\t{666666}Баллончик в руке"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Стереть {ff6347}>>\t{666666}Канистра в руке"), strcat(lines,line);
    ShowDialog(playerid,1399,DIALOG_STYLE_TABLIST_HEADERS,"Граффити",lines,"Выбрать","Выход");
    return 1;
}

stock gospray(playerid)
{
    new g = fraction(playerid);
    if(g != 13 && g != 14 && g != 15 && g != 16) return ErrorMessage(playerid,"{ff6347}Стереть или нанести граффити могут только участники банды");
    if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0) return ErrorMessage(playerid,"{ff6347}Вы не можете стереть или нанести граффити в помещении");

    new zone = GetZone(playerid);
    if(zone == -1) return ErrorMessage(playerid,"{ff6347}Нанести или стереть граффити можно только на территории капта\n{cccccc}Примечение: на респах банд квадрат капта намеренно отсутствует");

    if(GraphitiInfo[zone][graphitiStatus] == 1)
    {
        if(IsPlayerInRangeOfPoint(playerid,2.0,GraphitiInfo[zone][graphitiPos][0],GraphitiInfo[zone][graphitiPos][1],GraphitiInfo[zone][graphitiPos][2]))
        {
            PlayerPlaySound(playerid,40405,0,0,0);
            MenuGraffity(playerid, zone);
        }
        else
        {
            if(GraphitiInfo[zone][graphitiOrg] == g) ErrorMessage(playerid,"{ff6347}В этом квадрате нанесено граффити вашей банды");
            else ErrorMessage(playerid,"{ff6347}В этом квадрате нанесено граффити чужой банды\n{cccccc}Вы можете найти граффити, стереть его или перекрасить");
        }
        return 1;
    }
    CreateGraphiti(playerid);
    return 1;
}

CMD:sprays(playerid)
{
    if(PlayerInfo[playerid][pSoska] <= 0) return ErrorMessage(playerid,"{ff6347}Вы не можете использовать эту команду");
    ShowAllGraphiti(playerid);
    return 1;
}

CMD:cleargraffity(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid,"{ff6347}Вы не можете использовать эту команду");
    ShowDialog(playerid,1394,DIALOG_STYLE_MSGBOX,"Граффити","{cccccc}Вы уверены, что хотите {ff6347}стереть все граффити","Да","Нет");
    return 1;
}

stock ClearAllGraffity(playerid)
{
    if(QuanGraffity <= 0) return ErrorMessage(playerid,"{ff6347}На сервере нет ни одного граффити");

    // Начало транзакции
	mysql_query(pearsq, "START TRANSACTION;");

    new quan;
    for(new g = 0; g < GZONES; g++)
	{
        if(GraphitiInfo[g][graphitiStatus] == 1)
        {
            DestroyDynamicObject(GraphitiObject[g]);
            DestroyDynamicPickup(GraphitiPickUp[g]);
            DestroyDynamic3DTextLabel(GraphitiLabel[g]);
            GraphitiInfo[g][graphitiStatus] = 0;
            GraphitiInfo[g][graphitiOrg] = 0;
            GraphitiInfo[g][graphitiUnix] = 0;
            GraphitiInfo[g][graphitiStatus] = 0;
            GraphitiInfo[g][graphitiZone] = 0;
            GraphitiInfo[g][graphitiPlayer] = 0;
            SaveGraphiti(g);
            quan ++;
        }
    }

    new string[80];
    format(string, sizeof(string), " [ ADM ]: %s удалил все граффити (%d штук)",PlayerInfo[playerid][pName], quan);
	ABroadCast(COLOR_ADM,string,1);

    // Завершение транзакции
	mysql_query(pearsq, "COMMIT;");

    AdminLog("cleargraffity", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Удалил все граффити");
    return 1;
}

stock dialogCase_Graphiti(playerid, dialogid, response, listitem)
{
    if(dialogid == 1394)
    {
        if(response) ClearAllGraffity(playerid);
    }
    else if(dialogid == 1399)
    {
        if(response)
        {
            new zone = DP[0][playerid];
            if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return ErrorMessage(playerid,"{ff6347}Вы находитесь в интерьере или помещении");
            if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return ErrorMessage(playerid, "{FF6347}Только пешком рядом с граффити");
            if(GraphitiInfo[zone][graphitiStatus] == 0) return ErrorMessage(playerid,"{ff6347}Ошибка! Граффити куда-то пропало.. Возможно его кто-то стёр");
            if(!IsPlayerInRangeOfPoint(playerid,2.0,GraphitiInfo[zone][graphitiPos][0],GraphitiInfo[zone][graphitiPos][1],GraphitiInfo[zone][graphitiPos][2])) return ErrorMessage(playerid, "{FF6347}Вы далеко отошли от граффити");
            if(GraphitiInfo[zone][graphitiUnix]+1800>gettime())
            {
                new string[120];
                format(string,sizeof(string), "{ff6347}Граффити было создано недавно\n{cccccc}Можно стереть или перекрасить через %s", fine_time(GraphitiInfo[zone][graphitiUnix]+1800 - gettime()));
                ErrorMessage(playerid,string);
                return 1;
            }
            if(howstun(playerid) || HealthAC[playerid] <= 0) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");

            if(listitem == 0) CreateGraphiti(playerid); // Перекрасить
            if(listitem == 1) clearspray(playerid, zone); // Стереть
        }
    }
    else if(dialogid == 1476)
    {
        if(response)
        {
            if(PlayerInfo[playerid][pSoska] == 0) return ShowAllGraphiti(playerid);
            if(listitem < 0 || listitem > GZONES) return ErrorMessage(playerid,"Лист итем паленый броооооо");
            {
                new listord = List[listitem][playerid];
                DP[0][playerid] = listord;
                if(GraphitiInfo[listord][graphitiStatus] == 0) return ErrorMessage(playerid,"{ff6347}Данное граффити еще не размещено!");
                if(GraphitiInfo[listord][graphitiStatus] != 0)
                {
                    new tyear, tmonth, tday, thour, tminute, tsecond;
		            stamp2datetime(GraphitiInfo[listord][graphitiUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
                    new g = GraphitiInfo[listord][graphitiOrg];

                    new string[100];
                    format(string,sizeof(string),"%d. %s\nБанда: %s\nДата создания: %02d.%02d.%d %02d:%02d", listord+1,GraphitiInfo[listord][graphitiName],fraklastName[g],tday, tmonth, tyear, thour, tminute);
                    ShowDialog(playerid,1477,DIALOG_STYLE_MSGBOX,"{ff9000}Граффити",string,"Тп","Назад");
                }
            }
        }
    }
    else if(dialogid == 1477)
    {
        if(response)
        {
            new listord = DP[0][playerid];
            if(GraphitiInfo[listord][graphitiStatus] == 0) return ErrorMessage(playerid,"{ff6347}Ошибка! Граффити удалено");
            S_SetPlayerVirtualWorld(playerid, 0, 0);
            SetPlayerInterior(playerid, 0);
            PPSetPlayerPos(playerid, GraphitiInfo[listord][graphitiPos][0],GraphitiInfo[listord][graphitiPos][1],GraphitiInfo[listord][graphitiPos][2]+3);
        }
        else ShowAllGraphiti(playerid);
    }
    return 1;
}

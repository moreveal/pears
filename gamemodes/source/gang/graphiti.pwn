enum graphitiEnum
{
    graphitiID,
    Float:graphitiPos[6], // Координаты
    graphitiUnix, // Время создания граффити
    graphitiPlayer, // номер акка игрока
    graphitiOrg, // номер организации
    graphitiStatus, // Статус 0 - не установлена, 1 установлена
    graphitiZone, // Зона где граффити
}
new GraphitiInfo[GZONES][graphitiEnum];
new GraphitiPos[6][8];
new GraphitiObject[GZONES];
new GraphitiPickUp[GZONES];
new Text3D: GraphitiLabel[GZONES];

forward LoadGraphiti(); // Загрузка из базы
public LoadGraphiti()
{
	new time = GetTickCount();
	new rows;
    new stroca[48];
	cache_get_row_count(rows);
	for(new f; f<rows; ++f)
	{
    	cache_get_value_name_int(f, "newid", GraphitiInfo[f][graphitiID]);
    	cache_get_value_name_int(f, "gunix", GraphitiInfo[f][graphitiUnix]);
		cache_get_value_name_int(f, "gplayernumber", GraphitiInfo[f][graphitiPlayer]);
        cache_get_value_name_int(f, "gorg", GraphitiInfo[f][graphitiOrg]);
        cache_get_value_name_int(f, "gStatus", GraphitiInfo[f][graphitiStatus]);
        cache_get_value_name(f, "gstring", stroca, 48);
        split(stroca,GraphitiPos,'_');
        for(new i;i<6;i++)
        {
            GraphitiInfo[f][graphitiPos][i] = floatstr(GraphitiPos[i]);
        }
        format(stroca,sizeof(stroca),""); // Очищаем stroca
        GraphitiUpdateElement(f);
	}
	printf("[MODE]: Граффити [%d Quan][%d ms]",rows,GetTickCount() - time);
	return 1;
}

stock ShowAllGraphiti(playerid)
{
	format(lines,sizeof(lines),""); // Очищаем Lines
	new tyear, tmonth, tday, thour, tminute, tsecond, quan,g;
	format(line,sizeof(line),"№Банда\tВремя редактирования/создания"), strcat(lines,line);
	for(new i = 0; i < GZONES; i++) 
	{
		List[i][playerid] = 0;
		stamp2datetime(GraphitiInfo[i][graphitiUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
		if(GraphitiInfo[i][graphitiStatus] != 0)
		{
            g = GraphitiInfo[i][graphitiOrg];
            format(line,sizeof(line),"\n%d.%s\t{cccccc}[ %02d.%02d.%d %02d:%02d ]", i+1,fraklastName[g],tyear, tmonth, tday, thour, tminute, tsecond), strcat(lines,line);
		}
		else
		{
			format(line,sizeof(line),"\n%d.Пусто\t ", i+1), strcat(lines,line);
        }
        List[quan][playerid] = i;
		quan++;
	}
    ShowDialog(playerid,1476,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список Графити",lines,"Выбрать","Выход");
	return 1;
}

stock CreateGraphiti(playerid)
{
    new g = fraction(playerid),slot = -1,slotreset = -1;
    if(g != 13 && g != 14 && g != 15 && g !=16) return ErrorMessage(playerid,"{ff6347}Вы не участник банды");
    if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return ErrorMessage(playerid,"{ff6347}Граффити можно наносить только на улице");
    for(new i; i<GZONES;i++)
    {
        if(IsPlayerInRangeOfPoint(playerid,5.0,GraphitiInfo[i][graphitiPos][0],GraphitiInfo[i][graphitiPos][1],GraphitiInfo[i][graphitiPos][2]) && GetZoneXYZ(GraphitiInfo[i][graphitiPos][0],GraphitiInfo[i][graphitiPos][1]) == GraphitiInfo[i][graphitiZone])
        {
            slotreset = i;
            break;
        }
        if(GraphitiInfo[i][graphitiStatus] != 0) continue;
        slot = i;
        break;
    }
    if(slot == -1 && slotreset == -1) return ErrorMessage(playerid,"{ff6347}Нет свободных слотов для граффити. Найдите графити в этом квадрате и закрасте его или смойте бензином");
    else if(slot == -1 && slotreset != -1)
    {
        DP[0][playerid] = slotreset;
        DP[1][playerid] = slotreset;
        if(GraphitiInfo[slotreset][graphitiUnix]+1800 > gettime()) return ErrorMessage(playerid,"{ff6347}Граффити недавно было создано, перекрасить его нельзя");
    }
    else if(slot != -1 && slotreset == -1)
    {
        DP[0][playerid] = slot;
    }
    new objectid;
    if(g == 13) objectid = 1528; // grove
    else if(g == 14) objectid = 1529; // ballas
    else if(g == 15) objectid = 1530; // vagos
    else if(g == 16) objectid = 1531; // aztec
    new Float:f_pos[4];
    frontme(playerid, 2.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
    CreateEditPlayerObject(playerid, 27, 0, 0, 0, objectid, f_pos[0], f_pos[1], f_pos[2], 0.0, 0.0, 0.0);
    return 1;
}

stock GraphitiUpdateElement(graphiti)
{
    new g = GraphitiInfo[graphiti][graphitiOrg],text[16],objectid;
    if(g == 13) text = "{00cc00}Grove",objectid = 1528; // grove
    else if(g == 14) text = "{9900cc}Ballas",objectid = 1529; // ballas
    else if(g == 15) text = "{ffcc33}Vagos",objectid = 1530; // vagos
    else if(g == 16) text = "{00ffff}Aztecas",objectid = 1531; // aztec
    new Float:x,Float:y,Float:z;
    GraphitiObject[graphiti] = CreateDynamicObject(objectid, GraphitiInfo[graphiti][graphitiPos][0],GraphitiInfo[graphiti][graphitiPos][1],GraphitiInfo[graphiti][graphitiPos][2],GraphitiInfo[graphiti][graphitiPos][3],GraphitiInfo[graphiti][graphitiPos][4],GraphitiInfo[graphiti][graphitiPos][5],0,0);
    backtobject(GraphitiObject[graphiti],1.0,x,y,z,GraphitiInfo[graphiti][graphitiPos][5]);
    GraphitiPickUp[graphiti] = CreateDynamicPickup(365,1,x,y,z,0,0);


    format(store,sizeof(store),"{cccccc}Граффити банды\n %s\n\n{ff9000}[ Баллончик вруках + ALT ]",text);
    GraphitiLabel[graphiti] = CreateDynamic3DTextLabel(store,0xA9C4E4FF,GraphitiInfo[graphiti][graphitiPos][0], GraphitiInfo[graphiti][graphitiPos][1], GraphitiInfo[graphiti][graphitiPos][2],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
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
    format(store,sizeof(store),"%.2f_%.2f_%.2f_%.2f_%.2f_%.2f",GraphitiInfo[slot][graphitiPos][0],GraphitiInfo[slot][graphitiPos][1], GraphitiInfo[slot][graphitiPos][2],GraphitiInfo[slot][graphitiPos][3],GraphitiInfo[slot][graphitiPos][4], GraphitiInfo[slot][graphitiPos][5]);
    format(big_query, sizeof(big_query), "UPDATE `pp_graphiti` SET `gstring`='%s',`gunix`='%d',`gplayernumber`='%d',`gZone`='%d',`gStatus`='%d',`gorg`='%d' WHERE `gnewid`='%d'",
    store,GraphitiInfo[slot][graphitiUnix],GraphitiInfo[slot][graphitiPlayer],GraphitiInfo[slot][graphitiZone],GraphitiInfo[slot][graphitiStatus],GraphitiInfo[slot][graphitiOrg],slot);
    query_empty(pearsq, big_query);
}

CMD:spray(playerid)
{
	if(get_invent4(playerid, 197, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет балончика с краской");
    if(Hold[playerid] == 197)
    {
   		RemovePlayerAttachedObject(playerid,1), Hold[playerid] = 0;
    	if(NoAnim[playerid] == 0) ApplyAnimation(playerid,"PED","phone_out",4.0,0,1,1,0,0);
  		SetPlayerChatBubble(playerid,"убирает балончик",COLOR_PURPLE,30.0,8000);
	}
	else
	{
		if(Hold[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вашего персонажа заняты руки");
  		RemovePlayerAttachedObject(playerid,1);
  		Hold[playerid] = 197;
  		SetPlayerAttachedObject(playerid, 1, 365, 6, 0.098999, 0.039999, 0.000000, 85.700012, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
  		SetPlayerChatBubble(playerid,"достаёт балончик",COLOR_PURPLE,30.0,8000);
    }
	return 1;
}

stock clearspray(playerid)
{
    new slot;
    for(new i;i<GZONES;i++)
    {
        if(IsPlayerInRangeOfPoint(playerid,5.0,GraphitiInfo[i][graphitiPos][0],GraphitiInfo[i][graphitiPos][1],GraphitiInfo[i][graphitiPos][2]))
        {
            slot = i;
            break;
        }
    }
    if(GraphitiInfo[slot][graphitiUnix]+1800>gettime()) return ErrorMessage(playerid,"{ff6347}Граффити недавно было создано, стереть его нельзя");
    DestroyDynamicObject(GraphitiObject[slot]);
    DestroyDynamicPickup(GraphitiPickUp[slot]);
    DestroyDynamic3DTextLabel(GraphitiLabel[slot]);
    GraphitiInfo[slot][graphitiPos][0] = 0.0, GraphitiInfo[slot][graphitiPos][1] = 0.0, GraphitiInfo[slot][graphitiPos][2] = 0.0;
    GraphitiInfo[slot][graphitiPos][3] = 0.0, GraphitiInfo[slot][graphitiPos][4] = 0.0, GraphitiInfo[slot][graphitiPos][5] = 0.0;
    GraphitiInfo[slot][graphitiOrg] = fraction(playerid);
    GraphitiInfo[slot][graphitiUnix] = gettime();
    GraphitiInfo[slot][graphitiStatus] = 0;
    GraphitiInfo[slot][graphitiZone] = GetZone(playerid);
    GraphitiInfo[slot][graphitiPlayer] = PlayerInfo[playerid][pID];
    TakeInvent(playerid, 9, 1, 0, 999); // Отнимаем 1 литр из канистры
    if(NoAnim[playerid] == 0) ApplyAnimation(playerid,"SPRAYCAN","spraycan_full",3.0,0,1,1,0,0);
    PlayerPlaySound(playerid,20802,0,0,0);
    SaveGraphiti(slot);
    return 1;
}

CMD:gospray(playerid)
{
    if(IsAGhetto(playerid) == 0) return ErrorMessage(playerid,"{ff6347}Граффити можно размещать только в гетто");
    if(Hold[playerid] != 197) return ErrorMessage(playerid,"{ff6347}У вас нет балончика в руках");
    for(new i;i<GZONES;i++)
    {
        if(!IsPlayerInRangeOfPoint(playerid,5.0,GraphitiInfo[i][graphitiPos][0],GraphitiInfo[i][graphitiPos][1],GraphitiInfo[i][graphitiPos][2]) && GetZone(playerid) == GraphitiInfo[i][graphitiZone])
        {
            return ErrorMessage(playerid,"{ff6347}В данном квадрате уже есть граффите, смойте его или закрасте");
        }
    }
    CreateGraphiti(playerid);
    return 1;
}

CMD:sprays(playerid)
{
    ShowAllGraphiti(playerid);
    return 1;
}

stock dialogCase_Graphiti(playerid, dialogid, response, listitem)
{
    if(dialogid == 1476)
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
                    format(store,sizeof(store),"\n%d.%s\nБанда:%s\nДата создания:[ %02d.%02d.%d %02d:%02d ]", listord+1,PlayerInfo[GraphitiInfo[listord][graphitiPlayer]][pName],fraklastName[g],tyear, tmonth, tday, thour, tminute, tsecond);
                    ShowDialog(playerid,1477,DIALOG_STYLE_MSGBOX,"{ff9000}Граффити",store,"Тп","Назад");
                }
            }
        }
    }
    if(dialogid == 1477)
    {
        if(response)
        {
            new listord = DP[0][playerid];
            PPSetPlayerPos(playerid, GraphitiInfo[listord][graphitiPos][0],GraphitiInfo[listord][graphitiPos][1],GraphitiInfo[listord][graphitiPos][2]+3);
        }
        else ShowAllGraphiti(playerid);
    }
    return 1;
}

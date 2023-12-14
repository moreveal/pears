enum graphitiEnum
{
    graphitiID,
    Float:graphitiPos[6], // Координаты
    graphitiUnix, // Время создания граффити
    graphitiPlayer, // номер акка игрока
    graphitiOrg, // номер организации
    graphitiStatus, // Статус 0 - не установлена, 1 установлена
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
        cache_get_value_name_int(f, "gplayernumber", GraphitiInfo[f][graphitiOrg]);
        cache_get_value_name_int(f, "gStatus", GraphitiInfo[f][graphitiStatus]);
        cache_get_value_name(f, "gstring", stroca, 48);
        split(stroca,GraphitiPos,'_');
        for(new i;i<6;i++)
        {
            GraphitiInfo[f][graphitiPos][i] = floatstr(GraphitiPos[i]);
        }
        format(stroca,sizeof(stroca),""); // Очищаем stroca
	}
	printf("[MODE]: Граффити [%d Quan][%d ms]",rows,GetTickCount() - time);
	return 1;
}

stock ShowAllGraphiti(playerid)
{
	format(lines,sizeof(lines),""); // Очищаем Lines
	new tyear, tmonth, tday, thour, tminute, tsecond, quan;
	format(line,sizeof(line),"№ Создатель\tБанда\tВремя редактирования/создания"), strcat(lines,line);
	for(new i = 0; i < GZONES; i++) 
	{
		List[i][playerid] = 0;
		stamp2datetime(GraphitiInfo[i][graphitiUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
		if(GraphitiInfo[i][graphitiStatus] != 0)
		{
            format(line,sizeof(line),"\n%d.%s\t%s\t[ %02d.%02d.%d %02d:%02d ]", i+1,PlayerInfo[GraphitiInfo[i][graphitiUnix]][pName],fraklastName(GraphitiInfo[i][graphitiOrg]),tyear, tmonth, tday, thour, tminute, tsecond), strcat(lines,line);
		}
		else
		{
			format(line,sizeof(line),"\n%d.Пусто\t\t ", i+1), strcat(lines,line);
        }
        List[quan][playerid] = i;
		quan++;
	}
    ShowDialog(playerid,11111,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список Графити",lines,"Выбрать","Выход");
	return 1;
}

stock CreateGraphiti(playerid)
{
    new g = fraction(playerid),slot = -1,slotreset = -1;
    for(new i; i<GZONES;i++)
    {
        if(GraphitiInfo[i][graphitiStatus] != 0) continue;
        if(IsPlayerInRangeOfPoint(playerid,5.0,GraphitiInfo[i][graphitiStatus][0],GraphitiInfo[i][graphitiStatus][1],GraphitiInfo[i][graphitiStatus][2]))
        {
            slotreset = i;
            break;
        }
        slot = i;
        break;
    }
    if(slot == -1 && slotreset == -1) return ErrorMessage(playerid,"{ff6347} Нет свободных слотов для граффити. Найдите графити и закрасте его или смойте бензином");
    else if(slot == -1 && slotreset != -1)
    {
        DP[0][playerid] = slotreset;
        DestroyDynamicObject(GraphitiObject[slotreset]);
        DestroyDynamicPickup(GraphitiPickUp[slotreset]);
        DestroyDynamic3DTextLabel(GraphitiLabel[slotreset]);
    }
    else
    {
        DP[0][playerid] = slot;
    }
    new objectid;
    if(g == 13) objectid = 1528; // grove
    else if(g == 14) objectid = 1529; // ballas
    else if(g == 15) objectid = 1530; // vagos
    else if(g == 16) objectid = 1531; // aztec
    new Float:f_pos[4];
    frontme(playerid, 5.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
    CreateEditPlayerObject(playerid, 27, 0, 0, 0, objectid, f_pos[0], f_pos[1], f_pos[2], 0.0, 0.0, 0.0);
}

stock GraphitiUpdateElement(graphiti,objectid)
{
    new g = GraphitiInfo[graphiti][graphitiOrg];
    new Float:x,Float:y,Float:z;
    frontobject(objectid,1.0,x,y,z,GraphitiInfo[graphiti][graphitiPos][5]);
    GraphitiPickUp[graphiti] = CreateDynamicPickup(365,1,x,y,z,0,0);

   // format(store,sizeof(store),"{cccccc}Граффити банды {ff9000}%s\n {ff9000}[ Баллончик вруках + ALT ]",frakeasyName(g));
   // GraphitiLabel[slotreset] = CreateDynamic3DTextLabel(store,0xA9C4E4FF,GraphitiInfo[graphiti][graphitiPos][0], GraphitiInfo[graphiti][graphitiPos][1], GraphitiInfo[graphiti][graphitiPos][2],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
    return 1;
}
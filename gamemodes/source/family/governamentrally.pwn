#define RALLY_MAX_POINT 300000
#define RALLY_STATIC_POINT 150000
#define PARTIES_MEMBERS 30


enum rallygov
{
    rallyStatus, // Статус митинга.
    rallyInfo[40], // Название.
    rallyPoint, // Количество очков.
    rallyUnix, // Количество очков.
    rallyType, // Тип для авто системы
}
new RallyInfo[1][rallygov];

enum partie
{
    partieUnix, // Статус митинга.
    partieFam[10], // Количество очков.
    partieSlots[10], // Количество очков.
}
new PartieInfo[1][partie];
new RallyTabloObject[4];
//new SenateTabloObject[4];
//new SenatVote[3];
new VotePickup[1];
new Text3D:VoteLabel[1];
new VoteTableObject;
new dyn_zone_zzGov;

stock StartRally(playerid)
{
    /*if(OnlineInfo[playerid][oRally] == 0 && RallyInfo[0][rallyStatus] == 0)
    {
        new tyear, tmonth, tday, thour, tminute, tsecond;
        stamp2datetime(RallyInfo[0][rallyUnix]+430000, tyear, tmonth, tday, thour, tminute, tsecond, 3);
        new string[50];
        format(string,sizeof(string),"Митинг станет доступен: %02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute);
        return ErrorMessage(playerid,string);
    }*/
    new line[73],lines[146];
    if(RallyInfo[0][rallyStatus] != 0 && OnlineInfo[playerid][oRally] == 0)
    {
        format(line,sizeof(line),"{cccccc}Взять {44ff99}зеленый{cccccc} флажок [Поддерживание голосования]"), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}Взять {ff6347}красный{cccccc} флажок [Против голосования]"), strcat(lines,line);
        ShowDialog(playerid,1492,DIALOG_STYLE_TABLIST,"Участие в Митинге",lines,"Выбрать","Отмена");
    }
    else if(RallyInfo[0][rallyStatus] == 0)
    {
        format(line,sizeof(line),"{cccccc}Отстранение Губернатора"), strcat(lines,line);
        format(line,sizeof(line), "\n{cccccc}Отстранение всего Сената"), strcat(lines,line);
        format(line,sizeof(line), "\n{cccccc}Ваша тематика митинга [Выборочная]"), strcat(lines,line);
        ShowDialog(playerid,1493,DIALOG_STYLE_TABLIST,"Организцая Митинга",lines,"Выбрать","Отмена");
    }
    else if(RallyInfo[0][rallyStatus] != 0 && OnlineInfo[playerid][oRally] > 0)
    {
        RemovePlayerAttachedObject(playerid,3);
        OnlineInfo[playerid][oRally] = 0;
        SuccessMessage(playerid,"{44ff99}Вы вернули флажок и перестали участвовать в митинге");
        ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0,0,1,1,0,0);
    }
    else if(RallyInfo[0][rallyStatus] == 0 && OnlineInfo[playerid][oRally] > 0)
    {
        RemovePlayerAttachedObject(playerid,3);
        OnlineInfo[playerid][oRally] = 0;
        ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0,0,1,1,0,0);
        SuccessMessage(playerid,"{44ff99}Вы вернули флажок");
    }
    return 1;
}
CMD:startrally(playerid)
{
    StartRally(playerid);
    return 1;
}
CMD:stoprally(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 10) return 0;
    CloseRally(playerid);
    return 1;
}

CMD:voteclose(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 14) return 0;
    SelectVoteAfterRally();
    return 1;
}

CMD:sharpvoteclose(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 14) return 0;
    ViborInfo[vstat] = 0; // Закрываем
    new string[5];
    for(new gop = 0;gop<10;gop++)
    {
        if(ViborFunk[gop] == 1)
        {
            format(string, sizeof(string), " ");
            strmid(ViborName[gop], string, 0, strlen(string), 255);
            ViborFunk[gop] = 0;
        }
    }
    UpdateVoteTableObject();
    SaveVibor();
    DeleteVoteInfoPickup();
    return 1;
}

stock CreateRally(playerid,type)
{
    if(RallyInfo[0][rallyStatus] != 0) return ErrorMessage(playerid,"{ff6347}Кто-то уже начал митинг!");
    RallyInfo[0][rallyStatus] = 1;
    if(type == 2) format(RallyInfo[0][rallyInfo], 25, "%s",ListName[playerid]);
    if(type == 1) format(RallyInfo[0][rallyInfo], 25, "Отстранение всего Сената");
    if(type == 0) format(RallyInfo[0][rallyInfo], 25, "Отстранение Губернатора");
    RallyInfo[0][rallyType] = type;
    RallyInfo[0][rallyPoint] = RALLY_STATIC_POINT;
    RallyInfo[0][rallyUnix] = gettime();
    UpdateRallyTableObject();
    CreateRallyZone();
    SuccessMessage(playerid,"{44ff99}Вы начали митинг!");
    SaveRally();
    return 1;
}

stock CloseRally(playerid)
{
    if(RallyInfo[0][rallyStatus] == 0 && playerid >= 0) return ErrorMessage(playerid,"{ff6347}Сейчас нет митинга!");

    UpdateRallyTableObject();
    if(playerid >= 0) SuccessMessage(playerid,"{44ff99}Вы закончили митинг!");
    DestroyRallyZone();
    if(RallyInfo[0][rallyPoint] >= RALLY_MAX_POINT) CreateVoteAfterRally(RallyInfo[0][rallyType]);
    SaveRally();
    RallyInfo[0][rallyPoint] = 0;
    RallyInfo[0][rallyStatus] = 0;
    format(RallyInfo[0][rallyInfo], 1, " ");
    return 1;
}

stock GoToRally(playerid,status)
{
    if(RallyInfo[0][rallyStatus] == 0) return ErrorMessage(playerid,"{ff6347}Сейчас нет митинга!");
    new model;
    if(status == 1) OnlineInfo[playerid][oRally] = 2,model = 19306;
    else OnlineInfo[playerid][oRally] = 1,model = 2914;
    SetPlayerAttachedObject(playerid, 3, model, 6, 0.069999, -0.009000, -0.008000, -172.200027, -158.500000, 0.000000, 0.344999, 0.379999, 0.424000, 0, 0);
    SuccessMessage(playerid,"{66ff99} Вы начали участвовать в митиинге");
    return 1;
}

stock SetRallyPoint(playerid)
{
    if(RallyInfo[0][rallyPoint] >= RALLY_MAX_POINT) CloseRally(-1);
    if(OnlineInfo[playerid][oRally] == 1) RallyInfo[0][rallyPoint] += 10;
    else if(OnlineInfo[playerid][oRally] == 2) RallyInfo[0][rallyPoint] -= 10;
    else return 0;
    return 1;
}

stock dialogCase_Governament(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == 1493)
    {
        if(response)
        {
            if(listitem > 2 || listitem < 0) return 0;
            if(listitem == 2)
            {
                ShowDialog(playerid,1491,DIALOG_STYLE_INPUT,"{ff9000}Напишите назвиние митинга","{cccccc}Введите краткое название для митинга {ff9000}[ Лимит: 20 Символов ]\n\n{cccccc}Пример: Отмена закона №32","Принять","Отмена");
            }
            else if(listitem == 1 || listitem == 0)
            {
                CreateRally(playerid,listitem);
            }
        }
    }
    if(dialogid == 1491)
    {
        if(response)
        {
			if(!strlen(inputtext)) return 0;
          	if(strlen(inputtext) < 3 || strlen(inputtext) > 20) return ErrorText(playerid, "[ Мысли ]: Не меньше 3 и не больше 20 символов");
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь указать в названии какие-то каракули... [ Запрещённый Символ ]");
			format(ListName[playerid], 21, "%s", inputtext);
            CreateRally(playerid,2);
        }
        else return StartRally(playerid);
    }
    if(dialogid == 1492)
    {
        if(response)
        {
            if(listitem > 1 || listitem < 0) return 0;
            GoToRally(playerid,listitem);
        }
    }
    if(dialogid == 1494)
    {
        if(listitem > 1 || listitem < 0) return 0;
        if(listitem == 0 || listitem == 1)
        {
            if(ViborInfo[vfunk1] == 0) return cmd_vote(playerid), SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Необходимо заполнить: Название");
            if(ViborFunk[0] == 0 || ViborFunk[1] == 0) return cmd_vote(playerid), SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Необходимо добавить минимум 2-ух Кандидатов");
            for(new gop = 0;gop<10;gop++)
		    {	
                new fam = strval(ViborName[gop]);
                
                if(ViborFunk[gop] == 1 && (fam < 1 || fam > 500) && listitem == 1) return ErrorMessage(playerid,"{ff6347}Ошибка, для сената нужно указывать номер семьи от 1 до 500");
                if(ViborFunk[gop] == 1 && (FamilyInfo[fam][fSost] == 0 || FamilyInfo[fam][fType] != 2) && listitem == 1)
                {
                    new string[50];
                    format(string,sizeof(string),"{ff6347}Ошибка, в слоте %d не партия", gop+1);
                    return ErrorMessage(playerid,string);
                } 
            }
            OOCOff(COLOR_GREY,""); // Пропуск строки
            new str[128];
            format(str, sizeof(str), "{ffffff}     Уважаемые жители штата! Открыты: {ff9000}[ %s ]",ViborInfo[vname]);
            OOCOff(COLOR_GREY,str);
            OOCOff(COLOR_GREY,"{ffffff}     Приглашаем вас в Капитолий для голосования.");
            OOCOff(COLOR_GREY,"{cccccc}     [ Y >> GPS >> Организации >> Фракции >> Правительство ]");
            OOCOff(COLOR_GREY,""); // Пропуск строки
            ViborInfo[vstat] = 1+listitem;
            for(new gop = 0;gop<10;gop++){ ViborGol[gop] = 0; }
            ViborInfo[vkakoi] ++;
            ViborInfo[vfunk3] = gettime();
            ViborInfo[vfunk2] = gettime() + 259200;
            new tyear, tmonth, tday, thour, tminute, tsecond;
            stamp2datetime(ViborInfo[vfunk3], tyear, tmonth, tday, thour, tminute, tsecond, 3);
            format(ViborInfo[vdatanach],sizeof(ViborInfo[vdatanach]),"%02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute);
            stamp2datetime(ViborInfo[vfunk2], tyear, tmonth, tday, thour, tminute, tsecond, 3);
            format(ViborInfo[vdatakon],sizeof(ViborInfo[vdatakon]),"%02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute);
            UpdateVoteTableObject();
            SaveVibor();
            CreateVoteInfoPickup();
        }
    }
    return 1;
}

stock UpdateRallyTableObject()
{
    new string[34];
    if(RallyInfo[0][rallyStatus] != 0)
    {
        format(string,sizeof(string), "%d / %d", RallyInfo[0][rallyPoint],RALLY_MAX_POINT);
        SetDynamicObjectMaterialText(RallyTabloObject[0], 0, "э", 130, "Wingdings", 80, 0, 0xFFFF3545, 0x00000000, 1);
        SetDynamicObjectMaterialText(RallyTabloObject[1], 0, string, 130, "Arial", 30, 1, 0xFFFF3545, 0x00000000, 0);
        new tyear, tmonth, tday, thour, tminute, tsecond;
        stamp2datetime(RallyInfo[0][rallyUnix]+430000, tyear, tmonth, tday, thour, tminute, tsecond, 3);
        format(string,sizeof(string), "До: %02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute);
        SetDynamicObjectMaterialText(RallyTabloObject[2], 0, string, 130, "Arial", 20, 1, 0xFFFF3545, 0x00000000, 0);
        format(string,sizeof(string), "%s", RallyInfo[0][rallyInfo]);
        SetDynamicObjectMaterialText(RallyTabloObject[3], 0, string, 130, "Arial", 21, 1, 0xFFFF3545, 0x00000000, 0);
    }
    else
    {
        SetDynamicObjectMaterialText(RallyTabloObject[0], 0, " ", 130, "Wingdings", 80, 0, 0xFFFF3545, 0x00000000, 1);
        SetDynamicObjectMaterialText(RallyTabloObject[1], 0, " ", 130, "Arial", 30, 1, 0xFFFF3545, 0x00000000, 0);
        SetDynamicObjectMaterialText(RallyTabloObject[2], 0, " ", 130, "Arial", 20, 1, 0xFFFF3545, 0x00000000, 0);
        SetDynamicObjectMaterialText(RallyTabloObject[3], 0, " ", 130, "Arial", 21, 1, 0xFFFF3545, 0x00000000, 0);
    }
}

stock UpdateVoteTableObject()
{
    if(ViborInfo[vstat] > 0) 
    {
        new string[150];
        format(string,sizeof(string),"{99FF66}%s\n{ffffff}Начало: {ff9000}%s\n{ffffff}Завершение: {ff9000}%s",ViborInfo[vname],ViborInfo[vdatanach],ViborInfo[vdatakon]);
        SetDynamicObjectMaterialText(VoteTableObject, 0, string, 130, "Calibri", 23, 1, 0xFFFFFFFF, 0x00000000, 0);
    }
    else
    {
        SetDynamicObjectMaterialText(VoteTableObject, 0, " ", 130, "Calibri", 23, 1, 0xFFFFFFFF, 0x00000000, 0);
    }
}
stock CreateRallyZone()
{
    if(dyn_zone_zzGov != 0) return 0;
	dyn_zone_zzGov = CreateDynamicCube(-2667.4880, 339.9838, 0, -2745.1135, 411.2858, 10, 0, 0);
	return 1;
}

stock DestroyRallyZone()
{
    if(dyn_zone_zzGov == 0) return 0;
	DestroyDynamicArea(dyn_zone_zzGov);
    dyn_zone_zzGov = 0;
	return 1;
}

stock SaveRally()
{
    new text[40],string[250];
    mysql_escape_string(RallyInfo[0][rallyInfo], text, sizeof(text));
    format(string, sizeof(string), "UPDATE `pp_rally` SET `rallyStatus` = '%d',`rallyInfo` = '%s',`rallyPoint` = '%d',`rallyUnix` = '%d',`rallyType` = '%d' WHERE `rallyNewID` = '1'", RallyInfo[0][rallyUnix],text,RallyInfo[0][rallyPoint],RallyInfo[0][rallyUnix],RallyInfo[0][rallyType]), query_empty(pearsq, string);
    return 1;
}

public LoadRally()
{
	new time = GetTickCount();
	new rows;
	cache_get_row_count(rows);
	for(new f; f<rows; ++f)
	{
    	cache_get_value_name_int(f, "rallyStatus", RallyInfo[0][rallyStatus]);
        cache_get_value_name(f, "rallyInfo", RallyInfo[0][rallyInfo],40);
        cache_get_value_name_int(f, "rallyPoint", RallyInfo[0][rallyPoint]);
        cache_get_value_name_int(f, "rallyUnix", RallyInfo[0][rallyUnix]);
        cache_get_value_name_int(f, "rallyType", RallyInfo[0][rallyType]);
	}
	printf("[MODE]: Rally [%d Quan][%d ms]",rows,GetTickCount() - time);
	return 1;
}

public LoadParties()
{
	new time = GetTickCount();
	new rows;
    new string[30];
	cache_get_row_count(rows);
	for(new f; f<rows; ++f)
	{
        cache_get_value_name_int(f, "partiesUnix", PartieInfo[0][partieUnix]);
        if(PartieInfo[0][partieUnix]+259200 < gettime())
        {
            for(new i;i < 10; i++)
            {
                format(string,sizeof(string),"partiesFam%d",i);
                cache_get_value_name_int(f, string, PartieInfo[0][partieFam][i]);
                format(string,sizeof(string),"partiesSlots%d",i);
                cache_get_value_name_int(f, string, PartieInfo[0][partieSlots][i]);
            }
        }
    }
	printf("[MODE]: Parties [%d Quan][%d ms]",rows,GetTickCount() - time);
	return 1;
}

stock SaveParties()
{
    new string[800];
    format(string, sizeof(string), "UPDATE `pp_parties` SET `partiesUnix` = '%d',`partiesFam0` = '%d',`partiesSlots0` = '%d',\
    `partiesFam1` = '%d',`partiesSlots1` = '%d',\
    `partiesFam2` = '%d',`partiesSlots2` = '%d',\
    `partiesFam3` = '%d',`partiesSlots3` = '%d',\
    `partiesFam4` = '%d',`partiesSlots4` = '%d',\
    `partiesFam5` = '%d',`partiesSlots5` = '%d',\
    `partiesFam6` = '%d',`partiesSlots6` = '%d',\
    `partiesFam7` = '%d',`partiesSlots7` = '%d',\
    `partiesFam8` = '%d',`partiesSlots8` = '%d',\
    `partiesFam9` = '%d',`partiesSlots9` = '%d' WHERE `newid` = '1'", PartieInfo[0][partieUnix],PartieInfo[0][partieFam][0],PartieInfo[0][partieSlots][0],
    PartieInfo[0][partieFam][1],PartieInfo[0][partieSlots][1],
    PartieInfo[0][partieFam][2],PartieInfo[0][partieSlots][2],
    PartieInfo[0][partieFam][3],PartieInfo[0][partieSlots][3],
    PartieInfo[0][partieFam][4],PartieInfo[0][partieSlots][4],
    PartieInfo[0][partieFam][5],PartieInfo[0][partieSlots][5],
    PartieInfo[0][partieFam][6],PartieInfo[0][partieSlots][6],
    PartieInfo[0][partieFam][7],PartieInfo[0][partieSlots][7],
    PartieInfo[0][partieFam][8],PartieInfo[0][partieSlots][8],
    PartieInfo[0][partieFam][9],PartieInfo[0][partieSlots][9]), query_empty(pearsq, string);
    return 1;
}


stock CreateVoteAfterRally(type)
{
    format(ViborInfo[vname], 24, "%s",RallyInfo[0][rallyInfo]);
    if(type == 0 || type == 1) 
    {
        format(ViborName[0] , 24, "За отставку");
        ViborFunk[0] = 1;
        format(ViborName[1] , 24, "Против отставки");
        ViborFunk[1] = 1;
        ViborInfo[vstat] = 4+type; // Открываем
    }
    else
    {
        format(ViborName[0] , 24, "За отмену закона");
        ViborFunk[0] = 1;
        format(ViborName[1] , 24, "Против отмены закона");
        ViborFunk[1] = 1;
        format(ViborName[2] , 24, "Воздержание");
        ViborFunk[2] = 1;
        ViborInfo[vstat] = 3; // Открываем
    }
    ViborInfo[vfunk3] = gettime();
    ViborInfo[vfunk2] = gettime() + 259200;
    new tyear, tmonth, tday, thour, tminute, tsecond;
    stamp2datetime(ViborInfo[vfunk3], tyear, tmonth, tday, thour, tminute, tsecond, 3);
    format(ViborInfo[vdatanach],sizeof(ViborInfo[vdatanach]),"%02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute);
    stamp2datetime(ViborInfo[vfunk2], tyear, tmonth, tday, thour, tminute, tsecond, 3);
    format(ViborInfo[vdatakon],sizeof(ViborInfo[vdatakon]),"%02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute);
    new str[128];
    OOCOff(COLOR_GREY,""); // Пропуск строки
    format(str, sizeof(str), "{ffffff}     Уважаемые жители штата! Открыто голосование за: {ff9000}[ %s ]",ViborInfo[vname]);
    OOCOff(COLOR_GREY,str);
    OOCOff(COLOR_GREY,"{ffffff}     Приглашаем вас в Капитолий для голосования.");
    OOCOff(COLOR_GREY,"{cccccc}     [ Y >> GPS >> Организации >> Фракции >> Правительство ]");
    OOCOff(COLOR_GREY,""); // Пропуск строки
    for(new gop = 0;gop<10;gop++){ ViborGol[gop] = 0; }
    ViborInfo[vkakoi] ++;
    UpdateVoteTableObject();
    SaveVibor();
    CreateVoteInfoPickup();
}

stock SelectVoteAfterRally()
{
    new v1 = ViborGol[0];
    new v2 = ViborGol[1];
    new v3 = ViborGol[2];
    new v4 = ViborGol[3];
    new v5 = ViborGol[4];
    new v6 = ViborGol[5];
    new v7 = ViborGol[6];
    new v8 = ViborGol[7];
    new v9 = ViborGol[8];
    new v10 = ViborGol[9];
    OOCOff(COLOR_GREY,""); // Пропуск строки
    new str[164],set,string[100];
    format(str, sizeof(str), "{ffffff}     Завершено голосование за: {ff9000}[ %s ]",ViborInfo[vname]);
    OOCOff(COLOR_GREY,str);
    format(str, sizeof(str), " ");
    if(ViborInfo[vstat] == 2)
    {
        new slots[10];
        new summvote = v1+v2+v3+v4+v5+v6+v7+v8+v9+v10;
        for(new number;number<10;number++)
        {
            if(ViborFunk[number] == 1)
            {
                if(ViborGol[number] > 0)
                {
                    slots[number] = floatround(float(ViborGol[number])/float(summvote)*float(PARTIES_MEMBERS),floatround_round);
                    format(str, sizeof(str), "{ffffff}     {0088ff}[ %s {0088ff}] {cccccc}%d мандатов",FamilyInfo[strval(ViborName[number])][fName],slots[number]);
                    OOCOff(COLOR_GREY, str);
                }
            }
        }
    }
    else
    {
        if(v1 > v2 && v1 > v3 && v1 > v4 && v1 > v5 && v1 > v6 && v1 > v7 && v1 > v8 && v1 > v9 && v1 > v10) format(str, sizeof(str), "{ffffff}     Итог: {0088ff}[ %s ] {cccccc}%d голосов",ViborName[0],ViborGol[0]),set = 0;
        else if(v2 > v1 && v2 > v3 && v2 > v4 && v2 > v5 && v2 > v6 && v2 > v7 && v2 > v8 && v2 > v9 && v2 > v10) format(str, sizeof(str), "{ffffff}     Итог: {0088ff}[ %s ] {cccccc}%d голосов",ViborName[1],ViborGol[1]),set = 1;
        else if(v3 > v2 && v3 > v1 && v3 > v4 && v3 > v5 && v3 > v6 && v3 > v7 && v3 > v8 && v3 > v9 && v3 > v10) format(str, sizeof(str), "{ffffff}     Итог: {0088ff}[ %s ] {cccccc}%d голосов",ViborName[2],ViborGol[2]),set = 2;
        else if(v4 > v2 && v4 > v3 && v4 > v1 && v4 > v5 && v4 > v6 && v4 > v7 && v4 > v8 && v4 > v9 && v4 > v10) format(str, sizeof(str), "{ffffff}     Итог: {0088ff}[ %s ] {cccccc}%d голосов",ViborName[3],ViborGol[3]),set = 3;
        else if(v5 > v2 && v5 > v3 && v5 > v4 && v5 > v1 && v5 > v6 && v5 > v7 && v5 > v8 && v5 > v9 && v5 > v10) format(str, sizeof(str), "{ffffff}     Итог: {0088ff}[ %s ] {cccccc}%d голосов",ViborName[4],ViborGol[4]),set = 4;
        else if(v6 > v2 && v6 > v3 && v6 > v4 && v6 > v5 && v6 > v1 && v6 > v7 && v6 > v8 && v6 > v9 && v6 > v10) format(str, sizeof(str), "{ffffff}     Итог: {0088ff}[ %s ] {cccccc}%d голосов",ViborName[5],ViborGol[5]),set = 5;
        else if(v7 > v2 && v7 > v3 && v7 > v4 && v7 > v5 && v7 > v6 && v7 > v1 && v7 > v8 && v7 > v9 && v7 > v10) format(str, sizeof(str), "{ffffff}     Итог: {0088ff}[ %s ] {cccccc}%d голосов",ViborName[6],ViborGol[6]),set = 6;
        else if(v8 > v2 && v8 > v3 && v8 > v4 && v8 > v5 && v8 > v6 && v8 > v7 && v8 > v1 && v8 > v9 && v8 > v10) format(str, sizeof(str), "{ffffff}     Итог: {0088ff}[ %s ] {cccccc}%d голосов",ViborName[7],ViborGol[7]),set = 7;
        else if(v9 > v2 && v9 > v3 && v9 > v4 && v9 > v5 && v9 > v6 && v9 > v7 && v9 > v8 && v9 > v1 && v9 > v10) format(str, sizeof(str), "{ffffff}     Итог: {0088ff}[ %s ] {cccccc}%d голосов",ViborName[8],ViborGol[8]),set = 8;
        else if(v10 > v2 && v10 > v3 && v10 > v4 && v10 > v5 && v10 > v6 && v10 > v7 && v10 > v8 && v10 > v9 && v10 > v1) format(str, sizeof(str), "{ffffff}     Итог: {0088ff}[ %s ] {cccccc}%d голосов",ViborName[9],ViborGol[9]),set = 9;
        else OOCOff(COLOR_GREY,"{ffffff}     Исход выборов не установлен!");
        OOCOff(COLOR_GREY, str);
    }
    OOCOff(COLOR_GREY,""); // Пропуск строки
    if(ViborInfo[vstat] == 4)
    {
        new otmena = -1;
        foreach(Player,i)
        {
            if(PlayerInfo[i][pLeader] == 7 && PlayerInfo[i][pMember] == 7)
            {
                UnmakeleaderPlayerBridge(PlayerInfo[i][pID], PlayerInfo[i][pLeader], PlayerInfo[i][pRank]);
                PlayerInfo[i][pLeader] = 0;
                Uninvivte(i,0);
                otmena = 1;
                OrgLog(7, "DismissalAfterRally", PlayerInfo[i][pID], PlayerInfo[i][pName], PlayerInfo[i][pPlaIP], 0, "", "", 0, "Снят по голосованию после митинга");
                break;
            }
        }
        if(otmena == -1)
        {
            format(string,sizeof(string),"SELECT user_id, Name FROM `pp_igroki` WHERE `Leader` = '7' AND `Member` = '7'"); // Убиваем губера
            mysql_tquery(pearsq, string, "Call_dismissalGover", "");
        }
    }
    else if(ViborInfo[vstat] == 5)
    {
        foreach(Player,i)
        {
            if(PlayerInfo[i][pMember] == 7 && PlayerInfo[i][pDivision] == 1)
            {
                UnmakeleaderPlayerBridge(PlayerInfo[i][pID], PlayerInfo[i][pLeader], PlayerInfo[i][pRank]);
                PlayerInfo[i][pLeader] = 0;
                Uninvivte(i,0);
                OrgLog(7, "DismissalAfterRally", PlayerInfo[i][pID], PlayerInfo[i][pName], PlayerInfo[i][pPlaIP], 0, "", "", 0, "Уволен по голосованию после митинга");
            }
        }
        format(string,sizeof(string),"SELECT user_id, Name FROM `pp_igroki` WHERE `Division0` = '1' AND `Member` = '7' AND `Division1` > '0'"); // Распускаем сенат
        mysql_tquery(pearsq, string, "Call_dismissalSenat", "");
        for(new gop = 0;gop<10;gop++)
        {
            if(PartieInfo[0][partieFam][gop] > 0) 
            {
                PartieInfo[0][partieFam][gop] = 0;
                PartieInfo[0][partieSlots][gop] = 0;
            }
        }
        SaveParties();
    }
    else if(ViborInfo[vstat] == 3)
    {
        new stringlog[100];
        format(stringlog,sizeof(stringlog),"Голосование за: %s. Итог: %s.",ViborInfo[vname],ViborName[set]);
        OrgLog(7, "voting", 0, "", " ", 0, "", "", 0, stringlog);
    }
    else if(ViborInfo[vstat] == 2)
    {
        new slots[10],summvote;
        summvote = v1+v2+v3+v4+v5+v6+v7+v8+v9+v10;
        PartieInfo[0][partieUnix] = gettime();
        for(new number;number<10;number++)
        {
            if(ViborFunk[number] == 1)
            {
                if(ViborGol[number] > 0)
                {
                    slots[number] = floatround(float(ViborGol[number])/float(summvote)*float(PARTIES_MEMBERS),floatround_round);
                }
                else slots[number] = 0;
            }
        }
        for(new gop = 0;gop<10;gop++)
        {
            if(ViborFunk[gop] == 1) 
            {
                PartieInfo[0][partieFam][gop] = strval(ViborName[gop]);
                PartieInfo[0][partieSlots][gop] = slots[gop];
                new notifystring[60];
                format(notifystring, sizeof(notifystring), "Ваша партия победила в выборах и получила %d мест в сенате",slots[gop]);
                notify(0, "",FamilyInfo[strval(ViborName[gop])][fOwner], FamilyInfo[strval(ViborName[gop])][fOsn], notifystring);
            }
        }
        SaveParties();
    }
    ViborInfo[vstat] = 0; // Закрываем
    for(new gop = 0;gop<10;gop++)
    {
        if(ViborFunk[gop] == 1)
        {
            format(string, sizeof(string), " ");
            strmid(ViborName[gop], string, 0, strlen(string), 255);
            ViborFunk[gop] = 0;
        }
    }
    UpdateVoteTableObject();
    SaveVibor();
    DeleteVoteInfoPickup();
    return 1;
}

CMD:setvote(playerid,const params[])
{
    new number,count;
    sscanf(params, "ii",number,count);
    ViborGol[number] = count;
    return 1;
}

forward Call_dismissalGover();
public Call_dismissalGover()
{
	new rows,f_str[144];
	cache_get_row_count(rows);
	for(new i = 0; i < rows; i++)
	{
	    new userid,nickname[24];
		cache_get_value_name_int(0, "user_id", userid);
        cache_get_value_name(0, "Name", nickname,24);
        format(f_str,sizeof(f_str),"SELECT user_id, Soska, Member, Leader, Rank, Fbi, Family FROM `pp_igroki` WHERE `Name` = '%s'", nickname);
		mysql_tquery(pearsq, f_str, "Call_uninvite", "dss", -1, nickname,"Снят по голосованию после митинга");
        OrgLog(7, "DismissalAfterRally", userid, nickname, " ", 0, "", "", 0, "Снят по голосованию после митинга");
	}
	return 1;
}

forward Call_dismissalSenat();
public Call_dismissalSenat()
{
	new rows,f_str[144];
	cache_get_row_count(rows);
	for(new i = 0; i < rows; i++)
	{
	    new userid,nickname[24];
		cache_get_value_name_int(0, "user_id", userid);
        cache_get_value_name(0, "Name", nickname,24);
        format(f_str,sizeof(f_str),"SELECT user_id, Soska, Member, Leader, Rank, Fbi, Family FROM `pp_igroki` WHERE `Name` = '%s'", nickname);
		mysql_tquery(pearsq, f_str, "Call_uninvite", "dss", -1, nickname,"Снят по голосованию после митинга");
        OrgLog(7, "DismissalAfterRally", userid, nickname, " ", 0, "", "", 0, "Уволен по голосованию после митинга");
	}
	return 1;
}

stock CreateVoteInfoPickup()
{
    if(ViborInfo[vstat] != 2) return 0;
    VotePickup[0] = CreateDynamicPickup(1239, 1, -2785.5371, 369.4818, 6.1440, 189, 0);
    VoteLabel[0] = CreateDynamic3DTextLabel("{ff9000}Подробная информация о выборах\n{cccccc}[ ALT ]",-1,-2785.5371, 369.4818, 6.1440,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,189,0);
    return 1;
}

stock DeleteVoteInfoPickup()
{
    if(VotePickup[0] == 0) return 0;
    DestroyDynamicPickup(VotePickup[0]);
    DestroyDynamic3DTextLabel(VoteLabel[0]);
    VotePickup[0] = 0;
    return 1;
}

stock ShowVoteInfo(playerid)
{
    if(ViborInfo[vstat] == 0) return 0;
    new str[120],sctring[1200];
    if(ViborInfo[vstat] == 2)
    {
        for(new gop = 0;gop<10;gop++)
		{	
            if(ViborFunk[gop] == 1) format(str,sizeof(str),"\n{0088ff}%d. {ffffff}%s {ffffff}[ {cccccc}Глава: {cccccc}%s{ffffff}]",gop+1,FamilyInfo[strval(ViborName[gop])][fName],FamilyInfo[strval(ViborName[gop])][fOsn]), strcat(sctring,str);
        }
    }
    ShowDialog(playerid,11111,DIALOG_STYLE_LIST,"{0088ff}Подробная информация о кандидатах",sctring,"Выбор","Отмена");
    return 1;
}

stock gopasport(playerid)
{
	new line[50],lines[200];
	format(line,sizeof(line),"{ff9000}Получить Паспорт"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Возраст"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Пол"), strcat(lines,line);
	format(line,sizeof(line),"\n{FF6347}Развестись"), strcat(lines,line);
	if(PartieInfo[0][partieUnix]+259200 > gettime())
	{
		for(new gop = 0;gop<10;gop++)
		{
			if(PartieInfo[0][partieFam][gop] == PlayerInfo[playerid][pFamily] && FamilyInfo[PlayerInfo[playerid][pFamily]][fType] == 2 && PartieInfo[0][partieSlots][gop] > 0) 
			{
				format(line,sizeof(line),"\n{cccccc}Получить сенаторский мандат [ Мест: %d ]",PartieInfo[0][partieSlots][gop]), strcat(lines,line);
				break;
			}
		}
	}
	ShowDialog(playerid,1072,DIALOG_STYLE_TABLIST,"{ff9000}Паспортный Стол",lines,"Выбрать","Отмена");
	return 1;
}

/*stock GoVoteSenat(playerid)
{
    if(type == 0) SenatVote[0] += 1,SenateTableObject(1);
    else if(type == 1) SenatVote[1] += 1,SenateTableObject(1);
    else if(type == 2) SenatVote[2] += 1,SenateTableObject(1);
    else if(type == 3) 
    {
        SenatVote[0] =0, SenatVote[1]=0, SenatVote[2]=0,SenateTableObject(0);
        foreach(Player,i)
        {
            if(OnlineInfo[i][oLogged] == 0) continue;
            if(PlayerInfo[i][pLeader] != 7 && PlayerInfo[i][pMember] != 7 && PlayerInfo[i][pDivision][0] != 1) continue;
            else OnlineInfo[i][oSenatVote] = 0;
        }
    }
    return 1;
}

CMD:senatvote(playerid,const params[])
{
    if(OnlineInfo[playerid][oSenatVote] > 0) return ErrorMessage(playerid,"{ff6347}Я уже отдал свой голос");
    new number;
    sscanf(params, "i",number);
    if(number < 1 || number > 3) return 0;
    GoVoteSenat(number);
    OnlineInfo[playerid][oSenatVote] = 1;
    return 1;
}
stock SenateTableObject(type)
{
    new string[34];
    if(type == 1)
    {
        format(string,sizeof(string), "%d / %d / %d", RallyInfo[0][rallyPoint],RALLY_MAX_POINT);
        SetDynamicObjectMaterialText(SenateTabloObject[0], 0, "э", 130, "Wingdings", 80, 0, 0xFFFF3545, 0x00000000, 1);
        SetDynamicObjectMaterialText(SenateTabloObject[1], 0, string, 130, "Arial", 30, 1, 0xFFFF3545, 0x00000000, 0);
        SetDynamicObjectMaterialText(SenateTabloObject[2], 0, string, 130, "Arial", 20, 1, 0xFFFF3545, 0x00000000, 0);
        SetDynamicObjectMaterialText(SenateTabloObject[3], 0, "ю", 130, "Wingdings", 80, 0, 0xFFFF3545, 0x00000000, 1);
    }
    else
    {
        SetDynamicObjectMaterialText(SenateTabloObject[0], 0, " ", 130, "Wingdings", 80, 0, 0xFFFF3545, 0x00000000, 1);
        SetDynamicObjectMaterialText(SenateTabloObject[1], 0, " ", 130, "Arial", 30, 1, 0xFFFF3545, 0x00000000, 0);
        SetDynamicObjectMaterialText(SenateTabloObject[2], 0, " ", 130, "Arial", 20, 1, 0xFFFF3545, 0x00000000, 0);
        SetDynamicObjectMaterialText(SenateTabloObject[3], 0, " ", 130, "Arial", 21, 1, 0xFFFF3545, 0x00000000, 0);
    }
}*/

#define MAX_CRIMINAL_CODE_ARTICLE 60 // Максимальное количество статьей в кодексе

enum criminalInfo
{
    ccID, // newid в базе данных
	Float:ccArcticle, // Номер статьи (возможность указать плавающую точку, типо 1.1 и т.д.)
    ccType, // Тип статьи (Основная статья или под статья)
	ccName[31], // Название статьи
	ccLevel, // Уровень розыска статьи
    ccFine, // Штраф 
	ccText[121], // Описание статьи
    ccUnix, // Дата и время последнего изменения статьи
    ccPlayer[21], // Никнейм игрока, который последний раз изменял статью
    ccUserID // ID аккаунта игрока, который последний раз изменял статью
};
new CriminalCodeInfo[MAX_CRIMINAL_CODE_ARTICLE][criminalInfo];

CMD:yk(playerid) return cmd_criminal(playerid);
CMD:uk(playerid) return cmd_criminal(playerid);
CMD:criminal(playerid)
{
	CriminalCodeMenu(playerid, 0);
	PlayerPlaySound(playerid,40405,0,0,0);
	return 1;
}

stock CriminalCodeMenu(playerid, inject) // Меню кодекса
{
    format(lines,sizeof(lines),""); // Очищаем Lines
	format(line,sizeof(line),"Статья\tНазвание\tУровень Розыска / Штраф"), strcat(lines,line);
	
    new quan;
    for(new i = 0; i < MAX_CRIMINAL_CODE_ARTICLE; i++)
	{
        List[quan][playerid] = i;
        quan ++;
        if(CriminalCodeInfo[i][ccType] == 0) format(line,sizeof(line),"\n{555555}\t...\t"), strcat(lines,line); // Если статья не указана, показываем пробел
        else if(CriminalCodeInfo[i][ccType] == 1) // Основная Статья
        {
            if(CriminalCodeInfo[i][ccLevel] > 0) format(line,sizeof(line),"\n{cccccc}%.0f\t{ff9000}%s\t{FF6347}%d", CriminalCodeInfo[i][ccArcticle], CriminalCodeInfo[i][ccName], CriminalCodeInfo[i][ccLevel]);
            else format(line,sizeof(line),"\n{cccccc}%.0f\t{ff9000}%s\t{cccccc}%d$", CriminalCodeInfo[i][ccArcticle], CriminalCodeInfo[i][ccName], CriminalCodeInfo[i][ccFine]);
            strcat(lines,line);
        }
        else if(CriminalCodeInfo[i][ccType] == 2) // Подстатья имеет плавающую точку (Пример 1.2)
        {
            if(CriminalCodeInfo[i][ccLevel] > 0) format(line,sizeof(line),"\n{cccccc}%.1f\t{FDCD96}%s\t{FF6347}%d", CriminalCodeInfo[i][ccArcticle], CriminalCodeInfo[i][ccName], CriminalCodeInfo[i][ccLevel]);
            else format(line,sizeof(line),"\n{cccccc}%.1f\t{FDCD96}%s\t{cccccc}%d$", CriminalCodeInfo[i][ccArcticle], CriminalCodeInfo[i][ccName], CriminalCodeInfo[i][ccFine]);
            strcat(lines,line);
        }
	}
    if(inject == 0)
    {
        DP[4][playerid] = 0;
    }
    else
    {
        DP[4][playerid] = 1;
    }
    ShowDialog(playerid,1306,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Кодекс Правонарушений",lines,"Выбрать","Выход");
    return 1;
}

stock CriminalCodeSetting(playerid, i) // Меню редактора статьи
{
    if(i < 0 || i >= MAX_CRIMINAL_CODE_ARTICLE) return 0; // Защищаем от невалидного id статьи (малоли че)

    if(PlayerInfo[playerid][pSoska] >= 10 || PlayerInfo[playerid][pLeader] == 7
    || PlayerInfo[playerid][pMember] == 7 && PlayerInfo[playerid][pRank] >= 16) // Могут редактировать статью
    {
        DP[1][playerid] = 1;
    }
    else // Только просматривать
    {
        DP[1][playerid] = 0;
        ShowDialogCriminalCodeInfo(playerid, i);
    }

    format(lines,sizeof(lines),""); // Очищаем Lines

    // Формируем заголовок
    if(CriminalCodeInfo[i][ccType] == 0) format(line,sizeof(line),"...\t"), strcat(lines,line);
    else if(CriminalCodeInfo[i][ccType] == 1) // Основная Статья
    {
        format(line,sizeof(line),"%.0f {ff9000}%s\t", CriminalCodeInfo[i][ccArcticle], CriminalCodeInfo[i][ccName]), strcat(lines,line);
    }
    else if(CriminalCodeInfo[i][ccType] == 2) // Подстатья имеет плавающую точку (Пример 1.2)
    {
        format(line,sizeof(line),"%.1f {FDCD96}%s\t", CriminalCodeInfo[i][ccArcticle], CriminalCodeInfo[i][ccName]), strcat(lines,line);
    }
	
    // Настройки статьи
    format(line,sizeof(line),"\nОписание {ff9000}>> \t"), strcat(lines,line);

    if(CriminalCodeInfo[i][ccType] == 0) 
    {
        format(line,sizeof(line),"\nТип \t {555555}Не указан"), strcat(lines,line);
        format(line,sizeof(line),"\nНомер \t "), strcat(lines,line);
    }
    else if(CriminalCodeInfo[i][ccType] == 1) 
    {
        format(line,sizeof(line),"\nТип \t {ff9000}Статья"), strcat(lines,line);
        format(line,sizeof(line),"\nНомер \t %.0f", CriminalCodeInfo[i][ccArcticle]), strcat(lines,line);
    }
    else if(CriminalCodeInfo[i][ccType] == 2)
    {
        format(line,sizeof(line),"\nТип \t {FDCD96}Подстатья"), strcat(lines,line);
        format(line,sizeof(line),"\nНомер \t %.1f", CriminalCodeInfo[i][ccArcticle]), strcat(lines,line);
    }
    format(line,sizeof(line),"\nНазвание \t %s", CriminalCodeInfo[i][ccName]), strcat(lines,line);
    format(line,sizeof(line),"\nРозыск \t %d", CriminalCodeInfo[i][ccLevel]), strcat(lines,line);

    format(line,sizeof(line),"\nШтраф \t {FF6347}%d$", CriminalCodeInfo[i][ccFine]), strcat(lines,line);
    format(line,sizeof(line),"\nТекст \t"), strcat(lines,line);

    ShowDialog(playerid,1307,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Кодекс Правонарушений",lines,"Выбрать","Выход");
    return 1;
}

stock ShowDialogCriminalCodeInfo(playerid, i)
{
    if(CriminalCodeInfo[i][ccType] == 0) return ErrorText(playerid, "[ Мысли ]: Этой статье не указан тип"), showDialogCriminalCode(playerid);

    format(lines,sizeof(lines),""); // Очищаем Lines

    if(CriminalCodeInfo[i][ccType] == 1) format(line,sizeof(line),"\n%.0f {ff9000}%s\n", CriminalCodeInfo[i][ccArcticle], CriminalCodeInfo[i][ccName]), strcat(lines,line);
    else if(CriminalCodeInfo[i][ccType] == 2) format(line,sizeof(line),"\n%.1f {FDCD96}%s\n", CriminalCodeInfo[i][ccArcticle], CriminalCodeInfo[i][ccName]), strcat(lines,line);

    if(CriminalCodeInfo[i][ccLevel] >= 1)
    {
        format(line,sizeof(line),"\n{FF6347}Уровень Розыска: {FF6347}%d {555555}[ Время Ареста: %d минут ]", CriminalCodeInfo[i][ccLevel], CriminalCodeInfo[i][ccLevel]*10), strcat(lines,line);
    }
    else
    {
        format(line,sizeof(line),"\nУровень Розыска: {555555}Эта статья не предусматривает ареста"), strcat(lines,line);
    }
    format(line,sizeof(line),"\nШтраф: {FF6347}%d$", CriminalCodeInfo[i][ccFine]), strcat(lines,line);

    format(line,sizeof(line),"\n\n{cccccc}%s",CriminalCodeInfo[i][ccText]), strcat(lines,line);

    new tyear, tmonth, tday, thour, tminute, tsecond;
	stamp2datetime(CriminalCodeInfo[i][ccUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
    format(line,sizeof(line),"\n\n{555555}Редактировал"), strcat(lines,line);
    format(line,sizeof(line),"\n{555555}%s [ %02d.%02d.%d %02d:%02d ]\n", CriminalCodeInfo[i][ccPlayer], tday, tmonth, tyear, thour, tminute), strcat(lines,line);
    ShowDialog(playerid,1308,DIALOG_STYLE_MSGBOX,"{ff9000}Кодекс Правонарушений {cccccc}[Описание статьи]",lines,"*","");
    return 1;
}

stock showDialogCriminalCode(playerid) // При возврате меню или выводе ошибки, открываем предыдущее меню
{
    if(DP[1][playerid] == 1) CriminalCodeSetting(playerid, DP[0][playerid]); // Если доступ к редактированию имеется, значит открываем меню редактора статьи
    else CriminalCodeMenu(playerid, 0); // Если нет доступа, открываем просто список всех статей
    return 1;
}

stock CriminalCodeUpdate(playerid, i) // Записываем необходимую инфу и отправляем на сохранение в базу
{
    format(CriminalCodeInfo[i][ccPlayer], 31, "%s", PlayerInfo[playerid][pName]); // Записываем имя чела
    CriminalCodeInfo[i][ccUserID] = PlayerInfo[playerid][pID]; // Записываем номер аккаунта чела
    CriminalCodeInfo[i][ccUnix] = gettime(); // Записываем unix
    CriminalCodeSave(i); // Сохраняемс
    return 1;
}

stock CriminalCodeSave(i) // Сохраняем в базу (моментальное сохранение при любом изменении)
{
    // Экранируем текстовые строки (Для защиты от sql инъекций)
    new escapeName[31], escapeText[121];
	mysql_escape_string(CriminalCodeInfo[i][ccName], escapeName, sizeof(escapeName));
    mysql_escape_string(CriminalCodeInfo[i][ccText], escapeText, sizeof(escapeText));

    // Формируем запросы в переменную
    format(big_query,sizeof(big_query),"UPDATE `criminal_code` SET `ccArcticle` = '%f', `ccType` = '%d', `ccName` = '%s', `ccLevel` = '%d', `ccFine` = '%d'",
    CriminalCodeInfo[i][ccArcticle], CriminalCodeInfo[i][ccType], escapeName, CriminalCodeInfo[i][ccLevel], CriminalCodeInfo[i][ccFine]);

    format(big_query,sizeof(big_query),"%s, `ccText` = '%s', `ccUnix` = '%d', `ccPlayer` = '%s', `ccUserID` = '%d' WHERE `newid` = '%d'", big_query,
    escapeText, CriminalCodeInfo[i][ccUnix], CriminalCodeInfo[i][ccPlayer], CriminalCodeInfo[i][ccUserID], CriminalCodeInfo[i][ccID]);

    // Отправляем запрос
    query_empty(pearsq, big_query);
    return 1;
}

forward LoadCriminalCode(); // Загрузка из базы
public LoadCriminalCode()
{
	new time = GetTickCount();
	for(new f; f < MAX_CRIMINAL_CODE_ARTICLE; ++f) //  Плевать на то, сколько этих строк в базе. Мы делаем цикл до максимального числа в дефайне переменной
	{
    	cache_get_value_name_int(f, "newid", CriminalCodeInfo[f][ccID]);
    	cache_get_value_name_float(f, "ccArcticle", CriminalCodeInfo[f][ccArcticle]);
        cache_get_value_name_int(f, "ccType", CriminalCodeInfo[f][ccType]);
    	cache_get_value_name(f, "ccName", CriminalCodeInfo[f][ccName], 31);
        cache_get_value_name_int(f, "ccLevel", CriminalCodeInfo[f][ccLevel]);
        cache_get_value_name_int(f, "ccFine", CriminalCodeInfo[f][ccFine]);
        cache_get_value_name(f, "ccText", CriminalCodeInfo[f][ccText], 121);
        cache_get_value_name_int(f, "ccUnix", CriminalCodeInfo[f][ccUnix]);
        cache_get_value_name(f, "ccPlayer", CriminalCodeInfo[f][ccPlayer], 21);
        cache_get_value_name_int(f, "ccUserID", CriminalCodeInfo[f][ccUserID]);
	}
	printf("[MODE]: Кодекс Правонарушений [%d ms]", GetTickCount() - time);
	return 1;
}



#define MAX_CRIME_PLAYER 10

enum wantedInfo
{
    wanCrime[MAX_CRIME_PLAYER], // id статей
    wanPoliceId[MAX_CRIME_PLAYER], // userid полицейского
    wanUnix[MAX_CRIME_PLAYER], // unix, когда выдали розыск
    bool:wanLoad // Загрузка розыска из базы
};
new WantedInfo[MAX_REALPLAYERS][wantedInfo];
new WantedPolice[MAX_REALPLAYERS][MAX_CRIME_PLAYER][24]; // имя мента, который выдал розыск

CMD:wanted(playerid, const params[])
{
	if(IsACop(playerid) || PlayerInfo[playerid][pFbi] >= 1 || PlayerInfo[playerid][pSoska] >= 1)
	{
		if(PlayerInfo[playerid][pBkyrenie] >= 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чего, блин ?! Я не на земле");
		if(!sscanf(params, "i", params[0]))
		{
			if(!IsOnline(params[0])) return ErrorText(playerid, "[ Мысли ]: Игрока нет в сети [ Я могу пробить по базе данных в компьютере ]");
			if(PlayerInfo[params[0]][pCrimes] < 1 && ADUTY[params[0]] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Это не преступник [ Можно пробить по базе данных в компьютере ]");
			format(store,sizeof(store),"{FFFF00} Подозреваемый: {FFFFFF}%s[%d]: {FFFF00}Розыск: {FF6347}%d",PlayerInfo[params[0]][pName],params[0],PlayerInfo[params[0]][pCrimes]);
			SendClientMessage(playerid, COLOR_GREY,store);
		}
		else
		{
			PlayerPlaySound(playerid,40405,0,0,0);
			new qwer[74], year, month,day,quan;
			getdate(year, month, day);

            format(lines,sizeof(lines),""); // Очищаем Lines
			format(line,sizeof(line),"{cccccc}Имя\t{FF6347}Розыск\n"), strcat(lines,line);
			foreach(Player, i)
			{
                List[i][playerid] = 0;
				if(PlayerInfo[i][pCrimes] > 0 && ADUTY[i] == 0 && OnlineInfo[i][oLogged] == 1)
                {
                    format(line,sizeof(line),"{cccccc}%s[%d]\t{FF6347}%d\n",rpplayername(i),i,PlayerInfo[i][pCrimes]), strcat(lines,line);
                    List[quan][playerid] = i;
                    quan ++;
                }
            }
			format(qwer,sizeof(qwer),"{ff9000}Преступники [%d] {99ff66}Online {cccccc}[%02d.%02d.%d]",quan,day,month,year);
			ShowDialog(playerid,1342,DIALOG_STYLE_TABLIST_HEADERS,qwer,lines,"Ок","");
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не работаю в законной организации");
	return 1;
}

stock ShowPlayerWanted(playerid, criminalid)
{
    if(!IsOnline(criminalid)) return ErrorMessage(playerid, "{FF6347}Ой.. кажется преступник вышел из игры");

    DP[0][playerid] = criminalid;
    new qwer[74], uk, quan;
    new tyear, tmonth, tday, thour, tminute, tsecond;
    format(lines,sizeof(lines),""); // Очищаем Lines
			
    format(line,sizeof(line),"{cccccc}Статья\t{cccccc}Название Статьи\t{cccccc}Полицейский\t{cccccc}Время выдачи\n"), strcat(lines,line);
    for(new i = 0; i < MAX_CRIME_PLAYER; i++)
    {
        List[i][playerid] = 0;
        if(WantedInfo[criminalid][wanCrime][i] == 0) continue;

        uk = WantedInfo[criminalid][wanCrime][i] - 1;
        stamp2datetime(WantedInfo[criminalid][wanUnix][i], tyear, tmonth, tday, thour, tminute, tsecond, 3);

        format(line,sizeof(line),"{cccccc}%.1f\t{FF6347}%s\t{0066ff}%s\t{555555}%02d.%02d.%d %02d:%02d\n",CriminalCodeInfo[uk][ccArcticle],CriminalCodeInfo[uk][ccName],WantedPolice[criminalid][i], tday, tmonth, tyear, thour, tminute), strcat(lines,line);
        List[quan][playerid] = i;
        quan ++;
    }
    format(qwer,sizeof(qwer),"{ff9000}Преступник %s[%d]",rpplayername(criminalid),criminalid);
    ShowDialog(playerid,1343,DIALOG_STYLE_TABLIST_HEADERS,qwer,lines,"Ок","");
    return 1;
}

stock ShowPlayerSettingWanted(playerid, i)
{
    new criminalid = DP[0][playerid];
    if(!IsOnline(criminalid)) return ErrorMessage(playerid, "{FF6347}Ой.. кажется преступник вышел из игры");
    if(WantedInfo[criminalid][wanCrime][i] == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Статья пропала из дела");

    DP[1][playerid] = i;
    new uk = WantedInfo[criminalid][wanCrime][i] - 1, qwer[74];

    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"{cccccc}%.1f\t{FF6347}%s\t{0066ff}%s",CriminalCodeInfo[uk][ccArcticle],CriminalCodeInfo[uk][ccName],WantedPolice[criminalid][i]), strcat(lines,line);
    format(line,sizeof(line),"\n{FF6347}Изъять статью из дела"), strcat(lines,line);

    format(qwer,sizeof(qwer),"{ff9000}Преступник %s[%d]",rpplayername(criminalid),criminalid);
    ShowDialog(playerid,1344,DIALOG_STYLE_TABLIST_HEADERS,qwer,lines,"Ок","");
    return 1;
}

stock ClearPlayerWantedArcticle(playerid, criminalid)
{
    if(!IsOnline(criminalid)) return ErrorMessage(playerid, "{FF6347}Ой.. кажется преступник вышел из игры");

    new i = DP[1][playerid];
    new uk = WantedInfo[criminalid][wanCrime][i] - 1;
    if(WantedInfo[criminalid][wanCrime][i] == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Статья пропала из дела");
    if(WantedInfo[criminalid][wanPoliceId][i] != PlayerInfo[playerid][pID] && PlayerInfo[playerid][pSoska] <= 1
    && PlayerInfo[playerid][pLeader] != 1 && PlayerInfo[playerid][pLeader] != 2 && PlayerInfo[playerid][pLeader] != 7 
    && PlayerInfo[playerid][pLeader] != 11 && PlayerInfo[playerid][pLeader] != 21 
    && PlayerInfo[playerid][pLeader] != 22) return ErrorMessage(playerid, "{FF6347}Вы не можете изъять эту статью из дела\n\n{ffcc66}Статью может изъять только полицейский, который её выдал или лидер");

    if(WantedInfo[criminalid][wanUnix][i] + 1200 < gettime() && PlayerInfo[playerid][pLeader] == 0 
    && PlayerInfo[playerid][pSoska] <= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете изъять статью из дела\n\n{ffcc66}Статья была выдана больше 20 минут назад");

    format(store,sizeof(store),"%f %s",CriminalCodeInfo[uk][ccArcticle],CriminalCodeInfo[uk][ccName]);
    OrgLog(fraction(playerid), "clearsu", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[criminalid][pID], PlayerInfo[criminalid][pName], PlayerInfo[criminalid][pPlaIP], 0, store);

    ClearPlayerWantedOne(criminalid, i);
    ShowPlayerWanted(playerid, criminalid);
    return 1;
}

stock ClearAllWantedPlayer(playerid)
{
    new quan;
    for(new i = 0; i < MAX_CRIME_PLAYER; i++)
	{
        if(WantedInfo[playerid][wanCrime][i] == 0) continue;
        ClearPlayerWantedOne(playerid, i);
        quan ++;
    }
    return quan;
}

stock ClearPlayerWantedOne(playerid, i)
{
    new statiya = WantedInfo[playerid][wanCrime][i];
    new zv = CriminalCodeInfo[statiya-1][ccLevel];
    new savezv = PlayerInfo[playerid][pCrimes];
    PlayerInfo[playerid][pCrimes] = savezv - zv;
    WantedInfo[playerid][wanCrime][i] = 0;
    WantedInfo[playerid][wanPoliceId][i] = 0;
    WantedInfo[playerid][wanUnix][i] = 0;
    format(WantedPolice[playerid][i], 24,"");
    if(PursuitTime[playerid] > 0)
    {
        Pursuit[i] = 9999;
        PursuitTime[i] = 0;
        TextDrawHideForPlayer(i, PursuitDraw[0]);
        TextDrawHideForPlayer(i, PursuitDraw[1]);
        TextDrawHideForPlayer(i, PursuitDraw[2]);
        PlayerTextDrawHide(i, PursDraw1);
    }
    SaveWantedPlayer(playerid, i);
    SendClientMessage(i, COLOR_GREY, "{ff0000}[ POLICE ]: {0088ff}С вас была снята последняя статья в деле.");
    return 1;
}

stock SaveWantedPlayer(playerid, i)
{
    format(big_query,sizeof(big_query),"UPDATE `pp_wanted` SET `wanCrime%d`='%d', `wanPoliceId%d`='%d', `wanUnix%d`='%d', `WantedPolice%d`='%s' WHERE `newid`='%d'", 
    i, WantedInfo[playerid][wanCrime][i], 
    i, WantedInfo[playerid][wanPoliceId][i], 
    i, WantedInfo[playerid][wanUnix][i], 
    i, WantedPolice[playerid][i], PlayerInfo[playerid][pID]);
    query_empty(pearsq, big_query);
    return 1;
}
function Call_loadwanted(playerid, race_check)
{
	new rows, string[24];
	cache_get_row_count(rows);
	if(g_MysqlRaceCheck[playerid] != race_check) return Kick(playerid);

	if(rows)
	{
        for(new i = 0; i < MAX_CRIME_PLAYER; i++)
		{
		    format(string, sizeof(string), "wanCrime%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanCrime][i]);
            format(string, sizeof(string), "wanPoliceId%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanPoliceId][i]);
            format(string, sizeof(string), "wanUnix%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanUnix][i]);
            format(string, sizeof(string), "WantedPolice%d", i);
            cache_get_value_name(i, string, WantedPolice[playerid][i], 24);
		}
	}
	else format(store, sizeof(store), "INSERT INTO `pp_wanted` SET `newid` = '%d'", PlayerInfo[playerid][pID]), query_empty(pearsq, store);

    WantedInfo[playerid][wanLoad] = false;
	return 1;
}



function Call_Wanted(playeridID,targetplayerid,playerid)
{
	new datad1,datad2,datad3,unixDB, tyear, tmonth, tday, thour, tminute, tsecond,sctring[6400];
    cache_get_value_name_int(0, "senderid", datad1);
    cache_get_value_name_int(0, "playerid", datad2);
    cache_get_value_name_int(0, "Unix", unixDB);
    cache_get_value_name_int(0, "row", datad3);
    stamp2datetime(unixDB, tyear, tmonth, tday, thour, tminute, tsecond, 3);
    printf("%d != %d",datad1,PlayerInfo[playerid][pID]);
    if (datad1 != PlayerInfo[playerid][pID]) return ErrorMessage(playerid,"Вы не можете снять последнее обвинение\nОбвинение выдано другим человеком");
    new unix = gettime();
    if(unixDB+1200 < unix) return ErrorMessage(playerid,"Вы не можете снять последнее обвинение\nпрошло более 20 минут с момента выдачи обвинения");
    if(PlayerInfo[targetplayerid][pCrimes] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У игрока нет розыска..");
    if(PlayerInfo[targetplayerid][pCrimes] >= datad3)
    {
        PlayerInfo[targetplayerid][pCrimes] -= datad3;
        format(sctring,sizeof(sctring),"UPDATE `pp_igroki` SET `Crimes` = '%d' WHERE `Name` = '%s'", PlayerInfo[targetplayerid][pCrimes], PlayerInfo[targetplayerid][pName]);
        query_empty(pearsq, sctring);
    }
    SuccessMessage(playerid,"Было снято последнее обвинение");
	return 1;
}
function Call_Wanted2(targetplayerid,playeridID)
{
	new rows, datad1[24],datad2,datad3[24],datad5, datad4, str[64],sctring[6400], tyear, tmonth, tday, thour, tminute, tsecond;
	cache_get_row_count(rows);
    printf("%d",rows);
	for(new i = 0; i < rows; i++)
	{
	    cache_get_value_name_int(i, "playerid", datad2);
	    cache_get_value_name(i, "player", datad1, 24);
        cache_get_value_name_int(i, "senderid", datad5);
	    cache_get_value_name(i, "sender", datad3, 24);
	    cache_get_value_name_int(i, "Unix", datad4);
		stamp2datetime(datad4, tyear, tmonth, tday, thour, tminute, tsecond, 3);

		format(str, sizeof(str), "%s[%d] \tОбъявлен в розыск: %02d.%02d.%d.\tОбъявитель:%s[%d]\n", datad1,datad2,datad3,datad5, tday, tmonth, tyear), strcat(sctring,str);
	}
	ShowDialog(playeridID,13000,DIALOG_STYLE_TABLIST,"{ff9000}Доска Почета",sctring,"","Выход");
	return 1;
}
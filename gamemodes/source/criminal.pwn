
#define MAX_CRIMINAL_CODE_ARTICLE 60 // Максимальное количество статьей в кодексе

enum criminalInfo
{
    ccID, // newid в базе данных
	ccArcticle[4], // Номер статьи (возможность указать плавающую точку, типо 1.1 и т.д.)
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
	format(line,sizeof(line),"Статья\tНазвание\tРозыск / Штраф"), strcat(lines,line);
	
    new quan;
    for(new i = 0; i < MAX_CRIMINAL_CODE_ARTICLE; i++)
	{
        List[quan][playerid] = i;
        quan ++;
        if(CriminalCodeInfo[i][ccType] == 0) format(line,sizeof(line),"\n{555555}\t...\t"), strcat(lines,line); // Если статья не указана, показываем пробел
        else 
        {
            if(CriminalCodeInfo[i][ccLevel] > 0) format(line,sizeof(line),"\n%s\t%s\t{FF6347}%d", ukshow(i), CriminalCodeInfo[i][ccName], CriminalCodeInfo[i][ccLevel]);
            else format(line,sizeof(line),"\n%s\t%s\t{cccccc}%d$", ukshow(i), CriminalCodeInfo[i][ccName], CriminalCodeInfo[i][ccFine]);
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
    else
    {
        format(line,sizeof(line),"%s %s\t", ukshow(i), CriminalCodeInfo[i][ccName]), strcat(lines,line);
    }
	
    // Настройки статьи
    format(line,sizeof(line),"\nОписание {ff9000}>> \t"), strcat(lines,line);

    if(CriminalCodeInfo[i][ccType] == 0) format(line,sizeof(line),"\nТип \t {555555}Не указан"), strcat(lines,line);
    else if(CriminalCodeInfo[i][ccType] == 1) format(line,sizeof(line),"\nТип \t {ff9000}Статья"), strcat(lines,line);
    else if(CriminalCodeInfo[i][ccType] == 2) format(line,sizeof(line),"\nТип \t {FDCD96}Подстатья"), strcat(lines,line);
    format(line,sizeof(line),"\nНомер \t %s", ukshow(i)), strcat(lines,line);

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

    format(line,sizeof(line),"\n%s %s\n", ukshow(i), CriminalCodeInfo[i][ccName]), strcat(lines,line);

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
    format(big_query,sizeof(big_query),"UPDATE `criminal_code` SET `ccArcticle` = '%s', `ccType` = '%d', `ccName` = '%s', `ccLevel` = '%d', `ccFine` = '%d'",
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
    	cache_get_value_name(f, "ccArcticle", CriminalCodeInfo[f][ccArcticle], 4);
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
		if(!sscanf(params, "i", params[0]))
		{
            DP[1][playerid] = 1;
            ShowPlayerWanted(playerid, params[0]);
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
            DP[1][playerid] = quan;
			format(qwer,sizeof(qwer),"{ff9000}Преступники [%d] {99ff66}Online {cccccc}[%02d.%02d.%d]",quan,day,month,year);
			ShowDialog(playerid,1342,DIALOG_STYLE_TABLIST_HEADERS,qwer,lines,"Выбрать","Выход");
		}
	}
	else ErrorMessage(playerid, "{FF6347}Вы не работаете в законной организации");
	return 1;
}

stock ShowPlayerWanted(playerid, criminalid)
{
    if(DP[1][playerid] == 0) return 0;
    if(!IsOnline(criminalid)) return ErrorMessage(playerid, "{FF6347}Ой.. кажется преступник вышел из игры");
    if(PlayerInfo[criminalid][pCrimes] == 0) return ErrorMessage(playerid, "{FF6347}Подозреваемый не находится в розыске");

    DP[0][playerid] = criminalid;
    new qwer[74], uk, quan;
    new tyear, tmonth, tday, thour, tminute, tsecond;
    format(lines,sizeof(lines),""); // Очищаем Lines
			
    format(line,sizeof(line),"{cccccc}Статья\t{cccccc}Название Статьи\t{cccccc}Полицейский\t{cccccc}Время выдачи"), strcat(lines,line);
    for(new i = 0; i < MAX_CRIME_PLAYER; i++)
    {
        List[i][playerid] = 0;
        if(WantedInfo[criminalid][wanCrime][i] == 0) continue;

        uk = WantedInfo[criminalid][wanCrime][i] - 1;
        stamp2datetime(WantedInfo[criminalid][wanUnix][i], tyear, tmonth, tday, thour, tminute, tsecond, 3);

        format(line,sizeof(line),"\n%s\t{FF6347}%s\t{0066ff}%s\t{555555}%02d.%02d.%d %02d:%02d",ukshow(uk),CriminalCodeInfo[uk][ccName],WantedPolice[criminalid][i], tday, tmonth, tyear, thour, tminute), strcat(lines,line);
        List[quan][playerid] = i;
        quan ++;
    }
    format(qwer,sizeof(qwer),"{ff9000}Преступник %s[%d]",rpplayername(criminalid),criminalid);
    ShowDialog(playerid,1343,DIALOG_STYLE_TABLIST_HEADERS,qwer,lines,"Выбрать","Назад");
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
    format(line,sizeof(line),"%s\t{FF6347}%s\t{0066ff}%s",ukshow(uk),CriminalCodeInfo[uk][ccName],WantedPolice[criminalid][i]), strcat(lines,line);
    format(line,sizeof(line),"\n{FF6347}Изъять статью из дела"), strcat(lines,line);

    format(qwer,sizeof(qwer),"{ff9000}Преступник %s[%d]",rpplayername(criminalid),criminalid);
    ShowDialog(playerid,1344,DIALOG_STYLE_TABLIST_HEADERS,qwer,lines,"Выбрать","Назад");
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

    format(store,sizeof(store),"%s %s",ukshow(uk),CriminalCodeInfo[uk][ccName]);
    OrgLog(fraction(playerid), "clearsu", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[criminalid][pID], PlayerInfo[criminalid][pName], PlayerInfo[criminalid][pPlaIP], 0, store);

    ClearPlayerWantedOne(criminalid, i);
    ShowPlayerWanted(playerid, criminalid);

    if(PursuitTime[criminalid] > 0 && PlayerInfo[criminalid][pCrimes] == 0)
    {
        Pursuit[criminalid] = 9999;
        PursuitTime[criminalid] = 0;
        TextDrawHideForPlayer(criminalid, PursuitDraw[0]);
        TextDrawHideForPlayer(criminalid, PursuitDraw[1]);
        TextDrawHideForPlayer(criminalid, PursuitDraw[2]);
        PlayerTextDrawHide(criminalid, PursDraw1);
    }
    SendClientMessage(criminalid, COLOR_GREY, "{ff0000}[ POLICE ]: {0088ff}С вас была снята статья в деле.");
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
    PlayerInfo[playerid][pCrimes] = 0;
    return quan;
}

stock ClearPlayerWantedOne(playerid, i)
{
    new uk = WantedInfo[playerid][wanCrime][i];

    PlayerInfo[playerid][pCrimes] -= CriminalCodeInfo[uk-1][ccLevel];
    WantedInfo[playerid][wanCrime][i] = 0;
    WantedInfo[playerid][wanPoliceId][i] = 0;
    WantedInfo[playerid][wanUnix][i] = 0;
    format(WantedPolice[playerid][i], 24,"");

    SaveWantedPlayer(playerid, i);
    return 1;
}

stock SaveWantedPlayer(playerid, i)
{
    format(big_query,sizeof(big_query),"UPDATE `pp_wanted` SET `wanCrime%d`='%d', `wanPoliceId%d`='%d', `wanUnix%d`='%d', `WantedPolice%d`='%s' WHERE `playerid`='%d'", 
    i, WantedInfo[playerid][wanCrime][i], 
    i, WantedInfo[playerid][wanPoliceId][i], 
    i, WantedInfo[playerid][wanUnix][i], 
    i, WantedPolice[playerid][i], PlayerInfo[playerid][pID]);
    query_empty(pearsq, big_query);

    format(store,sizeof(store),"UPDATE `pp_igroki` SET `Crimes` = '%d' WHERE `id` = '%d'", PlayerInfo[playerid][pCrimes], PlayerInfo[playerid][pID]);
	query_empty(pearsq, store);
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
            if(WantedInfo[playerid][wanCrime][i] == 0) continue;

            format(string, sizeof(string), "wanPoliceId%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanPoliceId][i]);
            format(string, sizeof(string), "wanUnix%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanUnix][i]);
            format(string, sizeof(string), "WantedPolice%d", i);
            cache_get_value_name(0, string, WantedPolice[playerid][i], 24);
		}
	}
	else format(store, sizeof(store), "INSERT INTO `pp_wanted` SET `playerid` = '%d'", PlayerInfo[playerid][pID]), query_empty(pearsq, store);

    WantedInfo[playerid][wanLoad] = false;
	return 1;
}

stock CreatePlayerPursuit(playerid, mentid)
{
    if(GetPVarInt(playerid,"afksystem") >= 5 || Pursuit[playerid] != 9999) return 0;

    SendClientMessage(playerid, COLOR_GREY, "{0066ff}[ POLICE ]: {abcdef}Вас преследует полиция. Не выходите из игры во время преследования!");

    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"{0066ff}Вас преследует полиция!"), strcat(lines,line);
    format(line,sizeof(line),"\n\n{ffcc66}Если вы выйдете из игры во время преследования, вы автоматически отправитесь в тюрьму"), strcat(lines,line);
    format(line,sizeof(line),"\n{ffcc66}Вы можете сдаться полиции или попытаться избежать ареста"), strcat(lines,line);
	ShowDialog(playerid,1982,DIALOG_STYLE_MSGBOX,"{0066ff}POLICE",lines,"*","");

    TextDrawShowForPlayer(playerid, PursuitDraw[0]);
    TextDrawShowForPlayer(playerid, PursuitDraw[1]);
    TextDrawShowForPlayer(playerid, PursuitDraw[2]);
    PlayerTextDrawShow(playerid, PursDraw1);
    Pursuit[playerid] = mentid;
    PursuitTime[playerid] = 180;

    if(mentid >= 0)
    {
        if(IsOnline(mentid))
        {
            format(store, sizeof(store), "{0066ff}[ POLICE ]: {abcdef}Преследование {0066ff}%s {abcdef}активировано", playername(playerid));
		    SendClientMessage(mentid, COLOR_GREY, store);
        }
    }
    return 1;
}

stock CreatePlayerTicket(playerid, mentid, zv, uk)
{
    PlayerInfo[playerid][pAmmos11] += CriminalCodeInfo[uk][ccFine];

    if(zv == 0)
    {
        format(store, sizeof(store), "{0066ff}[ POLICE ]: {abcdef}%s выписал%s вам штраф в размере {FF6347}%d$", rpplayername(mentid), gender(mentid), CriminalCodeInfo[uk][ccFine]);
        SendClientMessage(playerid, COLOR_GREY, store);

        format(lines,sizeof(lines),""); // Очищаем Lines
        format(line,sizeof(line),"{0066ff}Вам выписан штраф в размере {FF6347}%d$", CriminalCodeInfo[uk][ccFine]), strcat(lines,line);
        format(line,sizeof(line),"\n\n{ffcc66}Вы можете оплатить его в любом банкомате"), strcat(lines,line);
        format(line,sizeof(line),"\n{ffcc66}За длительную неуплату штрфов, вы будете арестованы"), strcat(lines,line);
        ShowDialog(playerid,1982,DIALOG_STYLE_MSGBOX,"{0066ff}POLICE",lines,"*","");
    }
    return 1;
}

stock ukshow(uk)
{
    new uktext[16];
    if(CriminalCodeInfo[uk][ccType] == 1) // Основная Статья
    {
        format(uktext,sizeof(uktext),"{ff9000}%s", CriminalCodeInfo[uk][ccArcticle]);
    }
    else if(CriminalCodeInfo[uk][ccType] == 2) // Подстатья имеет плавающую точку (Пример 1.2)
    {
        format(uktext,sizeof(uktext),"{FDCD96}%s", CriminalCodeInfo[uk][ccArcticle]);
    }
    return uktext;
}

CMD:su(playerid, const params[])
{
	if(IsACop(playerid) || PlayerInfo[playerid][pFbi] >= 1)
	{
	    if(howstun(playerid)) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
		if(PlayerInfo[playerid][pMember] == 3 || PlayerInfo[playerid][pLeader] == 3) return ErrorMessage(playerid, "{FF6347}Бойцам национальной гвардии запрещено выдавать розыск");
		new r = PlayerInfo[playerid][pRank], g = fraction(playerid), string[114];
	    if(PlayerInfo[playerid][pFbi] > 0) r = PlayerInfo[playerid][pFbi], g = 2;
	    if(r < OrganInfo[g][gAcc][32]) return format(string,sizeof(string),"{FF6347}Вы не можете выполнить это действие [ %d+ Ранг ]",OrganInfo[g][gAcc][32]), ErrorMessage(playerid, string);
    	
		new playa,tmp[121],article[4];
        if(!sscanf(params, "s[121]s[4]", tmp, article)) // Указываем Ник и Номер статьи
		{
            if(!CheckWarningSu(playerid, tmp, playa)) return 1;
			new findUk = -1;
			for(new i = 0; i < MAX_CRIMINAL_CODE_ARTICLE; i++)
			{
				if(CriminalCodeInfo[i][ccType] == 0) continue;
				if(strfind(CriminalCodeInfo[i][ccArcticle], article,true) != (-1))
				{
					findUk = i;
					break;
				}
			}

			if(findUk == -1) return ErrorMessage(playerid, "{FF6347}Номер статьи не найден");
			if(CriminalCodeInfo[findUk][ccLevel] == 0) return ErrorMessage(playerid, "{FF6347}У этой статьи не предусмотрен уровень розыска");
			SetPlayerCriminal(1,playa, playerid,CriminalCodeInfo[findUk][ccName],CriminalCodeInfo[findUk][ccLevel], findUk);
		}
		else if(!sscanf(params, "s[121]", tmp)) // Указываем только ник или ID
		{
			if(!CheckWarningSu(playerid, tmp, playa)) return 1;
			DP[3][playerid] = playa;
			CriminalCodeMenu(playerid, 1);
		}
        else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать розыск подозреваемому [ /su ID или Ник (Номер статьи - не обязательно) ]");
	}
	else ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	return 1;
}
stock CheckWarningSu(playerid, const tmp[], &playa)
{
	if(strlen(tmp) > 20) 
	{
		ErrorMessage(playerid, "{FF6347}Слишком длинное имя.. [ Лимит 20 символов ]");
		return 0;
	}
	playa = ReturnUser(tmp);
	if(!IsPlayerConnected(playa))
	{
		ErrorMessage(playerid, "{FF6347}Игрока нет на сервере");
		return 0;
	}
	if(IsACapt(playa))
	{
		ErrorMessage(playerid, "{FF6347}Подозреваемый находится в гетто {ff0000}[ Работа на Капте - Запрещена ]");
		return 0;
	}
	return 1;
}

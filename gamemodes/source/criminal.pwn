
#define MAX_CRIMINAL_CODE_ARTICLE 80 // Максимальный набор статьей в кодексе
#define MAX_CRIMINAL_CODE_SUBENTRY 20 // Максимальное количество статей в наборе

enum criminalInfo
{
    ccID, // newid в базе данных
	ccArcticle[8], // Номер статьи (возможность указать плавающую точку, типо 1.1 и т.д.)
    bool:ccStatus, // Существует статья или нет
	ccName[31], // Название статьи
	ccLevel, // Уровень розыска статьи
    ccFine, // Штраф 
	ccText[121], // Описание статьи
    ccUnix, // Дата и время последнего изменения статьи
    ccPlayer[21], // Никнейм игрока, который последний раз изменял статью
    ccUserID // ID аккаунта игрока, который последний раз изменял статью
};
new CriminalCodeInfo[MAX_CRIMINAL_CODE_ARTICLE][MAX_CRIMINAL_CODE_SUBENTRY][criminalInfo];

CMD:yk(playerid) return cmd_criminal(playerid);
CMD:uk(playerid) return cmd_criminal(playerid);
CMD:criminal(playerid)
{
	CriminalCodeMenu(playerid, 0, 0);
	PlayerPlaySound(playerid,40405,0,0,0);
	return 1;
}

stock GetFreeArcticle()
{
    new findI = -1;
    for(new i = 0; i < MAX_CRIMINAL_CODE_ARTICLE; i++)
	{
        if(CriminalCodeInfo[i][0][ccStatus] == false)
        {
            findI = i;
            break;
        }
    }
    return findI;
}

stock GetFreeSubentry(i)
{
    new pi = 1;
    for(new p = 0; p < MAX_CRIMINAL_CODE_SUBENTRY; p++)
	{
        if(CriminalCodeInfo[i][p][ccStatus] == false)
        {
            pi = p;
            break;
        }
    }
    return pi;
}

stock CriminalCodeMenu(playerid, inject, page) // Меню кодекса
{
    new max_line = 8, minlist, thisPage, yesNext;

    new line[214],lines[4096];
	format(line,sizeof(line),"Статья\tНазвание\tРозыск\tШтраф"), strcat(lines,line);
	
    // Настраиваем отображение фильтров и страниц
	LoadPageSorting(playerid, 1306, MAX_CRIMINAL_CODE_ARTICLE, minlist, page, thisPage);

    new quan;
    if(inject == 0)
    {   
        DP[4][playerid] = 0;

        format(line,sizeof(line),"\n{99ff66}Добавить Статью >>\t \t \t ");
        strcat(lines,line);
    }
    else
    {
        DP[4][playerid] = 1;
    }

    new one;
    new textCrime[4], textFine[24];
    for(new i = minlist; i < MAX_CRIMINAL_CODE_ARTICLE; i++)
	{
        if(CriminalCodeInfo[i][0][ccStatus] == true) // Только если основная статья существует
        {
		    if(one == 0) OnlineInfo[playerid][oDialogMenu][4] = i, one = 1; // Записывали первый list
            
            for(new p = 0; p < MAX_CRIMINAL_CODE_SUBENTRY; p++)
	        {
                if(CriminalCodeInfo[i][p][ccStatus] == false) continue;
                List[quan][playerid] = i;
                ListParam[quan][playerid] = p;
                quan ++;

                if(CriminalCodeInfo[i][p][ccLevel] > 0) format(textCrime,sizeof(textCrime),"%d", CriminalCodeInfo[i][p][ccLevel]);
                else format(textCrime,sizeof(textCrime)," ");

                if(CriminalCodeInfo[i][p][ccFine] > 0) format(textFine,sizeof(textFine),"%d$", CriminalCodeInfo[i][p][ccFine]);
                else format(textFine,sizeof(textFine)," ");

                format(line,sizeof(line),"\n%s%s\t%s%s\t{FF6347}%s\t{FF6347}%s", ukshow(p), CriminalCodeInfo[i][p][ccArcticle], ukshow(p), CriminalCodeInfo[i][p][ccName], textCrime, textFine);
                strcat(lines,line);

                OnlineInfo[playerid][oDialogMenu][0] ++; // Подсчитываем строки
            }

            OnlineInfo[playerid][oDialogMenu][7] ++; // Подсчитываем главы
            OnlineInfo[playerid][oDialogMenu][2] = i;

            if(OnlineInfo[playerid][oDialogMenu][7] >= max_line) // Сбрасываем дальнейший вывод глав, если дошли до лимита на странице
            {
                yesNext = 1;
                break;
            }
            if(page > 0 
                && (i > MAX_CRIMINAL_CODE_ARTICLE // Последняя доступна глава
                    || i < MAX_CRIMINAL_CODE_ARTICLE && CriminalCodeInfo[i + 1][0][ccStatus] == false)) // Последняя заполненная глава
            {
                yesNext = 1; // Последний транспорт, отображаем Next Page
                OnlineInfo[playerid][oDialogMenu][5] = 1; // Записываем, что эта страница была последней
            }
        }
	}

	if(yesNext == 1) format(line,sizeof(line),"\n{cccccc}Next Page >>\t\t\t"), strcat(lines,line);
    ShowDialog(playerid,1306,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Кодекс Правонарушений",lines,"Выбрать","Выход");
    return 1;
}

stock CriminalCodeSetting(playerid, i, p) // Меню редактора статьи
{
    if(i < 0 || i >= MAX_CRIMINAL_CODE_ARTICLE
        || p < 0 || p >= MAX_CRIMINAL_CODE_SUBENTRY) return 0; // Защищаем от невалидного id статьи (малоли че)

    if(PlayerInfo[playerid][pSoska] >= 10 || PlayerInfo[playerid][pLeader] == 7
    || PlayerInfo[playerid][pMember] == 7 && PlayerInfo[playerid][pRank] >= 16) // Могут редактировать статью
    {
        DP[1][playerid] = 1;
    }
    else // Только просматривать
    {
        if(CriminalCodeInfo[i][p][ccStatus] == false) return ErrorMessage(playerid, "{FF6347}Вы не можете добавлять новую статью");
        DP[1][playerid] = 0;
        ShowDialogCriminalCodeInfo(playerid, i, p);
        return 1;
    }


    new line[100], lines[900], text[12];
    format(text,sizeof(text),"%s", CriminalCodeInfo[i][p][ccText]);

    // Формируем заголовок
    if(CriminalCodeInfo[i][p][ccStatus] == false) 
    {
        format(line,sizeof(line),"...\t "), strcat(lines,line);
        format(line,sizeof(line),"\nСтатус: \t{FF6347}[ Off ]"), strcat(lines,line);
    }
    else
    {
        format(line,sizeof(line),"%s%s %s\t ", ukshow(p), CriminalCodeInfo[i][p][ccArcticle], CriminalCodeInfo[i][p][ccName]), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}Статус: \t{99ff66}[ On ]"), strcat(lines,line);
    }
	format(line,sizeof(line),"\n{cccccc}Номер: \t %s", CriminalCodeInfo[i][p][ccArcticle]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Название: \t %s", CriminalCodeInfo[i][p][ccName]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Розыск: \t {FF6347}%d", CriminalCodeInfo[i][p][ccLevel]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Штраф: \t {FF6347}%d$", CriminalCodeInfo[i][p][ccFine]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Текст: \t %s...", text), strcat(lines,line);
    format(line,sizeof(line),"\n%sИнформация >> \t ", ukshow(p)), strcat(lines,line);

    if(p == 0 && CriminalCodeInfo[i][p][ccStatus] == true) format(line,sizeof(line),"\n{99ff66}Добавить подстатью >> \t"), strcat(lines,line);
    ShowDialog(playerid,1307,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Кодекс Правонарушений",lines,"Выбрать","Выход");
    return 1;
}

stock ShowDialogCriminalCodeInfo(playerid, i, p)
{
    if(CriminalCodeInfo[i][p][ccStatus] == false) return ErrorText(playerid, "[ Мысли ]: Эта статья не активирована"), showDialogCriminalCode(playerid);

    new line[140],lines[800];
    format(line,sizeof(line),"\n%s%s %s\n", ukshow(p), CriminalCodeInfo[i][p][ccArcticle], CriminalCodeInfo[i][p][ccName]), strcat(lines,line);

    if(CriminalCodeInfo[i][p][ccLevel] >= 1)
    {
        format(line,sizeof(line),"\n{cccccc}Уровень Розыска: {FF6347}%d {666666}[ Время Ареста: %d минут | При выходе из игры при аресте: %d минут ]", CriminalCodeInfo[i][p][ccLevel], CriminalCodeInfo[i][p][ccLevel]*10, CriminalCodeInfo[i][p][ccLevel]*20), strcat(lines,line);
    }
    else format(line,sizeof(line),"\n{cccccc}Уровень Розыска: {666666}Эта статья не предусматривает ареста"), strcat(lines,line);

    if(CriminalCodeInfo[i][p][ccFine] > 0) format(line,sizeof(line),"\nШтраф: {FF6347}%d$", CriminalCodeInfo[i][p][ccFine]), strcat(lines,line);
    else format(line,sizeof(line),"\nШтраф: {666666}Эта статья не имеет штрафа"), strcat(lines,line);

    format(line,sizeof(line),"\n\n{cccccc}%s",CriminalCodeInfo[i][p][ccText]), strcat(lines,line);

    new tyear, tmonth, tday, thour, tminute, tsecond;
	stamp2datetime(CriminalCodeInfo[i][p][ccUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
    format(line,sizeof(line),"\n\n{555555}Редактировал"), strcat(lines,line);
    format(line,sizeof(line),"\n{555555}%s %02d.%02d.%d %02d:%02d\n", CriminalCodeInfo[i][p][ccPlayer], tday, tmonth, tyear, thour, tminute), strcat(lines,line);
    ShowDialog(playerid,1308,DIALOG_STYLE_MSGBOX,"{ff9000}Кодекс Правонарушений {cccccc}[Описание статьи]",lines,"*","");
    return 1;
}

stock showDialogCriminalCode(playerid) // При возврате меню или выводе ошибки, открываем предыдущее меню
{
    if(DP[1][playerid] == 1) CriminalCodeSetting(playerid, DP[0][playerid], DP[2][playerid]); // Если доступ к редактированию имеется, значит открываем меню редактора статьи
    else CriminalCodeMenu(playerid, 0, OnlineInfo[playerid][oDialogMenu][1]); // Если нет доступа, открываем просто список всех статей
    return 1;
}

stock CriminalCodeUpdate(playerid, i, p) // Записываем необходимую инфу и отправляем на сохранение в базу
{
    format(CriminalCodeInfo[i][p][ccPlayer], 21, "%s", PlayerInfo[playerid][pName]); // Записываем имя чела
    CriminalCodeInfo[i][p][ccUserID] = PlayerInfo[playerid][pID]; // Записываем номер аккаунта чела
    CriminalCodeInfo[i][p][ccUnix] = gettime(); // Записываем unix
    CriminalCodeSave(i, p); // Сохраняемс
    return 1;
}

stock CriminalCodeSave(i, p) // Сохраняем в базу (моментальное сохранение при любом изменении)
{
    // Экранируем текстовые строки (Для защиты от sql инъекций)
    new escapeName[31], escapeText[121];
	mysql_escape_string(CriminalCodeInfo[i][p][ccName], escapeName, sizeof(escapeName));
    mysql_escape_string(CriminalCodeInfo[i][p][ccText], escapeText, sizeof(escapeText));

    // Формируем запрос в переменную
    new string_mysql[600];

    if(CriminalCodeInfo[i][p][ccID] == 0)
    {
        format(string_mysql,sizeof(string_mysql),"INSERT INTO `criminal_code` (ccI, ccP, ccStatus, ccArcticle, ccName, ccLevel, ccFine,\
            ccText, ccUnix, ccPlayer, ccUserID) VALUES ('%d', '%d', '%d', '%s', '%s', '%d', '%d', '%s', '%d', '%s', '%d')",
        i, p, CriminalCodeInfo[i][p][ccStatus], CriminalCodeInfo[i][p][ccArcticle], escapeName, CriminalCodeInfo[i][p][ccLevel], CriminalCodeInfo[i][p][ccFine], 
        escapeText, CriminalCodeInfo[i][p][ccUnix], CriminalCodeInfo[i][p][ccPlayer], CriminalCodeInfo[i][p][ccUserID]);
        mysql_tquery(pearsq, string_mysql, "Call_InsertCriminal", "dd", i, p);
    }
    else
    {
        format(string_mysql,sizeof(string_mysql),"UPDATE `criminal_code` SET `ccStatus` = '%d', `ccArcticle` = '%s', `ccName` = '%s', `ccLevel` = '%d', `ccFine` = '%d',\
            `ccText` = '%s', `ccUnix` = '%d', `ccPlayer` = '%s', `ccUserID` = '%d' WHERE `newid` = '%d'",
        CriminalCodeInfo[i][p][ccStatus], CriminalCodeInfo[i][p][ccArcticle], escapeName, CriminalCodeInfo[i][p][ccLevel], CriminalCodeInfo[i][p][ccFine], 
        escapeText, CriminalCodeInfo[i][p][ccUnix], CriminalCodeInfo[i][p][ccPlayer], CriminalCodeInfo[i][p][ccUserID], 
        CriminalCodeInfo[i][p][ccID]);

        query_empty(pearsq, string_mysql);
    }
    return 1;
}

function Call_InsertCriminal(i, p)
{
    CriminalCodeInfo[i][p][ccID] = cache_insert_id();
    return 1;
}

forward LoadCriminalCode(); // Загрузка из базы
public LoadCriminalCode()
{
	new time = GetTickCount();
    new rows;
	cache_get_row_count(rows);
	for(new f; f < rows; ++f) //  Плевать на то, сколько этих строк в базе. Мы делаем цикл до максимального числа в дефайне переменной
	{
        new i, p, bool:status;
        cache_get_value_name_int(f, "ccI", i);
        cache_get_value_name_int(f, "ccP", p);
        cache_get_value_name_bool(f, "ccStatus", status);

        if(status == false || i >= MAX_CRIMINAL_CODE_ARTICLE
            || p >= MAX_CRIMINAL_CODE_SUBENTRY) continue;
        PutSubentryLoad(f, i, p, status);
	}
	printf("[MODE]: Кодекс Правонарушений [%d ms]", GetTickCount() - time);
	return 1;
}

stock PutSubentryLoad(f, i, p, bool:status)
{
    CriminalCodeInfo[i][p][ccStatus] = status;
    cache_get_value_name_int(f, "newid", CriminalCodeInfo[i][p][ccID]);
    cache_get_value_name(f, "ccArcticle", CriminalCodeInfo[i][p][ccArcticle], 8);
    cache_get_value_name(f, "ccName", CriminalCodeInfo[i][p][ccName], 31);
    cache_get_value_name_int(f, "ccLevel", CriminalCodeInfo[i][p][ccLevel]);
    cache_get_value_name_int(f, "ccFine", CriminalCodeInfo[i][p][ccFine]);
    cache_get_value_name(f, "ccText", CriminalCodeInfo[i][p][ccText], 121);
    cache_get_value_name_int(f, "ccUnix", CriminalCodeInfo[i][p][ccUnix]);
    cache_get_value_name(f, "ccPlayer", CriminalCodeInfo[i][p][ccPlayer], 21);
    cache_get_value_name_int(f, "ccUserID", CriminalCodeInfo[i][p][ccUserID]);
    return 1;
}


#define MAX_CRIME_PLAYER 10

enum wantedInfo
{
    wanCrime[MAX_CRIME_PLAYER], // id статей
    wanSubentry[MAX_CRIME_PLAYER], // id подстатей
    wanPoliceId[MAX_CRIME_PLAYER], // userid полицейского
    wanUnix[MAX_CRIME_PLAYER], // unix, когда выдали розыск

    wanTicketCrime[MAX_CRIME_PLAYER], // id статей штрафа
    wanTicketSubentry[MAX_CRIME_PLAYER], // id подстатей штрафа
    wanTicketPoliceId[MAX_CRIME_PLAYER], //  userid полицейского
    wanTicketUnix[MAX_CRIME_PLAYER], // unix, когда выдали розыск
    bool:wanLoad // Загрузка розыска из базы
};
new WantedInfo[MAX_REALPLAYERS][wantedInfo];
new WantedPolice[MAX_REALPLAYERS][MAX_CRIME_PLAYER][24]; // имя мента, который выдал розыск
new TicketPolice[MAX_REALPLAYERS][MAX_CRIME_PLAYER][24]; // имя мента, который выдал штраф

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

            new line[214],lines[4096];
			format(line,sizeof(line),"{cccccc}Имя\t{FF6347}Розыск\n"), strcat(lines,line);
			foreach(Player, i)
			{
                List[i][playerid] = 0;
				if(PlayerInfo[i][pCrimes] > 0 && ADUTY[i] == 0 && OnlineInfo[i][oLogged] == 1 && PlayerInfo[i][pJailed] == 0)
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

CMD:ticket(playerid, const params[]) return cmd_tickets(playerid, params);
CMD:tickets(playerid, const params[])
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

            new line[214],lines[4096];
			format(line,sizeof(line),"{cccccc}Имя\t{FF6347}Сумма Штрафов\n"), strcat(lines,line);
			foreach(Player, i)
			{
                List[i][playerid] = 0;
				if(PlayerInfo[i][pAmmos11] > 0 && OnlineInfo[i][oLogged] == 1)
                {
                    format(line,sizeof(line),"{cccccc}%s[%d]\t{FF6347}%d$\n",rpplayername(i),i,PlayerInfo[i][pAmmos11]), strcat(lines,line);
                    List[quan][playerid] = i;
                    quan ++;
                }
            }
            DP[1][playerid] = quan;
			format(qwer,sizeof(qwer),"{ff9000}Оштрафованные [%d] {99ff66}Online {cccccc}[%02d.%02d.%d]",quan,day,month,year);
			ShowDialog(playerid,1346,DIALOG_STYLE_TABLIST_HEADERS,qwer,lines,"Выбрать","Выход");
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
    new line[214],lines[4096];
			
    format(line,sizeof(line),"{cccccc}Статья\t{cccccc}Название Статьи\t{cccccc}Полицейский\t{cccccc}Время выдачи"), strcat(lines,line);
    for(new i = 0; i < MAX_CRIME_PLAYER; i++)
    {
        List[i][playerid] = 0;
        if(WantedInfo[criminalid][wanCrime][i] == 0) continue;

        uk = WantedInfo[criminalid][wanCrime][i] - 1;
        new p = WantedInfo[criminalid][wanSubentry][i];
        stamp2datetime(WantedInfo[criminalid][wanUnix][i], tyear, tmonth, tday, thour, tminute, tsecond, 3);

        format(line,sizeof(line),"\n{ff9000}%s\t{FF6347}%s\t{0066ff}%s\t{555555}%02d.%02d.%d %02d:%02d",CriminalCodeInfo[uk][p][ccArcticle],
            CriminalCodeInfo[uk][p][ccName],WantedPolice[criminalid][i], tday, tmonth, tyear, thour, tminute), strcat(lines,line);
        List[quan][playerid] = i;
        quan ++;
    }
    format(qwer,sizeof(qwer),"{ff9000}Преступник %s[%d]",rpplayername(criminalid),criminalid);
    ShowDialog(playerid,1343,DIALOG_STYLE_TABLIST_HEADERS,qwer,lines,"Выбрать","Назад");
    return 1;
}

stock ShowPlayerTicket(playerid, criminalid)
{
    if(DP[1][playerid] == 0) return 0;
    if(!IsOnline(criminalid)) return ErrorMessage(playerid, "{FF6347}Ой.. кажется оштрафованный вышел из игры");

    DP[0][playerid] = criminalid;
    new qwer[74], uk, quan;
    new tyear, tmonth, tday, thour, tminute, tsecond;
    new line[214],lines[4096];
			
    format(line,sizeof(line),"{cccccc}Статья\t{cccccc}Название Статьи\t{cccccc}Полицейский\t{cccccc}Время выдачи"), strcat(lines,line);
    for(new i = 0; i < MAX_CRIME_PLAYER; i++)
    {
        List[i][playerid] = 0;
        if(WantedInfo[criminalid][wanTicketCrime][i] == 0) continue;

        uk = WantedInfo[criminalid][wanTicketCrime][i] - 1;
        new p = WantedInfo[criminalid][wanTicketSubentry][i];
        stamp2datetime(WantedInfo[criminalid][wanTicketUnix][i], tyear, tmonth, tday, thour, tminute, tsecond, 3);

        format(line,sizeof(line),"\n{ff9000}%s\t{FF6347}%s\t{0066ff}%s\t{555555}%02d.%02d.%d %02d:%02d",CriminalCodeInfo[uk][p][ccArcticle],
            CriminalCodeInfo[uk][p][ccName],TicketPolice[criminalid][i], tday, tmonth, tyear, thour, tminute), strcat(lines,line);
        List[quan][playerid] = i;
        quan ++;
    }
    format(qwer,sizeof(qwer),"{ff9000}Оштрафованный %s[%d]",rpplayername(criminalid),criminalid);
    ShowDialog(playerid,1347,DIALOG_STYLE_TABLIST_HEADERS,qwer,lines,"Выбрать","Назад");
    return 1;
}

stock ShowPlayerSettingTicket(playerid, i)
{
    new criminalid = DP[0][playerid];
    if(!IsOnline(criminalid)) return ErrorMessage(playerid, "{FF6347}Ой.. кажется Оштрафованный вышел из игры");
    if(WantedInfo[criminalid][wanTicketCrime][i] == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Штраф пропал из дела");

    DP[1][playerid] = i;
    new uk = WantedInfo[criminalid][wanTicketCrime][i] - 1, qwer[74];
    new p = WantedInfo[criminalid][wanTicketSubentry][i];

    new line[150],lines[300];
    format(line,sizeof(line),"%s\t{FF6347}%s\t{0066ff}%s",CriminalCodeInfo[uk][p][ccArcticle],CriminalCodeInfo[uk][p][ccName],TicketPolice[criminalid][i]), strcat(lines,line);
    format(line,sizeof(line),"\n{FF6347}Изъять штраф из дела"), strcat(lines,line);

    format(qwer,sizeof(qwer),"{ff9000}Оштрафованный %s[%d]",rpplayername(criminalid),criminalid);
    ShowDialog(playerid,1348,DIALOG_STYLE_TABLIST_HEADERS,qwer,lines,"Выбрать","Назад");
    return 1;
}
stock ClearPlayerTicketArcticle(playerid, criminalid)
{
    if(!IsOnline(criminalid)) return ErrorMessage(playerid, "{FF6347}Ой.. кажется оштрафованный вышел из игры");

    new i = DP[1][playerid];
    new uk = WantedInfo[criminalid][wanTicketCrime][i] - 1;
    new p = WantedInfo[criminalid][wanTicketSubentry][i];
    if(WantedInfo[criminalid][wanTicketCrime][i] == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Штраф пропал из дела");
    if(WantedInfo[criminalid][wanTicketPoliceId][i] != PlayerInfo[playerid][pID] && PlayerInfo[playerid][pSoska] <= 1
    && PlayerInfo[playerid][pLeader] != 1 && PlayerInfo[playerid][pLeader] != 2 && PlayerInfo[playerid][pLeader] != 7 
    && PlayerInfo[playerid][pLeader] != 11 && PlayerInfo[playerid][pLeader] != 21 
    && PlayerInfo[playerid][pLeader] != 22) return ErrorMessage(playerid, "{FF6347}Вы не можете изъять этот штраф из дела\n\n{ffcc66}Штраф может изъять только полицейский, который её выдал или лидер");

    if(WantedInfo[criminalid][wanUnix][i] + 1200 < gettime() && PlayerInfo[playerid][pLeader] == 0 
    && PlayerInfo[playerid][pSoska] <= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете изъять штраф из дела\n\n{ffcc66}Штраф была выдана больше 20 минут назад");

    new string[80];
    format(string,sizeof(string),"%s %s", CriminalCodeInfo[uk][p][ccArcticle],CriminalCodeInfo[uk][p][ccName]);
    OrgLog(fraction(playerid), "clearsu", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[criminalid][pID], PlayerInfo[criminalid][pName], PlayerInfo[criminalid][pPlaIP], 0, string);

    ClearPlayerTicketOne(criminalid, i);
    ShowPlayerTicket(playerid, criminalid);

    SendClientMessage(criminalid, COLOR_GREY, "{ff0000}[ POLICE ]: {0088ff}С вас была снят штраф в деле.");
    return 1;
}
stock ShowPlayerSettingWanted(playerid, i)
{
    new criminalid = DP[0][playerid];
    if(!IsOnline(criminalid)) return ErrorMessage(playerid, "{FF6347}Ой.. кажется преступник вышел из игры");
    if(WantedInfo[criminalid][wanCrime][i] == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Статья пропала из дела");

    DP[1][playerid] = i;
    new uk = WantedInfo[criminalid][wanCrime][i] - 1, qwer[74];
    new p = WantedInfo[criminalid][wanSubentry][i];

    new line[150],lines[300];
    format(line,sizeof(line),"%s\t{FF6347}%s\t{0066ff}%s",CriminalCodeInfo[uk][p][ccArcticle],CriminalCodeInfo[uk][p][ccName],WantedPolice[criminalid][i]), strcat(lines,line);
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
    new p = WantedInfo[criminalid][wanSubentry][i];

    if(WantedInfo[criminalid][wanCrime][i] == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Статья пропала из дела");
    if(WantedInfo[criminalid][wanPoliceId][i] != PlayerInfo[playerid][pID] && PlayerInfo[playerid][pSoska] <= 1
    && PlayerInfo[playerid][pLeader] != 1 && PlayerInfo[playerid][pLeader] != 2 && PlayerInfo[playerid][pLeader] != 7 
    && PlayerInfo[playerid][pLeader] != 11 && PlayerInfo[playerid][pLeader] != 21 
    && PlayerInfo[playerid][pLeader] != 22) return ErrorMessage(playerid, "{FF6347}Вы не можете изъять эту статью из дела\n\n{ffcc66}Статью может изъять только полицейский, который её выдал или лидер");

    if(WantedInfo[criminalid][wanUnix][i] + 1200 < gettime() && PlayerInfo[playerid][pLeader] == 0 
    && PlayerInfo[playerid][pSoska] <= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете изъять статью из дела\n\n{ffcc66}Статья была выдана больше 20 минут назад");

    new string[80];
    format(string,sizeof(string),"%s %s",CriminalCodeInfo[uk][p][ccArcticle],CriminalCodeInfo[uk][p][ccName]);
    OrgLog(fraction(playerid), "clearsu", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[criminalid][pID], PlayerInfo[criminalid][pName], PlayerInfo[criminalid][pPlaIP], 0, string);

    ClearPlayerWantedOne(criminalid, i);
    ShowPlayerWanted(playerid, criminalid);

    if(PursuitTime[criminalid] > 0 && PlayerInfo[criminalid][pCrimes] == 0) DestroyPursuit(criminalid);

    if(PlayerInfo[playerid][pSoska] > 0) SendClientMessage(criminalid, COLOR_GREY, "{ff0000}[ POLICE ]: {0088ff}Администратор удалил статью из вашего дела");
    else SendClientMessage(criminalid, COLOR_GREY, "{ff0000}[ POLICE ]: {0088ff}Из вашего дела изъята статья");
    return 1;
}

stock ClearAllWantedPlayer(playerid)
{
    mysql_tquery(pearsq, "START TRANSACTION;");
    new quan;
    for(new i = 0; i < MAX_CRIME_PLAYER; i++)
	{
        if(WantedInfo[playerid][wanCrime][i] == 0) continue;
        ClearPlayerWantedOne(playerid, i);
        quan ++;
    }
    mysql_tquery(pearsq, "COMMIT;");

    PlayerInfo[playerid][pCrimes] = 0;
    return quan;
}

stock ClearAllTicketPlayer(playerid)
{
	mysql_tquery(pearsq, "START TRANSACTION;");
    new quan;
    for(new i = 0; i < MAX_CRIME_PLAYER; i++)
	{
        if(WantedInfo[playerid][wanTicketCrime][i] == 0) continue;
        ClearPlayerTicketOne(playerid, i);
        quan ++;
    }
	mysql_tquery(pearsq, "COMMIT;");

    PlayerInfo[playerid][pAmmos11] = 0;
    return quan;
}

stock ClearPlayerWantedOne(playerid, i)
{
    new uk = WantedInfo[playerid][wanCrime][i];
    new p = WantedInfo[playerid][wanSubentry][i];

    PlayerInfo[playerid][pCrimes] -= CriminalCodeInfo[uk-1][p][ccLevel];
    WantedInfo[playerid][wanCrime][i] = 0;
    WantedInfo[playerid][wanSubentry][i] = 0;
    WantedInfo[playerid][wanPoliceId][i] = 0;
    WantedInfo[playerid][wanUnix][i] = 0;
    format(WantedPolice[playerid][i], 24,"");

    SaveWantedPlayer(playerid, i);
    return 1;
}
stock ClearPlayerTicketOne(playerid, i)
{
    new uk = WantedInfo[playerid][wanTicketCrime][i];
    new p = WantedInfo[playerid][wanTicketSubentry][i];

    if(PlayerInfo[playerid][pAmmos11] - CriminalCodeInfo[uk-1][p][ccFine] <= 0) PlayerInfo[playerid][pAmmos11] = 0; 
    else PlayerInfo[playerid][pAmmos11] -= CriminalCodeInfo[uk-1][p][ccFine];
    WantedInfo[playerid][wanTicketCrime][i] = 0;
    WantedInfo[playerid][wanTicketSubentry][i] = 0;
    WantedInfo[playerid][wanTicketPoliceId][i] = 0;
    WantedInfo[playerid][wanTicketUnix][i] = 0;
    format(TicketPolice[playerid][i], 24,"");

    SaveTicketPlayer(playerid, i);
    return 1;
}

stock SaveTicketPlayer(playerid, i)
{
    new string_mysql[400];
    format(string_mysql,sizeof(string_mysql),"UPDATE `pp_wanted` SET `wanTicketCrime%d`='%d', `wanTicketSubentry%d`='%d', `wanTicketPoliceId%d`='%d', `wanTicketUnix%d`='%d', \
        `WantedTicketPolice%d`='%s' WHERE `playerid`='%d'", 
    i, WantedInfo[playerid][wanTicketCrime][i], 
    i, WantedInfo[playerid][wanTicketSubentry][i], 
    i, WantedInfo[playerid][wanTicketPoliceId][i], 
    i, WantedInfo[playerid][wanTicketUnix][i], 
    i, TicketPolice[playerid][i], PlayerInfo[playerid][pID]);
    query_empty(pearsq, string_mysql);

    format(string_mysql,sizeof(string_mysql),"UPDATE `pp_igroki` SET `Ammo11` = '%d' WHERE `user_id` = '%d'", PlayerInfo[playerid][pAmmos11], PlayerInfo[playerid][pID]);
	query_empty(pearsq, string_mysql);
    return 1;
}

stock SaveWantedPlayer(playerid, i)
{
    new string_mysql[400];
    format(string_mysql,sizeof(string_mysql),"UPDATE `pp_wanted` SET `wanCrime%d`='%d', `wanSubentry%d`='%d', `wanPoliceId%d`='%d', `wanUnix%d`='%d', `WantedPolice%d`='%s' WHERE `playerid`='%d'", 
    i, WantedInfo[playerid][wanCrime][i], 
    i, WantedInfo[playerid][wanSubentry][i], 
    i, WantedInfo[playerid][wanPoliceId][i], 
    i, WantedInfo[playerid][wanUnix][i], 
    i, WantedPolice[playerid][i], PlayerInfo[playerid][pID]);
    query_empty(pearsq, string_mysql);

    format(string_mysql,sizeof(string_mysql),"UPDATE `pp_igroki` SET `Crimes` = '%d' WHERE `user_id` = '%d'", PlayerInfo[playerid][pCrimes], PlayerInfo[playerid][pID]);
	query_empty(pearsq, string_mysql);
    return 1;
}
function Call_loadwanted(playerid, race_check)
{
	new rows, string[24];
	cache_get_row_count(rows);
	if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);

	if(rows)
	{
        for(new i = 0; i < MAX_CRIME_PLAYER; i++)
		{
		    format(string, sizeof(string), "wanCrime%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanCrime][i]);
            if(WantedInfo[playerid][wanCrime][i] == 0) continue;

            format(string, sizeof(string), "wanSubentry%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanSubentry][i]);
            format(string, sizeof(string), "wanPoliceId%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanPoliceId][i]);
            format(string, sizeof(string), "wanUnix%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanUnix][i]);
            format(string, sizeof(string), "WantedPolice%d", i);
            cache_get_value_name(0, string, WantedPolice[playerid][i], 24);

            format(string, sizeof(string), "wanTicketCrime%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanTicketCrime][i]);
            if(WantedInfo[playerid][wanCrime][i] == 0) continue;

            format(string, sizeof(string), "wanTicketSubentry%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanTicketSubentry][i]);
            format(string, sizeof(string), "wanTicketPoliceId%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanTicketPoliceId][i]);
            format(string, sizeof(string), "wanTicketUnix%d", i);
			cache_get_value_name_int(0, string, WantedInfo[playerid][wanTicketUnix][i]);
            format(string, sizeof(string), "WantedTicketPolice%d", i);
            cache_get_value_name(0, string, TicketPolice[playerid][i], 24);
		}
	}
	else 
    {
        new string_mysql[80];
        format(string_mysql, sizeof(string_mysql), "INSERT INTO `pp_wanted` SET `playerid` = '%d'", PlayerInfo[playerid][pID]);
        query_empty(pearsq, string_mysql);
    }

    WantedInfo[playerid][wanLoad] = false;
	return 1;
}

stock CreatePlayerPursuit(playerid, mentid)
{
    if(GetPVarInt(playerid,"afksystem") >= 5 || Pursuit[playerid] != 9999) return 0;

    SendClientMessage(playerid, COLOR_GREY, "{0066ff}[ POLICE ]: {abcdef}Вас преследует полиция. Не выходите из игры во время преследования!");

    /*new line[110],lines[330];
    format(line,sizeof(line),"{0066ff}Вас преследует полиция!"), strcat(lines,line);
    format(line,sizeof(line),"\n\n{ffcc66}Если вы выйдете из игры во время преследования, вы автоматически отправитесь в тюрьму"), strcat(lines,line);
    format(line,sizeof(line),"\n{ffcc66}Вы можете сдаться полиции или попытаться избежать ареста"), strcat(lines,line);
	ShowDialog(playerid,1982,DIALOG_STYLE_MSGBOX,"{0066ff}POLICE",lines,"*","");*/

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
		    SendClientMessage(mentid, COLOR_GREY, "{0066ff}[ POLICE ]: {abcdef}Преследование {0066ff}%s {abcdef}активировано", playername(playerid));
        }
    }
    return 1;
}

stock DestroyPursuit(playerid)
{
    Pursuit[playerid] = 9999;
    PursuitTime[playerid] = 0;
    TextDrawHideForPlayer(playerid, PursuitDraw[0]);
    TextDrawHideForPlayer(playerid, PursuitDraw[1]);
    TextDrawHideForPlayer(playerid, PursuitDraw[2]);
    PlayerTextDrawHide(playerid, PursDraw1);
    return 1;
}

stock CreatePlayerTicket(playerid, mentid, zv, uk, p, slotzv)
{
    new slotUk = -1;
    for(new i = 0; i < MAX_CRIME_PLAYER; i++)
    {
        if(WantedInfo[playerid][wanTicketCrime][i] == 0)
        {
            slotUk = i;
            break;
        }
    }

    if(zv == 0 && mentid != -1)
    {
        if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING
            || !ProxDetectorS(2.0, playerid, mentid)) return ErrorMessage(mentid, "{FF6347}Вы далеко от игрока");
    }

    if(slotUk >= 0)
    {
        PlayerInfo[playerid][pAmmos11] += CriminalCodeInfo[uk][p][ccFine];
        WantedInfo[playerid][wanTicketCrime][slotUk] = uk + 1;
        WantedInfo[playerid][wanTicketSubentry][slotUk] = p;
        if(mentid != -1) 
        {
            WantedInfo[playerid][wanTicketPoliceId][slotUk] = PlayerInfo[mentid][pID];
            format(TicketPolice[playerid][slotUk], 24,"%s", PlayerInfo[mentid][pName]);

            new string[140];
            format(string, sizeof(string), " Вы выписали штраф %s в размере %d$ {cccccc}[ /ticket - отменить штраф или посмотреть список ]", rpplayername(playerid), CriminalCodeInfo[uk][p][ccFine]);
	        SendClientMessage(mentid, COLOR_LIGHTBLUE, string);
        }
        WantedInfo[playerid][wanTicketUnix][slotUk] = gettime();
        SaveTicketPlayer(playerid, slotUk);

        if(zv == 0)
        {
            SendClientMessage(playerid, COLOR_GREY, "{0066ff}[ POLICE ]: {abcdef}%s выписал%s вам штраф в размере {FF6347}%d$", rpplayername(mentid), gender(mentid), CriminalCodeInfo[uk][p][ccFine]);

            new line[80],lines[240];
            format(line,sizeof(line),"{0066ff}Вам выписан штраф в размере {FF6347}%d$", CriminalCodeInfo[uk][p][ccFine]), strcat(lines,line);
            format(line,sizeof(line),"\n\n{ffcc66}Вы можете оплатить его в любом банкомате"), strcat(lines,line);
            format(line,sizeof(line),"\n{ffcc66}За длительную неуплату штрфов, вы будете арестованы"), strcat(lines,line);
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{0066ff}POLICE",lines,"*","");
        }
    }
    else
    {
        if(mentid != -1 && slotzv != -1) ErrorMessage(mentid, "{FF6347}У преступника максимальное количество штрафов в личном деле [ /wanted ]");
        return 0;
    }
    return 1;
}

stock ukshow(p)
{
    new uktext[9];
    if(p == 0) // 0 Основная статья
    {
        format(uktext,sizeof(uktext),"{ff9000}");
    }
    else // Остальные подстатьи
    {
        format(uktext,sizeof(uktext),"{FDCD96}");
    }
    return uktext;
}

CMD:su(playerid, const params[])
{
    new g = fraction(playerid);
	if(!IsAFunctionOrganization(32, g, playerid) && PlayerInfo[playerid][pFbi] == 0) return ErrorMessage(playerid, "{FF6347}Вы не сотрудник правоохранительных органов");
	if(!GetAccessRankOrg(playerid, g, 32, PlayerInfo[playerid][pFbi])) return 1;

    if(howstun(playerid)) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
    new playa,tmp[121],article[8];
    if(!sscanf(params, "s[121]s[8]", tmp, article)) // Указываем Ник и Номер статьи
    {
        if(!CheckWarningSu(playerid, tmp, playa)) return 1;
        new findUk = -1, findP;
        for(new i = 0; i < MAX_CRIMINAL_CODE_ARTICLE; i++)
        {
            if(CriminalCodeInfo[i][0][ccStatus] == false) continue;
            for(new p = 0; p < MAX_CRIMINAL_CODE_SUBENTRY; p++)
	        {
                if(strfind(CriminalCodeInfo[i][p][ccArcticle], article,true) != (-1))
                {
                    findUk = i;
                    findP = p;
                    break;
                }
            }
        }

        if(findUk == -1) return ErrorMessage(playerid, "{FF6347}Номер статьи не найден");
        SetPlayerCriminal(playa, playerid, CriminalCodeInfo[findUk][findP][ccName], CriminalCodeInfo[findUk][findP][ccLevel], findUk, findP);
    }
    else if(!sscanf(params, "s[121]", tmp)) // Указываем только ник или ID
    {
        if(!CheckWarningSu(playerid, tmp, playa)) return 1;
        DP[3][playerid] = playa;
        CriminalCodeMenu(playerid, 1, 0);
    }
    else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать розыск или штраф подозреваемому [ /su ID или Ник (Номер статьи - не обязательно) ]");
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
stock SetPlayerCriminal(playerid,zakonnik,const reason[],zv, uk, p)
{
	new slotUk = -1;
	if(OnlineInfo[playerid][oLogged] == 1)
	{
        if(zakonnik >= 0)
        {
		    if(WantedInfo[playerid][wanLoad] == true) return ErrorMessage(zakonnik, "{FF6347}Стоп! Игрок заходит на сервер.. Пожалуйста подождите");
		    if(PlayerInfo[playerid][pJailed] != 0) return ErrorMessage(zakonnik, "{FF6347}Подозреваемый уже находится в заключении");
        }

        if(zakonnik != -1)
        {
            if(CriminalCodeInfo[uk][p][ccLevel] == 0 && CriminalCodeInfo[uk][p][ccFine] == 0) return ErrorMessage(zakonnik, "{FF6347}У заголовка статьи нет розыска или штрафа");
        }

		for(new i = 0; i < MAX_CRIME_PLAYER; i++)
		{
			if(WantedInfo[playerid][wanCrime][i] == 0)
			{
				slotUk = i;
				break;
			}
		}

        new resultFine;
        // Выписываем штраф
        if(CriminalCodeInfo[uk][p][ccFine] != 0 && zakonnik != -1) 
        {
            resultFine = CreatePlayerTicket(playerid, zakonnik, zv, uk, p, slotUk);
        }

        if(slotUk == -1 && resultFine == 0)
        {
            if(zakonnik >= 0) ErrorMessage(zakonnik, "{FF6347}У преступника максимальное количество статей в личном деле [ /wanted ]");
            return 1;
        }

        // Выдаём розыск
        if(CriminalCodeInfo[uk][p][ccLevel] != 0)
		{
			WantedInfo[playerid][wanCrime][slotUk] = uk + 1;
            WantedInfo[playerid][wanSubentry][slotUk] = p;
			if(zakonnik != -1) WantedInfo[playerid][wanPoliceId][slotUk] = PlayerInfo[zakonnik][pID];
			WantedInfo[playerid][wanUnix][slotUk] = gettime();
			if(zakonnik != -1) format(WantedPolice[playerid][slotUk], 24,"%s", PlayerInfo[zakonnik][pName]);
			SaveWantedPlayer(playerid, slotUk);

			if(PlayerInfo[playerid][pCrimes]+zv > 50) PlayerInfo[playerid][pCrimes] = 50;
			else if(PlayerInfo[playerid][pCrimes]+zv <= 50) PlayerInfo[playerid][pCrimes] += zv;

            new string[140];
			// Сообщения преступнику
			if(zakonnik != -1) format(string, sizeof(string), "{abcdef}Вы совершили Преступление [%s] Полицейский: [%s] {FF6347}Ур. розыска: [%d]",reason,PlayerInfo[zakonnik][pName],zv);
			else format(string, sizeof(string), "{abcdef}Вы совершили Преступление [%s] Полицейский: [Аноним] {FF6347}Ур. розыска: [%d]",reason,zv);
			SendClientMessage(playerid, COLOR_GREY, string);
            ErrorMessage(playerid,"{ffcc00}Вас пытается задержать полиция!\n\n{cccccc}Вы совершили престулпение и сейчас вас пытаются задержать\nВы можете попытать\nВ случае если вы сдадитесь добровольно, в суде это зачтется\n\nДля добровольной сдачи у вас есть {ff6743}15{cccccc} секунд:\n- Нажмите кнопку [ H ] находясь пешком.\n- На момент выполнения анимации не совершайте никаких действий");
			OnlineInfo[playerid][oUnixAcceptWanted] = 15;
            Moiplayer[playerid] = zakonnik;

            foreach (Player, i)
			{
				if(OnlineInfo[i][oLogged] == 0
                    || PlayerInfo[i][pTransmitterOff][5] == true) continue;
				if(IsACop(i) || PlayerInfo[i][pFbi] >= 1)
				{
					if(zakonnik != -1) format(string, sizeof(string), "[DEP]: По заявлению %s[%d], %s[%d] обвиняется в %s. {FF6347}Ур. розыска: [%d]",PlayerInfo[zakonnik][pName],zakonnik,rpplayername(playerid),playerid,reason,zv);
					else format(string, sizeof(string), "[DEP]: По заявлению Анонима, %s[%d] обвиняется в %s. {FF6347}Ур. розыска: [%d]",rpplayername(playerid),playerid,reason,zv);
					SendClientMessage(i, COLOR_LIGHTNEUTRALBLUE, string);
				}
			}

			// Врубаем Pursuit
			if(zakonnik != -1)
            {
                CreatePlayerPursuit(playerid, zakonnik);

			    OrgLog(fraction(zakonnik), "su", PlayerInfo[zakonnik][pID], PlayerInfo[zakonnik][pName], PlayerInfo[zakonnik][pPlaIP], PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], CriminalCodeInfo[uk][p][ccLevel], CriminalCodeInfo[uk][p][ccName]);
            }
        }
	}
	return slotUk;
}

stock AcceptWanted(playerid)
{
    NoAnim[playerid] = 1;
    TogglePlayerControllable(playerid, false);
    ApplyAnimation(playerid,"ROB_BANK","SHP_HandsUp_Scr",4.1,0,1,1,1,1,1);
    new string[115];
    format(string,sizeof(string),"{abcdef}[ HQ ]: Обвиняемый {FFFFFF}%s[%d] {abcdef}принял предложение сдаться добровольно.",rpplayername(playerid),playerid);
    SendClientMessage(Moiplayer[playerid],COLOR_GREY,string);
    return 1;
}

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
	CriminalCodeMenu(playerid);
	PlayerPlaySound(playerid,40405,0,0,0);
	return 1;
}

stock CriminalCodeMenu(playerid) // Меню кодекса
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
    else CriminalCodeMenu(playerid); // Если нет доступа, открываем просто список всех статей
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

CMD:unix(playerid, const params[])
{
    if(server != 0) return 1;
    if(sscanf(params, "i", params[0])) return ErrorText(playerid, "[ Мысли ]: /unix Время");

    new tyear, tmonth, tday, thour, tminute, tsecond;
	stamp2datetime(params[0], tyear, tmonth, tday, thour, tminute, tsecond, 3);

    format(store, sizeof(store), "%02d.%02d.%d %02d:%02d",tday, tmonth, tyear, thour, tminute);
	SendClientMessage(playerid, COLOR_GREY, store);
    return 1;
}


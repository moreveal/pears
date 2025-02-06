
#define MAX_GOLD_COURSE 9500 // Максимальный курс голды
#define MAX_TRADECRYPT 1000
#define MAX_TRADECRYPTLOG 20
enum TradeCryptInfo
{
    tcNewid, // id в базе
    tcStatus, // Статус у владельца
	tcActive, // установлена ли активность
    tcName[24], // NickName продавца
    tcVlad, // Номер Аккаунта
	tcCount, // Количество
	tcCourse, // Курс за еденицу
    tcUnix, // unix
};
new TradeCrypt[MAX_TRADECRYPT][TradeCryptInfo];
enum TradeCryptInfoLog
{
	tclCourse, // Курс за еденицу
};
new TradeCryptLog[MAX_TRADECRYPTLOG][TradeCryptInfoLog];

new AfloodCrypto[MAX_REALPLAYERS];
new BankTabloObject[4];
new tclArifmetik;
new tclArifmetikAllGold;

stock ClearSorting(playerid)
{
    OnlineInfo[playerid][oSorting][0] = 0; // ID диалога, в котором происходит сортировку
    OnlineInfo[playerid][oSorting][1] = 0; // 1 слой сортировки
    OnlineInfo[playerid][oSorting][2] = 0; // 2 слой сортировки
    OnlineInfo[playerid][oSorting][3] = 0; // 3 слой сортировки
    OnlineInfo[playerid][oSorting][4] = 0; // 3 слой сортировки
    OnlineInfo[playerid][oSorting][5] = 0; // 3 слой сортировки

    format(OnlineInfo[playerid][oSortingName], 64, ""); 
    return 1;
}

stock ClearDialogMenu(playerid)
{
    OnlineInfo[playerid][oDialogMenu][0] = 0; // Строки на текущей странице
    OnlineInfo[playerid][oDialogMenu][1] = 0; // Страница
    OnlineInfo[playerid][oDialogMenu][2] = 0; // Последний list на странице
    OnlineInfo[playerid][oDialogMenu][4] = 0; // Первый list на странице
    OnlineInfo[playerid][oDialogMenu][5] = 0; // Информация о последней странице
    return 1;
}

stock LoadPageSorting(playerid, dialogid, maxList, &minlist, &page, &thisPage)
{
    OnlineInfo[playerid][oDialogMenu][0] = 0; // Строки на текущей странице
    OnlineInfo[playerid][oDialogMenu][6] = dialogid;
    OnlineInfo[playerid][oDialogMenu][7] = 0; // Подсчет глав или заголовкок на странице
	if(page == 0)
	{
		if(OnlineInfo[playerid][oSorting][0] > 0 && OnlineInfo[playerid][oSorting][0] != dialogid) ClearSorting(playerid);
        OnlineInfo[playerid][oSorting][0] = dialogid;
        ClearDialogMenu(playerid);
	}

	minlist = 0;
    if(page > 0)
	{
		if(page == OnlineInfo[playerid][oDialogMenu][1]) minlist = OnlineInfo[playerid][oDialogMenu][4], thisPage = 1; // Если открывается та-же самая страница, показываем первый list
		else minlist = OnlineInfo[playerid][oDialogMenu][2] + 1; // В другом случае открываем последний list (+ 1 для следующей страницы)
		OnlineInfo[playerid][oDialogMenu][1] = page;
	}

    if((minlist >= maxList || OnlineInfo[playerid][oDialogMenu][5] == 1) && thisPage == 0) // Сбрасываем страницы, если последний лист максимальный или больше
	{
		ClearDialogMenu(playerid);
		minlist = 0, page = 0;
	}
    return 1;
}

stock IsActiveSorting(playerid)
{
    if(OnlineInfo[playerid][oSorting][1] > 0 || OnlineInfo[playerid][oSorting][2] > 0 
        || OnlineInfo[playerid][oSorting][3] > 0 || OnlineInfo[playerid][oSorting][4] > 0 
        || OnlineInfo[playerid][oSorting][5] > 0
        || strcmp(OnlineInfo[playerid][oSortingName], "\0", true ) != 0) return 1;
    return 0;
}

stock ReloadSorting(playerid, dialogid)
{
    if(IsActiveSorting(playerid))
    {
        ClearSorting(playerid);
        PlayerPlaySound(playerid, 6801, 0,0,0);
        OnlineInfo[playerid][oSorting][0] = dialogid;
    }
    return 1;
}

stock DialogMenuSorting(playerid)
{
	new line[90],lines[360];
    format(line,sizeof(line),"{cccccc}Сортировка\t{cccccc}Значение"), strcat(lines,line);

    if(OnlineInfo[playerid][oSorting][1] == 0) format(line,sizeof(line),"\n{cccccc}ID:\t{ff9000}Все"), strcat(lines,line);
	else format(line,sizeof(line),"\n{cccccc}ID:\t{99ff66}%d", OnlineInfo[playerid][oSorting][1]), strcat(lines,line);

	if(!strcmp(OnlineInfo[playerid][oSortingName],"\0",true)) format(line,sizeof(line),"\n{cccccc}Название:\t{ff9000}Все"), strcat(lines,line);
	else format(line,sizeof(line),"\n{cccccc}Название:\t{ff9000}%s", OnlineInfo[playerid][oSortingName]), strcat(lines,line);

    format(line,sizeof(line),"\n{cccccc}Сбросить Фильтры\t"), strcat(lines,line);

    ShowDialog(playerid,982,DIALOG_STYLE_TABLIST_HEADERS,"Фильтр",lines,"Выбрать","Назад");
    return 1;
}

stock TradeSorting(playerid)
{
    new line[100],lines[600];
    format(line,sizeof(line),"{cccccc}Сортировка\t{cccccc}Значение"), strcat(lines,line);

    if(OnlineInfo[playerid][oSorting][1] == 0) format(line,sizeof(line),"\n{cccccc}Тип трейдов:\t{ff9000}Все трейды"), strcat(lines,line);
    else if(OnlineInfo[playerid][oSorting][1] == 1) format(line,sizeof(line),"\n{cccccc}Тип трейдов:\t{FFCC00}Продажа Gold"), strcat(lines,line);
    else if(OnlineInfo[playerid][oSorting][1] == 2) format(line,sizeof(line),"\n{cccccc}Тип трейдов:\t{99ff66}Покупка Gold"), strcat(lines,line);
    else if(OnlineInfo[playerid][oSorting][1] == 3) format(line,sizeof(line),"\n{cccccc}Тип трейдов:\t{ffffff}Мои трейды"), strcat(lines,line);

    format(line,sizeof(line),"\n{cccccc}Количество:\t{ffcc00}От %dG - До %dG", OnlineInfo[playerid][oSorting][2], OnlineInfo[playerid][oSorting][3]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Курс:\t{ffcc00}От %d$ - До %d$", OnlineInfo[playerid][oSorting][4], OnlineInfo[playerid][oSorting][5]), strcat(lines,line);

    format(line,sizeof(line),"\n{cccccc}Сбросить Фильтры\t"), strcat(lines,line);

    ShowDialog(playerid,1386,DIALOG_STYLE_TABLIST_HEADERS,"Фильтр Сделок",lines,"Выбрать","Назад");
    return 1;
}

stock TradeList(playerid, page)
{
    new max_line = 50, yes_next;
    new line[214],lines[4096];

    DP[0][playerid] = 0; // Строки на текущей странице
    DP[7][playerid] = 0; // Очищаем статус последней страницы
    if(page == 0)
    {
        if(OnlineInfo[playerid][oSorting][0] > 0 && OnlineInfo[playerid][oSorting][0] != 1379) ClearSorting(playerid);
        OnlineInfo[playerid][oSorting][0] = 1379;

        DP[1][playerid] = 0; // Страница
        DP[5][playerid] = 0; // Последний trade id
    }

    new minlist = 0;
    if(page > 0) minlist = page * max_line;
    if(minlist >= MAX_TRADECRYPT) DP[1][playerid] = 0, minlist = 0, page = 0; // Сбрасываем страницы, если последний tradeid максимальный или больше

    format(line,sizeof(line),"{cccccc}Трейд\t{cccccc}Количество\t{99ff66}Стоимость\t{FF6347}Курс 1G"), strcat(lines,line);
    format(line,sizeof(line),"\n{ff9000}Создать Трейд\t\t\t"), strcat(lines,line);

    if(IsActiveSorting(playerid)) format(line,sizeof(line),"\n{cccccc}Фильтр {99ff66}[Активен]\t\t\t"), strcat(lines,line);
    else format(line,sizeof(line),"\n{cccccc}Фильтр\t\t\t"), strcat(lines,line);

    for(new d = minlist; d < MAX_TRADECRYPT; d++)
    {
        if(page > 0 && d >= MAX_TRADECRYPT - 1) yes_next = 1, DP[7][playerid] = 1; // Все прошарили, значит показываем Next Page

        if(TradeCrypt[d][tcVlad] == 0) continue;
        if(CheckSortingLineTrade(playerid, d)) continue;

        if(OnlineInfo[playerid][oSorting][1] == 0 // Отображаем все трейды
            || OnlineInfo[playerid][oSorting][1] == 1 && TradeCrypt[d][tcActive] == 0 // Отображаем только продажу голды
            || OnlineInfo[playerid][oSorting][1] == 2 && TradeCrypt[d][tcActive] == 1 // Отображаем только покупку голды
            || OnlineInfo[playerid][oSorting][1] == 3 && TradeCrypt[d][tcVlad] == PlayerInfo[playerid][pID]) // Отображаем только мои трейды
        {
            format(line,sizeof(line),"%s", ShowLineTrade(playerid, d)), strcat(lines,line);
        }

        if(DP[0][playerid] >= max_line)
        {
            yes_next = 1;
            break;
        }
    }
    if(yes_next == 1) format(line,sizeof(line),"\n{cccccc}Next Page >>\t\t\t"), strcat(lines,line);
    new header[130];
    format(header,sizeof(header),"Биржевые Сделки [ Курс 1G = %d$ | Страница %d] ", tclArifmetik, page + 1);
    ShowDialog(playerid,1379,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Выбрать","Выход");

    // Квест знакомство с ноутбуком
    JoneNoteLastTalk(playerid);
    return 1;
}

stock CheckSortingLineTrade(playerid, d)
{
    // Сортировка по количеству
    if(OnlineInfo[playerid][oSorting][2] > 0 && TradeCrypt[d][tcCount] < OnlineInfo[playerid][oSorting][2]) return 1; // От Если число меньше - пропускаем
    if(OnlineInfo[playerid][oSorting][3] > 0 && TradeCrypt[d][tcCount] > OnlineInfo[playerid][oSorting][3]) return 1; // До Если число больше - пропускаем

    // Сортировка по курсу
    if(OnlineInfo[playerid][oSorting][4] > 0 && TradeCrypt[d][tcCourse] < OnlineInfo[playerid][oSorting][4]) return 1; // От Если число меньше - пропускаем
    if(OnlineInfo[playerid][oSorting][5] > 0 && TradeCrypt[d][tcCourse] > OnlineInfo[playerid][oSorting][5]) return 1; // До Если число больше - пропускаем
    return 0;
}

stock ShowLineTrade(playerid, d)
{
    new line[214];

    // Подсчитываем строки
    List[DP[0][playerid]][playerid] = d;
    DP[0][playerid] ++;

    if(TradeCrypt[d][tcActive] == 0) // Продаёт Голду
    {
        format(line,sizeof(line),"\n{cccccc}%d. {FFCC00}Продажа\t{FFCC00}%dG\t{99ff66}%d$\t{FF6347}%d$", d+1, TradeCrypt[d][tcCount], TradeCrypt[d][tcCourse]*TradeCrypt[d][tcCount], TradeCrypt[d][tcCourse]);
    }
    else // Покупает голду
    {
        format(line,sizeof(line),"\n{cccccc}%d. {99ff66}Покупка\t{FFCC00}%dG\t{99ff66}%d$\t{FF6347}%d$", d+1, TradeCrypt[d][tcCount], TradeCrypt[d][tcCourse]*TradeCrypt[d][tcCount], TradeCrypt[d][tcCourse]);
    }
    return line;
}

CMD:ptrade(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 20)
	{
	    TradeList(playerid, 0);
	}
	return 1;
}

stock ShowDialogCreateTradeGold(playerid, create_page)
{
    new header[80];
    format(header,sizeof(header),"Создание Трейда [ Курс 1G = %d$ ]", tclArifmetik);
    if(create_page == 0)
    {
        if(TradeCrypt[playerid][tcStatus] == 0) 
        {
            ShowDialog(playerid,1377,DIALOG_STYLE_INPUT,header,"{cccccc}Чтобы {ffcc00}продать {cccccc}Gold введите его количество\n\n{FF6347}Не меньше 1 и не больше 10.000","Принять","Отмена");
        }
        else 
        {
            ShowDialog(playerid,1377,DIALOG_STYLE_INPUT,header,"{cccccc}Чтобы {99ff66}купить {cccccc}Gold введите его количество\n\n{FF6347}Не меньше 1 и не больше 10.000","Принять","Отмена");
        }
    }

    else if(create_page == 1)
    {
        new string[140];
        format(string,sizeof(string),"{cccccc}Введите курс за 1 Gold\nТ.е. сколько будет стоит 1 Gold в вашей заявке\n\n{FF6347}Не меньше 500$ и не больше %d$", MAX_GOLD_COURSE);
        ShowDialog(playerid,1376,DIALOG_STYLE_INPUT,header,string,"Принять","Отмена");
    }
    return 1;
}

stock dialogCase_notebook(playerid, dialogid,response, listitem, const inputtext[])
{
    if(dialogid == 1396) 
    {
        TradeList(playerid, 0);
        return true;
    }
    else if(dialogid == 1386) // Настройки фильтра
	{
        if(response)
        {
            if(listitem == 0)
			{
                if(OnlineInfo[playerid][oSorting][1] == 0) OnlineInfo[playerid][oSorting][1] = 1;
                else if(OnlineInfo[playerid][oSorting][1] == 1) OnlineInfo[playerid][oSorting][1] = 2;
                else if(OnlineInfo[playerid][oSorting][1] == 2) OnlineInfo[playerid][oSorting][1] = 3;
                else OnlineInfo[playerid][oSorting][1] = 0;
                TradeSorting(playerid);
            }
            if(listitem == 1)
            {
                DP[0][playerid] = 0;
				ShowDialog(playerid,1387,DIALOG_STYLE_INPUT,"Фильтр Сделок","{cccccc}Введите диапазон для отображения сделок по {ff9000}Количеству Gold\n{cccccc}Через пробел минимальное и максимальное количество [ Не меньше 1G и не больше 100.000G ]\n{ff9000}Пример: 10 100","Принять","Отмена");
            }
            if(listitem == 2)
            {
                DP[0][playerid] = 1;
                new string[210];
                format(string,sizeof(string),"{cccccc}Введите диапазон для отображения сделок по {ff9000}Курсу Gold\n{cccccc}Через пробел минимальный и максимальный курс [ Не меньше 1$ и не больше %d$ ]\n{ff9000}Пример: 10 100", MAX_GOLD_COURSE);
				ShowDialog(playerid,1387,DIALOG_STYLE_INPUT,"Фильтр Сделок",string,"Принять","Отмена");
            }
            if(listitem == 3) // Сбросить Фильтр
            {
                ReloadSorting(playerid, 1379);
                TradeSorting(playerid);
            }
        }
        else TradeList(playerid, DP[1][playerid]);
        return true;
    }
    if(dialogid == 1387) // Фильтры диапазонов
	{
        if(response)
        {
            new input, input2;
            if(sscanf(inputtext, "ii", input, input2)) return TradeSorting(playerid);
            if(input < 1 || input > MAX_GOLD_COURSE
                || input2 < 1 || input2 > MAX_GOLD_COURSE) return TradeSorting(playerid);

            if(DP[0][playerid] == 0) // Количество
            {
                OnlineInfo[playerid][oSorting][2] = input;
                OnlineInfo[playerid][oSorting][3] = input2;
            }
            else if(DP[0][playerid] == 1) // Курс
            {
                OnlineInfo[playerid][oSorting][4] = input;
                OnlineInfo[playerid][oSorting][5] = input2;
            }
            PlayerPlaySound(playerid,6401,0,0,0);
            TradeSorting(playerid);
        }
        else TradeSorting(playerid);
        return true;
    }
	else if(dialogid == 1379) // вывод меню
	{
        if(response)
        {
            if(listitem == 0) // Создать Трейд
            {
                if(AfloodCrypto[playerid] > gettime()) return ErrorText(playerid, "{FF6347}Для повторного создания трейда подождите 3 секунды"), TradeList(playerid, 0);
                MyTradeSetting(playerid);
                return true;
            }
            else if(listitem == 1) return TradeSorting(playerid); // Фильтры

            if(DP[0][playerid] > 0) // Есть строки на странице
            {
                if(listitem - 2 >= DP[0][playerid]) 
                {
                    if(DP[7][playerid] == 0) DP[1][playerid] += 1, TradeList(playerid, DP[1][playerid]); // Следующая страница
                    else TradeList(playerid, 0); // Первая страница
                }
                else // Отображаемые List
                {
                    new listtrade = List[listitem - 2][playerid];
                    DP[3][playerid] = listtrade;
                    if(TradeCrypt[listtrade][tcVlad] == PlayerInfo[playerid][pID]) inserttodelete(playerid,listtrade);
                    else inserttobuy(playerid, listtrade);
                }
            }
            else TradeList(playerid, 0); // Нет строк, открываем первую
        }
        else 
        {
            if(DP[6][playerid] == 0) pc_cmd_donate(playerid);
        }
        return true;
    } 
    else if (dialogid == 1378) // 
    {
        if(response)
        {
            if(listitem == 0)
            {
                if(TradeCrypt[playerid][tcStatus] == 0) TradeCrypt[playerid][tcStatus] = 1;
				else TradeCrypt[playerid][tcStatus] = 0;
                PlayerPlaySound(playerid,17803,0,0,0);
                MyTradeSetting(playerid);
            }
            if(listitem == 1) ShowDialogCreateTradeGold(playerid, 0);
        }
        else TradeList(playerid, DP[1][playerid]);
        return true;
    }
    else if(dialogid == 1377) //
    {
        if(response)
		{
            new input = strval(inputtext);
            if(sscanf(inputtext, "i", input)) return MyTradeSetting(playerid), PlayerPlaySound(playerid,4203,0,0,0);
            if(input < 1 || input > 10000) return ShowDialogCreateTradeGold(playerid, 0), PlayerPlaySound(playerid,4203,0,0,0);
            if(TradeCrypt[playerid][tcStatus] == 0) // Продаю золото
            {
                if(input > PlayerInfo[playerid][pDonateMoney]) return ErrorText(playerid, "{FF6347}Вам не хватает золота"), ShowDialogCreateTradeGold(playerid, 0);
            }
            DP[4][playerid] = input;
            ShowDialogCreateTradeGold(playerid, 1);
        }
        else MyTradeSetting(playerid);
        return true;
    }
    else if(dialogid == 1376) //
    {
        if(response)
        {
            new input = strval(inputtext);
            if(sscanf(inputtext, "i", input)) return MyTradeSetting(playerid), PlayerPlaySound(playerid,4203,0,0,0);
            if(input < 500 || input > MAX_GOLD_COURSE) return ShowDialogCreateTradeGold(playerid, 1), PlayerPlaySound(playerid,4203,0,0,0);

            new donate = DP[4][playerid];
            if(IsALimitTradePlayer(playerid) >= 5) return ErrorText(playerid, "{FF6347}Вы можете создать только 5 трейдов"), ShowDialogCreateTradeGold(playerid, 1);
            
            new id = GetFreeSlotTrade();
            if(id == -1) return ErrorText(playerid, "{FF6347}Нет свободных слотов для создания трейда\n\n{cccccc}Обратитесь к администрации /report"),  MyTradeSetting(playerid);
            if(TradeCrypt[playerid][tcStatus] == 1) // Купить золото
            {
                if(input*donate > PlayerInfo[playerid][pAccount]) return ErrorText(playerid, "{FF6347}На банковском счету недостаточно средств"), ShowDialogCreateTradeGold(playerid, 1);
                PlayerInfo[playerid][pAccount] -= input*donate;
                TradeCrypt[id][tcActive] = 1;
                mysql_save(playerid, 1);

                MoneyLog("goldtrade", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -input*donate, "Создал голд трейд");
            }
            else if(TradeCrypt[playerid][tcStatus] == 0) // Продать золото
            {
                if(donate > PlayerInfo[playerid][pDonateMoney]) return ErrorText(playerid, "{FF6347}Вам не хватает золота"), MyTradeSetting(playerid);
                PlayerInfo[playerid][pDonateMoney] -= donate;
                TradeCrypt[id][tcActive] = 0;
                mysql_save(playerid, 4);

                DonateLog("goldtrade", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -donate, "Создал голд трейд");
            }
            AfloodCrypto[playerid] = gettime() + 3;

			TradeCrypt[id][tcCount] = donate;
            TradeCrypt[id][tcCourse] = input;
            TradeCrypt[id][tcVlad] = PlayerInfo[playerid][pID];
            format(TradeCrypt[id][tcName], 24,"%s", PlayerInfo[playerid][pName]);
            TradeCrypt[id][tcUnix] = gettime();

            new string_mysql[220];
			mysql_format(pearsq, string_mysql,sizeof(string_mysql),"INSERT INTO `pp_tradecrypto` SET `active`='%d',`vlad`='%d',`playername`='%e',`count`='%d',`cource`='%d',`unix`='%d'",
            TradeCrypt[id][tcActive],PlayerInfo[playerid][pID],PlayerInfo[playerid][pName],TradeCrypt[id][tcCount],TradeCrypt[id][tcCourse],TradeCrypt[id][tcUnix]); // 116 + 55 + 24
			mysql_tquery(pearsq, string_mysql, "OnPlayerTradeCrypto", "d", id); // 195

            PlayerPlaySound(playerid,6401,0,0,0);

            new line[130],lines[1400];
            format(line,sizeof(line),"{99ff66}Трейд Создан!"), strcat(lines,line);

            format(line,sizeof(line),"\n\n{cccccc}Номер трейда: {ff9000}%d", id + 1), strcat(lines,line);
            if(TradeCrypt[id][tcActive] == 0) format(line,sizeof(line),"\n{cccccc}Тип трейда: {ffcc00}Продажа Gold"), strcat(lines,line);
            else format(line,sizeof(line),"\n{cccccc}Тип трейда: {99ff66}Покупка Gold"), strcat(lines,line);
            format(line,sizeof(line),"\n{cccccc}Количество: {ffcc00}%d", TradeCrypt[id][tcCount]), strcat(lines,line);
            format(line,sizeof(line),"\n{cccccc}Курс: {FF6347}1G = %d$", TradeCrypt[id][tcCourse]), strcat(lines,line);
            format(line,sizeof(line),"\n{cccccc}Стоимость: {99ff66}%d$", TradeCrypt[id][tcCourse] * TradeCrypt[id][tcCount]), strcat(lines,line);

            if(TradeCrypt[id][tcActive] == 0)
            {
                format(line,sizeof(line),"\n\n{666666}- Золото списано с вашего аккаунта для успешного заключения сделки"), strcat(lines,line);
            }
            else
            {
                format(line,sizeof(line),"\n\n{666666}- Деньги списаны с вашего аккаунта для успешного заключения сделки"), strcat(lines,line);
            }
            format(line,sizeof(line),"\n{666666}- Вы можете отменить трейд в любой момент и вернуть свои средства"), strcat(lines,line);
            format(line,sizeof(line),"\n{666666}- После успешной сделки вы получите уведомление"), strcat(lines,line);
            format(line,sizeof(line),"\n{666666}- Если сделка не состоится в течении 7 дней, трейд будет отменён и вам вернутся средства"), strcat(lines,line);

			ShowDialog(playerid,1396,DIALOG_STYLE_MSGBOX, "Создание Трейда", lines, "OK", "");
        }
        else MyTradeSetting(playerid);
        return true;
    }
    else if(dialogid == 1375) // Удаление заявки
    {
        if(response)
		{
            new id = DP[3][playerid];
            if (listitem >= 0 && listitem <= 3) return inserttodelete(playerid, id);
            else 
            {
                if(TradeCrypt[id][tcVlad] != PlayerInfo[playerid][pID]) return ErrorText(playerid, "{FF6347}Ошибка! Нельзя удалить чужой трейд"), inserttodelete(playerid, id);

                if(TradeCrypt[id][tcActive] == 0) // Продавал золото
                {
                    PlayerInfo[playerid][pDonateMoney] += TradeCrypt[id][tcCount];
                    mysql_save(playerid, 4);

                    DonateLog("goldtrade", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", TradeCrypt[id][tcCount], "Отменил голд трейд");
                }
                else // Покупал золото
                {
                    PlayerInfo[playerid][pAccount] += TradeCrypt[id][tcCourse]*TradeCrypt[id][tcCount];
                    mysql_save(playerid, 1);

                    MoneyLog("goldtrade", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", TradeCrypt[id][tcCourse]*TradeCrypt[id][tcCount], "Отменил голд трейд");
                }
                deltradecrypto(id);
                PlayerPlaySound(playerid, 6801, 0,0,0);
                TradeList(playerid, 0);
            }
        }
        else TradeList(playerid, DP[1][playerid]);
        return true;
    }
    else if(dialogid == 1374) // Покупка по заявке
    {
        if(response)
		{
            new id = DP[3][playerid];
            if(listitem == 0)
            {
                if(TradeCrypt[id][tcActive] == 1)
                {
                    new body[256];
                    format(body, sizeof(body), "{cccccc}Чтобы {ffcc00}продать {cccccc}Gold введите его количество\n\n{FF6347}Не меньше 1 и не больше 10.000\n{cccccc}Курс: 1G = %d$\nДоступно: %d", TradeCrypt[id][tcCourse], TradeCrypt[id][tcCount]);
                    ShowDialog(playerid,_:GOLDEXC_BUY_GOLD_AMOUNT,DIALOG_STYLE_INPUT,"Биржевая Сделка",body,"Принять","Отмена");
                }
                else 
                {
                    new body[256];
                    format(body, sizeof(body), "{cccccc}Чтобы {ffcc00}продать {cccccc}Gold введите его количество\n\n{FF6347}Не меньше 1 и не больше 10.000\n{cccccc}Курс: 1G = %d$\nДоступно: %d", TradeCrypt[id][tcCourse], TradeCrypt[id][tcCount]);
                    ShowDialog(playerid,_:GOLDEXC_SELL_GOLD_AMOUNT,DIALOG_STYLE_INPUT,"Биржевая Сделка",body,"Принять","Отмена");
                }
            }
            else
            {
                inserttobuy(playerid, id);
            }
        }
        else TradeList(playerid, DP[1][playerid]);
        return true;
    }

    // Настройки фильтра в меню
    else if(dialogid == 982)
	{
        if(response)
        {
            if(listitem == 0)
            {
				ShowDialog(playerid,980,DIALOG_STYLE_INPUT,"Фильтр","{cccccc}Введите ID","Принять","Отмена");
            }
            if(listitem == 1)
            {
                ShowDialog(playerid,972,DIALOG_STYLE_INPUT,"Фильтр","{cccccc}Введите название\nМожно неполное название\n1 - 30 символов","Принять","Отмена");
            }
            if(listitem == 2) // Сбросить Фильтр
            {
				ReloadSorting(playerid,  OnlineInfo[playerid][oDialogMenu][6]);
				DialogMenuSorting(playerid);
            }
        }
        else 
		{
			if(OnlineInfo[playerid][oDialogMenu][6] == 1075) skinprice(playerid, 0); // Возвращаем в меню настроек гос. цен
			else if(OnlineInfo[playerid][oDialogMenu][6] == 1089) showDialogFittingRoomSkin(playerid, 0); // Возвращаем в меню примерочной
			else if(OnlineInfo[playerid][oDialogMenu][6] == 1066) vehprice(playerid, 0); // Возвращаем в меню настроек гос. цен транспорта
		}
        return true;
	}
	else if(dialogid == 980) // Фильтр по id
	{
        if(response)
        {
			new input = strval(inputtext);
			if(input < 1 || input > 10000) return ErrorText(playerid, "{FF6347}Не меньше 1 и не больше 10.000"), DialogMenuSorting(playerid);
			OnlineInfo[playerid][oSorting][1] = input;
            PlayerPlaySound(playerid,6401,0,0,0);
            DialogMenuSorting(playerid);
        }
        else DialogMenuSorting(playerid);
        return true;
    }
	else if(dialogid == 972) // Фильтр по названию
	{
        if(response)
        {
			if(!strlen(inputtext)) return ErrorText(playerid, "{FF6347}Вы ничего не ввели"), DialogMenuSorting(playerid);
			if(strlen(inputtext) < 1 || strlen(inputtext) > 30) return ErrorText(playerid, "{FF6347}1 - 30 символов"), DialogMenuSorting(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "{FF6347}Вы используете запрещённый символ"), DialogMenuSorting(playerid);

			format(OnlineInfo[playerid][oSortingName], 64,"%s", inputtext);
            PlayerPlaySound(playerid,6401,0,0,0);
            DialogMenuSorting(playerid);
        }
        else DialogMenuSorting(playerid);
        return true;
    }
    else if (dialogid == _:GOLDEXC_BUY_GOLD_AMOUNT)
    {
        new id = DP[3][playerid];
        if (response)
        {
            new input = strval(inputtext);
			if(input < 1 || input > 10000) return ErrorText(playerid, "{FF6347}Не меньше 1 и не больше 10.000"), inserttobuy(playerid, id);

            if(TradeCrypt[id][tcActive] == 1) gotobuycrypto(playerid,id,input);
        }
        else inserttobuy(playerid, id);
        return true;
    }
    else if (dialogid == _:GOLDEXC_SELL_GOLD_AMOUNT)
    {
        new id = DP[3][playerid];
        if (response)
        {
            new input = strval(inputtext);
			if(input < 1 || input > 10000) return ErrorText(playerid, "{FF6347}Не меньше 1 и не больше 10.000"), inserttobuy(playerid, id);

            if(TradeCrypt[id][tcActive] == 0) gotosellcrypto(playerid,id,input);
        }
        else inserttobuy(playerid, id);
        return true;
    }
    return false;
}

stock MyTradeSetting(playerid)
{
    new line[130],lines[390];
    format(line,sizeof(line),"{cccccc}Мой Счёт: {FFCC00}%dG \t{cccccc}Банковский Счет: {99ff66}%d$ {cccccc}[%s]", PlayerInfo[playerid][pDonateMoney], PlayerInfo[playerid][pAccount], get_k(PlayerInfo[playerid][pAccount])), strcat(lines,line);
    if(TradeCrypt[playerid][tcStatus] == 0)
    {
        format(line,sizeof(line),"\n{cccccc}Тип трейда: \t{ffcc00}Продажа Gold"), strcat(lines,line);
        format(line,sizeof(line),"\n{ff9000}Создать трейд >>\t"), strcat(lines,line);
    }
    else
    {
        format(line,sizeof(line),"\n{cccccc}Тип трейда: \t{99ff66}Покупка Gold"), strcat(lines,line);
        format(line,sizeof(line),"\n{ff9000}Создать трейд >>\t"), strcat(lines,line);
    }

    new header[80];
    format(header,sizeof(header),"Создание Трейда [ Курс 1G = %d$ ]", tclArifmetik);
    ShowDialog(playerid,1378,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Выбрать","Назад");
    return 1;
}
function OnPlayerTradeCrypto(id) {
    TradeCrypt[id][tcNewid] = cache_insert_id();
    return 1;
}

stock IsALimitTradePlayer(playerid)
{
    new quan;
    for(new i = 0; i < MAX_TRADECRYPT; i++)
    {
        if(TradeCrypt[i][tcVlad] == PlayerInfo[playerid][pID])
        {
            quan ++;
        }
    }
    return quan;
}

stock GetFreeSlotTrade()
{
    new tradeid = -1;
    for(new i = 0; i < MAX_TRADECRYPT; i++)
    {
        if(TradeCrypt[i][tcVlad] == 0)
        {
            tradeid = i;
            break;
        }
    }
    return tradeid;
}

stock inserttodelete(playerid, id) // Удаление заказа
{
    new line[100],lines[500];

    if(TradeCrypt[id][tcActive] == 0) format(line,sizeof(line),"{cccccc}Тип трейда: \t{ffcc00}Продажа Gold"), strcat(lines,line);
    else format(line,sizeof(line),"{cccccc}Тип трейда: \t{99ff66}Покупка Gold"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Количество: \t{FFCC00}%dG", TradeCrypt[id][tcCount]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Курс: \t{99ff66}1G = %d$", TradeCrypt[id][tcCourse]), strcat(lines,line);

    new tyear, tmonth, tday, thour, tminute, tsecond;
	stamp2datetime(TradeCrypt[id][tcUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
    format(line,sizeof(line),"\n{cccccc}Трейд создан: \t%02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute), strcat(lines,line);

    format(line,sizeof(line),"\n{FF6347}Удалить трейд >>\t "), strcat(lines,line);
    DP[3][playerid] = id;
	ShowDialog(playerid,1375,DIALOG_STYLE_TABLIST,"Мой Трейд",lines,"Выбрать","Отмена");
	return 1;
}

stock inserttobuy(playerid, b) // Покупка по заявки
{
    new line[100],lines[600];
    if(TradeCrypt[b][tcActive] == 0) 
    {
        format(line,sizeof(line),"{cccccc}%d. Тип трейда {ffcc00}Продажа Gold\t", b + 1), strcat(lines,line);
        format(line,sizeof(line),"\n{ffcc00}Купить Gold по этому трейду >>\t"), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}Продавец: \t{ffffff}%s", TradeCrypt[b][tcName]), strcat(lines,line);
    }
    else
    {
        format(line,sizeof(line),"{cccccc}%d. Тип трейда {99ff66}Покупка Gold\t", b + 1), strcat(lines,line);
        format(line,sizeof(line),"\n{99ff66}Продать Gold по этому трейду >>\t"), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}Покупатель: \t{ffffff}%s", TradeCrypt[b][tcName]), strcat(lines,line);
    }
    format(line,sizeof(line),"\n{cccccc}Количество: \t{ffcc00}%dG", TradeCrypt[b][tcCount]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Курс: \t{FF6347}1G = %d$", TradeCrypt[b][tcCourse]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Стоимость: \t{99ff66}%d$", TradeCrypt[b][tcCourse]*TradeCrypt[b][tcCount]), strcat(lines,line);

    DP[3][playerid] = b;
	ShowDialog(playerid,1374,DIALOG_STYLE_TABLIST_HEADERS,"Биржевые Сделки",lines,"Выбрать","Отмена");
	return 1;
}

stock deltradecrypto(id) 
{
    TradeCrypt[id][tcCount] = 0;
    TradeCrypt[id][tcCourse] = 0;
    TradeCrypt[id][tcVlad] = 0;
    TradeCrypt[id][tcName] = 0;
    TradeCrypt[id][tcUnix] = 0;
    savetradecrypto(id);
}

stock savetradecrypto(idx)
{
    new string_mysql[100];
    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "DELETE FROM `pp_tradecrypto` WHERE `newid` = '%d'", TradeCrypt[idx][tcNewid]);
    query_empty(pearsq, string_mysql);
  	return 1;
}

stock gotobuycrypto(playerid,id,count) // playerid продаёт голду
{
    if (TradeCrypt[id][tcVlad] == 0) return ErrorText(playerid, "{FF6347}Упс.. вы не успели. Кто-то уже совершил сделку по этому трейду"), TradeList(playerid, 0);
    if (TradeCrypt[id][tcCount] < count || count <= 0) return ErrorText(playerid, "{FF6347}Введите корректную сумму"), inserttobuy(playerid, id);
    if(PlayerInfo[playerid][pDonateMoney] < count) return ErrorText(playerid, "{FF6347}Вам не хватает золота"), inserttobuy(playerid, id);

    new price = count*TradeCrypt[id][tcCourse];

    new string[140];
    new temp_name[24];
    format(temp_name, 24, "%s", TradeCrypt[id][tcName]);

    new para = ReturnUserID(TradeCrypt[id][tcVlad]);
    if(IsPlayerConnected(para))
    {
        if(OnlineInfo[para][oLogged] == 0) return ErrorText(playerid, "{FF6347}Покупатель подключается к серверу.. Пожалуйста, дождитесь когда он авторизуется"), inserttobuy(playerid, id);
        PlayerInfo[para][pDonateMoney] += count;
        mysql_save(para, 4);

        // Уведомление челу, если он в игре
        if(OnlineInfo[para][oLogged] == 1)
        {
   			SendClientMessage(para, COLOR_GREY, "{99ff66}[ GOLD TRADE ]: {cccccc}Успешная сделка на %d$ с {ff9000}%s {cccccc}| Ваш доход: {ffcc00}%dG", price, rpplayername(playerid), count);
        }

        format(string, sizeof(string),"Продал %dG за %d$", count, price);
        DonateLog("sellgold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[para][pID], PlayerInfo[para][pName], PlayerInfo[para][pPlaIP], -count, string);

        format(string, sizeof(string),"Купил %dG за %d$", count, price);
        DonateLog("buygold", PlayerInfo[para][pID], PlayerInfo[para][pName], PlayerInfo[para][pPlaIP], PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], count, string);
    }
    else
    {
        new string_mysql[120];
		mysql_format(pearsq, string_mysql,sizeof(string_mysql),"SELECT DonateMoney FROM `pp_igroki` WHERE `user_id` = '%d'", TradeCrypt[id][tcVlad]);
		mysql_tquery(pearsq, string_mysql, "get_tobuytradecrypto", "ddddds", playerid, TradeCrypt[id][tcVlad], price, id, count, TradeCrypt[id][tcName]);

        format(string, sizeof(string),"Продал %dG за %d$", count, price);
        DonateLog("sellgold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], TradeCrypt[id][tcVlad], TradeCrypt[id][tcName], "", -count, string);

        format(string, sizeof(string),"Купил %dG за %d$", count, price);
        DonateLog("buygold", TradeCrypt[id][tcVlad], TradeCrypt[id][tcName], "", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], count, string);
    }
    oGivePlayerMoney(playerid, price);
    PlayerInfo[playerid][pDonateMoney] -= count;
    mysql_save(playerid,4);

    PlayerPlaySound(playerid, 6401, 0,0,0);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я продал%s %s {ffcc00}%dG {cccccc}за {99ff66}%d$", gender(playerid), temp_name, count, price);
    CryptoLog(0, TradeCrypt[id][tcName],TradeCrypt[id][tcVlad], PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], "", count, TradeCrypt[id][tcCourse]);
	
    TradeCrypt[id][tcCount] -= count;
    if (TradeCrypt[id][tcCount] <= 0)
    {
        deltradecrypto(id);
    }
    else
    {
        new string_mysql[256];
		mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_tradecrypto` SET `count`='%d' WHERE `newid` = '%d'", TradeCrypt[id][tcCount], TradeCrypt[id][tcNewid]);
		mysql_tquery(pearsq, string_mysql);
    }
    TradeList(playerid, DP[1][playerid]);
    return 1;
}

function get_tobuytradecrypto(playerid, userid, price, id, gold, const name_seller[])
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
        new donatemoneyplayer, string[100];
        cache_get_value_name_int(0, "DonateMoney", donatemoneyplayer);

        mysql_format(pearsq, string,sizeof(string),"UPDATE `pp_igroki` SET `DonateMoney`='%d' WHERE `user_id` = '%d'", donatemoneyplayer + gold , userid);
        query_empty(pearsq, string);

        format(string, sizeof(string), "%s продал вам %d Gold за %d$", PlayerInfo[playerid][pName], gold, price);
        notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], userid, name_seller, string);
	}
	return 1;
}

stock gotosellcrypto(playerid,id,count) // playerid покупает голду
{
    if (TradeCrypt[id][tcVlad] == 0) return ErrorText(playerid, "{FF6347}Упс.. вы не успели. Кто-то уже совершил сделку по этому трейду"), TradeList(playerid, 0);
    if (TradeCrypt[id][tcCount] < count || count <= 0) return ErrorText(playerid, "{FF6347}Введите корректную сумму"), inserttobuy(playerid, id);
    new price = count*TradeCrypt[id][tcCourse];
    if(oGetPlayerMoney(playerid) < price) return ErrorText(playerid, "{FF6347}Вам не хватает денег"), inserttobuy(playerid, id);

    new string[140];
    new temp_name[24];
    format(temp_name, 24, "%s", TradeCrypt[id][tcName]);

    new para = ReturnUserID(TradeCrypt[id][tcVlad]);
    if(IsPlayerConnected(para))
    {
        if(OnlineInfo[para][oLogged] == 0) return ErrorText(playerid, "{FF6347}Продавец подключается к серверу.. Пожалуйста, дождитесь когда он авторизуется"), inserttobuy(playerid, id);
        PlayerInfo[para][pAccount] += price;
        mysql_save(para, 1);

        // Уведомление челу, если он в игре
        if(OnlineInfo[para][oLogged] == 1)
        {
   			SendClientMessage(para, COLOR_GREY, "{99ff66}[ GOLD TRADE ]: {cccccc}Успешная сделка на %dG с {ff9000}%s {cccccc}| Ваш доход: {99ff66}%d$ [%s]", count, rpplayername(playerid), price, get_k(price));
        }

        format(string, sizeof(string),"Купил %dG за %d$", count, price);
        DonateLog("buygold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[para][pID], PlayerInfo[para][pName], PlayerInfo[para][pPlaIP], count, string);

        format(string, sizeof(string),"Продал %dG за %d$", count, price);
        DonateLog("sellgold", PlayerInfo[para][pID], PlayerInfo[para][pName], PlayerInfo[para][pPlaIP], PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], -count, string);
    }
    else
    {
        new string_mysql[120];
		mysql_format(pearsq, string_mysql,sizeof(string_mysql),"SELECT Account FROM `pp_igroki` WHERE `user_id` = '%d'", TradeCrypt[id][tcVlad]);
		mysql_tquery(pearsq, string_mysql, "get_toselltradecrypto", "ddddds", playerid, TradeCrypt[id][tcVlad], price, id, count, TradeCrypt[id][tcName]);

        format(string, sizeof(string),"Купил %dG за %d$", count, price);
        DonateLog("buygold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], TradeCrypt[id][tcVlad], TradeCrypt[id][tcName], "", count, string);

        format(string, sizeof(string),"Продал %dG за %d$", count, price);
        DonateLog("sellgold", TradeCrypt[id][tcVlad], TradeCrypt[id][tcName], "", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], -count, string);
    }
    oGivePlayerMoney(playerid, -price);
    PlayerInfo[playerid][pDonateMoney] += count;
    mysql_save(playerid,4);

    PlayerPlaySound(playerid, 6401, 0,0,0);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я приобрел%s у %s {ffcc00}%dG {cccccc}за {99ff66}%d$", gender(playerid), temp_name, count, price);
    CryptoLog(1, TradeCrypt[id][tcName],TradeCrypt[id][tcVlad], PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], "", count, TradeCrypt[id][tcCourse]);
    
    TradeCrypt[id][tcCount] -= count;
    if (TradeCrypt[id][tcCount] <= 0)
    {
        deltradecrypto(id);
    }
    else
    {
        new string_mysql[256];
		mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_tradecrypto` SET `count`='%d' WHERE `newid` = '%d'", TradeCrypt[id][tcCount], TradeCrypt[id][tcNewid]);
		mysql_tquery(pearsq, string_mysql);
    }
    TradeList(playerid, DP[1][playerid]);
    return 1;
}

function get_toselltradecrypto(playerid, userid, price, id, gold, const name_seller[])
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new moneyplayer, string[120];
        cache_get_value_name_int(0, "Account", moneyplayer);

        mysql_format(pearsq, string,sizeof(string),"UPDATE `pp_igroki` SET `Account`='%d' WHERE `user_id` = '%d'", moneyplayer + price , userid);
        query_empty(pearsq, string);

        format(string, sizeof(string), "%s купил у вас %d Gold за %d$", PlayerInfo[playerid][pName], gold, price);
        notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], userid, name_seller, string);
	}
	return 1;
}

function LoadTradeCrypto()
{
	new time = GetTickCount();
	new rows, unix = gettime();
	cache_get_row_count(rows);
	for(new f; f<rows; ++f)
	{
    	cache_get_value_name_int(f, "newid", TradeCrypt[f][tcNewid]);
    	cache_get_value_name_int(f, "active", TradeCrypt[f][tcActive]);
		cache_get_value_name_int(f, "vlad", TradeCrypt[f][tcVlad]);
		cache_get_value_name(f, "playername", TradeCrypt[f][tcName],24);
		cache_get_value_name_int(f, "count", TradeCrypt[f][tcCount]);
		cache_get_value_name_int(f, "cource", TradeCrypt[f][tcCourse]);
		cache_get_value_name_int(f, "unix", TradeCrypt[f][tcUnix]);


        if(TradeCrypt[f][tcUnix] > 0 && unix - TradeCrypt[f][tcUnix] >= 864000)
        {
            new string_mysql[120];
            mysql_format(pearsq, string_mysql,sizeof(string_mysql),"SELECT DonateMoney, Account FROM `pp_igroki` WHERE `user_id` = '%d'", TradeCrypt[f][tcVlad]);
		    mysql_tquery(pearsq, string_mysql, "Call_returncrypto", "dd", TradeCrypt[f][tcVlad], f);
        }
	}
	printf("[MODE]: Trade Gold [%d Quan][%d ms]",rows,GetTickCount() - time);
	return 1;
}

function Call_returncrypto(characterid, d)
{
    new rows;
    cache_get_row_count(rows);
    if(rows)
    {
        new string[120];
        if(TradeCrypt[d][tcActive] == 0) // Продавал золото
        {
            new donatemoneyplayer;
            cache_get_value_name_int(0, "DonateMoney", donatemoneyplayer);

            mysql_format(pearsq, string,sizeof(string),"UPDATE `pp_igroki` SET `DonateMoney`='%d' WHERE `user_id` = '%d'", donatemoneyplayer + TradeCrypt[d][tcCount] , characterid);
            query_empty(pearsq, string);

            DonateLog("goldtrade", characterid, TradeCrypt[d][tcName], "", 0, "", "", TradeCrypt[d][tcCount], "Отмена трейда при запуске");
        }
        else // Покупал золото
        {
            new moneyplayer;
            cache_get_value_name_int(0, "Account", moneyplayer);

            mysql_format(pearsq, string,sizeof(string),"UPDATE `pp_igroki` SET `Account`='%d' WHERE `user_id` = '%d'", moneyplayer + TradeCrypt[d][tcCourse]*TradeCrypt[d][tcCount], characterid);
            query_empty(pearsq, string);

            MoneyLog("goldtrade", characterid, TradeCrypt[d][tcName], "", 0, "", "", TradeCrypt[d][tcCourse]*TradeCrypt[d][tcCount], "Отмена трейда при запуске");
        }

        format(string, sizeof(string), "Ваш Gold трейд № %d был удалён", d + 1);
        notify(0, "", characterid, TradeCrypt[d][tcName], string);
    }
    deltradecrypto(d); // Удаляем трейд
    return 1;
}

stock CheckCancelCrypto(playerid, stat)
{
    new unix = gettime(), quan;
    for(new d = 0; d < MAX_TRADECRYPT; d++)
    {
        if(TradeCrypt[d][tcVlad] == PlayerInfo[playerid][pID])
        {
            if(unix - TradeCrypt[d][tcUnix] >= 604800) // Трейд был создан больше 7 дней назад
            {
                if(TradeCrypt[d][tcActive] == 0) // Продавал золото
                {
                    PlayerInfo[playerid][pDonateMoney] += TradeCrypt[d][tcCount];
                    mysql_save(playerid, 4);

                    DonateLog("goldtrade", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", TradeCrypt[d][tcCount], "Отмена трейда при входе");
                }
                else // Покупал золото
                {
                    PlayerInfo[playerid][pAccount] += TradeCrypt[d][tcCourse]*TradeCrypt[d][tcCount];
                    mysql_save(playerid, 1);

                    MoneyLog("goldtrade", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", TradeCrypt[d][tcCount], "Отмена трейда при входе");
                }
                deltradecrypto(d); // Удаляем трейд
                quan ++;
            }
        }
    }

    if(quan > 0 && stat == 1)
    {
        new string[120];
        format(string, sizeof(string), "{0088ff}У вас удалены неактивные трейды в количестве %d {ffcc66}[ N >> Ноутбук >> Голд Трейд ]", quan);
        SendClientMessage(playerid, COLOR_GREY, string);
    }
    return 1;
}

stock CryptoLog(status, const nameplayer[],playerID, senderpID, const namesender[], const senderip[], const playerip[], countsell, countcourse)
{
	new query[600], unix = gettime();
    mysql_format(pearsq, query, sizeof(query), "INSERT INTO `crypto_log`\
	    (`tradecryptoSenderID`,`tradecryptoPlayerID`,`tradecryptoPlayerName`,`tradecryptoSenderName`,`tradecryptoPlayerIP`,`tradecryptoSenderIP`,\
        `tradecryptoStatus`,`tradecryptoCount`,`tradecryptoCourse`,`tradecryptoUnix`) VALUES ('%d','%d','%e','%e','%e','%e','%d','%d','%d','%d')",
    senderpID, playerID, nameplayer, namesender, playerip, senderip,status, countsell, countcourse, unix);
	mysql_tquery(pearsq, query);
}

stock UpdateLabelBank()
{
    new string[34];
    format(string,sizeof(string), "1G = {99FF66}%d$", tclArifmetik);
    SetDynamicObjectMaterialText(BankTabloObject[1], 0, string, 130, "Arial", 50, 1, 0xFFFFCC00, 0x00000000, 0);
    SetDynamicObjectMaterialText(BankTabloObject[3], 0, string, 130, "Arial", 50, 1, 0xFFFFCC00, 0x00000000, 0);
    format(string,sizeof(string), "%dG",tclArifmetikAllGold);
    SetDynamicObjectMaterialText(BankTabloObject[0], 0, string, 130, "Arial", 50, 1, 0xFFFFCC00, 0x00000000, 0);
    SetDynamicObjectMaterialText(BankTabloObject[2], 0, string, 130, "Arial", 50, 1, 0xFFFFCC00, 0x00000000, 0);
}

function LoadCryptoLog()
{
	new time = GetTickCount();
	new rows,rowslast;
	cache_get_row_count(rows);
    if(rows == 0)
    {
        tclArifmetik = 1000;
    }
    else
    {
        if(rows > 20) rowslast = rows - 20;
        else rowslast = 0;
        for(new f=rowslast,i; f<rows; ++f,i++)
        {
            cache_get_value_name_int(f, "tradecryptoCourse", TradeCryptLog[i][tclCourse]);
            tclArifmetik += TradeCryptLog[i][tclCourse];
        }
        if(rows > 20) tclArifmetik /= 20;
        else tclArifmetik /= rows;
    }
	printf("[MODE]: Trade Gold Log [%d Quan][%d ms]. Course = %d",rows,GetTickCount() - time,tclArifmetik);
    UpdateLabelBank();
	return 1;
}

CMD:cryptolog(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 20 && server != 0) return 0;      
    mysql_tquery(pearsq, "SELECT * FROM `crypto_log`", "LoadCryptoLog", ""); // Высчитываем курс
    UpdateLabelBank();
    return 1;
}

CMD:goldturnover(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу выполнить это действие");
	if(AntiFloodMysqlRequest(playerid, 30)) return 1;
	ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Поиск золота на аккаунтах","{cccccc}Поиск игроков...","*","");
	mysql_tquery(pearsq, "SELECT DonateMoney, Ammo8 FROM `pp_igroki` WHERE `DonateMoney`>='1' OR `Ammo8`>='1'", "Call_turnovergold", "d", playerid);
	return 1;
}

function Call_turnovergold(playerid)
{
    new time = GetTickCount();
	new rows, gold, goldchips;
	new year, month,day;
    tclArifmetikAllGold = 0;
	getdate(year, month, day);
	cache_get_row_count(rows);
	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "Ammo8",gold);
		cache_get_value_name_int(i, "DonateMoney", goldchips);
		tclArifmetikAllGold += gold + goldchips;
	}
    printf("[MODE]: AllGoldLog [%d Quan][%d ms]. Count = %d",rows,GetTickCount() - time,tclArifmetikAllGold);
    if(playerid != -1) ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Поиск золота на аккаунтах","{66ff99}Загружено. Итоги уже на таблице в банке!","*","");
    UpdateLabelBank();
	return 1;
}

// Информация про юниты в меню bank online
stock InfoUnit(playerid)
{
	new line[100],lines[800];
	format(line,sizeof(line),"{9900ff}Что такое Юниты?"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Это валюта, которая начисляется на ваш счёт в организации,"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}когда вы выполняете различную работу."), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Пример: доставляете ящики с боеприпасами на склад"), strcat(lines,line);
	format(line,sizeof(line),"\n\n{9900ff}Что делать с Юнитами?"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Их можно обменять на вирты в этом меню, когда вы вступите в организацию."), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Лидер каждой организации настраивает размер оплаты юнитами,"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}а так-же интервалы и время, когда вы сможете их обменивать на вирты."), strcat(lines,line);
	ShowDialog(playerid,515,DIALOG_STYLE_MSGBOX,"{9900ff}Юниты",lines,"*","");
	return 1;
}

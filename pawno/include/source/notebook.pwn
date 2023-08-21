#define MAX_TRADECRYPT 1000
enum TradeCryptInfo //  Переменные автобусных остановок
{
    tcNewid, // id в базе
    tcStatus, // Статус у владельца
	tcActive, // установлена ли активность
    tcName[24], // NickName продовца
    tcVlad[24], // Номер Аккаунта
	tcCount, // Количество
	tcCourse, // Курс за еденицу
    tcUnix, // unix
};
new TradeCrypt[MAX_TRADECRYPT][TradeCryptInfo];

stock TradeList(playerid)
{
    new quan;
    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"{cccccc}Продажа/Скупка\tКоличество крипты\t{FF6347}Курс\t{99ff66}Суммарно"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Создать запрос\t\t\t"), strcat(lines,line);
    for(new d; d < MAX_TRADECRYPT; d++)
    {
        if(TradeCrypt[d][tcVlad] == 0 ) continue;
        if(TradeCrypt[d][tcActive] == 0)
        {
            format(line,sizeof(line),"\n{cccccc}№ %d. Продажа:\t%d\t{FF6347}%d\t{99ff66}%d", d+1, TradeCrypt[d][tcCount], TradeCrypt[d][tcCourse], TradeCrypt[d][tcCourse]*TradeCrypt[d][tcCount]), strcat(lines,line);
        }
        else
        {
            format(line,sizeof(line),"\n{cccccc}№ %d. Скупка:\t%d\t{FF6347}%d\t{99ff66}%d", d+1, TradeCrypt[d][tcCount], TradeCrypt[d][tcCourse], TradeCrypt[d][tcCourse]*TradeCrypt[d][tcCount]), strcat(lines,line);
        }
        List[quan][playerid] = d;
		quan ++;
    }
    ShowDialog(playerid,1379,DIALOG_STYLE_TABLIST_HEADERS,"Биржевые сделки",lines,"выбрать","");
}

CMD:ptrade(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 20)
	{
	 TradeList(playerid);
	}
	return 1;
}


stock dialogCase_notebook(playerid, dialogid,response, listitem, const inputtext[])
{
	if(dialogid == 1379) // вывод меню
	{
        if(response)
        {
            if(listitem == 0)
			{
                format(lines,sizeof(lines),""); // Очищаем Lines
                if(TradeCrypt[playerid][tcStatus] == 0)
                {
                    format(line,sizeof(line),"{cccccc}Введите кол.во золота, которую хотите продать"), strcat(lines,line);
                    format(line,sizeof(line),"\n{cccccc}Мой Счёт: {FFCC00}%d PearsCoin [%s]", PlayerInfo[playerid][pDonateMoney],get_k(PlayerInfo[playerid][pDonateMoney])), strcat(lines,line);
                    format(line,sizeof(line),"\n{cccccc}Продажа золота {99ff66} [Сменить]"), strcat(lines,line);
                }
                else
                {
                    format(line,sizeof(line),"{cccccc}Введите кол.во золота, которую хотите купить"), strcat(lines,line);
                    format(line,sizeof(line),"\n{cccccc}Мой Счёт: {FFCC00}%d PearsCoin [%s]", PlayerInfo[playerid][pDonateMoney],get_k(PlayerInfo[playerid][pDonateMoney])), strcat(lines,line);
                    format(line,sizeof(line),"\n{cccccc}Скупка золота {99ff66} [Сменить]"), strcat(lines,line);
                }
				ShowDialog(playerid,1378,DIALOG_STYLE_TABLIST,"Создание запроса",lines,"выбрать","");
			}
			if(listitem >= 1 && listitem <= 50)
			{
                new listtrade = List[listitem-1][playerid];
                DP[3][playerid] = listtrade;
                if(TradeCrypt[listtrade][tcVlad] == PlayerInfo[playerid][pID]) inserttodelete(playerid,listtrade);
                else inserttobuy(playerid,listtrade);
                
			}
        }
    } 
    else if (dialogid == 1378) // 
    {
        if(response)
        {
            format(lines,sizeof(lines),""); // Очищаем Lines
            if(listitem < 0 || listitem > 2) return ErrorMessage(playerid,"Лист итем паленный какой-то");
            if(listitem == 0)
            {
                if(TradeCrypt[playerid][tcStatus] == 0) ShowDialog(playerid,1377,DIALOG_STYLE_INPUT,"{ff9000}Трейд золота","{cccccc}Чтобы {99ff66}продать {cccccc}золота введите его количество\n\nНе меньше 1 и не больше 1000","Принять","Отмена");
                else ShowDialog(playerid,1377,DIALOG_STYLE_INPUT,"{ff9000}Трейд золота","{cccccc}Чтобы {FF6347}купить{cccccc} золото введите его количество\n\nНе меньше 1 и не больше 1000","Принять","Отмена");
            }
            else if(listitem == 1)
            {
                TradeList(playerid);
            }
            else if(listitem == 2)
            {
                if(TradeCrypt[playerid][tcStatus] == 0) TradeCrypt[playerid][tcStatus] = 1;
				else TradeCrypt[playerid][tcStatus] = 0;
                TradeList(playerid);
            }
            else return 1;
        }
    }
    else if(dialogid == 1377) //
    {
        if(response)
		{
            format(lines,sizeof(lines),""); // Очищаем Lines
            new input = strval(inputtext);
            if(sscanf(inputtext, "i", input)) return ErrorMessage(playerid, "{FF6347}Чувачек чет с вводом не так");
            if(input < 10 || input > 1000) return ErrorMessage(playerid, "{FF6347}Количество не меньше 10 и не больше 1000");
            if(TradeCrypt[playerid][tcStatus] == 0)
            {
                if(input > PlayerInfo[playerid][pDonateMoney]) return ErrorMessage(playerid, "{FF6347}У вас нет такого количества золота.");
            }
            DP[4][playerid] = input;
			ShowDialog(playerid,1376,DIALOG_STYLE_INPUT,"{ff9000}Трейд золота","{cccccc}Введите курс за 1 единицу.\n\nНе меньше 1$ и не больше 50000$","Принять","Отмена");
        }
    }
    else if(dialogid == 1376) //
    {
        if(response)
        {
            new input = strval(inputtext);
            if(sscanf(inputtext, "i", input)) return ErrorMessage(playerid, "{FF6347}Чувачек чет с вводом не так");
            if(input < 1 || input > 50000) return ErrorMessage(playerid, "{FF6347}Курс должен быть не меньше 1$ и не больше 50000$");
            new donate = DP[4][playerid];
            if(IsALimitTradePlayer(playerid) >= 5) return ErrorMessage(playerid,"Нет личных свободных слотов для торговли [Лимит: 5]");
            new id = GetFreeSlotTrade();
            if(id == -1) return ErrorMessage(playerid,"Нет свободных слотов");
            if(TradeCrypt[playerid][tcStatus] == 1)
            {
                if(input*donate > PlayerInfo[playerid][pAccount]) return ErrorMessage(playerid, "{FF6347}На банковском счету недостаточно средств");
                PlayerInfo[playerid][pAccount] -= input*donate;
                TradeCrypt[id][tcActive] = 1;
                mysql_save(playerid, 1);
            }
            else if(TradeCrypt[playerid][tcStatus] == 0)
            {
                PlayerInfo[playerid][pDonateMoney] -= donate;
                TradeCrypt[id][tcActive] = 0;
                mysql_save(playerid, 4);
            }
			TradeCrypt[id][tcCount] = donate;
            TradeCrypt[id][tcCourse] = input;
            new unix = gettime();
            TradeCrypt[id][tcVlad] = PlayerInfo[playerid][pID];
            TradeCrypt[id][tcName] = PlayerInfo[playerid][pName];
            TradeCrypt[id][tcUnix] = unix;
			format(big_query,sizeof(big_query),"INSERT INTO `pp_tradecrypto` SET `active`='%d',`vlad`='%d',`playername`='%s',`count`='%d',`cource`='%d',`unix`='%d'",TradeCrypt[id][tcActive],PlayerInfo[playerid][pID],PlayerInfo[playerid][pName],TradeCrypt[id][tcCount],TradeCrypt[id][tcCourse], unix);
			mysql_tquery(pearsq, big_query, "OnPlayerTradeCrypto", "d", id);
            PlayerPlaySound(playerid,6401,0,0,0);
			ShowDialog(playerid,1702,DIALOG_STYLE_MSGBOX, "Создание запроса","Запрос успешно создан!", "Ок", "");
        }
    }
    else if(dialogid == 1375) // Удаление заявки
    {
        if(response)
		{
            new id = DP[3][playerid];
            if(listitem < 0 || listitem > 2) return ErrorMessage(playerid, "Брат, куда лезишь?");
            if (listitem >= 0 && listitem <= 1) return inserttodelete(playerid, id);
            else deltradecrypto(id);
        }
    }
    else if(dialogid == 1374) // Покупка по заявке
    {
        if(response)
		{
            new id = DP[3][playerid];
            if(listitem < 0 || listitem > 5) return ErrorMessage(playerid, "Брат, куда лезишь?");
            if (listitem >= 0 && listitem <= 3) return inserttobuy(playerid, id);
            else 
            {
                	if(TradeCrypt[id][tcActive] == 1) gotobuycrypto(playerid,id);
                    else if(TradeCrypt[id][tcActive] == 0) gotosellcrypto(playerid,id);
            }
        }
    }
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
    format(lines,sizeof(lines),""); // Очищаем Lines

    format(line,sizeof(line),"{cccccc}Количество: \t{ffffff}%d", TradeCrypt[id][tcCount]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Курс: \t{ffffff}%d", TradeCrypt[id][tcCourse]), strcat(lines,line);
    format(line,sizeof(line),"\n{FF6347}Удалить заявку\t "), strcat(lines,line);
    DP[3][playerid] = id;
	ShowDialog(playerid,1375,DIALOG_STYLE_TABLIST,"{cccccc}Ваша заявка",lines,"Выбрать","Отмена");
	return 1;
}

stock inserttobuy(playerid, b) // Покупка по заявки
{
    format(lines,sizeof(lines),""); // Очищаем Lines

    format(line,sizeof(line),"{cccccc}Продавец: \t{ffffff}%s", TradeCrypt[b][tcName]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Курс: \t{ffffff}%d", TradeCrypt[b][tcCourse]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Количество: \t{ffffff}%d", TradeCrypt[b][tcCount]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Стоимость: \t{ffffff}%d", TradeCrypt[b][tcCourse]*TradeCrypt[b][tcCount]), strcat(lines,line);
    format(line,sizeof(line),"\n{FF6347}Купить по данной заявки\t "), strcat(lines,line);
	if(TradeCrypt[b][tcActive] == 1)format(store,sizeof(store),"{cccccc}Заявка на скупку золота");
    else if(TradeCrypt[b][tcActive] == 0)format(store,sizeof(store),"{cccccc}Заявка на продажу золота");
    DP[3][playerid] = b;
	ShowDialog(playerid,1374,DIALOG_STYLE_TABLIST,store,lines,"Купить","Отмена");
	return 1;
}

stock deltradecrypto(id) // Удаляем заказ доставки товара в бизнесы
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
    format(big_query, sizeof(big_query), "DELETE FROM `pp_tradecrypto` WHERE `newid` = '%d'",TradeCrypt[idx][tcNewid]);
    query_empty(pearsq, big_query);
  	return 1;
}

stock gotobuycrypto(playerid,id)
{
    if (TradeCrypt[id][tcVlad] == 0) return ErrorMessage(playerid,"Данный запрос не активен");
    new price = TradeCrypt[id][tcCount]*TradeCrypt[id][tcCourse];
    if(PlayerInfo[playerid][pDonateMoney] < TradeCrypt[id][tcCount]) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня нет столько золота");
    new para = ReturnUserID(TradeCrypt[id][tcVlad]);
    if(IsPlayerConnected(para))
    {
        if(OnlineInfo[para][oLogged] == 0) return ErrorMessage(playerid,"Игрок не залогинился, дождитесь пока он авторизуется");
        PlayerInfo[para][pDonateMoney] += TradeCrypt[id][tcCount];
        mysql_save(playerid, 4);
    }
    else
    {
		format(store,sizeof(store),"SELECT * FROM `pp_igroki` WHERE `id` = '%d'", TradeCrypt[id][tcVlad]);
		mysql_tquery(pearsq, store, "get_tobuytradecrypto", "dddd", playerid, TradeCrypt[id][tcVlad],price,id);
    }
    oGivePlayerMoney(playerid, price);
    PlayerInfo[playerid][pDonateMoney] -= TradeCrypt[id][tcCount];
    mysql_save(playerid,4);
    format(store,sizeof(store),"[ Мысли ]: Я продал %d золота, за %d$",TradeCrypt[id][tcCount],price);
    SendClientMessage(playerid, COLOR_GREY, store);
	return 1;
}
function get_tobuytradecrypto(playerid, id,price)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new plaid,donatemoneyplayer,plaidName[24];
	    cache_get_value_name_int(0, "id", plaid);
        cache_get_value_name_int(0, "DonateMoney", donatemoneyplayer);
        cache_get_value_name(0, "Name", plaidName,24);
	    format(store,sizeof(store),"SELECT * FROM `pp_igroki` WHERE `id`='%d'", plaid);
      	mysql_tquery(pearsq, store, "processsellofflinetradecrypto", "ddddds", playerid, plaid,donatemoneyplayer,price,id,plaidName);
	}
	else format(store,sizeof(store),"{FF6347}Такого аккаунта не существует с данным трейдом"), ErrorMessage(playerid, store);
	return 1;
}

function processsellofflinetradecrypto(playerid, plaid,donatemoneyplayer,price,id,const plaidName[])
{
    new query[512],money;
    money = price;
    if(playerid >= 0)
    {
        PlayerPlaySound(playerid, 6401, 0,0,0);
        format(query, sizeof(query),"\n{cccccc}Вы продали %d золота. Купил %s за %d$",TradeCrypt[id][tcCount],plaidName,money);
        ShowDialog(playerid,1012,DIALOG_STYLE_MSGBOX, "{ff0000}*", query, "Ок", "");
    }
    format(big_query,sizeof(big_query),"UPDATE `pp_igroki` SET `DonateMoney`='%d' WHERE `id` = '%d'", donatemoneyplayer + TradeCrypt[id][tcCount], plaid);
    query_empty(pearsq, big_query);
    
    format(query, sizeof(query), "Вам продали %d золота. Продал %s за %d$",TradeCrypt[id][tcCount],PlayerInfo[playerid][pName],money);
    notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName],plaid, plaidName, query);
    deltradecrypto(id);
		
		//format(query, sizeof(query), "Занес в ДП %s", frakeasyName[g]), OrgLog(g, "inhb", tmpTPlayerID, tmpTName,PlayerInfo[tmpTPlayerID][pPlaIP], plaid, tmpName,PlayerInfo[plaid][pPlaIP],0, query);
	return 1;
}

stock gotosellcrypto(playerid,id)
{
    if (TradeCrypt[id][tcVlad] == 0) return ErrorMessage(playerid,"Данный запрос не активен");
    new price = TradeCrypt[id][tcCount]*TradeCrypt[id][tcCourse];
    if(oGetPlayerMoney(playerid) < price) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мне не хватает денег");
    new para = ReturnUserID(TradeCrypt[id][tcVlad]);
    if(IsPlayerConnected(para))
    {
        if(OnlineInfo[para][oLogged] == 0) return ErrorMessage(playerid,"Игрок не залогинился, дождитесь пока он авторизуется");
        PlayerInfo[para][pAccount] += price;
        mysql_save(playerid, 1);
    }
    else
    {
		format(store,sizeof(store),"SELECT * FROM `pp_igroki` WHERE `id` = '%d'", TradeCrypt[id][tcVlad]);
		mysql_tquery(pearsq, store, "get_toselltradecrypto", "dddd", playerid, TradeCrypt[id][tcVlad],price,id);
    }
    oGivePlayerMoney(playerid, -price);
    PlayerInfo[playerid][pDonateMoney] += TradeCrypt[id][tcCount];
    mysql_save(playerid,4);
    format(store,sizeof(store),"[ Мысли ]: Я приобрел %d золота, за %d$",TradeCrypt[id][tcCount],price);
    SendClientMessage(playerid, COLOR_GREY, store);
	return 1;
}

function get_toselltradecrypto(playerid,plaidd, price,id)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new plaid,moneyplayer,plaidName[24];
	    cache_get_value_name_int(0, "id", plaid);
        cache_get_value_name_int(0, "Account", moneyplayer);
        cache_get_value_name(0, "Name", plaidName,24);
	    format(store,sizeof(store),"SELECT * FROM `pp_igroki` WHERE `id`='%d'", plaid);
      	mysql_tquery(pearsq, store, "processbuyofflinetradecrypto", "ddddds", playerid, plaid,moneyplayer,price,id,plaidName);
	}
	else format(store,sizeof(store),"{FF6347}Такого аккаунта не существует с данным трейдом"), ErrorMessage(playerid, store);
	return 1;
}

function processbuyofflinetradecrypto(playerid, plaid,moneyplayer,price,id,const plaidName[])
{
    new query[512],money;
    money = price;
    if(playerid >= 0)
    {
        PlayerPlaySound(playerid, 6401, 0,0,0);
        format(query, sizeof(query),"\n{cccccc}Вы купили %d золото у %s за %d$",TradeCrypt[id][tcCount],plaidName,money);
        ShowDialog(playerid,1012,DIALOG_STYLE_MSGBOX, "{ff0000}*", query, "Ок", "");
    }
    format(big_query,sizeof(big_query),"UPDATE `pp_igroki` SET `Account`='%d' WHERE `id` = '%d'", moneyplayer + money , plaid);
    query_empty(pearsq, big_query);
    
    format(query, sizeof(query), "У вас купили %d золото. Купил %s за %d$",TradeCrypt[id][tcCount],PlayerInfo[playerid][pName],money);
    notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName],plaid, plaidName, query);
    deltradecrypto(id);
    
    //format(query, sizeof(query), "Занес в ДП %s", frakeasyName[g]), OrgLog(g, "inhb", tmpTPlayerID, tmpTName,PlayerInfo[tmpTPlayerID][pPlaIP], plaid, tmpName,PlayerInfo[plaid][pPlaIP],0, query);

	return 1;
}
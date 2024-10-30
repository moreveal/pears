
#define REFERAL_PROCENT_DONATE 10
#define MAX_DONATE_SERVICE 16

new donatePrice[MAX_DONATE_SERVICE];

// Активация Скидки
stock discount()
{
	for(new i = 0; i < MAX_DONATE_SERVICE; i++)
    {
        if(donatePrice[i] > 0)
        {
            donatePrice[i] = donatePrice[i]-(donatePrice[i]/100*ServerInfo[58]);
        }
    }
}

// Установка ценников на донаты
stock defaultPriceDonate()
{
    donatePrice[0] = 6; // Временная VIP (стоимость 1 день випки)
    donatePrice[1] = 900; // Platinum VIP
    donatePrice[2] = 600; // Создание семьи
    donatePrice[3] = 50; // Сменить ник
    donatePrice[4] = 50; // Занять ник (резервирование никнейма)
    donatePrice[5] = 200; // Сменить номер телефона
    donatePrice[6] = 200; // Снять warn
    donatePrice[7] = 600; // Снять ban
    donatePrice[8] = 8; // Снять мут (стоимость 1 минуты мута)
    donatePrice[9] = 190; // Открыть слот транспорта
    donatePrice[10] = 50; // +1 уровень навыка
    donatePrice[11] = 90; // Максимальное знание языка
    donatePrice[12] = 90; // Стоимость кейса
    donatePrice[13] = 90; // Стоимость ремонта транспорта
    donatePrice[14] = 10; // Стоимость замены одного ежедневного задания
    donatePrice[15] = 790; // Стоимость голд кейса
}

stock GetPriceGoldDonateMenu(donateid)
{
    return donatePrice[donateid];
}

CMD:donate(playerid)
{
	PlayerPlaySound(playerid,1150,0,0,0);
    showDialogDonateMenu(playerid);
    return true;
}

stock showDialogDonateMenu(playerid)
{
    new lines[1200];
	format(lines, sizeof(lines),"{99ff66}Получить {ffcc00}Золото\
                            \n{ffcc00}Gold Trade {666666}[ Обменник Голды ]\
	                        \n{666666}Информация..\
	                        \n{ffcc00}VIP {cccccc}Аккаунт {666666}>>\
	                        \n{cccccc}Услуги Аккаунта {666666}>>\
	                        \n{cccccc}Навыки {666666}>>\
	                        \n{cccccc}Создать Семью {ffcc00}[%d G]\
                            \n{cccccc}Купить {FF9000}GOLD {cccccc}Кейс {ffcc00}[%d G]\
                            \n{cccccc}Ремонт Транспорта {ffcc00}[%d G]\
                            \n{666666}Где купить Скин/Одежду? {99ff66}>>\
                            \n{666666}Где купить Машину? {99ff66}>>\
                            \n{666666}Где купить Дом? {99ff66}>>\
                            \n{666666}Где купить Бизнес? {99ff66}>>", 
                            donatePrice[2], donatePrice[15], donatePrice[13]);
	ShowDialog(playerid,455,DIALOG_STYLE_TABLIST,"{cccccc}Меню {ff9000}Donate",lines,"Выбор","Отмена");
	return true;
}

stock showDialogHowBuySkin(playerid)
{
    ShowDialog(playerid,457,DIALOG_STYLE_MSGBOX,"{ff9000}Donate",
        "{ff9000}Купить одежду можно в любом магазине одежды \
        \n{cccccc}Для этого вам необходимо отправиться в магазин \
        \n{cccccc}Y >> GPS >> Услуги >> Магазины Одежды \
        \n\n{cccccc}Внутри магазина вы можете приобрести одежду как за вирты, \
        \n{cccccc}так и за {ffcc00}Gold","Ок","");
    return true;
}

stock showDialogHowBuyCar(playerid)
{
    ShowDialog(playerid,457,DIALOG_STYLE_MSGBOX,"{ff9000}Donate",
        "{ff9000}Купить машину можно в любом Автосервисе \
        \n{cccccc}Для этого вам необходимо отправиться в автосалон \
        \n{cccccc}Y >> GPS >> Транспорт >> Автосалоны \
        \n\n{cccccc}В автосалоне вы можете приобрести машину как за вирты, \
        \n{cccccc}так и за {ffcc00}Gold","Ок","");
    return true;
}

stock showDialogHowBuyHouse(playerid)
{
    ShowDialog(playerid,457,DIALOG_STYLE_MSGBOX,"{ff9000}Donate",
        "{ff9000}Для того, чтобы купить дом просто подойдите к нему и нажмите ALT \
        \n\n{cccccc}Вы можете приобрести дом как за вирты, так и за {ffcc00}Gold","Ок","");
    return true;
}

stock showDialogHowBuyBiz(playerid)
{
    ShowDialog(playerid,457,DIALOG_STYLE_MSGBOX,"{ff9000}Donate",
        "{ff9000}Для того, чтобы купить бизнес отправляйтесь в Бизнес Центр \
        \n{cccccc}Y >> GPS >> Услуги >> Бизнес Центр \
        \n\n{cccccc}В Бизнес Центре можно ознакомиться со всеми бизнесами \
        \n{cccccc}и посмотреть статистику доходов \
        \n{cccccc}Вы можете приобрести бизнес как за вирты, так и за {ffcc00}Gold","Ок","");
    return true;
}

// Меню покупки навыков
stock showDialogDonateSkills(playerid)
{
    new line[214],lines[4096];

	format(line,sizeof(line),"{cccccc}Max Владение Русским Языком \t {ffcc00}[%d G]", donatePrice[11]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Max Владение Японским Языком \t {ffcc00}[%d G]", donatePrice[11]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Max Владение Итальянским Языком \t {ffcc00}[%d G]", donatePrice[11]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Max Владение Китайским Языком \t {ffcc00}[%d G]", donatePrice[11]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Max Владение Испанским Языком \t {ffcc00}[%d G]", donatePrice[11]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Max Владение Арабским Языком \t {ffcc00}[%d G]", donatePrice[11]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Навык Силы +1 уровень \t {ffcc00}[%d G]", donatePrice[10]), strcat(lines,line);

    // Далее новые навыки
    new quan;
    for(new i = 0; i < MAX_ABILITY; i++)
    {
        List[quan][playerid]= i;
        quan ++;
        format(line,sizeof(line),"\n{cccccc}%s +1 уровень \t {ffcc00}[%d G]", abilityName[i], donatePrice[10]), strcat(lines,line);
    }
    ShowDialog(playerid,509,DIALOG_STYLE_TABLIST,"{ff9000}Donate",lines,"Выбор","Назад");
    return true;
}

stock showDialogConfirmationDonateSkills(playerid, ability)
{
    if(ability < 0 || ability >= MAX_ABILITY) return false; // Защита от несуществующих навыков
    DP[0][playerid] = ability;

    new line[100], lines[300];
    format(line,sizeof(line),"{cccccc}Покупка: {0088ff}%s", abilityName[ability]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Стоимость: {ffcc00}%dG", donatePrice[10]), strcat(lines,line);
    format(line,sizeof(line),"\n\n{ff9000}Вы уверены, что хотите оплатить покупку?"), strcat(lines,line);
    ShowDialog(playerid,856,DIALOG_STYLE_MSGBOX,"{ff9000}Donate",lines,"Да","Нет");
    return true;
}

stock GetDonate(playerid)
{
    if(server == 0) return ErrorMessage(playerid, "{FF6347}Недоступно на тестовом сервере");

    if(GetPVarInt(playerid,"afdonate") > 0)
    {
        new string[80];
        format(string,sizeof(string),"{FF6347}Пожалуйста, повторите запрос позже [ Подождите %d секунд ]", GetPVarInt(playerid,"afdonate"));
        ErrorText(playerid, string);
        pc_cmd_donate(playerid);
        return true;
    }
    SetPVarInt(playerid,"afdonate",20);


    if(GetPVarInt(playerid,"acall_donate") == 1) return ErrorMessage(playerid, "{FF6347}Пожалуйста, дождитесь начисления прежде чем отправлять следующий запрос");
    SetPVarInt(playerid,"acall_donate",1);
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ff9000}Pears Project","{ff9000}Загрузка платежей..","*","");
    new string_mysql[200];
    mysql_format(pearsq_3, string_mysql, sizeof(string_mysql),"SELECT * FROM `orders` WHERE `name` = '%e' AND `item_id` = '0' AND `status` = 'paid'", 
        PlayerInfo[playerid][pName]);
    mysql_tquery(pearsq_3, string_mysql, "Call_Donate", "d", playerid);
    return true;
}

stock showDialogErrorDonateCall(playerid)
{
    PlayerPlaySound(playerid,4203,0,0,0);
    ShowDialog(playerid,457,DIALOG_STYLE_MSGBOX,"{cccccc}Меню {ff9000}Donate",
        "{FF6347}На ваш аккаунт не поступали зачисления средств. \
        \n{cccccc}Пополняйте свой счёт самостоятельно на сайте \
        \n{0088ff}pears.fun >> {ffcc00}Магазин","Ок","");

    SetPVarInt(playerid,"acall_donate",0);
    return true;
}

forward Call_Donate(playerid);
public Call_Donate(playerid)
{
	new rows;
	cache_get_row_count(rows);

	// Ничего не нашли, значит донатов нет
	if(rows == 0) return showDialogErrorDonateCall(playerid);

	// Собираем все донаты на аккаунте
	new gold;
	for(new i = 0; i < rows; i++)
	{
		new amount;
		cache_get_value_name_int(0, "amount", amount);
		gold += amount;
	}

	// Общая сумма донатов, почему-то 0
	if(gold == 0) return showDialogErrorDonateCall(playerid);

    new string_mysql[200];
    new string[300];
    // Отмечаем инфу о том, что голда была выдана на аккаунт
    mysql_format(pearsq_3, string_mysql, sizeof(string_mysql), "UPDATE `orders` SET `status` = 'completed' WHERE `name` = '%e' AND `item_id` = '0' AND `status` = 'paid'",
        PlayerInfo[playerid][pName]);
    mysql_tquery(pearsq_3, string_mysql);

    // Запись в логе
    if(newskidka1 > 0) format(string, sizeof(string),"Автодонат X%d", newskidka1);
    else format(string, sizeof(string),"Автодонат");
    DonateLog("givegold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", gold, string);

    // Выдаём голду на аккаунт
    PlayerInfo[playerid][pDonateMoney] += gold;
    PlayerInfo[playerid][pDonateAll] += gold; // Сумма донатов за всё время

    format(string, sizeof(string),"{99ff66}Счёт Пополнен\
                                \n{cccccc}Начислено: {ffcc00}%dG\
                                \n{cccccc}Баланс: {ffcc00}%dG", 
                                gold, PlayerInfo[playerid][pDonateMoney]);
    ShowDialog(playerid,457,DIALOG_STYLE_MSGBOX,"{ff9000}Donate",string,"Ок","");
    PlayerPlaySound(playerid,6401,0,0,0);
    SendClientMessage(playerid, COLOR_GREY,"{0088ff}На ваш аккаунт начислено {ffcc00}%dG {ffcc66}[ Баланс %dG ]", gold, PlayerInfo[playerid][pDonateMoney]);

    // Сохраняем голду в базе
    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_igroki` SET `DonateMoney` = '%d',`DonateAll` = '%d' WHERE `user_id` = '%d'",
				PlayerInfo[playerid][pDonateMoney], PlayerInfo[playerid][pDonateAll], PlayerInfo[playerid][pID]);
	mysql_tquery(pearsq, string_mysql);

    // Ачивки
    if(PlayerInfo[playerid][pAchieve][36] == 0) AchievePlayer(playerid, 36, 1); // Первый Донат
    if(PlayerInfo[playerid][pAchieve][37] == 0 && PlayerInfo[playerid][pDonateAll] >= 500) AchievePlayer(playerid, 37, 1); // Общая сумма донатов
    if(PlayerInfo[playerid][pAchieve][38] == 0 && PlayerInfo[playerid][pDonateAll] >= 1000) AchievePlayer(playerid, 38, 1);
    if(PlayerInfo[playerid][pAchieve][39] == 0 && PlayerInfo[playerid][pDonateAll] >= 10000) AchievePlayer(playerid, 39, 1);
    if(PlayerInfo[playerid][pAchieve][40] == 0 && PlayerInfo[playerid][pDonateAll] >= 20000) AchievePlayer(playerid, 40, 1);
    if(PlayerInfo[playerid][pAchieve][41] == 0 && PlayerInfo[playerid][pDonateAll] >= 30000) AchievePlayer(playerid, 41, 1);
    if(PlayerInfo[playerid][pAchieve][42] == 0 && PlayerInfo[playerid][pDonateAll] >= 40000) AchievePlayer(playerid, 42, 1);
    if(PlayerInfo[playerid][pAchieve][43] == 0 && PlayerInfo[playerid][pDonateAll] >= 50000) AchievePlayer(playerid, 43, 1);
    if(PlayerInfo[playerid][pAchieve][44] == 0 && PlayerInfo[playerid][pDonateAll] >= 100000) AchievePlayer(playerid, 44, 1);
    if(PlayerInfo[playerid][pAchieve][26] == 0 && PlayerInfo[playerid][pDonateMoney] >= 10000) AchievePlayer(playerid, 26, 1); // Сумма на счёте больше 10к голды

    // Подарок игроку, который нас пригласил (Начисляем ему рефералы)
    if(PlayerInfo[playerid][pReferalID] > 0 && PlayerInfo[playerid][pReferalID] != PlayerInfo[playerid][pID])
    {
        new koef = gold/100;
        if(koef >= 1)
        {
            new proc = koef * REFERAL_PROCENT_DONATE;
            mysql_format(pearsq, string_mysql, sizeof(string_mysql),"SELECT Name, DonateMoney FROM `pp_igroki` WHERE `user_id` = '%d'", PlayerInfo[playerid][pReferalID]);
            new Cache:cache = mysql_query(pearsq, string_mysql);
            Call_giverefdon(playerid, PlayerInfo[playerid][pReferalID], proc, cache != MYSQL_INVALID_CACHE);
            if(cache != MYSQL_INVALID_CACHE) cache_delete(cache);
        }
    }

    SetPVarInt(playerid,"acall_donate",0);
	return 1;
}

// Выдаём проценты рефералу
function Call_giverefdon(playerid, user_id, gold, bool:IsValid)
{
	new string[160];
	if(IsValid == true)
	{
        new rows;
        cache_get_row_count(rows);
        if (!rows) return 1;
        
	    new referalName[24], playerGold, onl, string_mysql[140];
	    cache_get_value_name(0, "Name", referalName, sizeof(referalName));

	    new playa = ReturnUser(referalName, 1);
	    cache_get_value_name_int(0, "DonateMoney", playerGold);

        // Сохраняем голду в базу
	    mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `pp_igroki` SET `DonateMoney` = '%d' WHERE `user_id` = '%d'", playerGold + gold, user_id);
		mysql_query(pearsq, string_mysql, false);
 
        // Уведомление
        format(string, sizeof(string), "Вам начислен реферал %dG", gold);
	    notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], user_id, referalName, string);

        // Если этот игрок онлайн, выдаём ему всё на аккаунт и оповещаем
	    if(IsOnline(playa))
		{
            PlayerInfo[playa][pDonateMoney] += gold;
			if(OnlineInfo[playa][oLogged] == 1)
			{
                PlayerPlaySound(playa,6401,0,0,0);
                SendClientMessage(playa, COLOR_GREY,"{0088ff}На ваш аккаунт начислено {ffcc00}%dG {ffcc66}| Реферал от %s[%d]", gold, PlayerInfo[playerid][pName], playerid);
			}
		}

        // Логируем
        if(onl == 0) DonateLog("givegold",  user_id, referalName, "", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], gold, "Процент от доната");
		else DonateLog("givegold", user_id, referalName, PlayerInfo[playa][pPlaIP], PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], gold, "Процент от доната");
	}
	else // Аккаунт рефералки не был найден, значит очищаем навеки
	{
		PlayerInfo[playerid][pReferalID] = 0, format(PlayerInfo[playerid][pReferal], 24, "");
		mysql_format(pearsq, string, sizeof(string),"UPDATE `pp_igroki` SET `Referal` = '0', `ReferalID` = '0' WHERE `user_id` = '%d'", PlayerInfo[playerid][pID]);
		mysql_tquery(pearsq, string);
	}
	return 1;
}

stock dialogCase_DonateMenu(playerid, dialogid, response, listitem)
{
    if(dialogid == 509)
    {
        if(response)
        {
            // Покупка новых скилов
            if(listitem >= 7) return showDialogConfirmationDonateSkills(playerid, listitem - 7);

		    new atext[100], cena;
			if(listitem == 0) atext = "{cccccc}Владение Русским Языком", DP[0][playerid] = 16, cena = donatePrice[11];
			else if(listitem == 1) atext = "{cccccc}Владение Японским Языком", DP[0][playerid] = 17, cena = donatePrice[11];
			else if(listitem == 2) atext = "{cccccc}Владение Итальянским Языком", DP[0][playerid] = 18, cena = donatePrice[11];
			else if(listitem == 3) atext = "{cccccc}Владение Китайским Языком", DP[0][playerid] = 19, cena = donatePrice[11];
			else if(listitem == 4) atext = "{cccccc}Владение Испанским Языком", DP[0][playerid] = 20, cena = donatePrice[11];
			else if(listitem == 5) atext = "{cccccc}Владение Арабским Языком", DP[0][playerid] = 22, cena = donatePrice[11];
			else if(listitem == 6) atext = "{cccccc}Навык Силы +1 Уровень", DP[0][playerid] = 14, cena = donatePrice[10];

			new str[130],sctring[860];
			format(str,sizeof(str),"{cccccc}Покупка: {0088ff}%s\n", atext), strcat(sctring,str);
			format(str,sizeof(str),"{cccccc}Стоимость: {ffcc00}%dG\n", cena), strcat(sctring,str);
			format(str,sizeof(str),"\n\n{ff9000}Вы уверены, что хотите оплатить покупку?"), strcat(sctring,str);
			ShowDialog(playerid,852,DIALOG_STYLE_MSGBOX,"{ff9000}Donate",sctring,"Да","Нет");
	    }
        else pc_cmd_donate(playerid);
        return true;
    }
    else if(dialogid == 856)
    {
        if(response)
        {
            new ability = DP[0][playerid];
            if(ability < 0 || ability >= MAX_ABILITY) return false; // Защита от несуществующих навыков

            if(PlayerInfo[playerid][pAbilStat][ability] >= 10) return ErrorText(playerid, "{FF6347}Этот навык максимально прокачен"), showDialogDonateSkills(playerid);
            if(PlayerInfo[playerid][pDonateMoney] < donatePrice[10]) return ErrorText(playerid, "{FF6347}Вам не хватает золота для покупки"), showDialogDonateSkills(playerid);

	    	PlayerInfo[playerid][pDonateMoney] -= donatePrice[10];
			tclArifmetikAllGold -= donatePrice[10];
            mysql_save(playerid, 4);

            new string[200];
            format(string, sizeof(string), "{99ff66}Вы приобрели {ff9000}%s +1 Уровень\
                                            \n{cccccc}Стоимость: {ffcc66}%dG", 
                                            abilityName[ability], donatePrice[10]);
            SuccessMessage(playerid, string);

            new maxAbility = getability_max(PlayerInfo[playerid][pAbility][ability]);
            PlayerInfo[playerid][pAbility][ability] = maxAbility;
            update_ability(playerid, ability, 1);

            DonateLog("buyability",PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -donatePrice[10], abilityName[ability]);
        }
        else showDialogDonateSkills(playerid);
        return true;
    }
    return false;
}

stock GivePlatinumVip(playerid)
{
	PlayerInfo[playerid][pDonateRank] = 4;
    PlayerInfo[playerid][pUpgrade] = 0;
    if(PlayerInfo[playerid][pAchieve][118] == 0) AchievePlayer(playerid, 118, 1);
	return true;
}

alias:setvip("givevip")
CMD:setvip(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    new tmp[121], status;
    if(sscanf(params, "s[121]I(1)", tmp, status)
        || status < 0 || status > 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить статус Platinum VIP [ /setvip ID 0 или 1 ]");
	if(strlen(tmp) > 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Длина никнейма не больше 20-ти символов");

	new giveplayerid;
 	giveplayerid = ReturnUser(tmp, 1);
	if(IsOnline(giveplayerid)) 
	{
        if(OnlineInfo[giveplayerid][oLogged] == 0) return ErrorMessage(playerid, "{FF6347}Игрок не залогинился");

        if(status == 1)
        {
            if(PlayerInfo[giveplayerid][pDonateRank] == 4) return ErrorMessage(playerid, "{FF6347}У игрока уже есть Platinum VIP");
            GivePlatinumVip(giveplayerid);
            mysql_save(giveplayerid, 4);

            SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы выдали %s Platinum VIP", PlayerInfo[giveplayerid][pName]);
            if(giveplayerid != playerid) SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "* %s выдал вам Platinum VIP", PlayerInfo[playerid][pName]);
            AdminLog("setvip", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], status, "Выдал Platinum VIP");
        }
        else
        {
            if(PlayerInfo[giveplayerid][pDonateRank] != 4) return ErrorMessage(playerid, "{FF6347}У игрока нет Platinum VIP");
            PlayerInfo[giveplayerid][pDonateRank] = 0;
            mysql_save(giveplayerid, 4);

            SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы забрали Platinum VIP у %s", PlayerInfo[giveplayerid][pName]);
            if(giveplayerid != playerid) SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "* %s забрал у вас Platinum VIP", PlayerInfo[playerid][pName]);
            AdminLog("setvip", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], status, "Забрал Platinum VIP");
        }
    }
    else
    {
        if(!CheckRP_Nickname(tmp)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
        new string[140];
        mysql_format(pearsq, string,sizeof(string),"SELECT user_id, DonateRank FROM `pp_igroki` WHERE `Name` = '%e'", tmp);
        mysql_tquery(pearsq, string, "Call_setvip", "dsd", playerid, tmp, status);
    }
    return true;
}

function Call_setvip(playerid, const str_name[], status)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new user_id, DonateRank;
		cache_get_value_name_int(0, "user_id", user_id);
        cache_get_value_name_int(0, "DonateRank", DonateRank);

        new string[120];
        if(status == 1)
        {
            if(DonateRank == 4) return ErrorMessage(playerid, "{FF6347}У игрока уже есть Platinum VIP");
            mysql_format(pearsq, string, sizeof(string), "UPDATE `pp_igroki` SET `DonateRank` = '4' WHERE `user_id` = '%d'", user_id);
		    mysql_tquery(pearsq, string);

            SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы выдали %s Platinum VIP", str_name);

            format(string, sizeof(string), "Админ %s выдал вам Platinum VIP", PlayerInfo[playerid][pName]);
 		    notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], user_id, str_name, string);
            AdminLog("setvip", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], user_id, str_name, "", status, "Выдал Platinum VIP");
        }
        else
        {
            if(DonateRank != 4) return ErrorMessage(playerid, "{FF6347}У игрока нет Platinum VIP");
            mysql_format(pearsq, string, sizeof(string), "UPDATE `pp_igroki` SET `DonateRank` = '0' WHERE `user_id` = '%d'", user_id);
		    mysql_tquery(pearsq, string);

            SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы забрали у %s Platinum VIP", str_name);

            format(string, sizeof(string), "Админ %s забрал у вас Platinum VIP", PlayerInfo[playerid][pName]);
 		    notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], user_id, str_name, string);
            AdminLog("setvip", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], user_id, str_name, "", status, "Забрал Platinum VIP");
        }
	}
	else ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
    return true;
}

stock RepairVehicleForGold(playerid)
{
    if(Protect_Veh[playerid] == 9999 && Protect_Seat[playerid] == 9999) return ErrorText(playerid, "{FF6347}Вы не в транспорте"), showDialogDonateMenu(playerid);
    if(PlayerInfo[playerid][pDonateMoney] < donatePrice[13]) return pc_cmd_donate(playerid), ErrorText(playerid, "{FF6347}Вам не хватает золота");

    new vehicleid;
    if(Protect_Veh[playerid] != 9999) vehicleid = Protect_Veh[playerid];
    else if(Protect_Seat[playerid] != 9999) vehicleid = Protect_Seat[playerid];

    new Float:health;
    GetVehicleHealth(vehicleid, health);
    new maxhealth = MaxVehicleHealth(VehInfo[vehicleid][vModel], vehicleid);

    if(maxhealth > health) // Максимальное хп выше текущего, значит чиним
    {
        ACRepairVehicle(vehicleid);
		ACSetVehicleHealth(vehicleid, maxhealth);

        PlayerInfo[playerid][pDonateMoney] -= donatePrice[13];
        tclArifmetikAllGold -= donatePrice[13];
        mysql_save(playerid, 4);

		PlayerPlaySound(playerid,6401,0,0,0);

        new string[100];
		format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~PEMOHЏ ‹‘ЊO‡HEH: ~y~-%dG", donatePrice[13]);
		GameTextForPlayer(playerid,string,4000,3);
		DonateLog("repair",PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -donatePrice[13], "");
    }
    else ErrorText(playerid, "{FF6347}Транспорт не нуждается в ремонте"), showDialogDonateMenu(playerid);
    return true;
}

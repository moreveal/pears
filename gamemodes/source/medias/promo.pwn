enum ProInfo
{
	roNewid, // id промокода в базе данных
	roID, // id промокода на сервере
	roName[64], // название промокода
	roActiv, // статус промокода: активен или нет
	roUnixcreate, // unix время создания промокода
	roUnixbegin, // unix время начала действия промокода
	roUnixend, // unix окончания действия промокода
	roUnixstart, // стартовая дата unix
	roLevel, // уровень с которого можно взять промкод
	roInsert, // количество активаций этого промокода
	roPar[5], // id подарка
	roStat[5], // количество для id подарка
	roText[84], // текст описание для промокода
	roNumber, // количество раз использования промокод
	roVoice, // есть ли требование лаунчера чата
}
new PromoInfo[MAX_PROMO][ProInfo];
new PromoNumber;

stock setprom(playerid)
{
	if(PlayerInfo[playerid][pSoska] <= 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	new pf = ListCode[playerid];
	if(pf >= 50) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Ошибка промокода!"), pc_cmd_promo(playerid);
	new tyear[2], tmonth[2], tday[2], thour[2], tminute[2], tsecond[2];
	stamp2datetime(PromoInfo[pf][roUnixbegin], tyear[0], tmonth[0], tday[0], thour[0], tminute[0], tsecond[0], 3);
	stamp2datetime(PromoInfo[pf][roUnixend], tyear[1], tmonth[1], tday[1], thour[1], tminute[1], tsecond[1], 3);

    new line[120], lines[1800];
	new count;
    format(line,sizeof(line),"ID Промкода: %d \t Активаций: %d \t Стоимость\n", PromoInfo[pf][roNewid], PromoInfo[pf][roNumber]), strcat(lines,line);

    if(PromoInfo[pf][roActiv] == 1) format(line,sizeof(line),"{cccccc}Статус: \t {99ff66}[ Активен ]\t \n"), strcat(lines,line);
	else if(PromoInfo[pf][roActiv] == 2) format(line,sizeof(line),"{cccccc}Статус: \t {99ff66}[ На проверке ]\t \n"), strcat(lines,line);
    else format(line,sizeof(line),"{cccccc}Статус: \t {FF6347}[ Отключен ]\t \n"), strcat(lines,line);
	for(new i; i < 5; i++)
	{
		if(PromoInfo[pf][roPar][i] == 2) format(line,sizeof(line),"{cccccc}[Slot %d] %s [%d] \t \t {99ff66}[%d$] \n",i,promoName[PromoInfo[pf][roPar][i]], PromoInfo[pf][roStat][i],GetVehiclePriceGos(PromoInfo[pf][roStat][i])), count+= GetVehiclePriceGos(PromoInfo[pf][roStat][i]), strcat(lines,line);
		else if(PromoInfo[pf][roPar][i] == 3) format(line,sizeof(line),"{cccccc}[Slot %d] %s [%d] \t \t {99ff66}[%d$] \n",i,promoName[PromoInfo[pf][roPar][i]], PromoInfo[pf][roStat][i],PromoInfo[pf][roStat][i]),count+= PromoInfo[pf][roStat][i], strcat(lines,line);
		else if(PromoInfo[pf][roPar][i] == 4) format(line,sizeof(line),"{cccccc}[Slot %d] %s [%d] \t \t {99ff66}[%d$] \n",i,promoName[PromoInfo[pf][roPar][i]], PromoInfo[pf][roStat][i],PromoInfo[pf][roStat][i]*2000),count+= PromoInfo[pf][roStat][i]*2000, strcat(lines,line);
		else if(PromoInfo[pf][roPar][i] == 12) format(line,sizeof(line),"{cccccc}[Slot %d] %s [%d] \t \t {99ff66}[%d$] \n",i,promoName[PromoInfo[pf][roPar][i]], PromoInfo[pf][roStat][i],PromoInfo[pf][roStat][i]*6*2000),count+= PromoInfo[pf][roStat][i]*6*2000, strcat(lines,line);
		else if(PromoInfo[pf][roPar][i] == 13) format(line,sizeof(line),"{cccccc}[Slot %d] %s [%d] \t \t {99ff66}[%d$] \n",i,promoName[PromoInfo[pf][roPar][i]], PromoInfo[pf][roStat][i],150*2000),count+= 150*2000, strcat(lines,line);
		else if(PromoInfo[pf][roPar][i] == 14) format(line,sizeof(line),"{cccccc}[Slot %d] %s [%d] \t \t {99ff66}[%d$] \n",i,promoName[PromoInfo[pf][roPar][i]], PromoInfo[pf][roStat][i],SkinGos[PromoInfo[pf][roStat][i]]),count+= SkinGos[PromoInfo[pf][roStat][i]], strcat(lines,line);
		else format(line,sizeof(line),"{cccccc}[Slot %d] %s [%d] \t \t \n",i,promoName[PromoInfo[pf][roPar][i]], PromoInfo[pf][roStat][i]), strcat(lines,line);
	}
    format(line,sizeof(line),"{cccccc}Название \t {ff9000}[%s] \t \n", PromoInfo[pf][roName]), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Условия \t \t \n"), strcat(lines,line);
    
    if(PromoInfo[pf][roLevel] == 0) format(line,sizeof(line),"{cccccc}Уровень: \t {ff9000}0 - При регистрации \t \n"), strcat(lines,line);
    else format(line,sizeof(line),"{cccccc}Уровень: \t {ff9000}%d+ \t \n",PromoInfo[pf][roLevel]), strcat(lines,line);
    if(PromoInfo[pf][roInsert] == 0) format(line,sizeof(line),"{cccccc}Активаций: \t {ff9000}Неограничено\t \n"), strcat(lines,line);
    else format(line,sizeof(line),"{cccccc}Активаций: \t {ff9000}%d\t \n",PromoInfo[pf][roInsert]), strcat(lines,line);
    
    format(line,sizeof(line),"{cccccc}Подпись \t \n"), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Начало Действия \t {99ff66}[%02d.%02d.%d %02d:%02d]\t \n", tday[0], tmonth[0], tyear[0], thour[0], tminute[0]), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Окончание Действия \t {FF6347}[%02d.%02d.%d  %02d:%02d]\t \n", tday[1], tmonth[1], tyear[1], thour[1], tminute[1]), strcat(lines,line);
    format(line,sizeof(line),"{FF6347}Удалить Промокод \t \t \n"), strcat(lines,line);
	format(line,sizeof(line),"{cccccc}Ценность промокода: {99ff66}%d$ \t \t \n",count), strcat(lines,line);
    
	DP[4][playerid] = count;
	ShowDialog(playerid,622,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Промокод",lines,"Выбрать","Отмена");
	return 1;
}

function Call_regpromo(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    new string[240], datad1;
	    if(AntiFloodMysqlRequest(playerid, 10)) return 1;
		ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Промокод","{cccccc}Поиск игроков...","*","");
		cache_get_value_name_int(0, "newid", datad1);
		DP[2][playerid] = 0;
		DP[0][playerid] = datad1;

		mysql_format(pearsq, string,sizeof(string),"SELECT user_id, Name, Level, ConnectTime, Offtime, Online \
			FROM `pp_igroki` WHERE `Promoins`='%d' AND `Level`>'0' ORDER BY `user_id` DESC LIMIT 60", datad1);
		mysql_tquery(pearsq, string, "call_getprom", "d", playerid);
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Промокод не найден.."), HidePlayerDialog(playerid);
	return 1;
}

function Call_promo(playerid, pf, unix)
{
	new rows, string[240];
	new year, month,day;
 	getdate(year, month, day);
	cache_get_row_count(rows);
	if(!rows)
	{
		new Potom;
		if(PromoInfo[pf][roLevel] > 0) // Проверка на лимиты только если промокод не регистрационный
		{
			new quan = 0;
			for(new checkslot; checkslot < 5; checkslot++)
			{
				if(PromoInfo[pf][roPar][checkslot] == 2 || PromoInfo[pf][roPar][checkslot] == 13 || PromoInfo[pf][roPar][checkslot] == 14) quan ++;
			}
			if(!free_invent(playerid,quan)) return ErrorMessage(playerid, "{FF6347}У вас не хватает места в инвентаре");
		}

	    new yeslvl = 0;
		new str[100],sctring[900];
		format(str,sizeof(str),"{ff9000}____________________________________________________________\n\n");
		strcat(sctring,str);
		format(str,sizeof(str),"\n{ff9000}%s\n", PromoInfo[pf][roText]), strcat(sctring,str);
		for(new statpf = 0; statpf < 5; statpf++)
		{
			if(PromoInfo[pf][roPar][statpf] == 2) // Транспорт
			{
				if(PromoInfo[pf][roLevel] > 0)
				{
					new vehid = PromoInfo[pf][roStat][statpf];
					format(str,sizeof(str),"{ff9000}* %s {cccccc}%s\n",promoName[PromoInfo[pf][roPar][statpf]], GetVehicleName(vehid)), strcat(sctring,str);
					new colorveh = 1 + random(254); // Color Vehicle
					GiveThingPlayer(playerid, vehid, colorveh, 0, 0, 5, 0, 9999);
				}
				else Potom ++;
			}
		
			if(PromoInfo[pf][roPar][statpf] == 3) // Деньги
			{
				if(PromoInfo[pf][roLevel] > 0)
				{
					format(str,sizeof(str),"{ff9000}* %s {cccccc}%d$\n",promoName[PromoInfo[pf][roPar][statpf]], PromoInfo[pf][roStat][statpf]), strcat(sctring,str);
					oGivePlayerMoney(playerid, PromoInfo[pf][roStat][statpf]);

					MoneyLog("promo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", PromoInfo[pf][roStat][statpf], PromoInfo[pf][roName]);
				}
				else Potom ++;
			}
			if(PromoInfo[pf][roPar][statpf] == 4) // Золото
			{
				if(PromoInfo[pf][roLevel] > 0)
				{
					format(str,sizeof(str),"{ff9000}* %s {cccccc}%dG {999999}[ Y >> Донат или /donate ]\n",promoName[PromoInfo[pf][roPar][statpf]], PromoInfo[pf][roStat][statpf]), strcat(sctring,str);
					PlayerInfo[playerid][pDonateMoney] += PromoInfo[pf][roStat][statpf];
					if(PlayerInfo[playerid][pAchieve][26] == 0 && PlayerInfo[playerid][pDonateMoney] >= 10000) AchievePlayer(playerid, 26, 1);

					DonateLog("promo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", PromoInfo[pf][roStat][statpf], PromoInfo[pf][roName]);
				}
				else Potom ++;
			}
			if(PromoInfo[pf][roPar][statpf] == 5) // Уровень
			{
				if(PromoInfo[pf][roLevel] > 0)
				{
					format(str,sizeof(str),"{ff9000}* Уровень: {cccccc}+%d {999999}[ /stats ]\n", PromoInfo[pf][roStat][statpf]), strcat(sctring,str);
					PlayerInfo[playerid][pLevel] += PromoInfo[pf][roStat][statpf], yeslvl = 1;
				}
				else Potom ++;
			}
			if(PromoInfo[pf][roPar][statpf] == 10) // X2 Exp
			{
				format(str,sizeof(str),"{ff9000}* X2 Exp {cccccc}[%d PayDay Зарплат] {999999}[ /stats ]\n", PromoInfo[pf][roStat][statpf]), strcat(sctring,str);
				PlayerInfo[playerid][pX2exp] += PromoInfo[pf][roStat][statpf];
			}
			if(PromoInfo[pf][roPar][statpf] == 12) // VIP
			{
			    if(PlayerInfo[playerid][pDonateRank] <= 2)
			    {
					format(str,sizeof(str),"{ff9000}* VIP {cccccc}[%d дней] {999999}[ /stats ]\n", PromoInfo[pf][roStat][statpf]), strcat(sctring,str);
					PlayerInfo[playerid][pDonateRank] = 1;
					givevip(playerid, PromoInfo[pf][roStat][statpf]);
					mysql_save(playerid, 4);
				}
				else if(PlayerInfo[playerid][pDonateRank] >= 3) format(str,sizeof(str),"{ff9000}* VIP: {ffcc00}Активна Premium VIP\n"), strcat(sctring,str);
			}
			if(PromoInfo[pf][roPar][statpf] == 13) // Кейс // NEW
			{
				if(PromoInfo[pf][roLevel] > 0)
				{
					format(str,sizeof(str),"{ff9000}* Кейс {999999}[ Инвентарь N ]\n"), strcat(sctring,str);
					new thingId, thingQuan, thingType, thingPara, thingPack;
					CreateCasePlayer(playerid, thingId, thingQuan, thingType,thingPara, thingPack);
					GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
					CalculateVehicleLimited(thingId, thingType);
				}
				else Potom ++;
			}
			if(PromoInfo[pf][roPar][statpf] == 14) // Скин
			{
				if(PromoInfo[pf][roLevel] > 0)
				{
					format(str,sizeof(str),"{ff9000}* Одежда {cccccc}[ №%d ]{999999}[ Инвентарь N ]\n",PromoInfo[pf][roStat][statpf]), strcat(sctring,str);
					GiveThingPlayer(playerid, PromoInfo[pf][roStat][statpf], 1, 0, 0, 3, 0, 9999);
				}
				else Potom ++;
			}
		}

		if(Potom > 0)
		{
			format(str,sizeof(str),"\n\n{ffcc66}В промкоде есть %d подарков, которые вы получите", Potom), strcat(sctring,str);
			format(str,sizeof(str),"\n{ffcc66}после достижения 3-го уровня [ /stats ]"), strcat(sctring,str);
			format(str,sizeof(str),"\n{99ff66}Приятной игры на Pears Project ;*"), strcat(sctring,str);
		}

		format(str,sizeof(str),"\n\n{ff9000}____________________________________________________________");
		strcat(sctring,str);
		ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Промокод",sctring,"Oк","");

		if(PromoInfo[pf][roLevel] <= 0 && PlayerInfo[playerid][pLevel] == 1 && PlayerInfo[playerid][pPromoreg] == 0)
		{
			PlayerInfo[playerid][pPromoreg] = pf;
			mysql_format(pearsq, string,sizeof(string),"UPDATE `pp_igroki` SET `Promoreg` = '%d', `Promoins` = '%d' WHERE `user_id` = '%d'", 
				PromoInfo[pf][roNewid], PromoInfo[pf][roNewid], PlayerInfo[playerid][pID]);
			mysql_tquery(pearsq, string);
		}

		PromoInfo[pf][roNumber] ++;
		SavePromo(10, pf);
		
		// Записываем в лог, что мы взяли этот промокод
		PromoLog(playerid, pf);

		if(OnlineInfo[playerid][oListenRadioPears] == 0)
		{
		    if(month == 9 && day == 1) PlayAudioStreamForPlayer(playerid,"https://cdn.pears.fun/sound/september.mp3");
		    if(month == 12 || month == 1) PlayAudioStreamForPlayer(playerid,"https://cdn.pears.fun/sound/newyear01.mp3");
			else PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/pears.mp3");
		}

		if(PlayerInfo[playerid][pReferalID] >= 1 && yeslvl == 1)
		{
			if(PlayerInfo[playerid][pLevel] == 5)
			{
				mysql_format(pearsq, string,sizeof(string),"SELECT Name, Ref5, Money FROM `pp_igroki` WHERE `user_id` = '%d'",PlayerInfo[playerid][pReferalID]);
        		mysql_tquery(pearsq, string, "Call_givereferal", "dd", playerid,PlayerInfo[playerid][pReferalID]);
			}
		}

		if(PlayerInfo[playerid][pAchieve][2] == 0 && PlayerInfo[playerid][pLevel] >= 5) AchievePlayer(playerid, 2, 1);
		if(PlayerInfo[playerid][pAchieve][56] == 0 && PlayerInfo[playerid][pLevel] >= 10) AchievePlayer(playerid, 56, 1);
		if(PlayerInfo[playerid][pAchieve][57] == 0 && PlayerInfo[playerid][pLevel] >= 20) AchievePlayer(playerid, 57, 1);
		if(PlayerInfo[playerid][pAchieve][58] == 0 && PlayerInfo[playerid][pLevel] >= 30) AchievePlayer(playerid, 58, 1);
		if(PlayerInfo[playerid][pAchieve][59] == 0 && PlayerInfo[playerid][pLevel] >= 40) AchievePlayer(playerid, 59, 1);
		if(PlayerInfo[playerid][pAchieve][60] == 0 && PlayerInfo[playerid][pLevel] >= 50) AchievePlayer(playerid, 60, 1);
		if(PlayerInfo[playerid][pAchieve][61] == 0 && PlayerInfo[playerid][pLevel] >= 100) AchievePlayer(playerid, 61, 1);
		if(PlayerInfo[playerid][pAchieve][79] == 0) AchievePlayer(playerid, 79, 1); // Первый промокод
		
		gMysqlSaveCheck[playerid] = 1;
		GF_OnPlayerUpdate(playerid);
	}
	else format(string,sizeof(string),"\n{cccccc}Введите промокод\n{FF6347}Вы уже получили призы по промокоду {ff9000}[%s]\n", PromoInfo[pf][roName]), ShowDialog(playerid,550,DIALOG_STYLE_INPUT,"{ff9000}Промокод",string,"Далее","Отмена");
	return 1;
}
function Call_createpromo(playerid, const str_promo[])
{
	new rows;
	cache_get_row_count(rows);
	if(!rows)
	{
		new tyear, tmonth, tday, thour, tminute, tsecond, unix = gettime();
		stamp2datetime(unix, tyear, tmonth, tday, thour, tminute, tsecond, 3);
		new minus = thour*3600+tminute*60;
		new pf;
		for(new f = 0; f < MAX_PROMO; f++)
		{
			if(PromoInfo[f][roNewid] == 0)
			{
				pf = f;
				break;
			}
		}
		new f_str[184],string[144];
		mysql_format(pearsq, f_str, sizeof(f_str), "INSERT INTO `pp_promo` SET `loading`='1',`name`='%e',`unixcreate`='%d',`unixbegin`='%d',`unixend`='%d',`unixstart`='%d'", str_promo, unix, unix-minus+60, unix-minus+604620, unix-minus+60);
		query_empty(pearsq, f_str);
		mysql_format(pearsq, string,sizeof(string),"SELECT * FROM `pp_promo` WHERE `name` = '%e'", str_promo); // Грузим ID промокода
		mysql_tquery(pearsq, string, "Call_getpromo", "d", pf);
		format(PromoInfo[pf][roName], 64, str_promo);
		PromoInfo[pf][roUnixcreate] = unix;
		PromoInfo[pf][roUnixbegin] = unix-minus+60;
		PromoInfo[pf][roUnixend] = unix-minus+604620;
		PromoInfo[pf][roUnixstart] = unix-minus+60;
		PromoInfo[pf][roID] = pf;
		PromoInfo[pf][roInsert] = 0;
		PromoInfo[pf][roVoice] = 0;
		ListCode[playerid] = pf;
		SavePromo(7, pf);
		AdminLog("promo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, str_promo, "", 0, "Создал промокод");
		PromoNumber ++;
		setprom(playerid);
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Такой промкод уже есть или существует как неактивный"), pc_cmd_promo(playerid);
	
	g_MysqlCall[playerid] = false;
	return 1;
}
function Call_getpromo(pf)
{
	new rows;
	cache_get_row_count(rows);
	if(rows) cache_get_value_name_int(0, "newid", PromoInfo[pf][roNewid]);
	return 1;
}

stock critprom(playerid)
{
	if(PlayerInfo[playerid][pSoska] <= 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	new pf = ListCode[playerid];
	if(pf >= 50) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Ошибка промокода!"), pc_cmd_promo(playerid);
	
	new line[70], lines[140];
	if(PromoInfo[pf][roVoice] == 1) format(line,sizeof(line),"{cccccc}Лаунчер: \t {99ff66}[ Требуется ]\n"), strcat(lines,line);
    else format(line,sizeof(line),"{cccccc}Лаунчер: \t {FF6347}[ Не требуется ]\n"), strcat(lines,line);
	ShowDialog(playerid,635,DIALOG_STYLE_TABLIST,"{ff9000}Промокод: Условия",lines,"Выбрать","Отмена");
	return 1;
}

function call_getprom(playerid)
{
	new rows,qwer[124],kol, str[216], sctring[4096], datad1[24], datad2[24], datad[3], datad5;
	new year, month,day;
	getdate(year, month, day);
	cache_get_row_count(rows);
	format(str,sizeof(str),"{cccccc}Имя\tУровень\tЧасов в Игре\tПоследняя Активность\n"), strcat(sctring,str);
	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "user_id", datad5);
		cache_get_value_name(i, "Name", datad1, 24);
		cache_get_value_name_int(i, "Level", datad[0]);
		cache_get_value_name_int(i, "ConnectTime", datad[1]);
		cache_get_value_name(i, "Offtime", datad2, 24);
		cache_get_value_name_int(i, "Online", datad[2]);
		if(datad[2] == 0) format(str,sizeof(str),"{cccccc}%s\t%d\t%d\t{444444}%s\n", datad1, datad[0], datad[1], datad2), strcat(sctring,str);
		else format(str,sizeof(str),"{cccccc}%s\t%d\t%d\t{99ff66}Online\n", datad1, datad[0], datad[1]), strcat(sctring,str);
		kol ++;
		DP[1][playerid] = datad5;
	}
	if(kol >= 1)
	{
		DP[2][playerid] ++;
		if(kol >= 60)
		{
			format(qwer,sizeof(qwer),"{ff9000}Промокод [%d] {cccccc}[%02d.%02d.%d] Страница %d",kol,day,month,year, DP[2][playerid]);
			ShowDialog(playerid,1040,DIALOG_STYLE_TABLIST_HEADERS,qwer,sctring,"Далее","");
   		}
   		else
   		{
			format(qwer,sizeof(qwer),"{ff9000}Промокод [%d] {cccccc}[%02d.%02d.%d] Страница %d",kol,day,month,year, DP[2][playerid]);
			if(ListCode[playerid] == 2) ShowDialog(playerid,1187,DIALOG_STYLE_TABLIST_HEADERS,qwer,sctring,"Ок","");
			else ShowDialog(playerid,1742,DIALOG_STYLE_TABLIST_HEADERS,qwer,sctring,"Ок","");
   		}
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок введённые промокод при регистрации не найдены.."), HidePlayerDialog(playerid);
	return 1;
}
CMD:promolog(playerid, const params[])
{
	if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER) && PlayerInfo[playerid][pMedia] == 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
	if(sscanf(params, "s[121]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Посмотреть лог промокода при регистрации [ /promolog Промокод ]");
	if(strlen(params[0]) > 60) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Длинна промокода не больше 60-ти символов");
	if(checksimvol(params[0])) return ErrorMessage(playerid, "{FF6347}Вы используете запрещённый символ\n{cccccc}Используйте, буквы и цифры");
	if(AntiFloodMysqlRequest(playerid, 10)) return 1;
	ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Промокод","{cccccc}Поиск промокода...","*","");
	new string[200];
	mysql_format(pearsq, string,sizeof(string),"SELECT * FROM `pp_promo` WHERE `name` = '%e'", params[0]);
	mysql_tquery(pearsq, string, "Call_regpromo", "d", playerid);
	return 1;
}

alias:promo("promik", "prom", "porn", "promocode", "promocod", "pornocod")
CMD:promo(playerid)
{
	if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER) && PlayerInfo[playerid][pMedia] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	new str[120], sctring[2800], qwer[84], kol = 0;
	PlayerPlaySound(playerid,40405,0,0,0);
	format(str,sizeof(str),"{99ff66}Создать Промокод\n"), strcat(sctring,str);
	for(new p; p < MAX_PROMO; ++p)
	{
	    if(PromoInfo[p][roNewid] >= 1)
	    {
	    	List[kol][playerid] = PromoInfo[p][roID];
	    	if(PromoInfo[p][roActiv] == 1) format(str,sizeof(str),"{cccccc}%d. {ff9000}%s {cccccc}[ %d ]\n", p+1, PromoInfo[p][roName], PromoInfo[p][roNumber]), strcat(sctring,str);
	    	else if(PromoInfo[p][roActiv] == 2) format(str,sizeof(str),"{cccccc}%d. {ff9000}%s {cccccc}[ %d ](В ожидании одобрения)\n", p+1, PromoInfo[p][roName], PromoInfo[p][roNumber]), strcat(sctring,str);
			else format(str,sizeof(str),"{cccccc}%d. %s [ %d ]\n", p+1, PromoInfo[p][roName], PromoInfo[p][roNumber]), strcat(sctring,str);
	    	kol++;
		}
	}
	format(qwer,sizeof(qwer),"{ff9000}Промокоды {FFFFFF}[ %d ]",PromoNumber);
	ShowDialog(playerid,621,DIALOG_STYLE_LIST,qwer,sctring,"Выбрать","Отмена");
	return 1;
}

stock dialogCase_Promo(playerid, dialogid, response, listitem,const inputtext[])
{
	new string[200];
	if(dialogid == 621)
	{
		if(response)
        {
        	if(listitem == 0)
        	{
        		if(PromoNumber >= 50) return ErrorMessage(playerid, "{FF6347}Лимит активных промокодов: 50");
          		ShowDialog(playerid,623,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите название для промокода [3 - 60 символов]\n\n{cccccc}Это текст, который будет вводить игрок, чтобы получить промокод","Принять","Отмена");
        	}
        	else if(listitem >= 1 && listitem <= MAX_PROMO)
        	{
        		ListCode[playerid] = List[listitem-1][playerid];
        		setprom(playerid);
        	}
        }
        else pc_cmd_server(playerid);
  	}
  	if(dialogid == 635)
	{
  	    if(response)
  	    {
  	        new pf = ListCode[playerid];
			if(listitem == 0)
        	{
        	    if(PromoInfo[pf][roVoice] == 0)
				{
				    if(PromoInfo[pf][roLevel] <= 0) return ErrorText(playerid,"{FF6347}Это условие нельзя установить для промокода при регистрации"), critprom(playerid);
					PromoInfo[pf][roVoice] = 1;
				}
        	    else PromoInfo[pf][roVoice] = 0;
        	    critprom(playerid);
        	    SavePromo(12, pf);
    	    }
  		}
  		else setprom(playerid);
	}
  	if(dialogid == 622)
	{
  	    if(response)
  	    {
			new bool: edit_promo_access = bool: admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER);
  	        new pf = ListCode[playerid];
  	    	if(listitem == 0)
			{
				if(PromoInfo[pf][roActiv] == 1 && PlayerInfo[playerid][pSoska] > 9)
				{
					new yes;
					foreach(Player,i)
					{
				    	if(PlayerInfo[i][pPromoreg] == PromoInfo[pf][roNewid]) yes = 1;
					}
					if(yes == 1) 
					{
						return format(string,sizeof(string),"{FF6347}Этот промокод сейчас используют игроки при регистрации [ %d Игроков ]",PromoInfo[pf][roNumber]), ErrorText(playerid,string), setprom(playerid);
					}
					PromoInfo[pf][roActiv] = 0;
				}
				else
				{
					if(PromoInfo[pf][roActiv] == 2 && PlayerInfo[playerid][pSoska] < 9) return ErrorText(playerid,"{FF6347}Промокод на одобрение у ответственной администрации");
					if(PromoInfo[pf][roPar][0] == 0 && PromoInfo[pf][roPar][1] == 0 && PromoInfo[pf][roPar][2] == 0 && PromoInfo[pf][roPar][3] == 0 && PromoInfo[pf][roPar][4] == 0) return ErrorText(playerid,"{FF6347}Нужно добавить хотя-бы один подарок в промокод"), setprom(playerid);
					if((!edit_promo_access && PlayerInfo[playerid][pMedia] > 0) && DP[4][playerid] > 1000000) return ErrorText(playerid,"{FF6347}Ценность промокода привышает 1.000.000$, допустима ценность ниже этого."), setprom(playerid);
					if(!edit_promo_access && PlayerInfo[playerid][pMedia] > 0) ErrorText(playerid,"{FF6347}Промокод отправлен на одобрение ответственной администрации"), PromoInfo[pf][roActiv] = 2;
					else PromoInfo[pf][roActiv] = 1;
				}
				PlayerPlaySound(playerid,6401,0,0,0);
				setprom(playerid);
				SavePromo(6, pf);
			}
			if(listitem >= 1)
			{
				if(PromoInfo[pf][roActiv] == 1) return ErrorText(playerid,"{FF6347}Нельзя редактировать активный промокод"), setprom(playerid);
				new yes;
				foreach(Player,i)
				{
				    if(PlayerInfo[i][pPromoreg] == PromoInfo[pf][roNewid]) yes = 1;
				}
				if(yes == 1) return format(string,sizeof(string),"{FF6347}Этот промокод сейчас используют игроки при регистрации [ %d Игроков ]",PromoInfo[pf][roNumber]), ErrorText(playerid,string), setprom(playerid);
			}
			if(listitem >= 1 && listitem <= 5)
			{
				PromoInfo[pf][roActiv] = 0;
				ListDop[playerid] = listitem-1;
				if(PromoInfo[pf][roPar][listitem-1] == 0)
				{
					ShowDialog(playerid,624,DIALOG_STYLE_LIST,"{ff9000}Промокод","{cccccc}Деньги\n{cccccc}Золото\n{cccccc}Уровень\n{cccccc}X2 Exp\n{cccccc}VIP Временная\n{cccccc}Кейс\n{cccccc}Транспорт\n{cccccc}Одежда","Выбрать","Отмена");
				}
				else
				{
					PromoInfo[pf][roPar][listitem-1] = 0;
					PromoInfo[pf][roStat][listitem-1] = 0;
					PlayerPlaySound(playerid,31203,0,0,0);
					setprom(playerid);
					SavePromo(listitem-1, pf);
				}
			}
			
			if(listitem == 6) ShowDialog(playerid,625,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите новое название для промокода [ 3 - 60 символов ]","Принять","Отмена");
			if(listitem == 7) critprom(playerid);
			if(listitem == 8 && edit_promo_access) ShowDialog(playerid,626,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите уровень с которого игрок сможет взять промокод (0 при регистрации) [0 - 100]","Принять","Отмена");
			if(listitem == 9 && edit_promo_access) ShowDialog(playerid,603,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите доступное количество активаций этого промокода (0 неограничено) [0 - 100.000]","Принять","Отмена");
			if(listitem == 10) ShowDialog(playerid,627,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите подпись промокода {ff9000}[3 - 80 символов]\n{cccccc}Это текст, который увидит игрок когда использует промокод","Принять","Отмена");
			if(listitem == 11 && edit_promo_access) ShowDialog(playerid,629,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите количество дней через которое промокод {99ff66}начнёт своё действие [0 - 3000]","Принять","Отмена");
			if(listitem == 12 && edit_promo_access) ShowDialog(playerid,614,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите количество дней через которое промокод {FF6347}завершит своё действие [1 - 3000]","Принять","Отмена");
			if(listitem == 13 && edit_promo_access) ShowDialog(playerid,606,DIALOG_STYLE_MSGBOX,"{ff9000}Промокод","{cccccc}Вы уверены, что хотите удалить промокод?\n\n","Да","Отмена");
  	    }
  	    else pc_cmd_promo(playerid);
 	}
 	if(dialogid == 603)
	{
  	    if(response)
  	    {
  	        new pf = ListCode[playerid], cashdeposit;
  	        if(PromoInfo[pf][roActiv] == 1) return ErrorText(playerid,"{FF6347}Нельзя редактировать активный промокод"), setprom(playerid);
  	        if(!strlen(inputtext)) return setprom(playerid);
  	        if(!sscanf(inputtext, "i", cashdeposit))
   			{
   				if(cashdeposit > 100000 || cashdeposit < 0) return ErrorText(playerid,"{FF6347}Не меньше 0 и не больше 100.000"), setprom(playerid);
   				if(cashdeposit >= 1) format(string, sizeof(string), "[ Промокод ]: %s можно будет активировать {ff9000}%d раз",PromoInfo[pf][roName], cashdeposit), SendClientMessage(playerid,COLOR_GREY,string);
   				else format(string, sizeof(string), "[ Промокод ]: %s можно будет активировать {ff9000}неограниченное количество раз",PromoInfo[pf][roName]), SendClientMessage(playerid,COLOR_GREY,string);
   				PromoInfo[pf][roInsert] = cashdeposit;
				PlayerPlaySound(playerid,31203,0,0,0);
				setprom(playerid);
				SavePromo(11, pf);
   			}
       	}
       	else setprom(playerid);
	}
 	if(dialogid == 606)
	{
  	    if(response)
  	    {
			if(PlayerInfo[playerid][pSoska] < 9) return ErrorText(playerid,"{FF6347}Вы не ответственный администратор"), setprom(playerid);
  	        new pf = ListCode[playerid];
  	        if(PromoInfo[pf][roActiv] == 1) return ErrorText(playerid,"{FF6347}Нельзя удалить активный промокод"), setprom(playerid);
			new f_str[144];
			mysql_format(pearsq, f_str,sizeof(f_str),"UPDATE `pp_promo` SET `loading` = '0' WHERE `newid` = '%d'", PromoInfo[pf][roNewid]);
			query_empty(pearsq, f_str);
			format(string, sizeof(string), "[ Промокод ]: %s промокод {FF0000}удалён",PromoInfo[pf][roName]), SendClientMessage(playerid,COLOR_GREY,string);
			PromoInfo[pf][roNewid] = 0;
			PromoInfo[pf][roActiv] = 0;
			PromoInfo[pf][roUnixcreate] = 0;
			PromoInfo[pf][roUnixbegin] = 0;
			PromoInfo[pf][roUnixend] = 0;
			PromoInfo[pf][roUnixstart] = 0;
			PromoInfo[pf][roLevel] = 0;
			PromoInfo[pf][roNumber] = 0;
			format(PromoInfo[pf][roText], 84, "");
			for(new spf = 0; spf < 5; spf ++) PromoInfo[pf][roPar][spf] = 0, PromoInfo[pf][roStat][spf] = 0;
			PromoNumber --;
			PlayerPlaySound(playerid,31203,0,0,0);
			pc_cmd_promo(playerid);
			AdminLog("promo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, PromoInfo[pf][roName], "", 0, "Удалил промокод");
       	}
       	else setprom(playerid);
	}
 	if(dialogid == 614)
	{
  	    if(response)
  	    {
  	        new pf = ListCode[playerid], cashdeposit;
  	        if(PromoInfo[pf][roActiv] == 1) return ErrorText(playerid,"{FF6347}Нельзя редактировать активный промокод"), setprom(playerid);
  	        if(!strlen(inputtext)) return setprom(playerid);
  	        if(!sscanf(inputtext, "i", cashdeposit))
   			{
   				if(cashdeposit > 3000 || cashdeposit < 1) return ErrorText(playerid,"{FF6347}Не меньше 1 и не больше 3000 дней"), setprom(playerid);
   				format(string, sizeof(string), "[ Промокод ]: %s промокод {FF6347}отключится {cccccc}через: {ff9000}%d дней",PromoInfo[pf][roName], cashdeposit), SendClientMessage(playerid,COLOR_GREY,string);
   				PromoInfo[pf][roUnixend] = PromoInfo[pf][roUnixstart]+cashdeposit*86400;
				PlayerPlaySound(playerid,31203,0,0,0);
				setprom(playerid);
				SavePromo(7, pf);
   			}
       	}
       	else setprom(playerid);
	}
 	if(dialogid == 629)
	{
  	    if(response)
  	    {
  	        new pf = ListCode[playerid], cashdeposit;
  	        if(PromoInfo[pf][roActiv] == 1) return ErrorText(playerid,"{FF6347}Нельзя редактировать активный промокод"), setprom(playerid);
  	        if(!strlen(inputtext)) return setprom(playerid);
  	        if(!sscanf(inputtext, "i", cashdeposit))
   			{
   				if(cashdeposit > 3000 || cashdeposit < 0) return ErrorText(playerid,"{FF6347}Не меньше 0 и не больше 3000 дней"), setprom(playerid);
   				format(string, sizeof(string), "[ Промокод ]: %s промокод будет {99ff66}активен {cccccc}через: {ff9000}%d дней",PromoInfo[pf][roName], cashdeposit), SendClientMessage(playerid,COLOR_GREY,string);
   				PromoInfo[pf][roUnixbegin] = PromoInfo[pf][roUnixstart]+cashdeposit*86400;
				PlayerPlaySound(playerid,31203,0,0,0);
				setprom(playerid);
				SavePromo(7, pf);
   			}
       	}
       	else setprom(playerid);
	}
 	if(dialogid == 627)
	{
  	    if(response)
  	    {
  	    	new pf = ListCode[playerid];
  	    	if(PromoInfo[pf][roActiv] == 1) return ErrorText(playerid,"{FF6347}Нельзя редактировать активный промокод"), setprom(playerid);
  	    	if(strlen(inputtext) < 3 || strlen(inputtext) > 80) return ShowDialog(playerid,627,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите подпись промокода {ff0000}[3 - 80 символов]\n{cccccc}Это текст, который увидит игрок когда использует промокод","Принять","Отмена");
  	    	if(!strlen(inputtext)) return ShowDialog(playerid,627,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите подпись промокода {ff9000}[3 - 80 символов]\n{cccccc}Это текст, который увидит игрок когда использует промокод","Принять","Отмена");
  	    	format(string, sizeof(string), "[ Промокод ]: %s обновлён текст: {ff9000}%s",PromoInfo[pf][roName], inputtext), SendClientMessage(playerid,COLOR_GREY,string);
			format(PromoInfo[pf][roText], 84, inputtext);
			PlayerPlaySound(playerid,6401,0,0,0);
			setprom(playerid);
			SavePromo(9, pf);
  		}
  		else setprom(playerid);
  	}
 	if(dialogid == 626)
	{
  	    if(response)
  	    {
			if(PlayerInfo[playerid][pSoska] < 9) return ErrorText(playerid,"{FF6347}Для медиа доступен промокод только при регистрации"), setprom(playerid);
  	        new pf = ListCode[playerid], cashdeposit;
  	        if(PromoInfo[pf][roActiv] == 1) return ErrorText(playerid,"{FF6347}Нельзя редактировать активный промокод"), setprom(playerid);
  	        if(!strlen(inputtext)) return setprom(playerid);
  	        if(!sscanf(inputtext, "i", cashdeposit))
   			{
   				if(cashdeposit > 100 || cashdeposit < 0) return ErrorText(playerid,"{FF6347}Не меньше 0 и не больше 100"), setprom(playerid);
   				if(cashdeposit >= 1) format(string, sizeof(string), "[ Промокод ]: %s будет доступен всем с {ff9000}%d Уровня",PromoInfo[pf][roName], cashdeposit), SendClientMessage(playerid,COLOR_GREY,string);
   				else format(string, sizeof(string), "[ Промокод ]: %s будет доступен только при {ff9000}регистрации",PromoInfo[pf][roName]), SendClientMessage(playerid,COLOR_GREY,string);
   				PromoInfo[pf][roLevel] = cashdeposit;
				PlayerPlaySound(playerid,31203,0,0,0);
				setprom(playerid);
				SavePromo(8, pf);
   			}
       	}
       	else setprom(playerid);
	}
 	if(dialogid == 625)
	{
  	    if(response)
  	    {
  	    	new pf = ListCode[playerid];
  	    	if(PromoInfo[pf][roActiv] == 1) return ErrorText(playerid,"{FF6347}Нельзя редактировать активнй промокод"), setprom(playerid);
  	    	if(strlen(inputtext) < 3 || strlen(inputtext) > 60) return ShowDialog(playerid,625,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите новое название для промокода {ff0000}[ 3 - 60 символов ]","Принять","Отмена");
  	    	if(!strlen(inputtext)) return ShowDialog(playerid,625,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите новое название для промокода [ 3 - 60 символов ]","Принять","Отмена");
  	    	if(checksimvolPromo(inputtext)) return ErrorMessage(playerid, "{FF6347}Этот символ запрещено использовать в названии промокода\
																		\n{ffcc66}# - этот символ не нужно использовать при создании.\
																		\n{ffcc66}Игрок можно активировать промокод, как с решёткой, так и без неё");
			new load = 0;
			for(new f = 0; f < MAX_PROMO; f++)
			{
				if(strfind(inputtext,PromoInfo[f][roName],true) != (-1))
				{
					ShowDialog(playerid,625,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите новое название для промокода {FF6347}[ Название промокода уже занято ]","Принять","Отмена");
					load++;
					return 1;
 				}
  	    	}
			if(load == 0)
			{
	  	    	format(string, sizeof(string), "[ Промокод ]: %s изменено название на {ff9000}%s",PromoInfo[pf][roName], inputtext), SendClientMessage(playerid,COLOR_GREY,string);
				format(PromoInfo[pf][roName], 64, inputtext);
				PlayerPlaySound(playerid,6401,0,0,0);
				setprom(playerid);
				SavePromo(5, pf);
			}
  		}
  		else setprom(playerid);
  	}
 	if(dialogid == 624)
	{
  	    if(response)
  	    {
			new bool: edit_promo_access = bool: admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER);
  	        new pf = ListCode[playerid];
			
  	        if(PromoInfo[pf][roActiv] == 1) return ErrorText(playerid,"{FF6347}Нельзя редактировать активный промокод"), setprom(playerid);
  	    	if(listitem == 0 && edit_promo_access) ShowDialog(playerid,611,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите количество денег {99ff66}1.000$ - 300.000$","Принять","Отмена");
  	    	else if(listitem == 0) ErrorText(playerid,"Выдача денег в промокоде заблокирована, чтобы не нарушать экономику"), setprom(playerid);
			if(listitem == 1) ShowDialog(playerid,610,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите количество золота {ffcc00}1G - 100G","Принять","Отмена");
  	    	if(listitem == 2 && edit_promo_access) ShowDialog(playerid,609,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите Level, на который повысится игрок {ff9000}1","Принять","Отмена");
  	    	else if(listitem == 2) ErrorText(playerid,"Выдача денег в промокоде заблокирована, чтобы не нарушать экономику"), setprom(playerid);
			if(listitem == 3) ShowDialog(playerid,604,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите количество PayDay, во время которых игрок получит X2 Exp {ff9000}1 - 1000","Принять","Отмена");
  	    	if(listitem == 4) ShowDialog(playerid,602,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите количество дней активности VIP аккаунта {ff9000}1 - 30","Принять","Отмена");
			if(listitem == 5)
			{
				new statpf = ListDop[playerid];
				PromoInfo[pf][roPar][statpf] = 13, PromoInfo[pf][roStat][statpf] = 1;
				PlayerPlaySound(playerid,31203,0,0,0);
				setprom(playerid);
				SavePromo(statpf, pf);
				AdminLog("promo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, PromoInfo[pf][roName], "", 1, "Подарок: Кейс");
			}
			if(listitem == 6) ShowDialog(playerid,600,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите ID транспорта {ff9000}400 - 612, 2000 и выше - кастомные авто","Принять","Отмена");
			if(listitem == 7) ShowDialog(playerid,597,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите ID скина {ff9000}1 - 311, кастомные 312 и выше","Принять","Отмена");
		}
		else setprom(playerid);
	}
	if(dialogid == 597) // Скин в промокоде
	{
  	    if(response)
  	    {
  	        new pf = ListCode[playerid], statpf = ListDop[playerid], cashdeposit;
  	        if(!strlen(inputtext)) return setprom(playerid);
  	        if(!sscanf(inputtext, "i", cashdeposit))
   			{
   				if(!IsASkinExisting(cashdeposit)) return ErrorText(playerid,"{FF6347}Несуществующий ID скина [1 - 311, кастомные 312 и выше]"), setprom(playerid);
   				PromoInfo[pf][roPar][statpf] = 14, PromoInfo[pf][roStat][statpf] = cashdeposit;
				PlayerPlaySound(playerid,31203,0,0,0);
				setprom(playerid);
				SavePromo(statpf, pf);
				AdminLog("promo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, PromoInfo[pf][roName], "", cashdeposit, "Подарок: Скин");
   			}
       	}
       	else setprom(playerid);
	}
	if(dialogid == 600) // Машина в промокоде
	{
  	    if(response)
  	    {
  	        new pf = ListCode[playerid], statpf = ListDop[playerid], cashdeposit;
  	        if(!strlen(inputtext)) return setprom(playerid);
  	        if(!sscanf(inputtext, "i", cashdeposit))
   			{
   				if(!IsAVehExisting(cashdeposit)) return ErrorText(playerid,"{FF6347}Несуществующий ID Транспорта [400 - 612, 2000 и выше - кастомные авто]"), setprom(playerid);
   				PromoInfo[pf][roPar][statpf] = 2, PromoInfo[pf][roStat][statpf] = cashdeposit;
				PlayerPlaySound(playerid,31203,0,0,0);
				setprom(playerid);
				SavePromo(statpf, pf);
				AdminLog("promo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, PromoInfo[pf][roName], "", cashdeposit, "Подарок: Транспорт");
   			}
       	}
       	else setprom(playerid);
	}
	if(dialogid == 602)
	{
  	    if(response)
  	    {
  	        new pf = ListCode[playerid], statpf = ListDop[playerid], cashdeposit;
  	        if(!strlen(inputtext)) return setprom(playerid);
  	        if(!sscanf(inputtext, "i", cashdeposit))
   			{
   				if(cashdeposit > 30 || cashdeposit < 1) return ErrorText(playerid,"{FF6347}Не меньше 1 и не больше 30 дней"), setprom(playerid);
   				PromoInfo[pf][roPar][statpf] = 12, PromoInfo[pf][roStat][statpf] = cashdeposit;
				PlayerPlaySound(playerid,31203,0,0,0);
				setprom(playerid);
				SavePromo(statpf, pf);
				AdminLog("promo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, PromoInfo[pf][roName], "", cashdeposit, "Подарок: VIP");
   			}
       	}
       	else setprom(playerid);
	}
	if(dialogid == 604)
	{
  	    if(response)
  	    {
  	        new pf = ListCode[playerid], statpf = ListDop[playerid], cashdeposit;
  	        if(!strlen(inputtext)) return setprom(playerid);
  	        if(!sscanf(inputtext, "i", cashdeposit))
   			{
   				if(cashdeposit > 1000 || cashdeposit < 1) return ErrorText(playerid,"{FF6347}Не меньше 1 и не больше 1000"), setprom(playerid);
   				PromoInfo[pf][roPar][statpf] = 10, PromoInfo[pf][roStat][statpf] = cashdeposit;
				PlayerPlaySound(playerid,31203,0,0,0);
				setprom(playerid);
				SavePromo(statpf, pf);
				AdminLog("promo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, PromoInfo[pf][roName], "", cashdeposit, "Подарок: X2 Exp");
   			}
       	}
       	else setprom(playerid);
	}
	if(dialogid == 611)
	{
  	    if(response)
  	    {
  	        new pf = ListCode[playerid], statpf = ListDop[playerid], cashdeposit;
  	        if(!strlen(inputtext)) return setprom(playerid);
  	        if(!sscanf(inputtext, "i", cashdeposit))
   			{
   				if(cashdeposit > 300000 || cashdeposit < 1000) return ErrorText(playerid,"{FF6347}Не меньше 1.000$ и не больше 300.000$"), setprom(playerid);
   				PromoInfo[pf][roPar][statpf] = 3, PromoInfo[pf][roStat][statpf] = cashdeposit;
				PlayerPlaySound(playerid,31203,0,0,0);
				setprom(playerid);
				SavePromo(statpf, pf);
				AdminLog("promo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, PromoInfo[pf][roName], "", cashdeposit, "Подарок: Деньги");
   			}
       	}
       	else setprom(playerid);
	}
	if(dialogid == 610)
	{
  	    if(response)
  	    {
  	        new pf = ListCode[playerid], statpf = ListDop[playerid], cashdeposit;
  	        if(!strlen(inputtext)) return setprom(playerid);
  	        if(!sscanf(inputtext, "i", cashdeposit))
   			{
   				if(cashdeposit > 100 || cashdeposit < 1) return ErrorText(playerid,"{FF6347}Не меньше 1G и не больше 100G"), setprom(playerid);
   				PromoInfo[pf][roPar][statpf] = 4, PromoInfo[pf][roStat][statpf] = cashdeposit;
				PlayerPlaySound(playerid,31203,0,0,0);
				setprom(playerid);
				SavePromo(statpf, pf);
				AdminLog("promo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, PromoInfo[pf][roName], "", cashdeposit, "Подарок: Золото");
   			}
       	}
       	else setprom(playerid);
	}
	if(dialogid == 609)
	{
  	    if(response)
  	    {
  	        new pf = ListCode[playerid], statpf = ListDop[playerid], cashdeposit;
  	        if(!strlen(inputtext)) return setprom(playerid);
  	        if(!sscanf(inputtext, "i", cashdeposit))
   			{
   				if(cashdeposit > 1 || cashdeposit < 1) return ErrorText(playerid,"{FF6347}Можно повысить только на 1 уровень"), setprom(playerid);
   				PromoInfo[pf][roPar][statpf] = 5, PromoInfo[pf][roStat][statpf] = cashdeposit;
				PlayerPlaySound(playerid,31203,0,0,0);
				setprom(playerid);
				SavePromo(statpf, pf);
				AdminLog("promo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, PromoInfo[pf][roName], "", cashdeposit, "Подарок: Level");
   			}
       	}
       	else setprom(playerid);
	}
  	if(dialogid == 623)
	{
  	    if(response)
  	    {
  	        if(PromoNumber >= 50) return ErrorMessage(playerid, "{FF6347}Лимит активных промокодов: 50");
  	    	if(strlen(inputtext) < 3 || strlen(inputtext) > 60) return ErrorMessage(playerid, "{FF6347}Не меньше 3 и не больше 60 символов");
  	    	if(!strlen(inputtext)) return pc_cmd_promo(playerid);
			if(checksimvolPromo(inputtext)) return ErrorMessage(playerid, "{FF6347}Этот символ запрещено использовать в названии промокода\
																		\n{ffcc66}# - этот символ не нужно использовать при создании.\
																		\n{ffcc66}Игрок можно активировать промокод, как с решёткой, так и без неё");

  	    	new load = 0;
			for(new f = 0; f < MAX_PROMO; f++)
			{
				if(strfind(inputtext,PromoInfo[f][roName],true) != (-1))
				{
					ShowDialog(playerid,623,DIALOG_STYLE_INPUT,"{ff9000}Промокод","{cccccc}Введите название для промокода  [3 - 60 символов] {FF6347}[Промокод с таким именем уже существует!]\n\n{cccccc}Это текст, который будет вводить игрок, чтобы получить промокод","Принять","Отмена");
					load++;
					return 1;
 				}
  	    	}
			if(load == 0)
			{
	  	    	if(AntiFloodMysqlRequest(playerid, 30)) return 1;
				ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Промокод","{cccccc}Загрузка промокода...","*","");
				if(g_MysqlCall[playerid]) return ErrorMessage(playerid, "{FF6347}Дождитесь ответа от базы");
				g_MysqlCall[playerid] = true;
		        mysql_format(pearsq, string, sizeof(string), "SELECT * FROM `pp_promo` WHERE `name` = '%e'", inputtext);
		        mysql_tquery(pearsq, string, "Call_createpromo", "ds", playerid, inputtext);
    		}
  		}
  		else pc_cmd_promo(playerid);
  	}
	return 1;
}

// Удаляем решётку из ввода промокода
stock ReloadPromoName(inputtext[])
{
	if(inputtext[0] == '#') strdel(inputtext, 0, 1);
	return 1;
}

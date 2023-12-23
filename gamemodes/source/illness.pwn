new zones_cold[MAX_REALPLAYERS], zones_coldstat[MAX_REALPLAYERS], incold[MAX_REALPLAYERS];
new vampire[MAX_REALPLAYERS];

CMD:rinfect(p, const params[])
{
	if(PlayerInfo[p][pSoska] < 10) return SendClientMessage(p, COLOR_GREY, "[ Мысли ]: Я не могу это сделать");
	if(sscanf(params, "i",params[0])) return SendClientMessage(p, COLOR_GREY, "[ Мысли ]: Удалить все болезни [ /rinfect ID ]");
	for(new i = 0; i < 5; i++) PlayerInfo[params[0]][pIllness][i] = 0, PlayerInfo[params[0]][pIllnessStat][i] = 0, PlayerInfo[params[0]][pIllnessProg][i] = 0;
	if(zones_coldstat[params[0]] > 0) DestroyDynamicArea(zones_cold[params[0]]), zones_coldstat[params[0]] = 0;
	if(vampire[params[0]] == 1) burn_vampire(params[0], 0);
	incold[p] = 0;
	SendClientMessage(p, COLOR_GREY, "[ Мысли ]: Все болезни игрока очищены");
	format(store, sizeof(store), " %s очистил все ваши болезни", PlayerInfo[p][pName]);
	SendClientMessage(params[0], COLOR_LIGHTBLUE, store);
	return 1;
}
CMD:infect(p, const params[])
{
	if(PlayerInfo[p][pSoska] < 10) return SendClientMessage(p, COLOR_GREY, "[ Мысли ]: Я не могу это сделать");
	if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(p, COLOR_GREY, "[ Мысли ]: Применить болезнь к игроку [ /infect ID 1-18 ]");
	if(params[1] < 1 || params[1] > 18) return SendClientMessage(p, COLOR_GREY, "[ Мысли ]: Не меньше 1 и не больше 18");
	new result = infect(params[0], params[1], 2000);

	if(result == -1) return ErrorMessage(p, "{FF6347}Игрок не был заражён болезнью\n{cccccc}Нет свободных слотов для болезни");
	if(result == -2) return ErrorMessage(p, "{FF6347}Игрок не был заражён болезнью\n{cccccc}Он вампир и не может болеть");

	if(params[1] == 18 && vampire[params[0]] == 0)
	{
		if(GetPlayerInterior(params[0]) == 0 && GetPlayerVirtualWorld(params[0]) == 0 && GetPlayerState(params[0]) == PLAYER_STATE_ONFOOT) burn_vampire(params[0], 1);
	}
	SendClientMessage(p, COLOR_GREY, "[ Мысли ]: Игрок заражён болезнью");
	return 1;
}
CMD:diagnosis(playerid)
{
	if(PlayerInfo[playerid][pMember] != 4 && PlayerInfo[playerid][pLeader] != 4) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я не доктор и не могу поставить диагноз"), cmd_showmed(playerid), PlayerPlaySound(playerid,4203,0,0,0);
	if(GetPlayerInterior(playerid) != 5) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я могу поставить диагноз только находясь в госпитале"), cmd_showmed(playerid), PlayerPlaySound(playerid,4203,0,0,0);
	if(Dei[playerid] != 6) return ErrorMessage(playerid, "{FF6347}Попросите пациента передать вам его медицинскую карту [ Инвентарь N или /med ]");
	new para1 = DeiStat[playerid];
	if(!IsOnline(para1)) return ErrorMessage(playerid, "{FF6347}Пациент куда-то делся [Вышел из игры]"), cmd_remove(playerid);
	if(para1 == playerid && PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете себе поставить диагноз");
	if(!ProxDetectorS(3.0, playerid, para1) || GetPlayerState(para1) == PLAYER_STATE_SPECTATING) return ErrorMessage(playerid, "{FF6347}Вы далеко от пациента"), cmd_remove(playerid);
	if(!illness(para1)) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: У него нет никаких симптомов"), cmd_showmed(playerid), PlayerPlaySound(playerid,4203,0,0,0);
	new str[68],sctring[4800];
	format(str,sizeof(str),"Хламидиоз"), strcat(sctring,str); // 1
   	format(str,sizeof(str),"\nГонорея"), strcat(sctring,str); // 2
   	format(str,sizeof(str),"\nСифилис"), strcat(sctring,str); // 3
   	format(str,sizeof(str),"\nЛучевая Болезнь"), strcat(sctring,str); // 4
   	format(str,sizeof(str),"\nПеритонит Мочевого Пузыря"), strcat(sctring,str); // 5
   	format(str,sizeof(str),"\nГрибок Ногтей"), strcat(sctring,str); // 6
   	format(str,sizeof(str),"\nДерматит"), strcat(sctring,str); // 7
   	format(str,sizeof(str),"\nАкне"), strcat(sctring,str); // 8
   	format(str,sizeof(str),"\nПорошковая Зависимость"), strcat(sctring,str); // 9
   	format(str,sizeof(str),"\nНикотиновая Зависимость"), strcat(sctring,str); // 10
   	format(str,sizeof(str),"\nАлкоголизм"), strcat(sctring,str); // 11
   	format(str,sizeof(str),"\nГастрит"), strcat(sctring,str); // 12
   	format(str,sizeof(str),"\nЯзва"), strcat(sctring,str); // 13
   	format(str,sizeof(str),"\nПростуда"), strcat(sctring,str); // 14
   	format(str,sizeof(str),"\nОРВИ"), strcat(sctring,str); // 15
   	format(str,sizeof(str),"\nГрипп"), strcat(sctring,str); // 16
   	format(str,sizeof(str),"\nCovid-19"), strcat(sctring,str); // 17
   	format(str,sizeof(str),"\nВампиризм"), strcat(sctring,str); // 18
	ShowDialog(playerid,1128,DIALOG_STYLE_LIST,"{ff6666}Поставить Диагноз",sctring,"Выбрать","Отмена");
	return 1;
}
CMD:sym(playerid) return cmd_symptom(playerid);
CMD:symptom(playerid)
{
	if(howstun(playerid) || HealthAC[playerid] <= 0) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerInfo[playerid][pSoska] == 0) return ErrorMessage(playerid, "{FF6347}Вы в слежке");
	new para1 = DeiStat[playerid];
	if(para1 != playerid && Dei[playerid] != 6) return ErrorMessage(playerid, "{FF6347}Попросите пациента передать вам его медицинскую карту [ Инвентарь N или /med ]");
	if(!IsOnline(para1)) return ErrorMessage(playerid, "{FF6347}Пациент куда-то делся [Вышел из игры]"), cmd_remove(playerid);
	if(!ProxDetectorS(3.0, playerid, para1) || GetPlayerState(para1) == PLAYER_STATE_SPECTATING) return ErrorMessage(playerid, "{FF6347}Вы далеко от пациента"), cmd_remove(playerid);
	PlayerPlaySound(playerid,40405,0,0,0);
	getmed(playerid, para1);
	return 1;
}
CMD:remedy(playerid, const params[])
{
	if(OnlineInfo[playerid][oShowInterface] != 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мне нужно посмотреть мои вещи [ Только через инвентарь - N ]");
	new string[164];
	if(PlayerInfo[playerid][pRemedy] > gettime()) return format(string,sizeof(string),"{FF6347}Вы недавно принимали лекарство\n{cccccc}Следующий приём не раньше чем через %s", fine_time(PlayerInfo[playerid][pRemedy]-gettime())), ErrorMessage(playerid, string);
	if(gSkafandr[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Вы в скафандре");
	if(howstun(playerid)) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
	if(!IsPlayerInAnyVehicle(playerid) && GetPlayerSpeed(playerid) > 3) return ErrorMessage(playerid, "{FF6347}Нельзя в движении");
	if(!sscanf(params, "i", params[0]))
 	{
 	    if(params[0] < 1 || params[0] > 16) return ErrorMessage(playerid, "{FF6347}Такого лекарства не существует [1-16]");
 	    if(get_invent4(playerid, params[0]+71, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет такого лекарства");
 	    new illn;
 	    if(params[0] >= 14 && params[0] <= 17)
 	    {
 	    	if(!getillness(playerid, 14) && !getillness(playerid, 15) && !getillness(playerid, 16) && !getillness(playerid, 17)) return ErrorMessage(playerid, "{FF6347}Вы не болеете, чтобы принимать это лекарство");
 			if(!getdiagnosis(playerid, 14) && !getdiagnosis(playerid, 15) && !getdiagnosis(playerid, 16) && !getdiagnosis(playerid, 17)) return ErrorMessage(playerid, "{FF6347}Лекарства можно принимать только по рецепту от врача");
 			if(getillness(playerid, 14)) illn = 14;
 			if(getillness(playerid, 15)) illn = 15;
 			if(getillness(playerid, 16)) illn = 16;
 			if(getillness(playerid, 17)) illn = 17;
		}
		else
		{
			if(!getillness(playerid, params[0])) return ErrorMessage(playerid, "{FF6347}Вы не болеете, чтобы принимать это лекарство");
			if(!getdiagnosis(playerid, params[0])) return ErrorMessage(playerid, "{FF6347}Лекарства можно принимать только по рецепту от врача");
			illn = params[0];
		}
		TakeInvent(playerid, params[0]+71, 1, 0, 999);
		new medid = infectremedy(playerid, illn, 200);
		PlayerPlaySound(playerid, 32200, 0.0, 0.0, 0.0);
		ApplyAnimation(playerid,"FOOD","EAT_Pizza",4.1,0,0,0,0,0);
		
		if(PlayerInfo[playerid][pIllness][medid] <= 0)
		{
			format(lines,sizeof(lines),""); // Очищаем Lines
			format(line,sizeof(line),"{99ff66}Вы приняли лекарство {ff9000}%s {99ff66}и полностью излечили болезнь", friskName[params[0]+71]), strcat(lines,line);
			format(line,sizeof(line),"\n{99ff66}Проверьте мед карту на наличие других болезней [ N - Инвентарь >> Мед Карта ]"), strcat(lines,line);

			if(ContagiousInfect(illn))
			{
				format(line,sizeof(line),"\n\n{ff6666}Это была заразная болезнь и теперь у вас иммунитет на 30 дней"), strcat(lines,line);
				format(line,sizeof(line),"\n{ffcc66}- Вас никто не сможет заразить в течении этого времени"), strcat(lines,line);
				format(line,sizeof(line),"\n{ffcc66}- Однако, вы всё-равно можете заболеть если будете купаться в холодной воде"), strcat(lines,line);
			}
			SuccessMessage(playerid, lines);
			if(PlayerInfo[playerid][pAchieve][14] == 0) AchievePlayer(playerid, 14, 1);
		}
		else
		{
			new Float:ostmed = (PlayerInfo[playerid][pIllnessProg][medid]-1000)/200;
			format(string,sizeof(string),"{99ff66}Вы приняли лекарство {ff9000}%s\n{99ff66}Для полного выздоровления необходимо принять: {0088ff}%d таблеток", friskName[params[0]+71], floatround(ostmed, floatround_ceil));
			SuccessMessage(playerid, string);
		}
		PlayerInfo[playerid][pRemedy] = gettime()+300;
		mysql_save(playerid, 60);
		update_illness(playerid, medid);
 	}
 	return 1;
}
stock getmed(playerid, para1)
{
	new str[84],sctring[4800], stope, agaest;
	format(str,sizeof(str),"\n{ff9000}Симптомы: %s[%d]",PlayerInfo[para1][pName], para1), strcat(sctring,str);
	for(new i = 0; i < 5; i++)
	{
		new Float:ostmed = (PlayerInfo[para1][pIllnessProg][i]-1000)/200;
		if(PlayerInfo[para1][pIllness][i] == 1 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Хламидиоз
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Хламидиоз {444444}[ Лекарство: Хламидиуберин ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			if(PlayerInfo[para1][pSex] == 1) format(str,sizeof(str),"\n{cccccc}выделения из мочеиспускательного канала"), strcat(sctring,str);
			else format(str,sizeof(str),"\n{cccccc}выделения из влагалища"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}легкая боль при мочеиспускании"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-10 хп во время мочеиспускании"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 2 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Гонорея
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Гонорея {444444}[ Лекарство: Гоногон ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}жжение и зуд во время мочеиспускания"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}гнойные выделения из уретры"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-20 хп во время мочеиспускании"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 3 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Сифилис
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Сифилис {444444}[ Лекарство: Сифистоп ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}высыпания на коже"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}жжение и зуд во время мочеиспускания"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}повышенная температура тела"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}общая слабость и сонливость"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-2 хп каждые 30 секунд"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 4 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Лучевая Болезнь
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Лучевая Болезнь {444444}[ Лекарство: Радиануклин ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}общая слабость и сонливость"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}тошнота"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}головная боль"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}боль в животе"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}высокая температура тела"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-4 хп каждые 30 секунд"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 5 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Перитонит мочевого пузыря
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Перитонит Мочевого Пузыря {444444}[ Лекарство: Перитонин ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}повышенная температура"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}тошнота"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}сильная боль в низу живота"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}недержание мочи"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-2 хп каждые 30 секунд"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 6 && PlayerInfo[para1][pIllnessProg][i] > 1000) //  Грибок ногтей
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Грибок Ногтей {444444}[ Лекарство: Грибкоубивин ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}зуд, жжение, покраснение, мелкие трещины в межпальцевом промежутке"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-2 хп каждые 30 секунд"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 7 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Дерматит
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Дерматит {444444}[ Лекарство: Дерматитогон ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}покраснение кожи"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}ощущение покалывания, жжения и зуда"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}небольшие высыпания"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-2 хп каждые 30 секунд"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 8 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Акне
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Акне {444444}[ Лекарство: Акнестопин ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}высыпания на коже"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}угри"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-2 хп каждые 30 секунд"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 9 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Порошковаяовая Зависимость
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Порошковая Зависимость {444444}[ Лекарство: Порошкозаменин ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}депрессия"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}сонливость, утомляемость"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}повышенная тяга к порошку"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-2 хп каждые 30 секунд"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 10 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Никотиновая Зависимость
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Никотиновая Зависимость {444444}[ Лекарство: Никотиновый пластырь ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}головокружение"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}мышечная слабость"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}тревога, беспокойство"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}тяга к сигаретам"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 11 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Алкоголизм
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Алкоголизм {444444}[ Лекарство: Бухлозаменин ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}мутные и покрасневшие белки глаз"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}темные круги под глазами"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}морщины и отеки"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}одутловатое лицо"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}тяга к алкоголю"), strcat(sctring,str);
			stope = 1;
		}
        if(PlayerInfo[para1][pIllness][i] == 12 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Гастрит
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Гастрит {444444}[ Лекарство: Гастритоуберин ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}боли в желудке"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}тошнота"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-2 хп каждые 30 секунд"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 13 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Язва
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Язва {444444}[ Лекарство: Язвазаживин ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}боли в желудке"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}тошнота"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}повышенная температура"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}слабый пульс"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-4 хп каждые 30 секунд"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 14 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Простуда
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Простуда {444444}[ Лекарство: Колдрекс, Терафлю или Анвимакс ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}повышенная температура тела"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}насморк"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}кашель"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-2 хп каждую минуту"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 15 && PlayerInfo[para1][pIllnessProg][i] > 1000) // ОРВИ
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}ОРВИ {444444}[ Лекарство: Колдрекс, Терафлю или Анвимакс ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}повышенная температура тела"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}насморк"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}боль в горле"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}озноб"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-2 хп каждую минуту"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 16 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Грипп
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Грипп {444444}[ Лекарство: Колдрекс, Терафлю или Анвимакс ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}повышенная температура тела"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}насморк"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}боль в горле"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}головная боль"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}боль в суставах"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}тошнота"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-2 хп каждую минуту"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 17 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Covid 19
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1)
			{
				format(str,sizeof(str),"\n\n{ff6666}Covid-19 {444444}[ Лекарство: Колдрекс, Терафлю или Анвимакс ]"), strcat(sctring,str);
				format(str,sizeof(str),"\n{444444}Лечение: %d таблеток", floatround(ostmed, floatround_ceil)), strcat(sctring,str);
			}
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}повышенная температура тела"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}затрудненное дыхание"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}сухой кашель"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}общая слабость и сонливость"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}-2 хп каждую минуту"), strcat(sctring,str);
			stope = 1;
		}
		if(PlayerInfo[para1][pIllness][i] == 18 && PlayerInfo[para1][pIllnessProg][i] > 1000) // Вампиризм
		{
			if(PlayerInfo[para1][pIllnessStat][i] == 1) format(str,sizeof(str),"\n\n{ff6666}Вампиризм {444444}[ Лекарство: Неизвестно ]"), strcat(sctring,str);
			else format(str,sizeof(str),"\n"), strcat(sctring,str), agaest ++;
			if(PlayerInfo[playerid][pSoska] >= 15) format(str,sizeof(str),"\n{cccccc}[Slot: %d, ID %d] Прогресс: %d", i, PlayerInfo[para1][pIllness][i], PlayerInfo[para1][pIllnessProg][i]), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}бледная кожа"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}реакция на ультрафиолет"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}отторжение пищи"), strcat(sctring,str);
			format(str,sizeof(str),"\n{cccccc}жажда крови"), strcat(sctring,str);
			stope = 1;
		}
	}
	if(stope == 0) format(str,sizeof(str),"\n{99ff66}Нет болезней и симптомов\n"), strcat(sctring,str);
	if((PlayerInfo[playerid][pMember] == 4 || PlayerInfo[playerid][pLeader] == 4) && agaest > 0) format(str,sizeof(str),"\n\n{444444}Определите болезнь на основе симптомов пациента\n"), strcat(sctring,str);
    ShowDialog(playerid,1126,DIALOG_STYLE_MSGBOX,"{ff6666}Осмотр Пациента",sctring,"Назад","");
	return 1;
}

stock InfoEatMessage(playerid, stat)
{
	if(OnlineInfo[playerid][oMessageInfect] <= gettime())
	{
		OnlineInfo[playerid][oMessageEat] = gettime() + 600; // 10 Минут Unix

		format(lines,sizeof(lines),""); // Очищаем Lines

		if(getillness(playerid, 18))
		{
			if(stat == 0) // Просто хотим кушать
			{
				SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Меня мучает жажда [ N - Инвентарь >> Сытость ]");
				format(line,sizeof(line),"{ffcc66}Ваш персонаж хочет крови"), strcat(lines,line);
				format(line,sizeof(line),"\n{684F7D}Срочно найдите кровь и выпейте её"), strcat(lines,line);
			}
			else if(stat == 1) // Пиздец
			{
				SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я теряю силы.. Меня мучает жажда [ N - Инвентарь >> Сытость ]");
				format(line,sizeof(line),"{ffcc66}Ваш персонаж хочет крови"), strcat(lines,line);
				format(line,sizeof(line),"\n{684F7D}Теперь усталость влияет на вас"), strcat(lines,line);
			}
		}
		else
		{
			if(stat == 0) // Просто хотим кушать
			{
				SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я хочу кушать [ N - Инвентарь >> Сытость ]");
				format(line,sizeof(line),"{ffcc66}Ваш персонаж хочет кушать"), strcat(lines,line);
				format(line,sizeof(line),"\n{99ff66}Отправляйтесь в закусочную и купите еды"), strcat(lines,line);
			}
			else if(stat == 1) // Пиздец
			{
				SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня болит животик.. Я сильно хочу кушать [ N - Инвентарь >> Сытость ]");
				format(line,sizeof(line),"{ffcc66}Ваш персонаж хочет кушать"), strcat(lines,line);
				format(line,sizeof(line),"\n{FF6347}У вас начинает накапливаться болезнь"), strcat(lines,line);
			}
		}
		ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");

		if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) SendMindMessage(playerid,"• xo¤y kyҐa¦©"," ");
		else SendMindMessage(playerid,"I want to eat"," ");

		Login[2][playerid] = 0;
	}
	return 1;
}

stock InfoPissMessage(playerid, stat)
{
	if(OnlineInfo[playerid][oMessagePiss] <= gettime())
	{
		OnlineInfo[playerid][oMessagePiss] = gettime() + 600; // 10 Минут Unix

		format(lines,sizeof(lines),""); // Очищаем Lines

		if(stat == 0) // Просто хотим сцать
		{
			format(line,sizeof(line),"{ffcc66}Ваш персонаж хочет в туалет"), strcat(lines,line);
			format(line,sizeof(line),"\n{99ff66}Отправляйтесь в туалет и воспользуйтесь им"), strcat(lines,line);
			format(line,sizeof(line),"\n\n{cccccc}Не справляйте нужду при людях в открытую, это не культурно"), strcat(lines,line);
		}
		else if(stat == 1) // Пиздец
		{
			format(line,sizeof(line),"{ffcc66}Ваш персонаж хочет в туалет"), strcat(lines,line);
			format(line,sizeof(line),"\n{FF6347}Если вы не сходите в туалет, ваш персонаж обмочится"), strcat(lines,line);
		}
		ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");

		Login[2][playerid] = 0;
	}
	return 1;
}

stock InfectInfo(playerid)
{
	if(OnlineInfo[playerid][oMessageInfect] <= gettime())
	{
		OnlineInfo[playerid][oMessageInfect] = gettime() + 600; // 10 Минут Unix

		if(getillness(playerid, 18))
		{
			SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Брр.. холодно. Но мне пофиг на ледяную воду");
			format(lines,sizeof(lines),""); // Очищаем Lines
			format(line,sizeof(line),"{ffcc66}Ваш персонаж плавает в холодной воде, но ему всё-равно"), strcat(lines,line);
			format(line,sizeof(line),"\n{FF6347}Вы вампир и поэтому вам не страшны болезни"), strcat(lines,line);
			ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Брр.. холодно. Я заболею если буду долго плавать в холодной воде");
			format(lines,sizeof(lines),""); // Очищаем Lines
			format(line,sizeof(line),"{ffcc66}Ваш персонаж плавает в холодной воде и начинает простужаться"), strcat(lines,line);
			format(line,sizeof(line),"\n{FF6347}Через 4 минуты пребывания в холодной воде персонаж заболеет"), strcat(lines,line);
			format(line,sizeof(line),"\n\n{99ff66}Подсказка :)\n{ffcc66}Употребив алкоголь вы сможете плавать и не заболеть"), strcat(lines,line);
			ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
		}
		Login[2][playerid] = 0;
	}
	return 1;
}

stock VampireInfo(playerid)
{
	format(lines,sizeof(lines),""); // Очищаем Lines
	format(line,sizeof(line),"{684F7D}Как найти проклятие?"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Откройте один из четырёх саркофагов в этой гробнице"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Проклятие может произойти случайно только с одним человеком раз в 4 часа"), strcat(lines,line);

	format(line,sizeof(line),"\n\n{684F7D}Что даёт проклятие?"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Вы никогда не заболеете другими, любыми болезнями"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Ваш персонаж никогда не устаёт и ему не нужен сон"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Вы НЕ сможете питаться обычной едой, от неё вас будет тошнить"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- С 6:00 до 21:00 находясь на солнце вы будете сгорать и терять здоровье"), strcat(lines,line);

	format(line,sizeof(line),"\n\n{684F7D}Как защититься от солнца?"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Находиться в интерьерах или сидеть в транспорте"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Надеть скафандр космонавта в NASA"), strcat(lines,line);

	format(line,sizeof(line),"\n\n{684F7D}Вы можете обратить другого игрока в вампира"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Приобретите нож в супермаркете и наполните бокал своей кровью"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Если вы вампир, дайте выпить эту кровь другому игроку"), strcat(lines,line);

	format(line,sizeof(line),"\n\n{684F7D}Как вам питаться?"), strcat(lines,line);
	format(line,sizeof(line),"\n{ffcc66}1. Вы можете выпить кровь у игрока без сознания, чтобы насытиться"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Для этого нокаутируйте игрока битой"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Затем зажмите Правую Кнопку Мыши и Кнопку ALT"), strcat(lines,line);
	format(line,sizeof(line),"\n{ffcc66}2. Игрок может добровольно дать вам свою кровь"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- С помощью ножа из супермаркете попросите игрока наполнить бокал своей кровью"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Эту кровь вы можете употребить в любой момент и насытиться"), strcat(lines,line);
	format(line,sizeof(line),"\n{ffcc66}3. Употреблять кровь животных"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Приобретите на ферме бычью кровь и употребляйте её"), strcat(lines,line);

	format(line,sizeof(line),"\n\n{684F7D}Как избавиться от проклятия?"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Наденьте на себя аксессуар Распятие и вы вновь станете обычным человеком"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Найти аксессуар можно случано, открывая саркофаги в этой гробнице"), strcat(lines,line);

	format(line,sizeof(line),"\n\n{684F7D}Распятие"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Если вы носите распятие, вампир не сможет выпить вашу кровь"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}- Если вы носите распятие, вы никогда не станете вампиром"), strcat(lines,line);

	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{684F7D}Проклятие Фараонов",lines,"*","");
	return 1;
}

stock infectback(playerid)
{
	for(new i = 0; i < 5; i++)
	{
		if(PlayerInfo[playerid][pIllness][i] == 4)
		{
			if(GetPlayerVirtualWorld(i) == 221 && GetPlayerInterior(i) == 221 || GetPlayerVirtualWorld(i) == 222 && GetPlayerInterior(i) == 222) {}
			else
			{
				if(PlayerInfo[playerid][pIllnessProg][i] < 1000)
				{
					PlayerInfo[playerid][pIllnessProg][i] -= 50;
					if(PlayerInfo[playerid][pIllnessProg][i] <= 0) PlayerInfo[playerid][pIllness][i] = 0, PlayerInfo[playerid][pIllnessStat][i] = 0, PlayerInfo[playerid][pIllnessProg][i] = 0;
				}
			}
		}
		if(PlayerInfo[playerid][pIllness][i] == 9 || PlayerInfo[playerid][pIllness][i] == 10 || PlayerInfo[playerid][pIllness][i] == 11)
		{
			if(PlayerInfo[playerid][pIllnessProg][i] < 1000)
			{
				PlayerInfo[playerid][pIllnessProg][i] -= 5;
				if(PlayerInfo[playerid][pIllnessProg][i] <= 0) PlayerInfo[playerid][pIllness][i] = 0, PlayerInfo[playerid][pIllnessStat][i] = 0, PlayerInfo[playerid][pIllnessProg][i] = 0;
			}
		}
		if(PlayerInfo[playerid][pIllness][i] == 14 || PlayerInfo[playerid][pIllness][i] == 15 || PlayerInfo[playerid][pIllness][i] == 16 || PlayerInfo[playerid][pIllness][i] == 17)
		{
			if(PlayerInfo[playerid][pIllnessProg][i] < 1000)
			{
				PlayerInfo[playerid][pIllnessProg][i] -= 4;
				if(PlayerInfo[playerid][pIllnessProg][i] <= 0) PlayerInfo[playerid][pIllness][i] = 0, PlayerInfo[playerid][pIllnessStat][i] = 0, PlayerInfo[playerid][pIllnessProg][i] = 0;
			}
		}
		if(PlayerInfo[playerid][pIllness][i] == 18)
		{
			if(PlayerInfo[playerid][pIllnessProg][i] >= 500 && PlayerInfo[playerid][pIllnessProg][i] < 1000)
			{
				PlayerInfo[playerid][pIllnessProg][i] += 30;
				if(PlayerInfo[playerid][pIllnessProg][i] >= 1000)
				{
					PlayerInfo[playerid][pIllnessProg][i] = 2000, PlayerInfo[playerid][pNeon] = 1000, PlayerInfo[playerid][pMechSkill] = 1000;
					if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) burn_vampire(playerid, 1);
					if(PlayerInfo[playerid][pOdet][0] == 11712) RemoveAksess(playerid, 0);
					else if(PlayerInfo[playerid][pOdet][1] == 11712) RemoveAksess(playerid, 1);
					else if(PlayerInfo[playerid][pOdet][2] == 11712) RemoveAksess(playerid, 2);
					else if(PlayerInfo[playerid][pOdet][3] == 11712) RemoveAksess(playerid, 3);
					else if(PlayerInfo[playerid][pOdet][4] == 11712) RemoveAksess(playerid, 4);
					if(PlayerInfo[playerid][pAchieve][13] == 0) AchievePlayer(playerid, 13, 1);
				}
			}
		}
	}
	return 1;
}
stock ContagiousInfect(stat) // Заразные болезни
{
	if(stat == 14 || stat == 15 || stat == 16 || stat == 17) return 1;
	return 0;
}
stock create_infect(playerid, stat, prog, i)
{
	PlayerInfo[playerid][pIllness][i] = stat;
	PlayerInfo[playerid][pIllnessProg][i] += prog;
	if(PlayerInfo[playerid][pIllnessProg][i] >= 1000)
	{
		PlayerInfo[playerid][pIllnessProg][i] = 2000;
		if(zones_coldstat[playerid] == 0 && stat >= 14 && stat <= 17)
		{
			zones_cold[playerid] = CreateDynamicSphere(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid], 2.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)), zones_coldstat[playerid] = stat;
			AttachDynamicAreaToPlayer(zones_cold[playerid], playerid, 0.0, 0.0, 0.0);
		}
	}
}
stock infect(playerid, stat, prog)
{
	new yes = -1;

    if(getillness(playerid, 18) && PlayerInfo[playerid][pNeon] > 100) yes = -2;
	else
    {
		for(new i = 0; i < 5; i++)
		{
			if(PlayerInfo[playerid][pIllness][i] == stat && PlayerInfo[playerid][pIllness][i] != 9 && PlayerInfo[playerid][pIllness][i] != 18)
			{
				create_infect(playerid, stat, prog, i), yes = 1;
				break;
			}
		}
		if(yes == -1)
		{
			for(new i = 0; i < 5; i++)
			{
				if(PlayerInfo[playerid][pIllness][i] == 0)
				{
					create_infect(playerid, stat, prog, i), yes = 1;
					break;
				}
			}
		}
	}
	return yes;
}
stock infectremedy(playerid, stat, prog)
{
	new medid;
	for(new i = 0; i < 5; i++)
	{
		if(PlayerInfo[playerid][pIllness][i] == stat)
		{
			PlayerInfo[playerid][pIllnessProg][i] -= prog;
			if(PlayerInfo[playerid][pIllnessProg][i] <= 1199)
			{
				PlayerInfo[playerid][pIllness][i] = 0;
				PlayerInfo[playerid][pIllnessStat][i] = 0;
				PlayerInfo[playerid][pIllnessProg][i] = 0;
				if(ContagiousInfect(stat) && zones_coldstat[playerid] == stat) DestroyDynamicArea(zones_cold[playerid]), zones_coldstat[playerid] = 0;
				incold[playerid] = 0;

				if(ContagiousInfect(stat))
				{
					PlayerInfo[playerid][pColdCD] = gettime() + 2592000;
				}
			}
			medid = i;
			break;
		}
	}
	return medid;
}
stock createcold(playerid)
{
	for(new i = 0; i < 5; i++)
	{
		if((PlayerInfo[playerid][pIllness][i] == 14 || PlayerInfo[playerid][pIllness][i] == 15 || PlayerInfo[playerid][pIllness][i] == 16 || PlayerInfo[playerid][pIllness][i] == 17) && PlayerInfo[playerid][pIllnessProg][i] >= 1000)
		{
			if(zones_coldstat[playerid] == 0)
			{
				zones_cold[playerid] = CreateDynamicSphere(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid], 2.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)), zones_coldstat[playerid] = PlayerInfo[playerid][pIllness][i];
				AttachDynamicAreaToPlayer(zones_cold[playerid], playerid, 0.0, 0.0, 0.0);
			}
			break;
		}
	}
	return 1;
}
stock illness(playerid)
{
	if(PlayerInfo[playerid][pIllness][0] > 0 && PlayerInfo[playerid][pIllnessProg][0] >= 1000 || PlayerInfo[playerid][pIllness][1] > 0 && PlayerInfo[playerid][pIllnessProg][1] >= 1000
	|| PlayerInfo[playerid][pIllness][2] > 0 && PlayerInfo[playerid][pIllnessProg][2] >= 1000 || PlayerInfo[playerid][pIllness][3] > 0 && PlayerInfo[playerid][pIllnessProg][3] >= 1000
	|| PlayerInfo[playerid][pIllness][4] > 0 && PlayerInfo[playerid][pIllnessProg][4] >= 1000) return 1;
	return 0;
}
stock illnessnovampire(playerid)
{
	new quan;
    for(new i = 0; i < 5; i++)
	{
        if(PlayerInfo[playerid][pIllness][i] > 0 && PlayerInfo[playerid][pIllnessProg][i] >= 1000 && PlayerInfo[playerid][pIllness][i] != 18) quan ++;
	}
	if(quan > 0) return 1;
	return 0;
}
stock getinfect(playerid, stat)
{
	new stope;
	for(new i = 0; i < 5; i++)
	{
		if(PlayerInfo[playerid][pIllness][i] == stat)
		{
		    stope = 1;
		    break;
		}
	}
	return stope;
}
stock getillness(playerid, stat)
{
	new stope;
	for(new i = 0; i < 5; i++)
	{
		if(PlayerInfo[playerid][pIllness][i] == stat && PlayerInfo[playerid][pIllnessProg][i] >= 1000)
		{
		    stope = 1;
		    break;
		}
	}
	return stope;
}
stock getdiagnosis(playerid, stat)
{
	new stope;
	for(new i = 0; i < 5; i++)
	{
		if(PlayerInfo[playerid][pIllness][i] == stat)
		{
			if(PlayerInfo[playerid][pIllnessStat][i] == 1)
			{
			    stope = 1;
			    break;
			}
		}
	}
	return stope;
}
stock update_illness(playerid, stat)
{
	if(ContagiousInfect(stat))
	{
		format(big_query,sizeof(big_query),"UPDATE `pp_igroki` SET `Illness%d`='%d',`IllnessStat%d`='%d',`IllnessProg%d`='%d',`pColdCD`='%d' WHERE `id`='%d'", 
		stat, PlayerInfo[playerid][pIllness][stat], stat, PlayerInfo[playerid][pIllnessStat][stat], stat, PlayerInfo[playerid][pIllnessProg][stat], PlayerInfo[playerid][pColdCD], PlayerInfo[playerid][pID]);
	}
	else
	{
		format(big_query,sizeof(big_query),"UPDATE `pp_igroki` SET `Illness%d`='%d',`IllnessStat%d`='%d',`IllnessProg%d`='%d' WHERE `id`='%d'", 
		stat, PlayerInfo[playerid][pIllness][stat], stat, PlayerInfo[playerid][pIllnessStat][stat], stat, PlayerInfo[playerid][pIllnessProg][stat], PlayerInfo[playerid][pID]);
	}
    query_empty(pearsq, big_query);
	return 1;
}
stock update_allillness(playerid)
{
	format(big_query, sizeof(big_query), "UPDATE `pp_igroki` SET `Illness0`='%d',`IllnessStat0`='%d',`IllnessProg0`='%d',`Illness1`='%d',`IllnessStat1`='%d',`IllnessProg1`='%d',`Illness2`='%d',`IllnessStat2`='%d',`IllnessProg2`='%d',\
  	`Illness3`='%d',`IllnessStat3`='%d',`IllnessProg3`='%d',`Illness4`='%d',`IllnessStat4`='%d',`IllnessProg4`='%d' WHERE `id`='%d'",
  	PlayerInfo[playerid][pIllness][0],PlayerInfo[playerid][pIllnessStat][0],PlayerInfo[playerid][pIllnessProg][0],PlayerInfo[playerid][pIllness][1],PlayerInfo[playerid][pIllnessStat][1],PlayerInfo[playerid][pIllnessProg][1],
  	PlayerInfo[playerid][pIllness][2],PlayerInfo[playerid][pIllnessStat][2],PlayerInfo[playerid][pIllnessProg][2],PlayerInfo[playerid][pIllness][3],PlayerInfo[playerid][pIllnessStat][3],PlayerInfo[playerid][pIllnessProg][3],
  	PlayerInfo[playerid][pIllness][4],PlayerInfo[playerid][pIllnessStat][4],PlayerInfo[playerid][pIllnessProg][4], PlayerInfo[playerid][pID]);
  	query_empty(pearsq, big_query);
  	return 1;
}

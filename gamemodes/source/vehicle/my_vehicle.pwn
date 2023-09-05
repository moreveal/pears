
new SellVeh[MAX_REALPLAYERS];

stock checkAccessMyVehicle(playerid)
{
	new v = DP[2][playerid];
	if(DP[1][playerid] == 1)
	{
		new slotId = DP[0][playerid] - 1;
		if(slotId < 0 || slotId >= MAX_MYVEHICLE)
		{
			ErrorMessage(playerid, "{FF6347}Ошибка! неверный слот транспорта [checkAccessMyVehicle]");
			if(v == 0 || v == 9999) return ErrorMessage(playerid, "{FF6347}Ошибка! Транспорт не записан в слот [checkAccessMyVehicle]");
			return 0;
		}
	}
	else if(DP[1][playerid] == 2)
	{
		new unix = gettime();
		if(unix > PlayerInfo[playerid][pKeyVeh][3])
		{
			ErrorMessage(playerid, "{FF6347}Закончилось время доступа к транспорту");
			PlayerInfo[playerid][pKeyVeh][0] = 0;
			mysql_SavePlayer(playerid, "KeyVeh0", 0);
			return 0;
		}
		if(PlayerInfo[playerid][pKeyVeh][0] == 0 || PlayerInfo[playerid][pKeyVehID] == 0)
		{
			ErrorMessage(playerid, "{FF6347}Ошибка! Транспорт отсутствует [checkAccessMyVehicle]");
			return 0;
		}
		new vehicleid = PlayerInfo[playerid][pKeyVehID];
		if(VehInfo[vehicleid][vModel] != PlayerInfo[playerid][pKeyVeh][0] || VehInfo[vehicleid][vKey] != PlayerInfo[playerid][pID] 
		|| VehInfo[vehicleid][vSost] != PlayerInfo[playerid][pKeyVeh][1])
		{
			ErrorMessage(playerid, "{FF6347}Ошибка! Неверный id транспорта или транспорт был отозван [checkAccessMyVehicle]");
			return 0;
		}
	}
	return 1;
}

CMD:insertcar(playerid)
{
	if(IsAtPark(playerid))
	{
    	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid, "{FF6347}Вам нужно быть за рулём транспорта");
    	new vehicleid = GetPlayerVehicleID(playerid);
		new modelka = GetVehicleModel(vehicleid);
    	if(VehInfo[vehicleid][vStat] == PlayerInfo[playerid][pID] || VehInfo[vehicleid][vKey] == PlayerInfo[playerid][pID] && VehInfo[vehicleid][vKeyUnix] > gettime())
    	{
			if((IsPlayerInRangeOfPoint(playerid,10.0,2814.1458,-1456.9066,16.2500) || IsPlayerInRangeOfPoint(playerid,10.0,-2495.3384,374.9754,35.1194)
			|| IsPlayerInRangeOfPoint(playerid,10.0,2464.9907,1633.5537,10.8203) || IsPlayerInRangeOfPoint(playerid,10.0,2246.3945,2042.6685,10.8203)) && (IsAPlane(modelka) || IsABoat(modelka))) return ErrorMessage(playerid, "{FF6347}На эту парковку можно ставить только автомобиль или мотоцикл");
			if((IsPlayerInRangeOfPoint(playerid,20.0,1983.2249,-2315.4692,13.5469) || IsPlayerInRangeOfPoint(playerid,20.0,-1475.9408,-156.5503,14.1484)
			|| IsPlayerInRangeOfPoint(playerid,20.0,1330.5399,1341.7534,10.8203)) && (IsACar(modelka) || IsABoat(modelka) || IsAMoto(modelka))) return ErrorMessage(playerid, "{FF6347}В аэропорту можно оставлять только аэротранспорт");
			if((IsPlayerInRangeOfPoint(playerid,30.0,2317.8706,-2393.4094,3.0000) || IsPlayerInRangeOfPoint(playerid,30.0,-2947.4229,503.3807,2.4297)
			|| IsPlayerInRangeOfPoint(playerid,30.0,2359.3020,523.5991,1.7969)) && (IsACar(modelka) || IsAPlane(modelka) || IsAMoto(modelka))) return ErrorMessage(playerid, "{FF6347}К причалу можно швартовать только лодки и катера");
			if(PlayerInfo[playerid][pTstat] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя доставать или парковать транспорт во время сделки");
			if(GetPVarInt(playerid,"stopload") >= 1) return ErrorMessage(playerid, "{FF6347}Стоп! Дождитесь завершения загрузки личного транспорта");

			SaveMyVehiclePos(vehicleid); // Сохраняем позицию транспорта
    		SaveCar(vehicleid);
    		SaveBoot(vehicleid);
			ACDestroyVehicle(vehicleid);
    		PlayerPlaySound(playerid,1138,0,0,0);

    		if(IsPlayerInRangeOfPoint(playerid,30.0,2317.8706,-2393.4094,3.0000)) PPSetPlayerPos(playerid,2317.8706,-2393.4094,3.0000);
			else if(IsPlayerInRangeOfPoint(playerid,30.0,-2947.4229,503.3807,2.4297)) PPSetPlayerPos(playerid,-2947.4229,503.3807,2.4297);
			else if(IsPlayerInRangeOfPoint(playerid,30.0,2359.3020,523.5991,1.7969)) PPSetPlayerPos(playerid,2359.3020,523.5991,1.7969);
    		if(PlayerInfo[playerid][pSex] == 1)SetPlayerChatBubble(playerid,"поставил транспорт на парковку",COLOR_PURPLE,20.0,3000);
    		else if(PlayerInfo[playerid][pSex] == 2)SetPlayerChatBubble(playerid,"поставила транспорт на парковку",COLOR_PURPLE,20.0,3000);

			SuccessMessage(playerid, "{99ff66}Транспорт отправлен на парковку\n\n{cccccc}Достать транспорт [ Y >> Транспорт ]\nПри извлечении, транспорт загрузится здесь");
    	}
    	else ErrorMessage(playerid, "{FF6347}Вы можете отправить на парковку только личный транспорт\n\n{cccccc}Примечание: Вы можете убирать транспорт, от которого у вас есть ключи");
	}
	return 1;
}

CMD:infocar(playerid)
{
	new Float:cars_pos[3], infocar = -1;
	for(new cars = 1; cars < SKOKOCAROV; cars++)
	{
		if(VehInfo[cars][vSellcar] == 0) continue;
  		GetCoordSellCarVehicle(cars, cars_pos[0], cars_pos[1], cars_pos[2]);
  		if(IsPlayerInRangeOfPoint(playerid, 2.0, cars_pos[0], cars_pos[1], cars_pos[2])) infocar = cars;
	}
	if(infocar == -1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Рядом со мной нет транспорта на продаже");
	else pts(playerid, infocar);
	return 1;
}
CMD:buycar(playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return ErrorMessage(playerid, "{FF6347}Вы находитесь в слежке");
	new Float:cars_pos[3], v = -1;
	for(new cars = 1; cars < SKOKOCAROV; cars++)
	{
		if(VehInfo[cars][vSellcar] == 0) continue;
  		GetCoordSellCarVehicle(cars, cars_pos[0], cars_pos[1], cars_pos[2]);
  		if(IsPlayerInRangeOfPoint(playerid, 2.0, cars_pos[0], cars_pos[1], cars_pos[2])) v = cars;
	}
	if(v < 0) return ErrorMessage(playerid, "{FF6347}Рядом с вами нет транспорта на продаже");
	else
	{
		new vladid = VehInfo[v][vIdvlad];
		if(vladid == playerid) return ErrorMessage(playerid, "{FF6347}Вы не можете купить транспорт у себя");
		if(GetPlayerQuanLoadVehicle(playerid) >= 2) return ErrorMessage(playerid, "{FF6347}У вас загружено два личных транспортных средства\n{cccccc}Уберите один загруженный транспорт на парковку");
		if(oGetPlayerMoney(playerid) < VehInfo[v][vSellcar]) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
		DP[3][playerid] = v;
		format(store, sizeof(store), "{cccccc}Вы уверены, что хотите купить {ff9000}%s [ID: %d] {cccccc}у %s[%d]?\n\nСтоимость: {99ff66}%d$ {cccccc}[ %s ]",vehName[VehInfo[v][vModel]], v, PlayerInfo[vladid][pName], vladid, VehInfo[v][vSellcar], get_k(VehInfo[v][vSellcar]));
		ShowDialog(playerid,1093,DIALOG_STYLE_MSGBOX,"{ff9000}Покупка Транспорта",store,"Да","Нет");
	}
	return 1;
}

stock DestroyMyVehicles(playerid)
{
	new vehicleid;
	for(new i = 0; i < MAX_MYVEHICLE; i++)
	{
		if(PlayerInfo[playerid][pMyVeh][i] == 0) continue;
		if(PlayerInfo[playerid][pMyVehID][i] > 0)
		{
			vehicleid = PlayerInfo[playerid][pMyVehID][i];
			if(VehInfo[vehicleid][vNospawn] == 0) // Спавнить можно (система не блокирует)
			{
				if(!CarRespawn(playerid, vehicleid)) PP_SetVehicleToRespawn(vehicleid); // В транспорте никто не сидит, кроме игрока
			}
		}
	}
	return 1;
}

stock SaveMyVehiclePos(vehicleid) // Сохраняем позицию личного транспорта
{
	GetVehicleZAngle(vehicleid, VehInfo[vehicleid][vKoordinatA]);
	GetVehiclePos(vehicleid, VehInfo[vehicleid][vKoordinatX], VehInfo[vehicleid][vKoordinatY], VehInfo[vehicleid][vKoordinatZ]);
	return 1;
}

CMD:car(playerid)
{
	if(PlayerInfo[playerid][pBkyrenie] >= 2) return ErrorMessage(playerid, "{FF6347}Ваш персонаж учавствует в экспедиции NASA");
	if(howstun(playerid) || HealthAC[playerid] <= 0 || GetPVarInt(playerid,"Boot") != 9999) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо и он не может сейчас это сделать");
	if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вас преследует полиция");
	if(MPGO[playerid] != 0 || CnnVed[playerid] >= 11 || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return ErrorMessage(playerid, "{FF6347}Сейчас нельзя управлять своим транспортом");
	
	format(lines,sizeof(lines),""); // Очищаем Lines

	PlayerPlaySound(playerid,1150,0,0,0);
	format(line,sizeof(line),"{cccccc}Название \t "), strcat(lines,line);

	// Личный Транспорт
	new quan;
	for(new i = 0; i < MAX_MYVEHICLE; i++)
	{
		List[i][playerid] = 0, ListParam[i][playerid] = 0; // Очищаем листы
		if(PlayerInfo[playerid][pMyVeh][i] > 0)
        {
			if(PlayerInfo[playerid][pMyVehID][i] > 0)
			{
				format(line,sizeof(line),"\n{ff9000}%d. %s \t ", i + 1, vehName[PlayerInfo[playerid][pMyVeh][i]]), strcat(lines,line);
			}
			else format(line,sizeof(line),"\n{cccccc}%d. %s \t ", i + 1, vehName[PlayerInfo[playerid][pMyVeh][i]]), strcat(lines,line);
			List[quan][playerid] = i;
			ListParam[quan][playerid] = 1; // Личный Транспорт
			quan ++;
		}
	}

	new unix = gettime();
	new tyear, tmonth, tday, thour, tminute, tsecond;
	stamp2datetime(PlayerInfo[playerid][pKeyVeh][3], tyear, tmonth, tday, thour, tminute, tsecond, 3);

	// Ключи от Транспорта
	if(PlayerInfo[playerid][pKeyVeh][0] > 0 && PlayerInfo[playerid][pKeyVeh][3] > unix)
	{
		if(PlayerInfo[playerid][pKeyVehID] > 0)
		{
			format(line,sizeof(line),"\n{ff9000}%s \t {cccccc}Ключи до %02d.%02d.%d %02d:%02d", vehName[PlayerInfo[playerid][pKeyVeh][0]], tday, tmonth, tyear, thour, tminute), strcat(lines,line);
		}
		else format(line,sizeof(line),"\n{cccccc}%s \t {cccccc}Ключи до %02d.%02d.%d %02d:%02d", vehName[PlayerInfo[playerid][pKeyVeh][0]], tday, tmonth, tyear, thour, tminute), strcat(lines,line);
		List[quan][playerid] = 0;
		ListParam[quan][playerid] = 3; // Ключи
		quan ++;
	}

	// Арендованный Транспорт
	for(new i = 0; i < 2; i++)
	{
		if(PlayerInfo[playerid][pRent][i] > unix)
		{
			stamp2datetime(PlayerInfo[playerid][pRent][i], tyear, tmonth, tday, thour, tminute, tsecond, 3);
			format(line,sizeof(line),"\n{0088ff}%s \t {cccccc}Аренда до %02d:%02d",vehName[PlayerInfo[playerid][pRentModel][i]], thour, tminute), strcat(lines,line);
			List[quan][playerid] = i;
			ListParam[quan][playerid] = 2; // Арендованный Транспорт
			quan ++;
		}
	}
	ShowDialog(playerid,653,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Мой Транспорт",lines,"Выбрать","Отмена");
	return 1;
}
stock GetPlayerQuanLoadVehicle(playerid)
{
	new quanLoad;
	for(new i = 0; i < MAX_MYVEHICLE; i++)
	{
		if(PlayerInfo[playerid][pMyVehID][i] > 0) quanLoad ++;
	}
	return quanLoad;
}
stock slcar(playerid, i)
{
	i --;

	new v, model;
	if(DP[1][playerid] == 1)
	{
		if(i < 0 || i >= MAX_MYVEHICLE) return ErrorMessage(playerid, "{FF6347}Ошибка! неверный слот транспорта [slcar]");
		v = PlayerInfo[playerid][pMyVehID][i];
		model = PlayerInfo[playerid][pMyVeh][i];
		DP[2][playerid] = v;
	}
	else if(DP[1][playerid] == 2)
	{
		v = PlayerInfo[playerid][pKeyVehID];
		model = PlayerInfo[playerid][pKeyVeh][0];
		DP[2][playerid] = v;
	}

	if(v == 0)
	{
		if(DP[1][playerid] == 1 && GetPlayerQuanLoadVehicle(playerid) >= 2) return ErrorMessage(playerid, "{FF6347}Вы не можете загрузить три личных транспорта одновременно\n{cccccc}Уберите один загруженный транспорт на парковку");

		format(store, sizeof(store), "{ff9000}Вы хотите загрузить %s?\n\n{cccccc}Транспорт появится там, где его оставили последний раз", vehName[model]);
		ShowDialog(playerid,652,DIALOG_STYLE_MSGBOX,"{ff9000}Транспорт",store,"Да","Нет");
		return 1;
	}

    model = GetVehicleModel(v);
    new str[100],sctring[500],qwer[44];
	format(str,sizeof(str),"{ff9000}Доставить Транспорт \t{cccccc}[-5 Fuel]\n"), strcat(sctring,str);
	if(VehInfo[v][vCarLock] == 0) format(str,sizeof(str),"{cccccc}Центральный Замок \t{99ff66}[ Открыт ]\n"), strcat(sctring,str);
	else if(VehInfo[v][vCarLock] == 1) format(str,sizeof(str),"{cccccc}Центральный Замок \t{FF6347}[ Закрыт ]\n"), strcat(sctring,str);
	format(str,sizeof(str),"{cccccc}Найти\t\n"), strcat(sctring,str);
	if(VehInfo[v][vAlarm] == 0) format(str,sizeof(str),"{cccccc}Сигнализация \t{FF6347}[ Off ]\n"), strcat(sctring,str);
	else if(VehInfo[v][vAlarm] == 1) format(str,sizeof(str),"{cccccc}Сигнализация \t{99ff66}[ On ]\n"), strcat(sctring,str);
	if(VehInfo[v][vEngine] == 0) format(str,sizeof(str),"{cccccc}Двигатель \t{FF6347}[ Off ]\n"), strcat(sctring,str);
	else if(VehInfo[v][vEngine] == 1) format(str,sizeof(str),"{cccccc}Двигатель \t{99ff66}[ On ]\n"), strcat(sctring,str);
	if(VehInfo[v][vLights] == 0) format(str,sizeof(str),"{cccccc}Фары \t{FF6347}[ Off ]\n"), strcat(sctring,str);
	else if(VehInfo[v][vLights] == 1) format(str,sizeof(str),"{cccccc}Фары \t{99ff66}[ On ]\n"), strcat(sctring,str);
	format(str,sizeof(str),"{999999}П.Т.С.\t\n"), strcat(sctring,str);

	if(DP[1][playerid] == 2) // Ключи
	{
		format(str,sizeof(str),"{FF6347}Отдать ключи\t\n"), strcat(sctring,str);
	}
	else if(DP[1][playerid] == 1) // Личный
	{
		if(VehInfo[v][vKey] != 0 && VehInfo[v][vKeyUnix] > gettime()) format(str,sizeof(str),"{cccccc}Отозвать Ключи\t\n"), strcat(sctring,str);
		else format(str,sizeof(str),"{cccccc}Дать Ключи\t\n"), strcat(sctring,str);

		if(VehInfo[v][vUpgrade] >= 1) format(str,sizeof(str),"{cccccc}Увеличить Багажник \t{99ff66}[ OK ]\n"), strcat(sctring,str);
		else if(VehInfo[v][vUpgrade] == 0) format(str,sizeof(str),"{cccccc}Увеличить Багажник \t{ffcc00}[ 100G ]\n"), strcat(sctring,str);
		if(VehInfo[v][vSellcar] == 0) format(str,sizeof(str),"{99ff66}Выставить {cccccc}на Продажу\t\n"), strcat(sctring,str);
		else format(str,sizeof(str),"{FF6347}Отменить {cccccc}Продажу\t\n"), strcat(sctring,str);
		format(str,sizeof(str),"{999999}О продаже..\t\n"), strcat(sctring,str);
	}

	format(qwer,sizeof(qwer),"{ff9000}%s {cccccc}[%d] Личный",vehName[model], v);
	ShowDialog(playerid,298,DIALOG_STYLE_TABLIST,qwer,sctring,"Выбрать","Отмена");
	return 1;
}
stock pts(p, v)
{
	new model = GetVehicleModel(v), vladid = VehInfo[v][vIdvlad];
	format(lines,sizeof(lines),""); // Очищаем Lines

   	format(line,sizeof(line),"\n{cccccc}Марка ТС: {0088ff}%s [ID: %d]",vehName[model],v), strcat(lines,line);
   	format(line,sizeof(line),"\n{cccccc}Модель №: {0088ff}%d",VehInfo[v][vModel]), strcat(lines,line);
   	format(line,sizeof(line),"\n{cccccc}Год изготовления: {cccccc}%d",VehInfo[v][vGod]), strcat(lines,line);
   	format(line,sizeof(line),"\n{cccccc}Владелец: {0088ff}%s[%d]",PlayerInfo[vladid][pName],vladid), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Налог: {FF6347}%s$ {555555}каждый PayDay",Procent(1, vehSumma[model])), strcat(lines,line);

   	if(VehInfo[v][vUpgrade] == 1) format(line,sizeof(line),"\n{cccccc}Увеличенный Багажник: {99ff66}установлен"), strcat(lines,line);
   	else if(VehInfo[v][vUpgrade] == 0) format(line,sizeof(line),"\n{cccccc}Увеличенный Багажник: {333333}отсутствует"), strcat(lines,line);

   	format(line,sizeof(line),"\n\n{cccccc}Гос. стоимость: {99ff66}%d$",vehSumma[model]), strcat(lines,line);
	format(line,sizeof(line),"\n{555555}В автосалоне стоимость выше из-за наценки\n",vehSumma[model]), strcat(lines,line);

	for(new i = 0; i < 13; i++)
	{
		if(GetVehicleComponentInSlot(v,i) != 0) format(line,sizeof(line),"\n{0088ff}* {cccccc}%s",detalName[GetVehicleComponentInSlot(v,i)]), strcat(lines,line);
	}
	format(line,sizeof(line),"\n"), strcat(lines,line);
	ShowDialog(p,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Паспорт Транспортного Средства",lines,"*","");
}
function LoadCar(playerid, dab, race_check)
{
	new rows;
	cache_get_row_count(rows);
	if(!rows)
	{
		ErrorMessage(playerid, "{FF6347}Ошибка! Транспорт не найден\n\n{cccccc}Обратитесь к администрации [ /report ]");
		SetPVarInt(playerid,"stopload",0);
		return 0;
	}

	if(g_MysqlRaceCheck[playerid] != race_check) return Kick(playerid);

	new paramet[6], fine;
	cache_get_value_name_int(0, "finelien", fine);
	cache_get_value_name_int(0, "sost", paramet[0]);

	if(fine > 0)
	{
		SetPVarInt(playerid,"stopload",0);
		if(paramet[0] == PlayerInfo[playerid][pID])
		{
			SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Транспорт арестован {FF6347}[ Подробности: Y >> GPS >> Транспорт >> Штраф Стоянка ]");
			ErrorMessage(playerid, "{FF6347}Транспорт арестован!\n\n{cccccc}Подробности: Y >> GPS >> Транспорт >> Штраф Стоянка");
		}
		else 
		{
			ErrorMessage(playerid, "{FF6347}Транспорт арестован!\n\n{cccccc}Владелец может узнать подробности ареста на штраф стоянке");
			PlayerInfo[playerid][pKeyVeh][0] = 0;
			mysql_SavePlayer(playerid, "KeyVeh0", 0);
		}
		return 1;
	}

	new Float:kord[4], vehid, newid, yescar, string[124];
	cache_get_value_name_int(0, "newid", newid);
	for(new car = 1; car < SKOKOCAROV; car++)
	{
		if(VehInfo[car][vNewid] == newid) yescar = car;
	}
	if(yescar > 0) // Такой транспорт уже на сервере
	{
		SetPVarInt(playerid,"stopload",0);
		if(paramet[0] == PlayerInfo[playerid][pID])
		{
			VehInfo[yescar][vIdvlad] = playerid;
			VehInfo[yescar][vDatabase] = dab;
			PlayerInfo[playerid][pMyVehID][dab - 1] = yescar;

			SuccessMessage(playerid, "{99ff66}Ваш транспорт уже на сервере\n\n{cccccc}Возможно его кто-то использует\n[ Y >> Транспорт >> Название >> Найти ]");
		}
		else
		{
			if(VehInfo[yescar][vKey] != PlayerInfo[playerid][pID])
			{
				ErrorMessage(playerid, "{FF6347}Владелец отозвал ключи от транспорта");
				PlayerInfo[playerid][pKeyVeh][0] = 0;
				mysql_SavePlayer(playerid, "KeyVeh0", 0);
				return 1;
			}
			PlayerInfo[playerid][pKeyVehID] = yescar;
			SuccessMessage(playerid, "{99ff66}Транспорт уже на сервере\n\n{cccccc}Возможно его кто-то использует\n[ Y >> Транспорт >> Название >> Найти ]");
		}
	}
	else
	{
		cache_get_value_name_int(0, "model", paramet[1]);
		cache_get_value_name_float(0, "koordinatx", kord[0]);
		cache_get_value_name_float(0, "koordinaty", kord[1]);
		cache_get_value_name_float(0, "koordinatz", kord[2]);
		cache_get_value_name_float(0, "koordinata", kord[3]);
		cache_get_value_name_int(0, "vehcol1", paramet[2]);
		cache_get_value_name_int(0, "vehcol2", paramet[3]);
		cache_get_value_name_int(0, "arest", paramet[4]);
		cache_get_value_name_int(0, "keyveh", paramet[5]);
		if(paramet[0] != 0 && paramet[1] != 0 && paramet[4] == 0)
		{
			if(paramet[0] != PlayerInfo[playerid][pID] && paramet[5] != PlayerInfo[playerid][pID])
			{
				ErrorMessage(playerid, "{FF6347}Владелец отозвал ключи от транспорта");
				PlayerInfo[playerid][pKeyVeh][0] = 0;
				mysql_SavePlayer(playerid, "KeyVeh0", 0);
				SetPVarInt(playerid,"stopload",0);
				return 1;
			}
			vehid = PP_CreateVehicle(vehid, paramet[1], kord[0],kord[1],kord[2],kord[3], paramet[2],paramet[3], -1,0, 20); // Спавн через 10 минут неактивности

			if(vehid == -1)
			{
				ErrorMessage(playerid, "{FF6347}Превышен лимит загруженных транспортных средств на сервере\n\n{cccccc}Пожалуйста, обратитесь к администрации для устранения этой проблемы [ /report ]");
				SetPVarInt(playerid,"stopload",0);
				return 1;
			}

			if(paramet[0] == PlayerInfo[playerid][pID]) PlayerInfo[playerid][pMyVehID][dab - 1] = vehid; // Личный
			else PlayerInfo[playerid][pKeyVehID] = vehid; // Ключи от транспорта

			Cars[vehid] = 88;
			VehInfo[vehid][vIdvlad] = playerid;
			VehInfo[vehid][vNewid] = newid;
			VehInfo[vehid][vSost] = paramet[0];
			VehInfo[vehid][vModel] = paramet[1];
			VehInfo[vehid][vKoordinatX] = kord[0];
			VehInfo[vehid][vKoordinatY] = kord[1];
			VehInfo[vehid][vKoordinatZ] = kord[2];
			VehInfo[vehid][vKoordinatA] = kord[3];
			VehInfo[vehid][vVehcol1] = paramet[2];
			VehInfo[vehid][vVehcol2] = paramet[3];
			VehInfo[vehid][vKey] = paramet[5];

			cache_get_value_name(0, "numer", VehInfo[vehid][vNumer], 20);
			cache_get_value_name_int(0, "arest", VehInfo[vehid][vArest]);
			cache_get_value_name_int(0, "lock", VehInfo[vehid][vCarLock]);
			cache_get_value_name_int(0, "comp1", VehInfo[vehid][vComp1]);
			cache_get_value_name_int(0, "comp2", VehInfo[vehid][vComp2]);
			cache_get_value_name_int(0, "comp3", VehInfo[vehid][vComp3]);
			cache_get_value_name_int(0, "comp4", VehInfo[vehid][vComp4]);
			cache_get_value_name_int(0, "comp5", VehInfo[vehid][vComp5]);
			cache_get_value_name_int(0, "comp6", VehInfo[vehid][vComp6]);
			cache_get_value_name_int(0, "comp7", VehInfo[vehid][vComp7]);
			cache_get_value_name_int(0, "comp8", VehInfo[vehid][vComp8]);
			cache_get_value_name_int(0, "comp9", VehInfo[vehid][vComp9]);
			cache_get_value_name_int(0, "comp10", VehInfo[vehid][vComp10]);
			cache_get_value_name_int(0, "comp11", VehInfo[vehid][vComp11]);
			cache_get_value_name_int(0, "benz", Gas[vehid]);
			cache_get_value_name_int(0, "benz2", Gelium[vehid]);
			cache_get_value_name_int(0, "god", VehInfo[vehid][vGod]);
			cache_get_value_name_int(0, "vehhp", VehInfo[vehid][vVehhp]);
			cache_get_value_name_int(0, "keyunix", VehInfo[vehid][vKeyUnix]);
			
			for(new i = 0; i < 20; i++)
			{
				format(string,sizeof(string),"Inven%d", i+1), cache_get_value_name_int(0, string, VehInfo[vehid][vInvent][i]);
				format(string,sizeof(string),"InvenKol%d", i+1), cache_get_value_name_int(0, string, VehInfo[vehid][vInv][i]);
				format(string,sizeof(string),"InvenPara%d", i+1), cache_get_value_name_int(0, string, VehInfo[vehid][vInvPara][i]);
				format(string,sizeof(string),"InvenQara%d", i+1), cache_get_value_name_int(0, string, VehInfo[vehid][vInvQara][i]);
				format(string,sizeof(string),"InvenType%d", i+1), cache_get_value_name_int(0, string, VehInfo[vehid][vInvType][i]);
				format(string,sizeof(string),"InvenPack%d", i+1), cache_get_value_name_int(0, string, VehInfo[vehid][vInvPack][i]);
			}
			cache_get_value_name_int(0, "upgrade", VehInfo[vehid][vUpgrade]);
			cache_get_value_name_int(0, "nosell", VehInfo[vehid][vNosell]);
			
			VehInfo[vehid][vDatabase] = dab;
			LoadTunning(vehid);

			LockCar(vehid,VehInfo[vehid][vCarLock]);
			GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(vehid, false, false, false, false, false, false, objective);
			format(string, sizeof(string), "{111111}%s",VehInfo[vehid][vNumer]);
			SetVehicleNumberPlate(vehid, string);

			SuccessMessage(playerid, "{99ff66}Транспорт загружен");
		}
	}
	SetPVarInt(playerid,"stopload",0);
	return 1;
}

CMD:scrap(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid,5.0,51.3109,936.5281,22.0238))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid, "{FF6347}Вы не за рулём личного транспорта");
    	new v = GetPlayerVehicleID(playerid);
		if(PlayerInfo[playerid][pTstat] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя сдать личный транспорт в утиль во время сделки");
		
		if(VehInfo[v][vNosell] == 1) ShowDialog(playerid,765,DIALOG_STYLE_MSGBOX,"{FF9000}Утиль","{ff9000}Вы уверены что хотите сдать транспорт в утиль?\n{ff0000}Внимание! {ffcc00}Это Media Транспорт и возврат денег невозможен","Да","Нет");
		else
		{
			format(store,sizeof(store),"{ff9000}Вы уверены что хотите сдать транспорт в утиль?\n{cccccc}Возврат: [ {99ff66}%d$ {cccccc}] (1/10 от стоимости)",vehSumma[GetVehicleModel(v)]/10);
			ShowDialog(playerid,765,DIALOG_STYLE_MSGBOX,"{FF9000}Утиль",store,"Да","Нет");
		}
	}
	return 1;
}
stock Scrap(playerid) // Сдаём транспорт в утиль
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid, "{FF6347}Вы не за рулём личного транспорта");
	if(PlayerInfo[playerid][pTstat] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя сдать личный транспорт в утиль во время сделки");

	new newcar = GetPlayerVehicleID(playerid);
	if(VehInfo[newcar][vSost] == PlayerInfo[playerid][pID]) // Личный Транспорт
	{
		new slot = VehInfo[newcar][vDatabase];

		if(PlayerInfo[playerid][pVehTax][slot - 1] > 0) return ErrorMessage(playerid, "{FF6347}Вам необходимо оплатить налоги на транспорт");
		if(VehInfo[newcar][vNosell] == 1) SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Транспорт сдан в утиль! Возвращение суммы за Media Транспорт: {ff0000}Невозможно");
		else
		{
			oGivePlayerMoney(playerid, vehSumma[VehInfo[newcar][vModel]]/10);
			format(store,sizeof(store),"[ Мысли ]: Транспорт сдан в утиль [ {99ff66}+%d$ {cccccc}]",vehSumma[VehInfo[newcar][vModel]]/10);
			SendClientMessage(playerid, COLOR_GREY, store);
		}
		CarLog("scrap", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], VehInfo[newcar][vModel], vehSumma[VehInfo[newcar][vModel]]/10, "");
		
		format(store,sizeof(store),"DELETE FROM `pp_cars` WHERE `newid` = '%d'", VehInfo[newcar][vNewid]);
		query_empty(pearsq, store);

		PlayerInfo[playerid][pMyVeh][slot] = 0;
		PlayerInfo[playerid][pMyVehID][slot] = 0;
		
		PlayerPlaySound(playerid,1138,0,0,0);
		if(PlayerInfo[playerid][pSex] == 1)SetPlayerChatBubble(playerid,"сдал транспорт в утиль",COLOR_PURPLE,20.0,3000);
		else if(PlayerInfo[playerid][pSex] == 2)SetPlayerChatBubble(playerid,"сдала транспорт в утиль",COLOR_PURPLE,20.0,3000);

		ACDestroyVehicle(newcar);

		// Сохраняем авто
  		format(store,sizeof(store),"UPDATE `pp_igroki` SET `MyVeh%d` = '0' WHERE `id` = '%d'", slot, PlayerInfo[playerid][pID]);
        query_empty(pearsq, store);

		if(IsPlayerInRangeOfPoint(playerid,10.0,2276.8972,534.0618,1.0)) PPSetPlayerPos(playerid,2284.4485,521.0029,1.7217), SetPlayerFacingAngle(playerid,270.0);
		else if(IsPlayerInRangeOfPoint(playerid,10.0,-1467.3530,669.2661,1.0)) PPSetPlayerPos(playerid,-1460.5260,678.3433,1.5122), SetPlayerFacingAngle(playerid,90.0);
		else if(IsPlayerInRangeOfPoint(playerid,10.0,2741.2739,-2316.9890,1.0)) PPSetPlayerPos(playerid,2733.0496,-2312.8413,1.5468), SetPlayerFacingAngle(playerid,180.0);
	}
	else ErrorMessage(playerid, "{FF6347}Вы не за рулём личного транспорта");
	return 1;
}

CMD:delcar(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 19 && PlayerInfo[playerid][pMedia] <= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	new tmp[24],slot,para1;
	if(sscanf(params, "s[24]i", tmp,slot)) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Удалить личный транспорт [ /delcar ID Слот ]");
	if(slot > MAX_MYVEHICLE || slot < 1) return ErrorMessage(playerid, "{FF6347}Номер слота не меньше 1 и не больше 20");

	para1 = ReturnUser(tmp, 1);
	if(IsPlayerConnected(para1))
 	{
 	    if(PlayerInfo[playerid][pSoska] < 19 && playerid != para1) return ErrorMessage(playerid, "{FF6347}Вы можете удалить только свой личный транспорт");
		format(store,sizeof(store),"SELECT * FROM `pp_cars` WHERE `sost` = '%d' AND `slot` = '%d'", PlayerInfo[para1][pID], slot);
        mysql_tquery(pearsq, store, "Call_delcar", "dsdd", playerid, PlayerInfo[para1][pName], PlayerInfo[para1][pID], slot);
	}
	else
	{
	    if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы можете удалить только свой личный транспорт");
		if(!CheckRP_Nickname(tmp)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
		format(store,sizeof(store),"SELECT * FROM `pp_igroki` WHERE `Name` = '%s'", tmp);
		mysql_tquery(pearsq, store, "Call_delcaroff", "dsd", playerid, tmp, slot);
	 }
	return 1;
}
function Call_delcaroff(playerid, str_name[], slot)
{
	new rows, datadid;
	cache_get_row_count(rows);
	if(rows)
	{
		cache_get_value_name_int(0, "id", datadid);
		format(store,sizeof(store),"SELECT * FROM `pp_cars` WHERE `sost` = '%d' AND `slot` = '%d'", datadid, slot);
		mysql_tquery(pearsq, store, "Call_delcar", "dsdd", playerid, str_name, datadid, slot);
	}
	else format(store,sizeof(store),"[ Мысли ]: Такого аккаунта не существует %s ",str_name), SendClientMessage(playerid,COLOR_GREY,store);
	return 1;
}
function Call_delcar(playerid, str_name[], str_id, slot)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		if(PlayerInfo[playerid][pSoska] < 19)
	    {
			new datad1;
			cache_get_value_name_int(0, "nosell", datad1);
			if(datad1 == 0) return ErrorMessage(playerid, "{FF6347}Вы не можете удалить этот транспорт [ Только созданный через медиа ]");
		}

		format(store,sizeof(store),"DELETE FROM `pp_cars` WHERE `sost` = '%d' AND `slot` = '%d'", str_id, slot);
        query_empty(pearsq, store);
		format(store, sizeof(store), " [ ADM ]: %s удалил транспорт игрока %s [ Слот: %d ]",PlayerInfo[playerid][pName],str_name, slot);
  		ABroadCast(COLOR_ADM,store,1);

        // Сохраняем авто
  		format(store,sizeof(store),"UPDATE `pp_igroki` SET `MyVeh%d` = '0' WHERE `id` = '%d'", slot - 1, str_id);
        query_empty(pearsq, store);

    	// Если чувак оказался Online
    	new para1 = ReturnUser(str_name, 1);
	    if(IsPlayerConnected(para1))
	    {
			new veh = PlayerInfo[para1][pMyVehID][slot - 1];
			PlayerInfo[para1][pMyVeh][slot - 1] = 0;
            PlayerInfo[para1][pMyVehID][slot - 1] = 0;

			ACDestroyVehicle(veh);
   			AdminLog("delcar", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[para1][pID], PlayerInfo[para1][pName], PlayerInfo[para1][pPlaIP], slot, "");
   			return 1;
	    }
	    AdminLog("delcar", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], str_id, str_name, "", slot, "");
	}
	else format(store,sizeof(store),"[ Мысли ]: У %s отсутствует личный транспорт в слоте %d",str_name, slot), SendClientMessage(playerid,COLOR_GREY,store);
	return 1;
}

CMD:addcar(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 19 && PlayerInfo[playerid][pMedia] <= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    new para1,vehid,tmp[24],nyche;
    if(sscanf(params, "s[24]i",tmp,vehid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Создание личного авто /addcar ID VehID");

    if(PlayerInfo[playerid][pSoska] < 19) nyche = 1; // Помечаем недоступный, для продажи, транспорт
    else nyche = 0;
    if(vehid > 609 || vehid < 400) return ErrorMessage(playerid, "{FF6347}ID Транспорта не меньше 400 и не больше 609");
    para1 = ReturnUser(tmp, 1);
    if(IsPlayerConnected(para1))
    {
        if(PlayerInfo[playerid][pSoska] < 19 && playerid != para1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я могу выдать личный транспорт только себе");
        new freeSlot = GetPlayerFreeVehSlot(para1);
        if(freeSlot == -1) return ErrorMessage(playerid, "{FF6347}У игрока нет свободного слота\n\n{cccccc}Возможно, требуется открыть дополнительные слоты [ Y >> Donate ]");


		new posId, biz, Float:pos[4];
		if(IsABoat(vehid)) biz = 90 + random(2), posId = random(4);
		else if(IsAPlane(vehid)) biz = 87 + random(2), posId = random(7);
		else if(IsAMoto(vehid)) biz = 82 + random(4), posId = random(7);
		else biz = 77 + random(4), posId = random(7);

		GetCoordBuyVehicle(biz, posId, pos[0], pos[1], pos[2], pos[3]);
		GiveCar(para1, freeSlot, vehid, pos[0], pos[1], pos[2], pos[3],nyche, 1, 1);
        AdminLog("addcar", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[para1][pID], PlayerInfo[para1][pName], PlayerInfo[para1][pPlaIP], vehid, "");
        
        format(store, sizeof(store), "{0088ff}[ {ffcc66}Server {0088ff}] {ffcc66}%s {ffffff}выдал вам %s [ Y >> Транспорт ]", PlayerInfo[playerid][pName], vehName[vehid]);
        SendClientMessage(para1, COLOR_GREY, store);
        format(store, sizeof(store), "{0088ff}[ {ffcc66}Server {0088ff}] {ffffff}Вы создали личный транспорт игроку {ffcc66}%s {0088ff}%s", PlayerInfo[para1][pName],vehName[vehid]);
        SendClientMessage(playerid, COLOR_GREY, store);
    }
    else
    {
        if(!CheckRP_Nickname(tmp)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
        format(store,sizeof(store),"SELECT * FROM `pp_igroki` WHERE `Name` = '%s'", tmp);
        mysql_tquery(pearsq, store, "Call_addcaradmin", "dsdd", playerid, tmp, vehid, nyche);
        return 1;
    }
	return 1;
}
stock GiveCar(playerid, slot, carid, Float:x,Float:y,Float:z,Float:f,nyche, col1, col2)
{
	format(store, sizeof(store), "SELECT * FROM `pp_cars` WHERE `sost`='%d' AND `slot`='%d'", PlayerInfo[playerid][pID], slot + 1);
	mysql_tquery(pearsq, store, "Call_GiveCar", "dddffffddd", playerid, slot, carid, Float:x,Float:y,Float:z,Float:f,nyche, col1, col2);
	return 1;
}
function Call_GiveCar(playerid, slot, carid, Float:x,Float:y,Float:z,Float:f,nyche, col1, col2)
{
	new rows;
	cache_get_row_count(rows);
	if(!rows)
	{
		if(slot < 0 || slot >= MAX_MYVEHICLE) return printf("[debug]: Call_GiveCar (str_name: %s, slot: %d, carid: %d)", PlayerInfo[playerid][pName], slot, carid);

		format(big_query, sizeof(big_query), "INSERT INTO `pp_cars` SET `sost`='%d',`slot`='%d',`model`='%d',`koordinatx`='%f',`koordinaty`='%f',\
		`koordinatz`='%f',`koordinata`='%f',`vehcol1`='%d',`vehcol2`='%d',`numer`='%s',`comp1`='999',`benz`='100',`god`='2023',`vehhp`='1000',`nosell`='%d'", PlayerInfo[playerid][pID],slot + 1,carid, x,y, z, f, col1, col2, CreatePlatesVehicle(),nyche);
		query_empty(pearsq, big_query);

        // Сохраняем авто
		format(store,sizeof(store),"UPDATE `pp_igroki` SET `MyVeh%d` = '%d' WHERE `id`='%d'", slot, carid, PlayerInfo[playerid][pID]);
		query_empty(pearsq, store);

		if(IsPlayerConnected(playerid)) PlayerInfo[playerid][pMyVeh][slot] = carid;
	}
	return true;
}

function Call_addcaradmin(playerid, str_name[], f_vehid, nyche)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
        new vehID[MAX_MYVEHICLE], bool:vehFreeSlot[MAX_MYVEHICLE], freeSlot = -1, datadid;

        for(new i = 0; i < MAX_MYVEHICLE; i++)
	    {
            format(store,sizeof(store),"MyVeh%d",i);
	  		cache_get_value_name_int(0, store, vehID[i]);
			format(store,sizeof(store),"MyVehSlot%d",i);
	  		cache_get_value_name_bool(0, store, vehFreeSlot[i]);

            if(i <= 1) // Первые два, не нуждаются в покупке слота
            {
                if(vehID[i] == 0) freeSlot = i;
            }
            else
            {
                if(vehID[i] == 0 && vehFreeSlot[i] == true) freeSlot = i;
            }
        }
        if(freeSlot == -1) return ErrorMessage(playerid, "{FF6347}У игрока нет свободного слота\n\n{cccccc}Возможно, требуется открыть дополнительные слоты [ Y >> Donate ]");
        cache_get_value_name_int(0, "id", datadid);

		new posId, biz, Float:pos[4];
		if(IsABoat(f_vehid)) biz = 90 + random(2), posId = random(4);
		else if(IsAPlane(f_vehid)) biz = 87 + random(2), posId = random(7);
		else if(IsAMoto(f_vehid)) biz = 82 + random(4), posId = random(7);
		else biz = 77 + random(4), posId = random(7);

		GetCoordBuyVehicle(biz, posId, pos[0], pos[1], pos[2], pos[3]);
		GiveCarOffline(str_name, freeSlot, f_vehid, pos[0], pos[1], pos[2], pos[3],datadid,nyche);
	    AdminLog("addcar", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], datadid, str_name, "", f_vehid, "");
	    format(store, sizeof(store), "{0088ff}[ {ffcc66}Server {0088ff}] {ffffff}Вы создали личный транспорт игроку {ffcc66}%s {0088ff}%s", str_name,vehName[f_vehid]);
	    SendClientMessage(playerid, COLOR_GREY, store);

	    format(store, sizeof(store), "Вам выдан %s", vehName[f_vehid]);
		notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], datadid, str_name, store);
	}
	else format(store,sizeof(store),"[ Мысли ]: Такого аккаунта не существует [ {ff0000}%s {cccccc}]",str_name), SendClientMessage(playerid,COLOR_GREY,store);
	return true;
}
function GiveCarOffline(str_name[], slot, carid, Float:x, Float:y, Float:z, Float:f, ploid, nyche)
{
	format(store, sizeof(store), "SELECT * FROM `pp_cars` WHERE `sost`='%d' AND `slot`='%d'", ploid, slot + 1);
	mysql_tquery(pearsq, store, "Call_GiveCarOffline", "sddffffdd", str_name, slot, carid, Float:x,Float:y,Float:z,Float:f,ploid,nyche);
	return 1;
}
function Call_GiveCarOffline(str_name[], slot, carid, Float:x,Float:y,Float:z,Float:f,ploid,nyche)
{
	new rows;
	cache_get_row_count(rows);
	if(!rows)
	{
		if(slot < 0 || slot >= MAX_MYVEHICLE) return printf("[debug]: Call_GiveCarOffline (str_name: %s, slot: %d, carid: %d)", str_name, slot, carid);

		format(big_query, sizeof(big_query), "INSERT INTO `pp_cars` SET `sost`='%d',`slot`='%d',`model`='%d',`koordinatx`='%f',`koordinaty`='%f',\
		`koordinatz`='%f',`koordinata`='%f',`vehcol1`='1',`vehcol2`='1',`numer`='%s',`comp1`='999',`benz`='100',`god`='2023',`vehhp`='1000',`nosell`='%d'", ploid, slot + 1,carid, x,y, z, f,CreatePlatesVehicle(),nyche);
		query_empty(pearsq, big_query);

        // Сохраняем авто
		format(store,sizeof(store),"UPDATE `pp_igroki` SET `MyVeh%d` = '%d' WHERE `id` = '%d'",slot, carid, ploid);
		query_empty(pearsq, store);
	}
	return 1;
}

stock GetPlayerFreeVehSlot(playerid) // Получаем свободный слот личного транспорта, с учётом доп слотов
{
    new freeSlot = -1;
    for(new i = 0; i < MAX_MYVEHICLE; i++)
	{
        if(i <= 1) // Первые два, не нуждаются в покупке слота
        {
            if(PlayerInfo[playerid][pMyVeh][i] == 0) 
			{
				freeSlot = i;
				break;
			}
        }
        else
        {
            if(PlayerInfo[playerid][pMyVeh][i] == 0 && PlayerInfo[playerid][pMyVehSlot][i] == true) 
			{
				freeSlot = i;
				break;
			}
        }
    }
    return freeSlot;
}
stock GetPlayerVehicleSlot(playerid)
{
	new quanSlot;
	for(new i = 0; i < MAX_MYVEHICLE; i++)
	{
        if(i <= 1) quanSlot ++;
        else
        {
            if(PlayerInfo[playerid][pMyVehSlot][i] == true) quanSlot ++;
        }
    }
	return quanSlot;
}

CMD:rslot(playerid, const params[])
{
	new giveplayerid,tmp[24],vslot;
	if(sscanf(params, "s[24]i", tmp,vslot)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Удалить багнутое авто из stats [ /rslot ID Слот ]");
 	giveplayerid = ReturnUser(tmp, 1);
	if(PlayerInfo[playerid][pSoska] >= 20)
	{
 		if(IsPlayerConnected(giveplayerid))
   		{
    		if(OnlineInfo[giveplayerid][oLogged] == 0) return SendClientMessage(playerid, COLOR_GREY, "   Игрок не залогинился!!!");
		    if(PlayerInfo[giveplayerid][pSoska] >= 9 && giveplayerid != playerid) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу сбросить авто администратору выского уровня");
		    if(vslot > MAX_MYVEHICLE || vslot < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Номер слота не меньше 1 и не больше 20");

			PlayerInfo[giveplayerid][pMyVeh][vslot - 1] = 0;
			format(store,sizeof(store),"UPDATE `pp_igroki` SET `MyVeh%d` = '0' WHERE `Name` = '%s'", vslot - 1, PlayerInfo[giveplayerid][pName]);
			query_empty(pearsq, store);

  	    	format(store, sizeof(store), "{ffffff}[ {0088ff}ADM {ffffff}] Игроку %s очищен слот транспорта № %d",PlayerInfo[giveplayerid][pName],vslot);
   	    	SendClientMessage(playerid, COLOR_WHITE, store);
    	    PlayerPlaySound(giveplayerid,6401,0,0,0);
		}
		else
		{
  			if(!CheckRP_Nickname(tmp)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: /rslot Lol_Lolkin");
  			format(store,sizeof(store),"SELECT * FROM `pp_igroki` WHERE `Name` = '%s'", tmp);
  			mysql_tquery(pearsq, store, "Call_resetslot", "dsd", playerid, tmp, vslot);
  			return 1;
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу использовать эту команду");
	return 1;
}
function Call_resetslot(playerid, str_name[],vslot)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
   		format(store,sizeof(store),"UPDATE `pp_igroki` SET `MyVeh%d` = '0' WHERE `Name` = '%s'", vslot - 1, str_name);
    	query_empty(pearsq, store);
	    format(store, sizeof(store), "{ffffff}[ {0088ff}ADM {ffffff}] Игроку %s очищен слот транспорта № %d",str_name,vslot);
	    SendClientMessage(playerid, COLOR_WHITE, store);
	}
	else
    {
        format(store,sizeof(store),"{cccccc}[ Мысли ]: Такого аккаунта не существует [ {ff0000}%s {cccccc}]",str_name);
        SendClientMessage(playerid,COLOR_GREY,store);
    }
	return true;
}

stock CreatePlatesVehicle()
{
    new numer[12],bukv[3][2];
    new nomer = 100 + random(899);
    new bukvi[3];
    for(new i = 0; i < 3; i++)
	{
	    bukvi[i] = 1 + random(25);
	    switch(bukvi[i])
		{
		    case 1: bukv[i] = "Q";
		    case 2: bukv[i] = "W";
		    case 3: bukv[i] = "E";
		    case 4: bukv[i] = "R";
		    case 5: bukv[i] = "T";
		    case 6: bukv[i] = "Y";
		    case 7: bukv[i] = "U";
		    case 8: bukv[i] = "I";
		    case 9: bukv[i] = "O";
		    case 10: bukv[i] = "P";
		    case 11: bukv[i] = "A";
		    case 12: bukv[i] = "S";
		    case 13: bukv[i] = "D";
		    case 14: bukv[i] = "F";
		    case 15: bukv[i] = "G";
		    case 16: bukv[i] = "H";
		    case 17: bukv[i] = "J";
		    case 18: bukv[i] = "K";
		    case 19: bukv[i] = "L";
		    case 20: bukv[i] = "Z";
		    case 21: bukv[i] = "X";
		    case 22: bukv[i] = "C";
		    case 23: bukv[i] = "V";
		    case 24: bukv[i] = "B";
		    case 25: bukv[i] = "N";
		    case 26: bukv[i] = "M";
		    default: bukv[i] = "M";
		}
	}
	format(numer, sizeof(numer), "%s %d %s%s", bukv[0], nomer, bukv[1], bukv[2]);
    return numer;
}
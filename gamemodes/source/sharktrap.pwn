

new Trap[MAX_REALPLAYERS];
new TrapTime[MAX_REALPLAYERS];
new TrapObj[MAX_REALPLAYERS];
new SharkObj[MAX_REALPLAYERS];
new Text3D:TrapText[MAX_REALPLAYERS];
new Float:TrapPos[MAX_REALPLAYERS][3];

stock sell_shark(playerid)
{
	new v = GetPlayerVehicleID(playerid);
	if(VehInfo[v][vModel] != 453) return ErrorMessage(playerid, "{FF6347}Вам необходимы быть за штурвалом катера Reefer");
	if(VehInfo[v][vObjstat] == 1)
	{
		DestroyDynamicObject(VehInfo[v][vObject]);
		VehInfo[v][vObjstat] = 0;
		new pay;

		new sumRand = ServerInfo[1]/2; // Получаем число добавление для веса акулы
		new randomPrice;
		if(sumRand > 4) randomPrice = random(sumRand); // Если число рандомного веса больше 4, значит можно расчитать
		new givePrice;
		if(randomPrice > 0 && randomPrice <= 100000) givePrice = randomPrice; // Сука тут ещё закроем все возможные пиздецы

		pay = ServerInfo[1] + givePrice; // Стоимость акулы + рандом
		if(ServerInfo[53] == 0) pay += pay/4; // Это повышенная оплата, если она есть для этой работы сейчас
		paysalary(playerid, pay, 0);
		getkazna(3, pay);
		
		SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я продал%s акулу за {99ff66}%d$", gender(playerid), pay);
		MoneyLog("salary", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", pay, "Зарплата Акула");
		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	}
	else ErrorMessage(playerid, "{FF6347}На катере нет пойманной акулы\n{ffcc66}Приобретите ловушку в рыболовном магазине и следуйте подсказкам");
	return 1;
}

stock shark(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid,10.0, TrapPos[playerid][0], TrapPos[playerid][1], TrapPos[playerid][2])
        && GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0)
	{
		if(Trap[playerid] == 1) return ErrorMessage(playerid, "{FF6347}Ловушка ещё не сработала");
    	if(GetPlayerSpeed(playerid) > 3) return ErrorMessage(playerid, "{FF6347}Вы не можете прикрепить акулу в движении");
 		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid, "{FF6347}Вам необходимо находиться за штурвалом катера Reefer\
                                                                                            \n{ffcc66}Вы можете арендовать его на причале рыбацкой бухты");
		new v = GetPlayerVehicleID(playerid);
		if(VehInfo[v][vModel] != 453) return ErrorMessage(playerid, "{FF6347}Вам необходимо находиться за штурвалом катера Reefer\
                                                                                            \n{ffcc66}Вы можете арендовать его на причале рыбацкой бухты");
		if(VehInfo[v][vObjstat] == 0)
		{
			PlayerPlaySound(playerid, 1084, 0,0,0);
            DeleteSharkTrap(playerid); // Удаляем акулу
			SaveSharkTrap(playerid); // Сохраняем в базу

			VehInfo[v][vObject] = CreateDynamicObject(1608, 0.0 ,0.0 ,-50.0 ,0.0 ,0.0 ,0.0);
			AttachDynamicObjectToVehicle(VehInfo[v][vObject], v, 0.075000, -7.865132, -1.074999, 73.364997, 1.005001, -0.000000);
			VehInfo[v][vObjstat] = 1;
			ShowDialog(playerid, 1700, 0, "{ffcc66}*", "{cccccc}Ого! Вы поймали Акулу {ff9000}Отвезите её на Рыбацкую Бухту", "Ок", "");
			SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Фух, ничего себе громадная. Нужно побыстрее отвезти её на Рыбацкую Бухту");
			CreateGps(playerid,934.4589,-1963.9500,1.0, 0, 0, 10.0);
			update_ability(playerid, 0, 40);
			if(PlayerInfo[playerid][pAchieve][102] == 0) AchievePlayer(playerid, 102, 1);

			// Ловить акулу
			CompletingDaily(playerid, 2, 1);
		}
		else ErrorMessage(playerid, "{FF6347}На ваш катер уже погружена акула\n{ffcc66}Продайте её на причале");
        return true;
	}
	return false;
}

CMD:trap(playerid)
{
	if(get_invent4(playerid, 50, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет ловушки для акулы");
	if(MPGO[playerid] != 0) return ErrorMessage(playerid, "{FF6347}Вы на мероприятии");
	if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) 
		return ErrorMessage(playerid, "{FF6347}Вы не можете использовать ловушку для акулы в помещении\n{ffcc66}Арендуй катер Reefer и отправляйтесь в море для установки ловушки");
 	if(Hold[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вашего персонажа заняты руки");
    if(GetPlayerSpeed(playerid) > 3) return ErrorMessage(playerid, "{FF6347}Вы не можете установить ловушку в движении");
 	if(howstun(playerid) || HealthAC[playerid] <= 0) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
 	if(Trap[playerid] != 0) return ErrorMessage(playerid, "{FF6347}Вы уже установили ловушку\n{ffcc66}Когда она сработает, вам придёт уведомление");
 	else
 	{
 		new tmphour,tmpminute,tmpsecond;
		gettime(tmphour, tmpminute, tmpsecond);
		if((tmphour == 2 && tmpminute >= 30 || tmphour == 3 && tmpminute <= 3) && PlayerInfo[playerid][pSoska] <= 22) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас установить ловушку\n{ffcc66}Скоро автоматически ночной рестарт сервера в 3:00");
 		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас установить ловушку\n{ffcc66}Ваш персонаж должен быть пешком и не за рулём");
 		if(IsATrap(playerid))
	    {
	 		new animname[32], animlib[32];
			GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
			if(strcmp(animlib, "SWIM", true) == 0) return ErrorMessage(playerid, "{FF6347}Вы не можете установить ловушку в воде");
		 	SetPVarInt(playerid,"oryjtemp",0), SetPVarInt(playerid,"Arobsklad",9);
		 	SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Нужно установить ловушку {ff9000}[ Нажимайте %s ]", buttonName[Device[playerid]]);
		 	ApplyAnimation(playerid,"BOMBER","BOM_Plant_Loop",4.0, false, true, true, true, true);
		 	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~‡oўyҐka: ~w~0/100", 5000, 3);

			new string[100];
			format(string, sizeof(string), "{ffcc66}Нажимайте %s чтобы установить ловушку", buttonName[Device[playerid]]);
			ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",string,"*","");
	 	}
 	}
	return 1;
}

CMD:findtrap(playerid)
{
	if(Trap[playerid] == 0) return ErrorMessage(playerid, "{FF6347}У вас нет установленной ловушки для акул");
	CreateGps(playerid, TrapPos[playerid][0], TrapPos[playerid][1], TrapPos[playerid][2], 0, 0, 10.0);
	SendClientMessage(playerid, COLOR_GREY,"{0088ff}Ваша ловушка отмечена на карте");
	return 1;
}

CMD:testtrap(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 22 && Trap[playerid] == 1) TrapTime[playerid] -= 1200;
	return 1;
}

// Процесс срабатывания ловушки для акулы
stock ProcessSharpTrap(playerid, unix)
{
    if(unix >= TrapTime[playerid])
    {
        Trap[playerid] = 2;
		UpdateSharkTrap(playerid, true);
        Update_Trap(playerid);
    }
    return true;
}

// Удаляем ловушку для акулы
stock DeleteSharkTrap(playerid)
{
	if(Trap[playerid] > 0)
	{
		DestroyDynamic3DTextLabel(TrapText[playerid]);
		DestroyDynamicObject(TrapObj[playerid]);
		if(Trap[playerid] == 2) DestroyDynamicObject(SharkObj[playerid]);
		Trap[playerid] = 0;
	}
    return true;
}

stock ClearVariableSharkTrap(playerid)
{
    Trap[playerid] = 0;
    return true;
}

// Сохраняем в базу ловушку
stock SaveSharkTrap(playerid)
{
	if(Trap[playerid] == 0)
	{
		new string_mysql[120];
		mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_igroki` SET `pSharkTrap`= NULL WHERE `user_id` = '%d'", PlayerInfo[playerid][pID]);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new JsonNode:node = JSON_Object(
			"Trap", JSON_Int(Trap[playerid]),
            "TrapTime", JSON_Int(TrapTime[playerid]),
			"x", JSON_Float(TrapPos[playerid][0]),
            "y", JSON_Float(TrapPos[playerid][1]),
			"z", JSON_Float(TrapPos[playerid][2])
		);

		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_igroki` SET `pSharkTrap`= '%e' WHERE `user_id` = '%d'", string_json, PlayerInfo[playerid][pID]);
			mysql_tquery(pearsq, string_mysql);
		}
	}
	return true;
}

// Загружаем ловушку для акулы из базы
stock OnPlayerLoadSharkTrap(playerid)
{
	new bool:is_null;
	cache_is_value_name_null(0, "pSharkTrap", is_null);
	if(is_null == false)
	{
		new string_json[512];
		cache_get_value_name(0, "pSharkTrap", string_json, 512);

		new JsonNode:node = JSON_INVALID_NODE;
		if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
		{
			JSON_GetInt(node, "Trap", Trap[playerid]);
			JSON_GetInt(node, "TrapTime", TrapTime[playerid]);
			JSON_GetFloat(node, "x", TrapPos[playerid][0]);
    		JSON_GetFloat(node, "y", TrapPos[playerid][1]);
    		JSON_GetFloat(node, "z", TrapPos[playerid][2]);

			if(Trap[playerid] > 0) CreateSharkTrap(playerid, false);
		}
	}
	return true;
}

stock CreateSharkTrap(playerid, bool:save = true)
{
	if(Trap[playerid] == 0) return false;
	TrapObj[playerid] = CreateDynamicObject(2803, TrapPos[playerid][0], TrapPos[playerid][1], TrapPos[playerid][2], 0.0, 0.0, 0.0, 0, 0, -1, 100.00, 100.00);
	TrapText[playerid] = CreateDynamic3DTextLabel(" ",0xA9C4E4FF,TrapPos[playerid][0], TrapPos[playerid][1], TrapPos[playerid][2],15.0);
	if(gettime() >= TrapTime[playerid]) 
	{
		Trap[playerid] = 2;
		UpdateSharkTrap(playerid, false);
	}
	Update_Trap(playerid);

	// Сохраняем в базу
	if(save == true) SaveSharkTrap(playerid);
	return true;
}

stock UpdateSharkTrap(playerid, bool:message = true)
{
	if(Trap[playerid] == 2)
	{
		SharkObj[playerid] = CreateDynamicObject(1608, TrapPos[playerid][0], TrapPos[playerid][1], -6.0, 90.000000, 0.000000, -90.000000, 0, 0, -1, 100.00, 100.00);
        if(message == true) MessageSharkTrap(playerid);
	}
	return true;
}

stock MessageSharkTrap(playerid)
{
    SendClientMessage(playerid, COLOR_GREY,"{0088ff}Ваша ловушка для акулы сработала {ffcc66}[ Местонахождение отмечено на карте ]");
	CreateGps(playerid, TrapPos[playerid][0], TrapPos[playerid][1], TrapPos[playerid][2], 0, 0, 10.0);
    return true;
}

stock Update_Trap(playerid)
{
	new string[140];
	new tyear, tmonth, tday, thour, tminute, tsecond;
	stamp2datetime(TrapTime[playerid], tyear, tmonth, tday, thour, tminute, tsecond, 3);
	if(Trap[playerid] == 1) format(string, sizeof(string),"{ff9000}Ловушка для Акулы\n\n{cccccc}Сработает в {FF6347}%02d:%02d\n{cccccc}Принадлежит: {444444}%s", thour, tminute, PlayerInfo[playerid][pName]);
	else if(Trap[playerid] == 2) format(string, sizeof(string),"{ff9000}Ловушка для Акулы\n\n{99ff66}[ Забрать Акулу - CAPS LOCK (Гудок) ]\n{cccccc}Принадлежит: {444444}%s", PlayerInfo[playerid][pName]);
	UpdateDynamic3DTextLabelText(TrapText[playerid], 0xA9C4E4FF, string);
	return true;
}

stock Pump_Trap(playerid)
{
	SetPVarInt(playerid,"oryjtemp",GetPVarInt(playerid,"oryjtemp")+1+random(3));
	if(GetPVarInt(playerid,"oryjtemp") >= 100)
	{
		if(IsATrap(playerid))
	    {
			if(Trap[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Ошибка! У вас уже установлена ловушка\n{ffcc66}Дождитесь когда она сработает");

			TakeInvent(playerid, 50, 1, 0, 999);
			SetPVarInt(playerid,"oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
		 	GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~‡oўyҐka: ~w~100/100", 1500, 3);
		 	PlayerPlaySound(playerid, 1139, 0,0,0);

			new Float:pos_a;
    		frontme(playerid, 3.0, TrapPos[playerid][0], TrapPos[playerid][1], TrapPos[playerid][2], pos_a); // Смещаем координату перед игроком
			Trap[playerid] = 1;
			new sekEnd = 600+600-60*get_ability(playerid, 0);
			TrapTime[playerid] = gettime() + sekEnd;
			CreateSharkTrap(playerid);
		 	ClearAnim(playerid);

			new string[270];
			format(string, sizeof(string),"{ffcc66}Отлично! Ловушка установлена и сработает через %d минут\
											\n{ffcc66}Чем выше навык моряка, тем меньше время ожидания [ Y >> Меню >> Навыки ]\
											\n{ffcc00}Вы можете прокачать навык моряка в меню Donate [ Y >> Donate ]", sekEnd / 60);
		 	ShowDialog(playerid, 1700, 0, "{ffcc66}*", string, "Ок", "");
			SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Ловушка установлена и я могу сюда вернуться через %d минут", sekEnd / 60);
		}
		else
		{
			SetPVarInt(playerid,"oryjtemp", 0);
			SetPVarInt(playerid,"Arobsklad",0);
		}
	}
	else
	{
		new string[58];
		format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~‡oўyҐka: ~w~%d/100", GetPVarInt(playerid,"oryjtemp"));
	 	GameTextForPlayer(playerid,string, 1500, 3);
	 	ApplyAnimation(playerid,"BOMBER","BOM_Plant_Loop",4.0, false, true, true, true, true);
 	}
 	return 1;
}

stock IsATrap(playerid)
{
	if(!IsBigFish(playerid))
	{
		ErrorMessage(playerid, "{FF6347}Здесь не водятся акулы\
							\n\n{ffcc66}Вам необходимо отплыть далеко в море\
							\nили приобрести карту моряка в рыболовном магазине.\
							\nКарта моряка поможет вам найти где водятся акулы");
		return 0;
	}
	new Float:trap_pos[3], noy;
    foreach(Player, i)
	{
		if(Trap[i] > 0)
		{
			GetDynamicObjectPos(TrapObj[i], trap_pos[0], trap_pos[1], trap_pos[2]);
			if(IsPlayerInRangeOfPoint(playerid,20.0, trap_pos[0], trap_pos[1], trap_pos[2]))
			{
			    noy = 1;
			    break;
			}
		}
	}
	if(noy == 1)
	{
		ErrorMessage(playerid, "{FF6347}Вы не можете установить свою ловушку слишком близко к другой");
		return 0;
	}
	return 1;
}

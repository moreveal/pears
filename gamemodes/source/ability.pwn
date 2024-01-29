
new abilityName[][] = // Названия навыков
{
    "Навык Моряка", "Навык Космонавта", "Навык Сексуальности", "Навык Инженера", "Навык Охотника", "Навык Фермера", "Навык Взломщика", "Навык Химика", "Навык Автомеханика", "Навык Сыщика","Навык Медика"
};
new skillLevelName[][] = // Названия уровня  навыков
{
    "Чайник", "Новичок", "Начинающий", "Знающий", "Опытный", "Продвинутый", "Эксперт", "Мастер", "Лучший", "Ветеран", "Легенда"
};
new skillName[][] = // Названия навыков
{
    "Вождение Автомобилей", "Пилотирование Вертолётов", "Пилотирование Самолётов", "Вождение Катеров", "Вождение Мототранспорта", "Сила"
};

stock mysql_save_ability(playerid, abilityId) // Сохраняем навык в базу
{
	if(!IsOnline(playerid)) return 1;

	new string_mysql[120];
	if(abilityId == 2)
	{
		format(string_mysql, sizeof(string_mysql),"UPDATE `pp_igroki` SET `Voennik`='%d',`AbilStat2`='%d' WHERE `user_id`='%d'", PlayerInfo[playerid][pAbility][2], PlayerInfo[playerid][pAbilStat][2], PlayerInfo[playerid][pID]);
		query_empty(pearsq, string_mysql);
	}
	else
	{
		format(string_mysql, sizeof(string_mysql),"UPDATE `pp_igroki` SET `Ability%d`='%d',`AbilStat%d`='%d' WHERE `user_id`='%d'", abilityId, PlayerInfo[playerid][pAbility][abilityId], abilityId, PlayerInfo[playerid][pAbilStat][abilityId], PlayerInfo[playerid][pID]);
    	query_empty(pearsq, string_mysql);
 	}
    return 1;
}
stock update_ability(p, abilityId, quan) // Повышаем навык
{
	new yes;
	if(GetPlayerVip(p) > 0) PlayerInfo[p][pAbility][abilityId] += quan*2;
	else PlayerInfo[p][pAbility][abilityId] += quan;

	if(PlayerInfo[p][pAbility][abilityId] >= 1000 && PlayerInfo[p][pAbility][abilityId] <= 4999 && PlayerInfo[p][pAbilStat][abilityId] <= 1) yes = 1, PlayerInfo[p][pAbilStat][abilityId] = 2;
	else if(PlayerInfo[p][pAbility][abilityId] >= 5000 && PlayerInfo[p][pAbility][abilityId] <= 9999 && PlayerInfo[p][pAbilStat][abilityId] <= 2) yes = 1, PlayerInfo[p][pAbilStat][abilityId] = 3;
	else if(PlayerInfo[p][pAbility][abilityId] >= 10000 && PlayerInfo[p][pAbility][abilityId] <= 14999 && PlayerInfo[p][pAbilStat][abilityId] <= 3) yes = 1, PlayerInfo[p][pAbilStat][abilityId] = 4;
	else if(PlayerInfo[p][pAbility][abilityId] >= 15000 && PlayerInfo[p][pAbility][abilityId] <= 19999 && PlayerInfo[p][pAbilStat][abilityId] <= 4) yes = 1, PlayerInfo[p][pAbilStat][abilityId] = 5;
	else if(PlayerInfo[p][pAbility][abilityId] >= 20000 && PlayerInfo[p][pAbility][abilityId] <= 29999 && PlayerInfo[p][pAbilStat][abilityId] <= 5) yes = 1, PlayerInfo[p][pAbilStat][abilityId] = 6;
	else if(PlayerInfo[p][pAbility][abilityId] >= 30000 && PlayerInfo[p][pAbility][abilityId] <= 39999 && PlayerInfo[p][pAbilStat][abilityId] <= 6) yes = 1, PlayerInfo[p][pAbilStat][abilityId] = 7;
	else if(PlayerInfo[p][pAbility][abilityId] >= 40000 && PlayerInfo[p][pAbility][abilityId] <= 59999 && PlayerInfo[p][pAbilStat][abilityId] <= 7) yes = 1, PlayerInfo[p][pAbilStat][abilityId] = 8;
	else if(PlayerInfo[p][pAbility][abilityId] >= 60000 && PlayerInfo[p][pAbility][abilityId] <= 79999 && PlayerInfo[p][pAbilStat][abilityId] <= 8) yes = 1, PlayerInfo[p][pAbilStat][abilityId] = 9;
	else if(PlayerInfo[p][pAbility][abilityId] >= 80000 && PlayerInfo[p][pAbilStat][abilityId] <= 9) yes = 1;
 	if(yes == 1)
 	{
 		if(OnlineInfo[p][oListenRadioPears] == 0) PlayAudioStreamForPlayer(p, "https://pears-test.ru/sound/upskill.mp3");

		new string[140];
 		if(PlayerInfo[p][pAbility][abilityId] >= 80000 && PlayerInfo[p][pAbilStat][abilityId] <= 9)
 		{
 			PlayerInfo[p][pAbilStat][abilityId] = 10;
 			format(string,sizeof(string),"{0088ff}[ Навык ]: {99ff66}%s максимальный! Вы лучший в своём деле! {ff9000}[ 10 ]", abilityName[abilityId]);
			SendClientMessage(p, COLOR_GREY, string);
			format(string,sizeof(string),"{99ff66}%s максимальный! Вы лучший в своём деле!", abilityName[abilityId]);
			SuccessMessage(p, string);
		}
		else
		{
		    format(string,sizeof(string),"{0088ff}[ Навык ]: {ffcc66}%s повышен! {ff9000}[ %d ] {cccccc}[ Y >> Меню >> Навыки ]", abilityName[abilityId], PlayerInfo[p][pAbilStat][abilityId]);
			SendClientMessage(p, COLOR_GREY, string);
			format(string,sizeof(string),"{ffcc66}%s повышен! {ff9000}[ %d ] {cccccc}[ Y >> Меню >> Навыки ]", abilityName[abilityId], PlayerInfo[p][pAbilStat][abilityId]);
			SuccessMessage(p, string);
		}
		new fpick, fpara, thingType;
		AbilityGiveGift(p, abilityId, PlayerInfo[p][pAbilStat][abilityId], fpick, fpara, thingType);
		if(fpick > 0)
		{
			if(!CheckInvent(p))
			{
			    new plit = GiveThingPlayer(p, fpick, 1, fpara, 0, thingType, 0, 9999); // Выдаём предмет игроку
				SendClientMessage(p, COLOR_GREY, "{0088ff}[ Навык ]: {ffcc66}Проверьте инвентарь, вы получили подарок!");
				SaveInvent(p, plit);
			}
			else Throw(p, fpick, 1, fpara, 0, thingType, 0), SendClientMessage(p, COLOR_GREY, "{0088ff}[ Навык ]: {ffcc66}Вы получили подарок [В инвентаре нет места, подарок упал на землю]");
		}
 	}
 	mysql_save_ability(p, abilityId);
}
stock getskill_level(Float:skillType)
{
	new point;
	if(skillType <= 99) point = 0;
	else if(skillType >= 100 && skillType <= 499) point = 1;
	else if(skillType >= 500 && skillType <= 999) point = 2;
	else if(skillType >= 1000 && skillType <= 4999) point = 3;
	else if(skillType >= 5000 && skillType <= 9999) point = 4;
	else if(skillType >= 10000 && skillType <= 14999) point = 5;
	else if(skillType >= 15000 && skillType <= 19999) point = 6;
	else if(skillType >= 20000 && skillType <= 29999) point = 7;
	else if(skillType >= 30000 && skillType <= 49999) point = 8;
	else if(skillType >= 50000 && skillType <= 99999) point = 9;
	else if(skillType >= 100000) point = 10;
	return point;
}
stock getskill_max(Float:skillType)
{
    new point;
	if(skillType <= 99) point = 100;
	else if(skillType >= 100 && skillType <= 499) point = 500;
	else if(skillType >= 500 && skillType <= 999) point = 1000;
	else if(skillType >= 1000 && skillType <= 4999) point = 5000;
	else if(skillType >= 5000 && skillType <= 9999) point = 10000;
	else if(skillType >= 10000 && skillType <= 14999) point = 15000;
	else if(skillType >= 15000 && skillType <= 19999) point = 20000;
	else if(skillType >= 20000 && skillType <= 29999) point = 30000;
	else if(skillType >= 30000 && skillType <= 49999) point = 50000;
	else if(skillType >= 50000 && skillType <= 99999) point = 100000;
	else if(skillType >= 100000) point = 0;
	return point;
}
stock getpower_max(skillType)
{
    new point;
	if(skillType <= 199) point = 200;
	else if(skillType >= 200 && skillType <= 499) point = 500;
	else if(skillType >= 500 && skillType <= 999) point = 1000;
	else if(skillType >= 1000 && skillType <= 1999) point = 2000;
	else if(skillType >= 2000 && skillType <= 2999) point = 3000;
	else if(skillType >= 3000 && skillType <= 4999) point = 5000;
	else if(skillType >= 5000 && skillType <= 9999) point = 10000;
	else if(skillType >= 10000 && skillType <= 14999) point = 15000;
	else if(skillType >= 15000 && skillType <= 19999) point = 20000;
	else if(skillType >= 20000) point = 20000;
	return point;
}
stock GetLanguageProcess(languageId)
{
	new ata;
    switch(languageId)
	{
		case 0: ata = 0;
		case 1: ata = 100;
		case 2..10: ata = languageId*10-10;
		default: ata = 0;
	}
	return ata;
}
stock ShowSkill(playerid, targetid)
{
    new str[94],sctring[2016],lol[56];
    DP[0][playerid] = targetid;
    format(str,sizeof(str),"Навык \t Уровень [Очки] \t Звание"), strcat(sctring,str);
    format(str,sizeof(str),"\n{ff9000}Вождение Автомобилей \t {ffcc66}%d [%.0f] \t %s\n",getskill_level(PlayerInfo[targetid][pCarLic]),PlayerInfo[targetid][pCarLic],skillLevelName[getskill_level(PlayerInfo[targetid][pCarLic])]), strcat(sctring,str);
    format(str,sizeof(str),"\n{ff9000}Пилотирование Вертолётов \t {ffcc66}%d [%.0f] \t %s\n",getskill_level(PlayerInfo[targetid][pHeliLic]),PlayerInfo[targetid][pHeliLic],skillLevelName[getskill_level(PlayerInfo[targetid][pHeliLic])]), strcat(sctring,str);
    format(str,sizeof(str),"\n{ff9000}Пилотирование Самолётов \t {ffcc66}%d [%.0f] \t %s\n",getskill_level(PlayerInfo[targetid][pFlyLic]),PlayerInfo[targetid][pFlyLic],skillLevelName[getskill_level(PlayerInfo[targetid][pFlyLic])]), strcat(sctring,str);
    format(str,sizeof(str),"\n{ff9000}Вождение Катеров \t {ffcc66}%d [%.0f] \t %s \t\n",getskill_level(PlayerInfo[targetid][pBoatLic]),PlayerInfo[targetid][pBoatLic],skillLevelName[getskill_level(PlayerInfo[targetid][pBoatLic])]), strcat(sctring,str);
    format(str,sizeof(str),"\n{ff9000}Вождение Мототранспорта \t {ffcc66}%d [%.0f] \t %s\n",getskill_level(PlayerInfo[targetid][pMotoLic]),PlayerInfo[targetid][pMotoLic],skillLevelName[getskill_level(PlayerInfo[targetid][pMotoLic])]), strcat(sctring,str);
    format(str,sizeof(str),"\n{ff9000}Сила \t {ffcc66}%d [%d] \t \n",get_power(targetid),PlayerInfo[targetid][pBoxSkill]), strcat(sctring,str);
    for(new i = 0; i < MAX_ABILITY; i++)
    {
        format(str,sizeof(str),"\n{ff9000}%s \t {ffcc66}%d [%d] \t \n",abilityName[i],get_ability(targetid, i),PlayerInfo[targetid][pAbility][i]), strcat(sctring,str);
    }
    
    new ata = GetLanguageProcess(PlayerInfo[targetid][pRusk]);
    new bta = GetLanguageProcess(PlayerInfo[targetid][pYapon]);
    new cta = GetLanguageProcess(PlayerInfo[targetid][pItaly]);
    new dta = GetLanguageProcess(PlayerInfo[targetid][pKitai]);
    new eta = GetLanguageProcess(PlayerInfo[targetid][pIspan]);
    new gta = GetLanguageProcess(PlayerInfo[targetid][pArab]);
    if(ata > 0) format(str,sizeof(str),"\n{ffffff}Русский Язык \t {66ff99}%d проц. \t \n",ata), strcat(sctring,str);
    if(bta > 0) format(str,sizeof(str),"\n{ffffff}Японский Язык \t {66ff99}%d проц. \t \n",bta), strcat(sctring,str);
    if(cta > 0) format(str,sizeof(str),"\n{ffffff}Итальянский Язык \t {66ff99}%d проц. \t \n",cta), strcat(sctring,str);
    if(dta > 0) format(str,sizeof(str),"\n{ffffff}Китайский Язык \t {66ff99}%d проц. \t \n",dta), strcat(sctring,str);
    if(eta > 0) format(str,sizeof(str),"\n{ffffff}Испанский Язык \t {66ff99}%d проц. \t \n",eta), strcat(sctring,str);
    if(gta > 0) format(str,sizeof(str),"\n{ffffff}Арабский Язык \t {66ff99}%d проц. \t \n",gta), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}Количество Смертей \t {cccccc}%d \t \n",PlayerInfo[targetid][pDeaths]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}Количество Убийств \t {cccccc}%d \t \n",PlayerInfo[targetid][pKills]), strcat(sctring,str);
    
	format(lol,sizeof(lol),"{ff9000}Навыки %s",playername(targetid));
	ShowDialog(playerid,1276,DIALOG_STYLE_TABLIST_HEADERS,lol,sctring,"Выбрать","Выход");
	return 1;
}
stock AbilityGiveGift(p, abilityID, abilityStat, &fpick, &fpara, &thingType) // Подбираем подарок для навыка
{
    thingType = 2;
    if(abilityID == 0) // Навык Рыбака
	{
	    switch(abilityStat)
	    {
			case 2: fpick = 18632, fpara = 1; // Удочка
			case 3: fpick = 2484, fpara = 1; // Игрушка
			case 4: fpick = 2782, fpara = 1; // Ракушка
			case 5: // Рыбки
			{
			    switch(random(2))
        		{
					case 0: fpick = 1599, fpara = 1; // Жёлтая
					case 1: fpick = 1600, fpara = 1; // Синяя
				}
			}
			case 6: fpick = 902, fpara = 1; // Морская Звезда
			case 7: fpick = 19085, fpara = 0; // Повязка на Глаз
			case 8: // Сёрфы
			{
				switch(random(3))
        		{
					case 0: fpick = 2404, fpara = 1;
					case 1: fpick = 2405, fpara = 1;
					case 2: fpick = 2406, fpara = 1;
				}
			}
			case 9: fpick = 19079, fpara = 1; // Попугай
	        case 10: // Одежда
	        {
	        	if(PlayerInfo[p][pSex] == 1) fpick = 35, fpara = 0; // Муж
   				else fpick = 216, fpara = 0; // Жен
   				thingType = 3;
	        }
     	}
	}
	else if(abilityID == 1)
	{
	    switch(abilityStat)
	    {
	        case 2: fpick = 1010, fpara = 1; // Кислородный баллон
			case 3: fpick = 3070, fpara = 0; // Очки ночного видения 3070
			case 4: fpick = 2977, fpara = 1; // Box с материалом на спине 2977
			case 5: fpick = 3791, fpara = 1; // Бокс с антенной на спину 3791
			case 6: fpick = 2976, fpara = 1; // Зелёная жижа 2976
			case 7: fpick = 2238, fpara = 1; // Лава лампа 2238
			case 8: fpick = 2511, fpara = 1; // Самолётик 2511
			case 9: fpick = 18846, fpara = 0; // Летающая тарелка 18846
	        case 10: // Одежда
	        {
	        	if(PlayerInfo[p][pSex] == 1) fpick = 165, fpara = 0; // Муж
   				else fpick = 141, fpara = 0; // Жен
   				thingType = 3;
	        }
     	}
	}
    else if(abilityID == 2) // Навык Сексуальности
	{
	    switch(abilityStat)
	    {
	        case 2: fpick = 19086, fpara = 1; // Фаллос Бензопила
			case 3: fpick = 30010, fpara = 0; // Фаллоимитатор Оружие
			case 4: // Яйцо на плече
			{
				switch(random(5))
        		{
					case 0: fpick = 19341, fpara = 1;
					case 1: fpick = 19342, fpara = 1;
					case 2: fpick = 19343, fpara = 1;
					case 3: fpick = 19344, fpara = 1;
					case 4: fpick = 19345, fpara = 1;
				}
			}
			case 5: fpick = 7392, fpara = 1; // Ногатёлка на спине (Мадама)
			case 6: fpick = 19163, fpara = 0; // Кожаная маска
			case 7: fpick = 1240, fpara = 1; // Сердечко на груди
			case 8: fpick = 14666, fpara = 1; // Фалоиммитаторы на спину
			case 9: fpick = 7093, fpara = 1; // Сердечко на спину
	        case 10: // Одежда
	        {
	        	if(PlayerInfo[p][pSex] == 1) fpick = 249, fpara = 0; // Муж
   				else fpick = 178, fpara = 0; // Жен
   				thingType = 3;
	        }
     	}
	}
	else if(abilityID == 3 || abilityID == 8) // Навык Инженера, Автомеханика
	{
	    switch(abilityStat)
	    {
	        case 2: fpick = 19627, fpara = 1; // Гаечный Ключ на Спину
			case 3: fpick = 19622, fpara = 1; // Швабра на спину
			case 4: fpick = 19631, fpara = 1; // Кувалда на Спину
			case 5: fpick = 19904, fpara = 1; // Желетка
			case 6: fpick = 18633, fpara = 1; // Баллонный Ключ на спину
			case 7: fpick = 18634, fpara = 1; // Монтировка на Спину
			case 8: fpick = 18635, fpara = 1; // Обычный Молоток на спину
			case 9: fpick = 19160, fpara = 0; // Каска на голову +
	        case 10: // Одежда
	        {
	        	if(PlayerInfo[p][pSex] == 1) fpick = 42, fpara = 0; // Муж
   				else fpick = 193, fpara = 0; // Жен
   				thingType = 3;
	        }
     	}
	}
	else if(abilityID == 4) // Навык Охотника
	{
	    switch(abilityStat)
	    {
	        case 2: fpick = 804, fpara = 0; // Кустик
			case 3: fpick = 1828, fpara = 1; // Тигренок
			case 4: fpick = 19314, fpara = 0; // Рога
			case 5: fpick = 2061, fpara = 1; // Гильзы
			case 6: fpick = 650, fpara = 1; // Кактус
			case 7: fpick = 2806, fpara = 1; // Мяско
			case 8: fpick = 19559, fpara = 1; // Рюкзак
			case 9: fpick = 2045, fpara = 1; // Бита с шипами
	        case 10: // Одежда
	        {
	        	if(PlayerInfo[p][pSex] == 1) fpick = 128, fpara = 0; // Муж
   				else fpick = 131, fpara = 0; // Жен
   				thingType = 3;
	        }
     	}
	}
	else if(abilityID == 5) // Навык Фермера
	{
	    switch(abilityStat)
	    {
	        case 2: fpick = 18890, fpara = 1; // Грабли
	        case 3: fpick = 19578, fpara = 1; // Бананчик
	        case 4: fpick = 19468, fpara = 0; // Ведро
	        case 5: fpick = 19094, fpara = 0; // Шапка Бургер +
	        case 6: fpick = 19569, fpara = 1; // Молочко
	        case 7: fpick = 19320, fpara = 0; // Тыковка +
	        case 8: fpick = 2590, fpara = 1; // Коса +
	        case 9: fpick = 19553, fpara = 0; // Шляпа +
	        case 10: // Одежда
	        {
	        	if(PlayerInfo[p][pSex] == 1) fpick = 162 + 20100, fpara = 0; // Муж
   				else fpick = 157 + 20100, fpara = 0; // Жен
   				thingType = 3;
	        }
     	}
	}
	return 1;
}
stock get_ability(p, a) // Узнаём навык
{
	new pow;
	if(PlayerInfo[p][pAbility][a] >= 1000 && PlayerInfo[p][pAbility][a] <= 4999) pow = 2;
	else if(PlayerInfo[p][pAbility][a] >= 5000 && PlayerInfo[p][pAbility][a] <= 9999) pow = 3;
	else if(PlayerInfo[p][pAbility][a] >= 10000 && PlayerInfo[p][pAbility][a] <= 14999) pow = 4;
	else if(PlayerInfo[p][pAbility][a] >= 15000 && PlayerInfo[p][pAbility][a] <= 19999) pow = 5;
	else if(PlayerInfo[p][pAbility][a] >= 20000 && PlayerInfo[p][pAbility][a] <= 29999) pow = 6;
	else if(PlayerInfo[p][pAbility][a] >= 30000 && PlayerInfo[p][pAbility][a] <= 39999) pow = 7;
	else if(PlayerInfo[p][pAbility][a] >= 40000 && PlayerInfo[p][pAbility][a] <= 59999) pow = 8;
	else if(PlayerInfo[p][pAbility][a] >= 60000 && PlayerInfo[p][pAbility][a] <= 79999) pow = 9;
	else if(PlayerInfo[p][pAbility][a] >= 80000) pow = 10;
	else pow = 1;
	return pow;
}
stock getability_max(abilityType) // Узнаём сколько нужно на следующий уровень
{
	new pow;
	if(abilityType<=999)  pow = 1000;
	else if(abilityType >= 1000 && abilityType <= 4999) pow = 5000;
	else if(abilityType >= 5000 && abilityType <= 9999) pow = 10000;
	else if(abilityType >= 10000 && abilityType <= 14999) pow = 15000;
	else if(abilityType >= 15000 && abilityType <= 19999) pow = 20000;
	else if(abilityType >= 20000 && abilityType <= 29999) pow = 30000;
	else if(abilityType >= 30000 && abilityType <= 39999) pow = 40000;
	else if(abilityType >= 40000 && abilityType <= 59999) pow = 60000;
	else if(abilityType >= 60000 && abilityType <= 79999) pow = 80000;
	else if(abilityType >= 80000) pow = 80000;
	return pow;
}
stock getAbilityRealProgress(level) // Узнаем сколько нужно прогресса на слещующий уровень навыка в зависимости от левела
{
	new realProgress;
	if(level <= 1) realProgress = 0;
	else if(level == 2) realProgress = 1000;
	else if(level == 3) realProgress = 5000;
	else if(level == 4) realProgress = 10000;
	else if(level == 5) realProgress = 15000;
	else if(level == 6) realProgress = 20000;
	else if(level == 7) realProgress = 30000;
	else if(level == 8) realProgress = 40000;
	else if(level == 9) realProgress = 60000;
	else realProgress = 80000;
	return realProgress;
}

function Call_setability(playerid, stat, amount, str_name[])
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new datadid, string_mysql[120];
		cache_get_value_name_int(0, "user_id", datadid);
		if(stat == 3)
		{
			format(string_mysql, sizeof(string_mysql),"UPDATE `pp_igroki` SET `Voennik` = '%d', `AbilStat2`='%d' WHERE `user_id` = '%d'", getAbilityRealProgress(amount), amount, datadid);
			query_empty(pearsq, string_mysql);
		}
		else
		{
			format(string_mysql, sizeof(string_mysql),"UPDATE `pp_igroki` SET `Ability%d` = '%d',`AbilStat%d`='%d' WHERE `user_id` = '%d'", stat, getAbilityRealProgress(amount), stat, amount, datadid);
			query_empty(pearsq, string_mysql);
		}
		format(string_mysql, sizeof(string_mysql), "Вы изменили %s на %d уровень игроку %s Offline", abilityName[stat], amount, str_name);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string_mysql);

		AdminLog("setability", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], datadid, str_name, "", amount, abilityName[stat]);
	}
	else ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
	return 1;
}
CMD:setability(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    new tmp[24],giveplayerid,stat,amount;
    if (sscanf(params, "s[24]ii", tmp,stat,amount))
	{
	    SendClientMessage(playerid, COLOR_GREY, "Изменить навык: /setability ID [номер навыка] [уровень]");

		// Формируем подсказку
		new row, quan;
		new line[214],lines[2000];

		for(new i = 0; i < MAX_ABILITY; i++)
		{
			row ++;
			quan ++;
			format(line,sizeof(line),"%d %s | ", i, abilityName[i]), strcat(lines,line);
			if(row == 3 || quan == MAX_ABILITY)
			{
				row = 0;
				SendClientMessage(playerid, COLOR_GREY, lines);
				format(lines,sizeof(lines),"");
			}
		}
		return 1;
	}
	if(stat < 0 || stat >= MAX_ABILITY) return ErrorMessage(playerid, "{FF6347}Неверный id навыка");
	if(amount <= 0 || amount > 10) return ErrorMessage(playerid, "{FF6347}Уровень навыка не меньше 1 и не больше 10");

 	giveplayerid = ReturnUser(tmp, 1);
	if(!IsPlayerConnected(giveplayerid))
	{
		if(!CheckRP_Nickname(tmp)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");

		new string_mysql[80];
		format(string_mysql,sizeof(string_mysql),"SELECT * FROM `pp_igroki` WHERE `Name` = '%s'", tmp);
		mysql_tquery(pearsq, string_mysql, "Call_setability", "ddds", playerid, stat, amount, tmp);
		return 1;
	}
	PlayerInfo[giveplayerid][pAbility][stat] = getAbilityRealProgress(amount);
	update_ability(giveplayerid, stat, 1);

	new string[80];
	format(string, sizeof(string), "Вы изменили %s на %d уровень игроку %s", abilityName[stat], amount, PlayerInfo[giveplayerid][pName]);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);

	AdminLog("setability", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], amount, abilityName[stat]);
	return 1;
}

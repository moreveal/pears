
stock ProcessHealthPlayer(playerid)
{
	OnlineInfo[playerid][oHealthTime] --;

	if(OnlineInfo[playerid][oHealthTime] == 0 // Время вышло
		&& DeathInfo[playerid][deathStatus] == false // Чувак не в процессе смерти
		&& HealthAC[playerid] > 0.0) // ХП имеется, значит не умер
	{
		new bool:yesHealth;
		if(OnlineInfo[playerid][oHealthInva] != 999) // Знаем слот предмета
		{
            new inva = OnlineInfo[playerid][oHealthInva];
			if(PlayerInfo[playerid][pInven][inva] == OnlineInfo[playerid][oHealthThing]) // Тот самый предмет
            {
			    TakeInvent(playerid, OnlineInfo[playerid][oHealthThing], 1, 0, inva); // Отнимаем
                yesHealth = true; // Можно лечить
            }
		}
        else // Не знаем слот, значит удаляем в поиске
        {
            new result = TakeInvent(playerid, OnlineInfo[playerid][oHealthThing], 1, 0, 999);
            if(result >= 0) yesHealth = true; // Можно лечить
        }

		if(yesHealth == true)
		{
			ACSetPlayerHealth(playerid, HealthAC[playerid] + OnlineInfo[playerid][oHealthMed]); // Пополняем хп
			new string[20];
			format(string, sizeof string, "+%.1f HP", OnlineInfo[playerid][oHealthMed]);
			SetPlayerChatBubble(playerid, string, COLOR_GREEN, 45.0, 4000);

            // Если лечим бинтами
            if(OnlineInfo[playerid][oHealthThing] == 70)
            {
                ResetHeal(playerid);

                if(IsAZoneCapt(playerid))
                {
                    new org = fraction(playerid);
                    if(CaptInfo[cAttack] == org) CaptInfo[cLogMedA] ++;
                    if(CaptInfo[cDefend] == org) CaptInfo[cLogMedD] ++;
                    PlayerInfo[playerid][pGangTemp][6] ++;
                }
            }

            //  Лечим порошком
            else if(OnlineInfo[playerid][oHealthThing] == 7 || OnlineInfo[playerid][oHealthThing] == 263 || OnlineInfo[playerid][oHealthThing] == 264)
            {
                // Старая система кровотечения off
                PlayerInfo[playerid][pRanentors] = 0;
                TextDrawHideForPlayer(playerid, PearsDraw[0]);

                Effect[playerid] = 4;
                EffectTime[playerid] += 30;
                PearsWeather(playerid), PearsTime(playerid);
                if(IsAZoneCapt(playerid))
                {
                    new org = fraction(playerid);
                    if(CaptInfo[cAttack] == org) CaptInfo[cLogDrugA][3] ++;
                    if(CaptInfo[cDefend] == org) CaptInfo[cLogDrugD][3] ++;
                    PlayerInfo[playerid][pGangTemp][10] ++;
                }
                infect(playerid, 9, 1);
            }
		}
	}
	return 1;
}

stock HealthPlayer(playerid, time, Float:health, inva, thingId) // Лечим
{
    if(OnlineInfo[playerid][oHealthTime] > 0) return 0;

	OnlineInfo[playerid][oHealthTime] = time; // Время через которое игроку повысится хп
	OnlineInfo[playerid][oHealthMed] = health; // Сколько хп повысится
	OnlineInfo[playerid][oHealthInva] = inva; // Слот предмета
    OnlineInfo[playerid][oHealthThing] = thingId; // ID предмета
	return 1;
}

function ResetHeal(playerid)
{
    if (!IsOnline(playerid)) return false;
    
    // Старая система кровотечения off
    PlayerInfo[playerid][pRanentors] = 0;
    TextDrawHideForPlayer(playerid, PearsDraw[0]);

    // Все эффекты off
    Effect[playerid] = 0;
    EffectTime[playerid] = 0;
    SetPlayerDrunkLevel(playerid, 0);

    // Погоду и время сбрасываем (Вдруг были эффекты)
    PearsWeather(playerid), PearsTime(playerid);

    PoliceStick[0][playerid] = 0; // Количества ударов тупым предметом сбрасываем
    return true;
}

CMD:suncreen(playerid, const params[])
{
    if(Hold[playerid] >= 1 || Hand[playerid] >= 1 || GetPlayerWeapon(playerid) >= WEAPON:2) return ErrorMessage(playerid, "{FF6347}У вас заняты руки [Предмет или оружие]");
    if(howstun(playerid) || HealthAC[playerid] <= 0) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо и он не может сейчас это сделать");
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return ErrorMessage(playerid, "{FF6347}Ваш персонаж должен быть пешечком");
    if(MPGO[playerid] != 0) return ErrorMessage(playerid, "{FF6347}Вы на мероприятии");

	if(PlayerInfo[playerid][pSunScreen] > 0)
    {
        new string[120];
        format(string, sizeof(string), "{FF6347}Вы всё ещё намазаны кремушком\n{cccccc}Повторно намазюкаться можно через %s", fine_time(PlayerInfo[playerid][pSunScreen]));
        ErrorMessage(playerid, string);
        return true;
    }

    if(sscanf(params, "i", params[0]))
	{
		if(get_invent4(playerid, 230, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет солнцезащитного крема");
        TakeInvent(playerid, 230, 1, 0, 999);
	}
	else 
	{
        if(params[0] < 0 || params[0] > 39) return 1;
		if(PlayerInfo[playerid][pInven][params[0]] != 230) return ErrorMessage(playerid, "{FF6347}Ошибка! В этом слоте инвентаря нет солнцезащитного крема");
        TakeInvent(playerid, 230, 1, 0, params[0]);
    }

    ApplyAnimation(playerid,"OTB","betslp_loop",4.0, false, true, true, false, false, SYNC_ALL);
	if(PlayerInfo[playerid][pSex] == 1) 
    {
        SetPlayerChatBubble(playerid,"намазался солнцезащитным кремом",COLOR_PURPLE,35.0,10000);
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я намазался кремушком (Время действия 2 часа)");
    }
    else 
    {
        SetPlayerChatBubble(playerid,"намазалась солнцезащитным кремом",COLOR_PURPLE,35.0,10000);
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я намазалась кремушком (Время действия 2 часа)");
    }
    PlayerInfo[playerid][pSunScreen] = 7200;
    SuccessMessage(playerid, "{99ff66}Вы намазались солнцезащитным кремом\n{ffcc66}Время действия: 2 часа\n\n{684F7D}Если вы вампир, то в течении этого времени вы не будете гореть на солнце");

    // Если вампир горел, выключаем горение
    if(vampire[playerid] == 1) burn_vampire(playerid, 0);
	return 1;
}

stock ProcessSunScreen(playerid)
{
    PlayerInfo[playerid][pSunScreen] --;
    if(PlayerInfo[playerid][pSunScreen] == 0)
    {
        if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) burn_vampire(playerid, 1);
    }
    return true;
}


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

            // Старая система кровотечения off
            PlayerInfo[playerid][pRanentors] = 0;
            TextDrawHideForPlayer(playerid, PearsDraw[0]);

            if(OnlineInfo[playerid][oHealthThing] == 70) // Только если лечим бинтами
            {
                // Все эффекты off
                Effect[playerid] = 0;
                EffectTime[playerid] = 0;
                SetPlayerDrunkLevel(playerid, 0);

                // Погоду и время сбрасываем (Вдруг были эффекты)
                PearsWeather(playerid), PearsTime(playerid);

                PoliceStick[0][playerid] = 0; // Количества ударов тупым предметом сбрасываем
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

stock IsNormalArestType(e_ArestType: type) { return (_:type > 0 && _:type < 2); }

// Может ли игрок быть арестован полицейским в текущий момент
stock IsPlayerCanBeArrested(playerid) {
	return !( // Не
		MPGO[playerid] > 0 // Находится на мероприятии
		|| computerClubPlayerInfo[playerid][ccpiInGame] // Находится в компьютерном клубе
		|| (bespilot[playerid] != 0 || GetTickCount() - bespilotejecttick[playerid] < 1000) // Управляет беспилотником
		|| PlayerInfo[playerid][pJailed] > 0 // Находится в заключении
	);
}

stock ArestPlayer(suspectid, copid, e_ArestType: type)
{
	// Не производим арест, если у игрока нет розыска, или он уже в заключении, или он на мероприятии
	if (PlayerInfo[suspectid][pCrimes] <= 0 || PlayerInfo[suspectid][pJailed] > 0 || MPGO[suspectid] != 0) return 1;

	new string[144];
	Stun[4][suspectid] = 0, StunTime[4][suspectid] = 0, CuffedId[suspectid] = 9999; // Наручники
	if(FollowTime[suspectid] == 0) StopFollow(suspectid); // Прекращение следования за собой
	new tar;
	if(IsNormalArestType(type)) RemovePlayerFromVehicle(suspectid);
	if(DeathInfo[suspectid][deathStatus]) ACSetPlayerHealth(suspectid, GetMaxPlayerHealth(suspectid)); // Выводим из стадии

	// Арест Игрока
	if(PlayerInfo[suspectid][pFbi] == 0)
	{
		// Временное лишение оружия
		TempTake(suspectid, 0);

		// Отключаем преследование
		DestroyPursuit(suspectid);

		new e_CityArea: cityPlayer = e_CityArea: GetPlayerCityArea(suspectid);
		if(cityPlayer == CITY_AREA_LOS_SANTOS) PlayerInfo[suspectid][pJailed] = 3; // КПЗ LS
		else if(cityPlayer == CITY_AREA_SAN_FIERRO) PlayerInfo[suspectid][pJailed] = 9; // КПЗ SF
		else PlayerInfo[suspectid][pJailed] = 1; // Областная Тюрьма

		if(type == AREST_TYPE_QUIT || type == AREST_TYPE_AFK) PlayerInfo[suspectid][pJailTime] = PlayerInfo[suspectid][pCrimes] * (15 * 60); // Вышел из игры при аресте
		else {
			if(type == AREST_TYPE_KILL) { // Арест при смерти (добили в стадии)
                PlayerInfo[suspectid][pJailTime] = PlayerInfo[suspectid][pCrimes] * (10 * 60);
                PlayerInfo[suspectid][pJailed] = 1;
            } else PlayerInfo[suspectid][pJailTime] = PlayerInfo[suspectid][pCrimes] * (7 * 60);
		}

		if (copid < 0) SendClientMessage(suspectid, COLOR_LIGHTRED, "* Вы были арестованы !");
		else
		{
			format(string, sizeof(string), "%s apec¦oўaћ ўac", rpplayername(copid)), GameTextForPlayer(suspectid, string, 8000, 5);
			SendClientMessage(suspectid, COLOR_LIGHTRED, "* Вы были арестованы %s!", playername(copid));
		}
		SendClientMessage(suspectid, COLOR_LIGHTRED, "* Вас отправили в Областную Тюрьму Штата San Andreas [ Осталось: %s ]", fine_time(PlayerInfo[suspectid][pJailTime]));
		if (IsNormalArestType(type) || type == AREST_TYPE_AFK) PPSpawnPlayer(suspectid);

		// Оповещение Полицейскому
		if(copid >= 0)
		{
			new org = fraction(copid);
			if(type == AREST_TYPE_QUIT) SendClientMessage(copid, COLOR_LIGHTBLUE, "* %s вышел из игры и был арестован на %d минут!", rpplayername(suspectid), PlayerInfo[suspectid][pJailTime] / 60);
			else if(type == AREST_TYPE_AFK) SendClientMessage(copid, COLOR_LIGHTBLUE, "* %s суммарно находился в AFK более 5-ти минут и был арестован на %d минут!", rpplayername(suspectid), PlayerInfo[suspectid][pJailTime] / 60);
			else SendClientMessage(copid, COLOR_LIGHTBLUE, "* %s арестован на %d минут!", rpplayername(suspectid), PlayerInfo[suspectid][pJailTime]/60);
			PlayerPlaySound(copid, 1058, 0,0,0);
			if(PlayerInfo[copid][pSex] == 1) format(string, sizeof(string), "арестовал %s", rpplayername(suspectid));
			else format(string, sizeof(string), "арестовала %s", rpplayername(suspectid));
			SetPlayerChatBubble(copid,string,COLOR_PURPLE,20.0,8000);
			if(IsNormalArestType(type)) tar = 2;
			else tar = 3;
			GiveUnit(copid, tar);

			strmid(PlayerInfo[suspectid][pVictim], PlayerInfo[copid][pName], 0, strlen(PlayerInfo[copid][pName]), 24);
			static const arest_type[][] = {"Арест RP", "Арест из транспорта", "Арест убийство", "Арест смерть", "Арест выход из игры", "Арест AFK", "Арест на зачистке"};
			OrgLog(org, "arest", PlayerInfo[copid][pID], PlayerInfo[copid][pName], PlayerInfo[copid][pPlaIP], PlayerInfo[suspectid][pID], PlayerInfo[suspectid][pName], PlayerInfo[suspectid][pPlaIP], PlayerInfo[suspectid][pJailTime], arest_type[type]);

			if(PlayerInfo[copid][pAchieve][71] == 0 && IsNormalArestType(type)) AchievePlayer(copid, 71, 1);

			// Арест Убийством
			if(type == AREST_TYPE_KILL)
			{
				SetPVarInt(suspectid, "CopHit", copid);
				if(PlayerInfo[suspectid][pCrimes] >= 6) SendClientMessage(suspectid, COLOR_LIGHTRED, "* Вы являлись опасным преступником и потому представитель закона имел право открыть огонь на поражение");

				format(string, sizeof(string), "{cccccc}Вас убил представитель закона {0066ff}%s\n{cccccc}Хотите заказать его киллеру?\nЦена заказа {99ff66}$5000", rpplayername(copid));
				ShowDialog(suspectid, 163, DIALOG_STYLE_MSGBOX, "Заказ", string, "Да", "Нет");
			}
		}
		PPSpawnPlayer(suspectid);
	}
	else
	{
		SendClientMessage(suspectid, COLOR_LIGHTBLUE, "* Извините, мы не были осведомлены, что вы агент под прикрытием!");
		S_SetPlayerVirtualWorld(suspectid, 0, 0), PPSetPlayerInterior(suspectid, 0);
		PPSetPlayerPos(suspectid, 900.1669, 2392.2295, 10.8203), PPSetPlayerFacingAngle(suspectid, 270.0);
		ClearAllWantedPlayer(suspectid);
	}

	TogglePlayerControllable(suspectid, true);

	return 1;
}

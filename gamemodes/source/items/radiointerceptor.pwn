stock RadioInterceptor_IsStateEnabled(playerid, e_RadioInterceptorState: status)
{
	if (get_invent(playerid, 236, 0) <= 0) return 0; // Устройство отсутствует
	if (gettime() > get_para(playerid, 236)) {
		new price = floatround(float(getThingPriceGos(236, 0) / 2) * 1.05);
		if (PlayerInfo[playerid][pAccount] >= price) {
			oGivePlayerBank(playerid, -price);
			SendClientMessage(playerid, COLOR_YELLOW, " SMS от Хэнка: {99ff33}Решил вопрос с прошивкой твоего радиоперехватчика, можешь пользоваться!");

			new quan, para;
			ThingParameters(playerid, 236, quan, para);
			set_para(playerid, 236, para);
		}
		return 0; // Устройство устарело
	}

	return (OnlineInfo[playerid][oRadioInterceptorState] & _:status) != 0;
}

stock RadioInterceptor_ToggleState(playerid, e_RadioInterceptorState: status)
{
	OnlineInfo[playerid][oRadioInterceptorState] ^= _:status;
	return 1;
}

stock RadioInterceptor_GetStatesCount(playerid, bool: enabled = true)
{
	new count = 0;
    new status = OnlineInfo[playerid][oRadioInterceptorState];

    for (new i = 0; i < 3; i++)
    {
        count += _:(enabled ? (status & (1 << i)) != 0 : (status & (1 << i)) == 0);
    }

    return count;
}

stock RadioInterceptor_Disable(playerid)
{
	OnlineInfo[playerid][oRadioInterceptorState] = 0;
	return 1;
}

stock RadioInterceptor_Dialog_Main(playerid)
{
	RadioInterceptor_IsStateEnabled(playerid, RADIO_INTERCEPTOR_STATE_SU); // Тригерим обновление частоты (услуга Хэнка)
	if (gettime() > get_para(playerid, 236)) return ErrorMessage(playerid, "{FF6347}Нельзя использовать устройство [ Требуется настройка частоты ]");

	ShowDialog(playerid, RADIO_INTERCEPTOR_MAIN, DIALOG_STYLE_LIST, "{ff9000}Радиоперехватчик", 
		"{cccccc}Поиск местоположения\n" \
		"{cccccc}Перехват радиосообщений",

		"Выбор", "Закрыть"
	);
	return 1;
}

stock RadioInterceptor_Dialog_Find(playerid)
{
	new dialog_text[256];
	strcat(dialog_text, "{cccccc}Укажите ID полицейского, местоположение которого вы хотите перехватить:");
	if (OnlineInfo[playerid][oDialogID] == _:RADIO_INTERCEPTOR_FIND) strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}Местоположение этого игрока перехватить невозможно");

	ShowDialog(playerid, RADIO_INTERCEPTOR_FIND, DIALOG_STYLE_INPUT, "{ff9000}Узнать местоположение", dialog_text, "Выбор", "Назад");
	return 1;
}

stock RadioInterceptor_Dialog_SetStates(playerid)
{
	new dialog_text[512] = "{cccccc}Опция\t{cccccc}Статус\n";
	format(dialog_text, sizeof(dialog_text),
		"%s\n" \
	 	"{cccccc}Перехват выдачи розыска [ /su ]\t%s\n" \
		"{cccccc}Перехват начала преследования [ /pursuit ]\t%s\n" \
		"{cccccc}Перехват задержаний [ /cuff ]\t%s",
		
		dialog_text,
		RadioInterceptor_IsStateEnabled(playerid, RADIO_INTERCEPTOR_STATE_SU) ? "{99ff66}[ On ]" : "{ff6347}[ Off ]",
		RadioInterceptor_IsStateEnabled(playerid, RADIO_INTERCEPTOR_STATE_PURSUIT) ? "{99ff66}[ On ]" : "{ff6347}[ Off ]",
		RadioInterceptor_IsStateEnabled(playerid, RADIO_INTERCEPTOR_STATE_CUFF) ? "{99ff66}[ On ]" : "{ff6347}[ Off ]"
	);
	ShowDialog(playerid, RADIO_INTERCEPTOR_SETSTATES, DIALOG_STYLE_TABLIST_HEADERS, "{ff9000}Режим работы", dialog_text, "Выбор", "Назад");
	return 1;
}

stock RadioInterceptor_SendMessage(e_RadioInterceptorState: status, color, const text[], excludeid = -1)
{
	foreach (Player, i)
	{
		if(OnlineInfo[i][oLogged] == 0 || PlayerInfo[i][pBkyrenie] >= 2 || i == excludeid) continue;

		if (RadioInterceptor_IsStateEnabled(i, status))
		{
			SendClientMessage(i, color, text);
		}
	}
	return 1;
}

function RadioInterceptor_UpdateFindZone(player_userid, find_userid, bool: message)
{
	new playerid = -1, findid = -1;
	foreach (new id : Player)
	{
		if (PlayerInfo[id][pID] == player_userid) playerid = id;
		else if (PlayerInfo[id][pID] == find_userid) findid = id;

		if (playerid > -1 && findid > -1) break;
	}
	if (!IsOnline(playerid) || !IsOnline(findid) || OnlineInfo[playerid][oRadioInterceptorFindId] != findid) return 0;
	if (OnlineInfo[playerid][oRadioInterceptorZoneTimer] <= 1) return 0;
	
	new Float:X,Float:Y,Float:Z;
	GetPlayerRealPos(findid, X, Y, Z);

	if(X == 0.0 && Y == 0.0 && message) return ErrorMessage(playerid, "{FF6347}Спутники не могут зафиксировать его местоположение\n\n{cccccc}Игрок только зашёл на сервер и находится в неизвестной точке спавна");

	new Float:rand_x = 5 + random(30), Float:rand_y = 5 + random(30);
	switch(random(4))
	{
		case 0: X += rand_x, Y += rand_y;
		case 1: X -= rand_x, Y -= rand_y;
		case 2: X += rand_x, Y -= rand_y;
		case 3: X -= rand_x, Y += rand_y;
	}
	ShowFindZone(playerid, findid, X, Y, FindRaionPos(X, Y, Z), message);
	ZoneTimer[playerid] = OnlineInfo[playerid][oRadioInterceptorZoneTimer];
	FindCd[playerid] = 0;

	SetTimerEx("RadioInterceptor_UpdateFindZone", 40 * 1000, false, "ddd", player_userid, find_userid, 0);
	return 1;
}

stock dialogCase_RadioInterceptor(playerid, dialogid, response, listitem, const inputtext[])
{
	switch (e_DialogId: dialogid)
	{
		case RADIO_INTERCEPTOR_MAIN:
		{
			if (!response) return 1;
			
			if (listitem == 0) {
				if(ZoneTimer[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вас активна зона поиска, дождитесь её окончания");
				
				new unix = gettime();
				if(PlayerInfo[playerid][pRadioInterceptorFindCd] > unix) {
					new msg[128];
					format(msg, sizeof(msg), "{FF6347}Вы уже пользовались поиском местоположения, следующий раз возможен через: %s", fine_time(PlayerInfo[playerid][pRadioInterceptorFindCd] - unix));
					return ErrorMessage(playerid, msg);
				}
				return RadioInterceptor_Dialog_Find(playerid);
			}
			else if (listitem == 1) return RadioInterceptor_Dialog_SetStates(playerid);
		}
		case RADIO_INTERCEPTOR_FIND:
		{
			if (!response) return RadioInterceptor_Dialog_Main(playerid);

			new currentid;
			if (sscanf(inputtext, "u", currentid)
				|| !IsOnline(currentid) || (!IsPoliceMember(currentid) || fraction(currentid) == 2)
				|| currentid == playerid
				|| MPGO[currentid]) return RadioInterceptor_Dialog_Find(playerid);

			if(PlayerInfo[currentid][pBkyrenie] >= 2) return ErrorMessage(playerid, "{FF6347}Спутники не могут зафиксировать его местоположение\n\n{cccccc}Возможно, он участник экспедиции NASA");
			
			OnlineInfo[playerid][oRadioInterceptorZoneTimer] = 60 * 2;
			OnlineInfo[playerid][oRadioInterceptorFindId] = currentid;
			RadioInterceptor_UpdateFindZone(PlayerInfo[playerid][pID], PlayerInfo[currentid][pID], true);
			PlayerInfo[playerid][pRadioInterceptorFindCd] = gettime() + RADIO_INTERCEPTOR_FIND_COOLDOWN * 60;
  			SendClientMessage(playerid, COLOR_GREY, "{cccccc}[ Мысли ]: Местоположение будет обновляться каждые 40 секунд, пока поиск активен.");
		}
		case RADIO_INTERCEPTOR_SETSTATES:
		{
			if (!response) return RadioInterceptor_Dialog_Main(playerid);

			new e_RadioInterceptorState: status;
			switch (listitem)
			{
				case 0: status = RADIO_INTERCEPTOR_STATE_SU;
				case 1: status = RADIO_INTERCEPTOR_STATE_PURSUIT;
				case 2: status = RADIO_INTERCEPTOR_STATE_CUFF;
				default: return 1;
			}

			if (!RadioInterceptor_IsStateEnabled(playerid, status) && RadioInterceptor_GetStatesCount(playerid) >= 2) {
				ErrorText(playerid, "{FF6347}Одновременно можно использовать лишь две из опций радиоперехватчика");
			} else {
				RadioInterceptor_ToggleState(playerid, status);
			}

			RadioInterceptor_Dialog_SetStates(playerid);
		}
		default: return 0;
	}

	return 1;
}
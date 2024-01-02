
/*
Как добавить новые права доступа?
1. Плюсуем в MAX_BIZ_ACCESS
2. Добавляем название в new bizAccess
3. Добавляем в базу новые acc и accrank, если требуются
4. Используем GetAccessBizMay или GetAccessBiz (возвращает - 0 нет доступа, 1 есть доступ)

Как добавить новую настройку?
1. Плюсуем в MAX_BIZ_SETTING
2. Добавляем название в new bizSetting
3. Добавляем атрибут настройки (что отображается напротив названия) в GetSettingAttributionText
4. Добавляем в базу новую setting, если требуется
5. Изменяем по необходимости dialogid == 691 область: // Настройки и dialogid == 693
6. Используем переменную, где нам необходимо BizzInfo[b][bSetting][i]
*/

new bizAccess[][] =
{
	"Вывод средств", "Переименование бизнеса", "Управление ценниками", "Просмотр лога", // 0 - 3
	"Управление местоположением", "Доступ к меню", "Доступ к складу", "Редактор интерьера" // 4 - 7
};

new bizSetting[][] =
{
	"Вывод дохода", "Макс. сумма вывода дохода", "Интервал вывода дохода" // 0 - 3
};

stock GetAccessBizMay(playerid, b, accessId) // Результат доступа
{
	if(PlayerInfo[playerid][pBusiness] == b) return 1;
	if(BizzInfo[b][bFam] >= 1 && BizzInfo[b][bAcc][accessId] == 1)
	{
		if(PlayerInfo[playerid][pFamily] == BizzInfo[b][bFam] && PlayerInfo[playerid][pFamrank] >= BizzInfo[b][bAccRank][accessId]) return 1;
	}
	return 0;
}

stock GetAccessBiz(playerid, b, accessId) // Ответ с сообщением
{
	if(!GetAccessBizMay(playerid, b, accessId))
	{
		ErrorMessage(playerid, "{FF6347}Вам недоступна эта функция бизнеса\n\n{cccccc}Бизнес имеет настройки прав доступа для участников семьи");
		return 0;
	}
	return 1;
}

stock GetSettingAttributionText(settingId, result)
{
	new text[34];
	if(settingId == 0)
	{
		if(result == 0) text = "Личный счет";
		else if(result == 1) text = "Семейный счет";
	}
	else if(settingId == 1) format(text,sizeof(text),"{99ff66}%d$", result);
	else if(settingId == 2) format(text,sizeof(text),"{0088ff}%d мин.", result);
	return text;
}

CMD:bac(playerid)
{
	if(PlayerInfo[playerid][pBusiness] == 0) return ErrorMessage(playerid, "{FF6347}У вас нет собственного бизнеса");

	new b = PlayerInfo[playerid][pBusiness], quan;
	format(lines,sizeof(lines),""); // Очищаем Lines

	format(line,sizeof(line),"Настройка \t Значение"), strcat(lines,line);

	// Права доступа бизнеса
	for(new i; i < MAX_BIZ_ACCESS; ++ i)
	{
		if(BizzInfo[b][bFam] > 0 && BizzInfo[b][bAcc][i] == 1)
		{
			format(line,sizeof(line),"\n{cccccc}%s \t {ff9000}%d+ Fam Ранг", bizAccess[i],BizzInfo[b][bAccRank][0]), strcat(lines,line);
		}
		else  format(line,sizeof(line),"\n{cccccc}%s \t {99ff66}Владелец", bizAccess[i]), strcat(lines,line);

		List[quan][playerid] = i;
		ListParam[quan][playerid] = 0;
		quan ++;
	}

	// Настройки бизнеса
	for(new i; i < MAX_BIZ_SETTING; ++ i)
	{
		format(line,sizeof(line),"\n{ff9000}%s \t {cccccc}%s", bizSetting[i], GetSettingAttributionText(i, BizzInfo[b][bSetting][i])), strcat(lines,line);

		List[quan][playerid] = i;
		ListParam[quan][playerid] = 1;
		quan ++;
	}
	ShowDialog(playerid,691,DIALOG_STYLE_TABLIST_HEADERS,"{cccccc}Настройки {ff9000}Бизнеса",lines,"Выбрать","Отмена");
   	return 1;
}

stock showDialogBizAccess(playerid, b, i)
{
	DP[2][playerid] = i;
	format(lines,sizeof(lines),""); // Очищаем Lines

	format(line,sizeof(line),"%s \t ", bizAccess[i]), strcat(lines,line);

	if(BizzInfo[b][bAcc][i] == 0) format(line,sizeof(line),"\n{cccccc}Доступ: \t {99ff66}Владелец"), strcat(lines,line);
	else if(BizzInfo[b][bAcc][i] == 1) format(line,sizeof(line),"\n{cccccc}Доступ: \t {ffcc00}Владелец и Семья"), strcat(lines,line);
	else if(BizzInfo[b][bAcc][i] == 2) format(line,sizeof(line),"\n{cccccc}Доступ: \t {FF6347}Любой Гость"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Fam Ранг: \t {ff9000}%d+", BizzInfo[b][bAccRank][i]), strcat(lines,line);

	ShowDialog(playerid,692,DIALOG_STYLE_TABLIST_HEADERS,"{cccccc}Настройки {ff9000}Бизнеса",lines,"Выбрать","Назад");
	return 1;
}

stock bizsbrosprava(b)
{
	for(new i; i < MAX_BIZ_ACCESS; ++ i) BizzInfo[b][bAcc][i] = 0, BizzInfo[b][bAccRank][i] = MAX_RANK_FAMILY;

	BizzInfo[b][bSetting][0] = 0; // Вывод на личный счет (1 - это счёт семьи)
	BizzInfo[b][bSetting][1] = 10000000; // Максимальная сумма вывода за раз (10кк)
	BizzInfo[b][bSetting][2] = 0; // Интервал на вывод (0 минут)
	return 1;
}

stock dialogCase_AccessBiz(playerid, dialogid, response, listitem, const inputtext[])
{
	if(dialogid == 691)
	{
   		if(response)
        {
			if(listitem < 0 || listitem >= MAX_BIZ_ACCESS + MAX_BIZ_SETTING) return 1;

			if(PlayerInfo[playerid][pBusiness] == 0) return ErrorMessage(playerid, "{FF6347}У вас нет собственного бизнеса");
			new b = PlayerInfo[playerid][pBusiness];

			// Права Доступа
			if(ListParam[listitem][playerid] == 0)
			{
				if(BizzInfo[b][bFam] == 0) return ErrorText(playerid, "[ Мысли ]: К моему бизнесу не привязана семья"), cmd_bac(playerid);
				showDialogBizAccess(playerid, b, List[listitem][playerid]);
			}

			// Настройки
			if(ListParam[listitem][playerid] == 1)
			{
				new settingId = List[listitem-MAX_BIZ_ACCESS][playerid];
				format(lines,sizeof(lines),""); // Очищаем Lines

				format(line,sizeof(line),"{cccccc}Введите значение для настройки: {ff9000}%s", bizSetting[settingId]), strcat(lines,line);
				if(settingId == 0) 
				{
					DP[0][playerid] = 0, DP[1][playerid] = 1;
					format(line,sizeof(line),"\n\n{0088ff}0 - личный счет, 1 - семейный счет"), strcat(lines,line);
				}
				else if(settingId == 1) 
				{
					DP[0][playerid] = 1, DP[1][playerid] = 900000000;
					format(line,sizeof(line),"\n\n{0088ff}1$ - 900.000.000$"), strcat(lines,line);
				}
				else if(settingId == 2) 
				{
					DP[0][playerid] = 0, DP[1][playerid] = 14400;
					format(line,sizeof(line),"\n\n{0088ff}0 - 14400 минут (10 дней)"), strcat(lines,line);
				}
				ShowDialog(playerid,693,DIALOG_STYLE_INPUT,"{ff9000}Настройки Бизнеса",lines,"Принять","Отмена");
			}
        }
        else mybiz(playerid, DP[4][playerid]);
	}
	else if(dialogid == 692)
   	{
   		if(response)
        {
			new b = PlayerInfo[playerid][pBusiness];
			new i = DP[2][playerid];

			if(listitem == 0)
			{
				if(BizzInfo[b][bAcc][i] == 0) BizzInfo[b][bAcc][i] = 1;
				else if(BizzInfo[b][bAcc][i] == 1)
				{
					if(i == 6 || i == 7) BizzInfo[b][bAcc][i] = 2; // Только у двух прав доступа есть возможность выбрать Любого Гостя
					else BizzInfo[b][bAcc][i] = 0;
				}
				else BizzInfo[b][bAcc][i] = 0;

				BizzInfo[b][bUpdate] = 1;
				showDialogBizAccess(playerid, b, i);
			}
			if(listitem == 1)
			{
				format(store,sizeof(store),"{cccccc}Введите ранг семьи, с которого будет доступно {ff9000}%s\n\n1 - %d Ранг", bizAccess[i], MAX_RANK_FAMILY);
				ShowDialog(playerid,696,DIALOG_STYLE_INPUT,"{ff9000}Настройки Бизнеса",store,"Принять","Отмена");
			}
		}
		else cmd_bac(playerid);
	}
	else if(dialogid == 693)
   	{
		new b = PlayerInfo[playerid][pBusiness];
		new i = DP[2][playerid];
   		if(response)
        {
			if(!strlen(inputtext)) return cmd_bac(playerid);

			new input = strval(inputtext);
			if(input < DP[0][playerid] || input > DP[1][playerid]) return format(store,sizeof(store),"[ Мысли ]: Значение не меньше %d и не больше %d", DP[0][playerid], DP[1][playerid]), ErrorText(playerid, store), cmd_bac(playerid);

			BizzInfo[b][bSetting][i] = input;
			BizzInfo[b][bUpdate] = 1;
			cmd_bac(playerid);
			PlayerPlaySound(playerid,6401,0,0,0);
		}
		else cmd_bac(playerid);
	}
	else if(dialogid == 696)
   	{
		new b = PlayerInfo[playerid][pBusiness];
		new i = DP[2][playerid];
   		if(response)
        {
			if(!strlen(inputtext)) return showDialogBizAccess(playerid, b, i);

			new input = strval(inputtext);
			if(input <= 0 || input > MAX_RANK_FAMILY) return format(store,sizeof(store),"[ Мысли ]: Семейный ранг не меньше 1 и не больше %d", MAX_RANK_FAMILY), ErrorText(playerid, store), showDialogBizAccess(playerid, b, i);

			BizzInfo[b][bAccRank][i] = input;
			BizzInfo[b][bUpdate] = 1;
			showDialogBizAccess(playerid, b, i);
			PlayerPlaySound(playerid,6401,0,0,0);
		}
		else showDialogBizAccess(playerid, b, i);
	}
	return 1;
}

stock SaveBizzAccess(b)
{
	new string_mysql[1400];
	format(string_mysql,sizeof(string_mysql),"UPDATE `pp_bizz` SET `acc0` = '%d', `accrank0` = '%d'",
	BizzInfo[b][bAcc][0], BizzInfo[b][bAccRank][0]); // 54 + 22

	for(new i = 1; i < MAX_BIZ_ACCESS; i++) 
	{
		format(string_mysql,sizeof(string_mysql),"%s, `acc%d` = '%d', `accrank%d` = '%d'", string_mysql,
		i, BizzInfo[b][bAcc][i], i, BizzInfo[b][bAccRank][i]); // 39 + 22 + 4 (1300)
	}

    format(string_mysql,sizeof(string_mysql),"%s WHERE `newid` = '%d'", string_mysql, b); // 24 + 11
	query_empty(pearsq, string_mysql);
	return 1;
}

stock SaveBizzSetting(b)
{
	new string_mysql[1400];
	format(string_mysql,sizeof(string_mysql),"UPDATE `pp_bizz` SET `setting0` = '%d'", BizzInfo[b][bSetting][0]);

	for(new i = 1; i < MAX_BIZ_SETTING; i++) 
	{
		format(string_mysql,sizeof(string_mysql),"%s, `setting%d` = '%d'", string_mysql, i, BizzInfo[b][bSetting][i]);
	}

    format(string_mysql,sizeof(string_mysql),"%s WHERE `newid` = '%d'", string_mysql, b);
	query_empty(pearsq, string_mysql);
	return 1;
}
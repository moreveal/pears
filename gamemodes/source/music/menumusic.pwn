
#define MAX_MUSIC_MENU 100 // Максимальное количество треков (В базе добавлено 100 слотов)
#define MAX_LENGTH_MUSIC_LINK 120 // Длинна музыкальной ссылки
#define MAX_LENGH_MUSIC_NAME 65 // Длинна названия трека
#define MAX_LINE_PAGE_MUSIC 40 // Количество listitem на странице

enum menumusInfo
{
	musID, // ID строки в базе данных
    bool:musStat, // Статус (включена ли эта музыка вообще для воспроизведения)
    musLink[MAX_LENGTH_MUSIC_LINK], // Ссылка на трек
	musName[MAX_LENGH_MUSIC_NAME], // Название трека
	musType, // Где этот трек используется (0 при входе на сервер, 1 автосалон, 2 автосервис)
    musTime // Время суток для проигрывания музыки (0 любое время) (1 день 8:00 - 21:59) (2 22:00 - 4:59 ночь) (3 раннее утро 5:00 - 7:59)
}
new MenuMusicInfo[MAX_MUSIC_MENU][menumusInfo];

// Название меню, в которых музыка используется
new typeMenuMusicName[][] =
{
    "Подключение", "Автосалон", "Автосервис", "Автосалон и Автосервис"
};

// Время суток, когда музыка используется
new typeMenuMusicTime[][] =
{
    "Любое время", "День", "Ночь", "Утро"
};

// Оригинальная музыка и ссылки, для перезагрузки
new originalMenuMusic[][4][] =
{
	// Ссылка, Название, Тип места, Время суток
    { "https://cdn.pears.fun/sound/music/load0.mp3", "SLUMB, Senbei - Over and Done", "0", "1" },
    { "https://cdn.pears.fun/sound/music/load1.mp3", "Hazzakbeats - Future", "0", "1" },
	{ "https://cdn.pears.fun/sound/music/load2.mp3", "PHXNK - Yaratilis", "0", "1" },
	{ "https://cdn.pears.fun/sound/music/load3.mp3", "Tre Savage - Rage vs. luv", "0", "1" },
	{ "https://cdn.pears.fun/sound/music/night0.mp3", "Karamel Kel - Aglow - Slowed Down", "0", "2" },
	{ "https://cdn.pears.fun/sound/music/night1.mp3", "METAHESH - I Promise", "0", "2" },
	{ "https://cdn.pears.fun/sound/music/night2.mp3", "grey killer, Lovemare - Dopamine", "0", "2" },
	{ "https://cdn.pears.fun/sound/music/night3.mp3", "leadwave - unfortunately", "0", "2" },
	{ "https://cdn.pears.fun/sound/music/morning0.mp3", "analog_mannequin - milk cassette (slowed + reverb)", "0", "3" },
	{ "https://cdn.pears.fun/sound/music/morning1.mp3", "с418 - key (slow + reverb)", "0", "3" },
	{ "https://cdn.pears.fun/sound/music/morning2.mp3", "leadwave - way through the universe", "0", "3" },
	{ "https://cdn.pears.fun/sound/music/morning3.mp3", "CXRGI - therapy", "0", "3" },

	// Для Автосалона
	{ "https://cdn.pears.fun/sound/music/vehicle2.mp3", "Baltra - Never Let Go Of Me (slowed)", "1", "0" },

	// Для автосервиса
	{ "https://cdn.pears.fun/sound/music/vehicle1.mp3", "Aero Chord - Surface", "2", "0" },
	{ "https://cdn.pears.fun/sound/music/vehicle6.mp3", "Lil Jon & The Eastside Boyz - Get Low", "2", "0" },
	{ "https://cdn.pears.fun/sound/music/vehicle10.mp3", "Hush - Fired Up", "2", "0" },

	// Для автосервиса и автосалона
	{ "https://cdn.pears.fun/sound/music/vehicle0.mp3", "Ludacris - On the Flow", "3", "0" },
	{ "https://cdn.pears.fun/sound/music/vehicle3.mp3", "DJ Shadow - Six Days", "3", "0" },
	{ "https://cdn.pears.fun/sound/music/vehicle4.mp3", "Don Omar - Conteo", "3", "0" },
	{ "https://cdn.pears.fun/sound/music/vehicle5.mp3", "Joe Budden - Pump It Up", "3", "0" },
	{ "https://cdn.pears.fun/sound/music/vehicle7.mp3", "Teriyaki Boyz - Tokyo Drift", "3", "0" },
	{ "https://cdn.pears.fun/sound/music/vehicle8.mp3", "Pitbull - Oye", "3", "0" },
	{ "https://cdn.pears.fun/sound/music/vehicle9.mp3", "Ludacris - Act A Fool", "3", "0" },
	{ "https://cdn.pears.fun/sound/music/vehicle11.mp3", "Snoop Dogg Feat. The Doors – Riders On The Storm", "3", "0" }
};



alias:menumusic("musicmenu")
CMD:menumusic(playerid)
{
	if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	PlayerPlaySound(playerid,40405,0,0,0);
	showDialogMenuMusic(playerid, 0);
	return true;
}

CMD:testmusic(playerid)
{
	if(server != 0) return false;
    PlayMenuMusicForPlayer(playerid, 0);
    return true;
}

alias:rmenumusic("rmusicmenu")
CMD:rmenumusic(playerid)
{
	if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

	ShowDialog(playerid,25,DIALOG_STYLE_MSGBOX,"Музыка Сервера","{FF6347}Вы уверены, что хотите сбросить всю музыку на сервере?","Да","Нет");
	return true;
}

// Сбрасываем музыку на сервере (включаем дефолтное музло и вырубаем всё остальное)
stock ReloadMenuMusic(playerid)
{
	new quanReload;
	// Перезагружаем дефолтные
	mysql_tquery(pearsq, "START TRANSACTION;");

	for(new i = 0; i < sizeof(originalMenuMusic); i++)
	{
		if(i >= MAX_MUSIC_MENU) break; // Сбрасываем, если упёрлись в предел по количеству допустимых менюшку

		MenuMusicInfo[i][musStat] = true;
		format(MenuMusicInfo[i][musLink], MAX_LENGTH_MUSIC_LINK, originalMenuMusic[i][0]);
		format(MenuMusicInfo[i][musName], MAX_LENGH_MUSIC_NAME, originalMenuMusic[i][1]);
		MenuMusicInfo[i][musType] = strval(originalMenuMusic[i][2]);
		MenuMusicInfo[i][musTime] = strval(originalMenuMusic[i][3]);
		SaveMenuMusicAllPermission(i);
		quanReload ++;
	}

	// Сбрасываем оставшуюся музыку
	if(quanReload > 0 && quanReload < MAX_MUSIC_MENU)
	{
		for(new i = quanReload; i < MAX_MUSIC_MENU; i++) 
		{
			if(MenuMusicInfo[i][musStat] == true) 
			{
				MenuMusicInfo[i][musStat] = false;
				SaveMenuMusicAllPermission(i);
			}
		}
	}

	mysql_tquery(pearsq, "COMMIT;");

	new string[100];
	format(string, sizeof(string), " [ ADM ]: %s сбросил музыку сервера", PlayerInfo[playerid][pName]);
	ABroadCast(COLOR_ADM,string,1);
	AdminLog("rmenumusic", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил музыку");
	return true;
}

// Запускаем воспроизведение музыки для игрока
stock PlayMenuMusicForPlayer(playerid, typeMenu)
{
	if(typeMenu != 0 // Музыка не при подключении
		&& (OnlineInfo[playerid][oListenRadioPears] > 0 || IsPlayerAfk(playerid))) return false; // Игнорим если игрок слушает радио или afk

	new tmphour, tmpminute, tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);

	// Определяем, какой сейчас нужен трек по времени суток
	new needTime;
	if(tmphour >= 22 || tmphour >= 0 && tmphour <= 4) needTime = 2; // Ночь
	else if(tmphour >= 5 && tmphour <= 7) needTime = 3; // Раннее утро
	else needTime = 1; // День

	new getSlotMusic[MAX_MUSIC_MENU], quan;
	for(new i = 0; i < MAX_MUSIC_MENU; i++)
	{
		if(MenuMusicInfo[i][musID] == 0
			|| MenuMusicInfo[i][musStat] == false) continue;

		if(MenuMusicInfo[i][musTime] == 0 || MenuMusicInfo[i][musTime] == needTime)
		{
			if(MenuMusicInfo[i][musType] == typeMenu // Совпадает меню
				|| (typeMenu == 1 || typeMenu == 2) && MenuMusicInfo[i][musType] == 3 // Меню Автосалон и Автосервис
				|| (MenuMusicInfo[i][musType] == 1 || MenuMusicInfo[i][musType] == 2) && typeMenu == 3) // Меню Автосалон и Автосервис
			{
				getSlotMusic[quan] = i + 1;
				quan ++;
			}
		}
	}

	// Не нашли ни один трек для запуска
	if(quan == 0) return false;

	// Выбираем рандомный трек из доступных
	new randomSlot = random(quan);
	if(randomSlot < 0 || randomSlot >= MAX_MUSIC_MENU) return false;
	new findSlotMusic = getSlotMusic[randomSlot] - 1;

	// Воспроизводим трек
	PlayAudioStreamForPlayer(playerid, MenuMusicInfo[findSlotMusic][musLink]);

	// Показываем название трека
	SetPlayerHudPopup(playerid, MenuMusicInfo[findSlotMusic][musName], 5000);
	return true;
}

stock showDialogMenuMusic(playerid, page)
{
	// Настраиваем отображение фильтров и страниц
	new minlist, thisPage, yesNext;
	LoadPageSorting(playerid, 19, MAX_MUSIC_MENU, minlist, page, thisPage);

	new line[214], lines[4096], quan, one;
	format(line,sizeof(line),"Название\tТип\tВремя"), strcat(lines,line);
	for(new i = minlist; i < MAX_MUSIC_MENU; i++)
	{
		List[quan][playerid] = i;
		quan ++;

		// Важные настройки для верной записи страниц
		if(one == 0) OnlineInfo[playerid][oDialogMenu][4] = i, one = 1; // Записывали первый list
		OnlineInfo[playerid][oDialogMenu][0] ++; // Подсчитываем строки
		OnlineInfo[playerid][oDialogMenu][2] = i;

		if(MenuMusicInfo[i][musID] == 0 || MenuMusicInfo[i][musStat] == false) format(line,sizeof(line),"\n{666666}%d. none\t \t ", i + 1);
		else
		{
			format(line, sizeof(line), "\n{ff9000}%d. %s\t%s\t%s",
				i + 1,
				MenuMusicInfo[i][musName],
				typeMenuMusicName[MenuMusicInfo[i][musType]],
				typeMenuMusicTime[MenuMusicInfo[i][musTime]]);
		}
		strcat(lines,line);

		if(quan >= MAX_LINE_PAGE_MUSIC)
		{
			yesNext = 1;
			break;
		}

		if(i >= MAX_MUSIC_MENU - 1 && page > 0)
		{
			yesNext = 1; // Последний list, отображаем Next Page
			OnlineInfo[playerid][oDialogMenu][5] = 1; // Записываем, что эта страница была последней
		}
	}
	if(yesNext == 1) format(line,sizeof(line),"\n{99ff66}Далее >>\t \t "), strcat(lines,line);

	format(line,sizeof(line), "Музыка Сервера [ Страница %d ]", page + 1);
	ShowDialog(playerid,19,DIALOG_STYLE_TABLIST_HEADERS,line,lines,"Выбор","Отмена");
	return true;
}

stock settingMenuMusic(playerid, i)
{
	new lines[1000];
	format(lines,sizeof(lines), "{ff9000}ID %d %s\
							\n{cccccc}Ссылка: {ffffff}..%s\
							\n{cccccc}Название: {ffffff}%s\
							\n{cccccc}Тип: {ffffff}%s\
							\n{cccccc}Время: {ffffff}%s\
							\n{cccccc}Статус: %s", 
		i + 1, MenuMusicInfo[i][musName],
		GetLastNChars(MenuMusicInfo[i][musLink], 12),
		MenuMusicInfo[i][musName],
		typeMenuMusicName[MenuMusicInfo[i][musType]],
		typeMenuMusicTime[MenuMusicInfo[i][musTime]],
		MenuMusicInfo[i][musStat] ? "{99ff66}[ On ]" : "{FF6347}[ Off ]");

	ShowDialog(playerid,20,DIALOG_STYLE_TABLIST_HEADERS,"Музыка Сервера",lines,"Выбор","Отмена");
	return true;
}

stock settingLinkMenuMusic(playerid)
{
	new string[70];
	format(string,sizeof(string),"{ff9000}Введите ссылку на музыку\n{FF6347}4 - %d символов", MAX_LENGTH_MUSIC_LINK - 1);
	ShowDialog(playerid,21,DIALOG_STYLE_INPUT,"Музыка Сервера",string,"Принять","Отмена");
	return true;
}

stock settingNameMenuMusic(playerid)
{
	new string[70];
	format(string,sizeof(string),"{ff9000}Введите название музыки\n{FF6347}4 - %d символов", MAX_LENGH_MUSIC_NAME - 1);
	ShowDialog(playerid,22,DIALOG_STYLE_INPUT,"Музыка Сервера",string,"Принять","Отмена");
	return true;
}

stock settingTypeMenuMusic(playerid)
{
	new line[50], lines[50 + 50 * sizeof(typeMenuMusicName)];
	format(line,sizeof(line),"Выберите где музыка будет воспроизводиться"), strcat(lines,line);
	for(new i = 0; i < sizeof(typeMenuMusicName); i++) format(line,sizeof(line),"\n{cccccc}%s", typeMenuMusicName[i]), strcat(lines,line);
	ShowDialog(playerid,23,DIALOG_STYLE_TABLIST_HEADERS,"Музыка Сервера",lines,"Выбор","Отмена");
	return true;
}

stock settingTimeMenuMusic(playerid)
{
	new line[60], lines[60 + 60 * sizeof(typeMenuMusicTime)];
	format(line,sizeof(line),"Выберите в какое время будет воспроизводиться музыка"), strcat(lines,line);
	for(new i = 0; i < sizeof(typeMenuMusicTime); i++) format(line,sizeof(line),"\n{cccccc}%s", typeMenuMusicTime[i]), strcat(lines,line);
	ShowDialog(playerid,24,DIALOG_STYLE_TABLIST_HEADERS,"Музыка Сервера",lines,"Выбор","Отмена");
	return true;
}

stock dialogCase_MenuMusic(playerid, dialogid, response, listitem, const inputtext[])
{
	if(dialogid == 19) // Главное меню
	{
		if(response)
		{
			if(listitem < 0 || listitem >= MAX_MUSIC_MENU) return true;

			if(OnlineInfo[playerid][oDialogMenu][0] > 0) // Есть строки на странице
			{
				if(listitem >= 0 && listitem < OnlineInfo[playerid][oDialogMenu][0]) // Отображаемые List
				{
					new i = List[listitem][playerid];
					DP[0][playerid] = i;
					settingMenuMusic(playerid, DP[0][playerid]);
				}
				else if(listitem >= OnlineInfo[playerid][oDialogMenu][0]) showDialogMenuMusic(playerid, OnlineInfo[playerid][oDialogMenu][1] + 1);
			}
		}
		return true;
	}
	else if(dialogid == 20) // Меню настройки
	{
		if(response)
		{
			new i = DP[0][playerid];
			if(listitem == 0) settingLinkMenuMusic(playerid); // Ссылка
			else if(listitem == 1) settingNameMenuMusic(playerid); // Название
			else if(listitem == 2) settingTypeMenuMusic(playerid); // Тип
			else if(listitem == 3) settingTimeMenuMusic(playerid); // Время
			else if(listitem == 4) // Статус
			{
				if(MenuMusicInfo[i][musStat] == false)
				{
					if(IsEmptyString(MenuMusicInfo[i][musLink])) return ErrorText(playerid, "{FF6347}Вы не добавили ссылку на музыку"), settingMenuMusic(playerid, i);
					if(IsEmptyString(MenuMusicInfo[i][musName])) return ErrorText(playerid, "{FF6347}Вы не добавили название музыки"), settingMenuMusic(playerid, i);
				}

				MenuMusicInfo[i][musStat] = !MenuMusicInfo[i][musStat];
				settingMenuMusic(playerid, i);
				SaveMenuMusicInt(i, "musStat", MenuMusicInfo[i][musStat]);
			}
		}
		else showDialogMenuMusic(playerid, OnlineInfo[playerid][oDialogMenu][1]);
		return true;
	}
	else if(dialogid == 21) // Вводим ссылку
	{
		new i = DP[0][playerid];
		if(response)
		{
			if(strlen(inputtext) < 4 || strlen(inputtext) >= MAX_LENGTH_MUSIC_LINK - 1) return settingLinkMenuMusic(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "{FF6347}Вы используете запрещённый символ"), settingLinkMenuMusic(playerid);

			if(strfind(inputtext,".mp3") == -1
				&& strfind(inputtext,".ogg") == -1) return ErrorText(playerid, "{FF6347}Можно использовать только mp3 или ogg файлы"), settingLinkMenuMusic(playerid);
			if(strfind(inputtext,"https://") == -1) return ErrorText(playerid, "{FF6347}Ссылка должна начинатся на https://"), settingLinkMenuMusic(playerid);

			format(MenuMusicInfo[i][musLink], MAX_LENGTH_MUSIC_LINK, "%s", inputtext);
			settingMenuMusic(playerid, i);
			SaveMenuMusicString(i, "musLink", MenuMusicInfo[i][musLink]);
		}
		else settingMenuMusic(playerid, i);
		return true;
	}
	else if(dialogid == 22) // Вводим название
	{
		new i = DP[0][playerid];
		if(response)
		{
			if(strlen(inputtext) < 4 || strlen(inputtext) >= MAX_LENGH_MUSIC_NAME - 1) return settingNameMenuMusic(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "{FF6347}Вы используете запрещённый символ"), settingNameMenuMusic(playerid);

			format(MenuMusicInfo[i][musName], MAX_LENGH_MUSIC_NAME, "%s", inputtext);
			settingMenuMusic(playerid, i);
			SaveMenuMusicString(i, "musName", MenuMusicInfo[i][musName]);
		}
		else settingMenuMusic(playerid, i);
		return true;
	}
	else if(dialogid == 23) // Выбираем тип музыки (где она будет воспроизводиться)
	{
		new i = DP[0][playerid];
		if(response)
		{
			if(listitem < 0 || listitem >= sizeof(typeMenuMusicName)) return true;

			MenuMusicInfo[i][musType] = listitem;
			settingMenuMusic(playerid, i);
			SaveMenuMusicInt(i, "musType", MenuMusicInfo[i][musType]);
		}
		else settingMenuMusic(playerid, i);
		return true;
	}
	else if(dialogid == 24) // Выбираем время музыки (в какой диапазон времени она будет воспроизводиться)
	{
		new i = DP[0][playerid];
		if(response)
		{
			if(listitem < 0 || listitem >= sizeof(typeMenuMusicTime)) return true;

			MenuMusicInfo[i][musTime] = listitem;
			settingMenuMusic(playerid, i);
			SaveMenuMusicInt(i, "musTime", MenuMusicInfo[i][musTime]);
		}
		else settingMenuMusic(playerid, i);
		return true;
	}
	else if(dialogid == 25) // Сбрасываем музыку
	{
		if(response) ReloadMenuMusic(playerid);
		return true;
	}
	return false;
}



// Загружаем музыку для меню
function LoadMenuMusic()
{
	new time = GetTickCount();
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		for(new i = 0; i < MAX_MUSIC_MENU; i++)
		{
			cache_get_value_name_int(i, "newid", MenuMusicInfo[i][musID]);
			cache_get_value_name_bool(i, "musStat", MenuMusicInfo[i][musStat]);
			cache_get_value_name(i, "musLink", MenuMusicInfo[i][musLink], MAX_LENGTH_MUSIC_LINK);
			cache_get_value_name(i, "musName", MenuMusicInfo[i][musName], MAX_LENGH_MUSIC_NAME);
			cache_get_value_name_int(i, "musType", MenuMusicInfo[i][musType]);
			cache_get_value_name_int(i, "musTime", MenuMusicInfo[i][musTime]);

			if(IsEmptyString(MenuMusicInfo[i][musLink])) MenuMusicInfo[i][musLink] = EOS;
			if(IsEmptyString(MenuMusicInfo[i][musName])) MenuMusicInfo[i][musName] = EOS;
			if(MenuMusicInfo[i][musType] >= sizeof(typeMenuMusicName)) MenuMusicInfo[i][musType] = 0; // Защита от невалидного типа музыки
			if(MenuMusicInfo[i][musTime] >= sizeof(typeMenuMusicTime)) MenuMusicInfo[i][musTime] = 0; // Защита от невалидного времени музыки
		}
		printf("[MODE]: Музыка Интерфейсов [%d ms]", GetTickCount() - time);
	}
	return true;
}

// Сохраняем int переменную
stock SaveMenuMusicInt(i, const namePermission[], databasePermission)
{
	new string_mysql[180];
	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_MenuMusic` SET `%s` = '%d' WHERE `newid` = '%d'", 
		namePermission, databasePermission, MenuMusicInfo[i][musID]);
	query_empty(pearsq, string_mysql);
	return true;
}

// Сохраняем string переменную
stock SaveMenuMusicString(i, const namePermission[], const databasePermission[])
{
	new string_mysql[280];
	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_MenuMusic` SET `%s` = '%e' WHERE `newid` = '%d'", 
		namePermission, databasePermission, MenuMusicInfo[i][musID]);
	query_empty(pearsq, string_mysql);
	return true;
}

// Сохраняем все переменные разом
stock SaveMenuMusicAllPermission(i)
{
	new string_mysql[400];
	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_MenuMusic` SET `musStat` = '%d', `musLink` = '%e', `musName` = '%e',\
		`musType` = '%d', `musTime` = '%d' WHERE `newid` = '%d'", 
			MenuMusicInfo[i][musStat], 
			MenuMusicInfo[i][musLink], 
			MenuMusicInfo[i][musName], 
			MenuMusicInfo[i][musType], 
			MenuMusicInfo[i][musTime], 
			MenuMusicInfo[i][musID]);
	query_empty(pearsq, string_mysql);
	return true;
}



// Получаем сколько-то последних символов из string переменной (n количество последних символов)
stock GetLastNChars(const input[], n)
{
    new len = strlen(input); // Определяем длину исходной строки
    new output[256]; // Массив для последних n символов + 1 для нуль-терминатора

    if (len > n) strmid(output, input, len - n, len, n + 1); // Копируем последние n символов
    else strmid(output, input, 0, len, len + 1); // Копируем всю строку, если она короче n
    return output;
}

// Проверяем, пустая ли строка
stock IsEmptyString(const string[])
{
	 if(!strcmp(string,"\0",true) || strfind(string,"NULL",true) != (-1)) return true;
	 return false;
}

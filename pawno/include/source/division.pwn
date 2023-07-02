/*
Важное поясниение!
В этом pwn много где в получении или передаче переменных имеется +1 или -1, т.е. какие-то вычеты
Организации, это id начиная с 1 и так далее, а внутри переменных подфракций счёт идёт с 0
Поэтому в зависимости от того, откуда мы берём переменную или куда мы её применяем, я делаю -1 или +1
Переменная pDivision не может иметь 0 (0 значит нет подфракции), поэтому если беру отсюда, то плюсую
Переменная pLeader pMember и функция ftaction(playerid) не могут иметь 0 (0 значит нет подфракции), так-же плюсуем

DP[0] - используется в /lmenu
DP[1] - id organization
DP[2] - id division
DP[3] - информация о доступе к управлению подфракцией
*/

#define MAX_DIVISION_ORG 10 // Количество подфракций
#define MAX_NAME_DIVISION_LENGTH 31 // Длинна названий в дивизиях (Если указано 31, значит максимальное количество символов 30, всегда -1 слот)
#define MAX_NAME_DIVISION_ABBREVIATION_LENGTH 11 // Длинна аббревиатуры

enum divInfo
{
    divRanks, //  Количество рангов
    divName[MAX_NAME_DIVISION_LENGTH], // Название
    divAbbreviation[MAX_NAME_DIVISION_ABBREVIATION_LENGTH], // Аббревиатура
    Float:divSpawnPos[4], // Позиция спавна
    divSpawnWorld, // Вирт мир спавна
    divSpawnInterior, // Интерьер спавна
    divColorHex[7], // hex цвет
	divColorVeh[2] // Цвет транспорта (0 и 1) - у транспорта цвет, это число (id)
};
new DivisionInfo[MAX_ORG][MAX_DIVISION_ORG][divInfo];
new DivisionRankName[MAX_ORG][MAX_DIVISION_ORG][MAX_RANK_ORG][MAX_NAME_DIVISION_LENGTH]; // Названия рангов


// Список всех подфракций (Меню для лидера)
CMD:alldiv(playerid)
{
	if(PlayerInfo[playerid][pLeader] == 0) return ErrorMessage(playerid, "{FF6347}Вы не лидер организации");

    PlayerPlaySound(playerid,1150,0,0,0);
    showDialogAllDivisions(playerid);
	return 1;
}
stock showDialogAllDivisions(playerid)
{
    new g = fraction(playerid) - 1;
	DP[1][playerid] = g; // Сохраняем id организации

	format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"ID\tНазвание\tАббревиатура"), strcat(lines,line);
    for(new i = 0; i < MAX_DIVISION_ORG; i++)
	{
        format(line,sizeof(line),"\n{ff9000}%d.\t{cccccc}{%s}%s\t%s", i+1, DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName], DivisionInfo[g][i][divAbbreviation]), strcat(lines,line);
    }
	ShowDialog(playerid,1315,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Подфракции",lines,"Выбрать","Выход");
    return 1;
}

// Меню подфракции
CMD:div(playerid) return cmd_division(playerid);
CMD:division(playerid)
{
	if(PlayerInfo[playerid][pDivision][0] == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в подфракции");
	if(fraction(playerid) == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");

	DP[1][playerid] = fraction(playerid)-1;
	DP[2][playerid] = PlayerInfo[playerid][pDivision][0]-1;

    PlayerPlaySound(playerid,1150,0,0,0);
    showDialogMenuDivision(playerid);
	return 1;
}
stock showDialogMenuDivision(playerid)
{
	new g = DP[1][playerid]; // Получаем id организации
	new i = DP[2][playerid]; // Получаем id подфракции
	DP[3][playerid] = 0; // Сбрасываем доступ к управлению

	format(lines,sizeof(lines),""); // Очищаем Lines

	format(line,sizeof(line),"{cccccc}Информация\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{555555}Участники {99ff66}Online\t"), strcat(lines,line);

	// Настройки подфракции для лидеров, замов и глав подфракции
	if(PlayerInfo[playerid][pLeader] > 0 
	|| PlayerInfo[playerid][pMember] > 0 && PlayerInfo[playerid][pRank] >= get_maxrank(g+1)-1
	|| PlayerInfo[playerid][pDivision][0] == i+1 && PlayerInfo[playerid][pRank] >= DivisionInfo[g][i][divRanks])
	{
		DP[3][playerid] = 1; // Даём доступ к управлению подфракцией

		format(line,sizeof(line),"\n{555555}Участники {FF6347}Offline\t"), strcat(lines,line);
		format(line,sizeof(line),"\n{555555}Пригласить\t"), strcat(lines,line);
		format(line,sizeof(line),"\n{555555}Исключить\t"), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}Настройки склада >>\t"), strcat(lines,line);

		format(line,sizeof(line),"\n{cccccc}Название: \t{%s}%s", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}Аббревиатура: \t{%s}%s", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divAbbreviation]), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}Количество рангов: \t{555555}%d", DivisionInfo[g][i][divRanks]), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}Названия рангов {%s}>>\t", DivisionInfo[g][i][divColorHex]), strcat(lines,line);
		if(DivisionInfo[g][i][divSpawnPos][0] == 0.0) format(line,sizeof(line),"\n{cccccc}Спавн {%s}>>\t{FF6347}[Не установлен]", DivisionInfo[g][i][divColorHex]), strcat(lines,line);
		else format(line,sizeof(line),"\n{cccccc}Спавн {%s}>>\t{99ff66}[Установлен]", DivisionInfo[g][i][divColorHex]), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}Цвет: \t{%s}||||||||||", DivisionInfo[g][i][divColorHex]), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}1 Цвет транспорта \t{%s}|||||||||| {555555}[ ID %d ]", VehicleColoursTableHex[DivisionInfo[g][i][divColorVeh][0]], DivisionInfo[g][i][divColorVeh][0]), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}2 Цвет транспорта \t{%s}|||||||||| {555555}[ ID %d ]", VehicleColoursTableHex[DivisionInfo[g][i][divColorVeh][1]], DivisionInfo[g][i][divColorVeh][1]), strcat(lines,line);
		
		if(PlayerInfo[playerid][pDivision][0] != i+1) format(line,sizeof(line),"\n{99ff66}Войти в подфракцию >> \t"), strcat(lines,line);
		else format(line,sizeof(line),"\n{FF6347}Покинуть подфракцию >> \t"), strcat(lines,line);
	}

    format(store,sizeof(store),"{ff9000}Подфракция {%s}%s", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);
	ShowDialog(playerid,1316,DIALOG_STYLE_TABLIST,store,lines,"Выбрать","Выход");
	return 1;
}

// Список участников подфракции
CMD:dmembers(playerid) return cmd_divmembers(playerid);
CMD:divmembers(playerid)
{
	if(PlayerInfo[playerid][pDivision][0] == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в подфракции");
	if(fraction(playerid) == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");

    showDialogMembersDivision(playerid, fraction(playerid), PlayerInfo[playerid][pDivision][0]);
	return 1;
}
stock showDialogMembersDivision(playerid, org, div)
{
	format(lines,sizeof(lines),""); // Очищаем Lines
	format(line,sizeof(line),"{cccccc}Имя\t{cccccc}Ранг\t{333333}AFK"), strcat(lines,line);

	new atext[10], btext[10], quan;
	new year, month, day;
	getdate(year, month, day);

	foreach(Player,i)
	{
		if(OnlineInfo[i][oLogged] == 0) continue; // Не залогинился
		if(PlayerInfo[i][pMember] != org && PlayerInfo[i][pLeader] != org) continue; // Не в организации
		if(PlayerInfo[i][pDivision][0] != div && PlayerInfo[i][pDivision][1] != div) continue; // Не в подфракции

		// Получаем информацию о рации (Включена или нет)
		if(PlayerInfo[i][pTransmitterOff][2]) atext = "{FF6347}*";
		else atext = "{00ff66}*";

		// Получаем информацию о главе подфракции
		if(PlayerInfo[i][pRank] >= DivisionInfo[org-1][div-1][divRanks]) format(btext,sizeof(btext),"%s", DivisionInfo[org-1][div-1][divColorHex]);
		else btext = "cccccc";

		// Выводим список игроков с учётом AFK
		if(GetPVarInt(i,"afksystem") > 8)
		{
			format(line,sizeof(line),"\n%s {%s}%s{cccccc}\t%s [%d]\t{333333}%s", atext, btext, getPlayerNameTransmitter(i), DivisionRankName[org-1][div-1][PlayerInfo[i][pRank]-1], PlayerInfo[i][pRank], fine_time(GetPVarInt(i,"afksystem"))), strcat(lines,line);
		}
		else
		{
			format(line,sizeof(line),"\n%s {%s}%s{cccccc}\t%s [%d]\t", atext, btext, getPlayerNameTransmitter(i), DivisionRankName[org-1][div-1][PlayerInfo[i][pRank]-1], PlayerInfo[i][pRank]), strcat(lines,line);
		}
		quan ++;
	}

	format(store,sizeof(store),"{cccccc}Участники {%s}%s {99ff66}Online: %d {ff9000}[%02d.%02d.%d]", DivisionInfo[org-1][div-1][divColorHex], DivisionInfo[org-1][div-1][divName], quan ,day, month, year);
   	ShowDialog(playerid,1326,DIALOG_STYLE_TABLIST_HEADERS,store,lines,"*","");
	return 1;
}

CMD:divin(playerid, const params[]) return cmd_divinvite(playerid, params);
CMD:divinvite(playerid, const params[])
{
	if(PlayerInfo[playerid][pGoogle] == 0 && server != 0) return ErrorMessage(playerid, "{FF6347}У вас не привязан Google Authenticator [ Y >> Меню >> Безопасность ]");

	new g = fraction(playerid);
	new i = PlayerInfo[playerid][pDivision][0];
	if(g == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");
	if(i == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в подфракции");
	if(PlayerInfo[playerid][pRank] < DivisionInfo[g-1][i-1][divRanks]) return ErrorMessage(playerid, "{FF6347}Доступно только для главы подфракции");

	new playerName[24], giveplayerid;
	if(sscanf(params, "s", playerName)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Пригласить игрока в подфракцию [ /divinvite ID ]");

	giveplayerid = ReturnUser(playerName);
	if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока нет на сервере");
	if(!ProxDetectorS(2.0, playerid, giveplayerid) || GetPlayerState(giveplayerid) == PLAYER_STATE_SPECTATING) return ErrorMessage(playerid, "{FF6347}Вы слишком далеко от игрока");
	if(PlayerInfo[giveplayerid][pDivision][0] > 0) return ErrorMessage(playerid, "{FF6347}Игрок уже находится в подфракции");
	if(g != fraction(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Этот игрок не состоит в вашей организации");

	// Записываем чела, которого приглашаем
	DP[4][playerid] = giveplayerid;
	format(store, sizeof(store), "* Вы отправили приглашение %s на вступление в %s", getPlayerNameTransmitter(giveplayerid), DivisionInfo[g - 1][i - 1][divName]);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, store);
	PlayerPlaySound(playerid,40405,0,0,0);

	// Записываем этому челу инфу, куда приглашаем и кто приглашает
	DP[0][giveplayerid] = i;
	DP[1][giveplayerid] = playerid;
	format(store, sizeof(store), "{ffcc66}%s{33CCFF}, приглашает вас в %s\n\n{33CCFF}Вы согласны?", getPlayerNameTransmitter(playerid), DivisionInfo[g - 1][i - 1][divName]);
	ShowDialog(giveplayerid,1327,DIALOG_STYLE_MSGBOX,"{ff9000}Приглашение",store,"Да","Нет");
	PlayerPlaySound(giveplayerid,40405,0,0,0);
	return 1;
}

CMD:dleave(playerid) return cmd_divleave(playerid);
CMD:divleave(playerid)
{
	new g = fraction(playerid);
	new i = PlayerInfo[playerid][pDivision][0] - 1;
	if(PlayerInfo[playerid][pDivision][0] == 0 || g == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в подфракции");
	g -= 1;

   	PlayerPlaySound(playerid,40405,0,0,0);
   	DP[5][playerid] = 0; // Сбрасываем счетчик уточнений
   	format(store, sizeof(store), "{cccccc}Вы уверены, что хотите покинуть {%s}%s{cccccc}?", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);
	ShowDialog(playerid,1325,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция",store,"Да","Нет");
	return 1;
}

stock showDialogSettingDivisionRank(playerid) // Меню настройки названий рангов в подфракции
{
	new g = DP[1][playerid]; // Получаем id организации
	new i = DP[2][playerid]; // Получаем id подфракции

	if(DivisionInfo[g][i][divRanks] <= 0) return ErrorText(playerid, "{cccccc}[ Мысли ]: Мне нужно указать количество рангов, прежде чем редактировать названия"), showDialogMenuDivision(playerid);

	format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"Названия рангов"), strcat(lines,line);
    for(new r = 0; r < DivisionInfo[g][i][divRanks]; r++)
	{
		if(r == DivisionInfo[g][i][divRanks]-1) format(line,sizeof(line),"\n{ff9000}%d. %s", r+1, DivisionRankName[g][i][r]), strcat(lines,line); // Ранг руководителя подфракции
		else format(line,sizeof(line),"\n{ff9000}%d. {cccccc}%s", r+1, DivisionRankName[g][i][r]), strcat(lines,line); // Прочие ранги
	}
	ShowDialog(playerid,1320,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Подфракция",lines,"Выбрать","Выход");
	return 1;
}

stock dialogCase_Division(playerid, dialogid, response, listitem, const inputtext[])
{
	if(dialogid == 1315) // Меню списка подфракций
	{
		if(response)
		{
			if(listitem < 0 || listitem >= MAX_DIVISION_ORG) return 0;
			DP[2][playerid] = listitem; // Сохраняем id выбранной подфракции
			showDialogMenuDivision(playerid);
		}
	}
	if(dialogid == 1316) // Меню настройки подфракции
	{
		if(response)
		{
			new g = DP[1][playerid];

			if(listitem == 1) cmd_divmembers(playerid);
			if(listitem == 3)
			{
				ShowDialog(playerid,1328,DIALOG_STYLE_INPUT,"{ff9000}Подфракция","{cccccc}Введите {ff9000}id или Никнейм {cccccc}игрока, чтобы пригласить его в подфракцию","Принять","Отмена");
			}

			if(listitem >= 5)
			{
				if(DP[3][playerid] == 0) return 0; // Блокируем другие листы, если нет доступа (не отрисованный listitem могут вызвать внешними скриптами)
			}

			if(listitem == 6) // Название
			{
				format(store,sizeof(store),"{cccccc}Введите название подфракции [1 - %d символов]", MAX_NAME_DIVISION_LENGTH-1);
				ShowDialog(playerid,1317,DIALOG_STYLE_INPUT,"{ff9000}Подфракция",store,"Принять","Отмена");
			}
			if(listitem == 7) // Абреввиатура
			{
				format(store,sizeof(store),"{cccccc}Введите аббревиатуру подфракции [1 - %d символов]\n\n{555555}Она будет отображаться в /r, /d, /i чатах. Пример: [ABC]", MAX_NAME_DIVISION_ABBREVIATION_LENGTH-1);
				ShowDialog(playerid,1318,DIALOG_STYLE_INPUT,"{ff9000}Подфракция",store,"Принять","Отмена");
			}
			if(listitem == 8) // Количество рангов
			{
				format(store,sizeof(store),"{cccccc}Введите количество рангов в подфракции [2 - %d рангов]\n\n{FF6347}Внимание! Максимальный ранг будет являться главой подфракции", get_maxrank(g+1)-1);
				ShowDialog(playerid,1319,DIALOG_STYLE_INPUT,"{ff9000}Подфракция",store,"Принять","Отмена");
			}
			if(listitem == 9) showDialogSettingDivisionRank(playerid); // Названия рангов
			if(listitem == 10) // Спавн
			{
				ShowDialog(playerid,1322,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция","{cccccc}Вы уверены, что хотите установить {ff9000}эту позицию {cccccc}в качестве спавна участников подфракции?\n\n{FF6347}Внимание! Учитывайте, в какую сторону повёрнут ваш персонаж лицом, в данный момент","Да","Нет");
			}
			if(listitem == 11) // Цвет
			{
				ShowDialog(playerid,1323,DIALOG_STYLE_INPUT,"{ff9000}Подфракция","{cccccc}Введите Hex код цвета подфракции [6 Символов]\nПример: ff9000","Принять","Отмена");
			}
			if(listitem == 12) // Цвет Транспорта 1
			{
				DP[4][playerid] = 0; // слот цвета транспорта
				ShowDialog(playerid,1324,DIALOG_STYLE_INPUT,"{ff9000}Подфракция","{cccccc}Введите id цвета транспорта [0 - 255]\n\nПосмотреть, как выглядят цвета транспорта, можно на форуме сервера pears-project.com","Принять","Отмена");
			}
			if(listitem == 13) // Цвет Транспорта 2
			{
				DP[4][playerid] = 1; // слот цвета транспорта
				ShowDialog(playerid,1324,DIALOG_STYLE_INPUT,"{ff9000}Подфракция","{cccccc}Введите id цвета транспорта [0 - 255]\n\nПосмотреть, как выглядят цвета транспорта, можно на форуме сервера pears-project.com","Принять","Отмена");
			}
			if(listitem == 14) // Войти в подфракцию
			{
				new i = DP[2][playerid]; // Получаем id подфракции
				if(PlayerInfo[playerid][pDivision][0] == i + 1) return cmd_divleave(playerid);

				PlayerInfo[playerid][pDivision][0] = i + 1;

				// Включаем отображение рации /i
				PlayerInfo[playerid][pTransmitterOff][2] = false;

				// Включаем рацию в доступ
				PlayerInfo[playerid][pRacDiv][0] = fraction(playerid);
            	PlayerInfo[playerid][pRacDiv][1] = PlayerInfo[playerid][pDivision][0];
            	PlayerInfo[playerid][pRacDiv][2] = 1;

				format(store, sizeof(store), "[ Мысли ]: Теперь я нахожусь в подфракции %s {ff9000}[ /div ]", DivisionInfo[g][i][divName]);
				SendClientMessage(playerid, COLOR_GREY, store);

				showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			}
		}
		else showDialogAllDivisions(playerid);
	}
	if(dialogid == 1317) // Название
	{
		if(response)
		{
			if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);
          	if(strlen(inputtext) < 1 || strlen(inputtext) >= MAX_NAME_DIVISION_LENGTH) return format(store,sizeof(store),"[ Мысли ]: Не меньше 1 и не больше %d символов", MAX_NAME_DIVISION_LENGTH-1), ErrorText(playerid, store), showDialogMenuDivision(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogMenuDivision(playerid);

			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции

			format(DivisionInfo[g][i][divName], MAX_NAME_DIVISION_LENGTH, "%s", inputtext);

			format(store, sizeof(store), "** [%s] Руководитель %s изменил%s название подфракции: %s.", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid), inputtext);
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, store);
			format(store, sizeof(store), "[ Мысли ]: Я изменил%s название подфракции: %s", gender(playerid), inputtext);
			SendClientMessage(playerid, COLOR_GREY, store);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			DivisionSave(g, i); // Сохраняем

			OrgLog(g + 1, "divName", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, inputtext);
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == 1318) // Аббревиатура
	{
		if(response)
		{
			if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);
          	if(strlen(inputtext) < 1 || strlen(inputtext) >= MAX_NAME_DIVISION_ABBREVIATION_LENGTH) return format(store,sizeof(store),"[ Мысли ]: Не меньше 1 и не больше %d символов", MAX_NAME_DIVISION_ABBREVIATION_LENGTH-1), ErrorText(playerid, store), showDialogMenuDivision(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogMenuDivision(playerid);

			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции

			format(DivisionInfo[g][i][divAbbreviation], MAX_NAME_DIVISION_ABBREVIATION_LENGTH, "%s", inputtext);

			format(store, sizeof(store), "** [%s] Руководитель %s изменил%s аббревиатуру подфракции: %s.", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid), inputtext);
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, store);
			format(store, sizeof(store), "[ Мысли ]: Я изменил%s аббревиатуру подфракции: %s", gender(playerid), inputtext);
			SendClientMessage(playerid, COLOR_GREY, store);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			DivisionSave(g, i); // Сохраняем

			OrgLog(g + 1, "divAbbr", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, inputtext);
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == 1319) // Количество рангов
	{
		if(response)
		{
			new input;
			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции

			if(sscanf(inputtext, "i", input)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);
			if(input > get_maxrank(g+1)-1 || input < 2) return format(store,sizeof(store),"[ Мысли ]: Не меньше 2 и не больше %d рангов", get_maxrank(g+1)-1), ErrorText(playerid, store), showDialogMenuDivision(playerid);

			if(DivisionInfo[g][i][divRanks] == input) return ErrorText(playerid, "[ Мысли ]: Это количество рангов уже указано"), showDialogMenuDivision(playerid);
			DivisionInfo[g][i][divRanks] = input;

			format(store, sizeof(store), "** [%s] Руководитель %s изменил%s количество рангов: %d.", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid), input);
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, store);
			format(store, sizeof(store), "[ Мысли ]: Я изменил%s количество рангов в подфракции: %d", gender(playerid), input);
			SendClientMessage(playerid, COLOR_GREY, store);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			DivisionSave(g, i); // Сохраняем

			format(store,sizeof(store),"%d Рангов", input);
			OrgLog(g + 1, "divRanks", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, store);
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == 1320) // Названия рангов
	{
		if(response)
		{
			if(listitem < 0 || listitem >= MAX_RANK_ORG) return 0;
			DP[3][playerid] = listitem; // Сохраняем id выбранного ранга

			format(store,sizeof(store),"{cccccc}Введите название %d ранга [1 - %d символов]", listitem + 1, MAX_NAME_DIVISION_LENGTH-1);
			ShowDialog(playerid,1321,DIALOG_STYLE_INPUT,"{ff9000}Подфракция",store,"Принять","Отмена");
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == 1321) // Название рангов
	{
		if(response)
		{
			if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogSettingDivisionRank(playerid);
          	if(strlen(inputtext) < 1 || strlen(inputtext) >= MAX_NAME_DIVISION_LENGTH) return format(store,sizeof(store),"[ Мысли ]: Не меньше 1 и не больше %d символов", MAX_NAME_DIVISION_LENGTH-1), ErrorText(playerid, store), showDialogSettingDivisionRank(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogSettingDivisionRank(playerid);

			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции
			new r = DP[3][playerid]; // Получаем id ранга

			format(DivisionRankName[g][i][r], MAX_NAME_DIVISION_LENGTH, "%s", inputtext);

			format(store, sizeof(store), "** [%s] Руководитель %s изменил%s название %d ранга: %s.", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid), r + 1, inputtext);
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, store);
			format(store, sizeof(store), "[ Мысли ]: Я изменил%s название %d ранга: %s", gender(playerid), r + 1, inputtext);
			SendClientMessage(playerid, COLOR_GREY, store);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogSettingDivisionRank(playerid); // Открываем меню настройки подфракции
			DivisionSaveRankName(g, i, r); // Сохраняем

			format(store,sizeof(store),"%d. %s", r + 1, inputtext);
			OrgLog(g + 1, "divRankName", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, store);
		}
		else showDialogSettingDivisionRank(playerid);
	}
	if(dialogid == 1322) // Спавн
	{
		if(response)
		{
			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции

			if(IsPlayerInSquare(playerid,-1739.7145, -103.8218,-1694.4082,-27.3040) 
			|| IsPlayerInSquare(playerid,2401.7756,-2641.1243,2447.0828,-2564.6064)) return ErrorText(playerid, "[ Мысли ]: Это место недоступно [ Ангар мафии ]"), showDialogMenuDivision(playerid);
            if((IsPlayerInSquare(playerid,61.6997,1731.2677,426.7695,2141.7856) || IsPlayerInSquare(playerid,-1562.9559,259.8604,-1211.1649,501.0728)) && Protect_Z[playerid] >= -30.0 && Protect_Z[playerid] <= 40.0
			|| GetPlayerInterior(playerid) == 241 && GetPlayerVirtualWorld(playerid) == 241 
			|| GetPlayerInterior(playerid) == 242 && GetPlayerVirtualWorld(playerid) == 242) return ErrorText(playerid, "[ Мысли ]: Это место недоступно [ Территория NGSA ]"), showDialogMenuDivision(playerid);
			if(MPGO[playerid] != 0) return ErrorText(playerid, "[ Мысли ]: Я на мероприятии"), showDialogMenuDivision(playerid);
			if(IsAGangCapt(playerid))
			{
				if(CaptInfo[cCaptStat] == true) return ErrorText(playerid, "[ Мысли ]: Не могу изменить во время капта"), showDialogMenuDivision(playerid);
			}

			GetPlayerPos(playerid, DivisionInfo[g][i][divSpawnPos][0], DivisionInfo[g][i][divSpawnPos][1], DivisionInfo[g][i][divSpawnPos][2]);
		    GetPlayerFacingAngle(playerid, DivisionInfo[g][i][divSpawnPos][3]);
		    DivisionInfo[g][i][divSpawnInterior] = GetPlayerInterior(playerid);
		    DivisionInfo[g][i][divSpawnWorld] = GetPlayerVirtualWorld(playerid);

			format(store, sizeof(store), "** [%s] Руководитель %s установил%s новый спавн.", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid));
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, store);
			format(store, sizeof(store), "[ Мысли ]: Я установил%s новый спавн для %s", gender(playerid), DivisionInfo[g][i][divName]);
			SendClientMessage(playerid, COLOR_GREY, store);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);

			showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			DivisionSave(g, i); // Сохраняем

			OrgLog(g + 1, "divSpawn", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, "");
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == 1323) // Цвет подфракции Hex
	{
		if(response)
		{
			if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);
          	if(strlen(inputtext) != 6) return ErrorText(playerid, "[ Мысли ]: Только 6 символов"), showDialogMenuDivision(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogMenuDivision(playerid);

			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции

			format(DivisionInfo[g][i][divColorHex], 7, "%s", inputtext);

			format(store, sizeof(store), "** [%s] Руководитель %s изменил%s цвет {%s}%s.", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid), inputtext, DivisionInfo[g][i][divName]);
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, store);
			format(store, sizeof(store), "[ Мысли ]: Я изменил%s цвет подфракции {%s}%s", gender(playerid), inputtext, DivisionInfo[g][i][divName]);
			SendClientMessage(playerid, COLOR_GREY, store);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			DivisionSave(g, i); // Сохраняем

			OrgLog(g + 1, "divColorHex", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, inputtext);
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == 1324) // Цвета транспорта
	{
		if(response)
		{
			new input;
			if(sscanf(inputtext, "i", input)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);
			if(input > MAX_COLOR_VEHICLE || input < 0) return format(store,sizeof(store),"[ Мысли ]: Не меньше 0 и не больше %d", MAX_COLOR_VEHICLE), ErrorText(playerid, store), showDialogMenuDivision(playerid);

			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции
			new s = DP[4][playerid]; // Получаем слот цвета

			if(DivisionInfo[g][i][divColorVeh][s] == input) return ErrorText(playerid, "[ Мысли ]: Этот цвет уже указан"), showDialogMenuDivision(playerid);
			DivisionInfo[g][i][divColorVeh][s] = input;

			format(store, sizeof(store), "** [%s] Руководитель %s изменил%s цвет транспорта {%s}[ ID: %d ]", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid), VehicleColoursTableHex[input], input);
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, store);
			format(store, sizeof(store), "[ Мысли ]: Я изменил%s цвет транспорта в подфракции {%s}[ ID: %d ]", gender(playerid), VehicleColoursTableHex[input], input);
			SendClientMessage(playerid, COLOR_GREY, store);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			DivisionSave(g, i); // Сохраняем

			format(store,sizeof(store),"ID: %d Slot: %d", input, s);
			OrgLog(g + 1, "divColorVeh", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, store);
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == 1325) // Покинуть подфракцию
	{
		if(response)
		{
			new goLeave;
			new g = fraction(playerid)-1;
			new i = PlayerInfo[playerid][pDivision][0]-1;
			if(PlayerInfo[playerid][pLeader] >= 1
			|| PlayerInfo[playerid][pMember] > 0 && PlayerInfo[playerid][pRank] >= get_maxrank(g + 1)-1) goLeave = 1;
			
			if(goLeave == 1 || DP[5][playerid] == 4) // Да, увольняемся
			{
				PlayerInfo[playerid][pDivision][0] = 0;
				format(store,sizeof(store),"{99ff66}Готово! Вы покинули подфракцию %s", DivisionInfo[g][i][divName]);
				SuccessMessage(playerid, store);
				format(store, sizeof(store), "[ Мысли ]: Я покинул%s подфракцию %s", gender(playerid), DivisionInfo[g][i][divName]);
				SendClientMessage(playerid, COLOR_GREY, store);

				if(goLeave == 0) OrgLog(g + 1, "divleave", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, "");
				return 1;
			}

			if(DP[5][playerid] == 0)
			{
				DP[5][playerid] = 1;
   				format(store, sizeof(store), "{cccccc}Вы точно уверены, что хотите покинуть {%s}%s{cccccc}?", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);
				ShowDialog(playerid,1325,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция",store,"Да","Нет");
			}
			else if(DP[5][playerid] == 1)
			{
				DP[5][playerid] = 2;
   				format(store, sizeof(store), "{cccccc}Вы точно точно точно уверены, что хотите покинуть {%s}%s{cccccc}?", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);
				ShowDialog(playerid,1325,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция",store,"Да","Нет");
			}
			else if(DP[5][playerid] == 2)
			{
				DP[5][playerid] = 3;
   				format(store, sizeof(store), "{cccccc}Прям точнее точного хотите покинуть {%s}%s{cccccc}?", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);
				ShowDialog(playerid,1325,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция",store,"Да","Нет");
			}
			else if(DP[5][playerid] == 3)
			{
				DP[5][playerid] = 4;
   				format(store, sizeof(store), "{cccccc}Всё всё... Последний раз, просто уточнить. Вы покидаете {%s}%s{cccccc}?", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);
				ShowDialog(playerid,1325,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция",store,"Да","Нет");
			}
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == 1326) showDialogMenuDivision(playerid); // divmembers или просто возвращаем меню
	if(dialogid == 1327) // divinvite
	{
		new giveplayerid = DP[1][playerid];
		new g = fraction(playerid);
		new i = DP[0][playerid];
		if(g == 0) return 0;

		if(response)
		{
			PlayerInfo[playerid][pDivision][0] = i + 1;

			// Включаем отображение рации /i
			PlayerInfo[playerid][pTransmitterOff][2] = false;

			// Включаем рацию в доступ
			PlayerInfo[playerid][pRacDiv][0] = fraction(playerid);
			PlayerInfo[playerid][pRacDiv][1] = PlayerInfo[playerid][pDivision][0];
			PlayerInfo[playerid][pRacDiv][2] = 1;

			format(store, sizeof(store), "[ Мысли ]: Теперь я нахожусь в подфракции %s {ff9000}[ /div ]", DivisionInfo[g - 1][i - 1][divName]);
			SendClientMessage(playerid, COLOR_GREY, store);


			PlayerPlaySound(playerid, 6401, 0, 0, 0); // Done
			if(IsOnline(giveplayerid) && ProxDetectorS(10.0, playerid, giveplayerid))
			{
				PlayerPlaySound(giveplayerid, 6401, 0, 0, 0); // Done
				format(store, sizeof(store), "* %s принимает приглашение и вступает в %s", getPlayerNameTransmitter(playerid), DivisionInfo[g - 1][i - 1][divName]);
				SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, store);
			}
		}
		else
		{
			PlayerPlaySound(playerid, 6801, 0, 0, 0); // Отказ
			if(IsOnline(giveplayerid) && ProxDetectorS(10.0, playerid, giveplayerid))
			{
				PlayerPlaySound(giveplayerid, 6801, 0, 0, 0); // Отказ
				format(store, sizeof(store), "* %s отказывается от вашего предложения вступить в %s", getPlayerNameTransmitter(playerid), DivisionInfo[g - 1][i - 1][divName]);
				SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, store);
			}
		}
	}
	if(dialogid == 1328)
	{
		if(response)
		{
			if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);
          	if(strlen(inputtext) > 24 || strlen(inputtext) < 1) return ErrorText(playerid, "[ Мысли ]: Не меньше 1 и не больше 24 символов"), showDialogMenuDivision(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogMenuDivision(playerid);

			format(store, sizeof(store), "%s", inputtext);
            cmd_divinvite(playerid, store);
		}
		else showDialogMenuDivision(playerid);
	}
	return 1;
}

stock DivisionSave(g, i) // Сохраняем в базу (моментальное сохранение при любом изменении)
{
    // Экранируем текстовые строки (Для защиты от sql инъекций)
    new escapeName[MAX_NAME_DIVISION_LENGTH], escapeAbbreviation[MAX_NAME_DIVISION_ABBREVIATION_LENGTH], escapeColorHex[7];
	mysql_escape_string(DivisionInfo[g][i][divName], escapeName, sizeof(escapeName));
    mysql_escape_string(DivisionInfo[g][i][divAbbreviation], escapeAbbreviation, sizeof(escapeAbbreviation));
	mysql_escape_string(DivisionInfo[g][i][divColorHex], escapeColorHex, sizeof(escapeColorHex));

    // Формируем запросы в переменную
    format(big_query,sizeof(big_query),"UPDATE `division` SET `divRanks` = '%d', `divName` = '%s', `divAbbreviation` = '%s', `divSpawnPos0` = '%f',\
	`divSpawnPos1` = '%f', `divSpawnPos2` = '%f', `divSpawnPos3` = '%f'",
    DivisionInfo[g][i][divRanks], escapeName, escapeAbbreviation, DivisionInfo[g][i][divSpawnPos][0], DivisionInfo[g][i][divSpawnPos][1],
	DivisionInfo[g][i][divSpawnPos][2], DivisionInfo[g][i][divSpawnPos][3]);

    format(big_query,sizeof(big_query),"%s, `divSpawnWorld` = '%d', `divSpawnInterior` = '%d', `divColorHex` = '%s',\
	`divColorVeh0` = '%d', `divColorVeh1` = '%d' WHERE `org`='%d' AND `divid`='%d'", big_query,
    DivisionInfo[g][i][divSpawnWorld], DivisionInfo[g][i][divSpawnInterior], escapeColorHex, DivisionInfo[g][i][divColorVeh][0], DivisionInfo[g][i][divColorVeh][1], g, i);

    // Отправляем запрос
    query_empty(pearsq, big_query);
    return 1;
}

stock DivisionSaveRankName(g, i, r) // Сохраняем название ранга в базу (моментальное сохранение)
{
	// Экранируем текстовые строки (Для защиты от sql инъекций)
    new escapeRankName[MAX_NAME_DIVISION_LENGTH];
	mysql_escape_string(DivisionRankName[g][i][r], escapeRankName, sizeof(escapeRankName));

    // Формируем запросы в переменную
    format(big_query,sizeof(big_query),"UPDATE `division` SET `divRankName%d` = '%s' WHERE `org`='%d' AND `divid`='%d'",
    r, escapeRankName, g, i);

    // Отправляем запрос
    query_empty(pearsq, big_query);
	return 1;
}

function LoadDivision() // Загрузка из базы
{
	new time = GetTickCount(); // Записываем текущий tick (чтобы узнать время загрузки в ms)
	new rows, g, i, load_max_rank;
	cache_get_row_count(rows); // Получаем количество найденных строк
	for(new f = 0; f < rows; f++)
	{
    	cache_get_value_name_int(f, "org", g); // Получаем id организации
		cache_get_value_name_int(f, "divid", i); // Получаем id подфракции

    	cache_get_value_name_int(f, "divRanks", DivisionInfo[g][i][divRanks]);
		cache_get_value_name(f, "divName", DivisionInfo[g][i][divName], MAX_NAME_DIVISION_LENGTH);
		cache_get_value_name(f, "divAbbreviation", DivisionInfo[g][i][divAbbreviation], MAX_NAME_DIVISION_ABBREVIATION_LENGTH);
		cache_get_value_name_float(f, "divSpawnPos0", DivisionInfo[g][i][divSpawnPos][0]);
		cache_get_value_name_float(f, "divSpawnPos1", DivisionInfo[g][i][divSpawnPos][1]);
		cache_get_value_name_float(f, "divSpawnPos2", DivisionInfo[g][i][divSpawnPos][2]);
		cache_get_value_name_float(f, "divSpawnPos3", DivisionInfo[g][i][divSpawnPos][3]);
		cache_get_value_name_int(f, "divSpawnWorld", DivisionInfo[g][i][divSpawnWorld]);
		cache_get_value_name_int(f, "divSpawnInterior", DivisionInfo[g][i][divSpawnInterior]);
		cache_get_value_name(f, "divColorHex", DivisionInfo[g][i][divColorHex], 7);
		cache_get_value_name_int(f, "divColorVeh0", DivisionInfo[g][i][divColorHex][0]);
		cache_get_value_name_int(f, "divColorVeh1", DivisionInfo[g][i][divColorHex][1]);

		// Если нет никакого цвета у подфракции, присвоим серенький
		if(!strcmp(DivisionInfo[g][i][divColorHex],"0",true)) format(DivisionInfo[g][i][divColorHex],7,"cccccc");

		// Получаем названия рангов
		if(DivisionInfo[g][i][divRanks] > 0)
		{
			load_max_rank = DivisionInfo[g][i][divRanks];
			if(DivisionInfo[g][i][divRanks] > MAX_RANK_ORG) load_max_rank = MAX_RANK_ORG;

			for(new r = 0; r < load_max_rank; r++)
			{
				format(store,sizeof(store),"divRankName%d",r);
				cache_get_value_name(f, store, DivisionRankName[g][i][r], MAX_NAME_DIVISION_LENGTH);
			}
		}
	}
	printf("[MODE]: Подфракции [%d ms]", GetTickCount() - time);
	return 1;
}
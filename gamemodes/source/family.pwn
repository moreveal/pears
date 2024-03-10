
#define MAX_FAMILY 501 // Максимальное количество семей
#define MAX_NAME_FAMILY_LENGTH 31 // Длинна названий в семьях (Если указано 31, значит максимальное количество символов 30, всегда -1 слот)
#define MAX_RANK_FAMILY 30 // Максимальное количество рангов в семье
#define MAX_CHECKPOINT 60 // Максимальное количество чекпоинтов

enum fInfo
{
    fIds, // Нумерация в таблице MySQL
	fOwner, // ID аккаунта владельца семьи
	fSost, // Состояние (Оформлен Семья или нет)
	fName[MAX_NAME_FAMILY_LENGTH], // Название Семьи
	fOsn[21], // Основатель Семьи
    fRanks, // Количество рангов в семье
	Float:fSpawnX, // Координата спавна участников семьи
	Float:fSpawnY, // Координата спавна участников семьи
	Float:fSpawnZ, // Координата спавна участников семьи
	Float:fSpawnA, // Координата спавна участников семьи
	fInt, // Интерьер Спавна
	fWorld, // Виртуальный Мир Спавна
	fStatusUch, // Максимальное количество участников ( 0 - десять, 1 - не ограничено )
	fStatusRank, // Подключены донат ранги или нет ( 0 - нет, 1 - да )
	fStatusSpawn, // Подключен спавн семьи или нет ( 0 - нет, 1 - да )
	fStatusGarage, // Подключён гараж семьи или нет ( 0 - нет, 1 - да )
	fDop1, // Текущее количество участников в семье
	fDop2, // Запасные Пункты 2
	fDop3, // Запасные Пункты 3
	fDop4, // Запасные Пункты 4
	fDop5, // Запасные Пункты 5
	fMoney, // Банковский счёт семьи
	fInvmon, // Открыт или Закрыт Счёт
	fAccoff, // Права на просмотр офлайн списка
	fAccdip, // Права на дипломатию
	fAccmoninv, // Права на закрытие или открытия счёта семьи
	fAccmonget, // Права на снятие денег со счёта семьи
	fAccdom, // Права на подключение дома к семье
	fAccbiz, // Права на подключение бизнеса к семье
	fAccname, // Права на изменение названия семьи
	fAccrank, // Права на изменения рангов
	fAccspawn, // Права на изменение спавна
	fAccgarage, // Права на редактирование гаража
	fAcclog, // Права на использование логов
	fAccdon, // Права на донат семьи
	fAccveh, // Права на использование гаража
	fAccinv, // Права на /invitefam
	fAccuninv, // Права на /uninvitefam
	fAccgiver, // Права на /giverankfam
	fAccfammu, // Права на /fammute
	fAccfamfo, // Права на /famforce
	fLoss, // Счётчик неактивной семьи
	fVeh[10], // Автомобили в гараже
	fBiz[10], // Бизнесы Семьи
	fVehCol[2],
	fUpdate, // Параметр сохранения семьи
	fType, // Тип семьи (0 обычная, 1 ОПГ, 2 Партии, 3 Секта, 4 Street Racers, 5 Bikers)
	fParthnerMarket, // Бизнес партнеры Хот доги
	fParthnerBenz, // Бизнес партнеры Хот доги
	fParthnerService, // Бизнес партнеры Хот доги
	Float:fRoudLoad1X[60],
	Float:fRoudLoad1Y[60],
	Float:fRoudLoad1Z[60],
	Float:fRoudLoad2X[60],
	Float:fRoudLoad2Y[60],
	Float:fRoudLoad2Z[60],
	Float:fRoudLoad3X[60],
	Float:fRoudLoad3Y[60],
	Float:fRoudLoad3Z[60],
	Float:fRoudLoad4X[60],
	Float:fRoudLoad4Y[60],
	Float:fRoudLoad4Z[60],
	Float:fRoudLoad5X[60],
	Float:fRoudLoad5Y[60],
	Float:fRoudLoad5Z[60],
	fRoutIdEditor[5],
	fRoutIdCreator[5],
	fRoutUnix[5],
	fInfluence, // Влияние в секте ранги
	fInfluenceTemp, // Временное влияние за эфиры и обряды.
	fsUnixCNN, // Таймер на кд эфира
	fsUnixRite, // Таймер на кд обряда
	Float:fsAltarPos[6], // Позиция Тележки
	fsAltarStatus, // статус алтаря
	fsUnixAltar, // Восстановление алтаря
};
new FamilyInfo[MAX_FAMILY][fInfo];
new famwar[MAX_FAMILY][10];
new famuni[MAX_FAMILY][10];

new SektaObject[MAX_FAMILY];
new SektaObjectHealt[MAX_FAMILY];

new FamilyRoutNameCreator[MAX_FAMILY][5][24];
new FamilyRoutNameEditor[MAX_FAMILY][5][24];
new FamilyRankName[MAX_FAMILY][MAX_RANK_FAMILY][MAX_NAME_FAMILY_LENGTH]; // Названия рангов

new famTypeName[][] =
{
    "Семья", "ОПГ", "Партия", "Секта", "Street Racers"
};

stock GetFamilyTypePrice(type)
{
	if(type == 0) return 0;
	else return 500;
}

CMD:fam(playerid)
{
    if(checkFamilyPermission(playerid)) return 1; // Проверки разрешений семьи
    PlayerPlaySound(playerid,1150,0,0,0);
    showDialogFamilyMenu(playerid);
	return 1;
}
stock showDialogFamilyMenu(playerid)
{
    new f = PlayerInfo[playerid][pFamily];
    new line[100],lines[1700];

    format(line,sizeof(line),"%s\t", FamilyInfo[f][fName]), strcat(lines,line);
    if(Fame[playerid] == true) format(line,sizeof(line),"\n{cccccc}3D Название \t{99ff66}[ On ]"), strcat(lines,line);
    else if(Fame[playerid] == false) format(line,sizeof(line),"\n{cccccc}3D Название \t{FF6347}[ Off ]"), strcat(lines,line);
    format(line, sizeof(line), "\n{cccccc}Рация Семьи \t%s", PlayerInfo[playerid][pTransmitterOff][3] ? "{FF6347}[ Off ]" : "{99ff66}[ On ]");strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Участники {99ff66}[ Online ]\t"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Участники {FF6347}[ Offline ]\t"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Дипломатия"), strcat(lines,line);
	if(FamilyInfo[f][fInvmon] == 0) format(line,sizeof(line),"\n{cccccc}Счёт Семьи {99ff66}[ %d$ ]\t[ Открыт ]",FamilyInfo[f][fMoney]), strcat(lines,line);
	else if(FamilyInfo[f][fInvmon] == 1) format(line,sizeof(line),"\n{cccccc}Счёт Семьи {99ff66}[ %d$ ]\t{FF6347}[ Закрыт ]",FamilyInfo[f][fMoney]), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Синхронизация с Домом\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Синхронизация с Бизнесом\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Название Семьи\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Количество Рангов\t{666666}%d", FamilyInfo[f][fRanks]), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Названия Рангов\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Спавн\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Гараж\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Лог Семьи\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{ffcc00}Donate\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{999999}О семье..\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{999999}Система типов семьи\t"), strcat(lines,line);
	if(PlayerInfo[playerid][pID] == FamilyInfo[f][fOwner]) format(line,sizeof(line),"\n{ff9000}Права Доступа\t"), strcat(lines,line);
	ShowDialog(playerid,465,DIALOG_STYLE_TABLIST_HEADERS,"Family",lines,"Выбрать","Отмена");
    return 1;
}

CMD:frank(playerid)
{
    if(checkFamilyPermission(playerid)) return 1; // Проверки разрешений семьи

    new f = PlayerInfo[playerid][pFamily];
	if(PlayerInfo[playerid][pFamrank] < FamilyInfo[f][fAccrank])
	{
		new string[60];
		format(string,sizeof(string),"[ Мысли ]: Я не могу изменять ранги [ %d+ Ранг ]",FamilyInfo[f][fAccrank]);
		ErrorText(playerid, string);
		showDialogFamilyMenu(playerid);
		return 1;
	}
	if(FamilyInfo[f][fStatusRank] == 0) return ErrorText(playerid, "[ Мысли ]: В семье нельзя изменять названия рангов {ffcc00}[ /fam >> Donate ]"), showDialogFamilyMenu(playerid);
	if(FamilyInfo[f][fRanks] <= 0) return ErrorText(playerid, "{cccccc}[ Мысли ]: Мне нужно указать количество рангов, прежде чем редактировать названия"), showDialogFamilyMenu(playerid);

	showDialogSettingFamilyRank(playerid);
	return 1;
}

stock showDialogSettingFamilyRank(playerid)
{
    new f = PlayerInfo[playerid][pFamily];
    new line[90],lines[4096];
    format(line,sizeof(line),"Ранг\tНазвание"), strcat(lines,line);

    for(new r = 0; r < FamilyInfo[f][fRanks]; r++)
	{
		if(r == FamilyInfo[f][fRanks]-1) format(line,sizeof(line),"\n{ff9000}%d. \t%s", r+1, FamilyRankName[f][r]), strcat(lines,line); // Ранг руководителя семьи
		else format(line,sizeof(line),"\n{ff9000}%d. \t{cccccc}%s", r+1, FamilyRankName[f][r]), strcat(lines,line); // Прочие ранги
	}
	ShowDialog(playerid,468,DIALOG_STYLE_TABLIST_HEADERS,"Family",lines,"Выбрать","Выход");
    return 1;
}

stock dialogCase_Family(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == 468) // Названия рангов
	{
        if(response)
		{
			if(listitem < 0 || listitem >= MAX_RANK_FAMILY) return 0;
			DP[0][playerid] = listitem; // Сохраняем id выбранного ранга

			new string[160];
			format(string,sizeof(string),"{cccccc}Введите название %d ранга [1 - %d символов]\n\n{333333}Вы можете использовать любые цветовые коды {cccccc}{ 0088ff } {333333}(Без пробелов)", listitem + 1, MAX_NAME_FAMILY_LENGTH-1);
			ShowDialog(playerid,469,DIALOG_STYLE_INPUT,"Family",string,"Принять","Отмена");
		}
		else showDialogFamilyMenu(playerid);
	}
	else if(dialogid == 469) // Изменение Названия Рангов
	{
		if(response)
		{
            if(checkFamilyPermission(playerid)) return 1; // Проверки разрешений семьи

            if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogSettingFamilyRank(playerid);

			new string[160];
          	if(strlen(inputtext) < 1 || strlen(inputtext) >= MAX_NAME_FAMILY_LENGTH) return format(string,sizeof(string),"[ Мысли ]: Не меньше 1 и не больше %d символов", MAX_NAME_FAMILY_LENGTH-1), ErrorText(playerid, string), showDialogSettingFamilyRank(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogSettingFamilyRank(playerid);

            new f = PlayerInfo[playerid][pFamily];
            new r = DP[0][playerid];
            format(FamilyRankName[f][r], MAX_NAME_FAMILY_LENGTH, "%s", inputtext);

            format(string, sizeof(string), "{66ffff}Family {ffcc00}%s изменил%s название %d ранга {cccccc}[ %s ]", PlayerInfo[playerid][pName], gender(playerid), r + 1, inputtext);
      		SendFamilyMessage(PlayerInfo[playerid][pFamily], COLOR_YELLOW, string);

			format(string, sizeof(string), "[ Мысли ]: Я изменил%s название %d ранга: %s", gender(playerid), r, inputtext);
			SendClientMessage(playerid, COLOR_GREY, string);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogSettingFamilyRank(playerid); // Открываем меню настройки
			FamilySaveRankName(f, r); // Сохраняем

            FamilyLog(f, "frank", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", r + 1, inputtext);
      		return 1;
		}
	}
	else if(dialogid == 487) // Количество рангов
	{
		if(response)
		{
			if(checkFamilyPermission(playerid)) return 1; // Проверки разрешений семьи

			new input, f = PlayerInfo[playerid][pFamily];
			if(PlayerInfo[playerid][pFamrank] < FamilyInfo[f][fAccrank] && FamilyInfo[f][fOwner] != PlayerInfo[playerid][pID])
			{
				new string[60];
				format(string,sizeof(string),"[ Мысли ]: Я не могу изменять ранги [ %d+ Ранг ]",FamilyInfo[f][fAccrank]);
				ErrorText(playerid, string);
				showDialogFamilyMenu(playerid);
				return 1;
			}
			if(sscanf(inputtext, "i", input)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), cmd_fam(playerid);

			new string[100];
			if(input > MAX_RANK_FAMILY || input < 2) return format(string,sizeof(string),"[ Мысли ]: Не меньше 2 и не больше %d рангов", MAX_RANK_FAMILY), ErrorText(playerid, string), cmd_fam(playerid);

			if(FamilyInfo[f][fRanks] == input) return ErrorText(playerid, "[ Мысли ]: Это количество рангов уже указано"), cmd_fam(playerid);
			FamilyInfo[f][fRanks] = input;
			FamilyInfo[f][fUpdate] = 1;

			PlayerInfo[playerid][pFamrank] = input;
			mysql_save(playerid, 13);

			format(string, sizeof(string), "{66ffff}Family {ffcc00}%s изменил%s количество рангов в семье {cccccc}[ %d ]", PlayerInfo[playerid][pName], gender(playerid), input);
      		SendFamilyMessage(PlayerInfo[playerid][pFamily], COLOR_YELLOW, string);

			format(string, sizeof(string), "[ Мысли ]: Я изменил%s количество рангов в семье на %d", gender(playerid), input);
			SendClientMessage(playerid, COLOR_GREY, string);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			cmd_fam(playerid);

            FamilyLog(f, "franks", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", input, "Количество рангов");
		}
		else cmd_fam(playerid);
	}
    return 1;
}

stock checkFamilyPermission(playerid) // Проверки разрешений семьи (чтобы не дублировать одну и ту-же херню в каждую команду)
{
    if(PlayerInfo[playerid][pFamily] == 0)
    {
        ErrorMessage(playerid, "{FF6347}У вас нет семьи");
        return 1;
    }
	new f = PlayerInfo[playerid][pFamily];
    if(FamilyInfo[f][fSost] == 0 || f >= MAX_FAMILY)
    {
        ErrorMessage(playerid, "{FF6347}Ошибка! Семья не создана или была удалена"), PlayerInfo[playerid][pFamily] = 0;
        return 1;
    }
	return 0;
}

public LoadFamily()
{
	new time = GetTickCount();
	new rows, load_max_rank, string[30];
	cache_get_row_count(rows);
	for(new f; f<rows; ++f)
	{
		new strocaX[600];
		new strocaY[600];
		new strocaZ[600];
		new FamRoutX[60][9];
		new FamRoutY[60][9];
		new FamRoutZ[60][9];
		new idx;
		cache_get_value_name_int(f, "id", idx);
		cache_get_value_name_int(f, "id", FamilyInfo[idx][fIds]);
		cache_get_value_name_int(f, "akka", FamilyInfo[idx][fOwner]);
		cache_get_value_name_int(f, "sost", FamilyInfo[idx][fSost]);
    	cache_get_value_name(f, "name", FamilyInfo[idx][fName], 34);
    	cache_get_value_name(f, "osn", FamilyInfo[idx][fOsn], 24);
		cache_get_value_name_int(f, "fRanks", FamilyInfo[idx][fRanks]);
    	cache_get_value_name_float(f, "spawnx", FamilyInfo[idx][fSpawnX]);
    	cache_get_value_name_float(f, "spawny", FamilyInfo[idx][fSpawnY]);
    	cache_get_value_name_float(f, "spawnz", FamilyInfo[idx][fSpawnZ]);
    	cache_get_value_name_float(f, "spawna", FamilyInfo[idx][fSpawnA]);
    	cache_get_value_name_int(f, "int", FamilyInfo[idx][fInt]);
    	cache_get_value_name_int(f, "world", FamilyInfo[idx][fWorld]);
    	cache_get_value_name_int(f, "statusuch", FamilyInfo[idx][fStatusUch]);
    	cache_get_value_name_int(f, "statusrank", FamilyInfo[idx][fStatusRank]);
    	cache_get_value_name_int(f, "statusspawn", FamilyInfo[idx][fStatusSpawn]);
    	cache_get_value_name_int(f, "statusgarage", FamilyInfo[idx][fStatusGarage]);
		cache_get_value_name_int(f, "dop1", FamilyInfo[idx][fDop1]);
		cache_get_value_name_int(f, "dop2", FamilyInfo[idx][fDop2]);
		cache_get_value_name_int(f, "dop3", FamilyInfo[idx][fDop3]);
		cache_get_value_name_int(f, "dop4", FamilyInfo[idx][fDop4]);
		cache_get_value_name_int(f, "dop5", FamilyInfo[idx][fDop5]);
		cache_get_value_name_int(f, "Mon", FamilyInfo[idx][fMoney]);
		cache_get_value_name_int(f, "Accoff", FamilyInfo[idx][fAccoff]);
		cache_get_value_name_int(f, "Accdip", FamilyInfo[idx][fAccdip]);
		cache_get_value_name_int(f, "Accmoninv", FamilyInfo[idx][fAccmoninv]);
		cache_get_value_name_int(f, "Accmonget", FamilyInfo[idx][fAccmonget]);
		cache_get_value_name_int(f, "Accdom", FamilyInfo[idx][fAccdom]);
		cache_get_value_name_int(f, "Accbiz", FamilyInfo[idx][fAccbiz]);
		cache_get_value_name_int(f, "Accname", FamilyInfo[idx][fAccname]);
		cache_get_value_name_int(f, "Accrank", FamilyInfo[idx][fAccrank]);
		cache_get_value_name_int(f, "Accspawn", FamilyInfo[idx][fAccspawn]);
		cache_get_value_name_int(f, "Accgarage", FamilyInfo[idx][fAccgarage]);
		cache_get_value_name_int(f, "Acclog", FamilyInfo[idx][fAcclog]);
		cache_get_value_name_int(f, "Accdon", FamilyInfo[idx][fAccdon]);
		cache_get_value_name_int(f, "Accveh", FamilyInfo[idx][fAccveh]);
		cache_get_value_name_int(f, "Accinv", FamilyInfo[idx][fAccinv]);
		cache_get_value_name_int(f, "Accuninv", FamilyInfo[idx][fAccuninv]);
		cache_get_value_name_int(f, "Accgiver", FamilyInfo[idx][fAccgiver]);
		cache_get_value_name_int(f, "Accfammu", FamilyInfo[idx][fAccfammu]);
		cache_get_value_name_int(f, "Accfamfo", FamilyInfo[idx][fAccfamfo]);
		cache_get_value_name_int(f, "Lossf", FamilyInfo[idx][fLoss]);
		cache_get_value_name_int(f, "war1", famwar[idx][0]);
		cache_get_value_name_int(f, "war2", famwar[idx][1]);
		cache_get_value_name_int(f, "war3", famwar[idx][2]);
		cache_get_value_name_int(f, "war4", famwar[idx][3]);
		cache_get_value_name_int(f, "war5", famwar[idx][4]);
		cache_get_value_name_int(f, "war6", famwar[idx][5]);
		cache_get_value_name_int(f, "war7", famwar[idx][6]);
		cache_get_value_name_int(f, "war8", famwar[idx][7]);
		cache_get_value_name_int(f, "war9", famwar[idx][8]);
		cache_get_value_name_int(f, "war10", famwar[idx][9]);
		cache_get_value_name_int(f, "union1", famuni[idx][0]);
		cache_get_value_name_int(f, "union2", famuni[idx][1]);
		cache_get_value_name_int(f, "union3", famuni[idx][2]);
		cache_get_value_name_int(f, "union4", famuni[idx][3]);
		cache_get_value_name_int(f, "union5", famuni[idx][4]);
		cache_get_value_name_int(f, "union6", famuni[idx][5]);
		cache_get_value_name_int(f, "union7", famuni[idx][6]);
		cache_get_value_name_int(f, "union8", famuni[idx][7]);
		cache_get_value_name_int(f, "union9", famuni[idx][8]);
		cache_get_value_name_int(f, "union10", famuni[idx][9]);
		cache_get_value_name_int(f, "fveh0", FamilyInfo[idx][fVeh][0]);
		cache_get_value_name_int(f, "fveh1", FamilyInfo[idx][fVeh][1]);
		cache_get_value_name_int(f, "fveh2", FamilyInfo[idx][fVeh][2]);
		cache_get_value_name_int(f, "fveh3", FamilyInfo[idx][fVeh][3]);
		cache_get_value_name_int(f, "fveh4", FamilyInfo[idx][fVeh][4]);
		cache_get_value_name_int(f, "fveh5", FamilyInfo[idx][fVeh][5]);
		cache_get_value_name_int(f, "fveh6", FamilyInfo[idx][fVeh][6]);
		cache_get_value_name_int(f, "fveh7", FamilyInfo[idx][fVeh][7]);
		cache_get_value_name_int(f, "fveh8", FamilyInfo[idx][fVeh][8]);
		cache_get_value_name_int(f, "fveh9", FamilyInfo[idx][fVeh][9]);
		cache_get_value_name_int(f, "fbiz0", FamilyInfo[idx][fBiz][0]);
		cache_get_value_name_int(f, "fbiz1", FamilyInfo[idx][fBiz][1]);
		cache_get_value_name_int(f, "fbiz2", FamilyInfo[idx][fBiz][2]);
		cache_get_value_name_int(f, "fbiz3", FamilyInfo[idx][fBiz][3]);
		cache_get_value_name_int(f, "fbiz4", FamilyInfo[idx][fBiz][4]);
		cache_get_value_name_int(f, "fbiz5", FamilyInfo[idx][fBiz][5]);
		cache_get_value_name_int(f, "fbiz6", FamilyInfo[idx][fBiz][6]);
		cache_get_value_name_int(f, "fbiz7", FamilyInfo[idx][fBiz][7]);
		cache_get_value_name_int(f, "fbiz8", FamilyInfo[idx][fBiz][8]);
		cache_get_value_name_int(f, "fbiz9", FamilyInfo[idx][fBiz][9]);
		cache_get_value_name_int(f, "parthnerMarket", FamilyInfo[idx][fParthnerMarket]);
		cache_get_value_name_int(f, "parthnerBenz", FamilyInfo[idx][fParthnerBenz]);
		cache_get_value_name_int(f, "parthnerService", FamilyInfo[idx][fParthnerService]);
		cache_get_value_name_int(f, "vehcol1", FamilyInfo[idx][fVehCol][0]);
		cache_get_value_name_int(f, "vehcol2", FamilyInfo[idx][fVehCol][1]);
		cache_get_value_name_int(f, "type", FamilyInfo[idx][fType]);
		cache_get_value_name_int(f, "influence", FamilyInfo[idx][fInfluence]);
		cache_get_value_name_int(f, "unixcnn", FamilyInfo[idx][fsUnixCNN]);
		cache_get_value_name_int(f, "unixrite", FamilyInfo[idx][fsUnixRite]);
		cache_get_value_name_int(f, "influenceTemp", FamilyInfo[idx][fInfluenceTemp]);
		cache_get_value_name_float(f, "altarPosX", FamilyInfo[idx][fsAltarPos][0]);
		cache_get_value_name_float(f, "altarPosY", FamilyInfo[idx][fsAltarPos][1]);
		cache_get_value_name_float(f, "altarPosZ", FamilyInfo[idx][fsAltarPos][2]);
		cache_get_value_name_float(f, "altarPosXR", FamilyInfo[idx][fsAltarPos][3]);
		cache_get_value_name_float(f, "altarPosYR", FamilyInfo[idx][fsAltarPos][4]);
		cache_get_value_name_float(f, "altarPosZR", FamilyInfo[idx][fsAltarPos][5]);
		cache_get_value_name_int(f, "altarStatus", FamilyInfo[idx][fsAltarStatus]);

		if(FamilyInfo[idx][fType] == 3 && FamilyInfo[idx][fsAltarPos][0] != 0.0 && FamilyInfo[idx][fsAltarPos][0] != 0.0 && FamilyInfo[idx][fsAltarStatus] > 0)
		{
			SektaObjectHealt[idx] = 1000;
			SektaObject[idx] = CreateDynamicObject(19527, FamilyInfo[idx][fsAltarPos][0], FamilyInfo[idx][fsAltarPos][1], FamilyInfo[idx][fsAltarPos][2], FamilyInfo[idx][fsAltarPos][3], FamilyInfo[idx][fsAltarPos][4], FamilyInfo[idx][fsAltarPos][5],0,0);
		}
		for(new i; i < 5; i++)
		{
			format(string,sizeof(string),"routNameCreator%d",i+1);
			cache_get_value_name(f, string, FamilyRoutNameCreator[idx][i], 24);
			format(string,sizeof(string),"routNameEditor%d",i+1);
			cache_get_value_name(f, string, FamilyRoutNameEditor[idx][i], 24);
			format(string,sizeof(string),"routIdEditor%d",i+1);
			cache_get_value_name_int(f, string, FamilyInfo[idx][fRoutIdEditor][i]);
			format(string,sizeof(string),"routIdCreator%d",i+1);
			cache_get_value_name_int(f, string, FamilyInfo[idx][fRoutIdCreator][i]);
			format(string,sizeof(string),"routUnix%d",i+1);
			cache_get_value_name_int(f, string, FamilyInfo[idx][fRoutUnix][i]);
		}
   		if(FamilyInfo[idx][fMoney] < 0) FamilyInfo[idx][fMoney] = 0;

        // Получаем названия рангов
		if(FamilyInfo[idx][fRanks] > 0)
		{
			load_max_rank = FamilyInfo[idx][fRanks];
			if(FamilyInfo[idx][fRanks] > MAX_RANK_FAMILY) load_max_rank = MAX_RANK_FAMILY;

			for(new r = 0; r < load_max_rank; r++)
			{
				format(string,sizeof(string),"rank%d",r);
				cache_get_value_name(f, string, FamilyRankName[idx][r], MAX_NAME_FAMILY_LENGTH);
			}
		}

		//Грузим маршруты 1
		cache_get_value_name(f, "Rout1X", strocaX, 600);
		cache_get_value_name(f, "Rout1Y", strocaY, 600);
		cache_get_value_name(f, "Rout1Z", strocaZ, 600);
		split(strocaX,FamRoutX,'_');
		split(strocaY,FamRoutY,'_');
		split(strocaZ,FamRoutZ,'_');
		for(new i; i < 60; i++)
		{
			FamilyInfo[idx][fRoudLoad1X][i] = floatstr(FamRoutX[i]);
			FamilyInfo[idx][fRoudLoad1Y][i] = floatstr(FamRoutY[i]);
			FamilyInfo[idx][fRoudLoad1Z][i] = floatstr(FamRoutZ[i]);
			format(FamRoutX[i],9,"0");
			format(FamRoutY[i],9,"0");
			format(FamRoutZ[i],9,"0");
		}
		format(strocaX,sizeof(strocaX),""); // Очищаем strocaX
		format(strocaY,sizeof(strocaY),""); // Очищаем strocaX
		format(strocaZ,sizeof(strocaZ),""); // Очищаем strocaX
		//Грузим маршруты 2
		cache_get_value_name(f, "Rout2X", strocaX, 600);
		cache_get_value_name(f, "Rout2Y", strocaY, 600);
		cache_get_value_name(f, "Rout2Z", strocaZ, 600);
		split(strocaX,FamRoutX,'_');
		split(strocaY,FamRoutY,'_');
		split(strocaZ,FamRoutZ,'_');
		for(new i; i < 60; i++)
		{
			FamilyInfo[idx][fRoudLoad2X][i] = floatstr(FamRoutX[i]);
			FamilyInfo[idx][fRoudLoad2Y][i] = floatstr(FamRoutY[i]);
			FamilyInfo[idx][fRoudLoad2Z][i] = floatstr(FamRoutZ[i]);
			format(FamRoutX[i],9," ");
			format(FamRoutY[i],9," ");
			format(FamRoutZ[i],9," ");
		}
		format(strocaX,sizeof(strocaX),""); // Очищаем strocaX
		format(strocaY,sizeof(strocaY),""); // Очищаем strocaX
		format(strocaZ,sizeof(strocaZ),""); // Очищаем strocaX
		//Грузим маршруты 3
		cache_get_value_name(f, "Rout3X", strocaX, 600);
		cache_get_value_name(f, "Rout3Y", strocaY, 600);
		cache_get_value_name(f, "Rout3Z", strocaZ, 600);
		split(strocaX,FamRoutX,'_');
		split(strocaY,FamRoutY,'_');
		split(strocaZ,FamRoutZ,'_');
		for(new i; i < 60; i++)
		{
			FamilyInfo[idx][fRoudLoad3X][i] = floatstr(FamRoutX[i]);
			FamilyInfo[idx][fRoudLoad3Y][i] = floatstr(FamRoutY[i]);
			FamilyInfo[idx][fRoudLoad3Z][i] = floatstr(FamRoutZ[i]);
			format(FamRoutX[i],9," ");
			format(FamRoutY[i],9," ");
			format(FamRoutZ[i],9," ");
		}
		format(strocaX,sizeof(strocaX),""); // Очищаем strocaX
		format(strocaY,sizeof(strocaY),""); // Очищаем strocaX
		format(strocaZ,sizeof(strocaZ),""); // Очищаем strocaX
		//Грузим маршруты 4
		cache_get_value_name(f, "Rout4X", strocaX, 600);
		cache_get_value_name(f, "Rout4Y", strocaY, 600);
		cache_get_value_name(f, "Rout4Z", strocaZ, 600);
		split(strocaX,FamRoutX,'_');
		split(strocaY,FamRoutY,'_');
		split(strocaZ,FamRoutZ,'_');
		for(new i; i < 60; i++)
		{
			FamilyInfo[idx][fRoudLoad4X][i] = floatstr(FamRoutX[i]);
			FamilyInfo[idx][fRoudLoad4Y][i] = floatstr(FamRoutY[i]);
			FamilyInfo[idx][fRoudLoad4Z][i] = floatstr(FamRoutZ[i]);
			format(FamRoutX[i],9," ");
			format(FamRoutY[i],9," ");
			format(FamRoutZ[i],9," ");
		}
		format(strocaX,sizeof(strocaX),""); // Очищаем strocaX
		format(strocaY,sizeof(strocaY),""); // Очищаем strocaX
		format(strocaZ,sizeof(strocaZ),""); // Очищаем strocaX
		//Грузим маршруты 5
		cache_get_value_name(f, "Rout5X", strocaX, 600);
		cache_get_value_name(f, "Rout5Y", strocaY, 600);
		cache_get_value_name(f, "Rout5Z", strocaZ, 600);
		split(strocaX,FamRoutX,'_');
		split(strocaY,FamRoutY,'_');
		split(strocaZ,FamRoutZ,'_');
		for(new i; i < 60; i++)
		{
			FamilyInfo[idx][fRoudLoad5X][i] = floatstr(FamRoutX[i]);
			FamilyInfo[idx][fRoudLoad5Y][i] = floatstr(FamRoutY[i]);
			FamilyInfo[idx][fRoudLoad5Z][i] = floatstr(FamRoutZ[i]);
			format(FamRoutX[i],9," ");
			format(FamRoutY[i],9," ");
			format(FamRoutZ[i],9," ");
		}
		format(strocaX,sizeof(strocaX),""); // Очищаем strocaX
		format(strocaY,sizeof(strocaY),""); // Очищаем strocaX
		format(strocaZ,sizeof(strocaZ),""); // Очищаем strocaX
	}
	Kolfam = rows;
	printf("[MODE]: Семьи [%d Quan][%d ms]",rows,GetTickCount() - time);
	return 1;
}

stock SaveFamily(idx)
{
	new f_str1[MAX_NAME_FAMILY_LENGTH],f_str2[24];
	mysql_escape_string(FamilyInfo[idx][fName], f_str1, sizeof(f_str1));
	mysql_escape_string(FamilyInfo[idx][fOsn], f_str2, sizeof(f_str2));

	new string_mysql[2400];
	format(string_mysql, sizeof(string_mysql), "UPDATE `pp_family` SET `akka`='%d',`sost`='%d',`name`='%s',`osn`='%s',",
	FamilyInfo[idx][fOwner], FamilyInfo[idx][fSost],f_str1,f_str2); // 71 + 22 + 31 + 21
	format(string_mysql, sizeof(string_mysql), "%s`war1`='%d',`war2`='%d',`war3`='%d',`war4`='%d',`war5`='%d',`war6`='%d',`war7`='%d',`war8`='%d',`war9`='%d',`war10`='%d',\
	`union1`='%d',`union2`='%d',`union3`='%d',`union4`='%d',`union5`='%d',`union6`='%d',`union7`='%d',`union8`='%d',`union9`='%d',`union10`='%d',",  string_mysql,
	famwar[idx][0],famwar[idx][1],famwar[idx][2],famwar[idx][3],famwar[idx][4],famwar[idx][5],famwar[idx][6],famwar[idx][7],famwar[idx][8],famwar[idx][9],
	famuni[idx][0],famuni[idx][1],famuni[idx][2],famuni[idx][3],famuni[idx][4],famuni[idx][5],famuni[idx][6],famuni[idx][7],famuni[idx][8],famuni[idx][9]); // 269 + 220
	format(string_mysql, sizeof(string_mysql), "%s`Accmoninv`='%d',`Accmonget`='%d',`Accdom`='%d',`Accbiz`='%d',`Accname`='%d',`Accrank`='%d',`Accspawn`='%d',`Accgarage`='%d',\
	`Acclog`='%d',`Accdon`='%d',`Accveh`='%d',`Accinv`='%d',`Accuninv`='%d',`Accgiver`='%d',`Accfammu`='%d',`Accfamfo`='%d',",  string_mysql,
	FamilyInfo[idx][fAccmoninv],FamilyInfo[idx][fAccmonget],FamilyInfo[idx][fAccdom],FamilyInfo[idx][fAccbiz],FamilyInfo[idx][fAccname],FamilyInfo[idx][fAccrank],FamilyInfo[idx][fAccspawn],FamilyInfo[idx][fAccgarage],
	FamilyInfo[idx][fAcclog],FamilyInfo[idx][fAccdon],FamilyInfo[idx][fAccveh],FamilyInfo[idx][fAccinv],FamilyInfo[idx][fAccuninv],FamilyInfo[idx][fAccgiver],
	FamilyInfo[idx][fAccfammu],FamilyInfo[idx][fAccfamfo]); // 252 + 176
	format(string_mysql, sizeof(string_mysql), "%s`fveh0`='%d',`fveh1`='%d',`fveh2`='%d',`fveh3`='%d',`fveh4`='%d',`fveh5`='%d',`fveh6`='%d',`fveh7`='%d',`fveh8`='%d',`fveh9`='%d',\
	`fbiz0`='%d',`fbiz1`='%d',`fbiz2`='%d',`fbiz3`='%d',`fbiz4`='%d',`fbiz5`='%d',`fbiz6`='%d',`fbiz7`='%d',`fbiz8`='%d',`fbiz9`='%d',", string_mysql,
	FamilyInfo[idx][fVeh][0],FamilyInfo[idx][fVeh][1],FamilyInfo[idx][fVeh][2],FamilyInfo[idx][fVeh][3],FamilyInfo[idx][fVeh][4],
	FamilyInfo[idx][fVeh][5],FamilyInfo[idx][fVeh][6],FamilyInfo[idx][fVeh][7],FamilyInfo[idx][fVeh][8],FamilyInfo[idx][fVeh][9],
	FamilyInfo[idx][fBiz][0],FamilyInfo[idx][fBiz][1],FamilyInfo[idx][fBiz][2],FamilyInfo[idx][fBiz][3],FamilyInfo[idx][fBiz][4],
	FamilyInfo[idx][fBiz][5],FamilyInfo[idx][fBiz][6],FamilyInfo[idx][fBiz][7],FamilyInfo[idx][fBiz][8],FamilyInfo[idx][fBiz][9]); // 267 + 220
	format(string_mysql, sizeof(string_mysql), "%s`spawnx`='%f',`spawny`='%f',`spawnz`='%f',`spawna`='%f',`int`='%d',`world`='%d',`statusuch`='%d',`statusrank`='%d',`statusgarage`='%d',\
	`statusspawn`='%d',`dop1`='%d',`dop2`='%d',`dop3`='%d',`dop4`='%d',`dop5`='%d',`Mon`='%d',`Accoff`='%d',`Accdip`='%d',`Lossf`='%d',`vehcol1`='%d',`vehcol2`='%d',`type`='%d',\
	`parthnerMarket`='%d',`parthnerBenz`='%d',`parthnerService`='%d',`influence`='%d',`fRanks`='%d' WHERE `id`='%d'", string_mysql,
	FamilyInfo[idx][fSpawnX],FamilyInfo[idx][fSpawnY],FamilyInfo[idx][fSpawnZ],FamilyInfo[idx][fSpawnA],FamilyInfo[idx][fInt],FamilyInfo[idx][fWorld],FamilyInfo[idx][fStatusUch],FamilyInfo[idx][fStatusRank],FamilyInfo[idx][fStatusGarage],
	FamilyInfo[idx][fStatusSpawn],FamilyInfo[idx][fDop1],FamilyInfo[idx][fDop2],FamilyInfo[idx][fDop3],FamilyInfo[idx][fDop4],FamilyInfo[idx][fDop5],
	FamilyInfo[idx][fMoney],FamilyInfo[idx][fAccoff],FamilyInfo[idx][fAccdip],FamilyInfo[idx][fLoss],FamilyInfo[idx][fVehCol][0],FamilyInfo[idx][fVehCol][1],
	FamilyInfo[idx][fType],FamilyInfo[idx][fParthnerMarket],FamilyInfo[idx][fParthnerBenz],FamilyInfo[idx][fParthnerService],
	FamilyInfo[idx][fInfluence],FamilyInfo[idx][fRanks],idx); // 416 + 253 + 80
	query_empty(pearsq, string_mysql);
	return true;
}

stock FamilySaveRankName(f, r) //  Сохраняем название ранга в базу (моментальное сохранение)
{
	// Экранируем текстовые строки (Для защиты от sql инъекций)
    new escapeRankName[MAX_NAME_FAMILY_LENGTH];
	mysql_escape_string(FamilyRankName[f][r], escapeRankName, sizeof(escapeRankName));

    // Формируем запросы в переменную
	new string_mysql[55 + 22 + MAX_NAME_FAMILY_LENGTH];
    format(string_mysql,sizeof(string_mysql),"UPDATE `pp_family` SET `rank%d` = '%s' WHERE `id`='%d'", r, escapeRankName, f);

    // Отправляем запрос
    query_empty(pearsq, string_mysql);
	return 1;
}

stock ColorFam1(f)
{
	new color[8];
	if(FamilyInfo[f][fType] == 3) format(color, 8, "333333");
    else format(color,8, "ffcc00");
	return color;
}
stock ColorFam2(f)
{
	new color[8];
	if(FamilyInfo[f][fType] == 3) format(color, 8, "950000");
    else format(color, 8, "99cccc");
	return color;
}


// Система чата в ВК
new LastMessageID;

stock CheckMessageFamilyChat()
{
	new string_mysql[100];
	format(string_mysql,sizeof(string_mysql),"SELECT * FROM `family_chat_messages` WHERE `TYPE` = '1' AND `ID` > '%d' LIMIT 30", LastMessageID);
	mysql_tquery(pearsq_2, string_mysql, "Call_loadmessagefamily", "");
	return 1;
}

function Call_loadmessagefamily()
{
	new rows;
	cache_get_row_count(rows);
	
	if(rows)
	{
		new userName[24], message[144], famId, string[300];
		for(new f; f < rows; ++f)
		{
			cache_get_value_name_int(f, "ID", LastMessageID);
			cache_get_value_name_int(f, "FAMILY", famId);
			cache_get_value_name(f, "NAME", userName, 24);
			cache_get_value_name(f, "MESSAGE", message, 144);

			format(string, sizeof(string), "[F] {%s}%s: {%s}(( %s ))", ColorFam1(famId), userName, ColorFam2(famId), message);
			SendFamilyMessage(famId, 0x66ffffAA, string);
		}
	}
	return 1;
}


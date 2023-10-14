
#define MAX_FAMILY 501 // Максимальное количество семей
#define MAX_NAME_FAMILY_LENGTH 31 // Длинна названий в семьях (Если указано 31, значит максимальное количество символов 30, всегда -1 слот)
#define MAX_RANK_FAMILY 30 // Максимальное количество рангов в семье

enum fInfo
{
    fIds, // Нумерация в таблице MySQL
	fAkka, // Номер управляющего аккаунта для семьи
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
};
new FamilyInfo[MAX_FAMILY][fInfo];
new famwar[MAX_FAMILY][10];
new famuni[MAX_FAMILY][10];

new FamilyRankName[MAX_FAMILY][MAX_RANK_FAMILY][MAX_NAME_FAMILY_LENGTH]; // Названия рангов

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
    format(lines,sizeof(lines),""); // Очищаем Lines

    format(line,sizeof(line),"%s\t", FamilyInfo[f][fName]), strcat(lines,line);
    if(Fame[playerid] == true) format(line,sizeof(line),"\n{cccccc}3D Название \t{99ff66}[ On ]"), strcat(lines,line);
    else if(Fame[playerid] == false) format(line,sizeof(line),"\n{cccccc}3D Название \t{FF6347}[ Off ]"), strcat(lines,line);
    if(Chat[1][playerid] == false) format(line,sizeof(line),"\n{cccccc}Рация Семьи \t{99ff66}[ On ]"), strcat(lines,line);
    else if(Chat[1][playerid] == true) format(line,sizeof(line),"\n{cccccc}Рация Семьи \t{FF6347}[ Off ]"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Участники {99ff66}[ Online ]\t"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Участники {FF6347}[ Offline ]\t"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Дипломатия"), strcat(lines,line);
	if(FamilyInfo[f][fInvmon] == 0) format(line,sizeof(line),"\n{cccccc}Счёт Семьи {99ff66}[ %d$ ]\t[ Открыт ]",FamilyInfo[f][fMoney]), strcat(lines,line);
	else if(FamilyInfo[f][fInvmon] == 1) format(line,sizeof(line),"{\ncccccc}Счёт Семьи {99ff66}[ %d$ ]\t{FF6347}[ Закрыт ]",FamilyInfo[f][fMoney]), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Синхронизация с Домом\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Синхронизация с Бизнесом\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Название Семьи\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Названия Рангов\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Спавн\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Гараж\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Лог Семьи\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{ffcc00}Donate\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{999999}О семье..\t"), strcat(lines,line);
	if(PlayerInfo[playerid][pFamrank] >= FamilyInfo[f][fRanks]) format(line,sizeof(line),"\n{ff9000}Права Доступа\t"), strcat(lines,line);
	ShowDialog(playerid,465,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Семья",lines,"Выбрать","Отмена");
    return 1;
}

CMD:frank(playerid)
{
    if(checkFamilyPermission(playerid)) return 1; // Проверки разрешений семьи

    new f = PlayerInfo[playerid][pFamily];
	if(PlayerInfo[playerid][pFamrank] < FamilyInfo[f][fAccrank]) return format(store,sizeof(store),"[ Мысли ]: Я не могу изменять ранги [ %d+ Ранг ]",FamilyInfo[f][fAccrank]), ErrorText(playerid, store), showDialogFamilyMenu(playerid);
	if(FamilyInfo[f][fStatusRank] == 0) return ErrorText(playerid, "[ Мысли ]: В семье нельзя изменять названия рангов {ffcc00}[ /fam >> Donate ]"), showDialogFamilyMenu(playerid);
	if(FamilyInfo[f][fRanks] <= 0) return ErrorText(playerid, "{cccccc}[ Мысли ]: Мне нужно указать количество рангов, прежде чем редактировать названия"), showDialogFamilyMenu(playerid);

	showDialogSettingFamilyRank(playerid);
	return 1;
}

stock showDialogSettingFamilyRank(playerid)
{
    new f = PlayerInfo[playerid][pFamily];
    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"Ранг\tНазвание"), strcat(lines,line);

    for(new r = 0; r < FamilyInfo[f][fRanks]; r++)
	{
		if(r == FamilyInfo[f][fRanks]-1) format(line,sizeof(line),"\n{ff9000}%d. \t%s", r+1, FamilyRankName[f][r]), strcat(lines,line); // Ранг руководителя семьи
		else format(line,sizeof(line),"\n{ff9000}%d. \t{cccccc}%s", r+1, FamilyRankName[f][r]), strcat(lines,line); // Прочие ранги
	}
	ShowDialog(playerid,468,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Семья",lines,"Выбрать","Выход");
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

			format(store,sizeof(store),"{cccccc}Введите название %d ранга [1 - %d символов]\n\n{333333}Вы можете использовать любые цветовые коды {cccccc}{ 0088ff } {333333}(Без пробелов)", listitem + 1, MAX_NAME_FAMILY_LENGTH-1);
			ShowDialog(playerid,469,DIALOG_STYLE_INPUT,"{ff9000}Семья",store,"Принять","Отмена");
		}
		else showDialogFamilyMenu(playerid);
	}
	if(dialogid == 469) // Изменение Названия Рангов
	{
		if(response)
		{
            if(checkFamilyPermission(playerid)) return 1; // Проверки разрешений семьи

            if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogSettingFamilyRank(playerid);
          	if(strlen(inputtext) < 1 || strlen(inputtext) >= MAX_NAME_FAMILY_LENGTH) return format(store,sizeof(store),"[ Мысли ]: Не меньше 1 и не больше %d символов", MAX_NAME_FAMILY_LENGTH-1), ErrorText(playerid, store), showDialogSettingFamilyRank(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogSettingFamilyRank(playerid);

            new f = PlayerInfo[playerid][pFamily];
            new r = DP[0][playerid];
            format(FamilyRankName[f][r], MAX_NAME_FAMILY_LENGTH, "%s", inputtext);

            format(store, sizeof(store), "{66ffff}Family {ffcc00}%s изменил%s название %d ранга {cccccc}[ %s ]", PlayerInfo[playerid][pName], gender(playerid), r + 1, inputtext);
      		SendFamilyMessage(PlayerInfo[playerid][pFamily], COLOR_YELLOW, store);

			format(store, sizeof(store), "[ Мысли ]: Я изменил%s название %d ранга: %s", gender(playerid), r, inputtext);
			SendClientMessage(playerid, COLOR_GREY, store);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogSettingFamilyRank(playerid); // Открываем меню настройки
			FamilySaveRankName(f, r); // Сохраняем

            FamilyLog(f, "frank", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", r + 1, inputtext);
      		return 1;
		}
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
	new rows, load_max_rank;
	cache_get_row_count(rows);
	for(new f; f<rows; ++f)
	{
		new idx;
		cache_get_value_name_int(f, "id", idx);
		cache_get_value_name_int(f, "id", FamilyInfo[idx][fIds]);
		cache_get_value_name_int(f, "akka", FamilyInfo[idx][fAkka]);
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
		cache_get_value_name_int(f, "vehcol1", FamilyInfo[idx][fVehCol][0]);
		cache_get_value_name_int(f, "vehcol2", FamilyInfo[idx][fVehCol][1]);
		cache_get_value_name_int(f, "type", FamilyInfo[idx][fType]);
   		if(FamilyInfo[idx][fMoney] < 0) FamilyInfo[idx][fMoney] = 0;

        // Получаем названия рангов
		if(FamilyInfo[idx][fRanks] > 0)
		{
			load_max_rank = FamilyInfo[idx][fRanks];
			if(FamilyInfo[idx][fRanks] > MAX_RANK_FAMILY) load_max_rank = MAX_RANK_FAMILY;

			for(new r = 0; r < load_max_rank; r++)
			{
				format(store,sizeof(store),"rank%d",r);
				cache_get_value_name(f, store, FamilyRankName[f][r], MAX_NAME_FAMILY_LENGTH);
			}
		}
        else FamilyInfo[f][fRanks] = 10;
	}
	Kolfam = rows;
	printf("[MODE]: Семьи [%d Quan][%d ms]",rows,GetTickCount() - time);
	return 1;
}

stock SaveFamily(idx)
{
	new f_str1[34],f_str2[24];
	mysql_escape_string(FamilyInfo[idx][fName], f_str1, sizeof(f_str1));
	mysql_escape_string(FamilyInfo[idx][fOsn], f_str2, sizeof(f_str2));
	format(big_query, sizeof(big_query), "UPDATE `pp_family` SET `akka`='%d',`sost`='%d',`name`='%s',\
	`osn`='%s',",FamilyInfo[idx][fAkka], FamilyInfo[idx][fSost],f_str1,
	f_str2);
	format(big_query, sizeof(big_query), "%s`war1`='%d',`war2`='%d',`war3`='%d',`war4`='%d',`war5`='%d',`war6`='%d',`war7`='%d',`war8`='%d',`war9`='%d',`war10`='%d',\
	`union1`='%d',`union2`='%d',`union3`='%d',`union4`='%d',`union5`='%d',`union6`='%d',`union7`='%d',`union8`='%d',`union9`='%d',`union10`='%d',",  big_query,
	famwar[idx][0],famwar[idx][1],famwar[idx][2],famwar[idx][3],famwar[idx][4],famwar[idx][5],famwar[idx][6],famwar[idx][7],famwar[idx][8],famwar[idx][9],
	famuni[idx][0],famuni[idx][1],famuni[idx][2],famuni[idx][3],famuni[idx][4],famuni[idx][5],famuni[idx][6],famuni[idx][7],famuni[idx][8],famuni[idx][9]);
	format(big_query, sizeof(big_query), "%s`Accmoninv`='%d',`Accmonget`='%d',`Accdom`='%d',`Accbiz`='%d',`Accname`='%d',`Accrank`='%d',`Accspawn`='%d',`Accgarage`='%d',\
	`Acclog`='%d',`Accdon`='%d',`Accveh`='%d',`Accinv`='%d',`Accuninv`='%d',`Accgiver`='%d',`Accfammu`='%d',`Accfamfo`='%d',",  big_query,
	FamilyInfo[idx][fAccmoninv],FamilyInfo[idx][fAccmonget],FamilyInfo[idx][fAccdom],FamilyInfo[idx][fAccbiz],FamilyInfo[idx][fAccname],FamilyInfo[idx][fAccrank],FamilyInfo[idx][fAccspawn],FamilyInfo[idx][fAccgarage],
	FamilyInfo[idx][fAcclog],FamilyInfo[idx][fAccdon],FamilyInfo[idx][fAccveh],FamilyInfo[idx][fAccinv],FamilyInfo[idx][fAccuninv],FamilyInfo[idx][fAccgiver],FamilyInfo[idx][fAccfammu],FamilyInfo[idx][fAccfamfo]);
	format(big_query, sizeof(big_query), "%s`fveh0`='%d',`fveh1`='%d',`fveh2`='%d',`fveh3`='%d',`fveh4`='%d',`fveh5`='%d',`fveh6`='%d',`fveh7`='%d',`fveh8`='%d',`fveh9`='%d',\
	`fbiz0`='%d',`fbiz1`='%d',`fbiz2`='%d',`fbiz3`='%d',`fbiz4`='%d',`fbiz5`='%d',`fbiz6`='%d',`fbiz7`='%d',`fbiz8`='%d',`fbiz9`='%d',", big_query,
	FamilyInfo[idx][fVeh][0],FamilyInfo[idx][fVeh][1],FamilyInfo[idx][fVeh][2],FamilyInfo[idx][fVeh][3],FamilyInfo[idx][fVeh][4],
	FamilyInfo[idx][fVeh][5],FamilyInfo[idx][fVeh][6],FamilyInfo[idx][fVeh][7],FamilyInfo[idx][fVeh][8],FamilyInfo[idx][fVeh][9],
	FamilyInfo[idx][fBiz][0],FamilyInfo[idx][fBiz][1],FamilyInfo[idx][fBiz][2],FamilyInfo[idx][fBiz][3],FamilyInfo[idx][fBiz][4],
	FamilyInfo[idx][fBiz][5],FamilyInfo[idx][fBiz][6],FamilyInfo[idx][fBiz][7],FamilyInfo[idx][fBiz][8],FamilyInfo[idx][fBiz][9]);
	format(big_query, sizeof(big_query), "%s`spawnx`='%f',`spawny`='%f',`spawnz`='%f',`spawna`='%f',`int`='%d',`world`='%d',`statusuch`='%d',`statusrank`='%d',`statusgarage`='%d',\
	`statusspawn`='%d',`dop1`='%d',`dop2`='%d',`dop3`='%d',`dop4`='%d',`dop5`='%d',`Mon`='%d',`Accoff`='%d',`Accdip`='%d',`Lossf`='%d',`vehcol1`='%d',`vehcol2`='%d',`type`='%d' WHERE `id`='%d'", big_query,
	FamilyInfo[idx][fSpawnX],FamilyInfo[idx][fSpawnY],FamilyInfo[idx][fSpawnZ],FamilyInfo[idx][fSpawnA],FamilyInfo[idx][fInt],FamilyInfo[idx][fWorld],FamilyInfo[idx][fStatusUch],FamilyInfo[idx][fStatusRank],FamilyInfo[idx][fStatusGarage],
	FamilyInfo[idx][fStatusSpawn],FamilyInfo[idx][fDop1],FamilyInfo[idx][fDop2],FamilyInfo[idx][fDop3],FamilyInfo[idx][fDop4],FamilyInfo[idx][fDop5],FamilyInfo[idx][fMoney],FamilyInfo[idx][fAccoff],FamilyInfo[idx][fAccdip],FamilyInfo[idx][fLoss],FamilyInfo[idx][fVehCol][0],FamilyInfo[idx][fVehCol][1],FamilyInfo[idx][fType],
	idx);
	query_empty(pearsq, big_query);
	return true;
}

stock FamilySaveRankName(f, r) //  Сохраняем название ранга в базу (моментальное сохранение)
{
	// Экранируем текстовые строки (Для защиты от sql инъекций)
    new escapeRankName[MAX_NAME_FAMILY_LENGTH];
	mysql_escape_string(FamilyRankName[f][r], escapeRankName, sizeof(escapeRankName));

    // Формируем запросы в переменную
    format(big_query,sizeof(big_query),"UPDATE `pp_family` SET `rank%d` = '%s' WHERE `id`='%d'",
    r, escapeRankName, f);

    // Отправляем запрос
    query_empty(pearsq, big_query);
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
	format(store_query,sizeof(store_query),"SELECT * FROM `family_chat_messages` WHERE `TYPE` = '1' AND `ID` > '%d'", LastMessageID);
	mysql_tquery(pearsq_2, store_query, "Call_loadmessagefamily", "");
	return 1;
}

function Call_loadmessagefamily()
{
	new rows;
	cache_get_row_count(rows);
	
	if(rows)
	{
		new userName[24], message[144], famId;
		for(new f; f < rows; ++f)
		{
			cache_get_value_name_int(f, "ID", LastMessageID);
			cache_get_value_name_int(f, "FAMILY", famId);
			cache_get_value_name(f, "NAME", userName, 24);
			cache_get_value_name(f, "MESSAGE", message, 144);

			format(store, sizeof(store), "[F] {%s}%s: {%s}(( %s ))", ColorFam1(famId), userName, ColorFam2(famId), message);
			SendFamilyMessage(famId, 0x66ffffAA, store);
		}
	}
	return 1;
}


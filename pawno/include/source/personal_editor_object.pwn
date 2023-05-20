
enum peoEnum // Enum отвечающий за личный редактор объектов
{
    bool:peoInEditor, // Статус - находится ли игрок внутри редактора

    // Переменные отвечающие за загруженный интерьер (для админов, он может быть и чужим)
    peoNewid, // id из базы данных
    bool:peoLoaded, // Статус - загружен из базы или нет
    peoName[34], // Название интерьера
    peoQuanUpdates, // Количество изменений в интерьере с момента сохранения или загрузки
    peoQuanObjects, // Количество объектов в интерьере
    peoCreatorId, // ID создателя интерьера
    peoCreatorName[24], // Имя создателя интерьера
    bool:peoStatusLoad, // Статус загружается ли интерьер в данный момент
    peoPriceInterior, // Стоимость интерьера без учёта мебели и текстур
    peoPublicationStatus, // Статус публикации интерьера в шоурум

    // Переменные отвечающие за объекты
    peoObject[MAX_OBJECT_INT], // ID Объекта присваеваемый в Streamer
    peoModel[MAX_OBJECT_INT], // id модели объекта
    Float:peoX[MAX_OBJECT_INT], // координата объекта
    Float:peoY[MAX_OBJECT_INT], // координата объекта
    Float:peoZ[MAX_OBJECT_INT], // координата объекта
    Float:peoRX[MAX_OBJECT_INT], // координата объекта
    Float:peoRY[MAX_OBJECT_INT], // координата объекта
    Float:peoRZ[MAX_OBJECT_INT], // координата объекта
};
new peoInfo[MAX_REALPLAYERS][peoEnum];
new peoTexture[MAX_REALPLAYERS][MAX_OBJECT_INT][MAX_TEXTURES_ON_OBJECTS]; // Переменные хранения текстур на объекте

stock showDialogPersonalEditor(playerid, targetid)
{
    format(lines,sizeof(lines),""); // Очищаем Lines

    format(line,sizeof(line),"Изменений: %d \t Объектов: %d", peoInfo[targetid][peoQuanUpdates], peoInfo[targetid][peoQuanObjects]), strcat(lines,line);

    format(line,sizeof(line),"\n{cccccc}Выйти из редактора {FF6347}>> \t "), strcat(lines,line);
    format(line,sizeof(line),"\n{ff9000}Загрузить интерьер \t "), strcat(lines,line);

    format(line,sizeof(line),"\n{99ff66}Сохранить \t "), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Название интерьера \t {FF9000}%s", peoInfo[targetid][peoName]), strcat(lines,line);

    ShowDialog(playerid,1292,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Редактор Интерьера",lines,"Выбрать","Выход");
    return 1;
}

CMD:editor(playerid) // Команда для открытия диалогового окна с управлением редактором
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");
    showDialogPersonalEditor(playerid, playerid);
    return 1;
}

forward Call_checkname_loadinterior(playerid, race_check, str_name[]); // Ищем ID аккаунта, если игрок Offline
public Call_checkname_loadinterior(playerid, race_check, str_name[])
{
    new rows;
    cache_get_row_count(rows);
    if(g_MysqlRaceCheck[playerid] != race_check) return Kick(playerid);
    if(!rows) return ErrorMessage(playerid, "{FF6347}Такого аккаунта не существует");

    new userId;
    cache_get_value_name_int(0, "id", userId);

    goloadInterior(playerid, userId, str_name);
    return 1;
}

stock goloadInterior(playerid, userId, str_name[]) // Начинаем загрузку интерьера
{
    if(peoInfo[playerid][peoStatusLoad]) return ErrorMessage(playerid, "{FF6347}Ошибка! Вы уже загружаете интерьер\nДождитесь завершения загрузки");

    new playerIdFind = -1;
    foreach(Player,i)
    {
        if(!peoInfo[i][peoLoaded]) continue;
        if(peoInfo[i][peoCreatorId] == userId)
        {
            playerIdFind = i;
            break;
        }
    }
    if(playerIdFind >= 0) return format(store,sizeof(store),"{FF6347}Интерьер %s уже загружен на аккаунт %s[%d]", str_name, PlayerInfo[playerIdFind][pName], playerIdFind), ErrorMessage(playerid, store);

    DP[0][playerid] = 1; // Загрузка интерьера
    DialogLoadInterior(playerid);

    peoInfo[playerid][peoStatusLoad] = true;
    format(big_query,sizeof(big_query),"SELECT * FROM `pp_peo_information` WHERE `userId` = '%d'", userId);
	mysql_tquery(pearsq, big_query, "Call_loadinterior_information", "ddds", playerid, g_MysqlRaceCheck[playerid], userId, str_name);
    return 1;
}

forward Call_loadinterior_information(playerid, race_check, userId, str_name[]);
public Call_loadinterior_information(playerid, race_check, userId, str_name[]) // Грузим инфу о загружаемом интерьере и передаём информацию в базу, что мы начинаем его грузить
{
    new rows;
	cache_get_row_count(rows);
    if(!rows) return ErrorMessage(playerid, "{FF6347}Интерьера не существует");
    if(g_MysqlRaceCheck[playerid] != race_check) return Kick(playerid);

    cache_get_value_name_int(0, "newid", peoInfo[playerid][peoNewid]); // ID Интерьера в личном редакторе
    cache_get_value_name(0, "peoName", peoInfo[playerid][peoName], 34);
    cache_get_value_name_int(0, "peoPriceInterior", peoInfo[playerid][peoPriceInterior]); // Получаем прайс интерьера, который устанавливает создатель
    cache_get_value_name_int(0, "peoPublicationStatus", peoInfo[playerid][peoPublicationStatus]); // Получаем статус публикации
    peoInfo[playerid][peoCreatorId] = userId;
    format(peoInfo[playerid][peoCreatorName],24,"%s", str_name);

    // После загрузки информации о интерьере, начинаем грузить его объекты
    format(big_query,sizeof(big_query),"SELECT * FROM `pp_peo_objects` WHERE `userId` = '%d'", userId);
	mysql_tquery(pearsq, big_query, "Call_loadinterior_object", "ddds", playerid, g_MysqlRaceCheck[playerid], userId, str_name);
    return 1;
}

forward Call_loadinterior_object(playerid, race_check, userId, str_name[]);
public Call_loadinterior_object(playerid, race_check, userId, str_name[]) // Грузим объекты интерьера для дома
{
	new rows;
	cache_get_row_count(rows);
    if(!rows) return ErrorMessage(playerid, "{FF6347}В интерьере нет объектов");
    if(g_MysqlRaceCheck[playerid] != race_check) return Kick(playerid);
    
    new slotId, string[6];
	for(new f; f < rows; ++f) // Цикл для всех найденных объектов игрока
	{
        cache_get_value_name_int(f, "slotId", slotId);
    	cache_get_value_name_int(f, "peoModel", peoInfo[playerid][peoModel][slotId]);
		cache_get_value_name_float(f, "peoX", peoInfo[playerid][peoX][slotId]);
		cache_get_value_name_float(f, "peoY", peoInfo[playerid][peoY][slotId]);
		cache_get_value_name_float(f, "peoZ", peoInfo[playerid][peoZ][slotId]);
		cache_get_value_name_float(f, "peoRX", peoInfo[playerid][peoRX][slotId]);
		cache_get_value_name_float(f, "peoRY", peoInfo[playerid][peoRY][slotId]);
		cache_get_value_name_float(f, "peoRZ", peoInfo[playerid][peoRZ][slotId]);

        if(peoInfo[playerid][peoModel][slotId] >= 1) // Создали объект
        {
            peoInfo[playerid][peoObject][slotId] = CreateDynamicObject(peoInfo[playerid][peoModel][slotId], peoInfo[playerid][peoX][slotId], peoInfo[playerid][peoY][slotId], peoInfo[playerid][peoZ][slotId], peoInfo[playerid][peoRX][slotId], peoInfo[playerid][peoRY][slotId], peoInfo[playerid][peoRZ][slotId], playerid+4000, 90, -1, 100.00, 100.00);
        }

        for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS; i++) // Грузим текстуры
        {
            format(string, sizeof(string), "txt%d", i);
			cache_get_value_name_int(f, string, peoTexture[playerid][slotId][i]);

            if(peoTexture[playerid][slotId][i] >= 1)
			{
				new textureId = peoTexture[playerid][slotId][i]-1;
				SetDynamicObjectMaterial(peoInfo[playerid][peoObject][slotId], i, ObjectTextures[textureId][TModel], ObjectTextures[textureId][TXDName], ObjectTextures[textureId][TextureName], 0x00000000);
			}
        }
    }
    peoInfo[playerid][peoStatusLoad] = false;
    return 1;
}

CMD:loadinterior(playerid, const params[]) // Загружаем интерьер
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");
    if(peoInfo[playerid][peoLoaded]) return ErrorMessage(playerid, "{FF6347}На ваш аккаунт уже загружен интерьер");

    if(PlayerInfo[playerid][pSoska] >= 1)
    {
        new playerName[24], string[46 + 24];
        if(!sscanf(params, "s[24]",playerName))
	    {
            new giveplayerid = ReturnUser(playerName, 1);
     	    if(IsPlayerConnected(giveplayerid)) goloadInterior(playerid, PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName]); // Игрок Online
            else // Игрок Offline
            {
                if(!CheckRP_Nickname(playerName)) return ErrorMessage(playerid, "{FF6347}Вы не правильно указали никнейм\nЕсли вы указали ID, значит игрок Offline");
                DP[0][playerid] = 0; // Поиск игрока
                DialogLoadInterior(playerid);
                format(string,sizeof(string),"SELECT * FROM `pp_igroki` WHERE `Name` = '%s'", playerName);
                mysql_tquery(pearsq, string, "Call_checkname_loadinterior", "dds", playerid, g_MysqlRaceCheck[playerid], playerName);
            }
            return 1;
        }
    }

    // Если не админ и ничего не вводили, то просто грузим обственный интерьер
    goloadInterior(playerid, PlayerInfo[playerid][pID], PlayerInfo[playerid][pName]);
    return 1;
}

CMD:loadeditor(playerid) // Входим в личный редактор
{
    if(PlayerInfo[playerid][pSoska] <= 0)
    {
	    // if(!IsPlayerInRangeOfPoint(playerid, 2.0, 228.0, 228.0, 228.0)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в шоуруме");
        if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вас преследует полиция");
        if(howstun(playerid) || HealthAC[playerid] <= 0) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
    }
    if(peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы уже в редакторе");

    if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return ErrorMessage(playerid, "{FF6347}Вы находитесь в наблюдении");
    if(setting_pos_draw[playerid] > 0 || setting_size_draw[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Завершите редактирование текстдравов");

    // Записываем текущие координаты и инты, чтобы при выходе из редактора вернуть игрока обратно
    GetPlayerPos(playerid, SpX[playerid], SpY[playerid], SpZ[playerid]);
    GetPlayerFacingAngle(playerid, SpA[playerid]);
    SpInt[playerid] = GetPlayerInterior(playerid);
    SpWorld[playerid] = GetPlayerVirtualWorld(playerid);

    S_SetPlayerVirtualWorld(playerid,playerid+4000,90); // Вирт миры 4000 - 4999 (Миры для личного редактора)
	SetPlayerInterior(playerid,90); // Инт 90 (поскольку там располагаются все кастомные интерьеры)
    PPSetPlayerPos(playerid,1387.4436,-16.2143,1000.8868); // Позиция входа в дом и бизнес (Они всегда в одной и той-же точке)
    SetPlayerFacingAngle(playerid, 0.0); // Угол поворота игрока
    SetCameraBehindPlayer(playerid); // Сбрасываем камеру

    peoInfo[playerid][peoInEditor] = true; // Мы в редакторе

    SendClientMessage(playerid, COLOR_GREY, "{A86CFB}[ Editor ]: {cccccc}Команда для управления редактором {A86CFB}/editor");
	return 1;
}

CMD:exiteditor(playerid) // Выходим из личного редактора
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");

    keep(playerid);
    S_SetPlayerVirtualWorld(playerid,SpWorld[playerid],SpInt[playerid]);
	SetPlayerInterior(playerid,SpInt[playerid]);
    PPSetPlayerPos(playerid,SpX[playerid], SpY[playerid], SpZ[playerid]);
    SetPlayerFacingAngle(playerid, SpA[playerid]);
    SetCameraBehindPlayer(playerid);

    peoInfo[playerid][peoInEditor] = false; // Статус редактора Off
	return 1;
}

stock DialogLoadInterior(playerid)
{
	if(DP[0][playerid] == 0) ShowDialog(playerid,1293,DIALOG_STYLE_MSGBOX,"{ff9000}Pears Project","{ff9000}Поиск аккаунта..","*","");
	else if(DP[0][playerid] == 1) ShowDialog(playerid,1293,DIALOG_STYLE_MSGBOX,"{ff9000}Pears Project","{ff9000}Загрузка интерьера..","*","");
	return 1;
}
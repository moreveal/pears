
stock EditObjectDom(playerid, dom, oba)
{
	if(oba < 0 || oba >= MAX_OBJECT_INT) return ErrorMessage(playerid, "{FF6347}Несуществующий ID объекта");
	if(DomInfo[dom][dOmodel][oba] == 0) return ErrorMessage(playerid, "{FF6347}Объекта не существует");
	if(!IsValidDynamicObject(DomInfo[dom][dObject][oba])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");
	if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, DomInfo[dom][dObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");

	new Float:ob[3];
    GetDynamicObjectPos(DomInfo[dom][dObject][oba],ob[0], ob[1], ob[2]);
  	if(!IsPlayerInRangeOfPoint(playerid, 20.0, ob[0], ob[1], ob[2])
		|| GetPlayerVirtualWorld(playerid) != GetDynamicObjectVirtualWorld(DomInfo[dom][dObject][oba])) return ErrorMessage(playerid, "{FF6347}Предмет далеко от вас");

	if(OnlineInfo[playerid][oShowInterface] == 2) CloseSmartfon(playerid);
	GoEditDynamicObject(playerid, 6, 1, dom, oba, DomInfo[dom][dObject][oba], 0);
	return 1;
}

stock InfoObjectDomBiz(playerid, type, id, oba)
{
	if(oba < 0 || oba >= MAX_OBJECT_INT) return ErrorMessage(playerid, "{FF6347}Несуществующий ID объекта");

    new model, object, userid;
    if(type == 1) model = DomInfo[id][dOmodel][oba], object = DomInfo[id][dObject][oba], userid = DomInfo[id][dUser][oba];
    else if(type == 2) model = BizzInfo[id][bOmodel][oba], object = BizzInfo[id][bObject][oba], userid = BizzInfo[id][bUser][oba];

	if(model == 0) return ErrorMessage(playerid, "{FF6347}Объекта не существует");
	if(!IsValidDynamicObject(object)) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");

    new string[144];
	format(string,sizeof(string),"SELECT * FROM `pp_igroki` WHERE `user_id` = '%d'", userid);
	mysql_tquery(pearsq, string, "call_io", "ddddd", playerid, userid, id, oba, type);
	return 1;
}
function call_io(playerid, userid, id, oba, type)
{
	new rows, datad[24];
	cache_get_row_count(rows);
	if(rows)
	{
        new model;
        if(type == 1) model = DomInfo[id][dOmodel][oba];
        else if(type == 2) model = BizzInfo[id][bOmodel][oba];

		if(model == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Пока искали аккаунт, объект уже был удалён");
		cache_get_value_name(0, "Name", datad, 24);

		new string[80];
		format(string,sizeof(string),"{ffcccc}[ Map ]: ID Объекта %d | Model %d | Редактировал %s", oba, model, datad);
		SendClientMessage(playerid, COLOR_GREY, string);
	}
	else ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
	return 1;
}

stock EditTextureDom(playerid, dom, oba)
{
	if(oba < 0 || oba >= MAX_OBJECT_INT) return ErrorMessage(playerid, "{FF6347}Несуществующий ID объекта");
	if(DomInfo[dom][dOmodel][oba] == 0) return ErrorMessage(playerid, "{FF6347}Объекта не существует");
	if(!IsValidDynamicObject(DomInfo[dom][dObject][oba])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");
	if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, DomInfo[dom][dObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");

	new Float:ob[3];
    GetDynamicObjectPos(DomInfo[dom][dObject][oba],ob[0], ob[1], ob[2]);
  	if(!IsPlayerInRangeOfPoint(playerid, 20.0, ob[0], ob[1], ob[2])
		|| GetPlayerVirtualWorld(playerid) != GetDynamicObjectVirtualWorld(DomInfo[dom][dObject][oba])) return ErrorMessage(playerid, "{FF6347}Предмет далеко от вас");


    if(OnlineInfo[playerid][oShowInterface] == 2) CloseSmartfon(playerid);
    Create3DMenu(playerid, 0, dom);
    Show3DMenu(playerid);
    RemoveObjectToTexture(playerid);
    ObjectToTexture(playerid, oba);
    NameTexture(playerid);

    // Перезапускаем меню со слотами на объекте
    if(DrawTextdrawEditor[playerid] == true)
    {
        CloseDraw3DMenu(playerid);
        ShowDraw3DMenu(playerid);
    }
	return 1;
}

stock DeleteObjectDom(playerid, dom, oba)
{
	if(oba < 0 || oba >= MAX_OBJECT_INT) return ErrorMessage(playerid, "{FF6347}Несуществующий ID объекта");
	if(DomInfo[dom][dOmodel][oba] == 0) return ErrorMessage(playerid, "{FF6347}Объекта не существует");
	if(!IsValidDynamicObject(DomInfo[dom][dObject][oba])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");
	if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, DomInfo[dom][dObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");

    new resultPut = PutThingDom(dom, DomInfo[dom][dOmodel][oba], 1, 0, DomInfo[dom][dQara][oba], 4, 0, 999);
    if(resultPut == -1) return ErrorMessage(playerid, "{FF6347}В инвентаре дома нет места");
    DestroyDynamicObject(DomInfo[dom][dObject][oba]);
    DelObject(dom, oba);
    ClearVariableObjectDom(dom, oba);
    PlayerPlaySound(playerid,17001,0,0,0);

    Delete3DLabelDomBiz(dom, oba, 1);
	return 1;
}

stock Update3DLabelDomBiz(id, obid, type)
{
    if(id == 0) return 1;

    foreach(Player,i)
	{
        if(LabelsInfo[i][labelCreate] == id && LabelsInfo[i][labelType] == type)
        {
            if(LabelsInfo[i][labelStatus][obid] != 0) DeleteForPlayer3DLabel(i, obid);
            CreateAndShow3DLabelDomBiz(i, id, obid, type);
        }
    }
    return 1;
}

stock Delete3DLabelDomBiz(id, obid, type)
{
    if(id == 0) return 1;

    foreach(Player,i)
	{
        if(LabelsInfo[i][labelCreate] == id && LabelsInfo[i][labelType] == type)
        {
            if(LabelsInfo[i][labelStatus][obid] != 0) DeleteForPlayer3DLabel(i, obid);
        }
    }
    return 1;
}

stock ShowForPlayer3DLabelDomBiz(playerid, i, type) // Показываем лейблы на объектах в доме или бизах
{
    for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
	{
        new model;
        if(type == 1) model = DomInfo[i][dOmodel][oba];
        else if(type == 2) model = BizzInfo[i][bOmodel][oba];

	    if(model >= 1) CreateAndShow3DLabelDomBiz(playerid, i, oba, type);
	}
    LabelsInfo[playerid][labelCreate] = i; // Отображение лейблов запущено
    LabelsInfo[playerid][labelType] = type; // 1 Дом, 2 Бизнес
    return 1;
}

stock CreateAndShow3DLabelDomBiz(playerid, i, oba, type)
{
    new string[80];
    new Float:pos[3];
    new model, objectid;

    if(type == 1) model = DomInfo[i][dOmodel][oba], objectid = DomInfo[i][dObject][oba];
    else if(type == 2) model = BizzInfo[i][bOmodel][oba], objectid = BizzInfo[i][bObject][oba];

    GetDynamicObjectPos(objectid, pos[0], pos[1], pos[2]);
    CreateForPlayer3DLabel(playerid, oba, pos[0], pos[1], pos[2]);

    format(string,sizeof(string),"{cccccc}ID: {555555}%d {cccccc}| Model: {555555}%d", oba, model);
    UpdateForPlayer3DLabel(playerid, oba, string);
    return 1;
}

stock showDialogInteriorDom(playerid)
{
    if(MenuInfo[playerid][zStat] > 0) return 1;

    new d = DP[4][playerid];
    if(!IsANearWardrobeDom(playerid, d)) return ErrorMessage(playerid, "{FF6347}Вы не в интерьере или далеко от дома");
    if(DomInfo[d][dFrame] == 0) return ErrorMessage(playerid, "{FF6347}В этом доме нельзя изменять интерьер{cccccc}Установите планировку");
    if(DomInfo[d][dSell] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя ремонтировать дом во время продажи");

    if(DP[0][playerid] == 0) DP[1][playerid] = 2; // Переместить объект интерьера дома
  	else if(DP[0][playerid] == 1) DP[1][playerid] = 4; // Изменить текстуры объекта интерьер дома
  	else if(DP[0][playerid] == 2) DP[1][playerid] = 3; // Убрать объект интерьер дома
    else return 1;

    PlayerPlaySound(playerid,40405,0,0,0);
    ShowAllObject(playerid, d, DP[1][playerid]);
	return 1;
}

stock setDomDefaultFrame(d) //  Ставим дефолтную планировку в дом
{
	DomInfo[d][dOmodel][0] = 14713;
	new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
	GetCoordFrame(14713, x, y, z, rx, ry, rz);
	DomInfo[d][dObject][0] = CreateDynamicObject(DomInfo[d][dOmodel][0], x, y, z, rx, ry, rz, d+1000, 90, -1, 100.00, 100.00);
	DomInfo[d][dEnterX] = 1387.4436, DomInfo[d][dEnterY] = -16.2143, DomInfo[d][dEnterZ] = 1000.8868, DomInfo[d][dEnterA] = 359.7609, DomInfo[d][dInterior] = 90;
	DomInfo[d][dFrame] = DomInfo[d][dOmodel][0];

	UpdateObject(d, 0, true, false);
	return 1;
}

stock DelObject(d, obid) // Удаляем объект из дома
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;
	if(d < 0 || d >= MAX_DOM || obid < 0 || obid >= MAX_OBJECT_INT) return 1;
    if(DomInfo[d][dNewid][obid] == 0) return 1;

	new string_mysql[120];
	format(string_mysql,sizeof(string_mysql),"DELETE FROM `pp_objects` WHERE `newid` = '%d'", DomInfo[d][dNewid][obid]);
	query_empty(pearsq, string_mysql);

	for(new t = 0; t < MAX_TEXTURES_ON_OBJECTS; t++)
	{
		if(DomTexture[d][obid][t] != 0) DomTexture[d][obid][t] = 0;
	}
	return 1;
}


stock UpdateObject(d, obid, bool:updatePosition, bool:updateTextures) // Обновляем объект в доме
{
    if(LIMITED_LOADING_SERVER >= 2) return 1;
    if(d < 0 || d >= MAX_DOM || obid < 0 || obid >= MAX_OBJECT_INT) return 1;

    if(updatePosition) UpdateObjectPosition(d, obid); // Только расположение и общая инфа
    else if(updateTextures) UpdateObjectTextures(d, obid); // Только текстуры
    else if(updatePosition && updateTextures)  UpdateObjectPositionAndTextures(d, obid); // Полное обновление
    return 1;
}

stock UpdateObjectPosition(d, obid)
{
    new Float:pos[3], Float:rot[3];
    GetDynamicObjectPos(DomInfo[d][dObject][obid], pos[0], pos[1], pos[2]);
    GetDynamicObjectRot(DomInfo[d][dObject][obid], rot[0], rot[1], rot[2]);

    new string_mysql[1000];
    if(DomInfo[d][dNewid][obid] == 0) // Если объекта нет в базе
    {
        format(string_mysql, sizeof(string_mysql), "INSERT INTO `pp_objects` (`dom`, `slot`, `user`, `model`, `qara`, `world`, `interior`, `ox`, `oy`, `oz`, `orx`, `ory`, `orz`) \
            VALUES ('%d', '%d', '%d', '%d', '%d', '%d', '%d', '%f', '%f', '%f', '%f', '%f', '%f')",
                d, obid, DomInfo[d][dUser][obid], DomInfo[d][dOmodel][obid], DomInfo[d][dQara][obid], GetDynamicObjectVirtualWorld(DomInfo[d][dObject][obid]), 
                GetDynamicObjectInterior(DomInfo[d][dObject][obid]), pos[0], pos[1], pos[2], rot[0], rot[1], rot[2]);
        mysql_tquery(pearsq, string_mysql, "Call_InsertObjectDom", "dd", d, obid);
    }
    else // Если объект уже существует в базе
    {
        format(string_mysql, sizeof(string_mysql), "UPDATE `pp_objects` SET `user` = '%d', `model` = '%d', `qara` = '%d', `world` = '%d', `interior` = '%d', \
            `ox` = '%f', `oy` = '%f', `oz` = '%f', `orx` = '%f', `ory` = '%f', `orz` = '%f' WHERE `newid` = '%d'",
                DomInfo[d][dUser][obid], DomInfo[d][dOmodel][obid], DomInfo[d][dQara][obid], GetDynamicObjectVirtualWorld(DomInfo[d][dObject][obid]), 
                GetDynamicObjectInterior(DomInfo[d][dObject][obid]), pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], DomInfo[d][dNewid][obid]);
        mysql_tquery(pearsq, string_mysql);
    }
    return 1;
}

function Call_InsertObjectDom(d, obid)
{
    DomInfo[d][dNewid][obid] = cache_insert_id();
    return 1;
}

stock BuildTextureString(type, d, obid, string:output[], outputsize)
{
    output[0] = '\0';
    new string_texture_part[64];

    // Формирование части запроса для каждой текстуры
    for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS; i++)
    {
		new textureid;
		if(type == 0) textureid = DomTexture[d][obid][i]; // Собираем строку для объектов в доме
		else if(type == 1) textureid = BizzTexture[d][obid][i]; // Собираем строку для объектов в бизнесе

        format(string_texture_part, sizeof(string_texture_part), "`t%d` = '%d'", i, textureid);
        strcat(output, string_texture_part, outputsize);

        if(i < MAX_TEXTURES_ON_OBJECTS - 1) strcat(output, ", ", outputsize); // Добавляем запятую после каждой текстуры, кроме последней
    }
}

stock UpdateObjectTextures(d, obid)
{
    if(LIMITED_LOADING_SERVER >= 2) return 1;
    if(d < 0 || d >= MAX_DOM || obid < 0 || obid >= MAX_OBJECT_INT) return 1;

    if(DomInfo[d][dNewid][obid] != 0) // Только если объект существует в базе
    {
        new string_mysql[3200];
        new texture_update_string[1600];

        // Собираем строку обновления текстур
        BuildTextureString(0, d, obid, texture_update_string, sizeof(texture_update_string));

        // Формирование запроса
        format(string_mysql, sizeof(string_mysql), "UPDATE `pp_objects` SET %s, `yesUpdate` = '1' WHERE `newid` = '%d'", 
            texture_update_string, DomInfo[d][dNewid][obid]);

        query_empty(pearsq, string_mysql);
    }
    return 1;
}

stock UpdateObjectPositionAndTextures(d, obid)
{
    if(LIMITED_LOADING_SERVER >= 2) return 1;
    if(d < 0 || d >= MAX_DOM || obid < 0 || obid >= MAX_OBJECT_INT) return 1;

    new Float:pos[3], Float:rot[3];
    GetDynamicObjectPos(DomInfo[d][dObject][obid], pos[0], pos[1], pos[2]);
    GetDynamicObjectRot(DomInfo[d][dObject][obid], rot[0], rot[1], rot[2]);

    new string_mysql[3200];
    new texture_update_string[1600];

    // Собираем строку обновления текстур
    BuildTextureString(0, d, obid, texture_update_string, sizeof(texture_update_string));

    if(DomInfo[d][dNewid][obid] == 0) // Если объекта нет в базе
    {
        format(string_mysql, sizeof(string_mysql), "INSERT INTO `pp_objects` (`dom`, `slot`, `user`, `model`, `qara`, `world`, `interior`, `ox`, `oy`, `oz`, `orx`, `ory`, `orz`, %s) \
        VALUES ('%d', '%d', '%d', '%d', '%d', '%d', '%d', '%f', '%f', '%f', '%f', '%f', '%f', %s)",
        texture_update_string, d, obid, DomInfo[d][dUser][obid], DomInfo[d][dOmodel][obid], DomInfo[d][dQara][obid], GetDynamicObjectVirtualWorld(DomInfo[d][dObject][obid]), 
        GetDynamicObjectInterior(DomInfo[d][dObject][obid]), pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], texture_update_string);
        mysql_tquery(pearsq, string_mysql, "Call_InsertObjectDom", "dd", d, obid);
    }
    else // Если объект уже существует в базе
    {
        format(string_mysql, sizeof(string_mysql), "UPDATE `pp_objects` SET `user` = '%d', `model` = '%d', `qara` = '%d', `world` = '%d', `interior` = '%d', \
        `ox` = '%f', `oy` = '%f', `oz` = '%f', `orx` = '%f', `ory` = '%f', `orz` = '%f', %s WHERE `newid` = '%d'",
        DomInfo[d][dUser][obid], DomInfo[d][dOmodel][obid], DomInfo[d][dQara][obid], GetDynamicObjectVirtualWorld(DomInfo[d][dObject][obid]), 
        GetDynamicObjectInterior(DomInfo[d][dObject][obid]), pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], texture_update_string, DomInfo[d][dNewid][obid]);
        mysql_tquery(pearsq, string_mysql);
    }
    return 1;
}

stock ClearVariableObjectDom(dom, oba)
{
    DomInfo[dom][dNewid][oba] = 0;
    DomInfo[dom][dObject][oba] = 0;
    DomInfo[dom][dOmodel][oba] = 0;
    DomInfo[dom][dQara][oba] = 0;
    DomInfo[dom][dUser][oba] = 0;
}

stock RemoveAllObject(playerid, dom) // Удаляем объекты и отключаем взаимодействие
{
	// Начало транзакции
	mysql_query(pearsq, "START TRANSACTION;");

	for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
	{
	    if(DomInfo[dom][dOmodel][oba] >= 1) 
        {
            DestroyDynamicObject(DomInfo[dom][dObject][oba]);
            DelObject(dom, oba);
            ClearVariableObjectDom(dom, oba);
        }
	}

	// Завершение транзакции
	mysql_query(pearsq, "COMMIT;");

    DeleteAll3DLabel(dom, 1); // Удаляем лейблы всем игрокам
	DeleteInteractionDom(dom); // Отключаем взаимодействие в доме
    SaveDom(dom); // Сохраняем дом
    HouseLog(0, "rdomobject", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], dom, 0, "Удалил всю мебель");
	return 1;
}

stock ClearAllObject(playerid, dom) // Убираем все объекты в дом отключаем взаимодействие
{
	// Начало транзакции
	mysql_query(pearsq, "START TRANSACTION;");

	for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
	{
	    if(DomInfo[dom][dOmodel][oba] >= 1)
        {
            if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, DomInfo[dom][dObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) <= 0)
            {
                new resultPut = PutThingDom(dom, DomInfo[dom][dOmodel][oba], 1, 0, DomInfo[dom][dQara][oba], 4, 0, 999);
                if(resultPut >= 0)
                {
                    DestroyDynamicObject(DomInfo[dom][dObject][oba]);
                    DelObject(dom, oba);
                    ClearVariableObjectDom(dom, oba);
                }
            }
        }
	}

	// Завершение транзакции
	mysql_query(pearsq, "COMMIT;");

    DeleteAll3DLabel(dom, 1); // Удаляем лейблы всем игрокам
	DeleteInteractionDom(dom);
    SaveDom(dom);
    HouseLog(0, "clearobject", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], dom, 0, "Убрал мебель");
	return 1;
}

stock DeleteInteractionDom(dom)
{
	if(DomInfo[dom][dIntoi] >= 1) DestroyDynamic3DTextLabel(IntoiLabel[dom]), DomInfo[dom][dIntoi] = 0;
	if(DomInfo[dom][dInsin] >= 1) DestroyDynamic3DTextLabel(InsinLabel[dom]), DomInfo[dom][dInsin] = 0;
	if(DomInfo[dom][dInsou] >= 1) DestroyDynamic3DTextLabel(InsouLabel[dom]), DomInfo[dom][dInsou] = 0;
	if(DomInfo[dom][dInspa] >= 1) DomInfo[dom][dInspa] = 0;
	if(DomInfo[dom][dInbedL] >= 1) DomInfo[dom][dInbedL] = 0;
	if(DomInfo[dom][dInbedR] >= 1) DomInfo[dom][dInbedR] = 0;
    return 1;
}

stock CheckObject(dom) // Проверяем есть ли свободные слоты для установки объекта мебели
{
	new quan;
	for(new oba = 0; oba < MAX_OBJECT_INT; oba++)
	{
		if(DomInfo[dom][dOmodel][oba] > 0) quan ++;
	}
	if(quan >= MAX_OBJECT_INT) return 1;
	return 0;
}

function LoadObject() // Грузим объекты интерьера для дома
{
    new time = GetTickCount();
    new rows, sla, nd, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
    new world, interior, quanAllTextures;
    cache_get_row_count(rows);

    for(new f = 0; f < rows; ++f)
    {
        // Загрузка данных объекта
        cache_get_value_name_int(f, "slot", sla);
        cache_get_value_name_int(f, "dom", nd);
        cache_get_value_name_int(f, "newid", DomInfo[nd][dNewid][sla]);
        cache_get_value_name_int(f, "user", DomInfo[nd][dUser][sla]);
        cache_get_value_name_int(f, "model", DomInfo[nd][dOmodel][sla]);
        cache_get_value_name_int(f, "qara", DomInfo[nd][dQara][sla]);
        cache_get_value_name_int(f, "world", world);
        cache_get_value_name_int(f, "interior", interior);
        cache_get_value_name_float(f, "ox", x);
        cache_get_value_name_float(f, "oy", y);
        cache_get_value_name_float(f, "oz", z);
        cache_get_value_name_float(f, "orx", rx);
        cache_get_value_name_float(f, "ory", ry);
        cache_get_value_name_float(f, "orz", rz);

        if(DomInfo[nd][dOmodel][sla] >= 1) 
        {
            // Обработка world и interior
            //if(world == 0) world = nd + 1000;
            //if(interior == 0) interior = 90;

            // Создание объекта
            DomInfo[nd][dObject][sla] = CreateDynamicObject(DomInfo[nd][dOmodel][sla], x, y, z, rx, ry, rz, world, interior, -1, 200.00, 200.00);

            // Получение и применение текстур к объекту
            for(new t = 0; t < MAX_TEXTURES_ON_OBJECTS; t++)
            {
                new textureId;
                new string_field[10];
                format(string_field, sizeof(string_field), "t%d", t); // Создаем имя поля (например, "t0", "t1", ...)
                cache_get_value_name_int(f, string_field, textureId); // Получаем значение текстуры

                if(textureId != 0)
                {
					quanAllTextures ++;
                    DomTexture[nd][sla][t] = textureId;
                    SetDynamicObjectMaterial(DomInfo[nd][dObject][sla], t, ObjectTextures[textureId][TModel], ObjectTextures[textureId][TXDName], ObjectTextures[textureId][TextureName], 0x00000000);
                }
            }
        }
    }
    printf("[MODE]: Объекты Домов [Текстур %d][%d Quan][%d ms]", quanAllTextures, rows, GetTickCount() - time);
    return 1;
}


// Комнада для пересбора текстур к новому набору
new stopReload;
CMD:reloadtexture(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(server == 0) return ErrorMessage(playerid, "{FF6347}Для тестового сервера, все объекты были обработаны");
	if(stopReload == 1) return ErrorMessage(playerid, "{FF6347}Команда уже была запущена, объекты обрабатываются");
	if(stopReload == 2) return ErrorMessage(playerid, "{FF6347}Все объекты обработаны");

	stopReload = 1;
	// Начало транзакции
	mysql_query(pearsq, "START TRANSACTION;");

	for(new d = 0; d < MAX_DOM; d++)
	{
		for(new obid = 0; obid < MAX_OBJECT_INT; obid++)
		{
			if(DomInfo[d][dOmodel][obid] >= 1)
			{
				new yesUpdate;
				for(new t = 0; t < MAX_TEXTURES_ON_OBJECTS; t++)
				{
					new oldTextureId = DomTexture[d][obid][t] - 1;
					if(oldTextureId >= 0)
					{
						yesUpdate ++;

						// Поиск соответствующей новой текстуры
						new newTextureId = FindNewTextureId(oldTextureId);

						printf("d: %d, obid: %d, dOmodel: %d, t: %d, oldTextureId %d ( %s, %s ), newTextureId %d ( %s, %s )", d, obid, 
							DomInfo[d][dOmodel][obid], t, oldTextureId, 
							OLDObjectTextures[oldTextureId][OLDTXDName], OLDObjectTextures[oldTextureId][OLDTextureName], newTextureId, ObjectTextures[newTextureId][TXDName], ObjectTextures[newTextureId][TextureName]);
					
						DomTexture[d][obid][t] = newTextureId;
						SetDynamicObjectMaterial(DomInfo[d][dObject][obid], t, ObjectTextures[newTextureId][TModel], ObjectTextures[newTextureId][TXDName], ObjectTextures[newTextureId][TextureName], 0x00000000);
					}
				}
				if(yesUpdate > 0)
				{
					UpdateObjectTextures(d, obid);
				}
			}
		}
	}

	// Завершение транзакции
	mysql_query(pearsq, "COMMIT;");

	stopReload = 2;
	return 1;
}

stock FindNewTextureId(oldTextureId)
{
    for(new i = 0; i < sizeof(ObjectTextures); i++)
    {
        if(strcmp(OLDObjectTextures[oldTextureId][OLDTXDName], ObjectTextures[i][TXDName], false) == 0
           && strcmp(OLDObjectTextures[oldTextureId][OLDTextureName], ObjectTextures[i][TextureName], false) == 0
		   && OLDObjectTextures[oldTextureId][OLDTModel] == ObjectTextures[i][TModel])
        {
            return i; // Возвращаем новый ID текстуры
        }
    }
    return -1; // Если соответствие не найдено
}

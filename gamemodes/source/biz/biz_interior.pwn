
stock ClearAllObjectBiz(playerid, biz) // Убираем все объекты в биз
{
	// Начало транзакции
	mysql_query(pearsq, "START TRANSACTION;");

	for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
	{
	    if(BizzInfo[biz][bOmodel][oba] >= 1)
        {
            if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) <= 0)
            {
                new resultPut = PutThingBiz(biz, BizzInfo[biz][bOmodel][oba], 1, 0, BizzInfo[biz][bQara][oba], 4, 999);
                if(resultPut >= 0)
                {
                    DestroyDynamicObject(BizzInfo[biz][bObject][oba]);
                    DelObjectBiz(biz, oba);
                    ClearVariableObjectBiz(biz, oba);
                }
            }
        }
	}

	// Завершение транзакции
	mysql_query(pearsq, "COMMIT;");

    DeleteAll3DLabel(biz, 2); // Удаляем лейблы всем игрокам
    BizLog("clearobject", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], biz, 0, "Убрал мебель");
	return 1;
}

stock RemoveAllObjectBiz(playerid, biz) // Удаляем объекты
{
	// Начало транзакции
	mysql_query(pearsq, "START TRANSACTION;");

	for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
	{
	    if(BizzInfo[biz][bOmodel][oba] >= 1) 
        {
            DestroyDynamicObject(BizzInfo[biz][bObject][oba]);
            DelObjectBiz(biz, oba);
            ClearVariableObjectBiz(biz, oba);
        }
	}

	// Завершение транзакции
	mysql_query(pearsq, "COMMIT;");

    DeleteAll3DLabel(biz, 2); // Удаляем лейблы всем игрокам
    BizLog("rbizobject", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], biz, 0, "Удалил всю мебель");
	return 1;
}

stock EditObjectBiz(playerid, biz, oba)
{
	if(oba < 0 || oba >= MAX_OBJECT_INT) return ErrorMessage(playerid, "{FF6347}Несуществующий ID объекта");
	if(BizzInfo[biz][bOmodel][oba] == 0) return ErrorMessage(playerid, "{FF6347}Объекта не существует");
	if(!IsValidDynamicObject(BizzInfo[biz][bObject][oba])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");
	if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");

	new Float:ob[3];
    GetDynamicObjectPos(BizzInfo[biz][bObject][oba],ob[0], ob[1], ob[2]);
  	if(!IsPlayerInRangeOfPoint(playerid, 20.0, ob[0], ob[1], ob[2])
		|| GetPlayerVirtualWorld(playerid) != GetDynamicObjectVirtualWorld(BizzInfo[biz][bObject][oba])) return ErrorMessage(playerid, "{FF6347}Предмет далеко от вас");

	if(OnlineInfo[playerid][oShowInterface] == 2) CloseSmartfon(playerid);
    if(Komputer[playerid] == 2) exitkomp(playerid, 2);
	GoEditDynamicObject(playerid, 17, 1, biz, oba, BizzInfo[biz][bObject][oba], 0);
	return 1;
}

stock DeleteObjectBiz(playerid, biz, oba)
{
	if(oba < 0 || oba >= MAX_OBJECT_INT) return ErrorMessage(playerid, "{FF6347}Несуществующий ID объекта");
	if(BizzInfo[biz][bOmodel][oba] == 0) return ErrorMessage(playerid, "{FF6347}Объекта не существует");
	if(!IsValidDynamicObject(BizzInfo[biz][bObject][oba])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");
	if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");

    new resultPut = PutThingBiz(biz, BizzInfo[biz][bOmodel][oba], 1, 0, BizzInfo[biz][bQara][oba], 4, 999);
    if(resultPut == -1) return ErrorMessage(playerid, "{FF6347}В инвентаре бизнеса нет места");
    DestroyDynamicObject(BizzInfo[biz][bObject][oba]);
    DelObjectBiz(biz, oba);
    ClearVariableObjectBiz(biz, oba);
    PlayerPlaySound(playerid,17001,0,0,0);

    Delete3DLabelDomBiz(biz, oba, 2);
	return 1;
}

stock EditTextureBiz(playerid, biz, oba)
{
	if(oba < 0 || oba >= MAX_OBJECT_INT) return ErrorMessage(playerid, "{FF6347}Несуществующий ID объекта");
	if(BizzInfo[biz][bOmodel][oba] == 0) return ErrorMessage(playerid, "{FF6347}Объекта не существует");
	if(!IsValidDynamicObject(BizzInfo[biz][bObject][oba])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");
	if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");

	new Float:ob[3];
    GetDynamicObjectPos(BizzInfo[biz][bObject][oba],ob[0], ob[1], ob[2]);
  	if(!IsPlayerInRangeOfPoint(playerid, 20.0, ob[0], ob[1], ob[2])
		|| GetPlayerVirtualWorld(playerid) != GetDynamicObjectVirtualWorld(BizzInfo[biz][bObject][oba])) return ErrorMessage(playerid, "{FF6347}Предмет далеко от вас");

    if(OnlineInfo[playerid][oShowInterface] == 2) CloseSmartfon(playerid);
    if(Komputer[playerid] == 2) exitkomp(playerid, 2);

    Create3DMenu(playerid, 1, biz);
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

stock ClearVariableObjectBiz(biz, oba)
{
    BizzInfo[biz][bNewid][oba] = 0;
    BizzInfo[biz][bObject][oba] = 0;
    BizzInfo[biz][bOmodel][oba] = 0;
    BizzInfo[biz][bQara][oba] = 0;
    BizzInfo[biz][bUser][oba] = 0;
}

stock getFreeSlotObjectBiz(biz)
{
	new slot = -1;
	for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
	{
		if(BizzInfo[biz][bOmodel][oba] == 0)
		{
			slot = oba;
			break;
		}
	}
	return slot;
}

stock getObjectStreetBiz(biz)
{
	new quan;
	for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
	{
		if(BizzInfo[biz][bOmodel][oba] > 0)
		{
			if(GetDynamicObjectVirtualWorld(BizzInfo[biz][bObject][oba]) == 0
				&& GetDynamicObjectInterior(BizzInfo[biz][bObject][oba]) == 0)
			{
				quan ++;
			}
		}
	}
	return quan;
}

stock DelObjectBiz(b, obid) // Удаляем объект из biza
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;
	if(b < 0 || b >= MAX_BIZ || obid < 0 || obid >= MAX_OBJECT_INT) return 1;
    if(BizzInfo[b][bNewid][obid] == 0) return 1;

	new string_mysql[120];
	format(string_mysql,sizeof(string_mysql),"DELETE FROM `pp_objects_biz` WHERE `newid` = '%d'", BizzInfo[b][bNewid][obid]);
	query_empty(pearsq, string_mysql);

	for(new t = 0; t < MAX_TEXTURES_ON_OBJECTS; t++)
	{
		if(BizzTexture[b][obid][t] != 0) BizzTexture[b][obid][t] = 0;
	}
	return 1;
}

stock UpdateObjectBiz(b, obid, bool:updatePosition, bool:updateTextures) // Обновляем объект в bize
{
    if(LIMITED_LOADING_SERVER >= 2) return 1;
    if(b < 0 || b >= MAX_BIZ || obid < 0 || obid >= MAX_OBJECT_INT) return 1;

    if(updatePosition) UpdateObjectPositionBiz(b, obid); // Только расположение и общая инфа
    else if(updateTextures) UpdateObjectTexturesBiz(b, obid); // Только текстуры
    else if(updatePosition && updateTextures)  UpdateObjectPosAndTextureBiz(b, obid); // Полное обновление
    return 1;
}

stock UpdateObjectPositionBiz(b, obid)
{
    new Float:pos[3], Float:rot[3];
    GetDynamicObjectPos(BizzInfo[b][bObject][obid], pos[0], pos[1], pos[2]);
    GetDynamicObjectRot(BizzInfo[b][bObject][obid], rot[0], rot[1], rot[2]);

    new string_mysql[1000];
    if(BizzInfo[b][bNewid][obid] == 0) // Если объекта нет в базе
    {
        format(string_mysql, sizeof(string_mysql), "INSERT INTO `pp_objects_biz` (`biz`, `slot`, `user`, `model`, `qara`, `world`, `interior`, `ox`, `oy`, `oz`, `orx`, `ory`, `orz`) \
            VALUES ('%d', '%d', '%d', '%d', '%d', '%d', '%d', '%f', '%f', '%f', '%f', '%f', '%f')",
                b, obid, BizzInfo[b][bUser][obid], BizzInfo[b][bOmodel][obid], BizzInfo[b][bQara][obid], GetDynamicObjectVirtualWorld(BizzInfo[b][bObject][obid]), 
                GetDynamicObjectInterior(BizzInfo[b][bObject][obid]), pos[0], pos[1], pos[2], rot[0], rot[1], rot[2]);
        mysql_tquery(pearsq, string_mysql, "Call_InsertObjectBiz", "dd", b, obid);
    }
    else // Если объект уже существует в базе
    {
        format(string_mysql, sizeof(string_mysql), "UPDATE `pp_objects_biz` SET `user` = '%d', `model` = '%d', `qara` = '%d', `world` = '%d', `interior` = '%d', \
            `ox` = '%f', `oy` = '%f', `oz` = '%f', `orx` = '%f', `ory` = '%f', `orz` = '%f' WHERE `newid` = '%d'",
                BizzInfo[b][bUser][obid], BizzInfo[b][bOmodel][obid], BizzInfo[b][bQara][obid], GetDynamicObjectVirtualWorld(BizzInfo[b][bObject][obid]), 
                GetDynamicObjectInterior(BizzInfo[b][bObject][obid]), pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], BizzInfo[b][bNewid][obid]);
        mysql_tquery(pearsq, string_mysql);
    }
    return 1;
}

function Call_InsertObjectBiz(b, obid)
{
    BizzInfo[b][bNewid][obid] = cache_insert_id();
    return 1;
}

stock UpdateObjectTexturesBiz(b, obid)
{
    if(LIMITED_LOADING_SERVER >= 2) return 1;
    if(b < 0 || b >= MAX_BIZ || obid < 0 || obid >= MAX_OBJECT_INT) return 1;

    if(BizzInfo[b][bNewid][obid] != 0) // Только если объект существует в базе
    {
        new string_mysql[3200];
        new texture_update_string[1600];

        // Собираем строку обновления текстур
        BuildTextureString(1, b, obid, texture_update_string, sizeof(texture_update_string));

        // Формирование запроса
        format(string_mysql, sizeof(string_mysql), "UPDATE `pp_objects_biz` SET %s WHERE `newid` = '%d'", 
            texture_update_string, BizzInfo[b][bNewid][obid]);

        query_empty(pearsq, string_mysql);
    }
    return 1;
}

stock UpdateObjectPosAndTextureBiz(b, obid)
{
    if(LIMITED_LOADING_SERVER >= 2) return 1;
    if(b < 0 || b >= MAX_BIZ || obid < 0 || obid >= MAX_OBJECT_INT) return 1;

    new Float:pos[3], Float:rot[3];
    GetDynamicObjectPos(BizzInfo[b][bObject][obid], pos[0], pos[1], pos[2]);
    GetDynamicObjectRot(BizzInfo[b][bObject][obid], rot[0], rot[1], rot[2]);

    new string_mysql[3200];
    new texture_update_string[1600];

    // Собираем строку обновления текстур
    BuildTextureString(1, b, obid, texture_update_string, sizeof(texture_update_string));

    if(BizzInfo[b][bNewid][obid] == 0) // Если объекта нет в базе
    {
        format(string_mysql, sizeof(string_mysql), "INSERT INTO `pp_objects_biz` (`biz`, `slot`, `user`, `model`, `qara`, `world`, `interior`, `ox`, `oy`, `oz`, `orx`, `ory`, `orz`, %s) \
        VALUES ('%d', '%d', '%d', '%d', '%d', '%d', '%d', '%f', '%f', '%f', '%f', '%f', '%f', %s)",
        texture_update_string, b, obid, BizzInfo[b][bUser][obid], BizzInfo[b][bOmodel][obid], BizzInfo[b][bQara][obid], GetDynamicObjectVirtualWorld(BizzInfo[b][bObject][obid]), 
        GetDynamicObjectInterior(BizzInfo[b][bObject][obid]), pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], texture_update_string);
        mysql_tquery(pearsq, string_mysql, "Call_InsertObjectBiz", "dd", b, obid);
    }
    else // Если объект уже существует в базе
    {
        format(string_mysql, sizeof(string_mysql), "UPDATE `pp_objects_biz` SET `user` = '%d', `model` = '%d', `qara` = '%d', `world` = '%d', `interior` = '%d', \
        `ox` = '%f', `oy` = '%f', `oz` = '%f', `orx` = '%f', `ory` = '%f', `orz` = '%f', %s WHERE `newid` = '%d'",
        BizzInfo[b][bUser][obid], BizzInfo[b][bOmodel][obid], BizzInfo[b][bQara][obid], GetDynamicObjectVirtualWorld(BizzInfo[b][bObject][obid]), 
        GetDynamicObjectInterior(BizzInfo[b][bObject][obid]), pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], texture_update_string, BizzInfo[b][bNewid][obid]);
        mysql_tquery(pearsq, string_mysql);
    }
    return 1;
}

function LoadObjectBiz() // Грузим объекты бизнесов
{
    new time = GetTickCount();
    new rows, sla, nd, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
    new world, interior, quanAllTextures;
    cache_get_row_count(rows);

    for(new f = 0; f < rows; ++f)
    {
        // Загрузка данных объекта
        cache_get_value_name_int(f, "slot", sla);
        cache_get_value_name_int(f, "biz", nd);
        cache_get_value_name_int(f, "newid", BizzInfo[nd][bNewid][sla]);
        cache_get_value_name_int(f, "user", BizzInfo[nd][bUser][sla]);
        cache_get_value_name_int(f, "model", BizzInfo[nd][bOmodel][sla]);
        cache_get_value_name_int(f, "qara", BizzInfo[nd][bQara][sla]);
        cache_get_value_name_int(f, "world", world);
        cache_get_value_name_int(f, "interior", interior);
        cache_get_value_name_float(f, "ox", x);
        cache_get_value_name_float(f, "oy", y);
        cache_get_value_name_float(f, "oz", z);
        cache_get_value_name_float(f, "orx", rx);
        cache_get_value_name_float(f, "ory", ry);
        cache_get_value_name_float(f, "orz", rz);

        if(BizzInfo[nd][bOmodel][sla] >= 1) 
        {
            // Обработка world и interior
            //if(world == 0) world = nd + 3000;
            //if(interior == 0) interior = 90;

            // Создание объекта
            BizzInfo[nd][bObject][sla] = CreateDynamicObject(BizzInfo[nd][bOmodel][sla], x, y, z, rx, ry, rz, world, interior, -1, 200.00, 200.00);

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
                    BizzTexture[nd][sla][t] = textureId;
                    SetDynamicObjectMaterial(BizzInfo[nd][bObject][sla], t, ObjectTextures[textureId][TModel], ObjectTextures[textureId][TXDName], ObjectTextures[textureId][TextureName], 0x00000000);
                }
            }
        }
    }
    printf("[MODE]: Объекты Бизнесов [Текстур %d][%d Quan][%d ms]", quanAllTextures, rows, GetTickCount() - time);
    return 1;
}
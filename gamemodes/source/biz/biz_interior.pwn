
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

stock ClearVariableObjectBiz(b, oba)
{
    BizzInfo[b][bNewid][oba] = 0;
    BizzInfo[b][bObject][oba] = 0;
    BizzInfo[b][bOmodel][oba] = 0;
    BizzInfo[b][bQara][oba] = 0;
    BizzInfo[b][bUser][oba] = 0;
}

stock CheckObjectBiz(b) // Проверяем есть ли свободные слоты для установки объекта мебели
{
	new quan;
	for(new i = 0; i < MAX_OBJECT_INT; i++)
	{
		if(BizzInfo[b][bOmodel][i] > 0) quan ++;
	}
	if(quan >= MAX_OBJECT_INT) return 1;
	return 0;
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
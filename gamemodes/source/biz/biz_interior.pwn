
CMD:reloadframebiz(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid,"{ff6347}Вы не можете использовать эту команду");
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сбросить планировку бизнеса [ /reloadframebiz ID ]");
	if(params[0] < 0 || params[0] >= MAX_BIZ) return ErrorMessage(playerid,"{ff6347}Неверный ID бизнеса\n{cccccc}0 - сбросить планировку всех бизнесов");

    new string[90];
	if(params[0] > 0)
	{
		new quan;
		for(new b = 1; b < sizeof(BizzInfo); b++)
		{
			if(IsABizInteriorFrame(b))
			{
				if(ReloadFrameBiz(b)) quan ++;
			}
		}
		if(quan == 0) return ErrorMessage(playerid,"{ff6347}У всех бизнесов установлены планировки");
		format(string, sizeof(string), " [ ADM ]: %s сбросил планировку %d бизнесов", PlayerInfo[playerid][pName], quan);
		ABroadCast(COLOR_ADM,string,1);

        format(string, sizeof(string), "Планировка %d бизнесов", quan);
        AdminLog("reloadframebiz", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, string);
	}
	else
	{
		if(!IsABizInteriorFrame(params[0])) return ErrorMessage(playerid,"{ff6347}В этом бизнесе недоступна система объектов");
        if(!ReloadFrameBiz(params[0])) return ErrorMessage(playerid,"{ff6347}В этом бизнесе уже установлена планировка");

		format(string, sizeof(string), " [ ADM ]: %s сбросил планировку бизнеса № %d", PlayerInfo[playerid][pName], params[0]);
		ABroadCast(COLOR_ADM,string,1);

        format(string, sizeof(string), "Планировка бизнесу № %d", params[0]);
        AdminLog("reloadframebiz", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], string);
	}
	return 1;
}

stock ReloadFrameBiz(b)
{
	if(IsAJizzyBiz(b))
	{
        new Float:obj_pos[6], model;

        for(new i = 0; i < 8; i++)
		{
            if(BizzInfo[b][bOmodel][i] > 0) // Удалим перед созданием
            {
                DestroyDynamicObject(BizzInfo[b][bObject][i]);
                BizzInfo[b][bObject][i] = 0;
                BizzInfo[b][bOmodel][i] = 0;
                BizzInfo[b][bQara][i] = 0;
                BizzInfo[b][bUser][i] = 0;
            }

            if(i == 0) model = 14536;
            else if(i == 1) model = 14546;
            else if(i == 2) model = 14533;
            else if(i == 3) model = 14559;
            else if(i == 4) model = 14547;
            else if(i == 5) model = 14539;
            else if(i == 6) model = 14540;
            else if(i == 7) model = 14537;

            BizzInfo[b][bOmodel][i] = model;
            GetCoordFrame(BizzInfo[b][bOmodel][i], obj_pos[0], obj_pos[1], obj_pos[2], obj_pos[3], obj_pos[4], obj_pos[5]);
            BizzInfo[b][bObject][i] = CreateDynamicObject(BizzInfo[b][bOmodel][i], obj_pos[0], obj_pos[1], obj_pos[2], obj_pos[3], obj_pos[4], obj_pos[5], b+3000, 90, -1, 300.00, 300.00);
        }

        // Начало транзакции
		mysql_query(pearsq, "START TRANSACTION;");

        UpdateObjectBiz(b, 0, true, true);
        UpdateObjectBiz(b, 1, true, true);
        UpdateObjectBiz(b, 2, true, true);
        UpdateObjectBiz(b, 3, true, true);
        UpdateObjectBiz(b, 4, true, true);
        UpdateObjectBiz(b, 5, true, true);
        UpdateObjectBiz(b, 6, true, true);
        UpdateObjectBiz(b, 7, true, true);

        // Завершение транзакции
		mysql_query(pearsq, "COMMIT;");

        // Записываем модель 0 каркаса
        BizzInfo[b][bFrame] = BizzInfo[b][bOmodel][0];

        // Координаты точки выхода из инта
        BizzInfo[b][bInteriorX] = 1387.4436;
        BizzInfo[b][bInteriorY] = -16.2143;
        BizzInfo[b][bInteriorZ] = 1000.8868;
        BizzInfo[b][bInteriorA] = 359.7609;
        BizzInfo[b][bInterior] = 90;
		return 1;
	}
	else
	{
		if(BizzInfo[b][bOmodel][0] == 0)
		{
			BizzInfo[b][bOmodel][0] = 14665;
			new Float:obj_pos[6];
			GetCoordFrame(14665, obj_pos[0], obj_pos[1], obj_pos[2], obj_pos[3], obj_pos[4], obj_pos[5]);
			BizzInfo[b][bObject][0] = CreateDynamicObject(BizzInfo[b][bOmodel][0], obj_pos[0], obj_pos[1], obj_pos[2], obj_pos[3], obj_pos[4], obj_pos[5], b+3000, 90, -1, 300.00, 300.00);
			BizzInfo[b][bInteriorX] = 1387.4436, BizzInfo[b][bInteriorY] = -16.2143, BizzInfo[b][bInteriorZ] = 1000.8868, BizzInfo[b][bInteriorA] = 359.7609, BizzInfo[b][bInterior] = 90;
			BizzInfo[b][bFrame] = BizzInfo[b][bOmodel][0];
			UpdateObjectBiz(b, 0, true, true);
			return 1;
		}
	}
	return 0;
}

stock IsAJizzyBiz(b)
{
    if(b == 93) return 1;
    return 0;
}

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

    if(IsAJizzyBiz(biz) && oba <= 7) return ErrorMessage(playerid, "{FF6347}В этом бизнесе нельзя редактировать объекты планировки");
    if(oba == 0) return ErrorMessage(playerid, "{FF6347}Планировку нельзя редактировать");

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

    if(IsAJizzyBiz(biz) && oba <= 7) return ErrorMessage(playerid, "{FF6347}В этом бизнесе нельзя редактировать объекты планировки");
    if(oba == 0) return ErrorMessage(playerid, "{FF6347}Планировку нельзя редактировать");

    new model = BizzInfo[biz][bOmodel][oba];
    if(!NoInventoryFurnitureObject(model))
    {
        new resultPut = PutThingBiz(biz, BizzInfo[biz][bOmodel][oba], 1, 0, BizzInfo[biz][bQara][oba], 4, 999);
        if(resultPut == -1) return ErrorMessage(playerid, "{FF6347}В инвентаре бизнеса нет места");
    }
    else
    {
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Объект был полностью удалён\n{cccccc}Система не позволяет сохранять этот объект в инвентаре","*","");
    }
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
	return 1;
}

stock UpdateObjectBiz(b, obid, bool:updatePosition, bool:updateTextures) // Обновляем объект в bize
{
    if(LIMITED_LOADING_SERVER >= 2) return 1;
    if(b < 0 || b >= MAX_BIZ || obid < 0 || obid >= MAX_OBJECT_INT) return 1;

    if(updatePosition == true && updateTextures == true) UpdateObjectPosAndTextureBiz(b, obid);
    else if(updatePosition == true && updateTextures == false) UpdateObjectPositionBiz(b, obid);
    else if(updatePosition == false && updateTextures == true) UpdateObjectTexturesBiz(b, obid);
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
        format(string_mysql, sizeof(string_mysql), "INSERT INTO `pp_objects_biz` SET `biz`='%d', `slot`='%d', `user`='%d', `model`='%d', `qara`='%d', `world`='%d', `interior`='%d',\
            `ox`='%f', `oy`='%f', `oz`='%f', `orx`='%f', `ory`='%f', `orz`='%f'",
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
        new string_mysql[3800];
        new texture_update_string[3600];

        // Собираем строку обновления текстур
        BuildTextureString(2, b, obid, texture_update_string, sizeof(texture_update_string));

        new text_material_string[600];
        BuildTextString(2, b, obid, text_material_string);

        // Формирование запроса
        format(string_mysql, sizeof(string_mysql), "UPDATE `pp_objects_biz` SET %s %s WHERE `newid` = '%d'", 
            texture_update_string, text_material_string, BizzInfo[b][bNewid][obid]);

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

    new string_mysql[4200];
    new texture_update_string[3600];

    // Собираем строку обновления текстур
    BuildTextureString(2, b, obid, texture_update_string, sizeof(texture_update_string));

    new text_material_string[600];
    BuildTextString(2, b, obid, text_material_string);

    if(BizzInfo[b][bNewid][obid] == 0) // Если объекта нет в базе
    {
        format(string_mysql, sizeof(string_mysql), "INSERT INTO `pp_objects_biz` SET  `biz`='%d', `slot`='%d', `user`='%d', `model`='%d', `qara`='%d', `world`='%d', `interior`='%d', \
        `ox`='%f', `oy`='%f', `oz`='%f', `orx`='%f', `ory`='%f', `orz`='%f', %s  %s",
        b, obid, BizzInfo[b][bUser][obid], BizzInfo[b][bOmodel][obid], BizzInfo[b][bQara][obid], GetDynamicObjectVirtualWorld(BizzInfo[b][bObject][obid]), 
        GetDynamicObjectInterior(BizzInfo[b][bObject][obid]), pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], texture_update_string, text_material_string);
        mysql_tquery(pearsq, string_mysql, "Call_InsertObjectBiz", "dd", b, obid);
    }
    else // Если объект уже существует в базе
    {
        format(string_mysql, sizeof(string_mysql), "UPDATE `pp_objects_biz` SET `user` = '%d', `model` = '%d', `qara` = '%d', `world` = '%d', `interior` = '%d', \
        `ox` = '%f', `oy` = '%f', `oz` = '%f', `orx` = '%f', `ory` = '%f', `orz` = '%f', %s  %s WHERE `newid` = '%d'",
        BizzInfo[b][bUser][obid], BizzInfo[b][bOmodel][obid], BizzInfo[b][bQara][obid], GetDynamicObjectVirtualWorld(BizzInfo[b][bObject][obid]), 
        GetDynamicObjectInterior(BizzInfo[b][bObject][obid]), pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], texture_update_string, text_material_string, BizzInfo[b][bNewid][obid]);
        mysql_tquery(pearsq, string_mysql);
    }
    return 1;
}

function LoadObjectBiz() // Грузим объекты бизнесов
{
    new time = GetTickCount();
    new rows, sla, nd, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
    new world, interior, quanAllTextures;
    new ousetextL, oFontFaceL[64], oFontSizeL, oFontBoldL, oFontColorL, oBackColorL, oAlignmentL, oTextFontSizeL, oObjectTextL[64];
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
        cache_get_value_name_int(f, "ousetext", ousetextL);
        cache_get_value_name(f, "oFontFace", oFontFaceL, 64);
        cache_get_value_name_int(f, "oFontSize", oFontSizeL);
        cache_get_value_name_int(f, "oFontBold", oFontBoldL);
        cache_get_value_name_int(f, "oFontColor", oFontColorL);
        cache_get_value_name_int(f, "oBackColor", oBackColorL);
        cache_get_value_name_int(f, "oAlignment", oAlignmentL);
        cache_get_value_name_int(f, "oTextFontSize", oTextFontSizeL);
        cache_get_value_name(f, "oObjectText", oObjectTextL, 64);

        if(BizzInfo[nd][bOmodel][sla] >= 1) 
        {
            // Обработка world и interior
            //if(world == 0) world = nd + 3000;
            //if(interior == 0) interior = 90;

            // Создание объекта
            BizzInfo[nd][bObject][sla] = CreateDynamicObject(BizzInfo[nd][bOmodel][sla], x, y, z, rx, ry, rz, world, interior, -1, 200.00, 200.00);

            if(ousetextL)
            {
                SetDynamicObjectMaterialText(BizzInfo[nd][bObject][sla], 0, oObjectTextL, oFontSizeL, oFontFaceL, oTextFontSizeL, oFontBoldL, oFontColorL, oBackColorL, oAlignmentL);
            }

            // Получение и применение текстур к объекту
            new tempQuanTextures = LoadTexturesOnObject(nd, sla, f, 2);
            quanAllTextures += tempQuanTextures;
        }
    }
    printf("[MODE]: Объекты Бизнесов [Текстур %d][%d Quan][%d ms]", quanAllTextures, rows, GetTickCount() - time);
    return 1;
}

stock ParseMixedString(const input[], output[][44], outputSize)
{
    new partIndex = 0, charIndex = 0;

    // Проходим по каждому символу в строке
    for (new i = 0; input[i] != '\0' && partIndex < outputSize; i++)
    {
        if (input[i] == ',' || input[i + 1] == '\0')
        {
            // Добавляем последний символ, если это конец строки
            if (input[i + 1] == '\0' && input[i] != ',')
                output[partIndex][charIndex++] = input[i];

            output[partIndex][charIndex] = '\0'; // Завершаем текущую часть
            partIndex++; // Переходим к следующей части
            charIndex = 0; // Сбрасываем индекс символа
        }
        else
        {
            output[partIndex][charIndex++] = input[i]; // Добавляем символ к текущей части
        }
    }
    return 1; // Возвращаем 1, если обработка прошла успешно
}

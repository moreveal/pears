stock EditObjectDom(playerid, dom, oba)
{
	if(oba < 0 || oba >= MAX_OBJECT_INT) return ErrorMessage(playerid, "{FF6347}Несуществующий ID объекта");
    if(oba == 0) return ErrorMessage(playerid, "{FF6347}Планировку нельзя редактировать");
	if(DomInfo[dom][dOmodel][oba] == 0) return ErrorMessage(playerid, "{FF6347}Объекта не существует");
	if(!IsValidDynamicObject(DomInfo[dom][dObject][oba])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");
	if(Streamer_HasIntData(STREAMER_TYPE_OBJECT, DomInfo[dom][dObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) 
        && Streamer_GetIntData(STREAMER_TYPE_OBJECT, DomInfo[dom][dObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");

    if(oba < IsAQuanInterior(DomInfo[dom][dOmodel][0])) return ErrorMessage(playerid, "{FF6347}Нельзя перемещать детали планировки");

	new Float:ob[3];
    GetDynamicObjectPos(DomInfo[dom][dObject][oba],ob[0], ob[1], ob[2]);
  	if(!IsPlayerInRangeOfPoint(playerid, 20.0, ob[0], ob[1], ob[2])
		|| GetPlayerVirtualWorld(playerid) != GetDynamicObjectVirtualWorld(DomInfo[dom][dObject][oba])) return ErrorMessage(playerid, "{FF6347}Предмет далеко от вас");

	if(OnlineInfo[playerid][oShowInterface] == 2) CloseSmartfon(playerid);
	GoEditDynamicObject(playerid, REDAKT_TYPE_FURNITURE_SET, 1, dom, oba, DomInfo[dom][dObject][oba], 0);
	return 1;
}

stock InfoObjectDomBiz(playerid, type, id, oba)
{
    new max_objects = MAX_OBJECT_INT;
    if(type == 2) max_objects = MAX_OBJECT_INT_BIZ;

	if(oba < 0 || oba >= max_objects) return ErrorMessage(playerid, "{FF6347}Несуществующий ID объекта");
    if(oba == 0) return ErrorMessage(playerid, "{FF6347}Нельзя посмотреть информацию планировки");

    new model, object, userid;
    if(type == 1) model = DomInfo[id][dOmodel][oba], object = DomInfo[id][dObject][oba], userid = DomInfo[id][dUser][oba];
    else if(type == 2) model = BizzInfo[id][bOmodel][oba], object = BizzInfo[id][bObject][oba], userid = BizzInfo[id][bUser][oba];

	if(model == 0) return ErrorMessage(playerid, "{FF6347}Объекта не существует");
	if(!IsValidDynamicObject(object)) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");
    if(userid == 0) return ErrorMessage(playerid, "{FF6347}У объекта нет создателя\n{cccccc}Он был создан системой");

    new string[144];
	mysql_format(pearsq, string,sizeof(string),"SELECT Name FROM `pp_igroki` WHERE `user_id` = '%d'", userid);
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
	if(Streamer_HasIntData(STREAMER_TYPE_OBJECT, DomInfo[dom][dObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) 
        && Streamer_GetIntData(STREAMER_TYPE_OBJECT, DomInfo[dom][dObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");

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
    if(oba == 0) return ErrorMessage(playerid, "{FF6347}Планировку нельзя редактировать");
	if(DomInfo[dom][dOmodel][oba] == 0) return ErrorMessage(playerid, "{FF6347}Объекта не существует");
	if(!IsValidDynamicObject(DomInfo[dom][dObject][oba])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");
	if(Streamer_HasIntData(STREAMER_TYPE_OBJECT, DomInfo[dom][dObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) 
        && Streamer_GetIntData(STREAMER_TYPE_OBJECT, DomInfo[dom][dObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");
    if(oba < IsAQuanInterior(DomInfo[dom][dOmodel][0])) return ErrorMessage(playerid, "{FF6347}Нельзя удалять детали планировки");

    new model = DomInfo[dom][dOmodel][oba];
    if(!NoInventoryFurnitureObject(model))
    {
        new resultPut = PutThingDom(dom, model, 1, 0, DomInfo[dom][dQara][oba], 4, 0, 999);
        if(resultPut == -1) return ErrorMessage(playerid, "{FF6347}В инвентаре дома нет места");
    }
    else
    {
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Объект был полностью удалён\n{cccccc}Система не позволяет сохранять этот объект в инвентаре","*","");
    }
    if(!GetDynamicObjectElectro(oba)) 
    {
        DomInfo[dom][dElectroStatus] = DomInfo[dom][dElectroConnect];
        SaveElectro_Dom(dom);
    }
    DestroyDynamicObject(DomInfo[dom][dObject][oba]);
    DelObject(dom, oba);
    ClearVariableObjectDom(dom, oba);
    PlayerPlaySound(playerid,17001,0,0,0);

    Delete3DLabelDomBiz(dom, oba, 1);
	return 1;
}

stock NoInventoryFurnitureObject(model)
{
    if(model >= 19475 && model <= 19483) return 1;
    return 0;
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
    new max_objects = MAX_OBJECT_INT;
    if(type == 2) max_objects = MAX_OBJECT_INT_BIZ;

    for(new oba = 1; oba < max_objects; oba++)
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
    if(DomInfo[d][dSell] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя ремонтировать дом во время продажи");

    if(DP[0][playerid] == 0) DP[1][playerid] = 2; // Переместить объект интерьера дома
  	else if(DP[0][playerid] == 1) DP[1][playerid] = 4; // Изменить текстуры объекта интерьер дома
  	else if(DP[0][playerid] == 2) DP[1][playerid] = 3; // Убрать объект интерьер дома
    else return 1;

    PlayerPlaySound(playerid,40405,0,0,0);
    ShowAllObject(playerid, d, DP[1][playerid]);
	return 1;
}

/*stock setDomDefaultFrame(d) //  Ставим дефолтную планировку в дом
{
	DomInfo[d][dOmodel][0] = 14713;
	new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
	GetCoordFrame(14713, x, y, z, rx, ry, rz);
	DomInfo[d][dObject][0] = CreateDynamicObject(DomInfo[d][dOmodel][0], x, y, z, rx, ry, rz, d+1000, 90, -1, 100.00, 100.00);
	DomInfo[d][dEnterX] = 1387.4436, DomInfo[d][dEnterY] = -16.2143, DomInfo[d][dEnterZ] = 1000.8868, DomInfo[d][dEnterA] = 359.7609, DomInfo[d][dInterior] = 90;

	UpdateObject(d, 0);
	return 1;
}*/

stock DelObject(d, obid) // Удаляем объект из дома
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;
	if(d < 0 || d >= MAX_DOM || obid < 0 || obid >= MAX_OBJECT_INT) return 1;

    DelObjectOwner(d, obid, 0);
	return 1;
}
stock DelObjectOwner(d, obid, owner_type) // Удаляем объект из дома или бизнеса
{
	new string_mysql[160];
	mysql_format(pearsq, string_mysql,sizeof(string_mysql), "DELETE FROM `pp_owner_objects` WHERE `owner_type` = '%d' AND `owner_id` = '%d' AND `slot` = '%d'", owner_type, d, obid);
	query_empty(pearsq, string_mysql);
	return 1;
}


stock UpdateObject(d, obid) // Обновляем объект в доме
{
    if(LIMITED_LOADING_SERVER >= 2) return 1;
    if(d < 0 || d >= MAX_DOM || obid < 0 || obid >= MAX_OBJECT_INT) return 1;

    UpdateObjectOwner(d, obid, 0);
    return 1;
}

stock ClearVariableObjectDom(dom, oba)
{
    //DomInfo[dom][dNewid][oba] = 0;
    DomInfo[dom][dObject][oba] = 0;
    DomInfo[dom][dOmodel][oba] = 0;
    DomInfo[dom][dQara][oba] = 0;
    DomInfo[dom][dUser][oba] = 0;
}

stock RemoveAllObject(playerid, dom) // Удаляем объекты и отключаем взаимодействие
{
	// Начало транзакции
	mysql_tquery(pearsq, "START TRANSACTION;");

    for(new oba = IsAQuanInterior(DomInfo[dom][dOmodel][0]); oba < MAX_OBJECT_INT; oba++)
	{
	    if(DomInfo[dom][dOmodel][oba] >= 1) 
        {
            DestroyDynamicObject(DomInfo[dom][dObject][oba]);
            DelObject(dom, oba);
            ClearVariableObjectDom(dom, oba);
        }
	}

    DeleteAll3DLabel(dom, 1); // Удаляем лейблы всем игрокам
	DeleteInteractionDom(dom); // Отключаем взаимодействие в доме
    SaveDom(dom); // Сохраняем дом

    // Завершение транзакции
	mysql_tquery(pearsq, "COMMIT;");

    HouseLog(0, "rdomobject", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], dom, 0, "Удалил всю мебель");
	return 1;
}

stock ClearAllObject(playerid, dom) // Убираем все объекты в дом отключаем взаимодействие
{
	// Начало транзакции
	mysql_tquery(pearsq, "START TRANSACTION;");

	for(new oba = IsAQuanInterior(DomInfo[dom][dOmodel][0]); oba < MAX_OBJECT_INT; oba++)
	{
	    if(DomInfo[dom][dOmodel][oba] >= 1 && IsValidDynamicObject(DomInfo[dom][dObject][oba]))
        {
            if(!Streamer_HasIntData(STREAMER_TYPE_OBJECT, DomInfo[dom][dObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT)
                || Streamer_GetIntData(STREAMER_TYPE_OBJECT, DomInfo[dom][dObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) <= 0)
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

    DeleteAll3DLabel(dom, 1); // Удаляем лейблы всем игрокам
	DeleteInteractionDom(dom);
    SaveDom(dom);

    // Завершение транзакции
	mysql_tquery(pearsq, "COMMIT;");

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

stock GetMaxDomObjects(dom)
{
    new max_objects = MAX_OBJECT_INT;
    if (!DomInfo[dom][dMoreIntObjects]) max_objects -= 200;
    return max_objects;
}

function LoadObject(stat, owner_type) // Грузим объекты интерьера для дома и бизнеса
{
    new time = GetTickCount();
    new rows;
    new quanAllTextures;
    
    cache_get_row_count(rows);

    for(new f = 0; f < rows; ++f)
    {
        new temptextures;
        if(owner_type == 0) temptextures = NewLoadObject(f, 0); // 0 - Грузим дома
        else if(owner_type == 1) temptextures = NewLoadObject(f, 1); // 1 - Грузим Бизы
        quanAllTextures += temptextures;
    }
    if(owner_type == 0)
    {
        printf("[MODE]: Объекты Домов [Текстур %d][%d Quan][%d ms]", quanAllTextures, rows, GetTickCount() - time);
        if(stat == 0) Launch3(); // Грузим теперь следующие 501 - 1000
        else if(stat == 1) Launch6(); // Грузим объекты бизов (После бизов сервер откроется и загрузятся NPC)
    }
    else if(owner_type == 1) 
    {
        printf("[MODE]: Объекты Бизнесов [Текстур %d][%d Quan][%d ms]", quanAllTextures, rows, GetTickCount() - time);
        Launch5(); // Открываем сервер и загружаем NPC
    }
    return 1;
}

stock UpdateObjectOwner(nd, sla, owner_type)
{
    if(LIMITED_LOADING_SERVER >= 2) return 1;

    new JsonNode:node;
    CreateJsonUpdateObject(nd, sla, owner_type, node);

    new string_json[4096];
    if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
    {
        new string_mysql[4600];
        mysql_format(pearsq, string_mysql, sizeof(string_mysql), "INSERT INTO `pp_owner_objects` (`owner_type`, `owner_id`, `slot`, `data`) \
        VALUES ('%d', '%d', '%d', '%e') ON DUPLICATE KEY UPDATE data = VALUES(data)", owner_type, nd, sla, string_json);

        mysql_tquery(pearsq, string_mysql, "", "");
    }
    return 1;
}

stock CreateJsonUpdateObject(nd, sla, owner_type, &JsonNode:node) // Сохраняем объект в доме и бизе
{
    new objectid, userid, model, qara, world, interior, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
    if(owner_type == 0) // Dom
    {
        objectid = DomInfo[nd][dObject][sla];
        userid = DomInfo[nd][dUser][sla];
        model = DomInfo[nd][dOmodel][sla];
        qara = DomInfo[nd][dQara][sla];
    }
    else if(owner_type == 1) // Biz
    {
        objectid = BizzInfo[nd][bObject][sla];
        userid = BizzInfo[nd][bUser][sla];
        model = BizzInfo[nd][bOmodel][sla];
        qara = BizzInfo[nd][bQara][sla];
    }

    world = GetDynamicObjectVirtualWorld(objectid);
    interior = GetDynamicObjectInterior(objectid);
    GetDynamicObjectPos(objectid, x, y, z);
    GetDynamicObjectRot(objectid, rx, ry, rz);

    // Собираем текстуры
    new JsonNode:obj_textures = JSON_Array();
    {
        for(new i = 0; i < MAX_OBJECT_TEXTURES; i++)
        {
            new modelid, texturelib[32], texturename[32], materialcolor;
            GetDynamicObjectMaterial(objectid, i, modelid, texturelib, texturename, materialcolor);
            if(modelid > 0)
            {
                JSON_ArrayAppendEx(obj_textures, JSON_Object(
                        "tslot", JSON_Int(i),
                        "tmodel", JSON_Int(modelid),
                        "tlib", JSON_String(texturelib),
                        "tname", JSON_String(texturename),
                        "tmatcolor", JSON_Int(materialcolor)
                    )
                );
            }
        }
    }

    // Собираем Текст
    new JsonNode:obj_text = JSON_Array();
    {
        for(new i = 0; i < 1; i++)
        {
            new yesText, oFontFaceL[64], oFontSizeL, oFontBoldL, oFontColorL, oBackColorT, oAlignmentT, oTextFontSizeT, oObjectTextL[64];
            yesText = GetDynamicObjectMaterialText(objectid, i, oObjectTextL, oFontSizeL, oFontFaceL, oTextFontSizeT, oFontBoldL, oFontColorL, oBackColorT, oAlignmentT);

            if(yesText)
            {
                JSON_ArrayAppendEx(obj_text, JSON_Object(
                        "textslot", JSON_Int(i),
                        "oFontFace", JSON_String(oFontFaceL),
                        "oFontSize", JSON_Int(oFontSizeL),
                        "oFontBold", JSON_Int(oFontBoldL),
                        "oFontColor", JSON_Int(oFontColorL),
                        "oBackColor", JSON_Int(oBackColorT),
                        "oAlignment", JSON_Int(oAlignmentT),
                        "oTextFontSize", JSON_Int(oTextFontSizeT),
                        "oObjectText", JSON_String(oObjectTextL)
                    )
                );
            }
        }
    }


    node = JSON_Object(
        // Инфа объекта
        "user", JSON_Int(userid),

        // Объект объекта
        "obj", JSON_Object(
            "model", JSON_Int(model),
            "qara", JSON_Int(qara),
            "world", JSON_Int(world),
            "interior", JSON_Int(interior)
        ),

        // Позиция объекта
        "pos", JSON_3DVector(x, y, z),
        "rot", JSON_3DVector(rx, ry, rz),

        // Текстуры
        "textures", obj_textures,

        // Текст
        "texts", obj_text
    );
    return 1;
}

// Новая загрузка объектов домов и бизов
stock NewLoadObject(f, owner_type)
{
    new sla, nd, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
    new textslot, oFontFaceL[64], oFontSizeL, oFontBoldL, oFontColorL, oBackColorL, oAlignmentL, oTextFontSizeL, oObjectTextL[64];
    new world, interior;
    new textureslot, texturemodel, texturelib[32], texturename[32], materialcolor; 

    cache_get_value_name_int(f, "owner_id", nd);
    cache_get_value_name_int(f, "slot", sla);
    //if(owner_type == 0) cache_get_value_name_int(f, "newid", DomInfo[nd][dNewid][sla]);
    //else if(owner_type == 1) cache_get_value_name_int(f, "newid", BizzInfo[nd][bNewid][sla]);

    new string_json[4096];
	cache_get_value_name(f, "data", string_json, sizeof(string_json));

    new JsonNode:node = JSON_INVALID_NODE;
    if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
    {
        // Инфа объекта
        if(owner_type == 0) JSON_GetInt(node, "user", DomInfo[nd][dUser][sla]);
        else if(owner_type == 1) JSON_GetInt(node, "user", BizzInfo[nd][bUser][sla]);

        // Объект объекта
        new JsonNode:obj = JSON_INVALID_NODE;
        JSON_GetObject(node, "obj", obj);
        if(owner_type == 0)
        {
            JSON_GetInt(obj, "model", DomInfo[nd][dOmodel][sla]);
            JSON_GetInt(obj, "qara", DomInfo[nd][dQara][sla]);
        }
        else if(owner_type == 1)
        {
            JSON_GetInt(obj, "model", BizzInfo[nd][bOmodel][sla]);
            JSON_GetInt(obj, "qara", BizzInfo[nd][bQara][sla]);
        }
        JSON_GetInt(obj, "world", world);
        JSON_GetInt(obj, "interior", interior);

        // Позиция объекта
        JSON_Get3DVector(node, "pos", x, y, z);
        JSON_Get3DVector(node, "rot", rx, ry, rz);

        if(owner_type == 0) DomInfo[nd][dObject][sla] = CreateDynamicObject(DomInfo[nd][dOmodel][sla], x, y, z, rx, ry, rz, world, interior, -1, 200.00, 200.00);
        else if(owner_type == 1) BizzInfo[nd][bObject][sla] = CreateDynamicObject(BizzInfo[nd][bOmodel][sla], x, y, z, rx, ry, rz, world, interior, -1, 200.00, 200.00);

        // Текстуры Объекта
        new JsonNode:obj_textures = JSON_INVALID_NODE;
        JSON_GetArray(node, "textures", obj_textures);
        {
            new JsonNode:texture = JSON_INVALID_NODE;
            new index = -1;
            while(!JSON_ArrayIterate(obj_textures, index, texture))
            {
                JSON_GetInt(texture, "tslot", textureslot);
                JSON_GetInt(texture, "tmodel", texturemodel);
                JSON_GetString(texture, "tlib", texturelib);
                JSON_GetString(texture, "tname", texturename);
                JSON_GetInt(texture, "tmatcolor", materialcolor);

                if(owner_type == 0) SetDynamicObjectMaterial(DomInfo[nd][dObject][sla], textureslot, texturemodel, texturelib, texturename, materialcolor);
                else if(owner_type == 1) SetDynamicObjectMaterial(BizzInfo[nd][bObject][sla], textureslot, texturemodel, texturelib, texturename, materialcolor);
            }
        }

        // Текст Объекта
        new JsonNode:obj_text = JSON_INVALID_NODE;
        JSON_GetArray(node, "texts", obj_text);
        {
            new JsonNode:text = JSON_INVALID_NODE;
            new index = -1;
            while(!JSON_ArrayIterate(obj_text, index, text))
            {
                JSON_GetInt(text, "textslot", textslot);
                JSON_GetString(text, "oFontFace", oFontFaceL);
                JSON_GetInt(text, "oFontSize", oFontSizeL);
                JSON_GetInt(text, "oFontBold", oFontBoldL);
                JSON_GetInt(text, "oFontColor", oFontColorL);
                JSON_GetInt(text, "oBackColor", oBackColorL);
                JSON_GetInt(text, "oAlignment", oAlignmentL);
                JSON_GetInt(text, "oTextFontSize", oTextFontSizeL);
                JSON_GetString(text, "oObjectText", oObjectTextL);
                if(owner_type == 0) SetDynamicObjectMaterialText(DomInfo[nd][dObject][sla], textslot, oObjectTextL, oFontSizeL, oFontFaceL, oTextFontSizeL, oFontBoldL, oFontColorL, oBackColorL, oAlignmentL);
                else if(owner_type == 1) SetDynamicObjectMaterialText(BizzInfo[nd][bObject][sla], textslot, oObjectTextL, oFontSizeL, oFontFaceL, oTextFontSizeL, oFontBoldL, oFontColorL, oBackColorL, oAlignmentL);
            }
        }
    }
    return 1;
}

stock JSON_Get3DVector(&JsonNode:node, const key[], &Float:x, &Float:y, &Float:z) {
    new JsonNode:vec3d = JSON_INVALID_NODE;
    JSON_GetObject(node, key, vec3d);
    JSON_GetFloat(vec3d, "x", x);
    JSON_GetFloat(vec3d, "y", y);
    JSON_GetFloat(vec3d, "z", z);
    return 1;
}

// Комнада для пересбора текстур к новому набору
/*new stopReload;
CMD:reloadtexture(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(server == 0) return ErrorMessage(playerid, "{FF6347}Для тестового сервера, все объекты были обработаны");
	if(stopReload == 1) return ErrorMessage(playerid, "{FF6347}Команда уже была запущена, объекты обрабатываются");
	if(stopReload == 2) return ErrorMessage(playerid, "{FF6347}Все объекты обработаны");

	stopReload = 1;
	// Начало транзакции
	mysql_tquery(pearsq, "START TRANSACTION;");

	for(new d = 0; d < MAX_DOM; d++)
	{
		for(new obid = 0; obid < MAX_OBJECT_INT; obid++)
		{
			if(DomInfo[d][dOmodel][obid] >= 1)
			{
				new yesUpdate;
				for(new t = 0; t < MAX_TEXTURES_ON_OBJECTS; t++)
				{
                    // Замена ID текстуры с дальнейшим сохранением
					new oldTextureId = DomTexture[d][obid][t] - 1;
					if(oldTextureId >= 0)
					{
						yesUpdate ++;

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
	mysql_tquery(pearsq, "COMMIT;");

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
}*/

// Перебрасываем текстуры в новую таблицу
/*new stopsaveTextures;
CMD:savetexture(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	//if(server == 0) return ErrorMessage(playerid, "{FF6347}Для тестового сервера, все объекты были обработаны");
	if(stopsaveTextures == 1) return ErrorMessage(playerid, "{FF6347}Команда уже была запущена, объекты обрабатываются");
	if(stopsaveTextures == 2) return ErrorMessage(playerid, "{FF6347}Все объекты обработаны");

	stopsaveTextures = 1;
	// Начало транзакции
	//mysql_tquery(pearsq, "START TRANSACTION;");

	for(new d = 0; d < MAX_DOM; d++)
    //for(new d = 0; d < MAX_BIZ; d++)
	{
		for(new obid = 0; obid < MAX_OBJECT_INT; obid++)
		{
            if(DomInfo[d][dOmodel][obid] > 0) UpdateObjectOwner(d, obid, 0);
            //if(BizzInfo[d][bOmodel][obid] > 0) UpdateObjectOwner(d, obid, 1);
		}
	}

	// Завершение транзакции
	//mysql_tquery(pearsq, "COMMIT;");

	stopsaveTextures = 2;
	return 1;
}*/



#pragma warning disable 240
#include "../gamemodes/source/biz/biz_interior_default.pwn" // Дефолтные интерьеры бизнесов
#pragma warning enable 240

alias:rbizint("reloadbizint", "reloadintbit", "rintbiz")
CMD:rbizint(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid,"{ff6347}Вы не можете использовать эту команду");
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сбросить интерьер бизнеса [ /rbizint ID ]");
	if(params[0] < 0 || params[0] >= MAX_BIZ) return ErrorMessage(playerid,"{ff6347}Неверный ID бизнеса\n{cccccc}0 - сбросить интерьер всех бизнесов");

    new string[140];
    DP[0][playerid] = params[0];
    if(params[0] == 0) format(string, sizeof(string), "Вы уверены, что хотите сбросить интерьеры всех бизнесов?");
    else format(string, sizeof(string), "Вы уверены, что хотите сбросить интерьер бизнеса № %d ?", params[0]);
	ShowDialog(playerid,1155,DIALOG_STYLE_MSGBOX,"Сброс Интерьера",string,"Да","Нет");
    return true;
}

// Процесс сброса интерьера
stock ReloadBizInterior(b)
{
    // Удалим все объекты перед созданием нового интерьера
    DeleteAllObjectBizz(b);

    // Устанавливаем интерьеры в клубы и бары
    if(b == 93) CreateBizInterior(b, 0); // Интерьер Jizzy
    else if(b == 94 || b == 95) CreateBizInterior(b, 2); // Интерьер Alhambra
    else if(b == 96) CreateBizInterior(b, 8); // Интерьер Pig Pen
    else if(b == 97 || b == 98 || b == 101 || b == 102) CreateBizInterior(b, 3); // Интерьер большого Клуба (Ретекстур каркаса ресторана)
    else if(b == 99 || b == 100) CreateBizInterior(b, 1); // Интерьер мини бар стендап

    // Устанавливаем интерьеры в закусочные
    else if(b == 103 || b == 109 || b == 116) CreateBizInterior(b, 4); // Интерьер закусочной тёмный (ааахуенный хавчик)
    else if(b == 104 || b == 113 || b == 115 || b == 117) CreateBizInterior(b, 6); // Интерьер Pizza (ретекстуренный инт из гетто)
    else if(b == 105 || b == 106 || b == 108 || b == 110 || b == 111 || b == 114) CreateBizInterior(b, 5); // Интерьер Cluckin bell (который всегда был в sf возле sfpd)
    else if(b == 107 || b == 112) CreateBizInterior(b, 7); // Интерьер закусочной светлый (ааахуенный хавчик)

    // Сохраняем все объекты в бизнесе
    SaveAllObjectBizz(b);
    return true;
}

stock SaveAllObjectBizz(b)
{
    mysql_tquery(pearsq, "START TRANSACTION;");
    for(new i = 0; i < MAX_OBJECT_INT_BIZ; i++)
    {
        if(BizzInfo[b][bOmodel][i] > 0) UpdateObjectBiz(b, i);
    }
    mysql_tquery(pearsq, "COMMIT;");
    return true;
}

// Удаление всех объектов в бизнесе
stock DeleteAllObjectBizz(b)
{
    mysql_tquery(pearsq, "START TRANSACTION;");
    for(new i = 0; i < MAX_OBJECT_INT_BIZ; i++)
    {
        if(BizzInfo[b][bOmodel][i] > 0)
        {
            DestroyDynamicObject(BizzInfo[b][bObject][i]);
            ClearVariableObjectBiz(b, i);
            UpdateObjectBiz(b, i);
        }
    }
    mysql_tquery(pearsq, "COMMIT;");
    return true;
}

// Выполняем сброс интерьера
stock PreReloadBizInterior(playerid, idx)
{
    new string[140];
    if(idx == 0)
    {
        new quan;
        for(new b = 1; b < sizeof(BizzInfo); b++)
        {
            if(IsABizInteriorFrame(b)) ReloadBizInterior(b), quan ++;
        }

        format(string, sizeof(string), " [ ADM ]: %s сбросил интерьеры всех бизнесов (Количество: %d)", PlayerInfo[playerid][pName], quan);
		ABroadCast(COLOR_ADM,string,1);
        AdminLog("rbizint", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Интерьеры всех бизнесов");
    }
    else
    {
        if(idx >= MAX_BIZ) return ErrorMessage(playerid,"{ff6347}Ошибка! Такого номера бизнеса не существует");
        if(!IsABizInteriorFrame(idx)) return ErrorMessage(playerid,"{ff6347}В этом бизнесе недоступна система объектов");
		format(string, sizeof(string), " [ ADM ]: %s сбросил интерьер бизнеса № %d", PlayerInfo[playerid][pName], idx);
		ABroadCast(COLOR_ADM,string,1);
        format(string, sizeof(string), "Интерьер бизнеса № %d", idx);
        AdminLog("rbizint", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", idx, string);

        ReloadBizInterior(idx);
    }
    return true;
}

stock IsAJizzyBiz(b)
{
    if(b == 93) return 1;
    return 0;
}

stock ReloadBizWhore(b, Float:x, Float:y, Float:z, Float:a)
{
    DestroyBizWhore(b);

    BizzInfo[b][bShluhaCord][0] = x;
    BizzInfo[b][bShluhaCord][1] = y;
    BizzInfo[b][bShluhaCord][2] = z;
    BizzInfo[b][bShluhaCord][3] = a;
	BizzInfo[b][bShluha] = 1;
	BizShluhaStatus[b] = -1;

    CreateShluha(b);
    SaveBizz(b);
    return true;
}

stock ReloadBizBar(b, Float:x, Float:y, Float:z)
{
    DestroyBizBar(b);

    BizzInfo[b][bBarX] = x;
    BizzInfo[b][bBarY] = y;
    BizzInfo[b][bBarZ] = z;
	BizzInfo[b][bBar] = 1;

    CreateBarLabel(b);
    SaveBizz(b);
    return true;
}

stock ClearAllObjectBiz(playerid, biz) // Убираем все объекты в биз
{
	// Начало транзакции
	mysql_tquery(pearsq, "START TRANSACTION;");

	for(new oba = IsAQuanInterior(BizzInfo[biz][bOmodel][0]); oba < MAX_OBJECT_INT_BIZ; oba++)
	{
	    if(BizzInfo[biz][bOmodel][oba] >= 1 && IsValidDynamicObject(BizzInfo[biz][bObject][oba]))
        {
            if(!Streamer_HasIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT)
                || Streamer_GetIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) <= 0)
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
	mysql_tquery(pearsq, "COMMIT;");

    DeleteAll3DLabel(biz, 2); // Удаляем лейблы всем игрокам
    BizLog("clearobject", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], biz, 0, "Убрал мебель");
	return 1;
}

stock RemoveAllObjectBiz(playerid, biz) // Удаляем объекты
{
	// Начало транзакции
	mysql_tquery(pearsq, "START TRANSACTION;");

	for(new oba = IsAQuanInterior(BizzInfo[biz][bOmodel][0]); oba < MAX_OBJECT_INT_BIZ; oba++)
	{
	    if(BizzInfo[biz][bOmodel][oba] >= 1) 
        {
            DestroyDynamicObject(BizzInfo[biz][bObject][oba]);
            DelObjectBiz(biz, oba);
            ClearVariableObjectBiz(biz, oba);
        }
	}

	// Завершение транзакции
	mysql_tquery(pearsq, "COMMIT;");

    DeleteAll3DLabel(biz, 2); // Удаляем лейблы всем игрокам
    BizLog("rbizobject", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], biz, 0, "Удалил всю мебель");
	return 1;
}

stock EditObjectBiz(playerid, biz, oba)
{
	if(CheckObjectRedaktBiz(playerid, biz, oba)) return false;
    if(oba < IsAQuanInterior(BizzInfo[biz][bOmodel][0])) return ErrorMessage(playerid, "{FF6347}Нельзя перемещать детали планировки");

	new Float:ob[3];
    GetDynamicObjectPos(BizzInfo[biz][bObject][oba],ob[0], ob[1], ob[2]);
  	if(!IsPlayerInRangeOfPoint(playerid, 20.0, ob[0], ob[1], ob[2])
		|| GetPlayerVirtualWorld(playerid) != GetDynamicObjectVirtualWorld(BizzInfo[biz][bObject][oba])) return ErrorMessage(playerid, "{FF6347}Предмет далеко от вас");

	if(OnlineInfo[playerid][oShowInterface] == 2) CloseSmartfon(playerid);
    if(Komputer[playerid] == 2) exitkomp(playerid, 2);
	GoEditDynamicObject(playerid, REDAKT_TYPE_BIZ_FURNITURE_SET, 1, biz, oba, BizzInfo[biz][bObject][oba], 0);
	return 1;
}

stock CopyMaterialObjectBiz(playerid, biz, oba)
{
    if(CheckObjectRedaktBiz(playerid, biz, oba)) return true;

    new Float:ob[3];
    GetDynamicObjectPos(BizzInfo[biz][bObject][oba],ob[0], ob[1], ob[2]);
  	if(!IsPlayerInRangeOfPoint(playerid, 20.0, ob[0], ob[1], ob[2])
		|| GetPlayerVirtualWorld(playerid) != GetDynamicObjectVirtualWorld(BizzInfo[biz][bObject][oba])) return ErrorMessage(playerid, "{FF6347}Предмет далеко от вас");

    new quan = CopyMaterialsFromObject(playerid, BizzInfo[biz][bObject][oba]);
    if(quan == 0) return ErrorMessage(playerid, "{FF6347}На этом объекте нет ретекстура");

    PlayerPlaySound(playerid,17001,0,0,0);
    new string[100];
	format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~ЏEKCЏYP‘ CKOЊ…PO‹AH‘~n~OЂђEKЏ ~y~%d", oba);
	GameTextForPlayer(playerid,string,1500,3);
    return true;
}

stock PasteMaterialObjectBiz(playerid, biz, oba)
{
    if(CheckObjectRedaktBiz(playerid, biz, oba)) return true;

    new Float:ob[3];
    GetDynamicObjectPos(BizzInfo[biz][bObject][oba],ob[0], ob[1], ob[2]);
  	if(!IsPlayerInRangeOfPoint(playerid, 20.0, ob[0], ob[1], ob[2])
		|| GetPlayerVirtualWorld(playerid) != GetDynamicObjectVirtualWorld(BizzInfo[biz][bObject][oba])) return ErrorMessage(playerid, "{FF6347}Предмет далеко от вас");

    new string[140];
    new quanCopyTexture = GetQuanCopyMaterial(playerid);
    new quanObjectTexture = GetTexturesOnObject(BizzInfo[biz][bOmodel][oba]);
    if(quanCopyTexture > quanObjectTexture)
    {
        format(string,sizeof(string),"{FF6347}Количество текстур в буфере обмена больше чем слотов текстур на объекте/
        \n\n{cccccc}В буфере обмена: %d\n{cccccc}Слотов на объекте: %d", quanCopyTexture, quanObjectTexture);
        ErrorMessage(playerid, "{FF6347}Количество текстур в буфере обмена больше чем слотов текстур на объекте");
        return true;
    }
    
    if(PasteMaterialsToObject(playerid, BizzInfo[biz][bObject][oba]))
    {
        PlayerPlaySound(playerid,6801,0,0,0);
        format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~ЏEKCЏYP‘ ЊP…MEHEH‘~n~OЂђEKЏ ~y~%d", oba);
	    GameTextForPlayer(playerid,string,1500,3);

        UpdateObjectBiz(biz, oba);
    }
    else ErrorMessage(playerid, "{FF6347}В буфере обмена нет текстур");
    return true;
}

stock PosObjectBiz(playerid, biz, oba, Float:x = 0.0, Float:y = 0.0, Float:z = 0.0, Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0)
{
	if(CheckObjectRedaktBiz(playerid, biz, oba)) return false;
    if(oba < IsAQuanInterior(BizzInfo[biz][bOmodel][0])) return ErrorMessage(playerid, "{FF6347}Нельзя перемещать детали планировки");

	new Float:ob[3];
    GetDynamicObjectPos(BizzInfo[biz][bObject][oba], ob[0], ob[1], ob[2]);
  	if(!IsPlayerInRangeOfPoint(playerid, 20.0, ob[0], ob[1], ob[2])
		|| GetPlayerVirtualWorld(playerid) != GetDynamicObjectVirtualWorld(BizzInfo[biz][bObject][oba])) return ErrorMessage(playerid, "{FF6347}Предмет далеко от вас");

    new Float:rob[3];
    GetDynamicObjectRot(BizzInfo[biz][bObject][oba], rob[0], rob[1], rob[2]);

    if(x != 0.0) ob[0] += x;
    if(y != 0.0) ob[1] += y;
    if(z != 0.0) ob[2] += z;
    if(rx != 0.0) rob[0] = rx;
    if(ry != 0.0) rob[1] = ry;
    if(rz != 0.0) rob[2] = rz;

	SetDynamicObjectPos(BizzInfo[biz][bObject][oba], ob[0], ob[1], ob[2]);
    SetDynamicObjectRot(BizzInfo[biz][bObject][oba], rob[0], rob[1], rob[2]);

    Update3DLabelDomBiz(biz, oba, 1);
    UpdateObjectBiz(biz, oba);
	return 1;
}

stock CheckObjectRedaktBiz(playerid, biz, oba)
{
    if(oba < 0 || oba >= MAX_OBJECT_INT_BIZ) return ErrorMessage(playerid, "{FF6347}Несуществующий ID объекта");
	if(BizzInfo[biz][bOmodel][oba] == 0) return ErrorMessage(playerid, "{FF6347}Объекта не существует");
	if(!IsValidDynamicObject(BizzInfo[biz][bObject][oba])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");
	if(Streamer_HasIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT)
        && Streamer_GetIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");

    return false;
}

stock DeleteObjectBiz(playerid, biz, oba)
{
	if(CheckObjectRedaktBiz(playerid, biz, oba)) return false;
    if(oba < IsAQuanInterior(BizzInfo[biz][bOmodel][0])) return ErrorMessage(playerid, "{FF6347}Нельзя удалять детали планировки");

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
	if(CheckObjectRedaktBiz(playerid, biz, oba)) return false;
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
    BizzInfo[biz][bObject][oba] = 0;
    BizzInfo[biz][bOmodel][oba] = 0;
    BizzInfo[biz][bQara][oba] = 0;
    BizzInfo[biz][bUser][oba] = 0;
}

stock getFreeSlotObjectBiz(biz)
{
	new slot = -1;
	for(new oba = 1; oba < MAX_OBJECT_INT_BIZ; oba++)
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
	for(new oba = 1; oba < MAX_OBJECT_INT_BIZ; oba++)
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
	if(b < 0 || b >= MAX_BIZ || obid < 0 || obid >= MAX_OBJECT_INT_BIZ) return 1;

    DelObjectOwner(b, obid, 1);
	return 1;
}

stock UpdateObjectBiz(b, obid) // Обновляем объект в bize
{
    if(LIMITED_LOADING_SERVER >= 2) return 1;
    if(b < 0 || b >= MAX_BIZ || obid < 0 || obid >= MAX_OBJECT_INT_BIZ) return 1;

    UpdateObjectOwner(b, obid, 1);
    return 1;
}

stock dialogCase_BizInterior(playerid, dialogid, response)
{
    if(dialogid == 1155)
    {
        if(response) ReloadBizInterior(DP[0][playerid]);
        return true;
    }
    return false;
}

// Сохраняем текущий id интерьер в бизнесе из набора интерьеров
stock SetBizThisInterior(biz, intid)
{
    if(biz <= 0 || biz >= MAX_BIZ) return false;
    BizzInfo[biz][bInteriorPack] = intid;

    new string_mysql[100];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_bizz` SET `bInteriorPack` = '%d' WHERE `newid` = '%d'", BizzInfo[biz][bInteriorPack], biz);
	query_empty(pearsq, string_mysql);
    return true;
}

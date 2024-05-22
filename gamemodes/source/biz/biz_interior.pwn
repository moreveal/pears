
/*
// Старая шляпа для установки каркасов в бизы
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
		mysql_tquery(pearsq, "START TRANSACTION;");

        UpdateObjectBiz(b, 0);
        UpdateObjectBiz(b, 1);
        UpdateObjectBiz(b, 2);
        UpdateObjectBiz(b, 3);
        UpdateObjectBiz(b, 4);
        UpdateObjectBiz(b, 5);
        UpdateObjectBiz(b, 6);
        UpdateObjectBiz(b, 7);

        // Завершение транзакции
		mysql_tquery(pearsq, "COMMIT;");

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
			UpdateObjectBiz(b, 0);
			return 1;
		}
	}
	return 0;
}*/

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
    for(new i = 0; i < MAX_OBJECT_INT; i++)
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
    for(new i = 0; i < MAX_OBJECT_INT; i++)
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

	for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
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
	mysql_tquery(pearsq, "COMMIT;");

    DeleteAll3DLabel(biz, 2); // Удаляем лейблы всем игрокам
    BizLog("rbizobject", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], biz, 0, "Удалил всю мебель");
	return 1;
}

stock EditObjectBiz(playerid, biz, oba)
{
	if(oba < 0 || oba >= MAX_OBJECT_INT) return ErrorMessage(playerid, "{FF6347}Несуществующий ID объекта");
	if(BizzInfo[biz][bOmodel][oba] == 0) return ErrorMessage(playerid, "{FF6347}Объекта не существует");
	if(!IsValidDynamicObject(BizzInfo[biz][bObject][oba])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");
	if(Streamer_HasIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT)
        && Streamer_GetIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");

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
	if(Streamer_HasIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT)
        && Streamer_GetIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");

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
	if(Streamer_HasIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT)
        && Streamer_GetIntData(STREAMER_TYPE_OBJECT, BizzInfo[biz][bObject][oba], STREAMER_EDITABLE_DYNAMIC_OBJECT) >= 1) return ErrorMessage(playerid, "{FF6347}Этот объект кто-то редактирует");

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

    DelObjectOwner(b, obid, 1);
	return 1;
}

stock UpdateObjectBiz(b, obid) // Обновляем объект в bize
{
    if(LIMITED_LOADING_SERVER >= 2) return 1;
    if(b < 0 || b >= MAX_BIZ || obid < 0 || obid >= MAX_OBJECT_INT) return 1;

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


#define STREAMER_EDITABLE_DYNAMIC_OBJECT   E_STREAMER_CUSTOM(4)

enum editObjectInfoEnum
{
    editPlayerOrDynamic, // 0 Player, 1 Dynamic (Какую систему редактирования используем - 0 временный объект New System, 1 постоянный Old)
    editType, // Тип: Создание 0 или Перемещение 1
    editTempObject, // ID Временного объекта
    editOption, // ID дома для которого ректируем объект или id бизнеса (Дополнительная переменная для хранения информации)
    editSlot, // Slot редактируемого объекта в разных системах
    editObjectid, // ID объекта, если редактируется DynamicObject
    editDopOption, // Дополнительная переменная для хранения информации
    editOne, // Начало процесса редактирования
    Float:editOldPos[6], // Координаты прежней позиции объекта
};
new EditObjectInfo[MAX_REALPLAYERS][editObjectInfoEnum];

// Начинаем редактирование объекта (New System 14.11.2023)
/* Инструкция

- Если мы хотим создать новый объект для сервера в любую систему, используем: CreateEditPlayerObject
 id Номер gRedakt (31 и 32 использовать НЕЛЬЗЯ!)
 type 0 создаём объект, 1 перемещаем уже созданный ранее
 option доп информация, например номер дома или бизнеса
 slot слот для объекта, в к примеру в том же доме
 modelid модель объекта
 дальше координаты
 - Затем в stock SaveEditPlayerObject добавляем новый gRedakt по списку с условиями для соответствующей системы
 ВСЁ

 - Если хотим отредачить уже существующий объект, используем: GoEditDynamicObject(playerid, id, type, option, slot, objectid, dopoption)
 id номер gRedakt (31 и 32 использовать НЕЛЬЗЯ!)
 type 0 создаём, 1 перемещаем
 option доп информация, например номер дома или бизнеса
 slot слот для объекта, в к примеру в том же доме
 objectid - идентификатор объекта, который был создан ранее
 - Затем в OnPlayerEditDynamicObject под EDIT_RESPONSE_FINAL добавляем условия для соответствующей системы (лейблы там и т.д.)
*/
stock CreateEditPlayerObject(playerid, id, type, option, slot, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    EditObjectInfo[playerid][editPlayerOrDynamic] = 0;
    gRedakt[playerid] = id;
    EditObjectInfo[playerid][editType] = type;
    EditObjectInfo[playerid][editOption] = option;
    EditObjectInfo[playerid][editSlot] = slot;

    EditObjectInfo[playerid][editTempObject] = CreatePlayerObject(playerid, modelid, x, y, z, rx, ry, rz, 300.0);
    EditPlayerObject(playerid, EditObjectInfo[playerid][editTempObject]);
    PlayerPlaySound(playerid,17000,0,0,0);
	return 1;
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
    if(OnlineInfo[playerid][oLogged] == 0) return 0;

    // Only PlayerObject (Редактируется временный объект, который был создан только для игрока)
    if(playerobject)
    {
        if(!IsValidPlayerObject(playerid, objectid)) return 1;

        if(response == EDIT_RESPONSE_CANCEL) CancelEditPlayerObject(playerid);

        if(response == EDIT_RESPONSE_UPDATE)
        {
            new Float:dist = GetPlayerDistanceFromPoint(playerid, fX, fY, fZ);
            if(dist >= 150.0)
            {
                new line[90],lines[800];
   	            format(line,sizeof(line),"{FF6347}Объект слишком далеко от вас"), strcat(lines,line);
                format(line,sizeof(line),"\n\n{ff9000}Объект улетает далеко с этой ошибкой сразу после открытия редактора?"), strcat(lines,line);
                format(line,sizeof(line),"\n{cccccc}- Не спешите"), strcat(lines,line);
                format(line,sizeof(line),"\n{cccccc}- Сейчас закройте это окно и затем повторите установку объекта"), strcat(lines,line);
                format(line,sizeof(line),"\n{FF6347}- Важно! Не шевелите мышкой, когда откроете редактор объекта повторно"), strcat(lines,line);
                format(line,sizeof(line),"\n{cccccc}- Затем просто нажмите Левую Кнопку Мыши, чтобы появился курсор"), strcat(lines,line);
                format(line,sizeof(line),"\n{cccccc}- Проблема всего-лишь в залипании курсора"), strcat(lines,line);
                format(line,sizeof(line),"\n\n{cccccc}Успехов в маппинге :)"), strcat(lines,line);
                ErrorMessage(playerid, lines);
                CancelEditable(playerid);
                return 1;
            }
        }

        if(response == EDIT_RESPONSE_FINAL)
		{
            SaveEditPlayerObject(playerid, GetPlayerObjectModel(playerid, objectid), fX, fY, fZ, fRotX, fRotY, fRotZ); // Save Object
            DestroyPlayerObject(playerid, objectid); // Delete Temp Object

            gRedakt[playerid] = 0; // Редактор Off
            CancelSelectTextDraw(playerid);
        }
    }
	return 1;
}

// Сохраняем результат редактирования (New System 14.11.2023)
stock SaveEditPlayerObject(playerid, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    new string[180];
    new oid = EditObjectInfo[playerid][editOption];
    new slot = EditObjectInfo[playerid][editSlot];
    //new type = EditObjectInfo[playerid][editType];

    if(gRedakt[playerid] == 3) // Создание или Перемещение Map Объекта (Админская Система)
    {
        new objid = -1;
	    for(new i = 0; i < MAX_MAPOBJECT; i++)
	    {
	        if(!IsValidDynamicObject(MapInfo[0][mapobject][i]))
			{
				objid = i;
				break;
			}
	    }
	    if(objid == -1) return ErrorMessage(playerid, "{FF6347}Лимит количества объектов для одной карты"), CancelEdit(playerid);

        MapInfo[0][mapobject][objid] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 300.00, 300.00);
		MapInfo[0][quanobject] ++;
		if(MapInfo[0][mapload] == 0) MapInfo[0][mapload] = 1, format(MapInfo[0][mapname], 64, "name");
		ObjectMapLabelAll(0, objid);

        format(string,sizeof(string),"CreateDynamicObject(%d, %f, %f, %f, %f, %f, %f);", modelid, x, y, z, rx, ry, rz);
        SendClientMessagef(playerid, COLOR_GREY, string);
    }
    else if(gRedakt[playerid] == 6) // Установка мебели в доме
    {
        new Float:dist = GetDistancePoint(x, y, z, DomInfo[oid][dEnterX], DomInfo[oid][dEnterY], DomInfo[oid][dEnterZ]);
        new Float:distStreet = GetDistancePoint(x, y, z, DomInfo[oid][dKoordinatX], DomInfo[oid][dKoordinatY], DomInfo[oid][dKoordinatZ]);
        if(dist > 200.0 && distStreet > 30.0)
        {
            ErrorMessage(playerid, "{FF6347}Предмет слишком далеко от вашего дома\n{cccccc}Установка объектов доступна только в интерьере или не дальше 30 метров от дома");
            CancelEditable(playerid);
            return 1;
        }
        
        new findSlot = getFreeSlotObjectDom(oid);
        if(findSlot == -1)
        {
            ErrorMessage(playerid, "{FF6347}В этом доме закончились слоты для установки объектов");
            CancelEditable(playerid);
            return 1;
        }

        if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
		{
            if(getObjectStreetDom(oid) >= MAX_DOM_OBJECT_STREET)
            {
                ErrorMessage(playerid, "{FF6347}В этом доме установлено максимальное количество предметов на улице");
                CancelEditable(playerid);
                return 1;
            }
        }
        
        DomInfo[oid][dInvent][slot] = 0, DomInfo[oid][dInv][slot] = 0; // Удаляем предмет из дома
        SaveOneTainik(oid, slot);

        DomInfo[oid][dObject][findSlot] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 200.00, 200.00);
		DomInfo[oid][dUser][findSlot] = PlayerInfo[playerid][pID];
		DomInfo[oid][dQara][findSlot] = DomInfo[oid][dInvQara][slot];
		DomInfo[oid][dOmodel][findSlot] = modelid;
        UpdateObject(oid, findSlot, true, false); // Обновляем только расположение (текстуры не обновляем)

        Update3DLabelDomBiz(oid, findSlot, 1);
        if(PlayerInfo[playerid][pAchieve][11] == 0) AchievePlayer(playerid, 11, 1);
    }
    else if(gRedakt[playerid] == 9) // Установка Камер Слежения
	{
        if(camerafbi >= 100) return ErrorMessage(playerid, "{FF6347}Лимит камер слежения"), CancelEdit(playerid);
        camerafbi ++;
        for(new cam = 0; cam < sizeof(CamInfo); cam++)
        {
            if(CamInfo[cam][cStat] == 0)
            {
                CamInfo[cam][cObject] = CreateDynamicObject(1616, x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 60.00, 60.00);
                CamInfo[cam][cWorld] = GetPlayerVirtualWorld(playerid), CamInfo[cam][cInterior] = GetPlayerInterior(playerid);
                CamInfo[cam][cStat] = 1;
                CamInfo[cam][cAccount] = PlayerInfo[playerid][pID];
                strmid(CamInfo[cam][cVlad], PlayerInfo[playerid][pName], 0, strlen(PlayerInfo[playerid][pName]), 34);
                strmid(CamInfo[cam][cName], ListName[playerid], 0, strlen(ListName[playerid]), 24);
                CamInfo[cam][cDate] = gettime();
                InsertCam(cam);
                format(string,sizeof(string),"[ Мысли ]: Камера установлена {ff9000}[ %s ]", CamInfo[cam][cName]), SendClientMessage(playerid, COLOR_GREY, string);
                if(PlayerInfo[playerid][pSex] == 1) SetPlayerChatBubble(playerid,"установил камеру слежения",COLOR_PURPLE,20.0,10000);
                else SetPlayerChatBubble(playerid,"установила камеру слежения",COLOR_PURPLE,20.0,10000);
                break;
            }
        }
    }
    else if(gRedakt[playerid] == 10) // Перемещение Объектов Бизнеса (Улица)
    {
        if(slot == 0)
        {
            if(biznearby(oid, x, y, z)) return ErrorMessage(playerid, "{FF6347}Вы установили вход в бизнес слишком близко к другому бизнесу [Отмена установки]"), CancelEdit(playerid);
            if(bizsame(oid, x, y, z) && PlayerInfo[playerid][pSoska] <= 1) return ErrorMessage(playerid, "{FF6347}В радиусе 200 метров уже есть бизнес вашего типа [Отмена установки]"), CancelEdit(playerid);
            if(bizdefault(oid, x, y, z)) return ErrorMessage(playerid, "{FF6347}Это место зарезервировано государством! [Отмена установки]"), CancelEdit(playerid);

            new bcity = getbiz_city(oid);
            if(bcity == 0
                && (IsPosInSquare(x, y, -3000, -3000.0, -1236, 1623) || IsPosInSquare(x, y, -1236, -3000, 39, -369)
                    || IsPosInSquare(x, y, -3000, 1623, 3000, 3000) || IsPosInSquare(x, y, -1236, 597, 3000, 1623))) return ErrorMessage(playerid, "{FF6347}Бизнес привязан к LS [Отмена установки]"), CancelEdit(playerid);
            if(bcity == 1
                && (IsPosInSquare(x, y, -1236, -370, 3000, 598) || IsPosInSquare(x, y, 40, -3000, 3000, -369)
                    || IsPosInSquare(x, y, -3000, 1623, 3000, 3000) || IsPosInSquare(x, y, -1236, 597, 3000, 1623))) return ErrorMessage(playerid, "{FF6347}Бизнес привязан к SF [Отмена установки]"), CancelEdit(playerid);
            if(bcity == 2
                && (IsPosInSquare(x, y, -1236, -370, 3000, 598) || IsPosInSquare(x, y, 40, -3000, 3000, -369)
                    || IsPosInSquare(x, y, -3000, -3000.0, -1236, 1623) || IsPosInSquare(x, y, -1236, -3000, 39, -369))) return ErrorMessage(playerid, "{FF6347}Бизнес привязан к LV [Отмена установки]"), CancelEdit(playerid);
        }

        new Float:object_pos[3];
        GetDynamicObjectPos(BizzInfo[oid][bBizObject][slot], object_pos[0], object_pos[1], object_pos[2]);
        new Float:distpos = GetDistancePoint(x, y, z, object_pos[0], object_pos[1], object_pos[2]);

        if(IsValidDynamicObject(BizzInfo[oid][bBizObject][slot]))
        {
            SetDynamicObjectPos(BizzInfo[oid][bBizObject][slot], x, y, z);
            SetDynamicObjectRot(BizzInfo[oid][bBizObject][slot], rx, ry, rz);
        }

        if(slot == 1)
        {
            GetDynamicObjectPos(BizzInfo[oid][bBizObject][0], object_pos[0], object_pos[1], object_pos[2]);
            new Float:disttodoor = GetDistancePoint(x, y, z, object_pos[0], object_pos[1], object_pos[2]);
            if(disttodoor >= 30.0) return ErrorMessage(playerid, "{FF6347}Вывеска слишком далеко от двери бизнеса [Отмена установки]"), CancelEdit(playerid);
        }
        else if(slot == 0)
        {
            DestroyDynamicPickup(BizPickup2[oid]);
            if(BizzInfo[oid][bStat] == 2) BizzInfo[oid][bStat] = 1;
            if(distpos >= 5)
            {
                BizzInfo[oid][bStat] = 1;
                if(BizzInfo[oid][bLab] == 1) DestroyDynamicPickup(BizPickup[oid]), DestroyDynamic3DTextLabel(BizLabel[oid]), BizzInfo[oid][bLab] = 0;

                ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Объект установлен\n\nТеперь, его расположение, необходимо одобрить сотрудникам Правительства\nПосле рассмотрения заявления вы получите уведомление","*","");
                format(string, sizeof(string), "{FFFFFF}** {00C6FF}Бизнес № %d требует одобрения открытия {cccccc}[ /goverment ] {ffffff} **", oid);
                SendRadioMessage(7, COLOR_ALLDEPT, string);
            }
            createdoor_biznes(oid);
        }
        SaveBizz(oid);
        BizLog("bizpos", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], oid, 0, "Перенёс объект бизнеса");
    }
    else if(gRedakt[playerid] == 11) // Установка Маппинга на респах банд
	{
        new yes = -1;
        for(new oba = 0; oba < 200; oba++)
		{
			if(ObjectInfo[oid][gOmodel][oba] == 0)
			{
                yes = oba;
                break;
            }
        }
        if(yes == -1)  return ErrorMessage(playerid, "{FF6347}Лимит объектов на респе"), CancelEdit(playerid);
        if(!IsAGObjectInSquare(oid, x, y)) return ErrorMessage(playerid, "{FF6347}Объект за пределами территории вашей респы"), CancelEdit(playerid);

        ObjectInfo[oid][gOmodel][yes] = modelid;
		ObjectInfo[oid][gObject][yes] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 300.00, 300.00);
        ObjectInfo[oid][gUser][yes] = PlayerInfo[playerid][pID];
        ObjectInfo[oid][gStat][yes] = 1;

        UpdateGangObject(oid+13, OrganInfo[oid+13][gMap], yes);
        show_labelobject(oid, yes), OrgLog(oid+13, "cob", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", ObjectInfo[oid][gOmodel][yes], "");

        if(ObjectInfo[oid][gOmodel][yes] == 2915)
        {
            if(ObjectInfo[oid][gDumStat] == 1) DestroyDynamic3DTextLabel(DumLabel[oid]);
            ObjectInfo[oid][gDumStat] = 1;
            ObjectInfo[oid][gDumx] = x, ObjectInfo[oid][gDumy] = y, ObjectInfo[oid][gDumz] = z;
            DumLabel[oid] = CreateDynamic3DTextLabel("{444444}Гантели \n{cccccc}[ ALT ]",-1,x, y, z,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
        }
    }
    else if(gRedakt[playerid] == 13 || gRedakt[playerid] == 14) // Перемещение и Установка Терминалов Бизнеса
    {
        new b = rentnumn(oid);
        if(termnearby(oid, x, y, z)) return ErrorMessage(playerid, "{FF6347}Слишком близко к другому терминалу или тележке [Отмена установки]"), CancelEdit(playerid);
        if(IsBizTerminal(b))
        {
            if(termsame(oid, x, y, z) && PlayerInfo[playerid][pSoska] <= 1) return ErrorMessage(playerid, "{FF6347}В радиусе 200 метров уже есть бизнес этого типа [Отмена установки]"), CancelEdit(playerid);
        }

        new bcity = getbiz_city(b);
        if(bcity == 0
            && (IsPosInSquare(x, y, -3000, -3000.0, -1236, 1623) || IsPosInSquare(x, y, -1236, -3000, 39, -369)
                || IsPosInSquare(x, y, -3000, 1623, 3000, 3000) || IsPosInSquare(x, y, -1236, 597, 3000, 1623))) return ErrorMessage(playerid, "{FF6347}Бизнес привязан к LS [Отмена установки]"), CancelEdit(playerid);
        if(bcity == 1
            && (IsPosInSquare(x, y, -1236, -370, 3000, 598) || IsPosInSquare(x, y, 40, -3000, 3000, -369)
                || IsPosInSquare(x, y, -3000, 1623, 3000, 3000) || IsPosInSquare(x, y, -1236, 597, 3000, 1623))) return ErrorMessage(playerid, "{FF6347}Бизнес привязан к SF [Отмена установки]"), CancelEdit(playerid);
        if(bcity == 2
            && (IsPosInSquare(x, y, -1236, -370, 3000, 598) || IsPosInSquare(x, y, 40, -3000, 3000, -369)
                || IsPosInSquare(x, y, -3000, -3000.0, -1236, 1623) || IsPosInSquare(x, y, -1236, -3000, 39, -369))) return ErrorMessage(playerid, "{FF6347}Бизнес привязан к LV [Отмена установки]"), CancelEdit(playerid);

        new Float:distpos = GetDistancePoint(x, y, z, RentPos_X[oid][slot], RentPos_Y[oid][slot], RentPos_Z[oid][slot]);
    
        if(gRedakt[playerid] == 13) // Переместили
        {
            if(IsValidDynamicObject(RentObject[oid][slot]))
            {
                SetDynamicObjectPos(RentObject[oid][slot], x, y, z);
		        SetDynamicObjectRot(RentObject[oid][slot], rx, ry, rz);
            }
            if(RentStat[oid][slot] > 0) DestroyDynamic3DTextLabel(RentLabel[oid][slot]);
        }
        if(gRedakt[playerid] == 14 || distpos >= 5)
        {
            if(IsValidDynamicObject(RentObject[oid][slot])) return ErrorMessage(playerid, "{FF6347}Ошибка! Кто-то уже установил этот терминал или тележку [Отмена установки]"), CancelEdit(playerid);
            if(gRedakt[playerid] == 14)
            {
                RentObject[oid][slot] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 300.00, 300.00);
            }
            RentStat[oid][slot] = 2; // Установили (Требуем одобрение в установке)
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Объект установлен\n\nТеперь, его расположение, необходимо одобрить сотрудникам Правительства\nПосле рассмотрения заявления вы получите уведомление","*","");
            format(string, sizeof(string), "{FFFFFF}** {00C6FF}Бизнес № %d требует одобрения терминала {cccccc}[ /goverment ] {ffffff} **", b, slot + 1);
            SendRadioMessage(7, COLOR_ALLDEPT, string);
        }

        if(IsValidDynamicObject(RentObject[oid][slot]))
        {
            RentPos_X[oid][slot] = x;
            RentPos_Y[oid][slot] = y;
            RentPos_Z[oid][slot] = z;
            RentPos_RX[oid][slot] = rx;
            RentPos_RY[oid][slot] = ry;
            RentPos_RZ[oid][slot] = rz;

            CreateLabelTerm(oid, slot, RentObject[oid][slot]);
            UpdateLabelTerm(b, oid, slot);
        }
        SaveBizzTerm(oid, slot);
        BizLog("bizpos", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], b, slot, "Установил объект");
    }
    else if(gRedakt[playerid] == 17) // Установка мебели в бизнесе
    {
        new Float:dist = GetDistancePoint(x, y, z, BizzInfo[oid][bEnterX], BizzInfo[oid][bEnterY], BizzInfo[oid][bEnterZ]);
        new Float:distStreet = GetDistancePoint(x, y, z, BizzInfo[oid][bInteriorX], BizzInfo[oid][bInteriorY], BizzInfo[oid][bInteriorZ]);
        if(dist > 200.0 && distStreet > 30.0)
        {
            ErrorMessage(playerid, "{FF6347}Предмет слишком далеко от вашего бизнеса\n{cccccc}Установка объектов доступна только в интерьере или не дальше 30 метров от бизнеса");
            CancelEditable(playerid);
            return 1;
        }
        
        new findSlot = getFreeSlotObjectBiz(oid);
        if(findSlot == -1)
        {
            ErrorMessage(playerid, "{FF6347}В этом бизнесе закончились слоты для установки объектов");
            CancelEditable(playerid);
            return 1;
        }

        if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
		{
            if(getObjectStreetBiz(oid) >= MAX_DOM_OBJECT_STREET)
            {
                ErrorMessage(playerid, "{FF6347}В этом бизнесе установлено максимальное количество предметов на улице");
                CancelEditable(playerid);
                return 1;
            }
        }
        
        BizzInfo[oid][bInvent][slot] = 0, BizzInfo[oid][bInv][slot] = 0; // Удаляем предмет из бизнеса
        SaveSkladBiz(oid, slot);

        BizzInfo[oid][bObject][findSlot] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 200.00, 200.00);
		BizzInfo[oid][bUser][findSlot] = PlayerInfo[playerid][pID];
		BizzInfo[oid][bQara][findSlot] = BizzInfo[oid][bInvQara][slot];
		BizzInfo[oid][bOmodel][findSlot] = modelid;
        UpdateObjectBiz(oid, findSlot, true, false); // Обновляем только расположение (текстуры не обновляем)

        Update3DLabelDomBiz(oid, findSlot, 2);
        if(PlayerInfo[playerid][pAchieve][122] == 0) AchievePlayer(playerid, 122, 1);
    }
    else if(gRedakt[playerid] == 19) // Установка Остановки
    {
        new Float:dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
        if(dist >= 30.0) return ErrorMessage(playerid, "{FF6347}Остановка слишком далеко от вас [Отмена установки]"), CancelEdit(playerid);
        if(bsrows >= 100) return ErrorMessage(playerid, "{FF6347}В штате установлено 100 остановок [Лимит]"), CancelEdit(playerid);
        for(new ost = 0; ost < MAX_BUSSTATION; ost++)
        {
            if(BusStationInfo[ost][bsActive] == 0)
            {
                BusStationInfo[ost][bsCordX] = x, BusStationInfo[ost][bsCordY] = y, BusStationInfo[ost][bsCordZ] = z;
                BusStationInfo[ost][bsCordRX] = rx, BusStationInfo[ost][bsCordRY] = ry, BusStationInfo[ost][bsCordRZ] = rz;
                BusStationInfo[ost][bsActive] = 1;
                BusStationInfo[ost][bsVlad] = PlayerInfo[playerid][pID];
                strmid(BusStationInfo[ost][bsPlayerName], PlayerInfo[playerid][pName], 0, strlen(PlayerInfo[playerid][pName]), 34);
                strmid(BusStationInfo[ost][bsName], ListName[playerid], 0, strlen(ListName[playerid]), 24);
                BusStationInfo[ost][bsUnix] = gettime();
                InsertBusStation(ost);
                format(string,sizeof(string),"[ Мысли ]: Остановка установлена {ff9000}[ %s ]", BusStationInfo[ost][bsName]), SendClientMessage(playerid, COLOR_GREY, string);
                format(string,sizeof(string),"установил%s остановку", gender(playerid)), SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 20.0, 3000);
                busstationcreate(ost);
                bsrows++;
                break;
            }
        }
    }
    else if(gRedakt[playerid] == 22 || gRedakt[playerid] == 23 || gRedakt[playerid] == 24 || gRedakt[playerid] == 25) // Объекты для стритов
    {
        new Float:dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
        if(dist >= 30.0) return ErrorMessage(playerid, "{FF6347}Предмет слишком далеко от вас [Отмена установки]"), CancelEdit(playerid);

        WriteRaceTerminalPosition(playerid, x, y, z, rx, ry, rz);
        RentObjectRace[oid] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz,0,0);
        CreateLabelTermRace(oid,RentObjectRace[oid]);
        UpdateLabelTermRace(oid);
    }
    else if(gRedakt[playerid] == 26) // Объекты для секты
    {
        new fam = PlayerInfo[playerid][pFamily];
        new Float:dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
        if(dist >= 30.0)
        {
            CancelEdit(playerid);
            return ErrorMessage(playerid, "{FF6347}Предмет слишком далеко от вас [Отмена установки]");
        }
        FamilyInfo[fam][fsAltarPos][0] = x, FamilyInfo[fam][fsAltarPos][1] = y, FamilyInfo[fam][fsAltarPos][2] = z;
        FamilyInfo[fam][fsAltarPos][3] = rx, FamilyInfo[fam][fsAltarPos][4] = ry, FamilyInfo[fam][fsAltarPos][5] = rz;

        if(FamilyInfo[fam][fsAltarStatus] == 1)
        {
            SetDynamicObjectPos(SektaObject[fam], x, y, z);
            SetDynamicObjectRot(SektaObject[fam], rx, ry, rz);
        }
        else
        {
            FamilyInfo[fam][fsAltarStatus] = 1; 
            SektaObject[fam] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 200.00, 200.00);
        }
        SektaObjectHealt[fam] = 1000;
        SaveFamilySekta(fam);
    }
    else if(gRedakt[playerid] == 27) // Граффити
    {
        new Float:dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
        if(dist >= 10.0)
        {
            CancelEdit(playerid);
            return ErrorMessage(playerid, "{FF6347}Предмет слишком далеко от вас [Отмена установки]");
        }
        new zone = GetZoneXYZ(x,y);
        if(zone == -1)
        {
            CancelEdit(playerid);
            return ErrorMessage(playerid, "{FF6347}Граффити не в территории гетто [Отмена установки]");
        }
        if(GraphitiInfo[zone][graphitiStatus] == 1)
        {
            if(GraphitiInfo[zone][graphitiUnix]+1800 > gettime())
            {
                CancelEdit(playerid);
                return ErrorMessage(playerid, "{FF6347}Ошибка! В этой зоне уже нанесено граффити");
            }
        }
        if(GraphitiInfo[zone][graphitiStatus] == 1)
        {
            DestroyDynamicObject(GraphitiObject[zone]);
            DestroyDynamicPickup(GraphitiPickUp[zone]);
            DestroyDynamic3DTextLabel(GraphitiLabel[zone]);
        }
        else QuanGraffity ++;
        GraphitiInfo[zone][graphitiPos][0] = x, GraphitiInfo[zone][graphitiPos][1] = y, GraphitiInfo[zone][graphitiPos][2] = z;
        GraphitiInfo[zone][graphitiPos][3] = rx, GraphitiInfo[zone][graphitiPos][4] = ry, GraphitiInfo[zone][graphitiPos][5] = rz;
        GraphitiInfo[zone][graphitiOrg] = fraction(playerid);
        GraphitiInfo[zone][graphitiUnix] = gettime();
        GraphitiInfo[zone][graphitiStatus] = 1;
        GraphitiInfo[zone][graphitiZone] = zone;
        GraphitiInfo[zone][graphitiPlayer] = PlayerInfo[playerid][pID];
        format(GraphitiInfo[zone][graphitiName], 24,"%s", PlayerInfo[playerid][pName]);
        TakeInvent(playerid, 197, 1, 0, 999); // Отнимаем 1 из баллончика с краской (чтобы он не был бесконечным)
        GraphitiUpdateElement(zone);
        SaveGraphiti(zone);
        ApplyAnimation(playerid,"SPRAYCAN","spraycan_fire",3.0,0,1,1,0,0);
        SetPlayerChatBubble(playerid,"наносит граффити",COLOR_PURPLE,20.0,4000);

        around_player_audio(playerid, 1134, 0, 5.0, 0);
    }
    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
    PlayerPlaySound(playerid,6401,0,0,0);
    return 1;
}

stock GoEditDynamicObject(playerid, id, type, option, slot, objectid, dopoption)
{
    EditObjectInfo[playerid][editPlayerOrDynamic] = 1;
    gRedakt[playerid] = id;
    EditObjectInfo[playerid][editType] = type;
    EditObjectInfo[playerid][editOption] = option;
    EditObjectInfo[playerid][editSlot] = slot;
    EditObjectInfo[playerid][editObjectid] = objectid;
    EditObjectInfo[playerid][editDopOption] = dopoption; // Save Slot Invent
    EditObjectInfo[playerid][editOne] = 0;

    Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, STREAMER_EDITABLE_DYNAMIC_OBJECT, 1); // Editable Dynamic Object
    EditDynamicObject(playerid, objectid);
    PlayerPlaySound(playerid,17000,0,0,0);
	return 1;
}

stock EditForSeat(playerid, objectid)
{
    EditDynamicObject(playerid, objectid);
    EditObjectInfo[playerid][editObjectid] = objectid;
    return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(OnlineInfo[playerid][oLogged] == 0) return 0;
    if(!IsValidDynamicObject(objectid)) return 0;

    if(EditObjectInfo[playerid][editOne] == 0)
    {
        EditObjectInfo[playerid][editOne] = 1;
        GetDynamicObjectPos(EditObjectInfo[playerid][editObjectid], EditObjectInfo[playerid][editOldPos][0], EditObjectInfo[playerid][editOldPos][1], EditObjectInfo[playerid][editOldPos][2]);
        GetDynamicObjectRot(EditObjectInfo[playerid][editObjectid], EditObjectInfo[playerid][editOldPos][3], EditObjectInfo[playerid][editOldPos][4], EditObjectInfo[playerid][editOldPos][5]);
    }

    if (GetPVarInt(playerid, "EditNewSeatObj") > 0) {
		if (response == EDIT_RESPONSE_FINAL) {
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);

			new modelid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);

			newSeatObjects[playerid][nssModel] = modelid;
			newSeatObjects[playerid][nssObject] = objectid;

			DeletePVar(playerid, "EditNewSeatObj");
		} else if (response == EDIT_RESPONSE_CANCEL) {
			DestroyDynamicObject(objectid);
			SendClientMessage(playerid, 0xCBCBCBFF, "[ Мысли ]: Я отменил установку объекта");

			DeletePVar(playerid, "EditNewSeatObj");
		}
	}

    if(response == EDIT_RESPONSE_CANCEL) CancelDynamicEditable(playerid);

    if(response == EDIT_RESPONSE_UPDATE)
    {
        new Float:dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
        if(dist >= 150.0)
        {
            new line[90],lines[800];
            format(line,sizeof(line),"{FF6347}Объект слишком далеко от вас"), strcat(lines,line);
            format(line,sizeof(line),"\n\n{ff9000}Объект улетает далеко с этой ошибкой сразу после открытия редактора?"), strcat(lines,line);
            format(line,sizeof(line),"\n{cccccc}- Не спешите"), strcat(lines,line);
            format(line,sizeof(line),"\n{cccccc}- Сейчас закройте это окно и затем повторите установку объекта"), strcat(lines,line);
            format(line,sizeof(line),"\n{FF6347}- Важно! Не шевелите мышкой, когда откроете редактор объекта повторно"), strcat(lines,line);
            format(line,sizeof(line),"\n{cccccc}- Затем просто нажмите Левую Кнопку Мыши, чтобы появился курсор"), strcat(lines,line);
            format(line,sizeof(line),"\n{cccccc}- Проблема всего-лишь в залипании курсора"), strcat(lines,line);
            format(line,sizeof(line),"\n\n{cccccc}Успехов в маппинге :)"), strcat(lines,line);
            ErrorMessage(playerid, lines);
            CancelDynamicEdit(playerid, EditObjectInfo[playerid][editObjectid]);
            return 1;
        }

        if(objectid != EditObjectInfo[playerid][editObjectid]) return ErrorMessage(playerid, "{FF6347}Ошибка редактора объектов"), CancelDynamicEdit(playerid, EditObjectInfo[playerid][editObjectid]);
    }

    if(response == EDIT_RESPONSE_FINAL)
	{
        if(objectid != EditObjectInfo[playerid][editObjectid]) return ErrorMessage(playerid, "{FF6347}Ошибка редактора объектов"), CancelDynamicEdit(playerid, EditObjectInfo[playerid][editObjectid]);

        SetDynamicObjectPos(EditObjectInfo[playerid][editObjectid], x, y, z);
		SetDynamicObjectRot(EditObjectInfo[playerid][editObjectid], rx, ry, rz);
        Streamer_SetIntData(STREAMER_TYPE_OBJECT, EditObjectInfo[playerid][editObjectid], STREAMER_EDITABLE_DYNAMIC_OBJECT, 0);

        new oid = EditObjectInfo[playerid][editOption];
        new slot = EditObjectInfo[playerid][editSlot];
        //new type = EditObjectInfo[playerid][editType];

        // Условности разных систем при сохранении установки или перемещения объекта
        if(gRedakt[playerid] == 3) // Создание или Перемещение Map Объекта (Админская Система)
        {
            ObjectMapLabelAll(1, slot);
        }
        else if(gRedakt[playerid] == 6) // Установка мебели в доме
		{
            new Float:dist = GetDistancePoint(x, y, z, DomInfo[oid][dEnterX], DomInfo[oid][dEnterY], DomInfo[oid][dEnterZ]);
            new Float:distStreet = GetDistancePoint(x, y, z, DomInfo[oid][dKoordinatX], DomInfo[oid][dKoordinatY], DomInfo[oid][dKoordinatZ]);
            if(dist > 200.0 && distStreet > 30.0)
            {
                ErrorMessage(playerid, "{FF6347}Предмет слишком далеко от вашего дома\n{cccccc}Установка объектов доступна только в интерьере или не дальше 30 метров от дома");
                CancelDynamicEdit(playerid, EditObjectInfo[playerid][editObjectid]);
                return 1;
            }
            DomInfo[oid][dUser][slot] = PlayerInfo[playerid][pID];
            Update3DLabelDomBiz(oid, slot, 1);
            UpdateObject(oid, slot, true, false); // Обновляем только расположение (текстуры не обновляем)
            if(PlayerInfo[playerid][pAchieve][11] == 0) AchievePlayer(playerid, 11, 1);
        }
        else if(gRedakt[playerid] == 12) // Установка Маппинга на респах банд
		{
            if(!IsAGObjectInSquare(oid, x, y)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Объект за пределами территории... {ffcc00}[ Отмена Установки ]"), CancelDynamicEdit(playerid, EditObjectInfo[playerid][editObjectid]);
            if(ObjectInfo[oid][gOmodel][slot] == 2915)
            {
                if(ObjectInfo[oid][gDumStat] == 1) DestroyDynamic3DTextLabel(DumLabel[oid]);
                ObjectInfo[oid][gDumStat] = 1;
                ObjectInfo[oid][gDumx] = x, ObjectInfo[oid][gDumy] = y, ObjectInfo[oid][gDumz] = z;
                DumLabel[oid] = CreateDynamic3DTextLabel("{444444}Гантели \n{cccccc}[ ALT ]",-1,x, y, z,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
            }
            ObjectInfo[oid][gUser][slot] = PlayerInfo[playerid][pID];
            ObjectInfo[oid][gStat][slot] = 1;
            UpdateGangObject(oid+13, OrganInfo[oid+13][gMap], slot);
            update_labelobject(oid, slot), OrgLog(oid+13, "eob", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", ObjectInfo[oid][gOmodel][slot], "");
		}
        else if(gRedakt[playerid] == 15 || gRedakt[playerid] == 16) // Установка или перенос предмета IKEA
		{
            new mworl = GetPlayerVirtualWorld(playerid), mint = GetPlayerInterior(playerid);
            IkeaInfo[oid][iBuyX] = x;
            IkeaInfo[oid][iBuyY] = y;
            IkeaInfo[oid][iBuyZ] = z;
            if(gRedakt[playerid] == 15)
            {
                format(IkeaInfo[oid][iName], 24, "%s", object_name(IkeaInfo[oid][iModel]));
                IkeaInfo[oid][iQuantextures] = object_material(IkeaInfo[oid][iModel]);
                new string[70];
                format(string,sizeof(string),"[ Server ]: Настройте предмет для продажи [ /ikea %d ]", oid);
                SendClientMessage(playerid, COLOR_GREY, string);
                AdminLog("ikea", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", IkeaInfo[oid][iModel], "IKEA");
            }
            if(gRedakt[playerid] == 16)
            {
                if(IkeaInfo[oid][iLabelstat] > 0)  DestroyDynamic3DTextLabel(IkeaLabel[oid]), IkeaInfo[oid][iLabelstat] = 0;
            }
            UpdateIkeaObject(oid);
            if(IkeaInfo[oid][iLabelstat] == 0)
            {
                IkeaLabel[oid] = CreateDynamic3DTextLabel(" ",-1,x, y, z,1.5,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,mworl,mint);
                IkeaInfo[oid][iLabelstat] = 1;
            }
            UpdateLabelIkea(oid);
		}
        else if(gRedakt[playerid] == 17) // Перемещение Мебель в Бизнесе
		{
            new Float:dist = GetDistancePoint(x, y, z, BizzInfo[oid][bEnterX], BizzInfo[oid][bEnterY], BizzInfo[oid][bEnterZ]);
            new Float:distStreet = GetDistancePoint(x, y, z, BizzInfo[oid][bInteriorX], BizzInfo[oid][bInteriorY], BizzInfo[oid][bInteriorZ]);
            if(dist > 200.0 && distStreet > 30.0)
            {
                ErrorMessage(playerid, "{FF6347}Предмет слишком далеко от вашего бизнеса\n{cccccc}Установка объектов доступна только в интерьере или не дальше 30 метров от бизнеса");
                CancelDynamicEdit(playerid, EditObjectInfo[playerid][editObjectid]);
                return 1;
            }
            BizzInfo[oid][bUser][slot] = PlayerInfo[playerid][pID];
            Update3DLabelDomBiz(oid, slot, 2);
            UpdateObjectBiz(oid, slot, true, false); // Обновляем только расположение (текстуры не обновляем)
            if(PlayerInfo[playerid][pAchieve][122] == 0) AchievePlayer(playerid, 122, 1);
        }
        else if(gRedakt[playerid] == 20 || gRedakt[playerid] == 21) // Установка или перенос предмета в Личном Редакторе
		{
            new prewSel = peoInfo[oid][peoSelObject]; // Получаем ID предыдущего выбранного объекта
            peoInfo[oid][peoSelObject] = slot; // Записываем выбранный новый объект
            peoInfo[oid][peoX][slot] = x;
            peoInfo[oid][peoY][slot] = y;
            peoInfo[oid][peoZ][slot] = z;
            peoInfo[oid][peoRX][slot] = rx;
            peoInfo[oid][peoRY][slot] = ry;
            peoInfo[oid][peoRZ][slot] = rz;
            if(gRedakt[playerid] == 20) peoInfo[oid][peoQuanObjects] ++;
            if(peoInfo[playerid][peoObjectLabelStatus])
            {
                update3dtextLabelPos(playerid, slot); // Обновляем label нового объекта
                if(peoInfo[oid][peoModel][prewSel] > 0) update3dtextLabel(playerid, prewSel); // Обновляем label предыдущего объекта
            }
            peoInfo[oid][peoQuanUpdates] ++;
		}
        else if(gRedakt[playerid] == 22 || gRedakt[playerid] == 23 || gRedakt[playerid] == 24 || gRedakt[playerid] == 25) // Объекты для стритов
        {
            WriteRaceTerminalPosition(playerid, x, y, z, rx, ry, rz);
            CreateLabelTermRace(oid,RentObjectRace[oid]);
            UpdateLabelTermRace(oid);
        }

        Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
        gRedakt[playerid] = 0; // Редактор Off
		PlayerPlaySound(playerid,6401,0,0,0);
        CancelSelectTextDraw(playerid);
    }
    return 1;
}

stock WriteRaceTerminalPosition(playerid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(gRedakt[playerid] == 22)
    {
        StreetRacers[0][racePosMarket][0] = x;
        StreetRacers[0][racePosMarket][1] = y;
        StreetRacers[0][racePosMarket][2] = z;
        StreetRacers[0][racePosMarket][3] = rx;
        StreetRacers[0][racePosMarket][4] = ry;
        StreetRacers[0][racePosMarket][5] = rz;
    }
    else if(gRedakt[playerid] == 23)
    {
        StreetRacers[0][racePosBenz][0] = x;
        StreetRacers[0][racePosBenz][1] = y;
        StreetRacers[0][racePosBenz][2] = z;
        StreetRacers[0][racePosBenz][3] = rx;
        StreetRacers[0][racePosBenz][4] = ry;
        StreetRacers[0][racePosBenz][5] = rz;
    }
    else if(gRedakt[playerid] == 24)
    {
        StreetRacers[0][racePosService][0] = x;
        StreetRacers[0][racePosService][1] = y;
        StreetRacers[0][racePosService][2] = z;
        StreetRacers[0][racePosService][3] = rx;
        StreetRacers[0][racePosService][4] = ry;
        StreetRacers[0][racePosService][5] = rz;
    }
    else if(gRedakt[playerid] == 25)
    {
        StreetRacers[0][racePosTerminal][0] = x;
        StreetRacers[0][racePosTerminal][1] = y;
        StreetRacers[0][racePosTerminal][2] = z;
        StreetRacers[0][racePosTerminal][3] = rx;
        StreetRacers[0][racePosTerminal][4] = ry;
        StreetRacers[0][racePosTerminal][5] = rz;
    }
    return 1;
}

stock CloseEditObject(playerid)
{
    if(gRedakt[playerid] > 0 && gRedakt[playerid] != 31 && gRedakt[playerid] != 32)
	{
		if(EditObjectInfo[playerid][editPlayerOrDynamic] == 0) 
        {
            CancelEditPlayerObject(playerid);
            CancelEdit(playerid);
        }
		else CancelDynamicEdit(playerid, EditObjectInfo[playerid][editObjectid]);
		gRedakt[playerid] = 0;
	}
    return 1;
}

stock CancelEditable(playerid)
{
    if(gRedakt[playerid] == 0) return 1;

    new objectid = EditObjectInfo[playerid][editTempObject];
    UnblockEditObject(playerid, objectid);
    CancelEdit(playerid);
    return 1;
}

stock CancelEditPlayerObject(playerid)
{
    if(gRedakt[playerid] == 0) return 1;

    new objectid = EditObjectInfo[playerid][editTempObject];
    if(objectid >= 0) 
    {
        UnblockEditObject(playerid, objectid);
        DestroyPlayerObject(playerid, objectid);
        EditObjectInfo[playerid][editTempObject] = -1;
    }
    gRedakt[playerid] = 0; // Редактор Off
    PlayerPlaySound(playerid,31200,0,0,0);
    return 1;
}

stock UnblockEditObject(playerid, objectid)
{
    if(gRedakt[playerid] == 6 && EditObjectInfo[playerid][editType] == 0) CancelCreateObjectDom(playerid, GetPlayerObjectModel(playerid, objectid));
    else if(gRedakt[playerid] == 17 && EditObjectInfo[playerid][editType] == 0) CancelCreateObjectBiz(playerid, GetPlayerObjectModel(playerid, objectid));
    return 1;
}

stock CancelCreateObjectDom(playerid, model)
{
    new oid = EditObjectInfo[playerid][editOption];
    new slot = EditObjectInfo[playerid][editSlot];
    if(model != 0 && DomInfo[oid][dInvent][slot] == model) DomInfo[oid][dInv][slot] = 1; // Сбрасываем блокировку объекта
    return 1;
}

stock CancelCreateObjectBiz(playerid, model)
{
    new oid = EditObjectInfo[playerid][editOption];
    new slot = EditObjectInfo[playerid][editSlot];
    if(model != 0 && BizzInfo[oid][bInvent][slot] == model) BizzInfo[oid][bInv][slot] = 1; // Сбрасываем блокировку объекта
    return 1;
}

stock CancelDynamicEditable(playerid)
{
    if(gRedakt[playerid] == 0) return 1;

    new oid = EditObjectInfo[playerid][editOption];
    new slot = EditObjectInfo[playerid][editSlot];
    //new type = EditObjectInfo[playerid][editType];

    if(EditObjectInfo[playerid][editType] == 0) // Создание Объекта (Удаляем при отмене)
    {
        // Условности разных систем при отмене создания
        if(gRedakt[playerid] == 11) // Объект на респе Банд
        {
            if(ObjectInfo[oid][gOmodel][slot] == 2915 && ObjectInfo[oid][gDumStat] == 1) ObjectInfo[oid][gDumStat] = 0, DestroyDynamic3DTextLabel(DumLabel[oid]);
            ObjectInfo[oid][gOmodel][slot] = 0;
        }
        else if(gRedakt[playerid] == 15) // IKEA
        {
            IkeaInfo[oid][iModel] = 0;
            IkeaInfo[oid][iObject] = 0;
            if(IkeaInfo[oid][iLabelstat] > 0)  DestroyDynamic3DTextLabel(IkeaLabel[oid]), IkeaInfo[oid][iLabelstat] = 0;
        }
        else if(gRedakt[playerid] == 20) // Личный Редактор
        {
            peoInfo[oid][peoModel][slot] = 0;
            peoInfo[oid][peoObject][slot] = 0;
        }

        DestroyDynamicObject(EditObjectInfo[playerid][editObjectid]);
    }
    else // Перемещение Объекта (Возвращаем на позицию при отмене)
    {
        SetDynamicObjectPos(EditObjectInfo[playerid][editObjectid], EditObjectInfo[playerid][editOldPos][0], EditObjectInfo[playerid][editOldPos][1], EditObjectInfo[playerid][editOldPos][2]);
        SetDynamicObjectRot(EditObjectInfo[playerid][editObjectid], EditObjectInfo[playerid][editOldPos][3], EditObjectInfo[playerid][editOldPos][4], EditObjectInfo[playerid][editOldPos][5]);
        Streamer_SetIntData(STREAMER_TYPE_OBJECT, EditObjectInfo[playerid][editObjectid], STREAMER_EDITABLE_DYNAMIC_OBJECT, 0); // Теперь объект никто не редактирует
    }

    gRedakt[playerid] = 0; // Редактор Off
    PlayerPlaySound(playerid,31200,0,0,0);
    CancelSelectTextDraw(playerid);
    return 1;
}
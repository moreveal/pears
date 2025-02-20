function NarcoFarmLoad()
{
    new rows;
    cache_get_row_count(rows);

    rows = min(rows, MAX_NARCO_FARMS);

    for (new i = 0; i < rows; i++)
    {
        new id;
        cache_get_value_name_int(i, "id", id);
        id--;

        SQL_LOAD_ENUM(NarcoFarmInfo[id], SQL_GET_ENUM_DEFINE(NarcoFarmInfo), i);

        NarcoFarmCreatePickup(id);
        NarcoFarmCreateActors(id);
        NarcoFarmCreateMapIcon(id);
        NarcoFarmCreateDynamicArea(id);
    }

    // Заполняем пустые слоты наркоферм
    for (new i = 0; i < MAX_NARCO_FARMS; i++)
    {
        if (!NarcoFarmIsExists(i))
        {
            NarcoFarmInfo[i][dfiID] = i + 1;
            NarcoFarmSave(i);
        }
    }

    // Определяем позиции будок/кустов
    new objects[300], count;
    for (new i = 0; i < MAX_NARCO_FARMS; i++)
    {
        for (new j = 0; j < MAX_NARCO_FARMS_BOOTHS; j++)
        {
            new Float: min_x = NarcoFarmBoothArea[i][j][0],
                Float: min_y = NarcoFarmBoothArea[i][j][1],
                Float: min_z = NarcoFarmBoothArea[i][j][2],
                Float: max_x = NarcoFarmBoothArea[i][j][3],
                Float: max_y = NarcoFarmBoothArea[i][j][4],
                Float: max_z = NarcoFarmBoothArea[i][j][5];

            count = Streamer_GetNearbyItems(min_x, min_y, min_z, STREAMER_TYPE_OBJECT, objects, .range = 100.0);
            for (new insert, oi = 0; oi < min(count, sizeof(objects)); oi++)
            {
                new objectid = objects[oi];
                if (!IsValidDynamicObject(objectid)) continue;
                if (GetDynamicObjectModel(objectid) != NARCO_FARMS_BUSH_MODELID) continue;

                new Float: x, Float: y, Float: z;
                GetDynamicObjectPos(objectid, x, y, z);
                if (IsPointInCube(x, y, z, min_x, min_y, min_z, max_x, max_y, max_z))
                {
                    if (insert >= MAX_NARCO_FARMS_BUSHES) break;

                    new Float: rx, Float: ry, Float: rz;
                    GetDynamicObjectRot(objectid, rx, ry, rz);

                    NarcoFarmBushInfo[i][j][insert++][dfbiObject] = CreateDynamicObject(NARCO_FARMS_BUSH_MODELID, x, y, z, rx, ry, rz, NARCO_FARMS_BUSH_VIRTUAL_WORLD);
                    DestroyDynamicObject(objectid);
                }
            }
        }
        NarcoFarmCreateBushLabels(i);
        NarcoFarmCreatePackLabels(i);
    }
    
    return 1;
}

stock NarcoFarmPlaceBush(farmid, boothid, bushid, bool: status = true)
{
    if (!NarcoFarmIsBushExists(farmid, boothid, bushid)) return 0;

    SetDynamicObjectVirtualWorld(NarcoFarmBushInfo[farmid][boothid][bushid][dfbiObject], status ? 0 : NARCO_FARMS_BUSH_VIRTUAL_WORLD);

    return 1;
}

stock NarcoFarmIsBushPlaced(farmid, boothid, bushid)
{
    if (!NarcoFarmIsBushExists(farmid, boothid, bushid)) return 0;

    return GetDynamicObjectVirtualWorld(NarcoFarmBushInfo[farmid][boothid][bushid][dfbiObject]) == 0;
}

stock NarcoFarmSave(id)
{
    if (NarcoFarmIsExists(id))
    {
        FORMAT:where("id = %d", NarcoFarmInfo[id][dfiID]);
        SQL_SAVE_ENUM_IF_NOT_EXISTS(pearsq, "pp_narco_farms", NarcoFarmInfo[id], SQL_GET_ENUM_DEFINE(NarcoFarmInfo), where, where);
    } else {
        FORMAT:query("DELETE FROM `pp_narco_farms` WHERE id = %d", id);
        mysql_tquery(pearsq, query);
    }

    return 1;
}

stock NarcoFarmCreateActors(id)
{
    if (!NarcoFarmIsExists(id)) return 0;

    // Продавец
    if (IsValidDynamicActor(NarcoFarmInfo[id][dfiSellerActor])) DestroyDynamicActor(NarcoFarmInfo[id][dfiSellerActor]);
    NarcoFarmInfo[id][dfiSellerActor] = CreateDynamicActor(133, NarcoFarmInfo[id][dfiSellerPos][0], NarcoFarmInfo[id][dfiSellerPos][1], NarcoFarmInfo[id][dfiSellerPos][2], NarcoFarmInfo[id][dfiSellerPos][3]);
    if (IsValidDynamic3DTextLabel(NarcoFarmInfo[id][dfiSellerActorLabel])) DestroyDynamic3DTextLabel(NarcoFarmInfo[id][dfiSellerActorLabel]);
    NarcoFarmInfo[id][dfiSellerActorLabel] = CreateDynamic3DTextLabel("Продавец\n{cccccc}[ ALT ]", 0xFF9000FF, NarcoFarmInfo[id][dfiSellerPos][0], NarcoFarmInfo[id][dfiSellerPos][1], NarcoFarmInfo[id][dfiSellerPos][2], 3.5, .worldid = 0);

    return 1;
}

stock NarcoFarmCreateMapIcon(id)
{
    if (!NarcoFarmIsExists(id)) return 0;

    CreateDynamicMapIcon(NarcoFarmInfo[id][dfiInfoPos][0], NarcoFarmInfo[id][dfiInfoPos][1], NarcoFarmInfo[id][dfiInfoPos][2], 11, 0xFF9000FF, 0, 0);

    return 1;
}

stock NarcoFarmCreateDynamicArea(id)
{
    if (!NarcoFarmIsExists(id)) return 0;

    if (IsValidDynamicArea(NarcoFarmInfo[id][dfiArea])) DestroyDynamicArea(NarcoFarmInfo[id][dfiArea]);
    NarcoFarmInfo[id][dfiArea] = CreateDynamicCube(NarcoFarmInfo[id][dfiAreaPos][0], NarcoFarmInfo[id][dfiAreaPos][1], NarcoFarmInfo[id][dfiAreaPos][2] - 10.0, NarcoFarmInfo[id][dfiAreaPos][3], NarcoFarmInfo[id][dfiAreaPos][4], NarcoFarmInfo[id][dfiAreaPos][5] + 15.0, 0, 0);

    return 1;
}

stock NarcoFarmCreatePackLabels(id)
{
    if (!NarcoFarmIsExists(id)) return 0;

    if (IsValidDynamic3DTextLabel(NarcoFarmInfo[id][dfiPackLabel])) DestroyDynamic3DTextLabel(NarcoFarmInfo[id][dfiPackLabel]);
    NarcoFarmInfo[id][dfiPackLabel] = CreateDynamic3DTextLabel("Упаковочный стол\n{cccccc}[ ALT ]", 0xFF9000FF, NarcoFarmInteractivePositions[id][0][0], NarcoFarmInteractivePositions[id][0][1], NarcoFarmInteractivePositions[id][0][2], 3.0);

    if (IsValidDynamic3DTextLabel(NarcoFarmInfo[id][dfiSeedLabel])) DestroyDynamic3DTextLabel(NarcoFarmInfo[id][dfiSeedLabel]);
    NarcoFarmInfo[id][dfiSeedLabel] = CreateDynamic3DTextLabel("Саженцы\n{cccccc}[ ALT ]", 0xFF9000FF, NarcoFarmInteractivePositions[id][1][0], NarcoFarmInteractivePositions[id][1][1], NarcoFarmInteractivePositions[id][1][2], 3.0);

    if (IsValidDynamic3DTextLabel(NarcoFarmInfo[id][dfiLeekLabel])) DestroyDynamic3DTextLabel(NarcoFarmInfo[id][dfiLeekLabel]);
    NarcoFarmInfo[id][dfiLeekLabel] = CreateDynamic3DTextLabel("Канистры для полива\n{cccccc}[ ALT ]", 0xFF9000FF, NarcoFarmInteractivePositions[id][2][0], NarcoFarmInteractivePositions[id][2][1], NarcoFarmInteractivePositions[id][2][2], 3.0);

    if (IsValidDynamic3DTextLabel(NarcoFarmInfo[id][dfiBasketLabel])) DestroyDynamic3DTextLabel(NarcoFarmInfo[id][dfiBasketLabel]);
    NarcoFarmInfo[id][dfiBasketLabel] = CreateDynamic3DTextLabel("Корзинки для урожая\n{cccccc}[ ALT ]", 0xFF9000FF, NarcoFarmInteractivePositions[id][3][0], NarcoFarmInteractivePositions[id][3][1], NarcoFarmInteractivePositions[id][3][2], 3.0);

    return 1;
}

stock NarcoFarmCreateBushLabels(id)
{
    if (!NarcoFarmIsExists(id)) return 0;

    for (new i = 0; i < MAX_NARCO_FARMS_BOOTHS; i++)
    {
        for (new j = 0; j < MAX_NARCO_FARMS_BUSHES; j++)
        {
            if (IsValidDynamic3DTextLabel(NarcoFarmBushInfo[id][i][j][dfbiLabel])) DestroyDynamic3DTextLabel(NarcoFarmBushInfo[id][i][j][dfbiLabel]);

            new Float: x, Float: y, Float: z;
            GetDynamicObjectPos(NarcoFarmBushInfo[id][i][j][dfbiObject], x, y, z);

            NarcoFarmBushInfo[id][i][j][dfbiLabel] = CreateDynamic3DTextLabel("", 0xFF9000FF, x, y, z, 3.0);
            NarcoFarmUpdateBushLabel(id, i, j);
        }
    }

    return 1;
}

stock NarcoFarmCreatePickup(id)
{
    if (!NarcoFarmIsExists(id)) return 0;

    if (IsValidDynamicPickup(NarcoFarmInfo[id][dfiInfoPickup])) DestroyDynamicPickup(NarcoFarmInfo[id][dfiInfoPickup]);
    NarcoFarmInfo[id][dfiInfoPickup] = CreateDynamicPickup(1314, 1, NarcoFarmInfo[id][dfiInfoPos][0], NarcoFarmInfo[id][dfiInfoPos][1], NarcoFarmInfo[id][dfiInfoPos][2], 0, 0);

    if (IsValidDynamic3DTextLabel(NarcoFarmInfo[id][dfiInfoLabel])) DestroyDynamic3DTextLabel(NarcoFarmInfo[id][dfiInfoLabel]);

    FORMAT:text("Наркоферма №%d\n{444444}Под Контролем: %s", NarcoFarmInfo[id][dfiID], frakName[NarcoFarmInfo[id][dfiFraction]]);
    NarcoFarmInfo[id][dfiInfoLabel] = CreateDynamic3DTextLabel(text, 0xFF9000FF, NarcoFarmInfo[id][dfiInfoPos][0], NarcoFarmInfo[id][dfiInfoPos][1], NarcoFarmInfo[id][dfiInfoPos][2] + 1.0, 15.0, .worldid = 0, .interiorid = 0, .testlos = 1);
    
    new Float: distance;
    foreach (new playerid : Player)
    {
        Streamer_GetDistanceToItem(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid], STREAMER_TYPE_PICKUP, NarcoFarmInfo[id][dfiInfoPickup], distance);
        if (distance > 5.0) continue;

        Streamer_Update(playerid);
    }

    return 1;
}

stock NarcoFarmGetFreeID()
{
    for (new i = 0; i < MAX_NARCO_FARMS; i++)
    {
        if (!NarcoFarmInfo[i][dfiID]) return i;
    }
    return INVALID_NARCOFARM_ID;
}

stock NarcoFarmGetPlayerBushes(playerid, e_NarcoFarmBushState: target_state = e_NarcoFarmBushState: -1, bool: only_riped = false)
{
    new count = 0;
    for (new i = 0; i < MAX_NARCO_FARMS; i++)
    {
        for (new j = 0; j < MAX_NARCO_FARMS_BOOTHS; j++)
        {
            for (new k = 0; k < MAX_NARCO_FARMS_BUSHES; k++)
            {
                if (_:target_state > -1 && NarcoFarmBushInfo[i][j][k][dfbiState] != target_state) continue;
                if (only_riped && NarcoFarmBushInfo[i][j][k][dfbiWaterings] < NarcoFarmGetMaxWaterings()) continue;

                if (NarcoFarmBushInfo[i][j][k][dfbiOwner] == PlayerInfo[playerid][pID]) count++;
            }
        }
    }
    return count;    
}

stock NarcoFarmGetThingPrice(thingid)
{
    switch (thingid)
    {
        case 44: return getThingPriceGos(thingid, 0) * 3;
    }
    return 0;
}

stock NarcoFarmIsExists(id)
{
    if (id < 0 || id >= MAX_NARCO_FARMS) return 0;
    return NarcoFarmInfo[id][dfiID] != 0;
}

stock NarcoFarmIsBoothExists(farmid, boothid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    if (boothid < 0 || boothid >= MAX_NARCO_FARMS_BOOTHS) return 0;
    return NarcoFarmBoothArea[farmid][boothid][0] != 0.0 && NarcoFarmBoothArea[farmid][boothid][1] != 0.0 && NarcoFarmBoothArea[farmid][boothid][2] != 0.0;
}

stock NarcoFarmIsBushExists(farmid, boothid, bushid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    if (!NarcoFarmIsBoothExists(farmid, boothid)) return 0;
    if (bushid < 0 || bushid >= MAX_NARCO_FARMS_BUSHES) return 0;
    return IsValidDynamicObject(NarcoFarmBushInfo[farmid][boothid][bushid][dfbiObject]);
}

stock NarcoFarmGetBoothOwner(farmid, boothid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    if (!NarcoFarmIsBoothExists(farmid, boothid)) return 0;

    new result = INVALID_PLAYER_ID;
    for (new bushid = 0; bushid < MAX_NARCO_FARMS_BUSHES; bushid++)
    {
        if (!NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner]) return INVALID_PLAYER_ID;
        
        if (result == INVALID_PLAYER_ID)
        {
            result = NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner];
        } else {
            if (result != NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner])
            {
                return INVALID_PLAYER_ID;
            }
        }
    }
    return result;
}

// Вызывается каждые 30 секунд
stock NarcoFarmTick()
{
    for (new farmid = 0; farmid < MAX_NARCO_FARMS; farmid++)
    {
        if (!NarcoFarmIsExists(farmid)) continue;

        for (new boothid = 0; boothid < MAX_NARCO_FARMS_BOOTHS; boothid++)
        {
            if (!NarcoFarmIsBoothExists(farmid, boothid)) continue;

            // Проверка окончания аренды
            for (new bushid = 0; bushid < MAX_NARCO_FARMS_BUSHES; bushid++)
            {
                if (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiRentTime] && NarcoFarmBushInfo[farmid][boothid][bushid][dfbiRentTime] < gettime())
                {
                    new playerid = INVALID_PLAYER_ID;
                    foreach (new id : Player)
                    {
                        if (PlayerInfo[id][pID] == NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner])
                        {
                            playerid = id;
                            break;
                        }
                    }

                    NarcoFarmClearRent(farmid, boothid, bushid);

                    if (IsOnline(playerid))
                    {
                        if (NarcoFarmGetBoothOwner(farmid, boothid) == PlayerInfo[playerid][pID])
                        {
                            SendClientMessage(playerid, COLOR_YELLOW, " SMS от Продавца: {99ff33}Время аренды будки №%d подошло к концу", boothid + 1);
                            for (new i = 0; i < MAX_NARCO_FARMS_BUSHES; i++)
                            {
                                NarcoFarmClearRent(farmid, boothid, i);
                            }
                        }
                        else
                        {
                            SendClientMessage(playerid, COLOR_YELLOW, " SMS от Продавца: {99ff33}Время аренды куста №%d в будке №%d подошло к концу", bushid + 1, boothid + 1);
                        }
                    }
                }
            }
        }
    }

    return 1;
}
// Количество кустов в будке
stock NarcoFarmGetBushesInBooth(farmid, boothid, bool: only_occupied = false)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    if (!NarcoFarmIsBoothExists(farmid, boothid)) return 0;

    new count = 0;
    for (new i = 0; i < MAX_NARCO_FARMS_BUSHES; i++)
    {
        if (only_occupied && !NarcoFarmBushInfo[farmid][boothid][i][dfbiOwner]) continue;
        if (!NarcoFarmIsBushExists(farmid, boothid, i)) continue;

        count++;
    }
    return count;
}

// Цена будки целиком (с учетом количества кустов внутри)
stock NarcoFarmGetBoothPrice(farmid, boothid)
{
    new Float: price = float(NarcoFarmGetBushPrice(farmid, boothid) * NarcoFarmGetBushesInBooth(farmid, boothid));
    price *= 1.2; // +20%

    return floatround(price, floatround_floor);
}

// Цена куста
stock NarcoFarmGetBushPrice(farmid, boothid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    if (!NarcoFarmIsBoothExists(farmid, boothid)) return 0;

    if (NarcoFarmInfo[farmid][dfiMafiaBoothId] == boothid) {
        new Float: price = float(NarcoFarmInfo[farmid][dfiRentPrice]);
        return floatround(price / 100 * (100 - NARCO_FARMS_MAFIA_DISCOUNT), floatround_floor);
    }
    return NarcoFarmInfo[farmid][dfiRentPrice];
}

stock bool: NarcoFarmIsBoothOwner(farmid, boothid, playerid)
{
    return NarcoFarmGetBoothOwner(farmid, boothid) == PlayerInfo[playerid][pID];
}

DIALOG:narcofarm_rent_manage(playerid, response, listitem, const inputtext[])
{
    new farmid = NarcoFarmGetNearest(playerid);
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь на территории наркофермы");

    if (!response) return ShowAdvancedDialogGen<narcofarm_rent>(playerid, GetDialogContextInt(playerid, "boothid"));

    new boothid = GetDialogContextInt(playerid, "boothid");
    if (!NarcoFarmIsBoothExists(farmid, boothid)) return ErrorMessage(playerid, "{FF6347}Указанной будки не существует");

    new bushid = GetDialogContextInt(playerid, "bushid");
    if (!NarcoFarmIsBushExists(farmid, boothid, bushid)) return ErrorMessage(playerid, "{FF6347}Указанного куста не существует");

    if (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid, "{FF6347}Вы не являетесь владельцем этого куста");

    new bool: booth_owner = NarcoFarmIsBoothOwner(farmid, boothid, playerid);
    switch (listitem)
    {
        case 0: {
            if (booth_owner) {
                CreateGps(playerid, NarcoFarmBoothPositions[farmid][boothid][0], NarcoFarmBoothPositions[farmid][boothid][1], NarcoFarmBoothPositions[farmid][boothid][2], .radius = 2.0);
            } else {
                new Float: x, Float: y, Float: z;
                GetDynamicObjectPos(NarcoFarmBushInfo[farmid][boothid][bushid][dfbiObject], x, y, z);
                CreateGps(playerid, x, y, z, .radius = 2.0);
            }
        }
        case 1: {
            new unix = gettime();
            if (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiRentTime] - unix > 300) return ErrorMessage(playerid, "{FF6347}Продлить аренду можно только за 5 минут до её окончания");
            
            new price;
            if (booth_owner)
            {
                price = NarcoFarmGetBoothPrice(farmid, boothid);
            }
            else
            {
                price = NarcoFarmGetBushPrice(farmid, boothid);
            }
            if (PlayerInfo[playerid][pMoney] < price) return ErrorMessage(playerid, "{FF6347}У вас недостаточно денег");
            
            if (booth_owner)
            {
                for (new i = 0; i < MAX_NARCO_FARMS_BUSHES; i++)
                {
                    if (!NarcoFarmIsBushExists(farmid, boothid, i)) continue;

                    NarcoFarmBushInfo[farmid][boothid][i][dfbiRentTime] = gettime() + NARCO_FARMS_RENT_TIME;
                }
            }
            else
            {
                NarcoFarmBushInfo[farmid][boothid][bushid][dfbiRentTime] = gettime() + NARCO_FARMS_RENT_TIME;
            }

            oGivePlayerMoney(playerid, -price);

            if (!booth_owner)
            {
                FORMAT:log("Продлил аренду куста №%d в будке №%d на наркоферме №%d", bushid + 1, boothid + 1, farmid + 1);
                MoneyLog("narcofarmrent", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, log);
            }
            else
            {
                FORMAT:log("Продлил аренду будки №%d на наркоферме №%d", boothid + 1, farmid + 1);
                MoneyLog("narcofarmrent", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, log);
            }

            SuccessMessage(playerid, booth_owner ? "{99ff66}Вы продлили аренду будки" : "{99ff66}Вы продлили аренду куста");
        }
        case 2: {
            if (booth_owner)
            {
                for (new i = 0; i < MAX_NARCO_FARMS_BUSHES; i++)
                {
                    if (!NarcoFarmIsBushExists(farmid, boothid, i)) continue;

                    NarcoFarmClearRent(farmid, boothid, i);
                }
            }
            else
            {
                NarcoFarmClearRent(farmid, boothid, bushid);
            }

            SuccessMessage(playerid, booth_owner ? "{99ff66}Вы отменили аренду будки" : "{99ff66}Вы отменили аренду куста");
        }
    }

    return 1;
}

stock NarcoFarmClearRent(farmid, boothid, bushid)
{
    if (!NarcoFarmIsBushExists(farmid, boothid, bushid)) return 0;

    NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner] = 0;
    NarcoFarmBushInfo[farmid][boothid][bushid][dfbiRentTime] = 0;
    NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterings] = 0;

    // Убираем куст, если не засох
    if (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiState] != NARCO_FARM_BUSH_STATE_DEAD)
    {
        NarcoFarmPlaceBush(farmid, boothid, bushid, false);
        NarcoFarmSetBushState(farmid, boothid, bushid, NARCO_FARM_BUSH_STATE_NONE);
    }

    NarcoFarmUpdateBushLabel(farmid, boothid, bushid);

    return 1;
}

DIALOG_GENERATOR:narcofarm_rent_manage(playerid, boothid)
{
    new farmid = NarcoFarmGetNearest(playerid);
    if (NarcoFarmIsBoothOwner(farmid, boothid, playerid))
    {
        return ShowAdvancedDialog(playerid, "narcofarm_rent_manage", DIALOG_STYLE_TABLIST, "{cccccc}Будка", "{ff9000}Отметить на карте\n{99ff66}Продлить аренду\n{ff6347}Отменить аренду", "Выбор", "Назад");
    }
    return ShowAdvancedDialog(playerid, "narcofarm_rent_manage", DIALOG_STYLE_TABLIST, "{cccccc}Куст", "{ff9000}Отметить на карте\n{99ff66}Продлить аренду\n{ff6347}Отменить аренду", "Выбор", "Назад");
}

DIALOG:narcofarm_rent_confirm(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<narcofarm_rent>(playerid, GetDialogContextInt(playerid, "boothid"));

    new farmid = NarcoFarmGetNearest(playerid);
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь на территории наркофермы");

    new boothid = GetDialogContextInt(playerid, "boothid");
    if (!NarcoFarmIsBoothExists(farmid, boothid)) return ErrorMessage(playerid, "{FF6347}Указанной будки не существует");

    new bushid = GetDialogContextInt(playerid, "bushid"), price = 0;
    if (bushid == -1)
    {
        if (NarcoFarmGetBushesInBooth(farmid, boothid, true) > 0) return ErrorMessage(playerid, "{FF6347}Нельзя арендовать эту будку [ Занят как минимум 1 куст ]");
        if (NarcoFarmGetPlayerBushes(playerid) > 0) return ErrorMessage(playerid, "{FF6347}Нельзя арендовать будку [ У вас уже есть арендованные кусты ]");
        if (NarcoFarmInfo[farmid][dfiMafiaBoothId] == boothid && fraction(playerid) != NarcoFarmInfo[farmid][dfiFraction]) {
            return ErrorMessage(playerid, "{FF6347}Нельзя арендовать эту будку [ Принадлежит участникам мафии ]");
        }

        price = NarcoFarmGetBoothPrice(farmid, boothid);
        if (PlayerInfo[playerid][pMoney] < price) return ErrorMessage(playerid, "{FF6347}У вас недостаточно денег");

        for (new i = 0; i < MAX_NARCO_FARMS_BUSHES; i++)
        {
            if (!NarcoFarmIsBushExists(farmid, boothid, i)) continue;
            
            NarcoFarmBushInfo[farmid][boothid][i][dfbiWaterings] = 0;
            NarcoFarmBushInfo[farmid][boothid][i][dfbiOwner] = PlayerInfo[playerid][pID];
            NarcoFarmBushInfo[farmid][boothid][i][dfbiRentTime] = gettime() + NARCO_FARMS_RENT_TIME;
            NarcoFarmUpdateBushLabel(farmid, boothid, i);
        }

        oGivePlayerMoney(playerid, -price);
        SuccessMessage(playerid, "{99ff66}Вы арендовали выбранную будку");

        FORMAT:log("Арендовал будку №%d на наркоферме №%d", boothid + 1, farmid + 1);
        MoneyLog("rentdrugfarm", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, log);
    }
    else
    {
        if (!NarcoFarmIsBushExists(farmid, boothid, bushid)) return ErrorMessage(playerid, "{FF6347}Указанного куста не существует");
        if (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner]) return ErrorMessage(playerid, "{FF6347}Этот куст уже арендован");
        if (NarcoFarmGetPlayerBushes(playerid) >= NarcoFarmGetMaxPlayerBushes(playerid)) return ErrorMessage(playerid, "{FF6347}Вы уже арендовали максимальное количество кустов");
        if (NarcoFarmInfo[farmid][dfiMafiaBoothId] == boothid && fraction(playerid) != NarcoFarmInfo[farmid][dfiFraction]) {
            return ErrorMessage(playerid, "{FF6347}Нельзя арендовать эту будку [ Принадлежит участникам мафии ]");
        }

        price = NarcoFarmGetBushPrice(farmid, boothid);
        if (PlayerInfo[playerid][pMoney] < price) return ErrorMessage(playerid, "{FF6347}У вас недостаточно денег");

        NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterings] = 0;
        NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner] = PlayerInfo[playerid][pID];
        NarcoFarmBushInfo[farmid][boothid][bushid][dfbiRentTime] = gettime() + NARCO_FARMS_RENT_TIME;
        NarcoFarmUpdateBushLabel(farmid, boothid, bushid);

        oGivePlayerMoney(playerid, -price);
        SuccessMessage(playerid, "{99ff66}Вы арендовали выбранный куст");

        FORMAT:log("Арендовал куст №%d в будке №%d на наркоферме №%d", bushid + 1, boothid + 1, farmid + 1);
        MoneyLog("rentdrugfarm", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, log);
    }

    new fractionid = NarcoFarmInfo[farmid][dfiFraction], amount = price / 10;
    OrganInfo[fractionid][goffshore] += amount;
    OrganInfo[fractionid][gUpdate] = 1;
    OrgLog(fractionid, "rentdrugfarm", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, "Аренда места на наркоферме");

    return 1;
}

DIALOG_GENERATOR:narcofarm_rent_confirm(playerid, boothid, bushid = -1)
{
    new farmid = NarcoFarmGetNearest(playerid);
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь на территории наркофермы");

    SetDialogContextInt(playerid, "boothid", boothid);
    SetDialogContextInt(playerid, "bushid", bushid);

    if (bushid == -1)
    {
        if (NarcoFarmGetBushesInBooth(farmid, boothid, true) > 0) return ErrorMessage(playerid, "{FF6347}Нельзя арендовать эту будку целиком [ Занят как минимум 1 куст ]");

        FORMAT:text("{cccccc}Стоимость аренды будки (1 час): {99ff66}$%d\n\n{cccccc}Вы уверены, что хотите продолжить?", NarcoFarmGetBoothPrice(farmid, boothid));
        return ShowAdvancedDialog(playerid, "narcofarm_rent_confirm", DIALOG_STYLE_MSGBOX, "{cccccc}Аренда будки", text, "Да", "Назад");
    }

    if (!NarcoFarmIsBushExists(farmid, boothid, bushid)) return ErrorMessage(playerid, "{FF6347}Указанного куста не существует");
    if (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner]) return ErrorMessage(playerid, "{FF6347}Этот куст уже арендован");

    FORMAT:text("{cccccc}Стоимость аренды куста (1 час): {99ff66}$%d\n\n{cccccc}Вы уверены, что хотите продолжить?", NarcoFarmGetBushPrice(farmid, boothid));
    return ShowAdvancedDialog(playerid, "narcofarm_rent_confirm", DIALOG_STYLE_MSGBOX, "{cccccc}Аренда куста", text, "Да", "Назад");
}

DIALOG_GENERATOR:narcofarm_rent(playerid, boothid)
{
    new farmid = NarcoFarmGetNearest(playerid);
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь на территории наркофермы");
    
    new dialog_text[1024] = "{cccccc}Будка общего использования\t \n";

    if (NarcoFarmInfo[farmid][dfiMafiaBoothId] == boothid) {
        format(dialog_text, sizeof(dialog_text), "{ff9000}Будка участников мафии [Скидка: %d%%]\t \n", NARCO_FARMS_MAFIA_DISCOUNT);
    }

    for (new bushid = 0; bushid < MAX_NARCO_FARMS_BUSHES; bushid++)
    {
        if (!NarcoFarmIsBushExists(farmid, boothid, bushid)) continue;

        new owner = NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner];

        new tyear, tmonth, tday, thour, tminute, tsecond;
        stamp2datetime(NarcoFarmBushInfo[farmid][boothid][bushid][dfbiRentTime], tyear, tmonth, tday, thour, tminute, tsecond, 3);

        if (owner == PlayerInfo[playerid][pID]) {
            format(dialog_text, sizeof(dialog_text), "%s{99ff66}Куст №%d\t{99ff66}[ Арендован до %02d:%02d:%02d ]\n", dialog_text, bushid + 1, thour, tminute, tsecond);
        } else if (owner > 0) {
            format(dialog_text, sizeof(dialog_text), "%s{ff6347}Куст №%d\t{ff6347}[ Арендован до %02d:%02d:%02d ]\n", dialog_text, bushid + 1, thour, tminute, tsecond);
        } else {
            format(dialog_text, sizeof(dialog_text), "%s{cccccc}Куст №%d\t{99ff66}[ Свободен ]\n", dialog_text, bushid + 1);
        }

        AttachAdvancedDialogItemValue(playerid, "narcofarm_rent", bushid);
    }

    if (NarcoFarmGetBushesInBooth(farmid, boothid, true) == 0) {
        format(dialog_text, sizeof(dialog_text), "%s{ff9000}Арендовать все кусты", dialog_text);
        AttachAdvancedDialogItemValue(playerid, "narcofarm_rent", -1);
    }

    FORMAT:header("{cccccc}Список кустов [Будка №%d]", boothid + 1);
    return ShowAdvancedDialog(playerid, "narcofarm_rent", DIALOG_STYLE_TABLIST_HEADERS, header, dialog_text, "Выбор", "Назад");
}

DIALOG_ITEMS:narcofarm_rent(playerid, response, listitem, bushid, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<narcofarm_booths>(playerid);

    new farmid = NarcoFarmGetNearest(playerid);
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь на территории наркофермы");

    new boothid = GetDialogContextInt(playerid, "boothid");
    if (!NarcoFarmIsBoothExists(farmid, boothid)) return ErrorMessage(playerid, "{FF6347}Указанной будки не существует");
    
    if (bushid == -1) // Арендовать все кусты
    {
        ShowAdvancedDialogGen<narcofarm_rent_confirm>(playerid, boothid, bushid);
    }
    else // Арендовать один куст
    {
        if (!NarcoFarmIsBushExists(farmid, boothid, bushid)) return ErrorMessage(playerid, "{FF6347}Указанного куста не существует");
        if (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner]) {
            if (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner] == PlayerInfo[playerid][pID])
            {
                SetDialogContextInt(playerid, "boothid", boothid);
                SetDialogContextInt(playerid, "bushid", bushid);

                return ShowAdvancedDialogGen<narcofarm_rent_manage>(playerid, boothid);
            }
            
            return ErrorMessage(playerid, "{FF6347}Этот куст уже арендован");
        }
        ShowAdvancedDialogGen<narcofarm_rent_confirm>(playerid, boothid, bushid);
    }

    return 1;
}

DIALOG_ITEMS:narcofarm_booths(playerid, response, listitem, boothid, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "narcofarm_seller");

    new farmid = NarcoFarmGetNearest(playerid);
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь на территории наркофермы");
    if (!NarcoFarmIsBoothExists(farmid, boothid)) return ErrorMessage(playerid, "{FF6347}Указанной будки не существует");

    SetDialogContextInt(playerid, "boothid", boothid);

    if (NarcoFarmIsBoothOwner(farmid, boothid, playerid))
    {
        return ShowAdvancedDialogGen<narcofarm_rent_manage>(playerid, boothid);
    } else if (NarcoFarmGetBoothOwner(farmid, boothid) != INVALID_PLAYER_ID) {
        return ErrorMessage(playerid, "{FF6347}Эта будка уже арендована");
    }
    return ShowAdvancedDialogGen<narcofarm_rent>(playerid, boothid);
}

DIALOG_GENERATOR:narcofarm_booths(playerid)
{
    new farmid = NarcoFarmGetNearest(playerid);
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь на территории наркофермы");

    new dialog_text[1024];

    for (new i = 0; i < MAX_NARCO_FARMS_BOOTHS; i++)
    {
        if (!NarcoFarmIsBoothExists(farmid, i)) continue;

        new rented_bushes = NarcoFarmGetBushesInBooth(farmid, i, true);
        new total_bushes = NarcoFarmGetBushesInBooth(farmid, i);
        
        if (NarcoFarmGetBoothOwner(farmid, i) != INVALID_PLAYER_ID) {
            new tyear, tmonth, tday, thour, tminute, tsecond;
            stamp2datetime(NarcoFarmBushInfo[farmid][i][0][dfbiRentTime], tyear, tmonth, tday, thour, tminute, tsecond, 3);
            
            if (NarcoFarmIsBoothOwner(farmid, i, playerid)) {
                format(dialog_text, sizeof(dialog_text), "%s{cccccc}Будка №%d\t{99ff66}[ Арендована до %02d:%02d:%02d ]\n", dialog_text, i + 1, thour, tminute, tsecond);
            } else {
                format(dialog_text, sizeof(dialog_text), "%s{cccccc}Будка №%d\t{ff9000}[ Арендована до %02d:%02d:%02d ]\n", dialog_text, i + 1, thour, tminute, tsecond);
            }
        } else if (rented_bushes > 0) {
            format(dialog_text, sizeof(dialog_text), "%s{cccccc}Будка №%d\t{ff9000}[ Арендовано кустов: %d/%d ]\n", dialog_text, i + 1, rented_bushes, total_bushes);
        } else {
            format(dialog_text, sizeof(dialog_text), "%s{cccccc}Будка №%d\t{99ff66}[ Свободна ]\n", dialog_text, i + 1);
        }

        AttachAdvancedDialogItemValue(playerid, "narcofarm_booths", i);
    }

    return ShowAdvancedDialog(playerid, "narcofarm_booths", DIALOG_STYLE_TABLIST, "{cccccc}Аренда будок", dialog_text, "Выбор", "Назад");
}

DIALOG:narcofarm_seller(playerid, response, listitem, const inputtext[])
{
    if (!response) return 0;

    new farmid = NarcoFarmGetNearest(playerid);
    if (!NarcoFarmIsExists(farmid)) return 0;

    switch (listitem)
    {
        case 0: return ShowAdvancedDialogGen<narcofarm_booths>(playerid);
        case 1: {
            new price = NarcoFarmGetThingPrice(44);
            if (PlayerInfo[playerid][pMoney] < price) return ErrorMessage(playerid, "{FF6347}У вас недостаточно денег");
            if (get_invent4(playerid, 44, 0) > 0) return ErrorMessage(playerid, "{FF6347}У вас уже есть лопата");

            new put_inva = GiveThingPlayer(playerid, 44, 1, 0, 0, 0, 0);
            if (put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");

            oGivePlayerMoney(playerid, -price);
            MoneyLog("buyshovel", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, "Купил лопату на наркоферме");

            SuccessMessage(playerid, "{99ff66}Вы купили лопату");
        }
    }

    return 1;
}

DIALOG_GENERATOR:narcofarm_info(playerid, farmid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;

    FORMAT:header("{ff9000}Наркоферма №%d\n", NarcoFarmInfo[farmid][dfiID]);

    new total_bushes = 0, occupied_bushes = 0;
    for (new i = 0; i < MAX_NARCO_FARMS_BOOTHS; i++)
    {
        if (!NarcoFarmIsBoothExists(farmid, i)) continue;

        new bushes = NarcoFarmGetBushesInBooth(farmid, i);

        for (new j = 0; j < bushes; j++)
        {
            if (NarcoFarmBushInfo[farmid][i][j][dfbiOwner]) occupied_bushes++;
        }

        total_bushes += bushes;
    }

    new text[2048];
    format(text, sizeof(text), 
        "{cccccc}Контролирующая организация: {ff9000}%s\n\n" \
        \
        "{cccccc}Общее количество кустов: {ff9000}%d [ Свободно: %d ]\n",

        frakName[NarcoFarmInfo[farmid][dfiFraction]],
        total_bushes, total_bushes - occupied_bushes
    );
    
    return ShowAdvancedDialog(playerid, "narcofarm_info", DIALOG_STYLE_MSGBOX, header, text, "Закрыть", "", true);
}

stock NarcoFarmGetMaxPlayerBushes(playerid)
{
    return GetPlayerVip(playerid) >= 3 ? 2 : 1;
}

stock NarcoFarmSetBushState(farmid, boothid, bushid, e_NarcoFarmBushState: status)
{
    if (!NarcoFarmIsBushExists(farmid, boothid, bushid)) return 0;

    new e_NarcoFarmBushState: prev_status = NarcoFarmBushInfo[farmid][boothid][bushid][dfbiState];

    NarcoFarmBushInfo[farmid][boothid][bushid][dfbiState] = status;
    if (status == NARCO_FARM_BUSH_STATE_SEEDED)
    {
        if (prev_status != status) // Первый полив
        {
            NarcoFarmPlaceBush(farmid, boothid, bushid, true);
            NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterTime] = gettime() + NARCO_FARMS_MAX_WATER_TIME; // Ждем первый полив
        }
        else // Любой другой полив
        {
            NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterTime] = gettime() + NARCO_FARMS_WATER_TIME + NARCO_FARMS_MAX_WATER_TIME; // Ждем следующий полив
        }
    }
    
    /*
        64431 = CreateDynamicObject(808, -1088.337402, -1645.263183, 76.373977, 0.000000, 0.000000, 0.000000); // нормальный
        64478 = CreateDynamicObject(809, -1087.696777, -1645.263183, 74.633605, 0.000000, 0.000000, 0.000000); // засохший
    */

    new objectid = NarcoFarmBushInfo[farmid][boothid][bushid][dfbiObject];
    if (IsValidDynamicObject(objectid))
    {
        if (status == NARCO_FARM_BUSH_STATE_DEAD) // Модель засохшего куста
        {
            if (GetDynamicObjectModel(objectid) == NARCO_FARMS_BUSH_MODELID)
            {
                new Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz;
                GetDynamicObjectPos(objectid, x, y, z);
                GetDynamicObjectRot(objectid, rx, ry, rz);
                new Float: new_x, Float: new_y, Float: new_z;
                GetRelativePos(x, y, z, rx, ry, rz, 0.640, 0.0, -1.740, new_x, new_y, new_z);
                SetDynamicObjectPos(objectid, new_x, new_y, new_z);
            }

            Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID, NARCO_FARMS_DEAD_BUSH_MODELID);
        } else // Модель обычного куста
        {
            if (GetDynamicObjectModel(objectid) == NARCO_FARMS_DEAD_BUSH_MODELID)
            {
                new Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz;
                GetDynamicObjectPos(objectid, x, y, z);
                GetDynamicObjectRot(objectid, rx, ry, rz);
                new Float: new_x, Float: new_y, Float: new_z;
                GetRelativePos(x, y, z, rx, ry, rz, -0.640, 0.0, 1.740, new_x, new_y, new_z);
                SetDynamicObjectPos(objectid, new_x, new_y, new_z);
            }

            Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID, NARCO_FARMS_BUSH_MODELID);
        }
    }

    if (status == NARCO_FARM_BUSH_STATE_NONE)
    {
        NarcoFarmBushInfo[farmid][boothid][bushid][dfbiCollect] = 0;
    }

    new Float: distance;
    foreach (new playerid : Player)
    {
        Streamer_GetDistanceToItem(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid], STREAMER_TYPE_OBJECT, objectid, distance);
        if (distance > 5.0) continue;

        Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
    }

    NarcoFarmUpdateBushLabel(farmid, boothid, bushid);
    return 1;
}

stock NarcoFarmPackStartPump(playerid)
{
    new farmid = NarcoFarmGetNearest(playerid);
    if (!NarcoFarmIsExists(farmid)) return 0;

    NarcoFarmPlayerInfo[playerid][dfpiPosition][0] = Protect_X[playerid];
    NarcoFarmPlayerInfo[playerid][dfpiPosition][1] = Protect_Y[playerid];
    NarcoFarmPlayerInfo[playerid][dfpiPosition][2] = Protect_Z[playerid];

    PPP15[playerid] = 0;
    RemovePlayerAttachedObject(playerid, 1);

    FORMAT:text("~n~~n~~n~~n~~n~~n~~n~~n~~w~УПАКОВАТЬ ПОРОШОК: ~y~%s", buttonName[Device[playerid]]);
    GameTextForPlayer(playerid, RusToGame(text), 2000, 5);
    SetPVarInt(playerid, "Arobsklad", 22);

    return 1;
}

stock NarcoFarm_PackPump(playerid)
{
    SetPVarInt(playerid, "oryjtemp", GetPVarInt(playerid, "oryjtemp") + 5);

    new farmid = NarcoFarmGetNearest(playerid);
    if (!NarcoFarmIsExists(farmid) ||
        Hold[playerid] != 21 ||
        !IsPlayerInRangeOfPoint(playerid, 1.0, NarcoFarmPlayerInfo[playerid][dfpiPosition][0], NarcoFarmPlayerInfo[playerid][dfpiPosition][1], NarcoFarmPlayerInfo[playerid][dfpiPosition][2])
    ) {
        // Произошла ошибка в процессе упаковки
        SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad", 0);
        ClearAnim(playerid);

        PlayerPlaySound(playerid, 31203);
        return 0;
    }

    new gametext[128];
    new current_progress = GetPVarInt(playerid, "oryjtemp");
    if (current_progress >= NARCO_FARMS_PACK_PUMP_POINTS)
    {
        SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad", 0);
        ClearAnim(playerid);

        format(gametext, sizeof(gametext), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~~h~~h~YЊAKO‹KA: ~w~%d/%d", NARCO_FARMS_PACK_PUMP_POINTS, NARCO_FARMS_PACK_PUMP_POINTS);

        GameTextForPlayer(playerid, gametext, 2500, 3);
        PlayerPlaySound(playerid, 6401);

        NarcoFarmPlayerInfo[playerid][dfpiFarmID] = INVALID_NARCOFARM_ID;

        new bool: is_mafia = NarcoFarmPlayerInfo[playerid][dfpiBoothID] == NarcoFarmInfo[farmid][dfiMafiaBoothId];
        if (is_mafia)
        {
            GiveThingHand(playerid, 272, HoldStat[playerid], 0, 0, 0, 2);
            ApplyAnimation(playerid, "CARRY", "liftup", 4.0, false, true, true, false, 0, SYNC_ALL);
            PPP15[playerid] = 3, RemovePlayerAttachedObject(playerid, 1);
            SetPlayerAttachedObject(playerid, 1, 3014, 6, 0.120000, 0.199448, -0.120000, 254.000000, 0.900000, 70.000000);
            SetPlayerChatBubble(playerid, "берёт ящик", COLOR_PURPLE, 20.0, 5000);
        }
        else
        {
            new put_inva = GiveThingPlayer(playerid, 272, HoldStat[playerid], 0, 0, 0, 0);
            if (put_inva == -1)
            {
                ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");
                return 0;
            }
            RemovePlayerAttachedObject(playerid, 1);

            new drugid, drugquan;
            Drugs_GetPackageAmount(272, drugid, drugquan);
            FORMAT:text("{99ff66}Вы успешно упаковали порошок!\n\n{cccccc}Вам выдано: %d %s (%d использований)", HoldStat[playerid], PluralToText(HoldStat[playerid], "упаковка", "упаковки", "упаковок"), HoldStat[playerid] * drugquan);
            SuccessMessage(playerid, text);

            SetPlayerChatBubble(playerid, "берёт упаковку", COLOR_PURPLE, 20.0, 5000);
        }

        Hold[playerid] = 0;
    } else {
        format(gametext, sizeof(gametext), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~~h~~h~YЊAKO‹KA: ~w~%d/%d", current_progress, NARCO_FARMS_PACK_PUMP_POINTS);

        if (current_progress <= 5 || current_progress % 10 == 0)
        {
            ApplyAnimation(playerid, "INT_HOUSE", "wash_up", 3.5, true, false, false, false, false, SYNC_ALL);
            SetPlayerChatBubble(playerid, "упаковывает порошок", COLOR_PURPLE, 20.0, 1500);
        }

        GameTextForPlayer(playerid, gametext, 2500, 3);
    }

    return 1;
}

stock NarcoFarmStartPump(playerid, boothid, bushid)
{
    new farmid = NarcoFarmGetNearest(playerid);
    if (!NarcoFarmIsBushExists(farmid, boothid, bushid)) return 0;
    if (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid, "{FF6347}Вы не арендуете этот куст");

    if (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterings] >= NarcoFarmGetMaxWaterings())
    {
        if (Hold[playerid] == 0 || Hold[playerid] != 21) return ErrorMessage(playerid, "{FF6347}Возьмите корзинку перед тем, как начать собирать порошок");

        new collect = NarcoFarmBushInfo[farmid][boothid][bushid][dfbiCollect];
        if ((random(2) == 0 || collect == 0) && collect < NARCO_FARMS_MAX_COCAINE) {} // [1; NARCO_FARMS_MAX_COCAINE]
        else {
            NarcoFarmPlaceBush(farmid, boothid, bushid, false);

            NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterings] = 0;
            NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterTime] = 0;
            NarcoFarmSetBushState(farmid, boothid, bushid, NARCO_FARM_BUSH_STATE_NONE);
        }
        
        PlayerPlaySound(playerid, 6401);
        GameTextForPlayer(playerid, RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~b~~h~~h~~h~ПОРОШОК +1"), 2000, 5);

        NarcoFarmBushInfo[farmid][boothid][bushid][dfbiCollect]++;
        HoldStat[playerid]++;
        NarcoFarmPlayerInfo[playerid][dfpiFarmID] = farmid;
        NarcoFarmPlayerInfo[playerid][dfpiBoothID] = boothid;
        NarcoFarmPlayerInfo[playerid][dfpiBushID] = bushid;

        return 1;
    }

    NarcoFarmPlayerInfo[playerid][dfpiPosition][0] = Protect_X[playerid];
    NarcoFarmPlayerInfo[playerid][dfpiPosition][1] = Protect_Y[playerid];
    NarcoFarmPlayerInfo[playerid][dfpiPosition][2] = Protect_Z[playerid];

    switch (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiState])
    {
        case NARCO_FARM_BUSH_STATE_NONE, NARCO_FARM_BUSH_STATE_DEAD:
        {
            if (get_invent4(playerid, 44, 0) == 0) return ErrorMessage(playerid, "{FF6347}У вас нет лопаты в инвентаре");
            if (Hold[playerid] != 6) return ErrorMessage(playerid, "{FF6347}Для начала работы необходимо взять лопату в руки");

            if (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiState] == NARCO_FARM_BUSH_STATE_DEAD)
            {
                FORMAT:text("~n~~n~~n~~n~~n~~n~~n~~n~~w~ВЫКОПАТЬ КУСТ: ~y~%s", buttonName[Device[playerid]]);
                GameTextForPlayer(playerid, RusToGame(text), 2000, 5);
            }
            else
            {
                FORMAT:text("~n~~n~~n~~n~~n~~n~~n~~n~~w~ВЫКОПАТЬ ЯМУ: ~y~%s", buttonName[Device[playerid]]);
                GameTextForPlayer(playerid, RusToGame(text), 2000, 5);
            }
        }
        case NARCO_FARM_BUSH_STATE_EXCAVATED, NARCO_FARM_BUSH_STATE_SEEDED:
        {
            if (Hold[playerid] != 15) return ErrorMessage(playerid, "{FF6347}Для начала работы необходимо взять канистру в руки");
            {
                new elapsed = NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterTime] - gettime();
                if (elapsed > NARCO_FARMS_MAX_WATER_TIME) return ErrorMessage(playerid, "{FF6347}Этот куст ещё не нуждается в поливе");
            }

            FORMAT:text("~n~~n~~n~~n~~n~~n~~n~~n~~w~ПОЛИТЬ КУСТ: ~y~%s", buttonName[Device[playerid]]);
            GameTextForPlayer(playerid, RusToGame(text), 2000, 5);
        }
        case NARCO_FARM_BUSH_STATE_WATERED:
        {
            if (Hold[playerid] != 20) return ErrorMessage(playerid, "{FF6347}Для начала работы необходимо взять саженец");
            FORMAT:text("~n~~n~~n~~n~~n~~n~~n~~n~~w~ПОСАДИТЬ САЖЕНЕЦ: ~y~%s", buttonName[Device[playerid]]);
            GameTextForPlayer(playerid, RusToGame(text), 2000, 5);
        }
        default: return 0;
    }

    NarcoFarmPlayerInfo[playerid][dfpiFarmID] = farmid;
    NarcoFarmPlayerInfo[playerid][dfpiBoothID] = boothid;
    NarcoFarmPlayerInfo[playerid][dfpiBushID] = bushid;
    NarcoFarmPlayerInfo[playerid][dfpiBushState] = NarcoFarmBushInfo[farmid][boothid][bushid][dfbiState];
    SetPVarInt(playerid, "Arobsklad", 21);

    return 1;
}

stock NarcoFarm_Pump(playerid)
{
    SetPVarInt(playerid, "oryjtemp", GetPVarInt(playerid, "oryjtemp") + 5);

    new farmid = NarcoFarmGetNearest(playerid),
        boothid = NarcoFarmPlayerInfo[playerid][dfpiBoothID],
        bushid = NarcoFarmPlayerInfo[playerid][dfpiBushID],
        e_NarcoFarmBushState: bushstate = NarcoFarmPlayerInfo[playerid][dfpiBushState];
    if (farmid != NarcoFarmPlayerInfo[playerid][dfpiFarmID] ||
        !NarcoFarmIsBushExists(farmid, boothid, bushid) ||
        NarcoFarmBushInfo[farmid][boothid][bushid][dfbiState] != bushstate ||
        !IsPlayerInRangeOfPoint(playerid, 1.0, NarcoFarmPlayerInfo[playerid][dfpiPosition][0], NarcoFarmPlayerInfo[playerid][dfpiPosition][1], NarcoFarmPlayerInfo[playerid][dfpiPosition][2])
    ) {
        // Произошла ошибка в процессе
        SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad", 0);
        ClearAnim(playerid);

        PlayerPlaySound(playerid, 31203);
        return 0;
    }

    new gametext[128], max_points, e_NarcoFarmBushState: nextstate;
    switch (bushstate)
    {
        case NARCO_FARM_BUSH_STATE_NONE, NARCO_FARM_BUSH_STATE_DEAD: // Раскопать (яму/засохший куст)
        {
            strcat(gametext, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~PACKAЊ‘‹AH…E");
            nextstate = NARCO_FARM_BUSH_STATE_EXCAVATED;
            max_points = NARCO_FARMS_EXCAVATE_PUMP_POINTS;
        }
        case NARCO_FARM_BUSH_STATE_EXCAVATED, NARCO_FARM_BUSH_STATE_SEEDED: // Полить (первый/последующий разы)
        {
            strcat(gametext, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~~h~~h~~h~ЊO‡…‹");
            if (bushstate == NARCO_FARM_BUSH_STATE_EXCAVATED)
            {
                // Полив перед посадкой
                nextstate = NARCO_FARM_BUSH_STATE_WATERED;
            }
            else
            {
                // Повторный полив
                nextstate = bushstate;
            }
            max_points = NARCO_FARMS_WATER_PUMP_POINTS;
        }
        case NARCO_FARM_BUSH_STATE_WATERED: // Посадить
        {
            strcat(gametext, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~h~ЊOCAѓKA");
            nextstate = NARCO_FARM_BUSH_STATE_SEEDED;
            max_points = NARCO_FARMS_SEED_PUMP_POINTS;
        }
        default: return 0;
    }

    new current_progress = GetPVarInt(playerid, "oryjtemp");
    if (current_progress >= max_points)
    {
        SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad", 0);
        ClearAnim(playerid);

        format(gametext, sizeof(gametext), "%s: ~w~%d/%d", gametext, max_points, max_points);
        NarcoFarmSetBushState(farmid, boothid, bushid, nextstate);

        GameTextForPlayer(playerid, gametext, 2500, 3);
        PlayerPlaySound(playerid, 6401);

        NarcoFarmPlayerInfo[playerid][dfpiFarmID] = INVALID_NARCOFARM_ID;

        if (nextstate == NARCO_FARM_BUSH_STATE_SEEDED) // Посадили саженец
        {
            if (Hold[playerid] == 20)
            {
                Hold[playerid] = 0;
                RemovePlayerAttachedObject(playerid, 1);
            }
        }

        if (nextstate == NARCO_FARM_BUSH_STATE_WATERED || (bushstate == nextstate && nextstate == NARCO_FARM_BUSH_STATE_SEEDED)) // Полили куст
        {
            if (++NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterings] >= NarcoFarmGetMaxWaterings())
            {
                NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterTime] = gettime() + NARCO_FARMS_WATER_TIME;
                SuccessMessage(playerid, "{99ff66}Куст созрел\n\n{cccccc}Соберите порошок и подойдите к упаковочному столу");
            }
            NarcoFarmUpdateBushLabel(farmid, boothid, bushid);
        } else if (nextstate == NARCO_FARM_BUSH_STATE_EXCAVATED) // Раскопали яму
        {
            NarcoFarmPlaceBush(farmid, boothid, bushid, false); // Убираем засохший куст, если был
        }

        Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
    } else {
        format(gametext, sizeof(gametext), "%s: ~w~%d/%d", gametext, current_progress, max_points);

        switch (bushstate)
        {
            case NARCO_FARM_BUSH_STATE_NONE, NARCO_FARM_BUSH_STATE_DEAD: // Раскопать
            {
                if (current_progress % 10 == 0)
                {
                    ApplyAnimation(playerid, "SWORD", "sword_4", 4.0, false, false, false, false, false, SYNC_ALL);
                    SetPlayerChatBubble(playerid, "раскапывает куст", COLOR_PURPLE, 20.0, 1500);
                }
            }
            case NARCO_FARM_BUSH_STATE_EXCAVATED, NARCO_FARM_BUSH_STATE_SEEDED: // Полить
            {
                if (current_progress % 10 == 0)
                {
                    ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false, SYNC_ALL);
                    SetPlayerChatBubble(playerid, "поливает куст", COLOR_PURPLE, 20.0, 1500);
                }
            }
            case NARCO_FARM_BUSH_STATE_WATERED: // Посадить
            {
                if (current_progress % 10 == 0)
                {
                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, false, SYNC_ALL);
                    SetPlayerChatBubble(playerid, "сажает куст", COLOR_PURPLE, 20.0, 1500);
                }
            }
        }

        GameTextForPlayer(playerid, gametext, 2500, 3);
    }

    return 1;
}

stock NarcoFarmGetMaxWaterings()
{
    return server == 0 ? NARCO_FARMS_RIPE_TIME_TEST : NARCO_FARMS_RIPE_TIME;
}

function NarcoFarmUpdateBushLabel(farmid, boothid, bushid)
{
    if (!IsValidDynamic3DTextLabel(NarcoFarmBushInfo[farmid][boothid][bushid][dfbiLabel])) return 0;
    new STREAMER_TAG_3D_TEXT_LABEL: BUSH_LABEL = NarcoFarmBushInfo[farmid][boothid][bushid][dfbiLabel];
    
    if (!NarcoFarmBushInfo[farmid][boothid][bushid][dfbiOwner])
    {
        FORMAT:text("{ff9000}Куст №%d\n{99ff66}Свободен\n\n{ff9000}[ Цена: $%d ]", bushid + 1, NarcoFarmGetBushPrice(farmid, boothid));
        UpdateDynamic3DTextLabelText(BUSH_LABEL, 0xFF9000FF, text);
        return 1;
    } else if (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterings] >= NarcoFarmGetMaxWaterings())
    {
        new elapsed = NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterTime] - gettime();
        if (elapsed > 0) {
            // Куст созрел, скоро засохнет
            FORMAT:text("{ff9000}Куст №%d\n{99ff66}Созрел\n{ff6347}Засохнет через: %s\n\n{ff9000}[ ALT ]", bushid + 1, fine_time(elapsed));
            UpdateDynamic3DTextLabelText(BUSH_LABEL, 0xFF9000FF, text);
            SetTimerEx("NarcoFarmUpdateBushLabel", 1000, false, "iii", farmid, boothid, bushid);
        } else {
            // Куст засох
            NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterings] = 0;
            NarcoFarmSetBushState(farmid, boothid, bushid, NARCO_FARM_BUSH_STATE_DEAD);
        }
        return 1;
    }

    switch (NarcoFarmBushInfo[farmid][boothid][bushid][dfbiState])
    {
        case NARCO_FARM_BUSH_STATE_NONE:
        {
            FORMAT:text("{ff9000}Куст №%d\n{8b4513}Требуется раскопать\n\n{ff9000}[ Лопата в руках + ALT ]", bushid + 1);
            UpdateDynamic3DTextLabelText(BUSH_LABEL, 0xFF9000FF, text);
        }
        case NARCO_FARM_BUSH_STATE_EXCAVATED:
        {
            FORMAT:text("{ff9000}Куст №%d\n{00bfff}Требуется полить\n\n{ff9000}[ Канистра в руках + ALT ]", bushid + 1);
            UpdateDynamic3DTextLabelText(BUSH_LABEL, 0xFF9000FF, text);
        }
        case NARCO_FARM_BUSH_STATE_WATERED:
        {
            FORMAT:text("{ff9000}Куст №%d\n{8b4513}Требуется посадить\n\n{ff9000}[ Саженец в руках + ALT ]", bushid + 1);
            UpdateDynamic3DTextLabelText(BUSH_LABEL, 0xFF9000FF, text);
        }
        case NARCO_FARM_BUSH_STATE_SEEDED:
        {
            new unix = gettime();

            new text[128];
            new elapsed = NarcoFarmBushInfo[farmid][boothid][bushid][dfbiWaterTime] - unix;
            if (elapsed > NARCO_FARMS_MAX_WATER_TIME)
            {
                format(text, sizeof(text), "{ff9000}Куст №%d\n{00bfff}Требуется полить через: %s", bushid + 1, fine_time(elapsed - NARCO_FARMS_MAX_WATER_TIME));
            } else {
                format(text, sizeof(text), "{ff9000}Куст №%d\n{00bfff}Требуется полить\n{ff6347}Засохнет через: %s\n\n{ff9000}[ Канистра в руках + ALT ]", bushid + 1, fine_time(elapsed));
            }
            UpdateDynamic3DTextLabelText(BUSH_LABEL, 0xFF9000FF, text);

            if (elapsed > 0) SetTimerEx("NarcoFarmUpdateBushLabel", 1000, false, "iii", farmid, boothid, bushid);
            else NarcoFarmSetBushState(farmid, boothid, bushid, NARCO_FARM_BUSH_STATE_DEAD);
        }
        case NARCO_FARM_BUSH_STATE_DEAD:
        {
            FORMAT:text("{ff9000}Куст №%d\n{ff6347}Засох\n\n{ff9000}[ Лопата в руках + ALT ]", bushid + 1);
            UpdateDynamic3DTextLabelText(BUSH_LABEL, 0xFF9000FF, text);
        }
    }

    return 1;
}

stock NarcoFarmGetNearestBush(playerid, &boothid, &bushid, Float: max_distance = 2.0)
{
    new farmid = NarcoFarmGetNearest(playerid);
    if (!NarcoFarmIsExists(farmid)) return 0;

    new Float: min_distance = max_distance + 1.0;
    new Float: distance;

    for (new i = 0; i < MAX_NARCO_FARMS_BOOTHS; i++)
    {
        for (new j = 0; j < MAX_NARCO_FARMS_BUSHES; j++)
        {
            if (!NarcoFarmIsBushExists(farmid, i, j)) continue;

            Streamer_GetDistanceToItem(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid], STREAMER_TYPE_3D_TEXT_LABEL, NarcoFarmBushInfo[farmid][i][j][dfbiLabel], distance);
            if (distance < min_distance)
            {
                min_distance = distance;
                boothid = i;
                bushid = j;
            }
        }
    }

    if (min_distance <= max_distance) return 1;

    return 0;
}

stock NarcoFarm_OnPlayerPressALT(playerid)
{
    if (GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return 0;

    for (new i = 0; i < MAX_NARCO_FARMS; i++)
    {
        if (!NarcoFarmIsExists(i)) continue;

        new Float: distance;

        // Информационный пикап
        Streamer_GetDistanceToItem(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid], STREAMER_TYPE_PICKUP, NarcoFarmInfo[i][dfiInfoPickup], distance);
        if (distance <= 1.5) return ShowAdvancedDialogGen<narcofarm_info>(playerid, i);

        // Интерактивные места (взять саженец/лейку и т.п.)
        for (new j = 0; j < sizeof(NarcoFarmInteractivePositions[]); j++)
        {
            if (!IsPlayerInRangeOfPoint(playerid, 1.30, NarcoFarmInteractivePositions[i][j][0], NarcoFarmInteractivePositions[i][j][1], NarcoFarmInteractivePositions[i][j][2])) continue;

            switch (e_NarcoFarmInteractivePositions: j)
            {
                case NARCO_FARM_POSITION_PACK_TABLE: {
                    if (Hold[playerid] != 21) return ErrorMessage(playerid, "{FF6347}У вас нет в руках собранного порошка");
                    if (HoldStat[playerid] <= 0) return ErrorMessage(playerid, "{FF6347}Ваша корзинка пуста");
                    NarcoFarmPackStartPump(playerid);
                }
                case NARCO_FARM_POSITION_SEEDS: {
                    if (Hold[playerid] == 0)
                    {
                        if (NarcoFarmGetPlayerBushes(playerid, NARCO_FARM_BUSH_STATE_WATERED) == 0) return ErrorMessage(playerid, "{FF6347}У вас нет кустов, ожидающих посадки");
                        
                        Hold[playerid] = 20;
                        SetPlayerAttachedObject(playerid, 1, 808, 6, 0.114000, -0.021999, 0.284000, 14.999998, 0.000000, 0.000000, 0.118999, 0.088999, 0.134999, 0x0, 0x0);
                        ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false, SYNC_ALL); 
                    }
                    else
                    {
                        if (Hold[playerid] != 20) return ErrorMessage(playerid, "{FF6347}У вас заняты руки");
                        Hold[playerid] = 0;
                        RemovePlayerAttachedObject(playerid, 1);
                        ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false, SYNC_ALL);
                    }
                }
                case NARCO_FARM_POSITION_LEEK: {
                    if (Hold[playerid] == 0)
                    {
                        if (NarcoFarmGetPlayerBushes(playerid) == 0) return ErrorMessage(playerid, "{FF6347}У вас нет арендованных кустов");
                        Hold[playerid] = 15;
                        SetPlayerAttachedObject(playerid, 1, 12732, 6, 0.271000, 0.025000, 0.000000, 0.399998, -80.399932, 89.400016, 0.434001, 0.661000, 0.632002, 0x0, 0x0);
                        ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false, SYNC_ALL);
                    }
                    else
                    {
                        if (Hold[playerid] != 15) return ErrorMessage(playerid, "{FF6347}У вас заняты руки");
                        Hold[playerid] = 0;
                        RemovePlayerAttachedObject(playerid, 1);
                        ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false, SYNC_ALL);
                    }
                }
                case NARCO_FARM_POSITION_BASKET: {
                    if (Hold[playerid] == 0)
                    {
                        if (NarcoFarmGetPlayerBushes(playerid, .only_riped = true) == 0) return ErrorMessage(playerid, "{FF6347}У вас нет кустов, ожидающих сбора");

                        Hold[playerid] = 21;
                        HoldStat[playerid] = 0;
                        SetPlayerAttachedObject(playerid, 1, 19639, 6, 0.080999, 0.043999, -0.149000, -106.700027, 0.000000, -10.999998, 1.000000, 1.000000, 1.000000, 0, 0);
                        ApplyAnimation(playerid,"CARRY","liftup",4.0, false, true, true, false, false, SYNC_ALL);
                        PPP15[playerid] = 3; // Пустая Корзинка
                    }
                    else
                    {
                        if (HoldStat[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Вы не можете убрать корзинку с собранным порошком");
                        RemovePlayerAttachedObject(playerid, 1);
                        ApplyAnimation(playerid,"CARRY","liftup",4.0, false, true, true, false, false, SYNC_ALL);
                        Hold[playerid] = 0;
                        PPP15[playerid] = 0;
                    }
                }
            }

            return 1;
        }

        // Кусты
        {
            new boothid, bushid;
            if (NarcoFarmGetNearestBush(playerid, boothid, bushid))
            {
                return NarcoFarmStartPump(playerid, boothid, bushid);
            }
        }
        
        // Продавец
        Streamer_GetDistanceToItem(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid], STREAMER_TYPE_ACTOR, NarcoFarmInfo[i][dfiSellerActor], distance);
        if (distance <= 1.0)
        {
            FORMAT:text("{cccccc}Аренда кустов\t{ff9000}>>\n{cccccc}Лопата\t{99ff66}$%d", NarcoFarmGetThingPrice(44));
            ShowAdvancedDialog(playerid, "narcofarm_seller", DIALOG_STYLE_TABLIST, "{cccccc}Продавец", text, "Выбор", "Закрыть", true);
            return 1;
        }
    }
    return 0;
}

stock NarcoFarm_OnPlayerPressY(playerid)
{
    if (NarcoFarmPlayerInfo[playerid][dfpiEditAreaMode])
    {
        new farmid = NarcoFarmPlayerInfo[playerid][dfpiFarmID];
        if (!NarcoFarmIsExists(farmid)) {
            NarcoFarmPlayerInfo[playerid][dfpiEditAreaMode] = false;
            return 0;
        }
        if (NarcoFarmPlayerInfo[playerid][dfpiArea][0] == 0.0 && NarcoFarmPlayerInfo[playerid][dfpiArea][1] == 0.0 && NarcoFarmPlayerInfo[playerid][dfpiArea][2] == 0.0) {
            NarcoFarmPlayerInfo[playerid][dfpiArea][0] = Protect_X[playerid];
            NarcoFarmPlayerInfo[playerid][dfpiArea][1] = Protect_Y[playerid];
            NarcoFarmPlayerInfo[playerid][dfpiArea][2] = Protect_Z[playerid] - 15.0;
            PlayerPlaySound(playerid, 6401);
            SendClientMessage(playerid, COLOR_GREY, " Встаньте в правую верхнюю точку фермы и нажмите Y");
        } else if (NarcoFarmPlayerInfo[playerid][dfpiArea][3] == 0.0 && NarcoFarmPlayerInfo[playerid][dfpiArea][4] == 0.0 && NarcoFarmPlayerInfo[playerid][dfpiArea][5] == 0.0)
        {
            NarcoFarmPlayerInfo[playerid][dfpiArea][3] = Protect_X[playerid];
            NarcoFarmPlayerInfo[playerid][dfpiArea][4] = Protect_Y[playerid];
            NarcoFarmPlayerInfo[playerid][dfpiArea][5] = Protect_Z[playerid] + 15.0;
            PlayerPlaySound(playerid, 6401);

            SuccessMessage(playerid, "{99ff66}Область успешно изменена!");
            NarcoFarmPlayerInfo[playerid][dfpiEditAreaMode] = false;
            
            NormalizeCoordinates3D(
                NarcoFarmPlayerInfo[playerid][dfpiArea][0], NarcoFarmPlayerInfo[playerid][dfpiArea][1],
                NarcoFarmPlayerInfo[playerid][dfpiArea][2], NarcoFarmPlayerInfo[playerid][dfpiArea][3],
                NarcoFarmPlayerInfo[playerid][dfpiArea][4], NarcoFarmPlayerInfo[playerid][dfpiArea][5],

                NarcoFarmInfo[farmid][dfiAreaPos][0], NarcoFarmInfo[farmid][dfiAreaPos][1], NarcoFarmInfo[farmid][dfiAreaPos][2],
                NarcoFarmInfo[farmid][dfiAreaPos][3], NarcoFarmInfo[farmid][dfiAreaPos][4], NarcoFarmInfo[farmid][dfiAreaPos][5]
            );
            NarcoFarmSave(farmid);

            AdminLog("editdrugfarmarea", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", farmid + 1, "Изменил область наркофермы");
        }
        return 1;
    }
    return 0;
}

DIALOG:edit_drugfarmarea(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "edit_drugfarm");

    new farmid = GetDialogContextInt(playerid, "farmid");
    if (!NarcoFarmIsExists(farmid)) {
        PlayerPlaySound(playerid, 31203);
        return ShowAdvancedDialogGen<show_drugfarms>(playerid);
    }

    NarcoFarmPlayerInfo[playerid][dfpiFarmID] = farmid;
    NarcoFarmPlayerInfo[playerid][dfpiEditAreaMode] = true;
    SendClientMessage(playerid, COLOR_GREY, " Встаньте в левую нижнюю точку фермы и нажмите Y");
    return 1;
}

DIALOG:edit_drugfarmseller(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "edit_drugfarm");

    new farmid = GetDialogContextInt(playerid, "farmid");
    if (!NarcoFarmIsExists(farmid)) {
        PlayerPlaySound(playerid, 31203);
        return ShowAdvancedDialogGen<show_drugfarms>(playerid);
    }

    NarcoFarmInfo[farmid][dfiSellerPos][0] = Protect_X[playerid];
    NarcoFarmInfo[farmid][dfiSellerPos][1] = Protect_Y[playerid];
    NarcoFarmInfo[farmid][dfiSellerPos][2] = Protect_Z[playerid];
    GetPlayerFacingAngle(playerid, NarcoFarmInfo[farmid][dfiSellerPos][3]);

    NarcoFarmCreateActors(farmid);
    NarcoFarmSave(farmid);

    SuccessMessage(playerid, "{99ff66}Продавец успешно перемещен!");
    AdminLog("editdrugfarmseller", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", farmid + 1, "Переместил продавца наркофермы");

    return 1;
}

DIALOG:edit_drugfarmpickup(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "edit_drugfarm");

    new farmid = GetDialogContextInt(playerid, "farmid");
    if (!NarcoFarmIsExists(farmid)) {
        PlayerPlaySound(playerid, 31203);
        return ShowAdvancedDialogGen<show_drugfarms>(playerid);
    }

    NarcoFarmInfo[farmid][dfiInfoPos][0] = Protect_X[playerid];
    NarcoFarmInfo[farmid][dfiInfoPos][1] = Protect_Y[playerid];
    NarcoFarmInfo[farmid][dfiInfoPos][2] = Protect_Z[playerid];

    NarcoFarmCreatePickup(farmid);
    NarcoFarmSave(farmid);
    
    SuccessMessage(playerid, "{99ff66}Пикап успешно перемещен!");
    AdminLog("editdrugfarmpickup", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", farmid + 1, "Переместил пикап наркофермы");

    return 1;
}

DIALOG_ITEMS:edit_drugfarmfraction(playerid, response, listitem, fractionid, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "edit_drugfarm");

    new farmid = GetDialogContextInt(playerid, "farmid");
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Указанной наркофермы не существует");

    NarcoFarmInfo[farmid][dfiFraction] = fractionid;
    NarcoFarmCreatePickup(farmid);
    NarcoFarmSave(farmid);

    ShowAdvancedDialog(playerid, "edit_drugfarm");
    AdminLog("editdrugfarmfraction", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", farmid + 1, "Изменил контролирующую организацию наркофермы");

    return 1;
}

DIALOG_GENERATOR:edit_drugfarmfraction(playerid)
{
    new farmid = GetDialogContextInt(playerid, "farmid");
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Указанной наркофермы не существует");

    FORMAT_SIZE:dialog_text(256, "{cccccc}Текущая организация: %s\n", frakName[NarcoFarmInfo[farmid][dfiFraction]]);
    for (new i = 0; i < MAX_ORG; i++)
    {
        if (!IsAMafiaID(i)) continue;

        format(dialog_text, sizeof(dialog_text), "%s%s\n", dialog_text, frakName[i]);
        AttachAdvancedDialogItemValue(playerid, "edit_drugfarmfraction", i);
    }

    return ShowAdvancedDialog(playerid, "edit_drugfarmfraction", DIALOG_STYLE_TABLIST_HEADERS, "{ff9000}Контролирующая организация", dialog_text, "Выбор", "Назад");
}

DIALOG:edit_drugfarmrentprice(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "edit_drugfarm");

    new farmid = GetDialogContextInt(playerid, "farmid");
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Указанной наркофермы не существует");

    new price;
    if (sscanf(inputtext, "d", price)) return ErrorMessage(playerid, "{FF6347}Некорректная стоимость аренды");
    if (price < 0 || price > 100000) return ErrorMessage(playerid, "{FF6347}Стоимость аренды: от $0 до $100.000");

    NarcoFarmInfo[farmid][dfiRentPrice] = price;
    for (new i = 0; i < MAX_NARCO_FARMS_BOOTHS; i++)
    {
        for (new j = 0; j < MAX_NARCO_FARMS_BUSHES; j++)
        {
            NarcoFarmUpdateBushLabel(farmid, i, j);
        }
    }

    NarcoFarmSave(farmid);

    SuccessMessage(playerid, "{99ff66}Стоимость аренды успешно изменена!");

    FORMAT:log("Изменил стоимость аренды на наркоферме ($%d)", price);
    AdminLog("editdrugfarmrentprice", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", farmid + 1, log);

    return 1;
}

DIALOG_GENERATOR:edit_drugfarmrentprice(playerid)
{
    new farmid = GetDialogContextInt(playerid, "farmid");
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Указанной наркофермы не существует");

    FORMAT:text("{cccccc}Текущая стоимость аренды: {99ff66}$%d\n\n{cccccc}Введите новую стоимость аренды:", NarcoFarmInfo[farmid][dfiRentPrice]);
    return ShowAdvancedDialog(playerid, "edit_drugfarmrentprice", DIALOG_STYLE_INPUT, "{ff9000}Изменение стоимости аренды", text, "Ок", "Назад");
}

DIALOG:edit_drugfarmboothmafia(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "edit_drugfarm");

    new farmid = GetDialogContextInt(playerid, "farmid");
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Указанной наркофермы не существует");

    new boothid;
    if (sscanf(inputtext, "d", boothid)) return ErrorMessage(playerid, "{FF6347}Некорректный номер будки");
    boothid--;
    if (!NarcoFarmIsBoothExists(farmid, boothid)) return ErrorMessage(playerid, "{FF6347}Указанной будки не существует");

    NarcoFarmInfo[farmid][dfiMafiaBoothId] = boothid;
    for (new i = 0; i < MAX_NARCO_FARMS_BOOTHS; i++)
    {
        for (new j = 0; j < MAX_NARCO_FARMS_BUSHES; j++)
        {
            NarcoFarmUpdateBushLabel(farmid, i, j);
        }
    }

    NarcoFarmSave(farmid);

    SuccessMessage(playerid, "{99ff66}Номер будки под нужды мафии успешно изменен!");

    FORMAT:log("Изменил номер будки под нужды мафии наркофермы (№%d)", boothid + 1);
    AdminLog("editdrugfarmboothmafia", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", farmid + 1, log);

    return 1;
}

DIALOG_GENERATOR:edit_drugfarmboothmafia(playerid)
{
    new farmid = GetDialogContextInt(playerid, "farmid");
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Указанной наркофермы не существует");

    FORMAT:text("{cccccc}Текущая будка: {99ff66}%d\n\n{cccccc}Введите номер будки:", NarcoFarmInfo[farmid][dfiMafiaBoothId] + 1);
    return ShowAdvancedDialog(playerid, "edit_drugfarmboothmafia", DIALOG_STYLE_INPUT, "{ff9000}Установка будки под нужды мафии", text, "Выбор", "Назад");
}

DIALOG:edit_drugfarmspawnarea(playerid, response, listitem, const inputtext[])
{
    new type = GetDialogContextInt(playerid, "spawn_area_type");
    if (!response) return ShowAdvancedDialog(playerid, "edit_drugfarm");

    new farmid = GetDialogContextInt(playerid, "farmid");
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Указанной наркофермы не существует");

    if (Protect_X[playerid] - NARCO_FARMS_SPAWN_RADIUS < NarcoFarmInfo[farmid][dfiAreaPos][0] || Protect_X[playerid] + NARCO_FARMS_SPAWN_RADIUS > NarcoFarmInfo[farmid][dfiAreaPos][3] ||
        Protect_Y[playerid] - NARCO_FARMS_SPAWN_RADIUS < NarcoFarmInfo[farmid][dfiAreaPos][1] || Protect_Y[playerid] + NARCO_FARMS_SPAWN_RADIUS > NarcoFarmInfo[farmid][dfiAreaPos][4])
    {
        return ErrorMessage(playerid, "{FF6347}Указанная область выходит за пределы фермы");
    }

    new Float: angle;
    GetPlayerFacingAngle(playerid, angle);

    switch(type)
    {
        case 0: { // Защитники
            NarcoFarmInfo[farmid][dfiSpawnDefendersPos][0] = Protect_X[playerid];
            NarcoFarmInfo[farmid][dfiSpawnDefendersPos][1] = Protect_Y[playerid];
            NarcoFarmInfo[farmid][dfiSpawnDefendersPos][2] = Protect_Z[playerid];
            NarcoFarmInfo[farmid][dfiSpawnDefendersPos][3] = angle;
            NarcoFarmSave(farmid);

            AdminLog("editdrugfarmspawnarea", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", farmid + 1, "Изменил область спавна защитников");
        }
        case 1: { // Атакующие
            NarcoFarmInfo[farmid][dfiSpawnAttackersPos][0] = Protect_X[playerid];
            NarcoFarmInfo[farmid][dfiSpawnAttackersPos][1] = Protect_Y[playerid];
            NarcoFarmInfo[farmid][dfiSpawnAttackersPos][2] = Protect_Z[playerid];
            NarcoFarmInfo[farmid][dfiSpawnAttackersPos][3] = angle;
            
            NarcoFarmSave(farmid);
            AdminLog("editdrugfarmspawnarea", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", farmid + 1, "Изменил область спавна атакующих");
        }
        default: return ErrorMessage(playerid, "{FF6347}Неизвестный тип области спавна");
    }

    SuccessMessage(playerid, "{99ff66}Область спавна успешно изменена!");

    return 1;
}

DIALOG:edit_drugfarm(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<show_drugfarms>(playerid);

    switch (listitem)
    {
        case 0: return ShowAdvancedDialog(playerid, "edit_drugfarmpickup", DIALOG_STYLE_MSGBOX, "{ff9000}Перемещение пикапа", "{cccccc}Вы уверены, что хотите переместить информационный пикап наркофермы в это место?", "Да", "Назад");
        case 1: return ShowAdvancedDialog(playerid, "edit_drugfarmarea", DIALOG_STYLE_MSGBOX, "{ff9000}Изменение области", "{cccccc}Вы уверены, что хотите изменить область наркофермы?", "Да", "Назад");
        case 2, 3: {
            if (listitem == 2) ShowAdvancedDialog(playerid, "edit_drugfarmspawnarea", DIALOG_STYLE_MSGBOX, "{ff9000}Изменение спавна защитников", "{cccccc}Вы уверены, что хотите изменить спавн защитников наркофермы?\n\n{ff6347}[!] {cccccc}Ваша текущая позиция будет взята за центр, старайтесь выбирать ровную поверхность\n{ff6347}[!] {cccccc}Позиция спавна будет рассчитываться случайным образом в диапазоне: {ff9000}(-6.0; 6.0)", "Да", "Назад");
            else if (listitem == 3) ShowAdvancedDialog(playerid, "edit_drugfarmspawnarea", DIALOG_STYLE_MSGBOX, "{ff9000}Изменение спавна атакующих", "{cccccc}Вы уверены, что хотите изменить спавн атакующих наркофермы?\n\n{ff6347}[!] {cccccc}Ваша текущая позиция будет взята за центр, старайтесь выбирать ровную поверхность\n{ff6347}[!] {cccccc}Позиция спавна будет рассчитываться случайным образом в диапазоне: {ff9000}(-6.0; 6.0)", "Да", "Назад");

            SetDialogContextInt(playerid, "spawn_area_type", listitem - 2);
        }
        case 4: return ShowAdvancedDialog(playerid, "edit_drugfarmseller", DIALOG_STYLE_MSGBOX, "{ff9000}Перемещение продавца", "{cccccc}Вы уверены, что хотите переместить продавца наркофермы в это место?", "Да", "Назад");
        case 5: return ShowAdvancedDialogGen<edit_drugfarmrentprice>(playerid);
        case 6: return ShowAdvancedDialogGen<edit_drugfarmboothmafia>(playerid);
        case 7: return ShowAdvancedDialogGen<edit_drugfarmfraction>(playerid);
    }

    return 1;
}

DIALOG_GENERATOR:edit_drugfarm(playerid, farmid)
{
    if (PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}Вам недоступна эта опция");
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Указанной наркофермы не существует");

    SetDialogContextInt(playerid, "farmid", farmid);

    new dialog_text[512];
    format(dialog_text, sizeof(dialog_text),
        "{cccccc}Переместить пикап\n" \
        "{cccccc}Задать область фермы\n" \
        "{cccccc}Задать спавн защитников\n" \
        "{cccccc}Задать спавн атакующих\n" \
        "{cccccc}Задать положение продавца\n" \
        "{cccccc}Задать стоимость аренды\t{99ff66}[ $%d ]\n" \
        "{cccccc}Задать номер будки под нужды мафии\t{ff9000}[ %d ]\n" \
        "{cccccc}Задать контролирующую организацию\t[ %s ]",

        NarcoFarmInfo[farmid][dfiRentPrice],
        NarcoFarmInfo[farmid][dfiMafiaBoothId] + 1,
        frakName[NarcoFarmInfo[farmid][dfiFraction]]
    );

    return ShowAdvancedDialog(playerid, "edit_drugfarm", DIALOG_STYLE_TABLIST, "{cccccc}Редактирование наркофермы", dialog_text, "Выбор", "Назад");
}

DIALOG:drugfarms_menu(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<show_drugfarms>(playerid);

    new farmid = GetDialogContextInt(playerid, "farmid");
    if (!NarcoFarmIsExists(farmid)) {
        PlayerPlaySound(playerid, 31203);
        return ShowAdvancedDialogGen<show_drugfarms>(playerid);
    }

    switch (listitem)
    {
        case 0: {
            FORMAT_SIZE:args(10, "%d", farmid + 1);
            return pc_cmd_gotodrugfarm(playerid, args);
        }
        case 1: return ShowAdvancedDialogGen<edit_drugfarm>(playerid, farmid);
    }

    return 1;
}

DIALOG_ITEMS:show_drugfarms(playerid, response, listitem, farmid, const inputtext[])
{
    if (!response) return 0;
    if (!NarcoFarmIsExists(farmid)) return 0;

    SetDialogContextInt(playerid, "farmid", farmid);

    new dialog_text[] = \
        "{cccccc}Телепортироваться к ферме\n" \
        "{cccccc}Редактировать ферму\n";

    return ShowAdvancedDialog(playerid, "drugfarms_menu", DIALOG_STYLE_LIST, "{ff9000}Наркоферма", dialog_text, "Выбор", "Назад");
}

DIALOG_GENERATOR:show_drugfarms(playerid)
{
    if (PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}Вам недоступна эта команда");

    new dialog_text[4096] = "{ff9000}Ферма\t{cccccc}Контролирующая организация\n";
    
    for (new i = 0; i < MAX_NARCO_FARMS; i++)
    {
        if (!NarcoFarmIsExists(i)) continue;

        format(dialog_text, sizeof(dialog_text), "%s{ff9000}Ферма №%d.\t{cccccc}%s\n", dialog_text,
            NarcoFarmInfo[i][dfiID], frakName[NarcoFarmInfo[i][dfiFraction]]
        );

        AttachAdvancedDialogItemValue(playerid, "show_drugfarms", i);
    }
    return ShowAdvancedDialog(playerid, "show_drugfarms", DIALOG_STYLE_TABLIST_HEADERS, "{ff9000}Наркофермы", dialog_text, "Выбор", "Закрыть", true);
}

alias:drugfarms("narcofarms")
CMD:drugfarms(playerid)
{
    return ShowAdvancedDialogGen<show_drugfarms>(playerid);
}

alias:gotodrugfarm("gotonarcofarm")
CMD:gotodrugfarm(playerid, const params[])
{
    if (PlayerInfo[playerid][pSoska] < 1) return ErrorMessage(playerid, "{FF6347}Вам недоступна эта команда");

    new farmid;
    if (sscanf(params, "d", farmid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Телепортироваться к наркоферме [ /gotodrugfarm ID ]");
    farmid--;
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Указанной наркофермы не существует");

    PPSetPlayerPos(playerid, NarcoFarmInfo[farmid][dfiInfoPos][0], NarcoFarmInfo[farmid][dfiInfoPos][1], NarcoFarmInfo[farmid][dfiInfoPos][2]);
    S_SetPlayerVirtualWorld(playerid, 0, 0);
    PPSetPlayerInterior(playerid, 0);

    return 1;
}

alias:editdrugfarm("editnarcofarm")
CMD:editdrugfarm(playerid, const params[])
{
    if (PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}Вам недоступна эта команда");

    new farmid;
    if (sscanf(params, "d", farmid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Редактировать наркоферму [ /editdrugfarm ID ]");
    farmid--;
    if (!NarcoFarmIsExists(farmid)) return ErrorMessage(playerid, "{FF6347}Указанной наркофермы не существует");
    return ShowAdvancedDialogGen<edit_drugfarm>(playerid, farmid);
}

stock NarcoFarmGetNearest(playerid)
{
    for (new i = 0; i < MAX_NARCO_FARMS; i++)
    {
        if (!NarcoFarmIsExists(i)) continue;
        
        if (IsPlayerInCube(playerid, NarcoFarmInfo[i][dfiAreaPos][0], NarcoFarmInfo[i][dfiAreaPos][1], NarcoFarmInfo[i][dfiAreaPos][2], NarcoFarmInfo[i][dfiAreaPos][3], NarcoFarmInfo[i][dfiAreaPos][4], NarcoFarmInfo[i][dfiAreaPos][5]))
        {
            return i;
        }
    }

    return INVALID_NARCOFARM_ID;
}

stock NarcoFarmIsInside(playerid, id = INVALID_NARCOFARM_ID)
{
    if (id != INVALID_NARCOFARM_ID)
    {
        return NarcoFarmGetNearest(playerid) == id;
    }
    return NarcoFarmGetNearest(playerid) != INVALID_NARCOFARM_ID;
}

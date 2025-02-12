function NarcoSpotLoad()
{
    new rows;
    cache_get_row_count(rows);

    rows = min(rows, MAX_NARCO_SPOTS);

    for (new i = 0; i < rows; i++)
    {
        new id;
        cache_get_value_name_int(i, "id", id);

        SQL_LOAD_ENUM(NarcoSpotInfo[id], SQL_GET_ENUM_DEFINE(NarcoSpotInfo), i);

        NarcoSpotCreatePickup(id);
        NarcoSpot_SetFraction(id, NarcoSpotInfo[id][nstFraction]);
    }

    // Притон
    {
        new worlds[500] = {NARCO_SPOT_HANGOUT_VIRTUAL_WORLD, NARCO_SPOT_HANGOUT_VIRTUAL_WORLD + 1, ...};
        NarcoHangoutZone = CreateDynamicSphereEx(1001.473144, 219.459396, 152.021652, 100.0, worlds);
        
        CreateDynamic3DTextLabel("Распорядитель {cccccc}[ ALT ]", 0xFF9000FF, 1006.3000, 226.0471, 152.5605, 5.0, .areaid = NarcoHangoutZone);

        CreateDynamic3DTextLabelEx("{32cd32}Почва для посадки\n{cccccc}[ ALT ]", 0xFFFFFFFF, 997.459899, 232.581756, 153.160415, 5.0, .worlds = worlds, .testlos = 1);
        CreateDynamic3DTextLabelEx("{00bfff}Вода для полива\n{cccccc}[ ALT ]", 0xFFFFFFFF, 999.700744, 219.648529, 153.160415, 5.0, .worlds = worlds);
        CreateDynamic3DTextLabelEx("{ff9000}Упаковочный стол\n{cccccc}[ ALT ]", 0xFFFFFFFF, 1000.942077, 236.837295, 152.709655, 5.0, .worlds = worlds);
        CreateDynamic3DTextLabelEx("{ff9000}Семена\n{cccccc}[ ALT ]", 0xFFFFFFFF, 999.440917, 236.873001, 152.709655, 5.0, .worlds = worlds);
    }

    // Лаборатория
    {
        new worlds[500] = {NARCO_SPOT_LABORATORY_VIRTUAL_WORLD, NARCO_SPOT_LABORATORY_VIRTUAL_WORLD + 1, ...};
        NarcoLaboratoryZone = CreateDynamicSphereEx(1001.473144, 219.459396, 152.021652, 100.0, worlds);

        CreateDynamic3DTextLabel("Распорядитель {cccccc}[ ALT ]", 0xFF9000FF, 1003.4462, 237.1849, 152.5605, 5.0, .areaid = NarcoLaboratoryZone);
            
        // Химический завод
        new actorid = INVALID_STREAMER_ID;
        actorid = CreateDynamicActor(482, 1787.3120, -1135.6371, 24.1105, 180.0000);
        ApplyDynamicActorAnimation(actorid, "SMOKING", "M_smklean_loop", 4.1, 1, 0, 0, 0, 0);
        CreateDynamic3DTextLabel("Карл\n{cccccc}[ ALT ]", 0xFF9000FF, 1787.3120, -1135.6371, 24.1105, 5.0);
    
        CreateDynamic3DTextLabel("{ff9000}Упаковочный стол\n{cccccc}[ ALT ]", 0xFFFFFFFF, 1003.108398, 227.879394, 152.998031, 5.0, .areaid = NarcoLaboratoryZone);
        CreateDynamic3DTextLabel("{ff9000}Упаковочный стол\n{cccccc}[ ALT ]", 0xFFFFFFFF, 1001.574890, 228.901046, 152.958633, 5.0, .areaid = NarcoLaboratoryZone);

        CreateDynamicActor(548, 1823.6509, -1143.8195, 24.0699, 340.0744); // 
        actorid = CreateDynamicActor(547, 1804.5881, -1144.5884, 24.0964, 106.4283); // anim
        ApplyDynamicActorAnimation(actorid, "GANGS", "prtial_gngtlkA", 2.1, true, false, false, true, false);
        actorid = CreateDynamicActor(611, 1803.0139, -1145.2358, 24.0936, 296.8114); // anim
        ApplyDynamicActorAnimation(actorid, "GANGS", "prtial_gngtlkB", 2.1, true, false, false, true, false);
        CreateDynamicActor(612, 1776.6809, -1140.6602, 24.1105, 228.2767); // 
        actorid = CreateDynamicActor(613, 1780.9003, -1135.8295, 24.1105, 104.4465); // anim
        ApplyDynamicActorAnimation(actorid, "GANGS", "prtial_gngtlkB", 2.1, true, false, false, true, false);
        actorid = CreateDynamicActor(548, 1779.1869, -1136.3232, 24.1105, 282.9622); // anim
        ApplyDynamicActorAnimation(actorid, "GANGS", "prtial_gngtlkA", 2.1, true, false, false, true, false);
    }

    // Загрузка мест игроков
    mysql_tquery(pearsq, "SELECT * FROM `pp_places_narco_spots`", "NarcoPlacesLoad");

    return 1;
}

function NarcoSpotSave(id)
{
    if (NarcoSpotIsExists(id))
    {
        new where[12];
        mysql_format(pearsq, where, sizeof(where), "id = %d", id);

        SQL_SAVE_ENUM_IF_NOT_EXISTS(pearsq, "pp_narco_spots", NarcoSpotInfo[id], SQL_GET_ENUM_DEFINE(NarcoSpotInfo), where, where);
    } else {
        new f_str[128];
        mysql_format(pearsq, f_str, sizeof(f_str), "DELETE FROM `pp_narco_spots` WHERE id = %d", id);
        mysql_tquery(pearsq, f_str);
    }
    
    return 1;
}

stock NarcoSpotPreparePlaces(spotid)
{
    for (new j = 0; j < MAX_NARCO_PLACES; j++) {
        if (!IsValidDynamicObject(NarcoPlaceObjects[spotid][j])) continue;

        DestroyDynamicObject(NarcoPlaceObjects[spotid][j]);
        NarcoPlaceObjects[spotid][j] = INVALID_STREAMER_ID;
    }

    // Помещаем все стандартные объекты (из маппинга) в их виртуальный мир, чтобы при необходимости получать их местоположения
    const MAPSTANDARD_PLACES_VIRTUAL_WORLD = 1000;
    static bool: prepare_map = false;
    if (!prepare_map)
    {
        new objects[1000];
        new count = Streamer_GetNearbyItems(1002.243591, 236.230087, 154.729995, STREAMER_TYPE_OBJECT, objects, .range = 200.0);
        for (new i = 0; i < min(sizeof(objects), count); i++)
        {
            new objectid = objects[i];
            if (!IsValidDynamicObject(objectid)) break;
            if (GetDynamicObjectModel(objectid) != 950 && GetDynamicObjectModel(objectid) != 19894) continue;

            new Float: x, Float: y, Float: z;
            GetDynamicObjectPos(objectid, x, y, z);
            if (GetDynamicObjectModel(objectid) == 950)
            {
                if (!IsPointInCube(x, y, z, 1001.010986, 220.619674, 150.886764, 1003.443603, 236.303939, 155.497299)) continue;
            }

            SetDynamicObjectVirtualWorld(objectid, MAPSTANDARD_PLACES_VIRTUAL_WORLD);
        }
        prepare_map = true;
    }

    switch (NarcoSpotInfo[spotid][nstType])
    {
        case NARCO_SPOT_HANGOUT:
        {
            // Горшки
            new near_objects[400];
            new count = Streamer_GetNearbyItems(1002.243591, 236.230087, 154.729995, STREAMER_TYPE_OBJECT, near_objects, .range = 100.0, .worldid = MAPSTANDARD_PLACES_VIRTUAL_WORLD);
            for (new i = 0; i < min(sizeof(near_objects), count); i++)
            {
                new objectid = near_objects[i];
                if (!IsValidDynamicObject(objectid)) break;
                if (GetDynamicObjectModel(objectid) != 950) continue;

                new Float: x, Float: y, Float: z;
                GetDynamicObjectPos(objectid, x, y, z);
                new Float: rx, Float: ry, Float: rz;
                GetDynamicObjectRot(objectid, rx, ry, rz);

                for (new j = 0; j < MAX_NARCO_PLACES; j++)
                {
                    if (NarcoPlaceObjects[spotid][j] == 0)
                    {
                        NarcoPlaceObjects[spotid][j] = CreateDynamicObject(950, x, y, z, rx, ry, rz, NarcoSpot_GetVirtualWorld(spotid));
                        NarcoSpotPlacePlant(spotid, j, false);
                        NarcoSpot_WaitForRent(spotid, j);

                        break;
                    }
                }

                SetDynamicObjectVirtualWorld(objectid, MAPSTANDARD_PLACES_VIRTUAL_WORLD);
            }
        }
        case NARCO_SPOT_LABORATORY:
        {
            // Рабочие места
            static const Float: points[][] = {
                {999.1901, 233.0160, 152.5605},
                {1005.5564, 224.3414, 152.5605}
            };
            for (new j, pointid = 0; pointid < sizeof(points); pointid++)
            {
                new near_objects[400];
                new count = Streamer_GetNearbyItems(points[pointid][0], points[pointid][1], points[pointid][2], STREAMER_TYPE_OBJECT, near_objects, .range = 8.0, .worldid = MAPSTANDARD_PLACES_VIRTUAL_WORLD);
                for (new i = 0; i < min(sizeof(near_objects), count); i++)
                {
                    new objectid = near_objects[i];
                    if (!IsValidDynamicObject(objectid)) break;
                    if (GetDynamicObjectModel(objectid) != 19894) continue;

                    new Float: x, Float: y, Float: z;
                    GetDynamicObjectPos(objectid, x, y, z);
                    new Float: rx, Float: ry, Float: rz;
                    GetDynamicObjectRot(objectid, rx, ry, rz);

                    NarcoPlaceObjects[spotid][j] = CreateDynamicObject(19894, x, y, z, rx, ry, rz, NarcoSpot_GetVirtualWorld(spotid));
                    SetDynamicObjectMaterial(NarcoPlaceObjects[spotid][j], 0, 5123, "chemgrnd_las2", "Was_side", 0xFF1E90FF);
                    NarcoSpotPlacePlant(spotid, j, false);
                    NarcoSpot_WaitForRent(spotid, j);
                    j++;

                    SetDynamicObjectVirtualWorld(objectid, MAPSTANDARD_PLACES_VIRTUAL_WORLD);
                }
            }

            // Взрывы для рабочих мест
            for (new i = 0; i < sizeof(NarcoPlaceObjects[]); i++)
            {
                new objectid = NarcoPlaceObjects[spotid][i];
                if (!IsValidDynamicObject(objectid)) continue;

                new Float: x, Float: y, Float: z;
                GetDynamicObjectPos(objectid, x, y, z);
                
                NarcoPlaceExplodeObjects[spotid][i][0] = CreateDynamicObject(18686, x - 0.01001, y, z - 1.182, 0.0, 0.0, 0.0, 228); // Explosion
                NarcoPlaceExplodeObjects[spotid][i][1] = CreateDynamicObject(18688, x - 0.01001, y, z - 1.682, 0.0, 0.0, 0.0, 228); // Fire
            }
        }
    }

    return 1;
}

function NarcoPlacesLoad()
{
    new rows;
    cache_get_row_count(rows);

    for (new i = 0; i < rows; i++)
    {
        new spotid, id;
        cache_get_value_name_int(i, "id", id);
        cache_get_value_name_int(i, "spot_id", spotid);

        SQL_LOAD_ENUM(NarcoPlaceInfo[spotid][id], SQL_GET_ENUM_DEFINE(NarcoPlaceInfo), i);
    }

    for (new spotid = 0; spotid < MAX_NARCO_SPOTS; spotid++) {
        // Приготавливаем места (размечаем их местоположение и прочее)
        NarcoSpotPreparePlaces(spotid);
        
        // Ставим лейблы/объекты и все остальное
        for (new placeid = 0; placeid < MAX_NARCO_PLACES; placeid++) {
            if (NarcoSpotIsPlaceFree(spotid, placeid)) continue;

            NarcoSpot_PrepareIngredients(spotid, placeid);
            NarcoSpot_UpdatePlaceLabel(spotid, placeid);

            if (NarcoSpotInfo[spotid][nstType] != NARCO_SPOT_LABORATORY || NarcoPlaceInfo[spotid][placeid][npdRiped])
            {
               NarcoSpotPlacePlant(spotid, placeid, true);
            }
        }
    }

    return 1;
}

function NarcoSpotPlayer_UpdateInfectLevel(playerid)
{
    if (!IsOnline(playerid)) return 0;
    if (!NarcoSpotPlayer_IsInside(playerid, NARCO_SPOT_LABORATORY)) {
        NarcoSpotPlayerInfo[playerid][nspLaboratoryExitTime] = gettime();
        return NarcoSpotPlayer_ShowInfectLevel(playerid, false);
    }
    if (!NarcoSpotPlayerInfo[playerid][nspLaboratoryCutScene]) return NarcoSpotPlayer_ShowInfectLevel(playerid, false);

    new Float: damage = 0.0;
    switch (GetPlayerInfectProtectionType(playerid))
    {
        case INFECT_PROTECTION_NONE, INFECT_PROTECTION_SUPER_LOW, INFECT_PROTECTION_VERY_LOW, INFECT_PROTECTION_LOW: damage += 10.0;
        case INFECT_PROTECTION_MEDIUM: damage += 1.0;
        case INFECT_PROTECTION_HIGH: damage += 0.05;
        case INFECT_PROTECTION_VERY_HIGH: damage += 0.025;
        case INFECT_PROTECTION_EXTREME: damage += 0.01;
        default: damage -= 10.0;
    }
    NarcoSpotPlayerInfo[playerid][nspInfectLevel] += damage;
    
    // [0-100%]
    if (NarcoSpotPlayerInfo[playerid][nspInfectLevel] > 100.0) {
        NarcoSpotPlayerInfo[playerid][nspInfectLevel] = 100.0;
    } else if (NarcoSpotPlayerInfo[playerid][nspInfectLevel] < 0.0) {
        NarcoSpotPlayerInfo[playerid][nspInfectLevel] = 0.0;
    }

    if (IsPlayerTextDrawVisible(playerid, LaboratoryInfect_PTD[playerid][1]))
    {
        if (NarcoSpotPlayerInfo[playerid][nspInfectLevel] <= 0) {
            NarcoSpotPlayer_ShowInfectLevel(playerid, false);
        } else {
            new Float: sizex, Float: sizey;
            PlayerTextDrawGetTextSize(playerid, LaboratoryInfect_PTD[playerid][1], sizex, sizey);
            PlayerTextDrawTextSize(playerid, LaboratoryInfect_PTD[playerid][1], NarcoSpotPlayerInfo[playerid][nspInfectLevel], sizey);
            PlayerTextDrawShow(playerid, LaboratoryInfect_PTD[playerid][1]);

            FORMAT:string("%.0f%%", NarcoSpotPlayerInfo[playerid][nspInfectLevel]);
            PlayerTextDrawSetString(playerid, LaboratoryInfect_PTD[playerid][2], string);

            const DEATH_REASON_INFECTED = 60;
            if (NarcoSpotPlayerInfo[playerid][nspInfectLevel] >= 100.0 && !DeathInfo[playerid][deathStatus])
            {
                if (DeathInfo[playerid][deathReason] != DEATH_REASON_INFECTED)
                {
                    // Смерть от заражения
                    ACSetPlayerHealth(playerid, 0.0);
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Что-то мне совсем хреново.. Нужно было позаботиться о защитном костюме");
                    DeathInfo[playerid][deathReason] = DEATH_REASON_INFECTED;
                }
                else
                {
                    // Сбрасываем уровень заражения, если нас воскресили в течение 15 секунд
                    NarcoSpotPlayerInfo[playerid][nspInfectLevel] = 0.0;
                    DeathInfo[playerid][deathReason] = 0;
                    return NarcoSpotPlayer_ShowInfectLevel(playerid, true);
                }
            }
        }
    } else if (NarcoSpotPlayerInfo[playerid][nspInfectLevel] > 0) {
        return NarcoSpotPlayer_ShowInfectLevel(playerid, true);
    }

    return SetTimerEx("NarcoSpotPlayer_UpdateInfectLevel", 800, false, "d", playerid);
}

stock NarcoSpotPlayer_ShowInfectLevel(playerid, bool: status)
{
    for (new i = 0; i < sizeof(LaboratoryInfect_PTD[]); i++)
    {
        PlayerTextDrawDestroy(playerid, LaboratoryInfect_PTD[playerid][i]);
        LaboratoryInfect_PTD[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
    }

    if (status && NarcoSpotPlayer_GetType(playerid) == _:NARCO_SPOT_LABORATORY)
    {
        LaboratoryInfect_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 267.6665, 427.5335, "LD_SPAC:white"); // blackbox
        PlayerTextDrawLetterSize(playerid, LaboratoryInfect_PTD[playerid][0], -0.0003, 0.0000);
        PlayerTextDrawTextSize(playerid, LaboratoryInfect_PTD[playerid][0], 103.0000, 14.0000);
        PlayerTextDrawAlignment(playerid, LaboratoryInfect_PTD[playerid][0], TEXT_DRAW_ALIGN_LEFT);
        PlayerTextDrawColour(playerid, LaboratoryInfect_PTD[playerid][0], 255);
        PlayerTextDrawBackgroundColour(playerid, LaboratoryInfect_PTD[playerid][0], 255);
        PlayerTextDrawFont(playerid, LaboratoryInfect_PTD[playerid][0], TEXT_DRAW_FONT_SPRITE_DRAW);
        PlayerTextDrawSetProportional(playerid, LaboratoryInfect_PTD[playerid][0], false);
        PlayerTextDrawSetShadow(playerid, LaboratoryInfect_PTD[playerid][0], false);

        LaboratoryInfect_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 269.0999, 429.3076, "LD_SPAC:white"); // fill
        PlayerTextDrawLetterSize(playerid, LaboratoryInfect_PTD[playerid][1], -0.0003, 0.0000);
        PlayerTextDrawTextSize(playerid, LaboratoryInfect_PTD[playerid][1], 0.0000, 10.0000); // 100.0 - max
        PlayerTextDrawAlignment(playerid, LaboratoryInfect_PTD[playerid][1], TEXT_DRAW_ALIGN_LEFT);
        PlayerTextDrawColour(playerid, LaboratoryInfect_PTD[playerid][1], 10520831);
        PlayerTextDrawBackgroundColour(playerid, LaboratoryInfect_PTD[playerid][1], 255);
        PlayerTextDrawFont(playerid, LaboratoryInfect_PTD[playerid][1], TEXT_DRAW_FONT_SPRITE_DRAW);
        PlayerTextDrawSetProportional(playerid, LaboratoryInfect_PTD[playerid][1], false);
        PlayerTextDrawSetShadow(playerid, LaboratoryInfect_PTD[playerid][1], false);

        LaboratoryInfect_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 369.0334, 430.4775, "10%"); // пусто
        PlayerTextDrawLetterSize(playerid, LaboratoryInfect_PTD[playerid][2], 0.1916, 0.8118);
        PlayerTextDrawTextSize(playerid, LaboratoryInfect_PTD[playerid][2], -8.0000, 0.0000);
        PlayerTextDrawAlignment(playerid, LaboratoryInfect_PTD[playerid][2], TEXT_DRAW_ALIGN_RIGHT);
        PlayerTextDrawColour(playerid, LaboratoryInfect_PTD[playerid][2], -1);
        PlayerTextDrawBackgroundColour(playerid, LaboratoryInfect_PTD[playerid][2], 255);
        PlayerTextDrawFont(playerid, LaboratoryInfect_PTD[playerid][2], TEXT_DRAW_FONT_1);
        PlayerTextDrawSetProportional(playerid, LaboratoryInfect_PTD[playerid][2], true);
        PlayerTextDrawSetShadow(playerid, LaboratoryInfect_PTD[playerid][2], false);

        for (new i = 0; i < sizeof(LaboratoryInfect_PTD[]); i++)
        {
            PlayerTextDrawShow(playerid, LaboratoryInfect_PTD[playerid][i]);
        }

        // Выветривание
        if (NarcoSpotPlayerInfo[playerid][nspInfectLevel] > 0)
        {
            if (NarcoSpotPlayerInfo[playerid][nspLaboratoryExitTime] > 0)
            {
                new diff = gettime() - NarcoSpotPlayerInfo[playerid][nspLaboratoryExitTime];
                NarcoSpotPlayerInfo[playerid][nspInfectLevel] -= 5.0 * diff;
                if (NarcoSpotPlayerInfo[playerid][nspInfectLevel] < 0.0) NarcoSpotPlayerInfo[playerid][nspInfectLevel] = 0.0;
            }
        }
        NarcoSpotPlayer_UpdateInfectLevel(playerid);

        if (_:GetPlayerInfectProtectionType(playerid) <= _:INFECT_PROTECTION_VERY_HIGH)
        {
            if(!PlayerInfo[playerid][pDrawLanguage] && Device[playerid] != 1) SendMindMessage(playerid, RusToGame("Что-то мне плохо.."), RusToGame("[Требуется защитный костюм]"));
            else SendMindMessage(playerid, "I feel bad..", "[Protect uniform is needed]");
        }
    }
    return 1;
}

stock NarcoPlaceShow(spotid, bool: status = true)
{
    if (!NarcoSpotIsExists(spotid)) return 0;

    new bool: show = NarcoSpotInfo[spotid][nstType] == NARCO_SPOT_HANGOUT && status;
    for (new i = 0; i < MAX_NARCO_PLACES; i++)
    {
        if (NarcoPlaceObjects[spotid][i] == 0) continue;
        SetDynamicObjectVirtualWorld(NarcoPlaceObjects[spotid][i], show ? NarcoSpot_GetVirtualWorld(spotid) : 228);
    }

    return 1;
}

stock NarcoSpotPlaceSave(spotid, placeid)
{
    FORMAT:where("spot_id = %d AND id = %d", spotid, placeid);
    FORMAT:init("spot_id = %d, id = %d", spotid, placeid);

    NarcoPlaceInfo[spotid][placeid][npdId] = placeid;
    NarcoPlaceInfo[spotid][placeid][npdSpotId] = spotid;

    if (NarcoPlaceInfo[spotid][placeid][npdRentTime] == 0 && NarcoPlaceInfo[spotid][placeid][npdWaterTime] == 0)
    {
        new f_str[128];
        mysql_format(pearsq, f_str, sizeof(f_str), "DELETE FROM `pp_places_narco_spots` WHERE spot_id = %d AND id = %d", spotid, placeid);
        mysql_tquery(pearsq, f_str);
    } else {
        SQL_SAVE_ENUM_IF_NOT_EXISTS(pearsq, "pp_places_narco_spots", NarcoPlaceInfo[spotid][placeid], SQL_GET_ENUM_DEFINE(NarcoPlaceInfo), where, init);
    }

    return 1;
}

function NarcoSpotPlayerLoad(playerid)
{
    NarcoSpotPlayerInfo[playerid][nspID] = PlayerInfo[playerid][pID];

    new rows;
    cache_get_row_count(rows);
    if (rows == 0) return 0;

    SQL_LOAD_ENUM(NarcoSpotPlayerInfo[playerid], SQL_GET_ENUM_DEFINE(NarcoSpotPlayerInfo), 0);

    // Сбрасываем текущее действие, если горшок свободен или теперь принадлежит другому игроку
    new spotid = NarcoSpotPlayerInfo[playerid][nspSpotId],
        potid = NarcoSpotPlayerInfo[playerid][nspPlaceId];
    if (NarcoSpotIsExists(spotid) && potid != NARCO_SPOT_INVALID_ID)
    {
        if (NarcoPlaceInfo[spotid][potid][npdPlayer] != PlayerInfo[playerid][pID])
        {
            NarcoSpotPlayerInfo[playerid][nspCurrentAction] = NARCO_PLAYER_ACTION_NONE;
            NarcoSpotPlayerInfo[playerid][nspPlaceId] = NARCO_SPOT_INVALID_ID;
        }
    }

    return 1;
}

function NarcoSpotPlace_WaitForConnect(user_id)
{
    foreach (new playerid : Player)
    {
        if (PlayerInfo[playerid][pID] == user_id) return 0;
    }

    new user_pots = 0;
    for (new i = 0; i < MAX_NARCO_SPOTS; i++)
    {
        for (new j = 0; j < MAX_NARCO_PLACES; j++)
        {
            if (NarcoPlaceInfo[i][j][npdPlayer] == user_id)
            {
                user_pots++;
                if (gettime() - NarcoPlaceInfo[i][j][npdPlayerExitTime] >= NARCO_DISCONNECT_RENTTIME)
                {
                    NarcoSpotPlaceFree(i, j);
                    user_pots--;
                }
            }
        }
    }
    if (user_pots < 1) return 0;

    return SetTimerEx("NarcoSpotPlace_WaitForConnect", 10000, false, "d", user_id);
}

stock NarcoSpot_OnPlayerDisconnect(playerid)
{
    NarcoSpotPlayerSave(playerid);

    new unix = gettime();
    for (new i = 0; i < MAX_NARCO_SPOTS; i++)
    {
        for (new j = 0; j < MAX_NARCO_PLACES; j++)
        {
            if (NarcoPlaceInfo[i][j][npdPlayer] != PlayerInfo[playerid][pID]) continue;

            NarcoPlaceInfo[i][j][npdPlayerExitTime] = unix;
        }
    }
    SetTimerEx("NarcoSpotPlace_WaitForConnect", 1000, false, "d", PlayerInfo[playerid][pID]);
    return 1;
}

stock NarcoSpotPlayerSave(playerid)
{
    new where[16];
    mysql_format(pearsq, where, sizeof(where), "user_id = %d", PlayerInfo[playerid][pID]);

    SQL_SAVE_ENUM_IF_NOT_EXISTS(pearsq, "pp_user_narco_spots", NarcoSpotPlayerInfo[playerid], SQL_GET_ENUM_DEFINE(NarcoSpotPlayerInfo), where, where);

    return 1;
}

stock NarcoSpotIsPlaceFree(id, i)
{
    return NarcoPlaceInfo[id][i][npdPlayer] == 0 && NarcoPlaceInfo[id][i][npdRentTime] == 0;
}

stock NarcoSpotPlacePlant(spotid, placeid, bool: status = true)
{
    new modelid = GetDynamicObjectModel(NarcoPlaceObjects[spotid][placeid]);
    
    if (modelid == 950)
    {
        for (new i = 1; i <= 2; i++)
        {
            if (!IsDynamicObjectMaterialUsed(NarcoPlaceObjects[spotid][placeid], i)) continue;
            RemoveDynamicObjectMaterial(NarcoPlaceObjects[spotid][placeid], i);
        }

        if (status)
        {
            SetDynamicObjectMaterial(NarcoPlaceObjects[spotid][placeid], 1, 1731, "cj_lighting", "cj_plantpot", 0x00000000);
            SetDynamicObjectMaterial(NarcoPlaceObjects[spotid][placeid], 2, 3261, "grasshouse", "veg_marijuana", 0x00000000);
        } else {
            SetDynamicObjectMaterial(NarcoPlaceObjects[spotid][placeid], 1, 1731, "cj_lighting", "cj_plantpot", 0x00000000);
            SetDynamicObjectMaterial(NarcoPlaceObjects[spotid][placeid], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
        }
    }
    else if (modelid == 19894)
    {
        SetDynamicObjectVirtualWorld(NarcoPlaceObjects[spotid][placeid], status ? NarcoSpot_GetVirtualWorld(spotid) : 228);
    }

    foreach (new playerid : Player)
    {
        new Float: distance;
        Streamer_GetDistanceToItem(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid], STREAMER_TYPE_OBJECT, NarcoPlaceObjects[spotid][placeid], distance);
        if (distance <= 50.0) Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
    }

    return 1;
}

stock NarcoSpotPlaceFree(id, placeid, bool: clear = true)
{
    if (placeid < 0) return 0;

    switch (NarcoSpotInfo[id][nstType])
    {
        case NARCO_SPOT_HANGOUT: {
            if (placeid >= MAX_NARCO_PLACES) return 0;

             // Делаем горшок пустым
            NarcoSpot_DestroyPlaceLabel(id, placeid);
            NarcoSpotPlacePlant(id, placeid, false);
        }
        case NARCO_SPOT_LABORATORY: {
            if (placeid >= LABORATORY_PLACES) return 0;

            // Делаем место пустым
            NarcoSpot_DestroyPlaceLabel(id, placeid);
            NarcoSpotPlacePlant(id, placeid, false);
        }
    }

    if (clear)
    {
        foreach (new playerid : Player)
        {
            if (NarcoPlaceInfo[id][placeid][npdPlayer] == PlayerInfo[id][pID])
            {
                if (NarcoSpotPlayerInfo[playerid][nspSpotId] == id && NarcoSpotPlayerInfo[playerid][nspPlaceId] == placeid)
                {
                    NarcoSpotPlayerInfo[playerid][nspCurrentAction] = NARCO_PLAYER_ACTION_NONE;
                    NarcoSpotPlayerInfo[playerid][nspPlaceId] = NARCO_SPOT_INVALID_ID;
                }
                break;
            }
        }

        for (new e_NarcoPlaceInfo: i; i < e_NarcoPlaceInfo; i++)
        {
            NarcoPlaceInfo[id][placeid][i] = 0;
        }

        NarcoSpotPlaceSave(id, placeid);
    }
    
    return 1;
}

stock NarcoSpotPlayer_ChangeActiveSpot(playerid)
{
    new id = NarcoSpotPlayer_GetId(playerid);

    if (!NarcoSpotIsExists(id)) return 0;
    if (id == NarcoSpotPlayerInfo[playerid][nspSpotId]) return 0;

    NarcoSpotPlayerInfo[playerid][nspCurrentAction] = NARCO_PLAYER_ACTION_NONE;
    NarcoSpotPlayerInfo[playerid][nspSpotId] = id;
    return 1;
}

stock NarcoSpotPlayer_SetCurrentAction(playerid, e_NarcoSpotPlayerAction: action)
{
    NarcoSpotPlayer_ChangeActiveSpot(playerid);
    NarcoSpotPlayerInfo[playerid][nspCurrentAction] = action;

    return 1;
}

stock NarcoSpotPlayer_MarkPlace(playerid, placeid)
{
    if (!NarcoSpotPlayer_IsInside(playerid)) return 0;
    
    switch (NarcoSpotPlayer_GetType(playerid))
    {
        case NARCO_SPOT_HANGOUT: CreateGps(playerid, NarcoHangoutPlacesMarks[placeid][0], NarcoHangoutPlacesMarks[placeid][1], NarcoHangoutPlacesMarks[placeid][2], .radius = NARCO_MARKS_SIZE);
        case NARCO_SPOT_LABORATORY: CreateGps(playerid, NarcoLaboratoryPlacesMarks[placeid][0], NarcoLaboratoryPlacesMarks[placeid][1], NarcoLaboratoryPlacesMarks[placeid][2], .radius = NARCO_MARKS_SIZE);
    }
    return 1;
}

stock NarcoSpotPlayer_GetPlacesAmount(playerid, e_NarcoSpotType: type, spotid = NARCO_SPOT_INVALID_ID, bool: only_free = false)
{
    new count = 0;
    
    new minid = spotid == NARCO_SPOT_INVALID_ID ? 0 : spotid;
    new maxid = spotid == NARCO_SPOT_INVALID_ID ? MAX_NARCO_SPOTS : spotid + 1;

    for (new i = minid; i < maxid; i++)
    {
        if (NarcoSpotInfo[i][nstType] != type) continue;

        for (new j = 0; j < MAX_NARCO_PLACES; j++)
        {
            if (NarcoPlaceInfo[i][j][npdPlayer] == PlayerInfo[playerid][pID])
            {
                if (!only_free || NarcoPlaceInfo[i][j][npdWaterTime] == 0)
                {
                    count++;
                }
            }
        }
    }

    return count;
}

stock NarcoSpotPlayer_GetMaxPlaces(playerid)
{
    new type = NarcoSpotPlayer_GetType(playerid);
    switch (type)
    {
        case NARCO_SPOT_HANGOUT: return GetPlayerVip(playerid) >= 3 ? 3 : 2;
        case NARCO_SPOT_LABORATORY: return 1;
    }
    return 0;
}

stock NarcoSpotPlayer_GetType(playerid)
{
    new worldid = GetPlayerVirtualWorld(playerid);
    if (worldid >= NARCO_SPOT_HANGOUT_VIRTUAL_WORLD && worldid < NARCO_SPOT_LABORATORY_VIRTUAL_WORLD) {
        return NARCO_SPOT_HANGOUT;
    } else if (worldid >= NARCO_SPOT_LABORATORY_VIRTUAL_WORLD && worldid < NARCO_SPOT_LABORATORY_VIRTUAL_WORLD + 500) {
        return NARCO_SPOT_LABORATORY;
    }
    return NARCO_SPOT_INVALID_ID;
}

stock NarcoSpotPlayer_GetId(playerid)
{
    if (!NarcoSpotPlayer_IsInside(playerid)) return NARCO_SPOT_INVALID_ID;
    
    new type = NarcoSpotPlayer_GetType(playerid);
    return GetPlayerVirtualWorld(playerid) - NarcoSpot_GetStartVirtualWorld(type);
}

stock NarcoSpotPlayer_GetNearPlaceId(playerid, Float: max_distance = 2.0, bool: only_free = false, bool: only_owner = false, bool: no_soil = false, bool: soil = false, bool: only_riped = false)
{
    if (!NarcoSpotPlayer_IsInside(playerid)) return NARCO_SPOT_INVALID_ID;

    new spotid = NarcoSpotPlayer_GetId(playerid);

    new Float: x, Float: y, Float: z, Float: distance = 100.0, result = NARCO_SPOT_INVALID_ID;
    for (new i = 0; i < MAX_NARCO_PLACES; i++)
    {
        if (only_free && spotid >= 0 && NarcoPlaceInfo[spotid][i][npdWaterTime] > 0) continue;
        if (only_owner && NarcoPlaceInfo[spotid][i][npdPlayer] != PlayerInfo[playerid][pID]) continue;
        if (no_soil && NarcoPlaceInfo[spotid][i][npdSoilPlaced]) continue;
        if (soil && !NarcoPlaceInfo[spotid][i][npdSoilPlaced]) continue;
        if (only_riped && !NarcoPlaceInfo[spotid][i][npdRiped]) continue;
        
        if (NarcoSpotInfo[spotid][nstType] == NARCO_SPOT_LABORATORY && i >= sizeof(NarcoLaboratoryPlacesMarks)) break;

        GetDynamicObjectPos(NarcoPlaceObjects[spotid][i], x, y, z);
        if (IsPlayerInRangeOfPoint(playerid, max_distance, x, y, z))
        {
            new Float: cur_distance = GetDistanceBetweenPoints3D(x, y, z, Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid]);
            if (cur_distance < distance)
            {
                distance = cur_distance;
                result = i;
            }
        }
    }

    return result;
}

stock NarcoSpotPlayer_IsInside(playerid, e_NarcoSpotType: type = e_NarcoSpotType: NARCO_SPOT_INVALID_ID, id = NARCO_SPOT_INVALID_ID)
{
    if (id == NARCO_SPOT_INVALID_ID)
    {
        if (_:type == NARCO_SPOT_INVALID_ID)
        {
            new _type = NarcoSpotPlayer_GetType(playerid);
            if (_type >= 0)
            {
                new Float: x, Float: y, Float: z, Float: a;
                NarcoSpot_GetExitPosition(_type, x, y, z, a);
                return IsPlayerInRangeOfPoint(playerid, 100.0, x, y, z);
            }
        } else {
            return NarcoSpotPlayer_GetType(playerid) == _:type;
        }
    }
    else if (NarcoSpotIsExists(id))
    {
        return NarcoSpotPlayer_GetId(playerid) == id;
    }

    return 0;
}

stock NarcoSpot_GetStartVirtualWorld(type)
{
    switch (type)
    {
        case NARCO_SPOT_HANGOUT: return NARCO_SPOT_HANGOUT_VIRTUAL_WORLD;
        case NARCO_SPOT_LABORATORY: return NARCO_SPOT_LABORATORY_VIRTUAL_WORLD;
        default: return 0;
    }
}

stock NarcoSpot_GetVirtualWorld(id)
{
    return NarcoSpot_GetStartVirtualWorld(NarcoSpotInfo[id][nstType]) + id;
}

stock NarcoSpot_GetExitPosition(type, &Float: x, &Float: y, &Float: z, &Float: a)
{
    switch (type)
    {
        case NARCO_SPOT_HANGOUT: x = 978.8376, y = 228.3050, z = 156.0435, a = 270.0;
        case NARCO_SPOT_LABORATORY: x = 978.7169, y = 228.3561, z = 156.0435, a = 270.0;
        default: return 0;
    }

    return 1;
}

stock NarcoSpot_DestroyPlaceLabel(spotid, potid)
{
    if (IsValidDynamic3DTextLabel(NarcoPlaceInfo[spotid][potid][npdLabel]))
    {
        DestroyDynamic3DTextLabel(NarcoPlaceInfo[spotid][potid][npdLabel]);
        NarcoPlaceInfo[spotid][potid][npdLabel] = STREAMER_TAG_3D_TEXT_LABEL: 0;
    }
    return 1;
}

function NarcoSpot_UpdatePlaceLabel(spotid, placeid)
{
    if (!NarcoSpotIsExists(spotid)) return NarcoSpot_DestroyPlaceLabel(spotid, placeid);
    if (NarcoSpotIsPlaceFree(spotid, placeid)) return NarcoSpot_DestroyPlaceLabel(spotid, placeid);

    if (!IsValidDynamic3DTextLabel(NarcoPlaceInfo[spotid][placeid][npdLabel]))
    {
        new Float: x, Float: y, Float: z;
        GetDynamicObjectPos(NarcoPlaceObjects[spotid][placeid], x, y, z);
        if (NarcoSpotInfo[spotid][nstType] == NARCO_SPOT_LABORATORY) z += 0.55;

        NarcoPlaceInfo[spotid][placeid][npdLabel] = CreateDynamic3DTextLabel("", 0xFFFFFFFF, x, y, z, 2.5, .worldid = NarcoSpot_GetVirtualWorld(spotid));

        foreach (new id : Player)
        {
            if (NarcoSpotPlayer_IsInside(id, NarcoSpotInfo[spotid][nstType], spotid))
            {
                Streamer_Update(id, STREAMER_TYPE_3D_TEXT_LABEL);
            }
        }
    }

    new unix = gettime();
    switch (NarcoSpotInfo[spotid][nstType])
    {
        case NARCO_SPOT_HANGOUT:
        {
            if (NarcoPlaceInfo[spotid][placeid][npdRiped])
            {
                FORMAT:buffer("Место №%d\n{99ff66}Растение созрело", placeid + 1);
                UpdateDynamic3DTextLabelText(NarcoPlaceInfo[spotid][placeid][npdLabel], 0xCCCCCCFF, buffer);
                return 1;
            } else if (NarcoPlaceInfo[spotid][placeid][npdSoilPlaced] && NarcoPlaceInfo[spotid][placeid][npdWaterTime] == 0)
            {
                FORMAT:buffer("Место №%d\n{c88833}Нужно посеять", placeid + 1);
                UpdateDynamic3DTextLabelText(NarcoPlaceInfo[spotid][placeid][npdLabel], 0xCCCCCCFF, buffer);
                return 1;
            }

            if (NarcoPlaceInfo[spotid][placeid][npdWaterTime] - unix <= 0) // Засохло
            {
                FORMAT:buffer("Место №%d\n\n{ff6347}Растение засохло", placeid + 1);
                UpdateDynamic3DTextLabelText(NarcoPlaceInfo[spotid][placeid][npdLabel], 0xFF9000FF, buffer);

                foreach (new playerid : Player)
                {
                    if(NarcoPlaceInfo[spotid][placeid][npdPlayer] == PlayerInfo[playerid][pID]) {
                        SendClientMessage(playerid, COLOR_YELLOW, " SMS от Распорядителя: {99ff33}Зачем ты занимаешь место, если даже уследить за ним не в силах?");
                        break;
                    }
                }

                NarcoPlaceInfo[spotid][placeid][npdPlayer] = 0;
                NarcoPlaceInfo[spotid][placeid][npdRentTime] = 0;
                NarcoPlaceInfo[spotid][placeid][npdWaterTime] = 0;
                NarcoSpotPlaceSave(spotid, placeid);

                return 1;
            } else if (NarcoPlaceInfo[spotid][placeid][npdWaterTime] - unix <= 120) // Осталось меньше двух минут до засыхания
            {
                FORMAT_SIZE:buffer(144, "Место №%d\n\n{00bfff}Нужно полить\n", placeid + 1);
                if (NarcoPlaceInfo[spotid][placeid][npdWaterings] > 0)
                {
                    format(buffer, sizeof(buffer), "%s{ede000}Растение засохнет через: %s", buffer, fine_time(NarcoPlaceInfo[spotid][placeid][npdWaterTime] - unix));
                }
                UpdateDynamic3DTextLabelText(NarcoPlaceInfo[spotid][placeid][npdLabel], 0xFF9000FF, buffer);
            } else { // Ожидает времени полива
                FORMAT:buffer("Место №%d\n\n{00bfff}Растение нужно полить через: %s", placeid + 1, fine_time(NarcoPlaceInfo[spotid][placeid][npdWaterTime] - unix - 120));
                UpdateDynamic3DTextLabelText(NarcoPlaceInfo[spotid][placeid][npdLabel], 0xFF9000FF, buffer);
            }
        }
        case NARCO_SPOT_LABORATORY:
        {
            if (NarcoPlaceInfo[spotid][placeid][npdRiped]) // Порошок готов
            {
                if (NarcoPlaceInfo[spotid][placeid][npdEarned])
                {
                    FORMAT:buffer("Место №%d\n{99ff66}Ожидает упаковки", placeid + 1);
                    UpdateDynamic3DTextLabelText(NarcoPlaceInfo[spotid][placeid][npdLabel], 0xCCCCCCFF, buffer);
                    return 1;
                }
                FORMAT:buffer("Место №%d\n{99ff66}Порошок изготовлен {cccccc}%s", placeid + 1, NarcoPlaceInfo[spotid][placeid][npdDummyPowder] ? "(некачественный)" : "(качественный)");
                UpdateDynamic3DTextLabelText(NarcoPlaceInfo[spotid][placeid][npdLabel], 0xCCCCCCFF, buffer);
                return 1;
            }

            if (NarcoPlaceInfo[spotid][placeid][npdWaterTime] - unix <= 0) // Сгорел
            {
                // Продлеваем время добавления, если порошка ещё не было
                if (NarcoPlaceInfo[spotid][placeid][npdWaterings] < 1) {
                    NarcoPlaceInfo[spotid][placeid][npdWaterTime] = gettime() + 120;
                    return NarcoSpot_UpdatePlaceLabel(spotid, placeid);
                }
                
                new playerid = INVALID_PLAYER_ID;
                foreach (new id : Player)
                {
                    if (NarcoPlaceInfo[spotid][placeid][npdPlayer] == PlayerInfo[id][pID])
                    {
                        playerid = id;
                        break;
                    }
                }

                if (IsOnline(playerid))
                {
                    SendClientMessage(playerid, COLOR_YELLOW, " SMS от Распорядителя: {99ff33}Ты что, спалить нам тут всё решил? Мы прибережем место для более ответственных людей.");
                }

                FORMAT:buffer("Место №%d\n\n{ff6347}Порошок сгорел", placeid + 1);
                UpdateDynamic3DTextLabelText(NarcoPlaceInfo[spotid][placeid][npdLabel], 0xFF9000FF, buffer);
                NarcoSpotPlaceExplode(spotid, placeid);

                NarcoPlaceInfo[spotid][placeid][npdPlayer] = 0;
                NarcoPlaceInfo[spotid][placeid][npdRentTime] = 0;
                NarcoPlaceInfo[spotid][placeid][npdWaterTime] = 0;
                NarcoSpotPlaceSave(spotid, placeid);

                return 1;
            } else if (NarcoPlaceInfo[spotid][placeid][npdWaterTime] - unix <= 120) // Осталось меньше двух минут до взрыва
            {
                FORMAT_SIZE:buffer(144, "Место №%d\n\n{00bfff}Нужно добавить ингредиент\n{cccccc}[ N >> Ингредиент >> ALT ]\n", placeid + 1);
                if (NarcoPlaceInfo[spotid][placeid][npdWaterings] > 0)
                {
                    format(buffer, sizeof(buffer), "%s{ede000}Порошок сгорит через: %s", buffer, fine_time(NarcoPlaceInfo[spotid][placeid][npdWaterTime] - unix));
                }
                UpdateDynamic3DTextLabelText(NarcoPlaceInfo[spotid][placeid][npdLabel], 0xFF9000FF, buffer);
            } else { // Ожидает времени добавления ингредиента
                FORMAT:buffer("Место №%d\n\n{00bfff}Ингредиент нужно добавить через: %s", placeid + 1, fine_time(NarcoPlaceInfo[spotid][placeid][npdWaterTime] - unix - 120));
                UpdateDynamic3DTextLabelText(NarcoPlaceInfo[spotid][placeid][npdLabel], 0xFF9000FF, buffer);
            }
        }
    }

    return SetTimerEx("NarcoSpot_UpdatePlaceLabel", 1000, false, "dd", spotid, placeid);
}

stock NarcoSpotPlaceIsDried(spotid, potid)
{
    if (!NarcoSpotIsExists(spotid)) return 0;
    if (potid < 0 || potid >= MAX_NARCO_PLACES) return 0;
    if (NarcoPlaceInfo[spotid][potid][npdWaterTime] == 0) return 0;

    return NarcoPlaceInfo[spotid][potid][npdWaterTime] - gettime() <= 0;
}

DIALOG:narcospot_hangout_clearpot(playerid, response, listitem, const inputtext[])
{
    if (!response) return 0;

    new spotid = NarcoSpotPlayer_GetId(playerid);
    if (!NarcoSpotIsExists(spotid)) return 0;

    new potid = GetDialogContextInt(playerid, "potid");
    if (!NarcoSpotPlaceIsDried(spotid, potid)) return 0;

    NarcoSpotPlaceFree(spotid, potid);
    NarcoSpot_DestroyPlaceLabel(spotid, potid);

    return 1;
}

stock NarcoSpotPlayer_Join(playerid, i)
{
    new Float: x, Float: y, Float: z, Float: a;
    S_SetPlayerVirtualWorld(playerid, NarcoSpot_GetVirtualWorld(i), 1);
    PPSetPlayerInterior(playerid, 1);
    NarcoSpot_GetExitPosition(NarcoSpotInfo[i][nstType], x, y, z, a);
    NarcoSpotPlayer_ChangeActiveSpot(playerid);
    PPSetPlayerPos(playerid, x, y, z);
    PPSetPlayerFacingAngle(playerid, a);
    NarcoSpot_SetPlayerTime(playerid);
    SetCameraBehindPlayer(playerid);
    keep(playerid);

    return 1;
}

stock NarcoSpotPlayer_Exit(playerid, i)
{
    if (Hold[playerid] == 15) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я что, так и пойду с канистрой? Нужно оставить её здесь.");
    if (Hold[playerid] == 16) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не думаю, что брать почву с собой - хорошая идея");
    if (Hold[playerid] == 17) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Ну, с чем с чем, а с травой я точно должен разобраться до того, как выйду отсюда");

    new Float: x, Float: y, Float: z, Float: a;

    if (NarcoSpotIsExists(i))
    {
        Streamer_GetItemPos(STREAMER_TYPE_PICKUP, NarcoSpotInfo[i][nstEnterPickup], x, y, z);
        a = NarcoSpotInfo[i][nstAngle][2] - 180.0;
        frontpos(1.5, x, y, a, x, y);
    }
    else
    {
        x = PlayerInfo[playerid][find_X],
        y = PlayerInfo[playerid][find_Y],
        z = PlayerInfo[playerid][find_Z] + 0.5,
        GetPlayerFacingAngle(playerid, a);
    }

    S_SetPlayerVirtualWorld(playerid, 0, 0);
    PPSetPlayerInterior(playerid, 0);

    PPSetPlayerPos(playerid, x, y, z);
    PPSetPlayerFacingAngle(playerid, a);
    PearsTime(playerid), PearsWeather(playerid);
    SetCameraBehindPlayer(playerid);

    return 1;
}

stock NarcoSpot_StartPackPump(playerid)
{
    if (!NarcoSpotPlayer_IsInside(playerid)) return 0;

    SetPVarInt(playerid, "Arobsklad", 20);

    if (NarcoSpotPlayer_GetType(playerid) == _:NARCO_SPOT_HANGOUT) SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Нужно упаковать срезанную траву {ff9000}[ Нажимайте %s ]", buttonName[Device[playerid]]);
    else if (NarcoSpotPlayer_GetType(playerid) == _:NARCO_SPOT_LABORATORY) SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Нужно упаковать порошок {ff9000}[ Нажимайте %s ]", buttonName[Device[playerid]]);
    
    return 1;
}

stock NarcoSpot_PackPump(playerid)
{
    if (gettime() - NarcoSpotPlayerInfo[playerid][nspPumpCooldown] < HANGOUT_PACK_COOLDOWN) return 0;

    SetPVarInt(playerid, "oryjtemp", GetPVarInt(playerid, "oryjtemp") + 5);

    new placeid = NarcoSpotPlayerInfo[playerid][nspPlaceId],
        spotid = NarcoSpotPlayer_GetId(playerid);
    if (placeid > NARCO_SPOT_INVALID_ID &&
        NarcoPlaceInfo[spotid][placeid][npdRiped] &&
        NarcoPlaceInfo[spotid][placeid][npdPlayer] == PlayerInfo[playerid][pID] &&
        NarcoSpotIsExists(spotid) &&
        NarcoSpotPlayer_IsInside(playerid, .id = spotid)
    ) {}
    else {
        // Произошла ошибка в процессе упаковки
        SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad", 0);
        ClearAnim(playerid);

        PlayerPlaySound(playerid, 31203);
        return 0;
    }

    new string[128];
    new current_progress = GetPVarInt(playerid, "oryjtemp");
    if (current_progress >= HANGOUT_PACK_POINTS)
    {
        SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad", 0);
        ClearAnim(playerid);

        new put_inva = NARCO_SPOT_INVALID_ID;
        if (NarcoSpotPlayer_GetType(playerid) == _:NARCO_SPOT_HANGOUT) put_inva = GiveThingPlayer(playerid, 271, 1, 0, 0, 0, 0);
        else if (NarcoSpotPlayer_GetType(playerid) == _:NARCO_SPOT_LABORATORY) put_inva = GiveThingPlayer(playerid, NarcoPlaceInfo[spotid][placeid][npdDummyPowder] ? 278 : 277, 1, 0, 0, 0, 0);
        if (put_inva == NARCO_SPOT_INVALID_ID) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");

        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~%s~~h~~h~YЊAKO‹KA: ~w~%d/%d",
            (NarcoSpotPlayer_GetType(playerid) == _:NARCO_SPOT_HANGOUT) ? "g" : "b",
            HANGOUT_PACK_POINTS, HANGOUT_PACK_POINTS
        );

        GameTextForPlayer(playerid, string, 2500, 3);
        PlayerPlaySound(playerid, 25800);

        NarcoPlaceInfo[spotid][placeid][npdRiped] = false;
        NarcoPlaceInfo[spotid][placeid][npdEarned] = false;
        NarcoPlaceInfo[spotid][placeid][npdWaterTime] = 0;
        NarcoPlaceInfo[spotid][placeid][npdWaterings] = 0;
        NarcoPlaceInfo[spotid][placeid][npdDummyPowder] = false;

        if (NarcoSpotPlayer_GetType(playerid) == _:NARCO_SPOT_LABORATORY) {
            NarcoPlaceInfo[spotid][placeid][npdWaterTime] = gettime() + 120;
            NarcoSpot_UpdatePlaceLabel(spotid, placeid);
        }

        NarcoSpotPlaceSave(spotid, placeid);

        NarcoSpotPlayerInfo[playerid][nspPlaceId] = NARCO_SPOT_INVALID_ID;

        NarcoSpotPlayer_SetCurrentAction(playerid, NARCO_PLAYER_ACTION_NONE);
        if (Hold[playerid] == 17) {
            RemovePlayerAttachedObject(playerid, 1);
            Hold[playerid] = 0;
        }

        if (NarcoSpotPlayer_GetType(playerid) == _:NARCO_SPOT_HANGOUT)
            return SuccessMessage(playerid, "{99ff66}Вы успешно упаковали траву!\n\n{cccccc}Вам выдана: 1 упаковка (10 использований)");
        else if (NarcoSpotPlayer_GetType(playerid) == _:NARCO_SPOT_LABORATORY)
            return SuccessMessage(playerid, "{99ff66}Вы успешно упаковали порошок!\n\n{cccccc}Вам выдана: 1 упаковка (20 использований)");
    } else {
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~%s~~h~~h~YЊAKO‹KA: ~w~%d/%d",
            (NarcoSpotPlayer_GetType(playerid) == _:NARCO_SPOT_HANGOUT) ? "g" : "b",
            current_progress, HANGOUT_PACK_POINTS
        );
        
        GameTextForPlayer(playerid, string, 2500, 3);
        if (current_progress <= 5 || current_progress % 10 == 0) {
            ApplyAnimation(playerid, "INT_HOUSE", "wash_up", 3.5, true, false, false, false, false);

            if (NarcoSpotPlayer_GetType(playerid) == _:NARCO_SPOT_HANGOUT)
                SetPlayerChatBubble(playerid, "упаковывает траву", COLOR_PURPLE, 20.0, 1500);
            else if (NarcoSpotPlayer_GetType(playerid) == _:NARCO_SPOT_LABORATORY)
                SetPlayerChatBubble(playerid, "упаковывает порошок", COLOR_PURPLE, 20.0, 1500);
        }
        NarcoSpotPlayerInfo[playerid][nspPumpCooldown] = gettime();
    }

    return 1;
}

DIALOG:narcospot_chemical_amount(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "narcospot_chemical");

    new e_NarcoSpotIngredient: ingredient = e_NarcoSpotIngredient: GetDialogContextInt(playerid, "ingredient");
    new fpick = NarcoSpotGetIngredientThing(ingredient);
    new price = getThingPriceGos(fpick, 0);

    new amount;
    if (sscanf(inputtext, "d", amount)) return PlayerPlaySound(playerid, 4203), ShowAdvancedDialog(playerid, "narcospot_chemical_amount");

    new getQuan, getLimit;
    i_limit(playerid, fpick, getQuan, getLimit);
    if (amount < 1) return PlayerPlaySound(playerid, 4203), ShowAdvancedDialog(playerid, "narcospot_chemical_amount");

    FORMAT_SIZE:string(144, "{FF6347}Максимальное количество этого ингредиента в инвентаре: %d", getLimit);
    if (getQuan + amount > getLimit) return ErrorText(playerid, string), ShowAdvancedDialog(playerid, "narcospot_chemical_amount");

    new put_inva = GiveThingPlayer(playerid, fpick, amount, 0, 0, 0, 0);
    if (put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");

    price *= amount;
    if (PlayerInfo[playerid][pMoney] < price) return ErrorMessage(playerid, "{FF6347}У вас недостаточно денег");
    oGivePlayerMoney(playerid, -price);

    format(string, sizeof(string), "Купил %s (%d шт.)", GetNameThing(0, fpick, 0, 0), amount);
    MoneyLog("buy_ingredient", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, string);

    format(string, sizeof(string), "{99ff66}Вы успешно купили %s (%d шт.)!", GetNameThing(0, fpick, 0, 0), amount);
    SuccessMessage(playerid, string);

    return 1;
}

DIALOG:narcospot_chemical_buykit(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "narcospot_chemical");

    new kitid = GetDialogContextInt(playerid, "kit");
    new price = NarcoSpot_GetIngredientKitPrice(kitid);
    if (PlayerInfo[playerid][pMoney] < price) return ErrorMessage(playerid, "{FF6347}У вас недостаточно денег");

    for (new i = 0; i < NARCO_MAX_INGREDIENTS_PER_KIT; i++)
    {
        new e_NarcoSpotIngredient: ingredient = e_NarcoSpotIngredient: NarcoSpotIngredientKits[kitid][nsikIngredients][i];
        new getQuan, getLimit;
        i_limit(playerid, NarcoSpotGetIngredientThing(ingredient), getQuan, getLimit);

        if (getQuan + NarcoSpotIngredientKits[kitid][nsikIngredientsAmount] > getLimit) return ErrorText(playerid, "{FF6347}Превышен лимит для одного из ингредиентов"), ShowAdvancedDialog(playerid, "narcospot_chemical");
    }

    new put_inva = 0, give_ingredient_id = 0;
    for (new i = 0; i < NARCO_MAX_INGREDIENTS_PER_KIT; i++)
    {
        new e_NarcoSpotIngredient: ingredient = e_NarcoSpotIngredient: NarcoSpotIngredientKits[kitid][nsikIngredients][i];
        new amount = NarcoSpotIngredientKits[kitid][nsikIngredientsAmount][i];

        put_inva = GiveThingPlayer(playerid, NarcoSpotGetIngredientThing(ingredient), amount, 0, 0, 0, 0);
        if (put_inva == -1) {
            // Откатываем выданные ингредиенты
            for (new j = 0; j < give_ingredient_id; j++)
            {
                new e_NarcoSpotIngredient: rollback_ingredient = e_NarcoSpotIngredient: NarcoSpotIngredientKits[kitid][nsikIngredients][j];
                new rollback_amount = NarcoSpotIngredientKits[kitid][nsikIngredientsAmount][j];
                TakeInvent(playerid, NarcoSpotGetIngredientThing(rollback_ingredient), rollback_amount, 0);
            }

            return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");
        }
        give_ingredient_id++;
    }

    oGivePlayerMoney(playerid, -price);

    FORMAT_SIZE:string(144, "Купил набор %s", NarcoSpotIngredientKits[kitid][nsikName]);
    MoneyLog("buy_ingredient_kit", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, string);

    format(string, sizeof(string), "{99ff66}Вы успешно купили набор %s!", NarcoSpotIngredientKits[kitid][nsikName]);
    SuccessMessage(playerid, string);

    return 1;
}

DIALOG_ITEMS:narcospot_chemical(playerid, response, listitem, i, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "narcospot_chemical_type");

    new type = GetDialogContextInt(playerid, "narcospot_chemical_type");
    switch (type)
    {
        case 0: { // Ингредиенты
            new fpick = NarcoSpotGetIngredientThing(e_NarcoSpotIngredient: i);
            new price = getThingPriceGos(fpick, 0);

            SetDialogContextInt(playerid, "ingredient", i);

            FORMAT:text("{cccccc}Вы выбрали: {99ff66}%s\n{cccccc}Цена (1 шт.): {99ff66}$%d\n\n{cccccc}Введите количество:", GetNameThing(0, fpick, 0, 0), price);
            ShowAdvancedDialog(playerid, "narcospot_chemical_amount", DIALOG_STYLE_INPUT, "{cccccc}Меню", text, "Выбор", "Назад");
        }
        case 1: { // Наборы
            new dialog_text[1024];
            format(dialog_text, sizeof(dialog_text), "{cccccc}Вы выбрали: {99ff66}Набор \"%s\"\n{cccccc}Цена: {99ff66}$%d\n\n{cccccc}Ингредиенты:\n", NarcoSpotIngredientKits[i][nsikName], NarcoSpot_GetIngredientKitPrice(i));
            for (new j = 0; j < NARCO_MAX_INGREDIENTS_PER_KIT; j++)
            {
                new e_NarcoSpotIngredient: ingredient = e_NarcoSpotIngredient: NarcoSpotIngredientKits[i][nsikIngredients][j];
                format(dialog_text, sizeof(dialog_text), "%s    {ff9000}%d. %s\n", dialog_text, j + 1, GetNameThing(0, NarcoSpotGetIngredientThing(ingredient), 0, 0));
            }
            strcat(dialog_text, "\n\n{cccccc}Вы уверены, что хотите купить этот набор?");

            SetDialogContextInt(playerid, "kit", i);
            ShowAdvancedDialog(playerid, "narcospot_chemical_buykit", DIALOG_STYLE_MSGBOX, "{cccccc}Меню", dialog_text, "Купить", "Назад");
        }
    }
    
    return 1;
}

DIALOG:narcospot_chemical_type(playerid, response, listitem, const inputtext[])
{
    if (!response) return 0;

    SetDialogContextInt(playerid, "narcospot_chemical_type", listitem);
    switch (listitem)
    {
        case 0: {
            new dialog_text[1024] = "{cccccc}Ингредиент\t{cccccc}Цена\n";
            for (new i = 1; i <= 3; i++)
            {
                new e_NarcoSpotIngredient: ingredient = e_NarcoSpotIngredient: i;

                new fpick = NarcoSpotGetIngredientThing(ingredient);
                format(dialog_text, sizeof(dialog_text), "%s{ff9000}%s\t{99ff66}$%d\n", dialog_text,
                    GetNameThing(0, fpick, 0, 0),
                    getThingPriceGos(fpick, 0)
                );
                AttachAdvancedDialogItemValue(playerid, "narcospot_chemical", i);
            }
            ShowAdvancedDialog(playerid, "narcospot_chemical", DIALOG_STYLE_TABLIST_HEADERS, "{cccccc}Меню", dialog_text, "Выбор", "Назад");
        }
        case 1: {
            new dialog_text[1024] = "{cccccc}Набор\t{cccccc}Цена\n";
            for (new i = 0; i < NARCO_MAX_INGREDIENT_KITS; i++)
            {
                format(dialog_text, sizeof(dialog_text), "%s{ff9000}%s\t{99ff66}$%d\n", dialog_text,
                    NarcoSpotIngredientKits[i][nsikName],
                    NarcoSpot_GetIngredientKitPrice(i)
                );
                AttachAdvancedDialogItemValue(playerid, "narcospot_chemical", i);
            }
            ShowAdvancedDialog(playerid, "narcospot_chemical", DIALOG_STYLE_TABLIST_HEADERS, "{cccccc}Меню", dialog_text, "Выбор", "Назад");
        }
    }

    return 1;
}

stock NarcoSpot_GetIngredientKitPrice(id)
{
    if (id < 0 || id > NARCO_MAX_INGREDIENT_KITS) return 0;

    new price = 0;
    for (new i = 0; i < NARCO_MAX_INGREDIENTS_PER_KIT; i++)
    {
        new e_NarcoSpotIngredient: ingredient = e_NarcoSpotIngredient: NarcoSpotIngredientKits[id][nsikIngredients][i];
        new fpick = NarcoSpotGetIngredientThing(ingredient);
        price += getThingPriceGos(fpick, 0) * NarcoSpotIngredientKits[id][nsikIngredientsAmount][i];
    }

    return price;
}

stock NarcoSpot_OnPlayerPressALT(playerid)
{
    // Вход/выход
    new Float: x, Float: y, Float: z, Float: a;
    if (GetPlayerVirtualWorld(playerid) == 0)
    {
        for (new i = 0; i < MAX_NARCO_SPOTS; i++)
        {
            if (!NarcoSpotIsExists(i)) continue;

            Streamer_GetItemPos(STREAMER_TYPE_PICKUP, NarcoSpotInfo[i][nstEnterPickup], x, y, z);

            if (IsPlayerInRangeOfPoint(playerid, 1.0, x, y, z))
            {
                if (IsPoliceMember(playerid)) return ErrorMessage(playerid, "Вы не можете войти в притон [ Только при рейде ]");
                if (IsPlayerHavePursuit(playerid)) return ErrorMessage(playerid, "Вы не можете войти в притон [ Вас преследуют ]");
                if (Stun[4][playerid] == 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я в наручниках");

                if (NarcoSpotHangOutCutSceneEnable(playerid, i)) return 1;
                if (NarcoSpotLaboratoryCutSceneEnable(playerid, i)) return 1;
                NarcoSpotPlayer_Join(playerid, i);

                return 1;
            }
        }
    } else if (NarcoSpotPlayer_IsInside(playerid)) {
        new i = NarcoSpotPlayer_GetId(playerid);
        NarcoSpot_GetExitPosition(NarcoSpotInfo[i][nstType], x, y, z, a);

        if (IsPlayerInRangeOfPoint(playerid, 1.0, x, y, z))
        {
            NarcoSpotPlayer_Exit(playerid, i);
            
            return 1;
        }
    }

    // Взаимодействие с "поставщиком" (Химический завод)
    if (GetPlayerVirtualWorld(playerid) == 0 && IsPlayerInRangeOfPoint(playerid, 1.5, 1787.7637, -1135.4215, 24.1105))
    {
        if (IsPoliceMember(playerid)) return ErrorMessage(playerid, "{FF6347}Вы не можете воспользоваться услугами поставщика [ Служитель закона ]");
        ShowAdvancedDialog(playerid, "narcospot_chemical_type", DIALOG_STYLE_LIST, "{cccccc}Поставщик", "{cccccc}Ингредиенты\n{cccccc}Наборы", "Выбор", "Закрыть", true);
        return 1;
    }

    // Взаимодействие с точками
    if (NarcoSpotPlayer_IsInside(playerid, NARCO_SPOT_HANGOUT))
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 1006.0000, 226.0471, 152.5605))
        {
            FORMAT:dialog_text("{cccccc}Информация\n{cccccc}Купить нож {99ff66}($%d)\n{ff9000}Перейти к аренде >>", getThingPriceGos(97, 0) * 2);
            return ShowAdvancedDialog(playerid, "narcospot_hangout", DIALOG_STYLE_LIST, "{cccccc}Меню", dialog_text, "Выбор", "Закрыть", true);
        } else if (IsPlayerInRangeOfPoint(playerid, 2.0, 997.459899, 232.581756, 153.160415)) { // Почва для посадки
            new spotid = NarcoSpotPlayer_GetId(playerid);
            if (!NarcoSpotIsExists(spotid)) return 0;
            if (Hold[playerid] == 16 || NarcoSpotPlayerInfo[playerid][nspCurrentAction] == NARCO_PLAYER_ACTION_SOIL) {
                Hold[playerid] = 0;
                NarcoSpotPlayer_SetCurrentAction(playerid, NARCO_PLAYER_ACTION_NONE);
                RemovePlayerAttachedObject(playerid, 1);
                ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false);
                SetPlayerChatBubble(playerid, "убирает мешок с почвой", COLOR_PURPLE, 20.0, 1500);
                return 1;
            }
            if (Hold[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вас заняты руки");

            new potid = NarcoSpotPlayerInfo[playerid][nspPlaceId];
            // Не установлен конкретный номер горшка/уже занят растением/был срезан
            if (potid < 0 || NarcoPlaceInfo[spotid][potid][npdEarned] || NarcoPlaceInfo[spotid][potid][npdSoilPlaced])
            {
                potid = NarcoSpotPlayerInfo[playerid][nspPlaceId] = NarcoSpotPlayer_GetNearPlaceId(playerid, 50.0, true, true, true);
            }
            if (potid < 0 || NarcoSpotPlayer_GetPlacesAmount(playerid, NARCO_SPOT_HANGOUT, spotid, true) < 1)
            {
                return ErrorMessage(playerid, "{FF6347}У вас нет свободных мест для почвы");
            }
            NarcoSpotPlayer_MarkPlace(playerid, potid);
            NarcoSpotPlayer_SetCurrentAction(playerid, NARCO_PLAYER_ACTION_SOIL);
            ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false);
            Hold[playerid] = 16;
            SetPlayerAttachedObject(playerid, 1, 2060, 6, 0.336999, 0.024999, 0.000000, 96.299972, 0.000000, 0.000000, 0.480999, 0.642001, 1.000000, 0, 0);
            SetPlayerChatBubble(playerid, "берёт мешок с почвой", COLOR_PURPLE, 20.0, 1500);
        } else if (IsPlayerInRangeOfPoint(playerid, 2.25, 1000.1066,237.2812,153.9699)) { // Стол с семенами
            if (NarcoSpotPlayerInfo[playerid][nspCurrentAction] == NARCO_PLAYER_ACTION_TAKE_SEED)
            {
                new potid = NarcoSpotPlayer_GetNearPlaceId(playerid, 50.0, true, true, false, true);
                if (potid != NARCO_SPOT_INVALID_ID)
                {
                    ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false);
                    NarcoSpotPlayer_SetCurrentAction(playerid, NARCO_PLAYER_ACTION_SEED);
                    NarcoSpotPlayer_MarkPlace(playerid, potid);
                    SetPlayerChatBubble(playerid, "берёт семена со стола", COLOR_PURPLE, 20.0, 1500);
                } else NarcoSpotPlayer_SetCurrentAction(playerid, NARCO_PLAYER_ACTION_NONE);
                return 1;
            } else if (NarcoSpotPlayerInfo[playerid][nspCurrentAction] == NARCO_PLAYER_ACTION_MAKE)
            {
                new potid = NarcoSpotPlayerInfo[playerid][nspPlaceId],
                    spotid = NarcoSpotPlayer_GetId(playerid);
                if (potid != NARCO_SPOT_INVALID_ID && NarcoPlaceInfo[spotid][potid][npdRiped] && NarcoPlaceInfo[spotid][potid][npdPlayer] == PlayerInfo[playerid][pID])
                {
                    NarcoSpot_StartPackPump(playerid);
                    return 1;
                } else {
                    NarcoSpotPlayerInfo[playerid][nspPlaceId] = NARCO_SPOT_INVALID_ID;
                    return ErrorMessage(playerid, "{FF6347}Вы не можете упаковать траву в данный момент [ Не ваше растение или не созрело ]");
                }
            } else if (NarcoSpotPlayerInfo[playerid][nspCurrentAction] == NARCO_PLAYER_ACTION_SEED) {
                ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false);
                NarcoSpotPlayer_SetCurrentAction(playerid, NARCO_PLAYER_ACTION_TAKE_SEED);
                SetPlayerChatBubble(playerid, "убирает семена на стол", COLOR_PURPLE, 20.0, 1500);
            } else if (Hold[playerid] != 15) return ErrorMessage(playerid, "{FF6347}Вы не можете взять семена в данный момент");
        } else if (IsPlayerInRangeOfPoint(playerid, 1.5, 999.7675, 220.6945, 152.5605)) { // Вода
            if (Hold[playerid] == 15)
            {
                Hold[playerid] = 0;
                RemovePlayerAttachedObject(playerid, 1);
                ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false);
            } else if (Hold[playerid] == 0)
            {
                Hold[playerid] = 15;
                SetPlayerAttachedObject(playerid, 1, 12732, 6, 0.271000, 0.025000, 0.000000, 0.399998, -80.399932, 89.400016, 0.434001, 0.661000, 0.632002, 0x0, 0x0);
                ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false);
            } else return ErrorMessage(playerid, "{FF6347}У вас заняты руки");

            return 1;
        } else {
            new spotid = NarcoSpotPlayer_GetId(playerid);
            if (NarcoSpotIsExists(spotid))
            {
                new potid = NarcoSpotPlayer_GetNearPlaceId(playerid);
                if (potid == NARCO_SPOT_INVALID_ID) return 1;

                // Пытаемся полить чужую грядку
                if (Hold[playerid] == 15 && !NarcoSpotIsPlaceFree(spotid, potid) && NarcoPlaceInfo[spotid][potid][npdPlayer] != PlayerInfo[playerid][pID])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Зачем мне сюда лезть? Не хватало ещё за чужими следить");
                }

                // Взаимодействуем с нашей грядкой
                if (NarcoPlaceInfo[spotid][potid][npdPlayer] == PlayerInfo[playerid][pID]) 
                {
                    if (IsPlayerInRangeOfPoint(playerid, 2.0, NarcoHangoutPlacesMarks[potid][0], NarcoHangoutPlacesMarks[potid][1], NarcoHangoutPlacesMarks[potid][2]))
                    {
                        if (NarcoSpotPlayerInfo[playerid][nspCurrentAction] == NARCO_PLAYER_ACTION_SOIL)
                        {
                            if (NarcoSpotPlaceIsDried(spotid, potid)) {
                                SetDialogContextInt(playerid, "potid", potid);
                                return ShowAdvancedDialog(playerid, "narcospot_hangout_clearpot", DIALOG_STYLE_MSGBOX, " ", "{ff6347}Растение засохло\n\n{cccccc}Хотите освободить место?", "Да", "Закрыть");
                            }

                            NarcoSpotPlayerInfo[playerid][nspPlaceId] = potid;
                            NarcoPlaceInfo[spotid][potid][npdSoilPlaced] = true;
                            NarcoPlaceInfo[spotid][potid][npdEarned] = false;
                            NarcoSpot_UpdatePlaceLabel(spotid, potid);
                            NarcoSpotPlayer_SetCurrentAction(playerid, NARCO_PLAYER_ACTION_TAKE_SEED);
                            CreateGps(playerid, 1000.1888, 235.8608, 152.5605, .radius = NARCO_MARKS_SIZE);
                            ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false);
                            SetPlayerChatBubble(playerid, "засыпает почву", COLOR_PURPLE, 20.0, 1500);
                            if (Hold[playerid] == 16) {
                                RemovePlayerAttachedObject(playerid, 1);
                                Hold[playerid] = 0;
                            }
                        } else if (NarcoSpotPlayerInfo[playerid][nspCurrentAction] == NARCO_PLAYER_ACTION_SEED) {
                            if (NarcoSpotPlaceIsDried(spotid, potid)) {
                                SetDialogContextInt(playerid, "potid", potid);
                                return ShowAdvancedDialog(playerid, "narcospot_hangout_clearpot", DIALOG_STYLE_MSGBOX, " ", "{ff6347}Растение засохло\n\n{cccccc}Хотите освободить место?", "Да", "Закрыть");
                            }
                            NarcoPlaceInfo[spotid][potid][npdWaterTime] = gettime() + 120; // 2 минуты на первый полив
                            NarcoSpot_UpdatePlaceLabel(spotid, potid);
                            // Если больше нет мест, которые нужно посеять:
                            if (NarcoSpotPlayer_GetPlacesAmount(playerid, NARCO_SPOT_HANGOUT, spotid, true) == 0)
                            {
                                // Сбрасываем текущее действие
                                NarcoSpotPlayer_SetCurrentAction(playerid, NARCO_PLAYER_ACTION_NONE);
                            } else {
                                // Заново даем возможность посадить семена в другой горшок
                                NarcoSpotPlayer_SetCurrentAction(playerid, NARCO_PLAYER_ACTION_TAKE_SEED);
                            }
                            CreateGps(playerid, 999.6849, 220.8281, 152.5605, .radius = NARCO_MARKS_SIZE);
                            SetPlayerChatBubble(playerid, "сажает семена", COLOR_PURPLE, 20.0, 1500);
                            SuccessMessage(playerid, "{99ff66}Вы успешно посадили семена!\n\n{cccccc}Теперь вам необходимо полить почву");
                        } else if (Hold[playerid] == 15) {
                            new unix = gettime();
                            if (NarcoPlaceInfo[spotid][potid][npdWaterTime] == 0) return ErrorMessage(playerid, "{ff6347}Сперва необходимо приготовить почву и посадить семена");
                            if (NarcoPlaceInfo[spotid][potid][npdWaterTime] - unix <= 120) {
                                NarcoPlaceInfo[spotid][potid][npdWaterings]++;
                                if (NarcoPlaceInfo[spotid][potid][npdWaterings] == 1)
                                {
                                    NarcoSpotPlacePlant(spotid, potid, true);
                                } else if (NarcoPlaceInfo[spotid][potid][npdWaterings] >= (server == 0 ? HANGOUT_WATERINGS_TEST : HANGOUT_WATERINGS))
                                {
                                    SetTimerEx("NarcoSpot_WaitForRipedPlace", 600000, false, "dddd", PlayerInfo[playerid][pID], spotid, potid, NarcoPlaceInfo[spotid][potid][npdEarnedTimes]);
                                    NarcoPlaceInfo[spotid][potid][npdRiped] = true;
                                    SuccessMessage(playerid, "{99ff66}Растение созрело!\n\n{cccccc}Теперь вам необходимо срезать его [ ALT ]");
                                }
                                ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false);
                                if (Hold[playerid] == 15) {
                                    RemovePlayerAttachedObject(playerid, 1);
                                    Hold[playerid] = 0;
                                }
                                NarcoPlaceInfo[spotid][potid][npdWaterTime] = gettime() + (server == 0 ? HANGOUT_WATER_TIME_TEST : HANGOUT_WATER_TIME) + 120; // 5 минут на следующий полив + 2 дополнительные минуты (потом высохнет)
                                NarcoSpotPlaceSave(spotid, potid);
                            } else ErrorMessage(playerid, "{FF6347}Растение не нуждается в поливе");
                        } else if (NarcoPlaceInfo[spotid][potid][npdRiped]) {
                            if (NarcoSpotPlayerInfo[playerid][nspCurrentAction] != NARCO_PLAYER_ACTION_MAKE)
                            {
                                if(get_invent4(playerid, 97, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет ножа [ Купите его у распорядителя ]");
                                if(Hold[playerid] != 14) return ErrorMessage(playerid, "{FF6347}Возьмите в руки нож, чтобы срезать траву");

                                NarcoSpotPlayerInfo[playerid][nspPlaceId] = potid;
                                NarcoPlaceInfo[spotid][potid][npdSoilPlaced] = false;
                                NarcoPlaceInfo[spotid][potid][npdEarned] = true;
                                NarcoPlaceInfo[spotid][potid][npdEarnedTimes]++;
                                NarcoSpotPlayer_SetCurrentAction(playerid, NARCO_PLAYER_ACTION_MAKE);
                                NarcoSpotPlaceFree(spotid, potid, false);
                                ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false);
                                CreateGps(playerid, 1000.1888, 235.8608, 152.5605, .radius = NARCO_MARKS_SIZE);
                                Hold[playerid] = 17;
                                RemovePlayerAttachedObject(playerid, 1);
                                SetPlayerAttachedObject(playerid, 1, 19473, 6, 0.045999, 0.060999, -0.047000, 0.000000, 0.000000, 0.000000, 0.127000, 0.120999, 0.132999, 0xFFAAAAAA, 0xFFAAAAAA);
                                SetPlayerChatBubble(playerid, "срезает траву", COLOR_PURPLE, 20.0, 1500);
                                GameTextForPlayer(playerid, RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~g~~h~~h~~h~ТРАВА СРЕЗАНА"), 5000, 3);
                                PlayerPlaySound(playerid, 6401);
                                NarcoSpotPlaceSave(spotid, potid);
                            } else ErrorMessage(playerid, "{FF6347}Сперва запакуйте уже сорванное растение");
                        }
                        return 1;
                    }
                }
            }
        }
    } else if (NarcoSpotPlayer_IsInside(playerid, NARCO_SPOT_LABORATORY))
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 1003.4462, 237.1849, 152.5605))
        {
            ShowAdvancedDialog(playerid, "narcospot_laboratory", DIALOG_STYLE_LIST, "{cccccc}Меню",
                "{cccccc}Информация\n" \
                "{ff9000}Перейти к аренде >>\n",

                "Выбор", "Закрыть", true
            );
            return 1;
        }

        new spotid = NarcoSpotPlayer_GetId(playerid);

        // Взаимодействие с точками
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 1002.354553, 228.286773, 152.851364)) // Упаковка порошка
        {
            if (NarcoSpotPlayerInfo[playerid][nspCurrentAction] == NARCO_PLAYER_ACTION_MAKE)
            {
                new placeid = NarcoSpotPlayerInfo[playerid][nspPlaceId];
                if (placeid != NARCO_SPOT_INVALID_ID && NarcoPlaceInfo[spotid][placeid][npdEarned] && NarcoPlaceInfo[spotid][placeid][npdPlayer] == PlayerInfo[playerid][pID])
                {
                    if (Hold[playerid] == 19)
                    {
                        RemovePlayerAttachedObject(playerid, 1);
                        RemovePlayerAttachedObject(playerid, 2);
                        Hold[playerid] = 0;
                    }
                    ApplyAnimation(playerid, "PED", "facanger", 4.0, false, true, true, true, true);
                    NarcoSpot_StartPackPump(playerid);
                    return 1;
                } else {
                    NarcoSpotPlayerInfo[playerid][nspPlaceId] = NARCO_SPOT_INVALID_ID;
                    return ErrorMessage(playerid, "{FF6347}Вы не можете упаковать порошок в данный момент [ Не ваш или не готов ]");
                }
            } else return ErrorMessage(playerid, "{FF6347}Вы не можете упаковать порошок в данный момент [ Не взят в руки ]");
        }
        else {
            new placeid = NarcoSpotPlayer_GetNearPlaceId(playerid);
            if (placeid == NARCO_SPOT_INVALID_ID) return 1;

            new unix = gettime();

            // Взаимодействуем с нашим местом
            if (NarcoPlaceInfo[spotid][placeid][npdPlayer] == PlayerInfo[playerid][pID]) 
            {
                if (NarcoPlaceInfo[spotid][placeid][npdRiped]) // Сбор порошка
                {
                    if (NarcoSpotPlayerInfo[playerid][nspCurrentAction] != NARCO_PLAYER_ACTION_MAKE)
                    {
                        if (Hold[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вас заняты руки");
                        NarcoSpotPlayerInfo[playerid][nspPlaceId] = placeid;
                        NarcoPlaceInfo[spotid][placeid][npdEarned] = true;
                        NarcoPlaceInfo[spotid][placeid][npdEarnedTimes]++;
                        NarcoSpotPlayer_SetCurrentAction(playerid, NARCO_PLAYER_ACTION_MAKE);
                        NarcoSpotPlacePlant(spotid, placeid, false);
                        NarcoSpot_UpdatePlaceLabel(spotid, placeid);
                        if (placeid <= 2) {
                            CreateGps(playerid, 1002.4236, 230.1087, 152.5605, .radius = NARCO_MARKS_SIZE);
                        } else {
                            CreateGps(playerid, 1002.3253, 226.3294, 152.5605, .radius = NARCO_MARKS_SIZE);
                        }
                        ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, true, true, true, true, true);
                        SetPlayerAttachedObject(playerid, 1, 19883, 6, 0.104000, 0.040999, -0.165000, 74.600212, -0.100046, 89.699951, 1.327007, 1.111998, 0.012000, 0xFF0088FF, 0xFF0088FF);
                        SetPlayerAttachedObject(playerid, 2, 19829, 6, 0.100000, 0.011999, -0.156000, 71.799873, 89.400001, 91.899940, 1.882003, 1.346000, 1.959002, 0xFFCCCCCC, 0xFFFFFFFF);
                        Hold[playerid] = 19;
                        SetPlayerChatBubble(playerid, "собирает порошок", COLOR_PURPLE, 20.0, 1500);
                        GameTextForPlayer(playerid, RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~b~~h~~h~ПОРОШОК СОБРАН"), 5000, 3);
                        PlayerPlaySound(playerid, 6401);
                        NarcoSpotPlaceSave(spotid, placeid);
                    } else {
                        if (NarcoSpotPlayerInfo[playerid][nspPlaceId] == placeid && Hold[playerid] == 19)
                        {
                            NarcoPlaceInfo[spotid][placeid][npdEarned] = false;
                            NarcoPlaceInfo[spotid][placeid][npdEarnedTimes]--;
                            NarcoSpotPlayerInfo[playerid][nspPlaceId] = NARCO_SPOT_INVALID_ID;
                            NarcoSpotPlayer_SetCurrentAction(playerid, NARCO_PLAYER_ACTION_NONE);
                            RemovePlayerAttachedObject(playerid, 1);
                            RemovePlayerAttachedObject(playerid, 2);
                            Hold[playerid] = 0;
                            ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false);
                            SetPlayerChatBubble(playerid, "убирает порошок", COLOR_PURPLE, 20.0, 1500);
                            DestroyGps(playerid);
                            NarcoSpotPlacePlant(spotid, placeid, true);
                            NarcoSpot_UpdatePlaceLabel(spotid, placeid);
                            NarcoSpotPlaceSave(spotid, placeid);
                            return 1;
                        }
                        return ErrorMessage(playerid, "{FF6347}Сперва запакуйте уже собранный порошок");
                    }
                } else if (NarcoPlaceInfo[spotid][placeid][npdWaterTime] - unix <= 120) { // Добавление ингредиента
                    if (NarcoSpotPlayerInfo[playerid][nspIngredient] == NARCO_INGREDIENT_NONE || Hold[playerid] != 18) return ErrorMessage(playerid, "{ff6347}Вы должны взять в руки нужный ингредиент [ N >> Ингредиент ]");
                    if (get_invent(playerid, NarcoSpotGetIngredientThing(NarcoSpotPlayerInfo[playerid][nspIngredient]), 0) == 0) {
                        NarcoSpotPlayerInfo[playerid][nspIngredient] = NARCO_INGREDIENT_NONE;
                        return ErrorMessage(playerid, "{ff6347}У вас нет нужного ингредиента в инвентаре");
                    }
                    if (NarcoSpotPlaceIsExplode(spotid, placeid)) return ErrorMessage(playerid, "{FF6347}Вы не можете добавить ингредиент в данный момент [ Покрыто огнём ]");

                    NarcoSpot_Laboratory_GameRules(playerid, placeid, NarcoSpotPlayerInfo[playerid][nspIngredient]);         
                    TakeInvent(playerid, NarcoSpotGetIngredientThing(NarcoSpotPlayerInfo[playerid][nspIngredient]), 1, 0);
                    NarcoSpotPlayerInfo[playerid][nspIngredient] = NARCO_INGREDIENT_NONE;
                    
                    Hold[playerid] = 0;
                    RemovePlayerAttachedObject(playerid, 1);
                    ApplyAnimation(playerid, "GANGS", "DRUGS_BUY", 3.0, false, true, true, false, false);
                    SetPlayerChatBubble(playerid, "добавляет ингредиент", COLOR_PURPLE, 20.0, 1500);
                }
                return 1;
            }
        }
    }

    return 0;
}

function NarcoSpot_WaitForRipedPlace(userid, spotid, potid, earned_times)
{
    if (!NarcoSpotIsExists(spotid)) return 0;
    if (NarcoPlaceInfo[spotid][potid][npdPlayer] != userid) return 0;
    if (!NarcoPlaceInfo[spotid][potid][npdRiped]) return 0;
    if (NarcoPlaceInfo[spotid][potid][npdRentTime] == 0) return 0;
    if (NarcoPlaceInfo[spotid][potid][npdEarnedTimes] != earned_times) return 0;
    
    // Не успел собрать порошок/растение в течение десяти минут:
    new playerid = INVALID_PLAYER_ID;
    foreach (new id : Player)
    {
        if (PlayerInfo[playerid][pID] == userid)
        {
            playerid = id;
            break;
        }
    }

    if (IsOnline(playerid))
    {
        switch (NarcoSpotInfo[spotid][nstType])
        {
            case NARCO_SPOT_HANGOUT:
                SendClientMessage(playerid, COLOR_YELLOW, " SMS от Распорядителя: {99ff33}Ты походу забыл про траву, зато мы с парнями про неё не забыли - в следующий раз будешь шевелиться быстрее");
            case NARCO_SPOT_LABORATORY:
                SendClientMessage(playerid, COLOR_YELLOW, " SMS от Распорядителя: {99ff33}Ты походу забыл про порошок, зато мы с парнями про него не забыли - в следующий раз будешь шевелиться быстрее");
        }
        NarcoSpotPlayerInfo[playerid][nspRentCooldown] = gettime() + 600; // КД на 10 минут
    }

    NarcoSpotPlaceFree(spotid, potid);

    return 1;
}

function NarcoSpot_WaitForPlace(userid, spotid, placeid, earned_times)
{
    if (!NarcoSpotIsExists(spotid)) return 0; // Точки не существует
    if (NarcoPlaceInfo[spotid][placeid][npdPlayer] != userid) return 0; // Перестал быть владельцем
    if (NarcoPlaceInfo[spotid][placeid][npdRentTime] == 0) return 0; // Место не арендовано
    if (NarcoPlaceInfo[spotid][placeid][npdRiped]) return 0; // Партия готова
    if (NarcoPlaceInfo[spotid][placeid][npdWaterTime] > 0) return 0; // Полив/добавление ингридиента не требуется
    if (NarcoPlaceInfo[spotid][placeid][npdEarnedTimes] != earned_times) return 0; // Началась следующая партия
    
    // Не успел приготовить место в течение нескольких минут:
    NarcoSpotPlaceFree(spotid, placeid);

    foreach (new playerid : Player)
    {
        if (PlayerInfo[playerid][pID] == userid)
        {
            SendClientMessage(playerid, COLOR_YELLOW, " SMS от Распорядителя: {99ff33}Мы отдали твоё место тому, кому нужнее - следующий раз будешь порасторопнее");
            NarcoSpotPlayerInfo[playerid][nspRentCooldown] = gettime() + 600; // КД на 10 минут
            break;
        }
    }

    return 1;
}

stock NarcoSpot_PrepareIngredients(spotid, placeid, playerid = INVALID_PLAYER_ID)
{
    if (NarcoSpotInfo[spotid][nstType] != NARCO_SPOT_LABORATORY) return 0;
    if (placeid < 0 || placeid >= LABORATORY_PLACES) return 0;
    if (NarcoPlaceInfo[spotid][placeid][npdPlayer] == 0) return 0;
    if (NarcoPlaceInfo[spotid][placeid][npdRiped]) return 0;

    #define ingredients NarcoPlaceInfo[spotid][placeid][npdIngredients]

    ingredients = { NARCO_INGREDIENT_HYDROCHLORIC_ACID, NARCO_INGREDIENT_CAUSTIC_SODA, NARCO_INGREDIENT_HYDROGEN_CHLORIDE };
    for (new i = 0; i < 3; i++)
    {
        new temp = ingredients[i];
        new randIndex = random(3);
        ingredients[i] = ingredients[randIndex];
        ingredients[randIndex] = temp;
    }

    if (server == 0 && IsOnline(playerid))
    {
        SendClientMessage(playerid, COLOR_GRAY, "[ Тестовый сервер ]: Ингредиенты: (1: %s, 2: %s, 3: %s)",
            GetNameThing(0, NarcoSpotGetIngredientThing(ingredients[0]), 0, 0),
            GetNameThing(0, NarcoSpotGetIngredientThing(ingredients[1]), 0, 0),
            GetNameThing(0, NarcoSpotGetIngredientThing(ingredients[2]), 0, 0)
        );
    }

    #undef ingredients

    return 1;
}

function NarcoSpot_WaitForRent(spotid, placeid)
{
    if (!NarcoSpotIsExists(spotid)) return 0;
    if (NarcoPlaceInfo[spotid][placeid][npdRentTime] == 0) return 0;

    if (NarcoPlaceInfo[spotid][placeid][npdRentTime] - gettime() <= 0)
    {
        // Аренда места закончилась - освобождаем его
        NarcoSpotPlaceFree(spotid, placeid, true);
        return 1;
    }

    return SetTimerEx("NarcoSpot_WaitForRent", 10000, false, "dd", spotid, placeid);
}

DIALOG_GENERATOR:narcospot_hangout_list(playerid)
{
    new id = NarcoSpotPlayer_GetId(playerid);
    if (!NarcoSpotIsExists(id) || NarcoSpotInfo[id][nstType] != NARCO_SPOT_HANGOUT) return 0;
    if (NarcoSpotPlayerInfo[playerid][nspCurrentAction] != NARCO_PLAYER_ACTION_NONE) return ErrorMessage(playerid, "{FF6347}Вы уже заняты другим действием");

    new dialog_text[1024];
    for (new i = 0; i < MAX_NARCO_PLACES; i++)
    {
        if (NarcoPlaceInfo[id][i][npdPlayer] == 0)
        {
            format(dialog_text, sizeof(dialog_text), "%s{cccccc}Горшок №%d\t{cccccc}Место свободно\n", dialog_text, i + 1);
            continue;
        }
        
        new tyear, tmonth, tday, thour, tminute, tsecond;
        stamp2datetime(NarcoPlaceInfo[id][i][npdRentTime], tyear, tmonth, tday, thour, tminute, tsecond, 3);

        format(dialog_text, sizeof(dialog_text), "%s%sГоршок №%d\t%sМесто арендовано до %02d:%02d:%02d\n",
            dialog_text,
            NarcoPlaceInfo[id][i][npdPlayer] == PlayerInfo[playerid][pID] ? "{99ff66}" : "{ff6347}",
            i + 1,
            NarcoPlaceInfo[id][i][npdPlayer] == PlayerInfo[playerid][pID] ? "{99ff66}" : "{ff6347}",
            thour, tminute, tsecond
        );
    }
    return ShowAdvancedDialog(playerid, "narcospot_hangout_list", DIALOG_STYLE_TABLIST, "{cccccc}Аренда места", dialog_text, "Выбор", "Назад");
}

DIALOG:narcospot_laboratory_rent(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<narcospot_laboratory_list>(playerid);

    new id = NarcoSpotPlayer_GetId(playerid);
    if (!NarcoSpotIsExists(id) || NarcoSpotInfo[id][nstType] != NARCO_SPOT_LABORATORY) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в лаборатории");

    new placeid = GetDialogContextInt(playerid, "pot");
    if (!NarcoSpotIsPlaceFree(id, placeid))
    {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Кажется, это место уже арендовал кто-то другой..");
        return ShowAdvancedDialogGen<narcospot_laboratory_list>(playerid);
    }

    if (NarcoSpotPlayer_GetPlacesAmount(playerid, NARCO_SPOT_LABORATORY) >= NarcoSpotPlayer_GetMaxPlaces(playerid))
    {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу арендовать большее количество мест");
        return ShowAdvancedDialogGen<narcospot_laboratory_list>(playerid);
    }

    if (PlayerInfo[playerid][pMoney] < LABORATORY_PRICE) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня нет денег для аренды этого места");
        return ShowAdvancedDialogGen<narcospot_laboratory_list>(playerid);
    }
    oGivePlayerMoney(playerid, -LABORATORY_PRICE);

    NarcoPlaceInfo[id][placeid][npdPlayer] = PlayerInfo[playerid][pID];
    NarcoPlaceInfo[id][placeid][npdRentTime] = gettime() + NARCO_RENT_TIME * 60;
    NarcoSpotPlayer_MarkPlace(playerid, placeid);

    new fractionid = NarcoSpotInfo[id][nstFraction];
    if (fractionid >= 0) {
        if (IsAMafiaID(fractionid))
        {
            new amount = LABORATORY_PRICE / ContinentalCoinInfo[cciExchangeRate];
            GiveFractionContinentalCoins(fractionid, amount);
            OrgLog(fractionid, "rentlaboratoryspot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, "Аренда места в лаборатории (Монеты Континенталь)");
        }
        else
        {
            new amount = LABORATORY_PRICE / 10;
            bigint_add(OrganInfo[fractionid][glave], amount);
            OrgLog(fractionid, "rentlaboratoryspot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, "Аренда места в лаборатории");
        }
        OrganInfo[fractionid][gUpdate] = 1;
    }
    MoneyLog("rentlaboratoryspot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -LABORATORY_PRICE, "Арендовал место в лаборатории");

    SetTimerEx("NarcoSpot_WaitForPlace", LABORATORY_WAIT_PLACE_TIME * 60000, false, "dddd", PlayerInfo[playerid][pID], id, placeid, NarcoPlaceInfo[id][placeid][npdEarnedTimes]);
    NarcoSpot_WaitForRent(id, placeid);
    NarcoSpotPlayerInfo[playerid][nspPlaceId] = placeid;
    NarcoPlaceInfo[id][placeid][npdWaterTime] = gettime() + 120; // 2 минуты перед взрывом
    
    NarcoSpot_PrepareIngredients(id, placeid, playerid);
    NarcoSpot_UpdatePlaceLabel(id, placeid);
    NarcoSpotPlaceSave(id, placeid);

    return SuccessMessage(playerid, 
        "{99ff66}Место успешно арендовано\n\n" \
        "{cccccc}Подойдите к отмеченному месту и приготовьте рабочее место"
    );
}

DIALOG:narcospot_hangout_rent(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<narcospot_hangout_list>(playerid);
    
    new id = NarcoSpotPlayer_GetId(playerid);
    if (!NarcoSpotIsExists(id) || NarcoSpotInfo[id][nstType] != NARCO_SPOT_HANGOUT) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в притоне");

    new potid = GetDialogContextInt(playerid, "pot");
    if (!NarcoSpotIsPlaceFree(id, potid))
    {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Кажется, это место уже арендовал кто-то другой..");
        return ShowAdvancedDialogGen<narcospot_hangout_list>(playerid);
    }

    if (NarcoSpotPlayer_GetPlacesAmount(playerid, NARCO_SPOT_HANGOUT) >= NarcoSpotPlayer_GetMaxPlaces(playerid))
    {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу арендовать большее количество мест");
        return ShowAdvancedDialogGen<narcospot_hangout_list>(playerid);
    }

    if (PlayerInfo[playerid][pMoney] < HANGOUT_PRICE) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня нет денег для аренды этого места");
        return ShowAdvancedDialogGen<narcospot_hangout_list>(playerid);
    }
    oGivePlayerMoney(playerid, -HANGOUT_PRICE);

    NarcoPlaceInfo[id][potid][npdPlayer] = PlayerInfo[playerid][pID];
    NarcoPlaceInfo[id][potid][npdRentTime] = gettime() + NARCO_RENT_TIME * 60;
    CreateGps(playerid, 998.6848, 232.5698, 152.5605, .radius = NARCO_MARKS_SIZE);

    new fractionid = NarcoSpotInfo[id][nstFraction];
    if (fractionid >= 0) {
        new amount = HANGOUT_PRICE / 10;
        if (IsAMafiaID(fractionid))
        {
            OrganInfo[fractionid][goffshore] += amount;
            OrgLog(fractionid, "renthangoutspot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, "Аренда места в притоне (Офшорный счёт)");
        }
        else
        {
            bigint_add(OrganInfo[fractionid][glave], amount);
            OrgLog(fractionid, "renthangoutspot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, "Аренда места в притоне");
        }
        OrganInfo[fractionid][gUpdate] = 1;
    }
    MoneyLog("renthangoutspot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -HANGOUT_PRICE, "Арендовал место в притоне");
    
    SetTimerEx("NarcoSpot_WaitForPlace", HANGOUT_WAIT_PLACE_TIME * 60000, false, "dddd", PlayerInfo[playerid][pID], id, potid, NarcoPlaceInfo[id][potid][npdEarnedTimes]);
    NarcoSpot_WaitForRent(id, potid);
    NarcoSpotPlayerInfo[playerid][nspPlaceId] = potid;
    NarcoSpotPlaceSave(id, potid);

    return SuccessMessage(playerid, 
        "{99ff66}Место успешно арендовано\n\n" \
        "{cccccc}Подойдите к отмеченному месту и приготовьте почву для посадки"
    );
}

DIALOG:narcospot_hangout_placemenu(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<narcospot_hangout_list>(playerid);

    if (!NarcoSpotPlayer_IsInside(playerid, NARCO_SPOT_HANGOUT)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в притоне");

    new spotid = NarcoSpotPlayer_GetId(playerid);
    new potid = GetDialogContextInt(playerid, "potid");
    switch (listitem)
    {
        case 0: return NarcoSpotPlayer_MarkPlace(playerid, potid);
        case 1: { // Продление аренды
            new unix = gettime();
            if (NarcoPlaceInfo[spotid][potid][npdRentTime] - unix > 300) {
                SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Продлить аренду можно только когда до её конца осталось менее 5 минут");
                return ShowAdvancedDialogGen<narcospot_hangout_list>(playerid);
            }
            NarcoPlaceInfo[spotid][potid][npdRentTime] = unix + NARCO_RENT_TIME * 60;
            SuccessMessage(playerid, "{99ff66}Аренда успешно продлена");
        }
        case 2: { // Отмена аренды
            NarcoPlaceInfo[spotid][potid][npdPlayer] = 0;
            NarcoPlaceInfo[spotid][potid][npdRentTime] = 0;
            NarcoPlaceInfo[spotid][potid][npdWaterTime] = 0;
            NarcoSpotPlaceFree(spotid, potid);
            DestroyGps(playerid);
            SuccessMessage(playerid, "{99ff66}Аренда успешно отменена");
        }
    }

    return 1;
}

DIALOG:narcospot_hangout_list(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "narcospot_hangout");

    new id = NarcoSpotPlayer_GetId(playerid);
    if (!NarcoSpotIsExists(id) || NarcoSpotInfo[id][nstType] != NARCO_SPOT_HANGOUT) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в притоне");
    
    new potid = listitem;
    if (gettime() < NarcoSpotPlayerInfo[playerid][nspRentCooldown]) {
        FORMAT:error("{FF6347}В данный момент вам недоступна аренда места [Осталось: %d минут]", (NarcoSpotPlayerInfo[playerid][nspRentCooldown] - gettime()) / 60);
        return ErrorMessage(playerid, error);
    }
    if (NarcoPlaceInfo[id][potid][npdPlayer] != 0) {
        if (PlayerInfo[playerid][pID] == NarcoPlaceInfo[id][potid][npdPlayer])
        {
            SetDialogContextInt(playerid, "potid", potid);
            return ShowAdvancedDialog(playerid, "narcospot_hangout_placemenu", DIALOG_STYLE_LIST, "{cccccc}Меню",
                "{ff9000}Отметить место\n" \
                "{99ff66}Продлить аренду\n" \
                "{ff6347}Отменить аренду\n",

                "Выбор", "Назад"
            );
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Это место уже кто-то арендует");
            return ShowAdvancedDialogGen<narcospot_hangout_list>(playerid);
        }
    }
    SetDialogContextInt(playerid, "pot", potid);

    ShowAdvancedDialog(playerid, "narcospot_hangout_rent", DIALOG_STYLE_MSGBOX, "{cccccc}Подтверждение аренды",
        "{cccccc}Вы действительно хотите арендовать выбранное место?\n" \
        "Цена аренды: {99ff66}"#HANGOUT_PRICE"$",

        "Да", "Назад"
    );

    return 1;
}

DIALOG_GENERATOR:narcospot_laboratory_list(playerid)
{
    new id = NarcoSpotPlayer_GetId(playerid);
    if (!NarcoSpotIsExists(id) || NarcoSpotInfo[id][nstType] != NARCO_SPOT_LABORATORY) return 0;
    if (NarcoSpotPlayerInfo[playerid][nspCurrentAction] != NARCO_PLAYER_ACTION_NONE) return ErrorMessage(playerid, "{FF6347}Вы уже заняты другим действием");

    new dialog_text[1024];
    for (new i = 0; i < LABORATORY_PLACES; i++)
    {
        if (NarcoPlaceInfo[id][i][npdPlayer] == 0)
        {
            format(dialog_text, sizeof(dialog_text), "%s{cccccc}Место №%d\t{cccccc}Место свободно\n", dialog_text, i + 1);
            continue;
        }
        
        new tyear, tmonth, tday, thour, tminute, tsecond;
        stamp2datetime(NarcoPlaceInfo[id][i][npdRentTime], tyear, tmonth, tday, thour, tminute, tsecond, 3);

        format(dialog_text, sizeof(dialog_text), "%s%sМесто №%d\t%sМесто арендовано до %02d:%02d:%02d\n",
            dialog_text,
            NarcoPlaceInfo[id][i][npdPlayer] == PlayerInfo[playerid][pID] ? "{99ff66}" : "{ff6347}",
            i + 1,
            NarcoPlaceInfo[id][i][npdPlayer] == PlayerInfo[playerid][pID] ? "{99ff66}" : "{ff6347}",
            thour, tminute, tsecond
        );
    }
    return ShowAdvancedDialog(playerid, "narcospot_laboratory_list", DIALOG_STYLE_TABLIST, "{cccccc}Аренда места", dialog_text, "Выбор", "Назад");
}

DIALOG:narcospot_laboratory_placemenu(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<narcospot_laboratory_list>(playerid);

    if (!NarcoSpotPlayer_IsInside(playerid, NARCO_SPOT_LABORATORY)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в лаборатории");

    new spotid = NarcoSpotPlayer_GetId(playerid);
    new placeid = GetDialogContextInt(playerid, "potid");
    switch (listitem)
    {
        case 0: return NarcoSpotPlayer_MarkPlace(playerid, placeid);
        case 1: { // Продление аренды
            new unix = gettime();
            if (NarcoPlaceInfo[spotid][placeid][npdRentTime] - unix > 300) {
                SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Продлить аренду можно только когда до её конца осталось менее 5 минут");
                return ShowAdvancedDialogGen<narcospot_laboratory_list>(playerid);
            }
            NarcoPlaceInfo[spotid][placeid][npdRentTime] = unix + NARCO_RENT_TIME * 60;
            SuccessMessage(playerid, "{99ff66}Аренда успешно продлена");
        }
        case 2: { // Отмена аренды
            NarcoPlaceInfo[spotid][placeid][npdPlayer] = 0;
            NarcoPlaceInfo[spotid][placeid][npdRentTime] = 0;
            NarcoPlaceInfo[spotid][placeid][npdWaterTime] = 0;
            NarcoSpotPlaceFree(spotid, placeid);
            DestroyGps(playerid);
            SuccessMessage(playerid, "{99ff66}Аренда успешно отменена");
        }
    }

    return 1;
}

DIALOG:narcospot_laboratory_list(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "narcospot_laboratory");

    new id = NarcoSpotPlayer_GetId(playerid);
    if (!NarcoSpotIsExists(id) || NarcoSpotInfo[id][nstType] != NARCO_SPOT_LABORATORY) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в лаборатории");
    
    new potid = listitem;
    if (gettime() < NarcoSpotPlayerInfo[playerid][nspRentCooldown]) {
        FORMAT:error("{FF6347}В данный момент вам недоступна аренда места [Осталось: %d минут]", (NarcoSpotPlayerInfo[playerid][nspRentCooldown] - gettime()) / 60);
        return ErrorMessage(playerid, error);
    }
    if (NarcoPlaceInfo[id][potid][npdPlayer] != 0) {
        if (PlayerInfo[playerid][pID] == NarcoPlaceInfo[id][potid][npdPlayer])
        {
            SetDialogContextInt(playerid, "potid", potid);
            return ShowAdvancedDialog(playerid, "narcospot_laboratory_placemenu", DIALOG_STYLE_LIST, "{cccccc}Меню",
                "{ff9000}Отметить место\n" \
                "{99ff66}Продлить аренду\n" \
                "{ff6347}Отменить аренду\n",

                "Выбор", "Назад"
            );
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Это место уже кто-то арендует");
            return ShowAdvancedDialogGen<narcospot_hangout_list>(playerid);
        }
    }
    SetDialogContextInt(playerid, "pot", potid);
    
    if (get_invent(playerid, 274, 0) == 0 ||
        get_invent(playerid, 275, 0) == 0 ||
        get_invent(playerid, 276, 0) == 0)
    {
        CreateGps(playerid, 1787.2097, -1136.6089, 24.1105, 0, 0); // Химический завод
        return ErrorMessage(playerid,
            "{FF6347}У вас нет как минимум одного из ингредиентов\n" \
            "[ Каустическая сода, Соляная кислота, Хлористый водород ]\n\n" \
            \
            "{FF6347}Ингредиенты можно приобрести у Химического Завода\n\n" \
            \
            "{cccccc}На карте была установлена метка с его местоположением"
        );
    }

    if (get_invent(playerid, 273, 0) == 0)
    {
        ShowAdvancedDialog(playerid, "narcospot_laboratory_rent", DIALOG_STYLE_MSGBOX, "{cccccc}Аренда мест",
            "{cccccc}Вы уверены, что хотите продолжить аренду места?\n" \
            "Цена аренды: {99ff66}"#LABORATORY_PRICE"$\n\n" \
            \
            "{ff6347}У вас нет поваренной книги Анархиста {cccccc}[ Можно приобрести у Хэнка ]\n" \
            "{ff6347}[!] {cccccc}Без книги вы не будете знать порядок ингредиентов в процессе приготовления",

            "Да", "Назад"
        );
    }
    else
    {
        ShowAdvancedDialog(playerid, "narcospot_laboratory_rent", DIALOG_STYLE_MSGBOX, "{cccccc}Подтверждение аренды",
            "{cccccc}Вы действительно хотите арендовать выбранное место?\n" \
            "Цена аренды: {99ff66}"#LABORATORY_PRICE"$",

            "Да", "Назад"
        );
    }

    return 1;
}

DIALOG:narcospot_laboratory_info(playerid, response, listitem, const inputtext[])
{
    return ShowAdvancedDialog(playerid, "narcospot_laboratory");
}

DIALOG:narcospot_hangout_info(playerid, response, listitem, const inputtext[])
{
    return ShowAdvancedDialog(playerid, "narcospot_hangout");
}

DIALOG:narcospot_hangout_knife(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "narcospot_hangout");
    if (get_invent4(playerid, 97, 0) > 0) return ErrorMessage(playerid, "{FF6347}У вас уже есть нож");

    new price = getThingPriceGos(97, 0) * 2;
    if (PlayerInfo[playerid][pMoney] < price) return ErrorMessage(playerid, "{FF6347}У вас недостаточно денег для покупки ножа");

    new put_inva = GiveThingPlayer(playerid, 97, 1, 0, 0, 0, 0);
    if (put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");

    oGivePlayerMoney(playerid, -price);
    MoneyLog("hangout_buyknife", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, "Покупка ножа для срезания травы");

    return 1;
}

DIALOG:narcospot_laboratory(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;
    if (!NarcoSpotPlayer_IsInside(playerid, NARCO_SPOT_LABORATORY)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в лаборатории");

    /*
        3. Оплата аренды проходит на 1 час, в одной лаборатории находится всего 2 стола
            - Если игрок арендует стол и не будет ничего готовить в течение 10 минут -
            аренда убирается, если игрок захочет продлить аренду - он может это сделать
            в течение 5 минут после того как она закончилась
            (также защита от выхода из игры)
        4. Варка порошка:
            - Раз в 7 минут добавлять ингредиент:
                - Каустическая сода
                - Соляная кислота
                - Хлористый водород
            
                Какие ингредиенты добавлять можно узнать с помощью специальной
                "поваренной книги анархиста" (её можно приобрести у Хэнка,
                с добавлением террористов - у них)

                Ингредиенты будут меняться местами и только книга поможет узнать
                правильный, если игрок не будет добавлять ничего в течение 2 минут -
                ингредиенты испортятся и он получит некачественный синий порошок

                Если он добавить неверный - ингредиенты сгорят и придется начать
                готовку заново

            - Варка одной партии занимает 21-23 минуты, итого за одну аренду человек
            приготовит 2-3 партии, но он может запросто её продлевать
                Если захочет отменить - может сделать это, но от него потребуют
                компенсацию за оставшееся время
            
            - После приготовления подойти к специальному столику и упаковать синий
            порошок, в упаковке: 15 использований
    */
    switch (listitem)
    {
        case 0: {
            ShowAdvancedDialog(playerid, "narcospot_laboratory_info", DIALOG_STYLE_MSGBOX, " ",
                "{0088ff}Информация о лабораториях{cccccc}\n\n" \
                \
                "Лаборатории служат местом для приготовления синего порошка, предоставляя возможность аренды мест и необходимые ингредиенты\n" \
                "Контролирующая организация получает вырученные деньги в полном размере, но может их потратить\n" \
                "только на ингредиенты для готовки и прочие специальные услуги\n\n" \
                \
                "Приготовление синего порошка:\n" \
                "    {ff9000}1. Оплатить аренду стола{cccccc}\n" \
                "        - Арендовать одно из столов [Общее количество: 6]\n" \
                "        - Одновременно можно оплатить не более 1 места\n" \
                "    {ff9000}2. Приготовление порошка{cccccc}\n" \
                "        - В течение 7 минут добавлять ингредиенты: каустическая сода, соляная кислота, хлористый водород\n" \
                "        - Если вы не добавите ингредиент в течение 2 минут - порошок станет некачественным\n" \
                "        - Если вы добавите неверный ингредиент - порошок сгорит и придется начать заново\n" \
                "        - Верные ингредиенты можно узнать с помощью специальной книги: \"Поваренная книга Анархиста\"\n" \
                "        - Книга является нелегальной и может быть приобретена у Хэнка\n" \
                "    {ff9000}3. Упаковка порошка{cccccc}\n" \
                "        - После приготовления подойти к специальному столику и упаковать порошок\n" \
                "        - После этого вы получите запакованный порошок: 20 использований\n",

                "Назад"
            );
        }
        case 1: return ShowAdvancedDialogGen<narcospot_laboratory_list>(playerid);
        default: return 0;
    }

    return 1;
}

DIALOG:narcospot_hangout(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;
    if (!NarcoSpotPlayer_IsInside(playerid, NARCO_SPOT_HANGOUT)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в притоне");

    switch (listitem)
    {
        case 0: {
            ShowAdvancedDialog(playerid, "narcospot_hangout_info", DIALOG_STYLE_MSGBOX, " ",
                "{0088ff}Информация о притонах{cccccc}\n\n" \
                \
                "Притоны служат местом выращивания травы, предоставляя возможность аренды мест и необходимые ингредиенты\n" \
                "Контролирующая организация получает вырученные деньги в полном размере, но может их потратить\n" \
                "только на ингредиенты для готовки и прочие специальные услуги\n\n" \
                \
                "Выращивание травы:\n" \
                "    {ff9000}1. Оплатить аренду горшка{cccccc}\n" \
                "        - Арендовать один из горшков [Общее количество: 20]\n" \
                "        - Одновременно можно оплатить не более 2 горшков {7474da}(+1 с Platinum VIP){cccccc}\n" \
                "        - На установку каждого из оплаченных горшков даётся 5 минут, вам необходимо:\n" \
                "            - Взять землю у специального места в притоне, засыпать её в горшок,\n" \
                "            после чего засыпать семена и взять канистру с водой, чтобы их полить\n" \
                "            - Если вы не успеете - вам откажут в аренде и запретят пользоваться арендой\n" \
                "            некоторый промежуток времени\n" \
                "    {ff9000}2. Своевременно поливать установленный горшок{cccccc}\n" \
                "        - Нужно поливать каждые 5 минут [Количество поливаний: 5]\n" \
                "        - Если вы пропустите полив травы - она очень быстро засохнет\n" \
                "    {ff9000}3. Сбор травы{cccccc}\n" \
                "        - Нужно срезать и упаковать на специальном столе\n" \
                "        - После этого вы получите запакованную траву (10 использований)\n",

                "Назад"
            );
        }
        case 1: {
            ShowAdvancedDialog(playerid, "narcospot_hangout_knife", DIALOG_STYLE_MSGBOX, "{cccccc}Покупка",
                "{99ff66}Вы действительно хотите приобрести нож?\n\n" \
                "{cccccc}* Он понадобится вам для срезания травы",
                
                "Да", "Назад"
            );
        }
        case 2: return ShowAdvancedDialogGen<narcospot_hangout_list>(playerid);
        default: return 0;
    }

    return 1;
}

stock NarcoSpotIsExists(id)
{
    if (id < 0 || id > MAX_NARCO_SPOTS) return 0;

    return !(NarcoSpotInfo[id][nstPosition][0] == 0.0 && NarcoSpotInfo[id][nstPosition][1] == 0.0 && NarcoSpotInfo[id][nstPosition][2] == 0.0); 
}

stock ClickTextDraw_LaboratoryGame(playerid, PlayerText: playertextid)
{
    if (NarcoSpotPlayer_GetType(playerid) != _:NARCO_SPOT_LABORATORY) return 0;

    if (playertextid == LaboratoryGame_PTD[playerid][7] || playertextid == LaboratoryGame_PTD[playerid][8])
    {
        if (gettime() - NarcoSpotPlayerInfo[playerid][nspLaboratoryGameStartTime] < LABORATORY_GAME_PREPARE_TIME) return 1;

        const Float: speed = 0.5;

        new Float: x, Float: y;
        PlayerTextDrawGetPos(playerid, LaboratoryGame_PTD[playerid][9], x, y);
        PlayerTextDrawSetPos(playerid, LaboratoryGame_PTD[playerid][9], x - speed, y);
        PlayerTextDrawGetPos(playerid, LaboratoryGame_PTD[playerid][10], x, y);
        PlayerTextDrawSetPos(playerid, LaboratoryGame_PTD[playerid][10], x - speed, y);
        for (new i = 9; i <= 10; i++) PlayerTextDrawShow(playerid, LaboratoryGame_PTD[playerid][i]);
    }

    return 1;
}

function NarcoSpot_Laboratory_GameUpdate(playerid, placeid, e_NarcoSpotIngredient: ingredient)
{
    if (!IsOnline(playerid)) return 0;
    if (NarcoSpotPlayer_GetType(playerid) != _:NARCO_SPOT_LABORATORY) return NarcoSpot_Laboratory_GameStart(playerid, .status = false);
    
    new spotid = NarcoSpotPlayer_GetId(playerid);
    if (!NarcoSpotIsExists(spotid)) return NarcoSpot_Laboratory_GameStart(playerid, .status = false);
    if (NarcoPlaceInfo[spotid][placeid][npdPlayer] != PlayerInfo[playerid][pID]) return NarcoSpot_Laboratory_GameStart(playerid, .status = false);
    
    const Float: speed = 0.2;
    new Float: x, Float: y;
    if (gettime() - NarcoSpotPlayerInfo[playerid][nspLaboratoryGameStartTime] >= LABORATORY_GAME_PREPARE_TIME)
    {
        PlayerTextDrawGetPos(playerid, LaboratoryGame_PTD[playerid][9], x, y);
        PlayerTextDrawSetPos(playerid, LaboratoryGame_PTD[playerid][9], x + speed, y);
        PlayerTextDrawGetPos(playerid, LaboratoryGame_PTD[playerid][10], x, y);
        PlayerTextDrawSetPos(playerid, LaboratoryGame_PTD[playerid][10], x + speed, y);

        FORMAT:elapsed("Oc¦aћoc©:_%s", fine_time(NarcoSpotPlayerInfo[playerid][nspLaboratoryGameEndTime] - gettime()));
        PlayerTextDrawSetString(playerid, LaboratoryGame_PTD[playerid][4], elapsed);
    }
    
    new Float: centerBoxStart, Float: centerBoxEnd;
    PlayerTextDrawGetPos(playerid, LaboratoryGame_PTD[playerid][1], centerBoxStart, centerBoxEnd);
    PlayerTextDrawGetTextSize(playerid, LaboratoryGame_PTD[playerid][1], x, y);
    centerBoxEnd = centerBoxStart + x;

    new Float: scaleStart, Float: scaleEnd;
    PlayerTextDrawGetPos(playerid, LaboratoryGame_PTD[playerid][10], scaleStart, scaleEnd);
    PlayerTextDrawGetTextSize(playerid, LaboratoryGame_PTD[playerid][10], x, y);
    scaleEnd = scaleStart + x;

    if (scaleStart < centerBoxStart || scaleEnd > centerBoxEnd) {
        NarcoSpotPlayerInfo[playerid][nspLaboratoryGameHealth] -= 4.0;
    } else {
        if (NarcoSpotPlayerInfo[playerid][nspLaboratoryGameHealth] < 100.0) {
            NarcoSpotPlayerInfo[playerid][nspLaboratoryGameHealth] += 0.25;
        }
    }

    if (NarcoSpotPlayerInfo[playerid][nspLaboratoryGameHealth] <= 0.0) {
        ErrorMessage(playerid, "{FF6347}Вы не смогли проконтролировать температуру вещества");
        NarcoSpotPlaceExplode(spotid, placeid);
        return NarcoSpot_Laboratory_GameStart(playerid, .status = false);
    }

    // Обновляем
    for (new i = 9; i <= 10; i++) PlayerTextDrawShow(playerid, LaboratoryGame_PTD[playerid][i]);

    if (NarcoSpotPlayerInfo[playerid][nspPumpCooldown] - gettime() <= 0) {
        NarcoSpotPlayerInfo[playerid][nspPumpCooldown] = gettime() + 5;
        ApplyAnimation(playerid, "INT_HOUSE", "wash_up", 3.5, true, false, false, false, false);
    }

    // Прошел игру
    if (NarcoSpotPlayerInfo[playerid][nspLaboratoryGameEndTime] - gettime() <= 0)
    {
        new ingredientid = NarcoPlaceInfo[spotid][placeid][npdWaterings];
        NarcoPlaceInfo[spotid][placeid][npdWaterTime] = gettime() + (server == 0 ? LABORATORY_INGREDIENT_TIME_TEST : LABORATORY_INGREDIENT_TIME) + 120;
        NarcoPlaceInfo[spotid][placeid][npdWaterings]++;

        if (!NarcoSpotPlayer_IsInside(playerid, NARCO_SPOT_LABORATORY)) return NarcoSpot_Laboratory_GameStart(playerid, .status = false);
        if (ingredientid < 0 || ingredientid >= 3) return NarcoSpot_Laboratory_GameStart(playerid, .status = false); // Несуществующий ингредиент (на всякий случай)
        
        if (_:ingredient != NarcoPlaceInfo[spotid][placeid][npdIngredients][ingredientid])
        {
            if (!NarcoPlaceInfo[spotid][placeid][npdDummyPowder])
            {
                // Первый неверный ингредиент
                NarcoPlaceInfo[spotid][placeid][npdDummyPowder] = true;
                SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я точно что-то сделал не так, теперь этот порошок не выйдет качественным");
                PlayerPlaySound(playerid, 4203);
                update_ability(playerid, 7, 10);
            } else {
                // Второй неверный ингредиент
                NarcoSpotPlaceExplode(spotid, placeid);
                NarcoSpot_UpdatePlaceLabel(spotid, placeid);
                PlayerPlaySound(playerid, 4203);
                SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чёрт.. опять неверно? Придётся начать всё заново");
                return NarcoSpot_Laboratory_GameStart(playerid, .status = false);
            }
        } else {
            // Верный ингредиент
            PlayerPlaySound(playerid, 6401);
            update_ability(playerid, 7, 20);
        }

        if (NarcoPlaceInfo[spotid][placeid][npdWaterings] >= 3)
        {
            SetTimerEx("NarcoSpot_WaitForRipedPlace", 600000, false, "dddd", PlayerInfo[playerid][pID], spotid, placeid, NarcoPlaceInfo[spotid][placeid][npdEarnedTimes]);
            NarcoSpotPlacePlant(spotid, placeid, true);
            NarcoPlaceInfo[spotid][placeid][npdRiped] = true;
            SuccessMessage(playerid, "{99ff66}Порошок готов!\n\n{cccccc}Теперь вам необходимо взять его [ ALT ]");
        }
        NarcoSpot_UpdatePlaceLabel(spotid, placeid);
        return NarcoSpot_Laboratory_GameStart(playerid, .status = false);
    }

    return SetTimerEx("NarcoSpot_Laboratory_GameUpdate", 70, false, "ddd", playerid, placeid, ingredient);
}

stock NarcoSpotPlaceIsExplode(spotid, placeid)
{
    if (!NarcoSpotIsExists(spotid)) return 0;
    if (NarcoSpotInfo[spotid][nstType] != NARCO_SPOT_LABORATORY) return 0;
    if (placeid < 0 || placeid >= LABORATORY_PLACES) return 0;

    return GetDynamicObjectVirtualWorld(NarcoPlaceExplodeObjects[spotid][placeid][0]) == NarcoSpot_GetVirtualWorld(spotid);
}

function NarcoSpotPlaceHideExplode(spotid, placeid)
{
    SetDynamicObjectVirtualWorld(NarcoPlaceExplodeObjects[spotid][placeid][0], 228);
    SetDynamicObjectVirtualWorld(NarcoPlaceExplodeObjects[spotid][placeid][1], 228);

    foreach (new playerid : Player)
    {
        new Float: x, Float: y, Float: z;
        GetDynamicObjectPos(NarcoPlaceExplodeObjects[spotid][placeid][0], x, y, z);
        if (!IsPlayerInRangeOfPoint(playerid, 7.0, x, y, z)) continue;
        if (!NarcoSpotPlayer_IsInside(playerid, .id = spotid)) continue;

        Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
    }

    return 1;
}

stock NarcoSpotPlaceExplode(spotid, placeid)
{
    if (!NarcoSpotIsExists(spotid)) return 0;
    if (NarcoSpotInfo[spotid][nstType] != NARCO_SPOT_LABORATORY) return 0;
    if (placeid < 0 || placeid >= LABORATORY_PLACES) return 0;

    NarcoPlaceInfo[spotid][placeid][npdDummyPowder] = false;
    NarcoPlaceInfo[spotid][placeid][npdWaterTime] = gettime() + 120;
    NarcoPlaceInfo[spotid][placeid][npdWaterings] = 0;
    
    SetDynamicObjectVirtualWorld(NarcoPlaceExplodeObjects[spotid][placeid][0], NarcoSpot_GetVirtualWorld(spotid));
    SetDynamicObjectVirtualWorld(NarcoPlaceExplodeObjects[spotid][placeid][1], NarcoSpot_GetVirtualWorld(spotid));

    foreach (new playerid : Player)
    {
        new Float: x, Float: y, Float: z;
        GetDynamicObjectPos(NarcoPlaceExplodeObjects[spotid][placeid][0], x, y, z);
        if (!IsPlayerInRangeOfPoint(playerid, 7.0, x, y, z)) continue;
        if (!NarcoSpotPlayer_IsInside(playerid, .id = spotid)) continue;

        new Float: distance = GetDistanceBetweenPoints2D(x, y, Protect_X[playerid], Protect_Y[playerid]);
        new Float: damage = 60.0 * max(0.0, 1.0 - distance / 3.0);

        if (damage > 0.0) ACSetPlayerHealth(playerid, HealthAC[playerid] - damage);

        PlayerPlaySound(playerid, 17003, x, y, z);
        Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
    }

    SetTimerEx("NarcoSpotPlaceHideExplode", 5000, false, "dd", spotid, placeid);
    return 1;
}

DIALOG:narcospot_laboratory_gamerules(playerid, response, listitem, const inputtext[])
{
    new placeid = GetDialogContextInt(playerid, "placeid");
    new e_NarcoSpotIngredient: ingredient = e_NarcoSpotIngredient: GetDialogContextInt(playerid, "ingredient");
    ClearDialogContext(playerid);

    NarcoSpotPlayerInfo[playerid][nspLaboratoryGameRules] = true;
    return NarcoSpot_Laboratory_GameStart(playerid, placeid, ingredient);
}

stock NarcoSpot_Laboratory_GameRules(playerid, placeid, e_NarcoSpotIngredient: ingredient)
{
    if (!NarcoSpotPlayer_IsInside(playerid, NARCO_SPOT_LABORATORY)) return 0;
    if (NarcoSpotPlayerInfo[playerid][nspLaboratoryGameRules]) return NarcoSpot_Laboratory_GameStart(playerid, placeid, ingredient);
    
    SetDialogContextInt(playerid, "placeid", placeid);
    SetDialogContextInt(playerid, "ingredient", ingredient);

    ShowAdvancedDialog(playerid, "narcospot_laboratory_gamerules", DIALOG_STYLE_MSGBOX, "{cccccc}Правила мини-игры",
        "{cccccc}Твоя задача — {ff9000}удерживать индикатор в центре шкалы{cccccc}.\n" \
        "{cccccc}Индикатор {ff9000}непрерывно смещается вправо{cccccc}, а каждое нажатие кнопки отодвигает его влево.\n\n" \
        \
        "{cccccc}С каждым уровнем {0088ff}навыка химика{cccccc} зона, в которой индикатор\n" \
        "считается «удержанным», {99ff66}увеличивается{cccccc}, упрощая управление.\n\n" \
        \
        "{cccccc}У тебя есть {99ff66}2 секунды{cccccc} на подготовку перед тем, как шкала начнёт двигаться.\n",

        "Запуск"
    );

    return 1;
}

// Запускает мини-игру при добавлении ингредиента / закрыть: NarcoSpot_Laboratory_GameStart(playerid, .status = false)
stock NarcoSpot_Laboratory_GameStart(playerid, placeid = NARCO_SPOT_INVALID_ID, e_NarcoSpotIngredient: ingredient = NARCO_INGREDIENT_NONE, bool: status = true)
{
    for (new i = 0; i < sizeof(LaboratoryGame_PTD[]); i++)
    {
        PlayerTextDrawDestroy(playerid, LaboratoryGame_PTD[playerid][i]);
        LaboratoryGame_PTD[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
    }
    ApplyAnimation(playerid, "PED", "facanger", 4.0, false, true, true, true, true);
    NarcoSpotPlayerInfo[playerid][nspLaboratoryGameHealth] = 0.0;
    CancelSelectTextDraw(playerid);

    if (!status) return 0;

    new spotid = NarcoSpotPlayer_GetId(playerid);

    if (!NarcoSpotPlayer_IsInside(playerid, NARCO_SPOT_LABORATORY)) return 0;

    // Подготовка текстдравов и запуск игры
    LaboratoryGame_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 197.6665, 362.4075, "LD_SPAC:white"); // пусто
    PlayerTextDrawTextSize(playerid, LaboratoryGame_PTD[playerid][0], 217.0000, 30.0000);
    PlayerTextDrawAlignment(playerid, LaboratoryGame_PTD[playerid][0], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, LaboratoryGame_PTD[playerid][0], 255);
    PlayerTextDrawBackgroundColour(playerid, LaboratoryGame_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, LaboratoryGame_PTD[playerid][0], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, LaboratoryGame_PTD[playerid][0], false);
    PlayerTextDrawSetShadow(playerid, LaboratoryGame_PTD[playerid][0], false);

    LaboratoryGame_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 201.2332, 365.3112, "LD_SPAC:white"); // пусто
    PlayerTextDrawTextSize(playerid, LaboratoryGame_PTD[playerid][2], 42.0000, 24.0000);
    PlayerTextDrawAlignment(playerid, LaboratoryGame_PTD[playerid][2], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, LaboratoryGame_PTD[playerid][2], 512819199);
    PlayerTextDrawBackgroundColour(playerid, LaboratoryGame_PTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, LaboratoryGame_PTD[playerid][2], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, LaboratoryGame_PTD[playerid][2], false);
    PlayerTextDrawSetShadow(playerid, LaboratoryGame_PTD[playerid][2], false);

    LaboratoryGame_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 243.2332, 365.3112, "LD_SPAC:white"); // bluebox
    PlayerTextDrawTextSize(playerid, LaboratoryGame_PTD[playerid][3], 61.0000, 24.0000);
    PlayerTextDrawAlignment(playerid, LaboratoryGame_PTD[playerid][3], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, LaboratoryGame_PTD[playerid][3], 515244031);
    PlayerTextDrawBackgroundColour(playerid, LaboratoryGame_PTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, LaboratoryGame_PTD[playerid][3], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, LaboratoryGame_PTD[playerid][3], false);
    PlayerTextDrawSetShadow(playerid, LaboratoryGame_PTD[playerid][3], false);

    LaboratoryGame_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 197.3333, 349.7037, "Oc¦aћoc©:_00:20"); // remains
    PlayerTextDrawLetterSize(playerid, LaboratoryGame_PTD[playerid][4], 0.2459, 1.2515);
    PlayerTextDrawTextSize(playerid, LaboratoryGame_PTD[playerid][4], 12.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, LaboratoryGame_PTD[playerid][4], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, LaboratoryGame_PTD[playerid][4], -1);
    PlayerTextDrawBackgroundColour(playerid, LaboratoryGame_PTD[playerid][4], 255);
    PlayerTextDrawFont(playerid, LaboratoryGame_PTD[playerid][4], TEXT_DRAW_FONT: 1);
    PlayerTextDrawSetProportional(playerid, LaboratoryGame_PTD[playerid][4], true);
    PlayerTextDrawSetShadow(playerid, LaboratoryGame_PTD[playerid][4], true);

    LaboratoryGame_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 304.3659, 365.3408, "LD_SPAC:white"); // redbox
    PlayerTextDrawTextSize(playerid, LaboratoryGame_PTD[playerid][5], 65.0000, 24.0000);
    PlayerTextDrawAlignment(playerid, LaboratoryGame_PTD[playerid][5], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, LaboratoryGame_PTD[playerid][5], -92245505);
    PlayerTextDrawBackgroundColour(playerid, LaboratoryGame_PTD[playerid][5], 255);
    PlayerTextDrawFont(playerid, LaboratoryGame_PTD[playerid][5], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, LaboratoryGame_PTD[playerid][5], false);
    PlayerTextDrawSetShadow(playerid, LaboratoryGame_PTD[playerid][5], false);

    LaboratoryGame_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 369.5997, 365.3259, "LD_SPAC:white"); // пусто
    PlayerTextDrawTextSize(playerid, LaboratoryGame_PTD[playerid][6], 42.0000, 24.0000);
    PlayerTextDrawAlignment(playerid, LaboratoryGame_PTD[playerid][6], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, LaboratoryGame_PTD[playerid][6], -1204406529);
    PlayerTextDrawBackgroundColour(playerid, LaboratoryGame_PTD[playerid][6], 255);
    PlayerTextDrawFont(playerid, LaboratoryGame_PTD[playerid][6], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, LaboratoryGame_PTD[playerid][6], false);
    PlayerTextDrawSetShadow(playerid, LaboratoryGame_PTD[playerid][6], false);

    LaboratoryGame_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 416.2333, 362.4074, "LD_SPAC:white"); // downbox
    PlayerTextDrawTextSize(playerid, LaboratoryGame_PTD[playerid][7], 28.0000, 30.0000);
    PlayerTextDrawAlignment(playerid, LaboratoryGame_PTD[playerid][7], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, LaboratoryGame_PTD[playerid][7], 146);
    PlayerTextDrawBackgroundColour(playerid, LaboratoryGame_PTD[playerid][7], 255);
    PlayerTextDrawFont(playerid, LaboratoryGame_PTD[playerid][7], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, LaboratoryGame_PTD[playerid][7], false);
    PlayerTextDrawSetShadow(playerid, LaboratoryGame_PTD[playerid][7], false);
    PlayerTextDrawSetSelectable(playerid, LaboratoryGame_PTD[playerid][7], true);

    LaboratoryGame_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 420.8999, 368.2147, "LD_BEAT:down"); // downbox
    PlayerTextDrawTextSize(playerid, LaboratoryGame_PTD[playerid][8], 19.0000, 20.0000);
    PlayerTextDrawAlignment(playerid, LaboratoryGame_PTD[playerid][8], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, LaboratoryGame_PTD[playerid][8], 9764863);
    PlayerTextDrawBackgroundColour(playerid, LaboratoryGame_PTD[playerid][8], 255);
    PlayerTextDrawFont(playerid, LaboratoryGame_PTD[playerid][8], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, LaboratoryGame_PTD[playerid][8], false);
    PlayerTextDrawSetShadow(playerid, LaboratoryGame_PTD[playerid][8], false);
    PlayerTextDrawSetSelectable(playerid, LaboratoryGame_PTD[playerid][8], true);

    new ability = get_ability(playerid, 7);
    new Float: min_center_box = 6.0, Float: max_center_box = 25.0;
    new Float: center_box_width = min_center_box + (max_center_box - min_center_box) * ((ability - 1) / 9.0);
    new Float: center_box_x = 305.8996 - center_box_width / 2.0;

    LaboratoryGame_PTD[playerid][1] = CreatePlayerTextDraw(playerid, center_box_x, 365.3112, "LD_SPAC:white"); // centerbox
    PlayerTextDrawTextSize(playerid, LaboratoryGame_PTD[playerid][1], center_box_width, 24.0000);
    PlayerTextDrawAlignment(playerid, LaboratoryGame_PTD[playerid][1], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, LaboratoryGame_PTD[playerid][1], -70685953);
    PlayerTextDrawBackgroundColour(playerid, LaboratoryGame_PTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, LaboratoryGame_PTD[playerid][1], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, LaboratoryGame_PTD[playerid][1], false);
    PlayerTextDrawSetShadow(playerid, LaboratoryGame_PTD[playerid][1], false);

    LaboratoryGame_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 305.6665, 362.8220, "LD_SPAC:white"); // scale
    PlayerTextDrawTextSize(playerid, LaboratoryGame_PTD[playerid][9], 3.0000, 29.0000);
    PlayerTextDrawAlignment(playerid, LaboratoryGame_PTD[playerid][9], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, LaboratoryGame_PTD[playerid][9], 255);
    PlayerTextDrawBackgroundColour(playerid, LaboratoryGame_PTD[playerid][9], 255);
    PlayerTextDrawFont(playerid, LaboratoryGame_PTD[playerid][9], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, LaboratoryGame_PTD[playerid][9], false);
    PlayerTextDrawSetShadow(playerid, LaboratoryGame_PTD[playerid][9], false);

    LaboratoryGame_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 306.1999, 363.7220, "LD_SPAC:white"); // scale
    PlayerTextDrawTextSize(playerid, LaboratoryGame_PTD[playerid][10], 2.0000, 27.0000);
    PlayerTextDrawAlignment(playerid, LaboratoryGame_PTD[playerid][10], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, LaboratoryGame_PTD[playerid][10], 852768511);
    PlayerTextDrawBackgroundColour(playerid, LaboratoryGame_PTD[playerid][10], 255);
    PlayerTextDrawFont(playerid, LaboratoryGame_PTD[playerid][10], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, LaboratoryGame_PTD[playerid][10], false);
    PlayerTextDrawSetShadow(playerid, LaboratoryGame_PTD[playerid][10], false);

    for (new i = 0; i < sizeof(LaboratoryGame_PTD[]); i++)
    {
        PlayerTextDrawShow(playerid, LaboratoryGame_PTD[playerid][i]);
    }

    // Запуск мини-игры
    new unix = gettime();
    NarcoSpotPlayerInfo[playerid][nspPumpCooldown] = unix - 5;
    NarcoPlaceInfo[spotid][placeid][npdWaterTime] = unix + LABORATORY_GAME_TIME + 20;
    NarcoSpotPlayerInfo[playerid][nspLaboratoryGameStartTime] = unix;
    NarcoSpotPlayerInfo[playerid][nspLaboratoryGameEndTime] = unix + LABORATORY_GAME_TIME + LABORATORY_GAME_PREPARE_TIME;
    NarcoSpotPlayerInfo[playerid][nspLaboratoryGameHealth] = 100.0;
    NarcoSpot_Laboratory_GameUpdate(playerid, placeid, ingredient);
    SelectColorDraw(playerid);

    return 1;
}

stock NarcoSpotGetIngredientType(fpick)
{
    if (fpick >= 274 && fpick <= 276) return fpick - 273;
    return 0;
}

stock NarcoSpotGetIngredientThing(ingredient)
{
    new fpick = ingredient + 273;
    if (fpick >= 274 && fpick <= 276) return fpick;
    return 0;
}

stock NarcoSpotCreatePickup(id)
{
    if (IsValidDynamicPickup(NarcoSpotInfo[id][nstEnterPickup])) {
        DestroyDynamicPickup(NarcoSpotInfo[id][nstEnterPickup]);
        DestroyDynamic3DTextLabel(NarcoSpotInfo[id][nstEnterLabel]);
    }
    if (IsValidDynamicObject(NarcoSpotInfo[id][nstEnterDoor])) {
        DestroyDynamicObject(NarcoSpotInfo[id][nstEnterDoor]);
    }
    if (IsValidDynamicMapIcon(NarcoSpotInfo[id][nstMapIcon]))
    {
        DestroyDynamicMapIcon(NarcoSpotInfo[id][nstMapIcon]);
    }

    new label_text[256], modelid = 19132;
    strcat(label_text, NarcoSpotGetTypeName(NarcoSpotInfo[id][nstType]));
    format(label_text, sizeof(label_text), "%s {cccccc}[№%d]\n{ffffff}Контролируют: %s\n\n{cccccc}[ ALT ]", label_text, id + 1, frakName[NarcoSpotInfo[id][nstFraction]]);

    new Float: x = NarcoSpotInfo[id][nstPosition][0],
        Float: y = NarcoSpotInfo[id][nstPosition][1],
        Float: z = NarcoSpotInfo[id][nstPosition][2],
        Float: rx = NarcoSpotInfo[id][nstAngle][0],
        Float: ry = NarcoSpotInfo[id][nstAngle][1],
        Float: rz = NarcoSpotInfo[id][nstAngle][2];

    NarcoSpotInfo[id][nstEnterDoor] = CreateDynamicObject(NarcoSpotInfo[id][nstType] == NARCO_SPOT_LABORATORY ? 1533 : 1501, x, y, z, rx, ry, rz, 0, 0);

    /*
        65154 = CreateDynamicObject(1533, 2803.417480, 2584.982666, 9.790288, 0.000000, 0.000000, 0.000000);
        CreateDynamicPickup(19132, 2804.114257, 2584.006347, 10.820312);
    */
    new Float: pickupX, Float: pickupY, Float: pickupZ;
    GetRelativePos(x, y, z, rx, ry, rz, 0.700000, -0.976319, 0.0, pickupX, pickupY, pickupZ);
    pickupZ = z + 0.95;

    if (NarcoSpotInfo[id][nstType] == NARCO_SPOT_LABORATORY)
    {
        SetDynamicObjectMaterial(NarcoSpotInfo[id][nstEnterDoor], 0, 2567, "ab", "ab_metaledge", 0x00000000);
        SetDynamicObjectMaterial(NarcoSpotInfo[id][nstEnterDoor], 1, 13363, "cephotoblockcs_t", "alleydoor3", 0x00000000);
        SetDynamicObjectMaterial(NarcoSpotInfo[id][nstEnterDoor], 2, 5819, "buildtestlawn", "alleydoor8", 0x00000000);
    }

    switch (NarcoSpotInfo[id][nstType])
    {
        case NARCO_SPOT_HANGOUT: modelid = 12722;
        case NARCO_SPOT_LABORATORY: modelid = 12723;
    }

    NarcoSpotInfo[id][nstEnterPickup] = CreateDynamicPickup(modelid, 1, pickupX, pickupY, pickupZ, 0, 0);
    NarcoSpotInfo[id][nstEnterLabel] = CreateDynamic3DTextLabel(label_text, 0xFFFFFFFF, pickupX, pickupY, pickupZ, 10.0, .testlos = 1);

    new map_icon = 40;
    if (NarcoSpotInfo[id][nstType] == NARCO_SPOT_LABORATORY) map_icon = 23;
    NarcoSpotInfo[id][nstMapIcon] = CreateDynamicMapIcon(x, y, z, map_icon, 0, 0, 0);

    return 1;
}

stock NarcoSpot_RandomActorSkin(spotid, bool: manager = false)
{
    if (!NarcoSpotIsExists(spotid)) return 0;

    if (NarcoSpotInfo[spotid][nstType] == NARCO_SPOT_LABORATORY)
    {
        if (manager) return 613;
        new skins[] = {547, 548, 610, 611, 612, 613};
        return skins[random(sizeof(skins))];
    }
    
    switch (NarcoSpotInfo[spotid][nstFraction])
    {
        case 6: // Якудза
        {
            if (manager) return 469;
            new skins[] = {381, 382, 468, 488};
            return skins[random(sizeof(skins))];
        }
        case 18: // Арабы
        {
            new skins[] = {412, 413};
            return skins[random(sizeof(skins))];
        }
        case 15, 16: { // Латиносы
            if (manager) return 582;
            new skins[] = {578, 327, 580, 581};
            return skins[random(sizeof(skins))];
        }
        default: { // Негроидные
            if (manager) return 473;
            new skins[] = {566, 545, 535, 318};
            return skins[random(sizeof(skins))];
        }
    }
}

stock NarcoSpot_SetFraction(spotid, fractionid)
{
    if (!NarcoSpotIsExists(spotid)) return 0;
    if (fractionid < 0 || fractionid >= MAX_ORG) return 0;

    NarcoSpotInfo[spotid][nstFraction] = fractionid;

    // Меняем скины актеров
    for (new i = 0; i < sizeof(NarcoSpotActors[]); i++)
    {
        if (!IsValidDynamicActor(NarcoSpotActors[spotid][i])) continue;
        DestroyDynamicActor(NarcoSpotActors[spotid][i]);
        NarcoSpotActors[spotid][i] = INVALID_STREAMER_ID;
    }

    #define manager_skin NarcoSpot_RandomActorSkin(spotid, true)
    #define default_skin NarcoSpot_RandomActorSkin(spotid, false)
    switch (NarcoSpotInfo[spotid][nstType])
    {
        case NARCO_SPOT_HANGOUT:
        {
            NarcoSpotActors[spotid][0] = CreateDynamicActor(manager_skin, 1006.0000, 226.0471, 152.5605, 83.6000, .worldid = NarcoSpot_GetVirtualWorld(spotid));
            ApplyDynamicActorAnimation(NarcoSpotActors[spotid][0], "BD_FIRE", "M_smklean_loop", 4.0, false, false, false, true, false);
            NarcoSpotActors[spotid][1] = CreateDynamicActor(default_skin, 1006.0974, 233.2639, 152.5605, 268.9659, .worldid = NarcoSpot_GetVirtualWorld(spotid));
            ApplyDynamicActorAnimation(NarcoSpotActors[spotid][1], "OTB", "wtchrace_loop", 4.0, false, false, false, true, false);
            NarcoSpotActors[spotid][2] = CreateDynamicActor(default_skin, 998.3226, 222.7031, 152.5605, 174.8872, .worldid = NarcoSpot_GetVirtualWorld(spotid));
            ApplyDynamicActorAnimation(NarcoSpotActors[spotid][2], "GANGS", "prtial_gngtlkA", 2.1, true, false, false, true, false);
            NarcoSpotActors[spotid][3] = CreateDynamicActor(default_skin, 998.3787, 221.6025, 152.5605, 1.6905, .worldid = NarcoSpot_GetVirtualWorld(spotid));
            ApplyDynamicActorAnimation(NarcoSpotActors[spotid][3], "GANGS", "prtial_gngtlkB", 2.1, true, false, false, true, false);
            NarcoSpotActors[spotid][4] = CreateDynamicActor(default_skin, 1005.2050, 219.8731, 152.5605, 359.1515, .worldid = NarcoSpot_GetVirtualWorld(spotid));
            ApplyDynamicActorAnimation(NarcoSpotActors[spotid][4], "BEACH", "ParkSit_M_loop", 4.0, false, false, false, true, false);
        }
        case NARCO_SPOT_LABORATORY:
        {
            NarcoSpotActors[spotid][0] = CreateDynamicActor(manager_skin, 1003.4462, 237.1849, 152.5605, 200.0, .worldid = NarcoSpot_GetVirtualWorld(spotid));
            ApplyDynamicActorAnimation(NarcoSpotActors[spotid][0], "DEALER", "DEALER_IDLE", 4.0, false, false, false, true, false);
            NarcoSpotActors[spotid][1] = CreateDynamicActor(default_skin, 998.2680, 223.8251, 152.5605, 90.9676, .worldid = NarcoSpot_GetVirtualWorld(spotid));
            ApplyDynamicActorAnimation(NarcoSpotActors[spotid][1], "OTB", "wtchrace_loop", 4.0, false, false, false, true, false);
            NarcoSpotActors[spotid][2] = CreateDynamicActor(default_skin, 1000.3223, 221.3145, 152.5605, 267.3299, .worldid = NarcoSpot_GetVirtualWorld(spotid));
            ApplyDynamicActorAnimation(NarcoSpotActors[spotid][2], "GANGS", "prtial_gngtlkA", 2.1, true, false, false, true, false);
            NarcoSpotActors[spotid][3] = CreateDynamicActor(default_skin, 1001.5030, 221.2403, 152.5605, 89.8809, .worldid = NarcoSpot_GetVirtualWorld(spotid));
            ApplyDynamicActorAnimation(NarcoSpotActors[spotid][3], "GANGS", "prtial_gngtlkB", 2.1, true, false, false, true, false);
            NarcoSpotActors[spotid][4] = CreateDynamicActor(default_skin, 997.8654, 231.8461, 152.5605, 266.8487, .worldid = NarcoSpot_GetVirtualWorld(spotid));
            ApplyDynamicActorAnimation(NarcoSpotActors[spotid][4], "BEACH", "ParkSit_M_loop", 4.0, false, false, false, true, false);
        }
    }
    #undef manager_skin
    #undef default_skin

    return 1;
}

stock NarcoSpotAdd(type, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz, fractionid = 0)
{
    for (new i = 0; i < MAX_NARCO_SPOTS; i++)
    {
        if (NarcoSpotIsExists(i)) continue;

        NarcoSpotInfo[i][nstType] = e_NarcoSpotType: type;
        NarcoSpotInfo[i][nstPosition][0] = x;
        NarcoSpotInfo[i][nstPosition][1] = y;
        NarcoSpotInfo[i][nstPosition][2] = z;
        NarcoSpotInfo[i][nstAngle][0] = rx;
        NarcoSpotInfo[i][nstAngle][1] = ry;
        NarcoSpotInfo[i][nstAngle][2] = rz;
        NarcoSpot_SetFraction(i, fractionid);
        
        NarcoSpotSave(i);
        NarcoPlaceShow(i);
        NarcoSpotCreatePickup(i);
        NarcoSpotPreparePlaces(i);

        return 1;
    }

    return 0;
}

stock NarcoSpotDelete(id)
{
    if (!NarcoSpotIsExists(id)) return 0;

    DestroyDynamicObject(NarcoSpotInfo[id][nstEnterDoor]);
    DestroyDynamicPickup(NarcoSpotInfo[id][nstEnterPickup]);
    DestroyDynamic3DTextLabel(NarcoSpotInfo[id][nstEnterLabel]);
    DestroyDynamicMapIcon(NarcoSpotInfo[id][nstMapIcon]);

    // Выкидываем людей из точки
    foreach (new i: Player)
    {
        if (NarcoSpotPlayer_GetId(i) == id)
        {
            S_SetPlayerVirtualWorld(i, 0);
            PPSetPlayerPos(i, NarcoSpotInfo[id][nstPosition][0] + frand(-0.2, 0.2), NarcoSpotInfo[id][nstPosition][1] + frand(-0.2, 0.2), NarcoSpotInfo[id][nstPosition][2]);
            PPSetPlayerFacingAngle(i, NarcoSpotInfo[id][nstAngle][2]);
            SetCameraBehindPlayer(i);
        }
    }

    for (new e_NarcoSpotInfo: i; i < e_NarcoSpotInfo; i++) NarcoSpotInfo[id][i] = 0;
    for (new i = 0; i < MAX_NARCO_PLACES; i++) NarcoSpotPlaceFree(id, i);
    NarcoSpotSave(id);

    return 1;
}

stock NarcoSpotGetGang(Float: x, Float: y, Float: z)
{
    for (new i = 0; i < GZONES ;i++)
	{
        if (IsPointInCube(x, y, z, GangZone[i][gzMinX],GangZone[i][gzMinY], 0.0, GangZone[i][gzMaxX], GangZone[i][gzMaxY], 1000.0))
		{
			return GZInfo[i][gFrakVlad];
        }
    }

    return 0;
}

DIALOG:accept_drugs_addspot(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<drugs_addspot>(playerid);

    new type = GetDialogContextInt(playerid, "spot_type"),
        Float: x = GetDialogContextFloat(playerid, "door_x"),
        Float: y = GetDialogContextFloat(playerid, "door_y"),
        Float: z = GetDialogContextFloat(playerid, "door_z"),
        Float: rx = GetDialogContextFloat(playerid, "door_rx"),
        Float: ry = GetDialogContextFloat(playerid, "door_ry"),
        Float: rz = GetDialogContextFloat(playerid, "door_rz");
    
    if (!NarcoSpotAdd(type, x, y, z, rx, ry, rz)) return ErrorMessage(playerid, "{FF6347}Превышено количество точек наркосбыта");

    AdminLog("newdrugspot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Добавил точку наркосбыта");
    SuccessMessage(playerid, "{99ff66}Точка наркосбыта успешно установлена");

    return 1;
}

DIALOG:drugs_addspot(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    switch (listitem)
    {
        case 0: {
            ChangeDialogContextInt(playerid, "spot_type", 1, .min = 0, .max = 1);
            return ShowAdvancedDialogGen<drugs_addspot>(playerid);
        }
        case 1: {
            return ShowAdvancedDialogGen<drugs_addspot>(playerid);
        }
        case 2: {
            if (GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) {
                ErrorText(playerid, "{FF6347}Вы должны находиться в общем мире");
                return ShowAdvancedDialogGen<drugs_addspot>(playerid);
            }

            new Float: x = GetDialogContextFloat(playerid, "door_x"),
                Float: y = GetDialogContextFloat(playerid, "door_y"),
                Float: z = GetDialogContextFloat(playerid, "door_z"),
                Float: rx = GetDialogContextFloat(playerid, "door_rx"),
                Float: ry = GetDialogContextFloat(playerid, "door_ry"),
                Float: rz = GetDialogContextFloat(playerid, "door_rz");
            if (x == 0.0 && y == 0.0 && z == 0.0) {
                x = Protect_X[playerid], y = Protect_Y[playerid], z = Protect_Z[playerid];
                GetPlayerFacingAngle(playerid, rz);
                frontpos(2.0, x, y, rz, x, y);
            }

            new e_NarcoSpotType: type = e_NarcoSpotType: GetDialogContextInt(playerid, "spot_type");
            CreateEditPlayerObject(playerid, REDAKT_TYPE_NARCOSPOT, 0, 0, 0, type == NARCO_SPOT_LABORATORY ? 1533 : 1501, x, y, z - 1.0, rx, ry, rz);
        }
        default: return 0;
    }

    return 1;
}

DIALOG_GENERATOR:drugs_addspot(playerid, bool: init = false)
{
    if (init) ClearDialogContext(playerid);

    new e_NarcoSpotType: type = e_NarcoSpotType: GetDialogContextInt(playerid, "spot_type"),
        findraiontolist = FindRaionPos(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid]);

    new dialog_text[1024];
    format(dialog_text, sizeof(dialog_text),
        "{cccccc}Тип: %s\n" \
        "{cccccc}Район: {ff9000}%s\n" \
        "{99ff66}>> Подтвердить добавление точки",

        NarcoSpotGetTypeName(type),
        gSAZones[findraiontolist][zName]
    );

    return ShowAdvancedDialog(playerid, "drugs_addspot", DIALOG_STYLE_LIST, "{cccccc}Добавление точки", dialog_text, "Выбор", "Закрыть");
}

DIALOG_ITEMS:drugs_editspot_fraction(playerid, response, listitem, fractionid, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<drugs_editspot>(playerid);

    SetDialogContextInt(playerid, "spot_fraction", fractionid);
    return ShowAdvancedDialogGen<drugs_editspot>(playerid);
}

DIALOG:accept_drugs_editpoint(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<drugs_editspot>(playerid);

    new Float: a; GetPlayerFacingAngle(playerid, a);
    SetDialogContextBool(playerid, "changedpos", true);

    new Float: x = GetDialogContextFloat(playerid, "spot_x"),
        Float: y = GetDialogContextFloat(playerid, "spot_y"),
        Float: z = GetDialogContextFloat(playerid, "spot_z"),
        Float: rx = GetDialogContextFloat(playerid, "spot_rx"),
        Float: ry = GetDialogContextFloat(playerid, "spot_ry"),
        Float: rz = GetDialogContextFloat(playerid, "spot_rz");
    if (x == 0.0 && y == 0.0 && z == 0.0) {
        new spotid = GetDialogContextInt(playerid, "spot_id");
        x = NarcoSpotInfo[spotid][nstPosition][0];
        y = NarcoSpotInfo[spotid][nstPosition][1];
        z = NarcoSpotInfo[spotid][nstPosition][2];
        rx = NarcoSpotInfo[spotid][nstAngle][0];
        ry = NarcoSpotInfo[spotid][nstAngle][1];
        rz = NarcoSpotInfo[spotid][nstAngle][2];
    }
    new e_NarcoSpotType: type = e_NarcoSpotType: GetDialogContextInt(playerid, "spot_type");
    CreateEditPlayerObject(playerid, REDAKT_TYPE_NARCOSPOT, 0, 1, 0, type == NARCO_SPOT_LABORATORY ? 1533 : 1501, x, y, z, rx, ry, rz);

    return 1;
}

DIALOG:accept_drugs_edit(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<drugs_editspot>(playerid);

    new id = GetDialogContextInt(playerid, "spot_id");
    if (!NarcoSpotIsExists(id)) return ErrorMessage(playerid, "{FF6347}Указанной точки не существует");

    if (GetDialogContextBool(playerid, "edit"))
    {
        new bool: changed = false;
        if (GetDialogContextBool(playerid, "changedpos"))
        {
            NarcoSpotInfo[id][nstPosition][0] = GetDialogContextFloat(playerid, "spot_x");
            NarcoSpotInfo[id][nstPosition][1] = GetDialogContextFloat(playerid, "spot_y");
            NarcoSpotInfo[id][nstPosition][2] = GetDialogContextFloat(playerid, "spot_z");
            NarcoSpotInfo[id][nstAngle][0] = GetDialogContextFloat(playerid, "spot_rx");
            NarcoSpotInfo[id][nstAngle][1] = GetDialogContextFloat(playerid, "spot_ry");
            NarcoSpotInfo[id][nstAngle][2] = GetDialogContextFloat(playerid, "spot_rz");
            changed = true;
        }
        if (GetDialogContextInt(playerid, "spot_fraction") != NarcoSpotInfo[id][nstFraction]) {
            NarcoSpot_SetFraction(id, GetDialogContextInt(playerid, "spot_fraction"));
            changed = true;
        }
        if (GetDialogContextInt(playerid, "spot_type") != _:NarcoSpotInfo[id][nstType]) {
            NarcoSpotInfo[id][nstType] = e_NarcoSpotType: GetDialogContextInt(playerid, "spot_type");
            changed = true;
        }

        if (!changed) return ErrorMessage(playerid, "{FF6347}Вы не изменили ни одного параметра");

        NarcoSpotPreparePlaces(id);
        NarcoSpotCreatePickup(id);
        NarcoPlaceShow(id);
        NarcoSpotSave(id);

        AdminLog("editdrugspot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", id, "Изменил точку наркосбыта");
        SuccessMessage(playerid, "{99ff66}Изменения успешно сохранены");
    } else if (GetDialogContextBool(playerid, "delete")) {
        NarcoPlaceShow(id, false);
        NarcoSpotDelete(id);

        AdminLog("deletedrugspot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", id, "Удалил точку наркосбыта");
        SuccessMessage(playerid, "{99ff66}Точка наркосбыта успешно удалена");
    }

    return 1;
}

DIALOG:drugs_editspot(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    switch (listitem)
    {
        case 0: {
            ChangeDialogContextInt(playerid, "spot_type", 1, .min = 0, .max = 1);
            return ShowAdvancedDialogGen<drugs_editspot>(playerid);
        }
        case 1: {
            new dialog_text[512];
            for (new i = 0; i < MAX_ORG; i++)
            {
                if (i != 0 && !IsAGhettoID(i) && !IsAMafiaID(i)) continue;

                format(dialog_text, sizeof(dialog_text), "%s%s\n", dialog_text, frakName[i]);
                AttachAdvancedDialogItemValue(playerid, "drugs_editspot_fraction", i);
            }
            ShowAdvancedDialog(playerid, "drugs_editspot_fraction", DIALOG_STYLE_LIST, "{cccccc}Выбор организации", dialog_text, "Выбор", "Назад");
        }
        case 2: return ShowAdvancedDialogGen<drugs_editspot>(playerid);
        case 3: {
            ShowAdvancedDialog(playerid, "accept_drugs_editpoint", DIALOG_STYLE_MSGBOX, "{cccccc}Изменение точки",
                "{cccccc}Вы уверены, что хотите изменить расположение точки?",
                "Да", "Назад"
            );
        }
        case 4: {
            SetDialogContextBool(playerid, "edit", true);
            ShowAdvancedDialog(playerid, "accept_drugs_edit", DIALOG_STYLE_MSGBOX, "{cccccc}Изменение точки",
                "{cccccc}Вы уверены, что хотите применить изменения?",
                
                "Да", "Назад"
            );
        }
        case 5: {
            SetDialogContextBool(playerid, "delete", true);
            ShowAdvancedDialog(playerid, "accept_drugs_edit", DIALOG_STYLE_MSGBOX, "{cccccc}Изменение точки",
                "{ff6347}Вы уверены, что хотите удалить точку наркосбыта?\n\n" \
                "{ff6347}[!] {cccccc}Все данные будут утеряны",
                
                "Да", "Назад"
            );
        }
        default: return 0;
    }

    return 1;
}

DIALOG_GENERATOR:drugs_editspot(playerid, id = 0, bool: init = false)
{
    if (init) {
        ClearDialogContext(playerid);
        SetDialogContextInt(playerid, "spot_id", id);
        SetDialogContextInt(playerid, "spot_type", NarcoSpotInfo[id][nstType]);
        SetDialogContextInt(playerid, "spot_fraction", NarcoSpotInfo[id][nstFraction]);
    } else {
        id = GetDialogContextInt(playerid, "spot_id");
    }

    new dialog_text[1024];
    format(dialog_text, sizeof(dialog_text),
        "{cccccc}Тип: %s\n" \
        "{cccccc}Контролирующая организация: %s\n" \
        "{cccccc}Район: {ff9000}%s\n" \
        "{ff9000}>> Установить положение пикапа\n" \
        "{99ff66}>> Подтвердить изменения\n" \
        "{ff6347}>> Удалить точку",

        NarcoSpotGetTypeName(GetDialogContextInt(playerid, "spot_type")),
        frakName[GetDialogContextInt(playerid, "spot_fraction")],
        gSAZones[FindRaionPos(NarcoSpotInfo[id][nstPosition][0], NarcoSpotInfo[id][nstPosition][1], NarcoSpotInfo[id][nstPosition][2])][zName]
    );

    return ShowAdvancedDialog(playerid, "drugs_editspot", DIALOG_STYLE_LIST, "{cccccc}Изменение точки", dialog_text, "Выбор", "Закрыть");
}

stock NarcoSpotGetTypeName(type)
{
    new text[32];
    switch(e_NarcoSpotType: type)
    {
        case NARCO_SPOT_HANGOUT: strcat(text, "{8A6642}Наркопритон");
        case NARCO_SPOT_LABORATORY: strcat(text, "{3BB08F}Нарколаборатория");
        default: strcat(text, "{cccccc}Неизвестно");
    }
    return text;
}

DIALOG:drugspot_fillpot(playerid, response, listitem, const inputtext[])
{
    if (!response) return Dialog_ShowDrugSpotsMenu(playerid);

    new spotid = GetDialogContextInt(playerid, "spot_id");
    if (!NarcoSpotIsExists(spotid)) return ErrorMessage(playerid, "{FF6347}Указанной точки не существует");

    new placeid;
    if (sscanf(inputtext, "d", placeid)) return ErrorText(playerid, "{FF6347}Некорректный номер места"), Dialog_ShowDrugSpotsMenu(playerid);
    if (placeid < 1 || placeid > MAX_NARCO_PLACES) return ErrorText(playerid, "{FF6347}Некорректный номер места"), Dialog_ShowDrugSpotsMenu(playerid);
    if (placeid > LABORATORY_PLACES && NarcoSpotInfo[spotid][nstType] == NARCO_SPOT_LABORATORY) return ErrorText(playerid, "{FF6347}Некорректный номер места [ В лаборатории "#LABORATORY_PLACES" мест ]"), Dialog_ShowDrugSpotsMenu(playerid);
    placeid--;

    if (NarcoPlaceInfo[spotid][placeid][npdRentTime] == 0)
    {
        NarcoPlaceInfo[spotid][placeid][npdPlayer] = PlayerInfo[playerid][pID];
        NarcoPlaceInfo[spotid][placeid][npdRentTime] = gettime() + NARCO_RENT_TIME * 60;
        NarcoSpot_WaitForRent(spotid, placeid);
    }

    NarcoPlaceInfo[spotid][placeid][npdWaterTime] = gettime() + HANGOUT_WATER_TIME;
    NarcoPlaceInfo[spotid][placeid][npdRiped] = true;
    NarcoSpot_UpdatePlaceLabel(spotid, placeid);
    NarcoSpotPlacePlant(spotid, placeid, true);
    NarcoSpotPlaceSave(spotid, placeid);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Место №%d успешно заполнено",  placeid + 1);
    return Dialog_ShowDrugSpotsMenu(playerid);
}

DIALOG:show_drugspots_menu(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<show_drugspots>(playerid);

    new spotid = GetDialogContextInt(playerid, "spot_id");
    switch (listitem)
    {
        case 0: {
            FORMAT_SIZE:args(10, "%d", spotid + 1);
            return pc_cmd_gotodrugspot(playerid, args);
        }
        case 1: return ShowAdvancedDialogGen<drugs_editspot>(playerid, spotid, true);
        case 2: {
            FORMAT:text("{cccccc}Введите номер %s {ff9000}[1-20]{cccccc}:", NarcoSpotInfo[spotid][nstType] == NARCO_SPOT_HANGOUT ? "горшка" : "места");
            ShowAdvancedDialog(playerid, "drugspot_fillpot", DIALOG_STYLE_INPUT, "{cccccc}Меню наркопритона", text, "Выбор", "Назад");
        }
        case 3: {
            for (new i = 0; i < MAX_NARCO_PLACES; i++) NarcoSpotPlaceFree(spotid, i);
        }
        default: return 0;
    }

    return 1;
}

stock Dialog_ShowDrugSpotsMenu(playerid, spotid = NARCO_SPOT_INVALID_ID)
{
    if (spotid != NARCO_SPOT_INVALID_ID) SetDialogContextInt(playerid, "spot_id", spotid);
    else spotid = GetDialogContextInt(playerid, "spot_id");

    new dialog_text[1024];
    format(dialog_text, sizeof(dialog_text),
        "{cccccc}Телепортироваться к точке\n" \
        "{cccccc}Редактировать точку\n" \
        "{ff9000}Заполнить %s\n" \
        "{ff6347}Очистить все %s\n",

        NarcoSpotInfo[spotid][nstType] == NARCO_SPOT_HANGOUT ? "указанный горшок" : "указанное место",
        NarcoSpotInfo[spotid][nstType] == NARCO_SPOT_HANGOUT ? "горшки" : "места"
    );
    ShowAdvancedDialog(playerid, "show_drugspots_menu", DIALOG_STYLE_LIST, "{cccccc}Меню точки наркосбыта", dialog_text, "Выбор", "Назад");

    return 1;
}

DIALOG_ITEMS:show_drugspots(playerid, response, listitem, spotid, const inputtext[])
{
    if (!response) return 1;

    new id = spotid;
    if (!NarcoSpotIsExists(id)) return ErrorMessage(playerid, "{FF6347}Указанной точки не существует");
    return Dialog_ShowDrugSpotsMenu(playerid, id);
}

DIALOG_GENERATOR:show_drugspots(playerid)
{
    if (PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "Вам недоступна эта команда");

    new tablist[4096];
    strcat(tablist, "{cccccc}ID\tТип\tОрганизация\tРайон\n");
    for (new i = 0; i < MAX_NARCO_SPOTS; i++)
    {
        if (!NarcoSpotIsExists(i)) continue;

        new type = NarcoSpotInfo[i][nstType],
            fractionid = NarcoSpotInfo[i][nstFraction],
            findraiontolist = FindRaionPos(NarcoSpotInfo[i][nstPosition][0], NarcoSpotInfo[i][nstPosition][1], NarcoSpotInfo[i][nstPosition][2]);

        AttachAdvancedDialogItemValue(playerid, "show_drugspots", i);
        format(tablist, sizeof(tablist), "%s{ff9000}№%d.\t%s\t%s\t{ffffff}%s\n",
            tablist,

            i + 1,
            NarcoSpotGetTypeName(type),
            frakName[fractionid],
            gSAZones[findraiontolist][zName]
        );
    }
    return ShowAdvancedDialogEx(playerid, "show_drugspots", DIALOG_STYLE_TABLIST_HEADERS, "{cccccc}Точки наркосбыта", tablist, "Выбор", "Закрыть", .init = true);
}

CMD:drugspots(playerid)
{
    return ShowAdvancedDialogGen<show_drugspots>(playerid);
}

alias:newdrugspot("newnarcospot", "addnarcospot", "adddrugspot")
CMD:newdrugspot(playerid)
{
    if (PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "Вам недоступна эта команда");
    return ShowAdvancedDialogGen<drugs_addspot>(playerid, true);
}

alias:editdrugspot("editnarcospot")
CMD:editdrugspot(playerid, const params[])
{
    if (PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "Вам недоступна эта команда");

    new id;
    if (sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Редактировать точку наркосбыта [ /editdrugspot ID ]");
    id--;
    if (!NarcoSpotIsExists(id)) return ErrorMessage(playerid, "{FF6347}Указанной точки не существует");
    return ShowAdvancedDialogGen<drugs_editspot>(playerid, id, true);
}

alias:gotodrugspot("gotonarcospot")
CMD:gotodrugspot(playerid, const params[])
{
    if (PlayerInfo[playerid][pSoska] < 1) return ErrorMessage(playerid, "Вам недоступна эта команда");

    new id;
    if (sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Телепортироваться к точке наркосбыта [ /gotodrugspot ID ]");
    id--;
    if (!NarcoSpotIsExists(id)) return ErrorMessage(playerid, "{FF6347}Указанной точки не существует");

    S_SetPlayerVirtualWorld(playerid, 0, 0);
    PPSetPlayerInterior(playerid, 0);
    new Float: x, Float: y, Float: z,
        Float: a = NarcoSpotInfo[id][nstAngle][2];
    Streamer_GetItemPos(STREAMER_TYPE_PICKUP, NarcoSpotInfo[id][nstEnterPickup], x, y, z);
    frontpos(-1.5, x, y, a, x, y);
    PPSetPlayerPos(playerid, x, y, z + 1.0);
    PPSetPlayerFacingAngle(playerid, a);
    SetCameraBehindPlayer(playerid);

    return 1;
}

stock NarcoSpot_SetPlayerTime(playerid)
{
    SetPlayerWeather(playerid, 0);
    SetPlayerTime(playerid, 0, 0);
    return 1;
}

DIALOG:next_hangout_scene(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    new stat = GetDialogContextInt(playerid, "hangout_scene_stat"),
        i = GetDialogContextInt(playerid, "hangout_scene_spot");
    return NarcoSpotHangOutCutScene(playerid, i, stat + 1);
}

DIALOG:next_laboratory_scene(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    new stat = GetDialogContextInt(playerid, "laboratory_scene_stat"),
        i = GetDialogContextInt(playerid, "laboratory_scene_spot");
    return NarcoSpotLaboratoryCutScene(playerid, i, stat + 1);
}

function NarcoSpotLaboratoryCutScene(playerid, i, stat)
{
    SetDialogContextInt(playerid, "laboratory_scene_spot", i);
    SetDialogContextInt(playerid, "laboratory_scene_stat", stat);

    switch (stat)
    {
        /*
            [18:41:32] FlyCameraPos(playerid, 978.777587, 227.564788, 158.194656, 983.470214, 228.678222, 156.875656, 1000, 1200);
            [18:41:43] FlyCameraPos(playerid, 992.346740, 228.389755, 154.064529, 997.336914, 228.362442, 153.752578, 1000, 1200);
            [18:41:53] FlyCameraPos(playerid, 1006.213806, 223.629455, 154.540908, 1004.381774, 228.210388, 153.729232, 1000, 1200);
            [18:42:02] FlyCameraPos(playerid, 1003.654907, 234.250473, 153.622177, 1003.421691, 239.110961, 152.472747, 1000, 1200);
            [18:42:22] FlyCameraPos(playerid, 1002.347351, 230.526351, 154.090057, 1002.308593, 235.045761, 151.951492, 1000, 1200);
            [18:42:33] FlyCameraPos(playerid, 1005.371887, 231.747802, 154.491775, 1002.333435, 228.195785, 152.716674, 1000, 1200);
        */
        case 0: {
            SetPlayerCameraPos(playerid, 978.777587, 227.564788, 158.194656);
            SetPlayerCameraLookAt(playerid, 983.470214, 228.678222, 156.875656);

            InterpolateCameraPos(playerid, 978.777587, 227.564788, 158.194656, 992.346740, 228.389755, 154.064529, 1000);
            InterpolateCameraLookAt(playerid, 983.470214, 228.678222, 156.875656, 997.336914, 228.362442, 153.752578, 1200);
        }
        case 1: {
            InterpolateCameraPos(playerid, 992.346740, 228.389755, 154.064529, 1006.213806, 223.629455, 154.540908, 1000);
            InterpolateCameraLookAt(playerid, 997.336914, 228.362442, 153.752578, 1004.381774, 228.210388, 153.729232, 1200);
        }
        case 2: {
            ShowAdvancedDialog(playerid, "next_laboratory_scene", DIALOG_STYLE_MSGBOX, " ",
                "{3BB08F}Нарколаборатория\n\n" \
                \
                "{cccccc}Перед тобой тщательно организованное помещение, где из сырья создают особые вещества.\n" \
                "Здесь всё поставлено на поток, чтобы обеспечить стабильное производство:\n" \
                "- Лабораторные столы со сложным оборудованием\n" \
                "- Полки с химическими ингредиентами\n" \
                "- Строгий порядок и дисциплина\n\n" \
                \
                "Всё это — часть сложной системы, построенной для получения огромной прибыли.",

                "Далее"
            );
            return 0;
        }
        case 3: {
            InterpolateCameraPos(playerid, 1006.213806, 223.629455, 154.540908, 1003.654907, 234.250473, 153.622177, 1000);
            InterpolateCameraLookAt(playerid, 1004.381774, 228.210388, 153.729232, 1003.421691, 239.110961, 152.472747, 1200);
        }
        case 4: {
            ShowAdvancedDialog(playerid, "next_laboratory_scene", DIALOG_STYLE_MSGBOX, " ",
                "{3BB08F}Нарколаборатория\n\n" \
                \
                "{cccccc}Перед тобой {3BB08F}распорядитель{cccccc}, человек, контролирующий весь процесс производства.\n" \
                "Его задача — следить за соблюдением рецептов, точностью дозировок и безопасностью.\n" \
                "Любая ошибка здесь может стоить дорого.\n\n" \
                \
                "Такие люди — невидимые дирижёры в мире нелегального бизнеса, которые превращают хаос в прибыль.",
                
                "Далее"
            );
            return 0;
        }
        case 5: {
            InterpolateCameraPos(playerid, 1003.654907, 234.250473, 153.622177, 1002.347351, 230.526351, 154.090057, 1000);
            InterpolateCameraLookAt(playerid, 1003.421691, 239.110961, 152.472747, 1002.308593, 235.045761, 151.951492, 1200);
        }
        case 6: {
            ShowAdvancedDialog(playerid, "next_laboratory_scene", DIALOG_STYLE_MSGBOX, " ",
                "{3BB08F}Нарколаборатория\n\n" \
                \
                "{cccccc}Это ключевая зона лаборатории — место, где сырьё превращается в готовую продукцию.\n\n" \
                "Здесь каждый компонент важен:\n" \
                "- Химикаты, доставленные в тайне\n" \
                "- Сложные формулы и точные расчёты\n" \
                "- Непрерывное внимание к деталям, чтобы избежать ошибок\n\n",
                
                "Далее"
            );
            return 0;
        }
        case 7: {
            InterpolateCameraPos(playerid, 1002.347351, 230.526351, 154.090057, 1005.371887, 231.747802, 154.491775, 1000);
            InterpolateCameraLookAt(playerid, 1002.308593, 235.045761, 151.951492, 1002.333435, 228.195785, 152.716674, 1200);
        }
        case 8: {
            ShowAdvancedDialog(playerid, "next_laboratory_scene", DIALOG_STYLE_MSGBOX, " ",
                "{3BB08F}Нарколаборатория\n\n" \
                \
                "{cccccc}На этом этапе всё заканчивается. Готовый продукт тщательно фасуют и упаковывают в пакеты.\n" \
                "Каждый грамм проверяется на весах.\n\n" \
                \
                "Эти пакеты скоро окажутся на улицах города, принося прибыль тем, кто управляет этим бизнесом.\n\n" \
                \
                "Упаковочный стол — финальная точка производства, но начало огромного потока денег.",
                
                "Закрыть"
            );
            return 0;
        }
        default: {
            SetCameraBehindPlayer(playerid);
            NarcoSpotPlayerInfo[playerid][nspLaboratoryCutScene] = true;
            NarcoSpotPlayer_ShowInfectLevel(playerid, true);

            return 1;
        }
    }

    return SetTimerEx("NarcoSpotLaboratoryCutScene", 2500, false, "ddd", playerid, i, stat + 1);
}

function NarcoSpotHangOutCutScene(playerid, i, stat)
{
    SetDialogContextInt(playerid, "hangout_scene_spot", i);
    SetDialogContextInt(playerid, "hangout_scene_stat", stat);

    switch (stat)
    {
        /*
        
            [08:47:58] FlyCameraPos(playerid, 980.846801, 228.312133, 156.714721, 985.846557, 228.277954, 156.682495, 1000, 1200);
            [08:48:03] FlyCameraPos(playerid, 992.472290, 228.256774, 154.067352, 997.448913, 228.256774, 153.584701, 1000, 1200);
            [08:48:08] FlyCameraPos(playerid, 1001.367187, 228.996887, 153.551925, 1005.604980, 226.381027, 153.106704, 1000, 1200);
            [08:48:13] FlyCameraPos(playerid, 1006.082275, 226.864379, 154.407882, 1003.484741, 231.058639, 153.594863, 1000, 1200);
            [08:48:21] FlyCameraPos(playerid, 1000.109558, 235.171661, 154.314834, 1000.157409, 239.095123, 151.215774, 1000, 1200);
        */
        case 0: {
            SetPlayerCameraPos(playerid, 980.055725, 228.309310, 156.532943);
            SetPlayerCameraLookAt(playerid, 985.053161, 228.398132, 156.398696);

            InterpolateCameraPos(playerid, 980.055725, 228.309310, 156.532943, 992.472290, 228.347976, 154.069900, 1000);
            InterpolateCameraLookAt(playerid, 985.053161, 228.398132, 156.398696, 997.448913, 228.262680, 153.775161, 1200);
        }
        case 1: {
            InterpolateCameraPos(playerid, 992.472290, 228.347976, 154.069900, 1001.367187, 228.996887, 153.551925, 1000);
            InterpolateCameraLookAt(playerid, 997.448913, 228.262680, 153.775161, 1005.604980, 226.381027, 153.106704, 1200);
        }
        case 2: {
            ShowAdvancedDialog(playerid, "next_hangout_scene", DIALOG_STYLE_MSGBOX, " ",
                "{ff9000}Наркопритон\n\n" \
                "{cccccc}Ты смотришь на {ff9000}распорядителя{cccccc}, управляющего этим местом.\n" \
                "Его задача — контролировать весь процесс: от аренды помещений до распределения денег.\n" \
                "Именно такие люди стоят за теневой стороной бизнеса, зарабатывая огромные суммы на продаже травы.\n",
                
                "Далее"
            );
            return 0;
        }
        case 3: {
            InterpolateCameraPos(playerid, 1001.367187, 228.996887, 153.551925, 1006.082275, 226.864379, 154.407882, 1000);
            InterpolateCameraLookAt(playerid, 1005.604980, 226.381027, 153.106704, 1003.484741, 231.058639, 153.594863, 1200);
        }
        case 4: {
            ShowAdvancedDialog(playerid, "next_hangout_scene", DIALOG_STYLE_MSGBOX, " ",
                "{ff9000}Наркопритон\n\n" \
                "{cccccc}Перед тобой столы, где и происходит всё самое основное.\n\n" \
                \
                "Здесь всё поставлено на поток:\n" \
                "   1. Ряды горшков с травой\n" \
                "   2. Специальное освещение, чтобы ускорить рост\n" \
                "   3. Система контроля микроклимата\n\n" \
                \
                "Это место — начало всей цепочки, где сырьё превращается в прибыльный товар\n",
                
                "Далее"
            );
            return 0;
        }
        case 5: {
            InterpolateCameraPos(playerid, 1006.082275, 226.864379, 154.407882, 1000.109558, 235.171661, 154.314834, 1000);
            InterpolateCameraLookAt(playerid, 1003.484741, 231.058639, 153.594863, 1000.157409, 239.095123, 151.215774, 1200);
        }
        case 6: {
            ShowAdvancedDialog(playerid, "next_hangout_scene", DIALOG_STYLE_MSGBOX, " ",
                "{ff9000}Наркопритон\n\n" \
                \
                "{cccccc}На этом столе проходит последний этап.\n\n" \
                "Готовую траву тщательно упаковывают в маленькие пакеты, которые вскоре окажутся на улицах города. \n" \
                "Всё это сделано для одной цели — деньги.\n\n" \
                \
                "Это финальная точка работы притона, но начало огромного потока денег для организации.\n",
                
                "Закрыть"
            );
            return 0;
        }
        default: {
            SetCameraBehindPlayer(playerid);
            NarcoSpotPlayerInfo[playerid][nspHangOutCutScene] = true;

            return 1;
        }
    }
    return SetTimerEx("NarcoSpotHangOutCutScene", 2500, false, "ddd", playerid, i, stat + 1);
}

stock NarcoSpotHangOutCutSceneEnable(playerid, i, bool: force = false)
{
    if (NarcoSpotInfo[i][nstType] != NARCO_SPOT_HANGOUT) return 0;

    if (!force)
    {
        if (NarcoSpotPlayerInfo[playerid][nspHangOutCutScene]) return 0;
    }

    NarcoSpotPlayer_Join(playerid, i);
    ClearDialogContext(playerid);
    NarcoSpotHangOutCutScene(playerid, i, 0);
    return 1;
}

stock NarcoSpotLaboratoryCutSceneEnable(playerid, i, bool: force = false)
{
    if (NarcoSpotInfo[i][nstType] != NARCO_SPOT_LABORATORY) return 0;

    if (!force)
    {
        if (NarcoSpotPlayerInfo[playerid][nspLaboratoryCutScene]) return 0;
    }

    NarcoSpotPlayer_Join(playerid, i);
    ClearDialogContext(playerid);
    NarcoSpotLaboratoryCutScene(playerid, i, 0);
    return 1;
}

CMD:hangoutcutscene(playerid)
{
    if (server != 0) return 0;

    new id = NarcoSpotPlayer_GetId(playerid);
    if (!NarcoSpotPlayer_IsInside(playerid, NARCO_SPOT_HANGOUT)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в притоне");
    NarcoSpotHangOutCutSceneEnable(playerid, id, true);
    return 1;
}

CMD:laboratorycutscene(playerid)
{
    if (server != 0) return 0;

    new id = NarcoSpotPlayer_GetId(playerid);
    if (!NarcoSpotPlayer_IsInside(playerid, NARCO_SPOT_LABORATORY)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в лаборатории");
    NarcoSpotLaboratoryCutSceneEnable(playerid, id, true);
    return 1;
}

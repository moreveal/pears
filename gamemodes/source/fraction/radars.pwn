stock SaveRadars(id = -1) {
    new query_string[1024];

    new minid = (id > -1 ? 0 : id),
        maxid = (id > -1 ? id + 1 : MAX_RADARS);

    for (new i = minid; i < maxid; i++) {
        if (Radar_IsExists(i)) {
            mysql_format(pearsq, query_string, sizeof(query_string),
                "REPLACE INTO `radars` (`id`, `fraction`, `owner`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `radius`, `max_speed`, `fine`, `tickets_issued`, `fine_total`) \
                VALUES(%d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %d, %d, %d, %d)",
                
                i,
                RadarInfo[i][riFraction],
                RadarInfo[i][riPID],
                RadarInfo[i][riX], RadarInfo[i][riY], RadarInfo[i][riZ], RadarInfo[i][riRX], RadarInfo[i][riRY], RadarInfo[i][riRZ],
                RadarInfo[i][riRadius],
                RadarInfo[i][riMaxSpeed],
                RadarInfo[i][riFine],
                RadarInfo[i][riTicketsIssued],
                RadarInfo[i][riFineTotal]
            );
        } else {
            mysql_format(pearsq, query_string, sizeof(query_string),
                "DELETE FROM `radars` WHERE `id` = %d",
                i
            );
        }
        query_empty(pearsq, query_string);
    }
}

/*
CREATE TABLE `radars` (
  `id` int(11) NOT NULL,
  `fraction` int(11) NOT NULL COMMENT 'ID организации',
  `owner` int(11) NOT NULL COMMENT 'ID аккаунта создателя',
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rx` float NOT NULL,
  `ry` float NOT NULL,
  `rz` float NOT NULL,
  `radius` float NOT NULL COMMENT 'Радиус действия',
  `max_speed` int(11) NOT NULL COMMENT 'Максимально допустимая скорость',
  `fine` int(11) NOT NULL COMMENT 'Размер штрафа',
  `tickets_issued` int(11) NOT NULL COMMENT 'Количество выписанных штрафов',
  `fine_total` int(11) NOT NULL COMMENT 'Общая сумма штрафов'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `radars`
  ADD UNIQUE KEY `newid` (`id`);
*/
function LoadRadars() {
    new rows;
    cache_get_row_count(rows);

    for (new i = 0; i < min(rows, MAX_RADARS); i++) {
        new id;
        cache_get_value_name_int(i, "id", id);

        cache_get_value_name(i, "Name", RadarInfo[id][riOwnerName], 24);
        
        cache_get_value_name_int(i, "fraction", RadarInfo[id][riFraction]);
        cache_get_value_name_int(i, "owner", RadarInfo[id][riPID]);
        cache_get_value_name_float(i, "x", RadarInfo[id][riX]);
        cache_get_value_name_float(i, "y", RadarInfo[id][riY]);
        cache_get_value_name_float(i, "z", RadarInfo[id][riZ]);
        cache_get_value_name_float(i, "rx", RadarInfo[id][riRX]);
        cache_get_value_name_float(i, "ry", RadarInfo[id][riRY]);
        cache_get_value_name_float(i, "rz", RadarInfo[id][riRZ]);
        cache_get_value_name_float(i, "radius", RadarInfo[id][riRadius]);
        cache_get_value_name_int(i, "max_speed", RadarInfo[id][riMaxSpeed]);
        cache_get_value_name_int(i, "fine", RadarInfo[id][riFine]);

        cache_get_value_name_int(i, "tickets_issued", RadarInfo[id][riTicketsIssued]);
        cache_get_value_name_int(i, "fine_total", RadarInfo[id][riFineTotal]);
    }
}

stock Radar_IsExists(id) {
    if (id < 0 || id >= MAX_RADARS) return 0;
    return RadarInfo[id][riPID] > 0;
}

stock Radar_IsPlaced(id) {
    if (!Radar_IsExists(id)) return 0;
    return RadarInfo[id][riPlaced];
}

stock Radar_Create(playerid, Float: radius, maxSpeed, fine) {
    if (GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return -1;
    new g = fraction(playerid);
    if(!IsAFunctionOrganization(35, g, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не полицейский");

    for (new id = 0; id < MAX_RADARS; id++) {
        if (!Radar_IsExists(id)) {
            RadarInfo[id][riFraction] = g;
            RadarInfo[id][riRadius] = radius;
            RadarInfo[id][riMaxSpeed] = maxSpeed;
            RadarInfo[id][riFine] = fine;
            RadarInfo[id][riPID] = PlayerInfo[playerid][pID];

            new Float: X, Float: Y, Float: Z, Float: A;
            frontme(playerid, 1.0, X, Y, Z, A);
            if (!Radar_SetPosition(id, X, Y, Z, 0.0, 0.0, A)) return 0;
            Radar_SetNormalZ(id);

            Radar_Place(id);
            
            RadarInfo[id][riPID] = PlayerInfo[playerid][pID];
            format(RadarInfo[id][riOwnerName], 24, "%s", PlayerInfo[playerid][pName]);
            SaveRadars(id);
            return id;
        }
    }

    return -1;
}

stock Radar_CalculateUnits(radarid) {
    if (!Radar_IsExists(radarid)) return 0;

    new police_share = RadarInfo[radarid][riFineTotal] / 100 * RADAR_POLICE_SHARE;
    return police_share / 100 * OrganInfo[RadarInfo[radarid][riFraction]][gUnit][24];
}

stock Radar_Delete(radarid) {
    // Выплачиваем юниты
    new units = Radar_CalculateUnits(radarid);
    if (units > 0) {
        new bool: owner_online = false;
        foreach (new playerid : Player) {
            if (Radar_IsOwner(playerid, radarid)) {
                owner_online = true;
                GivePlayerUnit(playerid, units);
                break;
            }
        }
        if (!owner_online) {
            // Начисляем юниты Offline, если игрок не в сети
            new string[128];
            mysql_format(pearsq, string, sizeof(string), "UPDATE `pp_igroki` SET `Unit` = `Unit` + %d WHERE `user_id` = %d", units, RadarInfo[radarid][riPID]);
            query_empty(pearsq, string);
        }
    }

    // Убираем из игрового мира
    Radar_Place(radarid, false);

    // Удаление таймеров
    KillTimer(RadarInfo[radarid][riAutoUnplaceTimer]);
    KillTimer(RadarInfo[radarid][riDeleteLaserTimer]);
    KillTimer(RadarInfo[radarid][riUpdateLaserTimer]);
    KillTimer(RadarInfo[radarid][riDeleteFlashlightTimer]);
    KillTimer(RadarInfo[radarid][riRepairTimer]);
    
    // Очищаем данные о радаре
    for (new e_RadarInfo: i; i < e_RadarInfo; ++i) RadarInfo[radarid][i] = 0;
    
    SaveRadars(radarid);
    return 1;
}

stock Radar_SetPosition(id, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz) {
    if (!Radar_IsExists(id)) return 0;

    RadarInfo[id][riX] = x;
    RadarInfo[id][riY] = y;
    RadarInfo[id][riZ] = z;
    RadarInfo[id][riLastX] = x;
    RadarInfo[id][riLastY] = y;
    RadarInfo[id][riLastZ] = z;

    RadarInfo[id][riRX] = rx;
    RadarInfo[id][riRY] = ry;
    RadarInfo[id][riRZ] = rz;

    return 1;
}

stock Radar_IsBroken(id) {
    if (!Radar_IsExists(id)) return 0;
    return RadarInfo[id][riBroken];
}

function Radar_SetBroken(id, bool: status) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id)) return 0;
    if (bool: Radar_IsBroken(id) == status) return 0;

    RadarInfo[id][riBroken] = status;
    if (status) {
        foreach (new currentid : Player) {
            if (!IsPlayerInRangeOfPoint(currentid, 20.0, RadarInfo[id][riX], RadarInfo[id][riY], RadarInfo[id][riZ])) continue;
            PlayerPlaySound(currentid, 6003, 0.0, 0.0, 0.0);
        }
    }
    Radar_Place(id);

    return 1;
}

stock Radar_UpdateLabel(id, bool: create = true) {
    if (!Radar_IsExists(id)) return 0;

    if ( create || !create && Radar_IsPlaced(id) ) {
        new speed_color[8 + 1];
        if (RadarInfo[id][riMaxSpeed] <= 90) strcat(speed_color, "{99ff66}");
        else if (RadarInfo[id][riMaxSpeed] <= 120) strcat(speed_color, "{ffff00}");
        else strcat(speed_color, "{ff6347}");

        new label[512];
        format(label, sizeof(label),
            "[ Скоростной Радар №%d ]\n" \
            "{FFFFFF}Ограничение скорости: %s%d км/ч\n" \
            "{FFFFFF}Штраф за нарушение: {FF6347}$%s",

            id + 1,
            speed_color,
            RadarInfo[id][riMaxSpeed],
            FormatNumberWithCommas(RadarInfo[id][riFine])
        );

        if (!Radar_IsBroken(id))
            strcat(label, "\n{FF9000}[ ALT - Взаимодействие ]");
        else
            strcat(label, "\n{FF0000}[ Выведен из строя ]");

        if (IsValidDynamic3DTextLabel(RadarInfo[id][riTextLabel])) return UpdateDynamic3DTextLabelText(RadarInfo[id][riTextLabel], 0x0077FFFF, label);
        RadarInfo[id][riTextLabel] = CreateDynamic3DTextLabel(label, 0x0077FFFF, RadarInfo[id][riX], RadarInfo[id][riY], RadarInfo[id][riZ], 10.0, .worldid = 0, .interiorid = 0);
    }

    return 1;
}

function Radar_DeleteFlashlight(id) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id) || Radar_IsBroken(id)) return 0;
    if (IsValidDynamicObject(RadarInfo[id][riObjects][16])) DestroyDynamicObject(RadarInfo[id][riObjects][16]);
    return 1;
}

stock Radar_SetLaserPosition(id, playerid) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id) || Radar_IsBroken(id)) return 0;
    if (!IsPlayerInAnyVehicle(playerid)) return 0;

    // Поворачиваем лазер к игроку
    new objectid = RadarInfo[id][riObjects][15];
    TurnDynamicObjectToPlayer(objectid, playerid);

    // Корректировка
    new Float: rZ; Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_Z, rZ);
    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_Z, rZ + 90);

    return 1;
}

function Radar_UpdateLaser(id, playerid) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id) || Radar_IsBroken(id) || !IsValidTimer(RadarInfo[id][riDeleteLaserTimer]) || !IsOnline(playerid)) {
        KillTimer(RadarInfo[id][riUpdateLaserTimer]);
        return 0;
    }

    Radar_SetLaserPosition(id, playerid);

    return 1;
}

function Radar_DeleteLaser(id) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id) || Radar_IsBroken(id)) return 0;

    Streamer_SetIntData(STREAMER_TYPE_OBJECT, RadarInfo[id][riObjects][15], E_STREAMER_WORLD_ID, 228);
    Streamer_SetIntData(STREAMER_TYPE_OBJECT, RadarInfo[id][riObjects][15], E_STREAMER_INTERIOR_ID, 228);

    return 1;
}

stock Radar_FlashLight(id) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id) || Radar_IsBroken(id)) return 0;

    Radar_DeleteFlashlight(id);
    new Float: x, Float: y, Float: z; GetDynamicObjectPos(RadarInfo[id][riObjects][12], x, y, z);
    RadarInfo[id][riObjects][16] = CreateDynamicObject(18670, x, y, z - 1.7, 0.000000, 0.000000, 0.000000, 0, 0, -1, 300.00, 300.00);
    Streamer_SetIntData(STREAMER_TYPE_OBJECT, RadarInfo[id][riObjects][16], STREAMER_RADAR_OBJECT, 1);
    if (IsValidTimer(RadarInfo[id][riDeleteFlashlightTimer])) KillTimer(RadarInfo[id][riDeleteFlashlightTimer]);
    RadarInfo[id][riDeleteFlashlightTimer] = SetTimerEx("Radar_DeleteFlashlight", 1000, false, "d", id);

    return 1;
}

stock Radar_Laser(id, playerid = -1) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id) || Radar_IsBroken(id)) return 0;

    new objectid = RadarInfo[id][riObjects][15];
    if (IsOnline(playerid)) {
        Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_WORLD_ID, 0);
        Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_INTERIOR_ID, 0);

        if (IsValidTimer(RadarInfo[id][riDeleteLaserTimer])) KillTimer(RadarInfo[id][riDeleteLaserTimer]);
        RadarInfo[id][riDeleteLaserTimer] = SetTimerEx("Radar_DeleteLaser", 4500, false, "d", id);
        if (IsValidTimer(RadarInfo[id][riUpdateLaserTimer])) KillTimer(RadarInfo[id][riUpdateLaserTimer]);
        RadarInfo[id][riUpdateLaserTimer] = SetTimerEx("Radar_UpdateLaser", 10, true, "dd", id, playerid);
    }

    return 1;
}

function Radar_RestorePosition(id) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id)) return 0;
    return Radar_Place(id);
}

stock Radar_Place(id, bool: status = true) {
    if (!Radar_IsExists(id)) return 0;

    if (status) {
        new bool: is_broken = bool: Radar_IsBroken(id);
        Radar_Place(id, false); // Удаляем объекты, если они уже были установлены
        
        new object_world = 17, object_int = 228;
        
        if (!is_broken) {
            // Основной объект (ноутбук)
            RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1326.328002, 1571.031616, 10.960308, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 18632, "fishingrod", "plastic", 0x00000000);
            gadd(RadarInfo[id][riObjects][0], 0, 0);
            RadarInfo[id][riObjects][1] = CreateDynamicObject(19087, 1326.328002, 1571.031616, 10.960308, 30.000000, 0.000000, 240.000000, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 3113, "carrierxr", "ws_shipmetal1", 0x00000000);
            gadd(RadarInfo[id][riObjects][1], 0, 0);
            RadarInfo[id][riObjects][2] = CreateDynamicObject(19087, 1326.328002, 1571.031616, 10.960308, 30.000000, 0.000000, 360.000000, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 3113, "carrierxr", "ws_shipmetal1", 0x00000000);
            gadd(RadarInfo[id][riObjects][2], 0, 0);
            RadarInfo[id][riObjects][3] = CreateDynamicObject(19087, 1326.328002, 1571.031616, 10.960308, 30.000000, 0.000000, 120.000000, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 3113, "carrierxr", "ws_shipmetal1", 0x00000000);
            gadd(RadarInfo[id][riObjects][3], 0, 0);
            RadarInfo[id][riObjects][4] = CreateDynamicObject(19893, 1326.328002, 1570.761352, 10.960308, 0.000000, 0.000000, 360.000000, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 18632, "fishingrod", "plastic", 0x00000000);
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
            gadd(RadarInfo[id][riObjects][4], 0, 0);
            RadarInfo[id][riObjects][5] = CreateDynamicObject(334, 1326.275146, 1571.127563, 10.940304, 90.000000, 0.000000, 270.000000, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 16322, "a51_stores", "steel64", 0x00000000);
            gadd(RadarInfo[id][riObjects][5], 0, 0);
            RadarInfo[id][riObjects][6] = CreateDynamicObject(19144, 1325.952148, 1571.001342, 11.160321, 15.300004, 0.000007, -0.000001, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 18632, "fishingrod", "plastic", 0x00000000);
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 1, 2127, "cj_kitchen", "CJ_RED", 0x00000000);
            gadd(RadarInfo[id][riObjects][6], 0, 0);
            RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1326.197875, 1571.001586, 11.110310, -89.999992, 179.999984, -90.000015, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 18632, "fishingrod", "plastic", 0x00000000);
            gadd(RadarInfo[id][riObjects][7], 0, 0);
            RadarInfo[id][riObjects][8] = CreateDynamicObject(19894, 1326.498168, 1571.001586, 11.110310, -89.999992, 179.999984, -90.000015, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 18632, "fishingrod", "plastic", 0x00000000);
            gadd(RadarInfo[id][riObjects][8], 0, 0);
            RadarInfo[id][riObjects][9] = CreateDynamicObject(19894, 1326.326049, 1571.031616, 11.220313, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 18632, "fishingrod", "plastic", 0x00000000);
            gadd(RadarInfo[id][riObjects][9], 0, 0);
            RadarInfo[id][riObjects][10] = CreateDynamicObject(19894, 1326.328002, 1571.171752, 11.110310, 270.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 18632, "fishingrod", "plastic", 0x00000000);
            gadd(RadarInfo[id][riObjects][10], 0, 0);
            RadarInfo[id][riObjects][11] = CreateDynamicObject(19894, 1326.328002, 1570.969604, 11.222311, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 18632, "fishingrod", "plastic", 0x00000000);
            gadd(RadarInfo[id][riObjects][11], 0, 0);
            RadarInfo[id][riObjects][12] = CreateDynamicObject(19623, 1326.327270, 1571.207153, 11.130313, 0.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 18632, "fishingrod", "plastic", 0x00000000);
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 3, 18632, "fishingrod", "plastic", 0x00000000);
            gadd(RadarInfo[id][riObjects][12], 0, 0);
            RadarInfo[id][riObjects][13] = CreateDynamicObject(19941, 1326.328369, 1571.197509, 11.150322, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][13], 0, 18632, "fishingrod", "plastic", 0x00000000);
            gadd(RadarInfo[id][riObjects][13], 0, 0);
            RadarInfo[id][riObjects][14] = CreateDynamicObject(19941, 1326.328369, 1571.197509, 11.120322, 180.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
            SetDynamicObjectMaterial(RadarInfo[id][riObjects][14], 0, 18632, "fishingrod", "plastic", 0x00000000);
            gadd(RadarInfo[id][riObjects][14], 0, 0);
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            RadarInfo[id][riObjects][15] = CreateDynamicObject(18643, 1325.951538, 1571.024658, 10.970321, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
            gadd(RadarInfo[id][riObjects][15], 228, 228); // Объект спрятан и отображается только в нужный момент

            // Корректировка позиции
            TSInfo[tsOffset][0] = -0.128173;
            TSInfo[tsOffset][1] = 0.042236;
            TSInfo[tsOffset][2] = 0.120000;

            MatrixDynamicObjectPos(0, RadarInfo[id][riX], RadarInfo[id][riY], RadarInfo[id][riZ], RadarInfo[id][riRX], RadarInfo[id][riRY], RadarInfo[id][riRZ]);
        } else {
            switch (1 + random(100)) {
                case 1..35: { // 2 версия разрушения (35%)
                    RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1326.268676, 1571.099121, 10.970118, 11.099998, 0.900001, 34.500011, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][0], 0, 0);
                    RadarInfo[id][riObjects][1] = CreateDynamicObject(19087, 1326.328002, 1571.031616, 10.960308, 33.100021, 1.100000, -124.900009, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 3113, "carrierxr", "ws_shipmetal1", 0x00000000);
                    gadd(RadarInfo[id][riObjects][1], 0, 0);
                    RadarInfo[id][riObjects][2] = CreateDynamicObject(19087, 1326.328002, 1571.031616, 10.960308, 36.000000, 1.299999, 360.000000, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 3113, "carrierxr", "ws_shipmetal1", 0x00000000);
                    gadd(RadarInfo[id][riObjects][2], 0, 0);
                    RadarInfo[id][riObjects][3] = CreateDynamicObject(19087, 1326.328002, 1571.031616, 10.960308, 35.100002, 0.000000, 124.399932, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 3113, "carrierxr", "ws_shipmetal1", 0x00000000);
                    gadd(RadarInfo[id][riObjects][3], 0, 0);
                    RadarInfo[id][riObjects][4] = CreateDynamicObject(19893, 1326.418945, 1570.880493, 10.918087, 11.099998, 0.900001, 34.500011, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 1, 14387, "dr_gsnew", "cd_tex2", 0x00000000);
                    gadd(RadarInfo[id][riObjects][4], 0, 0);
                    RadarInfo[id][riObjects][5] = CreateDynamicObject(334, 1326.169311, 1571.149658, 10.969779, 78.864028, 85.422599, -140.835128, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 16322, "a51_stores", "steel64", 0x00000000);
                    gadd(RadarInfo[id][riObjects][5], 0, 0);
                    RadarInfo[id][riObjects][6] = CreateDynamicObject(19144, 1326.000732, 1570.830932, 11.166330, 26.397958, 0.985989, 34.234886, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 1, 2127, "cj_kitchen", "CJ_RED", 0x00000000);
                    gadd(RadarInfo[id][riObjects][6], 0, 0);
                    RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1326.196533, 1570.978393, 11.113520, -78.864028, 274.577331, 39.164817, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][7], 0, 0);
                    RadarInfo[id][riObjects][8] = CreateDynamicObject(19894, 1326.443481, 1571.149291, 11.108892, -78.864028, 274.577331, 39.164817, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][8], 0, 0);
                    RadarInfo[id][riObjects][9] = CreateDynamicObject(19894, 1326.298706, 1571.059082, 11.225257, 11.099998, 0.900001, 34.500011, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][9], 0, 0);
                    RadarInfo[id][riObjects][10] = CreateDynamicObject(19894, 1326.209106, 1571.189941, 11.144275, -78.864006, -175.422607, 39.164882, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][10], 0, 0);
                    RadarInfo[id][riObjects][11] = CreateDynamicObject(19894, 1326.335205, 1571.009765, 11.215250, 11.099998, 0.900001, 34.500011, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][11], 0, 0);
                    RadarInfo[id][riObjects][12] = CreateDynamicObject(19623, 1326.191284, 1571.215332, 11.170728, -11.099998, -0.900001, -145.499954, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 3, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][12], 0, 0);
                    RadarInfo[id][riObjects][13] = CreateDynamicObject(19941, 1326.199951, 1571.205078, 11.188487, 11.099998, 0.900001, 34.500011, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][13], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][13], 0, 0);
                    RadarInfo[id][riObjects][14] = CreateDynamicObject(19941, 1326.196289, 1571.209594, 11.159052, -11.099997, 179.099990, -145.499984, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][14], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][14], 0, 0);
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    RadarInfo[id][riObjects][15] = CreateDynamicObject(18688, 1325.952026, 1570.738037, 9.420307, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                    gadd(RadarInfo[id][riObjects][15], 0, 0);

                    TSInfo[tsOffset][0] = -0.136596;
                    TSInfo[tsOffset][1] = -0.036132;
                    TSInfo[tsOffset][2] = -0.637525;
                }
                case 36..51: { // 3 версия разрушения (15%)
                    RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1325.755126, 1570.806396, 10.722577, 4.600006, -39.599964, -17.900032, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][0], 0, 0);
                    RadarInfo[id][riObjects][1] = CreateDynamicObject(19087, 1325.755126, 1570.806396, 10.722577, 47.214488, 20.037380, -157.906661, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 3113, "carrierxr", "ws_shipmetal1", 0x00000000);
                    gadd(RadarInfo[id][riObjects][1], 0, 0);
                    RadarInfo[id][riObjects][2] = CreateDynamicObject(19087, 1325.755126, 1570.806396, 10.722577, 15.360242, -41.216545, 12.167108, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 3113, "carrierxr", "ws_shipmetal1", 0x00000000);
                    gadd(RadarInfo[id][riObjects][2], 0, 0);
                    RadarInfo[id][riObjects][3] = CreateDynamicObject(19087, 1325.755126, 1570.806396, 10.722577, 14.729486, 12.932216, 102.482681, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 3113, "carrierxr", "ws_shipmetal1", 0x00000000);
                    gadd(RadarInfo[id][riObjects][3], 0, 0);
                    RadarInfo[id][riObjects][4] = CreateDynamicObject(19893, 1325.672363, 1570.550048, 10.700902, 4.600025, -39.599956, -17.900060, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 1, 14387, "dr_gsnew", "cd_tex2", 0x00000000);
                    gadd(RadarInfo[id][riObjects][4], 0, 0);
                    RadarInfo[id][riObjects][5] = CreateDynamicObject(334, 1325.759033, 1570.909912, 10.681324, 50.177452, 172.805923, 77.637153, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 16322, "a51_stores", "steel64", 0x00000000);
                    gadd(RadarInfo[id][riObjects][5], 0, 0);
                    RadarInfo[id][riObjects][6] = CreateDynamicObject(19144, 1325.351074, 1570.912353, 10.634958, 16.261367, -41.440956, -7.809256, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 1, 2127, "cj_kitchen", "CJ_RED", 0x00000000);
                    gadd(RadarInfo[id][riObjects][6], 0, 0);
                    RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1325.558715, 1570.835693, 10.752696, -50.177452, 187.194061, -102.362838, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][7], 0, 0);
                    RadarInfo[id][riObjects][8] = CreateDynamicObject(19894, 1325.774169, 1570.750000, 10.943493, -50.177452, 187.194061, -102.362838, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][8], 0, 0);
                    RadarInfo[id][riObjects][9] = CreateDynamicObject(19894, 1325.591064, 1570.842651, 10.921028, 4.600006, -39.599964, -17.900032, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][9], 0, 0);
                    RadarInfo[id][riObjects][10] = CreateDynamicObject(19894, 1325.704223, 1570.959960, 10.849022, -50.177459, 97.194053, -102.362861, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][10], 0, 0);
                    RadarInfo[id][riObjects][11] = CreateDynamicObject(19894, 1325.572143, 1570.783691, 10.918830, 4.600006, -39.599964, -17.900032, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][11], 0, 0);
                    RadarInfo[id][riObjects][12] = CreateDynamicObject(19623, 1325.702026, 1570.996582, 10.866758, -4.600006, 39.599964, 162.099945, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 3, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][12], 0, 0);
                    RadarInfo[id][riObjects][13] = CreateDynamicObject(19941, 1325.687255, 1570.989868, 10.882050, 4.600006, -39.599964, -17.900032, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][13], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][13], 0, 0);
                    RadarInfo[id][riObjects][14] = CreateDynamicObject(19941, 1325.706054, 1570.985717, 10.859010, -4.600002, -140.400024, 162.099960, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][14], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][14], 0, 0);
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    RadarInfo[id][riObjects][15] = CreateDynamicObject(18704, 1326.316528, 1570.660278, 9.216628, -1.799999, -25.099998, -16.599998, object_world, object_int, -1, 300.00, 300.00); 
                    gadd(RadarInfo[id][riObjects][15], 0, 0);

                    TSInfo[tsOffset][0] = 0.073242;
                    TSInfo[tsOffset][1] = -0.043823;
                    TSInfo[tsOffset][2] = -0.642516;
                }
                default: { // 1 версия разрушения (45%)
                    RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1326.712036, 1574.065429, 10.886045, -4.747470, 12.423851, -34.958362, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][0], 0, 0);
                    RadarInfo[id][riObjects][1] = CreateDynamicObject(19087, 1326.712036, 1574.065429, 10.886045, 30.201633, -11.061601, -136.169357, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 3113, "carrierxr", "ws_shipmetal1", 0x00000000);
                    gadd(RadarInfo[id][riObjects][1], 0, 0);
                    RadarInfo[id][riObjects][2] = CreateDynamicObject(19087, 1326.712036, 1574.065429, 10.886045, 32.415534, 21.729801, -76.648292, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 3113, "carrierxr", "ws_shipmetal1", 0x00000000);
                    gadd(RadarInfo[id][riObjects][2], 0, 0);
                    RadarInfo[id][riObjects][3] = CreateDynamicObject(19087, 1326.712036, 1574.065429, 10.886045, 32.398666, -2.788732, 86.196357, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 3113, "carrierxr", "ws_shipmetal1", 0x00000000);
                    gadd(RadarInfo[id][riObjects][3], 0, 0);
                    RadarInfo[id][riObjects][4] = CreateDynamicObject(19893, 1326.557617, 1573.844726, 10.908425, -4.747470, 12.423851, -34.958362, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 1, 8480, "csrspalace01", "black32", 0x00000000);
                    gadd(RadarInfo[id][riObjects][4], 0, 0);
                    RadarInfo[id][riObjects][5] = CreateDynamicObject(334, 1326.720703, 1574.175415, 10.869961, 76.713333, -21.107568, -104.367736, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 16322, "a51_stores", "steel64", 0x00000000);
                    gadd(RadarInfo[id][riObjects][5], 0, 0);
                    RadarInfo[id][riObjects][6] = CreateDynamicObject(19144, 1325.869873, 1574.497680, 9.990758, 17.800004, -75.400001, 24.899986, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 1, 2127, "cj_kitchen", "CJ_RED", 0x00000000);
                    gadd(RadarInfo[id][riObjects][6], 0, 0);
                    RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1326.625488, 1574.107055, 11.062417, -76.713333, 21.107612, 75.632232, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][7], 0, 0);
                    RadarInfo[id][riObjects][8] = CreateDynamicObject(19894, 1326.862915, 1573.934692, 10.998029, -76.713333, 21.107612, 75.632232, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][8], 0, 0);
                    RadarInfo[id][riObjects][9] = CreateDynamicObject(19894, 1326.768432, 1574.051757, 11.139507, -4.747470, 12.423851, -34.958362, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][9], 0, 0);
                    RadarInfo[id][riObjects][10] = CreateDynamicObject(19894, 1326.825561, 1574.171386, 11.020440, -76.713333, -68.892303, 75.632217, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][10], 0, 0);
                    RadarInfo[id][riObjects][11] = CreateDynamicObject(19894, 1326.734863, 1573.999755, 11.146165, -4.747470, 12.423851, -34.958362, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][11], 0, 0);
                    RadarInfo[id][riObjects][12] = CreateDynamicObject(19623, 1326.849487, 1574.199584, 11.037131, 4.747482, -12.423845, 145.041549, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 3, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][12], 0, 0);
                    RadarInfo[id][riObjects][13] = CreateDynamicObject(19941, 1326.849365, 1574.189819, 11.057155, -4.747470, 12.423851, -34.958362, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][13], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][13], 0, 0);
                    RadarInfo[id][riObjects][14] = CreateDynamicObject(19941, 1326.842651, 1574.191528, 11.027957, 4.747449, 167.576141, 145.041687, object_world, object_int, -1, 300.00, 300.00); 
                    SetDynamicObjectMaterial(RadarInfo[id][riObjects][14], 0, 18632, "fishingrod", "plastic", 0x00000000);
                    gadd(RadarInfo[id][riObjects][14], 0, 0);
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    RadarInfo[id][riObjects][15] = CreateDynamicObject(18717, 1327.211547, 1573.505004, 9.493952, -17.700000, -17.700002, 14.000007, object_world, object_int, -1, 300.00, 300.00); 
                    gadd(RadarInfo[id][riObjects][15], 0, 0);

                    TSInfo[tsOffset][0] = -0.086425;
                    TSInfo[tsOffset][1] = -0.161254;
                    TSInfo[tsOffset][2] = -0.565986;
                }
            }

            Radar_SetNormalZ(id); RadarInfo[id][riZ] -= 0.165;
            MatrixDynamicObjectPos(0, RadarInfo[id][riX], RadarInfo[id][riY], RadarInfo[id][riZ], RadarInfo[id][riRX], RadarInfo[id][riRY], RadarInfo[id][riRZ]);
            
            RadarInfo[id][riBroken] = true;
        }

        RadarInfo[id][riLastX] = RadarInfo[id][riX];
        RadarInfo[id][riLastY] = RadarInfo[id][riY];
        RadarInfo[id][riLastZ] = RadarInfo[id][riZ];

        // 3D текст
        Radar_UpdateLabel(id);

        // Добавляем метаданные объектам радаров
        for (new i = 0; i < 30; i++) {
            new objectid = RadarInfo[id][riObjects][i];
            if (IsValidDynamicObject(objectid)) Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, STREAMER_RADAR_OBJECT, 1);
        }
    } else {
        RadarInfo[id][riBroken] = false; // Помечаем радар исправным, если мы его удаляем

        // Удаляем объекты радара
        new nearest_objects[50];
        new count = Streamer_GetNearbyItems(RadarInfo[id][riLastX], RadarInfo[id][riLastY], RadarInfo[id][riLastZ], STREAMER_TYPE_OBJECT, nearest_objects, .range = 10.0, .worldid = 0);
        for (new i = 0; i < min(count, sizeof(nearest_objects)); i++) {
            new objectid = nearest_objects[i];
            if (Streamer_HasIntData(STREAMER_TYPE_OBJECT, objectid, STREAMER_RADAR_OBJECT)) {
                DestroyDynamicObject(objectid);
                RadarInfo[id][riObjects][i] = 0;
            }
        }
        DestroyDynamic3DTextLabel(RadarInfo[id][riTextLabel]);
        RadarInfo[id][riTextLabel] = Text3D: 0;
    }
    RadarInfo[id][riPlaced] = status;

    return 1;
}

stock Radar_GetOwner(id) {
    if (!Radar_IsExists(id)) return 0;
    return RadarInfo[id][riPID];
}

stock Radar_IsOwner(playerid, id) {
    if (!Radar_IsExists(id)) return 0;
    return Radar_GetOwner(id) == PlayerInfo[playerid][pID];
}

// Получает количество созданных радаров
stock Radar_GetAmount(creator_playerid = -1, bool: only_placed = false) {
    new count;
    for (new i = 0; i < MAX_RADARS; i++) {
        if (
            Radar_IsExists(i) // Существует
            && creator_playerid == -1 || PlayerInfo[creator_playerid][pID] == RadarInfo[i][riPID] // Установлен конкретным игроком
            && !only_placed || (only_placed && Radar_IsPlaced(i)) // Установлен в игровом мире
        ) count++;
    }
    return count;
}

stock Radar_GetFraction(id) {
    if (!Radar_IsExists(id)) return 0;
    return RadarInfo[id][riFraction];
}

function Radar_AutoUnplace(pid) {
    // Проверяем, не появился ли игрок в сети
    foreach (new id : Player) {
        if (PlayerInfo[id][pID] == pid) return 0;
    }

    // Если не появился, удаляем радары из игрового мира
    for (new i = 0; i < MAX_RADARS; i++) {
        if (Radar_IsPlaced(i) && Radar_GetOwner(i) == pid) {
            Radar_Place(i, false);
        }
    }

    return 1;
}

function Radar_Dialog_List(playerid) {
    new g = fraction(playerid);
    if (g < 1) return 0;

    new dialog_header[64];
    format(dialog_header, sizeof(dialog_header), "{ff9000}Радары %s", frakName[g]);

    new dialog_text[2048] = "{cccccc}Создатель\t{cccccc}Район\t{cccccc}Ограничение\t{cccccc}Статус\n";

    strcat(dialog_text, "{cccccc}Создать радар");
    for (new quan = 0, id = 0; id < MAX_RADARS; id++) {
        if (!Radar_IsExists(id)) continue;
        if (Radar_GetFraction(id) != g) continue;

        // Получаем ID, если игрок в сети
        new currentid = ReturnUser(RadarInfo[id][riOwnerName]), id_str[10];
        if (IsOnline(currentid)) format(id_str, sizeof(id_str), "[%d]", currentid);
        
        new findraiontolist = FindRaionPos(RadarInfo[id][riX], RadarInfo[id][riY], RadarInfo[id][riZ]);
        format(dialog_text, sizeof(dialog_text), "%s\n{ff9000}№%d. {cccccc}%s%s\t{cccccc}%s\t{ff9000}%d км/ч [$%s]\t%s",
            dialog_text,
            id + 1,
            RadarInfo[id][riOwnerName], id_str,
            gSAZones[findraiontolist][zName],
            RadarInfo[id][riMaxSpeed],
            FormatNumberWithCommas(RadarInfo[id][riFine]),

            Radar_IsBroken(id) ? "{ffff00}[Сломан]" : (Radar_IsPlaced(id) ? "{99ff66}[Установлен]" : "{ff6347}[Не установлен]")
        );

        quan++;
        List[quan][playerid] = id;
    }
    
    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
    return ShowDialog(playerid, _:RADAR_DIALOG_LIST, DIALOG_STYLE_TABLIST_HEADERS, dialog_header, dialog_text, "Выбрать", "Закрыть");
}

stock Radar_Dialog_Management(playerid, radarid, bool: single_dialog = false) {
    if (!Radar_IsExists(radarid)) return 0;

    new g = fraction(playerid);
    if (g < 1) return 0;

    new dialog_header[128];
    format(dialog_header, sizeof(dialog_header), "%s {ff9000}| Радар №%d [%s]", frakName[g], radarid + 1, RadarInfo[radarid][riOwnerName]);

    new dialog_text[512]; 
    format(dialog_text, sizeof(dialog_text), 
        "{99ff66}Отметить на карте\n" \
        "{99ff66}Посмотреть статистику\n" \
        "{cccccc}Изменить ограничение скорости [%d км/ч]\n" \
        "{cccccc}Изменить штраф [$%s]\n" \
        "{cccccc}Изменить расположение\n" \
        "%s\n" \
        "{ff6347}Удалить",

        RadarInfo[radarid][riMaxSpeed],
        FormatNumberWithCommas(RadarInfo[radarid][riFine]),
        Radar_IsPlaced(radarid) ? "{555555}Свернуть" : "{0088FF}Развернуть"
    );

    DP[0][playerid] = radarid;

    SetPVarInt(playerid, "RadarSingleDialog", single_dialog);

    PlayerPlaySound(playerid, 17006, 0.0, 0.0, 0.0);
    return ShowDialog(playerid, _:RADAR_DIALOG_MANAGEMENT, DIALOG_STYLE_LIST, dialog_header, dialog_text, "Выбрать", single_dialog ? "Закрыть" : "Назад");
}

stock Radar_Dialog_Stats(playerid, radarid) {
    if (!Radar_IsExists(radarid)) return 0;

    new dialog_text[512];
    format(dialog_text, sizeof(dialog_text), \
        "{0088FF}Статистика радара №%d\n\n" \
        "{cccccc}Количество выписанных штрафов: {ff6347}%d чел.\n" \
        "{cccccc}Общая сумма штрафов: {ff6347}$%s\n\n" \
        "{cccccc}Количество юнитов: {8066ff}%d\n" \
        "{cccccc}- Юниты будут переведены на счёт владельца при удалении радара",
        
        radarid + 1,
        RadarInfo[radarid][riTicketsIssued],
        FormatNumberWithCommas(RadarInfo[radarid][riFineTotal]),
        Radar_CalculateUnits(radarid)
    );

    ShowDialog(playerid, _:RADAR_DIALOG_STATS, DIALOG_STYLE_MSGBOX, "{ff9000}Статистика радара", dialog_text, "Закрыть", "");

    return 1;
}

stock Radar_Dialog_Set_MaxSpeed(playerid, radarid) {
    if (!Radar_IsExists(radarid)) return 0;

    new available_speed_limits[] = {60, 90, 120, 150, 200};

    new dialog_text[512];
    for (new quan, i = 0; i < sizeof(available_speed_limits); i++) {
        new current_speed_limit = available_speed_limits[i];
        format(dialog_text, sizeof(dialog_text), "%s\n{%s}%d км/ч",
            dialog_text,
            RadarInfo[radarid][riMaxSpeed] == current_speed_limit ? "ff9000" : "cccccc",
            current_speed_limit
        );
        List[quan++][playerid] = current_speed_limit;
    }

    return ShowDialog(playerid, _:RADAR_DIALOG_SET_MAXSPEED, DIALOG_STYLE_LIST, "{ff9000}Изменение скоростного лимита", dialog_text, "Применить", "Назад");
}

stock Radar_Dialog_Set_Fine(playerid, radarid) {
    if (!Radar_IsExists(radarid)) return 0;

    new available_fines[] = {500, 750, 1000, 1500, 2000};

    new dialog_text[512];
    for (new quan, i = 0; i < sizeof(available_fines); i++) {
        new current_fine = available_fines[i];
        format(dialog_text, sizeof(dialog_text), "%s\n{%s}$%s",
            dialog_text,
            RadarInfo[radarid][riFine] == current_fine ? "ff9000" : "cccccc",
            FormatNumberWithCommas(current_fine)
        );
        List[quan++][playerid] = current_fine;
    }

    return ShowDialog(playerid, _:RADAR_DIALOG_SET_FINE, DIALOG_STYLE_LIST, "{ff9000}Изменение штрафа", dialog_text, "Применить", "Назад");
}

stock Radar_Dialog_Place(playerid, radarid) {
    if (!Radar_IsExists(radarid)) return 0;

    new dialog_text[128];
    format(dialog_text, sizeof(dialog_text), "{cccccc}Вы действительно хотите %s этот радар?", !Radar_IsPlaced(radarid) ? "развернуть" : "свернуть");

    return ShowDialog(playerid, _:RADAR_DIALOG_PLACE, DIALOG_STYLE_MSGBOX, "{ff9000}Управление радаром", dialog_text, "Да", "Назад");
}

stock Radar_Dialog_Delete(playerid, radarid) {
    if (!Radar_IsExists(radarid)) return 0;
    return ShowDialog(playerid, _:RADAR_DIALOG_DELETE, DIALOG_STYLE_MSGBOX, "{ff9000}Управление радаром", "{ff6347}Вы действительно хотите удалить этот радар?\nУдаление безвозвратно сотрёт все статистические данные", "Да", "Назад");
}

// Проверяет, есть ли радар рядом с указанным игроком
stock Radar_IsAnyNearPlayer(playerid) {
    for (new i = 0; i < MAX_RADARS; i++) {
        if (!Radar_IsExists(i) || !Radar_IsPlaced(i)) continue;

        if (GetPlayerDistanceFromPoint(playerid, RadarInfo[i][riX], RadarInfo[i][riY], RadarInfo[i][riZ]) < RADAR_INTERVAL)
            return 1;
    }

    return 0;
}

// Проверяет есть ли с указанным радаром любой другой рядом
stock Radar_IsAnyNear(radarid) {
    for (new i = 0; i < MAX_RADARS; i++) {
        if (!Radar_IsExists(i) || !Radar_IsPlaced(i)) continue;

        if (GetDistanceBetweenCoords3d(RadarInfo[i][riX], RadarInfo[i][riY], RadarInfo[i][riZ], RadarInfo[radarid][riX], RadarInfo[radarid][riY], RadarInfo[radarid][riZ]) < RADAR_INTERVAL)
            return 1;
    }

    return 0;
}

stock Radar_GetNearest(playerid, Float: distance = 9999.0) {
    new slot = -1, Float: min_dist = distance;
    for (new i = 0; i < MAX_RADARS; i++) {
        if (!Radar_IsExists(i) || !Radar_IsPlaced(i)) continue;

        new Float: dist = GetPlayerDistanceFromPoint(playerid, RadarInfo[i][riX], RadarInfo[i][riY], RadarInfo[i][riZ]);
        if (dist < min_dist) {
            min_dist = dist;
            slot = i;
        }
    }
    return slot;
}

stock Radar_OnPlayerDisconnect(playerid) {
    for (new i = 0; i < MAX_RADARS; i++) {
        if (Radar_IsExists(i) && Radar_IsOwner(playerid, i)) {
            // Запускаем таймер на 5 минут и удаляем радар из игрового мира, если игрок не появится в сети
            if (IsValidTimer(RadarInfo[i][riAutoUnplaceTimer])) KillTimer(RadarInfo[i][riAutoUnplaceTimer]);
            RadarInfo[i][riAutoUnplaceTimer] = SetTimerEx("Radar_AutoUnplace", AUTO_UNPLACE_RADAR_TIME * 60 * 1000, false, "d", PlayerInfo[playerid][pID]);
            break;
        }
    }

    return 1;
}

stock Radar_OnPlayerConnect(playerid) {
    for (new i = 0; i < MAX_RADARS; i++) {
        if (Radar_IsExists(i) && Radar_IsOwner(playerid, i)) {
            format(RadarInfo[i][riOwnerName], 24, "%s", PlayerInfo[playerid][pName]);
        }
    }
    return 1;
}

stock Radar_IsOwnerOnline(radarid) {
    if (!Radar_IsExists(radarid)) return 0;

    foreach (new playerid : Player) {
        if (PlayerInfo[playerid][pID] == RadarInfo[radarid][riPID]) return 1;
    }

    return 0;
}

stock Radar_SetNormalZ(radarid) {
    CA_FindZ_For2DCoord(RadarInfo[radarid][riX], RadarInfo[radarid][riY], RadarInfo[radarid][riZ]);
    RadarInfo[radarid][riZ] += 1.2;

    return 1;
}

stock dialogCase_Radars(playerid, dialogid, response, listitem) {
    switch (e_DialogId: dialogid) {
        case RADAR_DIALOG_LIST: {
            if (!response) return 1;
            if (listitem == 0) {
                new g = fraction(playerid);

                if(MPGO[playerid] != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я на мероприятии");
	            if(Sleep[playerid] >= 1 || SleepRP[playerid] >= 1) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я сплю");
                if(!GetAccessRankOrg(playerid, g, 35, NO_FBI)) return 1;
                if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу установить радар, находясь в транспорте");
	            if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу установить радар в этом месте");
                if(Radar_GetAmount(playerid) >= RADAR_PER_PLAYER) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу создать больше %d %s", RADAR_PER_PLAYER, PluralToText(RADAR_PER_PLAYER, "радар", "радара", "радаров"));
                if(Radar_IsAnyNearPlayer(playerid)) return ErrorMessage(playerid, "{ff6347}Вы не можете установить радар близко с другим [ Минимальный радиус: "#RADAR_INTERVAL" метров");

                Radar_StartPump(playerid);
            } else if (listitem > 0) {
                new radarid = List[listitem][playerid];
                Radar_Dialog_Management(playerid, radarid);
            }
        }
        case RADAR_DIALOG_MANAGEMENT: {
            if (!response) {
                if (!GetPVarInt(playerid, "RadarSingleDialog")) Radar_Dialog_List(playerid);
                return 1;
            }

            new radarid = DP[0][playerid],
                g = fraction(playerid);

            if (listitem >= 2) {
                if (!Radar_IsOwner(playerid, radarid)) {
                    if (!GetAccessRankOrg(playerid, g, 36, NO_FBI)) return 1;
                }
                if (Radar_IsBroken(radarid)) {
                    ErrorText(playerid, "{ff6347}Этот радар неисправен, сейчас с ним нельзя взаимодействовать.");
                    return Radar_Dialog_Management(playerid, radarid);
                }
            }

            switch (listitem) {
                case 0: {
                    if (!Radar_IsPlaced(radarid)) {
                        ErrorText(playerid, "{ff6347}Этот радар нигде не размещён!");
                        return Radar_Dialog_Management(playerid, radarid);
                    }
                    CreateGps(playerid, RadarInfo[radarid][riX], RadarInfo[radarid][riY], RadarInfo[radarid][riZ], 0, 0, 5.0);
                    return SendClientMessage(playerid, COLOR_LIGHTBLUE, "{0088ff}[ {ffffff}Карта {0088ff}]{ffffff}: {0088ff}Радар №%d {ffffff}отмечен на карте", radarid + 1);
                }
                case 1: {
                    return Radar_Dialog_Stats(playerid, radarid);
                }
                case 2: {
                    return Radar_Dialog_Set_MaxSpeed(playerid, radarid);
                }
                case 3: {
                    return Radar_Dialog_Set_Fine(playerid, radarid);
                }
                case 4: {
                    if (!Radar_IsPlaced(radarid)) {
                        ErrorText(playerid, "{ff6347}Этот радар нигде не размещён!");
                        return Radar_Dialog_Management(playerid, radarid);
                    }

                    new Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz;
                    GetDynamicObjectPos(RadarInfo[radarid][riObjects][0], x, y, z);
                    GetDynamicObjectRot(RadarInfo[radarid][riObjects][0], rx, ry, rz);

                    new Float: dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
                    if (dist > 10.0) {
                        // Позиция для перемещения, если далеко от радара
                        frontme(playerid, 0.5, x, y, z, rz);
                        rx = 0.0; ry = 0.0;
                    }

                    return CreateEditPlayerObject(playerid, REDAKT_TYPE_RADAR, 1, radarid, 0, 19894, x, y, z, rx, ry, rz);
                }
                case 5: {
                    if (!Radar_IsPlaced(radarid) && Radar_IsAnyNear(radarid)) return ErrorMessage(playerid, "{ff6347}Рядом уже установлен другой радар [ Минимальный радиус: "#RADAR_INTERVAL" метров ]");
                    if (Radar_IsPlaced(radarid) && RadarInfo[radarid][riBroken]) return ErrorMessage(playerid, "{ff6347}Этот радар сейчас сломан, его нельзя свернуть в таком состоянии");
                    if (!Radar_IsPlaced(radarid) && !Radar_IsOwnerOnline(radarid)) return ErrorMessage(playerid, "{ff6347}Нельзя установить радар игрока не в сети");

                    return Radar_Dialog_Place(playerid, radarid);
                }
                case 6: {
                    return Radar_Dialog_Delete(playerid, radarid);
                }
                default: {}
            }
        }
        case RADAR_DIALOG_STATS: {
            new radarid = DP[0][playerid];
            Radar_Dialog_Management(playerid, radarid);
        }
        case RADAR_DIALOG_SET_MAXSPEED: {
            new radarid = DP[0][playerid];
            if (response) {
                RadarInfo[radarid][riMaxSpeed] = List[listitem][playerid];
                if (Radar_IsPlaced(radarid)) Radar_UpdateLabel(radarid, .create = false);
            }

            Radar_Dialog_Management(playerid, radarid);
        }
        case RADAR_DIALOG_SET_FINE: {
            new radarid = DP[0][playerid];
            if (response) {
                RadarInfo[radarid][riFine] = List[listitem][playerid];
                if (Radar_IsPlaced(radarid)) Radar_UpdateLabel(radarid, .create = false);
            }

            Radar_Dialog_Management(playerid, radarid);
        }
        case RADAR_DIALOG_PLACE: {
            new radarid = DP[0][playerid];
            if (!response) return Radar_Dialog_Management(playerid, radarid);

            new bool: status = !Radar_IsPlaced(radarid);
            Radar_Place(radarid, status);

            new string[50]; format(string, sizeof(string), "{99ff66}Вы успешно %s радар", status ? "развернули" : "свернули");
            SuccessMessage(playerid, string);
        }
        case RADAR_DIALOG_DELETE: {
            new radarid = DP[0][playerid];
            if (!response) return Radar_Dialog_Management(playerid, radarid);

            Radar_Delete(radarid);
            SuccessMessage(playerid, "{99ff66}Вы успешно удалили радар");
        }
        case RADAR_DIALOG_REPAIR: {
            new radarid = DP[0][playerid];
            if (!response) return 0;

            Radar_StartPump(playerid, radarid);
        }
    }

    return 1;
}

stock Radar_StartPump(playerid, radarid = -1) {
    new bool: is_repair = radarid > -1;

    GetPlayerPos(playerid, PlayerRadarInfo[playerid][priX], PlayerRadarInfo[playerid][priY], PlayerRadarInfo[playerid][priZ]);
    SetPVarInt(playerid, "oryjtemp", 0); SetPVarInt(playerid, "Arobsklad", 11);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Нужно %s радар {ff9000}[ Нажимайте %s ]", (is_repair ? "починить" : "установить"), buttonName[Device[playerid]]);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, false, true, true, true, true);
    PlayerPlaySound(playerid, 40405, 0.0, 0.0, 0.0);

    // Количество нажатий для выполнения действия
    SetPVarInt(playerid, "RadarRepair", radarid);
    DP[3][playerid] = is_repair ? RADAR_MANUAL_REPAIR_TIMES : RADAR_CREATING_TIMES;
    
    new string[64]; format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~PAѓAP: ~w~0/%d", DP[3][playerid]);
    GameTextForPlayer(playerid, string, 5000, 3);

    return 1;
}

stock Pump_Radar(playerid) {
    new radarid = GetPVarInt(playerid, "RadarRepair"),
        bool: is_repair = radarid > -1,
        MAX_TIMES = DP[3][playerid];

    new string[64];
    SetPVarInt(playerid, "oryjtemp", GetPVarInt(playerid, "oryjtemp") + 1 + random(2));

    // Проверка на дистанцию, доступ к радарам и прочее
    if (!IsPlayerInRangeOfPoint(playerid, 10.0, PlayerRadarInfo[playerid][priX], PlayerRadarInfo[playerid][priY], PlayerRadarInfo[playerid][priZ]) // Далеко от места установки
        || !is_repair && !GetAccessRankOrgMay(playerid, fraction(playerid), 35, NO_FBI) // Радар ставят, но нет доступа к размещению радара
        || (is_repair && !Radar_IsBroken(radarid))) // Радар чинят, но он уже починен
    {
        SetPVarInt(playerid, "oryjtemp", 0);
        SetPVarInt(playerid, "Arobsklad", 0);

        ClearAnim(playerid);
        PlayerPlaySound(playerid, 31203, 0.0, 0.0, 0.0);
        return 0;
    }

    new current_progress = GetPVarInt(playerid, "oryjtemp");
    if(current_progress >= MAX_TIMES) {
        SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad", 0);
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~PAѓAP: ~w~%d/%d", MAX_TIMES, MAX_TIMES);
        GameTextForPlayer(playerid, string, 1500, 3);
        PlayerPlaySound(playerid, 32000, 0, 0, 0);
        
        ClearAnim(playerid);

        if (is_repair) {
            Radar_SetBroken(radarid, false);
            SuccessMessage(playerid, "{99ff66}Вы успешно починили радар");
        } else {
            Radar_Create(playerid, RADAR_RADIUS, 90, 1000);
            SuccessMessage(playerid, "{99ff66}Вы успешно установили радар\nУстановлены настройки по умолчанию, вы можете изменить их в настройках [ ALT ]");
        }
        DeletePVar(playerid, "RadarRepair");
        ApplyAnimation(playerid, "OTB", "betslp_loop", 4.0, false, true, true, false, false, SYNC_ALL);
    } else {
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~PAѓAP: ~w~%d/%d", current_progress, MAX_TIMES);
        GameTextForPlayer(playerid, string, 1500, 3);
        ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, false, true, true, true, true);
        if (current_progress <= 5) PlayerPlaySound(playerid, 32401, 0.0, 0.0, 0.0);
        else if (current_progress % 3 == 0) PlayerPlaySound(playerid,  32000, 0.0, 0.0, 0.0);
    }

    return 1;
}

stock Radar_OnShoot(playerid, weaponid, objectid) {
    if (IsDepartmentOrganization(fraction(playerid))) return 0; // Пропускаем обработку выстрела по радару для сотрудников департамента

    for (new i = 0; i < MAX_RADARS; i++) {
        if (!Radar_IsExists(i) || !Radar_IsPlaced(i) || Radar_IsBroken(i)) continue;
        for (new objid = 0; objid < 30; objid++) {
            new currentobjectid = RadarInfo[i][riObjects][objid];
            if (currentobjectid == objectid) {
                if (weaponid >= 22 && weaponid <= 38) {
                    RadarInfo[i][riHits]++;

                    new string[64];
			        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~PAѓAP: ~w~%d/%d", RadarInfo[i][riHits], RADAR_BROKE_HITS_AMOUNT), GameTextForPlayer(playerid, string, 2000, 3);
                }

                if (RadarInfo[i][riHits] >= RADAR_BROKE_HITS_AMOUNT) {
                    // Выдаём розыск за порчу гос. имущества
                    new findUk, findP;
                    if (FindCriminalArticle("Порча гос", findUk, findP)) {
                        SetPlayerCriminal(playerid, -1, CriminalCodeInfo[findUk][findP][ccName], CriminalCodeInfo[findUk][findP][ccLevel], findUk, findP);
                    }

                    // Оповещаем полицейских о разрушении радара
                    new findraiontolist = FindRaionPos(RadarInfo[i][riX], RadarInfo[i][riY], RadarInfo[i][riZ]);
                    foreach (new currentid : Player) {
                        if (!IsPoliceMember(currentid)) continue;

                        SendClientMessage(currentid, COLOR_LIGHTNEUTRALBLUE, \
                            "[PD]: Порча государственного радара №%d, %s[%d] в районе %s",
                            
                            i + 1,
                            rpplayername(playerid), playerid,
                            gSAZones[findraiontolist][zName]
                        );
                    }

                    RadarInfo[i][riHits] = 0;
                    Radar_SetBroken(i, true);
                    if (IsValidTimer(RadarInfo[i][riRepairTimer])) KillTimer(RadarInfo[i][riRepairTimer]);
                    RadarInfo[i][riRepairTimer] = SetTimerEx("Radar_SetBroken", RADAR_BROKE_TIME * 60 * 1000, false, "dd", i, false);
                }
                return 1;
            }
        }
    }
    return 0;
}

stock Radar_OnPlayerPressALT(playerid) {
    if (GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0) {
        new g = fraction(playerid),
            radarid = Radar_GetNearest(playerid, .distance = 1.5);

        if (radarid > -1) {
            if (Radar_IsBroken(radarid)) { // Радар сломан
                // Предлагаем починить радар 
                if (IsPoliceMember(playerid) && GetPVarInt(playerid, "Arobsklad") != 11) {
                    DP[0][playerid] = radarid;

                    static const dialog_text[] = \
                        "{ff6347}Этот радар сломан\n\n" \
                        "{cccccc}Вы хотите его починить, чтобы восстановить его работу?";

                    return ShowDialog(playerid, _:RADAR_DIALOG_REPAIR, DIALOG_STYLE_MSGBOX, "{ff9000}Восстановление радара", dialog_text, "Да", "Закрыть");
                }
                return 0; // Нельзя взаимодействовать со сломанным радаром
            }

            if (RadarInfo[radarid][riFraction] == g) {
                ApplyAnimation(playerid, "OTB", "betslp_loop", 4.0, false, true, true, false, false, SYNC_ALL);
                return Radar_Dialog_Management(playerid, radarid, .single_dialog = true);
            }
            else if (IsPoliceMember(playerid)) return ErrorMessage(playerid, "{ff6347}Этот радар не принадлежит вашей организации");
            else return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не знаю, как этим пользоваться..");
        }
    }

    return 1;
}

stock Radar_ViolationHandler(playerid) {
    if(OnlineInfo[playerid][oLogged] == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(vehicleid >= swatcar[0] && vehicleid <= swatcar[1] || vehicleid >= armcar[0] && vehicleid <= armcar[1]
		|| vehicleid >= LSPDcar[0] && vehicleid <= LSPDcar[1] || vehicleid >= fbicar[0] && vehicleid <= fbicar[1]
		|| vehicleid == janswat[0] || vehicleid == janswat[1] || vehicleid == janswat[2] || vehicleid == janswat[3] || Cars[vehicleid] == 4 || Cars[vehicleid] == 3
		|| vehicleid >= SFPDcar[0] && vehicleid <= SFPDcar[1] || vehicleid >= NonLSCar[0] && vehicleid <= NonLSCar[1] || vehicleid >= NonSFCar[0] && vehicleid <= NonSFCar[1]
		|| Cars[vehicleid] == 1 || Cars[vehicleid] == 11 || Cars[vehicleid] == 2 || Cars[vehicleid] == 7 || Cars[vehicleid] == 28
	 	|| Cars[vehicleid] == 21 || Cars[vehicleid] == 22
		|| vehicleid >= Medcar[0] && vehicleid <= Medcar[1]){ }
		else
		{
	    	if(	IsACar(VehInfo[vehicleid][vModel]) || IsAMoto(VehInfo[vehicleid][vModel])
				&& (GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0))
	    	{
				for(new radarid = 0; radarid < MAX_RADARS; radarid++) // Ищем радары по близости
				{
                    if (!Radar_IsExists(radarid) || !Radar_IsPlaced(radarid)) continue;

					if (IsPlayerInRangeOfPoint(playerid, RadarInfo[radarid][riRadius], RadarInfo[radarid][riX], RadarInfo[radarid][riY], RadarInfo[radarid][riZ])) {
						// Пропускаем, если радар неисправен
                        if (Radar_IsBroken(radarid)) continue;
                        
                        // Пропускаем, если скорость не больше допустимой
                        if (WatchSpeed[playerid] <= RadarInfo[radarid][riMaxSpeed] + 1.0) continue;

                        // Пропускаем, если высота игрока сильно отличается от высоты расположения радара
                        new Float: playerPos[3], Float: radarPos[3];
                        GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);
                        GetDynamicObjectPos(RadarInfo[radarid][riObjects][0], radarPos[0], radarPos[1], radarPos[2]);
                        if (floatabs(playerPos[2] - radarPos[2]) > 2.5) continue;

                        // Пропускаем, если КД еще не прошло
                        if (PlayerRadarInfo[playerid][priCooldown] > 0 && PlayerRadarInfo[playerid][priLastRadar] == radarid) continue;

						new string[144];
						SendClientMessage(playerid, 0x0088FFFF, "Нарушение скоростного режима [ %.0f км/ч | %d км/ч ] | {FF6347}Штраф: $%d", WatchSpeed[playerid], RadarInfo[radarid][riMaxSpeed], RadarInfo[radarid][riFine]);
						if (PlayerInfo[playerid][pAccount] >= RadarInfo[radarid][riFine]) {
							PlayerInfo[playerid][pAccount] -= RadarInfo[radarid][riFine];
							MoneyLog("fine", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -RadarInfo[radarid][riFine], "Штраф: превышение скорости");

                            // Выплаты
                            new fine_percent = RadarInfo[radarid][riFine] / 100;
                            OrganInfo[RadarInfo[radarid][riFraction]][glave] += fine_percent * RADAR_POLICE_SHARE; // Часть от штрафа на счёт организации
                            putkazna(0, fine_percent * RADAR_GOVERNMENT_SHARE); // Часть от штрафа в казну
						}
						else PlayerInfo[playerid][pAmmos11] += RadarInfo[radarid][riFine];

						format(string, sizeof(string), "превышение скорости [ %.0f КМ/Ч ]", WatchSpeed[playerid]);
						SetPlayerChatBubble(playerid, string, COLOR_LIGHTRED, 30.0, 10000);
						PlayerRadarInfo[playerid][priCooldown] = 5;
                        PlayerRadarInfo[playerid][priLastRadar] = radarid;

                        // Лазер и вспышка при нарушении
                        Radar_Laser(radarid, playerid);
                        Radar_FlashLight(radarid);

                        // Подсчёт статистики
                        RadarInfo[radarid][riTicketsIssued]++;
                        RadarInfo[radarid][riFineTotal] += RadarInfo[radarid][riFine];
                        if (RadarInfo[radarid][riTicketsIssued] % 3 == 0) SaveRadars(radarid);

                        // Обнуление попаданий
                        RadarInfo[radarid][riHits] = 0;

                        // Проигрывание звуков
                        foreach (new currentid : Player) {
                            if (GetPlayerDistanceFromPoint(currentid, radarPos[0], radarPos[1], radarPos[2]) > RADAR_RADIUS) continue;

                            Streamer_Update(currentid);
                            PlayerPlaySound(currentid, 1132, 0.0, 0.0, 0.0);
                        }

                        PlayerPlaySound(playerid, 45400, 0.0, 0.0, 0.0);

						break;
					}
				}
			}
		}
	}
	return 1;
}
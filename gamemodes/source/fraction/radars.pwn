stock SaveRadars(id = -1) {
    new query_string[1024];

    new minid = (id > -1 ? 0 : id),
        maxid = (id > -1 ? id + 1 : MAX_RADARS);

    for (new i = minid; i < maxid; i++) {
        if (Radar_IsExists(i)) {
            mysql_format(pearsq, query_string, sizeof(query_string),
                "REPLACE INTO `radars` (`id`, `fraction`, `owner`, `placed`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `radius`, `max_speed`, `fine`, `tickets_issued`, `fine_total`, `fine_total_before_units`) \
                VALUES(%d, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %d, %d, %d, %d, %d)",
                
                i,
                RadarInfo[i][riFraction],
                RadarInfo[i][riPID],
                RadarInfo[i][riPlaced],
                RadarInfo[i][riX], RadarInfo[i][riY], RadarInfo[i][riZ], RadarInfo[i][riRX], RadarInfo[i][riRY], RadarInfo[i][riRZ],
                RadarInfo[i][riRadius],
                RadarInfo[i][riMaxSpeed],
                RadarInfo[i][riFine],
                RadarInfo[i][riTicketsIssued],
                RadarInfo[i][riFineTotal],
                RadarInfo[i][riFineTotalBeforeUnits]
            );
        } else {
            mysql_format(pearsq, query_string, sizeof(query_string),
                "DELETE FROM `radars` WHERE `id` = %d",
                i
            );
        }
        query_empty(pearsq, query_string);
    }

    return 1;
}

function LoadRadars() {
    new rows;
    cache_get_row_count(rows);

    for (new i = 0; i < min(rows, MAX_RADARS); i++) {
        new id;
        cache_get_value_name_int(i, "id", id);

        cache_get_value_name(i, "Name", RadarInfo[id][riOwnerName], 24);
        
        cache_get_value_name_int(i, "fraction", RadarInfo[id][riFraction]);
        cache_get_value_name_int(i, "owner", RadarInfo[id][riPID]);
        cache_get_value_name_int(i, "placed", RadarInfo[id][riPlaced]);
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
        cache_get_value_name_int(i, "fine_total_before_units", RadarInfo[id][riFineTotalBeforeUnits]);

        if (RadarInfo[id][riPlaced]) Radar_Place(id);
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

stock Radar_GetMaxRadarsForPlayer(playerid) {
    new amount = RADAR_PER_PLAYER;
    if (IsLeader(playerid) || IsSubLeader(playerid)) amount += 1; // +1 для заместителей и лидеров

    return amount;
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

stock Radar_CalculateUnits(radarid, playerid = -1) {
    if (!Radar_IsExists(radarid)) return 0;

    new fine_total = RadarInfo[radarid][riFineTotal] - RadarInfo[radarid][riFineTotalBeforeUnits];
    new Float: police_share = fine_total / 100.0 * RADAR_POLICE_SHARE;

    new Float: units = police_share / 100.0 * Float: OrganInfo[RadarInfo[radarid][riFraction]][gUnit][24];

    if (playerid > -1) {
        // Высчитываем сколько юнитов с радара получит конкретный игрок
        new radars_total = Radar_GetAmount(.fraction = Radar_GetFraction(radarid), .placed = true);
        new radars_player = Radar_GetAmount(.playerid = playerid, .fraction = Radar_GetFraction(radarid), .placed = true);

        if (radars_total == 0) return 0;

        new Float: player_units = units * (Float: radars_player / Float: radars_total);

        return _:player_units;
    }

    return _:units;
}

stock Radar_CollectUnits(radarid) {
    new bool: success_payment = false;

    new units = Radar_CalculateUnits(radarid);
    if (units > 0) {
        new radars_total = Radar_GetAmount(.fraction = Radar_GetFraction(radarid), .placed = true);
        
        {
            new radars_pid[MAX_RADARS];
            new radars_amount[MAX_RADARS];

            // Считаем количество установленных радаров у игроков
            for (new i = 0; i < MAX_RADARS; i++) {
                if (Radar_GetFraction(i) != Radar_GetFraction(radarid)) continue;
                if (!Radar_IsPlaced(i)) continue;

                new ownerid = RadarInfo[i][riPID];
                for (new j = 0; j < sizeof(radars_pid); j++) {
                    if (radars_pid[j] == ownerid || radars_pid[j] == 0) {
                        radars_pid[j] = ownerid;
                        radars_amount[j]++;
                        break;
                    }
                }
            }

            // Выплачиваем юниты, исходя из количества установленных каждым игроком в организации
            for (new i = 0; i < sizeof(radars_pid); i++) {
                new ownerid = radars_pid[i];
                if (ownerid == 0) break;
                
                new radars_player = radars_amount[i];
                new player_units = _:(Float: units * (Float: radars_player / Float: radars_total));

                success_payment = true;
                
                new bool: player_online = false;
                foreach (new playerid : Player) {
                    if (PlayerInfo[playerid][pID] == ownerid) {
                        player_online = true;
                        GivePlayerUnit(playerid, player_units);
                        break;
                    }
                }

                // Если игрок не в сети - начисляем юниты Offline
                if (!player_online) {
                    new string[128];
                    // Запрос кидается
                    mysql_format(pearsq, string, sizeof(string), "UPDATE `pp_igroki` SET `Unit` = `Unit` + %d WHERE `user_id` = %d", player_units, ownerid);
                    query_empty(pearsq, string);
                }
            }
        }
    }

    // Если юниты были выплачены (есть хотя бы один игрок для их получения и т.п.)
    if (success_payment) {
        // Вычитаем юниты из радара и сохраняем
        RadarInfo[radarid][riFineTotalBeforeUnits] = RadarInfo[radarid][riFineTotal];
        SaveRadars(radarid);
    }

    return 1;
}

stock Radar_Delete(radarid) {
    // Выплачиваем юниты
    Radar_CollectUnits(radarid);

    // Убираем из игрового мира
    Radar_Place(radarid, false);

    // Удаление таймеров
    KillTimer(RadarInfo[radarid][riDeleteLaserTimer]);
    KillTimer(RadarInfo[radarid][riUpdateLaserTimer]);
    KillTimer(RadarInfo[radarid][riDeleteFlashlightTimer]);
    KillTimer(RadarInfo[radarid][riRepairTimer]);
    KillTimer(RadarInfo[radarid][riLabelNoFixTimer]);
    
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
    return RadarInfo[id][riBroken] != RADAR_BROKEN_NONE;
}

stock Radar_IsPlayerNear(playerid, id, Float: radius = RADAR_RADIUS) {
    if (GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return 0;
    if (!IsPlayerInRangeOfPoint(playerid, radius, RadarInfo[id][riX], RadarInfo[id][riY], RadarInfo[id][riZ])) return 0;

    return 1;
}

function Radar_SetBroken(id, e_RadarBroken: status) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id)) return 0;
    if (RadarInfo[id][riBroken] == status) return 0;

    RadarInfo[id][riBroken] = status;
    if (status == RADAR_BROKEN_NO_FIX) {
        foreach (new currentid : Player) {
            if (!Radar_IsPlayerNear(currentid, id)) continue;

            PlayerPlaySound(currentid, 17003);
        }
    } else if (status == RADAR_BROKEN_NONE && RadarInfo[id][riBrokeReason] == RADAR_BROKE_REASON_PLAYER) {
        RadarInfo[id][riBrokenTime] = gettime();
    }

    if (status == RADAR_BROKEN_NO_FIX) {
        if (IsValidTimer(RadarInfo[id][riRepairTimer])) KillTimer(RadarInfo[id][riRepairTimer]);
        RadarInfo[id][riRepairTimer] = SetTimerEx("Radar_SetBroken", RADAR_BROKE_NO_FIX_TIME * 60 * 1000, false, "dd", id, RADAR_BROKEN_FIX);
        RadarInfo[id][riRepairTimerStarted] = gettime();
    } else if (status == RADAR_BROKEN_FIX) {
        if (IsValidTimer(RadarInfo[id][riRepairTimer])) KillTimer(RadarInfo[id][riRepairTimer]);
        RadarInfo[id][riRepairTimer] = SetTimerEx("Radar_SetBroken", RADAR_BROKE_TIME * 60 * 1000, false, "dd", id, RADAR_BROKEN_NONE);
        RadarInfo[id][riRepairTimerStarted] = gettime();
    }

    if (status == RADAR_BROKEN_NONE) {
        // Сбрасываем всем ID радара по которому был произведен выстрел последний раз
        foreach (new currentid : Player) {
            if (PlayerRadarInfo[currentid][priLastRadar] == id) {
                PlayerRadarInfo[currentid][priLastRadar] = -1;
            }
        }
    }

    // Пересоздаем радар и 3D текст
    Radar_Place(id);

    return 1;
}

function Radar_UpdateLabelNoFix(id) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id) || RadarInfo[id][riBroken] != RADAR_BROKEN_NO_FIX) return 0;
    Radar_UpdateLabel(id);
    SetTimerEx("Radar_UpdateLabelNoFix", 1000, false, "d", id);
    return 1;
}

stock Radar_UpdateLabel(id) {
    if (!Radar_IsExists(id)) return 0;

    if (!Radar_IsPlaced(id)) {
        DestroyDynamic3DTextLabel(RadarInfo[id][riTextLabel]);
        RadarInfo[id][riTextLabel] = Text3D: 0;
    } else {
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

        switch(RadarInfo[id][riBroken]) {
            case RADAR_BROKEN_NO_FIX: {
                format(label, sizeof(label),
                    "%s\n\n{FF6347}Выведен из строя\n{CCCCCC}[ Можно починить через: %s ]",

                    label,
                    fine_time( RADAR_BROKE_NO_FIX_TIME * 60 - (gettime() - RadarInfo[id][riRepairTimerStarted]) )
                );
            }
            case RADAR_BROKEN_FIX: {
                strcat(label, "\n\n{FFFF00}Выведен из строя");
            }
            default: {
                strcat(label, "\n{FF9000}[ ALT - Взаимодействие ]");
            }
        }
            

        if (IsValidDynamic3DTextLabel(RadarInfo[id][riTextLabel])) return UpdateDynamic3DTextLabelText(RadarInfo[id][riTextLabel], 0x0077FFFF, label);
        RadarInfo[id][riTextLabel] = CreateDynamic3DTextLabel(label, 0x0077FFFF, RadarInfo[id][riX], RadarInfo[id][riY], RadarInfo[id][riZ], 10.0, .worldid = 0, .interiorid = 0);
    }

    return 1;
}

function Radar_DeleteFlashlight(id) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id) || Radar_IsBroken(id)) return 0;
    if (IsValidDynamicObject(RadarInfo[id][riObjects][29])) DestroyDynamicObject(RadarInfo[id][riObjects][29]);
    return 1;
}

stock Radar_SetLaserPosition(id, playerid) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id) || Radar_IsBroken(id)) return 0;
    if (!IsPlayerInAnyVehicle(playerid)) return 0;

    // Поворачиваем лазер к игроку
    new objectid = RadarInfo[id][riObjects][8];
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

    Streamer_SetIntData(STREAMER_TYPE_OBJECT, RadarInfo[id][riObjects][8], E_STREAMER_WORLD_ID, INVISIBLE_VIRTUAL_WORLD);
    Streamer_SetIntData(STREAMER_TYPE_OBJECT, RadarInfo[id][riObjects][8], E_STREAMER_INTERIOR_ID, INVISIBLE_VIRTUAL_WORLD);

    return 1;
}

stock Radar_FlashLight(id) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id) || Radar_IsBroken(id)) return 0;

    Radar_DeleteFlashlight(id);
    for (new i = 0; i < RADAR_MAX_OBJECTS; i++) {
        new objectid = RadarInfo[id][riObjects][i];
        if (!IsValidDynamicObject(objectid)) continue;

        new model = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);
        if (model == 19143) { // Объект камеры
            new Float: x, Float: y, Float: z; GetDynamicObjectPos(objectid, x, y, z);
            RadarInfo[id][riObjects][29] = CreateDynamicObject(18670, x, y, z - 1.7, 0.000000, 0.000000, 0.000000, 0, 0, -1, 300.00, 300.00);
            if (IsValidTimer(RadarInfo[id][riDeleteFlashlightTimer])) KillTimer(RadarInfo[id][riDeleteFlashlightTimer]);
            RadarInfo[id][riDeleteFlashlightTimer] = SetTimerEx("Radar_DeleteFlashlight", 1000, false, "d", id);
            return 1;
        }
    }

    return 1;
}

stock Radar_Laser(id, playerid = -1) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id) || Radar_IsBroken(id)) return 0;
    if (!IsOnline(playerid)) return 0;

    Streamer_SetIntData(STREAMER_TYPE_OBJECT, RadarInfo[id][riObjects][8], E_STREAMER_WORLD_ID, 0);
    Streamer_SetIntData(STREAMER_TYPE_OBJECT, RadarInfo[id][riObjects][8], E_STREAMER_INTERIOR_ID, 0);

    if (IsValidTimer(RadarInfo[id][riDeleteLaserTimer])) KillTimer(RadarInfo[id][riDeleteLaserTimer]);
    RadarInfo[id][riDeleteLaserTimer] = SetTimerEx("Radar_DeleteLaser", 4500, false, "d", id);
    if (IsValidTimer(RadarInfo[id][riUpdateLaserTimer])) KillTimer(RadarInfo[id][riUpdateLaserTimer]);
    RadarInfo[id][riUpdateLaserTimer] = SetTimerEx("Radar_UpdateLaser", 10, true, "dd", id, playerid);

    return 1;
}

stock Radar_Explode(id) {
    if (!Radar_IsExists(id) || !Radar_IsPlaced(id) || !Radar_IsBroken(id)) return 0;
    
    
    return 1;
}

stock Radar_Place(id, bool: status = true) {
    if (!Radar_IsExists(id)) return 0;

    if (status) {
        new e_RadarBroken: brokenStatus = RadarInfo[id][riBroken];
        Radar_Place(id, false); // Удаляем объекты, если они уже были установлены
        
        new object_world = 17, object_int = INVISIBLE_VIRTUAL_WORLD;

        if (RadarInfo[id][riMaxSpeed] <= 60.0) {
            if (!brokenStatus) {
                RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1323.328002, 1571.031616, 10.960308, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                gadd(RadarInfo[id][riObjects][0], 0, 0);
                RadarInfo[id][riObjects][1] = CreateDynamicObject(19893, 1323.328002, 1570.760375, 10.960308, 0.000000, 0.000000, 360.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 16322, "a51_stores", "steel64", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
                gadd(RadarInfo[id][riObjects][1], 0, 0);
                RadarInfo[id][riObjects][2] = CreateDynamicObject(334, 1323.279052, 1571.169555, 10.790301, 89.999992, 0.000121, -89.999961, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 16322, "a51_stores", "steel64", 0x00000000);
                gadd(RadarInfo[id][riObjects][2], 0, 0);
                RadarInfo[id][riObjects][3] = CreateDynamicObject(19144, 1322.956054, 1571.043334, 11.010315, 15.300004, 0.000068, -0.000016, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 1, 2127, "cj_kitchen", "CJ_RED", 0x00000000);
                gadd(RadarInfo[id][riObjects][3], 0, 0);
                RadarInfo[id][riObjects][4] = CreateDynamicObject(19894, 1323.197875, 1571.001586, 11.116310, -89.999992, 179.999984, -90.000015, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                gadd(RadarInfo[id][riObjects][4], 0, 0);
                RadarInfo[id][riObjects][5] = CreateDynamicObject(19894, 1323.498168, 1571.001586, 11.116310, -89.999992, 179.999984, -90.000015, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                gadd(RadarInfo[id][riObjects][5], 0, 0);
                RadarInfo[id][riObjects][6] = CreateDynamicObject(19894, 1323.326049, 1571.031616, 11.220313, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                gadd(RadarInfo[id][riObjects][6], 0, 0);
                RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1323.328002, 1571.171752, 11.116310, 270.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                gadd(RadarInfo[id][riObjects][7], 0, 0);
                RadarInfo[id][riObjects][8] = CreateDynamicObject(18643, 1322.955444, 1571.066650, 10.820317, 0.000060, 0.000000, 89.999816, object_world, object_int, -1, 300.00, 300.00); // Laser Red
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                gadd(RadarInfo[id][riObjects][8], INVISIBLE_VIRTUAL_WORLD, INVISIBLE_VIRTUAL_WORLD);
                RadarInfo[id][riObjects][9] = CreateDynamicObject(19894, 1323.328002, 1570.969604, 11.219310, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                gadd(RadarInfo[id][riObjects][9], 0, 0);
                RadarInfo[id][riObjects][10] = CreateDynamicObject(19967, 1323.330566, 1571.037353, 11.030100, -27.000001, 180.000000, -0.000026, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 1, 16322, "a51_stores", "steel64", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                gadd(RadarInfo[id][riObjects][10], 0, 0);
                RadarInfo[id][riObjects][11] = CreateDynamicObject(19967, 1323.330566, 1571.037353, 11.030100, -26.999984, -179.999984, 119.999961, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 1, 16322, "a51_stores", "steel64", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                gadd(RadarInfo[id][riObjects][11], 0, 0);
                RadarInfo[id][riObjects][12] = CreateDynamicObject(19967, 1323.330566, 1571.037353, 11.030100, -26.999996, -179.999984, -119.999984, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 1, 16322, "a51_stores", "steel64", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                gadd(RadarInfo[id][riObjects][12], 0, 0);
                RadarInfo[id][riObjects][13] = CreateDynamicObject(19143, 1323.332519, 1571.117431, 11.285957, 19.000013, 0.000085, -0.000021, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][13], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][13], 1, 19623, "camera1", "cscamera02", 0x00000000);
                gadd(RadarInfo[id][riObjects][13], 0, 0);

                TSInfo[tsOffset][2] = 0.077821;
            } else {
                switch (brokenStatus) {
                    case RADAR_BROKEN_NO_FIX: {
                        RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1323.322875, 1567.060546, 10.979763, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        gadd(RadarInfo[id][riObjects][0], 0, 0);
                        RadarInfo[id][riObjects][1] = CreateDynamicObject(19893, 1323.234497, 1566.807128, 10.942198, 7.976202, 13.235788, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 16322, "a51_stores", "steel64", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
                        gadd(RadarInfo[id][riObjects][1], 0, 0);
                        RadarInfo[id][riObjects][2] = CreateDynamicObject(334, 1323.276733, 1567.186157, 10.797300, 87.093429, 135.795898, 139.167785, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 16322, "a51_stores", "steel64", 0x00000000);
                        gadd(RadarInfo[id][riObjects][2], 0, 0);
                        RadarInfo[id][riObjects][3] = CreateDynamicObject(19144, 1322.947265, 1567.048095, 10.963741, 9.437971, 6.928065, 36.718753, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 1, 2127, "cj_kitchen", "CJ_RED", 0x00000000);
                        gadd(RadarInfo[id][riObjects][3], 0, 0);
                        RadarInfo[id][riObjects][4] = CreateDynamicObject(19894, 1323.218872, 1567.038696, 11.155601, -74.583496, -31.465616, 40.257831, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        gadd(RadarInfo[id][riObjects][4], 0, 0);
                        RadarInfo[id][riObjects][5] = CreateDynamicObject(19894, 1323.498291, 1566.951293, 11.087444, -74.583496, -31.465616, 40.257831, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        gadd(RadarInfo[id][riObjects][5], 0, 0);
                        RadarInfo[id][riObjects][6] = CreateDynamicObject(19894, 1323.365966, 1567.008666, 11.230935, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        gadd(RadarInfo[id][riObjects][6], 0, 0);
                        RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1323.395385, 1567.159667, 11.149615, -74.583480, -121.465476, 40.257938, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 16322, "a51_stores", "steel64", 0x00000000);
                        gadd(RadarInfo[id][riObjects][7], 0, 0);
                        RadarInfo[id][riObjects][8] = CreateDynamicObject(19894, 1323.347290, 1566.950195, 11.220918, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        gadd(RadarInfo[id][riObjects][8], 0, 0);
                        RadarInfo[id][riObjects][9] = CreateDynamicObject(19967, 1323.331420, 1567.049560, 11.033987, -24.954961, 177.702224, 3.956743, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 1, 16322, "a51_stores", "steel64", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][9], 0, 0);
                        RadarInfo[id][riObjects][10] = CreateDynamicObject(19967, 1323.331420, 1567.049560, 11.033987, -29.815286, -180.821670, 124.572387, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 1, 16322, "a51_stores", "steel64", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][10], 0, 0);
                        RadarInfo[id][riObjects][11] = CreateDynamicObject(19967, 1323.331420, 1567.049560, 11.033987, -26.174581, -176.883407, -113.641273, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 1, 16322, "a51_stores", "steel64", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][11], 0, 0);
                        RadarInfo[id][riObjects][12] = CreateDynamicObject(19143, 1323.411254, 1567.073364, 11.304652, 26.426906, 14.667220, -23.978219, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 1, 19623, "camera1", "cscamera02", 0x00000000);
                        gadd(RadarInfo[id][riObjects][12], 0, 0);

                        RadarInfo[id][riObjects][16] = CreateDynamicObject(18688, 1323.299926, 1566.762329, 9.580307, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                        RadarInfo[id][riObjects][17] = CreateDynamicObject(18686, 1323.269531, 1566.983886, 9.640308, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); // Boom Effect
                        
                        TSInfo[tsOffset][2] = -0.537282;
                    }
                    default: {
                        RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1323.322875, 1563.060546, 10.979763, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        gadd(RadarInfo[id][riObjects][0], 0, 0);
                        RadarInfo[id][riObjects][1] = CreateDynamicObject(19893, 1323.234497, 1562.807128, 10.942198, 7.976202, 13.235788, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 16322, "a51_stores", "steel64", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
                        gadd(RadarInfo[id][riObjects][1], 0, 0);
                        RadarInfo[id][riObjects][2] = CreateDynamicObject(334, 1323.276733, 1563.186157, 10.797300, 87.093429, 135.795898, 139.167785, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 16322, "a51_stores", "steel64", 0x00000000);
                        gadd(RadarInfo[id][riObjects][2], 0, 0);
                        RadarInfo[id][riObjects][3] = CreateDynamicObject(19144, 1322.947265, 1563.048095, 10.963741, 9.437971, 6.928065, 36.718753, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 1, 2127, "cj_kitchen", "CJ_RED", 0x00000000);
                        gadd(RadarInfo[id][riObjects][3], 0, 0);
                        RadarInfo[id][riObjects][4] = CreateDynamicObject(19894, 1323.218872, 1563.038696, 11.155601, -74.583496, -31.465616, 40.257831, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        gadd(RadarInfo[id][riObjects][4], 0, 0);
                        RadarInfo[id][riObjects][5] = CreateDynamicObject(19894, 1323.498291, 1562.951293, 11.087444, -74.583496, -31.465616, 40.257831, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        gadd(RadarInfo[id][riObjects][5], 0, 0);
                        RadarInfo[id][riObjects][6] = CreateDynamicObject(19894, 1323.365966, 1563.008666, 11.230935, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        gadd(RadarInfo[id][riObjects][6], 0, 0);
                        RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1323.395385, 1563.159667, 11.149615, -74.583480, -121.465476, 40.257938, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        gadd(RadarInfo[id][riObjects][7], 0, 0);
                        RadarInfo[id][riObjects][8] = CreateDynamicObject(19894, 1323.347290, 1562.950195, 11.220918, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        gadd(RadarInfo[id][riObjects][8], 0, 0);
                        RadarInfo[id][riObjects][9] = CreateDynamicObject(19967, 1323.331420, 1563.049560, 11.033987, -24.954961, 177.702224, 3.956743, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 1, 16322, "a51_stores", "steel64", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][9], 0, 0);
                        RadarInfo[id][riObjects][10] = CreateDynamicObject(19967, 1323.331420, 1563.049560, 11.033987, -29.815286, -180.821670, 124.572387, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 1, 16322, "a51_stores", "steel64", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][10], 0, 0);
                        RadarInfo[id][riObjects][11] = CreateDynamicObject(19967, 1323.331420, 1563.049560, 11.033987, -26.174581, -176.883407, -113.641273, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 1, 16322, "a51_stores", "steel64", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][11], 0, 0);
                        RadarInfo[id][riObjects][12] = CreateDynamicObject(19143, 1323.411254, 1563.073364, 11.304652, 26.426906, 14.667220, -23.978219, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 1315, "dyntraffic", "Alumox64e", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 1, 19623, "camera1", "cscamera02", 0x00000000);
                        gadd(RadarInfo[id][riObjects][12], 0, 0);
                        RadarInfo[id][riObjects][13] = CreateDynamicObject(18703, 1323.305786, 1562.892333, 10.100318, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                        gadd(RadarInfo[id][riObjects][13], 0, 0);

                        TSInfo[tsOffset][2] = -0.277277;
                    }
                }
            }
        } else if (RadarInfo[id][riMaxSpeed] <= 90.0) {
            if (!brokenStatus) {
                RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1326.328002, 1571.031616, 10.960308, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                gadd(RadarInfo[id][riObjects][0], 0, 0);
                RadarInfo[id][riObjects][1] = CreateDynamicObject(19893, 1326.328002, 1570.760375, 10.960308, 0.000000, 0.000000, 360.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 14576, "mafiacasinovault01", "ab_vaultmetal", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
                gadd(RadarInfo[id][riObjects][1], 0, 0);
                RadarInfo[id][riObjects][2] = CreateDynamicObject(334, 1326.279052, 1571.169555, 10.790301, 89.999992, 0.000121, -89.999961, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 14576, "mafiacasinovault01", "ab_vaultmetal", 0x00000000);
                gadd(RadarInfo[id][riObjects][2], 0, 0);
                RadarInfo[id][riObjects][3] = CreateDynamicObject(19146, 1325.956054, 1571.043334, 11.010315, 15.300004, 0.000068, -0.000016, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 1, 3096, "bbpcpx", "blugrad32", 0x00000000);
                gadd(RadarInfo[id][riObjects][3], 0, 0);
                RadarInfo[id][riObjects][4] = CreateDynamicObject(19894, 1326.197875, 1571.001586, 11.116310, -89.999992, 179.999984, -90.000015, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                gadd(RadarInfo[id][riObjects][4], 0, 0);
                RadarInfo[id][riObjects][5] = CreateDynamicObject(19894, 1326.498168, 1571.001586, 11.116310, -89.999992, 179.999984, -90.000015, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                gadd(RadarInfo[id][riObjects][5], 0, 0);
                RadarInfo[id][riObjects][6] = CreateDynamicObject(19894, 1326.326049, 1571.031616, 11.220313, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                gadd(RadarInfo[id][riObjects][6], 0, 0);
                RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1326.328002, 1571.171752, 11.116310, 270.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                gadd(RadarInfo[id][riObjects][7], 0, 0);
                RadarInfo[id][riObjects][8] = CreateDynamicObject(19080, 1325.955444, 1571.066650, 10.820317, 0.000060, 0.000000, 89.999816, object_world, object_int, -1, 300.00, 300.00); // Laser Blue
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                gadd(RadarInfo[id][riObjects][8], INVISIBLE_VIRTUAL_WORLD, INVISIBLE_VIRTUAL_WORLD);
                RadarInfo[id][riObjects][9] = CreateDynamicObject(19894, 1326.328002, 1570.969604, 11.219310, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                gadd(RadarInfo[id][riObjects][9], 0, 0);
                RadarInfo[id][riObjects][10] = CreateDynamicObject(19967, 1326.330566, 1571.037353, 11.030100, -27.000001, 180.000000, -0.000026, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 1, 2772, "airp_prop", "CJ_GALVANISED", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                gadd(RadarInfo[id][riObjects][10], 0, 0);
                RadarInfo[id][riObjects][11] = CreateDynamicObject(19967, 1326.330566, 1571.037353, 11.030100, -26.999984, -179.999984, 119.999961, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 1, 2772, "airp_prop", "CJ_GALVANISED", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                gadd(RadarInfo[id][riObjects][11], 0, 0);
                RadarInfo[id][riObjects][12] = CreateDynamicObject(19967, 1326.330566, 1571.037353, 11.030100, -26.999996, -179.999984, -119.999984, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 1, 2772, "airp_prop", "CJ_GALVANISED", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                gadd(RadarInfo[id][riObjects][12], 0, 0);
                RadarInfo[id][riObjects][13] = CreateDynamicObject(19143, 1326.332519, 1571.117431, 11.285957, 19.000013, 0.000085, -0.000021, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][13], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][13], 1, 19623, "camera1", "cscamera02", 0x00000000);
                gadd(RadarInfo[id][riObjects][13], 0, 0);

                TSInfo[tsOffset][2] = 0.077821;
            } else {
                switch (brokenStatus) {
                    case RADAR_BROKEN_NO_FIX: {
                        RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1326.322875, 1567.060546, 10.979763, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][0], 0, 0);
                        RadarInfo[id][riObjects][1] = CreateDynamicObject(19893, 1326.234497, 1566.807128, 10.942198, 7.976202, 13.235788, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 14576, "mafiacasinovault01", "ab_vaultmetal", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
                        gadd(RadarInfo[id][riObjects][1], 0, 0);
                        RadarInfo[id][riObjects][2] = CreateDynamicObject(334, 1326.276733, 1567.186157, 10.797300, 87.093429, 135.795898, 139.167785, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 14576, "mafiacasinovault01", "ab_vaultmetal", 0x00000000);
                        gadd(RadarInfo[id][riObjects][2], 0, 0);
                        RadarInfo[id][riObjects][3] = CreateDynamicObject(19146, 1325.947265, 1567.048095, 10.963741, 9.437971, 6.928065, 36.718753, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 1, 3096, "bbpcpx", "blugrad32", 0x00000000);
                        gadd(RadarInfo[id][riObjects][3], 0, 0);
                        RadarInfo[id][riObjects][4] = CreateDynamicObject(19894, 1326.218872, 1567.038696, 11.155601, -74.583496, -31.465616, 40.257831, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][4], 0, 0);
                        RadarInfo[id][riObjects][5] = CreateDynamicObject(19894, 1326.498291, 1566.951293, 11.087444, -74.583496, -31.465616, 40.257831, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][5], 0, 0);
                        RadarInfo[id][riObjects][6] = CreateDynamicObject(19894, 1326.365966, 1567.008666, 11.230935, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][6], 0, 0);
                        RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1326.395385, 1567.159667, 11.149615, -74.583480, -121.465476, 40.257938, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][7], 0, 0);
                        RadarInfo[id][riObjects][8] = CreateDynamicObject(19894, 1326.347290, 1566.950195, 11.220918, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][8], 0, 0);
                        RadarInfo[id][riObjects][9] = CreateDynamicObject(19967, 1326.331420, 1567.049560, 11.033987, -24.954961, 177.702224, 3.956743, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 1, 2772, "airp_prop", "CJ_GALVANISED", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][9], 0, 0);
                        RadarInfo[id][riObjects][10] = CreateDynamicObject(19967, 1326.331420, 1567.049560, 11.033987, -29.815286, -180.821670, 124.572387, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 1, 2772, "airp_prop", "CJ_GALVANISED", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][10], 0, 0);
                        RadarInfo[id][riObjects][11] = CreateDynamicObject(19967, 1326.331420, 1567.049560, 11.033987, -26.174581, -176.883407, -113.641273, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 1, 2772, "airp_prop", "CJ_GALVANISED", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][11], 0, 0);
                        RadarInfo[id][riObjects][12] = CreateDynamicObject(19143, 1326.411254, 1567.073364, 11.304652, 26.426906, 14.667220, -23.978219, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 1, 19623, "camera1", "cscamera02", 0x00000000);
                        gadd(RadarInfo[id][riObjects][12], 0, 0);

                        RadarInfo[id][riObjects][16] = CreateDynamicObject(18688, 1326.299926, 1566.762329, 9.580307, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                        RadarInfo[id][riObjects][17] = CreateDynamicObject(18686, 1326.269531, 1566.983886, 9.640308, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); // Boom Effect
                    
                        TSInfo[tsOffset][2] = -0.537282;
                    }
                    default: {
                        RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1326.322875, 1563.060546, 10.979763, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][0], 0, 0);
                        RadarInfo[id][riObjects][1] = CreateDynamicObject(19893, 1326.234497, 1562.807128, 10.942198, 7.976202, 13.235788, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 14576, "mafiacasinovault01", "ab_vaultmetal", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
                        gadd(RadarInfo[id][riObjects][1], 0, 0);
                        RadarInfo[id][riObjects][2] = CreateDynamicObject(334, 1326.276733, 1563.186157, 10.797300, 87.093429, 135.795898, 139.167785, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 14576, "mafiacasinovault01", "ab_vaultmetal", 0x00000000);
                        gadd(RadarInfo[id][riObjects][2], 0, 0);
                        RadarInfo[id][riObjects][3] = CreateDynamicObject(19146, 1325.947265, 1563.048095, 10.963741, 9.437971, 6.928065, 36.718753, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 1, 3096, "bbpcpx", "blugrad32", 0x00000000);
                        gadd(RadarInfo[id][riObjects][3], 0, 0);
                        RadarInfo[id][riObjects][4] = CreateDynamicObject(19894, 1326.218872, 1563.038696, 11.155601, -74.583496, -31.465616, 40.257831, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][4], 0, 0);
                        RadarInfo[id][riObjects][5] = CreateDynamicObject(19894, 1326.498291, 1562.951293, 11.087444, -74.583496, -31.465616, 40.257831, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][5], 0, 0);
                        RadarInfo[id][riObjects][6] = CreateDynamicObject(19894, 1326.365966, 1563.008666, 11.230935, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][6], 0, 0);
                        RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1326.395385, 1563.159667, 11.149615, -74.583480, -121.465476, 40.257938, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][7], 0, 0);
                        RadarInfo[id][riObjects][8] = CreateDynamicObject(19894, 1326.347290, 1562.950195, 11.220918, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][8], 0, 0);
                        RadarInfo[id][riObjects][9] = CreateDynamicObject(19967, 1326.331420, 1563.049560, 11.033987, -24.954961, 177.702224, 3.956743, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 1, 2772, "airp_prop", "CJ_GALVANISED", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][9], 0, 0);
                        RadarInfo[id][riObjects][10] = CreateDynamicObject(19967, 1326.331420, 1563.049560, 11.033987, -29.815286, -180.821670, 124.572387, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 1, 2772, "airp_prop", "CJ_GALVANISED", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][10], 0, 0);
                        RadarInfo[id][riObjects][11] = CreateDynamicObject(19967, 1326.331420, 1563.049560, 11.033987, -26.174581, -176.883407, -113.641273, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 1, 2772, "airp_prop", "CJ_GALVANISED", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][11], 0, 0);
                        RadarInfo[id][riObjects][12] = CreateDynamicObject(19143, 1326.411254, 1563.073364, 11.304652, 26.426906, 14.667220, -23.978219, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 16640, "a51", "ws_metalpanel1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 1, 19623, "camera1", "cscamera02", 0x00000000);
                        gadd(RadarInfo[id][riObjects][12], 0, 0);
                        RadarInfo[id][riObjects][13] = CreateDynamicObject(18703, 1326.305786, 1562.892333, 10.100318, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                        gadd(RadarInfo[id][riObjects][13], 0, 0);

                        TSInfo[tsOffset][2] = -0.277277;
                    }
                }
            }
        } else {
            if (!brokenStatus) {
                RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1329.328002, 1571.031616, 10.960308, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                gadd(RadarInfo[id][riObjects][0], 0, 0);
                RadarInfo[id][riObjects][1] = CreateDynamicObject(19893, 1329.328002, 1570.760375, 10.960308, 0.000000, 0.000000, 360.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 1, 19894, "laptopsamp1", "laptopscreen3", 0x00000000);
                gadd(RadarInfo[id][riObjects][1], 0, 0);
                RadarInfo[id][riObjects][2] = CreateDynamicObject(334, 1329.279052, 1571.169555, 10.790301, 89.999992, 0.000121, -89.999961, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                gadd(RadarInfo[id][riObjects][2], 0, 0);
                RadarInfo[id][riObjects][3] = CreateDynamicObject(19145, 1328.956054, 1571.043334, 11.010315, 15.300004, 0.000068, -0.000016, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 1, 1273, "icons3", "greengrad32", 0x00000000);
                gadd(RadarInfo[id][riObjects][3], 0, 0);
                RadarInfo[id][riObjects][4] = CreateDynamicObject(19894, 1329.197875, 1571.001586, 11.116310, -89.999992, 179.999984, -90.000015, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                gadd(RadarInfo[id][riObjects][4], 0, 0);
                RadarInfo[id][riObjects][5] = CreateDynamicObject(19894, 1329.498168, 1571.001586, 11.116310, -89.999992, 179.999984, -90.000015, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                gadd(RadarInfo[id][riObjects][5], 0, 0);
                RadarInfo[id][riObjects][6] = CreateDynamicObject(19894, 1329.326049, 1571.031616, 11.220313, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                gadd(RadarInfo[id][riObjects][6], 0, 0);
                RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1329.328002, 1571.171752, 11.116310, 270.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                gadd(RadarInfo[id][riObjects][7], 0, 0);
                RadarInfo[id][riObjects][8] = CreateDynamicObject(19083, 1328.955444, 1571.066650, 10.820317, 0.000060, 0.000000, 89.999816, object_world, object_int, -1, 300.00, 300.00); // Laser Green
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                gadd(RadarInfo[id][riObjects][8], INVISIBLE_VIRTUAL_WORLD, INVISIBLE_VIRTUAL_WORLD);
                RadarInfo[id][riObjects][9] = CreateDynamicObject(19894, 1329.328002, 1570.969604, 11.219310, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                gadd(RadarInfo[id][riObjects][9], 0, 0);
                RadarInfo[id][riObjects][10] = CreateDynamicObject(19967, 1329.330566, 1571.037353, 11.030100, -27.000001, 180.000000, -0.000026, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 1, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                gadd(RadarInfo[id][riObjects][10], 0, 0);
                RadarInfo[id][riObjects][11] = CreateDynamicObject(19967, 1329.330566, 1571.037353, 11.030100, -26.999984, -179.999984, 119.999961, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 1, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                gadd(RadarInfo[id][riObjects][11], 0, 0);
                RadarInfo[id][riObjects][12] = CreateDynamicObject(19967, 1329.330566, 1571.037353, 11.030100, -26.999996, -179.999984, -119.999984, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 1, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                gadd(RadarInfo[id][riObjects][12], 0, 0);
                RadarInfo[id][riObjects][13] = CreateDynamicObject(19143, 1329.332519, 1571.117431, 11.285957, 19.000013, 0.000085, -0.000021, object_world, object_int, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][13], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                SetDynamicObjectMaterial(RadarInfo[id][riObjects][13], 1, 19623, "camera1", "cscamera02", 0x00000000);
                gadd(RadarInfo[id][riObjects][13], 0, 0);

                TSInfo[tsOffset][2] = 0.077821;
            } else {
                switch (brokenStatus) {
                    case RADAR_BROKEN_NO_FIX: {
                        RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1329.322875, 1567.060546, 10.979763, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][0], 0, 0);
                        RadarInfo[id][riObjects][1] = CreateDynamicObject(19893, 1329.234497, 1566.807128, 10.942198, 7.976202, 13.235788, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
                        gadd(RadarInfo[id][riObjects][1], 0, 0);
                        RadarInfo[id][riObjects][2] = CreateDynamicObject(334, 1329.276733, 1567.186157, 10.797300, 87.093429, 135.795898, 139.167785, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][2], 0, 0);
                        RadarInfo[id][riObjects][3] = CreateDynamicObject(19145, 1328.947265, 1567.048095, 10.963741, 9.437971, 6.928065, 36.718753, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 1, 1273, "icons3", "greengrad32", 0x00000000);
                        gadd(RadarInfo[id][riObjects][3], 0, 0);
                        RadarInfo[id][riObjects][4] = CreateDynamicObject(19894, 1329.218872, 1567.038696, 11.155601, -74.583496, -31.465616, 40.257831, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][4], 0, 0);
                        RadarInfo[id][riObjects][5] = CreateDynamicObject(19894, 1329.498291, 1566.951293, 11.087444, -74.583496, -31.465616, 40.257831, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][5], 0, 0);
                        RadarInfo[id][riObjects][6] = CreateDynamicObject(19894, 1329.365966, 1567.008666, 11.230935, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][6], 0, 0);
                        RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1329.395385, 1567.159667, 11.149615, -74.583480, -121.465476, 40.257938, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][7], 0, 0);
                        RadarInfo[id][riObjects][8] = CreateDynamicObject(19894, 1329.347290, 1566.950195, 11.220918, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][8], 0, 0);
                        RadarInfo[id][riObjects][9] = CreateDynamicObject(19967, 1329.331420, 1567.049560, 11.033987, -24.954961, 177.702224, 3.956743, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 1, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][9], 0, 0);
                        RadarInfo[id][riObjects][10] = CreateDynamicObject(19967, 1329.331420, 1567.049560, 11.033987, -29.815286, -180.821670, 124.572387, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 1, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][10], 0, 0);
                        RadarInfo[id][riObjects][11] = CreateDynamicObject(19967, 1329.331420, 1567.049560, 11.033987, -26.174581, -176.883407, -113.641273, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 1, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][11], 0, 0);
                        RadarInfo[id][riObjects][12] = CreateDynamicObject(19143, 1329.411254, 1567.073364, 11.304652, 26.426906, 14.667220, -23.978219, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 1, 19623, "camera1", "cscamera02", 0x00000000);
                        gadd(RadarInfo[id][riObjects][12], 0, 0);

                        RadarInfo[id][riObjects][16] = CreateDynamicObject(18688, 1329.299926, 1566.762329, 9.580307, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                        RadarInfo[id][riObjects][17] = CreateDynamicObject(18686, 1329.269531, 1566.983886, 9.640308, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); // Boom Effect

                        TSInfo[tsOffset][2] = -0.537282;
                    }
                    default: {
                        RadarInfo[id][riObjects][0] = CreateDynamicObject(19894, 1329.322875, 1563.060546, 10.979763, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][0], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][0], 0, 0);
                        RadarInfo[id][riObjects][1] = CreateDynamicObject(19893, 1329.234497, 1562.807128, 10.942198, 7.976202, 13.235788, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 0, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][1], 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
                        gadd(RadarInfo[id][riObjects][1], 0, 0);
                        RadarInfo[id][riObjects][2] = CreateDynamicObject(334, 1329.276733, 1563.186157, 10.797300, 87.093429, 135.795898, 139.167785, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][2], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][2], 0, 0);
                        RadarInfo[id][riObjects][3] = CreateDynamicObject(19145, 1328.947265, 1563.048095, 10.963741, 9.437971, 6.928065, 36.718753, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][3], 1, 1273, "icons3", "greengrad32", 0x00000000);
                        gadd(RadarInfo[id][riObjects][3], 0, 0);
                        RadarInfo[id][riObjects][4] = CreateDynamicObject(19894, 1329.218872, 1563.038696, 11.155601, -74.583496, -31.465616, 40.257831, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][4], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][4], 0, 0);
                        RadarInfo[id][riObjects][5] = CreateDynamicObject(19894, 1329.498291, 1562.951293, 11.087444, -74.583496, -31.465616, 40.257831, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][5], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][5], 0, 0);
                        RadarInfo[id][riObjects][6] = CreateDynamicObject(19894, 1329.365966, 1563.008666, 11.230935, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][6], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][6], 0, 0);
                        RadarInfo[id][riObjects][7] = CreateDynamicObject(19894, 1329.395385, 1563.159667, 11.149615, -74.583480, -121.465476, 40.257938, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][7], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][7], 0, 0);
                        RadarInfo[id][riObjects][8] = CreateDynamicObject(19894, 1329.347290, 1562.950195, 11.220918, 7.976202, 13.235789, -19.203355, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][8], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        gadd(RadarInfo[id][riObjects][8], 0, 0);
                        RadarInfo[id][riObjects][9] = CreateDynamicObject(19967, 1329.331420, 1563.049560, 11.033987, -24.954961, 177.702224, 3.956743, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 1, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][9], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][9], 0, 0);
                        RadarInfo[id][riObjects][10] = CreateDynamicObject(19967, 1329.331420, 1563.049560, 11.033987, -29.815286, -180.821670, 124.572387, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 1, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][10], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][10], 0, 0);
                        RadarInfo[id][riObjects][11] = CreateDynamicObject(19967, 1329.331420, 1563.049560, 11.033987, -26.174581, -176.883407, -113.641273, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 1, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][11], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                        gadd(RadarInfo[id][riObjects][11], 0, 0);
                        RadarInfo[id][riObjects][12] = CreateDynamicObject(19143, 1329.411254, 1563.073364, 11.304652, 26.426906, 14.667220, -23.978219, object_world, object_int, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 0, 3474, "freightcrane", "oldpaintyelend_256", 0x00000000);
                        SetDynamicObjectMaterial(RadarInfo[id][riObjects][12], 1, 19623, "camera1", "cscamera02", 0x00000000);
                        gadd(RadarInfo[id][riObjects][12], 0, 0);
                        RadarInfo[id][riObjects][13] = CreateDynamicObject(18703, 1329.305786, 1562.892333, 10.100318, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
                        gadd(RadarInfo[id][riObjects][13], 0, 0);

                        TSInfo[tsOffset][2] = -0.277277;
                    }
                }
            }
        }

        if (brokenStatus == RADAR_BROKEN_NO_FIX) {
            // Огонь спрятан и отображается только через секунду
            gadd(RadarInfo[id][riObjects][16], INVISIBLE_VIRTUAL_WORLD, 0);
            SetTimerEx("SetDynamicObjectVirtualWorld", 1000, false, "dd", RadarInfo[id][riObjects][16], 0);
            gadd(RadarInfo[id][riObjects][17], 0, 0);
            SetTimerEx("SetDynamicObjectVirtualWorld", 2000, false, "dd", RadarInfo[id][riObjects][17], INVISIBLE_VIRTUAL_WORLD);
        }

        Radar_SetNormalZ(id);

        TSInfo[tsOffset][0] = -0.048507;
        TSInfo[tsOffset][1] = 0.110473;
        MatrixDynamicObjectPos(0, RadarInfo[id][riX], RadarInfo[id][riY], RadarInfo[id][riZ], RadarInfo[id][riRX], RadarInfo[id][riRY], RadarInfo[id][riRZ]);

        RadarInfo[id][riBroken] = brokenStatus;

        RadarInfo[id][riLastX] = RadarInfo[id][riX];
        RadarInfo[id][riLastY] = RadarInfo[id][riY];
        RadarInfo[id][riLastZ] = RadarInfo[id][riZ];
    } else {
        RadarInfo[id][riBroken] = RADAR_BROKEN_NONE; // Помечаем радар исправным, если мы его удаляем

        // Удаляем объекты радара
        for (new i = 0; i < RADAR_MAX_OBJECTS; i++) {
            if (IsValidDynamicObject(RadarInfo[id][riObjects][i])) DestroyDynamicObject(RadarInfo[id][riObjects][i]);
        }
        DestroyDynamic3DTextLabel(RadarInfo[id][riTextLabel]);
        RadarInfo[id][riTextLabel] = Text3D: 0;
    }
    RadarInfo[id][riPlaced] = status;

    // 3D текст
    Radar_UpdateLabel(id); // Обновляем один раз
    Radar_UpdateLabelNoFix(id); // Обновляем раз в секунду (для счетчика)

    // Обновляем объекты у всех рядом с радаром
    foreach (new playerid : Player) {
        if (IsPlayerInRangeOfPoint(playerid, 50.0, RadarInfo[id][riX], RadarInfo[id][riY], RadarInfo[id][riZ]))
            Streamer_Update(playerid);
    }

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

stock Radar_DeleteAllByOwner(pid) {
    for (new i = 0; i < MAX_RADARS; i++)
        if (Radar_GetOwner(i) == pid) Radar_Delete(i);
}

// Получает количество созданных радаров (поддерживает условия)
stock Radar_GetAmount(playerid = -1, bool: placed = false, city = -1, fraction = 0) {
    new count;
    for (new i = 0; i < MAX_RADARS; i++) {
        if (
            Radar_IsExists(i) // Существует
            && (playerid == -1 || PlayerInfo[playerid][pID] == RadarInfo[i][riPID]) // Установлен конкретным игроком
            && (!placed || placed && Radar_IsPlaced(i)) // Установлен в игровом мире
            && (city == -1 || (city != _:CITY_AREA_NONE && GetCityArea(RadarInfo[i][riX], RadarInfo[i][riY]) == city) ) // Установлен в указанном городе
            && (fraction == 0 || Radar_GetFraction(i) == fraction) // Принадлежит указанной организации
        ) count++;
    }
    return count;
}

stock Radar_GetFraction(id) {
    if (!Radar_IsExists(id)) return 0;
    return RadarInfo[id][riFraction];
}

stock Radar_Dialog_List(playerid, g = -1, owner = -1) {
    if (g < 1) g = fraction(playerid);
    if (g < 1) return 0;

    new dialog_header[64];
    format(dialog_header, sizeof(dialog_header), "{ff9000}Радары %s", frakName[g]);

    new dialog_text[4096] = "{cccccc}Создатель\t{cccccc}Район\t{cccccc}Ограничение\t{cccccc}Статус\n";

    strcat(dialog_text, "{cccccc}Создать радар");
    for (new quan = 0, id = 0; id < MAX_RADARS; id++) {
        if (!Radar_IsExists(id)) continue;
        if (Radar_GetFraction(id) != g) continue;
        if (owner > -1 && Radar_GetOwner(id) != owner) continue;

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
        "{8066ff}Собрать юниты [%d]\n" \
        "%s\n" \
        "{ff6347}Удалить",

        RadarInfo[radarid][riMaxSpeed],
        FormatNumberWithCommas(RadarInfo[radarid][riFine]),
        Radar_CalculateUnits(radarid),
        Radar_IsPlaced(radarid) ? "{555555}Свернуть" : "{0088FF}Развернуть"
    );

    DP[0][playerid] = radarid;

    SetPVarInt(playerid, "RadarSingleDialog", single_dialog);

    PlayerPlaySound(playerid, 17006, 0.0, 0.0, 0.0);
    return ShowDialog(playerid, _:RADAR_DIALOG_MANAGEMENT, DIALOG_STYLE_LIST, dialog_header, dialog_text, "Выбрать", single_dialog ? "Закрыть" : "Назад");
}

stock Radar_Dialog_Stats(playerid, radarid) {
    if (!Radar_IsExists(radarid)) return 0;

    new dialog_text[1024];
    format(dialog_text, sizeof(dialog_text), \
        "{0088FF}Статистика радара №%d\n\n" \
        "{cccccc}Количество выписанных штрафов: {ff6347}%d чел.\n" \
        "{cccccc}Общая сумма штрафов: {ff6347}$%s\n\n" \
        "{cccccc}Количество юнитов: {8066ff}%d {cccccc}[Вы получите: {8066ff}%d{cccccc}]\n" \
        "{cccccc}- Сумма юнитов зависит от количества функционирующих радаров сотрудника",
        
        radarid + 1,
        RadarInfo[radarid][riTicketsIssued],
        FormatNumberWithCommas(RadarInfo[radarid][riFineTotal]),
        Radar_CalculateUnits(radarid), Radar_CalculateUnits(radarid, playerid)
    );

    ShowDialog(playerid, _:RADAR_DIALOG_STATS, DIALOG_STYLE_MSGBOX, "{ff9000}Статистика радара", dialog_text, "Закрыть", "");

    return 1;
}

stock Radar_Dialog_Set_MaxSpeed(playerid, radarid) {
    if (!Radar_IsExists(radarid)) return 0;

    new available_speed_limits[] = {60, 90, 120};

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

    new available_fines[] = {750, 1000, 1500, 2000};

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
stock Radar_IsAnyNearPlayer(playerid, bool: placed = true) {
    for (new i = 0; i < MAX_RADARS; i++) {
        if (!Radar_IsExists(i) || (placed && !Radar_IsPlaced(i)) ) continue;

        if (GetPlayerDistanceFromPoint(playerid, RadarInfo[i][riX], RadarInfo[i][riY], RadarInfo[i][riZ]) < RADAR_INTERVAL)
            return 1;
    }

    return 0;
}

// Проверяет есть ли с указанным радаром любой другой рядом
stock Radar_IsAnyNear(radarid, bool: placed = true) {
    for (new i = 0; i < MAX_RADARS; i++) {
        if (!Radar_IsExists(i) || (placed && !Radar_IsPlaced(i)) ) continue;
        if (radarid == i) continue;

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
    for (new e_PlayerRadarInfo: i; i < e_PlayerRadarInfo; i++) PlayerRadarInfo[playerid][i] = 0;

    return 1;
}

stock Radar_OnPlayerConnect(playerid) {
    for (new i = 0; i < MAX_RADARS; i++) {
        if (Radar_IsExists(i) && Radar_IsOwner(playerid, i)) {
            format(RadarInfo[i][riOwnerName], 24, "%s", PlayerInfo[playerid][pName]);
        }
    }

    Radar_Detect_TextDrawInit(playerid);
    return 1;
}

stock Radar_Detect_TextDrawInit(playerid) {
    radarDetector_TD[playerid][0] = CreatePlayerTextDraw(playerid, 590.0000, 126.0000, "LD_SPAC:white"); // Черный бокс позади (для обводки)
    PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][0], 42.5000, 46.0000);
    PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][0], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, radarDetector_TD[playerid][0], 0x000000FF);
    PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][0], 255);
    PlayerTextDrawFont(playerid, radarDetector_TD[playerid][0], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][0], false);
    PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid, radarDetector_TD[playerid][0], 1);

    radarDetector_TD[playerid][1] = CreatePlayerTextDraw(playerid, 591.0000, 127.0000, "LD_SPAC:white"); // Основной бокс
    PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][1], 40.5000, 43.0000);
    PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][1], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, radarDetector_TD[playerid][1], 0xEAEAEAFF);
    PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][1], 255);
    PlayerTextDrawFont(playerid, radarDetector_TD[playerid][1], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][1], false);
    PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, radarDetector_TD[playerid][1], 1);

    radarDetector_TD[playerid][2] = CreatePlayerTextDraw(playerid, 591.0000, 161.0000, "LD_SPAC:white"); // Нижняя полоса
    PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][2], 40.0000, 10.0000);
    PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][2], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, radarDetector_TD[playerid][2], 0x000000FF);
    PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][2], 0x000000FF);
    PlayerTextDrawFont(playerid, radarDetector_TD[playerid][2], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][2], false);
    PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][2], 0);

    radarDetector_TD[playerid][3] = CreatePlayerTextDraw(playerid, 591.0000, 127.0000, "LD_SPAC:white"); // Верхняя полоса
    PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][3], 40.0000, 10.0000);
    PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][3], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, radarDetector_TD[playerid][3], 0x000000FF);
    PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][3], 0x000000FF);
    PlayerTextDrawFont(playerid, radarDetector_TD[playerid][3], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][3], false);
    PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][3], 0);

    // Размер прямоугольника желтого: 2, отступ между: 3
    new Float: yellowBoxSize = 1.5, Float: yellowBoxIndent = 1.5;
    new Float: yellowBoxesAmount = 40.0 / (yellowBoxSize + yellowBoxIndent);

    // Полосы на нижней
    new lastid = 3;
    for (new i = 0; i < yellowBoxesAmount; i++) {
        new id = lastid + 1;

        radarDetector_TD[playerid][id] = CreatePlayerTextDraw(playerid, 591.0000 + (yellowBoxIndent * i) + (yellowBoxSize * i), 161.0000, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][id], yellowBoxSize, 10.0000);
        PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][id], TEXT_DRAW_ALIGN: 1);
        PlayerTextDrawColour(playerid, radarDetector_TD[playerid][id], 0xFFFF00FF);
        PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][id], 255);
        PlayerTextDrawFont(playerid, radarDetector_TD[playerid][id], TEXT_DRAW_FONT: 4);
        PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][id], false);
        PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][id], 0);

        lastid = id;
    }

    // Полосы на верхней
    for (new i = 0; i < yellowBoxesAmount; i++) {
        new id = lastid + 1;

        radarDetector_TD[playerid][id] = CreatePlayerTextDraw(playerid, 591.0000 + (yellowBoxIndent * i) + (yellowBoxSize * i), 127.0000, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][id], yellowBoxSize, 10.0000);
        PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][id], TEXT_DRAW_ALIGN: 1);
        PlayerTextDrawColour(playerid, radarDetector_TD[playerid][id], 0xFFFF00FF);
        PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][id], 255);
        PlayerTextDrawFont(playerid, radarDetector_TD[playerid][id], TEXT_DRAW_FONT: 4);
        PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][id], false);
        PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][id], 0);
        
        lastid = id;
    }

    new id = lastid + 1;

    radarDetector_TD[playerid][id] = CreatePlayerTextDraw(playerid, 604.0000, 142.9703, "LD_SPAC:white"); // Камера
    PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][id], 7.0000, 13.0000);
    PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][id], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, radarDetector_TD[playerid][id], 255);
    PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][id], 255);
    PlayerTextDrawFont(playerid, radarDetector_TD[playerid][id], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][id], false);
    PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][id], 0);

    radarDetector_TD[playerid][id + 1] = CreatePlayerTextDraw(playerid, 607.4667, 144.6296, "LD_SPAC:white"); // Камера
    PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][id + 1], 2.0000, 3.0000);
    PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][id + 1], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, radarDetector_TD[playerid][id + 1], -1);
    PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][id + 1], 255);
    PlayerTextDrawFont(playerid, radarDetector_TD[playerid][id + 1], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][id + 1], false);
    PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][id + 1], 0);

    radarDetector_TD[playerid][id + 2] = CreatePlayerTextDraw(playerid, 605.8001, 150.4370, "LD_SPAC:white"); // Камера
    PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][id + 2], 2.0000, 4.0000);
    PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][id + 2], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, radarDetector_TD[playerid][id + 2], -1);
    PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][id + 2], 255);
    PlayerTextDrawFont(playerid, radarDetector_TD[playerid][id + 2], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][id + 2], false);
    PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][id + 2], 0);

    radarDetector_TD[playerid][id + 3] = CreatePlayerTextDraw(playerid, 611.4667, 145.0444, "LD_SPAC:white"); // Камера
    PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][id + 3], 2.0000, 9.0000);
    PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][id + 3], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, radarDetector_TD[playerid][id + 3], 255);
    PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][id + 3], 255);
    PlayerTextDrawFont(playerid, radarDetector_TD[playerid][id + 3], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][id + 3], false);
    PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][id + 3], 0);

    radarDetector_TD[playerid][id + 4] = CreatePlayerTextDraw(playerid, 613.7999, 146.2889, "LD_SPAC:white"); // Камера
    PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][id + 4], 2.0000, 7.0000);
    PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][id + 4], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, radarDetector_TD[playerid][id + 4], 255);
    PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][id + 4], 255);
    PlayerTextDrawFont(playerid, radarDetector_TD[playerid][id + 4], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][id + 4], false);
    PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][id + 4], 0);

    radarDetector_TD[playerid][id + 5] = CreatePlayerTextDraw(playerid, 616.1334, 146.2888, "LD_SPAC:white"); // Камера
    PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][id + 5], 5.0000, 7.0000);
    PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][id + 5], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, radarDetector_TD[playerid][id + 5], 255);
    PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][id + 5], 255);
    PlayerTextDrawFont(playerid, radarDetector_TD[playerid][id + 5], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][id + 5], false);
    PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][id + 5], 0);

    radarDetector_TD[playerid][39] = CreatePlayerTextDraw(playerid, 612.0001, 170.9185, "RADAR"); // RADAR
    PlayerTextDrawLetterSize(playerid, radarDetector_TD[playerid][39], 0.2913, 1.4921);
    PlayerTextDrawTextSize(playerid, radarDetector_TD[playerid][39], 0.0000, -66.0000);
    PlayerTextDrawAlignment(playerid, radarDetector_TD[playerid][39], TEXT_DRAW_ALIGN: 2);
    PlayerTextDrawColour(playerid, radarDetector_TD[playerid][39], -1);
    PlayerTextDrawSetOutline(playerid, radarDetector_TD[playerid][39], 1);
    PlayerTextDrawBackgroundColour(playerid, radarDetector_TD[playerid][39], 255);
    PlayerTextDrawFont(playerid, radarDetector_TD[playerid][39], TEXT_DRAW_FONT: 2);
    PlayerTextDrawSetProportional(playerid, radarDetector_TD[playerid][39], true);
    PlayerTextDrawSetShadow(playerid, radarDetector_TD[playerid][39], 0);

    return 1;
}

stock Radar_Detect_TextDrawShow(playerid, color = -1) {
    if (!PlayerRadarInfo[playerid][priDetectTextdraw]) {
        for (new i = 0; i < sizeof(radarDetector_TD[]); i++) {
            if (radarDetector_TD[playerid][i] == PlayerText: 0) break;
            PlayerTextDrawShow(playerid, radarDetector_TD[playerid][i]);
        }
    }

    PlayerTextDrawColour(playerid, radarDetector_TD[playerid][39], color);
    PlayerTextDrawShow(playerid, radarDetector_TD[playerid][39]);

    PlayerRadarInfo[playerid][priDetectTextdraw] = true;

    return 1;
}

stock Radar_Detect_TextDrawHide(playerid) {
    if (!PlayerRadarInfo[playerid][priDetectTextdraw]) return 0;
    for (new i = 0; i < sizeof(radarDetector_TD[]); i++) {
        PlayerTextDrawHide(playerid, radarDetector_TD[playerid][i]);
    }

    PlayerRadarInfo[playerid][priDetectTextdraw] = false;
    PlayerRadarInfo[playerid][priLastDetectRadar] = -1;
    
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
                new maxRadars = Radar_GetMaxRadarsForPlayer(playerid);
                if(Radar_GetAmount(playerid) >= maxRadars) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу создать больше %d %s", maxRadars, PluralToText(maxRadars, "радара", "радаров", "радаров"));
                if(Radar_GetAmount(.city = GetPlayerCityArea(playerid, true)) >= RADAR_PER_CITY) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: В одном городе не может быть установлено более "#RADAR_PER_CITY" радаров");
                if(Radar_IsAnyNearPlayer(playerid, .placed = false)) return ErrorMessage(playerid, "{ff6347}Вы не можете установить радар близко с другим [ Минимальный радиус: "#RADAR_INTERVAL" метров ]\n\n* Свёрнутые радары тоже учитываются");

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
                    CreateGps(playerid, RadarInfo[radarid][riX], RadarInfo[radarid][riY], RadarInfo[radarid][riZ], 0, 0, 5.0);
                    return SendClientMessage(playerid, COLOR_LIGHTBLUE, "{0088ff}[ {ffffff}Карта {0088ff}]{ffffff}: {0088ff}Местоположение радара №%d {ffffff}отмечено на карте %s", radarid + 1, (!Radar_IsPlaced(radarid) ? "{cccccc}[ Не установлен ]" : "") );
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
                    if (GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0 || PlayerInfo[playerid][pBkyrenie] >= 2)
                    {
                        ErrorText(playerid, "{ff6347}Не могу изменять расположение радара, находясь здесь");
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
                    if (Radar_CalculateUnits(radarid) > 0) {
                        if (!GetAccessRankOrg(playerid, fraction(playerid), 77, NO_FBI)) return 1;
                       
                        Radar_CollectUnits(radarid);
                        PlayerPlaySound(playerid, 6401);
                    }
                    return Radar_Dialog_Management(playerid, radarid);
                }
                case 6: {
                    if (!Radar_IsPlaced(radarid) && Radar_IsAnyNear(radarid, .placed = false)) return ErrorMessage(playerid, "{ff6347}Рядом уже установлен другой радар [ Минимальный радиус: "#RADAR_INTERVAL" метров ]\n\n* Свёрнутые радары тоже учитываются");
                    if (Radar_IsPlaced(radarid) && Radar_IsBroken(radarid)) return ErrorMessage(playerid, "{ff6347}Этот радар сейчас сломан, его нельзя свернуть в таком состоянии");

                    return Radar_Dialog_Place(playerid, radarid);
                }
                case 7: {
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
                if (Radar_IsPlaced(radarid)) {
                    Radar_Place(radarid);
                }
            }

            Radar_Dialog_Management(playerid, radarid);
        }
        case RADAR_DIALOG_SET_FINE: {
            new radarid = DP[0][playerid];
            if (response) {
                RadarInfo[radarid][riFine] = List[listitem][playerid];
                if (Radar_IsPlaced(radarid)) Radar_UpdateLabel(radarid);
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
            SaveRadars(radarid);
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

            if (RadarInfo[radarid][riBroken] == RADAR_BROKEN_FIX) {
                Radar_StartPump(playerid, radarid);
            } else {
                ErrorMessage(playerid, "{ff6347}Сейчас починить этот радар невозможно");
            }
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
    
    new string[64]; format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~PAѓAP: ~w~0/%d", DP[3][playerid]);
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
        || !is_repair && Radar_IsAnyNearPlayer(playerid, .placed = false) // Радар ставят, но рядом уже стоит
        || (is_repair && !Radar_IsBroken(radarid)) // Радар чинят, но он уже починен
        || !is_repair && Radar_GetAmount(.city = GetPlayerCityArea(playerid, true)) >= RADAR_PER_CITY) // Количество радаров в одном городе стало превышать допустимое
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
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~PAѓAP: ~w~%d/%d", MAX_TIMES, MAX_TIMES);
        GameTextForPlayer(playerid, string, 1500, 3);
        PlayerPlaySound(playerid, 32000, 0, 0, 0);
        
        ClearAnim(playerid);

        if (is_repair) {
            Radar_SetBroken(radarid, RADAR_BROKEN_NONE);
            SuccessMessage(playerid, "{99ff66}Вы успешно починили радар");
        } else {
            Radar_Create(playerid, RADAR_RADIUS, 60, 1000);
            SuccessMessage(playerid, "{99ff66}Вы успешно установили радар\nУстановлены настройки по умолчанию, вы можете изменить их в настройках [ ALT ]");
        }
        DeletePVar(playerid, "RadarRepair");
        ApplyAnimation(playerid, "OTB", "betslp_loop", 4.0, false, true, true, false, false, SYNC_ALL);
    } else {
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~PAѓAP: ~w~%d/%d", current_progress, MAX_TIMES);
        GameTextForPlayer(playerid, string, 1500, 3);
        ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, false, true, true, true, true);
        if (current_progress <= 5) PlayerPlaySound(playerid, 32401, 0.0, 0.0, 0.0);
        else if (current_progress % 3 == 0) PlayerPlaySound(playerid,  32000, 0.0, 0.0, 0.0);
    }

    return 1;
}

stock Radar_OnShoot(playerid, weaponid, objectid) {
    new const currentTime = gettime();
    if (PlayerInfo[playerid][pSoska] < 22) {
        if (IsDepartmentOrganization(fraction(playerid))) return 0; // Пропускаем обработку выстрела для сотрудников департамента
        if (IsPlayerBeginner(playerid)) return 0; // Пропускаем обработку выстрела для новичков
    }
    if (server >= 0 && PlayerInfo[playerid][pSoska] > 0 && PlayerInfo[playerid][pSoska] < 20) return 0; // Младшие администраторы не могут разрушать радары на основном сервере

    for (new i = 0; i < MAX_RADARS; i++) {
        if (!Radar_IsExists(i) || !Radar_IsPlaced(i) || Radar_IsBroken(i)) continue;
        for (new objid = 0; objid < RADAR_MAX_OBJECTS; objid++) {
            new currentobjectid = RadarInfo[i][riObjects][objid];
            if (currentobjectid == objectid) {
                if (weaponid >= 22 && weaponid <= 38) {
                    new bool: cooldown = true;
                    if (currentTime - RadarInfo[i][riBrokenTime] < RADAR_BROKE_COOLDOWN * 60) { // КД у радара
                        if (PlayerRadarInfo[playerid][priLastRadar] != i) ErrorMessage(playerid, "{ff6347}Этот радар был разрушен совсем недавно, сейчас это сделать нельзя");
                    } else if (currentTime - PlayerRadarInfo[playerid][priBrokenRadarTime] < RADAR_BROKE_PLAYER_COOLDOWN * 60) { // КД у игрока
                        if (PlayerRadarInfo[playerid][priLastRadar] != i) ErrorMessage(playerid, "{ff6347}Вы совсем недавно разрушали радар, сейчас это сделать нельзя");
                    } else cooldown = false;

                    if (cooldown) {
                        PlayerRadarInfo[playerid][priLastRadar] = i;
                        return 0;
                    }

                    PlayerRadarInfo[playerid][priLastRadar] = i;
                    RadarInfo[i][riHits]++;

                    new string[64];
			        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~PAѓAP: ~w~%d/%d", RadarInfo[i][riHits], RADAR_BROKE_HITS_AMOUNT);
                    GameTextForPlayer(playerid, string, 2000, 3);

                    if (RadarInfo[i][riHits] >= RADAR_BROKE_HITS_AMOUNT) {
                        // Выдаём розыск за порчу гос. имущества
                        new findUk, findP;
                        if (FindCriminalArticle("Порча гос", findUk, findP)) {
                            SetPlayerCriminal(playerid, -1, CriminalCodeInfo[findUk][findP][ccName], CriminalCodeInfo[findUk][findP][ccLevel], findUk, findP);
                        }

                        // Оповещаем полицейских о разрушении радара
                        new findraiontolist = FindRaionPos(RadarInfo[i][riX], RadarInfo[i][riY], RadarInfo[i][riZ]);
                        foreach (new currentid : Player) {
                            if (!IsPoliceMember(currentid) || !IsOnline(currentid)) continue;

                            SendClientMessage(currentid, COLOR_LIGHTNEUTRALBLUE, \
                                "[PD]: Сломан скоростной радар №%d, %s[%d] в районе %s",
                                
                                i + 1,
                                rpplayername(playerid), playerid,
                                gSAZones[findraiontolist][zName]
                            );
                        }

                        RadarInfo[i][riHits] = 0;
                        RadarInfo[i][riBrokeReason] = RADAR_BROKE_REASON_PLAYER;
                        Radar_SetBroken(i, RADAR_BROKEN_NO_FIX);
                        PlayerRadarInfo[playerid][priBrokenRadarTime] = currentTime;
                    }
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

                    ShowDialog(playerid, _:RADAR_DIALOG_REPAIR, DIALOG_STYLE_MSGBOX, "{ff9000}Восстановление радара", dialog_text, "Да", "Закрыть");
                }
                return 1; // Нельзя взаимодействовать со сломанным радаром
            }

            if (RadarInfo[radarid][riFraction] == g) {
                ApplyAnimation(playerid, "OTB", "betslp_loop", 4.0, false, true, true, false, false, SYNC_ALL);
                return Radar_Dialog_Management(playerid, radarid, .single_dialog = true);
            }
            else if (IsPoliceMember(playerid)) return ErrorMessage(playerid, "{ff6347}Этот радар не принадлежит вашей организации");
            else {
                if (GetPVarInt(playerid, "idkradarmessage") > 0) return 1;
                SetPVarInt(playerid, "idkradarmessage", 3);
                SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не знаю, как этим пользоваться..");
            }
            return 1;
        }
    }

    return 0;
}

stock Radar_ViolationHandler(playerid) {
    {
        new idkradarmessage = GetPVarInt(playerid, "idkradarmessage");
        if (idkradarmessage > 0) {
            SetPVarInt(playerid, "idkradarmessage", --idkradarmessage);
            if (idkradarmessage == 0) DeletePVar(playerid, "idkradarmessage");
        }
    }
    
    if (GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return 0;
    if(OnlineInfo[playerid][oLogged] == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && !IsPlayerAfk(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(!(vehicleid >= swatcar[0] && vehicleid <= swatcar[1] || vehicleid >= armcar[0] && vehicleid <= armcar[1]
		|| vehicleid >= LSPDcar[0] && vehicleid <= LSPDcar[1] || vehicleid >= fbicar[0] && vehicleid <= fbicar[1]
		|| vehicleid == janswat[0] || vehicleid == janswat[1] || vehicleid == janswat[2] || vehicleid == janswat[3] || Cars[vehicleid] == 4 || Cars[vehicleid] == 3
		|| vehicleid >= SFPDcar[0] && vehicleid <= SFPDcar[1] || vehicleid >= NonLSCar[0] && vehicleid <= NonLSCar[1] || vehicleid >= NonSFCar[0] && vehicleid <= NonSFCar[1]
		|| Cars[vehicleid] == 1 || Cars[vehicleid] == 11 || Cars[vehicleid] == 2 || Cars[vehicleid] == 7 || Cars[vehicleid] == 28
	 	|| Cars[vehicleid] == 21 || Cars[vehicleid] == 22 || vehicleid >= govcar[0] && vehicleid <= govcar[1]
		|| vehicleid >= Medcar[0] && vehicleid <= Medcar[1]))
		{
	    	if(	IsACar(VehInfo[vehicleid][vModel]) || IsAMoto(VehInfo[vehicleid][vModel]) )
	    	{
                // Подсвечивание радара на мини-карте
                {
                    new radarid = -1,
                        Float: highlight_radius = 0.0;

                    if (PlayerInfo[playerid][pDonateRank] >= 4) { // Platinum VIP
                        highlight_radius = 200.0;
                    } else if (get_invent2(playerid, 232, 0)) { // Детектор радаров 2 ур.
                        highlight_radius = 120.0;
                    } 

                    if (highlight_radius > 0) {
                        radarid = Radar_GetNearest(playerid, highlight_radius);
                        if (radarid > -1 && !IsValidDynamicMapIcon(PlayerRadarInfo[playerid][priClosestRadarMapIcon])) {
                            PlayerRadarInfo[playerid][priClosestRadarMapIcon] = CreateDynamicMapIcon(
                                RadarInfo[radarid][riX], RadarInfo[radarid][riY], RadarInfo[radarid][riZ],
                                .type = 56,
                                .color = 0xF7EA25FF,
                                .worldid = 0, .interiorid = 0,
                                .playerid = playerid,
                                .streamdistance = highlight_radius
                            );
                        }
                    }
                    if (radarid == -1 || highlight_radius == 0.0) {
                        if (IsValidDynamicMapIcon(PlayerRadarInfo[playerid][priClosestRadarMapIcon])) {
                            DestroyDynamicMapIcon(PlayerRadarInfo[playerid][priClosestRadarMapIcon]);
                        }
                    }
                }

                // Поиск номера модели Peugeot 406
                static peugeot_modelid = -1;
                if (peugeot_modelid == -1) {
                    for (new i = 0; i < sizeof(vehNameCustom); i++) {
                        if (!strcmp(vehNameCustom[i], "Peugeot 406")) {
                            peugeot_modelid = i + 2000;
                            break;
                        }
                    } 
                }

                new currentTime = gettime();
                new bool: detectRadarTextDrawHide = true;
				for(new radarid = 0; radarid < MAX_RADARS; radarid++) // Ищем радары по близости
				{
                    if (!Radar_IsExists(radarid) || !Radar_IsPlaced(radarid)) continue; // Пропуск неустановленных радаров
                    if (VehInfo[vehicleid][vModel] == peugeot_modelid && RadarInfo[radarid][riMaxSpeed] <= 90.0) continue; // Игнорирование радара <= 90м для Peugeot 406

                    // Пропускаем, если радар неисправен
                    if (Radar_IsBroken(radarid)) continue;

                    // Пропускаем, если КД еще не прошло
                    if (PlayerRadarInfo[playerid][priCooldown] > 0 && PlayerRadarInfo[playerid][priLastRadar] == radarid) continue;

                    // Пропускаем, если игрок - администратор или новичок (только для основного сервера)
                    if (server > 0 && (PlayerInfo[playerid][pSoska] >= 1 || IsPlayerBeginner(playerid))) continue;

                    // Вывод уведомления о ближайшем радаре для владельцев детектора
                    {
                        new bool: isDetectedRadar = PlayerRadarInfo[playerid][priLastDetectRadar] == radarid;
                        if (!PlayerRadarInfo[playerid][priDetectTextdraw] || isDetectedRadar) {
                            new bool: simple_detector = get_invent2(playerid, 231, 0) > 0,
                                bool: enhanced_detector = get_invent2(playerid, 232, 0) > 0;
                            if (simple_detector || enhanced_detector) {
                                new Float: max_radius = enhanced_detector ? 200.0 : 130.0;

                                if (IsPlayerInRangeOfPoint(playerid, max_radius, RadarInfo[radarid][riX], RadarInfo[radarid][riY], RadarInfo[radarid][riZ])) {
                                    new highlight_color = 0x99FF66FF;

                                    if (enhanced_detector) {
                                        // Меняем цвет относительно скорости транспорта (только для улучшенного детектора)
                                        new Float: ratio = WatchSpeed[playerid] / RadarInfo[radarid][riMaxSpeed];
                                        if (ratio > 1.0) {
                                            if (ratio >= 1.30) {
                                                highlight_color = 0xFF6347FF;
                                            } else if (ratio >= 1.10) {
                                                highlight_color = 0xFFFF00FF;
                                            }
                                        } else if (ratio <= 0.45) {
                                            highlight_color = 0x0088FFFF;
                                        }
                                    } else highlight_color = 0xFFFFFFFF;

                                    if (!PlayerRadarInfo[playerid][priDetectTextdraw]) {
                                        PlayerRadarInfo[playerid][priDetectTime] = currentTime;
                                        PlayerRadarInfo[playerid][priLastDetectRadar] = radarid;
                                    }

                                    Radar_Detect_TextDrawShow(playerid, highlight_color);
                                    detectRadarTextDrawHide = false;
                                }
                            }
                        }
                    }

					if (IsPlayerInRangeOfPoint(playerid, RadarInfo[radarid][riRadius], RadarInfo[radarid][riX], RadarInfo[radarid][riY], RadarInfo[radarid][riZ])) {
                        // Пропускаем, если скорость не больше допустимой
                        if (WatchSpeed[playerid] <= RadarInfo[radarid][riMaxSpeed] + 1.0) continue;

                        // Пропускаем, если высота игрока сильно отличается от высоты расположения радара
                        new Float: playerPos[3], Float: radarPos[3];
                        GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);
                        GetDynamicObjectPos(RadarInfo[radarid][riObjects][0], radarPos[0], radarPos[1], radarPos[2]);
                        if (floatabs(playerPos[2] - radarPos[2]) > 2.5) continue;

                        // Глушим радар, если у игрока есть глушилка
                        if (get_invent2(playerid, 233, 0) || get_boot(vehicleid, 233) >= 0)
                        {
                            if (get_para(playerid, 233) > currentTime || get_boot_para(vehicleid, 233) > currentTime) {
                                if (currentTime >= PlayerRadarInfo[playerid][priJammedTime] + RADAR_JAMMER_COOLDOWN) { // Нет КД глушения на игроке
                                    if (currentTime > RadarInfo[radarid][riJammedTime] + RADAR_JAMMED_TIME) { // Радар не заглушен
                                        PlayerRadarInfo[playerid][priJammedTime] = currentTime;
                                        RadarInfo[radarid][riJammedTime] = currentTime;

                                        PlayerPlaySound(playerid, 41603);
                                        foreach (new currentid : Player) {
                                            if (currentid == playerid) continue;
                                            if (!Radar_IsPlayerNear(currentid, radarid)) continue;

                                            PlayerPlaySound(currentid, 6003);
                                        }
                                        
                                        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~PAѓAP 3A‚‡YЋEH", 2000, 3);
                                    }
                                }
                            } else if (Hank_IsServiceEnabled(playerid, HANK_SERVICE_STATE_PERSONAL_TECHIE)) {
                                new price = floatround(float(getThingPriceGos(233, 0) / 2) * 1.10);

                                if (PlayerInfo[playerid][pAccount] >= price) {
                                    RadarInfo[radarid][riJammedTime] = currentTime;
                                    oGivePlayerBank(playerid, -price);
                                    MoneyLog("hank_glushilka",
                                        PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP],
                                        0, "", "", -price, "Прошивка глушилки у Хэнка");
                                    SendClientMessage(playerid, COLOR_YELLOW, " SMS от Хэнка: {99ff33}Решил вопрос с прошивкой твоей глушилки, можешь пользоваться!");

                                    new quan, para;
                                    ThingParameters(playerid, 233, quan, para);
                                    set_para(playerid, 233, para);
                                    set_boot_para(vehicleid, 233, para);
                                }
                            }
                        }

                        // Пропускаем, если радар заглушен
                        if (currentTime <= RadarInfo[radarid][riJammedTime] + RADAR_JAMMED_TIME) continue;

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
                            if (GetPlayerVirtualWorld(currentid) != 0 || GetPlayerInterior(currentid) != 0) continue;

                            Streamer_Update(currentid);
                            PlayerPlaySound(currentid, 1132, 0.0, 0.0, 0.0);
                        }

                        PlayerPlaySound(playerid, 45400, 0.0, 0.0, 0.0);

						break;
					}
				}
                if (detectRadarTextDrawHide) Radar_Detect_TextDrawHide(playerid);
			}
		}
	} else {
        if (IsValidDynamicMapIcon(PlayerRadarInfo[playerid][priClosestRadarMapIcon])) {
            DestroyDynamicMapIcon(PlayerRadarInfo[playerid][priClosestRadarMapIcon]);
        }
        Radar_Detect_TextDrawHide(playerid);
    }

	return 1;
}

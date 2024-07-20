/*
    CREATE TABLE `obstacles` (
        `id` int(11) NOT NULL,
        `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ID аккаунта создателя',
        `passtime` int(11) NOT NULL COMMENT 'Время прохождения',
        `last_passtime` int(11) NOT NULL COMMENT 'Время прохождения перед последним запуском',
        `points` blob NOT NULL COMMENT 'Точки маршрута',
        `stats` blob NOT NULL COMMENT 'Статистика последнего забега'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    ALTER TABLE `obstacles`
        ADD UNIQUE KEY `id` (`id`);
*/
function Obstacle_Load() {
    new rows;
    cache_get_row_count(rows);

    for (new i = 0; i < min(rows, MAX_OBSTACLE_ROUTES); i++) {
        new id;
        cache_get_value_name_int(i, "id", id);
        cache_get_value_name(i, "name", ObstacleInfo[i][obName]);
        cache_get_value_int(i, "passtime", ObstacleInfo[i][obPassTime]);
        cache_get_value_int(i, "last_passtime", ObstacleInfo[i][obLastPassTime]);

        new points_json[125 * 85];
        cache_get_value_name(i, "points", points_json);
        new JsonNode: data = JSON_INVALID_NODE;
        if (!isnull(points_json) && JSON_Parse(points_json, data) == JSON_CALL_NO_ERR) {
            LoadJson_ObstaclePoints(i, data);
        }

        new stats_json[60 * MAX_OBSTACLE_PLAYERS];
        cache_get_value_name(i, "stats", stats_json);
        if (!isnull(stats_json) && JSON_Parse(stats_json, data) == JSON_CALL_NO_ERR) {
            LoadJson_ObstacleStats(i, data);
        }
    }

    return 1;
}

stock Obstacle_Save(id = -1) {
    for (new i = id; i < (id == -1 ? MAX_OBSTACLE_ROUTES : id + 1); i++) {
        if (Obstacle_IsExists(i)) {
            new JsonNode: pointNode = JSON_Array();
            CreateJson_ObstaclePoints(i, pointNode);

            new JsonNode: statsNode = JSON_Array();
            CreateJson_ObstacleStats(i, statsNode);

            new points_json[125 * 85];
            if (JSON_Stringify(pointNode, points_json) == JSON_CALL_NO_ERR) {
                new stats_json[60 * MAX_OBSTACLE_PLAYERS];
                if (JSON_Stringify(statsNode, stats_json) == JSON_CALL_NO_ERR) {
                    new query[256 + sizeof(points_json) + sizeof(stats_json)];
                    mysql_format(pearsq, query, sizeof(query),
                        "REPLACE INTO `obstacles` \
                        (`id`, `name`, `passtime`, `last_passtime`, `points`, `stats`) \
                        VALUES (%d, '%s', %d, %d, '%s', '%e')",

                        i,
                        ObstacleInfo[i][obName],
                        ObstacleInfo[i][obPassTime],
                        ObstacleInfo[i][obLastPassTime],
                        points_json, stats_json
                    );
                    query_empty(pearsq, query);
                }
            }
        } else {
            new query[256];
            mysql_format(pearsq, query, sizeof(query), "DELETE FROM `obstacles` WHERE id = %d", i);
            query_empty(pearsq, query);
        }
    }
    return 1;
}

// new JsonNode: node = JSON_Array();
stock CreateJson_ObstacleStats(id, &JsonNode: node) {
    new JsonNode: players = JSON_Array();
    for (new i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
        if (ObstacleStatsInfo[id][i][obsPID] == 0) continue;

        new JsonNode: playerNode = JSON_Object(
            "teamid", JSON_Int(ObstacleStatsInfo[id][i][obsTeam]),
            "pid", JSON_Int(ObstacleStatsInfo[id][i][obsPID]),
            "name", JSON_String(ObstacleStatsInfo[id][i][obsName]),
            "passtime", JSON_Int(ObstacleStatsInfo[id][i][obsPassTime])
        );
        JSON_ArrayAppendEx(node, playerNode);
    }

    return 1;
}

stock LoadJson_ObstacleStats(id, &JsonNode: node) {
    if (node == JSON_INVALID_NODE) return 0;

    new index = -1, JsonNode: curPlayer = JSON_INVALID_NODE;
    while (!JSON_ArrayIterate(node, index, curPlayer)) {
        if (index >= MAX_OBSTACLE_PLAYERS) break;

        new teamid, pid, passtime, name[MAX_PLAYER_NAME + 1];
        JSON_GetInt(curPlayer, "teamid", teamid);
        JSON_GetInt(curPlayer, "pid", pid);
        JSON_GetString(curPlayer, "name", name);
        JSON_GetInt(curPlayer, "passtime", passtime);

        for (new i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
            if (ObstacleStatsInfo[id][i][obsPID] == pid || ObstacleStatsInfo[id][i][obsPID] <= 0) {
                ObstacleStatsInfo[id][i][obsPID] = pid;
                ObstacleStatsInfo[id][i][obsTeam] = teamid;
                ObstacleStatsInfo[id][i][obsPassTime] = passtime;
                ObstacleStatsInfo[id][i][obsName][0] = EOS; strcat(ObstacleStatsInfo[id][i][obsName], name);
                break;
            }
        }
        
    }
    return 1;
}

stock CreateJson_ObstaclePoints(id, &JsonNode: node) {
    for (new teamid = 0; teamid < OBSTACLE_TEAMS_AMOUNT; teamid++) {
        new JsonNode: points = JSON_Array();
        for (new i = 0; i < MAX_OBSTACLE_POINTS; i++) {
            if (!Obstacle_IsPointExists(id, teamid, i)) break;

            new JsonNode: pointNode = JSON_Object(
                "x", JSON_Float(ObstaclePointsInfo[id][teamid][i][obpX]),
                "y", JSON_Float(ObstaclePointsInfo[id][teamid][i][obpY]),
                "z", JSON_Float(ObstaclePointsInfo[id][teamid][i][obpZ])
            );
            JSON_ArrayAppendEx(points, pointNode);
        }

        new JsonNode: row = JSON_Object(
            "teamid", JSON_Int(teamid),
            "points", points
        );
        JSON_ArrayAppendEx(node, row);
    }
    return 1;
}

stock LoadJson_ObstaclePoints(id, JsonNode: node) {
    if (node == JSON_INVALID_NODE) return 0;

    new index = -1, JsonNode: curTeam = JSON_INVALID_NODE;
    while (!JSON_ArrayIterate(node, index, curTeam)) {
        if (index >= OBSTACLE_TEAMS_AMOUNT) break;

        new teamid;
        JSON_GetInt(curTeam, "teamid", teamid);

        new JsonNode: pointNode;
        JSON_GetObject(curTeam, "points", pointNode);

        new pointid = -1, JsonNode: curPoint;
        while (!JSON_ArrayIterate(pointNode, pointid, curPoint)) {
            JSON_GetFloat(curPoint, "x", ObstaclePointsInfo[id][teamid][pointid][obpX]);
            JSON_GetFloat(curPoint, "y", ObstaclePointsInfo[id][teamid][pointid][obpY]);
            JSON_GetFloat(curPoint, "z", ObstaclePointsInfo[id][teamid][pointid][obpZ]);
        }
    }

    return 1;
}

stock Obstacle_PlayerInfo_Cleanup(playerid) {
    Obstacle_HideCheckpoint(playerid);

    for (new e_ObstaclePlayerInfo: i; i < e_ObstaclePlayerInfo; i++) ObstaclePlayerInfo[playerid][i] = 0;
    Obstacle_Create_UpdateMapIcons(playerid, 0);
    
    for (new teamid = 0; teamid < OBSTACLE_TEAMS_AMOUNT; teamid++)
        for (new pointid = 0; pointid < MAX_OBSTACLE_POINTS; pointid++)
            for (new e_ObstacleInfoPoint: i; i < e_ObstacleInfoPoint; i++)
                ObstaclePlayerPointsInfo[playerid][teamid][pointid][i] = 0;

    return 1;
}

stock Obstacle_SetMarker(playerid, id) {
    if (!Obstacle_IsExists(id)) return ErrorMessage(playerid, "{ff6347}Маршрут не существует");
    if (Obstacle_IsMember(playerid) && Obstacle_IsStarted(ObstaclePlayerInfo[playerid][obpRouteID])) return ErrorMessage(playerid, "{ff6347}Вы проходите один из маршрутов");

    return CreateGps(
        playerid,
        ObstaclePointsInfo[id][0][0][obpX], ObstaclePointsInfo[id][0][0][obpY], ObstaclePointsInfo[id][0][0][obpZ],
        GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), 5.0
    );
}

stock Obstacle_Dialog_Stats(playerid, id) {
    if (!Obstacle_IsExists(id)) return ErrorMessage(playerid, "{ff6347}Маршрут не существует");

    new dialog_text[4096];
    new team_exists[OBSTACLE_TEAMS_AMOUNT];

    // Временные массивы для последующей сортировки
    new team_players[OBSTACLE_TEAMS_AMOUNT][MAX_OBSTACLE_PLAYERS];
    new team_player_count[OBSTACLE_TEAMS_AMOUNT];

    // Определение игроков по командам
    for (new i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
        if (ObstacleStatsInfo[id][i][obsPID] > 0) {
            new team = ObstacleStatsInfo[id][i][obsTeam];
            if (team >= 0 && team < OBSTACLE_TEAMS_AMOUNT) {
                team_exists[team] = true;
                team_players[team][team_player_count[team]++] = i;
            }
        }
    }

    // Сортировка игроков каждой из команд по obsPassTime
    for (new team = 0; team < OBSTACLE_TEAMS_AMOUNT; team++) {
        if (team_exists[team]) {
            for (new i = 0; i < team_player_count[team] - 1; i++) {
                for (new j = 0; j < team_player_count[team] - i - 1; j++) {
                    new time1 = ObstacleStatsInfo[id][team_players[team][j]][obsPassTime];
                    new time2 = ObstacleStatsInfo[id][team_players[team][j + 1]][obsPassTime];
                    if (time1 <= 0) time1 = 999999;
                    if (time2 <= 0) time2 = 999999;

                    if (time1 > time2) {
                        new temp = team_players[team][j];
                        team_players[team][j] = team_players[team][j + 1];
                        team_players[team][j + 1] = temp;
                    }
                }
            }
        }
    }

    // Построение диалога
    for (new team = 0; team < OBSTACLE_TEAMS_AMOUNT; team++) {
        if (team_exists[team]) {
            format(dialog_text, sizeof(dialog_text), "%s{ffff00}%d команда:\n", dialog_text, team + 1);
            for (new i = 0; i < team_player_count[team]; i++) {
                new player_index = team_players[team][i];

                if (ObstacleStatsInfo[id][player_index][obsPassTime] > 0) {
                    format(dialog_text, sizeof(dialog_text),
                        "%s{99ff66}%s {cccccc}- [%s]\n",

                        dialog_text,
                        ObstacleStatsInfo[id][player_index][obsName],
                        fine_time(ObstacleStatsInfo[id][player_index][obsPassTime])
                    );
                } else {
                    format(dialog_text, sizeof(dialog_text),
                        "%s{ff6347}%s\n",

                        dialog_text,
                        ObstacleStatsInfo[id][player_index][obsName]
                    );
                }
            }
            strcat(dialog_text, "\n");
        }
    }

    if (isnull(dialog_text)) return ErrorMessage(playerid, "{ff6347}Данные для статистики отсутствуют");

    return ShowDialog(playerid, OBSTACLE_DIALOG_STATS, DIALOG_STYLE_MSGBOX, "{ff9000}Статистика маршрута", dialog_text, "Назад", "");
}

stock Obstacle_Dialog_List(playerid) {
    if(!IsAFunctionOrganization(76, fraction(playerid), playerid)) return ErrorMessage(playerid, "{FF6347}Вам недоступна эта функция");
    if (ObstaclePlayerInfo[playerid][obpCreate]) return Obstacle_Dialog_Create(playerid, -1);

    if (!Obstacle_IsMember(playerid) && !Obstacle_IsStarted(ObstaclePlayerInfo[playerid][obpRouteID])) {
        Obstacle_PlayerInfo_Cleanup(playerid);
    }

    new dialog_text[2048] = "{ff9000}Название\t{ffffff}Время прохождения\t{ffffff}Тип\n";
    strcat(dialog_text, "{cccccc}Создать маршрут\t\t\n");

    for (new quan = 1, i = 0; i < MAX_OBSTACLE_ROUTES; i++) {
        if (!Obstacle_IsExists(i)) continue;

        format(dialog_text, sizeof(dialog_text),
            "%s{ff9000}%s\t{ffffff}%s\t{%s}%s\n",
            
            dialog_text,
            ObstacleInfo[i][obName],
            fine_time(ObstacleInfo[i][obPassTime]),
            (ObstacleInfo[i][obType] == OBSTACLE_TYPE_SOLO ? "ffff00" : "99ff66"),
            Obstacle_GetTypeName(ObstacleInfo[i][obType])
        );

        List[quan++][playerid] = i;
    }

    return ShowDialog(playerid, OBSTACLE_DIALOG_MENU, DIALOG_STYLE_TABLIST_HEADERS, "{ff9000}Тренировочные маршруты", dialog_text, "Выбор", "Закрыть");
}

stock Obstacle_GetFreeSlot() {
    for (new i = 0; i < MAX_OBSTACLE_ROUTES; i++) {
        if (!Obstacle_IsExists(i)) return i;
    }

    return -1;
}

stock Obstacle_IsStarted(id) {
    if (!Obstacle_IsExists(id)) return 0;
    return ObstacleInfo[id][obStarted];
}

stock Obstacle_Dialog_Create(playerid, id = -1) {
    if (!GetAccessRankOrg(playerid, fraction(playerid), 76, NO_FBI)) return 0;

    new bool: is_create = !Obstacle_IsExists(id);

    if (is_create) {
        ObstaclePlayerInfo[playerid][obpCreate] = true;
        Obstacle_DeleteMember(playerid);

        if (Obstacle_IsMember(playerid) && Obstacle_IsStarted(ObstaclePlayerInfo[playerid][obpRouteID])) return ErrorMessage(playerid, "{FF6347}Нельзя начать создавать маршрут, если вы проходите один из них");
    }
    SetPVarInt(playerid, "ObstacleCreate", is_create);

    if (ObstaclePlayerInfo[playerid][obpEditPoints]) return Obstacle_Dialog_SetPoints(playerid, id);

    DP[0][playerid] = id;

    new dialog_text[1024];
    if (is_create) {
        format(dialog_text, sizeof(dialog_text),
            "{cccccc}Название:\t{cccccc}%s\n" \
            "{cccccc}Тип маршрута:\t{cccccc}%s\n" \
            "{cccccc}Время прохождения:\t{cccccc}%s\n" \
            "{ff9000}Настройка точек\t{ff9000}>>\n" \
            "{99ff66}Сохранить и выйти\n" \
            "{ff6347}Отменить и выйти",

            ObstaclePlayerInfo[playerid][obpName],
            Obstacle_GetTypeName(ObstaclePlayerInfo[playerid][obpType]),
            fine_time(ObstaclePlayerInfo[playerid][obpPassTime])
        );
    } else {
        format(dialog_text, sizeof(dialog_text),
            "{cccccc}Название:\t{cccccc}%s\n" \
            "{cccccc}Тип маршрута:\t{cccccc}%s\n" \
            "{cccccc}Время прохождения:\t{cccccc}%s\n" \
            "{cccccc}Отметить на карте\t\n" \
            "{555555}Статистика\t\n" \
            "%s\t\n" \
            "{ff6347}Удалить\t\n",

            ObstacleInfo[id][obName],
            Obstacle_GetTypeName(ObstacleInfo[id][obType]),
            fine_time(ObstacleInfo[id][obPassTime]),
            (!Obstacle_IsStarted(id) ? "{99ff66}Запустить маршрут" : "{ff6347}Завершить маршрут")
        );
    }

    new dialog_header[128];
    if (is_create) strcat(dialog_header, "{ff9000}Создание нового маршрута");
    else strcat(dialog_header, "{ff9000}Редактирование маршрута");

    return ShowDialog(playerid, OBSTACLE_DIALOG_CREATE, DIALOG_STYLE_TABLIST, dialog_header, dialog_text, "Выбор", "Назад");
}

stock Obstacle_Dialog_SetName(playerid, id) {
    new bool: is_create = GetPVarInt(playerid, "ObstacleCreate") > 0;
    if (!is_create && id < 0 || id >= MAX_OBSTACLE_ROUTES) return 0;
    
    DP[0][playerid] = id;

    new dialog_header[] = "{ff9000}Изменение названия маршрута";
    new dialog_text[] = "{ffffff}Введите новое название для выбранного маршрута:";

    return ShowDialog(playerid, OBSTACLE_DIALOG_SETNAME, DIALOG_STYLE_INPUT, dialog_header, dialog_text, "Ок", "Назад");
}

stock Obstacle_Dialog_SetType(playerid, id) {
    new bool: is_create = GetPVarInt(playerid, "ObstacleCreate") > 0;
    if (!is_create && id < 0 || id >= MAX_OBSTACLE_ROUTES) return 0;
    
    DP[0][playerid] = id;

    new dialog_header[] = "{ff9000}Изменение типа маршрута";

    new dialog_text[128];
    for (new i = 0; i < OBSTACLE_TYPES_AMOUNT; i++) {
        format(dialog_text, sizeof(dialog_text),
            "%s{cccccc}%s\n",
            dialog_text, Obstacle_GetTypeName(i)
        );
    }

    return ShowDialog(playerid, OBSTACLE_DIALOG_SETTYPE, DIALOG_STYLE_LIST, dialog_header, dialog_text, "Ок", "Назад");
}

stock Obstacle_Dialog_SetPassTime(playerid, id) {
    new bool: is_create = GetPVarInt(playerid, "ObstacleCreate") > 0;
    if (!is_create && id < 0 || id >= MAX_OBSTACLE_ROUTES) return 0;

    DP[0][playerid] = id;

    new dialog_header[] = "{ff9000}Изменение времени прохождения маршрута";
    new dialog_text[] = "{ffffff}Введите новое время прохождения для выбранного маршрута (в секундах):";

    return ShowDialog(playerid, OBSTACLE_DIALOG_SETPASSTIME, DIALOG_STYLE_INPUT, dialog_header, dialog_text, "Ок", "Назад");
}

stock Obstacle_GetTypeName(type) {
    new result[12];
    switch (_:type) {
        case OBSTACLE_TYPE_SOLO: strcat(result, "Одиночный");
        case OBSTACLE_TYPE_TEAM: strcat(result, "Командный");
        default: strcat(result, "Неизвестный");
    }
    return result;
}

stock Obstacle_Dialog_SetPoints(playerid, id) {
    new bool: is_create = GetPVarInt(playerid, "ObstacleCreate") > 0;
    if (!is_create && id < 0 || id >= MAX_OBSTACLE_ROUTES) return 0;

    DP[0][playerid] = id;

    new dialog_header[] = "{ff9000}Настройка точек маршрута";
    new dialog_text[256];

    new teamid = ObstaclePlayerInfo[playerid][obpTeam];
    if (!ObstaclePlayerInfo[playerid][obpEditPoints]) {
        format(dialog_text, sizeof(dialog_text),
            "{99ff66}Вы действительно хотите начать запись маршрута?"
        );

        return ShowDialog(playerid, OBSTACLE_DIALOG_SETPOINTS, DIALOG_STYLE_MSGBOX, dialog_header, dialog_text, "Да", "Назад");
    } else {
        format(dialog_text, sizeof(dialog_text),
            "{cccccc}Номер команды:\t%d\n" \
            "{ff9000}Добавить точку [Y]\t{99ff66}(%d/%d)\n" \
            "{555555}Удалить последнюю точку [N]\t\n" \
            "{99ff66}Сохранить и выйти",

            teamid + 1,
            Obstacle_Create_GetPointsCount(playerid, teamid), MAX_OBSTACLE_POINTS
        );

        return ShowDialog(playerid, OBSTACLE_DIALOG_SETPOINTS, DIALOG_STYLE_TABLIST, dialog_header, dialog_text, "Выбор", "Закрыть");
    }
}

stock Obstacle_Dialog_SetPoints_Accept(playerid, id) {
    DP[0][playerid] = id;

    for (new teamid = 0; teamid < (ObstaclePlayerInfo[playerid][obpType] == OBSTACLE_TYPE_TEAM ? OBSTACLE_TEAMS_AMOUNT ? 1); teamid++) {
        if (Obstacle_Create_GetPointsCount(playerid, teamid) == 0) return ErrorMessage(playerid, "{FF6347}Вы не добавили ни одной точки для маршрута одной из команд");
    }
    
    return ShowDialog(playerid, OBSTACLE_DIALOG_SETPOINTS_ACCEPT, DIALOG_STYLE_MSGBOX, "{ffffff}Вы действительно хотите сохранить точки маршрута?", "Да", "Назад");
}

stock Obstacle_Create_AddPoint(playerid, teamid, Float: x, Float: y, Float: z) {
    new count = Obstacle_Create_GetPointsCount(playerid, teamid);
    if (count >= MAX_OBSTACLE_POINTS) return ErrorMessage(playerid, "{ff6347}Достигнуто максимальное число точек на команду");
    
    ObstaclePlayerPointsInfo[playerid][teamid][count][obpX] = x;
    ObstaclePlayerPointsInfo[playerid][teamid][count][obpY] = y;
    ObstaclePlayerPointsInfo[playerid][teamid][count][obpZ] = z;

    return 1;
}

stock Obstacle_Create_DeletePoint(playerid, teamid, pointid) {
    new points[MAX_OBSTACLE_POINTS][e_ObstacleInfoPoint];
    for (new quan, i = 0; i < MAX_OBSTACLE_POINTS; i++) {
        if (!Obstacle_Create_IsPointExists(playerid, teamid, i)) continue;
        if (i == pointid) continue;

        points[quan][obpX] = ObstaclePlayerPointsInfo[playerid][teamid][i][obpX];
        points[quan][obpY] = ObstaclePlayerPointsInfo[playerid][teamid][i][obpY];
        points[quan][obpZ] = ObstaclePlayerPointsInfo[playerid][teamid][i][obpZ];

        ObstaclePlayerPointsInfo[playerid][teamid][i][obpX] = 0.0;
        ObstaclePlayerPointsInfo[playerid][teamid][i][obpY] = 0.0;
        ObstaclePlayerPointsInfo[playerid][teamid][i][obpZ] = 0.0;
        quan++;
    }

    for (new i = 0; i < sizeof(points); i++) {
        ObstaclePlayerPointsInfo[playerid][teamid][i][obpX] = points[i][obpX];
        ObstaclePlayerPointsInfo[playerid][teamid][i][obpY] = points[i][obpY];
        ObstaclePlayerPointsInfo[playerid][teamid][i][obpZ] = points[i][obpZ];
    }

    return 1;
}

stock Obstacle_Create_UpdateMapIcons(playerid, teamid, notify = false) {
    for (new i = 0; i < MAX_OBSTACLE_POINTS; i++) {
        new iconid = ObstaclePlayerInfo[playerid][obpMapIcons][i];
        if (IsValidDynamicMapIcon(iconid)) DestroyDynamicMapIcon(iconid);

        ObstaclePlayerInfo[playerid][obpMapIcons][i] = 0;
        if (ObstaclePlayerInfo[playerid][obpEditPoints]) {
            if (Obstacle_Create_IsPointExists(playerid, teamid, i)) {
                ObstaclePlayerInfo[playerid][obpMapIcons][i] = CreateDynamicMapIcon(
                    ObstaclePlayerPointsInfo[playerid][teamid][i][obpX],
                    ObstaclePlayerPointsInfo[playerid][teamid][i][obpY],
                    ObstaclePlayerPointsInfo[playerid][teamid][i][obpZ],
                    .type = 0,
                    .color = 0xFFFF00FF,
                    .worldid = GetPlayerVirtualWorld(playerid),
                    .interiorid = GetPlayerInterior(playerid),
                    .playerid = playerid
                );
            }
        }
    }
    Streamer_Update(playerid, STREAMER_TYPE_MAP_ICON);

    if (notify) {
        new text[32];
        format(text, sizeof(text), "%d/%d", Obstacle_Create_GetPointsCount(playerid, teamid), MAX_OBSTACLE_POINTS);
        GameTextForPlayer(playerid, text, 1000, 3);
    }
    
    return 1;
}

stock Obstacle_IsPointExists(id, teamid, pointid) {
    if (!Obstacle_IsExists(id)) return 0;
    if (teamid == -1) {
        for (new i = 0; i < OBSTACLE_TEAMS_AMOUNT; i++) {
            if (ObstaclePointsInfo[id][i][pointid][obpX] != 0.0 || ObstaclePointsInfo[id][i][pointid][obpY] != 0.0 || ObstaclePointsInfo[id][i][pointid][obpZ] != 0.0) {
                return true;
            }
        }
        return false;
    }
    return ObstaclePointsInfo[id][teamid][pointid][obpX] != 0.0 || ObstaclePointsInfo[id][teamid][pointid][obpY] != 0.0 || ObstaclePointsInfo[id][teamid][pointid][obpZ] != 0.0;
}

stock Obstacle_Create_IsPointExists(playerid, teamid, id) {
    if (id < 0 || id >= MAX_OBSTACLE_POINTS) return 0;
    if (teamid == -1) {
        for (new i = 0; i < OBSTACLE_TEAMS_AMOUNT; i++) {
            if (ObstaclePlayerPointsInfo[playerid][i][id][obpX] != 0.0 || ObstaclePlayerPointsInfo[playerid][i][id][obpY] != 0.0 || ObstaclePlayerPointsInfo[playerid][i][id][obpZ] != 0.0) {
                return true;
            }
        }
        return false;
    }
    return ObstaclePlayerPointsInfo[playerid][teamid][id][obpX] != 0.0 || ObstaclePlayerPointsInfo[playerid][teamid][id][obpY] != 0.0 || ObstaclePlayerPointsInfo[playerid][teamid][id][obpZ] != 0.0;
}

stock Obstacle_GetPointsCount(id, teamid = -1) {
    if (!Obstacle_IsExists(id)) return 0;

    new count = 0;
    for (new i = 0; i < MAX_OBSTACLE_POINTS; i++) {
        if (!Obstacle_IsPointExists(id, teamid, i)) break;
        count++;
    }
    return count;
}

stock Obstacle_Create_GetPointsCount(playerid, teamid = -1) {
    new count = 0;
    for (new i = 0; i < MAX_OBSTACLE_POINTS; i++) {
        if (!Obstacle_Create_IsPointExists(playerid, teamid, i)) break;
        count++;
    }

    return count;
}

stock Obstacle_Create(playerid) {
    new id = Obstacle_GetFreeSlot();
    if (id < 0) { ErrorMessage(playerid, "{ff6347}Было достигнуто максимальное количество маршрутов"); return -1; }
    if (Obstacle_Create_GetPointsCount(playerid) < 1) { ErrorMessage(playerid, "{ff6347}Не было добавлено ни одной точки маршрута"); return -1; }
    if (ObstaclePlayerInfo[playerid][obpPassTime] < 1) { ErrorMessage(playerid, "{ff6347}Время прохождения маршрута не установлено"); return -1; }
    if (isnull(ObstaclePlayerInfo[playerid][obpName])) { ErrorMessage(playerid, "{ff6347}Название для маршрута не установлено"); return -1; }

    ObstacleInfo[id][obName][0] = EOS; strcat(ObstacleInfo[id][obName], ObstaclePlayerInfo[playerid][obpName]);
    ObstacleInfo[id][obPassTime] = ObstaclePlayerInfo[playerid][obpPassTime];
    ObstacleInfo[id][obType] = ObstaclePlayerInfo[playerid][obpType];

    for (new teamid = 0; teamid < OBSTACLE_TEAMS_AMOUNT; teamid++) {
        for (new pointid = 0; pointid < MAX_OBSTACLE_POINTS; pointid++) {
            ObstaclePointsInfo[id][teamid][pointid][obpX] = ObstaclePlayerPointsInfo[playerid][teamid][pointid][obpX];
            ObstaclePointsInfo[id][teamid][pointid][obpY] = ObstaclePlayerPointsInfo[playerid][teamid][pointid][obpY];
            ObstaclePointsInfo[id][teamid][pointid][obpZ] = ObstaclePlayerPointsInfo[playerid][teamid][pointid][obpZ];
        }
    }

    Obstacle_Save(id);

    return id;
}

stock Obstacle_Stats_Add(playerid, id, bool: finish = true) {
    if (!Obstacle_IsExists(id)) return 0;
    if (!Obstacle_IsMember(playerid, id)) return 0;

    for (new i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
        if (ObstacleStatsInfo[id][i][obsPID] == PlayerInfo[playerid][pID] || ObstacleStatsInfo[id][i][obsPID] <= 0) { // Пустой слот или слот этого игрока
            ObstacleStatsInfo[id][i][obsPID] = PlayerInfo[playerid][pID];
            ObstacleStatsInfo[id][i][obsTeam] = ObstaclePlayerInfo[playerid][obpTeam];
            ObstacleStatsInfo[id][i][obsName][0] = EOS; strcat(ObstacleStatsInfo[id][i][obsName], PlayerInfo[playerid][pName]);
            
            if (finish) {
                ObstacleStatsInfo[id][i][obsPassTime] = gettime() - ObstacleInfo[id][obStartedTime];
            } else {
                ObstacleStatsInfo[id][i][obsPassTime] = 0;
            }
            
            return 1;
        }
    }
    
    return 0;
}

stock Obstacle_Stats_Delete(playerid, id) {
    if (!Obstacle_IsExists(id)) return 0;

    for (new i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
        if (ObstacleStatsInfo[id][i][obsPID] == PlayerInfo[playerid][pID]) {
            for (new e_ObstacleInfoStats: j; j < e_ObstacleInfoStats; j++) ObstacleStatsInfo[id][i][j] = 0;
            
            return 1;
        }
    }

    return 0;
}

stock Obstacle_Stats_Clear(id) {
    if (!Obstacle_IsExists(id)) return 0;

    for (new i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
        for (new e_ObstacleInfoStats: j; j < e_ObstacleInfoStats; j++) ObstacleStatsInfo[id][i][j] = 0;
    }

    return 1;
}

stock Obstacle_Start(id) {
    if (!Obstacle_IsExists(id)) return 0;
    if (Obstacle_GetMembersCount(id) < 1) return 0;

    Obstacle_Stats_Clear(id);
    ObstacleInfo[id][obStarted] = true;
    ObstacleInfo[id][obStartedTime] = gettime();
    ObstacleInfo[id][obLastPassTime] = ObstacleInfo[id][obPassTime];

    for (new teamid = 0; teamid < OBSTACLE_TEAMS_AMOUNT; teamid++) {
        for (new i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
            new playerid = ObstacleMembersInfo[id][teamid][i] - 1;
            if (playerid > -1) {
                // Очистка прочих данных и установка новых
                Obstacle_PlayerInfo_Cleanup(playerid);
                ObstaclePlayerInfo[playerid][obpRouteID] = id;
                ObstaclePlayerInfo[playerid][obpTeam] = teamid;

                // Отображаем первый чекпоинт
                Obstacle_ShowCheckpoint(playerid, 0);
                PlayerPlaySound(playerid, 3200);

                PlayerTextDrawSetString(playerid, ObstacleTimeTD[playerid], "00:00");
                PlayerTextDrawShow(playerid, ObstacleTimeTD[playerid]);

                // Добавляем запись об игроке в статистику
                Obstacle_Stats_Add(playerid, id, .finish = false);
            }
        }
    }

    return 1;
}

stock Obstacle_End(id) {
    if (!Obstacle_IsExists(id)) return 0;

    ObstacleInfo[id][obStarted] = false;

    foreach (new playerid : Player) {
        if (ObstaclePlayerInfo[playerid][obpRouteID] == id) {
            Obstacle_DeleteMember(playerid);
            PlayerTextDrawHide(playerid, ObstacleTimeTD[playerid]);
        }
    }

    Obstacle_Save(id);

    return 1;
}

stock Obstacle_Delete(id) {
    if (!Obstacle_IsExists(id)) return 0;

    Obstacle_End(id);

    for (new e_ObstacleInfo: i; i < e_ObstacleInfo; i++) ObstacleInfo[id][i] = 0;

    Obstacle_Save(id);

    return 1;
}

stock Obstacle_Dialog_Create_Accept(playerid, id) {
    new bool: is_create = GetPVarInt(playerid, "ObstacleCreate") > 0;
    if (!is_create && id < 0 || id >= MAX_OBSTACLE_ROUTES) return 0;
    
    DP[0][playerid] = id;

    return ShowDialog(playerid, OBSTACLE_DIALOG_CREATE_ACCEPT, DIALOG_STYLE_MSGBOX, "{ff9000}Подтверждение маршрута", "{ffffff}Вы уверены, что хотите добавить этот маршрут?", "Да", "Назад");
}

stock Obstacle_Dialog_Delete_Accept(playerid, id) {
    if (!GetAccessRankOrgMay(playerid, fraction(playerid), 76, NO_FBI)) return 0;
    if (!Obstacle_IsExists(id)) return 0;
    
    DP[0][playerid] = id;

    return ShowDialog(playerid, OBSTACLE_DIALOG_DELETE_ACCEPT, DIALOG_STYLE_MSGBOX, "{ff9000}Удаление маршрута", "{ffffff}Вы уверены, что хотите удалить этот маршрут?", "Да", "Назад");
}

stock Obstacle_Dialog_Start(playerid, id) {
    if (!Obstacle_IsExists(id)) return ErrorMessage(playerid, "{ff6347}Этот маршрут не существует");
    if (ObstaclePlayerInfo[playerid][obpCreate]) return ErrorMessage(playerid, "{ff6347}Сейчас вы не можете запустить маршрут");
    if (!GetAccessRankOrg(playerid, fraction(playerid), 76, NO_FBI)) return 0;
    
    DP[0][playerid] = id;

    new dialog_header[128];
    format(dialog_header, sizeof(dialog_header), "{ff9000}Запуск тренировочного маршрута {cccccc}[%s]", ObstacleInfo[id][obName]);

    new dialog_text[64];
    strcat(dialog_text, "{ff9000}Участники\t{ff9000}>>\n{99ff66}Начать");

    ObstaclePlayerInfo[playerid][obpTeam] = 0;
    return ShowDialog(playerid, OBSTACLE_DIALOG_START, DIALOG_STYLE_TABLIST, dialog_header, dialog_text, "Выбор", "Назад");
}

stock Obstacle_Dialog_Start_Members(playerid, id) {
    if (!Obstacle_IsExists(id)) return ErrorMessage(playerid, "{ff6347}Этот маршрут не существует");
    DP[0][playerid] = id;

    new teamid = ObstaclePlayerInfo[playerid][obpTeam];

    new dialog_header[64]; strcat(dialog_header, "{ff9000}Участники маршрута");
    
    new dialog_text[2048];
    format(dialog_text, sizeof(dialog_text),
        "{ffff00}Выбранная команда:\t{ffff00}%d\n" \
        "{99ff66}Добавить участника\t{99ff66}>>\n",

        teamid + 1
    );

    DP[1][playerid] = teamid;

    for (new quan = 2, i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
        new currentid = ObstacleMembersInfo[id][teamid][i] - 1;
        if (currentid < 0) continue;
        format(dialog_text, sizeof(dialog_text),
            "%s{ffffff}%s[%d]\n",

            dialog_text,
            PlayerInfo[currentid][pName], currentid
        );
        List[quan++][playerid] = currentid;
    }

    return ShowDialog(playerid, OBSTACLE_DIALOG_START_MEMBERS, DIALOG_STYLE_TABLIST, dialog_header, dialog_text, "Выбор", "Назад");
}

stock Obstacle_Dialog_Start_AddMember(playerid, id) {
    if (!Obstacle_IsExists(id)) return ErrorMessage(playerid, "{ff6347}Этот маршрут не существует");
    DP[0][playerid] = id;

    new dialog_header[64]; strcat(dialog_header, "{ff9000}Добавление участника");

    new dialog_text[256];
    if (PlayerInfo[playerid][pDialogID] == _:OBSTACLE_DIALOG_START_ADDMEMBER) {
        PlayerPlaySound(playerid, 4203);
        strcat(dialog_text, "{ffffff}Укажите никнейм или ID игрока для добавления в указанную команду {ff6347}[ Игрок не в сети ]");
    } else {
        strcat(dialog_text, "{ffffff}Укажите никнейм или ID игрока для добавления в указанную команду:");
    }

    return ShowDialog(playerid, OBSTACLE_DIALOG_START_ADDMEMBER, DIALOG_STYLE_INPUT, dialog_header, dialog_text, "Принять", "Назад");
}

stock Obstacle_Dialog_Start_Accept(playerid, id) {
    if (!Obstacle_IsExists(id)) return ErrorMessage(playerid, "{ff6347}Этот маршрут не существует");
    DP[0][playerid] = id;

    return ShowDialog(playerid, OBSTACLE_DIALOG_START_ACCEPT, DIALOG_STYLE_MSGBOX, "{ff9000}Подтверждение запуска маршрута", "{ffffff}Вы уверены, что хотите запустить этот маршрут?", "Да", "Назад");
}

stock Obstacle_Dialog_End_Accept(playerid, id) {
    if (!Obstacle_IsExists(id)) return ErrorMessage(playerid, "{ff6347}Этот маршрут не существует");
    if (!Obstacle_IsStarted(id)) return ErrorMessage(playerid, "{ff6347}Этот маршрут не запущен");

    DP[0][playerid] = id;

    return ShowDialog(playerid, OBSTACLE_DIALOG_END_ACCEPT, DIALOG_STYLE_MSGBOX, "{ff9000}Подтверждение завершения маршрута", "{ffffff}Вы уверены, что хотите завершить этот маршрут?", "Да", "Назад");
}

stock Obstacle_IsMember(playerid, id = -1) {
    for (new teamid = 0; teamid < OBSTACLE_TEAMS_AMOUNT; teamid++) {
        for (new i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
            if (id == -1) {
                for (new routeid = 0; routeid < MAX_OBSTACLE_ROUTES; routeid++) {
                    if (ObstacleMembersInfo[routeid][teamid][i] - 1 == playerid) {
                        return 1;
                    }
                }
            } else {
                if (ObstacleMembersInfo[id][teamid][i] - 1 == playerid) {
                    return 1;
                }
            }
        }
    }
    return 0;
}

stock Obstacle_AddMember(playerid, id, teamid) {
    if (!Obstacle_IsExists(id)) return 0;
    if (Obstacle_IsMember(playerid, id)) return 0;

    DP[0][playerid] = id;

    for (new i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
        if (ObstacleMembersInfo[id][teamid][i] <= 0) {
            ObstacleMembersInfo[id][teamid][i] = playerid + 1;
            break;
        }
    }

    ObstacleTimeTD[playerid] = CreatePlayerTextDraw(playerid, 320.0000, 410.0000, "00:00");
    PlayerTextDrawLetterSize(playerid, ObstacleTimeTD[playerid], 0.3153, 1.5253);
    PlayerTextDrawAlignment(playerid, ObstacleTimeTD[playerid], TEXT_DRAW_ALIGN: 2);
    PlayerTextDrawColour(playerid, ObstacleTimeTD[playerid], -1);
    PlayerTextDrawBackgroundColour(playerid, ObstacleTimeTD[playerid], 255);
    PlayerTextDrawFont(playerid, ObstacleTimeTD[playerid], TEXT_DRAW_FONT: 1);
    PlayerTextDrawSetProportional(playerid, ObstacleTimeTD[playerid], true);
    PlayerTextDrawSetShadow(playerid, ObstacleTimeTD[playerid], 1);

    return 1;
}

stock Obstacle_GetMembersCount(id, teamid = -1) {
    if (!Obstacle_IsExists(id)) return 0;

    new count = 0;
    for (new i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
        if (teamid == -1) {
            for (new t = 0; t < OBSTACLE_TEAMS_AMOUNT; t++) {
                if (ObstacleMembersInfo[id][t][i] <= 0) continue;
                count++;
            }
        } else {
            if (ObstacleMembersInfo[id][teamid][i] <= 0) continue;
            count++;
        }
    }

    return count;
}

stock Obstacle_DeleteMember(playerid, bool: finish = false) {
    Obstacle_Stats_Add(playerid, ObstaclePlayerInfo[playerid][obpRouteID], finish);
    
    ObstaclePlayerInfo[playerid][obpRouteID] = 0;
    ObstaclePlayerInfo[playerid][obpTeam] = 0;

    Obstacle_HideCheckpoint(playerid);
    PlayerTextDrawHide(playerid, ObstacleTimeTD[playerid]);

    for (new obstacleid = 0; obstacleid < MAX_OBSTACLE_ROUTES; obstacleid++) {
        for (new teamid = 0; teamid < OBSTACLE_TEAMS_AMOUNT; teamid++) {
            for (new i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
                if (ObstacleMembersInfo[obstacleid][teamid][i] - 1 == playerid) {
                    ObstacleMembersInfo[obstacleid][teamid][i] = 0;

                    // Завершение забега, если все участники закончили
                    if(Obstacle_GetMembersCount(obstacleid) <= 0) Obstacle_End(obstacleid);
                }
            }
        }
    }

    return 1;
}

stock Obstacle_IsExists(id) {
    if (id < 0 || id >= MAX_OBSTACLE_ROUTES) return 0;

    return ObstacleInfo[id][obPassTime] > 0;
}

stock Obstacle_ShowCheckpoint(playerid, checkpointid) {
    new obstacleid = ObstaclePlayerInfo[playerid][obpRouteID],
        teamid = ObstaclePlayerInfo[playerid][obpTeam];

    if (!Obstacle_IsExists(obstacleid)) return Obstacle_DeleteMember(playerid);
    if (!Obstacle_IsStarted(obstacleid)) return Obstacle_DeleteMember(playerid);

    new max_checkpointid = Obstacle_GetPointsCount(obstacleid, teamid) - 1;
    checkpointid = min(checkpointid, max_checkpointid);
    if (checkpointid < 0) return Obstacle_Delete(obstacleid);

    ObstaclePlayerInfo[playerid][obpCheckpoint] = checkpointid;

    Obstacle_HideCheckpoint(playerid);

    new
        Float: x = ObstaclePointsInfo[obstacleid][teamid][checkpointid][obpX],
        Float: y = ObstaclePointsInfo[obstacleid][teamid][checkpointid][obpY],
        Float: z = ObstaclePointsInfo[obstacleid][teamid][checkpointid][obpZ];
    
    ObstaclePlayerInfo[playerid][obpCheckpointModel] = CreateDynamicCP(x, y, z, .size = 0.80, .playerid = playerid);

    Streamer_Update(playerid, STREAMER_TYPE_CP);

    return 1;
}

stock Obstacle_HideCheckpoint(playerid) {
    if (ObstaclePlayerInfo[playerid][obpCheckpointModel] > 0) {
        DestroyDynamicCP(ObstaclePlayerInfo[playerid][obpCheckpointModel]);
        Streamer_Update(playerid, STREAMER_TYPE_CP);
    }
    ObstaclePlayerInfo[playerid][obpCheckpointModel] = 0;

    return 1;
}

stock Obstacle_OnPlayerUpdate(playerid) {
    new obstacleid = ObstaclePlayerInfo[playerid][obpRouteID];
    if (Obstacle_IsStarted(obstacleid) && Obstacle_IsMember(playerid, obstacleid)) {
        new checkpointid = ObstaclePlayerInfo[playerid][obpCheckpoint];
        new teamid = ObstaclePlayerInfo[playerid][obpTeam];

        new
            Float: x = ObstaclePointsInfo[obstacleid][teamid][checkpointid][obpX],
            Float: y = ObstaclePointsInfo[obstacleid][teamid][checkpointid][obpY],
            Float: z = ObstaclePointsInfo[obstacleid][teamid][checkpointid][obpZ];

        if (!IsPlayerInRangeOfPoint(playerid, 150.0, x, y, z)) {
            ErrorMessage(playerid, "{ff6347}Вы провалили выполнение маршрута [Отошли слишком далеко]");
            Obstacle_DeleteMember(playerid);
        }
    }
    return 1;
}

stock Obstacle_OnPlayerEnterCP(playerid) {
    new obstacleid = ObstaclePlayerInfo[playerid][obpRouteID],
        checkpointid = ObstaclePlayerInfo[playerid][obpCheckpoint];

    if (ObstaclePlayerInfo[playerid][obpCheckpointModel]) {
        new teamid = ObstaclePlayerInfo[playerid][obpTeam];
        new max_checkpointid = Obstacle_GetPointsCount(obstacleid, teamid) - 1;
        new next_checkpointid = checkpointid + 1;

        if (next_checkpointid > max_checkpointid) {
            Obstacle_HideCheckpoint(playerid);
            Obstacle_DeleteMember(playerid, .finish = true);
            PlayerPlaySound(playerid, 6401);
        } else {
            Obstacle_ShowCheckpoint(playerid, next_checkpointid);
            PlayerPlaySound(playerid, 17803);
        }
    }
    return 1;
}

stock Obstacle_OnPlayerDisconnect(playerid) {
    Obstacle_PlayerInfo_Cleanup(playerid);
    Obstacle_DeleteMember(playerid);
    return 1;
}

stock Obstacle_OnKeyStateChange(playerid, KEY: newkeys, KEY: oldkeys) {
    #pragma unused oldkeys
    
    if (ObstaclePlayerInfo[playerid][obpEditPoints]) {
        new teamid = ObstaclePlayerInfo[playerid][obpTeam];
        if (newkeys & KEY_YES) {
            new Float: x, Float: y, Float: z;
            GetPlayerPos(playerid, x, y, z);

            Obstacle_Create_AddPoint(playerid, teamid, x, y, z);

            PlayerPlaySound(playerid, 6401);
            Obstacle_Create_UpdateMapIcons(playerid, teamid, .notify = true);
        } else if (newkeys & KEY_NO) {
            Obstacle_Create_DeletePoint(playerid, teamid, Obstacle_Create_GetPointsCount(playerid, teamid) - 1);

            PlayerPlaySound(playerid, 30802);
            Obstacle_Create_UpdateMapIcons(playerid, teamid, .notify = true);
        }

        return 1;
    }

    return 0;
}

stock dialogCase_Obstacle(playerid, dialogid, response, listitem, const inputtext[]) {
    new obstacleid = DP[0][playerid];
    new bool: is_create = GetPVarInt(playerid, "ObstacleCreate") > 0;

    switch(dialogid) {
        case OBSTACLE_DIALOG_MENU: {
            DeletePVar(playerid, "ObstacleCreate");
            if (!response) return 1;

            if (listitem == 0) return Obstacle_Dialog_Create(playerid);
            
            return Obstacle_Dialog_Create(playerid, List[listitem][playerid]);
        }
        case OBSTACLE_DIALOG_CREATE: {
            if (!response) {
                if (!ObstaclePlayerInfo[playerid][obpCreate]) return Obstacle_Dialog_List(playerid);
                return 1;
            }

            if (listitem == 0) {
                return Obstacle_Dialog_SetName(playerid, obstacleid);
            } else if (listitem == 1) {
                if (obstacleid > -1) {
                    ErrorText(playerid, "{ff6347}Нельзя изменить тип уже созданного маршрута");
                    Obstacle_Dialog_Create(playerid, obstacleid);
                } else {
                    Obstacle_Dialog_SetType(playerid, obstacleid);
                }
            } else if (listitem == 2) {
                return Obstacle_Dialog_SetPassTime(playerid, obstacleid);
            } else if (is_create) {
                if (listitem == 3) return Obstacle_Dialog_SetPoints(playerid, obstacleid);
                if (listitem == 4 || listitem == 5) {
                    if (listitem == 4) {
                        if (Obstacle_Create(playerid) < 0) return 1;
                    }
                    ObstaclePlayerInfo[playerid][obpCreate] = false;
                    return Obstacle_Dialog_List(playerid);
                }
            } else {
                if (listitem == 3) {
                    return Obstacle_SetMarker(playerid, obstacleid);
                }
                if (listitem == 4) {
                    return Obstacle_Dialog_Stats(playerid, obstacleid);
                }
                if (listitem == 5) {
                    if (Obstacle_IsStarted(obstacleid)) return Obstacle_Dialog_End_Accept(playerid, obstacleid);
                    return Obstacle_Dialog_Start(playerid, obstacleid);
                }
                if (listitem == 6) {
                    return Obstacle_Dialog_Delete_Accept(playerid, obstacleid);
                }
            }
        }
        case OBSTACLE_DIALOG_SETNAME: {
            if (!response) return Obstacle_Dialog_Create(playerid, obstacleid);

            new const text_len = strlen(inputtext);
            if (text_len > 128) return Obstacle_Dialog_SetName(playerid, obstacleid);

            if (is_create) {
                ObstaclePlayerInfo[playerid][obpName][0] = EOS; strcat(ObstaclePlayerInfo[playerid][obpName], inputtext);
            } else {
                ObstacleInfo[obstacleid][obName][0] = EOS; strcat(ObstacleInfo[obstacleid][obName], inputtext);
                Obstacle_Save(obstacleid);
            }

            return Obstacle_Dialog_Create(playerid, obstacleid);
        }
        case OBSTACLE_DIALOG_SETTYPE: {
            if (!response) return Obstacle_Dialog_Create(playerid, obstacleid);

            if (is_create) {
                ObstaclePlayerInfo[playerid][obpType] = e_ObstacleInfoType: listitem;
            } else {
                ObstacleInfo[obstacleid][obType] = e_ObstacleInfoType: listitem;
                Obstacle_Save(obstacleid);
            }

            return Obstacle_Dialog_Create(playerid, obstacleid);
        }
        case OBSTACLE_DIALOG_SETPASSTIME: {
            if (!response) return Obstacle_Dialog_Create(playerid, obstacleid);

            new minutes;
            if (sscanf(inputtext, "d", minutes) || minutes < 0 || minutes > 3600) return Obstacle_Dialog_SetPassTime(playerid, obstacleid);

            if (is_create) {
                ObstaclePlayerInfo[playerid][obpPassTime] = minutes;
            } else {
                ObstacleInfo[obstacleid][obPassTime] = minutes;
                Obstacle_Save(obstacleid);
            }

            return Obstacle_Dialog_Create(playerid, obstacleid);
        }
        case OBSTACLE_DIALOG_SETPOINTS: {
            new teamid = ObstaclePlayerInfo[playerid][obpTeam];
            if (!response) {
                if (!ObstaclePlayerInfo[playerid][obpEditPoints]) Obstacle_Dialog_Create(playerid, obstacleid);
                Obstacle_Create_UpdateMapIcons(playerid, teamid);
                return 1;
            }

            if (ObstaclePlayerInfo[playerid][obpEditPoints]) {
                switch (listitem) {
                    case 0: {
                        if (ObstaclePlayerInfo[playerid][obpType] != OBSTACLE_TYPE_SOLO) {
                            // Переключаем команду в доступном диапазоне
                            ObstaclePlayerInfo[playerid][obpTeam] = (teamid + 1) % OBSTACLE_TEAMS_AMOUNT;
                            Obstacle_Create_UpdateMapIcons(playerid, ObstaclePlayerInfo[playerid][obpTeam]);
                        }
                    }
                    case 1: {
                        new Float: x, Float: y, Float: z;
                        GetPlayerPos(playerid, x, y, z);

                        Obstacle_Create_AddPoint(playerid, teamid, x, y, z);

                        PlayerPlaySound(playerid, 6401);
                        Obstacle_Create_UpdateMapIcons(playerid, teamid);
                    }
                    case 2: {
                        Obstacle_Create_DeletePoint(playerid, teamid, Obstacle_Create_GetPointsCount(playerid, teamid) - 1);

                        PlayerPlaySound(playerid, 30802);
                        Obstacle_Create_UpdateMapIcons(playerid, teamid);
                    }
                    case 3: {
                        if (ObstaclePlayerInfo[playerid][obpType] != OBSTACLE_TYPE_SOLO && Obstacle_Create_GetPointsCount(playerid) < 1) {
                            return ErrorMessage(playerid, "{ff6347}У одной из команд не проставлены точки маршрута");
                        }

                        ObstaclePlayerInfo[playerid][obpEditPoints] = false;
                        Obstacle_Create_UpdateMapIcons(playerid, 0);
                        return Obstacle_Dialog_Create(playerid, obstacleid);
                    }
                }
            } else {
                ObstaclePlayerInfo[playerid][obpEditPoints] = true;
                PlayerPlaySound(playerid, 6401);
            }
            return Obstacle_Dialog_SetPoints(playerid, obstacleid);
        }
        case OBSTACLE_DIALOG_CREATE_ACCEPT: {
            if (!response || !is_create) return Obstacle_Dialog_Create(playerid, obstacleid);

            if (ObstaclePlayerInfo[playerid][obpType] != OBSTACLE_TYPE_SOLO && Obstacle_Create_GetPointsCount(playerid) < 1) {
                return ErrorMessage(playerid, "{ff6347}Не были проставлены точки маршрута");
            }
            
            if(Obstacle_Create(playerid) < 0) return 1;
        }
        case OBSTACLE_DIALOG_DELETE_ACCEPT: {
            if (!response) return Obstacle_Dialog_Create(playerid, obstacleid);

            Obstacle_Delete(obstacleid);
            PlayerPlaySound(playerid, 30802);
            return Obstacle_Dialog_List(playerid);
        }
        case OBSTACLE_DIALOG_START: {
            if (!response) return Obstacle_Dialog_Create(playerid, obstacleid);

            switch (listitem) {
                case 0: return Obstacle_Dialog_Start_Members(playerid, obstacleid);
                case 1: return Obstacle_Dialog_Start_Accept(playerid, obstacleid);
            }
        }
        case OBSTACLE_DIALOG_START_ACCEPT: {
            if (!response) return Obstacle_Dialog_Start(playerid, obstacleid);

            for (new teamid = 0; teamid < OBSTACLE_TEAMS_AMOUNT; teamid++) {
                for (new i = 0; i < MAX_OBSTACLE_PLAYERS; i++) {
                    new currentid = ObstacleMembersInfo[obstacleid][teamid][i] - 1;
                    if (currentid < 0) continue;

                    new Float: x, Float: y, Float: z;
                    GetPlayerPos(currentid, x, y, z);
                    if (GetDistanceBetweenCoords3d(x, y, z, ObstaclePointsInfo[obstacleid][teamid][0][obpX], ObstaclePointsInfo[obstacleid][teamid][0][obpY], ObstaclePointsInfo[obstacleid][teamid][0][obpZ]) > 20.0) {
                        return ErrorMessage(playerid, "{ff6347}Один из участников находится далеко от начала маршрута");
                    }
                }
            }
            if (Obstacle_GetMembersCount(obstacleid) < 1) return ErrorMessage(playerid, "{ff6347}Необходимо выбрать участников маршрута");
            
            return Obstacle_Start(obstacleid);
        }
        case OBSTACLE_DIALOG_END_ACCEPT: {
            if (!response) return Obstacle_Dialog_Create(playerid, obstacleid);
            return Obstacle_End(obstacleid);
        }
        case OBSTACLE_DIALOG_START_MEMBERS: {
            if (!response) return Obstacle_Dialog_Start(playerid, obstacleid);

            if (listitem == 0) {
                if (ObstacleInfo[obstacleid][obType] != OBSTACLE_TYPE_SOLO) {
                    new teamid = ObstaclePlayerInfo[playerid][obpTeam];
                    ObstaclePlayerInfo[playerid][obpTeam] = (teamid + 1) % OBSTACLE_TEAMS_AMOUNT;
                }
            } else if (listitem == 1) {
                return Obstacle_Dialog_Start_AddMember(playerid, obstacleid);
            } else {
                Obstacle_DeleteMember(List[listitem][playerid]);
            }
            return Obstacle_Dialog_Start_Members(playerid, obstacleid);
        }
        case OBSTACLE_DIALOG_START_ADDMEMBER: {
            if (!response) return Obstacle_Dialog_Start(playerid, obstacleid);

            new id;
            if (sscanf(inputtext, "u", id) || id == INVALID_PLAYER_ID) return Obstacle_Dialog_Start_AddMember(playerid, obstacleid);
            if (Obstacle_IsMember(id)) ErrorText(playerid, "{ff6347}Этот игрок уже является участником одного из маршрутов");
            else if (!IsAFunctionOrganization(76, fraction(id), id)) ErrorText(playerid, "{ff6347}Этот игрок не может участвовать в прохождении маршрутов");
            else if (Obstacle_IsStarted(ObstaclePlayerInfo[id][obpRouteID])) ErrorText(playerid, "{ff6347}Этот игрок уже проходит один из маршрутов");
            else if (ObstaclePlayerInfo[id][obpCreate]) ErrorText(playerid, "{ff6347}Этот игрок находится в редакторе маршрутов");
            else {
                Obstacle_AddMember(id, obstacleid, .teamid = DP[1][playerid]);
            }
            
            return Obstacle_Dialog_Start_Members(playerid, obstacleid);
        }
        case OBSTACLE_DIALOG_STATS: {
            return Obstacle_Dialog_Create(playerid, obstacleid);
        }
        default: {}
    }
    
    return 1;
}

CMD:obstacle(playerid) {
    return Obstacle_Dialog_List(playerid);
}

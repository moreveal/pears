function Tomb_Load(playerid)
{
    new rows;
    cache_get_row_count(rows);
    if (rows <= 0) return 0;

    cache_get_value_name_int(0, "date", PlayerInfo[playerid][pLastTomb]);

    return 1;
}

stock Tomb_Save(playerid)
{
    new query[128];
    mysql_format(pearsq, query, sizeof(query),
        "REPLACE INTO `tomb` \
        (`user_id`, `date`) \
        VALUES (%d, %d)",

        PlayerInfo[playerid][pID],
        PlayerInfo[playerid][pLastTomb]
    );
    query_empty(pearsq, query);

    return 1;
}

CMD:rtomb(playerid, const params[])
{
    if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    
    new currentid;
    sscanf(params, "U(-1)", currentid);
    if (currentid == -1) currentid = playerid;
    if(!IsOnline(currentid)) return ErrorMessage(playerid, "{FF6347}Игрок не в сети");

    PlayerInfo[currentid][pLastTomb] = 0;
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "** Вы очистили кд на повторную игру в Гробнице Фараона для %s **", PlayerInfo[currentid][pName]);
    if(playerid != currentid) SendClientMessage(currentid, COLOR_LIGHTBLUE, "** %s очистил вам кд на повторную игру в Гробнице Фараона **", PlayerInfo[playerid][pName]);

    AdminLog("rtomb", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[currentid][pID], PlayerInfo[currentid][pName], PlayerInfo[currentid][pPlaIP], 0, "");
    return 1;
}

stock Tomb_LoadTextdraws(playerid)
{
    // Таймер
    Obstacle_CreateObstacleTimeTD(playerid);

    // Осталось NPC
    TombMummyRemainsTD[playerid][0] = CreatePlayerTextDraw(playerid, 43.0000, 191.0000, "120"); // пусто
    PlayerTextDrawLetterSize(playerid, TombMummyRemainsTD[playerid][0], 0.4000, 1.6000);
    PlayerTextDrawAlignment(playerid, TombMummyRemainsTD[playerid][0], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, TombMummyRemainsTD[playerid][0], -1);
    PlayerTextDrawBackgroundColour(playerid, TombMummyRemainsTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, TombMummyRemainsTD[playerid][0], TEXT_DRAW_FONT: 3);
    PlayerTextDrawSetProportional(playerid, TombMummyRemainsTD[playerid][0], true);
    PlayerTextDrawSetShadow(playerid, TombMummyRemainsTD[playerid][0], 0);

    TombMummyRemainsTD[playerid][1] = CreatePlayerTextDraw(playerid, 15.0000, 185.0000, "pears_element:mummy"); // пусто
    PlayerTextDrawTextSize(playerid, TombMummyRemainsTD[playerid][1], 21.0000, 26.0000);
    PlayerTextDrawAlignment(playerid, TombMummyRemainsTD[playerid][1], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, TombMummyRemainsTD[playerid][1], -1);
    PlayerTextDrawBackgroundColour(playerid, TombMummyRemainsTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, TombMummyRemainsTD[playerid][1], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, TombMummyRemainsTD[playerid][1], false);
    PlayerTextDrawSetShadow(playerid, TombMummyRemainsTD[playerid][1], 0);
    
    // Проклятие
    TombCurseTD[playerid][0] = CreatePlayerTextDraw(playerid, 264.3334, 400.1557, "LD_SPAC:white"); // бокс
    PlayerTextDrawTextSize(playerid, TombCurseTD[playerid][0], 102.0000, 11.0000);
    PlayerTextDrawAlignment(playerid, TombCurseTD[playerid][0], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, TombCurseTD[playerid][0], 572662527);
    PlayerTextDrawBackgroundColour(playerid, TombCurseTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, TombCurseTD[playerid][0], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, TombCurseTD[playerid][0], false);
    PlayerTextDrawSetShadow(playerid, TombCurseTD[playerid][0], false);

    TombCurseTD[playerid][1] = CreatePlayerTextDraw(playerid, 265.3333, 401.7149, "LD_SPAC:white"); // заполнение
    PlayerTextDrawTextSize(playerid, TombCurseTD[playerid][1], 100.0000, 8.0000);
    PlayerTextDrawAlignment(playerid, TombCurseTD[playerid][1], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, TombCurseTD[playerid][1], 0xFFDEADFF);
    PlayerTextDrawBackgroundColour(playerid, TombCurseTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, TombCurseTD[playerid][1], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, TombCurseTD[playerid][1], false);
    PlayerTextDrawSetShadow(playerid, TombCurseTD[playerid][1], false);

    return 1;
}

stock Tomb_SetMummyRemainsTextdraw(playerid, bool: show = true)
{
    for (new i = 0; i < sizeof(TombMummyRemainsTD[]); i++)
    {
        if (show) {
            PlayerTextDrawShow(playerid, TombMummyRemainsTD[playerid][i]);
        } else {
            PlayerTextDrawHide(playerid, TombMummyRemainsTD[playerid][i]);
        }
    }
    return 1;
}

stock Tomb_SetCurseTextdraw(playerid, bool: show)
{
    for (new i = 0; i < sizeof(TombCurseTD[]); i++)
    {
        if (show) {
            PlayerTextDrawShow(playerid, TombCurseTD[playerid][i]);
        } else {
            PlayerTextDrawHide(playerid, TombCurseTD[playerid][i]);
        }
    }
    
    foreach (new spectatorid : Player)
    {
        if (gSpectateID[spectatorid] == playerid) {
            for (new i = 0; i < sizeof(TombCurseTD[]); i++)
            {
                if (show) {
                    PlayerTextDrawShow(spectatorid, TombCurseTD[spectatorid][i]);
                } else {
                    PlayerTextDrawHide(spectatorid, TombCurseTD[spectatorid][i]);
                }
            }
        }
    }
    
    return 1;
}

stock Tomb_UpdateMummyRemainsTextdraw(roomid)
{
    for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        new currentid = TombInfo[roomid][tpPlayers][i] - 1;
        if (!IsOnline(currentid)) continue;

        PlayerTextDrawSetString(currentid, TombMummyRemainsTD[currentid][0], FormatNumberWithCommas(Tomb_GetCurrentWaveMummyRemains(roomid)));
    }
    return 1;
}

stock Tomb_GeneralChat(playerid, const string[])
{
    if (!Tomb_IsPlayerInside(playerid)) return 0;
    if (!TombPlayerInfo[playerid][tpDead] && (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT && GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER) ) return 0;

    foreach (new currentid : Player)
    {
        if (TombPlayerInfo[playerid][tpRoomID] != TombPlayerInfo[currentid][tpRoomID]) continue;
        if (GetPlayerVirtualWorld(currentid) != GetPlayerVirtualWorld(playerid)) continue;
        if (!Tomb_IsPlayerInside(currentid)) continue;

        SendClientMessage(currentid, 0x1E6698FF, "[ Гробница ]: {555555}%s: %s", PlayerInfo[playerid][pName], string);
    }

    return 1;
}

stock Tomb_GetElapsedTime(playerid)
{
    if (PlayerInfo[playerid][pLastTomb] <= 0) return 0;
    if (server == 0) return 0; // Для тестового сервера гробница всегда доступна

    return max(PlayerInfo[playerid][pLastTomb] + TOMB_COOLDOWN * 60 - gettime(), 0);
}

stock Tomb_CreateDynamicArea()
{
    new const worlds[MAX_REALPLAYERS + 5] = {1, 2, 3, ...};
    TombZone = CreateDynamicCubeEx(2087.208007, 1515.833618, 2765.488281, 2197.495117, 1625.671875, 2810.185546, .worlds = worlds);
    return 1;
}

stock Tomb_GetDifficultyName(e_TombDifficulty: difficulty)
{
    new string[32];

    switch(difficulty)
    {
        case TOMB_DIFFICULTY_EASY: strcat(string, "Легко");
        case TOMB_DIFFICULTY_HARD: strcat(string, "Трудно");
        default: {}
    }

    return string;
}

stock Tomb_Dialog_Main(playerid)
{
    new dialog_text[2048];
    if (!Tomb_IsPlayerInGame(playerid)) {
        if (!IsPlayerHaveLauncher(playerid)) return ErrorMessage(playerid, "{FF6347}Игра доступна только для игроков с лаунчером");
        if (Tomb_GetElapsedTime(playerid) > 0) return ErrorMessage(playerid, "{FF6347}Ближайшее время вы не сможете принимать участие в игре");

        format(dialog_text, sizeof(dialog_text), 
            "{555555}Что это за место?\t\n" \
            "{555555}Условия и правила\t\n" \
            "{ff9000}Сложность:\t{cccccc}%s\n" \
            "{ff9000}Моя команда\t{ff9000}>>\n" \
            "{99ff66}Начать",

            (Tomb_GetDifficultyName(TombPlayerInfo[playerid][tpDifficulty]))
        );
        ShowDialog(playerid, TOMB_DIALOG_MAIN, DIALOG_STYLE_TABLIST, "{ff9000}Гробница Фараона", dialog_text, "Выбор", "Закрыть");
    }

    return 1;
}

stock Tomb_Dialog_About(playerid)
{
    ShowDialog(playerid, TOMB_DIALOG_ABOUT, DIALOG_STYLE_MSGBOX, "{ff9000}Гробница Фараона",
        "{cccccc}Никто не осмеливается войти в эту древнюю гробницу, даже при свете палящего солнца.\n" \
        "Веками забытая, она была погребена под песками времени, а теперь скрыта от глаз смертных, окутанная мистикой и мрачными преданиями.\n\n" \
        \
        "Местные жители шепчутся, что сама земля вокруг гробницы пропитана древним злом, и тот, кто решится пересечь её порог, может больше никогда не выйти на поверхность.\n" \
        "Гробница считается проклятой: говорят, что фараон, чей покой был нарушен, проклял всех, кто вторгнется в его священное убежище.\n\n" \
        \
        "Тени древних стражей теперь блуждают по коридорам, оберегая покой своего господина.\n" \
        "Тот, кто осмелится бросить вызов и войти в эту гробницу, встретит лишь загадки, страх и неизбежную гибель.",

        "Назад", ""
    );

    return 1;
}

stock Tomb_Dialog_Rules(playerid)
{
    ShowDialog(playerid, TOMB_DIALOG_ABOUT, DIALOG_STYLE_MSGBOX, "{ff9000}Гробница Фараона",
        "{ff9000}Состав команды\n" \
        "{cccccc}- Вы не можете оставаться в гробнице, будучи совсем одним, сперва вам необходимо обзавестись командой\n" \
        "{cccccc}- В одной команде не может быть больше "#MAX_TOMB_PLAYERS" участников\n\n" \
        \
        "{ff9000}Сложности\n" \
        "{cccccc}- Перед запуском игры у вас есть выбор из двух сложностей: простой и сложной\n" \
        "{cccccc}- При выборе высокой сложности мумии становятся гораздо опаснее, а их количество возрастает\n" \
        "{cccccc}- Если вы сможете одолеть мумий при высоком уровне сложности, ваши призы будут сильно ценнее обычных\n\n" \
        \
        "{ff9000}Описание режима\n" \
        "{cccccc}- После запуска игры сразу же появятся мумии, которых потребуется убить вместе с товарищами по команде\n" \
        "{cccccc}- Мумии подходят волнами, численность их групп меняется в зависимости от стадии волны\n" \
        "{cccccc}- У вас есть "#TOMB_MAX_DEATHS" возможности возрождения после смерти\n" \
        "{cccccc}- Если перед вашим возрождением умрут все ваши союзники - игра завершается поражением\n\n" \
        \
        "{ff9000}Механика волн\n" \
        "{cccccc}- Каждая волна мумий увеличивается по численности, становясь всё опаснее с каждой новой атакой\n" \
        "{cccccc}- В некоторых волнах появляются усиленные типы мумий, которых сложнее уничтожить, и они наносят больший урон\n" \
        "{cccccc}- После завершения каждой волны у игроков будет время на отдых\n" \
        "{cccccc}- В перерывах между волнами игрокам случайным образом выдаются патроны и бинты для пополнения ресурсов\n\n" \
        \
        "{ff9000}Проклятие фараона\n" \
        "{cccccc}- Если вы будете долго оставаться на месте, вы будете заполнять шкалу проклятия\n" \
        "{cccccc}- Шкала проклятия также сильно увеличивается, если по вам наносит урон Анубис (босс на последней волне)\n" \
        "{cccccc}- При достижении критического уровня шкалы, ваш персонаж начинает терять некоторое количество здоровья\n" \
        "{cccccc}- При полном заполнении шкалы, ваш персонаж умирает до следующего возрождения (если оно доступно)\n\n" \
        \
        "{ff9000}Награды и штрафы\n" \
        "{cccccc}- В случае победы в конце игры каждому участнику будут выданы особые призы\n" \
        "{cccccc}- Ценность призов зависит от вашего личного вклада в победу, а также от установленного уровня сложности\n" \
        "{cccccc}- В случае поражения или победы каждый из участников не сможет некоторое время участвовать повторно\n",

        "Назад", ""
    );
    
    return 1;
}

stock Tomb_Dialog_Team(playerid)
{
    new dialog_text[4096] = "{99ff66}Добавить участника";

    for (new quan, i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        new currentid = TombPlayerInfo[playerid][tpPlayers][i] - 1;
        if (currentid < 0) continue;

        format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}%d. %s", dialog_text, quan + 1, PlayerInfo[currentid][pName]);

        List[++quan][playerid] = currentid;
    }

    ShowDialog(playerid, TOMB_DIALOG_TEAM, DIALOG_STYLE_LIST, "{ff9000}Гробница Фараона", dialog_text, "Выбор", "Назад");
    return 1;
}

stock Tomb_Create_AddMember(playerid, currentid)
{
    for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        if (!TombPlayerInfo[playerid][tpPlayers][i])
        {
            TombPlayerInfo[playerid][tpPlayers][i] = currentid + 1;
            return i;
        }
    }
    return -1;
}

stock Tomb_Create_DeleteMember(playerid, currentid)
{
    for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        if (TombPlayerInfo[playerid][tpPlayers][i] - 1 == currentid)
        {
            TombPlayerInfo[playerid][tpPlayers][i] = 0;
            break;
        }
    }
    return 1;
}

stock Tomb_CreateRoom(ownerid)
{
    for (new i = 0; i < MAX_TOMB_ROOMS; i++)
    {
        if (!Tomb_IsRoomExists(i))
        {
            Tomb_DeleteRoom(i);

            TombInfo[i][tpPlay] = true;
            TombInfo[i][tiOwner] = ownerid;
            Tomb_MummyProcess(i);

            return i;
        }
    }

    return -1;
}

stock Tomb_DeleteRoom(roomid)
{
    if (!Tomb_IsRoomExists(roomid)) return 0;

    Tomb_ClearMummy(roomid);
    for (new e_TombInfo: i; i < e_TombInfo; i++) TombInfo[roomid][i] = 0;

    return 1;
}

function Tomb_SetWave_Timer(roomid, waveid, cooldown)
{
    return Tomb_SetWave(roomid, waveid, cooldown);
}

stock Tomb_OnShoot(playerid, WEAPON: weaponid)
{
    new sl = Protect_Slot(weaponid);
    new index = sl - 3;
    if (sl == 2) index = 1;
    if (index >= 0 && index <= 3)
    {
        TombPlayerInfo[playerid][tpSpentAmmo][index]++;
    }
    return 1;
}

stock Tomb_UpdateWaveInfo(roomid)
{
    // Формируем список игроков по ID
    new players[MAX_TOMB_PLAYERS], quan;
    for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        new currentid = TombInfo[roomid][tpPlayers][i] - 1;
        if (!IsOnline(currentid)) continue;

        players[quan++] = currentid;
    }

    // Сортировка по урону
    for (new i = 0; i < quan - 1; i++)
    {
        for (new j = 0; j < quan - i - 1; j++)
        {
            if (TombPlayerInfo[players[j]][tpDamage] < TombPlayerInfo[players[j + 1]][tpDamage])
            {
                new temp = players[j];
                players[j] = players[j + 1];
                players[j + 1] = temp;
            }
        }
    }

    // Формируем статистику
    new string[1024];
    for (new i = 0; i < quan; i++)
    {
        new currentid = players[i];

        format(string, sizeof(string), 
            "%s" \
            "%s: %d/%d\n",

            string,
            PlayerInfo[currentid][pName],
            Tomb_PlayerGetMummyKilled(currentid),
            TombPlayerInfo[currentid][tpDeadCount]
        );
    }

    // Отображаем всем игрокам в комнате
    for (new i = 0; i < quan; i++) {
        new currentid = players[i];
        SetPlayerHudTask(currentid, "Гробница", string);
    }

    return 1;
}

stock Tomb_SetWave(roomid, waveid, cooldown = 0)
{
    if (!Tomb_IsRoomExists(roomid)) return 0;

    if (TombInfo[roomid][tiWaveCooldown] > 0)
    {
        TombInfo[roomid][tiWaveCooldown]--;
        return SetTimerEx("Tomb_SetWave_Timer", 1000, false, "ddd", roomid, waveid, 0);
    }

    if (cooldown > 0) {
        TombInfo[roomid][tiWaveCooldown] = cooldown;

        for (new i = 0; i < MAX_TOMB_PLAYERS; i++) {
            new currentid = TombInfo[roomid][tpPlayers] - 1;
            if (!IsOnline(currentid)) continue;

            PlayerPlaySound(currentid, 6400);
            Tomb_SetMummyRemainsTextdraw(currentid, false);
            Tomb_SetCurseTextdraw(currentid, false);
        }

        return SetTimerEx("Tomb_SetWave_Timer", 1000, false, "ddd", roomid, waveid, 0);
    }
    
    Tomb_UpdateMummyRemainsTextdraw(roomid);
    Tomb_UpdateWaveInfo(roomid);
    Tomb_ClearMummy(roomid);

    TombInfo[roomid][tiWaveCooldown] = 0;
    for (new i = 0; i < MAX_TOMB_PLAYERS; i++) {
        new currentid = TombInfo[roomid][tpPlayers][i] - 1;
        if (!IsOnline(currentid)) continue;

        for (new j = 0; j < 4; j++) TombPlayerInfo[currentid][tpSpentAmmo][j] = 0;
        PlayerPlaySound(currentid, 1139);
        PlayerTextDrawHide(currentid, ObstacleTimeTD[currentid]);

        Tomb_SetMummyRemainsTextdraw(currentid, true);

        Tomb_SetCurseTextdraw(currentid, true);
        Tomb_CurseProcess(currentid);
        Tomb_UpdateCurseTextdraw(currentid);
        
        for (new j = 0; j < _:TOMB_MAX_MUMMY_TYPE; j++)
        {
            TombPlayerInfo[currentid][tpLastWaveMummyKilled][j] = TombPlayerInfo[currentid][tpMummyKilled][j];
        }
    }

    TombInfo[roomid][tiWave] = e_TombWave: waveid;
    for (new i = 0; i < _:TOMB_MAX_MUMMY_TYPE; i++) {
        TombInfo[roomid][tpLastWaveMummyKilled][i] = TombInfo[roomid][tpMummyKilled][i];
        TombInfo[roomid][tiMummyWave][i] = 0;
        TombInfo[roomid][tiMummyNextSpawn][i] = 0;
    }

    TombInfo[roomid][tiMummyDamage] = 12.0;
    TombInfo[roomid][tiMummyMaxHealth] = 150.0;

    // Увеличиваем базовое HP мумий, опираясь на уровень сложности
    TombInfo[roomid][tiMummyMaxHealth] *= (_:TombInfo[roomid][tpDifficulty] + 1);

    new players_count = Tomb_GetPlayersCount(roomid, .alive = true);
    switch (TombInfo[roomid][tiWave])
    {
        case TOMB_WAVE_EASY: {
            switch (TombInfo[roomid][tpDifficulty])
            {
                case TOMB_DIFFICULTY_EASY: {
                    TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] = players_count * 5;
                }
                case TOMB_DIFFICULTY_HARD: {
                    TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] = players_count * 9;
                }
                default: {}
            }
        }
        case TOMB_WAVE_NORMAL:
        {
            switch (TombInfo[roomid][tpDifficulty])
            {
                case TOMB_DIFFICULTY_EASY: {
                    TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] = 3 + players_count * 6;
                }
                case TOMB_DIFFICULTY_HARD: {
                    TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] = 5 + players_count * 10;
                }
                default: {}
            }
        }
        case TOMB_WAVE_HARD:
        {
            switch (TombInfo[roomid][tpDifficulty])
            {
                case TOMB_DIFFICULTY_EASY: {
                    TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] = players_count * 7;
                    TombInfo[roomid][tiMummyWave][_:TOMB_HEAVY_MUMMY] = 2;
                    TombInfo[roomid][tiMummyMaxHealth] += 75.0;
                }
                case TOMB_DIFFICULTY_HARD: {
                    TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] = players_count * 12;
                    TombInfo[roomid][tiMummyWave][_:TOMB_HEAVY_MUMMY] = 5;
                    TombInfo[roomid][tiMummyMaxHealth] += 150.0;
                }
                default: {}
            }
        }
        case TOMB_WAVE_INSANE:
        {
            switch (TombInfo[roomid][tpDifficulty])
            {
                case TOMB_DIFFICULTY_EASY: {
                    TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] = players_count * 10;
                    TombInfo[roomid][tiMummyWave][_:TOMB_HEAVY_MUMMY] = 3;
                    TombInfo[roomid][tiMummyMaxHealth] += 100.0;
                }
                case TOMB_DIFFICULTY_HARD: {
                    TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] = players_count * 15;
                    TombInfo[roomid][tiMummyWave][_:TOMB_HEAVY_MUMMY] = 6;
                    TombInfo[roomid][tiMummyMaxHealth] += 200.0;
                }
                default: {}
            }
        }
        case TOMB_WAVE_IMPOSSIBLE:
        {
            switch (TombInfo[roomid][tpDifficulty])  
            {
                case TOMB_DIFFICULTY_EASY: {
                    TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] = players_count * 9;
                    TombInfo[roomid][tiMummyWave][_:TOMB_HEAVY_MUMMY] = 2;
                    TombInfo[roomid][tiMummyWave][_:TOMB_BOSS_MUMMY] = 1;
                    TombInfo[roomid][tiMummyMaxHealth] += 100.0;
                }
                case TOMB_DIFFICULTY_HARD: {
                    TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] = players_count * 14;
                    TombInfo[roomid][tiMummyWave][_:TOMB_HEAVY_MUMMY] = 5;
                    TombInfo[roomid][tiMummyWave][_:TOMB_BOSS_MUMMY] = 1;
                    TombInfo[roomid][tiMummyMaxHealth] += 200.0;
                }
                default: {}
            }
        }
        default: return 0;
    }

    Tomb_UpdateMummyRemainsTextdraw(roomid);
    Tomb_UpdateNextMummy(roomid);
    Tomb_SpawnMummy(roomid);

    return 1;
}

stock Tomb_GetPlayersCount(roomid, bool: alive = false)
{
    if (!Tomb_IsRoomExists(roomid)) return 0;

    new count = 0;

    for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        new currentid = TombInfo[roomid][tpPlayers][i] - 1;
        if (!IsOnline(currentid)) continue;
        if (alive && TombPlayerInfo[currentid][tpDead]) continue;

        count++;
    }

    return count;
}

stock Tomb_GetMummyCount(roomid, bool: alive = false)
{
    new count = 0;

    for (new i = 0; i < MAX_TOMB_MUMMY; i++)
    {
        if (!IsValidNpc(TombInfo[roomid][tiMummy][i])) continue;

        new Float: health; GetNpcHealth(TombInfo[roomid][tiMummy][i], health);
        if (alive && health <= 0.0) continue;
        
        count++;
    }

    return count;
}

stock Tomb_PlayerGetMummyKilled(playerid, type = -1, bool: current_wave = false)
{
    if (!Tomb_IsPlayerInGame(playerid)) return 0;
    if (type < -1 || type >= _:TOMB_MAX_MUMMY_TYPE) return 0;

    new killed = 0,
        lastwave_killed = 0;

    new minid = type == -1 ? 0 : type,
        maxid = type == -1 ? (_:TOMB_MAX_MUMMY_TYPE - 1) : type;

    for (new i = minid; i <= maxid; i++)
    {
        killed += TombPlayerInfo[playerid][tpMummyKilled][i];
        lastwave_killed += TombPlayerInfo[playerid][tpLastWaveMummyKilled][i];
    }
    if (current_wave) killed -= lastwave_killed;

    return killed;
}

stock Tomb_GetMummyKilled(roomid, type = -1, bool: current_wave = false)
{
    if (!Tomb_IsRoomExists(roomid)) return 0;
    if (type < -1 || type >= _:TOMB_MAX_MUMMY_TYPE) return 0;

    new killed = 0,
        lastwave_killed = 0;

    new minid = type == -1 ? 0 : type,
        maxid = type == -1 ? (_:TOMB_MAX_MUMMY_TYPE - 1) : type;

    for (new i = minid; i <= maxid; i++)
    {
        killed += TombInfo[roomid][tpMummyKilled][i];
        lastwave_killed += TombInfo[roomid][tpLastWaveMummyKilled][i];
    }
    if (current_wave) killed -= lastwave_killed;

    return killed;
}

function Tomb_DestroyDeadMummy(roomid, index)
{
    if (!Tomb_IsRoomExists(roomid)) return 0;

    new NPC: npc = TombInfo[roomid][tiMummy][index];
    if (IsValidNpc(npc)) {
        DestroyNpc(npc);
    }
    TombInfo[roomid][tiMummy][index] = NPC: 0;

    return 1;
}

stock Tomb_DisallowAreaProcess(roomid)
{
    if (!Tomb_IsRoomExists(roomid)) return 0;

    for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        new playerid = TombInfo[roomid][tpPlayers][i] - 1;
        if (!IsOnline(playerid)) continue; // Игнорируем игроков не в сети
        
        for (new j = 0; j < sizeof(TombDisallowedAreas); j++)
        {
            if (Protect_Z[playerid] < TombDisallowedAreas[j][tdaZ]) continue;
            if (!IsPlayerInSquare(playerid, TombDisallowedAreas[j][tdaMinX], TombDisallowedAreas[j][tdaMinY], TombDisallowedAreas[j][tdaMaxX], TombDisallowedAreas[j][tdaMaxY])) continue;

            new Float: closestDistance = 5000.0, point = -1; 
            for (new currentpoint = 0; currentpoint < sizeof(TombDisallowedAreaPoints); currentpoint++)
            {
                new Float: distance = GetPlayerDistanceFromPoint(playerid, TombDisallowedAreaPoints[currentpoint][tdapX], TombDisallowedAreaPoints[currentpoint][tdapY], TombDisallowedAreaPoints[currentpoint][tdapZ]);
                if (distance < closestDistance) {
                    closestDistance = distance;
                    point = currentpoint;
                }
            }

            if (point != -1)
            {
                PPSetPlayerPos(playerid, TombDisallowedAreaPoints[point][tdapX], TombDisallowedAreaPoints[point][tdapY], TombDisallowedAreaPoints[point][tdapZ]);
                PPSetPlayerFacingAngle(playerid, TombDisallowedAreaPoints[point][tdapA]);
                SetCameraBehindPlayer(playerid);

                PlayerPlaySound(playerid, 31200, 0, 0, 0);
            }
        }
    }
    return 1;
}

stock Tomb_UpdateCurse(playerid, Float: offset)
{
    if (TombPlayerInfo[playerid][tpCurse] + offset < 0.0) {
        TombPlayerInfo[playerid][tpCurse] = 0.0;
    } else if (TombPlayerInfo[playerid][tpCurse] + offset > 100.0) {
        TombPlayerInfo[playerid][tpCurse] = 100.0;
    } else {
        TombPlayerInfo[playerid][tpCurse] += offset;
    }
    Tomb_UpdateCurseTextdraw(playerid);
    return 1;
}

function Tomb_CurseProcess(playerid)
{
    new roomid = Tomb_GetPlayerRoom(playerid);
    if (!Tomb_IsRoomExists(roomid)) return 0;
    if (!IsOnline(playerid)) return 0;
    if (TombPlayerInfo[playerid][tpDead]) return 0;
    if (TombInfo[roomid][tiWaveCooldown] > 0) return 0;

    static Float: TombLastPositions[MAX_REALPLAYERS][3];
    if (GetPlayerDistanceFromPoint(playerid, TombLastPositions[playerid][0], TombLastPositions[playerid][1], TombLastPositions[playerid][2]) <= 0.5)
    {
        if (!IsPlayerAfk(playerid)) {
            Tomb_UpdateCurse(playerid, 0.75);
        } else {
            Tomb_UpdateCurse(playerid, 2.0);
        }
    } else {
        Tomb_UpdateCurse(playerid, -0.25);
    }

    if (TombPlayerInfo[playerid][tpCurse] >= 100.0) return Tomb_OnPlayerDeath(playerid);
    else if (TombPlayerInfo[playerid][tpCurse] >= 70.0) {
        // Урон -0.2HP каждые 300мс, если проклятие выше 70%
        ACSetPlayerHealth(playerid, HealthAC[playerid] - 0.2);
    }

    GetPlayerPos(playerid, TombLastPositions[playerid][0], TombLastPositions[playerid][1], TombLastPositions[playerid][2]);
    return SetTimerEx("Tomb_CurseProcess", 300, false, "d", playerid);
}

function Tomb_MummyProcess(roomid)
{
    if (!Tomb_IsRoomExists(roomid)) return 0;

    for (new i = 0; i < MAX_TOMB_MUMMY; i++)
    {
        new NPC: npc = TombInfo[roomid][tiMummy][i];
        if (!IsValidNpc(npc) || IsNpcDead(npc)) continue;

        new attackid = Tomb_GetNearestPlayerFromMummy(roomid, npc);
        if (IsOnline(attackid)) Tomb_MummySetAttack(roomid, npc, attackid);
    }

    Tomb_DisallowAreaProcess(roomid);

    return SetTimerEx("Tomb_MummyProcess", 1000, false, "d", roomid);
}

stock Tomb_GetNearestPlayerFromMummy(roomid, NPC: npcid, excludeid = -1)
{
    new playerid = -1;
    if (!Tomb_IsRoomExists(roomid)) return playerid;
    if (!IsValidNpc(npcid)) return playerid;

    new Float: x, Float: y, Float: z;
    GetNpcPosition(npcid, x, y, z);

    for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        new currentid = TombInfo[roomid][tpPlayers][i] - 1;
        if (!IsOnline(currentid)) continue; // Игнорируем игроков не в сети
        if (TombPlayerInfo[currentid][tpDead]) continue; // Игнорируем умерших игроков
        if (currentid == excludeid) continue; // Игнорируем необходимого игрока, если нужно
        if (IsPlayerNotTarget(currentid)) continue; // Игнорируем игроков, которые не могут являться целью для NPC

        if (!IsOnline(playerid) || GetPlayerDistanceFromPoint(playerid, x, y, z) > GetPlayerDistanceFromPoint(currentid, x, y, z))
        {
            playerid = currentid;
        }
    }

    return playerid;
}

function Tomb_LeaveExitTimer(playerid)
{
    if (Tomb_IsPlayerInside(playerid)) return 0;

    if (Tomb_IsPlayerInGame(playerid))
    {
        PlayerInfo[playerid][pLastTomb] = gettime();
        Tomb_Save(playerid);
        Tomb_DeleteMember(playerid);
    }

    return 1;
}

stock Tomb_MummySetAttack(roomid, NPC: npc, attackid)
{
    if (!IsValidNpc(npc) || IsNpcDead(npc)) return 0;

    for (new i = 0; i < MAX_TOMB_MUMMY; i++)
    {
        if (TombInfo[roomid][tiMummy][i] == npc) {
            if (TombInfo[roomid][tiMummyAttackId][i] - 1 == attackid) return 0;

            TombInfo[roomid][tiMummyAttackId][i] = attackid + 1;
            TaskNpcAttackPlayer(npc, attackid, TombInfo[roomid][tiMummyTypes][i] == _:TOMB_BOSS_MUMMY);
            return 1;
        }
    }

    return 0;
}

stock Tomb_UpdateCurseTextdraw(playerid)
{
    new roomid = Tomb_GetPlayerRoom(playerid);
    if (roomid < 0) return 0;
    if (TombPlayerInfo[playerid][tpDead]) return 0;
    if (TombInfo[roomid][tiWaveCooldown] > 0) return 0;

    new Float: width, Float: height;
    PlayerTextDrawGetTextSize(playerid, TombCurseTD[playerid][1], width, height);

    width = TombPlayerInfo[playerid][tpCurse];
    PlayerTextDrawTextSize(playerid, TombCurseTD[playerid][1], width, height);
    PlayerTextDrawShow(playerid, TombCurseTD[playerid][1]);

    foreach (new spectatorid : Player)
    {
        if (gSpectateID[spectatorid] == playerid) {
            PlayerTextDrawTextSize(spectatorid, TombCurseTD[spectatorid][1], width, height);
            PlayerTextDrawShow(spectatorid, TombCurseTD[spectatorid][1]);
        }
    }

    return 1;
}

stock Tomb_CreateMummy(roomid, e_TombMummyType: type, Float: x, Float: y, Float: z, Float: a)
{
    if (!Tomb_IsRoomExists(roomid)) return 0;

    for (new i = 0; i < MAX_TOMB_MUMMY; i++)
    {
        if (!TombInfo[roomid][tiMummy][i])
        {
            new skinid = 15784;
            if (type == TOMB_BOSS_MUMMY) skinid = 15790; // Босс (Анубис)
            new NPC: npcid = CreateNpc(skinid, x, y, z);

            new Float: health = TombInfo[roomid][tiMummyMaxHealth];
            if (type == TOMB_BOSS_MUMMY) {
                health *= frand(6.5, 10.0);
            } else if (type == TOMB_HEAVY_MUMMY) {
                health *= frand(2.0, 3.0);
            }

            SetNpcFacingAngle(npcid, a);
            SetNpcHealth(npcid, health);
            SetNpcVirtualWorld(npcid, Tomb_GetVirtualWorld(roomid));
            SetNpcStunAnimationEnabled(npcid, false);

            SetNpcWeapon(npcid, WEAPON: 0); // Очищаем оружие
            if (type == TOMB_HEAVY_MUMMY) SetNpcWeapon(npcid, WEAPON_BAT); // Бита в руки проклятой мумии

            new attackid = Tomb_GetNearestPlayerFromMummy(roomid, npcid);
            if (IsOnline(attackid)) Tomb_MummySetAttack(roomid, npcid, attackid);

            TombInfo[roomid][tiMummy][i] = npcid;
            TombInfo[roomid][tiMummyTypes][i] = _:type;

            #if defined TOMB_DEBUG_MODE
                printf("[TOMB DEBUG]: Мумия заспавнена в следующей точке: (%.04f, %.04f, %.04f, %.04f) - %.02f HP", x, y, z, a, health);
            #endif
            return _:npcid;
        }
    }
    
    return 0;
}

stock Tomb_ClearMummy(roomid)
{
    if (!Tomb_IsRoomExists(roomid)) return 0;
    
    for (new i = 0; i < MAX_TOMB_MUMMY; i++)
    {
        if (!IsValidNpc(TombInfo[roomid][tiMummy][i])) continue;

        DestroyNpc(TombInfo[roomid][tiMummy][i]);
        TombInfo[roomid][tiMummy][i] = NPC: 0;
        TombInfo[roomid][tiMummyTypes][i] = 0;
        TombInfo[roomid][tiMummyAttackId][i] = 0;
    }

    return 1;   
}

stock Tomb_SpawnMummy(roomid)
{
    if (!Tomb_IsRoomExists(roomid)) return 0;

    new max_spawn = sizeof(TombMummySpawns);
    if (TombInfo[roomid][tiWave] < TOMB_WAVE_HARD) max_spawn = 4;

    new Float: x, Float: y, Float: z, Float: a;

    // Спавн мумий
    new nextspawn_indexes[_:TOMB_MAX_MUMMY_TYPE], nextspawn_total = 0;
    for (new i = 0; i < _:TOMB_MAX_MUMMY_TYPE; i++) {
        nextspawn_total += TombInfo[roomid][tiMummyNextSpawn][i];
        nextspawn_indexes[i] = nextspawn_total - 1;
    }
    
    for (new i = 0; i < nextspawn_total; i++)
    {
        new spawn_index = random(max_spawn);

        // Спавн усиленных мумий
        new e_TombMummyType: mummy_type = TOMB_NORMAL_MUMMY;
        if (i > nextspawn_indexes[_:TOMB_HEAVY_MUMMY]) {
            mummy_type = TOMB_BOSS_MUMMY;
        }
        else if (i > nextspawn_indexes[_:TOMB_NORMAL_MUMMY])
        {
            mummy_type = TOMB_HEAVY_MUMMY;
        }

        RandomPointInCube(
            TombMummySpawns[spawn_index][tpMinX],
            TombMummySpawns[spawn_index][tpMinY],
            TombMummySpawns[spawn_index][tpZ],
            TombMummySpawns[spawn_index][tpMaxX],
            TombMummySpawns[spawn_index][tpMaxY],
            TombMummySpawns[spawn_index][tpZ],

            x, y, z
        );
        a = TombMummySpawns[spawn_index][tpAngle] + frand(-15.0, 15.0);

        Tomb_CreateMummy(roomid, mummy_type, x, y, z, a);
    }

    return 1;
}

// Получение общего количества мумий, которое должно заспавниться в текущей волне
stock Tomb_GetCurrentWaveMummyTotal(roomid, type = -1)
{
    if (type < -1 || type >= _:TOMB_MAX_MUMMY_TYPE) return 0;

    new count = 0;
    if (type == -1) {
        for (new i = 0; i < _:TOMB_MAX_MUMMY_TYPE; i++) {
            count += TombInfo[roomid][tiMummyWave][i];
        }
    } else {
        count = TombInfo[roomid][tiMummyWave][type];
    }
    return count;
}

// Получение количества убитых мумий в текущей волне
stock Tomb_GetCurrentWaveMummyKilled(roomid, type = -1)
{
    return Tomb_GetMummyKilled(roomid, type, .current_wave = true);
}

// Получение количества мумий, которое осталось убить до конца текущей волны
stock Tomb_GetCurrentWaveMummyRemains(roomid, type = -1)
{
    return Tomb_GetCurrentWaveMummyTotal(roomid, type) - Tomb_GetCurrentWaveMummyKilled(roomid, type);
}

// Получение отношения убитых мумий к их общему количеству для текущей волны
stock Float: Tomb_GetCurrentWaveKilledRatio(roomid)
{
    new mummy_total = Tomb_GetCurrentWaveMummyTotal(roomid);
    if (mummy_total <= 0) return 0;

    new Float: ratio = Tomb_GetCurrentWaveMummyKilled(roomid) / float(mummy_total);
    return ratio;
}

stock Tomb_UpdateNextMummy(roomid)
{
    // Определяем количество мумий, которые должны заспавниться в следующий раз
    new Float: mummy_killed_ratio = Tomb_GetCurrentWaveKilledRatio(roomid);

    #if defined TOMB_DEBUG_MODE
        printf("[TOMB DEBUG]: Количество убитых мумии для текущей волны: %d/%d (%.03f)", Tomb_GetCurrentWaveMummyKilled(roomid), Tomb_GetCurrentWaveMummyTotal(roomid), mummy_killed_ratio);
    #endif

    // Обнуление предыдущих значений
    for (new i = 0; i < _:TOMB_MAX_MUMMY_TYPE; i++) TombInfo[roomid][tiMummyNextSpawn][i] = 0;
    
    // Определение количества мумий каждого вида для спавна в зависимости от стадии волны
    if (mummy_killed_ratio <= 0.2) {
        TombInfo[roomid][tiMummyNextSpawn][_:TOMB_NORMAL_MUMMY] = floatround(TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] * 0.50);
        TombInfo[roomid][tiMummyNextSpawn][_:TOMB_HEAVY_MUMMY] = floatround(TombInfo[roomid][tiMummyWave][_:TOMB_HEAVY_MUMMY] * 0.70);
    }
    else if (mummy_killed_ratio <= 0.5) {
        TombInfo[roomid][tiMummyNextSpawn][_:TOMB_NORMAL_MUMMY] = floatround(TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] * 0.40);
    }
    else {
        TombInfo[roomid][tiMummyNextSpawn][_:TOMB_NORMAL_MUMMY] = floatround(TombInfo[roomid][tiMummyWave][_:TOMB_NORMAL_MUMMY] * 0.60);
        TombInfo[roomid][tiMummyNextSpawn][_:TOMB_HEAVY_MUMMY] = floatround(TombInfo[roomid][tiMummyWave][_:TOMB_HEAVY_MUMMY] * 0.80);
        TombInfo[roomid][tiMummyNextSpawn][_:TOMB_BOSS_MUMMY] = TombInfo[roomid][tiMummyWave][_:TOMB_BOSS_MUMMY];
    }

    if (mummy_killed_ratio >= 1) {
        // Если все мумии были убиты - не спавним никого
        for (new i = 0; i < _:TOMB_MAX_MUMMY_TYPE; i++) TombInfo[roomid][tiMummyNextSpawn][i] = 0;
    } else {
        // Если были убиты не все мумии - не спавним меньше одной обычной мумии (на всякий случай)
        if (TombInfo[roomid][tiMummyNextSpawn][_:TOMB_NORMAL_MUMMY] < 1) TombInfo[roomid][tiMummyNextSpawn][_:TOMB_NORMAL_MUMMY] = 1;
    }

    // Не спавним мумий каждого вида больше, чем положено
    for (new i = 0; i < _:TOMB_MAX_MUMMY_TYPE; i++) {
        new mummy_remains = Tomb_GetCurrentWaveMummyRemains(roomid, i);
        if (TombInfo[roomid][tiMummyNextSpawn][i] > mummy_remains) TombInfo[roomid][tiMummyNextSpawn][i] = mummy_remains;
    }

    #if defined TOMB_DEBUG_MODE
        printf("[TOMB DEBUG]: Должно быть заспавнено: %d обычных, %d усиленных и %d супер-мумий",
            TombInfo[roomid][tiMummyNextSpawn][_:TOMB_NORMAL_MUMMY],
            TombInfo[roomid][tiMummyNextSpawn][_:TOMB_HEAVY_MUMMY],
            TombInfo[roomid][tiMummyNextSpawn][_:TOMB_BOSS_MUMMY]
        );
    #endif
}

// Статистика после матча (Расчёт призов также тут)
stock Tomb_Dialog_Stats(playerid, e_TombEndReason: reason)
{
    new roomid = Tomb_GetPlayerRoom(playerid);
    if (!Tomb_IsRoomExists(roomid)) return 0;

    new dialog_text[2048];

    if (reason == TOMB_END_REASON_LOSE) {
        strcat(dialog_text, "{ff6347}К сожалению, вы проиграли");
        PlayerPlaySound(playerid, 1085);
    }
    else if (reason == TOMB_END_REASON_WIN) {
        strcat(dialog_text, "{99ff66}Поздравляем, вы одержали победу!");
        PlayerPlaySound(playerid, 1083);
    }
    strcat(dialog_text, "\n\n");

    format(dialog_text, sizeof(dialog_text),
        "%s" \
        "{ff9000}Личная статистика убийств:\n" \
        "{cccccc}- Обычных мумий уничтожено: %d\n" \
        "{cccccc}- Проклятых мумий уничтожено: %d",

        dialog_text,
        Tomb_PlayerGetMummyKilled(playerid, TOMB_NORMAL_MUMMY),
        Tomb_PlayerGetMummyKilled(playerid, TOMB_HEAVY_MUMMY)
    );
    if (Tomb_PlayerGetMummyKilled(playerid, TOMB_BOSS_MUMMY) >= 1) strcat(dialog_text, "\n{850000}- Вы уничтожили Анубиса!");

    strcat(dialog_text, "\n\n{ff9000}Ваши призы:");
    
    new case_amount;
    if (reason == TOMB_END_REASON_WIN) {
        // Гарантированные кейсы за прохождение (+4-6)
        case_amount += random_range(4, 6);
        if (_:TombInfo[roomid][tpDifficulty] > _:TOMB_DIFFICULTY_EASY) case_amount += 3;
        #if defined TOMB_DEBUG_MODE
            printf("[TOMB DEBUG]: Игрок %d получил %d кейсов за прохождение", playerid, case_amount);
        #endif
    }

    if (Tomb_GetMummyKilled(roomid, _:TOMB_BOSS_MUMMY) >= 1) {
        // 70% получить кейс, если был убит босс (даже при поражении)
        if(random(10) <= 7) {
            case_amount++;
            #if defined TOMB_DEBUG_MODE
                printf("[TOMB DEBUG]: Игрок %d получил дополнительный кейс за то, что при прохождении был убит босс", playerid);
            #endif
        }
    }

    // 3% получить Череп Осириса
    new osirisSkull = -1;
    if (random(100) < 3)
    {
        osirisSkull = 1;
        #if defined TOMB_DEBUG_MODE
            printf("[TOMB DEBUG]: Игрок %d получил Череп Осириса", playerid);
        #endif
    }

    {
        // 50% получить кейс для ТОП-1 по убийствам за всю игру
        new top1_kills_id = -1, top1_kills = 0;
        for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
        {
            new currentid = TombInfo[roomid][tpPlayers][i] - 1;
            if (!IsOnline(currentid)) continue;

            new kills = Tomb_PlayerGetMummyKilled(currentid, -1);

            if (top1_kills < kills) {
                top1_kills_id = currentid;
                top1_kills = kills;
            }
        }
        if (top1_kills_id == playerid) {
            if (random(4) < 2) {
                case_amount++;

                #if defined TOMB_DEBUG_MODE
                    printf("[TOMB DEBUG]: Игрок %d получил дополнительный кейс за ТОП-1 по убийствам", playerid);
                #endif
            }
        }
    }
    case_amount += TombPlayerInfo[playerid][tpCases]; // Прибавляем возможные кейсы, которые игрок мог получить на протяжении игры (за волны и т.п.)

    if (case_amount < 1 && osirisSkull < 1) strcat(dialog_text, "\n{cccccc}- Отсутствуют\n");
    else {
        new bool: no_place = false;
        {
            for (new i = 0; i < case_amount; i++)
            {
                new thingId, thingQuan, thingType, thingPara, thingPack;
                CreateCasePlayer(playerid, thingId, thingQuan, thingType, thingPara, thingPack);
                new put_inva = GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
                CalculateVehicleLimited(thingId, thingType);
                if (put_inva == -1) {
                    no_place = true;

                    new Float: x, Float: y, Float: z, Float: a;
                    x = TombGetOutPosition[playerid][0], y = TombGetOutPosition[playerid][1], z = TombGetOutPosition[playerid][2];
                    a = TombGetOutPosition[playerid][3];

                    frontme(INVALID_PLAYER_ID, 0.65, x, y, z, a);

                    SetThrow(
                        playerid, thingId, thingId, thingQuan, thingPara, 0, thingType, thingPack, 0, 0,
                        x + frand(-0.4, 0.4), y + frand(-0.4, 0.4), z - 0.8,
                        0.0, 0.0, a, 600, 0, 0
                    );
                }
            }
        }

        if (case_amount > 0) {
            format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}- Кейс: %d шт.", dialog_text, case_amount);
        }
        if (osirisSkull > 0) {
            strcat(dialog_text, "\n{ffcc00}- Череп Осириса (Редкий артефакт)");

            new put_inva = GiveThingPlayer(playerid, 242, 1, 0, 0, 0, 0);
            if (put_inva < 0) {
                no_place = true;
                Throw(playerid, 242, 1, 0, 0, 0, 0);
            }
        }

        if (no_place) strcat(dialog_text, "\n{ff6347}* Для одного или нескольких предметов не хватило места в инвентаре\n* Вы сможете найти их рядом с собой\n");
    }

    ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, " ", dialog_text, "Закрыть", "");

    return 1;
}

stock Tomb_SetPlayerTime(playerid)
{
    SetPlayerTime(playerid, 5, 0);
    SetPlayerWeather(playerid, 4);
    
    return 1;
}

stock Tomb_OnNpcDeath(NPC:npc, killerid, reason)
{
    #pragma unused reason

    for (new roomid = 0; roomid < MAX_TOMB_ROOMS; roomid++)
    {
        if (!Tomb_IsRoomExists(roomid)) continue;

        for (new npc_i = 0; npc_i < MAX_TOMB_MUMMY; npc_i++)
        {
            if (NPC: TombInfo[roomid][tiMummy][npc_i] == npc)
            {
                new mummy_type = TombInfo[roomid][tiMummyTypes][npc_i];
                TombInfo[roomid][tpMummyKilled][mummy_type]++;
                TombPlayerInfo[killerid][tpMummyKilled][mummy_type]++;

                TombInfo[roomid][tiMummyAttackId][npc_i] = 0;
                SetTimerEx("Tomb_DestroyDeadMummy", 5 * 1000, false, "dd", roomid, npc_i);

                Tomb_UpdateMummyRemainsTextdraw(roomid);
                Tomb_UpdateWaveInfo(roomid);

                new mummy = Tomb_GetMummyCount(roomid, .alive = true);
                if (mummy <= 0)
                {
                    Tomb_UpdateNextMummy(roomid);
                    Tomb_SpawnMummy(roomid);
                    
                    // Если уничтожили последнюю мумию в текущей волне
                    if (Tomb_GetCurrentWaveMummyRemains(roomid) <= 0)
                    {
                        // Если уничтожили последнюю оставшуюся мумию во всей игре
                        if (TombInfo[roomid][tiWave] == TOMB_WAVE_IMPOSSIBLE)
                        {
                            Tomb_End(roomid, TOMB_END_REASON_WIN);

                            #if defined TOMB_DEBUG_MODE
                                printf("[TOMB DEBUG]: Конец, все мумии уничтожены");
                            #endif
                        } else if (TombInfo[roomid][tiWave] != TOMB_WAVE_IMPOSSIBLE) {
                            for (new i = 0; i < MAX_TOMB_PLAYERS; i++) {
                                new currentid = TombInfo[roomid][tpPlayers][i] - 1;
                                if (!IsOnline(currentid)) continue;

                                SendClientMessage(currentid, 0x1E6698FF, "[ Гробница ]: {FFCC66}Текущая волна завершена, подготовьтесь к началу следующей!");

                                // Воскрешаем мертвых игроков
                                for (new j = 0; j < MAX_TOMB_PLAYERS; j++)
                                {
                                    new deadid = TombInfo[roomid][tpPlayers][j] - 1;
                                    if (!IsOnline(deadid)) continue;
                                    if (!TombPlayerInfo[deadid][tpDead]) continue;
                                    if (TombPlayerInfo[deadid][tpDeadCount] >= TOMB_MAX_DEATHS) continue;

                                    Tomb_StopSpectate(deadid, .lastposition = true);
                                    TombPlayerInfo[deadid][tpDead] = false;
                                    ACSetPlayerHealth(deadid, GetMaxPlayerHealth(deadid));
                                }

                                Tomb_GivePlayerWaveLoot(currentid);
                            }
                            
                            {
                                new top1_wave_kills_id = -1, top1_wave_kills = -1;
                                for (new i = 0; i < MAX_TOMB_PLAYERS; i++) {
                                    new currentid = TombInfo[roomid][tpPlayers][i] - 1;
                                    if (!IsOnline(currentid)) continue;

                                    if (top1_wave_kills_id >= -1) {
                                        new kills = Tomb_PlayerGetMummyKilled(currentid, -1, .current_wave = true);
                                        if (kills >= top1_wave_kills) {
                                            if (kills == top1_wave_kills) top1_wave_kills_id = -2;
                                            else {
                                                top1_wave_kills_id = currentid;
                                                top1_wave_kills = kills;
                                            }
                                        }
                                    }
                                }
                                
                                if (IsOnline(top1_wave_kills_id)) {
                                    // 30% получить кейс для ТОП-1 по убийствам на протяжении волны
                                    if (random(10) < 3) {
                                        TombPlayerInfo[top1_wave_kills_id][tpCases]++;
                                        #if defined TOMB_DEBUG_MODE
                                            printf("[TOMB DEBUG]: Игрок %d получил кейс за ТОП-1 по убийствам после окончания волны", top1_wave_kills_id);
                                        #endif
                                    }
                                }
                            }

                            Tomb_SetWave(roomid, _:TombInfo[roomid][tiWave] + 1, .cooldown = server == 0 ? TOMB_WAVE_COOLDOWN_TEST : TOMB_WAVE_COOLDOWN);

                            #if defined TOMB_DEBUG_MODE
                                printf("[TOMB DEBUG]: Изменение волны: %d", TombInfo[roomid][tiWave]);
                            #endif
                        }
                    }
                }

                return 1;
            }
        }
    }
    return 0;
}

stock Tomb_IsTeammates(firstid, secondid)
{
    return Tomb_IsPlayerInGame(firstid) && Tomb_GetPlayerRoom(firstid) == Tomb_GetPlayerRoom(secondid);
}

stock Tomb_GetPlayerRoom(playerid)
{
    if (!TombPlayerInfo[playerid][tpPlay]) return -1;

    return TombPlayerInfo[playerid][tpRoomID];
}

stock Tomb_OnPlayerGiveDamageNpc(NPC:npc, damagerid, Float: amount, weaponid, bodypart)
{
    #pragma unused npc
    #pragma unused weaponid
    #pragma unused bodypart

    new roomid = Tomb_GetPlayerRoom(damagerid);
    if (Tomb_IsRoomExists(roomid))
    {
        for (new npc_i = 0; npc_i < MAX_TOMB_MUMMY; npc_i++)
        {
            if (NPC: TombInfo[roomid][tiMummy][npc_i] == npc)
            {
                // Считаем урон
                new Float: damage = amount, Float: health;
                GetNpcHealth(npc, health);
                if (health - amount < 0.0) {
                    damage = health;
                }
                TombPlayerInfo[damagerid][tpDamage] += damage;
                Tomb_UpdateWaveInfo(roomid);
                return 1;
            }
        }
    }
    return 1;
}

stock Tomb_OnPlayerDeath(playerid)
{
    new roomid = Tomb_GetPlayerRoom(playerid);
    if (!Tomb_IsRoomExists(roomid)) return 0;
    if (TombPlayerInfo[playerid][tpDead]) return 0;

    TombPlayerInfo[playerid][tpDead] = true;
    TombPlayerInfo[playerid][tpDeadCount]++;
    TombPlayerInfo[playerid][tpCurse] = 0.0; // Сбрасываем проклятие

    Tomb_SetCurseTextdraw(playerid, false);
    Tomb_UpdateWaveInfo(roomid);

    for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        new currentid = TombInfo[roomid][tpPlayers][i] - 1;
        if (!IsOnline(currentid)) continue;

        SendClientMessage(currentid, 0x1E6698FF, "[ Гробница ]: {FFCC66}Союзник %s погиб!", PlayerInfo[playerid][pName]);
    }

    if (Tomb_GetPlayersCount(roomid, .alive = true) >= 1)
    {
        if (TombPlayerInfo[playerid][tpDeadCount] < TOMB_MAX_DEATHS)
        {
            SendClientMessage(playerid, 0x1E6698FF, "[ Гробница ]: {FFCC66}Будьте осторожны, количество возрождений ограничено [ Осталось: %d ]",
                TOMB_MAX_DEATHS - TombPlayerInfo[playerid][tpDeadCount]
            );
        } else SendClientMessage(playerid, 0x1E6698FF, "[ Гробница ]: {FFCC66}У вас не осталось возрождений");
    }

    // Если все игроки умерли - завершаем игру
    if (Tomb_GetPlayersCount(roomid, .alive = true) <= 0)
    {
        Tomb_End(roomid, TOMB_END_REASON_LOSE);
    } else {
        // Если живые ещё остались:
        // Направляем мумию на другого ближайшего к себе участника
        for (new i = 0; i < MAX_TOMB_MUMMY; i++)
        {
            new NPC: npcid = TombInfo[roomid][tiMummy][i];
            if (!IsValidNpc(npcid)) continue;

            new attackid = Tomb_GetNearestPlayerFromMummy(roomid, npcid, .excludeid = playerid);
            if (IsOnline(attackid)) Tomb_MummySetAttack(roomid, npcid, attackid);
        }

        // Переключаем наблюдение игрокам, которые за ним наблюдали
        for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
        {
            new currentid = TombInfo[roomid][tpPlayers][i] - 1;
            if (!IsOnline(currentid)) continue;
            
            if (Tomb_GetSpectateID(currentid) == playerid) {
                Tomb_SwitchPlayerSpectate(currentid);
            }
        }

        // Кидаем самого человека в наблюдение
        Tomb_SwitchPlayerSpectate(playerid);
    }

    return 1;
}

stock Tomb_OnPlayerTakeDamageNpc(NPC:npc, issuerid, Float:amount, weaponid, bodypart)
{
    #pragma unused amount
    #pragma unused weaponid
    #pragma unused bodypart
    
    new roomid = Tomb_GetPlayerRoom(issuerid);
    if (Tomb_IsRoomExists(roomid))
    {
        for (new npc_i = 0; npc_i < MAX_TOMB_MUMMY; npc_i++) {
            if (TombInfo[roomid][tiMummy][npc_i] == npc)
            {
                new Float: damage = TombInfo[roomid][tiMummyDamage];
                new type = TombInfo[roomid][tiMummyTypes][npc_i];
                switch (e_TombMummyType: type)
                {
                    case TOMB_HEAVY_MUMMY: {
                        damage *= 1.4;
                    }
                    case TOMB_BOSS_MUMMY: {
                        damage *= 1.75;
                        Tomb_UpdateCurse(issuerid, 8.0);
                    }
                    default: {}
                }

                new Float: health = HealthAC[issuerid] - damage;
                if (health <= 0.0)
                {
                    health = 1.0;
                    Tomb_OnPlayerDeath(issuerid);
                }

                // Устанавливаем HP игроку
                ACSetPlayerHealth(issuerid, health);
                
                return 0;
            }
        }
    }

    return 1;
}

stock Tomb_IsPlayerSpectate(playerid)
{
    return TombPlayerInfo[playerid][tpSpectateID] > 0;
}

stock Tomb_SetPlayerSpectate(playerid, spectateid)
{
    if (!Tomb_IsPlayerInGame(playerid) || !Tomb_IsPlayerInGame(spectateid)) return 0;
    if (TombPlayerInfo[playerid][tpSpectateID] - 1 == spectateid) return 0;

    #if defined TOMB_DEBUG_MODE
        printf("[TOMB DEBUG]: Игрок %d наблюдает за игроком %d", playerid, spectateid);
    #endif

    gSpectateID[playerid] = spectateid;
    
    if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) // Сохраняем позицию
	{
		new Float:X, Float:Y, Float:Z, Float:A;
 		GetPlayerPos(playerid, X, Y, Z); GetPlayerFacingAngle(playerid, A);
		SpA[playerid]=A;SpX[playerid]=X;SpY[playerid]=Y;SpZ[playerid]=Z;
		SpInt[playerid]=GetPlayerInterior(playerid);
		SpWorld[playerid]=GetPlayerVirtualWorld(playerid);
		S_SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(spectateid),GetPlayerInterior(spectateid));
		PPSetPlayerInterior(playerid,GetPlayerInterior(spectateid));
        PPOpenSpectating(playerid, X, Y, Z);
	}

    TombPlayerInfo[playerid][tpSpectateID] = spectateid + 1;
    StartSpectate(playerid, spectateid, 0);
    PlayerSpectatePlayer(playerid, spectateid);

    return 1;
}

stock Tomb_StopSpectate(playerid, bool: lastposition = false)
{
    if (!Tomb_IsPlayerSpectate(playerid) || GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) return 0;

    if (lastposition) StopSpectate(playerid);
    else {
        SetPosa[playerid] = 0;
        gSpectateID[playerid] = INVALID_PLAYER_ID, gSpectateType[playerid] = ADMIN_SPEC_TYPE_NONE;
        PPTogglePlayerSpectating(playerid, false);
    }
    TombPlayerInfo[playerid][tpSpectateID] = 0;

    return 1;
}

stock Tomb_GetSpectateID(playerid)
{
    return TombPlayerInfo[playerid][tpSpectateID] - 1;
}

stock Tomb_SwitchPlayerSpectate(playerid, bool: next = true)
{
    if (!Tomb_IsPlayerInGame(playerid)) return 0;

    new players_in_game[MAX_TOMB_PLAYERS];
    new index = 0, spectate_index = -1;
    foreach (new id : Player)
    {
        new roomid = Tomb_GetPlayerRoom(id);
        if (roomid != TombPlayerInfo[playerid][tpRoomID]) continue;
        if (id == playerid) continue;
        if (TombPlayerInfo[id][tpDead]) continue;

        players_in_game[index] = id;
        if (id == Tomb_GetSpectateID(playerid)) spectate_index = index;
        index++;
    }
    if (index == 0) return 0;
    else if (spectate_index == -1) return Tomb_SetPlayerSpectate(playerid, players_in_game[0]);

    index--;
    if (next) {
        if (spectate_index < index) Tomb_SetPlayerSpectate(playerid, players_in_game[spectate_index + 1]);
        else Tomb_SetPlayerSpectate(playerid, players_in_game[0]);
    } else {
        if (spectate_index > 0) Tomb_SetPlayerSpectate(playerid, players_in_game[spectate_index - 1]);
        else Tomb_SetPlayerSpectate(playerid, players_in_game[index]);
    }

    return 1;
}

stock Tomb_GivePlayerWaveLoot(playerid)
{
    new roomid = Tomb_GetPlayerRoom(playerid);
    if (!Tomb_IsRoomExists(roomid)) return 0;

    new gived_resources_line[128];

    // Выдача патрон
    for (new i = 27; i <= 30; i++) {
        new slot = 3 + (i-27);

        new spentAmmo = TombPlayerInfo[playerid][tpSpentAmmo][i - 27];
        
        // Если выдаем 11,43mm и пистолета-пулемета в руках нет, но есть пистолет - выдаем патроны для него
        if (i == 28 && ProtectInfo[playerid][prAmmo][4] < 1 && ProtectInfo[playerid][prAmmo][2] >= 1) slot = 2;

        if (spentAmmo <= 0) continue; // Если игрок не использовал это оружие - не выдаём патроны

        new maxAmmo = 100 * get_power(playerid);
        new currentAmmo = get_invent(playerid, i, 0) + ProtectInfo[playerid][prAmmo][slot];
        
        new ammo = floatround(float(spentAmmo) * 0.7);
        if (currentAmmo + ammo > maxAmmo) ammo = max(maxAmmo - currentAmmo, 0);

        if (ammo > 0) {
            if (ProtectInfo[playerid][prAmmo][slot] > 0) {
                // Выдаём сразу, если оружие есть в руках
                Protect_GiveWeapons(playerid, ProtectInfo[playerid][prWeapon][slot], ammo, 0, 0);
            }
            else {
                // Выдаём патроны в инвентарь, если оружия нет в руках
                GiveThingPlayer(playerid, i, ammo, 0, 0, 0, 0);
            }
            format(gived_resources_line, sizeof(gived_resources_line), "%s%s (%d шт.), ", gived_resources_line, GetNameThing(0, i, 0, 0), ammo);
        }

        #if defined TOMB_DEBUG_MODE
            printf("[TOMB DEBUG]: Игрок %d получил %d патрон (Слот оружия: %d)", playerid, ammo, slot);
        #endif
    }
    SetPlayerArmedWeapon(playerid, WEAPON_FIST);

    // Выдача бинтов
    new bandageId = 70;

    new quan, getQuan, getLimit;
    i_limit(playerid, bandageId, getQuan, getLimit);
    if (getQuan < getLimit) {
        switch(random(10) + 1) {
            case 1: quan = 3;
            case 2..4: quan = 2;
            case 5..9: quan = 1;
            default: quan = 0;
        }

        new currentQuan = get_invent(playerid, bandageId, 0);
        if (currentQuan + quan > getLimit) quan = max(getLimit - currentQuan, 0);
        quan = min(quan, getLimit);
        GiveThingPlayer(playerid, bandageId, quan, 0, 0, 0, 0, 9999);

        if (quan > 0) format(gived_resources_line, sizeof(gived_resources_line), "%s%s (%d шт.), ", gived_resources_line, GetNameThing(0, bandageId, 0, 0), quan);
    }
    #if defined TOMB_DEBUG_MODE
        printf("[TOMB DEBUG]: Игрок %d получил %d бинтов", playerid, quan);
    #endif

    if (!isnull(gived_resources_line)) {
        gived_resources_line[strlen(gived_resources_line) - 2] = EOS;
        SendClientMessage(playerid, 0x1E6698FF, "[ Гробница ]: {FFCC66}Ваши ресурсы были пополнены: %s", gived_resources_line);
    }

    return 1;
}

stock Tomb_AddMember(roomid, playerid)
{
    if (!Tomb_IsRoomExists(roomid)) return 0;

    for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        if (!TombInfo[roomid][tpPlayers][i])
        {
            TombInfo[roomid][tpPlayers][i] = playerid + 1;
            Tomb_LoadTextdraws(playerid);
            return 1;
        }
    }

    return 0;
}

stock Tomb_IsPlayerInGame(playerid)
{
    return Tomb_IsRoomExists(Tomb_GetPlayerRoom(playerid));
}

stock Tomb_Enter(playerid)
{
    keep(playerid);
    PPSetPlayerPos(playerid, 2143.1821, 1544.4906, 2773.5884);
    PPSetPlayerFacingAngle(playerid, 0.0);
    S_SetPlayerVirtualWorld(playerid, Tomb_GetVirtualWorld(Tomb_GetPlayerRoom(playerid)), 1);
    PPSetPlayerInterior(playerid, 1);
    SetCameraBehindPlayer(playerid);

    return 1;
}

stock Tomb_Exit(playerid)
{
    PPSetPlayerPos(playerid, -1261.844482, 2490.184570, 87.0468);
    PPSetPlayerFacingAngle(playerid, 90.0);
    S_SetPlayerVirtualWorld(playerid, 0);
    PPSetPlayerInterior(playerid, 0);
    SetCameraBehindPlayer(playerid);

    return 1;
}

stock Tomb_Dialog_Exit(playerid)
{
    ShowDialog(playerid, TOMB_DIALOG_EXIT, DIALOG_STYLE_MSGBOX, "{ff6347}Подтверждение выхода",
        "{ff6347}Вы уверены что хотите покинуть гробницу?\n\nИгра для вас будет автоматически завершена",

        "Да", "Закрыть"
    );
    return 1;
}

stock Tomb_DeleteMember(playerid)
{
    new roomid = Tomb_GetPlayerRoom(playerid);
    if (!Tomb_IsRoomExists(roomid)) return 0;

    Tomb_PlayerInfo_Cleanup(playerid);

    // Удаление текстдравов
    PlayerTextDrawDestroy(playerid, ObstacleTimeTD[playerid]);
    for (new i = 0; i < sizeof(TombMummyRemainsTD[]); i++) PlayerTextDrawDestroy(playerid, TombMummyRemainsTD[playerid][i]);
    for (new i = 0; i < sizeof(TombCurseTD[]); i++) PlayerTextDrawDestroy(playerid, TombCurseTD[playerid][i]);

    for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        if (TombInfo[roomid][tpPlayers][i] - 1 == playerid)
        {
            TombInfo[roomid][tpPlayers][i] = 0;

            // Если кто-то наблюдал за этим человеком - переключаем на следующего
            for (new j = 0; j < MAX_TOMB_PLAYERS; j++) {
                new currentid = TombInfo[roomid][tpPlayers][j] - 1;
                if (!IsOnline(currentid)) continue;

                if (Tomb_GetSpectateID(currentid) == playerid) {
                    Tomb_SwitchPlayerSpectate(currentid);
                }
            }

            // Направляем всех мумий на ближайшую цель, если они гнались за этим игроком
            for (new j = 0; j < MAX_TOMB_MUMMY; j++)
            {
                new NPC: npcid = TombInfo[roomid][tiMummy][j];
                if (!IsValidNpc(npcid)) continue;

                new attackid = Tomb_GetNearestPlayerFromMummy(roomid, npcid);
                if (IsOnline(attackid)) Tomb_MummySetAttack(roomid, npcid, attackid);
            }

            if (Tomb_GetPlayersCount(roomid, .alive = true) <= 0)
            {
                Tomb_End(roomid, TOMB_END_REASON_LOSE);

                #if defined TOMB_DEBUG_MODE
                    printf("[TOMB DEBUG]: Комната %d удалена [Ни одного участника в живых]", roomid);
                #endif
            }
            
            return 1;
        }
    }

    return 0;
}

stock Tomb_IsRoomExists(roomid)
{
    if (roomid < 0 || roomid >= MAX_TOMB_ROOMS) return 0;
    return TombInfo[roomid][tpPlay];
}

stock Tomb_Start(playerid)
{
    if (TombPlayerInfo[playerid][tpPlay]) return 1;

    new roomid = Tomb_CreateRoom(playerid);
    if (roomid < 0) return ErrorMessage(playerid, "{ff6347}Сейчас начать игру нельзя [Нет свободной комнаты]");

    // Если хост участник чужого лобби - кикаем его из него
    foreach (new id : Player)
    {
        if (id == playerid) continue;
        for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
        {
            if (TombPlayerInfo[id][tpPlayers][i] - 1 == playerid)
            {
                Tomb_Create_DeleteMember(id, playerid);
            }
        }
    }

    Tomb_Create_AddMember(playerid, playerid); // Хост всегда участник
    for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        new currentid = TombPlayerInfo[playerid][tpPlayers][i] - 1;
        if (!IsOnline(currentid)) continue;

        if (!Tomb_IsPlayerInside(currentid)) {
            Tomb_DeleteRoom(roomid);
            Tomb_Create_DeleteMember(playerid, playerid);
            return ErrorMessage(playerid, "{FF6347}Все участники команды должны находиться в гробнице перед началом игры");
        }
        
        TombPlayerInfo[currentid][tpPlay] = true;
        TombPlayerInfo[currentid][tpRoomID] = roomid;
        Tomb_Create_DeleteMember(playerid, currentid);
        Tomb_AddMember(roomid, currentid);
        SetPlayerVirtualWorld(currentid, Tomb_GetVirtualWorld(roomid));
        PlayerPlaySound(playerid, 3201);
    }

    TombInfo[roomid][tpDifficulty] = TombPlayerInfo[playerid][tpDifficulty];
    Tomb_SetWave(roomid, TOMB_WAVE_EASY); 

    return 1;
}

stock Tomb_GetVirtualWorld(roomid)
{
    if (!Tomb_IsRoomExists(roomid)) return 1;
    return TombInfo[roomid][tiOwner] + 2;
}

stock Tomb_GetOutPosition(&Float: x, &Float: y, &Float: z, &Float: a)
{
    x = -1279.2594 + frand(-3.0, 3.0); y = 2487.6809 + frand(-3.0, 3.0); z = 87.0799;
    a = 90.0;

    return 1;
}

stock Tomb_GetOutPlayer(playerid)
{
    S_SetPlayerVirtualWorld(playerid, 0, 0), PPSetPlayerInterior(playerid, 0);
    PPSetPlayerPos(playerid, TombGetOutPosition[playerid][0], TombGetOutPosition[playerid][1], TombGetOutPosition[playerid][2]);
    PPSetPlayerFacingAngle(playerid, TombGetOutPosition[playerid][3]);
    ClearAnimations(playerid, FORCE_SYNC: 1);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, true);
    return 1;
}

stock Tomb_End(roomid, e_TombEndReason: reason)
{
    if (!Tomb_IsRoomExists(roomid)) return 0;
    
    for (new j = 0; j < 2; j++) {
        for (new i = 0; i < MAX_TOMB_PLAYERS; i++) {
            new currentid = TombInfo[roomid][tpPlayers][i] - 1;
            if (!IsOnline(currentid)) continue;

            if (j == 0) {
                // Сначала выкидываем игроков на улицу и отображаем всем диалог о результатах игры (чтобы иметь доступ к статистике)
                SetPVarInt(currentid, "TombSpawn", 1);
                Tomb_GetOutPosition(
                    TombGetOutPosition[currentid][0], TombGetOutPosition[currentid][1], TombGetOutPosition[currentid][2],
                    TombGetOutPosition[currentid][3]
                );
                ACSetPlayerHealth(currentid, 1.0);
                if (!Tomb_StopSpectate(currentid)) PPSpawnPlayer(currentid);
                Tomb_Dialog_Stats(currentid, reason);
            } else {
                // Потом удаляем ненужные данные и прочее
                Tomb_PlayerInfo_Cleanup(currentid);
                PlayerTextDrawDestroy(currentid, ObstacleTimeTD[currentid]);
                for (new td_i = 0; td_i < sizeof(TombMummyRemainsTD[]); td_i++) PlayerTextDrawDestroy(currentid, TombMummyRemainsTD[currentid][td_i]);
                for (new td_i = 0; td_i < sizeof(TombCurseTD[]); td_i++) PlayerTextDrawDestroy(currentid, TombCurseTD[currentid][td_i]);

                PlayerInfo[currentid][pLastTomb] = gettime();
                Tomb_Save(currentid);
            }
        }
    }

    return Tomb_DeleteRoom(roomid);
}

stock Tomb_UpdateTimer(playerid) {
    new roomid = Tomb_GetPlayerRoom(playerid);
    if (Tomb_IsRoomExists(roomid))
    {
        new cooldown = TombInfo[roomid][tiWaveCooldown];
        if (cooldown > 0)
        {
            new ftime[32];
            format(ftime, sizeof(ftime), "%s", fine_time(cooldown));
            PlayerTextDrawSetString(playerid, ObstacleTimeTD[playerid], ftime);

            if (cooldown > 5) {
                PlayerTextDrawColour(playerid, ObstacleTimeTD[playerid], 0xFFFFFFFF);
            } else {
                PlayerTextDrawColour(playerid, ObstacleTimeTD[playerid], 0xFF0000FF);
            }
            PlayerTextDrawShow(playerid, ObstacleTimeTD[playerid]);
        }
    }
    return 1;
}

stock Tomb_Dialog_Start(playerid)
{
    new elapsed_time = Tomb_GetElapsedTime(playerid);
    if (elapsed_time > 0) {
        new message[128];
        format(message, sizeof(message), "{FF6347}Вы не можете играть в гробнице так часто [Можно через: %s]", fine_time(elapsed_time));
        return ErrorMessage(playerid, message);
    }
    return ShowDialog(playerid, TOMB_START_ACCEPT, DIALOG_STYLE_MSGBOX, "{ff9000}Гробница Фараона", "{99ff66}Вы действительно хотите начать?\n\n{cccccc}* Все участники должны находиться внутри гробницы", "Начать", "Назад");
}

stock Tomb_Create_GetPlayersCount(playerid)
{
    new count = 0;
    for (new i = 0; i < MAX_TOMB_PLAYERS; i++)
    {
        if (!TombPlayerInfo[playerid][tpPlayers][i]) continue;

        count++;
    }
    return count + 1; // Учитываем хоста, который добавится в команду в самом конце
}

stock Tomb_Dialog_AddMember(playerid)
{
    if (Tomb_Create_GetPlayersCount(playerid) >= MAX_TOMB_PLAYERS) {
        ErrorText(playerid, "{ff6347}Количество участников не может превышать "#MAX_TOMB_PLAYERS" человек");
        return Tomb_Dialog_Team(playerid);
    }

    new dialog_text[128] = "{cccccc}Введите никнейм или ID участника:";
    if (GetPVarInt(playerid, "TombNoPlayer")) {
        strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}Игрок не находится в гробнице");
        DeletePVar(playerid, "TombNoPlayer");
    }

    return ShowDialog(playerid, TOMB_DIALOG_ADDMEMBER, DIALOG_STYLE_INPUT, "{ff9000}Гробница Фараона", dialog_text, "Добавить", "Назад");
}

stock Tomb_PlayerInfo_Cleanup(playerid)
{
    for (new e_TombPlayerInfo: i; i < e_TombPlayerInfo; i++) TombPlayerInfo[playerid][i] = 0;

    return 1;
}

stock Tomb_OnKeyStateChange(playerid, KEY: newkeys, KEY: oldkeys)
{
    #pragma unused oldkeys

    if (!Tomb_IsPlayerInGame(playerid)) return 0;

    if (Tomb_IsPlayerSpectate(playerid)) {
        if (newkeys & KEY_FIRE) Tomb_SwitchPlayerSpectate(playerid, .next = true);
        else if (newkeys & KEY_HANDBRAKE) Tomb_SwitchPlayerSpectate(playerid, .next = false);
    }

    return 1;
}

stock Tomb_OnPlayerDisconnect(playerid)
{
    new roomid = Tomb_GetPlayerRoom(playerid);
    if (Tomb_IsRoomExists(roomid))
    {
        Tomb_DeleteMember(playerid);
    }

    Tomb_Save(playerid);
    Tomb_PlayerInfo_Cleanup(playerid);
    foreach (new currentid : Player) Tomb_Create_DeleteMember(currentid, playerid);

    return 1;
}

stock Tomb_IsPlayerInside(playerid)
{
    return IsPlayerInDynamicArea(playerid, TombZone);
}

stock Tomb_SendInvite(playerid, inviteid)
{
    DP[0][inviteid] = playerid;

    new dialog_text[256];

    format(dialog_text, sizeof(dialog_text),
        "{cccccc}Игрок %s[%d] приглашает вас в свою команду\n\n{99ff66}Вы согласны присоединиться?",

        playername(playerid), playerid  
    );
    ShowDialog(inviteid, TOMB_DIALOG_INVITE, DIALOG_STYLE_MSGBOX, "{ff9000}Гробница Фараона", dialog_text, "Принять", "Закрыть");

    return 1;
}

stock Tomb_Create_IsPlayerMember(playerid, inviterid = -1)
{
    new minid = inviterid == -1 ? 0 : inviterid;
    new maxid = inviterid == -1 ? MAX_REALPLAYERS : inviterid + 1;
    
    for (new i = minid; i < maxid; i++)
    {
        for (new j = 0; j < MAX_TOMB_PLAYERS; j++) {
            if (TombPlayerInfo[i][tpPlayers][j] - 1 == playerid) {
                return true;
            }
        }
    }

    return false;
}

stock dialogCase_Tomb(playerid, dialogid, response, listitem, const inputtext[])
{
    switch (e_DialogId: dialogid)
    {
        case TOMB_DIALOG_MAIN:
        {
            if (!response) return 1;

            switch(listitem)
            {
                case 0: return Tomb_Dialog_About(playerid);
                case 1: return Tomb_Dialog_Rules(playerid);
                case 2: {
                    TombPlayerInfo[playerid][tpDifficulty] = e_TombDifficulty:((_:TombPlayerInfo[playerid][tpDifficulty] + 1) % _:TOMB_MAX_DIFFICULTY);
                    return Tomb_Dialog_Main(playerid);
                }
                case 3: return Tomb_Dialog_Team(playerid);
                case 4: return Tomb_Dialog_Start(playerid);
            }
        }
        case TOMB_DIALOG_TEAM:
        {
            if (!response) return Tomb_Dialog_Main(playerid);

            if (listitem == 0) return Tomb_Dialog_AddMember(playerid);

            new currentid = List[listitem][playerid];
            Tomb_Create_DeleteMember(playerid, currentid);
            return Tomb_Dialog_Team(playerid);
        }
        case TOMB_DIALOG_ADDMEMBER:
        {
            if (!response) return Tomb_Dialog_Team(playerid);
            new currentid;
            if (sscanf(inputtext, "u", currentid) || !IsOnline(currentid) || !Tomb_IsPlayerInside(currentid)) {
                SetPVarInt(playerid, "TombNoPlayer", 1);
                return Tomb_Dialog_AddMember(playerid);
            }
            if (currentid == playerid) return ErrorMessage(playerid, "{ff6347}Вы будете автоматически считаться участником при запуске игры");
            if (!IsPlayerHaveLauncher(currentid)) return ErrorMessage(playerid, "{ff6347}Этот игрок не может быть добавлен, так как играет без лаунчера");
            if (Tomb_GetElapsedTime(currentid) > 0) return ErrorMessage(playerid, "{ff6347}Этот игрок не может быть добавлен, так как принимал участие в игре совсем недавно");
            if (Tomb_Create_IsPlayerMember(currentid)) return ErrorMessage(playerid, "{ff6347}Этот игрок уже состоит в чей-то команде");
            if (Tomb_Create_GetPlayersCount(playerid) >= MAX_TOMB_PLAYERS) return ErrorMessage(playerid, "{ff6347}Количество участников не может превышать "#MAX_TOMB_PLAYERS" человек");
            
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я пригласил %s в свою команду", playername(currentid));
            Tomb_SendInvite(playerid, currentid);

            return Tomb_Dialog_AddMember(playerid);
        }
        case TOMB_DIALOG_ABOUT:
        {
            return Tomb_Dialog_Main(playerid);
        }
        case TOMB_DIALOG_INVITE:
        {
            new inviterid = DP[0][playerid];

            if (!response) {
                SendClientMessage(inviterid, COLOR_GREY, "[ Мысли ]: %s отказался быть участником моей команды", playername(playerid));
                return 1;
            }

            if (!IsOnline(inviterid)) return ErrorMessage(playerid, "{FF6347}Пригласивший вас игрок вышел из игры");
            if (Tomb_GetElapsedTime(playerid) > 0) return ErrorMessage(playerid, "{FF6347}Ближайшее время вы не сможете принимать участие в игре");
            if (!Tomb_IsPlayerInside(inviterid)) return ErrorMessage(playerid, "{FF6347}Пригласивший вас игрок не находится в гробнице");
            if (Tomb_IsPlayerInGame(inviterid)) return ErrorMessage(playerid, "{FF6347}Пригласивший вас игрок уже находится в игре");
            if (Tomb_Create_IsPlayerMember(playerid)) return ErrorMessage(playerid, "{FF6347}Вы уже находитесь в чей-то команде");
            if (Tomb_Create_GetPlayersCount(inviterid) >= MAX_TOMB_PLAYERS) return ErrorMessage(playerid, "{FF6347}Максимальное количество участников превышено ["#MAX_TOMB_PLAYERS" человек]");
            
            Tomb_Create_AddMember(inviterid, playerid);
            SendClientMessage(inviterid, COLOR_GREY, "[ Мысли ]: %s согласился быть участником моей команды", playername(playerid));
            return SuccessMessage(playerid, "{99ff66}Вы согласились быть участником команды\n\nТеперь вам необходимо дождаться запуска игры");
        }
        case TOMB_START_ACCEPT:
        {
            if (!response) return Tomb_Dialog_Main(playerid);
            if (!Tomb_IsPlayerInside(playerid)) return ErrorMessage(playerid, "{FF6347}Нужно находиться внутри гробницы");
            if (server != 0 && Tomb_Create_GetPlayersCount(playerid) < MIN_TOMB_PLAYERS) return ErrorMessage(playerid, "{FF6347}Минимальное количество игроков для участия: "#MIN_TOMB_PLAYERS);
            if (Tomb_IsPlayerInGame(playerid)) return ErrorMessage(playerid, "{FF6347}Игра уже началась");
            
            return Tomb_Start(playerid);
        }
        case TOMB_DIALOG_QUEST: {
            if (!response) return pc_cmd_quest(playerid);
            
            CreateGps(playerid, 2373.6345, -651.1652, 127.4785, 0, 0, 2.0);
            SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ {ffffff}Карта {0088ff}]{ffffff}: {0088ff}Гробница Фараона {ffffff}отмечена на карте");
        }
        case TOMB_DIALOG_EXIT:
        {
            if (!response) return 1;

            Tomb_DeleteMember(playerid);
            Tomb_Exit(playerid);
            PlayerPlaySound(playerid, 17001);

            PlayerInfo[playerid][pLastTomb] = gettime();
            Tomb_Save(playerid);
        }
    }
    return 1;
}

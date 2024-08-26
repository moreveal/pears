/*
    CREATE TABLE `minewar` (
    `user_id` int(11) NOT NULL COMMENT 'ID аккаунта',
    `date` int(11) NOT NULL COMMENT 'Дата последней игры'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    ALTER TABLE `minewar`
    ADD UNIQUE KEY `id` (`user_id`);
*/
function MineWar_Load(playerid)
{
    new rows;
    cache_get_row_count(rows);
    if (rows <= 0) return 0;

    cache_get_value_name_int(0, "date", PlayerInfo[playerid][pLastMineWar]);

    return 1;
}

stock MineWar_Save(playerid)
{
    new query[128];
    mysql_format(pearsq, query, sizeof(query),
        "REPLACE INTO `minewar` \
        (`user_id`, `date`) \
        VALUES (%d, %d)",

        PlayerInfo[playerid][pID],
        PlayerInfo[playerid][pLastMineWar]
    );
    query_empty(pearsq, query);

    return 1;
}

CMD:rminewar(playerid, const params[])
{
    if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    
    new currentid;
    sscanf(params, "U(-1)", currentid);
    if (currentid == -1) currentid = playerid;
    if(!IsOnline(currentid)) return ErrorMessage(playerid, "{FF6347}Игрок не в сети");

    PlayerInfo[currentid][pLastMineWar] = 0;
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "** Вы очистили кд на повторную игру в Заброшенной Шахте для %s **", PlayerInfo[currentid][pName]);
    if(playerid != currentid) SendClientMessage(currentid, COLOR_LIGHTBLUE, "** %s очистил вам кд на повторную игру в Заброшенной Шахте **", PlayerInfo[playerid][pName]);

    AdminLog("rminewar", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[currentid][pID], PlayerInfo[currentid][pName], PlayerInfo[currentid][pPlaIP], 0, "");
    return 1;
}

stock MineWar_LoadTextdraws(playerid)
{
    Obstacle_CreateObstacleTimeTD(playerid);

    MineWarZombieRemainsTD[playerid][0] = CreatePlayerTextDraw(playerid, 43.0000, 191.0000, "120"); // пусто
    PlayerTextDrawLetterSize(playerid, MineWarZombieRemainsTD[playerid][0], 0.4000, 1.6000);
    PlayerTextDrawAlignment(playerid, MineWarZombieRemainsTD[playerid][0], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, MineWarZombieRemainsTD[playerid][0], -1);
    PlayerTextDrawBackgroundColour(playerid, MineWarZombieRemainsTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, MineWarZombieRemainsTD[playerid][0], TEXT_DRAW_FONT: 3);
    PlayerTextDrawSetProportional(playerid, MineWarZombieRemainsTD[playerid][0], true);
    PlayerTextDrawSetShadow(playerid, MineWarZombieRemainsTD[playerid][0], 0);

    MineWarZombieRemainsTD[playerid][1] = CreatePlayerTextDraw(playerid, 15.0000, 185.0000, "pears_element:zombie"); // пусто
    PlayerTextDrawTextSize(playerid, MineWarZombieRemainsTD[playerid][1], 21.0000, 26.0000);
    PlayerTextDrawAlignment(playerid, MineWarZombieRemainsTD[playerid][1], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, MineWarZombieRemainsTD[playerid][1], -1);
    PlayerTextDrawBackgroundColour(playerid, MineWarZombieRemainsTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, MineWarZombieRemainsTD[playerid][1], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, MineWarZombieRemainsTD[playerid][1], false);
    PlayerTextDrawSetShadow(playerid, MineWarZombieRemainsTD[playerid][1], 0);
    
    return 1;
}

stock MineWar_SetZombieRemainsTextdraw(playerid, bool: show = true)
{
    for (new i = 0; i < sizeof(MineWarZombieRemainsTD[]); i++)
    {
        if (show) {
            PlayerTextDrawShow(playerid, MineWarZombieRemainsTD[playerid][i]);
        } else {
            PlayerTextDrawHide(playerid, MineWarZombieRemainsTD[playerid][i]);
        }
    }
    return 1;
}

stock MineWar_UpdateZombieRemainsTextdraw(roomid)
{
    for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++)
    {
        new currentid = MineWarInfo[roomid][mwPlayers][i] - 1;
        if (!IsOnline(currentid)) continue;

        PlayerTextDrawSetString(currentid, MineWarZombieRemainsTD[currentid][0], FormatNumberWithCommas(MineWar_GetCurrentWaveZombieRemains(roomid)));
    }
    return 1;
}

stock MineWar_GeneralChat(playerid, const string[])
{
    if (!MineWar_IsPlayerInside(playerid)) return 0;
    if (!MineWarPlayerInfo[playerid][mwpDead] && (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT && GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER) ) return 0;

    foreach (new currentid : Player)
    {
        if (MineWarPlayerInfo[playerid][mwpRoomID] != MineWarPlayerInfo[currentid][mwpRoomID]) continue;
        if (GetPlayerVirtualWorld(currentid) != GetPlayerVirtualWorld(playerid)) continue;
        if (!MineWar_IsPlayerInside(currentid)) continue;

        SendClientMessage(currentid, 0x1E6698FF, "[ Шахта ]: {555555}%s: %s", PlayerInfo[playerid][pName], string);
    }

    return 1;
}

stock MineWar_GetElapsedTime(playerid)
{
    if (PlayerInfo[playerid][pLastMineWar] <= 0) return 0;
    if (server == 0) return 0; // Для тестового сервера шахта всегда доступна

    return max(PlayerInfo[playerid][pLastMineWar] + MINEWAR_COOLDOWN * 60 - gettime(), 0);
}

stock MineWar_CreateDynamicArea()
{
    new const worlds[MAX_REALPLAYERS + 5] = {1, 2, 3, ...};
    MineWarZone = CreateDynamicCubeEx(19.1310, 1187.5389, 1309.3766, -69.5142, 1081.3936, 1372.4247, .worlds = worlds);
    return 1;
}

stock MineWar_GetDifficultyName(e_MineWarDifficulty: difficulty)
{
    new string[32];

    switch(difficulty)
    {
        case MINEWAR_DIFFICULTY_EASY: strcat(string, "Легко");
        case MINEWAR_DIFFICULTY_HARD: strcat(string, "Трудно");
        default: {}
    }

    return string;
}

stock MineWar_Dialog_Main(playerid)
{
    new dialog_text[2048];
    if (!MineWar_IsPlayerInGame(playerid)) {
        if (!IsPlayerHaveLauncher(playerid)) return ErrorMessage(playerid, "{FF6347}Игра доступна только для игроков с лаунчером");
        if (MineWar_GetElapsedTime(playerid) > 0) return ErrorMessage(playerid, "{FF6347}Ближайшее время вы не сможете принимать участие в игре");

        format(dialog_text, sizeof(dialog_text), 
            "{555555}Что это за место?\t\n" \
            "{555555}Условия и правила\t\n" \
            "{ff9000}Сложность:\t{cccccc}%s\n" \
            "{ff9000}Моя команда\t{ff9000}>>\n" \
            "{99ff66}Начать",

            (MineWar_GetDifficultyName(MineWarPlayerInfo[playerid][mwpDifficulty]))
        );
        ShowDialog(playerid, MINEWAR_DIALOG_MAIN, DIALOG_STYLE_TABLIST, "{ff9000}Заброшенная шахта", dialog_text, "Выбор", "Закрыть");
    } else {
        // Возможно, добавить какой-то диалог для завершения игры, если игрок ее запустил и т.п., пока без всего
    }

    return 1;
}

stock MineWar_Dialog_About(playerid)
{
    ShowDialog(playerid, MINEWAR_DIALOG_ABOUT, DIALOG_STYLE_MSGBOX, "{ff9000}Заброшенная шахта",
        "{cccccc}Сюда никто не решается спуститься, даже в ясный день.\n" \
        "Старинная шахта, разорённая временем и покрытая сетью мрачных легенд, давно перестала привлекать золотоискателей и работников.\n\n" \
        \
        "Местные шепчутся, что сама земля здесь прогнила от зла, и что те, кто осмелится войти, могут уже никогда не увидеть дневного света.\n" \
        "Шахта считается проклятой: говорят, что глубоко под землёй обитают мертвецы, оставшиеся\n" \
        "здесь навсегда после того, как шахта была в спешке закрыта.\n\n" \
        \
        "Тени этих несчастных теперь бродят по коридорам, охраняя свое последнее пристанище.\n" \
        "Тот, кто бросит вызов, ступив на их территорию, может рассчитывать лишь на страх и боль.",
        
        "Назад", ""
    );

    return 1;
}

stock MineWar_Dialog_Rules(playerid)
{
    ShowDialog(playerid, MINEWAR_DIALOG_ABOUT, DIALOG_STYLE_MSGBOX, "{ff9000}Заброшенная шахта",
        "{ff9000}Состав команды\n" \
        "{cccccc}- Вы не можете оставаться в шахте, будучи совсем одним, сперва вам необходимо обзавестись командой\n" \
        "{cccccc}- В одной команде не может быть больше "#MAX_MINEWAR_PLAYERS" участников\n\n" \
        \
        "{ff9000}Сложности\n" \
        "{cccccc}- Перед запуском игры у вас есть выбор из двух сложностей: простой и сложной\n" \
        "{cccccc}- При выборе высокой сложности зомби становятся гораздо опаснее, а их количество возрастает\n" \
        "{cccccc}- Если вы сможете одолеть зомби при высоком уровне сложности, ваши призы будут сильно ценнее обычных\n\n" \
        \
        "{ff9000}Описание режима\n" \
        "{cccccc}- После запуска игры сразу же появятся зомби, которых потребуется убить вместе с товарищами по команде\n" \
        "{cccccc}- Зомби подходят волнами, численность их групп меняется в зависимости от стадии волны\n\n" \
        \
        "{ff9000}Механика волн\n" \
        "{cccccc}- Каждая волна зомби увеличивается по численности, становясь всё опаснее с каждой новой атакой\n" \
        "{cccccc}- В некоторых волнах появляются усиленные типы зомби, которых сложнее уничтожить, и они наносят больший урон\n" \
        "{cccccc}- После завершения каждой волны у игроков будет время на отдых\n" \
        "{cccccc}- В перерывах между волнами игрокам случайным образом выдаются патроны и бинты для пополнения ресурсов\n\n" \
        \
        "{ff9000}Награды и штрафы\n" \
        "{cccccc}- В случае победы в конце игры каждому участнику будут выданы особые призы\n" \
        "{cccccc}- Ценность призов зависит от вашего личного вклада в победу, а также от установленного уровня сложности\n" \
        "{cccccc}- В случае поражения или победы каждый из участников не сможет некоторое время участвовать повторно\n",

        "Назад", ""
    );
    
    return 1;
}

stock MineWar_Dialog_Team(playerid)
{
    new dialog_text[4096] = "{99ff66}Добавить участника";

    for (new quan, i = 0; i < MAX_MINEWAR_PLAYERS; i++)
    {
        new currentid = MineWarPlayerInfo[playerid][mwpPlayers][i] - 1;
        if (currentid < 0) continue;

        format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}%d. %s", dialog_text, quan + 1, PlayerInfo[currentid][pName]);

        List[++quan][playerid] = currentid;
    }

    ShowDialog(playerid, MINEWAR_DIALOG_TEAM, DIALOG_STYLE_LIST, "{ff9000}Заброшенная шахта", dialog_text, "Выбор", "Назад");
    return 1;
}

stock MineWar_Create_AddMember(playerid, currentid)
{
    for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++)
    {
        if (!MineWarPlayerInfo[playerid][mwpPlayers][i])
        {
            MineWarPlayerInfo[playerid][mwpPlayers][i] = currentid + 1;
            return i;
        }
    }
    return -1;
}

stock MineWar_Create_DeleteMember(playerid, currentid)
{
    for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++)
    {
        if (MineWarPlayerInfo[playerid][mwpPlayers][i] - 1 == currentid)
        {
            MineWarPlayerInfo[playerid][mwpPlayers][i] = 0;
            break;
        }
    }
    return 1;
}

stock MineWar_CreateRoom(ownerid)
{
    for (new i = 0; i < MAX_MINEWAR_ROOMS; i++)
    {
        if (!MineWar_IsRoomExists(i))
        {
            MineWar_DeleteRoom(i);

            MineWarInfo[i][mwPlay] = true;
            MineWarInfo[i][mwOwner] = ownerid;
            MineWar_ZombieProcess(i);

            return i;
        }
    }

    return -1;
}

stock MineWar_DeleteRoom(roomid)
{
    if (!MineWar_IsRoomExists(roomid)) return 0;

    MineWar_ClearZombies(roomid);
    for (new e_MineWarInfo: i; i < e_MineWarInfo; i++) MineWarInfo[roomid][i] = 0;

    return 1;
}

function MineWar_SetWave_Timer(roomid, waveid, cooldown)
{
    return MineWar_SetWave(roomid, waveid, cooldown);
}

stock MineWar_OnShoot(playerid, WEAPON: weaponid)
{
    new sl = Protect_Slot(weaponid);
    new index = sl - 3;
    if (sl == 2) index = 1;
    if (index >= 0 && index <= 3)
    {
        MineWarPlayerInfo[playerid][mwpSpentAmmo][index]++;
    }
    return 1;
}

stock MineWar_SetWave(roomid, waveid, cooldown = 0)
{
    if (!MineWar_IsRoomExists(roomid)) return 0;
    if (cooldown == 0 && MineWarInfo[roomid][mwWaveCooldown] > 0) return 0;

    if (cooldown > 0) {
        if (IsValidTimer(MineWarInfo[roomid][mwSetWaveTimer])) KillTimer(MineWarInfo[roomid][mwSetWaveTimer]);
        MineWarInfo[roomid][mwWaveCooldown] = cooldown;

        for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++) {
            new currentid = MineWarInfo[roomid][mwPlayers] - 1;
            if (!IsOnline(currentid)) continue;

            PlayerPlaySound(currentid, 6400);
            MineWar_SetZombieRemainsTextdraw(currentid, false);
        }

        MineWarInfo[roomid][mwSetWaveTimer] = SetTimerEx("MineWar_SetWave_Timer", cooldown * 1000, false, "ddd", roomid, waveid, 0);
        return 1;
    }
    
    MineWar_UpdateZombieRemainsTextdraw(roomid);
    MineWar_ClearZombies(roomid);

    MineWarInfo[roomid][mwWaveCooldown] = 0;
    for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++) {
        new currentid = MineWarInfo[roomid][mwPlayers][i] - 1;
        if (!IsOnline(currentid)) continue;

        for (new j = 0; j < 4; j++) MineWarPlayerInfo[currentid][mwpSpentAmmo][j] = 0;
        PlayerPlaySound(currentid, 1139);
        PlayerTextDrawHide(currentid, ObstacleTimeTD[currentid]);

        MineWar_SetZombieRemainsTextdraw(currentid, true);
        
        for (new j = 0; j < _:MINEWAR_MAX_ZOMBIE_TYPE; j++)
        {
            MineWarPlayerInfo[currentid][mwpLastWaveZombieKilled][j] = MineWarPlayerInfo[currentid][mwpZombieKilled][j];
        }
    }

    MineWarInfo[roomid][mwWave] = e_MineWarWave: waveid;
    for (new i = 0; i < _:MINEWAR_MAX_ZOMBIE_TYPE; i++) {
        MineWarInfo[roomid][mwLastWaveZombieKilled][i] = MineWarInfo[roomid][mwZombieKilled][i];
        MineWarInfo[roomid][mwZombieWave][i] = 0;
        MineWarInfo[roomid][mwZombieNextSpawn][i] = 0;
    }

    MineWarInfo[roomid][mwZombieDamage] = 12.0;
    MineWarInfo[roomid][mwZombieMaxHealth] = 100.0;

    // Увеличиваем базовое HP зомби, опираясь на уровень сложности
    MineWarInfo[roomid][mwZombieMaxHealth] *= (_:MineWarInfo[roomid][mwDifficulty] + 1);

    new players_count = MineWar_GetPlayersCount(roomid, .alive = true);
    switch (MineWarInfo[roomid][mwWave])
    {
        case MINEWAR_WAVE_EASY: {
            switch (MineWarInfo[roomid][mwDifficulty])
            {
                case MINEWAR_DIFFICULTY_EASY: {
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_NORMAL_ZOMBIE] = players_count * 8;
                }
                case MINEWAR_DIFFICULTY_HARD: {
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_NORMAL_ZOMBIE] = players_count * 12;
                }
                default: {}
            }
        }
        case MINEWAR_WAVE_NORMAL:
        {
            switch (MineWarInfo[roomid][mwDifficulty])
            {
                case MINEWAR_DIFFICULTY_EASY: {
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_NORMAL_ZOMBIE] = 3 + players_count * 11;
                }
                case MINEWAR_DIFFICULTY_HARD: {
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_NORMAL_ZOMBIE] = 5 + players_count * 13;
                }
                default: {}
            }
        }
        case MINEWAR_WAVE_HARD:
        {
            switch (MineWarInfo[roomid][mwDifficulty])
            {
                case MINEWAR_DIFFICULTY_EASY: {
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_NORMAL_ZOMBIE] = players_count * 12;
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_HEAVY_ZOMBIE] = 2;
                    MineWarInfo[roomid][mwZombieMaxHealth] += 50.0;
                }
                case MINEWAR_DIFFICULTY_HARD: {
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_NORMAL_ZOMBIE] = players_count * 16;
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_HEAVY_ZOMBIE] = 5;
                    MineWarInfo[roomid][mwZombieMaxHealth] += 100.0;
                }
                default: {}
            }
        }
        case MINEWAR_WAVE_IMPOSSIBLE:
        {
            switch (MineWarInfo[roomid][mwDifficulty])  
            {
                case MINEWAR_DIFFICULTY_EASY: {
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_NORMAL_ZOMBIE] = players_count * 15;
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_HEAVY_ZOMBIE] = 2;
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_SUPER_ZOMBIE] = 1;
                    MineWarInfo[roomid][mwZombieMaxHealth] += 50.0;
                }
                case MINEWAR_DIFFICULTY_HARD: {
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_NORMAL_ZOMBIE] = players_count * 18;
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_HEAVY_ZOMBIE] = 5;
                    MineWarInfo[roomid][mwZombieWave][_:MINEWAR_SUPER_ZOMBIE] = 1;
                    MineWarInfo[roomid][mwZombieMaxHealth] += 100.0;
                }
                default: {}
            }
        }
        default: return 0;
    }

    MineWar_UpdateZombieRemainsTextdraw(roomid);
    MineWar_UpdateNextZombies(roomid);
    MineWar_SpawnZombies(roomid);

    return 1;
}

stock MineWar_GetPlayersCount(roomid, bool: alive = false)
{
    if (!MineWar_IsRoomExists(roomid)) return 0;

    new count = 0;

    for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++)
    {
        new currentid = MineWarInfo[roomid][mwPlayers][i] - 1;
        if (!IsOnline(currentid)) continue;
        if (alive && MineWarPlayerInfo[currentid][mwpDead]) continue;

        count++;
    }

    return count;
}

stock MineWar_GetZombieCount(roomid, bool: alive = false)
{
    new count = 0;

    for (new i = 0; i < MAX_MINEWAR_ZOMBIES; i++)
    {
        if (!IsValidNpc(MineWarInfo[roomid][mwZombie][i])) continue;

        new Float: health; GetNpcHealth(MineWarInfo[roomid][mwZombie][i], health);
        if (alive && health <= 0.0) continue;
        
        count++;
    }

    return count;
}

stock MineWar_PlayerGetZombieKilled(playerid, type = -1, bool: current_wave = false)
{
    if (!MineWar_IsPlayerInGame(playerid)) return 0;
    if (type < -1 || type >= _:MINEWAR_MAX_ZOMBIE_TYPE) return 0;

    new killed = 0,
        lastwave_killed = 0;

    new minid = type == -1 ? 0 : type,
        maxid = type == -1 ? (_:MINEWAR_MAX_ZOMBIE_TYPE - 1) : type;

    for (new i = minid; i <= maxid; i++)
    {
        killed += MineWarPlayerInfo[playerid][mwpZombieKilled][i];
        lastwave_killed += MineWarPlayerInfo[playerid][mwpLastWaveZombieKilled][i];
    }
    if (current_wave) killed -= lastwave_killed;

    return killed;
}

stock MineWar_GetZombieKilled(roomid, type = -1, bool: current_wave = false)
{
    if (!MineWar_IsRoomExists(roomid)) return 0;
    if (type < -1 || type >= _:MINEWAR_MAX_ZOMBIE_TYPE) return 0;

    new killed = 0,
        lastwave_killed = 0;

    new minid = type == -1 ? 0 : type,
        maxid = type == -1 ? (_:MINEWAR_MAX_ZOMBIE_TYPE - 1) : type;

    for (new i = minid; i <= maxid; i++)
    {
        killed += MineWarInfo[roomid][mwZombieKilled][i];
        lastwave_killed += MineWarInfo[roomid][mwLastWaveZombieKilled][i];
    }
    if (current_wave) killed -= lastwave_killed;

    return killed;
}

function MineWar_DestroyDeadZombie(roomid, index)
{
    if (!MineWar_IsRoomExists(roomid)) return 0;

    new NPC: npc = MineWarInfo[roomid][mwZombie][index];
    if (IsValidNpc(npc)) {
        DestroyNpc(npc);
    }
    MineWarInfo[roomid][mwZombie][index] = NPC: 0;

    return 1;
}

function MineWar_ZombieProcess(roomid)
{
    if (!MineWar_IsRoomExists(roomid)) return 0;

    for (new i = 0; i < MAX_MINEWAR_ZOMBIES; i++)
    {
        new NPC: npc = MineWarInfo[roomid][mwZombie][i];
        if (!IsValidNpc(npc) || IsNpcDead(npc)) continue;

        new attackid = MineWar_GetNearestPlayerFromZombie(roomid, npc);
        if (IsOnline(attackid)) MineWar_ZombieSetAttack(roomid, npc, attackid);
    }

    return SetTimerEx("MineWar_ZombieProcess", 1000, false, "d", roomid);
}

stock MineWar_GetNearestPlayerFromZombie(roomid, NPC: npcid, excludeid = -1)
{
    new playerid = -1;
    if (!MineWar_IsRoomExists(roomid)) return playerid;
    if (!IsValidNpc(npcid)) return playerid;

    new Float: x, Float: y, Float: z;
    GetNpcPosition(npcid, x, y, z);

    for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++)
    {
        new currentid = MineWarInfo[roomid][mwPlayers][i] - 1;
        if (!IsOnline(currentid)) continue; // Игнорируем игроков не в сети
        if (MineWarPlayerInfo[currentid][mwpDead]) continue; // Игнорируем умерших игроков
        if (currentid == excludeid) continue; // Игнорируем необходимого игрока, если нужно
        if (IsPlayerNotTarget(currentid)) continue; // Игнорируем игроков, которые не могут являться целью для NPC

        if (!IsOnline(playerid) || GetPlayerDistanceFromPoint(playerid, x, y, z) > GetPlayerDistanceFromPoint(currentid, x, y, z))
        {
            playerid = currentid;
        }
    }

    return playerid;
}

function MineWar_LeaveExitTimer(playerid)
{
    if (MineWar_IsPlayerInside(playerid)) return 0;

    if (MineWar_IsPlayerInGame(playerid))
    {
        PlayerInfo[playerid][pLastMineWar] = gettime();
        MineWar_Save(playerid);
        MineWar_DeleteMember(playerid);
    }

    return 1;
}

stock MineWar_ZombieSetAttack(roomid, NPC: npc, attackid)
{
    if (!IsValidNpc(npc) || IsNpcDead(npc)) return 0;

    for (new i = 0; i < MAX_MINEWAR_ZOMBIES; i++)
    {
        if (MineWarInfo[roomid][mwZombie][i] == npc) {
            if (MineWarInfo[roomid][mwZombieAttackId][i] - 1 == attackid) return 0;

            MineWarInfo[roomid][mwZombieAttackId][i] = attackid + 1;
            TaskNpcAttackPlayer(npc, attackid);
            return 1;
        }
    }

    return 0;
}

stock MineWar_CreateZombie(roomid, e_MineWarZombieType: type, Float: x, Float: y, Float: z, Float: a)
{
    if (!MineWar_IsRoomExists(roomid)) return 0;

    for (new i = 0; i < MAX_MINEWAR_ZOMBIES; i++)
    {
        if (!MineWarInfo[roomid][mwZombie][i])
        {
            new NPC: npcid = CreateNpc(15700 + random(9), x, y, z);

            new Float: health = MineWarInfo[roomid][mwZombieMaxHealth];
            if (type == MINEWAR_SUPER_ZOMBIE) {
                health *= frand(6.5, 10.0);
            } else if (type == MINEWAR_HEAVY_ZOMBIE) {
                health *= frand(3.0, 4.0);
            }

            SetNpcFacingAngle(npcid, a);
            SetNpcHealth(npcid, health);
            SetNpcVirtualWorld(npcid, MineWar_GetVirtualWorld(roomid));
            SetNpcStunAnimationEnabled(npcid, false);

            SetNpcWeapon(npcid, WEAPON: 0); // Очищаем оружие (временное решение, пока в плагине баг)
            if (type == MINEWAR_HEAVY_ZOMBIE) SetNpcWeapon(npcid, WEAPON_BAT); // Бита в руки усиленному зомби
            else if (type == MINEWAR_SUPER_ZOMBIE) SetNpcWeapon(npcid, WEAPON_CHAINSAW); // Бензопила в руки супер-зомби

            new attackid = MineWar_GetNearestPlayerFromZombie(roomid, npcid);
            if (IsOnline(attackid)) MineWar_ZombieSetAttack(roomid, npcid, attackid);

            MineWarInfo[roomid][mwZombie][i] = npcid;
            MineWarInfo[roomid][mwZombieTypes][i] = _:type;

            #if defined MINEWAR_DEBUG_MODE
                printf("[MINEWAR DEBUG]: Зомби заспавнен в следующей точке: (%.04f, %.04f, %.04f, %.04f) - %.02f HP", x, y, z, a, health);
            #endif
            return _:npcid;
        }
    }
    
    return 0;
}

stock MineWar_ClearZombies(roomid)
{
    if (!MineWar_IsRoomExists(roomid)) return 0;
    
    for (new i = 0; i < MAX_MINEWAR_ZOMBIES; i++)
    {
        if (!IsValidNpc(MineWarInfo[roomid][mwZombie][i])) continue;

        DestroyNpc(MineWarInfo[roomid][mwZombie][i]);
        MineWarInfo[roomid][mwZombie][i] = NPC: 0;
        MineWarInfo[roomid][mwZombieTypes][i] = 0;
        MineWarInfo[roomid][mwZombieAttackId][i] = 0;
    }

    return 1;   
}

stock MineWar_SpawnZombies(roomid)
{
    if (!MineWar_IsRoomExists(roomid)) return 0;

    new max_spawn = sizeof(MineWarZombieSpawns);
    if (MineWarInfo[roomid][mwWave] < MINEWAR_WAVE_HARD) max_spawn = 4;

    new Float: x, Float: y, Float: z, Float: a;

    // Спавн зомби
    new nextspawn_indexes[_:MINEWAR_MAX_ZOMBIE_TYPE], nextspawn_total = 0;
    for (new i = 0; i < _:MINEWAR_MAX_ZOMBIE_TYPE; i++) {
        nextspawn_total += MineWarInfo[roomid][mwZombieNextSpawn][i];
        nextspawn_indexes[i] = nextspawn_total - 1;
    }
    
    for (new i = 0; i < nextspawn_total; i++)
    {
        new spawn_index = random(max_spawn);

        // Спавн усиленных зомби
        new e_MineWarZombieType: zombie_type = MINEWAR_NORMAL_ZOMBIE;
        if (i > nextspawn_indexes[_:MINEWAR_HEAVY_ZOMBIE]) {
            zombie_type = MINEWAR_SUPER_ZOMBIE;
        }
        else if (i > nextspawn_indexes[_:MINEWAR_NORMAL_ZOMBIE])
        {
            zombie_type = MINEWAR_HEAVY_ZOMBIE;
        }

        RandomPointInCube(
            MineWarZombieSpawns[spawn_index][mwMinX],
            MineWarZombieSpawns[spawn_index][mwMinY],
            MineWarZombieSpawns[spawn_index][mwZ],
            MineWarZombieSpawns[spawn_index][mwMaxX],
            MineWarZombieSpawns[spawn_index][mwMaxY],
            MineWarZombieSpawns[spawn_index][mwZ],

            x, y, z
        );
        a = MineWarZombieSpawns[spawn_index][mwAngle] + frand(-15.0, 15.0);

        MineWar_CreateZombie(roomid, zombie_type, x, y, z, a);
    }

    return 1;
}

// Получение общего количества зомби, которое должно заспавниться в текущей волне
stock MineWar_GetCurrentWaveZombieTotal(roomid, type = -1)
{
    if (type < -1 || type >= _:MINEWAR_MAX_ZOMBIE_TYPE) return 0;

    new count = 0;
    if (type == -1) {
        for (new i = 0; i < _:MINEWAR_MAX_ZOMBIE_TYPE; i++) {
            count += MineWarInfo[roomid][mwZombieWave][i];
        }
    } else {
        count = MineWarInfo[roomid][mwZombieWave][type];
    }
    return count;
}

// Получение количества убитых зомби в текущей волне
stock MineWar_GetCurrentWaveZombieKilled(roomid, type = -1)
{
    return MineWar_GetZombieKilled(roomid, type, .current_wave = true);
}

// Получение количества зомби, которое осталось убить до конца текущей волны
stock MineWar_GetCurrentWaveZombieRemains(roomid, type = -1)
{
    return MineWar_GetCurrentWaveZombieTotal(roomid, type) - MineWar_GetCurrentWaveZombieKilled(roomid, type);
}

// Получение отношения убитых зомби к их общему количеству для текущей волны
stock Float: MineWar_GetCurrentWaveKilledRatio(roomid)
{
    new zombie_total = MineWar_GetCurrentWaveZombieTotal(roomid);
    if (zombie_total <= 0) return 0;

    new Float: ratio = MineWar_GetCurrentWaveZombieKilled(roomid) / float(zombie_total);
    return ratio;
}

stock MineWar_UpdateNextZombies(roomid)
{
    // Определяем количество зомби, которые должны заспавниться в следующий раз
    new Float: zombie_killed_ratio = MineWar_GetCurrentWaveKilledRatio(roomid);

    #if defined MINEWAR_DEBUG_MODE
        printf("[MINEWAR DEBUG]: Количество убитых зомби для текущей волны: %d/%d (%.03f)", MineWar_GetCurrentWaveZombieKilled(roomid), MineWar_GetCurrentWaveZombieTotal(roomid), zombie_killed_ratio);
    #endif

    // Обнуление предыдущих значений
    for (new i = 0; i < _:MINEWAR_MAX_ZOMBIE_TYPE; i++) MineWarInfo[roomid][mwZombieNextSpawn][i] = 0;
    
    // Определение количества зомби каждого вида для спавна в зависимости от стадии волны
    if (zombie_killed_ratio <= 0.2) {
        MineWarInfo[roomid][mwZombieNextSpawn][_:MINEWAR_NORMAL_ZOMBIE] = floatround(MineWarInfo[roomid][mwZombieWave][_:MINEWAR_NORMAL_ZOMBIE] * 0.35);
        MineWarInfo[roomid][mwZombieNextSpawn][_:MINEWAR_HEAVY_ZOMBIE] = floatround(MineWarInfo[roomid][mwZombieWave][_:MINEWAR_HEAVY_ZOMBIE] * 0.50);
    }
    else if (zombie_killed_ratio <= 0.5) {
        MineWarInfo[roomid][mwZombieNextSpawn][_:MINEWAR_NORMAL_ZOMBIE] = floatround(MineWarInfo[roomid][mwZombieWave][_:MINEWAR_NORMAL_ZOMBIE] * 0.25);
    }
    else {
        MineWarInfo[roomid][mwZombieNextSpawn][_:MINEWAR_NORMAL_ZOMBIE] = floatround(MineWarInfo[roomid][mwZombieWave][_:MINEWAR_NORMAL_ZOMBIE] * 0.40);
        MineWarInfo[roomid][mwZombieNextSpawn][_:MINEWAR_HEAVY_ZOMBIE] = floatround(MineWarInfo[roomid][mwZombieWave][_:MINEWAR_HEAVY_ZOMBIE] * 0.50);
        MineWarInfo[roomid][mwZombieNextSpawn][_:MINEWAR_SUPER_ZOMBIE] = MineWarInfo[roomid][mwZombieWave][_:MINEWAR_SUPER_ZOMBIE];
    }

    if (zombie_killed_ratio >= 1) {
        // Если все зомби были убиты - не спавним никого
        for (new i = 0; i < _:MINEWAR_MAX_ZOMBIE_TYPE; i++) MineWarInfo[roomid][mwZombieNextSpawn][i] = 0;
    } else {
        // Если были убиты не все зомби - не спавним меньше одного обычного зомби (на всякий случай)
        if (MineWarInfo[roomid][mwZombieNextSpawn][_:MINEWAR_NORMAL_ZOMBIE] < 1) MineWarInfo[roomid][mwZombieNextSpawn][_:MINEWAR_NORMAL_ZOMBIE] = 1;
    }

    // Не спавним зомби каждого вида больше, чем положено
    for (new i = 0; i < _:MINEWAR_MAX_ZOMBIE_TYPE; i++) {
        new zombie_remains = MineWar_GetCurrentWaveZombieRemains(roomid, i);
        if (MineWarInfo[roomid][mwZombieNextSpawn][i] > zombie_remains) MineWarInfo[roomid][mwZombieNextSpawn][i] = zombie_remains;
    }

    #if defined MINEWAR_DEBUG_MODE
        printf("[MINEWAR DEBUG]: Должно быть заспавнено: %d обычных, %d усиленных и %d супер-зомби",
            MineWarInfo[roomid][mwZombieNextSpawn][_:MINEWAR_NORMAL_ZOMBIE],
            MineWarInfo[roomid][mwZombieNextSpawn][_:MINEWAR_HEAVY_ZOMBIE],
            MineWarInfo[roomid][mwZombieNextSpawn][_:MINEWAR_SUPER_ZOMBIE]
        );
    #endif
}

// Статистика после матча (Расчёт призов также тут)
stock MineWar_Dialog_Stats(playerid, e_MineWarEndReason: reason)
{
    new roomid = MineWar_GetPlayerRoom(playerid);
    if (!MineWar_IsRoomExists(roomid)) return 0;

    new dialog_text[2048];

    if (reason == MINEWAR_END_REASON_LOSE) {
        strcat(dialog_text, "{ff6347}К сожалению, вы проиграли");
        PlayerPlaySound(playerid, 1085);
    }
    else if (reason == MINEWAR_END_REASON_WIN) {
        strcat(dialog_text, "{99ff66}Поздравляем, вы одержали победу!");
        PlayerPlaySound(playerid, 1083);
    }
    strcat(dialog_text, "\n\n");

    format(dialog_text, sizeof(dialog_text),
        "%s" \
        "{ff9000}Личная статистика убийств:\n" \
        "{cccccc}- Обычных зомби уничтожено: %d\n" \
        "{cccccc}- Усиленных зомби уничтожено: %d",

        dialog_text,
        MineWar_PlayerGetZombieKilled(playerid, MINEWAR_NORMAL_ZOMBIE),
        MineWar_PlayerGetZombieKilled(playerid, MINEWAR_HEAVY_ZOMBIE)
    );
    if (MineWar_PlayerGetZombieKilled(playerid, MINEWAR_SUPER_ZOMBIE) >= 1) strcat(dialog_text, "\n{850000}- Вы уничтожили босса!");

    strcat(dialog_text, "\n\n{ff9000}Ваши призы:\n");
    
    new case_amount;
    if (reason == MINEWAR_END_REASON_WIN) {
        // Гарантированные кейсы за прохождение (+1-3)
        case_amount += random_range(1, 2);
        if (_:MineWarInfo[roomid][mwDifficulty] > _:MINEWAR_DIFFICULTY_EASY) case_amount++;
        #if defined MINEWAR_DEBUG_MODE
            printf("[MINEWAR DEBUG]: Игрок %d получил %d кейсов за прохождение", playerid, case_amount);
        #endif
    }

    if (MineWar_GetZombieKilled(roomid, _:MINEWAR_SUPER_ZOMBIE) >= 1) {
        // 40% получить кейс, если был убит босс (даже при поражении)
        if(random(10) <= 3) {
            case_amount++;
            #if defined MINEWAR_DEBUG_MODE
                printf("[MINEWAR DEBUG]: Игрок %d получил дополнительный кейс за то, что при прохождении был убит босс", playerid);
            #endif
        }
    }

    {
        // 25% получить кейс для ТОП-1 по убийствам за всю игру
        new top1_kills_id = -1, top1_kills = 0;
        for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++)
        {
            new currentid = MineWarInfo[roomid][mwPlayers][i] - 1;
            if (!IsOnline(currentid)) continue;

            new kills = MineWar_PlayerGetZombieKilled(currentid, -1);

            if (top1_kills < kills) {
                top1_kills_id = currentid;
                top1_kills = kills;
            }
        }
        if (top1_kills_id == playerid) {
            if (random(4) < 1) {
                case_amount++;

                #if defined MINEWAR_DEBUG_MODE
                    printf("[MINEWAR DEBUG]: Игрок %d получил дополнительный кейс за ТОП-1 по убийствам", playerid);
                #endif
            }
        }
    }
    case_amount += MineWarPlayerInfo[playerid][mwpCases]; // Прибавляем возможные кейсы, которые игрок мог получить на протяжении игры (за волны и т.п.)

    if (case_amount > 0) {
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
                    x = MineWarGetOutPosition[playerid][0], y = MineWarGetOutPosition[playerid][1], z = MineWarGetOutPosition[playerid][2];
                    a = MineWarGetOutPosition[playerid][3];

                    frontme(INVALID_PLAYER_ID, 0.65, x, y, z, a);

                    SetThrow(
                        playerid, thingId, thingId, thingQuan, thingPara, 0, thingType, thingPack, 0, 0,
                        x + frand(-0.4, 0.4), y + frand(-0.4, 0.4), z - 0.8,
                        0.0, 0.0, a, 600, 0, 0
                    );
                }
            }
        }

        format(dialog_text, sizeof(dialog_text),
            "%s" \
            "{cccccc}- Кейс: %d шт.",

            dialog_text,
            case_amount
        );

        if (no_place) strcat(dialog_text, "\n{ff6347}* Для одного или нескольких предметов не хватило места в инвентаре\n* Вы сможете найти их рядом с собой\n");
    } else {
        strcat(dialog_text, "{cccccc}- Отсутствуют\n");
    }

    ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, " ", dialog_text, "Закрыть", "");

    return 1;
}

stock MineWar_SetPlayerTime(playerid)
{
    SetPlayerTime(playerid, 0, 0);
    SetPlayerWeather(playerid, 4);
    
    return 1;
}

stock MineWar_OnNpcDeath(NPC:npc, killerid, reason)
{
    #pragma unused killerid
    #pragma unused reason

    for (new roomid = 0; roomid < MAX_MINEWAR_ROOMS; roomid++)
    {
        if (!MineWar_IsRoomExists(roomid)) continue;

        for (new npc_i = 0; npc_i < MAX_MINEWAR_ZOMBIES; npc_i++)
        {
            if (NPC: MineWarInfo[roomid][mwZombie][npc_i] == npc)
            {
                new zombie_type = MineWarInfo[roomid][mwZombieTypes][npc_i];
                MineWarInfo[roomid][mwZombieKilled][zombie_type]++;
                MineWarPlayerInfo[killerid][mwpZombieKilled][zombie_type]++;

                MineWarInfo[roomid][mwZombieAttackId][npc_i] = 0;
                SetTimerEx("MineWar_DestroyDeadZombie", 5 * 1000, false, "dd", roomid, npc_i);

                MineWar_UpdateZombieRemainsTextdraw(roomid);

                new zombies = MineWar_GetZombieCount(roomid, .alive = true);
                if (zombies <= 0)
                {
                    MineWar_UpdateNextZombies(roomid);
                    MineWar_SpawnZombies(roomid);
                    
                    // Если уничтожили последнего зомби в текущей волне
                    if (MineWar_GetCurrentWaveZombieRemains(roomid) <= 0)
                    {
                        // Если уничтожили последнего оставшегося зомби во всей игре
                        if (MineWarInfo[roomid][mwWave] == MINEWAR_WAVE_IMPOSSIBLE)
                        {
                            MineWar_End(roomid, MINEWAR_END_REASON_WIN);

                            #if defined MINEWAR_DEBUG_MODE
                                printf("[MINEWAR DEBUG]: Конец, все зомби уничтожены");
                            #endif
                        } else if (MineWarInfo[roomid][mwWave] != MINEWAR_WAVE_IMPOSSIBLE) {
                            for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++) {
                                new currentid = MineWarInfo[roomid][mwPlayers][i] - 1;
                                if (!IsOnline(currentid)) continue;

                                SendClientMessage(currentid, 0x1E6698FF, "[ Шахта ]: {FFCC66}Текущая волна завершена, подготовьтесь к началу следующей!");

                                // Воскрешаем мертвых игроков
                                for (new j = 0; j < MAX_MINEWAR_PLAYERS; j++)
                                {
                                    new deadid = MineWarInfo[roomid][mwPlayers][j] - 1;
                                    if (!IsOnline(deadid)) continue;
                                    if (!MineWarPlayerInfo[deadid][mwpDead]) continue;

                                    MineWar_StopSpectate(deadid, .lastposition = true);
                                    MineWarPlayerInfo[deadid][mwpDead] = false;
                                    ACSetPlayerHealth(deadid, GetMaxPlayerHealth(deadid));
                                }

                                MineWar_GivePlayerWaveLoot(currentid);
                            }
                            
                            {
                                new top1_wave_kills_id = -1, top1_wave_kills = -1;
                                for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++) {
                                    new currentid = MineWarInfo[roomid][mwPlayers][i] - 1;
                                    if (!IsOnline(currentid)) continue;

                                    if (top1_wave_kills_id >= -1) {
                                        new kills = MineWar_PlayerGetZombieKilled(currentid, -1, .current_wave = true);
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
                                    // 10% получить кейс для ТОП-1 по убийствам на протяжении волны
                                    if (random(10) < 1) {
                                        MineWarPlayerInfo[top1_wave_kills_id][mwpCases]++;
                                        #if defined MINEWAR_DEBUG_MODE
                                            printf("[MINEWAR DEBUG]: Игрок %d получил кейс за ТОП-1 по убийствам после окончания волны", top1_wave_kills_id);
                                        #endif
                                    }
                                }
                            }

                            MineWar_SetWave(roomid, _:MineWarInfo[roomid][mwWave] + 1, .cooldown = MINEWAR_WAVE_COOLDOWN);

                            #if defined MINEWAR_DEBUG_MODE
                                printf("[MINEWAR DEBUG]: Изменение волны: %d", MineWarInfo[roomid][mwWave]);
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

stock MineWar_IsTeammates(firstid, secondid)
{
    return MineWar_IsPlayerInGame(firstid) && MineWar_GetPlayerRoom(firstid) == MineWar_GetPlayerRoom(secondid);
}

stock MineWar_GetPlayerRoom(playerid)
{
    if (!MineWarPlayerInfo[playerid][mwpPlay]) return -1;

    return MineWarPlayerInfo[playerid][mwpRoomID];
}

stock MineWar_OnPlayerGiveDamageNpc(NPC:npc, damagerid, Float: amount, weaponid, bodypart)
{
    #pragma unused npc
    #pragma unused damagerid
    #pragma unused amount
    #pragma unused weaponid
    #pragma unused bodypart

    /*new roomid = MineWar_GetPlayerRoom(damagerid);
    if (MineWar_IsRoomExists(roomid))
    {
        
    }*/
    return 1;
}

stock MineWar_OnPlayerDeath(issuerid)
{
    new roomid = MineWar_GetPlayerRoom(issuerid);
    if (!MineWar_IsRoomExists(roomid)) return 0;
    if (MineWarPlayerInfo[issuerid][mwpDead]) return 0;

    MineWarPlayerInfo[issuerid][mwpDead] = true;

    for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++)
    {
        new currentid = MineWarInfo[roomid][mwPlayers][i] - 1;
        if (!IsOnline(currentid)) continue;

        SendClientMessage(currentid, 0x1E6698FF, "[ Шахта ]: {FFCC66}Союзник %s погиб!", PlayerInfo[issuerid][pName]);
    }

    // Если все игроки умерли - завершаем игру
    if (MineWar_GetPlayersCount(roomid, .alive = true) <= 0)
    {
        MineWar_End(roomid, MINEWAR_END_REASON_LOSE);
    } else {
        // Если живые ещё остались:
        // Направляем зомби на другого ближайшего к себе участника
        for (new i = 0; i < MAX_MINEWAR_ZOMBIES; i++)
        {
            new NPC: npcid = MineWarInfo[roomid][mwZombie][i];
            if (!IsValidNpc(npcid)) continue;

            new attackid = MineWar_GetNearestPlayerFromZombie(roomid, npcid, .excludeid = issuerid);
            if (IsOnline(attackid)) MineWar_ZombieSetAttack(roomid, npcid, attackid);
        }

        // Переключаем наблюдение игрокам, которые за ним наблюдали
        for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++)
        {
            new currentid = MineWarInfo[roomid][mwPlayers][i] - 1;
            if (!IsOnline(currentid)) continue;
            
            if (MineWar_GetSpectateID(currentid) == issuerid) {
                MineWar_SwitchPlayerSpectate(currentid);
            }
        }

        // Кидаем самого человека в наблюдение
        MineWar_SwitchPlayerSpectate(issuerid);
    }

    return 1;
}

stock MineWar_OnPlayerTakeDamageNpc(NPC:npc, issuerid, Float:amount, weaponid, bodypart)
{
    #pragma unused amount
    #pragma unused weaponid
    #pragma unused bodypart
    
    new roomid = MineWar_GetPlayerRoom(issuerid);
    if (MineWar_IsRoomExists(roomid))
    {
        for (new npc_i = 0; npc_i < MAX_MINEWAR_ZOMBIES; npc_i++) {
            if (MineWarInfo[roomid][mwZombie][npc_i] == npc)
            {
                new Float: damage = MineWarInfo[roomid][mwZombieDamage];
                new type = MineWarInfo[roomid][mwZombieTypes][npc_i];
                switch (e_MineWarZombieType: type)
                {
                    case MINEWAR_HEAVY_ZOMBIE: damage *= 1.4;
                    case MINEWAR_SUPER_ZOMBIE: damage *= 1.75;
                    default: {}
                }

                new Float: health = HealthAC[issuerid] - damage;
                if (health <= 0.0)
                {
                    health = 1.0;
                    MineWar_OnPlayerDeath(issuerid);
                }

                // Устанавливаем HP игроку
                ACSetPlayerHealth(issuerid, health);
                
                return 0;
            }
        }
    }

    return 1;
}

stock MineWar_IsPlayerSpectate(playerid)
{
    return MineWarPlayerInfo[playerid][mwpSpectateID] > 0;
}

stock MineWar_SetPlayerSpectate(playerid, spectateid)
{
    if (!MineWar_IsPlayerInGame(playerid) || !MineWar_IsPlayerInGame(spectateid)) return 0;
    if (MineWarPlayerInfo[playerid][mwpSpectateID] - 1 == spectateid) return 0;

    #if defined MINEWAR_DEBUG_MODE
        printf("[MINEWAR DEBUG]: Игрок %d наблюдает за игроком %d", playerid, spectateid);
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

    MineWarPlayerInfo[playerid][mwpSpectateID] = spectateid + 1;
    StartSpectate(playerid, spectateid, 0);
    PlayerSpectatePlayer(playerid, spectateid);

    return 1;
}

stock MineWar_StopSpectate(playerid, bool: lastposition = false)
{
    if (!MineWar_IsPlayerSpectate(playerid) || GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) return 0;

    if (lastposition) StopSpectate(playerid);
    else {
        SetPosa[playerid] = 0;
        gSpectateID[playerid] = INVALID_PLAYER_ID, gSpectateType[playerid] = ADMIN_SPEC_TYPE_NONE;
        PPTogglePlayerSpectating(playerid, false);
    }
    MineWarPlayerInfo[playerid][mwpSpectateID] = 0;

    return 1;
}

stock MineWar_GetSpectateID(playerid)
{
    return MineWarPlayerInfo[playerid][mwpSpectateID] - 1;
}

stock MineWar_SwitchPlayerSpectate(playerid, bool: next = true)
{
    if (!MineWar_IsPlayerInGame(playerid)) return 0;

    new players_in_game[MAX_MINEWAR_PLAYERS];
    new index = 0, spectate_index = -1;
    foreach (new id : Player)
    {
        new roomid = MineWar_GetPlayerRoom(id);
        if (roomid != MineWarPlayerInfo[playerid][mwpRoomID]) continue;
        if (id == playerid) continue;
        if (MineWarPlayerInfo[id][mwpDead]) continue;

        players_in_game[index] = id;
        if (id == MineWar_GetSpectateID(playerid)) spectate_index = index;
        index++;
    }
    if (index == 0) return 0;
    else if (spectate_index == -1) return MineWar_SetPlayerSpectate(playerid, players_in_game[0]);

    index--;
    if (next) {
        if (spectate_index < index) MineWar_SetPlayerSpectate(playerid, players_in_game[spectate_index + 1]);
        else MineWar_SetPlayerSpectate(playerid, players_in_game[0]);
    } else {
        if (spectate_index > 0) MineWar_SetPlayerSpectate(playerid, players_in_game[spectate_index - 1]);
        else MineWar_SetPlayerSpectate(playerid, players_in_game[index]);
    }

    return 1;
}

stock MineWar_GivePlayerWaveLoot(playerid)
{
    new roomid = MineWar_GetPlayerRoom(playerid);
    if (!MineWar_IsRoomExists(roomid)) return 0;

    new gived_resources_line[128];

    // Выдача патрон
    for (new i = 27; i <= 30; i++) {
        new slot = 3 + (i-27);

        new spentAmmo = MineWarPlayerInfo[playerid][mwpSpentAmmo][i - 27];
        
        // Если выдаем 11,43mm и пистолета-пулемета в руках нет, но есть пистолет - выдаем патроны для него
        if (i == 28 && ProtectInfo[playerid][prAmmo][4] < 1 && ProtectInfo[playerid][prAmmo][2] >= 1) slot = 2;

        if (spentAmmo <= 0) continue; // Если игрок не использовал это оружие - не выдаём патроны

        new maxAmmo = 100 * get_power(playerid);
        new currentAmmo = get_invent(playerid, i, 0) + ProtectInfo[playerid][prAmmo][slot];
        
        new ammo = floatround(float(spentAmmo) * 0.7);

        if (currentAmmo + ammo > maxAmmo) ammo = max(maxAmmo - currentAmmo, 0);
        Protect_GiveWeapons(playerid, ProtectInfo[playerid][prWeapon][slot], ammo, 0, 0);

        if (ammo > 0) format(gived_resources_line, sizeof(gived_resources_line), "%s%s (%d шт.), ", gived_resources_line, GetNameThing(0, i, 0, 0), ammo);

        #if defined MINEWAR_DEBUG_MODE
            printf("[MINEWAR DEBUG]: Игрок %d получил %d патрон (Слот оружия: %d)", playerid, ammo, slot);
        #endif

        SetPlayerArmedWeapon(playerid, WEAPON_FIST);
    }

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
    #if defined MINEWAR_DEBUG_MODE
        printf("[MINEWAR DEBUG]: Игрок %d получил %d бинтов", playerid, quan);
    #endif

    if (!isnull(gived_resources_line)) {
        gived_resources_line[strlen(gived_resources_line) - 2] = EOS;
        SendClientMessage(playerid, 0x1E6698FF, "[ Шахта ]: {FFCC66}Ваши ресурсы были пополнены: %s", gived_resources_line);
    }

    return 1;
}

stock MineWar_AddMember(roomid, playerid)
{
    if (!MineWar_IsRoomExists(roomid)) return 0;

    for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++)
    {
        if (!MineWarInfo[roomid][mwPlayers][i])
        {
            MineWarInfo[roomid][mwPlayers][i] = playerid + 1;
            MineWar_LoadTextdraws(playerid);
            return 1;
        }
    }

    return 0;
}

stock MineWar_IsPlayerInGame(playerid)
{
    return MineWar_IsRoomExists(MineWar_GetPlayerRoom(playerid));
}

stock MineWar_Enter(playerid)
{
    keep(playerid);
    PPSetPlayerPos(playerid, -25.3980, 1175.2297, 1310.8254);
    PPSetPlayerFacingAngle(playerid, 180.0);
    S_SetPlayerVirtualWorld(playerid, MineWar_GetVirtualWorld(MineWar_GetPlayerRoom(playerid)), 1);
    PPSetPlayerInterior(playerid, 1);
    SetCameraBehindPlayer(playerid);

    return 1;
}

stock MineWar_Exit(playerid)
{
    PPSetPlayerPos(playerid, 2335.0696,-652.3331,130.1445);
    PPSetPlayerFacingAngle(playerid, -90.0);
    S_SetPlayerVirtualWorld(playerid, 0);
    PPSetPlayerInterior(playerid, 0);
    SetCameraBehindPlayer(playerid);

    return 1;
}

stock MineWar_Dialog_Exit(playerid)
{
    ShowDialog(playerid, MINEWAR_DIALOG_EXIT, DIALOG_STYLE_MSGBOX, "{ff6347}Подтверждение выхода",
        "{ff6347}Вы уверены что хотите покинуть шахту?\n\nИгра для вас будет автоматически завершена",

        "Да", "Закрыть"
    );
    return 1;
}

stock MineWar_DeleteMember(playerid)
{
    new roomid = MineWar_GetPlayerRoom(playerid);
    if (!MineWar_IsRoomExists(roomid)) return 0;

    MineWar_PlayerInfo_Cleanup(playerid);

    // Удаление текстдравов
    PlayerTextDrawDestroy(playerid, ObstacleTimeTD[playerid]);
    for (new i = 0; i < sizeof(MineWarZombieRemainsTD[]); i++) PlayerTextDrawDestroy(playerid, MineWarZombieRemainsTD[playerid][i]);

    for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++)
    {
        if (MineWarInfo[roomid][mwPlayers][i] - 1 == playerid)
        {
            MineWarInfo[roomid][mwPlayers][i] = 0;

            // Если кто-то наблюдал за этим человеком - переключаем на следующего
            for (new j = 0; j < MAX_MINEWAR_PLAYERS; j++) {
                new currentid = MineWarInfo[roomid][mwPlayers][j] - 1;
                if (!IsOnline(currentid)) continue;

                if (MineWar_GetSpectateID(currentid) == playerid) {
                    MineWar_SwitchPlayerSpectate(currentid);
                }
            }

            // Направляем всех зомби на ближайшую цель, если они гнались за этим игроком
            for (new j = 0; j < MAX_MINEWAR_ZOMBIES; j++)
            {
                new NPC: npcid = MineWarInfo[roomid][mwZombie][j];
                if (!IsValidNpc(npcid)) continue;

                new attackid = MineWar_GetNearestPlayerFromZombie(roomid, npcid);
                if (IsOnline(attackid)) MineWar_ZombieSetAttack(roomid, npcid, attackid);
            }

            if (MineWar_GetPlayersCount(roomid, .alive = true) <= 0)
            {
                MineWar_End(roomid, MINEWAR_END_REASON_LOSE);

                #if defined MINEWAR_DEBUG_MODE
                    printf("[MINEWAR DEBUG]: Комната %d удалена [Ни одного участника в живых]", roomid);
                #endif
            }
            
            return 1;
        }
    }

    return 0;
}

stock MineWar_IsRoomExists(roomid)
{
    if (roomid < 0 || roomid >= MAX_MINEWAR_ROOMS) return 0;
    return MineWarInfo[roomid][mwPlay];
}

stock MineWar_Start(playerid)
{
    if (MineWarPlayerInfo[playerid][mwpPlay]) return 1;

    new roomid = MineWar_CreateRoom(playerid);
    if (roomid < 0) return ErrorMessage(playerid, "{ff6347}Сейчас начать игру нельзя [Нет свободной комнаты]");

    MineWar_Create_AddMember(playerid, playerid); // Хост всегда участник
    for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++)
    {
        new currentid = MineWarPlayerInfo[playerid][mwpPlayers][i] - 1;
        if (!IsOnline(currentid)) continue;

        if (!MineWar_IsPlayerInside(currentid)) {
            MineWar_DeleteRoom(roomid);
            MineWar_Create_DeleteMember(playerid, playerid);
            return ErrorMessage(playerid, "{FF6347}Все участники команды должны находиться в шахте перед началом игры");
        }
        
        MineWarPlayerInfo[currentid][mwpPlay] = true;
        MineWarPlayerInfo[currentid][mwpRoomID] = roomid;
        MineWar_Create_DeleteMember(playerid, currentid);
        MineWar_AddMember(roomid, currentid);
        SetPlayerVirtualWorld(currentid, MineWar_GetVirtualWorld(roomid));
        PlayerPlaySound(playerid, 3201);
    }

    MineWarInfo[roomid][mwDifficulty] = MineWarPlayerInfo[playerid][mwpDifficulty];
    MineWar_SetWave(roomid, MINEWAR_WAVE_EASY); 

    return 1;
}

stock MineWar_GetVirtualWorld(roomid)
{
    if (!MineWar_IsRoomExists(roomid)) return 1;
    return MineWarInfo[roomid][mwOwner] + 2;
}

stock MineWar_GetOutPosition(&Float: x, &Float: y, &Float: z, &Float: a)
{
    x = 2373.6345 + frand(-3.0, 3.0); y = -651.1652 + frand(-3.0, 3.0); z = 127.4785;
    a = 270.0;

    return 1;
}

stock MineWar_GetOutPlayer(playerid)
{
    S_SetPlayerVirtualWorld(playerid, 0, 0), PPSetPlayerInterior(playerid, 0);
    PPSetPlayerPos(playerid, MineWarGetOutPosition[playerid][0], MineWarGetOutPosition[playerid][1], MineWarGetOutPosition[playerid][2]);
    PPSetPlayerFacingAngle(playerid, MineWarGetOutPosition[playerid][3]);
    ClearAnimations(playerid, FORCE_SYNC: 1);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, true);
    return 1;
}

stock MineWar_End(roomid, e_MineWarEndReason: reason)
{
    if (!MineWar_IsRoomExists(roomid)) return 0;
    
    for (new j = 0; j < 2; j++) {
        for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++) {
            new currentid = MineWarInfo[roomid][mwPlayers][i] - 1;
            if (!IsOnline(currentid)) continue;

            if (j == 0) {
                // Сначала выкидываем игроков на улицу и отображаем всем диалог о результатах игры (чтобы иметь доступ к статистике)
                SetPVarInt(currentid, "MineWarSpawn", 1);
                MineWar_GetOutPosition(
                    MineWarGetOutPosition[currentid][0], MineWarGetOutPosition[currentid][1], MineWarGetOutPosition[currentid][2],
                    MineWarGetOutPosition[currentid][3]
                );
                ACSetPlayerHealth(currentid, 1.0);
                if (!MineWar_StopSpectate(currentid)) PPSpawnPlayer(currentid);
                MineWar_Dialog_Stats(currentid, reason);
            } else {
                // Потом удаляем ненужные данные и прочее
                MineWar_PlayerInfo_Cleanup(currentid);
                PlayerTextDrawDestroy(currentid, ObstacleTimeTD[currentid]);
                for (new td_i = 0; td_i < sizeof(MineWarZombieRemainsTD[]); td_i++) PlayerTextDrawDestroy(currentid, MineWarZombieRemainsTD[currentid][td_i]);

                PlayerInfo[currentid][pLastMineWar] = gettime();
                MineWar_Save(currentid);
            }
        }
    }

    return MineWar_DeleteRoom(roomid);
}

stock MineWar_UpdateTimer(playerid) {
    new roomid = MineWar_GetPlayerRoom(playerid);
    if (MineWar_IsRoomExists(roomid))
    {
        new cooldown = MineWarInfo[roomid][mwWaveCooldown];
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

stock MineWar_Dialog_Start(playerid)
{
    new elapsed_time = MineWar_GetElapsedTime(playerid);
    if (elapsed_time > 0) {
        new message[128];
        format(message, sizeof(message), "{FF6347}Вы не можете играть в заброшенной шахте так часто [Можно через: %s]", fine_time(elapsed_time));
        return ErrorMessage(playerid, message);
    }
    return ShowDialog(playerid, MINEWAR_START_ACCEPT, DIALOG_STYLE_MSGBOX, "{ff9000}Заброшенная шахта", "{99ff66}Вы действительно хотите начать?\n\n{cccccc}* Все участники должны находиться внутри шахты", "Начать", "Назад");
}

stock MineWar_Create_GetPlayersCount(playerid)
{
    new count = 0;
    for (new i = 0; i < MAX_MINEWAR_PLAYERS; i++)
    {
        if (!MineWarPlayerInfo[playerid][mwpPlayers][i]) continue;

        count++;
    }
    return count + 1; // Учитываем хоста, который добавится в команду в самом конце
}

stock MineWar_Dialog_AddMember(playerid)
{
    if (MineWar_Create_GetPlayersCount(playerid) >= MAX_MINEWAR_PLAYERS) {
        ErrorText(playerid, "{ff6347}Количество участников не может превышать "#MAX_MINEWAR_PLAYERS" человек");
        return MineWar_Dialog_Team(playerid);
    }

    new dialog_text[128] = "{cccccc}Введите никнейм или ID участника:";
    if (GetPVarInt(playerid, "MineWarNoPlayer")) {
        strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}Игрок не находится в заброшенной шахте");
        DeletePVar(playerid, "MineWarNoPlayer");
    }

    return ShowDialog(playerid, MINEWAR_DIALOG_ADDMEMBER, DIALOG_STYLE_INPUT, "{ff9000}Заброшенная шахта", dialog_text, "Добавить", "Назад");
}

stock MineWar_PlayerInfo_Cleanup(playerid)
{
    for (new e_MineWarPlayerInfo: i; i < e_MineWarPlayerInfo; i++) MineWarPlayerInfo[playerid][i] = 0;

    return 1;
}

stock MineWar_OnKeyStateChange(playerid, KEY: newkeys, KEY: oldkeys)
{
    #pragma unused oldkeys

    if (!MineWar_IsPlayerInGame(playerid)) return 0;

    if (MineWar_IsPlayerSpectate(playerid)) {
        if (newkeys & KEY_FIRE) MineWar_SwitchPlayerSpectate(playerid, .next = true);
        else if (newkeys & KEY_HANDBRAKE) MineWar_SwitchPlayerSpectate(playerid, .next = false);
    }

    return 1;
}

stock MineWar_OnPlayerDisconnect(playerid)
{
    new roomid = MineWar_GetPlayerRoom(playerid);
    if (MineWar_IsRoomExists(roomid))
    {
        MineWar_DeleteMember(playerid);
    }

    MineWar_Save(playerid);
    MineWar_PlayerInfo_Cleanup(playerid);
    foreach (new currentid : Player) MineWar_Create_DeleteMember(currentid, playerid);

    return 1;
}

stock MineWar_IsPlayerInside(playerid)
{
    return IsPlayerInDynamicArea(playerid, MineWarZone);
}

stock MineWar_SendInvite(playerid, inviteid)
{
    DP[0][inviteid] = playerid;

    new dialog_text[256];

    format(dialog_text, sizeof(dialog_text),
        "{cccccc}Игрок %s[%d] приглашает вас в свою команду\n\n{99ff66}Вы согласны присоединиться?",

        playername(playerid), playerid  
    );
    ShowDialog(inviteid, MINEWAR_DIALOG_INVITE, DIALOG_STYLE_MSGBOX, "{ff9000}Заброшенная шахта", dialog_text, "Принять", "Закрыть");

    return 1;
}

stock MineWar_Create_IsPlayerMember(playerid, inviterid = -1)
{
    new minid = inviterid == -1 ? 0 : inviterid;
    new maxid = inviterid == -1 ? MAX_REALPLAYERS : inviterid + 1;
    
    for (new i = minid; i < maxid; i++)
    {
        for (new j = 0; j < MAX_MINEWAR_PLAYERS; j++) {
            if (MineWarPlayerInfo[i][mwpPlayers][j] - 1 == playerid) {
                return true;
            }
        }
    }

    return false;
}

stock dialogCase_MineWar(playerid, dialogid, response, listitem, const inputtext[])
{
    switch (e_DialogId: dialogid)
    {
        case MINEWAR_DIALOG_MAIN:
        {
            if (!response) return 1;

            switch(listitem)
            {
                case 0: return MineWar_Dialog_About(playerid);
                case 1: return MineWar_Dialog_Rules(playerid);
                case 2: {
                    MineWarPlayerInfo[playerid][mwpDifficulty] = e_MineWarDifficulty:((_:MineWarPlayerInfo[playerid][mwpDifficulty] + 1) % _:MINEWAR_MAX_DIFFICULTY);
                    return MineWar_Dialog_Main(playerid);
                }
                case 3: return MineWar_Dialog_Team(playerid);
                case 4: return MineWar_Dialog_Start(playerid);
            }
        }
        case MINEWAR_DIALOG_TEAM:
        {
            if (!response) return MineWar_Dialog_Main(playerid);

            if (listitem == 0) return MineWar_Dialog_AddMember(playerid);

            new currentid = List[listitem][playerid];
            MineWar_Create_DeleteMember(playerid, currentid);
            return MineWar_Dialog_Team(playerid);
        }
        case MINEWAR_DIALOG_ADDMEMBER:
        {
            if (!response) return MineWar_Dialog_Team(playerid);
            new currentid;
            if (sscanf(inputtext, "u", currentid) || !IsOnline(currentid) || !MineWar_IsPlayerInside(currentid)) {
                SetPVarInt(playerid, "MineWarNoPlayer", 1);
                return MineWar_Dialog_AddMember(playerid);
            }
            if (currentid == playerid) return ErrorMessage(playerid, "{ff6347}Вы будете автоматически считаться участником при запуске игры");
            if (!IsPlayerHaveLauncher(currentid)) return ErrorMessage(playerid, "{ff6347}Этот игрок не может быть добавлен, так как играет без лаунчера");
            if (MineWar_GetElapsedTime(currentid) > 0) return ErrorMessage(playerid, "{ff6347}Этот игрок не может быть добавлен, так как принимал участие в игре совсем недавно");
            if (MineWar_Create_IsPlayerMember(currentid)) return ErrorMessage(playerid, "{ff6347}Этот игрок уже состоит в чей-то команде");
            if (MineWar_Create_GetPlayersCount(playerid) >= MAX_MINEWAR_PLAYERS) return ErrorMessage(playerid, "{ff6347}Количество участников не может превышать "#MAX_MINEWAR_PLAYERS" человек");
            
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я пригласил %s в свою команду", playername(currentid));
            MineWar_SendInvite(playerid, currentid);

            return MineWar_Dialog_AddMember(playerid);
        }
        case MINEWAR_DIALOG_ABOUT:
        {
            return MineWar_Dialog_Main(playerid);
        }
        case MINEWAR_DIALOG_INVITE:
        {
            new inviterid = DP[0][playerid];

            if (!response) {
                SendClientMessage(inviterid, COLOR_GREY, "[ Мысли ]: %s отказался быть участником моей команды", playername(playerid));
                return 1;
            }

            if (!IsOnline(inviterid)) return ErrorMessage(playerid, "{FF6347}Пригласивший вас игрок вышел из игры");
            if (MineWar_GetElapsedTime(playerid) > 0) return ErrorMessage(playerid, "{FF6347}Ближайшее время вы не сможете принимать участие в игре");
            if (!MineWar_IsPlayerInside(inviterid)) return ErrorMessage(playerid, "{FF6347}Пригласивший вас игрок не находится в заброшенной шахте");
            if (MineWar_IsPlayerInGame(inviterid)) return ErrorMessage(playerid, "{FF6347}Пригласивший вас игрок уже находится в игре");
            if (MineWar_Create_IsPlayerMember(playerid)) return ErrorMessage(playerid, "{FF6347}Вы уже находитесь в чей-то команде");
            if (MineWar_Create_GetPlayersCount(inviterid) >= MAX_MINEWAR_PLAYERS) return ErrorMessage(playerid, "{FF6347}Максимальное количество участников превышено ["#MAX_MINEWAR_PLAYERS" человек]");
            
            MineWar_Create_AddMember(inviterid, playerid);
            SendClientMessage(inviterid, COLOR_GREY, "[ Мысли ]: %s согласился быть участником моей команды", playername(playerid));
            return SuccessMessage(playerid, "{99ff66}Вы согласились быть участником команды\n\nТеперь вам необходимо дождаться запуска игры");
        }
        case MINEWAR_START_ACCEPT:
        {
            if (!response) return MineWar_Dialog_Main(playerid);
            if (!MineWar_IsPlayerInside(playerid)) return ErrorMessage(playerid, "{FF6347}Нужно находиться внутри заброшенной шахты");
            if (server != 0 && MineWar_Create_GetPlayersCount(playerid) < MIN_MINEWAR_PLAYERS) return ErrorMessage(playerid, "{FF6347}Минимальное количество игроков для участия: "#MIN_MINEWAR_PLAYERS);
            if (MineWar_IsPlayerInGame(playerid)) return ErrorMessage(playerid, "{FF6347}Игра уже началась");
            
            return MineWar_Start(playerid);
        }
        case MINEWAR_DIALOG_QUEST: {
            if (!response) return pc_cmd_quest(playerid);
            
            CreateGps(playerid, 2373.6345, -651.1652, 127.4785, 0, 0, 2.0);
            SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ {ffffff}Карта {0088ff}]{ffffff}: {0088ff}Заброшенная Шахта {ffffff}отмечена на карте");
        }
        case MINEWAR_DIALOG_EXIT:
        {
            if (!response) return 1;

            MineWar_DeleteMember(playerid);
            MineWar_Exit(playerid);
            PlayerPlaySound(playerid, 17001);

            PlayerInfo[playerid][pLastMineWar] = gettime();
            MineWar_Save(playerid);
        }
    }
    return 1;
}
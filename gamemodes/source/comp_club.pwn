#define COMPUTER_CLUB_GAMES_AMOUNT 1 // Количество существующих игр
#define COMPUTER_CLUB_MAX_ROOMS 500 // Максимальное количество комнат для одной игры
#define COMPUTER_CLUB_LOCATIONS_AMOUNT 3 // Количество существующих локаций (все игры вместе)
#define COMPUTER_CLUB_MAX_GAME_LOCATIONS 10 // Максимальное количество локаций у одной игры
#define COMPUTER_CLUB_MAX_LOCATION_SPAWNS 5 // Максимальное количество точек спавна на локации

#define COMPUTER_CLUB_MAX_TEAMS 2 // Максимальное количество команд (Создано только для удобства, поддержки 3+ команд нет)

enum e_ComputerClubGames {
    COMPUTER_GAME_TDM, // TDM
    COMPUTER_GAME_COPCHASE, // CopChase - погоня
    COMPUTER_GAME_CARGORAIDS // CargoRaids - перехват груза
};

enum e_ComputerClubDisconnectReasons {
    COMPUTER_CLUB_D_REASON_SELF,
    COMPUTER_CLUB_D_REASON_KICKED,
    COMPUTER_CLUB_D_REASON_BANNED,
    COMPUTER_CLUB_D_REASON_NO_BET // Нет суммы для ставки
};

enum e_ComputerClubWeaponSlotes {
    COMPUTER_CLUB_WS_COLD, // Холодное оружие
    COMPUTER_CLUB_WS_PISTOL, // Пистолеты
    COMPUTER_CLUB_WS_SHOTGUN, // Дробовики
    COMPUTER_CLUB_WS_SUBMACHINE, // Пистолет-пулемет
    COMPUTER_CLUB_WS_ASSAULT, // Штурмовые винтовки
    COMPUTER_CLUB_WS_SNIPER, // Снайперские винтовки
    COMPUTER_CLUB_WS_HEAVY, // Тяжелые оружия
    COMPUTER_CLUB_WS_GRENADE, // Гранаты
};

enum e_ComputerClubLocationInfo {
    ccliName[64], // Название
    ccliWorld, ccliInterior // Виртуальный мир, интерьер
};
new computerClubLocationInfo[COMPUTER_CLUB_LOCATIONS_AMOUNT][e_ComputerClubLocationInfo] = {
    {"TDM Локация 1"},
    {"TDM Локация 2"},
    {"Тестовая локация"}
};

// Информация о спавнах для каждой локации (порядок тот же, что и у локаций)
enum e_ComputerClubLocationSpawnInfo {
    Float: cclsPos[4], // X, Y, Z, A
    cclsTeam, // Команда: 0 - любая / 1 и выше - ccpiTeam + 1
}
new computerClubLocationSpawn[COMPUTER_CLUB_LOCATIONS_AMOUNT][COMPUTER_CLUB_MAX_LOCATION_SPAWNS][e_ComputerClubLocationSpawnInfo] = {
    // TDM Локация 1
    {
        { {1840.1737, -2493.8921, 13.5547, 90.0}, 1}, // 1 команда
        { {1792.8868, -2493.9136, 13.5547, -90.0}, 2}, // 2 команда
        {},
        {},
        {}
    },
    // TDM Локация 2
    {
        { {1158.5895, -2037.0967, 69.0078, -90.0}, 1}, // 1 команда
        { {1193.9482, -2037.1539, 69.0078, 90.0}, 2}, // 2 команда
        {},
        {},
        {}
    },
    {
        {},
        {},
        {},
        {},
        {}
    }
};

enum e_ComputerClubGameInfo {
    ccgiName[64], // Название
    ccgiLocations[COMPUTER_CLUB_MAX_GAME_LOCATIONS] // Доступные этой игре локации
};
new computerClubGameInfo[COMPUTER_CLUB_GAMES_AMOUNT][e_ComputerClubGameInfo] = {
    {"TDM", {0, 1}}
    //{"CopChase", {2}},
    //{"CargoRaids", {2}}
};

enum e_ComputerClubPlayerInfo {
    bool: ccpiInGame, // Находится в игре
    e_ComputerClubGames: ccpiID, // ID запущенной игры
    ccpiRoom, // ID комнаты
    ccpiTeam, // Номер команды
    bool: ccpiIsDead, // Мертв ли
    Float: ccpiConnectPos[4], // Позиция перед коннектом в игру
    ccpiConnectWorld, ccpiConnectInterior, // Виртуальный мир и интерьер перед коннектом в игру
};
new computerClubPlayerInfo[MAX_PLAYERS][e_ComputerClubPlayerInfo];

enum e_ComputerClubRoomInfo {
    // ----- Global Settings -----
    ccriHostID, // ID аккаунта хоста
    ccriHostNickname[MAX_PLAYER_NAME + 1], // Никнейм хоста (записывается единожды при создании комнаты)
    ccriName[25], // Название комнаты
    ccriSlotes, // Количество слотов
    ccriPassword[64], // Пароль (для частной сессии)
    bool: ccriClosed, // Закрыта ли комната
    bool: ccriStarted, // Активна ли игра
    ccriLocation, // Индекс текущей локации
    ccriRound, // Текущий раунд
    ccriMaxRounds, // Максимальное количество раундов
    ccriBet, // Размер ставки (для некоторых режимов)
    ccriTotalBet, // Сколько денег находятся в "банке" и будут выплачены победителям
    Float: ccriMaxHealth, // Максимальное HP (1 - 160)
    Float: ccriMaxArmor, // Максимальная броня (1 - 100)
    ccriTeamSize, // Размер команд
    ccriTeamScores[COMPUTER_CLUB_MAX_TEAMS], // Количество выигранных раундов каждой команды
    ccriHostDisconnectTimer, // Таймер для отключения комнаты при отсутствии хоста
    ccriWeapons[8], // Выбранное оружие под каждый слот
    ccriWeaponsAmmo[8], // Количество патрон под каждый слот оружия
    bool: ccriViewAccess, // Разрешение на просмотр
    ccriBannedPlayers[MAX_PLAYERS], // Заблокированные игроки [id аккаунтов]
    // ----- TDM Settings -----
    ccriTDMFirstTeamScore, // Количество выигранных раундов первой команды
    ccriTDMSecondTeamScore, // Количество выигранных раундов второй команды
    bool: ccriTDMShootMode, // Режим: Обычная стрельба / +C
    // ----- CopChase Settings -----

    // ----- CargoRaids Settings -----

};
new computerClubRoomInfo[COMPUTER_CLUB_GAMES_AMOUNT][COMPUTER_CLUB_MAX_ROOMS][e_ComputerClubRoomInfo];
new computerClubTeamInfo[COMPUTER_CLUB_GAMES_AMOUNT][COMPUTER_CLUB_MAX_ROOMS][COMPUTER_CLUB_MAX_TEAMS][64]; // Названия команд

enum e_ComputerClubToggleRoomReasons {
    COMPUTER_CLUB_ROOM_END, // Обычное завершение игры
    COMPUTER_CLUB_ROOM_HOST, // Завершение игры хостом
    COMPUTER_CLUB_ROOM_EXIT, // Завершение игры, если остались участники только одной команды
};

// Получает игру, в которой находится игрок
stock GetPlayerActiveComputerGame(playerid) {
    if (!computerClubPlayerInfo[playerid][ccpiInGame])
        return -1;

    return computerClubPlayerInfo[playerid][ccpiID];
}

// Проверяет комнату на существование
stock ComputerClubIsRoomExists(gameid, roomid) {
    if (gameid < 0 || roomid < 0) return 0;
    return computerClubRoomInfo[gameid][roomid][ccriSlotes] > 0;
}

// Проверяет комнату на общедоступность (общая сессия)
stock ComputerClubIsRoomPublic(gameid, roomid) {
    return isnull(computerClubRoomInfo[gameid][roomid][ccriPassword]);
}

// Проверяет, в одной ли команде игроки
stock ComputerClubIsTeammates(firstid, secondid) {
    new _: game_first = GetPlayerActiveComputerGame(firstid),
        _: game_second = GetPlayerActiveComputerGame(secondid);
    if (game_first > -1 && game_first == game_second) {
        new team_first = computerClubPlayerInfo[firstid][ccpiTeam],
            team_second = computerClubPlayerInfo[secondid][ccpiTeam];

        return team_first == team_second;
    }

    return false;
}

// Отсоединяет наблюдателя от сервера
stock ComputerClubSpectatorRoomExit(playerid) {
    if (!ComputerClubIsSpectator(playerid)) return false;

    PlayerPlaySound(playerid, 30800, 0.0, 0.0, 0.0);
    new Float: connect_pos[4]; connect_pos[0] = computerClubPlayerInfo[playerid][ccpiConnectPos][0]; connect_pos[1] = computerClubPlayerInfo[playerid][ccpiConnectPos][1]; connect_pos[2] = computerClubPlayerInfo[playerid][ccpiConnectPos][2]; connect_pos[3] = computerClubPlayerInfo[playerid][ccpiConnectPos][3]; 
    SetSpawnInfo(playerid, NO_TEAM, 0, connect_pos[0], connect_pos[1], connect_pos[2], connect_pos[3], 0, 0, 0, 0, 0, 0);

    ComputerClubSetSpectateMode(playerid, false);

    memset(computerClubPlayerInfo[playerid], 0);

    return true;
}

// Отображает меню компьютерного клуба (если игрок уже на одном из серверов, то меню сервера)
stock ShowComputerClubMenu(playerid) {
    if (ComputerClubIsSpectator(playerid)) return ShowDialog(playerid, dComputerClubDisableSpectate, DIALOG_STYLE_MSGBOX, " ", "{ffffff}Вам недоступно меню этой комнаты {cccccc}[ Вы наблюдатель ]\n\n{ffffff}Хотите ли вы отсоединиться от сервера?", "Да", "Нет");
    if (GetPlayerActiveComputerGame(playerid) > -1) return ShowComputerGameMenu(playerid, computerClubPlayerInfo[playerid][ccpiID]);

    static const header[] = "{ff9000}Номер\t{cccccc}Название игры\t{0088ff}Игроки в сети";
    new dialog_text[sizeof header + (3 + 64 + 8) * COMPUTER_CLUB_GAMES_AMOUNT]; strcat(dialog_text, header);

    new players_at_game[COMPUTER_CLUB_GAMES_AMOUNT];
    foreach (new id : Player) {
        new gameid = GetPlayerActiveComputerGame(id);

        if (gameid > -1)
            players_at_game[gameid]++;
    }

    for (new i = 0; i < COMPUTER_CLUB_GAMES_AMOUNT; i++)
        format(dialog_text, sizeof dialog_text, "%s\n{ff9000}#%d\t{cccccc}%s\t{0088ff}%d чел.", dialog_text, i + 1, computerClubGameInfo[i][ccgiName], players_at_game[i]);

    return ShowDialog(playerid, dComputerClubMenu, DIALOG_STYLE_TABLIST_HEADERS, "{ff9000}Компьютерный клуб", dialog_text, "Выбор", "Закрыть");
}

// Отображает меню конкретной игры
stock ShowComputerGameMenu(playerid, gameid) {
    if (computerClubPlayerInfo[playerid][ccpiInGame]) {
        // Отображение настроек сервера (хост сможет их менять, другие только просматривать)
        ShowComputerClubRoomEdit(playerid, gameid, computerClubPlayerInfo[playerid][ccpiRoom]);
    } else { // Если игрок еще не в игре
        SetPVarInt(playerid, "ComputerClubSelectedGame", gameid + 1);

        new dialog_title[8 + 64 + 1];
        format(dialog_title, sizeof dialog_title, "{cccccc}%s", computerClubGameInfo[gameid][ccgiName]);

        ShowDialog(playerid, dComputerClubGameMenu, DIALOG_STYLE_LIST, dialog_title, "{ff9000}Описание игры\n{ffffff}Создать сервер\n{ffffff}Присоединиться к серверу\n{ffffff}Наблюдать за игрой", "Выбор", "Закрыть");
    }
    return 1;
}

// Отображает диалог взаимодействия с игроком в комнате (для хостов)
stock ShowComputerClubPlayerEdit(playerid, targetid) {
    if (!IsPlayerConnected(targetid)) return 0;
    if (playerid == targetid) return ShowComputerClubPlayersList(playerid);

    new dialog_title[64];
    format(dialog_title, sizeof dialog_title, "{cccccc}Управление игроком {ff9000}%s[%d]", playerInfo[targetid][pName], targetid);

    SetPVarInt(playerid, "ComputerClubPlayerEditId", targetid);
    SetPVarInt(playerid, "ComputerClubPlayerEditAcc", playerInfo[targetid][pID]);
    return ShowDialog(playerid, dComputerClubPlayerEdit, DIALOG_STYLE_LIST, dialog_title, "{cccccc}Кикнуть\n{cccccc}Заблокировать", "Выбор", "Назад");
}

// Отображает подтверждение действия над игроком
stock ComputerClubPlayerEditAccept(playerid, targetid, type) {
    if (!IsPlayerConnected(targetid)) return 0;

    new player_str[MAX_PLAYER_NAME + 8];
    format(player_str, sizeof player_str, "%s[%d]", playerInfo[targetid][pName], targetid);

    new dialog_text[128];
    switch (type) {
        case 0: format(dialog_text, sizeof dialog_text, "{cccccc}Вы действительно хотите отсоединить игрока {ff9000}%s{cccccc}?", player_str);
        case 1: format(dialog_text, sizeof dialog_text, "{cccccc}Вы действительно хотите заблокировать игрока {ff9000}%s{cccccc}?", player_str);
        default: return ShowComputerClubPlayerEdit(playerid, targetid);
    }

    SetPVarInt(playerid, "ComputerClubPlayerEditType", type);
    return ShowDialog(playerid, dComputerClubPlayerEditAccept, DIALOG_STYLE_MSGBOX, "{cccccc}Подтверждение действия", dialog_text, "Да", "Назад");
}

// Отображает правила конкретной игры
stock ShowComputerClubGameRules(playerid, gameid) {
    if (gameid < 0 || gameid > COMPUTER_CLUB_GAMES_AMOUNT - 1) return 0;
    
    new dialog_text[1024];
    switch (e_ComputerClubGames: gameid) {
        case COMPUTER_GAME_TDM: {
            strcat(dialog_text, "{ffffff}Режим {ff9000}TDM{ffffff} (командный матч) представляет собой интенсивное соревнование между двумя или более {ff9000}командами{ffffff}.\nКаждая команда стремится набрать определенное количество {ff9000}раундов{ffffff}, преодолевая своих соперников в поединках на живучесть.\n\nВ этом захватывающем режиме победа в раунде достигается путем уничтожения всех членов противоположной команды, оставив при этом своих союзников невредимыми.\nТактическое взаимодействие между членами команды становится важным фактором, так как одиночные действия могут не только повлиять на исход раунда, но и на общий результат матча.\n\nЦель команды - добиться определенного числа победных раундов, что требует как мастерства в стрельбе, так и умения эффективно сотрудничать с партнерами.\nВедь именно совместные усилия и координация позволят команде выйти победителем в этом динамичном соревновании.");
        }
        case COMPUTER_GAME_COPCHASE: {

        }
    }

    new dialog_title[8 + 64 + 1];
    format(dialog_title, sizeof dialog_title, "{cccccc}%s", computerClubGameInfo[gameid][ccgiName]);
    return ShowDialog(playerid, dComputerClubGameRules, DIALOG_STYLE_MSGBOX, dialog_title, dialog_text, " * ", "");
}

// Отображает меню создания сервера
stock ShowComputerClubRoomCreate(playerid, gameid) {
    new name[64], password[64];
    new slotes = GetPVarInt(playerid, "ComputerClubRoomSlotes");
    GetPVarString(playerid, "ComputerClubRoomName", name, sizeof name);
    GetPVarString(playerid, "ComputerClubRoomPassword", password, sizeof password);

    new dialog_text[512];
    format(dialog_text, sizeof dialog_text, "{cccccc}Название сервера:\t{ff9000}%s\n{cccccc}Пароль:\t{ff9000}%s\n{cccccc}Количество слотов:\t{ff9000}%d %s\n{99ff99}Подтвердить",
        (isnull(name) ? "{cccccc}Не задано" : name),
        (isnull(password) ? "{cccccc}Не используется" : password),
        slotes, PluralToText(slotes, "игрок", "игрока", "игроков")
    );
    return ShowDialog(playerid, dComputerClubRoomCreate, DIALOG_STYLE_TABLIST, "{ff9000}Создание сервера", dialog_text, "Выбор", "Назад");
}

// Отображает изменение названия сервера
stock ShowComputerClubSetName(playerid, bool: change = false) {
    if (change) SetPVarInt(playerid, "ComputerClubChange", 1);
    
    return ShowDialog(playerid, dComputerClubRoomCreate_name, DIALOG_STYLE_INPUT, change ? "Изменение названия" : "Создание сервера {cccccc}[ Название ]", "{ffffff}Укажите название для вашего сервера:", "Принять", "Отмена");
}

// Отображает изменение пароля сервера
stock ShowComputerClubSetPass(playerid, bool: change = false) {
    if (change) SetPVarInt(playerid, "ComputerClubChange", 1);

    return ShowDialog(playerid, dComputerClubRoomCreate_pass, DIALOG_STYLE_INPUT, change ? "Изменение пароля" : "Создание сервера {cccccc}[ Пароль ]", "{ffffff}Укажите пароль для вашего сервера:", "Принять", "Отмена");
}

// Отображает изменение количества слотов сервера
stock ShowComputerClubSetSlotes(playerid, bool: change = false) {
    if (change) SetPVarInt(playerid, "ComputerClubChange", 1);

    return ShowDialog(playerid, dComputerClubRoomCreate_slotes, DIALOG_STYLE_INPUT, change ? "Изменение количества слотов" : "Создание сервера {cccccc}[ Слоты ]", "{ffffff}Укажите количество слотов вашего сервера (до 1000):", "Принять", "Отмена");
}

// Отображает изменение максимального количества участников в одной команде
stock ShowComputerClubSetTeamSize(playerid) {
    new gameid = GetPlayerActiveComputerGame(playerid),
        roomid = computerClubPlayerInfo[playerid][ccpiRoom];
    if (gameid < 0) return 0;

    new dialog_text[180];
    format(dialog_text, sizeof dialog_text, "{ffffff}Укажите максимальное количество игроков в одной команде:\n\n{cccccc}Минимальное количество участников в команде для этой комнаты: {ff9000}%d", ComputerClubGetTeamCount(gameid, roomid));
    
    return ShowDialog(playerid, dComputerClubRoom_teamsize, DIALOG_STYLE_INPUT, "Изменение размера команд", dialog_text, "Принять", "Назад");
}

// Отображает изменение максимального количества раундов
stock ShowComputerClubSetMaxRounds(playerid) {
    return ShowDialog(playerid, dComputerClubRoom_maxrounds, DIALOG_STYLE_INPUT, "Изменение количества раундов", "{ffffff}Укажите количество раундов для победы (не более 30):", "Принять", "Назад");
}

// Отображает изменение максимального количества HP
stock ShowComputerClubSetMaxHealth(playerid) {
    return ShowDialog(playerid, dComputerClubRoom_maxhealth, DIALOG_STYLE_INPUT, "Изменение максимального HP", "{ffffff}Укажите максимальное количество HP:", "Принять", "Назад");
}

// Отображает изменение максимального количества брони
stock ShowComputerClubSetMaxArmor(playerid) {
    return ShowDialog(playerid, dComputerClubRoom_maxarmor, DIALOG_STYLE_INPUT, "Изменение максимальной брони", "{ffffff}Укажите максимальное количество брони:", "Принять", "Назад");
}

// Отображает изменение оружия (+ патрон)
stock ShowComputerClubSetWeapons(playerid, slotid = 0, bool: change_weapon = false, bool: change_ammo = false, index = -1) {
    new gameid = GetPlayerActiveComputerGame(playerid),
        roomid = computerClubPlayerInfo[playerid][ccpiRoom];
    if (gameid < 0) return 0;

    if (computerClubRoomInfo[gameid][roomid][ccriStarted]) {
        SendClientMessage(playerid, 0xCCCCCCFF, "[ Мысли ]: Я не могу изменять редактировать оружие при запущенной игре");
        return ShowComputerClubMenu(playerid);
    }

    // Заполняем доступные для каждого типа оружия ID
    const MAX_SLOT_WEAPONS = 8; // Максимальное количество оружий для одного слота
    static available_ids[8][MAX_SLOT_WEAPONS] = {
        {WEAPON_GOLFCLUB, WEAPON_NITESTICK, WEAPON_KNIFE, WEAPON_BAT, WEAPON_SHOVEL, WEAPON_POOLSTICK, WEAPON_KATANA, WEAPON_CHAINSAW},
        {WEAPON_COLT45, WEAPON_SILENCED, WEAPON_DEAGLE},
        {WEAPON_SHOTGUN, WEAPON_SAWEDOFF, WEAPON_SHOTGSPA},
        {WEAPON_UZI, WEAPON_MP5, WEAPON_TEC9},
        {WEAPON_AK47, WEAPON_M4},
        {WEAPON_RIFLE, WEAPON_SNIPER},
        {WEAPON_ROCKETLAUNCHER, WEAPON_HEATSEEKER, WEAPON_FLAMETHROWER, WEAPON_MINIGUN},
        {WEAPON_GRENADE, WEAPON_TEARGAS, WEAPON_MOLTOV}
    };

    new dialog_text[512];
    SetPVarInt(playerid, "ComputerClubSetWeaponType", !change_weapon);
    if (change_weapon) {
        if (slotid < 0) return 0;
        SetPVarInt(playerid, "ComputerClubSetWeaponSlot", slotid);

        // Выбор оружия для указанного типа
        strcat(dialog_text, "{cccccc}Убрать\n");
        for (new i = 0; i < MAX_SLOT_WEAPONS; i++) {
            new weapon_id = available_ids[slotid][i];
            if (weapon_id == 0)
                break;

            new weapon_name[32];
            GetWeaponName(weapon_id, weapon_name, sizeof weapon_name);

            format(dialog_text, sizeof dialog_text, "%s%s\n", dialog_text, weapon_name);
        }

        return ShowDialog(playerid, dComputerClubRoom_weapons, DIALOG_STYLE_LIST, "{cccccc}Выбор оружия", dialog_text, "Выбор", "Назад");
    } else if (change_ammo) {
        slotid = GetPVarInt(playerid, "ComputerClubSetWeaponSlot");
        if (slotid < 0 || index < 0) return 0;

        // Изменение количества патрон для указанного оружия
        static none_ammo_ids[] = {0, WEAPON_BRASSKNUCKLE, WEAPON_GOLFCLUB, WEAPON_NITESTICK, WEAPON_KNIFE, WEAPON_BAT, WEAPON_SHOVEL, WEAPON_POOLSTICK, WEAPON_KATANA, WEAPON_CHAINSAW, WEAPON_DILDO, WEAPON_DILDO2, WEAPON_VIBRATOR, WEAPON_VIBRATOR2, WEAPON_FLOWER, WEAPON_CANE};
            
        // Убирание оружия для выбранного слота
        if (index == 0) {
            ComputerClubSetWeapons(gameid, roomid, slotid, 0, 1);
            return ShowComputerClubSetWeapons(playerid);
        }

        index--; // Учитываем, что первая строка - убирание оружия
        new weapon_id = available_ids[slotid][index];
        SetPVarInt(playerid, "ComputerClubSetWeaponIndex", index);
        SetPVarInt(playerid, "ComputerClubSetWeaponId", weapon_id + 1);

        for (new i = 0; i < sizeof none_ammo_ids; i++)
            if (weapon_id == none_ammo_ids[i]) {
                ComputerClubSetWeapons(gameid, roomid, slotid, weapon_id, 1);
                
                return ShowComputerClubSetWeapons(playerid);
            }

        new weapon_name[32];
        GetWeaponName(weapon_id, weapon_name, sizeof weapon_name);
        format(dialog_text, sizeof dialog_text, "{cccccc}Укажите количество патрон для выбранного оружия - %s (не более 1000):", weapon_name);
        return ShowDialog(playerid, dComputerClubRoom_weapons, DIALOG_STYLE_INPUT, "{cccccc}Количество патрон", dialog_text, "Принять", "Назад");
    } else {
        DeletePVar(playerid, "ComputerClubSetWeaponType");
        DeletePVar(playerid, "ComputerClubSetWeaponIndex");
        DeletePVar(playerid, "ComputerClubSetWeaponId");
        DeletePVar(playerid, "ComputerClubSetWeaponSlot");
        
        // Выбор типа оружия (основное/вторичное) + вывод текущих
        SetPVarInt(playerid, "ComputerClubSetWeaponType", 2);

        static dialog_headers[8][] = {"Холодное оружие", "Пистолет", "Дробовик", "Пистолет-пулемёт", "Штурмовая винтовка", "Снайперская винтовка", "Тяжелое оружие", "Метательное оружие"};
        for (new i = 0; i < 8; i++) {
            new weapon_name_str[100];
            new weapon_id = computerClubRoomInfo[gameid][roomid][ccriWeapons][i];

            if (weapon_id == 0) strcat(weapon_name_str, "{cccccc}-");
            else {
                new weapon_name[64];
                GetWeaponName(computerClubRoomInfo[gameid][roomid][ccriWeapons][i], weapon_name, sizeof weapon_name);

                format(weapon_name_str, sizeof weapon_name_str, "%s (%d)", weapon_name, computerClubRoomInfo[gameid][roomid][ccriWeaponsAmmo][i]);
            }

            format(dialog_text, sizeof dialog_text, "%s{ffffff}%s:\t{ff9000}%s\n", dialog_text, dialog_headers[i], weapon_name_str);
        }

        return ShowDialog(playerid, dComputerClubRoom_weapons, DIALOG_STYLE_TABLIST, "{cccccc}Выбор типа оружия", dialog_text, "Выбор", "Назад");
    }
}

// Отображает изменение ставки
stock ShowComputerClubSetBet(playerid) {
  return ShowDialog(playerid, dComputerClubRoom_bet, DIALOG_STYLE_INPUT, "Изменение ставки", "{ffffff}Укажите сумму ставки (не более $1.000.000):", "Принять", "Назад");  
}

// Отображает список участников указанной (или текущей) комнаты
stock ShowComputerClubPlayersList(playerid, gameid = -1, roomid = -1) {
    if (gameid == -1 || roomid == -1) {
        gameid = GetPlayerActiveComputerGame(playerid);
        roomid = computerClubPlayerInfo[playerid][ccpiRoom];
    }
    if (gameid < 0) return 0;

    new dialog_text[1024];
    foreach (new id : Player) {
        if (ComputerClubIsPlayerInRoom(id, gameid, roomid))
            format(dialog_text, sizeof dialog_text, "%s{%s}%s[%d]%s\n", dialog_text, ColorToHexString(GetPlayerColor(id)), playerInfo[id][pName], id, computerClubPlayerInfo[id][ccpiIsDead] ? " {333333}[DEAD]" : "");
    }

    return ShowDialog(playerid, dComputerClubPlayersList, DIALOG_STYLE_LIST, "{ff9000}Список игроков", dialog_text, "Выбор", "Назад");
}

// Отображает список наблюдателей указанной (или текущей) комнаты
stock ShowComputerClubSpectatorsList(playerid, gameid = -1, roomid = -1) {
    if (gameid == -1 || roomid == -1) {
        gameid = GetPlayerActiveComputerGame(playerid);
        roomid = computerClubPlayerInfo[playerid][ccpiRoom];
    }
    if (gameid < 0) return 0;

    new dialog_text[1024];
    foreach(new id : Player) {
        if (ComputerClubIsSpectate(id)) {
            new spectate_game, spectate_room, spectate_id, spectate_team;
            ComputerClubGetSpectatorData(id, spectate_game, spectate_room, spectate_id, spectate_team);

            // Если он не является игроком этой комнаты
            if (!ComputerClubIsPlayerInRoom(id, spectate_game, spectate_room))
                format(dialog_text, sizeof dialog_text, "%s{cccccc}%s[%d]\n", dialog_text, playerInfo[id][pName], id);
        }
    }

    if (isnull(dialog_text))
        return 0;

    ShowDialog(playerid, dComputerClubSpectatorsList, DIALOG_STYLE_LIST, "{ff9000}Список наблюдателей", dialog_text, "Назад", "");
    
    return 1;
}

// Отображает меню изменения настроек сервера (уже после его создания)
stock ShowComputerClubRoomEdit(playerid, gameid, roomid) {
    new dialog_text[1256];
    // Общие для всех игр пункты меню
    {
        new password[64], name[64];
        new slotes = computerClubRoomInfo[gameid][roomid][ccriSlotes];
        strcat(password, computerClubRoomInfo[gameid][roomid][ccriPassword]);
        strcat(name, computerClubRoomInfo[gameid][roomid][ccriName]);

        format(dialog_text, sizeof dialog_text, "{cd5700}Покинуть игру\t\n{ff9000}Список игроков >>\t\n{ff9000}Список наблюдателей >>\t\n{ff9000}Доступные команды >>\t\n{ff9000}Доступное оружие >>\t\n{cccccc}Статус игры:\t%s\n{cccccc}Название сервера:\t{ff9000}%s\n{cccccc}Пароль:\t{ff9000}%s\n{cccccc}Количество слотов:\t{ff9000}%d %s\n{cccccc}Возможность подключения:\t%s\n{cccccc}Разрешение на просмотр:\t%s",
            (!computerClubRoomInfo[gameid][roomid][ccriStarted] ? "{cd5700}[ OFF ]" : "{99ff99}[ ON ]"),
            name,
            (isnull(password) ? "{cccccc}Не используется" : password),
            slotes, PluralToText(slotes, "игрок", "игрока", "игроков"),
            (computerClubRoomInfo[gameid][roomid][ccriClosed] ? "{cd5700}[ OFF ]" : "{99ff99}[ ON ]"),
            (!computerClubRoomInfo[gameid][roomid][ccriViewAccess] ? "{cd5700}[ OFF ]" : "{99ff99}[ ON ]")
        );
    }
    // Пункты меню отдельные под каждую игру
    switch (e_ComputerClubGames: gameid) {
        case COMPUTER_GAME_TDM: {
            new bet_str[30];
            FormatNumberWithCommas(computerClubRoomInfo[gameid][roomid][ccriBet], bet_str);
            format(bet_str, sizeof bet_str, "{00cc00}$%s", bet_str);
            new armor_str[15];
            format(armor_str, sizeof armor_str, "{ff9000}%.0f", computerClubRoomInfo[gameid][roomid][ccriMaxArmor]);

            format(dialog_text, sizeof dialog_text, "%s\n{cccccc}Карта:\t{ff9000}%s\n{cccccc}Размер команд:\t{ff9000}%d %s\n{cccccc}Длительность:\t{ff9000}%d %s\n{cccccc}Режим стрельбы:\t{ff9000}%s\n{cccccc}Максимальное здоровье:\t{ff9000}%.0f\n{cccccc}Максимальная броня:\t%s\n{cccccc}Ставка:\t%s\n", dialog_text,
                computerClubLocationInfo[computerClubRoomInfo[gameid][roomid][ccriLocation]][ccliName],
                computerClubRoomInfo[gameid][roomid][ccriTeamSize], PluralToText(computerClubRoomInfo[gameid][roomid][ccriTeamSize], "игрок", "игрока", "игроков"),
                computerClubRoomInfo[gameid][roomid][ccriMaxRounds], PluralToText(computerClubRoomInfo[gameid][roomid][ccriMaxRounds], "раунд", "раунда", "раундов"),
                (!computerClubRoomInfo[gameid][roomid][ccriTDMShootMode] ? "Обычный" : "+C"),
                computerClubRoomInfo[gameid][roomid][ccriMaxHealth],
                (computerClubRoomInfo[gameid][roomid][ccriMaxArmor] <= 0 ? "{cccccc}Не используется" : armor_str),
                (computerClubRoomInfo[gameid][roomid][ccriBet] <= 0 ? "{cccccc}Не используется" : bet_str)
            );
        }
        case COMPUTER_GAME_COPCHASE: {
            format(dialog_text, sizeof dialog_text, "%s\n{cccccc}Локация:\t{ff9000}%s\n{cccccc}Автомобили для полицейских\n{cccccc}Автомобили для подозреваемых\n{cccccc}Оружие\n{cccccc}Выбор подозреваемого:\t{ff9000}%s",
                dialog_text,
                "Los Santos",
                "Случайно"
            );
        }
    }

    return ShowDialog(playerid, dComputerClubRoomEdit, DIALOG_STYLE_TABLIST, "Меню сервера", dialog_text, "Выбор", "Закрыть");
}

// Выдает оружие комнаты игроку
stock ComputerClubSetPlayerWeapons(playerid) {
    new gameid = GetPlayerActiveComputerGame(playerid),
        roomid = computerClubPlayerInfo[playerid][ccpiRoom];

    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;
    if (!IsPlayerConnected(playerid)) return 0;

    ResetPlayerWeapons(playerid);
    for (new i = 0; i < 8; i++)
        GivePlayerWeapon(playerid, computerClubRoomInfo[gameid][roomid][ccriWeapons][i], computerClubRoomInfo[gameid][roomid][ccriWeaponsAmmo][i]);

    return 1;
}

// Изменяет оружие и патроны для комнаты
stock ComputerClubSetWeapons(gameid, roomid, slotid, weaponid, ammo) {
    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;

    computerClubRoomInfo[gameid][roomid][ccriWeapons][slotid] = weaponid;
    computerClubRoomInfo[gameid][roomid][ccriWeaponsAmmo][slotid] = ammo;

    foreach (new id : Player)
        if (ComputerClubIsPlayerInRoom(id, gameid, roomid))
            ComputerClubSetPlayerWeapons(id);

    return 1;
}

// Получает индекс первой доступной указанной игре локации
stock ComputerClubGetStartLocation(gameid) {
    return computerClubGameInfo[_:gameid][ccgiLocations][0];
}

// Получает рандомный из спавнов указанной локации
stock ComputerClubGetRandomSpawn(gameid, locationid, teamid = 0) {
    new available_spawn_ids[COMPUTER_CLUB_MAX_LOCATION_SPAWNS], available_spawns_count = 0; // ID доступных для возрождения спавнов + их количество
    new occupied_spawn_ids[COMPUTER_CLUB_MAX_LOCATION_SPAWNS], occupied_spawns_count = 0; // ID спавнов на которых находится какой-нибудь игрок
    
    for (new j = 0; j < COMPUTER_CLUB_MAX_LOCATION_SPAWNS; j++) {
        new Float: lx = computerClubLocationSpawn[locationid][j][cclsPos][0],
            Float: ly = computerClubLocationSpawn[locationid][j][cclsPos][1],
            Float: lz = computerClubLocationSpawn[locationid][j][cclsPos][2],
            Float: la = computerClubLocationSpawn[locationid][j][cclsPos][3];

        // Если спавна не существует - выходим из цикла
        if (lx == 0.0 && ly == 0.0 && lz == 0.0 && la == 0.0) break;
        
        // Если спавн не соответствует нужной команде - пропускаем его
        new spawn_team = computerClubLocationSpawn[locationid][j][cclsTeam];
        if (spawn_team != 0 && spawn_team - 1 != teamid) continue;

        // Если спавн уже кем-то занят - пропускаем его, но запоминаем
        new bool: is_occupied = false;
        foreach (new id : Player) {
            if (IsPlayerInRangeOfPoint(id, 3.0, lx, ly, lz)) {
                occupied_spawn_ids[occupied_spawns_count] = j;
                occupied_spawns_count++;

                is_occupied = true;
                break;
            }
        }
        if (is_occupied) continue;

        // Помечаем спавн доступным
        available_spawn_ids[available_spawns_count] = j;
        available_spawns_count++;
    }

    if (available_spawns_count == 0 && occupied_spawns_count > 0)
        // Если нет доступных спавнов, но есть те, которые заняты - все-таки спавним его туда (ну а куда блин еще)
        return occupied_spawn_ids[random_range(0, occupied_spawns_count - 1)];
    else if (available_spawns_count > 0) {
        // Если доступные спавны есть - спавним на одном из них
        return available_spawn_ids[random_range(0, available_spawns_count - 1)];
    }

    // Спавнов вообще нет - ну это только если их в коде забыли добавить :/
    return 0;
}

// Получает количество команд в комнате
stock ComputerClubGetTeamCount(gameid, roomid) {
    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;

    for (new i = 0; i < COMPUTER_CLUB_MAX_TEAMS; i++) {
        if (isnull(computerClubTeamInfo[gameid][roomid][i]))
            return i;
    }
        
    return COMPUTER_CLUB_MAX_TEAMS;
}

// Узнает минимальный размер для команды в указанной комнате
stock ComputerClubGetMinimalTeamSize(gameid, roomid) {
    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;
    
    return _:(computerClubRoomInfo[gameid][roomid][ccriSlotes] / ComputerClubGetTeamCount(gameid, roomid)) + 1;
}

// Создает комнату в указанной игре
stock ComputerClubRoomCreate(hostid, gameid, const name[], const password[], slotes = 10) {
    for (new roomid = 0; roomid < COMPUTER_CLUB_MAX_ROOMS; roomid++) {
        if (ComputerClubIsRoomExists(gameid, roomid)) continue;
        memset(computerClubRoomInfo[gameid][roomid], 0);

        format(computerClubRoomInfo[gameid][roomid][ccriName], 25, "%s", name);
        format(computerClubRoomInfo[gameid][roomid][ccriPassword], 64, "%s", password);
        computerClubRoomInfo[gameid][roomid][ccriSlotes] = slotes;
        computerClubRoomInfo[gameid][roomid][ccriHostID] = playerInfo[hostid][pID];
        computerClubRoomInfo[gameid][roomid][ccriLocation] = ComputerClubGetStartLocation(gameid);
        format(computerClubRoomInfo[gameid][roomid][ccriHostNickname], MAX_PLAYER_NAME + 1, "%s", playerInfo[hostid][pName]);

        // Предустановленные настройки
        computerClubRoomInfo[gameid][roomid][ccriMaxRounds] = 3;
        computerClubRoomInfo[gameid][roomid][ccriMaxHealth] = 100;
        if (gameid == _:COMPUTER_GAME_TDM) {
            computerClubTeamInfo[gameid][roomid][0] = "{FF0000}Красные";
            computerClubTeamInfo[gameid][roomid][1] = "{0088FF}Синие";

            computerClubRoomInfo[gameid][roomid][ccriTeamSize] = ComputerClubGetMinimalTeamSize(gameid, roomid);

            computerClubRoomInfo[gameid][roomid][ccriWeapons][COMPUTER_CLUB_WS_ASSAULT] = WEAPON_M4;
            computerClubRoomInfo[gameid][roomid][ccriWeaponsAmmo][COMPUTER_CLUB_WS_ASSAULT] = 350;
            computerClubRoomInfo[gameid][roomid][ccriWeapons][COMPUTER_CLUB_WS_PISTOL] = WEAPON_DEAGLE;
            computerClubRoomInfo[gameid][roomid][ccriWeaponsAmmo][COMPUTER_CLUB_WS_PISTOL] = 100;
        }

        return roomid;
    }
    return -1;
}

// Сохраняет положение игрока перед присоединением к комп. клубу
stock ComputerClubSaveConnectPosition(playerid) {
    GetPlayerPos(playerid, computerClubPlayerInfo[playerid][ccpiConnectPos][0], computerClubPlayerInfo[playerid][ccpiConnectPos][1], computerClubPlayerInfo[playerid][ccpiConnectPos][2]);
    GetPlayerFacingAngle(playerid, computerClubPlayerInfo[playerid][ccpiConnectPos][3]);
    computerClubPlayerInfo[playerid][ccpiConnectWorld] = GetPlayerVirtualWorld(playerid);
    computerClubPlayerInfo[playerid][ccpiConnectInterior] = GetPlayerInterior(playerid);
}

// Подключает игрока к нужному серверу
stock ComputerClubRoomJoin(playerid, gameid, roomid) {
    // Отправляем на спавн, где будет выдано нужное оружие и т.п.
    SpawnPlayer(playerid);

    // Сообщение о коннекте
    {
        static const fmt_message_join[] = "[ Компьютерный клуб ]: {cccccc}Вы подключились к серверу {ff9000}%s {ff9000}[%d/%d]";
        new message_join[sizeof fmt_message_join - 2 + 64 + 2 * (-2 + 3)];
        format(message_join, sizeof message_join, fmt_message_join, computerClubRoomInfo[gameid][roomid][ccriName], ComputerClubGetPlayersCount(gameid, roomid) + 1, computerClubRoomInfo[gameid][roomid][ccriSlotes]);
        SendClientMessage(playerid, 0x0088FFFF, message_join);
    }
    {
        static const fmt_message_join[] = "[ Компьютерный клуб ]: {cccccc}%s подключился к серверу";
        new message_join[sizeof fmt_message_join - 2 + MAX_PLAYER_NAME + 1];
        format(message_join, sizeof message_join, fmt_message_join, playerInfo[playerid][pName]);

        ComputerClubRoomMessage(gameid, roomid, 0x0088FFFF, message_join);
    }

    // Подключение
    computerClubPlayerInfo[playerid][ccpiInGame] = true;
    computerClubPlayerInfo[playerid][ccpiID] = e_ComputerClubGames: gameid;
    computerClubPlayerInfo[playerid][ccpiRoom] = roomid;
    ComputerClubSaveConnectPosition(playerid);
    
    // Отмена отключения сервера при возвращении хоста
    if (ComputerClubIsPlayerHost(playerid))
        KillTimer(computerClubRoomInfo[gameid][roomid][ccriHostDisconnectTimer]);

    // Отображение текстдрава разминки
    if (gameid == _:COMPUTER_GAME_TDM) {
        if (!computerClubRoomInfo[gameid][roomid][ccriStarted])
            TextDrawShowForPlayer(playerid, COMPUTER_CLUB_WARMUP_TD);
    }

    return 1;
}

// Отображает настройки названий/количества команд
stock ShowComputerClubTeamSettings(playerid) {
    new gameid = GetPlayerActiveComputerGame(playerid),
        roomid = computerClubPlayerInfo[playerid][ccpiRoom];
    if (gameid < 0) return 0;
    if (computerClubRoomInfo[gameid][roomid][ccriStarted]) {
        SendClientMessage(playerid, 0xCCCCCCFF, "[ Мысли ]: Я не могу редактировать команды при запущенной игре");
        return ShowComputerClubMenu(playerid);
    }

    new bool: is_host = bool: ComputerClubIsPlayerHost(playerid);

    new dialog_text[256] = "{cccccc}Добавить команду\n";
    if (!is_host) dialog_text[0] = EOS;
    
    for (new i = 0; i < COMPUTER_CLUB_MAX_TEAMS; i++)
        format(dialog_text, sizeof dialog_text, "%s%s\n", dialog_text, computerClubTeamInfo[gameid][roomid][i]);

    return ShowDialog(playerid, dComputerClubTeamSettings, DIALOG_STYLE_LIST, "{ff9000}Управление командами", dialog_text, "Выбор", "Назад");
}

// Отображает добавление новой команды
stock ShowComputerClubAddTeam(playerid) {
    return ShowDialog(playerid, dComputerClubTeamAdd, DIALOG_STYLE_INPUT, "{ff9000}Добавление команды", "{cccccc}Укажите название команды в формате: {ff9000}{сссссс}Серые\n\n{cccccc}Цвет также будет использоваться для никнеймов участников", "Ок", "Назад");
}

// Отображает редактирование указанной команды
stock ShowComputerClubEditTeam(playerid, teamid) {
    SetPVarInt(playerid, "ComputerClubEditTeamId", teamid);
    return ShowDialog(playerid, dComputerClubTeamEdit, DIALOG_STYLE_INPUT, "{ff9000}Редактирование команды", "{cccccc}Введите название новой команды в формате: {ff9000}{сссссс}Серые\n\n{cccccc}Цвет также будет использоваться для никнеймов участников\nОставьте поле пустым для удаления команды", "Ок", "Назад");
}

// Отображает диалог выбора команды
stock ShowComputerClubChooseTeam(playerid, gameid, bool: before_connection = false) {
    if (gameid < 0 || gameid > COMPUTER_CLUB_GAMES_AMOUNT) return 0;
    new roomid = GetPVarInt(playerid, "ComputerClubSelectedRoom") - 1;
    if (roomid < 0) roomid = computerClubPlayerInfo[playerid][ccpiRoom];

    new dialog_text[512];
    for (new i = 0; i < COMPUTER_CLUB_MAX_TEAMS; i++) {
        if (isnull(computerClubTeamInfo[gameid][roomid][i])) break;

        format(dialog_text, sizeof dialog_text, "%s%s\n", dialog_text, computerClubTeamInfo[gameid][roomid][i]);
    }

    // Если игра без команд, просто присоединяем его к серверу
    if (before_connection && isnull(dialog_text))
        return ComputerClubRoomJoin(playerid, gameid, roomid);
    
    SetPVarInt(playerid, "ComputerClubChooseTeamBC", before_connection ? 1 : 0);
    return ShowDialog(playerid, dComputerClubChooseTeam, DIALOG_STYLE_LIST, "{cccccc}Выбор команды", dialog_text, "Выбор", !before_connection ? "Назад" : "");
}

// Отображает диалог выбора карты
stock ShowComputerClubChooseMap(playerid) {
    if (!ComputerClubIsPlayerHost(playerid)) return 0;

    new gameid = GetPlayerActiveComputerGame(playerid);

    new dialog_text[512];
    for (new i = computerClubGameInfo[gameid][ccgiLocations][0]; i < COMPUTER_CLUB_MAX_GAME_LOCATIONS; i++) {
        new locationid = computerClubGameInfo[gameid][ccgiLocations][i];
        if (i > 0 && locationid == 0) break;

        format(dialog_text, sizeof dialog_text, "%s{cccccc}%s\n", dialog_text, computerClubLocationInfo[locationid][ccliName]);
    }
    return ShowDialog(playerid, dComputerClubChooseMap, DIALOG_STYLE_LIST, "{ff9000}Выбор карты", dialog_text, "Выбор", "Назад");
}

// Присваивает указанную команду игроку
stock ComputerClubSetPlayerTeam(playerid, teamid) {
    new gameid = GetPlayerActiveComputerGame(playerid);
    if (gameid > -1) {
        if (computerClubPlayerInfo[playerid][ccpiTeam] == teamid) return 0;

        // [ Авто-баланс* ]
        computerClubPlayerInfo[playerid][ccpiTeam] = teamid;

        SpawnPlayer(playerid);
    }
    return 1;
}

// Узнает максимальное количество команд для комнаты
stock ComputerClubGetMaxTeams(gameid, roomid) {
    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;

    /*new locationid = computerClubRoomInfo[gameid][roomid][ccriLocation];

    new count = 0;
    for (new i = 0; i < COMPUTER_CLUB_MAX_LOCATION_SPAWNS; i++) {
        new teamid = computerClubLocationSpawn[locationid][i][cclsTeam];
        if (count < teamid) count = teamid;
    }

    return count;*/

    return COMPUTER_CLUB_MAX_TEAMS;
}

// Предлагает хосту удалить сервер или выйти на время, при попытке покинуть игру
stock ComputerClubShowHostRoomExit(playerid) {
    return ShowDialog(playerid, dComputerClubHostRoomExit, DIALOG_STYLE_MSGBOX, "{cd5700}Подтверждение выхода", "{cccccc}Вы являетесь хостом этого сервера\n\nВыберите один из двух возможных вариантов:\n{cd5700}1) {cccccc}Удаление сервера - комната будет моментально удалена, а все игроки получат соответствующее уведомление\n{cd5700}2) {cccccc}Выход на время - вы сможете вернуться не позже, чем через пять минут\n\nЕсли вы не вернётесь через отведенное время, сервер будет удалён автоматически", "Удаление", "Выход");
}

// Добавляет игрока в список заблокированных
stock ComputerClubSetBanned(gameid, roomid, playerid) {
    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;

    for (new i = 0; i < MAX_PLAYERS; i++) {
        if (computerClubRoomInfo[gameid][roomid][ccriBannedPlayers][i] > 0)
            continue;

        computerClubRoomInfo[gameid][roomid][ccriBannedPlayers][i] = playerInfo[playerid][pID];
        break;
    }
    
    return 1;
}

// Проверяет, что название команды соответствует требуемому
stock ComputerClubIsValidTeamName(const name[]) {
    if (isnull(name)) return false;
    if (name[0] != '{' || name[7] != '}') return false;

    for (new i = 1; i <= 6; i++) {
        new c = name[i];
        if (!( (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F') ))
            return false;
    }

    return true;
}

// Добавляет команду в указанную комнату
stock ComputerClubAddTeam(gameid, roomid, const name[]) {
    if (!ComputerClubIsValidTeamName(name)) return 0;
    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;
    if (ComputerClubGetTeamCount(gameid, roomid) >= ComputerClubGetMaxTeams(gameid, roomid)) return 0;

    for (new i = 0; i < COMPUTER_CLUB_MAX_TEAMS; i++)
        if (isnull(computerClubTeamInfo[gameid][roomid][i])) {
            strcat(computerClubTeamInfo[gameid][roomid][i], name);
            break;
        }

    return 1;
}

// Удаляет указанную команду из комнаты
stock ComputerClubDeleteTeam(gameid, roomid, teamid) {
    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;
    if (teamid < 0 || teamid > COMPUTER_CLUB_MAX_TEAMS) return 0;

    computerClubTeamInfo[gameid][roomid][teamid][0] = EOS;

    foreach(new id : Player) {
        if (ComputerClubIsPlayerInRoom(id, gameid, roomid)) {
            computerClubPlayerInfo[id][ccpiTeam] = 0;
            if (!ComputerClubIsPlayerHost(id)) {
                SendClientMessage(id, 0x0088FFFF, "[ Компьютерный клуб ]: {cccccc}Хост сервера удалил команду, в которой вы состояли.");
                ShowComputerClubChooseTeam(id, gameid);
            }
        }
    }

    return 1;
}

// Проверяет, заблокирован ли игрок
stock ComputerClubIsPlayerBanned(gameid, roomid, playerid) {
    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;

    for (new i = 0; i < MAX_PLAYERS; i++) {
        if (computerClubRoomInfo[gameid][roomid][ccriBannedPlayers][i] == 0)
            break;
        
        if (computerClubRoomInfo[gameid][roomid][ccriBannedPlayers][i] == playerInfo[playerid][pID])
            return 1;
    }

    return 0;
}

// Отключает игрока от текущего сервера
stock ComputerClubRoomExit(playerid, e_ComputerClubDisconnectReasons: reason) {
    if (!computerClubPlayerInfo[playerid][ccpiInGame]) return 0;

    new gameid = computerClubPlayerInfo[playerid][ccpiID],
        roomid = computerClubPlayerInfo[playerid][ccpiRoom],
        teamid = computerClubPlayerInfo[playerid][ccpiTeam];
    new Float: connect_pos[4]; connect_pos[0] = computerClubPlayerInfo[playerid][ccpiConnectPos][0]; connect_pos[1] = computerClubPlayerInfo[playerid][ccpiConnectPos][1]; connect_pos[2] = computerClubPlayerInfo[playerid][ccpiConnectPos][2]; connect_pos[3] = computerClubPlayerInfo[playerid][ccpiConnectPos][3]; 
    new connect_world = computerClubPlayerInfo[playerid][ccpiConnectWorld], connect_interior = computerClubPlayerInfo[playerid][ccpiConnectInterior];

    // Переключение на следующего игрока или выход из комнаты для наблюдателей, что смотрели за отключившимся игроком
    new bool: empty_room = ComputerClubGetPlayersCount(gameid, roomid) < 2;
    foreach (new id : Player) {
        new spectator_game, spectator_room, spectator_team, spectator_id;
        ComputerClubGetSpectatorData(id, spectator_game, spectator_room, spectator_team, spectator_id);
        
        if (spectator_game != gameid || spectator_room != roomid) continue;
        
        if (empty_room) {
            ComputerClubSpectatorRoomExit(id);
        } else if (playerid == spectator_id) {
            ComputerClubSwitchSpectate(id, true);
        }
    }

    // Отключение
    memset(computerClubPlayerInfo[playerid], 0);

    // Личное сообщение об отключении
    {
        static const fmt_message_exit[] = "[ Компьютерный клуб ]: {cccccc}Вы отключились от сервера {ff9000}%s";
        new message_exit[sizeof fmt_message_exit - 2 + 65];
        format(message_exit, sizeof message_exit, fmt_message_exit, computerClubRoomInfo[gameid][roomid][ccriName]);
        SendClientMessage(playerid, 0x0088FFFF, message_exit);
    }
    
    // Общее сообщение об отключении
    {
        new reason_str[30];
        if (reason == COMPUTER_CLUB_D_REASON_SELF) strcat(reason_str, "{33ccff}Выход");
        else if (reason == COMPUTER_CLUB_D_REASON_KICKED) strcat(reason_str, "{ffcc66}Кик");
        else if (reason == COMPUTER_CLUB_D_REASON_BANNED) {
            strcat(reason_str, "{cd5700}Бан");
            ComputerClubSetBanned(gameid, roomid, playerid);
        }
        else if (reason == COMPUTER_CLUB_D_REASON_NO_BET) strcat(reason_str, "{ffcc66}Нет суммы для ставки");
        
        static const fmt_message_exit[] = "[ Компьютерный клуб ]: {cccccc}%s отключился от сервера [ Причина: %s {cccccc}]";
        new message_exit[sizeof fmt_message_exit - 2 + MAX_PLAYER_NAME - 2 + 35];
        format(message_exit, sizeof message_exit, fmt_message_exit, playerInfo[playerid][pName], reason_str);

        ComputerClubRoomMessage(gameid, roomid, 0x0088FFFF, message_exit);
    }

    // Обработка дисконнекта хоста
    if (ComputerClubIsPlayerHost(playerid, gameid, roomid)) {
        ComputerClubRoomMessage(gameid, roomid, 0x0088FFFF, "[ Компьютерный клуб ]: {cccccc}Хост этого сервера покинул игру.");
        ComputerClubRoomMessage(gameid, roomid, 0x0088FFFF, "[ Компьютерный клуб ]: {cccccc}Если он не вернётся в течение 5 минут, сервер будет отключён.");
        computerClubRoomInfo[gameid][roomid][ccriHostDisconnectTimer] = SetTimerEx("ComputerClubRoomDelete", 1000 * 60 * 5, 0, "dd", gameid, roomid);

        ComputerClubSetRoomState(gameid, roomid, false, COMPUTER_CLUB_ROOM_HOST); // Делаем игру неактивной (дожидается возвращения хоста, ставки возвращаются и т.п.)
    }

    // Спавн на том месте, где он зашел в игру
    SetSpawnInfo(playerid, NO_TEAM, 0, connect_pos[0], connect_pos[1], connect_pos[2], connect_pos[3], 0, 0, 0, 0, 0, 0);
    SpawnPlayer(playerid);
    SetPlayerVirtualWorld(playerid, connect_world); SetPlayerInterior(playerid, connect_interior);

    // Завершение игры при выходе последнего оставшегося в команде участника
    new same_team_players_count = 0;
    foreach (new id : Player) {
        new player_game = GetPlayerActiveComputerGame(id),
            player_room = computerClubPlayerInfo[id][ccpiRoom],
            player_team = computerClubPlayerInfo[id][ccpiTeam];

        if (player_game == gameid && player_room == roomid && teamid == player_team)
            same_team_players_count++;
    }
    switch (e_ComputerClubGames: gameid) {
        case COMPUTER_GAME_TDM: {
            if (same_team_players_count < 1)
                ComputerClubSetRoomState(gameid, roomid, false, COMPUTER_CLUB_ROOM_EXIT, teamid);
        }
    }

    // Убирание текстдрава разминки
    TextDrawHideForPlayer(playerid, COMPUTER_CLUB_WARMUP_TD);
    
    return 1;   
}

// Отправляет сообщение всем игрокам в комнате
stock ComputerClubRoomMessage(gameid, roomid, color, const message[]) {
    foreach (new playerid : Player) {
        if (!computerClubPlayerInfo[playerid][ccpiInGame]) continue;

        if (_:computerClubPlayerInfo[playerid][ccpiID] == gameid && _:computerClubPlayerInfo[playerid][ccpiRoom] == roomid)
            SendClientMessage(playerid, color, message);
    }
}

// Получает количество игроков в комнате
stock ComputerClubGetPlayersCount(gameid, roomid) {
    new count = 0;
    foreach (new playerid : Player) {
        if (!computerClubPlayerInfo[playerid][ccpiInGame]) continue;

        if (_:computerClubPlayerInfo[playerid][ccpiID] == gameid && _:computerClubPlayerInfo[playerid][ccpiRoom] == roomid)
            count++;
    }
    return count;
}

// Получает ID комнаты указанной игры по ее порядковому номеру в списке
stock ComputerClubGetRoomIdByIndex(gameid, index) {
    new counter = 0;
    for (new roomid = 0; roomid < COMPUTER_CLUB_MAX_ROOMS; roomid++) {
        if (!ComputerClubIsRoomExists(gameid, roomid)) continue;
        if (index == counter) return roomid;

        counter++;
    }
    return -1;
}

// Отображает диалог списка серверов
stock ShowComputerClubRoomJoin(playerid, gameid) {
    static const header[] = "{ff9000}Название\t{cccccc}Слоты\t{cccccc}Создатель";
    new dialog_text[sizeof header + (64 + 9 + MAX_PLAYER_NAME) * 20 + 1];
    strcat(dialog_text, header);

    new room_count = 0;
    for (new roomid = 0; roomid < COMPUTER_CLUB_MAX_ROOMS; roomid++) {
        if (!ComputerClubIsRoomExists(gameid, roomid)) continue;

        room_count++;
        
        new hostid = GetPlayerIdByNickname(computerClubRoomInfo[gameid][roomid][ccriHostNickname]);
        new hostid_str[MAX_PLAYER_NAME + 2 + 3 + 1];
        if (hostid > -1)
            format(hostid_str, sizeof hostid_str, "[%d]", hostid);

        format(dialog_text, sizeof dialog_text, "%s\n%s\t{%s}[%d/%d]\t{cccccc}%s%s", dialog_text,
            computerClubRoomInfo[gameid][roomid][ccriName],
            (ComputerClubGetPlayersCount(gameid, roomid) >= computerClubRoomInfo[gameid][roomid][ccriSlotes] ? "cccccc" : "ff9000"),
            ComputerClubGetPlayersCount(gameid, roomid),
            computerClubRoomInfo[gameid][roomid][ccriSlotes],
            computerClubRoomInfo[gameid][roomid][ccriHostNickname],
            (hostid > -1 ? hostid_str : "")
        );
    }

    if (room_count > 0) return ShowDialog(playerid, dComputerClubRoomJoinList, DIALOG_STYLE_TABLIST_HEADERS, "{ff9000}Список серверов", dialog_text, "Выбор", "Закрыть");
    return SendClientMessage(playerid, 0x0088FFFF, "[ Компьютерный клуб ]: {cccccc}Нет доступных комнат для указанной игры");
}

// Отображает диалог подтверждения присоединения к комнате (+ ввод пароля для закрытых сессий)
stock ComputerClubRoomJoinAccept(playerid, gameid, roomid) {
    new bool: is_spectate = GetPVarInt(playerid, "ComputerClubChooseWatchRoom") > 0;
    
    // Если игрок заблокирован
    if (ComputerClubIsPlayerBanned(gameid, roomid, playerid)) {
        SendClientMessage(playerid, 0x0088FFFF, "[ Компьютерный клуб ]: {cccccc}Вы не можете присоединиться к этому серверу, так как были заблокированы");
        return ShowComputerClubRoomJoin(playerid, gameid);
    }

    // Если на сервере нет мест
    if (ComputerClubIsRoomFull(gameid, roomid) && !is_spectate)
        return ShowComputerClubRoomJoin(playerid, gameid);

    // Если на сервере нет игроков, и игрок пытается зайти в наблюдатели
    if (ComputerClubIsRoomEmpty(gameid, roomid) && is_spectate) {
        SendClientMessage(playerid, 0x0088FFFF, "[ Компьютерный клуб ]: {cccccc}На этом сервере нет игроков для наблюдения");
        return ShowComputerClubRoomJoin(playerid, gameid);
    }

    // Если на сервере стоит запрет на просмотр и игрок пытается зайти в наблюдатели
    if (!computerClubRoomInfo[gameid][roomid][ccriViewAccess] && is_spectate) {
        SendClientMessage(playerid, 0x0088FFFF, "[ Компьютерный клуб ]: {cccccc}Настройки этого сервера запрещают просмотр игры");
        return ShowComputerClubRoomJoin(playerid, gameid);
    }

    new bool: is_public = bool: ComputerClubIsRoomPublic(gameid, roomid);

    new dialog_text[1024];
    format(dialog_text, sizeof dialog_text, "{cccccc}Название: {ff9000}%s\n{cccccc}Игроки: {ff9000}[%d/%d]\n{cccccc}Создатель: {ff9000}%s\n\n{cccccc}",
        computerClubRoomInfo[gameid][roomid][ccriName],
        ComputerClubGetPlayersCount(gameid, roomid),
        computerClubRoomInfo[gameid][roomid][ccriSlotes],
        computerClubRoomInfo[gameid][roomid][ccriHostNickname]
    );

    if (!is_spectate) {
        strcat(dialog_text, is_public ? "Вы действительно хотите присоединиться к этому серверу?" : "Введите пароль для подтверждения входа на сервер:");
    } else {
        strcat(dialog_text, is_public ? "Вы действительно хотите присоединиться к этому серверу в качестве наблюдателя?" : "Введите пароль для подтверждения входа на сервер в качестве наблюдателя:");
    }
    
    return ShowDialog(playerid, dComputerClubRoomJoinAccept, is_public ? DIALOG_STYLE_MSGBOX : DIALOG_STYLE_INPUT, "{ff9000}Подтверждение входа", dialog_text, "Вход", "Назад");
}

forward ComputerClubRoomDelete(gameid, roomid);
public ComputerClubRoomDelete(gameid, roomid) {
    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;

    foreach (new playerid : Player) {
        if (!computerClubPlayerInfo[playerid][ccpiInGame]) continue;

        if (ComputerClubIsPlayerInRoom(playerid, gameid, roomid)) {
            SendClientMessage(playerid, 0x0088FFCC, "[ Компьютерный клуб ]: {cccccc}Сервер был отключён, вы будете возвращены на прежнее место");
            ComputerClubRoomExit(playerid, COMPUTER_CLUB_D_REASON_SELF);
        }
    }
    
    memset(computerClubRoomInfo[gameid][roomid], 0);

    return 1;
}

// Отображает диалог изменения статуса комнате (остановить или запустить игру на сервере)
stock ComputerClubShowSetRoomState(playerid) {
    if (!ComputerClubIsPlayerHost(playerid)) return 0;

    new gameid = GetPlayerActiveComputerGame(playerid),
        roomid = computerClubPlayerInfo[playerid][ccpiRoom];
    if (gameid < 0 || roomid < 0) return 0;

    new bool: status = computerClubRoomInfo[gameid][roomid][ccriStarted];
    new room_bet = computerClubRoomInfo[gameid][roomid][ccriBet];

    new title[64], dialog_text[512];
    if (status) {
        strcat(title, "{cd5700}Завершение игры");
        format(dialog_text, sizeof dialog_text, "{cccccc}Вы можете закончить игру досрочно\n\nВ этом случае все игроки будут возвращены на свои места, а прогресс сброшен\n\nСтавка комнаты будет возмещена всем присутствующим игрокам {ff9000}($%d)", room_bet);
    } else {
        strcat(title, "{99ff99}Запуск игры");
        format(dialog_text, sizeof dialog_text, "{cccccc}При запуске игры все участники комнаты будут возрождены на своих местах\n\nСо всех игроков автоматически будет снята ставка комнаты {ff9000}($%d)\n{cccccc}Если хост сервера покинет игру или она завершится принудительно, деньги будут возвращены участникам", room_bet);
    }

    return ShowDialog(playerid, dComputerClubSetRoomState, DIALOG_STYLE_MSGBOX, title, dialog_text, "Ок", "Назад");
}

// Спавнит игрока комп. клуба (обертка под таймер)
forward ComputerClubSpawnPlayer(id);
public ComputerClubSpawnPlayer(id) {
    ComputerClubSetSpectateMode(id, false);
    return 1;
}

// Обработчик победы в раунде (принимает номер проигравшей/победившей команды)
stock ComputerClubWinRoundHandler(gameid, roomid, win_team = -1, lose_team = -1) {
    computerClubRoomInfo[gameid][roomid][ccriRound]++;

    // Получаем номер второй команды (чтобы знать win_team и lose_team)
    foreach (new id : Player) {
        if (ComputerClubIsPlayerInRoom(id, gameid, roomid)) {
            new team = win_team > -1 ? win_team : (lose_team > -1 ? lose_team : -1);
            if (team == -1)
                return 0;

            new player_team = computerClubPlayerInfo[id][ccpiTeam];
            if (player_team != team) {
                if (win_team < 0) win_team = player_team;
                else if (lose_team < 0) lose_team = player_team;

                break;
            }
        }
    }

    // Прибавляем победу команде
    computerClubRoomInfo[gameid][roomid][ccriTeamScores][win_team]++;

    // Если количество побед равняется максимальному, значит игра завершена победой этой команды
    for (new i = 0; i < COMPUTER_CLUB_MAX_TEAMS; i++)
        if (computerClubRoomInfo[gameid][roomid][ccriTeamScores][i] >= computerClubRoomInfo[gameid][roomid][ccriMaxRounds]) {
            ComputerClubSetRoomState(gameid, roomid, false, COMPUTER_CLUB_ROOM_END, i);
            break;
        }
    
    // Спавним наблюдающих для следующего раунда
    foreach (new id : Player)
        if (ComputerClubIsPlayerInRoom(id, gameid, roomid))
            SetTimerEx("ComputerClubSpawnPlayer", 2000, 0, "d", id);

    // Выводим сообщение о победном раунде одной из команд
    new team_color[2][9];
    for (new i = 0; i < 2; i++)
        strmid(team_color[i], computerClubTeamInfo[gameid][roomid][i], 0, 8);
    
    new message[128];
    format(message, sizeof message, "Команда %s {cccccc}одержала победу в этом раунде: [%s%d{cccccc}-%s%d{cccccc}]",
        computerClubTeamInfo[gameid][roomid][win_team],
        team_color[0], computerClubRoomInfo[gameid][roomid][ccriTeamScores][0],
        team_color[1], computerClubRoomInfo[gameid][roomid][ccriTeamScores][1]
    );

    ComputerClubRoomMessage(gameid, roomid, 0xCCCCCCFF, message);
    
    return 1;
}
// Обработчик победы (принимает номер проигравшей/победившей команды или игрока)
stock ComputerClubWinHandler(gameid, roomid, win_team = -1, lose_team = -1, win_playerid = -1) {
    foreach (new id : Player) {
        new player_game = GetPlayerActiveComputerGame(id),
            player_room = computerClubPlayerInfo[id][ccpiRoom],
            player_team = computerClubPlayerInfo[id][ccpiTeam];
        
        if (player_game != gameid || player_room != roomid) continue;
        
        new bool: is_winner = (win_team > -1 && player_team == win_team) || (win_playerid > -1 && id == win_playerid) || (lose_team > -1 && player_team != lose_team);
        if (is_winner) {
            SetPVarInt(id, "ComputerClubIsWinner", 1);
            // [ Вывод сообщения о выигрыше ]
        } else {
            // [ Вывод сообщения о проигрыше ]
        }
    }

    ComputerClubPayout(gameid, roomid);

    return 1;
}

// Узнает, пуста ли комната
stock ComputerClubIsRoomEmpty(gameid, roomid) {
    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;
    return ComputerClubGetPlayersCount(gameid, roomid) < 1;
}

// Узнает, занята ли комната (нет мест в командах и(-или) нет слотов)
stock ComputerClubIsRoomFull(gameid, roomid) {
    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;
    if (ComputerClubGetPlayersCount(gameid, roomid) >= computerClubRoomInfo[gameid][roomid][ccriSlotes]) return 1;

    new teams[COMPUTER_CLUB_MAX_TEAMS];
    foreach (new id : Player)
        if (ComputerClubIsPlayerInRoom(id, gameid, roomid))
            teams[computerClubPlayerInfo[id][ccpiTeam]]++;

    for (new i = 0; i < sizeof teams; i++)
        if (teams[i] < computerClubRoomInfo[gameid][roomid][ccriTeamSize])
            return 0;

    return 1;
}

// Проверяет, следит ли игрок за кем-либо в комп. клубе
stock ComputerClubIsSpectate(playerid) {
    return (GetPVarInt(playerid, "ComputerClubSpectateTeam") - 2) >= -1;
}

// Проверяет, является ли игрок наблюдателем (следит, но не присоединен к комнате)
stock ComputerClubIsSpectator(playerid) {
    return ComputerClubIsSpectate(playerid) && GetPlayerActiveComputerGame(playerid) < 0;
}

// Получает данные о наблюдателе
stock ComputerClubGetSpectatorData(playerid, &gameid, &roomid, &teamid, &id) {
    if (!ComputerClubIsSpectate(playerid))
        return;

    gameid = GetPVarInt(playerid, "ComputerClubSpectateGame");
    roomid = GetPVarInt(playerid, "ComputerClubSpectateRoom");
    teamid = GetPVarInt(playerid, "ComputerClubSpectateTeam") - 2;
    id = GetPVarInt(playerid, "ComputerClubSpectateId");
}

// Переводит игрока в режим слежки за указанной командой (-1 это игроки любой команды)
// (надо сделать обработку дисконнекта, чтобы вызывалось переключение на следующего)
stock ComputerClubSetSpectateMode(playerid, bool: status = true, gameid = -1, roomid = -1, teamid = -1) {
    if (!status) {
        DeletePVar(playerid, "ComputerClubSpectateTeam");
        DeletePVar(playerid, "ComputerClubSpectateGame");
        DeletePVar(playerid, "ComputerClubSpectateRoom");
        DeletePVar(playerid, "ComputerClubSpectateId");

        // [ тут скрывать меню спека ]
        
        TogglePlayerSpectating(playerid, 1);
        return TogglePlayerSpectating(playerid, 0);
    }

    if (gameid == -1 || roomid == -1) {
        gameid = GetPlayerActiveComputerGame(playerid);
        roomid = computerClubPlayerInfo[playerid][ccpiRoom];
    }

    // Ставим в спек за первым игроком в команде
    foreach (new id : Player) {
        if (ComputerClubIsPlayerInRoom(id, gameid, roomid)) {
            if (playerid == id) continue;
            
            new player_team = computerClubPlayerInfo[id][ccpiTeam];

            if (teamid == -1 || player_team == teamid) {
                ComputerClubSpectatePlayer(playerid, id);

                SetPVarInt(playerid, "ComputerClubSpectateTeam", teamid + 2);
                SetPVarInt(playerid, "ComputerClubSpectateGame", gameid);
                SetPVarInt(playerid, "ComputerClubSpectateRoom", roomid);
                SetPVarInt(playerid, "ComputerClubSpectateId", id);

                // [ тут сделать вывод текстдрава с переключением игроков в спеке ]
                return 1;
            }
        }
    }
    
    // Если не за кем следить - ничего не делаем
    return 0;
}

// Переводит в спек за указанной командой (обертка для использования в таймере)
forward ComputerClubSpecTeam(playerid, teamid);
public ComputerClubSpecTeam(playerid, teamid) { ComputerClubSetSpectateMode(playerid, .teamid = teamid); }

// Обертка под переход в спек (присваивает нужный вирт мир и интерьер перед ним)
stock ComputerClubSpectatePlayer(playerid, id) {
    new world = GetPlayerVirtualWorld(id),
        interior = GetPlayerInterior(id);

    TogglePlayerSpectating(playerid, 1);
    SetPlayerVirtualWorld(playerid, world);
    SetPlayerInterior(playerid, interior);
    PlayerSpectatePlayer(playerid, id);
}

// Меняет игрока в спеке вперед/назад, если игрок в режиме слежки (SetSpectateMode)
stock ComputerClubSwitchSpectate(playerid, bool: next) {
    new gameid = GetPVarInt(playerid, "ComputerClubSpectateGame"),
        roomid = GetPVarInt(playerid, "ComputerClubSpectateRoom"),
        spectate_id = GetPVarInt(playerid, "ComputerClubSpectateId");

    new spectate_team = GetPVarInt(playerid, "ComputerClubSpectateTeam") - 2;

    if (spectate_team < -1) return 0; // Если игрок не в слежке

    new players[MAX_PLAYERS] = {-1, ...};
    new players_i = 0;

    new spectate_id_index = -1;
    foreach (new id : Player) {
        if (ComputerClubIsPlayerInRoom(id, gameid, roomid)) {
            if (playerid == id) continue;

            new player_team = computerClubPlayerInfo[id][ccpiTeam];
            if (spectate_team == -1 || spectate_team == player_team) {
                players[players_i] = id;

                if (spectate_id == id)
                    spectate_id_index = players_i;

                players_i++;
            }
        }
    }
    if (players_i < 1) return ComputerClubSetSpectateMode(playerid, false);

    new new_spectate_id = -1;
    if (spectate_id_index > -1) {
        new last_index = players_i - 1;

        if (!next)
            new_spectate_id = players[(spectate_id_index == 0) ? (last_index) : (spectate_id_index - 1)];
        else
            new_spectate_id = players[(spectate_id_index == last_index) ? 0 : (spectate_id_index + 1)];
    }

    if (new_spectate_id > -1) {
        ComputerClubSpectatePlayer(playerid, new_spectate_id);
        SetPVarInt(playerid, "ComputerClubSpectateId", new_spectate_id);
    } else {
        ComputerClubSetSpectateMode(playerid, false);
    }

    return 1;
}

// Выплачивает игрокам в комнате выигрыш, деля общий банк комнаты на всех победителей
stock ComputerClubPayout(gameid, roomid) {
    new total_bet = computerClubRoomInfo[gameid][roomid][ccriTotalBet];
    if (total_bet == 0) return 0; // Ничего не делаем, если игра без ставки

    // Узнаем победителей и высчитываем сумму выигрыша для каждого из них
    new winners[MAX_PLAYERS] = {-1, ...}, winners_count = 0;
    foreach (new id : Player) {
        if (ComputerClubIsPlayerInRoom(id, gameid, roomid)) {
            new bool: is_winner = bool: GetPVarInt(id, "ComputerClubIsWinner");
            DeletePVar(id, "ComputerClubIsWinner");
            if (is_winner) { winners[winners_count] = id; winners_count++; }
        }
    }

    // Выплачиваем выигрыш
    new prize = _:(total_bet / winners_count);
    for (new i = 0; i < winners_count; i++) {
        new playerid = winners[i];
        
        SetPlayerMoney(playerid, playerInfo[playerid][pMoney] + prize);

        // Оповещение о выигрыше
        PlayerPlaySound(playerid, 31205, 0.0, 0.0, 0.0);
        static const text_fmt[] = "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~$%d";
        new text[sizeof text_fmt - 2 + 15];
        format(text, sizeof text, text_fmt, prize);
        GameTextForPlayer(playerid, text, 2000, 3);
    }

    // Обнуляем банк комнаты
    computerClubRoomInfo[gameid][roomid][ccriTotalBet] = 0;

    return 1;
}

// Забирает у игроков сумму, необходимую для игры
stock ComputerClubPayin(gameid, roomid) {
    new room_bet = computerClubRoomInfo[gameid][roomid][ccriBet];
    if (room_bet == 0) return 0; // Ничего не делаем, если игра без ставки

    foreach (new id : Player) {
        // Если игрок в комнате и у него есть деньги на оплату ставки
        if (ComputerClubIsPlayerInRoom(id, gameid, roomid)) {
            // Кик игрока, если у него недостаточно денег для ставки
            if (playerInfo[id][pMoney] - room_bet < 0) {
                new teamid = computerClubPlayerInfo[id][ccpiTeam];
                ComputerClubRoomExit(id, COMPUTER_CLUB_D_REASON_NO_BET);
                
                foreach (new _id : Player) {
                    new bool: empty_team = false;
                    if (ComputerClubIsPlayerInRoom(_id, gameid, roomid) && computerClubPlayerInfo[_id][ccpiTeam] == teamid) {
                        empty_team = true;
                        break;
                    }

                    // Завершаем игру, возвращаем ставки (при ее наличии)
                    if (empty_team) ComputerClubSetRoomState(gameid, roomid, false, COMPUTER_CLUB_ROOM_HOST);
                }

                continue;
            }

            SetPlayerMoney(id, playerInfo[id][pMoney] - room_bet);
            computerClubRoomInfo[gameid][roomid][ccriTotalBet] += room_bet;

            // Оповещение о принятии ставки
            static const text_fmt[] = "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~$%d";
            new text[sizeof text_fmt - 2 + 15];
            format(text, sizeof text, text_fmt, room_bet);
            GameTextForPlayer(id, text, 2000, 3);
        }
    }

    return 1;
}

// Узнает, находится ли игрок в комнате (указанной*)
stock ComputerClubIsPlayerInRoom(playerid, gameid = -1, roomid = -1) {
    if (gameid == -1 || roomid == -1)
        return computerClubPlayerInfo[playerid][ccpiInGame];
    
    return (GetPlayerActiveComputerGame(playerid) == gameid && computerClubPlayerInfo[playerid][ccpiRoom] == roomid);
}

// Устанавливает статус комнате [Активна игра или нет]
stock ComputerClubSetRoomState(gameid, roomid, bool: status, e_ComputerClubToggleRoomReasons: reason = COMPUTER_CLUB_ROOM_END, data = -1) {
    if (!ComputerClubIsRoomExists(gameid, roomid)) return 0;
    if (computerClubRoomInfo[gameid][roomid][ccriStarted] == status) return 0;

    computerClubRoomInfo[gameid][roomid][ccriStarted] = status;

    if (status) { // При запуске игры
        // Обнуляем данные предыдущей игры
        computerClubRoomInfo[gameid][roomid][ccriRound] = 0;
        for (new i = 0; i < COMPUTER_CLUB_MAX_TEAMS; i++)
            computerClubRoomInfo[gameid][roomid][ccriTeamScores][i] = 0;

        ComputerClubPayin(gameid, roomid); // Берем ставку со всех игроков в комнате (при её наличии)
    }
    
    new room_bet = computerClubRoomInfo[gameid][roomid][ccriBet];
    new bool: has_bet = room_bet > 0;
    foreach (new id : Player) {
        new player_game = GetPlayerActiveComputerGame(id),
            player_room = computerClubPlayerInfo[id][ccpiRoom];

        if (player_game == gameid && player_room == roomid) {
            // Оповещение о смене статуса игры
            PlayerPlaySound(id, status ? 3200 : 5203, 0.0, 0.0, 0.0);

            // Обработка смены статуса игры
            if (status) {
                SpawnPlayer(id); // Спавним игрока (выдача оружия и все остальное есть в обработчике спавна)
            } else {
                if (has_bet && reason == COMPUTER_CLUB_ROOM_HOST) { // Если игра со ставкой, но завершена досрочно хостом
                    SetPlayerMoney(id, playerInfo[id][pMoney] + room_bet); // Возвращаем размер ставки игроку назад
                    
                    // Оповещение о возврате ставки
                    static const text_fmt[] = "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~$%d";
                    new text[sizeof text_fmt - 2 + 15];
                    format(text, sizeof text, text_fmt, room_bet);
                    GameTextForPlayer(id, text, 2000, 3);
                } else if (reason == COMPUTER_CLUB_ROOM_EXIT) {
                    // Если режим завершается по причине выхода одной из команд
                    return ComputerClubWinHandler(gameid, roomid, .lose_team = data);
                } else if (reason == COMPUTER_CLUB_ROOM_END) {
                    // Если режим завершен выигрышем одной из команд
                    return ComputerClubWinHandler(gameid, roomid, .win_team = data);
                }
            }
        }
    }

    if (!status) {
        // Отображение текстдрава разминки
        if (gameid == _:COMPUTER_GAME_TDM) {
            foreach (new id : Player) {
                if (ComputerClubIsPlayerInRoom(id, gameid, roomid))
                    TextDrawShowForPlayer(id, COMPUTER_CLUB_WARMUP_TD);
            }
        }
    } else {
        foreach (new id : Player) {
            if (ComputerClubIsPlayerInRoom(id, gameid, roomid)) {
                TextDrawHideForPlayer(id, COMPUTER_CLUB_WARMUP_TD); // Скрытие текстдрава разминки
            }
        }
    }

    return 1;
}

// Обработка дисконнекта игрока [ее вызов помещён в OnPlayerDisconnect]
stock ComputerClubOnPlayerDisconnect(playerid) {
    ComputerClubRoomExit(playerid, COMPUTER_CLUB_D_REASON_SELF);
}

// Получает координаты указанного спавна
stock ComputerClubGetSpawnInfo(locationid, spawnid, &Float: x, &Float: y, &Float: z, &Float: a) {
    x = computerClubLocationSpawn[locationid][spawnid][cclsPos][0],
    y = computerClubLocationSpawn[locationid][spawnid][cclsPos][1],
    z = computerClubLocationSpawn[locationid][spawnid][cclsPos][2],
    a = computerClubLocationSpawn[locationid][spawnid][cclsPos][3];
}

// Обработка спавна игрока [ее вызов помещен в OnPlayerSpawn (внутри PlayerSpawnHandler), кинете куда нужно]
stock ComputerClubOnPlayerSpawn(playerid) {
    new gameid = GetPlayerActiveComputerGame(playerid);
    if (gameid > -1) {
        // Назначаем уникальный виртуальный мир для участников комнаты
        new virtual_world_str[10];
        format(virtual_world_str, sizeof virtual_world_str, "%d%d", gameid, computerClubPlayerInfo[playerid][ccpiRoom] + 1);
        SetPlayerVirtualWorld(playerid, strval(virtual_world_str));
        
        computerClubPlayerInfo[playerid][ccpiIsDead] = false;

        new roomid = computerClubPlayerInfo[playerid][ccpiRoom];
        new teamid = computerClubPlayerInfo[playerid][ccpiTeam];

        new locationid = computerClubRoomInfo[gameid][roomid][ccriLocation];

        // Определения цвета никнейма
        new nick_color, team_color[10];
        strmid(team_color, computerClubTeamInfo[gameid][roomid][teamid], 1, 7); strcat(team_color, "ff");
        sscanf(team_color, "x", nick_color);

        new spawnid = ComputerClubGetRandomSpawn(gameid, locationid, teamid);
        new Float: x, Float: y, Float: z, Float: a; ComputerClubGetSpawnInfo(locationid, spawnid, x, y, z, a);
        SetPlayerPos(playerid, x, y, z); SetPlayerFacingAngle(playerid, a);
        SetSpawnInfo(playerid, teamid, GetPlayerSkin(playerid), x, y, z, a, 0, 0, 0, 0, 0, 0);

        SetCameraBehindPlayer(playerid);
        SetPlayerColor(playerid, nick_color);

        // Выдача оружия
        ResetPlayerWeapons(playerid);
        if (gameid == _:COMPUTER_GAME_TDM)
            ComputerClubSetPlayerWeapons(playerid);

        // Установка здоровья/брони
        SetPlayerHealth(playerid, computerClubRoomInfo[gameid][roomid][ccriMaxHealth]);
        SetPlayerArmour(playerid, computerClubRoomInfo[gameid][roomid][ccriMaxArmor]);

        // Устанавливаем команду (игроки своей команды не будут получать урон)
        SetPlayerTeam(playerid, computerClubPlayerInfo[playerid][ccpiTeam]);

        return 0;
    }
    return 1;
}

// Обработка смерти [ее вызов помещён в OnPlayerDeath]
stock ComputerClubOnPlayerDeath(playerid, killerid, reason) {
    new gameid = GetPlayerActiveComputerGame(playerid),
        roomid = computerClubPlayerInfo[playerid][ccpiRoom],
        teamid = computerClubPlayerInfo[playerid][ccpiTeam];
    if (gameid > -1) {
        if (!computerClubRoomInfo[gameid][roomid][ccriStarted]) return 0;
        switch (e_ComputerClubGames: gameid) {
            // Обработка смерти TDM
            case COMPUTER_GAME_TDM: {
                // [ нужно сделать чтобы переключался на некст доступного члена команды если умер тот за кем следил ]
                computerClubPlayerInfo[playerid][ccpiIsDead] = true;

                new teammates_alive_count = 0;
                foreach (new id : Player) {
                    new player_game = GetPlayerActiveComputerGame(id),  
                        player_team = computerClubPlayerInfo[id][ccpiTeam];
                    if (player_game == gameid) {
                        if (ComputerClubIsTeammates(playerid, id) && !computerClubPlayerInfo[id][ccpiIsDead] && player_team == teamid)
                            teammates_alive_count++;
                    }
                }

                // Отображение спека за убийцей в течение двух секунд
                if (killerid != INVALID_PLAYER_ID) {
                    ComputerClubSpectatePlayer(playerid, killerid);
                    
                    static const text_fmt[] = "~r~KILLED BY %s";
                    new text[sizeof text_fmt - 2 + MAX_PLAYER_NAME];
                    format(text, sizeof text, text_fmt, playerInfo[killerid][pName]);
                    GameTextForPlayer(playerid, text, 2000, 4);
                }

                // Уводим в спек за своей командой через две секунды
                SetTimerEx("ComputerClubSpecTeam", 2000, 0, "dd", playerid, teamid);

                // Если все участники команды умерли
                if (teammates_alive_count == 0) {
                    ComputerClubWinRoundHandler(gameid, roomid, .lose_team = teamid);
                }
            }
            case COMPUTER_GAME_COPCHASE: {

            }
        }
    }

    return 1;
}

// Устанавливает указанную локацию и переспавнивает игроков
stock ComputerClubChangeMap(gameid, roomid, locationid) {
    // Проверка устанавливаемой карты на валидность
    if (locationid < 0 || locationid >= COMPUTER_CLUB_MAX_GAME_LOCATIONS) return 0;
    {
        new i;
        for(; i < COMPUTER_CLUB_MAX_GAME_LOCATIONS; i++) {
            if (computerClubGameInfo[gameid][ccgiLocations][i] == locationid)
                break;
        }
        if (i == COMPUTER_CLUB_MAX_GAME_LOCATIONS - 1)
            return 0;
    }
    
    // Установка карты
    computerClubRoomInfo[gameid][roomid][ccriLocation] = locationid;
    new str[100]; format(str, sizeof str, "[ Компьютерный клуб ]: {cccccc}Карта текущего сервера изменена: {ff9000}%s", computerClubLocationInfo[locationid][ccliName]);
    foreach (new id : Player) {
        new player_game = GetPlayerActiveComputerGame(id),
            player_room = computerClubPlayerInfo[id][ccpiRoom];

        if (player_game != gameid || player_room != roomid) continue;

        SpawnPlayer(id);
        SendClientMessage(id, 0x0088FFFF, str);
    }

    return 1;
}

// Обработка ввода сообщений в чат [ее вызов помещен в OnPlayerText]
stock ComputerClubOnPlayerText(playerid, const text[]) {
    if (ComputerClubIsSpectate(playerid)) {
        SendClientMessage(playerid, 0xCCCCCCFF, "[ Мысли ]: Я наблюдаю за игрой");
        return 0;
    }

    new gameid = GetPlayerActiveComputerGame(playerid);
    if (gameid > -1) {
        switch (e_ComputerClubGames: gameid) {
            case COMPUTER_GAME_TDM: {

            }
            case COMPUTER_GAME_COPCHASE: {

            }
            case COMPUTER_GAME_CARGORAIDS: {

            }
        }
    }
    return 1;
}

// Обработка ввода команд [ее вызов помещен в OnPlayerCommandText]
stock ComputerClubCommandReceived(playerid, const cmd[], const params[], flags) {
    new gameid = GetPlayerActiveComputerGame(playerid);
    if (gameid < 0) return 1;

    static blacklist_commands[] = {"/pay"}; // [ Сюда нужно добавить команды, которые не должны быть доступны в комп. клубе ]
    for (new i = 0; i < sizeof blacklist_commands; i++)
        if (strfind(cmd, blacklist_commands[i], true) != -1) {
            SendClientMessage(playerid, 0xCCCCCCFF, "[ Мысли ]: Сейчас я не могу использовать это..");
            return 0;
        }
    
    return 1;
}

// Проверяет, является ли игрок хостом комнаты
stock ComputerClubIsPlayerHost(playerid, gameid = -1, roomid = -1) {
    if (gameid == -1 || roomid == -1) {
        if (!computerClubPlayerInfo[playerid][ccpiInGame]) return false;
        gameid = computerClubPlayerInfo[playerid][ccpiID];
        roomid = computerClubPlayerInfo[playerid][ccpiRoom];
    }
    return (computerClubRoomInfo[gameid][roomid][ccriHostID] == playerInfo[playerid][pID]);
}

CMD:compclub(playerid) {
    ShowComputerClubMenu(playerid);
    return 1;
}
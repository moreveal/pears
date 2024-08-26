stock PDatabase_Initialize()
{
    // Создание пикапов
    new vent_count = 0;
    for (new i = 0; i < sizeof(policeDatabasePickups); i++)
    {
        new pickup_model, pickup_color, pickup_text[128];
        switch (policeDatabasePickups[i][pdpType])
        {
            case POLICE_DATABASE_PICKUP_HACK: {
                pickup_model = 19893;
                strcat(pickup_text, "Используйте ноутбук для подключения к базе данных\n{cccccc}[ N ]");
                pickup_color = 0xFA2B1FFF;
            }
            case POLICE_DATABASE_PICKUP_VENT: {
                format(pickup_text, sizeof(pickup_text), "Вентиляция №%d\n{cccccc}[ ALT ]", ++vent_count);
                pickup_color = 0xB0C4DEFF;
            }
            case POLICE_DATABASE_PICKUP_SHIELD: {
                pickup_model = 19627;
                strcat(pickup_text, "Используйте монтировку для вскрытия электрощитка\n{cccccc}[ ALT ]");
                pickup_color = 0xFF9000FF;
            }
            case POLICE_DATABASE_PICKUP_INFO: {
                pickup_model = 1239;

                switch (policeDatabasePickups[i][pdpFraction]) {
                    case 0: {
                        strcat(pickup_text, "Серверная LSPD\n{cccccc}Подробнее [ ALT ]");
                        pickup_color = 0x0066FFFF;
                    }
                    case 1: {
                        strcat(pickup_text, "Серверная FBI\n{cccccc}Подробнее [ ALT ]");
                        pickup_color = 0x6666FFFF;
                    }
                    default: continue;
                }
            }
            case POLICE_DATABASE_PICKUP_THERMITE: {
                strcat(pickup_text, "[PLACEHOLDER]"); // Поменяется самостоятельно
                pickup_color = 0xFF6347FF;
            }
            default: continue;
        }

        new Float: x, Float: y, Float: z;
        if (!isnull(pickup_text)) {
            x = policeDatabasePickups[i][pdpX];
            y = policeDatabasePickups[i][pdpY];
            z = policeDatabasePickups[i][pdpZ];

            if (policeDatabasePickups[i][pdpType] == POLICE_DATABASE_PICKUP_VENT) {
                new objects[10], count;
                count = Streamer_GetNearbyItems(x, y, z, STREAMER_TYPE_OBJECT, objects, .range = 10.0);
                for (new j = 0; j < min(sizeof(objects), count); j++)
                {
                    new objectid = objects[j];
                    if (!IsValidDynamicObject(objectid)) break;

                    if (GetDynamicObjectModel(objectid) == 914) {
                        GetDynamicObjectPos(objectid, x, y, z);
                        frontme(INVALID_PLAYER_ID, 0.05, x, y, z, policeDatabasePickups[i][pdpA]);
                        break;
                    }
                }
            }
            
            CreateDynamic3DTextLabel(
                pickup_text, pickup_color,
                x, y, z,
                4.0, .testlos = 1, .worldid = policeDatabasePickups[i][pdpWorld], .interiorid = policeDatabasePickups[i][pdpInterior]
            );

            if (policeDatabasePickups[i][pdpExitX] != 0.0 && policeDatabasePickups[i][pdpExitY] != 0.0)
            {
                x = policeDatabasePickups[i][pdpExitX];
                y = policeDatabasePickups[i][pdpExitY];
                z = policeDatabasePickups[i][pdpExitZ];
                
                if (policeDatabasePickups[i][pdpType] == POLICE_DATABASE_PICKUP_VENT) {
                    new objects[10], count;
                    count = Streamer_GetNearbyItems(x, y, z, STREAMER_TYPE_OBJECT, objects, .range = 10.0);
                    for (new j = 0; j < min(sizeof(objects), count); j++)
                    {
                        new objectid = objects[j];
                        if (!IsValidDynamicObject(objectid)) break;

                        if (GetDynamicObjectModel(objectid) == 914) {
                            GetDynamicObjectPos(objectid, x, y, z);
                            frontme(INVALID_PLAYER_ID, 0.05, x, y, z, policeDatabasePickups[i][pdpExitA]);
                            break;
                        }
                    }
                }
                CreateDynamic3DTextLabel(
                    pickup_text, pickup_color,
                    x, y, z,
                    4.0, .testlos = 1, .worldid = policeDatabasePickups[i][pdpExitWorld], .interiorid = policeDatabasePickups[i][pdpExitInterior]
                );
            }

            if (policeDatabasePickups[i][pdpType] == POLICE_DATABASE_PICKUP_THERMITE) PDatabase_ExplodeProcessUpdateLabel(policeDatabasePickups[i][pdpFraction]);
        }
        if (pickup_model != 0) {
            CreateDynamicPickup(pickup_model, 1,
                policeDatabasePickups[i][pdpX], policeDatabasePickups[i][pdpY], policeDatabasePickups[i][pdpZ],
                policeDatabasePickups[i][pdpWorld], policeDatabasePickups[i][pdpInterior]
            );
        }
    }

    // Сбор генераторов на крыше
    {
        new objects[80], count;
        
        new Float: fractionGeneratorPositions[][] = {
            // X, Y, Z, Range
            {1588.7064, -1638.9824, 19.8792},
            {2130.595947, 2421.590332, 64.239562}
        };

        for (new fractionid = 0; fractionid < sizeof(fractionGeneratorPositions); fractionid++)
        {
            count = Streamer_GetNearbyItems(
                fractionGeneratorPositions[fractionid][0], fractionGeneratorPositions[fractionid][1], fractionGeneratorPositions[fractionid][2],
                STREAMER_TYPE_OBJECT, objects, .range = 100.0, .worldid = 0
            );
            for (new quan, i = 0; i < min(sizeof(objects), count); i++)
            {
                new objectid = objects[i];
                if (GetDynamicObjectModel(objectid) == 1687)
                {
                    policeDatabaseGeneratorInfo[fractionid][quan++][pdgiObjectID] = objectid;

                    new Float: x, Float: y, Float: z;
                    GetDynamicObjectPos(objectid, x, y, z);

                    new str[64];
                    format(str, sizeof(str), "Генератор №%d\n{cccccc}[ ALT ]", quan);

                    CreateDynamic3DTextLabel(
                        str, 0xB0C4DEFF,
                        x, y, z,
                        3.0, .testlos = 0, .worldid = GetDynamicObjectVirtualWorld(objectid), .interiorid = GetDynamicObjectInterior(objectid)
                    );
                }
            }
        }
    }

    // Создание скрытых объектов горения в интерьере FBI
    CreateDynamicObject(18691, 2408.119384, 2538.662841, 2115.853027, 0.000000, 180.000000, 0.000000, 228, 217, -1, 300.00, 300.00); 
    CreateDynamicObject(18717, 2408.119384, 2538.662841, 2114.771240, 180.000000, 0.000000, 0.000000, 228, 217, -1, 300.00, 300.00); 
    CreateDynamicObject(18718, 2408.119384, 2538.662841, 2114.771240, 170.000000, 0.000000, 0.000000, 228, 217, -1, 300.00, 300.00); 
    CreateDynamicObject(18718, 2408.119384, 2538.662841, 2114.771240, 190.000000, 0.000000, 0.000000, 228, 217, -1, 300.00, 300.00);

    return 1;
}

stock PDatabase_IsPlayerNearHack(playerid, fractionid)
{
    for (new i = 0; i < sizeof(policeDatabasePickups); i++)
    {
        if (policeDatabasePickups[i][pdpFraction] == fractionid) {
            if (policeDatabasePickups[i][pdpType] == POLICE_DATABASE_PICKUP_HACK) {
                if (IsPlayerInRangeOfPoint(playerid, 2.0, policeDatabasePickups[i][pdpX], policeDatabasePickups[i][pdpY], policeDatabasePickups[i][pdpZ])) {
                    return 1;
                }
            }
        }
    }
    
    return 0;
}

// Проверка доступности базы данных для взлома (Разработчик и выше игнорируют проверку)
stock PDatabase_CheckHackAvailableTime(playerid, fractionid)
{
    if (server != 0 && PlayerInfo[playerid][pSoska] < 22)
    {
        new tmphour, tmpminute, tmpsecond;
        gettime(tmphour, tmpminute, tmpsecond);
        if(tmphour < 12 || tmphour > 22) {
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: База данных отключена! [ Только с 12:00 до 22:00 ]");
            return 1;
        }

        new hackAvailableTime = PDatabase_GetHackAvailableTime(fractionid);
        if (hackAvailableTime > 0) {
            new message[256];
            format(message, sizeof(message), "{FF6347}Сейчас начать взлом базы данных невозможно [ Можно через: %s ]", fine_time(hackAvailableTime));
            ErrorMessage(playerid, message);
            return 1;
        }
    }

    return 0;
}

function PDatabase_HackPassFail(playerid, fractionid)
{
    if (!IsOnline(playerid)) return 0;
    if (policeDatabaseInfo[fractionid][pdiHackerID] != PlayerInfo[playerid][pID]) return 0;
    if (policeDatabasePlayerInfo[playerid][pdpiHackStage] != POLICE_DATABASE_HACK_STAGE_PASSWORD) return 0;
    if (policeDatabaseInfo[fractionid][pdiHacked]) return 0;
    
    PDatabase_ClearPassword(fractionid);
    ErrorMessage(playerid, "{FF6347}Вы не успели угадать пароль за отведённое количество времени");
    PDatabase_HackFail(playerid);

    return 1;
}

stock PDatabase_HackSuccess(playerid)
{
    new fractionid = policeDatabasePlayerInfo[playerid][pdpiFractionID];
    PDatabase_SetHackStage(playerid, fractionid, POLICE_DATABASE_HACK_STAGE_NONE);

    policeDatabaseInfo[fractionid][pdiHacked] = true;
    
    switch (fractionid) {
        case 1: policeDatabaseInfo[fractionid][pdiClearSuspectRemains] = 4;
        default: policeDatabaseInfo[fractionid][pdiClearSuspectRemains] = 2;
    }

    {
        new str[512];
        format(str, sizeof(str), 
            "{99ff66}Взлом базы данных %s произведён успешно!\n\n{cccccc}" \
            \
            "* Теперь вы можете просмотреть информацию об имеющихся подозреваемых, а также очистить им розыск (максимум: %d)\n" \
            "* Для этого вам необходимо вновь воспользоваться ноутбуком рядом с базой данных.",

            PDatabase_GetFractionAcronym(fractionid),
            policeDatabaseInfo[fractionid][pdiClearSuspectRemains]
        );

        SuccessMessage(playerid, str);
    }

    PDatabase_ClearPassword(fractionid);
    policeDatabaseInfo[fractionid][pdiHackerID] = 0;
    policeDatabaseInfo[fractionid][pdiHackAttemptTime] = gettime();
    policeDatabaseInfo[fractionid][pdiLastHackerID] = PlayerInfo[playerid][pID];

    return 1;
}

stock PDatabase_HackFail(playerid)
{
    new fractionid = policeDatabasePlayerInfo[playerid][pdpiFractionID];
    PDatabase_SetHackStage(playerid, fractionid, POLICE_DATABASE_HACK_STAGE_NONE);
    PlayerPlaySound(playerid, 31203);
    PDatabase_SetAlarm(fractionid, true);
    policeDatabaseInfo[fractionid][pdiHackerID] = 0;
    policeDatabaseInfo[fractionid][pdiHackAttemptTime] = gettime();

    return 1;
}

stock PDatabase_Hack_GetBoxPos(playerid, index, &Float: startX, &Float: endX)
{
    if (index < 0 || index >= POLICE_DATABASE_HACK_GAME_TEXTDRAWS - 1 || !IsValidPlayerTextDraw(playerid, policeDatabasePlayerTextDraws[playerid][index])) {
        return 0;
    }
    
    new Float: y;
    PlayerTextDrawGetPos(playerid, policeDatabasePlayerTextDraws[playerid][index], startX, y);
    startX -= 173.0;
    PlayerTextDrawGetTextSize(playerid, policeDatabasePlayerTextDraws[playerid][index], endX, y);
    endX += startX;

    return 1;
}

stock PDatabase_Hack_Pump(playerid) {
    new fractionid = policeDatabasePlayerInfo[playerid][pdpiFractionID];

    if (policeDatabaseInfo[fractionid][pdiHackerID] != PlayerInfo[playerid][pID]) return 0;
    if (policeDatabasePlayerInfo[playerid][pdpiHackStage] != POLICE_DATABASE_HACK_STAGE_GAME) return 0;

    new Float: current, Float: y, index = POLICE_DATABASE_HACK_GAME_TEXTDRAWS - 1;
    PlayerTextDrawGetTextSize(playerid, policeDatabasePlayerTextDraws[playerid][index], current, y);

    for (new i = 5; i < index; i++)
    {
        if (!IsValidPlayerTextDraw(playerid, policeDatabasePlayerTextDraws[playerid][i])) continue;
        if (i < policeDatabasePlayerInfo[playerid][pdpiHackGameCheckpointID]) continue;

        new Float: startX, Float: endX;
        PDatabase_Hack_GetBoxPos(playerid, i, startX, endX);

        if (current >= startX - 0.5 && current <= endX + 0.5) {
            if (i == policeDatabasePlayerInfo[playerid][pdpiHackGameCheckpointID]) break;

            policeDatabasePlayerInfo[playerid][pdpiHackGameCheckpointID] = i;
            PlayerPlaySound(playerid, 6401);
        } else {
            if (i == policeDatabasePlayerInfo[playerid][pdpiHackGameCheckpointID]) continue;

            PDatabase_HackFail(playerid);
        }

        break;
    }

    return 1;
}

function PDatabase_HackDraw(playerid) {
    if (!IsOnline(playerid)) return 0;
    if (policeDatabasePlayerInfo[playerid][pdpiHackStage] != POLICE_DATABASE_HACK_STAGE_GAME) return 0;

    new fractionid = policeDatabasePlayerInfo[playerid][pdpiFractionID];
    if (policeDatabaseInfo[fractionid][pdiHackerID] != PlayerInfo[playerid][pID] // Не взламывает БД
        || DeathInfo[playerid][deathStatus] // Умер (лежит в стадии)
        || !IsPlayerInRangeOfPoint(playerid, 7.0, policeDatabasePlayerInfo[playerid][pdpiX], policeDatabasePlayerInfo[playerid][pdpiY], policeDatabasePlayerInfo[playerid][pdpiZ]) // Далеко от места взлома
    ) {
        PDatabase_HackFail(playerid);
        return 0;
    }

    new start = policeDatabaseInfo[fractionid][pdiHackAttemptTime];
    new current = gettime();
    
    new duration = policeDatabasePlayerInfo[playerid][pdpiHackGameDuration];

    new Float: progress = float(current - start) / float(duration);

    // Срабатывание сигнализации на определенном уровне мини-игры, в зависимости от количества разрушенных генераторов
    {
        new Float: generators_ratio = float(PDatabase_GetGeneratorsCount(fractionid, .broken = true)) / PDatabase_GetGeneratorsCount(fractionid);
        if (progress >= generators_ratio && !policeDatabaseInfo[fractionid][pdiAlarm] && !policeDatabaseInfo[fractionid][pdiHackAlarm]) {
            PDatabase_SetAlarm(fractionid, true);
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Кажется, в здании сработала сигнализация, надеюсь я успею..");
            policeDatabaseInfo[fractionid][pdiHackAlarm] = true;
        }
    }

    new Float: barStart = 173.0, Float: barEnd = 173.0 + 301.0;

    new Float: barCurrent = (barEnd - barStart) * progress;

    if (progress >= 1.0) {
        PDatabase_SetHackStage(playerid, fractionid, POLICE_DATABASE_HACK_STAGE_PASSWORD);
        return 1;
    } else {
        new index = policeDatabasePlayerInfo[playerid][pdpiHackGameCheckpointID] + 1; // 12
        if (index <= 1) index = 5;
        
        new Float: startX, Float: endX;
        PDatabase_Hack_GetBoxPos(playerid, index, startX, endX);

        if (endX > 0.0 && endX < barCurrent) {
            PDatabase_HackFail(playerid);
            return 0;
        }
    }

    new index = POLICE_DATABASE_HACK_GAME_TEXTDRAWS - 1;
    PlayerTextDrawTextSize(playerid, policeDatabasePlayerTextDraws[playerid][index], barCurrent, 16.0);
    PlayerTextDrawShow(playerid, policeDatabasePlayerTextDraws[playerid][index]);

    SetTimerEx("PDatabase_HackDraw", 1000, false, "d", playerid);
    return 1;
}

stock PDatabase_SetHackStage(playerid, fractionid, e_PoliceDatabaseHackStage: stage)
{
    if (fractionid < 0 || fractionid >= POLICE_DATABASE_MAX_ORG) return 0;
    policeDatabasePlayerInfo[playerid][pdpiHackStage] = stage;
    policeDatabasePlayerInfo[playerid][pdpiFractionID] = fractionid;

    for (new i = 0; i < POLICE_DATABASE_HACK_GAME_TEXTDRAWS; i++) {
        PlayerTextDrawDestroy(playerid, policeDatabasePlayerTextDraws[playerid][i]);
        policeDatabasePlayerTextDraws[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
    }

    switch (policeDatabasePlayerInfo[playerid][pdpiHackStage])
    {
        case POLICE_DATABASE_HACK_STAGE_NONE:
        {
            TogglePlayerControllable(playerid, true);
            
            // Возвращаем базу данных в нормальное состояние через некоторое время после взлома
            policeDatabaseInfo[fractionid][pdiResetTime] = POLICE_DATABASE_HACK_BACK_TO_NORMAL;
        }
        case POLICE_DATABASE_HACK_STAGE_GAME:
        {
            // Инициализация текстдравов
            policeDatabasePlayerTextDraws[playerid][0] = CreatePlayerTextDraw(playerid, 170.0000, 389.0000, "LD_SPAC:white"); // outbox
            PlayerTextDrawTextSize(playerid, policeDatabasePlayerTextDraws[playerid][0], 307.0000, 21.0000);
            PlayerTextDrawAlignment(playerid, policeDatabasePlayerTextDraws[playerid][0], TEXT_DRAW_ALIGN: 1);
            PlayerTextDrawColour(playerid, policeDatabasePlayerTextDraws[playerid][0], -1263206401);
            PlayerTextDrawBackgroundColour(playerid, policeDatabasePlayerTextDraws[playerid][0], 255);
            PlayerTextDrawFont(playerid, policeDatabasePlayerTextDraws[playerid][0], TEXT_DRAW_FONT: 4);
            PlayerTextDrawSetProportional(playerid, policeDatabasePlayerTextDraws[playerid][0], false);
            PlayerTextDrawSetShadow(playerid, policeDatabasePlayerTextDraws[playerid][0], 0);

            policeDatabasePlayerTextDraws[playerid][1] = CreatePlayerTextDraw(playerid, 173.0000, 391.0000, "LD_SPAC:white"); // progressbar
            PlayerTextDrawTextSize(playerid, policeDatabasePlayerTextDraws[playerid][1], 301.0000, 16.0000);
            PlayerTextDrawAlignment(playerid, policeDatabasePlayerTextDraws[playerid][1], TEXT_DRAW_ALIGN: 1);
            PlayerTextDrawColour(playerid, policeDatabasePlayerTextDraws[playerid][1], 255);
            PlayerTextDrawBackgroundColour(playerid, policeDatabasePlayerTextDraws[playerid][1], 255);
            PlayerTextDrawFont(playerid, policeDatabasePlayerTextDraws[playerid][1], TEXT_DRAW_FONT: 4);
            PlayerTextDrawSetProportional(playerid, policeDatabasePlayerTextDraws[playerid][1], false);
            PlayerTextDrawSetShadow(playerid, policeDatabasePlayerTextDraws[playerid][1], 0);

            policeDatabasePlayerTextDraws[playerid][2] = CreatePlayerTextDraw(playerid, 295.000, 374.0000, "LD_SPAC:white"); // hintbox
            PlayerTextDrawTextSize(playerid, policeDatabasePlayerTextDraws[playerid][2], 49.0000, 15.0000);
            PlayerTextDrawAlignment(playerid, policeDatabasePlayerTextDraws[playerid][2], TEXT_DRAW_ALIGN: 1);
            PlayerTextDrawColour(playerid, policeDatabasePlayerTextDraws[playerid][2], -1868627969);
            PlayerTextDrawBackgroundColour(playerid, policeDatabasePlayerTextDraws[playerid][2], 255);
            PlayerTextDrawFont(playerid, policeDatabasePlayerTextDraws[playerid][2], TEXT_DRAW_FONT: 4);
            PlayerTextDrawSetProportional(playerid, policeDatabasePlayerTextDraws[playerid][2], false);
            PlayerTextDrawSetShadow(playerid, policeDatabasePlayerTextDraws[playerid][2], 0);

            policeDatabasePlayerTextDraws[playerid][3] = CreatePlayerTextDraw(playerid, 319.0000, 375.0000, "PRESS:_H");
            PlayerTextDrawLetterSize(playerid, policeDatabasePlayerTextDraws[playerid][3], 0.3361, 1.4048);
            PlayerTextDrawTextSize(playerid, policeDatabasePlayerTextDraws[playerid][3], 0.0000, -16.0000);
            PlayerTextDrawAlignment(playerid, policeDatabasePlayerTextDraws[playerid][3], TEXT_DRAW_ALIGN: 2);
            PlayerTextDrawColour(playerid, policeDatabasePlayerTextDraws[playerid][3], -1);
            PlayerTextDrawBackgroundColour(playerid, policeDatabasePlayerTextDraws[playerid][3], 255);
            PlayerTextDrawFont(playerid, policeDatabasePlayerTextDraws[playerid][3], TEXT_DRAW_FONT: 1);
            PlayerTextDrawSetProportional(playerid, policeDatabasePlayerTextDraws[playerid][3], true);
            PlayerTextDrawSetShadow(playerid, policeDatabasePlayerTextDraws[playerid][3], 0);

            new Float: divideSize = 3.0, Float: startPos = 173.0;
            new Float: endPos = 173.0 + 301.0 - divideSize * 2;
            new Float: sectionSize = (endPos - startPos) / POLICE_DATABASE_HACK_GAME_DIVISIONS;

            for (new i = 5; i < 5 + POLICE_DATABASE_HACK_GAME_DIVISIONS; i++)
            {
                new Float: sectionStart = startPos + (i - 5) * sectionSize;
                new Float: sectionEnd = sectionStart + sectionSize;

                new Float: dividePos = frand(sectionStart + divideSize * 2, sectionEnd - divideSize * 2);

                policeDatabasePlayerTextDraws[playerid][i] = CreatePlayerTextDraw(playerid, dividePos, 391.0, "LD_SPAC:white");
                PlayerTextDrawTextSize(playerid, policeDatabasePlayerTextDraws[playerid][i], divideSize, 16.0);
                PlayerTextDrawAlignment(playerid, policeDatabasePlayerTextDraws[playerid][i], TEXT_DRAW_ALIGN: 1);
                PlayerTextDrawColour(playerid, policeDatabasePlayerTextDraws[playerid][i], -1869873153);
                PlayerTextDrawBackgroundColour(playerid, policeDatabasePlayerTextDraws[playerid][i], 255);
                PlayerTextDrawFont(playerid, policeDatabasePlayerTextDraws[playerid][i], TEXT_DRAW_FONT: 4);
                PlayerTextDrawSetProportional(playerid, policeDatabasePlayerTextDraws[playerid][i], false);
                PlayerTextDrawSetShadow(playerid, policeDatabasePlayerTextDraws[playerid][i], 0);
            }

            {
                new index = POLICE_DATABASE_HACK_GAME_TEXTDRAWS - 1;
                policeDatabasePlayerTextDraws[playerid][index] = CreatePlayerTextDraw(playerid, 173.0000, 391.0000, "LD_SPAC:white"); // fillbox
                PlayerTextDrawTextSize(playerid, policeDatabasePlayerTextDraws[playerid][index], 0.0000, 16.0000);
                PlayerTextDrawAlignment(playerid, policeDatabasePlayerTextDraws[playerid][index], TEXT_DRAW_ALIGN: 1);
                PlayerTextDrawColour(playerid, policeDatabasePlayerTextDraws[playerid][index], -2131463425);
                PlayerTextDrawBackgroundColour(playerid, policeDatabasePlayerTextDraws[playerid][index], 255);
                PlayerTextDrawFont(playerid, policeDatabasePlayerTextDraws[playerid][index], TEXT_DRAW_FONT: 4);
                PlayerTextDrawSetProportional(playerid, policeDatabasePlayerTextDraws[playerid][index], false);
                PlayerTextDrawSetShadow(playerid, policeDatabasePlayerTextDraws[playerid][index], 0);
            }

            // После отображаем оставшиеся текстдравы
            for (new i = 0; i < POLICE_DATABASE_HACK_GAME_TEXTDRAWS; i++) PlayerTextDrawShow(playerid, policeDatabasePlayerTextDraws[playerid][i]);

            // Инициализация взлома
            GetPlayerPos(playerid, policeDatabasePlayerInfo[playerid][pdpiX], policeDatabasePlayerInfo[playerid][pdpiY], policeDatabasePlayerInfo[playerid][pdpiZ]);
            policeDatabaseInfo[fractionid][pdiHackerID] = PlayerInfo[playerid][pID];
            policeDatabaseInfo[fractionid][pdiHackAttemptTime] = gettime();
            TogglePlayerControllable(playerid, false);

            policeDatabasePlayerInfo[playerid][pdpiHackGameCheckpointID] = 0;

            switch (fractionid)
            {
                case 1: policeDatabasePlayerInfo[playerid][pdpiHackGameDuration] = 10 * 60;
                default: policeDatabasePlayerInfo[playerid][pdpiHackGameDuration] = 5 * 60;
            }

            // Для тестового сервера время ожидания - 1 минута
            if (server == 0) policeDatabasePlayerInfo[playerid][pdpiHackGameDuration] = 60;
            
            PDatabase_HackDraw(playerid);
        }
        case POLICE_DATABASE_HACK_STAGE_PASSWORD:
        {
            // Определяем известные в пароле цифры
            new length = 2;
            if (fractionid == 1) length = 4;

            for (new i = 0; i < length; i++)
            {
                new digit, bool: found = false;

                do {
                    found = false;
                    digit = '0' + random(10);
                    for (new j = 0; j < length; j++) {
                        if (policeDatabasePasswordInfo[fractionid][pdiPasswordSymbols][j] == digit) {
                            found = true;
                            break;
                        }
                    }
                } while (found);

                policeDatabasePasswordInfo[fractionid][pdiPasswordSymbols][i] = digit;
            }
            policeDatabasePasswordInfo[fractionid][pdiPasswordSymbols][length] = EOS;
            
            // Генерация пароля
            new tempPassword[5];
            if (length == 4) {
                // Перетасовываем уже известные цифры в итоговом пароле
                new indices[4] = {-1, ...};

                for (new i = 0; i < 4; i++) {
                    new randIndex;
                    do {
                        randIndex = random(4);
                    } while (indices[randIndex] != -1);

                    indices[randIndex] = 1;
                    tempPassword[i] = policeDatabasePasswordInfo[fractionid][pdiPasswordSymbols][randIndex];
                }
            } else if (length < 4) {
                // Генерируем 4-значный пароль из известных символов, но обязательно используем все из них хотя бы 1 раз
                new indices[4] = {-1, ...};

                // Заполняем пароль доступными символами
                for (new i = 0; i < length; i++) {
                    new randIndex;
                    do {
                        randIndex = random(4);
                    } while (indices[randIndex] != -1);

                    indices[randIndex] = 1;
                    tempPassword[randIndex] = policeDatabasePasswordInfo[fractionid][pdiPasswordSymbols][i];
                }

                // Заполняем оставшиеся символы случайными из доступных
                for (new i = 0; i < 4; i++) {
                    if (indices[i] == -1) {
                        tempPassword[i] = policeDatabasePasswordInfo[fractionid][pdiPasswordSymbols][random(length)];
                    }
                }
            }
            tempPassword[4] = EOS;

            policeDatabasePasswordInfo[fractionid][pdiPassword][0] = EOS;
            strcat(policeDatabasePasswordInfo[fractionid][pdiPassword], tempPassword);

            if (server == 0) SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Кажется... пароль от базы данных - \"%s\" [ Только на тестовом сервере ]", policeDatabasePasswordInfo[fractionid][pdiPassword]);

            PlayerPlaySound(playerid, 17803);
            ShowDialog(playerid, POLICE_DATABASE_DIALOG_HACKPASS_START, DIALOG_STYLE_MSGBOX, "{ff9000}Второй этап {cccccc}| Подбор пароля",
                "{ff9000}Первая стадия защиты базы данных позади\n" \
                "Теперь вам необходимо подобрать и указать системный пароль:\n\n" \
                \
                "{cccccc}- Пароль всегда состоит только из цифр\n" \
                "{cccccc}- Пароль всегда состоит из 4 символов\n" \
                "{cccccc}- Имеющиеся в пароле цифры будут известны заранее\n" \
                "{cccccc}- Количество попыток для угадывания пароля неограничено\n" \
                "{cccccc}- Время на угадывание пароля ограничено и составляет "#POLICE_DATABASE_HACK_PASSWORD_TIME" минуты\n" \
                "{cccccc}- Между попытками должно проходить не меньше "#POLICE_DATABASE_HACK_PASSWORD_COOLDOWN" секунд\n\n" \
                \
                "{99ff66}Вы готовы начать?",

                "Да", ""
            );

            SetTimerEx("PDatabase_HackPassFail", POLICE_DATABASE_HACK_PASSWORD_TIME * 60 * 1000, false, "dd", playerid, fractionid);
        }
        default: return 0;
    }

    PDatabase_UpdateResetTime(fractionid);

    return 1;
}

stock PDatabase_Dialog_ClearMenu(playerid)
{
    return ShowDialog(playerid, POLICE_DATABASE_DIALOG_CLEAR_MENU, DIALOG_STYLE_LIST, "{444444}База Данных", "{cccccc}Информация о человеке\n{cccccc}Очистить розыск", "Выбрать", "Отмена");
}

stock PDatabase_Dialog_ClearId(playerid)
{
    return ShowDialog(playerid, POLICE_DATABASE_DIALOG_CLEAR_ID, DIALOG_STYLE_INPUT, "{444444}База Данных", "{cccccc}Введите {ff9000}ID или никнейм {cccccc}игрока\nчтобы очистить его уровень розыска", "Принять", "Отмена");
}

stock PDatabase_Dialog_HackPass(playerid, stat = 0)
{
    new fractionid = policeDatabasePlayerInfo[playerid][pdpiFractionID];

    if (policeDatabasePlayerInfo[playerid][pdpiHackStage] != POLICE_DATABASE_HACK_STAGE_PASSWORD) return ErrorMessage(playerid, "{FF6347}Вы не дошли до этого этапа взлома");

    new dialog_text[2048] = "{ff9000}Загаданный пароль: ****\n\n";

    new knowndigits_str[28];
    for (new i = 0; i < strlen(policeDatabasePasswordInfo[fractionid][pdiPasswordSymbols]); i++)
    {
        format(knowndigits_str, sizeof(knowndigits_str), "%s%c|", knowndigits_str, policeDatabasePasswordInfo[fractionid][pdiPasswordSymbols][i]);
    }
    knowndigits_str[strlen(knowndigits_str) - 1] = EOS;

    format(dialog_text, sizeof(dialog_text), 
        "%s" \
        "Известные цифры: {ff6347}%s",
        
        dialog_text,
        knowndigits_str
    );

    strcat(dialog_text, "\n\n{99ff66}Ваши попытки:{cccccc}");

    for (new i = 0; i < POLICE_DATABASE_HACK_PASSWORD_ATTEMPTS; i++) {
        format(dialog_text, sizeof(dialog_text),
            "%s" \
            "\n%d. %s",

            dialog_text,
            i + 1,
            policeDatabasePasswordAttempts[fractionid][i]
        );

        if (isnull(policeDatabasePasswordAttempts[fractionid][i])) break;
    }

    switch (stat)
    {
        case 1: strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}Пароль состоит ровно из 4 символов");
        case 2: strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}В пароле могут использоваться только цифры");
        case 3: strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}Вы уже использовали эту комбинацию цифр");
        case 4: strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}Подождите немного перед следующей попыткой");
        case 5: strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}Одна из введённых вами цифр недопустима в этом пароле");
        case 6: strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}Вы не использовали в пароле одну из представленных цифр");
        case 7: strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}Вы отошли от базы данных");
        default: {}
    }
    
    return ShowDialog(playerid, POLICE_DATABASE_DIALOG_HACKPASS, DIALOG_STYLE_INPUT, "{ff9000}База данных {cccccc}| Подбор пароля", dialog_text, "Ввод", "Отмена");
}

stock PDatabase_OnPlayerDisconnect(playerid)
{
    // Очистка пользовательской информации
    for (new e_PoliceDatabasePlayerInfo: i; i < e_PoliceDatabasePlayerInfo; i++) {
        policeDatabasePlayerInfo[playerid][i] = 0;
    }

    // Если вышел игрок, взламывающий БД
    for (new fractionid = 0; fractionid < POLICE_DATABASE_MAX_ORG; fractionid++)
    {
        if (policeDatabaseInfo[fractionid][pdiHackerID] == PlayerInfo[playerid][pID]) {
            policeDatabaseInfo[fractionid][pdiHackerID] = 0;
            PDatabase_SetAlarm(fractionid, true);
            break;
        }
    }

    return 1;
}

stock PDatabase_GetGeneratorsCount(fractionid, bool: broken = false)
{
    new count = 0;

    for (new i = 0; i < POLICE_DATABASE_MAX_GENERATORS; i++)
    {
        new objectid = policeDatabaseGeneratorInfo[fractionid][i][pdgiObjectID];
        if (!IsValidDynamicObject(objectid)) continue;
    
        if (!broken || policeDatabaseGeneratorInfo[fractionid][i][pdgiBroken])
        {
            count++;
        }
    }

    return count;
}

stock PDatabase_PlayerTakeThermite(playerid)
{
    if (Hand[playerid] != 6) {
        if (Hand[playerid] >= 1 || Hold[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}У вашего персонажа заняты руки\n\n{cccccc}Предмет или какое-то действие");
        if (get_invent2(playerid, 237, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет термитной смеси");
        
        Hold[playerid] = 0, RemovePlayerAttachedObject(playerid, 1);
        Hand[playerid] = 6;
        SetPlayerAttachedObject(playerid, 1, 19921, 6, 0.073999, 0.048999, 0.000000, -90.199905, -166.600021, 92.599960, 1.000000, 1.000000, 1.000000, 0, 0);
        SetPlayerChatBubble(playerid, "достаёт термитную смесь", COLOR_PURPLE, 20.0, 3000);
    } else {
        Hold[playerid] = 0, RemovePlayerAttachedObject(playerid, 1);
        Hand[playerid] = 0;
        SetPlayerChatBubble(playerid, "убирает термитную смесь", COLOR_PURPLE, 20.0, 3000);
    }

    return 1;
}

stock PDatabase_GetShieldsCount(fractionid, bool: broken = false)
{
    new count = 0;

    for (new i = 0; i < sizeof(policeDatabasePickups); i++)
    {
        if (policeDatabasePickups[i][pdpFraction] != fractionid) continue;
        if (policeDatabasePickups[i][pdpType] != POLICE_DATABASE_PICKUP_SHIELD) continue;

        if (!broken || policeDatabaseShieldInfo[i][pdsiBreaked])
        {
            count++;
        }
    }

    return count;
}

stock PDatabase_IsGeneratorBroken(fractionid, generatorid)
{
    if (generatorid < 0 || generatorid >= POLICE_DATABASE_MAX_GENERATORS) return 0;
    return policeDatabaseGeneratorInfo[fractionid][generatorid][pdgiBroken];
}

stock PDatabase_FailShieldBreak(playerid, shieldid)
{
    new fractionid = policeDatabasePickups[shieldid][pdpFraction];

    policeDatabaseShieldInfo[shieldid][pdsiFailCount]++;
    if (policeDatabaseShieldInfo[shieldid][pdsiFailCount] >= POLICE_DATABASE_SHIELD_ATTEMPTS) {
        if (!policeDatabaseInfo[fractionid][pdiAlarm]) {
            ErrorMessage(playerid, "{FF6347}Вы не смогли вскрыть электрощиток "#POLICE_DATABASE_SHIELD_ATTEMPTS" раза подряд [ Сработала сигнализация ]");
            PDatabase_SetAlarm(fractionid, true);

            foreach (new id : Player)
            {
                if (GetPlayerVirtualWorld(id) != GetPlayerVirtualWorld(playerid)) continue;
                if (IsPlayerInRangeOfPoint(id, 100.0, policeDatabasePickups[shieldid][pdpX], policeDatabasePickups[shieldid][pdpY], policeDatabasePickups[shieldid][pdpZ]))
                {
                    PlayerPlaySound(id, 3401, policeDatabasePickups[shieldid][pdpX], policeDatabasePickups[shieldid][pdpY], policeDatabasePickups[shieldid][pdpZ], .muteseconds = 6);
                }
            }

            policeDatabaseShieldInfo[shieldid][pdsiFailCount] = 0;
        }
    }

    return 1;
}

function PDatabase_ExplodeProcessUpdateLabel(fractionid)
{
    // Получаем Dynamic Label ID
    new Text3D: explodeInfoLabel = Text3D: INVALID_STREAMER_ID;
    for (new i = 0; i < sizeof(policeDatabasePickups); i++)
    {
        if (policeDatabasePickups[i][pdpFraction] != fractionid) continue;

        if (policeDatabasePickups[i][pdpType] == POLICE_DATABASE_PICKUP_THERMITE)
        {
            explodeInfoLabel = Text3D: PDatabase_GetDynamicId(i, STREAMER_TYPE_3D_TEXT_LABEL);
            break;
        }
    }
    if (!IsValidDynamic3DTextLabel(explodeInfoLabel)) return 0;

    if (!PDatabase_IsThermitePlaced(fractionid)) {
        UpdateDynamic3DTextLabelText(explodeInfoLabel, 0xFF6347FF, "Место для размещения термита\n{cccccc}[ ALT ]");
    } else {
        new string[128];
        format(string, sizeof(string), "Термит установлен\n{cccccc}[ Проплавится через: %s ]", fine_time(POLICE_DATABASE_THERMITE_TIME * 60 - (gettime() - policeDatabaseInfo[fractionid][pdiExplodeStartTime]) ));
        UpdateDynamic3DTextLabelText(explodeInfoLabel, 0xFF6347FF, string);
        SetTimerEx("PDatabase_ExplodeProcessUpdateLabel", 1000, false, "d", fractionid);
    }

    return 1;
}

function PDatabase_ExplodeProcess(fractionid) {
    if (!PDatabase_IsThermitePlaced(fractionid)) {
        policeDatabaseInfo[fractionid][pdiExplodeFiresCount] = 0;
        return 0;
    }

    new bool: startBurn = policeDatabaseInfo[fractionid][pdiExplodeFiresCount] == 0,
        bool: endBurn = policeDatabaseInfo[fractionid][pdiExplodeFiresCount] >= 9;

    #pragma unused startBurn

    if (endBurn) {
        PDatabase_SetThermitePlace(fractionid, false);
        PDatabase_Explode(fractionid, true);
        
        policeDatabaseInfo[fractionid][pdiExplodeFiresCount] = 0;
        return 0;
    }

    new index = 17 + policeDatabaseInfo[fractionid][pdiExplodeFiresCount];
    new objectid = policeDatabaseExplodeObjects[fractionid][POLICE_DATABASE_THERMITE_EXPLODE_INDEX][index];

    if (!IsValidDynamicObject(objectid)) return 0;

    SetDynamicObjectVirtualWorld(objectid, 0);

    new Float: x, Float: y, Float: z;
    GetDynamicObjectPos(objectid, x, y, z);

    foreach (new playerid : Player) {
        if (GetPlayerVirtualWorld(playerid) != 0) continue;
        if (!IsPlayerInRangeOfPoint(playerid, 50.0, x, y, z)) continue;

        PlayerPlaySound(playerid, 40408, x, y, z);
        Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
    }

    policeDatabaseInfo[fractionid][pdiExplodeFiresCount]++;

    new Float: waitTime = 0.5;
    
    if (policeDatabaseInfo[fractionid][pdiExplodeFiresCount] == 9) {
        // Если загорелся последний, большой огонек - запускаем отсчет
        SetDynamicObjectVirtualWorld(policeDatabaseExplodeObjects[fractionid][POLICE_DATABASE_THERMITE_EXPLODE_INDEX][index + 1], 0);

        // Отображаем объекты горения в интерьере
        if (fractionid == 1) {
            new objects[30], count;
            count = Streamer_GetNearbyItems(2408.119384, 2538.662841, 2115.853027, STREAMER_TYPE_OBJECT, objects, .range = 5.0);
            for (new i = 0; i < min(sizeof(objects), count); i++)
            {
                new curobjectid = objects[i];
                if (!IsValidDynamicObject(curobjectid)) continue;

                new model = GetDynamicObjectModel(curobjectid);
                
                static explode_models[] = {18691, 18717, 18718};
                for (new j = 0; j < sizeof(explode_models); j++) {
                    if (model == explode_models[j]) {
                        SetDynamicObjectVirtualWorld(curobjectid, 217);
                    }
                }
            }
        }

        waitTime = POLICE_DATABASE_THERMITE_TIME * 60;

        policeDatabaseInfo[fractionid][pdiExplodeStartTime] = gettime();
        PDatabase_ExplodeProcessUpdateLabel(fractionid);
    }

    SetTimerEx("PDatabase_ExplodeProcess", floatround(waitTime * 1000), false, "d", fractionid);

    return 1;
}

stock PDatabase_SetThermitePlace(fractionid, bool: status = true)
{
    new index = POLICE_DATABASE_THERMITE_EXPLODE_INDEX;
    for (new i = 0; i < POLICE_DATABASE_MAX_EXPLODE_OBJECTS; i++) DestroyDynamicObject(policeDatabaseExplodeObjects[fractionid][index][i]);

    // Включаем сигнализацию, если все щитки были исправны при установке термита
    if (PDatabase_GetShieldsCount(fractionid, .broken = true) < 1) {
        PDatabase_SetAlarm(fractionid, true);
    }
    
    if (status) {
        policeDatabaseInfo[fractionid][pdiExplodeFiresCount] = 0;

        #define explodeObject policeDatabaseExplodeObjects[fractionid][index]
        
        switch (fractionid)
        {
            case 1: {
                explodeObject[0] = CreateDynamicObject(19921, 2156.754150, 2415.431640, 64.347923, 0.000000, 0.000000, 450.000000, 0, 0, -1, 300.00, 300.00); // TermitCenter
                SetDynamicObjectMaterial(explodeObject[0], 0, 2702, "pick_up", "CJ_red_FELT", 0x00000000);
                SetDynamicObjectMaterial(explodeObject[0], 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(explodeObject[0], 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                explodeObject[1] = CreateDynamicObject(1654, 2158.174316, 2415.391601, 64.347236, -89.999992, -89.999992, 89.999961, 0, 0, -1, 300.00, 300.00); // TermitChast
                SetDynamicObjectMaterial(explodeObject[1], 0, 2702, "pick_up", "CJ_red_FELT", 0x00000000);
                SetDynamicObjectMaterial(explodeObject[1], 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
                explodeObject[2] = CreateDynamicObject(1654, 2154.853515, 2415.431640, 64.347236, -89.999992, 89.999992, 89.999992, 0, 0, -1, 300.00, 300.00); // TermitChast
                SetDynamicObjectMaterial(explodeObject[2], 0, 2702, "pick_up", "CJ_red_FELT", 0x00000000);
                SetDynamicObjectMaterial(explodeObject[2], 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
                explodeObject[3] = CreateDynamicObject(1654, 2156.493896, 2413.681640, 64.347236, -89.999992, 179.999984, -90.000015, 0, 0, -1, 300.00, 300.00); // TermitChast
                SetDynamicObjectMaterial(explodeObject[3], 0, 2702, "pick_up", "CJ_red_FELT", 0x00000000);
                SetDynamicObjectMaterial(explodeObject[3], 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
                explodeObject[4] = CreateDynamicObject(1654, 2156.553955, 2417.181640, 64.347236, -89.999992, -179.999984, 90.000015, 0, 0, -1, 300.00, 300.00); // TermitChast
                SetDynamicObjectMaterial(explodeObject[4], 0, 2702, "pick_up", "CJ_red_FELT", 0x00000000);
                SetDynamicObjectMaterial(explodeObject[4], 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
                explodeObject[5] = CreateDynamicObject(1654, 2155.453613, 2416.631591, 64.347236, -89.999992, 89.999992, 45.000007, 0, 0, -1, 300.00, 300.00); // TermitChast
                SetDynamicObjectMaterial(explodeObject[5], 0, 2702, "pick_up", "CJ_red_FELT", 0x00000000);
                SetDynamicObjectMaterial(explodeObject[5], 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
                explodeObject[6] = CreateDynamicObject(1654, 2157.574218, 2414.191650, 64.347236, -89.999992, -89.999992, 44.999996, 0, 0, -1, 300.00, 300.00); // TermitChast
                SetDynamicObjectMaterial(explodeObject[6], 0, 2702, "pick_up", "CJ_red_FELT", 0x00000000);
                SetDynamicObjectMaterial(explodeObject[6], 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
                explodeObject[7] = CreateDynamicObject(1654, 2157.574218, 2416.591552, 64.347236, -89.999992, -89.999992, 135.000000, 0, 0, -1, 300.00, 300.00); // TermitChast
                SetDynamicObjectMaterial(explodeObject[7], 0, 2702, "pick_up", "CJ_red_FELT", 0x00000000);
                SetDynamicObjectMaterial(explodeObject[7], 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
                explodeObject[8] = CreateDynamicObject(1654, 2155.453613, 2414.231689, 64.347236, -89.999992, 89.999992, 134.999984, 0, 0, -1, 300.00, 300.00); // TermitChast
                SetDynamicObjectMaterial(explodeObject[8], 0, 2702, "pick_up", "CJ_red_FELT", 0x00000000);
                SetDynamicObjectMaterial(explodeObject[8], 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
                explodeObject[9] = CreateDynamicObject(2658, 2155.152099, 2416.180908, 64.297325, -90.000000, 0.000000, -27.299995, 0, 0, -1, 300.00, 300.00); // TermitChastProvod
                SetDynamicObjectMaterial(explodeObject[9], 0, 2942, "kmb_atmx", "kmb_wiresC", 0x00000000);
                explodeObject[10] = CreateDynamicObject(2658, 2156.092285, 2417.001464, 64.297325, -90.000000, 0.000000, -61.599990, 0, 0, -1, 300.00, 300.00);  // TermitChastProvod
                SetDynamicObjectMaterial(explodeObject[10], 0, 2942, "kmb_atmx", "kmb_wiresC", 0x00000000);
                explodeObject[11] = CreateDynamicObject(2658, 2157.254394, 2416.836425, 64.297325, -90.000000, 0.000000, -119.799980, 0, 0, -1, 300.00, 300.00); // TermitChastProvod
                SetDynamicObjectMaterial(explodeObject[11], 0, 2942, "kmb_atmx", "kmb_wiresC", 0x00000000);
                explodeObject[12] = CreateDynamicObject(2658, 2157.997314, 2415.876220, 64.297325, -90.000000, 0.000000, -150.799957, 0, 0, -1, 300.00, 300.00); // TermitChastProvod
                SetDynamicObjectMaterial(explodeObject[12], 0, 2942, "kmb_atmx", "kmb_wiresC", 0x00000000);
                explodeObject[13] = CreateDynamicObject(2658, 2157.908203, 2414.665283, 64.297325, -90.000000, 0.000000, 153.699920, 0, 0, -1, 300.00, 300.00); // TermitChastProvod
                SetDynamicObjectMaterial(explodeObject[13], 0, 2942, "kmb_atmx", "kmb_wiresC", 0x00000000);
                explodeObject[14] = CreateDynamicObject(2658, 2156.989501, 2413.820312, 64.297325, -90.000000, 0.000000, 119.299858, 0, 0, -1, 300.00, 300.00); // TermitChastProvod
                SetDynamicObjectMaterial(explodeObject[14], 0, 2942, "kmb_atmx", "kmb_wiresC", 0x00000000);
                explodeObject[15] = CreateDynamicObject(2658, 2155.786865, 2413.952636, 64.297325, -90.000000, 0.000000, 60.899883, 0, 0, -1, 300.00, 300.00); // TermitChastProvod
                SetDynamicObjectMaterial(explodeObject[15], 0, 2942, "kmb_atmx", "kmb_wiresC", 0x00000000);
                explodeObject[16] = CreateDynamicObject(2658, 2155.009277, 2414.900878, 64.297325, -90.000000, 0.000000, 28.399873, 0, 0, -1, 300.00, 300.00); // TermitChastProvod
                SetDynamicObjectMaterial(explodeObject[16], 0, 2942, "kmb_atmx", "kmb_wiresC", 0x00000000);

                // Огоньки (будут зажигаться поочередно, сначала существуют в другом вирт. мире)
                explodeObject[17] = CreateDynamicObject(18688, 2158.174316, 2415.391601, 62.938632, 0.000000, 0.000000, 0.000000, 228, 0, -1, 300.00, 300.00); // FireSmall
                explodeObject[18] = CreateDynamicObject(18688, 2157.574218, 2414.191650, 62.938632, 0.000000, 0.000000, 0.000000, 228, 0, -1, 300.00, 300.00);
                explodeObject[19] = CreateDynamicObject(18688, 2156.493896, 2413.681640, 62.938632, 0.000000, 0.000000, 0.000000, 228, 0, -1, 300.00, 300.00);
                explodeObject[20] = CreateDynamicObject(18688, 2155.453613, 2414.231689, 62.938632, 0.000000, 0.000000, 0.000000, 228, 0, -1, 300.00, 300.00);
                explodeObject[21] = CreateDynamicObject(18688, 2154.853515, 2415.431640, 62.938632, 0.000000, 0.000000, 0.000000, 228, 0, -1, 300.00, 300.00);
                explodeObject[22] = CreateDynamicObject(18688, 2155.453613, 2416.631591, 62.938632, 0.000000, 0.000000, 0.000000, 228, 0, -1, 300.00, 300.00);
                explodeObject[23] = CreateDynamicObject(18688, 2156.553955, 2417.181640, 62.938632, 0.000000, 0.000000, 0.000000, 228, 0, -1, 300.00, 300.00);
                explodeObject[24] = CreateDynamicObject(18688, 2157.574218, 2416.591552, 62.938632, 0.000000, 0.000000, 0.000000, 228, 0, -1, 300.00, 300.00);
                explodeObject[25] = CreateDynamicObject(18691, 2156.433837, 2415.141357, 62.676868, 0.000000, 0.000000, 0.000000, 228, 0, -1, 300.00, 300.00); // FireBig
                explodeObject[26] = CreateDynamicObject(18694, 2156.533935, 2417.013183, 64.696022, 450.000000, 0.000000, 0.000000, 228, 0, -1, 300.00, 300.00); // FireBig
            }
            default: return 0;
        }

        #undef explodeObject

        SetTimerEx("PDatabase_ExplodeProcess", 10 * 1000, false, "d", fractionid);

        PDatabase_UpdateResetTime(fractionid);
    }

    return 1;
}

stock PDatabase_PlayerUseThermite(playerid) {
    new fractionid = PDatabase_GetFractionIDByPos(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid]);
    if (PDatabase_IsThermitePlaced(fractionid)) return ErrorMessage(playerid, "{FF6347}Термит уже был установлен");
    if (Hand[playerid] != 6) return ErrorMessage(playerid, "{FF6347}У вас в руках должна быть термитная смесь");

    if (IsPlayerInRangeOfPoint(playerid, 2.0, 2156.5627, 2415.4214, 65.4495)) { // FBI
        PDatabase_Thermite_StartPump(playerid, 1);

        if (PDatabase_GetShieldsCount(fractionid, .broken = true) < 1) {
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Наверное, мне стоило бы отключить перед этим один из электрощитков, кто знает чем всё обернётся?..");
        }
    }

    return 1;
}

stock PDatabase_IsThermitePlaced(fractionid)
{
    return IsValidDynamicObject(policeDatabaseExplodeObjects[fractionid][POLICE_DATABASE_THERMITE_EXPLODE_INDEX][0]);
}

stock PDatabase_Thermite_StartPump(playerid, fractionid)
{
    if (GetPVarInt(playerid, "Arobsklad") > 0) return 1;

    DP[1][playerid] = fractionid;

    GetPlayerPos(playerid, policeDatabasePlayerInfo[playerid][pdpiX], policeDatabasePlayerInfo[playerid][pdpiY], policeDatabasePlayerInfo[playerid][pdpiZ]);
    SetPVarInt(playerid, "oryjtemp", 0); SetPVarInt(playerid, "Arobsklad", 13);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Теперь мне нужно разместить термит {ff9000}[ Нажимайте %s ]", buttonName[Device[playerid]]);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, false, true, true, true, true);

    return 1;
}

stock PDatabase_Thermite_Pump(playerid)
{
    if (gettime() - policeDatabasePlayerInfo[playerid][pdpiVentClick] < POLICE_DATABASE_THERMITE_MAKE_COOLDOWN) return 0;
    
    new fractionid = DP[1][playerid];

    new string[64];
    SetPVarInt(playerid, "oryjtemp", GetPVarInt(playerid, "oryjtemp") + 1);

    // Проверка на дистанцию и всё прочее
    if (!IsPlayerInRangeOfPoint(playerid, 0.5, policeDatabasePlayerInfo[playerid][pdpiX], policeDatabasePlayerInfo[playerid][pdpiY], policeDatabasePlayerInfo[playerid][pdpiZ]) // Далеко от места открытия
        || PDatabase_IsThermitePlaced(fractionid)) // Термит уже установлен
    {
        SetPVarInt(playerid, "oryjtemp", 0);
        SetPVarInt(playerid, "Arobsklad", 0);

        ClearAnim(playerid);
        PlayerPlaySound(playerid, 31203);
        return 0;
    }

    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, false, true, true, true, true);

    new current_progress = GetPVarInt(playerid, "oryjtemp");
    if(current_progress >= POLICE_DATABASE_THERMITE_MAKE_TIMES) {
        SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad", 0);
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~ЏEPM…Џ: ~w~%d/%d", POLICE_DATABASE_THERMITE_MAKE_TIMES, POLICE_DATABASE_THERMITE_MAKE_TIMES);
        GameTextForPlayer(playerid, string, 1500, 3);
        PlayerPlaySound(playerid, 25800);
        
        if (get_invent2(playerid, 237, 0) == 0) return ErrorMessage(playerid, "{FF6347}У вас нет термитной смеси");
        if (Hold[playerid] == 0 || Hold[playerid] == 6) {
            Hold[playerid] = 0, RemovePlayerAttachedObject(playerid, 1);
            Hand[playerid] = 0;
        }
        TakeInvent(playerid, 237, 1, 0);
        
        ClearAnim(playerid);
        
        PDatabase_SetThermitePlace(fractionid, true);
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Термит установлен, теперь мне нужно отойти на безопасное расстояние и дождаться, пока он загорится.");
        PlayerPlaySound(playerid, 6401);
    } else {
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~ЏEPM…Џ: ~w~%d/%d", current_progress, POLICE_DATABASE_THERMITE_MAKE_TIMES);
        GameTextForPlayer(playerid, string, 1500, 3);

        policeDatabasePlayerInfo[playerid][pdpiVentClick] = gettime();
    }

    return 1;
}

stock PDatabase_Vent_StartPump(playerid, ventid)
{
    if (GetPVarInt(playerid, "Arobsklad") > 0) return 1;

    GetPlayerPos(playerid, policeDatabasePlayerInfo[playerid][pdpiX], policeDatabasePlayerInfo[playerid][pdpiY], policeDatabasePlayerInfo[playerid][pdpiZ]);
    SetPVarInt(playerid, "oryjtemp", 0); SetPVarInt(playerid, "Arobsklad", 12);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Перед тем, как пролезть в вентиляцию, нужно снять решётку {ff9000}[ Нажимайте %s ]", buttonName[Device[playerid]]);
    PlayerPlaySound(playerid, 40405, policeDatabasePlayerInfo[playerid][pdpiX], policeDatabasePlayerInfo[playerid][pdpiY], policeDatabasePlayerInfo[playerid][pdpiZ]);

    DP[1][playerid] = ventid;

    new string[64]; format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~‹EмЏ…‡•‰…•: ~w~0/%d", POLICE_DATABASE_VENT_OPEN_TIMES);
    GameTextForPlayer(playerid, string, 5000, 3);

    return 1;
}

stock PDatabase_Vent_Pump(playerid)
{
    if (gettime() - policeDatabasePlayerInfo[playerid][pdpiVentClick] < POLICE_DATABASE_VENT_OPEN_COOLDOWN) return 0;

    new ventid = DP[1][playerid];
    new fractionid = policeDatabasePickups[ventid][pdpFraction];

    new string[64];
    SetPVarInt(playerid, "oryjtemp", GetPVarInt(playerid, "oryjtemp") + 1);

    // Проверка на дистанцию и всё прочее
    if (!IsPlayerInRangeOfPoint(playerid, 0.5, policeDatabasePlayerInfo[playerid][pdpiX], policeDatabasePlayerInfo[playerid][pdpiY], policeDatabasePlayerInfo[playerid][pdpiZ]) // Далеко от места открытия
        || policeDatabaseInfo[fractionid][pdiState] == POLICE_DATABASE_STATE_NORMAL // Нет доступа к вентиляции
        || policeDatabaseVentState[ventid]) // Вентиляцию уже кто-то открыл
    {
        SetPVarInt(playerid, "oryjtemp", 0);
        SetPVarInt(playerid, "Arobsklad", 0);

        ClearAnim(playerid);
        PlayerPlaySound(playerid, 31203);
        return 0;
    }

    ApplyAnimation(playerid, "OTB", "betslp_loop", 4.0, false, true, true, false, false, SYNC_ALL);

    new current_progress = GetPVarInt(playerid, "oryjtemp");
    if(current_progress >= POLICE_DATABASE_VENT_OPEN_TIMES) {
        SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad", 0);
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~‹EмЏ…‡•‰…•: ~w~%d/%d", POLICE_DATABASE_VENT_OPEN_TIMES, POLICE_DATABASE_VENT_OPEN_TIMES);
        GameTextForPlayer(playerid, string, 1500, 3);
        PlayerPlaySound(playerid, 32000);
        
        ClearAnim(playerid);
        
        policeDatabaseVentState[ventid] = true;
        PlayerPlaySound(playerid, 6401);
    } else {
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~‹EмЏ…‡•‰…•: ~w~%d/%d", current_progress, POLICE_DATABASE_VENT_OPEN_TIMES);
        GameTextForPlayer(playerid, string, 1500, 3);
        PlayerPlaySound(playerid, 32401);

        policeDatabasePlayerInfo[playerid][pdpiVentClick] = gettime();
    }

    return 1;
}

stock PDatabase_UpdateResetTime(fractionid)
{
    if (policeDatabaseInfo[fractionid][pdiState] == POLICE_DATABASE_STATE_NORMAL) return 0;
    policeDatabaseInfo[fractionid][pdiResetTime] = POLICE_DATABASE_BACK_TO_NORMAL;
    return 1;
}

stock PDatabase_CheckPolice(playerid) {
    // Запрет на взаимодействие копов с пикапами для взлома БД (только на основном сервере)
    if (server != 0 && IsPoliceMember(playerid)) {
        ErrorMessage(playerid, "{FF6347}Вы не можете этим воспользоваться [ Сотрудник правоохранительных органов ]");
        return 0;
    }
    return 1;
}

stock PDatabase_OnPlayerPressALT(playerid)
{
    if (GetPVarInt(playerid, "Arobsklad") > 0) return 1;

    // Вход/выход для дыры от взрыва
    for (new fractionid = 0; fractionid < POLICE_DATABASE_MAX_ORG; fractionid++)
    {
        for (new i = 0; i < 2; i++)
        {
            new pickupid = policeDatabaseInfo[fractionid][pdiExplodePickups][i];
            if (!IsValidDynamicPickup(pickupid)) continue;
            if (GetPlayerVirtualWorld(playerid) != Streamer_GetIntData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_WORLD_ID)) continue;
            
            new Float: distance;
            Streamer_GetDistanceToItem(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid], STREAMER_TYPE_PICKUP, pickupid, distance);
            if (distance >= 1.5) continue;

            switch (fractionid) {
                case 1: {
                    if (i == 0) { // Вход
                        keep(playerid);
                        S_SetPlayerVirtualWorld(playerid, 217, 217);
                        PPSetPlayerInterior(playerid, 217);
                        PPSetPlayerPos(playerid, 2407.9661 + frand(-1.15, 1.15), 2538.4675 + frand(-1.15, 1.15), 2110.4668);
                        SetCameraBehindPlayer(playerid);

                        // Включаем тревогу, если был разрушен лишь один щиток
                        if (!IsPoliceMember(playerid))
                        {
                            if (PDatabase_GetShieldsCount(fractionid, .broken = true) == 1 && !policeDatabaseInfo[fractionid][pdiExplodeJoin])
                            {
                                PDatabase_SetAlarm(fractionid, true);
                            }
                            policeDatabaseInfo[fractionid][pdiExplodeJoin] = true;
                        }

                        PDatabase_UpdateResetTime(fractionid);
                    } else if (i == 1) { // Выход
                        keep(playerid);
                        S_SetPlayerVirtualWorld(playerid, 0, 0);
                        PPSetPlayerInterior(playerid, 0);
                        PPSetPlayerPos(playerid, 2156.5713 + frand(-1.15, 1.15), 2415.3252 + frand(-1.15, 1.15), 65.2773);
                        SetCameraBehindPlayer(playerid);
                    }
                }
            }

            return 1;
        }
    }

    // Взаимодействие с пикапами
    for (new i = 0; i < sizeof(policeDatabasePickups); i++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 1.5, policeDatabasePickups[i][pdpX], policeDatabasePickups[i][pdpY], policeDatabasePickups[i][pdpZ]))
        {
            if (GetPlayerVirtualWorld(playerid) != policeDatabasePickups[i][pdpWorld] || GetPlayerInterior(playerid) != policeDatabasePickups[i][pdpInterior]) return 0;
            if (!PDatabase_CheckPolice(playerid)) return 0;

            new fractionid = DP[0][playerid] = policeDatabasePickups[i][pdpFraction];
            DP[1][playerid] = i;

            switch (policeDatabasePickups[i][pdpType])
            {
                case POLICE_DATABASE_PICKUP_VENT:
                {
                    if (policeDatabaseInfo[fractionid][pdiState] == POLICE_DATABASE_STATE_NORMAL) return ErrorMessage(playerid, "{FF6347}Сейчас войти в здание через вентиляцию нельзя [ Сигнализация не отключена ]");
                    
                    // Вход по вентиляции
                    if (!policeDatabaseVentState[i]) return PDatabase_Vent_StartPump(playerid, i);
                    if (PDatabase_IsPlayerUsedVent(fractionid, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать проход через вентиляцию");

                    S_SetPlayerVirtualWorld(playerid, policeDatabasePickups[i][pdpExitWorld], policeDatabasePickups[i][pdpExitInterior]);
                    PPSetPlayerInterior(playerid, policeDatabasePickups[i][pdpExitInterior]);
                    PPSetPlayerPos(playerid, policeDatabasePickups[i][pdpExitX], policeDatabasePickups[i][pdpExitY], policeDatabasePickups[i][pdpExitZ]);
                    PPSetPlayerFacingAngle(playerid, policeDatabasePickups[i][pdpExitA]);
                    SetCameraBehindPlayer(playerid);
                    PlayerPlaySound(playerid, 1002);
                }
                case POLICE_DATABASE_PICKUP_SHIELD:
                {
                    if (PDatabase_CheckHackAvailableTime(playerid, fractionid)) return 1;

                    if (policeDatabaseShieldInfo[i][pdsiBreaked]) return ErrorMessage(playerid, "{FF6347}Электрощиток уже был отключён");
                    if (policeDatabaseInfo[fractionid][pdiAlarm]) return ErrorMessage(playerid, "{FF6347}Сейчас начать взлом базы данных невозможно [ В здании включена сигнализация ]");
                    if (Hold[playerid] != 9) return ErrorMessage(playerid, "{FF6347}У вас в руках должна быть монтировка");

                    new hardLevel = 2;
                    if (fractionid == 1) hardLevel = 3;
                    CreateBreaking(playerid, BREAKING_TYPE_ELECTRICAL_SHIELD, i, hardLevel);
                }
                case POLICE_DATABASE_PICKUP_INFO:
                {
                    switch (fractionid) {
                        case 0: {
                            ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, "{0066ff}Серверная LSPD {cccccc}| Информация",
                                "{ffffff}В серверной Полицейского Департамента хранятся данные о небольшой части подозреваемых (не более 12+ ур. розыска)\n" \
                                "Вы можете использовать следующий способ для проникновения:\n\n" \
                                \
                                "{ff9000}1. Проникновение с использованием вентиляции\n" \
                                "{ffffff}Для этого способа достаточно вывести из строя единственный электрощиток, а после вскрыть вентиляционный проход.\n" \
                                "Выходом по вентиляции можно воспользоваться лишь один раз, поэтому своё отступление нужно планировать заранее.\n\n" \
                                \
                                "{cccccc}* Генераторы могут быть отключены в целях лишения здания электричества и повышения своих шансов на успех.",

                                "Закрыть", ""
                            );
                        }
                        case 1: {
                            ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, "{6666ff}Серверная FBI {cccccc}| Информация",
                                "{ffffff}В серверной Федерального Бюро Расследований хранятся данные об особо опасных подозреваемых (6+ ур. розыска)\n" \
                                "Для проникновения внутрь вы можете использовать любой из трёх предоставленных вариантов:\n\n" \
                                \
                                "{ff9000}1. Проникновение с использованием термитной смеси\n" \
                                "{ffffff}Вам необходимо произвести крафт термита, а после - воспользоваться им, чтобы проделать отверстие на крыше.\n" \
                                "Этот способ наиболее сложный и ресурсозатратный, но предоставит вам беспрепятственный доступ к серверной.\n\n" \
                                \
                                "{ff9000}2. Проникновение с использованием вентиляции\n" \
                                "{ffffff}Для этого способа достаточно вывести из строя все электрощитки, а после вскрыть вентиляционный проход.\n" \
                                "Выходом по вентиляции можно воспользоваться лишь один раз, поэтому своё отступление нужно планировать заранее.\n\n" \
                                \
                                /*"{ff9000}3. Проникновение с использованием похищенной ключ-карты\n" \
                                "{ffffff}Ключ-карту используют сотрудники FBI для доступа ко многим своим помещениям, включая серверную.\n" \
                                "Карта выпадает с некоторым шансом при убийстве её владельца, а также обладает сроком годности, длительностью в 1 день.\n" \
                                "Для этого способа достаточно лишь воспользоваться дверью, расположенной на 10 уровне парковки.\n\n"*/ \
                                \
                                "{cccccc}* Электрощитки должны быть отключены для предотвращения преждевременного срабатывания сигнализации.\n" \
                                "{cccccc}* Генераторы могут быть отключены в целях лишения здания электричества и повышения своих шансов на успех.",
                                
                                "Закрыть", ""
                            );
                        }
                        default: {}
                    }
                }
                case POLICE_DATABASE_PICKUP_THERMITE: return PDatabase_PlayerUseThermite(playerid);
                default: {}
            }
            break;
        } else if (IsPlayerInRangeOfPoint(playerid, 1.5, policeDatabasePickups[i][pdpExitX], policeDatabasePickups[i][pdpExitY], policeDatabasePickups[i][pdpExitZ])) {
            if (!PDatabase_CheckPolice(playerid)) return 0;

            new fractionid = DP[0][playerid] = policeDatabasePickups[i][pdpFraction];
            DP[1][playerid] = i;
            
            if (policeDatabasePickups[i][pdpExitX] == 0.0 && policeDatabasePickups[i][pdpExitY] == 0.0) return 0;
            if (GetPlayerVirtualWorld(playerid) != policeDatabasePickups[i][pdpExitWorld] || GetPlayerInterior(playerid) != policeDatabasePickups[i][pdpExitInterior]) return 0;
            
            // Выход по вентиляции
            if (policeDatabasePickups[i][pdpType] == POLICE_DATABASE_PICKUP_VENT) {
                if (policeDatabaseInfo[fractionid][pdiState] == POLICE_DATABASE_STATE_NORMAL) return ErrorMessage(playerid, "{FF6347}Сейчас выйти из здания через вентиляцию нельзя [ Сигнализация не отключена ]");
                if (!policeDatabaseVentState[i]) return ErrorMessage(playerid, "{FF6347}Этот вентиляционный проход не был открыт со стороны улицы");
                if (PDatabase_IsPlayerUsedVent(fractionid, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать проход через вентиляцию");
                
                ShowDialog(playerid, POLICE_DATABASE_DIALOG_VENT_EXIT, DIALOG_STYLE_MSGBOX, "{ff9000}Вентиляция", 
                    "{cccccc}Вы уверены, что хотите покинуть здание через вентиляцию?\n" \
                    "{ff0000}[!] {ff6347}Вы не сможете вернуться этим же путём вновь",

                    "Да", "Отмена"
                );
            }
        }
    }

    // Взаимодействие с генераторами
    for (new fractionid = 0; fractionid < POLICE_DATABASE_MAX_ORG; fractionid++)
    {
        for (new generatorid = 0; generatorid < POLICE_DATABASE_MAX_GENERATORS; generatorid++)
        {
            new objectid = policeDatabaseGeneratorInfo[fractionid][generatorid][pdgiObjectID];
            if (!IsValidDynamicObject(objectid)) continue;

            new Float: x, Float: y, Float: z;
            GetDynamicObjectPos(objectid, x, y, z);

            if (IsPlayerInRangeOfPoint(playerid, 1.5, x, y, z))
            {
                if (!PDatabase_CheckPolice(playerid)) return 0;

                if (policeDatabaseInfo[fractionid][pdiState] == POLICE_DATABASE_STATE_NORMAL) return ErrorMessage(playerid, "{FF6347}Сейчас сломать генераторы нельзя [ Сигнализация не отключена ]");
                if (PDatabase_IsGeneratorBroken(fractionid, generatorid)) return ErrorMessage(playerid, "{FF6347}Этот генератор уже был сломан");

                policeDatabasePlayerInfo[playerid][pdpiGeneratorID] = generatorid;

                PDatabase_UpdateResetTime(fractionid);
                PDatabase_StopGeneratorBroke(playerid, 0);
                policeDatabasePlayerInfo[playerid][pdpiGeneratorBroke] = true;
                GetPlayerPos(playerid, policeDatabasePlayerInfo[playerid][pdpiX], policeDatabasePlayerInfo[playerid][pdpiY], policeDatabasePlayerInfo[playerid][pdpiZ]);
                PlayerTextDrawShow(playerid, InputDraw1);
                PlayerTextDrawShow(playerid, InputDraw2);
                TextDrawShowForPlayer(playerid, InputDraw[1]);
                processbar2(playerid, 0);
                ShowInput(playerid);
                InputType[playerid] = 1;
                policeDatabasePlayerInfo[playerid][pdpiGeneratorTime] = 10;
                policeDatabasePlayerInfo[playerid][pdpiGeneratorTimer] = SetTimerEx("PDatabase_GeneratorTime", 300, true, "d", playerid);

                return 1;
            }
        }
    }
    
    return 1;
}

stock PDatabase_IsFractionVirtualWorld(fractionid, worldid)
{
    if (fractionid == 0) {
        return worldid >= 255 && worldid <= 257;
    } else if (fractionid == 1) {
        return worldid == 217 || worldid == 243 || worldid == 244;
    }

    return 0;
}

stock PDatabase_OnPlayerVirtualWorldChange(playerid, newworld, oldworld)
{
    for (new fractionid = 0; fractionid < POLICE_DATABASE_MAX_ORG; fractionid++)
    {
        // Активная сигнализация
        if (policeDatabaseInfo[fractionid][pdiAlarm]) {
            if (PDatabase_GetFractionIDByPos(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid]) != fractionid) continue;

            new f_oldworld = PDatabase_IsFractionVirtualWorld(fractionid, oldworld);
            new f_newworld = PDatabase_IsFractionVirtualWorld(fractionid, newworld);

            if (f_oldworld == f_newworld) continue; // Передвигаемся внутри здания/Вне здания
            if (!f_oldworld && f_newworld) PDatabase_PlayerAlarmSound(playerid, true); // Вхожу в здание
            else if (f_oldworld && !f_newworld) PDatabase_PlayerAlarmSound(playerid, false); // Выходим из здания
 
            break;
        }
    }
    return 1;
}

stock PDatabase_PlayerAlarmSound(playerid, bool: status)
{
    if (status) {
        new soundid = 6001;
        new fractionid = PDatabase_GetFractionIDByPos(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid]);
        if (fractionid == 1) soundid = 14800;

        PlayerPlaySound(playerid, soundid, .muteseconds = 7 * POLICE_DATABASE_ALARM_TIMES);
    } else {
        PlayerPlaySound(playerid, 0);
    }
    return 1;
}

function PDatabase_AlarmSound(fractionid, bool: status)
{
    foreach (new playerid : Player)
    {
        if (!PDatabase_IsFractionVirtualWorld(fractionid, GetPlayerVirtualWorld(playerid))) continue;
        if (PDatabase_GetFractionIDByPos(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid]) != fractionid) continue;

        PDatabase_PlayerAlarmSound(playerid, status);
    }
    
    if (status) {
       SetTimerEx("PDatabase_AlarmSound", 7000 * POLICE_DATABASE_ALARM_TIMES, false, "dd", fractionid, false); 
    }
    return 1;
}

stock PDatabase_GetFractionAcronym(fractionid) {
    new name[5];
    switch (fractionid) {
        case 0: strcat(name, "SAPD");
        case 1: strcat(name, "FBI");
    }
    return name;
}

function PDatabase_SetAlarm(fractionid, bool: status)
{
    if (policeDatabaseInfo[fractionid][pdiAlarm] == status) return 0;
    policeDatabaseInfo[fractionid][pdiAlarm] = status;

    if (status)
    {
        PDatabase_SetLight(fractionid, true);
        PDatabase_AlarmSound(fractionid, true);
        SetTimerEx("PDatabase_SetAlarm", 7000 * POLICE_DATABASE_ALARM_TIMES, false, "dd", fractionid, false);

        new string[128];
        format(string, sizeof(string), "[DEP]: Обнаружен несанкционированный доступ в здании %s [ Необходима срочная проверка безопасности ]", PDatabase_GetFractionAcronym(fractionid));
	    SendDepartMessage(COLOR_ALLDEPT, string);
    } else {
        PDatabase_AlarmSound(fractionid, false);
    }

    return 1;
}

stock PDatabase_GetDynamicId(index, type = STREAMER_TYPE_PICKUP)
{
    new id = INVALID_STREAMER_ID;

    new entities[1];
    Streamer_GetNearbyItems(policeDatabasePickups[index][pdpX], policeDatabasePickups[index][pdpY], policeDatabasePickups[index][pdpZ], type, entities, .range = 2.0);
    id = entities[0];
    
    return id;
}

stock PDatabase_Explode(fractionid, bool: status = true)
{
    if (policeDatabaseInfo[fractionid][pdiExplode] == status) return 0;
    policeDatabaseInfo[fractionid][pdiExplode] = status;

    switch (fractionid) {
        case 1: {
            new count, tmpobjid;

            // Скрытие объектов горения в интерьере
            {
                new objects[30];
                count = Streamer_GetNearbyItems(2408.1193, 2538.6628, 2115.8530, STREAMER_TYPE_OBJECT, objects, .range = 5.0);
                for (new i = 0; i < min(sizeof(objects), count); i++)
                {
                    new objectid = objects[i];
                    if (!IsValidDynamicObject(objectid)) break;

                    new model = GetDynamicObjectModel(objectid);
                    
                    static explode_models[] = {18691, 18717, 18718};
                    for (new j = 0; j < sizeof(explode_models); j++) {
                        if (model == explode_models[j]) {
                            SetDynamicObjectVirtualWorld(objectid, 228);
                        }
                    }
                }
            }

            if (status) {
                new objects[30];

                // Внутри
                count = Streamer_GetNearbyItems(2408.143310, 2537.640380, 2112.896728, STREAMER_TYPE_OBJECT, objects, .range = 5.0, .worldid = 217);
                for (new i = 0; i < min(sizeof(objects), count); i++)
                {
                    new objectid = objects[i];
                    if (!IsValidDynamicObject(objectid)) continue;

                    new model = GetDynamicObjectModel(objectid);
                    if (model == 2642) {
                        DestroyDynamicObject(objectid);
                        break;
                    }
                }
                tmpobjid = CreateDynamicObject(2642, 2408.066406, 2537.915039, 2109.506347, 270.000000, 180.000015, -55.899971, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 14534, "ab_wooziea", "light_full", 0x00000000);
                SetDynamicObjectMaterial(tmpobjid, 1, 14534, "ab_wooziea", "light_full", 0x00000000);
                SetDynamicObjectMaterial(tmpobjid, 2, 14534, "ab_wooziea", "light_full", 0x00000000);
                tmpobjid = CreateDynamicObject(19358, 2408.111816, 2538.594970, 2113.005126, 0.000053, -89.999977, 89.999855, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 18641, "flashlight1", "metalblack1-2", 0x00000000);
                tmpobjid = CreateDynamicObject(3502, 2408.119384, 2538.662841, 2117.098632, 89.999992, 88.873832, -88.873725, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 17562, "coast_apts", "sl_concslabgrey_64", 0x00000000);
                tmpobjid = CreateDynamicObject(828, 2409.621826, 2536.894531, 2112.858886, -0.000012, 179.999969, -157.199844, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 17562, "coast_apts", "sl_concslabgrey_64", 0x00000000);
                tmpobjid = CreateDynamicObject(828, 2406.445556, 2540.368164, 2112.688964, 0.000009, -179.999969, 21.700138, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 17562, "coast_apts", "sl_concslabgrey_64", 0x00000000);
                tmpobjid = CreateDynamicObject(867, 2406.166503, 2536.754882, 2112.918701, 0.000036, -179.999969, 138.199813, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 17562, "coast_apts", "sl_concslabgrey_64", 0x00000000);
                tmpobjid = CreateDynamicObject(867, 2410.922851, 2537.930175, 2109.705566, 180.000030, -179.999969, -47.999973, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 17562, "coast_apts", "sl_concslabgrey_64", 0x00000000);
                tmpobjid = CreateDynamicObject(828, 2406.007812, 2540.443359, 2109.778320, 180.000000, -179.999969, -107.499855, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 17562, "coast_apts", "sl_concslabgrey_64", 0x00000000);
                tmpobjid = CreateDynamicObject(867, 2410.730957, 2538.454101, 2112.918701, 0.000029, -179.999969, 48.199977, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 17562, "coast_apts", "sl_concslabgrey_64", 0x00000000);
                tmpobjid = CreateDynamicObject(19966, 2408.157226, 2539.140136, 2112.466308, 74.620819, -18.741600, 99.154968, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(tmpobjid, 1, 3900, "station", "rustd64", 0x00000000);
                SetDynamicObjectMaterial(tmpobjid, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                tmpobjid = CreateDynamicObject(816, 2406.280517, 2537.072021, 2109.548339, 180.000000, -179.999877, 38.899974, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 17562, "coast_apts", "sl_concslabgrey_64", 0x00000000);
                tmpobjid = CreateDynamicObject(19966, 2407.569091, 2538.096679, 2112.201416, 71.420875, -10.941595, 103.854949, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(tmpobjid, 1, 3900, "station", "rustd64", 0x00000000);
                SetDynamicObjectMaterial(tmpobjid, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
                tmpobjid = CreateDynamicObject(19966, 2407.479003, 2539.185791, 2112.367187, 54.920879, -23.141616, -82.345001, 217, 217, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
                SetDynamicObjectMaterial(tmpobjid, 1, 3900, "station", "rustd64", 0x00000000);
                SetDynamicObjectMaterial(tmpobjid, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);

                // Снаружи
                tmpobjid = CreateDynamicObject(19358, 2156.506347, 2415.381347, 64.191032, 0.000000, 90.000000, 90.000000, 0, 0, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 18641, "flashlight1", "metalblack1-2", 0x00000000);
                tmpobjid = CreateDynamicObject(3502, 2156.513916, 2415.393554, 60.097457, 270.000000, 0.000000, 0.000000, 0, 0, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 3881, "apsecurity_sfxrf", "ws_rooftarmac2", 0x00000000);
                tmpobjid = CreateDynamicObject(828, 2158.108642, 2417.205810, 64.337318, 0.000000, 0.000000, -19.499986, 0, 0, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 3881, "apsecurity_sfxrf", "ws_rooftarmac2", 0x00000000);
                tmpobjid = CreateDynamicObject(828, 2154.840087, 2413.688232, 64.507171, 0.000000, 0.000000, 158.299880, 0, 0, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 3881, "apsecurity_sfxrf", "ws_rooftarmac2", 0x00000000);
                tmpobjid = CreateDynamicObject(867, 2154.600585, 2417.256103, 64.127357, 0.000000, 0.000000, 41.800010, 0, 0, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 3881, "apsecurity_sfxrf", "ws_rooftarmac2", 0x00000000);
                tmpobjid = CreateDynamicObject(816, 2158.585205, 2418.992675, 64.327301, 0.000000, 0.000000, 117.700004, 0, 0, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 3881, "apsecurity_sfxrf", "ws_rooftarmac2", 0x00000000);
                tmpobjid = CreateDynamicObject(816, 2153.083496, 2413.929199, 64.327301, 0.000000, 0.000000, -67.899955, 0, 0, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 3881, "apsecurity_sfxrf", "ws_rooftarmac2", 0x00000000);
                tmpobjid = CreateDynamicObject(867, 2159.125488, 2415.602294, 64.227325, 0.000000, 0.000000, 131.800018, 0, 0, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 3881, "apsecurity_sfxrf", "ws_rooftarmac2", 0x00000000);
                tmpobjid = CreateDynamicObject(816, 2157.850097, 2411.889892, 64.327301, 0.000000, 0.000000, 176.100036, 0, 0, -1, 300.00, 300.00); 
                SetDynamicObjectMaterial(tmpobjid, 0, 3881, "apsecurity_sfxrf", "ws_rooftarmac2", 0x00000000);

                // Создание пикапов для входа и выхода
                policeDatabaseInfo[fractionid][pdiExplodePickups][0] = CreateDynamicPickup(19133, 1, 2156.513916, 2415.393554, 65.2773, 0, 0);
                policeDatabaseInfo[fractionid][pdiExplodePickups][1] = CreateDynamicPickup(19134, 1, 2408.119384, 2538.662841, 2110.4668, 217, 217);
            } else {
                new bool: delete, objects[500];

                // Внутри
                count = Streamer_GetNearbyItems(2408.066406, 2537.915039, 2109.506347, STREAMER_TYPE_OBJECT, objects, .range = 50.0, .worldid = 217);
                for (new i = 0; i < min(sizeof(objects), count); i++)
                {
                    new objectid = objects[i];
                    if (!IsValidDynamicObject(objectid)) continue;

                    new model = GetDynamicObjectModel(objectid);
                    if (!delete && model == 2642) {
                        DestroyDynamicObject(objectid);

                        tmpobjid = CreateDynamicObject(2642, 2408.143310, 2537.640380, 2112.896728, 89.999992, 180.000015, -89.999961, 217, 217, -1, 300.00, 300.00); 
                        SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
                        SetDynamicObjectMaterial(tmpobjid, 1, 18835, "mickytextures", "whiteforletters", 0x00000000);
                        SetDynamicObjectMaterial(tmpobjid, 2, 18835, "mickytextures", "whiteforletters", 0x00000000);

                        delete = true;
                        continue;
                    }

                    new d_models[] = {816, 828, 867, 3502, 19358, 19966};
                    for (new j = 0; j < sizeof(d_models); j++) {
                        if (d_models[j] == model) {
                            DestroyDynamicObject(objectid);
                            break;
                        }
                    }
                }

                // Снаружи
                count = Streamer_GetNearbyItems(2156.506347, 2415.461425, 64.191032, STREAMER_TYPE_OBJECT, objects, .range = 50.0, .worldid = 0);
                for (new i = 0; i < min(sizeof(objects), count); i++) {
                    new objectid = objects[i];
                    if (!IsValidDynamicObject(objectid)) continue;

                    new model = GetDynamicObjectModel(objectid);
                    
                    new d_models[] = {807, 816, 828, 867, 3502, 19358};
                    for (new j = 0; j < sizeof(d_models); j++) {
                        if (d_models[j] == model) {
                            DestroyDynamicObject(objectid);
                            break;
                        }
                    }
                }
            }
        }
        default: {}
    }

    // Получаем Dynamic Label ID для пикапа термита
    new Text3D: explodeInfoLabel = Text3D: INVALID_STREAMER_ID;
    for (new i = 0; i < sizeof(policeDatabasePickups); i++)
    {
        if (policeDatabasePickups[i][pdpFraction] != fractionid) continue;

        if (policeDatabasePickups[i][pdpType] == POLICE_DATABASE_PICKUP_THERMITE)
        {
            explodeInfoLabel = Text3D: PDatabase_GetDynamicId(i, STREAMER_TYPE_3D_TEXT_LABEL);
            break;
        }
    }
    
    PDatabase_SetThermitePlace(fractionid, false);
    PDatabase_ExplodeProcessUpdateLabel(fractionid);

    if (!status) {
        // Удаление пикапов для входа и выхода
        DestroyDynamicPickup(policeDatabaseInfo[fractionid][pdiExplodePickups][0]);
        DestroyDynamicPickup(policeDatabaseInfo[fractionid][pdiExplodePickups][1]);

        // Отображаем пикап о месте размещения термита
        if (IsValidDynamic3DTextLabel(explodeInfoLabel)) Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, explodeInfoLabel, E_STREAMER_WORLD_ID, 0);
    } else {
        // Скрываем пикап о месте размещения термита
        if (IsValidDynamic3DTextLabel(explodeInfoLabel)) Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, explodeInfoLabel, E_STREAMER_WORLD_ID, 228);
    }

    foreach (new playerid : Player) {
        new worldid = GetPlayerVirtualWorld(playerid);
        if (fractionid == 1 && (worldid != 0 && worldid != 217) ) continue;

        if (status) {
            if (fractionid == 1) {
                if (worldid == 217 && IsPlayerInRangeOfPoint(playerid, 50.0, 2408.1917, 2538.2107, 2110.4668)) {
                    PlayerPlaySound(playerid, 14600, 2408.1917, 2538.2107, 2110.4668);
                } else if (worldid == 0 && IsPlayerInRangeOfPoint(playerid, 50.0, 2156.7317, 2415.5791, 65.2773)) {
                    PlayerPlaySound(playerid, 14600, 2156.7317, 2415.5791, 65.2773);
                }
            }
        }

        Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
        Streamer_Update(playerid, STREAMER_TYPE_PICKUP);
    }

    return 1;
}

// Эту функцию нужно рефакторнуть как-нибудь, оставлено так, потому что не успевал
stock PDatabase_SetLight(fractionid, bool: status = true)
{
    if (policeDatabaseInfo[fractionid][pdiLightOff] == !status) return 0;
    policeDatabaseInfo[fractionid][pdiLightOff] = !status;

    new toggleoff_phrases[][] = {
        "[ Мысли ]: Ну вот, опять темнота. Надо найти фонарик, а то опять что-то потеряю.",
        "[ Мысли ]: Отлично, ещё и света нет. Как теперь работать?",
        "[ Мысли ]: Теперь нужно искать номер аварийки, как будто у меня других дел нет.",
        "[ Мысли ]: Вот и дождались - день в стиле \"средневековье\" - без света и интернета.",
        "[ Мысли ]: Что за невезение? Свет отрубили в самый неподходящий момент!",
        "[ Мысли ]: Вот так сюрприз! И почему всегда именно тогда, когда мне это совсем не нужно?",
        "[ Мысли ]: Ага, теперь придётся все свои вещи искать наощупь. Где мой телефон?",
        "[ Мысли ]: Темнота... Ну и где я теперь найду свой зарядник?",
        "[ Мысли ]: Хмм, может это повод заняться чем-то полезным? Хотя нет, без света ничего не поделать.",
        "[ Мысли ]: Знаю, что надо сохранять спокойствие, но эта тишина настораживает.",
        "[ Мысли ]: Ладно, осталось только надеяться, что это не надолго. Иначе можно сойти с ума.",
        "[ Мысли ]: Надеюсь, это просто перебой электричества, а не что-то серьёзное..",
        "[ Мысли ]: Отлично, теперь ещё и свет вырубился. Как будто работы и так мало.",
        "[ Мысли ]: Неужели это учения? Или у нас действительно проблемы? Надо быть наготове."
    };

    if (!status) {
        // Выключение света в здании
        new count;
        if (fractionid == 0) {
            new objects[1000];

            // Все 3 этажа
            for (new worldid = 255; worldid <= 257; worldid++)
            {
                count = Streamer_GetNearbyItems(1559.1282, -1656.2043, 16.2146, STREAMER_TYPE_OBJECT, objects, .range = 100.0, .worldid = worldid);
                for (new i = 0; i < min(count, sizeof(objects)); i++)
                {
                    new objectid = objects[i];
                    if (!IsValidDynamicObject(objectid)) break;
        
                    new model = GetDynamicObjectModel(objectid);

                    // Текстуры для ламп
                    if (model == 2642)
                    {
                        SetDynamicObjectMaterial(objectid, 0, 14534, "ab_wooziea", "light_full", 0xFFAAAAAA);
                        SetDynamicObjectMaterial(objectid, 1, 14534, "ab_wooziea", "light_full", 0xFFAAAAAA);
                        SetDynamicObjectMaterial(objectid, 2, 14534, "ab_wooziea", "light_full", 0xFFAAAAAA);
                        SetDynamicObjectMaterial(objectid, 3, 14576, "mafiacasinovault01", "ab_vaultmetal", 0xFFAAAAAA);
                    }

                    // Темное освещение
                    for (new materialindex = 0; materialindex <= 15; materialindex++)
                    {
                        new color = 0xFF464646;
                        if (worldid == 257) color = 0xFF303030; // Подвал темнее
                        if (model == 1649 || model == 19939 || model == 3857 || model == 2986 || model == 2987 || model == 19302 || model == 19304 || model == 19303) break;
                        if (model == 19843 || model == 914) color = 0xFF656565;
                        SetDynamicObjectColor(objectid, materialindex, color);
                    }
                }
            }

            foreach (new playerid : Player)
            {
                new worldid = GetPlayerVirtualWorld(playerid);
                if (worldid >= 255 && worldid <= 257) {
                    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
                    PlayerPlaySound(playerid, 6402);
                    SendClientMessage(playerid, COLOR_GREY, toggleoff_phrases[random(sizeof(toggleoff_phrases))]);
                }
            }
        } else if (fractionid == 1) {
            new objects[1000];

            // 2 этажа и серверная
            new worlds[] = {217, 243, 244};
            for (new world_i; world_i < sizeof(worlds); world_i++)
            {
                new worldid = worlds[world_i];

                if (worldid == 217) {
                    count = Streamer_GetNearbyItems(2408.4145, 2544.9953, 2105.0661, STREAMER_TYPE_OBJECT, objects, .range = 100.0, .worldid = worldid);
                } else {
                    count = Streamer_GetNearbyItems(2172.2468, 2385.2480, 23.6143, STREAMER_TYPE_OBJECT, objects, .range = 150.0, .worldid = worldid);
                }

                for (new i = 0; i < min(count, sizeof(objects)); i++)
                {
                    new objectid = objects[i];
                    if (!IsValidDynamicObject(objectid)) break;
        
                    new model = GetDynamicObjectModel(objectid);

                    // Текстуры для ламп
                    if (model == 19304 || model == 2642)
                    {
                        SetDynamicObjectMaterial(objectid, 0, 14534, "ab_wooziea", "light_full", 0xFFAAAAAA);
                        SetDynamicObjectMaterial(objectid, 1, 14534, "ab_wooziea", "light_full", 0xFFAAAAAA);
                        SetDynamicObjectMaterial(objectid, 2, 14534, "ab_wooziea", "light_full", 0xFFAAAAAA);
                        SetDynamicObjectMaterial(objectid, 3, 14576, "mafiacasinovault01", "ab_vaultmetal", 0xFFAAAAAA);
                    }

                    // Темное освещение
                    for (new materialindex = 0; materialindex <= 15; materialindex++)
                    {
                        new color = 0xFF606060;
                        if (model == 1649 || model == 19939 || model == 3857 || model == 3859 || model == 2986 || model == 2987
                        || model == 19302 || model == 19304 || model == 19303 || model == 14576 || model == 3089) break;
                        if (model == 19843 || model == 914 || model == 19355 || model == 19377) color = 0xFF707070;
                        SetDynamicObjectColor(objectid, materialindex, color);
                    }
                }
            }

            foreach (new playerid : Player)
            {
                new worldid = GetPlayerVirtualWorld(playerid);
                for (new world_i; world_i < sizeof(worlds); world_i++) {
                    if (worldid == worlds[world_i]) {
                        Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
                        PlayerPlaySound(playerid, 6402);
                        SendClientMessage(playerid, COLOR_GREY, toggleoff_phrases[random(sizeof(toggleoff_phrases))]);
                    }
                }
            }
        }
    } else {
        new count;
        // Включение света в здании
        if (fractionid == 0) {
            new objects[1000];

            // Все 3 этажа
            for (new worldid = 255; worldid <= 257; worldid++)
            {
                count = Streamer_GetNearbyItems(1559.1282, -1656.2043, 16.2146, STREAMER_TYPE_OBJECT, objects, .range = 100.0, .worldid = worldid);
                for (new i = 0; i < min(count, sizeof(objects)); i++)
                {
                    new objectid = objects[i];
                    if (!IsValidDynamicObject(objectid)) break;
        
                    new model = GetDynamicObjectModel(objectid);

                    // Возвращаем текстуры для ламп
                    if (model == 2642)
                    {
                        for (new j = 0; j < 4; j++) RemoveDynamicObjectMaterial(objectid, j);
                        SetDynamicObjectMaterial(objectid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
                        SetDynamicObjectMaterial(objectid, 1, 18835, "mickytextures", "whiteforletters", 0x00000000);
                        SetDynamicObjectMaterial(objectid, 2, 18835, "mickytextures", "whiteforletters", 0x00000000);
                        SetDynamicObjectMaterial(objectid, 3, 3440, "airportpillar", "metalic_64", 0x00000000);
                    }

                    // Возвращаем освещение
                    for (new materialindex = 0; materialindex <= 15; materialindex++)
                    {
                        SetDynamicObjectColor(objectid, materialindex, 0x00000000);
                    }
                }
            }

            foreach (new playerid : Player)
            {
                new worldid = GetPlayerVirtualWorld(playerid);
                if (worldid >= 255 && worldid <= 257) {
                    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
                }
            }
        } else if (fractionid == 1) {
            new objects[1000];

            // 2 этажа и серверная
            new worlds[] = {217, 243, 244};
            for (new world_i; world_i < sizeof(worlds); world_i++)
            {
                new worldid = worlds[world_i];

                if (worldid == 217) {
                    count = Streamer_GetNearbyItems(2408.4145, 2544.9953, 2105.0661, STREAMER_TYPE_OBJECT, objects, .range = 100.0, .worldid = worldid);
                } else {
                    count = Streamer_GetNearbyItems(2172.2468, 2385.2480, 23.6143, STREAMER_TYPE_OBJECT, objects, .range = 150.0, .worldid = worldid);
                }
                
                for (new i = 0; i < min(count, sizeof(objects)); i++)
                {
                    new objectid = objects[i];
                    if (!IsValidDynamicObject(objectid)) break;
        
                    new model = GetDynamicObjectModel(objectid);

                    // Возвращаем текстуры для ламп
                    if (model == 19304)
                    {
                        for (new j = 0; j < 4; j++) RemoveDynamicObjectMaterial(objectid, j);
                        SetDynamicObjectMaterial(objectid, 0, 3440, "airportpillar", "metalic_64", 0x00000000);
                    } else if (model == 2642)
                    {
                        for (new j = 0; j < 4; j++) RemoveDynamicObjectMaterial(objectid, j);
                        SetDynamicObjectMaterial(objectid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
                        SetDynamicObjectMaterial(objectid, 1, 18835, "mickytextures", "whiteforletters", 0x00000000);
                        SetDynamicObjectMaterial(objectid, 2, 18835, "mickytextures", "whiteforletters", 0x00000000);
                        SetDynamicObjectMaterial(objectid, 3, 2754, "otb_machine", "ab_shinyPanel", 0x00000000);
                    }

                    // Возвращаем освещение
                    for (new materialindex = 0; materialindex <= 15; materialindex++)
                    {
                        SetDynamicObjectColor(objectid, materialindex, 0x00000000);
                    }
                }
            }

            foreach (new playerid : Player)
            {
                new worldid = GetPlayerVirtualWorld(playerid);
                for (new world_i; world_i < sizeof(worlds); world_i++) {
                    if (worldid == worlds[world_i]) {
                        Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
                    }
                }
            }
        }
    }
    return 1;
}

stock PDatabase_ClearPassword(fractionid)
{
    for (new e_PoliceDatabasePasswordInfo: i; i < e_PoliceDatabasePasswordInfo; i++) policeDatabasePasswordInfo[fractionid][i] = 0;
    for (new i = 0; i < POLICE_DATABASE_HACK_PASSWORD_ATTEMPTS; i++) policeDatabasePasswordAttempts[fractionid][i][0] = EOS;

    return 1;
}

stock PDatabase_SetState(fractionid, e_PoliceDatabaseStates: status)
{
    switch (status)
    {
        case POLICE_DATABASE_STATE_NORMAL:
        {
            for (new i = 0; i < POLICE_DATABASE_MAX_GENERATORS; i++) policeDatabaseGeneratorInfo[fractionid][i][pdgiBroken] = false;
            for (new i = 0; i < sizeof(policeDatabasePickups); i++) {
                policeDatabaseVentState[i] = false;

                for (new e_PoliceDatabaseShieldInfo: j; j < e_PoliceDatabaseShieldInfo; j++) policeDatabaseShieldInfo[i][j] = 0;
            }
            for (new i = 0; i < MAX_REALPLAYERS; i++) policeDatabaseInfo[fractionid][pdiVentPlayers][i] = 0;
            policeDatabaseInfo[fractionid][pdiHackerID] = 0;
            policeDatabaseInfo[fractionid][pdiHacked] = false;
            policeDatabaseInfo[fractionid][pdiExplodeFiresCount] = 0;
            policeDatabaseInfo[fractionid][pdiExplodeJoin] = false;
            policeDatabaseInfo[fractionid][pdiHackAlarm] = false;
            
            PDatabase_ClearPassword(fractionid);
            PDatabase_SetAlarm(fractionid, false);
            PDatabase_ResetMap(fractionid);
        }
        case POLICE_DATABASE_STATE_NO_SHIELD:
        {
            PDatabase_SetAlarm(fractionid, false);
        }
        case POLICE_DATABASE_STATE_NO_GENERATORS:
        {
            PDatabase_SetLight(fractionid, false);
        }
        default: {}
    }
    policeDatabaseInfo[fractionid][pdiState] = status;

    PDatabase_UpdateResetTime(fractionid);

    return 1;
}

stock PDatabase_PlayerUseVent(fractionid, playerid)
{
    for (new i = 0; i < MAX_REALPLAYERS; i++)
    {
        if (policeDatabaseInfo[fractionid][pdiVentPlayers][i] == 0)
        {
            policeDatabaseInfo[fractionid][pdiVentPlayers][i] = PlayerInfo[playerid][pID];
            return 1;
        }
    }
    return 0;
}

stock PDatabase_IsPlayerUsedVent(fractionid, playerid)
{
    for (new i = 0; i < MAX_REALPLAYERS; i++)
    {
        new userid = policeDatabaseInfo[fractionid][pdiVentPlayers][i];
        if (userid == 0) break;

        if (userid == PlayerInfo[playerid][pID]) {
            return 1;
        }
    }

    return 0;
}

stock PDatabase_GetHackAvailableTime(fractionid)
{
    if (policeDatabaseInfo[fractionid][pdiHackAttemptTime] <= 0) return 0;
    return (POLICE_DATABASE_HACK_COOLDOWN * 3600) - (gettime() - policeDatabaseInfo[fractionid][pdiHackAttemptTime]);
}

stock PDatabase_GetFractionIDByPos(Float: x, Float: y, Float: z)
{
    // SAPD
    if (GetDistanceBetweenCoords3d(x, y, z, 1589.7787, -1659.9264, 19.8792) < 150.0) return 0;

    // FBI
    if (GetDistanceBetweenCoords3d(x, y, z, 2130.5959, 2421.5903, 64.2395) < 150.0) return 1;
    if (GetDistanceBetweenCoords3d(x, y, z, 2172.2490, 2384.7480, 23.6143) < 150.0) return 1;
    if (GetDistanceBetweenCoords3d(x, y, z, 2093.6726, 2414.5706, 74.5786) < 200.0) return 1;
    if (GetDistanceBetweenCoords3d(x, y, z, 2408.1709, 2534.8418, 2110.4668) < 150.0) return 1;

    for (new i = 0; i < sizeof(policeDatabasePickups); i++)
    {
        if (GetDistanceBetweenCoords3d(x, y, z, policeDatabasePickups[i][pdpX], policeDatabasePickups[i][pdpY], policeDatabasePickups[i][pdpZ]) <= 2.0) {
            return policeDatabasePickups[i][pdpFraction];
        }
    }

    return -1;
}

stock PDatabase_ResetMap(fractionid)
{
    for (new i = 0; i < POLICE_DATABASE_MAX_EXPLODE_SLOTS; i++)
    {
        for (new j = 0; j < POLICE_DATABASE_MAX_EXPLODE_OBJECTS; j++)
        {
            new objectid = policeDatabaseExplodeObjects[fractionid][i][j];
            if (!IsValidDynamicObject(objectid)) continue;

            DestroyDynamicObject(objectid);
            policeDatabaseExplodeObjects[fractionid][i][j] = INVALID_STREAMER_ID;
        }
    }

    PDatabase_SetLight(fractionid, true);
    PDatabase_Explode(fractionid, false);

    return 1;
}

stock PDatabase_DistanceProcess(playerid)
{
    if (!IsPlayerInRangeOfPoint(playerid, 0.5, policeDatabasePlayerInfo[playerid][pdpiX], policeDatabasePlayerInfo[playerid][pdpiY], policeDatabasePlayerInfo[playerid][pdpiZ]))
    {
        PlayerPlaySound(playerid, 31200, policeDatabasePlayerInfo[playerid][pdpiX], policeDatabasePlayerInfo[playerid][pdpiY], policeDatabasePlayerInfo[playerid][pdpiZ]);
        PDatabase_StopGeneratorBroke(playerid, 0);
        return 1;
    }

    return 0;
}

function PDatabase_GeneratorTime(playerid)
{
    if(InputProcess[playerid] >= 5)
	{
		if(PDatabase_DistanceProcess(playerid)) return 1;
		InputProcess[playerid] -= 5;
		processbar2(playerid, InputProcess[playerid]);
	}
	else
	{
        if(policeDatabasePlayerInfo[playerid][pdpiGeneratorTime] > 0) policeDatabasePlayerInfo[playerid][pdpiGeneratorTime]--;
		else
		{
			PDatabase_StopGeneratorBroke(playerid, 0);
		}
	}
	TextDrawHideForPlayer(playerid, InputDraw[0]), TextDrawHideForPlayer(playerid, InputDraw[5]);
	return 1;
}

stock PDatabase_ExplodeGenerator(fractionid, generatorid, playerid = INVALID_PLAYER_ID)
{
    new index = generatorid;
    for (new i = 0; i < POLICE_DATABASE_MAX_EXPLODE_OBJECTS; i++) DestroyDynamicObject(policeDatabaseExplodeObjects[fractionid][index][i]);

    new objectid = policeDatabaseGeneratorInfo[fractionid][generatorid][pdgiObjectID];
    if (!IsValidDynamicObject(objectid)) return 0;

    new Float: x, Float: y, Float: z,
        Float: rx, Float: ry, Float: rz;
    GetDynamicObjectPos(objectid, x, y, z);
    GetDynamicObjectRot(objectid, rx, ry, rz);

    policeDatabaseExplodeObjects[fractionid][index][0] = CreateDynamicObject(1687, 1585.372558, -1642.736938, 19.671188, 0.000000, 0.000000, 0.000000, 0, 0, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(policeDatabaseExplodeObjects[fractionid][index][0], 10, 18642, "taser1", "metalshinydented1", 0xFF000000);
    SetDynamicObjectMaterial(policeDatabaseExplodeObjects[fractionid][index][0], 11, 18642, "taser1", "metalshinydented1", 0xFF000000);
    SetDynamicObjectMaterial(policeDatabaseExplodeObjects[fractionid][index][0], 12, 18642, "taser1", "metalshinydented1", 0xFF000000);
    SetDynamicObjectMaterial(policeDatabaseExplodeObjects[fractionid][index][0], 13, 18642, "taser1", "metalshinydented1", 0xFF000000);
    SetDynamicObjectMaterial(policeDatabaseExplodeObjects[fractionid][index][0], 14, 18642, "taser1", "metalshinydented1", 0xFF000000);
    SetDynamicObjectMaterial(policeDatabaseExplodeObjects[fractionid][index][0], 15, 18642, "taser1", "metalshinydented1", 0xFF000000);
    policeDatabaseExplodeObjects[fractionid][index][1] = CreateDynamicObject(18718, 1586.489501, -1642.817260, 18.439153, 0.000000, 0.000000, 0.000000, 0, 0, -1, 300.00, 300.00);
    gadd(policeDatabaseExplodeObjects[fractionid][index][0], 0, 0);
    policeDatabaseExplodeObjects[fractionid][index][2] = CreateDynamicObject(18704, 1583.920532, -1643.018066, 18.217527, 18.199998, 0.000000, 0.000000, 0, 0, -1, 300.00, 300.00);
    gadd(policeDatabaseExplodeObjects[fractionid][index][1], 0, 0);
    policeDatabaseExplodeObjects[fractionid][index][3] = CreateDynamicObject(18686, 1585.340820, -1642.645385, 18.788427, 0.000000, 0.000000, 0.000000, 0, 0, -1, 300.00, 300.00);
    gadd(policeDatabaseExplodeObjects[fractionid][index][2], 0, 0);

    TSInfo[tsOffset][0] = 0.140380;
    TSInfo[tsOffset][1] = -0.167480;
    TSInfo[tsOffset][2] = -0.726829;

    MatrixDynamicObjectPos(0, x, y, z, rx, ry, rz);
    DestroyDynamicObject(policeDatabaseExplodeObjects[fractionid][index][0]);
    
    if (IsOnline(playerid)) {
        foreach (new id : Player)
        {
            if (GetDistanceBetweenPlayers(id, playerid) > 15.0) continue;
            Streamer_Update(id, STREAMER_TYPE_OBJECT);
            PlayerPlaySound(id, 0);
            PlayerPlaySound(id, 14401, x, y, z);
        }
    }

    PDatabase_UpdateResetTime(fractionid);

    return 1;
}

stock PDatabase_ExplodeShield(fractionid, shieldid, playerid = INVALID_PLAYER_ID)
{
    if (policeDatabasePickups[shieldid][pdpType] != POLICE_DATABASE_PICKUP_SHIELD) return 0;

    new index = 4 + shieldid;
    for (new i = 0; i < POLICE_DATABASE_MAX_EXPLODE_OBJECTS; i++) DestroyDynamicObject(policeDatabaseExplodeObjects[fractionid][index][i]);

    switch (shieldid) {
        case 3: {
            policeDatabaseExplodeObjects[fractionid][index][0] = CreateDynamicObject(18718, 1599.638183, -1647.137939, 20.811370, 0.000000, 79.799995, -5.400000, 0, 0, -1, 300.00, 300.00); 
            policeDatabaseExplodeObjects[fractionid][index][1] = CreateDynamicObject(18717, 1599.649291, -1646.666992, 19.469308, -27.899995, 0.000000, 13.499999, 0, 0, -1, 300.00, 300.00);
        }
        case 4: {
            policeDatabaseExplodeObjects[fractionid][index][0] = CreateDynamicObject(18718, 2144.169677, 2411.107177, 66.212860, 65.799987, 0.000000, -9.599997, 0, 0, -1, 300.00, 300.00);
            policeDatabaseExplodeObjects[fractionid][index][1] = CreateDynamicObject(18718, 2144.325927, 2411.227539, 66.108062, 80.499977, 21.000015, -8.599999, 0, 0, -1, 300.00, 300.00);
        }
        case 5: {
            policeDatabaseExplodeObjects[fractionid][index][0] = CreateDynamicObject(18717, 2162.579345, 2410.969970, 66.803237, 85.000053, 0.000000, -85.200012, 0, 0, -1, 300.00, 300.00);
            policeDatabaseExplodeObjects[fractionid][index][1] = CreateDynamicObject(18718, 2160.892822, 2410.452880, 66.279243, 82.500053, 0.000000, 90.000000, 0, 0, -1, 300.00, 300.00);
        }
        case 6: {
            policeDatabaseExplodeObjects[fractionid][index][0] = CreateDynamicObject(18688, 2157.311523, 2420.626464, 64.920524, -16.999998, 0.000000, 0.000000, 0, 0, -1, 300.00, 300.00);
            policeDatabaseExplodeObjects[fractionid][index][1] = CreateDynamicObject(18704, 2156.635253, 2419.882324, 65.209266, 0.000000, -46.999965, -2.399999, 0, 0, -1, 300.00, 300.00);
        }
    }
    if (IsOnline(playerid))
    {
        foreach (new id : Player)
        {
            if (GetDistanceBetweenPlayers(id, playerid) > 15.0) continue;
            Streamer_Update(id, STREAMER_TYPE_OBJECT);
            PlayerPlaySound(id, 6402, Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid]);
        }
    }

    PDatabase_UpdateResetTime(fractionid);

    return 0;
}

stock PDatabase_StopGeneratorBroke(playerid, stat)
{
    if (!policeDatabasePlayerInfo[playerid][pdpiGeneratorBroke]) return 0;

    ClearAnimations(playerid);
	ClearAnim(playerid);

    DP[0][playerid] = 0;
    InputProcess[playerid] = 0;
	InputID[playerid] = 0;
    KillTimer(policeDatabasePlayerInfo[playerid][pdpiGeneratorTimer]);

    if (stat == 0) { // Не смог сломать генератор
        PlayerPlaySound(playerid, 31200);
    } else if (stat == 1) {
        new fractionid = PDatabase_GetFractionIDByPos(Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid]);
        new generatorid = policeDatabasePlayerInfo[playerid][pdpiGeneratorID];

        policeDatabaseGeneratorInfo[fractionid][generatorid][pdgiBroken] = true;
        PDatabase_ExplodeGenerator(fractionid, generatorid, .playerid = playerid);
        {
            new str[256];
            new generators_broken = PDatabase_GetGeneratorsCount(fractionid, .broken = true);
            new generators_poweroff_need = PDatabase_GetGeneratorsCount(fractionid);

            strcat(str,
                "{99FF66}Вы успешно вывели генератор из строя!\n\n" \
                \
                "* Чем больше генераторов отключено, тем позднее сработает сигнализация в здании"
            );
            if (generators_broken < generators_poweroff_need) {
                format(str, sizeof(str), "%s\n* Отключение %d-х генераторов лишит здание электричества", str, generators_poweroff_need);
            } else {
                format(str, sizeof(str), "%s\n* Электричество в здании отключено", str);
            }
            SuccessMessage(playerid, str);

            new Float: x, Float: y, Float: z;
            GetDynamicObjectPos(policeDatabaseGeneratorInfo[fractionid][generatorid][pdgiObjectID], x, y, z);
            
            foreach (new id : Player)
            {
                if (GetPlayerVirtualWorld(id) != GetPlayerVirtualWorld(playerid)) continue;
                if (GetDistanceBetweenPlayers(id, playerid) > 65.0) continue;

                PlayerPlaySound(id, 6402, x, y, z);
            }

            if (generators_broken == generators_poweroff_need) { // Разрушены все генераторы
                SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я уничтожил%s оставшийся генератор, теперь здание оставлено без электричества.", gender(playerid));
                PDatabase_SetState(fractionid, POLICE_DATABASE_STATE_NO_GENERATORS);
                PlayerPlaySound(playerid, 21001, x, y, z);
                
                if(PlayerInfo[playerid][pAchieve][131] == 0) AchievePlayer(playerid, 131, 1); // Оставил здание без электричества
            }
        }
    }
    policeDatabasePlayerInfo[playerid][pdpiGeneratorBroke] = false;

    for (new i = 0; i <= 5; i++) TextDrawHideForPlayer(playerid, InputDraw[i]);
    PlayerTextDrawHide(playerid, InputDraw1);
	PlayerTextDrawHide(playerid, InputDraw2);

    return 1;
}

stock dialogCase_PDatabase(playerid, dialogid, response, listitem, const inputtext[])
{
    #pragma unused listitem

    switch (e_DialogId: dialogid)
    {
        case POLICE_DATABASE_DIALOG_VENT_EXIT:
        {
            if (!response) return 1;

            new i = DP[1][playerid];

            keep(playerid);
            S_SetPlayerVirtualWorld(playerid, policeDatabasePickups[i][pdpWorld], policeDatabasePickups[i][pdpInterior]);
            PPSetPlayerInterior(playerid, policeDatabasePickups[i][pdpInterior]);
            PPSetPlayerPos(playerid, policeDatabasePickups[i][pdpX], policeDatabasePickups[i][pdpY], policeDatabasePickups[i][pdpZ]);
            PPSetPlayerFacingAngle(playerid, policeDatabasePickups[i][pdpA]);
            SetCameraBehindPlayer(playerid);
            PlayerPlaySound(playerid, 1002);

            PDatabase_PlayerUseVent(policeDatabasePickups[i][pdpFraction], playerid);
        }
        case POLICE_DATABASE_DIALOG_HACK_START:
        {
            if (!response) return 1;
            PDatabase_SetHackStage(playerid, DP[0][playerid], POLICE_DATABASE_HACK_STAGE_GAME);
            exitkomp(playerid, 1);
        }
        case POLICE_DATABASE_DIALOG_HACKPASS_START:
        {
            return PDatabase_Dialog_HackPass(playerid);
        }
        case POLICE_DATABASE_DIALOG_HACKPASS:
        {
            if (policeDatabasePlayerInfo[playerid][pdpiHackStage] != POLICE_DATABASE_HACK_STAGE_PASSWORD) return ErrorMessage(playerid, "{FF6347}Вы не находитесь на этапе взлома пароля");
            if (DeathInfo[playerid][deathStatus]) return ErrorMessage(playerid, "{FF6347}Вы находитесь в стадии смерти");

            new fractionid = policeDatabasePlayerInfo[playerid][pdpiFractionID];
            
            if (!response) {
                return ShowDialog(playerid, POLICE_DATABASE_DIALOG_HACKPASS_DECLINE, DIALOG_STYLE_MSGBOX, "{ff6347}Отмена взлома базы данных",
                    "{ff6347}Вы уверены, что хотите отменить взлом?\n\n" \
                    \
                    "{cccccc}* Повторную попытку можно будет предпринять только через "#POLICE_DATABASE_HACK_COOLDOWN" час",

                    "Да", "Назад"
                );
            }

            new length = strlen(inputtext);

            if (gettime() - policeDatabaseInfo[fractionid][pdiHackPasswordAttempt] < POLICE_DATABASE_HACK_PASSWORD_COOLDOWN) return PDatabase_Dialog_HackPass(playerid, 4);
            if (length != 4) return PDatabase_Dialog_HackPass(playerid, 1);
            if (!PDatabase_IsPlayerNearHack(playerid, fractionid)) return PDatabase_Dialog_HackPass(playerid, 7);

            for (new i = 0; i < length; i++) {
                if (inputtext[i] < '0' || inputtext[i] > '9') {
                    return PDatabase_Dialog_HackPass(playerid, 2);
                } else {
                    new bool: found = false;
                    for (new j = 0; j < 4; j++) {
                        if (policeDatabasePasswordInfo[fractionid][pdiPasswordSymbols][j] == inputtext[i]) {
                            found = true;
                            break;
                        }
                    }
                    if (!found) return PDatabase_Dialog_HackPass(playerid, 5);
                }
            }

            for (new i = 0; i < strlen(policeDatabasePasswordInfo[fractionid][pdiPasswordSymbols]); i++)
            {
                new bool: found = false;
                for (new j = 0; j < length; j++) {
                    if (policeDatabasePasswordInfo[fractionid][pdiPasswordSymbols][i] == inputtext[j]) {
                        found = true;
                        break;
                    }
                }
                if (!found) return PDatabase_Dialog_HackPass(playerid, 6);
            }

            for (new i = 0; i < POLICE_DATABASE_HACK_PASSWORD_ATTEMPTS; i++)
            {
                if (isnull(policeDatabasePasswordAttempts[fractionid][i])) {
                    policeDatabasePasswordAttempts[fractionid][i][0] = EOS;
                    strcat(policeDatabasePasswordAttempts[fractionid][i], inputtext);

                    policeDatabaseInfo[fractionid][pdiHackPasswordAttempt] = gettime();

                    if (!strcmp(policeDatabasePasswordAttempts[fractionid][i], policeDatabasePasswordInfo[fractionid][pdiPassword])) {
                        return PDatabase_HackSuccess(playerid);
                    }
                    
                    break;
                } else if (!strcmp(policeDatabasePasswordAttempts[fractionid][i], inputtext)) {
                    return PDatabase_Dialog_HackPass(playerid, 3);
                }
            }

            PDatabase_Dialog_HackPass(playerid);
        }
        case POLICE_DATABASE_DIALOG_HACKPASS_DECLINE:
        {
            if (!response) return PDatabase_Dialog_HackPass(playerid);
            PDatabase_HackFail(playerid);
        }
        case POLICE_DATABASE_DIALOG_CLEAR_MENU:
        {
            if (!response) return 1;
            
            new fractionid = DP[0][playerid];
            
            if(listitem == 0) {
                SetPVarInt(playerid, "HackDatabaseMDC", 1);
                ShowDialog(playerid,566,DIALOG_STYLE_INPUT,"{444444}База Данных","{cccccc}Введите {ff9000}ID или никнейм {cccccc}игрока\nчтобы посмотреть всю информацию о нём","Принять","Отмена");
            } else if(listitem == 1)
            {
                if (policeDatabaseInfo[fractionid][pdiClearSuspectRemains] <= 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Теперь очистка розыска недоступна"), stop_dialog(playerid);
                PDatabase_Dialog_ClearId(playerid);
            }
        }
        case POLICE_DATABASE_DIALOG_CLEAR_ID:
        {
            if (!response) return PDatabase_Dialog_ClearMenu(playerid);

            new fractionid = DP[0][playerid];
            if (!PDatabase_IsPlayerNearHack(playerid, fractionid) || !policeDatabaseInfo[fractionid][pdiHacked]) return ErrorMessage(playerid, "{FF6347}Вы далеко от базы данных или она не была взломана");
            if (policeDatabaseInfo[fractionid][pdiLastHackerID] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к базе данных");

            new string[128];
            if(strlen(inputtext))
            {
                stop_dialog(playerid);
                new p = ReturnUser(inputtext, 1);
                if (IsNumeric(inputtext)) format(ListName[playerid], 24,"%s", rpplayername(p));
                else format(ListName[playerid], 24,"%s", inputtext);
                if(IsPlayerConnected(p))
                {
                    if(OnlineInfo[p][oLogged] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Его вообще нет.. [ Игрок не залогинился ]");
                    if(PlayerInfo[p][pCrimes] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Это не преступник.. [ Он не находится в розыске ]");

                    if(PlayerInfo[p][pCrimes] > 12 && fractionid == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: В базе данных SAPD нельзя очищать розыск особо опасным преступникам.");
                    if(PlayerInfo[p][pCrimes] < 6 && fractionid == 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: В базе данных FBI нельзя очищать розыск мелким преступникам.");

                    PlayerPlaySound(playerid, 6401, 0,0,0), PlayerPlaySound(p, 6401, 0, 0, 0);

                    format(string, sizeof(string), "* %s очищен уровень розыска", ListName[playerid]);
                    SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
                    format(string, sizeof(string), "* %s очистил ваш уровень розыска", rpplayername(playerid));
                    SendClientMessage(p, COLOR_LIGHTBLUE, string);
                    ClearAllWantedPlayer(p);

                    policeDatabaseInfo[fractionid][pdiClearSuspectRemains]--;
                }
                else
                {
                    if(!CheckRP_Nickname(inputtext)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
                    mysql_format(pearsq, string,sizeof(string),"SELECT Crimes FROM `pp_igroki` WHERE `Name` = '%e'", inputtext);
                    mysql_tquery(pearsq, string, "Call_clearsu", "dds", playerid, fractionid, inputtext);
                }
            }
            else PDatabase_Dialog_ClearId(playerid);
        }
        default: return 0;
    }

    return 1;
}

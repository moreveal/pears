stock Graves_IsExists(graveid)
{
    return IsValidDynamicObject(GraveInfo[graveid][giObjects][0]);
}

stock Graves_IsExcavated(graveid)
{
    return Graves_IsExists(graveid) && GetDynamicObjectVirtualWorld(GraveInfo[graveid][giObjects][0]) == 0;
}

stock Graves_GetClosest(playerid, Float: distance = 2.5)
{
    new id = -1;
    for (new i = 0; i < MAX_GRAVES; i++)
    {
        if (GetPlayerDistanceFromPoint(playerid, GraveInfo[i][giX], GraveInfo[i][giY], GraveInfo[i][giZ]) <= distance)
        {
            if (id == -1 || GetPlayerDistanceFromPoint(playerid, GraveInfo[i][giX], GraveInfo[i][giY], GraveInfo[i][giZ]) <
                            GetPlayerDistanceFromPoint(playerid, GraveInfo[id][giX], GraveInfo[id][giY], GraveInfo[id][giZ]))
            {
                id = i;
            }
        }
    }
    return id;
}

stock Graves_GetPlayerCooldown(playerid)
{
    new endtime = PlayerInfo[playerid][pCDGraves] + (GRAVES_PLAYER_COOLDOWN * 3600);
    new remains = endtime - gettime();
    
    if (server == 0) return 0; // На тестовом сервере КД нет
    if (remains > 0) return remains;

    return 0;
}

CMD:rgraves(playerid, const params[])
{
    if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    
    new currentid;
    sscanf(params, "U(-1)", currentid);
    if (currentid == -1) currentid = playerid;
    if(!IsOnline(currentid)) return ErrorMessage(playerid, "{FF6347}Игрок не в сети");

    PlayerInfo[currentid][pCDGraves] = 0;
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "** Вы очистили кд на Раскопку Могил для %s **", PlayerInfo[currentid][pName]);
    if(playerid != currentid) SendClientMessage(currentid, COLOR_LIGHTBLUE, "** %s очистил вам кд на Раскопку Могил **", PlayerInfo[playerid][pName]);

    AdminLog("rgraves", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[currentid][pID], PlayerInfo[currentid][pName], PlayerInfo[currentid][pPlaIP], 0, "");
    return 1;
}

function Graves_Reload(graveid)
{
    // Удаляем объекты гроба
    for (new i = 0; i < GRAVES_MAX_OBJECTS; i++)
    {
        if (!IsValidDynamicObject(GraveInfo[graveid][giObjects][i])) continue;
        DestroyDynamicObject(GraveInfo[graveid][giObjects][i]);
        GraveInfo[graveid][giObjects][i] = INVALID_STREAMER_ID;
    }
    GraveInfo[graveid][giPlayerID] = 0;
    GraveInfo[graveid][giOpened] = false;

    // Обновляем биографию человека
    Graves_UpdateBiography(graveid);

    // Возвращаем скрытые цветы
    {
        new objects[20];
        new count = Streamer_GetNearbyItems(GraveInfo[graveid][giX], GraveInfo[graveid][giY], GraveInfo[graveid][giZ], STREAMER_TYPE_OBJECT, objects, .range = 2.0);
        for (new i = 0; i < min(sizeof(objects), count); i++)
        {
            new objectid = objects[i];
            if (!IsValidDynamicObject(objectid)) break;

            if (GetDynamicObjectModel(objectid) == 870) {
                SetDynamicObjectVirtualWorld(objectid, 0);
            }
        }
    }

    return 1;
}

stock Graves_UpdateBiography(graveid)
{
    new bool: found;
    do {
        found = false;
        GraveInfo[graveid][giBiography] = random(GRAVES_MAX_BIOGRAPHIES) + 1;

        for (new i = 0; i < MAX_GRAVES; i++)
        {
            if (graveid == i) continue;
            if (GraveInfo[graveid][giBiography] == GraveInfo[i][giBiography]) {
                found = true;
                break;
            }
        }
    } while (found);
    
    return 1;
}

stock Graves_Init()
{
    #if GRAVES_MAX_BIOGRAPHIES <= MAX_GRAVES
        #error "The number of biographies must be greater than the number of graves"
    #endif

    static bool: init = false;
    if (!init) {
        init = true;

        GravesArea = CreateDynamicCube(804.272827, -1130.616821, 21.873744, 952.311950, -1063.319091, 41.357662, -1, 0);
        for (new Float: x = 882.050109, i = 0; i < MAX_GRAVES; x -= GRAVES_GAP, i++)
        {
            if (i == 9) x = 860.202880; // Корректировка для второго объекта надгробий

            GraveInfo[i][giX] = x;
            GraveInfo[i][giY] = -1108.184937;
            GraveInfo[i][giZ] = 23.407932;

            for (new j = 0; j < GRAVES_MAX_OBJECTS; j++) {
                Graves_UpdateBiography(i);
                GraveInfo[i][giObjects][j] = INVALID_STREAMER_ID;
            }
        }
    }

    return 1;
}

stock Graves_Dialog_Main(playerid, graveid)
{
    DP[0][playerid] = graveid;

    PlayerPlaySound(playerid, 1150);
    return ShowDialog(playerid, GRAVES_DIALOG_MAIN, DIALOG_STYLE_LIST, "{555555}Могила", "{cccccc}Просмотреть информацию\n{ff9000}Раскопать", "Выбор", "Закрыть");
}

stock Graves_Dialog_Open(playerid, graveid)
{
    if (GraveInfo[graveid][giPlayerID] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid, "{FF6347}Вы не можете начать открытие этого гроба [Его раскопал кто-то другой]");
    if (GraveInfo[graveid][giOpened]) return ErrorMessage(playerid, "{FF6347}Этот гроб уже был вскрыт");

    DP[0][playerid] = graveid;

    PlayerPlaySound(playerid, 1150);
    return ShowDialog(playerid, GRAVES_DIALOG_OPEN, DIALOG_STYLE_MSGBOX, "{555555}Могила", "{cccccc}Вы действительно хотите вскрыть этот гроб?\n\nУ вас будет шанс получить как обычные предметы, так и уникальные драгоценности\n\n{ff6347}[!] {cccccc}Вскрывая могилы, вы рискуете заразиться случайной болезнью", "Да", "Закрыть");
}

stock Graves_Dialog_ShowInfo(playerid, graveid)
{
    new biographyid = GraveInfo[graveid][giBiography] - 1;
    if (biographyid < 0) return 0;

    DP[0][playerid] = graveid;

    // Вычисляем годы жизни
    new startYear, endYear;
    {
        const minAge = 26, maxAge = 73;

        static year, month, day;
        if (year == 0) getdate(year, month, day);
        
        endYear = random_range(2000, year);
        new randomAge = random_range(minAge, maxAge);
        startYear = endYear - randomAge;
    }
    new age = endYear - startYear;

    new string[1024];
    format(string, sizeof(string),
        "{cccccc}Имя и фамилия: {ff9000}%s\n" \
        "{cccccc}Годы жизни: %04d - %04d {555555}[%d %s]\n\n" \
        \
        "{cccccc}%s",

        GraveBiography[biographyid][gbName],
        startYear, endYear, age, PluralToText(age, "год", "года", "лет"),
        GraveBiography[biographyid][gbText]
    );

    return ShowDialog(playerid, GRAVES_DIALOG_BIOGRAPHY, DIALOG_STYLE_MSGBOX, "{555555}Информация о могиле", string, "Назад", "");
}

stock Graves_GetSilverJewelPrice(id)
{
    new silverPrice;
    switch (id)
    {
        case 0: silverPrice = 8000;
        case 1: silverPrice = 15000;
        case 2: silverPrice = 25000;
        case 3: silverPrice = 40000;
        case 4: silverPrice = 65000;
    }
    return silverPrice;
}

stock Graves_GetGoldJewelPrice(id)
{
    return (id + 1) * 2;
}

stock Graves_RandomSilverJewel(&id, &price)
{
    id = random(sizeof(GravesSilverJewels));
    price = Graves_GetSilverJewelPrice(id);

    return 1;
}

stock Graves_RandomGoldJewel(&id, &price)
{
    id = random(sizeof(GravesGoldJewels));
    price = Graves_GetGoldJewelPrice(id);

    return 1;
}

stock Graves_GiveGoldJewel(playerid, id)
{
    new goldPrice = Graves_GetGoldJewelPrice(id);
    if (goldPrice < 1) return 0;
    
    if (goldPrice > 0) {
        PlayerInfo[playerid][pDonateMoney] += goldPrice;
        DonateLog("givegold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", goldPrice, "Раскопка могил");

        new f_str[128];
        mysql_format(pearsq, f_str, sizeof(f_str), "UPDATE `pp_igroki` SET `DonateMoney`='%d' WHERE `Name`='%e'", PlayerInfo[playerid][pDonateMoney], PlayerInfo[playerid][pName]);
        query_empty(pearsq, f_str);
    }
    return 1;
}

stock Graves_GiveSilverJewel(playerid, id)
{
    new silverPrice = Graves_GetSilverJewelPrice(id);
    if (silverPrice < 1) return 0;

    oGivePlayerMoney(playerid, silverPrice);
    MoneyLog("givemoney", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", silverPrice, "Раскопка могил");

    return 1;
}

stock Graves_Open(playerid, graveid)
{
    if (GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return 0;
    if (!IsPlayerInRangeOfPoint(playerid, 10.0, GraveInfo[graveid][giX], GraveInfo[graveid][giY], GraveInfo[graveid][giZ])) return 0;
    if (!Streamer_HasIntData(STREAMER_TYPE_OBJECT, GraveInfo[graveid][giObjects][0], STREAMER_GRAVE_TYPE)) return 0;

    // Формируем список доступных для заражения болезней
    new names[][] = {"Грибок", "Дерматит", "Акне", "Грипп", "ОРВИ", "Сифилис"};
    static illnessList[sizeof(names)];
    if (illnessList[0] == 0) {
        new illness_index = 0;
        for (new i = 0; i < sizeof(illnessName); i++)
        {
            for (new j = 0; j < sizeof(names); j++)
            {
                if (!strcmp(names[j], illnessName[i], true)) {
                    illnessList[illness_index++] = i;
                    break;
                }
            }
        }
    }

    new illness_chance, gold_chance, silver_chance, item_chance;
    switch (e_GraveType: Streamer_GetIntData(STREAMER_TYPE_OBJECT, GraveInfo[graveid][giObjects][0], STREAMER_GRAVE_TYPE))
    {
        case GRAVE_TYPE_SHIT: illness_chance = 45, gold_chance = 4, silver_chance = 48, item_chance = 50;
        case GRAVE_TYPE_NORMAL: illness_chance = 28, gold_chance = 10, silver_chance = 65, item_chance = 20;
        case GRAVE_TYPE_EXPENSIVE: illness_chance = 8, gold_chance = 40, silver_chance = 100, item_chance = 5;
    }
    // [Возможно, следует добавить корректировку шансов для конкретных биографий]

    // Назначаем игроку болезнь
    new illnessId = -1;
    if (random(100) + 1 <= illness_chance) {
        illnessId = illnessList[random(sizeof(illnessList))];

        new result = infect(playerid, illnessId, 2000);
        if (result < 0) illnessId = -1; // Не удалось выдать болезнь
    }
    #pragma unused illnessId // Возможно будет выводиться в диалоге

    // Назначаем игроку золотое украшение
    new goldJewelId = -1, goldPrice;
    if (random(100) + 1 <= gold_chance) {
        Graves_RandomGoldJewel(goldJewelId, goldPrice);
    }

    // Назначаем игроку серебрянное украшение
    new silverJewelId = -1, silverPrice;
    if (random(100) + 1 <= silver_chance) {
        Graves_RandomSilverJewel(silverJewelId, silverPrice);
    }

    // Назначаем игроку предметы (мусор)
    if (goldJewelId < 0 && silverJewelId < 0) item_chance = 100; // Гарантированное нахождение простого предмета при отсутствии драгоценностей
    new itemId = -1, itemQuan = 1;
    new items[] = {3, 13, 19, 45, 90, 91, 95, 111, 201, 234, 235, 238};
    if (random(100) + 1 <= item_chance) {
        itemId = items[random(sizeof(items))];
        
        new quan, para;
        ThingParameters(playerid, itemId, quan, para);

        quan = GetFullThingQuan(itemId);
        if (quan > 1) {
            itemQuan = random(quan);
        }

        new put_inva = GiveThingPlayer(playerid, itemId, itemQuan, para, 0, 0, 0);
        if (put_inva < 0) itemId = -1; // Не удалось выдать предмет
    }

    new dialog_text[1024];
    strcat(dialog_text, "{cccccc}Вы вскрыли гроб и обыскали его!\n\nСписок найденных предметов:");
    if (goldJewelId < 0 && silverJewelId < 0 && itemId < 0) {
        strcat(dialog_text, "\n{555555}Вы ничего не нашли");
    } else {
        if (goldJewelId > -1) format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}- {ff9000}%s {ffcc00}[%d Gold]", dialog_text, GravesGoldJewels[goldJewelId], goldPrice);
        if (silverJewelId > -1) format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}- {bbbbbb}%s {99ff66}[%s$]", dialog_text, GravesSilverJewels[silverJewelId], FormatNumberWithCommas(silverPrice));
        if (itemId > -1) {
            if (itemQuan > 1) format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}- {555555}%s (%d шт.)", dialog_text, GetNameThing(0, itemId, 0, 0), itemQuan);
            else format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}- {555555}%s", dialog_text, GetNameThing(0, itemId, 0, 0));
        }

        // Выдаём золото и деньги (обычные предметы выдаются сразу)
        if (goldPrice > 0) Graves_GiveGoldJewel(playerid, goldJewelId);
        if (silverPrice > 0) Graves_GiveSilverJewel(playerid, silverJewelId);
    }

    strcat(dialog_text,
        "\n\n{cccccc}Памятка:\n" \
        "{cccccc}- Обычные вещи можно сдать скупщику (при условии, что они легальные)\n" \
        "{cccccc}- Золотые и серебряные украшения автоматически конвертируются в игровую валюту ({99ff66}Деньги{cccccc}, {ffcc00}Золото{cccccc})\n" \
        "{cccccc}- Раскапывать могилы можно не чаще чем 1 раз в "#GRAVES_PLAYER_COOLDOWN" часа"
    );

    PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/treasure-chest-open-empt.mp3");
    ShowDialog(playerid, GRAVES_DIALOG_LOOT, DIALOG_STYLE_MSGBOX, "{555555}Обыск могилы", dialog_text, "Ок", "");

    if (PlayerInfo[playerid][pAchieve][21] == 0) AchievePlayer(playerid, 21, 1);
    GraveInfo[graveid][giOpened] = true;

    return 1;
}

stock Graves_IsExcavate(playerid)
{
    return GetPVarInt(playerid, "Arobsklad") == 14;
}

stock Graves_StartPump(playerid, graveid)
{
    if (GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return 0;
    if (GetPVarInt(playerid, "Arobsklad") > 0) return 0;
    if (!IsPlayerInRangeOfPoint(playerid, 2.5, GraveInfo[graveid][giX], GraveInfo[graveid][giY], GraveInfo[graveid][giZ])) return 0;
    if (Graves_IsExcavate(playerid)) return ErrorMessage(playerid, "{FF6347}Вы уже раскапываете могилу");

    {
        new cooldown = Graves_GetPlayerCooldown(playerid);
        if (cooldown > 0) {
            new string[144];

            new year, month, day, hour, minute, second;
            stamp2datetime(PlayerInfo[playerid][pCDGraves] + (GRAVES_PLAYER_COOLDOWN * 3600), year, month, day, hour, minute, second, 3);
            format(string, sizeof(string), "{FF6347}Нельзя начинать раскопку могил так часто [ Недоступно до %02d.%02d %02d:%02d:%02d ]", day, month, hour, minute, second);
            return ErrorMessage(playerid, string);
        }
    }
    if(get_invent4(playerid, 44, 0) <= 0) { ErrorMessage(playerid, "{FF6347}У вас нет лопаты"); return 0; }
    if(Hold[playerid] != 6) { ErrorMessage(playerid, "{FF6347}Возьмите в руки лопату, чтобы начать копать [ N или /shovel ]"); return 0; }
    
    SetPVarInt(playerid, "GraveID", graveid);
    SetPVarInt(playerid, "oryjtemp", 0); SetPVarInt(playerid, "Arobsklad", 14);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Теперь мне нужно начать раскапывать могилу {ff9000}[ Нажимайте %s ]", buttonName[Device[playerid]]);

    // Восстанавливаем гроб через пять минут принудительно, если игрок перестанет нажимать клавиши и т.д.
    SetTimerEx("Graves_Reload", 5 * 60 * 1000, false, "d", graveid);

    return 1;
}

stock Graves_FailPump(playerid)
{
    SetPVarInt(playerid, "oryjtemp", 0);
    SetPVarInt(playerid, "Arobsklad", 0);

    ClearAnim(playerid);
    PlayerPlaySound(playerid, 31203, 0.0, 0.0, 0.0);
    
    Graves_Reload(GetPVarInt(playerid, "GraveID"));
    return 1;
}

stock Graves_Pump(playerid)
{
    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, Aftextdraw[playerid]);
    if(interval > 500)
    {
        Aftextdraw[playerid] = current_tick;
        
        new graveid = GetPVarInt(playerid, "GraveID"), string[144];
        new biographyid = GraveInfo[graveid][giBiography] - 1;

        // Проверка на дистанцию, доступ и прочее
        if (!IsPlayerInRangeOfPoint(playerid, 10.0, GraveInfo[graveid][giX], GraveInfo[graveid][giY], GraveInfo[graveid][giZ]) // Далеко от гроба
            || Hold[playerid] != 6  // Нет лопаты в руках
            || biographyid < 0) // Не установлена биография для гроба (странно)
        {
            return Graves_FailPump(playerid);
        }

        SetPVarInt(playerid,"oryjtemp",GetPVarInt(playerid,"oryjtemp")+1);
        new current_progress = GetPVarInt(playerid,"oryjtemp");

        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Grave: ~w~%d/"#GRAVES_EXCAVATION_TIMES, current_progress), GameTextForPlayer(playerid,string,2000,3);
        ApplyAnimation(playerid,"SWORD","sword_4",4.0, false, false, false, false, false, SYNC_ALL), PlayerPlaySound(playerid,20800,0,0,0);
        SetPlayerArmedWeapon(playerid, WEAPON_FIST);
        if(current_progress <= 1) {
            if (Graves_IsExists(graveid)) return Graves_FailPump(playerid);

            new chances[] = {50, 40, 10}; // Шансы по умолчанию для создания гробов: Худший, Средний, Лучший
            switch (e_GraveBiographyType: biographyid)
            {
                case GRAVE_BIO_HOMELESS: chances[0] += 20, chances[1] -= 15, chances[2] -= 5; // 70, 25, 5
                case GRAVE_BIO_NORMAL: chances[0] -= 10, chances[1] += 5, chances[2] += 5; // 40, 45, 15
                case GRAVE_BIO_RICH: chances[0] -= 10, chances[2] += 10; // 40, 40, 20
            }
            
            // Объект гроба
            new rand = random(100) + 1;
            if (rand <= chances[0]) { // Худший
                GraveInfo[graveid][giObjects][0] = CreateDynamicObject(19339, GraveInfo[graveid][giX], GraveInfo[graveid][giY], GraveInfo[graveid][giZ], 0.000000, 0.000000, 90.000000, INVISIBLE_VIRTUAL_WORLD, 0, -1, 300.00, 300.00); // Гроб (Плохой)
                SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][0], 0, 14735, "newcrak", "AH_skirtscum", 0x00000000);
                SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][0], 1, 14735, "newcrak", "AH_skirtscum", 0x00000000);
                SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][0], 2, 15041, "bigsfsave", "AH_wdpanscum", 0x00000000);
                Streamer_SetIntData(STREAMER_TYPE_OBJECT, GraveInfo[graveid][giObjects][0], STREAMER_GRAVE_TYPE, GRAVE_TYPE_SHIT);
            } else if (rand <= chances[0] + chances[1]) { // Средний
                GraveInfo[graveid][giObjects][0] = CreateDynamicObject(19339, GraveInfo[graveid][giX], GraveInfo[graveid][giY], GraveInfo[graveid][giZ], 0.000007, 0.000000, 89.999977, INVISIBLE_VIRTUAL_WORLD, 0, -1, 300.00, 300.00); // Гроб (Средний)
                SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][0], 0, 14650, "ab_trukstpc", "sa_wood08_128", 0x00000000);
                SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][0], 1, 14650, "ab_trukstpc", "sa_wood08_128", 0x00000000);
                SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][0], 2, 18029, "genintintsmallrest", "GB_restaursmll04", 0x00000000);
                Streamer_SetIntData(STREAMER_TYPE_OBJECT, GraveInfo[graveid][giObjects][0], STREAMER_GRAVE_TYPE, GRAVE_TYPE_NORMAL);
            } else { // Лучший
                GraveInfo[graveid][giObjects][0] = CreateDynamicObject(19339, GraveInfo[graveid][giX], GraveInfo[graveid][giY], GraveInfo[graveid][giZ], 0.000007, 0.000000, 89.999977, INVISIBLE_VIRTUAL_WORLD, 0, -1, 300.00, 300.00); // Гроб (Лучший)
                SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][0], 0, 15048, "labigsave", "ah_pluskirt", 0x00000000);
                SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][0], 1, 15048, "labigsave", "ah_pluskirt", 0x00000000);
                SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][0], 2, 14748, "sfhsm1", "ah_pnwainscot6", 0x00000000);
                Streamer_SetIntData(STREAMER_TYPE_OBJECT, GraveInfo[graveid][giObjects][0], STREAMER_GRAVE_TYPE, GRAVE_TYPE_EXPENSIVE);
            }
            
            // Вариации песка
            switch (random(2))
            {
                case 0: {
                    GraveInfo[graveid][giObjects][1] = CreateDynamicObject(10985, GraveInfo[graveid][giX] - 0.006409, GraveInfo[graveid][giY] + 0.176025, GraveInfo[graveid][giZ] - 1.343970, -1.100000, -0.399998, -61.699943, 0, 0, -1, 300.00, 300.00); // Песок (1)
                    SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][1], 0, 17101, "cuntwlandse", "grasstype5_dirt", 0x00000000);
                    GraveInfo[graveid][giObjects][2] = CreateDynamicObject(10985, GraveInfo[graveid][giX] - 0.365906, GraveInfo[graveid][giY] + 0.842773, GraveInfo[graveid][giZ] - 1.458569, -1.100000, -0.399998, 75.100059, 0, 0, -1, 300.00, 300.00); // Песок (1)
                    SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][2], 0, 17101, "cuntwlandse", "grasstype5_dirt", 0x00000000);
                    GraveInfo[graveid][giObjects][3] = CreateDynamicObject(10986, GraveInfo[graveid][giX] + 1.293518, GraveInfo[graveid][giY] + 0.973877, GraveInfo[graveid][giZ] - 1.010983, -5.299996, -4.699997, 95.199989, 0, 0, -1, 300.00, 300.00); // Песок (1)
                    SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][3], 0, 17101, "cuntwlandse", "grasstype5_dirt", 0x00000000);
                    GraveInfo[graveid][giObjects][4] = CreateDynamicObject(19626, GraveInfo[graveid][giX] + 1.104614, GraveInfo[graveid][giY] - 0.423584, GraveInfo[graveid][giZ] + 0.773386, -9.100000, -3.399998, -160.900024, INVISIBLE_VIRTUAL_WORLD, 0, -1, 300.00, 300.00); // Лопата (1)
                    SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][4], 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
                    SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][4], 1, 3629, "arprtxxref_las", "metaldoor_128", 0x00000000);
                    SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][4], 2, 14888, "gf6", "mp_millie_wood", 0x00000000);
                }
                default: {
                    GraveInfo[graveid][giObjects][1] = CreateDynamicObject(10985, GraveInfo[graveid][giX] - 0.006409, GraveInfo[graveid][giY] + 0.176025, GraveInfo[graveid][giZ] - 1.392918, -0.500006, -1.599995, -55.699844, 0, 0, -1, 300.00, 300.00); // Песок (2)
                    SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][1], 0, 17101, "cuntwlandse", "grasstype5_dirt", 0x00000000);
                    GraveInfo[graveid][giObjects][2] = CreateDynamicObject(10985, GraveInfo[graveid][giX] - 0.365906, GraveInfo[graveid][giY] + 0.842773, GraveInfo[graveid][giZ] - 1.447609, -1.099992, -0.399998, 75.100059, 0, 0, -1, 300.00, 300.00); // Песок (2)
                    SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][2], 0, 17101, "cuntwlandse", "grasstype5_dirt", 0x00000000);
                    GraveInfo[graveid][giObjects][3] = CreateDynamicObject(10986, GraveInfo[graveid][giX] + 1.293518, GraveInfo[graveid][giY] + 0.973877, GraveInfo[graveid][giZ] - 0.937178, -5.299989, -4.699997, 95.199966, 0, 0, -1, 300.00, 300.00); // Песок (2)
                    SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][3], 0, 17101, "cuntwlandse", "grasstype5_dirt", 0x00000000);
                    GraveInfo[graveid][giObjects][4] = CreateDynamicObject(19626, GraveInfo[graveid][giX] + 1.104614, GraveInfo[graveid][giY] - 0.423584, GraveInfo[graveid][giZ] + 0.786135, -9.100002, 4.299991, 131.400039, INVISIBLE_VIRTUAL_WORLD, 0, -1, 300.00, 300.00); // Лопата (2)
                    SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][4], 0, 18800, "mroadhelix1", "concreteoldpainted1", 0x00000000);
                    SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][4], 1, 3629, "arprtxxref_las", "metaldoor_128", 0x00000000);
                    SetDynamicObjectMaterial(GraveInfo[graveid][giObjects][4], 2, 14888, "gf6", "mp_millie_wood", 0x00000000);
                }
            }

            // Опускаем все объекты под землю
            for (new i = 0; i < GRAVES_MAX_OBJECTS; i++)
            {
                if (!IsValidDynamicObject(GraveInfo[graveid][giObjects][i])) continue;

                new Float: z;
                Streamer_GetFloatData(STREAMER_TYPE_OBJECT, GraveInfo[graveid][giObjects][i], E_STREAMER_Z, z);
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, GraveInfo[graveid][giObjects][i], E_STREAMER_Z, z - GRAVES_UNDER_GROUND);
            }
            
            // Прячем цветы при начале раскопок
            {
                new objects[20];
                new count = Streamer_GetNearbyItems(GraveInfo[graveid][giX], GraveInfo[graveid][giY], GraveInfo[graveid][giZ], STREAMER_TYPE_OBJECT, objects, .range = 2.0);
                for (new i = 0; i < min(sizeof(objects), count); i++)
                {
                    new objectid = objects[i];
                    if (!IsValidDynamicObject(objectid)) break;

                    if (GetDynamicObjectModel(objectid) == 870)
                    {
                        SetDynamicObjectVirtualWorld(objectid, INVISIBLE_VIRTUAL_WORLD);
                    }
                }
            }
            
            GraveInfo[graveid][giPlayerID] = PlayerInfo[playerid][pID];
            PlayerInfo[playerid][pCDGraves] = gettime();

            Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
        }
        else if(current_progress >= 2 && current_progress < GRAVES_EXCAVATION_TIMES) {
            if (!Graves_IsExists(graveid)) return Graves_FailPump(playerid);

            for (new i = 0; i < GRAVES_MAX_OBJECTS; i++)
            {
                if (!IsValidDynamicObject(GraveInfo[graveid][giObjects][i])) continue;

                new Float: x, Float: y, Float: z;
                GetDynamicObjectPos(GraveInfo[graveid][giObjects][i], x, y, z);

                z += 1.0 / GRAVES_EXCAVATION_TIMES * GRAVES_UNDER_GROUND;
                MoveDynamicObject(GraveInfo[graveid][giObjects][i], x, y, z, 0.3);
            }
        } else {
            if (!Graves_IsExists(graveid)) return Graves_FailPump(playerid);

            // Убираем лопату из рук
            if (Hold[playerid] == 6) pc_cmd_shovel(playerid);

            // Отображаем лопату в песке
            if (IsValidDynamicObject(GraveInfo[graveid][giObjects][4])) {
                SetDynamicObjectVirtualWorld(GraveInfo[graveid][giObjects][4], 0);
            }

            // Отображаем сам гроб
            SetDynamicObjectVirtualWorld(GraveInfo[graveid][giObjects][0], 0);

            // Телепортируем игрока (костыльный фикс возможного подбрасывания)
            {
                new Float: x = GraveInfo[graveid][giX],
                    Float: y = GraveInfo[graveid][giY],
                    Float: z = GraveInfo[graveid][giZ] + 0.6,
                    Float: a = 180.0;
                
                backme(INVALID_PLAYER_ID, 2.35, x, y, z, a);
                PPSetPlayerPos(playerid, x, y, z);
                PPSetPlayerFacingAngle(playerid, a);
            }

            // Очистка переменных
            DeletePVar(playerid, "GraveID");
            DeletePVar(playerid, "oryjtemp"), DeletePVar(playerid, "Arobsklad");
            
            GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Grave: ~w~"#GRAVES_EXCAVATION_TIMES"/"#GRAVES_EXCAVATION_TIMES, 1500, 3);
            PlayerPlaySound(playerid, 32000);
            ClearAnim(playerid);
            
            SetTimerEx("Graves_Reload", 5 * 60 * 1000, false, "d", graveid);
            PlayerPlaySound(playerid, 6401);

            foreach (new id : Player)
            {
                if (GetPlayerVirtualWorld(id) != 0) continue;
                if (!IsPlayerInRangeOfPoint(id, 10.0, GraveInfo[graveid][giX], GraveInfo[graveid][giY], GraveInfo[graveid][giZ])) continue;
                
                Streamer_Update(id, STREAMER_TYPE_OBJECT);
            }
        }
    }
    return 1;
}

stock dialogCase_Graves(playerid, dialogid, response, listitem) {
    switch (e_DialogId: dialogid) {
        case GRAVES_DIALOG_MAIN:
        {
            if (!response) return 1;

            new graveid = DP[0][playerid];
            if (!IsPlayerInRangeOfPoint(playerid, 5.0, GraveInfo[graveid][giX], GraveInfo[graveid][giY], GraveInfo[graveid][giZ])) return 1;

            switch (listitem)
            {
                case 0: return Graves_Dialog_ShowInfo(playerid, graveid);
                case 1: {
                    if (Graves_IsExists(graveid)) return ErrorMessage(playerid, "{FF6347}Вы не можете начать раскапывать эту могилу");
                    return Graves_StartPump(playerid, graveid);
                }
            }
        }
        case GRAVES_DIALOG_BIOGRAPHY:
        {
            if (!response) return 1;

            return Graves_Dialog_Main(playerid, DP[0][playerid]);
        }
        case GRAVES_DIALOG_OPEN:
        {
            if (!response) return 1;
            return Graves_Open(playerid, DP[0][playerid]);
        }
        case GRAVES_DIALOG_LOOT:
        {
            return Graves_TryCreateNPC(playerid);
        }
        default: return 0;
    }

    return 1;
}

stock Graves_OnPlayerPressALT(playerid)
{
    new graveid = Graves_GetClosest(playerid);
    if (graveid < 0) return 0;
    
    if (Graves_IsExists(graveid)) {
        if (Graves_IsExcavated(graveid)) return Graves_Dialog_Open(playerid, graveid);
        return 1;
    }
    Graves_Dialog_Main(playerid, graveid);
    
    return 1;
}

stock Graves_OnPlayerDisconnect(playerid)
{
    if (IsValidNpc(GravePlayerInfo[playerid][gpiNPC])) DestroyNpc(GravePlayerInfo[playerid][gpiNPC]);
    
    for (new e_GravePlayerInfo: i; i < e_GravePlayerInfo; i++) GravePlayerInfo[playerid][i] = 0;

    for (new i = 0; i < MAX_GRAVES; i++)
    {
        if (GraveInfo[i][giPlayerID] == PlayerInfo[playerid][pID]) {
            Graves_Reload(i);
            break;
        }
    }

    return 1;
}

stock Graves_GetPlayerVirtualWorld(playerid)
{
    return GRAVES_MIN_VIRTUAL_WORLD + playerid;
}

function Graves_DestroyParticle(objectid)
{
    return DestroyDynamicObject(objectid);
}

function Graves_DestroyNpc(playerid)
{
    if (IsValidNpc(GravePlayerInfo[playerid][gpiNPC])) {
        DestroyNpc(GravePlayerInfo[playerid][gpiNPC]);
        GravePlayerInfo[playerid][gpiNPC] = NPC: 0;

        if (GetPlayerVirtualWorld(playerid) == Graves_GetPlayerVirtualWorld(playerid)) {
            SetPlayerVirtualWorld(playerid, 0);
        }

        return 1;
    }

    return 0;
}

function Graves_ProcessNpc(playerid, NPC: npc)
{
    if (!IsValidNpc(npc)) return 0;
    if (npc != GravePlayerInfo[playerid][gpiNPC]) return 0;

    new Float: x, Float: y, Float: z;
    GetNpcPosition(npc, x, y, z);

    // Регенерация HP (+8.0HP каждую секунду)
    {
        new Float: health;
        GetNpcHealth(npc, health);

        if (health > 0.0 && health < GravePlayerInfo[playerid][gpiNPCMaxHealth]) {
            health += 8.0;
            if (health > GravePlayerInfo[playerid][gpiNPCMaxHealth]) {
                health = GravePlayerInfo[playerid][gpiNPCMaxHealth];
            }

            SetNpcHealth(npc, health);
        }
    }

    new Float: distance = GetPlayerDistanceFromPoint(playerid, x, y, z);
    if (GravePlayerInfo[playerid][gpiLastDistChange] == 0) {
        GravePlayerInfo[playerid][gpiLastDistChange] = gettime();
        GravePlayerInfo[playerid][gpiLastDist] = distance;
    } else if (IsPlayerInRangeOfPoint(playerid, 1.0, x, y, z) || floatabs(distance - GravePlayerInfo[playerid][gpiLastDist]) > 5.0) {
        GravePlayerInfo[playerid][gpiLastDistChange] = gettime();
        GravePlayerInfo[playerid][gpiLastDist] = distance;
    } else {
        if(gettime() - GravePlayerInfo[playerid][gpiLastDistChange] >= 10)
        {
            new Float: px, Float: py, Float: pz, Float: pa;
            GetPlayerPos(playerid, px, py, pz);
            GetPlayerFacingAngle(playerid, pa);

            // Телепортируем за спину к игроку
            backme(playerid, 0.5, px, py, pz, pa);
            SetNpcPosition(npc, px, py, pz);
            SetNpcFacingAngle(npc, pa);

            // Эффект телепорта
            Graves_CreateParticleNpc(npc, 18682, px, py, pz);
            Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

            GravePlayerInfo[playerid][gpiLastDistChange] = gettime();
            GravePlayerInfo[playerid][gpiLastDist] = 0.0;
        }
    }

    return SetTimerEx("Graves_ProcessNpc", 1000, false, "dd", playerid, _:npc);
}

stock Graves_CreateParticleNpc(NPC: npc, modelid, Float: x, Float: y, Float: z, time = 1000)
{
    new playerid = INVALID_PLAYER_ID;
    foreach (new id : Player)
    {
        if (GravePlayerInfo[id][gpiNPC] == npc)
        {
            playerid = id;
            break;
        }
    }
    if (!IsOnline(playerid)) return 0;

    new worldid = GetNpcVirtualWorld(npc);
    new particle = CreateDynamicObject(modelid, x, y, z, 0.0, 0.0, 0.0, worldid, 0);
    SetTimerEx("Graves_DestroyParticle", time, false, "d", particle);
    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

    return 1;
}

stock Graves_TryCreateNPC(playerid)
{
    new SPAWN_CHANCE = 10; // Шанс спавна одного из NPC по умолчанию

    if (get_invent2(playerid, 242, 0)) { // Гарантированный спавн духа с Черепом Осириса
        return Graves_CreateNPC(playerid, GRAVE_NPC_TYPE_SPIRIT);
    } else {
        if (get_invent2(playerid, 243, 0)) SPAWN_CHANCE += 15; // Некрономикон
        if (get_invent2(playerid, 5, 0)) SPAWN_CHANCE += 12; // Доска Уиджи
        if (get_invent2(playerid, 180, 0)) SPAWN_CHANCE += 8; // Карты таро
        if (get_invent2(playerid, 198, 0)) SPAWN_CHANCE += 5; // Кукла вуду
    }

    if (random(100) < SPAWN_CHANCE)
    {
        switch (random(4))
        {
            case 0: return Graves_CreateNPC(playerid, GRAVE_NPC_TYPE_SPIRIT);
            default: return Graves_CreateNPC(playerid, GRAVE_NPC_TYPE_GHOST);
        }
    }
    
    return 1;
}

stock Graves_CreateNPC(playerid, e_GraveNPCType: type, bool: force = false)
{
    #pragma unused force
    
    // Спавним только для игроков с лаунчером
    if (!IsPlayerHaveLauncher(playerid)) return 0;
    
    // Спавним только на территории кладбища
    if (!IsPlayerInDynamicArea(playerid, GravesArea)) return 0;
    
    new Float: health = 1500.0;
    if (type == GRAVE_NPC_TYPE_SPIRIT) health += 1000.0;

    // Череп Осириса гарантированно спавнит Разгневанного Духа (c уменьшенным количеством HP)
    if (type == GRAVE_NPC_TYPE_SPIRIT && get_invent2(playerid, 242, 0)) {
        health *= 0.8;

        new para = get_para(playerid, 242) + 1;
        set_para(playerid, 242, para);
        if (para >= GRAVES_OSIRIS_SKULL_TIMES) TakeInvent(playerid, 242, 1, 0);
    }
    
    GravePlayerInfo[playerid][gpiNPCMaxHealth] = health;
    GravePlayerInfo[playerid][gpiLastDist] = 0.0;
    GravePlayerInfo[playerid][gpiLastDistChange] = 0;
    GravePlayerInfo[playerid][gpiNPCType] = type;

    // Создаём NPC
    if (IsValidNpc(GravePlayerInfo[playerid][gpiNPC])) Graves_DestroyNpc(playerid);
    {
        new Float: x, Float: y, Float: z, Float: a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);

        backme(playerid, 12.0, x, y, z, a);

        new skinid = 15792;
        if (type == GRAVE_NPC_TYPE_SPIRIT) skinid = 15791;

        // Создаем NPC
        GravePlayerInfo[playerid][gpiNPC] = CreateNpc(skinid, x, y, z);
        SetNpcFacingAngle(GravePlayerInfo[playerid][gpiNPC], a);

        // Помещаем NPC и игрока в отдельный виртуальный мир
        new worldid = Graves_GetPlayerVirtualWorld(playerid);
        SetNpcVirtualWorld(GravePlayerInfo[playerid][gpiNPC], worldid);
        SetPlayerVirtualWorld(playerid, worldid);

        // Эффект появления
        Graves_CreateParticleNpc(GravePlayerInfo[playerid][gpiNPC], 18715, x, y, z, 5000);
    }

    SetNpcHealth(GravePlayerInfo[playerid][gpiNPC], health);
    SetNpcWeapon(GravePlayerInfo[playerid][gpiNPC], WEAPON_FIST);
    TaskNpcAttackPlayer(GravePlayerInfo[playerid][gpiNPC], playerid, true);
    SetNpcStunAnimationEnabled(GravePlayerInfo[playerid][gpiNPC], false);
    
    Graves_ProcessNpc(playerid, GravePlayerInfo[playerid][gpiNPC]);
    Graves_SetPlayerTime(playerid);

    return 1;
}

stock Graves_SetPlayerTime(playerid)
{
    SetPlayerWeather(playerid, 8);
    return 1;
}

stock Graves_IsBattleNpc(playerid)
{
    return IsValidNpc(GravePlayerInfo[playerid][gpiNPC]);
}

stock Graves_OnPlayerGiveDamageNpc(NPC: npc, damagerid, Float: amount, weaponid, bodypart)
{
    #pragma unused weaponid
    #pragma unused bodypart

    new bool: isGhost = false;
    foreach (new playerid : Player)
    {
        if (npc == GravePlayerInfo[playerid][gpiNPC])
        {
            if (playerid != damagerid) return 0;
            isGhost = true;
        }
    }
    if (!isGhost) return 1;

    new Float: health;
    GetNpcHealth(npc, health);

    if (health <= 0.0) return 0;

    if (amount >= health) {
        new Float: x, Float: y, Float: z;
        GetNpcPosition(npc, x, y, z);

        // Эффект после смерти
        new modelid = (GravePlayerInfo[damagerid][gpiNPCType] == GRAVE_NPC_TYPE_SPIRIT) ? 18728 : 18723;
        Graves_CreateParticleNpc(npc, modelid, x, y, z - 3.5);
        SetTimerEx("Graves_DestroyNpc", 2500, false, "d", damagerid);
        Streamer_Update(damagerid, STREAMER_TYPE_OBJECT);

        // Лут
        Graves_GivePlayerLootNpc(npc, damagerid);

        // Достижение за убийство NPC
        if(PlayerInfo[damagerid][pAchieve][133] == 0) AchievePlayer(damagerid, 133, 1);
        CompleteBattlePassTask(damagerid, 12, 1);
    }

    return 1;
}

stock Graves_GivePlayerLootNpc(NPC: npc, playerid)
{
    if (!IsValidNpc(npc)) return 0;

    new silverJewelId = -1, silverPrice,
        goldJewelId = -1, goldPrice,
        caseKeyQuan, caseQuan, things[10];

    new dialog_text[1024];
    switch (GravePlayerInfo[playerid][gpiNPCType])
    {
        case GRAVE_NPC_TYPE_GHOST: {
            strcat(dialog_text, "{ff9000}Вы одолели Призрака!");

            // Назначение золотых украшений (10%)
            if (random(100) < 10)
            {
                Graves_RandomGoldJewel(goldJewelId, goldPrice);
            }

            // Назначение серебряных украшений (60%)
            if (random(100) < 60)
            {
                Graves_RandomSilverJewel(silverJewelId, silverPrice);
            }

            // Назначение костяного ключа (50%)
            if (random(100) < 50) caseKeyQuan = 1;

            // Назначение похоронного кейса
            caseQuan = 1;

            // Назначение артефактов (30% на каждый)
            new availableThings[] = {180, 198};
            for (new quan, i = 0; i < sizeof(availableThings); i++)
            {
                if (random(100) < 30)
                {
                    new put_inva = GiveThingPlayer(playerid, availableThings[i], 1, 0, 0, 0, 0);
                    if (put_inva < 0) continue; // Не удалось выдать предмет

                    things[quan++] = availableThings[i];
                }
            }
        }
        case GRAVE_NPC_TYPE_SPIRIT: {
            strcat(dialog_text, "{ff9000}Вы одолели Разгневанного Духа!");

            // Назначение золотых украшений (100%)
            Graves_RandomGoldJewel(goldJewelId, goldPrice);

            // Назначение серебряных украшений (100%)
            Graves_RandomSilverJewel(silverJewelId, silverPrice);

            // Назначение костяных ключей (100% + 50% + 20%)
            caseKeyQuan = 1;
            if (random(100) < 50) caseKeyQuan++;
            if (random(100) < 20) caseKeyQuan++;

            // Назначение похоронных кейсов (100%)
            caseQuan = 2;

            // Назначение артефактов (40% на первый, 32% на второй, ...)
            new chance = 40;
            new availableThings[] = {180, 198, 5, 243};
            for (new quan, i = 0; i < sizeof(availableThings); i++)
            {
                if (random(100) < chance)
                {
                    new put_inva = GiveThingPlayer(playerid, availableThings[i], 1, 0, 0, 0, 0);
                    if (put_inva < 0) continue; // Не удалось выдать предмет

                    things[quan++] = availableThings[i];
                }
                chance -= 8;
            }
        }
        default: return 0;
    }

    // Выдача костяных ключей
    for (new i = 0; i < caseKeyQuan; i++)
    {
        new put_inva = GiveThingPlayer(playerid, 241, 1, 0, 0, 0, 0);
        if (put_inva < 0) caseKeyQuan--; // Не удалось выдать предмет
    }

    // Выдача похоронных кейсов
    for (new i = 0; i < caseQuan; i++)
    {
        new thingId, thingQuan, thingType, thingPara, thingPack;
        CreateCasePlayer(playerid, thingId, thingQuan, thingType, thingPara, thingPack, "graves");
        new put_inva = GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack);
        if(put_inva < 0) caseQuan--; // Не удалось выдать предмет
    }

    strcat(dialog_text, "\n\n{99ff66}Ваша награда:");

    if (goldJewelId > -1) format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}- {ff9000}%s {ffcc00}[%d Gold]", dialog_text, GravesGoldJewels[goldJewelId], goldPrice);
    if (silverJewelId > -1) format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}- {bbbbbb}%s {99ff66}[%s$]", dialog_text, GravesSilverJewels[silverJewelId], FormatNumberWithCommas(silverPrice));
    if (caseKeyQuan > 0) format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}- {bbbbbb}Костяной ключ (%d шт.)", dialog_text, caseKeyQuan);
    for (new i = 0; i < sizeof(things); i++)
    {
        new itemid = things[i];
        if (itemid < 1) continue;

        format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}- {555555}%s", dialog_text, GetNameThing(0, itemid, 0, 0));
    }
    if (caseQuan > 0) format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}- {555555}Похоронный Кейс (%d шт.)", dialog_text, caseQuan);

    // Выдаём золото и деньги (предметы выдаются сразу)
    if (goldPrice > 0) Graves_GiveGoldJewel(playerid, goldJewelId);
    if (silverPrice > 0) Graves_GiveSilverJewel(playerid, silverJewelId);

    strcat(dialog_text,
        "\n\n{cccccc}Памятка:\n" \
        "{cccccc}- Артефакты увеличивают шанс появления одной из сущностей при раскопке могил\n" \
        "{cccccc}- Золотые и серебряные украшения автоматически конвертируются в игровую валюту ({99ff66}Деньги{cccccc}, {ffcc00}Золото{cccccc})\n" \
        "{cccccc}- Разгневанный Дух появляется реже Призрака, а потому имеет более ценную награду при уничтожении"
    );

    ShowDialog(playerid, NO_DIALOG_HANDLER, DIALOG_STYLE_MSGBOX, "{555555}Награда", dialog_text, "Ок", "");

    return 1;
}

stock Graves_IsArtifact(itemid)
{
    if (itemid == 5 || itemid == 180 || itemid == 198 || itemid == 242 || itemid == 243) return true;
    return false;
}

stock Graves_SetSpawnInfo(playerid)
{
    GravePlayerInfo[playerid][gpiNoDeath] = gettime() + 5;
    OnlineInfo[playerid][oSpawnWorld] = 0, OnlineInfo[playerid][oSpawnInt] = 0;
    ProtectSetSpawnInfo(playerid, DEFAULT_PLAYER_TEAM, PlayerInfo[playerid][pModel], 998.7671, -1106.4410, 23.8281, 90.0000, 0, 0, 0, 0, 0, 0);
    return 1;
}

stock Graves_OnPlayerDeadNpc(NPC: npc, playerid)
{
    if (!IsValidNpc(npc) || GravePlayerInfo[playerid][gpiNPC] != npc) return 0;

    Graves_SetSpawnInfo(playerid);

    // Уничтожаем артефакты при смерти (даже в товарах лавки)
    for(new i = 0; i < 40; i++)
	{
        if (PlayerInfo[playerid][pInvenType][i] == 0)
        {
            new quan = PlayerInfo[playerid][pInvenQuan][i];
            if (quan > 0)
            {
                new itemid = PlayerInfo[playerid][pInven][i];
                if (itemid != 242 && Graves_IsArtifact(itemid)) {
                    TakeInvent(playerid, itemid, quan, 0, i);
                }
            }
        }

        if (i < 20)
        {
            if (PlayerInfo[playerid][pMarkInvenType][i] == 0)
            {
                new quan = PlayerInfo[playerid][pMarkInvenQuan][i];
                if (quan > 0)
                {
                    new itemid = PlayerInfo[playerid][pMarkInven][i];
                    if (itemid != 242 && Graves_IsArtifact(itemid)) {
                        m_take_away(playerid, quan, i);
                    }
                }
            }
        }
	}

    Graves_DestroyNpc(playerid);

    return 1;
}

stock Graves_OnPlayerTakeDamageNpc(NPC:npc, issuerid, Float:amount, weaponid, bodypart)
{
    #pragma unused weaponid
    #pragma unused bodypart

    if (GravePlayerInfo[issuerid][gpiNPC] != npc) return 0;

    new Float: health;
    ACGetPlayerHealth(issuerid, health);

    if (health - amount <= 0.0)
    {
        Graves_OnPlayerDeadNpc(npc, issuerid);
    } else {
        new Float: nAngle, Float: pAngle;
        GetPlayerFacingAngle(issuerid, pAngle);
        GetNpcFacingAngle(npc, nAngle);

        // Если NPC атакует со спины - значительно увеличиваем урон
        if (floatabs(pAngle - nAngle) < 15.0) {
            new Float: pHealth;
            ACGetPlayerHealth(issuerid, pHealth);

            pHealth -= amount * 3.5;
            if (pHealth <= 0.0) {
                Graves_OnPlayerDeadNpc(npc, issuerid);
            }
            ACSetPlayerHealth(issuerid, pHealth);
        }
    }

    return 1;
}

CMD:gravestest(playerid, const params[])
{
    if (server != 0) return 0;

    new type;
    sscanf(params, "D(0)", type);

    Graves_DestroyNpc(playerid);
    if (!Graves_CreateNPC(playerid, e_GraveNPCType: type, true)) return 0;

    return 1;
}

/*
Добавляем шкатулку, Указываем параметры рандома, условно:
case 0..1 - Значит шанс равен 2%
case 2..99 - Значит шанс равен 98%

fpick - Оставляем ноль если выдаем предмет не в инвентарь
quan - Оставляем один если выдаем один предмет.
fpick 94 - Выдача голды человеку.
oGivePlayerMoney(playerid, babki) - Выдать игроку денюжку
*/

// Добавляем enum для типов кейсов
enum CASE_TYPE_ENUM 
{
    CASE_TYPE_NORMAL,
    CASE_TYPE_GOLD
};

// Обычный Транспорт
new ThingVehiclecaseGift[MAX_VEHICLE_ALL];
new ThingVehicleQuan;

// Премиум транспорт
new ThingPremiumVehiclecaseGift[MAX_VEHICLE_ALL];
new ThingPremiumVehicleQuan;

// Лимитированный транспорт
new ThingLimitedVehiclecaseGift[MAX_VEHICLE_ALL];
new ThingLimitedehicleQuan;

// Аксессуары
new ThingAccessoryGift[MAX_ACCESSORY];
new ThingAccessoryGiftBone[MAX_ACCESSORY];
new ThingAccessoryGiftTop[MAX_ACCESSORY];
new ThingAccessoryGiftBoneTop[MAX_ACCESSORY];
new ThingAccessoryQuanTop;
new ThingAccessoryQuan;

// Обычные предметы
new ThingItem[sizeof(friskPick)];
new thingItemQuan;

// Обычные предметы (топовые)
new ThingItemTop[sizeof(friskPick)];
new thingItemTopQuan;


stock IsThingNotVariable(i)
{
    if(i == 7  || i == 6 || i == 10 || i == 11 || i == 12 || i == 15 || i == 20 || i == 22 || i == 25 || i == 26 || i == 33 || i == 34 || i == 35  || i == 36  
    || i == 43 || i == 48 || i == 51 || i == 54 || i == 55
    || i == 56 || i == 57 || i == 58 || i == 59 || i == 63 || i == 68 || i == 69 || i == 89 || i == 96 || i >= 99 && i <= 105  || i == 106 
    || i == 108 || i == 109 || i == 110 || i == 111 || i == 120 || i == 123 || i == 125
    || i == 139 || i == 141 || i >= 142 && i <= 160 || i >= 163 && i <= 174 || i == 178 || i == 179 || i >= 184 && i <= 189 || i == 191 
    || i == 192 || i == 193 || i == 194 || i == 195 || i == 196 || i == 199 
    || i == 200 || i == 203 || i == 204 || i == 206 || i == 226 || i == 227 || i == 228 || i == 229 || i == 240 || i >= 244 && i <= 248 || i >= 252 && i <= 260
    || IsANaborsEdoi(i)) return 0;
    return 1;
}

stock IsThingClotheNotVariable(i)
{
    if(i == 1 || i == 74) return 0;
    return 1;
}

// Оружие которое нельзя давать в шкатулку
stock IsThingGunNotVariable(i)
{
    if(i == 0 || i == 1 || i == 2 || i == 4 || i == 7 || i == 9 || i >= 15 && i <= 21 || i == 23 || i == 26 || i == 34 || i >= 34) return 0; // Низя
    return 1; // Остальные можно
}

stock CreateVehicleGiftCase()
{
    ThingVehicleQuan = 0;
    ThingPremiumVehicleQuan = 0;
    ThingLimitedehicleQuan = 0;

    // Собираем обычный транспорт
    for(new i = 0; i < MAX_VEHICLE_ALL; i++)
    {
        new v = CorrectVehicleList(i);

        if(!IsAVehExisting(v)
            || VehGos[i] <= 0 || VehGold[i] <= 0) continue; // Пропускаем невалидный транспорт

        new vehClass = GetVehicleClass(v);
        if(vehClass == 0 || (vehClass >= 5 && vehClass <= 7)) continue; // Пропускаем невалидные тачки по классу

        new vehType = GetVehicleType(v);
        if(vehType == 1 || vehType == 2)
        {
            if(VehSale[i] == 1
                || (VehLimited[i] > 0 && (VehQuan[i] < VehLimited[i] || VehLimitedCase[i] < VehLimited[i])))
                {
                    if(vehClass == 1) ThingPremiumVehiclecaseGift[ThingPremiumVehicleQuan] = v, ThingPremiumVehicleQuan ++; // Premium Vehicle
                    else if(vehClass == 8) ThingLimitedVehiclecaseGift[ThingLimitedehicleQuan] = v, ThingLimitedehicleQuan ++; // Limited Vehicle
                    else ThingVehiclecaseGift[ThingVehicleQuan] = v, ThingVehicleQuan ++;
                }
        }
    }
    return true;
}

stock CreateAccessoryGiftCase() // Собираем аксессуары для шкатулки
{
    ThingAccessoryQuan = 0;
    ThingAccessoryQuanTop = 0;
    for(new i; i < MAX_ACCESSORY; i++)
    {
        if(AccessoryInfo[i][acCase] == true)
        {
            if(FindItemAccessoryCraft(AccessoryInfo[i][acModel]) != -1) continue;
            if(AccessoryInfo[i][acPrice] > 1000000)
            {
                ThingAccessoryGiftTop[ThingAccessoryQuanTop] = AccessoryInfo[i][acModel];
                ThingAccessoryGiftBoneTop[ThingAccessoryQuanTop] = AccessoryInfo[i][acBone];
                ThingAccessoryQuanTop ++;
            }
            else
            {
                ThingAccessoryGift[ThingAccessoryQuan] = AccessoryInfo[i][acModel];
                ThingAccessoryGiftBone[ThingAccessoryQuan] = AccessoryInfo[i][acBone];
                ThingAccessoryQuan ++;
            }
        }
    }
    return ThingAccessoryQuan+ThingAccessoryQuanTop;
}

// Блокируем предметы для шкатулки (хз, там разные шняги)
stock StopThingForCase(i, thingType)
{
    if(!IsThingNotVariable(i) // Запрещённые предметы для шкатулки
    || NotGiveThing(i, thingType, 1) // Предметы которые нельзя передать
    || DocumentThing(i, thingType) // Документы
    || CheckThingQuan(i) // Количественные предметы
    || JustOneThingInventory(i, thingType) // Предмет только в единственном экземпляре в инвентаре
    || IsKeyCustomCase(i) // Ключи от шкатулки
    ) return true;
    return false;
}

stock CreateThingGiftCase() // Собираем обычные предметы для шкатулки
{
    thingItemQuan = 0;
    for(new i = 1; i < sizeof(friskName); i++)
    {
        if(!StopThingForCase(i, 0) && !TopThing(i)) ThingItem[thingItemQuan] = i, thingItemQuan ++;
    }
    return thingItemQuan;
}

stock CreateThingTopGiftCase() // Собираем топовые обычные предметы для шкатулки
{
    thingItemTopQuan = 0;
    for(new i = 1; i < sizeof(friskName); i++)
    {
        if(!StopThingForCase(i, 0) && TopThing(i)) ThingItemTop[thingItemTopQuan] = i, thingItemTopQuan ++;
    }
    return thingItemTopQuan;
}

// Сток для получения обычного предмета из шкатулки
stock CommonThingCase(&thingId, &thingQuan, &thingType, &thingPack)
{
    switch(random(5))
    {
        case 1: // Top предметы
        {
            new thingTemp = random(thingItemTopQuan);
            thingId = ThingItemTop[thingTemp];
        }
        default:
        {
            new thingTemp = random(thingItemQuan);
            thingId = ThingItem[thingTemp];
        }
    }
    thingQuan = 0;
    thingType = 0;
    thingPack = 5;
    return true;
}


// Рандомайзер для создания шкатулки
stock CreateCasePlayer(playerid, &thingId, &thingQuan, &thingType, &thingPara, &thingPack, const name[] = "default")
{
    #pragma unused playerid

    // Поиск кастомного шкатулки
    new caseID = GetCustomCaseID(name);
    if(caseID >= 0) // Обнаружили кастомный шкатулки по идентификатору
    {
        new selectedThing = SelectRandomThing(caseID);
        if(selectedThing == -1)
        {
            CommonThingCase(thingId, thingQuan, thingType, thingPack); // Ошибка, предмет не найден, выдаём стандартный
            thingPack = GetCustomCaseInventoryPack(caseID);
            return true;
        }
        CustomThingCase(caseID, selectedThing, thingId, thingQuan, thingPara, thingType, thingPack);

        if(thingId < 0
            || thingId >= sizeof(friskPick) && thingType == 0)
        {
            CommonThingCase(thingId, thingQuan, thingType, thingPack); // Обычный предмет из кастомного шкатулки (на случай мусорного заполнения)
            thingPack = GetCustomCaseInventoryPack(caseID);
            return true;
        }
        return true;
    }


    if(strcmp(name,"gold") == 0)
    {
        switch(random(3))
        {
            case 0: thingType = 2; // акс
            case 1: thingType = 3; // Одежда
            case 2: thingType = 5; // Транспорт
        }
    }
    else if(strcmp(name,"craftaks") == 0)
    {
        thingType = 2;
    }
    else if(strcmp(name,"clothes") == 0) thingType = 3;
    else if(strcmp(name,"accessory") == 0) thingType = 2;
    else if(strcmp(name,"car") == 0) thingType = 5;
    else 
    {
        switch(random(18))
        {
            case 0: thingType = 0; // Обычный предмет
            case 1: thingType = 1; // Оружие
            case 2: thingType = 2; // Аксессуар
            case 3: thingType = 3; // Одежда
            case 4: thingType = 5; // Транспорт
            default: thingType = 0; // ПОДКРУТКА обычный предмет
        }
    }
    
    new quan;
    if(thingType == 0) CommonThingCase(thingId, thingQuan, thingType, thingPack); // Если выпал обычный
    if(thingType > 1 && strcmp(name,"default") == 0) // Дропаем вместо крутых предметов купоны
    {
        switch(thingType)
        {
            case 2: thingId = 253, thingQuan = 1, thingType = 0;
            case 3: thingId = 252, thingQuan = 1, thingType = 0;
            case 5: thingId = 254, thingQuan = 1, thingType = 0;
            default: CommonThingCase(thingId, thingQuan, thingType, thingPack);
        }
    }
    else if(thingType == 1)
    {
        new ThingIDcaseGift[46];
        for(new i = 1; i < 46; i++)
        {
            if(IsThingGunNotVariable(i)) ThingIDcaseGift[quan] = i, quan ++;
        }
        new thingTemp = random(quan);
        thingId = ThingIDcaseGift[thingTemp];

        thingPara = GUN_HEALTH;
        thingQuan = 1;
    }

    else if(thingType == 2) // Аксессуары (Список собирается при запуске сервера и при активации аксессуара для шкатулки)
    {
        new bool:givePremiumAks = false;
        if(ThingAccessoryQuan <= 0) return CommonThingCase(thingId, thingQuan, thingType, thingPack); // Если вдруг аксессуаров для шкатулки нет, выпадет обычный предмет

        if(strcmp(name,"craftaks") == 0)
        {
            switch(random(61))
            {
                case 0..40: thingId = AccessoryCraftListBust[FindRandomItemAccessoryCraft(0)][0]; // Разгрузка (доп переносимых патрон)
                case 41..49: thingId = AccessoryCraftListBust[FindRandomItemAccessoryCraft(1)][0]; // Рюкзак (слоты)
                case 50..55: thingId = AccessoryCraftListBust[FindRandomItemAccessoryCraft(2)][0]; // Катана / Са бля (урон нпс)
                case 56..60: thingId = AccessoryCraftListBust[FindRandomItemAccessoryCraft(3)][0]; // Очки (доп опыт к навыкам)
            }
            thingPara = random(520);
            thingQuan = 1;
        }
        else
        {
            switch(random(5))
            {
                case 1:
                {
                    if(strcmp(name,"gold") == 0) givePremiumAks = true; // Premium
                    else givePremiumAks = false;
                }
                default: givePremiumAks = false;
            }
            new thingTemp;
            if(givePremiumAks) 
            {
                thingTemp = random(ThingAccessoryQuanTop);
                thingId = ThingAccessoryGiftTop[thingTemp];
                thingPara = ThingAccessoryGiftBoneTop[thingTemp];
            }
            else
            {
                thingTemp = random(ThingAccessoryQuan);
                thingId = ThingAccessoryGift[thingTemp];
                thingPara = ThingAccessoryGiftBone[thingTemp];
            }
            thingQuan = 1;
        }
    }

    else if(thingType == 3) // Одежда (Новый рандомайзер для скинов в skin_custom.pwn от 21.05.25)
    {
        new skinIndex;
        if(strcmp(name,"gold") == 0) skinIndex = GetRandomSkinFromCase(CASE_TYPE_GOLD, PlayerInfo[playerid][pSex]);
        else skinIndex = GetRandomSkinFromCase(CASE_TYPE_NORMAL, PlayerInfo[playerid][pSex]);

        if(skinIndex == -1) return CommonThingCase(thingId, thingQuan, thingType, thingPack); // Если вдруг ошибка выбора скина, дропаем обычный предмет

        thingId = skinIndex;
        thingPara = 0;
        thingQuan = 1;
    }
    else if(thingType == 5) // Транспорт (Список собирается при запуске сервера)
    {
        new vehicleList;
        if(strcmp(name,"gold") == 0) vehicleList = GetRandomVehicleFromCase(CASE_TYPE_GOLD);
        else vehicleList = GetRandomVehicleFromCase(CASE_TYPE_NORMAL);

        if(vehicleList == -1) return CommonThingCase(thingId, thingQuan, thingType, thingPack); // Если вдруг ошибка выбора, дропаем обычный предмет

        thingId = CorrectVehicleList(vehicleList); // Обязательно корректируем id из набора, для получения модели транспорта!
        thingPara = 0;
        new colorveh = 1 + random(254); // Color Vehicle
        thingQuan = colorveh;
    }

    if(strcmp(name,"gold") == 0) thingPack = 9; // GOLD case
    else if(strcmp(name,"craftaks") == 0) thingPack = 12; // aks craft
    else if(strcmp(name,"clothes") == 0) thingPack = 13;
    else if(strcmp(name,"accessory") == 0) thingPack = 14;
    else if(strcmp(name,"car") == 0) thingPack = 15;
    else thingPack = 5; // Не трогаем

    return 1;
}

// Добавляем лимитированный транспорт в шкатулке на руках
stock CalculateVehicleLimited(thingId, thingType)
{
    if(thingType != 5) return false; // Это не транспорт, значит не считаем

    new v = CorrectVehicleID(thingId);
    if(VehLimited[v] > 0)
    {
        VehLimitedCase[v] += 1; // Считаем выданную лимитированную тачку
        SaveVehicleLimitedCase(v);

        // Пересобираем транспорт в подарках
        CreateVehicleGiftCase();
    }
    return true;
}

// Вычитаем лимитированный транспорт в шкатулке на руках
stock TakeCalculateVehicleLimited(thingId, thingType)
{
    if(thingType != 5) return false; // Это не транспорт, значит не считаем

    new v = CorrectVehicleID(thingId);
    if(VehLimited[v] > 0 && VehLimitedCase[v] - 1 >= 0) 
    {
        VehLimitedCase[v] -= 1; // Вычитаем выданную лимитированную тачку
        SaveVehicleLimitedCase(v);

        // Пересобираем транспорт в подарках
        CreateVehicleGiftCase();
    }
    return true;
}

CMD:givecase(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    new giveplayerid, getNameCaseCustom[24];
    if(!sscanf(params, "is[24]", giveplayerid, getNameCaseCustom)) GivePlayerCase(playerid, giveplayerid, getNameCaseCustom);
    else if(!sscanf(params, "i", giveplayerid)) GivePlayerCase(playerid, giveplayerid);
    else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать шкатулку [ /givecase ID ]");
    return 1;
}

CMD:givecaseall(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    new getNameCaseCustom[24], nameCase[24];
    if(!sscanf(params, "s[24]", getNameCaseCustom)) format(nameCase, sizeof(nameCase), "%s", getNameCaseCustom);

    new amount = 0;
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 1)
        {
            GivePlayerCase(playerid, i, nameCase, false);
            amount++;
        }
    }
    new string[140];
	format(string, sizeof(string), " [ ADM ]: %s выдал всем игрокам шкатулку [ %s ]", PlayerInfo[playerid][pName], nameCase);
	ABroadCast(COLOR_ADM,string,1);
	AdminLog("givecaseall", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, nameCase);
    return 1;
}

CMD:givecasegro(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    new getNameCaseCustom[24], nameCase[24];
    if(!sscanf(params, "s[24]", getNameCaseCustom)) format(nameCase, sizeof(nameCase), "%s", getNameCaseCustom);

    new amount = 0;
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 1 && ProxDetectorS(20.0, playerid, i) && playerid != i && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
        {
            GivePlayerCase(playerid, i, nameCase, false);
            amount++;
        }
    }

    new string[140];
	format(string, sizeof(string), " [ ADM ]: %s выдал шкатулку игрокам рядом с собой [ %s ]", PlayerInfo[playerid][pName], nameCase);
	ABroadCast(COLOR_ADM,string,1);
	AdminLog("givecasegro", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, nameCase);
    return 1;
}

CMD:givecaserandom(playerid, const params[])
{
    if (PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    new caseType[24], randomQuan;
    if (!sscanf(params, "s[24]i", caseType, randomQuan))
    {
        new quanPlayers = 0;
        new PlayerForCase[MAX_REALPLAYERS];

        // Собираем всех залогиненных игроков в массив
        foreach(Player, i)
        {
            if (OnlineInfo[i][oLogged] == 1 && !IsPlayerNPC(i))
            {
                PlayerForCase[quanPlayers] = i;
                quanPlayers++;
            }
        }

        // Если игроков меньше, чем указано, выдаем кейс всем
        if (randomQuan > quanPlayers) randomQuan = quanPlayers;

        // Перемешиваем массив игроков (алгоритм Фишера-Йетса)
        for (new i = quanPlayers - 1; i > 0; i--)
        {
            new j = random(i + 1);
            new temp = PlayerForCase[i];
            PlayerForCase[i] = PlayerForCase[j];
            PlayerForCase[j] = temp;
        }

        // Выдаем кейс первичным randomQuan игрокам (уникальные игроки)
        for (new i = 0; i < randomQuan; i++) GivePlayerCase(playerid, PlayerForCase[i], caseType, false);

        new string[140];
        format(string, sizeof(string), " [ ADM ]: %s выдал шкатулку %d игрокам [ %s ]", PlayerInfo[playerid][pName], randomQuan, caseType);
        ABroadCast(COLOR_ADM, string, 1);
        AdminLog("givecaserandom", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", randomQuan, caseType);
    }
    else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать кейс рандомному количеству игроков [ /givecaserandom default количество ]");
    return 1;
}

stock GivePlayerCase(playerid, giveplayerid, const name[] = "default", bool:onePlayer = true)
{
    new thingId, thingQuan, thingType, thingPara, thingPack;
    CreateCasePlayer(giveplayerid, thingId, thingQuan, thingType, thingPara, thingPack, name);
    new put_inva = GiveThingPlayer(giveplayerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
    if(put_inva == -1 && onePlayer == true) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре");

    CalculateVehicleLimited(thingId, thingType);
    if(onePlayer == true) SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы выдали %s шкатулку [ %s ]", PlayerInfo[giveplayerid][pName], name);
    if(giveplayerid != playerid) SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "* Администратор %s выдал вам шкатулку [ %s ]", PlayerInfo[playerid][pName], name);

    if(onePlayer == true) AdminLog("givecase", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], 0, name);
    return true;
}

//===================== Собираем скины в кейс =======================

// Правильное объявление массива с инициализацией
static const Float:gCaseClassChances[2][4] = {
    // Обычный кейс          COMMON  UNCOMMON  RARE  LEGENDARY
    {60.0, 40.0, 0.0, 0.0}, // CASE_TYPE_NORMAL (индекс 0)
    {0.0, 65.0, 20.0, 15.0}  // CASE_TYPE_GOLD    (индекс 1)
};

GetRandomSkinFromCase(CASE_TYPE_ENUM:caseType, sex = 0) 
{
    if(caseType != CASE_TYPE_NORMAL && caseType != CASE_TYPE_GOLD) 
        return -1;

    // 1. Выбираем класс скина
    new SKINCLASSENUM:selectedClass = GetRandomSkinClass(caseType);
    if(selectedClass == SKINCLASS_INVALID) 
        return -1;

    // 2. Выбираем скин внутри класса
    return GetRandomSkinByClass(selectedClass, caseType, sex);
}

// Исправленная функция GetRandomSkinClass
SKINCLASSENUM:GetRandomSkinClass(CASE_TYPE_ENUM:caseType) 
{
    // Проверка валидности индекса
    if(_:caseType < 0 || _:caseType >= sizeof(gCaseClassChances)) 
        return SKINCLASS_INVALID;

    new Float:total = 0.0;
    new Float:randValue = frandom(100.0);
    
    for(new i = 0; i < sizeof(gCaseClassChances[]); i++) 
    {
        // Явное приведение типа для caseType
        total += gCaseClassChances[_:caseType][i];
        
        if(randValue <= total) 
        {
            switch(i) {
                case 0: return SKINCLASS_COMMON;
                case 1: return SKINCLASS_UNCOMMON;
                case 2: return SKINCLASS_RARE;
                case 3: return SKINCLASS_LEGENDARY;
            }
        }
    }
    return SKINCLASS_INVALID;
}

GetRandomSkinByClass(SKINCLASSENUM:targetClass, CASE_TYPE_ENUM:caseType, sex = 0) 
{
    new totalWeight = 0;
    new skinCount = sizeof(SkinPearsInfo);
    new validSkins[MAX_MODELS_SKIN], validCount = 0;

    for(new i = 0; i < skinCount; i++) 
    {
        // Разрешаем RARE и LEGENDARY для целевого LEGENDARY класса
        if(targetClass == SKINCLASS_LEGENDARY) {
            if(SkinPearsInfo[i][eSkinClass] != SKINCLASS_RARE && 
               SkinPearsInfo[i][eSkinClass] != SKINCLASS_LEGENDARY) continue;
        }
        else {
            if(SkinPearsInfo[i][eSkinClass] != targetClass) continue;
        }
        
        if(SkinPearsInfo[i][eSkinClass] == SKINCLASS_SYSTEM) continue;

        if(sex == 1 && GetSkinSex(i) == 2) continue; // Пропускаем женские скины для мужчин
        if(sex == 2 && GetSkinSex(i) == 1) continue; // Пропускаем мужские скины для женщин
        if(!IsSkinAllowedInCase(i, caseType)) continue;

        validSkins[validCount++] = i;
    }

    if(validCount == 0) return -1;

    // Используем веса на основе целевого класса
    new skinWeights[MAX_MODELS_SKIN];
    for(new i = 0; i < validCount; i++) 
    {
        new idx = validSkins[i];
        skinWeights[i] = GetSkinWeightByCost(targetClass, SkinPearsInfo[idx][eSkinGold]);
        totalWeight += skinWeights[i];
    }

    new randomWeight = random(totalWeight);
    new accumulated = 0;

    for(new i = 0; i < validCount; i++) 
    {
        accumulated += skinWeights[i];
        if(randomWeight < accumulated) 
        {
            return validSkins[i];
        }
    }
    return -1;
}

// Проверка доступности скина в кейсе
IsSkinAllowedInCase(skinIndex, CASE_TYPE_ENUM:caseType) 
{
    switch(caseType) 
    {
        case CASE_TYPE_NORMAL: 
            return SkinPearsInfo[skinIndex][eSkinClass] != SKINCLASS_RARE &&
                   SkinPearsInfo[skinIndex][eSkinClass] != SKINCLASS_LEGENDARY;
        
        case CASE_TYPE_GOLD: 
            return SkinPearsInfo[skinIndex][eSkinClass] != SKINCLASS_COMMON;
    }
    return false;
}

// Формула веса на основе стоимости (чем выше цена - тем меньше вес)
GetSkinWeightByCost(SKINCLASSENUM:class, goldCost) 
{
    switch(class) 
    {
        case SKINCLASS_COMMON:    return 100000 / (goldCost + 1); // Базовый множитель для баланса
        case SKINCLASS_UNCOMMON:  return 75000 / (goldCost + 1);
        case SKINCLASS_RARE:     return 50000 / (goldCost + 1);
        case SKINCLASS_LEGENDARY: return 25000 / (goldCost + 1);
    }
    return 1;
}

// Пример использования в командах
CMD:opencase(playerid, params[]) {

    if(server != 0) return 0;

    new caseTypeStr[12], CASE_TYPE_ENUM:caseType;
    if(sscanf(params, "s[12]", caseTypeStr)) {
        return SendClientMessage(playerid, 0xFF0000AA, "Используй: /opencase [default/gold]");
    }
    
    if(!strcmp(caseTypeStr, "default", true)) {
        caseType = CASE_TYPE_NORMAL;
    }
    else if(!strcmp(caseTypeStr, "gold", true)) {
        caseType = CASE_TYPE_GOLD;
    }
    else {
        return SendClientMessage(playerid, 0xFF0000AA, "Доступные кейсы: default, gold");
    }

    new skinIndex = GetRandomSkinFromCase(caseType);
    if(skinIndex == -1) return SendClientMessage(playerid, 0xFF0000AA, "Ошибка при открытии кейса!");

    // Выдача скина
    m_custom_sync_SetPlayerSkin(playerid, skinIndex);
    
    // Отправка цветного сообщения
    SendClientMessage(playerid, -1, "Вы получили: %s | Редкость: %s {cccccc}| Gold: {ffcc00}%d", 
        SkinPearsInfo[skinIndex][eSkinName], GetSkinClassName(skinIndex), SkinPearsInfo[skinIndex][eSkinGold]);
    return 1;
}

//===================== Собираем транспорт в кейс =========================

// Шансы классов для каждого типа кейса (в процентах)
static const Float:gVehicleClassChances[2][9] = {
    // Обычный кейс (классы 2,3,4)
    {0.0, 0.0, 20.0, 50.0, 30.0, 0.0, 0.0, 0.0, 0.0}, 
    // Голд кейс (классы 1,2,3,4,8)
    {0.0, 5.0, 20.0, 45.0, 28.0, 0.0, 0.0, 0.0, 2.0}  
};

GetRandomVehicleFromCase(CASE_TYPE_ENUM:caseType) 
{
    // 1. Выбираем класс транспорта
    new vehicleClass = GetRandomVehicleClass(caseType);
    if(vehicleClass == 0) 
    {
        if(server == 0) SendClientMessageToAll(-1, "GetRandomVehicleFromCase vehicleClass == 0 (не нашли класс при создании кейса)");
        return -1; 
    }

    // 2. Выбираем транспорт внутри класса
    return GetRandomVehicleByClass(vehicleClass, caseType);
}

GetRandomVehicleClass(CASE_TYPE_ENUM:caseType) 
{
    if(_:caseType < 0 || _:caseType >= sizeof(gVehicleClassChances))
        return 0;

    new Float:total = 0.0;
    for(new i = 0; i < 9; i++)
        total += gVehicleClassChances[_:caseType][i];

    new Float:rand = frandom(total);
    new Float:accum = 0.0;

    for(new i = 0; i < 9; i++) {
        accum += gVehicleClassChances[_:caseType][i];
        if(rand <= accum)
            return i;
    }
    return 0;
}

GetRandomVehicleByClass(vehicleClass, CASE_TYPE_ENUM:caseType) 
{
    new validVehicles[MAX_VEHICLE_ALL];
    new validWeights[MAX_VEHICLE_ALL];
    new validCount = 0;
    new totalWeight = 0;

    for(new i = 0; i < MAX_VEHICLE_ALL; i++) 
    {
        new v = CorrectVehicleList(i);
        if(!IsAVehExisting(v)) continue; // Недоступный транспорт
        if(VehGold[i] <= 0) continue; // Без голд цены не пускаем в кейс
        if(GetVehicleType(v) != 1 && GetVehicleType(v) != 2) continue; // Только авто и мото транспорт
        
        // Проверка класса
        if(vehicleClass == 8)
        {
            // При выпадении лимитированного, собираем набор и премиальных, ибо нефиг
            if(GetVehicleClass(v) != 8 && GetVehicleClass(v) != 1) continue;
        }
        else
        {
            if(GetVehicleClass(v) != vehicleClass) continue;
        }
        
        // Проверка типа кейса
        switch(caseType) 
        {
            case CASE_TYPE_NORMAL:
            {
                if(vehicleClass < 2 || vehicleClass > 4) continue;
                if(VehCaseOff[i] == 1) continue;
            }
            case CASE_TYPE_GOLD:
            {
                if(!(vehicleClass == 1 || vehicleClass == 2 || vehicleClass == 3 || vehicleClass == 4 || vehicleClass == 8)) continue;
                if(v < 2000) continue; // Убираем из GOLD кейса дефолтный транспорт
            }
        }
        
        // Дополнительные условия
        if(VehSale[i] == 0 && vehicleClass != 8) continue; // Не на продаже
        if(VehLimited[i] > 0 && (VehQuan[i] >= VehLimited[i] || VehLimitedCase[i] >= VehLimited[i])) 
            continue;

        // Рассчет веса (обратно пропорционально цене)
        new weight = CalculateVehicleWeight(VehGold[i]);
        validWeights[validCount] = weight;
        validVehicles[validCount] = i;
        totalWeight += weight;
        validCount++;
    }

    if(validCount == 0) return -1;

    // Выбор случайного транспорта
    new randomWeight = random(totalWeight);
    new accumulated = 0;

    for(new i = 0; i < validCount; i++) 
    {
        accumulated += validWeights[i];
        if(randomWeight < accumulated) 
        {
            return validVehicles[i];
        }
    }
    return -1;
}

CalculateVehicleWeight(goldAmount) 
{
    // Чем больше goldAmount, тем меньше вес
    // Используем обратную пропорциональность с защитой от деления на 0
    return floatround(100000.0 / (float(goldAmount) + 1.0));
}

// Пример использования в команде открытия кейса
CMD:opencaseveh(playerid, params[]) 
{
    new caseTypeStr[8], CASE_TYPE_ENUM:caseType;
    if(sscanf(params, "s[8]", caseTypeStr))
        return SendClientMessage(playerid, 0xFF0000AA, "Используй: /opencaseveh [default/gold]");

    if(!strcmp(caseTypeStr, "default", true)) caseType = CASE_TYPE_NORMAL;
    else if(!strcmp(caseTypeStr, "gold", true)) caseType = CASE_TYPE_GOLD;
    else return SendClientMessage(playerid, 0xFF0000AA, "Доступные типы: default, gold");

    new vehicleList = GetRandomVehicleFromCase(caseType);
    if(vehicleList == -1) return SendClientMessage(playerid, 0xFF0000AA, "Не удалось выбрать транспорт");

    new modelID = CorrectVehicleList(vehicleList);
    
    SendClientMessage(playerid, -1, "Вы получили: %s modelID %d [Class: %s] [Gold: %d]", 
        GetVehicleName(modelID), modelID, vehClassName[GetVehicleClass(modelID)], VehGold[vehicleList]);
    return 1;
}

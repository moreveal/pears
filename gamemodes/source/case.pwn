/*
Добавляем кейс, Указываем параметры рандома, условно:
case 0..1 - Значит шанс равен 2%
case 2..99 - Значит шанс равен 98%

fpick - Оставляем ноль если выдаем предмет не в инвентарь
quan - Оставляем один если выдаем один предмет.
fpick 94 - Выдача голды человеку.
oGivePlayerMoney(playerid, babki) - Выдать игроку денюжку
*/

// Обычный Транспорт
new ThingVehiclecaseGift[MAX_MODELS_VEHICLE];
new ThingVehicleQuan;

// Премиум транспорт
new ThingPremiumVehiclecaseGift[MAX_MODELS_VEHICLE];
new ThingPremiumVehicleQuan;

// Лимитированный транспорт
new ThingLimitedVehiclecaseGift[MAX_MODELS_VEHICLE];
new ThingLimitedehicleQuan;

// Мужские скины
new ThingSkincaseGift[MAX_MODELS_SKIN];
new ThingSkinQuan;

// Женские скины
new ThingSkincaseGiftFemale[MAX_MODELS_SKIN];
new ThingSkinQuanFemale;

// Мужские скины TOP
new ThingSkinTopcaseGift[MAX_MODELS_SKIN];
new ThingSkinTopQuan;

// Женские скины TOP
new ThingSkinTopcaseGiftFemale[MAX_MODELS_SKIN];
new ThingSkinTopQuanFemale;

// Аксессуары
new ThingAccessoryGift[MAX_ACCESSORY];
new ThingAccessoryGiftBone[MAX_ACCESSORY];
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
    || i == 200 || i == 203 || i == 204 || i == 206 || i == 226 || i == 227 || i == 228 || i == 229 || i == 240
    || IsANaborsEdoi(i)) return 0;
    return 1;
}

stock IsThingClotheNotVariable(i)
{
    if(i == 1 || i == 74) return 0;
    return 1;
}

// Оружие которое нельзя давать в кейс
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
    for(new v = 400; v < 612; v++)
    {
        new i = CorrectVehicleID(v);

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
                    else ThingVehiclecaseGift[ThingVehicleQuan] = v, ThingVehicleQuan ++;
                }
        }
    }

    // Собираем кастомный транспорт
    for(new v = 2000; v < 2000 + MAX_VEHICLE_CUSTOM; v++)
    {
        new i = CorrectVehicleID(v);

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

stock CreateSkinGiftCase() // Собираем скины
{
    ThingSkinQuan = 0;
    ThingSkinQuanFemale = 0;

    ThingSkinTopQuan = 0;
    ThingSkinTopQuanFemale = 0;
    
    for(new i = 1; i < MAX_MODELS_SKIN; i++)
    {
        if(SkinSale[i] == 1) 
        {
            new genderSkin = GetSkinSex(i);

            if(SkinTop[i] == true)
            {
                if(genderSkin == 1 || genderSkin == 0) ThingSkinTopcaseGift[ThingSkinTopQuan] = i, ThingSkinTopQuan ++;
                else if(genderSkin == 2 || genderSkin == 0) ThingSkinTopcaseGiftFemale[ThingSkinTopQuanFemale] = i, ThingSkinTopQuanFemale ++;
            }
            else
            {
                if(genderSkin == 1 || genderSkin == 0) ThingSkincaseGift[ThingSkinQuan] = i, ThingSkinQuan ++;
                else if(genderSkin == 2 || genderSkin == 0) ThingSkincaseGiftFemale[ThingSkinQuanFemale] = i, ThingSkinQuanFemale ++;
            }
        }
    }
    
    return true;
}

stock CreateAccessoryGiftCase() // Собираем аксессуары для кейса
{
    ThingAccessoryQuan = 0;
    for(new i; i < MAX_ACCESSORY; i++)
    {
        if(AccessoryInfo[i][acCase] == true)
        {
            ThingAccessoryGift[ThingAccessoryQuan] = AccessoryInfo[i][acModel];
            ThingAccessoryGiftBone[ThingAccessoryQuan] = AccessoryInfo[i][acBone];
            ThingAccessoryQuan ++;
        }
    }
    return ThingAccessoryQuan;
}

// Блокируем предметы для кейса (хз, там разные шняги)
stock StopThingForCase(i, thingType)
{
    if(!IsThingNotVariable(i) // Запрещённые предметы для кейса
    || NotGiveThing(i, thingType, 1) // Предметы которые нельзя передать
    || DocumentThing(i, thingType) // Документы
    || CheckThingQuan(i) // Количественные предметы
    || JustOneThingInventory(i, thingType) // Предмет только в единственном экземпляре в инвентаре
    || IsKeyCustomCase(i) // Ключи от кейсов
    ) return true;
    return false;
}

stock CreateThingGiftCase() // Собираем обычные предметы для кейса
{
    thingItemQuan = 0;
    for(new i = 1; i < sizeof(friskName); i++)
    {
        if(!StopThingForCase(i, 0) && !TopThing(i)) ThingItem[thingItemQuan] = i, thingItemQuan ++;
    }
    return thingItemQuan;
}

stock CreateThingTopGiftCase() // Собираем топовые обычные предметы для кейса
{
    thingItemTopQuan = 0;
    for(new i = 1; i < sizeof(friskName); i++)
    {
        if(!StopThingForCase(i, 0) && TopThing(i)) ThingItemTop[thingItemTopQuan] = i, thingItemTopQuan ++;
    }
    return thingItemTopQuan;
}

// Сток для получения обычного предмета из кейса
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


// Рандомайзер для создания кейса
stock CreateCasePlayer(playerid, &thingId, &thingQuan, &thingType, &thingPara, &thingPack, const name[] = "default")
{
    // Поиск кастомного кейса
    new caseID = GetCustomCaseID(name);
    if(caseID >= 0) // Обнаружили кастомный кейс по идентификатору
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
            CommonThingCase(thingId, thingQuan, thingType, thingPack); // Обычный предмет из кастомного кейса (на случай мусорного заполнения)
            thingPack = GetCustomCaseInventoryPack(caseID);
            return true;
        }
        return true;
    }


    if(strfind(name,"gold",true) != (-1))
    {
        switch(random(6))
        {
            case 0: thingType = 0; // Обычный предмет
            case 1: thingType = 1; // Оружие
            case 2: thingType = 2; // Аксессуар
            case 3, 4: thingType = 3; // Одежда
            case 5: thingType = 5; // Транспорт
        }
    }
    else 
    {
        switch(random(15))
        {
            case 0: thingType = 5; // Обычный предмет
            case 1: thingType = 5; // Оружие
            case 2: thingType = 5; // Аксессуар
            case 3, 4: thingType = 5; // Одежда
            case 5: thingType = 5; // Транспорт
            default: thingType = 5; // ПОДКРУТКА обычный предмет
        }
    }

    new quan;
    if(thingType == 0) CommonThingCase(thingId, thingQuan, thingType, thingPack); // Если выпал обычный

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

    else if(thingType == 2) // Аксессуары (Список собирается при запуске сервера и при активации аксессуара для кейса)
    {
        if(ThingAccessoryQuan <= 0) return CommonThingCase(thingId, thingQuan, thingType, thingPack); // Если вдруг аксессуаров для кейса нет, выпадет обычный предмет

        new thingTemp = random(ThingAccessoryQuan);
        thingId = ThingAccessoryGift[thingTemp];
        thingPara = ThingAccessoryGiftBone[thingTemp];
        thingQuan = 1;
    }

    else if(thingType == 3) // Одежда (Список собирается при запуске сервера)
    {
        new bool:givePremiumSkin = false;
        switch(random(5))
        {
            case 1:
            {
                if(strfind(name,"gold",true) != (-1)) givePremiumSkin = true; // Premium
                else givePremiumSkin = false;
            }
            default: givePremiumSkin = false;
        }
        if (givePremiumSkin)
        {
            if(playerid == INVALID_PLAYER_ID)
            {
                if (ThingSkinTopQuan == 0)
                {
                    givePremiumSkin = false;
                }
                else
                {
                    new thingTemp = random(ThingSkinTopQuan);
                    thingId = ThingSkinTopcaseGift[thingTemp];
                }
            }
            else
            {
                if(PlayerInfo[playerid][pSex] == 1) // Мужской скин в кейсе
                {
                    if (ThingSkinTopQuan == 0)
                    {
                        givePremiumSkin = false;
                    }
                    else
                    {
                        new thingTemp = random(ThingSkinTopQuan);
                        thingId = ThingSkinTopcaseGift[thingTemp];
                    }
                }
                else // Женский скин в кейсе
                {
                    if (ThingSkinTopQuanFemale == 0)
                    {
                        givePremiumSkin = false;
                    }
                    else
                    {
                        new thingTemp = random(ThingSkinTopQuanFemale);
                        thingId = ThingSkinTopcaseGiftFemale[thingTemp];
                    }
                }
            }
        }

        if (!givePremiumSkin) // if/else здесь не подходит, так как мы можем позже упасть сюда, когда нет премиум скинов в кейсах
        {
            if(playerid == INVALID_PLAYER_ID)
            {
                if (ThingSkinQuan == 0)
                {
                    return CommonThingCase(thingId, thingQuan, thingType, thingPack); // Если вдруг скинов для кейса нет, выпадет обычный предмет
                }
                new thingTemp = random(ThingSkinQuan);
                thingId = ThingSkincaseGift[thingTemp];
            }
            else
            {
                if(PlayerInfo[playerid][pSex] == 1) // Мужской скин в кейсе
                {
                    if (ThingSkinQuan == 0)
                    {
                        return CommonThingCase(thingId, thingQuan, thingType, thingPack); // Если вдруг скинов для кейса нет, выпадет обычный предмет
                    }
                    new thingTemp = random(ThingSkinQuan);
                    thingId = ThingSkincaseGift[thingTemp];
                }
                else // Женский скин в кейсе
                {
                    if (ThingSkinQuanFemale == 0)
                    {
                        return CommonThingCase(thingId, thingQuan, thingType, thingPack); // Если вдруг скинов для кейса нет, выпадет обычный предмет
                    }
                    new thingTemp = random(ThingSkinQuanFemale);
                    thingId = ThingSkincaseGiftFemale[thingTemp];
                }
            }
        }
        thingPara = 0;
        thingQuan = 1;
    }
    else if(thingType == 5) // Транспорт (Список собирается при запуске сервера)
    {
        new bool:givePremiumVehicle = false;
        new bool:giveLimitedVehicle = false;
        switch(random(40))
        {
            case 8, 9, 10, 11:{
                if(strfind(name,"gold",true) != (-1)) givePremiumVehicle = true; // Premium
                else givePremiumVehicle = false;
            }
            case 1:{
                if(strfind(name,"gold",true) != (-1)) giveLimitedVehicle = true;// Limited
                else giveLimitedVehicle = false;// Limited
            }
            default: givePremiumVehicle = giveLimitedVehicle = false; // Прочие тс
        }

        if (giveLimitedVehicle)
        {
            if (ThingLimitedehicleQuan == 0)
            {
                giveLimitedVehicle = false; // Лимитированных машин нет
                givePremiumVehicle = true; // Попробуем выдать премиум машину
            }
            else
            {
                new thingTemp = random(ThingLimitedehicleQuan);
                thingId = ThingLimitedVehiclecaseGift[thingTemp];
            }
        }
        if (givePremiumVehicle) // if/else здесь не подходит, так как мы можем позже упасть сюда, когда нет лимитированных машин в кейсах
        {
            if (ThingPremiumVehicleQuan == 0)
            {
                givePremiumVehicle = false; // Премиум машин нет
            }
            else
            {
                new thingTemp = random(ThingPremiumVehicleQuan);
                thingId = ThingPremiumVehiclecaseGift[thingTemp];
            }
        }
        if (!givePremiumVehicle && !giveLimitedVehicle) // if/else здесь не подходит, так как мы можем позже упасть сюда, когда нет лимитированных/премиум машин в кейсах
        {
            if (ThingVehicleQuan == 0)
            {
                return CommonThingCase(thingId, thingQuan, thingType, thingPack); // Если вдруг машин для кейса нет, выпадет обычный предмет
            }
            new thingTemp = random(ThingVehicleQuan);
            thingId = ThingVehiclecaseGift[thingTemp];
        }
        new colorveh = 1 + random(254); // Color Vehicle
        thingQuan = colorveh;
    }

    if(strfind(name,"gold",true) != (-1)) thingPack = 9; // GOLD case
    else thingPack = 5; // Не трогаем
    return 1;
}

// Добавляем лимитированный транспорт в кейсе на руках
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

// Вычитаем лимитированный транспорт в кейсе на руках
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
    else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать кейс [ /givecase ID ]");
    return 1;
}

CMD:givecaseall(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    new getNameCaseCustom[24], nameCase[24];
    if(!sscanf(params, "s[24]", getNameCaseCustom)) format(nameCase, sizeof(nameCase), "%s", getNameCaseCustom);

    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 1) GivePlayerCase(playerid, i, nameCase, false);
    }
    new string[140];
	format(string, sizeof(string), " [ ADM ]: %s выдал всем игрокам кейсы [ %s ]", PlayerInfo[playerid][pName], nameCase);
	ABroadCast(COLOR_ADM,string,1);
	AdminLog("givecaseall", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, nameCase);
    return 1;
}

CMD:givecasegro(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    new getNameCaseCustom[24], nameCase[24];
    if(!sscanf(params, "s[24]", getNameCaseCustom)) format(nameCase, sizeof(nameCase), "%s", getNameCaseCustom);

    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 1 && ProxDetectorS(20.0, playerid, i) && playerid != i)
        {
            GivePlayerCase(playerid, i, nameCase, false);
        }
    }

    new string[140];
	format(string, sizeof(string), " [ ADM ]: %s выдал кейсы игрокам рядом с собой [ %s ]", PlayerInfo[playerid][pName], nameCase);
	ABroadCast(COLOR_ADM,string,1);
	AdminLog("givecasegro", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, nameCase);
    return 1;
}

stock GivePlayerCase(playerid, giveplayerid, const name[] = "default", bool:onePlayer = true)
{
    new thingId, thingQuan, thingType, thingPara, thingPack;
    CreateCasePlayer(giveplayerid, thingId, thingQuan, thingType, thingPara, thingPack, name);
    new put_inva = GiveThingPlayer(giveplayerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
    if(put_inva == -1 && onePlayer == true) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре");

    CalculateVehicleLimited(thingId, thingType);
    if(onePlayer == true) SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы выдали %s кейс [ %s ]", PlayerInfo[giveplayerid][pName], name);
    if(giveplayerid != playerid) SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "* Администратор %s выдал вам кейс [ %s ]", PlayerInfo[playerid][pName], name);

    if(onePlayer == true) AdminLog("givecase", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], 0, name);
    return true;
}

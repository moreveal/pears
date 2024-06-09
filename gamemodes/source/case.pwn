/*
Добавляем кейс, Указываем параметры рандома, условно:
case 0..1 - Значит шанс равен 2%
case 2..99 - Значит шанс равен 98%

fpick - Оставляем ноль если выдаем предмет не в инвентарь
quan - Оставляем один если выдаем один предмет.
fpick 94 - Выдача голды человеку.
oGivePlayerMoney(playerid, babki) - Выдать игроку денюжку
*/
#define MAX_CASE_ITEM 10 // Максимальное количество слотов в кейсе
#define MAC_CASES 1 // Максимальное количество типов Кейсов

new ThingVehiclecaseGift[MAX_MODELS_VEHICLE];
new ThingVehicleQuan;

new ThingSkincaseGift[MAX_MODELS_SKIN];
new ThingSkinQuan;

new ThingSkincaseGiftFemale[MAX_MODELS_SKIN];
new ThingSkinQuanFemale;

/*enum caseInfo
{
    caseId, // кейс ID
    caseSlots, // Количество предметов в кейсе
    caseSlot[MAX_CASE_ITEM],// Предметы в кейсе
    caseSlotType[MAX_CASE_ITEM], // Тип слота в кейсе
    caseSlotPara[MAX_CASE_ITEM], // Параметр
    caseSlotQuan[MAX_CASE_ITEM], // Количество
}
new OpenCase[MAC_CASES][caseInfo];*/

stock IsThingNotVariable(i)
{
    if(i == 7  || i == 6 || i == 10 || i == 11 || i == 12 || i == 15 || i == 20 || i == 22 || i == 25 || i == 26 || i == 33 || i == 34 || i == 35  || i == 36  
    || i == 43 || i == 48 || i == 51 || i == 54 || i == 55
    || i == 56 || i == 57 || i == 58 || i == 59 || i == 63 || i == 68 || i == 69 || i == 89 || i == 96 || i >= 99 && i <= 105  || i == 106 
    || i == 108 || i == 109 || i == 110 || i == 111 || i == 120 || i == 123 || i == 125
    || i == 139 || i == 141 || i >= 142 && i <= 160 || i >= 163 && i <= 174 || i == 178 || i == 179 || i >= 184 && i <= 189 || i == 191 
    || i == 192 || i == 193 || i == 194 || i == 195 || i == 196 || i == 199 
    || i == 200 || i == 203 || i == 204 || i == 226 || i == 227 || i == 228 || i == 229
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

    // Собираем обычный транспорт
    for(new i = 0; i < 212; i++)
    {
        if(!IsAVehExisting(i+400)
            || VehGos[i] <= 0 || VehGold[i] <= 0) continue; // Пропускаем невалидный транспорт

        new vehClass = GetVehicleClass(i+400);
        if(vehClass == 0 || vehClass >= 5) continue; // Пропускаем невалидные тачки по классу

        new vehType = GetVehicleType(i+400);
        if(vehType == 1 || vehType == 2)
        {
            if(VehSale[i] == 1
                || ((VehLimited[i] > 0 && VehQuan[i] < VehLimited[i]) && (VehLimited[i] > 0 && VehLimitedCase[i] < VehLimited[i]))) ThingVehiclecaseGift[ThingVehicleQuan] = i+400, ThingVehicleQuan ++;
        }
    }

    // Собираем кастомный транспорт
    for(new i = 0; i < MAX_VEHICLE_CUSTOM; i++)
    {
        if(!IsAVehExisting(i+2000)
            || VehGos[i] <= 0 || VehGold[i] <= 0) continue; // Пропускаем невалидный транспорт

        new vehClass = GetVehicleClass(i+2000);
        if(vehClass == 0 || vehClass >= 5) continue; // Пропускаем невалидные тачки по классу

        new vehType = GetVehicleType(i+400);
        if(vehType == 1 || vehType == 2)
        {
            if(VehSale[i] == 1
                || ((VehLimited[i] > 0 && VehQuan[i] < VehLimited[i]) && (VehLimited[i] > 0 && VehLimitedCase[i] < VehLimited[i]))) ThingVehiclecaseGift[ThingVehicleQuan] = i+2000, ThingVehicleQuan ++;
        }
    }
    return ThingVehicleQuan;
}

stock CreateSkinGiftCase() // Собираем скины
{
    ThingSkinQuan = 0;
    
    for(new i; i < MAX_MODELS_SKIN; i++)
    {
        if(SkinSale[i] == 1) 
        {
            new genderSkin = GetSkinSex(i);
            if(genderSkin == 1 || genderSkin == 0) ThingSkincaseGift[ThingSkinQuan] = i, ThingSkinQuan ++;
            else if(genderSkin == 2 || genderSkin == 0) ThingSkincaseGiftFemale[ThingSkinQuan] = i, ThingSkinQuanFemale ++;
        }
    }
    return ThingSkinQuan;
}

// Рандомайзер для создания кейса
stock CreateCasePlayer(playerid, &thingId, &thingQuan, &thingType, &thingPara, &thingPack)
{
    switch(random(15))
    {
        case 0: thingType = 0; // Обычный предмет
        case 1: thingType = 1; // Оружие
        //case 2: thingType = 0; // Акс 2(временно 0)
        case 3, 4: thingType = 3; // Одежда
        case 5: thingType = 5; // Транспорт
        default: thingType = 0; // ПОДКРУТКА обычный предмет
    }

    new quan;
    if(thingType == 0) // Если выпал обычный
    {
        new ThingIDcaseGift[sizeof(friskName)];
        for(new i = 1; i < sizeof(friskName); i++)
        {
            if(IsThingNotVariable(i) // Запрещённые предметы для кейса
                && !NotGiveThing(i, thingType, 1) // Предметы которые нельзя передать
                && !DocumentThing(i, thingType) // Документы
                && !CheckThingQuan(i) // Количественные предметы
                && !JustOneThingInventory(i, thingType) // Предмет только в единственном экземпляре в инвентаре
                //&& !PerishableThing(i,0) // Портящиеся предметы
                ) ThingIDcaseGift[quan] = i, quan ++;
        }
        new thingTemp = random(quan);
        thingId = ThingIDcaseGift[thingTemp];
        thingQuan = 0;
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
    else if(thingType == 2)
    {
        new ThingIDcaseGift[MAX_ACCESSORY];
        for(new i; i < MAX_ACCESSORY; i++)
        {
            if(AccessoryInfo[i][acStatus] == 1) ThingIDcaseGift[quan] = i, quan ++;
        }
        new thingTemp = random(quan);
        thingId = AccessoryInfo[ThingIDcaseGift[thingTemp]][acModel];
        thingPara = AccessoryInfo[ThingIDcaseGift[thingTemp]][acBone];
        thingQuan = 1;
    }
    else if(thingType == 3) // Список собирается при запуске сервера
    {
        if(PlayerInfo[playerid][pSex] == 1) // Мужской скин в кейсе
        {
            new thingTemp = random(ThingSkinQuan);
            thingId = ThingSkincaseGift[thingTemp];
        }
        else // Женский скин в кейсе
        {
            new thingTemp = random(ThingSkinQuanFemale);
            thingId = ThingSkincaseGiftFemale[thingTemp];
        }
        thingQuan = 1;
    }
    else if(thingType == 5) // Список собирается при запуске сервера
    {
        new thingTemp = random(ThingVehicleQuan);
        thingId = ThingVehiclecaseGift[thingTemp];
        new colorveh = 1 + random(254); // Color Vehicle
        thingQuan = colorveh;
    }

    thingPack = 5; // Не трогаем
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
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать кейс [ /givecase ID ]");
    
    GivePlayerCase(playerid, params[0]);
    return 1;
}

CMD:givecaseall(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 1) GivePlayerCase(playerid, i, false);
    }

    new string[140];
	format(string, sizeof(string), " [ ADM ]: %s выдал всем игрокам кейсы", PlayerInfo[playerid][pName]);
	ABroadCast(COLOR_ADM,string,1);
	AdminLog("givecaseall", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Выдал всем кейсы");
    return 1;
}

stock GivePlayerCase(playerid, giveplayerid, bool:onePlayer = true)
{
    new thingId, thingQuan, thingType, thingPara, thingPack;
    CreateCasePlayer(giveplayerid, thingId, thingQuan, thingType,thingPara, thingPack);
    new put_inva = GiveThingPlayer(giveplayerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
    if(put_inva == -1 && onePlayer == true) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре");

    CalculateVehicleLimited(thingId, thingType);
    if(onePlayer == true) SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы выдали %s кейс", PlayerInfo[giveplayerid][pName]);
    if(giveplayerid != playerid) SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "* Администратор %s выдал вам кейс", PlayerInfo[playerid][pName]);

    if(onePlayer == true) AdminLog("givecase", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], 0, "Рандомный кейс");
    return true;
}

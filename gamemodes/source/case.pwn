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

new ThingVehiclecaseGift[212 + MAX_VEHICLE_CUSTOM];
new ThingVehicleQuan;

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
    if(i == 7  || i == 6 || i == 10 || i == 11 || i == 12 || i == 15 || i == 25 || i == 26 || i == 33 || i == 34 || i == 35  || i == 36  || i == 43 || i == 51 
    || i == 56 || i == 57 || i == 58 || i == 59 || i == 63 || i == 68 || i == 69 || i == 106 || i == 108 || i == 109 || i == 110 || i == 111 
    || i >= 125 && i <= 138 || i == 11 || i >= 142 && i <= 160 || i == 171 || i == 178 || i == 179 || i >= 184 && i <= 189 || i == 191 
    || i == 192 || i == 193 || i == 194 || i == 195 || i == 196 || i == 199 || i == 200 || i == 203 || i == 20 || i == 22 || i == 55 || i == 54 || i == 89 || i >= 99 && i <= 105 
    || i == 120 || i == 123 || i == 141 || i >= 163 && i <= 174) return 0;
    return 1;
}

stock IsThingClotheNotVariable(i)
{
    if(i == 1 || i == 74) return 0;
    return 1;
}

stock IsThingGunNotVariable(i)
{
    if(i == 0 || i == 1 || i == 2 || i == 7 || i == 9 || i >= 15 && i <= 21 || i == 23 || i == 26 || i == 34 || i >= 34) return 0;
    return 1;
}

stock CreateVehicleGift()
{
    for(new i =1; i < 212; i++)
    {
        if(GetVehicleClass(i+400) >= 1 && GetVehicleClass(i+400) <= 4 && GetVehicleType(i+400) == 1  && GetVehicleType(i+400) == 2) ThingVehiclecaseGift[ThingVehicleQuan] = i+400, ThingVehicleQuan ++;
    }
    for(new i ; i < MAX_VEHICLE_CUSTOM; i++)
    {
        if(GetVehicleClass(i+2000) >= 1 && GetVehicleClass(i+2000) <= 4 && GetVehicleType(i+2000) == 1  && GetVehicleType(i+2000) == 2) ThingVehiclecaseGift[ThingVehicleQuan] = i+2000, ThingVehicleQuan ++;
    }
    return 1;
}

// Рандомайзер для создания кейса
stock CreateCasePlayer(type,&thingId, &thingQuan, &thingType, &thingPara, &thingPack)
{
    // Тут временно и нужно нормально заполнить рандомайзер для кесов
    // Скорее всего нужно связать рандомайзер с системой fundraisers 
    // Чтобы был какой-то единый общий список доступных предметов для подарков, который мы будем заполнять
    // Соответственно брать список предметов для кейса будем оттуда
    new zaglushka = type;
    // ВАЖНО! Не класть еду в кейсы, чтобы она там по unix не портилась нахрен
    if(zaglushka == 0)
    {
        switch(random(11))
        {
            case 0: thingType = 0; // Обычный предмет
            case 1: thingType = 1; // оружие
            case 2: thingType = 0; // Акс 2(временно 0)
            case 3: thingType = 3; // Одежда
            case 4: thingType = 5; // Транспорт
            case 5..10: thingType = 0; // ПОДКРУТКА обычный предмет
        }
    }
    new quan;
    if(thingType == 0) // Если выпал обычный
    {
        new ThingIDcaseGift[sizeof(friskName)];
        for(new i = 1; i < sizeof(friskName); i++)
        {
            if(IsThingNotVariable(i) && !NotGiveThing(i, thingType, 1)
            && !CheckThingQuan(i) && !PerishableThing(i,0)) ThingIDcaseGift[quan] = i, quan ++;
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
    else if(thingType == 3)
    {
        new ThingIDcaseGift[312 + MAX_SKIN_CUSTOM];
        for(new i; i < 312 + MAX_SKIN_CUSTOM; i++)
        {
            if(SkinSale[i] == 1) ThingIDcaseGift[quan] = i, quan ++;
        }
        new thingTemp = random(quan);
        thingId = ThingIDcaseGift[thingTemp];
        thingQuan = 1;
    }
    else if(thingType == 5)
    {
        new thingTemp = random(ThingVehicleQuan);
        thingId = ThingVehiclecaseGift[thingTemp];
        thingQuan = 1;
    }


    thingPack = 5; // Не трогаем
    return 1;
}

CMD:givecase(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не администратор");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать кейс в инвентарь [ /givecase ID ]");
    
    new thingId, thingQuan, thingType, thingPara, thingPack;
    CreateCasePlayer(0, thingId, thingQuan, thingType,thingPara, thingPack);
    new put_inva = GiveThingPlayer(params[0], thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре");
	return 1;
}

/*stock CaseList(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 21) return 0

	new quan;
	new line[90],lines[1170];
    format(line,sizeof(line),"\n{cccccc}Добавить Кейс{ff9000}>>\t"), strcat(lines,line);
    format(line,sizeof(line),"\n{ff9000}0. Кейс новичков{ff9000}>>\t"), strcat(lines,line);
    for(new i = 0; i < MAX_ORDERESCORT; i++)
	{
		List[i][playerid] = 0;

		if(OrganInfo[g][gOrder][i] > 0)
		{
		    List[quan][playerid] = i;
			quan ++;
			format(line,sizeof(line),"\n{ff9000}%d. Кейс \t{cccccc}Количество предметов: %d", quan,OpenCase[i][caseSlots]), strcat(lines,line);
		}
	}
	new header[40];
	format(header,sizeof(header),"Управление кейсами");
	ShowDialog(playerid,11111,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Выбрать","Отмена");
	return 1;
}

stock CaseMenu(playerid, number, slot)
{
    if(PlayerInfo[playerid][pSoska] < 21) return 0

	new quan;
	new line[90],lines[1170];
    DP[2][playerid] = number;
    DP[3][playerid] = slot;
    format(line,sizeof(line),"{cccccc}Тип предмета: {ff9000} \t%d", OpenCase[number][caseSlotType][slot]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Название предмета:\t {ff9000}%s",friskName[OpenCase[number][caseSlot][slot]]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Номер предмета:\t {ff9000}%d",OpenCase[number][caseSlot][slot]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Параметр:\t {ff9000}%d",OpenCase[number][caseSlotPara][slot]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Количетсво:\t {ff9000}%d",OpenCase[number][caseSlotQuan][slot]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Добавить {ff9000}>>\t"), strcat(lines,line);
	new header[40];
	format(header,sizeof(header),"{ff9000}Слот Кейс",slot);
	ShowDialog(playerid,11112,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Выбрать","Отмена");
	return 1;
}

stock dialogCase_MakeSystem(playerid, dialogid, response, listitem)
{
    if(dialogid == 11111)
    {
        if(response)
        {
            if(listitem < 0 || listitem > MAX_MAKE) return ErrorMessage(playerid,"{ff6347} Выбрана не правильная строка.");
            DP[4][playerid] = listitem;
            new number = DP[2][playerid];
            new slot = DP[3][playerid];
            new string[100];
            if(listitem == 0) ShowDialog(playerid, 11113,DIALOG_STYLE_TABLIST, "Выбор типа для слота","1 - Обычный\n2 - Оружие\n3 - Одежда\n4 - Аксессуар\n5 - Транспорт");
            if(listitem == 1)
            {
                CaseMenu(playerid,number,slot)
            }
            if(listitem == 2)
            {
                if(OpenCase[number][caseSlotType][slot] == 0)
               {
                    SendClientMessage(playerid,COLOR_GREY, "[Мысли] Сначала нужно указать тип предмета")
                    return CaseMenu(playerid,number,slot);
               }
               else
               {
                    ShowDialog(playerid, 11113,DIALOG_STYLE_INPUT "Введите количество","выбор","отмена");
               }
            }
        }
    }
    if(dialogid == 11113)
    {

    }
    return 1;
}*/
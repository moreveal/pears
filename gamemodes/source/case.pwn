/*
Добавляем кейс, Указываем параметры рандома, условно:
case 0..1 - Значит шанс равен 2%
case 2..99 - Значит шанс равен 98%

fpick - Оставляем ноль если выдаем предмет не в инвентарь
quan - Оставляем один если выдаем один предмет.
fpick 94 - Выдача голды человеку.
oGivePlayerMoney(playerid, babki) - Выдать игроку денюжку
*/

stock IsVariableThing(i)
{
    if(i == 1 || i == 2) return 1;
    return 0;
}

// Рандомайзер для создания кейса
stock CreateCasePlayer(&thingId, &thingQuan, &thingType, &thingPara, &thingPack)
{
    // Тут временно и нужно нормально заполнить рандомайзер для кесов
    // Скорее всего нужно связать рандомайзер с системой fundraisers 
    // Чтобы был какой-то единый общий список доступных предметов для подарков, который мы будем заполнять
    // Соответственно брать список предметов для кейса будем оттуда
    
    // ВАЖНО! Не класть еду в кейсы, чтобы она там по unix не портилась нахрен

    switch(random(5))
    {
        case 0: thingType = 0; // Обычный предмет
        case 1: thingType = 1; // оружие
        case 2: thingType = 2;
        case 3: thingType = 3;
        case 4: thingType = 5;
    }

    if(thingType == 0) // Если выпал обычный
    {
        new ThingIDCaseGift[sizeof(friskName)];
        new quan;
        for(new i = 0; i < sizeof(friskName); i++)
        {
            if(IsThingVariable(i) && !NotGiveThing(i, thingType, 1)
                && !CheckThingQuan(i)) ThingIDCaseGift[quan] = i; quan ++;
        }
        new thingTemp = random(quan);
        thingId = ThingIDCaseGift[thingTemp];
        thingQuan = 1;
    }
    else if(thingType == 1)
    {
        new ThingIDCaseGift[46];

        thingQuan = 1;
        thingPara = GUN_HEALTH;
    }
    else if(thingType == 2)
    {
        new ThingIDCaseGift[MAX_ACCESSORY];
    }



    thingPack = 5; // Не трогаем
    return 1;
}

CMD:givecase(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не администратор");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать кейс в инвентарь [ /givecase ID ]");
    
    new thingId, thingQuan, thingType, thingPara, thingPack;
    CreateCasePlayer(thingId, thingQuan, thingType, thingPack);
    new put_inva = GiveThingPlayer(params[0], thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре");
	return 1;
}

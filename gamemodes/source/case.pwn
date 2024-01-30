/*
Добавляем кейс, Указываем параметры рандома, условно:
case 0..1 - Значит шанс равен 2%
case 2..99 - Значит шанс равен 98%

fpick - Оставляем ноль если выдаем предмет не в инвентарь
quan - Оставляем один если выдаем один предмет.
fpick 94 - Выдача голды человеку.
oGivePlayerMoney(playerid, babki) - Выдать игроку денюжку
*/

// Рандомайзер для создания кейса
stock CreateCasePlayer(&thingId, &thingQuan, &thingType, &thingPack)
{
    // Тут временно и нужно нормально заполнить рандомайзер для кесов
    // Скорее всего нужно связать рандомайзер с системой fundraisers 
    // Чтобы был какой-то единый общий список доступных предметов для подарков, который мы будем заполнять
    // Соответственно брать список предметов для кейса будем оттуда
    
    // ВАЖНО! Не класть еду в кейсы, чтобы она там по unix не портилась нахрен
    thingId = 1;
    thingQuan = 1;
    thingType = 0;
    thingPack = 5;
    return 1;
}

CMD:givecase(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не администратор");
    if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать кейс в инвентарь [ /givecase ID ]");
    
    new thingId, thingQuan, thingType, thingPack;
    CreateCasePlayer(thingId, thingQuan, thingType, thingPack);
    new put_inva = GiveThingPlayer(params[0], thingId, thingQuan, 0, 0, thingType, thingPack, 9999);
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре");
	return 1;
}

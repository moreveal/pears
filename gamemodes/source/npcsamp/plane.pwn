
#define MAX_HEALTH_PLANE 400 // Максимальное хп самолёта
#define MAX_DIST_OBJECT_PLANE 300.0 // Расстояние отображения объектов на самолёте
#define HIDE_WORLD_PLANE INVISIBLE_VIRTUAL_WORLD
#define HIDE_INTERIOR_PLANE 10

new plane_health;
new plane_objects[2];
new plane_timer;
new plane_gold; // Слиток золота в сумке из самолёта (1 есть)

CMD:findplane(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(!NpcStatus(4)) return ErrorMessage(playerid, "{FF6347}Самолёт сейчас не запущен");
	new Float:pos[3];
	GetVehiclePos(flyveh, pos[0], pos[1], pos[2]);
	CreateGps(playerid, pos[0], pos[1], pos[2], 0, 0, 10.0);
	return 1;
}

stock GetBagPlane(playerid, t)
{
    new string[140];

    // Расчитывае деньги (рандомно от минимальной до максимальной)
    new randmoney = ServerInfo[4] - ServerInfo[3];
    new money = ServerInfo[3] + random(randmoney);
    if(money <= 0) money = 12000; // На всякий случай, малоли расчитало на 0 или на отрицательное число

    new quanInvent = 1; // Требуется свободных слотов в инвентаре
    if(plane_gold > 0) quanInvent = 2; // Если есть слиток золота, требуем два слота
    if(!free_invent(playerid, quanInvent)) return format(string, sizeof(string), "{FF6347}В инвентаре не хватает места\nТребуется свободных слотов: %d", quanInvent), ErrorMessage(playerid, string);

    mysql_tquery(pearsq, "START TRANSACTION;");
    // Даём голд (если он был в этой сумке)
    if(plane_gold > 0) GiveThingPlayer(playerid, 94, 1, 0, 0, 0, 0, 9999);

    // Даём кейс
    new thingId, thingQuan, thingType, thingPara, thingPack;
    CreateCasePlayer(playerid, thingId, thingQuan, thingType, thingPara, thingPack);
    GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
    CalculateVehicleLimited(thingId, thingType);
    mysql_tquery(pearsq, "COMMIT;");

    // Даём деньги
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Ухх! Мои денюжки.. В сумке было {99ff66}%d$ {cccccc}(%s)", money, get_k(money));
    new text[120];
    format(text, sizeof(text), "открыл%s сумку и забрал%s {99ff66}%d$ {C2A2DA}(%s)", gender(playerid), gender(playerid), money, get_k(money));
    SetPlayerChatBubble(playerid, text, COLOR_PURPLE, 20.0, 4000);
    format(string, sizeof(string), "* %s %s", playername(playerid), text);
    ProxDetectorScream(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
    oGivePlayerMoney(playerid, money);
    PlayerPlaySound(playerid,5600,0,0,0);

    ApplyAnimation(playerid,"CARRY","liftup",4.1, false, true, true, false, 0); // Анимация поднять предмет
	DestroyThrow(t); // Удаляем предмет на земле
	updatethrowall(t); // Обновляем всем у кого открыт инвентарь рядом с предметом

    MoneyLog("robplane", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", money, "Ограбил самолёт");
    return 1;
}

stock PlaneDamage(playerid, bool:explosion = false)
{
    if(explosion == true) plane_health -= 20 + random(8);
    else plane_health --;

    new string[70];
	if(plane_health >= 0) format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d/%d", plane_health, MAX_HEALTH_PLANE);
    else format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~0/%d", MAX_HEALTH_PLANE);
    GameTextForPlayer(playerid, string, 2000, 3);

    if(plane_health <= 0)
    {
        CompleteBattlePassTask(playerid, 38, 1);
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мешок падает с самолёта! Нужно дождаться когда он упадёт и подобрать его [ N >> Рядом ]");
        PlayerPlaySound(playerid,6401,0,0,0);

        DestroyDynamicObject(plane_objects[1]);
        new Float:fly_pos[3];
        GetCoordBootVehicle(flyveh, fly_pos[0], fly_pos[1], fly_pos[2]);

        plane_objects[1] = CreateDynamicObject(18849, fly_pos[0], fly_pos[1], fly_pos[2], 0.0, 0.0, 0.0, 0, 0, -1, MAX_DIST_OBJECT_PLANE, MAX_DIST_OBJECT_PLANE);

        new Float:find_z;
        CA_FindZ_For2DCoord(fly_pos[0], fly_pos[1], find_z);

        find_z += object_correct_z(18849);
        new time = MoveDynamicObject(plane_objects[1], fly_pos[0], fly_pos[1], find_z, 2.0);

        if(plane_timer > 0) KillTimer(plane_timer);
        plane_timer = SetTimerEx("PlaneBagEnd", time, false, "fff", fly_pos[0], fly_pos[1], find_z);
    }
    return 1;
}

function PlaneBagEnd(Float:x, Float:y, Float:z)
{
    if(plane_timer > 0) KillTimer(plane_timer);
    if(plane_objects[1] > 0) DestroyDynamicObject(plane_objects[1]), plane_objects[1] = 0;
    SetThrow(-1, 229, 229, 1, 0, 0, 0, 0, 0, 0, x, y, z, 0.0, 0.0, 0.0, 1800, 0, 0);

    around_update(100.0, x, y, z, 0, 0);
    return 1;
}

stock PlaneStart()
{
    // Запускаем NPC
    if(!StartNpc(4)) return 1; // Запускаем с проверкой (! - значит был уже запущен)

    ShowPlane();
    plane_objects[0] = CreateDynamicObject(19089, -0.00020, 0.08770, 0.54640,   -57.24000, 0.00000, 0.00000, 0, 0, -1, MAX_DIST_OBJECT_PLANE, MAX_DIST_OBJECT_PLANE);
    plane_objects[1] = CreateDynamicObject(18849, -0.0531, -7.7945, 3.0531,   0.00000, 12.51000, -90.00000, 0, 0, -1, MAX_DIST_OBJECT_PLANE, MAX_DIST_OBJECT_PLANE);
    SetTextureBagPlane(plane_objects[1]);

    AttachDynamicObjectToVehicle(plane_objects[0], flyveh,  -0.00020, 0.08770, 0.54640,   -57.24000, 0.00000, 0.00000);
    AttachDynamicObjectToVehicle(plane_objects[1], flyveh,  -0.0531, -7.7945, 3.0531,   0.0000, 12.5100, -90.0000);

    if(serverType == 0) plane_health = 20; // Хп самолёта для тестов на компе
    else plane_health = MAX_HEALTH_PLANE; // Хп самолёта на основных серверах
    plane_gold = random(2);
    return 1;
}

stock PlaneEnd(playerid)
{
    if(IsARealNPC(playerid))
    {
        OnNpcSpawn(playerid); // Возвращаем NPC на позицию
        ReloadVehicleNPC(flyveh);
        plane_health = 0;

        if(plane_objects[0] > 0) DestroyDynamicObject(plane_objects[0]), plane_objects[0] = 0;
        if(plane_objects[1] > 0) DestroyDynamicObject(plane_objects[1]), plane_objects[1] = 0;
    }
    return 1;
}

stock SetTextureBagPlane(objectid)
{
    SetDynamicObjectMaterial(objectid, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
    SetDynamicObjectMaterial(objectid, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
    return 1;
}

// Скрываем самолёт в другой вирт мир и интерьер, когда он на стоянке
stock HidePlane()
{
    LinkVehicleToInterior(flyveh, HIDE_INTERIOR_PLANE);
	SetVehicleVirtualWorld(flyveh, HIDE_WORLD_PLANE);
    return 1;
}

// Отображаем самолёт в общем мире
stock ShowPlane()
{
    LinkVehicleToInterior(flyveh, 0);
	SetVehicleVirtualWorld(flyveh, 0);
    return 1;
}

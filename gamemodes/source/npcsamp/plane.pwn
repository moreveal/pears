
#define MAX_HEALTH_PLANE 700

new plane_health;
new plane_objects[2];
new plane_timer;

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
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Ништяк! Мешок падает с самолёта [ N >> Рядом ]");
        SuccessMessage(playerid, "{99ff66}Мешок падает с самолёта, его нужно подобрать\n{ffcc66}N >> Рядом");

        DestroyDynamicObject(plane_objects[1]);
        new Float:fly_pos[3];
        GetCoordBootVehicle(flyveh, fly_pos[0], fly_pos[1], fly_pos[2]);

        plane_objects[1] = CreateDynamicObject(18849, fly_pos[0], fly_pos[1], fly_pos[2], 0.0, 0.0, 0.0, 0, 0, -1, 700.00, 700.00);

        new Float:find_z;
        CA_FindZ_For2DCoord(fly_pos[0], fly_pos[1], find_z);

        find_z += 7.2;
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

    plane_objects[0] = CreateDynamicObject(19089, -0.00020, 0.08770, 0.54640,   -57.24000, 0.00000, 0.00000, 0, 0, -1, 700.00, 700.00);
    plane_objects[1] = CreateDynamicObject(18849, -0.0531, -7.7945, 3.0531,   0.00000, 12.51000, -90.00000, 0, 0, -1, 700.00, 700.00);
    SetDynamicObjectMaterial(plane_objects[1], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
    SetDynamicObjectMaterial(plane_objects[1], 1, 19962, "samproadsigns", "materialtext1", 0x00000000);

    AttachDynamicObjectToVehicle(plane_objects[0], flyveh,  -0.00020, 0.08770, 0.54640,   -57.24000, 0.00000, 0.00000);
    AttachDynamicObjectToVehicle(plane_objects[1], flyveh,  -0.0531, -7.7945, 3.0531,   0.0000, 12.5100, -90.0000);

    plane_health = MAX_HEALTH_PLANE;
    return 1;
}

stock PlaneEnd(playerid)
{
    if(IsARealNPC(playerid))
    {
        OnNpcSpawn(playerid); // Возвращаем NPC на позицию
        ReloadVehicleNPC(collectorveh);
        plane_health = 0;

         if(plane_objects[0] > 0) DestroyDynamicObject(plane_objects[0]), plane_objects[0] = 0;
         if(plane_objects[1] > 0) DestroyDynamicObject(plane_objects[1]), plane_objects[1] = 0;
    }
    return 1;
}

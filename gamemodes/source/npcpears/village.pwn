
#define NOT_FIND_ATTACK_PLAYER 9000
#define SECOND_FOR_BACK_VILLAGE 300 // Время на возвращение ботов деревенских после того как их всех убили
#define CD_GIFT_VILLAGE 3600 // Кд, через которое подарки можно будет получить, убив всех ботов
#define RESPAWN_VILLAGE_NPC 180 // Время респавна для NPC
#define MAX_CASE_VILLAGE 8 // Максимальное количество кейсов у деревенских

new Iterator:VillagePlayer<MAX_PLAYERS>;

enum VILLAGENPCWALK { Float:WalkStart_X, Float:WalkStart_Y, Float:WalkStart_Z, Float:WalkStop_X, Float:WalkStop_Y, Float:WalkStop_Z }
new VillageNpcWalk[][VILLAGENPCWALK] =
{
	{ -1563.2344,2677.7383,55.6835, -1563.2062,2697.9192,55.8183},
	{ -1506.4155,2663.7102,55.8360, -1535.9773,2664.2480,55.8360},
	{ -1553.6833,2662.3206,55.8403, -1553.4933,2600.9385,55.8360},
    { -1518.4160,2678.9146,55.8360, -1551.8831,2678.6255,55.8360},
    { -1538.3955,2659.9458,55.8360, -1538.3961,2613.3933,55.8360},
    { -1485.8319,2678.9893,55.8360, -1517.1202,2678.7100,55.8360},
    { -1503.6010,2662.5103,55.8403, -1503.3816,2629.3110,55.8360},
    { -1488.2751,2661.3218,55.8360, -1488.0927,2611.8557,55.8360},
    { -1486.4047,2663.3298,55.8360, -1436.0438,2663.5657,55.8360},
    { -1418.4076,2664.9028,55.8360, -1418.2400,2610.5056,55.8360},
    { -1433.7734,2610.7292,55.8360, -1433.7128,2659.7478,55.8360},
    { -1418.1667,2593.7991,55.7587, -1445.6686,2593.9309,55.8360},
    { -1448.5513,2593.8240,55.8360, -1486.4504,2593.8064,55.8360},
    { -1485.9523,2608.5994,55.8360, -1466.0657,2608.7263,55.8360},
    { -1462.9865,2608.6899,55.8360, -1437.2056,2608.7302,55.8360},
    { -1488.4540,2588.2324,55.8360, -1488.4872,2563.0142,55.8360},
    { -1503.4723,2560.9150,55.8360, -1503.3622,2589.5986,55.8360},
    { -1505.3534,2593.6526,55.8360, -1536.9777,2593.3191,55.8360},
    { -1536.4692,2608.5618,55.8360, -1504.9670,2609.0723,55.8360},
    { -1499.0168,2544.4089,55.8360, -1532.9425,2543.7427,55.8360},
    { -1537.8613,2558.9189,55.8360, -1506.2584,2558.6521,55.8360},
    { -1500.7140,2532.3186,55.6875, -1527.1494,2532.5203,55.6875},
    { -1524.5896,2679.1912,55.8360, -1550.7054,2677.3784,55.8360},
    { -1553.9613,2661.8264,55.8360, -1553.2594,2628.3672,55.8360},
    { -1538.1300,2632.1814,55.8360, -1538.3060,2654.8223,55.8360},
    { -1426.7478,2594.5620,55.8360, -1440.5133,2594.5186,55.8360},
    { -1433.7206,2613.3018,55.8360, -1433.3739,2630.3848,55.8360},
    { -1407.4387,2630.5642,55.6875, -1408.3096,2649.6248,55.6875}
};

new VillageRandomWeapons[] = { 4, 6, 9, 9, 25, 26, 30, 30, 30, 30 };
new VillageRandomSkins[] = { 1, 15, 32, 33, 34, 95, 128, 132, 133, 134, 136, 158, 159, 160, 161, 162, 183, 200, 202, 234, 235, 236 };

enum VILLAGEINFO
{
	NPC:villID[sizeof(VillageNpcWalk)], // ID бота
    bool:villActive, // Статус активна ли битва (боты агрессивные или нет)
    villRespawn[sizeof(VillageNpcWalk)], // Время, через которое бот заспавнится
    villZone, // Динамическая зона деревни
    villAttackPlayerid[sizeof(VillageNpcWalk)], // ID игрока, которого атакует бот
    villDestination[sizeof(VillageNpcWalk)], // Направление прогулки бота, чтобы повторно не направлять в одну и ту-же точку
    villCD, // Кд на получение призов после того как все боты убиты
    Text3D:villEnterLabel[2], // Лейблы входов
    bool:villGiftStatus, // Статус, можно ли забирать подарки
    villCDShowGift // Время, которое даётся на то, чтобы забрать все подарки
}
new VillageInfo[VILLAGEINFO];

// Проверка бота, дохлый ли он
stock IsNpcDead(NPC:npc)
{
    new Float:health;
    GetNpcHealth(npc, health);
    return health <= 0.0;
}

// Получаем дистанцию от бота до позиции
forward Float:GetDistanceNpcPoint(NPC:npc, Float:x1,Float:y1,Float:zo1);
public Float:GetDistanceNpcPoint(NPC:npc, Float:x1,Float:y1,Float:zo1)
{
    new Float:npc_pos[3];
    GetNpcPosition(npc, npc_pos[0], npc_pos[1], npc_pos[2]);
	return floatsqroot(floatpower(floatabs(floatsub(npc_pos[0],x1)),2)+floatpower(floatabs(floatsub(npc_pos[1],y1)),2)+floatpower(floatabs(floatsub(npc_pos[2],zo1)),2));
}

CMD:rvillage(playerid)
{
    if(admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)
        || PlayerInfo[playerid][pMedia] >= 3)
    {
        if(VillageInfo[villCD] <= 0) return ErrorMessage(playerid, "{FF6347}Подарки в деревне можно получить");
        VillageInfo[villCD] = 0;

        new string[100];
        format(string, sizeof(string), " [ ADM ]: %s сбросил кд хранилища деревенских",PlayerInfo[playerid][pName]);
	    ABroadCast(COLOR_ADM,string,1);
        AdminLog("rvillage", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
    }
    else ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    return true;
}

stock CreateVillageNpc()
{
    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        VillageInfo[villID][i] = CreateNpc(VillageRandomSkins[random(sizeof(VillageRandomSkins))], VillageNpcWalk[i][WalkStart_X], VillageNpcWalk[i][WalkStart_Y], VillageNpcWalk[i][WalkStart_Z]);
        SpawnVillageNpc(i);
    }

    VillageInfo[villZone] = CreateDynamicSphere(-1490.1393,2608.5479,55.6808, 140.0, 0, 0);

    // Входы
	VillageInfo[villEnterLabel][0] = CreateDynamic3DTextLabel(" ",0xA9C4E4FF,-1483.2771,2644.1699,58.7281,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    VillageInfo[villEnterLabel][1] = CreateDynamic3DTextLabel(" ",0xA9C4E4FF,-1475.2959,2614.4619,58.7813,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    UpdateLabelVillageGift();
    CreateDynamicPickup(19132, 1, -1483.2771,2644.1699,58.7281, 0, 0);
    CreateDynamicPickup(19132, 1, -1475.2959,2614.4619,58.7813, 0, 0);

    // Выходы
    CreateDynamicPickup(19132, 1, -1483.0803,2642.3938,58.7813, 0, 0);
    CreateDynamicPickup(19132, 1, -1476.9990,2613.9775,58.7813, 0, 0);
    return true;
}

// Входы выходы в хранилище деревенских
stock DoorVillageStorage(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid,1.0,-1483.2771,2644.1699,58.7281) && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0
        || IsPlayerInRangeOfPoint(playerid,1.0,-1475.2959,2614.4619,58.7813) && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
	{
        if(VillageInfo[villGiftStatus] == true)
        {
            if(IsPlayerInRangeOfPoint(playerid,1.0,-1483.2771,2644.1699,58.7281)) PPSetPlayerPos(playerid,-1483.2737,2640.6836,58.7813), PPSetPlayerFacingAngle(playerid,185.0136);
            else if(IsPlayerInRangeOfPoint(playerid,1.0,-1475.2959,2614.4619,58.7813)) PPSetPlayerPos(playerid,-1478.7166,2614.4929,58.7880), PPSetPlayerFacingAngle(playerid,47.1690);
            SetCameraBehindPlayer(playerid);
        }
        else ErrorMessage(playerid, "{FF6347}Хранилище деревенских закрыто");
        return true;
    }

    // Выход 1
    else if(IsPlayerInRangeOfPoint(playerid,1.0,-1483.0803,2642.3938,58.7813) && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
	{
        PPSetPlayerPos(playerid,-1483.1899,2646.1348,58.7281), PPSetPlayerFacingAngle(playerid,0.0);
        SetCameraBehindPlayer(playerid);
        return true;
    }

    // Выход 2
    else if(IsPlayerInRangeOfPoint(playerid,1.0,-1476.9990,2613.9775,58.7813) && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
	{
        PPSetPlayerPos(playerid,-1473.4135,2614.3062,58.7880), PPSetPlayerFacingAngle(playerid,271.4945);
        SetCameraBehindPlayer(playerid);
        return true;
    }

    return false;
}

// Обновляем лейблы входов для получения подарков
stock UpdateLabelVillageGift()
{
    new string[200];
    if(VillageInfo[villGiftStatus] == true)
    {
        format(string,sizeof(string),"{EE8B59}Хранилище Деревенских\
                \n{99ff66}Призы доступны для получения\
                \n\n{cccccc}Войти ALT");
    }
    else
    {
        if(VillageInfo[villCD] > 0) format(string,sizeof(string),"{EE8B59}Хранилище Деревенских\n{666666}Хранилище будет доступно через %s", fine_time(VillageInfo[villCD]));
        else format(string,sizeof(string),"{EE8B59}Хранилище Деревенских\n{99ff66}В хранилище что-то есть\n\n{666666}Устраните всех деревенских, чтобы забрать их вещи");
    }

	UpdateDynamic3DTextLabelText(VillageInfo[villEnterLabel][0],0xA9C4E4FF,string);
    UpdateDynamic3DTextLabelText(VillageInfo[villEnterLabel][1],0xA9C4E4FF,string);
    return true;
}

stock SetVillageNpcRandomWeapons(i)
{
    SetNpcWeapon(VillageInfo[villID][i], WEAPON:VillageRandomWeapons[random(sizeof(VillageRandomWeapons))]);
    return true;
}

stock SpawnVillageNpc(i)
{
    VillageInfo[villRespawn][i] = 0;
    VillageInfo[villAttackPlayerid][i] = INVALID_PLAYER_ID;

    SetNpcPosition(VillageInfo[villID][i], VillageNpcWalk[i][WalkStart_X], VillageNpcWalk[i][WalkStart_Y], VillageNpcWalk[i][WalkStart_Z]);
    GoVilliageNpc(i, 0, NPC_MOVE_MODE_WALK);

    if(VillageInfo[villActive] == false) SetNpcWeapon(VillageInfo[villID][i], WEAPON_FIST);
    else SetVillageNpcRandomWeapons(i);

    SetVillageHealthNpc(i);
    return true;
}

// Ставим хп ботам деревенским
stock SetVillageHealthNpc(i)
{
    if(IsShootingWeapon(GetNpcWeapon(VillageInfo[villID][i]))) SetNpcHealth(VillageInfo[villID][i], 200.0);
    else SetNpcHealth(VillageInfo[villID][i], 400.0);
    return true;
}

stock GoVilliageNpc(i, destination, NPC_MOVE_MODE:MOVE_MODE)
{
    VillageInfo[villDestination][i] = destination;
    if(destination == 0)
    {
        TaskNpcGoToPoint(VillageInfo[villID][i], VillageNpcWalk[i][WalkStop_X], VillageNpcWalk[i][WalkStop_Y], VillageNpcWalk[i][WalkStop_Z], MOVE_MODE);
    }
    else if(destination == 1)
    {
        TaskNpcGoToPoint(VillageInfo[villID][i], VillageNpcWalk[i][WalkStart_X], VillageNpcWalk[i][WalkStart_Y], VillageNpcWalk[i][WalkStart_Z], MOVE_MODE);
    }
    return true;
}

alias:spawnvillage("racvillage", "respawnvillage")
CMD:spawnvillage(playerid)
{
    if(PlayerInfo[playerid][pSoska] <= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    for(new i = 0; i < sizeof(VillageNpcWalk); i++) SpawnVillageNpc(i);
    VillageInfo[villActive] = false;
    VillageInfo[villGiftStatus] = false;
    VillageInfo[villCDShowGift] = 0;
    UpdateLabelVillageGift();
    return true;
}

// NPC умер, респавним его через скока то секунд
stock RevivalVillageNpc(i)
{
    VillageInfo[villRespawn][i] = RESPAWN_VILLAGE_NPC;
    return true;
}

// Таймер деревенских NPC и обработка их действий
stock ProcessVillageNpc()
{
    // Процесс кд, через которое будут доступны подарки
    if(VillageInfo[villCD] > 0)
    {
        VillageInfo[villCD] --;
        if(VillageInfo[villCD] <= 0) UpdateLabelVillageGift();
    }

    // Кд, через которое все боты вернутся после победы над ними
    if(VillageInfo[villCDShowGift] > 0)
    {
        VillageInfo[villCDShowGift] --;
        if(VillageInfo[villCDShowGift] <= 0) 
        {
            VillageInfo[villActive] = false;
            VillageInfo[villGiftStatus] = false;
            UpdateLabelVillageGift();
        }
    }

    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        // Респавн NPC
        if(VillageInfo[villRespawn][i] > 0)
        {
            VillageInfo[villRespawn][i] --;
            if(VillageInfo[villRespawn][i] <= 0) SpawnVillageNpc(i);
        }

        // Боты постоянно ищут ближайшего игрока для атаки
        if(VillageInfo[villActive] == true
            && !IsNpcDead(VillageInfo[villID][i])) AttackVillageNpcNearbyPlayer(i);

        // Бот гуляет по городу туды сюды
        if(VillageInfo[villActive] == false
            && !IsNpcDead(VillageInfo[villID][i])) WalkingVillageNpc(i);
    }
    return true;
}

// Запускаем прогулку игрока
stock WalkingVillageNpc(i)
{
    if(VillageInfo[villDestination][i] != 0)
    {
        new Float:distance = GetDistanceNpcPoint(VillageInfo[villID][i], VillageNpcWalk[i][WalkStart_X], VillageNpcWalk[i][WalkStart_Y], VillageNpcWalk[i][WalkStart_Z]);
        if(distance <= 2) return GoVilliageNpc(i, 0, NPC_MOVE_MODE_WALK);
    }

    if(VillageInfo[villDestination][i] != 1)
    {
        new Float:distance2 = GetDistanceNpcPoint(VillageInfo[villID][i], VillageNpcWalk[i][WalkStop_X], VillageNpcWalk[i][WalkStop_Y], VillageNpcWalk[i][WalkStop_Z]);
        if(distance2 <= 2) return GoVilliageNpc(i, 1, NPC_MOVE_MODE_WALK);
    }
    return true;
}

stock GiveDamagePlayerToVillageNpc(NPC:npc, damagerid)
{
    if(VillageInfo[villActive] == false)
    {
        new bool:goAttack;
        for(new i = 0; i < sizeof(VillageNpcWalk); i++)
        {
            if(VillageInfo[villID][i] == npc)
            {
                goAttack = true;
                break;
            }
        }

        // Запускаем атаку на игрока
        if(goAttack == true)
        {
            for(new i = 0; i < sizeof(VillageNpcWalk); i++)
            {
                Village_TaskNpcAttackPlayer(VillageInfo[villID][i], damagerid, i);
                SetVillageNpcRandomWeapons(i);
            }
        }

        VillageInfo[villActive] = true;
    }
    return true;
}

stock SetSpawnVillageNpc(NPC:npc)
{
    new quanVillageNpcDeath;
    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        if(IsNpcDead(VillageInfo[villID][i])) quanVillageNpcDeath ++; // Считаем дохлых NPC

        if(VillageInfo[villID][i] == npc) RevivalVillageNpc(i);
    }

    if(server == 0) SendClientMessageToAll(-1, "Количество дохлых NPC %d", quanVillageNpcDeath);

    // Все NPC умерли, открываем призы
    if(quanVillageNpcDeath >= sizeof(VillageNpcWalk)) CreateVillageGift();
    return true;
}

// Открываем призы и создаём всю фигню
stock CreateVillageGift()
{
    foreach (VillagePlayer, playerid) 
    {
        if(!IsPlayerNotTargetForVillage(playerid)) MessageVillageWin(playerid);
    }

    // Запускаем подарки
    if(VillageInfo[villCD] <= 0)
    {
        VillageInfo[villGiftStatus] = true;
        UpdateLabelVillageGift();
        VillageInfo[villCDShowGift] = SECOND_FOR_BACK_VILLAGE;
        for(new i = 0; i < sizeof(VillageNpcWalk); i++) VillageInfo[villRespawn][i] = SECOND_FOR_BACK_VILLAGE;
        VillageInfo[villCD] = CD_GIFT_VILLAGE;

        for(new i = 0; i < MAX_CASE_VILLAGE; i++)
        {
            new thingId, thingQuan, thingType, thingPara, thingPack;
			CreateCasePlayer(INVALID_PLAYER_ID, thingId, thingQuan, thingType, thingPara, thingPack);

            SetThrow(-1, thingId, thingId, thingQuan, thingPara, 0, thingType, thingPack, 0,0, -1481.3367 + random(5),2627.9875 + random(5), 57.771343, 0.0, 0.0, 0.0 + random(90), 600, 0, 0, 0);
        }
    }
    return true;
}

// Сообщение о завершении битвы
stock MessageVillageWin(playerid)
{
    new lines[210];
    if(VillageInfo[villCD] > 0)
    {
        format(lines,sizeof(lines),"{EE8B59}Все деревенские были убиты!\
	                            \n{cccccc}- Однако, вы не можете забрать призы, потому что их нет на месте\
	                            \n{cccccc}- Призы доступны для получения 1 раз в %d минут\
                                \n{EE8B59}- Осталось времени для повторного получения призов: %s", CD_GIFT_VILLAGE / 60, fine_time(VillageInfo[villCD]));
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
    }
    else
    {
        format(lines,sizeof(lines),"{EE8B59}Все деревенские были убиты!\
	                            \n{cccccc}- Теперь вы можете забрать их вещи [ Отмечено GPS меткой ]\
	                            \n{cccccc}- У вас есть %d минут на то, чтобы забрать призы", SECOND_FOR_BACK_VILLAGE / 60);
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
        CreateGps(playerid,-1483.2771,2644.1699,58.7281, 0, 0, 2.0);
    }
    PlayerPlaySound(playerid,6401,0,0,0);
    return 1;
}

// NPC начинает атаковать ближайшего игрока
stock AttackVillageNpcNearbyPlayer(i)
{
    new latestid = FindClosestPlayerToVillageNpc(VillageInfo[villID][i], i);

    // Нашли нового игрока, атакуем
    if(latestid != NOT_FIND_ATTACK_PLAYER 
        && latestid != INVALID_PLAYER_ID) 
    {
        Village_TaskNpcAttackPlayer(VillageInfo[villID][i], latestid, i);
        if(server == 0) SendClientMessageToAll(-1, "бот %d атакует игрока %d", _:VillageInfo[villID][i], latestid);
    }

    else if(latestid == INVALID_PLAYER_ID) // Не нашли игрока для атаки
    {
        if(VillageInfo[villAttackPlayerid][i] != INVALID_PLAYER_ID) // До этого атаковали
        {
            if(server == 0) SendClientMessageToAll(-1, "Бот %d возвращается на позицию", _:VillageInfo[villID][i]);

            // Если в деревне не осталось игроков
            if(GetQuanPlayerInVillage() <= 0)
            {
                VillageInfo[villActive] = false;
                if(server == 0) SendClientMessageToAll(-1, "Режим битвы в деревне выключен");
                ChillVillageNpc();
                return true;
            }

            VillageInfo[villAttackPlayerid][i] = INVALID_PLAYER_ID;
            GoVilliageNpc(i, 1, NPC_MOVE_MODE_RUN);
        }
    }
    return true;
}

// Говорим боту просто гулять
stock ChillVillageNpc()
{
    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        if(!IsNpcDead(VillageInfo[villID][i]))
        {
            SetNpcWeapon(VillageInfo[villID][i], WEAPON_FIST);
            VillageInfo[villAttackPlayerid][i] = INVALID_PLAYER_ID;
            GoVilliageNpc(i, 1, NPC_MOVE_MODE_RUN);
            SetVillageHealthNpc(i);
        }
    }
    return true;
}

stock Village_TaskNpcAttackPlayer(NPC:npc, playerid, i)
{
    TaskNpcAttackPlayer(npc, playerid);
    VillageInfo[villAttackPlayerid][i] = playerid;
    return true;
}

// Игрок, который не является целью для ботов деревенских
stock IsPlayerNotTargetForVillage(playerid)
{
    if(IsPlayerAfk(playerid)
            || !IsPlayerInDynamicArea(playerid, VillageInfo[villZone])
            || DeathInfo[playerid][deathStatus] == true
            || HealthAC[playerid] <= 0.0
            || !IsPlayerSyncModels(playerid)) return true;
    return false;
}

// Получаем количество игроков в деревне, которые доступны для атаки ботами
stock GetQuanPlayerInVillage()
{
    new quan;
    foreach (VillagePlayer, playerid) 
    {
        if(!IsPlayerNotTargetForVillage(playerid)) quan ++;
    }
    return quan;
}

stock FindClosestPlayerToVillageNpc(NPC:npc, i) 
{
    new Float:npc_x, Float:npc_y, Float:npc_z;
    GetNpcPosition(npc, npc_x, npc_y, npc_z);

    new Float:dist = 99999.0;
    new latestId = INVALID_PLAYER_ID;
    foreach (VillagePlayer, playerid) 
    {
        if(IsPlayerNotTargetForVillage(playerid)) continue;

        new Float:thisDist = GetPlayerDistanceFromPoint(playerid, npc_x, npc_y, npc_z);
        if (thisDist < dist) 
        {
            dist = thisDist;
            latestId = playerid;
        }
    }

    // Если бот уже атакует этого игрока, игнорим нафиг
    if(VillageInfo[villAttackPlayerid][i] == latestId 
        && latestId != INVALID_PLAYER_ID) return NOT_FIND_ATTACK_PLAYER;

    return latestId;
}

// Игрок зашёл в деревню
stock PlayerEnterVillage(playerid)
{
    Iter_Add(VillagePlayer, playerid);
    return true;
}

// Игрок вышел из деревни
stock PlayerExitVillage(playerid)
{
    Iter_Remove(VillagePlayer, playerid);
    return true;
}

// Нанесли урон NPC
public bool:OnPlayerGiveDamageNpc(NPC:npc, damagerid, Float:amount, weaponid, bodypart)
{
    GiveDamagePlayerToVillageNpc(npc, damagerid);
    return true;
}

// NPC нанёс урон игроку
public OnPlayerTakeDamageNpc(NPC:npc, issuerid, Float:amount, weaponid, bodypart)
{

    return true;
}

// NPC убили
public OnNpcDeath(NPC:npc, killerid, reason)
{
    SetSpawnVillageNpc(npc);
    return true;
}

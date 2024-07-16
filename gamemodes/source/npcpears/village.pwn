
#define NOT_FIND_ATTACK_PLAYER 9000

new Iterator:VillagePlayer<MAX_PLAYERS>;

enum VILLAGENPCWALK { SkinID, Float:WalkStart_X, Float:WalkStart_Y, Float:WalkStart_Z, Float:WalkStop_X, Float:WalkStop_Y, Float:WalkStop_Z }
new VillageNpcWalk[][VILLAGENPCWALK] =
{
	{ 132, -1563.2344,2677.7383,55.6835, -1563.2062,2697.9192,55.8183},
	{ 134, -1506.4155,2663.7102,55.8360, -1535.9773,2664.2480,55.8360},
	{ 158, -1553.6833,2662.3206,55.8403, -1553.4933,2600.9385,55.8360},
    { 159, -1518.4160,2678.9146,55.8360, -1551.8831,2678.6255,55.8360},
    { 160, -1538.3955,2659.9458,55.8360, -1538.3961,2613.3933,55.8360}
};

new VillageRandomWeapons[] = { 4, 6, 9, 9, 25, 26, 30, 30, 30, 30 };
new VillageRandomSkins[] = { 132, 134, 158, 159, 160, 161, 162 };


enum VILLAGEINFO
{
	NPC:villID[sizeof(VillageNpcWalk)],
    bool:villActive,
    villRespawn[sizeof(VillageNpcWalk)],
    villZone,
    villAttackPlayerid[sizeof(VillageNpcWalk)],
    villDestination[sizeof(VillageNpcWalk)]
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

stock CreateVillageNpc()
{
    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        VillageInfo[villID][i] = CreateNpc(VillageRandomSkins[random(sizeof(VillageRandomSkins))], VillageNpcWalk[i][WalkStart_X], VillageNpcWalk[i][WalkStart_Y], VillageNpcWalk[i][WalkStart_Z]);
        SpawnVillageNpc(i);
    }

    VillageInfo[villZone] = CreateDynamicSphere(-1490.1393,2608.5479,55.6808, 120.0, 0, 0);
    return true;
}

stock SetVillageNpcRandomWeapons(i)
{
    SetNpcWeapon(VillageInfo[villID][i], WEAPON:VillageRandomWeapons[random(sizeof(VillageRandomWeapons))]);
    return true;
}

stock SpawnVillageNpc(i)
{
    VillageInfo[villAttackPlayerid][i] = INVALID_PLAYER_ID;

    SetNpcPosition(VillageInfo[villID][i], VillageNpcWalk[i][WalkStart_X], VillageNpcWalk[i][WalkStart_Y], VillageNpcWalk[i][WalkStart_Z]);
    GoVilliageNpc(i, 0, NPC_MOVE_MODE_WALK);
    
    if(GetNpcSkin(VillageInfo[villID][i]) == 162) SetNpcHealth(VillageInfo[villID][i], 300.0);
    else SetNpcHealth(VillageInfo[villID][i], 200.0);

    if(VillageInfo[villActive] == false) SetNpcWeapon(VillageInfo[villID][i], WEAPON_FIST);
    else SetVillageNpcRandomWeapons(i);
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
    return true;
}

// NPC умер, респавним его через скока то секунд
stock RevivalVillageNpc(i)
{
    VillageInfo[villRespawn][i] = 20;
    return true;
}

// Таймер деревенских NPC и обработка их действий
stock ProcessVillageNpc()
{
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
    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        if(VillageInfo[villID][i] == npc)
        {
            RevivalVillageNpc(i);
            break;
        }
    }
    return true;
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
            if(Iter_Count(VillagePlayer) <= 0)
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

stock FindClosestPlayerToVillageNpc(NPC:npc, i) 
{
    new Float:npc_x, Float:npc_y, Float:npc_z;
    GetNpcPosition(npc, npc_x, npc_y, npc_z);

    new Float:dist = 99999.0;
    new latestId = INVALID_PLAYER_ID;
    foreach (VillagePlayer, playerid) 
    {
        if(IsPlayerAfk(playerid)
            || !IsPlayerInDynamicArea(playerid, VillageInfo[villZone])
            || DeathInfo[playerid][deathStatus] == true
            || HealthAC[playerid] <= 0.0) continue;

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

enum JASONINFO
{
	NPC:jasonID,
    bool:jasonCreate,
    Float:jasonPos[3],
    jasonCreateTimer,
    jasonAttackPlayer, 
    jasonDestroyTimer,
    jasonObjectEffect,
    jasonAbilityTimer,
    jasonAbilityObject,
    Float:jasonHealth,
    NPC:jasonAnimals[4]
}
new JasonInfo[MAX_WILD_ANIMALS_ZONE][JASONINFO];
new UnixZoneCreatedJason[MAX_WILD_ANIMALS_ZONE];

stock GoCreateJason(playerid,zone)
{
    if(UnixZoneCreatedJason[zone]+1800 > gettime() || JasonInfo[zone][jasonCreateTimer] > 0) return false;
    JasonInfo[zone][jasonCreateTimer] = random(60);
    JasonInfo[zone][jasonAttackPlayer] = playerid;
    return true;
}

stock CreateJason(playerid)
{
    new zone = IsPlayerInWildZone(playerid);
    if(zone == -1) return false;
    
    if(UnixZoneCreatedJason[zone]+1800 > gettime()) return false;
    if(JasonInfo[zone][jasonCreate] == true) return false;

    new Float:PosX, Float:PosY, Float:PosZ;
    GetPlayerPos(playerid,PosX,PosY,PosZ);
    new Float:tempX = 50-random(50),Float:tempY = 10-random(50);
    PosX += tempX, PosY += tempY;
    CA_FindZ_For2DCoord(PosX,PosY,PosZ);
    PosZ += 1.5;


    JasonInfo[zone][jasonID] = CreateNpc(15617, PosX, PosY, PosZ);
    JasonInfo[zone][jasonCreate] = true;

    SetNpcWeapon(JasonInfo[zone][jasonID], WEAPON_CHAINSAW);
    SetNpcHealth(JasonInfo[zone][jasonID], 6000);
    SetNpcVirtualWorld(JasonInfo[zone][jasonID], 0);
    SetNpcStunAnimationEnabled(JasonInfo[zone][jasonID], false);

    JasonInfo[zone][jasonAttackPlayer] = playerid;
    UnixZoneCreatedJason[zone] = gettime();
    JasonInfo[zone][jasonAbilityTimer] = 120;

    JasonInfo[zone][jasonPos][0] = PosX;
    JasonInfo[zone][jasonPos][1] = PosY;
    JasonInfo[zone][jasonPos][2] = PosZ;

    if(server == 0) SendClientMessageToAll(-1, "Джейсон создан для %s", PlayerInfo[playerid][pName]);
    return true;
}


stock StartDestroyJason(i)
{
    if(JasonInfo[i][jasonDestroyTimer] > 0) return false;
    if(!IsNpcDead(JasonInfo[i][jasonID])) TaskNpcStandStill(JasonInfo[i][jasonID]);

    new Float:npc_pos[3];
    GetNpcPosition(JasonInfo[i][jasonID], npc_pos[0], npc_pos[1], npc_pos[2]);
    JasonInfo[i][jasonObjectEffect] = CreateDynamicObject(18715, npc_pos[0], npc_pos[1], npc_pos[2] -1.5, 0.0, 0.0, 0.0, 0, 0, -1, 80.0, 80.0);
    JasonInfo[i][jasonDestroyTimer] = 2;

    StreamerUpdateNearby(50.0, npc_pos[0], npc_pos[1], npc_pos[2], 0, 0, STREAMER_TYPE_OBJECT);
    return true;
}

stock DestroyJason(i)
{
    if(JasonInfo[i][jasonCreate] == false) return false;
    
    if(IsValidNpc(JasonInfo[i][jasonID]))
    {
        DestroyNpc(JasonInfo[i][jasonID]);
        JasonInfo[i][jasonCreate] = false;
    }

    if(JasonInfo[i][jasonObjectEffect] != 0) DestroyDynamicObject(JasonInfo[i][jasonObjectEffect]),JasonInfo[i][jasonObjectEffect] = 0;
    if(JasonInfo[i][jasonAbilityObject] != 0) DestroyDynamicObject(JasonInfo[i][jasonAbilityObject]),JasonInfo[i][jasonAbilityObject] = 0;
    
    for(new n; n < 4; n++)
    {
        if(IsValidNpc(JasonInfo[i][jasonAnimals][n])) DestroyNpc(JasonInfo[i][jasonAnimals][n]);
    }

    JasonInfo[i][jasonDestroyTimer] = 0;
    JasonInfo[i][jasonID] = NPC: 0;
    return true;
}

stock JasonAbility(i)
{
    if(JasonInfo[i][jasonCreate] == false) return false;
    if(IsValidNpc(JasonInfo[i][jasonID]))
    {
        new Float:npc_x, Float:npc_y, Float:npc_z;
        GetNpcPosition(JasonInfo[i][jasonID], npc_x, npc_y, npc_z);
        GetNpcHealth(JasonInfo[i][jasonID], JasonInfo[i][jasonHealth]);
        DestroyNpc(JasonInfo[i][jasonID]), JasonInfo[i][jasonID] = INVALID_NPC;
        for(new n; n < 4; n++)
        {
            if(IsValidNpc(JasonInfo[i][jasonAnimals][n])) DestroyNpc(JasonInfo[i][jasonAnimals][n]);
            JasonInfo[i][jasonAnimals][n] = CreateNpc(15797, npc_x+n, npc_y, npc_z);
            SetNpcHealth(JasonInfo[i][jasonAnimals][n], 100);
            SetNpcStunAnimationEnabled(JasonInfo[i][jasonAnimals][n], false);
            TaskNpcAttackPlayer(JasonInfo[i][jasonAnimals][n],JasonInfo[i][jasonAttackPlayer], .aggressive = true);
        }
    }
    else
    {
        new Float:PosX, Float:PosY, Float:PosZ, Float:a;
        if(JasonInfo[i][jasonAttackPlayer] != INVALID_PLAYER_ID) frontme(JasonInfo[i][jasonAttackPlayer], 1.5, PosX, PosY, PosZ, a);
        else PosX = JasonInfo[i][jasonPos][0],PosY = JasonInfo[i][jasonPos][1],PosZ = JasonInfo[i][jasonPos][2];
        JasonInfo[i][jasonID] = CreateNpc(15617, PosX, PosY, PosZ);
        SetNpcWeapon(JasonInfo[i][jasonID], WEAPON_CHAINSAW);
        SetNpcHealth(JasonInfo[i][jasonID], JasonInfo[i][jasonHealth]);
        SetNpcStunAnimationEnabled(JasonInfo[i][jasonID], false);
        SetNpcPosition(JasonInfo[i][jasonID],PosX, PosY, PosZ);
        SetNpcFacingAngle(JasonInfo[i][jasonID], a-180);
        JasonInfo[i][jasonAbilityTimer] = 120;
        for(new n; n < 4; n++)
        {
            if(IsValidNpc(JasonInfo[i][jasonAnimals][n])) DestroyNpc(JasonInfo[i][jasonAnimals][n]);
        }
    }
    return true;
}

stock LifeJason()
{
    for(new i = 0; i < MAX_WILD_ANIMALS_ZONE; i++)
    {
        if(JasonInfo[i][jasonCreate] == true)
        {
            if(JasonInfo[i][jasonDestroyTimer] > 0)
            {
                JasonInfo[i][jasonDestroyTimer] --;
                if(JasonInfo[i][jasonDestroyTimer] <= 0) DestroyJason(i);
            }
            if(JasonInfo[i][jasonAbilityTimer] > 0)
            {
                JasonInfo[i][jasonAbilityTimer] --;
                if(JasonInfo[i][jasonAbilityTimer] < 10 && JasonInfo[i][jasonAbilityObject] == 0)
                {
                    new Float:npc_x, Float:npc_y, Float:npc_z;
                    GetNpcPosition(JasonInfo[i][jasonID], npc_x, npc_y, npc_z);
                    JasonInfo[i][jasonAbilityObject] = CreateDynamicObject(18714, npc_x, npc_y, npc_z -1.5, 0.0, 0.0, 0.0, 0,0, -1, 80.0, 80.0);
                    JasonAbility(i);
                }
                if(JasonInfo[i][jasonAbilityTimer] <= 0 && JasonInfo[i][jasonAbilityObject] != 0) 
                {
                    DestroyDynamicObject(JasonInfo[i][jasonAbilityObject]);
                    JasonInfo[i][jasonAbilityObject] = 0;
                    JasonAbility(i);
                }
            }
            if(JasonInfo[i][jasonAttackPlayer] == INVALID_PLAYER_ID)
            {
                if(!IsNpcInRangeOfPoint(JasonInfo[i][jasonID], 200.0, JasonInfo[i][jasonPos][0], JasonInfo[i][jasonPos][1], JasonInfo[i][jasonPos][2]))
                {
                    StartDestroyJason(i);
                }

                if(!IsNpcDead(JasonInfo[i][jasonID]))
                {
                    JasonAttactNearPlayer(i);
                }
            }
            else
            {
                new Float:PosX, Float:PosY, Float:PosZ;
                GetPlayerPos(JasonInfo[i][jasonAttackPlayer],PosX,PosY,PosZ);
                if(IsNpcInRangeOfPoint(JasonInfo[i][jasonID], 10.0,PosX, PosY, PosZ)) TaskNpcAttackPlayer(JasonInfo[i][jasonID], JasonInfo[i][jasonAttackPlayer], true);
                else TaskNpcAttackPlayer(JasonInfo[i][jasonID], JasonInfo[i][jasonAttackPlayer], false);
            }
        }
        else if(JasonInfo[i][jasonCreateTimer] > 0)
        {
            JasonInfo[i][jasonCreateTimer]--;
            if(JasonInfo[i][jasonCreateTimer] <= 0 && JasonInfo[i][jasonAttackPlayer] != INVALID_PLAYER_ID) CreateJason(JasonInfo[i][jasonAttackPlayer]);
        }
    }
    return true;
}

stock JasonFindTargetForAttac(NPC:npc, i)
{
    new Float:npc_x, Float:npc_y, Float:npc_z;
    GetNpcPosition(npc, npc_x, npc_y, npc_z);

    new Float:dist = 99999.0;
    new latestId = INVALID_PLAYER_ID;
    foreach(Player, playerid) 
    {
        if(IsPlayerNotTarget(playerid, .excludeAFK = true) 
            || GetPlayerVirtualWorld(playerid) != GetNpcVirtualWorld(npc)
            || GetPlayerInterior(playerid) != 0) continue;

        new Float:thisDist = GetPlayerDistanceFromPoint(playerid, npc_x, npc_y, npc_z);
        if (thisDist < dist)
        {
            dist = thisDist;
            latestId = playerid;
        }
    }
    if (dist > 150.0) return INVALID_PLAYER_ID;

    if(JasonInfo[i][jasonAttackPlayer] == latestId 
        && latestId != INVALID_PLAYER_ID) return NOT_FIND_ATTACK_PLAYER;

    return latestId;
}

stock JasonAttactNearPlayer(i)
{
    new latestid = JasonFindTargetForAttac(JasonInfo[i][jasonID], i);

    if(latestid != NOT_FIND_ATTACK_PLAYER 
        && latestid != INVALID_PLAYER_ID) 
    {
        Jason_TaskNpcAttackPlayer(JasonInfo[i][jasonID], latestid, i);
        if(server == 0) SendClientMessageToAll(-1, "Джейсон %d атакует игрока %d", i, latestid);
    }

    else if(latestid == INVALID_PLAYER_ID)
    {
        StartDestroyJason(i);
        if(server == 0) SendClientMessageToAll(-1, "Джейсон %d не нашёл цель в своей зоне и был удалён", i);
    }
    return true;
}

stock Jason_TaskNpcAttackPlayer(NPC:npc, playerid, i)
{
    TaskNpcAttackPlayer(npc, playerid, .aggressive = true);
    JasonInfo[i][jasonAttackPlayer] = playerid;
    return true;
}

stock OnDeathJasonNpc(NPC:npc, playerid)
{
    new findSlot, bool:yesDeathJason;
    for(new i = 0; i < MAX_WILD_ANIMALS_ZONE; i++)
    {
        if(JasonInfo[i][jasonID] == npc)
        {
            yesDeathJason = true;
            findSlot = i;
            break;
        }
    }

    if(yesDeathJason == true)
    {
        new Float:npc_pos[3];
        GetNpcPosition(JasonInfo[findSlot][jasonID], npc_pos[0], npc_pos[1], npc_pos[2]);

        SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ Мысли ]: Жэсть, я завалил этого чекнутого, и кажется с него что-то выпало...");

        new thingId, thingQuan, thingType, thingPara, thingPack;
        CreateCasePlayer(playerid, thingId, thingQuan, thingType, thingPara, thingPack, "maniac");
        CalculateVehicleLimited(thingId, thingType);

        SetThrow(-1, thingId, thingId, thingQuan, thingPara, 0, thingType, thingPack, 0, 0, npc_pos[0] + random(2), npc_pos[1] + random(2), npc_pos[2] - 1.0, 0.0, 0.0, 0.0 + random(90), 600, 0, 0, 0);
        SetThrow(-1, 234, 234, 1, 0, 0, 0, 0, 0, 0, npc_pos[0] + random(2), npc_pos[1] + random(2), npc_pos[2] - 1.0, 0.0, 0.0, 0.0 + random(90), 600, 0, 0, 0);

        StartDestroyJason(findSlot);
    }
    return yesDeathJason;
}
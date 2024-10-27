#define PENNVIZE_HEALTH 10000
#define MAX_PENNIVIZE_NPC 100 
#define HALLOWEEN_BATTLE_MUSIC "https://cdn.pears.fun/sound/characters/pennywise/pennylaugh1.mp3"

enum PENNIVIZEINFO
{
	NPC:penID, // ID бота
    bool:penCreate, // Статус, создан маньяк или нет
    penAttack, // Маньяк атакует игрока
    penInterior, // Интерьер маньяка
    penPlayer, // Для какого игрока изначально был создан маньяк
    WEAPON:penWeapon, // Оружие пеннивайза в руке
    penUnixDamage, // Записываем как долго пеннивайз не нанес не по кому урона(для тпшки за спину)
    penUnixFormCD, // пере 
    Float:penHealth, // Записываем хп для проворота приколов.
    bool:penEvent[10], // Тумблер
    NPC:penEventNPC[4],
    penObject, // Объект с эффектом.
    penTimer, // Таймер для объекта
    penWorld, // 
    Float:penDamage[4] // Сколько дамага по маньяку наносил игрок, для которого был создан маньяк
}
new PennivizeInfo[MAX_PENNIVIZE_NPC][PENNIVIZEINFO];
new AudioStream:PennivizeMusic[MAX_PENNIVIZE_NPC] = { INVALID_AUDIOSTREAM, ... };

enum HalloweenNPCEventSpawnPoint { Float:HNPC_X, Float:HNPC_Y, Float:HNPC_Z  }
new Float:Halloween_NPCEventSpawn[4][HalloweenNPCEventSpawnPoint] =
{
    {-1237.8530,-243.8369,14.3347},
    {-1212.8147,-243.9519,14.7099},
    {-1237.9161,-197.0595,14.3083},
    {-1213.5718,-198.1165,14.5717}
};

enum Halloween_SpawnPositionPlayer { Float:PlayerX, Float:PlayerY, Float:PlayerZ  }
new Float:Halloween_SpawnPlayer[4][Halloween_SpawnPositionPlayer] =
{
    {863.9883,-28.8219,63.1953},
    {868.7416,-29.7015,63.1953},
    {873.2904,-31.6471,63.1953},
    {877.3041,-33.4152,63.1900}
};

CMD:createpenis(playerid)
{
    if(PlayerInfo[playerid][pSoska] <= 20) return 0;
    if(LobbyInfo[playerid][lobbyLeader] == -1) return 0;
    GoPennivizeBattle(playerid);
    return 1;
}

stock GoPennivizeBattle(playerid)
{
    new result = -1;
    for(new i; i < MAX_PENNIVIZE_NPC; i++)
    {
        if(PennivizeInfo[i][penCreate]) continue;
        else {
            result = i;
            break;
        }
    }
    if(result == -1) return 0;
    CreatePennivize(playerid, result, result+3000);

    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        S_SetPlayerVirtualWorld(LobbyInfo[playerid][lobbySatellite][l],result+3000, INT_HALLOWEEN_QUEST_2);
        PPSetPlayerInterior(LobbyInfo[playerid][lobbySatellite][l], INT_HALLOWEEN_QUEST_2);
        PPSetPlayerPos(LobbyInfo[playerid][lobbySatellite][l], -1237.6818 +5.0*l,-245.0869,14.3373);
    }
    return 1;
}

stock CreatePennivize(playerid, i, world)
{
    if(PennivizeInfo[i][penCreate] == true) return false;
    PennivizeInfo[i][penWeapon] = WEAPON_FIST;
    PennivizeInfo[i][penID] = CreateNpc(15699, -1227.3533,-215.5105,14.4543);
    PennivizeInfo[i][penCreate] = true;
    PennivizeInfo[i][penHealth] = PENNVIZE_HEALTH;
    PennivizeInfo[i][penUnixDamage] = gettime();
    PennivizeInfo[i][penWorld] = world;
    SetNpcWeapon(PennivizeInfo[i][penID], PennivizeInfo[i][penWeapon]);
    SetNpcHealth(PennivizeInfo[i][penID], PENNVIZE_HEALTH);
    SetNpcVirtualWorld(PennivizeInfo[i][penID], world);
    PennivizeInfo[i][penPlayer] = playerid;
    for(new p; p < 4; p++)
    {
        PennivizeInfo[i][penDamage][p] = 0;
    }
    for(new n;n < 10; n++)
    {
        PennivizeInfo[i][penEvent][n] = false; 
    }

    Pennivize_TaskNpcAttackPlayer(PennivizeInfo[i][penID], playerid, i);
    SetNpcStunAnimationEnabled(PennivizeInfo[i][penID], false);


    PennivizeInfo[i][penAttack] = playerid;
    PennivizeInfo[i][penPlayer] = playerid;

    // Создаём музыку для маньяка
    PennivizeMusic[i] = CreateAudioStream();
    SetAudioStreamPosition(PennivizeMusic[i], -1227.3533,-215.5105,14.4543);
    SetAudioStreamVirtualWorld(PennivizeMusic[i], world);
    SetAudioStreamAutostreamDist(PennivizeMusic[i], 72.0); // Максимальная дистанция
    SetAudioStreamMinDistance(PennivizeMusic[i], 30.0); // Минимальная дистанция (менее громкость не меняется)
    SetAudioStreamMaxDistance(PennivizeMusic[i], 70.0); // Макимальная дистанция
    SetAudioStreamAutostreamState(PennivizeMusic[i], true); // Врубать музло когда игрок входит в зону стрима
    SetAudioStreamSpatialState(PennivizeMusic[i], true); // 3d звук
    SetAudioStreamUrl(PennivizeMusic[i], MANIAC_MUSIC_0, true);

    // Обновляем зону стрима для всех игроков
    StreamerUpdateNearby(80.0, -1227.3533,-215.5105,14.4543, world, INT_HALLOWEEN_QUEST_2);

    // Записываем данные
    LobbyInfo[playerid][lobbyStatus] = 1;
    LobbyInfo[playerid][lobbyParam] = i;

    PennivizeHudInformation(i);

    if(server == 0) SendClientMessageToAll(-1, "Пеннивайз создан для %s", PlayerInfo[playerid][pName]);
    return true;
}

stock PennivizeHudInformation(i)
{
    new line[80];
    format(line,sizeof(line),"Убейте Пеннивайза\nЕго ХП: %.2f",PennivizeInfo[i][penHealth]);
    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[PennivizeInfo[i][penPlayer]][lobbySatellite][l] != -1) SetPlayerHudTask(LobbyInfo[PennivizeInfo[i][penPlayer]][lobbySatellite][l], "Хэллоуин квест", line);
    }
    return 1;
}

stock Pennivize_TaskNpcAttackPlayer(NPC:npc, playerid, i)
{
    TaskNpcAttackPlayer(npc, playerid, .aggressive = true);
    PennivizeInfo[i][penAttack] = playerid;
    return true;
}

stock AttackPennivizeNpcNearbyPlayer(i)
{
    new latestid = FindClosestPlayerToPennivizeNpc(PennivizeInfo[i][penID], i);

    if(latestid != NOT_FIND_ATTACK_PLAYER 
        && latestid != INVALID_PLAYER_ID) 
    {
        Pennivize_TaskNpcAttackPlayer(PennivizeInfo[i][penID], latestid, i);
    }

    else if(latestid == INVALID_PLAYER_ID)
    {
        DestroyPennivize(i, 0);
    }
    return true;
}

stock PennivizehenchmenCreate(i,WEAPON:weapon, health)
{
    for(new n; n < 4; n++)
    {
        if(IsValidNpc(PennivizeInfo[i][penEventNPC][n])) DestroyNpc(PennivizeInfo[i][penEventNPC][n]);
        PennivizeInfo[i][penEventNPC][n] = CreateNpc(15782, Halloween_NPCEventSpawn[n][HNPC_X],Halloween_NPCEventSpawn[n][HNPC_Y],Halloween_NPCEventSpawn[n][HNPC_Z]);
        SetNpcWeapon(PennivizeInfo[i][penEventNPC][n], weapon);
        SetNpcHealth(PennivizeInfo[i][penEventNPC][n], health);
        SetNpcVirtualWorld(PennivizeInfo[i][penEventNPC][n], GetNpcVirtualWorld(PennivizeInfo[i][penID]));
        SetNpcStunAnimationEnabled(PennivizeInfo[i][penEventNPC][n], false);
        if(LobbyInfo[PennivizeInfo[i][penPlayer]][lobbySatellite][n] != -1) TaskNpcAttackPlayer(PennivizeInfo[i][penEventNPC][n],LobbyInfo[PennivizeInfo[i][penPlayer]][lobbySatellite][n], .aggressive = true);
        else TaskNpcAttackPlayer(PennivizeInfo[i][penEventNPC][n],PennivizeInfo[i][penAttack], .aggressive = true);
    }
    return 1;
}

stock PennivizeCheckLife(playerid)
{
    if(LobbyInfo[playerid][lobbyLeader] == -1) return PennivizeGoBack(playerid, 0,1);
    if(LobbyInfo[playerid][lobbyLeader] != -1)
    {
        for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
        {
            if(LobbyInfo[playerid][lobbySatellite][l] == -1) 
            {
                return PennivizeGoBack(playerid, 1,1);
            }
            else
            {
                if(GetPlayerInterior(LobbyInfo[playerid][lobbySatellite][l]) != INT_HALLOWEEN_QUEST_1 && GetPlayerInterior(LobbyInfo[playerid][lobbySatellite][l]) != INT_HALLOWEEN_QUEST_2) return PennivizeGoBack(playerid, 1,1);
            }
        }
        if(DeathInfo[LobbyInfo[playerid][lobbySatellite][0]][deathStatus] == true && DeathInfo[LobbyInfo[playerid][lobbySatellite][1]][deathStatus] == true
        && DeathInfo[LobbyInfo[playerid][lobbySatellite][2]][deathStatus] == true && DeathInfo[LobbyInfo[playerid][lobbySatellite][3]][deathStatus] == true)  return PennivizeGoBack(playerid, 2,1);
    }
    return 1;
}

stock LifePennivize()
{
    for(new i = 0; i < MAX_MANIAC; i++)
    {
        if(!PennivizeInfo[i][penCreate]) continue;
        PennivizeCheckLife(PennivizeInfo[i][penPlayer]);
        if(PennivizeInfo[i][penID] != NPC:0) GetNpcHealth(PennivizeInfo[i][penID],PennivizeInfo[i][penHealth]), PennivizeHudInformation(i);
        if(PennivizeInfo[i][penWeapon] != WEAPON_MINIGUN) AttackPennivizeNpcNearbyPlayer(i);
        new newtarget = FindClosestPlayerToPennivizeNpc(PennivizeInfo[i][penID],i);
        if(PennivizeInfo[i][penTimer] > 0)
        {
            PennivizeInfo[i][penTimer] --;
            if(PennivizeInfo[i][penTimer] <= 0 && PennivizeInfo[i][penObject] != 0) DestroyDynamicObject(PennivizeInfo[i][penObject]), PennivizeInfo[i][penObject] = 0;
        }
        if(PennivizeInfo[i][penUnixDamage]+10 < gettime() && PennivizeInfo[i][penWeapon] == WEAPON_FIST)
        {
            new Float:x,Float:y,Float:z, Float:a;
            Pennivize_TaskNpcAttackPlayer(PennivizeInfo[i][penID], newtarget,i);
            GetNpcPosition(PennivizeInfo[i][penID], x,y,z);
            if(PennivizeInfo[i][penObject] == 0) 
            {
                PennivizeInfo[i][penObject] = CreateDynamicObject(18714, x, y, z -1.5, 0.0, 0.0, 0.0, PennivizeInfo[i][penWorld],INT_HALLOWEEN_QUEST_2, -1, 80.0, 80.0);
                PennivizeInfo[i][penTimer] = 5;
            }
            backme(newtarget, 0.5, x, y, z, a);
            PennivizeInfo[i][penUnixDamage] = gettime();
            if(OnlineInfo[newtarget][oListenRadioPears] == 0) PlayAudioStreamForPlayer(newtarget, HALLOWEEN_BATTLE_MUSIC);
            SetNpcPosition(PennivizeInfo[i][penID],x,y,z);
            SetNpcFacingAngle(PennivizeInfo[i][penID], a);
        }
        else if(PennivizeInfo[i][penHealth] < 9000.0 && !PennivizeInfo[i][penEvent][0])
        {
            PennivizeInfo[i][penEvent][0] = true;
            PennivizehenchmenCreate(i,WEAPON_COLT45, 50);
        }
        else if(PennivizeInfo[i][penHealth] < 8000.0 && !PennivizeInfo[i][penEvent][1])
        {
            PennivizeInfo[i][penEvent][1] = true;
            PennivizehenchmenCreate(i,WEAPON_RIFLE, 50);
        }
        else if(PennivizeInfo[i][penHealth] < 7000.0 && !PennivizeInfo[i][penEvent][2])
        {
            PennivizeInfo[i][penEvent][2] = true;
            PennivizehenchmenCreate(i,WEAPON_CHAINSAW, 300);
        }
        else if(PennivizeInfo[i][penHealth] < 6000.0 && !PennivizeInfo[i][penEvent][3])
        {
            PennivizeInfo[i][penEvent][3] = true;
            for(new n; n < 4; n++)
            {
                if(IsValidNpc(PennivizeInfo[i][penEventNPC][n])) DestroyNpc(PennivizeInfo[i][penEventNPC][n]);
                PennivizeInfo[i][penEventNPC][n] = CreateNpc(15699, Halloween_NPCEventSpawn[n][HNPC_X],Halloween_NPCEventSpawn[n][HNPC_Y],Halloween_NPCEventSpawn[n][HNPC_Z]);
                PennivizehenchmenCreate(i,WEAPON_DEAGLE, 300);
            }
            for(new l; l < MAX_LOBBY_PLAYER; l++)
            {
                if(LobbyInfo[PennivizeInfo[i][penPlayer]][lobbySatellite][l] != -1) SetPlayerHudTask(LobbyInfo[PennivizeInfo[i][penPlayer]][lobbySatellite][l], "Хэллоуин квест", "Убейте Преспешников");
            }
            new Float:x,Float:y,Float:z;
            GetNpcPosition(PennivizeInfo[i][penID], x,y,z);
            if(PennivizeInfo[i][penObject] == 0)
            {
                PennivizeInfo[i][penObject] = CreateDynamicObject(18714, x, y, z -1.5, 0.0, 0.0, 0.0, PennivizeInfo[i][penWorld],INT_HALLOWEEN_QUEST_2, -1, 80.0, 80.0);
                PennivizeInfo[i][penTimer] = 5;
            }
            DestroyNpc(PennivizeInfo[i][penID]);
            PennivizeInfo[i][penID] = NPC: 0;
        }
        else if(PennivizeInfo[i][penHealth] < 6000.0 && PennivizeInfo[i][penEvent][4] != true)
        {
            new Float:healthEventNPC[4];
            new Float:healthsumm;
            for(new n; n < 4; n++)
            {
                GetNpcHealth(PennivizeInfo[i][penEventNPC][n], healthEventNPC[n]);
                healthsumm += healthEventNPC[n];
            }
            if(healthsumm <= 0)
            {
                PennivizeInfo[i][penEvent][4] = true;
                PennivizeInfo[i][penID] = CreateNpc(15694, -1227.3533,-215.5105,14.4543);
                PennivizeInfo[i][penWeapon] = WEAPON_FIST;
                SetNpcWeapon(PennivizeInfo[i][penID], PennivizeInfo[i][penWeapon]);
                SetNpcHealth(PennivizeInfo[i][penID], PennivizeInfo[i][penHealth]);
                Pennivize_TaskNpcAttackPlayer(PennivizeInfo[i][penID], PennivizeInfo[i][penAttack], i);
                SetNpcStunAnimationEnabled(PennivizeInfo[i][penID], false);
                SetNpcVirtualWorld(PennivizeInfo[i][penID], PennivizeInfo[i][penWorld]);
            }
        }
        else if(PennivizeInfo[i][penHealth] < 2000.0 && !PennivizeInfo[i][penEvent][5])
        {
            PennivizeInfo[i][penEvent][5] = true;
            for(new n; n < 4; n++)
            {
                if(IsValidNpc(PennivizeInfo[i][penEventNPC][n])) DestroyNpc(PennivizeInfo[i][penEventNPC][n]);
                PennivizeInfo[i][penEventNPC][n] = CreateNpc(15699, Halloween_NPCEventSpawn[n][HNPC_X],Halloween_NPCEventSpawn[n][HNPC_Y],Halloween_NPCEventSpawn[n][HNPC_Z]);
                PennivizehenchmenCreate(i,WEAPON_CHAINSAW, 500);
            }
            DestroyNpc(PennivizeInfo[i][penID]);
            PennivizeInfo[i][penID] = NPC: 0;
            PennivizeInfo[i][penID] = CreateNpc(15699, -1227.3533,-215.5105,14.4543);
            PennivizeInfo[i][penWeapon] = WEAPON_FIST;
            SetNpcWeapon(PennivizeInfo[i][penID], PennivizeInfo[i][penWeapon]);
            SetNpcHealth(PennivizeInfo[i][penID], PennivizeInfo[i][penHealth]);
            Pennivize_TaskNpcAttackPlayer(PennivizeInfo[i][penID], PennivizeInfo[i][penAttack], i);
            SetNpcStunAnimationEnabled(PennivizeInfo[i][penID], false);
            SetNpcVirtualWorld(PennivizeInfo[i][penID], PennivizeInfo[i][penWorld]);
        }
        if(PennivizeInfo[i][penHealth] <= 0)
        {
            if(!PlayerInfo[PennivizeInfo[i][penPlayer]][pHalloweenQuestStatus]) PennivizeGoBack(PennivizeInfo[i][penPlayer],5,1);
            else PennivizeGoBack(PennivizeInfo[i][penPlayer],3,1);
            for(new n; n < 4; n++)
            {
                if(IsValidNpc(PennivizeInfo[i][penEventNPC][n])) DestroyNpc(PennivizeInfo[i][penEventNPC][n]);
            }
            
        }
    }
    return 1;
}

stock FindClosestPlayerToPennivizeNpc(NPC:npc, i)
{
    new Float:npc_x, Float:npc_y, Float:npc_z;
    GetNpcPosition(npc, npc_x, npc_y, npc_z);

    new Float:dist = 99999.0;
    new latestId = PennivizeInfo[i][penAttack];
    new prelatestId = INVALID_PLAYER_ID;
    new target = INVALID_PLAYER_ID;

    for(new t; t < MAX_PLAYER_TO_PENNIVIZE; t++) 
    {
        if(LobbyInfo[PennivizeInfo[i][penPlayer]][lobbySatellite][t] == -1) continue;
        target = LobbyInfo[PennivizeInfo[i][penPlayer]][lobbySatellite][t];
        if(IsPlayerNotTarget(target, .excludeAFK = true) 
            || GetPlayerVirtualWorld(target) != GetNpcVirtualWorld(npc)
            || GetPlayerInterior(target) != INT_HALLOWEEN_QUEST_2) continue;

        new Float:thisDist = GetPlayerDistanceFromPoint(target, npc_x, npc_y, npc_z);
        if (thisDist < dist)
        {
            dist = thisDist;
            prelatestId = latestId;
            latestId = target;
        }
    }
    if(PennivizeInfo[i][penAttack] == latestId 
        && latestId != INVALID_PLAYER_ID && PennivizeInfo[i][penUnixDamage]+10 < gettime() && prelatestId != INVALID_PLAYER_ID) return prelatestId;
    // Если бот уже атакует этого игрока отправляем последнего ближайшего
    if(PennivizeInfo[i][penAttack] == latestId 
        && latestId != INVALID_PLAYER_ID) return latestId;
        

    return latestId;
}

stock Pennivize_OnPlayerTakeDamageNpc(NPC:npc, issuerid, Float:amount, weaponid, bodypart)
{
    #pragma unused amount
    #pragma unused weaponid
    #pragma unused bodypart
    
    new pen;
    if(LobbyInfo[issuerid][lobbyLeader] == -1 && OnlineInfo[issuerid][oLobby] != 0) pen = LobbyInfo[OnlineInfo[issuerid][oLobby]-1][lobbyParam];
    new Float:damage = 1.0;
    PennivizeInfo[pen][penUnixDamage] = gettime();
    if(PennivizeInfo[pen][penID] != npc) return 1;
    if(PennivizeInfo[pen][penWeapon] == WEAPON_FIST)
    {
        damage *= 50;
        if(PennivizeInfo[pen][penEvent][4] && !PennivizeInfo[pen][penEvent][5])
        {
            GetNpcHealth(PennivizeInfo[pen][penID],PennivizeInfo[pen][penHealth]);
            PennivizeInfo[pen][penHealth] += 50.0, SetNpcHealth(PennivizeInfo[pen][penID],PennivizeInfo[pen][penHealth]);
        }
        if(PennivizeInfo[pen][penEvent][5]) damage *= 2;
        new Float: health = HealthAC[issuerid] - damage;

        // Устанавливаем HP игроку
        ACSetPlayerHealth(issuerid, health);
        
        return 0;
    }
    return 1;
}

stock DestroyPennivize(i,type)
{
    if(PennivizeInfo[i][penCreate] == false) return false;
    
    // Удаляем npc маньяка
    if(IsValidNpc(PennivizeInfo[i][penID]))
    {
        DestroyNpc(PennivizeInfo[i][penID]);
        PennivizeInfo[i][penID] = NPC: 0;
        PennivizeInfo[i][penCreate] = false;
    }
    else{
        PennivizeInfo[i][penID] = NPC: 0;
        PennivizeInfo[i][penCreate] = false;
    }

    // Удаляем музыку маньяка
    if(PennivizeMusic[i] != INVALID_AUDIOSTREAM)
    {
        DeleteAudioStream(PennivizeMusic[i]);
        PennivizeMusic[i] = INVALID_AUDIOSTREAM;
    }

    if(type) 
    {
        new lobby = PennivizeInfo[i][penPlayer];
        new procent;
        for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
        {
            if(LobbyInfo[lobby][lobbySatellite][l] == -1) continue;
            procent = floatround(PennivizeInfo[i][penDamage][l]/100);
            CountAwardsPennivize(LobbyInfo[lobby][lobbySatellite][l], procent);
            HidePlayerHudTask(LobbyInfo[lobby][lobbySatellite][l]);
        }

        if(server == 0) SendClientMessageToAll(-1, "Пеннивайз был убит");
    }
    PennivizeInfo[i][penID] = NPC: 0;
    return true;
}

stock PennivizeGoBack(playerid, type, typenpc)
{
    if(type == 0) 
    {
        if(typenpc) DestroyPennivize(LobbyInfo[playerid][lobbyParam],0);
        else destroyhqwalker(LobbyInfo[playerid][lobbyParam],0);
        for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
        {
            SendClientMessage(LobbyInfo[playerid][lobbySatellite][l],COLOR_GREY,"[ Мысли ] Битва с Пеннивайзом прервана. Лидер лобби вышел из игры");
        }
    }
    else if(type == 1)
    {
        if(typenpc) DestroyPennivize(LobbyInfo[playerid][lobbyParam],0);
        else destroyhqwalker(LobbyInfo[playerid][lobbyParam],0);
        for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
        {
            SendClientMessage(LobbyInfo[playerid][lobbySatellite][l],COLOR_GREY,"[ Мысли ] Битва с Пеннивайзом прервана. Один из участников лобби вышел из игры/лобби");
        }
    }
    else if(type == 2)
    {
        if(typenpc) DestroyPennivize(LobbyInfo[playerid][lobbyParam],0);
        else destroyhqwalker(LobbyInfo[playerid][lobbyParam],0);
        for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
        {
            SendClientMessage(LobbyInfo[playerid][lobbySatellite][l],COLOR_GREY,"[ Мысли ] Битва с Пеннивайзом прервана. Все участники мертвы");
        }
    }
    else if(type == 3)
    {
        if(typenpc) DestroyPennivize(LobbyInfo[playerid][lobbyParam],1);
    }
    else if(type == 4)
    {
        for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
        {
            SendClientMessage(LobbyInfo[playerid][lobbySatellite][l],COLOR_GREY,"[ Мысли ] Квест прерван, попробуйте позже(возможно нет свободных слов битвы для продолжения)");
        }
    }
    else if(type == 5)
    {
        if(typenpc) DestroyPennivize(LobbyInfo[playerid][lobbyParam],1);
        for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
        {
            if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
            if(DeathInfo[LobbyInfo[playerid][lobbySatellite][l]][deathStatus]) DeathEnd(LobbyInfo[playerid][lobbySatellite][l], 1);
            S_SetPlayerVirtualWorld(LobbyInfo[playerid][lobbySatellite][l],playerid+3000, INT_HALLOWEEN_QUEST_1);
            PPSetPlayerInterior(LobbyInfo[playerid][lobbySatellite][l], INT_HALLOWEEN_QUEST_1);
            FlyCameraPos(LobbyInfo[playerid][lobbySatellite][l], 969.850524, 1162.426635, 11.617245, 973.707092, 1159.378417, 10.703235, 1000, 1200);
            PPSetPlayerPos(LobbyInfo[playerid][lobbySatellite][l], HPCSPos[4+l][PlayerCuteScenePosX],HPCSPos[4+l][PlayerCuteScenePosY],HPCSPos[4+l][PlayerCuteScenePosZ]);
            PPSetPlayerFacingAngle(LobbyInfo[playerid][lobbySatellite][l], HPCSPos[4+l][PlayerCuteScenePosA]);
            ApplyAnimation(LobbyInfo[playerid][lobbySatellite][l],"PED","SEAT_idle",4.0, false, false, false, true, false, SYNC_ALL);
            TogglePlayerControllable(LobbyInfo[playerid][lobbySatellite][l], false);
            HidePlayerHudTask(LobbyInfo[playerid][lobbySatellite][l]);
        }
        HalloweenFiveCuteScene(playerid);
    }
    else if(type == 6)
    {
        for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
        {
            if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
            dialogHalloweenEndQuestInfo(LobbyInfo[playerid][lobbySatellite][l]);
            PlayerInfo[LobbyInfo[playerid][lobbySatellite][l]][pHalloweenQuestStatus] = 1;
            if(l == 0) PlayerInfo[LobbyInfo[playerid][lobbySatellite][l]][pHalloweenQuestUnix] = gettime()+28800;   
            SaveHalloweenPlayer(LobbyInfo[playerid][lobbySatellite][l]);
        }
    }
    if(type != 5)
    {
        for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
        {
            if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
            if(DeathInfo[LobbyInfo[playerid][lobbySatellite][l]][deathStatus]) DeathEnd(LobbyInfo[playerid][lobbySatellite][l], 1);
            S_SetPlayerVirtualWorld(LobbyInfo[playerid][lobbySatellite][l],0, 0);
            PPSetPlayerInterior(LobbyInfo[playerid][lobbySatellite][l], 0);
            PPSetPlayerPos(LobbyInfo[playerid][lobbySatellite][l], Halloween_SpawnPlayer[l][PlayerX],Halloween_SpawnPlayer[l][PlayerY],Halloween_SpawnPlayer[l][PlayerZ]);
            HidePlayerHudTask(LobbyInfo[playerid][lobbySatellite][l]);
            TogglePlayerControllable(LobbyInfo[playerid][lobbySatellite][l], true);
            SetCameraBehindPlayer(LobbyInfo[playerid][lobbySatellite][l]);
        }
    }
    LobbyInfo[playerid][lobbyStatus] = 0;
    LobbyInfo[playerid][lobbyParam] = 0;
    return 1;
}
stock CountAwardsPennivize(playerid, procent)
{
    new count;
    if(procent >= 15 && procent < 25) count = 1;
    else if(procent >= 25 && procent < 35) count = 2;
    else if(procent >= 35 && procent < 45) count = 3;
    else if(procent >= 45) count = 4;

    SendClientMessage(playerid,COLOR_GREY,"[ Мысли ] Я нанес Пеннивайзу %d%% урона и получил %d Хэллуин Кейса", procent,count);
    // Формируем кейс
    for(new i; i < count; i++)
    {
        new thingId, thingQuan, thingType, thingPara, thingPack;
        CreateCasePlayer(playerid, thingId, thingQuan, thingType, thingPara, thingPack, "halloween24");
        GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
    }
    return 1;
}

stock Pennivize_OnPlayerGiveDamageNpc(NPC:npc, damagerid, Float:amount, weaponid, bodypart)
{
    #pragma unused weaponid
    #pragma unused bodypart
    
    if(GiveDamagePlayerToPennivizeNpc(npc, damagerid, amount)) return true;
    return true;
}

// Наносим дамаг по маньяку
stock GiveDamagePlayerToPennivizeNpc(NPC:npc, damagerid,Float:amount)
{
    new findSlot = -1;
    for(new i = 0; i < MAX_PENNIVIZE_NPC; i++)
    {
        if(PennivizeInfo[i][penID] == npc)
        {
            findSlot = i;
            break;
        }
    }

    if(findSlot >= 0)
    {
        new lobby = PennivizeInfo[findSlot][penPlayer];
        if(LobbyInfo[lobby][lobbySatellite][0] == damagerid) PennivizeInfo[findSlot][penDamage][0] += amount;
        else if(damagerid == LobbyInfo[lobby][lobbySatellite][1]) PennivizeInfo[findSlot][penDamage][1] += amount;
        else if(damagerid == LobbyInfo[lobby][lobbySatellite][2]) PennivizeInfo[findSlot][penDamage][2] += amount;
        else if(damagerid == LobbyInfo[lobby][lobbySatellite][3]) PennivizeInfo[findSlot][penDamage][3] += amount;
        return true;
    }
    return false;
}


stock dialogHalloweenEndQuestInfo(playerid)
{
	new lines[300], string[60];
	format(lines,sizeof(lines),"{ff9000}Спасибо за прохождение Хэллуинского квеста!\
                                \n\n{ffcc66}Вы можете так же повторно пройти его. КД на битву равно 8 часам!\
								\n{ffcc66}КД вешается только на лидера лобби, смените лидера и сражайтесь снова!");
	format(string,sizeof(string),"{ff9000}Хэллоуинский Квест");
	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX, string, lines, "*", "");
    PlayerPlaySound(playerid,6401,0,0,0);
	return true;
}
#define MAX_HALLOWEEN_NPC 14
#define MAX_HALLOWEEN_NPC_SLOTS 50
#define MAX_HALLOWEEN_NPC_COUNT MAX_HALLOWEEN_NPC_SLOTS*MAX_HALLOWEEN_NPC
#define MAX_PLAYER_TO_PENNIVIZE 4
#define MAX_CUTESCENE_HALLOWEEN_POS 8

enum HalloweenNPCPoit { Float:HNPC_X, Float:HNPC_Y, Float:HNPC_Z }
new Float:Halloween_NPCWalking[][HalloweenNPCPoit] =
{
   {-1299.4084,-151.0883,14.2207},  // 0 +
   {-1286.8177,-151.0589,14.2028},  // 1
   {-1278.1172,-151.8100,14.2270},  // 2
   {-1278.4182,-179.2654,14.2270},  // 3
   {-1275.4662,-186.1488,14.2207},  // 4
   {-1318.7631,-176.9920,14.2207},  // 5 +
   {-1318.7296,-167.8376,14.2207},  // 6
   {-1312.4248,-168.1068,14.5019},  // 7
   {-1318.6715,-168.3209,14.2207},  // 8
   {-1318.2982,-159.6696,14.2207},  // 9
   {-1277.8182,-165.6967,14.2207},  // 10
   {-1286.3979,-166.0059,14.8769},  // 11
   {-1289.2014,-158.6020,14.8769},  // 12
   {-1299.3573,-158.7003,14.2207},  // 13
   {-1304.0674,-163.2286,14.6894},  // 14
   {-1272.7996,-168.6820,14.2207},  // 15
   {-1280.0029,-185.5280,14.2207},  // 16
   {-1286.0967,-186.8940,14.5787},  // 17
   {-1287.2288,-190.9298,14.2207},  // 18
   {-1288.5310,-181.6484,14.2270},  // 19
   {-1266.2386,-146.7078,14.8769},  // 20
   {-1275.4794,-147.7524,14.2207},  // 21
   {-1277.6742,-159.6899,14.2207},  // 22
   {-1278.1708,-166.1873,14.2207},  // 23
   {-1272.0942,-172.3089,14.2270},  // 24
   {-1288.7227,-159.1669,14.8769},  // 25
   {-1299.2129,-158.5847,14.2207},  // 26
   {-1313.0850,-160.3189,14.2207},  // 27
   {-1319.3209,-167.2127,14.2207},  // 28
   {-1318.0396,-176.1413,14.2207},  // 29
   {-1322.9230,-186.2787,16.3838},  // 30
   {-1323.0547,-174.1568,18.2519},  // 31
   {-1331.0435,-173.0928,18.2519},  // 32
   {-1330.4788,-167.3545,18.4160},  // 33
   {-1321.7090,-167.9489,18.2519},  // 34
   {-1323.1653,-173.1094,18.2519},  // 35
   {-1323.1201,-186.0242,16.3838},  // 36
   {-1318.7396,-185.5831,16.3769},  // 37
   {-1318.8922,-175.4356,14.2270},  // 38
   {-1298.9132,-176.1219,14.2207},  // 39
   {-1304.2484,-155.5472,14.2207},  // 40
   {-1313.2334,-155.5017,14.2207},  // 41
   {-1313.7571,-160.7859,14.2207},  // 42
   {-1299.1484,-160.1554,14.2207},  // 43
   {-1298.7689,-175.5130,14.2207},  // 44
   {-1278.1825,-185.6783,14.2270},  // 45
   {-1285.9323,-186.1855,14.5787},  // 46
   {-1286.1957,-190.3448,14.2207},  // 47
   {-1288.6593,-187.6443,14.2207},  // 48
   {-1287.8600,-180.6207,14.2270},  // 49
   {-1299.5647,-179.7728,14.3408},  // 50
   {-1298.2578,-164.6376,14.2207},  // 51
   {-1303.1499,-165.2546,14.6959},  // 52
   {-1303.7202,-159.8251,14.2207},  // 53
   {-1316.4501,-159.6830,14.2207},  // 54
   {-1298.9822,-164.5053,14.2207},  // 55
   {-1299.0397,-175.6049,14.2207},  // 56
   {-1318.3859,-176.1117,14.2207},  // 57
   {-1318.2748,-159.8722,14.2207},  // 58
   {-1300.5134,-159.9617,14.2207},  // 59
   {-1313.5242,-159.6949,14.2207},  // 60
   {-1313.1591,-155.4716,14.2207},  // 61
   {-1304.7974,-155.2772,14.2207},  // 62
   {-1304.3247,-150.8013,14.2207},  // 63
   {-1291.9326,-150.8489,14.2207},  // 64
   {-1318.6349,-175.5250,14.2270},  // 65
   {-1319.3054,-186.1746,16.3769},  // 66
   {-1322.8842,-186.3009,16.3838},  // 67
   {-1323.2813,-175.3304,18.2519},  // 68
   {-1329.4144,-172.1793,18.3457}  // 69
};

enum HalloweenNPCPoitSpawn { Float:HNPC_X, Float:HNPC_Y, Float:HNPC_Z  }
new Float:Halloween_NPCSpawn[MAX_HALLOWEEN_NPC][HalloweenNPCPoitSpawn] =
{
    {-1299.4084,-151.0883,14.2207},
    {-1318.7631,-176.9920,14.2207},
    {-1277.8182,-165.6967,14.2207},
    {-1272.7996,-168.6820,14.2207},
    {-1266.2386,-146.7078,14.8769},
    {-1288.7227,-159.1669,14.8769},
    {-1322.9230,-186.2787,16.3838}, 
    {-1323.1653,-173.1094,18.2519}, 
    {-1304.2484,-155.5472,14.2207}, 
    {-1278.1825,-185.6783,14.2270},
    {-1299.5647,-179.7728,14.3408}, 
    {-1298.9822,-164.5053,14.2207},
    {-1313.5242,-159.6949,14.2207},
    {-1318.6349,-175.5250,14.2270}
};

enum halloweennpc
{
	NPC:HalloweenNPCID, // ID бота
    HalloweenNPCDestination, // Направление прогулки бота
    bool:HalloweenNPCDestinationStatus, // Идет или пришел
    HalloweenNPCDestinationCount,
    bool:HalloweenNPCDestinationType, // Направление в + идет хождение или в -
    HalloweenNPCDestinationDefine, // стартовая точка.
    bool:HalloweenNPCReally, // 1 бот настоящик, его надо ударить
    bool:HalloweenNPCStatus, // Статус, можно ли заставить что-то делать
    HalloweenSlotNPC // На всякий для проверок моих же
}
new HalloweenNpcInfo[MAX_HALLOWEEN_NPC_COUNT][halloweennpc];

enum halloweennpctoplayer
{
    HalloweenSlot, // Слот
    bool:HalloweenStatus, // занято ли
	HalloweenPlayerID, // ID лобби
    HalloweenPlayerWorld, // Мир ботов
    bool:HalloweenCutscene, // была ли катсцена
    bool:HalloweenGoNextQuest, // Отправляем на другой квест пацанов.
    HalloweenCount // стартовое кол.во ботов
}
new HalloweenNpcInfoToPlayerID[MAX_HALLOWEEN_NPC_SLOTS][halloweennpctoplayer];


stock WalkingHalloweenNpcProcess(npcid)
{
    new pos = HalloweenNpcInfo[npcid][HalloweenNPCDestination];
    new Float:distance = GetDistanceNpcPoint(HalloweenNpcInfo[npcid][HalloweenNPCID], Halloween_NPCWalking[pos][HNPC_X], Halloween_NPCWalking[pos][HNPC_Y], Halloween_NPCWalking[pos][HNPC_Z]);
    if(distance <= 1.58 && !HalloweenNpcInfo[npcid][HalloweenNPCDestinationStatus]) HalloweenNpcInfo[npcid][HalloweenNPCDestinationStatus] = true;
    TaskNpcGoToPoint(HalloweenNpcInfo[npcid][HalloweenNPCID], Halloween_NPCWalking[pos][HNPC_X], Halloween_NPCWalking[pos][HNPC_Y], Halloween_NPCWalking[pos][HNPC_Z], NPC_MOVE_MODE:NPC_MOVE_MODE_WALK);
    return 1;
}

stock PennivizeWalkerCheckLife(playerid)
{
    if(LobbyInfo[playerid][lobbyLeader] == -1) return PennivizeGoBack(playerid, 0,0);
    if(LobbyInfo[playerid][lobbyLeader] != -1)
    {
        for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
        {
            if(LobbyInfo[playerid][lobbySatellite][l] == -1) 
            {
                return PennivizeGoBack(playerid, 1,0);
            }
            else
            {
                if(GetPlayerInterior(LobbyInfo[playerid][lobbySatellite][l]) != INT_HALLOWEEN_QUEST_1 && GetPlayerInterior(LobbyInfo[playerid][lobbySatellite][l]) != INT_HALLOWEEN_QUEST_2) return PennivizeGoBack(playerid, 1,0);
            }
        }
        if(DeathInfo[LobbyInfo[playerid][lobbySatellite][0]][deathStatus] == true && DeathInfo[LobbyInfo[playerid][lobbySatellite][1]][deathStatus] == true
        && DeathInfo[LobbyInfo[playerid][lobbySatellite][2]][deathStatus] == true && DeathInfo[LobbyInfo[playerid][lobbySatellite][4]][deathStatus] == true)  return PennivizeGoBack(playerid, 2,0);
    }
    return 1;
}

// Запускаем прогулку ботов по ID
stock WalkingHalloweenNpc(npcid)
{
    if(!IsValidNpc(HalloweenNpcInfo[npcid][HalloweenNPCID])) return 0;
    if(HalloweenNpcInfoToPlayerID[HalloweenNpcInfo[npcid][HalloweenSlotNPC]][HalloweenGoNextQuest]) return destroyhqwalker(HalloweenNpcInfo[npcid][HalloweenSlotNPC],1);
    else PennivizeWalkerCheckLife(HalloweenNpcInfoToPlayerID[HalloweenNpcInfo[npcid][HalloweenSlotNPC]][HalloweenPlayerID]);
    WalkingHalloweenNpcProcess(npcid);
    if(!HalloweenNpcInfo[npcid][HalloweenNPCDestinationStatus]) return 1;
    if(HalloweenNpcInfo[npcid][HalloweenNPCDestinationType]) {
        if(HalloweenNpcInfo[npcid][HalloweenNPCDestination] != HalloweenNpcInfo[npcid][HalloweenNPCDestinationCount]) HalloweenNpcInfo[npcid][HalloweenNPCDestination]++;
        else HalloweenNpcInfo[npcid][HalloweenNPCDestination]--, HalloweenNpcInfo[npcid][HalloweenNPCDestinationType] = false;
    }
    else {
        if(HalloweenNpcInfo[npcid][HalloweenNPCDestination] != HalloweenNpcInfo[npcid][HalloweenNPCDestinationDefine]) HalloweenNpcInfo[npcid][HalloweenNPCDestination]--;
        else HalloweenNpcInfo[npcid][HalloweenNPCDestination]++, HalloweenNpcInfo[npcid][HalloweenNPCDestinationType] = true;
    }
    new i = HalloweenNpcInfo[npcid][HalloweenNPCDestination];
    HalloweenNpcInfo[npcid][HalloweenNPCDestinationStatus] = false;
    TaskNpcGoToPoint(HalloweenNpcInfo[npcid][HalloweenNPCID], Halloween_NPCWalking[i][HNPC_X], Halloween_NPCWalking[i][HNPC_Y], Halloween_NPCWalking[i][HNPC_Z], NPC_MOVE_MODE:NPC_MOVE_MODE_WALK);
    return true;
}

stock createhqwalker(playerid,result)
{
    HalloweenNpcInfoToPlayerID[result][HalloweenStatus] = true;
    HalloweenNpcInfoToPlayerID[result][HalloweenSlot] = result;
    HalloweenNpcInfoToPlayerID[result][HalloweenPlayerID] = playerid;
    HalloweenNpcInfoToPlayerID[result][HalloweenCutscene] = false;
    LobbyInfo[playerid][lobbyStatus] = 2;
    LobbyInfo[playerid][lobbyParam] = result;
    new NpcInfoCount = result * MAX_HALLOWEEN_NPC;
    HalloweenNpcInfoToPlayerID[result][HalloweenCount] = NpcInfoCount;
    HalloweenNpcInfo[NpcInfoCount + random(MAX_HALLOWEEN_NPC)][HalloweenNPCReally] = true;
    for(new i; i < MAX_HALLOWEEN_NPC; i++)
    {
        HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCID] = CreateNpc(15699, Halloween_NPCSpawn[i][HNPC_X], Halloween_NPCSpawn[i][HNPC_Y], Halloween_NPCSpawn[i][HNPC_Z]);
        SetNpcVirtualWorld(HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCID], 3000+result);
        HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCDestinationType] = true;
        HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCDestination] = 1*i + 4*i;
        HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCDestinationDefine] = 1*i + 4*i;
        HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCDestinationCount] = 4 + HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCDestinationDefine];
        HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCDestinationStatus] = false;
        HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCStatus] = false;
        SetNpcHealth(HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCID], 100000.0);
        SetNpcStunAnimationEnabled(HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCID], false);
        HalloweenNpcInfo[NpcInfoCount+i][HalloweenSlotNPC] = NpcInfoCount/MAX_HALLOWEEN_NPC;
    }
    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] != -1) SetPlayerHudTask(LobbyInfo[playerid][lobbySatellite][l], "Хэллоуин квест", "Найдите и ударьте кулаком настоящего Пеннивайза");
    }
    if(server == 0) SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Боты ходаки созданы!");
    return 1;
}

stock destroyhqwalker(slot, type)
{
    new NpcInfoCount = HalloweenNpcInfoToPlayerID[slot][HalloweenCount];
    for(new i; i < MAX_HALLOWEEN_NPC; i++)
    {
        if(!IsValidNpc(HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCID])) continue;
        DestroyNpc(HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCID]);
        HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCID] = NPC: 0;
        HalloweenNpcInfo[NpcInfoCount+i][HalloweenNPCDestination] = 0;
    }
    HalloweenNpcInfoToPlayerID[slot][HalloweenStatus] = false;
    HalloweenNpcInfoToPlayerID[slot][HalloweenGoNextQuest] = false;
    if(type) GoPennivizeBattle(HalloweenNpcInfoToPlayerID[slot][HalloweenPlayerID]);
    return 1;
}

stock GoCreatePenisWalker(playerid)
{
    new result = -1;
    if(result == -1)
    {
        for(new i; i < MAX_HALLOWEEN_NPC_SLOTS; i++)
        {
            if(HalloweenNpcInfoToPlayerID[i][HalloweenStatus]) continue;
            else
            {
                result = i;
                break;
            }
        }
    }
    if(result == -1) return PennivizeGoBack(playerid,4,0);
    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        S_SetPlayerVirtualWorld(LobbyInfo[playerid][lobbySatellite][l],result+3000, INT_HALLOWEEN_QUEST_1);
        PPSetPlayerInterior(LobbyInfo[playerid][lobbySatellite][l], INT_HALLOWEEN_QUEST_1);
    }
    if(LobbyInfo[playerid][lobbySatellite][0] != -1) PPSetPlayerPos(LobbyInfo[playerid][lobbySatellite][0], -1255.8185,-145.9415,14.2207);
    if(LobbyInfo[playerid][lobbySatellite][1] != -1) PPSetPlayerPos(LobbyInfo[playerid][lobbySatellite][1], -1258.2152,-148.3463,14.2207);
    if(LobbyInfo[playerid][lobbySatellite][2] != -1) PPSetPlayerPos(LobbyInfo[playerid][lobbySatellite][2], -1258.3018,-146.0835,14.2207);
    if(LobbyInfo[playerid][lobbySatellite][3] != -1) PPSetPlayerPos(LobbyInfo[playerid][lobbySatellite][3], -1255.8185,-145.9415,14.2207);
    createhqwalker(playerid,result);
    return 1;
}

stock PennivizeWalker_OnPlayerGiveDamageNpc(NPC:npc, damagerid, Float:amount, weaponid, bodypart)
{
    #pragma unused bodypart
    #pragma unused amount
    #pragma unused damagerid
    if(weaponid != 0) return true;
    if(GiveDamagePlayerToPennivizeWalkerNpc(npc)) return true;
    return true;
}

// Наносим дамаг по маньяку
stock GiveDamagePlayerToPennivizeWalkerNpc(NPC:npc)
{
    new findSlot = -1;
    for(new i = 0; i < MAX_HALLOWEEN_NPC_COUNT; i++)
    {
        if(HalloweenNpcInfo[i][HalloweenNPCID] == npc)
        {
            if(HalloweenNpcInfo[i][HalloweenNPCReally]) 
            {
                findSlot = i;
                break;
            }
        }
    }

    if(findSlot >= 0)
    {
        new slot = HalloweenNpcInfo[findSlot][HalloweenSlotNPC];
        HalloweenNpcInfoToPlayerID[slot][HalloweenGoNextQuest] = true;
        return true;
    }
    return false;
}

//=========================================================
//=================== Касцена =====================
new NPC:PennivizeWalk[MAX_PLAYERS];
new PennivizeWalkTimer[MAX_PLAYERS];
new PennivizeWalkArea;

stock CreatePennivizeWalk(playerid)
{
    new world = GetPlayerVirtualWorld(playerid);
    DestroyPennivizeWalk(playerid);

    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        TogglePlayerControllable(LobbyInfo[playerid][lobbySatellite][l], false);
        FlyCameraPos(LobbyInfo[playerid][lobbySatellite][l], -1260.249633, -157.664672, 15.278270, -1261.784790, -162.359771, 14.504054, 1000, 2000);
    }
    PennivizeWalk[playerid] = CreateNpc(15699, -1261.3411,-166.9268,14.2207);
    SetNpcVirtualWorld(PennivizeWalk[playerid], world);
    SetNpcStunAnimationEnabled(PennivizeWalk[playerid], false);
    TaskNpcGoToPoint(PennivizeWalk[playerid], -1265.7235,-172.4133,14.2198, NPC_MOVE_MODE_WALK);
    PennivizeWalkTimer[playerid] = SetTimerEx("PennivizeWalkDestroyTimer", 5000, true, "d", playerid);
    HalloweenNpcInfoToPlayerID[LobbyInfo[playerid][lobbyParam]][HalloweenCutscene] = true;

    PlayAudioStreamForPlayer(playerid,"https://cdn.pears.fun/sound/characters/maniac/screamer0.mp3");
    return true;
}

stock DestroyPennivizeWalk(playerid)
{
    if(PennivizeWalkTimer[playerid] > 0)
    {
        DestroyNpc(PennivizeWalk[playerid]);
        KillTimer(PennivizeWalkTimer[playerid]);
        PennivizeWalkTimer[playerid] = 0;
        return true;
    }
    return false;
}

function PennivizeWalkDestroyTimer(playerid)
{
    DestroyPennivizeWalk(playerid);
    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        SetCameraBehindPlayer(LobbyInfo[playerid][lobbySatellite][l]);
        TogglePlayerControllable(LobbyInfo[playerid][lobbySatellite][l], true);
    }
    return true;
}

stock CreateHalloweenPickUP()
{
    if(IsAHalloween())
    {
        CreateDynamicPickup(12316, 1, 870.1978,-25.2869,63.9646, 0, 0); // Вход
        CreateDynamic3DTextLabel("{ff9000}Квест Хэллоуин [ ALT ]",-1,870.1978,-25.2869,63.9646+0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    }

    PennivizeWalkArea = CreateDynamicCube(-1259.3386,-166.4675, 0.0, -1265.8022, -140.6678, 50.0, -1, INT_HALLOWEEN_QUEST_1);
    return true;
}

//=========================================================
//=================== Касцена Джони=====================
new NPC:PennivizeWalkJone[MAX_PLAYERS];
new HalloweenCuteSceneTimer[MAX_PLAYERS][5];
new JoneHalloweenBot[MAX_PLAYERS];


enum HalloweenPlayerCuteScenePos { Float:PlayerCuteScenePosX, Float:PlayerCuteScenePosY, Float:PlayerCuteScenePosZ, Float:PlayerCuteScenePosA  }
new Float:HPCSPos[MAX_CUTESCENE_HALLOWEEN_POS][HalloweenPlayerCuteScenePos] =
{
    {969.9657, 1159.4873, 10.8362, 180.0},
    {967.3853, 1161.5129, 10.8362, 180.0},
    {971.4749, 1161.5554, 10.8362, 180.0}, 
    {969.4865, 1162.0107, 10.8362, 180.0},
    {972.7516, 1161.3346, 10.8362, 156.0},
    {973.3438, 1160.4398, 10.8362, 88.0},
    {973.3461, 1159.7889, 10.8362, 88.0},
    {973.3533, 1158.9921, 10.8362, 88.0}
};

CMD:starthalloween(playerid)
{
    if(PlayerInfo[playerid][pSoska] <= 20) return 0;
    HalloweenSetPosition(playerid);
    return 1;
}
stock HalloweenSetPosition(playerid)
{
    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        TogglePlayerControllable(LobbyInfo[playerid][lobbySatellite][l], false);
        S_SetPlayerVirtualWorld(LobbyInfo[playerid][lobbySatellite][l],playerid+3000, INT_HALLOWEEN_QUEST_1);
        PPSetPlayerInterior(LobbyInfo[playerid][lobbySatellite][l], INT_HALLOWEEN_QUEST_1);
        PPSetPlayerPos(LobbyInfo[playerid][lobbySatellite][l], HPCSPos[l][PlayerCuteScenePosX],HPCSPos[l][PlayerCuteScenePosY],HPCSPos[l][PlayerCuteScenePosZ]);
        PPSetPlayerFacingAngle(LobbyInfo[playerid][lobbySatellite][l], HPCSPos[l][PlayerCuteScenePosA]);
    }
    HalloweenOneCuteScene(playerid);
    return true;
}
stock HalloweenOneCuteScene(playerid)
{
    JoneHalloweenBot[playerid] = CreateDynamicActor(353, 970.3427,1153.9492,10.8362,0.0, true, 100.0, playerid+3000, INT_HALLOWEEN_QUEST_1);
    ApplyDynamicActorAnimation(JoneHalloweenBot[playerid], "PED","endchat_03" ,4.1,  false, false, false, true, false);
    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        FlyCameraPos(LobbyInfo[playerid][lobbySatellite][l], 970.027587, 1157.023925, 10.980079, 970.282897, 1152.053100, 11.454717, 500, 2000);
        PlayAudioStreamForPlayer(LobbyInfo[playerid][lobbySatellite][l],"https://cdn.pears.fun/sound/characters/jone/hallowen24/jone_pen1.mp3");
    }
    HalloweenCuteSceneTimer[playerid][0] = SetTimerEx("HalloweenOneCuteSceneTimer", 7500, true, "d", playerid);
    SetPVarInt(playerid,"qweststat",65), SetPVarInt(playerid,"qwesttime",17);
    return true;
}

stock DestroyHalloweenOneCuteScene(playerid)
{
    if(HalloweenCuteSceneTimer[playerid][0] > 0)
    {
        KillTimer(HalloweenCuteSceneTimer[playerid][0]);
        HalloweenCuteSceneTimer[playerid][0] = 0;
        HalloweenTwoCuteScene(playerid);
        return true;
    }
    return false;
}

function HalloweenOneCuteSceneTimer(playerid)
{
    DestroyHalloweenOneCuteScene(playerid);

    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        FlyCameraPos(LobbyInfo[playerid][lobbySatellite][l], 969.850524, 1162.426635, 11.617245, 973.707092, 1159.378417, 10.703235, 1000, 1200);
        PPSetPlayerPos(LobbyInfo[playerid][lobbySatellite][l], HPCSPos[4+l][PlayerCuteScenePosX],HPCSPos[4+l][PlayerCuteScenePosY],HPCSPos[4+l][PlayerCuteScenePosZ]);
        PPSetPlayerFacingAngle(LobbyInfo[playerid][lobbySatellite][l], HPCSPos[4+l][PlayerCuteScenePosA]);
        ApplyAnimation(LobbyInfo[playerid][lobbySatellite][l],"PED","SEAT_idle",4.0, false, false, false, true, false, SYNC_ALL);
    }
    return true;
}

stock HalloweenTwoCuteScene(playerid)
{
    SetDynamicActorPos(JoneHalloweenBot[playerid], 971.5273,1158.8145,10.8362);
    SetDynamicActorFacingAngle(JoneHalloweenBot[playerid], 313.0);
    ApplyDynamicActorAnimation(JoneHalloweenBot[playerid], "GANGS", "prtial_gngtlkA" ,2.1, true, false, false, true, false);
    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        FlyCameraPos(LobbyInfo[playerid][lobbySatellite][l], 970.027587, 1157.023925, 10.980079, 970.282897, 1152.053100, 11.454717, 500, 2000);
        PlayAudioStreamForPlayer(LobbyInfo[playerid][lobbySatellite][l],"https://cdn.pears.fun/sound/characters/jone/hallowen24/jone_pen2.mp3");
    }
    HalloweenCuteSceneTimer[playerid][1] = SetTimerEx("HalloweenTwoCuteSceneTimer", 13000, true, "d", playerid);
    return true;
}

function HalloweenTwoCuteSceneTimer(playerid)
{
    DestroyHalloweenTwoCuteScene(playerid);

    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        FlyCameraPos(LobbyInfo[playerid][lobbySatellite][l], 969.850524, 1162.426635, 11.617245, 973.707092, 1159.378417, 10.703235, 1000, 1200);
        PPSetPlayerPos(LobbyInfo[playerid][lobbySatellite][l], HPCSPos[4+l][PlayerCuteScenePosX],HPCSPos[4+l][PlayerCuteScenePosY],HPCSPos[4+l][PlayerCuteScenePosZ]);
        PPSetPlayerFacingAngle(LobbyInfo[playerid][lobbySatellite][l], HPCSPos[4+l][PlayerCuteScenePosA]);
        TextDrawShowForPlayer(LobbyInfo[playerid][lobbySatellite][l], Chernifon);
        SendMindMessage(LobbyInfo[playerid][lobbySatellite][l], RusToGame("После тусы вы уснули"),RusToGame("Но вдруг..."));
    }
    return true;
}

stock DestroyHalloweenTwoCuteScene(playerid)
{
    if(HalloweenCuteSceneTimer[playerid][1] > 0)
    {
        KillTimer(HalloweenCuteSceneTimer[playerid][1]);
        HalloweenCuteSceneTimer[playerid][1] = 0;
        HalloweenThreeCuteScene(playerid);
        return true;
    }
    return false;
}

stock HalloweenThreeCuteScene(playerid)
{
    DestroyDynamicActor(JoneHalloweenBot[playerid]); 
    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        TextDrawHideForPlayer(LobbyInfo[playerid][lobbySatellite][l], Chernifon);
        FlyCameraPos(LobbyInfo[playerid][lobbySatellite][l], 971.696777, 1159.935913, 10.836243, 970.724670, 1155.080322, 11.528119, 1000, 1200);
    }
    HalloweenCuteSceneTimer[playerid][2] = SetTimerEx("HalloweenThreeCuteSceneTimer", 6000, true, "d", playerid);
    return true;
}

function HalloweenThreeCuteSceneTimer(playerid)
{
    DestroyHalloweenThreeCuteScene(playerid);
    return true;
}

stock DestroyHalloweenThreeCuteScene(playerid)
{
    if(HalloweenCuteSceneTimer[playerid][2] > 0)
    {
        KillTimer(HalloweenCuteSceneTimer[playerid][2]);
        HalloweenCuteSceneTimer[playerid][2] = 0;
        HalloweenFourCuteScene(playerid);
        return true;
    }
    return false;
}

stock HalloweenFourCuteScene(playerid)
{
    DestroyDynamicActor(JoneHalloweenBot[playerid]); 
    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        TextDrawHideForPlayer(LobbyInfo[playerid][lobbySatellite][l], Chernifon);
        FlyCameraPos(LobbyInfo[playerid][lobbySatellite][l], 970.173461, 1155.662597, 11.340794, 970.102600, 1150.671142, 11.056347, 500, 2000);
        PlayAudioStreamForPlayer(LobbyInfo[playerid][lobbySatellite][l],"https://cdn.pears.fun/sound/characters/maniac/screamer0.mp3");
    }
    HalloweenCuteSceneTimer[playerid][3] = SetTimerEx("HalloweenFourCuteSceneTimer", 6000, true, "d", playerid);
    PennivizeWalkJone[playerid] = CreateNpc(15699, 966.2903,1149.5421,10.8362);
    SetNpcVirtualWorld(PennivizeWalkJone[playerid], playerid+3000);
    SetNpcStunAnimationEnabled(PennivizeWalkJone[playerid], false);
    TaskNpcGoToPoint(PennivizeWalkJone[playerid], 975.9124,1149.5952,10.8362, NPC_MOVE_MODE_WALK);
    return true;
}

function HalloweenFourCuteSceneTimer(playerid)
{
    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        SetCameraBehindPlayer(LobbyInfo[playerid][lobbySatellite][l]);
        TogglePlayerControllable(LobbyInfo[playerid][lobbySatellite][l], true);
    }
    DestroyHalloweenFourCuteScene(playerid);
    return true;
}

stock DestroyHalloweenFourCuteScene(playerid)
{
    if(HalloweenCuteSceneTimer[playerid][3] > 0)
    {
        DestroyNpc(PennivizeWalkJone[playerid]);
        KillTimer(HalloweenCuteSceneTimer[playerid][3]);
        HalloweenCuteSceneTimer[playerid][3] = 0;
        GoCreatePenisWalker(playerid);
        return true;
    }
    return false;
}

stock HalloweenFiveCuteScene(playerid)
{
    JoneHalloweenBot[playerid] = CreateDynamicActor(353, 970.3427,1153.9492,10.8362,0.0, true, 100.0, playerid+3000, INT_HALLOWEEN_QUEST_1);
    ApplyDynamicActorAnimation(JoneHalloweenBot[playerid], "GANGS", "prtial_gngtlkA" ,2.1, true, false, false, true, false);
    for(new l; l < MAX_PLAYER_TO_PENNIVIZE; l++)
    {
        if(LobbyInfo[playerid][lobbySatellite][l] == -1) continue;
        FlyCameraPos(LobbyInfo[playerid][lobbySatellite][l], 970.027587, 1157.023925, 10.980079, 970.282897, 1152.053100, 11.454717, 500, 2000);
        PlayAudioStreamForPlayer(LobbyInfo[playerid][lobbySatellite][l],"https://cdn.pears.fun/sound/characters/jone/hallowen24/jone_pen3.mp3");
    }
    HalloweenCuteSceneTimer[playerid][4] = SetTimerEx("HalloweenFiveCuteSceneTimer", 7000, true, "d", playerid);
    return true;
}

stock DestroyHalloweenFiveCuteScene(playerid)
{
    if(HalloweenCuteSceneTimer[playerid][4] > 0)
    {
        KillTimer(HalloweenCuteSceneTimer[playerid][4]);
        HalloweenCuteSceneTimer[playerid][4] = 0;
        PennivizeGoBack(playerid, 6, 1);
        return true;
    }
    return false;
}

function HalloweenFiveCuteSceneTimer(playerid)
{
    DestroyHalloweenFiveCuteScene(playerid);
    return true;
}

stock CheckHalloweenQuest(playerid)
{
    if(LobbyInfo[playerid][lobbyLeader] == -1) return ErrorMessage(playerid, "{ff6347}Запустить квест может только лидер лобби [ /mylobby ]");
    new countlobby, lastcout;
    for(new p; p < MAX_LOBBY_PLAYER; p++)
    {
        if(LobbyInfo[playerid][lobbySatellite][p] != -1) countlobby++;
        else if(p <= 4) lastcout = p;
    }
    if(countlobby < 4) return ErrorMessage(playerid, "{ff6347}Для квеста требуется 4 человека в лобби [ /mylobby ]");
    if(LobbyInfo[playerid][lobbySatellite][0] == -1 || LobbyInfo[playerid][lobbySatellite][1] == -1 || LobbyInfo[playerid][lobbySatellite][2] == -1 || LobbyInfo[playerid][lobbySatellite][3] == -1)
    {
        for(new i = 4; i < MAX_LOBBY_PLAYER; i++)
        {
            if(LobbyInfo[playerid][lobbySatellite][i] != -1)
            {
                LobbyInfo[playerid][lobbySatellite][lastcout] = LobbyInfo[playerid][lobbySatellite][i];
                LobbyInfo[playerid][lobbySatellite][i] = -1;
                break;
            }
        }
        return CheckHalloweenQuest(playerid);
    }
    dialogHalloweenGoQuestInfo(playerid);
    return 1;
}

stock dialogHalloweenGoQuestInfo(playerid)
{
	new lines[300], string[60];
	format(lines,sizeof(lines),"{ff9000}Вы хотите начать Хэллоуин Квест?\
                                \n\n{ffcc66}В вашем лобби должно быть 4 человека [ /mylobby ]\
								\n{ffcc66}Вам придется сразиться с боссом, вам нужно оружие и аптечки!");
	format(string,sizeof(string),"{ff9000}Хэллоуинский Квест");
	ShowDialog(playerid,LOBBY_ACCEPTHALLOWEEN,DIALOG_STYLE_MSGBOX, string, lines, "Далее", "Отмена");
    PlayerPlaySound(playerid,6401,0,0,0);
	return true;
}
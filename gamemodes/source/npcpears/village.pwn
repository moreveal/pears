
#define NOT_FIND_ATTACK_PLAYER 9000
#define SECOND_FOR_BACK_VILLAGE 300 // Время на возвращение ботов деревенских после того как их всех убили
#define CD_GIFT_VILLAGE 3600 // Кд, через которое подарки можно будет получить, убив всех ботов
#define RESPAWN_VILLAGE_NPC 150 // Время респавна для NPC
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
    { -1407.4387,2630.5642,55.6875, -1408.3096,2649.6248,55.6875},
    { -1476.0532,2680.3450,55.6742, -1476.1816,2696.7197,55.8194},
    { -1471.8306,2679.6736,55.8360, -1436.1375,2678.8806,55.8360},
    { -1432.8440,2611.5532,55.8360, -1433.4375,2658.2288,55.8360},
    { -1444.2333,2663.1423,55.8360, -1466.0264,2662.2234,55.8360},
    { -1488.6769,2660.2205,55.8360, -1488.4928,2612.9570,55.8360},
    { -1478.0665,2593.2788,55.8360, -1450.7744,2593.7302,55.8360},
    { -1417.9578,2621.0537,55.8360, -1418.1655,2651.4641,55.8360},
    { -1437.1744,2627.4558,55.8360, -1454.8990,2627.2456,55.8360},
    { -1516.2959,2638.5239,55.8360, -1533.8876,2637.3040,55.8360},
    { -1554.3000,2602.8113,55.8360, -1553.7778,2564.9648,55.8360},
    { -1535.5031,2569.6995,55.8360, -1508.0277,2577.2761,55.8360},
    { -1596.3037,2676.6538,55.0900, -1596.6954,2696.1082,55.0639}
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
    villCDShowGift, // Время, которое даётся на то, чтобы забрать все подарки
    villStoroji[2] // Два сторожа (DynamicActor)
}
new VillageInfo[VILLAGEINFO];

new Float: VillageStoroj[2][4] = {
    {-1361.6107,2642.7361,51.9239,255.6489}, // Бэрни
    {-1619.9281,2685.8677,54.9776,74.5639} // Эрни
};

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

alias:racvillage("spawnvillage", "respawnvillage")
CMD:racvillage(playerid)
{
    if(PlayerInfo[playerid][pSoska] <= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    VillageInfo[villActive] = false;
    VillageInfo[villGiftStatus] = false;
    VillageInfo[villCDShowGift] = 0;
    for(new i = 0; i < sizeof(VillageNpcWalk); i++) SpawnVillageNpc(i);
    UpdateLabelVillageGift();

    new string[100];
    format(string, sizeof(string), " [ ADM ]: %s заспавнил всех деревенских",PlayerInfo[playerid][pName]);
	ABroadCast(COLOR_ADM,string,1);
    AdminLog("racvillage", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
    return true;
}

stock CreateVillageNpc()
{
    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        VillageInfo[villID][i] = CreateNpc(VillageRandomSkins[random(sizeof(VillageRandomSkins))], VillageNpcWalk[i][WalkStart_X], VillageNpcWalk[i][WalkStart_Y], VillageNpcWalk[i][WalkStart_Z]);
        SpawnVillageNpc(i);
    }

    VillageInfo[villZone] = CreateDynamicCube(-1636, 2505, 100.0, -1356, 2734, 200.0, 0, 0);

    // Входы
	VillageInfo[villEnterLabel][0] = CreateDynamic3DTextLabel(" ",0xA9C4E4FF,-1483.2771,2644.1699,58.7281,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    VillageInfo[villEnterLabel][1] = CreateDynamic3DTextLabel(" ",0xA9C4E4FF,-1475.2959,2614.4619,58.7813,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    UpdateLabelVillageGift();
    CreateDynamicPickup(19132, 1, -1483.2771,2644.1699,58.7281, 0, 0);
    CreateDynamicPickup(19132, 1, -1475.2959,2614.4619,58.7813, 0, 0);

    // Выходы
    CreateDynamicPickup(19132, 1, -1483.0803,2642.3938,58.7813, 0, 0);
    CreateDynamicPickup(19132, 1, -1476.9990,2613.9775,58.7813, 0, 0);

    VillageInfo[villStoroji][0] = CreateDynamicActor(14, VillageStoroj[0][0],VillageStoroj[0][1],VillageStoroj[0][2],VillageStoroj[0][3], true, 100.0, 0, 0, -1, 100.0, -1, 0);
    VillageInfo[villStoroji][1] = CreateDynamicActor(15, VillageStoroj[1][0],VillageStoroj[1][1],VillageStoroj[1][2],VillageStoroj[1][3], true, 100.0, 0, 0, -1, 100.0, -1, 0);

    CreateDynamic3DTextLabel("Эрни [ ALT ]",0xA9C4E4FF,VillageStoroj[0][0],VillageStoroj[0][1],VillageStoroj[0][2] + 1.0,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    CreateDynamic3DTextLabel("Бэрни [ ALT ]",0xA9C4E4FF,VillageStoroj[1][0],VillageStoroj[1][1],VillageStoroj[1][2] + 1.0,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    return true;
}

// Меню информации от сторожа
stock ShowDialogInfoVillage(playerid)
{
    if((IsPlayerInRangeOfPoint(playerid,1.0,VillageStoroj[0][0],VillageStoroj[0][1],VillageStoroj[0][2])
        || IsPlayerInRangeOfPoint(playerid,1.0,VillageStoroj[1][0],VillageStoroj[1][1],VillageStoroj[1][2])) 
        && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
    {
		ShowDialog(playerid,1271,DIALOG_STYLE_TABLIST,"{ff9000}Сторож","{ff9000}Расскажи, что это за деревня?\
		                            \n{666666}Правила >>","Выбор","Отмена");
        return true;
    }
    return false;
}

// Запускаем отображенеи информации для игрока
stock InformationVillage(playerid, listitem)
{
    if(listitem == 0)
    {
        if(BotTalkTimer[playerid] || QuestInfo[playerid][ActorTimer]) return 1; // Если бот уже болтает - не прерываем его

        if(IsPlayerInRangeOfPoint(playerid,1.0,VillageStoroj[0][0],VillageStoroj[0][1],VillageStoroj[0][2]))
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/erny/erny0.mp3",VillageStoroj[0][0],VillageStoroj[0][1],VillageStoroj[0][2],6.0,true);
            StartScriptActor(playerid, 11, VillageInfo[villStoroji][0]);
        }
        else if(IsPlayerInRangeOfPoint(playerid,1.0,VillageStoroj[1][0],VillageStoroj[1][1],VillageStoroj[1][2]))
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/erny/erny0.mp3",VillageStoroj[1][0],VillageStoroj[1][1],VillageStoroj[1][2],6.0,true);
            StartScriptActor(playerid, 12, VillageInfo[villStoroji][1]);
        }
    }
    else if(listitem == 1) // Правила
    {
        new lines[600];
        format(lines,sizeof(lines),"{FB9656}Деревенские\
	                            \n\n{cccccc}- В Деревне бродят агрессивные жители\
	                            \n{cccccc}- Если вы нападёте на одного из них, они начнут атаковать всех приезжих\
                                \n{cccccc}- Вы можете убить всех деревенских для того, чтобы получить доступ к их хранилищу\
                                \n\n{ffcc66}- После смерти житель деревни возрождается через %d сек.\
                                \n{ffcc66}- Ваша задача успеть убить всех жителей\
                                \n{ffcc66}- Деревенские с холодным оружием имеют в два раза больше хп, чем с огнестрельным\
                                \n{ff9000}- Рекомендация: Не нападайте в одиночку. Вы сильно рискуете\
                                ", RESPAWN_VILLAGE_NPC);
        ShowDialog(playerid,1272,DIALOG_STYLE_MSGBOX,"{ff9000}Правила",lines,"*","");
    }
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
        format(string,sizeof(string),"{FB9656}Хранилище Деревенских\
                \n{99ff66}Призы доступны для получения\
                \n\n{cccccc}Войти ALT");
    }
    else
    {
        if(VillageInfo[villCD] > 0) format(string,sizeof(string),"{FB9656}Хранилище Деревенских\n{666666}Хранилище будет доступно через %s", fine_time(VillageInfo[villCD]));
        else format(string,sizeof(string),"{FB9656}Хранилище Деревенских\n{99ff66}В хранилище что-то есть\n\n{666666}Устраните всех деревенских, чтобы забрать их вещи");
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
    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        if(VillageInfo[villID][i] == npc) 
        {
            RevivalVillageNpc(i);
            break;
        }
    }

    new quanVillageNpcDeath = GetQuanDeadVillageNpc();
    if(server == 0) SendClientMessageToAll(-1, "Количество живых NPC %d", sizeof(VillageNpcWalk) - quanVillageNpcDeath);

    // Все NPC умерли, открываем призы
    if(quanVillageNpcDeath >= sizeof(VillageNpcWalk)) CreateVillageGift();
    return true;
}

stock GetQuanDeadVillageNpc()
{
    new quan;
    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        if(IsNpcDead(VillageInfo[villID][i])) quan ++; // Считаем дохлых NPC
    }
    return quan;
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
    else
    {
        VillageInfo[villCDShowGift] = SECOND_FOR_BACK_VILLAGE;
        for(new i = 0; i < sizeof(VillageNpcWalk); i++) VillageInfo[villRespawn][i] = SECOND_FOR_BACK_VILLAGE;
    }
    return true;
}

// Сообщение о завершении битвы
stock MessageVillageWin(playerid)
{
    new lines[320];
    if(VillageInfo[villCD] > 0)
    {
        format(lines,sizeof(lines),"{FB9656}Все деревенские были убиты!\
	                            \n{cccccc}- Однако, вы не можете забрать призы, потому что призов нет на месте\
	                            \n{cccccc}- Призы доступны для получения 1 раз в %d минут\
                                \n{FB9656}- Осталось времени для повторного получения призов: %s", CD_GIFT_VILLAGE / 60, fine_time(VillageInfo[villCD]));
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
    }
    else
    {
        format(lines,sizeof(lines),"{FB9656}Все деревенские были убиты!\
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
    if(Protect_Veh[damagerid] != 9999)
    {
        new vehicleid = Protect_Veh[damagerid];
        if(IsShootingVehicle(VehInfo[vehicleid][vModel])) return false;
    }
    GiveDamagePlayerToVillageNpc(npc, damagerid);
    return true;
}

// Транспорт из которого можно стрелять (полный список)
stock IsShootingVehicle(model)
{
    model = GetVehModelOriginal(model);
    if(model == 425 || model == 430 || model == 432 || model == 447 || model == 464 || model == 476 || model == 520 || model == 564) return true;
    return false;
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

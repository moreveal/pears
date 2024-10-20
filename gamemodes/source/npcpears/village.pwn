
#define SECOND_FOR_BACK_VILLAGE         300 // Время на возвращение ботов деревенских после того как их всех убили
#define CD_GIFT_VILLAGE                 3600 // Кд, через которое подарки можно будет получить, убив всех ботов
#define RESPAWN_VILLAGE_NPC             210 // Время респавна для NPC
#define VILLAGE_SWITCH_ATTACK_CD        3 // Время (в секундах), как часто NPC будет менять цель атаки, когда в него стреляет другой игрок

// -- Начисление призов --
#define VILLAGE_BASE_CASE_REWARD        1 // Базовое количество кейсов за первые X киллов
#define VILLAGE_KILLS_PER_REWARD        5 // Количество убийств для получения указанного количества кейсов
#define VILLAGE_DECREASE_REWARD_FACTOR  0.75 // Коэффициент уменьшения награды за каждый последующий набор киллов

new Iterator:VillagePlayer<MAX_PLAYERS>;

enum VILLAGENPCWALK { Float:WalkStart_X, Float:WalkStart_Y, Float:WalkStart_Z, Float:WalkStop_X, Float:WalkStop_Y, Float:WalkStop_Z }
new VillageNpcWalk[][VILLAGENPCWALK] =
{
	{-1411.0293, 2660.7769, 55.6875,  -1410.6873, 2650.2354, 55.6875},
    {-1410.6155, 2634.8545, 55.6875,  -1410.5419, 2625.4497, 55.6875},
    {-1389.8745, 2626.7554, 55.9844,  -1390.0033, 2637.2410, 55.9844},
    {-1418.5422, 2661.2385, 55.8360,  -1418.2983, 2645.9797, 55.6918},
    {-1418.3035, 2635.3799, 55.7307,  -1418.2275, 2622.2549, 55.8360},
    {-1417.2065, 2593.3708, 55.7713,  -1426.9941, 2593.7834, 55.8360},
    {-1432.6042, 2588.5288, 55.8360,  -1432.2854, 2576.7224, 55.8360},
    {-1437.0166, 2593.9033, 55.8360,  -1451.7305, 2593.7996, 55.8360},
    {-1446.6251, 2590.0430, 55.8360,  -1446.6166, 2572.8728, 55.8360},
    {-1450.8912, 2570.3516, 55.8360,  -1464.3019, 2570.5117, 55.8360},
    {-1464.2180, 2578.0676, 55.8360,  -1464.1276, 2591.6167, 55.8360},
    {-1468.2787, 2593.8853, 55.8360,  -1483.0529, 2593.8728, 55.8360},
    {-1488.2031, 2591.4143, 55.8360,  -1488.1381, 2577.9285, 55.8360},
    {-1498.6754, 2544.2625, 55.8360,  -1509.2627, 2544.0015, 55.7945},
    {-1521.6357, 2543.7986, 55.7243,  -1536.5270, 2543.5974, 55.8360},
    {-1531.2131, 2536.0376, 55.6875,  -1521.7983, 2535.9451, 55.6875},
    {-1509.9193, 2536.3228, 55.6875,  -1497.4003, 2536.8428, 55.6875},
    {-1496.9728, 2521.4443, 55.8562,  -1511.9117, 2521.3542, 55.8595},
    {-1519.3333, 2521.5635, 55.8535,  -1530.3545, 2521.4146, 55.9611},
    {-1532.5807, 2524.6685, 55.8532,  -1532.6233, 2536.3665, 55.6875},
    {-1553.9069, 2563.6563, 55.8360,  -1554.0684, 2583.5010, 55.8360},
    {-1553.4117, 2597.4832, 55.8360,  -1553.4445, 2626.9785, 55.8360},
    {-1552.4143, 2641.3040, 55.8360,  -1552.3186, 2654.6694, 55.8360},
    {-1563.2728, 2677.8359, 55.6831,  -1563.2555, 2691.6755, 55.7131},
    {-1547.3293, 2678.8125, 55.8360,  -1529.4081, 2678.8774, 55.8360},
    {-1527.5031, 2690.1328, 55.8360,  -1515.0317, 2690.0037, 55.8360},
    {-1499.5742, 2695.8564, 55.8360,  -1484.6726, 2695.5239, 55.8360},
    {-1476.2384, 2695.8105, 55.8018,  -1475.9655, 2684.8779, 55.6572},
    {-1474.9094, 2678.5396, 55.6826,  -1464.4270, 2678.7341, 55.8360},
    {-1455.1028, 2677.9177, 55.8360,  -1444.1818, 2677.7339, 55.8360},
    {-1434.5916, 2657.8809, 55.8360,  -1434.4617, 2643.8269, 55.8360},
    {-1434.3218, 2632.9512, 55.8360,  -1434.2684, 2617.5801, 55.8360},
    {-1441.2455, 2607.4819, 55.8360,  -1457.4935, 2607.6003, 55.8360},
    {-1459.5941, 2610.4199, 55.8360,  -1459.6425, 2629.1846, 58.7735},
    {-1478.5573, 2609.8618, 55.8360,  -1489.8650, 2610.1265, 55.8360}
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
    Float:villAttackPlayeridDist[sizeof(VillageNpcWalk)], // Последняя дистанция от бота до атакуемого игрока
    villAttackPlayeridDistChange[sizeof(VillageNpcWalk)], // Время последнего изменения дистанции
    villDestination[sizeof(VillageNpcWalk)], // Направление прогулки бота, чтобы повторно не направлять в одну и ту-же точку
    Text3D:villEnterLabel[2], // Лейблы входов
    bool:villGiftStatus, // Статус, можно ли забирать подарки
    villCDShowGift, // Время, которое даётся на то, чтобы забрать все подарки
    villStoroji[2], // Два сторожа (DynamicActor)
    villCDFindAttack[sizeof(VillageNpcWalk)], // Кд на повторный поиск цели
    villKillPlayerid[sizeof(VillageNpcWalk)] // ID игрока, который убил этого бота
}
new VillageInfo[VILLAGEINFO];

new bool:Village_LoadTextDraws[MAX_REALPLAYERS]; // Отображаются ли текстдравы деревни для игрока
new PlayerText: VillageRemainsTD[MAX_REALPLAYERS][2]; // Текстдравы для игры с деревенскими
new Village_Kills[MAX_REALPLAYERS]; // Количество киллов во время битвы с деревенскими
new Village_BlockTarget[MAX_REALPLAYERS][sizeof(VillageNpcWalk)]; // Запрет на таргет игрока конкретными NPC

new Float: VillageStoroj[2][4] = {
    {-1361.6107,2642.7361,51.9239,255.6489}, // Эрни
    {-1619.9281,2685.8677,54.9776,74.5639} // Бэрни
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

alias:racvillage("spawnvillage", "respawnvillage", "rvillage")
CMD:racvillage(playerid)
{
    if(PlayerInfo[playerid][pSoska] <= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    VillageInfo[villActive] = false;
    VillageInfo[villGiftStatus] = false;
    VillageInfo[villCDShowGift] = 0;
    foreach (new i : Player) Village_Kills[i] = 0;
    for(new i = 0; i < sizeof(VillageNpcWalk); i++) SpawnVillageNpc(i);
    UpdateLabelVillageGift();
    UpdateQuanVillage();

    // Сбрасываем всем игрокам килы деревенских
    foreach (Player, i) 
    {
        if(Village_Kills[i] > 0) Village_Kills[i] = 0;
    }

    new string[100];
    format(string, sizeof(string), " [ ADM ]: %s заспавнил всех деревенских",PlayerInfo[playerid][pName]);
	ABroadCast(COLOR_ADM,string,1);
    AdminLog("racvillage", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
    return true;
}

alias:rcdvillage("rcdvill", "rvillagecd")
CMD:rcdvillage(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сбросить кд получения подарков деревенских [ /rcdvillage ID ]");
    if(!IsOnline(params[0])) return ErrorMessage(playerid, "{FF6347}Игрок не в сети");

    PlayerInfo[params[0]][pCDVillage] = 0;

    new string[120];
    mysql_format(pearsq, string, sizeof(string),"UPDATE `pp_igroki` SET `pCDVillage` = '0' WHERE `user_id` = '%d'", PlayerInfo[params[0]][pID]);
    mysql_tquery(pearsq, string);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "** Вы очистили кд на получение подарков деревенских для %s **", PlayerInfo[params[0]][pName]);
    if(playerid != params[0]) SendClientMessage(params[0], COLOR_LIGHTBLUE, "** %s очистил вам кд на получение подарков деревенских **", PlayerInfo[playerid][pName]);

    AdminLog("rcdvillage", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[params[0]][pID], PlayerInfo[params[0]][pName], PlayerInfo[params[0]][pPlaIP], 0, "");
    return 1;
}

stock CreateVillageNpc()
{
    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        VillageInfo[villID][i] = CreateNpc(VillageRandomSkins[random(sizeof(VillageRandomSkins))], VillageNpcWalk[i][WalkStart_X], VillageNpcWalk[i][WalkStart_Y], VillageNpcWalk[i][WalkStart_Z]);
        SpawnVillageNpc(i);
    }

    VillageInfo[villZone] = CreateDynamicCube(-1636.0, 2505.0, 0.0, -1356.0, 2734.0, 300.0, 0, 0);

    // Входы
	VillageInfo[villEnterLabel][0] = CreateDynamic3DTextLabel(" ",0xA9C4E4FF,-1483.2771,2644.1699,58.7281,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    VillageInfo[villEnterLabel][1] = CreateDynamic3DTextLabel(" ",0xA9C4E4FF,-1475.2959,2614.4619,58.7813,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    UpdateLabelVillageGift();
    CreateDynamicPickup(19132, 1, -1483.2771,2644.1699,58.7281, 0, 0);
    CreateDynamicPickup(19132, 1, -1475.2959,2614.4619,58.7813, 0, 0);

    // Выходы
    CreateDynamicPickup(19132, 1, -1483.0803,2642.3938,58.7813, WORLD_VILLAGE, INT_VILLAGE);
    CreateDynamicPickup(19132, 1, -1476.9990,2613.9775,58.7813, WORLD_VILLAGE, INT_VILLAGE);

    // Сторожи
    VillageInfo[villStoroji][0] = CreateDynamicActor(14, VillageStoroj[0][0],VillageStoroj[0][1],VillageStoroj[0][2],VillageStoroj[0][3], true, 100.0, 0, 0, -1, 100.0, -1, 0);
    VillageInfo[villStoroji][1] = CreateDynamicActor(15, VillageStoroj[1][0],VillageStoroj[1][1],VillageStoroj[1][2],VillageStoroj[1][3], true, 100.0, 0, 0, -1, 100.0, -1, 0);
    CreateDynamic3DTextLabel("{cccccc}Эрни [ ALT ]",0xA9C4E4FF,VillageStoroj[0][0],VillageStoroj[0][1],VillageStoroj[0][2] + 1.0,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    CreateDynamic3DTextLabel("{cccccc}Бэрни [ ALT ]",0xA9C4E4FF,VillageStoroj[1][0],VillageStoroj[1][1],VillageStoroj[1][2] + 1.0,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);

    // Подарки
    CreateDynamicPickup(1274, 1, -1477.5995,2623.7434,58.7813, WORLD_VILLAGE, INT_VILLAGE);
    CreateDynamic3DTextLabel("{ff9000}Хранилище Деревенских\n{cccccc}[ ALT ]",0xA9C4E4FF,-1477.5995,2623.7434,58.7813,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1, WORLD_VILLAGE, INT_VILLAGE);
    return true;
}

// Меню информации от сторожа
stock ShowDialogInfoVillage(playerid)
{
    if((IsPlayerInRangeOfPoint(playerid,1.0,VillageStoroj[0][0],VillageStoroj[0][1],VillageStoroj[0][2])
        || IsPlayerInRangeOfPoint(playerid,1.0,VillageStoroj[1][0],VillageStoroj[1][1],VillageStoroj[1][2])) 
        && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
    {
        if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid, "{FF6347}Этот квест доступен только при наличии лаунчера");

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
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/berny/berny0.mp3",VillageStoroj[1][0],VillageStoroj[1][1],VillageStoroj[1][2],6.0,true);
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

// Находится ли игрок внутри интерьера деревенских
stock PlayerInInteriorVillage(playerid)
{
    if(GetPlayerVirtualWorld(playerid) == WORLD_VILLAGE && GetPlayerInterior(playerid) == INT_VILLAGE) return true;
    return false;
}

// Записываем последнюю позицию как вход в интерьер деревенских
stock Village_WriteLastPlayerPosition(playerid)
{
    return WriteLastPlayerPosition(playerid, -1483.2771,2644.1699,58.7281, 0.0, 0, 0);
}

// Получаем подарки в интерьере хранилища
stock GetGiftVillage(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid,1.0,-1477.5995,2623.7434,58.7813) && GetPlayerVirtualWorld(playerid) == WORLD_VILLAGE && GetPlayerInterior(playerid) == INT_VILLAGE)
    {
        if(VillageInfo[villGiftStatus] == true)
        {
            new string[160];
            if(PlayerInfo[playerid][pCDVillage] > gettime())
            {
                format(string, sizeof(string), "{FF6347}Вы сможете повторно получать подарки только через %s", fine_time(PlayerInfo[playerid][pCDVillage] - gettime()));
                ErrorMessage(playerid, string);
                return true;
            }

            // Рассчитываем количество кейсов для игрока
            new quanGift;
            {
                new Float: reward;
                new Float: currentQuan = VILLAGE_BASE_CASE_REWARD;
                new Float: killComplete = Village_Kills[playerid] / VILLAGE_KILLS_PER_REWARD;
                new Float: killRemains = Village_Kills[playerid] % VILLAGE_KILLS_PER_REWARD;

                for (new i = 0; i < killComplete; i++)
                {
                    reward += currentQuan;
                    currentQuan *= VILLAGE_DECREASE_REWARD_FACTOR;
                }

                if (killRemains > 0)
                {
                    reward += currentQuan * (killRemains / VILLAGE_KILLS_PER_REWARD);
                }

                quanGift = floatround(reward);
            }

            if(quanGift <= 0) return ErrorMessage(playerid, "{FF6347}Вы совершили недостаточно убийств для получения подарков\n{ffcc66}Требуется убить и удерживать "#VILLAGE_KILLS_PER_REWARD" деревенских");
            if(!free_invent(playerid, quanGift))
            {
                format(string, sizeof(string), "{FF6347}У вас не хватает места в инвентаре\n{ffcc66}Требуется %d слотов", quanGift);
                ErrorMessage(playerid, string);
                return true;
            }

            new thingId, thingQuan, thingType, thingPara, thingPack;
            for(new i = 0; i < quanGift; i++)
            {
                switch(random(4))
                {
                    case 0: CreateCasePlayer(playerid, thingId, thingQuan, thingType, thingPara, thingPack, "village");
                    default: CreateCasePlayer(playerid, thingId, thingQuan, thingType, thingPara, thingPack);
                }
                GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
				CalculateVehicleLimited(thingId, thingType);
            }

            format(string,sizeof(string),"собрал%s %d кейсов", gender(playerid), quanGift);
            SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 20.0, 5000);

            format(string,sizeof(string),"{99ff66}Поздравляем! Вы получили %d кейсов\n\n{ffcc66}Внимание! В следующий раз вы сможете получить подарки через %d минут", quanGift, CD_GIFT_VILLAGE / 60);
            SuccessMessage(playerid, string);

            PlayerInfo[playerid][pCDVillage] = gettime() + CD_GIFT_VILLAGE;
            mysql_format(pearsq, string, sizeof(string),"UPDATE `pp_igroki` SET `pCDVillage` = '%d' WHERE `user_id` = '%d'", PlayerInfo[playerid][pCDVillage], PlayerInfo[playerid][pID]);
            mysql_tquery(pearsq, string);
        }
        else ErrorMessage(playerid, "{FF6347}Хранилище деревенских закрыто");
        return true;
    }
    return false;
}

// Входы выходы в хранилище деревенских
stock DoorVillageStorage(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid,1.0,-1483.2771,2644.1699,58.7281) && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0
        || IsPlayerInRangeOfPoint(playerid,1.0,-1475.2959,2614.4619,58.7813) && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
	{
        if(VillageInfo[villGiftStatus] == true)
        {
            S_SetPlayerVirtualWorld(playerid, WORLD_VILLAGE, INT_VILLAGE);
            PPSetPlayerInterior(playerid, INT_VILLAGE);
            if(IsPlayerInRangeOfPoint(playerid,1.0,-1483.2771,2644.1699,58.7281)) PPSetPlayerPos(playerid,-1483.2737,2640.6836,58.7813), PPSetPlayerFacingAngle(playerid,185.0136);
            else if(IsPlayerInRangeOfPoint(playerid,1.0,-1475.2959,2614.4619,58.7813)) PPSetPlayerPos(playerid,-1478.7166,2614.4929,58.7880), PPSetPlayerFacingAngle(playerid,47.1690);
            SetCameraBehindPlayer(playerid);
        }
        else ErrorMessage(playerid, "{FF6347}Хранилище деревенских закрыто");
        return true;
    }

    // Выход 1
    else if(IsPlayerInRangeOfPoint(playerid,1.0,-1483.0803,2642.3938,58.7813) && GetPlayerVirtualWorld(playerid) == WORLD_VILLAGE && GetPlayerInterior(playerid) == INT_VILLAGE)
	{
        S_SetPlayerVirtualWorld(playerid, 0, 0);
        PPSetPlayerPos(playerid,-1483.1899,2646.1348,58.7281), PPSetPlayerFacingAngle(playerid,0.0);
        SetCameraBehindPlayer(playerid);
        return true;
    }

    // Выход 2
    else if(IsPlayerInRangeOfPoint(playerid,1.0,-1476.9990,2613.9775,58.7813) && GetPlayerVirtualWorld(playerid) == WORLD_VILLAGE && GetPlayerInterior(playerid) == INT_VILLAGE)
	{
        S_SetPlayerVirtualWorld(playerid, 0, 0);
        PPSetPlayerPos(playerid,-1473.4135,2614.3062,58.7880), PPSetPlayerFacingAngle(playerid,271.4945);
        SetCameraBehindPlayer(playerid);
        return true;
    }

    return false;
}

// Игрок находится в деревне во время активной битвы
stock IsPlayerInActiveVillage(playerid)
{
    if(IsPlayerInDynamicArea(playerid, VillageInfo[villZone]) && VillageInfo[villActive] == false) return true;
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
        format(string,sizeof(string),"{FB9656}Хранилище Деревенских\
                                    \n{99ff66}В хранилище что-то есть\
                                    \n\n{666666}Устраните всех деревенских, чтобы забрать их вещи");
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

stock SpawnVillageNpc(i, bool:update = false)
{
    VillageInfo[villRespawn][i] = 0;
    VillageInfo[villAttackPlayerid][i] = INVALID_PLAYER_ID;
    if(update == false) VillageInfo[villKillPlayerid][i] = INVALID_PLAYER_ID;

    SetNpcPosition(VillageInfo[villID][i], VillageNpcWalk[i][WalkStart_X], VillageNpcWalk[i][WalkStart_Y], VillageNpcWalk[i][WalkStart_Z]);
    GoVilliageNpc(i, 0, NPC_MOVE_MODE_WALK);

    if(VillageInfo[villActive] == false) SetNpcWeapon(VillageInfo[villID][i], WEAPON_FIST);
    else SetVillageNpcRandomWeapons(i);

    SetVillageHealthNpc(i);

    // Обновляем количество живых NPC для участников
    if(update == true) UpdateQuanVillage();
    return true;
}

// Ставим хп ботам деревенским
stock SetVillageHealthNpc(i)
{
    if(IsShootingWeapon(GetNpcWeapon(VillageInfo[villID][i]))) SetNpcHealth(VillageInfo[villID][i], 150.0);
    else SetNpcHealth(VillageInfo[villID][i], 250.0);
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
    // Кд, через которое все боты вернутся после победы над ними
    new bool:ResetVillage;
    if(VillageInfo[villCDShowGift] > 0)
    {
        VillageInfo[villCDShowGift] --;
        if(VillageInfo[villCDShowGift] <= 0) 
        {
            ResetVillage = true; // Процесс перезапуска деревенских
            VillageInfo[villActive] = false;
            VillageInfo[villGiftStatus] = false;
            foreach (new i : Player) Village_Kills[i] = 0;
            UpdateLabelVillageGift();
        }
    }

    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        // Респавн NPC
        if(VillageInfo[villRespawn][i] > 0)
        {
            VillageInfo[villRespawn][i] --;
            if(VillageInfo[villRespawn][i] <= 0) 
            {
                if(ResetVillage == true) SpawnVillageNpc(i); // Во время общего перезапуска, не нужно пересчитывать каждого живого отдельно
                else SpawnVillageNpc(i, true);
            }
        }

        if(VillageInfo[villActive] && !IsNpcDead(VillageInfo[villID][i]))
        {
            // Боты постоянно ищут ближайшего игрока для атаки
            AttackVillageNpcNearbyPlayer(i);
        }

        // Бот гуляет по городу туды сюды
        if(!VillageInfo[villActive] && !IsNpcDead(VillageInfo[villID][i])) WalkingVillageNpc(i);
    }

    // Обновляем количество живых NPC для участников
    if(ResetVillage == true) UpdateQuanVillage();
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
    new bool: isVillage = false;
    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        if(VillageInfo[villID][i] == npc)
        {
            isVillage = true;
            break;
        }
    }

    if (isVillage)
    {
        // Не пропускаем урон от игроков, которые не могут являться целью атаки деревенских
        if(IsPlayerNotTargetForVillage(damagerid)) return false;

        // Запускаем режим битвы, если его не было
        if(VillageInfo[villActive] == false)
        {
            VillageInfo[villActive] = true;

            for(new i = 0; i < sizeof(VillageNpcWalk); i++)
            {
                VillageInfo[villAttackPlayeridDist][i] = 0.0;
                VillageInfo[villAttackPlayeridDistChange][i] = 0;

                if (IsNpcDead(VillageInfo[villID][i])) continue;

                Village_TaskNpcAttackPlayer(VillageInfo[villID][i], damagerid, i);
                SetVillageNpcRandomWeapons(i);
            }
        }
    }

    return true;
}

stock SetSpawnVillageNpc(NPC:npc, playerid)
{
    new bool:villageNpc, slotNPC;
    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        if(VillageInfo[villID][i] == npc) 
        {
            RevivalVillageNpc(i);
            villageNpc = true;
            slotNPC = i;
            break;
        }
    }

    if(villageNpc == true)
    {
        // Игрок убил NPC
        PlayerShotVillage(playerid, slotNPC);

        new quanVillageNpcDeath = UpdateQuanVillage();
        if(quanVillageNpcDeath >= sizeof(VillageNpcWalk)) CreateVillageGift(); // Все NPC умерли, открываем призы
        return true;
    }
    return false;
}

// Игрок убил NPC
stock PlayerShotVillage(playerid, i)
{
    if(VillageInfo[villKillPlayerid][i] == playerid) return false; // Бота убил один и тот-же игрок

    if(VillageInfo[villKillPlayerid][i] != INVALID_PLAYER_ID) // Бота уже кто-то убивал (забираем килл у того игрока)
    {
        new giveplayerid = VillageInfo[villKillPlayerid][i];
        if(IsOnline(giveplayerid))
        {
            if(Village_Kills[giveplayerid] - 1 > 0) Village_Kills[giveplayerid] --;
        }
    }

    VillageInfo[villKillPlayerid][i] = playerid;
    Village_Kills[playerid] ++;
    PlayerInfo[playerid][pStatistics][1]++;

    if(server == 0) SendClientMessageToAll(-1, "%s убил %d деревенских", PlayerInfo[playerid][pName], Village_Kills[playerid]);
    return true;
}

stock UpdateQuanVillage()
{
    new quanVillageNpcDeath = GetQuanDeadVillageNpc();
    new quan = sizeof(VillageNpcWalk) - quanVillageNpcDeath;

    // Отображаем участникам количество живых ботов
    UpdateQuanVillageForPlayers(quan);
    return quanVillageNpcDeath;
}

stock UpdateQuanVillageForPlayers(quan)
{
    // Отображаем участникам количество живых ботов
    foreach (VillagePlayer, playerid)
    {
        if(OnlineInfo[playerid][oLogged] == 0) continue;
        Village_QuanNpcTextdraws(playerid, quan);
    }
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
    VillageInfo[villGiftStatus] = true;
    UpdateLabelVillageGift();
    VillageInfo[villCDShowGift] = SECOND_FOR_BACK_VILLAGE;
    for(new i = 0; i < sizeof(VillageNpcWalk); i++) VillageInfo[villRespawn][i] = SECOND_FOR_BACK_VILLAGE;
    return true;
}

// Сообщение о завершении битвы
stock MessageVillageWin(playerid)
{
    new lines[360];
    if(Village_Kills[playerid] < VILLAGE_KILLS_PER_REWARD)
    {
        format(lines,sizeof(lines),"{FB9656}Все деревенские были убиты!\
                            \n{cccccc}- Перед победой вы устранили и удерживали {FF6347}%d деревенских\
                            \n{FF6347}- Вам недоступны призы, поскольку вы внесли недостаточный вклад для победы\
                            \n{FF6347}- Требуется убить и удерживать минимум %d деревенских", Village_Kills[playerid], VILLAGE_KILLS_PER_REWARD);
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
    }
    else
    {
        if(PlayerInfo[playerid][pCDVillage] > gettime())
        {
            format(lines,sizeof(lines),"{FB9656}Все деревенские были убиты!\
                                \n{cccccc}- Перед победой вы устранили и удерживали {99ff66}%d деревенских\
	                            \n{FF6347}- Внимание! Вы сможете получать подарки только через %s", Village_Kills[playerid], fine_time(PlayerInfo[playerid][pCDVillage] - gettime()));
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
        }
        else
        {
            format(lines,sizeof(lines),"{FB9656}Все деревенские были убиты!\
                                    \n{cccccc}- Перед победой вы устранили и удерживали {99ff66}%d деревенских\
                                    \n{cccccc}- Теперь вы можете забрать их вещи [ Отмечено GPS меткой ]\
                                    \n{cccccc}- У вас есть %d минут на то, чтобы забрать призы", Village_Kills[playerid], SECOND_FOR_BACK_VILLAGE / 60);
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
            CreateGps(playerid,-1483.2771,2644.1699,58.7281, 0, 0, 2.0);
        }
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
        if(VillageInfo[villCDFindAttack][i] > gettime()) return false; // Не будем атаковать новую цель (только что начали атаковать другую)
        VillageInfo[villCDFindAttack][i] = gettime() + 2; // Кд на повторную смену цели при атаке 2 секунды

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
            VillageInfo[villKillPlayerid][i] = INVALID_PLAYER_ID;
            GoVilliageNpc(i, 1, NPC_MOVE_MODE_RUN);
            SetVillageHealthNpc(i);
        }
        else SpawnVillageNpc(i);
    }

    // Сбрасываем всем игрокам килы деревенских
    foreach (Player, i) 
    {
        if(Village_Kills[i] > 0) Village_Kills[i] = 0;
    }

    // Обновляем количество живых NPC для участников
    UpdateQuanVillage();
    return true;
}

stock Village_TaskNpcAttackPlayer(NPC:npc, playerid, i)
{
    TaskNpcAttackPlayer(npc, playerid, .aggressive = random(2) != 0);
    VillageInfo[villAttackPlayerid][i] = playerid;
    return true;
}

// Игрок, который не является целью для ботов деревенских
stock IsPlayerNotTargetForVillage(playerid)
{
    for(new i = 0; i < sizeof(VillageNpcWalk); i++)
    {
        new NPC: npc = VillageInfo[villID][i];
        if(IsNpcDead(npc)) continue;
        
        new Float: x, Float: y, Float: z;
        GetNpcPosition(npc, x, y, z);
        
        // Если игрок является целью одного из NPC, но тот существенно не изменял свою позицию более чем 15 секунд
        if(VillageInfo[villActive] && VillageInfo[villAttackPlayerid][i] == playerid)
        {
            new Float: distance = GetPlayerDistanceFromPoint(playerid, x, y, z);

            if(VillageInfo[villAttackPlayeridDistChange][i] == 0)
            {
                VillageInfo[villAttackPlayeridDistChange][i] = gettime();
                VillageInfo[villAttackPlayeridDist][i] = distance;
            } else if(floatabs(distance - VillageInfo[villAttackPlayeridDist][i]) > 1.0)
            {
                VillageInfo[villAttackPlayeridDistChange][i] = gettime();
                VillageInfo[villAttackPlayeridDist][i] = distance;
            } else
            {
                if(gettime() - VillageInfo[villAttackPlayeridDistChange][i] >= 15)
                {
                    Village_BlockTarget[playerid][i] = gettime() + 10;
                    
                    VillageInfo[villAttackPlayeridDistChange][i] = gettime();
                    VillageInfo[villAttackPlayeridDist][i] = 0.0;
                    continue;
                }
            }
        }
        
        // Если игрок сильно выше одного из NPC
        if(Protect_Z[playerid] - z > 10.0) return true;
    }

    // Если игрок не является целью для всех NPC или не находится в деревне
    if(IsPlayerNotTarget(playerid) || !IsPlayerInDynamicArea(playerid, VillageInfo[villZone])) return true;

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

    new currentTime = gettime();
    foreach (VillagePlayer, playerid) 
    {
        if(IsPlayerNotTargetForVillage(playerid)) continue;
        if(Village_BlockTarget[playerid][i] > currentTime) continue;

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
    Village_LoadTextdraws(playerid);
    Village_ShowTextdraws(playerid);
    return true;
}

// Игрок вышел из деревни
stock PlayerExitVillage(playerid)
{
    Iter_Remove(VillagePlayer, playerid);
    Village_DestroyTextdraws(playerid);
    return true;
}

// Создаём текстдравы деревенских
stock Village_LoadTextdraws(playerid)
{
    if(Village_LoadTextDraws[playerid] == true) return false;

    VillageRemainsTD[playerid][0] = CreatePlayerTextDraw(playerid, 43.0000, 191.0000, "120");
    PlayerTextDrawLetterSize(playerid, VillageRemainsTD[playerid][0], 0.4000, 1.6000);
    PlayerTextDrawAlignment(playerid, VillageRemainsTD[playerid][0], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, VillageRemainsTD[playerid][0], -1);
    PlayerTextDrawBackgroundColour(playerid, VillageRemainsTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, VillageRemainsTD[playerid][0], TEXT_DRAW_FONT: 3);
    PlayerTextDrawSetProportional(playerid, VillageRemainsTD[playerid][0], true);
    PlayerTextDrawSetShadow(playerid, VillageRemainsTD[playerid][0], 0);

    VillageRemainsTD[playerid][1] = CreatePlayerTextDraw(playerid, 15.0000, 185.0000, "pears_element:farmer");
    PlayerTextDrawTextSize(playerid, VillageRemainsTD[playerid][1], 21.0000, 26.0000);
    PlayerTextDrawAlignment(playerid, VillageRemainsTD[playerid][1], TEXT_DRAW_ALIGN: 1);
    PlayerTextDrawColour(playerid, VillageRemainsTD[playerid][1], -1);
    PlayerTextDrawBackgroundColour(playerid, VillageRemainsTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, VillageRemainsTD[playerid][1], TEXT_DRAW_FONT: 4);
    PlayerTextDrawSetProportional(playerid, VillageRemainsTD[playerid][1], false);
    PlayerTextDrawSetShadow(playerid, VillageRemainsTD[playerid][1], 0);

    Village_LoadTextDraws[playerid] = true;
    return true;
}


// Удаляем текстдравы деревенских
stock Village_DestroyTextdraws(playerid)
{
    if(Village_LoadTextDraws[playerid] == false) return false;

    for (new i = 0; i < sizeof(VillageRemainsTD[]); i++) PlayerTextDrawDestroy(playerid, VillageRemainsTD[playerid][i]);
    Village_LoadTextDraws[playerid] = false;
    return true;
}

// Отображаем количество живых деревенских для игрока
stock Village_QuanNpcTextdraws(playerid, quan)
{
    if(Village_LoadTextDraws[playerid] == false) return false;

    new string[10];
    format(string,sizeof(string), "%d", quan);
    PlayerTextDrawSetString(playerid, VillageRemainsTD[playerid][0], string);
    PlayerTextDrawShow(playerid, VillageRemainsTD[playerid][0]);
    return true;
}

// Отображаем текстдравы для игрока
stock Village_ShowTextdraws(playerid)
{
    if(Village_LoadTextDraws[playerid] == false) return false;

    new quanVillageNpcDeath = GetQuanDeadVillageNpc();
    Village_QuanNpcTextdraws(playerid, sizeof(VillageNpcWalk) - quanVillageNpcDeath);
    PlayerTextDrawShow(playerid, VillageRemainsTD[playerid][1]);
    return true;
}

// Нанесли урон NPC
stock Village_OnPlayerGiveDamageNpc(NPC:npc, damagerid, Float:amount, weaponid, bodypart)
{
    #pragma unused amount
    #pragma unused weaponid
    #pragma unused bodypart
    
    if(!GiveDamagePlayerToVillageNpc(npc, damagerid)) return false;
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
stock Village_OnPlayerTakeDamageNpc(NPC:npc, issuerid, Float:amount, weaponid, bodypart)
{
    #pragma unused npc
    #pragma unused issuerid
    #pragma unused amount
    #pragma unused weaponid
    #pragma unused bodypart

    return true;
}

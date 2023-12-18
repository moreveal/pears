
#define MAX_PLAYERS_START_QUEST 200 // Максимальное количество игроков на квесте id 0

/*
Как добавить новый квест в менюшку?
1. в define MAX_QUEST добавляем цифру
2. в StartQuestName добавляем новую строку с названием квеста
3. в StartQuestPresent добавляем информацию о вознаграждении за прохождение квеста
*/

new StartQuestName[][] =
{
    "Взлом транспорта", 
    "None"
};
new StartQuestPresent[][] =
{
    "Транспорт", 
    "None"
};

new ZoneQuest1; // ID Zone Quest в Los Santos
new ZoneQuest2; // ID Zone Quest в Las Venturas
new QuanPlayerStartQuest; // Количество игроков на стартовом квесте

enum questInfo
{
	QuestBot, // ID Actor
	Text3D:QuestBotLabel, // ID Label Actor
    ScriptQuest,
	VehicleQuest, // ID Vehicle Quest
    VehColorQuest, // Color ID Vehicle Quest
    ActorTimer, // Timer Actor Script
    ActorText, // Script ID Text Actor
    Text3D:LabelFirst, // 3d text 1
    bool:ThingOne
};
new QuestInfo[MAX_REALPLAYERS][questInfo];

stock OnGameModeStartQuest() // Создаём детали для квеста
{
    ZoneQuest1 = CreateDynamicCube(1346.014404, -1696.490600, 9.402812, 1389.085327, -1614.687255, 27.992818, -1, 0);
    ZoneQuest2 = CreateDynamicCube(2097.350830, 2703.892822, 9.030303, 2145.809082, 2763.931640, 23.730318, -1, 0);
    return 1;
}

stock showDialogStartQuest(playerid)
{
    format(lines,sizeof(lines),""); // Очищаем Lines

    format(line,sizeof(line),"{cccccc}Квест\t{cccccc}Статус{cccccc}\tВознаграждение"), strcat(lines,line);
    for(new i = 0; i < MAX_QUEST; i++)
    {
        if(PlayerInfo[playerid][pQuest][i] == 0) format(line,sizeof(line),"\n{ff9000}%d. %s\t{555555}Не выполнен\t{D9F26E}%s", i + 1, StartQuestName[i], StartQuestPresent[i]), strcat(lines,line);
        else format(line,sizeof(line),"\n{ff9000}%d. %s\t{99ff66}Выполнен\t{D9F26E}%s", i + 1, StartQuestName[i], StartQuestPresent[i]), strcat(lines,line);
    }
    ShowDialog(playerid,504,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Квесты",lines,"Выбор","Отмена");
    return 1;
}

new ScriptActorQuestJone0[][] = // Начало задания
{
    "Здарова. Короче, мне нужна помощь", 
    "Смотри, сзади тебя стоит тачка", 
    "В ней лежит пакет, который мне нужен", 
    "Вскрой тачку и принеси мне этот пакет",
    "Отмычки возьми на столе",
    "Мне сказали ты профи, так что действуй"
};
new ScriptJone0[] = // Время в милисекундах для переключения реплик
{
    3230,
    2380,
    1570,
    2160,
    1270,
    2060
};

new ScriptActorQuestJone1[][] = // Конец задания
{
    "Отлично! На владельца этой машины мне насрать, он мне должен",
    "Поэтому можешь оставить её себе",
    "Управляй транспортом через свой смартфон",
    "Не говорю прощай, потому что мы ещё точно увидимся"
};
new ScriptJone1[] = // Время в милисекундах для переключения реплик
{
    4200,
    2030,
    2220,
    3080
};

stock StartScriptActor(playerid, scriptid)
{
    if(QuestInfo[playerid][ActorTimer]) KillTimer(QuestInfo[playerid][ActorTimer]);
    QuestInfo[playerid][ActorText] = 0;
    QuestInfo[playerid][ScriptQuest] = scriptid;
    SendScriptActor(playerid, scriptid);
    return 1;
}
stock SendScriptActor(playerid, scriptid)
{
    if(scriptid == 1)
    {
        QuestInfo[playerid][ActorTimer] = SetTimerEx("NextScriptActor", ScriptJone0[QuestInfo[playerid][ActorText]], false, "dd", playerid, scriptid);
        SendDynamicActorMessage(QuestInfo[playerid][QuestBot], playerid, ScriptActorQuestJone0[QuestInfo[playerid][ActorText]]);
    }
    else if(scriptid == 2)
    {
        QuestInfo[playerid][ActorTimer] = SetTimerEx("NextScriptActor", ScriptJone1[QuestInfo[playerid][ActorText]], false, "dd", playerid, scriptid);
        SendDynamicActorMessage(QuestInfo[playerid][QuestBot], playerid, ScriptActorQuestJone1[QuestInfo[playerid][ActorText]]);
    }
    return 1;
}
function NextScriptActor(playerid, scriptid)
{
    if(QuestInfo[playerid][ActorTimer]) KillTimer(QuestInfo[playerid][ActorTimer]);

    QuestInfo[playerid][ActorText] ++;

    new maxScript;
    if(scriptid == 1) maxScript = sizeof(ScriptActorQuestJone0);
    else if(scriptid == 2) maxScript = sizeof(ScriptActorQuestJone1);

    if(QuestInfo[playerid][ActorText] >= maxScript)
    {
        if(QuestInfo[playerid][ActorTimer]) KillTimer(QuestInfo[playerid][ActorTimer]);
    }
    else SendScriptActor(playerid, scriptid);
    return 1;
}

stock QuestActorJone(playerid) // Начинаем взаимодействовать с NPC квеста
{
    if(IsPlayerInRangeOfPoint(playerid,1.5, 1364.35242, -1682.73926, 13.47850) || IsPlayerInRangeOfPoint(playerid,1.5, 2121.7776,2709.5793,10.8203))
	{
        if(BotTalkTimer[playerid]) return 1; // Если бот уже болтает - не прерываем его
        if(QuestInfo[playerid][ScriptQuest] == 2) return 1; // Все сценарии были отработаны

        new freeSlot = GetPlayerFreeVehSlot(playerid);
        if(freeSlot == -1) return ErrorMessage(playerid, "{FF6347}У вас нет свободного слота для транспорта\n\n{cccccc}Возможно, требуется открыть дополнительные слоты [ Y >> Donate ]");
        
        new Float:pos[3];
        GetDynamicActorPos(QuestInfo[playerid][QuestBot], pos[0], pos[1], pos[2]);

        if(OnlineInfo[playerid][oInHandThing][0] != 196) // Начинаем квест
        {
            if(QuestInfo[playerid][ScriptQuest] == 1)
            {
                SendDynamicActorMessage(QuestInfo[playerid][QuestBot], playerid, "Ну и где пакет? Делай свою работу");
                PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/jone/jone2.mp3",pos[0], pos[1], pos[2],5.0,true);
                return 1;
            }
            PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/jone/jone1.mp3",pos[0], pos[1], pos[2],5.0,true);
            StartScriptActor(playerid, 1);
        }
        else if(OnlineInfo[playerid][oInHandThing][0] == 196) // Принесли пакет (Квест выполнен)
        {
            new yesLoad = 1;
            if(GetPlayerQuanLoadVehicle(playerid) >= 2) yesLoad = 0;

            if(yesLoad == 0) SuccessMessage(playerid, "{99ff66}Вы выполнили задание и получили в подарок автомобиль\n{FF6347}Новый автомобиль не загружен, потому что у вас уже загружены транспортные средства\n\n{ff9000}Управление транспортом - Y >> Транспорт или /car");
            else SuccessMessage(playerid, "{99ff66}Вы выполнили задание и получили в подарок автомобиль\n\n{ff9000}Управление транспортом - Y >> Транспорт или /car");

            PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/jone/jone3.mp3",pos[0], pos[1], pos[2],5.0,true);
            StartScriptActor(playerid, 2);

            InHandClear(playerid);
            if(QuestInfo[playerid][VehicleQuest]) ACDestroyVehicle(QuestInfo[playerid][VehicleQuest]), QuestInfo[playerid][VehicleQuest] = 0;
            if(IsPlayerInRangeOfPoint(playerid,5.0, 1364.35242, -1682.73926, 13.47850)) GiveCar(playerid, freeSlot, 546, 1362.8092,-1658.9130,13.1072,269.5840, 0, QuestInfo[playerid][VehColorQuest], QuestInfo[playerid][VehColorQuest], yesLoad, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
            else if(IsPlayerInRangeOfPoint(playerid,5.0, 2121.7776,2709.5793,10.8203)) GiveCar(playerid, freeSlot, 546, 2118.9817,2729.5417,10.5447,270.2156, 0, QuestInfo[playerid][VehColorQuest], QuestInfo[playerid][VehColorQuest], yesLoad, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

            // Выполнили квест 0
            PlayerInfo[playerid][pQuest][0] = 1;
            SaveQuest(playerid);
        }
        return 1;
    }
    return 0;
}

stock EnterVehicleQuest(playerid)
{
    if(OnlineInfo[playerid][oInHandThing][0] == 196) return ErrorMessage(playerid, "{FF6347}Вы уже взяли пакет из машины\n{cccccc}Отнесите его Джоне");
    PlayerPlaySound(playerid,5600,0,0,0);
    GiveThingHand(playerid, 196, 1, 0, 0, 0, 0); // Даём в руки пакет
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы забрали пакет из машины\n{0088ff}Теперь отнесите этот пакет Джоне","*","");
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вот пакет! Теперь мне нужно отнести его Джоне");
    return 1;
}

stock MasterKeyQuest(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid,1.5, 1366.066772, -1679.641357, 13.546929) || IsPlayerInRangeOfPoint(playerid,1.5, 2124.882568, 2711.710449, 10.820312))
	{
        if(QuestInfo[playerid][ThingOne] == true) return ErrorMessage(playerid, "{FF6347}Вы уже взяли отмычки");
        if(QuestInfo[playerid][ScriptQuest] == 2) return 1; // Все сценарии были отработаны

        new getQuan, getLimit;
		i_limit(playerid, 19, getQuan, getLimit);
		if(getQuan+GetFullThingQuan(19) > getLimit) return ErrorMessage(playerid, "{FF6347}У вас уже есть отмычки\n{cccccc}Подойдите к транспорту и нажмите кнопку ALT");

        new put_inva = GiveThingPlayer(playerid, 19, 0, 0, 0, 0, 0, 9999); // Выдаём предмет
		if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");

        PlayerPlaySound(playerid,5600,0,0,0);
		ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0,0,1,1,0,0);
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы взяли отмычки\n{0088ff}Подойдите к машине и нажмите кнпоку ALT, чтобы взломать дверь","*","");
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мне нужно подойти к машине и взломать дверь [ Кнопка ALT ]");

        QuestInfo[playerid][ThingOne] = true;
        return 1;
    }
    return 0;
}

stock OpenStartQuest(playerid, zoneid) // Запускаем зону квеста
{
    if(PlayerInfo[playerid][pQuest][0] == 1) return 0; // Если квест уже пойден, не запускаем квест
    if(PursuitTime[playerid] >= 1) return 0; // Если преследует полиция, не запускаем квест
    if(QuestInfo[playerid][QuestBot]) return 0; // Квест уже запущен

    if(QuanPlayerStartQuest >= MAX_PLAYERS_START_QUEST) return ErrorMessage(playerid, "{FF6347}В данный момент этот квест проходит большое количество игроков\n\n{cccccc}Извините.. мы не можем запустить этот квест для вас\nПриходите немного позже, когда количество игроков проходящих этот квест уменьшится");
    
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        SetVehicleVirtualWorld(vehicleid, playerid + 1), S_SetPlayerVirtualWorld(playerid, playerid + 1, 0);
        LinkVehicleToInterior(vehicleid, 0), SetPlayerInterior(playerid, 0);
    }
    else
    {
        S_SetPlayerVirtualWorld(playerid, playerid + 1, 0);
        SetPlayerInterior(playerid, 0);
    }

    // Color Vehicle
    new color1 = 1 + random(254);
    new color2 = color1;
    QuestInfo[playerid][VehColorQuest] = color1;

    // Reset Variables
    QuestInfo[playerid][ScriptQuest] = 0;
    DestroyDetailsQuest(playerid);

    if(zoneid == 0) // Los Santos
    {
        // NPC
        QuestInfo[playerid][QuestBot] = CreateDynamicActor(44, 1364.35242, -1682.73926, 13.47850, 5.0, true, 100.0, playerid + 1, 0, playerid, 100.0, -1, 0);
        QuestInfo[playerid][QuestBotLabel] = CreateDynamic3DTextLabel("{cccccc}Джоне [ALT]",0xA9C4E4FF,1364.35242, -1682.73926, 13.47850 + 1.0, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerid + 1, 0, playerid);
    
        // Vehicle
        QuestInfo[playerid][VehicleQuest] = PP_CreateVehicle(QuestInfo[playerid][VehicleQuest], 546, 1362.8092,-1658.9130,13.1072,269.5840, color1, color2, -1, 0, -1, 0.0);
    
        // Master Keys
        QuestInfo[playerid][LabelFirst] = CreateDynamic3DTextLabel("{ff9000}Отмычки [ALT]",0xA9C4E4FF,1366.066772, -1679.641357, 13.546929, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerid + 1, 0, playerid);
    }
    else if(zoneid == 1) // Las Venturas
    {
        // NPC
        QuestInfo[playerid][QuestBot] = CreateDynamicActor(44, 2121.7776,2709.5793,10.8203,357.4829, true, 100.0, playerid + 1, 0, playerid, 100.0, -1, 0);
        QuestInfo[playerid][QuestBotLabel] = CreateDynamic3DTextLabel("{cccccc}Джоне [ALT]",0xA9C4E4FF,2121.7776,2709.5793,10.8203 + 1.0, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerid + 1, 0, playerid);
    
        // Vehicle
        QuestInfo[playerid][VehicleQuest] = PP_CreateVehicle(QuestInfo[playerid][VehicleQuest], 546, 2118.9817,2729.5417,10.5447,270.2156, color1, color2, -1, 0, -1, 0.0);
    
        // Master Keys
        QuestInfo[playerid][LabelFirst] = CreateDynamic3DTextLabel("{ff9000}Отмычки [ALT]",0xA9C4E4FF,2124.882568, 2711.710449, 10.820312, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerid + 1, 0, playerid);
    }

    // Car Information
    SetVehicleVirtualWorld(QuestInfo[playerid][VehicleQuest], playerid + 1);
    VehInfo[QuestInfo[playerid][VehicleQuest]][vCarLock] = 1;
	SetVehicleParamsForPlayer(QuestInfo[playerid][VehicleQuest],playerid,0,1);

    QuanPlayerStartQuest ++;
    return 1;
}

stock DestroyDetailsQuest(playerid)
{
    if(QuestInfo[playerid][QuestBot])
    {
        DestroyDynamicActor(QuestInfo[playerid][QuestBot]);
        DestroyDynamic3DTextLabel(QuestInfo[playerid][QuestBotLabel]);
        QuestInfo[playerid][QuestBot] = 0;

        DestroyDynamic3DTextLabel(QuestInfo[playerid][LabelFirst]);
    }
    if(QuestInfo[playerid][VehicleQuest])
    {
        ACDestroyVehicle(QuestInfo[playerid][VehicleQuest]);
        QuestInfo[playerid][VehicleQuest] = 0;
    }
    if(QuestInfo[playerid][ActorTimer]) KillTimer(QuestInfo[playerid][ActorTimer]);
    return 1;
}

stock CloseQuestJone(playerid)
{
    DestroyDetailsQuest(playerid);
    QuanPlayerStartQuest --;
    return 1; 
}

stock ExitQuestJone(playerid) // Вышли из зоны квеста
{
    if(QuestInfo[playerid][QuestBot])
    {
        CloseQuestJone(playerid);

        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehicleVirtualWorld(vehicleid, 0), S_SetPlayerVirtualWorld(playerid, 0, 0);
		    LinkVehicleToInterior(vehicleid, 0), SetPlayerInterior(playerid, 0);

            NoCollisionForAll(playerid, 0); // Отключаем коллизию на 20 сек при выезде из зоны
        }
        else
        {
            S_SetPlayerVirtualWorld(playerid, 0, 0);
            SetPlayerInterior(playerid, 0);
        }
    }
    return 1;
}

CMD:clearquest(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    new tmp[24],questid;
	if(sscanf(params, "s[24]i",tmp,questid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Очистить начальный квест игрока [ /clearquest ID Квест (0 - все квесты) ]");
    new giveplayerid = ReturnUser(tmp, 1);
    if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Этого игрока нет в сети");

    if(questid == 0)
    {
        for(new i = 0; i < MAX_QUEST; i++) PlayerInfo[giveplayerid][pQuest][i] = 0;
        format(store, sizeof(store), " [ ADM ]: %s очистил %s все начальные квесты",PlayerInfo[playerid][pName] ,PlayerInfo[giveplayerid][pName]);
        ABroadCast(COLOR_ADM,store,1);
        format(store, sizeof(store), "* Администратор %s очистил все ваши начальные квесты", PlayerInfo[playerid][pName]);
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, store);
        AdminLog("clearquest", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], 0, "Очистил все начальные квесты");
    }
    else if(questid >= 1 && questid <= MAX_QUEST)
    {
        PlayerInfo[giveplayerid][pQuest][questid - 1] = 0;
        format(store, sizeof(store), " [ ADM ]: %s очистил %s начальный квест id %d",PlayerInfo[playerid][pName] ,PlayerInfo[giveplayerid][pName], questid);
        ABroadCast(COLOR_ADM,store,1);
        format(store, sizeof(store), "* Администратор %s очистил ваш начальный квест id %d", PlayerInfo[playerid][pName], questid);
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, store);
        AdminLog("clearquest", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], questid, "Очистил начальный квест");
    }
    else return ErrorMessage(playerid, "{FF6347}Квеста под этим id не существует");
    SaveQuest(giveplayerid);
    return 1;
}

stock LoadPlayerQuest(playerid)
{
    cache_get_value_name(0, "Quest", store_query, sizeof(store_query)); // Берём из бд строку

	new arrCoords[MAX_QUEST][MAX_QUEST * 2];
	split(store_query, arrCoords, ','); // Делим её

    for(new i = 0; i < MAX_QUEST; i++) PlayerInfo[playerid][pQuest][i] = strval(arrCoords[i]); // Записываем в переменные
    return 1;
}

stock SaveQuest(playerid) // Сохраняем информацию о квестах
{
    // Записываем переменные в одну строку
    for(new i = 0; i < MAX_QUEST; i++)
    {
        if(i == 0) format(store_query,sizeof(store_query),"%d", PlayerInfo[playerid][pQuest][i]);
        else format(store_query,sizeof(store_query),"%s,%d", store_query, PlayerInfo[playerid][pQuest][i]);
    }

    // Сохраняем
    format(big_query, sizeof(big_query), "UPDATE `pp_igroki` SET `Quest`= '%s' WHERE `id`='%d'", store_query, PlayerInfo[playerid][pID]);
    query_empty(pearsq, big_query);
    return 1;
}
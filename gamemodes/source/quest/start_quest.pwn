
#define MAX_PLAYERS_START_QUEST 200

new ZoneQuest1; // ID Zone Quest в Los Santos
new QuanPlayerStartQuest; // Количество игроков на стартовом квесте

enum questInfo
{
	QuestBot, // ID Actor
	Text3D:QuestBotLabel, // ID Label Actor
	VehicleQuest, // ID Vehicle Quest
    VehColorQuest, // Color ID Vehicle Quest
    QuestTimerText // Text Actor on Quest
};
new QuestInfo[MAX_REALPLAYERS][questInfo];

stock OnGameModeStartQuest() // Создаём детали для квеста
{
    ZoneQuest1 = CreateDynamicCube(1346.014404, -1696.490600, 9.402812, 1389.085327, -1614.687255, 27.992818, -1, 0);
    return 1;
}

new TextActorQuestJone[][] =
{
    // Начало задания
    "Здарова. Короче, мне нужна помощь", 
    "Смотри, сзади тебя стоит тачка", 
    "В ней лежит пакет, который мне нужен", 
    "Вскрой тачку и принеси мне этот пакет",
    "Отмычки возьми на столе",
    "Мне сказали ты профи, так что действуй",

    // Конец задания
    "Отлично! На владельца этой машины мне насрать, он мне должен",
    "Поэтому можешь оставить её себе",
    "Управляй транспортом через свой смартфон",
    "Не говорю прощай, потому что мы ещё точно увидимся"
};

stock QuestActor(playerid) // Начинаем взаимодействовать с NPC квеста
{
    if(IsPlayerInRangeOfPoint(playerid,1.5, 1364.35242, -1682.73926, 13.47850))
	{
        new freeSlot = GetPlayerFreeVehSlot(playerid);
        if(freeSlot == -1) return ErrorMessage(playerid, "{FF6347}У вас нет свободного слота для транспорта\n\n{cccccc}Возможно, требуется открыть дополнительные слоты [ Y >> Donate ]");
        
        

        format(store,sizeof(store),"{67b2ff}%s", TextActorQuestJone[QuestInfo[playerid][QuestTimerText]]);
        SendDynamicActorMessage(QuestInfo[playerid][QuestBot], playerid, store);

        QuestInfo[playerid][QuestTimerText] ++;
        if(QuestInfo[playerid][QuestTimerText] >= 10) QuestInfo[playerid][QuestTimerText] = 0;
        
        
        
        if(OnlineInfo[playerid][oInHandThing][0] != 196) // Начинаем квест
        {


        }
        else if(OnlineInfo[playerid][oInHandThing][0] == 196) // Принесли пакет (Квест выполнен)
        {
            InHandClear(playerid);
            if(QuestInfo[playerid][VehicleQuest]) ACDestroyVehicle(QuestInfo[playerid][VehicleQuest]), QuestInfo[playerid][VehicleQuest] = 0;
            GiveCar(playerid, freeSlot, 546, 1362.8092,-1658.9130,13.1072,269.5840, 0, QuestInfo[playerid][VehColorQuest], QuestInfo[playerid][VehColorQuest]);
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

stock OpenStartQuest(playerid) // Запускаем зону квеста
{
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

    if(QuestInfo[playerid][QuestBot]) DestroyDynamicActor(QuestInfo[playerid][QuestBot]), DestroyDynamic3DTextLabel(QuestInfo[playerid][QuestBotLabel]);
    QuestInfo[playerid][QuestBot] = CreateDynamicActor(44, 1364.35242, -1682.73926, 13.47850, 5.0, true, 100.0, playerid + 1, 0, playerid, 100.0, -1, 0);
    QuestInfo[playerid][QuestBotLabel] = CreateDynamic3DTextLabel("{cccccc}Джоне [ALT]",0xA9C4E4FF,1364.35242, -1682.73926, 13.47850 + 1.0, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerid + 1, 0, playerid);
    
    QuestInfo[playerid][QuestTimerText] = 0;

    if(QuestInfo[playerid][VehicleQuest]) ACDestroyVehicle(QuestInfo[playerid][VehicleQuest]);
    new color1 = 1 + random(254);
    new color2 = color1;
    QuestInfo[playerid][VehColorQuest] = color1;
    QuestInfo[playerid][VehicleQuest] = PP_CreateVehicle(QuestInfo[playerid][VehicleQuest], 546, 1362.8092,-1658.9130,13.1072,269.5840, color1, color2, -1, 0, -1, 0.0);
    SetVehicleVirtualWorld(QuestInfo[playerid][VehicleQuest], playerid + 1);
    VehInfo[QuestInfo[playerid][VehicleQuest]][vCarLock] = 1;
	SetVehicleParamsForPlayer(QuestInfo[playerid][VehicleQuest],playerid,0,1);

    QuanPlayerStartQuest ++;
    return 1;
}

stock ExitQuest(playerid) // Вышли из зоны квеста
{
    if(QuestInfo[playerid][QuestBot])
    {
        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehicleVirtualWorld(vehicleid, 0), S_SetPlayerVirtualWorld(playerid, 0, 0);
		    LinkVehicleToInterior(vehicleid, 0), SetPlayerInterior(playerid, 0);
        }
        else
        {
            S_SetPlayerVirtualWorld(playerid, 0, 0);
            SetPlayerInterior(playerid, 0);
        }
        if(QuestInfo[playerid][QuestBot]) DestroyDynamicActor(QuestInfo[playerid][QuestBot]), DestroyDynamic3DTextLabel(QuestInfo[playerid][QuestBotLabel]);
        QuestInfo[playerid][QuestBot] = 0;
        if(QuestInfo[playerid][VehicleQuest]) ACDestroyVehicle(QuestInfo[playerid][VehicleQuest]);
        QuestInfo[playerid][VehicleQuest] = 0;

        QuanPlayerStartQuest --;
    }
    return 1;
}
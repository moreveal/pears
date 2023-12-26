
#define MAX_PLAYERS_START_QUEST 200 // Максимальное количество игроков на квесте id 0

#include "../gamemodes/source/quest/cue.pwn" // Тут лежат реплики персонажей (Когда они стоят на улице)

/*
Как добавить новый квест в менюшку?
1. в define MAX_QUEST добавляем цифру
2. в StartQuestName добавляем новую строку с названием квеста
3. в StartQuestPresent добавляем информацию о вознаграждении за прохождение квеста
*/

new StartQuestName[][] =
{
    "Паспортный контроль", 
    "Поселиться в отеле",
    "Привести себя в порядок",
    "Взлом транспорта",
    "Ремонт транспорта",
    "Археологические раскопки"
};
new StartQuestPresent[][] =
{
    "",
    "",
    "Деньги",
    "Транспорт",
    "",
    "Кейс"
};

new ZoneQuest1; // ID Zone Quest в Los Santos
new ZoneQuest2; // ID Zone Quest в Las Venturas
new QuanPlayerStartQuest; // Количество игроков на стартовом квесте
new ActorQuest1; // NPC bearby hotel LS
new ActorQuest2; // NPC bearby hotel LV

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

    ActorQuest1 = CreateDynamicActor(249, 1590.3958,-2278.8374,13.5328,270.2411, true, 100.0, 0, 0, -1, 100.0, -1, 0);
    CreateDynamic3DTextLabel("{cccccc}Дрейк [ALT]",0xA9C4E4FF,1590.3958,-2278.8374,13.5328 + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

    ActorQuest2 = CreateDynamicActor(249, 1731.7189,1440.1394,10.8767,182.8204, true, 100.0, 0, 0, -1, 100.0, -1, 0);
    CreateDynamic3DTextLabel("{cccccc}Дрейк [ALT]",0xA9C4E4FF,1731.7189,1440.1394,10.8767 + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
    return 1;
}

stock NoCompleteQuest(playerid, questId)
{
    if(questId == 0 && PlayerInfo[playerid][pQuest][questId] < 1) return 1; // Паспортный контроль
    else if(questId == 1 && PlayerInfo[playerid][pQuest][questId] < 1) return 1; // Заселиться в отель
    else if(questId == 2 && PlayerInfo[playerid][pQuest][questId] < 3) return 1; // Привести себя в порядок
    else if(questId == 3 && PlayerInfo[playerid][pQuest][questId] < 3) return 1; // Взломать тачку
    else if(questId == 4 && PlayerInfo[playerid][pQuest][questId] < 1) return 1; // Ремонт транспорта
    else if(questId == 5 && PlayerInfo[playerid][pQuest][questId] < 2) return 1; // Археологические раскопки
    return 0;
}

stock showDialogStartQuest(playerid, stat)
{
    DP[0][playerid] = stat;
    format(lines,sizeof(lines),""); // Очищаем Lines

    format(line,sizeof(line),"{cccccc}Квест\t{cccccc}Статус{cccccc}\tВознаграждение"), strcat(lines,line);
    for(new i = 0; i < MAX_QUEST; i++)
    {
        if(NoCompleteQuest(playerid, i)) format(line,sizeof(line),"\n{ff9000}%d. %s\t{555555}Не выполнен\t{D9F26E}%s", i + 1, StartQuestName[i], StartQuestPresent[i]), strcat(lines,line);
        else format(line,sizeof(line),"\n{ff9000}%d. %s\t{99ff66}Выполнен\t{D9F26E}%s", i + 1, StartQuestName[i], StartQuestPresent[i]), strcat(lines,line);
    }
    ShowDialog(playerid,504,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Квесты",lines,"Выбор","Отмена");
    return 1;
}


stock StartScriptActor(playerid, scriptid, actorid) // Запускаем скрипт
{
    if(QuestInfo[playerid][ActorTimer]) KillTimer(QuestInfo[playerid][ActorTimer]), QuestInfo[playerid][ActorTimer] = 0;
    QuestInfo[playerid][ActorText] = 0;
    QuestInfo[playerid][ScriptQuest] = scriptid;
    SendScriptActor(playerid, scriptid, actorid);
    return 1;
}
stock SendScriptActor(playerid, scriptid, actorid) // Следующая реплика запускаетс
{
    // Джоне
    if(scriptid == 1)
    {
        QuestInfo[playerid][ActorTimer] = SetTimerEx("NextScriptActor", msCue1[QuestInfo[playerid][ActorText]], false, "dddd", playerid, scriptid, actorid, sizeof(scriptCue1));
        SendDynamicActorScript(actorid, playerid, scriptCue1[QuestInfo[playerid][ActorText]]);
    }
    else if(scriptid == 2)
    {
        QuestInfo[playerid][ActorTimer] = SetTimerEx("NextScriptActor", msCue2[QuestInfo[playerid][ActorText]], false, "dddd", playerid, scriptid, actorid, sizeof(scriptCue2));
        SendDynamicActorScript(actorid, playerid, scriptCue2[QuestInfo[playerid][ActorText]]);
    }

    // Дрейк
    else if(scriptid == 3)
    {
        QuestInfo[playerid][ActorTimer] = SetTimerEx("NextScriptActor", msCue3[QuestInfo[playerid][ActorText]], false, "dddd", playerid, scriptid, actorid, sizeof(scriptCue3));
        SendDynamicActorScript(actorid, playerid, scriptCue3[QuestInfo[playerid][ActorText]]);
    }
    else if(scriptid == 4)
    {
        QuestInfo[playerid][ActorTimer] = SetTimerEx("NextScriptActor", msCue4[QuestInfo[playerid][ActorText]], false, "dddd", playerid, scriptid, actorid, sizeof(scriptCue4));
        SendDynamicActorScript(actorid, playerid, scriptCue4[QuestInfo[playerid][ActorText]]);
    }
    else if(scriptid == 5)
    {
        QuestInfo[playerid][ActorTimer] = SetTimerEx("NextScriptActor", msCue5[QuestInfo[playerid][ActorText]], false, "dddd", playerid, scriptid, actorid, sizeof(scriptCue5));
        SendDynamicActorScript(actorid, playerid, scriptCue5[QuestInfo[playerid][ActorText]]);
    }
    else if(scriptid == 6)
    {
        QuestInfo[playerid][ActorTimer] = SetTimerEx("NextScriptActor", msCue6[QuestInfo[playerid][ActorText]], false, "dddd", playerid, scriptid, actorid, sizeof(scriptCue6));
        SendDynamicActorScript(actorid, playerid, scriptCue6[QuestInfo[playerid][ActorText]]);
    }
    else if(scriptid == 7)
    {
        QuestInfo[playerid][ActorTimer] = SetTimerEx("NextScriptActor", msCue7[QuestInfo[playerid][ActorText]], false, "dddd", playerid, scriptid, actorid, sizeof(scriptCue7));
        SendDynamicActorScript(actorid, playerid, scriptCue7[QuestInfo[playerid][ActorText]]);
    }
    return 1;
}
function NextScriptActor(playerid, scriptid, actorid, maxScript) // Обработчик следующей реплики
{
    if(QuestInfo[playerid][ActorTimer]) KillTimer(QuestInfo[playerid][ActorTimer]), QuestInfo[playerid][ActorTimer] = 0;
    QuestInfo[playerid][ActorText] ++;

    // Дополнительные действия у сценариев Дрейка
    if((scriptid == 3) && QuestInfo[playerid][ActorText] >= maxScript) showDialogStartQuest(playerid, 0), PlayerPlaySound(playerid,40405,0,0,0);
    if((scriptid == 4 || scriptid == 5 || scriptid == 6 || scriptid == 7) && QuestInfo[playerid][ActorText] == 2) showDialogStartQuest(playerid, 0), PlayerPlaySound(playerid,40405,0,0,0);


    if(QuestInfo[playerid][ActorText] >= maxScript) // Последняя реплика
    {
        if(BotTalkStat[playerid] == true) DeletePlayer3DTextLabel(playerid, BotTalk[playerid]), BotTalkStat[playerid] = false;
        if(BotTalkTimer[playerid]) KillTimer(BotTalkTimer[playerid]), BotTalkTimer[playerid] = 0;

        if(QuestInfo[playerid][ActorTimer]) KillTimer(QuestInfo[playerid][ActorTimer]), QuestInfo[playerid][ActorTimer] = 0;
    }
    else SendScriptActor(playerid, scriptid, actorid); // Следующая реплика
    return 1;
}


stock QuestActorJone(playerid) // Начинаем взаимодействовать с NPC квеста
{
    if(IsPlayerInRangeOfPoint(playerid,1.5, 1364.35242, -1682.73926, 13.47850) || IsPlayerInRangeOfPoint(playerid,1.5, 2121.7776,2709.5793,10.8203))
	{
        if(BotTalkTimer[playerid] || QuestInfo[playerid][ActorTimer]) return 1; // Если бот уже болтает - не прерываем его
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
                PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/jone/jone2.mp3",pos[0], pos[1], pos[2],6.0,true);
                return 1;
            }
            PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/jone/jone1.mp3",pos[0], pos[1], pos[2],6.0,true);
            StartScriptActor(playerid, 1, QuestInfo[playerid][QuestBot]);
        }
        else if(OnlineInfo[playerid][oInHandThing][0] == 196) // Принесли пакет (Квест выполнен)
        {
            new yesLoad = 1;
            if(GetPlayerQuanLoadVehicle(playerid) >= 2) yesLoad = 0;

            if(yesLoad == 0) SuccessMessage(playerid, "{99ff66}Вы выполнили задание и получили в подарок автомобиль\n{FF6347}Новый автомобиль не загружен, потому что у вас уже загружены транспортные средства\n\n{ff9000}Управление транспортом - Y >> Транспорт или /car");
            else SuccessMessage(playerid, "{99ff66}Вы выполнили задание и получили в подарок автомобиль\n\n{ff9000}Управление транспортом - Y >> Транспорт или /car");

            PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/jone/jone3.mp3",pos[0], pos[1], pos[2],6.0,true);
            StartScriptActor(playerid, 2, QuestInfo[playerid][QuestBot]);

            InHandClear(playerid);
            if(QuestInfo[playerid][VehicleQuest]) ACDestroyVehicle(QuestInfo[playerid][VehicleQuest]), QuestInfo[playerid][VehicleQuest] = 0;
            if(IsPlayerInRangeOfPoint(playerid,5.0, 1364.35242, -1682.73926, 13.47850)) GiveCar(playerid, freeSlot, 546, 1362.8092,-1658.9130,13.1072,269.5840, 0, QuestInfo[playerid][VehColorQuest], QuestInfo[playerid][VehColorQuest], yesLoad, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
            else if(IsPlayerInRangeOfPoint(playerid,5.0, 2121.7776,2709.5793,10.8203)) GiveCar(playerid, freeSlot, 546, 2118.9817,2729.5417,10.5447,270.2156, 0, QuestInfo[playerid][VehColorQuest], QuestInfo[playerid][VehColorQuest], yesLoad, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

            // Выполнили квест 0
            PlayerInfo[playerid][pQuest][3] = 3;
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
    if(!NoCompleteQuest(playerid, 3)) return 0; // Если квест уже пойден, не запускаем квест
    if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете пройти сейчас этот квест\n{cccccc}Вас преследует полиция");
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
        QuestInfo[playerid][QuestBotLabel] = CreateDynamic3DTextLabel("{cccccc}Джоне [ALT]",0xA9C4E4FF,1364.35242, -1682.73926, 13.47850 + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerid + 1, 0, playerid);
    
        // Vehicle
        QuestInfo[playerid][VehicleQuest] = PP_CreateVehicle(QuestInfo[playerid][VehicleQuest], 546, 1362.8092,-1658.9130,13.1072,269.5840, color1, color2, -1, 0, -1, 0.0);
    
        // Master Keys
        QuestInfo[playerid][LabelFirst] = CreateDynamic3DTextLabel("{ff9000}Отмычки [ALT]",0xA9C4E4FF,1366.066772, -1679.641357, 13.546929, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerid + 1, 0, playerid);
    }
    else if(zoneid == 1) // Las Venturas
    {
        // NPC
        QuestInfo[playerid][QuestBot] = CreateDynamicActor(44, 2121.7776,2709.5793,10.8203,357.4829, true, 100.0, playerid + 1, 0, playerid, 100.0, -1, 0);
        QuestInfo[playerid][QuestBotLabel] = CreateDynamic3DTextLabel("{cccccc}Джоне [ALT]",0xA9C4E4FF,2121.7776,2709.5793,10.8203 + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerid + 1, 0, playerid);
    
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
    if(QuestInfo[playerid][ActorTimer]) KillTimer(QuestInfo[playerid][ActorTimer]), QuestInfo[playerid][ActorTimer] = 0;
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

stock QuestActorDrake(playerid) // Начинаем взаимодействовать с NPC квеста
{
    if(IsPlayerInRangeOfPoint(playerid,3.0, 1590.3958,-2278.8374,13.5328) || IsPlayerInRangeOfPoint(playerid,3.0, 1731.7189,1440.1394,10.8767))
	{
        if(BotTalkTimer[playerid] || QuestInfo[playerid][ActorTimer]) return 1; // Если бот уже болтает - не прерываем его

        new actorid;
        if(IsPlayerInRangeOfPoint(playerid,3.0, 1590.3958,-2278.8374,13.5328)) actorid = ActorQuest1; // в LS
        else if(IsPlayerInRangeOfPoint(playerid,3.0, 1731.7189,1440.1394,10.8767)) actorid = ActorQuest2; // в LV
        new Float:pos[3];
        GetDynamicActorPos(actorid, pos[0], pos[1], pos[2]);

        if(NoCompleteQuest(playerid, 0)) return ErrorMessage(playerid, "{FF6347}Ошибка! Вы не прошли паспортный контроль в Аэропорту");
        if(NoCompleteQuest(playerid, 1))
        {
            SendDynamicActorMessage(actorid, playerid, "Заселись в отель, а потом подходи ко мне. Договорились?");
            PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/drake/drake0.mp3",pos[0], pos[1], pos[2],6.0,true);
            return 1;
        }
        if(NoCompleteQuest(playerid, 2))
        {
            if(PlayerInfo[playerid][pSex] == 1)
            {
                SendDynamicActorMessage(actorid, playerid, "Ты явно устал с дороги. Зайди в свой номер в отеле, а потом возвращайся");
                PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/drake/drake1.mp3",pos[0], pos[1], pos[2],6.0,true);
            }
            else
            {
                SendDynamicActorMessage(actorid, playerid, "Ты явно устала с дороги. Зайди в свой номер в отеле, а потом возвращайся");
                PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/drake/drake11.mp3",pos[0], pos[1], pos[2],6.0,true);
            }
            return 1;
        }

        if(PlayerInfo[playerid][pQwest] == 0)
        {
            PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/drake/drake2.mp3",pos[0], pos[1], pos[2],6.0,true);
            StartScriptActor(playerid, 3, actorid);
            PlayerInfo[playerid][pQwest] = 1;
        }
        else
        {
            switch(random(3))
            {
                case 0:
                {
                    PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/drake/drake3.mp3",pos[0], pos[1], pos[2],6.0,true);
                    StartScriptActor(playerid, 4, actorid);
                }
                case 1:
                {
                    if(PlayerInfo[playerid][pSex] == 1) 
                    {
                        PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/drake/drake4.mp3",pos[0], pos[1], pos[2],6.0,true);
                        StartScriptActor(playerid, 5, actorid);
                    }
                    else
                    {
                        PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/drake/drake44.mp3",pos[0], pos[1], pos[2],6.0,true);
                        StartScriptActor(playerid, 6, actorid);
                    }
                }
                case 2:
                {
                    PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/drake/drake5.mp3",pos[0], pos[1], pos[2],6.0,true);
                    StartScriptActor(playerid, 7, actorid);
                }
            }
        }
        return 1;
    }
    return 0;
}

CMD:clearqwest(playerid)
{
    if(server != 0) return 1;
    PlayerInfo[playerid][pQwest] = 0;
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

stock QuestCallMessage(i)
{
    // Jone первый звонок
    if(GetPVarInt(i,"qweststat") == 2)
    {	
        SetPVarInt(i, "MobileStat",2), SetPVarInt(i, "Mobile",2500), SetPVarInt(i, "taks",0);
        if(OnlineInfo[i][oShowInterface] == 2) CloseMenu(i), SmartfonCall(i);
        else ShowSmartfon(i);
        SendClientMessage(i, COLOR_GREY, "{AFAFAF}Входящий Вызов: {ccffff}Неизвестный");
        SetPlayerChatBubble(i,"смартфон звонит",COLOR_PURPLE,20.0,3000);
        around_player_audio(i, 23000, 0, 5.0, 0);
    }
    else if(GetPVarInt(i,"qweststat") == 3)
    {
        PlayAudioStreamForPlayer(i, "https://pears-test.ru/sound/characters/jone/jone0.mp3");
        SendClientMessage(i, COLOR_YELLOW,"Неизвестный Абонент (телефон): Мне дали твой номер и сказали ты можешь помочь");
        SetPVarInt(i,"qweststat",4), SetPVarInt(i,"qwesttime",3);
    }
    else if(GetPVarInt(i,"qweststat") == 4)
    {
            SendClientMessage(i, COLOR_YELLOW,"Неизвестный Абонент (телефон): Дельце не трудное и за него ты получишь вознаграждение");
            SetPVarInt(i,"qweststat",5), SetPVarInt(i,"qwesttime",3);
    }
    else if(GetPVarInt(i,"qweststat") == 5)
    {
            SendClientMessage(i, COLOR_YELLOW,"Неизвестный Абонент (телефон): Приезжай. Я скину тебе в навигатор точку GPS");
            SetPVarInt(i,"qweststat",6), SetPVarInt(i,"qwesttime",3);
    }
    else if(GetPVarInt(i,"qweststat") == 6)
    {
            SendClientMessage(i, COLOR_GREY, "{cc9999}Оператор: {AFAFAF}Абонент сбросил вызов!");
            hangup(i, 0), PlayerPlaySound(i, 1063, 0,0,0);
            SetPVarInt(i,"qweststat",7), SetPVarInt(i,"qwesttime",4);
    }
    else if(GetPVarInt(i,"qweststat") == 7)
    {	
        PlayerPlaySound(i, 1084, 0,0,0);
        SendClientMessage(i, COLOR_YELLOW, " SMS от Джоне: {99ff33}скинул точку в твой навигатор");

        if(PlayerInfo[i][pKomnataCity] == 3) CreateGps(i,2121.7776,2709.5793,10.8203, 0, 0, 5.0);
        else CreateGps(i, 1364.35242, -1682.73926, 13.47850, 0, 0, 5.0);

        ShowDialog(i,1700,DIALOG_STYLE_MSGBOX,"{99ff66}*","{99ff66}Добавлена точка в GPS навигатор","*","");
        SetPVarInt(i,"qweststat",0), SetPVarInt(i,"qwesttime",0);

        PlayerInfo[i][pQuest][3] = 1; // Джоне нам позвонил первый раз
        SaveQuest(i);

        // Запускаем подсказку о передвижении по серверу
        if(IsPlayerInRangeOfPoint(i,200.0,1613.4502,-2292.7754,13.5331) && GetPlayerVirtualWorld(i) == 0) SetPVarInt(i,"qweststat",9), SetPVarInt(i,"qwesttime",4);
        else if(IsPlayerInRangeOfPoint(i,200.0,1741.3041,1427.0760,10.8767) && GetPlayerVirtualWorld(i) == 0) SetPVarInt(i,"qweststat",10), SetPVarInt(i,"qwesttime",4);
    }
    else if(GetPVarInt(i,"qweststat") == 9)
    {
        FlyCameraPos(i,1570.383911, -2280.617187, 18.590723,  1567.874877, -2276.920654, 16.345813  ,900,800);
        SetPVarInt(i,"qweststat",1), SetPVarInt(i,"qwesttime",7);
        ShowDialog(i,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Как передвигаться по штату?\n\n{ff9000}Воспользуйтесь терминалом аренды скутеров, чтобы отправиться к первому квесту","*","");
    }
    else if(GetPVarInt(i,"qweststat") == 10)
    {
        FlyCameraPos(i,1709.974975, 1412.771484, 15.816736,  1712.994873, 1416.352539, 14.068523  ,900,800);
        SetPVarInt(i,"qweststat",1), SetPVarInt(i,"qwesttime",7);
        ShowDialog(i,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Как передвигаться по штату?\n\n{ff9000}Воспользуйтесь терминалом аренды скутеров, чтобы отправиться к первому квесту","*","");
    }

    // Jone второй звонок
    else if(GetPVarInt(i,"qweststat") == 11)
    {	
        SetPVarInt(i, "MobileStat",2), SetPVarInt(i, "Mobile",2501), SetPVarInt(i, "taks",0);
        if(OnlineInfo[i][oShowInterface] == 2) CloseMenu(i), SmartfonCall(i);
        else ShowSmartfon(i);
        SendClientMessage(i, COLOR_GREY, "{AFAFAF}Входящий Вызов: {ccffff}Неизвестный");
        SetPlayerChatBubble(i,"смартфон звонит",COLOR_PURPLE,20.0,3000);
        around_player_audio(i, 23000, 0, 5.0, 0);
    }
    else if(GetPVarInt(i,"qweststat") == 12)
    {
        PlayAudioStreamForPlayer(i, "https://pears-test.ru/sound/characters/jone/jone4.mp3");
        SendClientMessage(i, COLOR_YELLOW,"Джоне (телефон): Ну чё? Ты приедешь?");
        SetPVarInt(i,"qweststat",13), SetPVarInt(i,"qwesttime",2);
    }
    else if(GetPVarInt(i,"qweststat") == 13)
    {
        SendClientMessage(i, COLOR_YELLOW,"Джоне (телефон): Давай, я жду тебя");
        SetPVarInt(i,"qweststat",14), SetPVarInt(i,"qwesttime",2);
    }
    else if(GetPVarInt(i,"qweststat") == 14)
    {
        SendClientMessage(i, COLOR_GREY, "{cc9999}Оператор: {AFAFAF}Абонент сбросил вызов!");
        hangup(i, 0), PlayerPlaySound(i, 1063, 0,0,0);
        SetPVarInt(i,"qweststat",0), SetPVarInt(i,"qwesttime",0);

        PlayerInfo[i][pQuest][3] = 2; // Джоне нам позвонил второй раз
        SaveQuest(i);
    }

    // Ремон Транспорта (Квест от Джоне)
    else if(GetPVarInt(i,"qweststat") == 15)
    {
        if(PlayerInfo[i][pSex] == 1) 
        {
            PlayAudioStreamForPlayer(i, "https://pears-test.ru/sound/characters/jone/jone_repair0.mp3");
            SendClientMessage(i, COLOR_YELLOW,"Джоне (голосовое): Ну как тебе авто? Уже успел сломать?");
        }
        else 
        {
            PlayAudioStreamForPlayer(i, "https://pears-test.ru/sound/characters/jone/jone_repair00.mp3");
            SendClientMessage(i, COLOR_YELLOW,"Джоне (голосовое): Ну как тебе авто? Уже успела сломать?");
        }
        SetPVarInt(i,"qweststat",16), SetPVarInt(i,"qwesttime",3);
    }
    else if(GetPVarInt(i,"qweststat") == 16)
    {
        PlayAudioStreamForPlayer(i, "https://pears-test.ru/sound/characters/jone/jone_repair1.mp3");
        SendClientMessage(i, COLOR_YELLOW,"Джоне (голосовое): Ну ты даёшь.. У тебя в машине лежит ремкомплект");

        SetPVarInt(i,"qweststat",17), SetPVarInt(i,"qwesttime",3);
    }
    else if(GetPVarInt(i,"qweststat") == 17)
    {
        SendClientMessage(i, COLOR_YELLOW,"Джоне (голосовое): Подойди к багажнику, открой инвентарь и выбери вкладку <<Багажник>>");
        SetPVarInt(i,"qweststat",0), SetPVarInt(i,"qwesttime",0);
    }
    return 1;
}

stock dialogCase_StartQuest(playerid, dialogid, response, listitem)
{
    if(dialogid == 504)
	{
		if(response)
		{
			if(listitem < 0 || listitem >= MAX_QUEST) return 1;
			if(NoCompleteQuest(playerid, listitem))
			{
                DP[1][playerid] = listitem;
				if(listitem == 0) ShowDialog(playerid,505,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Как пройти этот квест?\n\nПросто пройдите паспортный контроль в Аэропорту","Ок","");
				else if(listitem == 1) ShowDialog(playerid,505,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Как пройти этот квест?\n\nОтправляйтесь в отель возле аэропорта и снимите номер в отеле","Ок","");
				else if(listitem == 2) ShowDialog(playerid,505,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Как пройти этот квест?\n\nОтправляйтесь в номер отеля и поухаживайте за своим персонажем","Ок","");
				else if(listitem == 3) ShowDialog(playerid,505,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Хотите отметить этот квест в своём GPS навигаторе?","Да","Нет");
				else if(listitem == 4)
                {
                    format(lines,sizeof(lines),""); // Очищаем Lines
    	            format(line,sizeof(line),"{ffcc66}Как пройти этот квест?"), strcat(lines,line);
                    format(line,sizeof(line),"\n{cccccc}Этот квест запускается самостоятельно при выполнении необходимых условий"), strcat(lines,line);
                    format(line,sizeof(line),"\n{cccccc}Но если вам не терпится пройти его сейчас, вы можете выполнить следующие действия"), strcat(lines,line);
                    format(line,sizeof(line),"\n\n{ffcc66}1. Положите в багажнике автомобиля Рем. Комплект"), strcat(lines,line);
                    format(line,sizeof(line),"\n{ffcc66}2. Затем повредите автомобиль, сидя за рулём, до 400 хп и квест сразу запустится"), strcat(lines,line);
                    ShowDialog(playerid,505,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"Ок","");
                }
				
				else ErrorText(playerid, "{FF6347}Подробная информация об этом квесте не заполнена"), showDialogStartQuest(playerid, DP[0][playerid]);
			}
			else ErrorText(playerid, "{FF6347}Вы прошли этот квест"), showDialogStartQuest(playerid, DP[0][playerid]);
		}
		else
		{
			if(DP[0][playerid] == 1) cmd_quest(playerid);
		}
	}
    else if(dialogid == 505) 
	{
        new questId = DP[1][playerid];
        if(response)
        {
            if(questId == 3)
            {
                if(PlayerInfo[playerid][pKomnataCity] == 3) CreateGps(playerid,2121.7776,2709.5793,10.8203, 0, 0, 5.0);
				else CreateGps(playerid, 1364.35242, -1682.73926, 13.47850, 0, 0, 5.0);
				ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Квест отмечен в вашем GPS навигаторе","*","");
            }
            else showDialogStartQuest(playerid, DP[0][playerid]);
        }
        else showDialogStartQuest(playerid, DP[0][playerid]);
    }
    return 1;
}
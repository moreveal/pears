
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
    "Исследование гробницы",
    "Отдых в клубе",
    "Последствия",
    "Знакомство с едой",
    "Знакомство с ноутбуком"
};
new StartQuestPresent[][] =
{
    "",
    "",
    "Деньги",
    "Транспорт",
    "",
    "Кейс",
    "",
    "",
    "Деньги",
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
    VehModel, // Model vehicle
    ActorTimer, // Timer Actor Script
    ActorText, // Script ID Text Actor
    Text3D:LabelFirst, // 3d text 1
    bool:ThingOne,
    UnixCall
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
    else if(questId == 5 && PlayerInfo[playerid][pQuest][questId] < 8) return 1; // Археологические раскопки
    else if(questId == 6 && PlayerInfo[playerid][pQuest][questId] < 4) return 1; // Секас
    else if(questId == 7 && PlayerInfo[playerid][pQuest][questId] < 5) return 1; // Мед.карта и лечение болезни
    else if(questId == 8 && PlayerInfo[playerid][pQuest][questId] < 4) return 1; // Хавка
    else if(questId == 9 && PlayerInfo[playerid][pQuest][questId] < 5) return 1; // Ноут
    return 0;
}

stock showDialogStartQuest(playerid, stat)
{
    DP[0][playerid] = stat;

    new line[214],lines[4096];
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

    // Брюс
    else if(scriptid == 8)
    {
        QuestInfo[playerid][ActorTimer] = SetTimerEx("NextScriptActor", msCue8[QuestInfo[playerid][ActorText]], false, "dddd", playerid, scriptid, actorid, sizeof(scriptCue8));
        SendDynamicActorScript(actorid, playerid, scriptCue8[QuestInfo[playerid][ActorText]]);
    }
    else if(scriptid == 9)
    {
        QuestInfo[playerid][ActorTimer] = SetTimerEx("NextScriptActor", msCue9[QuestInfo[playerid][ActorText]], false, "dddd", playerid, scriptid, actorid, sizeof(scriptCue9));
        SendDynamicActorScript(actorid, playerid, scriptCue9[QuestInfo[playerid][ActorText]]);
    }

    // Доктор
    else if(scriptid == 10)
    {
        QuestInfo[playerid][ActorTimer] = SetTimerEx("NextScriptActor", msCue10[QuestInfo[playerid][ActorText]], false, "dddd", playerid, scriptid, actorid, sizeof(scriptCue10));
        SendDynamicActorScript(actorid, playerid, scriptCue10[QuestInfo[playerid][ActorText]]);
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
        if(BotTalkStat[playerid] > 0) DeletePlayer3DTextLabel(playerid, BotTalk[playerid]), BotTalkStat[playerid] = 0;
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
                SendDynamicActorMessage(playerid, QuestInfo[playerid][QuestBot], "Ну и где пакет? Делай свою работу");
                PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone2.mp3",pos[0], pos[1], pos[2],6.0,true);
                return 1;
            }
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone1.mp3",pos[0], pos[1], pos[2],6.0,true);
            StartScriptActor(playerid, 1, QuestInfo[playerid][QuestBot]);
        }
        else if(OnlineInfo[playerid][oInHandThing][0] == 196) // Принесли пакет (Квест выполнен)
        {
            new yesLoad = 1;
            if(GetPlayerQuanLoadVehicle(playerid) >= 2) yesLoad = 0;

            if(yesLoad == 0) SuccessMessage(playerid, "{99ff66}Вы выполнили задание и получили в подарок автомобиль\n{FF6347}Новый автомобиль не загружен, потому что у вас уже загружены транспортные средства\n\n{ff9000}Управление транспортом - Y >> Транспорт или /car");
            else SuccessMessage(playerid, "{99ff66}Вы выполнили задание и получили в подарок автомобиль\n\n{ff9000}Управление транспортом - Y >> Транспорт или /car");

            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone3.mp3",pos[0], pos[1], pos[2],6.0,true);
            StartScriptActor(playerid, 2, QuestInfo[playerid][QuestBot]);

            InHandClear(playerid);
            if(QuestInfo[playerid][VehicleQuest]) ACDestroyVehicle(QuestInfo[playerid][VehicleQuest]), QuestInfo[playerid][VehicleQuest] = 0;
            if(IsPlayerInRangeOfPoint(playerid,5.0, 1364.35242, -1682.73926, 13.47850)) GiveCar(playerid, freeSlot, QuestInfo[playerid][VehModel], 1362.8092,-1658.9130,13.1072,269.5840, 0, QuestInfo[playerid][VehColorQuest], QuestInfo[playerid][VehColorQuest], yesLoad, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
            else if(IsPlayerInRangeOfPoint(playerid,5.0, 2121.7776,2709.5793,10.8203)) GiveCar(playerid, freeSlot, QuestInfo[playerid][VehModel], 2118.9817,2729.5417,10.5447,270.2156, 0, QuestInfo[playerid][VehColorQuest], QuestInfo[playerid][VehColorQuest], yesLoad, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

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

    if(IsPlayerInRangeOfPoint(playerid,10.0, 1362.8092,-1658.9130,13.1072)) CreateGps(playerid, 1364.35242, -1682.73926, 13.47850, 0, 0, 5.0); // LS
    else if(IsPlayerInRangeOfPoint(playerid,10.0, 2118.9817,2729.5417,10.5447)) CreateGps(playerid, 2121.7776,2709.5793,10.8203, 0, 0, 5.0); // LV
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
		ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0, false, true, true, false, false);
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы взяли отмычки\n{0088ff}Подойдите к машине и нажмите кнпоку ALT, чтобы взломать дверь","*","");
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мне нужно подойти к машине и взломать дверь [ Кнопка ALT возле транспорта ]");

        QuestInfo[playerid][ThingOne] = true;
        return 1;
    }
    return 0;
}

stock QuestActorBruce(playerid) // Начинаем взаимодействовать с NPC квеста Археалогия
{
    if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете пройти сейчас этот квест\n{cccccc}Вас преследует полиция");

    if(PlayerInfo[playerid][pQuest][5] <= 1)
    {
        if(BotTalkTimer[playerid] || QuestInfo[playerid][ActorTimer]) return 1; // Если бот уже болтает - не прерываем его
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/bruce/bruce0.mp3",-338.6526, 1730.2946, 42.9321,6.0,true);
        StartScriptActor(playerid, 8, BotPears[47]);
        PlayerInfo[playerid][pQuest][5] = 2;
        CreateGps(playerid, -333.0125,1724.6714,42.7950, 0, 0, 5.0);
    }
    else if(PlayerInfo[playerid][pQuest][5] == 2)
    {
        if(BotTalkTimer[playerid] || QuestInfo[playerid][ActorTimer]) return 1; // Если бот уже болтает - не прерываем его
        if(get_invent4(playerid,44,0) == 0 || get_invent4(playerid,90,0) == 0 || get_invent4(playerid,13,0) == 0)
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/bruce/bruce1.mp3",-338.6526, 1730.2946, 42.9321,6.0,true);
            SendDynamicActorMessage(playerid, BotPears[47], "Ну и чего? Говорю: зайди в вагончик, купи монтировку, верёвку, лопату и не беси меня", 8000);
            CreateGps(playerid, -333.0125,1724.6714,42.7950, 0, 0, 5.0);
        }
        else
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/bruce/bruce2.mp3",-338.6526, 1730.2946, 42.9321,6.0,true);
            StartScriptActor(playerid, 9, BotPears[47]);
            PlayerInfo[playerid][pQuest][5] = 4;
            CreateGps(playerid, -293.3882,1827.2743,43.5926, 0, 0, 5.0);
        }
    }
    else if(PlayerInfo[playerid][pQuest][5] == 4)
    {
        if(BotTalkTimer[playerid] || QuestInfo[playerid][ActorTimer]) return 1; // Если бот уже болтает - не прерываем его
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/bruce/bruce3.mp3",-338.6526, 1730.2946, 42.9321,6.0,true);
        SendDynamicActorMessage(playerid, BotPears[47], "Прохлаждаешься? Иди работай!");
    }
    else if((PlayerInfo[playerid][pQuest][5] == 4 || PlayerInfo[playerid][pQuest][5] == 5) && !IsPlayerInRangeOfPoint(playerid,5.0,-338.6526, 1730.2946, 42.9321))
    {
        if(BotTalkTimer[playerid] || QuestInfo[playerid][ActorTimer]) return 1; // Если бот уже болтает - не прерываем его
        if(PlayerInfo[playerid][pSex] == 1)
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/bruce/bruce4.mp3");
            SendClientMessage(playerid, COLOR_YELLOW,"Брюс (голосовое): Нашёл что-нибудь ценное? Смотри там у меня. Всё что найдёшь принадлежит компании");
        }
        else
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/bruce/bruce4w.mp3");
            SendClientMessage(playerid, COLOR_YELLOW,"Брюс (голосовое): Нашла что-нибудь ценное? Смотри там у меня. Всё что найдёшь принадлежит компании");
        }
        SaveQuest(playerid);
    }
    else if(PlayerInfo[playerid][pQuest][5] == 6 && !IsPlayerInRangeOfPoint(playerid,5.0,-338.6526, 1730.2946, 42.9321))
    {
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/bruce/bruce5.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Брюс (голосовое): Эй черенок. Неси все ценности в вагончик и получишь свою оплату");
        CreateGps(playerid, -336.2932,1725.8201,42.8567, 0, 0, 2.0);
    }
    else if(PlayerInfo[playerid][pQuest][5] == 7)
    {
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/bruce/bruce6.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Брюс (голосовое): Ну.. молодчага. Будем на связи.. Бывай");
        PlayerInfo[playerid][pQuest][5] = 8;
        SaveQuest(playerid);

        // Выдаём кейс
        GiveGiftQuest(playerid);

        // Запускаем следующий квест
        if(PlayerInfo[playerid][pSex] == 1) SetPVarInt(playerid,"qweststat",18), SetPVarInt(playerid,"qwesttime",20);
        else ShowQwest(playerid, 8);
    }
    else if(PlayerInfo[playerid][pQuest][5] >= 8) // Реплики, когда мы полностью прошли квест
    {
        if(BotTalkTimer[playerid] || QuestInfo[playerid][ActorTimer]) return 1; // Если бот уже болтает - не прерываем его

        switch(random(3))
        {
            case 0:
            {
                PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/bruce/bruce7.mp3",-338.6526, 1730.2946, 42.9321,6.0,true);
                SendDynamicActorMessage(playerid, BotPears[47], "Ну чего стоишь? Работы немеренно!");
            }
            case 1:
            {
                PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/bruce/bruce8.mp3",-338.6526, 1730.2946, 42.9321,6.0,true);
                SendDynamicActorMessage(playerid, BotPears[47], "Не стой у меня над душой");
            }
            case 2:
            {
                PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/bruce/bruce9.mp3",-338.6526, 1730.2946, 42.9321,6.0,true);
                SendDynamicActorMessage(playerid, BotPears[47], "Мне не до тебя сейчас, иди работай");
            }
        }
    }
    return 1;
}

stock QuestActorJoneSeks(playerid)
{
    if(!NoCompleteQuest(playerid, 6)) return 0; // Если квест уже пойден, не запускаем квест
    if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете пройти сейчас этот квест\n{cccccc}Вас преследует полиция");

    if(PlayerInfo[playerid][pQuest][6] == 2)
    {
        new b = GetPlayerVirtualWorld(playerid)-3000;
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: А мне понравилось.. Надо будет ещё сюда придти");
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Теперь вы можете выйти из клуба для продолжения квеста\n{FF6347}Рекомендация! {666666}Продолжить квест, иначе ваш персонаж останется больным","*","");
        CreateGps(playerid, BizzInfo[b][bInteriorX], BizzInfo[b][bInteriorY], BizzInfo[b][bInteriorZ], 0, 0, 5.0);
        PlayerInfo[playerid][pQuest][6] = 3;
    }
    else if(PlayerInfo[playerid][pQuest][6] == 3)
    {
        PlayerInfo[playerid][pQuest][6] = 4;
        ShowQwest(playerid, 7);
    }
    SaveQuest(playerid);
    return 1;
}

stock ShowInfoEnterBizQuest(playerid, b)
{
    if(BizzInfo[b][bShluha] == 0) return ErrorMessage(playerid,"{ff6347}К сожалению в этом клубе отсутствует проститутка\n{ffcc66}Вам необходимо самостоятельно найти её в другом клубе\n\nНайдите другой клуб в вашем GPS [ Y > GPS > Развлечениея > Клубы ]");
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Подойдите к бару, купите алкоголь и выпейте","*","");
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Так, и где же тут бар? [ Подойдите к бару, купите алкоголь и выпейте ]");
    CreateGps(playerid, BizzInfo[b][bBarX],BizzInfo[b][bBarY],BizzInfo[b][bBarZ], 0, 0, 2.0);
    return 1;
}

stock ShowBuyAcloQuest(playerid, worldid)
{
    if(PlayerInfo[playerid][pQuest][6] != 1) return 1;
    new b = worldid-3000;
    if(BizType(b) == 12) // Type 12, значит только: Бар / Клуб
    {
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Найдите в клубе проститутку и подойдите к ней","*","");
        CreateGps(playerid, BizzInfo[b][bShluhaCord][0],BizzInfo[b][bShluhaCord][1],BizzInfo[b][bShluhaCord][2], 0, 0, 2.0);
    }
    return 1;
}

stock QuestActorJoneMed(playerid)
{
    if(!NoCompleteQuest(playerid, 7)) return 0; // Если квест уже пойден, не запускаем квест
    if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете пройти сейчас этот квест\n{cccccc}Вас преследует полиция");

    if(PlayerInfo[playerid][pQuest][7] == 1)
    {
        if(get_invent4(playerid,63,0) == 0)
        {
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Подойдите на ресепшен и оформите мед.карту","*","");
            CreateGps(playerid, 1391.4603, -12.2399, 1000.9217, 0, 0, 5.0);
        }
        else
        {
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Зайдите в кабинет врача и начните с ним диалог","*","");
            CreateGps(playerid, 1376.4359, -13.8744, 1000.9217, 0, 0, 5.0);
        }
    }
    else if(PlayerInfo[playerid][pQuest][7] == 2)
    {
        new slotillness = getillness(playerid,1);
        if(slotillness == -1)
        {
            ErrorMessage(playerid,"{ff6347}Я здоров, как мне пройти квест дальше? Надо снова ехать в клуб и заразится!");
            return 0;
        }

        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/doctor/doctor0.mp3",1377.5765,-21.8737,1000.9217,6.0,true);
        // Тут идёт озвучка медика, первый приём
        StartScriptActor(playerid, 10, BotPears[416]);
        PlayerInfo[playerid][pIllnessStat][slotillness] = 1;
        update_illness(playerid, slotillness);
        PlayerInfo[playerid][pQuest][7] = 3;
        SaveQuest(playerid);
    }
    else if(PlayerInfo[playerid][pQuest][7] == 3)
    {
        if(GetPlayerVirtualWorld(playerid) == 0) SetPVarInt(playerid,"qweststat",37), SetPVarInt(playerid,"qwesttime",5);
        else if(GetPlayerVirtualWorld(playerid) >= 123 && GetPlayerVirtualWorld(playerid) <= 132)
        {
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Доктор сказал купить Хламидиуберин");
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Подойдите к кассе и купите таблетки Хламидиуберин","*","");
        }
    }
    else if(PlayerInfo[playerid][pQuest][7] == 4)
    {
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/doctor/doctor2.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Доктор (голосовое): Обязательно пропейте полный курс лечения. Важно принять все таблетки");
        PlayerInfo[playerid][pQuest][7] = 5;
        SaveQuest(playerid);

        // Запускаем квест знакомство с едой
        ShowQwest(playerid, 8, 10); // Через 10 сек запустится
    }
    return 1;
}

stock QuestActorJoneHavka(playerid) // Начинаем взаимодействовать с NPC квеста Археалогия
{
    if(!NoCompleteQuest(playerid, 8)) return 0; // Если квест уже пойден, не запускаем квест
    if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете пройти сейчас этот квест\n{cccccc}Вас преследует полиция");

    new b = GetPlayerVirtualWorld(playerid)-3000;
    if(PlayerInfo[playerid][pQuest][8] == 1)
    {
        CreateGps(playerid, BizzInfo[b][bBarX],BizzInfo[b][bBarY],BizzInfo[b][bBarZ], 0, 0, 5.0);
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Покушать хочется. Закажу себе большой Набор");

        new lines[300];
        format(lines,sizeof(lines),"{ffcc66}Подойдите к кассе и закажите себе {ff9000}набор с едой\
                                \n\n{FF6347}Внимание! {ffcc66}Обязательно купите большой Набор\
                                \n{ffcc66}Квест покажет вам, как взаимодействовать с предметами");
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
    }
    else if(PlayerInfo[playerid][pQuest][8] == 2)
    {
        SendClientMessage(playerid,COLOR_GREY,"{0088ff}[ Квест ] {ffcc66}Как кушать?");
        SendClientMessage(playerid,COLOR_GREY,"{ffcc66}- Положите поднос на стол [ Кнопка F ]");
        SendClientMessage(playerid,COLOR_GREY,"{ffcc66}- Затем сядьте на стул или диван, рядом с подносом [ Кнопка - ALT ]");
        SendClientMessage(playerid,COLOR_GREY,"{ffcc66}- После откройте инвентарь и выберите в разделе << Рядом >> ваш поднос");
        SendClientMessage(playerid,COLOR_GREY,"{ffcc66}- Ваш поднос будет отмечен белым фоном, в отличии от других");
        PlayerInfo[playerid][pQuest][8] = 3;
    }
    else if(PlayerInfo[playerid][pQuest][8] == 3)
    {
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Ваш персонаж наелся\
                                                                \n{ffcc66}Теперь вы можете отправиться на улицу\
                                                                \n\n{99ff66}Подсказка:\
                                                                \n{ffcc66}- Если вы не будете кормить вашего персонажа, то он начнёт терять хп\
                                                                \n{ffcc66}- Если будете полностью игнорировать желание покушать, персонаж заболеет","*","");

        SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Я покушал%s, нужно заняться чем-то или ждать звонка от Джони", gender(playerid));
        PlayerInfo[playerid][pQuest][8] = 4;
        SaveQuest(playerid);

        // Выдаём деньги на руки
        oGivePlayerMoney(playerid, 5000);

        // Запускаем квест знакомство с ноутбуком
        ShowQwest(playerid, 9, 10); // Следующий квест через 10 секунд
    }
    return 1;
}

stock QuestHavkaSitHelp(playerid)
{
    new world = GetPlayerVirtualWorld(playerid);
    new b = world-3000;

    if(BizType(b) == 13 // Type 13, значит только: Закусочные
	    && PlayerInfo[playerid][pQuest][8] == 3)
    {
        new lines[300];
        format(lines,sizeof(lines),"{ffcc66}Откройте инвентарь [ Кнопка N ]\
                                    \n{ffcc66}Затем выберите ваш Набор во вкладке << Рядом >>\
                                    \n{99ff66}Подсказка: {ffcc66}Ваш набор будет выделяться белым фоном");
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
    }
    return 1;
}

stock QuestActorJoneNotebook(playerid) // Начинаем взаимодействовать с NPC квеста Археалогия
{
    if(!NoCompleteQuest(playerid, 9)) return 0; // Если квест уже пойден, не запускаем квест
    if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете пройти сейчас этот квест\n{cccccc}Вас преследует полиция");

    if(PlayerInfo[playerid][pQuest][9] == 1) // Вот эта шляпа не работает (Видимо должно показывать при входе)
    {
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Подойдите к кассе и купите ноутбук","*","");
    }
    else if(PlayerInfo[playerid][pQuest][9] == 2) // Просит взять в руки ноутбук после покупки
    {
        SetPVarInt(playerid,"qweststat",38), SetPVarInt(playerid,"qwesttime",3);
        PlayerInfo[playerid][pQuest][9] = 3;
        SaveQuest(playerid);
    }
    return 1;
}

stock OpenStartQuest(playerid, zoneid) // Запускаем зону квеста
{
    if(!NoCompleteQuest(playerid, 3)) return 0; // Если квест уже пойден, не запускаем квест
    if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете пройти сейчас этот квест\n{cccccc}Вас преследует полиция");
    if(QuestInfo[playerid][QuestBot]) return 0; // Квест уже запущен
    if(get_invent2(playerid, 156, 0) <= 0) return 0; // нет водительских прав

    if(QuanPlayerStartQuest >= MAX_PLAYERS_START_QUEST) return ErrorMessage(playerid, "{FF6347}В данный момент этот квест проходит большое количество игроков\n\n{cccccc}Извините.. мы не можем запустить этот квест для вас\nПриходите немного позже, когда количество игроков проходящих этот квест уменьшится");
    
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        SetVehicleVirtualWorld(vehicleid, playerid + 1), S_SetPlayerVirtualWorld(playerid, playerid + 1, 0);
        LinkVehicleToInterior(vehicleid, 0), PPSetPlayerInterior(playerid, 0);
    }
    else
    {
        S_SetPlayerVirtualWorld(playerid, playerid + 1, 0);
        PPSetPlayerInterior(playerid, 0);
    }

    // Color Vehicle
    new color1 = 1 + random(254);
    new color2 = color1;
    QuestInfo[playerid][VehColorQuest] = color1;

    // Reset Variables
    QuestInfo[playerid][ScriptQuest] = 0;
    DestroyDetailsQuest(playerid);

    if(QuestInfo[playerid][VehModel] == 0)
    {
        switch(random(7))
        {
            case 0: QuestInfo[playerid][VehModel] = 558; // uranus
            case 1: QuestInfo[playerid][VehModel] = 559; // jester
            case 2: QuestInfo[playerid][VehModel] = 561; // stratum
            case 3: QuestInfo[playerid][VehModel] = 562; // elegy
            case 4: QuestInfo[playerid][VehModel] = 565; // flash
            case 5: QuestInfo[playerid][VehModel] = 550; // sunrise
            case 6: QuestInfo[playerid][VehModel] = 402; // buffalo
        }
    }

    if(zoneid == 0) // Los Santos
    {
        // NPC
        QuestInfo[playerid][QuestBot] = CreateDynamicActor(353, 1364.35242, -1682.73926, 13.47850, 5.0, true, 100.0, playerid + 1, 0, playerid, 100.0, -1, 0);
        QuestInfo[playerid][QuestBotLabel] = CreateDynamic3DTextLabel("{cccccc}Джоне [ALT]",0xA9C4E4FF,1364.35242, -1682.73926, 13.47850 + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerid + 1, 0, playerid);
    
        // Vehicle
        QuestInfo[playerid][VehicleQuest] = PP_CreateVehicle(QuestInfo[playerid][VehModel], 1362.8092,-1658.9130,13.1072,269.5840, color1, color2, -1, 0, -1, 0.0);
    
        // Master Keys
        QuestInfo[playerid][LabelFirst] = CreateDynamic3DTextLabel("{ff9000}Отмычки [ALT]",0xA9C4E4FF,1366.066772, -1679.641357, 13.546929, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerid + 1, 0, playerid);
    }
    else if(zoneid == 1) // Las Venturas
    {
        // NPC
        QuestInfo[playerid][QuestBot] = CreateDynamicActor(353, 2121.7776,2709.5793,10.8203,357.4829, true, 100.0, playerid + 1, 0, playerid, 100.0, -1, 0);
        QuestInfo[playerid][QuestBotLabel] = CreateDynamic3DTextLabel("{cccccc}Джоне [ALT]",0xA9C4E4FF,2121.7776,2709.5793,10.8203 + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerid + 1, 0, playerid);
    
        // Vehicle
        QuestInfo[playerid][VehicleQuest] = PP_CreateVehicle(QuestInfo[playerid][VehModel], 2118.9817,2729.5417,10.5447,270.2156, color1, color2, -1, 0, -1, 0.0);
    
        // Master Keys
        QuestInfo[playerid][LabelFirst] = CreateDynamic3DTextLabel("{ff9000}Отмычки [ALT]",0xA9C4E4FF,2124.882568, 2711.710449, 10.820312, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerid + 1, 0, playerid);
    }

    // Car Information
    SetVehicleVirtualWorld(QuestInfo[playerid][VehicleQuest], playerid + 1);
    VehInfo[QuestInfo[playerid][VehicleQuest]][vCarLock] = 1;
	SetVehicleParamsForPlayer(QuestInfo[playerid][VehicleQuest],playerid, false, true);

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
		    LinkVehicleToInterior(vehicleid, 0), PPSetPlayerInterior(playerid, 0);

            NoCollisionForAll(playerid, 0); // Отключаем коллизию на 20 сек при выезде из зоны
        }
        else
        {
            S_SetPlayerVirtualWorld(playerid, 0, 0);
            PPSetPlayerInterior(playerid, 0);

            // Спавним личные тачки при выходе из зоны квеста
            RespawnPersonalVehicle(playerid);
        }
            
        // Выезжаем после успешного прохождения Jone и запускаем звонок с Археологических раскопок
        if(!NoCompleteQuest(playerid, 3) && NoCompleteQuest(playerid, 5)) ShowQwest(playerid, 5);
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
            SendDynamicActorMessage(playerid, actorid, "Заселись в отель, а потом подходи ко мне. Договорились?");
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/drake/drake0.mp3",pos[0], pos[1], pos[2],6.0,true);
            return 1;
        }
        if(NoCompleteQuest(playerid, 2))
        {
            if(PlayerInfo[playerid][pSex] == 1)
            {
                SendDynamicActorMessage(playerid, actorid, "Ты явно устал с дороги. Зайди в свой номер в отеле, а потом возвращайся");
                PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/drake/drake1.mp3",pos[0], pos[1], pos[2],6.0,true);
            }
            else
            {
                SendDynamicActorMessage(playerid, actorid, "Ты явно устала с дороги. Зайди в свой номер в отеле, а потом возвращайся");
                PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/drake/drake11.mp3",pos[0], pos[1], pos[2],6.0,true);
            }
            return 1;
        }

        if(PlayerInfo[playerid][pQwest] == 0)
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/drake/drake2.mp3",pos[0], pos[1], pos[2],6.0,true);
            StartScriptActor(playerid, 3, actorid);
            PlayerInfo[playerid][pQwest] = 1;
        }
        else
        {
            switch(random(3))
            {
                case 0:
                {
                    PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/drake/drake3.mp3",pos[0], pos[1], pos[2],6.0,true);
                    StartScriptActor(playerid, 4, actorid);
                }
                case 1:
                {
                    if(PlayerInfo[playerid][pSex] == 1) 
                    {
                        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/drake/drake4.mp3",pos[0], pos[1], pos[2],6.0,true);
                        StartScriptActor(playerid, 5, actorid);
                    }
                    else
                    {
                        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/drake/drake44.mp3",pos[0], pos[1], pos[2],6.0,true);
                        StartScriptActor(playerid, 6, actorid);
                    }
                }
                case 2:
                {
                    PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/drake/drake5.mp3",pos[0], pos[1], pos[2],6.0,true);
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
	if(PlayerInfo[playerid][pSoska] < 15) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    new tmp[24],questid;
	if(sscanf(params, "s[24]i",tmp,questid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Очистить начальный квест игрока [ /clearquest ID Квест (0 - все квесты) ]");
    new giveplayerid = ReturnUser(tmp, 1);
    if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Этого игрока нет в сети");

    new string[160];
    if(questid == 0)
    {
        for(new i = 0; i < MAX_QUEST; i++) PlayerInfo[giveplayerid][pQuest][i] = 0;
        format(string, sizeof(string), " [ ADM ]: %s очистил %s все начальные квесты",PlayerInfo[playerid][pName] ,PlayerInfo[giveplayerid][pName]);
        ABroadCast(COLOR_ADM,string,1);
        format(string, sizeof(string), "* Администратор %s очистил все ваши начальные квесты", PlayerInfo[playerid][pName]);
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
        AdminLog("clearquest", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], 0, "Очистил все начальные квесты");
    }
    else if(questid >= 1 && questid <= MAX_QUEST)
    {
        PlayerInfo[giveplayerid][pQuest][questid - 1] = 0;
        format(string, sizeof(string), " [ ADM ]: %s очистил %s начальный квест id %d",PlayerInfo[playerid][pName] ,PlayerInfo[giveplayerid][pName], questid);
        ABroadCast(COLOR_ADM,string,1);
        format(string, sizeof(string), "* Администратор %s очистил ваш начальный квест id %d", PlayerInfo[playerid][pName], questid);
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
        AdminLog("clearquest", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], questid, "Очистил начальный квест");
    }
    else return ErrorMessage(playerid, "{FF6347}Квеста под этим id не существует");
    SaveQuest(giveplayerid);
    return 1;
}

stock LoadPlayerQuest(playerid)
{
    new string_mysql[200];
    cache_get_value_name(0, "Quest", string_mysql, sizeof(string_mysql)); // Берём из бд строку

	new arrCoords[MAX_QUEST][MAX_QUEST * 2];
	split(string_mysql, arrCoords, ','); // Делим её

    for(new i = 0; i < MAX_QUEST; i++) PlayerInfo[playerid][pQuest][i] = strval(arrCoords[i]); // Записываем в переменные
    return 1;
}

stock SaveQuest(playerid) // Сохраняем информацию о квестах
{
    // Записываем переменные в одну строку
    new part[200];
    for(new i = 0; i < MAX_QUEST; i++)
    {
        if(i == 0) format(part,sizeof(part),"%d", PlayerInfo[playerid][pQuest][i]);
        else format(part,sizeof(part),"%s,%d", part, PlayerInfo[playerid][pQuest][i]);
    }

    // Сохраняем
    new string_mysql[400];
    format(string_mysql, sizeof(string_mysql), "UPDATE `pp_igroki` SET `Quest`= '%s' WHERE `user_id`='%d'", part, PlayerInfo[playerid][pID]);
    query_empty(pearsq, string_mysql); // 53 + 11 +
    return 1;
}

stock QuestCallMessage(playerid)
{
    // Jone первый звонок
    if(GetPVarInt(playerid,"qweststat") == 2)
    {	
        SetPVarInt(playerid, "MobileStat",2), SetPVarInt(playerid, "Mobile",2500), SetPVarInt(playerid, "taks",0);
        if(OnlineInfo[playerid][oShowInterface] == 2) CloseMenu(playerid), SmartfonCall(playerid);
        else ShowSmartfon(playerid);
        SendClientMessage(playerid, COLOR_GREY, "{AFAFAF}Входящий Вызов: {ccffff}Неизвестный");
        SetPlayerChatBubble(playerid,"смартфон звонит",COLOR_PURPLE,20.0,3000);
        around_player_audio(playerid, 23000, 0, 5.0, 0);
    }
    else if(GetPVarInt(playerid,"qweststat") == 3)
    {
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone0.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Неизвестный Абонент (телефон): Мне дали твой номер и сказали ты можешь помочь");
        SetPVarInt(playerid,"qweststat",4), SetPVarInt(playerid,"qwesttime",3);
    }
    else if(GetPVarInt(playerid,"qweststat") == 4)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Неизвестный Абонент (телефон): Дельце не трудное и за него ты получишь вознаграждение");
        SetPVarInt(playerid,"qweststat",5), SetPVarInt(playerid,"qwesttime",3);
    }
    else if(GetPVarInt(playerid,"qweststat") == 5)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Неизвестный Абонент (телефон): Приезжай. Я скину тебе в навигатор точку GPS");
        SetPVarInt(playerid,"qweststat",6), SetPVarInt(playerid,"qwesttime",4);

        PlayerInfo[playerid][pQuest][3] = 1; // Джоне нам позвонил первый раз
        SaveQuest(playerid);

        // Сохраняем unix этого звонка
        QuestInfo[playerid][UnixCall] = gettime();
    }
    else if(GetPVarInt(playerid,"qweststat") == 6)
    {
        SendClientMessage(playerid, COLOR_GREY, "{cc9999}Оператор: {AFAFAF}Абонент сбросил вызов!");
        hangup(playerid, 0), PlayerPlaySound(playerid, 1063, 0,0,0);
        SetPVarInt(playerid,"qweststat",7), SetPVarInt(playerid,"qwesttime",4);
    }
    else if(GetPVarInt(playerid,"qweststat") == 7)
    {	
        PlayerPlaySound(playerid, 1084, 0,0,0);
        SendClientMessage(playerid, COLOR_YELLOW, " SMS от Джоне: {99ff33}скинул точку в твой навигатор");

        if(PlayerInfo[playerid][pKomnataCity] == 3) CreateGps(playerid,2121.7776,2709.5793,10.8203, 0, 0, 5.0);
        else CreateGps(playerid, 1364.35242, -1682.73926, 13.47850, 0, 0, 5.0);

        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{99ff66}*","{99ff66}Добавлена точка в GPS навигатор","*","");
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);

        // Запускаем подсказку о передвижении по серверу
        ShowHintArenda(playerid);

        // Подсказка, что можно офнуть звонки от ботов
        MessageOffCallQuest(playerid);
    }


    // Уведомление о том, как передвигаться по штату
    else if(GetPVarInt(playerid,"qweststat") == 9)
    {
        FlyCameraPos(playerid,1570.383911, -2280.617187, 18.590723,  1567.874877, -2276.920654, 16.345813  ,900,800);
        SetPVarInt(playerid,"qweststat",1), SetPVarInt(playerid,"qwesttime",6);
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Как передвигаться по штату?\n\n{ff9000}Воспользуйтесь терминалом аренды скутеров, чтобы отправиться к первому квесту","*","");
    }
    else if(GetPVarInt(playerid,"qweststat") == 10)
    {
        FlyCameraPos(playerid,1709.974975, 1412.771484, 15.816736,  1712.994873, 1416.352539, 14.068523  ,900,800);
        SetPVarInt(playerid,"qweststat",1), SetPVarInt(playerid,"qwesttime",6);
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Как передвигаться по штату?\n\n{ff9000}Воспользуйтесь терминалом аренды скутеров, чтобы отправиться к первому квесту","*","");
    }


    // Jone второй звонок
    else if(GetPVarInt(playerid,"qweststat") == 11)
    {	
        SetPVarInt(playerid, "MobileStat",2), SetPVarInt(playerid, "Mobile",2501), SetPVarInt(playerid, "taks",0);
        if(OnlineInfo[playerid][oShowInterface] == 2) CloseMenu(playerid), SmartfonCall(playerid);
        else ShowSmartfon(playerid);
        SendClientMessage(playerid, COLOR_GREY, "{AFAFAF}Входящий Вызов: {ccffff}Неизвестный");
        SetPlayerChatBubble(playerid,"смартфон звонит",COLOR_PURPLE,20.0,3000);
        around_player_audio(playerid, 23000, 0, 5.0, 0);
    }
    else if(GetPVarInt(playerid,"qweststat") == 12)
    {
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone4.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (телефон): Ну чё? Ты приедешь?");
        SetPVarInt(playerid,"qweststat",13), SetPVarInt(playerid,"qwesttime",2);
    }
    else if(GetPVarInt(playerid,"qweststat") == 13)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (телефон): Давай, я жду тебя");
        SetPVarInt(playerid,"qweststat",14), SetPVarInt(playerid,"qwesttime",2);
        PlayerInfo[playerid][pQuest][3] = 2; // Джоне нам позвонил второй раз
        SaveQuest(playerid);
    }
    else if(GetPVarInt(playerid,"qweststat") == 14)
    {
        SendClientMessage(playerid, COLOR_GREY, "{cc9999}Оператор: {AFAFAF}Абонент сбросил вызов!");
        hangup(playerid, 0), PlayerPlaySound(playerid, 1063, 0,0,0);
        SetPVarInt(playerid,"qweststat",7), SetPVarInt(playerid,"qwesttime",4);
    }


    // Ремон Транспорта (Квест от Джоне)
    else if(GetPVarInt(playerid,"qweststat") == 15)
    {
        if(PlayerInfo[playerid][pSex] == 1) 
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_repair0.mp3");
            SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Ну как тебе авто? Уже успел сломать?");
        }
        else 
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_repair00.mp3");
            SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Ну как тебе авто? Уже успела сломать?");
        }
        SetPVarInt(playerid,"qweststat",16), SetPVarInt(playerid,"qwesttime",3);
    }
    else if(GetPVarInt(playerid,"qweststat") == 16)
    {
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_repair1.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Ну ты даёшь.. У тебя в машине лежит ремкомплект");

        SetPVarInt(playerid,"qweststat",17), SetPVarInt(playerid,"qwesttime",3);
    }
    else if(GetPVarInt(playerid,"qweststat") == 17)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Подойди к багажнику, открой инвентарь и выбери вкладку <<Багажник>>");
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);
    }


    // Джонни Секс
    else if(GetPVarInt(playerid,"qweststat") == 18)
    {
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);
        ShowQwest(playerid,6);
    }
    else if(GetPVarInt(playerid,"qweststat") == 19)
    {
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_bar0.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Сейчас самое время расслабиться, после тяжелого трудового дня");
        SetPVarInt(playerid,"qweststat",20), SetPVarInt(playerid,"qwesttime",5);
        PlayerInfo[playerid][pQuest][6] = 1;
    }
    else if(GetPVarInt(playerid,"qweststat") == 20)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Мой знакомый здесь владеет сетью клубов");
        SetPVarInt(playerid,"qweststat",21), SetPVarInt(playerid,"qwesttime",3);
    }
    else if(GetPVarInt(playerid,"qweststat") == 21)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Сгоняй в любой клуб или бар, развейся. Мне помогает");
        SetPVarInt(playerid,"qweststat",69), SetPVarInt(playerid,"qwesttime",6);
    }
    else if(GetPVarInt(playerid,"qweststat") == 69)
    {
        FindKlub(playerid, true); // true означает, что мы ищем клуб для квеста, а значит будем распределять игроков по клубам, чтобы они не толпились
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);
    }


    // Джоне мед.карта
    else if(GetPVarInt(playerid,"qweststat") == 22)
    {
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_bar1.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Вот чёрт! Дружище...");
        SetPVarInt(playerid,"qweststat",23), SetPVarInt(playerid,"qwesttime",3);
        PlayerInfo[playerid][pQuest][7] = 1;
    }
    else if(GetPVarInt(playerid,"qweststat") == 23)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Я тоже был в этом клубе недавно и походу че-то подцепил");
        SetPVarInt(playerid,"qweststat",24), SetPVarInt(playerid,"qwesttime",5);
    }
    else if(GetPVarInt(playerid,"qweststat") == 24)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Надеюсь у тебя были презики? Советую провериться в больничке, на всякий");
        SetPVarInt(playerid,"qweststat",70), SetPVarInt(playerid,"qwesttime",4);
    }
    else if(GetPVarInt(playerid,"qweststat") == 70)
    {
        CreateGps(playerid,1173.9412, -1323.2576, 14.9922, 0, 0, 5.0);
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Только-бы не заболеть... Мне нужно скорее в больницу");
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Отправляйтесь в больницу, чтобы получить лечение","*","");
    }


    // Джоне хавчик
    else if(GetPVarInt(playerid,"qweststat") == 25)
    {
        PlayerInfo[playerid][pQuest][8] = 1;
        if(PlayerInfo[playerid][pSex] == 1) 
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_havka0.mp3");
            SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Извини, что так вышло с этой стриптизершей, или как её");
        }
        else 
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_havka0w.mp3");
            SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Не устала работать?");
        }
        SetPVarInt(playerid,"qweststat",27), SetPVarInt(playerid,"qwesttime",4);
    }
    else if(GetPVarInt(playerid,"qweststat") == 27)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Хавать хочешь?");
        SetPVarInt(playerid,"qweststat",28), SetPVarInt(playerid,"qwesttime",3);
    }
    else if(GetPVarInt(playerid,"qweststat") == 28)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Найди какое нибудь кафе, похавай");
        SetPVarInt(playerid,"qweststat",29), SetPVarInt(playerid,"qwesttime",3);
    }
    else if(GetPVarInt(playerid,"qweststat") == 29)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Я скину тебе лаве на карту");
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);
        FindEat(playerid, true);
    }


    // Джоне ноут (Если не хватает денег)
    else if(GetPVarInt(playerid,"qweststat") == 30)
    {
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_note0.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Я думаю тебе нужно купить ноут");
        SetPVarInt(playerid,"qweststat",31), SetPVarInt(playerid,"qwesttime",4);
    }
    else if(GetPVarInt(playerid,"qweststat") == 31)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Но, если у тебя нет денег, то сейчас самое время их заработать");
        SetPVarInt(playerid,"qweststat",32), SetPVarInt(playerid,"qwesttime",4);
    }
    else if(GetPVarInt(playerid,"qweststat") == 32)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Поищи работу в своём смартфоне {ffcc66}[ Y >> GPS >> Работа ]");
        SetPVarInt(playerid,"qweststat",33), SetPVarInt(playerid,"qwesttime",2);
    }
    else if(GetPVarInt(playerid,"qweststat") == 33)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Я наберу тебе, когда заработаешь денег на ноутбук");
        SetPVarInt(playerid,"qweststat",34), SetPVarInt(playerid,"qwesttime",3);
    }
    else if(GetPVarInt(playerid,"qweststat") == 34)
    {
        SendClientMessage(playerid, COLOR_GREY,"{0088ff}[ Квест ] {ffcc66}Для продолжения вам необходимо заработать {99ff66}%d$", getThingPriceGos(42, 0) * 2);
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);
        PlayerInfo[playerid][pQuest][9] = 1;
        SaveQuest(playerid);
    }


    // Джоне ноут (Денег хватает)
    else if(GetPVarInt(playerid,"qweststat") == 35)
    {
        if(PlayerInfo[playerid][pSex] == 1)
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_note1.mp3");
            SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Дружище, ты заработал денег?");
        }
        else
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_note1w.mp3");
            SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Подруга, ты заработала денег?");
        }
        SetPVarInt(playerid,"qweststat",36), SetPVarInt(playerid,"qwesttime",3);
    }
    else if(GetPVarInt(playerid,"qweststat") == 36)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Отлично! Тогда дуй в ближайший магаз и купи ноутбук");
        SetPVarInt(playerid,"qweststat",71), SetPVarInt(playerid,"qwesttime",3);
    }
    else if(GetPVarInt(playerid,"qweststat") == 71)
    {
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);
        FindTehshop(playerid);
    }


    // Вышли из больницы, отобразили местонахождение аптеки
    else if(GetPVarInt(playerid,"qweststat") == 37)
    {
        FindAptek(playerid, true);
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);
    }


    // Джоне ноут (Купили ноут)
    else if(GetPVarInt(playerid,"qweststat") == 38)
    {
        PlayerInfo[playerid][pQuest][9] = 2;
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_note2.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Давай я научу тебя пользоваться ноутбуком");
        SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ Квест ] {ffcc66}Откройте инвентарь и выберите ноутбук [ Кнопка N ]");
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);
    }

    // Открыл Банк Online
    else if(GetPVarInt(playerid,"qweststat") == 39)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Кстати, советую включить автооплату налогов, чтобы потом не накопилось");
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);
    }

    // Открыл Gold Trade
    else if(GetPVarInt(playerid,"qweststat") == 40)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Так-же за голду можно покупать машины и шмот");
        SetPVarInt(playerid,"qweststat",41), SetPVarInt(playerid,"qwesttime",4);
    }
    else if(GetPVarInt(playerid,"qweststat") == 41)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Загляни как-нибудь в любой автосалон или магазин одежды");
        SetPVarInt(playerid,"qweststat",42), SetPVarInt(playerid,"qwesttime",4);
    }
    else if(GetPVarInt(playerid,"qweststat") == 42)
    {
        if(PlayerInfo[playerid][pSex] == 1) SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Всё братан, я отчаливаю. Ещё услышимся");
        else SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Всё солнце, я отчаливаю. Ещё услышимся :)");
        SetPVarInt(playerid,"qweststat",43), SetPVarInt(playerid,"qwesttime",4);
    }
    else if(GetPVarInt(playerid,"qweststat") == 43)
    {
        PlayerInfo[playerid][pQuest][9] = 5;
        SaveQuest(playerid);
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);

        // Выдаём кейс
        GiveGiftQuest(playerid);
    }


    // Археолог первый звонок
    else if(GetPVarInt(playerid,"qweststat") == 44)
    {	
        SetPVarInt(playerid, "MobileStat",2), SetPVarInt(playerid, "Mobile",2502), SetPVarInt(playerid, "taks",0); // Mobile 2502 - звонит археолог
        if(OnlineInfo[playerid][oShowInterface] == 2) CloseMenu(playerid), SmartfonCall(playerid);
        else ShowSmartfon(playerid);
        SendClientMessage(playerid, COLOR_GREY, "{AFAFAF}Входящий Вызов: {ccffff}Неизвестный");
        SetPlayerChatBubble(playerid,"смартфон звонит",COLOR_PURPLE,20.0,3000);
        around_player_audio(playerid, 23000, 0, 5.0, 0);
    }
    else if(GetPVarInt(playerid,"qweststat") == 45)
    {
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/bruce/bruce_call0.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Неизвестный Абонент (телефон): Приветствую. Я не телефонный мошенник, так что не сбрасывай");
        SetPVarInt(playerid,"qweststat",46), SetPVarInt(playerid,"qwesttime",3);

        // Сохраняем unix этого звонка
        QuestInfo[playerid][UnixCall] = gettime();
    }
    else if(GetPVarInt(playerid,"qweststat") == 46)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Неизвестный Абонент (телефон): Я работаю в компании, которая занимается археологическими раскопками");
        SetPVarInt(playerid,"qweststat",47), SetPVarInt(playerid,"qwesttime",3);
    }
    else if(GetPVarInt(playerid,"qweststat") == 47)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Неизвестный Абонент (телефон): Джоне сказал, что я могу тебе набрать");
        SetPVarInt(playerid,"qweststat",48), SetPVarInt(playerid,"qwesttime",3);
    }
    else if(GetPVarInt(playerid,"qweststat") == 48)
    {
        SendClientMessage(playerid, COLOR_YELLOW,"Неизвестный Абонент (телефон): Если интересует возможность заработать, приезжай");
        SetPVarInt(playerid,"qweststat",49), SetPVarInt(playerid,"qwesttime",3);

        PlayerInfo[playerid][pQuest][5] = 1; // Археолог нам позвонил первый раз
        SaveQuest(playerid);
    }
    else if(GetPVarInt(playerid,"qweststat") == 49)
    {
        SendClientMessage(playerid, COLOR_GREY, "{cc9999}Оператор: {AFAFAF}Абонент сбросил вызов!");
        hangup(playerid, 0), PlayerPlaySound(playerid, 1063, 0,0,0);
        SetPVarInt(playerid,"qweststat",50), SetPVarInt(playerid,"qwesttime",4);
    }
    else if(GetPVarInt(playerid,"qweststat") == 50)
    {	
        PlayerPlaySound(playerid, 1084, 0,0,0);
        SendClientMessage(playerid, COLOR_YELLOW, " SMS от Брюс: {99ff33}метка уже в твоём GPS");

        CreateGps(playerid,-338.6107,1729.5956,42.8917, 0, 0, 5.0);

        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{99ff66}*","{99ff66}Добавлена точка в GPS навигатор","*","");
        SetPVarInt(playerid,"qweststat",0), SetPVarInt(playerid,"qwesttime",0);

        // Запускаем подсказку о передвижении по серверу
        ShowHintArenda(playerid);

        // Подсказка, что мы можем выключить эти звонки
        MessageOffCallQuest(playerid);
    }
    return 1;
}

// Квест знакомство с ноутбуком
// Последняя фраза квеста
stock JoneNoteLastTalk(playerid)
{
    if(PlayerInfo[playerid][pQuest][9] == 3)
    {
        PlayerInfo[playerid][pQuest][9] = 4;

        if(PlayerInfo[playerid][pSex] == 1) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_note7.mp3");
        else PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_note7w.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Здесь ты можешь торговать. Покупать и продавать голду");
        SetPVarInt(playerid,"qweststat",40), SetPVarInt(playerid,"qwesttime",4);
    }
}

stock ShowHintArenda(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid,150.0,1613.4502,-2292.7754,13.5331) && GetPlayerVirtualWorld(playerid) == 0) 
        SetPVarInt(playerid,"qweststat",9), SetPVarInt(playerid,"qwesttime",4);
    else if(IsPlayerInRangeOfPoint(playerid,150.0,1741.3041,1427.0760,10.8767) && GetPlayerVirtualWorld(playerid) == 0) 
        SetPVarInt(playerid,"qweststat",10), SetPVarInt(playerid,"qwesttime",4);
    return 1;
}

stock GiveGiftQuest(playerid)
{
    new thingId, thingQuan, thingType, thingPara, thingPack;
    CreateCasePlayer(0, thingId, thingQuan, thingType,thingPara, thingPack);
    GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);

    SendClientMessage(playerid, COLOR_GREY,"{0088ff}Вам выпал кейс в подарок. Откройте инвентарь и распакуйте его {ffcc66}[ Кнопка N ]");
    return 1;
}

// Подсказка, что можно офнуть звонки от квестовых персонажей
stock MessageOffCallQuest(playerid) 
    return SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ Pears Project ]: {ffcc66}Вы можете отключить звонки от квестовых персонажей [ Y >> Квесты >> Звонки Off ]");

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
                    new line[100],lines[500];
    	            format(line,sizeof(line),"{ffcc66}Как пройти этот квест?"), strcat(lines,line);
                    format(line,sizeof(line),"\n{cccccc}Этот квест запускается самостоятельно при выполнении необходимых условий"), strcat(lines,line);
                    format(line,sizeof(line),"\n{cccccc}Но если вам не терпится пройти его сейчас, вы можете выполнить следующие действия"), strcat(lines,line);
                    format(line,sizeof(line),"\n\n{ffcc66}1. Положите в багажнике автомобиля Рем. Комплект"), strcat(lines,line);
                    format(line,sizeof(line),"\n{ffcc66}2. Затем повредите автомобиль, сидя за рулём, до 400 хп и квест сразу запустится"), strcat(lines,line);
                    ShowDialog(playerid,505,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"Ок","");
                }
                else if(listitem == 5) ShowDialog(playerid,505,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Хотите отметить этот квест в своём GPS навигаторе?","Да","Нет");
				else if(listitem == 6) ShowDialog(playerid,505,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Хотите запустить квест?","Да","Нет");
                else if(listitem == 7 && NoCompleteQuest(playerid, 6)) return ErrorMessage(playerid,"{ff6347}Вы не выполнили прошлый квест!");
                else if(listitem == 7) ShowDialog(playerid,505,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Хотите запустить квест?","Да","Нет");
                else if(listitem == 8) ShowDialog(playerid,505,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Хотите запустить квест?","Да","Нет");
                else if(listitem == 9) ShowDialog(playerid,505,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Хотите запустить квест?","Да","Нет");
				else ErrorText(playerid, "{FF6347}Подробная информация об этом квесте не заполнена"), showDialogStartQuest(playerid, DP[0][playerid]);
			}
			else ErrorText(playerid, "{FF6347}Вы прошли этот квест"), showDialogStartQuest(playerid, DP[0][playerid]);
		}
		else
		{
			if(DP[0][playerid] == 1) pc_cmd_quest(playerid);
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
            else if(questId == 5)
            {
                CreateGps(playerid,-338.6526,1730.2946,42.9321, 0, 0, 5.0);
				ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Квест отмечен в вашем GPS навигаторе\nПо прибытию нужно будет поговорить с Брюсом","*","");
            }
            else if(questId == 6)
            {
                if(PlayerInfo[playerid][pSex] == 1)
                {
                    if(NoCompleteQuest(playerid, 5)) return ErrorMessage(playerid,"{ff6347}Вы не выполнили предыдущий квест");
                    SuccessMessage(playerid,"{99ff66}Квест запущен, ожидайте указаний от бота и голосовых сообщений");
                    ShowQwest(playerid, 6);
                }
                else ErrorMessage(playerid,"{ff6347}Для запуска квеста вы должны быть мужчиной");
            }
            else if(questId == 7)
            {
                if(PlayerInfo[playerid][pSex] == 1 && getillness(playerid, 1) > -1)
                {
                    if(NoCompleteQuest(playerid, 6)) return ErrorMessage(playerid,"{ff6347}Вы не выполнили предыдущий квест");
                    SuccessMessage(playerid,"{99ff66}Квест запущен, ожидайте указаний от бота и голосовых сообщений");
                    ShowQwest(playerid, 7);
                }
                else ErrorMessage(playerid,"{99ff66}Для запуска квеста вы должны быть мужчиной и иметь болезнь: Хламидиоз");
            }
            else if(questId == 8)
            {
                SuccessMessage(playerid,"{99ff66}Квест запущен, ожидайте указаний от бота и голосовых сообщений");
                ShowQwest(playerid, 8);
            }
            else if(questId == 9)
            {
                if(NoCompleteQuest(playerid, 9)) return ErrorMessage(playerid,"{ff6347}Вы не выполнили предыдущий квест");
                SuccessMessage(playerid,"{99ff66}Квест запущен, ожидайте указаний от бота и голосовых сообщений");
                ShowQwest(playerid, 9);
            }
            else showDialogStartQuest(playerid, DP[0][playerid]);
        }
        else showDialogStartQuest(playerid, DP[0][playerid]);
    }
    return 1;
}


stock SelectNextStartQuest(playerid)
{
    if(QuanPlayerStartQuest >= MAX_PLAYERS_START_QUEST) // На квесте с джони слишком много игроков, тогда отправляем на следующий квест
    {
        if(NoCompleteQuest(playerid, 5)) ShowQwest(playerid, 5); // Исследование гробницы
    }
    else ShowQwest(playerid, 3); // Джоне (Взлом транспорта)
    return 1;
}

// Запускаем квесты со звонками
stock StartFirstCallQuest(playerid)
{
    // Если звонки от квестов выключены
    if(PlayerInfo[playerid][pQwestMessageOff] == true) return 1;

    if(NoCompleteQuest(playerid, 3)) SelectNextStartQuest(playerid); // Джоне или Исследование гробницы в зависимости от заполненности
    else if(NoCompleteQuest(playerid, 5)) 
    {
         if(PlayerInfo[playerid][pQuest][5] == 0) ShowQwest(playerid, 5); // Исследование гробницы
    }
    else if(NoCompleteQuest(playerid, 6)) 
    {
        if(PlayerInfo[playerid][pQuest][6] == 0) ShowQwest(playerid, 6); // Отдых в клубе
    }
    else if(NoCompleteQuest(playerid, 7)) 
    {
        if(PlayerInfo[playerid][pQuest][7] == 0) ShowQwest(playerid, 7); // Последствия отдыха
    }
    else if(NoCompleteQuest(playerid, 8)) 
    {
        if(PlayerInfo[playerid][pQuest][8] == 0) ShowQwest(playerid, 8); // Знакомство с едой
    }
    else if(NoCompleteQuest(playerid, 9)) 
    {
        if(PlayerInfo[playerid][pQuest][9] == 0) ShowQwest(playerid, 9); // Знакомство с ноутбуком
    }
    return 1;
}

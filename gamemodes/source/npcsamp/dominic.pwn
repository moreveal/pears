
#define DOMINIC_UNIX 7200 // Кд на следующую гонку с домиником

#include "../gamemodes/source/npcsamp/dominic_route.pwn" // маршруты доминика

new DominicStatusVehicle; // Порядок действий доминика
new DominicPlayeridRace; // ID игрока, который гоняется с домиником
new DominicDamageReplic; // Реплика доминика, если мы сильно повредили транспорт
new DominicWaitTimer; // Ждём пока игрок подъедет и начнёт с нами гонку
new DominicRaceid; // Какой сейчас у нас маршрут для гонки


// Начинаем болтать с домиником
stock Dominic_StartQuest(playerid)
{
    if(NPCInfo[5][npcStart] == true || NPCInfo[5][npcConnected] == false) return 0;

    new Float:pos[3];
    GetPlayerPos(NPCInfo[5][npcID], pos[0], pos[1], pos[2]);
    if(IsPlayerInRangeOfPoint(playerid,2.0, pos[0], pos[1], pos[2]))
    {
        if(PlayerInfo[playerid][pDominic] == 1) Dominic_GiveGift(playerid, pos[0], pos[1], pos[2]); // Получаем подарок от Доминика
        else
        {
            new unix = gettime();
            if(PlayerInfo[playerid][pDominicUnix] > unix)
            {
                new string[140];
                format(string, sizeof(string), "{FF6347}Вы не можете сейчас начать гонку с Домиником\n{ffcc66}Гонка будет доступна через %s", fine_time(PlayerInfo[playerid][pDominicUnix] - unix));
                ErrorMessage(playerid, string);
                return 1;
            }

            switch(random(3))
            {
                case 0:
                {
                    PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/dominic/dominic0.mp3",pos[0], pos[1], pos[2],6.0,true);
                    SetPlayerChatBubble(NPCInfo[5][npcID],"Ну что, давай прокатимся?",0x67b2ffFF,5.0,3000);
                }
                case 1:
                {
                    if(PlayerInfo[playerid][pSex] == 1)
                    {
                        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/dominic/dominic1.mp3",pos[0], pos[1], pos[2],6.0,true);
                        SetPlayerChatBubble(NPCInfo[5][npcID],"Уверен, что сможешь победить меня?",0x67b2ffFF,5.0,3000);
                    }
                    else
                    {
                        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/dominic/dominic1_w.mp3",pos[0], pos[1], pos[2],6.0,true);
                        SetPlayerChatBubble(NPCInfo[5][npcID],"Уверена, что сможешь победить меня?",0x67b2ffFF,5.0,3000);
                    }
                }
                case 2:
                {
                    if(PlayerInfo[playerid][pSex] == 1)
                    {
                        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/dominic/dominic2.mp3",pos[0], pos[1], pos[2],6.0,true);
                        SetPlayerChatBubble(NPCInfo[5][npcID],"Готов прокатиться?",0x67b2ffFF,5.0,3000);
                    }
                    else
                    {
                        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/dominic/dominic2_w.mp3",pos[0], pos[1], pos[2],6.0,true);
                        SetPlayerChatBubble(NPCInfo[5][npcID],"Готова прокатиться?",0x67b2ffFF,5.0,3000);
                    }
                }
            }

            ShowDialog(playerid,655,DIALOG_STYLE_MSGBOX,"{ff9000}Доминик Торпеда",
                "{ff9000}Вы уверены, что хотите начать гонку?\
                \n\n{99ff66}Вы можете выиграть:\
                \n{cccccc}- Деталь для тюнинга\
                \n- Бронеплёнка\
                \n- Кейс\
                \n- Рем. комплект\
                \n- Домкрат\
                \n- Пиво\
                \n\n{FF6347}Внимание! {ffcc66}Этот квест весьма сложный\
                \n{ffcc66}Чтобы победить Доминика, вам понадобится прокаченная и быстрая тачка",
                "Да","Нет");
        }
        return 1;
    }
    return 0;
}

// Получаем подарок от доминика
stock Dominic_GiveGift(playerid, Float:x, Float:y, Float:z)
{
    if(PlayerInfo[playerid][pAchieve][127] == 0) AchievePlayer(playerid, 127, 1); // Ачивка за победу в гонке с Домиником

    new thingId, thingQuan = 1, thingType, thingPara, thingPack;
    switch(random(16))
    {
        case 0..5:
        {
            thingId = 225; // Домкрат
            thingQuan = 1 + random(4);
        }
        case 6..10: thingId = 183; // Рем комплект
        case 11..13: thingId = 119; // Пиво разливное
        case 14: thingId = 207 + random(21); // Какая-то деталь тюнинга (207 - 228)
        case 15: CreateCasePlayer(0, thingId, thingQuan, thingType, thingPara, thingPack); // Кейс
    }

    // Количественный предмет (Проверка на лимиты)
    new bool:fallGift;
    if(CheckThingQuan(thingId) == 1)
	{
        new getQuan, getLimit;
		i_limit(playerid, thingId, getQuan, getLimit);
		if(getQuan+thingQuan > getLimit) fallGift = true;
    }

    // Выдаём предмет
    new put_inva = -1;
    if(fallGift == false) 
    {
        put_inva = GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999); // Всё окей, даём в инвентарь
        SuccessMessage(playerid, "{99ff66}Доминик дал вам подарок\n{ffcc66}Проверьте свой инвентарь [ Кнопка N ]");
    }
	if(put_inva == -1) // Всё хуйня, кладём на землю
    {
        Throw(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack);
        SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ Подарок ]: {ffcc66}Вы получили подарок [В инвентаре нет места, подарок упал на землю]");
        SuccessMessage(playerid, "{99ff66}Доминик дал вам подарок\n{ffcc66}Подарок упал на землю [ Кнопка N >> Рядом ]");
    }

    PlayerInfo[playerid][pDominic] = 0;
    SaveDominicQuest(playerid);

    switch(random(3))
    {
        case 0:
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/dominic/dominic3.mp3",x, y, z,6.0,true);
            SetPlayerChatBubble(NPCInfo[5][npcID],"Вот, держи.. Это для тебя",0x67b2ffFF,5.0,3000);
        }
        case 1:
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/dominic/dominic4.mp3",x, y, z,6.0,true);
            SetPlayerChatBubble(NPCInfo[5][npcID],"Держи, это тебе подарок от меня",0x67b2ffFF,5.0,3000);
        }
        case 2:
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/dominic/dominic5.mp3",x, y, z,6.0,true);
            SetPlayerChatBubble(NPCInfo[5][npcID],"Возьми, этот подарок для тебя",0x67b2ffFF,5.0,3000);
        }
    }
    return 1;
}

// Запускаем функционал гонки с домиником
stock Dominic_CreatePlayerRace(playerid, raceid)
{
    OnlineInfo[playerid][oDominicRace] = raceid; // Номер маршрута для гонки
    DominicStatusVehicle = 0; // Порядок действий бота доминика
    DominicPlayeridRace = playerid; // ID игрока, который сейчас будет гоняться с домиником
    DominicDamageReplic = 0;
    DominicRaceid = raceid;
    CreatePlayerRacePoint(playerid, raceid, 0);
    return 1;
}

// Доминик бибикает
stock Dominic_CapsLock()
{
    if(DominicStatusVehicle == 0) // Подъехал на старт
    {
        // Объясняем боту, какое будет второе действие доминика
        UpdateDominicAction(DominicRaceid);

        DominicWaitTimer = 60;
        DominicStatusVehicle = 1;

        if(IsOnline(DominicPlayeridRace))
        {
            SetVehicleParamsForPlayer(dominicveh, DominicPlayeridRace, true, true);

            SendClientMessage(DominicPlayeridRace, COLOR_GREY, "[ Мысли ]: Мне нужно подъехать к Доминику и посигналить, чтобы начать гонку [ Caps Lock ]");
            ShowDialog(DominicPlayeridRace,1700,DIALOG_STYLE_MSGBOX,"{ff9000}Доминик Торпеда",
                "{ffcc66}Подъедьте на своей машине к Доминику и посигнальте, чтобы начать гонку","*","");

            CreateGps(DominicPlayeridRace,-2424.6162,-610.5967,132.2272, 0, 0, 4.0);
            SetPlayerHudTask(DominicPlayeridRace, "Доминик", "Подъедьте на своей машине к Доминику и посигнальте, чтобы начать гонку.\nПосигналить: Caps Lock");
        }
        return 1;
    }
    return 0;
}

// Игрок бибикает рядом с домиником, чтобы начать гонку
stock Dominic_PlayerCapsLock(playerid)
{
    if(DominicStatusVehicle == 1 && NPCInfo[5][npcStart] == true && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new Float:pos[3];
        GetPlayerPos(NPCInfo[5][npcID], pos[0], pos[1], pos[2]);
        if(IsPlayerInRangeOfPoint(playerid,10.0, pos[0], pos[1], pos[2]))
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            if(!IsACar(VehInfo[vehicleid][vModel])) return ErrorMessage(playerid, "{FF6347}Вы можете начать гонку только на автомобиле");

            HidePlayerHudTask(playerid);
            DominicStatusVehicle = 2;
            StartRacePlayer(playerid); // Даём старт

            // Отображаем доминику последний поинт
            Dominic_ShowLastPoint(playerid, NPCInfo[5][npcID]);
            return 1;
        }
    }
    return 0;
}

// Запускаем доминика в гонку
stock Dominic_StartRace(playerid)
{
    if(DominicStatusVehicle == 2)
    {
        DominicStatusVehicle = 3;
        RemovePlayerFromVehicle(playerid);
        Protect_PutPlayerInVehicle(playerid, dominicveh, 0);
    }
    return 1;
}

// Доминик подбирает финишный чекпоинт
stock Dominic_PickupRaceCheckpoint()
{
    if(DominicStatusVehicle != 3) return 1;
    Dominic_ExtPlayerRace();

    if(IsOnline(DominicPlayeridRace))
    {
        Dominic_Restriction(DominicPlayeridRace);
        SaveDominicQuest(DominicPlayeridRace);
        ClearPlayerRace(DominicPlayeridRace, false);

        if(PlayerInfo[DominicPlayeridRace][pSex] == 1)
        {
            PlayAudioStreamForPlayer(DominicPlayeridRace, "https://cdn.pears.fun/sound/characters/dominic/dominic6.mp3");
            SendClientMessage(DominicPlayeridRace, COLOR_YELLOW,"Доминик (голосовое): Неплохо погоняли, брат");
            SendClientMessage(DominicPlayeridRace, COLOR_YELLOW,"Доминик (голосовое): Заезжай как-нибудь ещё, я всегда рад прокатиться");
        }
        else
        {
            PlayAudioStreamForPlayer(DominicPlayeridRace, "https://cdn.pears.fun/sound/characters/dominic/dominic6_w.mp3");
            SendClientMessage(DominicPlayeridRace, COLOR_YELLOW,"Доминик (голосовое): Неплохо погоняли");
            SendClientMessage(DominicPlayeridRace, COLOR_YELLOW,"Доминик (голосовое): Заезжай как-нибудь ещё, я всегда рад прокатиться");
        }
        SendClientMessage(DominicPlayeridRace, COLOR_GREY, "[ Мысли ]: Вот блин! Я проиграл%s", gender(DominicPlayeridRace));
    }
    return 1;
}

// Завершаем гонку с домиником и ставим бота на место
stock Dominic_ExtPlayerRace()
{
    DominicStatusVehicle = 0;
    OnNpcSpawn(NPCInfo[5][npcID]); // Возвращаем NPC на позицию
    ReloadVehicleNPC(dominicveh);

    // Сбрасываем первое действие доминика
    UpdateDominicAction(0);
    return 1;
}

// Игрок приехал на финиш раньше доминика
stock Dominic_FinishPlayer(playerid)
{
    switch(random(2))
    {
        case 0:
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/dominic/dominic7.mp3");
            SendClientMessage(playerid, COLOR_YELLOW,"Доминик (голосовое): Молодец, ты неплохо водишь");
            SendClientMessage(playerid, COLOR_YELLOW,"Доминик (голосовое): У меня для тебя кое-что есть, приезжай");
        }
        case 1:
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/dominic/dominic8.mp3");
            SendClientMessage(playerid, COLOR_YELLOW,"Доминик (голосовое): Ты хороший водитель");
            SendClientMessage(playerid, COLOR_YELLOW,"Доминик (голосовое): Приезжай, у меня для тебя подарок");
        }
    }

    CreateGps(playerid, NpcPositionSpawn[5][Npc_X], NpcPositionSpawn[5][Npc_Y], NpcPositionSpawn[5][Npc_Z], 0, 0, 2.0);

    // Сохраняем статус квеста с домиником
    PlayerInfo[playerid][pDominic] = 1;
    Dominic_Restriction(playerid);
    SaveDominicQuest(playerid);
    return 1;
}

// Создаём кд на гонку с домиником
stock Dominic_Restriction(playerid)
{
    if(server > 0) PlayerInfo[playerid][pDominicUnix] = gettime() + DOMINIC_UNIX;
    else PlayerInfo[playerid][pDominicUnix] = gettime() + 300; // На тестовом сервере кд будет 5 минут
    return 1;
}

alias:reloaddominic("rdominic", "доминик")
CMD:reloaddominic(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 14) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    PlayerInfo[playerid][pDominicUnix] = 0;
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ff9000}Доминик Торпеда","{ffcc66}Ограничение, на повторную гонку с Домиником, очищено","*","");
    return 1;
}

// Сохраняем статус квеста с домиником
stock SaveDominicQuest(playerid)
{
    new string_mysql[140];
    format(string_mysql, sizeof(string_mysql),"UPDATE `pp_igroki` SET `pDominic`='%d', `pDominic`='%d' WHERE `user_id`='%d'", 
        PlayerInfo[playerid][pDominic], PlayerInfo[playerid][pDominic], PlayerInfo[playerid][pID]);
    query_empty(pearsq, string_mysql);
    return 1;
}

stock dialogCase_Dominic(playerid, dialogid, response)
{
    if(dialogid == 655)
    {
        if(response) // Запускаем доминика
        {
            if(NPCInfo[5][npcStart] == true) return ErrorMessage(playerid, "{FF6347}Упс! Вы не успели.. Кто-то начал гонку с домиником раньше вас");
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/dominic/dominic_music.mp3",-2420.4680,-607.9064,132.4383,30.0,true);

            new raceid = 1;
            if(PlayerInfo[playerid][pAchieve][127] > 0) raceid += random(MAX_ROUTE_DOMINIC); // Ачивку получали, значит маршрут можем выбрать рандомный
            Dominic_CreatePlayerRace(playerid, raceid);
            StartNpc(5);
        }
        return 1;
    }
    return 0;
}

// Проверка дамага во время гонки
stock Dominic_CheckDamageVehicle(playerid, vehicleid)
{
    if(VehInfo[vehicleid][vHealth] <= 1500.0 && DominicDamageReplic == 0)
    {
        DominicDamageReplic = 1;
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/dominic/dominic9.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Доминик (голосовое): Ты как? В порядке?");
        SendClientMessage(playerid, COLOR_YELLOW,"Доминик (голосовое): Смотри не убейся");
    }
    return 1;
}

// Ожидание начала гонки
stock Dominic_WaitRace()
{
    DominicWaitTimer --;
    if(DominicWaitTimer <= 0)
    {
        Dominic_ExtPlayerRace();

        if(IsOnline(DominicPlayeridRace))
        {
            ClearPlayerRace(DominicPlayeridRace, false);

            ErrorMessage(DominicPlayeridRace, "{FF6347}Гонка с Домиником была отменена\n{ffcc66}В течении минуты вы не подъехали к Доминику");
            SendClientMessage(DominicPlayeridRace, COLOR_GREY, "[ Мысли ]: Я не подъехал%s к Доминику, чтобы начать гонку", gender(DominicPlayeridRace));
            Dominic_Restriction(DominicPlayeridRace);
            SaveDominicQuest(DominicPlayeridRace);
            HidePlayerHudTask(DominicPlayeridRace);
        }
    }
    return 1;
}

// Говорим, что сейчас будет делать доминик
stock UpdateDominicAction(action)
{
	new File:File = fopen("dominic.txt", io_write); // Открываем или создаём этот файл

	new text[4];
	format(text,sizeof(text),"%d", action);
	fwrite(File, text); // Записываем все строки в файл
	fclose(File); // Закрываем файл
	return 1;
}

CMD:testrace(playerid, const params[])
{
    if(server != 0) return 0;
    if(OnlineInfo[playerid][oDominicRace] > 0) return ErrorMessage(playerid, "{FF6347}Нельзя во время активной гонки с домиником");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Запустить чекпоинты гонки с ботом [ /testrace ID гонки ]");
    if(params[0] <= 0 || params[0] > MAX_ROUTE_DOMINIC) return ErrorMessage(playerid, "{FF6347}Несуществующий id маршрута гонки с ботом");

    CreatePlayerRacePoint(playerid, params[0], 0);
    StartRacePlayer(playerid);
    return 1;
}

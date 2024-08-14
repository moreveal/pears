
#define MAX_HINT 3 // Максимальное количество подсказок (новая система)

new bool:HintLoad[MAX_REALPLAYERS];
new HitPlayer[MAX_REALPLAYERS][MAX_HINT];

// Включаем подсказки для игрока после того как он залогинился в игре
stock ShowPlayerHintAfterLogin(playerid)
{
    if(HintLoad[playerid] == false) return false;

    if(HitPlayer[playerid][1] == 0) ShowPlayerHintInfo(playerid, 1); // Подсказка про деревенских
    else if(HitPlayer[playerid][2] == 0) ShowPlayerHintInfo(playerid, 2); // Подсказка про маньяка
    return true;
}

stock ShowPlayerHintInfo(playerid, hintid)
{
    if(hintid < 0 || hintid >= MAX_HINT) return false;
    if(HintLoad[playerid] == false) return false;
    if(HitPlayer[playerid][hintid] > 0) return false; // Пока что все подсказки имееют всего 1 уровень (1 озвучена, 0 нет)

    // Подсказка про систему угона
    if(hintid == 0)
    {
        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_hint0.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Эй привет! Совсем забыл тебе сказать");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): У нас тут криминальненько и если не хочешь, чтобы твою машину угнали..");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Поставь на неё сигнализацию");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Ты можешь купить её в любом автосервисе [ Y >> GPS >> Автосервис ]");
    }

    // Подсказка про деревенских
    else if(hintid == 1)
    {
        if(!IsPlayerSyncModels(playerid)) return false; // Если нет лаунчера, хрен тебе а не уведомление
        if(IsANotComleteImportantQuest(playerid)) return false; // Если один из квестов не пройден, не сообщаем игроку о следующем задании

        PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_hint1.mp3");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Привет. Ну как оно? Хочу дать тебе наводку на одно дельце");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Рядом со станцией NASA есть деревня, там живут какие-то больные");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Они что-то охраняют и это что-то ты можешь забрать себе");
        SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Возьми оружие, друзей и отправляйся [ Y >> Квесты >> Деревенские ]");
    }

    // Подсказка про маньяка
    else if(hintid == 2)
    {
        if(!IsPlayerSyncModels(playerid)) return false; // Если нет лаунчера, хрен тебе а не уведомление
        if(IsANotComleteImportantQuest(playerid)) return false; // Если один из квестов не пройден, не сообщаем игроку о следующем задании
        if(PlayerInfo[playerid][pManiacQwest] > 0) return false; // Игрок уже собрал все маски, пропускаем подсказку

        StartManiacQuest(playerid); // Запускаем начало квеста с маньяком
    }

    // Сохраняем результат подсказки
    DoneHintPlayer(playerid, hintid);
    return true;
}

// Если игрок не прошёл один из важных квестов
stock IsANotComleteImportantQuest(playerid)
{
    if(NoCompleteQuest(playerid, 2) // Привести себя в порядок
    || NoCompleteQuest(playerid, 3) // Взломать тачку
    || NoCompleteQuest(playerid, 5) // Археологические раскопки
    || NoCompleteQuest(playerid, 8) // Хавка
    || NoCompleteQuest(playerid, 9) // Ноут
    ) return true;
    return false;
}

stock DoneHintPlayer(playerid, hintid, result = 1)
{
    if(hintid < 0 || hintid >= MAX_HINT) return false;
    if(HintLoad[playerid] == false) return false;

    HitPlayer[playerid][hintid] = result;

    new string_mysql[100];
    mysql_format(pearsq, string_mysql ,sizeof(string_mysql),"UPDATE `pp_igroki_hint` SET `hint%d` = '%d' WHERE `user_id` = '%d'", 
        hintid, HitPlayer[playerid][hintid], PlayerInfo[playerid][pID]);
    mysql_tquery(pearsq, string_mysql);
    return true;
}

// Запрос для загрузки подсказок
function Call_OnPlayerHintLoad(playerid, race_check)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);

        new string[20];
        for(new i = 0; i < MAX_HINT; i++)
        {
            format(string, sizeof(string), "hint%d", i);
	  		cache_get_value_name_int(0, string, HitPlayer[playerid][i]);
        }
		printf("OnPlayerHintLoad(%s) Подсказки Найдены", PlayerInfo[playerid][pName]);
	}
	else // Если не нашли в таблице, тогда создаём
	{
		new string[100];
		mysql_format(pearsq, string, sizeof(string), "INSERT INTO `pp_igroki_hint` SET `user_id`= '%d'", PlayerInfo[playerid][pID]);
		mysql_tquery(pearsq, string);
        printf("OnPlayerHintLoad(%s) Подсказки Созданы", PlayerInfo[playerid][pName]);
	}
    HintLoad[playerid] = true;

    ShowPlayerHintAfterLogin(playerid);
	return 1;
}

// Очищаем переменные с подсказками
stock ClearHintPlayer(playerid)
{
    HintLoad[playerid] = false;
    for(new i = 0; i < MAX_HINT; i++) HitPlayer[playerid][i] = 0;
    return true;
}

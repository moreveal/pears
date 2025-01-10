
/* 
Как добавить новое ежедневное задание?
1. Добавляем его в dailyName
2. Прописываем описание, как выполнить задание в dailyDescription
3. Указываем диапазоны количества выполняемых действий для задания в stock GetDailyQuanMinMax
4. Добавляем gps координаты, если у задания есть место выполнения в stock DailyGPS (обязательно так-же как это сделано у других заданий)
5. Если задание не может быть доступно всем игрокам, указываем требования в stock IsDailyAvailableForPlayer
6. Прописать выполнение задания в той части кода, где это нужно
	CompletingDaily(playerid, dailyid, quan);
*/

enum e_DailyType {
    DAILY_TYPE_NONE, // Нет
    DAILY_TYPE_FISHING, // Рыбалка
    DAILY_TYPE_SPERM, // Спермобанк
    DAILY_TYPE_HUNT, // Охота
    DAILY_TYPE_SPACE, // Космос
    DAILY_TYPE_ARCHEOLOGY, // Археология
    DAILY_TYPE_FARM, // Ферма
    DAILY_TYPE_TRUCK, // Дальнобойщики
    DAILY_TYPE_CLEANING, // Клининговая служба
    DAILY_TYPE_BUS // Автобус
};

new dailyName[][] =
{
    "нет", // 0
    // Рыбалка
    "Ловить рыбу", // 1
    "Ловить акулу", // 2
    "Собрать морские звёзды", // 3
    "Собрать ракушки", // 4
    // Спермобанк
    "Сдать семя", // 5
    // Охота
    "Охотиться на животных", // 6
    // NASA Луна - Марс
    "Собирать базальт", // 7
    "Собирать палладий", // 8
    "Чистить солнечные панели", // 9
    "Собирать данные со спутниковой тарелки", // 10
    // NASA Марс
    "Выращивать картошку", // 11
    // Археология
    "Пройти лабиринт", // 12
    "Найти сокровища", // 13
    "Открыть саркофаг в гробнице", // 14
    "Собирать древние артефакты", // 15
    // Ферма
    "Собирать яблоки", // 16
    "Доить коров", // 17
    // Дальнобойщик
    "Доставить грузы", // 18
    // Клининговая Служба
    "Работать мусоровозом", // 19
    "Работать мойщиком улиц", // 20
    // Водитель Автобуса
    "Работать водителем автобуса", // 21
    // Охота
    "Убить медведей", // 22
    "Убить оленей", // 23
    "Убить лис", // 24
    "Убить зайцев", // 25
    "Убить волков" // 26
};

new dailyDescription[][] =
{
    "нет", // 0
    // Рыбалка
    "- Купите в рыбацком магазине удочку, наживку и наловите рыбы", // 1 Ловить рыбу
    "- Купите в рыбацком магазине ловушку для акул\
        \n- Затем отправляйтесь в море и установите ловушку", // 2 Ловить акулу
    "- Отправляйтесь на рыбацкую бухту\
        \n- Собирайте морские звёзды под водой вдоль пляжа Los Santos\
        \n- Если вы не находите морские звёзды, подождите и они вскоре появятся", // 3 Собрать морские звёзды
    "- Отправляйтесь на рыбацкую бухту\
        \n- Собирайте ракушки под водой вдоль пляжа Los Santos\
        \n- Если вы не находите ракушки подождите и они вскоре появятся", // 4 Собрать ракушки
    // Спермобанк
    "- Отправляйтесь в спермобанк и выполните процедуру сдачи семени", // 5 Сдать семя
    // Охота
    "- Отправляйтесь в лавку лесника, приобретите винтовку и начните охоту на животных", // 6 Охотиться на оленя
    // NASA Луна - Марс
    "- Отправляйтесь на базу NASA и начините экспедицию на Луну\
        \n- Работайте в карьере или разбивайте метеориты, чтобы найти базальт", // 7 Собирать базальт
    "- Отправляйтесь на базу NASA и начините экспедицию на Луну\
        \n- Разбивайте метеориты, чтобы находить палладий", // 8 Собирать палладий
    "- Отправляйтесь на базу NASA и начините экспедицию на Луну или Марс\
        \n- Возьмите швабру в жилом модуле и очистите солнечные панели от пыли", // 9 Чистить солнечные панели
    "- Отправляйтесь на базу NASA и начините экспедицию на Луну или Марс\
        \n- Возьмите ящик со спутниковой антенной и установите её недалеко от базы\
        \n- Затем дождитесь окончания процесса и скачайте данныые", // 10 Собирать данные со спутниковой тарелки
    // NASA Марс
    "- Отправляйтесь на базу NASA и начините экспедицию на Марс\
        \n- В жилом модуле найдите вход в теплицу и выращивайте картошку", // 11 Выращивать картошку
    // Археология
    "- Отправляйтесь на Археологические Раскопки\
        \n- Приобретите монтировку в вагончике и отправляйтесь проходить лабиринт\
        \n- Лабиринт находится в пирамиде", // 12 Пройти лабиринт
    "- Отправляйтесь на Археологические Раскопки\
        \n- Приобретите верёвку в вагончике и отправляйтесь в гробницу\
        \n- Гробница находится внутри сфинкса\
        \n- Найдите в гробнице карту с сокровищами\
        \n- Используйте карту, чтобы найти сокровища", // 13 Найти сокровища
    "- Отправляйтесь на Археологические Раскопки\
        \n- Приобретите монтировку в вагончике и отправляйтесь в гробницу\
        \n- Гробница находится внутри сфинкса\
        \n- Найдите в гробнице склеп с захоронением и откройте саркофаг", // 14 Открыть саркофаг в гробнице
    "- Отправляйтесь на Археологические Раскопки\
        \n- Собирайте древние артефакты внутри лабиринта или гробницы\
        \n- Для этого просто зайдите в пирамиду или в сфинкса", // 15 Собирать древние артефакты
    // Ферма
    "- Отправляйтесь на Ферму и собирайте яблоки в саду", // 16 Собирать яблоки
    "- Отправляйтесь на Ферму и доите коров в ангарах", // 17 Доить коров
    // Дальнобойщик
    "- Откройте команду /gryz и посмотрите список доступных заказов\
        \n- Выберите любой заказ и просто следуйте инструкции\
        \n- Для доставки вам понадобится грузовик\
        \n- Вы сможете его арендовать рядом с местом погрузки грузов", // 18 Доставить грузы
    // Клининговая Служба
    "- Отправляйтесь в городскую клининговую службу\
        \n- Зайдите в вагончик и устройтесь на работу\
        \n- После чего арендуйте мусоровоз Trashmaster и следуйте инструкции", // 19 Работать мусоровозом
    "- Отправляйтесь в городскую клининговую службу\
        \n- Зайдите в вагончик и устройтесь на работу\
        \n- После чего арендуйте мойщик улиц Sweeper и следуйте инструкции", // 20 Работать мойщиком улиц
    // Водитель Автобуса
    "- Отправляйтесь в автобусное депо\
        \n- Зайдите в вагончик и устройтесь на работу\
            \n- Выберите маршрут и арендуйте автобус для работы" // 21 Работать водителем автобуса
};

stock GetDailyType(dailyId) {
    switch (dailyId) {
        case 1..4: return DAILY_TYPE_FISHING;
        case 5: return DAILY_TYPE_SPERM;
        case 6: return DAILY_TYPE_HUNT;
        case 7..11: return DAILY_TYPE_SPACE;
        case 12..15: return DAILY_TYPE_ARCHEOLOGY;
        case 16..17: return DAILY_TYPE_FARM;
        case 18: return DAILY_TYPE_TRUCK;
        case 19..20: return DAILY_TYPE_CLEANING;
        case 21: return DAILY_TYPE_BUS;

        default: return DAILY_TYPE_NONE;
    }
}

stock GetDailyQuanMinMax(dailyid, &minQuan, &maxQuan) // Диапазон количества для заданий
{
    switch(dailyid)
    {
        // Рыбалка
        case 1: minQuan = 50, maxQuan = 250; // Ловить Рыбу (в килограммах)
        case 2: minQuan = 1, maxQuan = 3; // Ловить Акулу
        case 3: minQuan = 1, maxQuan = 3; // Собрать морские звёзды
        case 4: minQuan = 1, maxQuan = 3; // Собрать ракушки
        // Спермобанк ЕСТЬ ТРЕБОВАНИЕ
        case 5: minQuan = 1, maxQuan = 2; // Сдать семя (Количество раз)
        // Охота
        case 6: minQuan = 1, maxQuan = 2; // Охотиться на оленя (Количество раз)
        // NASA Луна - Марс ЕСТЬ ТРЕБОВАНИЯ
        case 7: minQuan = 10, maxQuan = 25; // Собирать базальт
        case 8: minQuan = 5, maxQuan = 10; // Собирать палладий
        case 9: minQuan = 2, maxQuan = 8; // Чистить солнечные панели
        case 10: minQuan = 1, maxQuan = 3; // Собирать данные со спутниковой тарелки
        // NASA Марс ЕСТЬ ТРЕБОВАНИЯ
        case 11: minQuan = 10, maxQuan = 20; // Выращивать картошку (Собрать клубней картошки)
        // Археология
        case 12: minQuan = 1, maxQuan = 0; // Пройти лабиринт
        case 13: minQuan = 1, maxQuan = 0; // Найти сокровища
        case 14: minQuan = 1, maxQuan = 0; // Открыть саркофаг в гробнице
        case 15: minQuan = 5, maxQuan = 15; // Собирать древние артефакты
        // Ферма
        case 16: minQuan = 50, maxQuan = 100; // Собирать яблоки
        case 17: minQuan = 2, maxQuan = 10; // Доить коров
        // Дальнобойщик
        case 18: minQuan = 1, maxQuan = 2; // Доставить грузы
        // Клининговая Служба
        case 19: minQuan = 1, maxQuan = 0; // Работать мусоровозом (Полностью загрузить мусоровоз и доставить мусор на базу)
        case 20: minQuan = 10, maxQuan = 20; // Работать мойщиком улиц (Количество раз очистить дорогу)
        // Водитель Автобуса
        case 21: minQuan = 1, maxQuan = 2; // Работать водителем автобуса (Полностью выполнить маршруты)
        case 22..26: minQuan = 1, maxQuan = 5; // Животных убить надо
        default: minQuan = 1, maxQuan = 0;
    }
}

stock DailyGPS(playerid, dailyid, createGps)
{
    if(dailyid >= 1 && dailyid <= 4)  // Рыбацкая бухта
    {
        if(createGps == 1) CreateGps(playerid,995.4814,-1955.7000,12.8842, 0, 0, 5.0);
    }
    else if(dailyid == 5)  // Спермобанк
    {
        if(createGps == 1) CreateGps(playerid,614.8055,-1542.3635,15.3872, 0, 0, 5.0);
    }
    else if(dailyid == 6 || dailyid >= 22 && dailyid <= 26)  // Лавка Лесника
    {
        if(createGps == 1) CreateGps(playerid,2464.9641, -890.7330, 99.8729, 0, 0, 5.0);
    }
    else if(dailyid >= 7 && dailyid <= 11) // NASA
    {
        if(createGps == 1) CreateGps(playerid,-1023.1989,2563.4631,42.3609, 0, 0, 5.0);
    }
    else if(dailyid >= 12 && dailyid <= 15) // Археология
    {
        if(createGps == 1) CreateGps(playerid,-336.2932,1725.8201,42.8567, 0, 0, 5.0);
    }
    else if(dailyid >= 16 && dailyid <= 17) // Ферма
    {
        if(createGps == 1) CreateGps(playerid,-59.7463,86.9567,3.1615, 0, 0, 5.0);
    }
    else if(dailyid >= 19 && dailyid <= 20) // Клининговая Служба
    {
        if(createGps == 1) FindCleaning(playerid);
    }
    else if(dailyid == 21) // Автобусное Депо
    {
        if(createGps == 1) FindBusDep(playerid);
    }
    else return 0;
    return 1;
}

stock IsDailyAvailableForPlayer(playerid, dailyid) // Требования для заданий
{
    switch(dailyid) 
    {
        case 5: // Спермобанк
        {
            if(PlayerInfo[playerid][pSex] == 1) return true; // Пол мужской, значит доступно
        }
        case 7..10: // NASA Луна
        {
            if(PlayerInfo[playerid][pPower] >= 2) return true; // Навык силы 2 уровень и выше, значит доступно
        }
        case 11: // NASA Марс
        {
            if(PlayerInfo[playerid][pPower] >= 2 // Навык силы 2 уровень и выше, значит доступно
                && PlayerInfo[playerid][pAbilStat][1] >= 3) return true; // Навык космонавта 3 и выше, значит доступно
        }
        default: return true; // Все остальные, доступны всегда
    }
    return false;
}


#define MAX_DAILY_QUEST_PLAYER 5 // Максимальное количество ежедневных заданий
enum dailyquestInfo
{
	daiID[MAX_DAILY_QUEST_PLAYER], // ID задания
    daiQuanNeed[MAX_DAILY_QUEST_PLAYER], // Необходимо выполнить (количество повторений)
    daiQuan[MAX_DAILY_QUEST_PLAYER], // Выполнено повторений
    bool:daiStatus[MAX_DAILY_QUEST_PLAYER], // Статус выполненого задания
    daiDay, // Номер дня, в который необходимо выполнить текущие задания
    bool:daiLoaded, // Статус загрузки из базы данных
    bool:daiFull, // Квест полностью пройден
    bool:daiChange // Статус замены одного задания в день
}
new DailyInfo[MAX_REALPLAYERS][dailyquestInfo];

alias:createdaily("resetdaily")
CMD:createdaily(playerid, const params[])
{
    if (PlayerInfo[playerid][pSoska] < 8) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    new targetid, taskid;
    if (sscanf(params, "uD(-1)", targetid, taskid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Перезапустить ежедневные задания игроку [ /createdaily ID Задание ]");
    if (taskid == -1
        || taskid > MAX_DAILY_QUEST_PLAYER) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Номер задания должен быть от 1 до %d [ 0 - Все задания ]", MAX_DAILY_QUEST_PLAYER);
    if (!IsOnline(targetid)) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети");

    if (taskid == 0) 
    {
        if(DailyInfo[targetid][daiFull] == true && PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Игрок выполнил все ежедневные задания, нельзя заменить");
        // Перезапуск всех квестов
        SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы перезапустили ежедневные задания для %s", PlayerInfo[targetid][pName]);
        SendClientMessage(targetid, COLOR_LIGHTBLUE, "* Администратор %s перезапустил ваши ежедневные задания", PlayerInfo[playerid][pName]);
        CreateDaily(targetid, 1);
    } else 
    {
        if(DailyInfo[targetid][daiStatus][taskid - 1] == true && PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Нельзя заменить выполненное задание");

        // Перезапуск конкретного квеста
        SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы перезапустили ежедневное задание №%d для %s", taskid, PlayerInfo[targetid][pName]);
        SendClientMessage(targetid, COLOR_LIGHTBLUE, "* Администратор %s перезапустил ваше ежедневное задание №%d", PlayerInfo[playerid][pName], taskid);
        CreateDaily(targetid, 1, taskid - 1);
    }

    AdminLog(
        "createdaily",
        PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP],
        PlayerInfo[targetid][pID], PlayerInfo[targetid][pName], PlayerInfo[targetid][pPlaIP],
        taskid,
        "Перезапустил ежедневное(ые) задание(я)"
    );

    return 1;
}

CMD:checkdaily(playerid, const params[])
{
    if (PlayerInfo[playerid][pSoska] < 3) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    new targetid;
    if (sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Просмотреть ежедневные задания игрока [ /checkdaily ID ]");
    if (!IsOnline(targetid)) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети");
    
    return showDialogDailyQuest(playerid, targetid);
}

stock GetUniqueDailyForPlayer(playerid) {
    const MAX_ATTEMPTS = 30;
    for (new i = 0; i < MAX_ATTEMPTS; i++) {
        new dailyId = random(sizeof(dailyName) - 1) + 1;
        if (!IsDailyAvailableForPlayer(playerid, dailyId)) {
            // Задание недоступно: не засчитываем эту попытку поиска задания и продолжаем дальше
            i--;
            continue;
        }

        new bool: isUnique = true;
        for (new j = 0; j < MAX_DAILY_QUEST_PLAYER; j++) {
            if (GetDailyType(DailyInfo[playerid][daiID][j]) == GetDailyType(dailyId)) {
                isUnique = false;
                break;
            }
        }

        // Задание повторяется: пытаемся найти ещё раз
        if (!isUnique) continue;
        
        // Уникальное задание найдено - возвращаем его
        return dailyId;
    }
    // Задание не найдено: возвращаем задание №0 "нет"
    return 0;
}

stock CreateDaily(playerid, forced, taskid = -1) 
{
    if(DailyInfo[playerid][daiDay] == getdate() && forced == 0) return 0; // Если день тот-же и мы не перезапускаем квесты, тогда игнорим

    if (taskid == -1) {
        for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++) 
        {
            new dailyid = GetUniqueDailyForPlayer(playerid);
            if(dailyid > 0)
            {
                CreateDailySlotForPlayer(playerid, i, dailyid);
            }
        }
    } else {
        CreateDailySlotForPlayer(playerid, taskid, GetUniqueDailyForPlayer(playerid));
    }

    DailyInfo[playerid][daiFull] = false; // Сбрасываем статус выполненных заданий
    DailyInfo[playerid][daiChange] = false; // Сбрасываем статус возможности заменить одно задание в день бесплатно
    DailyInfo[playerid][daiDay] = getdate(); // записываем сегодняшний день

    SaveDailyQuests(playerid);
    return 1;
}

stock CreateDailySlotForPlayer(playerid, slot, dailyid) // Записываем задание в слот
{
    if(slot < 0 || slot >= MAX_DAILY_QUEST_PLAYER) return 0;

    // Получаем диапазоны количества для задания
    new minQuan, maxQuan, dailyQuan;
    GetDailyQuanMinMax(dailyid, minQuan, maxQuan);

    // Расчитываем количество
    if(maxQuan == 0) dailyQuan = minQuan;
    else dailyQuan = minQuan + random(maxQuan);

    DailyInfo[playerid][daiID][slot] = dailyid; // id задания
    DailyInfo[playerid][daiQuanNeed][slot] = dailyQuan; // количество
    DailyInfo[playerid][daiQuan][slot] = 0; // очищаем процесс выполнения
    DailyInfo[playerid][daiStatus][slot] = false; // очищаем статус выполненного
    return 1;
}

stock CompletingDaily(playerid, dailyid, quan)
{
    if(DailyInfo[playerid][daiFull] == true  // Если сегодня квесты завершены, просто не лезем дальше
        || DailyInfo[playerid][daiLoaded] == false // Квесты ещё не загрузились
        || dailyid <= 0 || dailyid >= sizeof(dailyName)) return 0; // Невалидный id блокируем, на всякий пожарный

    new bool:yesComplete, slot = -1;
    for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++)
    {
        if(DailyInfo[playerid][daiID][i] == dailyid && DailyInfo[playerid][daiStatus][i] == false) // Нашли нужное задание
        {
            slot = i;
            DailyInfo[playerid][daiQuan][i] += quan; // Плюсуем процесс

            if(DailyInfo[playerid][daiQuan][i] >= DailyInfo[playerid][daiQuanNeed][i]) // Условие выполнено
            {
                DailyInfo[playerid][daiStatus][i] = true; // Задание выполнено
                yesComplete = true;
            }
            break;
        }
    }
    if(yesComplete) // Задание было выполнено, ищем есть ли ещё задания сегодня
    {
        new string[150];
        new noComplete = GetNoCompleteDailyQuan(playerid);
        if(noComplete > 0) // Нашли невыполненные задания
        {
            format(string, sizeof(string), "{0088ff}Вы выполнили ежедневное задание {ffcc66}%s {cccccc}[ Осталось %d заданий, чтобы получить шкатулку ]", dailyName[dailyid], noComplete);
            SendClientMessage(playerid, COLOR_GREY, string);
        }
        else // Все задания выполнены
        {
            DailyInfo[playerid][daiFull] = true;

            mysql_tquery(pearsq, "START TRANSACTION;");
            new thingId, thingQuan, thingType, thingPara, thingPack;
            CreateCasePlayer(playerid,thingId, thingQuan, thingType, thingPara, thingPack);
            new plit = GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
            CalculateVehicleLimited(thingId, thingType);
            mysql_tquery(pearsq, "COMMIT;");

            if(plit == -1)
            {
                Throw(playerid, thingId, thingQuan, 0, 0, thingType, thingPack);
                SendClientMessage(playerid, COLOR_GREY, "{0088ff}Вы выполнили все ежедневные задания {ffcc66}[ В инвентаре нет места, шкатулка упала на землю ]");
            }
            else
            {
                SendClientMessage(playerid, COLOR_GREY, "{0088ff}Вы выполнили все ежедневные задания {ffcc66}[ Проверьте инвентарь, там вас ждёт шкатулка ]");
            }

            PlayerInfo[playerid][pExp] ++;
	        UpdatePlayerExp(playerid);
            CompleteBattlePassTask(playerid, 0, 0);
        }
    }

    if(slot >= 0) SaveDailyQuestSlot(playerid, slot); // Нашли слот, значит сохраняем
    return 1;
}

stock GetNoCompleteDailyQuan(playerid)
{
    new quan;
    for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++)
    {
        if(DailyInfo[playerid][daiID][i] > 0 && DailyInfo[playerid][daiStatus][i] == false) quan ++;
    }
    return quan;
}

stock showDialogDailyQuest(playerid, targetid = -1)
{
    if (targetid == -1) targetid = playerid;
    if (DailyInfo[targetid][daiLoaded] == false) return ErrorMessage(playerid, "{FF6347}Квесты не загрузились на аккаунт\n{cccccc}Подождите немного, пока аккаунт полностью загрузится :)");

    new line[214], lines[214 * MAX_DAILY_QUEST_PLAYER], quan;
    format(line, sizeof(line), "{cccccc}Задание\t{cccccc}Статус"), strcat(lines, line);

    if (playerid == targetid) format(line, sizeof(line), "\n{99ff66}Информация о Заданиях"), strcat(lines, line);
    for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++)
    {
        List[i][targetid] = 0;
        if(DailyInfo[targetid][daiID][i] > 0)
        {
            if(DailyInfo[targetid][daiStatus][i] == false)
            {
                format(line, sizeof(line), "\n{ff9000}%d. %s\t{cccccc}%d / %d", i + 1, dailyName[DailyInfo[targetid][daiID][i]], DailyInfo[targetid][daiQuan][i], DailyInfo[targetid][daiQuanNeed][i]), strcat(lines, line);
            }
            else format(line, sizeof(line), "\n{cccccc}%d. %s\t{99ff66}Выполнен", i + 1, dailyName[DailyInfo[targetid][daiID][i]]), strcat(lines, line);
            List[quan][targetid] = i;
            quan ++;
        }
    }

    SetPVarInt(playerid, "IsMyDailyQuests", playerid == targetid);

    new dialog_header[100] = "{ff9000}Ежедневные Задания";
    if (playerid != targetid) format(dialog_header, sizeof(dialog_header), "%s (%s)", dialog_header, rpplayername(targetid));

    ShowDialog(playerid, 460, DIALOG_STYLE_TABLIST_HEADERS, dialog_header, lines, "Выбор", "Отмена");
    return 1;
}

// Выбор или замена задания
stock showDialogSelectDailyQuest(playerid, dailyid)
{
    new line[100],lines[300];
    format(line,sizeof(line),"{ff9000}%s", dailyName[dailyid]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Выполнить задание {99ff66}>>"), strcat(lines,line);
    if(DailyInfo[playerid][daiChange] == false) format(line,sizeof(line),"\n{FF6347}Заменить задание {cccccc}[ Бесплатно ]"), strcat(lines,line);
    else format(line,sizeof(line),"\n{FF6347}Заменить задание {ffcc00}[ %dG ]", GetPriceGoldDonateMenu(14)), strcat(lines,line);

    ShowDialog(playerid, 435, DIALOG_STYLE_TABLIST_HEADERS, "{ff9000}Ежедневные Задания", lines, "Выбор", "Отмена");
    return true;
}

// Предлагаем заменить задание
stock showDialogChangeDailyQuest(playerid, dailyid)
{
    new line[100],lines[300];
    format(line,sizeof(line),"{ff9000}%s", dailyName[dailyid]), strcat(lines,line);
    format(line,sizeof(line),"\n\n{ffcc66}Вы уверены, что хотите заменить это задание?"), strcat(lines,line);
    if(DailyInfo[playerid][daiChange] == false) format(line,sizeof(line),"\n{ffcc66}Вы можете заменить бесплатно только одно задание в день"), strcat(lines,line);
    else format(line,sizeof(line),"\n{ffcc66}Стоимость замены задания: {ffcc00}%dG", GetPriceGoldDonateMenu(14)), strcat(lines,line);
    ShowDialog(playerid, 434, DIALOG_STYLE_MSGBOX, "{ff9000}Ежедневные Задания", lines, "Да", "Нет");
    return true;
}

stock dialogCase_DailyQuest(playerid, dialogid, response, listitem)
{
    if(dialogid == 460)
    {
        new bool: is_my_quests = GetPVarInt(playerid, "IsMyDailyQuests") == 1; DeletePVar(playerid, "IsMyDailyQuests");
        if (!is_my_quests) return 1;

        if(response)
        {
            if(listitem == 0) // Информация о Ежедневных Заданиях
            {
                static const lines[] =
                    "{ffcc66}Что такое ежедневные задания?" \
                    "\n{cccccc}- Это небольшие действия, которые нужно выполнить, чтобы получить шкатулку" \
                    "\n{cccccc}- После выполнения задания вы так-же получаете +1 Exp [ /stats ]" \
                    "\n{cccccc}- Большинство заданий связано со стандартными работами" \
                    "\n{cccccc}- Однако, иногда вам могут попадаться уникальные задания" \
                    \
                    "\n\n{ffcc66}Сколько даётся времени на выполнение заданий?" \
                    "\n{cccccc}- Ежедневные задания обновляются 1 раз в день" \
                    "\n{cccccc}- Обновление происходит в тот момент, когда вы заходите на сервер" \
                    \
                    "\n\n{ffcc66}Что в шкатулке?" \
                    "\n{cccccc}- В шкатулке могут находиться как мелкие предметы, не имеющие ценности," \
                    "\n{cccccc}так и большие подарки." \
                    "\n{cccccc}Например: одежда, транспорт, деньги и даже золото";

                ShowDialog(playerid, 458, DIALOG_STYLE_MSGBOX, "{ff9000}Ежедневные Задания", lines, "*", "");
                return 1;
            }

            if(listitem < 1 || listitem > MAX_DAILY_QUEST_PLAYER) return 1;
            new slot = List[listitem - 1][playerid];

            if(DailyInfo[playerid][daiStatus][slot] == true) showDialogDailyQuest(playerid); // Задание выполнено
            else
            {
                new dailyid = DailyInfo[playerid][daiID][slot];
                DP[0][playerid] = dailyid;
                DP[1][playerid] = slot;

                showDialogSelectDailyQuest(playerid, dailyid);
            }
        }
        else pc_cmd_quest(playerid);
        return true;
    }
    else if(dialogid == 458) 
    {
        showDialogDailyQuest(playerid);
        return true;
    }
    else if(dialogid == 454)
    {
        if(response)
        {
            DailyGPS(playerid, DP[0][playerid], 1);
            SuccessMessage(playerid, "{99ff66}Место для выполнения задания отмечено GPS меткой");
        }
        else showDialogSelectDailyQuest(playerid, DP[0][playerid]);
        return true;
    }

    // Выбор задания или его замена
    else if(dialogid == 435)
    {
        new dailyid = DP[0][playerid];
        if(response)
        {
            // Выполняем задание
            if(listitem == 0)
            {
                new resultGps = DailyGPS(playerid, dailyid, 0);
                new line[214],lines[4096];
                format(line,sizeof(line),"{ff9000}%s", dailyName[dailyid]), strcat(lines,line);
                if(dailyid >= 22 && dailyid <=26) format(line,sizeof(line),"\n\n{cccccc}%s", dailyDescription[6]), strcat(lines,line);
                else format(line,sizeof(line),"\n\n{cccccc}%s", dailyDescription[dailyid]), strcat(lines,line);
                if(resultGps == 1) // Только если GPS метка существует (У некоторых заданий нет места выполнения)
                {
                    format(line,sizeof(line),"\n\n{ffcc66}Хотите отправиться выполнять задание?"), strcat(lines,line);
                    ShowDialog(playerid,454,DIALOG_STYLE_MSGBOX,"{ff9000}Ежедневные Задания",lines,"Да","Нет");
                }
                else
                {
                    format(line,sizeof(line),"\n\n{666666}У этого задания нет места выполнения"), strcat(lines,line);
                    format(line,sizeof(line),"\n{666666}Просто следуйте подсказкам"), strcat(lines,line);
                    ShowDialog(playerid,458,DIALOG_STYLE_MSGBOX,"{ff9000}Ежедневные Задания",lines,"Ок","");
                }
            }

            // Заменяем задание
            else if(listitem == 1) showDialogChangeDailyQuest(playerid, dailyid);
        }
        else showDialogDailyQuest(playerid);
        return true;
    }

    // Диалог предупреждения о замене задания
    else if(dialogid == 434)
    {
        if(response)
        {
            if(DailyInfo[playerid][daiChange] == true)
            {
                if(GetPriceGoldDonateMenu(14) > PlayerInfo[playerid][pDonateMoney]) return ErrorMessage(playerid, "{FF6347}Вам не хватает золота");
                PlayerInfo[playerid][pDonateMoney] -= GetPriceGoldDonateMenu(14);
                tclArifmetikAllGold -= GetPriceGoldDonateMenu(14);
    	        mysql_save(playerid, 4);
		        DonateLog("changedaily", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -GetPriceGoldDonateMenu(14), "Заменил задание");
            
                new string[80];
                format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~3AѓAH…E 3AMEHEHO: ~y~-%dG", GetPriceGoldDonateMenu(14));
                GameTextForPlayer(playerid,string,4000,3);
            }
            else
            {
                DailyInfo[playerid][daiChange] = true;
                SaveDailyQuestChange(playerid);
            }

            new slot = DP[1][playerid];
            new findDaily = GetUniqueDailyForPlayer(playerid);
            if(findDaily > 0)
            {
                CreateDailySlotForPlayer(playerid, slot, findDaily);
            }
            showDialogDailyQuest(playerid);

            PlayerPlaySound(playerid,6401,0,0,0);
            GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~3AѓAH…E 3AMEHEHO",4000,3);

            // Сохраняем задание в слоте
            SaveDailyQuestSlot(playerid, slot);
        }
        else showDialogSelectDailyQuest(playerid, DP[0][playerid]);
    }
    return false;
}

function OnPlayerQuestsLoad(playerid)
{
    new rows, string[128];
    cache_get_row_count(rows);
    if(rows)
    {
        cache_get_value_name_int(0, "daiDay", DailyInfo[playerid][daiDay]);
        cache_get_value_name_bool(0, "daiFull", DailyInfo[playerid][daiFull]);
        cache_get_value_name_bool(0, "daiChange", DailyInfo[playerid][daiChange]);
        for (new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++)
        {
            format(string, sizeof(string), "daiID_%d", i);
            cache_get_value_name_int(0, string, DailyInfo[playerid][daiID][i]);

            format(string, sizeof(string), "daiQuanNeed_%d", i);
            cache_get_value_name_int(0, string, DailyInfo[playerid][daiQuanNeed][i]);

            format(string, sizeof(string), "daiQuan_%d", i);
            cache_get_value_name_int(0, string, DailyInfo[playerid][daiQuan][i]);

            format(string, sizeof(string), "daiStatus_%d", i);
            cache_get_value_name_bool(0, string, DailyInfo[playerid][daiStatus][i]);
        }
    }
    DailyInfo[playerid][daiLoaded] = true;

    // Создаём ежедневные задания
	CreateDaily(playerid, 0);

    // Если задания не выполнены, пишем уведомление
    if(DailyInfo[playerid][daiFull] == false) 
    {
        SendClientMessage(playerid, COLOR_GREY,"{0088ff}Выполните ежедневные задания и получите шкатулку в подарок {ffcc66}[ Y >> Квесты ]");
    }
    return 1;
}

stock SaveDailyQuestChange(playerid)
{
    if (DailyInfo[playerid][daiLoaded] == false) return 0;

    new string_mysql[100];

    // Формируем запрос для обновления одного слота квеста
    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_quests` SET daiChange = %d WHERE user_id = %d", 
        DailyInfo[playerid][daiChange], PlayerInfo[playerid][pID]);

    // Отправляем запрос в базу данных
    mysql_tquery(pearsq, string_mysql, "", "");
    return 1;
}

stock SaveDailyQuestSlot(playerid, slot)
{
    if (slot < 0 || slot >= MAX_DAILY_QUEST_PLAYER || DailyInfo[playerid][daiLoaded] == false) return 0;

    new string_mysql[260];

    // Формируем запрос для обновления одного слота квеста
    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_quests` SET \
        daiFull = %d, daiID_%d = %d, daiQuanNeed_%d = %d, daiQuan_%d = %d, \
        daiStatus_%d = %d WHERE user_id = %d", 
        DailyInfo[playerid][daiFull], slot, DailyInfo[playerid][daiID][slot], slot, DailyInfo[playerid][daiQuanNeed][slot], slot, DailyInfo[playerid][daiQuan][slot], 
        slot, DailyInfo[playerid][daiStatus][slot], PlayerInfo[playerid][pID]);

    // Отправляем запрос в базу данных
    mysql_tquery(pearsq, string_mysql, "", "");
    return 1;
}

stock SaveDailyQuests(playerid)
{
    new string_mysql[1600], part[280];

    // Начальная часть запроса с daiDay
    format(string_mysql, sizeof(string_mysql), "INSERT INTO `pp_quests` (user_id, daiDay, daiFull, daiChange");

    // Добавляем названия остальных столбцов
    for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++) 
    {
        format(part, sizeof(part), ", daiID_%d, daiQuanNeed_%d, daiQuan_%d, daiStatus_%d", i, i, i, i);
        strcat(string_mysql, part);
    }

    // Добавляем значения для daiDay и user_id
    format(part, sizeof(part), ") VALUES (%d, %d, %d, %d", PlayerInfo[playerid][pID], DailyInfo[playerid][daiDay], DailyInfo[playerid][daiFull], DailyInfo[playerid][daiChange]);
    strcat(string_mysql, part);

    // Добавляем значения для остальных столбцов
    for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++) 
    {
        format(part, sizeof(part), ", %d, %d, %d, %d", DailyInfo[playerid][daiID][i], DailyInfo[playerid][daiQuanNeed][i], DailyInfo[playerid][daiQuan][i], DailyInfo[playerid][daiStatus][i]);
        strcat(string_mysql, part);
    }

    // Добавляем ON DUPLICATE KEY UPDATE с упрощенными значениями
    format(string_mysql, sizeof(string_mysql),
        "%s) ON DUPLICATE KEY UPDATE daiDay = VALUES(daiDay), daiFull = VALUES(daiFull), daiChange = %d",
        string_mysql, DailyInfo[playerid][daiChange]
    );

    for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++) 
    {
        format(part, sizeof(part), ", daiID_%d = VALUES(daiID_%d), daiQuanNeed_%d = VALUES(daiQuanNeed_%d), daiQuan_%d = VALUES(daiQuan_%d), daiStatus_%d = VALUES(daiStatus_%d)", i, i, i, i, i, i, i, i);
        strcat(string_mysql, part);
    }

    // Отправляем запрос в базу данных
    mysql_tquery(pearsq, string_mysql, "", "");
    return 1;
}


#define MAX_DAILY_QUEST_PLAYER 5 // Максимальное количество ежедневных заданий

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
    "Охотиться на оленя", // 6
    // NASA Луна - Марс
    "Собирать метеориты", // 7
    "Собирать базальт", // 8
    "Собирать палладий", // 9
    "Чистить солнечные панели", // 10
    "Собирать данные со спутниковой тарелки", // 11
    // NASA Марс
    "Выращивать картошку", // 12
    // Археология
    "Пройти лабиринт", // 13
    "Найти сокровища", // 14
    "Открыть саркофаг в гробнице", // 15
    "Собирать древние артефакты", // 16
    // Ферма
    "Собирать яблоки", // 17
    "Доить коров", // 18
    // Дальнобойщик
    "Доставить грузы", // 19
    // Мусоровоз
    "Работать мусоровозом", // 20
    "Работать мойщиком улиц", // 21
    // Водитель Автобуса
    "Работать водителем автобуса" // 22
};

enum dailyquestInfo
{
	daiID[MAX_DAILY_QUEST_PLAYER], // ID задания
    daiQuanNeed[MAX_DAILY_QUEST_PLAYER], // Необходимо выполнить (количество повторений)
    daiQuan[MAX_DAILY_QUEST_PLAYER], // Выполнено повторений
    bool:daiStatus[MAX_DAILY_QUEST_PLAYER], // Статус выполненого задания
    daiDay, // Номер дня, в который необходимо выполнить текущие задания
    bool:daiLoaded, // Статус загрузки из базы данных
}
new DailyInfo[MAX_REALPLAYERS][dailyquestInfo];

stock GetDailyQuanMinMax(dailyid, &minQuan, &maxQuan) // Получаем диапазон количества выполняемого действия для квеста
{
    switch(dailyid)
    {
        // Рыбалка
        case 1: minQuan = 50, maxQuan = 250; // Ловить Рыбу (в килограммах)
        case 2: minQuan = 1, maxQuan = 3; // Ловить Акулу
        case 3: minQuan = 5, maxQuan = 10; // Собрать морские звёзды
        case 4: minQuan = 5, maxQuan = 10; // Собрать ракушки
        // Спермобанк ЕСТЬ ТРЕБОВАНИЕ
        case 5: minQuan = 1, maxQuan = 2; // Сдать семя (Количество раз)
        // Охота
        case 6: minQuan = 1, maxQuan = 2; // Охотиться на оленя (Количество раз)
        // NASA Луна - Марс ЕСТЬ ТРЕБОВАНИЯ
        case 7: minQuan = 10, maxQuan = 30; // Собирать метеориты
        case 8: minQuan = 20, maxQuan = 50; // Собирать базальт
        case 9: minQuan = 5, maxQuan = 10; // Собирать палладий
        case 10: minQuan = 2, maxQuan = 8; // Чистить солнечные панели
        case 11: minQuan = 1, maxQuan = 3; // Собирать данные со спутниковой тарелки
        // NASA Марс ЕСТЬ ТРЕБОВАНИЯ
        case 12: minQuan = 10, maxQuan = 20; // Выращивать картошку (Собрать клубней картошки)
        // Археология
        case 13: minQuan = 1, maxQuan = 0; // Пройти лабиринт
        case 14: minQuan = 1, maxQuan = 0; // Найти сокровища
        case 15: minQuan = 1, maxQuan = 0; // Открыть саркофаг в гробнице
        case 16: minQuan = 5, maxQuan = 15; // Собирать древние артефакты
        // Ферма
        case 17: minQuan = 50, maxQuan = 100; // Собирать яблоки
        case 18: minQuan = 2, maxQuan = 10; // Доить коров
        // Дальнобойщик
        case 19: minQuan = 1, maxQuan = 2; // Доставить грузы
        // Мусоровоз
        case 20: minQuan = 1, maxQuan = 0; // Работать мусоровозом (Полностью загрузить мусоровоз и доставить мусор на базу)
        case 21: minQuan = 10, maxQuan = 20; // Работать мойщиком улиц (Количество раз очистить дорогу)
        // Водитель Автобуса
        case 22: minQuan = 1, maxQuan = 2; // Работать водителем автобуса (Полностью выполнить маршруты)
        default: minQuan = 1, maxQuan = 0;
    }
}

CMD:createdaily(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 3) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Перезапустить ежедневные задания игроку [ /createdaily ID ]");
    if(!IsOnline(params[0])) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети");

    new string[120];
    format(string, sizeof(string), "* Вы перезапустили ежедневные задания для %s", PlayerInfo[params[0]][pName]);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);

    format(string, sizeof(string), "* Администратор %s перезапустил ваши ежедневные задания", PlayerInfo[playerid][pName]);
	SendClientMessage(params[0], COLOR_LIGHTBLUE, string);
    CreateDaily(params[0], 1);
    return 1;
}

stock IsDailyAvailableForPlayer(playerid, dailyid) // Проверка требований для задания
{
    switch(dailyid) 
    {
        case 5: // Спермобанк
        {
            if(PlayerInfo[playerid][pSex] == 1) return true; // Пол мужской, значит доступно
        }
        case 7..11: // NASA Луна
        {
            if(PlayerInfo[playerid][pPower] >= 2) return true; // Навык силы 2 уровень и выше, значит доступно
        }
        case 12: // NASA Марс
        {
            if(PlayerInfo[playerid][pPower] >= 2 // Навык силы 2 уровень и выше, значит доступно
                && PlayerInfo[playerid][pAbilStat][1] >= 3) return true; // Навык космонавта 3 и выше, значит доступно
        }
        default: return true; // Все остальные, доступны всегда
    }
    return false;
}

stock SelectUniqueDailyForSlot(playerid, slot) {
    new dailyid, isUnique, attempts = 0;

    do {
        dailyid = random(sizeof(dailyName) - 1) + 1; // Выбираем случайное задание, начиная с 1
        if (!IsDailyAvailableForPlayer(playerid, dailyid)) continue; // Проверяем требования для задания

        isUnique = true;

        // Проверяем, не было ли это задание уже выбрано в других слотах
        for(new j = 0; j < slot; j++) {
            if(DailyInfo[playerid][daiID][j] == dailyid) {
                isUnique = false;
                break;
            }
        }

        attempts++;
        if(attempts > 10) { // Ограничение попыток, чтобы избежать бесконечного цикла
            return 0; // Возвращаем 0 (задание "нет"), если не удается найти уникальное
        }
    } while (!isUnique);

    return dailyid;
}

stock CreateDaily(playerid, forced) 
{
    if(DailyInfo[playerid][daiDay] == getdate() && forced == 0) return 0; // Если день тот-же и мы не перезапускаем квесты, тогда игнорим

    for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++) 
    {
        new dailyid = SelectUniqueDailyForSlot(playerid, i);
        if(dailyid > 0) 
        {
            CreateDailySlotForPlayer(playerid, i, dailyid);
        }
    }

    SaveDailyQuests(playerid);
    return 1;
}

stock ClearAllDaily(playerid)
{
    for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++) ClearDaily(playerid, i);
}

stock ClearDaily(playerid, slot)
{
    DailyInfo[playerid][daiID][slot] = 0;
    DailyInfo[playerid][daiQuanNeed][slot] = 0;
    DailyInfo[playerid][daiQuan][slot] = 0;
    DailyInfo[playerid][daiStatus][slot] = false;
    DailyInfo[playerid][daiDay] = 0;
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
    DailyInfo[playerid][daiDay] = getdate(); // записываем сегодняшний день
    return 1;
}

stock showDialogDailyQuest(playerid)
{
    if(DailyInfo[playerid][daiLoaded] == false) return ErrorMessage(playerid, "{FF6347}Квесты не загрузились на ваш аккаунт\n{cccccc}Подождите немного, пока ваш аккаунт полность загрузится :)");

    new line[214], lines[4096], quan;
    format(line,sizeof(line),"{cccccc}Задание\t{cccccc}Статус"), strcat(lines,line);

    format(line,sizeof(line),"\n{99ff66}Информация о Заданиях"), strcat(lines,line);
    for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++)
    {
        List[i][playerid] = 0;
        if(DailyInfo[playerid][daiID][i] > 0)
        {
            if(DailyInfo[playerid][daiStatus][i] == false)
            {
                format(line,sizeof(line),"\n{ff9000}%d. %s\t{cccccc}%d / %d", i + 1, dailyName[DailyInfo[playerid][daiID][i]], DailyInfo[playerid][daiQuan][i], DailyInfo[playerid][daiQuanNeed][i]), strcat(lines,line);
            }
            else format(line,sizeof(line),"\n{cccccc}%d. %s\t{99ff66}Выполнен", i + 1, dailyName[DailyInfo[playerid][daiID][i]]), strcat(lines,line);
            List[quan][playerid] = i;
            quan ++;
        }
    }
    ShowDialog(playerid,460,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Ежедневные Задания",lines,"Выбор","Отмена");
    return 1;
}

stock dialogCase_DailyQuest(playerid, dialogid, response, listitem)
{
    if(dialogid == 460)
    {
        if(response)
        {
            if(listitem == 0) // Информация о Ежедневных Заданиях
            {

                return 1;
            }

            if(listitem < 1 || listitem > MAX_DAILY_QUEST_PLAYER) return 1;
            new slot = List[listitem][playerid];

            if(DailyInfo[playerid][daiStatus][slot] == true) showDialogDailyQuest(playerid); // Задание выполнено
            else 
            {
                // Тут будем читать информацию о задании
                // Чё нужно сделать, какие требования, описание
                // А так же спрашиваем: метку gps ставим, чтобы отправиться к заданию?
                // Ну и далее ставим метку gps
            }
        }
        else cmd_quest(playerid);
    }
    return 1;
}

function OnPlayerQuestsLoad(playerid)
{
    new rows, string[128];
    cache_get_row_count(rows);
    if(rows)
    {
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
        cache_get_value_name_int(0, "daiDay", DailyInfo[playerid][daiDay]);
    }
    DailyInfo[playerid][daiLoaded] = true;

    // Создаём ежедневные задания
	CreateDaily(playerid, 0);
    return 1;
}

stock SaveDailyQuests(playerid)
{
    new string_mysql[800], part[240];

    // Начальная часть запроса с daiDay
    format(string_mysql, sizeof(string_mysql), "INSERT INTO `pp_quests` (user_id, daiDay");

    // Добавляем названия остальных столбцов
    for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++) 
    {
        format(part, sizeof(part), ", daiID_%d, daiQuanNeed_%d, daiQuan_%d, daiStatus_%d", i, i, i, i);
        strcat(string_mysql, part);
    }

    // Добавляем значения для daiDay и user_id
    format(part, sizeof(part), ") VALUES (%d, %d", PlayerInfo[playerid][pID], DailyInfo[playerid][daiDay]);
    strcat(string_mysql, part);

    // Добавляем значения для остальных столбцов
    for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++) 
    {
        format(part, sizeof(part), ", %d, %d, %d, %d", DailyInfo[playerid][daiID][i], DailyInfo[playerid][daiQuanNeed][i], DailyInfo[playerid][daiQuan][i], DailyInfo[playerid][daiStatus][i]);
        strcat(string_mysql, part);
    }

    // Добавляем ON DUPLICATE KEY UPDATE с упрощенными значениями
    strcat(string_mysql, ") ON DUPLICATE KEY UPDATE daiDay = VALUES(daiDay)");

    for(new i = 0; i < MAX_DAILY_QUEST_PLAYER; i++) 
    {
        format(part, sizeof(part), ", daiID_%d = VALUES(daiID_%d), daiQuanNeed_%d = VALUES(daiQuanNeed_%d), daiQuan_%d = VALUES(daiQuan_%d), daiStatus_%d = VALUES(daiStatus_%d)", i, i, i, i, i, i, i, i);
        strcat(string_mysql, part);
    }

    // Отправляем запрос в базу данных
    mysql_tquery(pearsq, string_mysql, "", "");
    return 1;
}

new BattlePassDailyTaskName[][] =
{
    "Выполнить ежедневные задания (/quest)", 
    "Откопать сокровища археологии", 
    "Открыть 3 любых кейса",
    "Отыграть 3 часа"
};

new BattlePassDailyTaskSetting[sizeof(BattlePassDailyTaskName)][2] =
{
    // 1 - Exp, 2 - Count
    { 100, 1},        // 0 
    { 100, 1},        // 1
    { 100, 3},        // 2
    { 100, 3}         // 2
};

new BattlePassWeeklyTaskDescription[][] =
{
    "- Вам нужно отправиться на работу (/job), после заработать нужную сумму", // 0
    "- Поезжайте в СТО (/gps > Автосервис), купите деталь повышающую характеристики"\
    "   \nвашего авто, либо же установите деталь через капот (если у вас имеется она)", // 1
    "- Мусорки разбросаны на территории городов, открывайте их и забирайте патроны", // 2
    "- Отправляйтесь на территорию шахты (/quest > заброшенная шахта), и поиграйте в ивент", // 3
    "- Отправляйтесь на территорию гробницы (/quest > гробница фараона), и поиграйте в ивент", // 4
    "- Отправляйтесь на территорию деревни (/quest > Деревенские), и поиграйте в ивент", // 5
    "- Включите радио и слушайте его (/radio)", // 6
    "- Сделайте так что бы игроки повысили вам репутацию (/rep)", // 7
    "- Отправляйтесь в казино (/gps > развлечение), сделайте ставку и выиграйте за раз 1.000.000$", // 8
    "- Нло появляется каждый час c 21:00 до 11:00, в разных городах. Вы можете искать его на карте"\
    "   \nДля выполнения вы должны выстрелить последний патрон, который собьет НЛО"\
    "   \nНавык космонавта упростит процесс поиска НЛО, прочитайте описание навыка(/skill)", // 9
    "- Отправляйтесь к Доминику (/quest > Доминик), начните гонку и победите его!", // 10
    "- Подробная информация как найти маньянка в меню квестов (/quest > Маньяк > Правила)", // 11
    "- Откапывате могилы на кладбище и ждите пока не начнется битва со скелетом/духом и победите их!", // 12
    "- Сокровища спавнятся 3 раза в день (10:00, 15:00, 20:00). Купите карту моряка для подробной информации", // 13
    "- Попросите кого-то управлять вертолетом, имейте веревку в инвентаре и воспользуйтесь командой (/rope)", // 14
    "- Возьмите биту в руки и оглушите ей игрока, если повезет с него упадет предмет (имеет КД)", // 15
    "- Убейте животное минимумом выстрелов, разделайте его, и получите шкуру отличного качества"\
    "   \nЖивотные водятся в лесах штата. Подробнее узнать можно в (/job > Охота)", // 16
    "- Отправляйтесь в леса штата в поисках медведя. Подробнее узнать можно в (/job > Охота)", // 17
    "- Отправляйтесь в леса штата в поисках оленей. Подробнее узнать можно в (/job > Охота)", // 18
    "- Отправляйтесь в леса штата в поисках лисов. Подробнее узнать можно в (/job > Охота)", // 19
    "- Отправляйтесь в леса штата в поисках волков. Подробнее узнать можно в (/job > Охота)", // 20
    "- Катайтесь на автомобиле по штату", // 21
    "- Катайтесь на мотоцикле по штату", // 22
    "- Летайте на самолете по штату", // 23
    "- Летайте на вертолете по штату", // 24
    "- Плавайте на катере по штату", // 25
    "- Прокачивайте навык на работах/станках/используя действия. Подробнее (/skill)", // 26
    "- Отправляйтесь в IKEA (/gps > Услуги > IKEA), и покупайте мебель", // 27
    "- Отправляйтесь в IKEA (/gps > Услуги > IKEA), и покупайте мебель",  // 28
    "- Просто помойтесь в душе в доме/отели/сауне.", // 29
    "- Отправляйтесь на кладбище в Лос-Сантосе. Возьмите лопату и раскапывайте могилы", // 30
    "- Подойдите, нажмите [ N ] и воспользуйтесь крафтовым столом/хим-лабороторией/станком для крафта предмета"\
    "   \nКупить их в дом можно в IKEA (gps > Услуги > IKEA)", // 31
    "- Подойдите к плите, нажмите [ N ], и в меню начните готовить блюдо"\
    "   \nКупить плиту в дом можно в IKEA (gps > Услуги > IKEA)", // 32
    "- Поучаствуйте в гонке от Семьи, и доедьте до финиша(во время гонок появляется значек финишного флага на карте)", // 33
    "- Поучаствуйте в гонке от Семьи, и доедьте до финиша первым", // 34
    "- Придите в спортзал (/gps > Услуги > Спортзал). И начните улучшать свою силу", // 35
    "- Отправляйтесь в здание правительства (/gps > Организации > Фракции), и покормите рыбок в аквариуме", // 36
    "- Вам тут еще нужно какое-то объяснение? А ну быстро смотреть Магическую Битву!!!!!", // 37
    "- Каждые 30 минут над территорией штата летит самолет с сумкой. Найдите и сбейте с него сумку", // 38
    "- Купите монтировку, отправляйтесь на лёд, возьмите монтировку в руку и нажмите [ ALT ]", // 39
    "- Купите или найдите отмычку, и взломайте ей любую дверь(Дома, Авто,Дверь Фракции, Генератора)", // 40
    "- Найдите точку пожертвований, подойдите к ней и нажмите [ ALT ] и сделайте пожертвование", // 41
    "- Отправляйтесь в тюрьму, у камер будет стоять бутылка, вам нужно сесть на неё нажимая кнопку [ C ]" // 42
};

new BattlePassWeeklyTaskName[][] =
{
    "Заработайте деньги на работе (где можно устроится)", // 0
    "Установите любую деталь тюнинга в авто", // 1
    "Найдите в мусорке оружейные патроны", // 2
    "Завершите битву в шахте", // 3
    "Завершите битву в гробнице", // 4
    "Завершите битву в деревне", // 5
    "Слушать Радио сервера (секунд)", // 6
    "Получить повышение репутации", // 7
    "Выиграть в казино за раз 1.000.000", // 8
    "Сбить НЛО", // 9
    "Выиграть Доминика", // 10
    "Убить маньяка", // 11
    "Убить Духа/Скелета на кладбище", // 12
    "Найти сокровища в море", // 13
    "Спустится с вертолета с помощью веревки", // 14
    "Выбить с игрока предмет битой", // 15
    "Получить шкур качеством 90 и больше", // 16
    "Убить медведей", // 17
    "Убить оленей", // 18
    "Убить лис", // 19
    "Убить волков", // 20
    "Повысить навык вождение автомобилем", // 21
    "Повысить навык вождение мото", // 22
    "Повысить навык пилотирования самолетом", // 23
    "Повысить навык пилотирования вертолетом", // 24
    "Повысить навык вождения катера", // 25
    "Повысить любой навык(кроме транспортных)", // 26
    "Купить мебель в IKEA на сумму", // 27
    "Купить мебель в IKEA", // 28
    "Помыться в душе", // 29
    "Раскопать могил", // 30
    "Скрафтить предметов", // 31
    "Приготовить на плите блюд", // 32
    "Завершите гонок", // 33
    "Займите 1 место в гонке", // 34
    "Прокачать силу", // 35
    "Покормите рыбок в правительстве", // 36
    "Победить сильнейшего", // 37
    "Сбить мешок с самолета", // 38
    "Продолбить дырку во льду", // 39
    "Взломать двери", // 40
    "Внести пожертвование (денег)", // 41
    "Сесть на бутылку" // 42
};


new BattlePassWeeklyTaskSetting[sizeof(BattlePassWeeklyTaskName)][2] =
{
    // 1 - ID, 2 - Exp, 2 - Count
    { 200, 100000},     // 0
    { 200, 3},          // 1
    { 200, 200},        // 2
    { 200, 4},          // 3
    { 200, 4},          // 4
    { 200, 4},          // 5 
    { 200, 1800},         // 6
    { 200, 10},         // 7
    { 200, 2},          // 8
    { 200, 3},          // 9
    { 200, 2},          // 10
    { 200, 2},          // 11
    { 200, 2},          // 12
    { 200, 2},          // 13 
    { 200, 10},          // 14
    { 200, 3},           // 15
    { 200, 10},           // 16
    { 200, 10},           // 17
    { 200, 15},           // 18
    { 200, 10},           // 19
    { 200, 10},           // 20
    { 200, 1000},           // 21
    { 200, 1000},           // 22
    { 200, 1000},           // 23
    { 200, 1000},           // 24
    { 200, 1000},           // 25
    { 200, 5000},          // 26
    { 200, 1000000},          // 27
    { 200, 20},          // 28
    { 200, 30},          // 29
    { 200, 30},          // 30
    { 200, 40},          // 31
    { 200, 10},          // 32
    { 200, 20},          // 33
    { 200, 2},          // 34
    { 200, 5000},          // 35
    { 200, 5},          // 36
    { 200, 2},          // 37
    { 200, 1},          // 38
    { 200, 10},          // 39
    { 200, 40},          // 40
    { 200, 1000000},          // 41
    { 200, 500}         // 42
};

new BattlePassOneTimeTaskName[][] =
{
    "Пройти новогодние квесты", // 0
    "Получить питомца", // 1
    "Открыть голд кейсов", // 2
    "Купите трейлер", // 3
    "Купите транспорт в салоне", // 4
    "Собрать подарков Санты" // 5
};


new BattlePassOneTimeTaskSetting[sizeof(BattlePassOneTimeTaskName)][2] =
{
    // 1 - Exp, 2 - Count
    { 1000, 1},         // 0
    { 1000, 1},         // 1
    { 1000, 10},        // 2
    { 1000, 1},         // 3
    { 1000, 3},         // 4
    { 1000, 20}         // 5
};

#define MAX_WEEKLY_BATTLEPASS_TASK 8 // Максимальное кол.во недельных заданий
#define MAX_LEVEL_BATTLEPASS 50 // Максимальный уровень боевого пропуска

new BattlePassAwarsdItem[MAX_LEVEL_BATTLEPASS][20] =
{
    // thingId, thingtype, quan, para, pack
    { 7, 0, 10,  0, 0,    0, 0, 0, 0, 0,     7, 0, 20, 0, 0,     0, 0, 0, 0, 0 }, 
    { 28, 0, 100, 0, 0,   29, 0, 100, 0, 0,   65, 0, 10, 0, 0,    66, 0, 10, 0, 0 },
    { 4, 0, 10,  0, 0,    70, 0, 5, 0, 0,     7, 0, 20, 0, 0,     8, 0, 2, 0, 0 },  
    { 28, 0, 100, 0, 0,   29, 0, 100, 0, 0,   65, 0, 50, 0, 0,    66, 0, 50, 0, 0 },
    { 1, 0, 1, 0, 5,     0, 0, 0, 0, 0,      1, 0, 1, 0, 13,      0, 0, 0, 0, 0 }, // 5
    { 252, 0, 1, 0, 0,     0, 0, 0, 0, 0,      254, 0, 1, 0, 0,      0, 0, 0, 0, 0 },
    { 253, 0, 1, 0, 0,     0, 0, 0, 0, 0,      254, 0, 1, 0, 0,      0, 0, 0, 0, 0 },
    { 60, 0, 10, 0, 0,     0, 0, 0, 0, 0,      60, 0, 40, 0, 0,      0, 0, 0, 0, 0 },
    { 238, 0, 10, 0, 0,     0, 0, 0, 0, 0,      238, 0, 40, 0, 0,      0, 0, 0, 0, 0 },
    { 1, 0, 1, 0, 13,     0, 0, 0, 0, 0,      1, 0, 1, 0, 15,      0, 0, 0, 0, 0 }, // 10
    { 60, 0, 20, 0, 0,     0, 0, 0, 0, 0,      182, 0, 1, 0, 0,      0, 0, 0, 0, 0 },
    { 7, 0, 10, 0, 0,     4, 0, 10, 0, 0,      7, 0, 40, 0, 0,      4, 0, 40, 0, 0 },
    { 225, 0, 5, 0, 0,     0, 0, 0, 0, 0,      225, 0, 10, 0, 0,      0, 0, 0, 0, 0 },
    { 30, 0, 100, 0, 0,     27, 0, 100, 0, 0,      67, 0, 10, 0, 0,      64, 0, 10, 0, 0 },
    { 12421, 2, 1, 0, 0,     0, 0, 0, 0, 0,      12422, 2, 1, 0, 0,      0, 0, 0, 0, 0 }, // 15
    { 95, 0, 1, 0, 0,     0, 0, 0, 0, 0,      94, 0, 1, 0, 0,      94, 0, 1, 0, 0 },
    { 52, 0, 1, 0, 0,     0, 0, 0, 0, 0,      251, 0, 1, 0, 0,      0, 0, 0, 0, 0 },
    { 175, 0, 1, 0, 0,     0, 0, 0, 0, 0,      176, 0, 1, 0, 0,      0, 0, 0, 0, 0 },
    { 12416, 2, 1, 0, 0,     0, 0, 0, 0, 0,      12417, 2, 1, 0, 0,      0, 0, 0, 0, 0 },
    { 1, 0, 1, 0, 5,     0, 0, 0, 0, 0,      1, 0, 1, 0, 14,      0, 0, 0, 0, 0  }, // 20
    { 70, 0, 5, 0, 0,     0, 0, 0, 0, 0,      8, 0, 2, 0, 0,      0, 0, 0, 0, 0 },
    { 60, 0, 15, 0, 0,     0, 0, 0, 0, 0,      60, 0, 30, 0, 0,      0, 0, 0, 0, 0 },
    { 238, 0, 15, 0, 0,     0, 0, 0, 0, 0,      238, 0, 30, 0, 0,      0, 0, 0, 0, 0 },
    { 207, 0, 1, 0, 0,     0, 0, 0, 0, 0,      208, 0, 1, 0, 0,      0, 0, 0, 0, 0 },
    { 252, 0, 1, 0, 0,     0, 0, 0, 0, 0,      254, 0, 1, 0, 0,      0, 0, 0, 0, 0 }, // 25
    { 211, 0, 1, 0, 0,     0, 0, 0, 0, 0,      213, 0, 1, 0, 0,      0, 0, 0, 0, 0 },
    { 217, 0, 1, 0, 0,     0, 0, 0, 0, 0,      215, 0, 1, 0, 0,      0, 0, 0, 0, 0 },
    { 218, 0, 1, 0, 0,     0, 0, 0, 0, 0,      219, 0, 1, 0, 0,      0, 0, 0, 0, 0 },
    { 221, 0, 1, 0, 0,     0, 0, 0, 0, 0,      222, 0, 1, 0, 0,      0, 0, 0, 0, 0 },
    { 1, 0, 1, 0, 5,     0, 0, 0, 0, 0,      1, 0, 1, 0, 14,      0, 0, 0, 0, 0 }, // 30
    { 256, 0, 10, 0, 0,     0, 0, 0, 0, 0,      256, 0, 20, 0, 0,      0, 0, 0, 0, 0 },
    { 256, 0, 10, 0, 0,     0, 0, 0, 0, 0,      256, 0, 20, 0, 0,      0, 0, 0, 0, 0 },
    { 257, 0, 50, 0, 0,     0, 0, 0, 0, 0,      257, 0, 100, 0, 0,      0, 0, 0, 0, 0 },
    { 258, 0, 1, 0, 0,     0, 0, 0, 0, 0,      258, 0, 2, 0, 0,      0, 0, 0, 0, 0 },
    { 254, 0, 1, 0, 0,     0, 0, 0, 0, 0,      1, 0, 1, 0, 15,      0, 0, 0, 0, 0 },        // 35
    { 259, 0, 5, 0, 0,     0, 0, 0, 0, 0,      259, 0, 10, 0, 0,      0, 0, 0, 0, 0 },
    { 260, 0, 10, 0, 0,     0, 0, 0, 0, 0,      260, 0, 20, 0, 0,      0, 0, 0, 0, 0 },
    { 244, 0, 1, 90, 0,     245, 0, 1, 90, 0,      246, 0, 1, 90, 0,      248, 0, 1, 90, 0 },
    { 246, 0, 1, 90, 0,     248, 0, 1, 90, 0,      248, 0, 1, 90, 0,      247, 0, 1, 90, 0 },
    { 1, 0, 1, 0, 17,     1, 0, 1, 0, 17,      1, 0, 1, 0, 17,      1, 0, 1, 0, 17 }, // 40
    { 256, 0, 10, 0, 0,     0, 0, 0, 0, 0,      256, 0, 20, 0, 0,      0, 0, 0, 0, 0 },
    { 256, 0, 10, 0, 0,     0, 0, 0, 0, 0,      256, 0, 20, 0, 0,      0, 0, 0, 0, 0 },
    { 257, 0, 50, 0, 0,     0, 0, 0, 0, 0,      257, 0, 100, 0, 0,      0, 0, 0, 0, 0 },
    { 258, 0, 1, 0, 0,     0, 0, 0, 0, 0,      258, 0, 2, 0, 0,      0, 0, 0, 0, 0 },
    { 12404, 2, 1, 0, 0,     0, 0, 0, 0, 0,      12418, 2, 1, 0, 0,      12419, 2, 1, 0, 0 }, // 45
    { 256, 0, 10, 0, 0,     0, 0, 0, 0, 0,      256, 0, 20, 0, 0,      0, 0, 0, 0, 0 },
    { 256, 0, 10, 0, 0,     0, 0, 0, 0, 0,      256, 0, 20, 0, 0,      0, 0, 0, 0, 0 },
    { 257, 0, 50, 0, 0,     0, 0, 0, 0, 0,      257, 0, 100, 0, 0,      0, 0, 0, 0, 0 },
    { 258, 0, 1, 0, 0,     0, 0, 0, 0, 0,      258, 0, 2, 0, 0,      0, 0, 0, 0, 0 },
    { 12461, 2, 1, 510, 0,     0, 0, 0, 0, 0,      2177, 5, 1, 0, 0,      0, 0, 0, 0, 0 } // 50
};

enum battlepassInfo
{
    bpLevel, // Лвл игрока
    bpExp, // Опыт игрока
    bpDonate, // Куплен ли премиум пропуск
    bool:bpTakeAwards[MAX_LEVEL_BATTLEPASS], // Статус награды за лвл
    bool:bpTakeAwardsDonate[MAX_LEVEL_BATTLEPASS], // Статус награды за лвл
    bpDay, // День для обновления ежедневных заданий
    bpWeekly, // Неделя для обновления ежедневных заданий
    bpTaskDaily[sizeof(BattlePassDailyTaskName)], // Ежедневные задания
    bool:bpTaskDailyComplete[sizeof(BattlePassDailyTaskName)], // Ежедневные задания
    bpTaskDailyQuan[sizeof(BattlePassDailyTaskName)], // Ежедневные задания подсчет
    bpTaskWeekly[MAX_WEEKLY_BATTLEPASS_TASK], // Еженедельные задания
    bool:bpTaskWeeklyComplete[MAX_WEEKLY_BATTLEPASS_TASK], // Ежедневные задания
    bpTaskWeeklyQuan[MAX_WEEKLY_BATTLEPASS_TASK], // Еженедельные задания подсчет
    bpTaskOneTime[sizeof(BattlePassOneTimeTaskName)], // Разовые задания за БП
    bool:bpTaskOneTimeComplete[sizeof(BattlePassOneTimeTaskName)], // Ежедневные задания
    bpTaskOneTimeQuan[sizeof(BattlePassOneTimeTaskName)], // Разовые задания за БП подсчет
    bpOneTimeLoad, // Загружены ли были разовые задания
    bpBuyLevel // Кол.во покупок лвла, для подсчета умножения
}
new BattlePass[MAX_REALPLAYERS][battlepassInfo];

#define MAX_LETTERS_IN_DIALOGBATTLEPASSMENU 50 // Букавки
stock dialogBattlePassMenu(playerid)
{
    new dailyquan, weeklyquan, onetimequan, dailymaxquan, weeklymaxquan, onetimemaxquan, awardsquan ,awardsquanmax, awardsdonatequan;
    ReceptionStatsBattlePass(playerid,dailyquan, weeklyquan, onetimequan, dailymaxquan, weeklymaxquan, onetimemaxquan, awardsquan ,awardsquanmax, awardsdonatequan);

    new tempText[4][MAX_LETTERS_IN_DIALOGBATTLEPASSMENU];
    format(tempText[0],MAX_LETTERS_IN_DIALOGBATTLEPASSMENU,"{ff6347}%d/%d",dailyquan,dailymaxquan);
    format(tempText[1],MAX_LETTERS_IN_DIALOGBATTLEPASSMENU,"{ff6347}%d/%d",weeklyquan,weeklymaxquan);
    format(tempText[2],MAX_LETTERS_IN_DIALOGBATTLEPASSMENU,"{ff6347}%d/%d",onetimequan,onetimemaxquan);
    format(tempText[3],MAX_LETTERS_IN_DIALOGBATTLEPASSMENU,"{ff6347}[ %d/%d ] {d7eb02}[ %d/%d ]",awardsquan,awardsquanmax,awardsdonatequan,awardsquanmax);

	new lines[500], string[60];
	format(lines,sizeof(lines),"{C8A2C8}Пропуск: %s\t "\
                                "\n{ff9000}Уровень {99ff66}%d \t{cccccc}Опыт [ {99ff66}%d{cccccc}/1000 ]"\
                                "\n{0088ff}Награды \t%s"\
								"\n{0088ff}Ежедневные задания \t%s"\
								"\n{0088ff}Еженедельные задания \t%s"\
                                "\n{0088ff}Разовые задания \t%s",
                                !BattlePass[playerid][bpDonate] ? "{cccccc}Обычный" : "{ffcc00}Премиум",
                                BattlePass[playerid][bpLevel],BattlePass[playerid][bpExp],
                                awardsquan == awardsquanmax && awardsdonatequan == awardsquanmax ? "{99ff66}Получено все" : tempText[3],
                                dailyquan == dailymaxquan ? "{99ff66}Выполнены" : tempText[0],
                                weeklyquan == weeklymaxquan ? "{99ff66}Выполнены" : tempText[1],
                                onetimequan == onetimemaxquan ? "{99ff66}Выполнены" : tempText[2]);
	format(string,sizeof(string),"{C8A2C8}Пропуск Зима 2024-2025");
	ShowDialog(playerid,BATTLEPASS_SHOW_MENU,DIALOG_STYLE_TABLIST_HEADERS, string, lines, "Принять", "Отмена");
	return true;
}

stock dialogBattlePassLevelMenu(playerid)
{
	new lines[500], string[100];
	format(lines,sizeof(lines),"{C8A2C8}Пропуск: %s\t "\
                                "\n{ff9000}Информация о пропуске\t "\
                                "\n{0088ff}Купить ЛВЛ пропуска за {66ff99}Вирты \t 1 lvl = {66ff99}%d$"\
								"\n{0088ff}Купить ЛВЛ пропуска за {ffcc00}Gold \t 1 lvl = {ffcc00}%d Gold",
                                !BattlePass[playerid][bpDonate] ? "{cccccc}Обычный" : "{ffcc00}Премиум",
                                !BattlePass[playerid][bpDonate] ? 1000000+1000000*BattlePass[playerid][bpBuyLevel] : (1000000+1000000*BattlePass[playerid][bpBuyLevel])/2,
                                !BattlePass[playerid][bpDonate] ? 100+100*BattlePass[playerid][bpBuyLevel] : (100+100*BattlePass[playerid][bpBuyLevel])/2);
	format(string,sizeof(string),"{C8A2C8}Пропуск Зима 2024-2025");
	ShowDialog(playerid,BATTLEPASS_SHOW_LEVELMENU,DIALOG_STYLE_TABLIST_HEADERS, string, lines, "Принять", "Отмена");
	return true;
}

stock dialogBattlePassLevelMenuInformation(playerid)
{
	new lines[3000], string[140];
	format(lines,sizeof(lines),"{C8A2C8}Пропуск: %s"\
                                "\n\n{ff9000}Что это за пропуск?"\
                                "\n{cccccc}- Это сезонное игровое событие, во время которого за выполнение заданий, можно получать опыт этого пропуска"\
                                "\n{cccccc}- За опыт повышается уровень пропуска, а уже за каждый уровень есть награды, которые может получить абсолютно любой игрок"\
                                "\n{cccccc}- Задания бывают 3 типов. Ежедневные - обновляются каждый день. Еженедельные - обновляются раз в неделю"\
                                "\n{cccccc}Разовые задания - не обновляются, и доступны 1 раз за сезон пропуска"\
                                "\n\n{ff9000}- Пропуск бывает 2 типов:"\
                                "\n{ffffff}Обычный {cccccc}- со стандартными наградами, доступен всем без вложений/доната"\
                                "\n{ffcc00}Премиум {cccccc}- с премиум наградами, покупка уровня в 2 раза дешевле, доступен к покупке на нашем сайте"\
                                "\n\n\n{ff9000}Вопрос-ответ по пропуску:"\
                                "\n{0088ff}Я не покупал пропуск, но собрал все награды, я смогу получить премиум награды если куплю пропуск?"\
                                "\n{cccccc}- Да, цифра перед наградой показывает статус сбора наград: {ff6347}Красным{cccccc}, если никакая награда не собрана, вообще"\
                                "\n{ffcc00}Желтым{cccccc} если собрана обычная награда, а премиум не была собрана и {99ff66}зеленым{cccccc} если собраны все награды"\
                                "\n{0088ff}Как мне заменить еженедельное задание?"\
                                "\n{cccccc}- Увы никак, у нас есть причины не вводить данную функцию, задания специально подбирались под невозможность замены"\
                                "\n{cccccc}Так же, мы хотим что бы игрок был ознакомлен со всеми системами, которые присутствуют в заданиях"\
                                "\n{0088ff}Я не успеваю получить 50 уровень, что мне делать?"\
                                "\n{cccccc}- Вы можете купить уровни за вирты или золото. С каждой покупкой уровня, его стоимость будет увеличиваться на %d$ или %d GOLD"\
                                "\n{0088ff}Какие награды идут после 50 уровня?"\
                                "\n{cccccc}- Каждый уровень вы будете получать по Новогоднему Кейсу, а каждый 5 уровень по одному Gold кейсу",
                                !BattlePass[playerid][bpDonate] ? "{cccccc}Обычный" : "{ffcc00}Премиум",
                                !BattlePass[playerid][bpDonate] ? 1000000 : 500000, !BattlePass[playerid][bpDonate] ? 100 : 50);
	format(string,sizeof(string),"{C8A2C8}Пропуск Зима 2024-2025");
	ShowDialog(playerid,BATTLEPASS_SHOW_LEVELMENU_INFO,DIALOG_STYLE_MSGBOX, string, lines, "*", "");
	return true;
}

stock dialogBattlePassListTask(playerid,type)
{
    new line[100],quan;
    ClearList(playerid);
    DP[0][playerid] = type;
    if(type == 0)
    {
        new lines[sizeof(BattlePassDailyTaskName)*100], TaskID;
        format(line,sizeof(line),"{C8A2C8}Ежедневные задания\tОпыт\tПрогресс\n"), strcat(lines,line);
        for(new i; i< sizeof(BattlePassDailyTaskName); i++)
        {
            TaskID = BattlePass[playerid][bpTaskDaily][i];

            format(line,sizeof(line),"{0088ff}%d. %s \t%d\t%s%d/%d\n",i+1, BattlePassDailyTaskName[TaskID],BattlePassDailyTaskSetting[TaskID][0],
            BattlePass[playerid][bpTaskDailyQuan][i] == BattlePassDailyTaskSetting[TaskID][1] ? "{99ff66}" : "{ff6347}",
            BattlePass[playerid][bpTaskDailyQuan][i],BattlePassDailyTaskSetting[TaskID][1]), strcat(lines,line);

            List[quan][playerid] = i;
            quan++;
        }
        ShowDialog(playerid,BATTLEPASS_SHOW_MENU_TASKS,DIALOG_STYLE_TABLIST_HEADERS,"{C8A2C8}Пропуск Зима 2024-2025",lines,"Выбор","Отмена");
    }
    else if(type == 1)
    {
        new lines[MAX_WEEKLY_BATTLEPASS_TASK*100], TaskID;
        new tyear, tmonth, tday, thour, tminute, tsecond;
        stamp2datetime(BattlePass[playerid][bpWeekly], tyear, tmonth, tday, thour, tminute, tsecond, 3);
        format(line,sizeof(line),"{C8A2C8}Обновление заданий в %d:%d %d.%d \tОпыт\tПрогресс\n",thour,tminute,tday,tmonth), strcat(lines,line);
        for(new i; i < MAX_WEEKLY_BATTLEPASS_TASK; i++)
        {
            TaskID = BattlePass[playerid][bpTaskWeekly][i];

            format(line,sizeof(line),"{0088ff}%d. %s \t%d\t%s%d/%d\n",i+1, BattlePassWeeklyTaskName[TaskID],BattlePassWeeklyTaskSetting[TaskID][0],
            BattlePass[playerid][bpTaskWeeklyQuan][i] == BattlePassWeeklyTaskSetting[TaskID][1] ? "{99ff66}" : "{ff6347}",
            BattlePass[playerid][bpTaskWeeklyQuan][i],BattlePassWeeklyTaskSetting[TaskID][1]), strcat(lines,line);

            List[quan][playerid] = i;
            quan++;
        }
        ShowDialog(playerid,BATTLEPASS_SHOW_MENU_TASKS,DIALOG_STYLE_TABLIST_HEADERS,"{C8A2C8}Пропуск Зима 2024-2025",lines,"Выбор","Отмена");
    }
    else if(type == 2)
    {
        new lines[sizeof(BattlePassOneTimeTaskName)*100], TaskID;
        format(line,sizeof(line),"{C8A2C8}Разовые задания\tОпыт\tПрогресс\n"), strcat(lines,line);
        for(new i; i < sizeof(BattlePassOneTimeTaskName); i++)
        {
            TaskID = BattlePass[playerid][bpTaskOneTime][i];

            format(line,sizeof(line),"{0088ff}%d. %s \t%d\t%s%d/%d\n",i+1, BattlePassOneTimeTaskName[TaskID],BattlePassOneTimeTaskSetting[TaskID][0],
            BattlePass[playerid][bpTaskOneTimeQuan][i] == BattlePassOneTimeTaskSetting[TaskID][1] ? "{99ff66}" : "{ff6347}",
            BattlePass[playerid][bpTaskOneTimeQuan][i],BattlePassOneTimeTaskSetting[TaskID][1]), strcat(lines,line);

            List[quan][playerid] = i;
            quan++;
        }
        ShowDialog(playerid,BATTLEPASS_SHOW_MENU_TASKS,DIALOG_STYLE_TABLIST_HEADERS,"{C8A2C8}Пропуск Зима 2024-2025",lines,"Выбор","Отмена");
    }
    return 1;
}

stock ReceptionStatsBattlePass(playerid, &dailyquan, &weeklyquan, &onetimequan, &dailymaxquan, &weeklymaxquan, &onetimemaxquan, &awardsquan , &awardsquanmax, &awardsdonatequan) // Делаем расчет кол-ва выполненных заданий
{
    for(new i; i < sizeof(BattlePassDailyTaskName); i++) // Ежедневные
    {
        dailymaxquan++;
        if(BattlePass[playerid][bpTaskDailyQuan][i] == BattlePassDailyTaskSetting[BattlePass[playerid][bpTaskDaily][i]][1]) dailyquan++;
    }
    for(new i; i < MAX_WEEKLY_BATTLEPASS_TASK; i++) // Еженедельные
    {
        weeklymaxquan++;
        if(BattlePass[playerid][bpTaskWeeklyQuan][i] == BattlePassWeeklyTaskSetting[BattlePass[playerid][bpTaskWeekly][i]][1]) weeklyquan++;
    }
    for(new i; i < sizeof(BattlePassOneTimeTaskName); i++) // Разовые
    {
        onetimemaxquan++;
        if(BattlePass[playerid][bpTaskOneTimeQuan][i] == BattlePassOneTimeTaskSetting[BattlePass[playerid][bpTaskOneTime][i]][1]) onetimequan++;
    }
    for(new i; i < MAX_LEVEL_BATTLEPASS; i++) // Награды
    {
        awardsquanmax++;
        if(BattlePass[playerid][bpTakeAwards][i]) awardsquan++;
        if(BattlePass[playerid][bpTakeAwardsDonate][i]) awardsdonatequan++;
    }
    return true;
}

CMD:battlepass(playerid)
{
    if(!OnlineInfo[playerid][oBattlePassLoad]) return ErrorMessage(playerid,"{ff6347}Попробуйте чуть позже, пропуск не успел загрузится");
    dialogBattlePassMenu(playerid);
    return true;
}

CMD:givebattlepass(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать премиум пропуск игроку [ /givebattlepass ID ]");
	if(!IsOnline(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Его вообще нет..");
    if(BattlePass[params[0]][bpDonate] == 0) 
    {
        GivePlayerBattlePass(params[0]);
        AdminLog("givebattlepass", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[params[0]][pID], PlayerInfo[params[0]][pName], PlayerInfo[params[0]][pPlaIP], 1, "Выдал премиум пропуск");
    }
    else ErrorMessage(playerid,"{ff6347}У игрока уже есть премиум пропуск");
    return true;
}

stock GivePlayerBattlePass(playerid)
{
    new string_mysql[200];
    BattlePass[playerid][bpDonate] = 1;

    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `battlepass` SET `bpDonate` = '1' WHERE `user_id` = '%d'", PlayerInfo[playerid][pID]);
	mysql_tquery(pearsq, string_mysql);
    return true;
}

CMD:resetbattlepass(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Установить номер бизнеса игроку [ /resetbattlepass ID Номер ]");
	if(!IsOnline(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Его вообще нет..");
    BattlePass[params[0]][bpDay] = 0;
    BattlePass[params[0]][bpWeekly] = 0;
    BattlePass[params[0]][bpOneTimeLoad] = 0;
    CreateAllTasksBattlePassForPlayer(params[0]);
    SuccessMessage(playerid,"{44ff99}Игроку очищенны задания");
    return 1;
}

stock dialogCase_BattlePass(playerid, dialogid, response, listitem) {
    switch (e_DialogId: dialogid) {
        case BATTLEPASS_SHOW_MENU: {
            if (!response) return false;
            else
            {
                if(listitem == 0) dialogBattlePassLevelMenu(playerid);
                if(listitem == 1) dialogBattlePassListAwards(playerid);
                if(listitem > 1) return dialogBattlePassListTask(playerid, listitem - 2);
            }
        }
        case BATTLEPASS_SHOW_MENU_TASKS: {
            if (!response) return dialogBattlePassMenu(playerid);
            else
            {
                if(DP[0][playerid] != 1) return dialogBattlePassListTask(playerid,DP[0][playerid]);
                new TaskID = List[listitem][playerid];
                new line[214],lines[4096];
                format(line,sizeof(line),"{cccccc}Задание: {ff9000}%s", BattlePassWeeklyTaskName[BattlePass[playerid][bpTaskWeekly][TaskID]]), strcat(lines,line);
                format(line,sizeof(line),"\n\n{cccccc}%s", BattlePassWeeklyTaskDescription[BattlePass[playerid][bpTaskWeekly][TaskID]]), strcat(lines,line);
                ShowDialog(playerid,BATTLEPASS_SHOW_MENU_TASKINFO,DIALOG_STYLE_MSGBOX,"{C8A2C8}Пропуск Зима 2024-2025",lines,"Ок","");
            }
        }
        case BATTLEPASS_SHOW_MENU_TASKINFO:{
            dialogBattlePassListTask(playerid,DP[0][playerid]);
        }
        case BATTLEPASS_SHOW_MENU_AWARDS: {
            if(!response) return dialogBattlePassMenu(playerid);
            else{
                GiveAwardsBattlePassLevel(playerid,listitem);
            }
        }
        case BATTLEPASS_SHOW_LEVELMENU: {
            if(!response) return dialogBattlePassMenu(playerid);
            else
            {
                if(listitem == 0) dialogBattlePassLevelMenuInformation(playerid);
                if(listitem == 2)
                {
                    new gold = 100+100*BattlePass[playerid][bpBuyLevel];
                    if(BattlePass[playerid][bpDonate]) gold /= 2;
                    if(PlayerInfo[playerid][pDonateMoney] < gold) return ErrorMessage(playerid, "{FF6347}У вас недостаточно Gold [ Y >> Donate ]");
                    PlayerInfo[playerid][pDonateMoney] -= gold;
                    tclArifmetikAllGold -= gold;
                    mysql_save(playerid,4);
                    BattlePass[playerid][bpBuyLevel]++;
                    GiveExpBattlePass(playerid,1000);

                    new string[50];
                    format(string, sizeof(string),"Купил уровень пропуска за голду [%d покупка]", BattlePass[playerid][bpBuyLevel]);
 	                DonateLog("buylevelbp", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -gold, string);

                    SuccessMessage(playerid,"{44ff99}Я купил уровень пропуска за золото!");
                }
                if(listitem == 1)
                {
                    new money = 1000000+1000000*BattlePass[playerid][bpBuyLevel];
                    if(BattlePass[playerid][bpDonate]) money /= 2;
                    if(oGetPlayerMoney(playerid) < money) return ErrorMessage(playerid, "{FF6347}У вас недостаточно Денег на руках");
                    oGivePlayerMoney(playerid, -money);
                    BattlePass[playerid][bpBuyLevel]++;
                    GiveExpBattlePass(playerid,1000);
                    
                    new string[50];
                    format(string, sizeof(string),"Купил уровень пропуска за вирты [%d покупка]", BattlePass[playerid][bpBuyLevel]);
 	                MoneyLog("buylevelbp", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -money, string);

                    SuccessMessage(playerid,"{44ff99}Я купил уровень пропуска за вирты!");
                }
            }
        }
        case BATTLEPASS_SHOW_LEVELMENU_INFO:{
            dialogBattlePassLevelMenu(playerid);
        }
    }

    return true;
}


stock GetUniqueTaskWeeklyBattlePassForPlayer(playerid) 
{
    new taskweeklyquan = sizeof(BattlePassWeeklyTaskName);
    for (new i = 0; i < taskweeklyquan; i++) {

        new TaskID = random(taskweeklyquan);
        new bool: isUnique = true;

        for (new j = 0; j < MAX_WEEKLY_BATTLEPASS_TASK; j++) {
            if (BattlePass[playerid][bpTaskWeekly][j] == TaskID) {
                isUnique = false;
                break;
            }
        }


        if (!isUnique) continue;
        
        return TaskID;
    }
    return false;
}

stock CreateAllTasksBattlePassForPlayer(playerid)
{
    if(BattlePass[playerid][bpDay] != getdate())
    {
        for(new i; i < sizeof(BattlePassDailyTaskName); i++) // Ежедневные
        {
            BattlePass[playerid][bpTaskDaily][i] = i;
            BattlePass[playerid][bpTaskDailyQuan][i] = 0;
            BattlePass[playerid][bpTaskDailyComplete][i] = false;
        }
        BattlePass[playerid][bpDay] = getdate();
    }
    if(BattlePass[playerid][bpWeekly] < gettime())
    {
        for(new i; i < MAX_WEEKLY_BATTLEPASS_TASK; i++) // Еженедельные
        {
            BattlePass[playerid][bpTaskWeekly][i] = GetUniqueTaskWeeklyBattlePassForPlayer(playerid);
            BattlePass[playerid][bpTaskWeeklyQuan][i] = 0;
            BattlePass[playerid][bpTaskWeeklyComplete][i] = false;
        }
        BattlePass[playerid][bpWeekly] = gettime()+604800;
    }
    if(!BattlePass[playerid][bpOneTimeLoad])
    {
        for(new i; i < sizeof(BattlePassOneTimeTaskName); i++) // Разовые
        {
            BattlePass[playerid][bpTaskOneTime][i] = i;
            BattlePass[playerid][bpTaskOneTimeQuan][i] = 0;
            BattlePass[playerid][bpTaskOneTimeComplete][i] = false;
        }
        BattlePass[playerid][bpOneTimeLoad] = 1;
    }
    OnlineInfo[playerid][oBattlePassLoad] = 1;
    return true;
}

stock dialogBattlePassListAwards(playerid)
{
    new line[250];
    new lines[MAX_LEVEL_BATTLEPASS*250];
    format(line,sizeof(line),"{cccccc}Обычный пропуск \t \t{ffcc00}Премиум пропуск\t "), strcat(lines,line);
    new tempText[5][MAX_LETTERS_IN_DIALOGBATTLEPASSMENU];
    for(new i; i< MAX_LEVEL_BATTLEPASS; i++)
    {
        format(tempText[0],MAX_LETTERS_IN_DIALOGBATTLEPASSMENU,"[ %d шт. ]",BattlePassAwarsdItem[i][2]);
        format(tempText[1],MAX_LETTERS_IN_DIALOGBATTLEPASSMENU,"[ %d шт. ]",BattlePassAwarsdItem[i][7]);
        format(tempText[2],MAX_LETTERS_IN_DIALOGBATTLEPASSMENU,"[ %d шт. ]",BattlePassAwarsdItem[i][12]);
        format(tempText[3],MAX_LETTERS_IN_DIALOGBATTLEPASSMENU,"[ %d шт. ]",BattlePassAwarsdItem[i][17]);
        if(BattlePass[playerid][bpTakeAwards][i] && BattlePass[playerid][bpTakeAwardsDonate][i]) format(tempText[4],MAX_LETTERS_IN_DIALOGBATTLEPASSMENU,"{99ff66}");
        else if(BattlePass[playerid][bpTakeAwards][i] && !BattlePass[playerid][bpTakeAwardsDonate][i]) format(tempText[4],MAX_LETTERS_IN_DIALOGBATTLEPASSMENU,"{ffcc00}");
        else if(!BattlePass[playerid][bpTakeAwards][i] && !BattlePass[playerid][bpTakeAwardsDonate][i]) format(tempText[4],MAX_LETTERS_IN_DIALOGBATTLEPASSMENU,"{ff6347}");
        format(line,sizeof(line),"\n%s%d.{ffffff} %s %s \t%s %s\t%s %s\t%s %s",tempText[4],i+1,
        GetNameThing(0, BattlePassAwarsdItem[i][0], BattlePassAwarsdItem[i][1], BattlePassAwarsdItem[i][4]),
        BattlePassAwarsdItem[i][2] != 0 ? tempText[0] : " ",
        GetNameThing(0, BattlePassAwarsdItem[i][5], BattlePassAwarsdItem[i][6], BattlePassAwarsdItem[i][9]),
        BattlePassAwarsdItem[i][7] != 0 ? tempText[1] : " ",
        GetNameThing(0, BattlePassAwarsdItem[i][10], BattlePassAwarsdItem[i][11], BattlePassAwarsdItem[i][14]),
        BattlePassAwarsdItem[i][12] != 0 ? tempText[2] : " ",
        GetNameThing(0, BattlePassAwarsdItem[i][15], BattlePassAwarsdItem[i][16], BattlePassAwarsdItem[i][19]),
        BattlePassAwarsdItem[i][17] != 0 ? tempText[3] : " "), strcat(lines,line);
    }
    ShowDialog(playerid,BATTLEPASS_SHOW_MENU_AWARDS,DIALOG_STYLE_TABLIST_HEADERS,"{C8A2C8}Пропуск Зима 2024-2025",lines,"Выбор","Отмена");
    return 1;
}

stock CompleteBattlePassTask(playerid, TaskID, TaskType, TaskPara = 0)
{
    new string[110];
    if(TaskType == 0)
    {
        for(new i; i < sizeof(BattlePassDailyTaskName); i++) // Ежедневные
        {
            if(BattlePass[playerid][bpTaskDaily][i] == TaskID && !BattlePass[playerid][bpTaskDailyComplete][i])
            {
                if(TaskPara == 0) BattlePass[playerid][bpTaskDailyQuan][i]++;
                else
                {
                    if(BattlePass[playerid][bpTaskDailyQuan][i]+TaskPara > BattlePassDailyTaskSetting[BattlePass[playerid][bpTaskDaily][i]][1]
                     && BattlePass[playerid][bpTaskDailyQuan][i] < BattlePassDailyTaskSetting[BattlePass[playerid][bpTaskDaily][i]][1]) BattlePass[playerid][bpTaskDailyQuan][i] = BattlePassDailyTaskSetting[BattlePass[playerid][bpTaskDaily][i]][1];
                    else BattlePass[playerid][bpTaskDailyQuan][i]+=TaskPara;
                }
                if(BattlePass[playerid][bpTaskDailyQuan][i] == BattlePassDailyTaskSetting[BattlePass[playerid][bpTaskDaily][i]][1])
                {
                    format(string, sizeof(string), "{0088ff}Вы выполнили ежедневное задание {ffcc66}Пропуска {0088ff}и получили {99ff66}%d {0088ff}опыта", BattlePassDailyTaskSetting[BattlePass[playerid][bpTaskDaily][i]][0]);
                    SendClientMessage(playerid, COLOR_GREY, string);
                    BattlePass[playerid][bpTaskDailyComplete][i] = true;
                    GiveExpBattlePass(playerid,BattlePassDailyTaskSetting[BattlePass[playerid][bpTaskDaily][i]][0]);
                    SaveSlotBattlePassTask(playerid,i,TaskType);
                }
                break;
            }
        }
    }
    else if(TaskType == 1)
    {
        for(new i; i < MAX_WEEKLY_BATTLEPASS_TASK; i++) // Еженедельные
        {
            if(BattlePass[playerid][bpTaskWeekly][i] == TaskID && !BattlePass[playerid][bpTaskWeeklyComplete][i])
            {
                if(TaskPara == 0) BattlePass[playerid][bpTaskWeeklyQuan][i]++;
                else
                {
                    if(BattlePass[playerid][bpTaskWeeklyQuan][i]+TaskPara > BattlePassWeeklyTaskSetting[BattlePass[playerid][bpTaskWeekly][i]][1]
                     && BattlePass[playerid][bpTaskWeeklyQuan][i] < BattlePassWeeklyTaskSetting[BattlePass[playerid][bpTaskWeekly][i]][1]) BattlePass[playerid][bpTaskWeeklyQuan][i] = BattlePassWeeklyTaskSetting[BattlePass[playerid][bpTaskWeekly][i]][1];
                    else BattlePass[playerid][bpTaskWeeklyQuan][i]+=TaskPara;
                }
                if(BattlePass[playerid][bpTaskWeeklyQuan][i] == BattlePassWeeklyTaskSetting[BattlePass[playerid][bpTaskWeekly][i]][1])
                {
                    format(string, sizeof(string), "{0088ff}Вы выполнили еженедельное задание {ffcc66}Пропуска {0088ff}и получили {99ff66}%d {0088ff}опыта", BattlePassWeeklyTaskSetting[BattlePass[playerid][bpTaskWeekly][i]][0]);
                    SendClientMessage(playerid, COLOR_GREY, string);
                    BattlePass[playerid][bpTaskWeeklyComplete][i] = true;
                    GiveExpBattlePass(playerid,BattlePassWeeklyTaskSetting[BattlePass[playerid][bpTaskWeekly][i]][0]);
                    SaveSlotBattlePassTask(playerid,i,TaskType);
                }
                break;
            }
        }
    }
    else if(TaskType == 2)
    {
        for(new i; i < sizeof(BattlePassOneTimeTaskName); i++) // Разовые
        {
            if(BattlePass[playerid][bpTaskOneTime][i] == TaskID && !BattlePass[playerid][bpTaskOneTimeComplete][i])
            {
                if(TaskPara == 0) BattlePass[playerid][bpTaskOneTimeQuan][i]++;
                else
                {
                    if(BattlePass[playerid][bpTaskOneTimeQuan][i]+TaskPara > BattlePassOneTimeTaskSetting[BattlePass[playerid][bpTaskOneTime][i]][1]
                     && BattlePass[playerid][bpTaskOneTimeQuan][i] < BattlePassOneTimeTaskSetting[BattlePass[playerid][bpTaskOneTime][i]][1]) BattlePass[playerid][bpTaskOneTimeQuan][i] = BattlePassOneTimeTaskSetting[BattlePass[playerid][bpTaskOneTime][i]][1];
                    else BattlePass[playerid][bpTaskOneTimeQuan][i]+=TaskPara;
                }
                if(BattlePass[playerid][bpTaskOneTimeQuan][i] == BattlePassOneTimeTaskSetting[BattlePass[playerid][bpTaskOneTime][i]][1])
                {
                    format(string, sizeof(string), "{0088ff}Вы выполнили разовое задание {ffcc66}Пропуска {0088ff}и получили {99ff66}%d {0088ff}опыта", BattlePassOneTimeTaskSetting[BattlePass[playerid][bpTaskOneTime][i]][0]);
                    SendClientMessage(playerid, COLOR_GREY, string);
                    BattlePass[playerid][bpTaskOneTimeComplete][i] = true;
                    GiveExpBattlePass(playerid,BattlePassOneTimeTaskSetting[BattlePass[playerid][bpTaskOneTime][i]][0]);
                    SaveSlotBattlePassTask(playerid,i,TaskType);
                }
                break;
            }
        }
    }
    return 1;
}

stock GiveAwardsBattlePassLevel(playerid, AwardsID)
{
    if(BattlePass[playerid][bpLevel] < AwardsID+1) return ErrorMessage(playerid,"{ff6347}Ваш уровень пропуска ниже уровня награды!");
    if(BattlePass[playerid][bpTakeAwards][AwardsID] && BattlePass[playerid][bpTakeAwardsDonate][AwardsID]) return ErrorMessage(playerid,"{ff6347}Вы уже получили награду за этот уровень!");
    if(BattlePass[playerid][bpTakeAwards][AwardsID] && !BattlePass[playerid][bpTakeAwardsDonate][AwardsID] && !BattlePass[playerid][bpDonate]) return ErrorMessage(playerid,"{ff6347}Для получения премиум награды нужно купить пропуск [ /donate ]");

    new bool:yesAwards[4], bool:noGiveAwards[4], bool:yesDropAwards, bool:nohavePremium;
    new getQuan, getLimit;
    for(new i; i < 4; i++)
    {
        if(BattlePass[playerid][bpTakeAwards][AwardsID] && (i == 0 || i == 1)) continue;
        if(BattlePass[playerid][bpTakeAwardsDonate][AwardsID] && (i == 2 || i == 3)) continue;
        if(!BattlePass[playerid][bpDonate] && (i == 2 || i == 3)) 
        {
            nohavePremium = true;
            break;
        }
        if(i == 1) BattlePass[playerid][bpTakeAwards][AwardsID] = true;
        if(i == 3) BattlePass[playerid][bpTakeAwardsDonate][AwardsID] = true;

        if(BattlePassAwarsdItem[AwardsID][2+i*5] > 0) yesAwards[i] = true;
        if(!yesAwards[i]) continue;
        if(CheckThingQuan(BattlePassAwarsdItem[AwardsID][0+i*5]))
        {
            getQuan = 0, getLimit = 0;
            i_limit(playerid, BattlePassAwarsdItem[AwardsID][0+i*5], getQuan, getLimit);
            if(getQuan+BattlePassAwarsdItem[AwardsID][2+i*5] > getLimit) noGiveAwards[i] = true;
        }

        if(noGiveAwards[i])
        {
            Throw(playerid, BattlePassAwarsdItem[AwardsID][0+i*5], BattlePassAwarsdItem[AwardsID][2+i*5], BattlePassAwarsdItem[AwardsID][3+i*5], 0, BattlePassAwarsdItem[AwardsID][1+i*5], BattlePassAwarsdItem[AwardsID][4+i*5]);
            yesDropAwards = true;
        }
        else
        {
            if(IsACasePackID(BattlePassAwarsdItem[AwardsID][4+i*5]))
            {
                new thingIdCase, thingQuan, thingType, thingPara, thingPack, casename[30];
                if(BattlePassAwarsdItem[AwardsID][4+i*5] != 5) format(casename, sizeof(casename),"%s", customCaseNameID[GetInventoryPackCustomCase(BattlePassAwarsdItem[AwardsID][4+i*5])]);
                CreateCasePlayer(playerid, thingIdCase, thingQuan, thingType,thingPara, thingPack, casename);

                new put_inva = GiveThingPlayer(playerid, thingIdCase, thingQuan, thingPara, 0, thingType, thingPack, 9999);
                if(put_inva == -1) Throw(playerid, thingIdCase, thingQuan, thingPara, 0, thingType, thingPack), yesDropAwards = true;
            }
            else
            {
                new put_inva = GiveThingPlayer(playerid, BattlePassAwarsdItem[AwardsID][0+i*5], BattlePassAwarsdItem[AwardsID][2+i*5], BattlePassAwarsdItem[AwardsID][3+i*5], 0, BattlePassAwarsdItem[AwardsID][1+i*5], BattlePassAwarsdItem[AwardsID][4+i*5], 9999); // Выдаём предмет игроку
                if(put_inva == -1) Throw(playerid, BattlePassAwarsdItem[AwardsID][0+i*5], BattlePassAwarsdItem[AwardsID][2+i*5], BattlePassAwarsdItem[AwardsID][3+i*5], 0, BattlePassAwarsdItem[AwardsID][1+i*5], BattlePassAwarsdItem[AwardsID][4+i*5]), yesDropAwards = true;
            }
        }
    }

    if(nohavePremium) ErrorMessage(playerid,"{ff6347}Я получил обычные награды пропуска.\nДля получения премиум награды нужно купить пропуск [ /donate ]");

    if(yesDropAwards) 
    {
        ErrorMessage(playerid, "{FF6347}В инвентаре не хватило места или был привышен лимит. Ваша награда была выброшена на землю");
        SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Черт! У меня нет места в карманах, предметы лежат на земле!");
    }
    else SuccessMessage(playerid,"{44ff99}Вы успешно получили награду пропуска. Проверьте инвентарь!");

    SaveSlotBattlePassAward(playerid,AwardsID);

    return 1;
}

stock GiveExpBattlePass(playerid, exp)
{
    if(BattlePass[playerid][bpExp]+exp >= 1000)
    {
        BattlePass[playerid][bpLevel] += (BattlePass[playerid][bpExp]+exp) / 1000;
        BattlePass[playerid][bpExp] = (BattlePass[playerid][bpExp]+exp) % 1000;
        SendClientMessage(playerid,COLOR_GREY,"{0088ff}Мой уровень {ffcc66}Пропуска {0088ff}был повышем и я могу получить награду{cccccc}[ Y > Пропуск > Награды]");

        if(BattlePass[playerid][bpLevel] > 50)
        {
            new thingIdCase, thingQuan, thingType, thingPara, thingPack, casename[30];
            if(BattlePass[playerid][bpLevel] % 5 == 0) thingPack = 9;
            else thingPack = 17;
            format(casename, sizeof(casename),"%s", customCaseNameID[GetInventoryPackCustomCase(thingPack)]);
            CreateCasePlayer(playerid, thingIdCase, thingQuan, thingType,thingPara, thingPack, casename);

            new put_inva = GiveThingPlayer(playerid, thingIdCase, thingQuan, thingPara, 0, thingType, thingPack, 9999);
            if(put_inva == -1)
            {   
                Throw(playerid, thingIdCase, thingQuan, thingPara, 0, thingType, thingPack);
                SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Черт! У меня нет места в карманах, предметы лежат на земле!");
            }
        }
    }
    else BattlePass[playerid][bpExp] += exp;

    SaveLevelBattlePass(playerid);
    return true;
}

stock SaveLevelBattlePass(playerid)
{
    new string_mysql[200];
    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `battlepass` SET `bpDonate`= '%d',`bpLevel`= '%d',`bpExp`= '%d',`bpBuyLevel`= '%d',`Name`='%e' WHERE `user_id` = '%d'",BattlePass[playerid][bpDonate], BattlePass[playerid][bpLevel],BattlePass[playerid][bpExp],BattlePass[playerid][bpBuyLevel],PlayerInfo[playerid][pName], PlayerInfo[playerid][pID]);
    mysql_tquery(pearsq, string_mysql);
    return true;
}

stock SaveSlotBattlePassTask(playerid, i,type)
{
	new JsonNode:node;
	CreateJsonBattlePassTask(playerid, i,type, node);
	SaveSlotBattlePassTaskByUserID(playerid, i,type, node);
	return 1;
}

stock SaveSlotBattlePassAward(playerid, i)
{
	new JsonNode:node;
	CreateJsonBattlePassAwards(playerid, i, node);
	SaveSlotBattlePassAwardByUserID(playerid, i, node);
	return 1;
}

stock CreateJsonBattlePassAwards(playerid, i, &JsonNode:node)
{
	node = JSON_Object(
		"bpTakeAwards", JSON_Bool(BattlePass[playerid][bpTakeAwards][i]),
		"bpTakeAwardsDonate", JSON_Bool(BattlePass[playerid][bpTakeAwardsDonate][i])
	);

	return 1;
}

stock CreateJsonBattlePassTask(playerid, i,type, &JsonNode:node)
{
    if(type == 0)
    {
        node = JSON_Object(
            "id", JSON_Int(BattlePass[playerid][bpTaskDaily][i]),
            "quan", JSON_Int(BattlePass[playerid][bpTaskDailyQuan][i]),
            "complete", JSON_Bool(BattlePass[playerid][bpTaskDailyComplete][i])
        );
    }
    else if(type == 1)
    {
        node = JSON_Object(
            "id", JSON_Int(BattlePass[playerid][bpTaskWeekly][i]),
            "quan", JSON_Int(BattlePass[playerid][bpTaskWeeklyQuan][i]),
            "complete", JSON_Bool(BattlePass[playerid][bpTaskWeeklyComplete][i])
        );
    }
    else if(type == 2)
    {
        node = JSON_Object(
            "id", JSON_Int(BattlePass[playerid][bpTaskOneTime][i]),
            "quan", JSON_Int(BattlePass[playerid][bpTaskOneTimeQuan][i]),
            "complete", JSON_Bool(BattlePass[playerid][bpTaskOneTimeComplete][i])
        );
    }
	return 1;
}

stock SaveSlotBattlePassTaskByUserID(playerid, i,type, JsonNode:node)
{
    new string[20];
    if(type == 0) format(string,sizeof(string),"bpTaskDaily_%d", i);
    else if(type == 1) format(string,sizeof(string),"bpTaskWeekly_%d", i);
    else if(type == 2) format(string,sizeof(string),"bpTaskOneTime_%d", i);
	if(node == JSON_INVALID_NODE)
	{
		new string_mysql[200];
		mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `battlepass` SET `bpDonate`= '%d',`bpLevel`= '%d',`bpExp`= '%d',`%e`= NULL WHERE `user_id` = '%d'",BattlePass[playerid][bpDonate], BattlePass[playerid][bpLevel],BattlePass[playerid][bpExp],string, PlayerInfo[playerid][pID]);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `battlepass` SET `bpDonate`= '%d',`bpLevel`= '%d',`bpExp`= '%d',`%e`= '%e' WHERE `user_id` = '%d'",
			BattlePass[playerid][bpDonate],BattlePass[playerid][bpLevel],BattlePass[playerid][bpExp], string,string_json,PlayerInfo[playerid][pID]);
			mysql_tquery(pearsq, string_mysql);
		}
	}
	return 1;
}

stock SaveSlotBattlePassAwardByUserID(playerid, i, JsonNode:node)
{
    new string[20];
    format(string,sizeof(string),"bpAwards_%d", i);
	if(node == JSON_INVALID_NODE)
	{
		new string_mysql[200];
		mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `battlepass` SET `bpDonate`= '%d',`bpLevel`= '%d',`bpExp`= '%d', `%e`= NULL WHERE `user_id` = '%d'",BattlePass[playerid][bpDonate], BattlePass[playerid][bpLevel],BattlePass[playerid][bpExp],string, PlayerInfo[playerid][pID]);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `battlepass` SET `bpDonate`= '%d',`bpLevel`= '%d',`bpExp`= '%d',`%e`= '%e' WHERE `user_id` = '%d'",
			BattlePass[playerid][bpDonate],BattlePass[playerid][bpLevel],BattlePass[playerid][bpExp], string,string_json,PlayerInfo[playerid][pID]);
			mysql_tquery(pearsq, string_mysql);
		}
	}
	return 1;
}

function OnPlayerBattlePassFirstLoad(playerid, race_check)
{
    new string_mysql[140];
    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT * FROM `battlepass` WHERE `user_id` = '%d'", PlayerInfo[playerid][pID]);
    mysql_tquery(pearsq, string_mysql, "OnPlayerBattlePassLoad", "dd",playerid, g_MysqlRaceCheck[playerid]);
    return 1;
}

function OnPlayerBattlePassLoad(playerid, race_check)
{
	new rows;
	cache_get_row_count(rows);

	if(rows)
	{
	    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);
		OnPlayerLoadBattlePass(playerid);
		printf("OnPlayerBattlePassLoad(%s) Пропуск Найден", PlayerInfo[playerid][pName]);
	}
    else 
    {
        new string_mysql[140];
        mysql_format(pearsq, string_mysql, sizeof(string_mysql), "INSERT INTO `battlepass` SET `user_id` = '%d'",PlayerInfo[playerid][pID]);
        mysql_tquery(pearsq, string_mysql, "OnPlayerBattlePassFirstLoad", "dd",playerid, g_MysqlRaceCheck[playerid]);
    }
	return 1;
}

stock OnPlayerLoadBattlePass(playerid)
{
	new string[20];
    cache_get_value_name_int(0,"bpDonate",BattlePass[playerid][bpDonate]);
	cache_get_value_name_int(0,"bpLevel",BattlePass[playerid][bpLevel]);
    cache_get_value_name_int(0,"bpExp",BattlePass[playerid][bpExp]);
    cache_get_value_name_int(0,"bpDay",BattlePass[playerid][bpDay]);
    cache_get_value_name_int(0,"bpWeekly",BattlePass[playerid][bpWeekly]);
    cache_get_value_name_int(0,"bpOneTimeLoad",BattlePass[playerid][bpOneTimeLoad]);
    cache_get_value_name_int(0,"bpBuyLevel",BattlePass[playerid][bpBuyLevel]);
    for(new i; i < MAX_LEVEL_BATTLEPASS; i++)
    {
        new bool:is_null;
        format(string, sizeof(string), "bpAwards_%d", i);
        cache_is_value_name_null(0, string, is_null);

        if(is_null == false)
        {
            new string_json[1024];
            cache_get_value_name(0, string, string_json, 1024);

            new JsonNode:node = JSON_INVALID_NODE;
            if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
            {
                JSON_GetBool(node, "bpTakeAwards", BattlePass[playerid][bpTakeAwards][i]);
                JSON_GetBool(node, "bpTakeAwardsDonate", BattlePass[playerid][bpTakeAwardsDonate][i]);
            }
        } 
    }
    for(new i; i < sizeof(BattlePassDailyTaskName); i++) // Ежедневные
    {
        new bool:is_null;
        format(string, sizeof(string), "bpTaskDaily_%d", i);
        cache_is_value_name_null(0, string, is_null);

        if(is_null == false)
        {
            new string_json[512];
            cache_get_value_name(0, string, string_json, 512);

            new JsonNode:node = JSON_INVALID_NODE;
            if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
            {
                JSON_GetInt(node, "id", BattlePass[playerid][bpTaskDaily][i]);
                JSON_GetInt(node, "quan", BattlePass[playerid][bpTaskDailyQuan][i]);
                JSON_GetBool(node, "complete", BattlePass[playerid][bpTaskDailyComplete][i]);
            }
        }
    }

    for(new i; i < MAX_WEEKLY_BATTLEPASS_TASK; i++) // Еженедельные
    {
        new bool:is_null;
        format(string, sizeof(string), "bpTaskWeekly_%d", i);
        cache_is_value_name_null(0, string, is_null);

        if(is_null == false)
        {
            new string_json[512];
            cache_get_value_name(0, string, string_json, 512);

            new JsonNode:node = JSON_INVALID_NODE;
            if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
            {
                JSON_GetInt(node, "id", BattlePass[playerid][bpTaskWeekly][i]);
                JSON_GetInt(node, "quan", BattlePass[playerid][bpTaskWeeklyQuan][i]);
                JSON_GetBool(node, "complete", BattlePass[playerid][bpTaskWeeklyComplete][i]);
            }
        }
    }
    for(new i; i < sizeof(BattlePassOneTimeTaskName); i++) // Разовые
    {
        new bool:is_null;
        format(string, sizeof(string), "bpTaskOneTime_%d", i);
        cache_is_value_name_null(0, string, is_null);

        if(is_null == false)
        {
            new string_json[512];
            cache_get_value_name(0, string, string_json, 512);

            new JsonNode:node = JSON_INVALID_NODE;
            if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
            {
                JSON_GetInt(node, "id", BattlePass[playerid][bpTaskOneTime][i]);
                JSON_GetInt(node, "quan", BattlePass[playerid][bpTaskOneTimeQuan][i]);
                JSON_GetBool(node, "complete", BattlePass[playerid][bpTaskOneTimeComplete][i]);
            }
        }
    }
    CreateAllTasksBattlePassForPlayer(playerid);
	return 1;
}

stock StartAllSaveBattlePass(playerid)
{
    if(!OnlineInfo[playerid][oBattlePassLoad]) return false;
    mysql_tquery(pearsq, "START TRANSACTION;");
    for(new i; i < MAX_LEVEL_BATTLEPASS; i++)
    {
        SaveSlotBattlePassAward(playerid, i);
    }

    for(new i; i < sizeof(BattlePassDailyTaskName); i++)
    {
        SaveSlotBattlePassTask(playerid,i,0);
    }

    for(new i; i < MAX_WEEKLY_BATTLEPASS_TASK; i++) // Еженедельные
    {
        SaveSlotBattlePassTask(playerid,i,1);
    }

    for(new i; i < sizeof(BattlePassOneTimeTaskName); i++) // Разовые
    {
        SaveSlotBattlePassTask(playerid,i,2);
    }

    new string_mysql[200];
    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `battlepass` SET `bpDay`= '%d', `bpWeekly`= '%d',`bpOneTimeLoad`= '%d' WHERE `user_id` = '%d'", BattlePass[playerid][bpDay],BattlePass[playerid][bpWeekly],BattlePass[playerid][bpOneTimeLoad], PlayerInfo[playerid][pID]);
    mysql_tquery(pearsq, string_mysql);

    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `battlepass` SET `bpDonate`= '%d',`bpLevel`= '%d',`bpExp`= '%d' WHERE `user_id` = '%d'",BattlePass[playerid][bpDonate], BattlePass[playerid][bpLevel],BattlePass[playerid][bpExp], PlayerInfo[playerid][pID]);
    mysql_tquery(pearsq, string_mysql);
    
    mysql_tquery(pearsq, "COMMIT;");
    return 1;
}
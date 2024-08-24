#define POLICE_DATABASE_MAX_ORG                 2 // Количество организаций с базами данных [0 - SAPD, 1 - FBI]

#define POLICE_DATABASE_MAX_GENERATORS          5 // Максимальное количество генераторов для одной организации

#define POLICE_DATABASE_MAX_EXPLODE_SLOTS       16 // Количество слотов под объекты для взрывов и т.п.
#define POLICE_DATABASE_MAX_EXPLODE_OBJECTS     28 // Максимальное количество взрываемых объектов в одном слоте

#define POLICE_DATABASE_VENT_OPEN_TIMES         4 // Количество нажатий на ПКМ для открытия вентиляции
#define POLICE_DATABASE_VENT_OPEN_COOLDOWN      2 // Время (в секундах) между нажатиями на ПКМ для открытия вентиляции

#define POLICE_DATABASE_BACK_TO_NORMAL          30 // Время (в минутах), сколько БД будет оставаться сломанной с последнего взаимодействия с ней (генераторы и т.п.)
#define POLICE_DATABASE_HACK_BACK_TO_NORMAL     2 // Время (в минутах), сколько БД будет оставаться сломанной после её взлома (удачного или неудачного)
#define POLICE_DATABASE_HACK_COOLDOWN           1 // Время (в часах), сколько БД нельзя будет взломать после последней попытки

#define POLICE_DATABASE_SHIELD_ATTEMPTS         2 // Максимальное число попыток неудачного взлома электрощитка, после которого включается тревога
#define POLICE_DATABASE_ALARM_TIMES             5 // Сколько раз будет проигрываться звук тревоги внутри здания

#define POLICE_DATABASE_THERMITE_TIME           5 // Время (в минутах), сколько горит термит перед "взрывом"
#define POLICE_DATABASE_THERMITE_MAKE_TIMES     20 // Количество нажатий на ПКМ для установки термита
#define POLICE_DATABASE_THERMITE_MAKE_COOLDOWN  1 // Время (в секундах) между нажатиями на ПКМ для установки термита
#define POLICE_DATABASE_THERMITE_EXPLODE_INDEX  15 // Индекс, под которым будут храниться объекты от термита (нужно избегать конфликта с генераторами/щитками)

#define POLICE_DATABASE_HACK_GAME_TEXTDRAWS     20 // Максимальное количество текстдравов в мини-игре при взломе
#define POLICE_DATABASE_HACK_GAME_DIVISIONS     7 // Количество делений при взломе (1 этап)

#define POLICE_DATABASE_HACK_PASSWORD_ATTEMPTS  32 // Максимальное количество попыток для угадывания пароля (должно быть больше возможных комбинаций, т.к. фактически они неограничены)
#define POLICE_DATABASE_HACK_PASSWORD_COOLDOWN  5 // Время (в секундах), сколько должно пройти времени после предыдущей попытки
#define POLICE_DATABASE_HACK_PASSWORD_TIME      3 // Время (в минутах), за которое требуется подобрать пароль для успешного взлома (2 этап)

enum e_PoliceDatabasePickupType
{
    POLICE_DATABASE_PICKUP_HACK, // Ноутбук (место для подключения к базе данных)
    POLICE_DATABASE_PICKUP_VENT, // Вентиляция
    POLICE_DATABASE_PICKUP_SHIELD, // Электрощиток
    POLICE_DATABASE_PICKUP_INFO, // Информационный пикап
    POLICE_DATABASE_PICKUP_THERMITE // Место для установки термита
};

enum e_PoliceDatabasePickups
{
    // Фракция и тип пикапа
    pdpFraction, e_PoliceDatabasePickupType: pdpType,

    // Позиция (Angle только для пикапов входа)
    Float: pdpX, Float: pdpY, Float: pdpZ, Float: pdpA,
    pdpWorld, pdpInterior,

    // Позиция выхода (для пикапов входа)
    Float: pdpExitX, Float: pdpExitY, Float: pdpExitZ, Float: pdpExitA,
    pdpExitWorld, pdpExitInterior
};

// Пикапы для системы (электрощитки должны располагаться друг за другом и на своих местах для PDatabase_ExplodeShield)
new policeDatabasePickups[][e_PoliceDatabasePickups] = {
    {0, POLICE_DATABASE_PICKUP_HACK, 1565.7759, -1657.6863, 6.2548, 0.0, 257, 0},
    {0, POLICE_DATABASE_PICKUP_VENT, 1578.3651, -1662.3876, 19.8792, 270.0, 0, 0, 1576.8755, -1676.6111, 6.2448, 90.0, 257, 0},
    {0, POLICE_DATABASE_PICKUP_VENT, 1578.3649, -1649.0015, 19.8792, 270.0, 0, 0, 1567.5018, -1667.8380, 6.2508, 90.0, 257, 0},
    {0, POLICE_DATABASE_PICKUP_SHIELD, 1600.1022, -1645.2532, 19.8792, 0.0, 0, 0},
    {1, POLICE_DATABASE_PICKUP_SHIELD, 2142.5193, 2410.8899, 65.2773, 0.0, 0, 0},
    {1, POLICE_DATABASE_PICKUP_SHIELD, 2159.9009, 2410.3467, 65.2773, 0.0, 0, 0},
    {1, POLICE_DATABASE_PICKUP_SHIELD, 2156.6042, 2418.4744, 65.2773, 0.0, 0, 0},
    {0, POLICE_DATABASE_PICKUP_INFO, 1578.8849, -1655.5782, 19.8792},
    {1, POLICE_DATABASE_PICKUP_VENT, 2173.0581,2420.7068,65.2773, 90.0, 0, 0, 2386.5444, 2545.5337, 2108.2761, 180.0, 217, 217},
    {1, POLICE_DATABASE_PICKUP_VENT, 2173.1594,2411.3130,65.2773, 90.0, 0, 0, 2395.0313, 2545.7136, 2110.4668, 180.0, 217, 217},
    {1, POLICE_DATABASE_PICKUP_INFO, 2171.6560, 2415.8867, 65.2773},
    {1, POLICE_DATABASE_PICKUP_THERMITE, 2156.5627, 2415.4214, 65.4495},
    {1, POLICE_DATABASE_PICKUP_HACK, 2402.3320, 2541.2825, 2110.4668, 0.0, 217, 217}
};

enum e_PoliceDatabaseStates
{
    POLICE_DATABASE_STATE_NORMAL, // В порядке
    POLICE_DATABASE_STATE_NO_SHIELD, // Отключен электрощиток
    POLICE_DATABASE_STATE_NO_GENERATORS // Разрушены генераторы
};

enum e_PoliceDatabaseInfo {
    e_PoliceDatabaseStates: pdiState, // Статус здания (норма, отключено аварийное питание и т.п.)
    pdiVentPlayers[MAX_REALPLAYERS], // Номера аккаунтов игроков, которые уже проходили через вентиляцию с момента последнего отключения сигнализации
    pdiHackerID, // ID аккаунта игрока, взламывающего базу данных прямо сейчас
    pdiLastHackerID, // ID аккаунта игрока, взломавшего базу данных в последний раз
    pdiHackAttemptTime, // Время попытки последнего взлома базы данных
    bool: pdiHacked, // Взломана ли база данных
    bool: pdiAlarm, // Включена ли тревога
    bool: pdiLightOff, // Выключено ли электричество
    bool: pdiExplode, // Взорвана ли (для серверной FBI, ..)
    pdiAlarmSoundCount, // Счётчик срабатываний звука сигнализации
    pdiExplodePickups[2], // PickupID для пикапов после взрыва (для FBI)
    pdiExplodeFiresCount, // Количество воспламенившихся огоньков при взрыве
    pdiExplodeStartTime, // Время начала воспламенения термита
    bool: pdiExplodeJoin, // Входили ли уже преступники через отверстие от термита
    bool: pdiHackAlarm, // В здании уже включалась сигнализация от взлома БД (1 этап)
    pdiHackPasswordAttempt, // Время последней попытки подбора пароля
    pdiClearSuspectRemains, // Скольким людям ещё можно очистить розыск
    pdiResetTime // Время до возврата в исходное состояние
};
new policeDatabaseInfo[POLICE_DATABASE_MAX_ORG][e_PoliceDatabaseInfo];

enum e_PoliceDatabasePasswordInfo
{
    pdiPassword[5], // Загаданный пароль
    pdiPasswordSymbols[5] // Известные цифры
};
new policeDatabasePasswordInfo[POLICE_DATABASE_MAX_ORG][e_PoliceDatabasePasswordInfo];
new policeDatabasePasswordAttempts[POLICE_DATABASE_MAX_ORG][POLICE_DATABASE_HACK_PASSWORD_ATTEMPTS][5];

new policeDatabaseExplodeObjects[POLICE_DATABASE_MAX_ORG][POLICE_DATABASE_MAX_EXPLODE_SLOTS][POLICE_DATABASE_MAX_EXPLODE_OBJECTS];

new bool: policeDatabaseVentState[sizeof(policeDatabasePickups)]; // Состояние вентиляции

enum e_PoliceDatabaseShieldInfo
{
    pdsiBreakingId, // ID аккаунта игрока, который взламывает электрощиток прямо сейчас
    pdsiFailCount, // Счётчик ошибок при взломе электрощитка
    bool: pdsiBreaked // Взломан ли электрощиток
};
new policeDatabaseShieldInfo[sizeof(policeDatabasePickups)][e_PoliceDatabaseShieldInfo]; // Состояние электрощитков

enum e_PoliceDatabaseGeneratorInfo {
    pdgiObjectID, // ObjectID генератора
    bool: pdgiBroken // Сломан ли генератор
};
new policeDatabaseGeneratorInfo[POLICE_DATABASE_MAX_ORG][POLICE_DATABASE_MAX_GENERATORS][e_PoliceDatabaseGeneratorInfo];

enum e_PoliceDatabaseHackStage {
    POLICE_DATABASE_HACK_STAGE_NONE,
    POLICE_DATABASE_HACK_STAGE_GAME,
    POLICE_DATABASE_HACK_STAGE_PASSWORD
};

enum e_PoliceDatabasePlayerInfo {
    bool: pdpiGeneratorBroke, // Ломает ли игрок генератор
    pdpiGeneratorID, // ID генератора, который ломает игрок
    pdpiGeneratorTime, // Отсчет при поломке генератора
    pdpiGeneratorTimer, // Таймер поломки генератора
    pdpiVentClick, // Когда в последний раз нажали ПКМ при открытии вентиляции (используется и для некоторых других действий с КД)
    e_PoliceDatabaseHackStage: pdpiHackStage, // Этап взлома
    pdpiHackGameDuration, // Длительность этапа взлома (в секундах)
    pdpiFractionID, // ID организации, с которой проходит взаимодействие (взлом и т.п.)
    pdpiHackGameCheckpointID, // ID последнего зафиксированного деления на этапе взлома
    Float: pdpiX, Float: pdpiY, Float: pdpiZ
};
new policeDatabasePlayerInfo[MAX_REALPLAYERS][e_PoliceDatabasePlayerInfo];
new PlayerText: policeDatabasePlayerTextDraws[MAX_REALPLAYERS][POLICE_DATABASE_HACK_GAME_TEXTDRAWS];

// TODO: КЛЮЧ КАРТА
#define MAX_TOMB_ROOMS          20 // Максимальное количество комнат (активных игр) одновременно
#define MIN_TOMB_PLAYERS        3  // Минимальное количество игроков в одной комнате
#define MAX_TOMB_PLAYERS        10 // Максимальное количество игроков в одной комнате
#define MAX_TOMB_MUMMY          200 // Максимальное количество мумий в одной комнате одновременно (включая трупы)

#define TOMB_WAVE_COOLDOWN      30 // Время в секундах между волнами
#define TOMB_WAVE_COOLDOWN_TEST 5 // Время в секундах между волнами (на тестовом сервере)
#define TOMB_COOLDOWN           90 // Время в минутах до повторного участия в игре

#define TOMB_MAX_DEATHS         3 // Максимальное количество смертей за игру

enum e_TombWave
{
    TOMB_WAVE_EASY,
    TOMB_WAVE_NORMAL,
    TOMB_WAVE_HARD,
    TOMB_WAVE_INSANE,
    TOMB_WAVE_IMPOSSIBLE
};

enum e_TombDifficulty
{
    TOMB_DIFFICULTY_EASY,
    TOMB_DIFFICULTY_HARD,

    // Счетчик типов
    TOMB_MAX_DIFFICULTY
};

enum e_TombEndReason
{
    TOMB_END_REASON_LOSE,
    TOMB_END_REASON_WIN
};

enum e_TombMummyType
{
    TOMB_NORMAL_MUMMY,
    TOMB_HEAVY_MUMMY,
    TOMB_BOSS_MUMMY,

    // Счетчик типов
    TOMB_MAX_MUMMY_TYPE
};

enum e_TombInfo
{
    // Данные о создателе и статусе игры
    bool: tpPlay, // Статус игры
    tiOwner, // ID создателя (владельца) комнаты

    // Данные о комнате
    e_TombWave: tiWave, // Текущая волна
    e_TombDifficulty: tpDifficulty, // Уровень сложности
    tiSetWaveTimer, // Таймер на изменение волны
    tiWaveCooldown, // КД до появления следующей волны
    tiMummyWave[_:TOMB_MAX_MUMMY_TYPE], // Сколько заспавнится мумий каждого вида в текущей волне
    tiMummyNextSpawn[_:TOMB_MAX_MUMMY_TYPE], // Сколько заспавнится мумий каждого вида при следующем вызове их спавна
    Float: tiMummyMaxHealth, // Здоровье, которое имеет обычная мумия
    Float: tiMummyDamage, // Урон, наносимый обычной мумией по игроку
    tpMummyKilled[_:TOMB_MAX_MUMMY_TYPE], // Количество убитых мумий каждого вида
    tpLastWaveMummyKilled[_:TOMB_MAX_MUMMY_TYPE], // Количество убитых мумий каждого вида при завершении последней волны
    tiLastMummyWaveKilled, // Количество убитых мумий при завершении последней волны

    // NPC
    NPC: tiMummy[MAX_TOMB_MUMMY], // ID мумий
    tiMummyTypes[MAX_TOMB_MUMMY], // Типы мумий
    tiMummyAttackId[MAX_TOMB_MUMMY], // Атакуемые игроки (+1)

    // Игроки
    tpPlayers[MAX_TOMB_PLAYERS], // ID участников (+1)
};
new TombInfo[MAX_TOMB_ROOMS][e_TombInfo];

enum e_TombPlayerInfo
{
    bool: tpPlay, // Статус игры
    tpRoomID, // ID комнаты
    tpPlayers[MAX_TOMB_PLAYERS], // ID участников при создании комнаты (+1)
    e_TombDifficulty: tpDifficulty, // Уровень сложности при создании комнаты
    tpMummyKilled[_:TOMB_MAX_MUMMY_TYPE], // Количество убитых игроком мумий каждого вида
    tpLastWaveMummyKilled[_:TOMB_MAX_MUMMY_TYPE], // Количество убитых мумий каждого вида при завершении последней волны
    tpSpectateID, // ID игрока, за которым происходит слежка (+1)
    tpCases, // Гарантированное кол-во кейсов, которые игрок заработал на протяжении игры (не учитывая те, что в конце игры)
    tpSpentAmmo[4], // Потраченные патроны с начала последней волны (fpick 27-30)
    Float: tpCurse, // Статус проклятия (0.00 - 100.00)
    Float: tpDamage, // Количество нанесённого урона
    tpDeadCount, // Сколько раз умер
    bool: tpDead // Статус смерти
};
new TombPlayerInfo[MAX_REALPLAYERS][e_TombPlayerInfo];
new Float: TombGetOutPosition[MAX_REALPLAYERS][4];
new TombZone; // Dynamic Area

enum e_TombMummyPos {
    Float: tpMinX, Float: tpMinY, Float: tpMaxX, Float: tpMaxY,
    Float: tpZ, Float: tpAngle
};
new TombMummySpawns[][e_TombMummyPos] = {
    {2100.0034, 1569.5369, 2106.2327, 1573.8058, 2773.5884, 280.0},
    {2120.0151, 1589.5018, 2127.0823, 1596.0171, 2773.5884, 180.0},
    {2128.7051, 1567.9833, 2129.5244, 1573.6090, 2773.5884, 235.0},
    {2164.1880, 1573.8109, 2170.9402, 1574.4644, 2776.6357, 124.0},
    {2123.9863, 1598.1649, 2127.3979, 1599.8364, 2773.6704, 180.0},
    {2114.0798, 1593.9899, 2114.9231, 1598.9957, 2773.5884, 215.0},
    {2102.0581, 1570.6550, 2103.7712, 1575.5443, 2773.5884, 210.0},
    {2173.6563, 1554.5188, 2177.8237, 1559.8181, 2775.1772, 80.0}
};

new PlayerText: TombMummyRemainsTD[MAX_REALPLAYERS][2];
new PlayerText: TombCurseTD[MAX_PLAYERS][2];

enum e_TombDisallowedAreas {
    Float: tdaMinX, Float: tdaMinY,
    Float: tdaMaxX, Float: tdaMaxY,
    Float: tdaZ
};
new TombDisallowedAreas[][e_TombDisallowedAreas] = {
    {2098.8474, 1576.2327, 2103.2568, 1579.6859, 2776.2644},
    {2106.8296, 1565.7518, 2108.4983, 1567.2086, 2774.7312},
    {2115.8457, 1559.0649, 2119.9663, 1559.7081, 2776.0981},
    {2122.1538, 1557.7358, 2124.1738, 1559.8698, 2775.9897},
    {2126.5164, 1559.1080, 2128.5757, 1559.9578, 2775.5657},
    {2131.8079, 1556.6187, 2134.2886, 1557.2026, 2775.5657},
    {2125.2617, 1568.8152, 2126.3447, 1572.8278, 2774.8369},
    {2127.8203, 1564.1606, 2129.4453, 1566.7673, 2775.9897},
    {2134.2991, 1564.9268, 2136.5833, 1565.2262, 2775.5657},
    {2141.3545, 1568.8947, 2144.2551, 1571.2600, 2776.8103},
    {2122.4016, 1600.2377, 2125.1521, 1603.0823, 2776.2644},
    {2182.2517, 1556.0127, 2185.4014, 1557.6790, 2777.4580},
    {2138.6096, 1535.7816, 2147.7810, 1543.2975, 2778.7693},
    {2132.7773, 1572.6160, 2133.4988, 1574.8724, 2775.5657}
};

enum e_TombDisallowedAreaPoints {
    Float: tdapX, Float: tdapY, Float: tdapZ, Float: tdapA
};
new TombDisallowedAreaPoints[][e_TombDisallowedAreaPoints] = {
    {2102.2302, 1573.8566, 2773.5884, 264.6734}, 
    {2097.9661, 1576.6873, 2773.5884, 226.7201}, 
    {2098.8286, 1582.0681, 2773.5884, 317.9794}, 
    {2103.8110, 1580.2949, 2773.5884, 240.9382}, 
    {2120.9592, 1566.1469, 2773.5884, 235.6896}, 
    {2126.6077, 1557.2052, 2773.5884, 244.2285}, 
    {2131.9758, 1558.4259, 2773.5884, 305.0547}, 
    {2133.3611, 1566.2358, 2773.5884, 8.1918}, 
    {2135.8042, 1572.7429, 2773.5884, 18.1793}, 
    {2124.1450, 1572.8746, 2773.5884, 169.3994}, 
    {2147.2952, 1571.9879, 2773.5884, 204.6095}, 
    {2143.5586, 1546.6194, 2773.5884, 357.1432}, 
    {2181.2896, 1553.2405, 2775.8521, 64.1752}, 
    {2127.1897, 1600.4833, 2773.7498, 146.2238}, 
    {2120.1365, 1540.1671, 2776.5542, 333.3977} 
};

//#define TOMB_DEBUG_MODE // Отладка гробницы (Закомментировать, если не требуется)

#define MAX_TOMB_ROOMS          20 // Максимальное количество комнат (активных игр) одновременно
#define MIN_TOMB_PLAYERS        3  // Минимальное количество игроков в одной комнате
#define MAX_TOMB_PLAYERS        10 // Максимальное количество игроков в одной комнате
#define MAX_TOMB_MUMMY          200 // Максимальное количество мумий в одной комнате одновременно (включая трупы)

#define TOMB_WAVE_COOLDOWN      30 // Время в секундах между волнами
#define TOMB_WAVE_COOLDOWN_TEST 5 // Время в секундах между волнами (на тестовом сервере)
#define TOMB_COOLDOWN           60 // Время в минутах до повторного участия в игре

enum e_TombWave
{
    TOMB_WAVE_EASY,
    TOMB_WAVE_NORMAL,
    TOMB_WAVE_HARD,
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

// TODO: Заполнить
enum e_TombDisallowedAreas {
    Float: tdaMinX, Float: tdaMinY,
    Float: tdaMaxX, Float: tdaMaxY,

    e_TombMummyPos: tdaSpawnPosition[10]
};

//#define TOMB_DEBUG_MODE // Отладка гробницы (Закомментировать, если не требуется)

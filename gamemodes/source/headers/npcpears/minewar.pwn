#define MAX_MINEWAR_ROOMS       20 // Максимальное количество комнат (активных игр) одновременно
#define MIN_MINEWAR_PLAYERS     2  // Минимальное количество игроков в одной комнате
#define MAX_MINEWAR_PLAYERS     10 // Максимальное количество игроков в одной комнате
#define MAX_MINEWAR_ZOMBIES     30 // Максимальное количество зомби в одной комнате одновременно

#define MINEWAR_WAVE_COOLDOWN   30 // Время в секундах между волнами
#define MINEWAR_COOLDOWN        60 // Время в минутах до повторного участия в игре

enum e_MineWarWave
{
    MINEWAR_WAVE_EASY,
    MINEWAR_WAVE_NORMAL,
    MINEWAR_WAVE_HARD,
    MINEWAR_WAVE_IMPOSSIBLE
};

enum e_MineWarDifficulty
{
    MINEWAR_DIFFICULTY_EASY,
    MINEWAR_DIFFICULTY_HARD,

    // Счетчик типов
    MINEWAR_MAX_DIFFICULTY
};

enum e_MineWarEndReason
{
    MINEWAR_END_REASON_LOSE,
    MINEWAR_END_REASON_WIN
};

enum e_MineWarZombieType
{
    MINEWAR_NORMAL_ZOMBIE,
    MINEWAR_HEAVY_ZOMBIE,
    MINEWAR_SUPER_ZOMBIE,

    // Счетчик типов
    MINEWAR_MAX_ZOMBIE_TYPE
};

enum e_MineWarInfo
{
    // Данные о создателе и статусе игры
    bool: mwPlay, // Статус игры
    mwOwner, // ID создателя (владельца) комнаты

    // Данные о комнате
    e_MineWarWave: mwWave, // Текущая волна
    e_MineWarDifficulty: mwDifficulty, // Уровень сложности
    mwSetWaveTimer, // Таймер на изменение волны
    mwWaveCooldown, // КД до появления следующей волны
    mwZombieWave[_:MINEWAR_MAX_ZOMBIE_TYPE], // Сколько заспавнится зомби каждого вида в текущей волне
    mwZombieNextSpawn[_:MINEWAR_MAX_ZOMBIE_TYPE], // Сколько заспавнится зомби каждого вида при следующем вызове их спавна
    Float: mwZombieMaxHealth, // Здоровье, которое имеет обычный зомби
    Float: mwZombieDamage, // Урон, наносимый обычным зомби по игроку
    mwZombieKilled[_:MINEWAR_MAX_ZOMBIE_TYPE], // Количество убитых зомби каждого вида
    mwLastWaveZombieKilled[_:MINEWAR_MAX_ZOMBIE_TYPE], // Количество убитых зомби каждого вида при завершении последней волны
    mwLastZombieWaveKilled, // Количество убитых зомби при завершении последней волны

    // NPC
    NPC: mwZombie[MAX_MINEWAR_ZOMBIES], // ID зомби
    mwZombieTypes[MAX_MINEWAR_ZOMBIES], // Типы зомби

    // Игроки
    mwPlayers[MAX_MINEWAR_PLAYERS], // ID участников (+1)
};
new MineWarInfo[MAX_MINEWAR_ROOMS][e_MineWarInfo];

enum e_MineWarPlayerInfo
{
    bool: mwpPlay, // Статус игры
    mwpRoomID, // ID комнаты
    mwpPlayers[MAX_MINEWAR_PLAYERS], // ID участников при создании комнаты (+1)
    e_MineWarDifficulty: mwpDifficulty, // Уровень сложности при создании комнаты
    mwpZombieKilled[_:MINEWAR_MAX_ZOMBIE_TYPE], // Количество убитых игроком зомби каждого вида
    mwpLastWaveZombieKilled[_:MINEWAR_MAX_ZOMBIE_TYPE], // Количество убитых зомби каждого вида при завершении последней волны
    mwpSpectateID, // ID игрока, за которым происходит слежка (+1)
    mwpCases, // Гарантированное кол-во кейсов, которые игрок заработал на протяжении игры (не учитывая те, что в конце игры)
    bool: mwpDead, // Статус смерти
};
new MineWarPlayerInfo[MAX_REALPLAYERS][e_MineWarPlayerInfo];
new Float: MineWarGetOutPosition[MAX_REALPLAYERS][4];
new MineWarZone; // Dynamic Area

enum e_MineWarZombiePos {
    Float: mwMinX, Float: mwMinY, Float: mwMaxX, Float: mwMaxY,
    Float: mwZ, Float: mwAngle
};
new MineWarZombieSpawns[][e_MineWarZombiePos] = {
    {-22.3359, 1168.6263, -27.8809, 1161.7518, 1311.0126, 180.0},
    {-41.8019, 1131.1935, -36.8864, 1123.4080, 1311.0126, 260.0},
    {-10.5086, 1116.3035, 11.5203, 1118.2679, 1310.8254, 90.0},
    {-41.8019, 1131.1935, -36.8864, 1123.4080, 1311.0126, 260.0},
    {-16.6597, 1110.6980, -10.5086, 1116.3035, 1310.8254, 350.0},
    {11.5203, 1118.2679, 6.1384, 1125.2892, 1311.0126, 80.0},
    {-4.3277, 1160.7217, -12.1403, 1164.8251, 1312.4802, 120.0}
};

//#define MINEWAR_DEBUG_MODE // Отладка заброшенной шахты (Закомментировать, если не требуется)
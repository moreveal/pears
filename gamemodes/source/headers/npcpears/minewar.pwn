#define MAX_MINEWAR_ROOMS       20 // Максимальное количество комнат (активных игр) одновременно
#define MIN_MINEWAR_PLAYERS     2  // Минимальное количество игроков в одной комнате
#define MAX_MINEWAR_PLAYERS     10 // Максимальное количество игроков в одной комнате
#define MAX_MINEWAR_ZOMBIES     200 // Максимальное количество зомби в одной комнате одновременно (включая трупы)

#define MINEWAR_WAVE_COOLDOWN   30 // Время в секундах между волнами
#define MINEWAR_COOLDOWN        90 // Время в минутах до повторного участия в игре

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
    mwZombieAttackId[MAX_MINEWAR_ZOMBIES], // Атакуемые игроки (+1)

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
    mwpSpentAmmo[4], // Потраченные патроны с начала последней волны (fpick 27-30)
    Float: mwpDamage, // Количество нанесённого урона
    mwpDeadCount, // Сколько раз умер
    bool: mwpDead // Статус смерти
};
new MineWarPlayerInfo[MAX_REALPLAYERS][e_MineWarPlayerInfo];
new Float: MineWarGetOutPosition[MAX_REALPLAYERS][4];
new MineWarZone; // Dynamic Area

enum e_MineWarZombiePos {
    Float: mwMinX, Float: mwMinY, Float: mwMaxX, Float: mwMaxY,
    Float: mwZ, Float: mwAngle
};
new MineWarZombieSpawns[][e_MineWarZombiePos] = {
    {-22.3369, 1169.7123, -28.1401, 1162.1517, 1310.8254, 185.3741},
    {-0.1406, 1141.8003, -4.9723, 1149.0660, 1310.8254, 77.1164},
    {15.5721, 1122.4795, 10.9586, 1131.1512, 1311.0183, 86.4160},
    {-4.2298, 1117.2642, 2.9308, 1121.4009, 1310.8254, 353.5289},
    {-15.0866, 1105.5962, -10.1442, 1109.4769, 1310.8693, 341.4824},
    {-33.5133, 1111.2592, -29.2622, 1114.8145, 1310.8254, 335.9769},
    {-40.8616, 1131.3792, -32.7045, 1121.6981, 1311.0126, 267.2898},
    {-42.4848, 1139.7998, -37.4226, 1133.9506, 1310.8254, 316.0084},
    {-54.0011, 1126.4329, -52.6392, 1121.5198, 1311.0126, 314.4378}
};

new PlayerText: MineWarZombieRemainsTD[MAX_REALPLAYERS][2];

//#define MINEWAR_DEBUG_MODE // Отладка заброшенной шахты (Закомментировать, если не требуется)

#define MAX_OBSTACLE_POINTS     75  // Максимальное количество "точек" в одном маршруте
#define MAX_OBSTACLE_ROUTES     10  // Максимальное количество созданных маршрутов
#define MAX_OBSTACLE_PLAYERS    15  // Максимальное количество участников в одной команде

#define OBSTACLE_TEAMS_AMOUNT   2   // Максимальное количество команд, для каждой свой маршрут (значение задано для удобства, не изменять)
#define OBSTACLE_TYPES_AMOUNT   2   // Количество доступных типов (значение задано для удобства, не изменять)

enum e_ObstacleInfoType {
    OBSTACLE_TYPE_SOLO, // Одиночное прохождение
    OBSTACLE_TYPE_TEAM // Командное прохождение (1х1, 2х2, 3х3, ...)
};

enum e_ObstacleInfoPoint {
    Float: obpX,
    Float: obpY,
    Float: obpZ
};

enum e_ObstacleInfoStats {
    obsPID, // ID аккаунта игрока
    obsTeam, // Команда игрока
    obsName[MAX_PLAYER_NAME + 1], // Ник игрока
    obsPassTime // Время прохождения маршрута
};

enum e_ObstacleInfo {
    obName[128], // Название маршрута
    obPassTime, // Время прохождения
    obLastPassTime, // Время прохождения перед последним запуском
    bool: obStarted, // Запущен ли маршрут
    obStartedTime, // Время последнего запуска
    e_ObstacleInfoType: obType // Тип маршрута
};
new ObstacleInfo[MAX_OBSTACLE_ROUTES][e_ObstacleInfo];
new ObstaclePointsInfo[MAX_OBSTACLE_ROUTES][OBSTACLE_TEAMS_AMOUNT][MAX_OBSTACLE_POINTS][e_ObstacleInfoPoint]; // Точки машрутов
new ObstacleMembersInfo[MAX_OBSTACLE_ROUTES][OBSTACLE_TEAMS_AMOUNT][MAX_OBSTACLE_PLAYERS]; // Текущие участники маршрута (playerid + 1)
new ObstacleStatsInfo[MAX_OBSTACLE_ROUTES][MAX_OBSTACLE_PLAYERS][e_ObstacleInfoStats]; // Статистика маршрута (обнуляется каждый запуск)

enum e_ObstaclePlayerInfo {
    obpRouteID, // ID маршрута
    obpTeam, // Номер команды
    bool: obpStarted, // Проходил ли один из маршрутов
    bool: obpEditPoints, // Редактирует ли точки
    bool: obpCreate, // Создает ли маршрут

    // Чекпоинт
    obpCheckpoint, // ID последнего взятого чекпоинта
    obpCheckpointModel, // Streamer Object

    // Создание нового маршрута
    obpName[128],
    obpPassTime,
    e_ObstacleInfoType: obpType,
    obpMapIcons[MAX_OBSTACLE_POINTS], // ID иконок на карте
};
new ObstaclePlayerInfo[MAX_REALPLAYERS][e_ObstaclePlayerInfo];
new ObstaclePlayerPointsInfo[MAX_REALPLAYERS][OBSTACLE_TEAMS_AMOUNT][MAX_OBSTACLE_POINTS][e_ObstacleInfoPoint];

new PlayerText: ObstacleTimeTD[MAX_PLAYERS];

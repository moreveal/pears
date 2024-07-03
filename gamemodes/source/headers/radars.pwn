#define MAX_RADARS                      50 // Максимально возможное количество радаров на сервере
#define RADAR_PER_PLAYER                5 // Максимальное количество радаров на игрока
#define RADAR_INTERVAL                  300.0 // Минимальное расстояние между радарами
#define RADAR_RADIUS                    60.0 // Радиус срабатывания по умолчанию
#define RADAR_CREATING_TIMES            30 // Количество нажатий на ПКМ для установки радара
#define RADAR_MANUAL_REPAIR_TIMES       45 // Количество нажатий на ПКМ для ремонта радара
#define AUTO_UNPLACE_RADAR_TIME         5 // Время в минутах, через которое радары должны быть удалены из игрового мира после отключения их владельца

#define RADAR_POLICE_SHARE              40 // Доля (в процентах), выплачиваемая организации, установившей радар [ Выплата сотрудникам настраивается в правах доступа ]
#define RADAR_GOVERNMENT_SHARE          60 // Доля (в процентах), выплачиваемая в казну

#define RADAR_BROKE_TIME                10 // Время в минутах, сколько радар будет продолжать оставаться сломанным после разрушения
#define RADAR_BROKE_HITS_AMOUNT         5 // Количество попаданий с оружия для ломания радара

enum e_RadarInfo {
    bool: riPlaced, // Установлен ли радар
    bool: riBroken, // Сломан ли радар
    riHits, // Количество попаданий по радару
    Float: riX, Float: riY, Float: riZ, Float: riRX, Float: riRY, Float: riRZ, // Позиция установленного радара
    Float: riRadius, // Радиус действия радара
    riFraction, // ID организации, за которой закреплён радар
    riMaxSpeed, // Максимальная допустимая скорость
    riFine, // Штраф за превышение скорости
    riTicketsIssued, // Общее количество выписанных штрафов (шт.)
    riFineTotal, // Общее количество принесённых денег ($)
    Text3D: riTextLabel, // ID текстлейбла
    riObjects[30], // ID объектов радара
    riPID, // Номер аккаунта игрока, которому принадлежит радар
    riOwnerName[24], // Имя игрока, которому принадлежит радар

    // Таймеры
    riAutoUnplaceTimer, // Авто-удаление радара из игрового мира
    riDeleteLaserTimer, // Удаление лазера
    riUpdateLaserTimer, // Обновление позиции лазера
    riDeleteFlashlightTimer, // Удаление вспышки
    riRepairTimer, // Автоматическая починка
};
new RadarInfo[MAX_RADARS][e_RadarInfo];

enum e_PlayerRadarInfo {
    priCooldown, // Задержка в секундах перед следующим возможным получением штрафа
    priLastRadar, // Последний радар (фиксация нарушения, последнее попадание, ...)
    Float: priX, Float: priY, Float: priZ // Хранение какой-либо позиции, связанной с радарами
};
new PlayerRadarInfo[MAX_REALPLAYERS][e_PlayerRadarInfo];
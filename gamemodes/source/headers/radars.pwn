#define MAX_RADARS                      35 // Максимально возможное количество радаров на сервере
#define RADAR_PER_PLAYER                2 // Максимальное количество радаров на игрока
#define RADAR_PER_CITY                  8 // Максимальное количество радаров на один город
#define RADAR_INTERVAL                  400 // Минимальное расстояние между радарами
#define RADAR_RADIUS                    65.0 // Радиус срабатывания по умолчанию
#define RADAR_CREATING_TIMES            30 // Количество нажатий на ПКМ для установки радара
#define RADAR_MANUAL_REPAIR_TIMES       45 // Количество нажатий на ПКМ для ремонта радара

#define RADAR_GOVERNMENT_SHARE          55 // Доля (в процентах), выплачиваемая в казну
#define RADAR_POLICE_SHARE              45 // Доля (в процентах), выплачиваемая организации, установившей радар [ Выплата сотрудникам настраивается в правах доступа ]

#define RADAR_BROKE_TIME                20 // Время в минутах, сколько радар будет продолжать оставаться сломанным после разрушения
#define RADAR_BROKE_NO_FIX_TIME         7  // Время в минутах, сколько радар после разрушения будет непригодным для починки
#define RADAR_BROKE_COOLDOWN            10 // Время в минутах, сколько радар не может быть разрушен после последнего разрушения
#define RADAR_BROKE_PLAYER_COOLDOWN     5  // Время в минутах, в течение которого игрок не сможет разрушать радары после разрушения одного из них
#define RADAR_BROKE_HITS_AMOUNT         5 // Количество попаданий с оружия для ломания радара

#define RADAR_JAMMED_TIME               3 // Время в секундах, сколько радар будет заглушен после отключения
#define RADAR_JAMMER_COOLDOWN           12 // Время в секундах, сколько глушилка не будет работать после одного срабатывания
#define RADAR_JAMMER_SOFTWARE_TIME      7 // Количество дней, в течение которых будет работать глушилка после приобретения (далее придется обновлять ПО)

#define RADAR_DETECT_RADIUS             160 // Радиус для обычного детектора
#define RADAR_ENHANCED_DETECT_RADIUS    260 // Радиус для улучшенного детектора

enum e_RadarBroken {
    RADAR_BROKEN_NONE, // Не сломан
    RADAR_BROKEN_NO_FIX, // Горит (Нельзя чинить)
    RADAR_BROKEN_FIX // Искрит (Можно чинить)
};

enum e_RadarInfo {
    bool: riPlaced, // Установлен ли радар
    e_RadarBroken: riBroken, // Сломан ли радар
    riBrokenTime, // Время последнего разрушения
    riHits, // Количество попаданий по радару
    riRepairTimerStarted, // Время, когда был запущен таймер на починку/смену статуса сломанного радара
    riJammedTime, // Время последнего глушения радара
    Float: riX, Float: riY, Float: riZ, Float: riRX, Float: riRY, Float: riRZ, // Позиция установленного радара
    Float: riLastX, Float: riLastY, Float: riLastZ, // Последняя установленная позиция радара (для перемещений и т.п.) 
    Float: riRadius, // Радиус действия радара
    riFraction, // ID организации, за которой закреплён радар
    riMaxSpeed, // Максимальная допустимая скорость
    riFine, // Штраф за превышение скорости
    riTicketsIssued, // Общее количество выписанных штрафов (шт.)
    riFineTotal, // Общее количество принесённых денег ($)
    riFineTotalBeforeUnits, // Последнее количество принесённых денег до сбора юнитов с радара
    Text3D: riTextLabel, // ID текстлейбла
    riObjects[30], // ID объектов радара
    riPID, // Номер аккаунта игрока, которому принадлежит радар
    riOwnerName[24], // Имя игрока, которому принадлежит радар

    // Таймеры
    riDeleteLaserTimer, // Удаление лазера
    riUpdateLaserTimer, // Обновление позиции лазера
    riDeleteFlashlightTimer, // Удаление вспышки
    riRepairTimer, // Автоматическая починка
    riLabelNoFixTimer, // Обновление 3D текста для счетчика времени перед возможностью его починить
};
new RadarInfo[MAX_RADARS][e_RadarInfo];

enum e_PlayerRadarInfo {
    priCooldown, // Задержка в секундах перед следующим возможным получением штрафа
    priLastRadar, // Последний радар (фиксация нарушения, последнее попадание, ...)
    priBrokenRadarTime, // Время последнего разрушения радара
    priClosestRadarMapIcon, // Иконка ближайшего радара на карте
    priJammedTime, // Время последнего глушения радара

    priDetectTime, // Время последнего обнаружения радара детектором
    priLastDetectRadar, // ID последнего обнаруженного детектором радара
    bool: priDetectTextdraw, // Отображается ли текстдрав в настоящий момент

    Float: priX, Float: priY, Float: priZ // Хранение какой-либо позиции, связанной с радарами
};
new PlayerRadarInfo[MAX_REALPLAYERS][e_PlayerRadarInfo];

new PlayerText: radarDetector_TD[MAX_REALPLAYERS][40];
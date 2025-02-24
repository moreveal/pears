/*
    Добавление новой наркофермы:

    1. Увеличить константу MAX_NARCO_FARMS на 1
    2. Добавить позиции кустов в каждой из будок (левый нижний/правый верхний углы) в массив NarcoFarmBoothArea
    3. Добавить модели кустов в массив NarcoFarmBushes (если они отличаются от уже существующих)
    4. Добавить позицию интерактивных мест в массив NarcoFarmInteractivePositions
    4. Добавить всё остальное в самой игре: /drugfarms (область фермы, продавец и т.п.)
*/

#define MAX_NARCO_FARMS                         1 // Общее количество наркоферм
#define MAX_NARCO_FARMS_BOOTHS                  4 // Максимальное количество будок на наркоферме
#define MAX_NARCO_FARMS_BUSHES                  4 // Максимальное количество кустов в будке

#define NARCO_FARMS_RENT_TIME                   3600 // Время аренды будки (в секундах)
#define NARCO_FARMS_MAFIA_DISCOUNT              20 // Скидка в будке для нужд мафии (в процентах)

#define NARCO_FARMS_RIPE_TIME                   6 // Время созревания куста (в количествах поливаний)
#define NARCO_FARMS_RIPE_TIME_TEST              3 // Время созревания куста (в количествах поливаний)
#define NARCO_FARMS_MAX_COCAINE                 3 // Максимальное количество кокаина на кусте

#define NARCO_FARMS_WATER_TIME                  240 // Время между поливами (в секундах)
#define NARCO_FARMS_MAX_WATER_TIME              60 // Допустимое время ожидания полива перед засыханием (в секундах)

#define NARCO_FARMS_BUSH_VIRTUAL_WORLD          100 // Виртуальный мир для скрытых кустов

#define NARCO_FARMS_BUSH_MODELID                808 // Модель куста
#define NARCO_FARMS_DEAD_BUSH_MODELID           809 // Модель засохшего куста

#define NARCO_FARMS_EXCAVATE_PUMP_POINTS        50 // Количество очков, которые нужно потратить на раскопку куста
#define NARCO_FARMS_WATER_PUMP_POINTS           50 // Количество очков, которые нужно потратить на полив куста
#define NARCO_FARMS_SEED_PUMP_POINTS            50 // Количество очков, которые нужно потратить на посадку саженца
#define NARCO_FARMS_PACK_PUMP_POINTS            50 // Количество очков, которые нужно потратить на упаковку порошка

#define NARCO_FARMS_SPAWN_RADIUS                6.0 // Радиус спавна защитников и атакующих

#define INVALID_NARCOFARM_ID                    -1 // Неверный ID наркофермы

enum e_NarcoFarmInfo {
    // SQL only
    dfiID, // ID наркофермы (+1)

    dfiFraction, // Контролирующая организация
    dfiRentPrice, // Стоимость аренды куста
    dfiMafiaBoothId, // ID будки для нужд мафии
    Float: dfiInfoPos[3], // Расположение информационного пикапа
    Float: dfiSellerPos[4], // Расположение продавца
    Float: dfiAreaPos[6], // Позиция области наркофермы
    Float: dfiSpawnDefendersPos[4], // Позиция спавна защитников
    Float: dfiSpawnAttackersPos[4], // Позиция спавна атакующих
    STREAMER_TAG_AREA: dfiArea, // Область наркофермы
    STREAMER_TAG_3D_TEXT_LABEL: dfiPackLabel, // Лейбл упаковочного стола
    STREAMER_TAG_3D_TEXT_LABEL: dfiSeedLabel, // Лейбл места для семян
    STREAMER_TAG_3D_TEXT_LABEL: dfiLeekLabel, // Лейбл места для леек
    STREAMER_TAG_3D_TEXT_LABEL: dfiBasketLabel, // Лейбл места для корзинки
    STREAMER_TAG_PICKUP: dfiInfoPickup, // Информационный пикап
    STREAMER_TAG_3D_TEXT_LABEL: dfiInfoLabel, // Лейбл информационного пикапа
    STREAMER_TAG_ACTOR: dfiSellerActor, // Продавец
    STREAMER_TAG_3D_TEXT_LABEL: dfiSellerActorLabel // Лейбл продавца=
};
new NarcoFarmInfo[MAX_NARCO_FARMS][e_NarcoFarmInfo];
SQL_ENUM_DEFINE(NarcoFarmInfo) {
    {"id", FIELD_TYPE_INT, 1, FIELD_COLUMN_PRIMARY_KEY | FIELD_COLUMN_NOT_NULL},
    {"fraction", FIELD_TYPE_INT},
    {"booth_rent_price", FIELD_TYPE_INT},
    {"booth_mafia", FIELD_TYPE_INT},
    {"info_pickup_x", FIELD_TYPE_FLOAT},
    {"info_pickup_y", FIELD_TYPE_FLOAT},
    {"info_pickup_z", FIELD_TYPE_FLOAT},
    {"seller_pos_x", FIELD_TYPE_FLOAT},
    {"seller_pos_y", FIELD_TYPE_FLOAT},
    {"seller_pos_z", FIELD_TYPE_FLOAT},
    {"seller_pos_a", FIELD_TYPE_FLOAT},
    {"area_min_x", FIELD_TYPE_FLOAT},
    {"area_min_y", FIELD_TYPE_FLOAT},
    {"area_min_z", FIELD_TYPE_FLOAT},
    {"area_max_x", FIELD_TYPE_FLOAT},
    {"area_max_y", FIELD_TYPE_FLOAT},
    {"area_max_z", FIELD_TYPE_FLOAT},
    {"defenders_pos_x", FIELD_TYPE_FLOAT},
    {"defenders_pos_y", FIELD_TYPE_FLOAT},
    {"defenders_pos_z", FIELD_TYPE_FLOAT},
    {"defenders_pos_a", FIELD_TYPE_FLOAT},
    {"attackers_pos_x", FIELD_TYPE_FLOAT},
    {"attackers_pos_y", FIELD_TYPE_FLOAT},
    {"attackers_pos_z", FIELD_TYPE_FLOAT},
    {"attackers_pos_a", FIELD_TYPE_FLOAT},
    {"", FIELD_TYPE_SKIP, 9}
};

new Float: NarcoFarmBoothArea[MAX_NARCO_FARMS][MAX_NARCO_FARMS_BOOTHS][] = {
    { // Наркоферма №1
        {-1107.7410, -1663.1608, 74.3949, -1103.1742, -1647.7817, 78.5569},
        {-1114.6763, -1663.3058, 74.4748, -1109.8945, -1646.6420, 78.8980},
        {-1121.5038, -1662.9558, 75.0180, -1116.8684, -1647.1353, 78.4247},
        {-1121.4910, -1683.6581, 75.2687, -1116.9408, -1667.8295, 78.5339}
    }
};

new Float: NarcoFarmBoothPositions[MAX_NARCO_FARMS][MAX_NARCO_FARMS_BOOTHS][] = {
    { // Наркоферма №1
       {-1104.5055, -1647.3693, 76.3672},
       {-1111.0792, -1647.4214, 76.3672},
       {-1117.9219, -1647.4465, 76.3672},
       {-1118.2892, -1667.9258, 76.3672}
    }
};

enum e_NarcoFarmInteractivePositions {
    NARCO_FARM_POSITION_PACK_TABLE, // Позиция упаковочного стола
    NARCO_FARM_POSITION_SEEDS, // Позиция взятия семян
    NARCO_FARM_POSITION_LEEK, // Позиция леек
    NARCO_FARM_POSITION_BASKET // Позиция корзинки
};

new Float: NarcoFarmInteractivePositions[MAX_NARCO_FARMS][][] = {
    { // Наркоферма №1
        {-1106.992431, -1640.950683, 76.655303},
        {-1109.263061, -1640.987304, 76.618377},
        {-1112.220092, -1642.684448, 76.916419},
        {-1105.031860, -1641.222656, 76.056030}
    }
};

enum e_NarcoFarmBushState
{
    NARCO_FARM_BUSH_STATE_NONE, // Ничего (требуется раскопать)
    NARCO_FARM_BUSH_STATE_EXCAVATED, // Раскопано (требуется полить перед посадкой)
    NARCO_FARM_BUSH_STATE_WATERED, // Полито (требуется посадить саженец)
    NARCO_FARM_BUSH_STATE_SEEDED, // Посажено (требуется полить)
    NARCO_FARM_BUSH_STATE_DEAD // Засохло
};

enum e_NarcoFarmBushInfo {
    dfbiOwner, // Владелец куста (ID аккаунта)
    dfbiRentTime, // Время аренды куста
    e_NarcoFarmBushState: dfbiState, // Состояние куста
    dfbiWaterTime, // Время полива куста
    dfbiWaterings, // Количество поливов
    dfbiCollect, // Собранное количество кокаина
    STREAMER_TAG_OBJECT: dfbiObject, // Объект куста
    STREAMER_TAG_3D_TEXT_LABEL: dfbiLabel // Лейбл куста
};
new NarcoFarmBushInfo[MAX_NARCO_FARMS][MAX_NARCO_FARMS_BOOTHS][MAX_NARCO_FARMS_BUSHES][e_NarcoFarmBushInfo];

enum e_NarcoFarmPlayerInfo {
    dfpiFarmID, // ID фермы
    dfpiBoothID, // ID будки
    dfpiBushID, // ID куста
    Float: dfpiPosition[3], // Сохраненная позиция игрока
    e_NarcoFarmBushState: dfpiBushState, // Сохраненное состояние куста
    Float: dfpiArea[6], // Область фермы
    bool: dfpiEditAreaMode, // Режим редактирования области
};
new NarcoFarmPlayerInfo[MAX_PLAYERS][e_NarcoFarmPlayerInfo];

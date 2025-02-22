/*
    Монеты континенталя

    Особая валюта для участников мафий для оплаты определённого списка услуг (будет дорабатываться)

    TODO:
    проверить начисление денег организации и игроку за действия (вычитание тоже)
    ...
*/

enum ContinentalCoinActions {
    CONTINENTAL_ACTION_SHIP_WIN, // Победа в порту
    CONTINENTAL_ACTION_SHOOT_WIN, // Победа в стреле
    CONTINENTAL_ACTION_SHIP_LOSE, // Проигрыш в порту
    CONTINENTAL_ACTION_SHOOT_LOSE // Проигрыш в стреле
};
new ContinentalCoinActionNames[_:ContinentalCoinActions][] = {
    "Победа в порту",
    "Победа в стреле",
    "Проигрыш в порту",
    "Проигрыш в стреле"
};

enum ContinentalCoinPlayerActions {
    CONTINENTAL_PLAYER_ACTION_SHOOT_WIN, // Победа в стреле
    CONTINENTAL_PLAYER_ACTION_SHIP_WIN // Победа в порту
};
new ContinentalCoinPlayerActionNames[_:ContinentalCoinPlayerActions][] = {
    "Победа в стреле",
    "Победа в порту"
};

enum e_ContinentalCoinInfo {
    // SQL only
    cciID,

    cciExchangeRate, // Курс обмена монеты на деньги
    cciRewards[_:ContinentalCoinActions] // Награды за действия
};
new ContinentalCoinInfo[e_ContinentalCoinInfo];
SQL_ENUM_DEFINE(ContinentalCoinInfo) {
    {"id", FIELD_TYPE_INT, 1, FIELD_COLUMN_PRIMARY_KEY | FIELD_COLUMN_NOT_NULL},
    {"exchange_rate", FIELD_TYPE_INT},
    {"reward_ship_win", FIELD_TYPE_INT},
    {"reward_shoot_win", FIELD_TYPE_INT},
    {"reward_ship_lose", FIELD_TYPE_INT},
    {"reward_shoot_lose", FIELD_TYPE_INT}
};

enum e_ContinentalCoinPlayerInfo {
    // SQL only
    ccpiUserID,

    ccpiLastUpdate, // Последнее обновление монет
    ccpiCoins[7] // Количество монет (по дням: 0 - понедельник / 6 - воскресенье)
};
new ContinentalCoinPlayerInfo[MAX_PLAYERS][e_ContinentalCoinPlayerInfo];
SQL_ENUM_DEFINE(ContinentalCoinPlayerInfo) {
    {"userid", FIELD_TYPE_INT, 1, FIELD_COLUMN_PRIMARY_KEY | FIELD_COLUMN_NOT_NULL},

    {"last_update", FIELD_TYPE_INT}, // Последнее обновление монет
    {"coins_0", FIELD_TYPE_INT}, // Понедельник
    {"coins_1", FIELD_TYPE_INT}, // Вторник
    {"coins_2", FIELD_TYPE_INT}, // Среда
    {"coins_3", FIELD_TYPE_INT}, // Четверг
    {"coins_4", FIELD_TYPE_INT}, // Пятница
    {"coins_5", FIELD_TYPE_INT}, // Суббота
    {"coins_6", FIELD_TYPE_INT} // Воскресенье
};


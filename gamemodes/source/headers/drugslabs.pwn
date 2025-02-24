#define MAX_NARCO_SPOTS                             20 // Максимальное количество точек
#define MAX_NARCO_PLACES                            20 // Максимальное количество рабочих мест в точке
#define MAX_NARCO_ACTORS                            20 // Максимальное количество актеров в точке

#define NARCO_SPOT_HANGOUT_VIRTUAL_WORLD            1500 // Виртуальный мир притона (+id)
#define NARCO_SPOT_LABORATORY_VIRTUAL_WORLD         2000 // Виртуальный мир лаборатории (+id)
#define NARCO_SPOT_INVALID_ID                       -1 // Неверный ID точки (места, ...)

#define HANGOUT_PRICE                               50000 // Стоимость аренды горшка в притоне
#define HANGOUT_WATER_TIME                          300 // Время до следующего полива горшка (в секундах)
#define HANGOUT_WATER_TIME_TEST                     30 // Время до следующего полива горшка для тестового сервера (в секундах)
#define HANGOUT_WATERINGS                           5 // Количество поливаний для созревания
#define HANGOUT_WATERINGS_TEST                      1 // Количество поливаний для созревания для тестового сервера
#define HANGOUT_PACK_POINTS                         50 // Количество поинтов для упаковки травы
#define HANGOUT_PACK_COOLDOWN                       2  // КД между нажатиями при упаковке травы (в секундах)
#define HANGOUT_WAIT_PLACE_TIME                     5 // Время до удаления аренды горшка при бездействии (в минутах)

#define LABORATORY_PRICE                            75000 // Стоимость аренды стола в лаборатории
#define LABORATORY_PLACES                           6 // Количество арендуемых мест в лаборатории
#define LABORATORY_INGREDIENT_TIME                  420 // Время до следующего добавления ингредиента (в секундах)
#define LABORATORY_INGREDIENT_TIME_TEST             60 // Время до следующего добавления ингредиента для тестового сервера (в секундах)
#define LABORATORY_GAME_TIME                        30 // Время мини-игры при варке (в секундах)
#define LABORATORY_GAME_PREPARE_TIME                2 // Время подготовки к мини-игре (в секундах)
#define LABORATORY_INGREDIENTS                      3 // Количество ингредиентов для добавления
#define LABORATORY_PACK_POINTS                      75 // Количество поинтов для упаковки порошка
#define LABORATORY_PACK_COOLDOWN                    2 // КД между нажатиями при упаковке порошка (в секундах)
#define LABORATORY_DUMMY_POWDER_TIME                120 // Время до добавления ингредиента в лаборатории, по истечении которого будет некачественный порошок (в секундах)
#define LABORATORY_WAIT_PLACE_TIME                  10 // Время до удаления аренды стола в лаборатории при бездействии (в минутах)

#define NARCO_MARKS_SIZE                            1.0 // Размеры GPS-меток внутри здания притона/лаборатории
#define NARCO_DISCONNECT_RENTTIME                   300 // Время до обнуления аренды при выходе из игры (в секундах)
#define NARCO_RENT_TIME                             60 // Время аренды места (в минутах)

#define NARCO_MAX_INGREDIENT_KITS                   1 // Максимальное количество наборов ингредиентов
#define NARCO_MAX_INGREDIENTS_PER_KIT               3 // Максимальное количество ингредиентов в наборе

new STREAMER_TAG_AREA: NarcoHangoutZone,
    STREAMER_TAG_AREA: NarcoLaboratoryZone;

enum e_NarcoSpotType {
    NARCO_SPOT_HANGOUT, // Притон
    NARCO_SPOT_LABORATORY // Лаборатория
};

enum e_NarcoPlaceInfo {
    // SQL only
    npdId,
    npdSpotId,

    npdPlayer, // ID аккаунта игрока
    npdRentTime, // Время окончания аренды
    bool: npdRiped, // Созрела ли трава
    bool: npdEarned, // Собрана ли трава
    bool: npdSoilPlaced, // Приготовлена ли почва
    bool: npdDummyPowder, // Порошок некачественный
    npdEarnedTimes, // Сколько раз собрана трава
    npdWaterTime, // Время следующего полива (или добавления ингредиента)
    npdWaterings, // Количество поливов (или добавлений ингредиента)
    npdPlayerExitTime, // Время выхода игрока
    npdIngredients[3], // Порядок ингредиентов
    STREAMER_TAG_3D_TEXT_LABEL: npdLabel // ID лейбла
};
new NarcoPlaceInfo[MAX_NARCO_SPOTS][MAX_NARCO_PLACES][e_NarcoPlaceInfo];
SQL_ENUM_DEFINE(NarcoPlaceInfo) {
    {"id", FIELD_TYPE_INT, 1, FIELD_COLUMN_UNIQUE_PAIR | FIELD_COLUMN_NOT_NULL},
    {"spot_id", FIELD_TYPE_INT, 1, FIELD_COLUMN_UNIQUE_PAIR | FIELD_COLUMN_NOT_NULL},
    {"user_id", FIELD_TYPE_INT},
    {"rent_time", FIELD_TYPE_INT},
    {"riped", FIELD_TYPE_BOOL},
    {"earned", FIELD_TYPE_BOOL},
    {"soil_placed", FIELD_TYPE_BOOL},
    {"dummy_powder", FIELD_TYPE_BOOL},
    {"earned_times", FIELD_TYPE_INT},
    {"water_time", FIELD_TYPE_INT},
    {"waterings", FIELD_TYPE_INT},
    {"player_exit_time", FIELD_TYPE_INT},
    {"", FIELD_TYPE_SKIP, 3},
    {"", FIELD_TYPE_SKIP}
};

new NarcoPlaceObjects[MAX_NARCO_SPOTS][MAX_NARCO_PLACES]; // Объекты горшков
new NarcoPlaceExplodeObjects[MAX_NARCO_SPOTS][MAX_NARCO_PLACES][2]; // Объекты взрыва

// Места с горшками в наркопритоне
new Float: NarcoHangoutPlacesMarks[][] = {
    {1004.0353, 234.2905, 152.5605},
    {1000.5511, 234.2749, 152.5605},
    {1003.7988, 233.4175, 152.5605}, 
    {1000.5397, 233.3538, 152.5605},
    {1003.8707, 232.4112, 152.5605},
    {1000.6071, 232.3572, 152.5605},
    {1003.8246, 231.4180, 152.5605},
    {1000.5889, 231.4353, 152.5605},
    {1003.7840, 230.5552, 152.5605},
    {1000.5814, 230.4736, 152.5605},
    {1003.9625, 226.2735, 152.5605},
    {1000.6864, 226.2433, 152.5605},
    {1004.0188, 225.3058, 152.5605},
    {1000.5723, 225.3079, 152.5605},
    {1003.9421, 224.3309, 152.5605},
    {1000.7021, 224.3205, 152.5605},
    {1003.8675, 223.4054, 152.5605},
    {1000.6667, 223.3351, 152.5605},
    {1003.9279, 222.4707, 152.5605},
    {1000.6113, 222.4377, 152.5605}
};

// Места у столов в лаборатории
new Float: NarcoLaboratoryPlacesMarks[][] = {
    {1000.5056, 231.9116, 152.5605},
    {1002.4041, 231.8891, 152.5605},
    {1004.2112, 231.7457, 152.5605},
    {1004.2935, 224.7775, 152.5605},
    {1002.4105, 224.8860, 152.5605},
    {1000.4250, 224.9359, 152.5605}
};

enum e_NarcoSpotInfo {
    e_NarcoSpotType: nstType, // Тип точки (Притон/Лаборатория)
    Float: nstPosition[3], // Позиция двери
    Float: nstAngle[3], // Поворот двери
    nstFraction, // ID контролирующей организации
    STREAMER_TAG_OBJECT: nstEnterDoor, // Объект двери
    STREAMER_TAG_PICKUP: nstEnterPickup, STREAMER_TAG_3D_TEXT_LABEL: nstEnterLabel, // Пикап/лейблы входа
    STREAMER_TAG_MAP_ICON: nstMapIcon // Иконка на радаре
};
new NarcoSpotInfo[MAX_NARCO_SPOTS][e_NarcoSpotInfo];
SQL_ENUM_DEFINE(NarcoSpotInfo) {
    {"type", FIELD_TYPE_INT},
    {"x", FIELD_TYPE_FLOAT},
    {"y", FIELD_TYPE_FLOAT},
    {"z", FIELD_TYPE_FLOAT},
    {"rx", FIELD_TYPE_FLOAT},
    {"ry", FIELD_TYPE_FLOAT},
    {"rz", FIELD_TYPE_FLOAT},
    {"fraction", FIELD_TYPE_INT},
    {"", FIELD_TYPE_SKIP, 4}
};

enum e_NarcoSpotPlayerAction {
    NARCO_PLAYER_ACTION_NONE, // Не ожидается никакого действия
    NARCO_PLAYER_ACTION_SOIL, // Нужно положить землю в горшок
    NARCO_PLAYER_ACTION_TAKE_SEED, // Нужно взять семена со специального стола
    NARCO_PLAYER_ACTION_SEED, // Нужно положить семена в горшок
    NARCO_PLAYER_ACTION_MAKE // Нужно упаковать траву
};

enum e_NarcoSpotIngredient {
    NARCO_INGREDIENT_NONE, // Нет ингредиента
    NARCO_INGREDIENT_HYDROCHLORIC_ACID, // Соляная кислота
    NARCO_INGREDIENT_CAUSTIC_SODA, // Каустическая сода
    NARCO_INGREDIENT_HYDROGEN_CHLORIDE // Хлористый водород
};

enum e_NarcoSpotIngredientKits {
    nsikName[32], // Название набора
    e_NarcoSpotIngredient: nsikIngredients[NARCO_MAX_INGREDIENTS_PER_KIT], // Ингредиенты
    nsikIngredientsAmount[NARCO_MAX_INGREDIENTS_PER_KIT] // Количество ингредиентов
};
new NarcoSpotIngredientKits[NARCO_MAX_INGREDIENT_KITS][e_NarcoSpotIngredientKits] = {
    {"Синий порошок", {NARCO_INGREDIENT_HYDROCHLORIC_ACID, NARCO_INGREDIENT_CAUSTIC_SODA, NARCO_INGREDIENT_HYDROGEN_CHLORIDE}, {1, 1, 1}}
};

enum e_NarcoSpotPlayerInfo {
    nspID, // ID аккаунта игрока
    nspRentCooldown, // Следующее доступное время аренды горшка
    e_NarcoSpotPlayerAction: nspCurrentAction, // Текущее ожидаемое действие
    nspSpotId, // ID точки, в которой находится игрок
    nspPlaceId, // ID места для взаимодействия
    bool: nspHangOutCutScene, // Смотрел ли катсцену наркопритона
    bool: nspLaboratoryCutScene, // Смотрел ли катсцену лаборатории
    nspPumpCooldown, // Время последнего нажатия при упаковке
    e_NarcoSpotIngredient: nspIngredient, // Выбранный ингредиент
    Float: nspInfectLevel, // Уровень заражения (для лаборатории)
    Float: nspLaboratoryGameHealth, // Поинты "здоровья" в мини-игре при варке
    nspLaboratoryGameStartTime, // Время начала мини-игры
    nspLaboratoryGameEndTime, // Время окончания мини-игры
    nspLaboratoryExitTime, // Время выхода из лаборатории
    bool: nspLaboratoryGameRules // Ознакамливался ли с правилами мини-игры
};
new NarcoSpotPlayerInfo[MAX_PLAYERS][e_NarcoSpotPlayerInfo];
SQL_ENUM_DEFINE(NarcoSpotPlayerInfo) {
    {"user_id", FIELD_TYPE_INT, 0, FIELD_COLUMN_PRIMARY_KEY | FIELD_COLUMN_NOT_NULL},
    {"rent_cooldown", FIELD_TYPE_INT},
    {"current_action", FIELD_TYPE_SKIP},
    {"spot_id", FIELD_TYPE_INT},
    {"place_id", FIELD_TYPE_INT},
    {"hangout_cutscene", FIELD_TYPE_BOOL},
    {"laboratory_cutscene", FIELD_TYPE_BOOL},
    {"", FIELD_TYPE_SKIP, 8}
};

new NarcoSpotActors[MAX_NARCO_SPOTS][MAX_NARCO_ACTORS]; // Актеры в точках

new PlayerText:LaboratoryInfect_PTD[MAX_PLAYERS][3];
new PlayerText:LaboratoryGame_PTD[MAX_PLAYERS][11];

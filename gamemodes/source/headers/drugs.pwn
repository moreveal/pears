enum e_DrugsType {
    DRUGS_TYPE_WEED, // Трава
    DRUGS_TYPE_COCAINE, // Порошок
    DRUGS_TYPE_BLUE_COCAINE, // Синий порошок
    DRUGS_TYPE_DUMMY_BLUE_COCAINE, // Некачественный синий порошок
    DRUGS_TYPE_ECSTASY, // Таблетки
    DRUGS_TYPE_MUSHROOMS // Грибы
};

// [!] Порошки наделяют порошкозависимостью и эффектом, искать по: "infect(playerid, 9, 1);" в health.pwn
enum e_DrugsInfo {
    diItem, // ID предмета в инвентаре
    diCooldown, // Интервал между приемом
    diEffect, // ID эффекта
    diEffectTime, // Время эффекта
    Float: diHeal // Количество лечения (0 - ручное лечение, например HealthPlayer)
};
new DrugsInfo[e_DrugsType][e_DrugsInfo] = {
    {4, 5, 0, 30, 30.0}, // Трава
    {7, 3, 0, 0, 80.0}, // Порошок (КД только на капте)
    {263, 6, 0, 0, 65.0}, // Синий порошок (КД только на капте)
    {264, 7, 0, 0, 40.0}, // Некачественный синий порошок (КД только на капте)
    {265, 10, 0, 0, 5.0}, // Таблетки
    {6, 12, 3, 60, 10.0} // Грибы
};
new DrugsCooldown[MAX_REALPLAYERS];

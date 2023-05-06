#define random_range(%0,%1) random(%1-%0+1) + %0 // Random для диапазона [x; y]
#define NON_DAMAGE_TEAM 1 // Команда для отмены стандартного урона

// Узнает является ли оружие огнестрельным
stock IsShootingWeapon(weaponid)
{
    switch (weaponid)
    {
        case 22..36, 38: return 1;
    }
    return 0;
}

// Получает урон, наносимый оружием, а также наносимое бронежилету повреждение
// Бронежилет работает только на огнестрельное оружие**
stock GetPlayerDamageByWeaponId(playerid, damagedid, weaponid, bodypart, &Float: damage, &Float: armour_breaking)
{
    if (GetVehicleModel(GetPlayerVehicleID(damagedid)) == 432) return 0; // Если игрок находится в танке - отмена урона
    if (GetPlayerState(playerid) == PLAYER_STATE_WASTED) return 0; // Если урон наносит мертвый игрок - отмена урона
    if (GetPVarInt(damagedid, "afksystem") >= 10) return 0; // Если игрок, по которому наносят урон, в AFK не менее 10 секунд - отмена урона
    if (Iamzz[damagedid])  return 0; // Если игрок, по которому наносят урон, в зелёной зоне - отмена урона
    if (weaponid < 0) weaponid = GetPlayerWeapon(playerid);

    // Обработка урона с оружий по Weapon ID
    static const weapons_damage[][] = {
        // Weapon ID -> Мин. дамаг -> Макс. дамаг -> Мин. дамаг в голову -> Макс. дамаг в голову
        {0, 1, 3}, // Fist
        {WEAPON_NITESTICK, 5, 10, 5, 10},
        {WEAPON_KNIFE, 15, 20, 15, 20},
        {WEAPON_BAT, 10, 15, 10, 15},
        {WEAPON_KATANA, 20, 30, 100, 100},
        {WEAPON_MOLTOV, 1, 1, 1, 1},
        {WEAPON_COLT45, 8, 14, 15, 17},
        {WEAPON_TEC9, 5, 12, 13, 16},
        {WEAPON_DEAGLE, 20, 32, 33, 49},
        {WEAPON_UZI, 9, 12, 13, 15},
        {WEAPON_MP5, 9, 13, 14, 17},
        {WEAPON_M4, 10, 18, 19, 23},
        {WEAPON_AK47, 11, 21, 22, 26},
        {WEAPON_SHOTGUN, 20, 35, 26, 37},
        {WEAPON_SHOTGSPA, 8, 18, 20, 23},
        {WEAPON_RIFLE, 20, 35, 36, 39},
        {WEAPON_SNIPER, 75, 80, 360, 360},
        {WEAPON_BRASSKNUCKLE, 10, 25},
        {WEAPON_GOLFCLUB, 5, 10},
        {WEAPON_SHOVEL, 8, 15},
        {WEAPON_POOLSTICK, 8, 15},
        {WEAPON_CHAINSAW, 8, 20},
        {WEAPON_DILDO, 3, 7},
        {WEAPON_DILDO2, 3, 7},
        {WEAPON_VIBRATOR, 3, 7},
        {WEAPON_VIBRATOR2, 3, 7},
        {WEAPON_CANE, 3, 7},
        {WEAPON_GRENADE, 50, 60},
        {WEAPON_TEARGAS, 0, 0},

        {35, 360, 360}, // Очень близкий взрыв
        {36, 50, 80} // Дальний взрыв
    };

    // Обработка поглощения урона бронежилетом по Weapon ID
    static const weapons_suppression[1][][] = {
        {
            // Weapon ID, Мин. процент подавления -> Макс. процент подавления
            {WEAPON_NITESTICK, 65, 70},
            {WEAPON_KNIFE, 65, 70},
            {WEAPON_BAT, 65, 70},
            {WEAPON_KATANA, 65, 68},
            {WEAPON_GRENADE, 30, 50},
            {WEAPON_CAMERA, 100, 100},
            {WEAPON_COLT45, 35, 49},
            {WEAPON_TEC9, 35, 49},
            {WEAPON_DEAGLE, 35, 49},
            {WEAPON_UZI, 30, 45},
            {WEAPON_MP5, 30, 45},
            {WEAPON_M4, 25, 40},
            {WEAPON_AK47, 25, 40},
            {WEAPON_SHOTGUN, 30, 50},
            {WEAPON_SHOTGSPA, 30, 50},
            {WEAPON_RIFLE, 25, 40},
            {WEAPON_SNIPER, 20, 30}
        }
    };

    new bool: isHead = bodypart == 9, armour_action;
    for (new i = 0; i < sizeof weapons_damage; i++)
    {
        if (floatround(weapons_damage[i][0]) == weaponid) {
            if (isHead) { // Урон в голову
                damage = random_range(weapons_damage[i][3], weapons_damage[i][4]);
            } else { // Урон в любую другую часть тела
                new Float: armour;
                ACGetPlayerArmour(damagedid, armour);
                if (armour > 0.0) { // Есть ли у потерпевшего бронежилет
                    static const armour_type = 0; // [ Временно тип армора статичный, в будущем можно добавить несколько ]
                    if (bodypart == 3) { // Если попадание было в торс - поглощаем урон
                        for (new s = 0; s < sizeof weapons_suppression[]; s++) {
                            if (weapons_suppression[armour_type][s][0] == weaponid) {
                                // Количество поглощаемого урона от оружия, задается в процентах
                                armour_action = random_range(weapons_suppression[armour_type][s][1], weapons_suppression[armour_type][s][2]);

                                // Степень урона бронежилета (например, 35% от поглощенного урона), задается в процентах
                                armour_breaking = armour_action * 0.35;

                                break;
                            }
                        }
                    }
                }
                damage = random_range(weapons_damage[i][1], weapons_damage[i][2]);
            }
            // new string[144];
            // format(string, sizeof string, "Игрок %s[%d] нанес %0.2f урона игроку %s[%d]", playerInfo[playerid][pName], playerid, damage, playerInfo[damagedid][pName], damagedid);
            // SendClientMessageToAll(COLOR_GRAY, string);
            if (armour_action > 0) { // Если бронежилет есть, и он подействовал на наносимый урон
                // format(string, sizeof string, "Бронежилет игрока %s[%d] сократил получаемый урон на %d процентов | Новый урон: %0.2f", playerInfo[damagedid][pName], damagedid, armour_action, damage - (damage / 100 * armour_action));
                // SendClientMessageToAll(COLOR_GRAY, string);
                damage = damage - (damage / 100 * armour_action); // Отправляем нужный урон, вычитая необходимый процент, поглощаемый бронежилетом
            }
            if(IsAZoneCapt(playerid) && IsAZoneCapt(damagedid)) CaptTakeHealth(playerid, damagedid, damage);
            return 1;
        }
    }

    damage = 0; // Отмена урона, если все проверки выше не сработали :/
    return 0;
}

forward PlayerGiveDamageHandler(playerid, damagedid, Float: amount, weaponid, bodypart);
public PlayerGiveDamageHandler(playerid, damagedid, Float: amount, weaponid, bodypart)
{
    SetPlayerTeam(playerid, NON_DAMAGE_TEAM);
    SetPlayerTeam(damagedid, NON_DAMAGE_TEAM);
    // Убийство с ножа
    if (weaponid == WEAPON_KNIFE && amount == 0.0 && bodypart == 3) return SetTimerEx("SetPlayerHealthTimer", 3000, 0, "df", damagedid, 0.0);
    // Обработка удара прикладом
    if (IsShootingWeapon(GetPlayerWeapon(playerid)) && amount == 2.6400001049042) {
        new Float: health;
        ACGetPlayerHealth(damagedid, health);
        return SetPlayerHealth(damagedid, health - random_range(1, 5));
    }
    if (damagedid != INVALID_PLAYER_ID) { // Если урон был нанесен какому-либо игроку
        new handler_weapon = weaponid;
        switch (weaponid)
        {
            case 37: handler_weapon = 18; // Определять все огненное оружие как молотов
            case 51: handler_weapon = amount >= 80.0 ? 35 : 36; // Взрывающееся оружие (35 обрабатывается как близкий взрыв, 36 - дальний)
        }
        new Float: damage, Float: armour_breaking;
        GetPlayerDamageByWeaponId(playerid, damagedid, handler_weapon, bodypart, damage, armour_breaking);
        TakePlayerHealth(damagedid, damage);

        new Float: armour;
        ACGetPlayerArmour(damagedid, armour);
        if (armour > 0.0) {
            // Забираем броню
            TakePlayerArmour(damagedid, armour_breaking);
            // Если броня закончилась
            ACGetPlayerArmour(damagedid, armour);
            if (armour <= 0.0) {
                // [ Удаляем аттач брони, если он есть ]
                // [ Удаляем броню из инвентаря ]
            }
        }
    }
    SetTimerEx("ResetTeams", 100, 0, "dd", playerid, damagedid);
    return 1;
}

// Забирает у игрока указанное количество HP
stock TakePlayerHealth(playerid, Float: amount)
{
	if (amount < 0) return 0;
	new Float: health,
		Float: remains;
	ACGetPlayerHealth(playerid, health);
	remains = health - amount;
	return ACSetPlayerHealth(playerid, remains < 0 ? 0.0 : remains);
}

// Забирает у игрока указанное количество брони
stock TakePlayerArmour(playerid, Float: amount)
{
	if (amount < 0) return 0;
	new Float: armour,
		Float: remains;
	ACGetPlayerArmour(playerid, armour);
	remains = armour - amount;
    armour = remains < 0 ? 0.0 : remains;
    // [ Сюда нужно будет добавить систему сохранения армора у игрока, адаптировав под пирс ]
	return ACSetPlayerArmour(playerid, armour);
}

// Отложенное присвоение урона (для использования в таймере)
forward SetPlayerHealthTimer(playerid, Float: health);
public SetPlayerHealthTimer(playerid, Float: health) return ACSetPlayerHealth(playerid, health);

// Сбрасывает команды игрокам
forward ResetTeams(firstid, secondid);
public ResetTeams(firstid, secondid)
{
    SetPlayerTeam(firstid, NO_TEAM);
    SetPlayerTeam(secondid, NO_TEAM);
    return 1;
}
#define random_range(%0,%1) random(%1-%0+1) + %0 // Random для диапазона [x; y]
#define NON_DAMAGE_TEAM 1 // Тима для отмены стандартного урона
#define max(%0,%1) (%0 > %1 ? %0 : %1) // Получает максимальное значение среди двух переданных

#if !defined BODY_PART_TORSO
enum {
	BODY_PART_TORSO = 3,
	BODY_PART_GROIN,
	BODY_PART_LEFT_ARM,
	BODY_PART_RIGHT_ARM,
	BODY_PART_LEFT_LEG,
	BODY_PART_RIGHT_LEG,
	BODY_PART_HEAD
};
#endif

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
    if (VehInfo[GetPlayerVehicleID(damagedid)][vModel] == 432) return 0; // Если игрок находится в танке - отмена урона
    if (VehInfo[GetPlayerVehicleID(damagedid)][vModel] == 537) return 0; // Если игрок находится в поезде - отмена урона
    if (GetPlayerState(playerid) == PLAYER_STATE_WASTED) return 0; // Если урон наносит мертвый игрок - отмена урона
    if (GetPVarInt(damagedid, "afksystem") >= 5) return 0; // Если игрок, по которому наносят урон, в AFK не менее 5 секунд - отмена урона
	if (Iamzz[damagedid]) return 0;// Если игрок, по которому наносят урон, в зелёной зоне - отмена урона [вернуть]

    // Характеристики оружия по WeaponID
	enum e_WeaponProperties {
		wpID, // ID оружия
		wpDistance[2], // Фиксированная [при которой урон не изменяется] и максимальная дистанция [при которой урон не идет вообще]
		wpBodyDamage[2], // Минимальный и максимальный урон [Все части тела кроме головы]
		wpHeadDamage[2], // Минимальный и максимальный урон [Голова]
	};
	static const weaponProperties[][e_WeaponProperties] = {
		// слот кулака
		{0, {30, 30}, {1, 3} },
		{WEAPON_BRASSKNUCKLE, {30, 30}, {10, 25} },
        {WEAPON_GOLFCLUB, {30, 30}, {5, 10} },
        {WEAPON_SHOVEL, {30, 30}, {8, 15} },
        {WEAPON_POOLSTICK, {30, 30}, {8, 15} },
        {WEAPON_CHAINSAW, {30, 30}, {8, 20} },
        {WEAPON_DILDO, {30, 30}, {3, 7} },
        {WEAPON_DILDO2, {30, 30}, {3, 7} },
        {WEAPON_VIBRATOR, {30, 30}, {3, 7} },
        {WEAPON_VIBRATOR2, {30, 30}, {3, 7} },
        {WEAPON_CANE, {30, 30}, {3, 7} },
        {WEAPON_NITESTICK, {30, 30}, {5, 10} },
        {WEAPON_KNIFE, {30, 30}, {15, 20} },
        {WEAPON_BAT, {30, 30}, {10, 15} },
        {WEAPON_KATANA, {30, 30}, {20, 30}, {100, 100} },
		// огнестрел
		{WEAPON_COLT45, {10, 30}, {7, 15}, {17, 35} },
		{WEAPON_SILENCED, {10, 30}, {6, 13}, {19, 26} },
		{WEAPON_DEAGLE, {13, 30}, {30, 46}, {46, 63} },
		{WEAPON_SHOTGUN, {5, 40}, {7, 50}, {44, 58} },
		{WEAPON_SAWEDOFF, {5, 35}, {5, 29}, {30, 37} },
        {WEAPON_SHOTGSPA, {5, 40}, {6, 37}, {38, 45} },
        {WEAPON_TEC9, {35, 105}, {2, 3}, {2, 4} },
		{WEAPON_UZI, {10, 30}, {2, 3}, {2, 4} },
        {WEAPON_MP5, {10, 30}, {8, 8}, {9, 12} },
		{WEAPON_AK47, {30, 70}, {10, 12}, {12, 16} },
        {WEAPON_M4, {30, 90}, {9, 11}, {11, 14} },
        {WEAPON_RIFLE, {100, 100}, {20, 35}, {40, 50} },
        {WEAPON_SNIPER, {300, 300}, {75, 80}, {360, 360} },
		{WEAPON_MINIGUN, {100, 100}, {20, 20}, {20, 20} },
		// гранаты
		{WEAPON_GRENADE, {10, 50}, {50, 60} },
        {WEAPON_TEARGAS, {10, 50}, {0, 0} },
		// прочее
		{18, {30, 30}, {1, 1} }, // Любой огонь
        {35, {300, 300}, {360, 360}, {360, 360} }, // Очень близкий взрыв
        {36, {300, 300}, {50, 80}, {50, 80} } // Дальний взрыв
	};

	enum e_WeaponsSuppresion {
		wsID, // ID оружия
		wsDegree[2] // Минимальная и максимальная степени подавления
	};
	static const weaponsSuppresion[1][][e_WeaponsSuppresion] = {
		{
			{WEAPON_NITESTICK, {65, 70} },
            {WEAPON_KNIFE, {65, 70} },
            {WEAPON_BAT, {65, 70} },
            {WEAPON_KATANA, {65, 68} },
            {WEAPON_GRENADE, {30, 50} },
            {WEAPON_CAMERA, {100, 100} },
            {WEAPON_COLT45, {35, 49} },
            {WEAPON_TEC9, {35, 49} },
            {WEAPON_DEAGLE, {35, 49} },
            {WEAPON_UZI, {30, 45} },
            {WEAPON_MP5, {30, 45} },
            {WEAPON_M4, {25, 40} },
            {WEAPON_AK47, {25, 40} },
            {WEAPON_SHOTGUN, {30, 50} },
			{WEAPON_SAWEDOFF, {30, 50} },
            {WEAPON_SHOTGSPA, {30, 50} },
            {WEAPON_RIFLE, {25, 40} },
            {WEAPON_SNIPER, {20, 30} }
		}
	};

    new armour_action;
    for (new i = 0; i < sizeof weaponProperties; i++)
    {
        if (weaponProperties[i][wpID] == weaponid) {
			// Сокращение урона в зависимости от расстояния
			new Float: distance_coef = 1.0, Float: distance = 0.0;
			
			if (weaponid != WEAPON_SNIPER && weaponid != WEAPON_RIFLE) { // Если урон наносится НЕ из винтовки
				// Учитываем дистанцию при составлении урона
				new Float: target_pos[3]; GetPlayerPos(damagedid, target_pos[0], target_pos[1], target_pos[2]);
				distance = GetPlayerDistanceFromPoint(playerid, target_pos[0], target_pos[1], target_pos[2]);
				
				// Если дистанция между игроками больше, чем фиксированная (та, при которой влияния на урон быть не должно)
				if (distance > weaponProperties[i][wpDistance][0]) {
					// Расчёт коэффициента, на который будет снижаться урон
					distance_coef = max(1.0 - ( (distance - weaponProperties[i][wpDistance][0]) / (weaponProperties[i][wpDistance][1] - weaponProperties[i][wpDistance][0]) ), 0.0);
				}
			}
			// --------------------------------------------

            if (bodypart == BODY_PART_HEAD) { // Обработка урона в голову
				if (weaponProperties[i][wpHeadDamage])
					damage = random_range(weaponProperties[i][wpHeadDamage][0], weaponProperties[i][wpHeadDamage][1]);
            } else { // Обработка урона во всё остальное
                new Float: armour;
                ACGetPlayerArmour(damagedid, armour);
                if (armour > 0.0) { // Есть ли у потерпевшего бронежилет
                    static const armour_type = 0; // [ Временно тип армора статичный, в будущем можно добавить несколько ]
                    if (bodypart == 3) { // Если попадание было в торс - поглощаем урон
                        for (new s = 0; s < sizeof weaponsSuppresion[]; s++) {
                            if (weaponsSuppresion[armour_type][s][wsID] == weaponid) {
                                // Количество поглощаемого урона (N% от нанесенного урона)
                                armour_action = random_range(weaponsSuppresion[armour_type][s][wsDegree][0], weaponsSuppresion[armour_type][s][wsDegree][1]);
                                // Степень урона бронежилета (N% от поглощенного урона)
                                armour_breaking = armour_action * 0.40;

                                break;
                            }
                        }
                    }
                }
                damage = random_range(weaponProperties[i][wpBodyDamage][0], weaponProperties[i][wpBodyDamage][1]);

				// Уменьшение урона в два раза при попадании в ноги/руки
				if (bodypart > 4) damage *= 0.5;
            }
			damage *= distance_coef; // Учитывание коэффициента дистанции
            if(Effect[damagedid] == 6)
            {
                damage *= 0.90;
            }
            if(Effect[playerid] == 7)
            {
                damage *= 1.10;
            }
            new string[144];
            format(string, sizeof string, "Игрок %s[%d] нанес %0.2f урона игроку %s[%d]", PlayerInfo[playerid][pName], playerid, damage, PlayerInfo[damagedid][pName], damagedid);
			SendClientMessageToAll(COLOR_GREY, string);
			if (distance_coef < 1.0) {
				format(string, sizeof string, "Урон был скорректирован с учетом дистанции: [%0.2f -> %0.2f] (%0.3f метров)", 
					damage + (damage * (1.0 - distance_coef)),
					damage,
					distance
				);
				SendClientMessageToAll(COLOR_GREY, string);
			}
            if (armour_action > 0) { // Если бронежилет есть, и он подействовал на наносимый урон
                format(string, sizeof string, "Бронежилет игрока %s[%d] сократил получаемый урон на %d процентов | Новый урон: %0.2f", PlayerInfo[damagedid][pName], damagedid, armour_action, damage - (damage / 100 * armour_action));
                SendClientMessageToAll(COLOR_GREY, string);
                damage = damage - (damage / 100 * armour_action); // Применяем изменения к урону, вычитая необходимый процент, поглощаемый бронежилетом
            }

			if(IsAZoneCapt(playerid) && IsAZoneCapt(damagedid))
            {
                 CaptTakeHealth(playerid, damagedid, damage);
            }
            return 1;
        }
    }
    return 0;
}

forward PlayerGiveDamageHandler(playerid, damagedid, Float: amount, weaponid, bodypart);
public PlayerGiveDamageHandler(playerid, damagedid, Float: amount, weaponid, bodypart)
{
    // Убийство с ножа
    if (weaponid == WEAPON_KNIFE && amount == 0.0 && bodypart == 3) return SetTimerEx("SetPlayerHealthTimer", 3000, 0, "df", damagedid, 0.0);
    // Обработка удара прикладом
    if (IsShootingWeapon(GetPlayerWeapon(playerid)) && amount == 2.6400001049042) {
        new Float: health;
        ACGetPlayerHealth(damagedid, health);
        return ACSetPlayerHealth(damagedid, health - random_range(1, 5));
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

        // Прерываем намаз
        if(Namaz[playerid] >= 0) NamazEnd(playerid, 2);
    }
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
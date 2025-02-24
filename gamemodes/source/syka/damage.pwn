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
        case 22..36, 38, 43: return 1;
    }
    return 0;
}

stock IsWeaponUsableInVehicle(weaponid)
{
    static const weapons[] = {WEAPON_COLT45, WEAPON_UZI, WEAPON_MP5, WEAPON_AK47, WEAPON_M4, WEAPON_TEC9};

    for (new i = 0; i < sizeof(weapons); i++)
        if (weaponid == weapons[i]) return 1;

    return 0;
}

// Урон оружия по умолчанию. Связано с s_DamageType.
// Оружие ближнего боя имеет множители, так как урон различается в зависимости от типа удара и стиля боя.
static Float: s_WeaponDamage[] = {
  1.0, // 0 - Fist
  1.0, // 1 - Brass knuckles
  1.0, // 2 - Golf club
  1.0, // 3 - Nitestick
  1.0, // 4 - Knife
  1.0, // 5 - Bat
  1.0, // 6 - Shovel
  1.0, // 7 - Pool cue
  1.0, // 8 - Katana
  1.0, // 9 - Chainsaw
  1.0, // 10 - Dildo
  1.0, // 11 - Dildo 2
  1.0, // 12 - Vibrator
  1.0, // 13 - Vibrator 2
  1.0, // 14 - Flowers
  1.0, // 15 - Cane
  82.5, // 16 - Grenade
  0.0, // 17 - Teargas
  1.0, // 18 - Molotov
  9.9, // 19 - Vehicle M4 (custom)
  46.2, // 20 - Vehicle minigun (custom)
  82.5, // 21 - Vehicle rocket (custom)
  8.25, // 22 - Colt 45
  13.2, // 23 - Silenced
  46.2, // 24 - Deagle
  3.3, // 25 - Shotgun
  3.3, // 26 - Sawed-off
  4.95, // 27 - Spas
  6.6, // 28 - UZI
  8.25, // 29 - MP5
  9.9, // 30 - AK47
  9.9, // 31 - M4
  6.6, // 32 - Tec9
  24.75, // 33 - Cuntgun
  41.25, // 34 - Sniper
  82.5, // 35 - Rocket launcher
  82.5, // 36 - Heatseeker
  1.0, // 37 - Flamethrower
  46.2, // 38 - Minigun
  82.5, // 39 - Satchel
  0.0, // 40 - Detonator
  0.33, // 41 - Spraycan
  0.33, // 42 - Fire extinguisher
  0.0, // 43 - Camera
  0.0, // 44 - Night vision
  0.0, // 45 - Infrared
  0.0, // 46 - Parachute
  0.0, // 47 - Fake pistol
  2.64, // 48 - Pistol whip (custom)
  9.9, // 49 - Vehicle
  330.0, // 50 - Helicopter blades
  82.5, // 51 - Explosion
  1.0, // 52 - Car park (custom)
  1.0, // 53 - Drowning
  165.0  // 54 - Splat
};

new TickDamagePlayer[MAX_REALPLAYERS]; // Записываем для интервалов между дамагами
new BulletDamagePlayer[MAX_REALPLAYERS] = { -1, ... }; // Игрок совершил выстрел в bullet sync

// Получает урон, наносимый оружием, а также наносимое бронежилету повреждение
// Бронежилет работает только на огнестрельное оружие**
stock GetPlayerDamageByWeaponId(playerid, damagedid, WEAPON: weaponid, bodypart, &Float: damage, &Float: armour_breaking)
{
    if (VehInfo[GetPlayerVehicleID(damagedid)][vModel] == 432  // Если игрок находится в танке
        || VehInfo[GetPlayerVehicleID(damagedid)][vModel] == 537  // Если игрок находится в поезде
        || GetPlayerState(playerid) == PLAYER_STATE_WASTED // Если урон наносит мертвый игрок
        || GetPVarInt(damagedid, "afksystem") >= 5 // Если игрок, по которому наносят урон, в AFK не менее 5 секунд
        || Iamzz[damagedid] // Если игрок, по которому наносят урон, в зелёной зоне
        || IsPlayerInVehicle(damagedid, prisonbus_LS) || IsPlayerInVehicle(damagedid, prisonbus_SF) // Если игрок в тюремном автобусе
        || weaponid == WEAPON_SILENCED // Это будет всегда электрошокер
        || HealthAC[damagedid] <= 0.0 // Хп уже на нуле
        || HealthAC[playerid] <= 0.0 // Урон наносит игрок с нулевым хп
        || Stun[3][playerid] >= 1 // Урон наносит оглушенный игрок
        || Stun[4][playerid] == 1 // Урон наносит игрок в наручниках
        || Stun[5][playerid] == 1 // Урон наносит игрок в смирительной рубашке
        || DeathInfo[playerid][deathStatus] == true // Урон наносит игрок в стадии смерти
    ) return 0;

    if(GameInfo[gamDamage] && MPGO[playerid]) // Ванильный урон для МП
    {
        if(weaponid <= WEAPON:54) damage = s_WeaponDamage[weaponid];
        return 1;
    }

    // Ящеры (Отключение кастомного дамага)
    if(IsAGangCapt(playerid) && IsAGangCapt(damagedid))
    {
        new g = fraction(playerid), yg = fraction(damagedid);
        if(Kapt[g] > 0 && Kapt[yg] > 0 // Капт у обоих
            && GoDamage[g] && GoDamage[yg]) // Включен обычный дамаг
        {
            if(weaponid <= WEAPON:54) damage = s_WeaponDamage[weaponid];
            return 1;
        }
    }

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
		{WEAPON_COLT45, {20, 60}, {7, 15}, {17, 35} },
		{WEAPON_SILENCED, {20, 60}, {6, 13}, {19, 26} },
		{WEAPON_DEAGLE, {30, 60}, {30, 46}, {46, 63} },
		{WEAPON_SHOTGUN, {10, 80}, {7, 50}, {44, 58} },
		{WEAPON_SAWEDOFF, {10, 70}, {5, 29}, {30, 37} },
        {WEAPON_SHOTGSPA, {10, 80}, {6, 37}, {38, 45} },
        {WEAPON_TEC9, {20, 60}, {5, 8}, {10, 12} },
		{WEAPON_UZI, {20, 60}, {5, 8}, {10, 12} },
        {WEAPON_MP5, {20, 60}, {8, 10}, {12, 14} },
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
        if (WEAPON:weaponProperties[i][wpID] == weaponid) {
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
                            if (WEAPON:weaponsSuppresion[armour_type][s][wsID] == weaponid) {
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
				if (bodypart > 4) damage /= 2;
            }
			damage *= distance_coef; // Учитывание коэффициента дистанции

            //new string[40];
            /*format(string, sizeof string, "Игрок %s[%d] нанес %0.2f урона игроку %s[%d]", PlayerInfo[playerid][pName], playerid, damage, PlayerInfo[damagedid][pName], damagedid);
			SendClientMessageToAll(COLOR_GREY, string);
			if (distance_coef < 1.0) {
				format(string, sizeof string, "Урон был скорректирован с учетом дистанции: [%0.2f -> %0.2f] (%0.3f метров)", 
					damage + (damage * (1.0 - distance_coef)),
					damage,
					distance
				);
				SendClientMessageToAll(COLOR_GREY, string);
			}*/
            if (armour_action > 0) { // Если бронежилет есть, и он подействовал на наносимый урон
                //format(string, sizeof string, "Бронежилет игрока %s[%d] сократил получаемый урон на %d процентов | Новый урон: %0.2f", PlayerInfo[damagedid][pName], damagedid, armour_action, damage - (damage / 100 * armour_action));
                //SendClientMessageToAll(COLOR_GREY, string);
                damage -= (damage / 100 * armour_action); // Применяем изменения к урону, вычитая необходимый процент, поглощаемый бронежилетом
            }
        
            if(DeathInfo[damagedid][deathStatus]) // Если игрок мертвый на земле (в стадии)
            {
                damage /= 2; // Снимаем хп в 2 раза медленнее при добивании
            }

            // Скилл силы для ближнего боя
            if((weaponid == WEAPON:0 || weaponid == WEAPON:1) && box[playerid] == 0 && ProxDetectorS(3.0, playerid, damagedid)) 
            {
                damage += get_power(playerid);
            }

            return 1;
        }
    }
    return 0;
}

static s_MaxWeaponShootRate[] = 
{
    230, // 0 - Fist
    230, // 1 - Brass knuckles
    230, // 2 - Golf club
    230, // 3 - Nitestick
    230, // 4 - Knife
    230, // 5 - Bat
    230, // 6 - Shovel
    230, // 7 - Pool cue
    230, // 8 - Katana
    30, // 9 - Chainsaw
    230, // 10 - Dildo
    230, // 11 - Dildo 2
    230, // 12 - Vibrator
    230, // 13 - Vibrator 2
    230, // 14 - Flowers
    230, // 15 - Cane
    0, // 16 - Grenade
    0, // 17 - Teargas
    0, // 18 - Molotov
    90, // 19 - Vehicle M4 (custom)
    20, // 20 - Vehicle minigun (custom)
    0, // 21 - Vehicle rocket (custom)
    140, // 22 - Colt 45
    100, // 23 - Silenced
    100, // 24 - Deagle
    700, // 25 - Shotgun
    100, // 26 - Sawed-off
    100, // 27 - Spas
    50, // 28 - UZI
    70, // 29 - MP5
    70, // 30 - AK47
    70, // 31 - M4
    60, // 32 - Tec9
    700, // 33 - Cuntgun
    800, // 34 - Sniper
    700, // 35 - Rocket launcher
    700, // 36 - Heatseeker
    20, // 37 - Flamethrower
    10, // 38 - Minigun
    0, // 39 - Satchel
    0, // 40 - Detonator
    10, // 41 - Spraycan
    10, // 42 - Fire extinguisher
    0, // 43 - Camera
    0, // 44 - Night vision
    0, // 45 - Infrared
    0, // 46 - Parachute
    0, // 47 - Fake pistol
    400 // 48 - Pistol whip (custom)
};

function PlayerGiveDamageHandler(playerid, damagedid, Float: amount, weaponid, bodypart)
{
    // Кикаем падлюку, если при нанесении дамага его тима странная
    if(GetPlayerTeam(playerid) != DEFAULT_PLAYER_TEAM)
    {
        SendClientMessage(playerid, COLOR_LIGHTRED, "* {0066ff}Protect Project: {FF6347}Вы были кикнуты по подозрению в читерстве [PlayerDamage].");
        ShowDialog(playerid, 1996, DIALOG_STYLE_MSGBOX, "{ff0000}****  {FFFFFF}*[Protect Project]*  {ff0000}****","{ff0000}******** {ffffff}Вы были кикнуты по подозрению в читерстве [PlayerDamage] {ff0000}********", "*", "");
        Kickx(playerid);
        return false;
    }

    // Игрок, который наносит урон, не авторизован
    if (!IsOnline(playerid)) return Kickx(playerid);
    // Игрок, по которому наносят урон, не авторизован
    if (!IsOnline(damagedid)) return false;

    // Игрок, которому наносим урон, AFK
    if(IsPlayerAfk(damagedid)) return false;

    // Блокируем урон по NPC
    if(IsPlayerNPC(damagedid)) return false;

    // Защита от дамага с выстреливающего оружия без отправки пули
    if(IsShootingWeapon(weaponid) && BulletDamagePlayer[playerid] != weaponid) return false;
    BulletDamagePlayer[playerid] = -1;

    // Простейший блок урона от читера
    new slot = Protect_Slot(weaponid);
    if(slot > 0)
    {
        if(ProtectInfo[playerid][prWeapon][slot] != weaponid || ProtectInfo[playerid][prAmmo][slot] <= 0) return false;
    }

    // Урон по союзникам на МП
    if(MPGO[playerid] != 0 && MPGO[damagedid] != 0 && !GameInfo[gamTeamKill] && Pognalinamp && (MPSpawn[playerid] == MPSpawn[damagedid])) return false;

    // Игроки участвуют в Zombie Game
    if(IsPlayerZombieGame(playerid, damagedid)) return false;

    // Защита для новичков
    if(BeginnerDamage(playerid, damagedid)) return false;

    // Блочим дамаг если игроки в одной тиме в комп клубе
    if(ComputerClubIsTeammates(playerid, damagedid)) return false;

    // Блочим урон во время подготовки к битве за наркоферму на её территории
    new farmid = NarcoFarmGetNearest(damagedid);
    if (NarcoFarmGetNearest(damagedid))
    {
        if(NarcoFarmIsPrepareBattleActive(farmid)) return false;
    }
    // Блочим дамаг если игроки в одной команде в шахте / гробнице
    if (MineWar_IsTeammates(playerid, damagedid) || Tomb_IsTeammates(playerid, damagedid)) return false;

    // Защита от дамага без интервалов
    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, TickDamagePlayer[playerid]);
    if(weaponid == _:WEAPON_DEAGLE)
    {
        new g = fraction(playerid);
        if(ChutC[g] != 0 || GoC[g] != 0
            || ComputerClubIsPlayerCbugActive(playerid) 
            || MPGO[playerid] > 0) // +C Доступен
        {
            if(interval < 20) return false;
        }
        else 
        {
            if(interval < s_MaxWeaponShootRate[weaponid]) return false;
        }
    }
    else if(weaponid <= sizeof(s_MaxWeaponShootRate))
    {
        if(interval < s_MaxWeaponShootRate[weaponid]) return false;
    }
    TickDamagePlayer[playerid] = current_tick;

    // Убийство с ножа
    if (weaponid == _:WEAPON_KNIFE && amount == 0.0 && bodypart == 3) return SetTimerEx("SetPlayerHealthTimer", 3000, false, "df", damagedid, 0.0);
    // Обработка удара прикладом
    if (IsShootingWeapon(GetPlayerWeapon(playerid)) && amount == 2.6400001049042) {
        new Float: health;
        ACGetPlayerHealth(damagedid, health);
        return ACSetPlayerHealth(damagedid, health - random_range(1, 5));
    }
    if (damagedid != INVALID_PLAYER_ID) // Если урон был нанесен какому-либо игроку
    {
        new handler_weapon = weaponid;
        switch (weaponid)
        {
            case 37: handler_weapon = WEAPON_MOLOTOV; // Определять все огненное оружие как молотов
            case 51: handler_weapon = amount >= 80.0 ? WEAPON_ROCKETLAUNCHER : WEAPON_HEATSEEKER; // Взрывающееся оружие (35 обрабатывается как близкий взрыв, 36 - дальний)
        }
        new Float: damage, Float: armour_breaking;
        GetPlayerDamageByWeaponId(playerid, damagedid, WEAPON:handler_weapon, bodypart, damage, armour_breaking);

        if(damage > 0) // Если дамаг вообще нанесли
        {
            new resultDeath = TakePlayerHealth(damagedid, damage);

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
            new string[20];
            format(string, sizeof string, "-%.1f HP", damage);
            SetPlayerChatBubble(damagedid, string, COLOR_RED, 45.0, 4000);

            // Дамаг информер (звук попадания)
            if(IsShootingWeapon(weaponid) && PlayerInfo[playerid][pDamagInf] == true) PlayerPlaySound(playerid,6401,0,0,0);

            // Считаем урон на капте
            if(IsAZoneCapt(playerid) && IsAZoneCapt(damagedid)) CaptTakeHealth(playerid, damagedid, damage);

            // Прерываем намаз
            if(Namaz[playerid] >= 0) NamazEnd(playerid, 2);

            if(HealthAC[damagedid] <= 0 || resultDeath == 1)
            {
                FruitPlayerDeath(damagedid, playerid, weaponid, resultDeath);
                //SendClientMessageToAllf(-1, "DamageHandler %d (health %.2f) resultDeath %d", damagedid, HealthAC[damagedid], resultDeath);
            }
        }
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

stock BeginnerDamage(playerid, damagedid) // Защита от дма новичков
{
	if(!IsPlayerNPC(damagedid) // Игрок не NPC
        && IsPlayerBeginner(damagedid) // Играл 2 часа и меньше
	    && MPGO[damagedid] == 0 // Не на мероприятии
	    && ADMS[damagedid] <= 4 // Защита от урона активна
        && PlayerInfo[damagedid][pMember] == 0 // Игрок не состоит в организации
        && PlayerInfo[damagedid][pFamily] == 0 // Игрок не состоит в семье
        && Pursuit[damagedid] == 9999 // Игрока не преследует полиция
        && computerClubPlayerInfo[damagedid][ccpiInGame] == false) // Игрок не в комп клубе
	{
		new string[160];
		if(ADMS[playerid] <= 4)
		{
			ADMS[playerid] ++;
			format(string, sizeof(string), "{FF6347}%s новичок и находится под защитой Anti DM\n\n{cccccc}Вы не сможете сейчас его убить или ранить", rpplayername(damagedid));
		}
		else
		{
			format(string, sizeof(string), "{FF6347}%s новичок и находится под защитой Anti DM\n\n{ffcc66}Вы заморожены на 20 секунд за попытки повредить другого игрока", rpplayername(damagedid));
			SendClientMessage(playerid, COLOR_GREY, "{0088ff}Вы были заморожены на 20 секунд {ffcc66}Причина: попытки навредить другому новичку");

			TogglePlayerControllable(playerid, false);
			Stopeee[playerid] = 1;
			Stopee[playerid] = 30;
		}
		ErrorMessage(playerid, string);
		return 1;
	}

    else if(PlayerInfo[playerid][pConnectTime] <= 2
        && MPGO[playerid] == 0
        && ADMS[playerid] <= 4)
    {
        if(ADMS[playerid] <= 4) ADMS[playerid] ++;
    }
	return 0;
}

new bool:readdam;
CMD:readdamage(playerid)
{
    if(server != 0) return 0;
    if(readdam == false)
    {
        ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, "{ffcc00}*", "{ffcc66}Чтение дамага {99ff66}включено", "*", "");
        readdam = true;
    }
    else 
    {
        ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, "{ffcc00}*", "{ffcc66}Чтение дамага {FF6347}отключено", "*", "");
        readdam = false;
    }
    return 1;
}

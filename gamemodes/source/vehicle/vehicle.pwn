
/*
Как добавить новый тс?
1. Добавляем в AddCustomVehice заменку и следующий id
2. Добавляем в IsAVehExisting новую цифру для создания транспорта
3. Добавляем имя транспорта в vehNameCustom[
4. Добавляем гос стоимость в vehSummaCustom[
5. Добавляем в GetVehicleType (что это за тип транспорта) [ВСЕ >= 2000]
6. stock GetVehicleClass - класс авто
7. stock IsABoot Есть ли у него багажник [ВСЕ >= 2000]
8. stock IsABootFront - только если у тачки двигатель сзади
9. stock IsA_Gen5, IsA_Gen10, IsA_Gen15 - сколько по дефолту слотов в багажнике
10. stock IsATaxi - доступен ли транспорт работать в такси [ВСЕ >= 2000]
11. stock IsAZad - есть ли задние двери в транспорте
12. Добавляем в define MAX_VEHICLE_CUSTOM (в целом там сейчас с запасом до 200)
*/

#define MAX_VEHICLE_CUSTOM 200 // Кастомный транспорт

new VehGos[212 + MAX_VEHICLE_CUSTOM]; // Стоимости транспорта
new VehGold[212 + MAX_VEHICLE_CUSTOM]; // Gold стоимости транспорта
new bool:vehgoldUpdate; // Нужно ли сохранять gold стоимость
new VehBuy[212 + MAX_VEHICLE_CUSTOM]; // Подсчет покупок транспорта за вирты
new bool:vehbuyUpdate;
new VehBuyGold[212 + MAX_VEHICLE_CUSTOM]; // Подсчет покупок транспорта за голду
new bool:vehbuyGoldUpdate;

new vehClassName[][] =
{
    "Undefiend", "Premium", "Middle", "Economy", "Off-Road", "Special", "Unique", "Goverment"
};

new vehNameCustom[][] =
{
    "Lamba Murcielago", "BMW E36 328i", "BMW M4 G82", "Mercedes S63", "Acura Integra", "Hummer H2", "Nissan GT-R R35", 
	"Lancer Evolution IX", "Shkoda Octavia", "Mercedes C63", "Nissan 350Z", "Audi Q7", "BMW 530i", "BMW M6",
	"Mercedes G65", "Ford Raptor", "Audi RS5", "BMW M4 F82", "BMW X5M", "VW Golf", "Cadillac Fleetwood", "Dodge Charger",
	"Dodge Super Bee", "Ford GT", "Lamba Aventador", "Mercedes GLE 350", "Mercedes SL 65", "Nissan 240SX", "Porsche 911 GT2",
	"Shelby GT 500", "Supra MK5", "Toyota GT AE86", "Prison Bus", "Mercedes AMG GT63", "Bentley Cabriolet", "BMW E30",
	"Arm Cargo", "Chevrolet Silverado", "Charger Police", "Charger Dep", "Enforcer SWAT", "Truck SWAT", "Ferrari F1",
	"Crown Vic", "Crown Vic Dep", "Expedition", "Explorer Dep", "Explorer Police", "Ford Focus ST", "Mustang Corch",
	"Jeep Wrangler", "Lexus LS400", "Lexus RCF", "Mazda RX7", "Mercedes EQS 580", "Mercedes Sprinter", "Mercedes Vito",
	"Mercedes E63", "Mitsu Eclipse", "Silvia S14", "Hummer H1", "Plymouth Hemi", "Camry Taxi", "Vaz 2106", "Vaz 2107",
	"VW Golf MK2"
};

new vehName[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster A", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Topfun Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "APC", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster B", "Monster C",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT 400", "DFT 30",
    "Huntley", "Stafford", "BF 400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car", "Police Car", "Police Car",
    "Police Ranger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

new vehSummaCustom[] = // Гос цены на авто (Дефолтные) Кастомный транспорт
{
    19000000,900000,10000000,11000000,400000,3500000,7000000,2500000,1100000,2800000, // 2000 - 2009
	1400000,5000000,3000000,4000000,9000000,4200000,10000000,6000000,2500000,400000, // 2010 - 2019
	2500000,1400000,7000000,4000000,30000000,6000000,7000000,1300000,3000000,3200000, // 2020 - 2029
	5000000,1200000,1300000,15000000,24000000,1500000, // 2030 - 2035
	31000000,4000000,5000000,5000000,4500000,4000000,300000000, // 2036 - 2042
	1200000,1200000,7000000,3500000,3500000,500000,12000000, // 2043 - 2049
	3000000,900000,4700000,700000,15000000,17000000,3000000, // 2050 - 2056
	11000000,1800000,2100000,9000000,6000000,2900000,500000,500000, // 2057 - 2064
	300000 // 2065
};

new vehSumma[] = // Гос цены на авто (Дефолтные)
{
    790000, 650000, 900000, 4500000, 350000, 750000, 190000000, 3900000, 2900000, // 400 - 408					+
    1900000, 320000, 4900000, 290000, 450000, 490000, 2500000, 3000000, 55000000, 550000,  // 409 - 418			+
    330000, 390000, 390000, 290000, 590000, 650000, 1500000000, 390000, 8900000, // 419 - 427					+
    6000000, 1800000, 12000000, 1600000, 900000000, 8900000, 6500000, 900000, 290000, 1600000, // 428 - 437		+
    150000, 180000, 350000, 200000, 260000, 1700000, 12000000, 390000, 8000000, 48000000, // 438 - 447			+
    24000, 100000000, 900000, 2600000, 1500000, 900000, 18000000, 1100000, 800000, 405000, 360000, // 448 - 458	+
    360000, 11150000, 600000, 89000, 330000, 20000000, 400000, 130000, 130000, // 459 - 467						+
    120000, 4000000, 3500000, 170000, 200000, 90000, 140000, 170000, 90000000, 1500000, 210000, // 468 - 478	+
    110000, 250000, 18000, 210000, 370000, 7200000, 80000, 2000000, 30000000, 29000000, 460000, // 479 - 489	+
    560000, 190000, 150000, 7000000, 2500000, 3500000, 280000, 35000000, // 490 - 497     						+
    260000, 250000, 280000, 200000, 2500000, 2500000, 2100000, 1200000, // 498 - 505							+
    2300000, 390000, 700000, 11000, 30000, 25000000, 15000000, 17000000, 5000000, 7500000, // 506 - 515         +
    250000, 180000, 170000, 50000000, 2000000000, 750000, 1250000, 600000, 4000000, 1000000, // 516 - 525       +
    450000, 370000, 5000000, 290000, 500000, 300000, 10000000, 600000, 450000, 500000, // 526 - 535				+
    400000, 100000000, 100000000, 900000, 325000, 4000000, 150000, 100000, 4900000, 200000, 260000, // 536 - 546+
    290000, 55000000, 80000, 450000, 310000, 1200000, 50000000, 870000, 325000, 60000000, 60000000, // 547 - 557+
    760000, 2300000, 2600000, 1000000, 1800000, 65000000, 20000000, 850000, 300000, 340000, 1500000, // 558 - 568
    100000000, 100000000, 2500000, 480000, 6000000, 400000, 670000, 400000, 60000000, 2500000, // 569 - 578
    900000, 500000, 700000, 2700000, 390000, 1500000, 370000, 300000, 1250000, 5000000, 560000, // 579 - 589
    100000000, 900000, 150000000, 10000000, 10000000, 60000000, 390000, 390000, 350000, // 590 - 598
    360000, 280000, 20000000, 1400000, 700000, 150000, 150000, 900000, 900000, 900000, // 599 - 608
    900000, 900000, 900000 // 609 - 611
};

new vehSpeed[] =
{
    179, 167, 212, 124, 151, 186, 125, 168, 113, // 400 - 408
	179, 147, 252, 191, 125, 120, 218, 175, 0, 131, // 409 - 418
	169, 164, 174, 159, 112, 153, 0, 197, 188, // 419 - 427
	178, 229, 210, 148, 107, 125, 189, 0, 169, 179, // 428 - 437
	162, 191, 154, 85, 158, 143, 125, 186, 0, 0, // 438 - 447
	130, 205, 0, 220, 0, 0, 0, 179, 120, 108, 179, // 448 - 458
	130, 205, 0, 220, 0, 0, 0, 179, 120, 108, 179, // 459 - 467
	163, 0, 178, 125, 0, 0, 169, 196, 0, 212, 133, // 468 - 478
	159, 209, 0, 178, 139, 0, 113, 72, 0, 0, 158, // 479 - 489
	178, 169, 159, 0, 244, 200, 185, 0, // 490 - 497
	122, 139, 159, 0, 244, 244, 196, 158, // 498 - 505
	203, 188, 122, 450, 450, 0, 0, 0, 136, 161, // 506 - 515
	178, 178, 186, 0, 0, 184, 195, 170, 148, 182, // 516 - 525
	179, 169, 200, 169, 68, 79, 125, 190, 191, 179, // 526 - 535
	196, 0, 0, 113, 169, 230, 187, 171, 168, 167, 169, // 536 - 546
	162, 0, 174, 164, 179, 137, 0, 163, 179, 125, 125, // 547 - 557
	177, 202, 192, 175, 202, 0, 0, 187, 181, 196, 166, // 558 - 568
	0, 0, 105, 68, 125, 68, 179, 179, 0, 148, // 569 - 578
	179, 173, 168, 154, 97, 0, 173, 155, 187, 122, 184, // 579 - 589
	0, 0, 0, 0, 0, 0, 199, 199, 199, // 590 - 598
	179, 171, 125, 192, 194, 167, 171, 0, 0, 0, // 599 - 608
	122, 0, 0 // 609 - 611
};

stock AddCustomVehice() // Добавляем тс на карту
{
	AddVehicleSyncModel(451, 2000); // Lamba Murcielago (Turismo) 			LQ
	AddVehicleSyncModel(602, 2001); // BMW E36 328i (Alpha)					LQ			(Колёса не получается опустить нормально)
	AddVehicleSyncModel(411, 2002); // BMW M4 G82 (Infernus)				MQ
	AddVehicleSyncModel(494, 2003); // Mercedes S63 Coupe (Hotring)			MQ			(Мелкая)
	AddVehicleSyncModel(559, 2004); // Acura Integra (Jester)				LQ			(Дерьмово выглядит)
	AddVehicleSyncModel(579, 2005); // Hummer H2 (Huntley) 					LQ
	AddVehicleSyncModel(503, 2006); // Nissan GT-R R35 (Hotrinb)			MQ
	AddVehicleSyncModel(560, 2007); // Lancer Evolution IX (Sultan)			LQ			(Крупновата)
	AddVehicleSyncModel(426, 2008); // Shkoda Octavia (Premier)				MQ
	AddVehicleSyncModel(551, 2009); // Mercedes C63 W204 (Merit)			MQ
	AddVehicleSyncModel(602, 2010); // Nissan 350Z (Alpha)					LQ
	AddVehicleSyncModel(579, 2011); // Audi Q7 (Huntley)					MQ
	AddVehicleSyncModel(426, 2012); // BMW 530i (Premier)					LQ
	AddVehicleSyncModel(602, 2013); // BMW M6 (Alpha)						MQ
	AddVehicleSyncModel(579, 2014); // Mercedes G65 (Huntley)				LQ			(Не открывается и не ломается Капот)
	AddVehicleSyncModel(579, 2015); // Ford Raptor (Huntley)				LQ
	AddVehicleSyncModel(602, 2016); // Audi RS5	(Alpha)						LQ
	AddVehicleSyncModel(602, 2017);	// BMW M4 F82 (Alpha)					LQ
	AddVehicleSyncModel(579, 2018); // BMW X5M (Huntley)					LQ			(Дерьмово выглядит)
	AddVehicleSyncModel(589, 2019);	// VW Golf	(Club)						MQ
	AddVehicleSyncModel(421, 2020); // Cadillac Fleetwood (Washing)			MQ
	AddVehicleSyncModel(560, 2021);	// Dodge Charger (Sultan)				LQ			(Дерьмово выглядит)
	AddVehicleSyncModel(475, 2022);	// Dodge Super Bee (Sabre)				MQ
	AddVehicleSyncModel(541, 2023);	// Ford GT	(Bullet)					LQ			(Дерьмово выглядит)
	AddVehicleSyncModel(541, 2024);	// Lamba Aventador (BULLET)				LQ			(Дерьмово выглядит)
	AddVehicleSyncModel(579, 2025);	// Mercedes GLE 350	(Huntley)			LQ			(Дерьмово выглядит)
	AddVehicleSyncModel(602, 2026);	// Mercedes SL 65 (Alpha)				LQ			(Дерьмово выглядит)
	AddVehicleSyncModel(602, 2027);	// Nissan 240SX (Alpha)					LQ
	AddVehicleSyncModel(451, 2028); // Porsche 911 GT2 (Turismo)			LQ
	AddVehicleSyncModel(402, 2029);	// Shelby GT 500 (Buffalo)				LQ
	AddVehicleSyncModel(562, 2030); // Supra MK5 (Elegy)					LQ
	AddVehicleSyncModel(558, 2031); // Toyota GT AE86 (Uranus)				LQ
	AddVehicleSyncModel(431, 2032); // Prison Bus (Bus)						LQ
	AddVehicleSyncModel(560, 2033); // Mercedes AMG GT63 (Sultan)			MQ
	AddVehicleSyncModel(533, 2034); // Bentley Cabriolet (Feltzer)
	AddVehicleSyncModel(502, 2035); // BMW E30	(Hotring Racer A)
	AddVehicleSyncModel(548, 2036); // Arm Cargo (cargobob)
	AddVehicleSyncModel(490, 2037); // Chevrolet Silverado (fbirancher)
	AddVehicleSyncModel(596, 2038); // Charger Police (copcarla)
	AddVehicleSyncModel(426, 2039); // Charger Dep (Premier)
	AddVehicleSyncModel(427, 2040); // Enforcer SWAT (enforcer)
	AddVehicleSyncModel(528, 2041); // Truck SWAT (fbitruck)
	AddVehicleSyncModel(494, 2042); // Ferrari F1 (hotring)
	AddVehicleSyncModel(426, 2043); // Crown Vic (Premier)
	AddVehicleSyncModel(426, 2044); // Crown Vic Dep (Premier)
	AddVehicleSyncModel(490, 2045); // Expedition (fbirancher)
	AddVehicleSyncModel(490, 2046); // Explorer Dep (fbirancher)
	AddVehicleSyncModel(490, 2047); // Explorer Police (fbirancher)
	AddVehicleSyncModel(589, 2048); // Ford Focus ST (Club)
	AddVehicleSyncModel(503, 2049); // Mustang Corch (hotrinb)
	AddVehicleSyncModel(500, 2050); // Jeep Wrangler (mesa)
	AddVehicleSyncModel(551, 2051); // Lexus LS400 (merit)
	AddVehicleSyncModel(602, 2052); // Lexus RCF (alpha)
	AddVehicleSyncModel(477, 2053); // Mazda RX7 (zr350)
	AddVehicleSyncModel(560, 2054); // Mercedes EQS 580 (sultan)
	AddVehicleSyncModel(482, 2055); // Mercedes Sprinter (Burrito)
	AddVehicleSyncModel(482, 2056); // Mercedes Vito (Burrito)
	AddVehicleSyncModel(560, 2057); // Mercedes E63 (sultan)
	AddVehicleSyncModel(559, 2058); // Mitsu Eclipse (jester)
	AddVehicleSyncModel(558, 2059); // Silvia S14 (uranus)
	AddVehicleSyncModel(470, 2060); // Hummer H1 (patriot)
	AddVehicleSyncModel(475, 2061); // Plymouth Hemi Cuda (sabre)
	AddVehicleSyncModel(420, 2062); // Camry Taxi (taxi)
	AddVehicleSyncModel(492, 2063); // Vaz 2106 (greenwoo)
	AddVehicleSyncModel(492, 2064); // Vaz 2107 (greenwoo)
	AddVehicleSyncModel(589, 2065); // VW Golf MK2 (Club)
	return 1;
}

// Проверка на доступный транспорт
stock IsAVehExisting(v)
{
    if(v >= 400 && v <= 611 // Стандартный транспорт gta

    || v >= 2000 && v <= 2065) return 1; // Кастомный транспорт пирса
    return 0;
}

stock GetVehicleName(v)
{
	new vehicleName[34];
	if(v >= 400 && v <= 611) format(vehicleName, sizeof(vehicleName), "%s", vehName[v - 400]);
	else if(v >= 2000) 
	{
		if(v - 2000 >= sizeof(vehNameCustom)) format(vehicleName, sizeof(vehicleName), "Unknown");
		else format(vehicleName, sizeof(vehicleName), "%s", vehNameCustom[v - 2000]);
	}
	return vehicleName;
}

stock GetVehiclePrice(v)
{
	new price;
	if(v >= 400 && v <= 611) price = vehSumma[v - 400];
	else if(v >= 2000)
	{
		if(v - 2000 > sizeof(vehSummaCustom)) price = 0;
		else price = vehSummaCustom[v - 2000];
	}
	return price;
}

stock GetVehiclePriceGos(v)
{
	if(v >= 2000) v -= 1788;
	else if(v >= 400 && v <= 611) v -= 400;
	return VehGos[v];
}

stock GetVehiclePriceGold(v)
{
	if(v >= 2000) v -= 1788;
	else if(v >= 400 && v <= 611) v -= 400;
	return VehGold[v];
}

stock GetVehicleSpeedMax(v)
{
	new speed;
	if(v >= 400 && v <= 611) speed = vehSpeed[v - 400];
	else speed = vehSpeed[GetVehModelOriginal(v) - 2000];
	return speed;
}

stock GetVehicleModelSync(playerid, model) // Получаем модель транспорта с учётом наличия модпака +
{
    new vehId;
    if(IsPlayerSyncModels(playerid)) // Мод установлен
	{		
		if(model >= 612) model += 13066;
		vehId = model;
	}
    else vehId = GetVehModelOriginal(model);
    return vehId;
}

stock PP_CreateVehicle(model,Float:x,Float:y,Float:z,Float:a, col1, col2, sek, siren, timerspawn, Float:health)
{
	if(QuantityVehicles + 1 >= SKOKOCAROV) return -1; // Лимит транспортных средств на серверах SAMP

	new id = m_custom_sync_CreateVehicle(model, x, y, z, a, col1, col2, sek, bool:siren);

	LinkVehicleToInterior(id, 0);
	SetVehicleVirtualWorld(id, 0);

	GetVehicleParamsEx(id, engine, lights, alarm, doors, bonnet, boot, objective);
   	SetVehicleParamsEx(id, false, false, false, false, false, false, objective);

	VehInfo[id][vStat] = 1;
	VehInfo[id][vVehcol1] = col1, VehInfo[id][vVehcol2] = col2;
	VehInfo[id][vModel] = model;
	VehInfo[id][vTimerSpawn] = timerspawn;

	VehInfo[id][vPanels] = 0;
	VehInfo[id][vDoors] = 0;
	VehInfo[id][vFara] = 0;
	VehInfo[id][vTires] = 0;

	if(!health) health = MaxVehicleHealth(model);
	VehInfo[id][vHealth] = health;
	SetVehicleHealth(id, VehInfo[id][vHealth]);

	QuantityVehicles ++;
	return id;
}

stock PP_AddStaticVehicleEx(modelID, Float: spawn_X, Float: spawn_Y, Float: spawn_Z, Float: z_Angle, color1, color2, respawn_Delay, siren = 0, Float:health = 0.0)
{
	new id = m_custom_sync_AddStaticVehEx(modelID, spawn_X, spawn_Y, spawn_Z, z_Angle, color1, color2, respawn_Delay, bool:siren);

	GetVehicleParamsEx(id, engine, lights, alarm, doors, bonnet, boot, objective);
   	SetVehicleParamsEx(id, false, false, false, false, false, false, objective);

    VehInfo[id][vStat] = 1;
    VehInfo[id][vVehcol1] = color1, VehInfo[id][vVehcol2] = color2;
    VehInfo[id][vModel] = modelID;
	VehInfo[id][vTimerSpawn] -= 1;

	VehInfo[id][vPanels] = 0;
	VehInfo[id][vDoors] = 0;
	VehInfo[id][vFara] = 0;
	VehInfo[id][vTires] = 0;

	if(!health) health = MaxVehicleHealth(modelID);
	VehInfo[id][vHealth] = health;
	SetVehicleHealth(id, VehInfo[id][vHealth]);

	QuantityVehicles ++;
    return id;
}

stock AddShopVehicleVisual()
{
	LinkVehicleToInterior(bizsalonveh[0], 186);
	SetVehicleVirtualWorld(bizsalonveh[0], 3078);

	SetVehicleVirtualWorld(bizsalonveh[1], 3079);
	LinkVehicleToInterior(bizsalonveh[1], 186);

	SetVehicleVirtualWorld(bizsalonveh[2], 3081);
	LinkVehicleToInterior(bizsalonveh[2], 186);

	SetVehicleVirtualWorld(bizsalonveh[3], 3082);
	LinkVehicleToInterior(bizsalonveh[3], 186);

	SetVehicleVirtualWorld(bizsalonveh[4], 3083);
	LinkVehicleToInterior(bizsalonveh[4], 186);

	SetVehicleVirtualWorld(bizsalonveh[5], 3084);
	LinkVehicleToInterior(bizsalonveh[5], 186);

	SetVehicleVirtualWorld(bizsalonveh[6], 3085);
	LinkVehicleToInterior(bizsalonveh[6], 186);

	SetVehicleVirtualWorld(bizsalonveh[7], 3086);
	LinkVehicleToInterior(bizsalonveh[7], 186);

	SetVehicleVirtualWorld(bizsalonveh[8], 3087);
	LinkVehicleToInterior(bizsalonveh[8], 185);

	SetVehicleVirtualWorld(bizsalonveh[9], 3088);
	LinkVehicleToInterior(bizsalonveh[9], 185);

	SetVehicleVirtualWorld(bizsalonveh[10], 3089);
	LinkVehicleToInterior(bizsalonveh[10], 185);
}

stock veh_openbonnet(v)
{
	GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);
	if(IsABootFront(v)) SetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, true, objective);
	else SetVehicleParamsEx(v, engine, lights, alarm, doors, true, boot, objective);
	VehInfo[v][vBonnet] = 1;
	if(VehInfo[v][vNospawn] != 2) VehInfo[v][vNospawn] = 1;
}
stock veh_openboot(v)
{
	GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);
	if(IsABootFront(v)) SetVehicleParamsEx(v, engine, lights, alarm, doors, true, boot, objective);
	else SetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, true, objective);
	VehInfo[v][vBoot] = 1;
	if(VehInfo[v][vNospawn] != 2) VehInfo[v][vNospawn] = 1;
}

stock IsAPosBootOrBonet(playerid, &type)
{
	new vehicleid = -1;
	new Float:pos_veh[3];
	for(new v = 0; v < SKOKOCAROV; v++)
	{
		if(VehInfo[v][vModel] == 0) continue;
		// if(!IsVehicleOpen(playerid, v)) continue;
		if(GetVehicleInterior(v) != GetPlayerInterior(playerid) || GetVehicleVirtualWorld(v) != GetPlayerVirtualWorld(playerid)) continue;

		if(IsAMoto(VehInfo[v][vModel]) || IsABoat(VehInfo[v][vModel]))
		{
			GetVehiclePos(v, pos_veh[0], pos_veh[1], pos_veh[2]);
			if(IsPlayerInRangeOfPoint(playerid, 2.0, pos_veh[0], pos_veh[1], pos_veh[2]))
			{
				vehicleid = v;
				type = 2;
				break;
			}
		}
		else if(IsAPlane(VehInfo[v][vModel]))
		{
			GetVehiclePos(v, pos_veh[0], pos_veh[1], pos_veh[2]);
			if(IsPlayerInRangeOfPoint(playerid, 4.0, pos_veh[0], pos_veh[1], pos_veh[2]))
			{
				vehicleid = v;
				type = 2;
				break;
			}
		}
		else
		{
			type = GetVehicleNear_Side(playerid, v);
			if(type > 0)
			{
				vehicleid = v;
				break;
			}
		}
	}
	return vehicleid;
}
stock IsAPosBoot(playerid) // Ищем транспорт с багажником рядом
{
	new vehicleid;
	for(new v = 0; v < SKOKOCAROV; v++)
	{
		if(VehInfo[v][vModel] == 0
			|| !IsABoot(v)
			|| GetVehicleInterior(v) != GetPlayerInterior(playerid) || GetVehicleVirtualWorld(v) != GetPlayerVirtualWorld(playerid)
			|| !IsVehicleOpen(playerid, v)
			|| !GetVehicleNear_Boot(playerid, v)) continue;

		vehicleid = v;
		break;
	}
	return vehicleid;
}

// Ищем транспорт с багажником рядом, который можно открыть только бомбой липучкой
stock IsAPosBootHardLock(playerid)
{
	new vehicleid;
	for(new v = 0; v < SKOKOCAROV; v++)
	{
		if(VehInfo[v][vModel] == 0
			|| !IsABoot(v)
			|| GetVehicleInterior(v) != GetPlayerInterior(playerid) || GetVehicleVirtualWorld(v) != GetPlayerVirtualWorld(playerid)
			|| !GetVehicleNear_Boot(playerid, v)
			|| !IsAHardLockVeicle(VehInfo[v][vModel])) continue;

		vehicleid = v;
		break;
	}
	return vehicleid;
}

stock GetVehicleNear_Boot(playerid, v) // Получаем инфу, стоим ли мы у багажника авто
{
    new Float:pos_veh[3];
    if(IsABootFront(v)) // Багажник спереди
    {
        GetCoordBonnetVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 1.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
    else // Багажник сзади
    {
        GetCoordBootVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 1.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
	return 0;
}
stock GetVehicleNear_Bonet(playerid, v) // Получаем инфу, стоим ли мы у капота авто
{
    new Float:pos_veh[3];
    if(IsABootFront(v)) // Багажник спереди
    {
        GetCoordBootVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 1.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
    else // Багажник сзади
    {
        GetCoordBonnetVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 1.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
	return 0;
}
stock GetVehicleNear_Side(playerid, v) // Получаем инфу, у какой части транспорта мы стоим
{
	new Float:boot_veh[3], Float:bonet_veh[3], sideId;
	if(IsABootFront(v)) // Багажник спереди
	{
        GetCoordBonnetVehicle(v, bonet_veh[0], bonet_veh[1], bonet_veh[2]);
        GetCoordBootVehicle(v, boot_veh[0], boot_veh[1], boot_veh[2]);
		if(IsPlayerInRangeOfPoint(playerid, 1.0, bonet_veh[0], bonet_veh[1], bonet_veh[2])) 
        {
            if(IsABoot(v)) sideId = 1; // Багажник
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1.0, boot_veh[0], boot_veh[1], boot_veh[2])) 
		{
			if(!IsANoEngine(VehInfo[v][vModel])) sideId = 2; // Капот
		}
	}
	else // Багажник сзади
	{
        GetCoordBonnetVehicle(v, bonet_veh[0], bonet_veh[1], bonet_veh[2]);
        GetCoordBootVehicle(v, boot_veh[0], boot_veh[1], boot_veh[2]);
		if(IsPlayerInRangeOfPoint(playerid, 1.0, bonet_veh[0], bonet_veh[1], bonet_veh[2])) 
		{
			if(!IsANoEngine(VehInfo[v][vModel])) sideId = 2; // Капот
		}
        else if(IsPlayerInRangeOfPoint(playerid, 1.0, boot_veh[0], boot_veh[1], boot_veh[2]))
        {
            if(IsABoot(v)) sideId = 1; // Багажник
        }
	}
	return sideId;
}

CMD:getside(playerid, const params[])
{
	if(server != 0) return 0;
	if(sscanf(params, "ii", params[0], params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: /getside id side (side 0 перед, side 1 зад)");
	
	GetDetailPosVehicle(playerid, params[0], params[1]);
	return 1;
}

stock GetDetailPosVehicle(playerid, vehicleid, typeSide)
{
	if(typeSide < 0 || typeSide > 1) return ErrorMessage(playerid, "{FF6347}Side 0 перед, side 1 зад");
	if(vehicleid < 0 || vehicleid >= 2000) return ErrorMessage(playerid, "{FF6347}Не меньше 0 и не больше 1999");
	if(!IsValidVehicle(vehicleid)) return ErrorMessage(playerid, "{FF6347}Транспорта с этим id не существует");

	new Float:pos[3];
	if(typeSide == 0) GetCoordBonnetVehicle(vehicleid, pos[0], pos[1], pos[2]);
	else if(typeSide == 1) GetCoordBootVehicle(vehicleid, pos[0], pos[1], pos[2]);
	CreateGps(playerid, pos[0], pos[1], pos[2], 0, 0, 2.0);
	return 1;
}

stock IsATrashBoot(playerid) // Позиция багажника в мусоровоза
{
	new Float:Boot[3];
	for(new v = 0; v < SKOKOCAROV; v++)
	{
		if(VehInfo[v][vModel] != 408) continue;
		if(GetVehicleInterior(v) != GetPlayerInterior(playerid) || GetVehicleVirtualWorld(v) != GetPlayerVirtualWorld(playerid)) continue;
		
		GetCoordBootVehicle(v, Boot[0], Boot[1], Boot[2]);
		if(IsPlayerInRangeOfPoint(playerid, 2.5, Boot[0], Boot[1], Boot[2]))
		{
			return v;
		}
	}
	return 0;
}

stock MaxVehicleHealth(model)
{
	new maxhealth;
    if(model == 428 || model == 470 || model == 528) maxhealth = 3000;
    else if(model == 427 || model == 433 || model == 425 || model == 548 || model == 601) maxhealth = 4000;
    else if(model == 432) maxhealth = 6000;
	else if(model == 537 || model == 538 || model == 2032) maxhealth = 10000; // train
    else maxhealth = 2000;
	return maxhealth;
}

stock IsVehicleOpen(playerid, v)
{
	if((VehInfo[v][vSost] == PlayerInfo[playerid][pID] || VehInfo[v][vKey] == PlayerInfo[playerid][pID] && VehInfo[v][vKeyUnix] > gettime()) 
		&& GetPlayerVip(playerid) > 0) return 1; // Личный или есть ключи + VIP
	else
	{
		if(VehInfo[v][vCarLock] == 0) return 1; // Транспорт открыт
	}
	return 0;
}

stock GetVehicleType(model) // Получаем тип транспорта
{
    new type;

    // Автомобили (Требуются водительские права) Car
    if(model == 400 || model == 401 || model == 402 || model == 403 || model == 404 || model == 405
    || model == 406 || model == 407 || model == 408 || model == 409 || model == 410 || model == 411 || model == 412
    || model == 413 || model == 414 || model == 415 || model == 416 || model == 418 || model == 419 || model == 420
    || model == 421 || model == 422 || model == 423 || model == 424 || model == 426 || model == 427 || model == 428
    || model == 429 || model == 431 || model == 432 || model == 433 || model == 434 || model == 436 || model == 437
    || model == 438 || model == 439 || model == 440 || model == 442 || model == 443 || model == 444 || model == 445
    || model == 451 || model == 455 || model == 456 || model == 457 || model == 458 || model == 459 || model == 466 || model == 467
    || model == 470 || model == 474 || model == 475 || model == 477 || model == 478 || model == 479
    || model == 480 || model == 482 || model == 483 || model == 485 || model == 486 || model == 489 || model == 490 || model == 491
    || model == 492 || model == 494 || model == 495 || model == 496 || model == 498 || model == 499 || model == 500
    || model == 502 || model == 503 || model == 504 || model == 505 || model == 506 || model == 507 || model == 508
    || model == 514 || model == 515 || model == 516 || model == 517 || model == 518 || model == 524 || model == 525
    || model == 526 || model == 527 || model == 528 || model == 529 || model == 530 || model == 531 || model == 532 || model == 533 || model == 534
    || model == 535 || model == 536 || model == 540 || model == 541 || model == 542 || model == 543
    || model == 544 || model == 545 || model == 546 || model == 547 || model == 549 || model == 550 || model == 551
    || model == 552 || model == 554 || model == 555 || model == 556 || model == 557 || model == 558 || model == 559
    || model == 560 || model == 561 || model == 562 || model == 565 || model == 566 || model == 567 || model == 568
    || model == 572 || model == 573 || model == 574 || model == 575 || model == 576 || model == 578 || model == 579
    || model == 580 || model == 582 || model == 583 || model == 585 || model == 587 || model == 588 || model == 589
    || model == 596 || model == 597 || model == 598 || model == 599 || model == 600 || model == 601 || model == 602
    || model == 603 || model == 604 || model == 605 || model == 609
	|| model >= 2000 && model <= 2035 || model >= 2037) type = 1;


    // Мототранспорт (Требуется лицензия на мото транспорт) Moto
    else if(model == 448 || model == 461 || model == 462 || model == 463 || model == 468 || model == 471 || model == 521
    || model == 522 || model == 523 || model == 571 || model == 581 || model == 586) type = 2;

    // Водный Транспорт (Требуется лицензия на катер) Boat
    else if(model == 430 || model == 446 || model == 452 || model == 453 || model == 454 || model == 472
    || model == 473 || model == 484 || model == 493 || model == 539 || model == 595) type = 3;

    // Вертолёты (Требуется лицензия на вертолёт) Helicopter
    else if(model == 417 || model == 425 || model == 447 || model == 469 || model == 487 || model == 488 || model == 497 
    || model == 548 || model == 563 || model == 2036) type = 4;

    // Самолёты (Требуется лицензия на самолёт) Plane
    else if(model == 460 || model == 476 || model == 511 || model == 512 || model == 513 || model == 519 || model == 520 
    || model == 553 || model == 577 || model == 592 || model == 593) type = 5;

    // Велотранспорт (Лицензия не требуется) Bicycle
    else if(model == 481 || model == 509 || model == 510) type = 6;
    return type;
}
stock GetVehicleClass(m)
{
    new class;

    // Premium Class (1) - Премиум
	
    if(m == 402 || m == 409 || m == 411 || m == 415 || m == 429 || m == 446 || m == 451 || m == 454 || m == 477 || m == 493 
    || m == 494 || m == 502 || m == 503 || m == 506 || m == 519 || m == 521 || m == 522 || m == 535 || m == 541 || m == 559
    || m == 560 || m == 562 || m == 565 || m == 580 || m == 586
	|| m == 2000 || m == 2002 || m == 2003 || m == 2020 || m == 2022 || m == 2023 || m == 2024 || m == 2033 || m == 2034
	|| m == 2052 || m == 2054 || m == 2057) class = 1;

    // Middle Class (2) - Средний
    else if(m == 401 || m == 405 || m == 418 || m == 419 || m == 421 || m == 426 || m == 439 || m == 445 || m == 452 || m == 460
    || m == 461 || m == 463 || m == 468 || m == 469 || m == 471 || m == 480 || m == 484 || m == 487 || m == 491 || m == 496
    || m == 507 || m == 511 || m == 516 || m == 533 || m == 534 || m == 550 || m == 551 || m == 555 || m == 558 || m == 561
    || m == 581 || m == 585 || m == 587 || m == 589 || m == 602 || m == 603
	|| m == 2001 || m == 2006 || m == 2007 || m == 2008 || m == 2009 || m == 2010 || m == 2012 || m == 2013 || m == 2016
	|| m == 2017 || m == 2018 || m == 2026 || m == 2027 || m == 2028 || m == 2029 || m == 2030 || m == 2039 || m == 2049) class = 2;

    // Economy Class (3) - Бомж
    else if(m == 404 || m == 410 || m == 412 || m == 436 || m == 453 || m == 458 || m == 462 || m == 466 || m == 467 || m == 472
    || m == 474 || m == 475 || m == 479 || m == 492 || m == 512 || m == 513 || m == 517 || m == 518 || m == 526 || m == 527
    || m == 529 || m == 536 || m == 540 || m == 542 || m == 546 || m == 547 || m == 549 || m == 553 || m == 566 || m == 567
    || m == 575 || m == 576 || m == 593 || m == 595 || m == 600
	|| m == 2004 || m == 2019 || m == 2021 || m == 2031 || m == 2043 || m == 2048 || m == 2051 || m == 2053 || m == 2061
	|| m == 2065) class = 3;

    // Off-Road Class (4) - Внедорожник
    else if(m == 400 || m == 422 || m == 489 || m == 495 || m == 500 || m == 543 || m == 554 || m == 579
	|| m == 2005 || m == 2011 || m == 2014 || m == 2015 || m == 2025 || m == 2050) class = 4;

    // Special Class (5) - Грузовая и Спец Техника
    else if(m == 403 || m == 413 || m == 414 || m == 417 || m == 440 || m == 455 || m == 456
    || m == 459 || m == 478 || m == 482 || m == 498 || m == 499 || m == 508 || m == 514 || m == 515 || m == 578
	|| m == 2055 || m == 2056) class = 5;

    // Unique Class (6) - Уникальный Транспорт
    else if(m == 423 || m == 424 || m == 431 || m == 434 || m == 437 || m == 442 || m == 443 || m == 444 || m == 457 || m == 473 
    || m == 476 || m == 481 || m == 483
    || m == 504 || m == 509 || m == 510 || m == 530 || m == 531 || m == 532 || m == 545 || m == 556 || m == 557 || m == 571 
    || m == 573 || m == 577 || m == 588 || m == 592 || m == 2035 || m == 2042 || m == 2058 || m == 2059 || m == 2062 || m == 2063 || m == 2064) class = 6;

    // Goverment Class (7) - Государственный Транспорт
    else if(m == 406 || m == 407 || m == 408 || m == 416 || m == 420 || m == 425 || m == 427 || m == 428 || m == 430 || m == 432 
    || m == 438 || m == 447 || m == 448 || m == 470 || m == 485 || m == 486 || m == 488 || m == 490 || m == 497 || m == 520
    || m == 523 || m == 524 || m == 525 || m == 528 || m == 539 || m == 544 || m == 548 || m == 552 || m == 563 || m == 572 
    || m == 574 || m == 582 || m == 583 || m == 596 || m == 597 || m == 598 || m == 599 || m == 601 
	|| m == 2032 || m == 2036 || m == 2037 || m == 2038 || m == 2040 || m == 2041 || m == 2044 || m == 2045 || m == 2046
	|| m == 2047 || m == 2060) class = 7;

    else class = 0; // 0 Класс недоступен для продажи (неизвестный транспорт)
    return class;
}

stock IsABoot(carid) // Транспорт, у которых есть багажник
{
	new model = VehInfo[carid][vModel];
	if(model == 400 || model == 401 || model == 402 || model == 404 || model == 405 || model == 409 || model == 410 || model == 411 || model == 412 || model == 413
    || model == 415 || model == 418 || model == 419 || model == 420 || model == 421 || model == 422 || model == 426 || model == 428 || model == 429 || model == 433 || model == 434 || model == 436
    || model == 438 || model == 439 || model == 440 || model == 442 || model == 444 || model == 445 || model == 451 || model == 458 || model == 459 || model == 466 || model == 467
    || model == 470 || model == 474 || model == 475 || model == 477 || model == 479 || model == 480 || model == 489 || model == 490 || model == 491
    || model == 492 || model == 494 || model == 495 || model == 496 || model == 498 || model == 500 || model == 502 || model == 503 || model == 504 || model == 505 || model == 506
    || model == 507 || model == 516 || model == 517 || model == 518 || model == 526 || model == 527 || model == 528 || model == 529 || model == 533 || model == 534 || model == 535
    || model == 536 || model == 540 || model == 541 || model == 542 || model == 543 || model == 545 || model == 546 || model == 547 || model == 549 || model == 550 || model == 551
    || model == 554 || model == 555 || model == 556 || model == 557 || model == 558 || model == 559 || model == 560 || model == 561 || model == 562 || model == 565 || model == 566
    || model == 567 || model == 573 || model == 575 || model == 576 || model == 579 || model == 580 || model == 585 || model == 587 || model == 589 || model == 596 || model == 597
    || model == 598 || model == 599 || model == 600 || model == 602 || model == 603 || model == 604 || model == 605 || model == 609
	|| model >= 2000 && model <= 2031 || model >= 2033 && model <= 2035
	|| model >= 2037 && model <= 2041 || model >= 2043 && model <= 2065) return 1;
	return 0;
}

stock IsABootFront(carid)
{
	new model = VehInfo[carid][vModel];
	if(model == 415 || model == 424 || model == 437 || model == 451 || model == 483 || model == 486 || model == 530 || model == 532 
	|| model == 541 || model == 568 || model == 588 || model == 601
	|| model == 2000 || model == 2023 || model == 2024 || model == 2028 || model == 2041) return 1;
	return 0;
}

stock IsA_Gen5(carid) // 5 слотов в багажнике
{
	new model = VehInfo[carid][vModel];
	if(model == 400 || model == 401 || model == 402 || model == 404 || model == 405 || model == 409 || model == 410 || model == 411 || model == 412 || model == 415
    || model == 419 || model == 420 || model == 421 || model == 426 || model == 429 || model == 434 || model == 436 || model == 438 || model == 439 || model == 442 || model == 445
    || model == 451 || model == 458 || model == 466 || model == 467 || model == 470 || model == 474 || model == 475 || model == 477 || model == 479 || model == 480 || model == 489
    || model == 490 || model == 491 || model == 492 || model == 495 || model == 496 || model == 500 || model == 504 || model == 505 || model == 506 || model == 507 || model == 516
    || model == 517 || model == 518 || model == 526 || model == 527 || model == 529 || model == 533 || model == 534 || model == 536 || model == 540 || model == 541 || model == 542
    || model == 545 || model == 546 || model == 547 || model == 549 || model == 550 || model == 551 || model == 555 || model == 558 || model == 559 || model == 560 || model == 561
    || model == 562 || model == 565 || model == 566 || model == 567 || model == 575 || model == 576 || model == 579 || model == 580 || model == 585 || model == 587 || model == 589
    || model == 596 || model == 597 || model == 598 || model == 599 || model == 602 || model == 603 || model == 604
	|| model == 2000 || model == 2001 || model == 2002 || model == 2003 || model == 2004 || model == 2006 || model == 2007
	|| model == 2008 || model == 2009 || model == 2010 || model == 2012 || model == 2013 || model == 2016 || model == 2017
	|| model == 2019 || model == 2020 || model == 2021 || model == 2022 || model == 2023 || model == 2024 || model == 2026
	|| model == 2027 || model == 2028 || model == 2029 || model == 2030 || model == 2031 || model == 2033 || model == 2034
	|| model == 2035 || model == 2038 || model == 2039 || model == 2043 || model == 2044 || model == 2048 || model == 2049
	|| model == 2050 || model == 2051 || model == 2052 || model == 2053 || model == 2054 || model == 2057 || model == 2058
	|| model == 2059 || model == 2061 || model == 2062 || model == 2063 || model == 2064 || model == 2065) return 1;
	return 0;
}

stock IsA_Gen10(carid) // 10 слотов в багажнике
{
	new model = VehInfo[carid][vModel];
	if(model == 418 || model == 422 || model == 444 || model == 543 || model == 554 || model == 556 || model == 557 || model == 600 || model == 605
	|| model == 2005 || model == 2011 || model == 2014 || model == 2018 || model == 2025 || model == 2037 || model == 2045
	|| model == 2046 || model == 2047) return 1;
	return 0;
}

stock IsA_Gen15(carid) // 15 слотов в багажнике
{
	new model = VehInfo[carid][vModel];
	if(model == 413 || model == 414 || model == 440 || model == 459 || model == 478 || model == 482 || model == 498 || model == 499 || model == 609
	|| model == 2015 || model == 2041 || model == 2056 || model == 2060) return 1;
	return 0;
}

stock IsATaxi(carid) // Транспорт, который разрешён для работы в такси
{
	new model = VehInfo[carid][vModel];
	if(model >= 400 && model <= 424 || model >= 426 && model <= 429 || model == 431 || model == 433 || model == 434 || model >= 436 && model <= 440 || model >= 442 && model <= 445
 	|| model == 447 || model == 448 || model == 451 || model >= 455 && model <= 463 || model >= 466 && model <= 471 || model == 474 || model == 475 || model >= 477 && model <= 480
 	|| model == 482 || model == 483 || model >= 487 && model <= 492 || model >= 494 && model <= 500 || model >= 502 && model <= 508 || model == 511 || model >= 514 && model <= 518
 	|| model >= 521 && model <= 529 || model >= 533 && model <= 536 || model >= 540 && model <= 552 || model >= 554 && model <= 563 || model >= 565 && model <= 567
 	|| model >= 573 && model <= 576 || model >= 578 && model <= 582 || model >= 585 && model <= 589 || model == 593 || model >= 596 && model <= 605 || model == 609
	|| model >= 2000) return 1;
	return 0;
}

stock IsAVello(carid) // Велики
{
	new model = VehInfo[carid][vModel];
	new type = GetVehicleType(model);
	if(type == 6) return 1;
	return 0;
}

stock IsAZad(model) // Транспорт с задними окнами
{
    if(model == 404 || model == 405 || model == 409 || model == 420 || model == 421 || model == 426 || model == 438
	|| model == 445 || model == 458 || model == 466 || model == 467 || model == 470 || model == 479 || model == 490
 	|| model == 492 || model == 507 || model == 516 || model == 529 || model == 540 || model == 546 || model == 547
  	|| model == 550 || model == 551 || model == 560 || model == 561 || model == 566 || model == 579 || model == 580
   	|| model == 585 || model == 596 || model == 597 || model == 598 || model == 604
	|| model == 2005 || model == 2007 || model == 2008 || model == 2009 || model == 2011 || model == 2012 || model == 2014
	|| model == 2015 || model == 2018 || model == 2020 || model == 2021 || model == 2025 || model == 2033 || model == 2034
	|| model >= 2037 && model <= 2047 || model == 2051 || model == 2054 || model == 2057 || model == 2060 || model == 2062) return 1;
	return 0;
}

stock IsABus(model)
{
	if(model == 431 || model == 437 
		|| GetVehModelOriginal(model) == 431
		|| GetVehModelOriginal(model) == 437) return 1;
	return 0;
}

stock IsACar(model) // Авто
{
	new type = GetVehicleType(model);
	if(type == 1) return 1;
	return 0;
}

stock IsANotTuning(model) // Запрещено ставить тюнинг
{
    if(model == 539) return 1;
	return 0;
}

stock IsABoat(model) // Лодки
{
	new type = GetVehicleType(model);
	if(type == 3) return 1;
	return 0;
}

// Воздушный ТС Самолёты и Вертолёты
stock IsAPlane(model)
{
	new type = GetVehicleType(model);
	if(type == 4 || type == 5) return 1;
	return 0;
}

// Самолёты
stock IsAAir(model)
{
	new type = GetVehicleType(model);
	if(type == 5) return 1;
	return 0;
}
// Вертолёты
stock IsAHeli(model)
{
	new type = GetVehicleType(model);
	if(type == 4) return 1;
	return 0;
}

stock IsAMoto(model)
{
	new type = GetVehicleType(model);
	if(type == 2) return 1;
	return 0;
}

stock IsAScooter(model)
{
	if(model == 462) return 1;
	return 0;
}

stock IsAEnforcer(model)
{
	if(model == 427 || model == 2040) return 1;
	return 0;
}

stock IsARC(model)
{
    if(model == 441 || model == 464 || model == 465 || model == 501 || model == 564 || model == 594) return 1;
	return 0;
}

stock IsANoEngine(model)
{
	if(model == 435 || model == 441 || model == 450 || model == 464 || model == 465 || model == 509 || model == 510 
	|| model == 564 || model == 584 || model == 590 || model == 591 || model == 594
	|| model == 606 || model == 607 || model == 608 || model == 610 || model == 611) return 1;
	return 0;
}

stock IsATrain(model)
{
    if(model == 537 || model == 538 || model == 569 || model == 570 || model == 590) return 1;
	return 0;
}

stock IsAShassi(model)
{
    if(model == 460 || model == 476 || model == 511 || model == 512 || model == 513 || model == 519 || model == 520 || model == 553 || model == 577
    || model == 592|| model == 593) return 1;
	return 0;
}

stock IsABig(model)
{
    if(model == 403 || model == 406 || model == 407 || model == 408 || model == 414 || model == 416 || model == 427 || model == 428
	|| model == 431 || model == 432 || model == 433 || model == 437 || model == 443 || model == 444 || model == 445 || model == 456
	|| model == 486 || model == 498 || model == 499 || model == 508 || model == 514 || model == 515 || model == 524 || model == 528
 	|| model == 532 || model == 544 || model == 556 || model == 557 || model == 573 || model == 578 || model == 582 || model == 588
  	|| model == 601 || model == 609 || model == 455 || model == 531) return 1;
	return 0;
}

stock IsATun(model) // Транспорт, на который можно на сервере устанавливать обвесы
{
    if(model == 558 || model == 559 || model == 560 || model == 561 || model == 562 || model == 565) return 1;
	return 0;
}

stock IsAMafCar(model) // Транспорт для мафий
{
    if(model == 405 || model == 609 || model == 445 || model == 562 || model == 461 || model == 579 || model == 540
    || model == 602 || model == 580 || model == 409 || model == 439 || model == 477 || model == 489 || model == 507
	|| model == 529 || model == 533 || model == 550 || model == 555 || model == 589 || model == 402 || model == 439
 	|| model == 451 || model == 506 || model == 521 || model == 560) return 1;
	return 0;
}

stock IsAGangCar(model) // Транспорт для банд
{
    if(model == 492 || model == 567 || model == 536 || model == 535 || model == 475 || model == 468 || model == 412 || model == 566
    || model == 517 || model == 576 || model == 575 || model == 467 || model == 466 || model == 482 || model == 419 || model == 518
	|| model == 534 || model == 404 || model == 413 || model == 422 || model == 471 || model == 474 || model == 479 || model == 491
 	|| model == 496 || model == 498 || model == 529 || model == 533 || model == 542 || model == 549 || model == 581 || model == 600
  	|| model == 603) return 1;
	return 0;
}

// Ищем транспорт в нужных нам координатах по модели
stock GetNeedVehicleNearby(model, Float:x, Float:y, Float:z, Float:radius)
{
	new yes;
	for(new v = 0; v < SKOKOCAROV; v++)
	{
		if(VehInfo[v][vModel] != model) continue;

		new Float:dist = GetVehicleDistanceFromPoint(v, x, y, z);
		if(dist <= radius)
		{
			yes = 1;
			break;
		}
	}
	return yes;
}

stock vehprice(playerid, page) // Настройки гос. цен транспорта
{
	new max_line = 40, yesNext, minlist, thisPage;
	new line[214],lines[4096];

	// Настраиваем отображение фильтров и страниц
	LoadPageSorting(playerid, 1066, 211 + sizeof(vehNameCustom) + 1, minlist, page, thisPage);

	format(line,sizeof(line),"{cccccc}Транспорт [Модель]\t{cccccc}Цена\t{cccccc}Gold\t{cccccc}Куплено за Вирты / Gold"), strcat(lines,line);
	if(IsActiveSorting(playerid)) format(line,sizeof(line),"\n{ff9000}Фильтр {99ff66}[Активен]\t\t\t"), strcat(lines,line);
    else format(line,sizeof(line),"\n{ff9000}Фильтр\t\t\t"), strcat(lines,line);

	new one;
	for(new v = minlist; v < 211 + sizeof(vehNameCustom) + 1; v++)
	{
		if(one == 0) OnlineInfo[playerid][oDialogMenu][4] = v, one = 1; // Записывали первый vehicleList

		if(CheckSortingLineVehPrice(playerid, v)) format(line,sizeof(line),"%s", ShowLineVehPrice(playerid, v)), strcat(lines,line);

		if(OnlineInfo[playerid][oDialogMenu][0] >= max_line) // Сбрасываем дальнейший вывод строк, если дошли до лимита на странице
        {
			yesNext = 1;
            break;
        }

		if(v > 211 + sizeof(vehNameCustom) + 1 && page > 0)
		{
			yesNext = 1; // Последний транспорт, отображаем Next Page
			OnlineInfo[playerid][oDialogMenu][5] = 1; // Записываем, что эта страница была последней
		}
	}
	if(yesNext == 1) format(line,sizeof(line),"\n{cccccc}Next Page >>\t\t\t"), strcat(lines,line);
	new header[60];
    format(header,sizeof(header),"Гос Стоимость Транспорта [ Страница %d ]", page + 1);
    ShowDialog(playerid,1066,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Выбрать","Выход");
    return 1;
}

stock CheckSortingLineVehPrice(playerid, v)
{
	new vehicleList = v;
	v = CorrectVehicleList(vehicleList);
	
	if(OnlineInfo[playerid][oSorting][1] > 0) // Фильтр по ID
	{
		new sortingID[14], vehicleID[14];
		valstr(sortingID, OnlineInfo[playerid][oSorting][1]);
		valstr(vehicleID, v);

		if(strfind(vehicleID, sortingID, true) != -1) {} // Отображаем схожие ID
		else return 0; // Отображаем только фильтрованные id транспортных средств
	}

	if(!strcmp(OnlineInfo[playerid][oSortingName],"\0",true)) {} // Фильтр по названию не включен
	else
	{
		if(strfind(GetVehicleName(v), OnlineInfo[playerid][oSortingName], true) != -1) {} // Отображаем схожую строку
		else return 0; // Отображаем только фильтрованные названия транспортных средств
	}
	return 1;
}

stock ShowLineVehPrice(playerid, v)
{
	new line[214];
	new vehicleList = v;
	v = CorrectVehicleList(vehicleList);

    List[OnlineInfo[playerid][oDialogMenu][0]][playerid] = vehicleList;
    OnlineInfo[playerid][oDialogMenu][0] ++; // Подсчитываем строки
	OnlineInfo[playerid][oDialogMenu][2] = vehicleList;

	if(v >= 2000) // Custom
	{
    	format(line,sizeof(line),"\n{0088ff}%s {cccccc}[%d]\t{99ff66}%d$ {cccccc}[%s]\t{ffcc00}%dG\t{cccccc}%d / %d",GetVehicleName(v), v, VehGos[vehicleList], get_k(VehGos[vehicleList]), VehGold[vehicleList], VehBuy[vehicleList], VehBuyGold[vehicleList]);
	}
	else
	{
    	format(line,sizeof(line),"\n{cccccc}%s [%d]\t{99ff66}%d$ {cccccc}[%s]\t{ffcc00}%dG\t{cccccc}%d / %d",GetVehicleName(v), v, VehGos[vehicleList], get_k(VehGos[vehicleList]), VehGold[vehicleList], VehBuy[vehicleList], VehBuyGold[vehicleList]);
	}
    return line;
}

stock SettingGosPriceVehicle(playerid, vehicleList)
{
	new v = CorrectVehicleList(vehicleList);

	new line[120],lines[360];
    if(v >= 2000) format(line,sizeof(line),"{0088ff}%s\t", GetVehicleName(v)), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}%s\t", GetVehicleName(v)), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Стоимость:\t{99ff66}%d$ {cccccc}[%s]", VehGos[vehicleList], get_k(VehGos[vehicleList])), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Gold:\t{ffcc00}%dG", VehGold[vehicleList]), strcat(lines,line);
    ShowDialog(playerid,1086,DIALOG_STYLE_TABLIST_HEADERS,"Гос Стоимость Транспорта",lines,"Выбрать","Назад");
	return 1;
}

stock CorrectVehicleList(vehicleList)
{
	new v = vehicleList;
	if(v >= 212) v += 1788;
	else v += 400;
	return v;
}

stock dialogCase_Vehicle(playerid, dialogid, response, listitem, const inputtext[])
{
	if(dialogid == 1066)
	{
		if(response)
		{
			if(listitem == 0) DialogMenuSorting(playerid);

			if(OnlineInfo[playerid][oDialogMenu][0] > 0) // Есть строки на странице
			{
				if(listitem >= 1 && listitem <= OnlineInfo[playerid][oDialogMenu][0]) // Отображаемые List
				{
					new vehicleList = List[listitem-1][playerid];
					OnlineInfo[playerid][oDialogMenu][3] = vehicleList;
					SettingGosPriceVehicle(playerid, vehicleList);
				}
				else if(listitem == OnlineInfo[playerid][oDialogMenu][0] + 1) vehprice(playerid, OnlineInfo[playerid][oDialogMenu][1] + 1); // Следующая страница
			}
		}
		else cmd_economy(playerid);
	}
	else if(dialogid == 1067)
	{
		if(response)
		{
			new input = strval(inputtext);
			new vehicleList = OnlineInfo[playerid][oDialogMenu][3];
			if(input < 1 || input > 900000000) return ErrorText(playerid, "{FF6347}Не меньше 1$ и не больше 900.000.000$"), SettingGosPriceVehicle(playerid, vehicleList);
			VehGos[vehicleList] = input;

			new v = CorrectVehicleList(vehicleList);
			PlayerPlaySound(playerid, 6401, 0,0,0);
			SaveVehiclePrice(vehicleList);

			new string[180];
			format(string,sizeof(string),"[ Мысли ]: Гос. стоимость %s теперь составляет: {99ff66}%d$ [%s]", GetVehicleName(v), VehGos[vehicleList], get_k(VehGos[vehicleList]));
  			SendClientMessage(playerid,COLOR_GREY,string);
  			format(string, sizeof(string), "[Правительство] %s изменяет гос. стоимость: %s {99ff66}%d$ [%s]", PlayerInfo[playerid][pName], GetVehicleName(v), VehGos[vehicleList], get_k(VehGos[vehicleList]));
  			SendDepartMessage(COLOR_ALLDEPT, string);
			SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);
     		OrgLog(7, "minfin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", input, GetVehicleName(v));

			// Сбрасываем ценники в Бизнесах: Все Аренды Транспорта, Автосалоны, Мотосалоны, Авиасалоны, Салоны Катеров
     		for(new b = 42; b < 92; b++) ResetBizzPriceItem(playerid, b, v, 5, input);
		}
		else SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);
	}
	else if(dialogid == 1086)
	{
		if(response)
		{
			new vehicleList = OnlineInfo[playerid][oDialogMenu][3];
			new v = CorrectVehicleList(vehicleList);
			if(listitem == 0)
			{
				new line[100],lines[300];
				format(line,sizeof(line),"{cccccc}Введите гос. стоимость для {ff9000}%s", GetVehicleName(v)), strcat(lines,line);
				format(line,sizeof(line),"\n\n{cccccc}Текущая Стоимость: {99ff66}%d$ {cccccc}[%s]", VehGos[vehicleList], get_k(VehGos[vehicleList])), strcat(lines,line);
				format(line,sizeof(line),"\n{cccccc}Не меньше 1$ и не больше 900.000.000$"), strcat(lines,line);
				ShowDialog(playerid,1067,DIALOG_STYLE_INPUT,"Гос Стоимость Транспорта",lines,"Принять","Отмена");
			}
			else if(listitem == 1)
			{
				new line[100],lines[300];
				format(line,sizeof(line),"{cccccc}Введите Gold стоимость для {ff9000}%s", GetVehicleName(v)), strcat(lines,line);
				format(line,sizeof(line),"\n\n{cccccc}Текущая Стоимость: {ffcc00}%dG", VehGold[vehicleList]), strcat(lines,line);
				format(line,sizeof(line),"\n{cccccc}Не меньше 1G и не больше 100.000G"), strcat(lines,line);
				ShowDialog(playerid,1133,DIALOG_STYLE_INPUT,"Гос Стоимость Транспорта",lines,"Принять","Отмена");
			}
		}
		else vehprice(playerid, OnlineInfo[playerid][oDialogMenu][1]);
	}
	else if(dialogid == 1133)
	{
		if(response)
		{
			new vehicleList = OnlineInfo[playerid][oDialogMenu][3];
			if(PlayerInfo[playerid][pSoska] < 20) return ErrorText(playerid, "{FF6347}Только для администраторов 20+ уровня"), SettingGosPriceVehicle(playerid, vehicleList);
			new input = strval(inputtext);
			if(input < 1 || input > 100000) return ErrorText(playerid, "{FF6347}Не меньше 1G и не больше 100.000G"), SettingGosPriceVehicle(playerid, vehicleList);
			VehGold[vehicleList] = input;

			new v = CorrectVehicleList(vehicleList);
			PlayerPlaySound(playerid, 6401, 0,0,0);

			// vehgoldUpdate = true;
			SaveVehicleGold();

			new string[180];
			format(string,sizeof(string),"[ Мысли ]: Gold стоимость %s теперь составляет: {ffcc00}%dG", GetVehicleName(v), VehGold[vehicleList]);
  			SendClientMessage(playerid,COLOR_GREY,string);
  			SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);

			format(string,sizeof(string),"%dG %s", input, GetVehicleName(v));
			AdminLog("vehgold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", v, string);
		}
		else SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);
	}
	return 1;
}

stock SaveVehiclePrice(idx)
{
	new string_mysql[100];
	format(string_mysql, sizeof(string_mysql), "UPDATE `pp_economy` SET `v%d` = '%d' WHERE `newid` = '1'", idx, VehGos[idx]);
	query_empty(pearsq, string_mysql);
	return 1;
}

stock SaveVehicleGold()
{
    new string_mysql[4096];
	format(string_mysql, sizeof(string_mysql), "UPDATE `pp_economy` SET `VehGold` = '%s' WHERE `newid` = '1'", StringifyArray(VehGold, sizeof(VehGold)));
	query_empty(pearsq, string_mysql);
    return 1;
}

stock SaveVehicleBuy()
{
    new string_mysql[4096];
	format(string_mysql, sizeof(string_mysql), "UPDATE `pp_economy` SET `VehBuy` = '%s' WHERE `newid` = '1'", StringifyArray(VehBuy, sizeof(VehBuy)));
	query_empty(pearsq, string_mysql);
    return 1;
}

stock SaveVehicleBuyGold()
{
    new string_mysql[4096];
	format(string_mysql, sizeof(string_mysql), "UPDATE `pp_economy` SET `VehBuyGold` = '%s' WHERE `newid` = '1'", StringifyArray(VehBuyGold, sizeof(VehBuyGold)));
	query_empty(pearsq, string_mysql);
    return 1;
}


new PlayerText3D:CustomVehLabel[MAX_REALPLAYERS][SKOKOCAROV];
new bool:CustomLabelBusy[MAX_REALPLAYERS][SKOKOCAROV];

stock CreateCustomVehicleLabel(playerid, vehicleid, Float:dist)
{
	if(IsPlayerSyncModels(playerid)) return 1; // У игрока есть лаунчер
	if(CustomLabelBusy[playerid][vehicleid] == true) return 1;

	new string[100];
	format(string, sizeof(string), "{0088ff}%s\n{666666}Доступен с лаунчером", GetVehicleName(VehInfo[vehicleid][vModel]));
	CustomVehLabel[playerid][vehicleid] = CreatePlayer3DTextLabel(playerid, string, 0xA9C4E4FF, 0.0,0.0,0.0 + 0.2, dist, INVALID_PLAYER_ID, vehicleid, false);
	CustomLabelBusy[playerid][vehicleid] = true;
	return 1;
}

stock DestroyCustomVehicleLabel(playerid, vehicleid)
{
	if(IsPlayerSyncModels(playerid)) return 1; // У игрока есть лаунчер

	if(CustomLabelBusy[playerid][vehicleid] == true)
	{
		DeletePlayer3DTextLabel(playerid, CustomVehLabel[playerid][vehicleid]);
		CustomLabelBusy[playerid][vehicleid] = false;
	}
	return 1;
}

stock DestroyAllCustomVehicleLabels(playerid)
{
	for(new i = 0; i < SKOKOCAROV; i++)
	{
		if(CustomLabelBusy[playerid][i] == true)
		{
			DeletePlayer3DTextLabel(playerid, CustomVehLabel[playerid][i]);
			CustomLabelBusy[playerid][i] = false;
		}
	}
	return 1;
}

function LoadGosVeh()
{
	new time = GetTickCount();
	new rows,stra[5];
	cache_get_row_count(rows);
	if(rows)
	{
		for(new v = 0; v < 211 + sizeof(vehNameCustom) + 1; v++)
		{
			format(stra,sizeof(stra),"v%d",v);
			cache_get_value_name_int(0, stra, VehGos[v]);

			if(VehGos[v] == 0)
			{
				if(v <= 211) VehGos[v] = vehSumma[v];
				else VehGos[v] = vehSummaCustom[v - 212];
			}
		}
		printf("[MODE]: Стоимость Транспорта [%d ms]",GetTickCount() - time);
	}
	return 1;
}

// Поиска id транспорта по названию
stock ReturnVehicle(const vehiclename[])
{
	new model = -1;

	// Если указан id, просто передаём id
	if(IsNumeric(vehiclename)) model = strval(vehiclename);
	else
	{
		// Ищем по названию среди обычного транспорта
		for(new i = 0; i < sizeof(vehName); i++)
		{
			if(strfind(vehName[i], vehiclename, true) != -1)
			{
				model = i + 400;
				break;
			}
		}

		// Ищем по названию среди кастомного транспорта
		if(model == -1)
		{
			for(new i = 0; i < sizeof(vehNameCustom); i++)
			{
				if(strfind(vehNameCustom[i], vehiclename, true) != -1)
				{
					model = i + 2000;
					break;
				}
			}
		}
	}
    return model;
}

// Замки транспорта, которые невозможно взломать отмычками и требуется бомба липучка
stock IsAHardLockVeicle(model)
{
	if(model == 428) return 1;
	return 0;
}

// Транспорт, в котором не нужно оповещать о том, что в нём не сохраняются предметы в багажнике
stock IsNoMessageVehicle(vehicleid)
{
	if(vehicleid == collectorveh) return 1;
	return 0;
}

CMD:vgall(playerid, const params[]) return cmd_vehgoldall(playerid, params);
CMD:vehgoldall(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 22) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

	if(sscanf(params, "ii",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить gold стоимость всех тс [ /vehgoldall Курс ]");
	if(params[0] > 10000 || params[0] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Курс не меньше 1 и не больше 10.000");

	for(new v = 0; v < 211 + sizeof(vehNameCustom) + 1; v++)
	{
		if(VehGos[v] > 0) VehGold[v] = VehGos[v]/params[0];
	}

	SaveVehicleGold();

	new string[144];
	format(string, sizeof(string), " [ ADM ]: %s изменил gold стоимости всех тс по курсу %d$", PlayerInfo[playerid][pName], params[0]);
 	ABroadCast(COLOR_ADM,string,1);
	AdminLog("vehgoldall", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "Gold цена тс");
	return 1;
}

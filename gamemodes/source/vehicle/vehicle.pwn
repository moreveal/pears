
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

new vehNameCustom[][] =
{
    "Lambo Murcielago", "BMW E36 328i", "BMW M4 G82", "Mercedes S63", "Acura Integra", "Hummer H2", "Nissan GT-R R35", 
	"Lancer Evolution IX", "Shkoda Octavia", "Mercedes C63", "Nissan 350Z", "Audi Q7", "BMW 530i", "BMW M6",
	"Mercedes G65", "Ford Raptor", "Audi RS5", "BMW M4 F82", "BMW X5M", "VW Gold", "Cadillac Fleetwood", "Dodge Charger",
	"Dodge Super Bee", "Ford GT", "Lamba Aventador", "Mercedes GLE 350", "Mercedes SL 65", "Nissan 240SX", "Porsche 911 GT2",
	"Shelby GT 500", "Supra MK5", "Toyota GT AE86","Prison Bus"
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
	2500000,1400000,7000000,4000000,90000000,6000000,7000000,1300000,3000000,3200000, // 2020 - 2029
	5000000,1200000,1300000 // 2030 - 2031
};

new vehSumma[] = // Гос цены на авто (Дефолтные)
{
    140000, 166000, 205000, 100, 60000, 95000, 2000, 1500, 100, // 400 - 408                          +
    390000, 61000, 1150000, 74000, 43000, 44000, 850000, 100, 3500000, 45500,  // 409 - 418          +
    86000, 90, 93000, 43000, 80, 125000, 777, 109000, 300, // 419 - 427                               +
    250, 900000, 777, 75000, 777, 200, 250, 777, 89000, 65000, // 428 - 437                          +
    70, 62000, 51000, 777, 64000, 100, 3900, 106000, 190000, 777, // 438 - 447                        +
    14000, 777, 777, 800000, 77000, 59000, 159000, 70000, 65000, 19000, 63000, // 448 - 458          +
    41000, 750000, 129000, 14000, 150000, 777, 777, 48000, 48000, // 459 - 467                        +
    120000, 5500000, 250, 37000, 25000, 9000, 47000, 52000, 5800, 550000, 21000, // 468 - 478     +
    27000, 85500, 2500, 42000, 34000, 86000, 13000, 150, 7800000, 7100000, 92000, // 479 - 489        +
    190, 62000, 61000, 230000, 565000, 940000, 81500, 1900, // 490 - 497                              +
    35000, 34000, 81500, 777, 533000, 535000, 167000, 102000, // 498 - 505                            +
    650500, 101000, 45000, 1800, 3100, 2900000, 1900000, 1800000, 80, 80, // 506 - 515               +
    71000, 76000, 77000, 4900, 777, 174000, 395000, 90, 47000, 40000, // 516 - 525                +
    41000, 42000, 300, 37000, 15000, 19000, 23000, 113000, 123500, 158000, // 526 - 535               +
    69500, 777, 777, 70, 81000, 1100000, 71500, 25000, 180, 181000, 54000, // 536 - 546               +
    62200, 870000, 37000, 159000, 90000, 39000, 4200000, 63000, 155000, 3900, 3900, // 547 - 557      +
    450000, 470000, 510000, 490000, 480000, 500, 777, 440000, 44000, 66000, 90, // 558 - 568          +
    777, 777, 7500, 7300, 280, 16000, 39000, 48000, 3200000, 65000, // 569 - 578                       +
    870000, 540000, 355000, 53000, 26000, 777, 83500, 141000, 145000, 40, 87500, // 579 - 589         +
    777, 777, 777, 1000000, 777, 49000, 200, 200, 200, // 590 - 598                                   +
    200, 42000, 1500, 91500, 89500, 29500, 27500, 777, 777, 777, // 599 - 608                          +
    37000, 777, 777 // 609 - 611                                                                      +
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
	AddVehicleSyncModel(589, 2019);	// VW Gold	(Club)						MQ
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
	AddVehicleSyncModel(431, 2032); // Prison Bus (Bus)					LQ
	return 1;
}

// Проверка на доступный транспорт
stock IsAVehExisting(v)
{
    if(v >= 400 && v <= 611 // Стандартный транспорт gta

    || v >= 2000 && v <= 2032) return 1; // Кастомный транспорт пирса
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

stock PP_CreateVehicle(id, model,Float:x,Float:y,Float:z,Float:a, col1, col2, sek, siren, timerspawn, Float:health)
{
	if(QuantityVehicles + 1 >= SKOKOCAROV) return -1; // Лимит транспортных средств на серверах SAMP

	id = m_custom_sync_CreateVehicle(model, x, y, z, a, col1, col2, sek, siren);

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

stock PP_AddStaticVehicleEx(modelID, Float: spawn_X, Float: spawn_Y, Float: spawn_Z, Float: z_Angle, color1, color2, respawn_Delay, siren, Float:health)
{
	new id = m_custom_sync_AddStaticVehEx(modelID, spawn_X, spawn_Y, spawn_Z, z_Angle, color1, color2, respawn_Delay, siren);

	LinkVehicleToInterior(id, 0);
	SetVehicleVirtualWorld(id, 0);

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
		if(!IsVehicleOpen(playerid, v)) continue;
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
		if(VehInfo[v][vModel] == 0) continue;
		if(GetVehicleInterior(v) != GetPlayerInterior(playerid) || GetVehicleVirtualWorld(v) != GetPlayerVirtualWorld(playerid)) continue;
		if(!IsVehicleOpen(playerid, v)) continue;
		if(!IsABoot(v)) continue;
		if(!GetVehicleNear_Boot(playerid, v)) continue;

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
        else if(IsPlayerInRangeOfPoint(playerid, 1.0, boot_veh[0], boot_veh[1], boot_veh[2])) sideId = 2; // Капот
	}
	else // Багажник сзади
	{
        GetCoordBonnetVehicle(v, bonet_veh[0], bonet_veh[1], bonet_veh[2]);
        GetCoordBootVehicle(v, boot_veh[0], boot_veh[1], boot_veh[2]);
		if(IsPlayerInRangeOfPoint(playerid, 1.0, bonet_veh[0], bonet_veh[1], bonet_veh[2])) sideId = 2; // Капот
        else if(IsPlayerInRangeOfPoint(playerid, 1.0, boot_veh[0], boot_veh[1], boot_veh[2]))
        {
            if(IsABoot(v)) sideId = 1; // Багажник
        }
	}
	return sideId;
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
	|| model >= 2000) type = 1;

    // Мототранспорт (Требуется лицензия на мото транспорт) Moto
    else if(model == 448 || model == 461 || model == 462 || model == 463 || model == 468 || model == 471 || model == 521
    || model == 522 || model == 523 || model == 571 || model == 581 || model == 586) type = 2;

    // Водный Транспорт (Требуется лицензия на катер) Boat
    else if(model == 430 || model == 446 || model == 452 || model == 453 || model == 454 || model == 472
    || model == 473 || model == 484 || model == 493 || model == 539 || model == 595) type = 3;

    // Вертолёты (Требуется лицензия на вертолёт) Helicopter
    else if(model == 417 || model == 425 || model == 447 || model == 469 || model == 487 || model == 488 || model == 497 
    || model == 548 || model == 563) type = 4;

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
	|| m == 2000 || m == 2002 || m == 2003 || m == 2020 || m == 2022 || m == 2023 || m == 2024) class = 1;

    // Middle Class (2) - Средний
    else if(m == 401 || m == 405 || m == 418 || m == 419 || m == 421 || m == 426 || m == 439 || m == 445 || m == 452 || m == 460
    || m == 461 || m == 463 || m == 468 || m == 469 || m == 471 || m == 480 || m == 484 || m == 487 || m == 491 || m == 496
    || m == 507 || m == 511 || m == 516 || m == 533 || m == 534 || m == 550 || m == 551 || m == 555 || m == 558 || m == 561
    || m == 581 || m == 585 || m == 587 || m == 589 || m == 602 || m == 603
	|| m == 2001 || m == 2006 || m == 2007 || m == 2008 || m == 2009 || m == 2010 || m == 2012 || m == 2013 || m == 2016
	|| m == 2017 || m == 2018 || m == 2026 || m == 2027 || m == 2028 || m == 2029 || m == 2030) class = 2;

    // Economy Class (3) - Бомж
    else if(m == 404 || m == 410 || m == 412 || m == 436 || m == 453 || m == 458 || m == 462 || m == 466 || m == 467 || m == 472
    || m == 474 || m == 475 || m == 479 || m == 492 || m == 512 || m == 513 || m == 517 || m == 518 || m == 526 || m == 527
    || m == 529 || m == 536 || m == 540 || m == 542 || m == 546 || m == 547 || m == 549 || m == 553 || m == 566 || m == 567
    || m == 575 || m == 576 || m == 593 || m == 595 || m == 600
	|| m == 2004 || m == 2019 || m == 2021 || m == 2031) class = 3;

    // Off-Road Class (4) - Внедорожник
    else if(m == 400 || m == 422 || m == 489 || m == 495 || m == 500 || m == 543 || m == 554 || m == 579
	|| m == 2005 || m == 2011 || m == 2014 || m == 2015 || m == 2025) class = 4;

    // Special Class (5) - Грузовая и Спец Техника
    else if(m == 403 || m == 413 || m == 414 || m == 417 || m == 440 || m == 455 || m == 456
    || m == 459 || m == 478 || m == 482 || m == 498 || m == 499 || m == 508 || m == 514 || m == 515 || m == 578) class = 5;

    // Unique Class (6) - Уникальный Транспорт
    else if(m == 423 || m == 424 || m == 431 || m == 434 || m == 437 || m == 442 || m == 443 || m == 444 || m == 457 || m == 473 
    || m == 476 || m == 481 || m == 483
    || m == 504 || m == 509 || m == 510 || m == 530 || m == 531 || m == 532 || m == 545 || m == 556 || m == 557 || m == 571 
    || m == 573 || m == 577 || m == 588 || m == 592) class = 6;

    // Goverment Class (7) - Государственный Транспорт
    else if(m == 406 || m == 407 || m == 408 || m == 416 || m == 420 || m == 425 || m == 427 || m == 428 || m == 430 || m == 432 
    || m == 438 || m == 447 || m == 448 || m == 470 || m == 485 || m == 486 || m == 488 || m == 490 || m == 497 || m == 520
    || m == 523 || m == 524 || m == 525 || m == 528 || m == 539 || m == 544 || m == 548 || m == 552 || m == 563 || m == 572 
    || m == 574 || m == 582 || m == 583 || m == 596 || m == 597 || m == 598 || m == 599 || m == 601 
	|| m == 2032) class = 7;

    else class = 0; // 0 Класс недоступен для продажи (неизвестный транспорт)
    return class;
}

stock IsABoot(carid) // Транспорт, у которых есть багажник
{
	new model = VehInfo[carid][vModel];
	if(model == 400 || model == 401 || model == 402 || model == 404 || model == 405 || model == 409 || model == 410 || model == 411 || model == 412 || model == 413
    || model == 415 || model == 418 || model == 419 || model == 420 || model == 421 || model == 422 || model == 426 || model == 429 || model == 433 || model == 434 || model == 436
    || model == 438 || model == 439 || model == 440 || model == 442 || model == 444 || model == 445 || model == 451 || model == 458 || model == 459 || model == 466 || model == 467
    || model == 470 || model == 474 || model == 475 || model == 477 || model == 479 || model == 480 || model == 483 || model == 489 || model == 490 || model == 491
    || model == 492 || model == 494 || model == 495 || model == 496 || model == 498 || model == 500 || model == 502 || model == 503 || model == 504 || model == 505 || model == 506
    || model == 507 || model == 516 || model == 517 || model == 518 || model == 526 || model == 527 || model == 528 || model == 529 || model == 533 || model == 534 || model == 535
    || model == 536 || model == 540 || model == 541 || model == 542 || model == 543 || model == 545 || model == 546 || model == 547 || model == 549 || model == 550 || model == 551
    || model == 554 || model == 555 || model == 556 || model == 557 || model == 558 || model == 559 || model == 560 || model == 561 || model == 562 || model == 565 || model == 566
    || model == 567 || model == 573 || model == 575 || model == 576 || model == 579 || model == 580 || model == 585 || model == 587 || model == 589 || model == 596 || model == 597
    || model == 598 || model == 599 || model == 600 || model == 601 || model == 602 || model == 603 || model == 604 || model == 605 || model == 609
	|| model >= 2000 && model <= 2031) return 1;
	return 0;
}

stock IsABootFront(carid)
{
	new model = VehInfo[carid][vModel];
	if(model == 415 || model == 424 || model == 451 || model == 483 || model == 486 || model == 541 || model == 568
	|| model == 2000 || model == 2023 || model == 2024 || model == 2028) return 1;
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
	|| model == 2027 || model == 2028 || model == 2029 || model == 2030 || model == 2031) return 1;
	return 0;
}
stock IsA_Gen10(carid) // 10 слотов в багажнике
{
	new model = VehInfo[carid][vModel];
	if(model == 418 || model == 422 || model == 444 || model == 543 || model == 554 || model == 556 || model == 557 || model == 600 || model == 605
	|| model == 2005 || model == 2011 || model == 2014 || model == 2018 || model == 2025) return 1;
	return 0;
}

stock IsA_Gen15(carid) // 15 слотов в багажнике
{
	new model = VehInfo[carid][vModel];
	if(model == 413 || model == 414 || model == 440 || model == 459 || model == 478 || model == 482 || model == 498 || model == 499 || model == 609
	|| model == 2015) return 1;
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
	|| model == 2015 || model == 2018 || model == 2020 || model == 2021 || model == 2025) return 1;
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
	new max_line = 50, yesNext;
	new line[214],lines[4096];

	DP[0][playerid] = 0; // Строки на текущей странице
	if(page == 0)
	{
		if(OnlineInfo[playerid][oSorting][0] > 0 && OnlineInfo[playerid][oSorting][0] != 1066) ClearSorting(playerid);
        OnlineInfo[playerid][oSorting][0] = 1066;

		DP[1][playerid] = 0; // Страница
		DP[2][playerid] = 0; // Последний vehicleList на странице
		DP[4][playerid] = 0; // Первый vehicleList на странице
		DP[5][playerid] = 0; // Информация о последней странице
	}

	new minlist = 0, thisPage;
    if(page > 0)
	{
		if(page == DP[1][playerid]) minlist = DP[4][playerid], thisPage = 1; // Если открывается та-же самая страница, показываем первый vehicleList
		else minlist = DP[2][playerid] + 1; // В другом случае открываем последний vehicleList (+ 1 для следующей страницы)
		DP[1][playerid] = page;
	}

    if((minlist >= 211 + sizeof(vehNameCustom) + 1 || DP[5][playerid] == 1) && thisPage == 0) // Сбрасываем страницы, если последний лист максимальный или больше
	{
		DP[1][playerid] = 0; // Страница
		DP[2][playerid] = 0; // Последний vehicleList на странице
		DP[4][playerid] = 0; // Первый vehicleList на странице
		DP[5][playerid] = 0; // Информация о последней странице
		minlist = 0, page = 0;
	}

	format(line,sizeof(line),"{cccccc}Транспорт [Модель]\t{cccccc}Цена\t{cccccc}Gold\t{cccccc}Куплено за Вирты / Gold"), strcat(lines,line);
	if(IsActiveSorting(playerid)) format(line,sizeof(line),"\n{ff9000}Фильтр {99ff66}[Активен]\t\t\t"), strcat(lines,line);
    else format(line,sizeof(line),"\n{ff9000}Фильтр\t\t\t"), strcat(lines,line);

	new one;
	for(new v = minlist; v < 211 + sizeof(vehNameCustom) + 1; v++)
	{
		if(one == 0) DP[4][playerid] = v, one = 1; // Записывали первый vehicleList

		if(CheckSortingLineVehPrice(playerid, v)) format(line,sizeof(line),"%s", ShowLineVehPrice(playerid, v)), strcat(lines,line);

		if(DP[0][playerid] >= max_line) // Сбрасываем дальнейший вывод строк, если дошли до лимита на странице
        {
			yesNext = 1;
            break;
        }

		if(v >= 211 + sizeof(vehNameCustom) && page > 0)
		{
			yesNext = 1; // Последний транспорт, отображаем Next Page
			DP[5][playerid] = 1; // Записываем, что эта страница была последней
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

	if(!strcmp(OnlineInfo[playerid][oSortingName],"0",true)) {} // Фильтр по названию не включен
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

    List[DP[0][playerid]][playerid] = vehicleList;
    DP[0][playerid] ++; // Подсчитываем строки
	DP[2][playerid] = vehicleList;

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

stock VehPriceSorting(playerid)
{
	new line[90],lines[360];
    format(line,sizeof(line),"{cccccc}Сортировка\t{cccccc}Значение"), strcat(lines,line);

    if(OnlineInfo[playerid][oSorting][1] == 0) format(line,sizeof(line),"\n{cccccc}Модель:\t{ff9000}Все"), strcat(lines,line);
	else format(line,sizeof(line),"\n{cccccc}Модель:\t{99ff66}%d", OnlineInfo[playerid][oSorting][1]), strcat(lines,line);

	if(!strcmp(OnlineInfo[playerid][oSortingName],"0",true)) format(line,sizeof(line),"\n{cccccc}Название:\t{ff9000}Все"), strcat(lines,line);
	else format(line,sizeof(line),"\n{cccccc}Название:\t{ff9000}%s", OnlineInfo[playerid][oSortingName]), strcat(lines,line);

    format(line,sizeof(line),"\n{cccccc}Сбросить Фильтры\t"), strcat(lines,line);

    ShowDialog(playerid,1063,DIALOG_STYLE_TABLIST_HEADERS,"Гос Стоимость Транспорта",lines,"Выбрать","Назад");
    return 1;
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
	if(dialogid == 1063) // Настройки фильтра
	{
        if(response)
        {
            if(listitem == 0)
            {
				ShowDialog(playerid,999,DIALOG_STYLE_INPUT,"Фильтр","{cccccc}Введите ID модели транспорта","Принять","Отмена");
            }
            if(listitem == 1)
            {
                ShowDialog(playerid,983,DIALOG_STYLE_INPUT,"Фильтр","{cccccc}Введите название транспорта \nМожно не полное название\n1 - 30 символов","Принять","Отмена");
            }
            if(listitem == 2) // Сбросить Фильтр
            {
				ReloadSorting(playerid, 1066);
				VehPriceSorting(playerid);
            }
        }
        else vehprice(playerid, 0);
	}
	else if(dialogid == 1066)
	{
		if(response)
		{
			if(listitem == 0) VehPriceSorting(playerid);

			if(DP[0][playerid] > 0) // Есть строки на странице
			{
				if(listitem >= 1 && listitem <= DP[0][playerid]) // Отображаемые List
				{
					new vehicleList = List[listitem-1][playerid];
					DP[3][playerid] = vehicleList;
					SettingGosPriceVehicle(playerid, vehicleList);
				}
				else if(listitem == DP[0][playerid] + 1) vehprice(playerid, DP[1][playerid] + 1); // Следующая страница
			}
		}
		else cmd_economy(playerid);
	}
	else if(dialogid == 1067)
	{
		if(response)
		{
			new input = strval(inputtext);
			new vehicleList = DP[3][playerid];
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
			SettingGosPriceVehicle(playerid, DP[3][playerid]);
     		OrgLog(7, "minfin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", input, GetVehicleName(v));

			// Сбрасываем ценники в Бизнесах: Все Аренды Транспорта, Автосалоны, Мотосалоны, Авиасалоны, Салоны Катеров
     		for(new b = 42; b < 92; b++) ResetBizzPriceItem(playerid, b, v, 5, input);
		}
		else SettingGosPriceVehicle(playerid, DP[3][playerid]);
	}
	else if(dialogid == 999) // Фильтр по id модели
	{
        if(response)
        {
			new input = strval(inputtext);
			if(input < 1 || input > 10000) return ErrorText(playerid, "{FF6347}Не меньше 1 и не больше 10000 (400 - 612, 2000 и выше - кастомные авто)"), VehPriceSorting(playerid);
			OnlineInfo[playerid][oSorting][1] = input;
            PlayerPlaySound(playerid,6401,0,0,0);
            VehPriceSorting(playerid);
        }
        else VehPriceSorting(playerid);
    }
	else if(dialogid == 983) // Фильтр по названию
	{
        if(response)
        {
			if(!strlen(inputtext)) return ErrorText(playerid, "{FF6347}Вы ничего не ввели"), VehPriceSorting(playerid);
			if(strlen(inputtext) < 1 || strlen(inputtext) > 30) return ErrorText(playerid, "{FF6347}1 - 30 символов"), VehPriceSorting(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "{FF6347}Вы используете запрещённый символ"), VehPriceSorting(playerid);

			format(OnlineInfo[playerid][oSortingName], 64,"%s", inputtext);
            PlayerPlaySound(playerid,6401,0,0,0);
            VehPriceSorting(playerid);
        }
        else VehPriceSorting(playerid);
    }
	else if(dialogid == 1086)
	{
		if(response)
		{
			new vehicleList = DP[3][playerid];
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
		else vehprice(playerid, DP[1][playerid]);
	}
	else if(dialogid == 1133)
	{
		if(response)
		{
			new vehicleList = DP[3][playerid];
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
  			SettingGosPriceVehicle(playerid, DP[3][playerid]);

			format(string,sizeof(string),"%dG %s", input, GetVehicleName(v));
			AdminLog("vehgold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", v, string);
		}
		else SettingGosPriceVehicle(playerid, DP[3][playerid]);
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
	CustomVehLabel[playerid][vehicleid] = CreatePlayer3DTextLabel(playerid, string, 0xA9C4E4FF, 0.0,0.0,0.0 + 0.2, dist, INVALID_PLAYER_ID, vehicleid, 0);
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

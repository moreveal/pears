
#include "../gamemodes/source/custom/vehicle_custom.pwn" // pwn для добавления новых тс в мод

#define MAX_MODELS_VEHICLE 212 + MAX_VEHICLE_CUSTOM // Количество моделей транспорта на сервере

new VehGos[MAX_MODELS_VEHICLE]; // Стоимости транспорта
new VehGold[MAX_MODELS_VEHICLE]; // Gold стоимости транспорта
new VehBuy[MAX_MODELS_VEHICLE]; // Подсчет покупок транспорта за вирты
new VehBuyGold[MAX_MODELS_VEHICLE]; // Подсчет покупок транспорта за голду
new VehLimited[MAX_MODELS_VEHICLE]; // Информация о лимитированном транспорте
new VehQuan[MAX_MODELS_VEHICLE]; // Количество на руках игроков транспортных средств
new VehSale[MAX_MODELS_VEHICLE]; // Статус доступности продажи транспорта (1 продаётся, 0 нет)
new VehLimitedCase[MAX_MODELS_VEHICLE]; // Статус лимитированного транспорта, выданного в кейсах в данный момент

new vehClassName[][] =
{
    "Undefiend", "Premium", "Middle", "Economy", "Off-Road", "Special", "Unique", "Government", "Limited"
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

stock GetVehicleName(model)
{
	new vehicleName[34];
	if(model >= 400 && model <= 611) format(vehicleName, sizeof(vehicleName), "%s", vehName[model - 400]);
	else if(model >= 2000) 
	{
		if(model - 2000 >= sizeof(vehNameCustom)) format(vehicleName, sizeof(vehicleName), "Unknown");
		else format(vehicleName, sizeof(vehicleName), "%s", vehNameCustom[model - 2000]);
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
	v = CorrectVehicleID(v);
	return VehGos[v];
}

stock GetVehiclePriceGold(v)
{
	v = CorrectVehicleID(v);
	return VehGold[v];
}

stock GetVehicleSpeedMax(v)
{
	new speed;
	if(v >= 400 && v <= 611) speed = vehSpeed[v - 400];
	else speed = vehSpeed[GetVehModelOriginal(v) - 2000];
	return speed;
}

/* СУПЕР ПУПЕР ВАЖНО добавляя новые диапазоны моделей транспорта
stock GetVehicleModelSync
stock ReadVehicleIDE
CS_RPC_WorldVehicleAdd
*/

stock GetVehicleModelSync(playerid, model) // Получаем модель транспорта с учётом наличия модпака +
{
    new vehId;
    if(playerid == -1 || IsPlayerSyncModels(playerid)) // Мод установлен
	{
		if(model >= 612 && model <= 2101) model += 13066;
		else if(model >= 2102) model += 13164;
		vehId = model;
	}
    else vehId = GetVehModelOriginal(model);
    return vehId;
}

stock PP_CreateVehicle(model, Float:x, Float:y, Float:z, Float:a, col1, col2, sek, siren, timerspawn, Float:health)
{
	if(QuantityVehicles + 1 >= MAX_CARS) return -1; // Лимит транспортных средств на серверах SAMP

	new id = m_custom_sync_CreateVehicle(model, x, y, z, a, col1, col2, sek, bool: siren);
	if (id == INVALID_VEHICLE_ID) return -1; // Ошибка при создании транспорта

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

	if(!health) health = MaxVehicleHealth(model, id);
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

	if(!health) health = MaxVehicleHealth(modelID, id);
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
	foreach (new v : Vehicle)
	{
		if (!IsVehicleStreamedIn(v, playerid)) continue;

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

	if(vehicleid >= 0)
	{
		if(!IsAMoto(VehInfo[vehicleid][vModel]) && !IsABoat(VehInfo[vehicleid][vModel]) && !IsAPlane(VehInfo[vehicleid][vModel]))
		{
			if (type == 1 && !GetVehicleNear_Boot(playerid, vehicleid)) return 0;
			else if (type == 2 && !GetVehicleNear_Bonet(playerid, vehicleid)) return 0;
		}
	}

	return vehicleid;
}
stock IsAPosBoot(playerid) // Ищем транспорт с багажником рядом
{
	new vehicleid;
	for(new v = 0; v < MAX_CARS; v++)
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
	for(new v = 0; v < MAX_CARS; v++)
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
        if(IsPlayerInRangeOfPoint(playerid, 2.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
    else // Багажник сзади
    {
        GetCoordBootVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 2.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
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
		if(IsPlayerInRangeOfPoint(playerid, 2.0, bonet_veh[0], bonet_veh[1], bonet_veh[2])) 
        {
            if(IsABoot(v)) sideId = 1; // Багажник
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2.0, boot_veh[0], boot_veh[1], boot_veh[2])) 
		{
			if(!IsANoEngine(VehInfo[v][vModel])) sideId = 2; // Капот
		}
	}
	else // Багажник сзади
	{
        GetCoordBonnetVehicle(v, bonet_veh[0], bonet_veh[1], bonet_veh[2]);
        GetCoordBootVehicle(v, boot_veh[0], boot_veh[1], boot_veh[2]);
		if(IsPlayerInRangeOfPoint(playerid, 2.0, bonet_veh[0], bonet_veh[1], bonet_veh[2])) 
		{
			if(!IsANoEngine(VehInfo[v][vModel])) sideId = 2; // Капот
		}
        else if(IsPlayerInRangeOfPoint(playerid, 2.0, boot_veh[0], boot_veh[1], boot_veh[2]))
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

CMD:azot(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(IsPlayerInAnyVehicle(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(!IsACar(VehInfo[vehicleid][vModel])) return ErrorMessage(playerid, "{FF6347}Вы не в автомобиле");
		AddVehicleComponent(vehicleid, 1010);
		ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Азот установлен на транспорт","*","");
	}
	else ErrorMessage(playerid, "{FF6347}Вы не в транспорте");
	return true;
}

CMD:tun(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(IsPlayerInAnyVehicle(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(!IsACar(VehInfo[vehicleid][vModel])) return ErrorMessage(playerid, "{FF6347}Вы не в автомобиле");

		SetVehicleTopTunning(vehicleid);
		ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Полный пиздатый тюн установлен на транспорт (Без сохранения в базу)","*","");
	}
	else ErrorMessage(playerid, "{FF6347}Вы не в транспорте");
	return true;
}

CMD:tungro(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

	new quan;
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	for(new vehicleid = 1; vehicleid < MAX_CARS; vehicleid++)
	{
		if(!IsValidVehicle(vehicleid)) continue; // Транспорта не существует
		if(Cars[vehicleid] != 9999) continue; // Транспорт не создан через /veh
		if(!IsACar(VehInfo[vehicleid][vModel])) continue; // Транспорт не авто
		if(GetVehicleInterior(vehicleid) != GetPlayerInterior(playerid) 
			|| GetVehicleVirtualWorld(vehicleid) != GetPlayerVirtualWorld(playerid)) continue; // Транспорт в другом мире или инте

		if(GetVehicleDistanceFromPoint(vehicleid, X, Y, Z) <= 30.0) 
		{
			SetVehicleTopTunning(vehicleid);
			quan ++;
		}
	}
	if(quan == 0) return ErrorMessage(playerid, "{FF6347}Рядом с вами нет созданных тс");
	new string[144];
    format(string, sizeof(string), " [ ADM ]: %s установил тюн созданному транспорту в 30 метров от себя (%d тс)", PlayerInfo[playerid][pName], quan);
    ABroadCast(COLOR_ADM,string,1);
    AdminLog("tungro", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
	return true;
}

stock SetVehicleTopTunning(vehicleid)
{
	for(new i = 0; i < MAX_TUNNING_VEHICLE; i++)
	{
		if(VehInfo[vehicleid][vTunningID][i] > 0) VehInfo[vehicleid][vTunningID][i] = 0;
	}

	VehInfo[vehicleid][vTunningID][0] = 224; // Philin Customs
	VehInfo[vehicleid][vTunningID][1] = 214; // HPRacing
	VehInfo[vehicleid][vTunningID][2] = 216; // KONI suspension
	VehInfo[vehicleid][vTunningID][3] = 220; // Falken Tire
	VehInfo[vehicleid][vTunningID][4] = 223; // Wilwood

	SetHandlingTotal(vehicleid);
	return true;
}

alias:cleartun("rtun")
CMD:cleartun(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(IsPlayerInAnyVehicle(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(!IsACar(VehInfo[vehicleid][vModel])) return ErrorMessage(playerid, "{FF6347}Вы не в автомобиле");

		for(new i = 0; i < MAX_TUNNING_VEHICLE; i++)
		{
			if(VehInfo[vehicleid][vTunningID][i] > 0) VehInfo[vehicleid][vTunningID][i] = 0;
		}
		
		SetHandlingTotal(vehicleid, true);
		ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Весь тюнинг удалён с транспорта (Без сохранения в базу)","*","");
	}
	else ErrorMessage(playerid, "{FF6347}Вы не в транспорте");
	return true;
}

alias:wheel("wheels", "whel", "whels")
CMD:wheel(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(IsPlayerInAnyVehicle(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(!IsACar(VehInfo[vehicleid][vModel])) return ErrorMessage(playerid, "{FF6347}Вы не в автомобиле");
		if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Установить диски на транспорт /wheel ID модели");
		if(!IsAWheelForVehicles(params[0])) return ErrorMessage(playerid, "{FF6347}Этот id нельзя установить в качестве дисков на транспорт");
		AddVehicleComponent(vehicleid, params[0]);
		PlayerPlaySound(playerid,40404,0,0,0);
	}
	else ErrorMessage(playerid, "{FF6347}Вы не в транспорте");
	return true;
}

CMD:paint(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(IsPlayerInAnyVehicle(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(IsAVehiclesPaintJob(VehInfo[vehicleid][vModel]) == 0) return ErrorMessage(playerid, "{FF6347}На этот транспорт нельзя установить покрасочную работу");
		if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Установить покрасочную работу на транспорт /paint ID paintjob (3 - удалить)");

		ChangeVehiclePaintjob(vehicleid, params[0]);
		PlayerPlaySound(playerid,1134,0,0,0);
	}
	else ErrorMessage(playerid, "{FF6347}Вы не в транспорте");
	return true;
}

stock GetVehicleSale(model) {
	new vehsale_model = model - 400;
	if (model >= 2000) vehsale_model = model - 2000 + 212;
	return VehSale[vehsale_model];
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
	for(new v = 0; v < MAX_CARS; v++)
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

stock MaxVehicleHealth(model, vehicleid = 0)
{
	new maxhealth;
    if(model == 428 || model == 470 || model == 528) maxhealth = 3000;
    else if(model == 427 || model == 433 || model == 425 || model == 548 || model == 601) maxhealth = 4000;
    else if(model == 432) maxhealth = 6000;
	else if(model == 537 || model == 538 || model == 2032) maxhealth = 10000; // train
    else maxhealth = 2000;

	if(vehicleid > 0) maxhealth += floatround(VehInfo[vehicleid][vArmor], floatround_round);
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

    // Если транспорт кастомный, то мы получаем его тип по его заменке без лаунчера
    if(model >= 2000) model = GetVehModelOriginal(model);

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
    || model == 603 || model == 604 || model == 605 || model == 609) type = 1;


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

    // Если не указать тип, то он будет 0 и лицензия не будет требоваться
    return type;
}

// Транспорт, у которых есть багажник
stock IsABoot(carid)
{
	new model = VehInfo[carid][vModel];

    // Если транспорт кастомный, то мы получаем наличие багажника по его заменке без лаунчера
    if(model >= 2000) model = GetVehModelOriginal(model);

	if(model == 400 || model == 401 || model == 402 || model == 404 || model == 405 || model == 409 || model == 410 || model == 411 || model == 412 || model == 413
    || model == 415 || model == 416 || model == 418 || model == 419 || model == 420 || model == 421 || model == 422 || model == 426 
    || model == 428 || model == 429 || model == 433 || model == 434 || model == 436
    || model == 438 || model == 439 || model == 440 || model == 442 || model == 444 || model == 445 || model == 451 || model == 458 || model == 459 
    || model == 466 || model == 467
    || model == 470 || model == 474 || model == 475 || model == 477 || model == 479 || model == 480 || model == 489 || model == 490 || model == 491
    || model == 492 || model == 494 || model == 495 || model == 496 || model == 498 || model == 500 || model == 502 || model == 503 || model == 504 
    || model == 505 || model == 506
    || model == 507 || model == 516 || model == 517 || model == 518 || model == 526 || model == 527 || model == 528 || model == 529 || model == 533 
    || model == 534 || model == 535
    || model == 536 || model == 540 || model == 541 || model == 542 || model == 543 || model == 545 || model == 546 || model == 547 || model == 549 
    || model == 550 || model == 551
    || model == 554 || model == 555 || model == 556 || model == 557 || model == 558 || model == 559 || model == 560 || model == 561 || model == 562 
    || model == 565 || model == 566
    || model == 567 || model == 573 || model == 575 || model == 576 || model == 579 || model == 580 || model == 585 || model == 587 || model == 589 
    || model == 596 || model == 597
    || model == 598 || model == 599 || model == 600 || model == 602 || model == 603 
    || model == 604 || model == 605 || model == 609) return 1;
	return 0;
}

// Транспорт, у которых багажник спереди, а двигатель сзади
stock IsABootFront(carid)
{
	new m = VehInfo[carid][vModel];

    // Если транспорт кастомный, то мы получаем расположение багажника по его заменке без лаунчера
    if(m >= 2000) m = GetVehModelOriginal(m);

	if(m == 415 || m == 424 || m == 437 || m == 451 || m == 483 || m == 486 || m == 530 || m == 532 
	|| m == 541 || m == 568 || m == 588 || m == 601) return 1;
	return 0;
}

stock IsA_Gen5(carid) // 5 слотов в багажнике
{
	new model = VehInfo[carid][vModel];

	// Если транспорт кастомный, то мы получаем количество слотов багажника по его заменке без лаунчера
    if(model >= 2000) model = GetVehModelOriginal(model);

	if(model == 400 || model == 401 || model == 402 || model == 404 || model == 405 || model == 409 || model == 410 || model == 411 || model == 412 || model == 415
    || model == 419 || model == 420 || model == 421 || model == 426 || model == 429 || model == 434 || model == 436 || model == 438 || model == 439 || model == 442 || model == 445
    || model == 451 || model == 458 || model == 466 || model == 467 || model == 474 || model == 475 || model == 477 || model == 479 || model == 480 || model == 489
    || model == 490 || model == 491 || model == 492 || model == 495 || model == 496 || model == 500 || model == 504 || model == 505 || model == 506 || model == 507 || model == 516
    || model == 517 || model == 518 || model == 526 || model == 527 || model == 529 || model == 533 || model == 534 || model == 536 || model == 540 || model == 541 || model == 542
    || model == 545 || model == 546 || model == 547 || model == 549 || model == 550 || model == 551 || model == 555 || model == 558 || model == 559 || model == 560 || model == 561
    || model == 562 || model == 565 || model == 566 || model == 567 || model == 575 || model == 576 || model == 580 || model == 585 || model == 587 || model == 589
    || model == 596 || model == 597 || model == 598 || model == 599 || model == 602 || model == 603 || model == 604) return 1;
	return 0;
}

stock IsA_Gen10(carid) // 10 слотов в багажнике
{
	new model = VehInfo[carid][vModel];

	// Если транспорт кастомный, то мы получаем количество слотов багажника по его заменке без лаунчера
    if(model >= 2000) model = GetVehModelOriginal(model);

	if(model == 418 || model == 422 || model == 444 || model == 543 || model == 554 || model == 556 || model == 557 || model == 600 || model == 605) return 1;
	return 0;
}

stock IsA_Gen15(carid) // 15 слотов в багажнике
{
	new model = VehInfo[carid][vModel];

	// Если транспорт кастомный, то мы получаем количество слотов багажника по его заменке без лаунчера
    if(model >= 2000) model = GetVehModelOriginal(model);

	if(model == 413 || model == 414 || model == 440 || model == 459 || model == 478 || model == 482 || model == 498 || model == 499 || model == 609) return 1;
	return 0;
}

stock IsATaxi(carid) // Транспорт, который разрешён для работы в такси
{
	new model = VehInfo[carid][vModel];

	// Если транспорт кастомный, то мы получаем доступ к работе в такси по его заменке безе лаунчера
    if(model >= 2000) model = GetVehModelOriginal(model);

	if(model >= 400 && model <= 424 || model >= 426 && model <= 429 || model == 431 || model == 433 || model == 434 || model >= 436 && model <= 440 || model >= 442 && model <= 445
 	|| model == 447 || model == 448 || model == 451 || model >= 455 && model <= 463 || model >= 466 && model <= 471 || model == 474 || model == 475 || model >= 477 && model <= 480
 	|| model == 482 || model == 483 || model >= 487 && model <= 492 || model >= 494 && model <= 500 || model >= 502 && model <= 508 || model == 511 || model >= 514 && model <= 518
 	|| model >= 521 && model <= 529 || model >= 533 && model <= 536 || model >= 540 && model <= 552 || model >= 554 && model <= 563 || model >= 565 && model <= 567
 	|| model >= 573 && model <= 576 || model >= 578 && model <= 582 || model >= 585 && model <= 589 
	|| model == 593 || model >= 596 && model <= 605 || model == 609) return 1;
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
	// Если транспорт кастомный, то мы получаем инфу о задних дверях по его заменке без лаунчера
    if(model >= 2000) model = GetVehModelOriginal(model);

    if(model == 404 || model == 405 || model == 409 || model == 420 || model == 421 || model == 426 || model == 438
	|| model == 445 || model == 458 || model == 466 || model == 467 || model == 470 || model == 479 || model == 490
 	|| model == 492 || model == 507 || model == 516 || model == 529 || model == 540 || model == 546 || model == 547
  	|| model == 550 || model == 551 || model == 560 || model == 561 || model == 566 || model == 579 || model == 580
   	|| model == 585 || model == 596 || model == 597 || model == 598 || model == 604) return 1;
	return 0;
}

stock IsABus(model)
{
	if(model == 431 || model == 437 || model == 2095
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
  	|| model == 601 || model == 609 || model == 455 || model == 531 || model == 2095) return 1;
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
	for(new v = 0; v < MAX_CARS; v++)
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
	new line[214], atext[14];
	new vehicleList = v;
	v = CorrectVehicleList(vehicleList);

    List[OnlineInfo[playerid][oDialogMenu][0]][playerid] = vehicleList;
    OnlineInfo[playerid][oDialogMenu][0] ++; // Подсчитываем строки
	OnlineInfo[playerid][oDialogMenu][2] = vehicleList;

	if(VehLimited[vehicleList] > 0) atext = "D39EE0"; // Лимитированный транспорт
	else
	{
		if(v >= 2000) atext = "0088ff"; // Custom
		else atext = "cccccc"; // Обычный транспорт
	}

	if(VehSale[vehicleList]) format(line,sizeof(line),"\n{%s}%s {cccccc}[%d]\t{99ff66}%d$ {cccccc}[%s]\t{ffcc00}%dG\t{cccccc}%d / %d", atext, GetVehicleName(v), v, VehGos[vehicleList], get_k(VehGos[vehicleList]), VehGold[vehicleList], VehBuy[vehicleList], VehBuyGold[vehicleList]);
    else format(line,sizeof(line),"\n{%s}%s {cccccc}[%d]\t%d$ {cccccc}[%s]\t%dG\t{cccccc}%d / %d", atext, GetVehicleName(v), v, VehGos[vehicleList], get_k(VehGos[vehicleList]), VehGold[vehicleList], VehBuy[vehicleList], VehBuyGold[vehicleList]);
	return line;
}

stock SettingGosPriceVehicle(playerid, vehicleList)
{
	new v = CorrectVehicleList(vehicleList);

	new line[120],lines[360];
    if(v >= 2000) format(line,sizeof(line),"{0088ff}%s\t \t", GetVehicleName(v)), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}%s\t \t", GetVehicleName(v)), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Стоимость:\t{99ff66}%d$ {cccccc}[%s] \t", VehGos[vehicleList], get_k(VehGos[vehicleList])), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Gold:\t{ffcc00}%dG \t", VehGold[vehicleList]), strcat(lines,line);
	if(VehLimited[vehicleList] == 0) format(line,sizeof(line),"\n{cccccc}Limited:\t{99ff66}Не ограничено \t"), strcat(lines,line);
	else format(line,sizeof(line),"\n{cccccc}Limited:\t{D39EE0}%d \t На руках %d", VehLimited[vehicleList], VehQuan[vehicleList]), strcat(lines,line);

	if(VehSale[vehicleList]) format(line,sizeof(line),"\n{cccccc}Доступ к продаже:\t{99ff66}[ On ]"), strcat(lines,line);
	else format(line,sizeof(line),"\n{cccccc}Доступ к продаже:\t{FF6347}[ Off ]"), strcat(lines,line);
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

stock CorrectVehicleID(model)
{
	if(model >= 2000) model -= 1788;
	else if(model >= 400 && model <= 611) model -= 400;
	return model;
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
		else pc_cmd_economy(playerid);
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
				if(PlayerInfo[playerid][pSoska] < 20) return ErrorText(playerid, "{FF6347}Только для администраторов 20+ уровня"), SettingGosPriceVehicle(playerid, vehicleList);

				new line[100],lines[300];
				format(line,sizeof(line),"{cccccc}Введите Gold стоимость для {ff9000}%s", GetVehicleName(v)), strcat(lines,line);
				format(line,sizeof(line),"\n\n{cccccc}Текущая Стоимость: {ffcc00}%dG", VehGold[vehicleList]), strcat(lines,line);
				format(line,sizeof(line),"\n{cccccc}Не меньше 0G и не больше 100.000G"), strcat(lines,line);
				ShowDialog(playerid,1133,DIALOG_STYLE_INPUT,"Гос Стоимость Транспорта",lines,"Принять","Отмена");
			}
			else if(listitem == 2)
			{
				if(PlayerInfo[playerid][pSoska] < 20) return ErrorText(playerid, "{FF6347}Только для администраторов 20+ уровня"), SettingGosPriceVehicle(playerid, vehicleList);

				new line[100],lines[600];
				format(line,sizeof(line),"{cccccc}Введите лимитированность для {ff9000}%s", GetVehicleName(v)), strcat(lines,line);
				if(VehLimited[vehicleList] == 0) format(line,sizeof(line),"\n\n{cccccc}Текущее количество: {99ff66}Не ограничено"), strcat(lines,line);
				else format(line,sizeof(line),"\n\n{cccccc}Текущее количество: {D39EE0}%d", VehLimited[vehicleList]), strcat(lines,line);
				format(line,sizeof(line),"\n{cccccc}Не меньше 0 и не больше 100.000"), strcat(lines,line);
				format(line,sizeof(line),"\n\n{FF6347}Внимание! {ffcc66}Лимит влияет только на рандомное выпадение"), strcat(lines,line);
				format(line,sizeof(line),"\n{ffcc66}Примеры: Кейсы, Контейнеры"), strcat(lines,line);
				ShowDialog(playerid,1139,DIALOG_STYLE_INPUT,"Гос Стоимость Транспорта",lines,"Принять","Отмена");
			}
			else if(listitem == 3)
			{
				if(PlayerInfo[playerid][pSoska] < 20) return ErrorText(playerid, "{FF6347}Только для администраторов 20+ уровня"), SettingGosPriceVehicle(playerid, vehicleList);

				if(VehSale[vehicleList]) VehSale[vehicleList] = 0;
				else VehSale[vehicleList] = 1;
				SaveVehicleSale(vehicleList);
				SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);

				// Пересобираем подарки с транспортом
				CreateVehicleGiftCase();

				new log_str[128];
				new model = vehicleList + 400;
				if (vehicleList >= 212) model = vehicleList + 2000 - 212;
				format(log_str, sizeof(log_str), "Транспорт %s [ID: %d]", GetVehicleName(model), model);
				OrgLog(7, "salechange", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", VehSale[vehicleList], log_str);
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
			if(input < 0 || input > 100000) return ErrorText(playerid, "{FF6347}Не меньше 0G и не больше 100.000G"), SettingGosPriceVehicle(playerid, vehicleList);
			VehGold[vehicleList] = input;

			new v = CorrectVehicleList(vehicleList);
			PlayerPlaySound(playerid, 6401, 0,0,0);

			SaveVehicleGold(vehicleList);

			new string[180];
			format(string,sizeof(string),"[ Мысли ]: Gold стоимость %s теперь составляет: {ffcc00}%dG", GetVehicleName(v), VehGold[vehicleList]);
  			SendClientMessage(playerid,COLOR_GREY,string);
  			SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);

			format(string,sizeof(string),"%dG %s", input, GetVehicleName(v));
			AdminLog("vehgold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", v, string);
		}
		else SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);
	}
	else if(dialogid == 1139)
	{
		if(response)
		{
			new vehicleList = OnlineInfo[playerid][oDialogMenu][3];
			if(PlayerInfo[playerid][pSoska] < 20) return ErrorText(playerid, "{FF6347}Только для администраторов 20+ уровня"), SettingGosPriceVehicle(playerid, vehicleList);
			new input = strval(inputtext);
			if(input < 0 || input > 100000) return ErrorText(playerid, "{FF6347}Не меньше 0 и не больше 100.000"), SettingGosPriceVehicle(playerid, vehicleList);
			VehLimited[vehicleList] = input;

			new v = CorrectVehicleList(vehicleList);
			PlayerPlaySound(playerid, 6401, 0,0,0);

			SaveVehicleLimited(vehicleList);

			new string[180];
			format(string,sizeof(string),"[ Мысли ]: Limited Vehicle %s теперь составляет: {D39EE0}%d", GetVehicleName(v), VehLimited[vehicleList]);
  			SendClientMessage(playerid,COLOR_GREY,string);
  			SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);

			format(string,sizeof(string),"%d %s", input, GetVehicleName(v));
			AdminLog("vehlimited", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", v, string);

			// Пересобираем подарки с транспортом
			CreateVehicleGiftCase();
		}
		else SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);
	}
	return 1;
}

// Подсчитываем транспорт на руках игроков
stock VehicleQuan(model, quan)
{
	new v = CorrectVehicleID(model);
	VehQuan[v] += quan;
	SaveVehicleQuan(v);
	return 1;
}

// Сохраняем стоимость транспорта в виртах
stock SaveVehiclePrice(v)
{
	new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehGos` = '%d' WHERE `model` = '%d'", VehGos[v], v);
	query_empty(pearsq, string_mysql);
	return 1;
}

// Сохраняем gold стоимость транспорта
stock SaveVehicleGold(v)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehGold` = '%d' WHERE `model` = '%d'", VehGold[v], v);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем количество покупок транспорта за вирты в салонах
stock SaveVehicleBuy(v)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehBuy` = '%d' WHERE `model` = '%d'", VehBuy[v], v);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем количество покупок транспорта за голду в салонах
stock SaveVehicleBuyGold(v)
{
	new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehBuyGold` = '%d' WHERE `model` = '%d'", VehBuyGold[v], v);
	query_empty(pearsq, string_mysql);
	return 1;
}

// Сохраняем лимитированное количествов транспорта
stock SaveVehicleLimited(v)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehLimited` = '%d' WHERE `model` = '%d'", VehLimited[v], v);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем количество экземпляров транспорта на руках игроков
stock SaveVehicleQuan(v)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehQuan` = '%d' WHERE `model` = '%d'", VehQuan[v], v);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем статус продажи транспорта
stock SaveVehicleSale(v)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehSale` = '%d' WHERE `model` = '%d'", VehSale[v], v);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем лимитированное количествов транспорта в кейсах (до тех пор, пока игрок не распакует)
stock SaveVehicleLimitedCase(v)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehLimitedCase` = '%d' WHERE `model` = '%d'", VehLimitedCase[v], v);
	query_empty(pearsq, string_mysql);
    return 1;
}


new bool:ReloadLimitedProcess; // Пауза на применение команды

alias:reloadlimited("rlimit", "rlimited", "rlimitveh", "rvehlimit", "rlimitedveh")
CMD:reloadlimited(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 9) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(ReloadLimitedProcess == true) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения пересчёта транспорта");

	new vehiclename[64];
	if(sscanf(params, "s[64]", vehiclename)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Пересчитать количество транспорта на руках [ /rlimit Model ]");
	new model = ReturnVehicle(vehiclename);
	if(model == -1) return ErrorMessage(playerid, "{FF6347}Неверный ID или название транспорта (400 - 612, 2000 и выше - кастомные авто)");
	if(!IsAVehExisting(model)) return ErrorMessage(playerid, "{FF6347}Неверный ID или название транспорта (400 - 612, 2000 и выше - кастомные авто)");

	ReloadLimitedVehicle(model); // Пересчитываем
	new string[140];
	format(string, sizeof(string), " [ ADM ]: %s пересчитал %s на руках игроков", PlayerInfo[playerid][pName], GetVehicleName(model));
	ABroadCast(COLOR_ADM,string,1);
	AdminLog("reloadlimited", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", model, "");
	return 1;
}

// Получаем количество лимитированных тачек
stock ReloadLimitedVehicle(model)
{
	new v = CorrectVehicleID(model); // Получаем слот в переменной

	ReloadLimitedProcess = true;
	new string_mysql[120];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT newid, model FROM `pp_cars` WHERE `model` = '%d'", model);
	mysql_tquery(pearsq, string_mysql, "Call_ReloadLimitedVehicle", "d", v);
	return 1;
}

function Call_ReloadLimitedVehicle(v)
{
	new rows;
	cache_get_row_count(rows);
	VehQuan[v] = rows;
	SaveVehicleQuan(v);

	VehLimitedCase[v] = 0;
	SaveVehicleLimitedCase(v);

	ReloadLimitedProcess = false;
	return 1;
}


alias:vehlimit("limitedveh", "limitedvehicle", "limitveh", "vehlimited")
CMD:vehlimit(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 9) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

	new vehiclename[64];
	if(sscanf(params, "s[64]", vehiclename)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Посмотреть список владельцев транспорта [ /vehlimit Model ]");
	new model = ReturnVehicle(vehiclename);
	if(model == -1) return ErrorMessage(playerid, "{FF6347}Неверный ID или название транспорта (400 - 612, 2000 и выше - кастомные авто)");
	if(!IsAVehExisting(model)) return ErrorMessage(playerid, "{FF6347}Неверный ID или название транспорта (400 - 612, 2000 и выше - кастомные авто)");

	new v = CorrectVehicleID(model);
	if(VehLimited[v] == 0) return ErrorMessage(playerid, "{FF6347}Это не лимитированный транспорт");

	new string_mysql[120];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT sost FROM `pp_cars` WHERE `model` = '%d'", model);
	mysql_tquery(pearsq, string_mysql, "Call_CheckLimitedVehicle", "ddd", playerid, model, v);
	return 1;
}

function Call_CheckLimitedVehicle(playerid, model, v)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new user_id, line[214], lines[4096];
		format(line,sizeof(line),"{ff9000}%s {cccccc}[ Лимит: %d | На руках: %d ]\n", GetVehicleName(model), VehLimited[v], VehQuan[v]), strcat(lines,line);

		for(new i = 0; i < rows; i++)
		{
			cache_get_value_name_int(i, "sost", user_id);
			format(line,sizeof(line),"\n{cccccc}user_id: %d", user_id), strcat(lines,line);
		}
		ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{999999}*",lines,"*","");
	}
	else return ErrorMessage(playerid, "{FF6347}Этого транспорта нет на руках игроков");
	return 1;
}

alias:rvehcrime("vehcrime", "crimeveh", "rcrimeveh")
CMD:rvehcrime(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 9) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	
	new string_mysql[120];
	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_cars` SET `Sklad` = '0'");
	query_empty(pearsq, string_mysql);

	// Очищаем все угоны авто
	ReloadVehicleInCrime();

	new string[140];
	format(string, sizeof(string), " [ ADM ]: %s очистил весь транспорт из угона", PlayerInfo[playerid][pName]);
	ABroadCast(COLOR_ADM,string,1);
	AdminLog("rvehcrime", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
	return 1;
}



new PlayerText3D:CustomVehLabel[MAX_REALPLAYERS][MAX_CARS];
new bool:CustomLabelBusy[MAX_REALPLAYERS][MAX_CARS];

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
	for(new i = 0; i < MAX_CARS; i++)
	{
		if(CustomLabelBusy[playerid][i] == true)
		{
			DeletePlayer3DTextLabel(playerid, CustomVehLabel[playerid][i]);
			CustomLabelBusy[playerid][i] = false;
		}
	}
	return 1;
}

function LoadPriceVeh()
{
	new time = GetTickCount();
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new vehicleList;
		for(new v = 0; v < 211 + sizeof(vehNameCustom) + 1; v++)
		{
			cache_get_value_name_int(v, "model", vehicleList); // Получаем id для переменной

			cache_get_value_name_int(v, "VehGos", VehGos[vehicleList]);
			cache_get_value_name_int(v, "VehGold", VehGold[vehicleList]);
			cache_get_value_name_int(v, "VehBuy", VehBuy[vehicleList]);
			cache_get_value_name_int(v, "VehBuyGold", VehBuyGold[vehicleList]);
			cache_get_value_name_int(v, "VehLimited", VehLimited[vehicleList]);
			cache_get_value_name_int(v, "VehQuan", VehQuan[vehicleList]);
			cache_get_value_name_int(v, "VehSale", VehSale[vehicleList]);
			cache_get_value_name_int(v, "VehLimitedCase", VehLimitedCase[vehicleList]);

			// Если гос 0, сразу прописываем из дефолт цен
			if(VehGos[vehicleList] == 0)
			{
				if(v <= 211) VehGos[vehicleList] = vehSumma[vehicleList];
				else VehGos[vehicleList] = vehSummaCustom[vehicleList - 212];
			}

			// Пересчитываем лимитированный транспорт
			if(VehLimited[vehicleList] > 0)
			{
				if(VehLimitedCase[vehicleList] >= VehLimited[vehicleList] // Если лимитированный транспорт в кейсах больше или равняется лимиту транспорта
					&& VehQuan[vehicleList] < VehLimitedCase[vehicleList]) // Если количество на руках меньше чем количество в кейсах
				{
					VehLimitedCase[vehicleList] = 0;
				}
			}
		}

		// Собираем набор транспорта для кейсов
		CreateVehicleGiftCase();

		printf("[MODE]: Настройки Транспорта [%d ms]", GetTickCount() - time);
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

// Транспорт, на котором можно ехать стоя на нём
stock IsARideOnVehicle(model)
{
	if(model == 406 || model == 422 || model == 478 || model == 543 || model == 554 
	|| model == 537 || model == 538 || model == 569 || model == 570 || model == 2141 
	|| model == 2036) return true;
	return false;
}

CMD:rvehquan(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 25) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

	mysql_tquery(pearsq, "START TRANSACTION;");
	for(new v = 0; v < 211 + sizeof(vehNameCustom) + 1; v++)
	{
		if(VehBuy[v] > 0) 
		{
			VehBuy[v] = 0;
			SaveVehicleBuy(v);
		}

		if(VehBuyGold[v] > 0) 
		{
			VehBuyGold[v] = 0;
			SaveVehicleBuyGold(v);
		}

		if(VehQuan[v] > 0) 
		{
			VehQuan[v] = 0;
			SaveVehicleQuan(v);
		}

		if(VehLimitedCase[v] > 0) 
		{
			VehLimitedCase[v] = 0;
			SaveVehicleLimitedCase(v);
		}
	}

	mysql_tquery(pearsq, "COMMIT;");

	new string[144];
	format(string, sizeof(string), " [ ADM ]: %s сбросил подсчёт всех тс на руках (VehBuy, VehBuyGold, VehQuan, VehLimitedCase)", PlayerInfo[playerid][pName]);
 	ABroadCast(COLOR_ADM,string,1);
	AdminLog("rvehquan", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
	return 1;
}

CMD:vgall(playerid, const params[]) return pc_cmd_vehgoldall(playerid, params);
CMD:vehgoldall(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 22) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

	if(sscanf(params, "ii",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить gold стоимость всех тс [ /vehgoldall Курс ]");
	if(params[0] > 10000 || params[0] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Курс не меньше 1 и не больше 10.000");

	mysql_tquery(pearsq, "START TRANSACTION;");
	for(new v = 0; v < 211 + sizeof(vehNameCustom) + 1; v++)
	{
		if(VehGos[v] > 0 && VehGold[v] == 0) 
		{
			VehGold[v] = VehGos[v]/params[0];
			SaveVehicleGold(v);
		}
	}
	mysql_tquery(pearsq, "COMMIT;");

	new string[144];
	format(string, sizeof(string), " [ ADM ]: %s изменил gold стоимости тс с 0 gold по курсу %d$", PlayerInfo[playerid][pName], params[0]);
 	ABroadCast(COLOR_ADM,string,1);
	AdminLog("vehgoldall", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "Gold цена тс");
	return 1;
}

stock PPAddVehicleComponent(vehicleid, component)
{
	if(VehInfo[vehicleid][vModel] >= 2000) // Если кастомная
	{
		if(component != 1010  // Азот
			&& component != 1087 // Гидравлика
			&& !IsAWheels(component)) // Диски
		{
			return false;
		}

		//if((VehInfo[vehicleid][vModel] == 2001 || VehInfo[vehicleid][vModel] == 2010) && component == 1010) return false; // Не ставим компонент азота
	}
	return AddVehicleComponent(vehicleid, component);
}

#if defined _ALS_AddVehicleComponent
    #undef AddVehicleComponent
#else
    #define _ALS_AddVehicleComponent
#endif
#define AddVehicleComponent PPAddVehicleComponent

// Диски на транспорт
stock IsAWheels(component)
{
	if(component == 1025 || component >= 1073 && component <= 1085 
		|| component == 1096 || component == 1097 || component == 1098) return 1;
	return 0;
}

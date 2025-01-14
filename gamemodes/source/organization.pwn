
#define MAX_ACC 100 // Максимальное количество команд по правам доступа у организаций
#define MAX_ORDERESCORT 10 // Максимальное количество заказов в ЭСкорте
#define MAX_SKIN_ORGANIZATION 50 

enum gInfo
{
	BigInt:glave,
	gbenz,
	gmats,
	gdepozit,
	gdrugs1[20],
	gdrugs2[20],
	gdrugs3,
	gdrugs4,
	gapt,
	gstat2,
	gstat,
	gAcc[MAX_ACC], // С какого ранга доступна функция или команда
	gAccDiv[MAX_ACC], // Какая подфракция привязана к функции или команде
	gBattle,
	gInterval,
	gInvent[20],
	gInv[20],
	gInvType[20],
	gInvPara[20],
	bool:gInvUpdate[20],
	gUpdate,
	gUpdateSklad,
	gUpdRank, // Статус обновления рангов
	gGuardStat[20],
	Float:gGu_X[20],
	Float:gGu_Y[20],
	Float:gGu_Z[20],
	gGuInt[20],
	gGuWorld[20],
	Text3D:gGuLabel[20],
	gGuPickup[20],
	gGuOccup[20],
	bool:gSCbug, // Переключатель режима кастомного дамага
	gSanCbug, // Санкция от админов на +C баг
	bool:gRejim2, // Включён ли режим +C баг
	gCapture[13], // Общая стата каптов
	gUnitStat[24], // Настройки юнитов
	gCash, // Счет организации (открыт или нет)
	gCarAcc[10], // Права доступа к транспорту
	gMap, // ID Загруженной карты
	gSkin[MAX_SKIN_ORGANIZATION], // ID Скина
	gSkinPrice[MAX_SKIN_ORGANIZATION], // Стоимость Скина
	gSkinRank[MAX_SKIN_ORGANIZATION], // С какого ранга доступен скин
	gMaxRanks, // Максимальное количество рангов
	gOrder[MAX_ORDERESCORT], // Заказ
	gOrderQuan[MAX_ORDERESCORT], // Заказ кол-во.
	gOrderType[MAX_ORDERESCORT], // Заказ тип.
	gOrderStatus, // Статус заказа
	gDeliveryOrder, // Статус доставки
	gDeliveryPay, // Общая стоимость
	gTax, // Стоимость доставки боеприпасов
	bool:gAvailableWeapons[38], // Доступные для взятия оружия на складе (если игрок без подфракции)
	gUnit[MAX_UNIT], // Новые настройки юнитов

	gMedMoney, // Деньги для закупа мед оборудования
	bool:gMedMoneyUpdate, // Статус для сохранение переменной денег мед оборудования
	bool:gWarehouse, // Доступ к складу, 0 открыт, 1 закрыт

	gMinSalary, // Минимальная зпшка в орге
	gMaxSalary // Максимальная зпшка в орге
};
new OrganInfo[35][gInfo];
new RankOrg[MAX_ORG][MAX_RANK_ORG][MAX_NAME_LENGTH];

stock get_maxrank(g) // Получаем максимальное количество рангов в организации
{
	new numr;
	if(OrganInfo[g][gMaxRanks] > 0) numr = OrganInfo[g][gMaxRanks];
	else
	{
		switch(g)
		{
			case 1: numr = 15; // LSPD (15 Рангов)
			case 2: numr = 14; // FBI (14 Рангов)
			case 3, 31, 33: numr = 20; // Army (20 Рангов), ВВС, ВМФ
			case 4, 26: numr = 12; // ASGH (12 Рангов), Пожарка
			case 5: numr = 10; // Cosa Nostra (10 Рангов)
			case 6: numr = 10; // Yakuza Mafia (10 Рангов)
			case 7: numr = 22; // Правительство (22 Ранга)
			case 8: numr = 11; // Hitman Agency (11 Рангов)
			case 9: numr = 10; // CNN (10 Рангов)
			case 10: numr = 10; // Triafa Mafia (10 Рангов)
			case 11: numr = 15; // SFPD (15 Рангов)
			case 12: numr = 10; // Russian Mafia (10 Рангов)
			case 13: numr = 10; // Grove Street (10 Рангов)
			case 14: numr = 10; // Ballas Gang (10 Рангов)
			case 15: numr = 10; // Vagos Gang (10 Рангов)
			case 16: numr = 10; // Los Aztecas (10 Рангов)
			case 17: numr = 10; // Rifa Gang (10 Рангов)
			case 18: numr = 10; // Arabian Mafia (10 Рангов)
			case 19: numr = 10; // Street Racers (10 Рангов)
			case 20: numr = 10; // Bikers (10 Рангов)
			case 21: numr = 15; // LVPD (15 Рангов)
			case 22: numr = 15; // SWAT (15 Рангов)
			case 32: numr = 6; // Секта
			default: numr = 0;
		}
	}
	return numr;
}

stock OnLoadOrganInvent(idx, f)
{
	for(new i = 0; i < 20; i++)
	{
		new string[20], bool:is_null;
		format(string, sizeof(string), "g_slot_%d", i);
		cache_is_value_name_null(f, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(f, string, string_json, 512);

			new JsonNode:node = JSON_INVALID_NODE;
			if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
			{
				JSON_GetInt(node, "id", OrganInfo[idx][gInvent][i]);
				JSON_GetInt(node, "quan", OrganInfo[idx][gInv][i]);
				JSON_GetInt(node, "para", OrganInfo[idx][gInvPara][i]);
				JSON_GetInt(node, "type", OrganInfo[idx][gInvType][i]);
			}
		}
	}
	return 1;
}

function LoadOrgan()
{
	new time = GetTickCount();
	new rows, idx,strFromFile2[256],atext[14], btext[14], ctext[14], dtext[14], etext[14], ftext[14], string[34];
	cache_get_row_count(rows);
	for(new f; f < MAX_ORG; ++f)
	{
		cache_get_value_name_int(f, "frakid", idx);
		new glave_str[MAX_BIGINT_LEN];
		cache_get_value_name(f, "lave", glave_str);
		OrganInfo[idx][glave] = bigint_create_str(glave_str);
		cache_get_value_name_int(f, "benz", OrganInfo[idx][gbenz]);
		cache_get_value_name_int(f, "mats", OrganInfo[idx][gmats]);
		cache_get_value_name_int(f, "depozit", OrganInfo[idx][gdepozit]);
		cache_get_value_name_int(f, "war1", orgwar[idx][0]);
		cache_get_value_name_int(f, "war2", orgwar[idx][1]);
		cache_get_value_name_int(f, "war3", orgwar[idx][2]);
		cache_get_value_name_int(f, "war4", orgwar[idx][3]);
		cache_get_value_name_int(f, "war5", orgwar[idx][4]);
		cache_get_value_name_int(f, "union1", orguni[idx][0]);
		cache_get_value_name_int(f, "union2", orguni[idx][1]);
		cache_get_value_name_int(f, "union3", orguni[idx][2]);
		cache_get_value_name_int(f, "union4", orguni[idx][3]);
		cache_get_value_name_int(f, "union5", orguni[idx][4]);
		cache_get_value_name_int(f, "drugs1", OrganInfo[idx][gdrugs1]);
		cache_get_value_name_int(f, "drugs2", OrganInfo[idx][gdrugs2]);
		cache_get_value_name_int(f, "drugs3", OrganInfo[idx][gdrugs3]);
		cache_get_value_name_int(f, "drugs4", OrganInfo[idx][gdrugs4]);
		cache_get_value_name_int(f, "apt", OrganInfo[idx][gapt]);
		cache_get_value_name_int(f, "food", OrganInfo[idx][gstat2]);
		cache_get_value_name_int(f, "cvetcar", OrganInfo[idx][gstat]);

		for(new i = 0; i < MAX_ACC; i++)
    	{
    	    format(string,sizeof(string),"acc%d", i), cache_get_value_name_int(f, string, OrganInfo[idx][gAcc][i]);
			format(string,sizeof(string),"accdiv%d", i), cache_get_value_name_int(f, string, OrganInfo[idx][gAccDiv][i]);
			if(OrganInfo[idx][gAcc][i] <= 0) OrganInfo[idx][gAcc][i] = MAX_RANK_ORG;
    	}
		cache_get_value_name_int(f, "interval", OrganInfo[idx][gInterval]);
		
		// Загружаем склад организации
		OnLoadOrganInvent(idx, f);

		for(new x = 0; x < 20; x++)
    	{
			format(atext,sizeof(atext),"gustat%d",x);
			format(btext,sizeof(btext),"gux%d",x);
			format(ctext,sizeof(ctext),"guy%d",x);
			format(dtext,sizeof(dtext),"guz%d",x);
			format(etext,sizeof(etext),"guint%d",x);
			format(ftext,sizeof(ftext),"guworld%d",x);
			cache_get_value_name_int(f, atext, OrganInfo[idx][gGuardStat][x]);
			cache_get_value_name_float(f, btext, OrganInfo[idx][gGu_X][x]);
			cache_get_value_name_float(f, ctext, OrganInfo[idx][gGu_Y][x]);
			cache_get_value_name_float(f, dtext, OrganInfo[idx][gGu_Z][x]);
			cache_get_value_name_int(f, etext, OrganInfo[idx][gGuInt][x]);
			cache_get_value_name_int(f, ftext, OrganInfo[idx][gGuWorld][x]);
			ReloadGuard(idx, x);
		}
		cache_get_value_name_int(f, "SCbug", OrganInfo[idx][gSCbug]);
		cache_get_value_name_int(f, "SanCbug", OrganInfo[idx][gSanCbug]);
		cache_get_value_name_int(f, "Rejim2", OrganInfo[idx][gRejim2]);

		for(new i = 0; i < MAX_RANK_ORG; i++)
    	{
			format(string,sizeof(string),"rank%d", i), cache_get_value_name(f, string, RankOrg[idx][i], MAX_NAME_LENGTH);
		}

		cache_get_value_name_int(f, "capt0", OrganInfo[idx][gCapture][0]);
		cache_get_value_name_int(f, "capt1", OrganInfo[idx][gCapture][1]);
		cache_get_value_name_int(f, "capt2", OrganInfo[idx][gCapture][2]);
		cache_get_value_name_int(f, "capt3", OrganInfo[idx][gCapture][3]);
		cache_get_value_name_int(f, "capt4", OrganInfo[idx][gCapture][4]);
		cache_get_value_name_int(f, "capt5", OrganInfo[idx][gCapture][5]);
		cache_get_value_name_int(f, "capt6", OrganInfo[idx][gCapture][6]);
		cache_get_value_name_int(f, "capt7", OrganInfo[idx][gCapture][7]);
		cache_get_value_name_int(f, "capt8", OrganInfo[idx][gCapture][8]);
		cache_get_value_name_int(f, "capt9", OrganInfo[idx][gCapture][9]);
		cache_get_value_name_int(f, "capt10", OrganInfo[idx][gCapture][10]);
		cache_get_value_name_int(f, "capt11", OrganInfo[idx][gCapture][11]);
		cache_get_value_name_int(f, "capt12", OrganInfo[idx][gCapture][12]);
		cache_get_value_name_int(f, "unitstat0", OrganInfo[idx][gUnitStat][0]);
		cache_get_value_name_int(f, "unitstat1", OrganInfo[idx][gUnitStat][1]);
		cache_get_value_name_int(f, "unitstat2", OrganInfo[idx][gUnitStat][2]);
		cache_get_value_name_int(f, "unitstat3", OrganInfo[idx][gUnitStat][3]);
		cache_get_value_name_int(f, "unitstat4", OrganInfo[idx][gUnitStat][4]);
		cache_get_value_name_int(f, "unitstat5", OrganInfo[idx][gUnitStat][5]);
		cache_get_value_name_int(f, "unitstat6", OrganInfo[idx][gUnitStat][6]);
		cache_get_value_name_int(f, "unitstat7", OrganInfo[idx][gUnitStat][7]);
		cache_get_value_name_int(f, "unitstat8", OrganInfo[idx][gUnitStat][8]);
		cache_get_value_name_int(f, "unitstat9", OrganInfo[idx][gUnitStat][9]);
		cache_get_value_name_int(f, "unitstat10", OrganInfo[idx][gUnitStat][10]);
		cache_get_value_name_int(f, "unitstat11", OrganInfo[idx][gUnitStat][11]);
		cache_get_value_name_int(f, "unitstat12", OrganInfo[idx][gUnitStat][12]);
		cache_get_value_name_int(f, "unitstat13", OrganInfo[idx][gUnitStat][13]);
		cache_get_value_name_int(f, "unitstat14", OrganInfo[idx][gUnitStat][14]);
		cache_get_value_name_int(f, "unitstat15", OrganInfo[idx][gUnitStat][15]);
		cache_get_value_name_int(f, "unitstat16", OrganInfo[idx][gUnitStat][16]);
		cache_get_value_name_int(f, "unitstat17", OrganInfo[idx][gUnitStat][17]);
		cache_get_value_name_int(f, "unitstat18", OrganInfo[idx][gUnitStat][18]);
		cache_get_value_name_int(f, "unitstat19", OrganInfo[idx][gUnitStat][19]);
		cache_get_value_name_int(f, "unitstat20", OrganInfo[idx][gUnitStat][20]);
		cache_get_value_name_int(f, "unitstat21", OrganInfo[idx][gUnitStat][21]);
		cache_get_value_name_int(f, "unitstat22", OrganInfo[idx][gUnitStat][22]);
		cache_get_value_name_int(f, "unitstat23", OrganInfo[idx][gUnitStat][23]);
		cache_get_value_name_int(f, "cash", OrganInfo[idx][gCash]);
		cache_get_value_name_int(f, "caracc0", OrganInfo[idx][gCarAcc][0]);
		cache_get_value_name_int(f, "caracc1", OrganInfo[idx][gCarAcc][1]);
		cache_get_value_name_int(f, "caracc2", OrganInfo[idx][gCarAcc][2]);
		cache_get_value_name_int(f, "caracc3", OrganInfo[idx][gCarAcc][3]);
		cache_get_value_name_int(f, "caracc4", OrganInfo[idx][gCarAcc][4]);
		cache_get_value_name_int(f, "caracc5", OrganInfo[idx][gCarAcc][5]);
		cache_get_value_name_int(f, "caracc6", OrganInfo[idx][gCarAcc][6]);
		cache_get_value_name_int(f, "caracc7", OrganInfo[idx][gCarAcc][7]);
		cache_get_value_name_int(f, "caracc8", OrganInfo[idx][gCarAcc][8]);
		cache_get_value_name_int(f, "caracc9", OrganInfo[idx][gCarAcc][9]);
		cache_get_value_name_int(f, "map", OrganInfo[idx][gMap]);

		// Загружаем скины организации
		OnLoadSkinOrganization(f, idx);

		// Загружаем новые настройки юнитов
		OnLoadUnitSetting(f, idx);

		cache_get_value_name_int(f, "gMaxRanks", OrganInfo[idx][gMaxRanks]);
		if(idx == 13 || idx == 14 || idx == 15 || idx == 16)
		{
			if(OrganInfo[idx][gMap] >= 1)
			{
			    MysqlRaceMapFrak[idx] = 1;
				mysql_format(pearsq, strFromFile2, sizeof(strFromFile2), "SELECT * FROM `pp_mapfrak` WHERE `frakid` = '%d' AND `mapid` = '%d' LIMIT 200", idx, OrganInfo[idx][gMap]);
				mysql_tquery(pearsq, strFromFile2, "call_loadmap", "ddd", -1, idx, OrganInfo[idx][gMap]);
			}
		}
		for(new i = 0; i < MAX_ORDERESCORT; i++)
    	{
			format(string,sizeof(string),"Order%d", i), cache_get_value_name_int(f, string, OrganInfo[idx][gOrder][i]);
			format(string,sizeof(string),"OrderQuan%d", i), cache_get_value_name_int(f, string, OrganInfo[idx][gOrderQuan][i]);
			format(string,sizeof(string),"OrderType%d", i), cache_get_value_name_int(f, string, OrganInfo[idx][gOrderType][i]);
		}
		cache_get_value_name_int(f, "OrderStatus", OrganInfo[idx][gOrderStatus]);
		cache_get_value_name_int(f, "gDeliveryPay", OrganInfo[idx][gDeliveryPay]);
		cache_get_value_name_int(f, "gTax", OrganInfo[idx][gTax]);
		cache_get_value_name_int(f, "gMedMoney", OrganInfo[idx][gMedMoney]);
		cache_get_value_name_bool(f, "gWarehouse", OrganInfo[idx][gWarehouse]);

		// Загрузка доступных оружий на складе
		new available_weapons_str[256];
		cache_get_value_name(f, "gAvailableWeapons", available_weapons_str);
		if (isnull(available_weapons_str)) {
			// Если нет информации по доступным оружиям - делаем доступными все
			for (new weaponid = 0; weaponid < 38; weaponid++) OrganInfo[idx][gAvailableWeapons][weaponid] = true;
		} else {
			sscanf(available_weapons_str, "p<|>a<i>[38]", OrganInfo[idx][gAvailableWeapons]);
		}

		OrganInfo[idx][gDeliveryOrder] = -1;
		// NGSA
		if(idx == 3)
		{
			if(OrganInfo[idx][gTax] == 0) OrganInfo[idx][gTax] = 100000;
		}

		// Загружаем расчёт по зпшкам в час
		LoadSalaryOrganization(idx);
	}
	UpdateHonor(1), UpdateHonor(2);

	mysql_tquery(pearsq, "SELECT * FROM `depart_weapons`", "LoadOrderWeaponsDepart", ""); // Загружаем доступные для заказа оружия

    format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n\n{ffffff}[ Заправить Цистерну - {0088ff}CAPS LOCK (Гудок) {ffffff}]",OrganInfo[3][gbenz]);
	FrakiBenz[0] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,329.3005,1913.6547,17.6566,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[3][gbenz]);
	FrakiBenz[1] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,342.7881,1952.4415,20.1840,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[3][gbenz]);
	FrakiBenz[2] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,342.7953,1987.6055,20.1840,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[3][gbenz]);
	FrakiBenz[3] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,318.1751,2072.9731,17.6446,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[3][gbenz]);
	FrakiBenz[4] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,278.6174,2002.4999,17.6406,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]\n[ Заправить Цистерну - {0088ff}CAPS LOCK (Гудок) {ffffff}]",OrganInfo[2][gbenz]);
	FrakiBenz[9] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,2112.4143,2374.6577,10.8203,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[2][gbenz]);
	FrakiBenz[11] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,2101.6763,2423.8325,74.5786,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);

	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n\n{ffffff}[ Заправить Цистерну - {0088ff}CAPS LOCK (Гудок) {ffffff}]",OrganInfo[3][gbenz]);
	FrakiBenz[5] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1400.3053,456.5131,7.1809,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[3][gbenz]);
	FrakiBenz[8] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1354.442749, 385.154052, 1.907501,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[3][gbenz]);
	FrakiBenz[10] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1354.441894, 349.254119, 1.907502,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[3][gbenz]);
	FrakiBenz[12] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1319.4836,493.9069,18.2344,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[3][gbenz]);
	FrakiBenz[20] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1256.6936,428.4373,24.7980,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[3][gbenz]);
	FrakiBenz[21] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1246.7941,439.3991,7.1875,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);

    format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]\n[ Заправить Цистерну - {0088ff}CAPS LOCK (Гудок) {ffffff}]",OrganInfo[1][gbenz]);
    FrakiBenz[15] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,1585.1774,-1677.7784,5.8979,7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[1][gbenz]);
    FrakiBenz[16] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,1570.9508,-1640.7448,28.4021,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]\n[ Заправить Цистерну - {0088ff}CAPS LOCK (Гудок) {ffffff}]",OrganInfo[11][gbenz]);
    FrakiBenz[6] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1606.1071,732.9869,-5.2344,7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[11][gbenz]);
    FrakiBenz[7] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1631.6208,712.2404,49.0737,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]\n[ Заправить Цистерну - {0088ff}CAPS LOCK (Гудок) {ffffff}]",OrganInfo[22][gbenz]);
    FrakiBenz[14] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,2499.1248,2487.4060,10.8203,7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
    format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[22][gbenz]);
    FrakiBenz[17] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,2400.4456,2480.4775,69.6422,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);

    RingText[0] = CreateDynamic3DTextLabel("{ff9000}Ринг {00cc00}Grove Street {cccccc}[ ALT ]",0xA9C4E4FF,2523.2881,-1696.6648,13.5210,10.0);
    RingText[1] = CreateDynamic3DTextLabel("{ff9000}Ринг {9900cc}Ballas Gang {cccccc}[ ALT ]",0xA9C4E4FF,2510.6646,-1987.1370,13.5540,10.0);
    RingText[2] = CreateDynamic3DTextLabel("{ff9000}Ринг {ffcc33}Vagos Gang {cccccc}[ ALT ]",0xA9C4E4FF,2249.1777,-1461.2014,24.0497,10.0);
    RingText[3] = CreateDynamic3DTextLabel("{ff9000}Ринг {00ffff}Los Aztecas {cccccc}[ ALT ]",0xA9C4E4FF,1711.5629,-2087.6062,13.5469,10.0);
    RingText[4] = CreateDynamic3DTextLabel("{ff9000}Ринг {ff9000}MMA {cccccc}[ ALT ]",0xA9C4E4FF,-1381.4384,83.0507,2044.1340,10.0);
    RingText[5] = CreateDynamic3DTextLabel("{ff9000}Ринг {ff9000}Тюрьма {cccccc}[ ALT ]",0xA9C4E4FF,1000.7909,2439.7969,10.8716,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
    RuletText[0] = CreateDynamic3DTextLabel("{ff9000}Рулетка\n{cccccc}ALT - Играть\n{cccccc}ENTER - выйти",-1,2182.339599, 1011.979858, 992.618713,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,2001,55); // 0
    RuletText[1] = CreateDynamic3DTextLabel("{ff9000}Рулетка\n{cccccc}ALT - Играть\n{cccccc}ENTER - выйти",-1,2182.339599, 1017.982482, 992.618713,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,2001,55); // 1
    RuletText[2] = CreateDynamic3DTextLabel("{ff9000}Рулетка\n{cccccc}ALT - Играть\n{cccccc}ENTER - выйти",-1,2182.339599, 1023.986572, 992.618713,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,2001,55); // 2
    RuletObject[0] = CreateDynamicObject(1979, RuletPos[0][0], RuletPos[0][1], RuletPos[0][2], 0.000000, 0.000000, 0.000000, 2001, 55, -1, 300.00, 300.00); // ruletka (2)
	RuletObject[1] = CreateDynamicObject(1979, RuletPos[1][0], RuletPos[1][1], RuletPos[1][2], 0.000000, 0.000000, 0.000000, 2001, 55, -1, 300.00, 300.00); // ruletka (1)
	RuletObject[2] = CreateDynamicObject(1979, RuletPos[2][0], RuletPos[2][1], RuletPos[2][2], 0.000000, 0.000000, 0.000000, 2001, 55, -1, 300.00, 300.00); // ruletka (0)
	load_ammosv(); // Загружаем ящики на склад NGSA
	dirtunix = gettime()+600;

	printf("[MODE]: Организации [%d ms]",GetTickCount() - time);
	return 1;
}

// Загрузка сохранений скинов организаций
stock OnLoadSkinOrganization(f, g)
{
	for(new i = 0; i < MAX_SKIN_ORGANIZATION; i++)
	{
		new string[20], bool:is_null;
		format(string, sizeof(string), "s_slot_%d", i);
		cache_is_value_name_null(f, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(f, string, string_json, 512);

			new JsonNode:node = JSON_INVALID_NODE;
			if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
			{
				JSON_GetInt(node, "id", OrganInfo[g][gSkin][i]);
				JSON_GetInt(node, "price", OrganInfo[g][gSkinPrice][i]);
				JSON_GetInt(node, "rank", OrganInfo[g][gSkinRank][i]);
			}
		}
	}
	return 1;
}

stock SaveSkinOrganization(g, bool:transaction = true)
{
	// Начало транзакции
	if(transaction == true) mysql_tquery(pearsq, "START TRANSACTION;");

	for(new i = 0; i < MAX_SKIN_ORGANIZATION; i++) SaveOneSkinOrganization(g, i);

	// Завершение транзакции
	if(transaction == true) mysql_tquery(pearsq, "COMMIT;");
	return 1;
}

// Сохраняем один слот скина в организации
stock SaveOneSkinOrganization(g, i)
{
	if(OrganInfo[g][gSkin][i] == 0)
	{
		new string_mysql[140];
		mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_organization` SET `s_slot_%d`= NULL WHERE `frakid` = '%d'", i, g);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new JsonNode:node = JSON_Object(
			"id", JSON_Int(OrganInfo[g][gSkin][i]),
			"price", JSON_Int(OrganInfo[g][gSkinPrice][i]),
			"rank", JSON_Int(OrganInfo[g][gSkinRank][i])
		);

		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_organization` SET `s_slot_%d`= '%e' WHERE `frakid` = '%d'", i, string_json, g);
			mysql_tquery(pearsq, string_mysql);
		}
	}
	return 1;
}

stock SaveOrgan(idx)
{
	new string_mysql[1400],glave_str[MAX_BIGINT_LEN];
	bigint_get_str(OrganInfo[idx][glave], glave_str);
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_organization` SET `lave`='%s',`benz`='%d',`mats`='%d',`depozit`='%d',`caracc0`='%d',`caracc1`='%d',`caracc2`='%d',\
		`caracc3`='%d',`caracc4`='%d',`caracc5`='%d',`caracc6`='%d',`caracc7`='%d',`caracc8`='%d',`caracc9`='%d',",glave_str,OrganInfo[idx][gbenz],
		OrganInfo[idx][gmats], OrganInfo[idx][gdepozit],OrganInfo[idx][gCarAcc][0],OrganInfo[idx][gCarAcc][1],OrganInfo[idx][gCarAcc][2],
		OrganInfo[idx][gCarAcc][3],OrganInfo[idx][gCarAcc][4],OrganInfo[idx][gCarAcc][5],OrganInfo[idx][gCarAcc][6],OrganInfo[idx][gCarAcc][7],
		OrganInfo[idx][gCarAcc][8],OrganInfo[idx][gCarAcc][9]); // 235 + 154
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "%s`war1`='%d',`war2`='%d',`war3`='%d',`war4`='%d',`war5`='%d',`union1`='%d',`union2`='%d',`union3`='%d',`union4`='%d',`union5`='%d',",  string_mysql,
		orgwar[idx][0],orgwar[idx][1],orgwar[idx][2],orgwar[idx][3],orgwar[idx][4],orguni[idx][0],orguni[idx][1],orguni[idx][2],orguni[idx][3],orguni[idx][4]); // 133 + 110
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "%s`drugs1`='%d',`drugs2`='%d',`drugs3`='%d',`drugs4`='%d',`apt`='%d',`food`='%d',`cvetcar`='%d',`interval`='%d',\
		`SCbug`='%d',`SanCbug`='%d',`Rejim2`='%d',`cash`='%d',`map`='%d', `gWarehouse` = '%d' WHERE `frakid`='%d'", string_mysql,
		OrganInfo[idx][gdrugs1],OrganInfo[idx][gdrugs2],OrganInfo[idx][gdrugs3],OrganInfo[idx][gdrugs4],OrganInfo[idx][gapt],OrganInfo[idx][gstat2],OrganInfo[idx][gstat],OrganInfo[idx][gInterval],
		OrganInfo[idx][gSCbug], OrganInfo[idx][gSanCbug], OrganInfo[idx][gRejim2], OrganInfo[idx][gCash], OrganInfo[idx][gMap], OrganInfo[idx][gWarehouse],idx);
	query_empty(pearsq, string_mysql); // 987
	return 1;
}

// Склад организации
stock gunsklad(playerid)
{
	new skladstat = GetSkladStat(playerid);
	if(skladstat > -1)
	{
	    new fpick = OnlineInfo[playerid][oInHandThing][0], fquan = OnlineInfo[playerid][oInHandThing][1];
		new fpara = OnlineInfo[playerid][oInHandThing][2], thingQara = OnlineInfo[playerid][oInHandThing][3];
		new thingType = OnlineInfo[playerid][oInHandThing][4], thingPack = OnlineInfo[playerid][oInHandThing][5];
		if(fpick > 0 && thingPack == 4) return ErrorMessage(playerid, "{FF6347}Запечатанный ящик невозможно распаковать на складе\n\n{cccccc}Этот ящик защищён и используется для доставки боеприпасов NGSA");
		if(fpick > 0 && thingPack == 2) //  Кладём Ящик
		{
		    if(fpick >= 4 && fpick <= 7 && (skladstat == 1 || skladstat == 3 || skladstat == 4 || skladstat == 7 || skladstat == 9 || skladstat == 11 || skladstat == 21 || skladstat == 22 || skladstat == 29 || skladstat == 33)) return ErrorMessage(playerid, "{FF6347}На этом складе нельзя хранить вещества");

			if(fpick == 34 && thingType == 1 && !IsOrderDepartWeapon(skladstat, 34)) return ErrorMessage(playerid, "{FF6347}На этом складе нельзя хранить снайперскую винтовку");
			
			if((fpick >= 4 && fpick <= 7 || fpick == 8 || fpick >= 27 && fpick <= 30 || fpick == 70) && thingType == 0 
				|| IsHelmet(fpick) && thingType == 2 
				|| IsArmor(fpick) && thingType == 2 || thingType == 1)
			{
			    if(thingType == 1) fpara = 100000;
			    if(IsHelmet(fpick) && thingType == 2) fpara = 3;
			    if(IsArmor(fpick) && thingType == 2) fpara = 100;
				
			    new put_inva = putsklad(skladstat, fpick, fquan, fpara, thingType, 1); // Кладём предмет
				if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}На складе организации, для этого предмета, нет места [ Лимит ]");

				InHandClear(playerid);
				
				new string[120];
				format(string,sizeof(string),"[ Мысли ]: Я положил%s на склад {ff9000}%s | %d", gender(playerid), GetNameThing(1, fpick, thingType, thingPack),fquan);
    			SendClientMessage(playerid, COLOR_GREY, string);
				OrgLog(skladstat, "putsklad", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fquan, GetNameThing(1, fpick, thingType, thingPack));

	   		    SetPlayerChatBubble(playerid,"кладёт ящик на склад",COLOR_PURPLE,20.0,3000);
	       	    RemovePlayerAttachedObject(playerid,1);
	       	    PPP15[playerid] = 0;
	       	    ApplyAnimation(playerid,"CARRY","putdwn",4.0, false, false, false, false, false, SYNC_ALL);
	       	    PlayerPlaySound(playerid,6401,0,0,0);

	       	    // Выдаём юниты
	       	    GiveUnitForBox(playerid, fpick, thingType, fquan, thingQara);

				// Выдаём ачивку, первый доставленный ящик
				if(PlayerInfo[playerid][pAchieve][99] == 0) AchievePlayer(playerid, 99, 1);
  	    	}
			else ErrorMessage(playerid, "{FF6347}Содержимое ящика в руках не может храниться на этом складе");
		}
		else ErrorMessage(playerid, "{FF6347}У вас в руках нет ящика");
	}
	return 1;
}

stock GiveUnitForBox(playerid, thingId, thingType, thingAmount, thingQara)
{
	if(thingQara != 0) return 1; // Если ящик был собран с арендованного склада (Не выдаём юниты)

	new g = fraction(playerid);
	if(OrganInfo[g][gUnit][0])
	{
		new kol;
		if((thingId >= 4 && thingId <= 7 || thingId >= 27 && thingId <= 30) && thingType == 0) kol = thingAmount; // Вещества, Патроны
		else if(IsHelmet(thingId) && thingType == 2 || IsArmor(thingId) && thingType == 2 || thingType == 1) kol = thingAmount * 1000; // Каска, Броня, Оружие
		else if((thingId == 8 || thingId == 70) && thingType == 0) kol = thingAmount * 100; // Аптечки, Бинты

		GivePlayerUnit(playerid, kol * OrganInfo[g][gUnit][0]);
	}
	return 1;
}

// lmenu
CMD:omenu(playerid) return pc_cmd_lmenu(playerid);
CMD:lmenu(playerid)
{
	if(PlayerInfo[playerid][pBkyrenie] >= 2) return ErrorMessage(playerid, "{FF6347}Ваш персонаж участвует в экспедиции NASA");
	new g = fraction(playerid);
	if(g == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");

	PlayerPlaySound(playerid,1150,0,0,0);
	showDialogOrganizationMenu(playerid);
	return 1;
}
stock showDialogOrganizationMenu(playerid)
{
	for(new i = 0; i < 200; i++) List[i][playerid] = 0;
	DP[0][playerid] = 0;
	new g = fraction(playerid);
	DP[1][playerid] = g;

	new line[100],lines[4048];
	format(line,sizeof(line), "%s\t", frakName[DP[1][playerid]]), strcat(lines,line);

	if(g == 5 || g == 6 || g == 10 || g == 12 || g == 18 || g == 13 || g == 14 || g == 15 || g == 16 || g == 17 || g == 19 || g == 20)
	{
		format(line,sizeof(line), detail_lmenu(playerid, 1)), strcat(lines,line);  // Информация
 	}
	format(line,sizeof(line), detail_lmenu(playerid, 2)), strcat(lines,line); // Участники Online
	format(line,sizeof(line), detail_lmenu(playerid, 3)), strcat(lines,line); // Участники Offline
	format(line,sizeof(line), detail_lmenu(playerid, 4)), strcat(lines,line); // Статус набора
	format(line,sizeof(line), detail_lmenu(playerid, 5)), strcat(lines,line); // Переводы на счет
	if(PlayerInfo[playerid][pLeader] >= 1 || IsSubLeader(playerid))
	{
		format(line,sizeof(line), detail_lmenu(playerid, 14)), strcat(lines,line); // Подфракции
	}
	format(line,sizeof(line), detail_lmenu(playerid, 7)), strcat(lines,line); // Названия рангов
	format(line,sizeof(line), detail_lmenu(playerid, 15)), strcat(lines,line); // Количество рангов
	format(line,sizeof(line), detail_lmenu(playerid, 8)), strcat(lines,line); // Лог
	format(line,sizeof(line), detail_lmenu(playerid, 10)), strcat(lines,line); // Черный список

	if(IsAGunSkladDepart(g)) // Только организации, у которых есть доступ к оружию на складе
	{
		format(line,sizeof(line), detail_lmenu(playerid, 16)), strcat(lines,line); // Заказ БП
	}

	// ASGH
	if(g == 4)
	{
		format(line,sizeof(line), detail_lmenu(playerid, 17)), strcat(lines,line); // Мед оборудование (Оплата заказа)
	}

	if(IsGangMember(playerid) || IsMafiaMember(playerid))
	{
	    format(line,sizeof(line), detail_lmenu(playerid, 6)), strcat(lines,line); // Дипломатия
	    format(line,sizeof(line), detail_lmenu(playerid, 9)), strcat(lines,line); // Управление гаражем
	}
	if (g != 9) format(line,sizeof(line), detail_lmenu(playerid, 12)), strcat(lines,line); // Настройки склада
	if(PlayerInfo[playerid][pLeader] >= 1)
	{
		if (g == 9) format(line,sizeof(line), detail_lmenu(playerid, 20)), strcat(lines,line); // Настройка стоимости объявлений
		format(line,sizeof(line), detail_lmenu(playerid, 11)), strcat(lines,line); // Права доступа
		format(line,sizeof(line), detail_lmenu(playerid, 13)), strcat(lines,line); // Настройки оплаты
		if(g == 4) format(line,sizeof(line), detail_lmenu(playerid, 18)), strcat(lines,line); // Стоимость лечения
		if(g == 6) format(line,sizeof(line), detail_lmenu(playerid, 19)), strcat(lines,line); // Пропуск на Дуэль
	}
	ShowDialog(playerid,615,DIALOG_STYLE_TABLIST_HEADERS,"Меню Организации",lines,"Выбрать","Отмена");
	return 1;
}
stock detail_lmenu(playerid, detail)
{
    List[DP[0][playerid]][playerid] = detail;
    DP[0][playerid] += 1;
	new text[90], g = DP[1][playerid];
	if(detail == 1) text = "\n{999999}Об организации..\t";
	else if(detail == 2) text = "\n{cccccc}Участники {99ff66}Online\t";
	else if(detail == 3) text = "\n{cccccc}Участники {FF6347}Offline\t";
	else if(detail == 4)
	{
		if(OrganInfo[g][gapt] == 1) text = "\n{cccccc}Набор \t{99ff66}[ Открыт ]";
 		else if(OrganInfo[g][gapt] == 0) text = "\n{cccccc}Набор \t{FF6347}[ Закрыт ]";
	}
	else if(detail == 5)
	{
		if(OrganInfo[g][gCash] == 1) text = "\n{cccccc}Счёт \t{99ff66}[ Открыт ]";
 		else if(OrganInfo[g][gCash] == 0) text = "\n{cccccc}Счёт \t{FF6347}[ Закрыт ]";
	}
	else if(detail == 6) text = "\n{cccccc}Дипломатия\t";
	else if(detail == 7) text = "\n{cccccc}Названия рангов\t";
	else if(detail == 8) text = "\n{cccccc}Лог\t";
	else if(detail == 9) text = "\n{cccccc}Управление гаражем\t";
	else if(detail == 10) text = "\n{cccccc}Черный список\t";
	else if(detail == 11) text = "\n{ff9000}Права доступа\t";
	else if(detail == 12) text = "\n{ff9000}Настройки склада\t";
	else if(detail == 13) text = "\n{ff9000}Настройки Unit\t";
	else if(detail == 14) text = "\n{cccccc}Подфракции\t";
	else if(detail == 15) format(text, sizeof(text), "\n{cccccc}Количество рангов\t{ff9000}%d", OrganInfo[g][gMaxRanks]);
	else if(detail == 16) 
	{
		if(OrganInfo[g][gOrderStatus] == 1) format(text, sizeof(text), "\n{cccccc}Заказ боеприпасов\t{99ff66}Active");
		else format(text, sizeof(text), "\n{cccccc}Заказ боеприпасов\t");
	}
	else if(detail == 17) format(text, sizeof(text), "\n{cccccc}Мед оборудование\t{99ff66}%d$", OrganInfo[g][gMedMoney]);
	else if(detail == 18) format(text, sizeof(text), "\n{ff9000}Стоимость лечения\t{99ff66}%d$", ServerInfo[9]);
	else if(detail == 19) format(text, sizeof(text), "\n{ff9000}Дуэль с Годжо\t{99ff66}%d$", ServerInfo[35]);
	else if(detail == 20) format(text, sizeof(text), "\n{ff9000}Цена публикации объявлений\t{99ff66}%d$ {cccccc}/ {FF6C00}%d$", ServerInfo[65], ServerInfo[66]);
	return text;
}
stock open_detail_lmenu(playerid, detail)
{	
	new g = fraction(playerid);
	if(detail == 1) infoorg(playerid, fraction(playerid));
	else if(detail == 2) pc_cmd_members(playerid, "");
	else if(detail == 3) pc_cmd_membersoff(playerid);
	else if(detail == 4) pc_cmd_nabor(playerid);
	else if(detail == 5)
	{
		if(!GetAccessRankOrg(playerid, g, 4, NO_FBI)) return 1;
    	if(OrganInfo[g][gCash] == 1) OrganInfo[g][gCash] = 0;
		else if(OrganInfo[g][gCash] == 0) OrganInfo[g][gCash] = 1;
		OrganInfo[g][gUpdate] = 1;
		showDialogOrganizationMenu(playerid);
    }
    else if(detail == 6) pc_cmd_dip(playerid);
	else if(detail == 7) rank_organization(playerid, fraction(playerid));
	else if(detail == 8)
	{
		if(!GetAccessRankOrg(playerid, g, 6, NO_FBI)) return 1;
		logorg(playerid, g);
	}
	else if(detail == 9) pc_cmd_cac(playerid);
	else if(detail == 10) BL[playerid] = fraction(playerid), pc_cmd_blacklist(playerid);
	else if(detail == 11) pc_cmd_oac(playerid);
	else if(detail == 12) pc_cmd_gac(playerid);
	else if(detail == 13) pc_cmd_jac(playerid);
	else if(detail == 14) pc_cmd_alldiv(playerid);
	else if(detail == 15)
	{
		if(!GetAccessRankOrg(playerid, g, 5, NO_FBI)) return 1;

		new string[80];
		format(string,sizeof(string),"{cccccc}Введите количество рангов в организации [2 - %d рангов]", MAX_RANK_ORG);
		ShowDialog(playerid,1331,DIALOG_STYLE_INPUT,"{ff9000}Организация",string,"Принять","Отмена");
	}
	else if(detail == 16) OrderEscort(playerid, g);
	else if(detail == 17) OrderMedEquipment(playerid);
	else if(detail == 18) ShowDialogSettingHealPrice(playerid);
	else if(detail == 19) ShowDialogSettingKatanaDuel(playerid);
	else if(detail == 20) CNN_EditPriceDialog(playerid,  0);
	return 1;
}

stock ShowDialogSettingHealPrice(playerid)
{
	ShowDialog(playerid,1507,DIALOG_STYLE_INPUT,"{ff9000}Организация","{cccccc}Введите стоимость лечения /heal\
																	\n{FF6347}Не меньше 1$ и не больше 10.000$","Принять","Отмена");
	return true;
}

// Настраиваем стоимость лечения
stock SettingHealPrice(playerid, const inputtext[])
{
	new input = strval(inputtext);
	if(input < 1 || input > 10000) return ShowDialogSettingHealPrice(playerid);

	PlayerPlaySound(playerid,6401,0,0,0);
	ServerInfo[9] = input;
	SaveServer(9);
	showDialogOrganizationMenu(playerid);

	OrgLog(fraction(playerid), "healprice", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", input, "Стоимость лечения");
	return true;
}

stock OrderMedEquipment(playerid)
{
	ShowDialog(playerid,26,DIALOG_STYLE_LIST,"{ff9000}Организация","{cccccc}Оплатить оборудование\n{cccccc}GPS Склада мед оборудования\n{666666}Информация","Выбрать","Отмена");
	return true;
}

stock InputOrderMedEquipment(playerid)
{
	ShowDialog(playerid,27,DIALOG_STYLE_INPUT,"{ff9000}Организация","{cccccc}Введите сумму для оплаты закупа мед оборудования\
																	\n{FF6347}Не меньше 1$ и не больше 1.000.000$","Принять","Отмена");
	return true;
}

// Заказываем мед оборудование для организации
stock CreateOrderMedEquipment(playerid, const inputtext[])
{
	new input = strval(inputtext);
	if(input < 1 || input > 1000000) return InputOrderMedEquipment(playerid);

	new g = fraction(playerid);
	if(g == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Вы не состоите в организации");
	if(input > PlayerInfo[playerid][pAccount]) return ErrorMessage(playerid, "{FF6347}На вашем банковском счету недостаточно средств");

	PlayerPlaySound(playerid,6401,0,0,0);
	OrganInfo[g][gMedMoney] += input;
	PlayerInfo[playerid][pAccount] -= input;
	showDialogOrganizationMenu(playerid);

	mysql_transaction(pearsq);
	mysql_save(playerid, 43);
	UpdateMedMoneyOrg(g);
	mysql_commit(pearsq);

	new string[40];
	format(string,sizeof(string),"Закуп мед оборудования %s", frakeasyName[g]);
	MoneyLog("ordermed", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -input, string);
	OrgLog(g, "ordermed", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", input, "Закуп мед оборудования");
	return true;
}

stock UpdateMedMoneyOrg(g)
{
	new string[160];
	mysql_format(pearsq, string, sizeof(string),"UPDATE `pp_organization` SET `gMedMoney` = '%d' WHERE `frakid` = '%d'", OrganInfo[g][gMedMoney], g);
	mysql_tquery(pearsq, string);
	return true;
}

#define MAX_WH_MED_THING 2
new WarehouseMedThingId[MAX_WH_MED_THING];
new WarehouseMedThingType[MAX_WH_MED_THING];
new WarehouseMedThingQuan[MAX_WH_MED_THING];

// Заполняем товары для склада мед оборудования
stock CreateWarehouseMedThing()
{
	WarehouseMedThingId[0] = 8;
	WarehouseMedThingType[0] = 0;
	WarehouseMedThingQuan[0] = 10;

	WarehouseMedThingId[1] = 70;
	WarehouseMedThingType[1] = 0;
	WarehouseMedThingQuan[1] = 10;
	return true;
}

stock GovWarehouseMed(playerid)
{
	new g = fraction(playerid);
	if(!IsAFunctionOrganization(75, g, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не сотрудник ASGH");
	if(!GetAccessRankOrg(playerid, g, 75, NO_FBI)) return 1;

	new line[100], lines[100 * MAX_WH_MED_THING];
	for(new i = 0; i < MAX_WH_MED_THING; i++)
	{
		if(WarehouseMedThingId[i] == 0) continue;
		format(line,sizeof(line),"{cccccc}%s [ %d штук ]\t{99ff66}%d$\n", 
			GetNameThing(1, WarehouseMedThingId[i], WarehouseMedThingType[i], 0), 
			WarehouseMedThingQuan[i], 
			getThingPriceGos(WarehouseMedThingId[i], WarehouseMedThingType[i]) * WarehouseMedThingQuan[i]), strcat(lines,line);
	}
	ShowDialog(playerid,29,DIALOG_STYLE_TABLIST,"{ff9000}Склад Мед Оборудования",lines,"Выбрать","Отмена");
	return true;
}

// Собираем ящик с мед оборудованием с гос склада
stock GetMedEquipment(playerid, thingId, thingQuan, thingType)
{
	if(OnlineInfo[playerid][oInHandThing][0] > 0 || Hand[playerid] >= 1 || Hold[playerid] >= 1 || GetPlayerWeapon(playerid) >= WEAPON:2) 
		return ErrorMessage(playerid, "{FF6347}У вас заняты руки [ Предмет или оружие ]");

	new g = fraction(playerid);
	if(g == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Вы не состоите в организации");

	new price = getThingPriceGos(thingId, thingType) * thingQuan;
	if(OrganInfo[g][gMedMoney] < price) return ErrorMessage(playerid, "{FF6347}На депозите организации не хватает денег для оплаты мед оборудования");

	new getLimit = sklad_limit(thingId, thingType);
	if(get_sklad(g, thingId, thingType) + thingQuan > getLimit) return ErrorMessage(playerid, "{FF6347}На складе вашей организации нет места для этого предмета\
																							\n{ffcc66}Это означает, что сейчас нет необходимости доставлять товары на склад");

	OrganInfo[g][gMedMoney] -= price;
	OrganInfo[g][gMedMoneyUpdate] = true;

	GiveThingHand(playerid, thingId, thingQuan, 0, 0, thingType, 2);
	ApplyAnimation(playerid,"CARRY","liftup",4.0, false, true, true, false, 0); // Анимация поднять предмет
	PPP15[playerid] = 3; // Повторение анимации рук перед лицом
	RemovePlayerAttachedObject(playerid,1); // Удаляем прежний прикреплённый объект
	SetPlayerAttachedObject(playerid,1 , 3014, 6, 0.120000, 0.199448, -0.120000, 254.000000, 0.900000, 70.000000); // Создаём ящик в руках

	new string[40];
	format(string, sizeof(string), "собирает ящик: %s", GetNameThing(1, thingId, thingType, 0));
	SetPlayerChatBubble(playerid,string,COLOR_PURPLE,20.0,3000);
	PlayerPlaySound(playerid,1052,0,0,0);
	return true;
}

stock rank_organization(playerid, g)
{
	if(!GetAccessRankOrg(playerid, g, 5, NO_FBI)) return 1;
	DP[1][playerid] = g;
	new line[90],lines[2700];

	for(new i = 0; i < get_maxrank(g); i++)
	{
		format(line,sizeof(line),"{ff9000}%d. {cccccc}%s\n",i+1 ,RankOrg[g][i]), strcat(lines,line);
	}
	new header[60];
	format(header,sizeof(header),"{ff9000}Названия Рангов {cccccc}[%s]", AbbName[g]);
	ShowDialog(playerid,1006,DIALOG_STYLE_LIST,header,lines,"Выбрать","Отмена");
   	return 1;
}

// New members
CMD:members(playerid, const params[])
{
	new fractionid = fraction(playerid);
	if (PlayerInfo[playerid][pSoska] >= 1 && !isnull(params)) {
		sscanf(params, "d", fractionid);
		if (fractionid < 1 || fractionid > 24) return ErrorMessage(playerid, "{FF6347}ID организации не меньше 1 и не больше 24");
	} else if(fractionid == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");
	else if(!GetAccessRankOrg(playerid, fractionid, 78, NO_FBI)) return 1;

	PlayerPlaySound(playerid, 40405, 0, 0, 0);
	new str[214], sctring[4096], quan;
	
	format(str, sizeof(str), "{cccccc}Имя\t{cccccc}Ранг\t{FF6347}Выговоры\t{444444}AFK"), strcat(sctring, str);

	foreach(Player, i)
	{
		if(isPlayerEligible(i, fractionid, playerid))
		{
			formatPlayerInfo(str, sizeof(str), i, fractionid);
			strcat(sctring, str);
			quan ++;
		}
	}

	new qwer[100];
	new year, month, day;
	getdate(year, month, day);
	format(qwer, sizeof(qwer), "{cccccc}Участники %s {99ff66}Online: %d {ff9000}[%02d.%02d.%d]", frakName[fractionid], quan, day, month, year);

	new bool: not_my_members = fractionid != fraction(playerid);
	if (not_my_members) SetPVarInt(playerid, "NotMyMembers", 1);
	ShowDialog(playerid, 706, DIALOG_STYLE_TABLIST_HEADERS, qwer, sctring, "Ок", (not_my_members ? "" : "Назад"));

    return 1;
}

stock formatPlayerInfo(str[], size, playerid, g)
{
    new atext[10], btext[8], afkStatus[24] = "";

    // Формируем статус AFK
    if(GetPVarInt(playerid, "afksystem") >= 2) format(afkStatus, sizeof(afkStatus), "%s", fine_time(GetPVarInt(playerid, "afksystem")));

    // Проверяем статус трансмиттера игрока
    atext = PlayerInfo[playerid][pTransmitterOff][0] ? "{FF6347}*" : "{00ff66}*";

    // Определяем цвет для вывода в зависимости от роли игрока
    btext = PlayerInfo[playerid][pLeader] > 0 ? "0088ff" : "cccccc";

    // Форматируем информацию об игроке
    if(PlayerInfo[playerid][pFbi] > 0 && g == 2)
    {
        format(str, size, "\n%s {%s}%s {444444}UNDER{cccccc}\t%s [%d]\t \t{444444}%s", atext, btext, getPlayerNameTransmitter(playerid), 
			getNameRankPlayer(g, PlayerInfo[playerid][pFbi], PlayerInfo[playerid][pDivision][1], PlayerInfo[playerid][pDivRank][1]), PlayerInfo[playerid][pFbi], afkStatus);
    }
    else
    {
        format(str, size, "\n%s {%s}%s{cccccc}\t%s [%d]\t%d\t{444444}%s", atext, btext, getPlayerNameTransmitter(playerid), getNameRank(playerid), 
			PlayerInfo[playerid][pRank], PlayerInfo[playerid][pVig], afkStatus);
    }
}

stock isPlayerEligible(playerid, g, makeplayerid)
{
    // Проверяем, что игрок онлайн
    if(OnlineInfo[playerid][oLogged] == 0)
        return 0;

    // Проверяем принадлежность к фракции
    if(PlayerInfo[playerid][pMember] == g)
        return 1;

    // Дополнительные условия для специфических фракций или ролей
    // Например, для FBI или других специальных групп
    if(g == 2 && PlayerInfo[playerid][pFbi] > 0 && GetAccessRankOrgMay(makeplayerid, g, 47, NO_FBI))
        return 1;

    // По умолчанию возвращаем false, если ни одно условие не выполнено
    return 0;
}

// New members offline
CMD:membersoff(playerid)
{
	if(fraction(playerid) == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");
	new g = fraction(playerid), needg;
	if(!GetAccessRankOrg(playerid, g, 0, NO_FBI)) return 1;
	
	if(AntiFloodMysqlRequest(playerid, 30)) return 1;
	ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Участники Организации {ff0000}Offline","{cccccc}Поиск участников...","*","");
	
	needg = g;
	DP[2][playerid] = 0;
	DP[0][playerid] = needg;

	if(needg >= MAX_ORG) return ErrorMessage(playerid, "{FF6347}Ошибка! Неверный ID организации");

	new string[340];
	if(needg == 2) mysql_format(pearsq, string, sizeof(string), "SELECT user_id, Name, Leader, Rank, Vig, Offtime, Fbi, Division0, Division1, SignTransmitter, CallSign, \
		pDivRank0, pDivRank1 \
		FROM `pp_igroki` WHERE `Member`='%d' AND `Online`='0' OR `Fbi`>'0' AND `Online`='0' LIMIT 40", needg);
	else mysql_format(pearsq, string, sizeof(string), "SELECT user_id, Name, Leader, Rank, Vig, Offtime, Fbi, Division0, Division1, SignTransmitter, CallSign, \
		pDivRank0, pDivRank1 \
		FROM `pp_igroki` WHERE `Member` = '%d' AND `Online` = '0' LIMIT 40", needg);
	mysql_pquery(pearsq, string, "Call_mem", "dd", playerid, needg);
	return 1;
}

function Call_mem(playerid, g)
{
    if(!GetAccessRankOrg(playerid, g, 0, NO_FBI)) return 1;

    new rows, str[214], sctring[4096], datad1[24], datad4[24], datad2, datad3, kol, qwer[144], datad5, datad6, datad7, btext[8], Division0, Division1;
	new DivRank0, DivRank1;
	new bool:singTransmitter, SingName[24];
    cache_get_row_count(rows);

    if(rows == 0)
    {
        ShowDialog(playerid, 706, DIALOG_STYLE_MSGBOX, "{ff9000}Участники Организации", "{cccccc}Участники Offline в организации не найдены", "*", "");
        return 1;
    }

    format(str,sizeof(str),"{cccccc}Имя\t{cccccc}Ранг\t{FF6347}Выговоры\t{cccccc}Последняя Активность\n"), strcat(sctring,str);
	
    for(new i = 0; i < rows; i++)
    {
        cache_get_value_name(i, "Name", datad1, sizeof(datad1));
        cache_get_value_name_int(i, "Rank", datad2);
        cache_get_value_name_int(i, "Vig", datad3);
        cache_get_value_name(i, "Offtime", datad4, sizeof(datad4));
        cache_get_value_name_int(i, "user_id", datad5);
        cache_get_value_name_int(i, "Fbi", datad6);
        cache_get_value_name_int(i, "Leader", datad7);
		cache_get_value_name_int(i, "Division0", Division0);
		cache_get_value_name_int(i, "Division1", Division1);
		cache_get_value_name_int(i, "SignTransmitter", singTransmitter);
		cache_get_value_name(i, "CallSign", SingName, 24);
		cache_get_value_name_int(i, "pDivRank0", DivRank0);
		cache_get_value_name_int(i, "pDivRank1", DivRank1);

        btext = datad7 > 0 ? "0088ff" : "cccccc";
        formatPlayerInfoOff(str, sizeof(str), datad1, datad2, datad3, datad4, datad6, btext, g, Division0, Division1, singTransmitter, SingName, DivRank0, DivRank1);
        strcat(sctring, str);

        kol++;
        DP[1][playerid] = datad5;
    }

	new year, month, day;
    getdate(year, month, day);
	DP[2][playerid] ++; // Считаем страницы
	if(kol >= 40)
	{
		format(qwer,sizeof(qwer),"{ff9000}Участники %s {FF6347}Offline: %d {ff9000}[%02d.%02d.%d] Страница %d", frakName[g],kol, day,month,year, DP[2][playerid]);
		ShowDialog(playerid,855,DIALOG_STYLE_TABLIST_HEADERS,qwer,sctring,"Далее","");
	}
	else
	{
		format(qwer,sizeof(qwer),"{ff9000}Участники %s {FF6347}Offline: %d {ff9000}[%02d.%02d.%d] Страница %d", frakName[g],kol, day,month,year, DP[2][playerid]);
		ShowDialog(playerid,706,DIALOG_STYLE_TABLIST_HEADERS,qwer,sctring,"Ок","");
	}
    return 1;
}

stock formatPlayerInfoOff(str[], size, const name[], rank, vig, offtime[], fbi, const btext[], g, Division0, Division1, bool:singTransmitter, const SingName[], DivRank0, DivRank1)
{
    if(fbi > 0 && g == 2)
    {
        format(str, size, "\n{%s}%s {444444}UNDER{cccccc}\t%s [%d]\t \t{444444}%s", btext, 
			getPlayerNameTransmitterOffline(g, singTransmitter, name, SingName) , getNameRankPlayer(2, fbi, Division1, DivRank1), rank, offtime);
    }
    else
    {
        format(str, size, "\n{%s}%s{cccccc}\t%s [%d]\t%d\t{444444}%s", btext, 
			getPlayerNameTransmitterOffline(g, singTransmitter, name, SingName), getNameRankPlayer(g, rank, Division0, DivRank0), rank, vig, offtime);
    }
}

stock dialogCase_Organization(playerid, dialogid, response, listitem, const inputtext[])
{
	if(dialogid == 615) // lmenu
	{
	    if(response)
	    {
			if(listitem < 0 || listitem > 199) return 1;
			open_detail_lmenu(playerid, List[listitem][playerid]);
        }
	}
	if(dialogid == 1006) // Названия рангов
	{
	    new g = DP[1][playerid]; // ID Организации
		if(response)
		{
			new string[60];
		    new nrank = get_maxrank(g);
			if(listitem < 0 || listitem > nrank) return format(string, sizeof(string), "{FF6347}Максимальное количество рангов: %d",nrank), ErrorMessage(playerid, string);
			DP[0][playerid] = listitem; // Ранг
 			format(string, sizeof(string), "{cccccc}Введите название для {ff9000}%d ранга",listitem+1);
 			ShowDialog(playerid,1007,DIALOG_STYLE_INPUT,"{ff9000}Названия Рангов",string,"Принять","Отмена");
		}
		else showDialogOrganizationMenu(playerid);
	}
	if(dialogid == 1007)
	{
		new g = DP[1][playerid];
		if(response)
		{
			new rankId = DP[0][playerid];
			if(!strlen(inputtext)) return rank_organization(playerid, g);
			if(checksimvol(inputtext)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Хм... я пытаюсь указать в названии какие-то каракули... [ Запрещённый Символ ]"), rank_organization(playerid, g);
			if(strlen(inputtext) < 3 || strlen(inputtext) >= MAX_NAME_LENGTH) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Название должно быть не больше 30-ти и не меньше 3-ёх символов.."), rank_organization(playerid, g);
			PlayerPlaySound(playerid,6401,0,0,0);
            OrgLog(g, "rank", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", rankId+1, inputtext);
            strmid(RankOrg[g][rankId], inputtext, 0, 34, 255);
   			rank_organization(playerid, g);
   			SaveRank(g, rankId);
		}
		else rank_organization(playerid, g);
	}
	if(dialogid == 1331) // Количество рангов
	{
		if(response)
		{
			new input;
			new g = fraction(playerid);

			if(sscanf(inputtext, "i", input)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogOrganizationMenu(playerid);
			if(input > MAX_RANK_ORG || input < 2)
			{
				new string[60];
				format(string,sizeof(string),"[ Мысли ]: Не меньше 2 и не больше %d рангов", MAX_RANK_ORG);
				ErrorText(playerid, string);
				showDialogOrganizationMenu(playerid);
				return 1;
			}

			if(OrganInfo[g][gMaxRanks] == input) return ErrorText(playerid, "[ Мысли ]: Это количество рангов уже указано"), showDialogOrganizationMenu(playerid);
			OrganInfo[g][gMaxRanks] = input;
			mysql_SaveOrganization(g, "pp_organization", "gMaxRanks", OrganInfo[g][gMaxRanks]);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			showDialogOrganizationMenu(playerid);
			OrgLog(g, "ranks", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", input, "");
		}
		else showDialogOrganizationMenu(playerid);
	}
	if(dialogid == _:ORGANIZATION_AVAILABLE_WEAPONS) // Настройка доступа ко складу для участников без подфракции
	{
		new g = fraction(playerid);
		if (!response) return SettingSkladOrganization(playerid, g);

		// Установка нового значения
		new weapon = List[listitem][playerid];
		OrganInfo[g][gAvailableWeapons][weapon] ^= true;

		// Сохранение
		new available_weapons_str[40 * 2];
		for (new weaponid = 0; weaponid < 38; weaponid++)
			format(available_weapons_str, sizeof(available_weapons_str), "%s%d|", available_weapons_str, OrganInfo[g][gAvailableWeapons][weaponid]);
		new string_mysql[256];
		mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_organization` SET `gAvailableWeapons` = '%e' WHERE frakid = %d", available_weapons_str, g);
		mysql_tquery(pearsq, string_mysql);

		return ShowAvailableOrganizationWeapons(playerid, g);
	}
	return 1;
}

stock mysql_SaveOrganization(orgId, const db_name[], const name[], value) // Сохраняем одну строку в базу
{
	new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `%e` SET `%e` = '%d' WHERE `frakid` = '%d'", db_name, name, value, orgId);
	query_empty(pearsq, string_mysql);
	return 1;
}

stock SaveRank(orgId, rankId)
{
	new string_mysql[160];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_organization` SET `rank%d` = '%e' WHERE `frakid` = '%d'", rankId, RankOrg[orgId][rankId], orgId);
	query_empty(pearsq, string_mysql);
	return 1;
}

stock SaveAllRanks(orgId)
{
	new string_mysql[2000];
	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_organization` SET `rank0` = '%e'", RankOrg[orgId][0]); // 44 + 31

	for(new i = 0; i < MAX_RANK_ORG; i++) 
	{
		mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s, `rank%d` = '%e'", string_mysql, i, RankOrg[orgId][i]); // 20 + 2 + 31
	}
    format(string_mysql,sizeof(string_mysql),"%s WHERE `frakid` = '%d'", string_mysql, orgId); // 25 + 11
	query_empty(pearsq, string_mysql);
}

stock IsAvailableOrganizationWeapon(g, weaponid) {
	if (g < 1 || g > MAX_ORG) return 1;
	return OrganInfo[g][gAvailableWeapons][weaponid];
}

stock ShowAvailableOrganizationWeapons(playerid, g) {
	if (!IsSubLeader(playerid) && !IsLeader(playerid)) return ErrorMessage(playerid, "Редактирование доступных на складе оружий доступно только заместителю и лидеру организации");

	new dialog_header[128];
	format(dialog_header, sizeof(dialog_header), "{ff9000}Доступное оружие %s", frakName[g]);

	DP[1][playerid] = g;

	new dialog_text[256], quan;

	for (new weaponid = 0; weaponid < 38; weaponid++) {
		if (!IsDefaultOrderDepartWeapon(weaponid)) continue;

		format(dialog_text, sizeof(dialog_text), "%s\n{%s}%s", dialog_text, OrganInfo[g][gAvailableWeapons][weaponid] ? "99ff66" : "ff6347", GetNameThing(0, weaponid, 1, 0));

		List[quan][playerid] = weaponid;
		quan++;
	}

	ShowDialog(playerid, _:ORGANIZATION_AVAILABLE_WEAPONS, DIALOG_STYLE_LIST, dialog_header, dialog_text, "Выбрать", "Назад");

	return 1;
}

stock ReloadRank(playerid, g) // Сброс названий рангов
{
	if(g == 1)
	{
		strmid(RankOrg[g][14], "Шеф Полиции LS", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][13], "Ассистент шефа полиции", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][12], "Помощник шефа полиции", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][11], "Коммандер", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][10], "Капитан", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][9], "Лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Сержант II", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Сержант I", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Детектив", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Офицер полиции III+I", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Офицер полиции III", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Офицер полиции II", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Офицер полиции I", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Кадет", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Студент академии", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 15;
	}
	else if(g == 2)
	{
		strmid(RankOrg[g][13], "Директор FBI", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][12], "Заместитель директора FBI", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][11], "Инспектор FBI", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][10], "Глава академии FBI", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][9], "Глава NSB", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Глава CID", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Глава DEA", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Секретный агент", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Старший специальный агент", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Специальный агент", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Старший агент", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Федеральный агент", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Младший агент", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Стажёр", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 14;
	}
	else if(g == 3)
	{
		strmid(RankOrg[g][19], "Генерал NGSA", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][18], "Генерал СВ", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][17], "Генерал-лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][16], "Генерал-майор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][15], "Полковник", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][14], "Подполковник", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][13], "Майор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][12], "Капитан", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][11], "Первый лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][10], "Второй лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][9], "Сержант-майор СВ", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Команд-сержант-майор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Мастер-сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Первый сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Сержант 1 класса", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Штаб-сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Капрал", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Рядовой", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Рядовой-рекрут", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 20;
	}
	else if(g == 4)
	{
		strmid(RankOrg[g][11], "Декан", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][10], "Зам. Декана", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][9], "Мед. Специалист", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Младший Мед. Специалист", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Лектор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Хирург", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Психиатр", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Терапевт", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Реаниматолог", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Парамедик EMT-B", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Парамедик CFR", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Интерн", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 12;
	}
	else if(g == 5)
	{
		strmid(RankOrg[g][9], "Godfather", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Consigliere", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Persone di Onore", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Veterano", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Caporegime", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Sotto Capo", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Guerra Soldier", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Cavalli Soldier", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Castello Soldier", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Antonelli Soldier", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 6)
	{
		strmid(RankOrg[g][9], "Shubo-sha", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Migiude", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Seji", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Dangan", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Kira", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Senshi", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Benri-ya", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Chujitsuna", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Sentoki", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Shoshinsha", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 7)
	{
		strmid(RankOrg[g][21], "Президент", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][20], "Вице-президент", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][19], "Государственный Секретарь", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][18], "Министр Финансов", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][17], "Министр Обороны", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][16], "Генеральный Прокурор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][15], "Министр Внутренней Безопасности", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][14], "Министр Образования", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][13], "Министр Здравоохранения", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][12], "Главный Судья", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][11], "Судья", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][10], "Федеральный Прокурор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][9], "Прокурор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Адвокат", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Спикер", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Конгрессмен", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Директор Секретной Службы", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Зам. Директора Секретной Службы", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Агент Секретной Службы", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Водитель", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Секретарь", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Клерк", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 22;
	}
	else if(g == 8)
	{
		strmid(RankOrg[g][10], "Директор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][9], "Зам. Директора", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Управляющий", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Почётный Агент", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Профессионал", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Спец. Агент", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Агент №", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Киллер №", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Наёмник №", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Убийца №", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Стажер №", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 11;
	}
	else if(g == 9)
	{
		strmid(RankOrg[g][9], "Директор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Зам. Директора", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Главный Редактор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Редактор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Корреспондент", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Журналист", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Ведущий Новостей", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Папарацци", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Водитель- оператор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Стажёр", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 10)
	{
		strmid(RankOrg[g][9], "Xiansheng", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Laoban", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Zuoyoushou", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Jingli", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Shulian", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Dangdi", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Kekao", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Fei", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Zhanxin", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Guowai", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 11)
	{
		strmid(RankOrg[g][14], "Шеф Полиции SF", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][13], "Ассистент шефа полиции", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][12], "Помощник шефа полиции", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][11], "Коммандер", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][10], "Капитан", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][9], "Лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Сержант II", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Сержант I", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Детектив", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Офицер полиции III+I", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Офицер полиции III", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Офицер полиции II", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Офицер полиции I", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Кадет", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Студент академии", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 15;
	}
	else if(g == 12)
	{
		strmid(RankOrg[g][9], "Авторитет", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Аристократ", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Вор в законе", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Вор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Жиган", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Вышибала", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Фраер", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Бандит", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Щипач", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Шнырь", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 13)
	{
		strmid(RankOrg[g][9], "Ringleader", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Big Brother", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Authority", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Enemy of the people", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Gangster", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Killer", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Street Wolf", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Bully", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Small", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Nigga", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 14)
	{
		strmid(RankOrg[g][9], "Gold Lord", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Right Hand", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Great", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Mad Dog", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Daring", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Crazy Man", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Skilled", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Offender", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Weak", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Newbie", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 15)
	{
		strmid(RankOrg[g][9], "Padre", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Subjefe", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Adjunto", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Autoridad", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Soldado", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Muchachos", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Hermano", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Amigo", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Primerizo", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Novato", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 16)
	{
		strmid(RankOrg[g][9], "El Fuerte", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Mejor Amigo", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Derecho", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Local", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Asesino", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Companero", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Amigo", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Sazonado", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Principiante", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Criado", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 17)
	{
		strmid(RankOrg[g][9], "Padre", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Fuerte", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Estrenador", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Amigo", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Latino", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Estimado", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Ordinarjo", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Novato", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Estranjo", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Raro", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 18)
	{
		strmid(RankOrg[g][9], "Al-Sheikh", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Hubal", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Kibar", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Mas-Ula", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Shahid", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Ierahabi", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "El-Ebon", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Rok-Ik", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Paratur", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Muntode", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 19)
	{
		strmid(RankOrg[g][9], "Глава Стритрейсеров", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Pro Racer", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Неуловимый", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Профи", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Pro Дрифтер", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Дрифтер", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Уличный Гонщик", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Начинающий Гонщик", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Механик", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Новичок", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 20)
	{
		strmid(RankOrg[g][9], "Король Дорог", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Байкер-Авторитет", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Викинг", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Умелец", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Байкер", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Гонщик", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Бывалый", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Знаток", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Любитель", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Новичок", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 10;
	}
	else if(g == 21)
	{
		strmid(RankOrg[g][14], "Шеф Полиции LV", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][13], "Ассистент шефа полиции", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][12], "Помощник шефа полиции", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][11], "Коммандер", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][10], "Капитан", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][9], "Лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Сержант II", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Сержант I", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Детектив", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Офицер полиции III+I", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Офицер полиции III", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Офицер полиции II", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Офицер полиции I", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Кадет", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Студент академии", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 15;
	}
	else if(g == 22)
	{
		strmid(RankOrg[g][14], "Командир", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][13], "Зам. Командира", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][12], "Полковник", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][11], "Подполковник", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][10], "Майор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][9], "Капитан", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Старший Лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Младший Лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Старший Прапорщик", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Прапорщик", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Старший Сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Младший Сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Стажер", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 15;
	}
	/*else if(g == 26) // SAFD
	{
		strmid(RankOrg[g][11], "Декан", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][10], "Пожарный шеф", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][9], "Зам. пожарного шефа", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Командир батальона", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Капитан", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Инструктор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Следователь по поджогам", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Инженер", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Пожарный III", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Пожарный II", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Пожарный I", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 12;
	}*/
	/*else if(g == 31) // ВВС
	{
		strmid(RankOrg[g][19], "Генерал NGSA", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][18], "Генерал ВВС", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][17], "Генерал-лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][16], "Генерал-майор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][15], "Полковник", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][14], "Подполковник", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][13], "Майор", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][12], "Капитан", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][11], "Первый лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][10], "Второй лейтенант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][9], "Главный мастер-сержант ВВС", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Главный мастер-сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Главный мастер-сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Старший мастер-сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Мастер-сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Техник-сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Штаб-сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Сержант", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Рядовой авиации", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Рядовой-рекрут авиации", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 20;
	}*/
	/*else if(g == 33) // ВМС
	{
		strmid(RankOrg[g][19], "Генерал NGSA", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][18], "Адмирал ВМС", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][17], "Вице-адмирал", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][16], "Контр-адмирал", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][15], "Капитан флота", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][14], "Коммандер", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][13], "Лейтенант-коммандер", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][12], "Лейтенант флота", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][11], "Младший лейтенант флота", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][10], "Энсин", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][9], "Главный мастер-старшина ВМС", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][8], "Главный мастер-старшина", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][7], "Главный старшина", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][6], "Первый главный старшина", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][5], "Главный старшина", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][4], "Старшина 1 класса", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][3], "Старшина 2 класса", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][2], "Старшина 3 класса", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][1], "Матрос", 0, MAX_NAME_LENGTH, 255);
		strmid(RankOrg[g][0], "Матрос-рекрут", 0, MAX_NAME_LENGTH, 255);
		OrganInfo[g][gMaxRanks] = 20;
	}*/
	OrganInfo[g][gUpdRank] = 1;
	mysql_SaveOrganization(g, "pp_organization", "gMaxRanks", OrganInfo[g][gMaxRanks]);
	OrgLog(g, "rrank", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
	return 1;
}

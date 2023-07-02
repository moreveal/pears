
#define MAX_ACC 100 // Максимальное количество команд по правам доступа у организаций

enum gInfo
{
	glave,
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
	gAcc[MAX_ACC],
	gBattle,
	gInterval,
	gInvent[20],
	gInv[20],
	gInvType[20],
	gInvPara[20],
	gUpdate,
	gUpdateSklad,
	gUpdRank, // Статус обновления рангов
	gUpdSkin, // Статус обновления скинов
	gGuardStat[20],
	Float:gGu_X[20],
	Float:gGu_Y[20],
	Float:gGu_Z[20],
	gGuInt[20],
	gGuWorld[20],
	Text3D:gGuLabel[20],
	gGuPickup[20],
	gGuOccup[20],
	bool:gSCbug, // Последняя битва был ли +C Bug
	gSanCbug, // Санкция от админов на +C баг
	bool:gRejim2, // Включён ли режим +C баг
	gCapture[13], // Общая стата каптов
	gUnitStat[24], // Настройки юнитов
	gCash, // Счет организации (открыт или нет)
	gCarAcc[10], // Права доступа к транспорту
	gMap, // ID Загруженной карты
	gSkin[20], // ID Скина
	gSkinPrice[20], // Стоимость Скина
	gSkinRank[20], // С какого ранга доступен скин
	gMaxRanks // Максимальное количество рангов
};
new OrganInfo[35][gInfo];
new RankOrg[35][22][34];

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

function LoadOrgan()
{
	new time = GetTickCount();
	new rows, idx,strFromFile2[256],atext[14], btext[14], ctext[14], dtext[14], etext[14], ftext[14], string[34];
	cache_get_row_count(rows);
	for(new f; f<rows; ++f)
	{
		cache_get_value_name_int(f, "frakid", idx);
		cache_get_value_name_int(f, "lave", OrganInfo[idx][glave]);
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
    	}
		cache_get_value_name_int(f, "interval", OrganInfo[idx][gInterval]);
		
		for(new i = 0; i < 20; i++)
    	{
    	    format(string,sizeof(string),"Invent%d", i), cache_get_value_name_int(f, string, OrganInfo[idx][gInvent][i]);
    	    format(string,sizeof(string),"Inv%d", i), cache_get_value_name_int(f, string, OrganInfo[idx][gInv][i]);
    	    format(string,sizeof(string),"InvType%d", i), cache_get_value_name_int(f, string, OrganInfo[idx][gInvType][i]);
    	    format(string,sizeof(string),"InvPara%d", i), cache_get_value_name_int(f, string, OrganInfo[idx][gInvPara][i]);
    	}
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
		cache_get_value_name(f, "rank1", RankOrg[idx][0], 34);
		cache_get_value_name(f, "rank2", RankOrg[idx][1], 34);
		cache_get_value_name(f, "rank3", RankOrg[idx][2], 34);
		cache_get_value_name(f, "rank4", RankOrg[idx][3], 34);
		cache_get_value_name(f, "rank5", RankOrg[idx][4], 34);
		cache_get_value_name(f, "rank6", RankOrg[idx][5], 34);
		cache_get_value_name(f, "rank7", RankOrg[idx][6], 34);
		cache_get_value_name(f, "rank8", RankOrg[idx][7], 34);
		cache_get_value_name(f, "rank9", RankOrg[idx][8], 34);
		cache_get_value_name(f, "rank10", RankOrg[idx][9], 34);
		cache_get_value_name(f, "rank11", RankOrg[idx][10], 34);
		cache_get_value_name(f, "rank12", RankOrg[idx][11], 34);
		cache_get_value_name(f, "rank13", RankOrg[idx][12], 34);
		cache_get_value_name(f, "rank14", RankOrg[idx][13], 34);
		cache_get_value_name(f, "rank15", RankOrg[idx][14], 34);
		cache_get_value_name(f, "rank16", RankOrg[idx][15], 34);
		cache_get_value_name(f, "rank17", RankOrg[idx][16], 34);
		cache_get_value_name(f, "rank18", RankOrg[idx][17], 34);
		cache_get_value_name(f, "rank19", RankOrg[idx][18], 34);
		cache_get_value_name(f, "rank20", RankOrg[idx][19], 34);
		cache_get_value_name(f, "rank21", RankOrg[idx][20], 34);
		cache_get_value_name(f, "rank22", RankOrg[idx][21], 34);

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
		cache_get_value_name_int(f, "skin0", OrganInfo[idx][gSkin][0]);
		cache_get_value_name_int(f, "skin1", OrganInfo[idx][gSkin][1]);
		cache_get_value_name_int(f, "skin2", OrganInfo[idx][gSkin][2]);
		cache_get_value_name_int(f, "skin3", OrganInfo[idx][gSkin][3]);
		cache_get_value_name_int(f, "skin4", OrganInfo[idx][gSkin][4]);
		cache_get_value_name_int(f, "skin5", OrganInfo[idx][gSkin][5]);
		cache_get_value_name_int(f, "skin6", OrganInfo[idx][gSkin][6]);
		cache_get_value_name_int(f, "skin7", OrganInfo[idx][gSkin][7]);
		cache_get_value_name_int(f, "skin8", OrganInfo[idx][gSkin][8]);
		cache_get_value_name_int(f, "skin9", OrganInfo[idx][gSkin][9]);
		cache_get_value_name_int(f, "skin10", OrganInfo[idx][gSkin][10]);
		cache_get_value_name_int(f, "skin11", OrganInfo[idx][gSkin][11]);
		cache_get_value_name_int(f, "skin12", OrganInfo[idx][gSkin][12]);
		cache_get_value_name_int(f, "skin13", OrganInfo[idx][gSkin][13]);
		cache_get_value_name_int(f, "skin14", OrganInfo[idx][gSkin][14]);
		cache_get_value_name_int(f, "skin15", OrganInfo[idx][gSkin][15]);
		cache_get_value_name_int(f, "skin16", OrganInfo[idx][gSkin][16]);
		cache_get_value_name_int(f, "skin17", OrganInfo[idx][gSkin][17]);
		cache_get_value_name_int(f, "skin18", OrganInfo[idx][gSkin][18]);
		cache_get_value_name_int(f, "skin19", OrganInfo[idx][gSkin][19]);
		cache_get_value_name_int(f, "skinprice0", OrganInfo[idx][gSkinPrice][0]);
		cache_get_value_name_int(f, "skinprice1", OrganInfo[idx][gSkinPrice][1]);
		cache_get_value_name_int(f, "skinprice2", OrganInfo[idx][gSkinPrice][2]);
		cache_get_value_name_int(f, "skinprice3", OrganInfo[idx][gSkinPrice][3]);
		cache_get_value_name_int(f, "skinprice4", OrganInfo[idx][gSkinPrice][4]);
		cache_get_value_name_int(f, "skinprice5", OrganInfo[idx][gSkinPrice][5]);
		cache_get_value_name_int(f, "skinprice6", OrganInfo[idx][gSkinPrice][6]);
		cache_get_value_name_int(f, "skinprice7", OrganInfo[idx][gSkinPrice][7]);
		cache_get_value_name_int(f, "skinprice8", OrganInfo[idx][gSkinPrice][8]);
		cache_get_value_name_int(f, "skinprice9", OrganInfo[idx][gSkinPrice][9]);
		cache_get_value_name_int(f, "skinprice10", OrganInfo[idx][gSkinPrice][10]);
		cache_get_value_name_int(f, "skinprice11", OrganInfo[idx][gSkinPrice][11]);
		cache_get_value_name_int(f, "skinprice12", OrganInfo[idx][gSkinPrice][12]);
		cache_get_value_name_int(f, "skinprice13", OrganInfo[idx][gSkinPrice][13]);
		cache_get_value_name_int(f, "skinprice14", OrganInfo[idx][gSkinPrice][14]);
		cache_get_value_name_int(f, "skinprice15", OrganInfo[idx][gSkinPrice][15]);
		cache_get_value_name_int(f, "skinprice16", OrganInfo[idx][gSkinPrice][16]);
		cache_get_value_name_int(f, "skinprice17", OrganInfo[idx][gSkinPrice][17]);
		cache_get_value_name_int(f, "skinprice18", OrganInfo[idx][gSkinPrice][18]);
		cache_get_value_name_int(f, "skinprice19", OrganInfo[idx][gSkinPrice][19]);
		cache_get_value_name_int(f, "skinrank0", OrganInfo[idx][gSkinRank][0]);
		cache_get_value_name_int(f, "skinrank1", OrganInfo[idx][gSkinRank][1]);
		cache_get_value_name_int(f, "skinrank2", OrganInfo[idx][gSkinRank][2]);
		cache_get_value_name_int(f, "skinrank3", OrganInfo[idx][gSkinRank][3]);
		cache_get_value_name_int(f, "skinrank4", OrganInfo[idx][gSkinRank][4]);
		cache_get_value_name_int(f, "skinrank5", OrganInfo[idx][gSkinRank][5]);
		cache_get_value_name_int(f, "skinrank6", OrganInfo[idx][gSkinRank][6]);
		cache_get_value_name_int(f, "skinrank7", OrganInfo[idx][gSkinRank][7]);
		cache_get_value_name_int(f, "skinrank8", OrganInfo[idx][gSkinRank][8]);
		cache_get_value_name_int(f, "skinrank9", OrganInfo[idx][gSkinRank][9]);
		cache_get_value_name_int(f, "skinrank10", OrganInfo[idx][gSkinRank][10]);
		cache_get_value_name_int(f, "skinrank11", OrganInfo[idx][gSkinRank][11]);
		cache_get_value_name_int(f, "skinrank12", OrganInfo[idx][gSkinRank][12]);
		cache_get_value_name_int(f, "skinrank13", OrganInfo[idx][gSkinRank][13]);
		cache_get_value_name_int(f, "skinrank14", OrganInfo[idx][gSkinRank][14]);
		cache_get_value_name_int(f, "skinrank15", OrganInfo[idx][gSkinRank][15]);
		cache_get_value_name_int(f, "skinrank16", OrganInfo[idx][gSkinRank][16]);
		cache_get_value_name_int(f, "skinrank17", OrganInfo[idx][gSkinRank][17]);
		cache_get_value_name_int(f, "skinrank18", OrganInfo[idx][gSkinRank][18]);
		cache_get_value_name_int(f, "skinrank19", OrganInfo[idx][gSkinRank][19]);
		if(idx == 13 || idx == 14 || idx == 15 || idx == 16)
		{
			if(OrganInfo[idx][gMap] >= 1)
			{
			    MysqlRaceMapFrak[idx] = 1;
				format(strFromFile2, sizeof(strFromFile2), "SELECT * FROM `pp_mapfrak` WHERE `frakid` = '%d' AND `mapid` = '%d' LIMIT 200", idx, OrganInfo[idx][gMap]);
				mysql_tquery(pearsq, strFromFile2, "call_loadmap", "ddd", -1, idx, OrganInfo[idx][gMap]);
			}
		}
	}
	UpdateHonor(1), UpdateHonor(2);
	OrganInfo[0][gstat2] = 0;
    SaveOrgan(0);

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

	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n\n{ffffff}[ Заправить Цистерну - {0088ff}CAPS LOCK (Гудок) {ffffff}]",OrganInfo[33][gbenz]);
	FrakiBenz[5] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1400.3053,456.5131,7.1809,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[33][gbenz]);
	FrakiBenz[8] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1354.442749, 385.154052, 1.907501,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[33][gbenz]);
	FrakiBenz[10] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1354.441894, 349.254119, 1.907502,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[33][gbenz]);
	FrakiBenz[12] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1319.4836,493.9069,18.2344,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[33][gbenz]);
	FrakiBenz[20] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1256.6936,428.4373,24.7980,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[33][gbenz]);
	FrakiBenz[21] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,-1246.7941,439.3991,7.1875,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);

    format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]\n[ Заправить Цистерну - {0088ff}CAPS LOCK (Гудок) {ffffff}]",OrganInfo[1][gbenz]);
    FrakiBenz[15] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,1585.1392,-1680.3263,5.8970,7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    format(strFromFile2,sizeof(strFromFile2),"{ffffff}* {0088ff}Топливо {ffffff}[ {0088ff}%d л. {ffffff}] *\n{ffffff}[ {0088ff}/fill {ffffff}]",OrganInfo[1][gbenz]);
    FrakiBenz[16] = CreateDynamic3DTextLabel(strFromFile2,0xA9C4E4FF,1568.0873,-1639.4658,28.4021,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
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
    RingText[5] = CreateDynamic3DTextLabel("{ff9000}Ринг {ff9000}Тюрьма {cccccc}[ ALT ]",0xA9C4E4FF,1411.0948,-133.2543,26.7904,10.0);
    RingText[6] = CreateDynamic3DTextLabel("{ff9000}Ринг {ff9000}Тюрьма {cccccc}[ ALT ]",0xA9C4E4FF,1402.0885,-122.4158,26.7904,10.0);
    RuletText[0] = CreateDynamic3DTextLabel("{ff9000}Рулетка\n{cccccc}ALT - Играть\n{cccccc}ENTER - выйти",-1,2182.339599, 1011.979858, 992.618713,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,2001,55); // 0
    RuletText[1] = CreateDynamic3DTextLabel("{ff9000}Рулетка\n{cccccc}ALT - Играть\n{cccccc}ENTER - выйти",-1,2182.339599, 1017.982482, 992.618713,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,2001,55); // 1
    RuletText[2] = CreateDynamic3DTextLabel("{ff9000}Рулетка\n{cccccc}ALT - Играть\n{cccccc}ENTER - выйти",-1,2182.339599, 1023.986572, 992.618713,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,2001,55); // 2
    RuletObject[0] = CreateDynamicObject(1979, RuletPos[0][0], RuletPos[0][1], RuletPos[0][2], 0.000000, 0.000000, 0.000000, 2001, 55, -1, 300.00, 300.00); // ruletka (2)
	RuletObject[1] = CreateDynamicObject(1979, RuletPos[1][0], RuletPos[1][1], RuletPos[1][2], 0.000000, 0.000000, 0.000000, 2001, 55, -1, 300.00, 300.00); // ruletka (1)
	RuletObject[2] = CreateDynamicObject(1979, RuletPos[2][0], RuletPos[2][1], RuletPos[2][2], 0.000000, 0.000000, 0.000000, 2001, 55, -1, 300.00, 300.00); // ruletka (0)

	DBLabel = CreateDynamic3DTextLabel("{ff9000}База Данных SWAT\n\n{cccccc}Статус: {99ff66}Активна",-1,2466.4614,2546.1318,22.0781,15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	DBInfo[dbHacker] = -1;
	load_ammosv(); // Загружаем ящики на склад NGSA
	dirtunix = gettime()+600;

	printf("[MODE]: Организации [%d ms]",GetTickCount() - time);
	return 1;
}

// Склад организации
function gunsklad(playerid)
{
	new skladstat = IsAGunSklad(playerid);
	if(skladstat > 0)
	{
	    new fpick = OnlineInfo[playerid][oInHandThing][0], fquan = OnlineInfo[playerid][oInHandThing][1], fpara = OnlineInfo[playerid][oInHandThing][2], thingType = OnlineInfo[playerid][oInHandThing][4], thingPack = OnlineInfo[playerid][oInHandThing][5];
		if(fpick > 0 && thingPack == 2) //  Кладём Ящик
		{
		    if(fpick >= 4 && fpick <= 7 && (skladstat == 1 || skladstat == 3 || skladstat == 4 || skladstat == 7 || skladstat == 9 || skladstat == 11 || skladstat == 21 || skladstat == 22 || skladstat == 29 || skladstat == 33)) return ErrorMessage(playerid, "{FF6347}На этом складе нельзя хранить вещества");

			if(fpick == 34 && thingType == 1 && skladstat != 8 && skladstat != 22) return ErrorMessage(playerid, "{FF6347}На этом складе нельзя хранить снайперскую винтовку\n{cccccc}[Только для ICA, SWAT]");
			if((fpick >= 4 && fpick <= 7 || fpick >= 27 && fpick <= 30) && thingType == 0 || IsHelmet(fpick) && thingType == 2 || IsArmor(fpick) && thingType == 2 || thingType == 1)
			{
			    if(thingType == 1) fpara = 300000;
			    if(IsHelmet(fpick) && thingType == 2) fpara = 3;
			    if(IsArmor(fpick) && thingType == 2) fpara = 100;
			
			    new put_inva = putsklad(skladstat, fpick, fquan, fpara, thingType); // Кладём предмет
				if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}На складе организации, для этого предмета, нет места [ Лимит ]");

				InHandClear(playerid);
				if(PlayerInfo[playerid][pSex] == 1) format(store,sizeof(store),"[ Мысли ]: Я положил на склад {ff9000}%s | %d",GetNameThing(1, fpick, thingType, thingPack),fquan);
				else format(store,sizeof(store),"[ Мысли ]: Я положила на склад {ff9000}%s | %d",GetNameThing(1, fpick, thingType, thingPack),fquan);
    			SendClientMessage(playerid, COLOR_GREY, store);
				OrgLog(skladstat, "putsklad", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fquan, GetNameThing(1, fpick, thingType, thingPack));

	   		    SetPlayerChatBubble(playerid,"кладёт ящик на склад",COLOR_PURPLE,20.0,3000);
	       	    RemovePlayerAttachedObject(playerid,1);
	       	    PPP15[playerid] = 0;
	       	    ApplyAnimation(playerid,"CARRY","putdwn",4.0,0,0,0,0,0,1);
	       	    PlayerPlaySound(playerid,6401,0,0,0);

	       	    // Выдаём юниты
	       	    if(OrganInfo[fraction(playerid)][gUnitStat][2] > 0)
	   			{
	   			    new kol;
	   				if((fpick >= 4 && fpick <= 7 || fpick >= 27 && fpick <= 30) && thingType == 0) kol = fquan; // Вещества, Патроны
	   				else if(IsHelmet(fpick) && thingType == 2 || IsArmor(fpick) && thingType == 2 || thingType == 1) kol = fquan*1000; // Каска, Броня, Оружие
	   				PlayerInfo[playerid][pUnit] += kol*OrganInfo[fraction(playerid)][gUnitStat][2];
	   				format(store,sizeof(store),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Unit: ~w~+%d",kol*OrganInfo[fraction(playerid)][gUnitStat][2]);
	   				GameTextForPlayer(playerid,store,3000,3);
				}

				// Выдаём ачивку, первый доставленный ящик
				if(PlayerInfo[playerid][pAchieve][99] == 0) AchievePlayer(playerid, 99, 1);
  	    	}
			else ErrorMessage(playerid, "{FF6347}Содержимое ящика в руках не может храниться на этом складе");
		}
		else ErrorMessage(playerid, "{FF6347}У вас в руках нет ящика");
	}
	return 1;
}
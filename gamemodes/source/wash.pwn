
enum WASHPOSENUM { Float:Wash_X, Float:Wash_Y, Float:Wash_Z, World, Interior }
new WashPos[][WASHPOSENUM] =
{
	{ -3.1652,1563.5146,12.7716, WORLD_TRAILER,INT_TRAILER }, // душевая в трейлере
	{ 1021.9533,2446.5547,10.8409, WORLD_PRISON_LAUNDY,INT_PRISON_LAUNDY }, // wash prison laundy
	{ 1027.4479,2446.9988,10.8409, WORLD_PRISON_LAUNDY,INT_PRISON_LAUNDY }, // wash prison laundy
	{ 1307.7063,1293.1716,1558.2050, 1,85 }, // wash
	{ 1299.9171,1315.3649,1558.2050, 1,85 }, // wash
	{ 1382.3269,-11.7618,1000.9258, 239,239 }, // wash
	{ 2606.0667,924.6343,1551.0029, -1,249 }, // wash
	{ 2488.8567,-1699.2834,2077.5850, 212,212 }, // wash grove
	{ 2477.4895,-2017.9043,2052.2810, 213,213 }, // wash ballas
	{ 2248.5010,-1460.5240,2089.4373, 214,214 }, // wash vagos
	{ 1665.7922,-2104.4722,2091.8059, 215,215 }, // wash aztecas
	{ 1373.2637,1554.4023,10.8584, 231,231 }, // wash nasa жилой модуль луна
	{ 1373.2637,1554.4023,10.8584, 232,232 }, // wash nasa жилой модуль марс
	{ 1666.5266,-2281.7371,30.3457, -1,0 }, // душ в отеле ls
	{ 1758.8577,1372.1455,28.0538, -1,0 }, // душ в отеле lv

    // Душ в спортзале
    { 1736.2831,-1204.0496,81.5090, WORLD_GYM, INT_GYM },
    { 1736.2827,-1206.4207,81.5090, WORLD_GYM, INT_GYM },
    { 1727.5959,-1204.1111,81.5090, WORLD_GYM, INT_GYM },
    { 1727.5958,-1206.5706,81.5090, WORLD_GYM, INT_GYM },
    { 1736.2220,-1231.4534,81.5090, WORLD_GYM, INT_GYM },
    { 1736.2228,-1233.9146,81.5090, WORLD_GYM, INT_GYM },
    { 1727.5952,-1234.0465,81.5090, WORLD_GYM, INT_GYM },
    { 1727.5955,-1231.5603,81.5090, WORLD_GYM, INT_GYM }
};

stock CreateWash()
{
    for(new i = 0; i < sizeof(WashPos); i++)
	{
        CreateDynamic3DTextLabel("{ff9000}Душевая\n{ffffff}[ ALT ]\n\n{cccccc}Соблюдайте гигиену и мойтесь", 0xFFFFFFFF, 
            WashPos[i][Wash_X], WashPos[i][Wash_Y], WashPos[i][Wash_Z],3.0,
            INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,WashPos[i][World],WashPos[i][Interior]);
    }
    return true;
}

stock IsPlayerInShower(playerid)
{
    new nd = 0;
    if(GetPlayerVirtualWorld(playerid) >= 1001 && GetPlayerVirtualWorld(playerid) <= 2000) 
    {
        nd = GetPlayerVirtualWorld(playerid)-1000;
        if(IsPlayerInRangeOfPoint(playerid, 1.0, DomInfo[nd][dSouX],DomInfo[nd][dSouY],DomInfo[nd][dSouZ]) && DomInfo[nd][dInsou] >= 1)
        {
            return true;
        }
    }
    else
    {
        for(new i = 0; i < sizeof(WashPos); i++)
	    {
            if(IsPlayerInRangeOfPoint(playerid, 1.0, WashPos[i][Wash_X], WashPos[i][Wash_Y], WashPos[i][Wash_Z])
                && (WashPos[i][World] == -1 || GetPlayerVirtualWorld(playerid) == WashPos[i][World])
                && GetPlayerInterior(playerid) == WashPos[i][Interior])
            {
                return true;
            }
        }
    }
    return false;
}

CMD:wash(playerid)
{
    if(!howstun(playerid) && NoAnim[playerid] == 0 && GetPlayerSpeed(playerid) <= 2 && Sleep[playerid] == 0 && SleepRP[playerid] == 0 && Piss[playerid] == 0
	&& GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        if(IsPlayerInShower(playerid))
    	{
    	    if(!isnaked(playerid))
            {
                ErrorMessage(playerid, "{FF6347}Вашему персонажу нужно снять одежду\n\n{cccccc}Откройте инвентарь на кнопку N\nЗатем нажмите на скин вашего персонажа, чтобы снять одежду\nИли воспользуйтесь командой /undress");
                return false;
            }

    		GetPlayerPos(playerid, Job_X[playerid], Job_Y[playerid], Job_Z[playerid]);
    		Piss[playerid] = 6, PissTime[playerid] = 5, NoAnim[playerid] = 0;
	    	TogglePlayerControllable(playerid, false);
	    	ApplyAnimation(playerid,"GHANDS","gsign1LH",4.0, false, true, true, true, true);
	    	new Float:posic[3];
			GetPlayerPos(playerid, posic[0], posic[1], posic[2]);
			if(AeroStat[playerid] > 0) DestroyPlayerObject(playerid, AeroObj[playerid]);
			AeroStat[playerid] = 1;
	    	AeroObj[playerid] = CreatePlayerObject(playerid, 18740, posic[0], posic[1], posic[2], 0.0, 0.0, 0.0);
            return true;
    	}
    }
	return false;
}

//===========================================
//================ Раковина =================

enum SINKPOSENUM { Float:Sink_X, Float:Sink_Y, Float:Sink_Z, Float:Sink_A, World, Interior }
new SinkPos[][SINKPOSENUM] =
{
    { 1665.0441,-2277.4800,30.3279,0.0, -1, 0 }, // Отель LS
	{ 1761.2642,1375.9084,28.0257,311.1326, -1, 0 }, // Отель LS
    { 2683.0244,932.7282,1551.0110,270.0, -1, -1 }, // Туалет LUX М
    { 2683.0244,930.7784,1551.0110,270.0, -1, -1 }, // Туалет LUX М
    { 2686.8408,931.4393,1551.0110,90.0, -1, -1 }, // Туалет LUX Ж
    { 2686.8408,933.4106,1551.0110,90.0, -1, -1 }, // Туалет LUX Ж
	{ 1385.2109,-8.8553,1000.9258,91.5730, 239, 239 },
	{ 1385.2111,-10.3407,1000.9258,91.5730, 239, 239 },

	{ 2653.0247,932.7318,1551.0110,270.0, -1, -1 }, // Туалет LUX М
	{ 2653.0247,930.7539,1551.0110,270.0, -1, -1 }, // Туалет LUX М
	{ 2656.8408,931.4531,1551.0110,90.0, -1, -1 }, // Туалет LUX Ж
	{ 2656.8408,933.4299,1551.0110,90.0, -1, -1 }, // Туалет LUX Ж
	{ 2606.1003,930.3265,1551.0029,0.0, -1, -1 }, // Туалет LUX Ж
	{ 2604.5437,930.3266,1551.0029,0.0, -1, -1 }, // Туалет LUX Ж
	{ 2498.1526,941.5274,1551.0160,270.0, 202, -1 }, // Столовая армейки
	{ 2498.1526,940.1204,1551.0160,270.0, 202, -1 }, // Столовая армейки
	{ 2488.9622,-1702.5397,2077.5850,90.0, 212, -1 }, // Раковина Grove Street
	{ 2478.9097,-2019.8583,2052.2810,180.0, 213, -1 }, // Раковина Ballas Gang
	{ 2250.4663,-1459.8940,2089.4373,180.0, 214, -1 }, // Раковина Vagos Gang
	{ 1667.1400,-2102.6125,2091.8059,0.0, 215, -1 }, // Раковина Aztecas Gang
	{ 601.6930,-1551.4680,15.3926,90.0, 220, 0 }, // Раковина Спермобанк
	{ 598.5220,-1551.4658,15.3926,90.0, 220, 0 }, // Раковина Спермобанк
	{ 595.1710,-1551.4893,15.3926,90.0, 220, 0 }, // Раковина Спермобанк
	{ 1377.5682,1555.3853,10.8584,270.0, 231, 231 }, // Раковина NASA Жилой модуль луна
	{ 1377.5682,1555.3853,10.8584,270.0, 232, 232 }, // Раковина NASA Жилой модуль марс
	{ 1024.5862,2454.1899,10.8409,0.0, WORLD_PRISON_LAUNDY, INT_PRISON_LAUNDY }, // Prison Laundy
	{ 1026.9065,2454.1931,10.8409,0.0, WORLD_PRISON_LAUNDY, INT_PRISON_LAUNDY }, // Prison Laundy
	{ 1053.9178,2438.4783,10.8639,89.6867, WORLD_PRISON_CELLS, INT_PRISON_CELLS }, // prison тюрьма
	{ 1047.1862,2438.4766,10.8639,88.4333, WORLD_PRISON_CELLS, INT_PRISON_CELLS }, // prison тюрьма
	{ 1040.4539,2438.4790,10.8639,90.0000, WORLD_PRISON_CELLS, INT_PRISON_CELLS }, // prison тюрьма
	{ 1033.7218,2438.4976,10.8639,90.6267, WORLD_PRISON_CELLS, INT_PRISON_CELLS }, // prison тюрьма
	{ 1038.0219,2458.3367,10.8639,271.0851, WORLD_PRISON_CELLS, INT_PRISON_CELLS }, // prison тюрьма
	{ 1044.7534,2458.3435,10.8639,269.5185, WORLD_PRISON_CELLS, INT_PRISON_CELLS }, // prison тюрьма
	{ 1051.4845,2458.3535,10.8639,267.3252, WORLD_PRISON_CELLS, INT_PRISON_CELLS }, // prison тюрьма
	{ 1058.2175,2458.3391,10.8639,268.5784, WORLD_PRISON_CELLS, INT_PRISON_CELLS }, // prison тюрьма
	{ 1058.2175,2458.3391,10.8639,268.5784, WORLD_PRISON_CELLS, INT_PRISON_CELLS }, // prison тюрьма

    // Спортзал
    { 1733.1624,-1238.2762,81.5090,270.3755, WORLD_GYM, INT_GYM },
    { 1733.1624,-1236.6198,81.5090,271.9423, WORLD_GYM, INT_GYM },
    { 1730.9564,-1199.8848,81.5090,91.4839, WORLD_GYM, INT_GYM },
    { 1730.9586,-1201.5581,81.5090,91.4839, WORLD_GYM, INT_GYM }
};

stock CreateSink()
{
    for(new i = 0; i < sizeof(SinkPos); i++)
	{
        new Float:correct_position[2];
		frontpos(0.5, SinkPos[i][Sink_X], SinkPos[i][Sink_Y], SinkPos[i][Sink_A], correct_position[0], correct_position[1]);

        CreateDynamic3DTextLabel("{ff9000}Раковина\n{cccccc}[ ALT ]\n\n{cccccc}Соблюдайте гигиену и мойте руки", 0xFFFFFFFF, 
            correct_position[0], correct_position[1], SinkPos[i][Sink_Z] + 0.1, 3.0,
            INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,SinkPos[i][World],SinkPos[i][Interior]);
    }
    return true;
}

stock IsPlayerInSink(playerid, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(GetPlayerVirtualWorld(playerid) >= 1001 && GetPlayerVirtualWorld(playerid) <= 2000) 
    {
        new nd = 0;
        nd = GetPlayerVirtualWorld(playerid)-1000;
        if(IsPlayerInRangeOfPoint(playerid, 0.7, DomInfo[nd][dSinX],DomInfo[nd][dSinY],DomInfo[nd][dSinZ]) && DomInfo[nd][dInsin] >= 1)
        {
            x = DomInfo[nd][dSinX], y = DomInfo[nd][dSinY], z = DomInfo[nd][dSinZ], a = DomInfo[nd][dSinA];
            return true;
        }
    }
    else
    {
        for(new i = 0; i < sizeof(SinkPos); i++)
	    {
            if(IsPlayerInRangeOfPoint(playerid, 1.0, SinkPos[i][Sink_X], SinkPos[i][Sink_Y], SinkPos[i][Sink_Z])
                && (SinkPos[i][World] == -1 || GetPlayerVirtualWorld(playerid) == SinkPos[i][World])
                && GetPlayerInterior(playerid) == SinkPos[i][Interior])
            {
                x = SinkPos[i][Sink_X], y = SinkPos[i][Sink_Y], z = SinkPos[i][Sink_Z], a = SinkPos[i][Sink_A];
                return true;
            }
        }
    }
    return false;
}

CMD:wash_hands(playerid)
{
    if(Piss[playerid] >= 1 || CnnVed[playerid] >= 11 || Sleep[playerid] >= 1 || GetPlayerSpeed(playerid) > 3 || IsPlayerInAnyVehicle(playerid)
	|| GetPVarInt(playerid,"gantel") >= 1 
    || GetPVarInt(playerid,"sport") >= 1 
    || NoAnim[playerid] == 1 
    || howstun(playerid) 
    || Hand[playerid] >= 1 
    || Hold[playerid] >= 1) return false;

    if(IsANearbyObject(playerid) == 6)
    {
        if(PlayerInfo[playerid][pQuest][2] == 0) return ErrorMessage(playerid, "{FF6347}Неверный порядок квеста\n{ffcc66}Ваш персонаж хочет в душ");

        TogglePlayerControllable(playerid, false);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",3.5,false,false,false,false,false, SYNC_ALL);
		GetPlayerPos(playerid, Job_X[playerid], Job_Y[playerid], Job_Z[playerid]);
		Piss[playerid] = 2;
		PissTime[playerid] = 4;
		PPP15[playerid] = 6;
		NoAnim[playerid] = 0;
        return true;
    }
    return false;
}

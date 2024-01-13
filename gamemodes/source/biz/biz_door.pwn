
static Float: BizDoor[14][3] = {
{542.1713,-1293.5934,17.2775},// 78 enter car 
{1081.1078,-1698.3617,13.6268},// 79 enter car
{2200.8601,1394.2876,11.0843},// 81 enter car
{1136.4282,-913.9841,43.4865},// 82 enter moto
{426.3937,-1317.3970,15.1215},// 83 enter moto
{-1942.4755,555.3748,35.2184},// 84 enter moto
{2085.6658,2089.1599,11.1387},// 85 enter moto
{1967.2474,2456.9504,11.2225},// 86 enter moto
{1600.5526,-2237.6724,13.5820},// 87 avia
{-1462.3704,-266.1921,14.1964},// 88 avia
{1703.5695,1530.1385,10.8309},// 89 avia
{-1497.4342,757.4125,7.2423},// 90 boat
{2688.2263,-2342.4609,13.6670},// 91 boat
{2326.6267,566.7286,7.8012}// 92 boat
};

stock DynamicPickupEnterBizDoor()
{
    for(new i = 0; i < sizeof(BizDoor); i++) CreateDynamicPickup(19132, 1, BizDoor[i][0],BizDoor[i][1],BizDoor[i][2], 0, 0);

    CreateDynamicPickup(19132, 1, 1346.2372,1575.5746,10.8269, -1, 186); // Выход из Автосалона, Мотосалона
    CreateDynamicPickup(19132, 1, 1335.4403,1574.2633,10.8364, -1, 185); // Выход из Авиасалона
    CreateDynamicPickup(19132, 1, 1363.6516,1578.4187,10.8461, -1, 184); // Выход из Салона Катеров
}

stock EnterBizDoor(playerid)
{
    new yes, b;
    if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
    {
        for(new i = 0; i < sizeof(BizDoor); i++)
        {
            if(IsPlayerInRangeOfPoint(playerid,2.0,BizDoor[i][0],BizDoor[i][1],BizDoor[i][2]))
            {
                b = i + 78;
                if(i >= 2) b ++; // 80 бизнес пропускается, у него нет интерьера

                if(BizzInfo[b][bArest] > 0) return ErrorMessage(playerid, "{FF6347}Закрыто [Бизнес арестован]");

                keep(playerid); // Подмораживаем
                if(i <= 7) // Автосалоны, Мотосалоны
                {
                    S_SetPlayerVirtualWorld(playerid, b+3000, 186), SetPlayerInterior(playerid, 186);
                    PPSetPlayerPos(playerid,1346.2616,1577.9895,10.8269), SetPlayerFacingAngle(playerid, 0.0);
                }
                else if(i >= 8 && i <= 10) // Авиасалоны
                {
                    S_SetPlayerVirtualWorld(playerid, b+3000, 185), SetPlayerInterior(playerid, 185);
                    PPSetPlayerPos(playerid,1335.5031,1576.4174,10.8364), SetPlayerFacingAngle(playerid, 0.0);
                }
                else if(i >= 11 && i <= 13) // Салоны Катеров
                {
                    S_SetPlayerVirtualWorld(playerid, b+3000, 184), SetPlayerInterior(playerid, 184);
                    PPSetPlayerPos(playerid,1363.7249,1580.1615,10.8461), SetPlayerFacingAngle(playerid, 0.0);
                }
                SetCameraBehindPlayer(playerid);
                yes = true;
                break;
            }
        }
    }

    if(!yes && 
    (IsPlayerInRangeOfPoint(playerid,2.0,1346.2372,1575.5746,10.8269) && GetPlayerInterior(playerid) == 186
    || IsPlayerInRangeOfPoint(playerid,2.0,1335.4403,1574.2633,10.8364) && GetPlayerInterior(playerid) == 185
    || IsPlayerInRangeOfPoint(playerid,2.0,1363.6516,1578.4187,10.8461) && GetPlayerInterior(playerid) == 184)) // Выход из Автосалона, Мотосалона, Авиасалона, Салона катеров
	{
        b = GetPlayerVirtualWorld(playerid) - 3000;
        if(b >= 1)
        {
            S_SetPlayerVirtualWorld(playerid, 0, 0), SetPlayerInterior(playerid, 0);

			if(b == 78) PPSetPlayerPos(playerid,542.2576,-1290.8726,17.2775), SetPlayerFacingAngle(playerid, 1.6429);
            else if(b == 79) PPSetPlayerPos(playerid,1081.0867,-1701.6763,13.6268), SetPlayerFacingAngle(playerid, 184.0356);
            else if(b == 81) PPSetPlayerPos(playerid,2200.8342,1391.8214,10.8203), SetPlayerFacingAngle(playerid, 183.0626);
            else if(b == 82) PPSetPlayerPos(playerid,1139.3390,-914.0158,43.4865), SetPlayerFacingAngle(playerid, 272.4193);
            else if(b == 83) PPSetPlayerPos(playerid,427.7670,-1319.4551,15.1215), SetPlayerFacingAngle(playerid, 214.5179);
            else if(b == 84) PPSetPlayerPos(playerid,-1942.3628,558.1135,35.2184), SetPlayerFacingAngle(playerid, 1.1827);
            else if(b == 85) PPSetPlayerPos(playerid,2087.9812,2089.1755,11.0579), SetPlayerFacingAngle(playerid, 272.1625);
            else if(b == 86) PPSetPlayerPos(playerid,1970.0583,2457.1067,11.2225), SetPlayerFacingAngle(playerid, 271.8051);
            else if(b == 87) PPSetPlayerPos(playerid,1600.6296,-2239.9875,13.5820), SetPlayerFacingAngle(playerid, 180.8459);
            else if(b == 88) PPSetPlayerPos(playerid,-1463.1289,-268.9378,14.1484), SetPlayerFacingAngle(playerid, 166.1381);
            else if(b == 89) PPSetPlayerPos(playerid,1703.8481,1527.2494,10.8309), SetPlayerFacingAngle(playerid, 187.6563);
            else if(b == 90) PPSetPlayerPos(playerid,-1497.3159,754.7651,7.2423), SetPlayerFacingAngle(playerid, 177.2830);
            else if(b == 91) PPSetPlayerPos(playerid,2690.9456,-2342.3950,13.6670), SetPlayerFacingAngle(playerid, 271.7137);
            else if(b == 92) PPSetPlayerPos(playerid,2323.4531,566.6951,7.8012), SetPlayerFacingAngle(playerid, 91.2554);
            SetCameraBehindPlayer(playerid);
            yes = true;
        }
    }
    return yes;
}

stock BankDoorMoving(playerid)
{
    if(GetPVarInt(playerid,"job_stat") == 13 || PlayerInfo[playerid][pSoska] > 1)
    {
        if(DoorBankStatus[GetPlayerVirtualWorld(playerid)-3163] == 0) DoorBankStatus[GetPlayerVirtualWorld(playerid)-3163] = 1,MoveDynamicObject(DoorBank[GetPlayerVirtualWorld(playerid)-3163],1349.905395, 1558.781127, 1559.846191,1.5);
        else if(DoorBankStatus[GetPlayerVirtualWorld(playerid)-3163] == 1) DoorBankStatus[GetPlayerVirtualWorld(playerid)-3163] = 0,MoveDynamicObject(DoorBank[GetPlayerVirtualWorld(playerid)-3163],1351.405395, 1558.781127, 1559.846191,1.5);
    }
}
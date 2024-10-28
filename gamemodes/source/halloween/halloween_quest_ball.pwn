#define MAX_HALLOWEEN_BALL 88
#define MAX_HALLOWEEN_BALL_NEED 50
#define HALLOWEEN_BALL_MUSIC "https://cdn.pears.fun/sound/characters/pennywise/pennylaugh0.mp3"

new bool:TakeBallHalloween[MAX_REALPLAYERS][MAX_HALLOWEEN_BALL];
new QuanBallHalloween[MAX_REALPLAYERS];
new ObjectBallHalloween[MAX_REALPLAYERS][MAX_HALLOWEEN_BALL];

new Float:HalloweenBall[][] =
{
    { 1542.061035, -1747.918457, 14.046899 }, 
    { 1464.342895, -1905.705322, 22.355188 }, 
    { 1305.612792, -2030.480590, 58.971908 }, 
    { 1474.447021, -2287.547119, 42.420486 }, 
    { 1765.437622, -2286.931152, 26.795997 }, 
    { 1903.477294, -2232.220458, 13.608603 }, 
    { 2021.911254, -2066.565429, 17.357172 }, 
    { 2153.203857, -1919.697998, 13.546850 }, 
    { 2115.733642, -1808.872314, 22.218711 }, 
    { 2008.328735, -1778.682373, 17.352289 }, 
    { 2156.633300, -1708.373535, 15.085900 }, 
    { 2252.474365, -1698.610717, 13.758340 }, 
    { 2316.147949, -1631.785888, 14.805679 }, 
    { 2442.291503, -1759.982055, 13.590425 }, 
    { 2504.238281, -1694.845581, 13.557376 }, 
    { 2497.852294, -1893.952148, 25.550052 }, 
    { 2471.020263, -1974.920532, 13.445212 }, 
    { 2645.993896, -1957.129760, 13.546875 }, 
    { 2655.757568, -2073.135742, 26.593738 }, 
    { 2700.361572, -2143.357421, 13.548791 }, 
    { 2718.470214, -2187.527099, 13.546888 }, 
    { 2669.256103, -2349.272460, 13.666997 }, 
    { 2776.290283, -2503.881835, 13.654086 }, 
    { 2829.778320, -2361.948974, 22.798677 }, 
    { 2874.631591, -2125.179443, 4.213140 }, 
    { 2898.293945, -1879.532714, 2.741542 },
    { 2768.398681, -1601.367065, 10.921899 },
    { 2791.600830, -1466.836181, 40.062473 },
    { 2766.838623, -1382.280883, 44.651062 },
    { 2763.804443, -1298.410888, 41.249771 },
    { 2764.323730, -1224.608642, 63.368911 },
    { 2688.014404, -1144.375976, 71.367202 },
    { 2578.383544, -1025.340942, 69.573577 },
    { 2416.740722, -1212.647705, 32.734352 },
    { 2350.411132, -1215.907348, 22.500013 },
    { 2350.088623, -1325.688720, 27.813026 },
    { 2399.025878, -1560.229980, 28.000049 },
    { 2177.998291, -1513.213378, 23.909107 },
    { 2035.521240, -1307.799438, 20.902853 },
    { 1974.303710, -1235.080932, 20.046899 },
    { 2264.513671, -1093.736206, 42.648448 },
    { 2181.557373, -980.258056, 62.943241 },
    { 2013.521606, -963.734191, 42.460899 },
    { 1833.024780, -1125.384643, 24.679662 },
    { 1591.924926, -1220.126831, 270.519653 },
    { 1439.672851, -806.815734, 86.478790 },
    { 1300.568725, -992.006530, 35.280941 },
    { 1195.505737, -1111.346801, 25.044830 },
    { 1248.980224, -1229.150268, 13.679687 },
    { 1164.420166, -1200.293823, 32.027549 },
    { 1018.065307, -1245.767578, 15.179687 },
    { 945.749206, -1346.472778, 16.338460 },
    { 928.510253, -1297.306884, 13.607042 },
    { 788.546936, -1323.945068, -0.507807 },
    { 749.684692, -1369.442871, 25.692234 },
    { 724.512817, -1483.591918, 1.968737 },
    { 851.417175, -1689.801269, 14.756076 },
    { 836.182983, -2064.662353, 12.867187 },
    { 961.639709, -2161.811767, 20.568016 },
    { 1144.913818, -2352.541503, 12.475242 },
    { 1426.043823, -2456.159423, 5.097983 },
    { 1034.925415, -2086.203125, 18.212467 },
    { 1071.823608, -1495.378662, 22.750000 },
    { 1029.938964, -1432.413940, 13.546837 },
    { 1489.773803, -1721.568725, 8.153642 },
    { 1378.538085, -1621.520751, 14.046887 },
    { 1259.611328, -1505.056274, 10.053999 },
    { 1425.936645, -1291.324707, 13.556992 },
    { 1396.168334, -1458.761596, 8.664587 },
    { 2330.447265, -661.644409, 130.415313 },
    { 1265.736328, -819.119323, 77.455970 },
    { 1105.609130, -817.545104, 86.945312 },
    { 811.765686, -852.559753, 69.921852 },
    { 704.237304, -919.081665, 78.523437 },
    { 730.106445, -1043.647583, 46.673778 },
    { 815.991516, -1108.165771, 25.790611 },
    { 1853.309448, -1587.108642, 29.046861 },
    { 1969.503540, -1554.997802, 26.578111 },
    { 2070.895263, -1550.303344, 13.424094 },
    { 2386.927246, -2297.841064, 6.062502 },
    { 2540.503173, -2328.238769, 1.898437 },
    { 2314.600097, -1437.837768, 21.212211 },
    { 2287.201171, -1354.316406, 30.435689 },
    { 2662.945068, -1438.261108, 16.250000 },
    { 153.956054, -1946.488403, 5.141767 },
    { 358.976226, -2071.714355, 10.695337 },
    { 973.056457, -1964.534423, 1.564178 },
    { 1084.040893, -1603.003540, 20.486255 }
};

CMD:gotoball(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] >= 19)
    {
        if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Тп по шарикам Хеллуина /gotoball 0 - %d", MAX_HALLOWEEN_BALL - 1);
        if(params[0] < 0 || params[0] >= MAX_HALLOWEEN_BALL) return ErrorMessage(playerid, "{FF6347}Неверный ID шарика");

        S_SetPlayerVirtualWorld(playerid, 0, 0);
        PPSetPlayerInterior(playerid, 0);
        PPSetPlayerPos(playerid, HalloweenBall[params[0]][0], HalloweenBall[params[0]][1], HalloweenBall[params[0]][2] + 1.0);
    }
    else ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    return true;
}

stock CreateHalloweenBallForPlayer(playerid)
{
    for(new i = 0; i < MAX_HALLOWEEN_BALL; i++)
    {
        if(TakeBallHalloween[playerid][i] == false && ObjectBallHalloween[playerid][i] == 0)
        {
            QuanBallHalloween[playerid] ++;
            ObjectBallHalloween[playerid][i] = CreateDynamicObject(12340, HalloweenBall[i][0], HalloweenBall[i][1], HalloweenBall[i][2]-0.870024, 0.0, 0.0, 0.0, 0, 0, playerid, 50.0, 50.0);
        }
    }
    return true;
}

stock DestroyHalloweenBallForPlayer(playerid)
{
    for(new i = 0; i < MAX_HALLOWEEN_BALL; i++)
    {
        if(TakeBallHalloween[playerid][i] == false && ObjectBallHalloween[playerid][i] > 0) 
        {
            DestroyDynamicObject(ObjectBallHalloween[playerid][i]);
            ObjectBallHalloween[playerid][i] = 0;
        }
        TakeBallHalloween[playerid][i] = false;
    }
    QuanBallHalloween[playerid] = 0;
    return true;
}

function Call_OnPlayerHalloweenBallLoad(playerid, race_check)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);

        cache_get_value_name_int(0, "HalloweenUnix", PlayerInfo[playerid][pHalloweenQuestUnix]);
        cache_get_value_name_int(0, "HalloweenQuestStatus", PlayerInfo[playerid][pHalloweenQuestStatus]);
        cache_get_value_name_int(0, "BallStatus", PlayerInfo[playerid][pHalloweenBallStatus]);
        if(PlayerInfo[playerid][pHalloweenBallStatus] == 0)
        {
            new bool:is_null;
            cache_is_value_name_null(0, "Ball", is_null);
            if(is_null == false)
            {
                new string_json[512];
                cache_get_value_name(0, "Ball", string_json);

                new JsonNode:node = JSON_INVALID_NODE;
                if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
                {
                    new index = -1, JsonNode: output;
                    while(!JSON_ArrayIterate(node, index, output))
                    {
                        JSON_GetNodeInt(output, TakeBallHalloween[playerid][index]);
                    }
                }
            }
            printf("Call_OnPlayerHalloweenBallLoad(%s) шары хеллуина найдены", PlayerInfo[playerid][pName]);
        }
	}
	else // Если не нашли в таблице, тогда создаём
	{
		new string[100];
		mysql_format(pearsq, string, sizeof(string), "INSERT INTO `pp_quest_temp` SET `user_id`= '%d'", PlayerInfo[playerid][pID]);
		mysql_tquery(pearsq, string);
        printf("Call_OnPlayerHalloweenBallLoad(%s) шары для хеллуина созданы", PlayerInfo[playerid][pName]);
	}

    if(PlayerInfo[playerid][pHalloweenBallStatus] == 0) CreateHalloweenBallForPlayer(playerid);
	return true;
}

stock SaveHalloweenPlayer(playerid)
{
    new JsonNode:node = JSON_Array();

    for(new i = 0; i < MAX_HALLOWEEN_BALL; i++)
    {
        JSON_ArrayAppendEx(node, JSON_Int(TakeBallHalloween[playerid][i]));
    }

    new string_json[512];
    if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
    {
        new string_mysql[640];
        mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_quest_temp` SET `Ball`= '%e',`BallStatus` = '%d',`HalloweenQuestStatus` = '%d',`HalloweenUnix` = '%d' WHERE `user_id` = '%d'",
        string_json,PlayerInfo[playerid][pHalloweenBallStatus],PlayerInfo[playerid][pHalloweenQuestStatus],PlayerInfo[playerid][pHalloweenQuestUnix], PlayerInfo[playerid][pID]);
        mysql_tquery(pearsq, string_mysql);
    }
    return true;
}

stock TakeHalloweenBallForPlayer(playerid)
{
    if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0
        || PlayerInfo[playerid][pHalloweenBallStatus] > 0) return false;

    new bool:findBall;
    for(new i = 0; i < MAX_HALLOWEEN_BALL; i++)
    {
        if(TakeBallHalloween[playerid][i] == false
            && IsPlayerInRangeOfPoint(playerid, 2.0, HalloweenBall[i][0], HalloweenBall[i][1], HalloweenBall[i][2]))
        {
            QuanBallHalloween[playerid] --;
            TakeBallHalloween[playerid][i] = true;
            DestroyDynamicObject(ObjectBallHalloween[playerid][i]);
            ObjectBallHalloween[playerid][i] = 0;
            findBall = true;

            new getBalls = MAX_HALLOWEEN_BALL - QuanBallHalloween[playerid];

            new string[100];
            if(getBalls >= MAX_HALLOWEEN_BALL_NEED)
            {
                DestroyHalloweenBallForPlayer(playerid); 
                PlayerInfo[playerid][pHalloweenBallStatus] = 1;
            }
            else
            {
                if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, HALLOWEEN_BALL_MUSIC);

                format(string,sizeof(string),"{A52C2C}Вы нашли шарик Пеннивайза\n{ffcc66}Найдено %d шариков из %d", getBalls, MAX_HALLOWEEN_BALL_NEED);
                ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",string,"*","");

                SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Кто спрятал этот шарик тут... {A52C2C}[ Найдено %d из %d шариков Пеннивайза ]", getBalls, MAX_HALLOWEEN_BALL_NEED);
            }
            new countrewards;
            if(getBalls == 10) countrewards = 1;
            else if(getBalls == 20) countrewards = 2;
            else if(getBalls == 30) countrewards = 3;
            else if(getBalls == 40) countrewards = 4;
            else if(getBalls == 50) countrewards = 5;
            if(countrewards != 0)
            {
                SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Воу, я собрал уже их так много! {A52C2C}[ Получено кейсов %d ]", countrewards);
                for(new b; b < countrewards; b++)
                {
                    new thingId, thingQuan, thingType, thingPara, thingPack;
                    CreateCasePlayer(playerid, thingId, thingQuan, thingType, thingPara, thingPack, "halloween24");
                    GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
                }
                if(countrewards == 5)
                {
                    new thingId, thingQuan, thingType, thingPara, thingPack;
                    CreateCasePlayer(playerid, thingId, thingQuan, thingType, thingPara, thingPack, "gold");
                    GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
                }
            }
            ApplyAnimation(playerid,"CARRY","liftup",4.1, false, true, true, false, 0); // Анимация поднять предмет
            SaveHalloweenPlayer(playerid);
            break;
        }
    }
    return findBall;
}

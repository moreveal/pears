
// Позиции спавна маньяка в LS
enum MANIACPOS { Float:Maniac_X, Float:Maniac_Y, Float:Maniac_Z }
new ManiacPosLS[][MANIACPOS] =
{
    { 1587.2015,-1770.1156,13.4934 },
    { 1501.1559,-1847.8613,13.5469 },
    { 1413.0641,-1839.5214,13.5469 },
    { 1381.4573,-1898.8656,13.5046 },
    { 1339.4036,-1769.5437,13.5388 },
    { 1338.8202,-1836.6636,13.5575 },
    { 1349.6814,-1603.8280,13.5582 },
    { 1366.2417,-1490.7297,13.5469 },
    { 1389.0266,-1454.0186,13.5466 },
    { 1434.6327,-1329.3311,13.5643 },
    { 1419.4415,-1258.4795,13.5801 },
    { 1276.3990,-1257.4011,13.9740 },
    { 1256.2656,-1185.0408,23.5781 },
    { 1234.3181,-1174.1017,23.1677 },
    { 1035.5077,-1236.9022,16.1742 },
    { 1031.2581,-1376.7762,13.5918 },
    { 959.2208,-1464.2988,13.4730 },
    { 956.6776,-1509.3011,13.5493 },
    { 955.9879,-1551.4221,13.5846 },
    { 1010.4576,-1541.8190,13.5616 },
    { 1050.0566,-1665.3365,13.6076 },
    { 982.9504,-1837.4152,12.6111 },
    { 975.9910,-1702.8713,13.5364 },
    { 1594.9911,-1103.9948,24.2793 },
    { 1522.9498,-1012.8163,24.0322 },
    { 1462.3917,-1093.7728,21.6953 },
    { 1425.5862,-1120.4307,22.3558 },
    { 1427.9839,-1068.8167,21.4399 },
    { 1306.3148,-1063.2972,29.2304 },
    { 1287.8967,-1017.8356,31.1051 },
    { 1146.1466,-1005.6448,31.7377 },
    { 1098.6238,-1006.8970,34.2126 },
    { 1070.9272,-992.8764,38.8633 },
    { 1277.2598,-963.7038,37.7967 },
    { 1228.4238,-977.2368,43.4766 },
    { 1425.7690,-909.6428,37.2959 },
    { 1847.2128,-1039.8453,25.0920 },
    { 2023.8530,-1037.0809,24.9943 },
    { 2063.3706,-1057.4760,27.1561 },
    { 2052.7075,-1105.1382,24.4580 },
    { 1992.2499,-1094.1570,24.9785 },
    { 1883.8083,-1084.3506,23.8981 },
    { 1967.7705,-1293.6459,23.9844 },
    { 1964.7443,-1309.7787,23.7245 },
    { 1998.3149,-1313.6919,21.6449 },
    { 2030.9808,-1316.8734,22.1303 },
    { 2047.7404,-1273.7964,23.0661 },
    { 2087.5911,-1260.9812,23.9918 },
    { 2279.3525,-1084.6666,47.5350 },
    { 2272.1250,-1023.0165,53.0772 },
    { 2383.3379,-1020.8831,55.4516 },
    { 2428.5811,-1001.1904,55.9908 },
    { 2521.0220,-1011.1566,71.5956 },
    { 2556.8945,-1027.4916,69.5676 },
    { 2607.7405,-989.7759,81.0199 },
    { 2666.7134,-1130.7515,66.3699 },
    { 2548.8584,-1291.3822,41.1640 },
    { 2528.2781,-1357.7074,29.3282 },
    { 2557.8728,-1368.6947,32.3999 },
    { 2583.8894,-1352.3053,35.7386 },
    { 2627.4001,-1350.5659,34.8385 },
    { 2587.7898,-1411.9730,25.7623 },
    { 2545.0493,-1435.7887,24.0009 },
    { 2581.9790,-1461.1926,24.0000 },
    { 2537.7329,-1445.0126,24.0000 },
    { 2520.5117,-1484.6648,23.9985 },
    { 2465.4495,-1548.9796,24.0003 },
    { 2479.3733,-1523.1204,23.9922 },
    { 2366.1487,-1474.7188,23.8266 },
    { 2385.1196,-1458.8097,24.0046 },
    { 2371.1960,-1815.1415,13.5546 },
    { 2259.6675,-1815.5808,13.5469 },
    { 2133.1763,-1711.9326,15.0784 },
    { 2131.7507,-1655.4194,15.0859 },
    { 2176.2544,-1586.0901,14.3350 },
    { 2193.3906,-1600.3126,14.3467 },
    { 2126.5876,-1594.5442,14.3515 },
    { 2085.5313,-1552.7626,13.3225 },
    { 2041.5256,-1692.6342,13.5469 },
    { 2018.3713,-1770.4458,13.5537 },
    { 2053.9600,-1768.3768,13.5530 },
    { 1980.7798,-1784.6965,13.5537 },
    { 1857.9955,-1860.0370,13.5824 },
    { 1841.6244,-1883.8759,13.4271 },
    { 1942.8080,-1978.2644,13.5469 },
    { 1923.9281,-2033.3950,13.6016 },
    { 1850.9484,-2102.1748,13.5580 },
    { 1916.5432,-2132.4116,13.5736 },
    { 2056.5364,-2152.5034,13.6329 },
    { 2161.6797,-2146.7332,13.5469 },
    { 2726.7754,-2016.9254,13.5547 },
    { 2701.8877,-1967.5748,13.5469 },
    { 2740.8000,-1945.1788,13.5469 },
    { 372.0093,-1795.8727,5.2565 },
    { 287.2766,-1372.0110,13.9862 },
    { 348.8094,-1313.5168,14.5485 },
    { 445.9078,-1285.6835,15.2731 },
    { 478.3980,-1258.5251,16.1212 },
    { 569.9710,-1298.3408,17.2483 },
    { 613.7067,-1348.2782,13.6700 },
    { 544.2424,-1362.4469,15.5668 },
    { 463.2856,-1623.8182,26.0938 },
    { 1031.0168,-1376.5483,13.5883 },
    { 905.7684,-1236.0229,16.4415 },
    { 960.1658,-1207.4286,17.0511 },
    { 1199.0618,-872.4905,43.2543 },
    { 1295.0125,-858.4816,43.3848 },
    { 1461.8445,-651.6387,93.3170 },
    { 1293.9888,-638.3645,108.2062 },
    { 806.9531,-818.3536,71.4050 },
    { 512.0556,-1229.7198,43.6679 },
    { 118.2678,-1503.9626,11.1072 }
};

// Вход в интерьер маньяка
new Float:ManiacEnterInterior[][] =
{
	{ 1424.3281,-1093.3744,17.5633 }, // ls
	{ -1873.4989,-152.0380,11.8985 }, // sf
	{ 2488.4824,2291.1934,10.8203 } // lv
};

// Точка появления из инта маньяка
new Float:ManiacExitFromInterior[][] =
{
	{ 1426.4454,-1093.3986,17.5601,270.6890 }, // ls
	{ -1875.5769,-151.8994,11.8985,86.4704 }, // sf
	{ 2491.1992,2291.1384,10.8203,271.0488 } // lv
};

new Float:ManiacMask[][] =
{
    { 1565.673583, -1563.486572, 12.493428, -89.499992, 0.000000, 0.000000 },
    { 1611.968872, -1484.781127, 12.524797, -88.599937, 0.000000, 0.000000 },
    { 1721.799682, -1472.595458, 12.518538, -88.099952, 20.100000, 0.000000 },
    { 1743.102539, -1538.406616, 12.459055, -91.400001, 0.000000, 0.000000 },
    { 1797.118652, -1703.962524, 12.474699, -90.400070, 32.499996, 0.000000 },
    { 1613.514282, -1777.189697, 12.506120, -91.800033, 23.799997, 0.000000 },
    { 1535.573974, -1849.446899, 12.480570, -89.199958, -36.399993, 0.000000 },
    { 1282.405029, -1877.676147, 12.479522, -90.299972, 12.500000, 0.000000 },
    { 1209.875244, -1878.278808, 12.496544, -90.299964, 22.899999, 0.000000 },
    { 1091.971801, -1878.957763, 12.477288, -91.499946, 0.000000, 48.900001 },
    { 977.890502, -1828.370483, 12.270645, -88.900047, -18.799999, 0.000000 },
    { 797.509765, -1810.785400, 11.964016, -88.599967, -39.599987, 0.000000 },
    { 643.769836, -1776.224487, 10.958978, -87.500022, 0.000000, 0.000000 },
    { 567.542053, -1763.025146, 4.746421, -89.299911, -25.500000, 0.000000 },
    { 431.216400, -1748.341186, 8.075140, -89.500015, 0.000000, 0.000000 },
    { 386.936370, -1746.535278, 8.328053, -88.799987, 24.700006, 0.000000 },
    { 355.155517, -1661.364257, 31.930900, -92.399978, -29.399999, 0.000000 },
    { 251.003814, -1472.669799, 22.644662, -91.500038, 53.400001, 0.000000 },
    { 309.593719, -1336.584106, 13.383345, -91.999969, 90.899978, 5.700008 },
    { 430.521911, -1293.040649, 14.054837, -90.599937, 0.000000, 3.699999 },
    { 559.648498, -1356.945312, 14.121730, -86.400024, 91.699996, 0.000000 },
    { 732.176696, -1342.552246, 12.443695, -89.099945, 0.000000, 0.000000 },
    { 799.562866, -1336.793945, -1.552712, -91.700042, 0.000000, 0.000000 },
    { 836.960815, -1357.116821, 21.462858, -87.899948, 26.399999, 0.199999 },
    { 906.540649, -1369.243164, 24.162771, -88.800018, 0.000000, 51.899993 },
    { 915.191894, -1234.861572, 16.141330, -89.599975, 22.500001, 0.000000 },
    { 990.094177, -1249.682250, 13.982686, -86.999977, 0.000000, 0.000000 },
    { 1139.127441, -1250.293823, 24.251979, -90.099967, 69.700035, 0.000000 },
    { 1233.721435, -1262.122802, 12.260156, -82.799919, 0.000000, 0.000000 },
    { 1330.156616, -1231.342285, 12.500905, -93.099922, 26.399999, 0.000000 },
    { 1425.855712, -1315.536499, 12.503373, -89.199974, 70.199996, 0.000000 },
    { 1784.642211, -1425.905273, 15.915662, -88.299980, 0.000000, 0.000000 },
    { 1960.741577, -1542.224731, 12.578511, -91.199966, 0.000000, 0.000000 },
    { 2121.043457, -1556.800415, 12.228185, -90.799987, 0.000000, 0.000000 },
    { 2316.287841, -1438.261718, 19.911916, -89.000099, 0.000000, 0.000000 },
    { 2332.126220, -1336.401489, 22.993331, -89.499969, 0.000000, 0.000000 },
    { 2417.036376, -1293.911499, 24.078737, -91.199989, 0.000000, 23.400001 },
    { 2533.260986, -1353.717163, 37.791545, -90.199989, 40.399997, 0.000000 },
    { 2543.481201, -1212.679321, 53.632202, -91.099975, 22.399997, 0.000000 },
    { 2612.551269, -1086.351684, 68.528511, -88.299934, 0.000000, 0.000000 }
};

#define MAX_MANIAC 3
#define MAX_DIST_MANIAC_POSITION 100 // Максимальная дистанция маньяка при создании для игрока
#define MAX_DIST_ZONE_MANIAC 80 // Максимальная дистанция маньяка внутри его зоны для атаки
#define MAX_DIST_ZONE_EFFECTS_MANIAC 120 // Зона действия для эффектов с маньяком
#define MANIAC_HEALTH 5000 // Хп маньяка
#define CD_CREATE_MANIAC 600 // Кд на создание маньяка в слоте (чтобы они не повторялись)
#define MANIAC_MUSIC_0 "https://cdn.pears.fun/sound/characters/maniac/maniac.mp3" // Аудиофайл маньяка
#define CD_CREATE_MANIAC_FOR_PLAYER 7200 // Кд на повторное создание маньяка для игрока

#define MAX_MANIAC_MASK 40 // Количество масок маньяка на земле
#define MANIAC_MASK_MUSIC "https://cdn.pears.fun/sound/characters/maniac/maniac_mask.mp3" // звук когда игрок подобрал маску

enum MANIACINFO
{
	NPC:manID, // ID бота
    bool:manCreate, // Статус, создан маньяк или нет
    Float:manCreatePosition[3], // Позиция создания маньяка (где он появился)
    manAttack, // Маньяк атакует игрока
    manDestroyTimer, // Таймер перед удалением маньяка
    manObjectEffect, // Объект для эффекта удаления маньяка
    manZone, // Зона маньяка
    manCD // Кд на повторное создание маньяка в слоте
}
new ManiacInfo[MAX_MANIAC][MANIACINFO];
new AudioStream:ManiacMusic[MAX_MANIAC] = { INVALID_AUDIOSTREAM, ... };

new bool:TakeMaskManiac[MAX_REALPLAYERS][MAX_MANIAC_MASK]; // Подобрал ли игрок маску маньяка
new QuanMaskManiac[MAX_REALPLAYERS];
new ObjectMaskManiac[MAX_REALPLAYERS][MAX_MANIAC_MASK]; // Маски маньяка на земле

// Инициализация системы маньяка (его интерьер)
stock CreateManiacInterior()
{
    // Создаём входы в инт маньяка
    for(new i = 0; i < sizeof(ManiacEnterInterior); i++)
    {
        CreateDynamicPickup(19132, 1, ManiacEnterInterior[i][0], ManiacEnterInterior[i][1], ManiacEnterInterior[i][2], 0, 0); // Входы
        CreateDynamicPickup(19132, 1, -10.7197,2503.9045,16.5099, i + 1, INT_MANIAC); // Выходы
    }
    return true;
}

// Входы выходы в логово маньяка
stock DoorManiacStorage(playerid)
{
    new bool:findDoor;
    for(new i = 0; i < sizeof(ManiacEnterInterior); i++)
    {
        if(IsPlayerInRangeOfPoint(playerid,1.0,ManiacEnterInterior[i][0], ManiacEnterInterior[i][1], ManiacEnterInterior[i][2]) 
            && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
        {
            keep(playerid);
            S_SetPlayerVirtualWorld(playerid, i + 1, INT_MANIAC);
            PPSetPlayerInterior(playerid, INT_MANIAC);
            PPSetPlayerPos(playerid, -10.6607,2505.5642,16.5099);
            PPSetPlayerFacingAngle(playerid,0.9297);
            SetCameraBehindPlayer(playerid);
            findDoor = true;
            break;
        }
    }
    if(findDoor == true) return true;

    new world = GetPlayerVirtualWorld(playerid);
    if(IsPlayerInRangeOfPoint(playerid,1.0,-10.7197,2503.9045,16.5099) 
        && world >= 1 && world <= sizeof(ManiacEnterInterior) + 1
        && GetPlayerInterior(playerid) == INT_MANIAC)
	{
        keep(playerid);
        S_SetPlayerVirtualWorld(playerid, 0, 0);
        PPSetPlayerInterior(playerid, 0);
        PPSetPlayerPos(playerid, ManiacExitFromInterior[world - 1][0], ManiacExitFromInterior[world - 1][1], ManiacExitFromInterior[world - 1][2]);
        PPSetPlayerFacingAngle(playerid,ManiacExitFromInterior[world - 1][3]);
        SetCameraBehindPlayer(playerid);
        return true;
    }

    return false;
}

// Получаем свободный слот для создания маньяка
stock GetFreeSlotManiac(bool:forced = false)
{
    new slot = -1, unix = gettime();
    for(new i = 0; i < MAX_MANIAC; i++)
    {
        if(ManiacInfo[i][manCreate] == false) // Свободный слот
        {
            if(ManiacInfo[i][manCD] < unix || forced == true)
            {
                slot = i;
                break;
            }
        }
    }
    return slot;
}

// Ищем уже созданного маньяка поблизости
stock GetCreatedManiacNearby(playerid)
{
    new slot = -1;
    for(new i = 0; i < MAX_MANIAC; i++)
    {
        if(ManiacInfo[i][manCreate] == true)
        {
            if(IsNpcNearby(MAX_DIST_MANIAC_POSITION, playerid, ManiacInfo[i][manID]))
            {
                slot = i;
                break;
            }
        }
    }
    return slot;
}

// Процесс поиска позиции для создания маньяка
stock ProcessCreateManiac(playerid, bool:forced = false)
{
    if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return 0;

    // Ограничение на автоматическое создание маньяка
    if(forced == false && PlayerInfo[playerid][pManiacCD] >= gettime()) return 0;

    // Если уже создан маньяк поблизости (не создаём его больше)
    if(GetCreatedManiacNearby(playerid) >= 0) return 3;

    new resultFind;

    // Ищем свободный слот для создания маньяка
    new slotManiac = GetFreeSlotManiac(forced);
    if(slotManiac == -1) return 2;

    for(new i = 0; i < sizeof(ManiacPosLS); i++)
    {
        if(GetPlayerDistanceFromPoint(playerid, ManiacPosLS[i][Maniac_X], ManiacPosLS[i][Maniac_Y], ManiacPosLS[i][Maniac_Z]) <= 40.0)
        {
            CreateManiac(playerid, i, slotManiac);
            resultFind = 1;
            break;
        }
    }
    return resultFind;
}

// Создаём маньяка
stock CreateManiac(playerid, posID, i)
{
    if(ManiacInfo[i][manCreate] == true) return false;

    ManiacInfo[i][manID] = CreateNpc(507, ManiacPosLS[posID][Maniac_X], ManiacPosLS[posID][Maniac_Y], ManiacPosLS[posID][Maniac_Z]);
    ManiacInfo[i][manCreate] = true;
    SetNpcWeapon(ManiacInfo[i][manID], WEAPON_CHAINSAW);
    SetNpcHealth(ManiacInfo[i][manID], MANIAC_HEALTH);
    Maniac_TaskNpcAttackPlayer(ManiacInfo[i][manID], playerid, i);
    //SetNpcStunAnimationEnabled(ManiacInfo[i][manID], false); // TODO: Выключаем анимацию стана при нанесении дамага маньяку
    ManiacInfo[i][manAttack] = INVALID_PLAYER_ID;

    // Записываем позицию, где мы создали маньяка
    ManiacInfo[i][manCreatePosition][0] = ManiacPosLS[posID][Maniac_X];
    ManiacInfo[i][manCreatePosition][1] = ManiacPosLS[posID][Maniac_Y];
    ManiacInfo[i][manCreatePosition][2] = ManiacPosLS[posID][Maniac_Z];

    // Создаём зону маньяка
    ManiacInfo[i][manZone] = CreateDynamicSphere(ManiacInfo[i][manCreatePosition][0],ManiacInfo[i][manCreatePosition][1],ManiacInfo[i][manCreatePosition][2], MAX_DIST_ZONE_EFFECTS_MANIAC, 0, 0);

    // Создаём музыку для маньяка
    ManiacMusic[i] = CreateAudioStream();
    SetAudioStreamPosition(ManiacMusic[i], ManiacInfo[i][manCreatePosition][0],ManiacInfo[i][manCreatePosition][1],ManiacInfo[i][manCreatePosition][2]);
    SetAudioStreamAutostreamDist(ManiacMusic[i], 72.0); // Максимальная дистанция
    SetAudioStreamMinDistance(ManiacMusic[i], 30.0); // Минимальная дистанция (менее громкость не меняется)
    SetAudioStreamMaxDistance(ManiacMusic[i], 70.0); // Макимальная дистанция
    SetAudioStreamAutostreamState(ManiacMusic[i], true); // Врубать музло когда игрок входит в зону стрима
    SetAudioStreamSpatialState(ManiacMusic[i], true); // 3d звук
    SetAudioStreamUrl(ManiacMusic[i], MANIAC_MUSIC_0, true);

    // Обновляем зону стрима для всех игроков
    StreamerUpdateNearby(MAX_DIST_ZONE_EFFECTS_MANIAC, ManiacInfo[i][manCreatePosition][0],ManiacInfo[i][manCreatePosition][1],ManiacInfo[i][manCreatePosition][2], 0, 0);

    // Записываем время создания маньяка для игрока
    PlayerInfo[playerid][pManiacCD] = gettime() + CD_CREATE_MANIAC_FOR_PLAYER;

    if(server == 0) SendClientMessageToAll(-1, "Маньяк создан для %s", PlayerInfo[playerid][pName]);
    return true;
}

// Включаем погоду для игрока в зоне маньяка
stock Maniac_UpdateWeatherPlayer(playerid)
{
    new bool:result;
    for(new i = 0; i < MAX_MANIAC; i++)
    {
        if(ManiacInfo[i][manCreate] == true && IsPlayerInDynamicArea(playerid, ManiacInfo[i][manZone]))
        {
            SetPlayerWeather(playerid, 20);
            SetPlayerTime(playerid, 6, 0);
            result = true;
            break;
        }
    }
    return result;
}

// Запускаем процесс удаления маньяка
stock BeginDestroyManiac(i)
{
    if(ManiacInfo[i][manDestroyTimer] > 0) return false; // Процесс удаления уже запущен
    if(!IsNpcDead(ManiacInfo[i][manID])) TaskNpcStandStill(ManiacInfo[i][manID]); // Если маньяк не дохлый, останавливаем его

    // Создаём объект горения
    new Float:npc_pos[3];
    GetNpcPosition(ManiacInfo[i][manID], npc_pos[0], npc_pos[1], npc_pos[2]);
    ManiacInfo[i][manObjectEffect] = CreateDynamicObject(18723, npc_pos[0], npc_pos[1], npc_pos[2] -1.5, 0.0, 0.0, 0.0, 0, 0, -1, 80.0, 80.0);
    ManiacInfo[i][manDestroyTimer] = 2; // Удалится через 3 секунды

    // Обновляем отображение объектов в зоне стрима для игрока
    StreamerUpdateNearby(50.0, npc_pos[0], npc_pos[1], npc_pos[2], 0, 0, STREAMER_TYPE_OBJECT);
    return true;
}

// Удаляем маньяка
stock DestroyManiac(i, bool:destroyEffect = false)
{
    if(ManiacInfo[i][manCreate] == false) return false;
    
    // Удаляем npc маньяка
    if(IsValidNpc(ManiacInfo[i][manID]))
    {
        DestroyNpc(ManiacInfo[i][manID]);
        ManiacInfo[i][manCreate] = false;
    }

    // Удаляем зону маньяка
    if(ManiacInfo[i][manZone] > 0)
    {
        DestroyDynamicArea(ManiacInfo[i][manZone]);
        ManiacInfo[i][manZone] = 0;
    }

    // Удаляем объект эффекта маньяка
    if(destroyEffect == true) DestroyDynamicObject(ManiacInfo[i][manObjectEffect]);

    // Записываем кд для повторного создания маньяка
    ManiacInfo[i][manCD] = gettime() + CD_CREATE_MANIAC;

    // Удаляем музыку маньяка
    if(ManiacMusic[i] != INVALID_AUDIOSTREAM)
    {
        DeleteAudioStream(ManiacMusic[i]);
        ManiacMusic[i] = INVALID_AUDIOSTREAM;
    }
    return true;
}

CMD:createmaniac(playerid, const params[])
{
    if(admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)
        || PlayerInfo[playerid][pMedia] >= 3)
    {
        if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Создать маньяка для игрока /createmaniac ID");
        if(!IsOnline(params[0])) return ErrorMessage(playerid, "{FF6347}Этого игрока нет в сети");

        new result = ProcessCreateManiac(params[0], true);
        if(result == 1) ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Маньяк создан","*","");
        else if(result == 2) ErrorMessage(playerid, "{FF6347}Маньяк не был создан для игрока\n{ffcc66}Нет свободных слотов для создания маньяка");
        else if(result == 3) ErrorMessage(playerid, "{FF6347}Маньяк не был создан для игрока\n{ffcc66}Где-то близко с игроком уже бегает маньяк");
        else ErrorMessage(playerid, "{FF6347}Маньяк не был создан для игрока\n\n{cccccc}Возможные причины:\nИгрок далеко от точки спавна маньяка\nИгрок в интерьере или вирт мире");
    }
    else ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    return true;
}

CMD:findmaniac(playerid, const params[])
{
    if(admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)
        || PlayerInfo[playerid][pMedia] >= 3)
    {
        if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Найти маньяка /findmaniac 0 - %d", MAX_MANIAC - 1);
        if(params[0] < 0 || params[0] >= MAX_MANIAC) return ErrorMessage(playerid, "{FF6347}Неверный ID маньяка");
        if(ManiacInfo[params[0]][manCreate] == false) return ErrorMessage(playerid, "{FF6347}Маньяк в этом городе не создан");

        new Float:npc_pos[3];
        GetNpcPosition(ManiacInfo[params[0]][manID], npc_pos[0], npc_pos[1], npc_pos[2]);
        CreateGps(playerid, npc_pos[0], npc_pos[1], npc_pos[2], 0, 0, 2.0);
    }
    else ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    return true;
}

CMD:gotomaniac(playerid, const params[])
{
    if(admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)
        || PlayerInfo[playerid][pMedia] >= 3)
    {
        if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Тп к логову маньяка /gotomaniac 0 - %d", sizeof(ManiacEnterInterior));
        if(params[0] < 0 || params[0] > sizeof(ManiacEnterInterior)) return ErrorMessage(playerid, "{FF6347}Неверный ID логова");

        S_SetPlayerVirtualWorld(playerid, 0, 0);
        PPSetPlayerInterior(playerid, 0);
        PPSetPlayerPos(playerid, ManiacEnterInterior[params[0]][0], ManiacEnterInterior[params[0]][1], ManiacEnterInterior[params[0]][2]);
    }
    else ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    return true;
}


// Процесс жизни маньяка
stock LifeManiacs()
{
    for(new i = 0; i < MAX_MANIAC; i++)
    {
        if(ManiacInfo[i][manCreate] == true)
        {
            // Процесс удаления маньяка
            if(ManiacInfo[i][manDestroyTimer] > 0)
            {
                ManiacInfo[i][manDestroyTimer] --;
                if(ManiacInfo[i][manDestroyTimer] <= 0) DestroyManiac(i, true);
            }
            else
            {
                // Маньяк далеко отошел от позиции создания (Удаляем его)
                if(!IsNpcInRangeOfPoint(ManiacInfo[i][manID], MAX_DIST_ZONE_MANIAC, ManiacInfo[i][manCreatePosition][0], ManiacInfo[i][manCreatePosition][1], ManiacInfo[i][manCreatePosition][2]))
                {
                    BeginDestroyManiac(i);
                }

                // Маньяк не мертвый
                if(!IsNpcDead(ManiacInfo[i][manID]))
                {
                    AttackManiacNpcNearbyPlayer(i);
                }
            }
        }
    }
    return true;
}

stock Maniac_TaskNpcAttackPlayer(NPC:npc, playerid, i)
{
    TaskNpcAttackPlayer(npc, playerid);
    ManiacInfo[i][manAttack] = playerid;
    return true;
}

// NPC начинает атаковать ближайшего игрока
stock AttackManiacNpcNearbyPlayer(i)
{
    new latestid = FindClosestPlayerToManiacNpc(ManiacInfo[i][manID], i);

    // Нашли нового игрока, атакуем
    if(latestid != NOT_FIND_ATTACK_PLAYER 
        && latestid != INVALID_PLAYER_ID) 
    {
        Maniac_TaskNpcAttackPlayer(ManiacInfo[i][manID], latestid, i);
        if(server == 0) SendClientMessageToAll(-1, "Маньяк %d атакует игрока %d", i, latestid);
    }

    else if(latestid == INVALID_PLAYER_ID) // Не нашли игрока для атаки
    {
        BeginDestroyManiac(i);
        if(server == 0) SendClientMessageToAll(-1, "Маньяк %d не нашёл цель в своей зоне и был удалён", i);
    }
    return true;
}

// Ищем ближайшего игрока для атаки
stock FindClosestPlayerToManiacNpc(NPC:npc, i)
{
    new Float:npc_x, Float:npc_y, Float:npc_z;
    GetNpcPosition(npc, npc_x, npc_y, npc_z);

    new Float:dist = 99999.0;
    new latestId = INVALID_PLAYER_ID;
    foreach(Player, playerid) 
    {
        if(IsPlayerNotTarget(playerid)) continue;

        new Float:thisDist = GetPlayerDistanceFromPoint(playerid, npc_x, npc_y, npc_z);
        if (thisDist < dist)
        {
            dist = thisDist;
            latestId = playerid;
        }
    }

    // Если бот уже атакует этого игрока, игнорим нафиг
    if(ManiacInfo[i][manAttack] == latestId 
        && latestId != INVALID_PLAYER_ID) return NOT_FIND_ATTACK_PLAYER;

    return latestId;
}

// Убили маньяка
stock OnDeathManiacNpc(NPC:npc)
{
    new findSlot, bool:yesDeathManiac;
    for(new i = 0; i < MAX_MANIAC; i++)
    {
        if(ManiacInfo[i][manID] == npc)
        {
            yesDeathManiac = true;
            findSlot = i;
            break;
        }
    }

    if(yesDeathManiac == true)
    {
        BeginDestroyManiac(findSlot);
    }
    return yesDeathManiac;
}


//==========================================
// Маски маньяка

// Создаём для игрока маски маньяка на земле
stock CreateManiacMaskForPlayer(playerid)
{
    for(new i = 0; i < MAX_MANIAC_MASK; i++)
    {
        if(TakeMaskManiac[playerid][i] == false && ObjectMaskManiac[playerid][i] == 0)
        {
            QuanMaskManiac[playerid] ++;
            ObjectMaskManiac[playerid][i] = CreateDynamicObject(12107, ManiacMask[i][0], ManiacMask[i][1], ManiacMask[i][2], ManiacMask[i][3], ManiacMask[i][4], ManiacMask[i][5], 0, 0, playerid, 50.0, 50.0);
        }
    }
    return true;
}

// Удаляем маски маньяка для игрока (при выходе из игры)
stock DestroyManiacMaskForPlayer(playerid)
{
    for(new i = 0; i < MAX_MANIAC_MASK; i++)
    {
        if(TakeMaskManiac[playerid][i] == false && ObjectMaskManiac[playerid][i] > 0) DestroyDynamicObject(ObjectMaskManiac[playerid][i]);
        TakeMaskManiac[playerid][i] = false;
        ObjectMaskManiac[playerid][i] = 0;
    }
    QuanMaskManiac[playerid] = 0;
    return true;
}

// Игрок подбирает маску маньяка
stock TakeManiacMaskForPlayer(playerid)
{
    if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0) return false;

    new bool:findMask;
    for(new i = 0; i < MAX_MANIAC_MASK; i++)
    {
        if(TakeMaskManiac[playerid][i] == false
            && IsPlayerInRangeOfPoint(playerid, 2.0, ManiacMask[i][0], ManiacMask[i][1], ManiacMask[i][2]))
        {
            if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, MANIAC_MASK_MUSIC);

            QuanMaskManiac[playerid] --;
            TakeMaskManiac[playerid][i] = true;
            DestroyDynamicObject(ObjectMaskManiac[playerid][i]);
            ObjectMaskManiac[playerid][i] = 0;
            findMask = true;

            new string[100];
			format(string,sizeof(string),"{A52C2C}Вы нашли маску маньяка\n{ffcc66}Найдено %d масок из %d", MAX_MANIAC_MASK - QuanMaskManiac[playerid], MAX_MANIAC_MASK);
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",string,"*","");

            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Какая странная маска.. Чья она? {A52C2C}[ Найдено %d из %d масок маньяка ]", MAX_MANIAC_MASK - QuanMaskManiac[playerid], MAX_MANIAC_MASK);
            
            format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~MACKA MAH’•KA: ~w~%d / %d", MAX_MANIAC_MASK - QuanMaskManiac[playerid], MAX_MANIAC_MASK);
			GameTextForPlayer(playerid,string,4000,3);

            ApplyAnimation(playerid,"CARRY","liftup",4.1, false, true, true, false, 0); // Анимация поднять предмет
            SaveMaskManiacForPlayer(playerid);
            break;
        }
    }
    return findMask;
}

// Загружаем маски маньяка для игрока
function Call_OnPlayerMaskManiacLoad(playerid, race_check)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);

        new bool:is_null;
        cache_is_value_name_null(0, "mask", is_null);
        if(is_null == false)
        {
            new string_json[512];
            cache_get_value_name(0, "mask", string_json);

            new JsonNode:node = JSON_INVALID_NODE;
            if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
            {
                new index = -1, JsonNode: output;
                while(!JSON_ArrayIterate(node, index, output))
                {
                    JSON_GetNodeInt(output, TakeMaskManiac[playerid][index]);
                }
            }
        }
		printf("Call_OnPlayerMaskManiacLoad(%s) Маски маньяка найдены", PlayerInfo[playerid][pName]);
	}
	else // Если не нашли в таблице, тогда создаём
	{
		new string[100];
		mysql_format(pearsq, string, sizeof(string), "INSERT INTO `pp_igroki_maniac` SET `user_id`= '%d'", PlayerInfo[playerid][pID]);
		mysql_tquery(pearsq, string);
        printf("Call_OnPlayerMaskManiacLoad(%s) Маски маньяка созданы", PlayerInfo[playerid][pName]);
	}

    CreateManiacMaskForPlayer(playerid);
	return true;
}

// Сохраняем прогресс сбора масок маньяка для игрока
stock SaveMaskManiacForPlayer(playerid)
{
    new JsonNode:node = JSON_Array();

    for(new i = 0; i < MAX_MANIAC_MASK; i++)
    {
        JSON_ArrayAppendEx(node, JSON_Int(TakeMaskManiac[playerid][i]));
    }

    new string_json[512];
    if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
    {
        new string_mysql[640];
        mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_igroki_maniac` SET `mask`= '%e' WHERE `user_id` = '%d'", string_json, PlayerInfo[playerid][pID]);
        mysql_tquery(pearsq, string_mysql);
    }
    return true;
}

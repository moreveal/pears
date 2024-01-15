
#define MAX_BIZ_WITH_ACTORS 10

new BizTermActor[MAX_BIZ_WITH_ACTORS][MAX_TERMINAL_BIZ];
new BizAptekaActor[MAX_BIZ_WITH_ACTORS];
new BizSMarketActor[13][4];
new BizTehnikaActor[MAX_BIZ_WITH_ACTORS];
new BizBankActor[MAX_BIZ_WITH_ACTORS][4];
new BizClothesActor[15];

stock CreateTerminalActor(b, i)
{
    new bizActorId = GetBizTermActorId(b);

    if(BizTermActor[bizActorId][i] != INVALID_VARIABLE)
    {
        DestroyDynamicActor(BizTermActor[bizActorId][i]);
        BizTermActor[bizActorId][i] = INVALID_VARIABLE;
    }

    new br = numnrent(b);

    new Float:pos[3];
	reartobject(RentObject[br][i], 1.0, pos[0], pos[1], pos[2], RentPos_RZ[br][i]);

    BizTermActor[bizActorId][i] = CreateDynamicActor(205, pos[0], pos[1], pos[2], RentPos_RZ[br][i]-90, true, 100.0, 0, 0, -1, 200.0, -1, 0);
    return 1;
}

stock GetBizTermActorId(b)
{
    new bType = BizType(b), minB, maxB;
    bizTypeMin(bType, minB, maxB);
    new bizActorId = b - minB;

    return bizActorId;
}

stock reartobject(objectid, Float:distance, &Float:x, &Float:y, &Float:z, Float:rz)
{
	new Float:rx,Float:ry;
    GetDynamicObjectPos(objectid,x,y,z);
	GetDynamicObjectRot(objectid,rx,ry,rz);
	x=x-distance*floatsin(-rz+90,degrees);
	y=y-distance*floatcos(-rz+90,degrees);
	return 1;
}

stock reloadVariableBizTermActor()
{
    for(new b; b < MAX_BIZ_WITH_ACTORS; ++b)
    {
        for(new t; t < MAX_TERMINAL_BIZ; ++t) BizTermActor[b][t] = INVALID_VARIABLE;
    }
}

stock LoadBizStaticActor()
{
    new minB, maxB;
    bizTypeMin(2, minB, maxB);
    for(new b = minB; b < maxB  + 1; ++b)
    {
        CreateDynamicActor(179, 1284.6154,1530.0483,10.8555,183.0609, true, 100.0, b, 225, -1, 100.0, -1, 0);
    }

    CreateDynamicActor(189, -1657.3358,1208.0765,7.2500,349.4227, true, 100.0, 0, 0, -1, 100.0, -1, 0); // 77 biz
    CreateDynamicActor(189, 1350.0996,1590.2234,10.8269,179.8917, true, 100.0, 3078, 186, -1, 100.0, -1, 0); // 78 biz
    CreateDynamicActor(189, 1350.0996,1590.2234,10.8269,179.8917, true, 100.0, 3079, 186, -1, 100.0, -1, 0); // 79 biz
    CreateDynamicActor(189, -1952.1547,297.8515,35.4687,91.5685, true, 100.0, 0, 0, -1, 100.0, -1, 0); // 80 biz
    CreateDynamicActor(189, 1350.0996,1590.2234,10.8269,179.8917, true, 100.0, 3081, 186, -1, 100.0, -1, 0); // 81 biz
    CreateDynamicActor(189, 1350.0996,1590.2234,10.8269,179.8917, true, 100.0, 3082, 186, -1, 100.0, -1, 0); // 82 biz
    CreateDynamicActor(189, 1350.0996,1590.2234,10.8269,179.8917, true, 100.0, 3083, 186, -1, 100.0, -1, 0); // 83 biz
    CreateDynamicActor(189, 1350.0996,1590.2234,10.8269,179.8917, true, 100.0, 3084, 186, -1, 100.0, -1, 0); // 84 biz
    CreateDynamicActor(189, 1350.0996,1590.2234,10.8269,179.8917, true, 100.0, 3085, 186, -1, 100.0, -1, 0); // 85 biz
    CreateDynamicActor(189, 1350.0996,1590.2234,10.8269,179.8917, true, 100.0, 3086, 186, -1, 100.0, -1, 0); // 86 biz
    CreateDynamicActor(189, 1334.9167,1589.7815,10.8364,178.8344, true, 100.0, 3087, 185, -1, 100.0, -1, 0); // 87 biz avia
    CreateDynamicActor(189, 1334.9167,1589.7815,10.8364,178.8344, true, 100.0, 3088, 185, -1, 100.0, -1, 0); // 88 biz avia
    CreateDynamicActor(189, 1334.9167,1589.7815,10.8364,178.8344, true, 100.0, 3089, 185, -1, 100.0, -1, 0); // 89 biz avia
    CreateDynamicActor(189, 1355.3701,1584.2448,10.8461,274.7623, true, 100.0, 3090, 184, -1, 100.0, -1, 0); // 90 biz boat
    CreateDynamicActor(189, 1355.3701,1584.2448,10.8461,274.7623, true, 100.0, 3091, 184, -1, 100.0, -1, 0); // 91 biz boat
    CreateDynamicActor(189, 1355.3701,1584.2448,10.8461,274.7623, true, 100.0, 3092, 184, -1, 100.0, -1, 0); // 92 biz boat


    //Supermarket;
    for(new b = 0; b < 13; ++b)
    {
        BizSMarketActor[b][0] = CreateDynamicActor(189, 1111.9116,-1380.5073,1401.7142,92.4125, true, 100.0, b+1, 206, -1, 100.0, -1, 0);
        BizSMarketActor[b][1] = CreateDynamicActor(189, 1107.3895,-1380.6812,1401.7142,270.3970, true, 100.0, b+1, 206, -1, 100.0, -1, 0);
        BizSMarketActor[b][2] = CreateDynamicActor(189, 1106.3508,-1380.6312,1401.7142,90.4179, true, 100.0, b+1, 206, -1, 100.0, -1, 0);
        BizSMarketActor[b][3] = CreateDynamicActor(189, 1101.8390,-1380.6248,1401.7142,270.2352, true, 100.0, b+1, 206, -1, 100.0, -1, 0);
    }

    // Apteka
    for(new b = 0; b < 10; ++b)
    {
        BizAptekaActor[b] = CreateDynamicActor(276, 1284.4778,1530.0472,10.8555,178.5849, true, 100.0, b+123, 224, -1, 100.0, -1, 0);
    }

    // Apteka
    for(new b = 0; b < 10; ++b)
    {
        BizTehnikaActor[b] = CreateDynamicActor(240, 1997.6824,1565.4247,1564.1647,90.0208, true, 100.0, b, 207, -1, 100.0, -1, 0);
    }

    for(new b = 0; b < 10; ++b)
    {
        BizBankActor[b][0] = CreateDynamicActor(11, 1355.7312,1568.8884,1560.8462,90.0000, true, 100.0, b+3163, 188, -1, 100.0, -1, 0);
        BizBankActor[b][1] = CreateDynamicActor(59, 1356.0292,1566.7098,1561.3649,90.0000, true, 100.0, b+3163, 188, -1, 100.0, -1, 0);
        BizBankActor[b][2] = CreateDynamicActor(11, 1355.7627,1564.5460,1560.8721,90.0000, true, 100.0, b+3163, 188, -1, 100.0, -1, 0);
        BizBankActor[b][3] = CreateDynamicActor(59, 1355.9939,1562.4127,1561.3649,90.0000, true, 100.0, b+3163, 188, -1, 100.0, -1, 0);
        for(new i; i < 4; i++)
        {
            ApplyDynamicActorAnimation(BizBankActor[b][i], "PED","SEAT_idle", 4.0, 0,0,0,1,0);
        }
    }

    BizClothesActor[0] = CreateDynamicActor(93,208.8246,-98.7054,1005.2578,177.9428, true, 100.0, 182, 15, -1, 100.0, -1, 0);
    BizClothesActor[1] = CreateDynamicActor(93,206.3100,-98.7052,1005.2578,178.7574, true, 100.0, 182, 15, -1, 100.0, -1, 0);
    BizClothesActor[2] = CreateDynamicActor(93,159.7952,-81.1915,1001.8047,180.4281, true, 100.0, 180, 18, -1, 100.0, -1, 0);
    BizClothesActor[3] = CreateDynamicActor(93,162.8142,-81.1918,1001.8047,180.4281, true, 100.0, 180, 18, -1, 100.0, -1, 0);
    BizClothesActor[4] = CreateDynamicActor(93,203.2695,-41.6711,1001.8047,177.9427, true, 100.0, 181, 1, -1, 100.0, -1, 0);
    BizClothesActor[5] = CreateDynamicActor(93,207.0535,-127.8052,1003.5078,179.5719, true, 100.0, 179, 3, -1, 100.0, -1, 0);
    BizClothesActor[6] = CreateDynamicActor(93,204.4043,-157.8300,1000.5234,180.2245, true, 100.0, 178, 14, -1, 100.0, -1, 0);
    BizClothesActor[7] = CreateDynamicActor(93,204.8537,-8.2923,1001.2109,268.7989, true, 100.0, 177, 5, -1, 100.0, -1, 0);
    BizClothesActor[8] = CreateDynamicActor(93,204.8514,-8.2400,1001.2109,272.4646, true, 100.0, 176, 5, -1, 100.0, -1, 0);
    BizClothesActor[9] = CreateDynamicActor(93,159.7009,-81.1918,1001.8120,178.7574, true, 100.0, 175, 18, -1, 100.0, -1, 0);
    BizClothesActor[10] = CreateDynamicActor(93,162.8424,-81.1918,1001.8047,177.7392, true, 100.0, 175, 18, -1, 100.0, -1, 0);
    BizClothesActor[11] = CreateDynamicActor(93,206.2991,-98.7047,1005.2578,182.4229, true, 100.0, 174, 15, -1, 100.0, -1, 0);
    BizClothesActor[12] = CreateDynamicActor(93,208.7682,-98.7050,1005.2578,182.0156, true, 100.0, 174, 15, -1, 100.0, -1, 0);
    BizClothesActor[13] = CreateDynamicActor(93,206.4495,-98.7045,1005.2578,178.3500, true, 100.0, 173, 15, -1, 100.0, -1, 0);
    BizClothesActor[14] = CreateDynamicActor(93,208.7266,-98.7051,1005.2578,178.3500, true, 100.0, 173, 15, -1, 100.0, -1, 0);
}
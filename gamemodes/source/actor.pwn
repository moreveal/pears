#define MAX_BOTS 600  // пїЅпїЅпїЅ-пїЅпїЅ пїЅпїЅпїЅпїЅ. npc пїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ

new BotPears[MAX_BOTS];
new PlayerText3D:BotTalk[MAX_REALPLAYERS]; // ID Label Text NPC
new BotTalkStat[MAX_REALPLAYERS];
new BotTalkTimer[MAX_REALPLAYERS]; // ID Timer Text NPC
new CompGameActor[MAX_REALPLAYERS]; // Актер у ноута
new Text3D: CompGameText[MAX_REALPLAYERS]; // текст у ноута

static const talk_anims_actor[][] = {
"prtial_gngtlkA", "prtial_gngtlkB", "prtial_gngtlkC", "prtial_gngtlkD",
"prtial_gngtlkE", "prtial_gngtlkF", "prtial_gngtlkG", "prtial_gngtlkH"
};

function SendActorMessage(playerid, stat,actorid,const text[])
{
	if(IsValidActor(actorid))
	{
		new Float:pos[3];
		GetActorPos(actorid, pos[0], pos[1], pos[2]);
		SetActorPos(actorid, pos[0], pos[1], pos[2]);

        if(BotTalkStat[playerid] > 0) DeletePlayer3DTextLabel(playerid, BotTalk[playerid]);
        if(BotTalkTimer[playerid]) KillTimer(BotTalkTimer[playerid]);

        BotTalkStat[playerid] = actorid;
        BotTalk[playerid] = CreatePlayer3DTextLabel(playerid, text, 0x67b2ffFF, pos[0], pos[1], pos[2] + 1.2, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
        BotTalkTimer[playerid] = SetTimerEx("ClearTextActor", 5000, false, "dd", playerid, actorid);

        if(stat == 1) ApplyActorAnimation(actorid, "GANGS", talk_anims_actor[random(sizeof(talk_anims_actor))], 4.0, 0, 1, 1, 1, 1);
	}
	return 1;
}

function ClearTextActor(playerid, actorid)
{
    if(BotTalkStat[playerid] > 0) DeletePlayer3DTextLabel(playerid, BotTalk[playerid]), BotTalkStat[playerid] = 0;
    if(BotTalkTimer[playerid]) KillTimer(BotTalkTimer[playerid]), BotTalkTimer[playerid] = 0;
    LoadAnimBot(actorid);
    return 1;
}

function SendDynamicActorMessage(actorid, playerid, const text[]) // Обычный текст над головой NPC
{
	if(IsValidDynamicActor(actorid)) MessageDynamicActor(actorid, 0, playerid, text);
	return 1;
}
function SendDynamicActorScript(actorid, playerid, const text[]) // Текст для сценария
{
	if(IsValidDynamicActor(actorid)) MessageDynamicActor(actorid, 1, playerid, text);
	return 1;
}

stock CreateActorComp(playerid)
{
    if(CompGameActor[playerid] == 1) return 0;
    new string[70];
    format(string,sizeof(string),"{ff9000}%s[%d]\n{0088ff}Играет в игру",rpplayername(playerid),playerid);
    new Float:f_pos[4];
    backme(playerid, 0.6, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
    CompGameText[playerid] = CreateDynamic3DTextLabel(string,0xA9C4E4FF,f_pos[0],f_pos[1],f_pos[2]+0.6,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,SpWorld[playerid],SpInt[playerid]);
    CompGameActor[playerid] = CreateDynamicActor(GetSkinModelOriginal(PlayerInfo[playerid][pModel]), SpX[playerid],SpY[playerid],SpZ[playerid],SpA[playerid], true, 100.0, SpWorld[playerid], SpInt[playerid], -1, 100.0, -1, 0);
    ApplyDynamicActorAnimation(CompGameActor[playerid], "PED","SEAT_idle", 4.0, 0,0,0,1,0);
    return 1;
}

stock DeleteActorComp(playerid)
{
    if(CompGameActor[playerid] == 0) return 0;
    DestroyDynamic3DTextLabel(CompGameText[playerid]);
    DestroyDynamicActor(CompGameActor[playerid]);
    CompGameActor[playerid] = 0;
    return 1;
}


stock MessageDynamicActor(actorid, status, playerid, const text[])
{
    new Float:pos[3];
    GetDynamicActorPos(actorid, pos[0], pos[1], pos[2]);

    if(BotTalkStat[playerid] > 0) DeletePlayer3DTextLabel(playerid, BotTalk[playerid]);
    if(BotTalkTimer[playerid]) KillTimer(BotTalkTimer[playerid]), BotTalkTimer[playerid] = 0;

    BotTalkStat[playerid] = actorid;
    BotTalk[playerid] = CreatePlayer3DTextLabel(playerid, text, 0x67b2ffFF, pos[0], pos[1], pos[2] + 1.1, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    if(status == 0) BotTalkTimer[playerid] = SetTimerEx("ClearDynamicTextActor", 4500, false, "dd", playerid, actorid);

    ApplyDynamicActorAnimation(actorid, "GANGS", talk_anims_actor[random(sizeof(talk_anims_actor))], 4.0, 0, 1, 1, 0, 0);
}

function ClearDynamicTextActor(playerid, actorid) // Удаляем текст над бошкой NPC
{
    if(BotTalkStat[playerid] > 0) DeletePlayer3DTextLabel(playerid, BotTalk[playerid]), BotTalkStat[playerid] = 0;
    if(BotTalkTimer[playerid]) KillTimer(BotTalkTimer[playerid]), BotTalkTimer[playerid] = 0;

    if(IsValidDynamicActor(actorid)) ClearDynamicActorAnimations(actorid);
    return 1;
}

stock LoadDynamicActor()
{
    CreateDynamicActor(163, -2777.3750,381.2728,6.164,182.8925, true, 100.0, 189, 0, -1, 100.0, -1, 0); // Goverment Hall (Security 1)
    CreateDynamicActor(164, -2801.6621,378.6697,6.164,181.7841, true, 100.0, 189, 0, -1, 100.0, -1, 0); // Goverment Hall (Security 2)
    CreateDynamicActor(150, -2793.0801,376.0515,6.164,270.1448, true, 100.0, 189, 0, -1, 100.0, -1, 0); // Goverment Hall (Reseption Girl)
    return 1;
}

stock LoadBot()
{
	BotPears[1] = CreateActor(27, 2271.6897,2785.0352,10.8203,26.2866);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
	BotPears[2] = CreateActor(133, 1617.7690,-1895.4532,13.8599,266.8432); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ LS
	BotPears[3] = CreateActor(133, -1872.4868,-218.2040,18.6155,272.1465); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ SF
	BotPears[4] = CreateActor(133, 1034.6359,2215.3616,11.0254,359.8574); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ LV
	BotPears[5] = CreateActor(133, 992.0648,-1342.0739,13.6369,183.5969); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ LS
	BotPears[6] = CreateActor(151, 1477.2902,-1782.6528,15.3182,0.3031); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[6], 197);
	BotPears[7] = CreateActor(147, 1509.1925,-1782.7321,21.0902,1.0359); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ 2 пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[7], 196);
	BotPears[8] = CreateActor(10, 1474.8569,-1806.1353,21.0982,359.8061); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ 2 пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[8], 196);
	BotPears[9] = CreateActor(158, -56.7789,89.7783,3.1172,234.6577); // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
	BotPears[10] = CreateActor(162, -43.4430,51.2411,3.1179,252.8287); // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ (пїЅпїЅпїЅпїЅпїЅпїЅ)
	BotPears[11] = CreateActor(141, 2166.4031,2371.6714,23.6143,226.8451); // FBI Bot 1
	SetActorVirtualWorld(BotPears[11], 243);

	//gotobiz 8
	BotPears[12] = CreateActor(42, 1535.7311,-2181.1694,13.7505,266.9203); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[13] = CreateActor(50, 1527.0488,-2181.1238,13.7505,92.0532); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[14] = CreateActor(151, 1533.0773,-2173.0298,13.5853,268.5912); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	//gotobiz 9
	BotPears[15] = CreateActor(42, 893.1202,1903.3278,11.0516,337.5979); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[16] = CreateActor(50, 892.9305,1894.7195,11.0516,191.5832); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[17] = CreateActor(151, 884.5753,1900.7799,10.8864,359.6999); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	//gotobiz 10
	BotPears[18] = CreateActor(42, -2630.7766,1359.5754,7.2240,332.5845); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[19] = CreateActor(50, -2630.6655,1351.4535,7.2240,216.6501); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[20] = CreateActor(151, -2639.1790,1357.3517,7.1398,359.6998); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	//gotobiz 11
	BotPears[21] = CreateActor(42, -1558.8522,-2745.5351,48.7373,233.7474); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[56] = CreateActor(50, -1565.6212,-2740.8579,48.7373,59.4913); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[57] = CreateActor(151, -1555.9618,-2737.3997,48.5721,235.5593); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot

	BotPears[22] = CreateActor(123, 1460.6874,660.9774,10.8203,185.5546); // Yakuza Mafia Bot 1
	BotPears[23] = CreateActor(118, 1509.5968,755.5034,11.0234,175.3727); // Yakuza Mafia Bot 2
	BotPears[24] = CreateActor(117, 1514.0986,755.4178,11.0234,184.6377); // Yakuza Mafia Bot 3
	BotPears[25] = CreateActor(122, 1520.8297,755.5728,11.0234,178.6217); // Yakuza Mafia Bot 4
	BotPears[26] = CreateActor(186, 1520.5500,750.6175,11.0234,176.3129); // Yakuza Mafia Bot 5
	BotPears[27] = CreateActor(208, 1513.8164,750.4470,11.0234,181.0129); // Yakuza Mafia Bot 6
	BotPears[28] = CreateActor(120, 1506.3950,750.5110,11.0234,179.6969); // Yakuza Mafia Bot 7
	BotPears[29] = CreateActor(49, 1515.8894,738.4565,11.0234,358.9152); // Yakuza Mafia Bot 8
	BotPears[30] = CreateActor(6, 1380.1854,-5.4021,1000.9713,257.5052); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ Bot 1 [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]
	SetActorVirtualWorld(BotPears[30], 219);
	BotPears[31] = CreateActor(95, 995.3415,-1954.1554,12.8842,182.6652); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ Bot 2 [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ ]
	BotPears[32] = CreateActor(150, 1276.9844,-46.5174,1000.9280,358.1093); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1 [ пїЅпїЅпїЅпїЅпїЅ ]
	SetActorVirtualWorld(BotPears[32], 3);
	BotPears[34] = CreateActor(96, 1613.8485,-2278.8977,13.5732,347.3431); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 3
	BotPears[35] = CreateActor(97, 1614.2062,-2277.4736,13.5656,162.1847); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 4
    BotPears[36] = CreateActor(3, 1625.8187,-2295.5776,13.5372,128.6577); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 5 [ пїЅпїЅпїЅпїЅпїЅ ]
	BotPears[37] = CreateActor(199, 1733.8733,-1901.9637,916.0651,281.3157); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot 6
	SetActorVirtualWorld(BotPears[37], 7);
	BotPears[38] = CreateActor(188, 1743.0204,-1899.2825,916.0651,289.1492); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot 7
	SetActorVirtualWorld(BotPears[38], 7);
	BotPears[39] = CreateActor(185, 1744.4777,-1898.8420,916.0651,101.7975); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot 8
	SetActorVirtualWorld(BotPears[39], 7);
	BotPears[40] = CreateActor(71, 1743.6726,-1895.4208,913.6010,357.6015); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot 9
	SetActorVirtualWorld(BotPears[40], 7);
	BotPears[45] = CreateActor(151, 607.0654,-1538.5491,15.3926,268.8089); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1 [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]
	SetActorVirtualWorld(BotPears[45], 220);
	BotPears[46] = CreateActor(159, -22.4602,66.8220,3.1172,184.2081); // Френк на ферме
    BotPears[47] = CreateActor(262,-338.6107,1729.5956,42.8917,4.2150); // Брюс археология
    BotPears[48] = CreateActor(133, -2059.5835,-87.3367,35.4489,1.8462); // Автобусное депо SF
	BotPears[49] = CreateActor(308, 1391.5339,-13.7709,1000.9217,1.1784); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 2
	SetActorVirtualWorld(BotPears[49], 5);
	BotPears[50] = CreateActor(16, 1385.5522,-18.7329,1000.9110,178.9046); // IKEA Bot (Pavilion 2)
    SetActorVirtualWorld(BotPears[50], 193);
	BotPears[51] = CreateActor(308, 1163.3939,-1315.3433,898.0944,90.6377); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 4
	SetActorVirtualWorld(BotPears[51], 1);
	BotPears[52] = CreateActor(250, 1161.7295,-1315.5109,898.0944,274.2293); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 5
	SetActorVirtualWorld(BotPears[52], 1);
	BotPears[53] = CreateActor(259, 1150.3359,-1297.2848,898.7470,180.6266); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 6
	SetActorVirtualWorld(BotPears[53], 1);
	BotPears[54] = CreateActor(229, 1153.5736,-1302.8451,898.7470,275.0858); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 7
	SetActorVirtualWorld(BotPears[54], 1);
	BotPears[55] = CreateActor(170, 1385.4244,-17.7351,1000.9110,355.9396); // IKEA Bot (Pavilion 2)
    SetActorVirtualWorld(BotPears[55], 193);

	BotPears[58] = CreateActor(111, -1978.7440,1125.3831,52.5381,237.8730); // Russian Mafia Bot 1
	BotPears[59] = CreateActor(125, -2002.7351,1131.1342,53.2815,188.2334); // Russian Mafia Bot 2
	BotPears[60] = CreateActor(126, -2010.2117,1110.2968,53.2891,197.0067); // Russian Mafia Bot 3
	BotPears[61] = CreateActor(112, -2009.2338,1108.3409,53.2891,35.0118); // Russian Mafia Bot 4
	BotPears[62] = CreateActor(192, -2002.4238,1104.6166,53.2891,354.5681); // Russian Mafia Bot 5
	//gotobiz 12
	BotPears[69] = CreateActor(42, 64.2792,-190.6612,1.8092,268.1631); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[70] = CreateActor(50, 55.8918,-190.3604,1.8092,89.1813); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[71] = CreateActor(151, 61.9165,-182.6632,1.6440,269.1813); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[72] = CreateActor(16, 1385.5709,-12.5325,1000.9110,177.0246); // IKEA Bot (Pavilion 2)
    SetActorVirtualWorld(BotPears[72], 193);
    BotPears[73] = CreateActor(6, 1385.5596,-14.3427,1000.9110,183.9181); // IKEA Bot (Pavilion 3)
    SetActorVirtualWorld(BotPears[73], 192);
    BotPears[74] = CreateActor(6, 1385.5792,-13.3454,1000.9110,0.9531); // IKEA Bot (Pavilion 3)
    SetActorVirtualWorld(BotPears[74], 192);
    BotPears[75] = CreateActor(133, 1063.9913,2306.4170,11.0953,270.3401); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ LV

	BotPears[77] = CreateActor(96, 1758.0946,1420.9188,10.8965,105.2076); // aero lv talk 1
	BotPears[78] = CreateActor(97, 1756.4376,1420.4808,10.8965,280.8209); // aero lv talk 2
	BotPears[80] = CreateActor(3, 1736.7946,1408.7692,10.8467,43.5901); // aero lv money

	BotPears[81] = CreateActor(150, 1276.9844,-46.5174,1000.9280,358.1093); // hotel lv girl reception 1
	SetActorVirtualWorld(BotPears[81], 6);
	BotPears[82] = CreateActor(141,1274.4423,-46.8282,1000.9280,20.3795); // hotel lv girl reception 2
	SetActorVirtualWorld(BotPears[82], 6);
	BotPears[83] = CreateActor(43,1273.9204,-45.3367,1000.9280,204.5977); // hotel lv people 1
	SetActorVirtualWorld(BotPears[83], 6);
	BotPears[84] = CreateActor(164,1265.6527,-49.2240,1000.9280,1.3875); // hotel lv security right
	SetActorVirtualWorld(BotPears[84], 6);
	BotPears[85] = CreateActor(164,1288.0977,-49.1689,1000.9280,7.3408); // hotel lv security left
	SetActorVirtualWorld(BotPears[85], 6);
	BotPears[86] = CreateActor(189,1280.3707,-47.6048,1000.9280,314.8688); // hotel lv boy reception
	SetActorVirtualWorld(BotPears[86], 6);
	BotPears[87] = CreateActor(163,1280.0337,-37.1167,1000.9280,181.2190); // hotel lv security entrance
	SetActorVirtualWorld(BotPears[87], 6);
	BotPears[88] = CreateActor(59,1283.0580,-42.2432,1000.9280,15.6561); // hotel lv boy talk 1
	SetActorVirtualWorld(BotPears[88], 6);
	BotPears[89] = CreateActor(98,1282.6345,-40.7867,1000.9280,194.8844); // hotel lv boy talk 2
	SetActorVirtualWorld(BotPears[89], 6);

    BotPears[95] = CreateActor(155, 1593.5620,1445.5161,10.8726,91.1705); // aero lv
	SetActorVirtualWorld(BotPears[95], 183);
	BotPears[96] = CreateActor(71, 1570.0636,1425.1440,10.8726,0.6398); // aero lv
	SetActorVirtualWorld(BotPears[96], 183);
	BotPears[97] = CreateActor(71, 1591.9197,1435.1173,10.8726,181.1216); // aero lv
	SetActorVirtualWorld(BotPears[97], 183);
	BotPears[98] = CreateActor(150, 1582.9110,1421.4177,10.8726,0.6164); // aero lv
	SetActorVirtualWorld(BotPears[98], 183);
	BotPears[99] = CreateActor(150, 1578.4772,1421.4210,10.8726,359.9897); // aero lv
	SetActorVirtualWorld(BotPears[99], 183);
	BotPears[107] = CreateActor(150, 1574.1418,1421.4066,10.8726,359.0497); // aero lv
	SetActorVirtualWorld(BotPears[107], 183);

	BotPears[100] = CreateActor(68, 1327.8085,1585.8474,11.0259,271.6756); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1 [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]
	SetActorVirtualWorld(BotPears[100], 195);
    SetActorVirtualWorld(BotPears[102], 1);
	BotPears[103] = CreateActor(161, -1631.7679,-2234.6997,31.4766,160.4179); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	BotPears[105] = CreateActor(40, 1776.7781,-1875.1967,13.5607,87.0187); // Sex Bot 1
	BotPears[106] = CreateActor(37, 1775.8397,-1875.1381,13.5608,268.5027); // Sex Bot 2
	BotPears[110] = CreateActor(276, 1154.4517,-1302.5990,898.1036,106.8008); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 8
	SetActorVirtualWorld(BotPears[110], 1);
	BotPears[111] = CreateActor(15, 1171.6820,-1297.7162,898.7470,92.0739); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 8
	SetActorVirtualWorld(BotPears[111], 1);
	BotPears[112] = CreateActor(32, 1168.5963,-1303.1786,898.7470,2.3148); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 10
	SetActorVirtualWorld(BotPears[112], 1);
	BotPears[113] = CreateActor(34, 1150.8004,-1305.3921,898.7470,92.7241); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 11
	SetActorVirtualWorld(BotPears[113], 1);
	BotPears[114] = CreateActor(44, 1147.5684,-1311.3845,898.7470,0.7715); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 12
	SetActorVirtualWorld(BotPears[114], 1);
	BotPears[115] = CreateActor(54, 1168.3097,-1310.6511,898.7470,275.4225); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 13
	SetActorVirtualWorld(BotPears[115], 1);
	BotPears[116] = CreateActor(58, 1150.9082,-1328.6205,898.0944,186.1451); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 14
	SetActorVirtualWorld(BotPears[116], 1);
	BotPears[117] = CreateActor(275, 1150.9603,-1329.8462,898.0944,9.4234); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 15
	SetActorVirtualWorld(BotPears[117], 1);
	BotPears[118] = CreateActor(71, 1162.4762,-1328.9657,898.0944,4.3867); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 16
	SetActorVirtualWorld(BotPears[118], 1);
	BotPears[119] = CreateActor(275, 1138.6152,-1349.8079,898.0916,181.7350); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 17
	SetActorVirtualWorld(BotPears[119], 1);
	BotPears[120] = CreateActor(276, 1138.5537,-1351.0946,898.0916,357.1800); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 18
	SetActorVirtualWorld(BotPears[120], 1);
	BotPears[121] = CreateActor(252, 1156.0387,-1382.1033,898.8210,96.7777); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 19
	SetActorVirtualWorld(BotPears[121], 1);
	BotPears[122] = CreateActor(70, 1118.0420,-1362.3555,898.0916,274.5060); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 20
	SetActorVirtualWorld(BotPears[122], 1);

	// LSPD пїЅпїЅпїЅпїЅ
	//148
	BotPears[149] = CreateActor(280, 1580.1194,-1634.3180,13.5624,2.8671); // LSPD Bot 2
	//150
	BotPears[151] = CreateActor(281, 1545.1991,-1669.5962,13.5599,20.7507); // LSPD Bot 4
	BotPears[152] = CreateActor(259, 1544.4688,-1668.0896,13.5585,205.2824); // LSPD Bot 5
	BotPears[153] = CreateActor(282, 1545.0980,-1683.7576,13.5563,0.9871); // LSPD Bot 6
	BotPears[154] = CreateActor(284, 1549.5330,-1680.2131,13.5564,193.9789); // LSPD Bot 7
	BotPears[155] = CreateActor(280, 1550.4847,-1682.5118,13.5545,18.5106); // LSPD Bot 8
	// пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[156] = CreateActor(300, 1556.1638,-1660.8695,16.2218,136.1330); // LSPD Bot 9 ((154))
	SetActorVirtualWorld(BotPears[156], 255);
	BotPears[157] = CreateActor(301, 1554.9736,-1661.7855,16.2218,309.0712); // LSPD Bot 10 ((144))
	SetActorVirtualWorld(BotPears[157], 255);

	SetActorVirtualWorld(BotPears[196], 1);
	BotPears[197] = CreateActor(141, 1384.8610,1588.3568,10.8484,184.8581); // NASA Bot 1
	SetActorVirtualWorld(BotPears[197], 230);
	BotPears[204] = CreateActor(36, -337.9493,1725.6622,42.8531,270.0621); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	// fill bots 50 справа, 42 слева, 151 kassa
	//gotobiz 1
	BotPears[207] = CreateActor(42, 1934.9749,-1779.5398,13.7258,327.5147);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[208] = CreateActor(50, 1934.4780,-1787.4510,13.7258,192.4313);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot ls2
	BotPears[209] = CreateActor(151, 1926.0579,-1781.8629,13.5606,358.2216);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 3
	//gotobiz 3
	BotPears[219] = CreateActor(42, -1675.1141,421.4946,7.3641,297.0783);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 4
	BotPears[220] = CreateActor(50, -1680.8055,415.6465,7.3641,158.2703);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 5
	BotPears[221] = CreateActor(151, -1682.5594,425.5037,7.1989,316.5287);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 6

	BotPears[226] = CreateActor(37, -2230.7534,251.7373,894.7211,4.7700); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ Bot 1 Ледовый
	SetActorVirtualWorld(BotPears[226], 77);
	//gotobiz 4
	BotPears[227] = CreateActor(42, -2105.4768,-0.9047,35.5099,339.2878);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 7 sf-2
	BotPears[228] = CreateActor(50, -2105.5925,-8.6365,35.5099,199.8531);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 8 sf-2
	BotPears[229] = CreateActor(151, -2113.7688,-3.1075,35.3447,358.4013);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 9 sf-2
	//gotobiz 2
	BotPears[230] = CreateActor(42, -86.4611,-1176.7148,2.8050,150.6032);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 10 ls-2
	BotPears[231] = CreateActor(50, -82.1471,-1170.0570,2.8050,335.3078);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 11 ls-2
	BotPears[232] = CreateActor(151, -77.7439,-1178.6635,2.6398,153.0467);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 12 ls-2
	//gotobiz 5
	BotPears[233] = CreateActor(42, 2113.4683,941.9081,11.0156,2.3508);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 13 lv-1
	BotPears[234] = CreateActor(50, 2113.3262,933.7612,11.0156,178.7060);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 14 lv-1
	BotPears[235] = CreateActor(151, 2105.3967,939.7891,10.8504,0.1524);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 15 lv-1
	//gotobiz 6
	BotPears[236] = CreateActor(42, 2250.1785,2391.5908,11.0000,56.4122);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 16 lv-2
	BotPears[237] = CreateActor(50, 2258.2874,2391.3408,11.0000,284.2471);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 17 lv-2
	BotPears[238] = CreateActor(151, 2252.6345,2383.2349,10.8348,90.0646);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 18 lv-2
	//gotobiz 7
    BotPears[490] = CreateActor(42, 2811.1558,1993.9091,11.0080,314.1533);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ LV-3 Bot 1
	BotPears[491] = CreateActor(50, 2805.9856,1986.8063,11.0080,135.4203);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ LV-3 Bot 2
	BotPears[492] = CreateActor(151, 2804.1641,1997.2927,10.8429,314.0154);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ LV-3 Bot 3
	BotPears[240] = CreateActor(155, 1717.9539,-2410.4026,13.5767,180.5654); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	SetActorVirtualWorld(BotPears[240], 198);
	BotPears[241] = CreateActor(71, 1728.6202,-2411.7305,13.5767,271.0727); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	SetActorVirtualWorld(BotPears[241], 198);
	BotPears[242] = CreateActor(71, 1738.4613,-2433.9980,13.5767,89.8428); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	SetActorVirtualWorld(BotPears[242], 198);
	BotPears[243] = CreateActor(150, 1742.0760,-2421.0786,13.5767,91.7972); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	SetActorVirtualWorld(BotPears[243], 198);
	BotPears[244] = CreateActor(150, 1742.0778,-2425.4563,13.5767,91.7972); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	SetActorVirtualWorld(BotPears[244], 198);
	BotPears[245] = CreateActor(150, 1742.0760,-2429.7825,13.5767,89.8938); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	SetActorVirtualWorld(BotPears[245], 198);
	BotPears[250] = CreateActor(199, -35.4461,77.0759,3.1331,13.4866); // Ферма в Интерьере
	SetActorVirtualWorld(BotPears[250], 228);

    BotPears[271] = CreateActor(178, -103.6952,-24.2643,1000.7188,1.9498); // Sex Shop Bot
    SetActorVirtualWorld(BotPears[271], 1);
    BotPears[272] = CreateActor(178, -103.6952,-24.2643,1000.7188,1.9498); // Sex Shop Bot
    SetActorVirtualWorld(BotPears[272], 2);
    BotPears[273] = CreateActor(178, -103.6952,-24.2643,1000.7188,1.9498); // Sex Shop Bot
    SetActorVirtualWorld(BotPears[273], 3);
    BotPears[274] = CreateActor(178, -103.6952,-24.2643,1000.7188,1.9498); // Sex Shop Bot
    SetActorVirtualWorld(BotPears[274], 4);
    BotPears[313] = CreateActor(147,-2046.6985,-988.4554,1651.6968,30.9710); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
    SetActorVirtualWorld(BotPears[313], 7);
    BotPears[314] = CreateActor(187,-2047.6536,-987.2053,1651.6968,215.5261); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
    SetActorVirtualWorld(BotPears[314], 7);
    BotPears[315] = CreateActor(164,-2000.2031,161.7839,1666.0313,93.0917); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
    SetActorVirtualWorld(BotPears[315], 7);
    BotPears[323] = CreateActor(202,1382.5847,-21.8886,1001.0793,94.5528); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ ]
    SetActorVirtualWorld(BotPears[323], 11);
    BotPears[324] = CreateActor(206,1377.6793,-15.4435,1001.0717,220.1772); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
    SetActorVirtualWorld(BotPears[324], 11);
    BotPears[325] = CreateActor(261,1378.6981,-16.7620,1001.0717,38.1523); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
    SetActorVirtualWorld(BotPears[325], 11);
    BotPears[350] = CreateActor(16,2532.5154,2800.9751,10.8203,125.0607); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[351] = CreateActor(27,2517.1875,2829.1831,10.8203,246.0552); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[352] = CreateActor(153,2518.6653,2828.4517,10.8203,58.7035); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[368] = CreateActor(208,-1456.3763,916.2051,7.3453,3.4842); // Triada Mafia Bot
    BotPears[369] = CreateActor(210,-1456.4972,917.7109,7.3453,182.3992); // Triada Mafia Bot
    BotPears[370] = CreateActor(120,-1500.5579,932.4845,7.3453,184.8825); // Triada Mafia Bot
    BotPears[371] = CreateActor(186,-1492.5112,917.4147,7.3453,77.4082); // Triada Mafia Bot
    BotPears[372] = CreateActor(118,-1494.8196,918.6791,7.3453,240.3431); // Triada Mafia Bot
    BotPears[373] = CreateActor(117,-1452.9584,929.5131,7.3793,99.3419); // Triada Mafia Bot
    BotPears[376] = CreateActor(194,2211.8379,1029.4117,994.4688,182.3280); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot пїЅпїЅпїЅпїЅпїЅ
    SetActorVirtualWorld(BotPears[376], 2001);
    BotPears[377] = CreateActor(172,2216.7393,1029.4164,994.4688,180.7613); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot пїЅпїЅпїЅпїЅпїЅ
    SetActorVirtualWorld(BotPears[377], 2001);
    BotPears[378] = CreateActor(171,2221.4226,1029.4115,994.4688,180.4480); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot пїЅпїЅпїЅпїЅпїЅ
    SetActorVirtualWorld(BotPears[378], 2001);
    BotPears[379] = CreateActor(172,2183.0564,1013.2817,992.4688,180.3346); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot пїЅпїЅпїЅпїЅпїЅпїЅпїЅ [0]
    SetActorVirtualWorld(BotPears[379], 2001);
    BotPears[380] = CreateActor(172,2183.0564,1019.2822,992.4688,177.8512); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot пїЅпїЅпїЅпїЅпїЅпїЅпїЅ [1]
    SetActorVirtualWorld(BotPears[380], 2001);
    BotPears[381] = CreateActor(172,2183.0564,1025.2816,992.4688,174.0912); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot пїЅпїЅпїЅпїЅпїЅпїЅпїЅ [2]
    SetActorVirtualWorld(BotPears[381], 2001);
    BotPears[382] = CreateActor(171,2171.3940,1014.0906,992.4688,106.5708); // пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[382], 2001);
	BotPears[383] = CreateActor(171,2171.5842,1022.4432,992.4688,83.6973); // пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[383], 2001);
	BotPears[384] = CreateActor(163,2201.9219,1007.3365,994.4688,91.9738); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ otb пїЅпїЅпїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[384], 2001);
	BotPears[385] = CreateActor(171,2176.9482,1020.9529,992.4688,277.3156); // пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[385], 2001);
    BotPears[386] = CreateActor(171,2176.8618,1014.8093,992.4688,270.7356); // пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[386], 2001);
	BotPears[387] = CreateActor(171,2171.0869,1018.0458,992.4688,95.1071); // пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[387], 2001);
	BotPears[388] = CreateActor(163,2170.4785,998.8090,992.4688,358.4547); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ otb пїЅпїЅпїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[388], 2001);
	BotPears[391] = CreateActor(164,2242.9587,1021.4113,996.8750,89.6121); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ otb пїЅпїЅпїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[391], 2001);
	BotPears[392] = CreateActor(163,2243.1431,1014.8881,996.8818,90.8655); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ otb пїЅпїЅпїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[392], 2001);
	BotPears[399] = CreateActor(300,-1589.6486,709.7194,13.8918,138.6395); // Bot SFPD
	SetActorVirtualWorld(BotPears[399], 209);
	BotPears[400] = CreateActor(301,-1590.7100,708.5793,13.8918,309.8895); // Bot SFPD
	SetActorVirtualWorld(BotPears[400], 209);
	BotPears[406] = CreateActor(281,-1617.9553,685.4202,7.1875,94.6019); // Bot SFPD
	BotPears[407] = CreateActor(210,-1611.9543,715.0781,13.1420,328.2543); // Bot SFPD
	BotPears[408] = CreateActor(267,-1611.1908,716.0125,12.9967,137.1425); // Bot SFPD
	BotPears[409] = CreateActor(288,-1591.9323,718.3911,9.5872,117.7156); // Bot SFPD
	BotPears[410] = CreateActor(265,-1593.4348,717.3204,9.8826,335.7743); // Bot SFPD
	BotPears[411] = CreateActor(71, 1402.2173,3.8803,1000.9217,92.9859); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 21
	SetActorVirtualWorld(BotPears[411], 5);
	BotPears[412] = CreateActor(71, 1376.4246,-6.3177,1000.9267,182.4317); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 22
	SetActorVirtualWorld(BotPears[412], 5);
	BotPears[413] = CreateActor(71, 1395.8878,-16.0300,1000.9217,271.3257); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 23
	SetActorVirtualWorld(BotPears[413], 5);
	BotPears[414] = CreateActor(274, 1400.1345,-21.4354,1000.9217,253.0776); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 24
	SetActorVirtualWorld(BotPears[414], 5);
	BotPears[415] = CreateActor(272, 1401.3024,-21.7337,1000.9217,71.9927); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 25
	SetActorVirtualWorld(BotPears[415], 5);
	BotPears[416] = CreateActor(70, 1377.5765,-21.8737,1000.9217,51.2186); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 26
	SetActorVirtualWorld(BotPears[416], 6);
	BotPears[417] = CreateActor(276, 1386.7156,-13.8015,1000.9217,9.9520); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 27
	SetActorVirtualWorld(BotPears[417], 5);
	BotPears[418] = CreateActor(259, 1386.1909,-12.0045,1000.9219,195.7369); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 28
	SetActorVirtualWorld(BotPears[418], 5);
	BotPears[419] = CreateActor(308, 1218.2460,-1352.8877,2001.0491,178.0994); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	SetActorVirtualWorld(BotPears[419], 4);
	BotPears[420] = CreateActor(71, 1211.5765,-1357.6942,2001.0449,271.6186); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 2
	SetActorVirtualWorld(BotPears[420], 4);
	BotPears[421] = CreateActor(291, 1226.6830,-1361.0850,2001.0491,78.6269); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 3
	SetActorVirtualWorld(BotPears[421], 4);
	BotPears[422] = CreateActor(70, 1225.1354,-1360.9229,2001.0491,258.0002); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 4
	SetActorVirtualWorld(BotPears[422], 4);
	BotPears[423] = CreateActor(308, 1219.8785,-1350.2245,2001.0491,357.6178); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 5
	SetActorVirtualWorld(BotPears[423], 4);
	BotPears[424] = CreateActor(70, 1226.2745,-1411.0952,2001.0491,89.4486); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 6
	SetActorVirtualWorld(BotPears[424], 4);
	BotPears[425] = CreateActor(71, 1218.0801,-1410.1809,2001.0491,183.2813); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 7
	SetActorVirtualWorld(BotPears[425], 4);
	BotPears[426] = CreateActor(70, 1223.8677,-1442.9573,2001.0491,1.4010); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 8
	SetActorVirtualWorld(BotPears[426], 4);
	BotPears[427] = CreateActor(279, -2143.6426,78.1282,35.1633,184.4606); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 1
	BotPears[428] = CreateActor(277, -2145.6177,64.1148,35.1633,68.6711); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 2
	BotPears[429] = CreateActor(278, -2147.5535,64.6648,35.1633,252.2863); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 3
	BotPears[430] = CreateActor(219, -2128.9646,66.1872,1403.3984,186.8929); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 4
	SetActorVirtualWorld(BotPears[430], 4);
	BotPears[431] = CreateActor(277, -2128.8323,69.6934,1403.3984,358.9144); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 5
	SetActorVirtualWorld(BotPears[431], 4);
	BotPears[432] = CreateActor(279, -2120.2576,60.6968,1403.3984,147.1225); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 6
	SetActorVirtualWorld(BotPears[432], 4);
	BotPears[433] = CreateActor(304, -2120.9204,59.4988,1403.3984,328.5442); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 7
	SetActorVirtualWorld(BotPears[433], 4);
	BotPears[434] = CreateActor(124, 1279.9063,-2049.4492,59.1290,88.8323); // Cosa Nostra Bot 1
	BotPears[435] = CreateActor(126, 1241.1165,-2049.7031,60.0028,342.2980); // Cosa Nostra Bot 2
	BotPears[436] = CreateActor(127, 1241.4069,-2048.6489,60.0191,159.9596); // Cosa Nostra Bot 3
	BotPears[437] = CreateActor(185, 1241.6699,-2035.7485,60.0329,267.0973); // Cosa Nostra Bot 4
	BotPears[438] = CreateActor(124, 1169.9761,-2028.0551,69.0000,132.3627); // Cosa Nostra Bot 5
	BotPears[439] = CreateActor(126, 1168.9500,-2028.9075,69.0000,308.7710); // Cosa Nostra Bot 6
	BotPears[440] = CreateActor(127, 1140.0459,-2041.6765,69.0000,358.9048); // Cosa Nostra Bot 7
	BotPears[441] = CreateActor(185, 1126.5526,-2033.9010,69.8845,274.3040); // Cosa Nostra Bot 8
	BotPears[442] = CreateActor(124, -1492.2446,1971.3748,1357.0326,87.5192); // Cosa Nostra Bot 9
	SetActorVirtualWorld(BotPears[442], 5);
	BotPears[443] = CreateActor(126, -1494.9949,1980.3163,1357.0326,227.7253); // Cosa Nostra Bot 10
	SetActorVirtualWorld(BotPears[443], 5);
	BotPears[444] = CreateActor(127, -1493.5272,1979.2655,1357.0326,54.4502); // Cosa Nostra Bot 11
	SetActorVirtualWorld(BotPears[444], 5);
	BotPears[445] = CreateActor(185, -1502.3109,1985.2120,1357.0447,81.3738); // Cosa Nostra Bot 12
	SetActorVirtualWorld(BotPears[445], 5);
	BotPears[470] = CreateActor(171,1264.6343,1306.6207,1558.2009,275.2307); // пїЅпїЅпїЅпїЅпїЅ Bot 1 пїЅ пїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[470], 85);
	BotPears[471] = CreateActor(11,1309.7184,1314.3702,1558.2090,272.7471); // пїЅпїЅпїЅпїЅпїЅ Bot 1 пїЅ пїЅпїЅпїЅпїЅ
	SetActorVirtualWorld(BotPears[471], 85);
	BotPears[475] = CreateActor(164,1265.6527,-49.2240,1000.9280,1.3875); // пїЅпїЅпїЅпїЅпїЅ Bot 1
	SetActorVirtualWorld(BotPears[475], 3);
	BotPears[476] = CreateActor(164,1288.0977,-49.1689,1000.9280,7.3408); // пїЅпїЅпїЅпїЅпїЅ Bot 2
	SetActorVirtualWorld(BotPears[476], 3);
	BotPears[477] = CreateActor(163,1280.0337,-37.1167,1000.9280,181.2190); // пїЅпїЅпїЅпїЅпїЅ Bot 3
	SetActorVirtualWorld(BotPears[477], 3);
	BotPears[478] = CreateActor(189,1280.3707,-47.6048,1000.9280,314.8688); // пїЅпїЅпїЅпїЅпїЅ Bot 4
	SetActorVirtualWorld(BotPears[478], 3);
	BotPears[479] = CreateActor(59,1283.0580,-42.2432,1000.9280,15.6561); // пїЅпїЅпїЅпїЅпїЅ Bot 5
	SetActorVirtualWorld(BotPears[479], 3);
	BotPears[480] = CreateActor(98,1282.6345,-40.7867,1000.9280,194.8844); // пїЅпїЅпїЅпїЅпїЅ Bot 6
	SetActorVirtualWorld(BotPears[480], 3);
	BotPears[481] = CreateActor(141,1274.4423,-46.8282,1000.9280,20.3795); // пїЅпїЅпїЅпїЅпїЅ Bot 7
	SetActorVirtualWorld(BotPears[481], 3);
	BotPears[482] = CreateActor(43,1273.9204,-45.3367,1000.9280,204.5977); // пїЅпїЅпїЅпїЅпїЅ Bot 8
	SetActorVirtualWorld(BotPears[482], 3);
	BotPears[483] = CreateActor(70,1178.8080,-1338.3379,13.8725,272.0269); // ASGH Bot 1
	BotPears[484] = CreateActor(70,2014.5818,-1410.8331,16.9922,153.8991); // ASGH Bot 2
	BotPears[489] = CreateActor(167, 368.9441,-4.4851,1001.8516,181.6134); // Cluckin Bell LV-2 Bot
    SetActorVirtualWorld(BotPears[489], 7);
	BotPears[493] = CreateActor(71, 1382.2180,-30.1561,1000.9110,359.8083); // IKEA Bot 1
    SetActorVirtualWorld(BotPears[493], 194);
    BotPears[494] = CreateActor(71, 1377.0071,-13.0329,1000.9110,270.8442); // IKEA Bot 2
    SetActorVirtualWorld(BotPears[494], 194);
    BotPears[495] = CreateActor(69, 1385.6508,-12.3937,1000.9110,181.3256); // IKEA Bot 3
    SetActorVirtualWorld(BotPears[495], 194);
    BotPears[496] = CreateActor(151, 1385.8430,-17.9771,1000.9110,349.6602); // IKEA Bot 4
    SetActorVirtualWorld(BotPears[496], 194);
    BotPears[498] = CreateActor(96, 1377.2981,-23.9866,1000.9110,90.2411); // IKEA Bot 6
    SetActorVirtualWorld(BotPears[498], 194);
    BotPears[501] = CreateActor(71,1369.7183,-25.3327,1001.0717,2.6003); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
    SetActorVirtualWorld(BotPears[501], 11);
	BotPears[502] = CreateActor(141,1631.0111,-2274.5208,13.5732,179.4451); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	// пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[507] = CreateActor(141,1274.8622,-21.0276,1000.9254,89.6971); // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ Bot
    SetActorVirtualWorld(BotPears[507], 100);
    BotPears[508] = CreateActor(150,1274.8622,-23.4229,1000.9254,87.1905); // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ Bot
    SetActorVirtualWorld(BotPears[508], 100);
    BotPears[509] = CreateActor(71,1255.7573,-24.2271,1000.9254,271.5772); // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ Bot
    SetActorVirtualWorld(BotPears[509], 100);
    BotPears[510] = CreateActor(71,1394.2056,-31.3340,1000.8779,335.8245); // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
    SetActorVirtualWorld(BotPears[510], 237);
    BotPears[511] = CreateActor(59,1400.3665,-30.2018,1000.8779,297.4525); // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
    SetActorVirtualWorld(BotPears[511], 237);
    BotPears[512] = CreateActor(147,1401.7723,-29.2993,1000.8779,122.6343); // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
    SetActorVirtualWorld(BotPears[512], 237);
    BotPears[513] = CreateActor(141,-1753.0793,885.3437,105.0207,182.7715); // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
    SetActorVirtualWorld(BotPears[513], 236);
    BotPears[514] = CreateActor(71,-1766.3875,890.2181,105.0248,270.9872); // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
    SetActorVirtualWorld(BotPears[514], 236);
    BotPears[515] = CreateActor(71,-1739.9305,877.7605,105.0148,91.1557); // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
    SetActorVirtualWorld(BotPears[515], 236);
    BotPears[516] = CreateActor(45, 565.910583,-1809.059204,6.062500,97.0); // пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
    BotPears[517] = CreateActor(140, 564.8656,-1809.2654,6.0625,280.8233); // пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	//BotPears[518] = CreateActor(270, 2530.8591,-1664.4253,15.1665,171.8431); // пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ Grove
	BotPears[519] = CreateActor(71, 1089.5840,-1213.9564,18.0118,183.9828); // collector bot work

	LoadAnimBot(5000);
	for(new i=0; i<MAX_BOTS; i++) SetActorInvulnerable(BotPears[i], 0);

	CreateDynamicActor(141, 1760.1196,1404.7627,10.9041,87.1673, true, 100.0, 0, 0, -1, 100.0, -1, 0); // aero lv girl
	return 1;
}
stock LoadAnimBot(stat)
{
     switch(stat)
	 {
        case 7: ApplyActorAnimation(BotPears[7],"PED","SEAT_idle",4.1,1,0,0,0,0);
        case 8: ApplyActorAnimation(BotPears[8],"PED","SEAT_idle",4.1,1,0,0,0,0);
        case 12: ApplyActorAnimation(BotPears[12],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        case 13: ApplyActorAnimation(BotPears[13],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        case 14: ApplyActorAnimation(BotPears[14],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
        case 15: ApplyActorAnimation(BotPears[15],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        case 16: ApplyActorAnimation(BotPears[16],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        case 17: ApplyActorAnimation(BotPears[17],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
        case 18: ApplyActorAnimation(BotPears[18],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        case 19: ApplyActorAnimation(BotPears[19],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        case 20: ApplyActorAnimation(BotPears[20],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
        case 21: ApplyActorAnimation(BotPears[21],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        case 22: ApplyActorAnimation(BotPears[22],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 1 [ Разговаривает ]
        case 23: ApplyActorAnimation(BotPears[23],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 2
        case 24: ApplyActorAnimation(BotPears[24],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 3
        case 25: ApplyActorAnimation(BotPears[25],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 4
        case 26: ApplyActorAnimation(BotPears[26],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 5
        case 27: ApplyActorAnimation(BotPears[27],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 6
        case 28: ApplyActorAnimation(BotPears[28],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 7
        case 29: ApplyActorAnimation(BotPears[29],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 8
        case 34: ApplyActorAnimation(BotPears[34],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Вокзал Bot 3
        case 35: ApplyActorAnimation(BotPears[35],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Вокзал Bot 4
        case 37: ApplyActorAnimation(BotPears[37],"PED","woman_idlestance",4.1,1,0,0,0,0); // Вокзал Bot 6
        case 38: ApplyActorAnimation(BotPears[38],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Вокзал Bot 7
        case 39: ApplyActorAnimation(BotPears[39],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Вокзал Bot 8
        case 40: ApplyActorAnimation(BotPears[40],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Вокзал Bot 9
        case 45: ApplyActorAnimation(BotPears[45],"PED","woman_idlestance",4.1,1,0,0,0,0); // Спермобанк Bot 1
        case 49: ApplyActorAnimation(BotPears[49],"PED","woman_idlestance",4.1,1,0,0,0,0); // Госпиталь Bot 2
        case 51: ApplyActorAnimation(BotPears[51],"PED","woman_idlestance",4.1,0,1,1,1,1); // Госпиталь Bot 4
        case 52: ApplyActorAnimation(BotPears[52],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Госпиталь Bot 5
        case 53: ApplyActorAnimation(BotPears[53],"CRACK","crckdeth1",4.1,0,1,1,1,1); // Госпиталь Bot 6
        case 54: ApplyActorAnimation(BotPears[54],"CRACK","crckidle2",4.1,0,1,1,1,1); // Госпиталь Bot 7
        case 56: ApplyActorAnimation(BotPears[56],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        case 57: ApplyActorAnimation(BotPears[57],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
        case 58: ApplyActorAnimation(BotPears[58],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Russian Mafia Bot 1 [ Разговаривает ]
        case 59: ApplyActorAnimation(BotPears[59],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0); // Russian Mafia Bot 2
        case 60: ApplyActorAnimation(BotPears[60],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Russian Mafia Bot 3
        case 61: ApplyActorAnimation(BotPears[61],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Russian Mafia Bot 4
        case 62: ApplyActorAnimation(BotPears[62],"SMOKING","M_smk_loop",4.1,1,0,0,0,0); // Russian Mafia Bot 5
        case 69: ApplyActorAnimation(BotPears[69],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        case 70: ApplyActorAnimation(BotPears[70],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        case 71: ApplyActorAnimation(BotPears[71],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
		case 77: ApplyActorAnimation(BotPears[77],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // aero lv talk 1
        case 78: ApplyActorAnimation(BotPears[78],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // aero lv talk 2
		case 83: ApplyActorAnimation(BotPears[83],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
		case 84: ApplyActorAnimation(BotPears[84],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
		case 85: ApplyActorAnimation(BotPears[85],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
		case 86: ApplyActorAnimation(BotPears[86],"BD_FIRE","wash_up",4.1,1,0,0,0,0);
		case 87: ApplyActorAnimation(BotPears[87],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
		case 88: ApplyActorAnimation(BotPears[88],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 89: ApplyActorAnimation(BotPears[89],"PED","IDLE_CHAT",4.1,1,0,0,0,0);

        case 96: ApplyActorAnimation(BotPears[96],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Аэропорт lv security 1
        case 97: ApplyActorAnimation(BotPears[97],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Аэропорт lv security 2

        case 105: ApplyActorAnimation(BotPears[105],"BLOWJOBZ","BJ_STAND_LOOP_W",4,1,0,0,1,0); // Sex Bot 1
        case 106: ApplyActorAnimation(BotPears[106],"BLOWJOBZ","BJ_STAND_LOOP_P",4,1,0,0,1,0); // Sex Bot 2
        case 110: ApplyActorAnimation(BotPears[110],"BD_FIRE","wash_up",4.1,1,0,0,0,0);// Госпиталь Bot 8
        case 111: ApplyActorAnimation(BotPears[111],"CRACK","crckidle2",4.1,0,1,1,1,1);// Госпиталь Bot 9
        case 112: ApplyActorAnimation(BotPears[112],"CRACK","crckidle1",4.1,0,1,1,1,1);// Госпиталь Bot 10
        case 113: ApplyActorAnimation(BotPears[113],"CRACK","crckidle2",4.1,0,1,1,1,1);// Госпиталь Bot 11
        case 114: ApplyActorAnimation(BotPears[114],"CRACK","crckidle1",4.1,0,1,1,1,1);// Госпиталь Bot 12
        case 115: ApplyActorAnimation(BotPears[115],"CRACK","crckidle2",4.1,0,1,1,1,1);// Госпиталь Bot 13
        case 116: ApplyActorAnimation(BotPears[116],"PED","IDLE_CHAT",4.1,1,0,0,0,0);// Госпиталь Bot 14
        case 117: ApplyActorAnimation(BotPears[117],"PED","IDLE_CHAT",4.1,1,0,0,0,0);// Госпиталь Bot 15
        case 118: ApplyActorAnimation(BotPears[118],"OTB","wtchrace_loop",4.1,1,0,0,0,0);// Госпиталь Bot 16
        case 119: ApplyActorAnimation(BotPears[119],"PED","IDLE_CHAT",4.1,1,0,0,0,0);// Госпиталь Bot 17
        case 120: ApplyActorAnimation(BotPears[120],"PED","IDLE_CHAT",4.1,1,0,0,0,0);// Госпиталь Bot 18
        case 121: ApplyActorAnimation(BotPears[121],"CRACK","crckidle1",4.1,1,0,0,0,0);// Госпиталь Bot 19
        case 122: ApplyActorAnimation(BotPears[122],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Госпиталь Bot 20
        case 151: ApplyActorAnimation(BotPears[151],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 4
        case 152: ApplyActorAnimation(BotPears[152],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 5
        case 153: ApplyActorAnimation(BotPears[153],"SMOKING","M_smk_drag",4.1,1,0,0,0,0); // LSPD Bot 6
        case 154: ApplyActorAnimation(BotPears[154],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 7
        case 155: ApplyActorAnimation(BotPears[155],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 8
        case 156: ApplyActorAnimation(BotPears[156],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 9
        case 157: ApplyActorAnimation(BotPears[157],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 10
        case 192: ApplyActorAnimation(BotPears[192],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Pizza Co Bot 1
        case 195: ApplyActorAnimation(BotPears[195],"BD_FIRE","wash_up",4.1,1,0,0,0,0); // Pizza Co Bot 2
        case 196: ApplyActorAnimation(BotPears[196],"BD_FIRE","wash_up",4.1,1,0,0,0,0); // Pizza Co Bot 3
        case 204: ApplyActorAnimation(BotPears[204],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Археология Bot 1
        case 207: ApplyActorAnimation(BotPears[207],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 1
        case 208: ApplyActorAnimation(BotPears[208],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 2
        case 209: ApplyActorAnimation(BotPears[209],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 3
        case 219: ApplyActorAnimation(BotPears[219],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 4
        case 220: ApplyActorAnimation(BotPears[220],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 5
        case 221: ApplyActorAnimation(BotPears[221],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 6
		case 227: ApplyActorAnimation(BotPears[227],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 7
        case 228: ApplyActorAnimation(BotPears[228],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 8
        case 229: ApplyActorAnimation(BotPears[229],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 9
        case 230: ApplyActorAnimation(BotPears[230],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 10
        case 231: ApplyActorAnimation(BotPears[231],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 11
        case 232: ApplyActorAnimation(BotPears[232],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 12
        case 233: ApplyActorAnimation(BotPears[233],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 13
        case 234: ApplyActorAnimation(BotPears[234],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 14
        case 235: ApplyActorAnimation(BotPears[235],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 15
        case 236: ApplyActorAnimation(BotPears[236],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 16
        case 237: ApplyActorAnimation(BotPears[237],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 17
        case 238: ApplyActorAnimation(BotPears[238],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 18
        case 241: ApplyActorAnimation(BotPears[241],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Аэропорт Bot 1
        case 242: ApplyActorAnimation(BotPears[242],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Аэропорт Bot 1
        case 313: ApplyActorAnimation(BotPears[313],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Правительство Bot
        case 314: ApplyActorAnimation(BotPears[314],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Правительство Bot
        case 315: ApplyActorAnimation(BotPears[315],"DEALER","DEALER_IDLE",4.1,0,1,1,1,1); // Правительство Bot
        case 324: ApplyActorAnimation(BotPears[324],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Дальнобойщики Bot
        case 325: ApplyActorAnimation(BotPears[325],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Дальнобойщики Bot
        case 350: ApplyActorAnimation(BotPears[350],"SMOKING","M_smk_loop",4.1,1,0,0,0,0);
        case 351: ApplyActorAnimation(BotPears[351],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 352: ApplyActorAnimation(BotPears[352],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 368: ApplyActorAnimation(BotPears[368],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 369: ApplyActorAnimation(BotPears[369],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 370: ApplyActorAnimation(BotPears[370],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 371: ApplyActorAnimation(BotPears[371],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 372: ApplyActorAnimation(BotPears[372],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 373: ApplyActorAnimation(BotPears[373],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 384: ApplyActorAnimation(BotPears[384],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 388: ApplyActorAnimation(BotPears[388],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 391: ApplyActorAnimation(BotPears[391],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 392: ApplyActorAnimation(BotPears[392],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 399: ApplyActorAnimation(BotPears[399],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 400: ApplyActorAnimation(BotPears[400],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 406: ApplyActorAnimation(BotPears[406],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 407: ApplyActorAnimation(BotPears[407],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 408: ApplyActorAnimation(BotPears[408],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 409: ApplyActorAnimation(BotPears[409],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 410: ApplyActorAnimation(BotPears[410],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0);
        case 411: ApplyActorAnimation(BotPears[411],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 412: ApplyActorAnimation(BotPears[412],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 413: ApplyActorAnimation(BotPears[413],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 414: ApplyActorAnimation(BotPears[414],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 415: ApplyActorAnimation(BotPears[415],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 418: ApplyActorAnimation(BotPears[418],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 420: ApplyActorAnimation(BotPears[420],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 421: ApplyActorAnimation(BotPears[421],"CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
        case 423: ApplyActorAnimation(BotPears[423],"BD_FIRE","wash_up",4.1,0,1,1,1,1);
        case 425: ApplyActorAnimation(BotPears[425],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 426: ApplyActorAnimation(BotPears[426],"BD_FIRE","wash_up",4.1,0,1,1,1,1);
        case 427: ApplyActorAnimation(BotPears[427],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0);
        case 428: ApplyActorAnimation(BotPears[428],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 429: ApplyActorAnimation(BotPears[429],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 431: ApplyActorAnimation(BotPears[431],"BD_FIRE","wash_up",4.1,0,1,1,1,1);
        case 432: ApplyActorAnimation(BotPears[432],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 433: ApplyActorAnimation(BotPears[433],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 434: ApplyActorAnimation(BotPears[434],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0);
        case 435: ApplyActorAnimation(BotPears[435],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 436: ApplyActorAnimation(BotPears[436],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 437: ApplyActorAnimation(BotPears[437],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 438: ApplyActorAnimation(BotPears[438],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 439: ApplyActorAnimation(BotPears[439],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 440: ApplyActorAnimation(BotPears[440],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0);
        case 441: ApplyActorAnimation(BotPears[441],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 442: ApplyActorAnimation(BotPears[442],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 443: ApplyActorAnimation(BotPears[443],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 444: ApplyActorAnimation(BotPears[444],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 445: ApplyActorAnimation(BotPears[445],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 475: ApplyActorAnimation(BotPears[475],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 476: ApplyActorAnimation(BotPears[476],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 477: ApplyActorAnimation(BotPears[477],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 478: ApplyActorAnimation(BotPears[478],"BD_FIRE","wash_up",4.1,1,0,0,0,0);
        case 479: ApplyActorAnimation(BotPears[479],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 480: ApplyActorAnimation(BotPears[480],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 482: ApplyActorAnimation(BotPears[482],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 486: ApplyActorAnimation(BotPears[486],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 487: ApplyActorAnimation(BotPears[487],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 488: ApplyActorAnimation(BotPears[488],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 490: ApplyActorAnimation(BotPears[490],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0);
        case 491: ApplyActorAnimation(BotPears[491],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0);
        case 492: ApplyActorAnimation(BotPears[492],"PED","woman_idlestance",4.1,1,0,0,0,0);
        case 493: ApplyActorAnimation(BotPears[493],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 494: ApplyActorAnimation(BotPears[494],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 498: ApplyActorAnimation(BotPears[498],"BD_FIRE","wash_up",4.1,1,0,0,0,0);
        case 501: ApplyActorAnimation(BotPears[501],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 509: ApplyActorAnimation(BotPears[509],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 510: ApplyActorAnimation(BotPears[510],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 511: ApplyActorAnimation(BotPears[511],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 512: ApplyActorAnimation(BotPears[512],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        case 514: ApplyActorAnimation(BotPears[514],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 515: ApplyActorAnimation(BotPears[515],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        case 516: ApplyActorAnimation(BotPears[516],"BLOWJOBZ","BJ_STAND_LOOP_P",4.1,1,0,0,0,0);
        case 517: ApplyActorAnimation(BotPears[517],"BLOWJOBZ","BJ_STAND_LOOP_W",4.1,1,0,0,0,0);
        
        case 5000:
		{
        ApplyActorAnimation(BotPears[7],"PED","SEAT_idle",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[8],"PED","SEAT_idle",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[12],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[13],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[14],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[15],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[16],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[17],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[18],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[19],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[20],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[21],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[22],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 1 [ Разговаривает ]
        ApplyActorAnimation(BotPears[23],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 2
        ApplyActorAnimation(BotPears[24],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 3
        ApplyActorAnimation(BotPears[25],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 4
        ApplyActorAnimation(BotPears[26],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 5
        ApplyActorAnimation(BotPears[27],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 6
        ApplyActorAnimation(BotPears[28],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 7
        ApplyActorAnimation(BotPears[29],"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0); // Yakuza Mafia Bot 8
        ApplyActorAnimation(BotPears[34],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Вокзал Bot 3
        ApplyActorAnimation(BotPears[35],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Вокзал Bot 4
        ApplyActorAnimation(BotPears[37],"PED","woman_idlestance",4.1,1,0,0,0,0); // Вокзал Bot 6
        ApplyActorAnimation(BotPears[38],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Вокзал Bot 7
        ApplyActorAnimation(BotPears[39],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Вокзал Bot 8
        ApplyActorAnimation(BotPears[40],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Вокзал Bot 9
        ApplyActorAnimation(BotPears[45],"PED","woman_idlestance",4.1,1,0,0,0,0); // Спермобанк Bot 1
        ApplyActorAnimation(BotPears[49],"PED","woman_idlestance",4.1,1,0,0,0,0); // Госпиталь Bot 2
        ApplyActorAnimation(BotPears[51],"PED","woman_idlestance",4.1,0,1,1,1,1); // Госпиталь Bot 4
        ApplyActorAnimation(BotPears[52],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Госпиталь Bot 5
        ApplyActorAnimation(BotPears[53],"CRACK","crckdeth1",4.1,0,1,1,1,1); // Госпиталь Bot 6
        ApplyActorAnimation(BotPears[54],"CRACK","crckidle2",4.1,0,1,1,1,1); // Госпиталь Bot 7
        ApplyActorAnimation(BotPears[56],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[57],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[58],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Russian Mafia Bot 1 [ Разговаривает ]
        ApplyActorAnimation(BotPears[59],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0); // Russian Mafia Bot 2
        ApplyActorAnimation(BotPears[60],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Russian Mafia Bot 3
        ApplyActorAnimation(BotPears[61],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Russian Mafia Bot 4
        ApplyActorAnimation(BotPears[62],"SMOKING","M_smk_loop",4.1,1,0,0,0,0); // Russian Mafia Bot 5
        ApplyActorAnimation(BotPears[69],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[70],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
        ApplyActorAnimation(BotPears[71],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
		ApplyActorAnimation(BotPears[77],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // aero lv talk 1
        ApplyActorAnimation(BotPears[78],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // aero lv talk 2
		ApplyActorAnimation(BotPears[83],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
		ApplyActorAnimation(BotPears[84],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
		ApplyActorAnimation(BotPears[85],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
		ApplyActorAnimation(BotPears[86],"BD_FIRE","wash_up",4.1,1,0,0,0,0);
		ApplyActorAnimation(BotPears[87],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
		ApplyActorAnimation(BotPears[88],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[89],"PED","IDLE_CHAT",4.1,1,0,0,0,0);

        ApplyActorAnimation(BotPears[96],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Аэропорт lv security 1
        ApplyActorAnimation(BotPears[97],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Аэропорт lv security 2

        ApplyActorAnimation(BotPears[105],"BLOWJOBZ","BJ_STAND_LOOP_W",4,1,0,0,1,0); // Sex Bot 1
        ApplyActorAnimation(BotPears[106],"BLOWJOBZ","BJ_STAND_LOOP_P",4,1,0,0,1,0); // Sex Bot 2
        ApplyActorAnimation(BotPears[110],"BD_FIRE","wash_up",4.1,1,0,0,0,0);// Госпиталь Bot 8
        ApplyActorAnimation(BotPears[111],"CRACK","crckidle2",4.1,0,1,1,1,1);// Госпиталь Bot 9
        ApplyActorAnimation(BotPears[112],"CRACK","crckidle1",4.1,0,1,1,1,1);// Госпиталь Bot 10
        ApplyActorAnimation(BotPears[113],"CRACK","crckidle2",4.1,0,1,1,1,1);// Госпиталь Bot 11
        ApplyActorAnimation(BotPears[114],"CRACK","crckidle1",4.1,0,1,1,1,1);// Госпиталь Bot 12
        ApplyActorAnimation(BotPears[115],"CRACK","crckidle2",4.1,0,1,1,1,1);// Госпиталь Bot 13
        ApplyActorAnimation(BotPears[116],"PED","IDLE_CHAT",4.1,1,0,0,0,0);// Госпиталь Bot 14
        ApplyActorAnimation(BotPears[117],"PED","IDLE_CHAT",4.1,1,0,0,0,0);// Госпиталь Bot 15
        ApplyActorAnimation(BotPears[118],"OTB","wtchrace_loop",4.1,1,0,0,0,0);// Госпиталь Bot 16
        ApplyActorAnimation(BotPears[119],"PED","IDLE_CHAT",4.1,1,0,0,0,0);// Госпиталь Bot 17
        ApplyActorAnimation(BotPears[120],"PED","IDLE_CHAT",4.1,1,0,0,0,0);// Госпиталь Bot 18
        ApplyActorAnimation(BotPears[121],"CRACK","crckidle1",4.1,1,0,0,0,0);// Госпиталь Bot 19
        ApplyActorAnimation(BotPears[122],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Госпиталь Bot 20
        ApplyActorAnimation(BotPears[151],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 4
        ApplyActorAnimation(BotPears[152],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 5
        ApplyActorAnimation(BotPears[153],"SMOKING","M_smk_drag",4.1,1,0,0,0,0); // LSPD Bot 6
        ApplyActorAnimation(BotPears[154],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 7
        ApplyActorAnimation(BotPears[155],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 8
        ApplyActorAnimation(BotPears[156],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 9
        ApplyActorAnimation(BotPears[157],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 10

        ApplyActorAnimation(BotPears[204],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Археология Bot 1
        ApplyActorAnimation(BotPears[207],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 1
        ApplyActorAnimation(BotPears[208],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 2
        ApplyActorAnimation(BotPears[209],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 3
        ApplyActorAnimation(BotPears[219],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 4
        ApplyActorAnimation(BotPears[220],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 5
        ApplyActorAnimation(BotPears[221],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 6
        ApplyActorAnimation(BotPears[227],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 7
        ApplyActorAnimation(BotPears[228],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 8
        ApplyActorAnimation(BotPears[229],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 9
        ApplyActorAnimation(BotPears[230],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 10
        ApplyActorAnimation(BotPears[231],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 11
        ApplyActorAnimation(BotPears[232],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 12
        ApplyActorAnimation(BotPears[233],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 13
        ApplyActorAnimation(BotPears[234],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 14
        ApplyActorAnimation(BotPears[235],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 15
        ApplyActorAnimation(BotPears[236],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 16
        ApplyActorAnimation(BotPears[237],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 17
        ApplyActorAnimation(BotPears[238],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 18
        ApplyActorAnimation(BotPears[241],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Аэропорт Bot 1
        ApplyActorAnimation(BotPears[242],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Аэропорт Bot 1
        ApplyActorAnimation(BotPears[313],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Правительство Bot
        ApplyActorAnimation(BotPears[314],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Правительство Bot
        ApplyActorAnimation(BotPears[315],"DEALER","DEALER_IDLE",4.1,0,1,1,1,1); // Правительство Bot
        ApplyActorAnimation(BotPears[324],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Дальнобойщики Bot
        ApplyActorAnimation(BotPears[325],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Дальнобойщики Bot
        ApplyActorAnimation(BotPears[350],"SMOKING","M_smk_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[351],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[352],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[368],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[369],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[370],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[371],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[372],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[373],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[384],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[388],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[391],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[392],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[399],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[400],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[406],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[407],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[408],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[409],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[410],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[411],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[412],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[413],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[414],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[415],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[418],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[420],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[421],"CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
        ApplyActorAnimation(BotPears[423],"BD_FIRE","wash_up",4.1,0,1,1,1,1);
        ApplyActorAnimation(BotPears[425],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[426],"BD_FIRE","wash_up",4.1,0,1,1,1,1);
        ApplyActorAnimation(BotPears[427],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[428],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[429],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[431],"BD_FIRE","wash_up",4.1,0,1,1,1,1);
        ApplyActorAnimation(BotPears[432],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[433],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[434],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[435],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[436],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[437],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[438],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[439],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[440],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[441],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[442],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[443],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[444],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[445],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[475],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[476],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[477],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[478],"BD_FIRE","wash_up",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[479],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[480],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[482],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[486],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[487],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[488],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[490],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[491],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[492],"PED","woman_idlestance",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[493],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[494],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[498],"BD_FIRE","wash_up",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[501],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[509],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[510],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[511],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[512],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[514],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[515],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[516],"BLOWJOBZ","BJ_STAND_LOOP_P",4.1,1,0,0,0,0);
        ApplyActorAnimation(BotPears[517],"BLOWJOBZ","BJ_STAND_LOOP_W",4.1,1,0,0,0,0);
        }
     }
     return 1;
}
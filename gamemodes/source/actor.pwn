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

stock VoiceDynamicActor(playerid, actorid, const link[])
{
    if(IsValidDynamicActor(actorid))
    {
        new Float:pos[3];
        GetDynamicActorPos(actorid, pos[0], pos[1], pos[2]);
        PlayAudioStreamForPlayer(playerid, link, pos[0], pos[1], pos[2], 6.0, true);
    }
    return 1;
}

stock SendDynamicActorMessage(playerid, actorid, const text[], time = 4500) // Обычный текст над головой NPC
{
	if(IsValidDynamicActor(actorid)) MessageDynamicActor(actorid, 0, playerid, text, time);
	return 1;
}
stock SendDynamicActorScript(actorid, playerid, const text[], time = 4500) // Текст для сценария
{
	if(IsValidDynamicActor(actorid)) MessageDynamicActor(actorid, 1, playerid, text, time);
	return 1;
}

stock CreateActorComp(playerid)
{
    if(CompGameActor[playerid] > 0) return 0;
    new string[70];
    format(string,sizeof(string),"{ff9000}%s[%d]\n{0088ff}Играет в игру",rpplayername(playerid),playerid);
    new Float:f_pos[4];
    backme(playerid, 0.6, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
    CompGameText[playerid] = CreateDynamic3DTextLabel(string,0xA9C4E4FF,f_pos[0],f_pos[1],f_pos[2]+0.6,10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,SpWorld[playerid],SpInt[playerid]);
    CompGameActor[playerid] = CreateDynamicActor(PlayerInfo[playerid][pModel], SpX[playerid],SpY[playerid],SpZ[playerid],SpA[playerid], true, 100.0, SpWorld[playerid], SpInt[playerid], -1, 100.0, -1, 0);
    ApplyDynamicActorAnimation(CompGameActor[playerid], "PED","SEAT_idle", 4.0, 0,0,0,1,0);
    OnlineInfo[playerid][oBotInteraction] = CompGameActor[playerid];

    Streamer_SetIntData(STREAMER_TYPE_ACTOR, CompGameActor[playerid], STREAMER_ACTOR_PLAYER_ID, playerid);
    return 1;
}

stock DeleteActorComp(playerid)
{
    if(CompGameActor[playerid] == 0) return 0;
    DestroyDynamic3DTextLabel(CompGameText[playerid]);
    DestroyDynamicActor(CompGameActor[playerid]);
    CompGameActor[playerid] = 0;
    OnlineInfo[playerid][oBotInteraction] = 0;
    return 1;
}


stock MessageDynamicActor(actorid, status, playerid, const text[], time)
{
    new Float:pos[3];
    GetDynamicActorPos(actorid, pos[0], pos[1], pos[2]);

    if(BotTalkStat[playerid] > 0) DeletePlayer3DTextLabel(playerid, BotTalk[playerid]);
    if(BotTalkTimer[playerid]) KillTimer(BotTalkTimer[playerid]), BotTalkTimer[playerid] = 0;

    BotTalkStat[playerid] = actorid;
    BotTalk[playerid] = CreatePlayer3DTextLabel(playerid, text, 0x67b2ffFF, pos[0], pos[1], pos[2] + 1.1, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true);
    if(status == 0) BotTalkTimer[playerid] = SetTimerEx("ClearDynamicTextActor", time, false, "dd", playerid, actorid);

    ApplyDynamicActorAnimation(actorid, "GANGS", talk_anims_actor[random(sizeof(talk_anims_actor))], 4.0, 0, 1, 1, 0, 0);
}

function ClearDynamicTextActor(playerid, actorid) // Удаляем текст над бошкой NPC
{
    if(BotTalkStat[playerid] > 0) DeletePlayer3DTextLabel(playerid, BotTalk[playerid]), BotTalkStat[playerid] = 0;
    if(BotTalkTimer[playerid]) KillTimer(BotTalkTimer[playerid]), BotTalkTimer[playerid] = 0;

    if(IsValidDynamicActor(actorid)) ClearDynamicActorAnimations(actorid);
    return 1;
}

stock DynamicActorfrontme(actorid, Float:distance, &Float:x, &Float:y, &Float:z, &Float:a)
{
	if(!IsValidDynamicActor(actorid)) return 0;
    GetDynamicActorPos(actorid, x,y,z);
	GetDynamicActorFacingAngle(actorid,a);
	x=x+distance*floatsin(-a,degrees);
	y=y+distance*floatcos(-a,degrees);
	return 1;
}

stock ShowSkupshikMenuInfo(playerid)
{
    new stro[1236];
    format(stro,sizeof(stro),"\n{ff9000}Информация о скупщике\
                            \n\n{cccccc}Вы можете продавать ему свои предметы за {44ff66}1/10 {cccccc}гос.стоимости\
                            \n{cccccc}А скины, аксессуары и детали тюнинга покупает за {44ff66}1/10 {cccccc}от гос.стоимости\
                            \n{cccccc}Он может купить все кроме нелегальных предметов, патронов и оружий\
                            \n{cccccc}Так же не покупает запакованные предметы\
                            \n{cccccc}Деньги с продажи он выдает на руки\
                            \n\n{ff9000}Как продать ему предмет?\
                            \n{cccccc}Откройте инвентарь, далее выберите предмет, и нажмите на кнопку мусорки.\
                            \n\n{ff4367}ВАЖНО!\
                            \n{cccccc}Предметы продаются скупщику в радиусе 3 метров от чекпоинта, если вы далеко от чекпоинта\
                            \n{cccccc}они будут выкидываться на землю и их кто-то сможет подобрать!");
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ff9000}Скупщик",stro,"*","");
    return 1;
}

stock LoadDynamicActor()
{
    CreateDynamicActor(163, -2777.3750,381.2728,6.164,182.8925, true, 100.0, 189, 0, -1, 100.0, -1, 0); // Goverment Hall (Security 1)
    CreateDynamicActor(164, -2801.6621,378.6697,6.164,181.7841, true, 100.0, 189, 0, -1, 100.0, -1, 0); // Goverment Hall (Security 2)
    CreateDynamicActor(150, -2793.0801,376.0515,6.164,270.1448, true, 100.0, 189, 0, -1, 100.0, -1, 0); // Goverment Hall (Reseption Girl)

    Hank_LoadActor();
    
    CreateDynamicActor(480, 1327.3071, 1555.0947, 1114.9565,359.1448, true, 100.0, WORLD_SKUPSHIK, INT_SKUPSHIK, -1, 100.0, -1, 0); // Скупщик

    return 1;
}

stock LoadBot()
{
	BotPears[1] = CreateDynamicActor(27, 2271.6897,2785.0352,10.8203,26.2866);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
	BotPears[2] = CreateDynamicActor(133, 1617.7690,-1895.4532,13.8599,266.8432); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ LS
	BotPears[3] = CreateDynamicActor(133, -1872.4868,-218.2040,18.6155,272.1465); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ SF
	BotPears[4] = CreateDynamicActor(133, 1034.6359,2215.3616,11.0254,359.8574); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ LV
	BotPears[5] = CreateDynamicActor(133, 992.0648,-1342.0739,13.6369,183.5969); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ LS
	BotPears[6] = CreateDynamicActor(151, 1477.2902,-1782.6528,15.3182,0.3031, true, 100.0, 197); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
	BotPears[7] = CreateDynamicActor(147, 1509.1925,-1782.7321,21.0902,1.0359, true, 100.0, 196); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ 2 пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[8] = CreateDynamicActor(10, 1474.8569,-1806.1353,21.0982,359.8061, true, 100.0, 196); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ 2 пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[9] = CreateDynamicActor(158, -56.7789,89.7783,3.1172,234.6577); // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
	BotPears[10] = CreateDynamicActor(162, -43.4430,51.2411,3.1179,252.8287); // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ (пїЅпїЅпїЅпїЅпїЅпїЅ)
	BotPears[11] = CreateDynamicActor(141, 2166.4031,2371.6714,23.6143,226.8451, true, 100.0, 243); // FBI Bot 1

	//gotobiz 8
	BotPears[12] = CreateDynamicActor(42, 1535.7311,-2181.1694,13.7505,266.9203); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[13] = CreateDynamicActor(50, 1527.0488,-2181.1238,13.7505,92.0532); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[14] = CreateDynamicActor(151, 1533.0773,-2173.0298,13.5853,268.5912); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	//gotobiz 9
	BotPears[15] = CreateDynamicActor(42, 893.1202,1903.3278,11.0516,337.5979); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[16] = CreateDynamicActor(50, 892.9305,1894.7195,11.0516,191.5832); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[17] = CreateDynamicActor(151, 884.5753,1900.7799,10.8864,359.6999); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	//gotobiz 10
	BotPears[18] = CreateDynamicActor(42, -2630.7766,1359.5754,7.2240,332.5845); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[19] = CreateDynamicActor(50, -2630.6655,1351.4535,7.2240,216.6501); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[20] = CreateDynamicActor(151, -2639.1790,1357.3517,7.1398,359.6998); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	//gotobiz 11
	BotPears[21] = CreateDynamicActor(42, -1558.8522,-2745.5351,48.7373,233.7474); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[56] = CreateDynamicActor(50, -1565.6212,-2740.8579,48.7373,59.4913); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[57] = CreateDynamicActor(151, -1555.9618,-2737.3997,48.5721,235.5593); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot

    BotPears[22] = CreateDynamicActor(348, 2190.7422,1928.0671,68.0681,0.6234, true, 100.0, WORLD_GYM_HALL, INT_GYM_HALL); // Спортзал ресепшен
    BotPears[23] = CreateDynamicActor(351, 2192.7583,1928.0481,68.0681,1.2733, true, 100.0, WORLD_GYM_HALL, INT_GYM_HALL); // Спортзал ресепшен

	BotPears[30] = CreateDynamicActor(6, 1380.1854,-5.4021,1000.9713,257.5052, true, 100.0, 219); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ Bot 1 [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]
	BotPears[31] = CreateDynamicActor(95, 995.3415,-1954.1554,12.8842,182.6652); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ Bot 2 [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ ]
	BotPears[32] = CreateDynamicActor(150, 1276.9844,-46.5174,1000.9280,358.1093, true, 100.0, 3); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1 [ пїЅпїЅпїЅпїЅпїЅ ]
	BotPears[34] = CreateDynamicActor(96, 1613.8485,-2278.8977,13.5732,347.3431); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 3
	BotPears[35] = CreateDynamicActor(97, 1614.2062,-2277.4736,13.5656,162.1847); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 4
    BotPears[36] = CreateDynamicActor(3, 1625.8187,-2295.5776,13.5372,128.6577); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 5 [ пїЅпїЅпїЅпїЅпїЅ ]
	BotPears[37] = CreateDynamicActor(199, 1733.8733,-1901.9637,916.0651,281.3157, true, 100.0, 7); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot 6
	BotPears[38] = CreateDynamicActor(188, 1743.0204,-1899.2825,916.0651,289.1492, true, 100.0, 7); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot 7
	BotPears[39] = CreateDynamicActor(185, 1744.4777,-1898.8420,916.0651,101.7975, true, 100.0, 7); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot 8
	BotPears[40] = CreateDynamicActor(71, 1743.6726,-1895.4208,913.6010,357.6015, true, 100.0, 7); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot 9
	BotPears[45] = CreateDynamicActor(151, 607.0654,-1538.5491,15.3926,268.8089, true, 100.0, 220); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1 [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]
	BotPears[46] = CreateDynamicActor(159, -22.4602,66.8220,3.1172,184.2081); // Френк на ферме
    BotPears[47] = CreateDynamicActor(262,-338.6107,1729.5956,42.8917,4.2150); // Брюс археология
    BotPears[48] = CreateDynamicActor(133, -2059.5835,-87.3367,35.4489,1.8462); // Автобусное депо SF
	BotPears[49] = CreateDynamicActor(308, 1391.5339,-13.7709,1000.9217,1.1784, true, 100.0, 5); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 2
	BotPears[50] = CreateDynamicActor(16, 1385.5522,-18.7329,1000.9110,178.9046, true, 100.0, 193); // IKEA Bot (Pavilion 2)
	BotPears[51] = CreateDynamicActor(308, 1163.3939,-1315.3433,898.0944,90.6377, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 4
	BotPears[52] = CreateDynamicActor(250, 1161.7295,-1315.5109,898.0944,274.2293, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 5
	BotPears[53] = CreateDynamicActor(259, 1150.3359,-1297.2848,898.7470,180.6266, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 6
	BotPears[54] = CreateDynamicActor(229, 1153.5736,-1302.8451,898.7470,275.0858, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 7
	BotPears[55] = CreateDynamicActor(170, 1385.4244,-17.7351,1000.9110,355.9396, true, 100.0, 193); // IKEA Bot (Pavilion 2)

	BotPears[58] = CreateDynamicActor(111, -1978.7440,1125.3831,52.5381,237.8730); // Russian Mafia Bot 1
	BotPears[59] = CreateDynamicActor(125, -2002.7351,1131.1342,53.2815,188.2334); // Russian Mafia Bot 2
	BotPears[60] = CreateDynamicActor(126, -2010.2117,1110.2968,53.2891,197.0067); // Russian Mafia Bot 3
	BotPears[61] = CreateDynamicActor(112, -2009.2338,1108.3409,53.2891,35.0118); // Russian Mafia Bot 4
	BotPears[62] = CreateDynamicActor(192, -2002.4238,1104.6166,53.2891,354.5681); // Russian Mafia Bot 5
	//gotobiz 12
	BotPears[69] = CreateDynamicActor(42, 64.2792,-190.6612,1.8092,268.1631); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[70] = CreateDynamicActor(50, 55.8918,-190.3604,1.8092,89.1813); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[71] = CreateDynamicActor(151, 61.9165,-182.6632,1.6440,269.1813); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[72] = CreateDynamicActor(16, 1385.5709,-12.5325,1000.9110,177.0246, true, 100.0, 193); // IKEA Bot (Pavilion 2)
    BotPears[73] = CreateDynamicActor(6, 1385.5596,-14.3427,1000.9110,183.9181, true, 100.0, 192); // IKEA Bot (Pavilion 3)
    BotPears[74] = CreateDynamicActor(6, 1385.5792,-13.3454,1000.9110,0.9531, true, 100.0, 192); // IKEA Bot (Pavilion 3)
    BotPears[75] = CreateDynamicActor(133, 1063.9913,2306.4170,11.0953,270.3401); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ LV

	BotPears[77] = CreateDynamicActor(96, 1758.0946,1420.9188,10.8965,105.2076); // aero lv talk 1
	BotPears[78] = CreateDynamicActor(97, 1756.4376,1420.4808,10.8965,280.8209); // aero lv talk 2
	BotPears[80] = CreateDynamicActor(3, 1736.7946,1408.7692,10.8467,43.5901); // aero lv money

	BotPears[81] = CreateDynamicActor(150, 1276.9844,-46.5174,1000.9280,358.1093, true, 100.0, 6); // hotel lv girl reception 1
	BotPears[82] = CreateDynamicActor(141,1274.4423,-46.8282,1000.9280,20.3795, true, 100.0, 6); // hotel lv girl reception 2
	BotPears[83] = CreateDynamicActor(43,1273.9204,-45.3367,1000.9280,204.5977, true, 100.0, 6); // hotel lv people 1
	BotPears[84] = CreateDynamicActor(164,1265.6527,-49.2240,1000.9280,1.3875, true, 100.0, 6); // hotel lv security right
	BotPears[85] = CreateDynamicActor(164,1288.0977,-49.1689,1000.9280,7.3408, true, 100.0, 6); // hotel lv security left
	BotPears[86] = CreateDynamicActor(189,1280.3707,-47.6048,1000.9280,314.8688, true, 100.0, 6); // hotel lv boy reception
	BotPears[87] = CreateDynamicActor(163,1280.0337,-37.1167,1000.9280,181.2190, true, 100.0, 6); // hotel lv security entrance
	BotPears[88] = CreateDynamicActor(59,1283.0580,-42.2432,1000.9280,15.6561, true, 100.0, 6); // hotel lv boy talk 1
	BotPears[89] = CreateDynamicActor(98,1282.6345,-40.7867,1000.9280,194.8844, true, 100.0, 6); // hotel lv boy talk 2

    BotPears[95] = CreateDynamicActor(155, 1593.5620,1445.5161,10.8726,91.1705, true, 100.0, 183); // aero lv
	BotPears[96] = CreateDynamicActor(71, 1570.0636,1425.1440,10.8726,0.6398, true, 100.0, 183); // aero lv
	BotPears[97] = CreateDynamicActor(71, 1591.9197,1435.1173,10.8726,181.1216, true, 100.0, 183); // aero lv
	BotPears[98] = CreateDynamicActor(150, 1582.9110,1421.4177,10.8726,0.6164, true, 100.0, 183); // aero lv
	BotPears[99] = CreateDynamicActor(150, 1578.4772,1421.4210,10.8726,359.9897, true, 100.0, 183); // aero lv
	BotPears[107] = CreateDynamicActor(150, 1574.1418,1421.4066,10.8726,359.0497, true, 100.0, 183); // aero lv

	BotPears[100] = CreateDynamicActor(68, 1327.8085,1585.8474,11.0259,271.6756, true, 100.0, 195); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1 [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]
	BotPears[103] = CreateDynamicActor(161, 2464.3816,-892.4882,99.8227,330.8747); // Hunter
	BotPears[105] = CreateDynamicActor(40, 1776.7781,-1875.1967,13.5607,87.0187); // Sex Bot 1
	BotPears[106] = CreateDynamicActor(37, 1775.8397,-1875.1381,13.5608,268.5027); // Sex Bot 2
	BotPears[110] = CreateDynamicActor(276, 1154.4517,-1302.5990,898.1036,106.8008, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 8
	BotPears[111] = CreateDynamicActor(15, 1171.6820,-1297.7162,898.7470,92.0739, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 8
	BotPears[112] = CreateDynamicActor(32, 1168.5963,-1303.1786,898.7470,2.3148, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 10
	BotPears[113] = CreateDynamicActor(34, 1150.8004,-1305.3921,898.7470,92.7241, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 11
	BotPears[114] = CreateDynamicActor(44, 1147.5684,-1311.3845,898.7470,0.7715, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 12
	BotPears[115] = CreateDynamicActor(54, 1168.3097,-1310.6511,898.7470,275.4225, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 13
	BotPears[116] = CreateDynamicActor(58, 1150.9082,-1328.6205,898.0944,186.1451, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 14
	BotPears[117] = CreateDynamicActor(275, 1150.9603,-1329.8462,898.0944,9.4234, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 15
	BotPears[118] = CreateDynamicActor(71, 1162.4762,-1328.9657,898.0944,4.3867, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 16
	BotPears[119] = CreateDynamicActor(275, 1138.6152,-1349.8079,898.0916,181.7350, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 17
	BotPears[120] = CreateDynamicActor(276, 1138.5537,-1351.0946,898.0916,357.1800, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 18
	BotPears[121] = CreateDynamicActor(252, 1156.0387,-1382.1033,898.8210,96.7777, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 19
	BotPears[122] = CreateDynamicActor(70, 1118.0420,-1362.3555,898.0916,274.5060, true, 100.0, 1); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 20

	// LSPD Актеры
	//148
	BotPears[149] = CreateDynamicActor(440, 1580.1194,-1634.3180,13.5624,2.8671); // LSPD Bot 2
	//150
	BotPears[151] = CreateDynamicActor(442, 1545.1991,-1669.5962,13.5599,20.7507); // LSPD Bot 4
	BotPears[152] = CreateDynamicActor(259, 1544.4688,-1668.0896,13.5585,205.2824); // LSPD Bot 5
	BotPears[153] = CreateDynamicActor(441, 1545.0980,-1683.7576,13.5563,0.9871); // LSPD Bot 6
	BotPears[154] = CreateDynamicActor(443, 1549.5330,-1680.2131,13.5564,193.9789); // LSPD Bot 7
	BotPears[155] = CreateDynamicActor(444, 1550.4847,-1682.5118,13.5545,18.5106); // LSPD Bot 8
	// пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[156] = CreateDynamicActor(300, 1556.1638,-1660.8695,16.2218,136.1330, true, 100.0, 255); // LSPD Bot 9 ((154))
	BotPears[157] = CreateDynamicActor(415, 1554.9736,-1661.7855,16.2218,309.0712, true, 100.0, 255); // LSPD Bot 10 ((144))

	BotPears[197] = CreateDynamicActor(141, 1384.8610,1588.3568,10.8484,184.8581, true, 100.0, 230); // NASA Bot 1
	BotPears[204] = CreateDynamicActor(36, -337.9493,1725.6622,42.8531,270.0621); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	// fill bots 50 справа, 42 слева, 151 kassa
	//gotobiz 1
	BotPears[207] = CreateDynamicActor(42, 1934.9749,-1779.5398,13.7258,327.5147);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[208] = CreateDynamicActor(50, 1934.4780,-1787.4510,13.7258,192.4313);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot ls2
	BotPears[209] = CreateDynamicActor(151, 1926.0579,-1781.8629,13.5606,358.2216);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 3
	//gotobiz 3
	BotPears[219] = CreateDynamicActor(42, -1675.1141,421.4946,7.3641,297.0783);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 4
	BotPears[220] = CreateDynamicActor(50, -1680.8055,415.6465,7.3641,158.2703);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 5
	BotPears[221] = CreateDynamicActor(151, -1682.5594,425.5037,7.1989,316.5287);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 6

	BotPears[226] = CreateDynamicActor(37, -2230.7534,251.7373,894.7211,4.7700, true, 100.0, 77); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ Bot 1 Ледовый
	//gotobiz 4
	BotPears[227] = CreateDynamicActor(42, -2105.4768,-0.9047,35.5099,339.2878);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 7 sf-2
	BotPears[228] = CreateDynamicActor(50, -2105.5925,-8.6365,35.5099,199.8531);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 8 sf-2
	BotPears[229] = CreateDynamicActor(151, -2113.7688,-3.1075,35.3447,358.4013);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 9 sf-2
	//gotobiz 2
	BotPears[230] = CreateDynamicActor(42, -85.7890,-1176.9122,2.8050,152.9876);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 10 ls-2
	BotPears[231] = CreateDynamicActor(50, -82.8375,-1169.9406,2.8050,9.4796);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 11 ls-2
	BotPears[232] = CreateDynamicActor(151, -77.7439,-1178.6635,2.6398,153.0467);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 12 ls-2
	//gotobiz 5
	BotPears[233] = CreateDynamicActor(42, 2113.4683,941.9081,11.0156,2.3508);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 13 lv-1
	BotPears[234] = CreateDynamicActor(50, 2113.3262,933.7612,11.0156,178.7060);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 14 lv-1
	BotPears[235] = CreateDynamicActor(151, 2105.3967,939.7891,10.8504,0.1524);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 15 lv-1
	//gotobiz 6
	BotPears[236] = CreateDynamicActor(42, 2250.1785,2391.5908,11.0000,56.4122);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 16 lv-2
	BotPears[237] = CreateDynamicActor(50, 2258.2874,2391.3408,11.0000,284.2471);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 17 lv-2
	BotPears[238] = CreateDynamicActor(151, 2252.6345,2383.2349,10.8348,90.0646);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 18 lv-2
	//gotobiz 7
    BotPears[490] = CreateDynamicActor(42, 2811.1558,1993.9091,11.0080,314.1533);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ LV-3 Bot 1
	BotPears[491] = CreateDynamicActor(50, 2805.9856,1986.8063,11.0080,135.4203);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ LV-3 Bot 2
	BotPears[492] = CreateDynamicActor(151, 2804.1641,1997.2927,10.8429,314.0154);// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ LV-3 Bot 3
	BotPears[240] = CreateDynamicActor(155, 1717.9539,-2410.4026,13.5767,180.5654, true, 100.0, 198); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	BotPears[241] = CreateDynamicActor(71, 1728.6202,-2411.7305,13.5767,271.0727, true, 100.0, 198); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	BotPears[242] = CreateDynamicActor(71, 1738.4613,-2433.9980,13.5767,89.8428, true, 100.0, 198); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	BotPears[243] = CreateDynamicActor(150, 1742.0760,-2421.0786,13.5767,91.7972, true, 100.0, 198); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	BotPears[244] = CreateDynamicActor(150, 1742.0778,-2425.4563,13.5767,91.7972, true, 100.0, 198); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	BotPears[245] = CreateDynamicActor(150, 1742.0760,-2429.7825,13.5767,89.8938, true, 100.0, 198); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	BotPears[250] = CreateDynamicActor(199, -35.4461,77.0759,3.1331,13.4866, true, 100.0, 228); // Ферма в Интерьере

    BotPears[313] = CreateDynamicActor(147,-2046.6985,-988.4554,1651.6968,30.9710, true, 100.0, 7); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[314] = CreateDynamicActor(187,-2047.6536,-987.2053,1651.6968,215.5261, true, 100.0, 7); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[315] = CreateDynamicActor(164,-2000.2031,161.7839,1666.0313,93.0917, true, 100.0, 7); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[323] = CreateDynamicActor(202,1382.5847,-21.8886,1001.0793,94.5528, true, 100.0, 11); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ ]
    BotPears[324] = CreateDynamicActor(206,1377.6793,-15.4435,1001.0717,220.1772, true, 100.0, 11); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[325] = CreateDynamicActor(261,1378.6981,-16.7620,1001.0717,38.1523, true, 100.0, 11); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[350] = CreateDynamicActor(16,2532.5154,2800.9751,10.8203,125.0607); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[351] = CreateDynamicActor(27,2517.1875,2829.1831,10.8203,246.0552); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[352] = CreateDynamicActor(153,2518.6653,2828.4517,10.8203,58.7035); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[368] = CreateDynamicActor(208,-1456.3763,916.2051,7.3453,3.4842); // Triada Mafia Bot
    BotPears[369] = CreateDynamicActor(210,-1456.4972,917.7109,7.3453,182.3992); // Triada Mafia Bot
    BotPears[370] = CreateDynamicActor(120,-1500.5579,932.4845,7.3453,184.8825); // Triada Mafia Bot
    BotPears[371] = CreateDynamicActor(186,-1492.5112,917.4147,7.3453,77.4082); // Triada Mafia Bot
    BotPears[372] = CreateDynamicActor(118,-1494.8196,918.6791,7.3453,240.3431); // Triada Mafia Bot
    BotPears[373] = CreateDynamicActor(117,-1452.9584,929.5131,7.3793,99.3419); // Triada Mafia Bot
    BotPears[376] = CreateDynamicActor(194,2211.8379,1029.4117,994.4688,182.3280, true, 100.0, 2001); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot пїЅпїЅпїЅпїЅпїЅ
    BotPears[377] = CreateDynamicActor(172,2216.7393,1029.4164,994.4688,180.7613, true, 100.0, 2001); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot пїЅпїЅпїЅпїЅпїЅ
    BotPears[378] = CreateDynamicActor(171,2221.4226,1029.4115,994.4688,180.4480, true, 100.0, 2001); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot пїЅпїЅпїЅпїЅпїЅ
    BotPears[379] = CreateDynamicActor(172,2183.0564,1013.2817,992.4688,180.3346, true, 100.0, 2001); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot пїЅпїЅпїЅпїЅпїЅпїЅпїЅ [0]
    BotPears[380] = CreateDynamicActor(172,2183.0564,1019.2822,992.4688,177.8512, true, 100.0, 2001); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot пїЅпїЅпїЅпїЅпїЅпїЅпїЅ [1]
    BotPears[381] = CreateDynamicActor(172,2183.0564,1025.2816,992.4688,174.0912, true, 100.0, 2001); // пїЅпїЅпїЅпїЅпїЅпїЅ Bot пїЅпїЅпїЅпїЅпїЅпїЅпїЅ [2]
    BotPears[382] = CreateDynamicActor(171,2171.3940,1014.0906,992.4688,106.5708, true, 100.0, 2001); // пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[383] = CreateDynamicActor(171,2171.5842,1022.4432,992.4688,83.6973, true, 100.0, 2001); // пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[384] = CreateDynamicActor(163,2201.9219,1007.3365,994.4688,91.9738, true, 100.0, 2001); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ otb пїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[385] = CreateDynamicActor(171,2176.9482,1020.9529,992.4688,277.3156, true, 100.0, 2001); // пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
    BotPears[386] = CreateDynamicActor(171,2176.8618,1014.8093,992.4688,270.7356, true, 100.0, 2001); // пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[387] = CreateDynamicActor(171,2171.0869,1018.0458,992.4688,95.1071, true, 100.0, 2001); // пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[388] = CreateDynamicActor(163,2170.4785,998.8090,992.4688,358.4547, true, 100.0, 2001); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ otb пїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[391] = CreateDynamicActor(164,2242.9587,1021.4113,996.8750,89.6121, true, 100.0, 2001); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ otb пїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[392] = CreateDynamicActor(163,2243.1431,1014.8881,996.8818,90.8655, true, 100.0, 2001); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ otb пїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[399] = CreateDynamicActor(300,-1589.6486,709.7194,13.8918,138.6395, true, 100.0, 209); // Bot SFPD
	BotPears[400] = CreateDynamicActor(301,-1590.7100,708.5793,13.8918,309.8895, true, 100.0, 209); // Bot SFPD
	BotPears[406] = CreateDynamicActor(281,-1617.9553,685.4202,7.1875,94.6019); // Bot SFPD
	BotPears[407] = CreateDynamicActor(210,-1611.9543,715.0781,13.1420,328.2543); // Bot SFPD
	BotPears[408] = CreateDynamicActor(267,-1611.1908,716.0125,12.9967,137.1425); // Bot SFPD
	BotPears[409] = CreateDynamicActor(288,-1591.9323,718.3911,9.5872,117.7156); // Bot SFPD
	BotPears[410] = CreateDynamicActor(265,-1593.4348,717.3204,9.8826,335.7743); // Bot SFPD
	BotPears[411] = CreateDynamicActor(71, 1402.2173,3.8803,1000.9217,92.9859, true, 100.0, 5); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 21
	BotPears[412] = CreateDynamicActor(71, 1376.4246,-6.3177,1000.9267,182.4317, true, 100.0, 5); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 22
	BotPears[413] = CreateDynamicActor(71, 1395.8878,-16.0300,1000.9217,271.3257, true, 100.0, 5); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 23
	BotPears[414] = CreateDynamicActor(274, 1400.1345,-21.4354,1000.9217,253.0776, true, 100.0, 5); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 24
	BotPears[415] = CreateDynamicActor(272, 1401.3024,-21.7337,1000.9217,71.9927, true, 100.0, 5); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 25
	BotPears[416] = CreateDynamicActor(70, 1377.5765,-21.8737,1000.9217,51.2186, true, 100.0, 6); // Доктор мз Bot 26
	BotPears[417] = CreateDynamicActor(276, 1386.7156,-13.8015,1000.9217,9.9520, true, 100.0, 5); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 27
	BotPears[418] = CreateDynamicActor(259, 1386.1909,-12.0045,1000.9219,195.7369, true, 100.0, 5); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 28
	BotPears[419] = CreateDynamicActor(308, 1218.2460,-1352.8877,2001.0491,178.0994, true, 100.0, 4); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 1
	BotPears[420] = CreateDynamicActor(71, 1211.5765,-1357.6942,2001.0449,271.6186, true, 100.0, 4); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 2
	BotPears[421] = CreateDynamicActor(291, 1226.6830,-1361.0850,2001.0491,78.6269, true, 100.0, 4); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 3
	BotPears[422] = CreateDynamicActor(70, 1225.1354,-1360.9229,2001.0491,258.0002, true, 100.0, 4); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 4
	BotPears[423] = CreateDynamicActor(308, 1219.8785,-1350.2245,2001.0491,357.6178, true, 100.0, 4); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 5
	BotPears[424] = CreateDynamicActor(70, 1226.2745,-1411.0952,2001.0491,89.4486, true, 100.0, 4); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 6
	BotPears[425] = CreateDynamicActor(71, 1218.0801,-1410.1809,2001.0491,183.2813, true, 100.0, 4); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 7
	BotPears[426] = CreateDynamicActor(70, 1223.8677,-1442.9573,2001.0491,1.4010, true, 100.0, 4); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot 8
	BotPears[427] = CreateDynamicActor(279, -2143.6426,78.1282,35.1633,184.4606); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 1
	BotPears[428] = CreateDynamicActor(277, -2145.6177,64.1148,35.1633,68.6711); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 2
	BotPears[429] = CreateDynamicActor(278, -2147.5535,64.6648,35.1633,252.2863); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 3
	BotPears[430] = CreateDynamicActor(219, -2128.9646,66.1872,1403.3984,186.8929, true, 100.0, 4); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 4
	BotPears[431] = CreateDynamicActor(277, -2128.8323,69.6934,1403.3984,358.9144, true, 100.0, 4); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 5
	BotPears[432] = CreateDynamicActor(279, -2120.2576,60.6968,1403.3984,147.1225, true, 100.0, 4); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 6
	BotPears[433] = CreateDynamicActor(304, -2120.9204,59.4988,1403.3984,328.5442, true, 100.0, 4); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ Bot 7
	BotPears[434] = CreateDynamicActor(124, 1279.9063,-2049.4492,59.1290,88.8323); // Cosa Nostra Bot 1
	BotPears[435] = CreateDynamicActor(126, 1241.1165,-2049.7031,60.0028,342.2980); // Cosa Nostra Bot 2
	BotPears[436] = CreateDynamicActor(127, 1241.4069,-2048.6489,60.0191,159.9596); // Cosa Nostra Bot 3
	BotPears[437] = CreateDynamicActor(185, 1241.6699,-2035.7485,60.0329,267.0973); // Cosa Nostra Bot 4
	BotPears[438] = CreateDynamicActor(124, 1169.9761,-2028.0551,69.0000,132.3627); // Cosa Nostra Bot 5
	BotPears[439] = CreateDynamicActor(126, 1168.9500,-2028.9075,69.0000,308.7710); // Cosa Nostra Bot 6
	BotPears[440] = CreateDynamicActor(127, 1140.0459,-2041.6765,69.0000,358.9048); // Cosa Nostra Bot 7
	BotPears[441] = CreateDynamicActor(185, 1126.5526,-2033.9010,69.8845,274.3040); // Cosa Nostra Bot 8
	BotPears[442] = CreateDynamicActor(124, -1492.2446,1971.3748,1357.0326,87.5192, true, 100.0, 5); // Cosa Nostra Bot 9
	BotPears[443] = CreateDynamicActor(126, -1494.9949,1980.3163,1357.0326,227.7253, true, 100.0, 5); // Cosa Nostra Bot 10
	BotPears[444] = CreateDynamicActor(127, -1493.5272,1979.2655,1357.0326,54.4502, true, 100.0, 5); // Cosa Nostra Bot 11
	BotPears[445] = CreateDynamicActor(185, -1502.3109,1985.2120,1357.0447,81.3738, true, 100.0, 5); // Cosa Nostra Bot 12
	BotPears[470] = CreateDynamicActor(171,1264.6343,1306.6207,1558.2009,275.2307, true, 100.0, 85); // пїЅпїЅпїЅпїЅпїЅ Bot 1 пїЅ пїЅпїЅпїЅпїЅ
	BotPears[471] = CreateDynamicActor(11,1309.7184,1314.3702,1558.2090,272.7471, true, 100.0, 85); // пїЅпїЅпїЅпїЅпїЅ Bot 1 пїЅ пїЅпїЅпїЅпїЅ

	BotPears[475] = CreateDynamicActor(164,1265.6527,-49.2240,1000.9280,1.3875, true, 100.0, 3); // пїЅпїЅпїЅпїЅпїЅ Bot 1
	BotPears[476] = CreateDynamicActor(164,1288.0977,-49.1689,1000.9280,7.3408, true, 100.0, 3); // пїЅпїЅпїЅпїЅпїЅ Bot 2
	BotPears[477] = CreateDynamicActor(163,1280.0337,-37.1167,1000.9280,181.2190, true, 100.0, 3); // пїЅпїЅпїЅпїЅпїЅ Bot 3
	BotPears[478] = CreateDynamicActor(189,1280.3707,-47.6048,1000.9280,314.8688, true, 100.0, 3); // пїЅпїЅпїЅпїЅпїЅ Bot 4
	BotPears[479] = CreateDynamicActor(59,1283.0580,-42.2432,1000.9280,15.6561, true, 100.0, 3); // пїЅпїЅпїЅпїЅпїЅ Bot 5
	BotPears[480] = CreateDynamicActor(98,1282.6345,-40.7867,1000.9280,194.8844, true, 100.0, 3); // пїЅпїЅпїЅпїЅпїЅ Bot 6
	BotPears[481] = CreateDynamicActor(141,1274.4423,-46.8282,1000.9280,20.3795, true, 100.0, 3); // пїЅпїЅпїЅпїЅпїЅ Bot 7
	BotPears[482] = CreateDynamicActor(43,1273.9204,-45.3367,1000.9280,204.5977, true, 100.0, 3); // пїЅпїЅпїЅпїЅпїЅ Bot 8
	BotPears[483] = CreateDynamicActor(70,1178.8080,-1338.3379,13.8725,272.0269); // ASGH Bot 1
	BotPears[484] = CreateDynamicActor(70,2014.5818,-1410.8331,16.9922,153.8991); // ASGH Bot 2
	BotPears[489] = CreateDynamicActor(167, 368.9441,-4.4851,1001.8516,181.6134, true, 100.0, 7); // Cluckin Bell LV-2 Bot
	BotPears[493] = CreateDynamicActor(71, 1382.2180,-30.1561,1000.9110,359.8083, true, 100.0, 194); // IKEA Bot 1
    BotPears[494] = CreateDynamicActor(71, 1377.0071,-13.0329,1000.9110,270.8442, true, 100.0, 194); // IKEA Bot 2
    BotPears[495] = CreateDynamicActor(69, 1385.6508,-12.3937,1000.9110,181.3256, true, 100.0, 194); // IKEA Bot 3
    BotPears[496] = CreateDynamicActor(151, 1385.8430,-17.9771,1000.9110,349.6602, true, 100.0, 194); // IKEA Bot 4
    BotPears[498] = CreateDynamicActor(96, 1377.2981,-23.9866,1000.9110,90.2411, true, 100.0, 194); // IKEA Bot 6
    BotPears[501] = CreateDynamicActor(71,1369.7183,-25.3327,1001.0717,2.6003, true, 100.0, 11); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	BotPears[502] = CreateDynamicActor(141,1631.0111,-2274.5208,13.5732,179.4451); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Bot
	// пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[507] = CreateDynamicActor(141,1274.8622,-21.0276,1000.9254,89.6971, true, 100.0, 100); // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[508] = CreateDynamicActor(150,1274.8622,-23.4229,1000.9254,87.1905, true, 100.0, 100); // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[509] = CreateDynamicActor(71,1255.7573,-24.2271,1000.9254,271.5772, true, 100.0, 100); // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ Bot
    BotPears[510] = CreateDynamicActor(71,1394.2056,-31.3340,1000.8779,335.8245, true, 100.0, 237); // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
    BotPears[511] = CreateDynamicActor(59,1400.3665,-30.2018,1000.8779,297.4525, true, 100.0, 237); // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
    BotPears[512] = CreateDynamicActor(147,1401.7723,-29.2993,1000.8779,122.6343, true, 100.0, 237); // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
    BotPears[513] = CreateDynamicActor(141,-1753.0793,885.3437,105.0207,182.7715, true, 100.0, 236); // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
    BotPears[514] = CreateDynamicActor(71,-1766.3875,890.2181,105.0248,270.9872, true, 100.0, 236); // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
    BotPears[515] = CreateDynamicActor(71,-1739.9305,877.7605,105.0148,91.1557, true, 100.0, 236); // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
    BotPears[516] = CreateDynamicActor(45, 565.910583,-1809.059204,6.062500,97.0); // пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
    BotPears[517] = CreateDynamicActor(140, 564.8656,-1809.2654,6.0625,280.8233); // пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	BotPears[518] = CreateDynamicActor(71, 767.5626,-1334.1028,13.7976,90.0000); // Electrician bot work
	BotPears[519] = CreateDynamicActor(71, 1089.5840,-1213.9564,18.0118,183.9828); // collector bot work

    BotPears[520] = CreateDynamicActor(442,1570.5031,-1649.5078,21.2318,100.8627, .worldid = 256); // LSPD Bot 11
    BotPears[521] = CreateDynamicActor(443,1569.3571,-1649.6467,21.2318,269.8762, .worldid = 256); // LSPD Bot 12
    BotPears[522] = CreateDynamicActor(422,1580.5566,-1694.6251,6.2187,306.7073); // LSPD Bot 13
    BotPears[523] = CreateDynamicActor(419,1581.6965,-1693.7367,6.2187,123.5138); // LSPD Bot 14
    

    BotPears[524] = CreateDynamicActor(657, 3261.6216,-340.3169,8.4405,245.5138); // Йольский Парень
    BotPears[525] = CreateDynamicActor(508, 3264.2461,-336.4369,8.4471,165.9117); // Овечка
    BotPears[526] = CreateDynamicActor(657, 3271.8430,-326.0200,8.3832,215.6650); // Йольский Парень
    BotPears[526] = CreateDynamicActor(657, 3289.9795,-321.6499,8.5798,181.9233); // Йольский Парень 

	LoadAnimBot();

	CreateDynamicActor(141, 1760.1196,1404.7627,10.9041,87.1673, true, 100.0, 0, 0, -1, 100.0, -1, 0); // aero lv girl
	return 1;
}
stock LoadAnimBot()
{
    ApplyDynamicActorAnimation(BotPears[7],"PED","SEAT_idle",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[8],"PED","SEAT_idle",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[12],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[13],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[14],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[15],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[16],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[17],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[18],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[19],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[20],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[21],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot

    ApplyDynamicActorAnimation(BotPears[22],"PED","SEAT_idle",4.1,1,0,0,0,0); // Спортзал
    ApplyDynamicActorAnimation(BotPears[23],"PED","SEAT_idle",4.1,1,0,0,0,0); // Спортзал

    ApplyDynamicActorAnimation(BotPears[34],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Вокзал Bot 3
    ApplyDynamicActorAnimation(BotPears[35],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Вокзал Bot 4
    ApplyDynamicActorAnimation(BotPears[37],"PED","woman_idlestance",4.1,1,0,0,0,0); // Вокзал Bot 6
    ApplyDynamicActorAnimation(BotPears[38],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Вокзал Bot 7
    ApplyDynamicActorAnimation(BotPears[39],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Вокзал Bot 8
    ApplyDynamicActorAnimation(BotPears[40],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Вокзал Bot 9
    ApplyDynamicActorAnimation(BotPears[45],"PED","woman_idlestance",4.1,1,0,0,0,0); // Спермобанк Bot 1
    ApplyDynamicActorAnimation(BotPears[49],"PED","woman_idlestance",4.1,1,0,0,0,0); // Госпиталь Bot 2
    ApplyDynamicActorAnimation(BotPears[51],"PED","woman_idlestance",4.1,0,1,1,1,1); // Госпиталь Bot 4
    ApplyDynamicActorAnimation(BotPears[52],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Госпиталь Bot 5
    ApplyDynamicActorAnimation(BotPears[53],"CRACK","crckdeth1",4.1,0,1,1,1,1); // Госпиталь Bot 6
    ApplyDynamicActorAnimation(BotPears[54],"CRACK","crckidle2",4.1,0,1,1,1,1); // Госпиталь Bot 7
    ApplyDynamicActorAnimation(BotPears[56],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[57],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[58],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Russian Mafia Bot 1 [ Разговаривает ]
    ApplyDynamicActorAnimation(BotPears[59],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0); // Russian Mafia Bot 2
    ApplyDynamicActorAnimation(BotPears[60],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Russian Mafia Bot 3
    ApplyDynamicActorAnimation(BotPears[61],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Russian Mafia Bot 4
    ApplyDynamicActorAnimation(BotPears[62],"SMOKING","M_smk_loop",4.1,1,0,0,0,0); // Russian Mafia Bot 5
    ApplyDynamicActorAnimation(BotPears[69],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[70],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[71],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправка Bot
    ApplyDynamicActorAnimation(BotPears[77],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // aero lv talk 1
    ApplyDynamicActorAnimation(BotPears[78],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // aero lv talk 2
    ApplyDynamicActorAnimation(BotPears[83],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[84],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[85],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[86],"BD_FIRE","wash_up",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[87],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[88],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[89],"PED","IDLE_CHAT",4.1,1,0,0,0,0);

    ApplyDynamicActorAnimation(BotPears[96],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Аэропорт lv security 1
    ApplyDynamicActorAnimation(BotPears[97],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Аэропорт lv security 2

    ApplyDynamicActorAnimation(BotPears[105],"BLOWJOBZ","BJ_STAND_LOOP_W",4,1,0,0,1,0); // Sex Bot 1
    ApplyDynamicActorAnimation(BotPears[106],"BLOWJOBZ","BJ_STAND_LOOP_P",4,1,0,0,1,0); // Sex Bot 2
    ApplyDynamicActorAnimation(BotPears[110],"BD_FIRE","wash_up",4.1,1,0,0,0,0);// Госпиталь Bot 8
    ApplyDynamicActorAnimation(BotPears[111],"CRACK","crckidle2",4.1,0,1,1,1,1);// Госпиталь Bot 9
    ApplyDynamicActorAnimation(BotPears[112],"CRACK","crckidle1",4.1,0,1,1,1,1);// Госпиталь Bot 10
    ApplyDynamicActorAnimation(BotPears[113],"CRACK","crckidle2",4.1,0,1,1,1,1);// Госпиталь Bot 11
    ApplyDynamicActorAnimation(BotPears[114],"CRACK","crckidle1",4.1,0,1,1,1,1);// Госпиталь Bot 12
    ApplyDynamicActorAnimation(BotPears[115],"CRACK","crckidle2",4.1,0,1,1,1,1);// Госпиталь Bot 13
    ApplyDynamicActorAnimation(BotPears[116],"PED","IDLE_CHAT",4.1,1,0,0,0,0);// Госпиталь Bot 14
    ApplyDynamicActorAnimation(BotPears[117],"PED","IDLE_CHAT",4.1,1,0,0,0,0);// Госпиталь Bot 15
    ApplyDynamicActorAnimation(BotPears[118],"OTB","wtchrace_loop",4.1,1,0,0,0,0);// Госпиталь Bot 16
    ApplyDynamicActorAnimation(BotPears[119],"PED","IDLE_CHAT",4.1,1,0,0,0,0);// Госпиталь Bot 17
    ApplyDynamicActorAnimation(BotPears[120],"PED","IDLE_CHAT",4.1,1,0,0,0,0);// Госпиталь Bot 18
    ApplyDynamicActorAnimation(BotPears[121],"CRACK","crckidle1",4.1,1,0,0,0,0);// Госпиталь Bot 19
    ApplyDynamicActorAnimation(BotPears[122],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Госпиталь Bot 20
    ApplyDynamicActorAnimation(BotPears[151],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 4
    ApplyDynamicActorAnimation(BotPears[152],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 5
    ApplyDynamicActorAnimation(BotPears[153],"SMOKING","M_smk_drag",4.1,1,0,0,0,0); // LSPD Bot 6
    ApplyDynamicActorAnimation(BotPears[154],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 7
    ApplyDynamicActorAnimation(BotPears[155],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 8
    ApplyDynamicActorAnimation(BotPears[156],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 9
    ApplyDynamicActorAnimation(BotPears[157],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 10

    ApplyDynamicActorAnimation(BotPears[204],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Археология Bot 1
    ApplyDynamicActorAnimation(BotPears[207],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 1
    ApplyDynamicActorAnimation(BotPears[208],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 2
    ApplyDynamicActorAnimation(BotPears[209],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 3
    ApplyDynamicActorAnimation(BotPears[219],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 4
    ApplyDynamicActorAnimation(BotPears[220],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 5
    ApplyDynamicActorAnimation(BotPears[221],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 6
    ApplyDynamicActorAnimation(BotPears[227],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 7
    ApplyDynamicActorAnimation(BotPears[228],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 8
    ApplyDynamicActorAnimation(BotPears[229],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 9
    ApplyDynamicActorAnimation(BotPears[230],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 10
    ApplyDynamicActorAnimation(BotPears[231],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 11
    ApplyDynamicActorAnimation(BotPears[232],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 12
    ApplyDynamicActorAnimation(BotPears[233],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 13
    ApplyDynamicActorAnimation(BotPears[234],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 14
    ApplyDynamicActorAnimation(BotPears[235],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 15
    ApplyDynamicActorAnimation(BotPears[236],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 16
    ApplyDynamicActorAnimation(BotPears[237],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0); // Заправщик Bot 17
    ApplyDynamicActorAnimation(BotPears[238],"PED","woman_idlestance",4.1,1,0,0,0,0); // Заправщик Bot 18
    ApplyDynamicActorAnimation(BotPears[241],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Аэропорт Bot 1
    ApplyDynamicActorAnimation(BotPears[242],"OTB","wtchrace_loop",4.1,1,0,0,0,0); // Аэропорт Bot 1
    ApplyDynamicActorAnimation(BotPears[313],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Правительство Bot
    ApplyDynamicActorAnimation(BotPears[314],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Правительство Bot
    ApplyDynamicActorAnimation(BotPears[315],"DEALER","DEALER_IDLE",4.1,0,1,1,1,1); // Правительство Bot
    ApplyDynamicActorAnimation(BotPears[324],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Дальнобойщики Bot
    ApplyDynamicActorAnimation(BotPears[325],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // Дальнобойщики Bot
    ApplyDynamicActorAnimation(BotPears[350],"SMOKING","M_smk_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[351],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[352],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[368],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[369],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[370],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[371],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[372],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[373],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[384],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[388],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[391],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[392],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[399],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[400],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[406],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[407],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[408],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[409],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[410],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[411],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[412],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[413],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[414],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[415],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[418],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[420],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[421],"CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
    ApplyDynamicActorAnimation(BotPears[423],"BD_FIRE","wash_up",4.1,0,1,1,1,1);
    ApplyDynamicActorAnimation(BotPears[425],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[426],"BD_FIRE","wash_up",4.1,0,1,1,1,1);
    ApplyDynamicActorAnimation(BotPears[427],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[428],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[429],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[431],"BD_FIRE","wash_up",4.1,0,1,1,1,1);
    ApplyDynamicActorAnimation(BotPears[432],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[433],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[434],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[435],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[436],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[437],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[438],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[439],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[440],"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[441],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[442],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[443],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[444],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[445],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[475],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[476],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[477],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[478],"BD_FIRE","wash_up",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[479],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[480],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[482],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[486],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[487],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[488],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[490],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[491],"SMOKING","M_smklean_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[492],"PED","woman_idlestance",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[493],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[494],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[498],"BD_FIRE","wash_up",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[501],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[509],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[510],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[511],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[512],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[514],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[515],"OTB","wtchrace_loop",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[516],"BLOWJOBZ","BJ_STAND_LOOP_P",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[517],"BLOWJOBZ","BJ_STAND_LOOP_W",4.1,1,0,0,0,0);
    ApplyDynamicActorAnimation(BotPears[520],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 11
    ApplyDynamicActorAnimation(BotPears[521],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 12
    ApplyDynamicActorAnimation(BotPears[522],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 13
    ApplyDynamicActorAnimation(BotPears[523],"PED","IDLE_CHAT",4.1,1,0,0,0,0); // LSPD Bot 14
    return 1;
}
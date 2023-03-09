#define MAX_BOTS 600  // кол-во макс. npc ботов на сервере

new BotPears[MAX_BOTS];
new BotInfo[MAX_BOTS];
new Text3D:BotChat[MAX_BOTS];

stock LoadBot()
{
	BotPears[0] = CreateActor(8, 944.2403,-1709.4430,13.5823,181.0545);// Автомастер LV 1 Хенк
	BotPears[1] = CreateActor(27, 2271.6897,2785.0352,10.8203,26.2866);// Государственный Склад Улица
	BotPears[2] = CreateActor(133, 1617.7690,-1895.4532,13.8599,266.8432); // Городская Клининговая Служба LS
	BotPears[3] = CreateActor(133, -1872.4868,-218.2040,18.6155,272.1465); // Городская Клининговая Служба SF
	BotPears[4] = CreateActor(133, 1034.6359,2215.3616,11.0254,359.8574); // Городская Клининговая Служба LV
	BotPears[5] = CreateActor(133, 992.0648,-1342.0739,13.6369,183.5969); // Автобусное Депо LS
	BotPears[6] = CreateActor(151, 1477.2902,-1782.6528,15.3182,0.3031); // Образовательный Центр
	SetActorVirtualWorld(BotPears[6], 197);
	BotPears[7] = CreateActor(147, 1509.1925,-1782.7321,21.0902,1.0359); // Образовательный Центр 2 Этаж Препод
	SetActorVirtualWorld(BotPears[7], 196);
	BotPears[8] = CreateActor(10, 1474.8569,-1806.1353,21.0982,359.8061); // Образовательный Центр 2 Этаж Библиотекарь
	SetActorVirtualWorld(BotPears[8], 196);
	BotPears[9] = CreateActor(158, -22.0634,81.3438,3.1096,68.7555); // Ферма бот на улице
	BotPears[10] = CreateActor(162, -43.4430,51.2411,3.1179,252.8287); // Ферма бот на улице (коровы)
	BotPears[11] = CreateActor(141, 2166.4031,2371.6714,23.6143,226.8451); // FBI Bot 1
	SetActorVirtualWorld(BotPears[11], 243);
	BotPears[12] = CreateActor(42, 1512.3502,-2183.3281,13.7929,249.3819); // Заправка Bot
	BotPears[13] = CreateActor(50, 1503.8464,-2183.2341,13.7929,100.0888); // Заправка Bot
	BotPears[14] = CreateActor(151, 1509.9032,-2174.9246,13.6277,270.0855); // Заправка Bot
	BotPears[15] = CreateActor(42, 893.1202,1903.3278,11.0516,337.5979); // Заправка Bot
	BotPears[16] = CreateActor(50, 892.9305,1894.7195,11.0516,191.5832); // Заправка Bot
	BotPears[17] = CreateActor(151, 884.5753,1900.7799,10.8864,359.6999); // Заправка Bot
	BotPears[18] = CreateActor(42, -2630.7766,1359.5754,7.2240,332.5845); // Заправка Bot
	BotPears[19] = CreateActor(50, -2630.6655,1351.4535,7.2240,216.6501); // Заправка Bot
	BotPears[20] = CreateActor(151, -2639.1790,1357.3517,7.1398,359.6998); // Заправка Bot
	BotPears[21] = CreateActor(42, -1562.2402,-2741.6199,48.7603,213.2033); // Заправка Bot
	BotPears[22] = CreateActor(123, 1460.6874,660.9774,10.8203,185.5546); // Yakuza Mafia Bot 1
	BotPears[23] = CreateActor(118, 1509.5968,755.5034,11.0234,175.3727); // Yakuza Mafia Bot 2
	BotPears[24] = CreateActor(117, 1514.0986,755.4178,11.0234,184.6377); // Yakuza Mafia Bot 3
	BotPears[25] = CreateActor(122, 1520.8297,755.5728,11.0234,178.6217); // Yakuza Mafia Bot 4
	BotPears[26] = CreateActor(186, 1520.5500,750.6175,11.0234,176.3129); // Yakuza Mafia Bot 5
	BotPears[27] = CreateActor(208, 1513.8164,750.4470,11.0234,181.0129); // Yakuza Mafia Bot 6
	BotPears[28] = CreateActor(120, 1506.3950,750.5110,11.0234,179.6969); // Yakuza Mafia Bot 7
	BotPears[29] = CreateActor(49, 1515.8894,738.4565,11.0234,358.9152); // Yakuza Mafia Bot 8
	BotPears[30] = CreateActor(6, 1380.1854,-5.4021,1000.9713,257.5052); // Рыбацкая Бухта Bot 1 [ Магазин ]
	SetActorVirtualWorld(BotPears[30], 219);
	BotPears[31] = CreateActor(95, 995.3415,-1954.1554,12.8842,182.6652); // Рыбацкая Бухта Bot 2 [ Продать Рыбу ]
	BotPears[32] = CreateActor(150, 1276.9844,-46.5174,1000.9280,358.1093); // Аэропорт Bot 1 [ Отель ]
	SetActorVirtualWorld(BotPears[32], 3);
	BotPears[33] = CreateActor(170, 1589.9722,-2279.1296,13.5331,244.2788); // Аэропорт Bot 2
	BotPears[34] = CreateActor(96, 1613.8485,-2278.8977,13.5732,347.3431); // Аэропорт Bot 3
	BotPears[35] = CreateActor(97, 1614.2062,-2277.4736,13.5656,162.1847); // Аэропорт Bot 4
    BotPears[36] = CreateActor(3, 1625.8187,-2295.5776,13.5372,128.6577); // Аэропорт Bot 5 [ Займы ]
	BotPears[37] = CreateActor(199, 1733.8733,-1901.9637,916.0651,281.3157); // Вокзал Bot 6
	SetActorVirtualWorld(BotPears[37], 7);
	BotPears[38] = CreateActor(188, 1743.0204,-1899.2825,916.0651,289.1492); // Вокзал Bot 7
	SetActorVirtualWorld(BotPears[38], 7);
	BotPears[39] = CreateActor(185, 1744.4777,-1898.8420,916.0651,101.7975); // Вокзал Bot 8
	SetActorVirtualWorld(BotPears[39], 7);
	BotPears[40] = CreateActor(71, 1743.6726,-1895.4208,913.6010,357.6015); // Вокзал Bot 9
	SetActorVirtualWorld(BotPears[40], 7);
	BotPears[41] = CreateActor(194, 1448.1943,-1004.8884,934.5612,178.0563); // Банк Bot 1
	SetActorVirtualWorld(BotPears[41], 1);
	BotPears[42] = CreateActor(240, 1470.2015,-1012.3074,934.5612,144.7220); // Банк Bot 2
	SetActorVirtualWorld(BotPears[42], 1);
	BotPears[43] = CreateActor(250, 1469.3521,-1013.6862,934.5612,323.3238); // Банк Bot 3
	SetActorVirtualWorld(BotPears[43], 1);
	BotPears[44] = CreateActor(71, 1460.7341,-1014.5112,934.5612,7.3114); // Банк Bot 4
	SetActorVirtualWorld(BotPears[44], 1);
	BotPears[45] = CreateActor(151, 607.0654,-1538.5491,15.3926,268.8089); // Спермобанк Bot 1 [ Спермобанк Приёмная ]
	SetActorVirtualWorld(BotPears[45], 220);
	BotPears[46] = CreateActor(159, -29.5093,67.5059,3.1172,72.0570); // Ферма бот на улице (фрукты)
    BotPears[47] = CreateActor(262,-338.6107,1729.5956,42.8917,4.2150); // археология бот на улице (гасхититель гробниц)
    BotPears[48] = CreateActor(133, -1655.5134,1289.8231,7.2908,225.2348); // Автобусное Депо SF
	BotPears[49] = CreateActor(308, 1391.5339,-13.7709,1000.9217,1.1784); // Госпиталь Bot 2
	SetActorVirtualWorld(BotPears[49], 5);
	BotPears[50] = CreateActor(16, 1385.5522,-18.7329,1000.9110,178.9046); // IKEA Bot (Pavilion 2)
    SetActorVirtualWorld(BotPears[50], 193);
	BotPears[51] = CreateActor(308, 1163.3939,-1315.3433,898.0944,90.6377); // Госпиталь Bot 4
	SetActorVirtualWorld(BotPears[51], 1);
	BotPears[52] = CreateActor(250, 1161.7295,-1315.5109,898.0944,274.2293); // Госпиталь Bot 5
	SetActorVirtualWorld(BotPears[52], 1);
	BotPears[53] = CreateActor(259, 1150.3359,-1297.2848,898.7470,180.6266); // Госпиталь Bot 6
	SetActorVirtualWorld(BotPears[53], 1);
	BotPears[54] = CreateActor(229, 1153.5736,-1302.8451,898.7470,275.0858); // Госпиталь Bot 7
	SetActorVirtualWorld(BotPears[54], 1);
	BotPears[55] = CreateActor(170, 1385.4244,-17.7351,1000.9110,355.9396); // IKEA Bot (Pavilion 2)
    SetActorVirtualWorld(BotPears[55], 193);
    BotPears[56] = CreateActor(50, -1569.2174,-2737.0059,48.7603,78.7820); // Заправка Bot
	BotPears[57] = CreateActor(151, -1559.4789,-2733.2468,48.5951,236.8721); // Заправка Bot
	BotPears[58] = CreateActor(111, -1978.7440,1125.3831,52.5381,237.8730); // Russian Mafia Bot 1
	BotPears[59] = CreateActor(125, -2002.7351,1131.1342,53.2815,188.2334); // Russian Mafia Bot 2
	BotPears[60] = CreateActor(126, -2010.2117,1110.2968,53.2891,197.0067); // Russian Mafia Bot 3
	BotPears[61] = CreateActor(112, -2009.2338,1108.3409,53.2891,35.0118); // Russian Mafia Bot 4
	BotPears[62] = CreateActor(192, -2002.4238,1104.6166,53.2891,354.5681); // Russian Mafia Bot 5
	BotPears[63] = CreateActor(220, -489.7464,2602.4995,53.9780,267.3839); // Arabian Mafia Bot 1
	BotPears[64] = CreateActor(142, -503.2404,2586.7517,53.5704,6.2471); // Arabian Mafia Bot 2
	BotPears[65] = CreateActor(220, -620.9092,2583.2419,2105.3840,178.0831); // Arabian Mafia Bot 3
	SetActorVirtualWorld(BotPears[65], 18);
	BotPears[66] = CreateActor(222, -635.4254,2628.1697,2104.9768,91.2262); // Arabian Mafia Bot 4
	SetActorVirtualWorld(BotPears[66], 18);
	BotPears[67] = CreateActor(221, -636.1757,2579.9343,2104.9768,227.1280); // Arabian Mafia Bot 5
	SetActorVirtualWorld(BotPears[67], 18);
	BotPears[68] = CreateActor(142, -634.8665,2578.5576,2104.9768,43.2623); // Arabian Mafia Bot 6
	SetActorVirtualWorld(BotPears[68], 18);
	BotPears[69] = CreateActor(42, 60.9589,-190.2918,1.8558,248.9236); // Заправка Bot
	BotPears[70] = CreateActor(50, 52.7649,-189.7369,1.8558,108.5488); // Заправка Bot
	BotPears[71] = CreateActor(151, 58.9251,-181.5847,1.6906,265.0719); // Заправка Bot
	BotPears[72] = CreateActor(16, 1385.5709,-12.5325,1000.9110,177.0246); // IKEA Bot (Pavilion 2)
    SetActorVirtualWorld(BotPears[72], 193);
    BotPears[73] = CreateActor(6, 1385.5596,-14.3427,1000.9110,183.9181); // IKEA Bot (Pavilion 3)
    SetActorVirtualWorld(BotPears[73], 192);
    BotPears[74] = CreateActor(6, 1385.5792,-13.3454,1000.9110,0.9531); // IKEA Bot (Pavilion 3)
    SetActorVirtualWorld(BotPears[74], 192);
    BotPears[75] = CreateActor(133, 1063.9913,2306.4170,11.0953,270.3401); // Автобусное Депо LV
    BotPears[89] = CreateActor(150, 1081.6710,-1687.4646,19.3107,178.5586); // Риэлторша Bot 1
    BotPears[91] = CreateActor(205, 375.8292,-65.8476,1001.5078,178.9384); // Burger Shot-1 Bot 1
    SetActorVirtualWorld(BotPears[91], 1);
    BotPears[92] = CreateActor(205, 376.3629,-61.4211,1001.5078,94.0476); // Burger Shot-1 Bot 2
    SetActorVirtualWorld(BotPears[92], 1);
    BotPears[93] = CreateActor(205, 378.3660,-57.4492,1001.5078,358.1901); // Burger Shot-1 Bot 3
    SetActorVirtualWorld(BotPears[93], 1);
    BotPears[94] = CreateActor(23, 369.3431,-61.7831,1001.5151,177.9983); // Burger Shot-1 Bot 4
    SetActorVirtualWorld(BotPears[94], 1);
	BotPears[100] = CreateActor(68, 1327.8085,1585.8474,11.0259,271.6756); // Церковь Bot 1 [ Священник ]
	SetActorVirtualWorld(BotPears[100], 195);
	BotPears[101] = CreateActor(205, 377.9569,-65.8493,1001.5078,183.9751); // Burger Shot-1 Bot 5
    SetActorVirtualWorld(BotPears[101], 1);
    BotPears[102] = CreateActor(20, 378.3685,-67.6006,1001.5151,1.5899); // Burger Shot-1 Bot 6
    SetActorVirtualWorld(BotPears[102], 1);
	BotPears[103] = CreateActor(161, -1631.7679,-2234.6997,31.4766,160.4179); // Лесник Bot 1
	BotPears[104] = CreateActor(11, 1793.9835,-1772.1897,13.7935,90.5202); // Автосалон Bot 1
	BotPears[105] = CreateActor(40, 1776.7781,-1875.1967,13.5607,87.0187); // Sex Bot 1
	BotPears[106] = CreateActor(37, 1775.8397,-1875.1381,13.5608,268.5027); // Sex Bot 2
	BotPears[110] = CreateActor(276, 1154.4517,-1302.5990,898.1036,106.8008); // Госпиталь Bot 8
	SetActorVirtualWorld(BotPears[110], 1);
	BotPears[111] = CreateActor(15, 1171.6820,-1297.7162,898.7470,92.0739); // Госпиталь Bot 8
	SetActorVirtualWorld(BotPears[111], 1);
	BotPears[112] = CreateActor(32, 1168.5963,-1303.1786,898.7470,2.3148); // Госпиталь Bot 10
	SetActorVirtualWorld(BotPears[112], 1);
	BotPears[113] = CreateActor(34, 1150.8004,-1305.3921,898.7470,92.7241); // Госпиталь Bot 11
	SetActorVirtualWorld(BotPears[113], 1);
	BotPears[114] = CreateActor(44, 1147.5684,-1311.3845,898.7470,0.7715); // Госпиталь Bot 12
	SetActorVirtualWorld(BotPears[114], 1);
	BotPears[115] = CreateActor(54, 1168.3097,-1310.6511,898.7470,275.4225); // Госпиталь Bot 13
	SetActorVirtualWorld(BotPears[115], 1);
	BotPears[116] = CreateActor(58, 1150.9082,-1328.6205,898.0944,186.1451); // Госпиталь Bot 14
	SetActorVirtualWorld(BotPears[116], 1);
	BotPears[117] = CreateActor(275, 1150.9603,-1329.8462,898.0944,9.4234); // Госпиталь Bot 15
	SetActorVirtualWorld(BotPears[117], 1);
	BotPears[118] = CreateActor(71, 1162.4762,-1328.9657,898.0944,4.3867); // Госпиталь Bot 16
	SetActorVirtualWorld(BotPears[118], 1);
	BotPears[119] = CreateActor(275, 1138.6152,-1349.8079,898.0916,181.7350); // Госпиталь Bot 17
	SetActorVirtualWorld(BotPears[119], 1);
	BotPears[120] = CreateActor(276, 1138.5537,-1351.0946,898.0916,357.1800); // Госпиталь Bot 18
	SetActorVirtualWorld(BotPears[120], 1);
	BotPears[121] = CreateActor(252, 1156.0387,-1382.1033,898.8210,96.7777); // Госпиталь Bot 19
	SetActorVirtualWorld(BotPears[121], 1);
	BotPears[122] = CreateActor(70, 1118.0420,-1362.3555,898.0916,274.5060); // Госпиталь Bot 20
	SetActorVirtualWorld(BotPears[122], 1);

	// LSPD Боты
	//148
	BotPears[149] = CreateActor(280, 1580.1194,-1634.3180,13.5624,2.8671); // LSPD Bot 2
	//150
	BotPears[151] = CreateActor(281, 1545.1991,-1669.5962,13.5599,20.7507); // LSPD Bot 4
	BotPears[152] = CreateActor(259, 1544.4688,-1668.0896,13.5585,205.2824); // LSPD Bot 5
	BotPears[153] = CreateActor(282, 1545.0980,-1683.7576,13.5563,0.9871); // LSPD Bot 6
	BotPears[154] = CreateActor(284, 1549.5330,-1680.2131,13.5564,193.9789); // LSPD Bot 7
	BotPears[155] = CreateActor(280, 1550.4847,-1682.5118,13.5545,18.5106); // LSPD Bot 8
	// В интерьере
	BotPears[156] = CreateActor(300, 1556.1638,-1660.8695,16.2218,136.1330); // LSPD Bot 9 ((154))
	SetActorVirtualWorld(BotPears[156], 255);
	BotPears[157] = CreateActor(301, 1554.9736,-1661.7855,16.2218,309.0712); // LSPD Bot 10 ((144))
	SetActorVirtualWorld(BotPears[157], 255);
	BotPears[192] = CreateActor(96, 375.7525,-118.8693,1001.4995,0.3965); // Pizza Co Bot 1
	SetActorVirtualWorld(BotPears[192], 1);
	BotPears[193] = CreateActor(155, 373.6131,-117.2756,1001.4995,182.4215); // Pizza Co Bot 2
	SetActorVirtualWorld(BotPears[193], 1);
	BotPears[194] = CreateActor(155, 375.7129,-117.2748,1001.4922,180.2282); // Pizza Co Bot 3
	SetActorVirtualWorld(BotPears[194], 1);
	BotPears[195] = CreateActor(155, 376.5362,-113.7120,1001.4922,0.0000); // Pizza Co Bot 4
	SetActorVirtualWorld(BotPears[195], 1);
	BotPears[196] = CreateActor(155, 372.6896,-113.7299,1001.4922,353.4200); // Pizza Co Bot 5
	SetActorVirtualWorld(BotPears[196], 1);
	BotPears[197] = CreateActor(141, 1384.8610,1588.3568,10.8484,184.8581); // NASA Bot 1
	SetActorVirtualWorld(BotPears[197], 230);
	BotPears[204] = CreateActor(36, -337.9493,1725.6622,42.8531,270.0621); // Археология Bot 1
	BotPears[207] = CreateActor(42, 1934.9749,-1779.5398,13.7258,327.5147);// Заправщик Bot 1
	BotPears[208] = CreateActor(50, 1934.4780,-1787.4510,13.7258,192.4313);// Заправщик Bot 2
	BotPears[209] = CreateActor(151, 1926.0579,-1781.8629,13.5606,358.2216);// Заправщик Bot 3
	BotPears[219] = CreateActor(42, -1675.1141,421.4946,7.3641,297.0783);// Заправщик Bot 4
	BotPears[220] = CreateActor(50, -1680.8055,415.6465,7.3641,158.2703);// Заправщик Bot 5
	BotPears[221] = CreateActor(151, -1682.5594,425.5037,7.1989,316.5287);// Заправщик Bot 6
	BotPears[222] = CreateActor(11, 1638.1517,1449.1168,15.3081,270.8537);// Авиасалон Bot 1
	BotPears[223] = CreateActor(40, 1451.5735,-1004.8928,934.5612,180.2496); // Банк Bot 5
	SetActorVirtualWorld(BotPears[223], 1);
	BotPears[224] = CreateActor(40, 1455.4291,-1004.8458,934.5612,180.5630); // Банк Bot 6
	SetActorVirtualWorld(BotPears[224], 1);
	BotPears[225] = CreateActor(40, 1459.2037,-1004.8942,934.5612,176.8029); // Банк Bot 7
	SetActorVirtualWorld(BotPears[225], 1);
	BotPears[226] = CreateActor(37, -2230.7534,251.7373,894.7211,4.7700); // Ледовый Дворец Bot 1
	SetActorVirtualWorld(BotPears[226], 77);
	BotPears[227] = CreateActor(42, -2105.4768,-0.9047,35.5099,339.2878);// Заправщик Bot 7 sf-2
	BotPears[228] = CreateActor(50, -2105.5925,-8.6365,35.5099,199.8531);// Заправщик Bot 8 sf-2
	BotPears[229] = CreateActor(151, -2113.7688,-3.1075,35.3447,358.4013);// Заправщик Bot 9 sf-2
	BotPears[230] = CreateActor(42, 157.5066,-1614.4482,14.7704,14.7461);// Заправщик Bot 10 ls-2
	BotPears[231] = CreateActor(50, 162.5071,-1620.5380,14.7704,239.3851);// Заправщик Bot 11 ls-2
	BotPears[232] = CreateActor(151, 152.5646,-1621.7789,14.6052,42.7584);// Заправщик Bot 12 ls-2
	BotPears[233] = CreateActor(42, 1844.1437,817.5923,10.9726,56.9960);// Заправщик Bot 13 lv-1
	BotPears[234] = CreateActor(50, 1852.0760,817.3677,10.9730,289.3431);// Заправщик Bot 14 lv-1
	BotPears[235] = CreateActor(151, 1846.3289,809.4238,10.8216,90.0844);// Заправщик Bot 15 lv-1
	BotPears[236] = CreateActor(42, 2250.1785,2391.5908,11.0000,56.4122);// Заправщик Bot 16 lv-2
	BotPears[237] = CreateActor(50, 2258.2874,2391.3408,11.0000,284.2471);// Заправщик Bot 17 lv-2
	BotPears[238] = CreateActor(151, 2252.6345,2383.2349,10.8348,90.0646);// Заправщик Bot 18 lv-2
	BotPears[240] = CreateActor(155, 1717.9539,-2410.4026,13.5767,180.5654); // Аэропорт Bot 1
	SetActorVirtualWorld(BotPears[240], 198);
	BotPears[241] = CreateActor(71, 1728.6202,-2411.7305,13.5767,271.0727); // Аэропорт Bot 1
	SetActorVirtualWorld(BotPears[241], 198);
	BotPears[242] = CreateActor(71, 1738.4613,-2433.9980,13.5767,89.8428); // Аэропорт Bot 1
	SetActorVirtualWorld(BotPears[242], 198);
	BotPears[243] = CreateActor(150, 1742.0760,-2421.0786,13.5767,91.7972); // Аэропорт Bot 1
	SetActorVirtualWorld(BotPears[243], 198);
	BotPears[244] = CreateActor(150, 1742.0778,-2425.4563,13.5767,91.7972); // Аэропорт Bot 1
	SetActorVirtualWorld(BotPears[244], 198);
	BotPears[245] = CreateActor(150, 1742.0760,-2429.7825,13.5767,89.8938); // Аэропорт Bot 1
	SetActorVirtualWorld(BotPears[245], 198);
	BotPears[250] = CreateActor(158, -35.4461,77.0759,3.1331,13.4866); // Ферма Bot 1
	SetActorVirtualWorld(BotPears[250], 228);
	BotPears[260] = CreateActor(205, 375.8292,-65.8476,1001.5078,178.9384); // Burger Shot Bot
    SetActorVirtualWorld(BotPears[260], 2);
    BotPears[261] = CreateActor(205, 375.8292,-65.8476,1001.5078,178.9384); // Burger Shot Bot
    SetActorVirtualWorld(BotPears[261], 3);
    BotPears[262] = CreateActor(205, 375.8292,-65.8476,1001.5078,178.9384); // Burger Shot Bot
    SetActorVirtualWorld(BotPears[262], 4);
    BotPears[263] = CreateActor(205, 375.8292,-65.8476,1001.5078,178.9384); // Burger Shot Bot
    SetActorVirtualWorld(BotPears[263], 5);
    BotPears[264] = CreateActor(205, 375.8292,-65.8476,1001.5078,178.9384); // Burger Shot Bot
    SetActorVirtualWorld(BotPears[264], 6);
	BotPears[265] = CreateActor(167, 368.9441,-4.4851,1001.8516,181.6134); // Cluckin Bell Bot
    SetActorVirtualWorld(BotPears[265], 1);
    BotPears[266] = CreateActor(167, 368.9441,-4.4851,1001.8516,181.6134); // Cluckin Bell Bot
    SetActorVirtualWorld(BotPears[266], 2);
    BotPears[267] = CreateActor(167, 368.9441,-4.4851,1001.8516,181.6134); // Cluckin Bell Bot
    SetActorVirtualWorld(BotPears[267], 3);
    BotPears[268] = CreateActor(167, 368.9441,-4.4851,1001.8516,181.6134); // Cluckin Bell Bot
    SetActorVirtualWorld(BotPears[268], 4);
    BotPears[269] = CreateActor(167, 368.9441,-4.4851,1001.8516,181.6134); // Cluckin Bell Bot
    SetActorVirtualWorld(BotPears[269], 5);
    BotPears[270] = CreateActor(167, 368.9441,-4.4851,1001.8516,181.6134); // Cluckin Bell Bot
    SetActorVirtualWorld(BotPears[270], 6);
    BotPears[271] = CreateActor(178, -103.6952,-24.2643,1000.7188,1.9498); // Sex Shop Bot
    SetActorVirtualWorld(BotPears[271], 1);
    BotPears[272] = CreateActor(178, -103.6952,-24.2643,1000.7188,1.9498); // Sex Shop Bot
    SetActorVirtualWorld(BotPears[272], 2);
    BotPears[273] = CreateActor(178, -103.6952,-24.2643,1000.7188,1.9498); // Sex Shop Bot
    SetActorVirtualWorld(BotPears[273], 3);
    BotPears[274] = CreateActor(178, -103.6952,-24.2643,1000.7188,1.9498); // Sex Shop Bot
    SetActorVirtualWorld(BotPears[274], 4);
    BotPears[275] = CreateActor(301,1461.7512,-92.3984,26.7904,316.2536); // Тюрьма Bot
    BotPears[276] = CreateActor(302,1473.8959,-88.8228,26.7904,151.1254); // Тюрьма Bot
    BotPears[277] = CreateActor(288,1473.4253,-89.7908,26.7904,330.2359); // Тюрьма Bot
    BotPears[278] = CreateActor(301,1517.2401,-29.4957,26.7835,131.0954); // Тюрьма Bot
    BotPears[279] = CreateActor(281,-1954.7623,2344.0791,1549.6833,179.2847); // Тюрьма Bot
    SetActorVirtualWorld(BotPears[279], 36);
    BotPears[280] = CreateActor(283,-1952.8025,2370.2859,1549.6833,177.7180); // Тюрьма Bot
    SetActorVirtualWorld(BotPears[280], 36);
    BotPears[281] = CreateActor(268,-1940.0203,2382.6238,1549.6833,270.7734); // Тюрьма Bot
    SetActorVirtualWorld(BotPears[281], 37);
    BotPears[282] = CreateActor(268,-1945.2432,2389.0210,1549.6833,0.7008); // Тюрьма Bot
    SetActorVirtualWorld(BotPears[282], 37);
    BotPears[283] = CreateActor(288,615.3415,-540.1636,1492.0072,3.2988); // Тюрьма Bot
    SetActorVirtualWorld(BotPears[283], 36);
    BotPears[284] = CreateActor(28,1431.5796,-132.3715,26.7904,37.8463); // Тюрьма Bot
    BotPears[285] = CreateActor(30,1410.6948,-119.8417,26.7904,277.6937); // Тюрьма Bot
    BotPears[286] = CreateActor(42,1427.3776,-115.7589,26.7904,20.0096); // Тюрьма Bot
    BotPears[287] = CreateActor(268,1426.8988,-114.0483,26.7904,194.5379); // Тюрьма Bot
    BotPears[288] = CreateActor(48,1421.5983,-145.5395,27.8694,36.9531); // Тюрьма Bot
    BotPears[289] = CreateActor(67,1424.7656,-144.2773,28.1855,36.9531); // Тюрьма Bot
    BotPears[290] = CreateActor(28,1405.3990,-125.5751,26.7904,358.7261); // Тюрьма Bot
    BotPears[291] = CreateActor(25,1406.2046,-123.9625,26.7904,125.0006); // Тюрьма Bot
    BotPears[292] = CreateActor(21,1404.6963,-123.8337,26.7904,210.8548); // Тюрьма Bot
    BotPears[293] = CreateActor(281,-1943.1350,2379.3757,1549.6833,176.0008); // Тюрьма Bot otb 37 инт столовка мент
    SetActorVirtualWorld(BotPears[293], 37);
    BotPears[294] = CreateActor(283,-1933.6089,2379.3655,1549.6833,0.2191); // Тюрьма Bot otb 37 инт столовка мент
    SetActorVirtualWorld(BotPears[294], 37);
    BotPears[295] = CreateActor(280,-1948.9519,2381.6292,1549.6833,186.0274); // Тюрьма Bot похлопывает рукой мент 36 инт
    SetActorVirtualWorld(BotPears[295], 36);
    BotPears[296] = CreateActor(288,605.9303,-549.1145,1492.0072,270.5513); // Тюрьма Bot похлопывает рукой мент 36 инт
    SetActorVirtualWorld(BotPears[296], 36);
    BotPears[297] = CreateActor(300,636.8461,-544.0811,1492.0072,333.7004); // Тюрьма Bot мент 1 пиздит с 2 36 инт
    SetActorVirtualWorld(BotPears[297], 36);
    BotPears[298] = CreateActor(301,637.6428,-542.6046,1492.0072,146.0353); // Тюрьма Bot мент 2 пиздит с 1 36 инт
    SetActorVirtualWorld(BotPears[298], 36);
    BotPears[299] = CreateActor(297,609.4335,-529.0662,1496.1713,180.3573); // Тюрьма Bot зек нигер стоит на охране otb 36 инт
    SetActorVirtualWorld(BotPears[299], 36);
    BotPears[300] = CreateActor(261,-1950.0703,2340.0571,1549.6833,150.4520); // Тюрьма Bot гражданский 1 пиздит с 2 36 инт
    SetActorVirtualWorld(BotPears[300], 36);
    BotPears[301] = CreateActor(259,-1950.6799,2338.4812,1549.6833,333.1270); // Тюрьма Bot гражданский 2 пиздит с 1 36 инт
    SetActorVirtualWorld(BotPears[301], 36);
    BotPears[302] = CreateActor(267,-1948.5565,2350.3408,1549.6833,99.5464); // Тюрьма Bot мент стоит хз какая анимка 36 инт
    SetActorVirtualWorld(BotPears[302], 36);
    BotPears[303] = CreateActor(248,1429.9197,-107.2486,26.7904,132.3054); // Тюрьма Bot зек стоит облокатившись улица
    BotPears[304] = CreateActor(247,1420.6920,-129.9727,26.7904,189.1877); // Тюрьма Bot зек пиздит  улица
    BotPears[305] = CreateActor(206,1419.7673,-131.7033,26.7904,320.7889); // Тюрьма Bot зек пиздит улица
    BotPears[306] = CreateActor(242,1421.5477,-131.0888,26.7904,65.1299); // Тюрьма Bot зек otb улица
    BotPears[307] = CreateActor(182,1410.1254,-139.7495,26.7904,227.4147); // Тюрьма Bot зек курит улица
    BotPears[308] = CreateActor(183,1411.6548,-140.8968,26.7904,52.2831); // Тюрьма Bot зек втирает ему что то улица
    BotPears[309] = CreateActor(297,1415.3198,-125.3952,26.7904,85.1366); // Тюрьма Bot зек пиздит грушу
    BotPears[310] = CreateActor(163,1292.8673,-53.0409,1000.9422,183.6430); // Правительство Bot
    SetActorVirtualWorld(BotPears[310], 234);
    BotPears[311] = CreateActor(164,1304.5822,-65.5058,1000.9422,7.8614); // Правительство Bot
    SetActorVirtualWorld(BotPears[311], 234);
    BotPears[312] = CreateActor(150,1283.8494,-61.0814,1002.3203,270.9135); // Правительство Bot
    SetActorVirtualWorld(BotPears[312], 234);
    BotPears[313] = CreateActor(147,-2046.6985,-988.4554,1651.6968,30.9710); // Правительство Bot
    SetActorVirtualWorld(BotPears[313], 7);
    BotPears[314] = CreateActor(187,-2047.6536,-987.2053,1651.6968,215.5261); // Правительство Bot
    SetActorVirtualWorld(BotPears[314], 7);
    BotPears[315] = CreateActor(164,-2000.2031,161.7839,1666.0313,93.0917); // Правительство Bot
    SetActorVirtualWorld(BotPears[315], 7);
    BotPears[322] = CreateActor(6,2380.3674,563.8082,909.7986,95.1605); // Салон Катеров Bot
    SetActorVirtualWorld(BotPears[322], 98);
    BotPears[323] = CreateActor(202,1382.5847,-21.8886,1001.0793,94.5528); // Дальнобойщики Bot [ Главный Бот ]
    SetActorVirtualWorld(BotPears[323], 11);
    BotPears[324] = CreateActor(206,1377.6793,-15.4435,1001.0717,220.1772); // Дальнобойщики Bot
    SetActorVirtualWorld(BotPears[324], 11);
    BotPears[325] = CreateActor(261,1378.6981,-16.7620,1001.0717,38.1523); // Дальнобойщики Bot
    SetActorVirtualWorld(BotPears[325], 11);
    BotPears[326] = CreateActor(16,1123.1250,-1305.4923,13.5872,71.5088); // Дальнобойщики База Bot
    BotPears[327] = CreateActor(27,1125.5597,-1296.5193,13.5633,152.9528); // Дальнобойщики База Bot
    BotPears[328] = CreateActor(153,1124.7781,-1298.0435,13.5674,329.6746); // Дальнобойщики База Bot
    BotPears[329] = CreateActor(16,-2486.1790,782.1337,35.1719,343.9197); // Дальнобойщики База Bot
    BotPears[330] = CreateActor(27,-2483.1833,795.7057,35.1719,238.1570); // Дальнобойщики База Bot
    BotPears[331] = CreateActor(153,-2482.0823,794.7839,35.1719,47.6719); // Дальнобойщики База Bot
    BotPears[332] = CreateActor(16,2183.5134,1980.5009,10.8203,140.8778); // Дальнобойщики База Bot
    BotPears[333] = CreateActor(27,2189.7139,1972.1982,10.8203,140.7328); // Дальнобойщики База Bot
    BotPears[334] = CreateActor(153,2188.4985,1970.7328,10.8203,319.3347); // Дальнобойщики База Bot
    BotPears[335] = CreateActor(16,2174.3938,-2273.1057,13.4333,307.2595); // Дальнобойщики База Bot
    BotPears[336] = CreateActor(27,2180.4761,-2284.1841,13.5469,87.1525); // Дальнобойщики База Bot
    BotPears[337] = CreateActor(153,2179.1135,-2284.2703,13.5469,274.2142); // Дальнобойщики База Bot
    BotPears[338] = CreateActor(16,-1715.1428,52.0637,3.5495,194.7718); // Дальнобойщики База Bot
    BotPears[339] = CreateActor(27,-1714.1239,35.8344,3.5547,181.7800); // Дальнобойщики База Bot
    BotPears[340] = CreateActor(153,-1714.0500,34.2317,3.5547,359.1283); // Дальнобойщики База Bot
    BotPears[341] = CreateActor(16,1064.3127,1924.6112,10.8203,356.4532); // Дальнобойщики База Bot
    BotPears[342] = CreateActor(27,1061.4304,1939.7343,10.8130,131.9829); // Дальнобойщики База Bot
    BotPears[343] = CreateActor(153,1060.3191,1938.7573,10.8203,311.8146); // Дальнобойщики База Bot
    BotPears[344] = CreateActor(16,1795.5890,-1086.3973,23.9686,86.7175); // Дальнобойщики База Bot
    BotPears[345] = CreateActor(27,1784.9038,-1071.5548,23.9609,234.1071); // Дальнобойщики База Bot
    BotPears[346] = CreateActor(153,1786.0665,-1072.4700,23.9609,48.3221); // Дальнобойщики База Bot
    BotPears[347] = CreateActor(16,-1831.7710,122.3533,15.1172,91.0809); // Дальнобойщики База Bot
    BotPears[348] = CreateActor(27,-1845.1890,123.4154,15.1172,357.5850); // Дальнобойщики База Bot
    BotPears[349] = CreateActor(153,-1845.0536,124.6794,15.1172,173.6801); // Дальнобойщики База Bot
    BotPears[350] = CreateActor(16,2532.5154,2800.9751,10.8203,125.0607); // Нефтеперерабатывающий Улица Bot
    BotPears[351] = CreateActor(27,2517.1875,2829.1831,10.8203,246.0552); // Нефтеперерабатывающий Улица Bot
    BotPears[352] = CreateActor(153,2518.6653,2828.4517,10.8203,58.7035); // Нефтеперерабатывающий Улица Bot
    BotPears[353] = CreateActor(16,1788.7747,-2035.9514,13.5175,94.2377); // Дальнобойщики База Bot
    BotPears[354] = CreateActor(27,1792.0707,-2051.0505,13.5739,253.5576); // Дальнобойщики База Bot
    BotPears[355] = CreateActor(153,1793.7808,-2051.8015,13.5755,62.4458); // Дальнобойщики База Bot
    BotPears[356] = CreateActor(16,-1855.7886,1404.0564,7.1841,270.3093); // Дальнобойщики База Bot
    BotPears[357] = CreateActor(27,-1843.2206,1402.4681,7.1875,225.9839); // Дальнобойщики База Bot
    BotPears[358] = CreateActor(153,-1842.0010,1401.1567,7.1875,43.9589); // Дальнобойщики База Bot
    BotPears[359] = CreateActor(16,2377.2729,2741.1497,10.8203,179.4418); // Дальнобойщики База Bot
    BotPears[360] = CreateActor(27,2377.0156,2727.0046,10.8203,272.6477); // Дальнобойщики База Bot
    BotPears[361] = CreateActor(153,2378.5669,2727.2043,10.8203,89.9960); // Дальнобойщики База Bot
    BotPears[362] = CreateActor(16,2174.6709,-1984.7338,13.5509,334.5432); // Дальнобойщики База Bot
    BotPears[363] = CreateActor(27,2190.6096,-1985.9928,13.5506,339.0983); // Дальнобойщики База Bot
    BotPears[364] = CreateActor(153,2191.1514,-1984.5547,13.5509,158.3266); // Дальнобойщики База Bot
    BotPears[365] = CreateActor(16,-1895.5596,-1709.9712,21.7564,180.0918); // Дальнобойщики База Bot
    BotPears[366] = CreateActor(17,-1910.7532,-1710.3342,21.7500,35.8122); // Дальнобойщики База Bot
    BotPears[367] = CreateActor(153,-1912.1523,-1708.4348,21.7564,215.0406); // Дальнобойщики База Bot
    BotPears[368] = CreateActor(208,-1456.3763,916.2051,7.3453,3.4842); // Triada Mafia Bot
    BotPears[369] = CreateActor(210,-1456.4972,917.7109,7.3453,182.3992); // Triada Mafia Bot
    BotPears[370] = CreateActor(120,-1500.5579,932.4845,7.3453,184.8825); // Triada Mafia Bot
    BotPears[371] = CreateActor(186,-1492.5112,917.4147,7.3453,77.4082); // Triada Mafia Bot
    BotPears[372] = CreateActor(118,-1494.8196,918.6791,7.3453,240.3431); // Triada Mafia Bot
    BotPears[373] = CreateActor(117,-1452.9584,929.5131,7.3793,99.3419); // Triada Mafia Bot
    BotPears[376] = CreateActor(194,2211.8379,1029.4117,994.4688,182.3280); // Казино Bot Касса
    SetActorVirtualWorld(BotPears[376], 2001);
    BotPears[377] = CreateActor(172,2216.7393,1029.4164,994.4688,180.7613); // Казино Bot Касса
    SetActorVirtualWorld(BotPears[377], 2001);
    BotPears[378] = CreateActor(171,2221.4226,1029.4115,994.4688,180.4480); // Казино Bot Касса
    SetActorVirtualWorld(BotPears[378], 2001);
    BotPears[379] = CreateActor(172,2183.0564,1013.2817,992.4688,180.3346); // Казино Bot Рулетка [0]
    SetActorVirtualWorld(BotPears[379], 2001);
    BotPears[380] = CreateActor(172,2183.0564,1019.2822,992.4688,177.8512); // Казино Bot Рулетка [1]
    SetActorVirtualWorld(BotPears[380], 2001);
    BotPears[381] = CreateActor(172,2183.0564,1025.2816,992.4688,174.0912); // Казино Bot Рулетка [2]
    SetActorVirtualWorld(BotPears[381], 2001);
    BotPears[382] = CreateActor(171,2171.3940,1014.0906,992.4688,106.5708); // бот в баре Казино
	SetActorVirtualWorld(BotPears[382], 2001);
	BotPears[383] = CreateActor(171,2171.5842,1022.4432,992.4688,83.6973); // бот в баре Казино
	SetActorVirtualWorld(BotPears[383], 2001);
	BotPears[384] = CreateActor(163,2201.9219,1007.3365,994.4688,91.9738); // охранник otb Казино
	SetActorVirtualWorld(BotPears[384], 2001);
	BotPears[385] = CreateActor(171,2176.9482,1020.9529,992.4688,277.3156); // бот в баре Казино
	SetActorVirtualWorld(BotPears[385], 2001);
    BotPears[386] = CreateActor(171,2176.8618,1014.8093,992.4688,270.7356); // бот в баре Казино
	SetActorVirtualWorld(BotPears[386], 2001);
	BotPears[387] = CreateActor(171,2171.0869,1018.0458,992.4688,95.1071); // бот в баре Казино
	SetActorVirtualWorld(BotPears[387], 2001);
	BotPears[388] = CreateActor(163,2170.4785,998.8090,992.4688,358.4547); // охранник otb Казино
	SetActorVirtualWorld(BotPears[388], 2001);
	BotPears[391] = CreateActor(164,2242.9587,1021.4113,996.8750,89.6121); // охранник otb Казино
	SetActorVirtualWorld(BotPears[391], 2001);
	BotPears[392] = CreateActor(163,2243.1431,1014.8881,996.8818,90.8655); // охранник otb Казино
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
	BotPears[411] = CreateActor(71, 1402.2173,3.8803,1000.9217,92.9859); // Госпиталь Bot 21
	SetActorVirtualWorld(BotPears[411], 5);
	BotPears[412] = CreateActor(71, 1376.4246,-6.3177,1000.9267,182.4317); // Госпиталь Bot 22
	SetActorVirtualWorld(BotPears[412], 5);
	BotPears[413] = CreateActor(71, 1395.8878,-16.0300,1000.9217,271.3257); // Госпиталь Bot 23
	SetActorVirtualWorld(BotPears[413], 5);
	BotPears[414] = CreateActor(274, 1400.1345,-21.4354,1000.9217,253.0776); // Госпиталь Bot 24
	SetActorVirtualWorld(BotPears[414], 5);
	BotPears[415] = CreateActor(272, 1401.3024,-21.7337,1000.9217,71.9927); // Госпиталь Bot 25
	SetActorVirtualWorld(BotPears[415], 5);
	BotPears[416] = CreateActor(70, 1377.5765,-21.8737,1000.9217,51.2186); // Госпиталь Bot 26
	SetActorVirtualWorld(BotPears[416], 6);
	BotPears[417] = CreateActor(276, 1386.7156,-13.8015,1000.9217,9.9520); // Госпиталь Bot 27
	SetActorVirtualWorld(BotPears[417], 5);
	BotPears[418] = CreateActor(259, 1386.1909,-12.0045,1000.9219,195.7369); // Госпиталь Bot 28
	SetActorVirtualWorld(BotPears[418], 5);
	BotPears[419] = CreateActor(308, 1218.2460,-1352.8877,2001.0491,178.0994); // Психушка Bot 1
	SetActorVirtualWorld(BotPears[419], 4);
	BotPears[420] = CreateActor(71, 1211.5765,-1357.6942,2001.0449,271.6186); // Психушка Bot 2
	SetActorVirtualWorld(BotPears[420], 4);
	BotPears[421] = CreateActor(291, 1226.6830,-1361.0850,2001.0491,78.6269); // Психушка Bot 3
	SetActorVirtualWorld(BotPears[421], 4);
	BotPears[422] = CreateActor(70, 1225.1354,-1360.9229,2001.0491,258.0002); // Психушка Bot 4
	SetActorVirtualWorld(BotPears[422], 4);
	BotPears[423] = CreateActor(308, 1219.8785,-1350.2245,2001.0491,357.6178); // Психушка Bot 5
	SetActorVirtualWorld(BotPears[423], 4);
	BotPears[424] = CreateActor(70, 1226.2745,-1411.0952,2001.0491,89.4486); // Психушка Bot 6
	SetActorVirtualWorld(BotPears[424], 4);
	BotPears[425] = CreateActor(71, 1218.0801,-1410.1809,2001.0491,183.2813); // Психушка Bot 7
	SetActorVirtualWorld(BotPears[425], 4);
	BotPears[426] = CreateActor(70, 1223.8677,-1442.9573,2001.0491,1.4010); // Психушка Bot 8
	SetActorVirtualWorld(BotPears[426], 4);
	BotPears[427] = CreateActor(279, -2143.6426,78.1282,35.1633,184.4606); // Пожарное Депо Bot 1
	BotPears[428] = CreateActor(277, -2145.6177,64.1148,35.1633,68.6711); // Пожарное Депо Bot 2
	BotPears[429] = CreateActor(278, -2147.5535,64.6648,35.1633,252.2863); // Пожарное Депо Bot 3
	BotPears[430] = CreateActor(219, -2128.9646,66.1872,1403.3984,186.8929); // Пожарное Депо Bot 4
	SetActorVirtualWorld(BotPears[430], 4);
	BotPears[431] = CreateActor(277, -2128.8323,69.6934,1403.3984,358.9144); // Пожарное Депо Bot 5
	SetActorVirtualWorld(BotPears[431], 4);
	BotPears[432] = CreateActor(279, -2120.2576,60.6968,1403.3984,147.1225); // Пожарное Депо Bot 6
	SetActorVirtualWorld(BotPears[432], 4);
	BotPears[433] = CreateActor(304, -2120.9204,59.4988,1403.3984,328.5442); // Пожарное Депо Bot 7
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
	BotPears[470] = CreateActor(171,1264.6343,1306.6207,1558.2009,275.2307); // Сауна Bot 1 в баре
	SetActorVirtualWorld(BotPears[470], 85);
	BotPears[471] = CreateActor(11,1309.7184,1314.3702,1558.2090,272.7471); // Сауна Bot 1 в баре
	SetActorVirtualWorld(BotPears[471], 85);
	BotPears[475] = CreateActor(164,1265.6527,-49.2240,1000.9280,1.3875); // Отель Bot 1
	SetActorVirtualWorld(BotPears[475], 3);
	BotPears[476] = CreateActor(164,1288.0977,-49.1689,1000.9280,7.3408); // Отель Bot 2
	SetActorVirtualWorld(BotPears[476], 3);
	BotPears[477] = CreateActor(163,1280.0337,-37.1167,1000.9280,181.2190); // Отель Bot 3
	SetActorVirtualWorld(BotPears[477], 3);
	BotPears[478] = CreateActor(189,1280.3707,-47.6048,1000.9280,314.8688); // Отель Bot 4
	SetActorVirtualWorld(BotPears[478], 3);
	BotPears[479] = CreateActor(59,1283.0580,-42.2432,1000.9280,15.6561); // Отель Bot 5
	SetActorVirtualWorld(BotPears[479], 3);
	BotPears[480] = CreateActor(98,1282.6345,-40.7867,1000.9280,194.8844); // Отель Bot 6
	SetActorVirtualWorld(BotPears[480], 3);
	BotPears[481] = CreateActor(141,1274.4423,-46.8282,1000.9280,20.3795); // Отель Bot 7
	SetActorVirtualWorld(BotPears[481], 3);
	BotPears[482] = CreateActor(43,1273.9204,-45.3367,1000.9280,204.5977); // Отель Bot 8
	SetActorVirtualWorld(BotPears[482], 3);
	BotPears[483] = CreateActor(70,1178.8080,-1338.3379,13.8725,272.0269); // ASGH Bot 1
	BotPears[484] = CreateActor(70,2014.5818,-1410.8331,16.9922,153.8991); // ASGH Bot 2
	BotPears[489] = CreateActor(167, 368.9441,-4.4851,1001.8516,181.6134); // Cluckin Bell LV-2 Bot
    SetActorVirtualWorld(BotPears[489], 7);
    BotPears[490] = CreateActor(42, 2858.4438,2213.5381,11.0265,140.1314);// Заправщик LV-3 Bot 1
	BotPears[491] = CreateActor(50, 2859.2239,2221.5581,11.0265,3.3719);// Заправщик LV-3 Bot 2
	BotPears[492] = CreateActor(151, 2867.3760,2215.5996,10.8613,178.8637);// Заправщик LV-3 Bot 3
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
    BotPears[501] = CreateActor(71,1369.7183,-25.3327,1001.0717,2.6003); // Дальнобойщики Bot
    SetActorVirtualWorld(BotPears[501], 11);
	BotPears[502] = CreateActor(141,1631.0111,-2274.5208,13.5732,179.4451); // Аэропорт Bot
	// Боты Лапландии
	if(IsACristmas())
	{
		BotPears[503] = CreateActor(194,741.2751,-3336.9570,3.1684,65.3740);
		BotPears[504] = CreateActor(27,-2105.3413,-2241.7046,30.6250,167.9991);
		BotPears[505] = CreateActor(153,-2097.3953,-2249.5237,30.6250,130.0855);
		BotPears[506] = CreateActor(16,-2098.5735,-2250.3770,30.6250,305.5538);
	}
	BotPears[507] = CreateActor(141,1274.8622,-21.0276,1000.9254,89.6971); // Центр Обмена Bot
    SetActorVirtualWorld(BotPears[507], 100);
    BotPears[508] = CreateActor(150,1274.8622,-23.4229,1000.9254,87.1905); // Центр Обмена Bot
    SetActorVirtualWorld(BotPears[508], 100);
    BotPears[509] = CreateActor(71,1255.7573,-24.2271,1000.9254,271.5772); // Центр Обмена Bot
    SetActorVirtualWorld(BotPears[509], 100);
    BotPears[510] = CreateActor(71,1394.2056,-31.3340,1000.8779,335.8245); // Бизнес Центр
    SetActorVirtualWorld(BotPears[510], 237);
    BotPears[511] = CreateActor(59,1400.3665,-30.2018,1000.8779,297.4525); // Бизнес Центр
    SetActorVirtualWorld(BotPears[511], 237);
    BotPears[512] = CreateActor(147,1401.7723,-29.2993,1000.8779,122.6343); // Бизнес Центр
    SetActorVirtualWorld(BotPears[512], 237);
    BotPears[513] = CreateActor(141,-1753.0793,885.3437,105.0207,182.7715); // Бизнес Центр
    SetActorVirtualWorld(BotPears[513], 236);
    BotPears[514] = CreateActor(71,-1766.3875,890.2181,105.0248,270.9872); // Бизнес Центр
    SetActorVirtualWorld(BotPears[514], 236);
    BotPears[515] = CreateActor(71,-1739.9305,877.7605,105.0148,91.1557); // Бизнес Центр
    SetActorVirtualWorld(BotPears[515], 236);
    BotPears[516] = CreateActor(45, 565.910583,-1809.059204,6.062500,97.0); // Бот Регистрация
    BotPears[517] = CreateActor(140, 564.8656,-1809.2654,6.0625,280.8233); // Бот Регистрация

	LoadZoneBot();
	BotInfo[107] = 0;
	BotInfo[108] = 0;
	LoadAnimBot(5000);
	for(new i=0; i<MAX_BOTS; i++) SetActorInvulnerable(BotPears[i], 0);
	return 1;
}
stock LoadZoneBot()
{
	new skini86[3],skini105[3],skini30[3],skini43[3],skini18[3],skini5[3],skini82[3],skini66[3],strFromFile2[128]; // Переменная Для Скинов Территорий
	// Территория 86
	if(GZInfo[86][gFrakVlad] == 13) { skini86[0] = 106; skini86[1] = 107; skini86[2] = 105; } // Grove
	else if(GZInfo[86][gFrakVlad] == 14) { skini86[0] = 104; skini86[1] = 102; skini86[2] = 103; } // Ballas
	else if(GZInfo[86][gFrakVlad] == 15) { skini86[0] = 108; skini86[1] = 109; skini86[2] = 110; } // Vagos
	else if(GZInfo[86][gFrakVlad] == 16) { skini86[0] = 115; skini86[1] = 116; skini86[2] = 114; } // Aztecas
	else { skini86[0] = 7; skini86[1] = 6; skini86[2] = 2; } // Others
	BotPears[446] = CreateActor(skini86[0], 1996.3341,-1282.9259,23.9696,354.1532); // 8 +3dtext
	BotPears[447] = CreateActor(skini86[1], 1997.4559,-1282.0037,23.9761,102.2542); // 8
	BotPears[448] = CreateActor(skini86[2], 1995.1650,-1281.5782,23.9791,239.1823); // 8
	format(strFromFile2,sizeof(strFromFile2),"{ff9000}Торговый Центр\n{cccccc}Под Контролем: %s",frakName[GZInfo[86][gFrakVlad]]);
	UpdateDynamic3DTextLabelText(ZoneLabel[7],0xA9C4E4FF,strFromFile2);

	// Территория 105
	if(GZInfo[105][gFrakVlad] == 13) { skini105[0] = 106; skini105[1] = 107; skini105[2] = 105; } // Grove
	else if(GZInfo[105][gFrakVlad] == 14) { skini105[0] = 104; skini105[1] = 102; skini105[2] = 103; } // Ballas
	else if(GZInfo[105][gFrakVlad] == 15) { skini105[0] = 108; skini105[1] = 109; skini105[2] = 110; } // Vagos
	else if(GZInfo[105][gFrakVlad] == 16) { skini105[0] = 115; skini105[1] = 116; skini105[2] = 114; } // Aztecas
	else { skini105[0] = 7; skini105[1] = 6; skini105[2] = 2; } // Others
	BotPears[449] = CreateActor(skini105[0], 2679.5576,-1095.1775,69.2969,358.0816); // 7 +3dtext
	BotPears[450] = CreateActor(skini105[1], 2680.4319,-1094.5328,69.2969,107.5809); // 7
	BotPears[451] = CreateActor(skini105[2], 2678.6653,-1094.3158,69.2969,222.5755); // 7
	format(strFromFile2,sizeof(strFromFile2),"{ff9000}Торговая Точка\n{cccccc}Под Контролем: %s",frakName[GZInfo[105][gFrakVlad]]);
	UpdateDynamic3DTextLabelText(ZoneLabel[6],0xA9C4E4FF,strFromFile2);

	// Территория 30
	if(GZInfo[30][gFrakVlad] == 13) { skini30[0] = 106; skini30[1] = 107; skini30[2] = 105; } // Grove
	else if(GZInfo[30][gFrakVlad] == 14) { skini30[0] = 104; skini30[1] = 102; skini30[2] = 103; } // Ballas
	else if(GZInfo[30][gFrakVlad] == 15) { skini30[0] = 108; skini30[1] = 109; skini30[2] = 110; } // Vagos
	else if(GZInfo[30][gFrakVlad] == 16) { skini30[0] = 115; skini30[1] = 116; skini30[2] = 114; } // Aztecas
	else { skini30[0] = 7; skini30[1] = 6; skini30[2] = 2; } // Others
	BotPears[452] = CreateActor(skini30[0], 2011.2177,-2098.1443,13.5469,181.8417); // 6 +3dtext
	BotPears[453] = CreateActor(skini30[1], 2010.4384,-2099.5334,13.5469,317.8296); // 6
	BotPears[454] = CreateActor(skini30[2], 2012.1031,-2099.4397,13.5469,56.2171); // 6
	format(strFromFile2,sizeof(strFromFile2),"{ff9000}Склады\n{cccccc}Под Контролем: %s",frakName[GZInfo[30][gFrakVlad]]);
	UpdateDynamic3DTextLabelText(ZoneLabel[5],0xA9C4E4FF,strFromFile2);

	// Территория 43
	if(GZInfo[43][gFrakVlad] == 13) { skini43[0] = 106; skini43[1] = 107; skini43[2] = 105; } // Grove
	else if(GZInfo[43][gFrakVlad] == 14) { skini43[0] = 104; skini43[1] = 102; skini43[2] = 103; } // Ballas
	else if(GZInfo[43][gFrakVlad] == 15) { skini43[0] = 108; skini43[1] = 109; skini43[2] = 110; } // Vagos
	else if(GZInfo[43][gFrakVlad] == 16) { skini43[0] = 115; skini43[1] = 116; skini43[2] = 114; } // Aztecas
	else { skini43[0] = 7; skini43[1] = 6; skini43[2] = 2; } // Others
	BotPears[455] = CreateActor(skini43[0], 2070.0815,-1775.6731,13.5574,271.9375); // 5 +3dtext
	BotPears[456] = CreateActor(skini43[1], 2071.2263,-1776.0580,13.5583,72.5106); // 5
	BotPears[457] = CreateActor(skini43[2], 2071.2371,-1774.4279,13.5563,142.0712); // 5
	format(strFromFile2,sizeof(strFromFile2),"{ff9000}Тату Салон\n{cccccc}Под Контролем: %s",frakName[GZInfo[43][gFrakVlad]]);
	UpdateDynamic3DTextLabelText(ZoneLabel[4],0xA9C4E4FF,strFromFile2);

	// Территория 18
	if(GZInfo[18][gFrakVlad] == 13) { skini18[0] = 106; skini18[1] = 107; skini18[2] = 105; } // Grove
	else if(GZInfo[18][gFrakVlad] == 14) { skini18[0] = 104; skini18[1] = 102; skini18[2] = 103; } // Ballas
	else if(GZInfo[18][gFrakVlad] == 15) { skini18[0] = 108; skini18[1] = 109; skini18[2] = 110; } // Vagos
	else if(GZInfo[18][gFrakVlad] == 16) { skini18[0] = 115; skini18[1] = 116; skini18[2] = 114; } // Aztecas
	else { skini18[0] = 7; skini18[1] = 6; skini18[2] = 2; } // Others
	BotPears[458] = CreateActor(skini18[0], 2786.0500,-2058.2913,11.8466,359.9850); // 4 +3dtext
	BotPears[459] = CreateActor(skini18[1], 2787.0562,-2057.2314,11.8190,123.8978); // 4
	BotPears[460] = CreateActor(skini18[2], 2785.3157,-2057.2170,11.8667,230.4321); // 4
	format(strFromFile2,sizeof(strFromFile2),"{ff9000}Электростанция\n{cccccc}Под Контролем: %s",frakName[GZInfo[18][gFrakVlad]]);
	UpdateDynamic3DTextLabelText(ZoneLabel[3],0xA9C4E4FF,strFromFile2);

	// Территория 5
	if(GZInfo[5][gFrakVlad] == 13) { skini5[0] = 106; skini5[1] = 107; skini5[2] = 105; } // Grove
	else if(GZInfo[5][gFrakVlad] == 14) { skini5[0] = 104; skini5[1] = 102; skini5[2] = 103; } // Ballas
	else if(GZInfo[5][gFrakVlad] == 15) { skini5[0] = 108; skini5[1] = 109; skini5[2] = 110; } // Vagos
	else if(GZInfo[5][gFrakVlad] == 16) { skini5[0] = 115; skini5[1] = 116; skini5[2] = 114; } // Aztecas
	else { skini5[0] = 7; skini5[1] = 6; skini5[2] = 2; } // Others
	BotPears[461] = CreateActor(skini5[0], 2422.7034,-1773.7966,13.5391,91.1659); // 3 +3dtext
	BotPears[462] = CreateActor(skini5[1], 2421.2622,-1773.1425,13.5391,242.9656); // 3
	BotPears[463] = CreateActor(skini5[2], 2421.7178,-1774.9487,13.5391,346.6800); // 3
	format(strFromFile2,sizeof(strFromFile2),"{ff9000}Оружейный Магазин\n{cccccc}Под Контролем: %s",frakName[GZInfo[5][gFrakVlad]]);
	UpdateDynamic3DTextLabelText(ZoneLabel[2],0xA9C4E4FF,strFromFile2);

	// Территория 82
	if(GZInfo[82][gFrakVlad] == 13) { skini82[0] = 106; skini82[1] = 107; skini82[2] = 105; } // Grove
	else if(GZInfo[82][gFrakVlad] == 14) { skini82[0] = 104; skini82[1] = 102; skini82[2] = 103; } // Ballas
	else if(GZInfo[82][gFrakVlad] == 15) { skini82[0] = 108; skini82[1] = 109; skini82[2] = 110; } // Vagos
	else if(GZInfo[82][gFrakVlad] == 16) { skini82[0] = 115; skini82[1] = 116; skini82[2] = 114; } // Aztecas
	else { skini82[0] = 7; skini82[1] = 6; skini82[2] = 2; } // Others
	BotPears[464] = CreateActor(skini82[0], 2424.7566,-1225.2189,25.1862,178.5867); // 2 +3dtext
	BotPears[465] = CreateActor(skini82[1], 2423.7466,-1226.0376,25.1161,297.7993); // 2
	BotPears[466] = CreateActor(skini82[2], 2425.7302,-1226.6124,25.1281,45.2736); // 2
	format(strFromFile2,sizeof(strFromFile2),"{ff9000}Стриптиз Клуб\n{cccccc}Под Контролем: %s",frakName[GZInfo[82][gFrakVlad]]);
	UpdateDynamic3DTextLabelText(ZoneLabel[1],0xA9C4E4FF,strFromFile2);

	// Территория 66
	if(GZInfo[66][gFrakVlad] == 13) { skini66[0] = 106; skini66[1] = 107; skini66[2] = 105; } // Grove
	else if(GZInfo[66][gFrakVlad] == 14) { skini66[0] = 104; skini66[1] = 102; skini66[2] = 103; } // Ballas
	else if(GZInfo[66][gFrakVlad] == 15) { skini66[0] = 108; skini66[1] = 109; skini66[2] = 110; } // Vagos
	else if(GZInfo[66][gFrakVlad] == 16) { skini66[0] = 115; skini66[1] = 116; skini66[2] = 114; } // Aztecas
	else { skini66[0] = 7; skini66[1] = 6; skini66[2] = 2; } // Others
	BotPears[467] = CreateActor(skini66[0], 2440.3450,-1467.8866,24.0000,91.8160); // 1 +3dtext
	BotPears[468] = CreateActor(skini66[1], 2439.4543,-1466.9581,24.0000,193.7951); // 1
	BotPears[469] = CreateActor(skini66[2], 2439.3042,-1468.7391,24.0000,332.2900); // 1
	format(strFromFile2,sizeof(strFromFile2),"{ff9000}Автомойка\n{cccccc}Под Контролем: %s",frakName[GZInfo[66][gFrakVlad]]);
	UpdateDynamic3DTextLabelText(ZoneLabel[0],0xA9C4E4FF,strFromFile2);

	LoadAnimBot(5001);
	return 1;
}

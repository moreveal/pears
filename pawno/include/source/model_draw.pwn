// Координаты отображения аксессуара в текстдраве
stock GetModelTextDraw(model, &Float:x, &Float:y, &Float:z, &Float:s, &findIt)
{
    findIt = 1;
	switch(model)
	{
		case 18891..18905: x = 83.0, y = 90.0, z = 0.0, s = 1.0;
		case 18911..18920: x = 0.0, y = -90.0, z = -90.0, s = 1.0;
		case 18921..18925: x = -100.0, y = -30.0, z = 283.0, s = 1.0;
		case 18939..18943: x = -100.0, y = 130.0, z = 299.0, s = 1.0;
		case 19352, 19487, 19801, 19320: x = 0.0, y = 0.0, z = 52.0, s = 1.7;
		case 11704, 19468, 18955..18961, 18964..18974, 19064..19066, 19036..19038: x = 0.0, y = 0.0, z = 52.0, s = 1.0;
		case 18926..18935, 19161, 19162, 19098, 18944..18951: x = -100.0, y = -30.0, z = 272.0, s = 1.0;
		case 19006..19035, 19138, 19139, 19140: x = 0.0, y = 0.0, z = 110.0, s = 1.0;
		case 18906..18910: x = -100.0, y = -30.0, z = 183.0, s = 1.0;
		case 2782: x = -20.0, y = 0.0, z = 170.0, s = 1.0; // Ракушка
		case 19078, 19079: x = 0.0, y = -90.0, z = 0.0, s = 1.0; // Попугай
		case 2045: x = 0.0, y = 30.0, z = -90.0, s = 1.0;
		case 19590: x = 0.0, y = 30.0, z = 90.0, s = 1.0;
		case 2404,2405,2406,19559: x = 0.0, y = 0.0, z = 180.0, s = 1.0;
		case 902: x = 90.0, y = 0.0, z = 0.0, s = 1.0; // Морская Звезда
		case 1599,1600,19085,11712: x = 0.0, y = 0.0, z = 90.0, s = 1.0; // Синяя и Жёлтая Рыбка, Повязка на Глаз
		case 18632,2484,804,650,2806,18890,19569: x = 0.0, y = 0.0, z = 0.0, s = 1.0;
		case 1828: x = 90.0, y = 0.0, z = -90.0, s = 1.0;
		case 2061: x = 0.0, y = 0.0, z = 0.0, s = 1.5;

		case 19578: x = 90.0000, y = 28.0000, z = -40.0000, s = 0.9599;
		case 1240: x = 0.0000, y = 0.0000, z = 26.0000, s = 1.2799;
		case 14666: x = 0.0000, y = 0.0000, z = 102.0000, s = 1.1799;
		case 19054: x = -16.0000, y = 0.0000, z = -28.0000, s = 1.3999;
		case 3014: x = -20.0000, y = 0.0000, z = -32.0000, s = 1.2599;
		case 2034: x = 90.0000, y = 20.0000, z = 0.0000, s = 0.9600;
		case 2035: x = 90.0000, y = 20.0000, z = 0.0000, s = 0.9599;
		case 2036: x = 90.0000, y = 20.0000, z = 0.0000, s = 0.9599;
		case 331: x = 0.0000, y = -44.0000, z = 0.0000, s = 0.6999;
		case 333: x = 0.0000, y = -44.0000, z = 0.0000, s = 1.0000;
		case 334: x = 0.0000, y = -44.0000, z = 0.0000, s = 1.0000;
		case 335: x = 0.0000, y = -44.0000, z = 0.0000, s = 1.0199;
		case 336: x = 0.0000, y = -44.0000, z = 0.0000, s = 1.7400;
		case 337: x = 32.0000, y = -48.0000, z = -28.0000, s = 1.5800;
		case 338: x = 0.0000, y = -44.0000, z = 0.0000, s = 1.3200;
		case 339: x = 0.0000, y = -44.0000, z = 0.0000, s = 1.7400;
		case 341: x = -18.0000, y = 0.0000, z = 76.0000, s = 2.0599;
		case 321: x = 0.0000, y = -44.0000, z = 0.0000, s = 1.2400;
		case 322: x = 0.0000, y = -44.0000, z = 0.0000, s = 0.7200;
		case 323: x = 0.0000, y = -44.0000, z = 0.0000, s = 1.0199;
		case 324: x = 0.0000, y = -18.0000, z = 0.0000, s = 0.8600;
		case 325: x = 0.0000, y = -36.0000, z = 0.0000, s = 1.6200;
		case 326: x = 0.0000, y = -34.0000, z = 0.0000, s = 1.4400;
		case 342: x = 0.0000, y = 0.0000, z = 54.0000, s = 0.6999;
		case 343: x = 0.0000, y = 0.0000, z = 180.0000, s = 0.6600;
		case 344: x = 0.0000, y = 0.0000, z = 0.0000, s = 0.9200;
		case 346: x = 0.0000, y = -20.0000, z = 0.0000, s = 0.8000;
		case 347: x = 0.0000, y = -20.0000, z = 0.0000, s = 1.0000;
		case 348: x = 0.0000, y = -20.0000, z = 0.0000, s = 1.0000;
		case 349: x = 0.0000, y = 0.0000, z = 58.0000, s = 2.3599;
		case 350: x = 0.0000, y = 0.0000, z = 60.0000, s = 1.7200;
		case 351: x = 0.0000, y = 0.0000, z = 68.0000, s = 2.0000;
		case 352: x = 0.0000, y = 0.0000, z = 14.0000, s = 1.0000;
		case 353: x = 0.0000, y = 0.0000, z = 58.0000, s = 1.4600;
		case 355: x = 0.0000, y = -18.0000, z = 56.0000, s = 2.1600;
		case 356: x = 0.0000, y = -14.0000, z = 64.0000, s = 1.8999;
		case 357: x = 0.0000, y = -4.0000, z = 60.0000, s = 1.9199;
		case 372: x = 0.0000, y = -8.0000, z = 56.0000, s = 1.2199;
		case 358: x = 0.0000, y = 0.0000, z = 64.0000, s = 1.5999;
		case 359: x = 0.0000, y = 0.0000, z = 54.0000, s = 1.5999;
		case 360: x = 0.0000, y = 0.0000, z = 50.0000, s = 1.5599;
		case 361: x = -10.0000, y = 0.0000, z = 74.0000, s = 2.7399;
		case 362: x = -6.0000, y = 0.0000, z = 74.0000, s = 2.8599;
		case 363: x = 0.0000, y = 0.0000, z = 74.0000, s = 1.6199;
		case 364: x = -46.0000, y = -10.0000, z = -70.0000, s = 1.0000;
		case 365: x = 0.0000, y = 0.0000, z = 80.0000, s = 1.0000;
		case 366: x = -26.0000, y = -8.0000, z = 68.0000, s = 2.0599;
		case 367: x = 0.0000, y = 0.0000, z = 50.0000, s = 1.0000;
		case 368: x = 0.0000, y = -90.0000, z = 0.0000, s = 0.7800;
		case 369: x = 0.0000, y = -90.0000, z = 0.0000, s = 0.7800;
		case 370: x = 0.0000, y = 0.0000, z = -16.0000, s = 1.6799;
		case 371: x = 0.0000, y = 0.0000, z = -14.0000, s = 1.4599;
		case 373: x = 42.0000, y = -58.0000, z = 72.0000, s = 1.9599;
		
		case 19579: x = -10.0000, y = 0.0000, z = 40.0000, s = 1.0000;
		case 2710: x = -10.0000, y = 0.0000, z = 140.0000, s = 1.0000;
		case 1520: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19473: x = 0.0000, y = 0.0000, z = 0.0000, s = 0.8999;
		case 1241: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 1578: x = -40.0000, y = 5.0000, z = -20.0000, s = 1.5000;
		case 1279: x = -20.0000, y = 0.0000, z = 50.0000, s = 1.0000;
		case 11738: x = -20.0000, y = 0.0000, z = 40.0000, s = 1.0000;
		case 1650: x = -10.0000, y = 0.0000, z = 10.0000, s = 1.0000;
		case 19515: x = -10.0000, y = -90.0000, z = 10.0000, s = 1.0000;
		case 1654: x = -10.0000, y = 0.0000, z = 10.0000, s = 1.0000;
		case 19088: x = 0.0000, y = 0.0000, z = 0.0000, s = 0.8999;
		case 1486: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 2057: x = -20.0000, y = 0.0000, z = 30.0000, s = 1.0000;
		case 19897: x = 90.0000, y = 0.0000, z = 0.0000, s = 0.6999;
		case 19142: x = 0.0000, y = -90.0000, z = 0.0000, s = 1.0000;
		case 1455: x = -35.0000, y = 0.0000, z = -90.0000, s = 1.0000;
		case 18644: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19942: x = 0.0000, y = 0.0000, z = -40.0000, s = 1.0000;
		case 2060: x = 90.0000, y = 0.0000, z = 90.0000, s = 1.0000;
		case 19308: x = 0.0000, y = 0.0000, z = 90.0000, s = 1.0000;
		case 1212: x = -10.0000, y = 0.0000, z = 40.0000, s = 1.0000;
		case 18872: x = 90.0000, y = 180.0000, z = 0.0000, s = 1.0000;
		case 18641: x = 70.0000, y = -40.0000, z = 0.0000, s = 1.0000;
		case 1314: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19824: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19819: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19921: x = -20.0000, y = 0.0000, z = 140.0000, s = 1.0000;
		case 3016: x = -15.0000, y = 0.0000, z = 150.0000, s = 1.0000;
		case 19616: x = 0.0000, y = 0.0000, z = 180.0000, s = 1.0000;
		case 19893: x = 0.0000, y = 0.0000, z = 170.0000, s = 1.0000;
		case 18642: x = 0.0000, y = 180.0000, z = 10.0000, s = 1.0000;
		case 19171: x = 90.0000, y = 180.0000, z = 360.0000, s = 1.0000;
		case 473: x = -10.0000, y = 0.0000, z = -20.0000, s = 1.0000;
		case 2969: x = -20.0000, y = 0.0000, z = 200.0000, s = 1.0000;
		case 2803: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 1581: x = 0.0000, y = 0.0000, z = 180.0000, s = 1.0000;
		case 19573: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19998: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19882: x = 90.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19630: x = 0.0000, y = 0.0000, z = 180.0000, s = 1.0000;
		case 3930: x = 0.0000, y = 0.0000, z = 180.0000, s = 1.0000;
		case 3931: x = 0.0000, y = 0.0000, z = 180.0000, s = 1.0000;
		case 2040: x = 0.0000, y = 0.0000, z = 180.0000, s = 1.0000;
		case 2976: x = 0.0000, y = 0.0000, z = 180.0000, s = 1.0000;
		case 2826: x = -90.0000, y = 0.0000, z = 180.0000, s = 1.0000;
		case 2894: x = 90.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 1265: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.6000;
		case 2908: x = -90.0000, y = 90.0000, z = 0.0000, s = 1.0000;
		case 11747: x = -35.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 11748: x = -90.0000, y = 0.0000, z = 180.0000, s = 1.0000;
		case 19562: x = 0.0000, y = 0.0000, z = -25.0000, s = 1.0000;
		case 19575: x = 0.0000, y = -30.0000, z = 0.0000, s = 1.0000;
		case 18634: x = 0.0000, y = 0.0000, z = -25.0000, s = 1.0000;
		case 19169: x = 90.0000, y = 180.0000, z = 360.0000, s = 1.0000;
		case 14705: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 2709: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19941: x = 0.0000, y = 0.0000, z = 30.0000, s = 1.0000;
		case 1276: x = 0.0000, y = 0.0000, z = 30.0000, s = 1.0000;
		case 1667: x = 0.0000, y = 0.0000, z = 30.0000, s = 1.0000;
		case 19583: x = 90.0000, y = 0.0000, z = 90.0000, s = 1.0000;
		case 19576: x = 0.0000, y = 0.0000, z = 30.0000, s = 1.0000;
		case 19574: x = 0.0000, y = 0.0000, z = 30.0000, s = 1.0000;
		case 19577: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 1644: x = 90.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 2752: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 1852: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.7000;
		case 1668: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19822: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19821: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19820: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19823: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 1544: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 1543: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 1951: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 2601: x = 0.0000, y = 0.0000, z = -90.0000, s = 1.0000;
		case 19835: x = 0.0000, y = 0.0000, z = 90.0000, s = 1.0000;
		case 19818: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 1666: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 1546: x = 0.0000, y = 0.0000, z = 90.0000, s = 1.0000;
		case 2703: x = -90.0000, y = 70.0000, z = 0.0000, s = 1.0000;
		case 2768: x = 0.0000, y = 0.0000, z = 200.0000, s = 1.0000;
		case 2769: x = -20.0000, y = 0.0000, z = -20.0000, s = 1.0000;
		case 2212: x = -50.0000, y = -40.0000, z = 150.0000, s = 1.0000;
		case 2213: x = -50.0000, y = -40.0000, z = 150.0000, s = 1.0000;
		case 2214: x = -50.0000, y = -40.0000, z = 150.0000, s = 1.0000;
		case 2215: x = -50.0000, y = -40.0000, z = 150.0000, s = 1.0000;
		case 2216: x = -50.0000, y = -40.0000, z = 150.0000, s = 1.0000;
		case 2217: x = -50.0000, y = -40.0000, z = 150.0000, s = 1.0000;
		case 2221: x = -60.0000, y = 0.0000, z = -10.0000, s = 1.2000;
		case 2222: x = -60.0000, y = 0.0000, z = -10.0000, s = 1.2000;
		case 2223: x = -60.0000, y = 0.0000, z = -10.0000, s = 1.2000;
		case 2353: x = -50.0000, y = -40.0000, z = 150.0000, s = 1.0000;
		case 2354: x = -50.0000, y = -40.0000, z = 150.0000, s = 1.0000;
		case 3027: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19346: x = -30.0000, y = 0.0000, z = 120.0000, s = 1.7999;
		case 19625: x = -30.0000, y = 0.0000, z = 150.0000, s = 1.0000;
		case 3044: x = 0.0000, y = 0.0000, z = 130.0000, s = 1.7999;
		case 2684: x = 0.0000, y = 0.0000, z = 180.0000, s = 1.0000;
		case 19525: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 11739: x = -30.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19571: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19580: x = -90.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 2702: x = 0.0000, y = -90.0000, z = 40.0000, s = 1.0000;
		case 19560: x = -90.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19582: x = 90.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19883: x = -30.0000, y = 0.0000, z = -30.0000, s = 1.0000;
		case 19563: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19564: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19572: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 1614: x = 0.0000, y = 0.0000, z = 90.0000, s = 1.0000;
		case 1616: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 1622: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 3465: x = 0.0000, y = 0.0000, z = 0.0000, s = 1.0000;
		case 19106: x = 74.0000, y = -60.0000, z = 90.0000, s = 0.7400; // Каска
		case 18954: x = -8.0000, y = -90.0000, z = 14.0000, s = 0.7200; // Шапка серая
		case 1798: x = -18.0000, y = 0.0000, z = 212.0000, s = 0.5200;
		case 1797: x = -18.0000, y = 0.0000, z = 209.0000, s = 0.6200;
		case 1764: x = -28.0000, y = 2.0000, z = 309.0000, s = 1.0000;
		case 2528: x = -14.0000, y = 0.0000, z = -145.0000, s = 1.3399;
		case 19128: x = -20.0000, y = 0.0000, z = 38.0000, s = 1.1599;
		case 3089: x = 0.0000, y = 0.0000, z = 18.0000, s = 1.2799;
		case 1444: x = 0.0000, y = 0.0000, z = 30.0000, s = 1.2399;


		default: x = 0.0, y = 0.0, z = 0.0, s = 1.0, findIt = 0;
	}
    return 1;
}


#define MAX_EDITMODEL 50

new PlayerText:DynamicTextDraw[15][MAX_REALPLAYERS];
new typeDynamicTextDraw[MAX_REALPLAYERS];

new editModelId[MAX_REALPLAYERS]; // ID Модели, которую редактируем
new editModelAxis[MAX_REALPLAYERS]; // Ось по которой редактируем модель
new Float:editModelPos[4][MAX_REALPLAYERS]; // Координаты отображения

enum editmInfo
{
	editId,
    editModel,
    Float:editPos[4]
}
new EditModelInfo[MAX_EDITMODEL][editmInfo];
new editModelQuan;

CMD:editmodel(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду [ 10+ Adm ]");
    if(sscanf(params, "i",params[0])) return ErrorText(playerid, "{FF6347}/editmodel ID Модели объекта");
    if(params[0] >= MAX_OBJECT_MODEL_ID || params[0] < 321) return format(store,sizeof(store),"{FF6347}ID Объекта не меньше 321 и не больше %d", MAX_OBJECT_MODEL_ID), ErrorMessage(playerid, store);
    if(editModelQuan >= MAX_EDITMODEL) return format(store,sizeof(store),"{FF6347}Лимит отредактированных объектов %d\n{cccccc}Дождитесь когда разработчик перенесёт их в stock мода сервера", MAX_EDITMODEL), ErrorMessage(playerid, store);
    
    // Закрываем использование компьютера или ноутбука
    if(Komputer[playerid] == 2) exitkomp(playerid, 2);
    
    // Делаем проверку на открытое меню
    if(OnlineInfo[playerid][oShowInterface] > 0 && OnlineInfo[playerid][oShowInterface] != 15) return ErrorMessage(playerid, "{FF6347}Закройте открытое меню [ Инвентарь, меню покупок, смартфон и так далее ]");
    
    new Float:modelPos[4], findModel;
    GetModelTextDraw(params[0], modelPos[0], modelPos[1], modelPos[2], modelPos[3], findModel);
    if(findModel == 1) return ErrorText(playerid, "{FF6347}Этот объект уже добавлен в общий stock и не нуждается в редактировании"), AccessorySetting(playerid, DP[3][playerid]);
	
    GameTextForPlayer(playerid," ",1000,3);
	DP[4][playerid] = 0;
    editModelId[playerid] = params[0]; // Сохраняем ID редактируемой модели
    editModelAxis[playerid] = 0; // Редактируем по оси X (0 x, 1 y, 2 z, 3 zoom)
    
	new findIt = -1;
    for(new i = 0; i < MAX_EDITMODEL; i++) // Ищем эту модель, вдруг она есть в списке на редактирование
    {
        if(EditModelInfo[i][editModel] == editModelId[playerid])
        {
            findIt = i;
            editModelPos[0][playerid] = EditModelInfo[i][editPos][0];
			editModelPos[1][playerid] = EditModelInfo[i][editPos][1];
			editModelPos[2][playerid] = EditModelInfo[i][editPos][2];
			editModelPos[3][playerid] = EditModelInfo[i][editPos][3];
        }
    }
    if(findIt == -1) // Если не нашли, сбрасываем координаты
    {
        editModelPos[0][playerid] = 0.0;
		editModelPos[1][playerid] = 0.0;
		editModelPos[2][playerid] = 0.0;
		editModelPos[3][playerid] = 1.0;
    }
    
    if(typeDynamicTextDraw[playerid] == 0) CreateEditModelTextDraw(playerid); // Создаём текстдравы редактора
    ShowEditModelMenu(playerid); // Показываем меню редактора
    UpdateColorButtonEditModelDraw(playerid, 0);
    SelectTextDraw(playerid,0x666666AA); // Активируем кликабельность (мышка)
	return 1;
}

CMD:exportmodel(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду [ 10+ Adm ]");
	if(editModelQuan <= 0) return ErrorMessage(playerid, "{FF6347}Нет отредактированных объектов для экспорта");
	
	new year, month, day;
	getdate(year, month, day); // Получаем дату
	new hours, minuite, second;
	gettime(hours,minuite,second); // Получаем время
	
	new filename[64], quanExport;
	format(filename, 64, "EditModel_%02d.%02d.%d_%02d %02d %02d.txt", day, month, year, hours, minuite, second); // Называем файл по дате и времени экспорта
	
	format(lines,sizeof(lines),""); // Очищаем Lines
	for(new i = 0; i < MAX_EDITMODEL; i++)
    {
        if(EditModelInfo[i][editModel] > 0)
        {
            // Вносим информацию в строку
        	format(line,sizeof(line),"case %d: x = %.4f, y = %.4f, z = %.4f, s = %.4f;\r\n",EditModelInfo[i][editModel], EditModelInfo[i][editPos][0], EditModelInfo[i][editPos][1], EditModelInfo[i][editPos][2], EditModelInfo[i][editPos][3]), strcat(lines,line);

			// Очищаем переменные
			EditModelInfo[i][editModel] = 0;
        	EditModelInfo[i][editPos][0] = 0.0;
        	EditModelInfo[i][editPos][1] = 0.0;
        	EditModelInfo[i][editPos][2] = 0.0;
        	EditModelInfo[i][editPos][3] = 0.0;
        	
        	editModelQuan --; // Вычитаем сохранённую модель
         	SaveEditModel(i); // Сохраняем результат
         	
         	quanExport ++;
       	}
	}
	new File:File = fopen(filename, io_write); // Открываем или создаём этот файл
	fwrite(File, lines); // Записываем все строки в файл
	fclose(File); // Закрываем файл
	
	format(store,sizeof(store),"{99ff66}Экспортировано %d моделей\n{cccccc}Файл: %s", quanExport, filename);
	SuccessMessage(playerid, store);
	
	AdminLog("exportmodel", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", quanExport, "Экспортировал модели");
	return 1;
}

stock SaveEditModelTextDraw(playerid)
{
    SetPVarInt(playerid,"afmysql",GetPVarInt(playerid,"afmysql")+1);
	if(GetPVarInt(playerid,"afmysql") >= 5)
	{
		SendClientMessage(playerid, COLOR_GREEN,"* Не флуди!");
		ShowDialog(playerid,11001,DIALOG_STYLE_MSGBOX,"{ff0000}****  {FFFFFF}*[АнтиФлуд]*  {ff0000}****","{ff0000}******** {ffffff}Не флуди! {ff0000}********","•","");
		return 1;
	}

    if(editModelQuan >= MAX_EDITMODEL) return format(store,sizeof(store),"{FF6347}Лимит отредактированных объектов %d\n{cccccc}Дождитесь когда разработчик перенесёт их в stock мода сервера", MAX_EDITMODEL), ErrorMessage(playerid, store);

	new findIt = -1, noFind;
    for(new i = 0; i < MAX_EDITMODEL; i++)
    {
        if(EditModelInfo[i][editModel] == editModelId[playerid])
        {
            findIt = i;
            if(EditModelInfo[i][editPos][0] != editModelPos[0][playerid] || EditModelInfo[i][editPos][1] != editModelPos[1][playerid] || EditModelInfo[i][editPos][2] != editModelPos[2][playerid] || EditModelInfo[i][editPos][3] != editModelPos[3][playerid])
            {
	            EditModelInfo[i][editPos][0] = editModelPos[0][playerid];
	            EditModelInfo[i][editPos][1] = editModelPos[1][playerid];
	            EditModelInfo[i][editPos][2] = editModelPos[2][playerid];
	            EditModelInfo[i][editPos][3] = editModelPos[3][playerid];
	            SaveEditModel(i);
            }
            else ErrorMessage(playerid, "{FF6347}Вы не внесли изменения, чтобы их сохранять"), noFind = 1;
			break;
        }
    }
    if(findIt == -1)
    {
	    for(new i = 0; i < MAX_EDITMODEL; i++)
	    {
	        if(EditModelInfo[i][editModel] == 0)
	        {
	            EditModelInfo[i][editModel] = editModelId[playerid];
	            EditModelInfo[i][editPos][0] = editModelPos[0][playerid];
	            EditModelInfo[i][editPos][1] = editModelPos[1][playerid];
	            EditModelInfo[i][editPos][2] = editModelPos[2][playerid];
	            EditModelInfo[i][editPos][3] = editModelPos[3][playerid];
	            editModelQuan ++;
	            SaveEditModel(i);
				break;
	        }
	    }
    }
    if(noFind == 0) SuccessMessage(playerid, "{99ff66}Отображение текстдрава сохранено\n{cccccc}Разработчик внесёт это изменение в stock мода в ближайшем обновлении: /exportmodel");
	return 1;
}

forward LoadEditModelTextDraw(); // Загрузка сохранённых переменных из базы
public LoadEditModelTextDraw()
{
	new rows, time = GetTickCount();
	cache_get_row_count(rows);
	for(new f; f < rows; ++f)
	{
    	cache_get_value_name_int(f, "newid", EditModelInfo[f][editId]);
    	cache_get_value_name_int(f, "editModel", EditModelInfo[f][editModel]);
		cache_get_value_name_float(f, "editPos0", EditModelInfo[f][editPos][0]);
		cache_get_value_name_float(f, "editPos1", EditModelInfo[f][editPos][1]);
		cache_get_value_name_float(f, "editPos2", EditModelInfo[f][editPos][2]);
		cache_get_value_name_float(f, "editPos3", EditModelInfo[f][editPos][3]);
		if(EditModelInfo[f][editModel] > 0) editModelQuan ++;
	}
	printf("[MODE]: Редактор Моделей Текстдравов [%d/%d Quan][%d ms]", editModelQuan, rows, GetTickCount() - time);
	return 1;
}

stock SaveEditModel(i) // Обновляем или добавляем строку об аксессуаре
{
	format(big_query, sizeof(big_query), "UPDATE `editModel` SET `editModel`='%d',`editPos0`='%f',`editPos1`='%f',`editPos2`='%f',`editPos3`='%f'  WHERE `newid` = '%d'",
	EditModelInfo[i][editModel], EditModelInfo[i][editPos][0], EditModelInfo[i][editPos][1], EditModelInfo[i][editPos][2], EditModelInfo[i][editPos][3], EditModelInfo[i][editId]);
	query_empty(pearsq, big_query);
    return 1;
}

stock CreateEditModelTextDraw(playerid) // Создаём текстдравы редактора
{
	if(typeDynamicTextDraw[playerid] > 0) return 0;
    typeDynamicTextDraw[playerid] = 1;
    
	DynamicTextDraw[0][playerid] = CreatePlayerTextDraw(playerid, 247.500000, 149.333435, "LD_SPAC:white"); // Основной текстдрав
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[0][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, DynamicTextDraw[0][playerid], 135.312500, 150.110900);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[0][playerid], 1);
	PlayerTextDrawColor(playerid, DynamicTextDraw[0][playerid], -1);
	PlayerTextDrawUseBox(playerid, DynamicTextDraw[0][playerid], true);
	PlayerTextDrawBoxColor(playerid, DynamicTextDraw[0][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[0][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[0][playerid], 120);
	PlayerTextDrawFont(playerid, DynamicTextDraw[0][playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, DynamicTextDraw[0][playerid], editModelId[playerid]);
	PlayerTextDrawSetPreviewRot(playerid, DynamicTextDraw[0][playerid], editModelPos[0][playerid], editModelPos[1][playerid], editModelPos[2][playerid], editModelPos[3][playerid]);
	
	DynamicTextDraw[1][playerid] = CreatePlayerTextDraw(playerid, 247.812500, 305.500000, "LD_SPAC:white"); // Кнопка X
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[1][playerid], 0.009687, 0.093333);
	PlayerTextDrawTextSize(playerid, DynamicTextDraw[1][playerid], 28.750000, 32.277770);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[1][playerid], 1);
	PlayerTextDrawColor(playerid, DynamicTextDraw[1][playerid], -1);
	PlayerTextDrawUseBox(playerid, DynamicTextDraw[1][playerid], true);
	PlayerTextDrawBoxColor(playerid, DynamicTextDraw[1][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[1][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[1][playerid], 120);
	PlayerTextDrawFont(playerid, DynamicTextDraw[1][playerid], 5);
	PlayerTextDrawSetSelectable(playerid, DynamicTextDraw[1][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, DynamicTextDraw[1][playerid], 2709);
	PlayerTextDrawSetPreviewRot(playerid, DynamicTextDraw[1][playerid], 0.000000, 0.000000, 0.000000, -2.000000);

	DynamicTextDraw[2][playerid] = CreatePlayerTextDraw(playerid, 263.125000, 311.500122, "X"); // Надпись X (Подсвечивается выбор оранжевым)
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[2][playerid], 0.611874, 2.008332);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[2][playerid], 2);
	PlayerTextDrawColor(playerid, DynamicTextDraw[2][playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[2][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[2][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[2][playerid], 51);
	PlayerTextDrawFont(playerid, DynamicTextDraw[2][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DynamicTextDraw[2][playerid], 1);

	DynamicTextDraw[3][playerid] = CreatePlayerTextDraw(playerid, 277.875000, 305.500000, "LD_SPAC:white"); // Кнопка Y
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[3][playerid], 0.009687, 0.093333);
	PlayerTextDrawTextSize(playerid, DynamicTextDraw[3][playerid], 28.750000, 32.277770);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[3][playerid], 1);
	PlayerTextDrawColor(playerid, DynamicTextDraw[3][playerid], -1);
	PlayerTextDrawUseBox(playerid, DynamicTextDraw[3][playerid], true);
	PlayerTextDrawBoxColor(playerid, DynamicTextDraw[3][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[3][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[3][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[3][playerid], 120);
	PlayerTextDrawFont(playerid, DynamicTextDraw[3][playerid], 5);
	PlayerTextDrawSetSelectable(playerid, DynamicTextDraw[3][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, DynamicTextDraw[3][playerid], 2709);
	PlayerTextDrawSetPreviewRot(playerid, DynamicTextDraw[3][playerid], 0.000000, 0.000000, 0.000000, -2.000000);

	DynamicTextDraw[4][playerid] = CreatePlayerTextDraw(playerid, 292.250000, 311.500122, "Y"); // Надпись Y
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[4][playerid], 0.611874, 2.008332);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[4][playerid], 2);
	PlayerTextDrawColor(playerid, DynamicTextDraw[4][playerid], -1);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[4][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[4][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[4][playerid], 51);
	PlayerTextDrawFont(playerid, DynamicTextDraw[4][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DynamicTextDraw[4][playerid], 1);

	DynamicTextDraw[5][playerid] = CreatePlayerTextDraw(playerid, 308.500000, 305.500000, "LD_SPAC:white"); // Кнопка Z
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[5][playerid], 0.009687, 0.093333);
	PlayerTextDrawTextSize(playerid, DynamicTextDraw[5][playerid], 28.750000, 32.277770);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[5][playerid], 1);
	PlayerTextDrawColor(playerid, DynamicTextDraw[5][playerid], -1);
	PlayerTextDrawUseBox(playerid, DynamicTextDraw[5][playerid], true);
	PlayerTextDrawBoxColor(playerid, DynamicTextDraw[5][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[5][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[5][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[5][playerid], 120);
	PlayerTextDrawFont(playerid, DynamicTextDraw[5][playerid], 5);
	PlayerTextDrawSetSelectable(playerid, DynamicTextDraw[5][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, DynamicTextDraw[5][playerid], 2709);
	PlayerTextDrawSetPreviewRot(playerid, DynamicTextDraw[5][playerid], 0.000000, 0.000000, 0.000000, -2.000000);

	DynamicTextDraw[6][playerid] = CreatePlayerTextDraw(playerid, 323.187500, 311.500122, "Z"); // Надпсь Z
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[6][playerid], 0.611874, 2.008332);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[6][playerid], 2);
	PlayerTextDrawColor(playerid, DynamicTextDraw[6][playerid], -1);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[6][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[6][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[6][playerid], 51);
	PlayerTextDrawFont(playerid, DynamicTextDraw[6][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DynamicTextDraw[6][playerid], 1);

	DynamicTextDraw[7][playerid] = CreatePlayerTextDraw(playerid, 338.812500, 305.500000, "LD_SPAC:white"); // Кнопка Zoom
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[7][playerid], 0.009687, 0.093333);
	PlayerTextDrawTextSize(playerid, DynamicTextDraw[7][playerid], 43.750000, 32.277770);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[7][playerid], 1);
	PlayerTextDrawColor(playerid, DynamicTextDraw[7][playerid], -1);
	PlayerTextDrawUseBox(playerid, DynamicTextDraw[7][playerid], true);
	PlayerTextDrawBoxColor(playerid, DynamicTextDraw[7][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[7][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[7][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[7][playerid], 120);
	PlayerTextDrawFont(playerid, DynamicTextDraw[7][playerid], 5);
	PlayerTextDrawSetSelectable(playerid, DynamicTextDraw[7][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, DynamicTextDraw[7][playerid], 2709);
	PlayerTextDrawSetPreviewRot(playerid, DynamicTextDraw[7][playerid], 0.000000, 0.000000, 0.000000, -2.000000);

	DynamicTextDraw[8][playerid] = CreatePlayerTextDraw(playerid, 360.750000, 313.500122, "Zoom"); // Надпись Zoom
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[8][playerid], 0.339062, 1.495000);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[8][playerid], 2);
	PlayerTextDrawColor(playerid, DynamicTextDraw[8][playerid], -1);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[8][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[8][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[8][playerid], 51);
	PlayerTextDrawFont(playerid, DynamicTextDraw[8][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DynamicTextDraw[8][playerid], 1);

	DynamicTextDraw[9][playerid] = CreatePlayerTextDraw(playerid, 254.062500, 344.944427, "LD_SPAC:white"); // Кнопка влево
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[9][playerid], 0.020625, 0.597222);
	PlayerTextDrawTextSize(playerid, DynamicTextDraw[9][playerid], 52.500000, 48.999996);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[9][playerid], 1);
	PlayerTextDrawColor(playerid, DynamicTextDraw[9][playerid], -1);
	PlayerTextDrawUseBox(playerid, DynamicTextDraw[9][playerid], true);
	PlayerTextDrawBoxColor(playerid, DynamicTextDraw[9][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[9][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[9][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[9][playerid], 0);
	PlayerTextDrawFont(playerid, DynamicTextDraw[9][playerid], 5);
	PlayerTextDrawSetSelectable(playerid, DynamicTextDraw[9][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, DynamicTextDraw[9][playerid], 19132);
	PlayerTextDrawSetPreviewRot(playerid, DynamicTextDraw[9][playerid], 0.000000, -90.000000, 90.000000, 1.000000);

	DynamicTextDraw[10][playerid] = CreatePlayerTextDraw(playerid, 324.125000, 344.944427, "LD_SPAC:white"); // Кнопка вправо
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[10][playerid], 0.020625, 0.597222);
	PlayerTextDrawTextSize(playerid, DynamicTextDraw[10][playerid], 52.500000, 48.999996);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[10][playerid], 1);
	PlayerTextDrawColor(playerid, DynamicTextDraw[10][playerid], -1);
	PlayerTextDrawUseBox(playerid, DynamicTextDraw[10][playerid], true);
	PlayerTextDrawBoxColor(playerid, DynamicTextDraw[10][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[10][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[10][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[10][playerid], 0);
	PlayerTextDrawFont(playerid, DynamicTextDraw[10][playerid], 5);
	PlayerTextDrawSetSelectable(playerid, DynamicTextDraw[10][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, DynamicTextDraw[10][playerid], 19132);
	PlayerTextDrawSetPreviewRot(playerid, DynamicTextDraw[10][playerid], 0.000000, 90.000000, 90.000000, 1.000000);

	DynamicTextDraw[11][playerid] = CreatePlayerTextDraw(playerid, 247.812500, 120.0, "LD_SPAC:white"); // Кнопка Input
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[11][playerid], 0.017500, 0.171111);
	PlayerTextDrawTextSize(playerid, DynamicTextDraw[11][playerid], 65.312500, 24.111114);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[11][playerid], 1);
	PlayerTextDrawColor(playerid, DynamicTextDraw[11][playerid], -1);
	PlayerTextDrawUseBox(playerid, DynamicTextDraw[11][playerid], true);
	PlayerTextDrawBoxColor(playerid, DynamicTextDraw[11][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[11][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[11][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[11][playerid], 120);
	PlayerTextDrawFont(playerid, DynamicTextDraw[11][playerid], 5);
	PlayerTextDrawSetSelectable(playerid, DynamicTextDraw[11][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, DynamicTextDraw[11][playerid], 2709);
	PlayerTextDrawSetPreviewRot(playerid, DynamicTextDraw[11][playerid], 0.000000, 0.000000, 0.000000, -2.000000);

	DynamicTextDraw[12][playerid] = CreatePlayerTextDraw(playerid, 317.562500, 120.0, "LD_SPAC:white"); // Кнопка Save
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[12][playerid], 0.017500, 0.171111);
	PlayerTextDrawTextSize(playerid, DynamicTextDraw[12][playerid], 65.312500, 24.111114);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[12][playerid], 1);
	PlayerTextDrawColor(playerid, DynamicTextDraw[12][playerid], -1);
	PlayerTextDrawUseBox(playerid, DynamicTextDraw[12][playerid], true);
	PlayerTextDrawBoxColor(playerid, DynamicTextDraw[12][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[12][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[12][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[12][playerid], 120);
	PlayerTextDrawFont(playerid, DynamicTextDraw[12][playerid], 5);
	PlayerTextDrawSetSelectable(playerid, DynamicTextDraw[12][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, DynamicTextDraw[12][playerid], 2709);
	PlayerTextDrawSetPreviewRot(playerid, DynamicTextDraw[12][playerid], 0.000000, 0.000000, 0.000000, -2.000000);

	DynamicTextDraw[13][playerid] = CreatePlayerTextDraw(playerid, 279.750000, 125.444572, "Input"); // Надпись Input
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[13][playerid], 0.296249, 1.308333);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[13][playerid], 2);
	PlayerTextDrawColor(playerid, DynamicTextDraw[13][playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[13][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[13][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[13][playerid], 51);
	PlayerTextDrawFont(playerid, DynamicTextDraw[13][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DynamicTextDraw[13][playerid], 1);

	DynamicTextDraw[14][playerid] = CreatePlayerTextDraw(playerid, 350.437500, 125.444572, "Save"); // Надпись Save
	PlayerTextDrawLetterSize(playerid, DynamicTextDraw[14][playerid], 0.296249, 1.308333);
	PlayerTextDrawAlignment(playerid, DynamicTextDraw[14][playerid], 2);
	PlayerTextDrawColor(playerid, DynamicTextDraw[14][playerid], 14706431);
	PlayerTextDrawSetShadow(playerid, DynamicTextDraw[14][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DynamicTextDraw[14][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DynamicTextDraw[14][playerid], 51);
	PlayerTextDrawFont(playerid, DynamicTextDraw[14][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DynamicTextDraw[14][playerid], 1);
	return 1;
}
stock ShowEditModelMenu(playerid) // Показываем меню редактора
{
    PlayerTextDrawSetPreviewModel(playerid, DynamicTextDraw[0][playerid], editModelId[playerid]);
	PlayerTextDrawSetPreviewRot(playerid, DynamicTextDraw[0][playerid], editModelPos[0][playerid], editModelPos[1][playerid], editModelPos[2][playerid], editModelPos[3][playerid]);
    for(new i = 0; i < 15; i++) PlayerTextDrawShow(playerid, DynamicTextDraw[i][playerid]);

    OnlineInfo[playerid][oShowInterface] = 15;
	return 1;
}
stock CloseEditModelMenu(playerid)
{
    if(typeDynamicTextDraw[playerid] != 1) return 1;

    for(new i = 0; i < 15; i++) PlayerTextDrawHide(playerid, DynamicTextDraw[i][playerid]), PlayerTextDrawDestroy(playerid, DynamicTextDraw[i][playerid]);

    typeDynamicTextDraw[playerid] = 0;
    OnlineInfo[playerid][oShowInterface] = 0;
    GameTextForPlayer(playerid," ",1000,3);
	return 1;
}
stock UpdateColorButtonEditModelDraw(playerid, buttonId)
{
	new drawId = 2;
    if(editModelAxis[playerid] == 0) drawId = 2;
    else if(editModelAxis[playerid] == 1) drawId = 4;
    else if(editModelAxis[playerid] == 2) drawId = 6;
    else if(editModelAxis[playerid] == 3) drawId = 8;
    PlayerTextDrawColor(playerid, DynamicTextDraw[drawId][playerid], -1); // Удаляем цвет у кнопки
    PlayerTextDrawShow(playerid, DynamicTextDraw[drawId][playerid]);
    
    if(buttonId >= 0)
    {
	    new nextDrawId = 2;
	    if(buttonId == 0) nextDrawId = 2;
	    else if(buttonId == 1) nextDrawId = 4;
	    else if(buttonId == 2) nextDrawId = 6;
	    else if(buttonId == 3) nextDrawId = 8;
	    editModelAxis[playerid] = buttonId;
	    PlayerTextDrawColor(playerid, DynamicTextDraw[nextDrawId][playerid], -5963521);
	    PlayerTextDrawShow(playerid, DynamicTextDraw[nextDrawId][playerid]);
    }
	return 1;
}
stock UpdatePositionEditModelDraw(playerid, status)
{
	if(status == 0) // Left
	{
		if(editModelAxis[playerid] == 3)
		{
		    if(editModelPos[editModelAxis[playerid]][playerid]-0.02 <= -360.0) editModelPos[editModelAxis[playerid]][playerid] = 0.0;
			else editModelPos[editModelAxis[playerid]][playerid] -= 0.02;
		}
		else
		{
			if(editModelPos[editModelAxis[playerid]][playerid]-2.0 <= -360.0) editModelPos[editModelAxis[playerid]][playerid] = 0.0;
			else editModelPos[editModelAxis[playerid]][playerid] -= 2.0;
		}
	}
	else if(status == 1) // Right
	{
		if(editModelAxis[playerid] == 3)
        {
		    if(editModelPos[editModelAxis[playerid]][playerid]+0.02 >= 360.0) editModelPos[editModelAxis[playerid]][playerid] = 0.0;
			else editModelPos[editModelAxis[playerid]][playerid] += 0.02;
		}
		else
		{
		    if(editModelPos[editModelAxis[playerid]][playerid]+2.0 >= 360.0) editModelPos[editModelAxis[playerid]][playerid] = 0.0;
			else editModelPos[editModelAxis[playerid]][playerid] += 2.0;
		}
	}
    UpdateShowPositionEditModelDraw(playerid);
	return 1;
}
stock UpdateShowPositionEditModelDraw(playerid)
{
	PlayerTextDrawSetPreviewRot(playerid, DynamicTextDraw[0][playerid], editModelPos[0][playerid], editModelPos[1][playerid], editModelPos[2][playerid], editModelPos[3][playerid]);
	PlayerTextDrawShow(playerid, DynamicTextDraw[0][playerid]);

	format(store,sizeof(store),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~X:%.2f, Y:%.2f, Z:%.2f, Zoom:%.2f", editModelPos[0][playerid], editModelPos[1][playerid], editModelPos[2][playerid], editModelPos[3][playerid]);
	GameTextForPlayer(playerid,store,8000,3);
	return 1;
}

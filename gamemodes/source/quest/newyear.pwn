#define MAX_NEWYEARSGIFTS 76
#define NEWYEARMUSIC "https://cdn.pears.fun/sound/newyear01.mp3"

new bool:TakeNewYearGiftsItem[MAX_NEWYEARSGIFTS];
new QuanLoadNewYearGifts = 0;
new ObjectNewYearGifts[MAX_NEWYEARSGIFTS];
new TakeNewYearGiftsUnix[MAX_NEWYEARSGIFTS];
new LaplandiaCube;

new Float:CandlesPosNewYear[][] =
{
    {3269.5271,-399.8250,8.3631},
    {3294.2329,-408.3743,8.5798},
    {3289.5745,-410.3390,8.5798},
    {3303.1040,-397.6117,8.6501},
    {3307.4717,-400.6337,8.6578},
    {3312.0632,-390.9363,11.109},
    {3311.2173,-393.7215,11.109},
    {3329.8564,-382.1311,8.6575},
    {3329.7495,-360.2035,9.3281},
    {3332.5708,-360.7018,9.3281},
    {3326.6860,-345.2749,8.3832},
    {3314.9033,-339.0758,8.7701},
    {3316.5820,-333.8947,8.7778},
    {3308.4204,-323.2083,8.6575},
    {3284.6069,-317.9158,8.5798},
    {3289.1318,-315.8502,8.5798},
    {3274.3542,-323.6554,8.3832},
    {3267.9026,-340.0154,11.323}
};
new PlayerTakeCandle[MAX_REALPLAYERS][sizeof(CandlesPosNewYear)]; 

new Float:WindowPosNewYear[][] =
{
    {3271.5959,-387.3220,8.3552},
    {3278.4629,-396.9425,8.6521},
    {3274.0474,-394.6434,8.6521},
    {3293.7849,-396.9828,8.3552},
    {3286.7590,-397.0605,8.5797},
    {3313.5117,-386.6299,8.3552},
    {3316.9717,-381.1005,8.3552},
    {3319.5073,-375.2523,8.3552},
    {3323.9980,-365.1008,9.3278},
    {3321.5210,-348.2910,8.6722},
    {3315.3315,-343.0193,8.3552},
    {3310.1533,-339.9247,8.3552},
    {3306.3699,-335.5358,8.3552},
    {3299.7678,-332.3102,8.3552},
    {3292.6111,-329.9173,8.3552},
    {3284.2891,-330.2480,8.3552},
    {3277.8489,-330.2879,8.6366},
    {3273.9580,-333.2327,8.6722},
    {3271.8796,-342.7209,8.3552}
};

new Float:NewYearsGiftsPos[][] =
{
    { 2825.489257, -2380.607177, 12.074913 },
    { 2874.753173, -2124.703125, 4.229651 },
    { 2173.919921, -1998.472045, 19.968690 },
    { 1450.119506, -1964.446533, 29.859375 },
    { 1744.319213, -1562.918945, 14.162378 },
    { 1869.361450, -1365.480834, 19.140586 },
    { 1675.090942, -1357.223022, 158.867218 },
    { 1561.091064, -1251.914062, 270.531799 },
    { 1165.305786, -1200.192138, 32.027549 },
    { 916.051086, -1235.293701, 17.210912 },
    { 65.668373, -1520.742431, 12.893699 },
    { 632.667236, -518.744567, 16.335899 },
    { 820.213623, -560.010925, 20.336259 },
    { 221.379837, -234.421737, 1.778618 },
    { 271.871002, -200.912841, 7.061348 },
    { 184.136276, -107.518669, 2.023437 },
    { -155.165878, -279.615325, 3.905314 },
    { -473.163421, -175.238983, 78.210899 },
    { -478.733306, -544.662170, 29.121551 },
    { -995.767578, -721.030761, 35.937511 },
    { -1072.953735, -1154.480224, 129.219192 },
    { -1429.962402, -1476.728271, 101.671623 },
    { -1851.483154, -1699.837280, 40.867160 },
    { -2172.965332, -2415.048583, 34.296852 },
    { -2005.713134, -2397.754394, 30.625000 },
    { -2789.937500, -1522.947998, 139.182556 },
    { -1946.848876, -727.456604, 35.882835 },
    { -1954.563110, -943.023925, 35.890884 },
    { -1675.951904, -628.650695, 14.148437 },
    { -1196.602416, -92.256408, 14.143965 },
    { -2723.063476, -319.403961, 7.843788 },
    { -2357.060546, -122.392219, 35.312500 },
    { -2526.729736, 140.614456, 22.273450 },
    { -2613.067138, 180.294097, 4.327496 },
    { -2498.697998, 391.589538, 35.119426 },
    { -2104.170898, 121.410011, 35.290908 },
    { -2041.415039, 300.758728, 35.369285 },
    { -1974.760498, 480.546997, 29.015586 },
    { -1747.191894, 524.009765, 38.085731 },
    { -2104.323730, 657.945739, 52.367149 },
    { -2542.523437, 662.072998, 14.459196 },
    { -2762.310791, 762.342407, 52.781250 },
    { -2545.744384, 928.214599, 64.984397 },
    { -1899.769409, 1159.283569, 45.859413 },
    { -1801.340698, 749.118957, 24.890686 },
    { -1624.961669, 1424.082275, 7.175174 },
    { -1508.176391, 1374.666137, 3.746025 },
    { -1456.084838, 1874.356811, 32.632785 },
    { -1213.603393, 1831.412475, 41.929714 },
    { -879.639648, 1538.580444, 25.914064 },
    { -857.608276, 1535.618896, 22.587005 },
    { -731.477233, 1538.727416, 40.436500 },
    { -684.572631, 941.858886, 13.632812 },
    { -317.584564, 818.070434, 14.326829 },
    { -170.179946, 1032.810058, 19.734388 },
    { -215.991485, 1052.110107, 19.742212 },
    { -100.532470, 1365.784057, 10.273487 },
    { -10.221295, 2333.001953, 24.140636 },
    { 412.984283, 2530.703613, 19.148475 },
    { -236.908691, 2666.697509, 63.858558 },
    { 1489.435424, 2773.544677, 10.820312 },
    { 1766.016601, 2783.305419, 10.835937 },
    { 2595.452880, 2392.725097, 17.820312 },
    { 2307.401367, 2352.750732, 11.265733 },
    { 2101.303710, 1927.404541, 13.232126 },
    { 2515.277832, 1552.642456, 11.088271 },
    { 2098.629394, 914.147277, 10.837452 },
    { 1725.353027, 1402.114013, 10.846714 },
    { 1087.391601, 1073.335693, 10.838157 },
    { 2295.732177, 582.306701, 9.255548 },
    { 1628.364013, 600.000488, 1.757762 },
    { 1324.015869, 285.990753, 20.045232 },
    { 1283.486816, 158.074188, 20.793418 },
    { 2281.225830, 59.565418, 30.483470 },
    { 2326.517578, 61.828880, 26.492162 },
    { 2313.577392, -1422.292480, 23.399204 },
    { 2683.722900, -1111.508666, 69.384071 }
};

function Call_OnPlayerNewYearLoad(playerid, race_check)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);

        new bool:is_null;
        cache_is_value_name_null(0, "pNewYearQuestComplete", is_null);
        if(is_null == false)
        {
            new string_json[512];
            cache_get_value_name(0, "pNewYearQuestComplete", string_json);

            new JsonNode:node = JSON_INVALID_NODE;
            if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
            {
                new index = -1, JsonNode: output;
                while(!JSON_ArrayIterate(node, index, output))
                {
                    JSON_GetNodeInt(output, PlayerInfo[playerid][pNewYearQuestComplete][index]);
                }
            }
        }
        cache_get_value_name_int(0, "pDedMorozMessage", PlayerInfo[playerid][pDedMorozMessage]);

        printf("Call_OnPlayerNewYearLoad(%s) загружен новогодний квест", PlayerInfo[playerid][pName]);
	}
	else // Если не нашли в таблице, тогда создаём
	{
		new string[100];
		mysql_format(pearsq, string, sizeof(string), "INSERT INTO `pp_quest_temp` SET `user_id`= '%d'", PlayerInfo[playerid][pID]);
		mysql_tquery(pearsq, string);
        printf("Call_OnPlayerNewYearLoad(%s) добавлена ячейка", PlayerInfo[playerid][pName]);
	}
    OnlineInfo[playerid][oLoadNewYear] = 1;

	return true;
}

CMD:reloadgifts(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 10) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
    for(new i = 0; i < MAX_NEWYEARSGIFTS; i++)
    {
        TakeNewYearGiftsItem[i] = true;
        TakeNewYearGiftsUnix[i] = 0;
        if(ObjectNewYearGifts[i] != 0) DestroyDynamicObject(ObjectNewYearGifts[i]);
        ObjectNewYearGifts[i] = 0;
    }
    QuanLoadNewYearGifts = 0;
    CreateNewYearGifts();
    SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Я очистил новогодние подарки. Их на карте сейчас %d", QuanLoadNewYearGifts);
    return true;
}

stock CreateNewYearGifts()
{
    if(!IsANewYearSoon()) return 0;
    new rand = random(MAX_NEWYEARSGIFTS-20);
    for(new i = rand; i < MAX_NEWYEARSGIFTS; i++)
    {
        if(TakeNewYearGiftsUnix[i] > gettime()) continue;
        else TakeNewYearGiftsItem[i] = false;
        if(TakeNewYearGiftsItem[i]) continue;
        if(ObjectNewYearGifts[i] == 0) ObjectNewYearGifts[i] = CreateDynamicObject(12403, NewYearsGiftsPos[i][0], NewYearsGiftsPos[i][1], NewYearsGiftsPos[i][2]-0.875024, 0.0, 0.0, 0.0, 0, 0, -1, 50.0, 50.0);
        QuanLoadNewYearGifts++;
    }
    return true;
}
stock SaveNewYearQuestPlayer(playerid)
{
    new JsonNode:node = JSON_Array();

    for(new i = 0; i < 13; i++)
    {
        JSON_ArrayAppendEx(node, JSON_Int(PlayerInfo[playerid][pNewYearQuestComplete][i]));
    }

    new string_json[512];
    if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
    {
        new string_mysql[640];
        mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_quest_temp` SET `pNewYearQuestComplete` = '%e', `pDedMorozMessage` = '%d' WHERE `user_id` = '%d'",
        string_json,PlayerInfo[playerid][pDedMorozMessage], PlayerInfo[playerid][pID]);
        mysql_tquery(pearsq, string_mysql);
    }
    return true;
}

stock SendMessageDedMoroz(playerid)
{
    if(!IsANewYearSoon() && PlayerInfo[playerid][pSoska] <= 22) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я смогу написать письмо только с 20 декабря по 31 декабря ;(");
    if(PlayerInfo[playerid][pDedMorozMessage]) return ErrorMessage(playerid, "{ff6347}Вы уже отправили письмо!");
    if(!OnlineInfo[playerid][oLoadNewYear]) return ErrorMessage(playerid, "{ff6347}Подождите, ваш аккаунт еще не до конца загрузился!");
    if(GetPVarInt(playerid,"antiflood") > 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Кхм... использование команды раз в 30 секунд");
    new stro[110],sctringo[1000];
    format(stro,sizeof(stro),"\n\n{0088ff}Письмо Деду Морозу\n"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"{cccccc}- Вы можете попросить у него всё, что угодно ;)\n"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"{cccccc}- Письмо не должно содержать мат или оскорбительный смысл\n"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"{cccccc}- Количество символов не меньше 20 и не больше 120\n\n"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"{ff6347}ВАЖНО!! {cccccc}Письмо можно написать только один раз в году!\n\n"), strcat(sctringo,stro);
    ShowDialog(playerid,418,DIALOG_STYLE_INPUT,"{0088ff}Письмо Деду Морозу",sctringo,"Отправить","Отмена");
    return 1;
}


stock CreateNewYearPickup()
{
    if(IsANewYear())
    {
        CreateNewYearGifts();
        CreateDynamicPickup(12463, 1, 3296.0962,-358.3546,8.3526, 0, 0); // пьсмо
        CreateDynamic3DTextLabel("{ff9000}Письмо Дедушке Морозу \n\n{444444}[ ALT ]",-1,3296.0962,-358.3546,8.3526 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
        
        CreateDynamic3DTextLabel("{ff9000}Жердин из овчарни\n\n{444444}[ ALT ]",-1,3261.6216,-340.3169,8.4405 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
        CreateDynamic3DTextLabel("{ff9000}Канавный остолоп\n\n{444444}[ ALT ]",-1,3271.8430,-326.0200,8.3832 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
        CreateDynamic3DTextLabel("{ff9000}Обрубок\n\n{444444}[ ALT ]",-1,3289.9795,-321.6499,8.5798 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);

        CreateDynamic3DTextLabel("{ff9000}Ложколиз\n\n{444444}[ ALT ]",-1,3304.9819,-327.0664,8.6575 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
        CreateDynamic3DTextLabel("{ff9000}Горшколиз\n\n{444444}[ ALT ]",-1,3318.8401,-337.3204,8.7701 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
        CreateDynamic3DTextLabel("{ff9000}Мисколиз\n\n{444444}[ ALT ]",-1,3328.3542,-348.5233,8.3832 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
        CreateDynamic3DTextLabel("{ff9000}Дверехлопальщик\n\n{444444}[ ALT ]",-1,3330.1108,-365.0452,9.3281 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
        CreateDynamic3DTextLabel("{ff9000}Скирный Обжора\n\n{444444}[ ALT ]",-1,3325.5002,-379.7283,8.6575 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
        CreateDynamic3DTextLabel("{ff9000}Колбасохват\n\n{444444}[ ALT ]",-1,3318.1042,-391.1663,8.4765 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);

        CreateDynamic3DTextLabel("{ff9000}Подглядыватель в окна\n\n{444444}[ ALT ]",-1,3302.1863,-401.8705,8.6501 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
        CreateDynamic3DTextLabel("{ff9000}Дверевынюхиватель\n\n{444444}[ ALT ]",-1,3289.0723,-404.1032,8.5798 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
        CreateDynamic3DTextLabel("{ff9000}Мясной крюк\n\n{444444}[ ALT ]",-1,3273.0542,-401.0622,8.3631 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
        CreateDynamic3DTextLabel("{ff9000}Свечной попрошайка\n\n{444444}[ ALT ]",-1,3266.8120,-389.1149,8.4329 +0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
        LaplandiaCube = CreateDynamicCube(3110.4719,-468.8748, 0.0, 3412.3660,-237.0729, 50.0, 0, 0);
    }
    return true;
}

stock TakeNewYearGifts(playerid)
{
    if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0) return false;

    new bool:findBall;
    for(new i = 0; i < MAX_NEWYEARSGIFTS; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, NewYearsGiftsPos[i][0], NewYearsGiftsPos[i][1], NewYearsGiftsPos[i][2]) && ObjectNewYearGifts[i])
        {
            TakeNewYearGiftsItem[i] = true;
            QuanLoadNewYearGifts--;
            TakeNewYearGiftsUnix[i] = gettime() + 21600;
            if(ObjectNewYearGifts[i] != 0)DestroyDynamicObject(ObjectNewYearGifts[i]);
            ObjectNewYearGifts[i] = 0;
            findBall = true;

            if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, NEWYEARMUSIC);

            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Кто-то спрятал подарок... Наверное рядом есть еще подарки {D93A49}[ Подарков на карте %d ]", QuanLoadNewYearGifts);

            new thingId, thingQuan, thingType, thingPara, thingPack;
            CreateCasePlayer(playerid, thingId, thingQuan, thingType, thingPara, thingPack, "newyear25");
            GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
                
            ApplyAnimation(playerid,"CARRY","liftup",4.1, false, true, true, false, 0); // Анимация поднять предмет

            CompleteBattlePassTask(playerid, 5, 2);
            break;
        }
    }
    return findBall;
}

//
//          Квестовая залупка
//
enum NewYearQuestNpc
{
    NPC:nyID,  // NPC
    nyTask, // Задача NPC
    NPC:nyTargetNpc, //
    nyTimers, // Таймер для второго квеста
    nyActor, // Для бота
    nyActorPump
}
new NewYearNPC[MAX_REALPLAYERS][NewYearQuestNpc];
new NPC:ShipNPC[MAX_REALPLAYERS][10];
new Float:ShipNPCHealt[MAX_REALPLAYERS][10];
new CountKill[MAX_REALPLAYERS][2];


stock IsACandleNewYear(playerid)
{
    new result = -1, quan = 0, string[120];
    for(new i; i < sizeof(CandlesPosNewYear); i++)
    {
        if(PlayerTakeCandle[playerid][i]) continue;
        if(IsPlayerInRangeOfPoint(playerid, 3.0, CandlesPosNewYear[i][0],CandlesPosNewYear[i][1],CandlesPosNewYear[i][2]))
        {
            result = i;
            quan--;
        }
        quan++;
    }
    if(quan == 0) format(string,sizeof(string),"Я собрал все свечи, теперь нужно отдать их Свечному Попрошайке");
    else format(string,sizeof(string),"Мне нужно собрать свечи в домах Йольских Парней. Осталось свечей %d",quan);
    SetPlayerHudTask(playerid, "Новогодний Квест", string);
    return result;
}

stock IsAWindowNewYear(playerid)
{
    new result = 0;
    for(new i; i < sizeof(WindowPosNewYear); i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, WindowPosNewYear[i][0],WindowPosNewYear[i][1],WindowPosNewYear[i][2]))
        {
            result = 1;
            break;
        }
    }
    return result;
}

stock StartNewYearThriTeenMan(playerid)
{
    if(OnlineInfo[playerid][oNewYearQuest] > 0) return ErrorMessage(playerid,"{ff6347}Я уже выполняю какой-то квест!");
    if(PlayerInfo[playerid][pNewYearQuestComplete][12] == 1) return ErrorMessage(playerid,"{ff6347}Я уже выполнил данный квест!");
    if(!OnlineInfo[playerid][oLoadNewYear]) return ErrorMessage(playerid,"{ff6347}Мой аккаунт еще не успел до конца загрузится!");
    if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid,"{ff6347}Доступно только с лаунчером!");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_hello.mp3");

    OnlineInfo[playerid][oNewYearQuest] = 13;
    new lines[500];
	format(lines,sizeof(lines),"{D93A49}Привет, я последний Йольский парень\n"\
                                "\n{cccccc}У меня всегда не хватало свечей"\
                                "\n{cccccc}Можешь мне нарулить из домов моих братьев свечей"\
                                "\n{cccccc}С меня будет тебе подарочек"\
                                "\n\n{cccccc}Готов начать?");
	ShowDialog(playerid,NEWYEAR_SHOW_STARTQUEST,DIALOG_STYLE_MSGBOX, "{ff9000}Новогодний квест", lines, "Да", "Нет");
	return true;
}

stock CloseNewYearQuestThriTeen(playerid)
{
    new quan = 0;
    for(new i; i < sizeof(CandlesPosNewYear); i++)
    {
        if(PlayerTakeCandle[playerid][i]) quan++;
    }
    if(quan < sizeof(CandlesPosNewYear)) return ErrorMessage(playerid, "{FF6347}Я не собрал все свечи");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_win.mp3");

    SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Туда их, давай их быстро сюда, устрою себе романтик!");

    GiveNewYesrCase(playerid);
    PlayerInfo[playerid][pNewYearQuestComplete][12] = 1;
    OnlineInfo[playerid][oNewYearQuest] = 0;
    OnlineInfo[playerid][oNewYearQuestDop] = 0;
    HidePlayerHudTask(playerid);
    SaveNewYearQuestPlayer(playerid);
    return true;
}

stock StartNewYearTwelvMan(playerid)
{
    if(OnlineInfo[playerid][oNewYearQuest] > 0) return ErrorMessage(playerid,"{ff6347}Я уже выполняю какой-то квест!");
    if(PlayerInfo[playerid][pNewYearQuestComplete][11] == 1) return ErrorMessage(playerid,"{ff6347}Я уже выполнил данный квест!");
    if(!OnlineInfo[playerid][oLoadNewYear]) return ErrorMessage(playerid,"{ff6347}Мой аккаунт еще не успел до конца загрузится!");
    if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid,"{ff6347}Доступно только с лаунчером!");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_hello.mp3");

    OnlineInfo[playerid][oNewYearQuest] = 12;
    new lines[500];
	format(lines,sizeof(lines),"{D93A49}ДАРОВА\n"\
                                "\n{cccccc}Слышал ты моим братьям тут во всю помогаешь?"\
                                "\n{cccccc}Давайка ты мне тоже поможешь, мне лень тащится за мясом, а крюки украсить хочется"\
                                "\n{cccccc}Притащи мне свежего мяска, что бы я мог украсить свои крюки"\
                                "\n\n{cccccc}Готов начать?");
	ShowDialog(playerid,NEWYEAR_SHOW_STARTQUEST,DIALOG_STYLE_MSGBOX, "{ff9000}Новогодний квест", lines, "Да", "Нет");
	return true;
}

stock CloseNewYearQuestTwelv(playerid)
{
    if(get_invent4(playerid, 22, 0) <= 0 && get_para(playerid, 22) < gettime()) return ErrorMessage(playerid, "{FF6347}Я нет свежего мяса");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_win.mp3");

    SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Оооо, харош, спасибо за помощь!");

    GiveNewYesrCase(playerid);
    PlayerInfo[playerid][pNewYearQuestComplete][11] = 1;
    OnlineInfo[playerid][oNewYearQuest] = 0;
    OnlineInfo[playerid][oNewYearQuestDop] = 0;
    TakeInvent(playerid, 22, 1, 0, 999);
    SaveNewYearQuestPlayer(playerid);
    return true;
}

stock StartNewYearElevenMan(playerid)
{
    if(OnlineInfo[playerid][oNewYearQuest] > 0) return ErrorMessage(playerid,"{ff6347}Я уже выполняю какой-то квест!");
    if(PlayerInfo[playerid][pNewYearQuestComplete][10] == 1) return ErrorMessage(playerid,"{ff6347}Я уже выполнил данный квест!");
    if(!OnlineInfo[playerid][oLoadNewYear]) return ErrorMessage(playerid,"{ff6347}Мой аккаунт еще не успел до конца загрузится!");
    if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid,"{ff6347}Доступно только с лаунчером!");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_hello.mp3");

    OnlineInfo[playerid][oNewYearQuest] = 11;
    new lines[500];
	format(lines,sizeof(lines),"{D93A49}Привет пистолет\n"\
                                "\n{cccccc}Привези-ка мне свежий хлеб, фабрики нынчи закрылись"\
                                "\n{cccccc}Мне негде вынюхивать в поисках свежего хлеба"\
                                "\n{cccccc}С меня будет тебе подарочек"\
                                "\n\n{cccccc}Готов начать?");
	ShowDialog(playerid,NEWYEAR_SHOW_STARTQUEST,DIALOG_STYLE_MSGBOX, "{ff9000}Новогодний квест", lines, "Да", "Нет");
	return true;
}

stock CloseNewYearQuestEleven(playerid)
{
    if(get_invent4(playerid, 1, 0) <= 0 && get_para(playerid, 1) < gettime()) return ErrorMessage(playerid, "{FF6347}У вас нет свежего хлеба");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_win.mp3");

    SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Знал бы ты как я скучал по запаху свежего хлеба.... Держи подарок");

    GiveNewYesrCase(playerid);
    PlayerInfo[playerid][pNewYearQuestComplete][10] = 1;
    OnlineInfo[playerid][oNewYearQuest] = 0;
    OnlineInfo[playerid][oNewYearQuestDop] = 0;
    TakeInvent(playerid, 1, 1, 0, 999);
    SaveNewYearQuestPlayer(playerid);
    return true;
}

stock StartNewYearTenMan(playerid)
{
    if(OnlineInfo[playerid][oNewYearQuest] > 0) return ErrorMessage(playerid,"{ff6347}Я уже выполняю какой-то квест!");
    if(PlayerInfo[playerid][pNewYearQuestComplete][9] == 1) return ErrorMessage(playerid,"{ff6347}Я уже выполнил данный квест!");
    if(!OnlineInfo[playerid][oLoadNewYear]) return ErrorMessage(playerid,"{ff6347}Мой аккаунт еще не успел до конца загрузится!");
    if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid,"{ff6347}Доступно только с лаунчером!");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_hello.mp3");

    OnlineInfo[playerid][oNewYearQuest] = 10;
    new lines[500];
	format(lines,sizeof(lines),"{D93A49}Привет, готов заняться истинным делом?\n"\
                                "\n{cccccc}Я люблю подглядывать в окна, и надеюсь ты тоже"\
                                "\n{cccccc}Подглядывай за моими братьями в их окна в течение 120 секунд"\
                                "\n{cccccc}За это от меня тебе будет подарочек"\
                                "\n\n{cccccc}Готов начать?");
	ShowDialog(playerid,NEWYEAR_SHOW_STARTQUEST,DIALOG_STYLE_MSGBOX, "{ff9000}Новогодний квест", lines, "Да", "Нет");
	return true;
}

stock CloseNewYearQuestTen(playerid)
{
    if(OnlineInfo[playerid][oNewYearQuestDop] < 119) return ErrorMessage(playerid, "{FF6347}Я не выполнил задание!");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_win.mp3");

    SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Как тебе мои братки балбесы? Вдоволь налюбовался ими?");

    GiveNewYesrCase(playerid);
    PlayerInfo[playerid][pNewYearQuestComplete][9] = 1;
    OnlineInfo[playerid][oNewYearQuest] = 0;
    OnlineInfo[playerid][oNewYearQuestDop] = 0;
    HidePlayerHudTask(playerid);
    SaveNewYearQuestPlayer(playerid);
    return true;
}

stock StartNewYearNineMan(playerid)
{
    if(OnlineInfo[playerid][oNewYearQuest] > 0) return ErrorMessage(playerid,"{ff6347}Я уже выполняю какой-то квест!");
    if(PlayerInfo[playerid][pNewYearQuestComplete][8] == 1) return ErrorMessage(playerid,"{ff6347}Я уже выполнил данный квест!");
    if(!OnlineInfo[playerid][oLoadNewYear]) return ErrorMessage(playerid,"{ff6347}Мой аккаунт еще не успел до конца загрузится!");
    if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid,"{ff6347}Доступно только с лаунчером!");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_hello.mp3");

    OnlineInfo[playerid][oNewYearQuest] = 9;
    new lines[500];
	format(lines,sizeof(lines),"{D93A49}Приветосик, чилибосик\n"\
                                "\n{cccccc}Знаешь, я тут очень устал, у меня не получается стащить колбасу"\
                                "\n{cccccc}Давай-ка ты мне её приготовишь и отдашь за подарочек?"\
                                "\n{cccccc}Ну тебе же не трудно, а мне приятно!"\
                                "\n\n{cccccc}Готов начать?");
	ShowDialog(playerid,NEWYEAR_SHOW_STARTQUEST,DIALOG_STYLE_MSGBOX, "{ff9000}Новогодний квест", lines, "Да", "Нет");
	return true;
}

stock StartNewYearEightMan(playerid)
{
    if(OnlineInfo[playerid][oNewYearQuest] > 0) return ErrorMessage(playerid,"{ff6347}Я уже выполняю какой-то квест!");
    if(PlayerInfo[playerid][pNewYearQuestComplete][7] == 1) return ErrorMessage(playerid,"{ff6347}Я уже выполнил данный квест!");
    if(!OnlineInfo[playerid][oLoadNewYear]) return ErrorMessage(playerid,"{ff6347}Мой аккаунт еще не успел до конца загрузится!");
    if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid,"{ff6347}Доступно только с лаунчером!");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_hello.mp3");

    OnlineInfo[playerid][oNewYearQuest] = 8;
    new lines[500];
	format(lines,sizeof(lines),"{D93A49}Дарова балбес!\n"\
                                "\n{cccccc}Привези-ка мне свеженькой скирки!"\
                                "\n{cccccc}Она делается из молока, на плите, ну думаю ты разберешь!"\
                                "\n{cccccc}С меня будет тебе подарочек"\
                                "\n\n{cccccc}Готов начать?");
	ShowDialog(playerid,NEWYEAR_SHOW_STARTQUEST,DIALOG_STYLE_MSGBOX, "{ff9000}Новогодний квест", lines, "Да", "Нет");
	return true;
}

stock CloseNewYearQuestNine(playerid)
{
    if(get_invent4(playerid, 262, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет колбасы");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_win.mp3");

    SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Класс! Я теперь так обожрусь колбасок! Век не забуду тебя. Держи подарок");

    GiveNewYesrCase(playerid);
    PlayerInfo[playerid][pNewYearQuestComplete][8] = 1;
    OnlineInfo[playerid][oNewYearQuest] = 0;
    OnlineInfo[playerid][oNewYearQuestDop] = 0;
    TakeInvent(playerid, 262, 1, 0, 999);
    SaveNewYearQuestPlayer(playerid);
    return true;
}

stock CloseNewYearQuestEight(playerid)
{
    if(get_invent4(playerid, 261, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет скирна");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_win.mp3");

    SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: А ты случаем не из Исландии? У тебя получилось божественно! Держи подарок");

    GiveNewYesrCase(playerid);
    PlayerInfo[playerid][pNewYearQuestComplete][7] = 1;
    OnlineInfo[playerid][oNewYearQuest] = 0;
    OnlineInfo[playerid][oNewYearQuestDop] = 0;
    TakeInvent(playerid, 261, 1, 0, 999);
    SaveNewYearQuestPlayer(playerid);
    return true;
}

stock StartNewYearSevenMan(playerid)
{
    if(OnlineInfo[playerid][oNewYearQuest] > 0) return ErrorMessage(playerid,"{ff6347}Я уже выполняю какой-то квест!");
    if(PlayerInfo[playerid][pNewYearQuestComplete][6] == 1) return ErrorMessage(playerid,"{ff6347}Я уже выполнил данный квест!");
    if(!OnlineInfo[playerid][oLoadNewYear]) return ErrorMessage(playerid,"{ff6347}Мой аккаунт еще не успел до конца загрузится!");
    if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid,"{ff6347}Доступно только с лаунчером!");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_hello.mp3");

    OnlineInfo[playerid][oNewYearQuest] = 7;
    new lines[500];
	format(lines,sizeof(lines),"{D93A49}Ай молодец, ай харош.\n"\
                                "\n{cccccc}А теперь давай договоримся..."\
                                "\n{cccccc}В этом году ты будешь всегда хлопать дверьми"\
                                "\n{cccccc}ВЕЗДЕ И ВСЕГДА!! А от меня тебе подарочек"\
                                "\n\n{cccccc}Согласен?");
	ShowDialog(playerid,NEWYEAR_SHOW_STARTQUEST,DIALOG_STYLE_MSGBOX, "{ff9000}Новогодний квест", lines, "Да", "Нет");
	return true;
}

stock StartNewYearFour_SixMan(playerid, type)
{
    if(OnlineInfo[playerid][oNewYearQuest] > 0) return ErrorMessage(playerid,"{ff6347}Я уже выполняю какой-то квест!");
    if(PlayerInfo[playerid][pNewYearQuestComplete][type-1] == 1) return ErrorMessage(playerid,"{ff6347}Я уже выполнил данный квест!");
    if(!OnlineInfo[playerid][oLoadNewYear]) return ErrorMessage(playerid,"{ff6347}Мой аккаунт еще не успел до конца загрузится!");
    if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid,"{ff6347}Доступно только с лаунчером!");
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_hello.mp3");

    OnlineInfo[playerid][oNewYearQuest] = type;
    new lines[500];
	if(type == 4) format(lines,sizeof(lines),"{D93A49}Хэй, ты! Здравствуй.\n"\
                                "\n{cccccc}Давай-ка посоревнуемся!"\
                                "\n{cccccc}Я мастер в лизание ложек, победишь меня, дам подарок"\
                                "\n{cccccc}Но знай, мой язык самый лучшей в данном деле!"\
                                "\n\n{cccccc}Готов начать?");
    if(type == 5) format(lines,sizeof(lines),"{D93A49}Хэй, ты! Здравствуй.\n"\
                                "\n{cccccc}Давай-ка посоревнуемся, в лизание горшков мне нет равных!"\
                                "\n{cccccc}Это тебе не ложки с мисками лизать, это дело серьезное!"\
                                "\n{cccccc}От меня конечно будет подгон если сможешь одолеть меня!"\
                                "\n\n{cccccc}Готов начать?");
    if(type == 6) format(lines,sizeof(lines),"{D93A49}Ну здарова, пи... Ой.\n"\
                                "\n{cccccc}Прокачал свой язык уже у моих братьев?"\
                                "\n{cccccc}Ну давай, смотри сколько тарелок!"\
                                "\n{cccccc}МЕНЯ ТЫ ЯВНО НЕ ПОБЕДИШЬ!"\
                                "\n\n{cccccc}Готов начать?");
	ShowDialog(playerid,NEWYEAR_SHOW_STARTQUEST,DIALOG_STYLE_MSGBOX, "{ff9000}Новогодний квест", lines, "Да", "Нет");
	return true;
}

stock CloseNewYearQuestFour_Six(playerid, type)
{
    //if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_win.mp3");

    if(type == 4) SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Еб... Копать, вот это ты дал, я в шоке...");
    if(type == 5) SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: КАК? КАК ТЫ ЭТО СДЕЛАЛ? Я растроен...");
    if(type == 6) SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Теперь ты самый главный лизун этого штата!");

    GiveNewYesrCase(playerid);
    PlayerInfo[playerid][pNewYearQuestComplete][type-1] = 1;
    OnlineInfo[playerid][oNewYearQuest] = 0;
    SaveNewYearQuestPlayer(playerid);

    return true;
}

stock NewYearCreateActor(playerid)
{
    new type = OnlineInfo[playerid][oNewYearQuest];
    if(type == 0) return 0;
    SaveReturnCoord(playerid);
    S_SetPlayerVirtualWorld(playerid,playerid, 0);
    if(type == 4)
    {
        NewYearNPC[playerid][nyActor] = CreateDynamicActor(657, 3302.3210,-324.2007,8.6647,71.6287, true,100,playerid,0);
        PPSetPlayerPos(playerid, 3301.5732,-325.4966,8.6647);
        PPSetPlayerFacingAngle(playerid, 42.0);
        SetCameraBehindPlayer(playerid);
    }
    else if(type == 5)
    {
        NewYearNPC[playerid][nyActor] = CreateDynamicActor(657, 3323.7632,-336.3015,8.7701,46.8983, true,100,playerid,0);
        PPSetPlayerPos(playerid, 3322.0596,-334.2267,8.7701);
        PPSetPlayerFacingAngle(playerid, 216.0);
        SetCameraBehindPlayer(playerid);
    }
    else if(type == 6)
    {
        NewYearNPC[playerid][nyActor] = CreateDynamicActor(657, 3325.7983,-354.0862,8.3832,287.8539, true,100,playerid,0);
        PPSetPlayerPos(playerid, 3328.3503,-353.2623,8.3832);
        PPSetPlayerFacingAngle(playerid, 109.0);
        SetCameraBehindPlayer(playerid);
    }
    ApplyDynamicActorAnimation(NewYearNPC[playerid][nyActor],"FOOD","EAT_Pizza",4.1, false, false, false, false, 1000);
    Pump_StartNewYearQuest(playerid);
    return true;
}

stock NewYearDeleteActor(playerid)
{
    if(NewYearNPC[playerid][nyActor] != 0) DestroyDynamicActor(NewYearNPC[playerid][nyActor]);
    NewYearNPC[playerid][nyActor] = 0;
    OnlineInfo[playerid][oNewYearQuest] = 0;
    NewYearNPC[playerid][nyTimers] = 0;
    return true;
}

stock Pump_NewYearQuest(playerid)
{
	SetPVarInt(playerid, "oryjtemp", GetPVarInt(playerid, "oryjtemp") + 1 + random(3));

    new Float:actorX, Float:actorY, Float:actorZ;
    GetDynamicActorPos(NewYearNPC[playerid][nyActor], actorX, actorY, actorZ);
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, actorX,actorY,actorZ)) 
    {
        SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
        PPSetPlayerPos(playerid, OnlineInfo[playerid][oReturnCord][0],OnlineInfo[playerid][oReturnCord][1],OnlineInfo[playerid][oReturnCord][2]);
        S_SetPlayerVirtualWorld(playerid, OnlineInfo[playerid][oReturnWorld], OnlineInfo[playerid][oReturnInt]);
        HidePlayerHudTask(playerid);
        NewYearDeleteActor(playerid);
        return ErrorMessage(playerid, "{ff6347}Вы далеко от точки квеста! Квест прерван");
    }
	if(GetPVarInt(playerid,"oryjtemp") >= 1000)
	{
	 	GameTextForPlayer(playerid, RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Облизывание: ~w~1000/1000"), 1500, 3);
	 	ClearAnim(playerid);
        PPSetPlayerPos(playerid, OnlineInfo[playerid][oReturnCord][0],OnlineInfo[playerid][oReturnCord][1],OnlineInfo[playerid][oReturnCord][2]);
        S_SetPlayerVirtualWorld(playerid, OnlineInfo[playerid][oReturnWorld], OnlineInfo[playerid][oReturnInt]);
        new type = OnlineInfo[playerid][oNewYearQuest];
        HidePlayerHudTask(playerid);
        CloseNewYearQuestFour_Six(playerid,type);
        SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
	}
	else
	{
		new string[75];
		format(string, sizeof(string), RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Облизывание: ~w~%d/1000"), GetPVarInt(playerid, "oryjtemp"));
	 	GameTextForPlayer(playerid, string, 1500, 3);
	 	ApplyAnimation(playerid, "FOOD","EAT_Pizza",4.1, false, false, false, false,false, SYNC_ALL);
 	}
 	return true;
}

stock Pump_StartNewYearQuest(playerid)
{
    SetPVarInt(playerid, "oryjtemp", 0); SetPVarInt(playerid, "Arobsklad", 17);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Теперь мне нужно начать лизать {ff9000}[ Нажимайте %s ]", buttonName[Device[playerid]]);

    NewYearNPC[playerid][nyTimers] = 100;

    return true;
}

stock StartNewYearThreeMan(playerid)
{
    if(OnlineInfo[playerid][oNewYearQuest] > 0) return ErrorMessage(playerid,"{ff6347}Я уже выполняю какой-то квест!");
    if(PlayerInfo[playerid][pNewYearQuestComplete][2] == 1) return ErrorMessage(playerid,"{ff6347}Я уже выполнил данный квест!");
    if(!OnlineInfo[playerid][oLoadNewYear]) return ErrorMessage(playerid,"{ff6347}Мой аккаунт еще не успел до конца загрузится!");
    if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid,"{ff6347}Доступно только с лаунчером!");
    if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_hello.mp3");

    OnlineInfo[playerid][oNewYearQuest] = 3;
    new lines[500];
	format(lines,sizeof(lines),"{D93A49}Ей, ты! Здравствуй.\n"\
                                "\n{cccccc}Принеси мне хлеба, про братски. Только я люблю испорченный."\
                                "\n{cccccc}Я не знаю, ну поищи на помойке, что-ле."\
                                "\n{cccccc}От меня разумеется подарок!"\
                                "\n\n{cccccc}Готов начать?");
	ShowDialog(playerid,NEWYEAR_SHOW_STARTQUEST,DIALOG_STYLE_MSGBOX, "{ff9000}Новогодний квест", lines, "Да", "Нет");
	return true;
}

stock CloseNewYearQuestThree(playerid)
{
    if(get_invent4(playerid, 1, 0) <= 0 || get_para(playerid, 1) < gettime()) return ErrorMessage(playerid, "{FF6347}У вас нет испорченнего хлеба");
    if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/3/3_win.mp3");

    SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Класс! Спасибо тебе большое! Век не забуду. Держи подарок");
    SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Не забудь зайти завтра к моему брату, Ложколизу");

    GiveNewYesrCase(playerid);
    PlayerInfo[playerid][pNewYearQuestComplete][2] = 1;
    OnlineInfo[playerid][oNewYearQuest] = 0;
    OnlineInfo[playerid][oNewYearQuestDop] = 0;
    TakeInvent(playerid, 1, 1, 0, 999);
    SaveNewYearQuestPlayer(playerid);
    return true;
}

stock StartNewYearTwoMan(playerid)
{
    if(OnlineInfo[playerid][oNewYearQuest] > 0) return ErrorMessage(playerid,"{ff6347}Я уже выполняю какой-то квест!");
    if(PlayerInfo[playerid][pNewYearQuestComplete][1] == 1) return ErrorMessage(playerid,"{ff6347}Я уже выполнил данный квест!");
    if(!OnlineInfo[playerid][oLoadNewYear]) return ErrorMessage(playerid,"{ff6347}Мой аккаунт еще не успел до конца загрузится!");
    if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid,"{ff6347}Доступно только с лаунчером!");
    if(OnlineInfo[playerid][oListenRadioPears] == 0) 
    {
        if(PlayerInfo[playerid][pSex] == 2) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/2/2_hello_w.mp3");
        else PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/2/2_hello.mp3");
    }
    OnlineInfo[playerid][oNewYearQuest] = 2;
    new lines[500];
	format(lines,sizeof(lines),"{D93A49}О, здарова. Рад, что ты пришё%s\n"\
                                "\n{cccccc}Молока хочу, ваще борода. Но этот гад фермер зажал мне его"\
                                "\n{cccccc}Сгоняй на ферму и привези мне оттуда молока"\
                                "\n{cccccc}У тебя есть 5 минут, с меня подгон!"\
                                "\n\n{cccccc}Готов начать?",PlayerInfo[playerid][pSex] == 2 ? "ла" : "л");
	ShowDialog(playerid,NEWYEAR_SHOW_STARTQUEST,DIALOG_STYLE_MSGBOX, "{ff9000}Новогодний квест", lines, "Да", "Нет");
	return true;
}

stock HandlerNewYearQuestTwo(playerid)
{
    if(NewYearNPC[playerid][nyTimers] > 0)
    {
        NewYearNPC[playerid][nyTimers]--;
        new string[100];
        if(OnlineInfo[playerid][oNewYearQuest] == 2)
        {
            format(string,sizeof(string),"Осталось %d секунд, за которое нужно получить молоко и доставить его Канавному Осталому",NewYearNPC[playerid][nyTimers]);
            SetPlayerHudTask(playerid, "Новогодний Квест", string);
            if(NewYearNPC[playerid][nyTimers] <= 0)
            {
                OnlineInfo[playerid][oNewYearQuest] = 0;
                OnlineInfo[playerid][oNewYearQuestDop] = 0;
                if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/2/2_loose.mp3");
                SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Ха-ха-ха. Ну что ты? Даже молока привезти нормально не можешь?");
                HidePlayerHudTask(playerid);
            }
        }
        else if(OnlineInfo[playerid][oNewYearQuest] >= 4 && OnlineInfo[playerid][oNewYearQuest] <= 6)
        {
            ApplyDynamicActorAnimation(NewYearNPC[playerid][nyActor],"FOOD","EAT_Pizza",4.1, false, false, false, false, 1000);
            format(string,sizeof(string),"Очков Йольского Парня %d",10*(100 - NewYearNPC[playerid][nyTimers]));
            SetPlayerHudTask(playerid, "Новогодний Квест", string);
            if(NewYearNPC[playerid][nyTimers] <= 0)
            {
                OnlineInfo[playerid][oNewYearQuest] = 0;
                SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
                NewYearDeleteActor(playerid);
                PPSetPlayerPos(playerid, OnlineInfo[playerid][oReturnCord][0],OnlineInfo[playerid][oReturnCord][1],OnlineInfo[playerid][oReturnCord][2]);
                S_SetPlayerVirtualWorld(playerid, OnlineInfo[playerid][oReturnWorld], OnlineInfo[playerid][oReturnInt]);
                if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/2/2_loose.mp3");
                SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Ха-ха-ха. Ну что ты? Даже молока привезти нормально не можешь?");
                HidePlayerHudTask(playerid);
            }
        }
    }
    return true;
}

stock CloseNewYearQuestTwo(playerid)
{
    if(get_invent4(playerid, 102, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет молока");
    if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/2/2_win.mp3");
    SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Оооо, заебумба. Держи подгон! Заходи завтра к моему братану, Обрубку.");
    GiveNewYesrCase(playerid);
    NewYearNPC[playerid][nyTimers] = 0;
    PlayerInfo[playerid][pNewYearQuestComplete][1] = 1;
    OnlineInfo[playerid][oNewYearQuest] = 0;
    OnlineInfo[playerid][oNewYearQuestDop] = 0;
    HidePlayerHudTask(playerid);
    TakeInvent(playerid, 102, 1, 0, 999);
    SaveNewYearQuestPlayer(playerid);
    return true;
}

stock StartNewYearOneMan(playerid)
{
    if(OnlineInfo[playerid][oNewYearQuest] > 0) return ErrorMessage(playerid,"{ff6347}Я уже выполняю какой-то квест!");
    if(PlayerInfo[playerid][pNewYearQuestComplete][0] == 1) return ErrorMessage(playerid,"{ff6347}Я уже выполнил данный квест!");
    if(!OnlineInfo[playerid][oLoadNewYear]) return ErrorMessage(playerid,"{ff6347}Мой аккаунт еще не успел до конца загрузится!");
    if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid,"{ff6347}Доступно только с лаунчером!");
    if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/1/1_hello.mp3");
    OnlineInfo[playerid][oNewYearQuest] = 1;
    new lines[300];
	format(lines,sizeof(lines),"{D93A49}Хо хо хо\n{D93A49}С новым годом, емае!"\
                                "\n\n{cccccc}Я сейчас собираюсь покрамсать овечек у одного фермера"\
                                "\n{cccccc}Если грохнешь больше овечек чем я, получишь от меня подгон"\
                                "\n\n{cccccc}Пушка есть?");
	ShowDialog(playerid,NEWYEAR_SHOW_STARTQUEST,DIALOG_STYLE_MSGBOX, "{ff9000}Новогодний квест", lines, "Да", "Нет");
	return true;
}

stock CreateQuestOneMan(playerid)
{
    SaveReturnCoord(playerid);
    S_SetPlayerVirtualWorld(playerid,playerid, 0);
    PPSetPlayerPos(playerid, -164.4, 1.0, 3.11);
    PPSetPlayerFacingAngle(playerid, 65.0);
    SetCameraBehindPlayer(playerid);

    NewYearNPC[playerid][nyID] = CreateNpc(15845, -164.0, 15.0, 3.11);
    SetNpcVirtualWorld(NewYearNPC[playerid][nyID], playerid);
    SetNpcInvulnerable(NewYearNPC[playerid][nyID]);
    SetNpcStunAnimationEnabled(NewYearNPC[playerid][nyID], false);
    SetNpcWeapon(NewYearNPC[playerid][nyID], WEAPON_MINIGUN);
    SetNpcWeaponSkill(NewYearNPC[playerid][nyID],NPC_SKILL_TYPE_PRO);

    new Float:ShipCoordX, Float:ShipCoordY, Float:ShipCoordZ = 50;
    for(new i; i < 10; i++)
    {
        ShipCoordX = random(55)-229, ShipCoordY = random(150)-79;
        CA_FindZ_For2DCoord(ShipCoordX,ShipCoordY,ShipCoordZ);
        ShipCoordZ += 1.5;
        ShipNPC[playerid][i] = CreateNpc(15696, ShipCoordX, ShipCoordY, ShipCoordZ);
        SetNpcVirtualWorld(ShipNPC[playerid][i], playerid);
        SetNpcHealth(ShipNPC[playerid][i], 100.0);
        ShipNPCHealt[playerid][i] = 100.0;
    }
    new ship = random(10);
    TaskNpcAttackNpc(NewYearNPC[playerid][nyID], ShipNPC[playerid][ship], true);
    NewYearNPC[playerid][nyTargetNpc] = ShipNPC[playerid][ship];

    return 1;
}

stock DestroyQuestOneMan(playerid)
{
    PPSetPlayerPos(playerid, OnlineInfo[playerid][oReturnCord][0],OnlineInfo[playerid][oReturnCord][1],OnlineInfo[playerid][oReturnCord][2]);
	S_SetPlayerVirtualWorld(playerid, OnlineInfo[playerid][oReturnWorld], OnlineInfo[playerid][oReturnInt]);
    OnlineInfo[playerid][oNewYearQuest] = 0;
    if(IsValidNpc(NewYearNPC[playerid][nyID])) DestroyNpc(NewYearNPC[playerid][nyID]);
    for(new i; i < 10; i++)
    {
        if(IsValidNpc(ShipNPC[playerid][i])) DestroyNpc(ShipNPC[playerid][i]);
    }
    HidePlayerHudTask(playerid);

    if(CountKill[playerid][0] > CountKill[playerid][1])
    {
        if(OnlineInfo[playerid][oListenRadioPears] == 0)
        {
            if(PlayerInfo[playerid][pSex] == 2) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/1/1win_w.mp3");
            else PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/1/1win.mp3");
        }
        SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: %s Не ожидал, что ты сможешь меня победить, емае", PlayerInfo[playerid][pSex] == 2 ? "Красотка!" : "Красавец!");
        SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Вот подгон, как и обещал. Заходи к моему братану, Канавному Остолопу завтра!");
        GiveNewYesrCase(playerid);
        PlayerInfo[playerid][pNewYearQuestComplete][0] = 1;
        SaveNewYearQuestPlayer(playerid);
    }
    else
    {
        if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/1/1loose.mp3");
        SendClientMessage(playerid, COLOR_GREY, "{D93A49}Йольский парень{cccccc}: Тюююю, я знал что ты не сдюжишь!");
    }
    CountKill[playerid][0] = 0;
    CountKill[playerid][1] = 0;

    return 1;
}

stock GiveNewYesrCase(playerid)
{
    new thingId, thingQuan, thingType, thingPara, thingPack;
    CreateCasePlayer(playerid, thingId, thingQuan, thingType, thingPara, thingPack,"newyear25");
    new put_inva = GiveThingPlayer(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack, 9999);
    //CalculateVehicleLimited(thingId, thingType);
    if(put_inva == -1)
    {
        Throw(playerid, thingId, thingQuan, thingPara, 0, thingType, thingPack);
        SendClientMessage(playerid, COLOR_GREY, "{0088ff}Вам выпал кейс в подарок. {ffcc66}[ В инвентаре нет места, кейс упал на землю ]");
    }
    new quan = 0;
    for(new i; i < 13; i++)
    {
        if(PlayerInfo[playerid][pNewYearQuestComplete][i]) quan++;
    }
    if(quan >= 12) CompleteBattlePassTask(playerid, 0, 2);
    return 1;
}
stock LifeNewYearQuestOne(playerid)
{
    new quanshipnolife;
    if(IsValidNpc(NewYearNPC[playerid][nyID]))
    {
        new Float:ShipCoordX, Float:ShipCoordY, Float:ShipCoordZ;
        new Float:tempHealt;

        for(new i = 0; i < 10; i++)
        {
            if(IsValidNpc(ShipNPC[playerid][i]))
            {
                GetNpcHealth(ShipNPC[playerid][i],tempHealt);
                if(tempHealt <= 0.0) 
                {
                    quanshipnolife++;
                    if(NewYearNPC[playerid][nyTargetNpc] != ShipNPC[playerid][i]) continue;
                    else 
                    {
                        TaskNpcStandStill(NewYearNPC[playerid][nyID]);
                        CountKill[playerid][1]++;
                        for(new s = 0; s < 10; s++)
                        {
                            if(!IsValidNpc(ShipNPC[playerid][s])) continue;
                            GetNpcHealth(ShipNPC[playerid][s],tempHealt);
                            if(tempHealt <= 0.0) continue;
                            else
                            {
                                NewYearNPC[playerid][nyTargetNpc] = ShipNPC[playerid][s];
                                TaskNpcAttackNpc(NewYearNPC[playerid][nyID], ShipNPC[playerid][s], true);
                                break;
                            }
                        }
                    }
                }
                else
                {
                    ShipCoordX = random(55)-229, ShipCoordY = random(150)-79;
                    CA_FindZ_For2DCoord(ShipCoordX,ShipCoordY,ShipCoordZ);
                    ShipCoordZ += 1.5;
                    TaskNpcGoToPoint(ShipNPC[playerid][i],ShipCoordX,ShipCoordY,ShipCoordZ, NPC_MOVE_MODE:2);
                }
            }
        }
    }

    new string[100];
    format(string,sizeof(string),"Моих убийств: %d\nУбийств Жердина-из-овчарни: %d",CountKill[playerid][0],CountKill[playerid][1]);
    SetPlayerHudTask(playerid, "Новогодний Квест", string);
    
    if(quanshipnolife >= 10) return DestroyQuestOneMan(playerid);
    return true;
}

stock NewYearQuestOne_OnNpcDeath(NPC:npc, killerid, reason)
{
    #pragma unused reason
    for(new i; i < 10; i++)
    {
        if(ShipNPC[killerid][i] == npc) 
        {
            CountKill[killerid][0]++;
            return true;
        }
    }
    return false;
}

stock NewYearQuestOne_OnPlayerGiveDamageNpc(NPC:npc, damagerid, Float:amount, weaponid, bodypart)
{
    #pragma unused weaponid
    #pragma unused bodypart
    #pragma unused amount
    
    new findSlot = -1;
    for(new i = 0; i < 10; i++)
    {
        if(ShipNPC[damagerid][i] == npc)
        {
            findSlot = i;
            break;
        }
    }

    if(findSlot >= 0)
    {
        ShipNPCHealt[damagerid][findSlot] -= 20;
        SetNpcHealth(ShipNPC[damagerid][findSlot], ShipNPCHealt[damagerid][findSlot]);
    }
    return true;
}


//=========================================================
//=================== Касцена Лапландия=====================
new LaplandiaTimer[MAX_PLAYERS];

stock LaplandiaCuteScene(playerid)
{
    TogglePlayerControllable(playerid,false);
    FlyCameraPos(playerid, 3258.263427, -363.157165, 15.110763, 3263.212158, -363.009460, 14.412275, 28000, 1200);
    SetPVarInt(playerid,"qweststat",85), SetPVarInt(playerid,"qwesttime",1);
    LaplandiaTimer[playerid] = SetTimerEx("LaplandiaTimers", 28000, true, "d", playerid);
    PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jolosveinar/jolo.mp3");
    return true;
}

stock DestroyLaplandiaCuteScene(playerid)
{
    if(LaplandiaTimer[playerid] > 0)
    {
        SetCameraBehindPlayer(playerid);
        KillTimer(LaplandiaTimer[playerid]);
        LaplandiaTimer[playerid] = 0;
        TogglePlayerControllable(playerid,true);
        DoneHintPlayer(playerid,4);
        return true;
    }
    return false;
}

function LaplandiaTimers(playerid)
{
    DestroyLaplandiaCuteScene(playerid);
    return true;
}
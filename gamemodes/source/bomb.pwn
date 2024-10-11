
#define MAX_BOMB 10 // Максимальное количество взрывов или активных бомб
#define MAX_OBJECT_RUINS 7 // Количество объектов после взрыва

enum boInfo
{
    boStat, // Статус взрыва или бомбы
    Float: boPos[3], // Позиция взрыва
    boWorld, // Вирт мир
    boInterior, // Интерьер
    boObject[MAX_OBJECT_RUINS], // ID объектов после взрыва
    boProcess, // Статус руин
    boTrainRoad, // Лежат ли руины на жд путях
    Text3D:boRuinsLabel
}
new RuinsInfo[MAX_BOMB][boInfo];

new NGSAStickyBombs[2], NGSAExplodeObjects[6], NGSAExplodeCD, NGSAExplodeGates = INVALID_STREAMER_ID;
stock NGSAStickyBombInit()
{
    new object_world = INVISIBLE_VIRTUAL_WORLD, object_int = 0; // Все объекты по умолчанию скрыты

    // Бомбы-липучки
    NGSAStickyBombs[0] = CreateDynamicObject(363, 96.652191, 1921.186035, 19.084711, -7.700006, 32.399978, -89.999954, object_world, object_int, -1, 300.00, 300.00);
    NGSAStickyBombs[1] = CreateDynamicObject(363, 96.627006, 1920.013549, 18.453948, -1.800010, -17.000047, -89.999954, object_world, object_int, -1, 300.00, 300.00);

    // Эффект взрыва
    NGSAExplodeObjects[0] = CreateDynamicObject(18683, 96.764518, 1920.437866, 17.372821, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
    
    // После взрыва
    NGSAExplodeObjects[1] = CreateDynamicObject(8674, 101.095222, 1926.277221, 17.327096, -17.900001, 0.000000, -50.699996, object_world, object_int, -1, 300.00, 300.00);
    NGSAExplodeObjects[2] = CreateDynamicObject(8674, 102.555877, 1914.463378, 17.315469, 84.000022, -26.099998, 75.800186, object_world, object_int, -1, 300.00, 300.00);
    NGSAExplodeObjects[3] = CreateDynamicObject(868, 99.370643, 1917.819458, 17.075191, 14.600003, -18.400007, -47.400024, object_world, object_int, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NGSAExplodeObjects[3], 0, 16110, "desert", "des_redrock2", 0x00000000);
    NGSAExplodeObjects[4] = CreateDynamicObject(867, 101.473983, 1923.929809, 17.244083, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NGSAExplodeObjects[4], 0, 16110, "desert", "des_redrock2", 0x00000000);
    NGSAExplodeObjects[5] = CreateDynamicObject(897, 106.400779, 1919.870117, 11.953762, 1.999999, 8.299998, -12.199985, object_world, object_int, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NGSAExplodeObjects[5], 0, 16110, "desert", "des_redrock2", 0x00000000);

    return 1;
}

stock PlantBomb(playerid, time)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || HealthAC[playerid] <= 0) return 0;
    if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0) return ErrorMessage(playerid, "{FF6347}Нельзя установить бомбу в помещении");
    if(IsAAntidm(playerid)) return ErrorMessage(playerid, "{FF6347}Вы находитесь в зелёной зоне");
    if(box[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы на ринге");
    if(get_invent4(playerid, 11, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет бомбы");
    if(IsATrainStation(playerid)) return ErrorMessage(playerid, "{FF6347}Нельзя установить бомбу на железнодорожной станции\n{cccccc}Установите бомбу где-то в лесу, за городом");
    if(IsANotMoney(playerid)) return ErrorMessage(playerid, "{FF6347}Нельзя установить бомбу на территории города\n{cccccc}Установите бомбу где-то в лесу, за городом");
    if(!IsCreateBomb(playerid)) return 0;

    if(time < 10 || time > 300) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не меньше 10 и не больше 300 секунд");

    new result = Throw(playerid, 11, 1, time, 0, 0, 0); // Кладём предмет на землю
    if(!result) return 1;

    TakeInvent(playerid, 11, 1, 0, 999);
    if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, false, SYNC_ALL);
    PlayerPlaySound(playerid,25800,0,0,0);

    new string[140];
    format(string,sizeof(string),"{99ff66}Бомба установлена и взорвётся через %d секунд\n\n{cccccc}Отойдите как можно дальше, радиус взрыва более 50-ти метров", time);
    SuccessMessage(playerid, string);
    format(string,sizeof(string),"[ Мысли ]: Я установил%s бомбу {0088ff}[ Взрыв произойдёт через %d секунд ]", gender(playerid), time);
    SendClientMessage(playerid, COLOR_GREY, string);
	return 1;
}

stock dialogCase_Bomb(playerid, dialogid, response, const inputtext[])
{
	if(dialogid == 1335) // Установка таймера бомбы
	{
        if(response)
        {
            new input;
			if(sscanf(inputtext, "i", input)) return 0;
            PlantBomb(playerid, input);
        }
    }
    return 1;
}

CMD:gotoruins(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] <= 0) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    new string[80];
    if(sscanf(params, "i", params[0])) return format(string,sizeof(string),"[ Мысли ]: Телепорт к руинам от бомбы [ /gotoruins ID 0 - %d ]", MAX_BOMB - 1), SendClientMessage(playerid, COLOR_GREY, string);
    if(params[0] < 0 || params[0] >= MAX_BOMB) return format(string,sizeof(string),"[ Мысли ]: Не меньше 0 и не больше %d", MAX_BOMB - 1), SendClientMessage(playerid, COLOR_GREY, string);
    
    new r = params[0];
    if(RuinsInfo[r][boStat] == 0) return ErrorMessage(playerid, "{FF6347}Руин под этим ID не существует");
    S_SetPlayerVirtualWorld(playerid, RuinsInfo[r][boWorld], RuinsInfo[r][boInterior]), PPSetPlayerInterior(playerid, RuinsInfo[r][boInterior]);
	PPSetPlayerPos(playerid, RuinsInfo[r][boPos][0],RuinsInfo[r][boPos][1],RuinsInfo[r][boPos][2]);
	PPSetPlayerFacingAngle(playerid,0.0);
    return 1;
}

stock IsCreateBomb(playerid) // Создаём бомбу
{
    new quan;

    // Проверка на, рядом лежащие руины + считаем количество
    new stopNearbyRuins;
    for(new r; r < MAX_BOMB; ++r)
	{
        if(RuinsInfo[r][boStat] > 0)
        {
            if(IsPlayerInRangeOfPoint(playerid,200.0, RuinsInfo[r][boPos][0],RuinsInfo[r][boPos][1],RuinsInfo[r][boPos][2]) 
                && GetPlayerVirtualWorld(playerid) == RuinsInfo[r][boWorld] && GetPlayerInterior(playerid) == RuinsInfo[r][boInterior])
            {
                stopNearbyRuins = 1;
                break;
            }
            quan ++;
        }
    }
    if(stopNearbyRuins == 1)
    {
        ErrorMessage(playerid, "{FF6347}Слишком близко к другой, взорвавшейся бомбе\n\n{cccccc}Расстояние не менее 200 метров");
        return 0;
    }

    // Проверка на, рядом установленную бомбу + считаем количество
    new stopNearbyPlant;
    for(new g = 0; g < MAX_THROW; g++)
	{
		if(ThrowInfo[g][tId] == 11 && ThrowInfo[g][tType] == 0 && ThrowInfo[g][tBombPlant] == true) 
        {
            if(IsPlayerInRangeOfPoint(playerid,200.0, ThrowInfo[g][tX], ThrowInfo[g][tY], ThrowInfo[g][tZ]) 
                && GetPlayerVirtualWorld(playerid) == ThrowInfo[g][tWorld] && GetPlayerInterior(playerid) == ThrowInfo[g][tInt])
            {
                stopNearbyPlant = 1;
                break;
            }
            quan ++;
        }
    }
    if(stopNearbyPlant == 1)
    {
        ErrorMessage(playerid, "{FF6347}Слишком близко к другой, установленной бомбе\n\n{cccccc}Расстояние не менее 200 метров");
        return 0;
    }

    // Проверка на лимит бомб в данный момент
    if(quan >= 10)
    {
        ErrorMessage(playerid, "{FF6347}Вы не можете установить новую бомбу\n\n{cccccc}На сервере взорвалось или установлено 10 бомб\nВы можете найти завалы от бомбы и устранить их, освободив слоты");
        return 0;
    }
    return 1;
}

stock CreateRuinsAndExplosion(t) // Взрываем бомбу и создаём руины
{
    new r = -1;
    for(new i; i < MAX_BOMB; ++i)
	{
        if(RuinsInfo[i][boStat] == 0)
        {
            r = i;
            break;
        }
    }
    if(r == -1) return 0;
    CreateExplosion(ThrowInfo[t][tX], ThrowInfo[t][tY] , ThrowInfo[t][tZ], 7, 40);
	CreateExplosion(ThrowInfo[t][tX]-2, ThrowInfo[t][tY] , ThrowInfo[t][tZ], 7, 40);
	CreateExplosion(ThrowInfo[t][tX]+2, ThrowInfo[t][tY] , ThrowInfo[t][tZ], 7, 40);
	CreateExplosion(ThrowInfo[t][tX], ThrowInfo[t][tY]-2 , ThrowInfo[t][tZ], 7, 40);
	CreateExplosion(ThrowInfo[t][tX], ThrowInfo[t][tY]+2 , ThrowInfo[t][tZ], 7, 40);

    // Записываем точку взрыва, для создания руин
    RuinsInfo[r][boPos][0] = ThrowInfo[t][tX];
    RuinsInfo[r][boPos][1] = ThrowInfo[t][tY];
    RuinsInfo[r][boPos][2] = ThrowInfo[t][tZ];
    RuinsInfo[r][boWorld] = ThrowInfo[t][tWorld];
    RuinsInfo[r][boInterior] = ThrowInfo[t][tInt];

    if(ThrowInfo[t][tQara] > 0) RuinsInfo[r][boTrainRoad] = ThrowInfo[t][tQara] - 1; // Бомба на жд путях

    DestroyThrow(t); // Удаляем бомбу

    // Создаём объекты
    CreateObjectRuins(r, RuinsInfo[r][boPos][0],RuinsInfo[r][boPos][1],RuinsInfo[r][boPos][2], RuinsInfo[r][boWorld], RuinsInfo[r][boInterior]);


    RuinsInfo[r][boRuinsLabel] = CreateDynamic3DTextLabel("{ff9000}Завалы после взрыва бомбы\n{cccccc}Убрать завалы - Кувалда в руках + ПКМ",
        0xA9C4E4FF,RuinsInfo[r][boPos][0],RuinsInfo[r][boPos][1],RuinsInfo[r][boPos][2],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,RuinsInfo[r][boWorld], RuinsInfo[r][boInterior]);

    RuinsInfo[r][boProcess] = 200; // Статус руин (Сколько раз по ним нужно долбить игрокам, чтобы расчистить)
    RuinsInfo[r][boStat] = 1; // Статус - развалины лежат
    return 1;
}

stock CreateObjectRuins(r, Float:x, Float:y, Float:z, world, int)
{
    new object_world = 17, object_int = 228; // Временно скрываем созданные объекты
    RuinsInfo[r][boObject][0] = CreateDynamicObject(807, 1338.224121, 1570.133666, 9.930312, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][0], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][0], world, int);
    RuinsInfo[r][boObject][1] = CreateDynamicObject(868, 1338.411743, 1567.012817, 10.181000, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][1], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][1], world, int);
    RuinsInfo[r][boObject][2] = CreateDynamicObject(868, 1337.818847, 1568.278564, 10.181000, 0.000000, 0.000000, -17.299972, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][2], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][2], world, int);
    RuinsInfo[r][boObject][3] = CreateDynamicObject(868, 1339.605957, 1566.887939, 10.151001, 0.000000, 0.000000, 109.500015, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][3], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][3], world, int);
    RuinsInfo[r][boObject][4] = CreateDynamicObject(868, 1340.984008, 1568.182739, 10.181000, 0.000000, 0.000000, 80.700027, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][4], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][4], world, int);
    RuinsInfo[r][boObject][5] = CreateDynamicObject(868, 1340.567016, 1569.584960, 10.180319, 0.000000, 0.000000, 124.299995, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][5], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][5], world, int);
    RuinsInfo[r][boObject][6] = CreateDynamicObject(868, 1337.989624, 1569.360473, 10.180319, 0.000000, 0.000000, -55.300010, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][6], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][6], world, int);

    MatrixDynamicObjectPos(0, x, y, z, 0.0, 0.0, 0.0);
    return 1;
}

stock DestroyObjects(r)
{
    for(new i; i < MAX_OBJECT_RUINS; ++i) DestroyDynamicObject(RuinsInfo[r][boObject][i]);
    return 1;
}

stock IsAPointRuins(playerid, Float:dist) // Находим ближайшие руины от бомбы
{
    new ruinsId = -1;
    for(new r; r < MAX_BOMB; ++r)
	{
        if(RuinsInfo[r][boStat] == 0) continue;

        if(IsPlayerInRangeOfPoint(playerid, dist, RuinsInfo[r][boPos][0], RuinsInfo[r][boPos][1], RuinsInfo[r][boPos][2])
            && GetPlayerVirtualWorld(playerid) == RuinsInfo[r][boWorld] && GetPlayerInterior(playerid) == RuinsInfo[r][boInterior])
        {
            ruinsId = r;
            break;
        }
    }
    return ruinsId;
}

stock PressCleanUpRuins(playerid) // Нажимаем на кнопку PKM
{
    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, Afclick[playerid]);
    if(interval < 800) return 0;
    Afclick[playerid] = current_tick;

    new r = IsAPointRuins(playerid, 3.0);
    if(r >= 0)
    {
        if(Dei[playerid] != 4) return ErrorMessage(playerid, "{FF6347}У вас в руках нет кувалды [ Если завалы на ж/д путях, кувалда висит на поезде ]");
        if(RuinsInfo[r][boProcess] > 0)
        {   
            RuinsInfo[r][boProcess] --;
            if(PlayerInfo[playerid][pID] == 1) RuinsInfo[r][boProcess] -= 9; // Elon Musk

            new string[50];
            format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~%d/200", RuinsInfo[r][boProcess]);
            GameTextForPlayer(playerid,string,2000,3);
            ApplyAnimation(playerid,"SWORD","sword_4",2.0, false, false, false, false, false);

            if(RuinsInfo[r][boProcess] <= 0) // Завалы разгребли
            {
                DestroyObjects(r);
                RuinsInfo[r][boStat] = 0;
                DestroyDynamic3DTextLabel(RuinsInfo[r][boRuinsLabel]);

                Dei[playerid] = 0, RemovePlayerAttachedObject(playerid,1);
                GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Done",2000,3);

                // Поезд стоит по причине этих руин
                /*if(TrainMoved == 0 && ReasonToStopTrain > 0)
                {
                    new Float:pos[3];
	                GetVehiclePos(train, pos[0], pos[1], pos[2]);

                    // Запускаем таймер для начала движения поезда
                    TrainGoing = 1;
                    SetTimer("TrainStart", 20000, false);

                    // Пишем сообщение всем армейцам, которые рядом тусуются
                    foreach(Player,i)
                    {
                        if(OnlineInfo[i][oLogged] == 0 || fraction(i) != 3 || GetPlayerState(i) == PLAYER_STATE_SPECTATING
                            || GetPlayerVirtualWorld(i) != 0 || GetPlayerInterior(i) != 0) continue;
                        if(IsPlayerInRangeOfPoint(i,200.0, pos[0], pos[1], pos[2])) 
                        {
                            MessageTrainStartOnRuins(i);
                            if(Dei[i] == 4) Dei[i] = 0, RemovePlayerAttachedObject(i,1);
                        }
                    }
                }*/
            }
        }
    }
    return 1;
}

// Сбрасывает состояние ворот NGSA после взрыва бомбы
function NGSAStickyBombRestore()
{
    // Взрыва не было - ничего не делаем
    if (!IsValidDynamicObject(NGSAExplodeGates) || GetDynamicObjectVirtualWorld(NGSAExplodeGates) == 0) return 0;

    // Убираем объекты после взрыва
    for (new i = 0; i < sizeof(NGSAExplodeObjects); i++) SetDynamicObjectVirtualWorld(NGSAExplodeObjects[i], INVISIBLE_VIRTUAL_WORLD);

    // Возвращаем ворота
    SetDynamicObjectVirtualWorld(NGSAExplodeGates, 0);

    // Обновляем игрокам объекты в зоне стрима
    new Float: x, Float: y, Float: z;
    GetDynamicObjectPos(NGSAExplodeGates, x, y, z);
    foreach (new playerid : Player)
    {
        if (GetPlayerVirtualWorld(playerid) != 0) continue;
        if (!IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z)) continue;

        Streamer_Update(playerid, STREAMER_TYPE_OBJECT);    
    }

    // КД на повторную установку бомбы (только на основном сервере)
    if (server != 0) NGSAExplodeCD = gettime() + 3600; // 1 час

    return 1;
}

alias:resetngsabomb("rngsabomb")
CMD:resetngsabomb(playerid)
{
    if (PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if (!NGSAStickyBombRestore()) return ErrorMessage(playerid, "{FF6347}Ворота NGSA не взорваны");
    
    new string[144];
    format(string, sizeof(string), " [ ADM ]: %s восстановил состояние ворот NGSA после взрыва", PlayerInfo[playerid][pName]);
    ABroadCast(COLOR_ADM, string, 2);

    AdminLog("rngsabomb", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Восстановил состояние ворот NGSA");

    NGSAExplodeCD = 0;

    return 1;
}

stock UseStickyBomb(playerid, inva = 999)
{
    new vehicleid = IsAPosBootHardLock(playerid);
    if (IsValidVehicle(vehicleid)) { // Установка на багажник бронированного автомобиля
        if (IsVehicleOpen(playerid, vehicleid)) return ErrorMessage(playerid, "{FF6347}Вы можете открыть багажник этого транспорта [ N >> Багажник ]");
        
        new result = Throw(playerid, 205, 1, 10, 0, 0, 0, vehicleid); // Кладём предмет на землю
        if (!result) return ErrorMessage(playerid, "{FF6347}Ошибка! Лимит выброшенных предметов\nСвяжитесь с администрацией [ /report ]");

        TakeInvent(playerid, 205, 1, 0, inva);
        TurnPlayerFaceToVehicle(playerid, vehicleid);
        SuccessMessage(playerid, "{99ff66}Бомба установлена и взорвётся через 10 секунд\n{cccccc}Отойдите на безопасное расстояние");
    } else if (IsPlayerInRangeOfPoint(playerid, 5.0, 96.671943, 1922.000244, 19.729703)) { // Установка на ворота NGSA
        if (IsValidDynamicObject(NGSAExplodeGates) && GetDynamicObjectVirtualWorld(NGSAExplodeGates) != 0) return ErrorMessage(playerid, "{FF6347}Ворота уже были взорваны"), i_resetveshi(playerid);
        if (gettime() < NGSAExplodeCD) {
            i_resetveshi(playerid);

            new string[144];
            format(string, sizeof(string), "{FF6347}Бомба была установлена совсем недавно [ Можно через: %s ]", fine_time(NGSAExplodeCD - gettime()));
            return ErrorMessage(playerid, string);
        }
        
        // Находим ближайшую к игроку бомбу
        new Float: distance = 50.0, bombid = INVALID_STREAMER_ID;
        for (new i = 0; i < sizeof(NGSAStickyBombs); i++)
        {
            new objectid = NGSAStickyBombs[i];
            if (GetDynamicObjectVirtualWorld(objectid) == INVISIBLE_VIRTUAL_WORLD) { // Бомба не установлена
                new Float: x, Float: y, Float: z;
                GetDynamicObjectPos(objectid, x, y, z);

                new Float: objectdistance = GetPlayerDistanceFromPoint(playerid, x, y, z);
                if (objectdistance < distance)
                {
                    distance = objectdistance;
                    bombid = objectid;
                }
            }
        }

        if (!IsValidDynamicObject(bombid)) return ErrorMessage(playerid, "{FF6347}Бомба уже была установлена, ожидайте пока она взорвётся");

        new Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz;
        GetDynamicObjectPos(bombid, x, y, z);
        GetDynamicObjectRot(bombid, rx, ry, rz);
        SetDynamicObjectVirtualWorld(bombid, 0);

        foreach (new id : Player)
        {
            if (GetDistanceBetweenPlayers(playerid, id) <= 10.0)
            {
                Streamer_Update(id, STREAMER_TYPE_OBJECT);
            }
        }

        new bool: completed = true; // Бомбы установлены
        for (new i = 0; i < sizeof(NGSAStickyBombs); i++)
        {
            new objectid = NGSAStickyBombs[i];
            if (GetDynamicObjectVirtualWorld(objectid) == INVISIBLE_VIRTUAL_WORLD)
            {
                completed = false;
                break;
            }
        }

        TakeInvent(playerid, 205, 1, 0, inva);
        
        if (completed)
        {
            SetThrow(playerid, 205, 205, 1, 10, 0, 0, 0, INVISIBLE_VIRTUAL_WORLD, INVISIBLE_VIRTUAL_WORLD, x, y, z, rx, ry, rz, 600, 0, 0);
            SuccessMessage(playerid, "{99ff66}Бомбы установлены и взорвутся через 10 секунд\n\n{cccccc}Отойдите на безопасное расстояние и дождитесь взрыва\nУ вас будет ровно 20 минут перед тем, как ворота починят!");
        } else {
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, false, SYNC_ALL);
            around_player_audio(playerid, 25800, 0, 8.0);
            SetPlayerChatBubble(playerid,"устанавливает бомбу-липучку",COLOR_PURPLE,20.0,3000);

            i_resetveshi(playerid);
            return SuccessMessage(playerid, "{99ff66}Бомба установлена!\n\n{cccccc}Чтобы взорвать ворота, вам необходимо установить ещё одну взрывчатку");
        }
    } else {
        return ErrorMessage(playerid, 
            "{ff9000}Бомба-липучка должна быть установлена на подходящей поверхности:\n\n" \
            \
            "{cccccc}- Багажник бронированного транспорта\n" \
            "{cccccc}- Ворота военной базы (Area 51)"
        );
    }

    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, false, SYNC_ALL);
    around_player_audio(playerid, 25800, 0, 8.0);

    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я установил%s бомбу {0088ff}[ Взрыв произойдёт через 10 секунд ]", gender(playerid));
    SetPlayerChatBubble(playerid,"устанавливает бомбу-липучку",COLOR_PURPLE,20.0,3000);

    return 1;
}

stock StickyBompExplosion(t)
{
    new vehicleid = ThrowInfo[t][tOpenVehicleBomp];
    if (IsValidVehicle(vehicleid)) {
        if(IsVehicleInRangeOfPoint(vehicleid, 20.0, ThrowInfo[t][tX], ThrowInfo[t][tY] , ThrowInfo[t][tZ])) LockCar(vehicleid, 0);
        CreateExplosion(ThrowInfo[t][tX], ThrowInfo[t][tY] , ThrowInfo[t][tZ], 12, 3);
    } else if (GetDistanceBetweenPoints3D(ThrowInfo[t][tX], ThrowInfo[t][tY], ThrowInfo[t][tZ], 96.671943, 1922.000244, 19.729703) <= 5.0) { // Взрыв ворот NGSA
        for (new i = 0; i < sizeof(NGSAStickyBombs); i++)
        {
            new objectid = NGSAStickyBombs[i];
            SetDynamicObjectVirtualWorld(objectid, INVISIBLE_VIRTUAL_WORLD);
        }

        // Эффекты взрыва
        for (new i = 0; i < sizeof(NGSAExplodeObjects); i++) SetDynamicObjectVirtualWorld(NGSAExplodeObjects[i], 0);
        SetTimerEx("SetDynamicObjectVirtualWorld", 500, false, "dd", NGSAExplodeObjects[0], INVISIBLE_VIRTUAL_WORLD);

        // Убираем ворота
        if (!IsValidDynamicObject(NGSAExplodeGates))
        {
            new objects[5];
            new count = Streamer_GetNearbyItems(96.671943, 1922.000244, 19.729703, STREAMER_TYPE_OBJECT, objects, .range = 2.0, .worldid = 0);
            for (new i = 0; i < min(count, sizeof(objects)); i++)
            {
                if (GetDynamicObjectModel(objects[i]) == 19313) {
                    NGSAExplodeGates = objects[i];
                    break;
                }
            }
        }
        SetDynamicObjectVirtualWorld(NGSAExplodeGates, INVISIBLE_VIRTUAL_WORLD);

        foreach (new id : Player)
        {
            if (IsPlayerInRangeOfPoint(id, 10.0, ThrowInfo[t][tX], ThrowInfo[t][tY], ThrowInfo[t][tZ]))
            {
                PlayerPlaySound(id, 17003, ThrowInfo[t][tX], ThrowInfo[t][tY], ThrowInfo[t][tZ]);
                Streamer_Update(id, STREAMER_TYPE_OBJECT);
            }
        }

        CreateExplosion(ThrowInfo[t][tX], ThrowInfo[t][tY], ThrowInfo[t][tZ], 11, 3);
        SetTimer("NGSAStickyBombRestore", 1200 * 1000, false); // Восстанавливаем ворота через 20 минут
    }

    DestroyThrow(t); // Удаляем бомбу
    return 1;
}

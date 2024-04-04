
#define STREAMER_EXTRA_TYPE_TRAILER_ENTER	E_STREAMER_CUSTOM(3)
#define MAX_TRAILERS 1000 // Максимальное количество трейлеров

// Минимальный и максимальный виртуальный мир для трейлеров
#define MIN_TRAILER_WORLD 5000
#define MAX_TRAILER_WORLD 5999

// Получаем вирт мир динамического объекта
stock GetDynamicObjectVirtualWorld(objectid) return Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_WORLD_ID);

// Получаем интерьер динамического объекта
stock GetDynamicObjectInterior(objectid) return Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_INTERIOR_ID);

// Получаем модель динамического объекта
stock GetDynamicObjectModel(objectid) return Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);

// Данные о трейлерах
enum e_TrailerInfo {
    tNewid, // id в таблице
	tID, // ID трейлера
	tOwnerID, // ID аккаунта владельца
	tModel, // ID модели трейлера
	Float: tPos[3], Float: tRot[3], Float: tPic[3], // Позиция в игровом мире
	Text3D: t3DLabel, // Идентификатор 3д текста у входа
	tEnterPickup, // Идентификатор иконки домика
	tAttached, // ID транспорта водителя - к нему прикреплен трейлер
	tObject, // ID объекта (и для аттача, и если трейлер уже установлен)
    tVehicle, // ID невидимого транспорта, к которому прикреплен объект трейлера
	bool: tActive, // Статус существования в игровом мире
	bool: tLocked, // Статус дверей
	tTimerID, // Хранит идентификатор таймера для сохранения прицепа
    tBreaking // Хранит ID игрока, взламывающего трейлер
}
new trailerInfo[MAX_TRAILERS][e_TrailerInfo];

const TRAILER_INVISIBLE_VEH_MODEL = 606; // ID невидимого транспорта для прикрепления объекта трейлера
const TRAILER_INVISIBLE_VEH_INTERIOR = 101; // Интерьер невидимого транспорта для трейлера

// Создает трейлер в игровом мире
stock PlaceTrailer(id, model, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz)
{
    if (id < 0 || id > MAX_TRAILERS) return;
    if (trailerInfo[id][tOwnerID] <= 0) return;

    // Установка трейлера
    UnloadPlacedTrailer(id);
    if (trailerInfo[id][tObject] > 0) {
        Streamer_SetIntData(STREAMER_TYPE_OBJECT, trailerInfo[id][tObject], E_STREAMER_ATTACHED_VEHICLE, INVALID_VEHICLE_ID);
        SetDynamicObjectPos(trailerInfo[id][tObject], x, y, z);
        SetDynamicObjectRot(trailerInfo[id][tObject], rx, ry, rz);
    } else trailerInfo[id][tObject] = CreateDynamicObject(trailerInfo[id][tModel], x, y, z, rx, ry, rz, 0, 0);
    // Размещение входа    
    new Float: doorX, Float: doorY, Float: doorZ;
    switch (model) {
        case 3171: GetRelativePos(x, y, z, rx, ry, rz, (1347.1438 - 1348.899902), (1594.2501 - 1594.863769), (10.8203 - 9.820312), doorX, doorY, doorZ);
        case 3172: GetRelativePos(x, y, z, rx, ry, rz, (1350.9469 - 1352.759643), (1573.7472 - 1574.919677), (11.0155 - 9.820312), doorX, doorY, doorZ);
        case 3174: GetRelativePos(x, y, z, rx, ry, rz, (1360.8247 - 1362.623901), (1592.9111 - 1593.942260), (10.8203 - 9.820312), doorX, doorY, doorZ);
        case 3168: GetRelativePos(x, y, z, rx, ry, rz, (1369.5554 - 1371.515380), (1576.9391 - 1577.505981), (10.8125 - 9.820312), doorX, doorY, doorZ);
    }

    new string_mysql[80];
    format(string_mysql,sizeof(string_mysql),"SELECT * FROM pp_igroki WHERE user_id = '%d'", trailerInfo[id][tOwnerID]); // Грузим ID Аккаунта
    mysql_tquery(pearsq, string_mysql, "OnCreatePlayerTrailerPickup", "dfff", id, doorX, doorY, doorZ);

    // Сохранение позиции
    trailerInfo[id][tModel] = model;
    trailerInfo[id][tPos][0] = x, trailerInfo[id][tPos][1] = y, trailerInfo[id][tPos][2] = z;
    trailerInfo[id][tRot][0] = rx, trailerInfo[id][tRot][1] = ry, trailerInfo[id][tRot][2] = rz;
    trailerInfo[id][tPic][0] = doorX, trailerInfo[id][tPic][1] = doorY, trailerInfo[id][tPic][2] = doorZ;
    trailerInfo[id][tActive] = true;
    trailerInfo[id][tAttached] = 0;

    SavePlayerTrailerInfo(id);
}

// Выгружает установленный трейлер из игрового мира
stock UnloadPlacedTrailer(id)
{
    if (id < 0 || id > MAX_TRAILERS) return 0;
    if (!trailerInfo[id][tActive]) return 0;

    new objects[1];
    Streamer_GetNearbyItems(trailerInfo[id][tPos][0], trailerInfo[id][tPos][1], trailerInfo[id][tPos][2], STREAMER_TYPE_OBJECT, objects, .range = 0.05);
    
    new trailer_obj = objects[0];
    if (!IsValidDynamicObject(trailer_obj) || GetDynamicObjectModel(trailer_obj) != trailerInfo[id][tModel]) return 0;
    DestroyDynamicObject(trailer_obj);
    DestroyDynamic3DTextLabel(trailerInfo[id][t3DLabel]);
    DestroyDynamicPickup(trailerInfo[id][tEnterPickup]);

    trailerInfo[id][tActive] = false;
    SavePlayerTrailerInfo(id);

    return 1;
}

// Создает объект трейлера с указанной моделью, прикрепляя его к автомобилю, в котором находится игрок
// Возвращает ID транспорта, к которому прикреплен трейлер, а также ID трейлера и прикрепленного объекта
stock AttachTrailer(playerid, model, vehicleid, &trailerid, &trailerobj)
{
    // Создаем трейлер
    new Float: player_pos[4];
    GetVehiclePos(vehicleid, player_pos[0], player_pos[1], player_pos[2]);
    GetVehicleZAngle(vehicleid, player_pos[3]);

    new Float:vehicleX,Float:vehicleY,Float:vehicleA, Float: trailer_car_distance = 3.5; // Расстояние от автомобиля игрока до невидимого транспорта
    GetXYInFrontOfPoint(vehicleX, vehicleY, vehicleA - 180.0, trailer_car_distance);

    trailerid = PP_CreateVehicle(TRAILER_INVISIBLE_VEH_MODEL,player_pos[0], player_pos[1], player_pos[2] - 10.0, 0.0, 0, 0, 600, 0, -1, 2000.0);
    SetVehicleVirtualWorld(trailerid, TRAILER_INVISIBLE_VEH_INTERIOR);
    LinkVehicleToInterior(trailerid, TRAILER_INVISIBLE_VEH_INTERIOR);

    trailerobj = CreateDynamicObject(model, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);
    
    switch (model) {
        case 3171: AttachDynamicObjectToVehicle(trailerobj, trailerid, -0.069, -2.861, -1.000, 0.000, 0.000, 180.000);
        case 3172: AttachDynamicObjectToVehicle(trailerobj, trailerid, 0.172, -4.417, -1.000, 0.000, 0.000, -180.000);
        case 3174: AttachDynamicObjectToVehicle(trailerobj, trailerid, 0.070, -2.189, -1.000, 0.000, 0.000, 0.000);
        case 3168: AttachDynamicObjectToVehicle(trailerobj, trailerid, -0.122, -4.363, -1.000, 0.000, -0.099, 180.000);

        default: {
            DestroyDynamicObject(trailerobj);
            return false;
        }
    }

    SetVehicleVirtualWorld(trailerid, 0);

    // Закрепляем трейлер за автомобилем
    SetTimerEx("AttachTrailerToVehicleDelay", 950, false, "dd", trailerid, vehicleid);

    SuccessMessage(playerid, "{99ff66}Трейлер прикреплён к вашему автомобилю\n{cccccc}Установить - {ff9000}[ H / CAPS LOCK ]\n\n{cccccc}Управляйте транспортом с прицепом осторожно.\nСоблюдайте правила дорожного движения.");
    return true;
}

// Для отложенного вызова прикрепления прицепа
forward AttachTrailerToVehicleDelay(trailerid, vehicleid);
public AttachTrailerToVehicleDelay(trailerid, vehicleid) { AttachTrailerToVehicle(trailerid, vehicleid); }

// Проверяет на месте ли трейлер и выполняет необходимые действия, если тот отцепился
forward PlayerTrailerTimer(vehicleid, trailerid, tid);
public PlayerTrailerTimer(vehicleid, trailerid, tid) {
    // Если либо машина, к которой прикреплен трейлер, либо невидимая машина, на которой висит объект исчезли
    if (!IsValidVehicle(vehicleid) || !IsValidVehicle(trailerid)) {
        // На случай, если уничтожилась только машина водителя, уничтожаем и трейлер
        trailerInfo[tid][tVehicle] = 0;
        if (GetVehicleModel(trailerid) == TRAILER_INVISIBLE_VEH_MODEL) DestroyPlayerTrailer(tid);

        trailerInfo[tid][tAttached] = 0;
        KillTimer(trailerInfo[tid][tTimerID]);
        trailerInfo[tid][tTimerID] = 0;
        return 1;
    }
    
    static Float: safe_health = 1000.0;
    if (GetVehicleTrailer(vehicleid) < 1) { // Если трейлер отцепился
        // Резко останавливаем машину водителя и сам трейлер (чтобы ничего не летало)
        SetVehicleSpeed(trailerid, 0), SetVehicleSpeed(vehicleid, 0);

        // Узнаем координаты машины водителя и трейлера
        new Float: vehicle_pos[3], Float: trailer_pos[3];
        GetVehiclePos(vehicleid, vehicle_pos[0], vehicle_pos[1], vehicle_pos[2]);
        GetVehiclePos(trailerid, trailer_pos[0], trailer_pos[1], trailer_pos[2]);

        // Ставим трейлеру максимальное HP
        ACSetVehicleHealth(trailerid, 1000.0);
        
        // Если нет никаких препятствий для присоединения трейлера (высота, вода)
        new Float: depth, Float: vehicledepth;
        if (IsVehicleStandingGround(vehicleid) && !CA_IsVehicleInWater(vehicleid, depth, vehicledepth)) 
        {
            // Если машины не в зоне стрима - помещаем трейлер в нее
            if (GetDistanceBetweenCoords2d(trailer_pos[0], trailer_pos[1], vehicle_pos[0], vehicle_pos[1]) > STREAMER_OBJECT_SD) 
                SetVehiclePos(trailerid, vehicle_pos[0], vehicle_pos[1], vehicle_pos[2] - 10.0);

            AttachTrailerToVehicle(trailerid, vehicleid); // Присоединяем трейлер обратно
            ACSetVehicleHealth(vehicleid, safe_health); // Компенсируем возможный полученный дамаг
        }
    }
    else {
        // Запоминаем последнее количество HP до отсоединения прицепа, чтобы восстановить его, если он продамажит транспорт
        GetVehicleHealth(vehicleid, safe_health);
    }

    return 1;
}

// Получает ID трейлера в массиве trailerInfo
stock GetPlayerTrailerID(playerid) 
{
    return PlayerInfo[playerid][pTrailer] - 1;

    /*
    if(PlayerInfo[playerid][pTrailer] == 0) return -1;

    new tid = PlayerInfo[playerid][pTrailer] - 1;
    if(trailerInfo[tid][tOwnerID] == PlayerInfo[playerid][pID]) return tid;

    return -1;
    */
}

// Создает новый трейлер указанного типа и присваивает его указанному игроку
stock AddPlayerTrailer(playerid, model) 
{
    new tid = GetPlayerTrailerID(playerid);
    if (tid > -1)
    {
        new string[60];
        format(string,sizeof(string),"{ff6347}У вас уже есть трейлер [ № %d ]", trailerInfo[tid][tID]);
        ErrorMessage(playerid, string);
        return false;
    }

    new result;
    for (new id = 0; id < MAX_TRAILERS; id++) 
    {
        if (trailerInfo[id][tOwnerID] == 0)
        {
            trailerInfo[id][tID] = id;
            trailerInfo[id][tModel] = model;
            trailerInfo[id][tOwnerID] = PlayerInfo[playerid][pID];

            // Сохранение в базу данных
            new query_string[200];
            mysql_format(pearsq, query_string, sizeof(query_string), "INSERT INTO trailers (id, owner, model) VALUES (%d, %d, %d)", id, trailerInfo[id][tOwnerID], trailerInfo[id][tModel]);
            mysql_tquery(pearsq, query_string, "OnPlayerTrailerCreate", "d", id);

            // Сохраняем трейлер в аккаунт игроку
            PlayerInfo[playerid][pTrailer] = id + 1;
            UpdateTrailerPlayer(PlayerInfo[playerid][pTrailer], PlayerInfo[playerid][pID]);

            result = 1;
            break;
        }
    }

    return result;
}

stock UpdateTrailerPlayer(trailer, user_id)
{
    new string_mysql[100];
    format(string_mysql,sizeof(string_mysql),"UPDATE `pp_igroki` SET `pTrailer` = '%d' WHERE `user_id` = '%d'", trailer, user_id);
    query_empty(pearsq, string_mysql);
    return 1;
}

// Удаляет трейлер
stock DeleteTrailer(tid) {
    if (tid < 0 || tid > MAX_TRAILERS) return 0;

    ClearTrailerFromAccount(tid); // Удаляем трейлер с аккаунта игрока (если он вдруг онлайн)
    UnloadAttachedTrailer(tid); // На случай если трейлер прямо сейчас прикреплен к авто игрока - открепляем, удаляем
    UnloadPlacedTrailer(tid); // Выгружаем трейлер из игрового мира (если он создан)
    DeleteTrailerFromDB(tid); // Удаляем трейлер из базы
    return 1;
}

// Выгружает трейлер, прикрепленный к автомобилю
stock UnloadAttachedTrailer(tid)
{
    if(trailerInfo[tid][tTimerID] > 0) KillTimer(trailerInfo[tid][tTimerID]), trailerInfo[tid][tTimerID] = 0;

    DestroyPlayerTrailer(tid);
    return 1;
}

// Отображает меню взаимодействия со своим трейлером
stock ShowTrailerMenu(playerid) {
    new tid = GetPlayerTrailerID(playerid);
    if (tid < 0) return 0;

    static const fmt_str[] = COLOR_WHITE_TEXT"Отметить на карте\nДверь [ %s "COLOR_WHITE_TEXT"]\nРедактировать позицию";
    new str[sizeof fmt_str - 2 + 8 + 7 + 1 + 23];
    format(str, sizeof str, fmt_str,
        (trailerInfo[tid][tLocked] ? (COLOR_RED_TEXT"Закрыта") : (COLOR_GREEN_TEXT"Открыта"))
    );

    ShowDialog(playerid, 1390, DIALOG_STYLE_LIST, COLOR_BLUE_TEXT"Трейлер", str, "Ок", "Закрыть");

    return 1;
}

stock ClearTrailerFromAccount(tid)
{
    foreach (new id : Player) 
    {
        if (PlayerInfo[id][pID] == trailerInfo[tid][tOwnerID]) 
        {
            PlayerInfo[id][pTrailer] = 0;
            break;
        }
    }
    return 1;
}

// Отображает диалог покупки трейлера
stock TrailerBuy(playerid)
{
	new line[80],lines[400];
    format(line,sizeof(line),"{cccccc}Название \t{99ff66}Цена\n"), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Round Trailer\t{99ff66}200.000$\n"), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Mini Trailer\t{99ff66}250.000$\n"), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Middle Trailer\t{99ff66}300.000$\n"), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Big Trailer\t{99ff66}400.000$\n"), strcat(lines,line);
    format(line,sizeof(line),"{FF6347}Уничтожить Трейлер\n"), strcat(lines,line);
	ShowDialog(playerid,1395, DIALOG_STYLE_TABLIST_HEADERS, "{cccccc}Покупка Трейлера", lines,"Выбрать","Отмена");
	return 1;
}

stock key_TrailerAttach(playerid) // Нажатие на H / CAPS LOCK
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        // Трейлеры
        new tid = GetPlayerTrailerID(playerid);

        new vehicleid = GetPlayerVehicleID(playerid);
        if (!vehicleid) return 0;

        new trailerid = GetVehicleTrailer(vehicleid);
        if (trailerid < 1) // Нет трейлера
        {
            if(IsPlayerInRangeOfPoint(playerid, 8.0, -547.4172, -1018.2808, 24.1529)) // Крепим в трейлерном парке
            {
                if(PlayerInfo[playerid][pTrailer] == 0) return ErrorMessage(playerid, "{FF6347}У вас нет трейлера\n{cccccc}Вы можете приобрести его рядышком :)");
                PlayerPlaySound(playerid, 40405, 0, 0, 0);
                ShowDialog(playerid, 1337, DIALOG_STYLE_MSGBOX, "{ff9000}Трейлер", "{cccccc}Вы уверены, что хотите {99ff66}прикрепить трейлер {cccccc}к автомобилю?", "Да", "Нет");
            }
            else // Крепим рядом с трейлером (Поиск своего трейлера воткнуть сюда)
            {
                if (tid < 0) return 0;
                if (trailerInfo[tid][tActive])
                {
                    if(IsPlayerInRangeOfPoint(playerid, 15.0, trailerInfo[tid][tPic][0], trailerInfo[tid][tPic][1], trailerInfo[tid][tPic][2]))
                    {
                        PlayerPlaySound(playerid, 40405, 0, 0, 0);
                        ShowDialog(playerid, 1337, DIALOG_STYLE_MSGBOX, "{ff9000}Трейлер", "{cccccc}Вы уверены, что хотите {99ff66}прикрепить трейлер {cccccc}к автомобилю?", "Да", "Нет");
                    }
                }
            }
        }
        else // Есть трейлер
        {
            if (tid < 0) return 0;
            if (trailerInfo[tid][tAttached] != vehicleid) return 0;

            PlayerPlaySound(playerid, 40405, 0, 0, 0);
            ShowDialog(playerid, 1336, DIALOG_STYLE_MSGBOX, "{ff9000}Трейлер", "{cccccc}Вы уверены, что хотите {99ff66}установить трейлер {cccccc}в этой точке?", "Да", "Нет");
        }
    }
    return 1;
}

stock dialogCase_Trailer(playerid, dialogid, response)
{
	if(dialogid == 1336)
   	{
   	    if(response) cmd_placetrailer(playerid);
    }
    else if(dialogid == 1337)
   	{
   	    if(response) cmd_attachtrailer(playerid);
    }
    else if(dialogid == 1463)
    {
        if(response) CreateBreaking(playerid, 3, DP[0][playerid], 0);
    }
    return 1;
}

stock IsAHimLab(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 1.5, -3.280344, 1566.091430, 12.861586) &&
       GetPlayerInterior(playerid) == INT_TRAILER && GetPlayerVirtualWorld(playerid) >= MIN_TRAILER_WORLD && GetPlayerVirtualWorld(playerid) <= MAX_TRAILER_WORLD) return 1;
    return 0;
}

// Удаляем неустановленный трейлер
stock TrailerOnPlayerDisconnect(playerid) 
{
    // Узнаем, есть ли у игрока трейлер
    new tid = GetPlayerTrailerID(playerid);
    if (tid < 0) return 1;

    // Открепляем и выгружаем трейлер, если он был прикреплен к какому-либо автомобилю
    UnloadAttachedTrailer(tid);

    return 1;
}

// Удаляет невидимый автомобиль, к которому приаттачен объект трейлера + удаляет этот объект для избежания багов (когда создается авто с тем же ID и на нем оказывается аттач)
stock DestroyPlayerTrailer(tid) 
{
    new trailerid = trailerInfo[tid][tVehicle];
    if (trailerid > 0) 
    {
        if(trailerInfo[tid][tObject] > 0) DestroyDynamicObject(trailerInfo[tid][tObject]), trailerInfo[tid][tObject] = 0;
        ACDestroyVehicle(trailerid); // Удаляем сам невидимый прицеп
    }

    // Если известен id транспорта, к которому мы прикрепили трейлер
    if(trailerInfo[tid][tAttached] > 0)
    {
        new vehicleid = trailerInfo[tid][tAttached];
        VehInfo[vehicleid][vTrailerID] = 0; // Очищаем инфу о том, что к нашей машине привязан трейлер
    }
}

// Покупка трейлера
stock trailer_add(playerid, model, trailer) 
{
    if(PlayerInfo[playerid][pTrailer] > 0) return ErrorMessage(playerid, "{FF6347}У вас уже есть трейлер");
    new money;
    if(trailer == 0) money = 200000;
    else if(trailer == 1) money = 250000;
    else if(trailer == 2) money = 300000;
    else if(trailer == 3) money = 400000;
    if(oGetPlayerMoney(playerid) < money) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
    new infocreate = AddPlayerTrailer(playerid, model);
    if (infocreate == 0) 
    {
        new string[55];
        format(string,sizeof(string),"{FF6347}Трейлер не может быть создан [ Лимит: %d ]", MAX_TRAILERS);
        ErrorMessage(playerid, string);
    }
    else
    {
        oGivePlayerMoney(playerid,-money);
        SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Я Купил трейлер и могу забрать его в точке загрузки");
        SuccessMessage(playerid, "{99ff66}Вы купили трейлер\n{ffcc66}Заберите трейлер в точке загрузки\n{ffcc66}Для этого подъедьте на автомобиле и нажмите CAPS LOCK");
 	    CreateGps(playerid,-547.4172, -1018.2808, 24.1529, 0, 0, 10.0);
    }
    return 1;
}

// Команда для телепорта к трейлеру
CMD:trailer(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 3) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Телепорт к трейлеру [ /trailer Номер ]");
    if(params[0] < 1 || params[0] > MAX_TRAILERS) return ErrorMessage(playerid, "{FF6347}Не меньше 1 и не больше 5000");
    
    new trailerid = params[0] - 1;
    if(!trailerInfo[trailerid][tActive]) return ErrorMessage(playerid, "{FF6347}Трейлер не установлен");

    PPSetPlayerPos(playerid, trailerInfo[trailerid][tPic][0], trailerInfo[trailerid][tPic][1], trailerInfo[trailerid][tPic][2] + 0.5);
    S_SetPlayerVirtualWorld(playerid, 0, 0);
	SetPlayerInterior(playerid, 0);
	return 1;
}

// Команда для прикрепления трейлера к своему автомобилю
// Срабатывает только в том случае, если игрок находится в пригодном для этого месте, либо рядом с уже существующим трейлером
CMD:attachtrailer(playerid)
{
    new tid = GetPlayerTrailerID(playerid);
    if (tid < 0) return ErrorMessage(playerid, "{FF6347}У вас нет трейлера\n{cccccc}Вы можете приобрести его в Трейлерном Парке");

    new vehicleid = GetPlayerVehicleID(playerid);
    if (!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid, "{FF6347}Вы должны находиться за рулем транспортного средства, чтобы прицепить трейлер");

    new typeVehcile = GetVehicleType(VehInfo[vehicleid][vModel]);
    if(typeVehcile != 1) return ErrorMessage(playerid, "{FF6347}Вы можете прикрепить трейлер только к автомобилю");
    if(VehInfo[vehicleid][vEngine] == 1) return ErrorMessage(playerid, "{FF6347}Заглушите двигатель вашего транспорта");

    // Если трейлер уже размещен в игровом мире
    if (trailerInfo[tid][tActive]) 
    {
        new Float: player_pos[3]; GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
        if (GetDistanceBetweenCoords3d(player_pos[0], player_pos[1], player_pos[2], trailerInfo[tid][tPos][0], trailerInfo[tid][tPos][1], trailerInfo[tid][tPos][2]) < 15.0) {
            UnloadPlacedTrailer(tid);
        }
        else {
            return ErrorMessage(playerid, "{FF6347}Ваш трейлер уже установлен {cccccc}[ Y >> Жилье >> Трейлер >> Отметить на карте ]");
        }
    } 
    else 
    {
        if(!IsPlayerInRangeOfPoint(playerid, 8.0, -547.4172, -1018.2808, 24.1529)) return ErrorMessage(playerid, "{FF6347}Прикрепить трейлер можно только в трейлерном парке\n{cccccc}[ Y >> GPS >> Недвижимость >> Трейлерный Парк ]");
    }

    // Выгружаем трейлер, если он уже был прицеплен
    UnloadAttachedTrailer(tid);

    // Создаем трейлер, цепляя его к автомобилю
    new trailerid, trailerobj;
    if (!AttachTrailer(playerid, trailerInfo[tid][tModel], vehicleid, trailerid, trailerobj)) return 0;

    trailerInfo[tid][tAttached] = vehicleid;
    trailerInfo[tid][tObject] = trailerobj;
    trailerInfo[tid][tVehicle] = trailerid;
    VehInfo[vehicleid][vTrailerID] = tid + 1;
    trailerInfo[tid][tTimerID] = SetTimerEx("PlayerTrailerTimer", 1000, true, "ddd", vehicleid, trailerid, tid);
    return 1;
}
//alias:attachtrailer("trailer_attach")

// Команда для размещения в игровом мире прицепленного трейлера
CMD:placetrailer(playerid) {
    // Если игрок водитель транспорта, к которому прикреплен трейлер
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!vehicleid) return 0;
    new tid = VehInfo[vehicleid][vTrailerID] - 1;
    if (tid < 0) return 0;
    
    if (trailerInfo[tid][tAttached] == vehicleid && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
        new trailerid = trailerInfo[tid][tVehicle];
        if (trailerid < 1) return 0;

        if(IsPlayerInRangeOfPoint(playerid, 50.0, -547.4172, -1018.2808, 24.1529)) return ErrorMessage(playerid, "{FF6347}Нельзя установить трейлер на территории трейлерного парка");
        if(IsANotMoney(playerid)) return ErrorMessage(playerid, "{FF6347}Трейлеры запрещено устанавливать на территории городов");
        if(VehInfo[vehicleid][vEngine] == 1) return ErrorMessage(playerid, "{FF6347}Заглушите двигатель транспорта");

        // Уничтожаем таймер, возвращающий прицеп
        if(trailerInfo[tid][tTimerID] > 0) KillTimer(trailerInfo[tid][tTimerID]), trailerInfo[tid][tTimerID] = 0;

        // Размещаем объект трейлера в игровом мире
        new Float: trailerX, Float: trailerY, Float: trailerZ, Float: trailerRX, Float: trailerRY, Float: trailerRZ;
        GetVehiclePos(trailerid, trailerX, trailerY, trailerZ);
        GetVehicleRotation(vehicleid, trailerRX, trailerRY, trailerRZ);
        GetXYInFrontOfPoint(trailerX, trailerY, trailerRZ - 180.0, 3.0);

        switch (trailerInfo[tid][tModel]) {
            case 3171: PlaceTrailer(tid, trailerInfo[tid][tModel], trailerX, trailerY, trailerZ - 1.000, trailerRX, trailerRY, trailerRZ + 180.0);
            case 3172: PlaceTrailer(tid, trailerInfo[tid][tModel], trailerX, trailerY, trailerZ - 1.000, trailerRX, trailerRY, trailerRZ - 180.0);
            case 3174: PlaceTrailer(tid, trailerInfo[tid][tModel], trailerX, trailerY, trailerZ - 1.000, trailerRX, trailerRY, trailerRZ);
            case 3168: PlaceTrailer(tid, trailerInfo[tid][tModel], trailerX, trailerY, trailerZ - 1.000, trailerRX, trailerRY - 0.099, trailerRZ + 180.0);
        }

        VehInfo[vehicleid][vTrailerID] = 0;

        // Уничтожаем невидимый автомобиль, к которому прикреплен объект трейлера
        ACDestroyVehicle(trailerid);

        SavePlayerTrailerInfo(tid);

        SuccessMessage(playerid, "{99ff66}Трейлер установлен!\n{cccccc}Теперь он будет находиться здесь.");
    }

    return 1;
}
//alias:placetrailer("trailer_place")

// Команда для удаления трейлера по ID
CMD:deletetrailer(playerid, const params[]) {
    if(PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}Команда недоступна");
    new trailerid;
    if (sscanf(params, "d", trailerid)) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Удалить трейлер игрока [ /deletetrailer ID трейлера ]");
    if (DeleteTrailer(trailerid)) SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Я удалил трейлер № %d", trailerid);
    else SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Указанного трейлера не существует");
    return 1;
}
//alias:deletetrailer("dtrailer", "deltrailer")

// Выгружает созданный в игровом мире трейлер
CMD:unloadtrailer(playerid, const params[]) {
    if(PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}Команда недоступна");
    new tid;
    if (sscanf(params, "d", tid)) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Выгрузить трейлер [ /unloadtrailer TrailerID ]");
    if (tid < 0 || tid > MAX_TRAILERS) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Указан некорректный номер трейлера");
    if (!trailerInfo[tid][tActive]) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Этот трейлер не находится в игровом мире");
    UnloadPlacedTrailer(tid);
    new stirng[80];
    format(stirng,sizeof(stirng),"[ Мысли ]: Я выгрузил трейлер [ № %d ] из игрового мира", tid);
    SendClientMessage(playerid, COLOR_GRAY, stirng);
    return 1;
}
//alias:unloadtrailer("trailer_unload")

// Открывает меню управления
CMD:trailermenu(playerid) {
    if (!ShowTrailerMenu(playerid)) return  ErrorMessage(playerid, "{FF6347}У вас нет трейлера\n{cccccc}Вы можете приобрести его в Трейлерном Парке");
    return 1;
}
//alias:trailermenu("trailer_menu")

stock exittrailer(playerid)
{   
    new tid = GetPlayerVirtualWorld(playerid) - MIN_TRAILER_WORLD;
    if(Sleep[playerid] >= 1 || SleepRP[playerid] >= 1) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я сплю");
    keep(playerid);
    S_SetPlayerVirtualWorld(playerid, 0, 0);
    SetPlayerInterior(playerid, 0);
    PPSetPlayerPos(playerid, trailerInfo[tid][tPic][0], trailerInfo[tid][tPic][1], trailerInfo[tid][tPic][2] + 0.5);
    return 1;
}

// MYSQL
forward UploadTrailers();
public UploadTrailers()
{
    new time = GetTickCount();
	for (new i = 0; i < cache_num_rows(); i++) 
    {
        new t;
		cache_get_value_name_int(i, "id", t);
        trailerInfo[t][tID] = t;
        cache_get_value_name_int(i, "newid", trailerInfo[t][tNewid]);
		cache_get_value_name_int(i, "owner", trailerInfo[t][tOwnerID]);
		cache_get_value_name_int(i, "model", trailerInfo[t][tModel]);
		cache_get_value_name_float(i, "pos_x", trailerInfo[t][tPos][0]);
		cache_get_value_name_float(i, "pos_y", trailerInfo[t][tPos][1]);
		cache_get_value_name_float(i, "pos_z", trailerInfo[t][tPos][2]);
		cache_get_value_name_float(i, "rot_x", trailerInfo[t][tRot][0]);
		cache_get_value_name_float(i, "rot_y", trailerInfo[t][tRot][1]);
		cache_get_value_name_float(i, "rot_z", trailerInfo[t][tRot][2]);
        cache_get_value_name_float(i, "pic_x", trailerInfo[t][tPic][0]);
		cache_get_value_name_float(i, "pic_y", trailerInfo[t][tPic][1]);
		cache_get_value_name_float(i, "pic_z", trailerInfo[t][tPic][2]);
		cache_get_value_name_bool(i, "active", trailerInfo[t][tActive]);
		cache_get_value_name_bool(i, "locked", trailerInfo[t][tLocked]);
		if (trailerInfo[t][tActive]) PlaceTrailer(t, trailerInfo[t][tModel], trailerInfo[t][tPos][0], trailerInfo[t][tPos][1], trailerInfo[t][tPos][2], trailerInfo[t][tRot][0], trailerInfo[t][tRot][1], trailerInfo[t][tRot][2]);
	}
    printf("[MODE]: Трейлеры [%d ms]",GetTickCount() - time);
	return 1;
}

stock infotrailer(playerid, t)
{
    if(trailerInfo[t][tOwnerID] == 0) return ErrorMessage(playerid, "{FF6347}У трейлера нет владельца\n{cccccc}Трейлер не был создан");
	new str[100],sctring[700];
 	format(str,sizeof(str),"{0088ff}№ %d",t + 1), strcat(sctring,str);
   	format(str,sizeof(str),"\n{cccccc}Владелец: {ff9000}№ %d", trailerInfo[t][tOwnerID]), strcat(sctring,str);
   	format(str,sizeof(str),"\nModel: {ffffff}%d", trailerInfo[t][tModel]), strcat(sctring,str);
    if (trailerInfo[t][tActive]) format(str,sizeof(str),"\nСтатус: {99ff66}Установлен"), strcat(sctring,str);
    else format(str,sizeof(str),"\nСтатус: {FF6347}Не установлен"), strcat(sctring,str);
	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ff9000}Трейлер",sctring,"*","");
	return 1;
}

forward OnCreatePlayerTrailerPickup(id, Float: x, Float: y, Float: z);
public OnCreatePlayerTrailerPickup(id, Float: x, Float: y, Float: z) {
	new owner_name[MAX_PLAYER_NAME + 1], number = id+1;
	cache_get_value_name(0, "Name", owner_name);
    new string[100];
    if(trailerInfo[id][tEnterPickup] != 0)
    {
        DestroyDynamic3DTextLabel(trailerInfo[id][t3DLabel]);
        DestroyDynamicPickup(trailerInfo[id][tEnterPickup]);
    }
    format(string,sizeof(string),"{cccccc}Трейлер "COLOR_ORANGE_TEXT"№ %d\n"COLOR_WHITE_TEXT"Владелец: "COLOR_ORANGE_TEXT"%s", number, owner_name);
    trailerInfo[id][t3DLabel] = CreateDynamic3DTextLabel(string, 0xA9C4E4FF, x, y, z, 12.5, .testlos = 1, .worldid = 0, .interiorid = 0);
    trailerInfo[id][tEnterPickup] = CreateDynamicPickup(1272, STREAMER_TYPE_PICKUP, x, y, z, 0, 0, .streamdistance = 100.0);
	Streamer_SetIntData(STREAMER_TYPE_PICKUP, trailerInfo[id][tEnterPickup], STREAMER_EXTRA_TYPE_TRAILER_ENTER, id + 1);
	return 1;
}

stock SavePlayerTrailerInfo(id) {
    if (id < 0 || id > MAX_TRAILERS) return 0;

    new string_mysql[500];
    format(string_mysql, sizeof(string_mysql), "UPDATE trailers SET owner = %d, pos_x = %.4f, pos_y = %.4f, pos_z = %.4f, pic_x = %.4f, pic_y = %.4f, pic_z = %.4f, rot_x = %.4f, rot_y = %.4f, rot_z = %.4f, active = %d, locked = %d WHERE id = %d",
	    trailerInfo[id][tOwnerID],
        trailerInfo[id][tPos][0], trailerInfo[id][tPos][1], trailerInfo[id][tPos][2],
        trailerInfo[id][tPic][0], trailerInfo[id][tPic][1], trailerInfo[id][tPic][2],
        trailerInfo[id][tRot][0], trailerInfo[id][tRot][1], trailerInfo[id][tRot][2],
        trailerInfo[id][tActive],
        trailerInfo[id][tLocked],
        trailerInfo[id][tID]); // 197 + 44 + 180
	query_empty(pearsq, string_mysql);
    return 1;
}

// При создании нового трейлера в базе данных
function OnPlayerTrailerCreate(id) {
    trailerInfo[id][tNewid] = cache_insert_id();
    return 1;
}

stock DeleteTrailerFromDB(tid)
{
    // Вносим изменения в базу данных
    static const query_fmt_str[] = "DELETE FROM trailers WHERE id = %d";
    new query_string[sizeof query_fmt_str - 2 + 5 + 1];
    mysql_format(pearsq, query_string, sizeof query_string, query_fmt_str, trailerInfo[tid][tID]);
    mysql_tquery(pearsq, query_string);

    // Сохраняем трейлер в аккаунт игроку
    UpdateTrailerPlayer(0, trailerInfo[tid][tOwnerID]);

    // Очищаем информацию о трейлере
    for(new e_TrailerInfo:i; i < e_TrailerInfo; ++i) trailerInfo[tid][i] = 0;
    return 1;
}
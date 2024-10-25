
#define STREAMER_EXTRA_TYPE_TRAILER_ENTER	E_STREAMER_CUSTOM(3)
#define MAX_TRAILERS 1000 // Максимальное количество трейлеров

// Минимальный и максимальный виртуальный мир для трейлеров
#define MIN_TRAILER_WORLD 5000
#define MAX_TRAILER_WORLD 5999

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
new TrailerInfo[MAX_TRAILERS][e_TrailerInfo];
new Float: TrailerSafeHealth[MAX_VEHICLES];

const TRAILER_INVISIBLE_VEH_MODEL = 606; // ID невидимого транспорта для прикрепления объекта трейлера
const TRAILER_INVISIBLE_VEH_INTERIOR = 101; // Интерьер невидимого транспорта для трейлера

// Создает трейлер в игровом мире
stock PlaceTrailer(id, model, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz)
{
    if (id < 0 || id > MAX_TRAILERS) return;
    if (TrailerInfo[id][tOwnerID] <= 0) return;

    // Установка трейлера
    UnloadPlacedTrailer(id);
    if (TrailerInfo[id][tObject] > 0) {
        Streamer_SetIntData(STREAMER_TYPE_OBJECT, TrailerInfo[id][tObject], E_STREAMER_ATTACHED_VEHICLE, INVALID_VEHICLE_ID);
        SetDynamicObjectPos(TrailerInfo[id][tObject], x, y, z);
        SetDynamicObjectRot(TrailerInfo[id][tObject], rx, ry, rz);
    } else TrailerInfo[id][tObject] = CreateDynamicObject(TrailerInfo[id][tModel], x, y, z, rx, ry, rz, 0, 0);
    // Размещение входа    
    new Float: doorX, Float: doorY, Float: doorZ;
    switch (model) {
        case 3171: GetRelativePos(x, y, z, rx, ry, rz, (1347.1438 - 1348.899902), (1594.2501 - 1594.863769), (10.8203 - 9.820312), doorX, doorY, doorZ);
        case 3172: GetRelativePos(x, y, z, rx, ry, rz, (1350.9469 - 1352.759643), (1573.7472 - 1574.919677), (11.0155 - 9.820312), doorX, doorY, doorZ);
        case 3174: GetRelativePos(x, y, z, rx, ry, rz, (1360.8247 - 1362.623901), (1592.9111 - 1593.942260), (10.8203 - 9.820312), doorX, doorY, doorZ);
        case 3168: GetRelativePos(x, y, z, rx, ry, rz, (1369.5554 - 1371.515380), (1576.9391 - 1577.505981), (10.8125 - 9.820312), doorX, doorY, doorZ);
    }

    new string_mysql[100];
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"SELECT Name FROM pp_igroki WHERE user_id = '%d'", TrailerInfo[id][tOwnerID]); // Грузим ID Аккаунта
    mysql_tquery(pearsq, string_mysql, "OnCreatePlayerTrailerPickup", "dfff", id, doorX, doorY, doorZ);

    // Сохранение позиции
    TrailerInfo[id][tModel] = model;
    TrailerInfo[id][tPos][0] = x, TrailerInfo[id][tPos][1] = y, TrailerInfo[id][tPos][2] = z;
    TrailerInfo[id][tRot][0] = rx, TrailerInfo[id][tRot][1] = ry, TrailerInfo[id][tRot][2] = rz;
    TrailerInfo[id][tPic][0] = doorX, TrailerInfo[id][tPic][1] = doorY, TrailerInfo[id][tPic][2] = doorZ;
    TrailerInfo[id][tActive] = true;
    TrailerInfo[id][tAttached] = 0;

    SavePlayerTrailerInfo(id);
}

// Выгружает установленный трейлер из игрового мира
stock UnloadPlacedTrailer(id)
{
    if (id < 0 || id > MAX_TRAILERS) return 0;
    if (!TrailerInfo[id][tActive]) return 0;
    
    if(TrailerInfo[id][tObject] > 0)
    {
        DestroyDynamicObject(TrailerInfo[id][tObject]);
        TrailerInfo[id][tObject] = 0;
    }
    if(TrailerInfo[id][tEnterPickup] != 0)
    {
        DestroyDynamic3DTextLabel(TrailerInfo[id][t3DLabel]);
        DestroyDynamicPickup(TrailerInfo[id][tEnterPickup]);
        TrailerInfo[id][tEnterPickup] = 0;
    }

    TrailerInfo[id][tActive] = false;
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
    if (!IsValidVehicle(vehicleid) || !IsValidVehicle(trailerid)) 
    {
        // Выгружаем из мира эту херабору
        UnloadAttachedTrailer(tid);
        return 1;
    }
    
    if (GetVehicleTrailer(vehicleid) < 1) { // Если трейлер отцепился
        // Резко останавливаем машину водителя и сам трейлер (чтобы ничего не летало)
        SetVehicleSpeed(trailerid, 0), SetVehicleSpeed(vehicleid, 0);

        // Узнаем координаты машины водителя и трейлера
        new Float: vehicle_pos[3], Float: trailer_pos[3];
        GetVehiclePos(vehicleid, vehicle_pos[0], vehicle_pos[1], vehicle_pos[2]);
        GetVehiclePos(trailerid, trailer_pos[0], trailer_pos[1], trailer_pos[2]);

        // Ставим трейлеру максимальное HP
        ACSetVehicleHealth(trailerid, 10000.0);
        
        // Если нет никаких препятствий для присоединения трейлера (высота, вода)
        new Float: depth, Float: vehicledepth;
        if (IsVehicleStandingGround(vehicleid) && !CA_IsVehicleInWater(vehicleid, depth, vehicledepth)) 
        {
            // Ставим трейлер под наш транспорт, чтобы попытаться избежать ошибку Loading Screen
            ACSetVehiclePos(trailerid, vehicle_pos[0], vehicle_pos[1], vehicle_pos[2] - 8.0);

            AttachTrailerToVehicle(trailerid, vehicleid); // Присоединяем трейлер обратно
            ACSetVehicleHealth(vehicleid, TrailerSafeHealth[vehicleid]); // Компенсируем возможный полученный дамаг
        }
    }
    else {
        // Запоминаем последнее количество HP до отсоединения прицепа, чтобы восстановить его, если он продамажит транспорт
        GetVehicleHealth(vehicleid, TrailerSafeHealth[vehicleid]);
    }

    return 1;
}

// Получает ID трейлера в массиве TrailerInfo
stock GetPlayerTrailerID(playerid) 
{
    return PlayerInfo[playerid][pTrailer] - 1;
}

// Создает новый трейлер указанного типа и присваивает его указанному игроку
stock AddPlayerTrailer(playerid, model) 
{
    new tid = GetPlayerTrailerID(playerid);
    if (tid > -1)
    {
        new string[60];
        format(string,sizeof(string),"{ff6347}У вас уже есть трейлер [ № %d ]", TrailerInfo[tid][tID]);
        ErrorMessage(playerid, string);
        return false;
    }

    new result;
    for (new id = 0; id < MAX_TRAILERS; id++) 
    {
        if (TrailerInfo[id][tOwnerID] == 0)
        {
            TrailerInfo[id][tID] = id;
            TrailerInfo[id][tModel] = model;
            TrailerInfo[id][tOwnerID] = PlayerInfo[playerid][pID];

            // Сохранение в базу данных
            new query_string[200];
            mysql_format(pearsq, query_string, sizeof(query_string), "INSERT INTO trailers (id, owner, model) VALUES (%d, %d, %d)", id, TrailerInfo[id][tOwnerID], TrailerInfo[id][tModel]);
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
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_igroki` SET `pTrailer` = '%d' WHERE `user_id` = '%d'", trailer, user_id);
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
    if(TrailerInfo[tid][tTimerID] > 0) KillTimer(TrailerInfo[tid][tTimerID]), TrailerInfo[tid][tTimerID] = 0;

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
        (TrailerInfo[tid][tLocked] ? (COLOR_RED_TEXT"Закрыта") : (COLOR_GREEN_TEXT"Открыта"))
    );

    ShowDialog(playerid, 1390, DIALOG_STYLE_LIST, COLOR_BLUE_TEXT"Трейлер", str, "Ок", "Закрыть");

    return 1;
}

stock ClearTrailerFromAccount(tid)
{
    foreach (new id : Player) 
    {
        if (PlayerInfo[id][pID] == TrailerInfo[tid][tOwnerID]) 
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
    format(line,sizeof(line),"{cccccc}Round Trailer\t{99ff66}600.000$\n"), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Mini Trailer\t{99ff66}750.000$\n"), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Middle Trailer\t{99ff66}900.000$\n"), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Big Trailer\t{99ff66}1.200.000$\n"), strcat(lines,line);
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
                if (TrailerInfo[tid][tActive])
                {
                    if(IsPlayerInRangeOfPoint(playerid, 15.0, TrailerInfo[tid][tPic][0], TrailerInfo[tid][tPic][1], TrailerInfo[tid][tPic][2]))
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
            if (TrailerInfo[tid][tAttached] != vehicleid) return 0;

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
   	    if(response) pc_cmd_placetrailer(playerid);
    }
    else if(dialogid == 1337)
   	{
   	    if(response) pc_cmd_attachtrailer(playerid);
    }
    else if(dialogid == 1463)
    {
        if(response) CreateBreaking(playerid, BREAKING_TYPE_TRAILER, DP[0][playerid], 0);
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
    new trailerid = TrailerInfo[tid][tVehicle];
    if (trailerid > 0) 
    {
        if(TrailerInfo[tid][tObject] > 0) DestroyDynamicObject(TrailerInfo[tid][tObject]), TrailerInfo[tid][tObject] = 0;
        if(IsValidVehicle(trailerid)) ACDestroyVehicle(trailerid); // Удаляем сам невидимый прицеп
        TrailerInfo[tid][tVehicle] = 0;
    }

    // Если известен id транспорта, к которому мы прикрепили трейлер
    if(TrailerInfo[tid][tAttached] > 0)
    {
        new vehicleid = TrailerInfo[tid][tAttached];
        VehInfo[vehicleid][vTrailerID] = 0; // Очищаем инфу о том, что к нашей машине привязан трейлер
    }
}

// Покупка трейлера
stock trailer_add(playerid, model, trailer) 
{
    if(PlayerInfo[playerid][pTrailer] > 0) return ErrorMessage(playerid, "{FF6347}У вас уже есть трейлер");
    new money;
    if(trailer == 0) money = 600000;
    else if(trailer == 1) money = 750000;
    else if(trailer == 2) money = 900000;
    else if(trailer == 3) money = 1200000;

    if(oGetPlayerMoney(playerid) < money) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
    new infocreate = AddPlayerTrailer(playerid, model);

    new string[80];
    if (infocreate == 0) 
    {
        format(string,sizeof(string),"{FF6347}Трейлер не может быть создан [ Лимит: %d ]", MAX_TRAILERS);
        ErrorMessage(playerid, string);
    }
    else
    {
        oGivePlayerMoney(playerid,-money);
        SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Я Купил трейлер и могу забрать его в точке загрузки");
        SuccessMessage(playerid, "{99ff66}Вы купили трейлер\n{ffcc66}Заберите трейлер в точке загрузки\n{ffcc66}Для этого подъедьте на автомобиле и нажмите CAPS LOCK");
 	    CreateGps(playerid,-547.4172, -1018.2808, 24.1529, 0, 0, 10.0);

        HouseLog(2, "buytrailer", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[playerid][pTrailer], 0, "");

        format(string, sizeof(string), "Купил трейлер № %d", PlayerInfo[playerid][pTrailer]);
    	MoneyLog("buytrailer", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -money, string);
    }
    return 1;
}

// Команда для установки трейлера игроку
CMD:settrailer(playerid, const params[]) {
    if (PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
    new targetid, trailerid;
    if (sscanf(params, "ud", targetid, trailerid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Установить трейлер игроку [ /settrailer ID Номер ]");
    if (!IsOnline(targetid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Его вообще нет..");
    if (trailerid < 0 || trailerid > MAX_TRAILERS) return ErrorMessage(playerid, "{FF6347}Не меньше 0 и не больше "#MAX_TRAILERS);

    PlayerInfo[targetid][pTrailer] = trailerid;
	SendClientMessage(playerid, COLOR_GREY, "{FFFFFF}Игроку %s установлен номер трейлера {0088ff}%d", playername(targetid), trailerid);
	SendClientMessage(targetid, COLOR_GREY, "{FFFFFF}Администрация установила вам номер трейлера %d", trailerid);

    return 1;
}

// Команда для изменения положения трейлера
alias:trailerpos("settrailerpos")
CMD:trailerpos(playerid, const params[]) {
    if (PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
    new trailerid;
    if (sscanf(params, "d", trailerid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить позицию трейлера [ /trailerpos Номер ]");
    if (trailerid < 1 || trailerid > MAX_TRAILERS) return ErrorMessage(playerid, "{FF6347}Не меньше 1 и не больше 5000");
    
    trailerid--; // Корректировка для обращения к массиву

    if (!TrailerInfo[trailerid][tActive]) return ErrorMessage(playerid, "{ff6347}Трейлер не установлен чтобы его редактировать");
    if(!IsPlayerInRangeOfPoint(playerid, 10.0, TrailerInfo[trailerid][tPos][0], TrailerInfo[trailerid][tPos][1], TrailerInfo[trailerid][tPos][2])) return ErrorMessage(playerid, "{ff6347}Трейлер далеко от вас, подойдите ближе чтобы его редактировать");
    GoEditDynamicObject(playerid, REDAKT_TYPE_ADM_TRAILER, 1, trailerid, 0, TrailerInfo[trailerid][tObject], 0);

    return 1;
}

// Команда для телепорта к трейлеру
CMD:trailer(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 3) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Телепорт к трейлеру [ /trailer Номер ]");
    if(params[0] < 1 || params[0] > MAX_TRAILERS) return ErrorMessage(playerid, "{FF6347}Не меньше 1 и не больше 5000");
    
    new trailerid = params[0] - 1;
    if(!TrailerInfo[trailerid][tActive]) return ErrorMessage(playerid, "{FF6347}Трейлер не установлен");

    S_SetPlayerVirtualWorld(playerid, 0, 0);
	PPSetPlayerInterior(playerid, 0);
    PPSetPlayerPos(playerid, TrailerInfo[trailerid][tPic][0], TrailerInfo[trailerid][tPic][1], TrailerInfo[trailerid][tPic][2] + 0.5);
    PPSetPlayerFacingAngle(playerid, 0.0);
    
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
    if (TrailerInfo[tid][tActive]) 
    {
        new Float: player_pos[3]; GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
        if (GetDistanceBetweenCoords3d(player_pos[0], player_pos[1], player_pos[2], TrailerInfo[tid][tPos][0], TrailerInfo[tid][tPos][1], TrailerInfo[tid][tPos][2]) < 15.0) {
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
    if (!AttachTrailer(playerid, TrailerInfo[tid][tModel], vehicleid, trailerid, trailerobj)) return 0;

    TrailerInfo[tid][tAttached] = vehicleid;
    TrailerInfo[tid][tObject] = trailerobj;
    TrailerInfo[tid][tVehicle] = trailerid;
    VehInfo[vehicleid][vTrailerID] = tid + 1;
    TrailerSafeHealth[vehicleid] = MaxVehicleHealth(VehInfo[vehicleid][vModel], vehicleid);
    TrailerInfo[tid][tTimerID] = SetTimerEx("PlayerTrailerTimer", 1000, true, "ddd", vehicleid, trailerid, tid);
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
    
    if (TrailerInfo[tid][tAttached] == vehicleid && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
        new trailerid = TrailerInfo[tid][tVehicle];
        if (trailerid < 1) return 0;

        if(IsPlayerInRangeOfPoint(playerid, 50.0, -547.4172, -1018.2808, 24.1529)) return ErrorMessage(playerid, "{FF6347}Нельзя установить трейлер на территории трейлерного парка");
        if(IsANotMoney(playerid)) return ErrorMessage(playerid, "{FF6347}Трейлеры запрещено устанавливать на территории городов");
        if(IsPlayerInCube(playerid, -1344.426147, 2450.162109, 86.028869, -1263.789428, 2566.796142, 107.494987)) { // Гробница фараона
            return ErrorMessage(playerid, "{FF6347}Нельзя установить трейлер в этом месте");
        }
        if(VehInfo[vehicleid][vEngine] == 1) return ErrorMessage(playerid, "{FF6347}Заглушите двигатель транспорта");
        if(GetVehicleSpeed(playerid) > 3) return ErrorMessage(playerid, "{FF6347}Остановите транспорт\n{cccccc}Установить трейлер во время движения невозможно");

        // Уничтожаем таймер, возвращающий прицеп
        if(TrailerInfo[tid][tTimerID] > 0) KillTimer(TrailerInfo[tid][tTimerID]), TrailerInfo[tid][tTimerID] = 0;

        // Размещаем объект трейлера в игровом мире
        new Float: trailerX, Float: trailerY, Float: trailerZ, Float: trailerRX, Float: trailerRY, Float: trailerRZ;
        GetVehiclePos(trailerid, trailerX, trailerY, trailerZ);
        GetVehicleRotation(vehicleid, trailerRX, trailerRY, trailerRZ);
        GetXYInFrontOfPoint(trailerX, trailerY, trailerRZ - 180.0, 3.0);

        switch (TrailerInfo[tid][tModel]) {
            case 3171: PlaceTrailer(tid, TrailerInfo[tid][tModel], trailerX, trailerY, trailerZ - 1.000, trailerRX, trailerRY, trailerRZ + 180.0);
            case 3172: PlaceTrailer(tid, TrailerInfo[tid][tModel], trailerX, trailerY, trailerZ - 1.000, trailerRX, trailerRY, trailerRZ - 180.0);
            case 3174: PlaceTrailer(tid, TrailerInfo[tid][tModel], trailerX, trailerY, trailerZ - 1.000, trailerRX, trailerRY, trailerRZ);
            case 3168: PlaceTrailer(tid, TrailerInfo[tid][tModel], trailerX, trailerY, trailerZ - 1.000, trailerRX, trailerRY - 0.099, trailerRZ + 180.0);
        }

        VehInfo[vehicleid][vTrailerID] = 0;

        // Уничтожаем невидимый автомобиль, к которому прикреплен объект трейлера
        if(IsValidVehicle(trailerid)) ACDestroyVehicle(trailerid);
        TrailerInfo[tid][tVehicle] = 0;

        SavePlayerTrailerInfo(tid);

        SuccessMessage(playerid, "{99ff66}Трейлер установлен!\n{cccccc}Теперь он будет находиться здесь.");
    }

    return 1;
}
//alias:placetrailer("trailer_place")

// Команда для удаления трейлера по ID

alias:deletetrailer("dtrailer", "deltrailer")
CMD:deletetrailer(playerid, const params[]) {
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Команда недоступна");
    new trailerid;
    if (sscanf(params, "d", trailerid)) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Удалить трейлер игрока [ /deletetrailer ID трейлера ]");
    if(trailerid <= 0 || trailerid > MAX_TRAILERS) return ErrorMessage(playerid, "{FF6347}Номер трейлера не меньше 1 и не больше 1000");
    new trid = trailerid - 1;
    if(TrailerInfo[trid][tOwnerID] == 0) return ErrorMessage(playerid, "{FF6347}Этот трейлер не создан");
    if (DeleteTrailer(trid)) SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Я удалил трейлер № %d", trailerid);
    else SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Указанного трейлера не существует");
    return 1;
}

// Выгружает созданный в игровом мире трейлер
CMD:unloadtrailer(playerid, const params[]) {
    if(PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}Команда недоступна");
    new tid;
    if (sscanf(params, "d", tid)) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Выгрузить трейлер [ /unloadtrailer TrailerID ]");
    if (tid < 0 || tid > MAX_TRAILERS) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Указан некорректный номер трейлера");
    if (!TrailerInfo[tid][tActive]) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Этот трейлер не находится в игровом мире");
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
    PPSetPlayerInterior(playerid, 0);
    PPSetPlayerPos(playerid, TrailerInfo[tid][tPic][0], TrailerInfo[tid][tPic][1], TrailerInfo[tid][tPic][2] + 0.5);
    PPSetPlayerFacingAngle(playerid, 0.0);
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
        TrailerInfo[t][tID] = t;
        cache_get_value_name_int(i, "newid", TrailerInfo[t][tNewid]);
		cache_get_value_name_int(i, "owner", TrailerInfo[t][tOwnerID]);
		cache_get_value_name_int(i, "model", TrailerInfo[t][tModel]);
		cache_get_value_name_float(i, "pos_x", TrailerInfo[t][tPos][0]);
		cache_get_value_name_float(i, "pos_y", TrailerInfo[t][tPos][1]);
		cache_get_value_name_float(i, "pos_z", TrailerInfo[t][tPos][2]);
		cache_get_value_name_float(i, "rot_x", TrailerInfo[t][tRot][0]);
		cache_get_value_name_float(i, "rot_y", TrailerInfo[t][tRot][1]);
		cache_get_value_name_float(i, "rot_z", TrailerInfo[t][tRot][2]);
        cache_get_value_name_float(i, "pic_x", TrailerInfo[t][tPic][0]);
		cache_get_value_name_float(i, "pic_y", TrailerInfo[t][tPic][1]);
		cache_get_value_name_float(i, "pic_z", TrailerInfo[t][tPic][2]);
		cache_get_value_name_bool(i, "active", TrailerInfo[t][tActive]);
		cache_get_value_name_bool(i, "locked", TrailerInfo[t][tLocked]);
		if (TrailerInfo[t][tActive]) PlaceTrailer(t, TrailerInfo[t][tModel], TrailerInfo[t][tPos][0], TrailerInfo[t][tPos][1], TrailerInfo[t][tPos][2], TrailerInfo[t][tRot][0], TrailerInfo[t][tRot][1], TrailerInfo[t][tRot][2]);
	}
    printf("[MODE]: Трейлеры [%d ms]",GetTickCount() - time);
	return 1;
}

stock infotrailer(playerid, t)
{
    if(TrailerInfo[t][tOwnerID] == 0) return ErrorMessage(playerid, "{FF6347}У трейлера нет владельца\n{cccccc}Трейлер не был создан");
	new str[100],sctring[700];
 	format(str,sizeof(str),"{0088ff}№ %d",t + 1), strcat(sctring,str);
   	format(str,sizeof(str),"\n{cccccc}Владелец: {ff9000}№ %d", TrailerInfo[t][tOwnerID]), strcat(sctring,str);
   	format(str,sizeof(str),"\nModel: {ffffff}%d", TrailerInfo[t][tModel]), strcat(sctring,str);
    if (TrailerInfo[t][tActive]) format(str,sizeof(str),"\nСтатус: {99ff66}Установлен"), strcat(sctring,str);
    else format(str,sizeof(str),"\nСтатус: {FF6347}Не установлен"), strcat(sctring,str);
	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ff9000}Трейлер",sctring,"*","");
	return 1;
}

function OnCreatePlayerTrailerPickup(id, Float: x, Float: y, Float: z) {
    new rows;
    cache_get_row_count(rows);

    if (rows) {
        new owner_name[MAX_PLAYER_NAME + 1], number = id + 1;
        cache_get_value_name(0, "Name", owner_name);
        new string[100];
        if(TrailerInfo[id][tEnterPickup] != 0)
        {
            DestroyDynamic3DTextLabel(TrailerInfo[id][t3DLabel]);
            DestroyDynamicPickup(TrailerInfo[id][tEnterPickup]);
        }
        format(string,sizeof(string),"{cccccc}Трейлер "COLOR_ORANGE_TEXT"№ %d\n"COLOR_WHITE_TEXT"Владелец: "COLOR_ORANGE_TEXT"%s", number, owner_name);
        TrailerInfo[id][t3DLabel] = CreateDynamic3DTextLabel(string, 0xA9C4E4FF, x, y, z, 12.5, .testlos = 1, .worldid = 0, .interiorid = 0);
        TrailerInfo[id][tEnterPickup] = CreateDynamicPickup(1272, STREAMER_TYPE_PICKUP, x, y, z, 0, 0, .streamdistance = 100.0);
        Streamer_SetIntData(STREAMER_TYPE_PICKUP, TrailerInfo[id][tEnterPickup], STREAMER_EXTRA_TYPE_TRAILER_ENTER, id + 1);
    }
    
	return 1;
}

stock SavePlayerTrailerInfo(id) {
    if (id < 0 || id > MAX_TRAILERS) return 0;

    new string_mysql[500];
    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE trailers SET owner = %d, pos_x = %.4f, pos_y = %.4f, pos_z = %.4f, \
        pic_x = %.4f, pic_y = %.4f, pic_z = %.4f, rot_x = %.4f, rot_y = %.4f, rot_z = %.4f, active = %d, locked = %d WHERE id = %d",
	    TrailerInfo[id][tOwnerID],
        TrailerInfo[id][tPos][0], TrailerInfo[id][tPos][1], TrailerInfo[id][tPos][2],
        TrailerInfo[id][tPic][0], TrailerInfo[id][tPic][1], TrailerInfo[id][tPic][2],
        TrailerInfo[id][tRot][0], TrailerInfo[id][tRot][1], TrailerInfo[id][tRot][2],
        TrailerInfo[id][tActive],
        TrailerInfo[id][tLocked],
        TrailerInfo[id][tID]); // 197 + 44 + 180
	query_empty(pearsq, string_mysql);
    return 1;
}

// При создании нового трейлера в базе данных
function OnPlayerTrailerCreate(id) {
    TrailerInfo[id][tNewid] = cache_insert_id();
    return 1;
}

stock DeleteTrailerFromDB(tid)
{
    new query_string[100];
    mysql_format(pearsq, query_string, sizeof(query_string), "DELETE FROM trailers WHERE id = %d", TrailerInfo[tid][tID]);
    mysql_tquery(pearsq, query_string);

    // Сохраняем трейлер в аккаунт игроку
    UpdateTrailerPlayer(0, TrailerInfo[tid][tOwnerID]);

    // Очищаем информацию о трейлере
    for(new e_TrailerInfo:i; i < e_TrailerInfo; ++i) TrailerInfo[tid][i] = 0;
    return 1;
}

// Вход в трейлер
stock EnterTrailer(playerid)
{
    new bool:yesEnter;
    if(OnlineInfo[playerid][oInteriorPlayer] == 0 && OnlineInfo[playerid][oWorldPlayer] == 0)
    {
        new Float:pickup_pos[3];
        for(new i = 0; i < MAX_TRAILERS; i++)
        {
            if(TrailerInfo[i][tOwnerID] > 0 && TrailerInfo[i][tObject] > 0 && TrailerInfo[i][tActive] == true
                && IsValidDynamicPickup(TrailerInfo[i][tEnterPickup]))
            {
                Streamer_GetItemPos(STREAMER_TYPE_PICKUP, TrailerInfo[i][tEnterPickup], pickup_pos[0], pickup_pos[1], pickup_pos[2]);
                if(IsPlayerInRangeOfPoint(playerid, 1.8, pickup_pos[0], pickup_pos[1], pickup_pos[2]))
                {
                    if(TrailerInfo[i][tLocked] == false || TrailerInfo[i][tOwnerID] == PlayerInfo[playerid][pID])
                    {
                        keep(playerid);
                        S_SetPlayerVirtualWorld(playerid,i+5000,187);
                        PPSetPlayerInterior(playerid,187);
                        PPSetPlayerPos(playerid,-0.6773,1567.1011,12.7694);
                        PPSetPlayerFacingAngle(playerid, 91);
                        SetCameraBehindPlayer(playerid);
                        GameTextForPlayer(playerid," ",5000,3);
                    }
                    else
                    {
                        DP[0][playerid] = i;
                        PlayerPlaySound(playerid,17803,0,0,0);
                        new lines[200];
                        format(lines,sizeof(lines),"{FF6347}Дверь заперта!\
                            {cccccc}\n\nТребования для проникновения в трейлер!\
                            {cccccc}\n- Террорка маска [ Y >> GPS >> Услуги >> Магазины Одежды ]\
                            {cccccc}\n- Фонарик [ Y >> GPS >> Услуги >> Супермаркеты ]\
                            {FF6347}\n\nВнимание! {cccccc}Доступно только для участников банд и мафий\
                            {cccccc}\n\nХотите взломать дверь?");
                        ShowDialog(playerid,1463,DIALOG_STYLE_MSGBOX,"{ff9000}Дверь",lines,"Да","Нет");
                    }
                    yesEnter = true;
                    break;
                }
            }
        }
    }
    return yesEnter;
}

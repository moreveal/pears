// Система установки трейлеров (построек)
// Основная часть кода выполнена в этом файле, но отдельные части, для соответствия структуре мода, помещены в различные паблики/колбеки
// Также используется кастомные функции по типу GetDistanceBetweenCoords3d(), их можно найти с помощью [ Ctrl + Shift + F ]

// [ Требуется доработать вход в трейлер - само определение трейлера уже сделано () ]

#define STREAMER_EXTRA_TYPE_TRAILER_ENTER	E_STREAMER_CUSTOM(3)
#define PI 3.14159265358979323846
#define MAX_TRAILERS 1000 // Максимальное количество трейлеров
// Данные о трейлерах
enum e_TrailerInfo {
	tID, // ID трейлера
	tOwnerID, // ID аккаунта владельца
	tModel, // ID модели трейлера
	Float: tPos[3], Float: tRot[3], Float: tPic[3], // Позиция в игровом мире
	Text3D: t3DLabel, // Идентификатор 3д текста у входа
    Text3D: tt3DLabel, // Идентификатор Стола
	tEnterPickup, // Идентификатор иконки домика
	tAttached, // ID транспорта, к которому прикреплен трейлер [0 - если не прикреплен]
	tObject, // ID установленного объекта (если он стоит в игровом мире)
	bool: tActive, // Статус существования в игровом мире
	bool: tLocked, // Статус дверей
    bool: tTable, // Статус стола
	tTimerID // Хранит идентификатор таймера для сохранения прицепа
}
new trailerInfo[MAX_TRAILERS][e_TrailerInfo];

const TRAILER_VEHICLE_INTERIOR = 101; // Интерьер для трейлеров (для самого транспорта, чтобы он стал невидимым; а уже к нему будет приклепляться объект трейлера)

CMD:trailer(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 3) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Телепорт к трейлеру [ /trailer Номер ]");
    if(params[0] < 1 || params[0] > MAX_TRAILERS) return ErrorMessage(playerid, "{FF6347}Не меньше 1 и не больше 1000");
    if(!trailerInfo[params[0]-1][tActive]) return ErrorMessage(playerid, "{FF6347}Трейлер не установлен");
    PPSetPlayerPos(playerid, trailerInfo[params[0]-1][tPic][0], trailerInfo[params[0]-1][tPic][1], trailerInfo[params[0]-1][tPic][2]+0.5);
    S_SetPlayerVirtualWorld(playerid,0,0);
	SetPlayerInterior(playerid,0);
	return 1;
}

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
    if (model == 3171) GetRelativePos(x, y, z, rx, ry, rz, (1153.9735 - 1155.514282), (-1412.2659 - -1411.623779), (13.6603 - 12.465091), doorX, doorY, doorZ);
    else if (model == 3172) GetRelativePos(x, y, z, rx, ry, rz, (298.9278 - 300.657226), (-1716.3157 - -1715.170776), (7.0998 - 5.904612), doorX, doorY, doorZ);
    else if (model == 3174) GetRelativePos(x, y, z, rx, ry, rz, (298.9278 - 300.657226), (-1716.3157 - -1715.170776), (7.0998 - 5.904612), doorX, doorY, doorZ);

    format(store,sizeof(store),"SELECT * FROM pp_igroki WHERE id = '%d'", trailerInfo[id][tOwnerID]); // Грузим ID Аккаунта
    mysql_tquery(pearsq, store, "OnCreatePlayerTrailerPickup", "dfff", id, doorX, doorY, doorZ);

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
    if (trailerInfo[id][tTable] == true){
        DestroyDynamic3DTextLabel(trailerInfo[id][tt3DLabel]);
    }
    DestroyDynamic3DTextLabel(trailerInfo[id][t3DLabel]);
    DestroyDynamicPickup(trailerInfo[id][tEnterPickup]);

    trailerInfo[id][tActive] = false;
    trailerInfo[id][tTable] = false;
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
    GetXYInFrontOfPoint(player_pos[0], player_pos[1], player_pos[3], -3.5);

    trailerid = CreateVehicle(606, player_pos[0], player_pos[1], player_pos[2] - 10.0, 0, 0, 600, 0);
    SetVehicleVirtualWorld(trailerid, 100);
    LinkVehicleToInterior(trailerid, TRAILER_VEHICLE_INTERIOR);

    if (model == 3171 || model == 3168 || model == 3172 || model == 3174)
    {
        trailerobj = CreateDynamicObject(model, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);
        if (model == 3171) AttachDynamicObjectToVehicle(trailerobj, trailerid, -0.119, -1.900, -1.060, 0.000, 0.000, 178.698); // Mini (2)
        else if (model == 3168) AttachDynamicObjectToVehicle(trailerobj, trailerid, -0.178, -3.511, -1.000, 0.000, 0.000, 177.901); // Middle (3)
        else if (model == 3172) AttachDynamicObjectToVehicle(trailerobj, trailerid, -0.178, -3.511, -1.000, 0.000, 0.000, 177.901); // Big (4)
        else if (model == 3174) AttachDynamicObjectToVehicle(trailerobj, trailerid, -0.178, -3.511, -1.000, 0.000, 0.000, 177.901); // Round (1)
    }
    else return false;

    SetVehicleVirtualWorld(trailerid, 0);

    // Закрепляем трейлер за автомобилем
    SetTimerEx("AttachTrailerToVehicleDelay", 950, 0, "dd", trailerid, vehicleid);

    SuccessMessage(playerid, "{99ff66}Трейлер прикреплён к вашему автомобилю\n{cccccc}Установить - {ff9000}[ CAPS LOCK ]\n\n{cccccc}Управляйте транспортом с прицепом осторожно.\nСоблюдайте правила дорожного движения.");
    return true;
}

// Для отложенного вызова прикрепления прицепа
forward AttachTrailerToVehicleDelay(trailerid, vehicleid);
public AttachTrailerToVehicleDelay(trailerid, vehicleid) { AttachTrailerToVehicle(trailerid, vehicleid); }

// Проверяет на месте ли трейлер и выполняет необходимые действия, если тот отцепился
forward PlayerTrailerTimer(vehicleid, trailerid, tid);
public PlayerTrailerTimer(vehicleid, trailerid, tid) {
    if (!IsValidVehicle(vehicleid) || !IsValidVehicle(trailerid)) {
        trailerInfo[tid][tAttached] = 0;
        return KillTimer(trailerInfo[tid][tTimerID]);
    }
    
    static Float: safe_health = 1000.0;
    if (GetVehicleTrailer(vehicleid) < 1) {
        // Резко останавливаем водителя и трейлер (чтобы ничего не летало)
        SetVehicleSpeed(trailerid, 0), SetVehicleSpeed(vehicleid, 0);

        // Если трейлер далеко (Удаляем трейлер)
        new Float: vehicle_pos[3], Float: trailer_pos[3];
        GetVehiclePos(vehicleid, vehicle_pos[0], vehicle_pos[1], vehicle_pos[2]);
        GetVehiclePos(trailerid, trailer_pos[0], trailer_pos[1], trailer_pos[2]);
        if (GetDistanceBetweenCoords3d(trailer_pos[0], trailer_pos[1], trailer_pos[2], vehicle_pos[0], vehicle_pos[1], vehicle_pos[2]) > STREAMER_OBJECT_SD) {
            trailerInfo[tid][tAttached] = 0;
            ACDestroyVehicle(trailerid);
            return KillTimer(trailerInfo[tid][tTimerID]);
        }

        // Если трейлер на грани уничтожения после того, как отцепился (Удаляем трейлер)
        new Float: health;
        GetVehicleHealth(trailerid, health);
        if (health < 400) {
            trailerInfo[tid][tAttached] = 0;
            ACDestroyVehicle(trailerid);
            return KillTimer(trailerInfo[tid][tTimerID]);
        }

        // Если трейлер не очень далеко и целый, просто отцепился (Крепим обратно)
        foreach (new id : Player) {
            if (PlayerInfo[id][pID] == trailerInfo[tid][tOwnerID]) {
                if (GetPlayerVehicleID(id) == vehicleid && GetPlayerState(id) == PLAYER_STATE_DRIVER) {
                    SetVehicleHealth(trailerid, 1000);
                    
                    // Если нет никаких препятствий для присоединения трейлера (высота, вода)
                    new Float: depth, Float: vehicledepth;
                    if (IsVehicleStandingGround(vehicleid) && !CA_IsVehicleInWater(vehicleid, depth, vehicledepth)) {
                        AttachTrailerToVehicle(trailerid, vehicleid); // Присоединяем трейлер обратно
                        SetVehicleHealth(vehicleid, safe_health); // Компенсируем возможный полученный дамаг
                    }
                }
                break;
            }
        }
    } else {
        // Запоминаем последнее количество HP до отсоединения прицепа, чтобы восстановить его, если он продамажит транспорт
        GetVehicleHealth(vehicleid, safe_health);
    }

    return 1;
}

// Получает ID трейлера в массиве trailerInfo
stock GetPlayerTrailerID(playerid) {
    for (new i = 0; i < MAX_TRAILERS; i++) 
    {
        if (trailerInfo[i][tOwnerID] == 0) break;
        if (trailerInfo[i][tOwnerID] == PlayerInfo[playerid][pID]) return i;
    }
    return -1;
}

// Создает новый трейлер указанного типа и присваивает его указанному игроку
stock AddPlayerTrailer(playerid, model) {
    if (GetPlayerTrailerID(playerid) > -1) return false;

    for (new id = 0; id < MAX_TRAILERS; id++) {
        if (trailerInfo[id][tOwnerID] == 0)
        {
            trailerInfo[id][tModel] = model;
            trailerInfo[id][tOwnerID] = PlayerInfo[playerid][pID];
            // Сохранение в базу данных
            static const fmt_str[] = "INSERT INTO trailers (owner, model) VALUES (%d, %d)";
            new query_string[sizeof fmt_str - 2 + 9 - 2 + 8 + 1];
            mysql_format(pearsq, query_string, sizeof query_string, fmt_str, trailerInfo[id][tOwnerID], trailerInfo[id][tModel]);
            mysql_tquery(pearsq, query_string, "OnPlayerTrailerCreate", "d", id);
            return true;
        }
    }

    return false;
}

// Удаляет трейлер, принадлежавший игроку
stock DeletePlayerTrailer(playerid) {
    new tid = GetPlayerTrailerID(playerid);
    if (tid < 0) return false;

    // На случай если трейлер прямо сейчас прикреплен к авто игрока - открепляем, удаляем
    if (trailerInfo[tid][tTimerID] <= 0) {
        KillTimer(trailerInfo[tid][tTimerID]);
        new trailerid = GetVehicleTrailer(GetPlayerVehicleID(playerid));
        if (trailerid > 0) {
            //DestroyDynamicObject(trailerInfo[tid][tObject]);
            ACDestroyVehicle(trailerid);
        }
    }

    UnloadPlacedTrailer(tid); // Выгружаем трейлер из игрового мира (если он создан)
    
    // Вносим изменения в базу данных
    static const query_fmt_str[] = "DELETE FROM trailers WHERE id = %d";
    new query_string[sizeof query_fmt_str - 2 + 5 + 1];
    mysql_format(pearsq, query_string, sizeof query_string, query_fmt_str, trailerInfo[tid][tID]);
    mysql_tquery(pearsq, query_string);

    // Очищаем информацию о трейлере
    memset(trailerInfo[tid], 0);

    return true;
}

// Отображает меню взаимодействия со своим трейлером
stock ShowTrailerMenu(playerid) {
    new tid = GetPlayerTrailerID(playerid);
    if (tid < 0) return 0;

    static const fmt_str[] = "{ffffff}Отметить на карте\nДверь [ %s ]\nСтол для варки [ %s ]";
    new str[sizeof fmt_str - 2 + 8 + 7 + 1 + 16 + 1 + 10];
    format(str, sizeof str, fmt_str, 
        (trailerInfo[tid][tLocked] ? ("{ff3333}Закрыта{ffffff}") : ("{ffffff}Открыта")),(trailerInfo[tid][tTable] ? ("{ff3333}Спрятан{ffffff}") : ("{ffffff}Установлен"))
    );

    ShowDialog(playerid, 1390, DIALOG_STYLE_LIST,"Трейлер", str, "Ок", "Закрыть");

    return 1;
}

// Команда для прикрепления трейлера к своему автомобилю
// Срабатывает только в том случае, если игрок находится в пригодном для этого месте, либо рядом с уже существующим трейлером
CMD:trailer_attach(playerid)
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
        if (GetDistanceBetweenCoords3d(player_pos[0], player_pos[1], player_pos[2], trailerInfo[tid][tPos][0], trailerInfo[tid][tPos][1], trailerInfo[tid][tPos][2]) < 15.0) 
        {
            UnloadPlacedTrailer(tid);
        } 
        else return ErrorMessage(playerid, "{FF6347}Ваш трейлер уже установлен {cccccc}[ Y >> Жилье >> Трейлер >> Отметить на карте ]");
    } 
    else 
    {
        if(!IsPlayerInRangeOfPoint(playerid,8.0,-547.4172,-1018.2808,24.1529)) return ErrorMessage(playerid, "{FF6347}Прикрепить трейлер можно только в трейлерном парке\n{cccccc}[ Y >> GPS >> Недвижимость >> Трейлерный Парк ]");
    }
    // Удаляем трейлер, если он уже был прицеплен
    if (trailerInfo[tid][tAttached]) {
        new trailerid = GetVehicleTrailer(trailerInfo[tid][tAttached]);
        if (trailerid > 0) ACDestroyVehicle(trailerid);
        KillTimer(trailerInfo[tid][tTimerID]);
    }

    // Создаем трейлер, цепляя его к автомобилю
    new trailerid, trailerobj;
    if (!AttachTrailer(playerid, trailerInfo[tid][tModel], vehicleid, trailerid, trailerobj)) return 0;

    trailerInfo[tid][tAttached] = vehicleid;
    trailerInfo[tid][tObject] = trailerobj;
    Cars[trailerid] = 2001 + tid;
    trailerInfo[tid][tTimerID] = SetTimerEx("PlayerTrailerTimer", 1000, 1, "ddd", vehicleid, trailerid, tid);

    return 1;
}

// Команда для размещения в игровом мире прицепленного трейлера
CMD:trailer_place(playerid) {
    new tid = GetPlayerTrailerID(playerid);
    if (tid < 0) return 0;

    // Если игрок водитель транспорта, к которому прикреплен его трейлер
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!vehicleid) return 0;
    if (trailerInfo[tid][tAttached] == vehicleid && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
        new trailerid = GetVehicleTrailer(vehicleid);
        if (trailerid < 1) return 0;

        if(IsPlayerInRangeOfPoint(playerid,50.0,-547.4172,-1018.2808,24.1529)) return ErrorMessage(playerid, "{FF6347}Нельзя установить трейлер на территории трейлерного парка");
        if(IsANotMoney(playerid)) return ErrorMessage(playerid, "{FF6347}Трейлеры запрещено устанавливать на территории городов");
        if(VehInfo[vehicleid][vEngine] == 1) return ErrorMessage(playerid, "{FF6347}Заглушите двигатель вашего транспорта");

        // Отсоединяем трейлер от автомобиля
        KillTimer(trailerInfo[tid][tTimerID]);

        // Размещаем объект трейлера в игровом мире
        new Float: trailer_pos[4];
        GetVehiclePos(trailerid, trailer_pos[0], trailer_pos[1], trailer_pos[2]);
        GetVehicleZAngle(trailerid, trailer_pos[3]);
        GetXYInFrontOfPoint(trailer_pos[0], trailer_pos[1], trailer_pos[3], -0.75); // чуть назад

        // [ Довольно плохо определяется позиция, относительно невидимого автомобиля, к которому приаттачен объект, в идеале бы поправить ]

        // 3174 - round
        if (trailerInfo[tid][tModel] == 3171) PlaceTrailer(tid, trailerInfo[tid][tModel], trailer_pos[0] - 0.119, trailer_pos[1] - 1.900, trailer_pos[2] - 1.060, 0.0, 0.0, trailer_pos[3] + 178.698);
        // 3168 middle
        else if (trailerInfo[tid][tModel] == 3172) PlaceTrailer(tid, trailerInfo[tid][tModel], trailer_pos[0] - 0.178, trailer_pos[1] - 3.511, trailer_pos[2] - 1.000, 0.0, 0.0, trailer_pos[3] + 177.901);
        
        ACDestroyVehicle(trailerid);
        SavePlayerTrailerInfo(tid);

        SuccessMessage(playerid, "{99ff66}Трейлер установлен!\n{cccccc}Теперь он будет находиться здесь.");
    }

    return 1;
}

// Команда для добавления трейлера игроку
stock trailer_add(playerid, model) {
    new targetid;

    new tid = GetPlayerTrailerID(targetid);
    if (tid > -1) {
        static const fmt_str[] = "[ Мысли ]: У вас уже есть трейлер "COLOR_ORANGE_TEXT"[ №%d ]";
        new str[sizeof fmt_str - 2 + 5];
        format(str, sizeof str, fmt_str, trailerInfo[tid][tID]);
        SendClientMessage(playerid, COLOR_GRAY, str);
        return 1;
    }
    SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Я Купил трейлер");
    
    new infocreate = AddPlayerTrailer(targetid, model);
    if (infocreate == 0) ErrorMessage(playerid, "{FF6347}Трейлер не может быть создан [ Лимит: 1000 ]");
    return 1;
}


// Команда для удаления трейлера игрока
CMD:trailer_delete(playerid, const params[]) {
    new targetid;
    if (sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Удалить трейлер игрока [ /trailer_delete ID ]");
    new tid = GetPlayerTrailerID(targetid);
    if (tid < 0) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: У этого игрока нет трейлера");
    SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Я забрал трейлер у указанного игрока");

    DeletePlayerTrailer(targetid);
    return 1;
}

// Выгружает созданный в игровом мире трейлер
CMD:trailer_unload(playerid, const params[]) {
    new tid;
    if (sscanf(params, "d", tid)) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Выгрузить трейлер [ /trailer_unload TrailerID ]");
    if (tid < 0 || tid > MAX_TRAILERS) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Указан некорректный номер трейлера");
    if (!trailerInfo[tid][tActive]) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Этот трейлер не находится в игровом мире");
    UnloadPlacedTrailer(tid);
    SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Я выгрузил указанный трейлер из игрового мира");
    return 1;
}

// Открывает меню управления
CMD:trailer_menu(playerid) {
    if (!ShowTrailerMenu(playerid)) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: У меня вообще нет трейлера..");
    return 1;
}


// MYSQL
forward UploadTrailers();
public UploadTrailers()
{
    new time = GetTickCount();
	for (new i = 0; i < cache_num_rows(); i++) {
		cache_get_value_name_int(i, "id", trailerInfo[i][tID]);
		cache_get_value_name_int(i, "owner", trailerInfo[i][tOwnerID]);
		cache_get_value_name_int(i, "model", trailerInfo[i][tModel]);
		cache_get_value_name_float(i, "pos_x", trailerInfo[i][tPos][0]);
		cache_get_value_name_float(i, "pos_y", trailerInfo[i][tPos][1]);
		cache_get_value_name_float(i, "pos_z", trailerInfo[i][tPos][2]);
		cache_get_value_name_float(i, "rot_x", trailerInfo[i][tRot][0]);
		cache_get_value_name_float(i, "rot_y", trailerInfo[i][tRot][1]);
		cache_get_value_name_float(i, "rot_z", trailerInfo[i][tRot][2]);
        cache_get_value_name_float(i, "pic_x", trailerInfo[i][tPic][0]);
		cache_get_value_name_float(i, "pic_y", trailerInfo[i][tPic][1]);
		cache_get_value_name_float(i, "pic_z", trailerInfo[i][tPic][2]);
		cache_get_value_name_bool(i, "active", trailerInfo[i][tActive]);
		cache_get_value_name_bool(i, "locked", trailerInfo[i][tLocked]);
        cache_get_value_name_bool(i, "stol", trailerInfo[i][tTable]);

		if (trailerInfo[i][tActive]) PlaceTrailer(i, trailerInfo[i][tModel], trailerInfo[i][tPos][0], trailerInfo[i][tPos][1], trailerInfo[i][tPos][2], trailerInfo[i][tRot][0], trailerInfo[i][tRot][1], trailerInfo[i][tRot][2]);
	}
    printf("[MODE]: Трейлеры [%d ms]",GetTickCount() - time);
	return 1;
}

forward OnCreatePlayerTrailerPickup(id, Float: x, Float: y, Float: z);
public OnCreatePlayerTrailerPickup(id, Float: x, Float: y, Float: z) {
	new owner_name[MAX_PLAYER_NAME + 1], number = id+1;
	cache_get_value_name(0, "Name", owner_name);
	static const label_fmt_str[] = "{cccccc}Трейлер "COLOR_ORANGE_TEXT"№%d\n"COLOR_WHITE_TEXT"Владелец: "COLOR_ORANGE_TEXT"%s";
    new label_str[sizeof label_fmt_str - 10 + 5 - 2 + MAX_PLAYER_NAME + 1];
    format(label_str, sizeof label_str, label_fmt_str,
        number,
        owner_name
    );
	if (trailerInfo[id][tTable] == true) 
    {
        trailerInfo[id][tt3DLabel] = CreateDynamic3DTextLabel("{ff9000}Химический Стол\n{cccccc}[ /kakish ]", 0xA9C4E4FF, 391.608337, -2089.791015, 899.472961, 12.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1,id+5000,0);
    }
    trailerInfo[id][t3DLabel] = CreateDynamic3DTextLabel(label_str, 0xA9C4E4FF, x, y, z, 12.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1,0,0);
    trailerInfo[id][tEnterPickup] = CreateDynamicPickup(1272, STREAMER_TYPE_OBJECT, x, y, z, 0, 0, .streamdistance = 100.0);
	Streamer_SetIntData(STREAMER_TYPE_PICKUP, trailerInfo[id][tEnterPickup], STREAMER_EXTRA_TYPE_TRAILER_ENTER, id + 1);
	return 1;
}


stock SavePlayerTrailerInfo(id) {
    if (id < 0 || id > MAX_TRAILERS) return 0;
    format(big_query, sizeof(big_query), "UPDATE trailers SET owner = %d, pos_x = %.4f, pos_y = %.4f, pos_z = %.4f, pic_x = %.4f, pic_y = %.4f, pic_z = %.4f, rot_x = %.4f, rot_y = %.4f, rot_z = %.4f, active = %d, locked = %d, stol = %d WHERE id = %d",
	    trailerInfo[id][tOwnerID],
        trailerInfo[id][tPos][0], trailerInfo[id][tPos][1], trailerInfo[id][tPos][2],
        trailerInfo[id][tPic][0], trailerInfo[id][tPic][1], trailerInfo[id][tPic][2],
        trailerInfo[id][tRot][0], trailerInfo[id][tRot][1], trailerInfo[id][tRot][2],
        trailerInfo[id][tActive],
        trailerInfo[id][tLocked],
        trailerInfo[id][tTable],
        trailerInfo[id][tID]);
	query_empty(pearsq, big_query);
    return 1;
}

// При создании нового трейлера в базе данных
stock OnPlayerTrailerCreate(id) {
    trailerInfo[id][tID] = cache_insert_id();
    return 1;
}

stock VehicleOnPlayerDisconnect(playerid)
{
	// Удаление прицепленного трейлера
	new tid = GetPlayerTrailerID(playerid);
	if (tid > -1) {
		if (trailerInfo[tid][tAttached]) {
			new trailerid = GetVehicleTrailer(trailerInfo[tid][tAttached]);
			if (trailerid > 0) ACDestroyVehicle(trailerid);
			else KillTimer(trailerInfo[tid][tTimerID]);
		}
	}
	return 1;
}
stock TrailerBuy(playerid){
	format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"{cccccc}Название \t{99ff66}Цена\n"), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Round Trailer\t{99ff66}1$\n"), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Mini Trailer\t{99ff66}2$\n"), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Middle Trailer\t{99ff66}3$\n"), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Big Trailer\t{99ff66}4$\n"), strcat(lines,line);

	format(store,sizeof(store),"{cccccc}Покупка Трейлера");
	ShowDialog(playerid,1395,DIALOG_STYLE_TABLIST_HEADERS,store,lines,"Выбрать","Отмена");
	return 1;
}
//_________________________________________________________
//__________________Славин Паблик__________________________
//_________________________________________________________
/*
    Получает новые координаты, высчитанные на основе применения переданных углов поворота.
    Полезно для высчитывания новой позиции одного объекта, относительно другого (родительского).

    x, y, z, rx, ry, rz - данные родительского объекта
    offsetX, offsetY, offsetZ - оффсеты второго объекта при нулевых угловых поворотах родительского объекта
    resX, resY, resZ - переменные для записи результата
*/
stock GetRelativePos(Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz, Float: offsetX, Float: offsetY, Float: offsetZ, &Float: resX, &Float: resY, &Float: resZ) {
    new Float: rz_rad = rz * (PI / 180.0);
    new Float: ry_rad = ry * (PI / 180.0);
    new Float: rx_rad = rx * (PI / 180.0);

    // correct by z-axis
    x = x + (offsetX * floatcos(rz_rad)) - (offsetY * floatsin(rz_rad));
    y = y + (offsetX * floatsin(rz_rad)) + (offsetY * floatcos(rz_rad));
    z = z + offsetZ;

    // correct by y-axis
    x = x + (offsetZ * floatsin(ry_rad));
    z = z - (offsetZ * floatcos(ry_rad));

    // correct by x-axis
    y = y + (offsetZ * floatsin(rx_rad));
    z = z + (offsetZ * floatcos(rx_rad));

    resX = x; resY = y; resZ = z;
    return 1;
}

// Получаем модель динамического объекта
stock GetDynamicObjectModel(objectid) return Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);

// Вычисление расстояния от точки до точки в 3D пространстве
stock GetDistanceBetweenCoords3d(Float: x, Float: y, Float: z, Float: fx, Float:fy, Float: fz) return floatround(floatsqroot(floatpower(fx - x, 2) + floatpower(fy - y, 2) + floatpower(fz - z, 2)));

// Вычисление расстояния от точки до точки в 2D пространстве
stock GetDistanceBetweenCoords2d(Float: x, Float: y, Float: fx, Float:fy) return floatround(floatsqroot(floatpower(fx - x, 2) + floatpower(fy - y, 2)));

// Получает модуль числа
#define abs(%0) ( ( %0 < 0 ) ? (-%0) : (%0) )

// Проверяет находится ли транспорт на земле
stock IsVehicleStandingGround(vehicleid) {
	if (!IsValidVehicle(vehicleid)) return false;

	new Float: vehicle_pos[3], Float: z;
	GetVehiclePos(vehicleid, vehicle_pos[0], vehicle_pos[1], vehicle_pos[2]);
	CA_FindZ_For2DCoord(vehicle_pos[0], vehicle_pos[1], z);

	return abs(vehicle_pos[2] - z) <= 1.0;
}

stock SetVehicleSpeed(vehicleid, speed_mph)
{
	if (speed_mph < 1) speed_mph = 1;
	new Float: v[3], Float:cur_speed_mph;
	GetVehicleVelocity(vehicleid, v[0], v[1], v[2]);
	cur_speed_mph = GetVehicleSpeed(vehicleid);
	if (cur_speed_mph <= 0)
	{
		new Float: zAngle;
		GetVehicleZAngle(vehicleid, zAngle);
		new Float:newVelX = floatcos((zAngle -= 270.0), degrees) *speed_mph / 200;
		SetVehicleVelocity(vehicleid, newVelX, floattan(zAngle,degrees) *newVelX, 0.0);
		return;
	}
	new Float: vMultiplier = float(speed_mph) / cur_speed_mph;
	SetVehicleVelocity(vehicleid, v[0] *vMultiplier, v[1] *vMultiplier, v[2] *vMultiplier);
}

// Чистка Enum
stock memset(array[], val, size = sizeof array)
{
    #pragma unused array, val
    static
        fill_inst_offset;
    if (fill_inst_offset == 0) {
        #emit lctrl 6
        #emit move.alt                  // 4
        #emit lctrl 0                   // 8
        #emit add                       // 4
        #emit move.alt                  // 4
        #emit lctrl 1                   // 8
        #emit sub.alt                   // 4
        #emit add.c 92                  // 8
        #emit stor.pri fill_inst_offset // 8
    } {}                                // 
    #emit load.s.pri size               // 8
    #emit shl.c.pri 2                   // 8
    #emit sref.pri fill_inst_offset     // 8
    #emit load.s.alt 12                 // 8
    #emit load.s.pri 16                 // 8
    #emit fill 1                        // 4
    #emit zero.pri
    #emit retn
}

stock exittrailer(playerid)
{   
    new tid = GetPlayerVirtualWorld(playerid)-5000;
    if(Sleep[playerid] >= 1 || SleepRP[playerid] >= 1) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я сплю");
    keep(playerid);
    S_SetPlayerVirtualWorld(playerid,0,0);
    SetPlayerInterior(playerid,0);
    PPSetPlayerPos(playerid,trailerInfo[tid][tPic][0], trailerInfo[tid][tPic][1], trailerInfo[tid][tPic][2]+0.5);
    return 1;
}

CMD:kakish(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid,0.5,391.608337, -2089.791015, 899.472961))
	{
		if(!howstun(playerid))
	 	{
			if(Piss[playerid] >= 1 || Hold[playerid] >= 1 || Piss[playerid] == 7 || Dei[playerid] > 0 || OnlineInfo[playerid][oInHandThing][0] > 0 || GetPlayerWeapon(playerid) >= 2) return ErrorMessage(playerid, "{FF6347}У вас заняты руки или выполняется действие [Предмет или оружие]");
			new str[64],sctring[704];
			format(str,sizeof(str),"{ff9000}Таблетка\n"), strcat(sctring,str);
            format(str,sizeof(str),"{ff9000}Деталь бомбы\n"), strcat(sctring,str);
			ShowDialog(playerid,1391,DIALOG_STYLE_LIST,"{ff9000}Изготовительный Стол",sctring,"Выбор","Отмена");
		}
	}
	else ErrorMessage(playerid, "{FF6347}Вы должны быть у изготовительного стола\n[В интерьере трейлера!]");
	return 1;
}

stock UseHimLab(playerid)
{
    new thingId;
    if (GetPVarInt(playerid,"Arobsklad") == 16) thingId = 180;
	else if (GetPVarInt(playerid,"Arobsklad") == 17) thingId = 182;
	else return ErrorMessage(playerid, "{FF6347}Шакал на Филине допустил где-то ошибку"), SetPVarInt(playerid,"Arobsklad",0);
	new current_tick = GetTickCount();
	new interval = GetTickDiff(current_tick, Aftextdraw[playerid]);
	if(interval > 300)
	{
		SetPVarInt(playerid,"oryjtemp",GetPVarInt(playerid,"oryjtemp")+1*get_ability(playerid, 7));
		if(!IsPlayerInRangeOfPoint(playerid,3.0,Job_X[playerid], Job_Y[playerid], Job_Z[playerid]))
		{
			SetPVarInt(playerid,"oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0), ClearAnimations(playerid), TextDrawHideForPlayer(playerid, MindDraw[3]), PlayerTextDrawHide(playerid, HintButton), PlayerPlaySound(playerid,4203,0,0,0);
			Dei[playerid] = 7, GameTextForPlayer(playerid,RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Вы отошли от стола"), 5000, 3), RemovePlayerAttachedObject(playerid,1);
		}
		new string[58];
		format(string, sizeof(string), RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~%d/100"),GetPVarInt(playerid,"oryjtemp")), GameTextForPlayer(playerid,string, 1500, 3);
	 	ApplyAnimation(playerid,"OTB","betslp_loop",2.0, 1, 0, 0, 0, 0);
	 	if(GetPVarInt(playerid,"oryjtemp") >= 100)
		{
            new watchslot = get_watch(playerid);
			RemovePlayerAttachedObject(playerid,1), ClearAnim(playerid), ClearAnimations(playerid), Dei[playerid] = 0, TextDrawHideForPlayer(playerid, MindDraw[3]), PlayerTextDrawHide(playerid, HintButton), SetPVarInt(playerid,"oryjtemp", 0);
            if (GetPVarInt(playerid,"Arobsklad") == 16){
			    if(get_invent3(playerid, 6, 1) < 10) return ErrorMessage(playerid, "{FF6347}У вас не хватает Грибов\n\n{cccccc}1 Таблетка = 10 штук Грибов"), SetPVarInt(playerid,"Arobsklad",0);
			    if(get_invent4(playerid, 112, 0) < 1) return ErrorMessage(playerid, "{FF6347}У вас не хватает Водки\n\n{cccccc}1 Таблетка = 100мл из бутылки Водки"), SetPVarInt(playerid,"Arobsklad",0);
			    if(get_invent4(playerid, 5, 0) < 1) return ErrorMessage(playerid, "{FF6347}У вас не хватает Пустой Таблетки\n\n{cccccc}1 Таблетка = 1 Пустая Таблетка"), SetPVarInt(playerid,"Arobsklad",0);
            } 
            else if (GetPVarInt(playerid,"Arobsklad") == 17)
            {
                if(get_invent4(playerid, 181, 0) < 3) return ErrorMessage(playerid, "{FF6347}У вас не хватает Изоленты\n\n{cccccc}1 Деталь бомбы = 3 изоленты"), SetPVarInt(playerid,"Arobsklad",0);
			    if(get_invent4(playerid, 60, 0) < 40) return ErrorMessage(playerid, "{FF6347}У вас не хватает Палладия\n\n{cccccc}1 Деталь бомбы = 40 Палладия"), SetPVarInt(playerid,"Arobsklad",0);
			    if(get_invent4(playerid, 61, 0) < 50) return ErrorMessage(playerid, "{FF6347}У вас не хватает Гелия 3\n\n{cccccc}1 Деталь бомбы = 50 Гелия"), SetPVarInt(playerid,"Arobsklad",0);
                if(watchslot < 0) return ErrorMessage(playerid, "{FF6347}У вас нет часов\n\n{cccccc}1 Деталь бомбы = 1 часы"), SetPVarInt(playerid,"Arobsklad",0);
            }	    
		    

   			if (GetPVarInt(playerid,"Arobsklad") == 16)
            {
                new put_inva = GiveThingPlayer(playerid, thingId, 1, 1, 0, 0, 0, 9999);
   			    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре"), SetPVarInt(playerid,"Arobsklad",0);
                TakeInvent(playerid, 6, 10, 0, 999); // Отнимаем Грибы свежие
                TakeInvent(playerid, 112, 1, 0, 999); // Отнимаем Водку 100 мл
                TakeInvent(playerid, 5, 1, 0, 999); // Отнимаем пустая таблетка
                ShowDialog(playerid, 1700, 0, "{ff9000}Стол для варки", "{cccccc}Отлично! {99ff66}Вы сварили таблетку!", "Ок", "");
            }
            else if (GetPVarInt(playerid,"Arobsklad") == 17)
            {
                if (get_ability(playerid, 8) < 5)
                {
                    switch(random(2))
                    {
                        case 0:
                        {
                            TakeInvent(playerid, 181, 3, 0, 999); // Отнимаем изоленту
                            TakeInvent(playerid, 60, 40, 0, 999); // Отнимаем паладий
                            TakeInvent(playerid, 61, 50, 0, 999); // Отнимаем гелий
                            i_del(playerid,watchslot); // Отнимаем часы
                            ErrorMessage(playerid, "{FF6347}У вас не получилось сделать бомбу"), SetPVarInt(playerid,"Arobsklad",0);
                        } 
                        case 1:
                        {
                            TakeInvent(playerid, 181, 3, 0, 999); // Отнимаем изоленту
                            TakeInvent(playerid, 60, 40, 0, 999); // Отнимаем паладий
                            TakeInvent(playerid, 61, 50, 0, 999); // Отнимаем гелий
                            i_del(playerid,watchslot); // Отнимаем часы
                            new put_inva = GiveThingPlayer(playerid, thingId, 1, 1, 0, 0, 0, 9999);
   			                if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре"), SetPVarInt(playerid,"Arobsklad",0);
                            SuccessMessage(playerid, "{FF6347}Вы изготовили деталь бомбы"), SetPVarInt(playerid,"Arobsklad",0);
                        }
                    }
                } 
                else 
                {
                    new put_inva = GiveThingPlayer(playerid, thingId, 1, 1, 0, 0, 0, 9999);
   			        if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре"), SetPVarInt(playerid,"Arobsklad",0);
                }
            }
		 	GameTextForPlayer(playerid," ", 3000, 3);
		 	PlayerPlaySound(playerid,6401,0,0,0);
		 	
		 	
		 	SetPVarInt(playerid,"Arobsklad",0);
		 	update_ability(playerid, 7, 10);
		 	/*if(PlayerInfo[playerid][pAchieve][86] == 0) AchievePlayer(playerid, 86, 1);
		 	if(PlayerInfo[playerid][pAchieve][101] == 0)
			{
			    new quan_eammo[4];
			    quan_eammo[0] = get_invent(playerid, 64, 0);
			    quan_eammo[1] = get_invent(playerid, 65, 0);
			    quan_eammo[2] = get_invent(playerid, 66, 0);
			    quan_eammo[3] = get_invent(playerid, 67, 0);
		 		if(quan_eammo[0]+quan_eammo[1]+quan_eammo[2]+quan_eammo[3] >= 100) AchievePlayer(playerid, 101, 1);
 			}*/
		}
	 	Aftextdraw[playerid] = current_tick;
 	}
 	return 1;
}

stock key_TrailerAttach(playerid) // Нажатие на CAPS LOCK
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        // Трейлеры
        new tid = GetPlayerTrailerID(playerid);
        if (tid < 0) return 0;

        new vehicleid = GetPlayerVehicleID(playerid);
        if (!vehicleid) return 0;

        new trailerid = GetVehicleTrailer(vehicleid);
        if (trailerid < 1) // Нет трейлера
        {
            if(IsPlayerInRangeOfPoint(playerid,8.0,-547.4172,-1018.2808,24.1529)) // Крепим в трейлерном парке
            {
                PlayerPlaySound(playerid,40405,0,0,0);
                ShowDialog(playerid,1337,DIALOG_STYLE_MSGBOX,"{ff9000}Трейлер","{cccccc}Вы уверены, что хотите {99ff66}прикрепить трейлер {cccccc}к автомобилю?","Да","Нет");
            }
            else // Крепим рядом с трейлером (Поиск своего трейлера воткнуть сюда)
            {
                if (trailerInfo[tid][tActive])
                {
                    if(IsPlayerInRangeOfPoint(playerid,15.0,trailerInfo[tid][tPic][0], trailerInfo[tid][tPic][1], trailerInfo[tid][tPic][2]))
                    {
                        PlayerPlaySound(playerid,40405,0,0,0);
                        ShowDialog(playerid,1337,DIALOG_STYLE_MSGBOX,"{ff9000}Трейлер","{cccccc}Вы уверены, что хотите {99ff66}прикрепить трейлер {cccccc}к автомобилю?","Да","Нет");
                    }
                }
            }
        }
        else // Есть трейлер
        {
            if (trailerInfo[tid][tAttached] != vehicleid) return 0;

            PlayerPlaySound(playerid,40405,0,0,0);
            ShowDialog(playerid,1336,DIALOG_STYLE_MSGBOX,"{ff9000}Трейлер","{cccccc}Вы уверены, что хотите {99ff66}установить трейлер {cccccc}в этой точке?","Да","Нет");
        }
    }
    return 1;
}

stock dialogCase_Trailer(playerid, dialogid, response)
{
	if(dialogid == 1336)
   	{
   	    if(response) cmd_trailer_place(playerid);
    }
    else if(dialogid == 1337)
   	{
   	    if(response) cmd_trailer_attach(playerid);
    }
    return 1;
}
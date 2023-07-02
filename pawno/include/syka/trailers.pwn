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
	Float: tPos[3], Float: tRot[3], // Позиция в игровом мире
	Text3D: t3DLabel, // Идентификатор 3д текста у входа
	tEnterPickup, // Идентификатор иконки домика
	tAttached, // ID транспорта, к которому прикреплен трейлер [0 - если не прикреплен]
	tObject, // ID установленного объекта (если он стоит в игровом мире)
	bool: tActive, // Статус существования в игровом мире
	bool: tLocked, // Статус дверей
	tTimerID // Хранит идентификатор таймера для сохранения прицепа
}
new trailerInfo[MAX_TRAILERS][e_TrailerInfo];

const TRAILER_VEHICLE_INTERIOR = 101; // Интерьер для трейлеров (для самого транспорта, чтобы он стал невидимым; а уже к нему будет приклепляться объект трейлера)

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

//    new query_string[40];
//    mysql_format(pearsq, query_string, sizeof query_string, "SELECT Name FROM pp_igroki WHERE id = %d", trailerInfo[id][tOwnerID]);
    format(store,sizeof(store),"SELECT * FROM pp_igroki WHERE id = '%d'", trailerInfo[id][tOwnerID]); // Грузим ID Аккаунта
    mysql_tquery(pearsq, store, "OnCreatePlayerTrailerPickup", "dfff", id, doorX, doorY, doorZ);
//    mysql_tquery(pearsq, query_string, "OnCreatePlayerTrailerPickup", "dfff", id, doorX, doorY, doorZ);

    // Сохранение позиции
    trailerInfo[id][tModel] = model;
    trailerInfo[id][tPos][0] = x, trailerInfo[id][tPos][1] = y, trailerInfo[id][tPos][2] = z;
    trailerInfo[id][tRot][0] = rx, trailerInfo[id][tRot][1] = ry, trailerInfo[id][tRot][2] = rz;
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
stock AttachTrailer(playerid, model, &vehicleid, &trailerid, &trailerobj)
{
    vehicleid = GetPlayerVehicleID(playerid);
    if (!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return false;
    
    // Создаем трейлер
    new Float: player_pos[4];
    GetVehiclePos(vehicleid, player_pos[0], player_pos[1], player_pos[2]);
    GetVehicleZAngle(vehicleid, player_pos[3]);
    GetXYInFrontOfPoint(player_pos[0], player_pos[1], player_pos[3], -3.5);

    trailerid = CreateVehicle(606, player_pos[0], player_pos[1], player_pos[2] - 10.0, 0, 0, 0, 10);
    SetVehicleVirtualWorld(trailerid, 100);
    LinkVehicleToInterior(trailerid, TRAILER_VEHICLE_INTERIOR);
    trailerobj = CreateDynamicObject(model, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);
    if (model == 3171) AttachDynamicObjectToVehicle(trailerobj, trailerid, -0.119, -1.900, -1.060, 0.000, 0.000, 178.698);
    else if (model == 3172) AttachDynamicObjectToVehicle(trailerobj, trailerid, -0.178, -3.511, -1.000, 0.000, 0.000, 177.901);
    else {
        DestroyObject(trailerobj);
        return false;
    }
    SetVehicleVirtualWorld(trailerid, 0);

    // Закрепляем трейлер за автомобилем
    SetTimerEx("AttachTrailerToVehicleDelay", 950, 0, "dd", trailerid, vehicleid);

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
            DestroyVehicle(trailerid);
            return KillTimer(trailerInfo[tid][tTimerID]);
        }

        // Если трейлер на грани уничтожения после того, как отцепился (Удаляем трейлер)
        new Float: health;
        GetVehicleHealth(trailerid, health);
        if (health < 400) {
            trailerInfo[tid][tAttached] = 0;
            DestroyVehicle(trailerid);
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
            DestroyDynamicObject(trailerInfo[tid][tObject]);
            DestroyVehicle(trailerid);
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

    static const fmt_str[] = "{ffffff} Отметить на карте\nДверь [ %s ]";
    new str[sizeof fmt_str - 2 + 8 + 7 + 1];
    format(str, sizeof str, fmt_str, 
        (trailerInfo[tid][tLocked] ? ("{ff3333}Закрыта") : ("{ffffff}Открыта"))
    );

    ShowDialog(playerid, 1330, DIALOG_STYLE_LIST,"Трейлер", str, "Ок", "Закрыть");

    return 1;
}

// Команда для прикрепления трейлера к своему автомобилю
// Срабатывает только в том случае, если игрок находится в пригодном для этого месте, либо рядом с уже существующим трейлером
CMD:trailer_attach(playerid)
{
    new tid = GetPlayerTrailerID(playerid);
    if (tid < 0) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: У меня вообще нет трейлера..");

    // Если трейлер уже размещен в игровом мире
    if (trailerInfo[tid][tActive]) {
        new Float: player_pos[3]; GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
        if (GetDistanceBetweenCoords3d(player_pos[0], player_pos[1], player_pos[2], trailerInfo[tid][tPos][0], trailerInfo[tid][tPos][1], trailerInfo[tid][tPos][2]) < 15.0) {
            UnloadPlacedTrailer(tid);
        } else return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Я должен подъехать к моему размещенному трейлеру, чтобы прицепить его");
    }

    // Удаляем трейлер, если он уже был прицеплен
    if (trailerInfo[tid][tAttached]) {
        new trailerid = GetVehicleTrailer(trailerInfo[tid][tAttached]);
        if (trailerid > 0) DestroyVehicle(trailerid);
        KillTimer(trailerInfo[tid][tTimerID]);
    }

    // Создаем трейлер, цепляя его к автомобилю
    new vehicleid, trailerid, trailerobj;
    if (!AttachTrailer(playerid, trailerInfo[tid][tModel], vehicleid, trailerid, trailerobj)) return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Я должен находиться за рулем транспортного средства, чтобы прицепить трейлер");
    trailerInfo[tid][tAttached] = vehicleid;
    trailerInfo[tid][tObject] = trailerobj;
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

        // Отсоединяем трейлер от автомобиля
        KillTimer(trailerInfo[tid][tTimerID]);

        // Размещаем объект трейлера в игровом мире
        new Float: trailer_pos[4];
        GetVehiclePos(trailerid, trailer_pos[0], trailer_pos[1], trailer_pos[2]);
        GetVehicleZAngle(trailerid, trailer_pos[3]);
        GetXYInFrontOfPoint(trailer_pos[0], trailer_pos[1], trailer_pos[3], -0.75); // чуть назад

        // [ Довольно плохо определяется позиция, относительно невидимого автомобиля, к которому приаттачен объект, в идеале бы поправить ]
        if (trailerInfo[tid][tModel] == 3171) PlaceTrailer(tid, trailerInfo[tid][tModel], trailer_pos[0] - 0.119, trailer_pos[1] - 1.900, trailer_pos[2] - 1.060, 0.0, 0.0, trailer_pos[3] + 178.698);
        else if (trailerInfo[tid][tModel] == 3172) PlaceTrailer(tid, trailerInfo[tid][tModel], trailer_pos[0] - 0.178, trailer_pos[1] - 3.511, trailer_pos[2] - 1.000, 0.0, 0.0, trailer_pos[3] + 177.901);
        
        DestroyVehicle(trailerid);
        SavePlayerTrailerInfo(tid);
    }

    return 1;
}

// Команда для добавления трейлера игроку
CMD:trailer_add(playerid, const params[]) {
    new targetid, model;
    if (sscanf(params, "ud", targetid, model)) {
        SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Выдать игроку трейлер: [ /trailer_add ID Model ]");
        SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Доступные типы: [3171] - Базовый | [3172] - Премиум");
        return 1;
    }
    new tid = GetPlayerTrailerID(targetid);
    if (tid > -1) {
        static const fmt_str[] = "[ Мысли ]: У этого игрока уже есть трейлер "COLOR_ORANGE_TEXT"[ №%d ]";
        new str[sizeof fmt_str - 2 + 5];
        format(str, sizeof str, fmt_str, trailerInfo[tid][tID]);
        SendClientMessage(playerid, COLOR_GRAY, str);
        return 1;
    }
    SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Трейлер выдан указанному игроку");
    
    AddPlayerTrailer(targetid, model);
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
		cache_get_value_name_bool(i, "active", trailerInfo[i][tActive]);
		cache_get_value_name_bool(i, "locked", trailerInfo[i][tLocked]);

		if (trailerInfo[i][tActive]) PlaceTrailer(i, trailerInfo[i][tModel], trailerInfo[i][tPos][0], trailerInfo[i][tPos][1], trailerInfo[i][tPos][2], trailerInfo[i][tRot][0], trailerInfo[i][tRot][1], trailerInfo[i][tRot][2]);
	}
    printf("[MODE]: Трейлеры [%d ms]",GetTickCount() - time);
	return 1;
}

forward OnCreatePlayerTrailerPickup(id, Float: x, Float: y, Float: z);
public OnCreatePlayerTrailerPickup(id, Float: x, Float: y, Float: z) {
	new owner_name[MAX_PLAYER_NAME + 1];
	cache_get_value_name(0, "Name", owner_name);
	static const label_fmt_str[] = "Трейлер "COLOR_ORANGE_TEXT"№%d\n"COLOR_WHITE_TEXT"Владелец: "COLOR_ORANGE_TEXT"%s";
    new label_str[sizeof label_fmt_str - 2 + 5 - 2 + MAX_PLAYER_NAME + 1];
    format(label_str, sizeof label_str, label_fmt_str,
        trailerInfo[id][tID],
        owner_name
    );
	
    trailerInfo[id][t3DLabel] = CreateDynamic3DTextLabel(label_str, 0xA9C4E4FF, x, y, z, 12.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    trailerInfo[id][tEnterPickup] = CreateDynamicPickup(1272, STREAMER_TYPE_OBJECT, x, y, z, 0, 0, .streamdistance = 100.0);
	Streamer_SetIntData(STREAMER_TYPE_PICKUP, trailerInfo[id][tEnterPickup], STREAMER_EXTRA_TYPE_TRAILER_ENTER, id + 1);
    printf("%d, %s",trailerInfo[id][tEnterPickup], owner_name);
	return 1;
}


stock SavePlayerTrailerInfo(id) {
    if (id < 0 || id > MAX_TRAILERS) return 0;

    static const fmt_str[] = "UPDATE trailers SET owner = %d, pos_x = %.4f, pos_y = %.4f, pos_z = %.4f, rot_x = %.4f, rot_y = %.4f, rot_z = %.4f, active = %d, locked = %d WHERE id = %d";
    new query_string[sizeof fmt_str - 2 + 9 - 2 + 7 - 2 + 9 - 4 * 6 + 10 * 6 - 2 + 1 - 2 + 1 - 2 + 5 + 1];
    mysql_format(pearsq, query_string, sizeof query_string, fmt_str,
        trailerInfo[id][tOwnerID],
        trailerInfo[id][tPos][0], trailerInfo[id][tPos][1], trailerInfo[id][tPos][2],
        trailerInfo[id][tRot][0], trailerInfo[id][tRot][1], trailerInfo[id][tRot][2],
        trailerInfo[id][tActive],
        trailerInfo[id][tLocked],
        trailerInfo[id][tID]
    );
    mysql_tquery(pearsq, query_string);
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
			if (trailerid > 0) DestroyVehicle(trailerid);
			else KillTimer(trailerInfo[tid][tTimerID]);
		}
	}
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
	new Float: vMultiplier = float(speed_mph) / float(cur_speed_mph);
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
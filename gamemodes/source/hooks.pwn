// Объекты
stock PP_DestroyDynamicObject(&STREAMER_TAG_OBJECT:objectid)
{
	new result = DestroyDynamicObject(objectid);
	// нам стоит здесь ставить в любом случае INVALID_STREAMER_ID, так как единственный сценарий
	// при котором бы DestroyDynamicObject вернул 0 -- это несуществующий динамический объект
	// то же самое относится и к остальным DestroyDynamic*
	objectid = STREAMER_TAG_OBJECT:INVALID_STREAMER_ID;
	return result;
}

#if defined _ALS_DestroyDynamicObject
    #undef DestroyDynamicObject
#else
    #define _ALS_DestroyDynamicObject
#endif
#define DestroyDynamicObject PP_DestroyDynamicObject


// Пикапы
stock PP_DestroyDynamicPickup(&STREAMER_TAG_PICKUP:pickupid)
{
	new result = DestroyDynamicPickup(pickupid);
	pickupid = STREAMER_TAG_PICKUP:INVALID_STREAMER_ID;
	return result;
}

#if defined _ALS_DestroyDynamicPickup
    #undef DestroyDynamicPickup
#else
    #define _ALS_DestroyDynamicPickup
#endif
#define DestroyDynamicPickup PP_DestroyDynamicPickup


// Чекпоинты
stock PP_DestroyDynamicCP(&STREAMER_TAG_CP:checkpointid)
{
	new result = DestroyDynamicCP(checkpointid);
	checkpointid = STREAMER_TAG_CP:INVALID_STREAMER_ID;
	return result;
}

#if defined _ALS_DestroyDynamicCP
    #undef DestroyDynamicCP
#else
    #define _ALS_DestroyDynamicCP
#endif
#define DestroyDynamicCP PP_DestroyDynamicCP


// Гоночные чекпоинты
stock PP_DestroyDynamicRaceCP(&STREAMER_TAG_RACE_CP:checkpointid)
{
	new result = DestroyDynamicRaceCP(checkpointid);
	checkpointid = STREAMER_TAG_RACE_CP:INVALID_STREAMER_ID;
	return result;
}

#if defined _ALS_DestroyDynamicRaceCP
    #undef DestroyDynamicRaceCP
#else
    #define _ALS_DestroyDynamicRaceCP
#endif
#define DestroyDynamicRaceCP PP_DestroyDynamicRaceCP


// Иконки на карте
stock PP_DestroyDynamicMapIcon(&STREAMER_TAG_MAP_ICON:iconid)
{
	new result = DestroyDynamicMapIcon(iconid);
	iconid = STREAMER_TAG_MAP_ICON:INVALID_STREAMER_ID;
	return result;
}

#if defined _ALS_DestroyDynamicMapIcon
    #undef DestroyDynamicMapIcon
#else
    #define _ALS_DestroyDynamicMapIcon
#endif
#define DestroyDynamicMapIcon PP_DestroyDynamicMapIcon


// 3Д тексты
stock PP_DestroyDynamic3DTextLabel(&STREAMER_TAG_3D_TEXT_LABEL:id)
{
	new result = DestroyDynamic3DTextLabel(id);
	id = STREAMER_TAG_3D_TEXT_LABEL:INVALID_STREAMER_ID;
	return result;
}

#if defined _ALS_DestroyDynamic3DTextLabel
    #undef DestroyDynamic3DTextLabel
#else
    #define _ALS_DestroyDynamic3DTextLabel
#endif
#define DestroyDynamic3DTextLabel PP_DestroyDynamic3DTextLabel


// Динамические зоны
stock PP_DestroyDynamicArea(&STREAMER_TAG_AREA:areaid)
{
	new result = DestroyDynamicArea(areaid);
	areaid = STREAMER_TAG_AREA:INVALID_STREAMER_ID;
	return result;
}

#if defined _ALS_DestroyDynamicArea
    #undef DestroyDynamicArea
#else
    #define _ALS_DestroyDynamicArea
#endif
#define DestroyDynamicArea PP_DestroyDynamicArea


// Актёры
stock PP_DestroyDynamicActor(&STREAMER_TAG_ACTOR:actorid)
{
	new result = DestroyDynamicActor(actorid);
	actorid = STREAMER_TAG_ACTOR:INVALID_STREAMER_ID;
	return result;
}

#if defined _ALS_DestroyDynamicActor
    #undef DestroyDynamicActor
#else
    #define _ALS_DestroyDynamicActor
#endif
#define DestroyDynamicActor PP_DestroyDynamicActor
// ------------------------------------------------------

// Закрываем диалоговое окно (Перехват функции)
stock PPHidePlayerDialog(playerid)
{
	OnlineInfo[playerid][oDialogID] = -1;
	OnlineInfo[playerid][oDialogClosed] = true;
	
	HidePlayerDialog(playerid);
	return true;
}

#if defined _ALS_HidePlayerDialog
    #undef HidePlayerDialog
#else
    #define _ALS_HidePlayerDialog
#endif
#define HidePlayerDialog PPHidePlayerDialog


// Аттач транспорта к транспорту (Перехват функции)
stock PPAttachTrailerToVehicle(trailerid, vehicleid)
{
	VehInfo[vehicleid][vAttachTrailer] = trailerid;
	AttachTrailerToVehicle(trailerid, vehicleid);
	return true;
}

#if defined _ALS_AttachTrailerToVehicle
    #undef AttachTrailerToVehicle
#else
    #define _ALS_AttachTrailerToVehicle
#endif
#define AttachTrailerToVehicle PPAttachTrailerToVehicle

stock __HOOK_SetPlayerSkin(playerid, skinid) {
	new result = SetPlayerSkin(playerid, skinid);
	TogglePlayerControllable(playerid, true);
	return result;
}

#if defined _ALS_SetPlayerSkin
	#undef SetPlayerSkin
#else
	#define _ALS_SetPlayerSkin
#endif
#define SetPlayerSkin __HOOK_SetPlayerSkin

stock __HOOK_ApplyAnimation(playerid, const animationLibrary[], const animationName[], Float: delta, bool: loop, bool: lockX, bool: lockY, bool: freeze, time, FORCE_SYNC: forceSync = SYNC_NONE) {
	if (GetPVarInt(playerid, "Follow_Run")) return 0; // Не ставим анимацию, если игрока ведут за собой
	return ApplyAnimation(playerid, animationLibrary, animationName, delta, loop, lockX, lockY, freeze, time, forceSync);
}

#if defined _ALS_ApplyAnimation
	#undef ApplyAnimation
#else
	#define _ALS_ApplyAnimation
#endif
#define ApplyAnimation __HOOK_ApplyAnimation

stock __HOOK_SetVehicleNumberPlate(vehicleid, const numberplate[]) {
	// Сохраняем состояние автомобиля
	new t_VEHICLE_PANEL_STATUS:_panels, t_VEHICLE_DOOR_STATUS:_doors, t_VEHICLE_LIGHT_STATUS:_lights, t_VEHICLE_TYRE_STATUS:_tires;
	GetVehicleDamageStatus(vehicleid, _panels, _doors, _lights, _tires);
	new Float: health;
	GetVehicleHealth(vehicleid, health);

	SetVehicleNumberPlate(vehicleid, numberplate);

	// Возвращаем состояние автомобиля после изменения номеров
	SetVehicleHealth(vehicleid, health);
	UpdateVehicleDamageStatus(vehicleid, _panels, _doors, _lights, _tires);

	return 1;
}

#if defined _ALS_SetVehicleNumberPlate
	#undef SetVehicleNumberPlate
#else
	#define _ALS_SetVehicleNumberPlate
#endif
#define SetVehicleNumberPlate __HOOK_SetVehicleNumberPlate

/*
	Возможность воспроизведения звука с заглушением всех остальных
	* При soundid = 0 или указанном аргументе muteseconds - заглушение звуков игнорируется
*/
new MuteSoundPlayers[MAX_REALPLAYERS];
stock __HOOK_PlayerPlaySound(playerid, soundid, Float: x = 0.0, Float: y = 0.0, Float: z = 0.0, muteseconds = 0)
{
	new result = PlayerPlaySound(playerid, soundid, x, y, z);

	if (result)
	{
		if (soundid == 0 || muteseconds > 0) MuteSoundPlayers[playerid] = 0;
		
		if (gettime() - MuteSoundPlayers[playerid] < 0) return 0;

		if (muteseconds > 0) {
			MuteSoundPlayers[playerid] = gettime() + muteseconds;
		}
	}

	return result;
}

#if defined _ALS_PlayerPlaySound
	#undef PlayerPlaySound
#else
	#define _ALS_PlayerPlaySound
#endif
#define PlayerPlaySound __HOOK_PlayerPlaySound
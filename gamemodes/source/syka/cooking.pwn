// Информация о каждой модели объекта, на который можно готовить
static enum e_pressCookObjects {
	soModel, //  Модель
};
static const pressCookObjects[][e_pressCookObjects] = {
	{2294},
	{2135},
  {19915},
  {2144},
  {19933},

  // Custom
  {12225}
};

stock GetDynamicObjectCookPosition(objectid) {
	if (!IsValidDynamicObject(objectid)) return false;
	new model = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);
	for (new i = 0; i < sizeof pressCookObjects; i++) {
		new curmodel = _:pressCookObjects[i][soModel];
		if (model == curmodel) {
			return true;
		}
	}
	return false;
}

// Узнаём, что нужный нам dynamic object, это верстак
stock GetDynamicObjectWorkbench(objectid) 
{
	if (!IsValidDynamicObject(objectid)) return false;
	new model = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);
    if(model == 12173 || model == 12292) return true;
	return false;
}

stock GetDynamicObjectToilet(objectid) 
{
	if (!IsValidDynamicObject(objectid)) return false;
	new model = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);
    if(model == 2528 || model == 2738 || model == 2514 || model == 2521 || model == 2525) return true;
	return false;
}

stock GetDynamicObjectSink(objectid) 
{
	if (!IsValidDynamicObject(objectid)) return false;
	new model = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);
    if(model == 2524 || model == 2515 || model == 2136 || model == 2132 || model == 2130) return true;
	return false;
}

stock GetDynamicObjectElectro(objectid) 
{
	if (!IsValidDynamicObject(objectid)) return false;
	new model = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);
    if(model == 12299) return true;
	return false;
}

// Узнаём, что нужный нам dynamic object, это холодильник
stock GetDynamicObjectFridge(objectid) 
{
	if (!IsValidDynamicObject(objectid)) return false;
	new model = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);
    if(model == 19916 || model == 12228 || model == 12204 || model == 2140 || model == 2127) return true;
	return false;
}

stock IsANearbyObject(playerid) // Ищем предметы рядом с игроком
{
    if(GetPlayerVirtualWorld(playerid) == 192 && GetPlayerInterior(playerid) == 192
	|| GetPlayerVirtualWorld(playerid) == 193 && GetPlayerInterior(playerid) == 193
	|| GetPlayerVirtualWorld(playerid) == 194 && GetPlayerInterior(playerid) == 194) return 0; // Ikea блокируем взаимодействие
    new Float: player_pos[3];
    GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);

    // Получаем ближайшие к игроку динамические объекты
    new objects[5];
    // Функция Streamer_GetAllVisibleItems возвращает количество динамических элементов, которые находятся в зоне стрима игрока и помещает их ID в массив (objects)
    // Но это количество не учитывает то, что в массиве может не хватить для них места, поэтому я использую макрос min, который вернёт 3 (sizeof objects), если количество объектов больше
    new objects_count = min(Streamer_GetAllVisibleItems(playerid, STREAMER_TYPE_OBJECT, objects), sizeof objects);
    for(new i = 0; i < objects_count; i++) 
    {
        // Перебираем каждый объект
        new current_object = objects[i];

        // Функция Streamer_GetAllVisibleItems возвращает уже отсортированный по дистанции список, т.е. если один из объектов при последовательном прохождении
        // цикла находится дальше, чем требуется - то все остальные объекты тоже, поэтому можно не пропускать один объект, а прервать цикл вовсе 
        new Float: distance;
        Streamer_GetDistanceToItem(player_pos[0], player_pos[1], player_pos[2], STREAMER_TYPE_OBJECT, current_object, distance);
        if(distance > 1.50) break;

        if(GetDynamicObjectCookPosition(current_object)) return 1; // Кухонная Плита
        if(GetDynamicObjectWorkbench(current_object)) return 2; // Верстак
        if(GetDynamicObjectFridge(current_object)) return 3; // Холодильник
        if(GetDynamicObjectElectro(current_object)) return 4; // Электрощиток
        if(GetDynamicObjectToilet(current_object))
        {
            new Float:x, Float:y, Float:z;
            GetDynamicObjectPos(current_object, x, y, z);
            new Float:a = atan2(player_pos[1] - y, player_pos[0]-x) + 90.0; // Направляем игрока на объект.
            PPSetPlayerFacingAngle(playerid, a);
            return 5; 
        }// Туалет
        if(GetDynamicObjectSink(current_object))
        {
            new Float:x, Float:y, Float:z;
            GetDynamicObjectPos(current_object, x, y, z);
            new Float:a = atan2(player_pos[1] - y, player_pos[0]-x) + 90.0; // Направляем игрока на объект.
            PPSetPlayerFacingAngle(playerid, a);
            return 6; 
        }// Раковина
    }
    return 0;
}

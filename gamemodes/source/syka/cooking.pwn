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
    if(model == 12173) return true;
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
    if(model == 19916 || model == 12228 || model == 12204 || model == 2140) return true;
	return false;
}

stock IsANearbyObject(playerid) // Ищем предметы рядом с игроком
{
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

        if(GetDynamicObjectCookPosition(current_object)) return 1; // 0 Кухонная Плита
        if(GetDynamicObjectWorkbench(current_object)) return 2; // 1 Верстак
        if(GetDynamicObjectFridge(current_object)) return 3; // 2 Холодос
        if(GetDynamicObjectElectro(current_object)) return 4; // 3 Щиток для электричества
    }
    return 0;
}

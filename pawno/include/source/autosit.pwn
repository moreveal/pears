
// ѕереносит координаты на указанную дистанцию и направление от указанной точки
stock GetXYInFrontOfPoint(&Float:x, &Float:y, Float:angle, Float:dist) {
    x += (dist * floatsin(-angle, degrees));
    y += (dist * floatcos(-angle, degrees));
	return 1;
}

// »нформаци¤ о каждой модели объекта, на который можно садитьс¤
static enum e_pressSeatObjects {
	soModel, // ћодель
	Float: soBaseZ, // Ѕазовое вращение по Z (что возвращает GetPlayerFacingAngle если смотреть в ту сторону, куда смотрит объект, при указанном вращении 0.0)
	Float: soFrontDistance, // ƒистанци¤, на которую перемещаетс¤ игрок вперЄд от объекта (определ¤етс¤ опытным путем, начать стоит с ~0.6)
	Float: soSideDistance, // ƒистанци¤, на которую игрок передвигаетс¤ вбок, относительно объекта (почти всегда 0.0)
	Float: soUpDistance // ƒистанци¤, на которую игрок передвигаетс¤ в высоту, относительно объекта (почти всегда 0.0) 
};
static const pressSeatObjects[][e_pressSeatObjects] = {
	{1663, -180.0, 0.65, 0.0, -0.15},
	{1671, -180.0, 0.6, 0.0, 0.0},
	{19994, -180.0, 0.6, 0.0, 0.0},
	{1721, 0.0, 0.7, 0.0, 0.0},
	{1722, 0.0, 0.7, 0.0, 0.0},
	{2356, 0.0, 0.55, 0.0, 0.0},
	{1714, -180.0, 0.7, 0.0, 0.0},
	{1715, -180.0, 0.7, 0.0, 0.0},
	{19999, -180.0, 0.6, 0.0, 0.0},
	{1810, -180.0, 0.35, 0.22, 0.4550},
	{19996, -180.0, 0.6, 0.0, -0.2},
	{2121, -180.0, 0.6, 0.0, 0.0},
	{1720, -180.0, 0.48, 0.0, -0.2},
	{2122, 90.0, 0.6, 0.0, 0.0},
	{2293, 0.0, 0.6, 0.0, 0.0},
	{2310, 90.0, 0.6, 0.0, 0.0},
	{2776, -180.0, 0.6, 0.0, 0.0},
	{2777, -180.0, 0.6, 0.0, 0.0},
	{2309, 0.0, 0.65, 0.0, 0.0},
	{2096, -180.0, 0.45, 0.0, -0.2},
	{2788, 90.0, 0.6, 0.0, -0.15},
	{2807, 90.0, 0.6, 0.0, -0.15},
	{1729, -180.0, 0.6, 0.0, -0.2},
	{2079, 90.0, 0.6, 0.0, 0.0},
	{1746, 0.0, 0.6, 0.0, -0.2},
	{2123, 90.0, 0.6, 0.0, 0.0},
	{2120, 90.0, 0.6, 0.0, 0.0},
	{2636, 90.0, 0.55, 0.0, 0.0},
	{1811, 90.0, 0.6, 0.0, 0.05},
	{1711, -180.0, 0.6, -0.2, -0.2},
	{2724, -180.0, 0.6, 0.0, -0.03},
	{11734, -180.0, 0.6, 0.0, 0.0},
	{1735, -180.0, 0.6, 0.0, 0.0},
	{2124, 90.0, 0.6, 0.0, 0.35},
	{2343, -90.0, 0.6, 0.0, 0.0},
	{11685, -180.0, 0.6, 0.0, 0.0},
	{1739, 90.0, 0.6, 0.0, 0.0},
	{11684, -90.0, 0.6, 0.0, -0.05},
	{1705, -180.0, 0.7, -0.5, -0.3},
	{1704, -180.0, 0.7, -0.5, -0.3},
	{1724, -180.0, 0.7, -0.5, -0.3},
	{1727, -180.0, 0.7, -0.5, -0.3},
	{1708, -180.0, 0.7, -0.5, -0.3},
	{2748, -180.0, 0.7, 0.0, -0.5},
	{11683, -180.0, 0.7, 0.0, -0.25},
	{11682, 90.0, 0.65, 0.0, -0.2},
	{1562, -180.0, 0.65, 0.0, -0.33}
};

// ќпредел¤ет, относитс¤ ли модель к тому объекту, на котором можно сидеть по нажатию клавиши
stock IsPressSeatDynamicObject(modelid) {
	for (new i = 0; i < sizeof pressSeatObjects; i++) {
		if (pressSeatObjects[i][soModel] == modelid)
			return true;
	}
	return false;
}

stock GetDynamicObjectSeatPosition(objectid, &Float: x, &Float: y, &Float: z, &Float: a) {
	if (!IsValidDynamicObject(objectid)) return false;

	new model = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);
	for (new i = 0; i < sizeof pressSeatObjects; i++) {
		new curmodel = _:pressSeatObjects[i][soModel];

		if (model == curmodel) {
			new Float: object_pos[4];
			GetDynamicObjectPos(objectid, object_pos[0], object_pos[1], object_pos[2]);
			Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_Z, object_pos[3]);
			
			// ¬ычисл¤ем нужную позицию
			new Float: pos[4];
			pos[0] = object_pos[0], pos[1] = object_pos[1];

			GetXYInFrontOfPoint(pos[0], pos[1], object_pos[3] - 90.0, -pressSeatObjects[i][soSideDistance]); // X, Y
			pos[2] = object_pos[2] + pressSeatObjects[i][soUpDistance]; // Z
			pos[3] = pressSeatObjects[i][soBaseZ] + object_pos[3]; // Angle

			GetXYInFrontOfPoint(pos[0], pos[1], pos[3], pressSeatObjects[i][soFrontDistance]);

			// «аполн¤ем переданные параметры
			x = pos[0];
			y = pos[1];
			z = pos[2];
			a = pos[3];

			return true;
		}
	}

	return false;
}

stock PressSeatableObjectSeatHandler(playerid) {
  // Получаем три ближайших к игроку динамических объекта
  new Float: player_pos[3];
  GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
  new objects[3];
  // Функция Streamer_GetAllVisibleItems возвращает количество динамических элементов, которые находятся в зоне стрима игрока и помещает их ID в массив (objects)
  // Но это количество не учитывает то, что в массиве может не хватить для них места, поэтому я использую макрос min, который вернёт 3 (sizeof objects), если количество объектов больше
  new objects_count = min(Streamer_GetAllVisibleItems(playerid, STREAMER_TYPE_OBJECT, objects), sizeof objects);
  for (new i = 0; i < objects_count; i++) {
    // Перебираем каждый объект
    new current_object = objects[i];

    /* Функция Streamer_GetAllVisibleItems возвращает уже отсортированный по дистанции список, т.е. если один из объектов при последовательном прохождении
    цикла находится дальше, чем требуется - то все остальные объекты тоже, поэтому можно не пропускать один объект, а прервать цикл вовсе */
    new Float: distance;
    Streamer_GetDistanceToItem(player_pos[0], player_pos[1], player_pos[2], STREAMER_TYPE_OBJECT, current_object, distance);
    if (distance > 1.75) break;

    // Установка нужной позиции и анимации игроку (если объект является стулом)
    new Float: x, Float: y, Float: z, Float: a;
    new result = GetDynamicObjectSeatPosition(current_object, x, y, z, a);
    if (result) {
      // Если модель объекта найдена и позиция определена - помещаем игрока на неё
      PPSetPlayerPos(playerid, x, y, player_pos[2]);
      SetPlayerFacingAngle(playerid, a);
      ApplyAnimation(playerid, "PED", "SEAT_down", 4.0, 0, 0, 0, 1, 1, 1);
    }
    break;
  }
}


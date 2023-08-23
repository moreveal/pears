// Информация о каждой модели объекта, на который можно готовить
static enum e_pressCookObjects {
	soModel, //  Модель
};
static const pressCookObjects[][e_pressCookObjects] = {
	{2294},
	{2135}
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

stock PressCookObjectHandler(playerid) 
{
  // В Ikea отключено срабатывание присаживания
  if(GetPlayerVirtualWorld(playerid) == 192 && GetPlayerInterior(playerid) == 192
  || GetPlayerVirtualWorld(playerid) == 193 && GetPlayerInterior(playerid) == 193
  || GetPlayerVirtualWorld(playerid) == 194 && GetPlayerInterior(playerid) == 194) return 0;
  
  new Float: player_pos[3];
  GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
  new pickups[1];
  new pickups_count = min(Streamer_GetAllVisibleItems(playerid, STREAMER_TYPE_PICKUP, pickups), sizeof pickups);
  for (new i = 0; i < pickups_count; i++) {
    new Float: distance;
   	Streamer_GetDistanceToItem(player_pos[0], player_pos[1], player_pos[2], STREAMER_TYPE_PICKUP, pickups[i], distance);
    
    // Если рядом есть пикап - прекращаем обработку
    if (distance >= 2.05) {
		break;
		} else return 1;
  }
  // Получаем ближайшие к игроку динамические объекты
  new objects[5];
  // Функция Streamer_GetAllVisibleItems возвращает количество динамических элементов, которые находятся в зоне стрима игрока и помещает их ID в массив (objects)
  // Но это количество не учитывает то, что в массиве может не хватить для них места, поэтому я использую макрос min, который вернёт 3 (sizeof objects), если количество объектов больше
  new objects_count = min(Streamer_GetAllVisibleItems(playerid, STREAMER_TYPE_OBJECT, objects), sizeof objects);
  for (new i = 0; i < objects_count; i++) 
  {
    // Перебираем каждый объект
    new current_object = objects[i];

    // Функция Streamer_GetAllVisibleItems возвращает уже отсортированный по дистанции список, т.е. если один из объектов при последовательном прохождении
   // цикла находится дальше, чем требуется - то все остальные объекты тоже, поэтому можно не пропускать один объект, а прервать цикл вовсе 
    new Float: distance;
    Streamer_GetDistanceToItem(player_pos[0], player_pos[1], player_pos[2], STREAMER_TYPE_OBJECT, current_object, distance);
    if (distance > 1.50) break;
    new result = GetDynamicObjectCookPosition(current_object);
    if (result) 
    {
      if(!howstun(playerid))
      {
        if(Piss[playerid] >= 1 || Hold[playerid] >= 1 || Piss[playerid] == 7 || Dei[playerid] > 0 || OnlineInfo[playerid][oInHandThing][0] > 0 || GetPlayerWeapon(playerid) >= 2) return ErrorMessage(playerid, "{FF6347}У вас заняты руки или выполняется действие [Предмет или оружие]");
        format(lines,sizeof(lines),""); // Очищаем Lines
        format(line,sizeof(line),"{ff9000}Пицца\n"), strcat(lines,line);
        format(line,sizeof(line),"{ff9000}Апельсиновый сок\n"), strcat(lines,line);
        format(line,sizeof(line),"{ff9000}Яблочный сок\n"), strcat(lines,line);
        ShowDialog(playerid,1393,DIALOG_STYLE_LIST,"{ff9000}Плита",lines,"Выбор","Отмена");
      }
      break;
    }
  }
  return 1;
}


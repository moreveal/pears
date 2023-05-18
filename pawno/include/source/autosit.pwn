// Переносит координаты на указанную дистанцию и направление от указанной точки
stock GetXYInFrontOfPoint(&Float:x, &Float:y, Float:angle, Float:dist) {
    x += (dist * floatsin(-angle, degrees));
    y += (dist * floatcos(-angle, degrees));
	return 1;
}

// Информация о каждой модели объекта, на который можно садиться
static enum e_pressSeatObjects {
	soModel, // Модель
	Float: soBaseZ, // Базовое вращение по Z (что возвращает GetPlayerFacingAngle если смотреть в ту сторону, куда смотрит объект, при указанном вращении 0.0)
	Float: soFrontDistance, // Дистанция, на которую перемещается игрок вперЄд от объекта (определяется опытным путем, начать стоит с ~0.6)
	Float: soSideDistance, // Дистанция, на которую игрок передвигается вбок, относительно объекта (почти всегда 0.0)
	Float: soUpDistance // Дистанция, на которую игрок передвигается в высоту, относительно объекта (почти всегда 0.0) 
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
	{1562, -180.0, 0.65, 0.0, -0.33},
	{1806, 0.0, 0.6, 0.04, 0.0}
};

new bool:playerSeat[MAX_REALPLAYERS];

// Определяет, относится ли модель к тому объекту, на котором можно сидеть по нажатию клавиши
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
			
			// Вычисляем нужную позицию
			new Float: pos[4];
			pos[0] = object_pos[0], pos[1] = object_pos[1];

			GetXYInFrontOfPoint(pos[0], pos[1], object_pos[3] - 90.0, -pressSeatObjects[i][soSideDistance]); // X, Y
			pos[2] = object_pos[2] + pressSeatObjects[i][soUpDistance]; // Z
			pos[3] = pressSeatObjects[i][soBaseZ] + object_pos[3]; // Angle

			GetXYInFrontOfPoint(pos[0], pos[1], pos[3], pressSeatObjects[i][soFrontDistance]);

			// Заполняем переданные параметры
			x = pos[0];
			y = pos[1];
			z = pos[2];
			a = pos[3];

			return true;
		}
	}

	return false;
}

stock PressSeatableObjectHandler(playerid) 
{

  // В Ikea отключено срабатывание присаживания на стул (Чтобы на ALT их можно было купить, а не садиться на них)
  if(GetPlayerVirtualWorld(playerid) == 192 && GetPlayerInterior(playerid) == 192
  || GetPlayerVirtualWorld(playerid) == 193 && GetPlayerInterior(playerid) == 193
  || GetPlayerVirtualWorld(playerid) == 194 && GetPlayerInterior(playerid) == 194) return 0;

  new Float: player_pos[3];
  GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);

  // Узнаем есть ли рядом пикапы и отменяем посадку, если да (чтобы не было конфликтов со входами и т.п.)
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
  for (new i = 0; i < objects_count; i++) {
    // Перебираем каждый объект
    new current_object = objects[i];

    // Функция Streamer_GetAllVisibleItems возвращает уже отсортированный по дистанции список, т.е. если один из объектов при последовательном прохождении
   // цикла находится дальше, чем требуется - то все остальные объекты тоже, поэтому можно не пропускать один объект, а прервать цикл вовсе 
    new Float: distance;
    Streamer_GetDistanceToItem(player_pos[0], player_pos[1], player_pos[2], STREAMER_TYPE_OBJECT, current_object, distance);
    if (distance > 2.50) break;

    // Установка нужной позиции и анимации игроку (если объект является стулом)
    new Float: x, Float: y, Float: z, Float: a;
    new result = GetDynamicObjectSeatPosition(current_object, x, y, z, a);
    if (result) {
      // Если модель объекта найдена и позиция определена - помещаем игрока на неё
	  if(Hold[playerid] == 12) return ErrorMessage(playerid, "{FF6347}У вас в руках поднос [ Положите его на стол F ]");
	  new status = sit(playerid);
	  if(status > 0)
	  {
		playerSeat[playerid] = true;
      	PPSetPlayerPos(playerid, x, y, player_pos[2]);
      	SetPlayerFacingAngle(playerid, a);
	  	sit_Active(playerid, x, y, player_pos[2], a);
		break;
	  }
    }
  }
  return 1;
}

/*stock PressSeatableObjectHandler(playerid) {
	new Float: player_pos[3];
	GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);

	// Узнаем есть ли рядом пикапы и отменяем посадку, если да (чтобы не было конфликтов со входами и т.п.)
	new pickups[1];
	new pickups_count = min(Streamer_GetAllVisibleItems(playerid, STREAMER_TYPE_PICKUP, pickups), sizeof pickups);
	for (new i = 0; i < pickups_count; i++) {
		new Float: distance;
		Streamer_GetDistanceToItem(player_pos[0], player_pos[1], player_pos[2], STREAMER_TYPE_PICKUP, pickups[i], distance);
		
		// Если рядом есть пикап - прекращаем обработку
		if (distance >= 2.05) break; else return;
	}
	// Получаем три ближайших к игроку динамических объекта
	new objects[5];
	// Функция Streamer_GetAllVisibleItems возвращает количество динамических элементов, которые находятся в зоне стрима игрока и помещает их ID в массив (objects)
	// Но это количество не учитывает то, что в массиве может не хватить для них места, поэтому я использую макрос min, который вернёт 3 (sizeof objects), если количество объектов больше
	new objects_count = min(Streamer_GetAllVisibleItems(playerid, STREAMER_TYPE_OBJECT, objects), sizeof objects);
	for (new i = 0; i < objects_count; i++) {
		// Перебираем каждый объект
		new current_object = objects[i];

		// Установка нужной позиции и анимации игроку (если объект является стулом)
		new Float: x, Float: y, Float: z, Float: a;
		new result = GetDynamicObjectSeatPosition(current_object, x, y, z, a);
		if (result) {
			// Функция Streamer_GetAllVisibleItems возвращает уже отсортированный по дистанции список, т.е. если один из объектов при последовательном прохождении
			//цикла находится дальше, чем требуется - то все остальные объекты тоже, поэтому можно не пропускать один объект, а прервать цикл вовсе 
			if (GetPlayerDistanceFromPoint(playerid, x, y, z) > 1.25) break;

			// Помещаем игрока на стул
			SetPlayerPos(playerid, x, y, player_pos[2]);
			SetPlayerFacingAngle(playerid, a);
			ApplyAnimation(playerid, "PED", "SEAT_down", 4.0, 0, 0, 0, 1, 1, 1);
			break;
		}
	}
}*/

stock sit_Active(playerid, Float:x, Float:y, Float:z, Float:a)
{
	SetPVarInt(playerid, "antifsit", 3);
	Job_X[playerid] = x, Job_Y[playerid] = y, Job_Z[playerid] = z, Job_A[playerid] = a;
	NoAnim[playerid] = 1;
	ApplyAnimation(playerid,"PED","SEAT_down",4.0,0,0,0,1,0,1);
	SetTimerEx("sitload", 1500, 0, "d", playerid);
	return 1;
}

stock sit(playerid)
{
	new status = 1;
	if(SitPlayer[playerid] == 0 && HealthAC[playerid] >= 1 && Stun[0][playerid] == 0 && Stun[2][playerid] == 0 && Stun[3][playerid] == 0 && !IsPlayerInAnyVehicle(playerid)
	&& GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		if(GetPVarInt(playerid, "antifsit") > 0) return 0;
		new sitid = 0, mw = GetPlayerVirtualWorld(playerid), mi = GetPlayerInterior(playerid);
		for(new s = 0; s < sizeof(SitPos); ++s)
		{
			if(IsPlayerInRangeOfPoint(playerid,0.7, SitPos[s][SitPos_X], SitPos[s][SitPos_Y], SitPos[s][SitPos_Z])
			&& (SitPos[s][SitWorld] >= 0 && mw == SitPos[s][SitWorld] || SitPos[s][SitWorld] <= -1)
			&& (SitPos[s][SitInt] >= 0 && mi == SitPos[s][SitInt] || SitPos[s][SitInt] <= -1) && SitID[s] == 0)
			{
				sitid = s+1;
				break;
			}
		}
		if(sitid > 0)
		{
			new sid = sitid-1, kassit, minussid;
			
			// Стулья в комнате казино для игры в карты
			if(sid >= 18 && sid <= 23) kassit = 1, minussid = 18;
			else if(sid >= 24 && sid <= 29) kassit = 2, minussid = 24;
			else if(sid >= 30 && sid <= 35) kassit = 3, minussid = 30;
			else if(sid >= 36 && sid <= 41) kassit = 4, minussid = 36;
			else if(sid >= 42 && sid <= 47) kassit = 5, minussid = 42;
			else if(sid >= 48 && sid <= 53) kassit = 6, minussid = 48;
			else if(sid >= 54 && sid <= 59) kassit = 7, minussid = 54;
			else if(sid >= 60 && sid <= 65) kassit = 8, minussid = 60;
			else if(sid >= 66 && sid <= 71) kassit = 9, minussid = 66;
			else if(sid >= 72 && sid <= 75) kassit = 10, minussid = 72;
			if(kassit > 0)
			{
				if(DeskInfo[kassit-1][Table] == 1) return ErrorMessage(playerid, "{FF6347}Стол закрыт лидером"), status = -1;
				if(setting_pos_draw[playerid] > 0 || setting_size_draw[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Завершите редактирование текстдравов"), status = -1;
			}

			// Дойка Коров
			if(sid >= 0 && sid <= 17)
			{
				if(Dei[playerid] == 13)
				{
					RemovePlayerAttachedObject(playerid, 1);
					SetPlayerAttachedObject(playerid, 1, 19468, 1, -0.496000, 1.380000, 0.000000, 3.999999, 88.799995, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
					if(DeiStat[playerid] < 20)
					{
						format(store,sizeof(store),"{ffcc66}Доить корову: {ff9000}%s", buttonName[Device[playerid]]);
						ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}•",store,"•","");
						DeiStat[playerid] = 0;
					}
				}
				else return ErrorMessage(playerid, "{FF6347}Возьмите ведро у входа в сарай"), status = -1;
			}
			// Образовательный Центр
			if(sid >= 78 && sid <= 101)
			{
				LessonQuest[playerid] = 0;
				if(Lesson[playerid] == 0)
				{
					SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мне нужно взять нужный учебник из инвентаря, чтобы начать обучение");
					ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}•","{ffcc66}Откройте инвентарь и кликните два раза по нужному учебнику, чтобы начать обучение\n\n{cccccc}Если у вас нет учебника - возьмите его в библиотеке","•","");
				}
				else ShowDialog(playerid,1227,DIALOG_STYLE_MSGBOX,"{ff9000}Образовательный Центр","\n{ff9000}Вы уверены, что хотите начать экзамен?\n","Да","Нет");
			}

			SitID[sid] = playerid+1;
			SitPlayer[playerid] = sitid;

			// Стулья в комнате казино для игры в карты
			if(kassit > 0) join_player_desk(playerid, kassit-1, sid-minussid);

			if(readsit == 1) SendClientMessagef(playerid, COLOR_GREY, "%d", sid);
		}
		TextDrawShowForPlayer(playerid, MindDraw[3]), PlayerTextDrawSetString(playerid, HintButton, "ENTER"), PlayerTextDrawShow(playerid, HintButton);

	}
	return status;
}
stock exitsit(playerid, stat)
{
	if(SitPlayer[playerid] >= 1 || playerSeat[playerid])
	{
		if(playerSeat[playerid]) playerSeat[playerid] = false;
		NoAnim[playerid] = 0;
	    if(stat == 1) ApplyAnimation(playerid,"PED","SEAT_up",4.0,0,0,0,0,0,1);
	    if(stat == 2) ClearAnimations(playerid);

		if(SitPlayer[playerid] >= 1)
		{
			new sitid = SitPlayer[playerid]-1;

			// FBI Прослушка
			if(sitid >= 174 && sitid <= 186) SetPVarInt(playerid,"komp", -1), SetPVarInt(playerid,"komp2", -1);
			
			// Дойка Коров
			if(sitid >= 0 && sitid <= 17 && Dei[playerid] == 13) RemovePlayerAttachedObject(playerid, 1), SetPlayerAttachedObject(playerid, 1, 19468, 6, 0.325999, -0.114999, 0.019000, 99.999977, -103.299972, 1.999999, 1.000000, 1.000000, 1.000000, 0, 0);
			
			// Место в казино
			if(sitid >= 18 && sitid <= 77) leave_desk(playerid);
			
			// Обучение
			if(sitid >= 78 && sitid <= 101)
			{
				if(Ash[playerid] > 0)
				{
					Ash[playerid] = 0, AshTime[playerid] = 0;
					if(stat == 1) ErrorMessage(playerid, "{FF6347}Вы встали из-за парты и прервали обучение {cccccc}[ Вы можете повторить или уйти и вернуться в любое время ]");
				}
				if(AeroStat[playerid] > 0) DestroyPlayerObject(playerid, AeroObj[playerid]);
				if(stat == 1) SetCameraBehindPlayer(playerid);
			}

			if(SitID[sitid] == playerid+1) SitID[sitid] = 0;
			SitPlayer[playerid] = 0;
		}
		
		// Взаимодействие Off
		if(Hold[playerid] == 13)
		{
			new t = HoldStat[playerid];
		    if(ThrowInfo[t][tId] > 0 && HoldFrisk[playerid] == ThrowInfo[t][tId] && ThrowInfo[t][tUseplayer] > 0 && ThrowInfo[t][tUseplayer] == playerid+1) ThrowInfo[t][tUseplayer] = 0;
			Hold[playerid] = 0, HoldStat[playerid] = 0, HoldFrisk[playerid] = 0;
			if(Komputer[playerid] == 1 || Komputer[playerid] == 2) closecomp(playerid), CancelSelectTextDraw(playerid);
		}
	
		TextDrawHideForPlayer(playerid, MindDraw[3]), PlayerTextDrawHide(playerid, HintButton);
		if(Komputer[playerid] == 1 || Komputer[playerid] == 2) exitkomp(playerid, 1);
	}
	return 1;
}

CMD:createseat(playerid, const params[]) {
	new modelid;
	if (sscanf(params, "d", modelid)) return SendClientMessage(playerid, 0xCBCBCBFF, "[ Мысли ]: Создание стула [ /createseat ModelID ]");
	if (!IsPressSeatDynamicObject(modelid)) return SendClientMessage(playerid, 0xCBCBCBFF, "[ Мысли ]: Модель этого объекта не поддерживается");
	new Float: player_pos[4];
	GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
	GetPlayerFacingAngle(playerid, player_pos[3]);
	GetXYInFrontOfPoint(player_pos[0], player_pos[1], player_pos[3], 1.0);
	new object = CreateDynamicObject(modelid, player_pos[0], player_pos[1], player_pos[2], 0.0, 0.0, 0.0);
	SetPVarInt(playerid, "EditSeatObj", 1);
	EditDynamicObject(playerid, object);
	return 1;
}


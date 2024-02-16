
#define MAX_SEAT_OBJECT_POSITIONS 10 // Максимальное количество сидений у одного объекта

// Хранит относительные координаты каждой из позиций для сидения определенного объекта
static enum e_pressSeatObjectsPositions {
	Float: sopBaseZ, // Базовое вращение по Z (что возвращает GetPlayerFacingAngle если смотреть в сторону, вперед от сидения, при указанном вращении 0.0)
	Float: sopVerticalDistance, // Дистанция для вертикального направления относительно объекта (вперед - назад)
	Float: sopHorizontalDistance, // Дистанция для горизонтального направления относительно объекта (влево - вправо)
	Float: sopUpDistance // Смещение позиции сидения по высоте, относительно объекта
};

enum e_newSeatObjects {
	nssModel, // ID модели добавляемого стула
	nssObject, // ID созданного объекта

	// Сидения
	Float: nssSeat1[e_pressSeatObjectsPositions],
	Float: nssSeat2[e_pressSeatObjectsPositions],
	Float: nssSeat3[e_pressSeatObjectsPositions],
	Float: nssSeat4[e_pressSeatObjectsPositions],
	Float: nssSeat5[e_pressSeatObjectsPositions],
	Float: nssSeat6[e_pressSeatObjectsPositions],
	Float: nssSeat7[e_pressSeatObjectsPositions],
	Float: nssSeat8[e_pressSeatObjectsPositions],
	Float: nssSeat9[e_pressSeatObjectsPositions],
	Float: nssSeat10[e_pressSeatObjectsPositions]
};
new newSeatObjects[MAX_PLAYERS][e_newSeatObjects];

// Информация о каждой модели объекта, на который можно садиться
static enum e_pressSeatObjects {
	soModel, // Модель

	// Информация о каждом из возможных сидений
	Float: soSeat1[e_pressSeatObjectsPositions],
	Float: soSeat2[e_pressSeatObjectsPositions],
	Float: soSeat3[e_pressSeatObjectsPositions],
	Float: soSeat4[e_pressSeatObjectsPositions],
	Float: soSeat5[e_pressSeatObjectsPositions],
	Float: soSeat6[e_pressSeatObjectsPositions],
	Float: soSeat7[e_pressSeatObjectsPositions],
	Float: soSeat8[e_pressSeatObjectsPositions],
	Float: soSeat9[e_pressSeatObjectsPositions],
	Float: soSeat10[e_pressSeatObjectsPositions]
};

static const pressSeatObjects[][e_pressSeatObjects] = {
	{ 1768, {180.6798, 0.6954, -0.2146, 1.0200}, {179.0416, 0.6754, -1.0483, 1.0200}, {179.0416, 0.6621, -1.8397, 1.0200} },
	{ 1702, {181.3448, 0.5873, -0.5117, 1.0200}, {179.8953, 0.5703, -1.4566, 1.0200} },
	{ 1757, {181.7364, 0.6422, -0.4934, 1.0100}, {180.2873, 0.6348, -1.5759, 1.0100} },
	{ 1766, {178.4621, 0.6161, -0.5096, 1.0300}, {178.6185, 0.5902, -1.6428, 1.0300} },
	{ 1760, {183.1385, 0.7089, -0.0997, 1.0000}, {177.8121, 0.6628, -1.0487, 1.0000}, {177.8121, 0.6301, -1.9053, 1.0000} },
	{ 11717, {177.0812, 0.7437, -0.0166, 0.9900} },
	{ 1763, {182.2116, 0.4902, -0.0868, 1.0000}, {175.6092, 0.3992, -1.1555, 1.0000} },
	{ 1764, {177.8914, 0.5928, -0.4852, 1.0100}, {175.4015, 0.5053, -1.6035, 1.0100} },
	{ 1761, {175.8207, 0.5888, -0.2190, 1.0100}, {173.7227, 0.5386, -1.0338, 1.0100}, {173.1520, 0.3893, -1.8172, 1.0100} },
	{ 2290, {175.7473, 0.6544, -0.4996, 0.9900}, {178.3104, 0.6514, -1.4541, 0.9900} },
	{ 1710, {178.3451, 0.7534, -0.6961, 1.0000}, {175.6201, 0.6321, -1.8108, 1.0000}, {174.1878, 0.3436, -2.8779, 1.0000} },
	{ 1723, {179.1893, 0.6047, -0.4351, 1.0200}, {174.1314, 0.4593, -1.5745, 1.0200} },
	{ 1726, {179.3580, 0.6547, -0.4421, 1.0200}, {175.4580, 0.5256, -1.5153, 1.0200} },
	{ 11689, {262.0510, -0.6915, 0.6366, 1.0100}, {179.6607, -0.1107, 0.0228, 1.0100}, {89.2416, -0.6569, -0.3990, 1.0100} },
	{ 2808, {359.3265, 0.7185, -0.4469, 0.3730}, {359.3265, 0.7290, 0.4415, 0.3730} },
	{ 1705, {178.4570, 0.6106, -0.5198, 1.0199} },
	{ 1769, {180.2323, 0.6931, -0.4915, 0.9999} },
	{ 1758, {178.8748, 0.5461, -0.4817, 1.0599} },
	{ 1735, {182.4025, 0.5994, -0.0246, 1.0099} },
	{ 1755, {179.8733, 0.7846, -0.5451, 1.0099} },
	{ 1759, {179.9802, 0.4750, -0.5314, 1.0099} },
	{ 1767, {181.7526, 0.5929, -0.5302, 1.0499} },
	{ 1765, {182.6926, 0.6355, -0.6036, 1.0099} },
	{ 1762, {180.8127, 0.6525, -0.5762, 1.0099} },
	{ 1711, {182.1704, 0.7021, -0.2272, 0.9999} },
	{ 1724, {181.3350, 0.6064, -0.5531, 1.0099} },
	{ 1727, {182.1707, 0.6728, -0.5420, 1.0199} },
	{ 2120, {91.3982, 0.6055, 0.0147, 0.4800} },
	{ 2079, {86.9878, 0.6077, -0.0556, 0.4100} },
	{ 2350, {270.0336, 0.3833, -0.0146, 0.9000} },
	{ 1715, {176.7873, 0.6765, -0.0621, 1.0400} },
	{ 2356, {3.1585, 0.6981, -0.0140, 1.0500} },
	{ 2124, {88.7802, 0.5894, -0.0267, 0.1900} },
	{ 2310, {90.8475, 0.5935, -0.0122, 0.5100} },
	{ 1714, {185.1561, 0.5962, 0.0202, 1.0400} },
	{ 2121, {179.7251, 0.6590, -0.0339, 0.5600} },
	{ 1716, {87.7817, 0.7583, -0.3411, 1.0400} },
	{ 2724, {175.1788, 0.3949, -0.0497, 0.6000} },
	{ 2776, {175.1342, 0.6667, -0.0452, 0.6400} },
	{ 2788, {94.7343, 0.5683, 0.0000, 0.5700} },
	{ 2748, {178.4183, 0.6613, -0.0277, 0.4300} },
	{ 2746, {5.7291, 1.0856, 0.0961, 0.4300}, {181.8239, 1.0612, 0.0242, 0.4300} },
	{ 2639, {359.3265, 0.7271, 0.3493, 0.3803}, {359.3265, 0.7252, -0.4257, 0.3730} },
	{ 1280, {85.5502, 0.6858, 0.6724, 0.5900}, {85.2540, 0.5703, -0.5745, 0.5900} },
	{ 1256, {91.1302, 0.5892, 0.8892, 0.3400}, {86.5254, 0.6093, 0.0258, 0.3400}, {87.1074, 0.5617, -0.9045, 0.3400} },
	{ 2295, {183.0910, 0.7035, -0.0018, 1.0000} },
	{ 2291, {175.4096, 0.6215, -0.5831, 1.0000} },
	{ 2638, {180.3333, 1.0967, 0.3918, 0.3500}, {181.5865, 1.1540, -0.4861, 0.3500}, {3.6351, 1.0038, 0.4904, 0.3500}, {354.8618, 0.9650, -0.4677, 0.3500} },
	{ 1709, {181.2731, -0.3709, -0.1932, 1.0100}, {180.3333, -0.3630, -1.3418, 1.0100}, {180.3333, -0.3562, -2.4243, 1.0100}, {180.3333, -0.3494, -3.4835, 1.0100}, {151.8199, -2.3114, -3.6094, 1.0100}, {132.3931, -3.4159, -3.4288, 1.0100} },
	{ 1663, {-180.0, 0.65, 0.0, -0.15} },
	{ 1671, {-180.0, 0.6, 0.0, 0.0} },
	{ 19994, {-180.0, 0.6, 0.0, 0.0} },
	{ 1721, {0.0, 0.7, 0.0, 0.0} },
	{ 1722, {0.0, 0.7, 0.0, 0.0} },
	{ 19999, {-180.0, 0.6, 0.0, 0.0} },
	{ 1810, {-180.0, 0.35, 0.22, 0.4550} },
	{ 19996, {-180.0, 0.6, 0.0, -0.2} },
	{ 1720, {-180.0, 0.48, 0.0, -0.2} },
	{ 2122, {90.0, 0.6, 0.0, 0.0} },
	{ 2293, {0.0, 0.6, 0.0, 0.0} },
	{ 2777, {-180.0, 0.6, 0.0, 0.0} },
	{ 2309, {0.0442, 0.6750, -0.0131, 0.9900} },
	{ 2096, {-180.0, 0.45, 0.0, -0.2} },
	{ 2807, {90.0, 0.6, 0.0, -0.15} },
	{ 1729, {-180.0, 0.6, 0.0, -0.2} },
	{ 1746, {0.0, 0.6, 0.0, -0.2} },
	{ 2123, {90.0, 0.6, 0.0, 0.0} },
	{ 2636, {90.0, 0.55, 0.0, 0.0} },
	{ 1811, {90.0, 0.6, 0.0, 0.05} },
	{ 11734, {-180.0, 0.6, 0.0, 0.0} },
	{ 2343, {-90.0, 0.6, 0.0, 0.0} },
	{ 11682, {180.0, 0.65, 0.1, -0.2} },
	{ 11683, {-180.0, 0.7, 0.0, -0.25} },
	{ 11684, {180.0, 0.6, -0.2, -0.05} },
	{ 11685, {-180.0, 0.6, 0.0, 0.0} },
	{ 1739, {90.0, 0.6, 0.0, 0.0} },
	{ 1704, {-180.0, 0.7, -0.5, -0.3} },
	{ 1708, {-180.0, 0.7, -0.5, -0.3} },
	{ 1562, {-180.0, 0.65, 0.0, -0.33} },
	{ 1806, {0.0, 0.6, 0.04, 0.0} },
	{ 1713, {181.5093, 0.6850, -0.3393, 1.0100}, {181.1961, 0.7033, -1.3060, 1.0100} }
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

// Получает информацию о сидении модели объекта по числовому индексу
stock GetSeatPosition(model_index, seat_index, &Float: baseZ, &Float: verticalDistance, &Float: horizontalDistance, &Float: upDistance) {
	switch(seat_index) {
		case 0:
		{	
			baseZ = pressSeatObjects[model_index][soSeat1][sopBaseZ];
			verticalDistance = pressSeatObjects[model_index][soSeat1][sopVerticalDistance];
			horizontalDistance = pressSeatObjects[model_index][soSeat1][sopHorizontalDistance];
			upDistance = pressSeatObjects[model_index][soSeat1][sopUpDistance];
		}
		case 1: 
		{	
			baseZ = pressSeatObjects[model_index][soSeat2][sopBaseZ];
			verticalDistance = pressSeatObjects[model_index][soSeat2][sopVerticalDistance];
			horizontalDistance = pressSeatObjects[model_index][soSeat2][sopHorizontalDistance];
			upDistance = pressSeatObjects[model_index][soSeat2][sopUpDistance];
		}
		case 2: 
		{	
			baseZ = pressSeatObjects[model_index][soSeat3][sopBaseZ];
			verticalDistance = pressSeatObjects[model_index][soSeat3][sopVerticalDistance];
			horizontalDistance = pressSeatObjects[model_index][soSeat3][sopHorizontalDistance];
			upDistance = pressSeatObjects[model_index][soSeat3][sopUpDistance];
		}
		case 3: 
		{	
			baseZ = pressSeatObjects[model_index][soSeat4][sopBaseZ];
			verticalDistance = pressSeatObjects[model_index][soSeat4][sopVerticalDistance];
			horizontalDistance = pressSeatObjects[model_index][soSeat4][sopHorizontalDistance];
			upDistance = pressSeatObjects[model_index][soSeat4][sopUpDistance];
		}
		case 4: 
		{	
			baseZ = pressSeatObjects[model_index][soSeat5][sopBaseZ];
			verticalDistance = pressSeatObjects[model_index][soSeat5][sopVerticalDistance];
			horizontalDistance = pressSeatObjects[model_index][soSeat5][sopHorizontalDistance];
			upDistance = pressSeatObjects[model_index][soSeat5][sopUpDistance];
		}
		case 5: 
		{	
			baseZ = pressSeatObjects[model_index][soSeat6][sopBaseZ];
			verticalDistance = pressSeatObjects[model_index][soSeat6][sopVerticalDistance];
			horizontalDistance = pressSeatObjects[model_index][soSeat6][sopHorizontalDistance];
			upDistance = pressSeatObjects[model_index][soSeat6][sopUpDistance];
		}
		case 6: 
		{	
			baseZ = pressSeatObjects[model_index][soSeat7][sopBaseZ];
			verticalDistance = pressSeatObjects[model_index][soSeat7][sopVerticalDistance];
			horizontalDistance = pressSeatObjects[model_index][soSeat7][sopHorizontalDistance];
			upDistance = pressSeatObjects[model_index][soSeat7][sopUpDistance];
		}
		case 7: 
		{	
			baseZ = pressSeatObjects[model_index][soSeat8][sopBaseZ];
			verticalDistance = pressSeatObjects[model_index][soSeat8][sopVerticalDistance];
			horizontalDistance = pressSeatObjects[model_index][soSeat8][sopHorizontalDistance];
			upDistance = pressSeatObjects[model_index][soSeat8][sopUpDistance];
		}
		case 8: 
		{	
			baseZ = pressSeatObjects[model_index][soSeat9][sopBaseZ];
			verticalDistance = pressSeatObjects[model_index][soSeat9][sopVerticalDistance];
			horizontalDistance = pressSeatObjects[model_index][soSeat9][sopHorizontalDistance];
			upDistance = pressSeatObjects[model_index][soSeat9][sopUpDistance];
		}
		case 9: 
		{	
			baseZ = pressSeatObjects[model_index][soSeat10][sopBaseZ];
			verticalDistance = pressSeatObjects[model_index][soSeat10][sopVerticalDistance];
			horizontalDistance = pressSeatObjects[model_index][soSeat10][sopHorizontalDistance];
			upDistance = pressSeatObjects[model_index][soSeat10][sopUpDistance];
		}
		default: return false;
	}

	return true;
}
// Получает информацию о сидении добавляемой модели объекта по числовому индексу
stock GetNewSeatPosition(playerid, seat_index, &Float: baseZ, &Float: verticalDistance, &Float: horizontalDistance, &Float: upDistance) {
	switch(seat_index) {
		case 0:
		{	
			baseZ = newSeatObjects[playerid][nssSeat1][sopBaseZ];
			verticalDistance = newSeatObjects[playerid][nssSeat1][sopVerticalDistance];
			horizontalDistance = newSeatObjects[playerid][nssSeat1][sopHorizontalDistance];
			upDistance = newSeatObjects[playerid][nssSeat1][sopUpDistance];
		}
		case 1: 
		{	
			baseZ = newSeatObjects[playerid][nssSeat2][sopBaseZ];
			verticalDistance = newSeatObjects[playerid][nssSeat2][sopVerticalDistance];
			horizontalDistance = newSeatObjects[playerid][nssSeat2][sopHorizontalDistance];
			upDistance = newSeatObjects[playerid][nssSeat2][sopUpDistance];
		}
		case 2: 
		{	
			baseZ = newSeatObjects[playerid][nssSeat3][sopBaseZ];
			verticalDistance = newSeatObjects[playerid][nssSeat3][sopVerticalDistance];
			horizontalDistance = newSeatObjects[playerid][nssSeat3][sopHorizontalDistance];
			upDistance = newSeatObjects[playerid][nssSeat3][sopUpDistance];
		}
		case 3: 
		{	
			baseZ = newSeatObjects[playerid][nssSeat4][sopBaseZ];
			verticalDistance = newSeatObjects[playerid][nssSeat4][sopVerticalDistance];
			horizontalDistance = newSeatObjects[playerid][nssSeat4][sopHorizontalDistance];
			upDistance = newSeatObjects[playerid][nssSeat4][sopUpDistance];
		}
		case 4: 
		{	
			baseZ = newSeatObjects[playerid][nssSeat5][sopBaseZ];
			verticalDistance = newSeatObjects[playerid][nssSeat5][sopVerticalDistance];
			horizontalDistance = newSeatObjects[playerid][nssSeat5][sopHorizontalDistance];
			upDistance = newSeatObjects[playerid][nssSeat5][sopUpDistance];
		}
		case 5: 
		{	
			baseZ = newSeatObjects[playerid][nssSeat6][sopBaseZ];
			verticalDistance = newSeatObjects[playerid][nssSeat6][sopVerticalDistance];
			horizontalDistance = newSeatObjects[playerid][nssSeat6][sopHorizontalDistance];
			upDistance = newSeatObjects[playerid][nssSeat6][sopUpDistance];
		}
		case 6: 
		{	
			baseZ = newSeatObjects[playerid][nssSeat7][sopBaseZ];
			verticalDistance = newSeatObjects[playerid][nssSeat7][sopVerticalDistance];
			horizontalDistance = newSeatObjects[playerid][nssSeat7][sopHorizontalDistance];
			upDistance = newSeatObjects[playerid][nssSeat7][sopUpDistance];
		}
		case 7: 
		{	
			baseZ = newSeatObjects[playerid][nssSeat8][sopBaseZ];
			verticalDistance = newSeatObjects[playerid][nssSeat8][sopVerticalDistance];
			horizontalDistance = newSeatObjects[playerid][nssSeat8][sopHorizontalDistance];
			upDistance = newSeatObjects[playerid][nssSeat8][sopUpDistance];
		}
		case 8: 
		{	
			baseZ = newSeatObjects[playerid][nssSeat9][sopBaseZ];
			verticalDistance = newSeatObjects[playerid][nssSeat9][sopVerticalDistance];
			horizontalDistance = newSeatObjects[playerid][nssSeat9][sopHorizontalDistance];
			upDistance = newSeatObjects[playerid][nssSeat9][sopUpDistance];
		}
		case 9: 
		{	
			baseZ = newSeatObjects[playerid][nssSeat10][sopBaseZ];
			verticalDistance = newSeatObjects[playerid][nssSeat10][sopVerticalDistance];
			horizontalDistance = newSeatObjects[playerid][nssSeat10][sopHorizontalDistance];
			upDistance = newSeatObjects[playerid][nssSeat10][sopUpDistance];
		}
		default: return false;
	}

	return true;
}

// Присваивает информацию о сидении добавляемой модели объекта по числовому индексу
stock SetNewSeatPosition(playerid, seat_index, Float: baseZ, Float: verticalDistance, Float: horizontalDistance, Float: upDistance) {
	switch (seat_index) {
		case 0: {
			newSeatObjects[playerid][nssSeat1][sopBaseZ] = baseZ;
			newSeatObjects[playerid][nssSeat1][sopVerticalDistance] = verticalDistance;
			newSeatObjects[playerid][nssSeat1][sopHorizontalDistance] = horizontalDistance;
			newSeatObjects[playerid][nssSeat1][sopUpDistance] = upDistance;
		}
		case 1: {
			newSeatObjects[playerid][nssSeat2][sopBaseZ] = baseZ;
			newSeatObjects[playerid][nssSeat2][sopVerticalDistance] = verticalDistance;
			newSeatObjects[playerid][nssSeat2][sopHorizontalDistance] = horizontalDistance;
			newSeatObjects[playerid][nssSeat2][sopUpDistance] = upDistance;
		}
		case 2: {
			newSeatObjects[playerid][nssSeat3][sopBaseZ] = baseZ;
			newSeatObjects[playerid][nssSeat3][sopVerticalDistance] = verticalDistance;
			newSeatObjects[playerid][nssSeat3][sopHorizontalDistance] = horizontalDistance;
			newSeatObjects[playerid][nssSeat3][sopUpDistance] = upDistance;
		}
		case 3: {
			newSeatObjects[playerid][nssSeat4][sopBaseZ] = baseZ;
			newSeatObjects[playerid][nssSeat4][sopVerticalDistance] = verticalDistance;
			newSeatObjects[playerid][nssSeat4][sopHorizontalDistance] = horizontalDistance;
			newSeatObjects[playerid][nssSeat4][sopUpDistance] = upDistance;
		}
		case 4: {
			newSeatObjects[playerid][nssSeat5][sopBaseZ] = baseZ;
			newSeatObjects[playerid][nssSeat5][sopVerticalDistance] = verticalDistance;
			newSeatObjects[playerid][nssSeat5][sopHorizontalDistance] = horizontalDistance;
			newSeatObjects[playerid][nssSeat5][sopUpDistance] = upDistance;
		}
		case 5: {
			newSeatObjects[playerid][nssSeat6][sopBaseZ] = baseZ;
			newSeatObjects[playerid][nssSeat6][sopVerticalDistance] = verticalDistance;
			newSeatObjects[playerid][nssSeat6][sopHorizontalDistance] = horizontalDistance;
			newSeatObjects[playerid][nssSeat6][sopUpDistance] = upDistance;
		}
		case 6: {
			newSeatObjects[playerid][nssSeat7][sopBaseZ] = baseZ;
			newSeatObjects[playerid][nssSeat7][sopVerticalDistance] = verticalDistance;
			newSeatObjects[playerid][nssSeat7][sopHorizontalDistance] = horizontalDistance;
			newSeatObjects[playerid][nssSeat7][sopUpDistance] = upDistance;
		}
		case 7: {
			newSeatObjects[playerid][nssSeat8][sopBaseZ] = baseZ;
			newSeatObjects[playerid][nssSeat8][sopVerticalDistance] = verticalDistance;
			newSeatObjects[playerid][nssSeat8][sopHorizontalDistance] = horizontalDistance;
			newSeatObjects[playerid][nssSeat8][sopUpDistance] = upDistance;
		}
		case 8: {
			newSeatObjects[playerid][nssSeat9][sopBaseZ] = baseZ;
			newSeatObjects[playerid][nssSeat9][sopVerticalDistance] = verticalDistance;
			newSeatObjects[playerid][nssSeat9][sopHorizontalDistance] = horizontalDistance;
			newSeatObjects[playerid][nssSeat9][sopUpDistance] = upDistance;
		}
		case 9: {
			newSeatObjects[playerid][nssSeat10][sopBaseZ] = baseZ;
			newSeatObjects[playerid][nssSeat10][sopVerticalDistance] = verticalDistance;
			newSeatObjects[playerid][nssSeat10][sopHorizontalDistance] = horizontalDistance;
			newSeatObjects[playerid][nssSeat10][sopUpDistance] = upDistance;
		}
	}
}

stock SetNewSeatPositionByPlayer(playerid, seat_index) {
	new Float: object_x, Float: object_y, Float: object_z;
	GetDynamicObjectPos(newSeatObjects[playerid][nssObject], object_x, object_y, object_z);

	new Float: player_x, Float: player_y, Float: player_z, Float: angle;
	GetPlayerPos(playerid, player_x, player_y, player_z);
	GetPlayerFacingAngle(playerid, angle);
	
	new Float: verticalDistance, Float: horizontalDistance;
	GetOffsetPosition(player_x, player_y, object_x, object_y, angle, verticalDistance, horizontalDistance);

	SetNewSeatPosition(playerid, seat_index, angle, verticalDistance, horizontalDistance, player_z - object_z);
	
	return 1;
}

stock GetNewSeatsCount(playerid) {
	new count = 0;
	for (new i = 0; i < MAX_SEAT_OBJECT_POSITIONS; i++) {
		new Float: baseZ, Float: verticalDistance, Float: horizontalDistance, Float: upDistance;
		GetNewSeatPosition(playerid, i, baseZ, verticalDistance, horizontalDistance, upDistance);

		if (baseZ == 0.0 && verticalDistance == 0.0 && horizontalDistance == 0.0 && upDistance == 0.0)
			break;

		count++;
	}

	return count;
}

stock GetSeatsCount(model_index) {
	new count = 0;
	for (new i = 0; i < MAX_SEAT_OBJECT_POSITIONS; i++) {
		new Float: baseZ, Float: verticalDistance, Float: horizontalDistance, Float: upDistance;
		GetSeatPosition(model_index, i, baseZ, verticalDistance, horizontalDistance, upDistance);

		if (baseZ == 0.0 && verticalDistance == 0.0 && horizontalDistance == 0.0 && upDistance == 0.0)
			break;

		count++;
	}
	return count;
}

// Возвращает координаты ближайшего к игроку сидения у модели объекта
stock GetClosestSeatPosition(playerid, objectid, model_index, &Float: x, &Float: y, &Float: z, &Float: a) {
	new Float: min_distance = 1000.0;
	new bool: seats_occupied[MAX_SEAT_OBJECT_POSITIONS];

	new closest_seat_index = -1;
	for(new seat_index = 0; seat_index < min(GetSeatsCount(model_index), MAX_SEAT_OBJECT_POSITIONS); seat_index++) {
		new Float: baseZ, Float: verticalDistance, Float: horizontalDistance, Float: upDistance;
		GetSeatPosition(model_index, seat_index, baseZ, verticalDistance, horizontalDistance, upDistance);

		new Float: cur_x, Float: cur_y, Float: cur_z, Float: cur_a;
		GetSeatPositionCoords(objectid, baseZ, verticalDistance, horizontalDistance, cur_x, cur_y, cur_z, cur_a);

		new Float: cur_player_x, Float: cur_player_y, Float: cur_player_z;
		GetPlayerPos(playerid, cur_player_x, cur_player_y, cur_player_z);

		// Узнаем, занято ли место кем-то другим
		for(new id = 0; id < MAX_REALPLAYERS; id++)
		{
			if(OnlineInfo[id][oLogged] == 0) continue;
		
			if (IsPlayerInRangeOfPoint(id, 0.01, cur_x, cur_y, cur_player_z)) 
			{
				seats_occupied[seat_index] = true;
				break;
			}

			if(CompGameActor[id] == 0) continue;
			if(IsDynamicActorInRangeOfPoint(CompGameActor[id], 0.05, cur_x, cur_y, cur_player_z)) 
			{
				seats_occupied[seat_index] = true;
				break;
			}
		}

		new Float: distance = GetPlayerDistanceFromPoint(playerid, cur_x, cur_y, cur_z);
		if (distance < min_distance) {
			closest_seat_index = seat_index;
			min_distance = distance;

			x = cur_x;
			y = cur_y;
			z = cur_z;
			a = cur_a;
		}
	}

	// Не сажаем игрока, если ближайшее к нему место занято кем-то другим
	if (seats_occupied[closest_seat_index])
		return -1;

	return closest_seat_index;
}

// Получает координаты сидения по его относительной информации
stock GetSeatPositionCoords(objectid, Float: baseZ, Float: verticalDistance, Float: horizontalDistance, &Float: x, &Float: y, &Float:z, &Float: a) {
	new Float: object_pos[4];
	GetDynamicObjectPos(objectid, object_pos[0], object_pos[1], object_pos[2]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_Z, object_pos[3]);

	a = baseZ + object_pos[3];
	CalculateOffsetPosition(object_pos[0], object_pos[1], a, verticalDistance, horizontalDistance, x, y);
	z = object_pos[2];
}

// Получает позицию, в которой нужно применить анимацию, чтобы ровно сесть
stock GetDynamicObjectSeatPosition(playerid, objectid, &Float: x, &Float: y, &Float: z, &Float: a) {
	if (!IsValidDynamicObject(objectid)) return false;

	new model = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);
	for (new i = 0; i < sizeof pressSeatObjects; i++) {
		new curmodel = _:pressSeatObjects[i][soModel];

		if (model == curmodel) {
			new seat_index = GetClosestSeatPosition(playerid, objectid, i, x, y, z, a);
			if (seat_index >= 0)
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

	// Позиции, где sit не будет работать
	if(NoSit(playerid)) return 0;

	new Float: player_pos[3];
	GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);

	// Узнаем есть ли рядом пикапы и отменяем посадку, если да (чтобы не было конфликтов со входами и т.п.)
	new pickups[1];
	new pickups_count = min(Streamer_GetAllVisibleItems(playerid, STREAMER_TYPE_PICKUP, pickups), sizeof pickups);
	for (new i = 0; i < pickups_count; i++) {
		new Float: distance;
		Streamer_GetDistanceToItem(player_pos[0], player_pos[1], player_pos[2], STREAMER_TYPE_PICKUP, pickups[i], distance);
		
		// Если рядом есть пикап - прекращаем обработку
		if (distance >= 2.05) break;
		else return 0;
	}

  	// Получаем ближайшие к игроку динамические объекты
	new objects[10];
	new objects_count = min(Streamer_GetAllVisibleItems(playerid, STREAMER_TYPE_OBJECT, objects), sizeof objects);
	for (new i = 0; i < objects_count; i++) {
		// Перебираем каждый объект
		new current_object = objects[i];

		new Float: distance;
		Streamer_GetDistanceToItem(player_pos[0], player_pos[1], player_pos[2], STREAMER_TYPE_OBJECT, current_object, distance);
		if (distance > 2.50) break;

		if(IsAMusicObject(playerid, GetDynamicObjectModel(current_object))) return 1;

		// Установка нужной позиции и анимации игроку (если объект является стулом)
		new Float: x, Float: y, Float: z, Float: a;
		new result = GetDynamicObjectSeatPosition(playerid, current_object, x, y, z, a);
		if (result) 
		{
			// Если игрок не в той стороне, куда "смотрит" сидение - отменяем
			static const Float: side_detect_sensitivity = 0.20; // Чем больше - тем менее точным будет определение стороны, но более чаще будет срабатывать приседание с нужной стороны [0.25 - по умолчанию]
			new Float: dirX = floatsin(a, degrees),
				Float: dirY = floatcos(a, degrees);

			new Float: vecToPlayerX = player_pos[0] - x,
				Float: vecToPlayerY = player_pos[1] - y;

			new Float: dotProduct = dirX * vecToPlayerX + dirY * vecToPlayerY;
			if (dotProduct < -side_detect_sensitivity || dotProduct > side_detect_sensitivity) break;
			
			// Если модель объекта найдена и позиция определена - помещаем игрока на неё
			if(Hold[playerid] == 12) return ErrorMessage(playerid, "{FF6347}У вас в руках поднос\n{cccccc}Кнопка F, чтобы положить его на стол");
			new status = sit(playerid, x, y, player_pos[2]);
			if(status > 0)
			{
				playerSeat[playerid] = true;
				
				PPSetPlayerPos(playerid, x, y, player_pos[2]);

				SetPlayerFacingAngle(playerid, a);

				sit_Active(playerid, x, y, player_pos[2], a);

				return 1;
			}
		}
	}
	return 0;
}

stock sit_Active(playerid, Float:x, Float:y, Float:z, Float:a)
{
	SetPVarInt(playerid, "antifsit", 3);
	Job_X[playerid] = x, Job_Y[playerid] = y, Job_Z[playerid] = z, Job_A[playerid] = a;
	NoAnim[playerid] = 1;
	if(OnlineInfo[playerid][oKeepSit] == 0) 
	{
		ApplyAnimation(playerid,"PED","SEAT_down",4.0,0,0,0,1,0,1);
		SetTimerEx("sitload", 1500, 0, "d", playerid);
	}
	else ApplyAnimation(playerid,"PED","SEAT_idle",4.0,0,0,0,1,0,1);
	return 1;
}

stock NoSit(playerid) // Позиции, где sit работать не будет
{
	if(IsPlayerInRangeOfPoint(playerid,2.0,1302.9628,1606.5735,20.0563) && GetPlayerVirtualWorld(playerid) == 180 && GetPlayerInterior(playerid) == 179 // Поезд (место машиниста)
	|| IsPlayerInRangeOfPoint(playerid,2.0,975.0098,2420.8489,10.8503) && GetPlayerVirtualWorld(playerid) == WORLD_PRISON_1LVL && GetPlayerInterior(playerid) == INT_PRISON_1LVL) // Тюрьма (1 Этаж Холл)
	{
		return 1;
	}
	return 0;
}

stock sit(playerid, Float:x, Float:y, Float:z)
{
	new status = 1;
	if(SitPlayer[playerid] == 0 && HealthAC[playerid] >= 1 && Stun[0][playerid] == 0 && Stun[2][playerid] == 0 && Stun[3][playerid] == 0 && !IsPlayerInAnyVehicle(playerid)
	&& GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		if(GetPVarInt(playerid, "antifsit") > 0) return 0;
		new sitid = 0, mw = GetPlayerVirtualWorld(playerid), mi = GetPlayerInterior(playerid);
		for(new s = 0; s < sizeof(SitPos); ++s)
		{
			new Float:dist = GetDistancePoint(x, y, z, SitPos[s][SitPos_X], SitPos[s][SitPos_Y], SitPos[s][SitPos_Z]);

			if(dist <= 0.4
			&& (SitPos[s][SitWorld] >= 0 && mw == SitPos[s][SitWorld] || SitPos[s][SitWorld] <= -1)
			&& (SitPos[s][SitInt] >= 0 && mi == SitPos[s][SitInt] || SitPos[s][SitInt] <= -1) && SitID[s] == 0)
			{
				sitid = s+1;
				break;
			}
		}

		new joinDesk;
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
						new string[60];
						format(string,sizeof(string),"{ffcc66}Доить корову: {ff9000}%s", buttonName[Device[playerid]]);
						ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",string,"*","");
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
					ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Откройте инвентарь и кликните два раза по нужному учебнику, чтобы начать обучение\n\n{cccccc}Если у вас нет учебника - возьмите его в библиотеке","*","");
				}
				else ShowDialog(playerid,1227,DIALOG_STYLE_MSGBOX,"{ff9000}Образовательный Центр","\n{ff9000}Вы уверены, что хотите начать экзамен?\n","Да","Нет");
			}

			SitID[sid] = playerid+1;
			SitPlayer[playerid] = sitid;

			// Стулья в комнате казино для игры в карты
			if(kassit > 0) joinDesk = join_player_desk(playerid, kassit-1, sid-minussid);

			if(readsit == 1) SendClientMessagef(playerid, COLOR_GREY, "%d", sid);
		}

		// Отображаем подсказку, только если игрок не сел за игровой стол в карты
		if(joinDesk == 0) TextDrawShowForPlayer(playerid, MindDraw[3]), PlayerTextDrawSetString(playerid, HintButton, "ENTER"), PlayerTextDrawShow(playerid, HintButton);
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

			// FBI Прослушка Off
			SetPVarInt(playerid,"komp", -1), SetPVarInt(playerid,"komp2", -1);
			
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

stock IsAMusicObject(playerid, model)
{
	if(model == 2232)
	{
		ShowDialog(playerid, 1488, DIALOG_STYLE_TABLIST, "Магнитофон", "{ffffff}Включить трек\nВыключить трек", "Выбор", "Отмена");
		return 1;
	}
	return 0;
}

stock ShowNewSeatMenu(playerid) {
	if (newSeatObjects[playerid][nssModel] <= 0) return 0;

	new dialog_text[512] = " \t \n";

	strcat(dialog_text, "{FFCC00}* {ffffff}Добавить новое место");

	for (new i = 0; i < min(GetNewSeatsCount(playerid), MAX_SEAT_OBJECT_POSITIONS); i++)
		format(dialog_text, sizeof dialog_text, "%s\n{ffffff}  - Место %d:\t{99ff66}Установлено", dialog_text, i + 1);

	strcat(dialog_text, "\n{FFCC00}* {FF6347}Отмена добавления объекта\n{FFCC00}* {99ff66}Сохранить и выйти");

	return ShowDialog(playerid, 1485, DIALOG_STYLE_TABLIST_HEADERS, "{cbcbcb}Редактирование сидений", dialog_text, "Выбор", "Закрыть");
}

CMD:newseat(playerid) {
	if (newSeatObjects[playerid][nssModel] <= 0) {
		ShowDialog(playerid, 1484, DIALOG_STYLE_INPUT, " ", "{ffffff}Объект с указанной моделью появится рядом с вашим персонажем\nВы не должны применять к объекту какое-либо вращение или перемещать его по осям X/Y\n\n{ffffff}Укажите {ff9000}ID модели{ffffff} необходимого объекта:", "Продолжить", "Отмена");
	} else {
		ShowNewSeatMenu(playerid);
	}
	return 1;
}

CMD:ebalo180(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 1) return 0;
	new Float:a;
	GetPlayerFacingAngle(playerid,a);
	SetPlayerFacingAngle(playerid,a+180);

	ApplyAnimation(playerid,"PED","SEAT_down",4.0,0,0,0,1,0,1);
	return 1;
}

stock AutoSitOnDialogResponse(playerid, dialogid, response, listitem,const inputtext[]) {
	if(dialogid == 1484)
	{
		if (!response) return 1;
		new modelid = strval(inputtext);

		// Создание объекта
		new Float: player_pos[4];
		GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
		GetPlayerFacingAngle(playerid, player_pos[3]);
		GetXYInFrontOfPoint(player_pos[0], player_pos[1], player_pos[3], 2.0);

		new objectid = CreateDynamicObject(modelid, player_pos[0], player_pos[1], player_pos[2], 0.0, 0.0, 0.0);
		if (objectid == INVALID_OBJECT_ID) {
			SendClientMessage(playerid, 0xCCCCCC, "[ Мысли ]: Не удалось создать объект");
			return 1;
		}
		SetPVarInt(playerid, "EditNewSeatObj", 1);
		EditForSeat(playerid, objectid);
	}

	if(dialogid == 1485)
	{
		if (!response) return 1;

		new seats_count = GetNewSeatsCount(playerid);
		
		if (listitem == 0) {
			if (seats_count >= MAX_SEAT_OBJECT_POSITIONS) {
				PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
				return ShowDialog(playerid, 11111, DIALOG_STYLE_MSGBOX, "{ffffff}Информация", "{FF6347}Вы добавили максимальное количество сидений", "Закрыть", "");
			}

			SetNewSeatPositionByPlayer(playerid, seats_count);

			ShowDialog(playerid, 11111, DIALOG_STYLE_MSGBOX, "{ffffff}Информация", "{99ff66}Позиция была успешно добавлена", "Ок", "");
			PlayerPlaySound(playerid, 6401, 0.0, 0.0, 0.0);
		} else if (listitem <= seats_count) {
			new seat_index = listitem - 1;
			SetNewSeatPositionByPlayer(playerid, seat_index);

			ShowDialog(playerid, 11111, DIALOG_STYLE_MSGBOX, "{ffffff}Информация", "{99ff66}Позиция была успешно заменена текущим положением вашего персонажа", "Закрыть", "");
			PlayerPlaySound(playerid, 6401, 0.0, 0.0, 0.0);
		} else if (listitem == seats_count + 1) {
			DestroyDynamicObject(newSeatObjects[playerid][nssObject]);

			for(new e_newSeatObjects:i; i < e_newSeatObjects; ++i) newSeatObjects[playerid][i] = 0;

			ShowDialog(playerid, 11111, DIALOG_STYLE_MSGBOX, "{ffffff}Информация", "{FF6347}Вы отменили добавление объекта", "Закрыть", "");
			PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
		} else if (listitem == seats_count + 2) {
			if (seats_count <= 0) {
				PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
				return ShowDialog(playerid, 11111, DIALOG_STYLE_MSGBOX, "{ffffff}Информация", "{FF6347}Вы не добавили ни одного сидения", "Закрыть", "");
			}

			new log_str[512];
			for (new i = 0; i < min(seats_count, MAX_SEAT_OBJECT_POSITIONS); i++) {
				new Float: baseZ, Float: verticalDistance, Float: horizontalDistance, Float: upDistance;
				GetNewSeatPosition(playerid, i, baseZ, verticalDistance, horizontalDistance, upDistance);

				format(log_str, sizeof log_str, "%s{%.04f, %.04f, %.04f, %.04f}, ", log_str,
					baseZ, verticalDistance, horizontalDistance, upDistance
				);
			}
			log_str[strlen(log_str) - 2] = EOS;

			new lane[180];
			format(lane,sizeof(lane), "{ %d, %s }", newSeatObjects[playerid][nssModel], log_str);
			SendClientMessage(playerid, COLOR_GREEN, lane);

			printf("{ %d, %s }", newSeatObjects[playerid][nssModel], log_str);

			DestroyDynamicObject(newSeatObjects[playerid][nssObject]);
			for(new e_newSeatObjects:i; i < e_newSeatObjects; ++i) newSeatObjects[playerid][i] = 0;

			ShowDialog(playerid, 11111, DIALOG_STYLE_MSGBOX, "{ffffff}Информация", "{99ff66}Данные о позициях были выведены в чат!", "Закрыть", "");
			PlayerPlaySound(playerid, 6401, 0.0, 0.0, 0.0);
		}
	}
	if(dialogid == 1487)
	{
		new Float: player_pos[3],world,int;
		GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
		world = GetPlayerVirtualWorld(playerid), int = GetPlayerInterior(playerid);
		if(response)
		{
			if(checksimvol(inputtext)) return ErrorMessage(playerid, "{FF6347}Вы используете запрещённый символ");
			new urlvalid = strfind(inputtext,".mp3");
			if(urlvalid == -1)
			{
				urlvalid = urlvalid = strfind(inputtext,"https://");
				if(urlvalid > 1 || urlvalid == -1) return ErrorMessage(playerid,"{ff6347}Ссылка должна начинатся на https://");
				urlvalid = strfind(inputtext,".ogg");
				if(urlvalid == -1) return ErrorMessage(playerid,"{ff6347}Ссылка на трек обязательно должена иметь в ссылке формат .mp3 или .ogg");
			}
			SuccessMessage(playerid,"{44ff99}Вы поставили трек. Если он не играет значит вы допустили ошибку в ссылке, или у вас в настройках выключен звук Радио.");
			foreach (Player, i)
			{
				if(IsPlayerInRangeOfPoint(i,300.0,player_pos[0], player_pos[1], player_pos[2]) && world == GetPlayerVirtualWorld(i) && int == GetPlayerInterior(i))
				{
					if(OnlineInfo[i][oListenRadioPears] == 0) PlayAudioStreamForPlayer(i,inputtext,player_pos[0], player_pos[1], player_pos[2],30.0,true);
				}
			}
		}
	}
	if(dialogid == 1488)
	{
		if(response)
		{
			if(listitem == 0) ShowDialog(playerid, 1487, DIALOG_STYLE_INPUT, "Включение музыки", "{ffffff}Ссылка обязательно должна начинаться на [ {ff6347}https:// {ffffff}], а оканчиваться на [ {ff6347}.ogg или .mp3 {ffffff}]\nМузыка будет играть у точки магнитофона и чем дальше от него тем тише. Радиус музыки 30 метров\n\n{ffffff}Укажите {ff9000}Ссылку{ffffff} на трек:", "Продолжить", "Отмена");
			if(listitem == 1)
			{
				new Float: player_pos[3],world,int;
				GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
				world = GetPlayerVirtualWorld(playerid), int = GetPlayerInterior(playerid);
				foreach (Player, i)
				{
					if(IsPlayerInRangeOfPoint(i,300.0,player_pos[0], player_pos[1], player_pos[2]) && world == GetPlayerVirtualWorld(i) && int == GetPlayerInterior(i))
					{
						if(OnlineInfo[i][oListenRadioPears] == 0) StopAudioStreamForPlayer(i);
					}
				}
			}
		}
	}
	return 1;
}

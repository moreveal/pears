#define PI 3.14159265358979323846

// Разбивает число по разрядам, точками
stock FormatNumberWithCommas(number)
{
    const str_len = 64;

    new str[str_len];
	if(number == cellmin)
	{
		str[0] = EOS;
		strcat(str, "-2.147.483.648", str_len);
		return str;
	}
	format(str, str_len, "%d", number);

	for(new i = strlen(str), end = number >= 0 ? 0 : 1; (i -= 3) > end;)
		strins(str, ".", i, str_len);

	return str;
}

enum e_PointDirection: {
    POINT_DIRECTION_FRONT,
    POINT_DIRECTION_BACK,
    POINT_DIRECTION_LEFT,
    POINT_DIRECTION_RIGHT
}

// Переносит координаты на указанную дистанцию и направление от указанной точки (2D)
stock TranslatePoint2D(&Float: x, &Float: y, Float: angle, Float: distance, e_PointDirection: direction = POINT_DIRECTION_FRONT) {
    switch(direction) {
        case POINT_DIRECTION_FRONT:
        {
            x += (distance * floatsin(-angle, degrees));
            y += (distance * floatcos(-angle, degrees));
        }
        case POINT_DIRECTION_BACK:
        {
            x += (-distance * floatsin(-angle, degrees));
            y += (-distance * floatcos(-angle, degrees));
        }
        case POINT_DIRECTION_LEFT:
        {
            x += (distance * floatsin(-angle+270.0, degrees));
            y += (distance * floatcos(-angle+270.0, degrees));
        }
        case POINT_DIRECTION_RIGHT:
        {
            x += (-distance * floatsin(-angle+270.0, degrees));
            y += (-distance * floatcos(-angle+270.0, degrees));
        }
    }

    return 1;
}

// Получает координаты, применяя смещение по вертикали и горизонтали (2D)
stock CalculateOffsetPosition(Float: x, Float: y, Float: angle, Float: verticalDistance, Float: horizontalDistance, &Float: newX, &Float: newY) {
	newX = x + (verticalDistance * floatsin(-angle, degrees)) + (horizontalDistance * floatcos(-angle, degrees));
	newY = y + (verticalDistance * floatcos(-angle, degrees)) - (horizontalDistance * floatsin(-angle, degrees));

	return 1;
}

// Получает смещение по вертикали и горизонтали по паре координат и углу "лицевой" стороны (2D)
stock GetOffsetPosition(Float: x, Float: y, Float: parentX, Float: parentY, Float: angle, &Float: distanceVertical, &Float: distanceHorizontal) {
	new Float: deltaX = x - parentX,
		Float: deltaY = y - parentY;

	distanceHorizontal = deltaX * floatcos(angle, degrees) + deltaY * floatsin(angle, degrees);
	distanceVertical = (deltaX * floatsin(angle, degrees) - deltaY * floatcos(angle, degrees)) * -1.0;

  	return 1;
}

// Переводит угол из градусов в радианы
stock Float: DegToRad(Float: deg) {
    return deg * (PI / 180.0);
}

/*
    Получает координаты с учетом углов поворота (3D)
    Полезно для высчитывания новой позиции одного объекта, относительно другого (родительского).

    x, y, z, rx, ry, rz - текущая позиция родительского объекта
    offsetX, offsetY, offsetZ - оффсеты второго объекта при нулевых угловых поворотах родительского объекта
*/
stock GetRelativePos(Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz, Float: offsetX, Float: offsetY, Float: offsetZ, &Float: resX, &Float: resY, &Float: resZ) {
    new Float: rz_rad = DegToRad(rz),
        Float: ry_rad = DegToRad(ry),
        Float: rx_rad = DegToRad(rx);

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

// Вычисление расстояния от точки до точки (3D)
stock Float: GetDistanceBetweenCoords3d(Float: x, Float: y, Float: z, Float: fx, Float:fy, Float: fz) return floatsqroot(floatpower(fx - x, 2) + floatpower(fy - y, 2) + floatpower(fz - z, 2));

// Вычисление расстояния от точки до точки (2D)
stock Float: GetDistanceBetweenCoords2d(Float: x, Float: y, Float: fx, Float:fy) return floatsqroot(floatpower(fx - x, 2) + floatpower(fy - y, 2));

// Остаток от деления X на Y
stock Float: fmod(Float:x, Float:y) return x - (floatround(x / y, floatround_floor) * y);

// Получает модуль числа
#define abs(%0) ( ( %0 < 0 ) ? (-%0) : (%0) )

// Рандом для диапазона [x; y]
#define random_range(%0,%1) random(%1-%0+1) + %0

// Рандом для диапазона вещественных чисел [x; y]
stock Float:frand(Float:min, Float:max) 
{
    return float(random(0)) / (float(cellmax) / (max - min)) + min; 
}

// Рандомная точка в указанном кубе
stock RandomPointInCube(Float: minx, Float: miny, Float: minz, Float: maxx, Float: maxy, Float: maxz, &Float: x, &Float: y, &Float: z)
{
    x = frand(minx, maxx), y = frand(miny, maxy), z = frand(minz, maxz);
    return 1;
}

// Находится ли точка в указанном кубе
stock IsPointInCube(Float: x, Float: y, Float: z, Float: minx, Float: miny, Float: minz, Float: maxx, Float: maxy, Float: maxz)
{
    return (x >= minx && x <= maxx && y >= miny && y <= maxy && z >= minz && z <= maxz);
}

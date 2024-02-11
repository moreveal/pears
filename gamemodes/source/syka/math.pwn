#define PI 3.14159265358979323846

// Переносит координаты на указанную дистанцию и направление от указанной точки (2D)
stock GetXYInFrontOfPoint(&Float:x, &Float:y, Float:angle, Float:dist) {
	x += (dist * floatsin(-angle, degrees));
	y += (dist * floatcos(-angle, degrees));
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
stock GetDistanceBetweenCoords3d(Float: x, Float: y, Float: z, Float: fx, Float:fy, Float: fz) return floatround(floatsqroot(floatpower(fx - x, 2) + floatpower(fy - y, 2) + floatpower(fz - z, 2)));

// Вычисление расстояния от точки до точки (2D)
stock GetDistanceBetweenCoords2d(Float: x, Float: y, Float: fx, Float:fy) return floatround(floatsqroot(floatpower(fx - x, 2) + floatpower(fy - y, 2)));

// Остаток от деления X на Y
stock Float: fmod(Float:x, Float:y) return x - (floatround(x / y, floatround_floor) * y);

// Получает модуль числа
#define abs(%0) ( ( %0 < 0 ) ? (-%0) : (%0) )

// Рандом для диапазона [x; y]
#define random_range(%0,%1) random(%1-%0+1) + %0

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
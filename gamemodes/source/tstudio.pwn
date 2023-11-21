
#define MAX_GROUP_OBJECT 10 // Максимальное количество сгруппирированных объектов

enum tsINFO
{ 
    tsObjectID[MAX_GROUP_OBJECT],
    Float:tsOffset[3],
    Float:tsPosX[MAX_GROUP_OBJECT],
    Float:tsPosY[MAX_GROUP_OBJECT],
    Float:tsPosZ[MAX_GROUP_OBJECT],
    Float:tsPosRX[MAX_GROUP_OBJECT],
    Float:tsPosRY[MAX_GROUP_OBJECT],
    Float:tsPosRZ[MAX_GROUP_OBJECT],
    tsWorld, // Мир, в котором должны оказаться объекты по окончанию трансформации
    tsInt // Инт, в котором должны оказаться объекты по окончанию трансформации
};
new TSInfo[tsINFO];

/*
Как работает эта шляпа?
Охерительно

1. Добавляем объекты в группу поочерёдно, после каждого создания
        objectid = CreateDynamicObject
        gadd(objectid, world, int);
        objectid = CreateDynamicObject
        gadd(objectid, world, int);
2. Первое создание объектов должно быть где то в скрытом вирт мире
    - Чтобы никто не натыкался на эти расчёты сервера
    - После расчета сервер поставит объекты в нужный инт и мир, если ты указал их в gadd(objectid, world, int))
3. Затем нам нужно сместить центральную точку (У одного объекта и у группы объектов - центр разный)
    - Включаем отбражение вычисления (цифорку 1 в status) MatrixDynamicObjectPos(1, ...
    - Запускаем сервер и пробуем поставить объект, чтобы получить расчёт разницы в printf (Увидишь в server_log)
    - Берём полученные 3 строки и ставим их в нашу работу над MatrixDynamicObjectPos
    - В MatrixDynamicObjectPos убираем цифру 1 и ставим 0
4. Пример всей этой конструкции есть в stock busstationcreate
5. Целую
*/

stock MatrixDynamicObjectPos(status, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    new Float:offx, Float:offy, Float:offz;
    new Float:gCenterX, Float:gCenterY, Float:gCenterZ;
    GetGroupCenter(gCenterX, gCenterY, gCenterZ);

    for(new i = 0; i < MAX_GROUP_OBJECT; i++)
    {
        if(TSInfo[tsObjectID][i] == 0) continue;

        // Корректируем координаты
        offx = (TSInfo[tsPosX][i] + (x - gCenterX)) + TSInfo[tsOffset][0];
        offy = (TSInfo[tsPosY][i] + (y - gCenterY)) + TSInfo[tsOffset][1];
        offz = (TSInfo[tsPosZ][i] + (z - gCenterZ)) + TSInfo[tsOffset][2];

        // Трансформируем объекты
        AttachObjectToPoint_GroupEdit(i, offx, offy, offz, x, y, z, rx, ry, rz, TSInfo[tsPosX][i], TSInfo[tsPosY][i], TSInfo[tsPosZ][i], TSInfo[tsPosRX][i], TSInfo[tsPosRY][i], TSInfo[tsPosRZ][i]);
        
        // Ставим объекты
        SetDynamicObjectPos(TSInfo[tsObjectID][i], TSInfo[tsPosX][i], TSInfo[tsPosY][i], TSInfo[tsPosZ][i]);
        SetDynamicObjectRot(TSInfo[tsObjectID][i], TSInfo[tsPosRX][i], TSInfo[tsPosRY][i], TSInfo[tsPosRZ][i]);

        if(i == 0 && status == 1) // Отображаем смещение центра
        {
            printf("TSInfo[tsOffset][0] = %f;", x - TSInfo[tsPosX][i]);
            printf("TSInfo[tsOffset][1] = %f;", y - TSInfo[tsPosY][i]);
            printf("TSInfo[tsOffset][2] = %f;", z - TSInfo[tsPosZ][i]);
        }

        // Меняем объектам мир и интерьер на необходимый
        Streamer_SetIntData(STREAMER_TYPE_OBJECT, TSInfo[tsObjectID][i], E_STREAMER_WORLD_ID, TSInfo[tsWorld]);
        Streamer_SetIntData(STREAMER_TYPE_OBJECT, TSInfo[tsObjectID][i], E_STREAMER_INTERIOR_ID, TSInfo[tsInt]);
    }

    ClearGroup();
    return 1;
}

stock ClearGroup()
{
    for(new i = 0; i < MAX_GROUP_OBJECT; i++)
    {
        if(TSInfo[tsObjectID][i] == 0) continue;

        TSInfo[tsObjectID][i] = 0;
        TSInfo[tsPosX][i] = 0.0;
        TSInfo[tsPosY][i] = 0.0;
        TSInfo[tsPosZ][i] = 0.0;
        TSInfo[tsPosRX][i] = 0.0;
        TSInfo[tsPosRY][i] = 0.0;
        TSInfo[tsPosRZ][i] = 0.0;
    }
    TSInfo[tsOffset][0] = 0.0;
    TSInfo[tsOffset][1] = 0.0;
    TSInfo[tsOffset][2] = 0.0;
    return 1;
}

stock gadd(objectid, world, int)
{
    for(new i = 0; i < MAX_GROUP_OBJECT; i++)
    {
        if(TSInfo[tsObjectID][i] == 0) 
        {
            TSInfo[tsObjectID][i] = objectid;
            GetDynamicObjectPos(TSInfo[tsObjectID][i], TSInfo[tsPosX][i], TSInfo[tsPosY][i], TSInfo[tsPosZ][i]);
            GetDynamicObjectRot(TSInfo[tsObjectID][i], TSInfo[tsPosRX][i], TSInfo[tsPosRY][i], TSInfo[tsPosRZ][i]);
            break;
        }
    }
    TSInfo[tsWorld] = world;
    TSInfo[tsInt] = int;
    return 1;
}

stock GetGroupCenter(&Float:X, &Float:Y, &Float:Z)
{
	new Float:highX = -9999999.0;
	new Float:highY = -9999999.0;
	new Float:highZ = -9999999.0;

	new Float:lowX  = 9999999.0;
	new Float:lowY  = 9999999.0;
	new Float:lowZ  = 9999999.0;

	new count;

	for(new i = 0; i < MAX_GROUP_OBJECT; i++)
	{
        if(TSInfo[tsObjectID][i] == 0) continue;
        if(IsValidDynamicObject(TSInfo[tsObjectID][i]))
        {
			if(TSInfo[tsPosX][i] > highX) highX = TSInfo[tsPosX][i];
			if(TSInfo[tsPosY][i] > highY) highY = TSInfo[tsPosY][i];
			if(TSInfo[tsPosZ][i] > highZ) highZ = TSInfo[tsPosZ][i];
			if(TSInfo[tsPosX][i] < lowX) lowX = TSInfo[tsPosX][i];
			if(TSInfo[tsPosY][i] < lowY) lowY = TSInfo[tsPosY][i];
			if(TSInfo[tsPosZ][i] < lowZ) lowZ = TSInfo[tsPosZ][i];
			count++;
        }
	}

	if(count < 1) return 0;

	X = (highX + lowX) / 2;
	Y = (highY + lowY) / 2;
	Z = (highZ + lowZ) / 2;
	return 1;
}

stock AttachObjectToPoint_GroupEdit(i, Float:offx, Float:offy, Float:offz, Float:px, Float:py, Float:pz, Float:prx, Float:pry, Float:prz, &Float:RetX, &Float:RetY, &Float:RetZ, &Float:RetRX, &Float:RetRY, &Float:RetRZ, sync_rotation = 1)
{
    new
        Float:g_sin[3],
        Float:g_cos[3],
        Float:off_x,
        Float:off_y,
        Float:off_z;

    EDIT_FloatEulerFix(prx, pry, prz);

    off_x = offx - px; // static offset
    off_y = offy - py; // static offset
    off_z = offz - pz; // static offset

    // Calculate the new position
    EDIT_FloatConvertValue(prx, pry, prz, g_sin, g_cos);
    RetX = px + off_x * g_cos[1] * g_cos[2] - off_x * g_sin[0] * g_sin[1] * g_sin[2] - off_y * g_cos[0] * g_sin[2] + off_z * g_sin[1] * g_cos[2] + off_z * g_sin[0] * g_cos[1] * g_sin[2];
    RetY = py + off_x * g_cos[1] * g_sin[2] + off_x * g_sin[0] * g_sin[1] * g_cos[2] + off_y * g_cos[0] * g_cos[2] + off_z * g_sin[1] * g_sin[2] - off_z * g_sin[0] * g_cos[1] * g_cos[2];
    RetZ = pz - off_x * g_cos[0] * g_sin[1] + off_y * g_sin[0] + off_z * g_cos[0] * g_cos[1];

    if (sync_rotation)
    {
        // Calculate the new rotation
        EDIT_FloatConvertValue(asin(g_cos[0] * g_cos[1]), atan2(g_sin[0], g_cos[0] * g_sin[1]) + TSInfo[tsPosRZ][i], atan2(g_cos[1] * g_cos[2] * g_sin[0] - g_sin[1] * g_sin[2], g_cos[2] * g_sin[1] - g_cos[1] * g_sin[0] * -g_sin[2]), g_sin, g_cos);
 	  	EDIT_FloatConvertValue(asin(g_cos[0] * g_sin[1]), atan2(g_cos[0] * g_cos[1], g_sin[0]), atan2(g_cos[2] * g_sin[0] * g_sin[1] - g_cos[1] * g_sin[2], g_cos[1] * g_cos[2] + g_sin[0] * g_sin[1] * g_sin[2]), g_sin, g_cos);
        EDIT_FloatConvertValue(atan2(g_sin[0], g_cos[0] * g_cos[1]) + TSInfo[tsPosRX][i], asin(g_cos[0] * g_sin[1]), atan2(g_cos[2] * g_sin[0] * g_sin[1] + g_cos[1] * g_sin[2], g_cos[1] * g_cos[2] - g_sin[0] * g_sin[1] * g_sin[2]), g_sin, g_cos);

   	    RetRX = asin(g_cos[1] * g_sin[0]);
		RetRY = atan2(g_sin[1], g_cos[0] * g_cos[1]) + TSInfo[tsPosRY][i];
		RetRZ = atan2(g_cos[0] * g_sin[2] - g_cos[2] * g_sin[0] * g_sin[1], g_cos[0] * g_cos[2] + g_sin[0] * g_sin[1] * g_sin[2]);
    }
}

stock EDIT_FloatEulerFix(&Float:rot_x, &Float:rot_y, &Float:rot_z)
{
    EDIT_FloatGetRemainder(rot_x, rot_y, rot_z);
    if((!floatcmp(rot_x, 0.0) || !floatcmp(rot_x, 360.0))
    && (!floatcmp(rot_y, 0.0) || !floatcmp(rot_y, 360.0)))
    {
        rot_y = 0.00000002;
    }
    return 1;
}

stock EDIT_FloatGetRemainder(&Float:rot_x, &Float:rot_y, &Float:rot_z)
{
    EDIT_FloatRemainder(rot_x, 360.0);
    EDIT_FloatRemainder(rot_y, 360.0);
    EDIT_FloatRemainder(rot_z, 360.0);
    return 1;
}

stock EDIT_FloatRemainder(&Float:remainder, Float:value)
{
    if(remainder >= value)
    {
        while(remainder >= value)
        {
            remainder = remainder - value;
        }
    }
    else if(remainder < 0.0)
    {
        while(remainder < 0.0)
        {
            remainder = remainder + value;
        }
    }
    return 1;
}

stock EDIT_FloatConvertValue(Float:rot_x, Float:rot_y, Float:rot_z, Float:sin[3], Float:cos[3])
{
    sin[0] = floatsin(rot_x, degrees);
    sin[1] = floatsin(rot_y, degrees);
    sin[2] = floatsin(rot_z, degrees);
    cos[0] = floatcos(rot_x, degrees);
    cos[1] = floatcos(rot_y, degrees);
    cos[2] = floatcos(rot_z, degrees);
    return 1;
}
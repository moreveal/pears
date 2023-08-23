
#define MAX_BIZ_WITH_ACTORS 10 // Количество бизнесов с ботами (Пока только ларьки с едой)

new BizTermActor[MAX_BIZ_WITH_ACTORS][MAX_TERMINAL_BIZ];

stock CreateTerminalActor(b, i) // b биз, i терминал
{
    new bizActorId = GetBizTermActorId(b); // Получаем порядковый id бота

    // Если бот уже был создан, сперва удаляем его
    if(BizTermActor[bizActorId][i] != INVALID_VARIABLE)
    {
        DestroyDynamicActor(BizTermActor[bizActorId][i]);
        BizTermActor[bizActorId][i] = INVALID_VARIABLE;
    }

    // Получаем номер терминала из номера бизнеса
    new br = numnrent(b);

    // Получаем точку позади ларька
    new Float:pos[3];
	reartobject(RentObject[br][i], 1.0, pos[0], pos[1], pos[2], RentPos_RZ[br][i]);

    // Создаём бота
    BizTermActor[bizActorId][i] = CreateDynamicActor(205, pos[0], pos[1], pos[2], RentPos_RZ[br][i]-90, true, 100.0, 0, 0, -1, 200.0, -1, 0);
    return 1;
}

stock GetBizTermActorId(b)
{
    new bType = BizType(b), minB, maxB; // Получаем тип бизнеса
    bizTypeMin(bType, minB, maxB); // Получаем диапазон id бизнеса по его типу
    new bizActorId = b - minB; // Вычитаем первое число диапазона бизнеса (Пример: ларьки с едой начинаются с 153)

    return bizActorId;
}

stock reartobject(objectid, Float:distance, &Float:x, &Float:y, &Float:z, Float:rz) // Задняя часть объекта
{
	new Float:rx,Float:ry;
    GetDynamicObjectPos(objectid,x,y,z);
	GetDynamicObjectRot(objectid,rx,ry,rz);
	x=x-distance*floatsin(-rz+90,degrees);
	y=y-distance*floatcos(-rz+90,degrees);
	return 1;
}

stock reloadVariableBizTermActor() // Сбрасываем переменные
{
    for(new b; b < MAX_BIZ_WITH_ACTORS; ++b)
    {
        for(new t; t < MAX_TERMINAL_BIZ; ++t) BizTermActor[b][t] = INVALID_VARIABLE;
    }
}
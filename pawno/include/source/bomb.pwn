
 #define MAX_BOMB 10 // Максимальное количество взрывов или активных бомб
 #define MAX_OBJECT_RUINS 10 // Количество объектов после взрыва

enum boInfo
{
    boStat, // Статус взрыва или бомбы
    Float: boPos[3], // Позиция взрыва
    boWorld, // Вирт мир
    boInterior, // Интерьер
    boObject[MAX_OBJECT_RUINS], // ID объектов после взрыва
    boObjectStat[MAX_OBJECT_RUINS], // Статус объекта
    boQuanObject // Подсчёт текущего количества объектов
}
new RuinsInfo[MAX_BOMB][boInfo];

new SlotInteraction[MAX_REALPLAYERS]; // Записываем всегда и везде объект, с которым происходит взаимодействие


stock PlantBomb(playerid, time)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || HealthAC[playerid] <= 0) return 0;
    if(IsAAntidm(playerid)) return ErrorMessage(playerid, "{FF6347}Вы находитесь в зелёной зоне");
    if(box[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы на ринге");
    if(get_invent4(playerid, 11, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет бомбы");
    if(!IsCreateBomb(playerid)) return 0;

    if(time < 1 || time > 10) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я могу установить таймер не меньше 5 и не больше 10 минут");

    Throw(playerid, 11, 1, time*60, 0, 0, 0); // Кладём предмет на землю
    TakeInvent(playerid, 11, 1, 0, 999);

    if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);

    PlayerPlaySound(playerid,25800,0,0,0);
    format(store,sizeof(store),"{99ff66}Успешный успех. Бомба установлена и взорвётся через %d минут", time);
    SuccessMessage(playerid, store);
    format(store,sizeof(store),"[ Мысли ]: Я установил%s бомбу {0088ff}[ Взрыв произойдёт через %d минут ]", gender(playerid), time);
    SendClientMessage(playerid, COLOR_GREY, store);
	return 1;
}

stock dialogCase_Bomb(playerid, dialogid, response, const inputtext[])
{
	if(dialogid == 1335) // Установка таймера бомбы
	{
        if(response)
        {
            new input;
			if(sscanf(inputtext, "i", input)) return 0;
            PlantBomb(playerid, input);
        }
    }
    return 1;
}

stock IsCreateBomb(playerid) // Создаём бомбу
{
    new quan;
    for(new b; b < MAX_BOMB; ++b)
	{
        if(RuinsInfo[b][boStat] == 0) quan ++;
    }
    if(quan == 0)
    {
        ErrorMessage(playerid, "{FF6347}Вы не можете установить новую бомбу [ Лимит 10 штук на сервере ]");
        return 0;
    }
    return 1;
}

stock CreateRuinsAndExplosion(t) // Взрываем бомбу и создаём руины
{
    new r = -1;
    for(new i; i < MAX_OBJECT_RUINS; ++i)
	{
        if(RuinsInfo[i][boStat] == 1) continue;
        r = i;
    }
    if(r == -1) return 0;
    CreateExplosion(ThrowInfo[t][tX], ThrowInfo[t][tY] , ThrowInfo[t][tZ], 7, 40);
	CreateExplosion(ThrowInfo[t][tX]-2, ThrowInfo[t][tY] , ThrowInfo[t][tZ], 7, 40);
	CreateExplosion(ThrowInfo[t][tX]+2, ThrowInfo[t][tY] , ThrowInfo[t][tZ], 7, 40);
	CreateExplosion(ThrowInfo[t][tX], ThrowInfo[t][tY]-2 , ThrowInfo[t][tZ], 7, 40);
	CreateExplosion(ThrowInfo[t][tX], ThrowInfo[t][tY]+2 , ThrowInfo[t][tZ], 7, 40);
    // Записываем точку взрыва, для создания руин
    RuinsInfo[r][boPos][0] = ThrowInfo[t][tX];
    RuinsInfo[r][boPos][1] = ThrowInfo[t][tY];
    RuinsInfo[r][boPos][2] = ThrowInfo[t][tZ];
    RuinsInfo[r][boWorld] = ThrowInfo[t][tWorld];
    RuinsInfo[r][boInterior] = ThrowInfo[t][tInt];

    DestroyThrow(t); // Удаляем бомбу

    // Вокруг бомбы объекты (0, 1 и т.д.)
    RuinsInfo[r][boObject][0] = CreateDynamicObject(901, RuinsInfo[r][boPos][0],RuinsInfo[r][boPos][1],RuinsInfo[r][boPos][2], 0, 0, 0,RuinsInfo[r][boWorld], RuinsInfo[r][boInterior], -1, 200.00, 200.00);
    RuinsInfo[r][boObjectStat][0] = 11; // 10 раз уебать по камню + 1 для удаления его (Поскольку 0 - камня нет)
    
    RuinsInfo[r][boStat] = 1; // Статус - развалины лежат
    RuinsInfo[r][boQuanObject] = 1; // Количество объектов на руинах
    return 1;
}

stock IsARuins(playerid)
{
    new Float:dist;
    if (WatchSpeed[playerid] > 175) dist = 400;
    else if (WatchSpeed[playerid] > 150) dist = 350;
    else if (WatchSpeed[playerid] >= 100) dist = 200;
    else if (WatchSpeed[playerid] < 100) dist = 150;
    if (IsAPointRuins(playerid,dist) >= 0) 
    {
        Protect_PutPlayerInVehicle(playerid, train, 1);
    }
    return 1;
}

stock IsAPointRuins(playerid, Float:dist) // Находим ближайшие руины от бомбы
{
    new ruinsId = -1;
    for(new r; r < MAX_OBJECT_RUINS; ++r)
	{
        if(RuinsInfo[r][boStat] == 0) continue;
        if(IsPlayerInRangeOfPoint(playerid, dist, RuinsInfo[r][boPos][0], RuinsInfo[r][boPos][1], RuinsInfo[r][boPos][2])
        && GetPlayerVirtualWorld(playerid) == RuinsInfo[r][boWorld] && GetPlayerInterior(playerid) == RuinsInfo[r][boInterior])
        {
            ruinsId = r;
            break;
        }
    }
    return ruinsId;
}
stock IsAPointObjectRuins(playerid,r) // Получаем координаты объекта на руинах
{
    new objectid = -1, Float:object_pos[3];
    for(new slot; slot < MAX_OBJECT_RUINS; ++slot)
    {
        if(RuinsInfo[r][boObjectStat][slot] == 0) continue;
        GetDynamicObjectPos(RuinsInfo[r][boObject][slot], object_pos[0], object_pos[1], object_pos[2]); // Получаем координаты объекта
        if(IsPlayerInRangeOfPoint(playerid, 3.0, object_pos[0], object_pos[1], object_pos[2]))
        {
            objectid = slot;
            break;
        }
    }
    return objectid;
}

stock PressCleanUpRuins(playerid) // Нажимаем на кнопку PKM
{
    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, Aftextdraw[playerid]);
    if(interval < 500) return 0;
    Aftextdraw[playerid] = current_tick;

    new r = IsAPointRuins(playerid, 20.0);
    if(r >= 0)
    {
        if(SlotInteraction[playerid] == 0) SlotInteraction[playerid] = IsAPointObjectRuins(playerid,r) + 1;
        if(SlotInteraction[playerid] > 0)
        {
            new slot = SlotInteraction[playerid]-1;

            if(RuinsInfo[r][boObjectStat][slot] > 0)
            {   
                new Float:object_pos[3];
                GetDynamicObjectPos(RuinsInfo[r][boObject][slot], object_pos[0], object_pos[1], object_pos[2]); // Получаем координаты объекта
                if(!IsPlayerInRangeOfPoint(playerid, 3.0, object_pos[0], object_pos[1], object_pos[2])) SlotInteraction[playerid] = 0;
                
                RuinsInfo[r][boObjectStat][slot] --;
                format(store, sizeof(store), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Pizdic: ~w~%d/10", RuinsInfo[r][boObjectStat][slot]), GameTextForPlayer(playerid,store,2000,3);
			    ApplyAnimation(playerid,"SWORD","sword_4",2.0,0,0,0,0,0,1);

                if(RuinsInfo[r][boObjectStat][slot] == 0) // Мы разрушили камень (сломали его)
                {
                    DestroyDynamicObject(RuinsInfo[r][boObject][slot]);
                    RuinsInfo[r][boQuanObject] --;

                    if(RuinsInfo[r][boQuanObject] <= 0)
                    {
                        RuinsInfo[r][boStat] = 0;
                    }
                    // Здесь проверка есть ли объекты ещё
                }
            }
            else SlotInteraction[playerid] = 0;
        }
    }
    return 1;
}
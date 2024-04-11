
#define MAX_HEALTH_COLLECTOR 100 // ХП транспорта инкассатора

new collector_health = -1;
new collector_city;
new Float:collector_veh_pos[4];

stock UpdateCollectorLabel()
{
    new string[140];

    // Едет
    if(NpcStatus(3))
    {
        if(collector_health > 0) format(string, sizeof(string), "{82CEA3}Инкассаторская Машина\n{cccccc}%s - Правительство", cityName[collector_city]);
        else format(string, sizeof(string), "{82CEA3}Инкассаторская Машина\n{cccccc}%s - Правительство\n\n{FF6347}ОГРАБЛЕНИЕ\n[ N >> Багажник ]", cityName[collector_city]);
    }
    else format(string, sizeof(string), "{82CEA3}Инкассаторская Машина");
    Update3DTextLabelText(collectorlabel, 0x008080FF, string);
    return 1;
}

// Наносим дамаг по машине инкассатора
stock CollectorDamage(playerid, damageid)
{
    collector_health --;
    new string[70];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d/%d", collector_health, MAX_HEALTH_COLLECTOR);
    GameTextForPlayer(playerid, string, 2000, 3);

    if(collector_health <= 0)
    {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Ништяк! Теперь я могу забрать деньги [ N >> Багажник ]");
        SuccessMessage(playerid, "{99ff66}Теперь подойдите к багажнику и заберите мешок с деньгами\n{ffcc66}N >> Багажник");

        new vehicleid = GetPlayerVehicleID(damageid), Float:POS[3];
        GetVehiclePos(vehicleid, collector_veh_pos[0], collector_veh_pos[1], collector_veh_pos[2]);
        GetVehicleZAngle(vehicleid, collector_veh_pos[3]);
        UpdateCollectorLabel();

        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(vehicleid, false, false, alarm, doors, bonnet, boot, objective);

		GetCoordLeftSideVehicle(vehicleid, POS[0], POS[1], POS[2]);
        RemovePlayerFromVehicle(damageid);
        PPSetPlayerPos(damageid, POS[0], POS[1], POS[2]);
        ApplyAnimation(damageid,"ROB_BANK","SHP_HandsUp_Scr",4.1, false, true, true, true, true, SYNC_ALL);

        SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
        ACSetVehiclePos(vehicleid, collector_veh_pos[0], collector_veh_pos[1], collector_veh_pos[2]);
        SetVehicleZAngle(vehicleid, collector_veh_pos[3]);

        SetTimerEx("ResetCollector", 1000, false, "dd", damageid, vehicleid);
    }
    return 1;
}

// Фиксим расположение инкассаторской машины, и анимацию инкассатора
function ResetCollector(damageid, vehicleid)
{
    ApplyAnimation(damageid,"ROB_BANK","SHP_HandsUp_Scr",4.1, false, true, true, true, true, SYNC_ALL);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    ACSetVehiclePos(vehicleid, collector_veh_pos[0], collector_veh_pos[1], collector_veh_pos[2]);
    SetVehicleZAngle(vehicleid, collector_veh_pos[3]);

    SetTimerEx("ComeBackCollector", 180000, true, "d", damageid);
    return 1;
}

// Возвращаем инкассатора домой после ограбления
function ComeBackCollector(damageid)
{
    CollectorEnd(damageid);
    return 1;
}

// Запускаем инкассатора в путь
stock CollectorStart(city = -1, bool:forced = false)
{
    if(forced == false) // forced == false означает, что запуск не принудительный и был выполнен таймером
    {
        new tmphour,tmpminute,tmpsecond;
        gettime(tmphour, tmpminute, tmpsecond);
        if(tmphour <= 12 || tmphour >= 23) return 0; // С 13:00 до 22:00
    }

    if(city == -1) city = random(3);
    collector_health = MAX_HEALTH_COLLECTOR;

    // Кладём мешок с деньгами в инкассаторскую тачку
    new randmoney = ServerInfo[48] - ServerInfo[44];
    new money = ServerInfo[44] + random(randmoney);
    if(money <= 0) money = 12000; // На всякий случай, малоли расчитало на 0 или на отрицательное число
    PutThingBoot(collectorveh, 204, money, 0, 0, 0, 0, 0);

    // Запираем транспорт
    VehInfo[collectorveh][vCarLock] = 1;

    // Пишем уведомление бандам и мафиям
    new string[100];
	format(string, sizeof(string), "** Инкассаторская машина с деньгами отправилась из %s в Правительство **", cityName[city]);
	SendGangMessage(COLOR_ALLDEPT, string);

    format(string, sizeof(string), "** Инкассаторская машина с деньгами отправилась из %s в Правительство **", cityName[city]);
	SendMafiaMessage(COLOR_ALLDEPT, string);

    // Устанавлиаем город
    collector_city = city;
    UpdateDestinationCollector(city);

    // Запускаем NPC
    StartNpc(3);

    UpdateCollectorLabel();
    return 1;
}

// NPC Инкассатор привёз деньги в казну 
stock CollectorEnd(playerid)
{
    if(IsARealNPC(playerid))
    {
        OnNpcSpawn(playerid); // Возвращаем NPC на позицию
        ReloadVehicleNPC(collectorveh);

        // Очищаем багажник инкассаторской тачки
        ClearBootVehcileAll(collectorveh);

        collector_health = -1;
    }
    return 1;
}

// Объясняем, куда инкассатору нужно ехать
stock UpdateDestinationCollector(destination)
{
	new File:File = fopen("collector.txt", io_write); // Открываем или создаём этот файл

	new text[4];
	format(text,sizeof(text),"%d", destination);
	fwrite(File, text); // Записываем все строки в файл
	fclose(File); // Закрываем файл
	return 1;
}

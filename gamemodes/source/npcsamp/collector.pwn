
#define MAX_HEALTH_COLLECTOR 100 // ХП транспорта инкассатора

new collector_health;
new collector_city;

stock UpdateCollectorLabel()
{
    new string[140];

    // Едет
    if(NpcStatus(3))
    {
        if(collector_health > 0) format(string, sizeof(string), "{82CEA3}Инкассаторская Машина\n{cccccc}%s - San Fierro", cityName[collector_city]);
        else format(string, sizeof(string), "{82CEA3}Инкассаторская Машина\n{cccccc}%s - San Fierro\n\n{FF6347}ОГРАБЛЕНИЕ\n[ N >> Багажник ]", cityName[collector_city]);
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

        new Float:pos_veh[3], vehicleid = GetPlayerVehicleID(damageid), Float:POS[3];
        GetVehiclePos(vehicleid, pos_veh[0], pos_veh[1], pos_veh[2]);
        UpdateCollectorLabel();

		GetCoordBonnetVehicle(vehicleid, POS[0], POS[1], POS[2]);
        RemovePlayerFromVehicle(damageid);
        PPSetPlayerPos(damageid, POS[0], POS[1], POS[2]);
        TurnPlayerFaceToVehicle(damageid, vehicleid);
        SetPlayerSpecialAction(damageid,SPECIAL_ACTION_HANDSUP);

        SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
        ACSetVehiclePos(vehicleid, pos_veh[0], pos_veh[1], pos_veh[2]);

        // Открываем икассаторскую тачку
        LockCar(vehicleid, 0);

        SetTimerEx("ComeBackCollector", 60000, false, "d", damageid);
    }
    return 1;
}

// Возвращаем инкассатора домой после ограбления
function ComeBackCollector(damageid)
{
    CollectorEnd(damageid);
    return 1;
}

// Запускаем инкассатора в путь
stock CollectorStart(city = -1)
{
    new tmphour,tmpminute,tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	if(tmphour <= 12 || tmphour >= 23) return 0; // С 13:00 до 22:00

    if(city == -1) city = random(3);
    collector_health = MAX_HEALTH_COLLECTOR;

    // Пишем уведомление бандам и мафиям
    new string[100];
	format(string, sizeof(string), "** Инкассаторская машина с деньгами отправилась из %s в San Fierro **", cityName[city]);
	SendGangMessage(COLOR_ALLDEPT, string);

    format(string, sizeof(string), "** Инкассаторская машина с деньгами отправилась из %s в San Fierro **", cityName[city]);
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

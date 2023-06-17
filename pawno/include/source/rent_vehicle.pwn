
static Float:RentBusPoint[3][3] = { // Координаты аренды автобусов
	{1003.3546,-1351.2242,13.3380}, // 0 ls
	{-1661.5186,1300.3572,7.0391}, // 1 sf
	{1052.3445,2310.6680,10.8363} // 2 lv
};
new bool:create_bus_pos[3];

static Float:RentTruckPoint[3][3] = { // Координаты аренды грузовиков
	{-18.6327,-282.6137,5.4297}, // 0 Дальнобойщики
	{2545.5227,2791.2454,10.8203}, // 1 Нефтеперерабатывающий
	{2248.7615,2790.5532,10.8203} // 2 Гос. склад
};

#define MAX_RENT_TRUCK_VEHICLES 6
new RentTruckVehicleModel[] = // ID Аренды грузового транспорта
{
    499, // Benson
    414, // Mule
    456, // Yankee
    403, // Linerunner
    514, // Tanker
    515 // Roadtrain
};

stock DynamicPickupRent()
{
    // Аренда Автобусов
    for(new i = 0; i < sizeof(RentBusPoint); i++)
    {
        CreateDynamicPickup(2485, 1, RentBusPoint[i][0],RentBusPoint[i][1],RentBusPoint[i][2], 0, 0);
        CreateDynamic3DTextLabel("{ff9000}Транспорт Автобусного Депо\n{333333}[ ALT ]",-1,RentBusPoint[i][0],RentBusPoint[i][1],RentBusPoint[i][2],7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    }

    // Аренда грузовиков
    for(new i = 0; i < sizeof(RentTruckPoint); i++)
    {
        CreateDynamicPickup(2485, 1, RentTruckPoint[i][0],RentTruckPoint[i][1],RentTruckPoint[i][2], 0, 0);
        CreateDynamic3DTextLabel("{ff9000}Аренда Грузового Транспорта\n{333333}[ ALT ]",-1,RentTruckPoint[i][0],RentTruckPoint[i][1],RentTruckPoint[i][2],7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    }
	return 1;
}

stock agetbus(playerid)
{
    if(busdrivers >= MAX_BUSDRIVER) return ErrorMessage(playerid, "{FF6347}Сейчас на дежурстве 30 водителей автобусов [ Приходите на работу немного позже ]");
    
    if(IsPlayerInRangeOfPoint(playerid,3.0,RentBusPoint[0][0],RentBusPoint[0][1],RentBusPoint[0][2])) DP[0][playerid] = 0;
    else if(IsPlayerInRangeOfPoint(playerid,3.0,RentBusPoint[1][0],RentBusPoint[1][1],RentBusPoint[1][2])) DP[0][playerid] = 1;
    else if(IsPlayerInRangeOfPoint(playerid,3.0,RentBusPoint[2][0],RentBusPoint[2][1],RentBusPoint[2][2])) DP[0][playerid] = 2;
    
	ShowDialog(playerid,1191,2,"{ff9000}Транспорт Автобусного Депо", "Bus (Автобус)","Выбрать","Выход");
	return 1;
}

stock IsARentBusPos(playerid) // Проверка рядом с арендой автобусов
{
    if((IsPlayerInRangeOfPoint(playerid,3.0,RentBusPoint[0][0],RentBusPoint[0][1],RentBusPoint[0][2]) 
    || IsPlayerInRangeOfPoint(playerid,3.0,RentBusPoint[1][0],RentBusPoint[1][1],RentBusPoint[1][2])
	|| IsPlayerInRangeOfPoint(playerid,3.0,RentBusPoint[2][0],RentBusPoint[2][1],RentBusPoint[2][2]))
	&& GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) return 1;
	return 0;
}

stock agettruck(playerid)
{
    new quan;
    DP[2][playerid] = 0; // Аренда Грузовиков
    format(lines,sizeof(lines),""); // Очищаем Lines

    format(line,sizeof(line),"Транспорт\tСтоимость Аренды\tВремя Аренды"), strcat(lines,line);
    for(new i = 0; i < MAX_RENT_TRUCK_VEHICLES; i++)
    {
        List[quan][playerid] = RentTruckVehicleModel[i];
        quan ++;
        format(line,sizeof(line),"\n{ff9000}%s\t{99ff66}%d$\t{cccccc}1 Час",vehName[RentTruckVehicleModel[i]], VehGos[RentTruckVehicleModel[i]-400]/10), strcat(lines,line);
    }
    ShowDialog(playerid,1288,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Аренда Грузового Транспорта",lines,"Выбрать","Назад");
	return 1;
}

stock IsARentTruckPos(playerid) // Проверка рядом с арендой грузовиков
{
    if((IsPlayerInRangeOfPoint(playerid,3.0,RentTruckPoint[0][0],RentTruckPoint[0][1],RentTruckPoint[0][2]) 
    || IsPlayerInRangeOfPoint(playerid,3.0,RentTruckPoint[1][0],RentTruckPoint[1][1],RentTruckPoint[1][2])
	|| IsPlayerInRangeOfPoint(playerid,3.0,RentTruckPoint[2][0],RentTruckPoint[2][1],RentTruckPoint[2][2]))
	&& GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) return 1;
    return 0;
}

stock CreateRentVehicle(playerid, vehicleModel, color1, color2, statusLabel, unix, price)
{
    if(price > 0)
    {
        oGivePlayerMoney(playerid, -price);
        putkazna(2, price);
        MoneyLog("rentcar", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, "");
    }

	new Float:pos[4];
	GetPlayerPos(playerid, pos[0],pos[1],pos[2]);
	GetPlayerFacingAngle(playerid,pos[3]);

	new newcar;
	newcar = PP_CreateVehicle(newcar,vehicleModel,pos[0],pos[1],pos[2],pos[3],color1,color2,300,0);
	Gas[newcar] = 100;
	VehInfo[newcar][vAgetid] = playerid;
	VehInfo[newcar][vRent] = unix+3600;
	VehInfo[newcar][vBiz] = 0;
	VehInfo[newcar][vBizItem] = 0;
	Cars[newcar] = 53;

	if(statusLabel == 1)
	{
		new tyear, tmonth, tday, thour, tminute, tsecond;
	 	stamp2datetime(VehInfo[newcar][vRent], tyear, tmonth, tday, thour, tminute, tsecond, 3);
	   	VehInfo[newcar][v3dstat] = 4000;
		format(store,sizeof(store),"{cccccc}Аренда до {0088ff}%02d:%02d\n{333333}%s", thour, tminute, PlayerInfo[playerid][pName]);
	    VehLabel[newcar] = CreateDynamic3DTextLabel(store,0xfaf75c99,pos[0],pos[1],pos[2],15.0,INVALID_PLAYER_ID, newcar,0,0,0);
	}

	Protect_PutPlayerInVehicle(playerid, newcar, 0);
	CreateRent_Player(playerid, unix, newcar, color1, 100, vehicleModel, 0, 0, pos[0],pos[1],pos[2],pos[3]);
	return 1;
}

stock CreateRent_Player(playerid, unix, newcar, color, benz, model, biz, item, Float:x, Float:y, Float:z, Float:a)
{
	new sl;
	if(PlayerInfo[playerid][pRent][0] < unix) sl = 0;
	else sl = 1;
	PlayerInfo[playerid][pRent][sl] = unix+3600;
	PlayerInfo[playerid][pRentVeh][sl] = newcar;
	PlayerInfo[playerid][pRentCol][sl] = color;
	PlayerInfo[playerid][pRentBenz][sl] = benz;
	PlayerInfo[playerid][pRentModel][sl] = model;
	PlayerInfo[playerid][pRentBiz][sl] = biz;
	PlayerInfo[playerid][pRentItem][sl] = item;
	PlayerInfo[playerid][pRent_X][sl] = x;
	PlayerInfo[playerid][pRent_Y][sl] = y;
	PlayerInfo[playerid][pRent_Z][sl] = z;
	PlayerInfo[playerid][pRent_A][sl] = a;
	VehInfo[newcar][vRentSlot] = sl;
	if(sl == 0) mysql_save(playerid, 46);
	else if(sl == 1)  mysql_save(playerid, 65);
	return 1;
}

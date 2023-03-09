
static Float:RentBusPoint[3][3] = { // Координаты аренды автобусов
	{1003.3546,-1351.2242,13.3380}, // 0 ls
	{-1661.5186,1300.3572,7.0391}, // 1 sf
	{1052.3445,2310.6680,10.8363} // 2 lv
};
new bool:create_bus_pos[3];

stock DynamicPickupRent()
{
    CreateDynamicPickup(2485, 1, RentBusPoint[0][0],RentBusPoint[0][1],RentBusPoint[0][2], 0, 0);
    CreateDynamicPickup(2485, 1, RentBusPoint[1][0],RentBusPoint[1][1],RentBusPoint[1][2], 0, 0);
    CreateDynamicPickup(2485, 1, RentBusPoint[2][0],RentBusPoint[2][1],RentBusPoint[2][2], 0, 0);
    CreateDynamic3DTextLabel("{ff9000}Транспорт Автобусного Депо\n{333333}[ ALT ]",-1,RentBusPoint[0][0],RentBusPoint[0][1],RentBusPoint[0][2],7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    CreateDynamic3DTextLabel("{ff9000}Транспорт Автобусного Депо\n{333333}[ ALT ]",-1,RentBusPoint[1][0],RentBusPoint[1][1],RentBusPoint[1][2],7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    CreateDynamic3DTextLabel("{ff9000}Транспорт Автобусного Депо\n{333333}[ ALT ]",-1,RentBusPoint[2][0],RentBusPoint[2][1],RentBusPoint[2][2],7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
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

stock IsARentBusPos(playerid)
{
    if((IsPlayerInRangeOfPoint(playerid,3.0,RentBusPoint[0][0],RentBusPoint[0][1],RentBusPoint[0][2]) || IsPlayerInRangeOfPoint(playerid,3.0,RentBusPoint[1][0],RentBusPoint[1][1],RentBusPoint[1][2])
	|| IsPlayerInRangeOfPoint(playerid,3.0,RentBusPoint[2][0],RentBusPoint[2][1],RentBusPoint[2][2]))
	&& GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) return 1;
	return 0;
}

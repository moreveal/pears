
static Float:JobBusDepo[3][3] = { // Координаты работы в автобусном депо
	{992.3076,-1343.8839,13.6369}, // 0 ls
	{-1654.2604,1288.7062,7.2908}, // 1 sf
	{1065.5687,2306.5149,11.0953} // 2 lv
};

stock DynamicPickupJobBus()
{
    CreateDynamicPickup(1210, 1, JobBusDepo[0][0],JobBusDepo[0][1],JobBusDepo[0][2], 0, 0); // автобусное депо ls
    CreateDynamicPickup(1210, 1, JobBusDepo[1][0],JobBusDepo[1][1],JobBusDepo[1][2], 0, 0); // автобусное депо sf
    CreateDynamicPickup(1210, 1, JobBusDepo[2][0],JobBusDepo[2][1],JobBusDepo[2][2], 0, 0); // автобусное депо lv
    CreateDynamic3DTextLabel("{ff9000}Автобусное Депо\n{cccccc}[ ALT ]",-1,JobBusDepo[0][0],JobBusDepo[0][1],JobBusDepo[0][2],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    CreateDynamic3DTextLabel("{ff9000}Автобусное Депо\n{cccccc}[ ALT ]",-1,JobBusDepo[1][0],JobBusDepo[1][1],JobBusDepo[1][2],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    CreateDynamic3DTextLabel("{ff9000}Автобусное Депо\n{cccccc}[ ALT ]",-1,JobBusDepo[2][0],JobBusDepo[2][1],JobBusDepo[2][2],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
	return 1;
}

stock IsAJobBusDepoPos(playerid)
{
    if((IsPlayerInRangeOfPoint(playerid,2.0,JobBusDepo[0][0],JobBusDepo[0][1],JobBusDepo[0][2]) || IsPlayerInRangeOfPoint(playerid,2.0,JobBusDepo[1][0],JobBusDepo[1][1],JobBusDepo[1][2])
	|| IsPlayerInRangeOfPoint(playerid,2.0,JobBusDepo[2][0],JobBusDepo[2][1],JobBusDepo[2][2])) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT
	&& GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) return 1;
	return 0;
}

stock jobbus(playerid)
{
	if(PlayerInfo[playerid][pPlacement] >= 1 && PlayerInfo[playerid][pPlacement] != 10) return StopJob(playerid);
	
	format(lines,sizeof(lines),""); // Очищаем Lines
	
	if(ServerInfo[53] == 9) format(line,sizeof(line),"{99ff66}Повышенная Оплата: Активна \t \n"), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}Стандартная Оплата \t \n"), strcat(lines,line);
	format(line,sizeof(line),"{0088ff}Как заработать? \t \n"), strcat(lines,line);
	if(GetPVarInt(playerid,"job_stat") != 12) format(line,sizeof(line),"{ff9000}Начать Работу \t \n"), strcat(lines,line);
	else if(GetPVarInt(playerid,"job_stat") == 12) format(line,sizeof(line),"{ff9000}Завершить Работу \t \n"), strcat(lines,line);
	format(line,sizeof(line),"{99ff66}Получить Зарплату \t {00cc00}[ %d$ ]\n", PlayerInfo[playerid][pSalary]), strcat(lines,line);
	ShowDialog(playerid,1190,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Автобусное Депо",lines,"Выбор","Отмена");
	return 1;
}

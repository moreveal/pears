
new PlayerText3D:RadioVehLabel[MAX_REALPLAYERS][MAX_CARS];
new bool:RadioLabelBusy[MAX_REALPLAYERS][MAX_CARS];

CMD:radio(playerid)
{
    PlayerPlaySound(playerid,1150,0,0,0);
    new vehicleid = Protect_Veh[playerid];
    new line[100], lines[300];
    if (vehicleid == 9999)
    {
        if(OnlineInfo[playerid][oListenRadioPears] == 1) format(line,sizeof(line),"{cccccc}Радио Pears \t{99ff66}[ On ]"), strcat(lines,line);
        else format(line,sizeof(line),"{cccccc}Радио Pears \t{FF6347}[ Off ]"), strcat(lines,line);
    }
	else
    {
        if (IsVehicleHavingMusicStream(vehicleid)) format(line,sizeof(line),"{cccccc}Радио Pears в Машине \t{99ff66}[ On ]"), strcat(lines,line);
        else format(line,sizeof(line),"{cccccc}Радио Pears в Машине \t{FF6347}[ Off ]"), strcat(lines,line);
    }
    format(line,sizeof(line),"\n{cccccc}Диджеи Online {99ff66}>>\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Связаться с Dj\t"), strcat(lines,line);
    ShowDialog(playerid,928,DIALOG_STYLE_TABLIST,"{ff9000}Музыка",lines,"Выбор","Отмена");
    return 1;
}

stock CreateRadioVehicleLabel(playerid, vehicleid, Float:dist)
{
	if(!IsPlayerSyncModels(playerid)) return false; // У игрока нет лаунчера
	if(RadioLabelBusy[playerid][vehicleid] == true) return 1;

	RadioVehLabel[playerid][vehicleid] = CreatePlayer3DTextLabel(playerid, "{BE98E7}Играет Музыка\n{777777}Настройки F11", 0xA9C4E4FF, 0.0,0.0,0.0 + 0.2, dist, INVALID_PLAYER_ID, vehicleid, false);
	RadioLabelBusy[playerid][vehicleid] = true;
	return 1;
}

stock DestroyRadioVehicleLabel(playerid, vehicleid)
{
	if(!IsPlayerSyncModels(playerid)) return false; // У игрока нет лаунчера

	if(RadioLabelBusy[playerid][vehicleid] == true)
	{
		DeletePlayer3DTextLabel(playerid, RadioVehLabel[playerid][vehicleid]);
		RadioLabelBusy[playerid][vehicleid] = false;
	}
	return 1;
}

stock DestroyAllRadioVehicleLabels(playerid)
{
	for(new v = 0; v < MAX_CARS; v++)
	{
		if(RadioLabelBusy[playerid][v] == true)
		{
			DeletePlayer3DTextLabel(playerid, RadioVehLabel[playerid][v]);
			RadioLabelBusy[playerid][v] = false;
		}
	}
	return 1;
}

// Включаем лейбл всем игрокам, кто видит этот транспорт
stock CreateRadioVehicleLabelAround(vehicleid)
{
    foreach(Player,i)
	{
        if (IsVehicleStreamedIn(vehicleid, i))
        {
	        if(IsVehicleHavingMusicStream(vehicleid) && IsPlayerSyncModels(i)) CreateRadioVehicleLabel(i, vehicleid, 12.0);
        }
    }
    return true;
}

// Удаляем лейблы всех игроков, кто видит этот транспорт
stock DestroyRadioVehicleLabelAround(vehicleid)
{
    foreach(Player,i)
	{
        if (IsVehicleStreamedIn(vehicleid, i))
        {
            if(RadioLabelBusy[i][vehicleid] == true) DestroyRadioVehicleLabel(i, vehicleid);
        }
    }
    return true;
}

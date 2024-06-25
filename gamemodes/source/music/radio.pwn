
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

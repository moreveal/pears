#define MAX_APPLICATION_THEFT 100




stock FindCarInWareHouse(playerid)
{
    ClearAnimations(playerid);
    ApplyAnimation(playerid,"SHOP","SHP_Rob_React",4.1,0,1,1,1,1);
    new world = GetPlayerVirtualWorld(playerid)-80;
    new car = PlayerInfo[playerid][pTheft];
    if(VehInfo[car][vSklad] == world /*&& VehInfo[car][vTheft] == 2*/)
    {
        VehInfo[car][vSklad] = 0;
        SaveCar(car);
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я нашел угнанную машину. Нужно вернутся в участок и сообщить владельцу об этом!");
        SuccessMessage(playerid,"Вы нашли угнанную машину.\nНужно вернутся в участок и сдать дело.");
    }
    else return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чёрт... Тут нет нужной машины!"),SuccessMessage(playerid,"Вам необходимо продолжить поиски в других складах");
    return 1;
}

stock ListFindCar(playerid)
{
    format(lines,sizeof(lines),""); // Очищаем Lines
	format(line,sizeof(line),"{cccccc}Название \t "), strcat(lines,line);
    new quan;
	for(new i = 0; i < SKOKOCAROV; i++)
	{
		List[i][playerid] = 0, ListParam[i][playerid] = 0; // Очищаем листы
        if(VehInfo[i][vTheft] > 0)
        {
            format(line,sizeof(line),"\n{ff9000}%d. %s \t ", i + 1, vehName[VehInfo[i][vModel]]), strcat(lines,line);
            List[quan][playerid] = i;
            ListParam[quan][playerid] = VehInfo[i][vNewid];
            quan ++;
        }
	}
    ShowDialog(playerid,1352,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Угнанный Транспорт",lines,"Выбрать","Отмена");
    return 1;
}
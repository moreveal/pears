
// Высаживаем заключенных
stock ExitPrisonersFromBus(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    foreach(Player,i)
	{
        if(PlayerInfo[i][pJailed] == 0) continue;
        if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == vehicleid)
        {
            PlayerInfo[i][pJailed] = 1;
            PPSpawnPlayer(i);
            SuccessMessage(i, "{99ff66}Вас конвоировали в областную тюрьму San Andreas");
        }
    }

    // Запускаем таймер, чтобы вернуть автобус на место
    SetTimerEx("ComeBackPrisonBus", 10000, false, "dd", playerid, vehicleid);
    return 1;
}

function ComeBackPrisonBus(playerid, vehicleid) // Возвращаем автобус на место
{
    ReloadVehicleNPC(vehicleid);

    // Оповещение всем, кто сидит в КПЗ
    new line[70],lines[140];
    format(line,sizeof(line),"{ff9000}Тюремный Автобус готов доставить вас в Областную Тюрьму"), strcat(lines,line);
    format(line,sizeof(line),"{ffcc66}Подойдите и нажмите красную кнопку"), strcat(lines,line);

    foreach(Player,i)
	{
        if(GetPVarInt(i,"afksystem") >= 5) continue;
        if(PlayerInfo[i][pJailTime] <= 600) continue;
        if(vehicleid == prisonbus_LS && PlayerInfo[i][pJailed] == 3 // КПЗ LS
            || vehicleid == prisonbus_SF && PlayerInfo[i][pJailed] == 9) // КПЗ SF
        {
            ShowDialog(i,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
            SendClientMessage(i, COLOR_GREY,"[ Мысли ]: Что мне тут делать? Я могу отправиться в областную тюрьму");
        }
    }
    return 1;
}

stock ReloadVehicleNPC(vehicleid)
{
    PP_SetVehicleToRespawn(vehicleid);
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, false, false, alarm, doors, bonnet, boot, objective);
    return 1;
}

function PrisonGo(vehicleid) // Запускаем автобус
{
    if(vehicleid == prisonbus_LS)
    {
        StartNpc(NPCInfo[0][npcID]);
        TimerPrisonBusLS = 0;
    }
    else if(vehicleid == prisonbus_SF)
    {
        StartNpc(NPCInfo[1][npcID]);
        TimerPrisonBusSF = 0;
    }
    return 1;
}

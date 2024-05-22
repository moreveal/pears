
#define MAX_FLIP_TRIGER 3
#define UNIX_FLIP_TRIGER 10
#define THINGID_FLIP 225

stock CheckFlipVehicle(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:rotation[3];
    GetVehicleRotation(vehicleid, rotation[0], rotation[1], rotation[2]);

    if(IsACar(VehInfo[vehicleid][vModel]))
    {
        if(rotation[1] >= 120.0 && rotation[1] <= 240.0)
        {
            if(OnlineInfo[playerid][oFlipTriger] <= 0) 
            {
                if(OnlineInfo[playerid][oFlipVeh] != vehicleid) OnlineInfo[playerid][oFlipVeh] = vehicleid;
                OnlineInfo[playerid][oFlipVehHealth] = VehInfo[vehicleid][vHealth];
            }

            OnlineInfo[playerid][oFlipTriger] ++;
            if(OnlineInfo[playerid][oFlipTriger] >= MAX_FLIP_TRIGER) 
            {
                new inventSlot = get_invent2_Slot(playerid, THINGID_FLIP, 0);
                if(inventSlot >= 0)
                {
                    FlipVehicle(vehicleid);
                    ACSetVehicleHealth(vehicleid, OnlineInfo[playerid][oFlipVehHealth]);
                    TakeInvent(playerid, THINGID_FLIP, 1, 0, inventSlot, false); // Забираем один домкрат
                }
                OnlineInfo[playerid][oFlipVeh] = 0;
            }
        }
        else if(OnlineInfo[playerid][oFlipTriger] > 0) OnlineInfo[playerid][oFlipTriger] --;
    }
    return 1;
}

stock showDialogSettingFlip(playerid)
{
    new line[80];
    if(PlayerInfo[playerid][pAutoFlipOff] == false) format(line,sizeof(line),"{ff9000}Автопереворот Автомобиля {99ff66}[ On ]");
    else format(line,sizeof(line),"{ff9000}Автопереворот Автомобиля {FF6347}[ Off ]");
    ShowDialog(playerid,437,DIALOG_STYLE_TABLIST,"{ff9000}Домкрат",line,"Выбрать","Отмена");
    return 1;
}

stock ChangeFlipVehicle(playerid)
{
    if(AntiFloodMysqlRequest(playerid, 3, true)) return 1;
    if(PlayerInfo[playerid][pAutoFlipOff] == false) PlayerInfo[playerid][pAutoFlipOff] = true;
    else PlayerInfo[playerid][pAutoFlipOff] = false;

    new f_str[120];
    format(f_str,sizeof(f_str),"UPDATE `pp_igroki` SET `pAutoFlipOff` = '%i' WHERE `user_id` = '%d'", 
        PlayerInfo[playerid][pAutoFlipOff], PlayerInfo[playerid][pID]);
    query_empty(pearsq, f_str);
    return 1;
}

stock FlipVehicle(vehicleid)
{
    new Float:pos[4];
    GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
    GetVehicleZAngle(vehicleid, pos[3]);

    ACSetVehiclePos(vehicleid, pos[0], pos[1], pos[2] + 1.0); // Ставим в ту-же позицию, но чуточек выше
    SetVehicleZAngle(vehicleid, pos[3]);
    return 1;
}

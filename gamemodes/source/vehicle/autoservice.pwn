
stock ClickTextDraw_Autoservice(playerid, Text:clickedid) // Кликаем по текстдравам
{
    if(clickedid == TuningDraw[17]) // Кнопка Test Drive
	{
        PlayerPlaySound(playerid,17803,0,0,0);
        PlayerPlaySound(playerid,30800,0,0,0);
        openTestDrive_Autoservice(playerid);
        return 1;
    }
    return 0;
}

stock showPlayerAutoserviceMenu(playerid)
{
    playerDefaultCameraAutoservice(playerid);
    PlayerPlaySound(playerid, 30801, 0.0, 0.0, 0.0);
    TogglePlayerControllable(playerid, false);

    S_SetPlayerVirtualWorld(playerid,playerid+1,223);
    SetPlayerInterior(playerid,223);

    OnlineInfo[playerid][oShowInterface] = 20; // Интерфейс автосервиса
    TextDrawShowForPlayer(playerid, TuningDraw[0]);
    TextDrawShowForPlayer(playerid, TuningDraw[1]);
    TextDrawShowForPlayer(playerid, TuningDraw[2]);
    TextDrawShowForPlayer(playerid, TuningDraw[3]);
    TextDrawShowForPlayer(playerid, TuningDraw[4]);
    TextDrawShowForPlayer(playerid, TuningDraw[5]);
    TextDrawShowForPlayer(playerid, TuningDraw[6]);
    TextDrawShowForPlayer(playerid, TuningDraw[7]);
    TextDrawShowForPlayer(playerid, TuningDraw[8]);
    TextDrawShowForPlayer(playerid, TuningDraw[9]);
    TextDrawShowForPlayer(playerid, TuningDraw[10]);
    TextDrawShowForPlayer(playerid, TuningDraw[17]);
    TextDrawShowForPlayer(playerid, TuningDraw[18]);
    SelectColorDraw(playerid);
    NoAnim[playerid] = 1;

    SetPVarInt(playerid,"tunstat",0);
    if(PlayerInfo[playerid][pDrawVisible][7] == false && setting_pos_draw[playerid] != 8 && setting_size_draw[playerid] != 8) CloseVehSpeed(playerid);
    PlayerTextDrawHide(playerid, PlayerHintDraw[0][playerid]), PlayerTextDrawHide(playerid, PlayerHintDraw[1][playerid]);
    return 1;
}

stock playerDefaultCameraAutoservice(playerid)
{
    new vehicleid = OnlineInfo[playerid][oAutoserviceVeh];
    new model = VehInfo[vehicleid][vModel];
    if(IsAMoto(model))
    {
        InterpolateCameraPos(playerid, -1131.184082, 2869.335693, 919.213500, -1131.184082, 2869.335693, 919.213500, 1000);
        InterpolateCameraLookAt(playerid, -1136.030883, 2868.354980, 918.474060, -1136.030883, 2868.354980, 918.474060, 1000);
    }
    else if(IsABig(model))
    {
        InterpolateCameraPos(playerid, -1124.197387, 2869.546875, 920.400634, -1124.197387, 2869.546875, 920.400634, 1000);
        InterpolateCameraLookAt(playerid, -1125.660156, 2874.268066, 919.644958, -1125.660156, 2874.268066, 919.644958, 1000);
    }
    else
    {
        InterpolateCameraPos(playerid, -1130.384399, 2875.142333, 919.587463, -1130.384399, 2875.142333, 919.587463, 1000);
        InterpolateCameraLookAt(playerid, -1135.326416, 2874.769531, 918.925659, -1135.326416, 2874.769531, 918.925659, 1000);
    }
    return 1;
}

stock vehiclePositionAutoservice(vehicleid)
{
    if(VehInfo[vehicleid][vTestDrive] > 0)
    {
        new playerid = VehInfo[vehicleid][vTestDrive] - 1;
        new model = VehInfo[vehicleid][vModel];
        if(IsAMoto(model))
        {
            ACSetVehiclePos(vehicleid,-1137.9078,2867.5972,917.8622);
            SetVehicleZAngle(vehicleid, 250.4064);
        }
        else if(IsABig(model))
        {
            ACSetVehiclePos(vehicleid,-1126.8308,2880.2805,918.4659);
            SetVehicleZAngle(vehicleid, 179.0594);
        }
        else
        {
            ACSetVehiclePos(vehicleid,-1138.4857,2875.1323,917.9734);
            SetVehicleZAngle(vehicleid, 249.8055);
        }
        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(vehicleid, false, false, alarm, doors, bonnet, boot, objective);
        VehInfo[vehicleid][vEngine] = 0;
        VehInfo[vehicleid][vLights] = 0;
        SetVehicleVirtualWorld(vehicleid, playerid+1);
        LinkVehicleToInterior(vehicleid, 223);
    }
    return 1;
}

stock openTestDrive_Autoservice(playerid)
{
    if(gAutosalon[playerid] == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Вы не находитесь в автосервисе");
    new vehicleid = GetPlayerVehicleID(playerid);
    if(Cars[vehicleid] != 88) return ErrorMessage(playerid, "{FF6347}Тест драйв доступен только для личного транспорта");
    if(GetPVarInt(playerid,"tunstat") > 0) return ErrorMessage(playerid, "{FF6347}Сохраните или отмените выбранную деталь\n{ffcc66}Тест драйв доступен только для проверки характеристик транспорта");
    VehShopInfo[playerid][vsTest] = true;

    HidePlayerDialog(playerid); // Сбрасываем диалоговые окна
    hideDraw_Autoservice(playerid); // Удаляем текстдравы
    OnlineInfo[playerid][oShowInterface] = 0;

    CancelSelectTextDraw(playerid); // Убираем мышку
	TogglePlayerControllable(playerid, true); // Unfreeze

    SetPlayerInterior(playerid, 0);
    LinkVehicleToInterior(vehicleid, 0);

    positionVehicleTestDrive(vehicleid);

    SetCameraBehindPlayer(playerid); // Возвращаем камеру
    SuccessMessage(playerid, "{99ff66}Вы запустили Test Drive {cccccc}[ Выйти: кнопка N ]");
    return 1;
}

// Закрываем текстдравы автосервиса
stock hideDraw_Autoservice(playerid)
{
    TextDrawHideForPlayer(playerid, TuningDraw[0]);
    TextDrawHideForPlayer(playerid, TuningDraw[1]);
    TextDrawHideForPlayer(playerid, TuningDraw[2]);
    TextDrawHideForPlayer(playerid, TuningDraw[3]);
    TextDrawHideForPlayer(playerid, TuningDraw[4]);
    TextDrawHideForPlayer(playerid, TuningDraw[5]);
    TextDrawHideForPlayer(playerid, TuningDraw[6]);
    TextDrawHideForPlayer(playerid, TuningDraw[7]);
    TextDrawHideForPlayer(playerid, TuningDraw[8]);
    TextDrawHideForPlayer(playerid, TuningDraw[9]);
    TextDrawHideForPlayer(playerid, TuningDraw[10]);
    TextDrawHideForPlayer(playerid, TuningDraw[12]);
    TextDrawHideForPlayer(playerid, TuningDraw[13]);
    TextDrawHideForPlayer(playerid, TuningDraw[14]);
    TextDrawHideForPlayer(playerid, TuningDraw[15]);
    TextDrawHideForPlayer(playerid, TuningDraw[16]);
    TextDrawHideForPlayer(playerid, TuningDraw[17]);
    TextDrawHideForPlayer(playerid, TuningDraw[18]);
    return 1;
}
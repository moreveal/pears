
new AudioStream:VehicleMusicAudioStream[SKOKOCAROV] = { INVALID_AUDIOSTREAM, ... };

stock IsVehicleHavingMusicStream(vehicleid)
{
    if (vehicleid <= 0 || vehicleid >= SKOKOCAROV) return false;
    return VehicleMusicAudioStream[vehicleid] != INVALID_AUDIOSTREAM;
}

stock CreateVehicleMusicStream(vehicleid, const url[], bool:withTiming = true)
{
    if (IsVehicleHavingMusicStream(vehicleid)) {
        return SetVehicleMusicStreamUrl(vehicleid, url, withTiming);
    }

    { // Создание аудиострима
        VehicleMusicAudioStream[vehicleid] = CreateAudioStream();
        AttachAudioStreamToVehicle(VehicleMusicAudioStream[vehicleid], vehicleid); // Аттачим к тачке

        SetAudioStreamAutostreamDist(VehicleMusicAudioStream[vehicleid], 12.0); // Максимальная дистанция
        SetAudioStreamMinDistance(VehicleMusicAudioStream[vehicleid], 2.0); // Минимальная дистанция (менее громкость не меняется)
        SetAudioStreamMaxDistance(VehicleMusicAudioStream[vehicleid], 10.0); // Макимальная дистанция

        SetAudioStreamAutostreamState(VehicleMusicAudioStream[vehicleid], true); // Врубать музло когда игрок входит в зону стрима
        SetAudioStreamSpatialState(VehicleMusicAudioStream[vehicleid], true); // 3d звук

        CreateRadioVehicleLabelAround(vehicleid);
    }

    SetVehicleMusicStreamUrl(vehicleid, url, withTiming);
    return true;
}

stock SetVehicleMusicStreamUrl(vehicleid, const url[], bool:withTiming = true)
{
    if (!IsVehicleHavingMusicStream(vehicleid)) return false;

    SetAudioStreamUrl(VehicleMusicAudioStream[vehicleid], url, withTiming);
    return true;
}

stock DestroyVehicleMusicStream(vehicleid)
{
    if (!IsVehicleHavingMusicStream(vehicleid)) return false;

    DeleteAudioStream(VehicleMusicAudioStream[vehicleid]);
    VehicleMusicAudioStream[vehicleid] = INVALID_AUDIOSTREAM;
    DestroyRadioVehicleLabelAround(vehicleid);
    return true;
}

CMD:music(playerid, const params[])
{
    if (PlayerInfo[playerid][pSoska] == 0 && PlayerInfo[playerid][pMedia] == 0) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    
    new vehicleid = Protect_Veh[playerid];
    if (vehicleid == 9999) return ErrorMessage(playerid, "{FF6347}Вы не за рулём транспорта");

    // Выключаем музло, если оно играет в транспорте
    if (IsVehicleHavingMusicStream(vehicleid)) {
        DestroyVehicleMusicStream(vehicleid);
        ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, "{ffcc00}*", "{ffcc66}Музыка в транспорте {FF6347}выключена", "*", "");
        return true;
    }

    new tmp[120];
	if (sscanf(params, "s[120]", tmp)) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Музыка в транспорте [ /music Ссылка ]");
    CreateVehicleMusicStream(vehicleid, tmp);
    ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, "{ffcc00}*", "{ffcc66}Музыка в транспорте {99ff66}включена", "*", "");
    return true;
}


CMD:eng(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 22) return false;
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить статус двигателя транспорта [ /eng VehID ]");

    new v = params[0];
    if(!IsValidVehicle(v)) return ErrorMessage(playerid, "{FF6347}Этого транспорта не существует");

    if(VehInfo[v][vEngine] == 1)
    {
        GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(v, false, false, alarm, doors, bonnet, boot, objective);
        VehInfo[v][vEngine] = 0, VehInfo[v][vLights] = 0;
    }
    else
    {
        GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(v, true, true, alarm, doors, bonnet, boot, objective);
        VehInfo[v][vEngine] = 1, VehInfo[v][vLights] = 1;
    }
    return true;
}

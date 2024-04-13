
#define MAX_HANDLING_ID 25

new handlingName[][] =
{
    "HANDLING_RESET",

    "HANDLING_MASS",                                      // m_fMass
    "HANDLING_TURNMASS",                                  // m_fTurnMass
    "HANDLING_DRAGMULT",                                  // m_fDragMult
    "HANDLING_CENTREOFMASS_X",                            // m_vecCentreOfMass.x
    "HANDLING_CENTREOFMASS_Y",                            // m_vecCentreOfMass.y
    "HANDLING_CENTREOFMASS_Z",                            // m_vecCentreOfMass.z
    "HANDLING_TRACTIONMULTIPLIER",                        // m_fTractionMultiplier
    "HANDLING_TRACTIONLOSS",                              // m_fTractionLoss
    "HANDLING_TRACTIONBIAS",                              // m_fTractionBias
    "HANDLING_NUMOFGEARS",                                // m_transmissionData.m_nNumberOfGears
    "HANDLING_MAXVELOCITY",                               // m_transmissionData.m_fMaxGearVelocity
    "HANDLING_ENGINEACCELERATION",                        // m_transmissionData.m_fEngineAcceleration
    "HANDLING_ENGINEINERTIA",                             // m_transmissionData.m_fEngineInertia
    "HANDLING_BRAKEDECELERATION",                         // m_fBrakeDeceleration
    "HANDLING_BRAKEBIAS",                                 // m_fBrakeBias
    "HANDLING_ABS",                                       // m_bABS
    "HANDLING_STEERINGLOCK",                              // m_fSteeringLock
    "HANDLING_SUSPFORCELEVEL",                            // m_fSuspensionForceLevel
    "HANDLING_SUSPDAMPINGLEVEL",                          // m_fSuspensionDampingLevel
    "HANDLING_SUSPHIGHSPDCOMDAMP",                        // m_fSuspensionHighSpdComDamp
    "HANDLING_SUSPUPPERLIMIT",                            // m_fSuspensionUpperLimit
    "HANDLING_SUSPLOWERLIMIT",                            // m_fSuspensionLowerLimit
    "HANDLING_SUSPBIASBETWEEN",                           // m_fSuspensionBiasBetweenFrontAndRear
    "HANDLING_WHEELSCALE",                                // custom: CVehicle->m_fWheelScale
    "HANDLING_WHEELTILT",                                 // custom: wheel_tilt

    "HANDLING_MAX"
};

CMD:vehhand(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    new vehicleid, handlingid, value[24];
    if(sscanf(params, "iis[24]", vehicleid, handlingid, value)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить хендлинг транспорта /vehhand VehID HandlingID Значение");
    if(handlingid < 1 || handlingid > MAX_HANDLING_ID) return ErrorMessage(playerid, "{FF6347}HandlingID не меньше 1 и не больше 25");
    if(!IsValidVehicle(vehicleid)) return ErrorMessage(playerid, "{FF6347}Ошибка! Транспорта не существует");

    
    SetVehicleHandling(vehicleid, handlingid, value);
    SendClientMessage(playerid, -1, "Handling %s %d %s новое значение %s", GetVehicleName(VehInfo[vehicleid][vModel]), vehicleid, handlingName[handlingid], value);
    return 1;
}

// Устанавливаем хендлинг
stock SetVehicleHandling(vehicleid, handlingid, const value[])
{
    if(GetHandlingEntryType(handlingid) == HANDLING_TYPE_FLOAT)
    {
        SetVehicleHandlingFloat(vehicleid, handlingid, floatstr(value), false);
    }
    else if(GetHandlingEntryType(handlingid) == HANDLING_TYPE_INT)
    {
        SetVehicleHandlingInt(vehicleid, handlingid, strval(value), false);
    }
    return 1;
}

CMD:rvehhand(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    new vehicleid;
    if(sscanf(params, "i", vehicleid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сбросить хендлинг транспорта /rvehhand VehID");
    if(!IsValidVehicle(vehicleid)) return ErrorMessage(playerid, "{FF6347}Ошибка! Транспорта не существует");

    ResetVehicleHandling(vehicleid);
    SendClientMessage(playerid, -1, "Handling %s %d {FF6347}сброшен", GetVehicleName(VehInfo[vehicleid][vModel]), vehicleid);
    return 1;
}

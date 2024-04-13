
#define MAX_HANDLING_ID 25

new handlingName[][] =
{
    "HANDLING_RESET",

    "HANDLING_MASS",                  // 1 m_fMass                                    1200.0 — Масса (100...50000)
    "HANDLING_TURNMASS",              // 2 m_fTurnMass                                3000.0 — Масса в повороте
    "HANDLING_DRAGMULT",              // 3 m_fDragMult                                2.5 —--— Множитель тяжести (влияет на разгон 0.0...20.0)
    "HANDLING_CENTREOFMASS_X",        // 4 m_vecCentreOfMass.x                        0.0 —--— Центр массы по Х    
    "HANDLING_CENTREOFMASS_Y",        // 5 m_vecCentreOfMass.y                        0.1 —--— Центр массы по У
    "HANDLING_CENTREOFMASS_Z",        // 6 m_vecCentreOfMass.z                        0.0 —--— Центр массы по Z (верх низ)
    "HANDLING_TRACTIONMULTIPLIER",    // 7 m_fTractionMultiplier                      0.70 —— Сила сцепления с дорогой (0.5...2.0)
    "HANDLING_TRACTIONLOSS",          // 8 m_fTractionLoss                            0.90 —— Потеря сцепления (скорость поворота 0.5...2.0)
    "HANDLING_TRACTIONBIAS",          // 9 m_fTractionBias                            0.48 —— Смещение сцепления (корпуса0.1...0.6)
    "HANDLING_NUMOFGEARS",            // 10 m_transmissionData.m_nNumberOfGears        5 —----— Количество передач (всего 5)
    "HANDLING_MAXVELOCITY",           // 11 m_transmissionData.m_fMaxGearVelocity      150.0 —- Максимальная скорость
    "HANDLING_ENGINEACCELERATION",    // 12 m_transmissionData.m_fEngineAcceleration   18.0 —— Ускорение (мощность)
    "HANDLING_ENGINEINERTIA",         // 13 m_transmissionData.m_fEngineInertia        20.0 —— Инерция двигателя (влияет на ускорение 0.0...250.0)
    "HANDLING_BRAKEDECELERATION",     // 14 m_fBrakeDeceleration                       4.0 —-— Эффективность торможения (1.0...20.0)
    "HANDLING_BRAKEBIAS",             // 15 m_fBrakeBias                               0.80 —— Распределение тормоза (0.0-задняя,0.5-равномерно,1.0-передняя)
    "HANDLING_ABS",                   // 16 m_bABS                                     0 —----— Наличие ABS (0 - нету; 1 - есть)
    "HANDLING_STEERINGLOCK",          // 17 m_fSteeringLock                            30.0 —— Уровень поворота колес(10.0...40.0)
    "HANDLING_SUSPFORCELEVEL",        // 18 m_fSuspensionForceLevel                    0.8 —-— Жесткость пружин (влияет на высоту подвески)
    "HANDLING_SUSPDAMPINGLEVEL",      // 19 m_fSuspensionDampingLevel                  0.08 —— Жесткость амортизаторов (длительность качки корпуса)
    "HANDLING_SUSPHIGHSPDCOMDAMP",    // 20 m_fSuspensionHighSpdComDamp                0.0 —-— Прыгучесть на скорости
    "HANDLING_SUSPUPPERLIMIT",        // 21 m_fSuspensionUpperLimit                    0.45 —— Верхний предел (амплитуда сжатия пружин 0.1...0.5)
    "HANDLING_SUSPLOWERLIMIT",        // 22 m_fSuspensionLowerLimit                    -0.25 —- Нижний предел (амплитуда сжатия пружин -0.01...-0.5)
    "HANDLING_SUSPBIASBETWEEN",       // 23 m_fSuspensionBiasBetweenFrontAndRear       0.45 —— Смещение наклона (высота зада переда 0.0...0.6)
    "HANDLING_WHEELSCALE",            // 24 custom: CVehicle->m_fWheelScale            Размер колёс
    "HANDLING_WHEELTILT",             // 25 custom: wheel_tilt                         Развал

    "HANDLING_MAX"
};

/*
; name       mass     turnmass  drag   centreofmass  boy traction           transmission            brakes       steer  suspension       suslines        antidive   seat col  cost      mflags      hflags      lights
; A          B         C   	    D      F   G    H    I   J    K    L    	M N     O    P Q  R      S     T U    V    	a    b     c     d    e     f    g   		aa   ab   ac		af 			ag 			ah ai aj
drift
JESTER       1400      2725.3   1.5    0.0 0.0 -0.5  70  0.63 0.8  0.6      5 300.0 35.0 3.0  4 p   11.0  0.51 0 75.0   0.5  0.19  0.0   0.25 -0.1  0.5   0.4 0.37 0 35000 40002004 C04000 1 1 1
*/

CMD:vehhand(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    new vehicleid, handlingid, value[24];
    if(IsPlayerInAnyVehicle(playerid))
    {
        vehicleid = GetPlayerVehicleID(playerid);
        if(sscanf(params, "is[24]", handlingid, value)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить хендлинг транспорта /vehhand HandlingID Значение");
    }
    else
    {
        if(sscanf(params, "iis[24]", vehicleid, handlingid, value)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить хендлинг транспорта /vehhand VehID HandlingID Значение");
    }
    
    if(handlingid < 1 || handlingid > MAX_HANDLING_ID) return ErrorMessage(playerid, "{FF6347}HandlingID не меньше 1 и не больше 25");
    if(!IsValidVehicle(vehicleid)) return ErrorMessage(playerid, "{FF6347}Ошибка! Транспорта не существует");
    
    SetVehicleHandling(vehicleid, HandlingEntry:handlingid, value);
    SendClientMessage(playerid, -1, "Handling %s %d %s новое значение %s", GetVehicleName(VehInfo[vehicleid][vModel]), vehicleid, handlingName[handlingid], value);
    return 1;
}

CMD:getvehhand(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    new vehicleid, model;
    if(IsPlayerInAnyVehicle(playerid))
    {
        vehicleid = GetPlayerVehicleID(playerid);
        if(sscanf(params, "i", model)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Скопировать хендлинг транспорта /getvehhand Model");
    }
    else
    {
        if(sscanf(params, "ii", vehicleid, model)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Скопировать хендлинг транспорта /getvehhand VehID Model");
    }
    
    if(!IsValidVehicle(vehicleid)) return ErrorMessage(playerid, "{FF6347}Ошибка! Транспорта не существует");
    
    if(!PutVehicleHandling(model, vehicleid)) return ErrorMessage(playerid, "{FF6347}Handling этой модели транспорта не найден");
    SendClientMessage(playerid, -1, "Handling %s [ID: %d] скопирован для %s [ID: %d Vehicleid: %d]", GetVehicleName(model), model, GetVehicleName(VehInfo[vehicleid][vModel]), VehInfo[vehicleid][vModel], vehicleid);
    return 1;
}

// Устанавливаем хендлинг
stock SetVehicleHandling(vehicleid, HandlingEntry:handlingid, const value[])
{
    if(GetHandlingEntryType(handlingid) == HANDLING_TYPE_FLOAT)
    {
        SetVehicleHandlingFloat(vehicleid, handlingid, floatstr(value));
    }
    else if(GetHandlingEntryType(handlingid) == HANDLING_TYPE_INT)
    {
        SetVehicleHandlingInt(vehicleid, handlingid, strval(value));
    }
    return 1;
}

CMD:rvehhand(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    new vehicleid;
    if(IsPlayerInAnyVehicle(playerid))
    {
        vehicleid = GetPlayerVehicleID(playerid);
    }
    else
    {
        if(sscanf(params, "i", vehicleid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сбросить хендлинг транспорта /rvehhand VehID");
    }
    if(!IsValidVehicle(vehicleid)) return ErrorMessage(playerid, "{FF6347}Ошибка! Транспорта не существует");

    ResetVehicleHandling(vehicleid);
    SendClientMessage(playerid, -1, "Handling %s %d {FF6347}сброшен", GetVehicleName(VehInfo[vehicleid][vModel]), vehicleid);
    return 1;
}

// Чтение HANDLING.CFG
enum HandlingData
{
    HD_Name[24],
    Float:HD_Mass,
    Float:HD_TurnMass,
    Float:HD_Drag,
    Float:HD_CentreOfMassX,
    Float:HD_CentreOfMassY,
    Float:HD_CentreOfMassZ,
    HD_Boyant,
    Float:HD_TractionMultiplier,
    Float:HD_TractionLoss,
    Float:HD_TractionBias,
    HD_NumberOfGears,
    Float:HD_MaxVelocity,
    Float:HD_EngineAcceleration,
    Float:HD_EngineInertia,
    HD_Zalupa[4],
    HD_Zalupa2[4],
    Float:HD_BrakeDeceleration,
    Float:HD_BrakeBias,
    HD_ABS,
    Float:HD_SteeringLock,
    Float:HD_SuspensionForceLevel,
    Float:HD_SuspensionDampingLevel,
    Float:HD_SuspensionHighSpdComDamp,
    Float:HD_SuspensionUpperLimit,
    Float:HD_SuspensionLowerLimit,
    Float:HD_SuspensionBiasBetweenFrontAndRear,
    HD_ModelID
}
new HandlingInfo[sizeof(vehName) + sizeof(vehNameCustom)][HandlingData];

// Кладём хандлинг одной тачки на другую
stock PutVehicleHandling(getmodel, vehicleid)
{
    new v = FindVehicleModelHandling(getmodel);
    if(v == -1) return 0;

    //SetVehicleHandlingFloat(vehicleid, HANDLING_MASS, HandlingInfo[v][HD_Mass]);
    //SetVehicleHandlingFloat(vehicleid, HANDLING_TURNMASS, HandlingInfo[v][HD_TurnMass]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_DRAGMULT, HandlingInfo[v][HD_Drag]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_CENTREOFMASS_X, HandlingInfo[v][HD_CentreOfMassX]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_CENTREOFMASS_Z, HandlingInfo[v][HD_CentreOfMassY]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_TURNMASS, HandlingInfo[v][HD_CentreOfMassZ]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_TRACTIONMULTIPLIER, HandlingInfo[v][HD_TractionMultiplier]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_TRACTIONLOSS, HandlingInfo[v][HD_TractionLoss]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_TRACTIONBIAS, HandlingInfo[v][HD_TractionBias]);
    SetVehicleHandlingInt(vehicleid, HANDLING_NUMOFGEARS, HandlingInfo[v][HD_NumberOfGears]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_MAXVELOCITY, HandlingInfo[v][HD_MaxVelocity]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_ENGINEACCELERATION, HandlingInfo[v][HD_EngineAcceleration]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_ENGINEINERTIA, HandlingInfo[v][HD_EngineInertia]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_BRAKEDECELERATION, HandlingInfo[v][HD_BrakeDeceleration]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_BRAKEBIAS, HandlingInfo[v][HD_BrakeBias]);
    SetVehicleHandlingInt(vehicleid, HANDLING_ABS, HandlingInfo[v][HD_ABS]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_STEERINGLOCK, HandlingInfo[v][HD_SteeringLock]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_SUSPFORCELEVEL, HandlingInfo[v][HD_SuspensionForceLevel]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_SUSPDAMPINGLEVEL, HandlingInfo[v][HD_SuspensionDampingLevel]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_SUSPHIGHSPDCOMDAMP, HandlingInfo[v][HD_SuspensionHighSpdComDamp]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_SUSPUPPERLIMIT, HandlingInfo[v][HD_SuspensionUpperLimit]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_SUSPLOWERLIMIT, HandlingInfo[v][HD_SuspensionLowerLimit]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_SUSPBIASBETWEEN, HandlingInfo[v][HD_SuspensionBiasBetweenFrontAndRear]);
    return 1;
}

// Ищем хенлдлинг тачки по её id
stock FindVehicleModelHandling(model)
{
    new findHandling = -1;
    for(new v = 0; v < sizeof(vehName) + sizeof(vehNameCustom); v++)
    {
        if(HandlingInfo[v][HD_ModelID] == model)
        {
            findHandling = v;
            break;
        }
    }
    return findHandling;
}

stock ReadHandlingCFG()
{
    new File: f = fopen("HANDLING.CFG", io_read);
    new line[512], quan;
    while (fread(f, line))
    {
        switch (line[0])
        {
            case '/', ';', '%', '!', '$', '^': continue;
        }
        if(!sscanf(line, "s[14]ffffffifffifffccffifffffff", 
            HandlingInfo[quan][HD_Name],
            HandlingInfo[quan][HD_Mass],
            HandlingInfo[quan][HD_TurnMass],
            HandlingInfo[quan][HD_Drag],
            HandlingInfo[quan][HD_CentreOfMassX],
            HandlingInfo[quan][HD_CentreOfMassY],
            HandlingInfo[quan][HD_CentreOfMassZ],
            HandlingInfo[quan][HD_Boyant],
            HandlingInfo[quan][HD_TractionMultiplier],
            HandlingInfo[quan][HD_TractionLoss],
            HandlingInfo[quan][HD_TractionBias],
            HandlingInfo[quan][HD_NumberOfGears],
            HandlingInfo[quan][HD_MaxVelocity],
            HandlingInfo[quan][HD_EngineAcceleration],
            HandlingInfo[quan][HD_EngineInertia],
            HandlingInfo[quan][HD_Zalupa],
            HandlingInfo[quan][HD_Zalupa2],
            HandlingInfo[quan][HD_BrakeDeceleration],
            HandlingInfo[quan][HD_BrakeBias],
            HandlingInfo[quan][HD_ABS],
            HandlingInfo[quan][HD_SteeringLock],
            HandlingInfo[quan][HD_SuspensionForceLevel],
            HandlingInfo[quan][HD_SuspensionDampingLevel],
            HandlingInfo[quan][HD_SuspensionHighSpdComDamp],
            HandlingInfo[quan][HD_SuspensionUpperLimit],
            HandlingInfo[quan][HD_SuspensionLowerLimit],
            HandlingInfo[quan][HD_SuspensionBiasBetweenFrontAndRear]))
        {
            quan ++;
        }
    }
    fclose(f);
    return 1;
}

enum VehiclesData
{
    VD_Id,
    VD_Dffname[14],
    VD_Txdname[14],
    VD_Type[14],
    VD_Handling[14]
}

stock ReadVehicleIDE()
{
    new Temp[VehiclesData];
    new File: f = fopen("vehicles.ide", io_read);
    new line[512];
    while (fread(f, line))
    {
        if(line[0] < '0' || line[0] > '9') continue;

        if(!sscanf(line, "p<,>is[14]s[14]s[14]s[14] ", 
            Temp[VD_Id],
            Temp[VD_Dffname],
            Temp[VD_Txdname],
            Temp[VD_Type],
            Temp[VD_Handling]))
        {
            for(new v = 0; v < sizeof(vehName) + sizeof(vehNameCustom); v++)
            {
                if(strfind(HandlingInfo[v][HD_Name], Temp[VD_Handling],true) != (-1))
                {
                    if(Temp[VD_Id] > 15000) HandlingInfo[v][HD_ModelID] = Temp[VD_Id] - 13066;
                    else HandlingInfo[v][HD_ModelID] = Temp[VD_Id];
                }
            }
        }
    }
    fclose(f);
    return 1;
}

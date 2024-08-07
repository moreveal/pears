
#define MAX_HANDLING_ID 26
#define MAX_DETAIL 18
new friskDetail[MAX_DETAIL][3] = // ID предмета в инвентаре | 2 тип детали(0 двигатель,1 трансмиссия, 2 подвеска, 3 шины, 4 тормоз) | bizprice |
{
    {207, 0, 10 },
    {208, 0, 11 },
    {209, 0, 12 },
    {210, 0, 13 },
    {211, 1, 14 },
    {212, 1, 15 },
    {213, 1, 16 },
    {214, 1, 17 },
    {215, 2, 18 },
    {216, 2, 19 },
    {217, 2, 20 },
    {218, 3, 21 },
    {219, 3, 22 },
    {220, 3, 23 },
    {221, 4, 24 },
    {222, 4, 25 },
    {223, 4, 26 },
    {224, 0, 27 }
};
new friskDetailPoint[][3][MAX_DETAIL] =
{
    { "5.0","2.5", "0.0" }, // Двигатель AROSPEED
    { "10.0", "5.0", "0.0 "}, // Двигатель SkinkRacer
    { "15.0","7.5", "0.0" }, // Двигатель Venom
    { "20.0","10.0", "0.0 "}, // Двигатель DC Sports
    { "10.0","0.0","0.0" }, // Трансмиссия ACT
    { "15.0","0.0","0.0" }, // Трансмиссия Clutch Masters
    { "20.0","0.0","0.0" }, // Трансмиссия Jackson Racing
    { "25.0","0.0","0.0" }, // Трансмиссия HP Racing
    { "10.0","0.0","0.0" }, // Подвеска Ibach Springs
    { "15.0","0.0","0.0" }, // Подвеска Koni Suspension
    { "5.0","0.0","0.0" }, // Подвеска Billstein
    { "5.0", "0.0", "0.0"}, // Шины YOKOHAMA
    { "10.0","0.0", "0.0" }, // Шины TOYO
    { "15.0","0.0", "0.0" }, // Шины Falken Tyre
    { "10.0","0.0", "0.0" }, // Тормоза KVR Performance
    { "20.0","0.0"," 0.0" }, // Тормоза Brembo
    { "50.0","0.0"," 0.0" }, // Тормоза Wilwood
    { "30.0","15.0","0.0" } // Двигатель Philin Customs
};
new friskDetailTypeName[][] = // Тип детали
{
    "Двигатель","Трансмиссия","Подвеска","Шины","Тормоз"
};

new TempDetail[MAX_REALPLAYERS][sizeof(friskDetailTypeName)];
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
    HD_Zalupa,
    HD_Zalupa2,
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
new DefaultHandling[sizeof(vehName) + sizeof(vehNameCustom)][HandlingData];
new HandlingVehInfo[MAX_CARS][HandlingData];

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
    "HANDLING_DRIVETYPE",             // 14 m_transmissionData.m_nDriveType            Привод транспорта
    "HANDLING_BRAKEDECELERATION",     // 15 m_fBrakeDeceleration                       4.0 —-— Эффективность торможения (1.0...20.0)
    "HANDLING_BRAKEBIAS",             // 16 m_fBrakeBias                               0.80 —— Распределение тормоза (0.0-задняя,0.5-равномерно,1.0-передняя)
    "HANDLING_ABS",                   // 17 m_bABS                                     0 —----— Наличие ABS (0 - нету; 1 - есть)
    "HANDLING_STEERINGLOCK",          // 18 m_fSteeringLock                            30.0 —— Уровень поворота колес(10.0...40.0)
    "HANDLING_SUSPFORCELEVEL",        // 19 m_fSuspensionForceLevel                    0.8 —-— Жесткость пружин (влияет на высоту подвески)
    "HANDLING_SUSPDAMPINGLEVEL",      // 20 m_fSuspensionDampingLevel                  0.08 —— Жесткость амортизаторов (длительность качки корпуса)
    "HANDLING_SUSPHIGHSPDCOMDAMP",    // 21 m_fSuspensionHighSpdComDamp                0.0 —-— Прыгучесть на скорости
    "HANDLING_SUSPUPPERLIMIT",        // 22 m_fSuspensionUpperLimit                    0.45 —— Верхний предел (амплитуда сжатия пружин 0.1...0.5)
    "HANDLING_SUSPLOWERLIMIT",        // 23 m_fSuspensionLowerLimit                    -0.25 —- Нижний предел (амплитуда сжатия пружин -0.01...-0.5)
    "HANDLING_SUSPBIASBETWEEN",       // 24 m_fSuspensionBiasBetweenFrontAndRear       0.45 —— Смещение наклона (высота зада переда 0.0...0.6)
    "HANDLING_WHEELSCALE",            // 25 custom: CVehicle->m_fWheelScale            Размер колёс
    "HANDLING_WHEELTILT",             // 26 custom: wheel_tilt                         Развал

    "HANDLING_MAX"
};

/*
; name       mass     turnmass  drag   centreofmass  boy traction           transmission            brakes       steer  suspension       suslines        antidive   seat col  cost      mflags      hflags      lights
; A          B         C   	    D      F   G    H    I   J    K    L    	M N     O    P Q  R      S     T U    V    	a    b     c     d    e     f    g   		aa   ab   ac		af 			ag 			ah ai aj
drift
JESTER       1400      2725.3   1.5    0.0 0.0 -0.5  70  0.63 0.8  0.6      5 300.0 35.0 3.0  4 p   11.0  0.51 0 75.0   0.5  0.19  0.0   0.25 -0.1  0.5   0.4 0.37 0 35000 40002004 C04000 1 1 1
*/


/*
Как установить тюнинг на транспорт?
new slot = SetVehicleDetailTunning(vehicleid, thingId, thingQara);
if(slot == -1) return ErrorMessage(playerid, "{FF6347}В транспорте нет слотов для установки тюнинга");
SaveOneTunning(playerid, slot);


Как снять деталь тюнинга с транспорта?
new slot = RemoveDetailTunning(vehicleid, thingId);
if(slot == -1) return ErrorMessage(playerid, "{FF6347}Эта деталь тюнинга не установлена на транспорте");
SaveOneTunning(playerid, slot);
*/

// Ставим одну деталь тюнинга
stock SetVehicleDetailTunning(vehicleid, thingId, thingQara,tuningType)
{
    new slot = -1;
    for(new t = 0; t < MAX_TUNNING_VEHICLE; t++)
    {
        if(VehInfo[vehicleid][vTunningID][t] == 0)
        {
            VehInfo[vehicleid][vTunningID][t] = thingId;
            VehInfo[vehicleid][vTunningQara][t] = thingQara;
            VehInfo[vehicleid][vTunningType][t] = tuningType;
            slot = t;
            break;
        }
    }
    if(slot >= 0) SetHandlingTotal(vehicleid);
    return slot;
}

stock GetVehicleDetailTunning(vehicleid, tuningType)
{
    new slot = -1;
    for(new t = 0; t < MAX_TUNNING_VEHICLE; t++)
    {
        if(VehInfo[vehicleid][vTunningType][t] == tuningType && VehInfo[vehicleid][vTunningID][t] != 0)
        {
            slot = t;
            break;
        }
    }
    return slot;
}

stock GetVehicleDetailTunningID(vehicleid, tuningType)
{
    new slot = -1;
    for(new t = 0; t < MAX_TUNNING_VEHICLE; t++)
    {
        if(VehInfo[vehicleid][vTunningType][t] == tuningType && VehInfo[vehicleid][vTunningID][t] != 0)
        {
            slot = VehInfo[vehicleid][vTunningID][t];
            break;
        }
    }
    return slot;
}

// Снимаем одну деталь тюнинга по её thingId
/*stock RemoveDetailTunning(vehicleid, thingId)
{
    new slot = -1;
    for(new t = 0; t < MAX_TUNNING_VEHICLE; t++)
    {
        if(VehInfo[vehicleid][vTunningID][t] == thingId)
        {
            ClearTunningSlot(vehicleid, t);
            slot = t;
            break;
        }
    }
    if(slot >= 0) SetHandlingTotal(vehicleid, true);
    return slot;
}*/

// Снимаем деталь по слоту
stock RemoveDetailTunningSlot(vehicleid, slot)
{
    ClearTunningSlot(vehicleid, slot);
    SetHandlingTotal(vehicleid, true);
    return true;
}


CMD:sethandling(playerid, const params[])
{   
    if(server != 0) return 0;
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Запустить хендлинг на транспорте /sethandling VehID");
    if(!IsValidVehicle(params[0])) return ErrorMessage(playerid, "{FF6347}Ошибка! Транспорта не существует");

    SetHandlingTotal(params[0]);
    SuccessMessage(playerid, "{99ff66}Хендлинг транспорта перезаписан");
    return 1;
}

CMD:vehhand(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 1) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

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
    
    SetVehicleHandlingPofigType(vehicleid, handlingid, value);
    SendClientMessage(playerid, -1, "Handling %s %d %s новое значение %s", GetVehicleName(VehInfo[vehicleid][vModel]), vehicleid, handlingName[handlingid], value);
    return 1;
}

CMD:getvehhand(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 1) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

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
    
    new vehicleHandlingID = FindVehicleModelHandling(model);
    if(vehicleHandlingID == -1) return ErrorMessage(playerid, "{FF6347}Handling этой модели транспорта не найден");

    VehInfo[vehicleid][vHandlingModel] = model;

    // Применили весь хендлинг
    SetHandlingTotal(vehicleid);

    SendClientMessage(playerid, -1, "Handling %s [ID: %d] скопирован для %s [ID: %d Vehicleid: %d]", GetVehicleName(model), model, GetVehicleName(VehInfo[vehicleid][vModel]), VehInfo[vehicleid][vModel], vehicleid);
    return 1;
}

// Устанавливаем хендлинг
stock SetVehicleHandlingPofigType(vehicleid, handlingid, const value[])
{
    SetVehicleHandling(vehicleid, handlingid, value); // Записываем тачке её новый хендлинг

    if(GetHandlingEntryType(HandlingEntry:handlingid) == HANDLING_TYPE_FLOAT) SetVehicleHandlingFloat(vehicleid, HandlingEntry:handlingid, floatstr(value));
    else if(GetHandlingEntryType(HandlingEntry:handlingid) == HANDLING_TYPE_INT) SetVehicleHandlingInt(vehicleid, HandlingEntry:handlingid, strval(value));
    return 1;
}

CMD:rvehhand(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 1) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

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

    DestroyVehicleHandling(vehicleid);
    SendClientMessage(playerid, -1, "Handling %s %d {FF6347}сброшен", GetVehicleName(VehInfo[vehicleid][vModel]), vehicleid);
    return 1;
}

// Снимаем весь тюнинг и хендлинг с транспорта
stock DestroyVehicleHandling(vehicleid)
{
    VehInfo[vehicleid][vHandlingModel] = 0;
    for(new t = 0; t < MAX_TUNNING_VEHICLE; t++) ClearTunningSlot(vehicleid, t);
    ResetVehicleHandling(vehicleid);
    return 1;
}

// Получаем 1 процент настройки в стандартном хендлинге транспорта
stock GetOneProcentHandling(handlId, vehicleHandlingID, &Float:oneProcent)
{
    new defaultValue[14];
    GetVehicleHandlingDefault(handlId, vehicleHandlingID, defaultValue);
    oneProcent = floatstr(defaultValue) / 100;
    return 1;
}

// Снимаем весь тюннинг с транспорта и кладём детали в багажник
stock TakeAllTunningVehicle(vehicleid)
{
    for(new t = 0; t < MAX_TUNNING_VEHICLE; t++)
    {
        if(VehInfo[vehicleid][vTunningID][t] > 0)
        {
            PutThingBoot(vehicleid, VehInfo[vehicleid][vTunningID][t], 1, VehInfo[vehicleid][vTunningType][t], VehInfo[vehicleid][vTunningQara][t], 0, 0, 999);
            ClearTunningSlot(vehicleid, t);
        }
    }
    return 1;
}

stock ClearAllTunning(vehicleid)
{
    for(new t = 0; t < MAX_TUNNING_VEHICLE; t++) ClearTunningSlot(vehicleid, t);
    return 1;
}

// Очищаем тюнинг с транспорта
stock ClearTunningSlot(vehicleid, slot)
{
    VehInfo[vehicleid][vTunningID][slot] = 0;
    VehInfo[vehicleid][vTunningQara][slot] = 0;
    VehInfo[vehicleid][vTunningType][slot] = 0;
    return 1;
}

// Перекидываем тюнинг детали с одной машины на другую
stock ReversVehicleTunning(vehicleid, getvehicleid)
{
    for(new t = 0; t < MAX_TUNNING_VEHICLE; t++)
    {
        VehInfo[vehicleid][vTunningID][t] = VehInfo[getvehicleid][vTunningID][t];
        VehInfo[vehicleid][vTunningQara][t] = VehInfo[getvehicleid][vTunningQara][t];
        VehInfo[vehicleid][vTunningType][t] = VehInfo[getvehicleid][vTunningType][t];
    }
    return 1;
}

// Ставим все характеристики в переменные
stock SetHandlingTotalForTestDrive(playerid,vehicleid, bool:result = false)
{
    new model = GetVehicleRealModelTemp(vehicleid);
    new vehicleHandlingID = FindVehicleModelHandling(model);

    // Если не нашли хендлинг транспорта, останавливаем установку
    if(vehicleHandlingID <= 0) return 1;

    if(VehInfo[vehicleid][vHandlingModelTemp] > 0) 
    {
        result = true;
        SetVehicleHandlingDefault(vehicleid, vehicleHandlingID);
    }

    // Записали все детали тюнинга
    for(new t = 0; t < sizeof(friskDetailTypeName); t++)
    {
        if(TempDetail[playerid][t] > 0)
        {
            SetVehicleTuning(vehicleid, TempDetail[playerid][t], model, vehicleHandlingID);
            result = true;
        }
    }

    // Применили весь хендлинг
    if(result == true) PutVehicleHandling(vehicleid);
    return 1;
}

// Ставим все характеристики в переменные
stock SetHandlingTotal(vehicleid, bool:result = false)
{
    new model = GetVehicleRealModel(vehicleid);
    new vehicleHandlingID = FindVehicleModelHandling(model);

    // Если не нашли хендлинг транспорта, останавливаем установку
    if(vehicleHandlingID <= 0) return 1;

    // Записали хендлинг перенесённой тачки
    if(VehInfo[vehicleid][vHandlingModel] > 0) result = true;
    SetVehicleHandlingDefault(vehicleid, vehicleHandlingID);

    // Записали все детали тюнинга
    for(new t = 0; t < MAX_TUNNING_VEHICLE; t++)
    {
        if(VehInfo[vehicleid][vTunningID][t] > 0)
        {
            SetVehicleTuning(vehicleid, VehInfo[vehicleid][vTunningID][t], model, vehicleHandlingID);
            result = true;
        }
    }

    // Применили весь хендлинг
    if(result == true) PutVehicleHandling(vehicleid);
    return 1;
}

// Записываем тюнинг в одной детали в переменную транспорта
stock SetVehicleTuning(vehicleid, thingId, model = 0, vehicleHandlingID = 0)
{
    new plus, handl0, handl1, handl2, value0[14], value1[14], value2[14];
    if(!GetHandlingChangeThing(thingId, plus, handl0, handl1, handl2, value0, value1, value2)) return 0;

    // Получаем реальную model транспорта
    if(model == 0) model = GetVehicleRealModel(vehicleid);

    // Получаем vehiclehandlingid внутри enuma с хранением дефолтных характеристик
    if(vehicleHandlingID == 0) vehicleHandlingID = FindVehicleModelHandling(model);

    if(handl0 > 0) SetOneDetailTuning(vehicleid, plus, handl0, vehicleHandlingID, value0);
    if(handl1 > 0) SetOneDetailTuning(vehicleid, plus, handl1, vehicleHandlingID, value1);
    if(handl2 > 0) SetOneDetailTuning(vehicleid, plus, handl2, vehicleHandlingID, value2);
    return 1;
}

stock SetOneDetailTuning(vehicleid, plus, handlingid, vehicleHandlingID, const value[])
{
    new defaultValue[14], Float:oneProcent;
    if(plus == 0) SetVehicleHandling(vehicleid, handlingid, value);
    else
    {
        GetOneProcentHandling(handlingid, vehicleHandlingID, oneProcent); // Получили 1 процент для тюнинг детали
        GetVehicleHandling(vehicleid, handlingid, defaultValue); // Получаем это значение у транспорта
        new handlingFormat[14];
        format(handlingFormat,sizeof(handlingFormat),"%f",floatstr(defaultValue) + oneProcent * floatstr(value));
       // printf("%s",handlingFormat);
        SetVehicleHandling(vehicleid, handlingid, handlingFormat);
    }
}

// Получаем реальную модель транспорта (вдруг на ней стоит кастомный хендлинг от другого транспорта)
stock GetVehicleRealModel(vehicleid)
{
    new model = VehInfo[vehicleid][vModel];
    if(VehInfo[vehicleid][vHandlingModel] > 0) model = VehInfo[vehicleid][vHandlingModel];
    return model;
}

stock GetVehicleRealModelTemp(vehicleid)
{
    new model = VehInfo[vehicleid][vModel];
    if(VehInfo[vehicleid][vHandlingModelTemp] > 0) model = VehInfo[vehicleid][vHandlingModelTemp];
    return model;
}

// Получаем инфу, что деталь меняет и сколько даёт
stock GetHandlingChangeThing(thingId, &plus, &handl0, &handl1, &handl2, value0[], value1[], value2[])
{
    new DetailTuningID = thingId-207;
    format(value0, 14,"%s",friskDetailPoint[DetailTuningID][0]);
    format(value1, 14,"%s",friskDetailPoint[DetailTuningID][1]);
    format(value2, 14,"%s",friskDetailPoint[DetailTuningID][2]);
    if(friskDetail[DetailTuningID][1] == 0) // Двигатель
    {
        plus = 1;
        handl0 = 11;
        handl1 = 12;
        handl2 = 0;
    }
    else if(friskDetail[DetailTuningID][1] == 1) // Трансмиссия
    {
        plus = 1;
        handl0 = 12;
        handl1 = 0;
        handl2 = 0;
    }
    else if(friskDetail[DetailTuningID][1] == 2) // Подвеска
    {
        plus = 1;
        handl0 = 18;
        handl1 = 0;
        handl2 = 0;
    }
    else if(friskDetail[DetailTuningID][1] == 3) // Шины
    {
        plus = 1;
        handl0 = 7;
        handl1 = 0;
        handl2 = 0;
    }
    else if(friskDetail[DetailTuningID][1] == 4) // Тормоз
    {
        plus = 1;
        handl0 = 15;
        handl1 = 0;
        handl2 = 0;
    }
    else return 0;
    return 1;
}

// Записываем хендлинг в переменную
stock SetVehicleHandling(vehicleid, handlingId, const value[])
{
    switch(handlingId)
    {
        case 1: HandlingVehInfo[vehicleid][HD_Mass] = floatstr(value);
        case 2: HandlingVehInfo[vehicleid][HD_TurnMass] = floatstr(value);
        case 3: HandlingVehInfo[vehicleid][HD_Drag] = floatstr(value);
        case 4: HandlingVehInfo[vehicleid][HD_CentreOfMassX] = floatstr(value);
        case 5: HandlingVehInfo[vehicleid][HD_CentreOfMassY] = floatstr(value);
        case 6: HandlingVehInfo[vehicleid][HD_CentreOfMassZ] = floatstr(value);
        // case 1: HandlingVehInfo[vehicleid][HD_Boyant] = strval(HandlingVehInfo[vehicleid][HD_Boyant]);
        case 7: HandlingVehInfo[vehicleid][HD_TractionMultiplier] = floatstr(value);
        case 8: HandlingVehInfo[vehicleid][HD_TractionLoss] = floatstr(value);
        case 9: HandlingVehInfo[vehicleid][HD_TractionBias] = floatstr(value);
        case 10: HandlingVehInfo[vehicleid][HD_NumberOfGears] = strval(value);
        case 11: HandlingVehInfo[vehicleid][HD_MaxVelocity] = floatstr(value);
        case 12: HandlingVehInfo[vehicleid][HD_EngineAcceleration] = floatstr(value);
        case 13: HandlingVehInfo[vehicleid][HD_EngineInertia] = floatstr(value);
        case 14: HandlingVehInfo[vehicleid][HD_Zalupa] = strval(value);
        //case 1: format(HandlingVehInfo[vehicleid][HD_Zalupa2] = floatstr(value);
        case 15: HandlingVehInfo[vehicleid][HD_BrakeDeceleration] = floatstr(value);
        case 16: HandlingVehInfo[vehicleid][HD_BrakeBias] = floatstr(value);
        case 17: HandlingVehInfo[vehicleid][HD_ABS] = strval(value);
        case 18: HandlingVehInfo[vehicleid][HD_SteeringLock] = floatstr(value);
        case 19: HandlingVehInfo[vehicleid][HD_SuspensionForceLevel] = floatstr(value);
        case 20: HandlingVehInfo[vehicleid][HD_SuspensionDampingLevel] = floatstr(value);
        case 21: HandlingVehInfo[vehicleid][HD_SuspensionHighSpdComDamp] = floatstr(value);
        case 22: HandlingVehInfo[vehicleid][HD_SuspensionUpperLimit] = floatstr(value);
        case 23: HandlingVehInfo[vehicleid][HD_SuspensionLowerLimit] = floatstr(value);
        case 24: HandlingVehInfo[vehicleid][HD_SuspensionBiasBetweenFrontAndRear] = floatstr(value);
        default: {}
    }
    return 1;
}

// Берём хендлинг из переменной
stock GetVehicleHandling(vehicleid, handlingId, value[])
{
    switch(handlingId)
    {
        case 1: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_Mass]);
        case 2: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_TurnMass]);
        case 3: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_Drag]);
        case 4: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_CentreOfMassX]);
        case 5: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_CentreOfMassY]);
        case 6: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_CentreOfMassZ]);
        // case 1: format(value, 14, "%d", HandlingVehInfo[vehicleid][HD_Boyant]);
        case 7: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_TractionMultiplier]);
        case 8: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_TractionLoss]);
        case 9: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_TractionBias]);
        case 10: format(value, 14, "%d", HandlingVehInfo[vehicleid][HD_NumberOfGears]);
        case 11: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_MaxVelocity]);
        case 12: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_EngineAcceleration]);
        case 13: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_EngineInertia]);
        case 14: format(value, 14, "%c", HandlingVehInfo[vehicleid][HD_Zalupa]);
        //case 1: format(value, 14, "%s", HandlingVehInfo[vehicleid][HD_Zalupa2]);
        case 15: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_BrakeDeceleration]);
        case 16: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_BrakeBias]);
        case 17: format(value, 14, "%d", HandlingVehInfo[vehicleid][HD_ABS]);
        case 18: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_SteeringLock]);
        case 19: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_SuspensionForceLevel]);
        case 20: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_SuspensionDampingLevel]);
        case 21: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_SuspensionHighSpdComDamp]);
        case 22: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_SuspensionUpperLimit]);
        case 23: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_SuspensionLowerLimit]);
        case 24: format(value, 14, "%f", HandlingVehInfo[vehicleid][HD_SuspensionBiasBetweenFrontAndRear]);
        default: {}
    }
    return 1;
}

// Берём дефолтный хендлинг
stock GetVehicleHandlingDefault(handlingId, vehicleHandlingID, value[])
{
    switch(handlingId)
    {
        case 1: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_Mass]);
        case 2: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_TurnMass]);
        case 3: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_Drag]);
        case 4: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_CentreOfMassX]);
        case 5: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_CentreOfMassY]);
        case 6: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_CentreOfMassZ]);
        // case 1: format(value, 14, "%d", DefaultHandling[vehicleHandlingID][HD_Boyant]);
        case 7: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_TractionMultiplier]);
        case 8: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_TractionLoss]);
        case 9: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_TractionBias]);
        case 10: format(value, 14, "%d", DefaultHandling[vehicleHandlingID][HD_NumberOfGears]);
        case 11: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_MaxVelocity]);
        case 12: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_EngineAcceleration]);
        case 13: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_EngineInertia]);
        case 14: format(value, 14, "%c", DefaultHandling[vehicleHandlingID][HD_Zalupa]);
        //case 1: format(value, 14, "%s", DefaultHandling[vehicleHandlingID][HD_Zalupa2]);
        case 15: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_BrakeDeceleration]);
        case 16: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_BrakeBias]);
        case 17: format(value, 14, "%d", DefaultHandling[vehicleHandlingID][HD_ABS]);
        case 18: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_SteeringLock]);
        case 19: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_SuspensionForceLevel]);
        case 20: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_SuspensionDampingLevel]);
        case 21: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_SuspensionHighSpdComDamp]);
        case 22: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_SuspensionUpperLimit]);
        case 23: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_SuspensionLowerLimit]);
        case 24: format(value, 14, "%f", DefaultHandling[vehicleHandlingID][HD_SuspensionBiasBetweenFrontAndRear]);
        default: {}
    }
    return 1;
}

// Перекидываем дефолтное значение характеристик транспорта
stock SetVehicleHandlingDefault(vehicleid, vehicleHandlingID)
{
    HandlingVehInfo[vehicleid][HD_Mass] = DefaultHandling[vehicleHandlingID][HD_Mass];
    HandlingVehInfo[vehicleid][HD_TurnMass] = DefaultHandling[vehicleHandlingID][HD_TurnMass];
    HandlingVehInfo[vehicleid][HD_Drag] = DefaultHandling[vehicleHandlingID][HD_Drag];
    HandlingVehInfo[vehicleid][HD_CentreOfMassX] = DefaultHandling[vehicleHandlingID][HD_CentreOfMassX];
    HandlingVehInfo[vehicleid][HD_CentreOfMassY] = DefaultHandling[vehicleHandlingID][HD_CentreOfMassY];
    HandlingVehInfo[vehicleid][HD_CentreOfMassZ] = DefaultHandling[vehicleHandlingID][HD_CentreOfMassZ];
    // format(HandlingVehInfo[vehicleid][HD_Boyant], 14, "%d", DefaultHandling[vehicleHandlingID][HD_Boyant]);
    HandlingVehInfo[vehicleid][HD_TractionMultiplier] = DefaultHandling[vehicleHandlingID][HD_TractionMultiplier];
    HandlingVehInfo[vehicleid][HD_TractionLoss] = DefaultHandling[vehicleHandlingID][HD_TractionLoss];
    HandlingVehInfo[vehicleid][HD_TractionBias] = DefaultHandling[vehicleHandlingID][HD_TractionBias];
    HandlingVehInfo[vehicleid][HD_NumberOfGears] = DefaultHandling[vehicleHandlingID][HD_NumberOfGears];
    HandlingVehInfo[vehicleid][HD_MaxVelocity] = DefaultHandling[vehicleHandlingID][HD_MaxVelocity];
    HandlingVehInfo[vehicleid][HD_EngineAcceleration] = DefaultHandling[vehicleHandlingID][HD_EngineAcceleration];
    HandlingVehInfo[vehicleid][HD_EngineInertia] = DefaultHandling[vehicleHandlingID][HD_EngineInertia];
    // format(HandlingVehInfo[vehicleid][HD_Zalupa2], 14, "%s", DefaultHandling[vehicleHandlingID][HD_Zalupa2]);
    HandlingVehInfo[vehicleid][HD_BrakeDeceleration] = DefaultHandling[vehicleHandlingID][HD_BrakeDeceleration];
    HandlingVehInfo[vehicleid][HD_BrakeBias] = DefaultHandling[vehicleHandlingID][HD_BrakeBias];
    HandlingVehInfo[vehicleid][HD_ABS] = DefaultHandling[vehicleHandlingID][HD_ABS];
    HandlingVehInfo[vehicleid][HD_SteeringLock] = DefaultHandling[vehicleHandlingID][HD_SteeringLock];
    HandlingVehInfo[vehicleid][HD_SuspensionForceLevel] = DefaultHandling[vehicleHandlingID][HD_SuspensionForceLevel];
    HandlingVehInfo[vehicleid][HD_SuspensionDampingLevel] = DefaultHandling[vehicleHandlingID][HD_SuspensionDampingLevel];
    HandlingVehInfo[vehicleid][HD_SuspensionHighSpdComDamp] = DefaultHandling[vehicleHandlingID][HD_SuspensionHighSpdComDamp];
    HandlingVehInfo[vehicleid][HD_SuspensionUpperLimit] = DefaultHandling[vehicleHandlingID][HD_SuspensionUpperLimit];
    HandlingVehInfo[vehicleid][HD_SuspensionLowerLimit] = DefaultHandling[vehicleHandlingID][HD_SuspensionLowerLimit];
    HandlingVehInfo[vehicleid][HD_SuspensionBiasBetweenFrontAndRear] = DefaultHandling[vehicleHandlingID][HD_SuspensionBiasBetweenFrontAndRear];
    HandlingVehInfo[vehicleid][HD_Zalupa] = DefaultHandling[vehicleHandlingID][HD_Zalupa];
    return 1;
}

// Присваиваем итоговый хендлинг на транспорт
stock PutVehicleHandling(vehicleid)
{
    SetVehicleHandlingFloat(vehicleid, HANDLING_MASS, HandlingVehInfo[vehicleid][HD_Mass]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_TURNMASS, HandlingVehInfo[vehicleid][HD_TurnMass]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_DRAGMULT, HandlingVehInfo[vehicleid][HD_Drag]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_CENTREOFMASS_X, HandlingVehInfo[vehicleid][HD_CentreOfMassX]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_CENTREOFMASS_Y, HandlingVehInfo[vehicleid][HD_CentreOfMassY]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_CENTREOFMASS_Z, HandlingVehInfo[vehicleid][HD_CentreOfMassZ]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_TRACTIONMULTIPLIER, HandlingVehInfo[vehicleid][HD_TractionMultiplier]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_TRACTIONLOSS, HandlingVehInfo[vehicleid][HD_TractionLoss]);
    //SetVehicleHandlingFloat(vehicleid, HANDLING_TRACTIONBIAS, HandlingVehInfo[vehicleid][HD_TractionBias]); // Вырубаем перенос Traction Bias
    SetVehicleHandlingInt(vehicleid, HANDLING_NUMOFGEARS, HandlingVehInfo[vehicleid][HD_NumberOfGears]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_MAXVELOCITY, HandlingVehInfo[vehicleid][HD_MaxVelocity]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_ENGINEACCELERATION, HandlingVehInfo[vehicleid][HD_EngineAcceleration]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_ENGINEINERTIA, HandlingVehInfo[vehicleid][HD_EngineInertia]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_BRAKEDECELERATION, HandlingVehInfo[vehicleid][HD_BrakeDeceleration]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_BRAKEBIAS, HandlingVehInfo[vehicleid][HD_BrakeBias]);
    SetVehicleHandlingInt(vehicleid, HANDLING_ABS, HandlingVehInfo[vehicleid][HD_ABS]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_STEERINGLOCK, HandlingVehInfo[vehicleid][HD_SteeringLock]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_SUSPFORCELEVEL, HandlingVehInfo[vehicleid][HD_SuspensionForceLevel]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_SUSPDAMPINGLEVEL, HandlingVehInfo[vehicleid][HD_SuspensionDampingLevel]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_SUSPHIGHSPDCOMDAMP, HandlingVehInfo[vehicleid][HD_SuspensionHighSpdComDamp]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_SUSPUPPERLIMIT, HandlingVehInfo[vehicleid][HD_SuspensionUpperLimit]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_SUSPLOWERLIMIT, HandlingVehInfo[vehicleid][HD_SuspensionLowerLimit]);
    SetVehicleHandlingFloat(vehicleid, HANDLING_SUSPBIASBETWEEN, HandlingVehInfo[vehicleid][HD_SuspensionBiasBetweenFrontAndRear]);
    SetVehicleHandlingInt(vehicleid, HANDLING_ABS, HandlingVehInfo[vehicleid][HD_Zalupa]);

    /*
    SendClientMessageToAll(COLOR_RED, "vehicleid %d", vehicleid);
    SendClientMessageToAll(-1, "HD_Mass %0.2f", HandlingVehInfo[vehicleid][HD_Mass]);
    SendClientMessageToAll(-1, "HD_TurnMass %0.2f", HandlingVehInfo[vehicleid][HD_TurnMass]);
    SendClientMessageToAll(-1, "HD_Drag %0.2f", HandlingVehInfo[vehicleid][HD_Drag]);
    SendClientMessageToAll(-1, "HD_CentreOfMassX %0.2f", HandlingVehInfo[vehicleid][HD_CentreOfMassX]);
    SendClientMessageToAll(-1, "HD_CentreOfMassY %0.2f", HandlingVehInfo[vehicleid][HD_CentreOfMassY]);
    SendClientMessageToAll(-1, "HD_CentreOfMassZ %0.2f", HandlingVehInfo[vehicleid][HD_CentreOfMassZ]);
    SendClientMessageToAll(-1, "HD_TractionMultiplier %0.2f", HandlingVehInfo[vehicleid][HD_TractionMultiplier]);
    SendClientMessageToAll(-1, "HD_TractionLoss %0.2f", HandlingVehInfo[vehicleid][HD_TractionLoss]);
    SendClientMessageToAll(-1, "HD_NumberOfGears %d", HandlingVehInfo[vehicleid][HD_NumberOfGears]);
    SendClientMessageToAll(-1, "HD_MaxVelocity %0.2f", HandlingVehInfo[vehicleid][HD_MaxVelocity]);
    SendClientMessageToAll(-1, "HD_EngineAcceleration %0.2f", HandlingVehInfo[vehicleid][HD_EngineAcceleration]);
    SendClientMessageToAll(-1, "HD_EngineInertia %0.2f", HandlingVehInfo[vehicleid][HD_EngineInertia]);
    SendClientMessageToAll(-1, "HD_BrakeDeceleration %0.2f", HandlingVehInfo[vehicleid][HD_BrakeDeceleration]);
    SendClientMessageToAll(-1, "HD_BrakeBias %0.2f", HandlingVehInfo[vehicleid][HD_BrakeBias]);
    SendClientMessageToAll(-1, "HD_ABS %d", HandlingVehInfo[vehicleid][HD_ABS]);
    SendClientMessageToAll(-1, "HD_SteeringLock %0.2f", HandlingVehInfo[vehicleid][HD_SteeringLock]);
    SendClientMessageToAll(-1, "HD_SuspensionForceLevel %0.2f", HandlingVehInfo[vehicleid][HD_SuspensionForceLevel]);
    SendClientMessageToAll(-1, "HD_SuspensionDampingLevel %0.2f", HandlingVehInfo[vehicleid][HD_SuspensionDampingLevel]);
    SendClientMessageToAll(-1, "HD_SuspensionHighSpdComDamp %0.2f", HandlingVehInfo[vehicleid][HD_SuspensionHighSpdComDamp]);
    SendClientMessageToAll(-1, "HD_SuspensionUpperLimit %0.2f", HandlingVehInfo[vehicleid][HD_SuspensionUpperLimit]);
    SendClientMessageToAll(-1, "HD_SuspensionLowerLimit %0.2f", HandlingVehInfo[vehicleid][HD_SuspensionLowerLimit]);
    SendClientMessageToAll(-1, "HD_SuspensionBiasBetweenFrontAndRear %0.2f", HandlingVehInfo[vehicleid][HD_SuspensionBiasBetweenFrontAndRear]);
    SendClientMessageToAll(-1, "HD_Zalupa %d", HandlingVehInfo[vehicleid][HD_Zalupa]);
    SendClientMessageToAll(COLOR_RED, " ");
    */
    return 1;
}

// Ищем хенлдлинг тачки по её id
stock FindVehicleModelHandling(model)
{
    new findHandling = -1;
    for(new v = 0; v < sizeof(vehName) + sizeof(vehNameCustom); v++)
    {
        if(DefaultHandling[v][HD_ModelID] == model)
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
            DefaultHandling[quan][HD_Name],
            DefaultHandling[quan][HD_Mass],
            DefaultHandling[quan][HD_TurnMass],
            DefaultHandling[quan][HD_Drag],
            DefaultHandling[quan][HD_CentreOfMassX],
            DefaultHandling[quan][HD_CentreOfMassY],
            DefaultHandling[quan][HD_CentreOfMassZ],
            DefaultHandling[quan][HD_Boyant],
            DefaultHandling[quan][HD_TractionMultiplier],
            DefaultHandling[quan][HD_TractionLoss],
            DefaultHandling[quan][HD_TractionBias],
            DefaultHandling[quan][HD_NumberOfGears],
            DefaultHandling[quan][HD_MaxVelocity],
            DefaultHandling[quan][HD_EngineAcceleration],
            DefaultHandling[quan][HD_EngineInertia],
            DefaultHandling[quan][HD_Zalupa],
            DefaultHandling[quan][HD_Zalupa2],
            DefaultHandling[quan][HD_BrakeDeceleration],
            DefaultHandling[quan][HD_BrakeBias],
            DefaultHandling[quan][HD_ABS],
            DefaultHandling[quan][HD_SteeringLock],
            DefaultHandling[quan][HD_SuspensionForceLevel],
            DefaultHandling[quan][HD_SuspensionDampingLevel],
            DefaultHandling[quan][HD_SuspensionHighSpdComDamp],
            DefaultHandling[quan][HD_SuspensionUpperLimit],
            DefaultHandling[quan][HD_SuspensionLowerLimit],
            DefaultHandling[quan][HD_SuspensionBiasBetweenFrontAndRear]))
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
                if(strfind(DefaultHandling[v][HD_Name], Temp[VD_Handling],true) != (-1))
                {
                    if(Temp[VD_Id] >= 612 && Temp[VD_Id] <= 15265) DefaultHandling[v][HD_ModelID] = Temp[VD_Id] - 13066;
				    else if(Temp[VD_Id] >= 15266) DefaultHandling[v][HD_ModelID] = Temp[VD_Id] - 13164;
                    else DefaultHandling[v][HD_ModelID] = Temp[VD_Id];
                }
            }
        }
    }
    fclose(f);
    return 1;
}

/*
    Определение нового кастомного компонента транспорта:

    1. Переходим в сток VehicleCustomComponentsLoad
    2. Добавляем или изменяем уже существующую категорию (например, Wheels):
        - Вызываем SetVehicleCustomComponentType(*номер объекта*, *номер слота*);

    * Слоты компонентов используются только на стороне сервера и созданы для предотвращения неразберихи между назначением различных компонентов на один транспорт.
    * Поэтому, компонент всё равно будет "вставать" на свое место, но при этом может быть заменён, например, при установке нитро, если ему задан неверный слот.
*/

stock VehicleCustomComponentsLoad()
{
    // Wheels
    SetVehicleCustomComponentType(12246, VEHICLE_COMPONENT_WHEELS);
    for (new id = 12500; id <= 12508; id++) SetVehicleCustomComponentType(id, VEHICLE_COMPONENT_WHEELS);

    return 1;
}

stock GetVehicleCustomComponentTypeName(VEHICLE_COMPONENTS_TYPE: type)
{
    new result[64];  // Array to store the result as a string
    switch (type) {
        case VEHICLE_COMPONENT_SPOILER: strcat(result, "Спойлер");
        case VEHICLE_COMPONENT_HOOD: strcat(result, "Капот");
        case VEHICLE_COMPONENT_ROOF: strcat(result, "Крыша");
        case VEHICLE_COMPONENT_SIDESKIRT: strcat(result, "Боковые накладки");
        case VEHICLE_COMPONENT_LAMPS: strcat(result, "Фары");
        case VEHICLE_COMPONENT_NITRO: strcat(result, "Нитро");
        case VEHICLE_COMPONENT_EXHAUST: strcat(result, "Выходное устройство");
        case VEHICLE_COMPONENT_WHEELS: strcat(result, "Колеса");
        case VEHICLE_COMPONENT_STEREO: strcat(result, "Стереосистема");
        case VEHICLE_COMPONENT_HYDRAULICS: strcat(result, "Гидравлика");
        case VEHICLE_COMPONENT_FRONTBUMPER: strcat(result, "Передний бампер");
        case VEHICLE_COMPONENT_REARBUMPER: strcat(result, "Задний бампер");
        case VEHICLE_COMPONENT_VENTRIGHT: strcat(result, "Вентиляция справа");
        case VEHICLE_COMPONENT_VENTLEFT: strcat(result, "Вентиляция слева");
        case VEHICLE_COMPONENT_FRONTBULLBAR: strcat(result, "Передний металлический бампер");
        case VEHICLE_COMPONENT_REARBULLBAR: strcat(result, "Задний металлический бампер");
        default: strcat(result, "Неизвестно");
    }
    return result;
}

CMD:vehiclecomponent(playerid, const params[])
{
    if (PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "Вам недоступна эта команда");

    new component;
    if (sscanf(params, "d", component))
    {
        return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Установить компонент транспорта [ /vehiclecomponent ID ]");
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsValidVehicle(vehicleid)) return ErrorMessage(playerid, "{ff6347}Вы должны находиться внутри транспорта");

    if (!AddVehicleComponent(vehicleid, component))
    {
        return ErrorMessage(playerid, "{ff6347}Не удалось установить компонент");
    }

    return 1;
}

CMD:defvehiclecomponent(playerid, const params[])
{
    if (PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "Вам недоступна эта команда");
    
    new component, type;
    if (sscanf(params, "dd", component, type)) {
        return SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Определить слот компонента транспорта [ /defvehiclecomponent ID Type ]");
    }

    SetVehicleCustomComponentType(component, VEHICLE_COMPONENTS_TYPE: type);
    SendClientMessage(playerid, COLOR_GRAY,
        "[ Мысли ]: Тип компонента успешно установлен {ff9000}(ID: %d, Тип: %s)",
        component, GetVehicleCustomComponentTypeName(VEHICLE_COMPONENTS_TYPE: type)
    );

    return 1;
}

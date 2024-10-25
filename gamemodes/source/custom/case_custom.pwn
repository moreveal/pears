
/*
Как добавить новую вариацию кастомного кейса?
1. Добавляем новый идентификатор по названию в customCaseNameID
2. Добавляем полное название кейса в customCaseName
3. Добавляем в stock GetModelCustomCase объект (как будет выглядеть новый кейс)
4. Добавляем в stock GetCustomCaseInventoryPack(caseID) (id упаковки внутри системы инвентаря)

5. Если кейсу нужен ключ, добавляем строки в stock GetKeyIDCustomCase(keyID)
    - А также обязательно прописываем новый ключ предмет в inventory.pwn
*/

// Идентификатор кастомных кейсов
new customCaseNameID[][] =
{
    "maniac", "village", "yakuza", "gold", "graves"
};

// Названия кастомных кейсов
new customCaseName[][] =
{
    "Кейс Маньяка", "Кейс Деревенских", "Кейс Yakuza", "Gold Кейс", "Похоронный кейс"
};

// Упаковки, которые относятся к кейсу
stock IsACasePackID(thingPack)
{
    return thingPack == 5 || GetInventoryPackCustomCase(thingPack) != -1;
}

// ID объекта, как выглядит кейс
stock GetModelCustomCase(thingPack)
{
    new model;
    if(thingPack == 6) model = 12260; // maniac
    else if(thingPack == 7) model = 12259; // village
    else if(thingPack == 8) model = 12261; // yakuza
    else if(thingPack == 9) model = 12303; // gold
    else if(thingPack == 10) model = 12352; // graves
    else model = 19918;
    return model;
}

// Получаем ID упаковки кейса внутри системы инвентаря
stock GetCustomCaseInventoryPack(caseID)
{
    new thingPack;
    if(caseID == 0) thingPack = 6; // maniac
    else if(caseID == 1) thingPack = 7; // village
    else if(caseID == 2) thingPack = 8; // yakuza
    else if(caseID == 3) thingPack = 9; // gold
    else if(caseID == 4) thingPack = 10; // graves
    return thingPack;
}

// Получаем ID кейса отталкиваясь от ID упаковки
stock GetInventoryPackCustomCase(thingPack)
{
    for (new i = 0; i < sizeof(customCaseNameID); i++)
    {
        new packid = GetCustomCaseInventoryPack(i);
        if (packid > 0 && thingPack == packid) return i;
    }
    
    return -1;
}

stock GetCaseName(thingPack)
{
    new name[30];
    new caseID = GetInventoryPackCustomCase(thingPack);
	if(caseID == -1) format(name, sizeof(name),"Кейс");
	else format(name, sizeof(name),"%s", customCaseName[caseID]);
    return name;
}

// Предмет - ключ от кастомного кейса
stock IsKeyCustomCase(thingId)
{
    for (new i = 0; i < sizeof(customCaseNameID); i++)
    {
        new keyid = GetKeyIDCustomCase(i);
        if (keyid >= 0 && thingId == keyid) {
            return true;
        }
    }
    return false;
}

// Нужен ли ключ для кастомного кейса и какой у него ID
stock GetKeyIDCustomCase(caseID)
{
    switch (caseID)
    {
        case 0: return 234;
        case 2: return 235;
        case 4: return 241;
    }
    return -1;
}

#define MAX_THING_FOR_CASE 100 // Максимальное количество вариаций предметов для кейса
#define JSON_CUSTOM_CASE_FILE "scriptfiles/custom_case.json" // Путь к JSON файлу

// Определяем структуру данных с помощью enum
enum ManiacItem
{
    THING,
    TYPE,
    AMOUNT,
    CHANCE,
    PARA
};

new CustomCaseItems[sizeof(customCaseNameID)][MAX_THING_FOR_CASE][ManiacItem]; // Массив для хранения данных, рассчитан на 100 элементов
new totalItems[sizeof(customCaseNameID)]; // Общее количество элементов

CMD:testcase(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(!strlen(params)) return ErrorMessage(playerid, "{FF6347}Вы не указали идентификатор кейса\nПримеры: maniac, village, yakuza");

    new caseID = GetCustomCaseID(params);
    if(caseID == -1) return ErrorMessage(playerid, "{FF6347}Идентификатор кейса не найден в моде сервера");

    new selectedThing = SelectRandomThing(caseID);
    if (selectedThing != -1)
    {
        new string[144];
        format(string, sizeof(string), "Кейс %s, Элемент %d", params, CustomCaseItems[caseID][selectedThing][THING]);
        if (CustomCaseItems[caseID][selectedThing][THING] > -1) format(string, sizeof(string), "%s {ff9000}[ %s ]", string, GetNameThing(0, CustomCaseItems[caseID][selectedThing][THING], CustomCaseItems[caseID][selectedThing][TYPE], 0));
        else strcat(string, " {ff9000}[ Обычный предмет ]");

        SendClientMessage(playerid, COLOR_GREY, string);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "Кейс %s, {FF6347}Не удалось выбрать элемент", params);
    }
    return true;
}

CMD:rcase(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(!strlen(params)) return ErrorMessage(playerid, "{FF6347}Вы не указали идентификатор кейса\nПримеры: maniac, village, yakuza");
    new quan;
    new reason = ParseCustomCaseItems(playerid, params, quan);
    if(reason == -1) return ErrorMessage(playerid, "{FF6347}Кастомный кейс с таким идентификатором в json файле не найден\nПримеры: maniac, village, yakuza");

    new string[140];
    format(string, sizeof(string), "{99ff66}В кастомный кейс %s загружено %d элементов", params, quan);
	SuccessMessage(playerid, string);
    return true;
}

CMD:showcase(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(!strlen(params)) return ErrorMessage(playerid, "{FF6347}Вы не указали идентификатор кейса\nПримеры: maniac, village, yakuza");

    new caseID = GetCustomCaseID(params);
    if(caseID == -1) return ErrorMessage(playerid, "{FF6347}Идентификатор кейса не найден в моде сервера");

    new line[200],lines[3000];
    format(line,sizeof(line),"{cccccc}Идентификатор: %s [ID %d]", params, caseID), strcat(lines,line);

    for(new i = 0; i < totalItems[caseID]; i++)
    {
        format(line,sizeof(line),"\n{ff9000}%s {cccccc}[ thing %d, type %d, amount %d, chance %d ]", 
            GetNameThing(0, CustomCaseItems[caseID][i][THING], CustomCaseItems[caseID][i][TYPE], 0),
            CustomCaseItems[caseID][i][THING], CustomCaseItems[caseID][i][TYPE], CustomCaseItems[caseID][i][AMOUNT], CustomCaseItems[caseID][i][CHANCE]), strcat(lines,line);
    }
    ShowDialog(playerid,1700,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Кастомный Кейс",lines,"Выбор","Отмена");
    return true;
}

// Получаем предметы внутри переменных для формирования кейса
stock CustomThingCase(caseID, selectedThing, &thingId, &thingQuan, &thingPara, &thingType, &thingPack)
{
    thingId = CustomCaseItems[caseID][selectedThing][THING];
    thingType = CustomCaseItems[caseID][selectedThing][TYPE];
    thingQuan = CustomCaseItems[caseID][selectedThing][AMOUNT];
    thingPara = CustomCaseItems[caseID][selectedThing][PARA];
    thingPack = GetCustomCaseInventoryPack(caseID);

    if(thingType == 0) thingQuan = 0; // Обычный предмет (Сбрасываем количество, оно применяется системами сервера)
    else if(thingType == 1) thingPara = GUN_HEALTH; // Оружие (Устанавливаем дефолтное хп оружию)
    else if(thingType == 5) thingQuan = 1 + random(254); // Транспорт (Устанавливаем цвет транспорта)
    return true;
}

// Поиск ID кейса по названию
stock GetCustomCaseID(const name[])
{
    new id = -1;
    if(strcmp(name,"gold") == 0) return id;

    for(new i = 0; i < sizeof(customCaseNameID); i++)
    {
        if(!strcmp(name, customCaseNameID[i], true))
        {
            id = i;
            break;
        }
    }
    
    return id;
}

// Загружаем все кейсы в переменную при запуске сервера
stock LoadCustomCaseOnGameMode()
{
    for(new i = 0; i < sizeof(customCaseNameID); i++)
    {
        new quan;
        ParseCustomCaseItems(INVALID_PLAYER_ID, customCaseNameID[i], quan);
    }
    return true;
}

stock ParseCustomCaseItems(playerid, const name[], &quan)
{
    if (!strcmp(name, "gold", true)) return 0;

    // Парсинг JSON файла
    new JsonNode:rootNode;
    if (JSON_ParseFile(JSON_CUSTOM_CASE_FILE, rootNode) != JSON_CALL_NO_ERR)
    {
        if(playerid != INVALID_PLAYER_ID) ErrorMessage(playerid, "{FF6347}Ошибка при парсинге JSON файла");
        return 0;
    }
    
    new JsonNode:maniacNode;
    if (JSON_GetObject(rootNode, name, maniacNode) != JSON_CALL_NO_ERR)
    {
        printf("Не удалось найти массив '%s' в JSON файле", name);
        JSON_Cleanup(rootNode);
        return -1;
    }

    new length;
    if (JSON_ArrayLength(maniacNode, length) != JSON_CALL_NO_ERR)
    {
        if(playerid != INVALID_PLAYER_ID) ErrorMessage(playerid, "{FF6347}Не удалось получить длину массива в json");
        JSON_Cleanup(rootNode);
        return 0;
    }

    new caseID = GetCustomCaseID(name);
    if(caseID == -1)
    {
        if(playerid != INVALID_PLAYER_ID) ErrorMessage(playerid, "{FF6347}Идентификатор кейса не найден в моде сервера");
        return 0;
    }

    if(length > MAX_THING_FOR_CASE) length = MAX_THING_FOR_CASE; // Защита от перелимита по количеству предметов для кейса внутри json файла

    totalItems[caseID] = length;
    for (new i = 0; i < length; i++)
    {
        new JsonNode:itemNode;
        if (JSON_ArrayObject(maniacNode, i, itemNode) != JSON_CALL_NO_ERR)
        {
            printf("Не удалось получить элемент массива '%s'", name);
            continue;
        }

        new thingID, thingQuan, thingPara, thingType, thingChance;
        JSON_GetInt(itemNode, "thing", thingID);
        JSON_GetInt(itemNode, "type", thingType);
        JSON_GetInt(itemNode, "amount", thingQuan);
        JSON_GetInt(itemNode, "chance", thingChance);
        JSON_GetInt(itemNode, "para", thingPara);

        // Если добавлен аксессуар, ищем его внутри общей системы
        new findBone;
        if(thingType == 2)
        {
            findBone = FormingCustomCaseAccessory(thingID);
            if(findBone >= 0) WriteItemsForCase(caseID, quan, thingID, thingType, thingQuan, thingChance, findBone), quan ++;
            else totalItems[caseID] --;
        }
        else WriteItemsForCase(caseID, quan, thingID, thingType, thingQuan, thingChance, thingPara), quan ++;

        // Очистка узла после использования
        JSON_Cleanup(itemNode);
    }

    // Очистка корневого узла
    JSON_Cleanup(rootNode);
    return 1;
}

stock WriteItemsForCase(caseID, i, thingID, thingType, thingQuan, thingChance, thingPara)
{
    CustomCaseItems[caseID][i][THING] = thingID;
    CustomCaseItems[caseID][i][TYPE] = thingType;
    CustomCaseItems[caseID][i][AMOUNT] = thingQuan;
    CustomCaseItems[caseID][i][CHANCE] = thingChance;
    CustomCaseItems[caseID][i][PARA] = thingPara;
    return true;
}

stock SelectRandomThing(caseID)
{
    new totalChance = 0;
    for (new i = 0; i < totalItems[caseID]; i++)
    {
        totalChance += CustomCaseItems[caseID][i][CHANCE];
    }

    new randomValue = random(totalChance);

    new cumulativeChance = 0;
    for (new i = 0; i < totalItems[caseID]; i++)
    {
        cumulativeChance += CustomCaseItems[caseID][i][CHANCE];
        if (randomValue < cumulativeChance) {
            return i;
        }
    }
    return -1;
}

stock FormingCustomCaseAccessory(thingID) // В момент формирования кастомного кейса, ищем аксессуар внутри системы
{
    new thingBone = -1;
    for(new i; i < MAX_ACCESSORY; i++)
    {
        if(AccessoryInfo[i][acModel] == thingID)
        {
            thingBone = AccessoryInfo[i][acBone];
            break;
        }
    }
    return thingBone;
}

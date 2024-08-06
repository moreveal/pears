
#define MAX_THING_FOR_CASE 100 // Максимальное количество вариаций предметов для кейса
#define JSON_FILE "scriptfiles/custom_case.json" // Путь к JSON файлу
#define MAX_RAND_VALUE 32767

// Определяем структуру данных с помощью enum
enum ManiacItem
{
    THING,
    TYPE,
    AMOUNT,
    CHANCE,
    PARA
};

new ManiacItems[100][ManiacItem]; // Массив для хранения данных, рассчитан на 100 элементов
new totalItems; // Общее количество элементов

CMD:testcase(playerid)
{
    new selectedThing = SelectRandomThing();
    if (selectedThing != -1)
    {
        printf("Выбранный элемент: Thing: %d", ManiacItems[selectedThing][THING]);
    }
    else
    {
        print("Не удалось выбрать элемент");
    }
    return true;
}

CMD:rcase(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(!strlen(params)) return ErrorMessage(playerid, "{FF6347}Вы не указали идентификатор кейса\nПримеры: maniac, village, yakuza");
    new quan;
    new reason = ParseCustomCaseItems(params, quan);
    if(reason == -1) return ErrorMessage(playerid, "{FF6347}Кастомный кейс с таким идентификатором не найден\nПримеры: maniac, village, yakuza");

    new string[140];
    format(string, sizeof(string), "{99ff66}В кастомный кейс %s загружено %d элементов", params, quan);
	SuccessMessage(playerid, string);
    return true;
}

stock ParseCustomCaseItems(const name[], &quan)
{
    // Парсинг JSON файла
    new JsonNode:rootNode;
    if (JSON_ParseFile(JSON_FILE, rootNode) != JSON_CALL_NO_ERR)
    {
        print("Ошибка при парсинге JSON файла");
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
        printf("Не удалось получить длину массива '%s'", name);
        JSON_Cleanup(rootNode);
        return 0;
    }

    totalItems = length;

    for (new i = 0; i < length; i++)
    {
        new JsonNode:itemNode;
        if (JSON_ArrayObject(maniacNode, i, itemNode) != JSON_CALL_NO_ERR)
        {
            printf("Не удалось получить элемент массива '%s'", name);
            continue;
        }

        JSON_GetInt(itemNode, "thing", ManiacItems[i][THING]);
        JSON_GetInt(itemNode, "type", ManiacItems[i][TYPE]);
        JSON_GetInt(itemNode, "amount", ManiacItems[i][AMOUNT]);
        JSON_GetInt(itemNode, "chance", ManiacItems[i][CHANCE]);
        JSON_GetInt(itemNode, "para", ManiacItems[i][PARA]);
        quan ++;

        // Очистка узла после использования
        JSON_Cleanup(itemNode);
    }

    // Очистка корневого узла
    JSON_Cleanup(rootNode);
    return 1;
}

stock SelectRandomThing()
{
    new totalChance = 0;
    for (new i = 0; i < totalItems; i++)
    {
        totalChance += ManiacItems[i][CHANCE];
    }

    new randomValue = random(totalChance);

    new cumulativeChance = 0;
    for (new i = 0; i < totalItems; i++)
    {
        cumulativeChance += ManiacItems[i][CHANCE];
        if (randomValue < cumulativeChance) {
            return i;
        }
    }
    return -1;
}


// Сериализация в строку
stock StringifyArray(const array[], size) 
{
    static string[4096];
    string[0] = '\0'; // Обнуляем строку перед использованием
    new length = 0;

    for (new i = 0; i < size; i++) 
    {
        new numString[12];
        format(numString, sizeof(numString), "%d", array[i]);
        
        if (length + strlen(numString) < sizeof(string)) {
            strcat(string, numString);
            length += strlen(numString);
        }

        if (i < size - 1 && length < sizeof(string) - 1) 
        {
            strcat(string, ",");
            length++;
        }
    }
    return string;
}

// Разбираем строку на символы
stock ParseStringToArray(const inputString[], outputArray[], outputSize) 
{
    new token[12];
    new tokenIndex = 0, arrayIndex = 0;

    // Проходим по каждому символу в строке
    for (new i = 0; inputString[i] != '\0' && arrayIndex < outputSize; i++) 
    {
        if (inputString[i] == ',' || inputString[i] == '\0') 
        {
            token[tokenIndex] = '\0'; // Завершаем текущий токен
            outputArray[arrayIndex] = strval(token); // Преобразуем токен в число и сохраняем в массив
            arrayIndex ++; // Переходим к следующему элементу массива
            tokenIndex = 0; // Сбрасываем индекс токена для следующего числа
        } 
        else 
        {
            token[tokenIndex++] = inputString[i]; // Добавляем символ к текущему токену
        }
    }
}

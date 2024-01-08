
// Сериализация в строку
stock StringifyArray(const array[], size) 
{
    new string[4096];
    new length = 0;

    // Использование функции strcat для более эффективной конкатенации
    for (new i = 0; i < size; i++) 
    {
        new numString[12];
        format(numString, sizeof(numString), "%d", array[i]);
        
        strcat(string, numString, sizeof(string) - length);
        length += strlen(numString);

        if (i < size - 1) 
        {
            strcat(string, ",", sizeof(string) - length);
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

/**
    В данном файле будут находиться различные функции и информация, касающаяся экономики сервера
    Здесь следует быть предельно внимательным и осторожным, при работе с процентами держать в уме фактор сложных процентов
    И просто держать калькулятор при себе
    В конце данного файла имеются парочку примеров с применением тех или иных функций, связанных с финансами

    Копейка рубль бережёт
 */

/**
    Функция преобразует удобные 100% и прочие проценты в дробный вариант
    Входное значение является числом с плавающей точкой, сделано это для того, чтобы можно было указывать более гибкие проценты
    - 80.2%, 4.35% и пр.
    Внимательнее! На вход можно подавать любое значение, даже больше ста процентов,
    что может создать непредвиденные баги при работе с числами с плавающими точками (в моменты, когда числом получаются сверхбольшие значения)
    Отрицательные проценты тоже возможны

    Именно результат этой функции следует использовать в функциях, связанных с процентами, например, в ComputeShares
 */
stock Float:PercentageToFraction(const Float:percentage)
{
    return percentage / 100.0;
}

/**
    Функция считает процент от дробного числа
    В amount необходимо передавать само число, а в fraction -- дробь числа, например, результат функции PercentageToFraction
    Округляет числа в меньшую сторону
 */
stock ComputePercentOfNum(const amount, const Float:fraction)
{
    return floatround(float(amount) * fraction, floatround_floor);
}

/**
    Функция считает пропорции в зависимости от указанных процентов и преимущественно используется для налогов
    В out нужно передать массив, в который будут класться суммы в соответствии с их пропорцией
    В out_fractions нужно передать массив, в котором будут храниться пропорции взиваемых объёмов

    Возвращает сумму после высчета всех налогообложений
    Может вернуть -1, если произошла какая-то ошибка при попытке вычислений
 */
stock ComputeShares(const amount, out[], const Float:out_fractions[], const out_size = sizeof(out), const out_fractions_size = sizeof(out_fractions))
{
    if (amount < 0) return -1;
    if (out_size != out_fractions_size) return -1;

    new Float:result_percentage = 1.0; // 1.0 = 100%, отражает итоговый процент, который вернётся функцией
    new result = amount;
    for (new i = 0; i < out_size; i++)
    {
        if (!(out_fractions[i] >= 0.0 && out_fractions[i] <= 1.0)) return -1;
        out[i] = ComputePercentOfNum(amount, out_fractions[i]);
        result_percentage -= out_fractions[i];
        result -= out[i];
    }
    if (result_percentage < 0.0 || result < 0) return -1;
    return result;
}

/**
    Проверка наличия указанного количества денег в казне

    Может вернуть false, если amount меньше нуля
 */
stock bool:IsAmountInTreasury(const amount)
{
    if (amount < 0) return false;
    return OrganInfo[7][glave] >= amount;
}

/**
    Функция кладёт указанное количество вирт в казну правительства
    В поле purpose следует прописать источник денег
    Подробности не важны, достаточно лишь информации об источнике денег "Покупка дома", "Конвертация фишек в казино" и пр.

    Может вернуть false, если amount меньше нуля
 */
stock bool:PutMoneyToTreasury(const amount, const purpose[])
{
    if (amount < 0) return false;

    bigint_add(OrganInfo[7][glave], amount);
    OrganInfo[7][gUpdate] = 1;

    // TODO: Лог о пополнении казны
    #pragma unused purpose

    return true;
}

/**
    Функция забирает указанное количество вирт из казны правительства
    В поле purpose следует прописать назначение денег
    Подробности не важны, достаточно лишь информации об источнике денег "Вытащили из казны", "Зарплата в ферме", "Зарплата PayDay" и пр.

    Может вернуть false, если в казне нет указанного количества денег, или если amount меньше нуля
 */
stock bool:TakeMoneyFromTreasury(const amount, const purpose[])
{
    if (amount < 0) return false;

    if (!IsAmountInTreasury(amount))
    {
        return false;
    }

    bigint_sub(OrganInfo[7][glave], amount);
    OrganInfo[7][gUpdate] = 1;

    // TODO: Лог о снятии денег из казны
    #pragma unused purpose

    return true;
}


/**

    Примеры

 */

// // Пример использования функций PercentageToFraction и ComputeShares
// stock ComputeSharesExample(const playerid, const fishkiAmount)
// {
//     /**
//         Считаем налоги на продажу фишек в казино
//         Представим ситуацию, когда нам необходимо:
//         - 5% с продажи фишек должно идти в казну в качестве налога
//         - 3% с продажи фишек должно идти в само казино в качестве заработка
//         - 2.2% денег необходимо уничтожить (не отправлять никуда)

//         Оставшиеся деньги возвращаем игроку
//     */
//     /**
//         Рядом с объявленной переменной категорически рекомендуется расписать индекс каждого из значений и их назначение
//         Здесь можно использовать хоть enum, хоть константы, всё равно. Главное, чтобы всё было понятно

//         0 = деньги в казну
//         1 = деньги в казино
//         2 = деньги в никуда (уничтожение)
//     */
//     {
//         // Любое подобное вычисление оборачиваем в отдельный блок, чтобы при создании одних и тех же констант в общих блоках проблем не было
//         // Со вложенными блоками варнинги будут, но не проблема. Можно, как вариант, отключить варнинг

//         const MONEY_TO_TREASURY = 0;
//         const MONEY_TO_CASINO = 1;
//         const MONEY_TO_NULL = 2;
//         const SHARES_MAX = 3;

//         new shares[SHARES_MAX];
//         new Float:shares_percent[SHARES_MAX];
//         shares_percent[MONEY_TO_TREASURY] = PercentageToFraction(5.0);
//         shares_percent[MONEY_TO_CASINO] = PercentageToFraction(3.0);
//         shares_percent[MONEY_TO_NULL] = PercentageToFraction(2.2); // 2.2% в мусорку
//         new toGive = ComputeShares(fishkiAmount, shares, shares_percent);
//         if (toGive < 0)
//         {
//             // Какая-то ошибка произошла при подсчётах. Проверить, изучить и исправить появившуюся ошибку!
//             // Пишем в лог информацию и ни в коем случае не производим никакие действия дальше
//             return false;
//         }
//         PlayerInfo[playerid][pAmmos1] -= fishkiAmount;
//         oGivePlayerMoney(playerid, toGive);
//         PutMoneyToTreasury(shares[MONEY_TO_TREASURY], "Налог за продажу фишек в казино");
//         paybiz(200, shares[MONEY_TO_CASINO]);
//     }

//     return true;
// }

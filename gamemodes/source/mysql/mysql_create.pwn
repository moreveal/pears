
stock CreateMysqlTable()
{
	AddColumnIfNotExists("pp_igroki", "pTaxesUnix", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_igroki", "pNotCloseVeh", "BOOLEAN NOT NULL DEFAULT FALSE");

    AddColumnIfNotExists("pp_bizz", "bAtmCollector", "INT NOT NULL DEFAULT '0'");
	return true;
}


// Функция для проверки существования столбца и его добавления
stock AddColumnIfNotExists(const table[], const column[], const definition[])
{
    new query[256];
    
    // Проверяем, существует ли столбец
    format(query, sizeof(query), "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '%s' AND COLUMN_NAME = '%s'", table, column);
    
    // Выполняем запрос и проверяем количество строк в результате
    if (mysql_query(pearsq, query))
    {
        new rows;
		cache_get_row_count(rows); // Получаем количество строк в результате запроса
        
        // Если строк больше нуля, значит столбец существует
        if(rows == 0)
        {
            // Если столбец не существует, добавляем его
            format(query, sizeof(query), "ALTER TABLE `%s` ADD `%s` %s", table, column, definition);
            mysql_query(pearsq, query);
        }
    }
}

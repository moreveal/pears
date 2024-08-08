
stock CreateMysqlTable()
{
	AddColumnIfNotExists("pp_igroki", "pTaxesUnix", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_igroki", "pNotCloseVeh", "BOOLEAN NOT NULL DEFAULT FALSE");
    AddColumnIfNotExists("pp_igroki", "pSharkTrap", "BLOB NULL DEFAULT NULL");
    AddColumnIfNotExists("pp_igroki", "pDivRank0", "INT NOT NULL DEFAULT '0'"); // Ранг в подфракции
    AddColumnIfNotExists("pp_igroki", "pDivRank1", "INT NOT NULL DEFAULT '0'"); // Ранг в подфракции для fbi под прикрытием
    AddColumnIfNotExists("pp_igroki", "pSunScreen", "INT NOT NULL DEFAULT '0'"); // Солнцезащитный крем
    AddColumnIfNotExists("pp_igroki", "pManiacCD", "INT NOT NULL DEFAULT '0'"); // Кд на повторное создание маньяка
    AddColumnIfNotExists("pp_igroki", "pGymUnix", "INT NOT NULL DEFAULT '0'"); // Абонемент в спортзал
    AddColumnIfNotExists("pp_igroki_maniac", "pManiacQwest", "INT NOT NULL DEFAULT '0'"); // Процесс выполнения квеста с маньяком

    AddColumnIfNotExists("pp_bizz", "bAtmCollector", "INT NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("pp_organization", "gMedMoney", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_organization", "gWarehouse", "BOOLEAN NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("pp_dom", "dDoorInt0", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dDoorInt1", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dDoor0", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dDoor1", "INT NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("pp_dom", "dCoordDopDoorOneX", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dCoordDopDoorOneY", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dCoordDopDoorOneZ", "FLOAT NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("pp_dom", "dCoordDopDoorTwoX", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dCoordDopDoorTwoY", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dCoordDopDoorTwoZ", "FLOAT NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("pp_dom", "dCoordDopDoorOneIntX", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dCoordDopDoorOneIntY", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dCoordDopDoorOneIntZ", "FLOAT NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("pp_dom", "dCoordDopDoorTwoIntX", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dCoordDopDoorTwoIntY", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dCoordDopDoorTwoIntZ", "FLOAT NOT NULL DEFAULT '0'");

    // Аксессуары
    AddColumnIfNotExists("accessory", "acCase", "BOOLEAN NOT NULL DEFAULT '0'");

    // Подсказки с озвучкой
    AddColumnIfNotExists("pp_igroki_hint", "hint1", "INT NOT NULL DEFAULT '0'"); // Подсказка от джоне о деревенских
    AddColumnIfNotExists("pp_igroki_hint", "hint2", "INT NOT NULL DEFAULT '0'"); // Подсказка от джоне о маньяке
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

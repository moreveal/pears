function PriceSkinPad()
{
    new rows;
    cache_get_row_count(rows);
    if (!rows) return 0;

    // Получаем максимальный ID скина в таблице
    new skinid;
    cache_get_value_name_int(0, "skin", skinid);

    // Узнаем сколько осталось
    new remains = MAX_MODELS_SKIN - (skinid + 1);
    
    if (remains > 0)
    {
        skinid++; // Для удобного построения цикла ниже

        mysql_tquery(pearsq, "START TRANSACTION;");

        new string[144];
        for (new i = skinid; i < skinid + remains; i++)
        {
            mysql_format(pearsq, string, sizeof(string), "INSERT INTO `pp_priceskin` SET `skin` = '%d'", i);
            query_empty(pearsq, string);
        }

        mysql_tquery(pearsq, "COMMIT;");
    }

    return 1;
}

stock CreateMysqlTable()
{
	AddColumnIfNotExists("pp_igroki", "pTaxesUnix", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_igroki", "pUnixRename", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_igroki", "pNotCloseVeh", "BOOLEAN NOT NULL DEFAULT FALSE");
    AddColumnIfNotExists("pp_igroki", "pSharkTrap", "BLOB NULL DEFAULT NULL");
    AddColumnIfNotExists("pp_igroki", "pDivRank0", "INT NOT NULL DEFAULT '0'"); // Ранг в подфракции
    AddColumnIfNotExists("pp_igroki", "pDivRank1", "INT NOT NULL DEFAULT '0'"); // Ранг в подфракции для fbi под прикрытием
    AddColumnIfNotExists("pp_igroki", "pSunScreen", "INT NOT NULL DEFAULT '0'"); // Солнцезащитный крем
    AddColumnIfNotExists("pp_igroki", "pManiacCD", "INT NOT NULL DEFAULT '0'"); // Кд на повторное создание маньяка
    AddColumnIfNotExists("pp_igroki", "pGymUnix", "INT NOT NULL DEFAULT '0'"); // Абонемент в спортзал
    AddColumnIfNotExists("pp_igroki_maniac", "pManiacQwest", "INT NOT NULL DEFAULT '0'"); // Процесс выполнения квеста с маньяком
    AddColumnIfNotExists("pp_igroki", "pRadioInterceptorFindCd", "INT NOT NULL DEFAULT '0'"); // КД использования поиска в радиоперехватчике
    AddColumnIfNotExists("pp_igroki", "pHankServices", "INT NOT NULL DEFAULT '0'"); // Услуги Хэнка
    AddColumnIfNotExists("pp_igroki", "pCDVillage", "INT NOT NULL DEFAULT '0'"); // КД на получение подарков после убийства всех деревенских
    AddColumnIfNotExists("pp_igroki", "pDatabaseActive", "INT NOT NULL DEFAULT '0'"); // Выбранный тип поддержки при взломе базы данных
    AddColumnIfNotExists("pp_igroki", "pCDKatana", "INT NOT NULL DEFAULT '0'"); // КД на дуэль на катанах
    AddColumnIfNotExists("pp_igroki", "pCDAd", "INT NOT NULL DEFAULT '0'"); // КД на подачу объявлений
    AddColumnIfNotExists("pp_igroki", "pCDGraves", "INT NOT NULL DEFAULT '0'"); // КД на раскопку могил
    AddColumnIfNotExists("pp_igroki", "pJobHint", "INT NOT NULL DEFAULT '0'"); // Подсказки на работах 
    AddColumnIfNotExists("pp_igroki", "pSpawnChangeDop", "INT NOT NULL DEFAULT '0'"); // Доп параметр для спавна
    AddColumnIfNotExists("pp_igroki", "pMenstrDay", "INT NOT NULL DEFAULT '0'"); // День следующей менструации
    AddColumnIfNotExists("pp_igroki", "pMenstrProkl", "INT NOT NULL DEFAULT '0'"); // Применены ли прокладки на текущий день менструации

    // quest halloween
    AddColumnIfNotExists("pp_quest_temp", "Ball", "BLOB NULL DEFAULT NULL");
    AddColumnIfNotExists("pp_quest_temp", "BallStatus", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_quest_temp", "HalloweenUnix", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_quest_temp", "HalloweenQuestStatus", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_quest_temp", "user_id", "INT NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("pp_igroki", "pApartmentsRoom0", "INT NOT NULL DEFAULT '0'"); 
    AddColumnIfNotExists("pp_igroki", "pApartmentsRoom1", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_igroki", "pApartmentsRoom2", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_igroki", "pApartmentsRoom3", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_igroki", "pApartmentsRoom4", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_igroki", "pApartmentsRoom5", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_igroki", "pApartmentsRoom6", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_igroki", "pApartmentsRoom7", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_igroki", "pApartmentsRoom8", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_igroki", "pApartmentsRoom9", "INT NOT NULL DEFAULT '0'");
    
    AddColumnIfNotExists("pp_bizz", "bAtmCollector", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_bizz", "bElectroPayForConnect", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_bizz", "bElectroPayForRepair", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_bizz", "bChipsFee", "INT NOT NULL DEFAULT '0'"); // Для кзаино

    AddColumnIfNotExists("pp_organization", "gMedMoney", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_organization", "gWarehouse", "BOOLEAN NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("pp_dom", "dDoorInt0", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dDoorInt1", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dDoor0", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dDoor1", "INT NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("pp_dom", "dElectroStatus", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dElectroConnect", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_dom", "dElectroUnix", "INT NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("pp_dom", "MoreIntObjects", "INT NOT NULL DEFAULT '0'");    

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
    AddColumnIfNotExists("pp_igroki_hint", "hint3", "INT NOT NULL DEFAULT '0'"); // Подсказка от джоне о маньяке

    // Цены за объявления CNN
    AddColumnIfNotExists("pp_server", "serv65", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_server", "serv66", "INT NOT NULL DEFAULT '0'");

    // День подсчёта максимального онлайна за сегодня
    AddColumnIfNotExists("pp_server", "serv67", "INT NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("pp_family", "vehPlate", "VARCHAR(32) DEFAULT ''"); // Номера авто в семье
    AddColumnIfNotExists("pp_family", "statusplate", "INT NOT NULL DEFAULT '0'"); // Статус покупки номерных знаков в семью

    
    AddColumnIfNotExists("apartments", "apCoordHolRoof0", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("apartments", "apCoordHolRoof1", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("apartments", "apCoordHolRoof2", "FLOAT NOT NULL DEFAULT '0'");
    
    AddColumnIfNotExists("apartments", "apCoordPlatform0", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("apartments", "apCoordPlatform1", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("apartments", "apCoordPlatform2", "FLOAT NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("apartments", "apCoordRoof0", "FLOAT NOT NULL DEFAULT '0'"); 
    AddColumnIfNotExists("apartments", "apCoordRoof1", "FLOAT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("apartments", "apCoordRoof2", "FLOAT NOT NULL DEFAULT '0'");

    // Создание недостающих строк в pp_priceskin
    mysql_tquery(pearsq, "SELECT skin FROM `pp_priceskin` ORDER BY skin DESC LIMIT 1", "PriceSkinPad");

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

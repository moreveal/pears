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
    AddColumnIfNotExists("pp_igroki", "pPackInteriors", "INT NOT NULL DEFAULT '0'"); // Количество купленных слотов для архива интерьера

    AddColumnIfNotExists("pp_igroki", "WarnClearTime", "INT NOT NULL DEFAULT '0'"); // Когда будет снят варн
    AddColumnIfNotExists("pp_igroki", "GunWarns", "INT NOT NULL DEFAULT '0'"); // Количество ганварнов
    AddColumnIfNotExists("pp_igroki", "GunWarnsZZTime", "INT NOT NULL DEFAULT '0'"); // Время персональной ЗЗ при ганварне
    AddColumnIfNotExists("pp_igroki", "GunWarnsDonateCD", "INT NOT NULL DEFAULT '0'"); // Когда можно будет снять ганварн за донат
    
    AddColumnIfNotExists("pp_igroki", "Fame", "INT NOT NULL DEFAULT '0'"); // 3D-название семьи на игроке

    // Achive
    for (new i = 141; i < 200; i++)
    {
        FORMAT:column("a%d", i);
        AddColumnIfNotExists("achieve_server", column, "INT NOT NULL DEFAULT '0'");
    }

    for (new i = 141; i < 200; i++)
    {
        FORMAT:column("a%d", i);
        AddColumnIfNotExists("pp_achieve", column, "BLOB NULL DEFAULT NULL");
    }
    //Top
    AddColumnIfNotExists("pp_igroki_top", "pCraftCount", "INT NOT NULL DEFAULT '0'"); // Кол-во очков для крафта.

    // Pets
    AddColumnIfNotExists("pets", "petName", "VARCHAR(20) DEFAULT ''");
    AddColumnIfNotExists("pets", "petHunger", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pets", "petLastUserName", "VARCHAR(24) DEFAULT ''");
    AddColumnIfNotExists("pets", "petLastUserID", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pets", "petLevel", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pets", "petExp", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pets", "petPoint", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pets", "petPower", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pets", "petAgility", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pets", "petEndurance", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pets", "petFeatures", "BLOB NULL DEFAULT NULL");
    AddColumnIfNotExists("pets", "petDonateFeatures", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pets", "petSkills", "BLOB NULL DEFAULT NULL");
    AddColumnIfNotExists("pets", "petPlayingUnix", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pets", "petUnixLastEating", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pets", "petType", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pets", "petHealth", "FLOAT NOT NULL DEFAULT '0'");

    //battlepass
    AddColumnIfNotExists("battlepass", "Name", "VARCHAR(24) DEFAULT ''");

    //backpack
    AddColumnIfNotExists("backpacks", "Name", "VARCHAR(24) DEFAULT ''");
    AddColumnIfNotExists("backpacks", "user_id", "INT NOT NULL DEFAULT '0'");


    //Просьба дениса.
    AddColumnIfNotExists("blacklist", "type", "INT NOT NULL DEFAULT '0'"); // 0 - может вынести лидер. 1 Может вынести только админ
    // quest halloween
    AddColumnIfNotExists("pp_quest_temp", "Ball", "BLOB NULL DEFAULT NULL");
    AddColumnIfNotExists("pp_quest_temp", "BallStatus", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_quest_temp", "HalloweenUnix", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_quest_temp", "HalloweenQuestStatus", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_quest_temp", "user_id", "INT NOT NULL DEFAULT '0'");
    // new year
    AddColumnIfNotExists("pp_quest_temp", "pDedMorozMessage", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_quest_temp", "pNewYearQuestComplete", "BLOB NULL DEFAULT NULL");

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
    AddColumnIfNotExists("pp_bizz", "bInteriorPack", "INT NOT NULL DEFAULT '0'");

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

    AddColumnIfNotExists("pp_dom", "dInteriorPack", "INT NOT NULL DEFAULT '0'");

    // Аксессуары
    AddColumnIfNotExists("accessory", "acCase", "BOOLEAN NOT NULL DEFAULT '0'");

    // Подсказки с озвучкой
    AddColumnIfNotExists("pp_igroki_hint", "hint1", "INT NOT NULL DEFAULT '0'"); // Подсказка от джоне о деревенских
    AddColumnIfNotExists("pp_igroki_hint", "hint2", "INT NOT NULL DEFAULT '0'"); // Подсказка от джоне о маньяке
    AddColumnIfNotExists("pp_igroki_hint", "hint3", "INT NOT NULL DEFAULT '0'"); // Подсказка от джоне о охоте
    AddColumnIfNotExists("pp_igroki_hint", "hint4", "INT NOT NULL DEFAULT '0'"); // Подсказка от джоне о Новом годе

    // Цены за объявления CNN
    AddColumnIfNotExists("pp_server", "serv65", "INT NOT NULL DEFAULT '0'");
    AddColumnIfNotExists("pp_server", "serv66", "INT NOT NULL DEFAULT '0'");

    // День подсчёта максимального онлайна за сегодня
    AddColumnIfNotExists("pp_server", "serv67", "INT NOT NULL DEFAULT '0'");

    // Радость моя для щупы
    AddColumnIfNotExists("pp_server", "serv68", "INT NOT NULL DEFAULT '0'");

    // Тариф (GUNWARN)
    AddColumnIfNotExists("pp_server", "serv69", "INT NOT NULL DEFAULT '0'");

    // Курс монет континенталя
    AddColumnIfNotExists("pp_server", "serv70", "INT NOT NULL DEFAULT '0'");

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

    AddColumnIfNotExists("pp_organization", "offshore", "INT NOT NULL DEFAULT '0'"); // офшорные деньги

    // Монеты континенталя в организациях
    for (new i = 0; i < _:ContinentalCoinPlayerActions; i++)
    {
        FORMAT:column("continental_reward_%d", i);
        AddColumnIfNotExists("pp_organization", column, "INT NOT NULL DEFAULT '0'");
    }
    for (new i = 0; i < 7; i++)
    {
        FORMAT:column("continental_%d", i);
        AddColumnIfNotExists("pp_organization", column, "INT NOT NULL DEFAULT '0'");
    }
    AddColumnIfNotExists("pp_organization", "continental_last_update", "INT NOT NULL DEFAULT '0'");

    AddColumnIfNotExists("pp_work", "gunwarn", "INT NOT NULL DEFAULT '0'"); // Счетчик выданных GunWarns у администраторов

    // Создание недостающих строк в pp_priceskin
    mysql_tquery(pearsq, "SELECT skin FROM `pp_priceskin` ORDER BY skin DESC LIMIT 1", "PriceSkinPad");


    // Возможность заблокировать транспорт в доступе из обычного авто кейса
    AddColumnIfNotExists("pp_priceveh", "VehCaseOff", "INT NOT NULL DEFAULT '0'");
	return true;
}

// Функция для создания недостающих таблиц
stock CreateTablesIfNotExists()
{
    SQL_INIT_TABLE(pearsq, "pp_narco_spots", NarcoSpotInfo);
    SQL_INIT_TABLE(pearsq, "pp_user_narco_spots", NarcoSpotPlayerInfo);
    SQL_INIT_TABLE(pearsq, "pp_places_narco_spots", NarcoPlaceInfo);
    SQL_INIT_TABLE(pearsq, "pp_narco_farms", NarcoFarmInfo);
    SQL_INIT_TABLE(pearsq, "pp_user_continental", ContinentalCoinPlayerInfo);
    SQL_INIT_TABLE(pearsq, "pp_continental", ContinentalCoinInfo);

    return 1;
}

// Функция для проверки существования столбца и его добавления
stock AddColumnIfNotExists(const table[], const column[], const definition[], MySQL: db_handle = MySQL: -1)
{
    if (_:db_handle == -1) db_handle = pearsq;

    new query[256];
    
    // Проверяем, существует ли столбец
    format(query, sizeof(query), "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '%s' AND COLUMN_NAME = '%s'", table, column);
    
    // Выполняем запрос и проверяем количество строк в результате
    new Cache: result = mysql_query(db_handle, query);
    if (result)
    {
        new rows;
		cache_get_row_count(rows); // Получаем количество строк в результате запроса
        
        // Если строк больше нуля, значит столбец существует
        if(rows == 0)
        {
            // Если столбец не существует, добавляем его
            format(query, sizeof(query), "ALTER TABLE `%s` ADD `%s` %s", table, column, definition);
            mysql_query(db_handle, query);
        }
    }
    cache_delete(result);
}

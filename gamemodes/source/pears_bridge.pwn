
stock AddPearsBridgeEvent(const eventId[], const JsonNode:data) {
    new str[4096];
    if (JSON_Stringify(data, str) != JSON_CALL_NO_ERR) {
        printf("[debug] AddPearsBridgeEvent Error");
        return 0;
    }

    new escape_string[4096];
    mysql_escape_string(str, escape_string, sizeof(escape_string));


    //new tempServerID = server; // VREMENNO
    new tempServerID = 1;

    new string_mysql[4096];
    format(string_mysql, sizeof(string_mysql), "INSERT INTO `event_forum` (`eventid`, `serverid`, `data`) VALUES (`%s`, `%d`, `%s`)", eventId, tempServerID, escape_string);
    mysql_tquery(pearsq_3, string_mysql, "", "");
    return 1;
}

stock UpdateSqlProperties() // Сохраняем инфу о сервере в базу (для синхры)
{
    new string_mysql[1024];
    format(string_mysql, sizeof(string_mysql), "INSERT INTO properties ( name, value ) VALUES \
        ('players', '%d'), \
        ('maxPlayers',  '%d'), \
        ('password',  '%s'), \
        ('lastUpdate', '%d') \
        ON DUPLICATE KEY UPDATE value = VALUES(value)", OrganInfo[0][gstat2], GetMaxPlayers(), serverPass, gettime());
    mysql_tquery(pearsq_3, string_mysql, "", "");
    return 1;
}

stock UpdateSqlPlayer() // Записываем все аккаунты в таблицу
{
    mysql_tquery(pearsq_3, "START TRANSACTION;");

    mysql_tquery(pearsq_3, "TRUNCATE `online_players`"); 

    new string_mysql[400];
    foreach(Player,i)
	{
        format(string_mysql, sizeof(string_mysql), "INSERT INTO online_players ( playerId, name, accountId, score, ping ) VALUES \
            ('%d', '%s', '%d', '%d', '%d')", 
            i, 
            PlayerInfo[i][pName], 
            PlayerInfo[i][pID], 
            (OnlineInfo[i][oLogged] == 0) ? 0 : PlayerInfo[i][pLevel], // Использование тернарного оператора здесь
            GetPlayerPing(i));

        mysql_tquery(pearsq_3, string_mysql);
    }

    mysql_tquery(pearsq_3, "COMMIT;");
    return 1;
}

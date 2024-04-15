
#define ALERT_COMPLAIT "https://forum.pears.fun/forums/zhaloby-na-administraciju.57/post-thread" // Ссылка на создание жалобы на администратора

stock UpdateSqlProperties() // Сохраняем инфу о сервере в базу (для синхры)
{
    // if(server == 0) return 0; // VREMENNO koment

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
    // if(server == 0) return 0; // VREMENNO koment

    mysql_tquery(pearsq_3, "START TRANSACTION;");

    mysql_tquery(pearsq_3, "DELETE FROM `online_players`");

    new string_mysql[400];
    foreach(Player,i)
	{
        if(OnlineInfo[i][oLogged] == 0) continue; // Незалогинившихся, не показываем
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

stock SendBridgeEvent(const name[], JsonNode:data = JSON_INVALID_NODE)
{
    if(server == 0) return 0;

    new string_json[512], string_mysql[1024];
    if(data == JSON_INVALID_NODE)
	{
        mysql_format(pearsq_3, string_mysql, sizeof(string_mysql), "INSERT INTO events_from_server ( name, date ) VALUES \
            ('%e', '%d')", name, gettime());
        mysql_tquery(pearsq_3, string_mysql);
    }
    else if (JSON_Stringify(data, string_json) == JSON_CALL_NO_ERR) 
    {
        mysql_format(pearsq_3, string_mysql, sizeof(string_mysql), "INSERT INTO events_from_server ( name, data, date ) VALUES \
            ('%e', '%e', '%d')", name, string_json, gettime());
        mysql_tquery(pearsq_3, string_mysql);
    }
    else return 0;
    return 1;
}

// Отправляем почту через pears_bridge
stock SendMail(const mail[], const subject[], const body[], const name[] = "")
{
    SendBridgeEvent("send_mail", JSON_Object(
        "mail", JSON_String(mail),
        "subject", JSON_String(subject),
        "body", JSON_String(body),
        "name", JSON_String(name)
    ));
    return 1;
}

// Отправляем уведомление на форум
stock SendAlertBridge(const user_id, const body[], const url[] = "")
{
    SendBridgeEvent("account_alert", JSON_Object(
        "account_id", JSON_Int(user_id),
        "body", JSON_String(body),
        "url", JSON_String(url)
    ));
    return 1;
}

// Удаляем все старые запросы от сервера
stock ClearOldBridgeEvents()
{
    if(server == 0) return 0;

    new string_mysql[90];
    format(string_mysql, sizeof(string_mysql), "DELETE FROM events_from_server WHERE date <= %d", gettime() - 604800);
    mysql_tquery(pearsq_3, string_mysql);
    return 1;
}

stock RegisterAccountBridge(playerid)
{
    SendBridgeEvent("account_register", JSON_Object(
        "account_id", JSON_Int(PlayerInfo[playerid][pID]),
        "name", JSON_String(PlayerInfo[playerid][pName])
    ));
    return 1;
}

stock LinkForumAccount(playerid)
{
    new key = 1000000 + random(8999999);
    SendBridgeEvent("account_link", JSON_Object(
        "account_id", JSON_Int(PlayerInfo[playerid][pID]),
        "key", JSON_Int(key)
    ));
    return 1;
}

stock InvitePlayerBridge(user_id, g)
{
    SendBridgeEvent("account_invite", JSON_Object(
        "account_id", JSON_Int(user_id),
        "org_id", JSON_Int(g) 
    ));
    return 1;
}

stock UninvitePlayerBridge(user_id, g)
{
    SendBridgeEvent("account_uninvite", JSON_Object(
        "account_id", JSON_Int(user_id),
        "org_id", JSON_Int(g) 
    ));
    return 1;
}

stock MakeleaderPlayerBridge(user_id, g, r)
{
    SendBridgeEvent("account_makeleader", JSON_Object(
        "account_id", JSON_Int(user_id),
        "org_id", JSON_Int(g),
        "rang", JSON_Int(r)
    ));
    return 1;
}

stock UnmakeleaderPlayerBridge(user_id, g, r)
{
    SendBridgeEvent("account_unmakeleader", JSON_Object(
        "account_id", JSON_Int(user_id),
        "org_id", JSON_Int(g),
        "rang", JSON_Int(r)
    ));
    return 1;
}

stock MakeadminPlayerBridge(user_id, g)
{
    SendBridgeEvent("account_makeadmin", JSON_Object(
        "account_id", JSON_Int(user_id),
        "admin_id", JSON_Int(g) 
    ));
    return 1;
}

stock GiverankPlayerBridge(user_id, g, r)
{
    SendBridgeEvent("account_giverank", JSON_Object(
        "account_id", JSON_Int(user_id),
        "org_id", JSON_Int(g),
        "rang", JSON_Int(r) 
    ));
    return 1;
}

stock DeletePlayerBridge(user_id)
{
    SendBridgeEvent("account_delete", JSON_Object(
        "account_id", JSON_Int(user_id)
    ));
    return 1;
}

stock SetnamePlayerBridge(user_id, const name[])
{
    SendBridgeEvent("account_setname", JSON_Object(
        "account_id", JSON_Int(user_id),
        "name", JSON_String(name)
    ));
    return 1;
}

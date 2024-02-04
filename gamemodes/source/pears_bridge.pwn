
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

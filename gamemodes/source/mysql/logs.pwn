
// Какие-то нанотехнологии
#define LOGS_NULL_IF_NOT_ASSIGNED(%0)   \
new %0_id_[32];                         \
new %0_name_[32];                       \
new %0_ip_[32];                         \
                                        \
if (%0_id == 0) strcat(%0_id_, "NULL"); \
else mysql_format(pearsq_2, %0_id_, sizeof(%0_id_), "'%d'", %0_id);        \
                                                                           \
if (strlen(%0_name) == 0) strcat(%0_name_, "NULL");                        \
else mysql_format(pearsq_2, %0_name_, sizeof(%0_name_), "'%e'", %0_name);  \
                                                                           \
if (strlen(%0_ip) == 0) strcat(%0_ip_, "NULL");                            \
else mysql_format(pearsq_2, %0_ip_, sizeof(%0_ip_), "'%e'", %0_ip);


stock ConnectLog(playerid, const type[])
{
    if(PlayerInfo[playerid][pHidden] > 0) return true;

    new query[512];
    mysql_format(pearsq_2, query, sizeof(query),
        "INSERT INTO connection_logs ( \
            `account_id`, \
            `account_name`, \
            `account_ip`, \
            `account_gpci`, \
            `type` \
        ) VALUES ('%d', '%e', '%e', '%e', '%e')",
        PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[playerid][pGpci], type
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock AdminLog(const action[], 
    primary_player_id, const primary_player_name[], const primary_player_ip[], 
    secondary_player_id, const secondary_player_name[], const secondary_player_ip[], 
    row, const rows[])
{
    LOGS_NULL_IF_NOT_ASSIGNED(primary_player)
    LOGS_NULL_IF_NOT_ASSIGNED(secondary_player)

    new query[512];
    mysql_format(pearsq_2, query, sizeof(query), 
        "INSERT INTO `admin_logs` ( \
            `action`, \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `secondary_player_id`, \
            `secondary_player_name`, \
            `secondary_player_ip`, \
            `row`, \
            `rows` \
        ) VALUES ('%e', %s, %s, %s, %s, %s, %s, '%d', convertCharset('%e', \'windows-1251\', \'utf-8\'))",
        action, primary_player_id_, primary_player_name_, primary_player_ip_, secondary_player_id_, secondary_player_name_, secondary_player_ip_, row, rows
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock OrgLog(org_id, const action[], 
    primary_player_id, const primary_player_name[], const primary_player_ip[], 
    secondary_player_id, const secondary_player_name[], const secondary_player_ip[], 
    row, const rows[])
{
    LOGS_NULL_IF_NOT_ASSIGNED(primary_player)
    LOGS_NULL_IF_NOT_ASSIGNED(secondary_player)

    new query[512];
    mysql_format(pearsq_2, query, sizeof(query), 
        "INSERT INTO `org_logs` ( \
            `org_id`, \
            `action`, \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `secondary_player_id`, \
            `secondary_player_name`, \
            `secondary_player_ip`, \
            `row`, \
            `rows` \
        ) VALUES ('%d', '%e', %s, %s, %s, %s, %s, %s, '%d', convertCharset('%e', \'windows-1251\', \'utf-8\'))",
        org_id, action, primary_player_id_, primary_player_name_, primary_player_ip_, secondary_player_id_, secondary_player_name_, secondary_player_ip_, row, rows
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock MoneyLog(const action[], 
    primary_player_id, const primary_player_name[], const primary_player_ip[], 
    secondary_player_id, const secondary_player_name[], const secondary_player_ip[], 
    row, const rows[])
{
    LOGS_NULL_IF_NOT_ASSIGNED(primary_player)
    LOGS_NULL_IF_NOT_ASSIGNED(secondary_player)

    new query[512];
    mysql_format(pearsq_2, query, sizeof(query), 
        "INSERT INTO `money_logs` ( \
            `action`, \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `secondary_player_id`, \
            `secondary_player_name`, \
            `secondary_player_ip`, \
            `row`, \
            `rows` \
        ) VALUES ('%e', %s, %s, %s, %s, %s, %s, '%d', convertCharset('%e', \'windows-1251\', \'utf-8\'))",
        action, primary_player_id_, primary_player_name_, primary_player_ip_, secondary_player_id_, secondary_player_name_, secondary_player_ip_, row, rows
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock CarLog(const action[], 
    primary_player_id, const primary_player_name[], const primary_player_ip[], 
    carid, row, const rows[])
{
    LOGS_NULL_IF_NOT_ASSIGNED(primary_player)

    new query[512];
    mysql_format(pearsq_2, query, sizeof(query), 
        "INSERT INTO `car_logs` ( \
            `car_id`, \
            `action`, \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `row`, \
            `rows` \
        ) VALUES ('%d', '%e', %s, %s, %s, '%d', convertCharset('%e', \'windows-1251\', \'utf-8\'))",
        carid, action, primary_player_id_, primary_player_name_, primary_player_ip_, row, rows
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock HouseLog(house_type, const action[], 
    primary_player_id, const primary_player_name[], const primary_player_ip[], 
    house_id, row, const rows[])
{
    LOGS_NULL_IF_NOT_ASSIGNED(primary_player)

    new house_type_[24];
    if(house_type == 0) house_type_ = "house";
    else if(house_type == 1) house_type_ = "room";
    else if(house_type == 2) house_type_ = "trailer";
    else house_type_ = "unknown";

    new query[512];
    mysql_format(pearsq_2, query, sizeof(query), 
        "INSERT INTO `house_logs` ( \
            `house_type`, \
            `house_id`, \
            `action`, \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `row`, \
            `rows` \
        ) VALUES ('%e', '%d', '%e', %s, %s, %s, '%d', convertCharset('%e', \'windows-1251\', \'utf-8\'))",
        house_type_, house_id, action, primary_player_id_, primary_player_name_, primary_player_ip_, row, rows
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock BizLog(const action[], 
    primary_player_id, const primary_player_name[], const primary_player_ip[], 
    business_id, row, const rows[])
{
    LOGS_NULL_IF_NOT_ASSIGNED(primary_player)

    new query[512];
    mysql_format(pearsq_2, query, sizeof(query), 
        "INSERT INTO `business_logs` ( \
            `business_id`, \
            `action`, \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `row`, \
            `rows` \
        ) VALUES ('%d', '%e', %s, %s, %s, '%d', convertCharset('%e', \'windows-1251\', \'utf-8\'))",
        business_id, action, primary_player_id_, primary_player_name_, primary_player_ip_, row, rows
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock FamilyLog(family_id, const action[], 
    primary_player_id, const primary_player_name[], const primary_player_ip[], 
    secondary_player_id, const secondary_player_name[], const secondary_player_ip[], 
    row, const rows[])
{
    LOGS_NULL_IF_NOT_ASSIGNED(primary_player)
    LOGS_NULL_IF_NOT_ASSIGNED(secondary_player)

    new query[512];
    mysql_format(pearsq_2, query, sizeof(query), 
        "INSERT INTO `family_logs` ( \
            `family_id`, \
            `action`, \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `secondary_player_id`, \
            `secondary_player_name`, \
            `secondary_player_ip`, \
            `row`, \
            `rows` \
        ) VALUES ('%d', '%e', %s, %s, %s, %s, %s, %s, '%d', convertCharset('%e', \'windows-1251\', \'utf-8\'))",
        family_id, action, primary_player_id_, primary_player_name_, primary_player_ip_, secondary_player_id_, secondary_player_name_, secondary_player_ip_, row, rows
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock DonateLog(const action[], 
    primary_player_id, const primary_player_name[], const primary_player_ip[], 
    secondary_player_id, const secondary_player_name[], const secondary_player_ip[], 
    row, const rows[])
{
    LOGS_NULL_IF_NOT_ASSIGNED(primary_player)
    LOGS_NULL_IF_NOT_ASSIGNED(secondary_player)

    new query[512];
    mysql_format(pearsq_2, query, sizeof(query), 
        "INSERT INTO `gold_logs` ( \
            `action`, \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `secondary_player_id`, \
            `secondary_player_name`, \
            `secondary_player_ip`, \
            `row`, \
            `rows` \
        ) VALUES ('%e', %s, %s, %s, %s, %s, %s, '%d', convertCharset('%e', \'windows-1251\', \'utf-8\'))",
        action, primary_player_id_, primary_player_name_, primary_player_ip_, secondary_player_id_, secondary_player_name_, secondary_player_ip_, row, rows
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock InsultLog(playerid, const rows[])
{
    new query[512];
    mysql_format(pearsq_2, query, sizeof(query),
        "INSERT INTO insult_log ( \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `rows` \
        ) VALUES ('%d', '%e', '%e', convertCharset('%e', \'windows-1251\', \'utf-8\'))",
        PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], rows
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock UserLog(const action[], 
    primary_player_id, const primary_player_name[], const primary_player_ip[], 
    secondary_player_id, const secondary_player_name[], const secondary_player_ip[], 
    row, const rows[])
{
    LOGS_NULL_IF_NOT_ASSIGNED(primary_player)
    LOGS_NULL_IF_NOT_ASSIGNED(secondary_player)

    new query[512];
    mysql_format(pearsq_2, query, sizeof(query), 
        "INSERT INTO `inventory_logs` ( \
            `action`, \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `secondary_player_id`, \
            `secondary_player_name`, \
            `secondary_player_ip`, \
            `row`, \
            `rows` \
        ) VALUES ('%e', %s, %s, %s, %s, %s, %s, '%d', convertCharset('%e', \'windows-1251\', \'utf-8\'))",
        action, primary_player_id_, primary_player_name_, primary_player_ip_, secondary_player_id_, secondary_player_name_, secondary_player_ip_, row, rows
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock TradeLog(trade_id, p, t)
{
    new model[3], slot_1_name[34], slot_2_name[34], slot_3_name[34];

    if(PlayerInfo[p][pTslot][0] == 4) model[0] = VehInfo[PlayerInfo[p][pTmodel][0]][vModel];
	else model[0] = PlayerInfo[p][pTmodel][0];
	if(PlayerInfo[p][pTslot][1] == 4) model[1] = VehInfo[PlayerInfo[p][pTmodel][1]][vModel];
	else model[1] = PlayerInfo[p][pTmodel][1];
	if(PlayerInfo[p][pTslot][2] == 4) model[2] = VehInfo[PlayerInfo[p][pTmodel][2]][vModel];
	else model[2] = PlayerInfo[p][pTmodel][2];

    format(slot_1_name, sizeof(slot_1_name),"%s", tradeName[PlayerInfo[p][pTslot][0]]);
    format(slot_2_name, sizeof(slot_2_name),"%s", tradeName[PlayerInfo[p][pTslot][1]]);
    format(slot_3_name, sizeof(slot_3_name),"%s", tradeName[PlayerInfo[p][pTslot][2]]);

    new query[900];
    mysql_format(pearsq_2, query, sizeof(query), 
        "INSERT INTO `trade_logs` ( \
            `trade_id`, \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `secondary_player_id`, \
            `secondary_player_name`, \
            `secondary_player_ip`, \
            `slot_1_name`, \
            `slot_1_id`, \
            `slot_1_amount`, \
            `slot_2_name`, \
            `slot_2_id`, \
            `slot_2_amount`, \
            `slot_3_name`, \
            `slot_3_id`, \
            `slot_3_amount` \
        ) VALUES ('%d', '%d', '%e', '%e', '%d', '%e', '%e', \
            convertCharset('%e', \'windows-1251\', \'utf-8\'), '%d', '%d', \
            convertCharset('%e', \'windows-1251\', \'utf-8\'), '%d', '%d', \
            convertCharset('%e', \'windows-1251\', \'utf-8\'), '%d', '%d')",
        trade_id, PlayerInfo[p][pID], PlayerInfo[p][pName], PlayerInfo[p][pPlaIP], PlayerInfo[t][pID], PlayerInfo[t][pName], PlayerInfo[t][pPlaIP],
        slot_1_name, model[0], PlayerInfo[p][pTamount][0],
        slot_2_name, model[1], PlayerInfo[p][pTamount][1],
        slot_3_name, model[2], PlayerInfo[p][pTamount][2]
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock SupportLog(report_id, 
    primary_player_id, const primary_player_name[], const primary_player_ip[], 
    secondary_player_id, const secondary_player_name[], const secondary_player_ip[], 
    const rows[])
{
    LOGS_NULL_IF_NOT_ASSIGNED(primary_player)
    LOGS_NULL_IF_NOT_ASSIGNED(secondary_player)

    new query[512];
    mysql_format(pearsq_2, query, sizeof(query), 
        "INSERT INTO `report_logs` ( \
            `report_id`, \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `secondary_player_id`, \
            `secondary_player_name`, \
            `secondary_player_ip`, \
            `rows` \
        ) VALUES ('%d', %s, %s, %s, %s, %s, %s, convertCharset('%e', \'windows-1251\', \'utf-8\'))",
        report_id, primary_player_id_, primary_player_name_, primary_player_ip_, secondary_player_id_, secondary_player_name_, secondary_player_ip_, rows
    );
    mysql_tquery(pearsq_2, query);
    return true;
}

stock CasinoLog(game_id, 
    primary_player_id, const primary_player_name[], const primary_player_ip[], 
    row, const rows[])
{
    new query[512];
    mysql_format(pearsq_2, query, sizeof(query), 
        "INSERT INTO `casino_logs` ( \
            `game_id`, \
            `primary_player_id`, \
            `primary_player_name`, \
            `primary_player_ip`, \
            `row`, \
            `rows` \
        ) VALUES ('%d', '%d', '%e', '%e', '%d', convertCharset('%e', \'windows-1251\', \'utf-8\'))",
        game_id, primary_player_id, primary_player_name, primary_player_ip, row, rows
    );
    mysql_tquery(pearsq_2, query);
    return true;
}


#undef LOGS_NULL_IF_NOT_ASSIGNED

#if !defined isnull
	#define isnull(%0) (!%0[0])
#endif

#define FIELD_NAME_SIZE                 (32)
#define UPDATE_QUERY_BUFFER             (512)
#define INSERT_QUERY_BUFFER             (1024)

enum e_DatabaseColumnInfo {
    FIELD_COLUMN_PRIMARY_KEY = 1, // Is primary key
    FIELD_COLUMN_UNIQUE_KEY = 2, // Is unique key
    FIELD_COLUMN_AUTO_INCREMENT = 4, // Is auto increment
    FIELD_COLUMN_NOT_NULL = 8, // Is not null
    FIELD_COLUMN_UNIQUE_PAIR = 16 // Is unique pair part
};

enum e_DatabaseFieldInfo {
	FIELD_NAME[FIELD_NAME_SIZE], // Column name in the database
	e_DatabaseFieldType: FIELD_TYPE, // Type of the field
	FIELD_SIZE, // For text fields (or for skipping fields)
    FIELD_COLUMN_FLAGS // Column flags (e_DatabaseColumnInfo)
};

enum e_DatabaseFieldType {
    FIELD_TYPE_BOOL,    // For bool values
    FIELD_TYPE_INT,     // For int values
    FIELD_TYPE_FLOAT,   // For float values
    FIELD_TYPE_BIGINT,  // For Pawn-BigInt values
    FIELD_TYPE_TEXT,    // For text (FIELD_SIZE must be specified)
    FIELD_TYPE_SKIP     // For values that are not stored in the database (supports specifying the FIELD_SIZE of the cells to skip)
};

/*
    Usage:

    enum e_SomeInfo {
        siID,
        siName[24];
    }
    new SomeInfo[MAX_PLAYERS][e_SomeInfo];
    SQL_ENUM_DEFINE(SomeInfo) {
        {"id", FIELD_TYPE_INT},
        {"name", FIELD_TYPE_TEXT, 24}  
    };
*/
#define SQL_ENUM_DEFINE(%0) \
    new %0DB[][e_DatabaseFieldInfo] = 

#define SQL_GET_ENUM_DEFINE(%0) %0DB

/*
    Usage:

    function SomeCallback(playerid)
    {
        new rows;
        cache_get_rows_count(rows);

        for (new i = 0; i < rows; i++)
        {
            SQL_LOAD_ENUM(SomeInfo[playerid], SQL_GET_ENUM_DEFINE(SomeInfo), i);
        }
        
        return 1;
    }
*/
#define SQL_LOAD_ENUM(%0,%1,%2) SQL_LoadEnum(%0, %2, %1, #%0)

// SQL_LoadEnum(VehicleInfo[vehicleid], i, VehicleInfoDB, "VehicleInfo[vehicleid]");
stock SQL_LoadEnum(_enum[], i, const db[][], const _enum_name[], db_len = sizeof(db))
{
    for (new fieldRead, fieldIndex = 0; fieldIndex < db_len; fieldIndex++)
    {
        switch (db[fieldIndex][FIELD_TYPE])
        {
            case FIELD_TYPE_BOOL, FIELD_TYPE_INT:
            {
                cache_get_value_name_int(i, db[fieldIndex][FIELD_NAME], _enum[fieldRead]);
                fieldRead++;
            }
            case FIELD_TYPE_FLOAT:
            {
                cache_get_value_name_float(i, db[fieldIndex][FIELD_NAME], Float:_enum[fieldRead]);
                fieldRead++;
            }
            #if defined MAX_BIGINT_LEN
                case FIELD_TYPE_BIGINT:
                {
                    new value[MAX_BIGINT_LEN];
                    cache_get_value_name(i, db[fieldIndex][FIELD_NAME], value);
                    if (_enum[fieldRead] == INVALID_BIGINT)
                    {
                        _enum[fieldRead] = _:bigint_create();
                    }
                    bigint_set_str(BigInt:_enum[fieldRead], value);
                    fieldRead++;
                }
            #endif
            case FIELD_TYPE_TEXT:
            {
                if (db[fieldIndex][FIELD_SIZE] > 0)
                {
                    cache_get_value_name(i, db[fieldIndex][FIELD_NAME], _enum[fieldRead], db[fieldIndex][FIELD_SIZE]);
                    fieldRead += db[fieldIndex][FIELD_SIZE];
                }
                else
                {
                    printf("[SQL-LOAD-ERROR]: Undefined size for field `%s` (%s)", db[fieldIndex][FIELD_NAME], _enum_name);
                    break;
                }
            }
            case FIELD_TYPE_SKIP:
            {
                fieldRead += max(1, db[fieldIndex][FIELD_SIZE]);
            }
            default:
            {
                printf("[SQL-LOAD-ERROR]: Unknown field type for field `%s` (%s)", db[fieldIndex][FIELD_NAME], _enum_name);
                fieldRead++;
            }
        }
    }
}

/*
	Usage:

	stock SavePlayer(playerid)
	{
		new where[32];
		mysql_format(pearsq, where, sizeof(where), "id = %d", PlayerInfo[playerid][pID]);
        
        // If row already exists
        // The last variable represents the value for the WHERE statement when forming UPDATE queries
		SQL_SAVE_ENUM(pearsq, "pp_igroki", PlayerInfo[playerid], GET_ENUM_DEFINE(PlayerInfo), where);

        // If the row may not exist initially
        // The last variable represents the value for the SET statement when forming REPLACE INTO query
        SQL_SAVE_ENUM_IF_NOT_EXISTS(pearsq, "pp_igroki", PlayerInfo[playerid], GET_ENUM_DEFINE(PlayerInfo), where, where);
	}
*/
#define SQL_SAVE_ENUM(%0,%1,%2,%3,%4)                       SQL_SaveEnum(%1, %2, %0, %3, #%2, %4)
#define SQL_SAVE_ENUM_IF_NOT_EXISTS(%0,%1,%2,%3,%4,%5)      SQL_SaveEnum(%1, %2, %0, %3, #%2, %4, %5)

// SQL_SaveEnum("users", PlayerInfo[playerid], dbHandle, PlayerInfoDB, "name = 'Desire_Messier'");
stock SQL_SaveEnum(const table[], const _enum[], MySQL: connection, const db[][], const _enum_name[], const whereCondition[], const init_list[] = "", db_len = sizeof(db))
{
    mysql_tquery(connection, "START TRANSACTION;");

    // Create if not exists
    if (!isnull(init_list))
    {
        new __buf[INSERT_QUERY_BUFFER];
        mysql_format(connection, __buf, sizeof(__buf), "REPLACE INTO `%e` SET %e", table, init_list);
        mysql_tquery(connection, __buf);
    }

    new bool: empty_query = true;

    new __buf[UPDATE_QUERY_BUFFER];
    for (new fieldRead, fieldIndex = 0; fieldIndex < db_len; fieldIndex++)
    {
        // Do not try to update auto increment or primary key fields
        if (db[fieldIndex][FIELD_COLUMN_FLAGS] & _:FIELD_COLUMN_AUTO_INCREMENT ||
            db[fieldIndex][FIELD_COLUMN_FLAGS] & _:FIELD_COLUMN_PRIMARY_KEY)
        {
            fieldRead += max(1, db[fieldIndex][FIELD_SIZE]);
            continue;
        }

        __buf[0] = 0;
        mysql_format(connection, __buf, sizeof(__buf), "UPDATE `%e` SET `%s` = ", table, db[fieldIndex][FIELD_NAME]);
        switch (db[fieldIndex][FIELD_TYPE])
        {
            case FIELD_TYPE_BOOL, FIELD_TYPE_INT:
            {
                mysql_format(connection, __buf, sizeof(__buf), "%s%d", __buf, _enum[fieldRead]);
                fieldRead++;
            }
            case FIELD_TYPE_FLOAT:
            {
                mysql_format(connection, __buf, sizeof(__buf), "%s%f", __buf, Float:_enum[fieldRead]);
                fieldRead++;
            }
            #if defined MAX_BIGINT_LEN
                case FIELD_TYPE_BIGINT:
                {
                    if (_enum[fieldRead] == INVALID_BIGINT)
                    {
                        continue;
                    }
                    new value[MAX_BIGINT_LEN];
                    bigint_get_str(BigInt:_enum[fieldRead], value);
                    mysql_format(connection, __buf, sizeof(__buf), "%s'%e'", __buf, value);
                    fieldRead++;
                }
            #endif
            case FIELD_TYPE_TEXT:
            {
                if (db[fieldIndex][FIELD_SIZE] > 0)
                {
                    mysql_format(connection, __buf, sizeof(__buf), "%s'%e'", __buf, _enum[fieldRead]);
                    fieldRead += db[fieldIndex][FIELD_SIZE];
                }
                else
                {
                    printf("[SQL-SAVE-ERROR]: Undefined size for field `%s` (%s)", db[fieldIndex][FIELD_NAME], _enum_name);
                    break;
                }
            }
            case FIELD_TYPE_SKIP:
            {
                fieldRead += max(1, db[fieldIndex][FIELD_SIZE]);
                continue;
            }
            default:
            {
                printf("[SQL-SAVE-ERROR]: Unknown field type for field `%s` (%s)", db[fieldIndex][FIELD_NAME], _enum_name);
                fieldRead++;
                break;
            }
        }
        mysql_format(connection, __buf, sizeof(__buf), "%s WHERE %s", __buf, whereCondition);
        mysql_tquery(connection, __buf);

        empty_query = false;
    }

    if (empty_query)
    {
        mysql_tquery(connection, "ROLLBACK;");
        return 0;
    }

    mysql_tquery(connection, "COMMIT;");
    return 1;
}

/*
    Usage:

    enum e_UsersInfo {
        uiID,
        uiName[24]
    }
    new UsersInfo[MAX_PLAYERS][e_UsersInfo];
    SQL_ENUM_DEFINE(UsersInfo) {
        {"id", FIELD_TYPE_INT, 0, FIELD_COLUMN_PRIMARY_KEY | FIELD_COLUMN_AUTO_INCREMENT},
        {"name", FIELD_TYPE_TEXT, 24}
    };

    // OnGameModeInit:
    SQL_INIT_TABLE(pearsq, "users", UsersInfo);
*/
#define SQL_INIT_TABLE(%0,%1,%2) SQL_InitTable(%0, %1, %2DB)

// SQL_InitTable(pearsq, "users", UsersInfoDB);
stock SQL_InitTable(const MySQL: connection, const table[], const db[][], db_len = sizeof(db))
{
    new __buf[INSERT_QUERY_BUFFER], __column[UPDATE_QUERY_BUFFER];
    mysql_format(connection, __buf, sizeof(__buf), "CREATE TABLE IF NOT EXISTS `%e` (", table);

    {
        new bool: column_added = false;
        for (new i = 0; i < db_len; i++)
        {
            __column[i] = 0;
            if (!SQL_GetColumnDefinition(db, i, __column)) continue;
            strcat(__buf, __column);
            strcat(__buf, ", ");

            column_added = true;
        }
        if (!column_added) return 0;
    }
    __buf[strlen(__buf) - 2] = 0;

    // Add unique key pairs, etc.
    {
        new additional_keys[UPDATE_QUERY_BUFFER], bool: was_added = false;
        strcat(additional_keys, ", UNIQUE KEY (");
        for (new i = 0; i < db_len; i++)
        {
            if (db[i][FIELD_COLUMN_FLAGS] & _:FIELD_COLUMN_UNIQUE_PAIR)
            {
                strcat(additional_keys, db[i][FIELD_NAME]);
                strcat(additional_keys, ", ");
                was_added = true;
            }
        }
        if (was_added)
        {
            additional_keys[strlen(additional_keys) - 2] = 0;
            strcat(additional_keys, ")");
            strcat(__buf, additional_keys);
        }
    }

    strcat(__buf, ") ENGINE = InnoDB;");
    mysql_query(connection, __buf, false);

    // If table already exists, we need to check if all columns are present
    for (new i = 0; i < db_len; i++)
    {
        mysql_format(connection, __buf, sizeof(__buf), "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '%e' AND COLUMN_NAME = '%e'", table, db[i][FIELD_NAME]);
        new Cache: result = mysql_query(connection, __buf);
        if (result)
        {
            new rows;
            cache_get_row_count(rows);

            if (rows == 0)
            {
                mysql_format(connection, __buf, sizeof(__buf), "ALTER TABLE `%e` ADD COLUMN ", table);
                if (!SQL_GetColumnDefinition(db, i, __column)) continue;
                strcat(__buf, __column);
                mysql_tquery(connection, __buf);
            }
        }
        cache_delete(result);
    }

    return 1;
}

stock SQL_GetColumnDefinition(const db[][], const i, buf[], len = sizeof(buf))
{
    format(buf, len, "`%s` ", db[i][FIELD_NAME]);
    switch (db[i][FIELD_TYPE])
    {
        case FIELD_TYPE_BOOL, FIELD_TYPE_INT:
        {
            format(buf, len, "%s INT DEFAULT 0", buf);
        }
        case FIELD_TYPE_FLOAT:
        {
            format(buf, len, "%s FLOAT DEFAULT 0.0", buf);
        }
        #if defined MAX_BIGINT_LEN
            case FIELD_TYPE_BIGINT:
            {
                format(buf, len, "%s BIGINT DEFAULT 0", buf);
            }
        #endif
        case FIELD_TYPE_TEXT:
        {
            if (db[i][FIELD_SIZE] > 0)
            {
                format(buf, len, "%s VARCHAR(%d) DEFAULT ''", buf, db[i][FIELD_SIZE]);
            }
            else
            {
                return 0;
            }
        }
        default: {
            return 0;
        }
    }

    new e_DatabaseColumnInfo: flags = e_DatabaseColumnInfo: db[i][FIELD_COLUMN_FLAGS];
    if (flags & FIELD_COLUMN_PRIMARY_KEY)
    {
        strcat(buf, " PRIMARY KEY", len);
    }
    if (flags & FIELD_COLUMN_UNIQUE_KEY && !(flags & FIELD_COLUMN_UNIQUE_PAIR))
    {
        strcat(buf, " UNIQUE", len);
    }
    if (flags & FIELD_COLUMN_AUTO_INCREMENT)
    {
        strcat(buf, " AUTO_INCREMENT", len);
    }
    if (flags & FIELD_COLUMN_NOT_NULL)
    {
        strcat(buf, " NOT NULL", len);
    }

    return 1;
}


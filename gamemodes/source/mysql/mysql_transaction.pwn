
/*
Пример для откатов транзакций

mysql_transaction(handle, false);
mysql_query(handle, "query1");
mysql_query(handle, "query1");
mysql_query(handle, "query2");
// проверяешь какие-то ошибки, если что-то не понравилось по ходу действий:
if (error) {
    mysql_rollback(handle);
    return 0;
}
mysql_commit(handle);
*/

/*
- Хукать mysql_tquery и mysql_query
- Переписать некоторые старые транзакции
- Проверить транзакцию внутри транзакции (попробовать несколько уровне транзакций в транзакции)
*/

CMD:testtrans(playerid, const params[])
{
    if(params[0] == '0')
    {
        mysql_transaction(pearsq, true);
        mysql_tquery(pearsq, "INSERT INTO `AA_test` SET `variable0` = '228'");
        mysql_tquery(pearsq, "INSERT INTO `AA_test` SET `variable1` = '1488'");
        mysql_tquery(pearsq, "INSERT INTO `AA_test` SET `variable2` = 'хуй'");
        mysql_commit(pearsq);
    }
    else if(params[0] == '1')
    {
        mysql_transaction(pearsq, true);
        mysql_tquery(pearsq, "UPDATE `AA_test` SET `variable0` = '229' WHERE newid = 1");
        mysql_tquery(pearsq, "UPDATE `AA_test` SET `variable0` = '-50' WHERE newid = 2");
        mysql_commit(pearsq);
    }
    else if(params[0] == '2')
    {
        mysql_transaction(pearsq, true);
        mysql_tquery(pearsq, "UPDATE `AA_test` SET `variable0` = '229' WHERE newid = 1");
        mysql_tquery(pearsq, "UPDATE `AA_test` SET `variable0` = '-50' WHERE newid = 2");
        mysql_tquery(pearsq, "INSERT INTO `AA_test` SET `variable2` = 'залупа'");
        mysql_commit(pearsq);
    }
    else if(params[0] == '3')
    {
        mysql_transaction(pearsq, true);
        mysql_tquery(pearsq, "UPDATE `AA_test` SET `variable0` = '229' WHERE newid = 1");
        mysql_tquery(pearsq, "UPDATE `AA_test` SET `variable0` = '-50' WHERE newid = 2");
        mysql_tquery(pearsq, "INSERT INTO `AA_test` SET `variable2` = 'хрен хрен'");

        mysql_rollback(pearsq);
        return 0;
    }
    return true;
}

new _mysql_transaction_id = 0;
new bool:_mysql_async_transaction = false;
new MySQL:_mysql_last_inst_transaction = MYSQL_INVALID_HANDLE;

stock _mysql_transaction_query(MySQL:handle, const query[]) {
    if (_mysql_async_transaction) {
        return mysql_tquery(handle, query);
    }
    mysql_query(handle, query, false);
    return true;
}

stock mysql_transaction(MySQL:handle, bool:async = true) {
    if (_mysql_transaction_id != 0 && _mysql_async_transaction != async) {
        printf("[ERROR] ALERT ALERT ALERT mysql_transaction MIXED WITH sync AND async\n");
        return 0;
    }
    if (_mysql_last_inst_transaction != MYSQL_INVALID_HANDLE && _mysql_transaction_id != 0 && _mysql_last_inst_transaction != handle) {
        printf("[ERROR] ALERT ALERT ALERT mysql_transaction MIXED WITH ANOTHER MYSQL INSTANCE\n");
        return 0;
    }
    _mysql_async_transaction = async;
    _mysql_last_inst_transaction = handle;
    if (_mysql_transaction_id++ == 0) {
        _mysql_transaction_query(handle, "BEGIN");
    } else {
        new query_fmt[32];
        format(query_fmt, sizeof(query_fmt), "SAVEPOINT save%d", _mysql_transaction_id);
        _mysql_transaction_query(handle, query_fmt);
    }
    return 1;
}

stock mysql_commit(MySQL:handle) {
    if (_mysql_transaction_id == 0) {
        return 0;
    }
    if (_mysql_last_inst_transaction != MYSQL_INVALID_HANDLE && _mysql_transaction_id != 0 && _mysql_last_inst_transaction != handle) {
        printf("[ERROR] ALERT ALERT ALERT mysql_commit MIXED WITH ANOTHER MYSQL INSTANCE\n");
        return 0;
    }
    if (--_mysql_transaction_id == 0) {
        _mysql_transaction_query(handle, "COMMIT");
    } else {
        new query_fmt[32];
        format(query_fmt, sizeof(query_fmt), "RELEASE SAVEPOINT save%d", _mysql_transaction_id + 1);
        _mysql_transaction_query(handle, query_fmt);
    }
    return 1;
}

stock mysql_rollback(MySQL:handle) {
    if (_mysql_transaction_id == 0) {
        return 0;
    }
    if (_mysql_last_inst_transaction != MYSQL_INVALID_HANDLE && _mysql_transaction_id != 0 && _mysql_last_inst_transaction != handle) {
        printf("[ERROR] ALERT ALERT ALERT mysql_rollback MIXED WITH ANOTHER MYSQL INSTANCE\n");
        return 0;
    }
    if (--_mysql_transaction_id == 0) {
        _mysql_transaction_query(handle, "ROLLBACK");
    } else {
        new query_fmt[32];
        format(query_fmt, sizeof(query_fmt), "ROLLBACK TO SAVEPOINT save%d", _mysql_transaction_id + 1);
        _mysql_transaction_query(handle, query_fmt);
    }
    return 1;
}

stock mysql_commit_all(MySQL:handle) {
    if (_mysql_transaction_id == 0) {
        return 0;
    }
    if (_mysql_last_inst_transaction != MYSQL_INVALID_HANDLE && _mysql_transaction_id != 0 && _mysql_last_inst_transaction != handle) {
        printf("[ERROR] ALERT ALERT ALERT mysql_commit_all MIXED WITH ANOTHER MYSQL INSTANCE\n");
        return 0;
    }
    _mysql_transaction_query(handle, "COMMIT");
    return 1;
}

stock mysql_rollback_all(MySQL:handle) {
    if (_mysql_transaction_id == 0) {
        return 0;
    }
    if (_mysql_last_inst_transaction != MYSQL_INVALID_HANDLE && _mysql_transaction_id != 0 && _mysql_last_inst_transaction != handle) {
        printf("[ERROR] ALERT ALERT ALERT mysql_rollback_all MIXED WITH ANOTHER MYSQL INSTANCE\n");
        return 0;
    }
    _mysql_transaction_query(handle, "ROLLBACK");
    return 1;
}

stock LoadContinentalCoinInfo()
{
    new Cache:cache = mysql_query(pearsq, "SELECT * FROM `pp_continental`");

    new rows;
    cache_get_row_count(rows);

    if (!rows) {
        cache_delete(cache);
        return 0;
    }

    SQL_LOAD_ENUM(ContinentalCoinInfo, SQL_GET_ENUM_DEFINE(ContinentalCoinInfo), 0);

    cache_delete(cache);

    return 1;
}

stock SaveContinentalCoinInfo()
{
    new where[] = "id = 1";
    SQL_SAVE_ENUM_IF_NOT_EXISTS(pearsq, "pp_continental", ContinentalCoinInfo, SQL_GET_ENUM_DEFINE(ContinentalCoinInfo), where, where);

    return 1;
}

function LoadPlayerContinentalCoins(playerid)
{
    new rows;
    cache_get_row_count(rows);
    if (!rows) return 0;

    SQL_LOAD_ENUM(ContinentalCoinPlayerInfo[playerid], SQL_GET_ENUM_DEFINE(ContinentalCoinPlayerInfo), 0);

    return 1;
}

stock SavePlayerContinentalCoins(playerid)
{
    FORMAT:where("userid = %d", PlayerInfo[playerid][pID]);

    if (GetPlayerContinentalCoins(playerid) <= 0)
    {
        new f_str[128];
        mysql_format(pearsq, f_str, sizeof(f_str), "DELETE FROM `pp_user_continental` WHERE %e", where);
        mysql_tquery(pearsq, f_str);
        return 1;
    }

    ContinentalCoinPlayerInfo[playerid][ccpiUserID] = PlayerInfo[playerid][pID];
    SQL_SAVE_ENUM_IF_NOT_EXISTS(pearsq, "pp_user_continental", ContinentalCoinPlayerInfo[playerid], SQL_GET_ENUM_DEFINE(ContinentalCoinPlayerInfo), where, where);

    return 1;
}

function DeleteExpiredContinentalCoins()
{
    new week_day = get_week_day(3);

    // Удаляем монеты прошлой недели этого же дня и конвертируем их в юниты
    new query[350], unix = gettime();
    format(query, sizeof(query),
        "UPDATE pp_igroki AS pi " \
        "JOIN pp_user_continental AS puc ON pi.user_id = puc.userid " \
        "SET pi.Unit = pi.Unit + (puc.coins_%d * %d), puc.coins_%d = 0 " \
        "WHERE %d >= (SELECT @last_update := FROM_UNIXTIME(puc.last_update)) " \
        "AND @last_update < DATE_SUB(FROM_UNIXTIME(%d), INTERVAL WEEKDAY(FROM_UNIXTIME(%d)) DAY)",

        week_day, ContinentalCoinInfo[cciExchangeRate], week_day, unix, unix, unix
    );


    mysql_tquery(pearsq, query);
    
    return 1;
}

function Call_takecontinental(playerid, const name[], amount)
{
    new rows;
    cache_get_row_count(rows);

    if (!rows)
    {
        return ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
    }

    new userid;
    cache_get_value_name_int(0, "user_id", userid);

    // Генерируем информацию об имеющихся монетах
    new info[e_ContinentalCoinPlayerInfo], total;
    info[ccpiUserID] = userid;
    for (new i = 0; i < 7; i++)
    {
        FORMAT:coins_day("coins_%d", i);

        cache_get_value_name_int(0, coins_day, info[ccpiCoins][i]);
        total += info[ccpiCoins][i];
    }
    if (total < amount) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У него нет такого количества монет (Доступно: %d)", total);

    // Вычитаем монеты
    for (new i = 6; i >= 0; i--)
    {
        if (info[ccpiCoins][i] >= amount)
        {
            info[ccpiCoins][i] -= amount;
            break;
        }
        else
        {
            amount -= info[ccpiCoins][i];
            info[ccpiCoins][i] = 0;
        }
    }

    new string[128];
    FORMAT:where("userid = %d", userid);
    if (total == amount)
    {
        mysql_format(pearsq, string, sizeof(string), "DELETE FROM `pp_user_continental` WHERE %e", where);
        mysql_tquery(pearsq, string);
    }
    else
    {
        SQL_SAVE_ENUM_IF_NOT_EXISTS(pearsq, "pp_user_continental", info, SQL_GET_ENUM_DEFINE(ContinentalCoinPlayerInfo), where, where);
    }

    format(string, sizeof(string), "   Я забираю у %s %d монет Континенталь", name, amount), SendClientMessage(playerid, COLOR_GRAD1, string);
    format(string, sizeof(string), " [ ADM ]: %s забрал %d монет Континенталь у %s", PlayerInfo[playerid][pName], amount, name);
    ABroadCast(COLOR_ADM,string,2);
    AdminLog("takecontinental", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], userid, name, "", amount, "");

    return 1;
}

function Call_givecontinental(playerid, const name[], amount)
{
    new rows;
    cache_get_row_count(rows);

    if (!rows)
    {
        return ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
    }

    new userid;
    cache_get_value_name_int(0, "user_id", userid);

    FORMAT:coins_day("coins_%d", get_week_day(3));
    new bool: is_null = false;
    cache_is_value_name_null(0, coins_day, is_null);
    
    new query[128];
    if (!is_null)
    {
        mysql_format(pearsq, query, sizeof(query),
            "UPDATE pp_user_continental SET `%s` = `%s` + %d WHERE userid = %d",
            coins_day, coins_day, amount, userid
        );
        mysql_tquery(pearsq, query);
    }
    else
    {
        mysql_format(pearsq, query, sizeof(query),
            "INSERT INTO pp_user_continental (userid, `%s`) VALUES (%d, %d)",
            coins_day, userid, amount
        );
        mysql_tquery(pearsq, query);
    }

    new string[128];
    format(string, sizeof(string), "   %s получил от меня %d монет Континенталь", name, amount), SendClientMessage(playerid, COLOR_GRAD1, string);
    format(string, sizeof(string), " [ ADM ]: %s выдал %d монет Континенталь %s", PlayerInfo[playerid][pName], amount, name);
    ABroadCast(COLOR_ADM,string,2);
    AdminLog("givecontinental", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], userid, name, "", amount, "");

    return 1;
}

function Call_paycontinental(playerid, const name[], amount, fractionid)
{
    new rows;
    cache_get_row_count(rows);

    if (!rows)
    {
        return ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
    }

    new userid, member, leader;
    cache_get_value_name_int(0, "user_id", userid);
    cache_get_value_name_int(0, "Member", member);
    cache_get_value_name_int(0, "Leader", leader);

    if (member != fractionid) return ErrorMessage(playerid, "{FF6347}Это не участник вашей организации");
    if (leader > 0) return ErrorMessage(playerid, "{FF6347}Вы не можете начислить монеты лидеру");

    FORMAT:coins_day("coins_%d", get_week_day(3));
    new bool: is_null = false;
    cache_is_value_name_null(0, coins_day, is_null);
    
    new query[128];
    if (!is_null)
    {
        mysql_format(pearsq, query, sizeof(query),
            "UPDATE pp_user_continental SET `%s` = `%s` + %d WHERE userid = %d",
            coins_day, coins_day, amount, userid
        );
        mysql_tquery(pearsq, query);
    }
    else
    {
        mysql_format(pearsq, query, sizeof(query),
            "INSERT INTO pp_user_continental (userid, `%s`) VALUES (%d, %d)",
            coins_day, userid, amount
        );
        mysql_tquery(pearsq, query);
    }

    OrgLog(fractionid, "paycontinental", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], userid, name, "", amount, "Передал монеты");

    return 1;
}

stock GivePlayerContinentalCoins(playerid, amount)
{
    if (amount < 0) return TakePlayerContinentalCoins(playerid, -amount);
    
    new week_day = get_week_day(3);
    ContinentalCoinPlayerInfo[playerid][ccpiCoins][week_day] += amount;
    ContinentalCoinPlayerInfo[playerid][ccpiLastUpdate] = gettime();

    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~~h~~h~Continental: ~w~+%d", 3000, 3, amount);

    return 1;
}

stock GiveFractionContinentalCoins(fractionid, amount)
{
    if (amount < 0) return TakeFractionContinentalCoins(fractionid, -amount);

    new week_day = get_week_day(3);
    OrganInfo[fractionid][gcontinental][week_day] += amount;
    OrganInfo[fractionid][gcontinental_last_update] = gettime();
    OrganInfo[fractionid][gUpdate] = 1;

    return 1;
}

stock GetPlayerContinentalCoins(playerid)
{
    new amount = 0;

    for (new i = 0; i < 7; i++)
    {
        amount += ContinentalCoinPlayerInfo[playerid][ccpiCoins][i];
    }

    return amount;
}

stock GetFractionContinentalCoins(fractionid)
{
    new amount = 0;

    for (new i = 0; i < 7; i++)
    {
        amount += OrganInfo[fractionid][gcontinental][i];
    }

    return amount;
}

stock TakePlayerContinentalCoins(playerid, amount)
{
    if (amount < 0) return GivePlayerContinentalCoins(playerid, -amount);
    if (GetPlayerContinentalCoins(playerid) < amount) return 0;

    for (new i = 6; i >= 0; i--)
    {
        if (ContinentalCoinPlayerInfo[playerid][ccpiCoins][i] >= amount)
        {
            ContinentalCoinPlayerInfo[playerid][ccpiCoins][i] -= amount;
            break;
        }
        else
        {
            amount -= ContinentalCoinPlayerInfo[playerid][ccpiCoins][i];
            ContinentalCoinPlayerInfo[playerid][ccpiCoins][i] = 0;
        }
    }
    ContinentalCoinPlayerInfo[playerid][ccpiLastUpdate] = gettime();

    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~~h~~h~Continental: ~r~-%d", 3000, 3, amount);

    return 1;
}

stock PayPlayerContinentalCoins(playerid, amount, const reason[])
{
    new g = PlayerInfo[playerid][pFraction];
    if (!IsAMafiaID(g)) return 0;
    if (GetPlayerContinentalCoins(playerid) < amount) return 0;
    if (GetFractionContinentalCoins(g) < amount) return 0;

    TakePlayerContinentalCoins(playerid, amount);
    TakeFractionContinentalCoins(g, amount);

    OrgLog(g, "paycontinental", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, reason);

    return 1;
}

stock TakeFractionContinentalCoins(fractionid, amount)
{
    if (amount < 0) return GiveFractionContinentalCoins(fractionid, -amount);
    if (GetFractionContinentalCoins(fractionid) < amount) return 0;

    for (new i = 6; i >= 0; i--)
    {
        if (OrganInfo[fractionid][gcontinental][i] >= amount)
        {
            OrganInfo[fractionid][gcontinental][i] -= amount;
            break;
        }
        else
        {
            amount -= OrganInfo[fractionid][gcontinental][i];
            OrganInfo[fractionid][gcontinental][i] = 0;
        }
    }

    OrganInfo[fractionid][gcontinental_last_update] = gettime();
    OrganInfo[fractionid][gUpdate] = 1;

    return 1;
}

stock ResetPlayerContinentalCoins(playerid)
{
    for (new i = 0; i < 7; i++)
    {
        ContinentalCoinPlayerInfo[playerid][ccpiCoins][i] = 0;
    }

    return 1;
}

stock ResetFractionContinentalCoins(fractionid)
{
    for (new i = 0; i < 7; i++)
    {
        OrganInfo[fractionid][gcontinental][i] = 0;
    }

    SaveOrgan(fractionid);

    return 1;
}

stock ContinentalCoins_OnPlayerDisconnect(playerid)
{
    SavePlayerContinentalCoins(playerid);
    return 1;
}

DIALOG:setorgcontinental_coins(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<setorgcontinental_fraction>(playerid);

    new amount;
    if (sscanf(inputtext, "d", amount)) return ShowAdvancedDialog(playerid, "setorgcontinental_coins");
    if (amount < 1 || amount > 100000) return ErrorText(playerid, "{FF6347}Количество монет от 1 до 100000"), ShowAdvancedDialog(playerid, "setorgcontinental_coins");

    new fractionid = GetDialogContextInt(playerid, "fractionid");
    switch(GetDialogContextInt(playerid, "type"))
    {
        case 1: {
            GiveFractionContinentalCoins(fractionid, amount);
            FORMAT:text("{99ff66}Вы успешно выдали %d монет организации %s", amount, frakName[fractionid]);
            SuccessMessage(playerid, text);

            format(text, sizeof(text), "Выдал монеты (%d)", amount);
            AdminLog("giveorgcontinental", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fractionid, text);
            OrgLog(fractionid, "giveorgcontinental", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, text);
        }
        case 2: {
            if (!TakeFractionContinentalCoins(fractionid, amount)) return ShowAdvancedDialog(playerid, "setorgcontinental_coins");
            
            FORMAT:text("{99ff66}Вы успешно забрали %d монет у организации %s", amount, frakName[fractionid]);
            SuccessMessage(playerid, text);

            format(text, sizeof(text), "Забрал монеты (%d)", amount);
            AdminLog("takeorgcontinental", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fractionid, text);
            OrgLog(fractionid, "takeorgcontinental", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, text);
        }
        default: return 0;
    }

    return 1;
}

DIALOG_ITEMS:setorgcontinental_fraction(playerid, response, listitem, fractionid, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "setorgcontinental");

    SetDialogContextInt(playerid, "fractionid", fractionid);

    new balance = GetFractionContinentalCoins(fractionid);
    FORMAT_SIZE:text(144, "%s\n{cccccc}Текущий баланс: {ff4500}%d {cccccc}[%s]\n\n", frakName[fractionid], balance, get_k(balance));

    new type = GetDialogContextInt(playerid, "type");
    switch(type)
    {
        case 1: {
            format(text, sizeof(text), "%s{cccccc}Введите количество монет для выдачи:", text);
            ShowAdvancedDialog(playerid, "setorgcontinental_coins", DIALOG_STYLE_INPUT, "{cccccc}Выдача монет", text, "Ок", "Назад");
        }
        case 2: {
            format(text, sizeof(text), "%s{cccccc}Введите количество монет для изъятия:", text);
            ShowAdvancedDialog(playerid, "setorgcontinental_coins", DIALOG_STYLE_INPUT, "{cccccc}Изъятие монет", text, "Ок", "Назад");
        }
        default: return 0;
    }

    return 1;
}

DIALOG_GENERATOR:setorgcontinental_fraction(playerid)
{
    new dialog_text[256];
    for (new i = 0; i < MAX_ORG; i++)
    {
        if (!IsAMafiaID(i)) continue;

        format(dialog_text, sizeof(dialog_text), "%s%s\n", dialog_text, frakName[i]);
        AttachAdvancedDialogItemValue(playerid, "setorgcontinental_fraction", i);
    }

    return ShowAdvancedDialog(playerid, "setorgcontinental_fraction", DIALOG_STYLE_TABLIST, "{cccccc}Выбор организации", dialog_text, "Выбор", "Назад");
}

DIALOG:setorgcontinental_setreward(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialogGen<setorgcontinental_rewards>(playerid);

    new reward = GetDialogContextInt(playerid, "reward");
    if (reward < 0 || reward >= sizeof(ContinentalCoinActionNames)) return 0;

    new amount;
    if (sscanf(inputtext, "d", amount)) return ShowAdvancedDialog(playerid, "setorgcontinental_setreward");
    if (amount < -50 || amount > 50) return ErrorText(playerid, "{FF6347}Количество монет от -50 (для отрицательных действий) до 50 (для положительных действий)"), ShowAdvancedDialog(playerid, "setorgcontinental_setreward");

    ContinentalCoinInfo[cciRewards][reward] = amount;
    SaveContinentalCoinInfo();

    FORMAT:log("Изменение награды за %s на %d монет", ContinentalCoinActionNames[reward], amount);
    AdminLog("setorgcontinental", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, log);

    ShowAdvancedDialogGen<setorgcontinental_rewards>(playerid);

    return 1;
}

DIALOG:setorgcontinental_rewards(playerid, response, listitem, const inputtext[])
{
    if (!response) return ShowAdvancedDialog(playerid, "setorgcontinental");

    new reward = listitem;
    SetDialogContextInt(playerid, "reward", reward);

    FORMAT:text("{cccccc}Текущая награда: %s%d\n\n{cccccc}Введите количество монет:", ContinentalCoinInfo[cciRewards][reward] > 0 ? "{99ff66}" : "{ff6347}", ContinentalCoinInfo[cciRewards][reward]);
    return ShowAdvancedDialog(playerid, "setorgcontinental_setreward", DIALOG_STYLE_INPUT, "{cccccc}Изменение награды", text, "Ок", "Назад");
}

DIALOG_GENERATOR:setorgcontinental_rewards(playerid)
{
    new dialog_text[256];
    for (new i = 0; i < sizeof(ContinentalCoinActionNames); i++)
    {
        format(dialog_text, sizeof(dialog_text), "%s{cccccc}%s\t%s[ %d монет ]\n", dialog_text,
            ContinentalCoinActionNames[i],
            ContinentalCoinInfo[cciRewards][i] > 0 ? "{99ff66}" : "{ff6347}",
            ContinentalCoinInfo[cciRewards][i]
        );
    }

    return ShowAdvancedDialog(playerid, "setorgcontinental_rewards", DIALOG_STYLE_TABLIST, "{cccccc}Настройка монет за активности", dialog_text, "Выбор", "Назад");
}

DIALOG:setorgcontinental(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    SetDialogContextInt(playerid, "type", listitem + 1);
    switch (listitem)
    {
        case 0: {
            ShowAdvancedDialogGen<setorgcontinental_fraction>(playerid);
        }
        case 1: {
            ShowAdvancedDialogGen<setorgcontinental_fraction>(playerid);
        }
        case 2: {
            ShowAdvancedDialogGen<setorgcontinental_rewards>(playerid);
        }
    }

    return 1;
}

CMD:setorgcontinental(playerid)
{
    if (PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к этой команде");
    return ShowAdvancedDialog(playerid, "setorgcontinental", DIALOG_STYLE_TABLIST, "{ff9000}Настройка монет",
        "{99ff66}Выдать монеты\n" \
        "{ff6347}Забрать монеты\n" \
        "{ff9000}Настройка монет за активности\t>>",

        "Выбор", "Закрыть", true
    );
}

CMD:setcontinentalexchange(playerid, const params[])
{
    if (PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к этой команде");

    new amount;
    if (sscanf(params, "d", amount)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Установить курс монет Континенталь [ /setcontinentalexchange Курс ]");
    if (amount < 1 || amount > 100000) return ErrorMessage(playerid, "{FF6347}Курс обмена монеты от 1 до 100000");

    FORMAT:log("Изменил курс обмена монеты (Было: %d)", ContinentalCoinInfo[cciExchangeRate] );

    ContinentalCoinInfo[cciExchangeRate] = amount;
    SaveContinentalCoinInfo();

    AdminLog("setcontinentalexchange", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, log);

    SuccessMessage(playerid, "{99ff66}Курс обмена монеты успешно изменен");

    return 1;
}

CMD:giveoffshore(playerid, params[])
{
    if (PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к этой команде");

    new g, amount;
    if (sscanf(params, "ud", g, amount)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать деньги на офшорный счет [ /giveoffshore ID Количество ]");
    if (!IsAMafiaID(g)) return ErrorMessage(playerid, "{FF6347}Это не мафия");
    if (amount < 1 || amount > 1000000) return ErrorMessage(playerid, "{FF6347}Количество денег от 1 до 1000000");
    
    FORMAT:log("Выдал деньги на офшорный счёт %s (Было: %d)", frakeasyName[g], OrganInfo[g][goffshore]);
    OrganInfo[g][goffshore] += amount;
    OrganInfo[g][gUpdate] = 1;

    AdminLog("giveoffshore", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, log);
    OrgLog(g, "giveoffshore", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, "Выдал деньги на офшорный счет");

    FORMAT:string(" [ ADM ]: %s выдал %d$ на офшорный счет %s", PlayerInfo[playerid][pName], amount, frakName[g]);
    ABroadCast(COLOR_ADM, string, 2);

    return 1;
}


CMD:takeoffshore(playerid, params[])
{
    if (PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к этой команде");

    new g, amount;
    if (sscanf(params, "ud", g, amount)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Забрать деньги с офшорного счета [ /takeoffshore ID Количество ]");
    if (!IsAMafiaID(g)) return ErrorMessage(playerid, "{FF6347}Это не мафия");
    if (amount < 1 || amount > 1000000) return ErrorMessage(playerid, "{FF6347}Количество денег от 1 до 1000000");

    if (OrganInfo[g][goffshore] < amount) {
        FORMAT:error("{FF6347}На офшорном счете недостаточно денег [ Доступно: %d ]", OrganInfo[g][goffshore]);
        return ErrorMessage(playerid, error);
    }

    FORMAT:log("Забрал деньги с офшорного счёта %s (Было: %d)", frakeasyName[g], OrganInfo[g][goffshore]);
    OrganInfo[g][goffshore] -= amount;
    OrganInfo[g][gUpdate] = 1;

    AdminLog("takeoffshore", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, log);
    OrgLog(g, "takeoffshore", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", amount, "Забрал деньги с офшорного счета");
    
    FORMAT:string(" [ ADM ]: %s забрал %d$ с офшорного счета %s", PlayerInfo[playerid][pName], amount, frakName[g]);
    ABroadCast(COLOR_ADM, string, 2);

    return 1;
}

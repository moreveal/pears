
alias:cleartaxes("cleartax")
CMD:cleartaxes(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    if(sscanf(params, "s[121]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Очистить подоходный налог игрока [ /cleartaxes ID ]");
	if(strlen(params[0]) > 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Длина никнейма не больше 20-ти символов");
	new giveplayerid;
 	giveplayerid = ReturnUser(params[0], 1);
	if(IsPlayerConnected(giveplayerid)) 
	{
        if(OnlineInfo[giveplayerid][oLogged] == 0) return ErrorMessage(playerid, "{FF6347}Игрок не залогинился");
        if(PlayerInfo[giveplayerid][pTaxes][1] <= 0) return ErrorMessage(playerid, "{FF6347}У игрока нет задолженности подоходного налога");
        new taxes = ClearPlayerTaxes(giveplayerid);
        mysql_save(giveplayerid, 44);

        SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы очистили подоходный налог %s в размере {FF6347}%d$", PlayerInfo[giveplayerid][pName], taxes);
        if(giveplayerid != playerid) 
        {
            SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "* Администратор %s очистил ваш подоходный налог в размере {FF6347}%d$", PlayerInfo[playerid][pName], taxes);
        }
        AdminLog("cleartaxes", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], taxes, "Очистил подоходный налог");
    }
    else
    {
        if(!CheckRP_Nickname(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
        new string[57];
        mysql_format(pearsq, string,sizeof(string),"SELECT user_id, Taxes1 FROM `pp_igroki` WHERE `Name` = '%e'", params[0]);
        mysql_tquery(pearsq, string, "Call_cleartaxes", "ds", playerid, params[0]);
    }
    return true;
}

function Call_cleartaxes(playerid, const str_name[])
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new user_id, Taxes1;
		cache_get_value_name_int(0, "user_id", user_id);
        cache_get_value_name_int(0, "Taxes1", Taxes1);
        if(Taxes1 <= 0) return ErrorMessage(playerid, "{FF6347}У игрока нет задолженности подоходного налога");
        SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы очистили подоходный налог %s в размере {FF6347}%d$", str_name, Taxes1);

        new string[120];
        mysql_format(pearsq, string, sizeof(string), "UPDATE `pp_igroki` SET `Taxes1` = '0', `PlaTax` = '0' WHERE `user_id` = '%d'", user_id);
		mysql_tquery(pearsq, string);

        format(string, sizeof(string), "Админ %s очистил ваш подоходный налог", PlayerInfo[playerid][pName]);
 		notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], user_id, str_name, string);

        AdminLog("cleartaxes", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], user_id, str_name, "", Taxes1, "Очистил подоходный налог");
	}
	else ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
    return true;
}

stock ClearPlayerTaxes(playerid)
{
    new taxes = PlayerInfo[playerid][pTaxes][1];
    PlayerInfo[playerid][pTaxes][1] = 0;
	PlayerInfo[playerid][pPlaTax] = 0;
    return taxes;
}

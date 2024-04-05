
stock NoTempTakeWeapon(weaponid) // Оружие, которое не нужно временно отнимать
{
    if(weaponid == 23 // Пистолет с глушителем (Электрошокер)
        || weaponid == 41 // Spray
        || weaponid == 42 // Огнетушитель
        || weaponid == 43 // Camera
        || weaponid == 46) return 1; // Парашут
    return 0;
}
 
stock TempWeaponClear(playerid, i)
{
    TempWeapon[playerid][i] = 0;
    TempAmmo[playerid][i] = 0;
    TempDet[playerid][i] = 0;
    TempQet[playerid][i] = 0;
    TempUpdate[playerid][i] = 0;
    return 1;
}

stock ProtectWeaponClear(playerid, i)
{
    ProtectInfo[playerid][prWeapon][i] = 0;
    ProtectInfo[playerid][prAmmo][i] = 0;
    //ProtectInfo[playerid][prExplosive][i] = 0;
    ProtectInfo[playerid][prDet][i] = 0;
    ProtectInfo[playerid][prQet][i] = 0;
    ProtectInfo[playerid][prUpgrade][i] = 0;
    return 1;
}

stock GetPlayerWeaponInSlotAll(playerid, weaponid, slot)
{
    if(ProtectInfo[playerid][prWeapon][slot] == weaponid && ProtectInfo[playerid][prAmmo][slot] > 0
        || TempWeapon[playerid][slot] == weaponid && TempAmmo[playerid][slot] > 0) return 1;
    return 0;
}

stock GetPlayerWeaponProtect(playerid, weaponid, slot)
{
    if(ProtectInfo[playerid][prWeapon][slot] == weaponid && ProtectInfo[playerid][prAmmo][slot] > 0) return 1;
    return 0;
}

stock TempTake(playerid, stat) // Временно забираем оружие
{
	if(PlayerInfo[playerid][pBeret] == 0)
	{
        for(new i = 0; i < MAX_WEAPON_SLOTS; i++)
        {
            if(stat == 1 && NoTempTakeWeapon(ProtectInfo[playerid][prWeapon][i])) continue;

            if(ProtectInfo[playerid][prWeapon][i] > 0 && ProtectInfo[playerid][prAmmo][i] > 0) 
            {
                TempWeapon[playerid][i] = ProtectInfo[playerid][prWeapon][i];
                TempAmmo[playerid][i] = ProtectInfo[playerid][prAmmo][i];
                TempDet[playerid][i] = ProtectInfo[playerid][prDet][i];
                TempQet[playerid][i] = ProtectInfo[playerid][prQet][i];
                TempUpdate[playerid][i] = ProtectInfo[playerid][prUpgrade][i];
            }
        }
        if(stat == 0) OnDuty[playerid] = 0;
        Protect_TakeGuns(playerid, stat);

		PlayerInfo[playerid][pBeret] = 1;
		SetPlayerArmedWeapon(playerid, WEAPON:0);
		
        SetPVarInt(playerid,"afmysql",GetPVarInt(playerid,"afmysql")+1);
		if(GetPVarInt(playerid,"afmysql") <= 3) SaveGun(playerid);
	}
	return 1;
}

stock TempGive(playerid) // Возвращаем временно лишённое оружие
{
	if(PlayerInfo[playerid][pBeret] >= 1 // Есть временное лишение
        && PlayerInfo[playerid][pJailed] == 0 // Не в заключении
        && !Iamzz[playerid] // Не в зз
        && MPGO[playerid] == 0 // Не на мп
        && PlayerInfo[playerid][pBkyrenie] <= 1 // Не в космосе
        && GetPlayerState(playerid) != PLAYER_STATE_DRIVER) // Не за рулём
	{
		Protect_TakeGuns(playerid, 1);
		for(new i = 0; i < MAX_WEAPON_SLOTS; i++)
		{
			if(TempWeapon[playerid][i] > 0 && TempAmmo[playerid][i] > 0)
			{
				Protect_GiveWeapons(playerid, TempWeapon[playerid][i], TempAmmo[playerid][i], TempDet[playerid][i], TempQet[playerid][i]);
				TempWeaponClear(playerid, i);
			}
		}
		SetPlayerArmedWeapon(playerid, WEAPON:0);
		PlayerInfo[playerid][pBeret] = 0;

		SetPVarInt(playerid,"afmysql",GetPVarInt(playerid,"afmysql")+1);
		if(GetPVarInt(playerid,"afmysql") <= 3) SaveGun(playerid);
	}
	return 1;
}

// Новый сток загрузки оружия игрока
stock OnPlayerLoadWeapon(playerid)
{
	new string[20];
	for(new i = 0; i < MAX_WEAPON_SLOTS; i++)
	{
		new bool:is_null;
		format(string, sizeof(string), "gun_%d", i);
		cache_is_value_name_null(0, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(0, string, string_json, 512);

			new JsonNode:node = JSON_INVALID_NODE;

            if(PlayerInfo[playerid][pBeret] == 0) // Нет лишения
            {
                if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
                {
                    JSON_GetInt(node, "weap", ProtectInfo[playerid][prWeapon][i]);
                    JSON_GetInt(node, "ammo", ProtectInfo[playerid][prAmmo][i]);
                    JSON_GetInt(node, "emmo", ProtectInfo[playerid][prExplosive][i]);
                    JSON_GetInt(node, "det", ProtectInfo[playerid][prDet][i]);
                    JSON_GetInt(node, "qet", ProtectInfo[playerid][prQet][i]);
                    JSON_GetInt(node, "upg", ProtectInfo[playerid][prUpgrade][i]);
                }
            }
            else
            {
                if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
                {
                    JSON_GetInt(node, "weap", TempWeapon[playerid][i]);
                    JSON_GetInt(node, "ammo", TempAmmo[playerid][i]);
                    JSON_GetInt(node, "emmo", ProtectInfo[playerid][prExplosive][i]);
                    JSON_GetInt(node, "det", TempDet[playerid][i]);
                    JSON_GetInt(node, "qet", TempQet[playerid][i]);
                    JSON_GetInt(node, "upg", TempUpdate[playerid][i]);
                }
            }
		}
	}
	return 1;
}

stock SaveGun(playerid, bool:transaction = true)
{
	// Начало транзакции
	if(transaction == true) mysql_tquery(pearsq, "START TRANSACTION;");

	for(new i = 0; i < MAX_WEAPON_SLOTS; i++) SaveOneGun(playerid, i);

	// Завершение транзакции
	if(transaction == true) mysql_tquery(pearsq, "COMMIT;");
	return 1;
}

stock SaveOneGun(playerid, i)
{
    new JsonNode:node;
	CreateJsonWeapon(playerid, i, node);
	SaveOneGunByUserID(PlayerInfo[playerid][pID], i, node);
    return 1;
}

stock CreateJsonWeapon(playerid, i, &JsonNode:node)
{
    if(PlayerInfo[playerid][pBeret] == 0)
	{
        if(ProtectInfo[playerid][prWeapon][i] == 0) 
        {
            node = JSON_INVALID_NODE;
            return 1;
        }
        else
        {
            node = JSON_Object(
                "weap", JSON_Int(ProtectInfo[playerid][prWeapon][i]),
                "ammo", JSON_Int(ProtectInfo[playerid][prAmmo][i]),
                "emmo", JSON_Int(ProtectInfo[playerid][prExplosive][i]),
                "det", JSON_Int(ProtectInfo[playerid][prDet][i]),
                "qet", JSON_Int(ProtectInfo[playerid][prQet][i]),
                "upg", JSON_Int(ProtectInfo[playerid][prUpgrade][i])
            );
        }
    }
    else
    {
        if(TempWeapon[playerid][i] == 0) 
        {
            node = JSON_INVALID_NODE;
            return 1;
        }
        else
        {
            node = JSON_Object(
                "weap", JSON_Int(TempWeapon[playerid][i]),
                "ammo", JSON_Int(TempAmmo[playerid][i]),
                "emmo", JSON_Int(ProtectInfo[playerid][prExplosive][i]),
                "det", JSON_Int(TempDet[playerid][i]),
                "qet", JSON_Int(TempQet[playerid][i]),
                "upg", JSON_Int(TempUpdate[playerid][i])
            );
        }
    }
	return 1;
}

stock SaveOneGunByUserID(user_id, i, JsonNode:node)
{
    if(node == JSON_INVALID_NODE)
	{
		new string_mysql[140];
		format(string_mysql, sizeof(string_mysql), "UPDATE `pp_igroki` SET `gun_%d`= NULL WHERE `user_id` = '%d'", i, user_id);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
        new string_json[512];
        if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
        {
            new string_mysql[640];
            mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_igroki` SET `gun_%d`= '%e' WHERE `user_id` = '%d'", i, string_json, user_id);
            mysql_tquery(pearsq, string_mysql);
        }
    }
    return 1;
}

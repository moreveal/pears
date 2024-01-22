
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
    ProtectInfo[playerid][prExplosive][i] = 0;
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
        Protect_DeleteGuns(playerid, stat);

		PlayerInfo[playerid][pBeret] = 1;
		SetPlayerArmedWeapon(playerid, 0);
		
        SetPVarInt(playerid,"afmysql",GetPVarInt(playerid,"afmysql")+1);
		if(GetPVarInt(playerid,"afmysql") <= 3) SaveGun(playerid);
	}
	return 1;
}

stock TempGive(playerid) // Возвращаем временно лишённое оружие
{
	if(PlayerInfo[playerid][pBeret] >= 1 && PlayerInfo[playerid][pJailed] == 0 && !Iamzz[playerid] && MPGO[playerid] == 0
		&& Tir[0][playerid] == 0 && PlayerInfo[playerid][pBkyrenie] <= 1)
	{
		Protect_DeleteGuns(playerid, 1);
		for(new i = 0; i < MAX_WEAPON_SLOTS; i++)
		{
			if(TempWeapon[playerid][i] > 0 && TempAmmo[playerid][i] > 0)
			{
				Protect_GiveWeapons(playerid, TempWeapon[playerid][i], TempAmmo[playerid][i], TempDet[playerid][i], TempQet[playerid][i]);
				TempWeaponClear(playerid, i);
			}
		}
		SetPlayerArmedWeapon(playerid, 0);
		PlayerInfo[playerid][pBeret] = 0;

		SetPVarInt(playerid,"afmysql",GetPVarInt(playerid,"afmysql")+1);
		if(GetPVarInt(playerid,"afmysql") <= 3) SaveGun(playerid);
	}
	return 1;
}

stock LoadWeapon(playerid)
{
    new string[200];
    new temp_weap[MAX_WEAPON_SLOTS], temp_ammo[MAX_WEAPON_SLOTS], temp_det[MAX_WEAPON_SLOTS], temp_qet[MAX_WEAPON_SLOTS], temp_upd[MAX_WEAPON_SLOTS];

    // Оружие
	cache_get_value_name(0, "Weapon", string, sizeof(string));
	ParseStringToArray(string, temp_weap, MAX_WEAPON_SLOTS);

    // Патроны
	cache_get_value_name(0, "Ammo", string, sizeof(string));
	ParseStringToArray(string, temp_ammo, MAX_WEAPON_SLOTS);

    // Взрывные Патроны
	cache_get_value_name(0, "EAmmo", string, sizeof(string));
	ParseStringToArray(string, ProtectInfo[playerid][prExplosive], MAX_WEAPON_SLOTS);

    // Изношенность оружия
	cache_get_value_name(0, "WeapDet", string, sizeof(string));
	ParseStringToArray(string, temp_det, MAX_WEAPON_SLOTS);

    // Краденное оружие
	cache_get_value_name(0, "WeapQet", string, sizeof(string));
	ParseStringToArray(string, temp_qet, MAX_WEAPON_SLOTS);

    // Улучшения оружия
	cache_get_value_name(0, "WeapUpgrade", string, sizeof(string));
	ParseStringToArray(string, temp_upd, MAX_WEAPON_SLOTS);

    if(PlayerInfo[playerid][pBeret] == 0) // Нет лишения
    {
        for(new i = 0; i < MAX_WEAPON_SLOTS; i++)
		{
            if(temp_weap[i] > 0 && temp_ammo[i] > 0)
            {
                ProtectInfo[playerid][prWeapon][i] = temp_weap[i];
                ProtectInfo[playerid][prAmmo][i] = temp_ammo[i];
                ProtectInfo[playerid][prDet][i] = temp_det[i];
                ProtectInfo[playerid][prQet][i] = temp_qet[i];
                ProtectInfo[playerid][prUpgrade][i] = temp_upd[i];
            }
        }
    }
    else // Временное лишения
    {
        for(new i = 0; i < MAX_WEAPON_SLOTS; i++)
		{
            if(temp_weap[i] > 0 && temp_ammo[i] > 0)
            {
                TempWeapon[playerid][i] = temp_weap[i];
                TempAmmo[playerid][i] = temp_ammo[i];
                TempDet[playerid][i] = temp_det[i];
                TempQet[playerid][i] = temp_qet[i];
                TempUpdate[playerid][i] = temp_upd[i];
            }
        }
    }
    return 1;
}

stock SaveGun(playerid)
{
    new string_mysql[2096];

    new weaponString[256];
    new ammoString[256];
    new detString[256];
    new qetString[256];
    new explosiveString[256];
    new upgradeString[256];

    // Формируем строки для каждого атрибута
    ArrayToString(ProtectInfo[playerid][prExplosive], explosiveString, MAX_WEAPON_SLOTS);
    if(PlayerInfo[playerid][pBeret] == 0)
	{
        ArrayToString(ProtectInfo[playerid][prWeapon], weaponString, MAX_WEAPON_SLOTS);
        ArrayToString(ProtectInfo[playerid][prAmmo], ammoString, MAX_WEAPON_SLOTS);
        ArrayToString(ProtectInfo[playerid][prDet], detString, MAX_WEAPON_SLOTS);
        ArrayToString(ProtectInfo[playerid][prQet], qetString, MAX_WEAPON_SLOTS);
        ArrayToString(ProtectInfo[playerid][prUpgrade], upgradeString, MAX_WEAPON_SLOTS);
    }
    else 
    {
        ArrayToString(TempWeapon[playerid], weaponString, MAX_WEAPON_SLOTS);
        ArrayToString(TempAmmo[playerid], ammoString, MAX_WEAPON_SLOTS);
        ArrayToString(TempDet[playerid], detString, MAX_WEAPON_SLOTS);
        ArrayToString(TempQet[playerid], qetString, MAX_WEAPON_SLOTS);
        ArrayToString(TempUpdate[playerid], upgradeString, MAX_WEAPON_SLOTS);
    }

    format(string_mysql, sizeof(string_mysql), "UPDATE pp_igroki SET Weapon='%s', Ammo='%s', EAmmo='%s', WeapDet='%s', WeapQet='%s', WeapUpgrade='%s', Beret='%d' WHERE id=%d",
           weaponString, ammoString, explosiveString, detString, qetString, upgradeString, PlayerInfo[playerid][pBeret], PlayerInfo[playerid][pID]);
	query_empty(pearsq, string_mysql);
    return 1;
}

stock ArrayToString(const array[], dest[], maxsize) {
    for (new i = 0; i < maxsize; i++) {
        new temp[16];
        format(temp, sizeof(temp), "%d", array[i]);
        strcat(dest, temp, 256);
        if (i < maxsize - 1) {
            strcat(dest, ",", 256);
        }
    }
}

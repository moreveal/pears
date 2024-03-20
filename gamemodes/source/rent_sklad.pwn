CMD:rentsklad(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid,2.0,1371.6943,-19.6758,1000.9112) && GetPlayerInterior(playerid) == 238)
	{
	    new mw = GetPlayerVirtualWorld(playerid);
	    new r = mw-81;
	    if(r >= 0 && r <= 14)
	    {
		    if(WhInfo[r][wStat] >= 1)
			{
			    new fpick = OnlineInfo[playerid][oInHandThing][0], fquan = OnlineInfo[playerid][oInHandThing][1];
				new thingQara = OnlineInfo[playerid][oInHandThing][3], thingType = OnlineInfo[playerid][oInHandThing][4];
				new thingPack = OnlineInfo[playerid][oInHandThing][5];
				if(fpick > 0 && thingPack == 4) return ErrorMessage(playerid, "{FF6347}Запечатанный ящик невозможно распаковать на складе\n\n{cccccc}Этот ящик защищён и используется для доставки боеприпасов NGSA");
				if(fpick > 0 && thingPack == 2) //  Кладём Ящик
				{
					if(fpick == 34 && thingType == 1 && WhInfo[r][wStat] != 8 && WhInfo[r][wStat] != 22) return ErrorMessage(playerid, "{FF6347}На этом складе нельзя хранить снайперскую винтовку");
					if((fpick >= 4 && fpick <= 7 || fpick >= 27 && fpick <= 30) && thingType == 0 || IsHelmet(fpick) && thingType == 2 || IsArmor(fpick) && thingType == 2 || thingType == 1)
					{
					    new put_inva = putrentwh(r, fpick, fquan, thingType); // Кладём предмет
						if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}На складе, для этого предмета, нет места [ Лимит ]");

					    InHandClear(playerid);

						new string[70];
						format(string,sizeof(string),"[ Мысли ]: Я положил%s ящик на склад {ff9000}[ %s | %d ]", gender(playerid), GetNameThing(1, fpick, thingType, thingPack),fquan);
		    			SendClientMessage(playerid, COLOR_GREY, string);
						OrgLog(WhInfo[r][wStat], "putrentwh", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fquan, GetNameThing(1, fpick, thingType, thingPack));

			   		    SetPlayerChatBubble(playerid,"кладёт ящик на склад",COLOR_PURPLE,20.0,3000);
			       	    RemovePlayerAttachedObject(playerid,1);
			       	    PPP15[playerid] = 0;
			       	    ApplyAnimation(playerid,"CARRY","putdwn",4.0,0,0,0,0,0,1);
			       	    PlayerPlaySound(playerid,6401,0,0,0);

						// Выдаём юниты
	       	    		GiveUnitForBox(playerid, fpick, thingType, fquan, thingQara);
       	    		}
       	    		else ErrorMessage(playerid, "{FF6347}Содержимое ящика в моих руках, не может храниться на этом складе");
				}
				else ErrorMessage(playerid, "{FF6347}У меня нет в руках ящика [ Открыть склад: N >> Склад ]");
			}
			else ErrorMessage(playerid, "{FF6347}Этот склад никем не арендован");
		}
	}
	return 1;
}
stock use_rent(playerid, wh, inva)
{
	i_resetveshi(playerid);
    i_resettabs(playerid);
	new fpick = WhInfo[wh][wInvent][inva], thingType = WhInfo[wh][wInvType][inva];
	if(fpick == 0) return 1;
	if(OnlineInfo[playerid][oInHandThing] >= 1 || Hand[playerid] >= 1 || Hold[playerid] >= 1 || GetPlayerWeapon(playerid) >= 2) return ErrorMessage(playerid, "{FF6347}У вас заняты руки [ Предмет или оружие ]");

	new string[120];
	if(thingType == 0) // Количественные предметы до 1000 в один ящик
	{
	    if(CheckThingQuan(fpick) == 1)
	    {
	        DP[0][playerid] = inva;
			format(string,sizeof(string),"{cccccc}Чтобы собрать ящик с {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1000",GetNameThing(1, fpick, thingType, 0));
			ShowDialog(playerid,969,DIALOG_STYLE_INPUT,"{ff9000}Склад",string,"Принять","Отмена");
			return 1;
	    }
	}
	
	// Все остальные предметы до 10 штук в 1 ящик
	DP[0][playerid] = inva;
	format(string,sizeof(string),"{cccccc}Чтобы собрать ящик с {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 10",GetNameThing(1, fpick, thingType, 0));
	ShowDialog(playerid,969,DIALOG_STYLE_INPUT,"{ff9000}Склад",string,"Принять","Отмена");
	return 1;
}
stock shift_rent(playerid, wh, getinva, putinva) // Перемещение предметов внутри инвентаря арендованного склада организации (с одной ячейки на другую)
{
	if(OnlineInfo[playerid][oShowTabs] == wh)
	{
	    if(PlayerInfo[playerid][pLeader] == 0) return ErrorMessage(playerid, "{FF6347}Перемещать предметы может только лидер"), i_resettabs(playerid);
		if(WhInfo[wh][wInvent][getinva] == 0) return i_resettabs(playerid);
		else if(WhInfo[wh][wInvent][putinva] != 0) return 1;
		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 4) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			new string[80];
			format(string, sizeof(string), "{FF6347}Склад просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, string);
			i_resettabs(playerid);
			return 1;
		}
		WhInfo[wh][wInvent][putinva] = WhInfo[wh][wInvent][getinva];
		WhInfo[wh][wInv][putinva] = WhInfo[wh][wInv][getinva];
		WhInfo[wh][wInvType][putinva] = WhInfo[wh][wInvType][getinva];
		WhInfo[wh][wInvQara][putinva] = WhInfo[wh][wInvQara][getinva];
		WhInfo[wh][wInvUpdate][putinva] = true;

		WhInfo[wh][wInvent][getinva] = 0;
		WhInfo[wh][wInv][getinva] = 0;
		WhInfo[wh][wInvType][getinva] = 0;
		WhInfo[wh][wInvQara][getinva] = 0;
		WhInfo[wh][wInvUpdate][getinva] = true;

		i_resettabs(playerid);
		item_second(playerid, 0, 0, getinva, 0, 0, 0, 0, 0);
		item_second(playerid, WhInfo[wh][wInvent][putinva], WhInfo[wh][wInv][putinva], putinva, 0, 300000, WhInfo[wh][wInvType][putinva], 0, 0);
		WhInfo[wh][wUpdate] = 1;
	}
	return 1;
}
stock putrentwh(wh, pick, kol, thingType)
{
	new put_inva = -1, getLimit, bool:stopFind;
	rentwh_limit(pick, thingType, getLimit);
	
	for(new inva = 0; inva < 20; inva++)
	{
		if(WhInfo[wh][wInvent][inva] == pick && WhInfo[wh][wInvType][inva] == thingType)
		{
		    if(WhInfo[wh][wInv][inva]+kol > getLimit) // Встроенная проверка на лимит
		    {
		        stopFind = true;
		    }
			else WhInfo[wh][wInv][inva] += kol, put_inva = inva;
			break;
		}
	}
	if(put_inva == -1 && stopFind == false)
	{
		for(new inva = 0; inva < 20; inva++)
		{
			if(WhInfo[wh][wInvent][inva] == 0)
			{
				WhInfo[wh][wInvent][inva] = pick, WhInfo[wh][wInv][inva] += kol, WhInfo[wh][wInvType][inva] = thingType;
				put_inva = inva;
				break;
			}
		}
 	}
 	if(put_inva >= 0)
 	{
		WhInfo[wh][wInvUpdate][put_inva] = true;
 		WhInfo[wh][wUpdate] = 1;
	 	foreach(Player,i)
		{
			if(Tabs_Load[i] != 4) continue;
			if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowTabs] == wh) tilesklad(i, WhInfo[wh][wInvent][put_inva], WhInfo[wh][wInv][put_inva], put_inva, thingType);
		}
	}
	return put_inva;
}
stock TakeRentwh(wh, stat, kolvo, thingType, dopinf)
{
	if(WhInfo[wh][wInvent][dopinf] == stat && WhInfo[wh][wInvType][dopinf] == thingType)
	{
		if(WhInfo[wh][wInv][dopinf]-kolvo <= 0)
		{
	   		WhInfo[wh][wInvent][dopinf] = 0;
	   		WhInfo[wh][wInv][dopinf] = 0;
			WhInfo[wh][wInvType][dopinf] = 0;
			WhInfo[wh][wInvQara][dopinf] = 0;
		}
		else WhInfo[wh][wInv][dopinf] -= kolvo;
	}
	WhInfo[wh][wInvUpdate][dopinf] = true;
	WhInfo[wh][wUpdate] = 1;
	foreach(Player, i)
	{
		if(Tabs_Load[i] != 4) continue;
		if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowTabs] == wh) tilesklad(i, WhInfo[wh][wInvent][dopinf], WhInfo[wh][wInv][dopinf], dopinf, WhInfo[wh][wInvType][dopinf]);
	}
	return 1;
}

stock OnLoadRentInvent(idx)
{
	for(new i = 0; i < 20; i++)
	{
		new string[20], bool:is_null;
		format(string, sizeof(string), "r_slot_%d", i);
		cache_is_value_name_null(0, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(0, string, string_json, 512);

			new JsonNode:node = JSON_INVALID_NODE;
			if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
			{
				JSON_GetInt(node, "id", WhInfo[idx][wInvent][i]);
				JSON_GetInt(node, "quan", WhInfo[idx][wInv][i]);
				JSON_GetInt(node, "qara", WhInfo[idx][wInvQara][i]);
				JSON_GetInt(node, "type", WhInfo[idx][wInvType][i]);
			}
		}
	}
	return 1;
}

stock SaveRent(idx, bool:transaction = true) // Сохранение всего арендованного склада по циклу
{
	// Начало транзакции
	if(transaction == true) mysql_tquery(pearsq, "START TRANSACTION;");

	for(new i = 0; i < 20; i++) 
	{
		if(WhInfo[idx][wInvUpdate][i] == true) SaveRentOne(idx, i);
	}

	// Завершение транзакции
	if(transaction == true) mysql_tquery(pearsq, "COMMIT;");
	return 1;
}

stock SaveRentOne(idx, i)
{
	WhInfo[idx][wInvUpdate][i] = false;
	if(WhInfo[idx][wInvent][i] == 0)
	{
		new string_mysql[140];
		format(string_mysql, sizeof(string_mysql), "UPDATE `pp_rentwh` SET `r_slot_%d`= NULL WHERE `Ids` = '%d'", i, idx);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new JsonNode:node = JSON_Object(
			"id", JSON_Int(WhInfo[idx][wInvent][i]),
			"quan", JSON_Int(WhInfo[idx][wInv][i]),
			"qara", JSON_Int(WhInfo[idx][wInvQara][i]),
			"type", JSON_Int(WhInfo[idx][wInvType][i])
		);

		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_rentwh` SET `r_slot_%d`= '%e' WHERE `Ids` = '%d'", i, string_json, idx);
			mysql_tquery(pearsq, string_mysql);
		}
	}
	return 1;
}

stock rentwh_limit(thingId, thingType, &getLimit) // Проверяем лимиты склада организации
{
	if(thingType == 0) // Обычные Предметы
	{
	    if(thingId >= 4 && thingId <= 8) getLimit = 50000; // Вещества
	    else if(thingId >= 27 && thingId <= 30) getLimit = 50000; // Патроны
	    else getLimit = 10000; // На случай ошибки, остальные предметы лимит 10к
 	}
	else if(thingType == 1) getLimit = 5000; // Оружие
    else if(thingType == 2) getLimit = 5000; // Каски и Бронежилеты (Аксессуары)
    else getLimit = 10000; // На случай ошибки, остальные предметы лимит 10к
	return 1;
}

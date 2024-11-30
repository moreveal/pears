#define MAX_BACKPACK_ON_PLAYER 2

// Отображаем верхние вкладки инвентаря
stock TabBackpackShow(playerid)
{
	PlayerTextDrawShow(playerid, PlaInventDraw[12][playerid]); // Фон вкладки
	PlayerTextDrawShow(playerid, PlaInventDraw[13][playerid]); // Кнопка Инвентарь
	PlayerTextDrawShow(playerid, PlaInventDraw[14][playerid]); // Текст кнопки Инвентарь
	PlayerTextDrawShow(playerid, PlaInventDraw[15][playerid]); // Кнопка Рюкзак
	PlayerTextDrawShow(playerid, PlaInventDraw[16][playerid]); // Текст кнопки Рюкзак
	return true;
}

// Скрываем верхние вкладки инвентаря (Например, используем этот сток когда игрок снимет рюкзак)
stock TabBackpackHide(playerid)
{
	PlayerTextDrawHide(playerid, PlaInventDraw[12][playerid]); // Фон вкладки
	PlayerTextDrawHide(playerid, PlaInventDraw[13][playerid]); // Кнопка Инвентарь
	PlayerTextDrawHide(playerid, PlaInventDraw[14][playerid]); // Текст кнопки Инвентарь
	PlayerTextDrawHide(playerid, PlaInventDraw[15][playerid]); // Кнопка Рюкзак
	PlayerTextDrawHide(playerid, PlaInventDraw[16][playerid]); // Текст кнопки Рюкзак
	return true;
}

stock BackpackLoadPick(playerid)
{
	if(!BackPackInfo[playerid][backpackLoad]) return ErrorMessage(playerid,"{ff6347}Рюкзак еще не загрузился, подождите");
	Backpack[playerid] = 1;

	Page[playerid] = 0;
	i_switches(playerid, 0, 1);
	for(new inva = 0; inva < 20; inva++) i_tile(playerid, BackPackInfo[playerid][backpackInvent][inva], BackPackInfo[playerid][backpackInv][inva], inva, BackPackInfo[playerid][backpackInvPara][inva], BackPackInfo[playerid][backpackInvType][inva], BackPackInfo[playerid][backpackInvPack][inva]);
	return true;
}

stock ShowTabInventory(playerid)
{
	PlayerPlaySound(playerid,17803,0,0,0);
	InventoryLoadPick(playerid);
	return true;
}

stock ShowTabBackpack(playerid)
{
	PlayerPlaySound(playerid,17803,0,0,0);

	new aks = HasABustAks(playerid,1),slots;
	if(aks == -1) return ErrorMessage(playerid,"{ff6347}У вас проблема с рюкзаком. Пожалуйста свяжитесь с разработчиками");
	if(GetBustAksType(PlayerInfo[playerid][pOdet][aks]) == 1) slots = ResultCountBustAks(PlayerInfo[playerid][pOdet][aks], 1,PlayerInfo[playerid][pOdetPara][aks]);
	if(slots > 0) Backpages[playerid] = slots;
	else Backpages[playerid] = 1;
	OffSwitchInventory(playerid); // Выключаем все переключатели страниц
	CloseSwitchInventory(playerid); // Закрываем все переключатели
	PositionSwitchPages(playerid, Backpages[playerid]); // Меняем позиции положения кнопок страниц инвентаря (в зависимости от количества страниц в рюкзаке)
	ShowSwitchPages(playerid, Backpages[playerid]);
	BackpackLoadPick(playerid);
	return true;
}

stock player_tile_backpack(playerid, inva)
{
	if(OnlineInfo[playerid][oLogged] == 0 || Veshi[playerid] >= 1) return 1;
	PlayerPlaySound(playerid,17803,0,0,0);
	if(LoadPick[playerid] != 9999) return reset_aksess_tile(playerid);
	if(LoadGun[playerid] != 9999) return reset_gun_tile(playerid);
	new fpick = BackPackInfo[playerid][backpackInvent][inva], fquan = BackPackInfo[playerid][backpackInv][inva], fpara = BackPackInfo[playerid][backpackInvPara][inva], thingType = BackPackInfo[playerid][backpackInvType][inva], thingPack = BackPackInfo[playerid][backpackInvPack][inva];
	if(fpick == 0)
	{
		reset_pick_othe(playerid), PlayerTextDrawShow(playerid, PlaNestOthe[2][playerid]);
		if(Hold[playerid] == 4) Hold[playerid] = 0;
	}
	if(fpick == 0) // Ничего нет
	{
		if(OnlineInfo[playerid][oInventSelectRight] == 9999)
		{
			if(OnlineInfo[playerid][oInventSelectLeft] != 9999) // Перекладываем из инвентаря
			{
				if(JustOneThingInventory(PlayerInfo[playerid][pInven][OnlineInfo[playerid][oInventSelectLeft]],PlayerInfo[playerid][pInvenType][OnlineInfo[playerid][oInventSelectLeft]]) && get_invent(playerid,PlayerInfo[playerid][pInven][OnlineInfo[playerid][oInventSelectLeft]],PlayerInfo[playerid][pInvenType][OnlineInfo[playerid][oInventSelectLeft]]) > 0)
				{
					return ErrorMessage(playerid,"{ff6347}Данный предмет может быть один в инвентаре!"),i_resetveshi(playerid);
				}
				if(NotGiveThing(PlayerInfo[playerid][pInven][OnlineInfo[playerid][oInventSelectLeft]],PlayerInfo[playerid][pInvenType][OnlineInfo[playerid][oInventSelectLeft]],PlayerInfo[playerid][pInvenQuan][OnlineInfo[playerid][oInventSelectLeft]],PlayerInfo[playerid][pInvenPack][OnlineInfo[playerid][oInventSelectLeft]]))
				{
					return ErrorMessage(playerid,"{ff6347}Данный предмет нельзя убирать в рюкзак!"),i_resetveshi(playerid);
				}
				if(Hold[playerid] == 2 || Hold[playerid] == 3 && HoldStat[playerid] > 0)
		    	{
		    	    if(HoldInva[playerid] == OnlineInfo[playerid][oInventSelectLeft]) HoldInva[playerid] = inva;
		    	}
		    	if(IsABackPack(PlayerInfo[playerid][pInven][OnlineInfo[playerid][oInventSelectLeft]]) && thingPack == 0) return ErrorMessage(playerid,"{ff6347}Рюкзак нельзя убирать в рюкзак!"),i_resetveshi(playerid);

				BackPackInfo[playerid][backpackInvent][inva] = PlayerInfo[playerid][pInven][OnlineInfo[playerid][oInventSelectLeft]];
				BackPackInfo[playerid][backpackInv][inva] = PlayerInfo[playerid][pInvenQuan][OnlineInfo[playerid][oInventSelectLeft]];
				BackPackInfo[playerid][backpackInvPara][inva] = PlayerInfo[playerid][pInvenPara][OnlineInfo[playerid][oInventSelectLeft]];
				BackPackInfo[playerid][backpackInvQara][inva] = PlayerInfo[playerid][pInvenQara][OnlineInfo[playerid][oInventSelectLeft]];
				BackPackInfo[playerid][backpackInvType][inva] = PlayerInfo[playerid][pInvenType][OnlineInfo[playerid][oInventSelectLeft]];
				BackPackInfo[playerid][backpackInvPack][inva] = PlayerInfo[playerid][pInvenPack][OnlineInfo[playerid][oInventSelectLeft]];
				i_tile(playerid, BackPackInfo[playerid][backpackInvent][inva], BackPackInfo[playerid][backpackInv][inva], inva, BackPackInfo[playerid][backpackInvPara][inva], BackPackInfo[playerid][backpackInvType][inva], BackPackInfo[playerid][backpackInvPack][inva]);

				// Старую плитку удаляем
				PlayerInfo[playerid][pInven][OnlineInfo[playerid][oInventSelectLeft]] = 0;
				PlayerInfo[playerid][pInvenQuan][OnlineInfo[playerid][oInventSelectLeft]] = 0;
				PlayerInfo[playerid][pInvenPara][OnlineInfo[playerid][oInventSelectLeft]] = 0;
				PlayerInfo[playerid][pInvenQara][OnlineInfo[playerid][oInventSelectLeft]] = 0;
				PlayerInfo[playerid][pInvenType][OnlineInfo[playerid][oInventSelectLeft]] = 0;
				PlayerInfo[playerid][pInvenPack][OnlineInfo[playerid][oInventSelectLeft]] = 0;
				SaveInventBackPack(playerid,inva);

				OnlineInfo[playerid][oInventSelectLeft] = 9999;
				OnlineInfo[playerid][oInventSelectBackPack] = 9999;

				CheckCraftReady(playerid);

				new Aks = HasABustAks(playerid,1), string[100];
				format(string,sizeof(string),"Положил в рюкзак %d: %s", PlayerInfo[playerid][pOdetQara][Aks], GetNameThing(1, BackPackInfo[playerid][backpackInvent][inva], BackPackInfo[playerid][backpackInvType][inva], BackPackInfo[playerid][backpackInvPack][inva]));
				UserLog("inbackpackinv", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", BackPackInfo[playerid][backpackInv][inva], string);
			}
			else if(OnlineInfo[playerid][oInventSelectBackPack] != 9999 && OnlineInfo[playerid][oInventSelectBackPack] != inva) // Перекладываем в рюкзаке
			{
				if(Hold[playerid] == 2 || Hold[playerid] == 3 && HoldStat[playerid] > 0)
		    	{
		    	    if(HoldInva[playerid] == OnlineInfo[playerid][oInventSelectBackPack]) HoldInva[playerid] = inva;
		    	}
		    	
				BackPackInfo[playerid][backpackInvent][inva] = BackPackInfo[playerid][backpackInvent][OnlineInfo[playerid][oInventSelectBackPack]];
				BackPackInfo[playerid][backpackInv][inva] = BackPackInfo[playerid][backpackInv][OnlineInfo[playerid][oInventSelectBackPack]];
				BackPackInfo[playerid][backpackInvPara][inva] = BackPackInfo[playerid][backpackInvPara][OnlineInfo[playerid][oInventSelectBackPack]];
				BackPackInfo[playerid][backpackInvQara][inva] = BackPackInfo[playerid][backpackInvQara][OnlineInfo[playerid][oInventSelectBackPack]];
				BackPackInfo[playerid][backpackInvType][inva] = BackPackInfo[playerid][backpackInvType][OnlineInfo[playerid][oInventSelectBackPack]];
				BackPackInfo[playerid][backpackInvPack][inva] = BackPackInfo[playerid][backpackInvPack][OnlineInfo[playerid][oInventSelectBackPack]];
				i_tile(playerid, BackPackInfo[playerid][backpackInvent][inva], BackPackInfo[playerid][backpackInv][inva], inva, BackPackInfo[playerid][backpackInvPara][inva], BackPackInfo[playerid][backpackInvType][inva], BackPackInfo[playerid][backpackInvPack][inva]);

				// Старую плитку удаляем
				BackPackInfo[playerid][backpackInvent][OnlineInfo[playerid][oInventSelectBackPack]] = 0;
				BackPackInfo[playerid][backpackInv][OnlineInfo[playerid][oInventSelectBackPack]] = 0;
				BackPackInfo[playerid][backpackInvPara][OnlineInfo[playerid][oInventSelectBackPack]] = 0;
				BackPackInfo[playerid][backpackInvQara][OnlineInfo[playerid][oInventSelectBackPack]] = 0;
				BackPackInfo[playerid][backpackInvType][OnlineInfo[playerid][oInventSelectBackPack]] = 0;
				BackPackInfo[playerid][backpackInvPack][OnlineInfo[playerid][oInventSelectBackPack]] = 0;
				i_tile(playerid, BackPackInfo[playerid][backpackInvent][OnlineInfo[playerid][oInventSelectBackPack]], BackPackInfo[playerid][backpackInv][OnlineInfo[playerid][oInventSelectBackPack]], OnlineInfo[playerid][oInventSelectBackPack], BackPackInfo[playerid][backpackInvPara][OnlineInfo[playerid][oInventSelectBackPack]], BackPackInfo[playerid][backpackInvType][OnlineInfo[playerid][oInventSelectBackPack]], BackPackInfo[playerid][backpackInvPack][OnlineInfo[playerid][oInventSelectBackPack]]);
				
				SaveInventBackPack(playerid,inva);
				SaveInventBackPack(playerid,OnlineInfo[playerid][oInventSelectBackPack]);

				OnlineInfo[playerid][oInventSelectBackPack] = 9999;
				
				CheckCraftReady(playerid);
			}
		}
		else if(OnlineInfo[playerid][oInventSelectRight] != 9999) // Берём Откуда-то
		{
			OnlineInfo[playerid][oInventSelectBackPack] = inva;
			if(Tabs_Load[playerid] == 2)
			{
				if(OnlineInfo[playerid][oShowTabs] != 9999) return use_dom(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
			}
			else if(Tabs_Load[playerid] == 3)
			{
				if(OnlineInfo[playerid][oShowTabs] != 9999) return use_sklad(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
			}
			else if(Tabs_Load[playerid] == 4)
			{
				if(OnlineInfo[playerid][oShowTabs] != 9999) return use_rent(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight]);
			}
			else if(Tabs_Load[playerid] == 5)
			{
				if(OnlineInfo[playerid][oShowTabs] != 9999) return use_boot(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
			}
			else if(Tabs_Load[playerid] == 6) return use_mygoods(playerid, OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
			else if(Tabs_Load[playerid] == 7) return use_throw(playerid, OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
			else if(Tabs_Load[playerid] == 8) return use_trash(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
			else if(Tabs_Load[playerid] == 14)
			{
				if(OnlineInfo[playerid][oShowTabs] != 9999) return use_prisontable(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
			}
			else if(Tabs_Load[playerid] == 15)
			{
				if(OnlineInfo[playerid][oShowTabs] != 9999) return use_Apartments_table(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
			}
			else if(Tabs_Load[playerid] == 16)
			{
				if(OnlineInfo[playerid][oShowTabs] != 9999) return use_Refrigerator(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
			}
			else i_resettabs(playerid);
		}
	}
	else if(fpick > 0) // Что-то Лежит
	{
		if(OnlineInfo[playerid][oInventSelectBackPack] == 9999) // Выделяем
		{
			if(Page[playerid] == 0 && inva <= 19) PlayerTextDrawBackgroundColour(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva][playerid]);
			else if(Page[playerid] == 1 && inva >= 20 && inva <= 39) PlayerTextDrawBackgroundColour(playerid, PlaNestPick[inva-20][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva-20][playerid]);
			else if(Page[playerid] == 2 && inva >= 40 && inva <= 59) PlayerTextDrawBackgroundColour(playerid, PlaNestPick[inva-40][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva-40][playerid]);
			else if(Page[playerid] == 3 && inva >= 60 && inva <= 79) PlayerTextDrawBackgroundColour(playerid, PlaNestPick[inva-60][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva-60][playerid]);

			i_infofpick(playerid, fpick, fquan, inva, 0, fpara, thingType, thingPack);
			OnlineInfo[playerid][oInventSelectBackPack] = inva;
			if(OnlineInfo[playerid][oInventSelectRight] != 9999) // Кладём
			{
			    new myinva = OnlineInfo[playerid][oInventSelectRight], myfpick;
			    if(Tabs_Load[playerid] == 2)
				{
					if(OnlineInfo[playerid][oShowTabs] != 9999) myfpick = DomInfo[OnlineInfo[playerid][oShowTabs]][dInvent][myinva];
				}
				else if(Tabs_Load[playerid] == 3)
				{
					if(OnlineInfo[playerid][oShowTabs] != 9999) myfpick = OrganInfo[OnlineInfo[playerid][oShowTabs]][gInvent][myinva];
				}
				else if(Tabs_Load[playerid] == 5)
				{
					if(OnlineInfo[playerid][oShowTabs] != 9999) myfpick = VehInfo[OnlineInfo[playerid][oShowTabs]][vInvent][myinva];
				}
			    if(myfpick == 0 || myfpick != fpick) return i_resettabs(playerid), i_resetveshi(playerid);
				if(thingType == 0 && thingPack == 0)
				{
					if(CheckThingQuan(myfpick) == 1)
					{
						if(Tabs_Load[playerid] == 2)
						{
							if(OnlineInfo[playerid][oShowTabs] != 9999) return use_dom(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
						}
						else if(Tabs_Load[playerid] == 3)
						{
							if(OnlineInfo[playerid][oShowTabs] != 9999) return use_sklad(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
						}
						else if(Tabs_Load[playerid] == 5)
						{
							if(OnlineInfo[playerid][oShowTabs] != 9999) return use_boot(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
						}
						else if(Tabs_Load[playerid] == 6) return use_mygoods(playerid, OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
						else if(Tabs_Load[playerid] == 7) return use_throw(playerid, OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
						else if(Tabs_Load[playerid] == 8)
						{
							if(OnlineInfo[playerid][oShowTabs] != 9999) return use_trash(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
						}
						else if(Tabs_Load[playerid] == 14)
						{
							if(OnlineInfo[playerid][oShowTabs] != 9999) return use_prisontable(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
						}
						else if(Tabs_Load[playerid] == 15)
						{
							if(OnlineInfo[playerid][oShowTabs] != 9999) return use_Apartments_table(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
						}
						else if(Tabs_Load[playerid] == 16)
						{
							if(OnlineInfo[playerid][oShowTabs] != 9999) return use_Refrigerator(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectBackPack]);
						}
					}
					else i_resetveshi(playerid);
				}
				else i_resetveshi(playerid);
			}
		}
		else if(OnlineInfo[playerid][oInventSelectBackPack] != inva) i_resetveshi(playerid); // Сбрасываем Выбор
        else // Выполняем
		{
			ErrorMessage(playerid,"{ff6347}Предмет сначала нужно достать из рюкзака что бы использовать его!");
		}
	}
	return 1;
}

stock put_thing_player_backpack(playerid, thingId, quan, para, qara, thingType, thingPack, slot)
{
	if(BackPackInfo[playerid][backpackInvent][slot] != 0 && BackPackInfo[playerid][backpackInvent][slot] != thingId) return -1; // Защита от ошибки, на всякий случай

    if(qara == PlayerInfo[playerid][pID]) 
	{
		if(!IsABackPack(thingId)) qara = 0; // Удаляем статус краденного предмета, если он принадлежит этому игроку
	}
    // Выдача особых предметов
    if(thingType == 0) // Обычные предметы
    {
        ThingParameters(playerid, thingId, quan, para);
	}
	else if(thingType == 2) // Аксессуары с особыми возможностями
    {
        if(IsHelmet(thingId) && para == 0) para = 3; // Каска
        if(IsArmor(thingId) && para == 0) para = 100; // Бронежилет
    }
	
	BackPackInfo[playerid][backpackInvent][slot] = thingId; // Ставим предмет в слот

	if (thingType == 1 && thingPack == 0) {
		BackPackInfo[playerid][backpackInv][slot] = 1; // Добавляем всегда 1, т.к. в слоте не может быть более чем 1 оружия
	} else {
		BackPackInfo[playerid][backpackInv][slot] += quan; // Добавляем нужное количество в слот
	}

	// Не выдаем оружий ближнего боя больше чем 1
	if (thingType == 1 && !IsShootingWeapon(thingId)) BackPackInfo[playerid][backpackInv][slot] = min(quan, 1);
	
	// (Техника сломана или нет, Одежда какой организации принадлежит, Unix время свежести продуктов, Изношенность оружия, Прнадлежность лицензии к ID игрока, Тип крепления аксессуара)
	if(PerishableThing(thingId, thingType)) // Проверка на портящиеся продукты - у них используется Unix (Добавляя испорченный продукт к свежему, портиться должно всё)
	{
	    if(BackPackInfo[playerid][backpackInvPara][slot] > 0)
		{
			if(BackPackInfo[playerid][backpackInvPara][slot] > para) BackPackInfo[playerid][backpackInvPara][slot] = para;
		}
		else BackPackInfo[playerid][backpackInvPara][slot] = para;
	}
	else BackPackInfo[playerid][backpackInvPara][slot] = para;
	
	BackPackInfo[playerid][backpackInvQara][slot] = qara; // Статус краденного предмета
	BackPackInfo[playerid][backpackInvType][slot] = thingType; // Тип предмета
	BackPackInfo[playerid][backpackInvPack][slot] = thingPack; // Упаковка предмета
	
	SaveInventBackPack(playerid,slot);
	if(OnlineInfo[playerid][oShowInterface] == 1 && Backpack[playerid]) i_tile(playerid, BackPackInfo[playerid][backpackInvent][slot], BackPackInfo[playerid][backpackInv][slot], slot, BackPackInfo[playerid][backpackInvPack][slot], BackPackInfo[playerid][backpackInvType][slot], BackPackInfo[playerid][backpackInvPack][slot]), PlayerPlaySound(playerid,1052,0,0,0);
	return slot;
}

stock SaveInventBackPack(playerid, i)
{
	new Aks = HasABustAks(playerid,1);
	new backpackid;
	if(Aks != -1) backpackid = PlayerInfo[playerid][pOdetQara][Aks];
	else return 0;
	new JsonNode:node;
	CreateJsonBackPack(playerid, i, node);
	SaveInventBackPackByUserID(backpackid, i, node);
	return 1;
}

stock CreateJsonBackPack(playerid, i, &JsonNode:node)
{
	if(BackPackInfo[playerid][backpackInvent][i] == 0) 
	{
		node = JSON_INVALID_NODE;
		return 1;
	}

	node = JSON_Object(
		"id", JSON_Int(BackPackInfo[playerid][backpackInvent][i]),
		"quan", JSON_Int(BackPackInfo[playerid][backpackInv][i]),
		"para", JSON_Int(BackPackInfo[playerid][backpackInvPara][i]),
		"qara", JSON_Int(BackPackInfo[playerid][backpackInvQara][i]),
		"type", JSON_Int(BackPackInfo[playerid][backpackInvType][i]),
		"pack", JSON_Int(BackPackInfo[playerid][backpackInvPack][i])
	);

	return 1;
}

stock SaveInventBackPackByUserID(backpackid, i, JsonNode:node)
{
	if(node == JSON_INVALID_NODE)
	{
		new string_mysql[140];
		mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `backpacks` SET `b_slot_%d`= NULL,`lastunix`= '%d' WHERE `backpackid` = '%d'", i,gettime(), backpackid);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `backpacks` SET `b_slot_%d`= '%e',`lastunix`= '%d' WHERE `backpackid` = '%d'",
			i, string_json,gettime(),backpackid);
			mysql_tquery(pearsq, string_mysql);
		}
	}
	return 1;
}

function OnPlayerBackPackLoad(playerid, race_check,sl)
{
	new rows;
	cache_get_row_count(rows);

	if(rows)
	{
	    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);
		OnPlayerLoadBackPack(playerid,sl);
		printf("OnPlayerLoadBackPack(%s) Инвентарь Найден", PlayerInfo[playerid][pName]);
	}
	return 1;
}

function Call_getidBackPack(playerid,Aks) {
	PlayerInfo[playerid][pOdetQara][Aks] = cache_insert_id();
	new string_mysql[256];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT * FROM `backpacks` WHERE `backpackid` = '%d'", PlayerInfo[playerid][pOdetQara][Aks]);
	mysql_tquery(pearsq, string_mysql, "OnPlayerBackPackLoad", "ddd",playerid, g_MysqlRaceCheck[playerid],Aks);
    return 1;
}

stock OnPlayerLoadBackPack(playerid,sl)
{
	new string[20], fqara;
	cache_get_value_name_int(0,"backpackid",fqara);
	for(new i = 0; i < MAX_INVEN_BACKPACK; i++)
	{
		new bool:is_null;
		format(string, sizeof(string), "b_slot_%d", i);
		cache_is_value_name_null(0, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(0, string, string_json, 512);

			new JsonNode:node = JSON_INVALID_NODE;
			if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
			{
				JSON_GetInt(node, "id", BackPackInfo[playerid][backpackInvent][i]);
				JSON_GetInt(node, "quan", BackPackInfo[playerid][backpackInv][i]);
				JSON_GetInt(node, "para", BackPackInfo[playerid][backpackInvPara][i]);
				JSON_GetInt(node, "qara", BackPackInfo[playerid][backpackInvQara][i]);
				JSON_GetInt(node, "type", BackPackInfo[playerid][backpackInvType][i]);
				JSON_GetInt(node, "pack", BackPackInfo[playerid][backpackInvPack][i]);

				if(BackPackInfo[playerid][backpackInv][i] < 0) BackPackInfo[playerid][backpackInv][i] = 0;
				//new slotLol[512];
				//JSON_GetString(node, "lol", slotLol);
			}
		}
	}
	BackPackInfo[playerid][backpackLoad] = 1;
	PlayerInfo[playerid][pOdetQara][sl] = fqara;
	UpdateOdet(playerid,sl);
	return 1;
}

stock ClearPlayerBackPack(playerid)
{
	for(new inva; inva < MAX_INVEN_BACKPACK; inva++)
	{
		BackPackInfo[playerid][backpackInvent][inva] = 0;
		BackPackInfo[playerid][backpackInv][inva] = 0;
		BackPackInfo[playerid][backpackInvPara][inva] = 0;
		BackPackInfo[playerid][backpackInvQara][inva] = 0;
		BackPackInfo[playerid][backpackInvType][inva] = 0;
		BackPackInfo[playerid][backpackInvPack][inva] = 0;
	}
	return 1;
}

stock DeleteBackPack(backpackid)
{
	new string_mysql[128];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql),"DELETE FROM `backpacks` WHERE `backpackid` = '%d'", backpackid);
	query_empty(pearsq, string_mysql);
	return 1;
}

CMD:rbackpack(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 15) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу использовать эту команду");
	if(sscanf(params, "u", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Очистить инвентарь игроку [ /rbackpack ID ]");
	if(IsOnline(params[0]))
	{
		new aks = HasABustAks(params[0],1);
		if(aks == -1) return ErrorMessage(playerid,"{ff6347}На игроке нет рюкзака");
		new string[128];
		format(string, sizeof(string), " [ ADM ]: %s[%d] очистил рюкзак №%d у игрока %s[%d]", PlayerInfo[playerid][pName],playerid,PlayerInfo[params[0]][pOdetQara][aks],PlayerInfo[params[0]][pName],params[0]);
    	ABroadCast(COLOR_ADM,string,2);
		format(string, sizeof(string), "* Администратор %s очистил ваш рюкзак.", PlayerInfo[playerid][pName]);
		SendClientMessage(params[0], COLOR_LIGHTBLUE, string);
    	if(OnlineInfo[params[0]][oShowInterface] == 1) CloseFrisk(params[0]), CancelSelectTextDraw(params[0]);
		ClearPlayerBackPack(params[0]);
		for(new i = 0; i < MAX_INVEN_BACKPACK; i ++) SaveInventBackPack(params[0], i);
		AdminLog("rbackpack", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[params[0]][pID], PlayerInfo[params[0]][pName], PlayerInfo[params[0]][pPlaIP], PlayerInfo[params[0]][pOdetQara][aks], "Очистил рюкзак");
	}
	else SendClientMessage(playerid, COLOR_GRAD5, "[ Мысли ]: Его вообще нет..");
	return 1;
}

stock get_backpack(playerid) // Поиск рюкзаков в инвентаре
{
	new quan = 0;
	if(HasABustAks(playerid,1) != -1) quan++;
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] == 0) continue;
		if(PlayerInfo[playerid][pInvenType][i] != 2) continue;
		if(IsABackPack(PlayerInfo[playerid][pInven][i])) quan++;
		if(i < 20)
		{
		   if(IsABackPack(PlayerInfo[playerid][pMarkInven][i])) quan++;
		}
	}
	if(quan > MAX_BACKPACK_ON_PLAYER) return false;
	else return true;
}
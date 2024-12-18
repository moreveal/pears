stock showapartmentstable(playerid, i) // Открываем меню прикроватного столика
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || howstun(playerid)) return 1;
	if(ApartmentsRoom[i][aprOwn] != PlayerInfo[playerid][pID] && PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Открывать тумбу в квартире может только владелец");

	OnlineInfo[playerid][oShowTabs] = i;
	i_tabs(playerid, 4, 1);
	for(new inva = 0; inva < MAX_APARTMENTS_TABLE_SLOTS; inva++) item_second(playerid, ApartmentsRoom[i][aprInvent][inva], ApartmentsRoom[i][aprInv][inva], inva, 0, ApartmentsRoom[i][aprInvPara][inva], ApartmentsRoom[i][aprInvType][inva], ApartmentsRoom[i][aprInvPack][inva], 0);
	return 1;
}

stock use_Apartments_table(playerid, i, inva, useinva)
{
    i_resettabs(playerid);
	i_resetveshi(playerid);
	
	if(OnlineInfo[playerid][oShowTabs] != i) return 1;
	if(Veshi[playerid] >= 1) return 1;
	if(IsPlayerEditObject(playerid)) return ErrorMessage(playerid, "{FF6347}Нельзя перекладывать предметы во время использования редактора объектов");
 		
	if(useinva != 9999)
	{
		if(!IsAItemMatch(playerid, useinva, ApartmentsRoom[i][aprInvent][inva])) return 1;
	}
    if(IsAApartmentsTable(playerid) == -1) return ErrorMessage(playerid, "{FF6347}Вы далеко от тумбы"), closetab(playerid, 1);

	new thingId = ApartmentsRoom[i][aprInvent][inva];
    new thingQuan = ApartmentsRoom[i][aprInv][inva];
    new thingPara = ApartmentsRoom[i][aprInvPara][inva];
    new thingQara = ApartmentsRoom[i][aprInvQara][inva];
    new thingType = ApartmentsRoom[i][aprInvType][inva];
    new thingPack = ApartmentsRoom[i][aprInvPack][inva];
	
	// Забираем предмет из дома
	if(thingType == 0 && thingPack == 0)
	{
	    if(CheckThingQuan(thingId) == 1)
		{
		    DP[0][playerid] = inva;
			new string[120];
			format(string,sizeof(string),"{cccccc}Чтобы взять {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(0, thingId, thingType, thingPack));
			ShowDialog(playerid,APARTMENTS_DIALOG_TABLETAKE,DIALOG_STYLE_INPUT,"{ff9000}Тумба",string,"Принять","Отмена");
			return 1;
		}
	}
	
	// Проверка на наличие особых аксессуаров (Каска и Броня)
	if(IsArmor(thingId) && thingType == 2 && PlayerInfo[playerid][pArmor] >= 1) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет\n\n{cccccc}Учитывается надетая броня");
	
	// Проверка на одиночный предмет
	if(JustOneThingInventory(thingId, thingType) && get_invent(playerid, thingId, thingType) > 0) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров");
	
	new string[160];
	if(thingType == 0)
	{
	    if(CheckThingQuan(thingId) == 1)
		{
			new getQuan, getLimit;
    		i_limit(playerid, thingId, getQuan, getLimit);
    		if(getQuan + thingQuan > getLimit) return format(string,sizeof(string),"{FF6347}У вас нет места в инвентаре\nЛимит для этого предмета: %d\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров", getLimit), ErrorMessage(playerid, string);
 		}
	}
	
	new put_inva = GiveThingPlayer(playerid, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, useinva);
	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
    TakeApartmentsTable(i, thingId, thingQuan, thingType, inva);
	
    format(string,sizeof(string),"Взял %d: %s", i, GetNameThing(1, thingId, thingType, thingPack));
	UserLog("gApartmentsTable", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", thingQuan, string);
	return 1;
}

stock TakeApartmentsTable(i, thingId, thingQuan, thingType, dopinf)
{
	new plalit;
	if(dopinf == 999)
	{
		for(new inva = 0; inva < 80; inva++)
		{
			if(ApartmentsRoom[i][aprInvent][inva] == thingId && ApartmentsRoom[i][aprInvType][inva] == thingType)
			{
				if(ApartmentsRoom[i][aprInv][inva]-thingQuan <= 0) 
                {
                    ApartmentsRoom[i][aprInvent][inva] = 0;
                    ApartmentsRoom[i][aprInv][inva] = 0;
                    ApartmentsRoom[i][aprInvPara][inva] = 0;
                    ApartmentsRoom[i][aprInvQara][inva] = 0;
                    ApartmentsRoom[i][aprInvType][inva] = 0;
                    ApartmentsRoom[i][aprInvPack][inva] = 0;
                }
				else ApartmentsRoom[i][aprInv][inva] -= thingQuan;
				plalit = inva;
				break;
			}
		}
	}
	else
	{
		if(ApartmentsRoom[i][aprInvent][dopinf] == thingId && ApartmentsRoom[i][aprInvType][dopinf] == thingType)
		{
			if(ApartmentsRoom[i][aprInv][dopinf]-thingQuan <= 0) 
            {
                ApartmentsRoom[i][aprInvent][dopinf] = 0;
                ApartmentsRoom[i][aprInv][dopinf] = 0;
                ApartmentsRoom[i][aprInvPara][dopinf] = 0;
                ApartmentsRoom[i][aprInvQara][dopinf] = 0;
                ApartmentsRoom[i][aprInvType][dopinf] = 0;
                ApartmentsRoom[i][aprInvPack][dopinf] = 0;
            }
			else ApartmentsRoom[i][aprInv][dopinf] -= thingQuan;
		}
		plalit = dopinf;
	}
	foreach(Player,p)
	{
		if(Tabs_Load[p] != 15) continue;
		if(OnlineInfo[p][oLogged] == 1 && OnlineInfo[p][oShowInterface] == 1 && OnlineInfo[p][oShowTabs] == i) item_second(p, ApartmentsRoom[i][aprInvent][plalit], ApartmentsRoom[i][aprInv][plalit], plalit, 0, ApartmentsRoom[i][aprInvPara][plalit], ApartmentsRoom[i][aprInvType][plalit], ApartmentsRoom[i][aprInvPack][plalit], 0);
	}
	SaveOneInventApartmentsRoom(i,plalit);
	return 1;
}

stock get_ApartmentsTable(pt, thingId, thingType) // Поиск предмета в тумбе
{
	new quan = 0;
	for(new i = 0; i < MAX_APARTMENTS_TABLE_SLOTS; i++)
	{
		if(ApartmentsRoom[pt][aprInvent][i] == thingId 
            && ApartmentsRoom[pt][aprInv][i] > 0 
            && ApartmentsRoom[pt][aprInvType][i] == thingType) quan += ApartmentsRoom[pt][aprInv][i];
	}
	return quan;
}

stock put_ApartmentsTable(playerid, inva, i, thingId, thingQuan, binva, thingType, thingPack)
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || binva == 9999 || OnlineInfo[playerid][oShowTabs] == 9999
	|| PlayerInfo[playerid][pInven][inva] == 0 || PlayerInfo[playerid][pInven][inva] != thingId || PlayerInfo[playerid][pInvenQuan][inva] < thingQuan) return i_resetveshi(playerid);
	if(IsPlayerEditObject(playerid)) return ErrorMessage(playerid, "{FF6347}Нельзя перекладывать предметы во время использования редактора объектов"), i_resetveshi(playerid);
	
	if(IsAApartmentsTable(playerid) == -1) return ErrorMessage(playerid, "{FF6347}Вы далеко от тумбы"), closetab(playerid, 1);
	
	if(NotGiveInflatabelBoat(playerid, thingId, thingType)) return i_resetveshi(playerid);
	if(NotGiveThing(thingId, thingType, PlayerInfo[playerid][pInvenQuan][inva], thingPack)) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя передавать, продавать или убирать"), i_resetveshi(playerid);
	
    // Кейс нельзя выбрасывать на 3 уровне и ниже
	if(IsNotGiveCase(playerid, thingPack)) return i_resetveshi(playerid);

	new string[100];
	new quanThing;
	if(thingType == 0)
	{
		if(CheckThingQuan(thingId) == 1)
		{
		    if(ApartmentsRoom[i][aprInvent][binva] != 0 && ApartmentsRoom[i][aprInvent][binva] != PlayerInfo[playerid][pInven][inva]) return ErrorMessage(playerid, "{FF6347}Эта ячейка занята"), i_resetveshi(playerid);
		    if(thingPack == 0) quanThing = 1;
		    if(PlayerInfo[playerid][pInvenQuan][inva] < thingQuan) return ErrorMessage(playerid, "{FF6347}У вас нет такого количества в этой ячейке"), i_resetveshi(playerid);
		    new getQuan, getLimit;
		    apartments_limit(i, thingId, getQuan, getLimit);
		    if(getQuan+thingQuan > getLimit)
		    {
		        format(string,sizeof(string),"{FF6347}В тумбе нет места\n\nЛимит для этого предмета: %d", getLimit);
		        ErrorMessage(playerid, string);
				i_resetveshi(playerid);
				i_resettabs(playerid);
				return 1;
		    }
		}
	}
	if(ApartmentsRoom[i][aprInvent][binva] > 0 && quanThing == 0) return ErrorMessage(playerid, "{FF6347}Эта ячейка занята"), i_resetveshi(playerid);
	
	new put_inva = put_thing_Apartmentstable(i, thingId, thingQuan, PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenQara][inva], thingType, thingPack, binva);
	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}В квартире нет места"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
	
	if(quanThing == 1) take_away(playerid, thingQuan, inva); // Отнимаем предмет (по количеству)
 	else i_del(playerid, inva); // Отнимаем предмет (целиком)
	
    format(string,sizeof(string),"Положил %d: %s", i, GetNameThing(1, thingId, thingType, thingPack));
	UserLog("atable", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", thingQuan, string);
	
	i_resetveshi(playerid);
	i_resettabs(playerid);
	return put_inva;
}
stock PutThingApartmentsTable(pt, playerid, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, useinva) // Кладём предмет в тумбу
{
    new inva = -1;
	if(thingId == 0) return inva; // Малоли где то ошибка может быть (0 - не пропускаем выдачу предмета)
	if(useinva == 999) // Не знаем в какую ячейку класть
	{
	    if(thingType == 0 && thingPack == 0) // Обычный предмет
		{
		    if(CheckThingQuan(thingId) == 1) // Предмет имеет количество (Складывается в одну ячейку)
		    {
		        new find;
		    	for(new i = 0; i < MAX_PRISON_TABLE_SLOTS; i++)
				{
					if(ApartmentsRoom[pt][aprInvent][i] == thingId && ApartmentsRoom[pt][aprInvType][i] == thingType && ApartmentsRoom[pt][aprInvPack][i] == thingPack) // Ищем тот, где уже предмет лежит
					{
					    inva = i;
		  				put_thing_Apartmentstable(pt, thingId, thingQuan, thingPara, 0, thingType, thingPack, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
		  				find = 1;
			   			break;
					}
				}
				if(find == 0) // Если не нашли, ищем пустую
				{
					for(new i = 0; i < MAX_PRISON_TABLE_SLOTS; i++)
					{
						if(ApartmentsRoom[pt][aprInvent][i] == 0) // Ищем пустую ячейку
						{
						    inva = i;
			  				put_thing_Apartmentstable(pt, thingId, thingQuan, thingPara, 0, thingType, thingPack, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
				   			break;
						}
					}
				}
			}
			else if(CheckThingQuan(thingId) == 0) // Объект не имеет количество
			{
			    for(new i = 0; i < MAX_PRISON_TABLE_SLOTS; i++)
				{
					if(ApartmentsRoom[pt][aprInvent][i] == 0) // Ищем пустую ячейку
					{
					    inva = i;
		  				put_thing_Apartmentstable(pt, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, i);
			   			break;
					}
				}
			}
		}
		else // Все остальные предметы не имеют количества или возможности складываться в одну ячейку
		{
		    for(new i = 0; i < MAX_PRISON_TABLE_SLOTS; i++)
			{
				if(ApartmentsRoom[pt][aprInvent][i] == 0) // Ищем пустую ячейку
				{
				    inva = i;
	  				put_thing_Apartmentstable(pt, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, i);
		   			break;
				}
			}
		}
	}
	else inva = put_thing_Apartmentstable(pt, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, useinva); // Знаем в какую ячейку класть
	return inva;
}

stock put_thing_Apartmentstable(pt, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, i)
{
	if(ApartmentsRoom[pt][aprInvent][i] != 0 && ApartmentsRoom[pt][aprInvent][i] != thingId) return -1; // Защита от ошибки, на всякий случай

	ApartmentsRoom[pt][aprInvent][i] = thingId; // Ставим предмет в слот
	ApartmentsRoom[pt][aprInv][i] += thingQuan; // Ставим количество в слот

	// (Техника сломана или нет, Одежда какой организации принадлежит, Unix время свежести продуктов, Изношенность оружия, Прнадлежность лицензии к ID игрока, Тип крепления аксессуара)
	if(PerishableThing(thingId, thingType)) // Проверка на портящиеся продукты - у них используется Unix (Добавляя испорченный продукт к свежему, портиться должно всё)
	{
	    if(ApartmentsRoom[pt][aprInvPara][i] > 0)
		{
			if(ApartmentsRoom[pt][aprInvPara][i] > thingPara) ApartmentsRoom[pt][aprInvPara][i] = thingPara;
		}
		else ApartmentsRoom[pt][aprInvPara][i] = thingPara;
	}
	else ApartmentsRoom[pt][aprInvPara][i] = thingPara;
	ApartmentsRoom[pt][aprInvQara][i] = thingQara; // Статус краденного предмета
	ApartmentsRoom[pt][aprInvType][i] = thingType; // Тип предмета
	ApartmentsRoom[pt][aprInvPack][i] = thingPack; // Упаковка предмета
	
	foreach(Player,x)
	{
		if(Tabs_Load[x] != 15) continue;
		if(OnlineInfo[x][oLogged] == 1 && OnlineInfo[x][oShowInterface] == 1 && OnlineInfo[x][oShowTabs] == pt) item_second(x, thingId, ApartmentsRoom[pt][aprInv][i], i, 0, ApartmentsRoom[pt][aprInvPara][i], thingType, thingPack, 0);
	}
	SaveOneInventApartmentsRoom(pt,i);
	return i;
}

stock shift_ApartmentsTable(playerid, pt, getinva, putinva) //  Перемещение предметов внутри инвентаря (с одной ячейки на другую)
{
	if(OnlineInfo[playerid][oShowTabs] != 9999)
	{
		if(ApartmentsRoom[pt][aprInvent][getinva] == 0) return i_resettabs(playerid);
		else if(ApartmentsRoom[pt][aprInvent][putinva] != 0) return 1;

        new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 15) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			new string[80];
			format(string, sizeof(string), "{FF6347}Тумбу просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, string);
			i_resettabs(playerid);
			return 1;
		}
		ApartmentsRoom[pt][aprInvent][putinva] = ApartmentsRoom[pt][aprInvent][getinva];
		ApartmentsRoom[pt][aprInv][putinva] = ApartmentsRoom[pt][aprInv][getinva];
		ApartmentsRoom[pt][aprInvPara][putinva] = ApartmentsRoom[pt][aprInvPara][getinva];
		ApartmentsRoom[pt][aprInvQara][putinva] = ApartmentsRoom[pt][aprInvQara][getinva];
		ApartmentsRoom[pt][aprInvType][putinva] = ApartmentsRoom[pt][aprInvType][getinva];
		ApartmentsRoom[pt][aprInvPack][putinva] = ApartmentsRoom[pt][aprInvPack][getinva];
		ApartmentsRoom[pt][aprInvent][getinva] = 0;
		ApartmentsRoom[pt][aprInv][getinva] = 0;
		ApartmentsRoom[pt][aprInvPara][getinva] = 0;
		ApartmentsRoom[pt][aprInvQara][getinva] = 0;
		ApartmentsRoom[pt][aprInvType][getinva] = 0;
		ApartmentsRoom[pt][aprInvPack][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, 0, 0, getinva, 0, 0, 0, 0, 0);
		item_second(playerid, ApartmentsRoom[pt][aprInvent][putinva], ApartmentsRoom[pt][aprInv][putinva], putinva, 0, ApartmentsRoom[pt][aprInvPara][putinva], ApartmentsRoom[pt][aprInvType][putinva], ApartmentsRoom[pt][aprInvPack][putinva], 0);
		mysql_tquery(pearsq, "START TRANSACTION;");
		SaveOneInventApartmentsRoom(pt,getinva);
		SaveOneInventApartmentsRoom(pt,putinva);
		mysql_tquery(pearsq, "COMMIT;");
	}
	return 1;
}

stock mix_ApartmentsTable(playerid, pt, getinva, putinva)
{
	if(OnlineInfo[playerid][oShowTabs] != 9999)
	{
		if(ApartmentsRoom[pt][aprInvent][getinva] == 0) return i_resettabs(playerid);
		if(ApartmentsRoom[pt][aprInvent][putinva] != ApartmentsRoom[pt][aprInvent][getinva]) return i_resettabs(playerid);

		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 15) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			new string[80];
			format(string, sizeof(string), "{FF6347}Тумбу просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, string);
			i_resettabs(playerid);
			return 1;
		}
		ApartmentsRoom[pt][aprInv][putinva] += ApartmentsRoom[pt][aprInv][getinva];
		if(ApartmentsRoom[pt][aprInvPara][putinva] > ApartmentsRoom[pt][aprInvPara][getinva]) ApartmentsRoom[pt][aprInvPara][putinva] = ApartmentsRoom[pt][aprInvPara][getinva];
		ApartmentsRoom[pt][aprInvQara][putinva] = ApartmentsRoom[pt][aprInvQara][getinva];
		ApartmentsRoom[pt][aprInvType][putinva] = ApartmentsRoom[pt][aprInvType][getinva];
		ApartmentsRoom[pt][aprInvPack][putinva] = ApartmentsRoom[pt][aprInvPack][getinva];
		ApartmentsRoom[pt][aprInvent][getinva] = 0;
		ApartmentsRoom[pt][aprInv][getinva] = 0;
		ApartmentsRoom[pt][aprInvPara][getinva] = 0;
		ApartmentsRoom[pt][aprInvQara][getinva] = 0;
		ApartmentsRoom[pt][aprInvType][getinva] = 0;
		ApartmentsRoom[pt][aprInvPack][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, ApartmentsRoom[pt][aprInvent][getinva], ApartmentsRoom[pt][aprInvent][getinva], getinva, 0, ApartmentsRoom[pt][aprInvPara][getinva], ApartmentsRoom[pt][aprInvType][getinva], ApartmentsRoom[pt][aprInvPack][getinva], 0);
		item_second(playerid, ApartmentsRoom[pt][aprInvent][putinva], ApartmentsRoom[pt][aprInv][putinva], putinva, 0, ApartmentsRoom[pt][aprInvPara][putinva], ApartmentsRoom[pt][aprInvType][putinva], ApartmentsRoom[pt][aprInvPack][putinva], 0);
		mysql_tquery(pearsq, "START TRANSACTION;");
		SaveOneInventApartmentsRoom(pt,getinva);
		SaveOneInventApartmentsRoom(pt,putinva);
		mysql_tquery(pearsq, "COMMIT;");
	}
	return 1;
}

stock IsAApartmentsTable(playerid)
{
	new result = GetPlayerApartmentsId(playerid);
    if(result == -1) return -1;
	new roomID = GetPlayerApartmentsRoom(playerid,result);
	if(Apartments[result][apClass] == 0)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.0,600.5263,-1374.9799,48.0580)) return roomID;
		else if(IsPlayerInRangeOfPoint(playerid,1.0,592.7370,-1376.9614,48.0440)) return roomID;
		else if(IsPlayerInRangeOfPoint(playerid,1.0,570.6313,-1376.5552,48.0580)) return roomID;
		else if(IsPlayerInRangeOfPoint(playerid,1.0,555.9232,-1383.6599,48.0520)) return roomID;
	}
	else if(Apartments[result][apClass] == 1)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.0, 1503.5256, 1378.5081, 10.9010)) return roomID;
		else if(IsPlayerInRangeOfPoint(playerid,1.0,1494.6069,1268.5408,10.8507)) return roomID;
	}
	else if(Apartments[result][apClass] == 2)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.0, 1503.5256, 1378.5081, 10.9010)) return roomID;
	}
    return -1;
}



stock SaveOneInventApartmentsRoom(idx, inva) // Сохраняем одну ячейку шкафа квартиры
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;

	if(ApartmentsRoom[idx][aprInvent][inva] == 0)
	{
		new string_mysql[140];
		mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `apartmentsRoom` SET `apr_slot%d`= NULL WHERE `aprID` = '%d'", inva, idx);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new JsonNode:node = JSON_Object(
			"id", JSON_Int(ApartmentsRoom[idx][aprInvent][inva]),
			"quan", JSON_Int(ApartmentsRoom[idx][aprInv][inva]),
			"para", JSON_Int(ApartmentsRoom[idx][aprInvPara][inva]),
			"qara", JSON_Int(ApartmentsRoom[idx][aprInvQara][inva]),
			"type", JSON_Int(ApartmentsRoom[idx][aprInvType][inva]),
			"pack", JSON_Int(ApartmentsRoom[idx][aprInvPack][inva])
		);

		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `apartmentsRoom` SET `apr_slot%d`= '%e' WHERE `aprID` = '%d'", inva, string_json, idx);
			mysql_tquery(pearsq, string_mysql);
		}
	}
	return 1;
}

stock OnLoadInventApartmentsRoom(idx)
{
	for(new i = 0; i < 20; i++)
	{
		new string[20], bool:is_null;
		format(string, sizeof(string), "apr_slot%d", i);
		cache_is_value_name_null(idx, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(idx, string, string_json, 512);

			new JsonNode:node = JSON_INVALID_NODE;
			if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
			{
				JSON_GetInt(node, "id",ApartmentsRoom[idx][aprInvent][i]);
				JSON_GetInt(node, "quan",ApartmentsRoom[idx][aprInv][i]);
				JSON_GetInt(node, "para",ApartmentsRoom[idx][aprInvPara][i]);
				JSON_GetInt(node, "qara",ApartmentsRoom[idx][aprInvQara][i]);
				JSON_GetInt(node, "type",ApartmentsRoom[idx][aprInvType][i]);
				JSON_GetInt(node, "pack",ApartmentsRoom[idx][aprInvPack][i]);
			}
		}
	}
	return 1;
}
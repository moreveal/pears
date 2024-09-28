#define MAX_FRIDGE_SLOTS 20 // кол.во слотов в холодосе
#define MAX_FRIDGE 3600 // НУЖНО ПОСЧИТАТЬ ГДЕ ХОЛОДОСЫ БУДУТ. В ДАННЫЙ МОМЕНТ В: Дома, Квартиры, Трейлеры
enum fridgeEnum
{
    fridgeInvent[MAX_FRIDGE_SLOTS],
	fridgeInv[MAX_FRIDGE_SLOTS],
	fridgeInvPara[MAX_FRIDGE_SLOTS],
	fridgeInvQara[MAX_FRIDGE_SLOTS],
	fridgeInvType[MAX_FRIDGE_SLOTS],
	fridgeInvPack[MAX_FRIDGE_SLOTS]
}
new Refrigerator[MAX_FRIDGE][fridgeEnum];

stock showRefrigerator(playerid, i) // Открываем меню прикроватного столика
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || howstun(playerid)) return 1;
    if(i >= 1 && i <= 1000)
    {
		if(DomInfo[i][dElectroConnect] == 0) return ErrorMessage(playerid, "{FF6347}Дом не подключен к электростанции");
        if(PlayerInfo[playerid][pDom] != i)
		{
			if(DomInfo[i][dAcccupO] == 0) return ErrorMessage(playerid, "{FF6347}Открывать холодильник в этом доме может только владелец");
			if(DomInfo[i][dAcccupO] == 1 && PlayerInfo[playerid][pHouserent] != i) return ErrorMessage(playerid, "{FF6347}Открывать холодильник в этом доме может только владелец и проживающие");
			if(DomInfo[i][dAcccupO] == 2 && (DomInfo[i][dFam] == 0 || DomInfo[i][dFam] >= 1 && PlayerInfo[playerid][pFamily] != DomInfo[i][dFam])) return ErrorMessage(playerid, "{FF6347}Открывать холодильник в этом доме может только владелец и семья");
			if(DomInfo[i][dAcccupO] == 3 && (DomInfo[i][dFam] == 0 || DomInfo[i][dFam] >= 1 && PlayerInfo[playerid][pFamily] != DomInfo[i][dFam]) && PlayerInfo[playerid][pHouserent] != i) return ErrorMessage(playerid, "{FF6347}Открывать холодильник в этом доме может только владелец, проживающие и семья");
		}
    }
    else if(i >= 1001 && i <= 1999)
    {
        if(TrailerInfo[i-1000][tOwnerID] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid, "{FF6347}Открывать холодильник в трейлере может только владелец");
    }
    else if(i >= 2000 && i <= 3600)
    {
        if(ApartmentsRoom[i-2000][aprOwn] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid, "{FF6347}Открывать холодильник в квартире может только владелец");
    }
	OnlineInfo[playerid][oShowTabs] = i-1;
	i_tabs(playerid, 4, 1);
	for(new inva = 0; inva < MAX_FRIDGE_SLOTS; inva++) item_second(playerid, Refrigerator[i-1][fridgeInvent][inva], Refrigerator[i-1][fridgeInv][inva], inva, 0, Refrigerator[i-1][fridgeInvPara][inva], Refrigerator[i-1][fridgeInvType][inva], Refrigerator[i-1][fridgeInvPack][inva], 0);
	return 1;
}

stock use_Refrigerator(playerid, i, inva, useinva)
{
    i_resettabs(playerid);
	i_resetveshi(playerid);
	
	if(OnlineInfo[playerid][oShowTabs] != i) return 1;
	if(Veshi[playerid] >= 1) return 1;
	if(IsPlayerEditObject(playerid)) return ErrorMessage(playerid, "{FF6347}Нельзя перекладывать предметы во время использования редактора объектов");
 		
	if(useinva != 9999)
	{
 		if(PlayerInfo[playerid][pInven][useinva] != Refrigerator[i][fridgeInvent][inva] && PlayerInfo[playerid][pInven][useinva] != 0) return 1;
	}
    if(GetPlayerRefrigerator(playerid) == -1) return ErrorMessage(playerid, "{FF6347}Вы далеко от холодильника"), closetab(playerid, 1);

	new thingId = Refrigerator[i][fridgeInvent][inva];
    new thingQuan = Refrigerator[i][fridgeInv][inva];
    new thingPara = Refrigerator[i][fridgeInvPara][inva];
    new thingQara = Refrigerator[i][fridgeInvQara][inva];
    new thingType = Refrigerator[i][fridgeInvType][inva];
    new thingPack = Refrigerator[i][fridgeInvPack][inva];
	
	// Забираем предмет из холодоса
	if(thingType == 0 && thingPack == 0)
	{
	    if(CheckThingQuan(thingId) == 1)
		{
		    DP[0][playerid] = inva;
			new string[120];
			format(string,sizeof(string),"{cccccc}Чтобы взять {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(0, thingId, thingType, thingPack));
			ShowDialog(playerid,FRIDGE_DIALOG_TAKE,DIALOG_STYLE_INPUT,"{ff9000}Холодильник",string,"Принять","Отмена");
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
	
	new put_inva = GiveThingPlayer(playerid, thingId, thingQuan, gettime() + thingPara, thingQara, thingType, thingPack, useinva);
	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
    TakeRefrigerator(i, thingId, thingQuan, thingType, inva);
	
    format(string,sizeof(string),"Взял %d: %s", i, GetNameThing(1, thingId, thingType, thingPack));
	UserLog("takeFridge", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", thingQuan, string);
	return 1;
}

stock TakeRefrigerator(i, thingId, thingQuan, thingType, dopinf)
{
	new plalit;
	if(dopinf == 999)
	{
		for(new inva = 0; inva < 80; inva++)
		{
			if(Refrigerator[i][fridgeInvent][inva] == thingId && Refrigerator[i][fridgeInvType][inva] == thingType)
			{
				if(Refrigerator[i][fridgeInv][inva]-thingQuan <= 0) 
                {
                    Refrigerator[i][fridgeInvent][inva] = 0;
                    Refrigerator[i][fridgeInv][inva] = 0;
                    Refrigerator[i][fridgeInvPara][inva] = 0;
                    Refrigerator[i][fridgeInvQara][inva] = 0;
                    Refrigerator[i][fridgeInvType][inva] = 0;
                    Refrigerator[i][fridgeInvPack][inva] = 0;
                }
				else Refrigerator[i][fridgeInv][inva] -= thingQuan;
				plalit = inva;
				break;
			}
		}
	}
	else
	{
		if(Refrigerator[i][fridgeInvent][dopinf] == thingId && Refrigerator[i][fridgeInvType][dopinf] == thingType)
		{
			if(Refrigerator[i][fridgeInv][dopinf]-thingQuan <= 0) 
            {
                Refrigerator[i][fridgeInvent][dopinf] = 0;
                Refrigerator[i][fridgeInv][dopinf] = 0;
                Refrigerator[i][fridgeInvPara][dopinf] = 0;
                Refrigerator[i][fridgeInvQara][dopinf] = 0;
                Refrigerator[i][fridgeInvType][dopinf] = 0;
                Refrigerator[i][fridgeInvPack][dopinf] = 0;
            }
			else Refrigerator[i][fridgeInv][dopinf] -= thingQuan;
		}
		plalit = dopinf;
	}
	foreach(Player,p)
	{
		if(Tabs_Load[p] != 16) continue;
		if(OnlineInfo[p][oLogged] == 1 && OnlineInfo[p][oShowInterface] == 1 && OnlineInfo[p][oShowTabs] == i) item_second(p, Refrigerator[i][fridgeInvent][plalit], Refrigerator[i][fridgeInv][plalit], plalit, 0, Refrigerator[i][fridgeInvPara][plalit], Refrigerator[i][fridgeInvType][plalit], Refrigerator[i][fridgeInvPack][plalit], 0);
	}
	SaveOneInventRefrigerator(i,plalit);
	return 1;
}

stock get_Refrigerator(pt, thingId, thingType) // Поиск предмета в холодосе
{
	new quan = 0;
	for(new i = 0; i < MAX_FRIDGE_SLOTS; i++)
	{
		if(Refrigerator[pt][fridgeInvent][i] == thingId 
            && Refrigerator[pt][fridgeInv][i] > 0 
            && Refrigerator[pt][fridgeInvType][i] == thingType) quan += Refrigerator[pt][fridgeInv][i];
	}
	return quan;
}

stock put_Refrigerator(playerid, inva, i, thingId, thingQuan, binva, thingType, thingPack)
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || binva == 9999 || OnlineInfo[playerid][oShowTabs] == 9999
	|| PlayerInfo[playerid][pInven][inva] == 0 || PlayerInfo[playerid][pInven][inva] != thingId || PlayerInfo[playerid][pInvenQuan][inva] < thingQuan) return i_resetveshi(playerid);
	if(IsPlayerEditObject(playerid)) return ErrorMessage(playerid, "{FF6347}Нельзя перекладывать предметы во время использования редактора объектов"), i_resetveshi(playerid);
	
	if(GetPlayerRefrigerator(playerid) == -1) return ErrorMessage(playerid, "{FF6347}Вы далеко от холодильника"), closetab(playerid, 1);
	
	if(NotGiveInflatabelBoat(playerid, thingId, thingType)) return i_resetveshi(playerid);
	if(!PerishableThing(thingId, thingType)) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя положить в холодильник"), i_resetveshi(playerid);


	new string[100];
	new quanThing;
	if(thingType == 0)
	{
		if(CheckThingQuan(thingId) == 1)
		{
		    if(Refrigerator[i][fridgeInvent][binva] != 0 && Refrigerator[i][fridgeInvent][binva] != PlayerInfo[playerid][pInven][inva]) return ErrorMessage(playerid, "{FF6347}Эта ячейка занята"), i_resetveshi(playerid);
		    if(thingPack == 0) quanThing = 1;
		    if(PlayerInfo[playerid][pInvenQuan][inva] < thingQuan) return ErrorMessage(playerid, "{FF6347}У вас нет такого количества в этой ячейке"), i_resetveshi(playerid);
		    new getQuan, getLimit;
		    Refrigerator_limit(i, thingId, getQuan, getLimit);
		    if(getQuan+thingQuan > getLimit)
		    {
		        format(string,sizeof(string),"{FF6347}В холодильнике нет места\n\nЛимит для этого предмета: %d", getLimit);
		        ErrorMessage(playerid, string);
				i_resetveshi(playerid);
				i_resettabs(playerid);
				return 1;
		    }
		}
	}
	if(Refrigerator[i][fridgeInvent][binva] > 0 && quanThing == 0) return ErrorMessage(playerid, "{FF6347}Эта ячейка занята"), i_resetveshi(playerid);
	
	new put_inva = put_thing_Refrigerator(i, thingId, thingQuan, PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenQara][inva], thingType, thingPack, binva);
	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}В холодильнике нет места"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
	
	if(quanThing == 1) take_away(playerid, thingQuan, inva); // Отнимаем предмет (по количеству)
 	else i_del(playerid, inva); // Отнимаем предмет (целиком)
	
    format(string,sizeof(string),"Положил %d: %s", i, GetNameThing(1, thingId, thingType, thingPack));
	UserLog("aRefrigerator", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", thingQuan, string);
	
	i_resetveshi(playerid);
	i_resettabs(playerid);
	return put_inva;
}
stock PutThingRefrigerator(pt, playerid, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, useinva) // Кладём предмет в холодильник
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
					if(Refrigerator[pt][fridgeInvent][i] == thingId && Refrigerator[pt][fridgeInvType][i] == thingType && Refrigerator[pt][fridgeInvPack][i] == thingPack) // Ищем тот, где уже предмет лежит
					{
					    inva = i;
		  				put_thing_Refrigerator(pt, thingId, thingQuan, thingPara, 0, thingType, thingPack, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
		  				find = 1;
			   			break;
					}
				}
				if(find == 0) // Если не нашли, ищем пустую
				{
					for(new i = 0; i < MAX_PRISON_TABLE_SLOTS; i++)
					{
						if(Refrigerator[pt][fridgeInvent][i] == 0) // Ищем пустую ячейку
						{
						    inva = i;
			  				put_thing_Refrigerator(pt, thingId, thingQuan, thingPara, 0, thingType, thingPack, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
				   			break;
						}
					}
				}
			}
			else if(CheckThingQuan(thingId) == 0) // Объект не имеет количество
			{
			    for(new i = 0; i < MAX_PRISON_TABLE_SLOTS; i++)
				{
					if(Refrigerator[pt][fridgeInvent][i] == 0) // Ищем пустую ячейку
					{
					    inva = i;
		  				put_thing_Refrigerator(pt, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, i);
			   			break;
					}
				}
			}
		}
		else // Все остальные предметы не имеют количества или возможности складываться в одну ячейку
		{
		    for(new i = 0; i < MAX_PRISON_TABLE_SLOTS; i++)
			{
				if(Refrigerator[pt][fridgeInvent][i] == 0) // Ищем пустую ячейку
				{
				    inva = i;
	  				put_thing_Refrigerator(pt, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, i);
		   			break;
				}
			}
		}
	}
	else inva = put_thing_Refrigerator(pt, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, useinva); // Знаем в какую ячейку класть
	return inva;
}

stock put_thing_Refrigerator(pt, thingId, thingQuan, thingPara, thingQara, thingType, thingPack, i)
{
	if(Refrigerator[pt][fridgeInvent][i] != 0 && Refrigerator[pt][fridgeInvent][i] != thingId) return -1; // Защита от ошибки, на всякий случай

	Refrigerator[pt][fridgeInvent][i] = thingId; // Ставим предмет в слот
	Refrigerator[pt][fridgeInv][i] += thingQuan; // Ставим количество в слот

	// (Техника сломана или нет, Одежда какой организации принадлежит, Unix время свежести продуктов, Изношенность оружия, Прнадлежность лицензии к ID игрока, Тип крепления аксессуара)
	if(PerishableThing(thingId, thingType)) // Проверка на портящиеся продукты - у них используется Unix (Добавляя испорченный продукт к свежему, портиться должно всё)
	{
	    if(Refrigerator[pt][fridgeInvPara][i] > 0)
		{
			if(Refrigerator[pt][fridgeInvPara][i] > thingPara) Refrigerator[pt][fridgeInvPara][i] = thingPara - gettime();
		}
		else Refrigerator[pt][fridgeInvPara][i] = thingPara - gettime();
	}
	else Refrigerator[pt][fridgeInvPara][i] = thingPara;
	Refrigerator[pt][fridgeInvQara][i] = thingQara; // Статус краденного предмета
	Refrigerator[pt][fridgeInvType][i] = thingType; // Тип предмета
	Refrigerator[pt][fridgeInvPack][i] = thingPack; // Упаковка предмета
	
	foreach(Player,x)
	{
		if(Tabs_Load[x] != 16) continue;
		if(OnlineInfo[x][oLogged] == 1 && OnlineInfo[x][oShowInterface] == 1 && OnlineInfo[x][oShowTabs] == pt) item_second(x, thingId, Refrigerator[pt][fridgeInv][i], i, 0, Refrigerator[pt][fridgeInvPara][i], thingType, thingPack, 0);
	}
	SaveOneInventRefrigerator(pt,i);
	return i;
}

stock shift_Refrigerator(playerid, pt, getinva, putinva) //  Перемещение предметов внутри инвентаря (с одной ячейки на другую)
{
	if(OnlineInfo[playerid][oShowTabs] != 9999)
	{
		if(Refrigerator[pt][fridgeInvent][getinva] == 0) return i_resettabs(playerid);
		else if(Refrigerator[pt][fridgeInvent][putinva] != 0) return 1;

        new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 16) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			new string[80];
			format(string, sizeof(string), "{FF6347}Холодильник просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, string);
			i_resettabs(playerid);
			return 1;
		}
		Refrigerator[pt][fridgeInvent][putinva] = Refrigerator[pt][fridgeInvent][getinva];
		Refrigerator[pt][fridgeInv][putinva] = Refrigerator[pt][fridgeInv][getinva];
		Refrigerator[pt][fridgeInvPara][putinva] = Refrigerator[pt][fridgeInvPara][getinva];
		Refrigerator[pt][fridgeInvQara][putinva] = Refrigerator[pt][fridgeInvQara][getinva];
		Refrigerator[pt][fridgeInvType][putinva] = Refrigerator[pt][fridgeInvType][getinva];
		Refrigerator[pt][fridgeInvPack][putinva] = Refrigerator[pt][fridgeInvPack][getinva];
		Refrigerator[pt][fridgeInvent][getinva] = 0;
		Refrigerator[pt][fridgeInv][getinva] = 0;
		Refrigerator[pt][fridgeInvPara][getinva] = 0;
		Refrigerator[pt][fridgeInvQara][getinva] = 0;
		Refrigerator[pt][fridgeInvType][getinva] = 0;
		Refrigerator[pt][fridgeInvPack][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, 0, 0, getinva, 0, 0, 0, 0, 0);
		item_second(playerid, Refrigerator[pt][fridgeInvent][putinva], Refrigerator[pt][fridgeInv][putinva], putinva, 0, Refrigerator[pt][fridgeInvPara][putinva], Refrigerator[pt][fridgeInvType][putinva], Refrigerator[pt][fridgeInvPack][putinva], 0);
		mysql_tquery(pearsq, "START TRANSACTION;");
		SaveOneInventRefrigerator(pt,getinva);
		SaveOneInventRefrigerator(pt,putinva);
		mysql_tquery(pearsq, "COMMIT;");
	}
	return 1;
}

stock mix_Refrigerator(playerid, pt, getinva, putinva)
{
	if(OnlineInfo[playerid][oShowTabs] != 9999)
	{
		if(Refrigerator[pt][fridgeInvent][getinva] == 0) return i_resettabs(playerid);
		if(Refrigerator[pt][fridgeInvent][putinva] != Refrigerator[pt][fridgeInvent][getinva]) return i_resettabs(playerid);

		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 16) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			new string[80];
			format(string, sizeof(string), "{FF6347}Холодильник просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, string);
			i_resettabs(playerid);
			return 1;
		}
		Refrigerator[pt][fridgeInv][putinva] += Refrigerator[pt][fridgeInv][getinva];
		if(Refrigerator[pt][fridgeInvPara][putinva] > Refrigerator[pt][fridgeInvPara][getinva]) Refrigerator[pt][fridgeInvPara][putinva] = Refrigerator[pt][fridgeInvPara][getinva];
		Refrigerator[pt][fridgeInvQara][putinva] = Refrigerator[pt][fridgeInvQara][getinva];
		Refrigerator[pt][fridgeInvType][putinva] = Refrigerator[pt][fridgeInvType][getinva];
		Refrigerator[pt][fridgeInvPack][putinva] = Refrigerator[pt][fridgeInvPack][getinva];
		Refrigerator[pt][fridgeInvent][getinva] = 0;
		Refrigerator[pt][fridgeInv][getinva] = 0;
		Refrigerator[pt][fridgeInvPara][getinva] = 0;
		Refrigerator[pt][fridgeInvQara][getinva] = 0;
		Refrigerator[pt][fridgeInvType][getinva] = 0;
		Refrigerator[pt][fridgeInvPack][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, Refrigerator[pt][fridgeInvent][getinva], Refrigerator[pt][fridgeInvent][getinva], getinva, 0, Refrigerator[pt][fridgeInvPara][getinva], Refrigerator[pt][fridgeInvType][getinva], Refrigerator[pt][fridgeInvPack][getinva], 0);
		item_second(playerid, Refrigerator[pt][fridgeInvent][putinva], Refrigerator[pt][fridgeInv][putinva], putinva, 0, Refrigerator[pt][fridgeInvPara][putinva], Refrigerator[pt][fridgeInvType][putinva], Refrigerator[pt][fridgeInvPack][putinva], 0);
		mysql_tquery(pearsq, "START TRANSACTION;");
		SaveOneInventRefrigerator(pt,getinva);
		SaveOneInventRefrigerator(pt,putinva);
		mysql_tquery(pearsq, "COMMIT;");
	}
	return 1;
}



stock SaveOneInventRefrigerator(idx, inva) // Сохраняем одну ячейку холодильника
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;

	if(Refrigerator[idx][fridgeInvent][inva] == 0)
	{
		new string_mysql[140];
		mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `Refrigerator` SET `rf_slot%d`= NULL WHERE `id` = '%d'", inva, idx);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new JsonNode:node = JSON_Object(
			"id", JSON_Int(Refrigerator[idx][fridgeInvent][inva]),
			"quan", JSON_Int(Refrigerator[idx][fridgeInv][inva]),
			"para", JSON_Int(Refrigerator[idx][fridgeInvPara][inva]),
			"qara", JSON_Int(Refrigerator[idx][fridgeInvQara][inva]),
			"type", JSON_Int(Refrigerator[idx][fridgeInvType][inva]),
			"pack", JSON_Int(Refrigerator[idx][fridgeInvPack][inva])
		);

		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `Refrigerator` SET `rf_slot%d`= '%e' WHERE `id` = '%d'", inva, string_json, idx);
			mysql_tquery(pearsq, string_mysql);
		}
	}
	return 1;
}

stock OnLoadInventRefrigerator(idx)
{
	for(new i = 0; i < 20; i++)
	{
		new string[20], bool:is_null;
		format(string, sizeof(string), "rf_slot%d", i);
		cache_is_value_name_null(idx, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(idx, string, string_json, 512);
		
			new JsonNode:node = JSON_INVALID_NODE;
			if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
			{
				JSON_GetInt(node, "id",Refrigerator[idx][fridgeInvent][i]);
				JSON_GetInt(node, "quan",Refrigerator[idx][fridgeInv][i]);
				JSON_GetInt(node, "para",Refrigerator[idx][fridgeInvPara][i]);
				JSON_GetInt(node, "qara",Refrigerator[idx][fridgeInvQara][i]);
				JSON_GetInt(node, "type",Refrigerator[idx][fridgeInvType][i]);
				JSON_GetInt(node, "pack",Refrigerator[idx][fridgeInvPack][i]);
			}
		}
	}
	return 1;
}

/* В дальнейшем, при добавление ДОМОВ или ТРЕЙЛЕРОВ, нам нужно будет зайти в базу и сместить уже имеющие
строки на N - добавленных домов/трейлеров.
А в системе ниже добавить дополнительно кол.во. Домов в данный момент 1000, с них идет отсчет
Трейлеров 1000, Квартир 1600
*/
stock GetPlayerRefrigerator(playerid)
{
	new world = GetPlayerVirtualWorld(playerid),result = -1;
    if(world > 1000 && world <= 2000) // Дома
    {
        result = world - 1000;
    }
    else if(world >= 5000 && world <= 5999) // Трейлеры
    {
        result = world - 4000;
    }
    else if(world > 15000 && world <= 16600) // Квартиры
    {
        result = 2000 + GetPlayerApartmentsRoom(playerid,GetPlayerApartmentsId(playerid));
    }
    if(result == -1) return -1;
    return result;
}

CMD:firstloadfridge(playerid)
{
    if(PlayerInfo[playerid][pSoska] >= 23 && (strfind(PlayerInfo[playerid][pName],"Elon_Musk",true) != (-1) || strfind(PlayerInfo[playerid][pName],"Cardinale_Reveal",true) != (-1)) )
	{
        for(new i = 1; i < MAX_FRIDGE;i++)
        {
            new string[180];
	        mysql_format(pearsq, string, sizeof(string), "INSERT INTO `Refrigerator` SET `id` = '%d'", i), mysql_tquery(pearsq, string);
        }
    }
    return 1;
}

function LoadRefegirator() {
    new rows;
    cache_get_row_count(rows);
    for (new f = 1; f < rows; f++) {
        OnLoadInventRefrigerator(f);
    }
}
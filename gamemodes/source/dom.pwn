stock use_dom(playerid, dom, inva, useinva)
{
    i_resettabs(playerid);
	i_resetveshi(playerid);
	
	if(OnlineInfo[playerid][oShowTabs] != dom) return 1;
	if(Veshi[playerid] >= 1) return 1;
	if(gRedakt[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя перекладывать предметы во время использования редактора объектов");
 		
	if(useinva != 9999)
	{
 		if(PlayerInfo[playerid][pInven][useinva] != DomInfo[dom][dInvent][inva] && PlayerInfo[playerid][pInven][useinva] != 0) return 1;
	}
	if(!IsPlayerInRangeOfPoint(playerid,1.5,DomInfo[dom][dCupX], DomInfo[dom][dCupY], DomInfo[dom][dCupZ])
	&& !IsPlayerInRangeOfPoint(playerid,100.0,DomInfo[dom][dEnterX], DomInfo[dom][dEnterY], DomInfo[dom][dEnterZ])) return ErrorMessage(playerid, "{FF6347}Вы далеко от шкафа"), closetab(playerid, 1);
		
	new fpick = DomInfo[dom][dInvent][inva], fquan = DomInfo[dom][dInv][inva], thingType = DomInfo[dom][dInvType][inva], thingPack = DomInfo[dom][dInvPack][inva];
	if(PlayerInfo[playerid][pDom] != dom)
	{
		if(DomInfo[dom][dAcccupG] == 0) return ErrorMessage(playerid, "{FF6347}Брать предметы из шкафа может только владелец");
		if(DomInfo[dom][dAcccupG] == 1 && PlayerInfo[playerid][pHouserent] != dom) return ErrorMessage(playerid, "{FF6347}Брать предметы из шкафа может только владелец и проживающие");
		if(DomInfo[dom][dAcccupG] == 2 && (DomInfo[dom][dFam] == 0 || DomInfo[dom][dFam] >= 1 && PlayerInfo[playerid][pFamily] != DomInfo[dom][dFam])) return ErrorMessage(playerid, "{FF6347}Брать предметы из шкафа может только владелец и семья");
		if(DomInfo[dom][dAcccupG] == 3 && (DomInfo[dom][dFam] == 0 || DomInfo[dom][dFam] >= 1 && PlayerInfo[playerid][pFamily] != DomInfo[dom][dFam]) && PlayerInfo[playerid][pHouserent] != dom) return ErrorMessage(playerid, "{FF6347}Брать предметы из шкафа может только владелец, проживающие и семья");
	}
	
	// Забираем предмет из дома
	if(thingType == 0 && thingPack == 0)
	{
	    if(CheckThingQuan(fpick) == 1)
		{
		    DP[0][playerid] = inva;
			new string[120];
			format(string,sizeof(string),"{cccccc}Чтобы взять {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(0, fpick, thingType, thingPack));
			ShowDialog(playerid,777,DIALOG_STYLE_INPUT,"{ff9000}Дом",string,"Принять","Отмена");
			return 1;
		}
	}
	else if(thingType == 4) // Мебель
	{
		PlayerPlaySound(playerid,1052,0,0,0);
		new obid;
		if(DomInfo[dom][dFrame] == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! В доме не установлена планировка");
		if(DomInfo[dom][dSell] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете заниматься ремонтом дома во время продажи"), i_resettabs(playerid);
		if(gRedakt[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя перекладывать предметы во время использования редактора объектов"), i_resettabs(playerid);

		new slot = -1;
		for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
		{
			if(DomInfo[dom][dOmodel][oba] == 0)
			{
				slot = oba;
				break;
			}
		}
		if(slot == -1) return ErrorMessage(playerid, "{FF6347}Лимит слотов для мебели в доме"), i_resettabs(playerid);

		obid = DomInfo[dom][dInvent][inva], DomInfo[dom][dInvent][inva] = 0, DomInfo[dom][dInv][inva] = 0;
		CloseFrisk(playerid);

		new Float:f_pos[4];
		frontme(playerid, 2.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
		DomInfo[dom][dObject][slot] = CreateDynamicObject(obid, f_pos[0], f_pos[1], f_pos[2], 0.0000, 0.0000, 0.0000, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 100.00, 100.00);
		DomInfo[dom][dUser][slot] = playerid;
		DomInfo[dom][dQara][slot] = DomInfo[dom][dInvQara][inva];
		DomInfo[dom][dOmodel][slot] = obid;

		GoEditDynamicObject(playerid, 6, 0, dom, slot, DomInfo[dom][dObject][slot], inva);
		return 1;
	}
	
	// Проверка на наличие особых аксессуаров (Каска и Броня)
	if(IsArmor(fpick) && thingType == 2 && PlayerInfo[playerid][pArmor] >= 1) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет\n\n{cccccc}Учитывается надетая броня");
	
	// Проверка на одиночный предмет
	if(JustOneThingInventory(fpick, thingType) && get_invent(playerid, fpick, thingType) > 0) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров");
	
	new string[160];
	if(thingType == 0)
	{
	    if(CheckThingQuan(fpick) == 1)
		{
			new getQuan, getLimit;
    		i_limit(playerid, fpick, getQuan, getLimit);
    		if(getQuan+fquan > getLimit) return format(string,sizeof(string),"{FF6347}У вас нет места в инвентаре\nЛимит для этого предмета: %d\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров", getLimit), ErrorMessage(playerid, string);
 		}
	}
	
	new put_inva = GiveThingPlayer(playerid, fpick, fquan, DomInfo[dom][dInvPara][inva], DomInfo[dom][dInvQara][inva], DomInfo[dom][dInvType][inva], DomInfo[dom][dInvPack][inva], useinva);
	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У меня нет места в инвентаре"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
    TakeDom(dom, fpick, fquan, thingType, inva);
    
    SaveInvent(playerid, put_inva); // Сохраняем то, что игрок взял
    
    format(string, sizeof(string), "Взял %s", GetNameThing(1, fpick, thingType, thingPack));
	HouseLog(0, "wb", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], dom, fquan, string);
	
    format(string,sizeof(string),"Взял %d: %s", dom, GetNameThing(1, fpick, thingType, thingPack));
	UserLog("wb", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fquan, string);
	return 1;
}
stock put_dom(playerid, inva, dom, fpick, fquan, binva, thingType, thingPack)
{
	new put_inva = -1;
	if(OnlineInfo[playerid][oShowInterface] != 1 || binva == 9999 || OnlineInfo[playerid][oShowTabs] == 9999
	|| PlayerInfo[playerid][pInven][inva] == 0 || PlayerInfo[playerid][pInven][inva] != fpick || PlayerInfo[playerid][pInvenQuan][inva] < fquan) return i_resetveshi(playerid);
	if(gRedakt[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя перекладывать предметы во время использования редактора объектов"), i_resetveshi(playerid);
	
	if(!IsPlayerInRangeOfPoint(playerid,1.5,DomInfo[dom][dCupX], DomInfo[dom][dCupY], DomInfo[dom][dCupZ])
	&& !IsPlayerInRangeOfPoint(playerid,80.0,DomInfo[dom][dEnterX], DomInfo[dom][dEnterY], DomInfo[dom][dEnterZ])) return ErrorMessage(playerid, "{FF6347}Вы далеко от шкафа"), i_resetveshi(playerid);
	
	if(PlayerInfo[playerid][pDom] != dom)
	{
		if(DomInfo[dom][dAcccupP] == 0) return ErrorMessage(playerid, "{FF6347}Класть предметы в шкаф этого дома может только владелец"), i_resetveshi(playerid);
		if(DomInfo[dom][dAcccupP] == 1 && PlayerInfo[playerid][pHouserent] != dom) return ErrorMessage(playerid, "{FF6347}Класть предметы в шкаф этого дома может только владелец и проживающие"), i_resetveshi(playerid);
		if(DomInfo[dom][dAcccupP] == 2 && (DomInfo[dom][dFam] == 0 || DomInfo[dom][dFam] >= 1 && PlayerInfo[playerid][pFamily] != DomInfo[dom][dFam])) return ErrorMessage(playerid, "{FF6347}Класть предметы в шкаф этого дома может только владелец и семья"), i_resetveshi(playerid);
		if(DomInfo[dom][dAcccupP] == 3 && (DomInfo[dom][dFam] == 0 || DomInfo[dom][dFam] >= 1 && PlayerInfo[playerid][pFamily] != DomInfo[dom][dFam]) && PlayerInfo[playerid][pHouserent] != dom) return ErrorMessage(playerid, "{FF6347}Класть предметы в шкаф этого дома может только владелец, проживающие и семья"), i_resetveshi(playerid);
	}
	
	if(fpick == 48 && thingType == 0 && OnlineInfo[playerid][oInflatableBoat] != NON) return ErrorMessage(playerid, "{FF6347}Нужно сдуть лодку, прежде чем убрать в дом"), i_resetveshi(playerid);
	if(NotGiveThing(fpick, thingType, PlayerInfo[playerid][pInvenQuan][inva])) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя передавать, продавать или убирать"), i_resetveshi(playerid);
	
	new string[100];
	new quanThing;
	if(thingType == 0)
	{
		if(CheckThingQuan(fpick) == 1)
		{
		    if(DomInfo[dom][dInvent][binva] != 0 && DomInfo[dom][dInvent][binva] != PlayerInfo[playerid][pInven][inva]) return ErrorMessage(playerid, "{FF6347}Эта ячейка занята"), i_resetveshi(playerid);
		    if(thingPack == 0) quanThing = 1;
		    if(PlayerInfo[playerid][pInvenQuan][inva] < fquan) return ErrorMessage(playerid, "{FF6347}У вас нет такого количества в этой ячейке"), i_resetveshi(playerid);
		    new getQuan, getLimit;
		    d_limit(dom, fpick, getQuan, getLimit);
		    if(getQuan+fquan > getLimit)
		    {
		        format(string,sizeof(string),"{FF6347}В доме нет места\n\nЛимит для этого предмета: %d", getLimit);
		        ErrorMessage(playerid, string);
				i_resetveshi(playerid);
				i_resettabs(playerid);
				return 1;
		    }
		}
	}
	if(DomInfo[dom][dInvent][binva] > 0 && quanThing == 0) return ErrorMessage(playerid, "{FF6347}Эта ячейка занята"), i_resetveshi(playerid);
	
	put_inva = put_thing_dom(dom, fpick, fquan, PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenQara][inva], thingType, thingPack, binva);
	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}В доме нет места"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
	
	if(quanThing == 1) take_away(playerid, fquan, inva); // Отнимаем предмет (по количеству)
 	else i_del(playerid, inva); // Отнимаем предмет (целиком)
 	SaveInvent(playerid, inva); // Сохраняем ячейку инвентаря игрока
	
	format(string,sizeof(string),"Положил в дом %d: %s", GetNameThing(1, fpick, thingType, thingPack));
	UserLog("wb", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fquan, string);
	
	i_resetveshi(playerid);
	i_resettabs(playerid);
	return put_inva;
}
stock PutThingDom(dom, thingId, quan, para, qara, thingType, thingPack, useinva) // Кладём предмет в дом
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
		    	for(new i = 0; i < 80; i++)
				{
					if(DomInfo[dom][dInvent][i] == thingId && DomInfo[dom][dInvType][i] == thingType && DomInfo[dom][dInvPack][i] == thingPack) // Ищем тот, где уже предмет лежит
					{
					    inva = i;
		  				put_thing_dom(dom, thingId, quan, para, 0, thingType, thingPack, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
		  				find = 1;
			   			break;
					}
				}
				if(find == 0) // Если не нашли, ищем пустую
				{
					for(new i = 0; i < 80; i++)
					{
						if(DomInfo[dom][dInvent][i] == 0) // Ищем пустую ячейку
						{
						    inva = i;
			  				put_thing_dom(dom, thingId, quan, para, 0, thingType, thingPack, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
				   			break;
						}
					}
				}
			}
			else if(CheckThingQuan(thingId) == 0) // Объект не имеет количество
			{
			    for(new i = 0; i < 80; i++)
				{
					if(DomInfo[dom][dInvent][i] == 0) // Ищем пустую ячейку
					{
					    inva = i;
		  				put_thing_dom(dom, thingId, quan, para, qara, thingType, thingPack, i);
			   			break;
					}
				}
			}
		}
		else // Все остальные предметы не имеют количества или возможности складываться в одну ячейку
		{
		    for(new i = 0; i < 80; i++)
			{
				if(DomInfo[dom][dInvent][i] == 0) // Ищем пустую ячейку
				{
				    inva = i;
	  				put_thing_dom(dom, thingId, quan, para, qara, thingType, thingPack, i);
		   			break;
				}
			}
		}
	}
	else inva = put_thing_dom(dom, thingId, quan, para, qara, thingType, thingPack, useinva); // Знаем в какую ячейку класть
	return inva;
}

stock put_thing_dom(dom, thingId, quan, para, qara, thingType, thingPack, i)
{
	if(DomInfo[dom][dInvent][i] != 0 && DomInfo[dom][dInvent][i] != thingId) return -1; // Защита от ошибки, на всякий случай

	if(DomInfo[dom][dSost] > 0 && qara == DomInfo[dom][dSost]) qara = 0; // Удаляем статус краденного предмета, если он принадлежит этому игроку

	DomInfo[dom][dInvent][i] = thingId; // Ставим предмет в слот
	DomInfo[dom][dInv][i] += quan; // Ставим количество в слот

	// (Техника сломана или нет, Одежда какой организации принадлежит, Unix время свежести продуктов, Изношенность оружия, Прнадлежность лицензии к ID игрока, Тип крепления аксессуара)
	if(PerishableThing(thingId, thingType)) // Проверка на портящиеся продукты - у них используется Unix (Добавляя испорченный продукт к свежему, портиться должно всё)
	{
	    if(DomInfo[dom][dInvPara][i] > 0)
		{
			if(DomInfo[dom][dInvPara][i] > para) DomInfo[dom][dInvPara][i] = para;
		}
		else DomInfo[dom][dInvPara][i] = para;
	}
	else DomInfo[dom][dInvPara][i] = para;
	DomInfo[dom][dInvQara][i] = qara; // Статус краденного предмета
	DomInfo[dom][dInvType][i] = thingType; // Тип предмета
	DomInfo[dom][dInvPack][i] = thingPack; // Упаковка предмета
	
	SaveOneTainik(dom, i);
	foreach(Player,x)
	{
		if(Tabs_Load[x] != 2) continue;
		if(OnlineInfo[x][oLogged] == 1 && OnlineInfo[x][oShowInterface] == 1 && OnlineInfo[x][oShowTabs] == dom) item_second(x, thingId, DomInfo[dom][dInv][i], i, 0, DomInfo[dom][dInvPara][i], thingType, thingPack, 0);
	}
	return i;
}
stock TakeDom(dom, stat, kolvo, thingType, dopinf)
{
	new plalit;
	if(dopinf == 999)
	{
		for(new inva = 0; inva < 80; inva++)
		{
			if(DomInfo[dom][dInvent][inva] == stat && DomInfo[dom][dInvType][inva] == thingType)
			{
				if(DomInfo[dom][dInv][inva]-kolvo <= 0) DomInfo[dom][dInvent][inva] = 0, DomInfo[dom][dInv][inva] = 0, DomInfo[dom][dInvPara][inva] = 0, DomInfo[dom][dInvQara][inva] = 0, DomInfo[dom][dInvType][inva] = 0, DomInfo[dom][dInvPack][inva] = 0;
				else DomInfo[dom][dInv][inva] -= kolvo;
				plalit = inva;
				break;
			}
		}
	}
	else
	{
		if(DomInfo[dom][dInvent][dopinf] == stat && DomInfo[dom][dInvType][dopinf] == thingType)
		{
			if(DomInfo[dom][dInv][dopinf]-kolvo <= 0) DomInfo[dom][dInvent][dopinf] = 0, DomInfo[dom][dInv][dopinf] = 0, DomInfo[dom][dInvPara][dopinf] = 0, DomInfo[dom][dInvQara][dopinf] = 0, DomInfo[dom][dInvType][dopinf] = 0, DomInfo[dom][dInvPack][dopinf] = 0;
			else DomInfo[dom][dInv][dopinf] -= kolvo;
		}
		plalit = dopinf;
	}
	SaveOneTainik(dom, plalit);
	foreach(Player,i)
	{
		if(Tabs_Load[i] != 2) continue;
		if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowTabs] == dom) item_second(i, DomInfo[dom][dInvent][plalit], DomInfo[dom][dInv][plalit], plalit, 0, DomInfo[dom][dInvPara][plalit], DomInfo[dom][dInvType][plalit], DomInfo[dom][dInvPack][plalit], 0);
	}
	return 1;
}
stock CheckDom(dom)
{
	new quanfree;
    for(new inva = 0; inva < 80; inva++)
	{
	    if(DomInfo[dom][dInvent][inva] == 0) quanfree ++;
	}
	if(quanfree == 0) return 1;
	return 0;
}
stock mix_dom(playerid, d, getinva, putinva)
{
	if(OnlineInfo[playerid][oShowTabs] != 9999)
	{
		if(DomInfo[d][dInvent][getinva] == 0) return i_resettabs(playerid);
		if(DomInfo[d][dInvent][putinva] != DomInfo[d][dInvent][getinva]) return i_resettabs(playerid);
		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 2) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			new string[80];
			format(string, sizeof(string), "{FF6347}Шкаф просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, string);
			i_resettabs(playerid);
			return 1;
		}
		DomInfo[d][dInv][putinva] += DomInfo[d][dInv][getinva];
		if(DomInfo[d][dInvPara][putinva] > DomInfo[d][dInvPara][getinva]) DomInfo[d][dInvPara][putinva] = DomInfo[d][dInvPara][getinva];
		DomInfo[d][dInvQara][putinva] = DomInfo[d][dInvQara][getinva];
		DomInfo[d][dInvType][putinva] = DomInfo[d][dInvType][getinva];
		DomInfo[d][dInvPack][putinva] = DomInfo[d][dInvPack][getinva];
		DomInfo[d][dInvent][getinva] = 0;
		DomInfo[d][dInv][getinva] = 0;
		DomInfo[d][dInvPara][getinva] = 0;
		DomInfo[d][dInvQara][getinva] = 0;
		DomInfo[d][dInvType][getinva] = 0;
		DomInfo[d][dInvPack][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, DomInfo[d][dInvent][getinva], DomInfo[d][dInvent][getinva], getinva, 0, DomInfo[d][dInvPara][getinva], DomInfo[d][dInvType][getinva], DomInfo[d][dInvPack][getinva], 0);
		item_second(playerid, DomInfo[d][dInvent][putinva], DomInfo[d][dInv][putinva], putinva, 0, DomInfo[d][dInvPara][putinva], DomInfo[d][dInvType][putinva], DomInfo[d][dInvPack][putinva], 0);
		SaveOneTainik(d, getinva);
		SaveOneTainik(d, putinva);
	}
	return 1;
}
stock shift_dom(playerid, d, getinva, putinva) //  Перемещение предметов внутри инвентаря дома (с одной ячейки на другую)
{
	if(OnlineInfo[playerid][oShowTabs] != 9999)
	{
		if(DomInfo[d][dInvent][getinva] == 0) return i_resettabs(playerid);
		else if(DomInfo[d][dInvent][putinva] != 0) return 1;
		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 2) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			new string[80];
			format(string, sizeof(string), "{FF6347}Шкаф просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, string);
			i_resettabs(playerid);
			return 1;
		}
		DomInfo[d][dInvent][putinva] = DomInfo[d][dInvent][getinva];
		DomInfo[d][dInv][putinva] = DomInfo[d][dInv][getinva];
		DomInfo[d][dInvPara][putinva] = DomInfo[d][dInvPara][getinva];
		DomInfo[d][dInvQara][putinva] = DomInfo[d][dInvQara][getinva];
		DomInfo[d][dInvType][putinva] = DomInfo[d][dInvType][getinva];
		DomInfo[d][dInvPack][putinva] = DomInfo[d][dInvPack][getinva];
		DomInfo[d][dInvent][getinva] = 0;
		DomInfo[d][dInv][getinva] = 0;
		DomInfo[d][dInvPara][getinva] = 0;
		DomInfo[d][dInvQara][getinva] = 0;
		DomInfo[d][dInvType][getinva] = 0;
		DomInfo[d][dInvPack][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, 0, 0, getinva, 0, 0, 0, 0, 0);
		item_second(playerid, DomInfo[d][dInvent][putinva], DomInfo[d][dInv][putinva], putinva, 0, DomInfo[d][dInvPara][putinva], DomInfo[d][dInvType][putinva], DomInfo[d][dInvPack][putinva], 0);
		SaveOneTainik(d, getinva);
		SaveOneTainik(d, putinva);
	}
	return 1;
}
stock get_dom(dom, thingId) // Поиск при добавлении нового предмета
{
	new quan = 0;
	for(new inva = 0; inva < 80; inva++)
	{
		if(DomInfo[dom][dInvent][inva] == thingId && DomInfo[dom][dInvType][inva] == 0) quan += DomInfo[dom][dInv][inva];
	}
	return quan;
}
stock get_dom2(dom, thingId) // Поиск на наличие предмета, без учёта упаковки
{
	new quan = 0;
	for(new inva = 0; inva < 80; inva++)
	{
		if(DomInfo[dom][dInvent][inva] == thingId && DomInfo[dom][dInvType][inva] == 0 && DomInfo[dom][dInvPack][inva] == 0) quan += DomInfo[dom][dInv][inva];
	}
	return quan;
}
stock d_limit(d, thingId, &getQuan, &getLimit) // Проверяем лимиты дома
{
	new lim[INVENTER];
	for(new i = 0; i < INVENTER; i++) lim[i] = 1;
	lim[8] = 100, lim[19] = 1000, lim[41] = 1000, lim[25] = 999000000; // Аптечки, Отмычки, Бенгальские Свечи, Деньги 999кк
	lim[4] = 100000, lim[5] = 100000, lim[6] = 100000, lim[7] = 100000, lim[9] = 20, lim[18] = 10000, lim[20] = 10000, lim[27] = 50000, lim[28] = 50000, lim[29] = 50000, lim[30] = 50000;
	lim[46] = 1000, lim[47] = 1000, lim[55] = 100, lim[60] = 1000, lim[61] = 500, lim[64] = 10000, lim[65] = 10000, lim[66] = 10000, lim[67] = 10000, lim[71] = 1000;
	lim[72] = 1000, lim[73] = 1000, lim[74] = 1000, lim[75] = 1000, lim[76] = 1000, lim[77] = 1000, lim[78] = 1000, lim[79] = 1000, lim[80] = 1000, lim[81] = 1000;
	lim[82] = 1000, lim[83] = 1000, lim[84] = 1000, lim[85] = 1000, lim[86] = 1000, lim[87] = 1000, lim[88] = 1000, lim[89] = 10000, lim[106] = 1000, lim[108] = 1000, lim[109] = 1000, lim[110] = 1000;
	lim[140] = 10000, lim[141] = 10000, lim[142] = 1000, lim[180] = 1000, lim[181] = 1000, lim[198] = 1000;

    getQuan = get_dom(d, thingId);
    getLimit = lim[thingId];
	return 1;
}
stock SaveOneTainik(idx, inva) // Сохраняем одну ячейку шкафа дома
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;

	new string_mysql[300];
	format(string_mysql, sizeof(string_mysql), "UPDATE `pp_dom` SET `Invent%d`='%d',`Inv%d`='%d',`InvPara%d`='%d',`InvQara%d`='%d',`InvType%d`='%d',`InvPack%d`='%d' WHERE `Ids`='%d'",
	inva,DomInfo[idx][dInvent][inva],inva,DomInfo[idx][dInv][inva],inva,DomInfo[idx][dInvPara][inva],inva,DomInfo[idx][dInvQara][inva],inva,DomInfo[idx][dInvType][inva],
	inva,DomInfo[idx][dInvPack][inva],idx); // 134 + 143
	query_empty(pearsq, string_mysql); // 277
	return 1;
}
stock SaveDomAll(idx) // Сохранение всего шкафа по цилку
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;

	new string_mysql[5300];
	format(string_mysql,sizeof(string_mysql),"UPDATE `pp_dom` SET `Invent0` = '%d', `Inv0` = '%d', `InvPara0` = '%d', `InvQara0` = '%d', `InvType0` = '%d', `InvPack0` = '%d'",
	DomInfo[idx][dInvent][0], DomInfo[idx][dInv][0], DomInfo[idx][dInvPara][0], DomInfo[idx][dInvQara][0], DomInfo[idx][dInvType][0], DomInfo[idx][dInvPack][0]); // 128 + 66
	for(new i = 1; i < 20; i++) 
	{
		format(string_mysql,sizeof(string_mysql),"%s, `Invent%d` = '%d', `Inv%d` = '%d', `InvPara%d` = '%d', `InvQara%d` = '%d', `InvType%d` = '%d', `InvPack%d` = '%d'", string_mysql,
		i, DomInfo[idx][dInvent][i], i, DomInfo[idx][dInv][i], i, DomInfo[idx][dInvPara][i], i, DomInfo[idx][dInvQara][i], i, DomInfo[idx][dInvType][i], 
		i, DomInfo[idx][dInvPack][i]); // 118 + 132
	}
	format(string_mysql,sizeof(string_mysql),"%s WHERE `Ids` = '%d'", string_mysql, idx); // 22 + 11
	query_empty(pearsq, string_mysql);
	
	format(string_mysql,sizeof(string_mysql),"UPDATE `pp_dom` SET `Invent20` = '%d', `Inv20` = '%d', `InvPara20` = '%d', `InvQara20` = '%d', `InvType20` = '%d', `InvPack20` = '%d'",
	DomInfo[idx][dInvent][20], DomInfo[idx][dInv][20], DomInfo[idx][dInvPara][20], DomInfo[idx][dInvQara][20], DomInfo[idx][dInvType][20], DomInfo[idx][dInvPack][20]); // 134 + 66
	for(new i = 21; i < 40; i++) 
	{
		format(string_mysql,sizeof(string_mysql),"%s, `Invent%d` = '%d', `Inv%d` = '%d', `InvPara%d` = '%d', `InvQara%d` = '%d', `InvType%d` = '%d', `InvPack%d` = '%d'", string_mysql,
		i, DomInfo[idx][dInvent][i], i, DomInfo[idx][dInv][i], i, DomInfo[idx][dInvPara][i], i, DomInfo[idx][dInvQara][i], i, DomInfo[idx][dInvType][i], 
		i, DomInfo[idx][dInvPack][i]); // 118 + 132
	}
	format(string_mysql,sizeof(string_mysql),"%s WHERE `Ids` = '%d'", string_mysql, idx); // 22 + 11
	query_empty(pearsq, string_mysql);
	
	format(string_mysql,sizeof(string_mysql),"UPDATE `pp_dom` SET `Invent40` = '%d', `Inv40` = '%d', `InvPara40` = '%d', `InvQara40` = '%d', `InvType40` = '%d', `InvPack40` = '%d'",
	DomInfo[idx][dInvent][40], DomInfo[idx][dInv][40], DomInfo[idx][dInvPara][40], DomInfo[idx][dInvQara][40], DomInfo[idx][dInvType][40], DomInfo[idx][dInvPack][40]); // 134 + 66
	for(new i = 41; i < 60; i++) 
	{
		format(string_mysql,sizeof(string_mysql),"%s, `Invent%d` = '%d', `Inv%d` = '%d', `InvPara%d` = '%d', `InvQara%d` = '%d', `InvType%d` = '%d', `InvPack%d` = '%d'", string_mysql,
		i, DomInfo[idx][dInvent][i], i, DomInfo[idx][dInv][i], i, DomInfo[idx][dInvPara][i], i, DomInfo[idx][dInvQara][i], i, DomInfo[idx][dInvType][i], 
		i, DomInfo[idx][dInvPack][i]); // 118 + 132
	}
	format(string_mysql,sizeof(string_mysql),"%s WHERE `Ids` = '%d'", string_mysql, idx); // 22 + 11
	query_empty(pearsq, string_mysql);
	
	format(string_mysql,sizeof(string_mysql),"UPDATE `pp_dom` SET `Invent60` = '%d', `Inv60` = '%d', `InvPara60` = '%d', `InvQara60` = '%d', `InvType60` = '%d', `InvPack60` = '%d'",
	DomInfo[idx][dInvent][60], DomInfo[idx][dInv][60], DomInfo[idx][dInvPara][60], DomInfo[idx][dInvQara][60], DomInfo[idx][dInvType][60], DomInfo[idx][dInvPack][60]); // 134 + 66
	for(new i = 61; i < 80; i++) 
	{
		format(string_mysql,sizeof(string_mysql),"%s, `Invent%d` = '%d', `Inv%d` = '%d', `InvPara%d` = '%d', `InvQara%d` = '%d', `InvType%d` = '%d', `InvPack%d` = '%d'", string_mysql,
		i, DomInfo[idx][dInvent][i], i, DomInfo[idx][dInv][i], i, DomInfo[idx][dInvPara][i], i, DomInfo[idx][dInvQara][i], i, DomInfo[idx][dInvType][i], 
		i, DomInfo[idx][dInvPack][i]); // 118 + 132
	}
	format(string_mysql,sizeof(string_mysql),"%s WHERE `Ids` = '%d'", string_mysql, idx); // 22 + 11
	query_empty(pearsq, string_mysql);
	return 1;
}

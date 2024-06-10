

CMD:rdomspawn(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сбросить спавн в доме [ /rdomspawn Номер Дома (0 - все дома) ]");

	new string[144];
	if(params[0] > 0)
	{
		if(params[0] >= MAX_DOM) return ErrorMessage(playerid, "{FF6347}Такого номера дома не существует");
		if(DomInfo[params[0]][dInspa] == 0) return ErrorMessage(playerid, "{FF6347}В доме не установлен спавн");
		DomInfo[params[0]][dInspa] = 0;
		format(string, sizeof(string), " [ ADM ]: %s сбросил спавн в доме № %d", PlayerInfo[playerid][pName], params[0]);
 		ABroadCast(COLOR_ADM,string,1);
		AdminLog("rdomspawn", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "Сбросил спавн в доме");
	}
	else
	{
		new string_mysql[100];
		mysql_transaction(pearsq);
		for(new d = 0; d < sizeof(DomInfo); d++)
 		{
			if(DomInfo[d][dInspa] > 0) 
			{
				DomInfo[d][dInspa] = 0;
				mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_dom` SET `Inspa` = '0' WHERE `Ids` = '%d'", d);
				mysql_tquery(pearsq, string_mysql);
			}
		}
		mysql_commit(pearsq);

		format(string, sizeof(string), " [ ADM ]: %s сбросил спавн во всех домах", PlayerInfo[playerid][pName]);
 		ABroadCast(COLOR_ADM,string,1);
		AdminLog("rdomspawn", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "Сбросил спавн во всех домах");	
	}
	return 1;
}

alias:rdomtaxes("rdomnal", "rdomtax", "rdomnalog")
CMD:rdomtaxes(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сбросить налог в доме [ /rdomtaxes Номер Дома (0 - все дома) ]");

	new string[144];
	if(params[0] > 0)
	{
		if(params[0] >= MAX_DOM) return ErrorMessage(playerid, "{FF6347}Такого номера дома не существует");
		ReloadDomTaxes(params[0]);
		format(string, sizeof(string), " [ ADM ]: %s сбросил налоги в доме № %d", PlayerInfo[playerid][pName], params[0]);
 		ABroadCast(COLOR_ADM,string,1);
		AdminLog("rdomtaxes", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "Сбросил налоги в доме");
	}
	else
	{
		mysql_transaction(pearsq);
		for(new d = 0; d < sizeof(DomInfo); d++)
 		{
			if(DomInfo[d][dTaxes] > 0 || DomInfo[d][dTaxday] > 0) ReloadDomTaxes(d);
		}
		mysql_commit(pearsq);

		format(string, sizeof(string), " [ ADM ]: %s сбросил налоги во всех домах", PlayerInfo[playerid][pName]);
 		ABroadCast(COLOR_ADM,string,1);
		AdminLog("rdomtaxes", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "Сбросил налоги во всех домах");	
	}
	return 1;
}

stock ReloadDomTaxes(d)
{
	DomInfo[d][dTaxes] = 0;
	DomInfo[d][dTaxday] = 0;
	SaveTax_Dom(d);
	return true;
}

alias:domdist("distdom", "ddist")
CMD:domdist(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 13) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Установить радиус для мапа дома [ /domdist ID Радиус ]");
	if(params[0] > MAX_DOM || params[0] < 1) return ErrorMessage(playerid, "{FF6347}Несуществующий номер дома");
	if(params[1] <= 10.0 || params[1] > 200.0) return ErrorMessage(playerid, "{FF6347}Радиус не меньше 10 и не больше 200");

	DomInfo[params[0]][dMapDistance] = params[1];

	new string[144];
	format(string, sizeof(string), " [ ADM ]: %s изменил радиус маппинга для дома № %d (%d метров)", PlayerInfo[playerid][pName], params[0], params[1]);
 	ABroadCast(COLOR_ADM,string,1);

	new string_mysql[100];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_dom` SET `dMapDistance`='%f' WHERE `Ids`='%d'", DomInfo[params[0]][dMapDistance], params[0]);
	query_empty(pearsq, string_mysql);

	HouseLog(0, "domdist", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], params[0], params[1], "Дистанция маппинга");
	format(string, sizeof(string), "Дом %d, %d метров", params[0], params[1]);
	AdminLog("domdist", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], string);
	return 1;
}

stock getFreeSlotObjectDom(dom)
{
	new slot = -1;
	for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
	{
		if(DomInfo[dom][dOmodel][oba] == 0)
		{
			slot = oba;
			break;
		}
	}
	return slot;
}

stock getObjectStreetDom(dom)
{
	new quan;
	for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
	{
		if(DomInfo[dom][dOmodel][oba] > 0)
		{
			if(GetDynamicObjectVirtualWorld(DomInfo[dom][dObject][oba]) == 0
				&& GetDynamicObjectInterior(DomInfo[dom][dObject][oba]) == 0)
			{
				quan ++;
			}
		}
	}
	return quan;
}

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

	if(!IsANearWardrobeDom(playerid, dom)) return ErrorMessage(playerid, "{FF6347}Вы далеко от шкафа"), closetab(playerid, 1);
		
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
		if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0) return ErrorMessage(playerid, "{FF6347}Вы не можете взять предметы из дома на улице\n{cccccc}На улице вы можете устанавливать только объекты из шкафа");
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
		new obid = DomInfo[dom][dInvent][inva];
		if(DomInfo[dom][dSell] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете заниматься ремонтом дома во время продажи");
		if(gRedakt[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя перекладывать предметы во время использования редактора объектов");

		if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
		{
			if(!getIkeaObjectStreet(obid)) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя устанавливать на улице");
			if(getObjectStreetDom(dom) >= MAX_DOM_OBJECT_STREET) return ErrorMessage(playerid, "{FF6347}В этом доме установлено максимальное количество предметов на улице");
		}
		if(getFreeSlotObjectDom(dom) == -1) return ErrorMessage(playerid, "{FF6347}В этом доме закончились слоты для установки объектов");
		if(DomInfo[dom][dInv][inva] == 1000) return ErrorMessage(playerid, "{FF6347}Этот предмет мебели кто-то устанавливает");

		PlayerPlaySound(playerid,1052,0,0,0);
		DomInfo[dom][dInv][inva] = 1000; // Блокируем возможность забрать предмет из инвентаря
		CloseFrisk(playerid);

		new Float:f_pos[4];
		frontme(playerid, 2.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
		CreateEditPlayerObject(playerid, 6, 0, dom, inva, obid, f_pos[0], f_pos[1], f_pos[2], 0.0000, 0.0000, 0.0000);
		return 1;
	}
	
	if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)  return ErrorMessage(playerid, "{FF6347}Вы не можете взять предметы из дома на улице\n{cccccc}На улице вы можете устанавливать только объекты из шкафа");

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
    
    format(string, sizeof(string), "Взял %s", GetNameThing(1, fpick, thingType, thingPack));
	HouseLog(0, "wb", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], dom, fquan, string);
	
    format(string,sizeof(string),"Взял из Дома %d: %s", dom, GetNameThing(1, fpick, thingType, thingPack));
	UserLog("wb", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fquan, string);
	return 1;
}
stock put_dom(playerid, inva, dom, fpick, fquan, binva, thingType, thingPack)
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || binva == 9999 || OnlineInfo[playerid][oShowTabs] == 9999
	|| PlayerInfo[playerid][pInven][inva] == 0 || PlayerInfo[playerid][pInven][inva] != fpick || PlayerInfo[playerid][pInvenQuan][inva] < fquan) return i_resetveshi(playerid);
	if(gRedakt[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя перекладывать предметы во время использования редактора объектов"), i_resetveshi(playerid);
	
	if(!IsPlayerInRangeOfPoint(playerid,200.0,DomInfo[dom][dEnterX], DomInfo[dom][dEnterY], DomInfo[dom][dEnterZ])) return ErrorMessage(playerid, "{FF6347}Зайдите в дом, чтобы положить предмет"), i_resetveshi(playerid);
	
	if(PlayerInfo[playerid][pDom] != dom)
	{
		if(DomInfo[dom][dAcccupP] == 0) return ErrorMessage(playerid, "{FF6347}Класть предметы в шкаф этого дома может только владелец"), i_resetveshi(playerid);
		if(DomInfo[dom][dAcccupP] == 1 && PlayerInfo[playerid][pHouserent] != dom) return ErrorMessage(playerid, "{FF6347}Класть предметы в шкаф этого дома может только владелец и проживающие"), i_resetveshi(playerid);
		if(DomInfo[dom][dAcccupP] == 2 && (DomInfo[dom][dFam] == 0 || DomInfo[dom][dFam] >= 1 && PlayerInfo[playerid][pFamily] != DomInfo[dom][dFam])) return ErrorMessage(playerid, "{FF6347}Класть предметы в шкаф этого дома может только владелец и семья"), i_resetveshi(playerid);
		if(DomInfo[dom][dAcccupP] == 3 && (DomInfo[dom][dFam] == 0 || DomInfo[dom][dFam] >= 1 && PlayerInfo[playerid][pFamily] != DomInfo[dom][dFam]) && PlayerInfo[playerid][pHouserent] != dom) return ErrorMessage(playerid, "{FF6347}Класть предметы в шкаф этого дома может только владелец, проживающие и семья"), i_resetveshi(playerid);
	}
	
	if(NotGiveInflatabelBoat(playerid, fpick, thingType)) return i_resetveshi(playerid);
	if(NotGiveThing(fpick, thingType, PlayerInfo[playerid][pInvenQuan][inva])) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя передавать, продавать или убирать"), i_resetveshi(playerid);
	
	// Кейс нельзя выбрасывать на 3 уровне и ниже
	if(IsNotGiveCase(playerid, thingPack)) return i_resetveshi(playerid);

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
	
	new put_inva = put_thing_dom(dom, fpick, fquan, PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenQara][inva], thingType, thingPack, binva);
	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}В доме нет места"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
	
	if(quanThing == 1) take_away(playerid, fquan, inva); // Отнимаем предмет (по количеству)
 	else i_del(playerid, inva); // Отнимаем предмет (целиком)
	
	format(string,sizeof(string),"Положил в дом %d: %s", dom, GetNameThing(1, fpick, thingType, thingPack));
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

	if(DomInfo[dom][dSost] > 0 && qara == DomInfo[dom][dSost] && thingPack == 0) qara = 0; // Удаляем статус краденного предмета, если он принадлежит этому игроку

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
		if(GetPlayerInterior(playerid) == 0) return ErrorMessage(playerid, "{FF6347}Вы не можете перекладывать предметы в доме на улице"), i_resettabs(playerid);

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
		
		mysql_tquery(pearsq, "START TRANSACTION;");
		SaveOneTainik(d, getinva);
		SaveOneTainik(d, putinva);
		mysql_tquery(pearsq, "COMMIT;");
	}
	return 1;
}
stock shift_dom(playerid, d, getinva, putinva) //  Перемещение предметов внутри инвентаря дома (с одной ячейки на другую)
{
	if(OnlineInfo[playerid][oShowTabs] != 9999)
	{
		if(DomInfo[d][dInvent][getinva] == 0) return i_resettabs(playerid);
		else if(DomInfo[d][dInvent][putinva] != 0) return 1;
		if(GetPlayerInterior(playerid) == 0) return ErrorMessage(playerid, "{FF6347}Вы не можете перекладывать предметы в доме на улице"), i_resettabs(playerid);
		if(DomInfo[d][dInvType][getinva] == 4 && DomInfo[d][dInv][getinva] == 1000) return ErrorMessage(playerid, "{FF6347}Этот предмет мебели кто-то устанавливает"), i_resettabs(playerid);

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
		
		mysql_tquery(pearsq, "START TRANSACTION;");
		SaveOneTainik(d, getinva);
		SaveOneTainik(d, putinva);
		mysql_tquery(pearsq, "COMMIT;");
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
	new lim[sizeof(friskName)];
	for(new i = 0; i < sizeof(friskName); i++) lim[i] = 1;
	lim[8] = 100, lim[19] = 1000, lim[41] = 1000, lim[25] = 999000000; // Аптечки, Отмычки, Бенгальские Свечи, Деньги 999кк
	lim[4] = 100000, lim[5] = 100000, lim[6] = 100000, lim[7] = 100000, lim[9] = 20, lim[18] = 10000, lim[20] = 10000, lim[27] = 50000, lim[28] = 50000, lim[29] = 50000, lim[30] = 50000;
	lim[46] = 1000, lim[47] = 1000, lim[55] = 100, lim[60] = 1000, lim[61] = 500, lim[64] = 10000, lim[65] = 10000, lim[66] = 10000, lim[67] = 10000, lim[71] = 1000;
	lim[72] = 1000, lim[73] = 1000, lim[74] = 1000, lim[75] = 1000, lim[76] = 1000, lim[77] = 1000, lim[78] = 1000, lim[79] = 1000, lim[80] = 1000, lim[81] = 1000;
	lim[82] = 1000, lim[83] = 1000, lim[84] = 1000, lim[85] = 1000, lim[86] = 1000, lim[87] = 1000, lim[88] = 1000, lim[89] = 10000, lim[106] = 1000, lim[108] = 1000, lim[109] = 1000, lim[110] = 1000;
	lim[140] = 10000, lim[141] = 10000, lim[142] = 1000, lim[180] = 1000, lim[181] = 1000, lim[197] = 1000, lim[198] = 1000, lim[225] = 1000;

    getQuan = get_dom(d, thingId);
    getLimit = lim[thingId];
	return 1;
}
stock SaveOneTainik(idx, inva) // Сохраняем одну ячейку шкафа дома
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;

	if(DomInfo[idx][dInvent][inva] == 0)
	{
		new string_mysql[140];
		mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_dom` SET `d_slot_%d`= NULL WHERE `Ids` = '%d'", inva, idx);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new JsonNode:node = JSON_Object(
			"id", JSON_Int(DomInfo[idx][dInvent][inva]),
			"quan", JSON_Int(DomInfo[idx][dInv][inva]),
			"para", JSON_Int(DomInfo[idx][dInvPara][inva]),
			"qara", JSON_Int(DomInfo[idx][dInvQara][inva]),
			"type", JSON_Int(DomInfo[idx][dInvType][inva]),
			"pack", JSON_Int(DomInfo[idx][dInvPack][inva])
		);

		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_dom` SET `d_slot_%d`= '%e' WHERE `Ids` = '%d'", inva, string_json, idx);
			mysql_tquery(pearsq, string_mysql);
		}
	}
	return 1;
}

stock OnLoadDomInvent(idx, f)
{
	for(new i = 0; i < 80; i++)
	{
		new string[20], bool:is_null;
		format(string, sizeof(string), "d_slot_%d", i);
		cache_is_value_name_null(f, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(f, string, string_json, 512);

			new JsonNode:node = JSON_INVALID_NODE;
			if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
			{
				JSON_GetInt(node, "id", DomInfo[idx][dInvent][i]);
				JSON_GetInt(node, "quan", DomInfo[idx][dInv][i]);
				JSON_GetInt(node, "para", DomInfo[idx][dInvPara][i]);
				JSON_GetInt(node, "qara", DomInfo[idx][dInvQara][i]);
				JSON_GetInt(node, "type", DomInfo[idx][dInvType][i]);
				JSON_GetInt(node, "pack", DomInfo[idx][dInvPack][i]);
			}
		}
	}
	return 1;
}

stock CreateNewHouseDoor(playerid,d, door)
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	if(DomInfo[d][dDoor][door] == 0)
	{
		DomInfo[d][dDoor][door] = 1;
		if(door == 0)
		{
			DopDomPickup[d][door] = CreateDynamicPickup(19132, 1, x, y, z,0,0);
			DomInfo[d][dCoordDopDoorOne][0] = x;
			DomInfo[d][dCoordDopDoorOne][1] = y;
			DomInfo[d][dCoordDopDoorOne][2] = z;
		}
		else if(door == 1)
		{
			DopDomPickup[d][door] = CreateDynamicPickup(19132, 1, x, y, z,0,0);
			DomInfo[d][dCoordDopDoorTwo][0] = x;
			DomInfo[d][dCoordDopDoorTwo][1] = y;
			DomInfo[d][dCoordDopDoorTwo][2] = z;
		}
	}
	else
	{
		DomInfo[d][dDoor][door] = 0;
		if(DopDomPickup[d][door] != 0) DestroyDynamicPickup(DopDomPickup[d][door]);
		if(door == 0)
		{
			DomInfo[d][dCoordDopDoorOne][0] = 0.0;
			DomInfo[d][dCoordDopDoorOne][1] = 0.0;
			DomInfo[d][dCoordDopDoorOne][2] = 0.0;
		}
		else if(door == 1)
		{
			DomInfo[d][dCoordDopDoorTwo][0] = 0.0;
			DomInfo[d][dCoordDopDoorTwo][1] = 0.0;
			DomInfo[d][dCoordDopDoorTwo][2] = 0.0;
		}
	}
	SaveDopDoor(d);
	return 1;
}

stock CreateNewHouseDoorInt(playerid,d, door)
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	new w = GetPlayerVirtualWorld(playerid);
	new i = GetPlayerInterior(playerid);
	if(DomInfo[d][dDoorInt][door] == 0)
	{
		DomInfo[d][dDoorInt][door] = 1;
		if(door == 0)
		{
			DopDomPickupInt[d][door] = CreateDynamicPickup(19132, 1, x, y, z,w,i);
			DomInfo[d][dCoordDopDoorOneInt][0] = x;
			DomInfo[d][dCoordDopDoorOneInt][1] = y;
			DomInfo[d][dCoordDopDoorOneInt][2] = z;
		}
		else if(door == 1)
		{
			DopDomPickupInt[d][door] = CreateDynamicPickup(19132, 1, x, y, z,w,i);
			DomInfo[d][dCoordDopDoorTwoInt][0] = x;
			DomInfo[d][dCoordDopDoorTwoInt][1] = y;
			DomInfo[d][dCoordDopDoorTwoInt][2] = z;
		}
	}
	else
	{
		DomInfo[d][dDoorInt][door] = 0;
		if(DopDomPickupInt[d][door] != 0) DestroyDynamicPickup(DopDomPickupInt[d][door]);
		if(door == 0)
		{
			DomInfo[d][dCoordDopDoorOneInt][0] = 0.0;
			DomInfo[d][dCoordDopDoorOneInt][1] = 0.0;
			DomInfo[d][dCoordDopDoorOneInt][2] = 0.0;
		}
		else if(door == 1)
		{
			DomInfo[d][dCoordDopDoorTwoInt][0] = 0.0;
			DomInfo[d][dCoordDopDoorTwoInt][1] = 0.0;
			DomInfo[d][dCoordDopDoorTwoInt][2] = 0.0;
		}
	}
	SaveDopDoor(d);
	return 1;
}

stock SaveDopDoor(d)
{
	new string_mysql[3600];
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_dom` SET `dDoorInt0` = '%d', `dDoorInt1` = '%d', `dDoor0` = '%d', `dDoor1` = '%d'",
	DomInfo[d][dDoorInt][0],DomInfo[d][dDoorInt][1],DomInfo[d][dDoor][0],DomInfo[d][dDoor][1]);
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s, `dCoordDopDoorOneX` = '%f', `dCoordDopDoorOneY` = '%f', `dCoordDopDoorOneZ` = '%f'", string_mysql,
	DomInfo[d][dCoordDopDoorOne][0],DomInfo[d][dCoordDopDoorOne][1],DomInfo[d][dCoordDopDoorOne][2]);
	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s, `dCoordDopDoorTwoX` = '%f', `dCoordDopDoorTwoY` = '%f', `dCoordDopDoorTwoZ` = '%f'", string_mysql,
	DomInfo[d][dCoordDopDoorTwo][0],DomInfo[d][dCoordDopDoorTwo][1],DomInfo[d][dCoordDopDoorTwo][2]);
	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s, `dCoordDopDoorOneIntX` = '%f', `dCoordDopDoorOneIntY` = '%f', `dCoordDopDoorOneIntZ` = '%f'", string_mysql,
	DomInfo[d][dCoordDopDoorOneInt][0],DomInfo[d][dCoordDopDoorOneInt][1],DomInfo[d][dCoordDopDoorOneInt][2]);
	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s, `dCoordDopDoorTwoIntX` = '%f', `dCoordDopDoorTwoIntY` = '%f', `dCoordDopDoorTwoIntZ` = '%f' WHERE `Ids` = '%d'", string_mysql,
	DomInfo[d][dCoordDopDoorTwoInt][0],DomInfo[d][dCoordDopDoorTwoInt][1],DomInfo[d][dCoordDopDoorTwoInt][2], d);
    query_empty(pearsq, string_mysql);
	return 1;
}
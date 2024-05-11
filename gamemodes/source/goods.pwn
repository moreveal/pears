stock showgoods(playerid, i)
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || howstun(playerid)) return 1;
	i_tabs(playerid, 4, 1);
	OnlineInfo[playerid][oShowTabs] = i;
	Pagetwo[playerid] = 0;
	for(new m = 0; m < 20; m++) item_second(playerid, PlayerInfo[i][pMarkInven][m], PlayerInfo[i][pMarkInvenQuan][m], m, 1, PlayerInfo[i][pMarkInvenPara][m], PlayerInfo[i][pMarkInvenType][m], PlayerInfo[i][pMarkInvenPack][m], 0);
	return 1;
}
stock showmygoods(playerid)
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || howstun(playerid)) return 1;
	i_tabs(playerid, 2, 1);
	Pagetwo[playerid] = 0;
	for(new m = 0; m < 20; m++) item_second(playerid, PlayerInfo[playerid][pMarkInven][m], PlayerInfo[playerid][pMarkInvenQuan][m], m, 1, PlayerInfo[playerid][pMarkInvenPara][m], PlayerInfo[playerid][pMarkInvenType][m], PlayerInfo[playerid][pMarkInvenPack][m], 0);
	return 1;
}
stock use_mygoods(playerid, inva, useinva) // Берём предмет  из собственного раздела товаров
{
    new fpick = PlayerInfo[playerid][pMarkInven][inva], fquan = PlayerInfo[playerid][pMarkInvenQuan][inva], thingType = PlayerInfo[playerid][pMarkInvenType][inva], thingPack = PlayerInfo[playerid][pMarkInvenPack][inva];
    if(fpick == 0) return i_resettabs(playerid);
	if(useinva != 9999)
	{
 		if(PlayerInfo[playerid][pInven][useinva] != fpick && PlayerInfo[playerid][pInven][useinva] != 0) return i_resettabs(playerid);
	}
	if(Goods[playerid] == 0) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас перекладывать товары\n{cccccc}Откройте или арендуйте торговую лавку"), i_resetveshi(playerid), i_resettabs(playerid);
	
	// Забираем предмет из товаров
	if(thingType == 0 && thingPack == 0)
	{
	    if(CheckThingQuan(fpick) == 1)
		{
		    DP[0][playerid] = inva;
		    Veshi[playerid] = OnlineInfo[playerid][oInventSelectRight];
			new string[130];
			format(string,sizeof(string),"{cccccc}Чтобы переложить {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(0, fpick, thingType, thingPack));
			ShowDialog(playerid,1104,DIALOG_STYLE_INPUT,"{ff9000}Торговля",string,"Принять","Отмена");
			return 1;
		}
	}
	
	Veshi[playerid] = 0;
    i_resetveshi(playerid);
	i_resettabs(playerid);
	
	new put_inva = GiveThingPlayer(playerid, fpick, fquan, PlayerInfo[playerid][pMarkInvenPara][inva], PlayerInfo[playerid][pMarkInvenQara][inva], thingType, thingPack, useinva);
	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У меня нет места в инвентаре"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет

    ClearMyGoods(playerid, inva);
    PlayerInfo[playerid][pM_Update][inva] = true;
    item_second(playerid, 0, 0, inva, 1, 0, 0, 0, 0);
    PlayerInfo[playerid][pI_Update][put_inva] = true; // Сохраняем то, что игрок взял

	// Отображаем всем кто смотрит раздел моих товаров
	updategoods(playerid, inva);
	return 1;
}
stock buy_goods(playerid, seller, inva, fpick, fquan, para, qara)
{
	i_resettabs(playerid);
	i_resetveshi(playerid);
	Veshi[playerid] = 0;
	new thingType = PlayerInfo[seller][pMarkInvenType][inva], thingQuan = PlayerInfo[seller][pMarkInvenQuan][inva], thingPack = PlayerInfo[seller][pMarkInvenPack][inva], price = PlayerInfo[seller][pMarkPrice][inva];
	if(NotGiveThing(fpick, thingType, thingQuan)) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя передать этому игроку");
	
	// Проверка на наличие особых аксессуаров (Каска и Броня)
	if(IsArmor(fpick) && thingType == 2 && PlayerInfo[playerid][pArmor] >= 1) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет\n\n{cccccc}Учитывается надетая броня");
	
	new string[160];
	// Проверка на лимиты количественного предмета
	new quanThing;
	if(thingType == 0) // Обычный предмет
	{
	    if(CheckThingQuan(fpick) == 1) // Предмет имеет количество
		{
		    if(thingPack == 0) quanThing = 1;
		    new getQuan, getLimit;
		    i_limit(playerid, fpick, getQuan, getLimit);
		    if(getQuan+fquan > getLimit)
		    {
		        format(string,sizeof(string),"{FF6347}У меня нет места в инвентаре\nЛимит для этого предмета: %d\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров", getLimit);
		        ErrorMessage(playerid, string);
				i_resetveshi(playerid);
				i_resettabs(playerid);
				return 1;
		    }
		}
	}
	
	// Покупка предмета
    if(JustOneThingInventory(fpick, thingType) && get_invent(playerid, fpick, thingType) > 0) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров");

    new put_inva = GiveThingPlayer(playerid, fpick, fquan, para, qara, thingType, thingPack, 9999); // Выдаём предмет игроку
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У меня нет места в инвентаре"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет

	if(quanThing == 1) // Отнимаем предмет (по количеству)
	{
    	PlayerInfo[seller][pMarkInvenQuan][inva] -= fquan;
		if(PlayerInfo[seller][pMarkInvenQuan][inva] <= 0) PlayerInfo[seller][pMarkInven][inva] = 0, PlayerInfo[seller][pMarkPrice][inva] = 0, PlayerInfo[seller][pMarkInvenPara][inva] = 0, PlayerInfo[seller][pMarkInvenQara][inva] = 0, PlayerInfo[seller][pMarkInvenType][inva] = 0, PlayerInfo[seller][pMarkInvenPack][inva] = 0;
	}
	else PlayerInfo[seller][pMarkInven][inva] = 0, PlayerInfo[seller][pMarkInvenQuan][inva] = 0, PlayerInfo[seller][pMarkPrice][inva] = 0, PlayerInfo[seller][pMarkInvenPara][inva] = 0, PlayerInfo[seller][pMarkInvenQara][inva] = 0, PlayerInfo[seller][pMarkInvenType][inva] = 0, PlayerInfo[seller][pMarkInvenPack][inva] = 0;
    PlayerInfo[seller][pM_Update][inva] = true;

	// Если предмет имеет количество, мы умножаем стоимость
	if(quanThing == 1) price = price*fquan;

    format(string,sizeof(string),"{99ff66}Вы приобрели: %s\n{cccccc}Стоимость: {99ff66}%d$ [%s]", GetNameThing(0, fpick, thingType, thingPack), price, get_k(price));
	SuccessMessage(playerid, string);
	oGivePlayerMoney(playerid, -price);
	oGivePlayerMoney(seller, price);
	payanim(playerid, 0); // Анимация передачи денег с появление бабла в руках

	SaveInvent(playerid, put_inva);
    updategoods(seller, inva);
    
    format(string,sizeof(string),"Купил: %s [%d$]",GetNameThing(1, fpick, thingType, thingPack), price);
	UserLog("buygoods", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[seller][pID], PlayerInfo[seller][pName], PlayerInfo[seller][pPlaIP], fquan, string);
    
    if(PlayerInfo[seller][pAchieve][22] == 0) AchievePlayer(seller, 22, 1);
	if(PlayerInfo[playerid][pAchieve][23] == 0) AchievePlayer(playerid, 23, 1);
	return 1;
}
stock use_goods(playerid, seller, inva)
{
    new fpick = PlayerInfo[seller][pMarkInven][inva], thingType = PlayerInfo[seller][pMarkInvenType][inva], thingPack = PlayerInfo[seller][pMarkInvenPack][inva];
    if(fpick == 0) return i_resettabs(playerid);
	if(PlayerInfo[seller][pMarkPrice][inva] == 0) return ErrorMessage(playerid, "{FF6347}Этот товар не продаётся [ Не установлена цена ]"), i_resettabs(playerid);
	
	new string[140];
	if(thingType == 0 && thingPack == 0)
	{
		if(CheckThingQuan(fpick) == 1)
		{
		    Veshi[playerid] = OnlineInfo[playerid][oInventSelectRight];
			format(string,sizeof(string),"{cccccc}Чтобы купить {ff9000}%s {cccccc}введите количество",GetNameThing(0, fpick, thingType, thingPack));
			ShowDialog(playerid,1106,DIALOG_STYLE_INPUT,"{ff9000}Торговля",string,"Принять","Отмена");
			return 1;
		}
	}
	DP[0][playerid] = 0;
	Veshi[playerid] = OnlineInfo[playerid][oInventSelectRight];
	format(string,sizeof(string),"{cccccc}Вы уверены, что хотите купить {ff9000}%s {cccccc}за {99ff66}%d$ [%s] {cccccc}?",GetNameThing(0, fpick, thingType, thingPack), PlayerInfo[seller][pMarkPrice][inva], get_k(PlayerInfo[seller][pMarkPrice][inva]));
	ShowDialog(playerid,1107,DIALOG_STYLE_MSGBOX,"{ff9000}Торговля",string,"Да","Нет");
	return 1;
}
stock put_goods(playerid, inva, fpick, quan, binva)
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || binva == 9999 || OnlineInfo[playerid][oInventSelectLeft] == 9999
	|| PlayerInfo[playerid][pInven][inva] <= 0 || PlayerInfo[playerid][pInven][inva] != fpick || PlayerInfo[playerid][pInvenQuan][inva] < quan) return 1;
	
	i_resetveshi(playerid);
	i_resettabs(playerid);
	if(Goods[playerid] == 0) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас перекладывать товары\n{cccccc}Откройте или арендуйте торговую лавку");
	
	new thingType = PlayerInfo[playerid][pInvenType][inva], thingPack = PlayerInfo[playerid][pInvenType][inva];

	if(NotGiveInflatabelBoat(playerid, fpick, thingType)) return i_resetveshi(playerid);
    if(NotGiveThing(fpick, thingType, PlayerInfo[playerid][pInvenQuan][inva])) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя передавать, продавать или убирать");
	if(PlayerInfo[playerid][pMarkInven][binva] > 0) return ErrorMessage(playerid, "{FF6347}Эта ячейка занята");

	// Кейс нельзя выбрасывать на 3 уровне и ниже
	if(IsNotGiveCase(playerid, thingPack)) return i_resetveshi(playerid);
	
	new put_inva = binva;
	PlayerInfo[playerid][pMarkInven][binva] = fpick;
	PlayerInfo[playerid][pMarkInvenQuan][binva] = quan;
	PlayerInfo[playerid][pMarkInvenPara][binva] = PlayerInfo[playerid][pInvenPara][inva];
	PlayerInfo[playerid][pMarkInvenQara][binva] = PlayerInfo[playerid][pInvenQara][inva];
	PlayerInfo[playerid][pMarkInvenType][binva] = PlayerInfo[playerid][pInvenType][inva];
	PlayerInfo[playerid][pMarkInvenPack][binva] = PlayerInfo[playerid][pInvenPack][inva];
	PlayerInfo[playerid][pMarkPrice][binva] = 0;
	PlayerInfo[playerid][pM_Update][binva] = true;
	
	new quanThing;
	if(thingType == 0 && thingPack == 0)
	{
	    if(CheckThingQuan(fpick) == 1) quanThing = 1;
	}
	if(quanThing == 1) take_away(playerid, quan, inva); // Отнимаем предмет (по количеству)
    else i_del(playerid, inva); // Отнимаем предмет (целиком)
	PlayerInfo[playerid][pI_Update][inva] = true;

    updategoods(playerid, binva);
	item_second(playerid, PlayerInfo[playerid][pMarkInven][binva], PlayerInfo[playerid][pMarkInvenQuan][binva], binva, 1, PlayerInfo[playerid][pMarkInvenPara][binva], PlayerInfo[playerid][pMarkInvenType][binva], PlayerInfo[playerid][pMarkInvenPack][binva], 0);
	return put_inva;
}
stock shift_goods(playerid, getinva, putinva)
{
	if(PlayerInfo[playerid][pMarkInven][getinva] == 0 || PlayerInfo[playerid][pMarkInven][putinva] != 0) return i_resettabs(playerid);
	new quanPlayer;
	foreach(Player,i)
	{
	    if(OnlineInfo[i][oLogged] == 0) continue;
	    if(OnlineInfo[i][oShowInterface] != 1) continue;
		if(Tabs_Load[i] != 1) continue;
	    if(OnlineInfo[i][oShowTabs] == 9999) continue;
		if(playerid == OnlineInfo[i][oShowTabs]) quanPlayer ++;
	}
	if(quanPlayer >= 1)
	{
		new string[90];
		format(string, sizeof(string), "{FF6347}Ваши товары просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer);
		ErrorMessage(playerid, string);
		i_resettabs(playerid);
		return 1;
	}
	PlayerInfo[playerid][pMarkInven][putinva] = PlayerInfo[playerid][pMarkInven][getinva];
	PlayerInfo[playerid][pMarkInvenQuan][putinva] = PlayerInfo[playerid][pMarkInvenQuan][getinva];
	PlayerInfo[playerid][pMarkInvenPara][putinva] = PlayerInfo[playerid][pMarkInvenPara][getinva];
	PlayerInfo[playerid][pMarkInvenQara][putinva] = PlayerInfo[playerid][pMarkInvenQara][getinva];
	PlayerInfo[playerid][pMarkPrice][putinva] = PlayerInfo[playerid][pMarkPrice][getinva];
	PlayerInfo[playerid][pMarkInvenType][putinva] = PlayerInfo[playerid][pMarkInvenType][getinva];
	PlayerInfo[playerid][pMarkInvenPack][putinva] = PlayerInfo[playerid][pMarkInvenPack][getinva];

	ClearMyGoods(playerid, getinva);
	PlayerInfo[playerid][pM_Update][putinva] = true;
	PlayerInfo[playerid][pM_Update][getinva] = true;
	i_resettabs(playerid);
	item_second(playerid, 0, 0, getinva, 1, 0, 0, 0, 0);
	item_second(playerid, PlayerInfo[playerid][pMarkInven][putinva], PlayerInfo[playerid][pMarkInvenQuan][putinva], putinva, 1, PlayerInfo[playerid][pMarkInvenPara][putinva], PlayerInfo[playerid][pMarkInvenType][putinva], PlayerInfo[playerid][pMarkInvenPack][putinva], 0);
	return 1;
}

// Сохраняем весь инвентарь
stock SaveMarkAll(playerid, bool:transaction = true)
{
	// Начало транзакции
	if(transaction == true) mysql_tquery(pearsq, "START TRANSACTION;");

	for(new i = 0; i < MAX_MARK; i++) SaveMark(playerid, i);

	// Завершение транзакции
	if(transaction == true) mysql_tquery(pearsq, "COMMIT;");
	return 1;
}

stock CreateJsonMark(playerid, i, &JsonNode:node)
{
	if(PlayerInfo[playerid][pMarkInven][i] == 0) 
	{
		node = JSON_INVALID_NODE;
		return 1;
	}

	node = JSON_Object(
		"id", JSON_Int(PlayerInfo[playerid][pMarkInven][i]),
		"quan", JSON_Int(PlayerInfo[playerid][pMarkInvenQuan][i]),
		"para", JSON_Int(PlayerInfo[playerid][pMarkInvenPara][i]),
		"qara", JSON_Int(PlayerInfo[playerid][pMarkInvenQara][i]),
		"type", JSON_Int(PlayerInfo[playerid][pMarkInvenType][i]),
		"pack", JSON_Int(PlayerInfo[playerid][pMarkInvenPack][i]),
		"price", JSON_Int(PlayerInfo[playerid][pMarkPrice][i])
	);
	return 1;
}

// Сохраняем одну ячейку товаров
stock SaveMark(playerid, i)
{
	new JsonNode:node;
	CreateJsonMark(playerid, i, node);
	SaveInventByUserID(PlayerInfo[playerid][pID], i, node, true);
	return 1;
}

stock IsAUpdateM(playerid)
{
	new up = 0;
	for(new i = 0; i < 20; i++)
	{
	    if(PlayerInfo[playerid][pM_Update][i] == true) up ++;
	}
	return up;
}
stock updategoods(seller, inva)
{
	foreach(Player,i)
	{
	    if(OnlineInfo[i][oLogged] == 0) continue;
	    if(OnlineInfo[i][oShowInterface] != 1) continue;
	    if(OnlineInfo[i][oShowTabs] != 9999 && OnlineInfo[i][oShowTabs] == seller || Tabs_Load[i] == 6 && i == seller) item_second(i, PlayerInfo[seller][pMarkInven][inva], PlayerInfo[seller][pMarkInvenQuan][inva], inva, 1, PlayerInfo[seller][pMarkInvenPara][inva], PlayerInfo[seller][pMarkInvenType][inva], PlayerInfo[seller][pMarkInvenPack][inva], 0);
	}
	return 1;
}
stock ClearMyGoods(playerid, i)
{
    PlayerInfo[playerid][pMarkInven][i] = 0;
	PlayerInfo[playerid][pMarkInvenQuan][i] = 0;
	PlayerInfo[playerid][pMarkInvenPara][i] = 0;
	PlayerInfo[playerid][pMarkInvenQara][i] = 0;
	PlayerInfo[playerid][pMarkInvenType][i] = 0;
	PlayerInfo[playerid][pMarkInvenPack][i] = 0;
	PlayerInfo[playerid][pMarkPrice][i] = 0;
	return 1;
}

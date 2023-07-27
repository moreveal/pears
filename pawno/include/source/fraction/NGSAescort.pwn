stock OrderEscort(playerid, g)
{
	DP[4][playerid] = g;
	new quan;
	format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"{cccccc}Счет фракции {99ff66}%d$ [%s] \t \t \n", OrganInfo[g][glave], get_k(OrganInfo[g][glave])), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Заказать боеприпасы {ff9000}>>\t \t \n"), strcat(lines,line);
	if(OrganInfo[g][gOrderStatus] == 0) format(line,sizeof(line),"{cccccc}Статус заказа \t {FF6347}[Unactive] \t \n"), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}Статус заказа \t {99ff66}[Active] \t \n"), strcat(lines,line);
    for(new i = 0; i < MAX_ORDERESCORT; i++)
	{
		List[i][playerid] = 0;
		if(OrganInfo[g][gOrder][i] == 0) continue;

		if(OrganInfo[g][gOrder][i] > 0)
		{
		    List[quan][playerid] = i;
			quan ++;
			format(line,sizeof(line),"{ff9000}%d. %s \t{cccccc}[Количество: %d] \t{9DF1B4}%d$\n", quan, GetNameThing(0, OrganInfo[g][gOrder][i], OrganInfo[g][gOrderType][i], 0), OrganInfo[g][gOrderQuan][i], getThingPriceGos(OrganInfo[g][gOrder][i], OrganInfo[g][gOrderType][i]) * OrganInfo[g][gOrderQuan][i]), strcat(lines,line);
		}
	}
	format(store,sizeof(store),"{ff9000}%s [%d]",frakeasyName[g], g);
	ShowDialog(playerid,1380,DIALOG_STYLE_TABLIST_HEADERS,store,lines,"Выбрать","Отмена");
	return 1;
}
stock InsertOrderEscort(playerid, g, ord)
{
    format(lines,sizeof(lines),""); // Очищаем Lines

	format(line,sizeof(line),"{ff9000}%s \t", GetNameThing(0, OrganInfo[g][gOrder][ord], OrganInfo[g][gOrderType][ord], 0)), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Количество: \t{ffffff}%d", OrganInfo[g][gOrderQuan][ord]), strcat(lines,line);
    format(line,sizeof(line),"\n{FF6347}Удалить\t "), strcat(lines,line);
	format(store,sizeof(store),"{ff9000}%s [%d]",frakeasyName[g], g);
	ShowDialog(playerid,1381,DIALOG_STYLE_TABLIST_HEADERS,store,lines,"Выбрать","Отмена");
	return 1;
}
stock CreateOrderEscort(playerid, g, ord, thingId, thingType, thingPrice)
{
	if(OrganInfo[g][glave] < thingPrice) return ErrorText(playerid, "{FF6347}На депозите бизнеса недостаточно средств"), OrderEscort(playerid, g);
	OrganInfo[g][gOrder][ord] = thingId;
	OrganInfo[g][gOrderQuan][ord] = 1;
	OrganInfo[g][gOrderType][ord] = thingType;
	SaveEscortOrder(g, ord);
	PlayerPlaySound(playerid,6401,0,0,0);
	InsertOrderEscort(playerid, g, ord);
	//BizLog("setorder", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], b, ord, GetNameThing(0, thingId, thingType,0));
	return 1;
}
stock ShowOrderThingEscort(playerid, g) // Меню заказа боеприпасов и оружия для законной организации
{
    format(lines,sizeof(lines),""); // Очищаем Lines

    new quan;
	format(line,sizeof(line),"Товар \tНа складе \tГос. стоимость"), strcat(lines,line);
    // Обычные предметы
    for(new i = 0; i < INVENTER; i++)
  	{
        if(IsSkladThing(i, 0))
        {
            List[quan][playerid] = i;
            ListParam[quan][playerid] = 0;
            quan ++;
            format(line,sizeof(line),"\n{ff9000}%s {333333}| %s \t{333333}%d/%d \t{99ff66}%d$", GetNameThing(0, i, 0, 0), getAmmoName(i), get_sklad(g,i,0), maxQuanThingProductEscort(i, 0), getThingPriceGos(i, 0)), strcat(lines,line);
        }
    }

    // Оружие
    for(new i = 0; i < 46; i++)
  	{
        if(IsSkladThing(i, 1))
        {
            List[quan][playerid] = i;
            ListParam[quan][playerid] = 1;
            quan ++;
            format(line,sizeof(line),"\n{cccccc}%s \t{333333}%d/%d \t{99ff66}%d$", GetNameThing(0, i, 1, 0), get_sklad(g, i, 1), maxQuanThingProductEscort(i, 1), getThingPriceGos(i, 1)), strcat(lines,line);
        }
    }

    List[quan][playerid] = 19142;
    ListParam[quan][playerid] = 2;
    quan ++;
    format(line,sizeof(line),"\n{ff9000}Бронежилет \t{333333}%d/%d \t{99ff66}%d$", get_sklad(g,19142,2), maxQuanThingProductEscort(19142, 1), getThingPriceGos(19142, 2)), strcat(lines,line);
    ShowDialog(playerid,1384,DIALOG_STYLE_TABLIST_HEADERS,"*",lines,"Выбор","Отмена");
    return 1;
}
stock getAmmoName(thingId) // Получаем название оружия, для которого принадлежит тип патрона
{
    // Учиытваем обычный патрон (Ammo) и взрывной (E Ammo)
    new name[9];
    if(thingId == 27 || thingId == 64) name = "Дробовик";
    else if(thingId == 28 || thingId == 65) name = "Пистолет";
    else if(thingId == 29 || thingId == 66) name = "Автомат";
    else if(thingId == 30 || thingId == 67) name = "Винтовка";
    return name;
}
stock IsSkladThing(thingId, thingType)
{
    if(thingType == 0) // Обычный предмет
    {
        if(thingId == 27 || thingId == 28 || thingId == 29 || thingId == 30) return 1;
    }
    if(thingType == 1) // Оружие
    {
        if(thingId == 24 || thingId == 25 || thingId == 26 || thingId == 30 || thingId == 31 || thingId == 33 
        || thingId == 34 || thingId == 3 || thingId == 8) return 1;
    }
    if(thingType == 2) // Аксессуар
    {
        if(IsArmor(thingId)) return 1;
    }
	return 0;
}
stock getThingHaveQuanOrderEscort(g, thingId, thingType)
{
	new stop;
	for(new i = 0; i < MAX_ORDERESCORT; i++)
	{
		if(OrganInfo[g][gOrder][i] == thingId && OrganInfo[g][gOrderType][i] == thingType)
		{
			stop ++;
		}
	}
	return stop;
}
stock maxQuanThingProductEscort(thingId, thingType)
{
	new maxQuan;
	if(thingType == 0)
	{
		maxQuan = 10000;
	}
	else maxQuan = 100; 
	return maxQuan;
}
stock putThingBizzProductEscort(g, thingId, thingType, thingQuan)
{
	/*for(new i = 0; i < MAX_BIZ_ITEM; i++)
    {
		if(BizzInfo[b][bTypeProduct][i] == thingType)
		{
			if(BizzInfo[b][bProduct][i] == thingId) BizzInfo[b][bItem][i] += thingQuan;
		}
	}*/
	return 1;
}

stock getThingQuanItemBizzEscort(g, thingId, thingType)
{
	new quan;
	/*for(new i = 0; i < 50; i++)
    {
        if(BizzInfo[b][bProduct][i] == thingId) 
        {
            quan = BizzInfo[b][bItem][i];
            break;
        }
    }*/
	return quan;
}
stock delproductEscort(g, ord) // Удаляем заказ доставки товара в бизнесы
{
	OrganInfo[g][gOrder][ord] = 0;
    OrganInfo[g][gOrderQuan][ord] = 0;
    OrganInfo[g][gOrderType][ord] = 0;
    SaveEscortOrder(g, ord);
    Orders --;
}
stock SaveEscortOrder(idx, ord)
{
	if(ord >= 0 && ord <= 10)
	{
		format(big_query, sizeof(big_query), "UPDATE `pp_organization` SET `Order%d`='%d',`OrderQuan%d`='%d',`OrderType%d`='%d' WHERE `newid` = '%d'", ord, OrganInfo[idx][gOrder][ord], ord, OrganInfo[idx][gOrderQuan][ord], ord, OrganInfo[idx][gOrderType][ord], idx);
		query_empty(pearsq_2, big_query);
	}
  	return 1;
}
stock getFreeOrderSlotEscort(g)
{
	new ordId = -1;
	for(new i = 0; i < MAX_ORDERESCORT; i++) // Ищем свободный слот заказа
	{
		if(OrganInfo[g][gOrder][i] == 0) // Нашли
		{
			ordId = i; // Передали id свободного слота в переменную
			break;
		}
	}
	return ordId;
}
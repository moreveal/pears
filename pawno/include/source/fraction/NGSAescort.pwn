stock OrderEscort(playerid, g)
{
	new quan;
	format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"{cccccc}Счет фракции {99ff66}%d$ [%s] \t \t \n", OrganInfo[g][glave], get_k(OrganInfo[g][glave])), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Заказать боеприпасы {ff9000}>>\t \t \n"), strcat(lines,line);
	if(OrganInfo[g][gOrderStatus] == 0) format(line,sizeof(line),"{cccccc}Статус заказа \t {FF6347}[Unactive] \t \n"), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}Статус заказа \t {99ff66}[Active] \t \n"), strcat(lines,line);
    for(new i = 0; i < 50; i++)
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
	ShowDialog(playerid,1380,DIALOG_STYLE_TABLIST,store,lines,"Выбрать","Отмена");
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
	//SaveBizzOrder(b, ord);
	//Orders ++, OrganInfo[g][gOrders] ++;
	PlayerPlaySound(playerid,6401,0,0,0);
	InsertOrderEscort(playerid, g, ord);
	//BizLog("setorder", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], b, ord, GetNameThing(0, thingId, thingType,0));
	return 1;
}
stock ShowOrderThingEscort(playerid, g)
{
	format(lines,sizeof(lines),""); // Очищаем Lines
    new lol[84], quan;

    format(line,sizeof(line),"Товар \t На складе \t Гос. стоимость\n"), strcat(lines,line);
    for(new i = 0; i < MAX_BIZ_ITEM; i++)
    {
        List[i][playerid] = 0;

        //if (OrganInfo[g][gProduct][i] == 0) break;
        List[quan][playerid] = i;
      //  format(line,sizeof(line),"{cccccc}%s \t {444444}%d/%d  \t {99FF66}[%d$]\n",GetNameThing(0, BizzInfo[b][bProduct][i], BizzInfo[b][bTypeProduct][i], 0), BizzInfo[b][bItem][i],maxQuanThingProduct(BizzInfo[b][bProduct][i], BizzInfo[b][bTypeProduct][i]), getThingPriceGos(BizzInfo[b][bProduct][i], BizzInfo[b][bTypeProduct][i])), strcat(lines,line);
        quan++;
    }		
    format(lol,sizeof(lol),"{ff9000}%s [%d]",frakeasyName[g], g);
    ShowDialog(playerid,1384,DIALOG_STYLE_TABLIST_HEADERS,lol,lines,"Выбрать","Отмена");
	return 1;
}
stock getThingHaveQuanOrderEscort(g, thingId, thingType)
{
	new stop;
	for(new i = 0; i < 50; i++)
	{
		if(OrganInfo[g][gOrder][i] == thingId && OrganInfo[g][gOrderType][i] == thingType)
		{
			stop ++;
		}
	}
	return stop;
}
stock getFreeOrderSlotEscort(g)
{
	new ordId = -1;
	for(new i = 0; i < 50; i++)
	{
		if(OrganInfo[g][gOrder][i] == 0)
		{
			ordId = i;
			break;
		}
	}
	return ordId;
}
stock maxQuanThingProductEscort(thingId, thingType)
{
	new maxQuan;
	if(thingType == 0)
	{
		maxQuan = 10000;
	}
	else maxQuan = 1000; 
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

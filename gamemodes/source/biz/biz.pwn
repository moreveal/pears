
#define MAX_BIZ_TYPE 24 // Типы бизнесов (заправки, супермаркеты, магазы и т.д.)
new dyn_zone_zzBiz[MAX_BIZ];

// Бизнесы Аренды
#define MAX_BIZ_TERM 46
new Float:RentPos_X[MAX_BIZ_TERM][MAX_TERMINAL_BIZ], Float:RentPos_Y[MAX_BIZ_TERM][MAX_TERMINAL_BIZ], Float:RentPos_Z[MAX_BIZ_TERM][MAX_TERMINAL_BIZ];
new Float:RentPos_RX[MAX_BIZ_TERM][MAX_TERMINAL_BIZ];
new Float:RentPos_RY[MAX_BIZ_TERM][MAX_TERMINAL_BIZ], Float:RentPos_RZ[MAX_BIZ_TERM][MAX_TERMINAL_BIZ], RentObject[MAX_BIZ_TERM][MAX_TERMINAL_BIZ];
new Text3D:RentLabel[MAX_BIZ_TERM][MAX_TERMINAL_BIZ], RentStat[MAX_BIZ_TERM][MAX_TERMINAL_BIZ]; // Позиция аренды и самого Объекта
new RentPickup[MAX_BIZ_TERM][MAX_TERMINAL_BIZ], bool:RentPickupStat[MAX_BIZ_TERM][MAX_TERMINAL_BIZ];
new BizIcon[MAX_BIZ];


new cityName[][] =
{
    "Los Santos", "San Fierro", "Las Venturas"
};

CMD:gototerm(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 3) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Телепортироваться к терминалу бизнеса [ /gototerm Бизнес Терминал ]");
	if(params[0] >= 42 && params[0] <= 52 || params[0] >= 62 && params[0] <= 76 || params[0] >= 163 && params[0] <= 172)
	{
	    if(params[1] < 1 || params[1] > 5) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Номер терминала не меньше 1 - 5");
	    new br = numnrent(params[0]);
	    if(RentStat[br][params[1]-1] <= 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: У бизнеса нет терминала под этим номером");
		PPSetPlayerPos(playerid,RentPos_X[br][params[1]-1],RentPos_Y[br][params[1]-1],RentPos_Z[br][params[1]-1]);
		S_SetPlayerVirtualWorld(playerid,0,0), SetPlayerInterior(playerid,0);
	}
	else SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: У этого бизнеса нет терминалов");
	return 1;
}

CMD:bizcity(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить город бизнеса [ /bizcity BizID 0 LS, 1 SF, 2 LV ]");
	if(params[0] <= 0 || params[0] > 200) return ErrorMessage(playerid, "{FF6347}Номер бизнеса не меньше 1 и не больше 200");
	if(params[1] > 2 || params[1] < 0) return ErrorMessage(playerid, "{FF6347}Города 0 - LS, 1 - SF, 2 - LV");

	new string[90];
	format(string, sizeof(string), " [ ADM ]: %s изменил город бизнеса № %d {cccccc}[%s]", PlayerInfo[playerid][pName],params[0],cityName[params[1]]);
	ABroadCast(COLOR_ADM,string,1);
	BizzInfo[params[0]][bCity] = params[1];
	SaveBizzCity(params[0]);
	return 1;
}

stock productbiz(playerid, b) // Заказ товаров в бизнес
{
	new quan;
	new line[100],lines[4048];
    format(line,sizeof(line),"{cccccc}Депозит {99ff66}%d$ [%s] \t \t \n", BizzInfo[b][bDeposit], get_k(BizzInfo[b][bDeposit])), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Заказать товар {ff9000}>>\t \t \n"), strcat(lines,line);
	if(BizzInfo[b][bOrderStatus] == 0) format(line,sizeof(line),"{cccccc}Статус заказа \t {FF6347}[Unactive] \t \n"), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}Статус заказа \t {99ff66}[Active] \t \n"), strcat(lines,line);
	format(line,sizeof(line),"{cccccc}Оплата доставки товаров\t {99ff66}%d$ {cccccc}[%s] \t \n", BizzInfo[b][bDeliveryPay], get_k(BizzInfo[b][bDeliveryPay])), strcat(lines,line);
    for(new i = 0; i < 50; i++)
	{
		List[i][playerid] = 0;
		if(BizzInfo[b][bOrder][i] == 0) continue;

		if(BizzInfo[b][bOrder][i] > 0)
		{
		    List[quan][playerid] = i;
			quan ++;
			format(line,sizeof(line),"{ff9000}%d. %s \t{cccccc}[Количество: %d] \t{9DF1B4}%d$\n", quan, GetNameThing(0, BizzInfo[b][bOrder][i], BizzInfo[b][bOrderType][i], 0), BizzInfo[b][bOrderQuan][i], getThingPriceGos(BizzInfo[b][bOrder][i], BizzInfo[b][bOrderType][i]) * BizzInfo[b][bOrderQuan][i]), strcat(lines,line);
		}
	}
	new header[90];
	format(header,sizeof(header),"{cccccc}Бизнес {ff9000}%s [%d]",bizname(b), b);
	ShowDialog(playerid,1054,DIALOG_STYLE_TABLIST,header,lines,"Выбрать","Отмена");
	return 1;
}
stock insertorder(playerid, b, ord) // Управление заказом доставки товара
{
    new line[90],lines[270];
	format(line,sizeof(line),"{444444}Товар: {ff9000}%s \t", GetNameThing(0, BizzInfo[b][bOrder][ord], BizzInfo[b][bOrderType][ord], 0)), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Количество: \t{ffffff}%d", BizzInfo[b][bOrderQuan][ord]), strcat(lines,line);
    format(line,sizeof(line),"\n{FF6347}Удалить товар\t "), strcat(lines,line);
	new header[90];
	format(header,sizeof(header),"{cccccc}Бизнес {ff9000}%s [%d]",bizname(b), b);
	ShowDialog(playerid,1058,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Выбрать","Отмена");
	return 1;
}
stock createorder(playerid, b, ord, thingId, thingType, thingPrice)
{
	if(BizzInfo[b][bDeposit] < thingPrice) return ErrorText(playerid, "{FF6347}На депозите бизнеса недостаточно средств"), productbiz(playerid, b);
	BizzInfo[b][bOrder][ord] = thingId;
	BizzInfo[b][bOrderQuan][ord] = 1;
	BizzInfo[b][bOrderType][ord] = thingType;
	SaveBizzOrder(b, ord);
	Orders ++, BizzInfo[b][bOrders] ++;
	PlayerPlaySound(playerid,6401,0,0,0);
	insertorder(playerid, b, ord);
	BizLog("setorder", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], b, ord, GetNameThing(0, thingId, thingType,0));
	return 1;
}
stock AddThingToOrder(playerid, b, thingId, thingType)
{
	if(BizzInfo[b][bDeliveryOrder] >= 0) return ErrorText(playerid, "{FF6347}Нельзя добавить товар, доставку выполняет дальнобойщик"), productbiz(playerid, b);
	
	new ordId = getFreeOrderSlot(b);
	if(ordId == -1) return ErrorText(playerid, "{FF6347}Нет свободных слотов для заказа товаров [ Лимит: 50 ]"), productbiz(playerid, b);

	new orderQuan = getThingHaveQuanOrder(b, thingId, thingType);
	if(orderQuan > 0) return ErrorText(playerid, "{FF6347}Этот товар уже добавлен для доставки [ Вы можете указать количество ]"), productbiz(playerid, b);

	// Получаем максимальное количество для этого предмета
	new maxQuan = maxQuanThingProduct(thingId, thingType);

	// Проверка на лимиты
	new realQuan = getThingQuanItemBizz(b, thingId, thingType); // Получаем количество товаров уже в бизнесе

	if(realQuan+1 > maxQuan)
	{
		new string[60];
		format(string, sizeof(string), "{FF6347}Нет места для этого товара. Лимит: %d", maxQuan);
		ErrorText(playerid, string);
		productbiz(playerid, b);
		return 1;
	}

	new thingPrice = getThingPriceGos(thingId, thingType) + getPayOrderDelivery(b); // Вычисляем стоимость товара и стоимость доставки по километражу
	createorder(playerid, b, ordId, thingId, thingType, thingPrice);
	return 1;
}
stock ShowOrderThing(playerid, b)
{
	if(b <= 12) // Заправка
	{
		new line[100],lines[100];
		format(line,sizeof(line),"{ff9000}Топливо {cccccc}[10.000 Литров]\t {99ff66}[%d$]\n",getThingPriceGos(178, 0) * 10000), strcat(lines,line);
		new header[90];
		format(header,sizeof(header),"{cccccc}Бизнес {ff9000}%s [%d]",bizname(b), b);
		ShowDialog(playerid,1059,DIALOG_STYLE_TABLIST,header,lines,"Выбрать","Отмена");
	}
	else if(b >= 13 && b <= 41 || b >= 77 && b <= 92 || b >= 93 && b <= 162 || b >= 183 && b <= 200)
	{
		new quan;
		new line[100],lines[4048];
		format(line,sizeof(line),"Товар \t На складе \t Гос. стоимость\n"), strcat(lines,line);
		for(new i = 0; i < MAX_BIZ_ITEM; i++)
		{
			List[i][playerid] = 0;
			if(b >= 103 && b <= 122 || b >= 153 && b <= 162) // Закусочные, Рестораны, Ларьки с едой
			{
				if (BizzInfo[b][bWare][i] == 0) break;
				List[quan][playerid] = i;
				format(line,sizeof(line),"{cccccc}%s \t {444444}%d/%d \t {99FF66}[%d$]\n",GetNameThing(0, BizzInfo[b][bWare][i], 0, 0), BizzInfo[b][bItem][i],maxQuanThingProduct(BizzInfo[b][bWare][i], BizzInfo[b][bTypeProduct][i]), getThingPriceGos(BizzInfo[b][bWare][i], 0)), strcat(lines,line);
			}
			else
			{
				if (BizzInfo[b][bProduct][i] == 0) break;
				List[quan][playerid] = i;
				format(line,sizeof(line),"{cccccc}%s \t {444444}%d/%d  \t {99FF66}[%d$]\n",GetNameThing(0, BizzInfo[b][bProduct][i], BizzInfo[b][bTypeProduct][i], 0), BizzInfo[b][bItem][i],maxQuanThingProduct(BizzInfo[b][bProduct][i], BizzInfo[b][bTypeProduct][i]), getThingPriceGos(BizzInfo[b][bProduct][i], BizzInfo[b][bTypeProduct][i])), strcat(lines,line);
			}
			quan++;
		}	
		new header[90];	
		format(header,sizeof(header),"{cccccc}Бизнеc {ff9000}%s [%d]",bizname(b), b);
		ShowDialog(playerid,1059,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Выбрать","Отмена");
	}
	else if(b >= 173 && b <= 182) // Магазин Одежды
	{
		new header[90];
		format(header,sizeof(header),"{cccccc}Бизнес {ff9000}%s [%d]",bizname(b), b);
		ShowDialog(playerid,1059,DIALOG_STYLE_TABLIST,header,"{ff9000}Одежда\n{ff9000}Аксессуары","Выбрать","Отмена");
	}
	return 1;
}
stock getThingHaveQuanOrder(b, thingId, thingType) // Проверка, имеется ли уже такой товар в текущем заказе на доставку
{
	new stop;
	for(new i = 0; i < 50; i++)
	{
		if(BizzInfo[b][bOrder][i] == thingId && BizzInfo[b][bOrderType][i] == thingType)
		{
			stop ++;
		}
	}
	return stop;
}
stock getFreeOrderSlot(b)
{
	new ordId = -1;
	for(new i = 0; i < 50; i++) // Ищем свободный слот заказа
	{
		if(BizzInfo[b][bOrder][i] == 0) // Нашли
		{
			ordId = i; // Передали id свободного слота в переменную
			break;
		}
	}
	return ordId;
}
stock getPayOrderDelivery(b) // Расчитываем стоимость оплаты доставки в бизнес за километр
{
	new Float:dist, pay;
	if(b <= 12) dist = GetDistancePoint(2533.0725,2789.3311,10.8203, BizzInfo[b][bX],BizzInfo[b][bY],BizzInfo[b][bZ]); // Доставка к заправкам (С нефтеперерабатывающего)
	else dist = GetDistancePoint(2265.3845,2796.5225,10.8203, BizzInfo[b][bX],BizzInfo[b][bY],BizzInfo[b][bZ]); // Доставка к прочим бизнеса (С гос. склада)
	pay = (floatround(dist, floatround_round)/1000) * ServerInfo[11];
	if(pay <= 0) pay = ServerInfo[11];
	return pay; 
}
stock maxQuanThingProduct(thingId, thingType) // Подсчет максимального количество товаров в бизнесе
{
	new maxQuan;
	if(thingType == 0) // Обычные Предметы
	{
		if(thingId == 178) maxQuan = 50000; // Топливо
		else if(thingId >= 27 && thingId <= 30) maxQuan = 10000; // Патроны
		else maxQuan = 1000; 
	}
	else if(thingType == 5) maxQuan = 40; // Транспорт
	else maxQuan = 1000; 
	return maxQuan;
}
stock putThingBizzProduct(b, thingId, thingType, thingQuan) // Кладём товары по ячейкам (В доставке)
{
	for(new i = 0; i < MAX_BIZ_ITEM; i++)
    {
		if(BizzInfo[b][bTypeProduct][i] == thingType) // Если тип совпадает
		{
			if(b >= 103 && b <= 122 || b >= 153 && b <= 162) // У магазов с хавкой, товары формируются из продуктов
			{
				if(BizzInfo[b][bWare][i] == thingId) BizzInfo[b][bItem][i] += thingQuan;
			}
			else // Прочие бизы
			{
				if(BizzInfo[b][bProduct][i] == thingId) BizzInfo[b][bItem][i] += thingQuan;
			}
		}
	}
	return 1;
}

stock getThingQuanItemBizz(b, thingId, thingType) // Получаем количество одного товара в бизнесе по id и типу
{
	new quan;
	if(b >= 173 && b <= 182) // Магазины с одеждой
	{
		new bn = b-173;
		if(thingType == 2) // Аксессуары
		{
			for(new as = 0; as < 100; as++)
			{
				if(AksesItem[bn][as] == thingId)
				{
					quan = AksesQuan[bn][as];
					break;
				}
			}
		}
		else if(thingType == 3) // Одежда
		{
			for(new as = 0; as < 50; as++)
			{
				if(StoreItem[bn][as] == thingId)
				{
					quan = StoreQuan[bn][as];
					break;
				}
			}
		}
	}
	else
	{
		for(new i = 0; i < 50; i++)
		{
			if(b >= 103 && b <= 122 || b >= 153 && b <= 162) // Закусочные, Рестораны, Ларьки с едой
			{
				if(BizzInfo[b][bWare][i] == thingId) 
				{
					quan = BizzInfo[b][bItem][i];
					break;
				}
			}
			else // Прочие бизнесы
			{
				if(BizzInfo[b][bProduct][i] == thingId) 
				{
					quan = BizzInfo[b][bItem][i];
					break;
				}
			}
		}
	}
	return quan;
}

stock LoadBusinessProduct(b, stat) // Если нет продукта (значит первый запуск бизнеса, устанавливаем продукты)
{
    new bool:yes[MAX_BIZ_ITEM], bool:yesUpdate;
    if(b <= 12) // Заправки
	{
	    // Тип товара (0 обычный, 1 оружие, 2 аксессуар, 3 одежда, 4 мебель, 5 машина)
	    if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 178, BizzInfo[b][bTypeProduct][0] = 0, yes[0] = true; // Топливо
	}
	if(b >= 13 && b <= 26) // Супермаркеты
	{
	    if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 46, BizzInfo[b][bTypeProduct][0] = 1, yes[0] = true; // Парашют
	    if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 13, BizzInfo[b][bTypeProduct][1] = 0, yes[1] = true; // Верёвка
	    if(BizzInfo[b][bProduct][2] == 0 || stat == 1) BizzInfo[b][bProduct][2] = 19, BizzInfo[b][bTypeProduct][2] = 0, yes[2] = true; // Отмычки
	    if(BizzInfo[b][bProduct][3] == 0 || stat == 1) BizzInfo[b][bProduct][3] = 41, BizzInfo[b][bTypeProduct][3] = 0, yes[3] = true; // Бенгальские Свечи
	    if(BizzInfo[b][bProduct][4] == 0 || stat == 1) BizzInfo[b][bProduct][4] = 5, BizzInfo[b][bTypeProduct][4] = 1, yes[4] = true; // Бита
	    if(BizzInfo[b][bProduct][5] == 0 || stat == 1) BizzInfo[b][bProduct][5] = 2, BizzInfo[b][bTypeProduct][5] = 0, yes[5] = true; // Золотое Кольцо
	    if(BizzInfo[b][bProduct][6] == 0 || stat == 1) BizzInfo[b][bProduct][6] = 24, BizzInfo[b][bTypeProduct][6] = 0, yes[6] = true; // Шашка Таксиста
	    if(BizzInfo[b][bProduct][7] == 0 || stat == 1) BizzInfo[b][bProduct][7] = 14, BizzInfo[b][bTypeProduct][7] = 1, yes[7] = true; // Цветы
	    if(BizzInfo[b][bProduct][8] == 0 || stat == 1) BizzInfo[b][bProduct][8] = 39, BizzInfo[b][bTypeProduct][8] = 0, yes[8] = true; // Подарочная Упаковка
	    if(BizzInfo[b][bProduct][9] == 0 || stat == 1) BizzInfo[b][bProduct][9] = 40, BizzInfo[b][bTypeProduct][9] = 0, yes[9] = true; // Феиерверк
	    if(BizzInfo[b][bProduct][10] == 0 || stat == 1) BizzInfo[b][bProduct][10] = 88, BizzInfo[b][bTypeProduct][10] = 0, yes[10] = true; // Семена Травы
	    if(BizzInfo[b][bProduct][11] == 0 || stat == 1) BizzInfo[b][bProduct][11] = 16, BizzInfo[b][bTypeProduct][11] = 0, yes[11] = true; // Пачка Сигарет
	    if(BizzInfo[b][bProduct][12] == 0 || stat == 1) BizzInfo[b][bProduct][12] = 38, BizzInfo[b][bTypeProduct][12] = 0, yes[12] = true; // Бокал
	    if(BizzInfo[b][bProduct][13] == 0 || stat == 1) BizzInfo[b][bProduct][13] = 23, BizzInfo[b][bTypeProduct][13] = 0, yes[13] = true; // Мешок
	    if(BizzInfo[b][bProduct][14] == 0 || stat == 1) BizzInfo[b][bProduct][14] = 1, BizzInfo[b][bTypeProduct][14] = 0, yes[14] = true; // Хлеб
	    if(BizzInfo[b][bProduct][15] == 0 || stat == 1) BizzInfo[b][bProduct][15] = 37, BizzInfo[b][bTypeProduct][15] = 0, yes[15] = true; // Шампанское
	    if(BizzInfo[b][bProduct][16] == 0 || stat == 1) BizzInfo[b][bProduct][16] = 14, BizzInfo[b][bTypeProduct][16] = 0, yes[16] = true; // Пиво
	    if(BizzInfo[b][bProduct][17] == 0 || stat == 1) BizzInfo[b][bProduct][17] = 52, BizzInfo[b][bTypeProduct][17] = 0, yes[17] = true; // Угли
	    if(BizzInfo[b][bProduct][18] == 0 || stat == 1) BizzInfo[b][bProduct][18] = 53, BizzInfo[b][bTypeProduct][18] = 0, yes[18] = true; // Зажигалка
	    if(BizzInfo[b][bProduct][19] == 0 || stat == 1) BizzInfo[b][bProduct][19] = 97, BizzInfo[b][bTypeProduct][19] = 0, yes[19] = true; // Кухонный Нож
	    if(BizzInfo[b][bProduct][20] == 0 || stat == 1) BizzInfo[b][bProduct][20] = 163, BizzInfo[b][bTypeProduct][20] = 0, yes[20] = true; // Свадебный Торт
		if(BizzInfo[b][bProduct][21] == 0 || stat == 1) BizzInfo[b][bProduct][21] = 181, BizzInfo[b][bTypeProduct][21] = 0, yes[21] = true; // Изолента
		if(BizzInfo[b][bProduct][22] == 0 || stat == 1) BizzInfo[b][bProduct][22] = 197, BizzInfo[b][bTypeProduct][22] = 0, yes[22] = true; // Балончик
		if(BizzInfo[b][bProduct][23] == 0 || stat == 1) BizzInfo[b][bProduct][23] = 168, BizzInfo[b][bTypeProduct][23] = 0, yes[23] = true; // Упаковка с мясом
	}
	else if(b >= 27 && b <= 41) // Оружейный Магазин
	{
    	if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 27, BizzInfo[b][bTypeProduct][0] = 0, yes[0] = true; // Ammo 20,8mm
    	if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 28, BizzInfo[b][bTypeProduct][1] = 0, yes[1] = true; // Ammo 11,43mm
    	if(BizzInfo[b][bProduct][2] == 0 || stat == 1) BizzInfo[b][bProduct][2] = 29, BizzInfo[b][bTypeProduct][2] = 0, yes[2] = true; // Ammo 5,45mm
    	if(BizzInfo[b][bProduct][3] == 0 || stat == 1) BizzInfo[b][bProduct][3] = 30, BizzInfo[b][bTypeProduct][3] = 0, yes[3] = true; // Ammo 45mm
    	if(BizzInfo[b][bProduct][4] == 0 || stat == 1) BizzInfo[b][bProduct][4] = 24, BizzInfo[b][bTypeProduct][4] = 1, yes[4] = true; // Deagle
    	if(BizzInfo[b][bProduct][5] == 0 || stat == 1) BizzInfo[b][bProduct][5] = 25, BizzInfo[b][bTypeProduct][5] = 1, yes[5] = true; // Дробовик
    	if(BizzInfo[b][bProduct][6] == 0 || stat == 1) BizzInfo[b][bProduct][6] = 27, BizzInfo[b][bTypeProduct][6] = 1, yes[6] = true; // Скорострельный Дробовик
    	if(BizzInfo[b][bProduct][7] == 0 || stat == 1) BizzInfo[b][bProduct][7] = 30, BizzInfo[b][bTypeProduct][7] = 1, yes[7] = true; // AK-47
    	if(BizzInfo[b][bProduct][8] == 0 || stat == 1) BizzInfo[b][bProduct][8] = 31, BizzInfo[b][bTypeProduct][8] = 1, yes[8] = true; // M4
    	if(BizzInfo[b][bProduct][9] == 0 || stat == 1) BizzInfo[b][bProduct][9] = 33, BizzInfo[b][bTypeProduct][9] = 1, yes[9] = true; // Винтовка
		if(BizzInfo[b][bProduct][10] == 0 || stat == 1) BizzInfo[b][bProduct][10] = 22, BizzInfo[b][bTypeProduct][10] = 1, yes[10] = true; // Colt
		if(BizzInfo[b][bProduct][11] == 0 || stat == 1) BizzInfo[b][bProduct][11] = 29, BizzInfo[b][bTypeProduct][11] = 1, yes[11] = true; // MP5
		if(BizzInfo[b][bProduct][12] == 0 || stat == 1) BizzInfo[b][bProduct][12] = 28, BizzInfo[b][bTypeProduct][12] = 1, yes[12] = true; // Uzi
		if(BizzInfo[b][bProduct][13] == 0 || stat == 1) BizzInfo[b][bProduct][13] = 32, BizzInfo[b][bTypeProduct][13] = 1, yes[13] = true; // Tec 9
	}
	else if(b >= 42 && b <= 52) // Аренда Автомобилей
	{
		if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 410, BizzInfo[b][bTypeProduct][0] = 5, yes[0] = true; // MANANA
		if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 401, BizzInfo[b][bTypeProduct][1] = 5, yes[1] = true; // Bravura
		if(BizzInfo[b][bProduct][2] == 0 || stat == 1) BizzInfo[b][bProduct][2] = 479, BizzInfo[b][bTypeProduct][2] = 5, yes[2] = true; // regina
		if(BizzInfo[b][bProduct][3] == 0 || stat == 1) BizzInfo[b][bProduct][3] = 516, BizzInfo[b][bTypeProduct][3] = 5, yes[3] = true; // nebula
		if(BizzInfo[b][bProduct][4] == 0 || stat == 1) BizzInfo[b][bProduct][4] = 547, BizzInfo[b][bTypeProduct][4] = 5, yes[4] = true; // primo
	}
	else if(b >= 62 && b <= 66) // Аренда Мото
	{
		if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 461, BizzInfo[b][bTypeProduct][0] = 5, yes[0] = true; // PCJ 600
		if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 468, BizzInfo[b][bTypeProduct][1] = 5, yes[1] = true; // sanchez
		if(BizzInfo[b][bProduct][2] == 0 || stat == 1) BizzInfo[b][bProduct][2] = 471, BizzInfo[b][bTypeProduct][2] = 5, yes[2] = true; // Quad
		if(BizzInfo[b][bProduct][3] == 0 || stat == 1) BizzInfo[b][bProduct][3] = 581, BizzInfo[b][bTypeProduct][3] = 5, yes[3] = true; // BF-400
		if(BizzInfo[b][bProduct][4] == 0 || stat == 1) BizzInfo[b][bProduct][4] = 586, BizzInfo[b][bTypeProduct][4] = 5, yes[4] = true; // Wayfarer
	}
	else if(b >= 67 && b <= 76) // Аренда Скутеров
	{
		if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 462, BizzInfo[b][bTypeProduct][0] = 5, yes[0] = true; // Fagio
	}

	else if(b >= 77 && b <= 81 || b >= 82 && b <= 86 || b >= 87 && b <= 89 || b >= 90 && b <= 92) // Автосалоны, Мотосалоны, Ависалоны, Салоны Катеров
	{
		for(new s = 0; s < MAX_BIZ_ITEM; s++) BizzInfo[b][bProduct][s] = 0; // Очищаем все слоты, перед перезагрузкой

		new slot;

		// Custom Vehicle
		for(new v = 0; v < sizeof(vehNameCustom); v++)
		{
			if(slot >= MAX_BIZ_ITEM) break;

			if(ForBizVehicleClassAndType(b, GetVehicleType(v + 2000), GetVehicleClass(v + 2000)))
			{
				BizzInfo[b][bProduct][slot] = v + 2000, BizzInfo[b][bTypeProduct][slot] = 5, yes[slot] = true;
				slot ++;
			}
		}

		// Обычный Транспорт
		for(new v = 400; v < MAX_VEHICLE_ID; v++)
		{
			if(slot >= MAX_BIZ_ITEM) break;

			if(ForBizVehicleClassAndType(b, GetVehicleType(v), GetVehicleClass(v)))
			{
				BizzInfo[b][bProduct][slot] = v, BizzInfo[b][bTypeProduct][slot] = 5, yes[slot] = true;
				slot ++;
			}
		}
	}

	else if(b >= 93 && b <= 102) // Клубы
	{
    	if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 14, BizzInfo[b][bTypeProduct][0] = 0, yes[0] = true; // пиво
    	if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 113, BizzInfo[b][bTypeProduct][1] = 0, yes[1] = true; // вино бокал
    	if(BizzInfo[b][bProduct][2] == 0 || stat == 1) BizzInfo[b][bProduct][2] = 37, BizzInfo[b][bTypeProduct][2] = 0, yes[2] = true; // шампанское бокал
    	if(BizzInfo[b][bProduct][3] == 0 || stat == 1) BizzInfo[b][bProduct][3] = 114, BizzInfo[b][bTypeProduct][3] = 0, yes[3] = true; // виски бокал
    	if(BizzInfo[b][bProduct][4] == 0 || stat == 1) BizzInfo[b][bProduct][4] = 115, BizzInfo[b][bTypeProduct][4] = 0, yes[4] = true; // коньяк бокал
    	if(BizzInfo[b][bProduct][5] == 0 || stat == 1) BizzInfo[b][bProduct][5] = 116, BizzInfo[b][bTypeProduct][5] = 0, yes[5] = true; // брэнди бокал
    	if(BizzInfo[b][bProduct][6] == 0 || stat == 1) BizzInfo[b][bProduct][6] = 112, BizzInfo[b][bTypeProduct][6] = 0, yes[6] = true; // Водка
	}
	else if(b >= 103 && b <= 122) // Закусочные, Рестораны
	{
		if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 121, BizzInfo[b][bTypeProduct][0] = 0, yes[0] = true; //  Кофе
    	if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 124, BizzInfo[b][bTypeProduct][1] = 0, yes[1] = true; // Sprunk Стакан
    	if(BizzInfo[b][bProduct][2] == 0 || stat == 1) BizzInfo[b][bProduct][2] = 120, BizzInfo[b][bTypeProduct][2] = 0, yes[2] = true; // Sprunk Банка
    	if(BizzInfo[b][bProduct][3] == 0 || stat == 1) BizzInfo[b][bProduct][3] = 125, BizzInfo[b][bTypeProduct][3] = 0, yes[3] = true; // Бургер
    	if(BizzInfo[b][bProduct][4] == 0 || stat == 1) BizzInfo[b][bProduct][4] = 127, BizzInfo[b][bTypeProduct][4] = 0, yes[4] = true; // Ролл
    	if(BizzInfo[b][bProduct][5] == 0 || stat == 1) BizzInfo[b][bProduct][5] = 128, BizzInfo[b][bTypeProduct][5] = 0, yes[5] = true; // Набор 1
    	if(BizzInfo[b][bProduct][6] == 0 || stat == 1) BizzInfo[b][bProduct][6] = 129, BizzInfo[b][bTypeProduct][6] = 0, yes[6] = true; // Набор 2
    	if(BizzInfo[b][bProduct][7] == 0 || stat == 1) BizzInfo[b][bProduct][7] = 130, BizzInfo[b][bTypeProduct][7] = 0, yes[7] = true; //  Набор 3
    	if(BizzInfo[b][bProduct][8] == 0 || stat == 1) BizzInfo[b][bProduct][8] = 131, BizzInfo[b][bTypeProduct][8] = 0, yes[8] = true; // Набор 4
    	if(BizzInfo[b][bProduct][9] == 0 || stat == 1) BizzInfo[b][bProduct][9] = 132, BizzInfo[b][bTypeProduct][9] = 0, yes[9] = true; // Набор 5
    	if(BizzInfo[b][bProduct][10] == 0 || stat == 1) BizzInfo[b][bProduct][10] = 133, BizzInfo[b][bTypeProduct][10] = 0, yes[10] = true; // Набор 6
    	if(BizzInfo[b][bProduct][11] == 0 || stat == 1) BizzInfo[b][bProduct][11] = 134, BizzInfo[b][bTypeProduct][11] = 0, yes[11] = true; // Набор 7
		if(BizzInfo[b][bProduct][12] == 0 || stat == 1) BizzInfo[b][bProduct][12] = 135, BizzInfo[b][bTypeProduct][12] = 0, yes[12] = true; // Набор 8
    	if(BizzInfo[b][bProduct][13] == 0 || stat == 1) BizzInfo[b][bProduct][13] = 136, BizzInfo[b][bTypeProduct][13] = 0, yes[13] = true; // Набор 9
    	if(BizzInfo[b][bProduct][14] == 0 || stat == 1) BizzInfo[b][bProduct][14] = 137, BizzInfo[b][bTypeProduct][14] = 0, yes[14] = true; // Набор 10
    	if(BizzInfo[b][bProduct][15] == 0 || stat == 1) BizzInfo[b][bProduct][15] = 138, BizzInfo[b][bTypeProduct][15] = 0, yes[15] = true; // Набор 11

		if(BizzInfo[b][bWare][0] == 0 || stat == 1) BizzInfo[b][bWare][0] = 1, yes[0] = true; // Хлеб
		if(BizzInfo[b][bWare][1] == 0 || stat == 1) BizzInfo[b][bWare][1] = 168, yes[1] = true; // Мясо в Упаковке
		if(BizzInfo[b][bWare][2] == 0 || stat == 1) BizzInfo[b][bWare][2] = 120, yes[2] = true; // Sprunk
		if(BizzInfo[b][bWare][3] == 0 || stat == 1) BizzInfo[b][bWare][3] = 174, yes[3] = true; // Овощи
		if(BizzInfo[b][bWare][4] == 0 || stat == 1) BizzInfo[b][bWare][4] = 104, yes[4] = true; // Картошка
		if(BizzInfo[b][bWare][5] == 0 || stat == 1) BizzInfo[b][bWare][5] = 179, yes[5] = true; // Мороженое
		if(BizzInfo[b][bWare][6] == 0 || stat == 1) BizzInfo[b][bWare][6] = 102, yes[6] = true; // Молоко
		if(BizzInfo[b][bWare][7] == 0 || stat == 1) BizzInfo[b][bWare][7] = 121, yes[7] = true; // Кофе
	}
	else if(b >= 123 && b <= 132) // Аптека
	{
	    if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 70, BizzInfo[b][bTypeProduct][0] = 0, yes[0] = true; // Бинт
    	if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 71, BizzInfo[b][bTypeProduct][1] = 0, yes[1] = true; // Презерватив
    	if(BizzInfo[b][bProduct][2] == 0 || stat == 1) BizzInfo[b][bProduct][2] = 72, BizzInfo[b][bTypeProduct][2] = 0, yes[2] = true; // Хламидиуберин
    	if(BizzInfo[b][bProduct][3] == 0 || stat == 1) BizzInfo[b][bProduct][3] = 73, BizzInfo[b][bTypeProduct][3] = 0, yes[3] = true; // Гоногон
    	if(BizzInfo[b][bProduct][4] == 0 || stat == 1) BizzInfo[b][bProduct][4] = 74, BizzInfo[b][bTypeProduct][4] = 0, yes[4] = true; // Сифистоп
    	if(BizzInfo[b][bProduct][5] == 0 || stat == 1) BizzInfo[b][bProduct][5] = 75, BizzInfo[b][bTypeProduct][5] = 0, yes[5] = true; // Радиануклин
    	if(BizzInfo[b][bProduct][6] == 0 || stat == 1) BizzInfo[b][bProduct][6] = 76, BizzInfo[b][bTypeProduct][6] = 0, yes[6] = true; // Перитонин
    	if(BizzInfo[b][bProduct][7] == 0 || stat == 1) BizzInfo[b][bProduct][7] = 77, BizzInfo[b][bTypeProduct][7] = 0, yes[7] = true; // Грибкоубивин
    	if(BizzInfo[b][bProduct][8] == 0 || stat == 1) BizzInfo[b][bProduct][8] = 78, BizzInfo[b][bTypeProduct][8] = 0, yes[8] = true; // Дерматитогон
    	if(BizzInfo[b][bProduct][9] == 0 || stat == 1) BizzInfo[b][bProduct][9] = 79, BizzInfo[b][bTypeProduct][9] = 0, yes[9] = true; // Акнестопин
    	if(BizzInfo[b][bProduct][10] == 0 || stat == 1) BizzInfo[b][bProduct][10] = 80, BizzInfo[b][bTypeProduct][10] = 0, yes[10] = true; // Порошкоозаменин
    	if(BizzInfo[b][bProduct][11] == 0 || stat == 1) BizzInfo[b][bProduct][11] = 81, BizzInfo[b][bTypeProduct][11] = 0, yes[11] = true; // Никотиновый пластырь
    	if(BizzInfo[b][bProduct][12] == 0 || stat == 1) BizzInfo[b][bProduct][12] = 82, BizzInfo[b][bTypeProduct][12] = 0, yes[12] = true; // Бухлозаменин
    	if(BizzInfo[b][bProduct][13] == 0 || stat == 1) BizzInfo[b][bProduct][13] = 83, BizzInfo[b][bTypeProduct][13] = 0, yes[13] = true; // Гастритоуберин
    	if(BizzInfo[b][bProduct][14] == 0 || stat == 1) BizzInfo[b][bProduct][14] = 84, BizzInfo[b][bTypeProduct][14] = 0, yes[14] = true; // Язвазаживин
    	if(BizzInfo[b][bProduct][15] == 0 || stat == 1) BizzInfo[b][bProduct][15] = 85, BizzInfo[b][bTypeProduct][15] = 0, yes[15] = true; // Колдрекс
    	if(BizzInfo[b][bProduct][16] == 0 || stat == 1) BizzInfo[b][bProduct][16] = 86, BizzInfo[b][bTypeProduct][16] = 0, yes[16] = true; // Терафлю
    	if(BizzInfo[b][bProduct][17] == 0 || stat == 1) BizzInfo[b][bProduct][17] = 87, BizzInfo[b][bTypeProduct][17] = 0, yes[17] = true; // Анвимакс
		if(BizzInfo[b][bProduct][18] == 0 || stat == 1) BizzInfo[b][bProduct][18] = 5, BizzInfo[b][bTypeProduct][18] = 0, yes[18] = true; // Оболочка таблетки
	}
	else if(b >= 133 && b <= 142) // Магазины с Техникой
	{
    	if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 43, BizzInfo[b][bTypeProduct][0] = 1, yes[0] = true; // Фотоаппарат
    	if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 21, BizzInfo[b][bTypeProduct][1] = 0, yes[1] = true; // Рация
    	if(BizzInfo[b][bProduct][2] == 0 || stat == 1) BizzInfo[b][bProduct][2] = 32, BizzInfo[b][bTypeProduct][2] = 0, yes[2] = true; // Фонарик
    	if(BizzInfo[b][bProduct][3] == 0 || stat == 1) BizzInfo[b][bProduct][3] = 26, BizzInfo[b][bTypeProduct][3] = 0, yes[3] = true; // Смартфон
    	if(BizzInfo[b][bProduct][4] == 0 || stat == 1) BizzInfo[b][bProduct][4] = 42, BizzInfo[b][bTypeProduct][4] = 0, yes[4] = true; // Ноутбук
    	if(BizzInfo[b][bProduct][5] == 0 || stat == 1) BizzInfo[b][bProduct][5] = 175, BizzInfo[b][bTypeProduct][5] = 0, yes[5] = true; // Сигнализация 1 ур.
    	if(BizzInfo[b][bProduct][6] == 0 || stat == 1) BizzInfo[b][bProduct][6] = 176, BizzInfo[b][bTypeProduct][6] = 0, yes[6] = true; // Сигнализация 2 ур.
    	if(BizzInfo[b][bProduct][7] == 0 || stat == 1) BizzInfo[b][bProduct][7] = 177, BizzInfo[b][bTypeProduct][7] = 0, yes[7] = true; // Сигнализация 3 ур.
	}
	else if(b >= 153 && b <= 162) // Ларьки с едой
	{
		if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 141, BizzInfo[b][bTypeProduct][0] = 0, yes[0] = true; // Хот Дог
		if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 120, BizzInfo[b][bTypeProduct][1] = 0, yes[1] = true; // Sprunk в бутылке
		if(BizzInfo[b][bWare][0] == 0 || stat == 1) BizzInfo[b][bWare][0] = 1, yes[0] = true; // Хлеб (Было bProduct[2])
		if(BizzInfo[b][bWare][1] == 0 || stat == 1) BizzInfo[b][bWare][1] = 168, yes[1] = true; // Мясо в Упаковке (Было bProduct[3])
		if(BizzInfo[b][bWare][2] == 0 || stat == 1) BizzInfo[b][bWare][2] = 120, yes[2] = true; // Sprunk

		BizzInfo[b][bProduct][2] = 0, BizzInfo[b][bProduct][3] = 0; // (Сбросим предыдущую херню с исключением, чтобы не мешать формированию списка)
	}
	else if(b >= 183 && b <= 192) // Автосервисы
	{
    	if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 183, BizzInfo[b][bTypeProduct][0] = 0, yes[0] = true; // Ремонтный набор
    	if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 184, BizzInfo[b][bTypeProduct][1] = 0, yes[1] = true; // Краска
    	if(BizzInfo[b][bProduct][2] == 0 || stat == 1) BizzInfo[b][bProduct][2] = 185, BizzInfo[b][bTypeProduct][2] = 0, yes[2] = true; // Диски
    	if(BizzInfo[b][bProduct][3] == 0 || stat == 1) BizzInfo[b][bProduct][3] = 186, BizzInfo[b][bTypeProduct][3] = 0, yes[3] = true; // Гидравлика
    	if(BizzInfo[b][bProduct][4] == 0 || stat == 1) BizzInfo[b][bProduct][4] = 187, BizzInfo[b][bTypeProduct][4] = 0, yes[4] = true; // Закись Азота
		if(BizzInfo[b][bProduct][5] == 0 || stat == 1) BizzInfo[b][bProduct][5] = 188, BizzInfo[b][bTypeProduct][5] = 0, yes[5] = true; // Деталь
		if(BizzInfo[b][bProduct][6] == 0 || stat == 1) BizzInfo[b][bProduct][6] = 190, BizzInfo[b][bTypeProduct][6] = 0, yes[6] = true; // Ремонтный набор Мото
		if(BizzInfo[b][bProduct][7] == 0 || stat == 1) BizzInfo[b][bProduct][7] = 199, BizzInfo[b][bTypeProduct][7] = 0, yes[7] = true; // Обычная сигнализация
		if(BizzInfo[b][bProduct][8] == 0 || stat == 1) BizzInfo[b][bProduct][8] = 200, BizzInfo[b][bTypeProduct][8] = 0, yes[8] = true; // Улучшенная Сигнализация
	}
	else if(b >= 193 && b <= 195) // Сервис Авиатранспорта
	{
    	if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 191, BizzInfo[b][bTypeProduct][0] = 0, yes[0] = true; // Ремонтный набор
    	if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 184, BizzInfo[b][bTypeProduct][1] = 0, yes[1] = true; // Краска
	}
	else if(b >= 197 && b <= 200) // Сервис Авиатранспорта
	{
    	if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 192, BizzInfo[b][bTypeProduct][0] = 0, yes[0] = true; // Ремонтный набор
    	if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 184, BizzInfo[b][bTypeProduct][1] = 0, yes[1] = true; // Краска
	}
	for(new i = 0; i < MAX_BIZ_ITEM; i++)
    {
        if((BizzInfo[b][bProduct][i] > 0 || BizzInfo[b][bWare][i] > 0) && (yes[i] || stat == 1))
        {
			// Выставляем Стоимость
            if(BizzInfo[b][bTypeProduct][i] == 0) BizzInfo[b][bPrice][i] = friskPrice[BizzInfo[b][bProduct][i]];
            else if(BizzInfo[b][bTypeProduct][i] == 1) BizzInfo[b][bPrice][i] = gunPrice[BizzInfo[b][bProduct][i]];
            else if(BizzInfo[b][bTypeProduct][i] == 2) BizzInfo[b][bPrice][i] = 10000;
			else if(BizzInfo[b][bTypeProduct][i] == 5) BizzInfo[b][bPrice][i] = getThingPriceGos(BizzInfo[b][bProduct][i], BizzInfo[b][bTypeProduct][i]);
            
			// Выставляем количество
			if(b >= 103 && b <= 122 || b >= 153 && b <= 162) // Закусочные, Рестораны, Ларьки с едой
			{
				BizzInfo[b][bItem][i] = maxQuanThingProduct(BizzInfo[b][bWare][i], BizzInfo[b][bTypeProduct][i]);
			}
			else BizzInfo[b][bItem][i] = maxQuanThingProduct(BizzInfo[b][bProduct][i], BizzInfo[b][bTypeProduct][i]);

			yesUpdate = true;
        }
    }
    if(yesUpdate)
	{
	    if(b <= 12) UpdateFillLabel(b);
	    if(b >= 13 && b <= 26) UpdateSupermarketLabel_S(b);
		SaveBizzProduct(b);
	}
	return 1;
}
stock getThingPriceGos(thingId, thingType)
{
	new price;
	if(thingType == 0) price = friskPrice[thingId];
	else if(thingType == 1) price = gunPrice[thingId];
	else if(thingType == 2) price = GetPriceGosAccessory(thingId);
	else if(thingType == 3) price = SkinGos[thingId];
//	else if(thingType == 4) format(nameProduct,sizeof(nameProduct),"%s", object_name(thingId));
	else if(thingType == 5) price = GetVehiclePriceGos(thingId);
	return price;
}
stock pricebiz(playerid, b)
{
	DP[4][playerid] = b;
	
	if(b >= 173 && b <= 182) return ErrorMessage(playerid, "{FF6347}Прайс можно настроить только в меню выбора товара"), mybiz(playerid, b);
	new lol[84], quan;
	new line[100],lines[4048];

	if(b >= 1 && b <= 12 || b >= 13 && b <= 26 || b >= 27 && b <= 41 || b >= 42 && b <= 76 || b >= 77 && b <= 92 || b >= 93 && b <= 102 || b >= 103 && b <= 122 
	|| b >= 123 && b <= 132 || b >= 133 && b <= 142 || b >= 153 && b <= 162 || b >= 183 && b <= 200) // Прайс автоматгенерация
	{
		for(new i = 0; i < MAX_BIZ_ITEM; i++)
    	{
			List[i][playerid] = 0;
			if (BizzInfo[b][bProduct][i] == 0) break;
			List[quan][playerid] = i;
			format(line,sizeof(line),"{cccccc}%s \t {99FF66}%d$\n",GetNameThing(0, BizzInfo[b][bProduct][i], BizzInfo[b][bTypeProduct][i], 0),BizzInfo[b][bPrice][i]), strcat(lines,line);
			quan++;
		}		
	}
	else if(b >= 163 && b <= 172) // Прайс Банкоматов
	{
		format(line,sizeof(line),"{cccccc}Комиссия на {99ff66}Внесение \t [%.3f проц.]\n", comput[b-163]), strcat(lines,line);
		format(line,sizeof(line),"{cccccc}Комиссия на {FF6347}Вывод {99ff66} \t [%.3f проц.]\n", comtake[b-163]), strcat(lines,line);
		format(lol,sizeof(lol),"{cccccc}Прайс Бизнеса {ff9000}%s [%d]",bizname(b), b);
		ShowDialog(playerid,1171,DIALOG_STYLE_LIST,lol,lines,"Выбрать","Отмена");
		return 1;
	}
	else return ErrorMessage(playerid, "{FF6347}В этом бизнесе нельзя настраивать стоимость товаров и услуг"), mybiz(playerid, b);

	format(lol,sizeof(lol),"{cccccc}Прайс Бизнеса {ff9000}%s [%d]",bizname(b), b);
	ShowDialog(playerid,997,DIALOG_STYLE_TABLIST,lol,lines,"Выбрать","Отмена");
	return 1;
}

stock use_biz(playerid, biz, inva, useinva)
{
    if(Veshi[playerid] >= 1) return i_resettabs(playerid);
	if(gRedakt[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Ваш персонаж занят ремонтом или настройкой предмета"), i_resettabs(playerid);
	if(useinva != 9999)
	{
 		if(PlayerInfo[playerid][pInven][useinva] != BizzInfo[biz][bInvent][inva] && PlayerInfo[playerid][pInven][useinva] != 0) return i_resettabs(playerid);
	}
	if(!IsANearWardrobeBiz(playerid, biz)) return ErrorMessage(playerid, "{FF6347}Вы далеко от склада бизнеса"), closetab(playerid, 1);

    new thingType = BizzInfo[biz][bInvType][inva];
    if(thingType == 4)
    {
     	PlayerPlaySound(playerid,1052,0,0,0);
		new obid = BizzInfo[biz][bInvent][inva];
		if(BizzInfo[biz][bSell]  >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя заниматься ремонтом интерьера во время продажи"), i_resettabs(playerid);

		if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
		{
			if(!getIkeaObjectStreet(obid)) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя устанавливать на улице");
			if(getObjectStreetBiz(biz) >= MAX_DOM_OBJECT_STREET) return ErrorMessage(playerid, "{FF6347}В этом бизнесе установлено максимальное количество предметов на улице");
		}
		if(getFreeSlotObjectBiz(biz) == -1) return ErrorMessage(playerid, "{FF6347}В этом бизнесе закончились слоты для установки объектов");
		if(BizzInfo[biz][bInv][inva] == 1000) return ErrorMessage(playerid, "{FF6347}Этот предмет мебели кто-то устанавливает");

		PlayerPlaySound(playerid,1052,0,0,0);
		BizzInfo[biz][bInv][inva] = 1000; // Блокируем возможность забрать предмет из инвентаря
		CloseFrisk(playerid);

		new Float:f_pos[4];
		frontme(playerid, 2.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
		CreateEditPlayerObject(playerid, 17, 0, biz, inva, obid, f_pos[0], f_pos[1], f_pos[2], 0.0000, 0.0000, 0.0000);
		return 1;
	}

	if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)  return ErrorMessage(playerid, "{FF6347}Вы не можете взять предметы из бизнеса на улице\n{cccccc}На улице вы можете устанавливать только объекты");
	return 1;
}

stock shift_biz(playerid, b, getinva, putinva)
{
	if(OnlineInfo[playerid][oShowTabs] != 9999)
	{
		if(BizzInfo[b][bInvent][getinva] == 0) return i_resettabs(playerid);
		else if(BizzInfo[b][bInvent][putinva] != 0) return 1;
		if(GetPlayerInterior(playerid) == 0) return ErrorMessage(playerid, "{FF6347}Вы не можете перекладывать предметы в бизнесе на улице"), i_resettabs(playerid);
		if(BizzInfo[b][bInvType][getinva] == 4 && BizzInfo[b][bInv][getinva] == 1000) return ErrorMessage(playerid, "{FF6347}Этот предмет мебели кто-то устанавливает"), i_resettabs(playerid);

		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 9) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			new string[90];
		    format(string, sizeof(string), "{FF6347}Склад бизнеса просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, string);
			i_resettabs(playerid);
			return 1;
		}
		BizzInfo[b][bInvent][putinva] = BizzInfo[b][bInvent][getinva];
		BizzInfo[b][bInv][putinva] = BizzInfo[b][bInv][getinva];
		BizzInfo[b][bInvPara][putinva] = BizzInfo[b][bInvPara][getinva];
		BizzInfo[b][bInvQara][putinva] = BizzInfo[b][bInvQara][getinva];
		BizzInfo[b][bInvType][putinva] = BizzInfo[b][bInvType][getinva];
		BizzInfo[b][bInvPack][putinva] = BizzInfo[b][bInvPack][getinva];
		BizzInfo[b][bInvent][getinva] = 0;
		BizzInfo[b][bInv][getinva] = 0;
		BizzInfo[b][bInvPara][getinva] = 0;
		BizzInfo[b][bInvQara][getinva] = 0;
		BizzInfo[b][bInvType][getinva] = 0;
		BizzInfo[b][bInvPack][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, 0, 0, getinva, 0, 0, 0, 0, 0);
		item_second(playerid, BizzInfo[b][bInvent][putinva], BizzInfo[b][bInv][putinva], putinva, 0, BizzInfo[b][bInvPara][putinva], BizzInfo[b][bInvType][putinva], BizzInfo[b][bInvPack][putinva], 0);
		
		mysql_tquery(pearsq, "START TRANSACTION;");
		SaveSkladBiz(b, getinva);
		SaveSkladBiz(b, putinva);
		mysql_tquery(pearsq, "COMMIT;");
	}
	return 1;
}
stock PutThingBiz(b, thingId, quan, para, qara, thingType, useinva) // Кладём предмет в инвентарь бизнеса
{
	new put_inva = -1;
	if(thingId == 0) return 1; // Малоли где то ошибка может быть (0 - не пропускаем выдачу предмета)
	if(useinva == 999)
	{
	    if(thingType == 0) // Обычный предмет
		{
		    if(CheckThingQuan(thingId) == 1) // Предмет имеет количество (Складывается в одну ячейку)
		    {
		        new find;
		    	for(new i = 0; i < 80; i++)
				{
					if(BizzInfo[b][bInvent][i] == thingId && BizzInfo[b][bInvType][i] == thingType) // Ищем тот, где уже предмет лежит
					{
		  				put_thing_biz(b, thingId, quan, para, 0, thingType, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
		  				put_inva = i;
		  				find = 1;
			   			break;
					}
				}
				if(find == 0) // Если не нашли, ищем пустую
				{
					for(new i = 0; i < 80; i++)
					{
						if(BizzInfo[b][bInvent][i] == 0) // Ищем пустую ячейку
						{
			  				put_thing_biz(b, thingId, quan, para, 0, thingType, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
			  				put_inva = i;
				   			break;
						}
					}
				}
			}
			else if(CheckThingQuan(thingId) == 0) // Объект не имеет количество
			{
			    for(new i = 0; i < 80; i++)
				{
					if(BizzInfo[b][bInvent][i] == 0) // Ищем пустую ячейку
					{
		  				put_thing_biz(b, thingId, quan, para, qara, thingType, i);
		  				put_inva = i;
			   			break;
					}
				}
			}
		}
		else // Все остальные предметы не имеют количества или возможности складываться в одну ячейку
		{
		    for(new i = 0; i < 80; i++)
			{
				if(BizzInfo[b][bInvent][i] == 0) // Ищем пустую ячейку
				{
	  				put_thing_biz(b, thingId, quan, para, qara, thingType, i);
	  				put_inva = i;
		   			break;
				}
			}
		}
	}
	else put_thing_biz(b, thingId, quan, para, qara, thingType, useinva), put_inva = useinva;
	return put_inva;
}
stock put_thing_biz(b, thingId, quan, para, qara, thingType, i)
{
	BizzInfo[b][bInvent][i] = thingId; // Ставим предмет в слот
	BizzInfo[b][bInv][i] += quan; // Ставим количество в слот

	// (Техника сломана или нет, Одежда какой организации принадлежит, Unix время свежести продуктов, Изношенность оружия, Прнадлежность лицензии к ID игрока, Тип крепления аксессуара)
	if(PerishableThing(thingId, thingType)) // Проверка на портящиеся продукты - у них используется Unix (Добавляя испорченный продукт к свежему, портиться должно всё)
	{
	    if(BizzInfo[b][bInvPara][i] > 0)
		{
			if(BizzInfo[b][bInvPara][i] > para) BizzInfo[b][bInvPara][i] = para;
		}
		else BizzInfo[b][bInvPara][i] = para;
	}
	else BizzInfo[b][bInvPara][i] = para;
	BizzInfo[b][bInvQara][i] = qara; // Статус краденного предмета
	BizzInfo[b][bInvType][i] = thingType; // Тип предмета
	SaveSkladBiz(b, i);
	foreach(Player,playerid)
	{
		if(Tabs_Load[i] != 9) continue;
		if(OnlineInfo[playerid][oLogged] == 1 && OnlineInfo[playerid][oShowInterface] == 1 && OnlineInfo[playerid][oShowTabs] == b) item_second(playerid, thingId, quan, i, 0, para, thingType, 0, 0);
	}
	return i;
}
stock TakeThingBiz(b, thingId, kolvo, thingType, inv) // Забираем из бизнеса предмет
{
	new plalit;
	if(inv == 999)
	{
		for(new i = 0; i < 80; i++)
		{
			if(BizzInfo[b][bInvent][i] == thingId && BizzInfo[b][bInvType][i] == thingType && BizzInfo[b][bInvPack][i] == 0)
			{
				if(BizzInfo[b][bInv][i]-kolvo <= 0) BizzInfo[b][bInvent][i] = 0, BizzInfo[b][bInv][i] = 0, BizzInfo[b][bInvPara][i] = 0, BizzInfo[b][bInvQara][i] = 0, BizzInfo[b][bInvType][i] = 0, BizzInfo[b][bInvPack][i] = 0;
				else BizzInfo[b][bInv][i] -= kolvo;
				plalit = i;
				break;
			}
		}
	}
	else
	{
		if(BizzInfo[b][bInvent][inv] == thingId && BizzInfo[b][bInvType][inv] == thingType && BizzInfo[b][bInvPack][inv] == 0)
		{
			if(BizzInfo[b][bInv][inv]-kolvo <= 0) BizzInfo[b][bInvent][inv] = 0, BizzInfo[b][bInv][inv] = 0, BizzInfo[b][bInvPara][inv] = 0,BizzInfo[b][bInvQara][inv] = 0, BizzInfo[b][bInvType][inv] = 0, BizzInfo[b][bInvPack][inv] = 0;
			else BizzInfo[b][bInv][inv] -= kolvo;
			plalit = inv;
		}
	}
	SaveSkladBiz(b, plalit);
	foreach(Player,i)
	{
		if(Tabs_Load[i] != 9) continue;
		if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowTabs] == b) item_second(i, BizzInfo[b][bInvent][plalit], BizzInfo[b][bInv][plalit], plalit, 0, BizzInfo[b][bInvPara][plalit], BizzInfo[b][bInvType][plalit], BizzInfo[b][bInvPack][plalit], 0);
	}
	return 1;
}

stock SaveSkladBiz(idx, i)
{
	if(BizzInfo[idx][bInvent][i] == 0)
	{
		new string_mysql[140];
		format(string_mysql, sizeof(string_mysql), "UPDATE `pp_bizz` SET `b_slot_%d`= NULL WHERE `newid` = '%d'", i, idx);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new JsonNode:node = JSON_Object(
			"id", JSON_Int(BizzInfo[idx][bInvent][i]),
			"quan", JSON_Int(BizzInfo[idx][bInv][i]),
			"para", JSON_Int(BizzInfo[idx][bInvPara][i]),
			"qara", JSON_Int(BizzInfo[idx][bInvQara][i]),
			"type", JSON_Int(BizzInfo[idx][bInvType][i]),
			"pack", JSON_Int(BizzInfo[idx][bInvPack][i])
		);

		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_bizz` SET `b_slot_%d`= '%e' WHERE `newid` = '%d'", i, string_json, idx);
			mysql_tquery(pearsq, string_mysql);
		}
	}
	return 1;
}

stock delproduct(b, ord) // Удаляем заказ доставки товара в бизнесы
{
	BizzInfo[b][bOrder][ord] = 0;
    BizzInfo[b][bOrderQuan][ord] = 0;
    BizzInfo[b][bOrderType][ord] = 0;
    SaveBizzOrder(b, ord);
    BizzInfo[b][bOrders] --;
    Orders --;
}
stock IsBizOrder(b)
{
    // Заправка, Супермаркет, Оружейный Магазин, Аптека
	// Магазин с Техникой, Магазин Одежды
	// Автосалоны, Мотосалоны, Авиасалоны, Салоны Катеров
	// Автосервисы
    if(b <= 12 || b >= 13 && b <= 26 || b >= 27 && b <= 41 || b >= 77 && b <= 92 || b >= 93 && b <= 122 || b >= 123 && b <= 132
	|| b >= 133 && b <= 142 || b >= 153 && b <= 162 || b >= 173 && b <= 200) return 1;
	return 0;
}
stock SendBizMessage(b, const string[]) // Сообщение в чат семье, привязанной к бизнесу
{
    if(BizzInfo[b][bFam] > 0)
	{
        if(FamilyInfo[BizzInfo[b][bFam]][fSost] > 0) SendFamilyMessage(BizzInfo[b][bFam], COLOR_GREY, string);
	}
	return 1;
}

stock ResetBizzPriceItem(playerid, b, thingId, thingType, input)
{
    new bool:bizUpdate;

	// Заправки
    if(b >= 1 && b <= 12)
    {
        BizzInfo[b][bPrice][0] = friskPrice[thingId]+friskPrice[thingId]/2, UpdateFillLabel(b), SaveBizzProductItem(b, 0), bizUpdate = true;
    }

	// Супермаркеты, Оружейный Магазин, Аптеки, Магазины с Техникой, Клуб
    else if(b >= 13 && b <= 26 || b >= 27 && b <= 41|| b >= 93 && b <= 102 || b >= 123 && b <= 132 || b >= 133 && b <= 142 || b >= 183 && b <= 192)
    {
        for(new i = 0; i < MAX_BIZ_ITEM; i++)
    	{
    		if(BizzInfo[b][bProduct][i] == thingId && BizzInfo[b][bTypeProduct][i] == thingType)
			{
				if(BizzInfo[b][bTypeProduct][i] == 0) BizzInfo[b][bPrice][i] = friskPrice[thingId]+friskPrice[thingId]/2, bizUpdate = true;
				else if(BizzInfo[b][bTypeProduct][i] == 1) BizzInfo[b][bPrice][i] = gunPrice[thingId]+gunPrice[thingId]/2, bizUpdate = true;
			}
    	}
    	if(b >= 13 && b <= 26) UpdateSupermarketLabel_S(b);
    	SaveBizzProduct(b);
    }

	// Аренда Транспорта
    else if(b >= 42 && b <= 76)
    {
        for(new i = 0; i < MAX_BIZ_ITEM; i++)
    	{
    		if(BizzInfo[b][bProduct][i] == thingId && BizzInfo[b][bTypeProduct][i] == thingType)
			{
				BizzInfo[b][bPrice][i] = (GetVehiclePriceGos(thingId)/10)/2;
				SaveBizzProductItem(b, i), bizUpdate = true;
			}
    	}
    }

	// Автосалоны, Мотосалоны, Авиасалоны, Салоны Катеров
    else if(b >= 77 && b <= 92)
    {
        for(new i = 0; i < MAX_BIZ_ITEM; i++)
    	{
    		if(BizzInfo[b][bProduct][i] == thingId && BizzInfo[b][bTypeProduct][i] == thingType)
			{
				BizzInfo[b][bPrice][i] = (GetVehiclePriceGos(thingId)*2) - GetVehiclePriceGos(thingId)/2; // 3/4 от гос. стоимости
				SaveBizzProductItem(b, i), bizUpdate = true;
			}
    	}
    }

	// Магазины с Одеждой
	if(b >= 173 && b <= 182)
	{
	    new bn = b-173;
	    for(new gs = 0; gs < 50; gs++) // Прокатываем цикл по слотам с одеждой
		{
			if(StoreItem[bn][gs] == thingId) StorePrice[bn][gs] = SkinGos[thingId]+SkinGos[thingId]/2, bizUpdate = true, SaveBizzStore(bn, gs); // Нашли скин и установили новую стоимость
		}
	}
	if(bizUpdate && BizzInfo[b][bSost] > 0) //  Если изменения для бизнеса были, отправляем все необходимые уведомления
	{
		new string[80];
        format(string, sizeof(string), "Новая гос. стоимость %s [%d$]", GetNameThing(0, thingId, thingType, 0), input);
		notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], BizzInfo[b][bSost], BizzInfo[b][bVlad], string);
	}
	return 1;
}
stock isPlayersWatchProductBiz(b, slot)
{
	new bool:yesPlayer;
	if(b >= 77 && b <= 92) // Автосалоны, Мотосалоны, Авиасалоны, Салоны Катеров
	{
		foreach(Player,i)
		{
			if(OnlineInfo[i][oShowInterface] == 16 && TP[0][i] == b && TP[1][i] == slot)
			{
				yesPlayer = true;
				break;
			}
		}
	}
	return yesPlayer;
}
stock putshop(b, item, thingType, quan) // Кладём товары в Магазины с Одеждой во время доставки
{
	new nashel = -1;
	if(thingType == 3) // Одежда
	{
		for(new gs = 0; gs < 50; gs++)
		{
		    if(StoreItem[b][gs] == item)
		    {
		    	StoreQuan[b][gs] += quan, nashel = gs;
		    	SaveBizzStore(b, gs);
		        break;
		    }
		}
		if(nashel == -1)
		{
			for(new gs = 0; gs < 50; gs++)
			{
			    if(StoreItem[b][gs] == 0)
			    {
			    	StoreItem[b][gs] = item;
			    	StoreQuan[b][gs] = quan;
			    	StorePrice[b][gs] = SkinGos[item] + SkinGos[item]/2;
			    	SaveBizzStore(b, gs);
			        break;
			    }
			}
		}
	}
	else if(thingType == 2) // Аксессуары
	{
		for(new as = 0; as < 100; as++)
		{
		    if(AksesItem[b][as] == item)
		    {
		    	AksesQuan[b][as] += quan, nashel = as;
		    	SaveBizzAkses(b, as);
		        break;
		    }
		}
		if(nashel == -1)
		{
			new price = GetPriceGosAccessory(item);
			for(new as = 0; as < 100; as++)
			{
			    if(AksesItem[b][as] == 0)
			    {
			    	AksesItem[b][as] = item;
			    	AksesQuan[b][as] = quan;
			    	AksesPrice[b][as] = price + price/2;
			    	SaveBizzAkses(b, as);
			        break;
			    }
			}
		}
	}
	return 1;
}

stock takeWareBusiness(b, thingId) // Снимаем продукты из бизнеса
{
	new ingId[6], ingQuan[6], slot;
	menuEatIngredient(thingId, ingId[0], ingId[1], ingId[2], ingId[3], ingId[4], ingId[5], ingQuan[0], ingQuan[1], ingQuan[2], ingQuan[3], ingQuan[4], ingQuan[5]);

	for(new i = 0; i < 6; i++)
    {
		if(ingId[i] > 0)
		{
			slot = getSlotIngredientBusiness(ingId[i]);
			if(BizzInfo[b][bItem][slot] - ingQuan[i] < 0) BizzInfo[b][bItem][slot] = 0;
			else BizzInfo[b][bItem][slot] -= ingQuan[i];
		}
	}
	BizzInfo[b][bUpdate] = 1;
	return 1;
}

stock getSlotIngredientBusiness(thingId) // Получаем слот, который используется для продукта (По сути нужно динамически искать, но мне насрать)
{
	new slot;
	if(thingId == 1) slot = 0;
	else if(thingId == 168) slot = 1;
	else if(thingId == 120) slot = 2;
	else if(thingId == 174) slot = 3;
	else if(thingId == 104) slot = 4;
	else if(thingId == 179) slot = 5;
	else if(thingId == 102) slot = 6;
	else if(thingId == 121) slot = 7;
	return slot;
}

stock partnerbiz(playerid, b) // Партнерство в бизнесе
{
	new quan;
	new line[90],lines[900];
	for(new i = 0; i < 10; i++)
	{
		List[i][playerid] = 0;
		if(BizzInfo[b][bFamilyPartner][i] != 0)
		{
		    List[quan][playerid] = i;
			quan ++;
			format(line,sizeof(line),"{ff9000}%d. %s\n", quan, FamilyInfo[BizzInfo[b][bFamilyPartner][i]][fName]), strcat(lines,line);
		}
		else if(BizzInfo[b][bFamilyPartner][i] == 0)
		{
		    List[quan][playerid] = i;
			quan ++;
			format(line,sizeof(line),"{ff9000}%d. {cccccc}Пусто\n", quan), strcat(lines,line);
		}
	}
	new header[90];
	format(header,sizeof(header),"{cccccc}Бизнес {ff9000}%s [%d]",bizname(b), b);
	ShowDialog(playerid,1453,DIALOG_STYLE_TABLIST,header,lines,"Выбрать","Отмена");
	return 1;
}

stock SaveBizzCity(b)
{
	if(LIMITED_LOADING_SERVER >= 2) return true;

	// Saving immediately
	new string_mysql[90];
	format(string_mysql,sizeof(string_mysql),"UPDATE `pp_bizz` SET `bCity` = '%d' WHERE `newid` = '%d'", BizzInfo[b][bCity], b);
	query_empty(pearsq, string_mysql);
	return true;
}
stock SaveBizz(b)
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;
	new f_str1[24],f_str2[34],f_str3[64],f_str4[64];
	mysql_escape_string(BizzInfo[b][bVlad], f_str1, sizeof(f_str1));
	mysql_escape_string(BizzInfo[b][bName], f_str2, sizeof(f_str2));
	mysql_escape_string(BizzInfo[b][bArReason], f_str3, sizeof(f_str3));
	mysql_escape_string(BizzInfo[b][bStatReason], f_str4, sizeof(f_str4));

	new string_mysql[2000];
	format(string_mysql, sizeof(string_mysql), "UPDATE `pp_bizz` SET `Vlad`='%s',`Level`='%d',`Sost`='%d',`Data`='%d',`Freeze`='%d',`Arest`='%d',`Fam`='%d',`Intorval`='%d',\
	`bcX`='%f',`bcY`='%f',`bcZ`='%f',`Lab`='%d',`Descrip`='%d',`Name`='%s',`BizBar`='%d',`BizBarX`='%f',`BizBarY`='%f',`BizBarZ`='%f',`BizShluha`='%d',`BizShluhaX`='%f',`BizShluhaY`='%f',`BizShluhaZ`='%f',",f_str1,
	BizzInfo[b][bLevel], BizzInfo[b][bSost], BizzInfo[b][bData], BizzInfo[b][bFreeze], BizzInfo[b][bArest], BizzInfo[b][bFam], BizzInfo[b][bInterval],
	BizzInfo[b][bX], BizzInfo[b][bY], BizzInfo[b][bZ], BizzInfo[b][bLab], BizzInfo[b][bDescrip], f_str2, BizzInfo[b][bBar], BizzInfo[b][bBarX], BizzInfo[b][bBarY], 
	BizzInfo[b][bBarZ],BizzInfo[b][bShluha], BizzInfo[b][bShluhaCord][0], BizzInfo[b][bShluhaCord][1],BizzInfo[b][bShluhaCord][2]); // 259 + 110 + 24 + 120 + 34 + 72

	format(string_mysql, sizeof(string_mysql), "%s`obX0`='%f',`obY0`='%f',`obZ0`='%f',`obRX0`='%f',`obRY0`='%f',`obRZ0`='%f',`obX1`='%f',`obY1`='%f',`obZ1`='%f',`obRX1`='%f',`obRY1`='%f',`obRZ1`='%f'\
	,`EnterX`='%f',`EnterY`='%f',`EnterZ`='%f',`EnterA`='%f',`InteriorX`='%f',`InteriorY`='%f',`InteriorZ`='%f',`InteriorA`='%f',`Inter`='%d',`bZZ` ='%d',",string_mysql,
	BizzInfo[b][bBizOX][0],BizzInfo[b][bBizOY][0],BizzInfo[b][bBizOZ][0],BizzInfo[b][bBizORX][0],BizzInfo[b][bBizORY][0],BizzInfo[b][bBizORZ][0],
	BizzInfo[b][bBizOX][1],BizzInfo[b][bBizOY][1],BizzInfo[b][bBizOZ][1],BizzInfo[b][bBizORX][1],BizzInfo[b][bBizORY][1],BizzInfo[b][bBizORZ][1],BizzInfo[b][bEnterX],BizzInfo[b][bEnterY],
	BizzInfo[b][bEnterZ],BizzInfo[b][bEnterA], BizzInfo[b][bInteriorX], BizzInfo[b][bInteriorY], BizzInfo[b][bInteriorZ], BizzInfo[b][bInteriorA], 
	BizzInfo[b][bInterior],BizzInfo[b][bZZ]); // 307 + 22 + 400 + 12
	
	format(string_mysql, sizeof(string_mysql), "%s`PriceProd`='%d',`Bablo`='%d',`Schet`='%d',`Sell`='%d',`Pastime`='%d',`Mafunix`='%d',\
	`Taxes`='%d',`Warn`='%d',`Lien`='%d',`ArTime`='%d',`ArReason`='%s',`Stat`='%d',`StatReason`='%s',`Taxday`='%d',\
	`Deposit`='%d',`Income`='%d',`DeliveryPay`='%d',`OrderStatus`='%d',`bMafiaSchet`='%d' WHERE `newid`='%d'", string_mysql,
	BizzInfo[b][bMafia],BizzInfo[b][bBablo],BizzInfo[b][bSchet],BizzInfo[b][bSell],BizzInfo[b][bPastime],BizzInfo[b][bMafunix],BizzInfo[b][bTaxes],
	BizzInfo[b][bWarn],BizzInfo[b][bLien],BizzInfo[b][bArTime], f_str3, BizzInfo[b][bStat], f_str4, BizzInfo[b][bTaxday], 
	BizzInfo[b][bDeposit], BizzInfo[b][bIncome], BizzInfo[b][bDeliveryPay], BizzInfo[b][bOrderStatus],BizzInfo[b][bMafiaSchet], b); // 292 + 187 + 64+29
	query_empty(pearsq, string_mysql); // 1891

	SaveBizzAccess(b);
	SaveBizzSetting(b);
	return true;
}
stock SaveBizzProduct(idx, bool:transaction = true)
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;

	// Начало транзакции
	if(transaction == true) mysql_tquery(pearsq, "START TRANSACTION;");

	for(new i = 0; i < MAX_BIZ_ITEM; i++) SaveBizzProductItem(idx, i);

	// Завершение транзакции
	if(transaction == true) mysql_tquery(pearsq, "COMMIT;");
	return 1;
}
stock SaveBizzProductItem(idx, i)
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;

	if(BizzInfo[idx][bProduct][i] == 0 && BizzInfo[idx][bWare][i] == 0) // Слот пустой, тогда NULL
	{
		new string_mysql[140];
		format(string_mysql, sizeof(string_mysql), "UPDATE `pp_bizz` SET `p_slot_%d`= NULL WHERE `newid` = '%d'", i, idx);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new JsonNode:node = JSON_Object(
			"item", JSON_Int(BizzInfo[idx][bItem][i]),
			"price", JSON_Int(BizzInfo[idx][bPrice][i]),
			"product", JSON_Int(BizzInfo[idx][bProduct][i]),
			"typeprod", JSON_Int(BizzInfo[idx][bTypeProduct][i]),
			"ware", JSON_Int(BizzInfo[idx][bWare][i])
		);

		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_bizz` SET `p_slot_%d`= '%e' WHERE `newid` = '%d'", i, string_json, idx);
			mysql_tquery(pearsq, string_mysql);
		}
	}
	return 1;
}

stock OnLoadBizzProduct(idx, f)
{
	for(new i = 0; i < MAX_BIZ_ITEM; i++)
	{
		new string[20], bool:is_null;
		format(string, sizeof(string), "p_slot_%d", i);
		cache_is_value_name_null(f, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(f, string, string_json, 512);

			new JsonNode:node = JSON_INVALID_NODE;
			if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
			{
				JSON_GetInt(node, "item", BizzInfo[idx][bItem][i]);
				JSON_GetInt(node, "price", BizzInfo[idx][bPrice][i]);
				JSON_GetInt(node, "product", BizzInfo[idx][bProduct][i]);
				JSON_GetInt(node, "typeprod", BizzInfo[idx][bTypeProduct][i]);
				JSON_GetInt(node, "ware", BizzInfo[idx][bWare][i]);
			}
		}
	}
	return 1;
}

stock OnLoadBizzInvent(idx, f)
{
	for(new i = 0; i < 80; i++)
	{
		new string[20], bool:is_null;
		format(string, sizeof(string), "b_slot_%d", i);
		cache_is_value_name_null(f, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(f, string, string_json, 512);

			new JsonNode:node = JSON_INVALID_NODE;
			if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
			{
				JSON_GetInt(node, "id", BizzInfo[idx][bInvent][i]);
				JSON_GetInt(node, "quan", BizzInfo[idx][bInv][i]);
				JSON_GetInt(node, "para", BizzInfo[idx][bInvPara][i]);
				JSON_GetInt(node, "qara", BizzInfo[idx][bInvQara][i]);
				JSON_GetInt(node, "type", BizzInfo[idx][bInvType][i]);
				JSON_GetInt(node, "pack", BizzInfo[idx][bInvPack][i]);
			}
		}
	}
	return 1;
}

stock OnLoadBizzOrder(idx, f)
{
	for(new i = 0; i < 50; i++)
	{
		new string[20], bool:is_null;
		format(string, sizeof(string), "o_slot_%d", i);
		cache_is_value_name_null(f, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(f, string, string_json, 512);

			new JsonNode:node = JSON_INVALID_NODE;
			if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
			{
				JSON_GetInt(node, "id", BizzInfo[idx][bOrder][i]);
				JSON_GetInt(node, "quan", BizzInfo[idx][bOrderQuan][i]);
				JSON_GetInt(node, "type", BizzInfo[idx][bOrderType][i]);
			}
		}
	}
	return 1;
}

stock SaveBizzOrder(idx, i)
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;

	if(BizzInfo[idx][bOrder][i] == 0) // Слот пустой, тогда NULL
	{
		new string_mysql[140];
		format(string_mysql, sizeof(string_mysql), "UPDATE `pp_bizz` SET `o_slot_%d`= NULL WHERE `newid` = '%d'", i, idx);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new JsonNode:node = JSON_Object(
			"id", JSON_Int(BizzInfo[idx][bOrder][i]),
			"quan", JSON_Int(BizzInfo[idx][bOrderQuan][i]),
			"type", JSON_Int(BizzInfo[idx][bOrderType][i])
		);

		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_bizz` SET `o_slot_%d`= '%e' WHERE `newid` = '%d'", i, string_json, idx);
			mysql_tquery(pearsq, string_mysql);
		}
	}
  	return 1;
}

stock SaveBizzOrderAll(idx, bool:transaction = true)
{
	// Начало транзакции
	if(transaction == true) mysql_tquery(pearsq, "START TRANSACTION;");

	for(new i = 0; i < 50; i++) SaveBizzOrder(idx, i);

	// Завершение транзакции
	if(transaction == true) mysql_tquery(pearsq, "COMMIT;");
	return 1;
}

stock SaveBizzPartner(idx)
{
	if(LIMITED_LOADING_SERVER >= 2) return 1;

	new string_mysql[500];
	format(string_mysql,sizeof(string_mysql),"UPDATE `pp_bizz` SET `parthner0` = '%d'", BizzInfo[idx][bFamilyPartner][0]); // 40 + 11
	for(new i = 1; i < 10; i++) 
	{
		format(string_mysql,sizeof(string_mysql),"%s, `parthner%d` = '%d'", string_mysql, i, BizzInfo[idx][bFamilyPartner][i]); // 24 + 11 + 2 (370)
	}
    format(string_mysql,sizeof(string_mysql),"%s WHERE `newid` = '%d'", string_mysql, idx); // 24 + 11
	query_empty(pearsq, string_mysql); // 456
	return 1;
}

stock IsBizTerminal(b)
{
	if(b >= 42 && b <= 52 // Аренда Автомобилей (11)
		|| b >= 62 && b <= 66 // Мотоциклов (5)
		|| b >= 67 && b <= 76 // Скутеров (10)
		|| b >= 153 && b <= 162 // Ларьки (10)
		|| b >= 163 && b <= 172) return 1; // Банкоматы (10)
	return 0;
}

stock IsBizTransfer(b)
{
	if(b >= 13 && b <= 26 // Супермаркеты (14)
		|| b >= 27 && b <= 41 // Оружейный магазин (15)
		|| b >= 93 && b <= 102 // Клубы (10)
		|| b >= 103 && b <= 117 // Закусочные (15)
		|| b >= 123 && b <= 132 // Аптеки (10)
		|| b >= 133 && b <= 142) return 1;  // Магазины с техникой (10)
	return 0;
}

stock BizMapIcon(b)
{
	if(!IsBizTransfer(b)) return 0;
	if(BizIcon[b]) DestroyDynamicMapIcon(BizIcon[b]), BizIcon[b] = 0;
	if(BizType(b) == 1) BizIcon[b] = CreateDynamicMapIcon(BizzInfo[b][bEnterX],BizzInfo[b][bEnterY],BizzInfo[b][bEnterZ],38,0,-1,-1,-1,200.0);
	else if(BizType(b) == 2) BizIcon[b] = CreateDynamicMapIcon(BizzInfo[b][bEnterX],BizzInfo[b][bEnterY],BizzInfo[b][bEnterZ],6,0,-1,-1,-1,200.0);
	else if(BizType(b) == 12) BizIcon[b] = CreateDynamicMapIcon(BizzInfo[b][bEnterX],BizzInfo[b][bEnterY],BizzInfo[b][bEnterZ],48,0,-1,-1,-1,200.0);
	else if(BizType(b) == 13) BizIcon[b] = CreateDynamicMapIcon(BizzInfo[b][bEnterX],BizzInfo[b][bEnterY],BizzInfo[b][bEnterZ],10,0,-1,-1,-1,200.0);
	else if(BizType(b) == 15) BizIcon[b] = CreateDynamicMapIcon(BizzInfo[b][bEnterX],BizzInfo[b][bEnterY],BizzInfo[b][bEnterZ],22,0,-1,-1,-1,200.0);
	else if(BizType(b) == 16) BizIcon[b] = CreateDynamicMapIcon(BizzInfo[b][bEnterX],BizzInfo[b][bEnterY],BizzInfo[b][bEnterZ],25,0,-1,-1,-1,200.0);
	return 1;
}

stock GpsBiz(playerid, bizType)
{
	DP[0][playerid] = bizType;
	new minB, maxB;
	bizTypeMin(bizType, minB, maxB);

	new line[90],lines[4048];
	format(line,sizeof(line),"{ff9000}Ближайший"), strcat(lines,line);

	new quan;
	for(new b = minB; b < maxB + 1; b++) 
	{
		List[quan][playerid] = b;
		quan ++;
		format(line,sizeof(line),"\n{cccccc}№ %d %s", b, BizzInfo[b][bName]), strcat(lines,line);
	}
	new header[60];
	format(header,sizeof(header),"{ff9000}GPS: %s", bizname(minB));
	ShowDialog(playerid,1077,DIALOG_STYLE_LIST,header,lines,"Выбор","Назад");
	return 1;
}

stock CreateGreenZoneBiz(b)
{
	if(BizzInfo[b][bZZ] == 1) return 0;
	dyn_zone_zzBiz[b] = CreateDynamicSphere(BizzInfo[b][bBarX],BizzInfo[b][bBarY],BizzInfo[b][bBarZ], 50, 3000+b, BizzInfo[b][bInterior]);
	BizzInfo[b][bZZ] = 1;
	BizzInfo[b][bUpdate] = 1;
	return 1;
}

stock DestroyGreenZoneBiz(b)
{
	DestroyDynamicArea(dyn_zone_zzBiz[b]);
	BizzInfo[b][bZZ] = 0;
	BizzInfo[b][bUpdate] = 1;
	return 1;
}

stock GetBizArea(areaid)
{
	new bool:yes;
	for(new b; b<MAX_BIZ; b++)
	{
		if(areaid == dyn_zone_zzBiz[b] && BizzInfo[b][bZZ] != 0)
		{
			yes = true;
			break;
		}
	}
	return yes;
}

stock CreateShluha(idx)
{
	new string[70];
    format(string,sizeof(string),"{ff9000}Проститутка\n{44ff99}Цена 200$\n{cccccc}[ ALT ]");
	BizShluha[idx] = CreateDynamicActor(369, BizzInfo[idx][bShluhaCord][0], BizzInfo[idx][bShluhaCord][1], BizzInfo[idx][bShluhaCord][2],180, true, 100.0, 3000+idx, BizzInfo[idx][bInterior], -1, 100.0, -1, 0);
	BizShluhaLabel[idx] = CreateDynamic3DTextLabel(string,-1,BizzInfo[idx][bShluhaCord][0], BizzInfo[idx][bShluhaCord][1], BizzInfo[idx][bShluhaCord][2],3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,3000+idx, BizzInfo[idx][bInterior]); 
	return 1;
}

stock BotSex(playerid,b)
{
	if(BizzInfo[b][bShluha] == 0) return 0;
	if(!IsPlayerInRangeOfPoint(playerid,1.0, BizzInfo[b][bShluhaCord][0],BizzInfo[b][bShluhaCord][1],BizzInfo[b][bShluhaCord][2])) return 0;
	if(BizShluhaStatus[b] >= 0) return ErrorMessage(playerid,"{ff6347}Проститутка в данный момент занята");
	if(OnlineInfo[playerid][oSexBot] > 0) return ErrorMessage(playerid,"{ff6347}Проститутка в данный момент занята");
	if(oGetPlayerMoney(playerid) < 200) return ErrorMessage(playerid,"{ff6347}Вам не хватает денег [ 200$ ]");
	new days, hour, minute, second, unix = gettime(), string[84];
	getunix(PlayerInfo[playerid][pSexBreak]-unix, days, hour, minute, second);
	if(PlayerInfo[playerid][pSexBreak] > unix) return format(string, sizeof(string), "{FF6347}Вы не можете так часто [ Через %02d мин. %02d сек. ]", minute, second), ErrorMessage(playerid, string);
	oGivePlayerMoney(playerid, -200);
	paybiz(b, 200);
	OnlineInfo[playerid][oSexBot] = b, BizShluhaStatus[b] = playerid;
	InputProcess[playerid] = 100;
	new Float:x,Float:y,Float:z,Float:a;
	DynamicActorfrontme(BizShluha[b],0.5,x,y,z,a);
	PPSetPlayerPos(playerid,x,y,z);
	SetPlayerFacingAngle(playerid,a-180);
	ApplyDynamicActorAnimation(BizShluha[b],"BLOWJOBZ","BJ_STAND_LOOP_W", 4.0, 0,0,0,1,0);
	ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_LOOP_P",4.0, false, false, true, false, true);
	Sex[playerid] = 3;
	SexPlayerid[playerid] = 5555;
	SetPVarInt(playerid,"Infect",0);
	if(PlayerInfo[playerid][pSex] == 1) SetPlayerAttachedObject(playerid, 1, 19086, 1, -0.078000, 0.119999, 0.008999, 95.299903, 86.899986, 0.299999, 0.328000, 0.481999, 0.494000, 0, 0);
	PlayerTextDrawShow(playerid, InputDraw1);
	PlayerTextDrawShow(playerid, InputDraw2);
	TextDrawShowForPlayer(playerid, InputDraw[1]);
	procesbar2(playerid, 0);
	ShowInput(playerid);
	SendClientMessage(playerid, COLOR_GREY, "{ff33ff}[ Sex ] {cccccc}Вам нужно заполнить шкалу удовольствия | Нажимайте на кнопки, указанные справа от шкалы");
	SetPVarInt(playerid, "sekas", 10);
	SexTimer[playerid] = SetTimerEx("SexTime", 200, true, "d", playerid,1);
	return 1;
}
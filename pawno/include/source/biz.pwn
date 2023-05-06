
stock productbiz(playerid, b) // Заказ товаров в бизнес
{
	new kolnum;
	format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"{cccccc}Депозит {99ff66}%d$ [%s] \t \t \n", BizzInfo[b][bDeposit], get_k(BizzInfo[b][bDeposit])), strcat(lines,line);
    format(line,sizeof(line),"{ff9000}Заказать Товар\t \t \n"), strcat(lines,line);
    for(new i = 0; i < 50; i++)
	{
		if(BizzInfo[b][bOrder][i] == 0) continue;
		if(BizzInfo[b][bOrder][i] > 0 && BizzInfo[b][bOrderType][i] == 0) delproduct(b, i); // Удаляем невалидные заказы (Старая система)

		if(BizzInfo[b][bOrder][i] > 0)
		{
		    List[kolnum][playerid] = i;
			kolnum ++;
			format(line,sizeof(line),"{ff9000}%d. %s \t{cccccc}[Количество: %d]\t{cccccc}Оплата: {99ff66}%d$\n", i+1, GetNameThing(0, BizzInfo[b][bOrder][i], BizzInfo[b][bOrderType][i], BizzInfo[b][bOrderType][i]), BizzInfo[b][bOrderQuan][i], BizzInfo[b][bOrderPay][i]), strcat(lines,line);
		}
	}
	format(store,sizeof(store),"{cccccc}Бизнес {ff9000}%s [%d]",bizname(b), b);
	ShowDialog(playerid,1054,DIALOG_STYLE_TABLIST,store,lines,"Выбрать","Отмена");
	return 1;
}
stock insertorder(playerid, b, i) // Управление заказом доставки товара
{
    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"{cccccc}Товар: \t{ff9000}%s", GetNameThing(0, BizzInfo[b][bOrder][i], BizzInfo[b][bOrderType][i], BizzInfo[b][bOrderType][i])), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Количество: \t{ffffff}%d", BizzInfo[b][bOrderQuan][i]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Оплата: \t{99ff66}%d$", BizzInfo[b][bOrderPay][i]), strcat(lines,line);
    if(BizzInfo[b][bOrder][i] >= 1) format(line,sizeof(line),"\n{FF6347}Удалить Заказ\t "), strcat(lines,line);
	format(store,sizeof(store),"{cccccc}Бизнес {ff9000}%s [%d]",bizname(b), b);
	ShowDialog(playerid,1058,DIALOG_STYLE_TABLIST,store,lines,"Выбрать","Отмена");
	return 1;
}
stock LoadBusinessProduct(b, stat) // Если нет продукта (значит первый запуск бизнеса, устанавливаем продукты)
{
    new bool:yes[MAX_BIZ_ITEM], bool:yesUpdate;
    if(b <= 12) // Заправки
	{
	    // Тип товара (0 обычный, 1 оружие, 2 аксессуар, 3 одежда, 4 мебель)
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
	}
	if(b >= 27 && b <= 41) // Оружейный Магазин
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
    	if(BizzInfo[b][bProduct][10] == 0 || stat == 1) BizzInfo[b][bProduct][10] = 19106, BizzInfo[b][bTypeProduct][10] = 2, yes[10] = true; // Каска
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
	}
	if(b >= 133 && b <= 142) // Магазины с Техникой
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
	if(b >= 153 && b <= 162) // Ларьки с едой
	{
    	if(BizzInfo[b][bProduct][0] == 0 || stat == 1) BizzInfo[b][bProduct][0] = 168, BizzInfo[b][bTypeProduct][0] = 0, yes[0] = true; // Мясо в упаковке
    	if(BizzInfo[b][bProduct][1] == 0 || stat == 1) BizzInfo[b][bProduct][1] = 1, BizzInfo[b][bTypeProduct][1] = 0, yes[1] = true; // Хлеб
    	if(BizzInfo[b][bProduct][2] == 0 || stat == 1) BizzInfo[b][bProduct][2] = 120, BizzInfo[b][bTypeProduct][2] = 0, yes[2] = true; // Sprunk в бутылке
		if(BizzInfo[b][bProduct][3] == 0 || stat == 1) BizzInfo[b][bProduct][3] = 141, BizzInfo[b][bTypeProduct][2] = 0, yes[3] = true; // Хот Дог
	}
	for(new i = 0; i < MAX_BIZ_ITEM; i++)
    {
        if(BizzInfo[b][bProduct][i] > 0 && (yes[i] || stat == 1))
        {
            if(BizzInfo[b][bTypeProduct][i] == 0) BizzInfo[b][bPrice][i] = friskPrice[BizzInfo[b][bProduct][i]];
            else if(BizzInfo[b][bTypeProduct][i] == 1) BizzInfo[b][bPrice][i] = gunPrice[BizzInfo[b][bProduct][i]];
            else if(BizzInfo[b][bTypeProduct][i] == 2) BizzInfo[b][bPrice][i] = 10000;
            
            if(BizzInfo[b][bProduct][i] == 178) BizzInfo[b][bItem][i] = 50000; // Топливо
            else if(BizzInfo[b][bProduct][i] >= 27 && BizzInfo[b][bProduct][i] <= 30) BizzInfo[b][bItem][i] = 10000; // Патроны
            else BizzInfo[b][bItem][i] = 1000;
            
            yesUpdate = true;
        }
    }
    if(yesUpdate)
	{
	    if(b <= 12) UpdateFillLabel(b);
	    if(b >= 13 && b <= 26) UpdateSupermarketLabel(b);
		SaveBizzProduct(b);
	}
	return 1;
}
stock pricebiz(playerid, b)
{
	DP[4][playerid] = b;
	
	if(b >= 173 && b <= 182) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Прайс можно настроить только в меню выбора товара"), mybiz(playerid, b);
	new lol[84], quan;
	format(lines,sizeof(lines),""); // Очищаем Lines
	if(b >= 1 && b <= 12 || b >= 13 && b <= 26 || b >= 27 && b <= 41 || b >= 123 && b <= 132 || b >= 133 && b <= 142 || b >= 42 && b <= 76 ) // Прайс автоматгенерация
	{
		for(new i = 0; i < MAX_BIZ_ITEM; i++)
    	{
			List[quan][playerid] = i;
			if(b >= 42 && b <= 76) format(line,sizeof(line),"{cccccc}%s \t {99ff66}[%d$]\n",vehName[BizzInfo[b][bProduct][i]], BizzInfo[b][bPrice][i]), strcat(lines,line);
			else format(line,sizeof(line),"\n{cccccc}%s \t {99FF66}[%d$]",GetNameThing(0, BizzInfo[b][bProduct][i], BizzInfo[b][bTypeProduct][i], 0),BizzInfo[b][bPrice][i]), strcat(lines,line);
			quan++;
		}		
	}
	else if(b >= 153 && b <= 162) // Прайс Ларьков
	{
		List[0][playerid] = 3;
		List[0][playerid] = 2;
		format(line,sizeof(line),"{cccccc}%s \t {99FF66}[%d$]",GetNameThing(0, BizzInfo[b][bProduct][3], BizzInfo[b][bTypeProduct][3], 0),BizzInfo[b][bPrice][3]), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}%s \t {99FF66}[%d$]",GetNameThing(0, BizzInfo[b][bProduct][2], BizzInfo[b][bTypeProduct][2], 0),BizzInfo[b][bPrice][2]), strcat(lines,line);
	}
	else if(b >= 163 && b <= 172) // Прайс Банкоматов
	{
		format(line,sizeof(line),"{cccccc}Комиссия на {99ff66}Внесение \t [%.3f проц.]\n", comput[b-163]), strcat(lines,line);
		format(line,sizeof(line),"{cccccc}Комиссия на {FF6347}Вывод {99ff66} \t [%.3f проц.]\n", comtake[b-163]), strcat(lines,line);
		format(lol,sizeof(lol),"{cccccc}Прайс Бизнеса {ff9000}%s [%d]",bizname(b), b);
		ShowDialog(playerid,1171,DIALOG_STYLE_LIST,lol,lines,"Выбрать","Отмена");
		return 1;
	}
	else return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: В этом бизнесе нельзя настраивать стоимость товаров или услуг"), mybiz(playerid, b);
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
	if(IsPlayerInRangeOfPoint(playerid,200.0,BizzInfo[biz][bX], BizzInfo[biz][bY], BizzInfo[biz][bZ])) return ErrorMessage(playerid, "{FF6347}Вы далеко от склада бизнеса"), tabs_close(playerid, 2), OnlineInfo[playerid][oShowInterfaceBiz] = 0, Tabs_Type[playerid] = 0;
    new thingType = BizzInfo[biz][bInvType][inva];
    if(thingType == 4)
    {
     	PlayerPlaySound(playerid,1052,0,0,0);
		new obid;
		if(BizzInfo[biz][bFrame] == 0) return ErrorMessage(playerid, "{FF6347}В этом бизнесе не установлен каркас"), i_resettabs(playerid);
		if(BizzInfo[biz][bSell]  >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя заниматься ремонтом интерьера во время продажи"), i_resettabs(playerid);
		if(CheckObjectBiz(biz)) return ErrorMessage(playerid, "{FF6347}Лимит объектов мебели: 60"), i_resettabs(playerid);
		obid = BizzInfo[biz][bInvent][inva], BizzInfo[biz][bInvent][inva] = 0, BizzInfo[biz][bInv][inva] = 0, BizzInfo[biz][bInvPara][inva] = 0, BizzInfo[biz][bInvQara][inva] = 0, BizzInfo[biz][bInvType][inva] = 0, BizzInfo[biz][bInvPack][inva] = 0;
		SaveSkladBiz(biz, inva);
		CloseFrisk(playerid);
      	new Float:f_pos[4];
		frontme(playerid, 3.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
      	gRedakt[playerid] = 17;
       	Vrobj[playerid] = CreateDynamicObject(obid, f_pos[0], f_pos[1], f_pos[2], 0.0000, 0.0000, 0.0000, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 100.00, 100.00);
       	Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
        Idobj[playerid] = obid;
        gRedakt2[playerid] = 0;
		EditDynamicObject(playerid, Vrobj[playerid]);
		PlayerPlaySound(playerid,6400,0,0,0);
		return 1;
	}
	return 1;
}
stock shift_biz(playerid, b, getinva, putinva)
{
	if(OnlineInfo[playerid][oShowInterfaceBiz] > 0)
	{
		if(BizzInfo[b][bInvent][getinva] == 0) return i_resettabs(playerid);
		else if(BizzInfo[b][bInvent][putinva] != 0) return 1;
		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
		    if(OnlineInfo[playerid][oShowInterfaceBiz] != OnlineInfo[i][oShowInterfaceBiz]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
		    format(store, sizeof(store), "{FF6347}Склад бизнеса просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, store);
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
		SaveSkladBiz(b, getinva);
		SaveSkladBiz(b, putinva);
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
		    if(friskKol[thingId] == 1) // Предмет имеет количество (Складывается в одну ячейку)
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
			else if(friskKol[thingId] == 0) // Объект не имеет количество
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
		if(OnlineInfo[playerid][oLogged] == 1 && OnlineInfo[playerid][oShowInterface] == 1 && OnlineInfo[playerid][oShowInterfaceBiz] == b) item_second(playerid, thingId, quan, i, 0, para, thingType, 0, 0);
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
		if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowInterfaceBiz] == b) item_second(i, BizzInfo[b][bInvent][plalit], BizzInfo[b][bInv][plalit], plalit, 0, BizzInfo[b][bInvPara][plalit], BizzInfo[b][bInvType][plalit], BizzInfo[b][bInvPack][plalit], 0);
	}
	return 1;
}
stock SaveSkladBiz(idx, i) // Сохраняем ячейку склада бизнеса
{
	format(big_query, sizeof(big_query), "UPDATE `pp_bizz` SET `Invent%d`='%d',`Inv%d`='%d',`InvPara%d`='%d',`InvQara%d`='%d',`InvType%d`='%d',`InvPack%d`='%d' WHERE `newid`='%d'",
	i,BizzInfo[idx][bInvent][i],i,BizzInfo[idx][bInv][i],i,BizzInfo[idx][bInvPara][i],i,BizzInfo[idx][bInvQara][i],i,BizzInfo[idx][bInvType][i],i,BizzInfo[idx][bInvPack][i],idx);
	query_empty(pearsq, big_query);
	return 1;
}
stock delproduct(b, ord) // Удаляем заказ доставки товара в бизнесы
{
	BizzInfo[b][bOrder][ord] = 0;
    BizzInfo[b][bOrderQuan][ord] = 0;
    BizzInfo[b][bOrderPay][ord] = 0;
    BizzInfo[b][bOrderType][ord] = 0;
    SaveBizzOrder(b, ord);
    BizzInfo[b][bOrders] --;
    Orders --;
}
stock IsBizOrder(b)
{
    // Заправка, Супермаркет, Оружейный Магазин, Аптека
	// Магазин с Техникой, Магазин Одежды
    if(b <= 12 || b >= 13 && b <= 26 || b >= 27 && b <= 41 || b >= 123 && b <= 132
	|| b >= 133 && b <= 142 || b >= 173 && b <= 182) return 1;
	return 0;
}
stock SendBizMessage(b, const string[]) // Сообщение в чат семье, привязанной к бизнесу
{
    if(BizzInfo[b][bFam] > 0)
	{
        if(FamilyInfo[BizzInfo[b][bFam]][fSost] > 0) SendSkypeMessage(BizzInfo[b][bFam], COLOR_GREY, string);
	}
	return 1;
}
stock ResetBizzPriceItem(playerid, b, thingId, thingType, input)
{
    new bool:bizUpdate;
    if(b >= 1 && b <= 12) // Заправки
    {
        BizzInfo[b][bPrice][0] = friskPrice[thingId]+friskPrice[thingId]/2, UpdateFillLabel(b), SaveBizzProductItem(b, 0), bizUpdate = true;
    }
    else if(b >= 13 && b <= 26 || b >= 27 && b <= 41 || b >= 123 && b <= 132 || b >= 133 && b <= 142) // Супермаркеты, Оружейный Магазин, Аптеки, Магазины с Техникой
    {
        for(new i = 0; i < MAX_BIZ_ITEM; i++)
    	{
    		if(BizzInfo[b][bProduct][i] == thingId && BizzInfo[b][bTypeProduct][i] == thingType)
			{
				if(BizzInfo[b][bTypeProduct][i] == 0) BizzInfo[b][bPrice][i] = friskPrice[thingId]+friskPrice[thingId]/2, bizUpdate = true;
				else if(BizzInfo[b][bTypeProduct][i] == 1) BizzInfo[b][bPrice][i] = gunPrice[thingId]+gunPrice[thingId]/2, bizUpdate = true;
			}
    	}
    	if(b >= 13 && b <= 26) UpdateSupermarketLabel(b);
    	SaveBizzProduct(b);
    }
	if(b >= 173 && b <= 182) // Магазины с Одеждой
	{
	    new bn = b-173;
	    for(new gs = 0; gs < 50; gs++) // Прокатываем цикл по слотам с одеждой
		{
			if(StoreItem[bn][gs] == thingId) StorePrice[bn][gs] = SkinGos[thingId]+SkinGos[thingId]/2, bizUpdate = true, SaveBizzStore(bn, gs); // Нашли скин и установили новую стоимость
		}
	}
	if(bizUpdate && BizzInfo[b][bSost] > 0) // Если изменения для бизнеса были, отправляем все необходимые уведомления
	{
        format(store, sizeof(store), "Новая гос. стоимость %s [%d$]", GetNameThing(0, thingId, thingType, 0), input);
		notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], BizzInfo[b][bSost], BizzInfo[b][bVlad], store);
	}
	return 1;
}
stock SaveBizz(b)
{
	new f_str1[24],f_str2[34],f_str3[64],f_str4[64];
	mysql_escape_string(BizzInfo[b][bVlad], f_str1, sizeof(f_str1));
	mysql_escape_string(BizzInfo[b][bName], f_str2, sizeof(f_str2));
	mysql_escape_string(BizzInfo[b][bArReason], f_str3, sizeof(f_str3));
	mysql_escape_string(BizzInfo[b][bStatReason], f_str4, sizeof(f_str4));
	format(big_query, sizeof(big_query), "UPDATE `pp_bizz` SET `Vlad`='%s',`Level`='%d',`Sost`='%d',`Data`='%d',`Freeze`='%d',`Arest`='%d',`Fam`='%d',`Intorval`='%d',\
	`bcX`='%f',`bcY`='%f',`bcZ`='%f',`Lab`='%d',`Descrip`='%d',`Name`='%s',",f_str1,
	BizzInfo[b][bLevel], BizzInfo[b][bSost], BizzInfo[b][bData], BizzInfo[b][bFreeze], BizzInfo[b][bArest], BizzInfo[b][bFam], BizzInfo[b][bInterval],
	BizzInfo[b][bX], BizzInfo[b][bY], BizzInfo[b][bZ], BizzInfo[b][bLab], BizzInfo[b][bDescrip], f_str2);

	format(big_query, sizeof(big_query), "%s`obX0`='%f',`obY0`='%f',`obZ0`='%f',`obRX0`='%f',`obRY0`='%f',`obRZ0`='%f',`obX1`='%f',`obY1`='%f',`obZ1`='%f',`obRX1`='%f',`obRY1`='%f',`obRZ1`='%f'\
	,`EnterX`='%f',`EnterY`='%f',`EnterZ`='%f',`EnterA`='%f',`Frame`='%d',`InteriorX`='%f',`InteriorY`='%f',`InteriorZ`='%f',`InteriorA`='%f',`Inter`='%d',",big_query,
	BizzInfo[b][bBizOX][0],BizzInfo[b][bBizOY][0],BizzInfo[b][bBizOZ][0],BizzInfo[b][bBizORX][0],BizzInfo[b][bBizORY][0],BizzInfo[b][bBizORZ][0],
	BizzInfo[b][bBizOX][1],BizzInfo[b][bBizOY][1],BizzInfo[b][bBizOZ][1],BizzInfo[b][bBizORX][1],BizzInfo[b][bBizORY][1],BizzInfo[b][bBizORZ][1],BizzInfo[b][bEnterX],BizzInfo[b][bEnterY],
	BizzInfo[b][bEnterZ],BizzInfo[b][bEnterA],BizzInfo[b][bFrame], BizzInfo[b][bInteriorX], BizzInfo[b][bInteriorY], BizzInfo[b][bInteriorZ], BizzInfo[b][bInteriorA], BizzInfo[b][bInterior]);
	format(big_query, sizeof(big_query), "%s`PriceProd`='%d',`Bablo`='%d',`Schet`='%d',`Sell`='%d',`Pastime`='%d',`Mafunix`='%d',`acc0`='%d',`acc1`='%d',`acc2`='%d',`acc3`='%d',`acc4`='%d',\
	`acc5`='%d',`acc6`='%d',`acc7`='%d',`acc8`='%d',`acc9`='%d',`acc10`='%d',`Taxes`='%d',`Warn`='%d',`Lien`='%d',`ArTime`='%d',`ArReason`='%s',`Stat`='%d',`StatReason`='%s',`Taxday`='%d',`Deposit`='%d',`Income`='%d' WHERE `newid`='%d'", big_query,
	BizzInfo[b][bMafia],BizzInfo[b][bBablo],BizzInfo[b][bSchet],BizzInfo[b][bSell],BizzInfo[b][bPastime],BizzInfo[b][bMafunix],BizzInfo[b][bAcc][0],BizzInfo[b][bAcc][1],
	BizzInfo[b][bAcc][2],BizzInfo[b][bAcc][3],BizzInfo[b][bAcc][4],BizzInfo[b][bAcc][5],BizzInfo[b][bAcc][6],BizzInfo[b][bAcc][7],BizzInfo[b][bAcc][8],BizzInfo[b][bAcc][9],BizzInfo[b][bAcc][10], BizzInfo[b][bTaxes],
	BizzInfo[b][bWarn],BizzInfo[b][bLien],BizzInfo[b][bArTime], f_str3, BizzInfo[b][bStat], f_str4, BizzInfo[b][bTaxday], BizzInfo[b][bDeposit], BizzInfo[b][bIncome], b);
	query_empty(pearsq, big_query);
	return true;
}
stock SaveBizzProduct(idx)
{
	format(big_query,sizeof(big_query),"UPDATE `pp_bizz` SET `Item0` = '%d', `Price0` = '%d', `Product0` = '%d', `TypeProduct0` = '%d'",
	BizzInfo[idx][bItem][0], BizzInfo[idx][bPrice][0], BizzInfo[idx][bProduct][0], BizzInfo[idx][bTypeProduct][0]);
	for(new i = 1; i < MAX_BIZ_ITEM; i++) format(big_query,sizeof(big_query),"%s, `Item%d` = '%d', `Price%d` = '%d', `Product%d` = '%d', `TypeProduct%d` = '%d'", big_query,
	i, BizzInfo[idx][bItem][i], i, BizzInfo[idx][bPrice][i], i, BizzInfo[idx][bProduct][i], i, BizzInfo[idx][bTypeProduct][i]);
    format(big_query,sizeof(big_query),"%s WHERE `newid` = '%d'", big_query, idx);
	query_empty(pearsq, big_query);
	return 1;
}
stock SaveBizzProductItem(idx, i)
{
	format(big_query,sizeof(big_query),"UPDATE `pp_bizz` SET `Item%d` = '%d', `Price%d` = '%d', `Product%d` = '%d', `TypeProduct%d` = '%d' WHERE `newid` = '%d'",
	i, BizzInfo[idx][bItem][i], i, BizzInfo[idx][bPrice][i], i, BizzInfo[idx][bProduct][i], i, BizzInfo[idx][bTypeProduct][i], idx);
	query_empty(pearsq, big_query);
	return 1;
}

new BoxStat,BoxStatLV,BoxStatLS,BoxStatSF, train; // Общее количество ящиков

static Float:StationTrain[3][3] = { // Координаты станции поезда
	{1390.6432,2638.9263,11.3906}, // 0 LV
	{1798.0410,-1949.7764,13.5469}, // 1 LS
	{1798.0410,-1949.7764,13.5469} // 2 SF
};

stock IsAStationTrainPos(playerid)
{
    if((IsPlayerInRangeOfPoint(playerid,2.0,StationTrain[0][0],StationTrain[0][1],StationTrain[0][2]) || IsPlayerInRangeOfPoint(playerid,2.0,StationTrain[1][0],StationTrain[1][1],StationTrain[1][2])
	|| IsPlayerInRangeOfPoint(playerid,2.0,StationTrain[2][0],StationTrain[2][1],StationTrain[2][2])) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER
	&& GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) return 1;
	return 0;
}
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
            format(line,sizeof(line),"\n{ff9000}%s {333333}| %s \t{333333}%d/%d \t{99ff66}%d$", GetNameThing(0, i, 0, 0), getAmmoName(i), get_sklad(g,i,0), maxQuanThingProductEscort(0), getThingPriceGos(i, 0)), strcat(lines,line);
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
            format(line,sizeof(line),"\n{cccccc}%s \t{333333}%d/%d \t{99ff66}%d$", GetNameThing(0, i, 1, 0), get_sklad(g, i, 1), maxQuanThingProductEscort(1), getThingPriceGos(i, 1)), strcat(lines,line);
        }
    }

    List[quan][playerid] = 19142;
    ListParam[quan][playerid] = 2;
    quan ++;
    format(line,sizeof(line),"\n{ff9000}Бронежилет \t{333333}%d/%d \t{99ff66}%d$", get_sklad(g,19142,2), maxQuanThingProductEscort(2), getThingPriceGos(19142, 2)), strcat(lines,line);
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
stock maxQuanThingProductEscort(thingType)
{
	new maxQuan;
	if(thingType == 0)
	{
		maxQuan = 10000;
	}
	else maxQuan = 100; 
	return maxQuan;
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

stock orderfrak(playerid)
{
	new quan;
	format(lines,sizeof(lines),""); // Очищаем Lines
	format(line,sizeof(line),"{cccccc}Фракция\n"), strcat(lines,line);
	format(line,sizeof(line),"\n{FF6347}Отменить Доставку \t "), strcat(lines,line);
	for(new g = 0; g < sizeof(OrganInfo); g++)
	{
		if(OrganInfo[g][gOrderStatus] == 1 && OrganInfo[g][gDeliveryOrder] == -1)
		{
			List[quan][playerid] = g;
			quan ++;
			format(line,sizeof(line),"\n{ff9000}[№ %d] %s", g, frakeasyName[g]), strcat(lines,line);
		}
	}
	format(store,sizeof(store),"{cccccc}Доставка Боеприпасов");
	ShowDialog(playerid,1385,DIALOG_STYLE_TABLIST_HEADERS,store,lines,"Выбрать","Отмена");
	PlayerPlaySound(playerid,40405,0,0,0);
	return 1;
}

stock LoadOrderEscort(playerid)
{
	new veh = GetPlayerVehicleID(playerid);
	new model = GetVehicleModel(veh);
	if(model != 433) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не на спец.транспорте(Barracks)");
	if(GetPVarInt(playerid,"delivery_frak") >= 1 && GetPVarInt(playerid,"delivery_frak_status") == 1) 
	{
		SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Молодец, отправляйтесь к ЖД станции для отправки БП на поезде(отмечено в GPS Навигаторе) ");
		SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Не забудьте собрать людей для сопровождения, на вас могут напасть!");
		SetPVarInt(playerid,"delivery_frak_status",2);
		CreateGps(playerid, 137.91, 1289.1465, 21.3203, 0, 0, 10.0);
	} 
	else return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не выполняю доставку боеприпасов");
	return 1;
}

stock LoadOrderEscortTrain(playerid)
{
	new veh = GetPlayerVehicleID(playerid);
	new model = GetVehicleModel(veh);
	if(model != 433) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не на спец.транспорте(Barracks)");
	if(GetPVarInt(playerid,"delivery_frak") >= 1 && GetPVarInt(playerid,"delivery_frak_status") == 2) 
	{
		SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Садитесь в поезд и ожидайте загрузку Боеприпасов в поезд");
		SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Как все ящики будут загружены вы сможете тронуться(необходимо погудеть перед отправкой)");
		SetPVarInt(playerid,"delivery_frak_status",3);
		BoxStat = 20;
		CreateGps(playerid, 137.91, 1289.1465, 21.3203, 0, 0, 10.0); // Указать корды куда следовать.
	} 
	else return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не выполняю доставку боеприпасов");
	return 1;
}

stock NGSAWorkToTrain(playerid, status)
{
	if(PlayerInfo[playerid][pMember] == 3)
	{
		if(IsPlayerInAnyVehicle(playerid)) return 1;
		if(Hand[playerid] > 0 || Hold[playerid] >= 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня руки заняты");
		if (status == 0)
		{
			if(BoxStat < 1) return ErrorMessage(playerid, "{FF6347}В машине больше нет ящиков");
			if(MG151[playerid] == 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня в руках ящик, который нужно отнести в поезд");
			BoxStat -= 1;
  		} 
		else if (status == 1)
		{
			if(BoxStatLV < 1) return ErrorMessage(playerid, "{FF6347}В поезде больше нет ящиков");
			if(MG151[playerid] == 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня в руках ящик, который нужно отнести в машину");
			BoxStatLV -= 1;
		}
		else if (status == 2)
		{
			if(BoxStatLS < 1) return ErrorMessage(playerid, "{FF6347}В поезде больше нет ящиков");
			if(MG151[playerid] == 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня в руках ящик, который нужно отнести в машину");
			BoxStatLS -= 1;
		}
		else if (status == 3)
		{
			if(BoxStatSF < 1) return ErrorMessage(playerid, "{FF6347}В поезде больше нет ящиков");
			if(MG151[playerid] == 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня в руках ящик, который нужно отнести в машину");
			BoxStatSF -= 1;
		}
		ApplyAnimation(playerid,"CARRY","liftup",4.1,0,1,1,1,1), SetPlayerChatBubble(playerid,"берёт ящик с боеприпасами",COLOR_PURPLE,20.0,3000);
		RemovePlayerAttachedObject(playerid,1);
		SetPlayerAttachedObject(playerid,1 , 3014, 6, 0.120000, 0.199448, -0.120000, 254.000000, 0.900000, 70.000000);
		PPP15[playerid] = 3, MG151[playerid] = 2;
		Hand[playerid] = 2;
	} else return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не состою в NGSA");
	return 1;
} 
stock NGSAWorkToTrainPut(playerid)
{
	if(PlayerInfo[playerid][pMember] == 3)
	{
		if(IsPlayerInAnyVehicle(playerid)) return 1;
		if(MG151[playerid] != 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня в руках нет ящика с боеприпасами");
		PPP15[playerid] = 0, MG151[playerid] = 0, Hand[playerid] = 0;
		ApplyAnimation(playerid,"CARRY","putdwn",4.0,0,0,0,0,0,1);
		SetPlayerChatBubble(playerid,"кладёт ящик с боеприпасами",COLOR_PURPLE,20.0,3000);
		RemovePlayerAttachedObject(playerid,1);
	} else return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не состою в NGSA");
	return 1;
}

stock GoTrainToStation(playerid)
{
	new veh = GetPlayerVehicleID(playerid);
	new model = GetVehicleModel(veh);
	if(model != 537) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не сижу в поезде");
	if(BoxStat != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не все ящики находятся в поезде.");
	if(GetPVarInt(playerid,"delivery_frak") >= 1 && GetPVarInt(playerid,"delivery_frak_status") == 3) 
	{
		SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Ожидайте пока все усядутся и трогайтесь!");
		SetPVarInt(playerid,"delivery_frak_status",4);
		if (GetPVarInt(playerid,"delivery_frak") == 2 || GetPVarInt(playerid,"delivery_frak") == 21 || GetPVarInt(playerid,"delivery_frak") == 22){
			CreateGps(playerid, 1390.6432,2638.9263,11.3906, 0, 0, 10.0); // Указать корды куда следовать.
		}
		else if (GetPVarInt(playerid,"delivery_frak") == 1){
			CreateGps(playerid, 1798.0410,-1949.7764,13.5469, 0, 0, 10.0); // Указать корды куда следовать.
		}
		else if (GetPVarInt(playerid,"delivery_frak") == 7 || GetPVarInt(playerid,"delivery_frak") == 11){
			CreateGps(playerid, 1798.0410,-1949.7764,13.5469, 0, 0, 10.0); // Указать корды куда следовать.
		}
	} 
	else return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не выполняю доставку боеприпасов");
	return 1;
}

stock GoPutIsTrain(playerid)
{
	new veh = GetPlayerVehicleID(playerid);
	new model = GetVehicleModel(veh);
	if(model != 537) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не сижу в Поезде");
	if(GetPVarInt(playerid,"delivery_frak") >= 1 && GetPVarInt(playerid,"delivery_frak_status") == 4)
	{
		SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Производите разгрузку и садитесь в спец.транспорт");
		SetPVarInt(playerid,"delivery_frak_status",5);
		if((IsPlayerInRangeOfPoint(playerid,2.0,StationTrain[0][0],StationTrain[0][1],StationTrain[0][2])))
		{
			BoxStatLV += 20;
		}
		else if ((IsPlayerInRangeOfPoint(playerid,2.0,StationTrain[1][0],StationTrain[1][1],StationTrain[1][2])))
		{
			BoxStatLS += 20;
		}
		else if ((IsPlayerInRangeOfPoint(playerid,2.0,StationTrain[2][0],StationTrain[2][1],StationTrain[2][2])))
		{
			BoxStatSF += 20;
		}
	}
	return 1;
}

stock GoEscortToBaseFrak(playerid)
{
	new veh = GetPlayerVehicleID(playerid);
	new model = GetVehicleModel(veh);
	if(model != 433) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не сижу в спец.транспорте");
	if(GetPVarInt(playerid,"delivery_frak") >= 1 && GetPVarInt(playerid,"delivery_frak_status") == 5)
	{
		SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Отправляйтесь к зданию указанному в GPS");
		SetPVarInt(playerid,"delivery_frak_status",6);
		if (GetPVarInt(playerid,"delivery_frak") == 1)
		{
			CreateGps(playerid,1555.5037,-1675.6438,16.1953, 0, 0, 5.0);
		    SendClientMessage(playerid, COLOR_GREY, " {0088ff}[ {ffffff}Карта {0088ff}]{ffffff}: {0088ff}LSPD {ffffff}отмечен на карте");
		}
		else if (GetPVarInt(playerid,"delivery_frak") == 2)
		{
			CreateGps(playerid,2127.6096,2378.3899,10.8203, 0, 0, 5.0);
			SendClientMessage(playerid,COLOR_WHITE," {0088ff}[ {ffffff}Карта {0088ff}]{ffffff}: {0088ff}FBI {ffffff}отмечен на карте");
		}
		else if (GetPVarInt(playerid,"delivery_frak") == 7)
		{
			CreateGps(playerid,-2721.7415,-324.6003,9.1620, 0, 0, 5.0);
			SendClientMessage(playerid,COLOR_WHITE," {0088ff}[ {ffffff}Карта {0088ff}]{ffffff}: {0088ff}Правительство {ffffff}отмечено на карте");
		}
		else if (GetPVarInt(playerid,"delivery_frak") == 11)
		{
			CreateGps(playerid,-1605.4895,716.8007,11.9735, 0, 0, 5.0);
			SendClientMessage(playerid,COLOR_WHITE," {0088ff}[ {ffffff}Карта {0088ff}]{ffffff}: {0088ff}SFPD {ffffff}отмечен на карте");
		}
		else if (GetPVarInt(playerid,"delivery_frak") == 21)
		{
			//lvpd
		}
		else if (GetPVarInt(playerid,"delivery_frak") == 22)
		{
			CreateGps(playerid,2388.9980,2466.0085,10.8203, 0, 0, 5.0);
			SendClientMessage(playerid,COLOR_WHITE," {0088ff}[ {ffffff}Карта {0088ff}]{ffffff}: {0088ff}SWAT {ffffff}отмечен на карте");
		}
	}
	return 1;
}

/*
stock ARobTrain(playerid)
{
	foreach(Player,i)
	{
		if (OnlineInfo[i][oLogged] == 0) continue;
		if(PlayerInfo[i][pMember] == 3 ||PlayerInfo[i][pLeader] == 3)
		{
			if(IsPlayerInRangeOfPoint(playerid,100.0,StationTrain[0][0],StationTrain[0][1],StationTrain[0][2]))
		}
	}
}*/

CMD:ngsaescort(playerid,const params[])
{
	if(PlayerInfo[playerid][pSoska] >= 20)
	{
	if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать статус доставки [ Номер процесса,FRAK (2,21,22,1,7,11) ]");
	SetPVarInt(playerid,"delivery_frak_status",params[0]);
	SetPVarInt(playerid,"delivery_frak",params[1]);
	}
	return 1;
}
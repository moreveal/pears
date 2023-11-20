new BoxStat,BoxStatLV,BoxStatLS,BoxStatSF; // Общее количество ящиков
new train;
new train_object1, train_object2;

#define MAX_POS_SIDE_TRAIN 14
new Float:train_side_X[2][MAX_POS_SIDE_TRAIN], Float:train_side_Y[2][MAX_POS_SIDE_TRAIN], Float:train_side_Z[2][MAX_POS_SIDE_TRAIN];

stock GetCoordTrain(vehicleid, &Float:x, &Float:y, &Float:z) // Координаты багажника автомобиля
{
    new Float:angle,Float:distance;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), 1, x, distance, z);
    distance = distance/2 + 50;
	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, angle);
    x += (distance * floatsin(-angle+180, degrees));
    y += (distance * floatcos(-angle+180, degrees));
    return 1;
}

static Float:StationTrain[3][3] = { // Координаты станции поезда
	{2864.7500,1308.7200,12.3495}, // 0 LV
	{1776.9491,-1953.8057,15.0995}, // 1 LS
	{-1944.3595,115.9928,27.2245} // 2 SF
};

static Float:StationTrainGoEscort[3][3] = { // Координаты станции поезда
	{2856.7761,1229.0349,10.8984}, // 0 LV
	{1777.7351,-1936.8763,13.5507}, // 1 LS
	{-1985.2375,190.4366,27.6875} // 2 SF
};
stock IsAStationTrainPosGoEscort(playerid)
{
    if((IsPlayerInRangeOfPoint(playerid,2.0,StationTrainGoEscort[0][0],StationTrainGoEscort[0][1],StationTrainGoEscort[0][2]) || IsPlayerInRangeOfPoint(playerid,2.0,StationTrainGoEscort[1][0],StationTrainGoEscort[1][1],StationTrainGoEscort[1][2])
	|| IsPlayerInRangeOfPoint(playerid,2.0,StationTrainGoEscort[2][0],StationTrainGoEscort[2][1],StationTrainGoEscort[2][2])) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER
	&& GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) return 1;
	return 0;
}
stock IsAStationTrainPos(playerid)
{
    if((IsPlayerInRangeOfPoint(playerid,2.0,StationTrain[0][0],StationTrain[0][1],StationTrain[0][2]) || IsPlayerInRangeOfPoint(playerid,2.0,StationTrain[1][0],StationTrain[1][1],StationTrain[1][2])
	|| IsPlayerInRangeOfPoint(playerid,2.0,StationTrain[2][0],StationTrain[2][1],StationTrain[2][2])) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER
	&& GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) return 1;
	return 0;
}
stock OrderEscort(playerid, frak)
{
	DP[4][playerid] = frak;
	new g = fraction(playerid);
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
            format(line,sizeof(line),"\n{ff9000}%s {444444}| %s \t{444444}%d/%d \t{99ff66}%d$", GetNameThing(0, i, 0, 0), getAmmoName(i), get_sklad(g,i,0), maxQuanThingProductEscort(0), getThingPriceGos(i, 0)), strcat(lines,line);
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
            format(line,sizeof(line),"\n{cccccc}%s \t{444444}%d/%d \t{99ff66}%d$", GetNameThing(0, i, 1, 0), get_sklad(g, i, 1), maxQuanThingProductEscort(1), getThingPriceGos(i, 1)), strcat(lines,line);
        }
    }

    List[quan][playerid] = 19142;
    ListParam[quan][playerid] = 2;
    quan ++;
    format(line,sizeof(line),"\n{ff9000}Бронежилет \t{444444}%d/%d \t{99ff66}%d$", get_sklad(g,19142,2), maxQuanThingProductEscort(2), getThingPriceGos(19142, 2)), strcat(lines,line);
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
		format(big_query, sizeof(big_query), "UPDATE `pp_organization` SET `Order%d`='%d',`OrderQuan%d`='%d',`OrderType%d`='%d' WHERE `frakid` = '%d'", ord, OrganInfo[idx][gOrder][ord], ord, OrganInfo[idx][gOrderQuan][ord], ord, OrganInfo[idx][gOrderType][ord], idx);
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
		format(store, sizeof(store), "** NGSA начинает грузить боеприпасы в поезд для %s **", frakeasyName[GetPVarInt(playerid,"delivery_frak")]);
		SendGangMessage(COLOR_ALLDEPT, store);
        SendMafiaMessage(COLOR_ALLDEPT, store);
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
		new Float:Boot[3];
		GetCoordTrain(train,Boot[0],Boot[1],Boot[2]);
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
			if(!IsPlayerInRangeOfPoint(playerid,5.0,Boot[0],Boot[1],Boot[2])) return ErrorMessage(playerid, "{FF6347}Поезда нет на данной станции");
			if(BoxStatLV < 1) return ErrorMessage(playerid, "{FF6347}В поезде больше нет ящиков");
			if(MG151[playerid] == 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня в руках ящик, который нужно отнести в машину");
			BoxStatLV -= 1;
		}
		else if (status == 2)
		{
			if(!IsPlayerInRangeOfPoint(playerid,5.0,Boot[0],Boot[1],Boot[2])) return ErrorMessage(playerid, "{FF6347}Поезда нет на данной станции");
			if(BoxStatLS < 1) return ErrorMessage(playerid, "{FF6347}В поезде больше нет ящиков");
			if(MG151[playerid] == 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня в руках ящик, который нужно отнести в машину");
			BoxStatLS -= 1;
		}
		else if (status == 3)
		{
			if(!IsPlayerInRangeOfPoint(playerid,5.0,Boot[0],Boot[1],Boot[2])) return ErrorMessage(playerid, "{FF6347}Поезда нет на данной станции");
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
		if(BoxStat > 0)
		{
			new Float:Boot[3];
			GetCoordTrain(train,Boot[0],Boot[1],Boot[2]);
			if(!IsPlayerInRangeOfPoint(playerid,10.0,Boot[0]-4,Boot[1],Boot[2])) return ErrorMessage(playerid, "{FF6347}Поезда нет на данной станции");
		}
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
		format(store, sizeof(store), "** NGSA начинает движение на поезде к вокзалу. Они доставляют боеприпасы для %s **", frakeasyName[GetPVarInt(playerid,"delivery_frak")]);
		SendGangMessage(COLOR_ALLDEPT, store);
        SendMafiaMessage(COLOR_ALLDEPT, store);
		SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Ожидайте пока все усядутся и трогайтесь!");
		SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}По прибытию на станцию необходимо погудеть!");
		SetPVarInt(playerid,"delivery_frak_status",4);
		if (GetPVarInt(playerid,"delivery_frak") == 2 || GetPVarInt(playerid,"delivery_frak") == 21 || GetPVarInt(playerid,"delivery_frak") == 22){
			CreateGps(playerid, 2864.7500,1308.7200,12.3495, 0, 0, 10.0); 
		}
		else if (GetPVarInt(playerid,"delivery_frak") == 1){
			CreateGps(playerid, 1776.9491,-1953.8057,15.0995, 0, 0, 10.0);
		}
		else if (GetPVarInt(playerid,"delivery_frak") == 7 || GetPVarInt(playerid,"delivery_frak") == 11){
			CreateGps(playerid, -1944.3595,115.9928,27.2245, 0, 0, 10.0);
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
		format(store, sizeof(store), "** NGSA прибыли на вокзал. Они разгружают поезд, и после напрявятся к зданию %s **", frakeasyName[GetPVarInt(playerid,"delivery_frak")]);
		SendGangMessage(COLOR_ALLDEPT, store);
        SendMafiaMessage(COLOR_ALLDEPT, store);
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

stock CanselEscortToFrak(playerid,g)
{
	if(OrganInfo[g][gOrderStatus] == 0) return ErrorMessage(playerid, "{FF6347}В этот бизнес не оформлен заказ товаров");
	new frakid = GetPVarInt(playerid,"delivery_frak");
	if(g != frakid) return ErrorMessage(playerid, "{FF6347}Вы не оформляли доставку для этого бизнеса");
	if(GetPVarInt(playerid,"delivery_frak") >= 1 && GetPVarInt(playerid,"delivery_frak_status") == 6)
	{
		new payOrders;
		// Распределяем товары из заказа в биз
		for(new i = 0; i < MAX_ORDERESCORT; i++)
		{
			if(OrganInfo[g][gOrder][i] > 0)
			{
				putsklad(g, OrganInfo[g][gOrder][i],OrganInfo[g][gOrderQuan][i],0, OrganInfo[g][gOrderType][i],0);
				payOrders += getThingPriceGos( OrganInfo[g][gOrder][i],  OrganInfo[g][gOrderType][i]) * OrganInfo[g][gOrderQuan][i];
				OrganInfo[g][gOrder][i] = 0;
				OrganInfo[g][gOrderQuan][i] = 0;
			}
		}

		// Изменяем переменные игрока
		SetPVarInt(playerid,"delivery_biz",0);
		//paysalary(playerid, BizzInfo[b][bDeliveryPay], 0);
		//MoneyLog("salary", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", BizzInfo[b][bDeliveryPay], "Зарплата Дальнобойщик");

		// Изменяем переменные биза
		OrganInfo[g][glave] -= payOrders;
		OrganInfo[g][gDeliveryOrder] = -1;
		SaveOrgan(g);
		//BizLog("order", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], b, 0, "Доставил товары");

		OrganInfo[3][glave] +=payOrders;
		SaveOrgan(3);
		// Удаляем объект с транспорта
		PP_SetVehicleToRespawn(train);
		SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Поздравляем с успешной доставкой");

		// Ачивка
		//if(PlayerInfo[playerid][pAchieve][119] == 0) AchievePlayer(playerid, 119, 1);
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

stock IsPlayerNearbyHammerOnTrain(playerid) // Стоим вдоль бочины поезда
{
	new yesFind;
	for(new i = 0; i < MAX_POS_SIDE_TRAIN; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,2.0, train_side_X[0][i], train_side_Y[0][i], train_side_Z[0][i])
			|| IsPlayerInRangeOfPoint(playerid,2.0, train_side_X[1][i], train_side_Y[1][i], train_side_Z[1][i]))
		{
			yesFind = 1;
			break;
		}
	}
    return yesFind;
}

stock FindPointSideTrain() // Собираем бок поезда
{
	new Float:pos[4];
	GetVehiclePos(train, pos[0], pos[1], pos[2]);
	GetVehicleZAngle(train, pos[3]);

	// Сдвигаем середину чуть-чуть назад
	pos[0] += (4.0 * floatsin(-pos[3]+180, degrees));
    pos[1] += (4.0 * floatcos(-pos[3]+180, degrees));
	
	// Собираем стороны
	for(new i = 0; i < MAX_POS_SIDE_TRAIN; i++)
	{
		pos[0] -= (1.0 * floatsin(-pos[3]+180, degrees));
    	pos[1] -= (1.0 * floatcos(-pos[3]+180, degrees));
		WritePosTrain(i, 0, pos[0], pos[1], pos[2], pos[3]); // left
		WritePosTrain(i, 1, pos[0], pos[1], pos[2], pos[3]); // right
	}
	return 1;
}

stock WritePosTrain(i, side, Float:x, Float:y, Float:z, Float:a) // Записываем точки бока поезда
{
	new Float:offset_side;
	if(side == 0) offset_side = 1.55480;
	else offset_side = -1.55480;

	x -= (offset_side * floatsin(-a+90, degrees));
    y -= (offset_side * floatcos(-a+90, degrees));

	train_side_X[side][i] = x;
	train_side_Y[side][i] = y;
	train_side_Z[side][i] = z;
	return 1;
}



enum TRAINROADENUM { Float:TrainRoad_X, Float:TrainRoad_Y, Float:TrainRoad_Z }
new TrainRoad[][TRAINROADENUM] =
{
	{ 30.0358, 1292.4050, 19.8040  }, // 0
	{ 19.9859, 1292.9880, 19.6807  }, // 1
	{ 9.7570, 1293.3242, 19.6284  }, // 2
	{ -0.5734, 1293.5026, 19.5995  }, // 3
	{ -10.7141, 1293.5405, 19.5995  }, // 4
	{ -21.3356, 1293.3983, 19.5995  }, // 5
	{ -31.6203, 1293.1257, 19.6371  }, // 6
	{ -42.4538, 1292.6901, 19.7150  }, // 7
	{ -52.7603, 1292.1131, 19.8446  }, // 8
	{ -62.9099, 1291.4832, 19.9885  }, // 9
	{ -73.6343, 1290.6870, 20.1340  }, // 10
	{ -84.0688, 1289.8476, 20.2954  }, // 11
	{ -94.0427, 1288.9418, 20.4887  }, // 12
	{ -104.4350, 1287.9460, 20.7458  }, // 13
	{ -114.7155, 1286.9011, 21.0613  }, // 14
	{ -125.1063, 1285.7869, 21.4593  }, // 15
	{ -136.0226, 1284.5628, 21.9731  }, // 16
	{ -146.5245, 1283.3540, 22.5475  }, // 17
	{ -156.4729, 1282.1226, 23.1758  }, // 18
	{ -166.6988, 1280.8422, 23.8315  }, // 19
	{ -176.9223, 1279.4282, 24.5661  }, // 20
	{ -186.8012, 1278.0198, 25.2973  }, // 21
	{ -197.4746, 1276.3710, 26.1222  }, // 22
	{ -207.9988, 1274.6824, 26.9334  }, // 23
	{ -218.1134, 1272.9736, 27.6561  }, // 24
	{ -228.6699, 1271.1380, 28.3657  }, // 25
	{ -239.2051, 1269.1621, 28.9522  }, // 26
	{ -249.9237, 1267.0932, 29.4991  }, // 27
	{ -259.8665, 1265.0119, 29.8748  }, // 28
	{ -270.2260, 1262.7790, 30.2280  }, // 29
	{ -281.3854, 1260.2623, 30.5511  }, // 30
	{ -291.9462, 1257.6724, 30.8376  }, // 31
	{ -302.2570, 1255.0526, 31.0847  }, // 32
	{ -313.6917, 1252.0612, 31.3496  }, // 33
	{ -323.6336, 1249.4442, 31.5375  }, // 34
	{ -333.3682, 1246.8732, 31.7137  }, // 35
	{ -343.5556, 1244.1601, 31.8768  }, // 36
	{ -353.9491, 1241.4233, 32.0321  }, // 37
	{ -363.7373, 1238.9721, 32.1625  }, // 38
	{ -374.4312, 1236.4398, 32.2734  }, // 39
	{ -385.2486, 1234.0659, 32.3277  }, // 40
	{ -395.0669, 1231.9467, 32.3193  }, // 41
	{ -405.3958, 1229.7163, 32.2512  }, // 42
	{ -415.4542, 1227.5362, 32.1396  }, // 43
	{ -426.3052, 1225.1804, 31.9968  }, // 44
	{ -436.0898, 1223.0212, 31.8347  }, // 45
	{ -446.3162, 1220.7530, 31.6546  }, // 46
	{ -458.3386, 1218.0317, 31.3908  }, // 47
	{ -468.4483, 1215.7443, 31.1679  }, // 48
	{ -478.2528, 1213.6000, 30.9324  }, // 49
	{ -488.9895, 1211.2731, 30.6691  }, // 50
	{ -499.0057, 1209.1599, 30.4086  }, // 51
	{ -509.9056, 1206.8602, 30.1251  }, // 52
	{ -520.8782, 1204.5451, 29.8397  }, // 53
	{ -530.6763, 1202.4779, 29.5848  }, // 54
	{ -540.9938, 1200.3010, 29.3164  }, // 55
	{ -550.9393, 1198.2028, 29.0577  }, // 56
	{ -561.8034, 1195.8952, 28.8412  }, // 57
	{ -573.6398, 1193.3703, 28.6523  }, // 58
	{ -584.2952, 1191.0760, 28.5745  }, // 59
	{ -595.4093, 1188.6868, 28.5710  }, // 60
	{ -605.7307, 1186.4707, 28.6206  }, // 61
	{ -616.1329, 1184.2430, 28.7810  }, // 62
	{ -626.6041, 1182.0012, 28.9579  }, // 63
	{ -638.5173, 1179.4591, 29.2031  }, // 64
	{ -649.5318, 1177.1186, 29.4829  }, // 65
	{ -660.5839, 1174.3380, 29.8802  }, // 66
	{ -670.6365, 1171.4739, 30.2842  }, // 67
	{ -681.5355, 1167.5755, 30.7891  }, // 68
	{ -691.7176, 1163.1706, 31.2732  }, // 69
	{ -701.7569, 1158.3243, 31.7853  }, // 70
	{ -711.6904, 1153.1313, 32.2918  }, // 71
	{ -721.4759, 1147.5141, 32.7697  }, // 72
	{ -730.4473, 1142.1697, 33.1971  }, // 73
	{ -739.2852, 1136.6044, 33.5917  }, // 74
	{ -748.4652, 1130.5521, 34.0199  }, // 75
	{ -756.8485, 1124.8587, 34.4048  }, // 76
	{ -765.5561, 1118.7512, 34.7922  }, // 77
	{ -774.6818, 1112.2154, 35.0718  }, // 78
	{ -783.0627, 1106.1635, 35.2799  }, // 79
	{ -792.2373, 1099.5439, 35.4347  }, // 80
	{ -800.6247, 1093.4921, 35.5763  }, // 81
	{ -809.0559, 1087.4090, 35.7186  }, // 82
	{ -818.3406, 1080.7099, 35.8753  }, // 83
	{ -827.2463, 1074.2734, 35.9996  }, // 84
	{ -836.2417, 1067.7510, 36.0757  }, // 85
	{ -844.8044, 1061.5222, 36.0995  }, // 86
	{ -853.3895, 1055.2670, 36.0995  }, // 87
	{ -862.8542, 1048.3708, 36.0995  }, // 88
	{ -871.0599, 1042.3920, 36.0995  }, // 89
	{ -879.7980, 1036.0252, 36.0995  }, // 90
	{ -888.5141, 1029.6746, 36.0995  }, // 91
	{ -897.3288, 1023.2520, 36.0995  }, // 92
	{ -906.5789, 1016.5123, 36.0995  }, // 93
	{ -915.8709, 1009.7420, 36.0995  }, // 94
	{ -925.2227, 1002.9281, 36.0995  }, // 95
	{ -935.5111, 995.4320, 36.0995  }, // 96
	{ -944.4969, 988.8847, 36.0995  }, // 97
	{ -953.4851, 982.3356, 36.0995  }, // 98
	{ -961.6751, 976.3684, 36.0995  }, // 99
	{ -971.2328, 969.4045, 36.0995  }, // 100
	{ -979.4346, 963.4285, 36.0995  }, // 101
	{ -989.4860, 956.1219, 36.0995  }, // 102
	{ -998.7430, 949.4091, 36.0995  }, // 103
	{ -1007.0594, 943.3817, 36.0995  }, // 104
	{ -1017.7382, 935.6317, 36.0995  }, // 105
	{ -1026.0886, 929.5574, 36.0995  }, // 106
	{ -1035.8786, 922.4360, 36.0995  }, // 107
	{ -1045.2287, 915.6346, 36.0995  }, // 108
	{ -1054.6749, 908.7631, 36.0995  }, // 109
	{ -1063.1507, 902.5977, 36.0995  }, // 110
	{ -1072.6324, 895.7005, 36.0995  }, // 111
	{ -1083.5588, 887.7575, 36.0995  }, // 112
	{ -1092.1818, 881.4915, 36.0995  }, // 113
	{ -1100.3234, 875.5793, 36.0995  }, // 114
	{ -1108.9741, 869.2973, 36.0995  }, // 115
	{ -1117.1970, 863.3260, 36.0995  }, // 116
	{ -1125.9403, 856.9769, 36.0995  }, // 117
	{ -1135.6448, 849.9297, 36.0995  }, // 118
	{ -1144.9145, 843.1983, 36.0995  }, // 119
	{ -1153.7456, 836.7854, 36.0995  }, // 120
	{ -1162.0721, 830.7388, 36.0995  }, // 121
	{ -1172.3957, 823.2421, 36.0995  }, // 122
	{ -1181.2512, 816.8115, 36.0995  }, // 123
	{ -1189.7170, 810.6639, 36.0995  }, // 124
	{ -1198.5961, 804.2160, 36.0995  }, // 125
	{ -1207.0515, 798.0759, 36.0995  }, // 126
	{ -1215.4997, 791.9410, 36.0995  }, // 127
	{ -1224.0327, 785.7446, 36.0995  }, // 128
	{ -1232.4985, 779.5970, 36.0995  }, // 129
	{ -1242.6125, 772.2523, 36.0995  }, // 130
	{ -1251.2197, 766.0020, 36.0995  }, // 131
	{ -1260.3385, 759.3802, 36.0995  }, // 132
	{ -1269.4904, 752.7343, 36.0995  }, // 133
	{ -1278.1718, 746.4300, 36.0995  }, // 134
	{ -1286.3508, 740.4899, 36.0995  }, // 135
	{ -1295.5517, 733.8064, 36.0995  }, // 136
	{ -1305.6108, 726.4979, 36.0995  }, // 137
	{ -1314.3499, 720.1481, 36.0995  }, // 138
	{ -1324.4011, 712.8450, 36.0995  }, // 139
	{ -1333.5904, 706.1680, 36.0995  }, // 140
	{ -1341.9329, 700.1064, 36.0995  }, // 141
	{ -1350.7652, 693.6889, 36.0995  }, // 142
	{ -1359.2791, 687.5028, 36.0995  }, // 143
	{ -1368.6888, 680.6657, 36.0995  }, // 144
	{ -1377.1158, 674.5426, 36.0995  }, // 145
	{ -1386.0682, 668.0379, 36.0995  }, // 146
	{ -1395.0102, 661.5406, 36.0995  }, // 147
	{ -1404.4832, 654.6575, 36.0995  }, // 148
	{ -1412.9616, 648.4973, 36.0995  }, // 149
	{ -1422.4692, 641.5889, 36.0995  }, // 150
	{ -1432.0748, 634.6096, 36.0995  }, // 151
	{ -1441.1614, 628.0073, 36.0995  }, // 152
	{ -1451.3292, 620.6192, 36.0995  }, // 153
	{ -1460.9056, 613.6579, 36.0995  }, // 154
	{ -1470.5679, 606.6324, 36.0995  }, // 155
	{ -1480.0635, 599.7264, 36.0995  }, // 156
	{ -1489.7677, 592.6689, 36.0995  }, // 157
	{ -1497.9049, 586.7509, 36.0995  }, // 158
	{ -1507.1331, 580.0394, 36.0995  }, // 159
	{ -1515.3060, 574.0955, 36.0995  }, // 160
	{ -1524.5683, 567.3653, 36.0778  }, // 161
	{ -1533.8941, 560.5912, 36.0471  }, // 162
	{ -1543.2551, 553.7966, 35.9437  }, // 163
	{ -1551.4943, 547.8207, 35.6261  }, // 164
	{ -1560.3385, 541.4086, 35.1529  }, // 165
	{ -1569.7163, 534.6131, 34.3962  }, // 166
	{ -1578.0280, 528.5902, 33.5128  }, // 167
	{ -1588.5429, 520.9707, 32.1847  }, // 168
	{ -1597.9951, 514.1293, 30.7830  }, // 169
	{ -1606.3735, 508.0724, 29.4712  }, // 170
	{ -1614.7309, 502.0075, 28.0919  }, // 171
	{ -1623.1040, 495.9264, 26.6881  }, // 172
	{ -1632.6195, 488.9870, 25.1232  }, // 173
	{ -1642.1434, 482.0793, 23.5168  }, // 174
	{ -1651.6683, 475.1671, 21.8216  }, // 175
	{ -1661.8253, 467.7957, 19.9595  }, // 176
	{ -1670.8131, 461.2395, 18.2662  }, // 177
	{ -1679.2639, 455.0774, 16.7026  }, // 178
	{ -1688.3281, 448.4838, 15.0615  }, // 179
	{ -1697.9451, 441.5150, 13.3425  }, // 180
	{ -1708.6857, 433.7662, 11.4784  }, // 181
	{ -1718.9317, 426.3022, 9.8284  }, // 182
	{ -1728.6188, 419.2519, 8.3690  }, // 183
	{ -1737.1767, 413.0043, 7.1759  }, // 184
	{ -1745.7543, 406.7842, 6.0541  }, // 185
	{ -1755.4960, 399.7318, 4.9389  }, // 186
	{ -1763.5999, 393.8754, 4.0973  }, // 187
	{ -1771.7497, 388.0653, 3.4732  }, // 188
	{ -1779.8940, 382.2854, 2.9557  }, // 189
	{ -1788.1091, 376.4966, 2.5294  }, // 190
	{ -1798.0108, 369.5510, 2.2692  }, // 191
	{ -1807.9780, 362.6196, 2.3362  }, // 192
	{ -1816.8417, 356.5214, 2.7235  }, // 193
	{ -1825.2396, 350.8554, 3.6669  }, // 194
	{ -1834.1606, 344.8898, 4.9373  }, // 195
	{ -1843.1628, 338.9052, 6.4745  }, // 196
	{ -1851.5860, 333.2747, 7.9760  }, // 197
	{ -1859.9859, 327.6752, 9.4639  }, // 198
	{ -1869.1059, 321.6469, 11.1094  }, // 199
	{ -1877.5910, 316.0757, 12.5790  }, // 200
	{ -1887.1405, 309.5157, 14.2401  }, // 201
	{ -1895.1386, 303.2179, 15.7048  }, // 202
	{ -1904.1618, 294.9115, 17.4313  }, // 203
	{ -1910.9980, 287.5611, 18.8281  }, // 204
	{ -1918.8275, 277.1787, 20.5957  }, // 205
	{ -1924.0344, 268.3953, 21.9208  }, // 206
	{ -1928.3685, 258.1755, 23.2471  }, // 207
	{ -1931.5966, 247.6789, 24.3599  }, // 208
	{ -1934.1911, 237.6920, 25.2691  }, // 209
	{ -1936.1750, 227.5817, 25.9510  }, // 210
	{ -1938.0600, 216.6452, 26.6158  }, // 211
	{ -1939.8481, 203.4918, 27.0014  }, // 212
	{ -1940.9744, 193.0404, 27.1825  }, // 213
	{ -1942.1079, 179.6959, 27.2245  }, // 214
	{ -1942.7348, 169.3585, 27.2245  }, // 215
	{ -1943.2607, 158.9365, 27.2245  }, // 216
	{ -1943.7084, 148.4580, 27.2245  }, // 217
	{ -1944.0146, 138.0244, 27.2245  }, // 218
	{ -1944.2238, 127.5744, 27.2245  }, // 219
	{ -1944.3559, 116.3004, 27.2245  }, // 220
	{ -1944.3750, 105.0498, 27.2245  }, // 221
	{ -1944.3750, 93.8271, 27.2245  }, // 222
	{ -1944.3750, 80.2357, 27.2245  }, // 223
	{ -1944.3750, 69.6568, 27.2245  }, // 224
	{ -1944.3750, 58.3373, 27.2245  }, // 225
	{ -1944.3750, 47.7732, 27.2245  }, // 226
	{ -1944.3750, 34.1466, 27.2245  }, // 227
	{ -1944.3750, 20.4965, 27.2245  }, // 228
	{ -1944.3750, 6.7771, 27.2245  }, // 229
	{ -1944.3776, -3.8496, 27.2245  }, // 230
	{ -1944.4011, -14.4533, 27.2245  }, // 231
	{ -1944.4335, -25.0553, 27.2245  }, // 232
	{ -1944.4681, -36.4398, 27.2245  }, // 233
	{ -1944.4859, -47.8614, 27.2245  }, // 234
	{ -1944.4758, -58.5996, 27.2245  }, // 235
	{ -1944.4587, -71.6601, 27.2245  }, // 236
	{ -1944.4448, -82.4033, 27.2245  }, // 237
	{ -1944.4299, -93.9306, 27.2245  }, // 238
	{ -1944.4156, -104.7333, 27.2245  }, // 239
	{ -1944.3996, -117.1240, 27.2245  }, // 240
	{ -1944.3842, -130.9716, 27.2245  }, // 241
	{ -1944.4000, -144.9189, 27.2245  }, // 242
	{ -1944.5268, -155.7558, 27.2245  }, // 243
	{ -1944.8994, -166.5888, 27.2245  }, // 244
	{ -1945.4376, -177.4814, 27.2245  }, // 245
	{ -1946.3482, -189.1367, 27.2245  }, // 246
	{ -1947.2869, -200.0117, 27.2245  }, // 247
	{ -1948.3040, -210.9049, 27.2245  }, // 248
	{ -1949.4791, -222.4839, 27.2245  }, // 249
	{ -1950.7247, -233.3097, 27.2245  }, // 250
	{ -1952.2360, -244.9396, 27.2245  }, // 251
	{ -1953.7998, -255.7954, 27.2245  }, // 252
	{ -1955.5214, -266.6987, 27.2245  }, // 253
	{ -1957.3342, -278.3255, 27.2245  }, // 254
	{ -1958.9841, -289.2158, 27.2245  }, // 255
	{ -1960.6716, -300.8941, 27.2245  }, // 256
	{ -1962.0844, -311.8143, 27.2245  }, // 257
	{ -1963.4362, -323.4975, 27.2245  }, // 258
	{ -1964.4631, -334.4685, 27.2245  }, // 259
	{ -1965.4526, -348.6738, 27.2245  }, // 260
	{ -1966.1485, -359.7880, 27.2245  }, // 261
	{ -1966.9155, -371.7246, 27.2245  }, // 262
	{ -1967.7388, -382.8173, 27.2245  }, // 263
	{ -1968.7858, -394.7822, 27.2245  }, // 264
	{ -1969.8525, -405.8453, 27.2245  }, // 265
	{ -1971.3337, -420.1944, 27.2245  }, // 266
	{ -1972.5485, -431.2853, 27.2245  }, // 267
	{ -1973.8994, -443.2089, 27.2245  }, // 268
	{ -1975.1263, -454.3828, 27.2245  }, // 269
	{ -1976.5991, -468.7297, 27.2245  }, // 270
	{ -1977.5980, -479.8740, 27.2245  }, // 271
	{ -1978.4394, -491.0324, 27.2245  }, // 272
	{ -1979.1452, -503.0156, 27.2245  }, // 273
	{ -1979.7182, -517.4951, 27.2245  }, // 274
	{ -1979.9311, -528.7978, 27.2245  }, // 275
	{ -1979.9799, -540.0644, 27.2245  }, // 276
	{ -1980.0334, -551.3437, 27.2245  }, // 277
	{ -1980.0683, -562.6835, 27.3054  }, // 278
	{ -1980.0957, -574.8632, 27.3495  }, // 279
	{ -1980.0009, -587.0566, 27.4532  }, // 280
	{ -1979.9384, -599.2148, 27.3924  }, // 281
	{ -1979.8142, -610.5751, 27.3026  }, // 282
	{ -1979.6682, -625.1845, 27.2296  }, // 283
	{ -1979.5541, -636.5806, 27.2245  }, // 284
	{ -1979.4316, -648.8740, 27.2245  }, // 285
	{ -1979.3181, -660.2706, 27.2245  }, // 286
	{ -1979.1702, -675.1356, 27.2245  }, // 287
	{ -1979.0559, -686.6395, 27.2245  }, // 288
	{ -1978.9417, -698.1026, 27.2245  }, // 289
	{ -1978.8247, -710.4078, 27.2245  }, // 290
	{ -1978.7340, -722.5816, 27.2245  }, // 291
	{ -1978.6660, -734.0550, 27.2245  }, // 292
	{ -1978.5568, -748.7839, 27.2245  }, // 293
	{ -1978.4459, -762.8168, 27.2245  }, // 294
	{ -1978.3891, -774.3455, 27.2245  }, // 295
	{ -1978.3750, -786.8246, 27.2245  }, // 296
	{ -1978.3750, -798.3588, 27.2245  }, // 297
	{ -1978.3750, -810.7374, 27.2245  }, // 298
	{ -1978.3750, -822.3045, 27.2245  }, // 299
	{ -1978.3750, -833.9138, 27.2245  }, // 300
	{ -1978.4013, -846.3811, 27.2245  }, // 301
	{ -1978.4395, -858.0604, 27.2245  }, // 302
	{ -1978.4957, -869.7025, 27.2245  }, // 303
	{ -1978.5517, -881.3308, 27.2245  }, // 304
	{ -1978.6262, -893.7485, 27.2245  }, // 305
	{ -1978.6987, -903.8121, 27.2245  }, // 306
	{ -1978.7891, -914.6264, 27.2218  }, // 307
	{ -1978.8167, -926.2904, 27.1934  }, // 308
	{ -1978.8088, -936.3215, 27.1583  }, // 309
	{ -1978.6594, -948.0230, 27.0090  }, // 310
	{ -1978.4589, -959.6702, 26.8084  }, // 311
	{ -1978.0211, -971.3370, 26.4792  }, // 312
	{ -1977.4511, -983.7740, 26.1069  }, // 313
	{ -1976.7131, -993.7572, 25.7102  }, // 314
	{ -1975.7922, -1005.3476, 25.2174  }, // 315
	{ -1974.6718, -1015.3159, 24.6803  }, // 316
	{ -1972.9245, -1029.3896, 23.8917  }, // 317
	{ -1971.3063, -1039.2685, 23.2929  }, // 318
	{ -1969.3364, -1050.7424, 22.5898  }, // 319
	{ -1966.4814, -1064.5739, 21.6817  }, // 320
	{ -1964.0075, -1075.0327, 20.9610  }, // 321
	{ -1961.5269, -1084.6981, 20.2794  }, // 322
	{ -1958.2058, -1095.8822, 19.5009  }, // 323
	{ -1954.7031, -1106.9608, 18.7395  }, // 324
	{ -1950.7250, -1117.9355, 18.0789  }, // 325
	{ -1947.2246, -1127.3874, 17.5310  }, // 326
	{ -1941.5205, -1141.2038, 16.8395  }, // 327
	{ -1935.3591, -1154.7495, 16.2864  }, // 328
	{ -1930.3366, -1165.2518, 15.9332  }, // 329
	{ -1924.9335, -1175.6545, 15.7268  }, // 330
	{ -1919.4450, -1185.9443, 15.5678  }, // 331
	{ -1914.5458, -1194.7025, 15.5099  }, // 332
	{ -1908.8242, -1204.7810, 15.4745  }, // 333
	{ -1902.4803, -1215.5738, 15.4745  }, // 334
	{ -1896.5070, -1225.6379, 15.4745  }, // 335
	{ -1891.2929, -1234.2104, 15.4745  }, // 336
	{ -1886.0412, -1242.8203, 15.4745  }, // 337
	{ -1880.7275, -1251.3483, 15.4745  }, // 338
	{ -1874.4128, -1261.2194, 15.4745  }, // 339
	{ -1867.6182, -1271.6508, 15.4745  }, // 340
	{ -1861.1369, -1281.3021, 15.4745  }, // 341
	{ -1852.6970, -1293.6757, 15.4745  }, // 342
	{ -1845.9779, -1303.2326, 15.4745  }, // 343
	{ -1839.1857, -1312.7271, 15.4745  }, // 344
	{ -1833.2368, -1320.8381, 15.4745  }, // 345
	{ -1827.2027, -1328.8322, 15.4745  }, // 346
	{ -1819.5979, -1338.7497, 15.4745  }, // 347
	{ -1812.3146, -1347.8895, 15.4745  }, // 348
	{ -1804.3798, -1357.4603, 15.4745  }, // 349
	{ -1796.9128, -1366.2871, 15.4745  }, // 350
	{ -1789.2651, -1374.9649, 15.4745  }, // 351
	{ -1782.5203, -1382.3824, 15.4745  }, // 352
	{ -1774.4494, -1390.9848, 15.4745  }, // 353
	{ -1766.2163, -1399.2679, 15.4745  }, // 354
	{ -1759.0750, -1406.2988, 15.4745  }, // 355
	{ -1751.7388, -1413.1149, 15.4745  }, // 356
	{ -1741.0673, -1422.4166, 15.4745  }, // 357
	{ -1729.6142, -1431.9204, 15.4745  }, // 358
	{ -1720.2768, -1438.8447, 15.4745  }, // 359
	{ -1710.1203, -1446.0447, 15.4745  }, // 360
	{ -1700.2941, -1452.1184, 15.4745  }, // 361
	{ -1690.2001, -1458.0567, 15.4745  }, // 362
	{ -1680.4692, -1462.9064, 15.4853  }, // 363
	{ -1669.8481, -1467.7976, 15.5141  }, // 364
	{ -1659.0563, -1472.1523, 15.5830  }, // 365
	{ -1645.7607, -1476.9682, 15.7555  }, // 366
	{ -1634.6303, -1480.5847, 15.9800  }, // 367
	{ -1624.3063, -1483.6035, 16.2365  }, // 368
	{ -1612.2840, -1486.8778, 16.5668  }, // 369
	{ -1600.9185, -1489.5393, 16.9229  }, // 370
	{ -1589.5367, -1492.0808, 17.2900  }, // 371
	{ -1579.6428, -1493.9859, 17.6353  }, // 372
	{ -1568.1459, -1496.0970, 18.0456  }, // 373
	{ -1556.7030, -1497.8970, 18.4816  }, // 374
	{ -1544.3487, -1499.6372, 18.9746  }, // 375
	{ -1532.0002, -1501.1950, 19.4867  }, // 376
	{ -1520.3532, -1502.4438, 19.9754  }, // 377
	{ -1507.8972, -1503.6899, 20.4974  }, // 378
	{ -1496.3078, -1504.6400, 20.9624  }, // 379
	{ -1481.3675, -1505.7446, 21.5428  }, // 380
	{ -1469.6925, -1506.4482, 22.0053  }, // 381
	{ -1458.0093, -1507.1186, 22.4806  }, // 382
	{ -1447.9678, -1507.5869, 22.8876  }, // 383
	{ -1436.3132, -1508.0588, 23.3323  }, // 384
	{ -1421.2963, -1508.4908, 23.8223  }, // 385
	{ -1409.5485, -1508.7758, 24.1646  }, // 386
	{ -1398.7470, -1508.9888, 24.4309  }, // 387
	{ -1386.3005, -1509.2067, 24.7113  }, // 388
	{ -1374.7309, -1509.3918, 24.9391  }, // 389
	{ -1362.2558, -1509.5863, 25.0991  }, // 390
	{ -1349.7933, -1509.7941, 25.1848  }, // 391
	{ -1339.7851, -1509.9858, 25.2112  }, // 392
	{ -1329.7038, -1510.1955, 25.2245  }, // 393
	{ -1319.6899, -1510.4104, 25.3317  }, // 394
	{ -1308.0305, -1510.6519, 25.5509  }, // 395
	{ -1295.5957, -1511.0970, 26.1445  }, // 396
	{ -1284.0332, -1511.6250, 26.7927  }, // 397
	{ -1271.5283, -1512.5329, 27.8041  }, // 398
	{ -1259.8659, -1513.4381, 28.8619  }, // 399
	{ -1248.1638, -1514.3259, 30.1993  }, // 400
	{ -1237.3118, -1515.0920, 31.5693  }, // 401
	{ -1225.6787, -1515.8607, 33.2474  }, // 402
	{ -1215.7363, -1516.4782, 34.8137  }, // 403
	{ -1205.7972, -1517.0284, 36.5027  }, // 404
	{ -1194.1425, -1517.5046, 38.6446  }, // 405
	{ -1182.4262, -1517.8356, 40.9376  }, // 406
	{ -1170.8010, -1517.9418, 43.4076  }, // 407
	{ -1158.3063, -1517.9140, 46.1316  }, // 408
	{ -1148.3376, -1517.5592, 48.4222  }, // 409
	{ -1134.2512, -1516.5820, 51.7669  }, // 410
	{ -1122.6225, -1515.4371, 54.6001  }, // 411
	{ -1110.2861, -1513.5235, 57.7310  }, // 412
	{ -1100.3110, -1511.8543, 60.2622  }, // 413
	{ -1088.8758, -1509.7275, 63.1242  }, // 414
	{ -1074.9924, -1507.4151, 66.4754  }, // 415
	{ -1065.1273, -1505.9045, 68.8183  }, // 416
	{ -1051.1584, -1504.3867, 71.9972  }, // 417
	{ -1041.1737, -1503.4223, 74.2136  }, // 418
	{ -1031.1846, -1502.6823, 76.3409  }, // 419
	{ -1018.6916, -1501.8374, 78.9450  }, // 420
	{ -1007.0618, -1501.1472, 81.2690  }, // 421
	{ -994.5953, -1500.4010, 83.6226  }, // 422
	{ -982.9486, -1499.6870, 85.7642  }, // 423
	{ -971.2663, -1498.7983, 87.7987  }, // 424
	{ -958.8225, -1497.5976, 89.8745  }, // 425
	{ -947.2456, -1496.2324, 91.7161  }, // 426
	{ -935.7813, -1494.1801, 93.3221  }, // 427
	{ -923.6525, -1491.4155, 94.8906  }, // 428
	{ -914.0086, -1488.6813, 96.0144  }, // 429
	{ -901.0167, -1483.2166, 97.1636  }, // 430
	{ -888.4050, -1475.4062, 97.8271  }, // 431
	{ -879.7676, -1467.8540, 97.9170  }, // 432
	{ -870.0425, -1456.4625, 97.6424  }, // 433
	{ -862.1477, -1443.8332, 96.9350  }, // 434
	{ -857.1448, -1433.3395, 96.1528  }, // 435
	{ -852.8441, -1422.5317, 95.2392  }, // 436
	{ -849.5981, -1413.0766, 94.3891  }, // 437
	{ -846.4990, -1401.8437, 93.2441  }, // 438
	{ -843.7266, -1390.5476, 92.0420  }, // 439
	{ -841.0642, -1378.3262, 90.6839  }, // 440
	{ -839.1042, -1366.8317, 89.3938  }, // 441
	{ -837.3881, -1356.1484, 88.1864  }, // 442
	{ -835.6820, -1344.5454, 86.8596  }, // 443
	{ -834.0578, -1332.9719, 85.4865  }, // 444
	{ -832.1597, -1318.8859, 83.7772  }, // 445
	{ -830.6409, -1307.3837, 82.3655  }, // 446
	{ -828.6572, -1292.5742, 80.5491  }, // 447
	{ -827.3326, -1282.7287, 79.3402  }, // 448
	{ -825.8810, -1272.8908, 78.1694  }, // 449
	{ -824.3658, -1262.9638, 76.9987  }, // 450
	{ -822.3358, -1251.5507, 75.6448  }, // 451
	{ -820.1350, -1240.1787, 74.2885  }, // 452
	{ -817.2996, -1227.9368, 72.8143  }, // 453
	{ -814.0970, -1216.8481, 71.4613  }, // 454
	{ -810.3439, -1205.8726, 70.1835  }, // 455
	{ -805.4422, -1194.4177, 68.8020  }, // 456
	{ -798.1279, -1181.5153, 67.3786  }, // 457
	{ -789.0574, -1169.6833, 66.1324  }, // 458
	{ -780.8922, -1161.3378, 65.2912  }, // 459
	{ -772.1291, -1153.8740, 64.6726  }, // 460
	{ -764.0853, -1147.8542, 64.1690  }, // 461
	{ -754.5123, -1141.3513, 63.6009  }, // 462
	{ -744.4340, -1135.3544, 62.8555  }, // 463
	{ -733.2697, -1129.8850, 61.6921  }, // 464
	{ -722.3899, -1125.7917, 60.1871  }, // 465
	{ -712.7576, -1123.3010, 58.6068  }, // 466
	{ -698.8442, -1121.2502, 56.1374  }, // 467
	{ -687.1679, -1120.9733, 54.0068  }, // 468
	{ -676.4310, -1121.7778, 52.1040  }, // 469
	{ -665.0036, -1123.8885, 50.1795  }, // 470
	{ -653.8315, -1127.0895, 48.4749  }, // 471
	{ -640.7360, -1132.1693, 46.7374  }, // 472
	{ -627.4306, -1138.8161, 45.3436  }, // 473
	{ -618.7873, -1143.8017, 44.6173  }, // 474
	{ -609.1881, -1150.3511, 44.1157  }, // 475
	{ -597.8026, -1158.7944, 43.7327  }, // 476
	{ -588.7015, -1166.1397, 43.6214  }, // 477
	{ -578.9583, -1174.1567, 43.5995  }, // 478
	{ -569.9096, -1181.6501, 43.5995  }, // 479
	{ -560.8013, -1189.0512, 43.5995  }, // 480
	{ -551.7461, -1196.4364, 43.5995  }, // 481
	{ -541.9194, -1204.1853, 43.5995  }, // 482
	{ -530.1320, -1213.4130, 43.5995  }, // 483
	{ -518.3002, -1222.4748, 43.5995  }, // 484
	{ -506.4909, -1231.5371, 43.5995  }, // 485
	{ -497.1754, -1238.4753, 43.5995  }, // 486
	{ -486.7514, -1245.3308, 43.5995  }, // 487
	{ -476.3330, -1250.5334, 43.5995  }, // 488
	{ -462.0144, -1255.0002, 43.6215  }, // 489
	{ -450.5796, -1256.6350, 43.6620  }, // 490
	{ -438.1529, -1256.9353, 43.7027  }, // 491
	{ -426.5873, -1256.0251, 43.6643  }, // 492
	{ -414.4032, -1253.8658, 43.6284  }, // 493
	{ -403.1520, -1250.8693, 43.5064  }, // 494
	{ -392.2766, -1246.9808, 43.4063  }, // 495
	{ -380.9294, -1241.7397, 43.1609  }, // 496
	{ -368.2261, -1233.9964, 42.8069  }, // 497
	{ -359.2356, -1226.7318, 42.2916  }, // 498
	{ -352.1661, -1219.6322, 41.7463  }, // 499
	{ -343.0225, -1208.8669, 40.6436  }, // 500
	{ -335.8176, -1199.7072, 39.6035  }, // 501
	{ -328.2051, -1189.8955, 38.2930  }, // 502
	{ -322.0736, -1181.9035, 37.1993  }, // 503
	{ -314.4942, -1171.9287, 35.7249  }, // 504
	{ -308.4892, -1163.9085, 34.5328  }, // 505
	{ -301.1081, -1153.8258, 32.9760  }, // 506
	{ -295.1362, -1145.6861, 31.6692  }, // 507
	{ -289.2420, -1137.5402, 30.3725  }, // 508
	{ -281.8586, -1127.3227, 28.7090  }, // 509
	{ -276.1076, -1119.2009, 27.4010  }, // 510
	{ -267.9655, -1107.5744, 25.4794  }, // 511
	{ -261.3821, -1098.0577, 23.9275  }, // 512
	{ -254.0039, -1087.9406, 22.2609  }, // 513
	{ -246.6027, -1079.1661, 20.7597  }, // 514
	{ -239.5359, -1071.9681, 19.5260  }, // 515
	{ -228.7221, -1063.0627, 17.9214  }, // 516
	{ -219.1034, -1056.3239, 16.7493  }, // 517
	{ -208.4364, -1049.9650, 15.6394  }, // 518
	{ -198.0453, -1044.5784, 14.7329  }, // 519
	{ -188.9633, -1040.2756, 14.0810  }, // 520
	{ -179.7482, -1036.3525, 13.5401  }, // 521
	{ -168.8710, -1032.3833, 13.1328  }, // 522
	{ -156.1450, -1028.3229, 12.8787  }, // 523
	{ -146.4537, -1025.6138, 12.8197  }, // 524
	{ -134.2874, -1022.9036, 13.1353  }, // 525
	{ -122.7166, -1020.8703, 13.7238  }, // 526
	{ -111.1369, -1019.3475, 14.6114  }, // 527
	{ -96.9556, -1018.3032, 16.1243  }, // 528
	{ -86.9740, -1018.0993, 17.4406  }, // 529
	{ -75.3859, -1018.0000, 18.8272  }, // 530
	{ -61.2502, -1018.0000, 20.1902  }, // 531
	{ -51.2252, -1018.0121, 20.8968  }, // 532
	{ -37.1001, -1018.0385, 21.5955  }, // 533
	{ -25.4676, -1018.0267, 21.9757  }, // 534
	{ -10.4893, -1017.9735, 22.2778  }, // 535
	{ -0.4740, -1017.9407, 22.4055  }, // 536
	{ 13.6883, -1018.0000, 22.4745  }, // 537
	{ 23.7449, -1018.0000, 22.5118  }, // 538
	{ 35.4164, -1018.0000, 22.6474  }, // 539
	{ 49.6403, -1018.0576, 22.8886  }, // 540
	{ 64.6455, -1018.1881, 23.1626  }, // 541
	{ 74.7100, -1018.3132, 23.2877  }, // 542
	{ 86.4129, -1018.4777, 23.4337  }, // 543
	{ 100.5886, -1018.7114, 23.6104  }, // 544
	{ 115.4595, -1019.4736, 23.6880  }, // 545
	{ 127.0843, -1020.3372, 23.6870  }, // 546
	{ 139.5612, -1021.3747, 23.6604  }, // 547
	{ 149.5394, -1022.2044, 23.6391  }, // 548
	{ 161.2001, -1023.2554, 23.5994  }, // 549
	{ 175.2247, -1024.9243, 23.4777  }, // 550
	{ 185.9109, -1026.5131, 23.3271  }, // 551
	{ 195.7946, -1028.0488, 23.1757  }, // 552
	{ 207.2644, -1029.8308, 23.0000  }, // 553
	{ 218.7810, -1031.7117, 22.8115  }, // 554
	{ 231.0358, -1034.0498, 22.5667  }, // 555
	{ 243.2590, -1036.7032, 22.2803  }, // 556
	{ 257.9167, -1040.0225, 21.9188  }, // 557
	{ 267.6831, -1042.2342, 21.6779  }, // 558
	{ 281.4193, -1045.6718, 21.2826  }, // 559
	{ 292.7127, -1048.7233, 20.9187  }, // 560
	{ 303.9346, -1052.0512, 20.5059  }, // 561
	{ 315.9155, -1055.6042, 20.0652  }, // 562
	{ 327.0745, -1058.9318, 19.6533  }, // 563
	{ 338.9650, -1062.8723, 19.1833  }, // 564
	{ 349.8854, -1066.7011, 18.7349  }, // 565
	{ 360.0125, -1070.4184, 18.3060  }, // 566
	{ 372.4683, -1074.9904, 17.7785  }, // 567
	{ 381.8528, -1078.5026, 17.3730  }, // 568
	{ 393.4205, -1083.1434, 16.8359  }, // 569
	{ 404.1140, -1087.6849, 16.3094  }, // 570
	{ 414.8570, -1092.3704, 15.7658  }, // 571
	{ 427.8434, -1098.0344, 15.1086  }, // 572
	{ 438.4212, -1102.8520, 14.5706  }, // 573
	{ 451.9465, -1109.2857, 13.8789  }, // 574
	{ 465.3553, -1115.9902, 13.1887  }, // 575
	{ 478.0035, -1122.3142, 12.5377  }, // 576
	{ 486.9259, -1126.8977, 12.0756  }, // 577
	{ 497.2276, -1132.3818, 11.5374  }, // 578
	{ 507.3642, -1138.0444, 11.0016  }, // 579
	{ 518.1630, -1144.1528, 10.4289  }, // 580
	{ 528.3255, -1149.9013, 9.8900  }, // 581
	{ 539.0949, -1156.1978, 9.3160  }, // 582
	{ 549.1190, -1162.2135, 8.7794  }, // 583
	{ 561.8287, -1170.2509, 8.0933  }, // 584
	{ 571.6972, -1176.4916, 7.5606  }, // 585
	{ 581.5656, -1182.7324, 7.0278  }, // 586
	{ 592.0852, -1189.6853, 6.4951  }, // 587
	{ 600.4210, -1195.2976, 6.0849  }, // 588
	{ 612.0590, -1203.3405, 5.5365  }, // 589
	{ 621.6384, -1209.9609, 5.0851  }, // 590
	{ 630.5473, -1216.1413, 4.6683  }, // 591
	{ 640.0131, -1222.9394, 4.2551  }, // 592
	{ 650.0816, -1230.3222, 3.8349  }, // 593
	{ 660.0881, -1237.7869, 3.4335  }, // 594
	{ 670.1340, -1245.2812, 3.0306  }, // 595
	{ 682.0298, -1254.3035, 2.5735  }, // 596
	{ 693.8266, -1263.5024, 2.1541  }, // 597
	{ 705.5108, -1272.8687, 1.7730  }, // 598
	{ 714.6217, -1280.1723, 1.4760  }, // 599
	{ 723.7366, -1287.4990, 1.1847  }, // 600
	{ 733.4166, -1295.4702, 0.9330  }, // 601
	{ 742.3499, -1302.9448, 0.7363  }, // 602
	{ 751.2103, -1310.4382, 0.5655  }, // 603
	{ 758.9682, -1316.9992, 0.4159  }, // 604
	{ 766.6425, -1323.4897, 0.2679  }, // 605
	{ 775.3226, -1331.1613, 0.1657  }, // 606
	{ 785.7987, -1340.5678, 0.0995  }, // 607
	{ 794.4478, -1348.3676, 0.0909  }, // 608
	{ 801.9300, -1355.0476, 0.0611  }, // 609
	{ 812.5079, -1364.4011, 0.0113  }, // 610
	{ 821.1777, -1372.2687, -0.0234  }, // 611
	{ 830.4597, -1380.7977, -0.0207  }, // 612
	{ 841.3989, -1391.0072, 0.0225  }, // 613
	{ 849.9060, -1399.0169, 0.0561  }, // 614
	{ 858.3569, -1407.0462, 0.0730  }, // 615
	{ 866.7144, -1415.1688, 0.0394  }, // 616
	{ 875.0720, -1423.2913, 0.0058  }, // 617
	{ 882.2438, -1430.3450, -0.0230  }, // 618
	{ 890.5912, -1438.5913, -0.0568  }, // 619
	{ 899.4510, -1447.4511, -0.0928  }, // 620
	{ 907.6995, -1455.7106, -0.1288  }, // 621
	{ 915.8765, -1464.0382, -0.1958  }, // 622
	{ 924.5136, -1472.9202, -0.2860  }, // 623
	{ 931.4778, -1480.1445, -0.3726  }, // 624
	{ 941.2275, -1490.3079, -0.4863  }, // 625
	{ 949.2495, -1498.7333, -0.5701  }, // 626
	{ 957.8521, -1507.8697, -0.6444  }, // 627
	{ 964.7430, -1515.1967, -0.7026  }, // 628
	{ 972.7016, -1523.7211, -0.7940  }, // 629
	{ 982.3476, -1534.1145, -0.9288  }, // 630
	{ 990.2014, -1542.6396, -1.0630  }, // 631
	{ 997.5126, -1550.5905, -1.1858  }, // 632
	{ 1005.3464, -1559.1998, -1.3036  }, // 633
	{ 1012.0607, -1566.6228, -1.3979  }, // 634
	{ 1020.4451, -1575.9509, -1.5068  }, // 635
	{ 1027.1496, -1583.4232, -1.5941  }, // 636
	{ 1033.8446, -1590.9205, -1.6816  }, // 637
	{ 1041.6472, -1599.6878, -1.7839  }, // 638
	{ 1049.3592, -1608.3808, -1.8854  }, // 639
	{ 1057.0556, -1617.0877, -1.9870  }, // 640
	{ 1063.6740, -1624.6142, -2.0749  }, // 641
	{ 1071.9514, -1634.0870, -2.1855  }, // 642
	{ 1080.1232, -1643.4628, -2.2949  }, // 643
	{ 1089.9606, -1654.7521, -2.4089  }, // 644
	{ 1096.5725, -1662.3410, -2.4773  }, // 645
	{ 1104.6621, -1671.6279, -2.5498  }, // 646
	{ 1111.2276, -1679.1760, -2.6056  }, // 647
	{ 1119.4265, -1688.6517, -2.6612  }, // 648
	{ 1125.9617, -1696.2373, -2.6963  }, // 649
	{ 1132.4914, -1703.8355, -2.7259  }, // 650
	{ 1139.5374, -1712.0311, -2.7531  }, // 651
	{ 1148.7514, -1722.7386, -2.7740  }, // 652
	{ 1155.3122, -1730.3537, -2.7754  }, // 653
	{ 1163.4451, -1739.7924, -2.7754  }, // 654
	{ 1169.9833, -1747.4090, -2.7630  }, // 655
	{ 1176.5162, -1755.0257, -2.7480  }, // 656
	{ 1183.5485, -1763.2624, -2.7156  }, // 657
	{ 1191.1204, -1772.1313, -2.6805  }, // 658
	{ 1198.7658, -1781.0225, -2.6284  }, // 659
	{ 1205.7150, -1789.0817, -2.5752  }, // 660
	{ 1215.5384, -1800.4128, -2.4838  }, // 661
	{ 1223.1655, -1809.1887, -2.3801  }, // 662
	{ 1231.3824, -1818.6247, -2.2403  }, // 663
	{ 1239.0422, -1827.3889, -2.0622  }, // 664
	{ 1247.2629, -1836.8010, -1.8624  }, // 665
	{ 1254.9047, -1845.5690, -1.6502  }, // 666
	{ 1261.5703, -1853.1032, -1.4719  }, // 667
	{ 1271.0556, -1863.7009, -1.2259  }, // 668
	{ 1278.9914, -1872.3776, -1.0514  }, // 669
	{ 1289.1811, -1883.2790, -0.5938  }, // 670
	{ 1297.8674, -1892.2009, -0.0417  }, // 671
	{ 1306.1860, -1900.2954, 0.6442  }, // 672
	{ 1314.1689, -1907.6573, 1.3660  }, // 673
	{ 1323.1411, -1915.1420, 2.3937  }, // 674
	{ 1336.4150, -1924.4409, 4.2375  }, // 675
	{ 1346.9484, -1930.2480, 5.9863  }, // 676
	{ 1357.5871, -1934.9414, 7.7127  }, // 677
	{ 1368.6984, -1939.2497, 9.3254  }, // 678
	{ 1380.4899, -1943.1715, 10.8000  }, // 679
	{ 1390.1606, -1945.9018, 11.8135  }, // 680
	{ 1402.3085, -1948.6815, 12.9441  }, // 681
	{ 1416.4533, -1951.0744, 13.9075  }, // 682
	{ 1426.7226, -1952.2860, 14.3710  }, // 683
	{ 1439.1363, -1953.2382, 14.8119  }, // 684
	{ 1450.7357, -1953.7261, 14.9927  }, // 685
	{ 1462.2614, -1953.9224, 15.0995  }, // 686
	{ 1474.2537, -1953.8836, 15.0995  }, // 687
	{ 1486.7923, -1953.8215, 15.0995  }, // 688
	{ 1496.8089, -1953.7478, 15.0995  }, // 689
	{ 1507.5981, -1953.7443, 15.0995  }, // 690
	{ 1520.0871, -1953.7368, 15.0995  }, // 691
	{ 1531.7868, -1953.7294, 15.0995  }, // 692
	{ 1544.2197, -1953.7216, 15.0995  }, // 693
	{ 1555.9028, -1953.7141, 15.0995  }, // 694
	{ 1565.9360, -1953.7077, 15.0995  }, // 695
	{ 1576.0285, -1953.7014, 15.0995  }, // 696
	{ 1587.7116, -1953.6940, 15.0995  }, // 697
	{ 1599.3449, -1953.6867, 15.0995  }, // 698
	{ 1611.8447, -1953.6787, 15.0995  }, // 699
	{ 1623.4277, -1953.6713, 15.0995  }, // 700
	{ 1635.2202, -1953.6639, 15.0995  }, // 701
	{ 1649.3037, -1953.6550, 15.0995  }, // 702
	{ 1659.3366, -1953.6486, 15.0995  }, // 703
	{ 1671.8200, -1953.6408, 15.0995  }, // 704
	{ 1684.3032, -1953.6329, 15.0995  }, // 705
	{ 1696.7573, -1953.6481, 15.0995  }, // 706
	{ 1709.2770, -1953.6801, 15.0995  }, // 707
	{ 1719.2984, -1953.7187, 15.0995  }, // 708
	{ 1729.3210, -1953.7464, 15.0995  }, // 709
	{ 1741.8142, -1953.7680, 15.0995  }, // 710
	{ 1753.3958, -1953.7803, 15.0995  }, // 711
	{ 1765.1270, -1953.7929, 15.0995  }, // 712
	{ 1776.8084, -1953.8055, 15.0995  }, // 713
	{ 1788.4400, -1953.8179, 15.0995  }, // 714
	{ 1798.4716, -1953.8287, 15.0995  }, // 715
	{ 1810.1198, -1953.8411, 15.0995  }, // 716
	{ 1821.7509, -1953.8537, 15.0995  }, // 717
	{ 1831.7825, -1953.8643, 15.0995  }, // 718
	{ 1844.2723, -1953.8510, 15.1402  }, // 719
	{ 1856.7171, -1953.8232, 15.2032  }, // 720
	{ 1866.7636, -1953.7885, 15.2723  }, // 721
	{ 1878.4527, -1953.7650, 15.3194  }, // 722
	{ 1890.1035, -1953.7500, 15.3495  }, // 723
	{ 1900.1296, -1953.7500, 15.3495  }, // 724
	{ 1910.1555, -1953.7500, 15.3495  }, // 725
	{ 1922.6835, -1953.7500, 15.3495  }, // 726
	{ 1932.7141, -1953.7500, 15.3411  }, // 727
	{ 1942.7160, -1953.7500, 15.3043  }, // 728
	{ 1955.2019, -1953.7500, 15.2783  }, // 729
	{ 1966.8376, -1953.7500, 15.2632  }, // 730
	{ 1978.5729, -1953.7500, 15.3076  }, // 731
	{ 1991.0090, -1953.7500, 15.3347  }, // 732
	{ 2003.5446, -1953.7500, 15.3495  }, // 733
	{ 2015.0300, -1953.7500, 15.3495  }, // 734
	{ 2026.6159, -1953.7500, 15.3495  }, // 735
	{ 2039.0520, -1953.7500, 15.3495  }, // 736
	{ 2049.9040, -1953.7500, 15.3495  }, // 737
	{ 2062.3898, -1953.7500, 15.3495  }, // 738
	{ 2074.0754, -1953.7500, 15.3495  }, // 739
	{ 2085.6604, -1953.7500, 15.3495  }, // 740
	{ 2099.8962, -1953.7500, 15.3495  }, // 741
	{ 2114.8322, -1953.7500, 15.3495  }, // 742
	{ 2124.8637, -1953.7500, 15.3495  }, // 743
	{ 2136.4504, -1953.7500, 15.3495  }, // 744
	{ 2148.0847, -1953.3935, 15.3495  }, // 745
	{ 2161.8452, -1951.1306, 15.3495  }, // 746
	{ 2175.1994, -1944.9836, 15.3495  }, // 747
	{ 2186.2409, -1935.2287, 15.3495  }, // 748
	{ 2192.6120, -1925.7421, 15.3495  }, // 749
	{ 2196.7631, -1914.0937, 15.3495  }, // 750
	{ 2198.3422, -1902.6467, 15.3495  }, // 751
	{ 2198.6250, -1887.6599, 15.3495  }, // 752
	{ 2198.6250, -1875.9743, 15.3495  }, // 753
	{ 2198.6250, -1863.5927, 15.3352  }, // 754
	{ 2198.6250, -1852.0114, 15.3119  }, // 755
	{ 2198.6250, -1840.3093, 15.2688  }, // 756
	{ 2198.6250, -1827.8234, 15.2229  }, // 757
	{ 2198.6250, -1816.1379, 15.1800  }, // 758
	{ 2198.6250, -1803.6520, 15.1341  }, // 759
	{ 2198.6250, -1792.0163, 15.0913  }, // 760
	{ 2198.6250, -1781.1311, 15.0513  }, // 761
	{ 2198.6250, -1768.6452, 15.0068  }, // 762
	{ 2198.6250, -1756.1594, 14.9839  }, // 763
	{ 2198.5625, -1745.3244, 14.9745  }, // 764
	{ 2198.5666, -1733.6721, 14.9745  }, // 765
	{ 2198.6870, -1723.6383, 15.0161  }, // 766
	{ 2199.0615, -1711.0180, 15.1134  }, // 767
	{ 2199.9289, -1701.0321, 15.3298  }, // 768
	{ 2201.3935, -1688.6796, 15.6283  }, // 769
	{ 2203.5168, -1676.4743, 15.9728  }, // 770
	{ 2205.7255, -1666.6981, 16.2393  }, // 771
	{ 2208.6694, -1655.3088, 16.5761  }, // 772
	{ 2211.6616, -1644.1102, 16.8920  }, // 773
	{ 2215.2819, -1632.2819, 17.2455  }, // 774
	{ 2220.2985, -1618.1591, 17.7503  }, // 775
	{ 2224.5207, -1607.4350, 18.2323  }, // 776
	{ 2229.4111, -1595.8509, 18.8258  }, // 777
	{ 2233.8322, -1585.1007, 19.4240  }, // 778
	{ 2237.6564, -1575.8205, 19.9171  }, // 779
	{ 2243.0627, -1562.6999, 20.5821  }, // 780
	{ 2247.4904, -1551.8975, 21.1091  }, // 781
	{ 2252.1748, -1540.3394, 21.5544  }, // 782
	{ 2256.6682, -1529.5625, 22.0891  }, // 783
	{ 2262.3041, -1515.7070, 22.7762  }, // 784
	{ 2266.4492, -1504.8194, 23.3909  }, // 785
	{ 2269.9060, -1494.6131, 23.7777  }, // 786
	{ 2273.4086, -1482.5922, 24.2598  }, // 787
	{ 2276.0888, -1471.3093, 24.5291  }, // 788
	{ 2278.5153, -1459.9372, 24.8273  }, // 789
	{ 2280.5839, -1448.5292, 25.0912  }, // 790
	{ 2282.3261, -1436.1835, 25.3331  }, // 791
	{ 2283.4055, -1424.6882, 25.4753  }, // 792
	{ 2284.1762, -1413.0467, 25.5588  }, // 793
	{ 2284.6118, -1402.9936, 25.5978  }, // 794
	{ 2284.7797, -1391.2331, 25.5995  }, // 795
	{ 2284.8750, -1381.1687, 25.6620  }, // 796
	{ 2284.8227, -1368.6730, 25.6721  }, // 797
	{ 2284.8750, -1358.6379, 25.7245  }, // 798
	{ 2284.8750, -1346.9025, 25.7245  }, // 799
	{ 2284.8750, -1332.7663, 25.7245  }, // 800
	{ 2284.8750, -1322.7644, 25.7245  }, // 801
	{ 2284.8750, -1312.7194, 25.7245  }, // 802
	{ 2284.8750, -1301.0837, 25.7245  }, // 803
	{ 2284.8750, -1290.9987, 25.7245  }, // 804
	{ 2284.8750, -1276.0124, 25.7245  }, // 805
	{ 2284.8750, -1264.2673, 25.7245  }, // 806
	{ 2284.8750, -1252.6315, 25.7245  }, // 807
	{ 2284.8750, -1240.9460, 25.7245  }, // 808
	{ 2284.8750, -1230.9440, 25.7245  }, // 809
	{ 2284.8750, -1219.3083, 25.9249  }, // 810
	{ 2284.8750, -1208.5227, 26.2058  }, // 811
	{ 2284.8750, -1198.4377, 26.7179  }, // 812
	{ 2284.8750, -1186.0327, 27.2790  }, // 813
	{ 2284.8750, -1174.3455, 27.7657  }, // 814
	{ 2284.8750, -1162.7617, 28.0589  }, // 815
	{ 2284.8750, -1150.2946, 28.2829  }, // 816
	{ 2284.8750, -1135.2843, 28.3586  }, // 817
	{ 2284.8750, -1123.6450, 28.4158  }, // 818
	{ 2284.8750, -1111.9780, 28.4716  }, // 819
	{ 2284.8750, -1100.3608, 28.5272  }, // 820
	{ 2284.8750, -1090.3278, 28.5653  }, // 821
	{ 2284.8750, -1078.5716, 28.5934  }, // 822
	{ 2284.8750, -1066.0803, 28.5995  }, // 823
	{ 2284.8750, -1054.3041, 28.5995  }, // 824
	{ 2284.8750, -1044.2764, 28.5995  }, // 825
	{ 2284.8750, -1031.7890, 28.5992  }, // 826
	{ 2284.8750, -1019.3203, 28.5734  }, // 827
	{ 2284.8750, -1007.6588, 28.5371  }, // 828
	{ 2284.8750, -996.0048, 28.4897  }, // 829
	{ 2284.8750, -983.5521, 28.4398  }, // 830
	{ 2284.8750, -971.8374, 28.3944  }, // 831
	{ 2284.8750, -961.7987, 28.3556  }, // 832
	{ 2284.8750, -949.2402, 28.3071  }, // 833
	{ 2284.8750, -937.5278, 28.2621  }, // 834
	{ 2284.8750, -925.8109, 28.2152  }, // 835
	{ 2284.8750, -914.1569, 28.1679  }, // 836
	{ 2284.7744, -902.5212, 28.2628  }, // 837
	{ 2284.5087, -890.8356, 28.5926  }, // 838
	{ 2284.0319, -879.1999, 29.2237  }, // 839
	{ 2283.3061, -867.5817, 29.9186  }, // 840
	{ 2282.1567, -853.4385, 30.7521  }, // 841
	{ 2281.0869, -843.5050, 31.3252  }, // 842
	{ 2279.2988, -831.9935, 32.1074  }, // 843
	{ 2276.6855, -818.0939, 33.1495  }, // 844
	{ 2274.1220, -807.5637, 34.0314  }, // 845
	{ 2271.0966, -798.0573, 34.8569  }, // 846
	{ 2265.8662, -784.1310, 36.0989  }, // 847
	{ 2261.2416, -774.4280, 37.0461  }, // 848
	{ 2256.4458, -765.6861, 37.9708  }, // 849
	{ 2250.0937, -755.9274, 39.1160  }, // 850
	{ 2242.5625, -745.9537, 40.3760  }, // 851
	{ 2236.0012, -738.4382, 41.3846  }, // 852
	{ 2228.9584, -731.3889, 42.3999  }, // 853
	{ 2219.8447, -722.9749, 43.7041  }, // 854
	{ 2210.4042, -714.9512, 45.0544  }, // 855
	{ 2202.0922, -708.1970, 46.2391  }, // 856
	{ 2194.0288, -702.2070, 47.3527  }, // 857
	{ 2184.6992, -695.1968, 48.6752  }, // 858
	{ 2174.7265, -687.6794, 50.3301  }, // 859
	{ 2165.4160, -680.6461, 51.8942  }, // 860
	{ 2156.0117, -673.5660, 53.5167  }, // 861
	{ 2146.0791, -666.0364, 55.3407  }, // 862
	{ 2136.7866, -658.9218, 57.0809  }, // 863
	{ 2126.8964, -651.2653, 58.9703  }, // 864
	{ 2119.0065, -645.0616, 60.4017  }, // 865
	{ 2111.1772, -638.8577, 61.8224  }, // 866
	{ 2102.1474, -631.6279, 63.4533  }, // 867
	{ 2093.0751, -624.2114, 64.9757  }, // 868
	{ 2085.3505, -617.8328, 66.2517  }, // 869
	{ 2075.8066, -609.8273, 67.7451  }, // 870
	{ 2066.9621, -602.2186, 68.9810  }, // 871
	{ 2058.2006, -594.5897, 70.0896  }, // 872
	{ 2049.4248, -586.8718, 71.1082  }, // 873
	{ 2040.8963, -579.0001, 71.9239  }, // 874
	{ 2032.6154, -570.8728, 72.6263  }, // 875
	{ 2025.7583, -563.5654, 73.0886  }, // 876
	{ 2018.0141, -553.7918, 73.5413  }, // 877
	{ 2011.3311, -544.2163, 73.8786  }, // 878
	{ 2004.1306, -531.1484, 74.0645  }, // 879
	{ 1998.8291, -518.1292, 74.0147  }, // 880
	{ 1995.7116, -506.0529, 73.6753  }, // 881
	{ 1994.0424, -494.5364, 73.2769  }, // 882
	{ 1993.6398, -484.5183, 72.8204  }, // 883
	{ 1994.2053, -472.8855, 72.3547  }, // 884
	{ 1996.4803, -458.1577, 71.7992  }, // 885
	{ 1999.1058, -446.7791, 71.4764  }, // 886
	{ 2002.6633, -435.6545, 71.2058  }, // 887
	{ 2007.2779, -424.1370, 70.9471  }, // 888
	{ 2011.7048, -415.1513, 70.7222  }, // 889
	{ 2019.2670, -403.3072, 70.2472  }, // 890
	{ 2028.9714, -391.9718, 69.5174  }, // 891
	{ 2037.7602, -384.4064, 68.6559  }, // 892
	{ 2047.2358, -377.7254, 67.7001  }, // 893
	{ 2058.2153, -371.8027, 66.4810  }, // 894
	{ 2071.9570, -366.0425, 64.9304  }, // 895
	{ 2085.3896, -362.0217, 63.4131  }, // 896
	{ 2095.1220, -359.8550, 62.3365  }, // 897
	{ 2106.6821, -358.0782, 61.1285  }, // 898
	{ 2119.1762, -356.9356, 59.8660  }, // 899
	{ 2130.8654, -356.6183, 58.6913  }, // 900
	{ 2140.8176, -356.4819, 57.6800  }, // 901
	{ 2155.0336, -356.9721, 55.9459  }, // 902
	{ 2165.0395, -357.3450, 54.6003  }, // 903
	{ 2176.7119, -357.6765, 52.7843  }, // 904
	{ 2190.8378, -357.5690, 50.5034  }, // 905
	{ 2201.6503, -357.2124, 48.7338  }, // 906
	{ 2211.5346, -356.1420, 47.2600  }, // 907
	{ 2223.1508, -354.4886, 45.5322  }, // 908
	{ 2234.4497, -351.8462, 44.1622  }, // 909
	{ 2244.1513, -349.0285, 42.9942  }, // 910
	{ 2254.9833, -344.9513, 41.8947  }, // 911
	{ 2265.6987, -340.1979, 40.7766  }, // 912
	{ 2276.7358, -334.3131, 39.4518  }, // 913
	{ 2286.7167, -328.3057, 37.9928  }, // 914
	{ 2295.1328, -322.8575, 36.5238  }, // 915
	{ 2306.8457, -315.0552, 34.2193  }, // 916
	{ 2315.7773, -309.0239, 32.3842  }, // 917
	{ 2324.0830, -303.4907, 30.6635  }, // 918
	{ 2332.4609, -298.0031, 28.9518  }, // 919
	{ 2341.0234, -292.8460, 27.2847  }, // 920
	{ 2349.7695, -288.0314, 25.7369  }, // 921
	{ 2358.8325, -283.7220, 24.3084  }, // 922
	{ 2368.1030, -279.8870, 22.9674  }, // 923
	{ 2379.2114, -276.3988, 21.8779  }, // 924
	{ 2388.9016, -274.0427, 21.0113  }, // 925
	{ 2400.4306, -272.5593, 20.5170  }, // 926
	{ 2411.9721, -271.9628, 20.2086  }, // 927
	{ 2424.4604, -272.1801, 20.0493  }, // 928
	{ 2436.9760, -272.7788, 19.9382  }, // 929
	{ 2448.6206, -273.5855, 19.7841  }, // 930
	{ 2463.4687, -274.7045, 19.5269  }, // 931
	{ 2474.9912, -275.7220, 19.2950  }, // 932
	{ 2486.6835, -276.9569, 19.0284  }, // 933
	{ 2496.7092, -278.1435, 18.8186  }, // 934
	{ 2511.6215, -279.9438, 18.4087  }, // 935
	{ 2523.1823, -281.4705, 18.1034  }, // 936
	{ 2537.9990, -283.4392, 17.6312  }, // 937
	{ 2549.5922, -285.0869, 17.2617  }, // 938
	{ 2561.1748, -286.8266, 16.8707  }, // 939
	{ 2573.4946, -288.8709, 16.4620  }, // 940
	{ 2584.9892, -290.6104, 16.0458  }, // 941
	{ 2597.4101, -292.2340, 15.6531  }, // 942
	{ 2609.0747, -293.4445, 15.3482  }, // 943
	{ 2624.0810, -294.4308, 15.2194  }, // 944
	{ 2635.6596, -294.9738, 15.2114  }, // 945
	{ 2648.1718, -294.8574, 15.4086  }, // 946
	{ 2663.0273, -294.2730, 15.7252  }, // 947
	{ 2672.9948, -293.1698, 16.0755  }, // 948
	{ 2685.2744, -291.6430, 16.5408  }, // 949
	{ 2695.0988, -289.7260, 16.9727  }, // 950
	{ 2707.3071, -287.1405, 17.5117  }, // 951
	{ 2721.6967, -283.0859, 18.2488  }, // 952
	{ 2732.6965, -279.3510, 18.8485  }, // 953
	{ 2745.5129, -272.0646, 19.8395  }, // 954
	{ 2753.7246, -264.0957, 20.8469  }, // 955
	{ 2760.3952, -254.5238, 21.9332  }, // 956
	{ 2766.4484, -243.6503, 23.2247  }, // 957
	{ 2771.9223, -233.3610, 24.4213  }, // 958
	{ 2777.8081, -222.3678, 25.6691  }, // 959
	{ 2782.5344, -213.5971, 26.6538  }, // 960
	{ 2789.3598, -201.1101, 28.0119  }, // 961
	{ 2794.7561, -190.8186, 29.1021  }, // 962
	{ 2799.3095, -181.8903, 30.0328  }, // 963
	{ 2803.6821, -172.9272, 30.9342  }, // 964
	{ 2807.8554, -163.8621, 31.7756  }, // 965
	{ 2811.9602, -154.6947, 32.5937  }, // 966
	{ 2815.8200, -145.4706, 33.3473  }, // 967
	{ 2819.5493, -136.1277, 34.0810  }, // 968
	{ 2822.7932, -126.6736, 34.7261  }, // 969
	{ 2825.3405, -116.9995, 35.2214  }, // 970
	{ 2827.2905, -104.7429, 35.4759  }, // 971
	{ 2827.9636, -92.2841, 35.5208  }, // 972
	{ 2828.0366, -77.3474, 35.0735  }, // 973
	{ 2827.9372, -65.7369, 34.6121  }, // 974
	{ 2827.8872, -54.0564, 34.0237  }, // 975
	{ 2827.8374, -42.4095, 33.4370  }, // 976
	{ 2827.7836, -29.9293, 32.8083  }, // 977
	{ 2827.7302, -17.4491, 32.1796  }, // 978
	{ 2827.6767, -4.9689, 31.5509  }, // 979
	{ 2827.6337, 5.0618, 31.0456  }, // 980
	{ 2827.5803, 17.5420, 30.4169  }, // 981
	{ 2827.4716, 29.2180, 29.8492  }, // 982
	{ 2827.1076, 40.8744, 29.3725  }, // 983
	{ 2826.5546, 52.4663, 28.9655  }, // 984
	{ 2825.7456, 62.4616, 28.6585  }, // 985
	{ 2824.5922, 74.9637, 28.2788  }, // 986
	{ 2823.2165, 85.8029, 27.7682  }, // 987
	{ 2821.6975, 97.3432, 27.1078  }, // 988
	{ 2819.9682, 108.8486, 25.9616  }, // 989
	{ 2818.4267, 118.7338, 24.8407  }, // 990
	{ 2816.4948, 128.6018, 23.5137  }, // 991
	{ 2813.9921, 140.0403, 21.9311  }, // 992
	{ 2811.3886, 149.6747, 20.5884  }, // 993
	{ 2807.2487, 163.2498, 18.6786  }, // 994
	{ 2803.6267, 174.2941, 17.1874  }, // 995
	{ 2800.6403, 183.8024, 15.9631  }, // 996
	{ 2796.4404, 197.3692, 14.2899  }, // 997
	{ 2792.7321, 208.3949, 13.2346  }, // 998
	{ 2788.5703, 220.1865, 12.2676  }, // 999
	{ 2784.4638, 231.0228, 11.6137  }, // 1000
	{ 2780.9792, 240.3983, 11.2278  }, // 1001
	{ 2776.0490, 253.7709, 10.7824  }, // 1002
	{ 2772.3085, 264.8211, 10.4702  }, // 1003
	{ 2769.3793, 274.4004, 10.1846  }, // 1004
	{ 2767.2641, 284.1936, 9.9937  }, // 1005
	{ 2765.8686, 295.7138, 9.7849  }, // 1006
	{ 2765.1958, 307.4016, 9.6867  }, // 1007
	{ 2765.1669, 319.0164, 9.5406  }, // 1008
	{ 2765.1721, 333.0924, 9.3803  }, // 1009
	{ 2765.2265, 344.7645, 9.2903  }, // 1010
	{ 2765.2939, 359.7059, 9.2245  }, // 1011
	{ 2765.3237, 371.3543, 9.2245  }, // 1012
	{ 2765.2470, 383.0387, 9.2245  }, // 1013
	{ 2765.1250, 393.0654, 9.2245  }, // 1014
	{ 2764.9711, 405.5414, 9.2505  }, // 1015
	{ 2764.8750, 419.6782, 9.3114  }, // 1016
	{ 2764.8842, 434.6394, 9.4202  }, // 1017
	{ 2764.9819, 446.3808, 9.5350  }, // 1018
	{ 2765.1293, 458.0184, 9.6653  }, // 1019
	{ 2765.2661, 469.7144, 9.7937  }, // 1020
	{ 2765.3500, 481.3706, 9.9056  }, // 1021
	{ 2765.3295, 493.0642, 9.9858  }, // 1022
	{ 2765.3034, 504.7421, 10.0642  }, // 1023
	{ 2765.2770, 516.4703, 10.1429  }, // 1024
	{ 2765.2448, 530.6859, 10.2596  }, // 1025
	{ 2765.2104, 545.6818, 10.4033  }, // 1026
	{ 2765.1831, 557.3640, 10.5258  }, // 1027
	{ 2765.1538, 569.9056, 10.6573  }, // 1028
	{ 2765.1264, 581.6378, 10.7802  }, // 1029
	{ 2765.1030, 591.6701, 10.8854  }, // 1030
	{ 2765.0703, 605.8021, 11.0336  }, // 1031
	{ 2765.0468, 615.8344, 11.1387  }, // 1032
	{ 2765.0175, 628.3165, 11.2696  }, // 1033
	{ 2764.9907, 639.9987, 11.3921  }, // 1034
	{ 2764.9633, 651.6976, 11.5147  }, // 1035
	{ 2764.9301, 665.8295, 11.6629  }, // 1036
	{ 2764.9013, 678.3115, 11.7937  }, // 1037
	{ 2764.8681, 692.4935, 11.9424  }, // 1038
	{ 2764.8427, 703.3258, 12.0560  }, // 1039
	{ 2764.8139, 715.8078, 12.1868  }, // 1040
	{ 2764.7846, 728.2899, 12.3177  }, // 1041
	{ 2764.7607, 743.2727, 12.4264  }, // 1042
	{ 2764.7500, 758.2565, 12.4745  }, // 1043
	{ 2764.7500, 773.2245, 12.4745  }, // 1044
	{ 2764.7500, 783.2255, 12.4745  }, // 1045
	{ 2764.7500, 795.7100, 12.4745  }, // 1046
	{ 2764.7500, 805.7443, 12.4745  }, // 1047
	{ 2764.7500, 816.6287, 12.4745  }, // 1048
	{ 2764.7500, 828.2631, 12.4745  }, // 1049
	{ 2764.7500, 838.2640, 12.4745  }, // 1050
	{ 2764.7500, 850.7485, 12.4745  }, // 1051
	{ 2764.7500, 863.2330, 12.4745  }, // 1052
	{ 2764.7500, 873.2673, 12.4745  }, // 1053
	{ 2764.7500, 885.7018, 12.4745  }, // 1054
	{ 2764.7500, 898.1863, 12.4745  }, // 1055
	{ 2764.7500, 910.7208, 12.4745  }, // 1056
	{ 2764.7500, 923.2053, 12.4745  }, // 1057
	{ 2764.7500, 934.9398, 12.4745  }, // 1058
	{ 2764.7500, 949.0745, 12.4745  }, // 1059
	{ 2764.7500, 960.6588, 12.4745  }, // 1060
	{ 2764.7500, 970.6597, 12.4745  }, // 1061
	{ 2764.7500, 982.2942, 12.4745  }, // 1062
	{ 2764.7500, 994.7286, 12.4745  }, // 1063
	{ 2764.7500, 1006.4631, 12.4745  }, // 1064
	{ 2764.9047, 1018.9462, 12.4745  }, // 1065
	{ 2766.6567, 1030.3040, 12.6668  }, // 1066
	{ 2771.7536, 1044.0163, 12.9348  }, // 1067
	{ 2779.6005, 1056.7719, 13.1596  }, // 1068
	{ 2788.4580, 1068.8818, 13.1610  }, // 1069
	{ 2797.3828, 1080.9232, 12.7360  }, // 1070
	{ 2803.6206, 1089.8576, 12.5189  }, // 1071
	{ 2810.1364, 1099.5874, 12.3532  }, // 1072
	{ 2816.4326, 1110.3659, 12.3495  }, // 1073
	{ 2822.2050, 1120.5344, 12.3495  }, // 1074
	{ 2827.7431, 1130.6643, 12.3495  }, // 1075
	{ 2833.4897, 1141.6906, 12.3495  }, // 1076
	{ 2838.0444, 1150.6291, 12.3463  }, // 1077
	{ 2843.0390, 1161.1657, 12.3037  }, // 1078
	{ 2847.8505, 1171.8303, 12.2659  }, // 1079
	{ 2852.6982, 1183.2823, 12.2245  }, // 1080
	{ 2856.8515, 1194.1992, 12.2245  }, // 1081
	{ 2860.6984, 1206.0808, 12.2360  }, // 1082
	{ 2862.9565, 1215.9013, 12.2870  }, // 1083
	{ 2864.5490, 1230.0141, 12.3351  }, // 1084
	{ 2864.7500, 1244.9631, 12.3495  }, // 1085
	{ 2864.7500, 1256.6477, 12.3495  }, // 1086
	{ 2864.7500, 1271.6730, 12.3495  }, // 1087
	{ 2864.7500, 1283.2886, 12.3495  }, // 1088
	{ 2864.7500, 1294.9370, 12.3495  }, // 1089
	{ 2864.7500, 1307.4309, 12.3495  }, // 1090
	{ 2864.7500, 1319.8916, 12.3495  }, // 1091
	{ 2864.7500, 1331.5421, 12.3495  }, // 1092
	{ 2864.7500, 1346.5177, 12.3495  }, // 1093
	{ 2864.7500, 1358.2204, 12.3495  }, // 1094
	{ 2864.7500, 1369.8781, 12.3495  }, // 1095
	{ 2864.7500, 1382.3875, 12.3495  }, // 1096
	{ 2864.7500, 1392.4416, 12.3495  }, // 1097
	{ 2864.7500, 1406.6540, 12.3495  }, // 1098
	{ 2864.7500, 1416.6578, 12.3495  }, // 1099
	{ 2864.7500, 1430.8706, 12.3495  }, // 1100
	{ 2864.7500, 1442.6289, 12.3495  }, // 1101
	{ 2864.7500, 1457.5725, 12.3495  }, // 1102
	{ 2864.7500, 1467.6064, 12.3495  }, // 1103
	{ 2864.4614, 1481.7121, 12.3495  }, // 1104
	{ 2863.7666, 1493.4420, 12.3495  }, // 1105
	{ 2861.6459, 1508.2307, 12.3495  }, // 1106
	{ 2858.4301, 1522.7359, 12.3495  }, // 1107
	{ 2855.0234, 1533.8270, 12.3495  }, // 1108
	{ 2850.7331, 1545.5886, 12.3495  }, // 1109
	{ 2846.7336, 1554.7580, 12.3495  }, // 1110
	{ 2841.5969, 1565.1337, 12.3495  }, // 1111
	{ 2834.3127, 1577.2603, 12.3495  }, // 1112
	{ 2825.4897, 1589.2800, 12.3495  }, // 1113
	{ 2818.1616, 1598.3703, 12.3495  }, // 1114
	{ 2809.9868, 1607.8719, 12.3495  }, // 1115
	{ 2802.5578, 1616.8967, 12.3495  }, // 1116
	{ 2795.1118, 1625.8930, 12.3495  }, // 1117
	{ 2787.6918, 1635.7802, 12.3495  }, // 1118
	{ 2783.4035, 1646.3048, 12.3495  }, // 1119
	{ 2781.1157, 1659.8969, 12.3495  }, // 1120
	{ 2781.0000, 1671.5690, 12.3495  }, // 1121
	{ 2781.0000, 1681.5809, 12.3495  }, // 1122
	{ 2780.9375, 1696.4632, 12.3495  }, // 1123
	{ 2780.8750, 1711.4709, 12.3495  }, // 1124
	{ 2780.8750, 1726.3923, 12.3495  }, // 1125
	{ 2780.8750, 1736.4653, 12.3495  }, // 1126
	{ 2780.8750, 1750.5970, 12.3495  }, // 1127
	{ 2780.8750, 1762.2696, 12.3495  }, // 1128
	{ 2780.8750, 1774.7052, 12.3495  }, // 1129
	{ 2780.8750, 1786.2623, 12.3495  }, // 1130
	{ 2780.9282, 1798.0567, 12.3495  }, // 1131
	{ 2780.9526, 1810.5982, 12.3495  }, // 1132
	{ 2781.0000, 1820.6414, 12.3495  }, // 1133
	{ 2781.0000, 1830.6990, 12.3495  }, // 1134
	{ 2781.0000, 1842.2597, 12.2517  }, // 1135
	{ 2781.0000, 1852.3259, 12.0027  }, // 1136
	{ 2781.0000, 1867.1481, 11.1349  }, // 1137
	{ 2781.0000, 1877.2460, 10.3076  }, // 1138
	{ 2781.0000, 1887.2636, 9.2650  }, // 1139
	{ 2781.0000, 1897.2741, 8.3164  }, // 1140
	{ 2781.0000, 1908.9545, 7.2400  }, // 1141
	{ 2781.0000, 1920.5988, 6.5526  }, // 1142
	{ 2781.0000, 1932.3466, 6.2053  }, // 1143
	{ 2782.0036, 1944.6923, 6.0995  }, // 1144
	{ 2783.1171, 1957.0067, 6.0995  }, // 1145
	{ 2784.5693, 1968.5718, 6.0967  }, // 1146
	{ 2784.2373, 1983.5407, 6.0094  }, // 1147
	{ 2783.5217, 1995.0844, 5.8721  }, // 1148
	{ 2782.0754, 2006.6716, 5.7124  }, // 1149
	{ 2780.0903, 2018.9301, 5.4416  }, // 1150
	{ 2777.6733, 2030.3237, 5.1852  }, // 1151
	{ 2774.2866, 2042.4062, 4.7696  }, // 1152
	{ 2771.0446, 2051.8786, 4.4340  }, // 1153
	{ 2765.6225, 2065.1074, 3.8742  }, // 1154
	{ 2760.4970, 2075.4453, 3.4132  }, // 1155
	{ 2752.8767, 2088.2973, 2.7340  }, // 1156
	{ 2746.1987, 2097.7788, 2.1951  }, // 1157
	{ 2738.3125, 2107.5844, 1.5966  }, // 1158
	{ 2730.3942, 2116.1220, 1.0493  }, // 1159
	{ 2723.2431, 2123.1301, 0.6103  }, // 1160
	{ 2712.5930, 2132.5629, 0.0928  }, // 1161
	{ 2700.9001, 2141.8349, -0.3502  }, // 1162
	{ 2691.5776, 2148.6533, -0.6224  }, // 1163
	{ 2681.9577, 2155.3300, -0.7989  }, // 1164
	{ 2672.2148, 2161.8852, -0.8763  }, // 1165
	{ 2662.4543, 2168.2617, -0.7882  }, // 1166
	{ 2652.6638, 2174.7182, -0.6283  }, // 1167
	{ 2642.9746, 2181.1291, -0.3614  }, // 1168
	{ 2631.3459, 2189.0358, 0.0447  }, // 1169
	{ 2623.2177, 2194.8830, 0.3891  }, // 1170
	{ 2612.0820, 2203.4580, 0.9335  }, // 1171
	{ 2603.1967, 2211.0371, 1.4193  }, // 1172
	{ 2595.3459, 2218.4526, 1.8731  }, // 1173
	{ 2588.5019, 2225.7661, 2.3074  }, // 1174
	{ 2582.0864, 2233.4284, 2.7148  }, // 1175
	{ 2574.5664, 2244.2971, 3.2864  }, // 1176
	{ 2568.7241, 2254.4687, 3.7110  }, // 1177
	{ 2563.6450, 2265.8229, 4.1224  }, // 1178
	{ 2559.6992, 2276.8627, 4.4360  }, // 1179
	{ 2556.8444, 2287.5903, 4.6700  }, // 1180
	{ 2554.6411, 2299.5102, 4.8314  }, // 1181
	{ 2553.4541, 2311.8618, 4.9120  }, // 1182
	{ 2552.9333, 2323.5283, 5.2000  }, // 1183
	{ 2552.7500, 2334.1784, 5.7817  }, // 1184
	{ 2552.7128, 2345.0063, 6.7084  }, // 1185
	{ 2552.6801, 2355.8986, 7.7520  }, // 1186
	{ 2552.6340, 2367.6218, 8.7988  }, // 1187
	{ 2552.6250, 2377.6740, 9.5252  }, // 1188
	{ 2552.6250, 2387.6931, 10.2044  }, // 1189
	{ 2552.6250, 2402.6218, 10.9995  }, // 1190
	{ 2552.6250, 2414.2485, 11.4887  }, // 1191
	{ 2552.6660, 2425.9270, 11.8489  }, // 1192
	{ 2552.7021, 2437.5917, 12.1087  }, // 1193
	{ 2552.6801, 2449.3532, 12.2803  }, // 1194
	{ 2551.5764, 2461.6005, 12.3415  }, // 1195
	{ 2550.3068, 2473.9379, 12.3495  }, // 1196
	{ 2548.6931, 2488.6276, 12.3495  }, // 1197
	{ 2548.6953, 2503.6533, 12.3495  }, // 1198
	{ 2548.7250, 2515.3393, 12.3495  }, // 1199
	{ 2548.7500, 2527.8637, 12.3495  }, // 1200
	{ 2548.7043, 2537.9233, 12.3495  }, // 1201
	{ 2548.1308, 2552.0136, 12.3495  }, // 1202
	{ 2546.9130, 2563.6933, 12.3495  }, // 1203
	{ 2544.4340, 2577.6442, 12.3495  }, // 1204
	{ 2541.3161, 2589.6606, 12.3495  }, // 1205
	{ 2537.8342, 2600.7529, 12.3495  }, // 1206
	{ 2533.7006, 2611.5444, 12.3495  }, // 1207
	{ 2529.5747, 2620.7502, 12.3495  }, // 1208
	{ 2522.4750, 2633.9396, 12.3495  }, // 1209
	{ 2514.2685, 2646.5068, 12.3495  }, // 1210
	{ 2507.1162, 2655.5187, 12.3495  }, // 1211
	{ 2500.2431, 2662.8613, 12.3495  }, // 1212
	{ 2490.8549, 2670.9628, 12.3495  }, // 1213
	{ 2480.6196, 2677.8686, 12.3495  }, // 1214
	{ 2469.5444, 2683.3281, 12.3495  }, // 1215
	{ 2458.6318, 2686.9882, 12.3495  }, // 1216
	{ 2446.3867, 2689.1215, 12.3495  }, // 1217
	{ 2433.9848, 2689.9692, 12.3495  }, // 1218
	{ 2422.3056, 2690.1250, 12.3495  }, // 1219
	{ 2412.2658, 2690.1250, 12.3495  }, // 1220
	{ 2398.1147, 2690.1250, 12.3495  }, // 1221
	{ 2386.4645, 2690.1250, 12.3495  }, // 1222
	{ 2373.9641, 2690.1250, 12.3495  }, // 1223
	{ 2363.9509, 2690.1250, 12.3495  }, // 1224
	{ 2352.2521, 2690.1250, 12.3495  }, // 1225
	{ 2338.1010, 2690.1250, 12.3495  }, // 1226
	{ 2326.4020, 2690.1250, 12.3495  }, // 1227
	{ 2315.5053, 2690.1250, 12.3495  }, // 1228
	{ 2303.0046, 2690.1250, 12.3495  }, // 1229
	{ 2291.3059, 2690.1250, 12.3495  }, // 1230
	{ 2281.2946, 2690.1250, 12.3495  }, // 1231
	{ 2266.3063, 2690.1250, 12.3495  }, // 1232
	{ 2254.6408, 2690.1250, 12.3495  }, // 1233
	{ 2242.9421, 2690.1250, 12.3495  }, // 1234
	{ 2231.3166, 2690.1250, 12.3495  }, // 1235
	{ 2218.9125, 2690.1250, 12.3495  }, // 1236
	{ 2206.4931, 2690.1250, 12.3495  }, // 1237
	{ 2194.8706, 2690.1250, 12.3495  }, // 1238
	{ 2183.2272, 2690.1250, 12.3495  }, // 1239
	{ 2171.7241, 2691.1948, 12.3495  }, // 1240
	{ 2160.1035, 2692.2817, 12.3495  }, // 1241
	{ 2148.5864, 2693.7563, 12.3723  }, // 1242
	{ 2137.0224, 2694.1250, 12.4054  }, // 1243
	{ 2125.3725, 2694.1250, 12.4560  }, // 1244
	{ 2111.2783, 2694.1250, 12.5173  }, // 1245
	{ 2099.6235, 2694.1250, 12.5604  }, // 1246
	{ 2087.0446, 2694.1250, 12.5653  }, // 1247
	{ 2075.3925, 2694.1250, 12.5393  }, // 1248
	{ 2064.5329, 2694.1250, 12.5008  }, // 1249
	{ 2052.8239, 2694.1250, 12.4592  }, // 1250
	{ 2041.1616, 2694.1250, 12.4179  }, // 1251
	{ 2031.1398, 2694.1250, 12.3823  }, // 1252
	{ 2018.6408, 2694.1250, 12.3601  }, // 1253
	{ 2006.9990, 2694.1250, 12.3495  }, // 1254
	{ 1994.4072, 2694.1250, 12.3495  }, // 1255
	{ 1984.3740, 2694.1250, 12.3495  }, // 1256
	{ 1970.2392, 2694.1250, 12.3495  }, // 1257
	{ 1958.5556, 2694.1250, 12.3495  }, // 1258
	{ 1946.8645, 2694.1250, 12.3495  }, // 1259
	{ 1934.2890, 2694.1250, 12.3495  }, // 1260
	{ 1922.6674, 2694.1250, 12.3495  }, // 1261
	{ 1910.1805, 2694.1250, 12.3495  }, // 1262
	{ 1898.5579, 2694.1250, 12.3495  }, // 1263
	{ 1883.5893, 2694.1250, 12.3495  }, // 1264
	{ 1871.9667, 2694.1250, 12.3495  }, // 1265
	{ 1859.3889, 2693.8647, 12.3495  }, // 1266
	{ 1847.7792, 2693.0966, 12.3495  }, // 1267
	{ 1832.9226, 2691.1066, 12.3495  }, // 1268
	{ 1821.4970, 2688.7680, 12.3495  }, // 1269
	{ 1810.1513, 2685.9438, 12.3495  }, // 1270
	{ 1800.5139, 2683.1528, 12.3495  }, // 1271
	{ 1786.2142, 2678.7468, 12.3495  }, // 1272
	{ 1775.1872, 2675.0375, 12.3495  }, // 1273
	{ 1764.1418, 2671.2155, 12.3495  }, // 1274
	{ 1752.3632, 2666.9970, 12.3495  }, // 1275
	{ 1741.3244, 2663.0249, 12.3495  }, // 1276
	{ 1727.1630, 2657.9653, 12.3495  }, // 1277
	{ 1712.9891, 2653.1728, 12.3495  }, // 1278
	{ 1701.8984, 2649.6210, 12.3495  }, // 1279
	{ 1690.7409, 2646.3767, 12.3495  }, // 1280
	{ 1679.4727, 2643.4086, 12.3495  }, // 1281
	{ 1669.6656, 2641.1679, 12.3495  }, // 1282
	{ 1659.0703, 2639.1286, 12.3495  }, // 1283
	{ 1647.5874, 2637.5595, 12.3495  }, // 1284
	{ 1635.1687, 2636.6313, 12.3495  }, // 1285
	{ 1622.8173, 2634.7827, 12.3495  }, // 1286
	{ 1610.5461, 2633.7258, 12.3495  }, // 1287
	{ 1595.6914, 2632.2500, 12.3495  }, // 1288
	{ 1580.7897, 2632.2500, 12.3495  }, // 1289
	{ 1569.0810, 2632.2500, 12.3495  }, // 1290
	{ 1559.0615, 2632.2500, 12.3495  }, // 1291
	{ 1544.8139, 2632.2500, 12.3495  }, // 1292
	{ 1534.7905, 2632.2500, 12.3495  }, // 1293
	{ 1520.5764, 2632.2500, 12.3495  }, // 1294
	{ 1505.6066, 2632.2500, 12.3495  }, // 1295
	{ 1493.8979, 2632.2500, 12.3495  }, // 1296
	{ 1481.4774, 2632.2500, 12.3495  }, // 1297
	{ 1466.6018, 2632.2500, 12.3495  }, // 1298
	{ 1455.0107, 2632.2500, 12.3495  }, // 1299
	{ 1443.3271, 2632.2500, 12.3495  }, // 1300
	{ 1430.8916, 2632.2500, 12.3495  }, // 1301
	{ 1419.2080, 2632.2500, 12.3495  }, // 1302
	{ 1404.2193, 2632.2500, 12.3495  }, // 1303
	{ 1392.5297, 2632.2500, 12.3495  }, // 1304
	{ 1379.9829, 2632.2500, 12.3495  }, // 1305
	{ 1368.3283, 2632.2500, 12.3495  }, // 1306
	{ 1355.7822, 2632.2500, 12.3495  }, // 1307
	{ 1344.0866, 2632.2500, 12.3495  }, // 1308
	{ 1334.0764, 2632.2500, 12.3495  }, // 1309
	{ 1324.0308, 2632.2500, 12.3495  }, // 1310
	{ 1312.3841, 2632.2500, 12.3495  }, // 1311
	{ 1302.3405, 2632.2500, 12.3495  }, // 1312
	{ 1290.7426, 2632.2500, 12.3495  }, // 1313
	{ 1279.0471, 2632.2500, 12.3495  }, // 1314
	{ 1267.3847, 2632.2500, 12.3495  }, // 1315
	{ 1254.8874, 2632.2500, 12.3495  }, // 1316
	{ 1242.3811, 2632.2500, 12.3495  }, // 1317
	{ 1232.3471, 2632.2500, 12.3495  }, // 1318
	{ 1218.2041, 2633.0834, 12.5046  }, // 1319
	{ 1206.7291, 2634.8056, 12.7143  }, // 1320
	{ 1194.7834, 2638.0278, 13.0008  }, // 1321
	{ 1183.9101, 2642.0207, 13.2612  }, // 1322
	{ 1173.3808, 2646.8984, 13.5103  }, // 1323
	{ 1162.5307, 2652.8486, 13.7649  }, // 1324
	{ 1152.6894, 2659.3022, 13.9944  }, // 1325
	{ 1140.5704, 2668.1008, 14.3004  }, // 1326
	{ 1132.6293, 2674.2529, 14.5225  }, // 1327
	{ 1122.8608, 2682.0322, 14.7908  }, // 1328
	{ 1113.1079, 2689.8198, 15.0352  }, // 1329
	{ 1103.2591, 2697.4135, 15.2605  }, // 1330
	{ 1093.4573, 2705.1059, 15.4850  }, // 1331
	{ 1081.8016, 2714.4477, 15.7520  }, // 1332
	{ 1074.0026, 2720.7744, 15.9313  }, // 1333
	{ 1064.1489, 2728.4099, 16.1585  }, // 1334
	{ 1055.9436, 2734.1552, 16.3482  }, // 1335
	{ 1045.3687, 2740.6870, 16.5944  }, // 1336
	{ 1032.1643, 2747.5812, 16.9046  }, // 1337
	{ 1022.8522, 2751.4494, 17.1519  }, // 1338
	{ 1010.9828, 2755.1040, 17.4709  }, // 1339
	{ 1001.1351, 2756.8859, 17.8598  }, // 1340
	{ 989.7193, 2757.9628, 18.2781  }, // 1341
	{ 978.0943, 2758.3044, 18.8047  }, // 1342
	{ 966.3193, 2758.4501, 19.2733  }, // 1343
	{ 953.9354, 2758.3044, 19.7203  }, // 1344
	{ 941.4293, 2757.0703, 20.2587  }, // 1345
	{ 926.8822, 2753.8300, 20.7658  }, // 1346
	{ 916.0132, 2749.8281, 21.1112  }, // 1347
	{ 904.9259, 2744.3012, 21.3550  }, // 1348
	{ 895.1385, 2738.0676, 21.5962  }, // 1349
	{ 886.0002, 2730.8911, 21.7905  }, // 1350
	{ 877.3910, 2723.2055, 21.9746  }, // 1351
	{ 870.2009, 2716.2192, 22.1195  }, // 1352
	{ 862.8633, 2708.3029, 22.2450  }, // 1353
	{ 856.2498, 2700.7846, 22.3088  }, // 1354
	{ 848.6939, 2691.7963, 22.3495  }, // 1355
	{ 840.9974, 2681.9667, 22.3495  }, // 1356
	{ 834.5980, 2672.4208, 22.3495  }, // 1357
	{ 828.6975, 2662.4326, 22.3495  }, // 1358
	{ 823.2035, 2652.1572, 22.3495  }, // 1359
	{ 817.4464, 2641.0996, 22.3495  }, // 1360
	{ 812.0989, 2630.7958, 22.3495  }, // 1361
	{ 806.7483, 2620.3952, 22.3495  }, // 1362
	{ 801.0598, 2609.2429, 22.3495  }, // 1363
	{ 795.8282, 2598.8085, 22.3495  }, // 1364
	{ 790.3265, 2587.7392, 22.3495  }, // 1365
	{ 785.2589, 2577.3081, 22.3495  }, // 1366
	{ 779.9291, 2566.0671, 22.3495  }, // 1367
	{ 775.6545, 2556.9396, 22.3495  }, // 1368
	{ 769.8078, 2543.9704, 22.3299  }, // 1369
	{ 765.6990, 2534.7812, 22.3081  }, // 1370
	{ 759.9595, 2521.8574, 22.2679  }, // 1371
	{ 755.2501, 2511.1979, 22.2252  }, // 1372
	{ 750.9184, 2501.3378, 22.1760  }, // 1373
	{ 746.1540, 2489.9287, 22.0967  }, // 1374
	{ 742.2219, 2479.8979, 22.0223  }, // 1375
	{ 739.0874, 2470.3471, 21.9486  }, // 1376
	{ 735.7962, 2458.3283, 21.8572  }, // 1377
	{ 733.0566, 2446.0534, 21.7520  }, // 1378
	{ 730.4791, 2431.3696, 21.5939  }, // 1379
	{ 728.9210, 2419.7890, 21.4675  }, // 1380
	{ 727.6361, 2408.2358, 21.3639  }, // 1381
	{ 726.5852, 2396.6074, 21.2741  }, // 1382
	{ 725.9577, 2384.1938, 21.1396  }, // 1383
	{ 725.6458, 2372.5961, 21.0175  }, // 1384
	{ 725.5505, 2360.1865, 20.8908  }, // 1385
	{ 725.7222, 2348.6206, 20.8058  }, // 1386
	{ 726.0982, 2336.9111, 20.7187  }, // 1387
	{ 726.5975, 2325.3112, 20.6120  }, // 1388
	{ 727.1348, 2315.2563, 20.4969  }, // 1389
	{ 728.0456, 2303.6232, 20.3691  }, // 1390
	{ 729.0547, 2292.8891, 20.2296  }, // 1391
	{ 730.2000, 2282.8789, 20.1083  }, // 1392
	{ 731.5905, 2271.3691, 19.9741  }, // 1393
	{ 733.0885, 2259.7844, 19.7977  }, // 1394
	{ 734.4934, 2248.2922, 19.6185  }, // 1395
	{ 735.6078, 2238.3452, 19.4145  }, // 1396
	{ 736.8797, 2223.4790, 19.1385  }, // 1397
	{ 737.4351, 2211.8125, 18.8744  }, // 1398
	{ 737.8830, 2199.2502, 18.5056  }, // 1399
	{ 738.1572, 2189.2368, 18.0448  }, // 1400
	{ 738.6218, 2175.0595, 17.3359  }, // 1401
	{ 738.9992, 2163.3593, 16.7070  }, // 1402
	{ 739.1888, 2151.5766, 16.0464  }, // 1403
	{ 739.1914, 2139.1889, 15.3205  }, // 1404
	{ 739.2014, 2127.4619, 14.6427  }, // 1405
	{ 739.2992, 2112.5590, 13.7429  }, // 1406
	{ 739.4527, 2100.8659, 13.0200  }, // 1407
	{ 739.6358, 2089.2314, 12.2710  }, // 1408
	{ 739.8189, 2077.5969, 11.5220  }, // 1409
	{ 740.0020, 2065.9624, 10.7730  }, // 1410
	{ 740.1868, 2054.2116, 10.0165  }, // 1411
	{ 740.3699, 2042.5771, 9.2675  }, // 1412
	{ 740.5648, 2028.3964, 8.5669  }, // 1413
	{ 740.7263, 2013.4409, 8.1569  }, // 1414
	{ 740.8176, 2001.8056, 8.0961  }, // 1415
	{ 740.9348, 1986.8576, 8.0179  }, // 1416
	{ 741.0260, 1975.2221, 7.9571  }, // 1417
	{ 741.1171, 1963.6032, 7.8964  }, // 1418
	{ 741.2090, 1951.8851, 7.8351  }, // 1419
	{ 741.3005, 1940.2165, 7.7741  }, // 1420
	{ 741.3916, 1928.5977, 7.7134  }, // 1421
	{ 741.4839, 1916.8295, 7.6519  }, // 1422
	{ 741.5942, 1902.7637, 7.5783  }, // 1423
	{ 741.6857, 1891.0952, 7.5173  }, // 1424
	{ 741.8027, 1876.1804, 7.4394  }, // 1425
	{ 741.8812, 1866.1599, 7.3870  }, // 1426
	{ 741.9919, 1852.0441, 7.3132  }, // 1427
	{ 742.0834, 1840.3756, 7.2522  }, // 1428
	{ 742.2008, 1825.4111, 7.1740  }, // 1429
	{ 742.2922, 1813.7424, 7.1130  }, // 1430
	{ 742.3835, 1802.1071, 7.0522  }, // 1431
	{ 742.4639, 1790.4332, 7.0404  }, // 1432
	{ 742.5342, 1778.7443, 7.0750  }, // 1433
	{ 742.5843, 1767.0554, 7.1995  }, // 1434
	{ 742.6332, 1755.3659, 7.3297  }, // 1435
	{ 742.6925, 1741.1752, 7.4879  }, // 1436
	{ 742.7413, 1729.4855, 7.6181  }, // 1437
	{ 742.8039, 1714.4942, 7.7851  }, // 1438
	{ 742.8481, 1704.4567, 7.9050  }, // 1439
	{ 742.9204, 1690.3720, 8.1123  }, // 1440
	{ 742.9899, 1678.6425, 8.3194  }, // 1441
	{ 743.0812, 1663.6650, 8.5934  }, // 1442
	{ 743.1674, 1649.5371, 8.8519  }, // 1443
	{ 743.2435, 1637.0585, 9.0801  }, // 1444
	{ 743.3147, 1625.3798, 9.2938  }, // 1445
	{ 743.3521, 1613.8137, 9.4830  }, // 1446
	{ 743.3702, 1603.7788, 9.6556  }, // 1447
	{ 743.3485, 1588.8688, 9.9348  }, // 1448
	{ 743.3148, 1577.1904, 10.2055  }, // 1449
	{ 743.2784, 1564.6621, 10.4969  }, // 1450
	{ 743.1673, 1549.6696, 10.8106  }, // 1451
	{ 742.9840, 1537.9020, 11.0393  }, // 1452
	{ 742.7256, 1526.2609, 11.2584  }, // 1453
	{ 742.2932, 1513.7429, 11.5027  }, // 1454
	{ 741.8255, 1502.1606, 11.7215  }, // 1455
	{ 741.1893, 1489.7641, 11.9313  }, // 1456
	{ 740.3065, 1477.2539, 12.1550  }, // 1457
	{ 739.3270, 1465.7053, 12.3425  }, // 1458
	{ 738.1395, 1454.1014, 12.5165  }, // 1459
	{ 736.2068, 1439.3088, 12.7099  }, // 1460
	{ 734.2463, 1427.7921, 12.8421  }, // 1461
	{ 731.7106, 1415.5300, 12.9795  }, // 1462
	{ 728.7814, 1404.1765, 13.0868  }, // 1463
	{ 724.1238, 1390.0131, 13.1824  }, // 1464
	{ 719.4882, 1379.2927, 13.2245  }, // 1465
	{ 713.9959, 1369.2788, 13.2802  }, // 1466
	{ 708.2251, 1361.1005, 13.2951  }, // 1467
	{ 700.5241, 1352.6169, 13.3495  }, // 1468
	{ 692.5469, 1345.1940, 13.3495  }, // 1469
	{ 683.5550, 1337.8356, 13.3495  }, // 1470
	{ 674.2827, 1330.6635, 13.3495  }, // 1471
	{ 664.8273, 1323.8291, 13.3495  }, // 1472
	{ 653.1310, 1315.8763, 13.3495  }, // 1473
	{ 643.2834, 1309.5456, 13.3495  }, // 1474
	{ 633.3645, 1303.3737, 13.3495  }, // 1475
	{ 623.4147, 1297.3940, 13.3495  }, // 1476
	{ 614.7457, 1292.2971, 13.3495  }, // 1477
	{ 604.6293, 1286.3974, 13.3495  }, // 1478
	{ 594.5503, 1280.5600, 13.3642  }, // 1479
	{ 583.6560, 1274.2827, 13.4054  }, // 1480
	{ 570.7019, 1266.8623, 13.5343  }, // 1481
	{ 557.7062, 1259.4318, 13.6958  }, // 1482
	{ 544.7462, 1252.0358, 13.8654  }, // 1483
	{ 534.5930, 1246.2620, 14.0945  }, // 1484
	{ 524.4794, 1240.5458, 14.3696  }, // 1485
	{ 513.4812, 1234.6032, 14.7574  }, // 1486
	{ 504.4584, 1230.1973, 15.1141  }, // 1487
	{ 495.3271, 1226.0201, 15.5139  }, // 1488
	{ 484.3946, 1221.7106, 16.0934  }, // 1489
	{ 474.8882, 1218.5228, 16.6036  }, // 1490
	{ 464.5380, 1215.4184, 17.1954  }, // 1491
	{ 453.1467, 1212.5168, 17.8214  }, // 1492
	{ 441.8171, 1210.1727, 18.4787  }, // 1493
	{ 427.9020, 1207.9062, 19.3300  }, // 1494
	{ 416.3501, 1206.5343, 20.0237  }, // 1495
	{ 406.3796, 1205.6463, 20.6152  }, // 1496
	{ 396.3091, 1205.1584, 21.1414  }, // 1497
	{ 383.0020, 1204.9248, 21.8003  }, // 1498
	{ 371.3619, 1205.1174, 22.3548  }, // 1499
	{ 361.3439, 1205.5300, 22.8225  }, // 1500
	{ 347.3416, 1206.5830, 23.3740  }, // 1501
	{ 337.3711, 1207.6699, 23.6788  }, // 1502
	{ 323.3626, 1209.5234, 23.9913  }, // 1503
	{ 311.8539, 1211.3642, 24.1709  }, // 1504
	{ 297.1821, 1214.1853, 24.2823  }, // 1505
	{ 287.4062, 1216.3769, 24.3205  }, // 1506
	{ 276.0974, 1219.1201, 24.3495  }, // 1507
	{ 263.9979, 1222.3315, 24.3495  }, // 1508
	{ 252.8741, 1225.6599, 24.3495  }, // 1509
	{ 239.3468, 1230.0046, 24.3495  }, // 1510
	{ 228.3233, 1233.8264, 24.3495  }, // 1511
	{ 218.8938, 1237.2705, 24.3495  }, // 1512
	{ 205.6889, 1242.4676, 24.3495  }, // 1513
	{ 196.4358, 1246.3372, 24.3495  }, // 1514
	{ 183.4156, 1251.9482, 24.3495  }, // 1515
	{ 172.7729, 1256.6613, 24.3445  }, // 1516
	{ 162.7416, 1260.9277, 24.2992  }, // 1517
	{ 151.9915, 1265.2321, 24.1545  }, // 1518
	{ 140.9790, 1269.3601, 23.9369  }, // 1519
	{ 129.2157, 1273.3955, 23.5804  }, // 1520
	{ 117.3783, 1277.1057, 23.1442  }, // 1521
	{ 106.1698, 1280.2255, 22.6461  }, // 1522
	{ 96.3672, 1282.6481, 22.1955  }, // 1523
	{ 84.8349, 1285.1567, 21.6681  }, // 1524
	{ 73.3106, 1287.3536, 21.1673  }, // 1525
	{ 60.9440, 1289.2916, 20.6656  }, // 1526
	{ 49.4065, 1290.7213, 20.2642  } // 1527
};

stock IsPosTrainRoad(Float:x, Float:y, Float:z) // Проверяем координаты на наличие жд путей
{
	new yesFind = -1, Float:dist;
	for(new i = 0; i < sizeof(TrainRoad); i++)
	{
		dist = GetDistancePoint(x, y, z, TrainRoad[i][TrainRoad_X], TrainRoad[i][TrainRoad_Y], TrainRoad[i][TrainRoad_Z]);
		if(dist <= 16.0 // Проверяем по радиусу
			&& z <= TrainRoad[i][TrainRoad_Z] + 3  && z >= TrainRoad[i][TrainRoad_Z] - 3) // Проверяем, лежит ли бомба на жд путях
		{
			yesFind = i;
			break;
		}
	}
	return yesFind;
}

stock GetIDTrainOnRoad()
{
	new trainRoadId = -1;
	new Float:train_pos[3], Float:dist;
	GetVehiclePos(train, train_pos[0], train_pos[1], train_pos[2]);

	for(new i = 0; i < sizeof(TrainRoad); i++)
	{
		dist = GetDistancePoint(train_pos[0], train_pos[1], train_pos[2], TrainRoad[i][TrainRoad_X], TrainRoad[i][TrainRoad_Y], TrainRoad[i][TrainRoad_Z]);
		if(dist <= 20.0)
		{
			trainRoadId = i;
			break;
		}
	}
	return trainRoadId;
}


// Запись координат в движении
/*
#define MAX_TRAINROAD_POSITION 2000
new Float:position_trainroad[3][MAX_TRAINROAD_POSITION];
new write_traindroad_id, new_write, export_quan;

CMD:exporttrain(playerid)
{
	if(server != 0) return 0;
	new filename[64], quanWrite, quanLine = 70;
	new min_i = 0, max_i = quanLine;

	for(new e = 0; e < MAX_TRAINROAD_POSITION / quanLine; e++)
    {
		quanWrite = 0;
		format(filename, 64, "ExportTrain%d.txt", export_quan); // Называем файл по дате и времени экспорта

		if(e > 0)
		{
			min_i += quanLine;
			max_i += quanLine;
		}
		
		format(lines,sizeof(lines),""); // Очищаем Lines
		for(new i = min_i; i < max_i; i++)
		{
			if(position_trainroad[0][i] != 0.0)
			{
				// Вносим информацию в строку
				format(line,sizeof(line),"{ %.4f, %.4f, %.4f  }, // %d\r\n",position_trainroad[0][i], position_trainroad[1][i], position_trainroad[2][i], i), strcat(lines,line);
				quanWrite ++;
			}
		}

		if(quanWrite > 0)
		{
			new File:File = fopen(filename, io_write); // Открываем или создаём этот файл
			fwrite(File, lines); // Записываем все строки в файл
			fclose(File); // Закрываем файл

			export_quan ++;
		}
		else 
		{
			SuccessMessage(playerid, "{99ff66}Всё экспортировано в папку scriptfiles");
			break;
		}
	}
	return 1;
}

stock WriteTrainRoad(playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
 	{
		new vehicleid = GetPlayerVehicleID(playerid);
		new model = GetVehicleModel(vehicleid);

		if(model == 537)
		{
			if(new_write == 0) YesWrite(playerid, write_traindroad_id), write_traindroad_id ++, new_write = 1; // Первая запись
			else // Дальше всё время ищем
			{
				new yesOnTrainRoad;
				for(new i = 0; i < MAX_TRAINROAD_POSITION; i++)
				{
					if(IsPlayerInRangeOfPoint(playerid,10.0,position_trainroad[0][i],position_trainroad[1][i],position_trainroad[2][i]))
					{
						yesOnTrainRoad = 1;
						break;
					}
				}
				if(yesOnTrainRoad == 0) YesWrite(playerid, write_traindroad_id), write_traindroad_id ++;
			}
		}
	}
	return 1;
}

stock YesWrite(playerid, id)
{
	if(id >= MAX_TRAINROAD_POSITION) return SendClientMessage(playerid, COLOR_RED, "end");
    GetVehiclePos(train,position_trainroad[0][id],position_trainroad[1][id],position_trainroad[2][id]);

	format(store,sizeof(store),"Write %d [ %f, %f, %f ]", id, position_trainroad[0][id],position_trainroad[1][id],position_trainroad[2][id]);
	SendClientMessage(playerid, COLOR_GREY, store);
	return 1;
}

function MsTimer() // Таймер для записи координат (каждые 50 ms)
{
	WriteTrainRoad(0);
	return 1;
}
*/
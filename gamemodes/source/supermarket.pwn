
new Float:SupermarketItemPos[][] =
{
	{ 1105.087158, -1372.597167, 1401.845336 }, // 0 Парашют
	{ 1101.706665, -1373.357910, 1401.545043 }, // 1 Верёвка
	{ 1101.706665, -1370.817138, 1401.545043 }, // 2 Отмычки
	{ 1111.009155, -1377.957885, 1401.935424 }, // 3 Бенгальские свечи
	{ 1105.085937, -1375.336914, 1401.855346 }, // 4 Бита
	{ 1101.726318, -1376.236572, 1401.855346 }, // 5 Золотое кольцо
	{ 1103.216796, -1369.375610, 1401.855346 }, // 6 Шашка таксиста
	{ 1106.046752, -1369.375610, 1401.855346 }, // 7 Цветы
	{ 1115.489379, -1374.966186, 1401.855346 }, // 8 Подарочная упаковка
	{ 1115.489379, -1372.265869, 1401.855346 }, // 9 Феиерверк
	{ 1121.029907, -1373.405761, 1401.855346 }, // 10 Семена травы
	{ 1121.029907, -1377.447631, 1401.855346 }, // 11 Сигареты
	{ 1121.920776, -1378.028198, 1401.855346 }, // 12 Бокал
	{ 1110.919799, -1372.167480, 1401.855346 }, // 13 Мешок
	{ 1125.142456, -1372.837768, 1401.855346 }, // 14 Хлеб
	{ 1117.922729, -1369.777587, 1401.454956 }, // 15 Шампанское
	{ 1121.273315, -1369.777587, 1401.454956 }, // 16 Пиво
	{ 1110.982055, -1374.947509, 1401.855346 }, // 17 Уголь
	{ 1108.325073, -1378.018188, 1401.935424}, // 18 Зажигалка
	{ 1124.570190, -1378.077636, 1401.935424 }, // 19 Кухонный нож
	{ 1131.505126, -1372.518798, 1402.124633 }, // 20 Свадебный торт
	{ 1103.220092, -1378.248413, 1401.914550 }, // 21 Изолента
	{ 1122.468994, -1372.837768, 1401.855346 },// 22 Баллончик
	{ 1129.744750, -1380.981811, 1401.484130 }, // 23 мясо в упакове
	{ 1118.450805, -1381.694458, 1401.443969 }, // 24 Котелок большой
	{ 1118.450805, -1379.728271, 1401.443969 } // 25 Котелок маленький
};

/* 
	Как добавить новый товар в супермаркет?
	1. Добавить в biz/biz.pwn stock LoadBusinessProduct - следующий предмет
	2. Добавить координату предмета, который лежит где-то на полке в супермаркете: Float:SupermarketItemPos
	3. По необходимости дополнить маппинг супермаркета новыми предметами
*/

new Text3D: BizSM[14][MAX_BIZ_ITEM]; // 3D Текст Продукции Супермаркета

stock UpdateSupermarketLabel_S(b)
{
	new string[120];
	for(new i = 0; i < sizeof(SupermarketItemPos); i++)
	{
		format(string,sizeof(string),"{ff9000}%s {99ff66}[%d$]\n{cccccc}[ ALT ]\n\n{444444}В наличии: %d шт.", GetNameThing(0, BizzInfo[b][bProduct][i], BizzInfo[b][bTypeProduct][i], 0), BizzInfo[b][bPrice][i], BizzInfo[b][bItem][i]);
		UpdateDynamic3DTextLabelText(BizSM[b-13][i],-1, string);
	}
}
stock CreateSupermarketLabel_S(b)
{
	new string[120];
    for(new i = 0; i < sizeof(SupermarketItemPos); i++)
	{
		format(string,sizeof(string),"{ff9000}%s {99ff66}[%d$]\n{cccccc}[ ALT ]\n\n{444444}В наличии: %d шт.", GetNameThing(0, BizzInfo[b][bProduct][i], BizzInfo[b][bTypeProduct][i], 0), BizzInfo[b][bPrice][i], BizzInfo[b][bItem][i]);
		BizSM[b-13][i] = CreateDynamic3DTextLabel(string, -1, SupermarketItemPos[i][0],SupermarketItemPos[i][1],SupermarketItemPos[i][2],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,b-12,206);
	}
}

CMD:supermarket(playerid) // Взять тележку
{
	if(IsPlayerInRangeOfPoint(playerid,2.0,1113.8209,-1384.0480,1401.7142) && GetPlayerInterior(playerid) == 206 && GetPlayerVirtualWorld(playerid) >= 1)
	{
		if(GetPVarInt(playerid,"svzyal") >= 1) return Svalilizsm(playerid);
		if(PPP15[playerid] != 4)
		{
			if(OnlineInfo[playerid][oInHandThing][0] > 0 || Hand[playerid] >= 1 || GetPlayerWeapon(playerid) >= WEAPON:2 || Hold[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}У вас заняты руки [ Предмет или оружие ]");
			new b = GetPlayerVirtualWorld(playerid)+12;
			SetPVarInt(playerid,"sbussines",b);
			SetPVarInt(playerid,"svzyal", 1);
			PPP15[playerid] = 4;
			ApplyAnimation(playerid,"MISC","bmx_idleloop_02",4.1, true, true, true, true, true);
			SetPlayerAttachedObject(playerid, 1, 1349, 1, -0.281999, 1.412000, 0.012000, 87.499938, 85.899978, 4.000003, 1.000000, 1.000000, 1.000000, 0, 0);
		}
	}
	return 1;
}
CMD:buy(playerid) // Покупаем предметы в супермаркете
{
	if(IsPlayerInRangeOfPoint(playerid,1.5,1110.2102,-1380.6837,1401.7142) || IsPlayerInRangeOfPoint(playerid,1.5,1109.0911,-1380.6733,1401.7142)
	|| IsPlayerInRangeOfPoint(playerid,1.5,1104.6500,-1380.7075,1401.7142) || IsPlayerInRangeOfPoint(playerid,1.5,1103.5388,-1380.7046,1401.7142))
	{
		if(PPP15[playerid] == 4)
		{
			if(GetPVarInt(playerid,"svzyal") >= 2)
			{
          		if(oGetPlayerMoney(playerid) < OnlineInfo[playerid][oShopPrice]) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
          		RemovePlayerAttachedObject(playerid,1);
          		PPP15[playerid] = 0;
          		ClearAnimations(playerid);
          		new b = GetPVarInt(playerid,"sbussines");
          		new str[100],sctring[1500], item;
          		format(str,sizeof(str),"{ff9000}Кассовый чек:\n"), strcat(sctring,str);

				for(new i = 0; i < 10; i++)
			    {
			        if(OnlineInfo[playerid][oShopCartsThing][i] > 0)
			        {
			            new bool:noBuy;
			            item = OnlineInfo[playerid][oShopCartsThing][i]-1;
			            
		             	// Обычный
			            if(BizzInfo[b][bTypeProduct][item] == 0)
						{
						    if(CheckThingQuan(BizzInfo[b][bProduct][item]) == 1) // Если предмет имеет количество
			        		{
			        		    new getQuan, getLimit;
								i_limit(playerid, BizzInfo[b][bProduct][item], getQuan, getLimit);
								if(getQuan+GetFullThingQuan(BizzInfo[b][bProduct][item]) > getLimit) noBuy = true; // Если нет места
			        		}
			        		if(noBuy == false)
			        		{
			        		    new put_inva = GiveThingPlayer(playerid, BizzInfo[b][bProduct][item], 0, 0, 0, BizzInfo[b][bTypeProduct][item], 0, 9999); // Выдаём предмет
						    	if(put_inva == -1) noBuy = true; // Если нет места
						    	else format(str,sizeof(str),"\n{cccccc}%s", GetNameThing(0, BizzInfo[b][bProduct][item], BizzInfo[b][bTypeProduct][item], 0)), strcat(sctring,str);
			        		}
						}
						
						// Оружие (Цветы и бита и парашют являются оружием)
						else if(BizzInfo[b][bTypeProduct][item] == 1)
						{
						    new sl = Protect_Slot(BizzInfo[b][bProduct][item]); // Получаем слот оружия
						    if(PlayerInfo[playerid][pBeret] == 1 && BizzInfo[b][bProduct][item] != 46) // Если временное лишение оружия (чел в зелёной зоне) - кроме парашюта, он выдаётся всегда и никогда не отнимается
							{
							    if(TempWeapon[playerid][sl] == BizzInfo[b][bProduct][item] && TempAmmo[playerid][sl] > 0) noBuy = true; // Если такое оружие уже есть в руках
								else
								{
									TempWeapon[playerid][sl] = BizzInfo[b][bProduct][item], TempAmmo[playerid][sl] = 1, TempQet[playerid][sl] = 0;
									format(str,sizeof(str),"\n{cccccc}%s", GetNameThing(0, BizzInfo[b][bProduct][item], BizzInfo[b][bTypeProduct][item], 0)), strcat(sctring,str);
								}
							}
							else // Если нет временного лишения (выдаём в руки)
							{
							    if(ProtectInfo[playerid][prWeapon][sl] == BizzInfo[b][bProduct][item] && ProtectInfo[playerid][prAmmo][sl] > 0) noBuy = true; // Если такое оружие уже есть в руках
								else
								{
									Protect_GiveWeapons(playerid, BizzInfo[b][bProduct][item], 1, 0, 0);
									format(str,sizeof(str),"\n{cccccc}%s", GetNameThing(0, BizzInfo[b][bProduct][item], BizzInfo[b][bTypeProduct][item], 0)), strcat(sctring,str);
								}
							}
						}
						
						if(noBuy)
						{
							if(OnlineInfo[playerid][oShopPrice]-BizzInfo[b][bPrice][item] >= 0) OnlineInfo[playerid][oShopPrice] -= BizzInfo[b][bPrice][item]; // Вычитаем из стоимости, только если не загоним вычет в минуса
						    format(str,sizeof(str),"\n{cccccc}%s {FF6347}Не куплен - нет места", GetNameThing(0, BizzInfo[b][bProduct][item], BizzInfo[b][bTypeProduct][item], 0)), strcat(sctring,str);
						}
						else OnlineInfo[playerid][oShopCartsThing][i] = 0;
			        }
       			}
       			
          		new zaplati = OnlineInfo[playerid][oShopPrice];
          		if(zaplati >= 1)
          		{
	        		oGivePlayerMoney(playerid, -zaplati);
	        		paybiz(b, zaplati);
              		format(str,sizeof(str),"\n\n{cccccc}Вы заплатили: {99ff66}%d$",zaplati), strcat(sctring,str);
         		}
         		else format(str,sizeof(str),"\n\n{cccccc}Вы заплатили: {FF6347}%d$",zaplati), strcat(sctring,str);
            	ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Супермаркет",sctring,"•","");
            	PlayerPlaySound(playerid,6401,0,0,0);
            	if(OnlineInfo[playerid][oListenRadioPears] == 0) PlayAudioStreamForPlayer(playerid,"https://cdn.pears.fun/sound/check.mp3");

            	payanim(playerid, 0); // Анимация оплаты
            	Svalilizsm(playerid); // Очистка переменных супермаркета

            	// Ачивка за первую покупку
            	if(PlayerInfo[playerid][pAchieve][6] == 0) AchievePlayer(playerid, 6, 1);
          	}
          	else ErrorMessage(playerid, "{FF6347}В вашей тележке ничего нет");
        }
        else ErrorMessage(playerid, "{FF6347}Возьмите тележку и кладите в неё покупки");
    }
	return 1;
}
stock Korochepokypau(playerid) // Кладём предмет в тележку
{
	if(GetPlayerVirtualWorld(playerid) <= 0 || GetPlayerVirtualWorld(playerid) >= 15) return 1;
	if(PPP15[playerid] != 4) return ErrorMessage(playerid, "{FF6347}Возьмите тележку возле кассы");

	new b = GetPlayerVirtualWorld(playerid)+12, item = -1;

	for(new i = 0; i < sizeof(SupermarketItemPos); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid,1.5,SupermarketItemPos[i][0],SupermarketItemPos[i][1],SupermarketItemPos[i][2]))
		{
			item = i;
			break;
		}
	}
	if(item == -1) return 1;
    if(BizzInfo[b][bItem][item] <= 0) return ErrorMessage(playerid, "{FF6347}В супермаркете нет этого товара в наличии");
    
	new string[120];
    if(oGetPlayerMoney(playerid) < OnlineInfo[playerid][oShopPrice]+BizzInfo[b][bPrice][item]) return format(string, sizeof(string), "{FF6347}На кассе вам не хватит %d$", OnlineInfo[playerid][oShopPrice]+BizzInfo[b][bPrice][item]-oGetPlayerMoney(playerid)), ErrorMessage(playerid, string);

    new fquan;
    new put_i = putshopcarts(playerid, item, 0, fquan);
    if(put_i == -1) return ErrorMessage(playerid, "{FF6347}В тележке нет места\n{cccccc}Вы можете положить до 10 предметов");
    if(BizzInfo[b][bSost] > 0)
	{
		if(BizzInfo[b][bProduct][item] == 14 || BizzInfo[b][bProduct][item] == 37) BizzInfo[b][bItem][item] -= 10;
		else BizzInfo[b][bItem][item] -= 1;
	}
	BizzInfo[b][bUpdate] = 1;

	SetPVarInt(playerid,"sbussines",b);
	SetPVarInt(playerid,"svzyal",GetPVarInt(playerid,"svzyal")+1);
	PlayerPlaySound(playerid,1052,0,0,0);
	OnlineInfo[playerid][oShopPrice] += BizzInfo[b][bPrice][item];

	format(string, sizeof(string), "кладёт в тележку %s", GetNameThing(0, BizzInfo[b][bProduct][item], BizzInfo[b][bTypeProduct][item], 0)), SetPlayerChatBubble(playerid,string,COLOR_PURPLE,20.0,3000);
	if(PlayerInfo[playerid][pSex] == 1) format(string, sizeof(string), "[ Мысли ]: Я положил в тележку {0088ff}%s {cccccc}[ В тележке: %d шт. ]", GetNameThing(0, BizzInfo[b][bProduct][item], BizzInfo[b][bTypeProduct][item], 0), fquan);
	else format(string, sizeof(string), "[ Мысли ]: Я положила в тележку {0088ff}%s {cccccc}[ В тележке: %d шт. ]", GetNameThing(0, BizzInfo[b][bProduct][item], BizzInfo[b][bTypeProduct][item], 0), fquan);
	SendClientMessage(playerid, COLOR_GREY, string);
	UpdateSupermarketLabel_S(b);
	return 1;
}
stock putshopcarts(playerid, item, stat, &fquan) //  Помещаем предмет в переменные тележки
{
	new put_i = -1;
 	for(new i = 0; i < 10; i++)
    {
        if(OnlineInfo[playerid][oShopCartsThing][i] == item+1)
		{
			if(stat == 1) break;
			fquan ++;
		}
        if(OnlineInfo[playerid][oShopCartsThing][i] == 0)
        {
    		OnlineInfo[playerid][oShopCartsThing][i] = item+1;
    		put_i = i;
    		fquan ++;
    		break;
		}
	}
	return put_i;
}
stock Svalilizsm(playerid) // Удаляем тележку
{
	if(PPP15[playerid] == 4)
	{
		RemovePlayerAttachedObject(playerid,1);
		PPP15[playerid] = 0;
		ClearAnimations(playerid);
		ApplyAnimation(playerid,"PED","facanger",4.1, false, true, true, true, true, SYNC_ALL);
	}
	if(GetPVarInt(playerid,"svzyal") >= 1)
	{
		new b = GetPVarInt(playerid,"sbussines");
		for(new i = 0; i < 10; i++)
	    {
	        if(OnlineInfo[playerid][oShopCartsThing][i] > 0) 
			{	
				if(BizzInfo[b][bProduct][OnlineInfo[playerid][oShopCartsThing][i]-1] == 14 || BizzInfo[b][bProduct][OnlineInfo[playerid][oShopCartsThing][i]-1] == 37) BizzInfo[b][bItem][OnlineInfo[playerid][oShopCartsThing][i]-1] -= 10;
				else BizzInfo[b][bItem][OnlineInfo[playerid][oShopCartsThing][i]-1] -= 1;
				OnlineInfo[playerid][oShopCartsThing][i] = 0;
			}
     	}
     	OnlineInfo[playerid][oShopPrice] = 0;
		SetPVarInt(playerid,"svzyal",0);
		BizzInfo[b][bUpdate] = 1;
		UpdateSupermarketLabel_S(b);
		SetPVarInt(playerid,"sbussines",0);
	}
	return 1;
}
stock addiction(playerid, item)
{
    new b = GetPlayerVirtualWorld(playerid)+12;
    if(b >= 13 && b <= 26) // Если в интерьере одного из супермаркете
    {
        if(BizzInfo[b][bItem][item] <= 0) return 1;

	    if(oGetPlayerMoney(playerid) < OnlineInfo[playerid][oShopPrice]+BizzInfo[b][bPrice][item]) return 1;
	    if(get_invent4(playerid, BizzInfo[b][bProduct][item], BizzInfo[b][bTypeProduct][item]) >= 1) return 1;
	    
	    
	    if(BizzInfo[b][bTypeProduct][item] == 0)
		{
		    if(CheckThingQuan(BizzInfo[b][bProduct][item]) == 1) // Если предмет имеет количество
    		{
    		    new getQuan, getLimit;
				i_limit(playerid, BizzInfo[b][bProduct][item], getQuan, getLimit);
				if(getQuan+GetFullThingQuan(BizzInfo[b][bProduct][item]) > getLimit) return 1;
    		}
  		}

	    new fquan;
	    new put_i = putshopcarts(playerid, item, 1, fquan);
	    if(put_i == -1) return 1;
	    if(BizzInfo[b][bSost] > 0) 
		{
			if(BizzInfo[b][bProduct][item] == 14 || BizzInfo[b][bProduct][item] == 37) BizzInfo[b][bItem][item] -= 10;
			else BizzInfo[b][bItem][item] -= 1;
		}
		BizzInfo[b][bUpdate] = 1;

		SetPVarInt(playerid,"sbussines",b);
		SetPVarInt(playerid,"svzyal",GetPVarInt(playerid,"svzyal")+1);
		PlayerPlaySound(playerid,1052,0,0,0);
		OnlineInfo[playerid][oShopPrice] += BizzInfo[b][bPrice][item];

		new string[120];
		format(string, sizeof(string), "кладёт в тележку %s", GetNameThing(0, BizzInfo[b][bProduct][item], BizzInfo[b][bTypeProduct][item], 0)), SetPlayerChatBubble(playerid,string,COLOR_PURPLE,20.0,3000);
		if(PlayerInfo[playerid][pSex] == 1) format(string, sizeof(string), "[ Мысли ]: Я положил в тележку {0088ff}%s {FF6347}[ Кажется, у меня зависимость ]", GetNameThing(0, BizzInfo[b][bProduct][item], BizzInfo[b][bTypeProduct][item], 0));
		else format(string, sizeof(string), "[ Мысли ]: Я положила в тележку {0088ff}%s {FF6347}[ Кажется, у меня зависимость ]", GetNameThing(0, BizzInfo[b][bProduct][item], BizzInfo[b][bTypeProduct][item], 0));
		SendClientMessage(playerid, COLOR_GREY, string);
		UpdateSupermarketLabel_S(b);
    }
 	return 1;
}

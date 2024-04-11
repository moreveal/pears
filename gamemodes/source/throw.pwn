stock showthrow(playerid)
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || howstun(playerid)) return 1;
	i_tabs(playerid, 3, 1);
	Pagetwo[playerid] = 0;
	for(new t = 0; t < 20; t++) MyThrow[t][playerid] = -1;
	new plus;
	for(new t = 0; t < MAX_THROW; t++)
	{
		if(ThrowInfo[t][tId] == 0) continue;
		if(IsPlayerInRangeOfPoint(playerid,3.0,ThrowInfo[t][tX],ThrowInfo[t][tY],ThrowInfo[t][tZ]) && GetPlayerVirtualWorld(playerid) == ThrowInfo[t][tWorld] && GetPlayerInterior(playerid) == ThrowInfo[t][tInt])
		{
			if(plus <= 19)
			{
				MyThrow[plus][playerid] = t;
				plus ++;
			}
		}
	}
	for(new inva = 0; inva < 20; inva++)
	{
		if(MyThrow[inva][playerid] >= 0) item_second(playerid, ThrowInfo[MyThrow[inva][playerid]][tId], ThrowInfo[MyThrow[inva][playerid]][tQuan], inva, 2, ThrowInfo[MyThrow[inva][playerid]][tPara], ThrowInfo[MyThrow[inva][playerid]][tType], ThrowInfo[MyThrow[inva][playerid]][tPack], ThrowInfo[MyThrow[inva][playerid]][tPlayerid]);
		else item_second(playerid, 0, 0, inva, 2, 0, 0, 0, 0);
	}
	return 1;
}
stock use_throw(playerid, inva, useinva)
{
    if(IsPlayerInAnyVehicle(playerid)) return ErrorMessage(playerid, "{FF6347}Вы в транспорте");
    new t = MyThrow[inva][playerid];
    if(t <= -1) return i_resettabs(playerid);
    new fpick = ThrowInfo[t][tId], fquan = ThrowInfo[t][tQuan], thingPara = ThrowInfo[t][tPara], thingQara = ThrowInfo[t][tQara], thingType = ThrowInfo[t][tType], thingPack = ThrowInfo[t][tPack];
    
    if(fpick == 0) return i_resettabs(playerid);
	if(useinva != 9999)
	{
 		if(PlayerInfo[playerid][pInven][useinva] != fpick && PlayerInfo[playerid][pInven][useinva] != 0) return i_resettabs(playerid);
	}
	if(GetPVarInt(playerid,"svzyal") >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя подбирать предметы во время покупок в супермаркете");
	if(thingPack == 2 || thingPack == 4) // Ящик с предметом
	{
	    if(SitPlayer[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Вы не можете взять этот предмет сидя");
	    if(OnlineInfo[playerid][oInHandThing][0] > 0 || Hand[playerid] >= 1 || Hold[playerid] >= 1 || GetPlayerWeapon(playerid) >= WEAPON:2) return ErrorMessage(playerid, "{FF6347}У вас заняты руки [ Предмет или оружие ]");

		GiveThingHand(playerid, fpick, fquan, thingPara, thingQara, thingType, thingPack);

		ApplyAnimation(playerid,"CARRY","liftup",4.1, false, true, true, true, true); // Анимация поднять предмет
		DestroyThrow(t);
		updatethrowall(t);
		
        PPP15[playerid] = 3; // Повторение анимации рук перед лицом
        RemovePlayerAttachedObject(playerid,1); // Удаляем прежний прикреплённый объект
       	SetPlayerAttachedObject(playerid, 1, 3014, 6, 0.120000, 0.199448, -0.120000, 254.000000, 0.900000, 70.000000); // Создаём ящик в руках
		i_resetveshi(playerid);
		i_resettabs(playerid);
		Veshi[playerid] = 0;
		return 1;
	}
	else if(thingPack == 3) // Мешок с предметом (Вешается на спину)
	{
	    if(SitPlayer[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Вы не можете взять этот предмет сидя");
	    if(OnlineInfo[playerid][oOnBackThing][0] > 0) return ErrorMessage(playerid, "{FF6347}У вас на спине уже есть сумка или мешок");

        OnlineInfo[playerid][oOnBackThing][0] = fpick; // ID Предмета
        OnlineInfo[playerid][oOnBackThing][1] = fquan; // Количество
        OnlineInfo[playerid][oOnBackThing][2] = thingPara; // Условности особые
        OnlineInfo[playerid][oOnBackThing][3] = thingQara; // Статус краденного
        OnlineInfo[playerid][oOnBackThing][4] = thingType; // Тип предмета
        OnlineInfo[playerid][oOnBackThing][5] = thingPack; // Упаковка Мешок

		ApplyAnimation(playerid,"CARRY","liftup",4.1, false, true, true, true, true); // Анимация поднять предмет
		DestroyThrow(t);
		updatethrowall(t);

        PPP15[playerid] = 3; // Повторение анимации рук перед лицом
        RemovePlayerAttachedObject(playerid,2); // Удаляем прежний прикреплённый объект
        SetPlayerAttachedObject(playerid, 2, 2060, 1, 0.076999, -0.155999, 0.000000, 91.999961, 0.000000, 0.000000, 0.610000, 0.649999, 0.664000, 0, 0); // Вешаем мешок на спину
		i_resetveshi(playerid);
		i_resettabs(playerid);
		Veshi[playerid] = 0;
		return 1;
	}
	
	// Проверка на наличие особых аксессуаров (Каска и Броня)
	if(IsArmor(fpick) && thingType == 2 && PlayerInfo[playerid][pArmor] >= 1) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет\n\n{cccccc}Учитывается надетая броня");

    if(JustOneThingInventory(fpick, thingType) && get_invent(playerid, fpick, thingType) > 0)
	{
		if(fpick >= 128 && fpick <= 138 || fpick == 42) // Если предметы с взаимодействием
		{
			if(ThrowInfo[t][tPutLocation] == 0) return ErrorMessage(playerid, "{FF6347}Этот предмет лежит на полу и он уже есть в вашем инвентаре\n{ffcc66}Если вы хотите начать взаимодействие с предметом, положите его на стол\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров");
		}
		else return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров");
	}
	
	new string[180];
	if(thingType == 0 && thingPack == 0) // Обычный предмет
	{
	    if(CheckThingQuan(fpick) == 1) // Предмет имеет количество
		{
		    DP[0][playerid] = inva;
			Veshi[playerid] = OnlineInfo[playerid][oInventSelectRight];
			format(string,sizeof(string),"{cccccc}Чтобы взять {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(0, fpick, thingType, thingPack));
			ShowDialog(playerid,1094,DIALOG_STYLE_INPUT,"{ff9000}Выброшено",string,"Принять","Отмена");
			return 1;
		}
	}
	if(ThrowInfo[t][tBombPlant] == true)
	{
		if(ThrowInfo[t][tPlayerid] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid, "{FF6347}Вы не можете поднять активированную бомбу");
	} 
    i_resetveshi(playerid);
	i_resettabs(playerid);
	Veshi[playerid] = 0;
	
	// Если предмет лежит на столе (Бутылка в руки)
	if(ThrowInfo[t][tPutLocation] == 1 && (fpick >= 112 && fpick <= 121 || fpick == 14 || fpick == 37) && thingPack == 0)
	{
		if(Hand[playerid] >= 1 || Hold[playerid] >= 1 || GetPlayerWeapon(playerid) >= WEAPON:2 || OnlineInfo[playerid][oInHandThing][0] > 0) return ErrorMessage(playerid, "{FF6347}У вас заняты руки [Предмет, действие или оружие]");
	}

	// Отрезаем Кусочек Торта
	if(fpick == 163 || fpick == 166 && thingType == 0 && thingPack == 0 && Hold[playerid] == 14 && HoldFrisk[playerid] == 97)
	{
		new put_inva = GiveThingPlayer(playerid, fpick+1, 3, ThrowInfo[t][tPara], ThrowInfo[t][tQara], ThrowInfo[t][tType], ThrowInfo[t][tPack], useinva); // 164 торт, 3 количество кусь
		if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");
		Hold[playerid] = 0, HoldFrisk[playerid] = 0, HoldStat[playerid] = 0, HoldQuan[playerid] = 0, HoldInva[playerid] = 0, HoldPara[playerid] = 0, HoldQara[playerid] = 0;
		if(fpick == 163)
		{
			SetPlayerChatBubble(playerid,"отрезает кусочек торта",COLOR_PURPLE,20.0,3000);
		}
		else if(fpick == 166)
		{
			SetPlayerChatBubble(playerid,"отрезает кусочек пиццы",COLOR_PURPLE,20.0,3000);
		}
		ApplyAnimation(playerid,"OTB","betslp_loop",4.0, false, true, true, false, false);
		RemovePlayerAttachedObject(playerid,1);
		in_hand_eat(playerid, 3, fpick+1, fpick+1, 3, put_inva, ThrowInfo[t][tPara], ThrowInfo[t][tQara], ThrowInfo[t][tNoinvent]); // Выдаём сразу в руки
	    PlayerPlaySound(playerid,5600,0,0,0);
	    ThrowInfo[t][tQuan] -= 1;
	    if(ThrowInfo[t][tQuan] <= 1)
		{
			DestroyThrow(t);
			updatethrowall(t);
		}
	    return 1;
	}

	// Взаимодействие с Подносом еды или Ноутбуком
	if((fpick >= 128 && fpick <= 138 || fpick == 42) && thingType == 0 && thingPack == 0)
	{
	    if(ThrowInfo[t][tUseplayer] > 0 && ThrowInfo[t][tUseplayer] != playerid+1) return format(string,sizeof(string),"{FF6347}С этим предметом взаимодействует %s",PlayerInfo[ThrowInfo[t][tUseplayer]-1][pName]), ErrorMessage(playerid, string);
		if(playerSeat[playerid])
		{
		    if(!IsPlayerInRangeOfPoint(playerid,2.0,ThrowInfo[t][tX],ThrowInfo[t][tY],ThrowInfo[t][tZ])) return ErrorMessage(playerid, "{FF6347}Этот предмет слишком далеко");
		    if(ThrowInfo[t][tPutLocation] == 0) return ErrorMessage(playerid, "{FF6347}Этот предмет лежит на полу [ Чтобы взаимодействовать - поставте его на стол ]");
		    if(Hand[playerid] >= 1 || Hold[playerid] >= 1 && Hold[playerid] != 13 || GetPlayerWeapon(playerid) >= WEAPON:2 || OnlineInfo[playerid][oInHandThing][0] > 0) return ErrorMessage(playerid, "{FF6347}У вас заняты руки [Предмет, действие или оружие]");
			if(Hold[playerid] == 13)
			{
			    if(ThrowInfo[t][tId] > 0 && HoldFrisk[playerid] == ThrowInfo[t][tId] && ThrowInfo[t][tUseplayer] > 0 && ThrowInfo[t][tUseplayer] == playerid+1) ThrowInfo[t][tUseplayer] = 0;
				Hold[playerid] = 0, HoldStat[playerid] = 0, HoldFrisk[playerid] = 0;
				ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}•","{ffcc66}Вы завершили взаимодействие с предметом","•","");
				TextDrawShowForPlayer(playerid, MindDraw[3]), PlayerTextDrawSetString(playerid, HintButton, "ENTER"), PlayerTextDrawShow(playerid, HintButton);
			}
			else
			{
			    Hold[playerid] = 13, HoldFrisk[playerid] = fpick, HoldQuan[playerid] = fquan, HoldStat[playerid] = t, ThrowInfo[t][tUseplayer] = playerid+1;
			    if(fpick >= 128 && fpick <= 138) format(string,sizeof(string),"{ffcc66}Вы начали взаимодействие с предметом: %s (%d кусков)\nЗакройте инвентарь (ESC), чтобы начать кушать {ff9000}[ Кушать: %s ]", friskName[fpick], fquan-1, buttonName[Device[playerid]]);
				else format(string,sizeof(string),"{ffcc66}Вы начали взаимодействие с предметом: %s\nЗакройте инвентарь (ESC), чтобы использовать предмет {ff9000}[ Использовать: %s ]", friskName[fpick], buttonName[Device[playerid]]);
    			ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}•",string,"•","");
				TextDrawShowForPlayer(playerid, MindDraw[3]);
				if(Device[playerid] == 0) PlayerTextDrawSetString(playerid, HintButton, "RMB");
				else if(Device[playerid] == 1) PlayerTextDrawSetString(playerid, HintButton, "H");
				PlayerTextDrawShow(playerid, HintButton);
			}
			return 1;
		}
		if(ThrowInfo[t][tPutLocation] == 1 && ThrowInfo[t][tPlayerid] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid, "{FF6347}Этот предмет поставил другой человек"), i_resettabs(playerid);
	}

	// Берём предмет (Выдаём в инвентарь или в руки)
	if(ThrowInfo[t][tPutLocation] == 0 && NoAnim[playerid] == 0) ApplyAnimation(playerid,"CARRY","liftup05",4.0, false, true, true, false, false); // Предмет лежал на земле
	else if(ThrowInfo[t][tPutLocation] == 1 && NoAnim[playerid] == 0) ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0, false, true, true, false, false); // Предмет лежал на столе
	
	new yesinva = -1;
	if(ThrowInfo[t][tNoinvent] == 0) // Предмет может оказатсья в инвентаре
	{
	    if(thingType == 0)
		{
		    if(CheckThingQuan(fpick) == 1)
			{
				new getQuan, getLimit;
	    		i_limit(playerid, fpick, getQuan, getLimit);
	    		if(getQuan+fquan > getLimit) return format(string,sizeof(string),"{FF6347}У вас нет места в инвентаре\nЛимит для этого предмета: %d\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров", getLimit), ErrorMessage(playerid, string);
	 		}
		}
	
	    new tort_quan;
		if(fpick == 38 || fpick == 122 || fpick == 123) tort_quan = 1; // Бокалы и Кружки
		else if(fpick == 11) // Обезевреживаем бомбу, когда берём её с земли
		{
			if(ThrowInfo[t][tPara] > 0) ThrowInfo[t][tPara] = 0, ThrowInfo[t][tQara] = 0;
		}
		else tort_quan = fquan;

		yesinva = GiveThingPlayer(playerid, fpick, tort_quan, ThrowInfo[t][tPara], ThrowInfo[t][tQara], ThrowInfo[t][tType], ThrowInfo[t][tPack], useinva);

		if(ThrowInfo[t][tPutLocation] == 1 && fpick >= 112 && fpick <= 121 || fpick == 14 || fpick == 37) in_hand_eat(playerid, 3, fpick, fpick, fquan, yesinva, ThrowInfo[t][tPara], ThrowInfo[t][tQara], ThrowInfo[t][tNoinvent]);

		format(string,sizeof(string),"[ID %d] Взял: %s",t,GetNameThing(1, fpick, thingType, thingPack));
		UserLog("took", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], ThrowInfo[t][tPlayerid], ThrowInfo[t][tName], ThrowInfo[t][tIP], fquan, string);
	}
	if(fpick == 38 || fpick == 122 || fpick == 123)
	{
		if(fpick != ThrowInfo[t][tModel]) in_hand_eat(playerid, 2, fpick, ThrowInfo[t][tModel], fquan, yesinva, ThrowInfo[t][tPara], ThrowInfo[t][tQara], ThrowInfo[t][tNoinvent]);
	}
	if(fpick >= 128 && fpick <= 138) in_hand_podnos(playerid, fpick, fquan, ThrowInfo[t][tPara], ThrowInfo[t][tQara]);
	DestroyThrow(t);
	updatethrowall(t);
	around_player_audio(playerid, 5601, 0, 5.0, 0);
	return 1;
}
stock Throw(playerid, fpick, quan, para, qara, thingType, thingPack, DopParametr = 0) // Кладём предмет на землю
{
	if(fpick == 34 && thingType == 1 && thingPack >= 1) { } // Исключим падение снайперки, которая в упаковке
	else
	{
		if(NotGiveThing(fpick, thingType, quan)) return 1; // Предметы которые нельзя передавать или выбрасывать
	}
	if(throwkol >= 1000) return 1;
	throwkol ++;
	new Float:X, Float:Y, Float:Z,Float:A, Float:herx, Float:hery;
	switch(random(8))
 	{
		case 0: herx = 0.1, hery = 0.1;
		case 1: herx = 0.2, hery = 0.2;
		case 2: herx = -0.1, hery = -0.1;
		case 3: herx = -0.2, hery = -0.2;
		case 4: herx = 0.3, hery = 0.3;
		case 5: herx = 0.4, hery = 0.4;
		case 6: herx = -0.3, hery = -0.3;
		case 7: herx = -0.4, hery = -0.4;
	}
 	GetPlayerPos(playerid, X, Y, Z), GetPlayerFacingAngle(playerid,A);
 	X=X+0.8*floatsin(-A,degrees);
  	Y=Y+0.8*floatcos(-A,degrees);

	// Ставим бомбу
	if(fpick == 11 && thingType == 0 && thingPack == 0 && para >= 10)
	{
		/*new roadId = IsPosTrainRoad(X+herx, Y+hery, Z-0.8);
		if(roadId >= 0) 
		{
			qara = roadId + 1;
			if(!CheckTrainNearby(playerid, roadId, para)) return 0;
		}*/
	}

  	if(thingPack > 0) SetThrow(playerid, fpick, fpick, quan, para, qara, thingType, thingPack, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), X+herx, Y+hery, Z-0.8, 0.0, 0.0, A, 600, 0, 0, DopParametr);
  	else
  	{
  	    if(thingType == 0)
		{
		    if(CheckThingQuan(fpick) == 1) return GiveThrow(playerid, fpick, fpick, quan, para, qara, thingType, thingPack, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), X+herx, Y+hery, Z-0.8, A, 600);
		}
		SetThrow(playerid, fpick, fpick, quan, para, qara, thingType, thingPack, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), X+herx, Y+hery, Z-0.8, 0.0, 0.0, A, 600, 0, 0, DopParametr);
  	}
 	return 1;
}
stock GiveThrow(playerid, fpick, frisk, quan, para, qara, thingType, thingPack, world, interior, Float:x, Float:y, Float:z, Float:rz, time) // Добавляем предмет, если количественный и такой уже есть
{
	new noobject, gee, Float:dist;
	for(new g = 0; g < MAX_THROW; g++)
	{
		if(ThrowInfo[g][tId] == fpick && ThrowInfo[g][tType] == thingType && ThrowInfo[g][tWorld] == world && ThrowInfo[g][tInt] == interior)
		{
			dist = GetDistancePoint(x,y,z, ThrowInfo[g][tX],ThrowInfo[g][tY],ThrowInfo[g][tZ]);
		    if(dist <= 3.0)
			{
				ThrowInfo[g][tQuan] += quan;
				ThrowInfo[g][tPara] = para;
				ThrowInfo[g][tQara] = qara;
				ThrowInfo[g][tTime] = 600; // Удалится через 10 минут
				ThrowInfo[g][tType] = thingType;
				ThrowInfo[g][tPack] = thingPack;

				new string[60];
			    format(string,sizeof(string),"[tID %d] Оставил: %s",g, GetNameThing(1, fpick, thingType, thingPack));
			    UserLog("throw", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", quan, string);
				noobject = 1, gee = g;
				break;
			}
		}
	}
	if(noobject == 1) updatethrowall(gee);
	else if(noobject == 0) SetThrow(playerid, fpick, frisk, quan, para, qara, thingType, thingPack, world, interior, x, y, z, 0.0, 0.0, rz, time, 0, 0);
	return 1;
}
stock SetThrow(playerid, fpick, frisk, quan, para, qara, thingType, thingPack, world, interior, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, time, type, noinvent, DopParametr = 0) // Устанавливаем новый предмет на землю
{
	new noobject, gee;
	if(fpick >= 128 && fpick <= 138 && thingType == 0) time = 1200;
	if(fpick == 11 && thingType == 0) time = 1200;
	if(fpick == 42 && type == 1) time = -1;
	for(new g = 0; g < MAX_THROW; g++)
	{
		if(ThrowInfo[g][tId] == 0)
		{
			ThrowInfo[g][tId] = fpick;
			ThrowInfo[g][tModel] = frisk;
			ThrowInfo[g][tQuan] = quan;
			ThrowInfo[g][tPara] = para;
			ThrowInfo[g][tQara] = qara;
			ThrowInfo[g][tX] = x;
		 	ThrowInfo[g][tY] = y;
		 	ThrowInfo[g][tZ] = z;
		 	ThrowInfo[g][tRX] = rx;
		 	ThrowInfo[g][tRY] = ry;
		 	ThrowInfo[g][tRZ] = rz;
		 	ThrowInfo[g][tWorld] = world;
			ThrowInfo[g][tInt] = interior;
			ThrowInfo[g][tTime] = time;
			ThrowInfo[g][tPutLocation] = type;
			ThrowInfo[g][tNoinvent] = noinvent;
			ThrowInfo[g][tUseplayer] = 0;
			ThrowInfo[g][tType] = thingType;
			ThrowInfo[g][tPack] = thingPack;
			if((fpick == 11 || fpick == 205) && para >= 9) ThrowInfo[g][tBombPlant] = true;
			if(fpick == 205) ThrowInfo[g][tOpenVehicleBomp] = DopParametr;

			if(playerid != -1)
			{
			    ThrowInfo[g][tPlayerid] = PlayerInfo[playerid][pID];
			    format(ThrowInfo[g][tName],24,"%s",PlayerInfo[playerid][pName]);
			    format(ThrowInfo[g][tIP],24,"%s",PlayerInfo[playerid][pPlaIP]);

				new string[80];
			    if(fpick != frisk) format(string,sizeof(string),"[tID %d] Оставил: %s (%s)",g,GetNameThing(1, fpick, thingType, thingPack),GetNameThing(1, frisk, thingType, thingPack));
			    else format(string,sizeof(string),"[tID %d] Оставил: %s", g, GetNameThing(1, fpick, thingType, thingPack));
			    UserLog("throw", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", quan, string);
			}
			else if(playerid == -1) ThrowInfo[g][tPlayerid] = 0, format(ThrowInfo[g][tName], 24, "\0"), format(ThrowInfo[g][tIP], 24, "\0");
			noobject = 1, gee = g;
			break;
		}
	}
	if(noobject == 1) updatethrowall(gee), ObjectThrow(playerid, gee);
	return 1;
}
stock DestroyThrow(t) // Удаляем предмет с земли
{
 	if(ThrowInfo[t][tObjectStat] == 1) ThrowInfo[t][tObjectStat] = 0, DestroyDynamicObject(ThrowInfo[t][tObject]);
	ThrowInfo[t][tBombPlant] = false;
	ThrowInfo[t][tOpenVehicleBomp] = 0;
 	ThrowInfo[t][tUseplayer] = 0;
	ThrowInfo[t][tId] = 0, ThrowInfo[t][tQuan] = 0, ThrowInfo[t][tPara] = 0, ThrowInfo[t][tQara] = 0, ThrowInfo[t][tType] = 0, ThrowInfo[t][tPack] = 0, throwkol --;
	return 1;
}
stock updatethrowall(t) // Обновляем отображение выброшенных предметов всем, кто смотрит рядом
{
	foreach(Player,i)
	{
		if(OnlineInfo[i][oLogged] == 0) continue;
		if(OnlineInfo[i][oShowInterface] != 1) continue;
		if(Tabs_Load[i] != 7) continue;
		if(IsPlayerInRangeOfPoint(i,3.0,ThrowInfo[t][tX],ThrowInfo[t][tY],ThrowInfo[t][tZ]) && GetPlayerVirtualWorld(i) == ThrowInfo[t][tWorld] && GetPlayerInterior(i) == ThrowInfo[t][tInt]) showthrow(i);
	}
	return 1;
}
stock ObjectThrow(playerid, t) // Получаем id объекта на земле
{
	new model, setgift, fpick = ThrowInfo[t][tId], fpara = ThrowInfo[t][tPara], thingType = ThrowInfo[t][tType], thingPack = ThrowInfo[t][tPack];
	if(fpick == 0) return 1;
	if(playerid != -1)
	{
		if(thingPack == 2 || thingPack == 4)
		{
			RemovePlayerAttachedObject(playerid, 1);
			PPP15[playerid] = 0;
			SetPlayerChatBubble(playerid,"роняет ящик",COLOR_PURPLE,20.0,3000);
			InHandClear(playerid);
		}
		if(NoAnim[playerid] == 0) ApplyAnimation(playerid,"CARRY","putdwn",4.0, false, false, false, false, false);
	}
	if(thingPack == 1) model = 3014, setgift = 1; // Подарок
	else if(thingPack == 2 || thingPack == 4)  model = 3014; // Ящик
	else if(thingPack == 5)  model = 19918; // Кейс
	else
	{
	    if(thingType == 0) // Основные предметы
	    {
	    	model = friskPick[fpick];
			if(fpick == 4) model = 1578;
			else if(fpick == 5) model = 1577;
			else if(fpick == 6) model = 1576;
			// экстази: 1579
			else if(fpick == 39) model = 19921, setgift = 2; // Упаковка
			else if(fpick == 45) model = 3017; // Карта Моряка
			else if(fpick == 48) model = 1575; // Надувная Лодка
			else if(fpick == 91) model = 3017; // Карта Сокровищ
	    }
	    else if(thingType == 1) // Оружие
	    {
		    if(fpara <= 0) // Изношенное оружие в хлам
		    {
				new weaponType = WeaponAmmoType(fpick);
				if(weaponType == 1) model = 2034; // Дробовики
				else if(weaponType == 2) model = 2034; // Пистолеты
				else if(weaponType == 3) model = 2044; // Пистолеты-Пулемёты
				else if(weaponType == 4) model = 2035; // Автомат
				else if(weaponType == 5) model = 2036; // Дробовик
				else model = friskGun[fpick];
		    }
		    else model = friskGun[fpick];
	    }
	    else if(thingType == 2) model = fpick; // Аксессуар
	    else if(thingType == 3) model = 2844; // Одежда
	    else if(thingType == 4) model = 2912; // Мебель
	}
	ThrowInfo[t][tObjectStat] = 1;
 	ThrowInfo[t][tObject] = CreateDynamicObject(model, ThrowInfo[t][tX], ThrowInfo[t][tY], ThrowInfo[t][tZ], ThrowInfo[t][tRX], ThrowInfo[t][tRY], ThrowInfo[t][tRZ], ThrowInfo[t][tWorld], ThrowInfo[t][tInt], -1, 30.00, 30.00);
 	if(setgift == 1)
 	{
 		SetDynamicObjectMaterial(ThrowInfo[t][tObject], 0, 19058, "xmasboxes", "wrappingpaper20", 0x00000000);
		SetDynamicObjectMaterial(ThrowInfo[t][tObject], 1, 19058, "xmasboxes", "wrappingpaper4-2", 0x00000000);
 	}
	else if(setgift == 1)
 	{
		SetDynamicObjectMaterial(ThrowInfo[t][tObject], 0, 19058, "xmasboxes", "wrappingpaper20", 0x00000000);
		SetDynamicObjectMaterial(ThrowInfo[t][tObject], 1, 19058, "xmasboxes", "silk9-128x128", 0x00000000);
 	}
 	if(playerid != -1) Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
 	return 1;
}

stock use_boot(playerid, v, inva, useinva)
{
 	if(!IsABoot(v)) return closetab(playerid, 1);
	if(!GetVehicleNear_Boot(playerid, v)) return closetab(playerid, 1);

	if((VehInfo[v][vSost] == PlayerInfo[playerid][pID] || VehInfo[v][vKey] == PlayerInfo[playerid][pID] && VehInfo[v][vKeyUnix] > gettime()) && GetPlayerVip(playerid) > 0) {}
	else
	{
		if(VehInfo[v][vCarLock] >= 1) return closetab(playerid, 1);
	}

 	new fpick = VehInfo[v][vInvent][inva], fquan = VehInfo[v][vInv][inva], thingPara = VehInfo[v][vInvPara][inva], thingQara = VehInfo[v][vInvQara][inva], thingType = VehInfo[v][vInvType][inva], thingPack = VehInfo[v][vInvPack][inva];
 	if(useinva != 9999)
	{
 		if(PlayerInfo[playerid][pInven][useinva] != VehInfo[v][vInvent][inva] && PlayerInfo[playerid][pInven][useinva] != 0) return i_resettabs(playerid);
	}
	if(fpick == 0) return 1;
	
	if(thingType == 4) return ErrorMessage(playerid, "{FF6347}Вы не можете взять мебель в руки или в инвентарь\n\nМебель можно перекладывать только в дом или в бизнес"), i_resettabs(playerid);
	if(thingPack == 2 || thingPack == 4) // Если это ящик
	{
	    TakeBootBox(playerid, v, inva, 0);
		if(OnlineInfo[playerid][oShowInterface] == 1) CloseFrisk(playerid), CancelSelectTextDraw(playerid);
	    return 1;
	}
	else if(thingType == 0 && thingPack == 0)
	{
	    if(CheckThingQuan(fpick) == 1)
		{
		    DP[0][playerid] = inva;
		    format(store,sizeof(store),"{cccccc}Чтобы взять {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(0, fpick, thingType, thingPack));
			ShowDialog(playerid,896,DIALOG_STYLE_INPUT,"{ff9000}Багажник",store,"Принять","Отмена");
			return 1;
		}
		if(fpick == 35) // Человек в багажнике
		{
		    new para1 = get_boot(v, 35);
		    if(IsOnline(para1))
		    {
	    		format(store, sizeof(store), "вытаскивает из багажника %s", playername(para1));
				SetPlayerChatBubble(playerid,store,COLOR_PURPLE,20.0,5000);
				format(store, sizeof(store), "* %s вытаскивает из багажника %s", playername(playerid), playername(para1));
				ProxDetector(20.0, playerid, store, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	    		GameTextForPlayer(para1, RusToGame("~g~Вас вытащили из багажника"), 7000, 4);
	    		EjectBoot(para1, v);
		    }
		    else ErrorMessage(playerid, "{FF6347}Ошибка! В багажнике никого нет"), TakeBoot(v, fpick, fquan, thingType, inva), VehInfo[v][vPeople] = 0;
			i_resettabs(playerid);
			return 1;
		}
	}
	
	i_resettabs(playerid);
	i_resetveshi(playerid);
	// Проверка на наличие особых аксессуаров (Броня)
	if(IsArmor(fpick) && thingType == 2 && PlayerInfo[playerid][pArmor] >= 1) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет\n\n{cccccc}Учитывается надетая броня");

	// Проверка на одиночный предмет
	if(JustOneThingInventory(fpick, thingType) && get_invent(playerid, fpick, thingType) > 0) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров");
	
	if(thingType == 0)
	{
	    if(CheckThingQuan(fpick) == 1)
		{
			new getQuan, getLimit;
    		i_limit(playerid, fpick, getQuan, getLimit);
    		if(getQuan+fquan > getLimit) return format(store,sizeof(store),"{FF6347}У вас нет места в инвентаре\nЛимит для этого предмета: %d\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров", getLimit), ErrorMessage(playerid, store);
 		}
	}

	new put_inva = GiveThingPlayer(playerid, fpick, fquan, thingPara, thingQara, thingType, thingPack, useinva);
	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У меня нет места в инвентаре"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
    TakeBoot(v, fpick, fquan, thingType, inva);

    SaveInvent(playerid, put_inva); // Сохраняем то, что игрок взял

    format(store,sizeof(store),"Взял из %s: %s", GetVehicleName(VehInfo[v][vModel]), GetNameThing(1, fpick, thingType, thingPack));
	UserLog("getboot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fquan, store);


	// Квест ремонт транспорта
	if(NoCompleteQuest(playerid, 4) && fpick == 183 && IsACar(VehInfo[v][vModel]) && VehInfo[v][vHealth] <= 400.0)
	{
		PlayAudioStreamForPlayer(playerid, "https://pears-test.ru/sound/characters/jone/jone_repair3.mp3");
		SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Теперь подойди к капоту и открой его так-же как багажник");
	}
	return 1;
}

stock TakeBootBox(playerid, v, inva, rob)
{
	if(OnlineInfo[playerid][oInHandThing] >= 1 || Hand[playerid] >= 1 || Hold[playerid] >= 1 || GetPlayerWeapon(playerid) >= 2) return ErrorMessage(playerid, "{FF6347}У вас заняты руки [ Предмет или оружие ]"), i_resettabs(playerid);
	    
	new fpick = VehInfo[v][vInvent][inva], fquan = VehInfo[v][vInv][inva], thingPara = VehInfo[v][vInvPara][inva], thingQara = VehInfo[v][vInvQara][inva], thingType = VehInfo[v][vInvType][inva], thingPack = VehInfo[v][vInvPack][inva];
	if(IsArmor(fpick)) thingPara = 100; // Броня 100 хп

	if(thingPack == 4 && rob == 1) thingPack = 2; // Снимаем блокировку с ящика, если мы грабим поезд
	GiveThingHand(playerid, fpick, fquan, thingPara, thingQara, thingType, thingPack);

	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,1,1,1,1,1);
	PPP15[playerid] = 3, RemovePlayerAttachedObject(playerid,1);
	SetPlayerAttachedObject(playerid,1 , 3014, 6, 0.120000, 0.199448, -0.120000, 254.000000, 0.900000, 70.000000);
	i_resettabs(playerid);
	TakeBoot(v, fpick, fquan, thingType, inva);

	// Если транспорт полностью залочен от спавна
	if(VehInfo[v][vNospawn] == 2)
	{
		if(get_bootbox(v) <= 0) VehInfo[v][vNospawn] = 0; // Ящики кончились - отключаем блокировку спавна транспорта
	}
	return 1;
}

stock boot_close(playerid)
{
    if(OnlineInfo[playerid][oShowTabs] != 9999)
    {
		new kolka = 0;
		foreach(Player, i)
		{
			if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[playerid][oShowTabs] == OnlineInfo[i][oShowTabs] && Tabs_Load[i] == 5) kolka ++;
		}
	    if(kolka <= 1)
	    {
    		if(IsABootFront(OnlineInfo[playerid][oShowTabs])) // Морда
    		{
    			GetVehicleParamsEx(OnlineInfo[playerid][oShowTabs], engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(OnlineInfo[playerid][oShowTabs], engine, lights, alarm, doors, false, boot, objective);
    		}
    		else // Жопа
    		{
				GetVehicleParamsEx(OnlineInfo[playerid][oShowTabs], engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(OnlineInfo[playerid][oShowTabs], engine, lights, alarm, doors, bonnet, false, objective);
			}
			VehInfo[OnlineInfo[playerid][oShowTabs]][vBoot] = 0;
			if(VehInfo[OnlineInfo[playerid][oShowTabs]][vNospawn] != 2) VehInfo[OnlineInfo[playerid][oShowTabs]][vNospawn] = 0;
		}
		OnlineInfo[playerid][oShowTabs] = 9999;
	}
	PlayerTextDrawHide(playerid, PlaNestAct[0][playerid]);
	PlayerTextDrawHide(playerid, PlaNestAct[1][playerid]);
   	return 1;
}
stock put_boot(playerid, inva, v, fpick, fquan, binva, thingType, thingPack)
{
    new put_inva = -1;
	if(OnlineInfo[playerid][oShowInterface] != 1 || binva == 9999 || OnlineInfo[playerid][oInventSelectLeft] == 9999 || v == INVALID_VEHICLE_ID || !IsABoot(v)
	|| PlayerInfo[playerid][pInven][inva] <= 0 || PlayerInfo[playerid][pInven][inva] != fpick || PlayerInfo[playerid][pInvenQuan][inva] < fquan) return 1;
	
	if(fpick == 48 && thingType == 0 && OnlineInfo[playerid][oInflatableBoat] != NON) return ErrorMessage(playerid, "{FF6347}Нужно сдуть лодку, прежде чем положить в багажник"), i_resetveshi(playerid);
    if(NotGiveThing(fpick, thingType, PlayerInfo[playerid][pInvenQuan][inva])) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя передавать, продавать или убирать"), i_resetveshi(playerid);
    if((VehInfo[v][vSost] == PlayerInfo[playerid][pID] || VehInfo[v][vKey] == PlayerInfo[playerid][pID] && VehInfo[v][vKeyUnix] > gettime()) && GetPlayerVip(playerid) > 0) {}
	else
	{
		if(VehInfo[v][vCarLock] >= 1) return ErrorMessage(playerid, "{FF6347}Транспорт заперт"), i_resetveshi(playerid);
	}
    new Float:Boot[3], Float:Bonnet[3];
	GetCoordBonnetVehicle(v, Bonnet[0], Bonnet[1], Bonnet[2]);
	GetCoordBootVehicle(v, Boot[0], Boot[1], Boot[2]);
	if(IsPlayerInRangeOfPoint(playerid, 1.0, Boot[0], Boot[1], Boot[2]) && !IsABootFront(v) || IsPlayerInRangeOfPoint(playerid, 1.0, Bonnet[0], Bonnet[1], Bonnet[2]) && IsABootFront(v))
	{
	    if(VehInfo[v][vUpgrade] == 0) // Проверка на слоты багажника
		{
			if(IsA_Gen5(v) && binva >= 5) return ErrorMessage(playerid, "{FF6347}В багажнике не хватает места [ Y >> Транспорт >> Увеличить Багажник ]"), i_resetveshi(playerid);

			if(IsA_Gen10(v) && binva >= 10) return ErrorMessage(playerid, "{FF6347}В багажнике не хватает места [ Y >> Транспорт >> Увеличить Багажник ]"), i_resetveshi(playerid);

		 	if(IsA_Gen15(v) && binva >= 15) return ErrorMessage(playerid, "{FF6347}В багажнике не хватает места [ Y >> Транспорт >> Увеличить Багажник ]"), i_resetveshi(playerid);
		}
	
	    new quanThing;
		if(thingType == 0)
		{
			if(CheckThingQuan(fpick) == 1)
			{
			    if(VehInfo[v][vInvent][binva] != 0 && VehInfo[v][vInvent][binva] != PlayerInfo[playerid][pInven][inva]) return ErrorMessage(playerid, "{FF6347}Эта ячейка занята"), i_resetveshi(playerid);
			    if(thingPack == 0) quanThing = 1;
			    if(PlayerInfo[playerid][pInvenQuan][inva] < fquan) return ErrorMessage(playerid, "{FF6347}У вас нет такого количества в этой ячейке"), i_resetveshi(playerid);
			    new getQuan, getLimit;
			    v_limit(v, fpick, getQuan, getLimit);
			    if(getQuan+fquan > getLimit)
			    {
			        format(store,sizeof(store),"{FF6347}В багажнике нет места\n\nЛимит для этого предмета: %d", getLimit);
			        ErrorMessage(playerid, store);
					i_resetveshi(playerid);
					i_resettabs(playerid);
					return 1;
			    }
			}
		}
		if(VehInfo[v][vInvent][binva] > 0 && quanThing == 0) return ErrorMessage(playerid, "{FF6347}Эта ячейка занята"), i_resetveshi(playerid);

		put_inva = put_thing_boot(v, fpick, fquan, PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenQara][inva], thingType, thingPack, binva);
		if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}В багажнике нет места"), i_resetveshi(playerid); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет

		if(quanThing == 1) take_away(playerid, fquan, inva); // Отнимаем предмет (по количеству)
	 	else i_del(playerid, inva); // Отнимаем предмет (целиком)
	 	SaveInvent(playerid, inva); // Сохраняем ячейку инвентаря игрока

		format(store,sizeof(store),"Положил в багажник %d: %s", GetNameThing(1, fpick, thingType, thingPack));
		UserLog("putboot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fquan, store);

		i_resetveshi(playerid);
		i_resettabs(playerid);
    }
	else ErrorMessage(playerid, "{FF6347}Вы далеко от транспорта");
	return put_inva;
}
stock PutThingBoot(v, thingId, quan, para, qara, thingType, thingPack, useinva) // Кладём предмет в багажник
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
		    	for(new i = 0; i < 20; i++)
				{
					if(VehInfo[v][vInvent][i] == thingId && VehInfo[v][vInvType][i] == thingType) // Ищем тот, где уже предмет лежит
					{
					    inva = i;
		  				put_thing_boot(v, thingId, quan, para, 0, thingType, thingPack, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
		  				find = 1;
			   			break;
					}
				}
				if(find == 0) // Если не нашли, ищем пустую
				{
					for(new i = 0; i < 20; i++)
					{
						if(VehInfo[v][vInvent][i] == 0) // Ищем пустую ячейку
						{
						    inva = i;
			  				put_thing_boot(v, thingId, quan, para, 0, thingType, thingPack, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
				   			break;
						}
					}
				}
			}
			else if(CheckThingQuan(thingId) == 0) // Объект не имеет количество
			{
			    for(new i = 0; i < 20; i++)
				{
					if(VehInfo[v][vInvent][i] == 0) // Ищем пустую ячейку
					{
					    inva = i;
		  				put_thing_boot(v, thingId, quan, para, qara, thingType, thingPack, i);
			   			break;
					}
				}
			}
		}
		else // Все остальные предметы не имеют количества или возможности складываться в одну ячейку
		{
		    for(new i = 0; i < 20; i++)
			{
				if(VehInfo[v][vInvent][i] == 0) // Ищем пустую ячейку
				{
				    inva = i;
	  				put_thing_boot(v, thingId, quan, para, qara, thingType, thingPack, i);
		   			break;
				}
			}
		}
	}
	else inva = put_thing_boot(v, thingId, quan, para, qara, thingType, thingPack, useinva); // Знаем в какую ячейку класть
	return inva;
}
stock put_thing_boot(v, thingId, quan, para, qara, thingType, thingPack, i)
{
	if(VehInfo[v][vInvent][i] != 0 && VehInfo[v][vInvent][i] != thingId) return -1; // Защита от ошибки, на всякий случай

	if(VehInfo[v][vSost] > 0 && qara == VehInfo[v][vSost]) qara = 0; // Удаляем статус краденного предмета, если он принадлежит этому игроку

	VehInfo[v][vInvent][i] = thingId; // Ставим предмет в слот
	VehInfo[v][vInv][i] += quan; // Ставим количество в слот

	// (Техника сломана или нет, Одежда какой организации принадлежит, Unix время свежести продуктов, Изношенность оружия, Прнадлежность лицензии к ID игрока, Тип крепления аксессуара)
	if(PerishableThing(thingId, thingType)) // Проверка на портящиеся продукты - у них используется Unix (Добавляя испорченный продукт к свежему, портиться должно всё)
	{
	    if(VehInfo[v][vInvPara][i] > 0)
		{
			if(VehInfo[v][vInvPara][i] > para) VehInfo[v][vInvPara][i] = para;
		}
		else VehInfo[v][vInvPara][i] = para;
	}
	else VehInfo[v][vInvPara][i] = para;
	VehInfo[v][vInvQara][i] = qara; // Статус краденного предмета
	VehInfo[v][vInvType][i] = thingType; // Тип предмета
	VehInfo[v][vInvPack][i] = thingPack; // Упаковка предмета

	if(thingId != 35) SaveOneBoot(v, i);
	foreach(Player,x)
	{
		if(Tabs_Load[x] != 5) continue;
		if(OnlineInfo[x][oLogged] == 1 && OnlineInfo[x][oShowInterface] == 1 && OnlineInfo[x][oShowTabs] == v) item_second(x, thingId, VehInfo[v][vInv][i], i, 0, VehInfo[v][vInvPara][i], thingType, thingPack, 0);
	}
	return i;
}
stock TakeBoot(veh, stat, kolvo, thingType, dopinf)
{
	new plalit;
	if(dopinf == 999)
	{
		for(new inva = 0; inva < 20; inva++)
		{
			if(VehInfo[veh][vInvent][inva] == stat && VehInfo[veh][vInvType][inva] == thingType)
			{
				if(VehInfo[veh][vInv][inva]-kolvo <= 0) VehInfo[veh][vInvent][inva] = 0, VehInfo[veh][vInv][inva] = 0, VehInfo[veh][vInvPara][inva] = 0, VehInfo[veh][vInvQara][inva] = 0, VehInfo[veh][vInvType][inva] = 0, VehInfo[veh][vInvPack][inva] = 0;
				else VehInfo[veh][vInv][inva] -= kolvo;
				plalit = inva;
				break;
			}
		}
	}
	else
	{
		if(VehInfo[veh][vInvent][dopinf] == stat && VehInfo[veh][vInvType][dopinf] == thingType)
		{
			if(VehInfo[veh][vInv][dopinf]-kolvo <= 0) VehInfo[veh][vInvent][dopinf] = 0, VehInfo[veh][vInv][dopinf] = 0, VehInfo[veh][vInvPara][dopinf] = 0, VehInfo[veh][vInvQara][dopinf] = 0, VehInfo[veh][vInvType][dopinf] = 0, VehInfo[veh][vInvPack][dopinf] = 0;
			else VehInfo[veh][vInv][dopinf] -= kolvo;
		}
		plalit = dopinf;
	}
	SaveOneBoot(veh, plalit);
	foreach(Player,i)
	{
		if(Tabs_Load[i] != 5) continue;
		if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowTabs] == veh) item_second(i, VehInfo[veh][vInvent][plalit], VehInfo[veh][vInv][plalit], plalit, 0, VehInfo[veh][vInvPara][plalit], VehInfo[veh][vInvType][plalit], VehInfo[veh][vInvPack][plalit], 0);
	}
	return 1;
}
stock mix_boot(playerid, v, getinva, putinva) // Смешивание предметов
{
	if(OnlineInfo[playerid][oShowTabs] != 9999)
	{
		if(VehInfo[v][vInvent][getinva] == 0) return i_resettabs(playerid);
		else if(VehInfo[v][vInvent][putinva] != VehInfo[v][vInvent][getinva]) return i_resettabs(playerid);
		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 5) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			format(store, sizeof(store), "{FF6347}Багажник просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, store);
			i_resettabs(playerid);
			return 1;
		}
		VehInfo[v][vInv][putinva] += VehInfo[v][vInv][getinva];
		if(VehInfo[v][vInvPara][putinva] > VehInfo[v][vInvPara][getinva]) VehInfo[v][vInvPara][putinva] = VehInfo[v][vInvPara][getinva];
		VehInfo[v][vInvent][getinva] = 0;
		VehInfo[v][vInv][getinva] = 0;
		VehInfo[v][vInvPara][getinva] = 0;
		VehInfo[v][vInvQara][getinva] = 0;
		VehInfo[v][vInvType][getinva] = 0;
		VehInfo[v][vInvPack][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, VehInfo[v][vInvent][getinva], VehInfo[v][vInv][getinva], getinva, 0, VehInfo[v][vInvPara][getinva], VehInfo[v][vInvType][getinva], VehInfo[v][vInvPack][getinva], 0);
		item_second(playerid, VehInfo[v][vInvent][putinva], VehInfo[v][vInv][putinva], putinva, 0, VehInfo[v][vInvPara][putinva], VehInfo[v][vInvType][putinva], VehInfo[v][vInvPack][putinva], 0);
		SaveOneBoot(v, getinva);
		SaveOneBoot(v, putinva);
	}
	return 1;
}
stock shift_boot(playerid, v, getinva, putinva) // Перемещение предметов внутри багажника транспорта (с одной ячейки на другую)
{
	if(OnlineInfo[playerid][oShowTabs] != 9999)
	{
		if(VehInfo[v][vInvent][getinva] == 0) return i_resettabs(playerid);
		else if(VehInfo[v][vInvent][putinva] != 0) return 1;
		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 5) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
		    format(store, sizeof(store), "{FF6347}Багажник просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, store);
			i_resettabs(playerid);
			return 1;
		}
		if(VehInfo[v][vUpgrade] == 0)
		{
			if(IsA_Gen5(v) && putinva >= 5) return ErrorMessage(playerid, "{FF6347}В багажнике не хватает места [ Y >> Транспорт >> Увеличить Багажник ]"), i_resetveshi(playerid);
			if(IsA_Gen10(v) && putinva >= 10) return ErrorMessage(playerid, "{FF6347}В багажнике не хватает места [ Y >> Транспорт >> Увеличить Багажник ]"), i_resetveshi(playerid);
		 	if(IsA_Gen15(v) && putinva >= 15) return ErrorMessage(playerid, "{FF6347}В багажнике не хватает места [ Y >> Транспорт >> Увеличить Багажник ]"), i_resetveshi(playerid);
		}
		VehInfo[v][vInvent][putinva] = VehInfo[v][vInvent][getinva];
		VehInfo[v][vInv][putinva] = VehInfo[v][vInv][getinva];
		VehInfo[v][vInvPara][putinva] = VehInfo[v][vInvPara][getinva];
		VehInfo[v][vInvQara][putinva] = VehInfo[v][vInvQara][getinva];
		VehInfo[v][vInvType][putinva] = VehInfo[v][vInvType][getinva];
		VehInfo[v][vInvPack][putinva] = VehInfo[v][vInvPack][getinva];
		VehInfo[v][vInvent][getinva] = 0;
		VehInfo[v][vInv][getinva] = 0;
		VehInfo[v][vInvPara][getinva] = 0;
		VehInfo[v][vInvQara][getinva] = 0;
		VehInfo[v][vInvType][getinva] = 0;
		VehInfo[v][vInvPack][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, 0, 0, getinva, 0, 0, 0, 0, 0);
		item_second(playerid, VehInfo[v][vInvent][putinva], VehInfo[v][vInv][putinva], putinva, 0, VehInfo[v][vInvPara][putinva], VehInfo[v][vInvType][putinva], VehInfo[v][vInvPack][putinva], 0);
		SaveOneBoot(v, getinva);
		SaveOneBoot(v, putinva);
	}
	return 1;
}
stock put_bootbox(playerid, v) // Кладём ящик в багажник
{
	if(OnlineInfo[playerid][oInHandThing][0] > 0 && (OnlineInfo[playerid][oInHandThing][5] == 2 || OnlineInfo[playerid][oInHandThing][5] == 4))
	{
	    new put_inva = PutThingBoot(v, OnlineInfo[playerid][oInHandThing][0], OnlineInfo[playerid][oInHandThing][1], OnlineInfo[playerid][oInHandThing][2], OnlineInfo[playerid][oInHandThing][3], OnlineInfo[playerid][oInHandThing][4], OnlineInfo[playerid][oInHandThing][5], 999);
	    if(put_inva == -1)
		{
			ErrorMessage(playerid, "{FF6347}В транспорте нет места");
			return 0;
		}
	    
		if(VehicleEscort > 0 && fraction(playerid) == 3 && (OnlineInfo[playerid][oInHandThing][5] == 2 || OnlineInfo[playerid][oInHandThing][5] == 4)
			&& v != VehicleEscort && v != train)
		{
			ErrorMessage(playerid, "{FF6347}Вы не можете положить ящик в этот транспорт\n\n{cccccc}Ящики для доставки БП должны находиться в одном транспорте");
			return 0;
		}

		// Если это Barracks и в руках у нас ящик, блокируем спавн транспорта
		if(VehInfo[v][vModel] == 433 && (OnlineInfo[playerid][oInHandThing][5] == 2 || OnlineInfo[playerid][oInHandThing][5] == 4))
		{
			VehInfo[v][vNospawn] = 2;
			VehicleEscort = v;
		}

	    InHandClear(playerid);
		SetPlayerChatBubble(playerid,"кладёт ящик в транспорт",COLOR_PURPLE,20.0,3000);
		RemovePlayerAttachedObject(playerid,1), PPP15[playerid] = 0;
   		ClearAnimations(playerid);
   		ClearAnim(playerid);
   		PlayerPlaySound(playerid,1053,0,0,0);
	}
	else 
	{
		ErrorMessage(playerid, "{FF6347}У вас в руках нет ящика");
		return 0;
	}
	return 1;
}

stock GetInvaBoxInBoot(v)
{
	new inva = -1;
	for(new i = 0; i < 20; i++)
	{
		if(VehInfo[v][vInvent][i] > 0 && (VehInfo[v][vInvPack][i] == 2 || VehInfo[v][vInvPack][i] == 4))
		{
			inva = i;
			break;
		}
	}
	return inva;
}

stock item_boot(playerid, v, fpick, fquan, inva, fpara, thingType, thingPack)
{
    inva = inva+20;
	if(fpick == 0)
	{
		new blocker = 0;
		if(VehInfo[v][vUpgrade] == 1) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]), PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
		else
		{
   			if(IsA_Gen5(v))
		 	{
		 		if(inva <= 24) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]), PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
  				else blocker = 1;
   			}
		 	else if(IsA_Gen10(v))
		 	{
		 		if(inva <= 29) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]), PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
		 		else blocker = 1;
		 	}
		 	else if(IsA_Gen15(v))
		 	{
		 		if(inva <= 34) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]), PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
		 		else blocker = 1;
		 	}
		 	else PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]), PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
		}
		if(blocker == 1)
		{
			PlayerTextDrawSetPreviewModel(playerid, PlaNestPick[inva][playerid], 2485);
			PlayerTextDrawSetPreviewRot(playerid, PlaNestPick[inva][playerid], 0.0, 0.0, 0.0, -1.0);
			PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], 80);
			PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], -1);
			PlayerTextDrawBoxColor(playerid, PlaNestPick[inva][playerid], 0);
			PlayerTextDrawFont(playerid, PlaNestPick[inva][playerid], 5);
		}
	 	else if(blocker == 0) PlayerTextDrawFont(playerid, PlaNestPick[inva][playerid], 4);
	 	PlayerTextDrawShow(playerid, PlaNestPick[inva][playerid]);
	}
	else
	{
		new string[28], yesFindModel;
		PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
		PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], -1);
		PlayerTextDrawBoxColor(playerid, PlaNestPick[inva][playerid], 0);
		PlayerTextDrawFont(playerid, PlaNestPick[inva][playerid], 5);
		
		if(thingPack == 1) yesFindModel = 19054; // Подарок
		else if(thingPack == 2 || thingPack == 4) yesFindModel = 3014; // Ящик / Запечатанный Ящик
		else if(thingPack == 3) yesFindModel = 2060; // Мешок
		else if(thingPack == 5) yesFindModel = 19918; // Кейс
		else if(thingPack == 0) // Без упаковки
		{
			if(thingType == 0) // Обычный предмет
			{
			    yesFindModel = friskPick[fpick];
				if(CheckThingQuan(fpick) == 1) // Количественный
				{
					format(string, sizeof(string), "%d", fquan);
					PlayerTextDrawSetString(playerid, PlaNestPickNum[inva][playerid], string);
					if(PlayerInfo[playerid][pSty] == 6 || PlayerInfo[playerid][pSty] == 11) PlayerTextDrawColor(playerid, PlaNestPickNum[inva][playerid], 673720575);
					else PlayerTextDrawColor(playerid, PlaNestPickNum[inva][playerid], -1);
	  				PlayerTextDrawShow(playerid, PlaNestPickNum[inva][playerid]);
				}
			}
			if(thingType == 1) // Оружие
			{
			    yesFindModel = friskGun[fpick];
			    if(fpara <= 0)
			    {
			    	if(fpick == 25 || fpick == 26 || fpick == 27) yesFindModel = 2034;
			    	else if(fpick == 22 || fpick == 24) yesFindModel = 2034;
			    	else if(fpick == 30 || fpick == 31) yesFindModel = 2035;
			        else if(fpick == 33 || fpick == 34) yesFindModel = 2036;
			    }
			}
			if(thingType == 2) yesFindModel = fpick; // Аксессуары
			if(thingType == 3) 
			{
				yesFindModel = GetModelSkin(playerid, fpick); // Одежда
				format(string, sizeof(string), "ID %d", fpick);
				textPickInventory(playerid, inva, string);
			}
			if(thingType == 4) yesFindModel = fpick; // Мебель
		}
		
		if(yesFindModel > 0)
		{
		    new Float:modelPos[4], findIt;
			GetModelTextDraw(yesFindModel, thingType, modelPos[0], modelPos[1], modelPos[2], modelPos[3], findIt);
			PlayerTextDrawSetPreviewModel(playerid, PlaNestPick[inva][playerid], yesFindModel);
			PlayerTextDrawSetPreviewRot(playerid, PlaNestPick[inva][playerid], modelPos[0], modelPos[1], modelPos[2], modelPos[3]);
		}
	}
	PlayerTextDrawShow(playerid, PlaNestPick[inva][playerid]);
	return 1;
}
stock SaveBoot(v) // Сохранение всего багажника по цилку
{
    if(Cars[v] == 88 || Cars[v] == 99)
	{
		if(VehInfo[v][vDatabase] >= 1 && VehInfo[v][vDatabase] <= MAX_MYVEHICLE)
		{
			format(big_query,sizeof(big_query),"UPDATE `pp_cars` SET `Inven1` = '%d', `InvenKol1` = '%d', `InvenPara1` = '%d', `InvenQara1` = '%d', `InvenType1` = '%d', `InvenPack1` = '%d'",
			VehInfo[v][vInvent][0], VehInfo[v][vInv][0], VehInfo[v][vInvPara][0], VehInfo[v][vInvQara][0], VehInfo[v][vInvType][0], VehInfo[v][vInvPack][0]);

			for(new i = 1; i < 20; i++) format(big_query,sizeof(big_query),"%s, `Inven%d` = '%d', `InvenKol%d` = '%d', `InvenPara%d` = '%d', `InvenQara%d` = '%d', `InvenType%d` = '%d', `InvenPack%d` = '%d'", big_query,
			i+1, VehInfo[v][vInvent][i], i+1, VehInfo[v][vInv][i], i+1, VehInfo[v][vInvPara][i], i+1, VehInfo[v][vInvQara][i], i+1, VehInfo[v][vInvType][i], i+1, VehInfo[v][vInvPack][i]);

		    format(big_query,sizeof(big_query),"%s WHERE `newid` = '%d'", big_query, VehInfo[v][vNewid]);
			query_empty(pearsq, big_query);
		}
	}
	return 1;
}
stock SaveOneBoot(veh, inva) // Сохранение багажника транспорта
{
    if(Cars[veh] == 88 || Cars[veh] == 99)
	{
		if(VehInfo[veh][vDatabase] >= 1 && VehInfo[veh][vDatabase] <= MAX_MYVEHICLE)
		{
			format(big_query, sizeof(big_query), "UPDATE `pp_cars` SET `Inven%d`='%d',`InvenKol%d`='%d',`InvenPara%d`='%d',`InvenQara%d`='%d',`InvenType%d`='%d',`InvenPack%d`='%d' WHERE `newid`='%d'",
			inva+1,VehInfo[veh][vInvent][inva], inva+1,VehInfo[veh][vInv][inva], inva+1,VehInfo[veh][vInvPara][inva], inva+1,VehInfo[veh][vInvQara][inva], inva+1,VehInfo[veh][vInvType][inva], inva+1,VehInfo[veh][vInvPack][inva], VehInfo[veh][vNewid]);
			query_empty(pearsq, big_query);
		}
	}
	return 1;
}
stock v_limit(v, thingId, &getQuan, &getLimit) // Проверяем лимиты дома
{
	new lim[INVENTER];
	for(new i = 0; i < INVENTER; i++) lim[i] = 1;
	lim[8] = 100, lim[19] = 100, lim[41] = 1000, lim[25] = 1000000; // Аптечки, Отмычки, Бенгальские Свечи, Деньги 1кк
	lim[4] = 10000, lim[5] = 10000, lim[6] = 10000, lim[7] = 10000, lim[9] = 20, lim[18] = 1000, lim[20] = 10000, lim[27] = 10000, lim[28] = 10000, lim[29] = 10000, lim[30] = 10000;
	lim[46] = 100, lim[47] = 100, lim[55] = 100, lim[60] = 1000, lim[61] = 100, lim[64] = 1000, lim[65] = 1000, lim[66] = 1000, lim[67] = 1000, lim[71] = 100;
	lim[72] = 100, lim[73] = 100, lim[74] = 100, lim[75] = 100, lim[76] = 100, lim[77] = 100, lim[78] = 100, lim[79] = 100, lim[80] = 100, lim[81] = 100;
	lim[82] = 100, lim[83] = 100, lim[84] = 100, lim[85] = 100, lim[86] = 100, lim[87] = 100, lim[88] = 100, lim[89] = 1000, lim[106] = 100, lim[108] = 100, lim[109] = 100, lim[110] = 100;
	lim[140] = 1000, lim[141] = 1000, lim[142] = 100;

    getQuan = get_boot(v, thingId);
    getLimit = lim[thingId];
	return 1;
}
stock get_boot(v, stat) // Поиск при добавлении нового предмета
{
	new kolvo = 0, yes = 0;
	for(new inva = 0; inva < 20; inva++)
	{
		if(VehInfo[v][vInvent][inva] == stat && VehInfo[v][vInvType][inva] == 0) kolvo += VehInfo[v][vInv][inva], yes = 1;
	}
	if(yes == 1) return kolvo;
	else return -1;
}
stock get_boot2(v, stat, inva) // Поиск при вытаскивании предмета только в одной ячейке
{
	if(VehInfo[v][vInvent][inva] == stat && VehInfo[v][vInvType][inva] == 0)
	{
		return VehInfo[v][vInv][inva];
	}
	else return -1;
}
stock get_bootbox(v) // Считаем количество ящиков в багажнике
{
	new quan;
	for(new inva = 0; inva < 20; inva++)
	{
		if(VehInfo[v][vInvent][inva] > 0 && (VehInfo[v][vInvPack][inva] == 2 || VehInfo[v][vInvPack][inva] == 4)) quan ++;
	}
	return quan;
}
stock ClearBootVehcile(v, i)
{
    VehInfo[v][vInvent][i] = 0;
	VehInfo[v][vInv][i] = 0;
	VehInfo[v][vInvPara][i] = 0;
	VehInfo[v][vInvQara][i] = 0;
	VehInfo[v][vInvType][i] = 0;
    VehInfo[v][vInvPack][i] = 0;
	return 1;
}
stock CheckBoot(v)
{
	if(VehInfo[v][vUpgrade] == 1)
	{
		if(VehInfo[v][vInvent][0] >= 1 && VehInfo[v][vInvent][1] >= 1 && VehInfo[v][vInvent][2] >= 1 && VehInfo[v][vInvent][3] >= 1 && VehInfo[v][vInvent][4] >= 1
		&& VehInfo[v][vInvent][5] >= 1 && VehInfo[v][vInvent][6] >= 1 && VehInfo[v][vInvent][7] >= 1 && VehInfo[v][vInvent][8] >= 1 && VehInfo[v][vInvent][9] >= 1
		&& VehInfo[v][vInvent][10] >= 1 && VehInfo[v][vInvent][11] >= 1 && VehInfo[v][vInvent][12] >= 1 && VehInfo[v][vInvent][13] >= 1 && VehInfo[v][vInvent][14] >= 1
		&& VehInfo[v][vInvent][15] >= 1 && VehInfo[v][vInvent][16] >= 1 && VehInfo[v][vInvent][17] >= 1 && VehInfo[v][vInvent][18] >= 1 && VehInfo[v][vInvent][19] >= 1) return 1;
	}
	else if(IsA_Gen5(v) && VehInfo[v][vUpgrade] == 0)
	{
	    if(VehInfo[v][vInvent][0] >= 1 && VehInfo[v][vInvent][1] >= 1 && VehInfo[v][vInvent][2] >= 1 && VehInfo[v][vInvent][3] >= 1 && VehInfo[v][vInvent][4] >= 1) return 1;
 	}
 	else if(IsA_Gen10(v) && VehInfo[v][vUpgrade] == 0)
	{
	    if(VehInfo[v][vInvent][0] >= 1 && VehInfo[v][vInvent][1] >= 1 && VehInfo[v][vInvent][2] >= 1 && VehInfo[v][vInvent][3] >= 1 && VehInfo[v][vInvent][4] >= 1
		&& VehInfo[v][vInvent][5] >= 1 && VehInfo[v][vInvent][6] >= 1 && VehInfo[v][vInvent][7] >= 1 && VehInfo[v][vInvent][8] >= 1 && VehInfo[v][vInvent][9] >= 1) return 1;
 	}
 	else if(IsA_Gen15(v) && VehInfo[v][vUpgrade] == 0)
	{
	    if(VehInfo[v][vInvent][0] >= 1 && VehInfo[v][vInvent][1] >= 1 && VehInfo[v][vInvent][2] >= 1 && VehInfo[v][vInvent][3] >= 1 && VehInfo[v][vInvent][4] >= 1
		&& VehInfo[v][vInvent][5] >= 1 && VehInfo[v][vInvent][6] >= 1 && VehInfo[v][vInvent][7] >= 1 && VehInfo[v][vInvent][8] >= 1 && VehInfo[v][vInvent][9] >= 1
		&& VehInfo[v][vInvent][10] >= 1 && VehInfo[v][vInvent][11] >= 1 && VehInfo[v][vInvent][12] >= 1 && VehInfo[v][vInvent][13] >= 1 && VehInfo[v][vInvent][14] >= 1) return 1;
 	}
 	else
 	{
		if(VehInfo[v][vInvent][0] >= 1 && VehInfo[v][vInvent][1] >= 1 && VehInfo[v][vInvent][2] >= 1 && VehInfo[v][vInvent][3] >= 1 && VehInfo[v][vInvent][4] >= 1
		&& VehInfo[v][vInvent][5] >= 1 && VehInfo[v][vInvent][6] >= 1 && VehInfo[v][vInvent][7] >= 1 && VehInfo[v][vInvent][8] >= 1 && VehInfo[v][vInvent][9] >= 1
		&& VehInfo[v][vInvent][10] >= 1 && VehInfo[v][vInvent][11] >= 1 && VehInfo[v][vInvent][12] >= 1 && VehInfo[v][vInvent][13] >= 1 && VehInfo[v][vInvent][14] >= 1
		&& VehInfo[v][vInvent][15] >= 1 && VehInfo[v][vInvent][16] >= 1 && VehInfo[v][vInvent][17] >= 1 && VehInfo[v][vInvent][18] >= 1 && VehInfo[v][vInvent][19] >= 1) return 1;
	}
	return 0;
}

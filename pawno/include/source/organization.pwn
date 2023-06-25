function gunsklad(playerid)
{
	new skladstat = IsAGunSklad(playerid);
	if(skladstat > 0)
	{
	    new fpick = OnlineInfo[playerid][oInHandThing][0], fquan = OnlineInfo[playerid][oInHandThing][1], fpara = OnlineInfo[playerid][oInHandThing][2], thingType = OnlineInfo[playerid][oInHandThing][4], thingPack = OnlineInfo[playerid][oInHandThing][5];
		if(fpick > 0 && thingPack == 2) //  Кладём Ящик
		{
		    if(fpick >= 4 && fpick <= 7 && (skladstat == 1 || skladstat == 3 || skladstat == 4 || skladstat == 7 || skladstat == 9 || skladstat == 11 || skladstat == 21 || skladstat == 22 || skladstat == 29 || skladstat == 33)) return ErrorMessage(playerid, "{FF6347}На этом складе нельзя хранить вещества");

			if(fpick == 34 && thingType == 1 && skladstat != 8 && skladstat != 22) return ErrorMessage(playerid, "{FF6347}На этом складе нельзя хранить снайперскую винтовку\n{cccccc}[Только для ICA, SWAT]");
			if((fpick >= 4 && fpick <= 7 || fpick >= 27 && fpick <= 30) && thingType == 0 || IsHelmet(fpick) && thingType == 2 || IsArmor(fpick) && thingType == 2 || thingType == 1)
			{
			    if(thingType == 1) fpara = 300000;
			    if(IsHelmet(fpick) && thingType == 2) fpara = 3;
			    if(IsArmor(fpick) && thingType == 2) fpara = 100;
			
			    new put_inva = putsklad(skladstat, fpick, fquan, fpara, thingType); // Кладём предмет
				if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}На складе организации, для этого предмета, нет места [ Лимит ]");

				InHandClear(playerid);
				if(PlayerInfo[playerid][pSex] == 1) format(store,sizeof(store),"[ Мысли ]: Я положил на склад {ff9000}%s | %d",GetNameThing(1, fpick, thingType, thingPack),fquan);
				else format(store,sizeof(store),"[ Мысли ]: Я положила на склад {ff9000}%s | %d",GetNameThing(1, fpick, thingType, thingPack),fquan);
    			SendClientMessage(playerid, COLOR_GREY, store);
				OrgLog(skladstat, "putsklad", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fquan, GetNameThing(1, fpick, thingType, thingPack));

	   		    SetPlayerChatBubble(playerid,"кладёт ящик на склад",COLOR_PURPLE,20.0,3000);
	       	    RemovePlayerAttachedObject(playerid,1);
	       	    PPP15[playerid] = 0;
	       	    ApplyAnimation(playerid,"CARRY","putdwn",4.0,0,0,0,0,0,1);
	       	    PlayerPlaySound(playerid,6401,0,0,0);

	       	    // Выдаём юниты
	       	    if(OrganInfo[fraction(playerid)][gUnitStat][2] > 0)
	   			{
	   			    new kol;
	   				if((fpick >= 4 && fpick <= 7 || fpick >= 27 && fpick <= 30) && thingType == 0) kol = fquan; // Вещества, Патроны
	   				else if(IsHelmet(fpick) && thingType == 2 || IsArmor(fpick) && thingType == 2 || thingType == 1) kol = fquan*1000; // Каска, Броня, Оружие
	   				PlayerInfo[playerid][pUnit] += kol*OrganInfo[fraction(playerid)][gUnitStat][2];
	   				format(store,sizeof(store),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Unit: ~w~+%d",kol*OrganInfo[fraction(playerid)][gUnitStat][2]);
	   				GameTextForPlayer(playerid,store,3000,3);
				}

				// Выдаём ачивку, первый доставленный ящик
				if(PlayerInfo[playerid][pAchieve][99] == 0) AchievePlayer(playerid, 99, 1);
  	    	}
			else ErrorMessage(playerid, "{FF6347}Содержимое ящика в руках не может храниться на этом складе");
		}
		else ErrorMessage(playerid, "{FF6347}У вас в руках нет ящика");
	}
	return 1;
}
stock use_sklad(playerid, wh, inva, useinva)
{
    i_resettabs(playerid);
	i_resetveshi(playerid);

	new fpick = OrganInfo[wh][gInvent][inva], thingType = OrganInfo[wh][gInvType][inva], unixtime = gettime();
    if(useinva != 9999)
	{
 		if(PlayerInfo[playerid][pInven][useinva] != OrganInfo[wh][gInvent][inva] && PlayerInfo[playerid][pInven][useinva] != 0) return i_resettabs(playerid);
	}
	if(JustOneThingInventory(fpick, thingType) && get_invent(playerid, fpick, thingType) > 0) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет");

	new yes, giveThing;
	if(IsHelmet(fpick) && thingType == 2) // Каска (Тип аксессуар)
	{
	    if(PlayerInfo[playerid][pGacc][6]+OrganInfo[wh][gUnitStat][20]*60 > unixtime) return format(store,sizeof(store),"{FF6347}Вы не можете сейчас взять каску [ Через %d мин. ]", ((PlayerInfo[playerid][pGacc][6]+OrganInfo[wh][gUnitStat][20]*60)-unixtime)/60), ErrorMessage(playerid, store);
	    if(PlayerInfo[playerid][pOdet][0] == fpick || PlayerInfo[playerid][pOdet][1] == fpick || PlayerInfo[playerid][pOdet][2] == fpick || PlayerInfo[playerid][pOdet][3] == fpick || PlayerInfo[playerid][pOdet][4] == fpick) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет");
	    giveThing = 6;
	    yes = 1;
	}
	else if(IsArmor(fpick) && thingType == 2) // Бронежилет (Тип аксессуар)
	{
	    if(PlayerInfo[playerid][pGacc][7]+OrganInfo[wh][gUnitStat][21]*60 > unixtime) return format(store,sizeof(store),"{FF6347}Вы не можете сейчас взять бронежилет [ Через %d мин. ]", ((PlayerInfo[playerid][pGacc][7]+OrganInfo[wh][gUnitStat][21]*60)-unixtime)/60), ErrorMessage(playerid, store);
	    if(PlayerInfo[playerid][pArmor] >= 1) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет");
	    giveThing = 7;
	    yes = 1;
	}
	else if(thingType == 1) // Оружие
	{
	    if(PlayerInfo[playerid][pGacc][4]+OrganInfo[wh][gUnitStat][18]*60 > unixtime) return format(store,sizeof(store),"{FF6347}Вы не можете сейчас взять оружие [ Через %d мин. ]", ((PlayerInfo[playerid][pGacc][4]+OrganInfo[wh][gUnitStat][18]*60)-unixtime)/60), ErrorMessage(playerid, store);
	    giveThing = 4;
	    yes = 1;
	}
	else if(thingType == 0)
	{
	    if(friskKol[fpick] == 1) // Предмет имеет количество
		{
		    DP[0][playerid] = inva;
			new maxQuan = 1000, maxTime;
			if(fpick == 27) maxQuan = OrganInfo[wh][gUnitStat][10], maxTime = PlayerInfo[playerid][pGacc][0]+OrganInfo[wh][gUnitStat][14]*60;
			else if(fpick == 28) maxQuan = OrganInfo[wh][gUnitStat][11], maxTime = PlayerInfo[playerid][pGacc][1]+OrganInfo[wh][gUnitStat][15]*60;
			else if(fpick == 29) maxQuan = OrganInfo[wh][gUnitStat][12], maxTime = PlayerInfo[playerid][pGacc][2]+OrganInfo[wh][gUnitStat][16]*60;
			else if(fpick == 30) maxQuan = OrganInfo[wh][gUnitStat][13], maxTime = PlayerInfo[playerid][pGacc][3]+OrganInfo[wh][gUnitStat][17]*60;
			else if(fpick >= 4 && fpick <= 7) maxQuan = OrganInfo[wh][gUnitStat][22], maxTime = PlayerInfo[playerid][pGacc][8]+OrganInfo[wh][gUnitStat][23]*60;
			
			if(maxTime > 0 && maxTime > unixtime) return format(store,sizeof(store),"{FF6347}Вы не можете сейчас взять этот предмет [ Через %d мин. ]\n\n{cccccc}Ограничения устанавливает руководитель", maxQuan), ErrorMessage(playerid, store);
			format(store,sizeof(store),"{cccccc}Чтобы взять {ff9000}%s {cccccc}введите количество\n\n{cccccc}Не меньше 1 и не больше %d\nЛимиты устанавливает руководитель",friskName[fpick], maxQuan);
			ShowDialog(playerid,967,DIALOG_STYLE_INPUT,"{ff9000}Склад",store,"Принять","Отмена");
			return 1;
		}
		if(fpick == 8) // Аптечка
		{
			if(PlayerInfo[playerid][pGacc][5]+OrganInfo[wh][gUnitStat][19]*60 > unixtime) return format(store,sizeof(store),"{FF6347}Вы не можете сейчас взять предмет [ Через %d мин. ]\n\n{cccccc}Ограничения устанавливает руководитель", ((PlayerInfo[playerid][pGacc][5]+OrganInfo[wh][gUnitStat][19]*60)-unixtime)/60), ErrorMessage(playerid, store);
			giveThing = 5;
		}
		yes = 1;
	}

	if(yes == 1)
	{
	    new fpara;
	    if(thingType == 1) fpara = 300000;
	    if(IsHelmet(fpick) && thingType == 2) fpara = 3;
	    if(IsArmor(fpick) && thingType == 2) fpara = 100;
	    OrganInfo[wh][gInvPara][inva] = fpara;
	
		new put_inva = GiveThingPlayer(playerid, fpick, 1, OrganInfo[wh][gInvPara][inva], 0, OrganInfo[wh][gInvType][inva], 0, useinva); // Выдаём предмет игроку
    	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У меня нет места в инвентаре"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
    	SaveInvent(playerid, put_inva);

    	TakeSklad(wh, fpick, 1, thingType, inva);
		PlayerPlaySound(playerid,1052,0,0,0);
    	PlayerPlaySound(playerid, 36401, 0.0, 0.0, 0.0);

    	if(giveThing > 0) PlayerInfo[playerid][pGacc][giveThing] = unixtime;
    	format(store, sizeof(store), "берёт со склада: %s", GetNameThing(0, fpick, thingType, 0));
		SetPlayerChatBubble(playerid,store,COLOR_PURPLE,20.0,5000);
    	OrgLog(wh, "sklad", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 1, GetNameThing(1, fpick, thingType, 0));
	}
	return 1;
}
stock shift_sklad(playerid, wh, getinva, putinva) // Перемещение предметов внутри инвентаря склада организации (с одной ячейки на другую)
{
	if(OnlineInfo[playerid][oShowInterfaceSklad] == wh)
	{
	    if(PlayerInfo[playerid][pLeader] == 0) return ErrorMessage(playerid, "{FF6347}Перемещать предметы может только лидер"), i_resettabs(playerid);
		if(OrganInfo[wh][gInvent][getinva] == 0) return i_resettabs(playerid);
		else if(OrganInfo[wh][gInvent][putinva] != 0) return 1;
		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
		    if(OnlineInfo[playerid][oShowInterfaceSklad] != OnlineInfo[i][oShowInterfaceSklad]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
		    format(store, sizeof(store), "{FF6347}Склад просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, store);
			i_resettabs(playerid);
			return 1;
		}
		OrganInfo[wh][gInvent][putinva] = OrganInfo[wh][gInvent][getinva];
		OrganInfo[wh][gInv][putinva] = OrganInfo[wh][gInv][getinva];
		OrganInfo[wh][gInvType][putinva] = OrganInfo[wh][gInvType][getinva];
		OrganInfo[wh][gInvPara][putinva] = OrganInfo[wh][gInvPara][getinva];
		OrganInfo[wh][gInvent][getinva] = 0;
		OrganInfo[wh][gInv][getinva] = 0;
		OrganInfo[wh][gInvType][getinva] = 0;
		OrganInfo[wh][gInvPara][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, 0, 0, getinva, 0, 0, 0, 0, 0);
		item_second(playerid, OrganInfo[wh][gInvent][putinva], OrganInfo[wh][gInv][putinva], putinva, 0, 300000, OrganInfo[wh][gInvType][putinva], 0, 0);
		OrganInfo[wh][gUpdateSklad] = 1;
	}
	return 1;
}
stock putsklad(wh, pick, kol, fpara, thingType)
{
	new put_inva = -1, getLimit, bool:stopFind;
	sklad_limit(pick, thingType, getLimit);
	
	for(new inva = 0; inva < 20; inva++)
	{
		if(OrganInfo[wh][gInvent][inva] == pick && OrganInfo[wh][gInvType][inva] == thingType)
		{
		    if(OrganInfo[wh][gInv][inva]+kol > getLimit) // Встроенная проверка на лимит
		    {
		        stopFind = true;
		    }
			else OrganInfo[wh][gInv][inva] += kol, put_inva = inva;
			break;
		}
	}
	if(put_inva == -1 && stopFind == false)
	{
		for(new inva = 0; inva < 20; inva++)
		{
			if(OrganInfo[wh][gInvent][inva] == 0)
			{
				OrganInfo[wh][gInvent][inva] = pick, OrganInfo[wh][gInv][inva] += kol, OrganInfo[wh][gInvPara][inva] = fpara, OrganInfo[wh][gInvType][inva] = thingType, put_inva = inva;
				break;
			}
		}
 	}
 	if(put_inva >= 0)
 	{
 		OrganInfo[wh][gUpdate] = 1;
	 	foreach(Player,i)
		{
			if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowInterfaceSklad] == wh) tilesklad(i, OrganInfo[wh][gInvent][put_inva], OrganInfo[wh][gInv][put_inva], put_inva, thingType);
		}
	}
	return put_inva;
}
stock TakeSklad(g, thingId, quan, thingType, dopinf)
{
	if(OrganInfo[g][gInvent][dopinf] == thingId && OrganInfo[g][gInvType][dopinf] == thingType)
	{
		if(OrganInfo[g][gInv][dopinf]-quan <= 0)
		{
	   		OrganInfo[g][gInvent][dopinf] = 0;
	   		OrganInfo[g][gInv][dopinf] = 0;
	   		OrganInfo[g][gInvType][dopinf] = 0;
	   		OrganInfo[g][gInvPara][dopinf] = 0;
		}
		else OrganInfo[g][gInv][dopinf] -= quan;
	}
	OrganInfo[g][gUpdate] = 1;
	foreach(Player, i)
	{
		if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowInterfaceSklad] == g) tilesklad(i, OrganInfo[g][gInvent][dopinf], OrganInfo[g][gInv][dopinf], dopinf, OrganInfo[g][gInvType][dopinf]);
	}
	return 1;
}
stock SaveSklad(idx) // Сохранение всего склада организации по циклу
{
	format(big_query,sizeof(big_query),"UPDATE `pp_organization` SET `Invent0` = '%d', `Inv0` = '%d', `InvType0` = '%d', `InvPara0` = '%d'",
	OrganInfo[idx][gInvent][0], OrganInfo[idx][gInv][0], OrganInfo[idx][gInvType][0], OrganInfo[idx][gInvPara][0]);

	for(new i = 1; i < 20; i++) format(big_query,sizeof(big_query),"%s, `Invent%d` = '%d', `Inv%d` = '%d', `InvType%d` = '%d', `InvPara%d` = '%d'", big_query,
	i, OrganInfo[idx][gInvent][i], i, OrganInfo[idx][gInv][i], i, OrganInfo[idx][gInvType][i], i, OrganInfo[idx][gInvPara][i]);

    format(big_query,sizeof(big_query),"%s WHERE `frakid` = '%d'", big_query, idx);
	query_empty(pearsq_2, big_query);
	return 1;
}
stock sklad_limit(thingId, thingType, &getLimit) // Проверяем лимиты склада организации
{
	if(thingType == 0) // Обычные Предметы
	{
	    if(thingId >= 4 && thingId <= 8) getLimit = 10000; // Вещества
	    else if(thingId >= 27 && thingId <= 30) getLimit = 20000; // Патроны
	    else getLimit = 1000; // На случай ошибки, остальные предметы лимит 1к
 	}
	else if(thingType == 1) getLimit = 500; // Оружие
    else if(thingType == 2) getLimit = 1000; // Каски и Бронежилеты (Аксессуары)
    else getLimit = 1000; // На случай ошибки, остальные предметы лимит 1к
	return 1;
}

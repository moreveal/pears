
#define MAX_ATM_MONEY 10000 // Дефолтная сумма комиссионных в банкомата (от которой инкассаторы могут выполнять доставку)

stock jobcollector(playerid)
{
	if(PlayerInfo[playerid][pPlacement] >= 1 && PlayerInfo[playerid][pPlacement] != 13) return StopJob(playerid);
	
	new line[100],lines[400];
	if(ServerInfo[53] == 10) format(line,sizeof(line),"{99ff66}Повышенная Оплата: Активна \t \n"), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}Стандартная Оплата \t \n"), strcat(lines,line);
	format(line,sizeof(line),"{0088ff}Как заработать? \t \n"), strcat(lines,line);
	if(GetPVarInt(playerid,"job_stat") != 13) format(line,sizeof(line),"{ff9000}Начать Работу \t \n"), strcat(lines,line);
	else if(GetPVarInt(playerid,"job_stat") == 13) format(line,sizeof(line),"{ff9000}Завершить Работу \t \n"), strcat(lines,line);
	format(line,sizeof(line),"{99ff66}Получить Зарплату \t {99ff66}[ %d$ ]\n", PlayerInfo[playerid][pSalary]), strcat(lines,line);
	ShowDialog(playerid,1338,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Инкассаторы",lines,"Выбор","Отмена");
	return 1;
}

stock dialogCase_CollectorJob(playerid, dialogid, response,listitem)
{
	if(dialogid == 1338)
	{
		if(response)
		{
			if(IsPlayerInRangeOfPoint(playerid,2.0,1089.6284,-1215.5012,18.0118))
			{
				if(listitem == 0)
				{
					new stro[86],sctringo[860];
			        format(stro,sizeof(stro),"{0088ff}Как заработать?"), strcat(sctringo,stro);
			        format(stro,sizeof(stro),"\n\n{cccccc}- Выберите пункт <<Начать Работу>> в этом меню"), strcat(sctringo,stro);
			        format(stro,sizeof(stro),"\n{cccccc}- Отправляйтесь на улицу и возьмите спец.транспорт с парковки"), strcat(sctringo,stro);
			        format(stro,sizeof(stro),"\n{cccccc}- Следуйте по точкам указанным на гпс до банкомата, а после возвращайтесь в банк"), strcat(sctringo,stro);
			        format(stro,sizeof(stro),"\n{cccccc}- Только по перевозки денег в банк в получите зарплату"), strcat(sctringo,stro);
			        ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Инкассаторы",sctringo,"Ок","");
			        return 1;
				}
				if(listitem == 1)
				{
				    if(PlayerInfo[playerid][pPlacement] >= 1 && PlayerInfo[playerid][pPlacement] != 13) return StopJob(playerid);
				    if(GetPVarInt(playerid,"job_stat") != 13)
				    {
				    	if(get_invent2(playerid, 156, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет водительских прав [ Y >> GPS >> Образовательный Центр ]");
				    	if(PlayerInfo[playerid][pMechSkill] == 0) return ErrorMessage(playerid, "{FF6347}Ваш персонаж устал и хочет спать");
				    	SetPVarInt(playerid,"job_stat",13);
						RemovePlayerAttachedObject(playerid,0), PlayerPlaySound(playerid,5600,0,0,0);
				    	SetPlayerAttachedObject(playerid, 0, 19904, 1, 0.067999, 0.044999, 0.000000, 0.000000, 88.199996, 178.000000, 1.053000, 1.141001, 1.016000, 0, 0);
				    	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Отправляйтесь на улицу и возьмите спец.транспорт с парковки\n","*","");
				    }
				    else if(GetPVarInt(playerid,"job_stat") == 13)
				    {
				    	SetPVarInt(playerid,"job_stat",0), RemovePlayerAttachedObject(playerid,0), PlayerPlaySound(playerid,5601,0,0,0);
				    	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы {FF6347}завершили {ffcc66}работу в Инкассаторах","*","");
				    	DisablePlayerRaceCheckpoint(playerid);

						SpawnRentVehicleJob(playerid, 428);
				    }
		    	}
		    	if(listitem == 2)
				{
					if(PlayerInfo[playerid][pPlacement] >= 1 && PlayerInfo[playerid][pPlacement] != 13) return StopJob(playerid);
					if(PlayerInfo[playerid][pSalary] <= 0) return ErrorMessage(playerid, "{FF6347}Вы не выполнили работу");
					new pay = PlayerInfo[playerid][pSalary];
					if(ServerInfo[53] == 9) pay += pay/4;
					paysalary(playerid, pay, 0);
					ApplyAnimation(playerid,"DEALER","shop_pay",4.0, false, false, false, false, false);
					MoneyLog("salary", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", PlayerInfo[playerid][pSalary], "Зарплата Инкассаторы");
					SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Моя зарплата {99ff66}%d$", PlayerInfo[playerid][pSalary]);
					SendDynamicActorMessage(playerid, BotPears[5],"Отлично! Держи деньги");
					PlayerInfo[playerid][pPlacement] = 0, PlayerInfo[playerid][pSalary] = 0;
					mysql_save(playerid, 58);
				}
			}
		}
		return true;
	}
    if(dialogid == 1339)
    {
        if(response)
        {
            if(listitem == 0)
            {
                if (GetPVarInt(playerid,"job_collector") >= 1)
                {
					CloseCollectorToBiz(playerid);
                    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы отменили инкассацию денег","*","");
                }
                else return ErrorMessage(playerid,"{FF6347}Вы не выполняете инкассацию денег");
            }
			if(listitem >= 1 && listitem <= 50)
			{
				if(GetPVarInt(playerid,"job_stat") != 13) return ErrorMessage(playerid,"{FF6347}Вы не работаете инкассатором\n{ffcc66}Устроиться на работу можно [ Y >> GPS >> Работа >> Инкассаторы ]");
                new veh = GetPlayerVehicleID(playerid);
                new model = VehInfo[veh][vModel];
                if(model != 428) return ErrorMessage(playerid,"{FF6347}Вы не на спец. транспорте Securicar\n{ffcc66}Возьмите транспорт на парковке инкассаторов");
                new listterm = List[listitem-1][playerid];
                new listord = ListParam[listitem-1][playerid];
				if(listord == 0) return 1;
                new termid = numnrent(listord);
                if(PlayerInfo[playerid][pBusiness] == listord && server != 0) return ErrorText(playerid, "{FF6347}Вы не можете самостоятельно выполнить инкассацию денег в своём бизнесе"), pc_cmd_checkterm(playerid);
				if(TerminalDelivery[listord - GetBizMin(19)][listterm] != 0) return ErrorText(playerid,"{FF6347}Упс, вы не успели.. Кто-то принял этот заказ");

				CreateTermCollector(playerid, listord, listterm);
                SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Отправляйтесь к банкомату для снятия денег (отмечено в GPS Навигаторе)");
                CreateGps(playerid,RentPos_X[termid][listterm],RentPos_Y[termid][listterm],RentPos_Z[termid][listterm],0, 0, 10.0);
			}
        }
		return true;
    }
    if(dialogid == 1340)
    {
        if(response)
		{
			if(IsPlayerInRangeOfPoint(playerid,3.0,1107.387, -1216.869, 17.804))
			{
			    if(listitem >= 1 || listitem < 0) return 1;
				if(IsPlayerInAnyVehicle(playerid)) return ErrorMessage(playerid, "{FF6347}Нельзя арендовать транспорт сидя в транспорте");
				if(get_invent2(playerid, 156, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет водительских прав [ Y >> GPS >> Образовательный Центр ]");
				if(GetPVarInt(playerid,"job_stat") != 13) return ErrorMessage(playerid, "{FF6347}Зайдите в будку и начните дежурство, прежде чем брать транспорт");
				new unix = gettime();
				if(PlayerInfo[playerid][pRent][0] > unix && PlayerInfo[playerid][pRent][1] > unix) return ErrorMessage(playerid, "{FF6347}У вас уже два арендованных транспорта [ Y >> Транспорт или /car ]");
	            new model, newcar;
            	if(listitem == 0) newcar = PP_CreateVehicle(428,1107.387, -1216.869, 17.804,1.1,6,1,600,0, -1, 0.0), model = 428;
				SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Я могу посмотреть список всех доступных банкоматов [ /atm ]");
                Gas[newcar] = 100;
	   			VehInfo[newcar][vAgetid] = playerid;
	   			VehInfo[newcar][vRent] = unix+3600;
	   			VehInfo[newcar][vBiz] = 0;
	   			VehInfo[newcar][vBizItem] = 0;
	   			Cars[newcar] = 53;
                new tyear, tmonth, tday, thour, tminute, tsecond;
                stamp2datetime(VehInfo[newcar][vRent], tyear, tmonth, tday, thour, tminute, tsecond, 3);

				ReloadVehicleLabel(newcar); // Перезагружаем лейбл на тс
                VehInfo[newcar][v3dstat] = 4000;

				new string[90];
                format(string,sizeof(string),"{cccccc}Аренда до {0088ff}%02d:%02d\n{444444}%s", thour, tminute, PlayerInfo[playerid][pName]);
                VehLabel[newcar] = CreateDynamic3DTextLabel(string,0xfaf75c99, 1107.387, -1216.869, 17.804,1.0,INVALID_PLAYER_ID, newcar,0,0,0);
	   			Protect_PutPlayerInVehicle(playerid, newcar, 0);
	   			CreateRent_Player(playerid, unix, newcar, 6, 100, model, 0, 0, 1107.387, -1216.869, 17.804,1);
			}
		}
		return true;
    }
    return false;
}

stock CreateTermCollector(playerid, whrom, term)
{
	SetPVarInt(playerid,"job_collector",whrom);
	SetPVarInt(playerid,"job_collector_term",term);
	SetPVarInt(playerid,"job_collector_status",1);
	TerminalDelivery[whrom - GetBizMin(19)][term] = 1;
	return 1;
}

stock CloseCollectorToBiz(playerid)
{
	new b = GetPVarInt(playerid,"job_collector");
	TerminalDelivery[b - GetBizMin(19)][GetPVarInt(playerid,"job_collector_term")] = 0;
	SetPVarInt(playerid,"job_collector",0);
	SetPVarInt(playerid,"job_collector_term",0);
	SetPVarInt(playerid,"job_collector_status",0);
	return true;
}

alias:checkterm("atm")
CMD:checkterm(playerid)
{
	new quan;
	new line[214],lines[4096];
	ClearList(playerid);

    format(line,sizeof(line),"Номер бизнеса\tДенег в банкомате\tОплата"), strcat(lines,line);
    format(line,sizeof(line),"\n{FF6347}Отменить Инкассацию\t\t "), strcat(lines,line);

	new minb = GetBizMin(19);
    for(new b = 163; b <= 172; b++)
	{
		if(b < 163 || b > 172) continue; // На всякий пожарный оставлю эту гавнину

        for(new i = 0; i < 5; i++)
	    {
            if(BizzInfo[b][bItem][i] == 0
				|| TerminalDelivery[b - minb][i] != 0) continue;

            if(RentStat[b-137][i] > 0 
				&& BizzInfo[b][bItem][i] >= BizzInfo[b][bAtmCollector] 
				&& BizzInfo[b][bDeliveryPay] > 0)
            {
                List[quan][playerid] = i;
                ListParam[quan][playerid] = b;
                quan ++;
                format(line,sizeof(line),"\n{ff9000}Банк № %d\t{cccccc}%d$ \t%d$", b, BizzInfo[b][bItem][i], BizzInfo[b][bDeliveryPay]), strcat(lines,line);
            }
        }
	}
    if(quan < 0) return ErrorMessage(playerid,"{FF6347}В данный момент ни один из банкоматов не заполнен");
	ShowDialog(playerid,1339,DIALOG_STYLE_TABLIST_HEADERS,"Инкассация Денег",lines,"Выбрать","Отмена");
	return 1;
}
stock agetcollector(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid,3.0,1107.387, -1216.869, 17.804))
	{
		ShowDialog(playerid,1340,2,"{ff9000}Транспорт Инкасаторов", "Securicar ","Выбрать","Выход");
  	}
    return 1;
}

stock CloseCollector(playerid)
{
	new b = GetPlayerVirtualWorld(playerid)-3000;
	new term = GetPVarInt(playerid,"job_collector_term");
	if(GetPVarInt(playerid,"job_collector") != b || GetPVarInt(playerid,"job_collector_status") != 2) return ErrorMessage(playerid, "{FF6347}Вы не работаете инкасатором или не выполняете доставку в этот банк");
	if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, false);
	paybiz(b,BizzInfo[b][bItem][term]);
	BizzInfo[b][bDeposit] -= BizzInfo[b][bDeliveryPay];
	PlayerInfo[playerid][pPlacement] = 13;
	PlayerInfo[playerid][pSalary] += BizzInfo[b][bDeliveryPay];
	mysql_save(playerid, 58);
	CloseCollectorToBiz(playerid);
	new br = numnrent(b);
	UpdateLabelTerm(b,br,term);
	BizzInfo[b][bItem][term] = 0;
	BizzInfo[b][bUpdate] = 1;
	SuccessMessage(playerid,"{99ff66}Деньги доставлены\n{ffcc66}Вы можете забрать зарплату на базе инкассаторов\nили сесть в Securicar и продолжить работу");
	SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я могу забрать зарплату на базе инкассаторов или продолжить работу");
	RemovePlayerAttachedObject(playerid,1);
	return 1;
}

stock FindBankFromCollector(playerid)
{
	new Float:dist, Float:findpos, findBiz = 26, kakoi, quan;
	dist = GetPlayerDistanceFromPoint(playerid, RentPos_X[26][0], RentPos_Y[26][0], RentPos_Z[26][0]);
	for(new b = 26; b <= 35; b++)
	{
		for(new i = 0; i < MAX_TERMINAL_BIZ; i++)
		{
			if(BizzInfo[b][bItem][i] == 0
				|| TerminalDelivery[b - 26][i] != 0) continue;

		    if(RentStat[b][i] > 0 
				&& BizzInfo[b+137][bItem][i] > BizzInfo[b+137][bAtmCollector] 
				&& BizzInfo[b+137][bDeliveryPay] > 0)
		    {
		        quan ++;
	    		findpos = GetPlayerDistanceFromPoint(playerid, RentPos_X[b][i], RentPos_Y[b][i], RentPos_Z[b][i]);
	    		if(findpos <= dist) dist = findpos, kakoi = i, findBiz = b;
			}
		}
	}
	if(quan == 0) return ErrorMessage(playerid, "{FF6347}Все банкоматы были обслуженны\n{ffcc66}Деньги в банкоматах накапливаются со временем");

	new correctB = rentnumn(findBiz);
	CreateTermCollector(playerid, correctB, kakoi);
	new string[200];
	format(string,sizeof(string),"{ff9000}Ближайший Банкомат: %s {99ff66}отмечен на карте\n{cccccc}Бизнес № %d | Банкомат № %d | Денег в банкомате %d$\nОплата инкассации: {99ff66}%d$", 
		BizzInfo[correctB][bName], correctB, kakoi+1, BizzInfo[correctB][bItem], BizzInfo[correctB][bDeliveryPay]);
	SuccessMessage(playerid, string);
	CreateGps(playerid, RentPos_X[findBiz][kakoi], RentPos_Y[findBiz][kakoi], RentPos_Z[findBiz][kakoi], 0, 0, 5.0);
	return 1;
}

stock MessageCollectorBank(playerid)
{
	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Пройдите к двери и спуститесь в хранилище","*","");
	SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мне нужно спуститься в хранилище, чтобы доставить деньги");
	return true;
}

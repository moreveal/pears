
stock jobcollector(playerid)
{
	if(PlayerInfo[playerid][pPlacement] >= 1 && PlayerInfo[playerid][pPlacement] != 13) return StopJob(playerid);
	
	new line[100],lines[400];
	if(ServerInfo[53] == 9) format(line,sizeof(line),"{99ff66}Повышенная Оплата: Активна \t \n"), strcat(lines,line);
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
				    }
		    	}
		    	if(listitem == 2)
				{
					if(PlayerInfo[playerid][pPlacement] >= 1 && PlayerInfo[playerid][pPlacement] != 10) return StopJob(playerid);
					if(PlayerInfo[playerid][pSalary] <= 0) return ErrorMessage(playerid, "{FF6347}Вы не выполнили работу");
					new pay = PlayerInfo[playerid][pSalary];
					if(ServerInfo[53] == 9) pay += pay/4;
					paysalary(playerid, pay, 0);
					ApplyAnimation(playerid,"DEALER","shop_pay",4.0, 0, 0, 0, 0, 0);
					MoneyLog("salary", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", PlayerInfo[playerid][pSalary], "Зарплата Инкассаторы");
					SendClientMessagef(playerid, COLOR_GREY, "[ Мысли ]: Моя зарплата {99ff66}%d$", PlayerInfo[playerid][pSalary]);
					SendActorMessage(playerid, 1,BotPears[5],"Отлично! Держи деньги");
					PlayerInfo[playerid][pPlacement] = 0, PlayerInfo[playerid][pSalary] = 0, PlayerInfo[playerid][pSalarytwo] = 0;
					mysql_save(playerid, 58);
				}
			}
		}
	}
    if(dialogid == 1339)
    {
        if(response)
        {
            if(listitem == 0)
            {
                if (GetPVarInt(playerid,"job_collector") >= 1)
                {
                    BizzInfo[GetPVarInt(playerid,"job_collector")][bDeliveryOrder] = -1;
                    SetPVarInt(playerid,"job_collector",0);
                    SetPVarInt(playerid,"job_collector_term",0);
                    SetPVarInt(playerid,"job_collector_status",0);
                    ErrorMessage(playerid,"Я отменил перевозку денег");
                }//ОТМЕНИТЬ
                else return ErrorMessage(playerid,"Я не выполняю перевозку денег");
            }
			if(listitem >= 1 && listitem <= 50)
			{
                new veh = GetPlayerVehicleID(playerid);
                new model = VehInfo[veh][vModel];
                if(model != 428) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не на спец.транспорте(Securicar)");
                new listterm = List[listitem-1][playerid];
                new listord = ListParam[listitem-1][playerid];
                new termid = numnrent(listord);
                if(PlayerInfo[playerid][pBusiness] == listord && server != 0) return ErrorText(playerid, "[ Мысли ]: Я не могу самостоятельно выполнять заказы в своём бизнесе"), cmd_checkterm(playerid);
				if(BizzInfo[listord][bDeliveryOrder] >= 0) return ErrorText(playerid, "[ Мысли ]: Заказ недоступен, его уже кто-то забрал.."), cmd_checkterm(playerid);

				BizzInfo[listord][bDeliveryOrder] = playerid;
				SetPVarInt(playerid,"job_collector",listord);
                SetPVarInt(playerid,"job_collector_term",listterm+1);
                SetPVarInt(playerid,"job_collector_status",1);
                SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Отправляйтесь к банкомату для снятия денег(отмечено в GPS Навигаторе)");
                CreateGps(playerid,RentPos_X[termid][listterm],RentPos_Y[termid][listterm],RentPos_Z[termid][listterm],0, 0, 10.0);
			}
        }
    }
    if(dialogid == 1340)
    {
        if(response)
		{
			if(IsPlayerInRangeOfPoint(playerid,3.0,1107.387, -1216.869, 17.804))
			{
			    if(listitem > 1 || listitem < 0) return 1;
				if(IsPlayerInAnyVehicle(playerid)) return ErrorMessage(playerid, "{FF6347}Нельзя арендовать транспорт сидя в транспорте");
				if(get_invent2(playerid, 156, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет водительских прав [ Y >> GPS >> Образовательный Центр ]");
				if(GetPVarInt(playerid,"job_stat") != 13) return ErrorMessage(playerid, "{FF6347}Зайдите в будку и начните дежурство, прежде чем брать транспорт");
				new unix = gettime();
				if(PlayerInfo[playerid][pRent][0] > unix && PlayerInfo[playerid][pRent][1] > unix) return ErrorMessage(playerid, "{FF6347}У вас уже два арендованных транспорта [ Y >> Транспорт или /car ]");
	            new model, newcar;
            	if(listitem == 0) newcar = PP_CreateVehicle(newcar,428,1107.387, -1216.869, 17.804,1.1,6,1,600,0, -1, 0.0), model = 428;
                Gas[newcar] = 100;
	   			VehInfo[newcar][vAgetid] = playerid;
	   			VehInfo[newcar][vRent] = unix+3600;
	   			VehInfo[newcar][vBiz] = 0;
	   			VehInfo[newcar][vBizItem] = 0;
	   			Cars[newcar] = 53;
                new tyear, tmonth, tday, thour, tminute, tsecond;
                stamp2datetime(VehInfo[newcar][vRent], tyear, tmonth, tday, thour, tminute, tsecond, 3);
                VehInfo[newcar][v3dstat] = 4000;

				new string[90];
                format(string,sizeof(string),"{cccccc}Аренда до {0088ff}%02d:%02d\n{444444}%s", thour, tminute, PlayerInfo[playerid][pName]);
                VehLabel[newcar] = CreateDynamic3DTextLabel(string,0xfaf75c99, 1107.387, -1216.869, 17.804,1.0,INVALID_PLAYER_ID, newcar,0,0,0);
	   			Protect_PutPlayerInVehicle(playerid, newcar, 0);
	   			CreateRent_Player(playerid, unix, newcar, 6, 100, model, 0, 0, 1107.387, -1216.869, 17.804,1);
			}
		}
    }
    return 1;
}

CMD:checkterm(playerid)
{
    if(PlayerInfo[playerid][pPlacement] == 13) return ErrorMessage(playerid,"Вы не работаете инкассатаром!");
	new quan;
	new line[100],lines[2000];

    format(line,sizeof(line),"{FF6347}Номер бизнеса\t Денег в терминале\tОплата "), strcat(lines,line);
    format(line,sizeof(line),"\n{FF6347}Отменить Доставку \t\t "), strcat(lines,line);
    for(new b = 163; b < 172; b++)
	{
        for(new i = 0; i < 5; i++)
	    {
            if(BizzInfo[b][bItem][i] == 0) continue;

            if(BizzInfo[b][bItem][i] > 1000 && BizzInfo[b][bDeliveryOrder] < 0)
            {
                List[quan][playerid] = i;
                ListParam[quan][playerid] = b;
                quan ++;
                format(line,sizeof(line),"\n{ff9000}%d.%d\t{cccccc}%d$ \t%d", quan,b, BizzInfo[b][bItem][i], BizzInfo[b][bDeliveryPay]), strcat(lines,line);
            }
        }
	}
    if(quan < 0) return ErrorMessage(playerid,"В данный момент не один из терминалов не заполнен");
	ShowDialog(playerid,1339,DIALOG_STYLE_TABLIST_HEADERS,"Инкасаторские заказы",lines,"Выбрать","Отмена");
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
	new term = GetPVarInt(playerid,"job_collector_term")-1;
	if(BizzInfo[b][bDeliveryOrder] < 0 || GetPVarInt(playerid,"job_collector") != b || GetPVarInt(playerid,"job_collector_status") != 2) return ErrorMessage(playerid, "{FF6347}Вы не работаете инкасатором или не выполняете доставку в данный банк.");
	if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
	paybiz(b,BizzInfo[b][bItem][term]);
	BizzInfo[b][bDeposit] -= BizzInfo[b][bDeliveryPay];
	PlayerInfo[playerid][pSalary] += BizzInfo[b][bDeliveryPay];
	mysql_save(playerid,58);
	SetPVarInt(playerid,"job_collector",0);
	SetPVarInt(playerid,"job_collector_term",0);
	SetPVarInt(playerid,"job_collector_status",0);
	new br = numnrent(b);
	UpdateLabelTerm(b,br,term);
	BizzInfo[b][bDeliveryOrder] = -1;
	BizzInfo[b][bItem][term] = 0, BizzInfo[b][bUpdate] = 1;
	SuccessMessage(playerid,"Деньги доставлены!\nВы можете сесть дальше в транспорт инкассаторов\n и продолжить работать(/checkterm)");
	RemovePlayerAttachedObject(playerid,1);
	return 1;
}
#define MIN_PAY_ELECTRICIAN 3000
#define MIN_PROCENT_REPAIRTERMINAL 5000

new ElectricianProccessTime[MAX_REALPLAYERS];
new ElectricianProccessTimers[MAX_REALPLAYERS];
new Float:ElectricianProccessObjectHouse[MAX_REALPLAYERS][3];

stock dialogElectricianToHouse(playerid, b)
{
	new lines[300], string[60];
	format(lines,sizeof(lines),"\n{cccccc}Введите сумму, которую будет получать электрик за один дом\
								\n\nТекущая минимальная сумма за один дом: {99ff66}%d$\
								\n{FF6347}Не меньше %d$ и не больше 1.000.000$", BizzInfo[b][bElectroPayForConnect], MIN_PAY_ELECTRICIAN);
	format(string,sizeof(string),"{cccccc}Бизнес {ff9000}%s [%d]",bizname(b), b);
	ShowDialog(playerid,ELECTRICIAN_DIALOG_PAYMENTHOUSE,DIALOG_STYLE_INPUT, string, lines, "Принять", "Отмена");
	return true;
}

stock dialogElectricianToTerminal(playerid, b)
{
	new lines[300], string[60];
	format(lines,sizeof(lines),"\n{cccccc}Введите сумму, которую будет получать электрик за один терминал\
                                \n{cccccc}Терминалы ломаются от зарядки и всегда нуждаются в ремонте\
								\n\nТекущая минимальная сумма за один терминал: {99ff66}%d$\
								\n{FF6347}Не меньше %d$ и не больше 1.000.000$", BizzInfo[b][bElectroPayForRepair], MIN_PAY_ELECTRICIAN);
	format(string,sizeof(string),"{cccccc}Бизнес {ff9000}%s [%d]",bizname(b), b);
	ShowDialog(playerid,ELECTRICIAN_DIALOG_PAYMENTTERMINAL,DIALOG_STYLE_INPUT, string, lines, "Принять", "Отмена");
	return true;
}

stock dialogElectricianJob(playerid)
{
	new lines[300], string[60];
	format(lines,sizeof(lines),"{0088ff}Как заработать? \t\
                                \n{ff9000}%s работу \t\
								\n{99ff66}Получить Зарплату \t{99ff66}[ %d$ ]", GetPVarInt(playerid,"job_stat") != 14 ? "Начать" : "Завершить", PlayerInfo[playerid][pSalary]);
	format(string,sizeof(string),"{ff9000}Электрики \t");
	ShowDialog(playerid,ELECTRICIAN_DIALOG_GOJOB,DIALOG_STYLE_TABLIST, string, lines, "Принять", "Отмена");
	return true;
}

stock dialogElectricianJobComplete(playerid,type)
{
	new lines[300], string[60];
	format(lines,sizeof(lines),"{99ff66}%s\
                                \n\n{ffcc66}Вы можете забрать зарплату на базе электриков\t\
								\nили сесть в Ford Econoline и продолжить работу", type == 2 ? "Электрозарядная станция отремонтирована" : "Дом подключен к электростанции");
	format(string,sizeof(string),"{ff9000}Электрики \t");
	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX, string, lines, "*", "");
    PlayerPlaySound(playerid,6401,0,0,0);
	return true;
}

stock dialogElectricianHelp(playerid)
{
	new lines[520], string[60];
	format(lines,sizeof(lines),"\n{0088ff}Как заработать?\
                                \n\n{cccccc}- Выберите пункт \"Начать Работу\" в этом меню\
								\n{cccccc}- Отправляйтесь на улицу и возьмите спец. транспорт с парковки\
                                \n{cccccc}- Следуйте по точкам указанным в GPS до терминалов или домов\
                                \n{cccccc}и выполняйте работу на точках. У домов стоит {ff9000}специальный щиток на улице(Объект электрощитка){cccccc},\
                                \n{cccccc}к которому нужно подойти и нажать [ {ff9000}ALT {cccccc}] и пройти миниигру.\
                                \n{cccccc}У терминалов вам нужно подойти к самому терминалу нажать [ {ff9000}ALT {cccccc}] и пройти миниигру");
	format(string,sizeof(string),"{ff9000}Электрики \t");
	ShowDialog(playerid,ELECTRICIAN_DIALOG_GOJOB,DIALOG_STYLE_MSGBOX, string, lines, "Назад", "");
	return true;
}

stock dialogElectricianReconnect(playerid, d,b)
{
    DP[4][playerid] = b, DP[3][playerid] = d;
	new lines[520], string[60];
	format(lines,sizeof(lines),"\n{0088ff}Смена электростанции\
                                \n\n{cccccc}- При смени электростанции ваша сумма дневного платежа изменится\
								\n{cccccc}- В данный момент вы платите в день {44ff99}%d${cccccc}, после переподключения дома будете платить {44ff99}%d$\
                                \n{cccccc}- За переподключение вам не придется платить деньги. Расходы покрывает бизнес\
                                \n{cccccc}- Смена электростанции доступна раз в сутки!\
                                \n\n{ff9000}Сменить электростанцию?",\
                                BizzInfo[DomInfo[d][dElectroConnect]][bPrice][0]*12,BizzInfo[b][bPrice][0]*12);
	format(string,sizeof(string),"{ff9000}Смена Электростанции \t");
	ShowDialog(playerid,ELECTRICIAN_DIALOG_HOUSESELECTCONNECT,DIALOG_STYLE_MSGBOX, string, lines, "Да", "Нет");
	return true;
}

stock dialogECTSucssesMessage(playerid)
{
	new lines[300], string[60];
	format(lines,sizeof(lines),"\n{ff9000}Вы начали зарядку электрокара {0088ff}%s\
								\n\n{cccccc}Зарядка продлится {0088ff}%d {cccccc}секунд\
                                \nОплата за зарядку произойдет автоматически. Деньги спишутся с банковского счета\
								\nЕсли транспорт будет далеко от станции зарядки, она прервется!", GetVehicleName(VehInfo[zaprcarElectro[playerid]][vModel]), zaprcarElectroTimer[playerid]);
	format(string,sizeof(string),"{ff9000}Зарядная станция");
	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX, string, lines, "*", "");
	return true;
}

stock UpdateElectricianMoneyForWork(playerid, b, const inputtext[], type)
{
	new input = strval(inputtext);
	if((input < MIN_PAY_ELECTRICIAN || input > 1000000) && type == 1) return dialogElectricianToHouse(playerid, b);
    else if((input < MIN_PAY_ELECTRICIAN || input > 1000000) && type == 2) return dialogElectricianToTerminal(playerid, b);

    if(type == 1)
    {
        BizzInfo[b][bElectroPayForConnect] = input;
        productbiz(playerid, b);

        new string[160];
        mysql_format(pearsq, string, sizeof(string),"UPDATE `pp_bizz` SET `bElectroPayForConnect` = '%d' WHERE `newid` = '%d'", BizzInfo[b][bElectroPayForConnect], b);
        mysql_tquery(pearsq, string);

        format(string,sizeof(string),"Оплата за подключение дома %s", get_k(BizzInfo[b][bElectroPayForConnect]));
        BizLog("ElectroPayForConnect", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], b, input, string);
    }
    else if(type == 2)
    {
        BizzInfo[b][bElectroPayForRepair] = input;
        productbiz(playerid, b);

        new string[160];
        mysql_format(pearsq, string, sizeof(string),"UPDATE `pp_bizz` SET `bElectroPayForRepair` = '%d' WHERE `newid` = '%d'", BizzInfo[b][bElectroPayForRepair], b);
        mysql_tquery(pearsq, string);

        format(string,sizeof(string),"Оплата за ремонт терминала %s", get_k(BizzInfo[b][bElectroPayForRepair]));
        BizLog("ElectroPayForRepair", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], b, input, string);
    }
	return true;
}

stock TotalFindElectrician(playerid)
{
    if(GetPVarInt(playerid,"job_electrician_point") != 0) return 0;
    if(FindTerminalFromElectrician(playerid)) return 1;
    else if(FindHouseFromElectrician(playerid)) return 1;
    else return 0;
}

stock FindTerminalFromElectrician(playerid)
{
	new Float: dist, Float: findpos, termId, bizId;
	dist = GetPlayerDistanceFromPoint(playerid, RentPos_X[46][0], RentPos_Y[46][0], RentPos_Z[46][0]);
	for(new b = 46; b <= 55; b++)
	{
		new currentBizId = rentnumn(b);
		for(new i = 0; i < MAX_TERMINAL_BIZ; i++)
		{
			if(BizzInfo[currentBizId][bItem][i] < MIN_PROCENT_REPAIRTERMINAL) continue;
			if(BizzInfo[currentBizId][bElectroPayForRepair] <= 0 || BizzInfo[currentBizId][bDeposit] < BizzInfo[currentBizId][bElectroPayForRepair]) continue;
			if(RentStat[b][i] <= 0) continue;
            if(ElectricianRepair[currentBizId - GetBizMin(17)][i] == 1) continue;
			findpos = GetPlayerDistanceFromPoint(playerid, RentPos_X[b][i], RentPos_Y[b][i], RentPos_Z[b][i]);
			if(findpos <= dist) dist = findpos, termId = i, bizId = currentBizId;
		}
	}
	if (!bizId) return 0;

	CreateElectrician(playerid, bizId, termId,2);
	new string[200];
	format(string,sizeof(string),"{ff9000}Ближайшая зарядочная станция: %s {99ff66}отмечена на карте\n{cccccc}Бизнес № %d | Зарядочная станция № %d\nОплата ремонта: {99ff66}%d$", 
		BizzInfo[bizId][bName], bizId, termId + 1, BizzInfo[bizId][bElectroPayForRepair]);
	SuccessMessage(playerid, string);

	new rentNumber = numnrent(bizId);
	CreateGps(playerid, RentPos_X[rentNumber][termId], RentPos_Y[rentNumber][termId], RentPos_Z[rentNumber][termId], 0, 0, 5.0);

	return 1;
}

stock FindHouseFromElectrician(playerid)
{
	new Float: dist, Float: findpos, domId, bizId;
	dist = GetPlayerDistanceFromPoint(playerid, DomInfo[1][dKoordinatX], DomInfo[1][dKoordinatY], DomInfo[1][dKoordinatZ]);
	for(new d = 1; d <= 1000; d++)
	{
        if(DomInfo[d][dElectroStatus] == 0) continue;
        if(ElectricianConnect[d] == 1) continue;
        bizId = DomInfo[d][dElectroStatus];
        if(BizzInfo[bizId][bElectroPayForConnect] <= 0 || BizzInfo[bizId][bDeposit] < BizzInfo[bizId][bElectroPayForConnect]) continue;
        if(!GetElectroObject(d)) continue;
        findpos = GetPlayerDistanceFromPoint(playerid, DomInfo[d][dKoordinatX], DomInfo[d][dKoordinatY], DomInfo[d][dKoordinatZ]);
        if(findpos <= dist) dist = findpos, domId = d;
    }
	if (!bizId || !domId) return 0;

	CreateElectrician(playerid, bizId, domId, 0);
	new string[200];
	format(string,sizeof(string),"{ff9000}Ближайший дом для подключения отмечен на карте\n{cccccc}Бизнес № %d | Дом № %d\nОплата за подключения: {99ff66}%d$", 
		bizId, domId, BizzInfo[bizId][bElectroPayForConnect]);
	SuccessMessage(playerid, string);

	CreateGps(playerid, DomInfo[domId][dKoordinatX], DomInfo[domId][dKoordinatY], DomInfo[domId][dKoordinatZ], 0, 0, 5.0);

	return 1;
}

stock CreateElectrician(playerid, b, where, type)
{
	SetPVarInt(playerid,"job_electrician", b);
	SetPVarInt(playerid,"job_electrician_point", where);
	SetPVarInt(playerid,"job_electrician_type", type);
	if(type == 2) ElectricianRepair[b - GetBizMin(17)][where] = 1;
    else ElectricianConnect[where] = 1;
	return 1;
}

stock CloseElectricianClear(playerid)
{
	new b = GetPVarInt(playerid, "job_electrician");
	if(GetPVarInt(playerid,"job_electrician_type") == 2) ElectricianRepair[b - GetBizMin(17)][GetPVarInt(playerid,"job_electrician_point")] = 0;
    else ElectricianConnect[GetPVarInt(playerid,"job_electrician_point")] = 0;
	SetPVarInt(playerid,"job_electrician", 0);
	SetPVarInt(playerid,"job_electrician_point", 0);
	SetPVarInt(playerid,"job_electrician_type", 0);
	return true;
}

stock ElectrostationHouseList(playerid,d)
{
    new line[256],lines[4096];
    format(line,sizeof(line),"{ff9000}Электростанция\t{44ff99}Статус\tОплата в день\n"), strcat(lines,line);
    for(new b = 143; b <= 152; b++)
    {  
        if(DomInfo[d][dElectroConnect] == b) format(line,sizeof(line),"{ff9000}%s\t{44ff99}Подключена\t {cccccc}[ {44ff99}%d$ {cccccc}]\n", BizzInfo[b][bName],12*BizzInfo[b][bPrice][0]), strcat(lines,line);
        else if(DomInfo[d][dElectroStatus] == b) format(line,sizeof(line),"{ff9000}%s\t{cccccc}Ожидается подключение\t {cccccc}[ {44ff99}%d$ {cccccc}]\n", BizzInfo[b][bName],12*BizzInfo[b][bPrice][0]), strcat(lines,line);
        else format(line,sizeof(line),"{ff9000}%s\t \t {cccccc}[ {44ff99}%d$ {cccccc}]\n", BizzInfo[b][bName],12*BizzInfo[b][bPrice][0]), strcat(lines,line);
    }
	return ShowDialog(playerid,ELECTRICIAN_DIALOG_HOUSELIST,DIALOG_STYLE_TABLIST_HEADERS,"Список электростанций",lines,"Выбрать","Выход");
}

stock ElectricianStopProcess(playerid, stat)
{
    ClearAnimations(playerid);
	ClearAnim(playerid);

    DP[0][playerid] = 0;
    InputProcess[playerid] = 0;
	InputID[playerid] = 0;
    KillTimer(ElectricianProccessTimers[playerid]);
    ElectricianProccessTimers[playerid] = 0;
    ElectricianProccessTime[playerid] = 0;

    if (stat == 0) {
        PlayerPlaySound(playerid, 31200);
    } else if (stat == 1) {
        CloseElectrician(playerid);
    }
    ElectricianProccessObjectHouse[playerid][0] = 0.0, ElectricianProccessObjectHouse[playerid][1] = 0.0, ElectricianProccessObjectHouse[playerid][2] = 0.0;
    for (new i = 0; i <= 5; i++) TextDrawHideForPlayer(playerid, InputDraw[i]);
    PlayerTextDrawHide(playerid, InputDraw1);
	PlayerTextDrawHide(playerid, InputDraw2);

    return 1;
}

stock CloseElectrician(playerid)
{
    new b = GetPVarInt(playerid,"job_electrician"), term = GetPVarInt(playerid,"job_electrician_point"), type = GetPVarInt(playerid,"job_electrician_type");
    if(type == 2) BizzInfo[b][bItem][term] = 0, BizzInfo[b][bDeposit] -= BizzInfo[b][bElectroPayForRepair], PlayerInfo[playerid][pSalary] += BizzInfo[b][bElectroPayForRepair];
    else DomInfo[term][dElectroUnix] = gettime(),DomInfo[term][dElectroStatus] = 0,DomInfo[term][dElectroConnect] = b, BizzInfo[b][bDeposit] -= BizzInfo[b][bElectroPayForConnect], PlayerInfo[playerid][pSalary] += BizzInfo[b][bElectroPayForConnect], SaveElectro_Dom(term);
   
    PlayerInfo[playerid][pPlacement] = 14;
    BizzInfo[b][bUpdate] = 1;

    mysql_save(playerid, 58);
    CloseElectricianClear(playerid);
    dialogElectricianJobComplete(playerid,type);
    return 1;
}

stock ECTHouse(playerid)
{
    new d = IsAWardrobeDom(playerid);
    if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вас преследует полиция");
    if(howstun(playerid) || HealthAC[playerid] <= 0) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
    if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return ErrorMessage(playerid, "{FF6347}Вы находитесь в слежке");
    if(GetPlayerVirtualWorld(playerid) != 0) return 0;

    if(GetPVarInt(playerid,"job_electrician_point") == d && GetPVarInt(playerid,"job_electrician_type") == 0) 
    {
        if(PlayerInfo[playerid][pRentModel][1] != 2091 && PlayerInfo[playerid][pRentModel][0] != 2091) return ErrorMessage(playerid, "{FF6347}Вы не арендуете Ford Econoline, а в нем инструменты для ремонта!");
        if(IsVehicleInRangeOfPoint(PlayerInfo[playerid][pRentVeh][1], 50.0, DomInfo[d][dKoordinatX], DomInfo[d][dKoordinatY], DomInfo[d][dKoordinatZ]) 
            || IsVehicleInRangeOfPoint(PlayerInfo[playerid][pRentVeh][0], 50.0, DomInfo[d][dKoordinatX], DomInfo[d][dKoordinatY], DomInfo[d][dKoordinatZ])) 
        {
            if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "OTB", "betslp_loop", 4.0, false, true, true, false, false, SYNC_ALL);
            GetPlayerPos(playerid,ElectricianProccessObjectHouse[playerid][0],ElectricianProccessObjectHouse[playerid][1],ElectricianProccessObjectHouse[playerid][2]);
            PlayerTextDrawShow(playerid, InputDraw1);
            PlayerTextDrawShow(playerid, InputDraw2);
            TextDrawShowForPlayer(playerid, InputDraw[1]);
            processbar2(playerid, 0);
            ShowInput(playerid);
            InputType[playerid] = 2;
            ElectricianProccessTime[playerid] = 10;
            ElectricianProccessTimers[playerid] = SetTimerEx("ElectricianProccessTimer", 300, true, "d", playerid);
        }
        else ErrorMessage(playerid, "{FF6347}Транспорт электриков далеко от дома");
	}
    else return 0;
    return 1;
}

stock ECT(playerid, br, term)
{
	DP[0][playerid] = rentnumn(br), DP[1][playerid] = br, DP[2][playerid] = term;
	new b = DP[0][playerid];

    if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вас преследует полиция");
    if(howstun(playerid) || HealthAC[playerid] <= 0) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
    if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return ErrorMessage(playerid, "{FF6347}Вы находитесь в слежке");
    if(zaprcarElectroTimer[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Я уже заряжаю электрокар");

	PlayerPlaySound(playerid,40405,0,0,0);
    if(GetPVarInt(playerid,"job_electrician") == b && GetPVarInt(playerid,"job_electrician_point") == term && GetPVarInt(playerid,"job_electrician_type") == 2) 
    {
        if(PlayerInfo[playerid][pRentModel][1] != 2091 && PlayerInfo[playerid][pRentModel][0] != 2091) return ErrorMessage(playerid, "{FF6347}Вы не арендуете транспорт электриков,а в нем инструменты для ремонта!");
        if(IsVehicleInRangeOfPoint(PlayerInfo[playerid][pRentVeh][1], 50.0, RentPos_X[br][term], RentPos_Y[br][term], RentPos_Z[br][term]) 
            || IsVehicleInRangeOfPoint(PlayerInfo[playerid][pRentVeh][0], 50.0, RentPos_X[br][term], RentPos_Y[br][term], RentPos_Z[br][term])) 
        {
            if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "OTB", "betslp_loop", 4.0, false, true, true, false, false, SYNC_ALL);

            PlayerTextDrawShow(playerid, InputDraw1);
            PlayerTextDrawShow(playerid, InputDraw2);
            TextDrawShowForPlayer(playerid, InputDraw[1]);
            processbar2(playerid, 0);
            ShowInput(playerid);
            InputType[playerid] = 2;
            ElectricianProccessTime[playerid] = 10;
            ElectricianProccessTimers[playerid] = SetTimerEx("ElectricianProccessTimer", 300, true, "d", playerid);
        }
        else ErrorMessage(playerid, "{FF6347}Транспорт электриков далеко от зарядной станции");
	}
    else
    {
        if(BizzInfo[b][bItem][term] > MIN_PROCENT_REPAIRTERMINAL) return ErrorMessage(playerid, "{FF6347}Зарядная станция сломана, ожидайте пока её починят!");
        ElectroFillStart(playerid, br,term);
    }
	return 1;
}

stock ElectricianProccessDisctance(playerid)
{
    new br = numnrent(GetPVarInt(playerid,"job_electrician")), term = GetPVarInt(playerid,"job_electrician_point"), type = (GetPVarInt(playerid,"job_electrician_type"));
    if(type == 2)
    {
        if(!IsPlayerInRangeOfPoint(playerid, 2.0, RentPos_X[br][term], RentPos_Y[br][term], RentPos_Z[br][term]))       
        {
            ElectricianStopProcess(playerid, 0);
            return 1;
        }
    }
    else if(type == 0)
    {
        if(!IsPlayerInRangeOfPoint(playerid, 2.0, ElectricianProccessObjectHouse[playerid][0],ElectricianProccessObjectHouse[playerid][1],ElectricianProccessObjectHouse[playerid][2]))
        {
            ElectricianStopProcess(playerid, 0);
            return 1;
        }
    }
    return 0;
}

function ElectricianProccessTimer(playerid)
{
    if(InputProcess[playerid] >= 5)
	{
		if(ElectricianProccessDisctance(playerid)) return 1;
		InputProcess[playerid] -= 5;
		processbar2(playerid, InputProcess[playerid]);
	}
	else
	{
        if(ElectricianProccessTime[playerid] > 0) ElectricianProccessTime[playerid]--;
		else
		{
			ElectricianStopProcess(playerid, 0);
		}
	}
	TextDrawHideForPlayer(playerid, InputDraw[0]), TextDrawHideForPlayer(playerid, InputDraw[5]);
	return 1;
}

stock ElectroFillStart(playerid,br,term)
{
    new result = -1;
    for(new vehicleid = 1; vehicleid < MAX_CARS; vehicleid++)
    {
        if(!IsValidVehicle(vehicleid)) continue;
        if(!IsAElectroCar(VehInfo[vehicleid][vModel])) continue;
        if(GetVehicleInterior(vehicleid) != GetPlayerInterior(playerid) 
            || GetVehicleVirtualWorld(vehicleid) != GetPlayerVirtualWorld(playerid)) continue;
        //if(VehInfo[vehicleid][vSost] != PlayerInfo[playerid][pID]) continue;
        if(GetVehicleDistanceFromPoint(vehicleid, RentPos_X[br][term], RentPos_Y[br][term], RentPos_Z[br][term]) <= 5.0) 
        {
            result = vehicleid;
            break;
        }
    }
    if(result == -1) return ErrorMessage(playerid, "{FF6347}Рядом с вами нет электрокара для заряда");
    if(VehInfo[result][vGas] >= 100) return ErrorMessage(playerid, "{FF6347}Электрокар стоящий рядом полностью заряжен");
    if(PlayerInfo[playerid][pAccount] < (100 - VehInfo[result][vGas]) * BizzInfo[rentnumn(br)][bPrice][0]) return ErrorMessage(playerid,"У меня недостаточно денег на банковском счете");
    zaprcarBizElectro[playerid] = br,zaprcarTermElectro[playerid] = term, zaprcarElectro[playerid] = result, zaprcarElectroTimer[playerid] = 100 - VehInfo[result][vGas];

    Obstacle_CreateObstacleTimeTD(playerid);
    dialogECTSucssesMessage(playerid);
    return 1;
}

stock ElectroFillUpdateTimer(playerid) {
    new ftime[32];
    format(ftime, sizeof(ftime), "%s", fine_time(zaprcarElectroTimer[playerid]));
    PlayerTextDrawSetString(playerid, ObstacleTimeTD[playerid], ftime);
    PlayerTextDrawColour(playerid, ObstacleTimeTD[playerid], 0xFFFFFFFF);
    PlayerTextDrawShow(playerid, ObstacleTimeTD[playerid]);

    new br = zaprcarBizElectro[playerid], term = zaprcarTermElectro[playerid];
    zaprcarElectroTimer[playerid]--, zaprcarElectroKol[playerid]++;
    if(!IsVehicleInRangeOfPoint(zaprcarElectro[playerid], 7.0, RentPos_X[br][term], RentPos_Y[br][term], RentPos_Z[br][term])) return ElectroFillClose(playerid, 0);
    
    if(zaprcarElectroTimer[playerid] <= 0 || zaprcarElectroTimer[playerid] >= 100) ElectroFillClose(playerid,1);
    return 1;
}

stock ElectroFillClose(playerid,type)
{
    new b = rentnumn(zaprcarBizElectro[playerid]),term = zaprcarTermElectro[playerid];

    if(VehInfo[zaprcarElectro[playerid]][vGas] + zaprcarElectroKol[playerid] > 100) zaprcarElectroKol[playerid] = 100 - VehInfo[zaprcarElectro[playerid]][vGas];

    new price = zaprcarElectroKol[playerid] * BizzInfo[b][bPrice][0];

    PlayerTextDrawHide(playerid, ObstacleTimeTD[playerid]);
    PlayerTextDrawDestroy(playerid, ObstacleTimeTD[playerid]);

    if(PlayerInfo[playerid][pAccount] < price || type == 2) 
    {
        zaprcarBizElectro[playerid] = 0, zaprcarTermElectro[playerid] = 0, zaprcarElectro[playerid] = 0, zaprcarElectroTimer[playerid] = 0;
        return ErrorMessage(playerid,"У меня недостаточно денег на банковском счете. Заправка отменена");
    }
    VehInfo[zaprcarElectro[playerid]][vGas] += zaprcarElectroKol[playerid];

    oGivePlayerBank(playerid, -price, true);
    paybiz(b,price);

    BizzInfo[b][bItem][term] += zaprcarElectroKol[playerid];
    BizzInfo[b][bUpdate] = 1;

    if(type == 1) SendClientMessage(playerid,COLOR_GRAY,"[ Мысли ]: Я зарядил свой электрокар на %d кВт за {99ff66}%d$", zaprcarElectroKol[playerid], price);
    else SendClientMessage(playerid,COLOR_GRAY,"[ Мысли ]: Машина отьехала от зарядной станции, она была заряжена на %d кВт за {99ff66}%d$", zaprcarElectroKol[playerid], price);

    zaprcarBizElectro[playerid] = 0, zaprcarTermElectro[playerid] = 0, zaprcarElectro[playerid] = 0, zaprcarElectroTimer[playerid] = 0;
    return 1;
}

stock dialogCase_Electrician(playerid, dialogid, response, listitem, const inputtext[]) {
    new b = DP[4][playerid];
    switch (e_DialogId: dialogid) {
        case ELECTRICIAN_DIALOG_PAYMENTHOUSE: {
            if (!response) return productbiz(playerid,b);
            else
            {
                UpdateElectricianMoneyForWork(playerid, b,inputtext, 1);
            }
        }
        case ELECTRICIAN_DIALOG_PAYMENTTERMINAL: {
            if (!response) return productbiz(playerid,b);
            else
            {
                UpdateElectricianMoneyForWork(playerid, b,inputtext, 2);
            }
        }
        case ELECTRICIAN_DIALOG_GOJOB: {
            if(!response) return 0;
            else
            {
                if(listitem == 0)
				{
                    dialogElectricianHelp(playerid);
				}
				if(listitem == 1)
				{
				    if(PlayerInfo[playerid][pPlacement] >= 1 && PlayerInfo[playerid][pPlacement] != 14) return StopJob(playerid);
				    if(GetPVarInt(playerid,"job_stat") != 14)
				    {
				    	if(get_invent2(playerid, 156, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет водительских прав [ Y >> GPS >> Образовательный Центр ]");
				    	if(PlayerInfo[playerid][pMechSkill] == 0) return ErrorMessage(playerid, "{FF6347}Ваш персонаж устал и хочет спать");
				    	SetPVarInt(playerid,"job_stat",14);
						RemovePlayerAttachedObject(playerid,0), PlayerPlaySound(playerid,5600,0,0,0);
				    	SetPlayerAttachedObject(playerid, 0, 19904, 1, 0.067999, 0.044999, 0.000000, 0.000000, 88.199996, 178.000000, 1.053000, 1.141001, 1.016000, 0, 0);
				    	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Отправляйтесь на улицу и возьмите спец. транспорт с парковки\n","*","");
				    }
				    else if(GetPVarInt(playerid,"job_stat") == 14)
				    {
				    	SetPVarInt(playerid,"job_stat",0), RemovePlayerAttachedObject(playerid,0), PlayerPlaySound(playerid,5601,0,0,0);
				    	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы {FF6347}завершили {ffcc66}работу Электрика","*","");
				    	DisablePlayerRaceCheckpoint(playerid);
                        CloseElectricianClear(playerid);
						SpawnRentVehicleJob(playerid, 2091);
				    }
		    	}
		    	if(listitem == 2)
				{
					if(PlayerInfo[playerid][pPlacement] >= 1 && PlayerInfo[playerid][pPlacement] != 14) return StopJob(playerid);
					if(PlayerInfo[playerid][pSalary] <= 0) return ErrorMessage(playerid, "{FF6347}Вы не выполнили работу");
					new pay = PlayerInfo[playerid][pSalary];
					paysalary(playerid, pay, 0);
					ApplyAnimation(playerid,"DEALER","shop_pay",4.0, false, false, false, false, false);
					MoneyLog("salary", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", PlayerInfo[playerid][pSalary], "Зарплата Электрика");
					SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Моя зарплата {99ff66}%d$", PlayerInfo[playerid][pSalary]);
					SendDynamicActorMessage(playerid, BotPears[5],"Отлично! Держи деньги");
					PlayerInfo[playerid][pPlacement] = 0, PlayerInfo[playerid][pSalary] = 0;
					mysql_save(playerid, 58);
				}
            }
        }
        case ELECTRICIAN_DIALOG_HELP: {
            if(response) dialogElectricianJob(playerid);
        }
        case ELECTRICIAN_DIALOG_AGETCAR: {
            if(!response) return 0;
            if(listitem >= 1 || listitem < 0) return 1;
            if(IsPlayerInAnyVehicle(playerid)) return ErrorMessage(playerid, "{FF6347}Нельзя арендовать транспорт сидя в транспорте");
            if(get_invent2(playerid, 156, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет водительских прав [ Y >> GPS >> Образовательный Центр ]");
            if(GetPVarInt(playerid,"job_stat") != 14) return ErrorMessage(playerid, "{FF6347}Зайдите в будку и начните дежурство, прежде чем брать транспорт");
            new unix = gettime();
            if(PlayerInfo[playerid][pRent][0] > unix && PlayerInfo[playerid][pRent][1] > unix) return ErrorMessage(playerid, "{FF6347}У вас уже два арендованных транспорта [ Y >> Транспорт или /car ]");
            new model, newcar;
            new Float:X,Float:Y,Float:Z;
            GetPlayerPos(playerid,X,Y,Z);
            if(listitem == 0) newcar = PP_CreateVehicle(2091,X, Y, Z,1.1,6,1,600,0, -1, 0.0), model = 2091;
            VehInfo[newcar][vGas] = GasMax;
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
            VehLabel[newcar] = CreateDynamic3DTextLabel(string,0xfaf75c99, X, Y, Z,1.0,INVALID_PLAYER_ID, newcar,0,0,0);
            Protect_PutPlayerInVehicle(playerid, newcar, 0);
            CreateRent_Player(playerid, unix, newcar, 6, 100, model, 0, 0, X, Y, Z,1);
        }
        case ELECTRICIAN_DIALOG_HOUSELIST: {
            if(!response) return pc_cmd_dominteraction(playerid);
            else {
                new biz = listitem + 143, d = PlayerInfo[playerid][pDom];
                if(DomInfo[d][dElectroUnix]+86400 > gettime()) return ErrorMessage(playerid,"{ff6347}Менять электростанцию можно только раз в сутки!");
                if(ElectricianConnect[d] == 1) return ErrorMessage(playerid,"{ff6347}К вам уже едет Электрик, сменить электростанцию не возможно!");
                if(DomInfo[d][dElectroConnect] == biz) 
                {
                    ErrorText(playerid,"{ff6347}Мой дом уже подключен к данной электростанции\n\n{cccccc}Если нужно сменить электростацнию вам нужно выбрать другую к которой я не подключен и ждать подключения.");
                    return ElectrostationHouseList(playerid,d);
                }
                else dialogElectricianReconnect(playerid, d,biz);
            }
        }
        case ELECTRICIAN_DIALOG_HOUSESELECTCONNECT:{
            new d = DP[3][playerid];
            if(response)
            {
                if(!GetElectroObject(d)) return ErrorMessage(playerid,"{ff6347}У вашего дома не установлен электрощиток. Купить его можно в IKEA и установить на улице дома!");
                DomInfo[d][dElectroStatus] = b;
                SaveElectro_Dom(d);
                SuccessMessage(playerid,"{44ff99}Вы успешно сменили электростацнию\n\n{cccccc}Ожидайте приезда электриков, время зависит от электростанции и электриков");
            }
            else return ElectrostationHouseList(playerid,d);
        }
        case ELECTRICIAN_DIALOG_TICKETLIST:{
            if(!response) return 0;
            if(listitem == 0) 
            {
                if(GetPVarInt(playerid, "job_electrician") != 0) return CloseElectricianClear(playerid);
                else return 0;
            }
            if(listitem == 1) CreateListElectrianTerm(playerid);
            if(listitem == 2) CreateListElectrianHome(playerid);
        }
        case ELECTRICIAN_DIALOG_TICKETLISTTERM:{
            if(!response) return pc_cmd_checkcharg(playerid);
            if(listitem >= 0 && listitem <= 50)
            {
                if(GetPVarInt(playerid,"job_stat") != 14) return ErrorMessage(playerid,"{FF6347}Вы не работаете Электриком\n{ffcc66}Устроиться на работу можно [ Y >> GPS >> Работа >> Электрики ]");
                new veh = GetPlayerVehicleID(playerid);
                new model = VehInfo[veh][vModel];
                if(model != 2091) return ErrorMessage(playerid,"{FF6347}Вы не на спец. транспорте Электриков\n{ffcc66}Возьмите транспорт на парковке Электриков");
                new listterm = List[listitem-1][playerid];
                new listord = ListParam[listitem-1][playerid];
				if(listord == 0) return 1;
                new termid = numnrent(listord);
                if(PlayerInfo[playerid][pBusiness] == listord && server != 0) return ErrorText(playerid, "{FF6347}Вы не можете самостоятельно выполнить ремонт зарядной станции в своем бизнесе"), pc_cmd_checkcharg(playerid);
				if(ElectricianRepair[listord - GetBizMin(17)][listterm] != 0) return ErrorText(playerid,"{FF6347}Упс, вы не успели.. Кто-то принял этот заказ");

				CreateElectrician(playerid, listord, listterm,2);
                SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Отправляйтесь к терминалу для его ремонта (отмечено в GPS)");
                CreateGps(playerid,RentPos_X[termid][listterm],RentPos_Y[termid][listterm],RentPos_Z[termid][listterm],0, 0, 10.0);
            }
        }
        case ELECTRICIAN_DIALOG_TICKETLISTHOUSE:{
            if(!response) return pc_cmd_checkcharg(playerid);
            if(listitem >= 0 && listitem <= 50)
            {
                if(GetPVarInt(playerid,"job_stat") != 14) return ErrorMessage(playerid,"{FF6347}Вы не работаете Электриком\n{ffcc66}Устроиться на работу можно [ Y >> GPS >> Работа >> Электрики ]");
                new veh = GetPlayerVehicleID(playerid);
                new model = VehInfo[veh][vModel];
                if(model != 2091) return ErrorMessage(playerid,"{FF6347}Вы не на спец. транспорте Электриков\n{ffcc66}Возьмите транспорт на парковке Электриков");
                new dom = List[listitem-1][playerid];
                new biz = ListParam[listitem-1][playerid];
				if(biz == 0) return 1;
                if(PlayerInfo[playerid][pBusiness] == biz && server != 0) return ErrorText(playerid, "{FF6347}Вы не можете самостоятельно выполнить подключение домов к электростанции к своему бизнесу"), pc_cmd_checkcharg(playerid);
				if(ElectricianConnect[dom] != 0) return ErrorText(playerid,"{FF6347}Упс, вы не успели.. Кто-то принял этот заказ");

				CreateElectrician(playerid, biz, dom,1);
                SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Отправляйтесь к дому для его подключения (отмечено в GPS)");
                SendClientMessage(playerid, COLOR_YELLOW, " SMS от Оператора: {99ff33}Рядом с домом находится электрощиток для подключения.");
                CreateGps(playerid,DomInfo[dom][dKoordinatX], DomInfo[dom][dKoordinatY], DomInfo[dom][dKoordinatZ],0, 0, 10.0);
            }
        }
    }

    return 1;
}

stock AgetCarElectrician(playerid)
{
    ShowDialog(playerid, ELECTRICIAN_DIALOG_AGETCAR, DIALOG_STYLE_TABLIST, "{ff9000}Транспорт Электриков", "Ford Econoline", "Выбрать", "Выход");
    return 1;
}

stock GetElectroObject(dom)
{
    new slot = -1;
    for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
	{
        if(!IsValidDynamicObject(DomInfo[dom][dObject][oba])) continue;
        if(GetDynamicObjectElectro(DomInfo[dom][dObject][oba]) && GetDynamicObjectVirtualWorld(DomInfo[dom][dObject][oba]) == 0) slot = oba;
	}
	if(slot == -1) return 0;
    else return 1;
}


alias:checkcharg("ect")
CMD:checkcharg(playerid)
{
	ClearList(playerid);
    new lines[300], string[60];
	format(lines,sizeof(lines),"\n{ff6347}Отменить принятую заявку\
                                \n{ff9000}Список терминалов нуждающихся в ременте\
								\n{ff9000}Список домов нуждающихся в подключение");
	format(string,sizeof(string),"{cccccc}Работа Электрика");
	ShowDialog(playerid,ELECTRICIAN_DIALOG_TICKETLIST,DIALOG_STYLE_LIST, string, lines, "Принять", "Отмена");
	return true;
}

stock CreateListElectrianTerm(playerid)
{
    new quan;
	new line[214],lines[4096];
	ClearList(playerid);

    format(line,sizeof(line),"Номер бизнеса\tОплата"), strcat(lines,line);

	new minb = GetBizMin(17);
    for(new b = 143; b <= 152; b++)
	{
		if(b < 143 || b > 152) continue;

        for(new i = 0; i < 5; i++)
	    {
            if(BizzInfo[b][bItem][i] < MIN_PROCENT_REPAIRTERMINAL || ElectricianRepair[b - minb][i] != 0) continue;
            
            if(BizzInfo[b][bItem][i] < MIN_PROCENT_REPAIRTERMINAL) continue;
			if(BizzInfo[b][bElectroPayForRepair] <= 0 || BizzInfo[b][bDeposit] < BizzInfo[b][bElectroPayForRepair]) continue;
			if(RentStat[b-97][i] <= 0) continue;
            List[quan][playerid] = i;
            ListParam[quan][playerid] = b;
            quan ++;
            format(line,sizeof(line),"\n{ff9000}Электростанция № %d | Терминал № %d \t%d$", b, i, BizzInfo[b][bElectroPayForRepair]), strcat(lines,line);
        }
	}
    if(quan < 1) return ErrorMessage(playerid,"{FF6347}В данный момент ни один из терминалов не сломан");
	ShowDialog(playerid,ELECTRICIAN_DIALOG_TICKETLISTTERM,DIALOG_STYLE_TABLIST_HEADERS,"Заявки на ремонт терминалов",lines,"Выбрать","Отмена");
    return true;
}

stock CreateListElectrianHome(playerid)
{
    new quan,bizId;
	new line[214],lines[4096];
	ClearList(playerid);

    format(line,sizeof(line),"Номер Дома\tОплата"), strcat(lines,line);

    for(new d = 1; d <= 1000; d++)
	{
        if(DomInfo[d][dElectroStatus] == 0) continue;
        if(ElectricianConnect[d] == 1) continue;
        bizId = DomInfo[d][dElectroStatus];
        if(BizzInfo[bizId][bElectroPayForConnect] <= 0 || BizzInfo[bizId][bDeposit] < BizzInfo[bizId][bElectroPayForConnect]) continue;
        if(!GetElectroObject(d)) continue;
        List[quan][playerid] = d;
        ListParam[quan][playerid] = bizId;
        quan ++;
        format(line,sizeof(line),"\n{ff9000}Электростанция № %d | Дом № %d \t%d$", bizId, d, BizzInfo[bizId][bElectroPayForConnect]), strcat(lines,line);
    }
    if(quan < 1) return ErrorMessage(playerid,"{FF6347}В данный момент ни один из домов не требует подключения");
	ShowDialog(playerid,ELECTRICIAN_DIALOG_TICKETLISTHOUSE,DIALOG_STYLE_TABLIST_HEADERS,"Заявки на подключение дома",lines,"Выбрать","Отмена");
    return true;
}

stock Electrician_OnPlayerDisconnect(playerid)
{
    if (ElectricianProccessTimers[playerid] != 0)
    {
        ElectricianStopProcess(playerid, 0);
    }
    return 1;
}

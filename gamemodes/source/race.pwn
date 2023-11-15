#define MAX_RACERS_POINT 1
enum raceInfo
{
    raceStat, // Статус взрыва или бомбы
    Float: racePosMarket[6], // Позиция Тележки
    Float: racePosBenz[6], // Позиция Бензика
    Float: racePosService[6], // Позиция Сервиса
    Float: racePosTerminal[6], // Позиция Терминала
    raceFamily, // Семья начавшего событие
    raceUnix, // Время на проведенную гонку
    racersCount[8], // Количество участников в гонке
}
new StreetRacers[MAX_RACERS_POINT][raceInfo];

stock ShowStreetRacers(playerid,family)
{
    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"Начать подготовку к сходке"), strcat(lines,line);
    if(FamilyInfo[family][fParthnerMarket] == 0) format(line,sizeof(line),"\nПартнерство с Ларьком с Едой. {FF6347}[Отсутствует]"), strcat(lines,line);
    else if(FamilyInfo[family][fParthnerMarket] != 0) format(line,sizeof(line),"\nПартнерство с Ларьком с Едой. {99ff66}[Бизнес № %d]", FamilyInfo[family][fParthnerMarket]), strcat(lines,line);
    if(FamilyInfo[family][fParthnerBenz] == 0) format(line,sizeof(line),"\nПартнерство с заправкой. {FF6347}[Отсутствует]"), strcat(lines,line);
    else if(FamilyInfo[family][fParthnerBenz] != 0) format(line,sizeof(line),"\nПартнерство с заправкой. {99ff66}[Бизнес № %d]", FamilyInfo[family][fParthnerBenz]), strcat(lines,line);
    if(FamilyInfo[family][fParthnerService] == 0) format(line,sizeof(line),"\nПартнерство с Автосервисом. {FF6347}[Отсутствует]"), strcat(lines,line);
    else if(FamilyInfo[family][fParthnerService] != 0) format(line,sizeof(line),"\nПартнерство с Автосервисом. {99ff66}[Бизнес № %d]", FamilyInfo[family][fParthnerService]), strcat(lines,line);
    ShowDialog(playerid,1457,DIALOG_STYLE_TABLIST,"{ff9000}StreetRacers Menu",lines,"Выбрать","Назад");
}

stock GoStreetRacers(playerid)
{
    new fId = PlayerInfo[playerid][pFamily];
    new tyear, tmonth, tday, thour, tminute, tsecond;
    new unixsecond = gettime();
    format(lines,sizeof(lines),""); // Очищаем Lines
    if(StreetRacers[0][raceUnix] > 0)
    {
        if(StreetRacers[0][raceFamily] == fId)
        {
            stamp2datetime(StreetRacers[0][raceUnix]+unixsecond, tyear, tmonth, tday, thour, tminute, tsecond, 3);
            format(line,sizeof(line),"Сходка Стритрейсеров. Активна до [ %02d.%02d.%d %02d:%02d ]",tday, tmonth, tyear, thour, tminute), strcat(lines,line);
            format(line,sizeof(line),"\nОбъявить сбор"), strcat(lines,line);
            if(StreetRacers[0][racePosMarket][0] == 0.0 && StreetRacers[0][racePosMarket][1] == 0.0) format(line,sizeof(line),"\nТележка с хот-догами {FF6347}[Не установлена]"), strcat(lines,line);
            else if(StreetRacers[0][racePosMarket][0] != 0.0 && StreetRacers[0][racePosMarket][1] != 0.0) format(line,sizeof(line),"\nТележка с хот-догами {99ff66}[Установлена]"), strcat(lines,line);
            if(StreetRacers[0][racePosBenz][0] == 0.0 && StreetRacers[0][racePosBenz][1] == 0.0) format(line,sizeof(line),"\nКолонка с бензином {FF6347}[Не установлена]"), strcat(lines,line);
            else if(StreetRacers[0][racePosBenz][0] != 0.0 && StreetRacers[0][racePosBenz][1] != 0.0) format(line,sizeof(line),"\nКолонка с бензином {99ff66}[Установлена]"), strcat(lines,line);
            if(StreetRacers[0][racePosService][0] == 0.0 && StreetRacers[0][racePosService][1] == 0.0) format(line,sizeof(line),"\nСтойка автосервиса {FF6347}[Не установлена]"), strcat(lines,line);
            else if(StreetRacers[0][racePosService][0] != 0.0 && StreetRacers[0][racePosService][1] != 0.0) format(line,sizeof(line),"\nСтойка автосервиса {99ff66}[Установлена]"), strcat(lines,line);
            if(StreetRacers[0][racePosTerminal][0] == 0.0 && StreetRacers[0][racePosTerminal][1] == 0.0) format(line,sizeof(line),"\nТерминал для гонки {FF6347}[Не установлена]"), strcat(lines,line);
            else if(StreetRacers[0][racePosTerminal][0] != 0.0 && StreetRacers[0][racePosTerminal][1] != 0.0) format(line,sizeof(line),"\nТерминал для гонки {99ff66}[Установлена]"), strcat(lines,line);
            ShowDialog(playerid,1452,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}StreetRacers Menu",lines,"Выбрать","Назад");
        }
        else if(StreetRacers[0][raceFamily] != fId)
        {
            CreateGps(playerid,StreetRacers[0][racePosTerminal][0],StreetRacers[0][racePosTerminal][1],StreetRacers[0][racePosTerminal][2], 0, 0, 5.0);
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сейчас уже активна сходка StreetRacers");
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Возможно мне стоит явится на неё и проявить себя!");
        }
    }
    else if(StreetRacers[0][raceUnix] == 0)
    {
        format(line,sizeof(line),"\nНачать сходку Стрит Рейсоров?"), strcat(lines,line);
		ShowDialog(playerid,1451,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu",lines,"Да","Нет");
    }
}

stock CreatePartyStreet(playerid)
{
    if(StreetRacers[0][raceUnix] > 0) return ErrorMessage(playerid,"Кто-то уже начал сбор");
    StreetRacers[0][raceFamily] = PlayerInfo[playerid][pFamily];
    StreetRacers[0][raceStat] = 1;
    StreetRacers[0][raceUnix] = 7200;
    for(new i; i < 8; i++)
    {
        StreetRacers[0][racersCount][i] = -1;   
    }
    return 1;
}

stock ClosePartyStreet()
{
    StreetRacers[0][raceFamily] = -1;
    StreetRacers[0][raceStat] = 0;
    StreetRacers[0][raceUnix] = 0;
    return 1;
}

stock dialogCase_Race(playerid, dialogid, response, listitem,const inputtext[])
{
	if(dialogid == 1451)
   	{
   	    if(response) CreatePartyStreet(playerid);
    }
    else if(dialogid == 1452)
   	{
   	    if(response)
        {
            if(listitem == 0)
            {
                if((StreetRacers[0][racePosTerminal][0] == 0.0 && StreetRacers[0][racePosTerminal][1] == 0.0) 
                || (StreetRacers[0][racePosBenz][0] == 0.0 && StreetRacers[0][racePosBenz][1] == 0.0) 
                || (StreetRacers[0][racePosService][0] == 0.0 && StreetRacers[0][racePosService][1] == 0.0) 
                || (StreetRacers[0][racePosMarket][0] == 0.0 && StreetRacers[0][racePosMarket][1] == 0.0)) return ErrorMessage(playerid,"{FF6347}Вы должны установить все физичиские объекты!");
            }
            if(listitem >= 1 && listitem <= 4)
            {   
                new moving;
                if(StreetRacers[0][racePosMarket][0] == 0.0 && StreetRacers[0][racePosMarket][1] == 0.0 && listitem == 1) moving = 0;
                else if(StreetRacers[0][racePosMarket][0] != 0.0 && StreetRacers[0][racePosMarket][1] != 0.0 && listitem == 1) moving = 1;
                if(StreetRacers[0][racePosBenz][0] == 0.0 && StreetRacers[0][racePosBenz][1] == 0.0 && listitem == 2) moving = 0;
                else if(StreetRacers[0][racePosBenz][0] != 0.0 && StreetRacers[0][racePosBenz][1] != 0.0 && listitem == 2) moving = 1;
                if(StreetRacers[0][racePosService][0] == 0.0 && StreetRacers[0][racePosService][1] == 0.0 && listitem == 3) moving = 0;
                else if(StreetRacers[0][racePosService][0] != 0.0 && StreetRacers[0][racePosService][1] != 0.0 && listitem == 3) moving = 1;
                if(StreetRacers[0][racePosTerminal][0] == 0.0 && StreetRacers[0][racePosTerminal][1] == 0.0 && listitem == 4) moving = 0;
                else if(StreetRacers[0][racePosTerminal][0] != 0.0 && StreetRacers[0][racePosTerminal][1] != 0.0 && listitem == 4) moving = 1;
                if(moving == 0 || moving == 1)
                {
                    new objectid;
                    if(listitem == 1) objectid = 1340;
                    else if(listitem == 2) objectid = 3465;
                    else if(listitem == 3) objectid = 19903;
                    else if(listitem == 4) objectid = 2754;
                    if(MPGO[playerid] != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я на мероприятии..");
                    DP[0][playerid] = moving;

                    new Float:f_pos[4];
                    frontme(playerid, 5.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
                    if(moving == 0) CreateEditPlayerObject(playerid, 21 + listitem, 0, 0, 0, objectid, f_pos[0], f_pos[1], f_pos[2]);
                    else if(moving == 1)
                    {
                        GoEditDynamicObject(playerid, 21 + listitem, 1, 0, 0, RentObjectRace[listitem], 0);
                    }
                }
            }
        }
    }
    else if(dialogid == 1453)
   	{
   	    if(response)
        {
            if(listitem < 0 || listitem > 9) return ErrorMessage(playerid,"Лист итем паленый броооооо");
            {
                new b = DP[4][playerid];
                new listord = List[listitem][playerid];
                DP[1][playerid] = listord;
                settingpartner(playerid, b, listord);
            }
        }
    }
    else if(dialogid == 1454)
   	{
   	    if(response)
        {
            new b = DP[4][playerid];
            new listord = DP[1][playerid];
            if(listitem == 0)
            {   
                if(BizzInfo[b][bFamilyPartner][listord] != 0) return ErrorMessage(playerid,"{FF6347}Сначала нужно разорвать партнерство с семьей в данном слоте");
                ShowDialog(playerid,1455,DIALOG_STYLE_INPUT,"{ff9000}Заключения партнерства","{cccccc}Введите {ff9000}ID или Никнейм {cccccc}владельца бизнеса\n\nПример: 25 / Elon_Muskat","Принять","Отмена");
            }
            if(listitem == 1)
            {
                if(BizzInfo[b][bFamilyPartner][listord] != 0)
                {
                    new fam = BizzInfo[b][bFamilyPartner][listord];
                    if(b >= 1 && b <= 12) FamilyInfo[fam][fParthnerBenz] = b;
                    else if(b >= 153 && b <= 162) FamilyInfo[fam][fParthnerMarket] = b;
                    else if(b >= 183 && b <= 192) FamilyInfo[fam][fParthnerService] = b;
                    SaveBizzPartner(b);
                    SaveFamily(fam);
                }
                else if(BizzInfo[b][bFamilyPartner][listord] == 0) return ErrorMessage(playerid,"{FF6347}В слоте партнерства пусто");
            }
        }
    }
    else if(dialogid == 1455)
    {
        new b = DP[4][playerid];
        new number = DP[1][playerid];
        new string[20];
        if(response)
		{
			format(string, sizeof(string), "%s", inputtext);
            CreatePartnerRace(playerid,b, string,number);
		}
		else settingpartner(playerid,b,number);
    }
    else if(dialogid == 1456)
    {
        new b = DP[0][playerid];
        new giveplayerid = DP[1][playerid];
        new number = DP[2][playerid];
        new fam = DP[3][playerid];
        if(response)
		{
            BizzInfo[b][bFamilyPartner][number] = FamilyInfo[fam][fIds];
            if(b >= 1 && b <= 12) FamilyInfo[fam][fParthnerBenz] = b;
            else if(b >= 153 && b <= 162) FamilyInfo[fam][fParthnerMarket] = b;
            else if(b >= 183 && b <= 192) FamilyInfo[fam][fParthnerService] = b;
            SaveFamily(fam);
            SaveBizzPartner(b);
            SuccessMessage(giveplayerid, "Ваше предложение о партнерстве принято");
            SuccessMessage(playerid, "Вы приняли предложение о партнерстве");
		}
		else settingpartner(playerid,b,number);
    }
    else if(dialogid == 1457)
    {
        format(lines,sizeof(lines),""); // Очищаем Lines
        new fam = PlayerInfo[playerid][pFamily];
        new b = DP[4][playerid];
        new number = DP[2][playerid];
        if(response)
		{
            if(listitem < 0 || listitem > 4) return 0;
            if(listitem == 0)
            {
                if(PlayerInfo[playerid][pFamrank] < 10) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вы не глава семьи и не можете управлять данным мероприятием");
                if(FamilyInfo[fam][fParthnerBenz] == 0 || FamilyInfo[fam][fParthnerMarket] == 0 || FamilyInfo[fam][fParthnerService] == 0) return ErrorMessage(playerid, "{FF6347}Нужно что бы все партнерства были заключены");
                GoStreetRacers(playerid);
            }
            if(listitem == 1)
            {
                if(PlayerInfo[playerid][pFamrank] < 10) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вы не глава семьи и не можете управлять данным мероприятием");
                if(FamilyInfo[fam][fParthnerMarket] == 0)
                {
                    ErrorMessage(playerid,"{FF6347}У семьи нет партнера данного типа.\n Возможно стоит связаться с владельцем одного из бизнесов");
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Было бы неплохо связаться с владельцем и заключить партнерство");
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Участникам мероприятия будет комфортно если будет где быстро перекусить");
                }
                else if(FamilyInfo[fam][fParthnerMarket] != 0)
                {
                    DP[1][playerid] = listitem;
                    format(line,sizeof(line),"\nРазорвать партнерство?"), strcat(lines,line);
		            ShowDialog(playerid,1458,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu",lines,"Да","Нет");
                }
            }
            if(listitem == 2)
            {
                if(PlayerInfo[playerid][pFamrank] < 10) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вы не глава семьи и не можете управлять данным мероприятием");
                if(FamilyInfo[fam][fParthnerBenz] == 0)
                {
                    ErrorMessage(playerid,"{FF6347}У семьи нет партнера данного типа.\n Возможно стоит связаться с владельцем одного из бизнесов");
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Было бы неплохо связаться с владельцем и заключить партнерство");
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Участникам мероприятия будет комфортно если будет колонка с бензином");
                }
                else if(FamilyInfo[fam][fParthnerBenz] != 0)
                {
                    DP[1][playerid] = listitem;
                    format(line,sizeof(line),"\nРазорвать партнерство?"), strcat(lines,line);
		            ShowDialog(playerid,1458,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu",lines,"Да","Нет");
                }
            }
            if(listitem == 3)
            {
                if(PlayerInfo[playerid][pFamrank] < 10) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вы не глава семьи и не можете управлять данным мероприятием");
                if(FamilyInfo[fam][fParthnerService] == 0)
                {
                    ErrorMessage(playerid,"{FF6347}У семьи нет партнера данного типа.\n Возможно стоит связаться с владельцем одного из бизнесов");
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Было бы неплохо связаться с владельцем и заключить партнерство");
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Участникам мероприятия будет комфортно если будет где быстро перекусить");
                }
                else if(FamilyInfo[fam][fParthnerService] != 0)
                {
                    DP[1][playerid] = listitem;
                    format(line,sizeof(line),"\nРазорвать партнерство?"), strcat(lines,line);
		            ShowDialog(playerid,1458,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu",lines,"Да","Нет");                    
                }
            }
		}
		else settingpartner(playerid,b,number);
    }
    else if(dialogid == 1458)
    {
        new fam = PlayerInfo[playerid][pFamily];
        if(response)
        {
            new number = DP[1][playerid];
            new b;
            if(number == 1)
            {
                b = FamilyInfo[fam][fParthnerMarket];
                for(new i; i < 10; i++)
                {
                    if(BizzInfo[b][bFamilyPartner][i] == FamilyInfo[fam][fIds])
                    {
                        BizzInfo[b][bFamilyPartner][i] = 0;
                        break;
                    }
                }
                FamilyInfo[fam][fParthnerMarket] = 0;
                SaveFamily(fam);
                SaveBizzPartner(b);
            }
            else if(number == 2)
            {
                b = FamilyInfo[fam][fParthnerBenz];
                for(new i; i < 10; i++)
                {
                    if(BizzInfo[b][bFamilyPartner][i] == FamilyInfo[fam][fIds])
                    {
                        BizzInfo[b][bFamilyPartner][i] = 0;
                        break;
                    }
                }
                FamilyInfo[fam][fParthnerBenz] = 0;
                SaveFamily(fam);
                SaveBizzPartner(b);
            }
            else if(number == 3)
            {
                b = FamilyInfo[fam][fParthnerService];
                for(new i; i < 10; i++)
                {
                    if(BizzInfo[b][bFamilyPartner][i] == FamilyInfo[fam][fIds])
                    {
                        BizzInfo[b][bFamilyPartner][i] = 0;
                        break;
                    }
                }
                FamilyInfo[fam][fParthnerService] = 0;
                SaveFamily(fam);
                SaveBizzPartner(b);
            }
        }
        else ShowStreetRacers(playerid, fam);
    }
    else if(dialogid == 1459)
    {
        if(response)
        {
            if(listitem < 0 || listitem > 9) return ErrorMessage(playerid,"Лист итем паленый броооооо");
            {
                new listord = List[listitem][playerid];
                DP[1][playerid] = listord;
                RegisterToRace(playerid, listord);
            }
        }
    }
    else if(dialogid == 1460)
    {
        if(response)
		{
            new number = DP[1][playerid];
            if(StreetRacers[0][racersCount][number] == -1) return ErrorMessage(playerid,"{FF6347} Слот занят, выбирете другой");
            StreetRacers[0][racersCount][number] = playerid;
            SuccessMessage(playerid, "Вы успешно зарегестрировались на гонку");
		}
    }
    return 1;
}
stock settingpartner(playerid, b, number) // Управление партнерством
{
    format(lines,sizeof(lines),""); // Очищаем Lines

	if(BizzInfo[b][bFamilyPartner][number] == 0) format(line,sizeof(line),"{444444}Партнерство с семьей: {ff9000}Пусто"), strcat(lines,line);
    else if(BizzInfo[b][bFamilyPartner][number] != 0) format(line,sizeof(line),"{444444}Партнерство с семьей: {ff9000}%s", FamilyInfo[BizzInfo[b][bFamilyPartner][number]][fName]), strcat(lines,line);
    format(line,sizeof(line),"\n{99ff66}Предложить партнерство "), strcat(lines,line);
    format(line,sizeof(line),"\n{FF6347}Разорвать партнерство"), strcat(lines,line);
	ShowDialog(playerid,1454,DIALOG_STYLE_TABLIST_HEADERS,"Бизнес партнерство",lines,"Выбрать","Отмена");
	return 1;
}
stock CreatePartnerRace(playerid, b, const params[],number) // Отправка запроса на создание партнерства
{
    if(!sscanf(params, "s[144]", params[0]))
    {
        new giveplayerid = ReturnUser(params[0]);
        if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрок не в сети");

        if(!ProxDetectorS(10.0, playerid, giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрок далеко от вас [ Не больше 10 метров ]");
        if(PlayerInfo[giveplayerid][pFamrank] < 10) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок не глава семьи и не может принять предложение");
        new fam = PlayerInfo[giveplayerid][pFamily];
        if(b >= 1 && b <= 12 && FamilyInfo[fam][fParthnerBenz] != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У семьи Игрока уже заключено партнерство с подобным бизнесом");
        else if(b >= 153 && b <= 162 && FamilyInfo[fam][fParthnerMarket] != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У семьи Игрока уже заключено партнерство с подобным бизнесом");
        else if(b >= 183 && b <= 192 && FamilyInfo[fam][fParthnerService] != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У семьи Игрока уже заключено партнерство с подобным бизнесом");
        //if(giveplayerid == playerid) return ErrorMessage(playerid, "{FF6347}Вы не можете заключить партнерство с собой");
        DP[0][giveplayerid] = b;
        DP[1][giveplayerid] = playerid;
        DP[2][giveplayerid] = number;
        DP[3][giveplayerid] = fam;
        format(lines,sizeof(lines),""); // Очищаем Lines
        format(line,sizeof(line),"{cccccc}Владелец бизнеса {ff9000}%s [%d]",bizname(b), b), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}Предлагает вам заключить партнерство"), strcat(lines,line);
        format(line,sizeof(line),"\nВашей семьи с его бизнесом"), strcat(lines,line);

        ShowDialog(giveplayerid,1456,DIALOG_STYLE_MSGBOX,"{ff9000}Предложение о партнерстве",lines,"Принять","Отказать");
    }
	return 1;
}
stock CreateLabelTermRace(br,objectid)
{	
	if(br == 1)
	{	
		if(!RentPickupRace[0]) DestroyDynamicPickup(RentPickupRace[0]);
		new Float:x,Float:y,Float:z;
		frontobject(objectid,1.0,x,y,z,StreetRacers[0][racePosMarket][5]);
		RentLabelRace[br] = CreateDynamic3DTextLabel(" ",0xA9C4E4FF,x, y, z,8.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
		RentPickupRace[0] = CreateDynamicPickup(1546, 1, x, y, z, 0, 0);

		// Ставим бота для ларька с едой (Создаётся и переустанавливается в одном стоке)
		//CreateTerminalActorRace();
	}
	else if(br == 2)
	{
		RentLabelRace[br] = CreateDynamic3DTextLabel(" ",0xA9C4E4FF,StreetRacers[0][racePosBenz][1], StreetRacers[0][racePosBenz][2], StreetRacers[0][racePosBenz][3]+0.2,8.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
	}
    else if(br == 3)
	{
		RentLabelRace[br] = CreateDynamic3DTextLabel(" ",0xA9C4E4FF,StreetRacers[0][racePosService][1], StreetRacers[0][racePosService][2], StreetRacers[0][racePosService][3]+0.2,8.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
	}
    else if(br == 4)
	{
		RentLabelRace[br] = CreateDynamic3DTextLabel(" ",0xA9C4E4FF,StreetRacers[0][racePosTerminal][1], StreetRacers[0][racePosTerminal][2], StreetRacers[0][racePosTerminal][3]+0.2,8.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
	}
	return 1;
}

stock UpdateLabelTermRace(br)
{
	new string[214];
	if (br == 1) format(string,sizeof(string),"{ff9000}Тележка с Хот Догами {444444}\n {cccccc}[№ %d]\n\n[ ALT ]");
	else if (br == 2) format(string,sizeof(string),"{ff9000}Колонка бензина №\n {cccccc}[№ %d]\n\n[ ALT ]");
    else if (br == 3) format(string,sizeof(string),"{ff9000}Сервисная стойка № \n {cccccc}[№ %d]\n\n[ ALT ]");
    else if (br == 4) format(string,sizeof(string),"{ff9000}Терминал гонки № \n {cccccc}[№ %d]\n\n[ ALT ]");
	UpdateDynamic3DTextLabelText(RentLabelRace[br],0xA9C4E4FF,string);
	return 1;
}

stock ListRegisterToRace(playerid)
{
    new quan;
	format(lines,sizeof(lines),""); // Очищаем Lines
	for(new i = 0; i < 8; i++)
	{
		List[i][playerid] = 0;
		if(StreetRacers[0][racersCount][i] != -1)
		{
		    List[quan][playerid] = i;
			quan ++;
			format(line,sizeof(line),"{ff9000}%d. %s\n", quan, rpplayername(StreetRacers[0][racersCount][i])), strcat(lines,line);
		}
		else if(StreetRacers[0][racersCount][i] == -1)
		{
		    List[quan][playerid] = i;
			quan ++;
			format(line,sizeof(line),"{ff9000}%d. {cccccc}Свободно\n", quan), strcat(lines,line);
		}
	}
	format(store,sizeof(store),"{cccccc}Сходка StreetRacers");
	ShowDialog(playerid,1459,DIALOG_STYLE_TABLIST,store,lines,"Выбрать","Отмена");
	return 1;
}

stock RegisterToRace(playerid, number)
{
    if(StreetRacers[0][racersCount][number] == -1)
    {
        format(line,sizeof(line),"\nЗанять место в гонке?"), strcat(lines,line);
		ShowDialog(playerid,1460,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu",lines,"Да","Нет");
    }
    else return ErrorMessage(playerid,"{FF6347} Слот занят, выбирете другой");
    return 1;
}
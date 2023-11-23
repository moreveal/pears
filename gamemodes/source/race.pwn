#define MAX_RACERS_POINT 1
enum raceInfo
{
    raceStat, // Статус гонки
    Float: racePosMarket[6], // Позиция Тележки
    Float: racePosBenz[6], // Позиция Бензика
    Float: racePosService[6], // Позиция Сервиса
    Float: racePosTerminal[6], // Позиция Терминала
    raceMap, // Карта для гонки
    raceFamily, // Семья начавшего событие
    raceUnix, // Время на проведенную гонку
    racersCount[8], // Количество участников в гонке
}
new StreetRacers[MAX_RACERS_POINT][raceInfo];
new RaceIcon[1];
new carRaceCheckpoint[MAX_REALPLAYERS],raceRout[MAX_REALPLAYERS];

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
    if(StreetRacers[0][raceStat] == 1 || StreetRacers[0][raceStat] == 2)
    {
        if(StreetRacers[0][raceFamily] == fId)
        {
            if(StreetRacers[0][raceStat] == 1)
            {
                stamp2datetime(StreetRacers[0][raceUnix]+unixsecond, tyear, tmonth, tday, thour, tminute, tsecond, 3);
                format(line,sizeof(line),"Сходка StreetRacers. Активна до [ %02d.%02d.%d %02d:%02d ]",tday, tmonth, tyear, thour, tminute), strcat(lines,line);
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
            else if(StreetRacers[0][raceStat] == 2)
            {
                stamp2datetime(StreetRacers[0][raceUnix]+unixsecond, tyear, tmonth, tday, thour, tminute, tsecond, 3);
                format(line,sizeof(line),"Сходка StreetRacers. Активна до [ %02d.%02d.%d %02d:%02d ]",tday, tmonth, tyear, thour, tminute), strcat(lines,line);
                format(line,sizeof(line),"\nНачать гонку"), strcat(lines,line);
                if(StreetRacers[0][raceMap] == -1) format(line,sizeof(line),"\nКарта {FF6347}[Не выбрана]"), strcat(lines,line);
                else if(StreetRacers[0][raceMap] > -1) format(line,sizeof(line),"\nКарта {99ff66}[Выбрана]"), strcat(lines,line);
                format(line,sizeof(line),"\nСписок гонщиков"), strcat(lines,line);
                format(line,sizeof(line),"\nЗакончить сходку"), strcat(lines,line);
                ShowDialog(playerid,1461,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}StreetRacers Menu",lines,"Выбрать","Назад");
            }
        }
        else if(StreetRacers[0][raceFamily] != fId)
        {
            CreateGps(playerid,StreetRacers[0][racePosTerminal][0],StreetRacers[0][racePosTerminal][1],StreetRacers[0][racePosTerminal][2], 0, 0, 5.0);
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сейчас уже активна сходка StreetRacers");
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Возможно мне стоит явится на неё и проявить себя!");
        }
    }
    else if(StreetRacers[0][raceStat] == 0)
    {
        format(line,sizeof(line),"\nНачать сходку Стрит Рейсоров?"), strcat(lines,line);
		ShowDialog(playerid,1451,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu",lines,"Да","Нет");
    }
    return 1;
}

stock CreatePartyStreet(playerid)
{
    if(StreetRacers[0][raceUnix] > 0 || StreetRacers[0][raceStat] > 0) return ErrorMessage(playerid,"Кто-то уже начал сбор");
    StreetRacers[0][raceFamily] = PlayerInfo[playerid][pFamily];
    StreetRacers[0][raceStat] = 1;
    StreetRacers[0][raceUnix] = 7200;
    SuccessMessage(playerid,"{99ff66}Вы начали подготовку к сходке StreetRacers");
    return 1;
}

stock ReadyPartyStreet(playerid)
{
    StreetRacers[0][raceStat] = 2;
    StreetRacers[0][raceUnix] = 7200;
    StreetRacers[0][raceMap] = -1;
    RaceIcon[0] = CreateDynamicMapIcon(StreetRacers[0][racePosTerminal][0],StreetRacers[0][racePosTerminal][1],StreetRacers[0][racePosTerminal][2],53,0,-1,-1,-1,200.0);
    for(new i; i < 8; i++)
    {
        StreetRacers[0][racersCount][i] = -1;   
    }
    SuccessMessage(playerid,"{99ff66}Вы начали сходку StreetRacers");
    return 1;
}

stock ClosePartyStreet()
{
    for(new i; i < 4; i++)
    {
        if(RentPickupRace[i])
        {
            DestroyDynamic3DTextLabel(RentLabelRace[i]);
            DestroyDynamicPickup(RentPickupRace[i]);
            RentPickupRace[i] = 0;
        }
        DestroyDynamicObject(RentObjectRace[i]);
        RentObjectRace[i] = 0;
    }
    for(new p; p < 8; p++)
    {
        raceRout[StreetRacers[0][racersCount][p]] = -1;
        carRaceCheckpoint[StreetRacers[0][racersCount][p]] = -1;
    }
    if(RaceIcon[0] != 0) DestroyDynamicMapIcon(RaceIcon[0]);
    RaceIcon[0] = 0;
    StreetRacers[0][raceFamily] = -1;
    StreetRacers[0][raceMap] = -1;
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
                ReadyPartyStreet(playerid);
                GoStreetRacers(playerid);
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
                    if(moving == 0) CreateEditPlayerObject(playerid, 21 + listitem, 0, listitem -1, 0, objectid, f_pos[0], f_pos[1], f_pos[2], 0.0, 0.0, 0.0);
                    else if(moving == 1)
                    {
                        GoEditDynamicObject(playerid, 21 + listitem, 1, listitem - 1, 0, RentObjectRace[listitem -1], 0);
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
        else return GoStreetRacers(playerid);
    }
    else if(dialogid == 1460)
    {
        if(response)
		{
            new number = DP[1][playerid];
            if(StreetRacers[0][racersCount][number] != -1) return ErrorMessage(playerid,"{FF6347} Слот занят, выбирете другой");
            StreetRacers[0][racersCount][number] = playerid;
            SuccessMessage(playerid, "Вы успешно зарегестрировались на гонку");
		}
        else return ListRegisterToRace(playerid);
    }
    else if(dialogid == 1461)
    {
        if(response)
        {
            if(listitem == 0)
            {
                format(line,sizeof(line),"\nВы уверены что хотите начать гонку?"), strcat(lines,line);
		        ShowDialog(playerid,1464,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu",lines,"Да","Нет");     
            }
            if(listitem == 1)
            {
                ShowAllRout(playerid,1,1);
            }
            if(listitem == 2)
            {
                ListRegisterToRace(playerid);
            }
            if(listitem == 3)
            {
                ClosePartyStreet();
            }
        }
    }
    else if(dialogid == 1462)
    {
        if(response)
		{
			if(listitem > 50 || listitem < 0) return 0;
			new slot = List[listitem][playerid];
			DP[0][playerid] = -1;
			StreetRacers[0][raceMap] = slot;
		}
    }
    else if(dialogid == 1464)
    {
        if(response)
		{
            StartRace(playerid);
		}
        else return GoStreetRacers(playerid);
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
    if(RentPickupRace[br]) 
    {
        DestroyDynamicPickup(RentPickupRace[br]);
        DestroyDynamic3DTextLabel(RentLabelRace[br]);
    }
    new Float:x,Float:y,Float:z;
	if(br == 0)
	{	
        frontobject(objectid,1.0,x,y,z,StreetRacers[0][racePosMarket][5]);
		RentPickupRace[br] = CreateDynamicPickup(1546, 1, x, y, z, 0, 0);

		// Ставим бота для ларька с едой (Создаётся и переустанавливается в одном стоке)
		//CreateTerminalActorRace();
	}
	else if(br == 1)
	{
		frontobject(objectid,1.0,x,y,z,StreetRacers[0][racePosBenz][5]);
        RentPickupRace[br] = CreateDynamicPickup(1650, 1, x, y, z, 0, 0);
	}
    else if(br == 2)
	{
		frontobject(objectid,1.0,x,y,z,StreetRacers[0][racePosService][5]);
        z = z+0.5;
        RentPickupRace[br] = CreateDynamicPickup(19627, 1, x, y, z, 0, 0);
    }
    else if(br == 3)
	{
		backtobject(objectid,1.0,x,y,z,StreetRacers[0][racePosTerminal][5]);
        RentPickupRace[br] = CreateDynamicPickup(1239, 1, x, y, z, 0, 0);
    }
    RentLabelRace[br] = CreateDynamic3DTextLabel(" ",0xA9C4E4FF,x, y, z,8.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
	return 1;
}

stock UpdateLabelTermRace(br)
{
    new b = FamilyInfo[StreetRacers[0][raceFamily]][fParthnerMarket];
    new b1 = FamilyInfo[StreetRacers[0][raceFamily]][fParthnerBenz];
    new b2 = FamilyInfo[StreetRacers[0][raceFamily]][fParthnerService];
	new string[214];
	if (br == 0) 
    {
        format(string,sizeof(string),"{ff9000}Тележка с Хот Догами \n{444444}%s {cccccc}[№ %d]\n\n[ ALT ]",bizname(b),b);
    }
	else if (br == 1)
    {
        format(string,sizeof(string),"{ff9000}Колонка бензина \n{444444}%s {cccccc}[№ %d]\n\n[ CAPS LOCK ]",bizname(b1),b1);
    }
    else if (br == 2)
    {
        format(string,sizeof(string),"{ff9000}Сервисная стойка \n{444444}%s {cccccc}[№ %d]\n\n[ ALT ]",bizname(b2),b2);
    }
    else if (br == 3) 
    {
        format(string,sizeof(string),"{ff9000}Терминал гонки {cccccc}\n[ ALT ]");
    }
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
    format(lines,sizeof(lines),""); // Очищаем Lines
    new otmena = 0;
    for(new i; i < 8; i++)
    {
        if(StreetRacers[0][racersCount][i] == playerid)
        {
            otmena = -1;
            break;
        }   
    }
    if(otmena == -1) return ErrorMessage(playerid,"{FF6347} Вы уже зарегестрированы в гонке");
    if(StreetRacers[0][racersCount][number] == -1 && otmena != -1)
    {
        format(line,sizeof(line),"\nЗанять место в гонке?"), strcat(lines,line);
		ShowDialog(playerid,1460,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu",lines,"Да","Нет");
    }
    else return ErrorMessage(playerid,"{FF6347} Слот занят, выбирете другой");
    return 1;
}

stock StreetRacersBusi(playerid, br)
{
	DP[0][playerid] = br;
    if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вас преследует полиция");
    if(howstun(playerid) || HealthAC[playerid] <= 0) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
    if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return ErrorMessage(playerid, "{FF6347}Вы находитесь в слежке");
    format(lines,sizeof(lines),""); // Очищаем Lines
	PlayerPlaySound(playerid,40405,0,0,0);
    if(br >= 1 && br <= 12)
    {
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid,"{FF6347} Для заправки необходимо быть на транспорте");
 		new vehicle = GetPlayerVehicleID(playerid);
 		if(IsAVello(vehicle)) return ErrorMessage(playerid, "{FF6347}Велосипед нельзя заправить");
 		new fill = Gas[vehicle]+Gelium[vehicle];
        if(fill >= 99) return ErrorMessage(playerid, "{FF6347}Транспорт не нужно заправлять [ Бак полон ]");
        format(line, sizeof(line), "{ffffff}Сколько литров топлива вы хотите заправить?\n\n{cccccc}Стоимость 1 литра на этой заправке = {00cc00}%d$\n{cccccc}Для полного бака вам требуется: %d литров {99ff66}[%d$]",BizzInfo[br][bPrice][0],100-fill,(100-fill)*BizzInfo[br][bPrice][0]);
   		ShowDialog(playerid,484,DIALOG_STYLE_INPUT,"{0088ff}Заправка",line,"Принять","Отмена");
    }
    else if(br >= 153 && br <= 162)
	{
		//ApplyDynamicActorAnimation(BizTermActor[GetBizTermActorId(b)][term], "PED","endchat_03",4.0,0,1,1,0,0); // Машет рукой
		format(line,sizeof(line),"Товар\tСтоимость"), strcat(lines,line);
	   	format(line,sizeof(line),"\n{ff9000}Хот-Дог\t{99ff66}%d$",BizzInfo[br][bPrice][0]), strcat(lines,line);
		format(line,sizeof(line),"\n{ff9000}Sprunk\t{99ff66}%d$",BizzInfo[br][bPrice][1]), strcat(lines,line);
		ShowDialog(playerid,648,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Ларек с едой",lines,"Выбрать","Выход"); // 1157
	}
	return 1;
}

stock CheckpointRaceRout(playerid)
{
	new slot = raceRout[playerid];
	new r = carRaceCheckpoint[playerid];
	DisablePlayerRaceCheckpoint(playerid);
    if(r == 59) SetPlayerRaceCheckpoint(playerid,1,FullRout[slot][brCordX][r], FullRout[slot][brCordY][r], FullRout[slot][brCordZ][r],FullRout[slot][brCordX][r], FullRout[slot][brCordY][r], FullRout[slot][brCordZ][r],6.0);
	else SetPlayerRaceCheckpoint(playerid,0,FullRout[slot][brCordX][r], FullRout[slot][brCordY][r], FullRout[slot][brCordZ][r], FullRout[slot][brCordX][r+1], FullRout[slot][brCordY][r+1], FullRout[slot][brCordZ][r+1],6.0);
	return 1;
}

stock StartRace(playerid)
{
    new slot = StreetRacers[0][raceMap];
    for(new i; i < 8; i++)
    {
        if(StreetRacers[0][racersCount][i] != -1)
        {
            raceRout[StreetRacers[0][racersCount][i]] = slot;
            carRaceCheckpoint[StreetRacers[0][racersCount][i]] = 0;
            SetPlayerRaceCheckpoint(playerid,1,FullRout[slot][brCordX][0], FullRout[slot][brCordY][0], FullRout[slot][brCordZ][0],FullRout[slot][brCordX][0], FullRout[slot][brCordY][0], FullRout[slot][brCordZ][0],6.0);
        }   
    }
    SuccessMessage(playerid,"{99ff66} Вы объявили старт гонке!");
    return 1;
}
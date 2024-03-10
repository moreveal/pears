#define MAX_RACERS_POINT 1
#if defined isnull
	#undef isnull
#endif
#define isnull(%0) (!%0[0])
enum raceInfo
{
    raceStat, // Статус гонки
    Float: racePosMarket[6], // Позиция Тележки
    Float: racePosBenz[6], // Позиция Бензика
    Float: racePosService[6], // Позиция Сервиса
    Float: racePosTerminal[6], // Позиция Терминала
    Float: raceCordX[61],
    Float: raceCordY[61],
    Float: raceCordZ[61],
    raceMap, // Карта для гонки
    raceFamily, // Семья начавшего событие
    raceUnix, // Время на проведенную гонку
    racersCount[8], // Количество участников в гонке
    racersCountWinner[8], // Список победителей
    raceTimer, // Таймер отсчета для старта
    racePoints, // Количество поинтов в гонке
    racePlace[8] // Места в гонке
}
new StreetRacers[MAX_RACERS_POINT][raceInfo];
new RaceIcon[1];
new carRaceCheckpoint[MAX_REALPLAYERS],raceRout[MAX_REALPLAYERS];


stock ShowStreetRacers(playerid,family)
{
    new line[70],lines[350];
    format(line,sizeof(line),"Начать подготовку к сходке"), strcat(lines,line);
    if(FamilyInfo[family][fParthnerMarket] == 0) format(line,sizeof(line),"\nПартнерство с Ларьком с Едой. {FF6347}[Отсутствует]"), strcat(lines,line);
    else if(FamilyInfo[family][fParthnerMarket] != 0) format(line,sizeof(line),"\nПартнерство с Ларьком с Едой. {99ff66}[Бизнес № %d]", FamilyInfo[family][fParthnerMarket]), strcat(lines,line);
    if(FamilyInfo[family][fParthnerBenz] == 0) format(line,sizeof(line),"\nПартнерство с заправкой. {FF6347}[Отсутствует]"), strcat(lines,line);
    else if(FamilyInfo[family][fParthnerBenz] != 0) format(line,sizeof(line),"\nПартнерство с заправкой. {99ff66}[Бизнес № %d]", FamilyInfo[family][fParthnerBenz]), strcat(lines,line);
    if(FamilyInfo[family][fParthnerService] == 0) format(line,sizeof(line),"\nПартнерство с Автосервисом. {FF6347}[Отсутствует]"), strcat(lines,line);
    else if(FamilyInfo[family][fParthnerService] != 0) format(line,sizeof(line),"\nПартнерство с Автосервисом. {99ff66}[Бизнес № %d]", FamilyInfo[family][fParthnerService]), strcat(lines,line);
    format(line,sizeof(line),"\nСписок гоночных маршрутов семьи"), strcat(lines,line);
    ShowDialog(playerid,1457,DIALOG_STYLE_TABLIST,"{ff9000}StreetRacers Menu",lines,"Выбрать","Назад");
    return 1;
}

stock GoStreetRacers(playerid)
{
    new fId = PlayerInfo[playerid][pFamily];
    new tyear, tmonth, tday, thour, tminute, tsecond;
    new unixsecond = gettime();
    if(StreetRacers[0][raceStat] == 1 || StreetRacers[0][raceStat] == 2)
    {
        if(StreetRacers[0][raceFamily] == fId)
        {
            new line[70],lines[490];
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
            else if(StreetRacers[0][raceStat] > 1)
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
		ShowDialog(playerid,1451,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu","Начать сходку Стрит Рейсеров?","Да","Нет");
    }
    return 1;
}

stock CreatePartyStreet(playerid)
{
    if(StreetRacers[0][raceUnix] > 0 || StreetRacers[0][raceStat] > 0) return ErrorMessage(playerid,"{FF6347}Кто-то уже начал сбор");
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
    dyn_zone_zzRace = CreateDynamicSphere(StreetRacers[0][racePosTerminal][0],StreetRacers[0][racePosTerminal][1],StreetRacers[0][racePosTerminal][2], 50, 0, 0);
    for(new i; i < 8; i++)
    {
        StreetRacers[0][racersCount][i] = -1;   
        StreetRacers[0][racersCountWinner][i] = -1;
    }
    SuccessMessage(playerid,"{99ff66}Вы начали сходку StreetRacers");
    return 1;
}
CMD:closerace(playerid)
{
    if(PlayerInfo[playerid][pSoska] <= 3) ErrorMessage(playerid,"{FF6347}Закончить сходку предварительно могут только Админ 4+ лвла");
    ClosePartyStreet();
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
        if(StreetRacers[0][racersCount][p] == -1) continue;
        OnlineInfo[StreetRacers[0][racersCount][p]][oRacers] = 0;
        raceRout[StreetRacers[0][racersCount][p]] = -1;
        carRaceCheckpoint[StreetRacers[0][racersCount][p]] = -1;
        StreetRacers[0][racersCountWinner][p] = -1;
        DisablePlayerRaceCheckpoint(StreetRacers[0][racersCount][p]);
        DestroyRaceDrawForPlayer(StreetRacers[0][racersCount][p]);
        StreetRacers[0][racersCount][p] = -1;
    }

    StreetRacers[0][racePosMarket][0] = 0.0, StreetRacers[0][racePosMarket][1] = 0.0;
    StreetRacers[0][racePosBenz][0] = 0.0, StreetRacers[0][racePosBenz][1] = 0.0;
    StreetRacers[0][racePosService][0] = 0.0, StreetRacers[0][racePosService][1] = 0.0;
    StreetRacers[0][racePosTerminal][0] = 0.0, StreetRacers[0][racePosTerminal][1] = 0.0;
    
    if(RaceIcon[0] != 0) DestroyDynamicMapIcon(RaceIcon[0]);
    DestroyDynamicArea(dyn_zone_zzRace);
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
        else cmd_fam(playerid);
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
        new fam = PlayerInfo[playerid][pFamily];
        if(response)
		{
            if(listitem < 0 || listitem > 4) return 0;
            if(listitem == 0)
            {
                if(PlayerInfo[playerid][pFamrank] < FamilyInfo[fam][fRanks]) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вы не глава семьи и не можете управлять данным мероприятием");
                if(FamilyInfo[fam][fParthnerBenz] == 0 || FamilyInfo[fam][fParthnerMarket] == 0 || FamilyInfo[fam][fParthnerService] == 0) return ErrorMessage(playerid, "{FF6347}Нужно что бы все партнерства были заключены");
                if(StreetRacers[0][raceStat] == 3) return ErrorMessage(playerid, "{FF6347}Сейчас идет гонка");
                GoStreetRacers(playerid);
            }
            if(listitem == 1)
            {
                if(PlayerInfo[playerid][pFamrank] < FamilyInfo[fam][fRanks]) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вы не глава семьи и не можете управлять данным мероприятием");
                if(FamilyInfo[fam][fParthnerMarket] == 0)
                {
                    ErrorMessage(playerid,"{FF6347}У семьи нет партнера данного типа.\n Возможно стоит связаться с владельцем одного из бизнесов");
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Было бы неплохо связаться с владельцем и заключить партнерство");
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Участникам мероприятия будет комфортно если будет где быстро перекусить");
                }
                else if(FamilyInfo[fam][fParthnerMarket] != 0)
                {
                    DP[1][playerid] = listitem;
		            ShowDialog(playerid,1458,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu","Расторгнуть партнерство?","Да","Нет");
                }
            }
            if(listitem == 2)
            {
                if(PlayerInfo[playerid][pFamrank] < FamilyInfo[fam][fRanks]) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вы не глава семьи и не можете управлять данным мероприятием");
                if(FamilyInfo[fam][fParthnerBenz] == 0)
                {
                    ErrorMessage(playerid,"{FF6347}У семьи нет партнера данного типа.\n Возможно стоит связаться с владельцем одного из бизнесов");
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Было бы неплохо связаться с владельцем и заключить партнерство");
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Участникам мероприятия будет комфортно если будет колонка с бензином");
                }
                else if(FamilyInfo[fam][fParthnerBenz] != 0)
                {
                    DP[1][playerid] = listitem;
		            ShowDialog(playerid,1458,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu","Расторгнуть партнерство?","Да","Нет");
                }
            }
            if(listitem == 3)
            {
                if(PlayerInfo[playerid][pFamrank] < FamilyInfo[fam][fRanks]) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вы не глава семьи и не можете управлять данным мероприятием");
                if(FamilyInfo[fam][fParthnerService] == 0)
                {
                    ErrorMessage(playerid,"{FF6347}У семьи нет партнера данного типа.\n Возможно стоит связаться с владельцем одного из бизнесов");
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Было бы неплохо связаться с владельцем и заключить партнерство");
                    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Участникам мероприятия будет комфортно если будет где быстро перекусить");
                }
                else if(FamilyInfo[fam][fParthnerService] != 0)
                {
                    DP[1][playerid] = listitem;
		            ShowDialog(playerid,1458,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu","Расторгнуть партнерство?","Да","Нет");                    
                }
            }
            if(listitem == 4)
            {
                ShowAllRoutRace(playerid,0);
            }
		}
		else cmd_fam(playerid);
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
            if(StreetRacers[0][racersCount][number] != -1) return ErrorMessage(playerid,"{FF6347} Слот занят, выбирете другой");
            StreetRacers[0][racersCount][number] = playerid;
            SuccessMessage(playerid, "Вы успешно зарегестрировались на гонку");
		}
    }
    else if(dialogid == 1461)
    {
        if(response)
        {
            if(listitem == 0)
            {
                if(StreetRacers[0][raceStat] == 3) return ErrorMessage(playerid,"{FF6347} Можно провести только одну гонку за сходку");
		        ShowDialog(playerid,1464,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu","Вы уверены что хотите начать гонку?","Да","Нет");     
            }
            if(listitem == 1)
            {
                if(StreetRacers[0][raceStat] == 3) return ErrorMessage(playerid,"{FF6347} Можно провести только одну гонку за сходку");
                ShowAllRoutRace(playerid,2);
            }
            if(listitem == 2)
            {
                if(StreetRacers[0][raceStat] == 3) return ErrorMessage(playerid,"{FF6347} Список победителей можно посмотреть в терминале");
                ListRegisterToRace(playerid,1);
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
			if(listitem > 5 || listitem < 0) return 0;
			new slot = List[listitem][playerid];
            new fam = PlayerInfo[playerid][pFamily];
            if(FamilyInfo[fam][fRoutIdCreator][slot] == 0) return ErrorMessage(playerid,"{ff4367}Маршрут пустой");
			DP[0][playerid] = -1;
			StreetRacers[0][raceMap] = slot;
            SuccessMessage(playerid,"{99ff66}Вы успешно выбрали карту для гонки");
		}
    }
    else if(dialogid == 1464)
    {
        if(response)
		{
            ShowDialog(playerid,1467,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu","Вы уверены что хотите начать гонку?\nВсе игроки заморозятся на 5 секунд, и будет дан отсчет до начала гонки","Да","Нет");
		}
        else return GoStreetRacers(playerid);
    }
    else if(dialogid == 1465)
    {
        if(response)
        {
            if(listitem < 0 || listitem > 9) return ErrorMessage(playerid,"{FF6347}Лист итем паленый броооооо");
            {
                new listord = List[listitem][playerid];
                DP[1][playerid] = listord;
                SettingRegisterToRace(playerid, listord);
            }
        }
    }
    else if(dialogid == 1466)
    {
        if(response)
		{
            new target = DP[1][playerid];
            ErrorMessage(StreetRacers[0][racersCount][target], "{FF6347}Вас исключили из участников гонки");
            LeaveRace(target);
		}
        else return ListRegisterToRace(playerid,1);
    }
    else if(dialogid == 1467)
    {
        if(response)
		{
            StartRace(playerid);
		}
        else return GoStreetRacers(playerid);
    }
    else if(dialogid == 1468)
    {
        new fam = PlayerInfo[playerid][pFamily];
        if(response)
        {
        	if(listitem > 5 || listitem < 0) return 0;
			new slot = List[listitem][playerid],who;
			if(FamilyInfo[fam][fRoutIdCreator][slot] == PlayerInfo[playerid][pID]) who = 1;
			SettingRoutRace(playerid,slot, who);
		}
        else return ShowStreetRacers(playerid,fam);
    }
    else if(dialogid == 1469)
    {
        if(response)
        {
            if(listitem > 5 || listitem < 0) return 0;
			new slot = List[listitem][playerid];
            SaveRoutRace(playerid,slot,0);
		}
    }
    else if(dialogid == 1470)
	{
		if(response)
		{	
            new fam = PlayerInfo[playerid][pFamily];
			new slot = DP[0][playerid];
			if(slot == 0)
            {
                for(new z = 0; z < 60; z++)
                {
                    if(FamilyInfo[fam][fRoudLoad1X][z] != 0 && FamilyInfo[fam][fRoudLoad1Y][z] != 0)
                    {
                        PlayerInfo[playerid][CheckPointX][z] = 0;
                        PlayerInfo[playerid][CheckPointX][z] = FamilyInfo[fam][fRoudLoad1X][z];
                        PlayerInfo[playerid][CheckPointY][z] = 0;
                        PlayerInfo[playerid][CheckPointY][z] = FamilyInfo[fam][fRoudLoad1Y][z];
                        PlayerInfo[playerid][CheckPointZ][z] = 0;
                        PlayerInfo[playerid][CheckPointZ][z] = FamilyInfo[fam][fRoudLoad1Z][z];
                        PlayerInfo[playerid][pCheckPointCount][z] = 1;
                    }
                }
            }
            else if(slot == 1)
            {
                for(new z = 0; z < 60; z++)
                {
                    if(FamilyInfo[fam][fRoudLoad2X][z] != 0 && FamilyInfo[fam][fRoudLoad2Y][z] != 0)
                    {
                        PlayerInfo[playerid][CheckPointX][z] = 0;
                        PlayerInfo[playerid][CheckPointX][z] = FamilyInfo[fam][fRoudLoad2X][z];
                        PlayerInfo[playerid][CheckPointY][z] = 0;
                        PlayerInfo[playerid][CheckPointY][z] = FamilyInfo[fam][fRoudLoad2Y][z];
                        PlayerInfo[playerid][CheckPointZ][z] = 0;
                        PlayerInfo[playerid][CheckPointZ][z] = FamilyInfo[fam][fRoudLoad2Z][z];
                        PlayerInfo[playerid][pCheckPointCount][z] = 1;
                    }
                }
            }
            else if(slot == 2)
            {
                for(new z = 0; z < 60; z++)
                {
                    if(FamilyInfo[fam][fRoudLoad3X][z] != 0 && FamilyInfo[fam][fRoudLoad3Y][z] != 0)
                    {
                        PlayerInfo[playerid][CheckPointX][z] = 0;
                        PlayerInfo[playerid][CheckPointX][z] = FamilyInfo[fam][fRoudLoad3X][z];
                        PlayerInfo[playerid][CheckPointY][z] = 0;
                        PlayerInfo[playerid][CheckPointY][z] = FamilyInfo[fam][fRoudLoad3Y][z];
                        PlayerInfo[playerid][CheckPointZ][z] = 0;
                        PlayerInfo[playerid][CheckPointZ][z] = FamilyInfo[fam][fRoudLoad3Z][z];
                        PlayerInfo[playerid][pCheckPointCount][z] = 1;
                    }
                }
            }
            else if(slot == 3)
            {
                for(new z = 0; z < 60; z++)
                {
                    if(FamilyInfo[fam][fRoudLoad4X][z] != 0 && FamilyInfo[fam][fRoudLoad4Y][z] != 0)
                    {
                        PlayerInfo[playerid][CheckPointX][z] = 0;
                        PlayerInfo[playerid][CheckPointX][z] = FamilyInfo[fam][fRoudLoad4X][z];
                        PlayerInfo[playerid][CheckPointY][z] = 0;
                        PlayerInfo[playerid][CheckPointY][z] = FamilyInfo[fam][fRoudLoad4Y][z];
                        PlayerInfo[playerid][CheckPointZ][z] = 0;
                        PlayerInfo[playerid][CheckPointZ][z] = FamilyInfo[fam][fRoudLoad4Z][z];
                        PlayerInfo[playerid][pCheckPointCount][z] = 1;
                    }
                }       
            }
            else if(slot == 4)
            {
                for(new z = 0; z < 60; z++)
                {
                    if(FamilyInfo[fam][fRoudLoad5X][z] != 0 && FamilyInfo[fam][fRoudLoad5Y][z] != 0)
                    {
                        PlayerInfo[playerid][CheckPointX][z] = 0;
                        PlayerInfo[playerid][CheckPointX][z] = FamilyInfo[fam][fRoudLoad5X][z];
                        PlayerInfo[playerid][CheckPointY][z] = 0;
                        PlayerInfo[playerid][CheckPointY][z] = FamilyInfo[fam][fRoudLoad5Y][z];
                        PlayerInfo[playerid][CheckPointZ][z] = 0;
                        PlayerInfo[playerid][CheckPointZ][z] = FamilyInfo[fam][fRoudLoad5Z][z];
                        PlayerInfo[playerid][pCheckPointCount][z] = 1;
                    }
                }
            }
            SuccessMessage(playerid,"{99ff66}Маршрут успешно загружен [/scpa]");
		}
		else return 0;
	}
	else if(dialogid == 1471)
	{
		if(response)
		{
            new fam = PlayerInfo[playerid][pFamily];
            new slot = DP[0][playerid];
            if(listitem == 0)
            {
                if(slot == 0)
                {
                    for(new z = 0; z < 60; z++)
                    {
                        if(FamilyInfo[fam][fRoudLoad1X][z] != 0 && FamilyInfo[fam][fRoudLoad1Y][z] != 0)
                        {
                            PlayerInfo[playerid][CheckPointX][z] = 0;
                            PlayerInfo[playerid][CheckPointX][z] = FamilyInfo[fam][fRoudLoad1X][z];
                            PlayerInfo[playerid][CheckPointY][z] = 0;
                            PlayerInfo[playerid][CheckPointY][z] = FamilyInfo[fam][fRoudLoad1Y][z];
                            PlayerInfo[playerid][CheckPointZ][z] = 0;
                            PlayerInfo[playerid][CheckPointZ][z] = FamilyInfo[fam][fRoudLoad1Z][z];
                            PlayerInfo[playerid][pCheckPointCount][z] = 1;
                        }
                    }
                }
                else if(slot == 1)
                {
                    for(new z = 0; z < 60; z++)
                    {
                        if(FamilyInfo[fam][fRoudLoad2X][z] != 0 && FamilyInfo[fam][fRoudLoad2Y][z] != 0)
                        {
                            PlayerInfo[playerid][CheckPointX][z] = 0;
                            PlayerInfo[playerid][CheckPointX][z] = FamilyInfo[fam][fRoudLoad2X][z];
                            PlayerInfo[playerid][CheckPointY][z] = 0;
                            PlayerInfo[playerid][CheckPointY][z] = FamilyInfo[fam][fRoudLoad2Y][z];
                            PlayerInfo[playerid][CheckPointZ][z] = 0;
                            PlayerInfo[playerid][CheckPointZ][z] = FamilyInfo[fam][fRoudLoad2Z][z];
                            PlayerInfo[playerid][pCheckPointCount][z] = 1;
                        }
                    }
                }
                else if(slot == 2)
                {
                    for(new z = 0; z < 60; z++)
                    {
                        if(FamilyInfo[fam][fRoudLoad3X][z] != 0 && FamilyInfo[fam][fRoudLoad3Y][z] != 0)
                        {
                            PlayerInfo[playerid][CheckPointX][z] = 0;
                            PlayerInfo[playerid][CheckPointX][z] = FamilyInfo[fam][fRoudLoad3X][z];
                            PlayerInfo[playerid][CheckPointY][z] = 0;
                            PlayerInfo[playerid][CheckPointY][z] = FamilyInfo[fam][fRoudLoad3Y][z];
                            PlayerInfo[playerid][CheckPointZ][z] = 0;
                            PlayerInfo[playerid][CheckPointZ][z] = FamilyInfo[fam][fRoudLoad3Z][z];
                            PlayerInfo[playerid][pCheckPointCount][z] = 1;
                        }
                    }
                }
                else if(slot == 3)
                {
                    for(new z = 0; z < 60; z++)
                    {
                        if(FamilyInfo[fam][fRoudLoad4X][z] != 0 && FamilyInfo[fam][fRoudLoad4Y][z] != 0)
                        {
                            PlayerInfo[playerid][CheckPointX][z] = 0;
                            PlayerInfo[playerid][CheckPointX][z] = FamilyInfo[fam][fRoudLoad4X][z];
                            PlayerInfo[playerid][CheckPointY][z] = 0;
                            PlayerInfo[playerid][CheckPointY][z] = FamilyInfo[fam][fRoudLoad4Y][z];
                            PlayerInfo[playerid][CheckPointZ][z] = 0;
                            PlayerInfo[playerid][CheckPointZ][z] = FamilyInfo[fam][fRoudLoad4Z][z];
                            PlayerInfo[playerid][pCheckPointCount][z] = 1;
                        }
                    }       
                }
                else if(slot == 4)
                {
                    for(new z = 0; z < 60; z++)
                    {
                        if(FamilyInfo[fam][fRoudLoad5X][z] != 0 && FamilyInfo[fam][fRoudLoad5Y][z] != 0)
                        {
                            PlayerInfo[playerid][CheckPointX][z] = 0;
                            PlayerInfo[playerid][CheckPointX][z] = FamilyInfo[fam][fRoudLoad5X][z];
                            PlayerInfo[playerid][CheckPointY][z] = 0;
                            PlayerInfo[playerid][CheckPointY][z] = FamilyInfo[fam][fRoudLoad5Y][z];
                            PlayerInfo[playerid][CheckPointZ][z] = 0;
                            PlayerInfo[playerid][CheckPointZ][z] = FamilyInfo[fam][fRoudLoad5Z][z];
                            PlayerInfo[playerid][pCheckPointCount][z] = 1;
                        }
                    }
                }
                SuccessMessage(playerid,"{99ff66}Маршрут успешно загружен [/scpa]");
            }
            if(listitem == 2)
            {
                SaveRoutRace(playerid,slot,1);
                SuccessMessage(playerid,"{99ff66} Маршрут удален");
            }
            if(listitem == 1)
            {
                SaveRoutRace(playerid,slot,0);
                SuccessMessage(playerid,"{99ff66} Маршрут обновлен");
            }
		}
	}
    return 1;
}
stock settingpartner(playerid, b, number) // Управление партнерством
{
    new line[60],lines[180];
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
        new fam = PlayerInfo[giveplayerid][pFamily];
        if(PlayerInfo[giveplayerid][pFamrank] < FamilyInfo[fam][fRanks]) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок не глава семьи и не может принять предложение");
        if(b >= 1 && b <= 12 && FamilyInfo[fam][fParthnerBenz] != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У семьи Игрока уже заключено партнерство с подобным бизнесом");
        else if(b >= 153 && b <= 162 && FamilyInfo[fam][fParthnerMarket] != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У семьи Игрока уже заключено партнерство с подобным бизнесом");
        else if(b >= 183 && b <= 192 && FamilyInfo[fam][fParthnerService] != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У семьи Игрока уже заключено партнерство с подобным бизнесом");
        //if(giveplayerid == playerid) return ErrorMessage(playerid, "{FF6347}Вы не можете заключить партнерство с собой");
        DP[0][giveplayerid] = b;
        DP[1][giveplayerid] = playerid;
        DP[2][giveplayerid] = number;
        DP[3][giveplayerid] = fam;

        new line[60],lines[180];
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

stock ListRegisterToRace(playerid, type)
{
    new quan;
	new line[50],lines[450];
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
	if(type == 0) ShowDialog(playerid,1459,DIALOG_STYLE_TABLIST,"{cccccc}Сходка StreetRacers",lines,"Выбрать","Отмена");
    else if(type == 1) ShowDialog(playerid,1465,DIALOG_STYLE_TABLIST,"{cccccc}Сходка StreetRacers",lines,"Выбрать","Отмена");
	return 1;
}

stock SettingRegisterToRace(playerid, number)
{
    if(StreetRacers[0][racersCount][number] != -1)
    {
		ShowDialog(playerid,1466,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu","Выгнать игрока из списка участников?","Да","Нет");
    }
    else return ErrorMessage(playerid,"{FF6347} Слот пустой, выбирете другой");
    return 1;
}

stock RegisterToRace(playerid, number)
{
    if(StreetRacers[0][raceStat] != 3)
    {
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
            ShowDialog(playerid,1460,DIALOG_STYLE_MSGBOX,"{ff9000}StreetRacers Menu","Занять место в гонке?","Да","Нет");
        }
        else return ErrorMessage(playerid,"{FF6347}Слот занят, выберите другой");
    }
    else if(StreetRacers[0][raceStat] == 3)
    {
        new line[40],lines[360];
        format(line,sizeof(line),"Позиция Имя победителя"), strcat(lines,line);
        for(new i; i < 8; i++)
        {
            format(line,sizeof(line),"\n{ff9000}%d. %s", i+1, rpplayername(StreetRacers[0][racersCount][i])), strcat(lines,line);
        }
        ShowDialog(playerid,1742,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}StreetRacers Menu",lines,"Выход","");
    }
    return 1;
}

stock StreetRacersBusi(playerid, br)
{
	DP[0][playerid] = br;
    if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вас преследует полиция");
    if(howstun(playerid) || HealthAC[playerid] <= 0) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
    if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return ErrorMessage(playerid, "{FF6347}Вы находитесь в слежке");
	PlayerPlaySound(playerid,40405,0,0,0);
    if(br >= 1 && br <= 12)
    {
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid,"{FF6347} Для заправки необходимо быть на транспорте");
 		new vehicle = GetPlayerVehicleID(playerid);
 		if(IsAVello(vehicle)) return ErrorMessage(playerid, "{FF6347}Велосипед нельзя заправить");
 		new fill = Gas[vehicle]+Gelium[vehicle];
        if(fill >= 99) return ErrorMessage(playerid, "{FF6347}Транспорт не нужно заправлять [ Бак полон ]");
        new string[200];
        format(string, sizeof(string), "{ffffff}Сколько литров топлива вы хотите заправить?\n\n{cccccc}Стоимость 1 литра на этой заправке = {99ff66}%d$\n{cccccc}Для полного бака вам требуется: %d литров {99ff66}[%d$]",BizzInfo[br][bPrice][0],100-fill,(100-fill)*BizzInfo[br][bPrice][0]);
   		ShowDialog(playerid,484,DIALOG_STYLE_INPUT,"{0088ff}Заправка",string,"Принять","Отмена");
    }
    else if(br >= 153 && br <= 162)
	{
        new line[50],lines[150];
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
	new r = carRaceCheckpoint[playerid];
    PlayerPlaySound(playerid,1150,0,0,0);
	DisablePlayerRaceCheckpoint(playerid);
    if(r >= 59) return RaceWinner(playerid);
    else
    {
        if(StreetRacers[0][raceCordX][r] != 0.0 && StreetRacers[0][raceCordY][r] != 0.0 && StreetRacers[0][raceCordX][r+1] == 0.0 && StreetRacers[0][raceCordY][r+1] == 0.0) SetPlayerRaceCheckpoint(playerid,1,StreetRacers[0][raceCordX][r], StreetRacers[0][raceCordY][r], StreetRacers[0][raceCordZ][r], StreetRacers[0][raceCordX][r], StreetRacers[0][raceCordY][r], StreetRacers[0][raceCordZ][r],7.0);
	    else if(StreetRacers[0][raceCordX][r+1] != 0.0 && StreetRacers[0][raceCordY][r+1] != 0.0) SetPlayerRaceCheckpoint(playerid,0,StreetRacers[0][raceCordX][r], StreetRacers[0][raceCordY][r], StreetRacers[0][raceCordZ][r], StreetRacers[0][raceCordX][r+1], StreetRacers[0][raceCordY][r+1], StreetRacers[0][raceCordZ][r+1],7.0);
        else if(StreetRacers[0][raceCordX][r] == 0.0 && StreetRacers[0][raceCordY][r] == 0.0) return RaceWinner(playerid);
    }
    UpdatePointRace(0, playerid);
	return 1;
}

stock StartRace(playerid)
{
    StreetRacers[0][raceStat] = 3;
    for(new i; i < 8; i++)
    {
        if(StreetRacers[0][racersCount][i] != -1)
        {
            OnlineInfo[StreetRacers[0][racersCount][i]][oRacers] = 1;
            TogglePlayerControllable(StreetRacers[0][racersCount][i],0);
            StreetRacers[0][raceTimer] = 5;
        }   
    }
    UpdatePointRaceStart(0);
    new fam = StreetRacers[0][raceFamily];

    StreetRacers[0][racePoints] = 0;
    for(new i; i < 60; i++)
    {
        StreetRacers[0][raceCordX][i] = 0.0;
        StreetRacers[0][raceCordY][i] = 0.0;
        StreetRacers[0][raceCordZ][i] = 0.0;

        if(StreetRacers[0][raceMap] == 0)
        {
            StreetRacers[0][raceCordX][i] = FamilyInfo[fam][fRoudLoad1X][i];
            StreetRacers[0][raceCordY][i] = FamilyInfo[fam][fRoudLoad1Y][i];
            StreetRacers[0][raceCordZ][i] = FamilyInfo[fam][fRoudLoad1Z][i];
        }
        else if(StreetRacers[0][raceMap] == 1)
        {
            StreetRacers[0][raceCordX][i] = FamilyInfo[fam][fRoudLoad2X][i];
            StreetRacers[0][raceCordY][i] = FamilyInfo[fam][fRoudLoad2Y][i];
            StreetRacers[0][raceCordZ][i] = FamilyInfo[fam][fRoudLoad2Z][i];
        }
        else if(StreetRacers[0][raceMap] == 2)
        {
            StreetRacers[0][raceCordX][i] = FamilyInfo[fam][fRoudLoad3X][i];
            StreetRacers[0][raceCordY][i] = FamilyInfo[fam][fRoudLoad3Y][i];
            StreetRacers[0][raceCordZ][i] = FamilyInfo[fam][fRoudLoad3Z][i];
        }
        else if(StreetRacers[0][raceMap] == 3)
        {
            StreetRacers[0][raceCordX][i] = FamilyInfo[fam][fRoudLoad4X][i];
            StreetRacers[0][raceCordY][i] = FamilyInfo[fam][fRoudLoad4Y][i];
            StreetRacers[0][raceCordZ][i] = FamilyInfo[fam][fRoudLoad4Z][i];
        }
        else if(StreetRacers[0][raceMap] == 4)
        {
            StreetRacers[0][raceCordX][i] = FamilyInfo[fam][fRoudLoad5X][i];
            StreetRacers[0][raceCordY][i] = FamilyInfo[fam][fRoudLoad5Y][i];
            StreetRacers[0][raceCordZ][i] = FamilyInfo[fam][fRoudLoad5Z][i];
        }

        if(StreetRacers[0][raceCordX][i] != 0.0 && StreetRacers[0][raceCordY][i] != 0.0) StreetRacers[0][racePoints] ++;
    }
    StreetRacers[0][raceCordX][60] = 0.0;
    StreetRacers[0][raceCordY][60] = 0.0;
    StreetRacers[0][raceCordZ][60] = 0.0;
    SuccessMessage(playerid,"{99ff66} Вы объявили начало гонке!");
    return 1;
}

stock TimerToStart()
{
    StreetRacers[0][raceTimer]--;
    if(StreetRacers[0][raceTimer] > 0)
    {
        for(new i; i < 8; i++)
        {
            if(StreetRacers[0][racersCount][i] != -1)
            {
                new string[4];
                PlayerPlaySound(StreetRacers[0][racersCount][i],1056,0,0,0);
                format(string,sizeof(string),"%d",StreetRacers[0][raceTimer]);
                GameTextForPlayer(StreetRacers[0][racersCount][i], string, 2000, 6);
            }
        }
    }
    else if(StreetRacers[0][raceTimer] == 0)
    {
        for(new i; i < 8; i++)
        {
            if(StreetRacers[0][racersCount][i] != -1)
            {
                TogglePlayerControllable(StreetRacers[0][racersCount][i],1);
                PlayerPlaySound(StreetRacers[0][racersCount][i],3201,0,0,0);
                GameTextForPlayer(StreetRacers[0][racersCount][i], "~g~ GO!", 2000, 6);
                carRaceCheckpoint[StreetRacers[0][racersCount][i]] = 0;
                SetPlayerRaceCheckpoint(StreetRacers[0][racersCount][i],0,StreetRacers[0][raceCordX][0], StreetRacers[0][raceCordY][0], StreetRacers[0][raceCordZ][0],StreetRacers[0][raceCordX][1],StreetRacers[0][raceCordY][1],StreetRacers[0][raceCordZ][1],6.0);
            }
        } 
    }
}

stock LeaveRace(playerid)
{
    for(new checking; checking < 8; checking++)
	{
		if(StreetRacers[0][racersCount][checking] == playerid)
		{
            OnlineInfo[playerid][oRacers] = 0;
			StreetRacers[0][racersCount][checking] = -1;
			break;
		}
	}

    DestroyRaceDrawForPlayer(playerid);
    return 1;
}
CMD:stoprace(playerid)
{
    if(PlayerInfo[playerid][pSoska] == 0) return 0;
    StreetRacers[0][raceStat] = 2;
    for(new p; p < 8; p++)
    {
        if(StreetRacers[0][racersCount][p] == -1) continue;
        OnlineInfo[StreetRacers[0][racersCount][p]][oRacers] = 0;
        raceRout[StreetRacers[0][racersCount][p]] = -1;
        carRaceCheckpoint[StreetRacers[0][racersCount][p]] = -1;
        StreetRacers[0][racersCountWinner][p] = -1;
        DisablePlayerRaceCheckpoint(playerid);
        DestroyRaceDrawForPlayer(playerid);
    }
    return 1;
}
stock RaceWinner(playerid)
{
    new quan;
    for(new checking; checking < 8; checking++)
	{
		if(StreetRacers[0][racersCountWinner][checking] == -1)
		{
			StreetRacers[0][racersCountWinner][checking] = playerid;
			break;
		}
        quan++;
	}

    new string[100];
    format(string,sizeof(string),"[ Мысли ]: Я завершил гонку на %d месте",quan+1);
    SendClientMessage(playerid,COLOR_GREY,string);
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 0) continue;
        if(IsPlayerInRangeOfPoint(i,50.0,StreetRacers[0][racePosTerminal][0],StreetRacers[0][racePosTerminal][1],StreetRacers[0][racePosTerminal][2])
         && GetPlayerVirtualWorld(i) == 0 && GetPlayerInterior(i) == 0 || OnlineInfo[i][oRacers] == 1)
        {
            format(string,sizeof(string), " SMS от Оператора Гонки: {99ff33}Участник %s завершил гонку на %d месте",rpplayername(playerid),quan+1);
            SendClientMessage(i,COLOR_YELLOW,string);
        }
    }
    new quanrace,quanwin;
    for(new checking; checking < 8; checking++)
	{
		if(StreetRacers[0][racersCount][checking] != -1) quanrace++;
        if(StreetRacers[0][racersCountWinner][checking] != -1) quanwin++;
	}
    if(quanrace <= quanwin) StreetRacers[0][raceStat] = 2;

    DestroyRaceDrawForPlayer(playerid);
    return 1;
}

stock SaveRoutRace(playerid,slot,status)
{
    new fam = PlayerInfo[playerid][pFamily];
    if(fam < 0) return 0;
    new strocaX[600];
    new strocaY[600];
    new strocaZ[600];
    new string_mysql[3200];
    new quan;
    if(status == 0)
    {
        if(FamilyInfo[fam][fRoutIdCreator][slot] == 0) 
        {
            format(FamilyRoutNameCreator[fam][slot],24,PlayerInfo[playerid][pName]);
            FamilyInfo[fam][fRoutIdCreator][slot] = PlayerInfo[playerid][pID];
        }
        else if(FamilyInfo[fam][fRoutIdCreator][slot] != 0)
        {
            FamilyInfo[fam][fRoutIdEditor][slot] = PlayerInfo[playerid][pID];
            format(FamilyRoutNameEditor[fam][slot],24,PlayerInfo[playerid][pName]);
        }
        FamilyInfo[fam][fRoutUnix][slot] = gettime();
        if(slot == 0)
        {
            for(new i = 0; i < 60; i++) 
            {
                FamilyInfo[fam][fRoudLoad1X][i] = 0;
                FamilyInfo[fam][fRoudLoad1Y][i] = 0; 
                FamilyInfo[fam][fRoudLoad1Z][i] = 0; 

                if(PlayerInfo[playerid][CheckPointX][i] == 0.0 && PlayerInfo[playerid][CheckPointY][i] == 0.0) 
                {
                    continue;
                }
                FamilyInfo[fam][fRoudLoad1X][quan] = PlayerInfo[playerid][CheckPointX][i];
                FamilyInfo[fam][fRoudLoad1Y][quan] = PlayerInfo[playerid][CheckPointY][i];
                FamilyInfo[fam][fRoudLoad1Z][quan] = PlayerInfo[playerid][CheckPointZ][i];
                if(quan == 0)
                {
                    format(strocaX,sizeof(strocaX),"%.2f",PlayerInfo[playerid][CheckPointX][i]);
                    format(strocaY,sizeof(strocaY),"%.2f",PlayerInfo[playerid][CheckPointY][i]);
                    format(strocaZ,sizeof(strocaZ),"%.2f",PlayerInfo[playerid][CheckPointZ][i]);
                }
                else
                {
                    format(strocaX,sizeof(strocaX),"%s_%.2f",strocaX,PlayerInfo[playerid][CheckPointX][i]);
                    format(strocaY,sizeof(strocaY),"%s_%.2f",strocaY,PlayerInfo[playerid][CheckPointY][i]);
                    format(strocaZ,sizeof(strocaZ),"%s_%.2f",strocaZ,PlayerInfo[playerid][CheckPointZ][i]);
                }
                quan++;
                PlayerInfo[playerid][CheckPointX][i] = 0.0, PlayerInfo[playerid][CheckPointY][i] = 0.0,PlayerInfo[playerid][CheckPointZ][i] = 0.0,PlayerInfo[playerid][pCheckPointCount][i] = 0;
            }
            format(string_mysql, sizeof(string_mysql), "UPDATE `pp_family` SET `Rout1X`='%s',`Rout1Y`='%s',`Rout1Z`='%s',\
            `routNameCreator1`='%s',`routNameEditor1`='%s',`routIdCreator1`='%d',`routIdEditor1`='%d',`routUnix1`='%d' WHERE `id`='%d'",
            strocaX,strocaY,strocaZ,FamilyRoutNameCreator[fam][slot],FamilyRoutNameEditor[fam][slot],FamilyInfo[fam][fRoutIdCreator][slot],
            FamilyInfo[fam][fRoutIdEditor][slot],FamilyInfo[fam][fRoutUnix][slot], fam); // 199 + 480 + 480 + 480 + 24 + 24 + 44
            query_empty(pearsq, string_mysql);
        }
        else if(slot == 1)
        {
            for(new i = 0; i < 60; i++) 
            {
                FamilyInfo[fam][fRoudLoad2X][i] = 0;
                FamilyInfo[fam][fRoudLoad2Y][i] = 0; 
                FamilyInfo[fam][fRoudLoad2Z][i] = 0; 

                if(PlayerInfo[playerid][CheckPointX][i] == 0.0 && PlayerInfo[playerid][CheckPointY][i] == 0.0) 
                {
                    continue;
                }
                FamilyInfo[fam][fRoudLoad2X][quan] = PlayerInfo[playerid][CheckPointX][i];
                FamilyInfo[fam][fRoudLoad2Y][quan] = PlayerInfo[playerid][CheckPointY][i];
                FamilyInfo[fam][fRoudLoad2Z][quan] = PlayerInfo[playerid][CheckPointZ][i];
                if(quan == 0)
                {
                    format(strocaX,sizeof(strocaX),"%.2f",PlayerInfo[playerid][CheckPointX][i]);
                    format(strocaY,sizeof(strocaY),"%.2f",PlayerInfo[playerid][CheckPointY][i]);
                    format(strocaZ,sizeof(strocaZ),"%.2f",PlayerInfo[playerid][CheckPointZ][i]);
                }
                else
                {
                    format(strocaX,sizeof(strocaX),"%s_%.2f",strocaX,PlayerInfo[playerid][CheckPointX][i]);
                    format(strocaY,sizeof(strocaY),"%s_%.2f",strocaY,PlayerInfo[playerid][CheckPointY][i]);
                    format(strocaZ,sizeof(strocaZ),"%s_%.2f",strocaZ,PlayerInfo[playerid][CheckPointZ][i]);
                }
                quan++;
                PlayerInfo[playerid][CheckPointX][i] = 0.0, PlayerInfo[playerid][CheckPointY][i] = 0.0,PlayerInfo[playerid][CheckPointZ][i] = 0.0,PlayerInfo[playerid][pCheckPointCount][i] = 0;
            }
            format(string_mysql, sizeof(string_mysql), "UPDATE `pp_family` SET `Rout2X`='%s',`Rout2Y`='%s',`Rout2Z`='%s',\
            `routNameCreator2`='%s',`routNameEditor2`='%s',`routIdCreator2`='%d',`routIdEditor2`='%d',`routUnix2`='%d' WHERE `id`='%d'",
            strocaX,strocaY,strocaZ,FamilyRoutNameEditor[fam][slot],FamilyRoutNameCreator[fam][slot],FamilyInfo[fam][fRoutIdCreator][slot],
            FamilyInfo[fam][fRoutIdEditor][slot],FamilyInfo[fam][fRoutUnix][slot], fam);
            query_empty(pearsq, string_mysql);
        }
        else if(slot == 2)
        {
            for(new i = 0; i < 60; i++) 
            {
                FamilyInfo[fam][fRoudLoad3X][i] = 0;
                FamilyInfo[fam][fRoudLoad3Y][i] = 0; 
                FamilyInfo[fam][fRoudLoad3Z][i] = 0; 

                if(PlayerInfo[playerid][CheckPointX][i] == 0.0 && PlayerInfo[playerid][CheckPointY][i] == 0.0) 
                {
                    continue;
                }
                FamilyInfo[fam][fRoudLoad3X][quan] = PlayerInfo[playerid][CheckPointX][i];
                FamilyInfo[fam][fRoudLoad3Y][quan] = PlayerInfo[playerid][CheckPointY][i];
                FamilyInfo[fam][fRoudLoad3Z][quan] = PlayerInfo[playerid][CheckPointZ][i];
                if(quan == 0)
                {
                    format(strocaX,sizeof(strocaX),"%.2f",PlayerInfo[playerid][CheckPointX][i]);
                    format(strocaY,sizeof(strocaY),"%.2f",PlayerInfo[playerid][CheckPointY][i]);
                    format(strocaZ,sizeof(strocaZ),"%.2f",PlayerInfo[playerid][CheckPointZ][i]);
                }
                else
                {
                    format(strocaX,sizeof(strocaX),"%s_%.2f",strocaX,PlayerInfo[playerid][CheckPointX][i]);
                    format(strocaY,sizeof(strocaY),"%s_%.2f",strocaY,PlayerInfo[playerid][CheckPointY][i]);
                    format(strocaZ,sizeof(strocaZ),"%s_%.2f",strocaZ,PlayerInfo[playerid][CheckPointZ][i]);
                }
                quan++;
                PlayerInfo[playerid][CheckPointX][i] = 0.0, PlayerInfo[playerid][CheckPointY][i] = 0.0,PlayerInfo[playerid][CheckPointZ][i] = 0.0,PlayerInfo[playerid][pCheckPointCount][i] = 0;
            }
            format(string_mysql, sizeof(string_mysql), "UPDATE `pp_family` SET `Rout3X`='%s',`Rout3Y`='%s',`Rout3Z`='%s',\
            `routNameCreator3`='%s',`routNameEditor3`='%s',`routIdCreator3`='%d',`routIdEditor3`='%d',`routUnix3`='%d' WHERE `id`='%d'",
            strocaX,strocaY,strocaZ,FamilyRoutNameEditor[fam][slot],FamilyRoutNameCreator[fam][slot],FamilyInfo[fam][fRoutIdCreator][slot],
            FamilyInfo[fam][fRoutIdEditor][slot],FamilyInfo[fam][fRoutUnix][slot], fam);
            query_empty(pearsq, string_mysql);
        }
        else if(slot == 3)
        {
            for(new i = 0; i < 60; i++) 
            {
                FamilyInfo[fam][fRoudLoad4X][i] = 0;
                FamilyInfo[fam][fRoudLoad4Y][i] = 0; 
                FamilyInfo[fam][fRoudLoad4Z][i] = 0; 

                if(PlayerInfo[playerid][CheckPointX][i] == 0.0 && PlayerInfo[playerid][CheckPointY][i] == 0.0) 
                {
                    continue;
                }
                FamilyInfo[fam][fRoudLoad4X][quan] = PlayerInfo[playerid][CheckPointX][i];
                FamilyInfo[fam][fRoudLoad4Y][quan] = PlayerInfo[playerid][CheckPointY][i];
                FamilyInfo[fam][fRoudLoad4Z][quan] = PlayerInfo[playerid][CheckPointZ][i];
                if(quan == 0)
                {
                    format(strocaX,sizeof(strocaX),"%.2f",PlayerInfo[playerid][CheckPointX][i]);
                    format(strocaY,sizeof(strocaY),"%.2f",PlayerInfo[playerid][CheckPointY][i]);
                    format(strocaZ,sizeof(strocaZ),"%.2f",PlayerInfo[playerid][CheckPointZ][i]);
                }
                else
                {
                    format(strocaX,sizeof(strocaX),"%s_%.2f",strocaX,PlayerInfo[playerid][CheckPointX][i]);
                    format(strocaY,sizeof(strocaY),"%s_%.2f",strocaY,PlayerInfo[playerid][CheckPointY][i]);
                    format(strocaZ,sizeof(strocaZ),"%s_%.2f",strocaZ,PlayerInfo[playerid][CheckPointZ][i]);
                }
                quan++;
                PlayerInfo[playerid][CheckPointX][i] = 0.0, PlayerInfo[playerid][CheckPointY][i] = 0.0,PlayerInfo[playerid][CheckPointZ][i] = 0.0,PlayerInfo[playerid][pCheckPointCount][i] = 0;
            }
            format(string_mysql, sizeof(string_mysql), "UPDATE `pp_family` SET `Rout4X`='%s',`Rout4Y`='%s',`Rout4Z`='%s',\
            `routNameCreator4`='%s',`routNameEditor4`='%s',`routIdCreator4`='%d',`routIdEditor4`='%d',`routUnix4`='%d' WHERE `id`='%d'",
            strocaX,strocaY,strocaZ,FamilyRoutNameEditor[fam][slot],FamilyRoutNameCreator[fam][slot],FamilyInfo[fam][fRoutIdCreator][slot],
            FamilyInfo[fam][fRoutIdEditor][slot],FamilyInfo[fam][fRoutUnix][slot], fam);
            query_empty(pearsq, string_mysql);
        }
        else if(slot == 4)
        {
            for(new i = 0; i < 60; i++) 
            {
                FamilyInfo[fam][fRoudLoad5X][i] = 0;
                FamilyInfo[fam][fRoudLoad5Y][i] = 0; 
                FamilyInfo[fam][fRoudLoad5Z][i] = 0; 

                if(PlayerInfo[playerid][CheckPointX][i] == 0.0 && PlayerInfo[playerid][CheckPointY][i] == 0.0) 
                {
                    continue;
                }
                FamilyInfo[fam][fRoudLoad5X][quan] = PlayerInfo[playerid][CheckPointX][i];
                FamilyInfo[fam][fRoudLoad5Y][quan] = PlayerInfo[playerid][CheckPointY][i];
                FamilyInfo[fam][fRoudLoad5Z][quan] = PlayerInfo[playerid][CheckPointZ][i];
                if(quan == 0)
                {
                    format(strocaX,sizeof(strocaX),"%.2f",PlayerInfo[playerid][CheckPointX][i]);
                    format(strocaY,sizeof(strocaY),"%.2f",PlayerInfo[playerid][CheckPointY][i]);
                    format(strocaZ,sizeof(strocaZ),"%.2f",PlayerInfo[playerid][CheckPointZ][i]);
                }
                else
                {
                    format(strocaX,sizeof(strocaX),"%s_%.2f",strocaX,PlayerInfo[playerid][CheckPointX][i]);
                    format(strocaY,sizeof(strocaY),"%s_%.2f",strocaY,PlayerInfo[playerid][CheckPointY][i]);
                    format(strocaZ,sizeof(strocaZ),"%s_%.2f",strocaZ,PlayerInfo[playerid][CheckPointZ][i]);
                }
                PlayerInfo[playerid][CheckPointX][i] = 0.0, PlayerInfo[playerid][CheckPointY][i] = 0.0,PlayerInfo[playerid][CheckPointZ][i] = 0.0,PlayerInfo[playerid][pCheckPointCount][i] = 0;
                quan++;
            }
            format(string_mysql, sizeof(string_mysql), "UPDATE `pp_family` SET `Rout5X`='%s',`Rout5Y`='%s',`Rout5Z`='%s',\
            `routNameCreator5`='%s',`routNameEditor5`='%s',`routIdCreator5`='%d',`routIdEditor5`='%d',`routUnix5`='%d' WHERE `id`='%d'",
            strocaX,strocaY,strocaZ,FamilyRoutNameEditor[fam][slot],FamilyRoutNameCreator[fam][slot],FamilyInfo[fam][fRoutIdCreator][slot],
            FamilyInfo[fam][fRoutIdEditor][slot],FamilyInfo[fam][fRoutUnix][slot], fam);
            query_empty(pearsq, string_mysql);
        }
        SuccessMessage(playerid,"{99ff66}Маршрут успешно загружен");
    }
    else
    {
        FamilyInfo[fam][fRoutIdCreator][slot] = 0;
        FamilyInfo[fam][fRoutIdEditor][slot] = 0;
        format(FamilyRoutNameEditor[fam][slot],24,"0");
        format(FamilyRoutNameCreator[fam][slot],24,"0");
        FamilyInfo[fam][fRoutUnix][slot] = 0;
        if(slot == 0)
        {
            for(new i = 0; i < 60; i++) 
            {
                FamilyInfo[fam][fRoudLoad1X][i] = 0.0;
                FamilyInfo[fam][fRoudLoad1Y][i] = 0.0;
                FamilyInfo[fam][fRoudLoad1Z][i] = 0.0;
                format(strocaX,sizeof(strocaX),"%.2f",strocaX,0.0);
                format(strocaY,sizeof(strocaY),"%.2f",strocaY,0.0);
                format(strocaZ,sizeof(strocaZ),"%.2f",strocaZ,0.0);

            }
            format(string_mysql, sizeof(string_mysql), "UPDATE `pp_family` SET `Rout1X`='%s',`Rout1Y`='%s',`Rout1Z`='%s',\
            `routNameCreator1`='%s',`routNameEditor1`='%s',`routIdCreator1`='%d',`routIdEditor1`='%d',`routUnix1`='%d' WHERE `id`='%d'",
            strocaX,strocaY,strocaZ,FamilyRoutNameCreator[fam][slot],FamilyRoutNameEditor[fam][slot],FamilyInfo[fam][fRoutIdCreator][slot],
            FamilyInfo[fam][fRoutIdEditor][slot],FamilyInfo[fam][fRoutUnix][slot], fam); // 199 + 480 + 480 + 480 + 24 + 24 + 44
            query_empty(pearsq, string_mysql);
        }
        else if(slot == 1)
        {
            for(new i = 0; i < 60; i++) 
            {
                FamilyInfo[fam][fRoudLoad2X][i] = 0.0;
                FamilyInfo[fam][fRoudLoad2Y][i] = 0.0;
                FamilyInfo[fam][fRoudLoad2Z][i] = 0.0;
                format(strocaX,sizeof(strocaX),"%.2f",strocaX,0.0);
                format(strocaY,sizeof(strocaY),"%.2f",strocaY,0.0);
                format(strocaZ,sizeof(strocaZ),"%.2f",strocaZ,0.0);

            }
            format(string_mysql, sizeof(string_mysql), "UPDATE `pp_family` SET `Rout2X`='%s',`Rout2Y`='%s',`Rout2Z`='%s',\
            `routNameCreator2`='%s',`routNameEditor2`='%s',`routIdCreator2`='%d',`routIdEditor2`='%d',`routUnix2`='%d' WHERE `id`='%d'",
            strocaX,strocaY,strocaZ,FamilyRoutNameEditor[fam][slot],FamilyRoutNameCreator[fam][slot],FamilyInfo[fam][fRoutIdCreator][slot],
            FamilyInfo[fam][fRoutIdEditor][slot],FamilyInfo[fam][fRoutUnix][slot], fam);
            query_empty(pearsq, string_mysql);
        }
        else if(slot == 2)
        {
            for(new i = 0; i < 60; i++) 
            {
                FamilyInfo[fam][fRoudLoad3X][i] = 0.0;
                FamilyInfo[fam][fRoudLoad3Y][i] = 0.0;
                FamilyInfo[fam][fRoudLoad3Z][i] = 0.0;
                format(strocaX,sizeof(strocaX),"%.2f",strocaX,0.0);
                format(strocaY,sizeof(strocaY),"%.2f",strocaY,0.0);
                format(strocaZ,sizeof(strocaZ),"%.2f",strocaZ,0.0);

            }
            format(string_mysql, sizeof(string_mysql), "UPDATE `pp_family` SET `Rout3X`='%s',`Rout3Y`='%s',`Rout3Z`='%s',\
            `routNameCreator3`='%s',`routNameEditor3`='%s',`routIdCreator3`='%d',`routIdEditor3`='%d',`routUnix3`='%d' WHERE `id`='%d'",
            strocaX,strocaY,strocaZ,FamilyRoutNameEditor[fam][slot],FamilyRoutNameCreator[fam][slot],FamilyInfo[fam][fRoutIdCreator][slot],
            FamilyInfo[fam][fRoutIdEditor][slot],FamilyInfo[fam][fRoutUnix][slot], fam);
            query_empty(pearsq, string_mysql);
        }
        else if(slot == 3)
        {
            for(new i = 0; i < 60; i++) 
            {
                FamilyInfo[fam][fRoudLoad4X][i] = 0.0;
                FamilyInfo[fam][fRoudLoad4Y][i] = 0.0;
                FamilyInfo[fam][fRoudLoad4Z][i] = 0.0;
                format(strocaX,sizeof(strocaX),"%.2f",strocaX,0.0);
                format(strocaY,sizeof(strocaY),"%.2f",strocaY,0.0);
                format(strocaZ,sizeof(strocaZ),"%.2f",strocaZ,0.0);

            }
            format(string_mysql, sizeof(string_mysql), "UPDATE `pp_family` SET `Rout4X`='%s',`Rout4Y`='%s',`Rout4Z`='%s',\
            `routNameCreator4`='%s',`routNameEditor4`='%s',`routIdCreator4`='%d',`routIdEditor4`='%d',`routUnix4`='%d' WHERE `id`='%d'",
            strocaX,strocaY,strocaZ,FamilyRoutNameEditor[fam][slot],FamilyRoutNameCreator[fam][slot],FamilyInfo[fam][fRoutIdCreator][slot],
            FamilyInfo[fam][fRoutIdEditor][slot],FamilyInfo[fam][fRoutUnix][slot], fam);
            query_empty(pearsq, string_mysql);
        }
        else if(slot == 4)
        {
            for(new i = 0; i < 60; i++) 
            {
                FamilyInfo[fam][fRoudLoad5X][i] = 0.0;
                FamilyInfo[fam][fRoudLoad5Y][i] = 0.0;
                FamilyInfo[fam][fRoudLoad5Z][i] = 0.0;
                format(strocaX,sizeof(strocaX),"%.2f",strocaX,0.0);
                format(strocaY,sizeof(strocaY),"%.2f",strocaY,0.0);
                format(strocaZ,sizeof(strocaZ),"%.2f",strocaZ,0.0);

            }
            format(string_mysql, sizeof(string_mysql), "UPDATE `pp_family` SET `Rout5X`='%s',`Rout5Y`='%s',`Rout5Z`='%s',\
            `routNameCreator5`='%s',`routNameEditor5`='%s',`routIdCreator5`='%d',`routIdEditor5`='%d',`routUnix5`='%d' WHERE `id`='%d'",
            strocaX,strocaY,strocaZ,FamilyRoutNameEditor[fam][slot],FamilyRoutNameCreator[fam][slot],FamilyInfo[fam][fRoutIdCreator][slot],
            FamilyInfo[fam][fRoutIdEditor][slot],FamilyInfo[fam][fRoutUnix][slot], fam);
            query_empty(pearsq, string_mysql);
        }
    }
    return 1;
}


stock ShowAllRoutRace(playerid,type)
{
    new fam = PlayerInfo[playerid][pFamily];
    if(fam < 0) return 0;
	new line[90],lines[540];
	new tyear, tmonth, tday, thour, tminute, tsecond, quan;
	format(line,sizeof(line),"№ Автор\tВремя редактирования/создания"), strcat(lines,line);
	for(new i = 0; i < 5; i++) 
	{
		List[i][playerid] = 0;
		stamp2datetime(FamilyInfo[fam][fRoutUnix][i], tyear, tmonth, tday, thour, tminute, tsecond, 3);
		if(FamilyInfo[fam][fRoutUnix][i] != 0)
		{
            format(line,sizeof(line),"\n%d.%s\t[ %02d.%02d.%d %02d:%02d ]", i+1,FamilyRoutNameCreator[fam][i],tday, tmonth, tyear, thour, tminute), strcat(lines,line);
		}
		else
		{
			format(line,sizeof(line),"\n%d.Пусто\t ", i+1), strcat(lines,line);
        }
        List[quan][playerid] = i;
		quan++;
	}
    if(type == 0) ShowDialog(playerid,1468,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список маршрутов Стритрейсеров",lines,"Выбрать","Выход");
    else if(type == 1) ShowDialog(playerid,1469,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список маршрутов Стритрейсеров",lines,"Выбрать","Выход");
    else if(type == 2) ShowDialog(playerid,1462,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список маршрутов Стритрейсеров",lines,"Выбрать","Выход");
	return 1;
}

stock SettingRoutRace(playerid, number, author)
{
    new fam = PlayerInfo[playerid][pFamily];
	DP[0][playerid] = number;
	if(author == 0)
	{
		new tyear, tmonth, tday, thour, tminute, tsecond;
		new line[90],lines[270];
		stamp2datetime(FamilyInfo[fam][fRoutUnix][number], tyear, tmonth, tday, thour, tminute, tsecond, 3);
		format(line,sizeof(line),"\n%s Создан/отредактирован: [ %02d.%02d.%d %02d:%02d ]\n", FamilyRoutNameCreator[fam][number],tday, tmonth, tyear, thour, tminute), strcat(lines,line);

		format(line,sizeof(line),"\n\n{555555}Редактировал"), strcat(lines,line);
		format(line,sizeof(line),"\n{555555}%s\n", FamilyRoutNameEditor[fam][number]), strcat(lines,line);
		ShowDialog(playerid,1470,DIALOG_STYLE_MSGBOX,"{ff9000}Маршрут",lines,"Загрузить","Назад");
	}
	else if(author == 1)
	{
		new tyear, tmonth, tday, thour, tminute, tsecond;
		new line[90],lines[360];
		stamp2datetime(FamilyInfo[fam][fRoutUnix][number], tyear, tmonth, tday, thour, tminute, tsecond, 3);
		format(line,sizeof(line),"Маршрут от: %s Создан: [ %02d.%02d.%d %02d:%02d ]", FamilyRoutNameCreator[fam][number],tday, tmonth, tyear, thour, tminute), strcat(lines,line);
		format(line,sizeof(line),"\nЗагрузить маршрут себе в чекпоинты"), strcat(lines,line);
		format(line,sizeof(line),"\nОбновить маршрут [Загрузит ваши текущие координаты в него]"), strcat(lines,line);
		format(line,sizeof(line),"\nУдалить маршрут из базы"), strcat(lines,line);
		ShowDialog(playerid,1471,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Маршрут",lines,"Загрузить","Назад");
	}
	return 1;
}

#define MAX_PLACE_RACE 8 // участники в гонке
#define MAX_DRAW_RACE 4 // текстдравы гонок
new PlayerText:PlayerRaceDraw[MAX_DRAW_RACE][MAX_REALPLAYERS]; // Текстдравы Гонки
new bool:DrawRace[MAX_REALPLAYERS];

stock UpdatePointRace(raceid, playerid)
{
    new string[3000];
    FindPlaceRacePlayer(playerid, StreetRacers[0][racersCount], string);
    if(isnull(string))
    {
        UpdatePointRaceForPlayer(0,playerid);
        return 1;
    }
    else UpdateRaceDrawForAllPlayers(raceid, string); // Обновляем строку всем участникам
    return 1;
}
stock UpdatePointRaceStart(raceid)
{
    new line[30], lines[3000];
    for (new i = 0; i < MAX_PLACE_RACE; i++)
    {
        if(StreetRacers[0][racersCount][i] != -1) format(line,sizeof(line),"%d._%s~n~", i + 1, PlayerInfo[StreetRacers[0][racersCount][i]][pName]), strcat(lines,line);
    }
    UpdateRaceDrawForAllPlayers(raceid, lines); // Обновляем строку всем участникам
    return 1;
}
stock FindPlaceRacePlayer(playerid, racers[], text[])
{
    new line[30], lines[3000];

    new playerCheckpoint = carRaceCheckpoint[playerid];
    for (new i = 0; i < MAX_PLACE_RACE; i++)
    {
        // Находим игрока, взявшего чекпоинт в racers[]
        if (racers[i] == playerid) 
        {
            // Начиная с текущей позиции игрока идем назад по массиву,
            // чтобы найти, нужно ли его переместить выше по списку
            for (new j = i; j > 0; j--)
            {
                if(j-1 < 0) continue;
                if(racers[j-1] == -1) continue;
                if (carRaceCheckpoint[racers[j-1]] < playerCheckpoint)
                {
                    // Меняем местами, если игрок впереди имеет меньшее значение чекпоинта
                    new temp = racers[j];
                    racers[j] = racers[j-1];
                    racers[j-1] = temp;

                }
                else
                {
                    // Если мы нашли игрока с большим или равным числом чекпоинтов, останавливаемся
                    break;
                }
            }
            break;
        }
    }
    for (new i = 0; i < MAX_PLACE_RACE; i++)
    {
        if(racers[i] != -1) format(line,sizeof(line),"%d._%s~n~", i + 1, PlayerInfo[racers[i]][pName]), strcat(lines,line);
    }
    // Передаём сформированные строки в text
    format(text, 3000, "%s", lines);
    return 1;
}


stock UpdateRaceDrawForAllPlayers(raceid, const string[])
{
    for(new p; p < MAX_PLACE_RACE; p++)
    {
        if(StreetRacers[raceid][racersCount][p] == -1) continue;
        new giveplayerid = StreetRacers[raceid][racersCount][p];
        if(IsOnline(giveplayerid))
        {
            UpdateRaceDrawForPlayer(giveplayerid, string);
        }
    }
    return 1;
}

/*stock FindPlaceRacePlayer(giveplayerid, text[])
{
    new playerid[MAX_PLACE_RACE] = {-1, ...};

    new line[30], lines[3000];
    new i, j, temp;
    for (i = 0; i < MAX_PLACE_RACE - 1; i++) 
    {
        for (j = 0; j < MAX_PLACE_RACE - i - 1; j++) 
        {
            new giveplayerid = StreetRacers[0][racersCount][j];
            if(giveplayerid == -1) continue;

            if (carRaceCheckpoint[playerid[j]] < carRaceCheckpoint[playerid[j + 1]]) {
                temp = playerid[j];
                playerid[j] = playerid[j + 1];
                playerid[j + 1] = temp;
            } else if (carRaceCheckpoint[playerid[j]] == carRaceCheckpoint[playerid[j + 1]] &&
                       playerid[j] > playerid[j + 1]) {
                temp = playerid[j];
                playerid[j] = playerid[j + 1];
                playerid[j + 1] = temp;
            }

            format(line,sizeof(line),"%d._%s~n~", j + 1, PlayerInfo[playerid[j]][pName]), strcat(lines,line);
        }
    }

    // Передаём сформированные строки в text
    format(text, 3000, "%s", lines);
    return 1;
}*/

stock UpdateRaceDrawForPlayer(playerid, const text[])
{
    if(DrawRace[playerid] == false) // Если текстдравов не было, создаём
    {
        CreateRaceDrawForPlayer(playerid);
        ShowRaceDrawForPlayer(playerid);
    }

	PlayerTextDrawSetString(playerid, PlayerRaceDraw[0][playerid], text);
    PlayerTextDrawShow(playerid, PlayerRaceDraw[0][playerid]); 

    UpdatePointRaceForPlayer(0, playerid);
    return 1;
}

stock ShowRaceDrawForPlayer(playerid)
{
    PlayerTextDrawShow(playerid, PlayerRaceDraw[1][playerid]); // Иконка гонки
    PlayerTextDrawShow(playerid, PlayerRaceDraw[2][playerid]); // Заголовок
    PlayerTextDrawShow(playerid, PlayerRaceDraw[3][playerid]); // Количество собранных чекпоинтов
    return 1;
}

stock UpdatePointRaceForPlayer(gameid, playerid)
{
    new string[20];
    format(string,sizeof(string),"%d/%d", carRaceCheckpoint[playerid], StreetRacers[gameid][racePoints]);
    PlayerTextDrawSetString(playerid, PlayerRaceDraw[3][playerid], string);
    PlayerTextDrawShow(playerid, PlayerRaceDraw[3][playerid]);
    return 1;
}

stock CreateRaceDrawForPlayer(playerid)
{
    if(DrawRace[playerid] == true) return 1;

    PlayerRaceDraw[0][playerid] = CreatePlayerTextDraw(playerid, 18.333337, 215.703750, "1._Wwwwwwwwwww_Wwwwwwwwwww~n~2._Wwwwwwwwwww_Wwwwwwwwwww");
    PlayerTextDrawLetterSize(playerid, PlayerRaceDraw[0][playerid], 0.182666, 1.027556);
    PlayerTextDrawAlignment(playerid, PlayerRaceDraw[0][playerid], 1);
    PlayerTextDrawColor(playerid, PlayerRaceDraw[0][playerid], COLOR_TEXTDRAW_GREY);
    PlayerTextDrawUseBox(playerid, PlayerRaceDraw[0][playerid], true);
    PlayerTextDrawBoxColor(playerid, PlayerRaceDraw[0][playerid], 1);
    PlayerTextDrawSetShadow(playerid, PlayerRaceDraw[0][playerid], 0);
    PlayerTextDrawSetOutline(playerid, PlayerRaceDraw[0][playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerRaceDraw[0][playerid], COLOR_TEXTDRAW_STROKE_GREY);
    PlayerTextDrawFont(playerid, PlayerRaceDraw[0][playerid], 1);
    PlayerTextDrawSetProportional(playerid, PlayerRaceDraw[0][playerid], 1);

    PlayerRaceDraw[1][playerid] = CreatePlayerTextDraw(playerid, 17.333335, 198.281509, "hud:radar_flag");
    PlayerTextDrawLetterSize(playerid, PlayerRaceDraw[1][playerid], 0.005000, 0.066370);
    PlayerTextDrawTextSize(playerid, PlayerRaceDraw[1][playerid], 9.333318, 11.614809);
    PlayerTextDrawAlignment(playerid, PlayerRaceDraw[1][playerid], 1);
    PlayerTextDrawColor(playerid, PlayerRaceDraw[1][playerid], -1);
    PlayerTextDrawSetShadow(playerid, PlayerRaceDraw[1][playerid], 0);
    PlayerTextDrawSetOutline(playerid, PlayerRaceDraw[1][playerid], 0);
    PlayerTextDrawFont(playerid, PlayerRaceDraw[1][playerid], 4);

    PlayerRaceDraw[2][playerid] = CreatePlayerTextDraw(playerid, 33.666656, 199.111114, "PEARS_RACE");
    PlayerTextDrawLetterSize(playerid, PlayerRaceDraw[2][playerid], 0.321666, 1.193483);
    PlayerTextDrawAlignment(playerid, PlayerRaceDraw[2][playerid], 1);
    PlayerTextDrawColor(playerid, PlayerRaceDraw[2][playerid], -5963521);
    PlayerTextDrawSetShadow(playerid, PlayerRaceDraw[2][playerid], 0);
    PlayerTextDrawSetOutline(playerid, PlayerRaceDraw[2][playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerRaceDraw[2][playerid], COLOR_TEXTDRAW_STROKE_GREY);
    PlayerTextDrawFont(playerid, PlayerRaceDraw[2][playerid], 3);
    PlayerTextDrawSetProportional(playerid, PlayerRaceDraw[2][playerid], 1);

    PlayerRaceDraw[3][playerid] = CreatePlayerTextDraw(playerid, 110.333328, 199.281494, "10/60");
    PlayerTextDrawLetterSize(playerid, PlayerRaceDraw[3][playerid], 0.321666, 1.193483);
    PlayerTextDrawAlignment(playerid, PlayerRaceDraw[3][playerid], 1);
    PlayerTextDrawColor(playerid, PlayerRaceDraw[3][playerid], -1523963137);
    PlayerTextDrawSetShadow(playerid, PlayerRaceDraw[3][playerid], 0);
    PlayerTextDrawSetOutline(playerid, PlayerRaceDraw[3][playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerRaceDraw[3][playerid], COLOR_TEXTDRAW_STROKE_GREY);
    PlayerTextDrawFont(playerid, PlayerRaceDraw[3][playerid], 3);
    PlayerTextDrawSetProportional(playerid, PlayerRaceDraw[3][playerid], 1);

    DrawRace[playerid] = true;
    return 1;
}

stock DestroyRaceDrawForPlayer(playerid)
{
    if(DrawRace[playerid] == false) return 1;

    for(new i = 0; i < MAX_DRAW_RACE; i++)
    {
        PlayerTextDrawHide(playerid, PlayerRaceDraw[i][playerid]);
        PlayerTextDrawDestroy(playerid, PlayerRaceDraw[i][playerid]);
    }

    DrawRace[playerid] = false;
    return 1;
}

CMD:startrace(playerid)
{
    for(new i =0; i < MAX_PLACE_RACE; i++)
    {
        StreetRacers[0][racersCount][i] = -1;
    }
    StreetRacers[0][raceMap] = 0;
    StreetRacers[0][racersCount][0] = playerid;
    StreetRacers[0][raceFamily] = 5;
    StartRace(playerid);
    UpdatePointRaceStart(0);
    return 1;
}
#define MAX_MAKE 100 // Максимальное количество вызовов

enum mkInfo
{
    mkPlayerId, // playerid Создателя заявки
    mkWho, // Куда заявка. 0 нет вызова
    mkStatus, // проверка статуса
    mkWhoTake, // Кто принял фракция
    mkWhoTakePlayer, // Кто принял вызов playerid
    mkWhoParam, // Ид того что угнали/ограбили
    mkWhoType, // Тип машина/дом
    Float:mkCord[3], // Корды
}
new MakeInfo[MAX_MAKE][mkInfo];

new serviceName[][] =
{
    "{cccccc}нет", "{0066ff}Полиция", "{ff6666}Скорая Помощь", "{ff6666}Пожарные 911", "{ffcc00}Такси"
};
new servicePlayerName[][] =
{
    "{cccccc}нет", "{0066ff}Полицейский", "{ff6666}Доктор", "{ff6666}Пожарный", "{ffcc00}Таксист"
};

stock SettingServiceMake(playerid)
{
    new s = OnlineInfo[playerid][oServiceMake][0]; // servie id
    new mk = OnlineInfo[playerid][oServiceMake][2]; // make id

    new line[90],lines[180];
    if(MakeInfo[mk][mkStatus] == 1)
    {
        format(line,sizeof(line),"{cccccc}Активный Вызов: %s {cccccc}| Ожидание до %s \t", serviceName[s], fine_time(OnlineInfo[playerid][oServiceMake][1])), strcat(lines,line);
        format(line,sizeof(line),"\n{FF6347}Отменить вызов \t"), strcat(lines,line);
    }
    else
    {
        new callid = MakeInfo[mk][mkPlayerId];
        format(line,sizeof(line),"{cccccc}Активный Вызов: %s {cccccc}| {99ff66}Вызов Принят \t", serviceName[s]), strcat(lines,line);
        if(IsOnline(callid)) format(line,sizeof(line),"\n%s: \t{cccccc}%s", servicePlayerName[s], PlayerInfo[callid][pName]), strcat(lines,line);
        else format(line,sizeof(line),"\n%s: \t{cccccc}неизвестно", servicePlayerName[s]), strcat(lines,line);
    }
    ShowDialog(playerid,790,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Вызов служб",lines,"Выбрать","Отмена");
    return 1;
}
stock AutoMakeCreate(whom,type,id)
{
    new findslot = -1;
    for(new z = 0; z < MAX_MAKE; z++) 
    {
        if(MakeInfo[z][mkWho] == 0 || MakeInfo[z][mkWhoParam] == id)
        {
            findslot = z;
            break;
        }
    }
    if(findslot == -1) return 0;
    MakeInfo[findslot][mkPlayerId] = -1;
    MakeInfo[findslot][mkWho] = whom;
    MakeInfo[findslot][mkStatus] = 1;
    MakeInfo[findslot][mkWhoType] = type+1;

    if(type == 0) GetVehiclePos(id, MakeInfo[findslot][mkCord][0], MakeInfo[findslot][mkCord][1], MakeInfo[findslot][mkCord][2]);
    if(type == 1) MakeInfo[findslot][mkCord][0] = DomInfo[id][dKoordinatX],MakeInfo[findslot][mkCord][1]=DomInfo[id][dKoordinatY], MakeInfo[findslot][mkCord][2]=DomInfo[id][dKoordinatZ];
    if(type == 2) GetPlayerRealPos(id, MakeInfo[findslot][mkCord][0], MakeInfo[findslot][mkCord][1], MakeInfo[findslot][mkCord][2]),MakeInfo[findslot][mkPlayerId] = id;
    MessageMake(findslot);
    return 1;
}

stock MessageMake(number)
{
    new string[160];
    new findraiontolist = FindRaionPos(MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2]);
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 0) continue;
        if(MakeInfo[number][mkWho] == 1)
        {
            if(PlayerInfo[i][patroolID] == -1) continue;
            if(IsPlayerInRangeOfPoint(i,1000.0,MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2]))
            {
                if(MakeInfo[number][mkWhoType] == 2) format(string,sizeof(string), " SMS от Дистпетчера: {99ff33}Сработала сигнализация в доме в районе %s. Номер вызова: %d",gSAZones[findraiontolist][zName],number+1);
                else if(MakeInfo[number][mkWhoType] == 1) format(string,sizeof(string), " SMS от Дистпетчера: {99ff33}Сработала сигнализация в машине в районе %s. Номер вызова: %d",gSAZones[findraiontolist][zName],number+1);
                else format(string,sizeof(string), " SMS от Дистпетчера: {99ff33}Только что поступил вызов от %s в районе %s. Номер вызова: %d",rpplayername(MakeInfo[number][mkPlayerId]),gSAZones[findraiontolist][zName],number+1);
                SendClientMessage(i,COLOR_YELLOW,string);
            }
        }
        else if(MakeInfo[number][mkWho] == 2 && fraction(i) == 4)
        {
            if(IsPlayerInRangeOfPoint(i,1000.0,MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2]))
            {
                if(MakeInfo[number][mkWhoType] == 3) format(string,sizeof(string), " SMS от Дистпетчера: {99ff33}Человек в тяжелом состояние в районе: %s. Номер вызова: %d",gSAZones[findraiontolist][zName],number+1);
                SendClientMessage(i,COLOR_YELLOW,string);
            }
        }
    }
}
stock MakeCreate(playerid, whom)
{
    if(howstun(playerid)) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");

    new findslot = -1;
    for(new z = 0; z < MAX_MAKE; z++) 
    {
        if(MakeInfo[z][mkWho] == 0)
        {
            findslot = z;
            break;
        }
    }
    if(findslot == -1) return ErrorMessage(playerid,"{FF6347}В данный момент 50 активных вызовов\n\n{cccccc}Сообщите об этом администрации в [ /report ]");

    if(whom == 1)
    {
        if(PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pLeader] == 1 
            || PlayerInfo[playerid][pMember] == 11 || PlayerInfo[playerid][pLeader] == 11 
            || PlayerInfo[playerid][pMember] == 21 || PlayerInfo[playerid][pLeader] == 21) return ErrorMessage(playerid, "{FF6347}Вы сотрудник правоохранительных органов и не можете вызвать полицию");
        SetPlayerChatBubble(playerid,"вызывает полицию",COLOR_PURPLE,20.0,9000);
        SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Вызов: {0066ff}[ Полиция ]");
        SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Статус: {ccffff}Ожидание");
        SuccessMessage(playerid, "{99ff66}Вызов принят\n\n{cccccc}Пожалуйста, не покидайте радиус вызова (200 метров), до тех пор пока не приедет {0066ff}полиция");
        // Вот как всем ПД кинуть, или найти самый ближайший патруль и только им?
    }
    else if(whom == 2)
    {
        if(PlayerInfo[playerid][pMember] == 4 || PlayerInfo[playerid][pLeader] == 4) return ErrorMessage(playerid, "{FF6347}Вы работник ASGH и не можете вызвать скорую помощь");
        SetPlayerChatBubble(playerid,"вызывает скорую помощь",COLOR_PURPLE,20.0,9000);
        SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Вызов: {ff6666}[ Скорая Помощь ]");
        SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Статус: {ccffff}Ожидание");
        SuccessMessage(playerid, "{99ff66}Вызов принят\n\n{cccccc}Пожалуйста, не покидайте радиус вызова (200 метров), до тех пор пока не приедет {ff6666}скорая помощь");
    }
    around_player_audio(playerid, 3600, 0, 5.0, 0);

    MakeInfo[findslot][mkPlayerId] = playerid;
    MakeInfo[findslot][mkWho] = whom;
    MakeInfo[findslot][mkStatus] = 1;

    GetPlayerRealPos(playerid, MakeInfo[findslot][mkCord][0], MakeInfo[findslot][mkCord][1], MakeInfo[findslot][mkCord][2]);

    OnlineInfo[playerid][oServiceMake][0] = whom; // servie id
    OnlineInfo[playerid][oServiceMake][1] = 300;
    OnlineInfo[playerid][oServiceMake][2] = findslot; // make id
    return 1;
}

stock CloseMake(playerid,number)
{
    OnlineInfo[playerid][oTakeMake] = -1;
    if(MakeInfo[number][mkPlayerId] == -1)
    {
        MakeInfo[number][mkWho] = -1;
        MakeInfo[number][mkStatus] = 0;
        MakeInfo[number][mkWhoParam] = -1;
        MakeInfo[number][mkWhoTakePlayer] = -1;
    }
    else AutoCloseMake(MakeInfo[number][mkPlayerId]);
    return 1;
}

stock AutoCloseMake(playerid)
{
    if(OnlineInfo[playerid][oServiceMake][0] == 0) return 1;

    new findslot = OnlineInfo[playerid][oServiceMake][2];
    OnlineInfo[playerid][oServiceMake][0] = 0;
    OnlineInfo[playerid][oServiceMake][1] = 0;
    OnlineInfo[playerid][oServiceMake][2] = 0;
    MakeInfo[findslot][mkPlayerId] = -1;
    MakeInfo[findslot][mkWho] = 0;
    MakeInfo[findslot][mkStatus] = 0;
    if(IsPlayerConnected(playerid))
    {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Время активности вашего вызова истекло.");
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Если проблема актуальна, наверное стоит сделать вызов по новой?");
        SuccessMessage(playerid, "Время активности вашего вызова истекло.\nЕсли проблема актуально, наверное стоит сделать вызов по новой?");
    }
    return 1;
}

stock TakeMake(playerid,number)
{
    MakeInfo[number][mkStatus] = 2;
    if(MakeInfo[number][mkWhoParam] == -1) OnlineInfo[MakeInfo[number][mkPlayerId]][oServiceMake][1] = 600,SendClientMessage(MakeInfo[number][mkPlayerId], COLOR_GREY, " {AFAFAF}Запрос Принят, ожидайте прибытия служб.");
    MakeInfo[number][mkWhoTakePlayer] = playerid;
    MakeInfo[number][mkWho] = fraction(playerid);
    OnlineInfo[playerid][oTakeMake] = number;
    SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Вы приняли вызов.");
    SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Получение координат GPS доступно через бортовой ПК. [/findmake ID вызова]");
}

stock FindMake(playerid,number)
{
    if(MakeInfo[number][mkStatus] == 2 && MakeInfo[number][mkWhoParam] == -1)
    {
        CreateGps(playerid,MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2], 0, 0, 50.0);
    }
    else if(MakeInfo[number][mkStatus] == 2 && MakeInfo[number][mkWhoParam] != -1)
    {
        if(MakeInfo[number][mkWhoType] == 1)
        {
            if(VehInfo[MakeInfo[number][mkWhoParam]][vAlarm] == 2 && VehInfo[MakeInfo[number][mkWhoParam]][vAlarmUnix]+604800 > gettime())
            {
                new Float:X,Float:Y,Float:Z;
                if(ZoneTimer[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вас активна зона поиска, дождитесь её окончания");
                GetVehiclePos(MakeInfo[number][mkWhoParam],X,Y,Z);
                new Float:rand_x = 5 + random(30), Float:rand_y = 5 + random(30);
                switch(random(4))
                {
                    case 0: X += rand_x, Y += rand_y;
                    case 1: X -= rand_x, Y -= rand_y;
                    case 2: X += rand_x, Y -= rand_y;
                    case 3: X -= rand_x, Y += rand_y;
                }
                new findraiontolist = FindRaionPos(X,Y,Z);
                ShowFindZone(playerid, -1, X, Y,findraiontolist);
            }
            else
            {
                if(ZoneTimer[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вас активна зона поиска, дождитесь её окончания");
                new findraiontolist = FindRaionPos(MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2]);
                ShowFindZone(playerid, -1, MakeInfo[number][mkCord][0], MakeInfo[number][mkCord][1],findraiontolist);
            }
        }
        else if(MakeInfo[number][mkWhoType] == 2)
        {
            if(ZoneTimer[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вас активна зона поиска, дождитесь её окончания");
            new findraiontolist = FindRaionPos(MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2]);
            ShowFindZone(playerid, -1, MakeInfo[number][mkCord][0], MakeInfo[number][mkCord][1],findraiontolist);
        }
    }
    else return ErrorMessage(playerid,"{FF6347}Ошибка! Данный вызов нельзя отследить. Он не принят или недоступен");
    return 1;
}

CMD:findmake(playerid,const params[])
{
    new number;
    if(sscanf(params, "d",number)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Отследить место вызова {ffcc00}[ /findmake ID вызова ]");
    number--;
    FindMake(playerid,number);
    return 1;
}

CMD:acceptmake(playerid,const params[])
{
    new number;
    if(sscanf(params, "d",number)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Принять вызов {ffcc00}[ /accaptmake ID ]");
    number--;
    if(MakeInfo[number][mkStatus] != 1) return ErrorMessage(playerid,"{FF6347}Данный вызов недоступен или его просто нет");
    new g = fraction(playerid);
    if(OnlineInfo[playerid][oTakeMake] != -1) return ErrorMessage(playerid,"{FF6347}У вас уже есть принятый вызов");
    if(MakeInfo[number][mkWho] == 1)
    {
        if(g != 1 && g != 11 && g != 21 && g != 1) return ErrorMessage(playerid,"{FF6347}Вы не работаете в LSPD/SFPD/LVPD");
        TakeMake(playerid,number);
    }
    else if(MakeInfo[number][mkWho] == 2)
    {
        if(g != 3) return ErrorMessage(playerid,"{FF6347}Вы не работаете в Мин.Здраве");
        TakeMake(playerid,number);
    }
    return 1;
}

CMD:closemake(playerid,const params[])
{
    new number;
    if(sscanf(params, "d",number)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Принять вызов {ffcc00}[ /accaptmake ID ]");
    number--;
    if(MakeInfo[number][mkStatus] != 2) return ErrorMessage(playerid,"{FF6347}Данный вызов не принят что бы его завершить.");
    if(MakeInfo[number][mkWhoParam] != -1 && MakeInfo[number][mkWhoType] == 1)
    {
        new Float:x,Float:y,Float:z;
        GetVehiclePos(MakeInfo[number][mkWhoParam],x,y,z);
        if(VehInfo[MakeInfo[number][mkWhoParam]][vAlarm] == 2 && VehInfo[MakeInfo[number][mkWhoParam]][vAlarmUnix]+604800 > gettime())
        {
            if(!IsPlayerInRangeOfPoint(playerid,50.0,x,y,z)) return ErrorMessage(playerid,"{ff6347}Вы не можете завершить вызов находясь далеко от места вызова");
        }
        else
        {
            if(!IsPlayerInRangeOfPoint(playerid,50.0,MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2])) return ErrorMessage(playerid,"{ff6347}Вы не можете завершить вызов находясь далеко от места вызова");
        }
        CloseMake(playerid,number);
    }
    if(sscanf(params, "d",number)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Для закрытия вызова нужно написать{ffcc00}[ /closemake ID вызова ]");
    if(MakeInfo[number][mkStatus] != 2) return ErrorMessage(playerid,"{ff6347}Вы не можете завершить вызов, который никто не принял");
    if(MakeInfo[number][mkWhoTakePlayer] != playerid && MakeInfo[number][mkWhoTakePlayer] != -1) return ErrorMessage(playerid,"{ff6347}Вы не можете завершить вызов, который принял другой человек");
    if(!IsPlayerInRangeOfPoint(playerid,50.0,MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2])) return ErrorMessage(playerid,"{ff6347}Вы не можете завершить вызов находясь далеко от места вызова");
    CloseMake(playerid,number);
    return 1;
}

stock CallService(playerid, whom)
{
	if(OnlineInfo[playerid][oServiceMake][0] > 0)
    {
        new s = OnlineInfo[playerid][oServiceMake][0];
        if(whom != OnlineInfo[playerid][oServiceMake][0])
        {
            new string[120];
            format(string,sizeof(string),"{FF6347}Вы уже вызвали %s\n\n{cccccc}К сожалению, вы не можете вызвать два сервиса одновременно", serviceName[s]);
            ErrorMessage(playerid, string);
            return 1;
        }
        SettingServiceMake(playerid);
        return 1;
    }
	if(whom == 4)
	{
		ShowDialog(playerid,800,DIALOG_STYLE_MSGBOX,"{ff9000}Вызовы","\n{ff9000}Вы уверены, что хотите вызвать такси?\n\n{cccccc}Обязательно дождитесь таксиста после того, как он примет заказ {ff9000};)\n","Да","Нет");
	}
	else if(whom == 1)
	{
		ShowDialog(playerid,598,DIALOG_STYLE_MSGBOX,"{ff9000}Сервис","\n{ff9000}Вы уверены, что хотите вызвать {0066ff}полицию ?\n\n{FF6347}Внимание! {cccccc}В случае ложного вызова вам придётся заплатить штраф\n","Да","Нет");
	}
	else if(whom == 2)
	{
		ShowDialog(playerid,791,DIALOG_STYLE_MSGBOX,"{ff9000}Сервис","\n{ff9000}Вы уверены, что хотите вызвать {ff6666}скорую помощь ?\n\n{FF6347}Внимание! {cccccc}В случае ложного вызова вам придётся заплатить штраф\n","Да","Нет");
	}
	return 1;
}



stock MakeList(playerid)
{
    new CopOrMin = 0; // 1 - kop, 2 - MZ
    if(IsACop(playerid)) CopOrMin = 1;
    else CopOrMin = 2;
    new line[100],lines[4048];
    format(line,sizeof(line),"№ Вызвавший\tСтатус\tРайон\tВремя\t"), strcat(lines,line);
    new quan, targetid,findraiontolist,timemake[20];
    for(new z = 0; z < MAX_MAKE; z++) 
    {
        if((MakeInfo[z][mkStatus] == 1 || MakeInfo[z][mkStatus] == 2) && CopOrMin == 1 && MakeInfo[z][mkWho] == 1)
        {
            if(MakeInfo[z][mkWhoType] > 0) timemake = "Срочный вызов";
            else timemake = fine_time(OnlineInfo[playerid][oServiceMake][MakeInfo[z][mkWho]]);
            targetid = MakeInfo[z][mkPlayerId];
            findraiontolist = FindRaionPos(MakeInfo[z][mkCord][0],MakeInfo[z][mkCord][1],MakeInfo[z][mkCord][2]);
            if(MakeInfo[z][mkStatus] == 1) format(line,sizeof(line),"\n%d. %s\tВ ожидание\t%s\t%s", quan+1, rpplayername(targetid),gSAZones[findraiontolist][zName],timemake), strcat(lines,line);
            else format(line,sizeof(line),"\n%d. %s\tПринят\t%s\t%s", quan+1, rpplayername(targetid),gSAZones[findraiontolist][zName],timemake), strcat(lines,line);
            quan++;
        }
        else if((MakeInfo[z][mkStatus] == 1 || MakeInfo[z][mkStatus] == 2) && CopOrMin == 2 && MakeInfo[z][mkWho] == 2)
        {
            targetid = MakeInfo[z][mkPlayerId];
            findraiontolist = FindRaionPos(MakeInfo[z][mkCord][0],MakeInfo[z][mkCord][1],MakeInfo[z][mkCord][2]);
            if(MakeInfo[z][mkStatus] == 1) format(line,sizeof(line),"\n%d. %s\tВ ожидание\t%s\t%s", quan+1, rpplayername(targetid),gSAZones[findraiontolist][zName],fine_time(OnlineInfo[playerid][oServiceMake][1])), strcat(lines,line);
            else format(line,sizeof(line),"\n%d. %s\tПринят\t%s\t%s", quan+1, rpplayername(targetid),gSAZones[findraiontolist][zName],fine_time(OnlineInfo[playerid][oServiceMake][1])), strcat(lines,line);
            quan++;
        }
        else if((MakeInfo[z][mkStatus] == 1 || MakeInfo[z][mkStatus] == 2) && CopOrMin == 0)
        {
            targetid = MakeInfo[z][mkPlayerId];
            findraiontolist = FindRaionPos(MakeInfo[z][mkCord][0],MakeInfo[z][mkCord][1],MakeInfo[z][mkCord][2]);
            if(MakeInfo[z][mkStatus] == 1) format(line,sizeof(line),"\n%d. %s\tВ ожидание\t%d\t%s\t%s", quan+1, rpplayername(targetid),gSAZones[findraiontolist][zName],fine_time(OnlineInfo[playerid][oServiceMake][1])), strcat(lines,line);
            else format(line,sizeof(line),"\n%d. %s\tПринят\t%d\t%s\t%s", quan+1, rpplayername(targetid),gSAZones[findraiontolist][zName],fine_time(OnlineInfo[playerid][oServiceMake][1])), strcat(lines,line);
            quan++;
        }
        List[z][playerid] = quan;
    }
    if(quan == 0) return ErrorMessage(playerid,"{FF6347}В данный момент нет вызовов");
    else ShowDialog(playerid,1478,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список вызовов",lines,"Выбрать","Выход");
    return 1;
}

stock dialogCase_MakeSystem(playerid, dialogid, response, listitem)
{
    if(dialogid == 1478)
    {
        if(response)
        {
            if(listitem < 0 || listitem > MAX_MAKE) return ErrorMessage(playerid,"{ff6347} Выбрана не правильная строка.");
            new listselect = List[listitem][playerid],findraiontolist;

            new string[100];
            if(MakeInfo[listselect][mkStatus] == 2)
            {
                format(string,sizeof(string),"Вызов принят: %s. Вызов принял:%s",frakeasyName[MakeInfo[listselect][mkWhoTake]],rpplayername(MakeInfo[listselect][mkWhoTakePlayer]));
                ShowDialog(playerid,11111,DIALOG_STYLE_MSGBOX,"Информация о вызове",string,"Закрыть","");
            }
            else if(MakeInfo[listselect][mkStatus] == 1 && OnlineInfo[playerid][oTakeMake] == -1)
            {
                findraiontolist = FindRaionPos(MakeInfo[listselect][mkCord][0], MakeInfo[listselect][mkCord][1], MakeInfo[listselect][mkCord][2]);
                format(string,sizeof(string),"Вызов от: %s. В районе: %s\n\nВы хотите принять вызов?",rpplayername(MakeInfo[listselect][mkPlayerId]),gSAZones[findraiontolist][zName]);
                ShowDialog(playerid,1479,DIALOG_STYLE_MSGBOX,"Информация о вызове",string,"Принять","Назад");
            }
            else 
            {
                findraiontolist = FindRaionPos(MakeInfo[listselect][mkCord][0], MakeInfo[listselect][mkCord][1], MakeInfo[listselect][mkCord][2]);
                format(string,sizeof(string),"Вызов от: %s. В районе: %s\n\nВы хотите принять вызов?",rpplayername(MakeInfo[listselect][mkPlayerId]),gSAZones[findraiontolist][zName]);
                ShowDialog(playerid,1479,DIALOG_STYLE_MSGBOX,"Информация о вызове",string,"Приянть","Назад");
            }
        }
    }
    if(dialogid == 1479)
    {
        if(response)
        {
            new listselect = List[listitem][playerid];
            TakeMake(playerid,listselect);
        }
        else return MakeList(playerid);
    }
    return 1;
}
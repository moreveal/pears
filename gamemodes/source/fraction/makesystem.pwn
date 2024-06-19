#define MAX_MAKE_AMOUNT 300 // Максимальное количество вызовов
#define MAKE_AUTOCLOSE_TIME 900 // Время через которое вызов будет завершен автоматически при любых обстоятельствах (в секундах)

enum e_MakeType {
    MAKE_TYPE_VEHICLE, // Взлом автомобиля
    MAKE_TYPE_HOUSE, // Взлом дома
    MAKE_TYPE_PLAYER // Вызов игрока
};

enum mkInfo
{
    mkPlayerId, // playerid Создателя заявки
    mkCreatedTime, // Когда была создана заявка
    mkWho, // Куда заявка. 0 нет вызова
    mkStatus, // проверка статуса
    mkWhoTake, // Кто принял фракция
    mkWhoTakePlayer, // Кто принял вызов playerid
    mkWhoParam, // Ид того что угнали/ограбили
    mkWhoType, // Тип машина/дом
    Float: mkCord[3], // Корды
}
new MakeInfo[MAX_MAKE_AMOUNT][mkInfo];

new serviceName[][] =
{
    "{cccccc}нет", "{0066ff}Полиция", "{ff6666}Скорая Помощь", "{ff6666}Пожарные 911", "{ffcc00}Такси"
};
new servicePlayerName[][] =
{
    "{cccccc}нет", "{0066ff}Полицейский", "{ff6666}Доктор", "{ff6666}Пожарный", "{ffcc00}Таксист"
};

stock FindFreeMakeSlot() {
    for (new i = 0; i < MAX_MAKE_AMOUNT; i++)
        if (MakeInfo[i][mkWho] <= 0) return i;
    return -1;
}

stock SettingServiceMake(playerid)
{
    new s = OnlineInfo[playerid][oServiceMake][0]; // service id
    new mk = OnlineInfo[playerid][oServiceMake][2]; // make id

    new line[90],lines[360];
    if(MakeInfo[mk][mkStatus] == 1)
    {
        format(line,sizeof(line),"{cccccc}Активный Вызов: %s {cccccc}| Ожидание до %s \t", serviceName[s], fine_time(OnlineInfo[playerid][oServiceMake][1])), strcat(lines,line);
        format(line,sizeof(line),"\n{FF6347}Отменить вызов \t"), strcat(lines,line);
    }
    else
    {
        new callid = MakeInfo[mk][mkWhoTakePlayer];
        format(line,sizeof(line),"{cccccc}Активный Вызов: %s {cccccc}| {99ff66}Вызов Принят \t", serviceName[s]), strcat(lines,line);
        if(IsOnline(callid)) format(line,sizeof(line),"\n%s: \t{cccccc}%s", servicePlayerName[s], PlayerInfo[callid][pName]), strcat(lines,line);
        else format(line,sizeof(line),"\n%s: \t{cccccc}неизвестно", servicePlayerName[s]), strcat(lines,line);
    }
    ShowDialog(playerid,790,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Вызов служб",lines,"Выбрать","Отмена");
    return 1;
}
stock AutoMakeCreate(whom, type, id)
{
    new findslot = -1;
    for(new z = 0; z < MAX_MAKE_AMOUNT; z++) 
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
    MakeInfo[findslot][mkWhoType] = type + 1;

    switch(e_MakeType: type) {
        case MAKE_TYPE_VEHICLE: {
            GetVehiclePos(id, MakeInfo[findslot][mkCord][0], MakeInfo[findslot][mkCord][1], MakeInfo[findslot][mkCord][2]);
        }
        case MAKE_TYPE_HOUSE: {
            MakeInfo[findslot][mkCord][0] = DomInfo[id][dKoordinatX], MakeInfo[findslot][mkCord][1] = DomInfo[id][dKoordinatY], MakeInfo[findslot][mkCord][2] = DomInfo[id][dKoordinatZ];
        }
        case MAKE_TYPE_PLAYER: {
            GetPlayerRealPos(id, MakeInfo[findslot][mkCord][0], MakeInfo[findslot][mkCord][1], MakeInfo[findslot][mkCord][2]);
            MakeInfo[findslot][mkPlayerId] = id;
            OnlineInfo[id][oServiceMake][0] = 2;
            OnlineInfo[id][oServiceMake][1] = MAKE_AUTOCLOSE_TIME;
            OnlineInfo[id][oServiceMake][2] = findslot;
        }
    }

    MakeInfo[findslot][mkCreatedTime] = gettime();
    SetTimerEx("TimeOutCloseMake", MAKE_AUTOCLOSE_TIME * 1000, false, "dd", findslot, MakeInfo[findslot][mkCreatedTime]);

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
            if(IsPlayerRealPosInRangeOfPoint(i,1000.0,MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2]))
            {
                if(MakeInfo[number][mkWhoType] == 2) format(string, sizeof(string), "[DEP]: Сработала сигнализация в доме в районе %s. Номер вызова: %d",gSAZones[findraiontolist][zName],number+1);
                else if(MakeInfo[number][mkWhoType] == 1) format(string, sizeof(string), "[DEP]: Сработала сигнализация в транспорте в районе %s. Номер вызова: %d",gSAZones[findraiontolist][zName],number+1);
                else format(string, sizeof(string), "[DEP]: Поступил вызов от %s[%d] в районе %s. Номер вызова: %d",rpplayername(MakeInfo[number][mkPlayerId]), MakeInfo[number][mkPlayerId], gSAZones[findraiontolist][zName],number+1);
				SendClientMessage(i, COLOR_LIGHTNEUTRALBLUE, string);
            }
        }
        else if(MakeInfo[number][mkWho] == 2 && fraction(i) == 4)
        {
            if(IsPlayerRealPosInRangeOfPoint(i,1000.0,MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2]))
            {
                if(MakeInfo[number][mkWhoType] == 3) format(string, sizeof(string), "[DEP]: Человек в тяжелом состоянии в районе %s. Номер вызова: %d", gSAZones[findraiontolist][zName],number+1);
                else format(string, sizeof(string), "[DEP]: Поступил вызов от %s[%d] в районе %s. Номер вызова: %d",rpplayername(MakeInfo[number][mkPlayerId]), MakeInfo[number][mkPlayerId], gSAZones[findraiontolist][zName],number+1);
				SendClientMessage(i, COLOR_LIGHTNEUTRALBLUE, string);
            }
        }
    }
}

stock MakeCreate(playerid, whom)
{
    if(howstun(playerid)) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");

    new findslot = FindFreeMakeSlot();
    if(findslot == -1) return ErrorMessage(playerid,"{FF6347}В данный момент нет свободных слотов для вызовов\n\n{cccccc}Сообщите об этом администрации в [ /report ]");

    if(whom == 1)
    {
        if(PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pLeader] == 1 
            || PlayerInfo[playerid][pMember] == 11 || PlayerInfo[playerid][pLeader] == 11 
            || PlayerInfo[playerid][pMember] == 21 || PlayerInfo[playerid][pLeader] == 21) return ErrorMessage(playerid, "{FF6347}Вы сотрудник правоохранительных органов и не можете вызвать полицию");
        SetPlayerChatBubble(playerid,"вызывает полицию",COLOR_PURPLE,20.0,9000);
        SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Вызов: {0066ff}[ Полиция ]");
        SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Статус: {ccffff}Ожидание");
    }
    else if(whom == 2)
    {
        if(PlayerInfo[playerid][pMember] == 4 || PlayerInfo[playerid][pLeader] == 4) return ErrorMessage(playerid, "{FF6347}Вы работник ASGH и не можете вызвать скорую помощь");
        SetPlayerChatBubble(playerid,"вызывает скорую помощь",COLOR_PURPLE,20.0,9000);
        SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Вызов: {ff6666}[ Скорая Помощь ]");
        SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Статус: {ccffff}Ожидание");
    }
    around_player_audio(playerid, 3600, 0, 5.0, 0);

    MakeInfo[findslot][mkPlayerId] = playerid;
    MakeInfo[findslot][mkWho] = whom;
    MakeInfo[findslot][mkStatus] = 1;
    MakeInfo[findslot][mkWhoParam] = -1;
    MakeInfo[findslot][mkWhoType] = 3;

    GetPlayerRealPos(playerid, MakeInfo[findslot][mkCord][0], MakeInfo[findslot][mkCord][1], MakeInfo[findslot][mkCord][2]);

    OnlineInfo[playerid][oServiceMake][0] = whom; // service id
    OnlineInfo[playerid][oServiceMake][1] = 5 * 60;
    OnlineInfo[playerid][oServiceMake][2] = findslot; // make id

    MakeInfo[findslot][mkCreatedTime] = gettime();
    SetTimerEx("TimeOutCloseMake", MAKE_AUTOCLOSE_TIME * 1000, false, "dd", findslot, MakeInfo[findslot][mkCreatedTime]);

    MessageMake(findslot);
    return 1;
}

stock CloseMake(playerid,number)
{
    OnlineInfo[playerid][oTakeMake] = -1;
    if(PlayerInfo[playerid][pMember] == 1) GiveUnit(playerid, 17); // Выдаём копам юниты за закрытие вызова
    if(MakeInfo[number][mkPlayerId] == -1)
    {
        MakeInfo[number][mkWho] = -1;
        MakeInfo[number][mkStatus] = 0;
        MakeInfo[number][mkWhoParam] = -1;
        MakeInfo[number][mkWhoTakePlayer] = -1;
    }
    else 
    {
        if(IsOnline(MakeInfo[number][mkPlayerId])) AutoCloseMake(MakeInfo[number][mkPlayerId]);
    }
    return 1;
}

stock AutoCloseMake(playerid)
{
    if(OnlineInfo[playerid][oServiceMake][0] == 0) return 1;
    OnlineInfo[playerid][oServiceMake][1] = 0;

    new findslot = OnlineInfo[playerid][oServiceMake][2];
    if(OnlineInfo[playerid][oServiceMake][1] > 0 && MakeInfo[findslot][mkWhoType] == 0)
    {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: %s {cccccc}прибыл на место и закрыл вызов", servicePlayerName[OnlineInfo[playerid][oServiceMake][0]]);
        if(MakeInfo[findslot][mkWhoTakePlayer] != 0) SuccessMessage(MakeInfo[findslot][mkWhoTakePlayer], "{99ff66}Вы закрыли вызов");
    }
    DestroyPlayerMake(playerid, false);
    return 1;
}

stock RevivalCloseMake(playerid, medicid)
{
    if(OnlineInfo[playerid][oServiceMake][0] == 0) return 1;
    new number = OnlineInfo[playerid][oServiceMake][2];

    if(MakeInfo[number][mkWhoTakePlayer] >= 0 && MakeInfo[number][mkWhoTakePlayer] != medicid) MessageMakeCloseAccepted(playerid, number, 2);
    DestroyPlayerMake(playerid, false);
    return true;
}

stock MessageMakeCloseAccepted(playerid, number, typeClose)
{
    if(MakeInfo[number][mkWhoTakePlayer] >= 0)
    {
        new giveplayerid = MakeInfo[number][mkWhoTakePlayer];
        if(IsOnline(giveplayerid))
        {
            OnlineInfo[giveplayerid][oTakeMake] = -1;
            SendClientMessage(giveplayerid, COLOR_GREY, "[ Мысли ]: Упс.. кажется я не успел%s приехать на вызов", gender(giveplayerid));
            if(typeClose == 0) ErrorMessage(giveplayerid,"{ff6347}Вы не успели приехать на вызов\n{ffcc66}Игрок, который совершил вызов, вышел из игры");
            else if(typeClose == 1) ErrorMessage(giveplayerid,"{ff6347}Вы не успели приехать на вызов\n{ffcc66}Время активного вызова вышло");
            else if(typeClose == 2) ErrorMessage(giveplayerid,"{ff6347}Вы не успели приехать на вызов\n{ffcc66}Пострадавшего уже кто-то вылечил");
            else if(typeClose == 3) ErrorMessage(giveplayerid,"{ff6347}Вы не успели приехать на вызов\n{ffcc66}Пострадавший отправился в госпиталь или его кто-то вылечил");

            if(zones_gpsstat[giveplayerid] == true &&
                IsNearlyCloseGps(giveplayerid, 20.0, Protect_X[playerid], Protect_Y[playerid], Protect_Z[playerid], OnlineInfo[playerid][oWorldPlayer], OnlineInfo[playerid][oInteriorPlayer]))
            {
                DestroyGps(giveplayerid);
            }
        }
    }
    return true;
}

function TimeOutCloseMake(makeid, created_time)
{
    // Если на место вызова теперь другой - пропускаем
    if (MakeInfo[makeid][mkCreatedTime] != created_time) return 1;

    new e_MakeType: type = e_MakeType:(MakeInfo[makeid][mkWhoType] - 1);
    if (_:type < 0) return 1; // Если вызова не существует - пропускаем

    switch (type) {
        case MAKE_TYPE_VEHICLE, MAKE_TYPE_HOUSE: {
            DestroyMake(makeid);
        }
        case MAKE_TYPE_PLAYER: {
            new playerid = MakeInfo[makeid][mkPlayerId];

            // Если вызов неактивный - пропускаем
            if(OnlineInfo[playerid][oServiceMake][0] == 0) return 1;

            OnlineInfo[playerid][oServiceMake][1] = 0;

            new number = OnlineInfo[playerid][oServiceMake][2];
            MessageMakeCloseAccepted(playerid, number, 1);
            DestroyPlayerMake(playerid, false);
        }
        default: {}
    }

    return true;
}

stock ExitCloseMake(playerid)
{
    if(OnlineInfo[playerid][oServiceMake][0] == 0) return 1;
    new number = OnlineInfo[playerid][oServiceMake][2];

    MessageMakeCloseAccepted(playerid, number, 0);
    DestroyPlayerMake(playerid, false);
    return true;
}

stock DestroyMake(makeid) {
    if (makeid < 0 || makeid > MAX_MAKE_AMOUNT) return 1;

    MakeInfo[makeid][mkPlayerId] = -1;
    MakeInfo[makeid][mkWho] = 0;
    MakeInfo[makeid][mkStatus] = 0;
    MakeInfo[makeid][mkWhoType] = -1;
    MakeInfo[makeid][mkWhoTakePlayer] = -1;

    return 1;
}

stock DestroyPlayerMake(playerid, bool:message = true)
{
    if(OnlineInfo[playerid][oServiceMake][0] == 0) return 1;
    new makeid = OnlineInfo[playerid][oServiceMake][2];

    if(message == true) MessageMakeCloseAccepted(playerid, makeid, 3);

    OnlineInfo[playerid][oServiceMake][1] = 0;
    OnlineInfo[playerid][oServiceMake][0] = 0;
    OnlineInfo[playerid][oServiceMake][2] = 0;

    DestroyMake(makeid);

    return true;
}

stock TakeMake(playerid,number)
{
    new CopOrMin;
    if(fraction(playerid) == 4) CopOrMin = 2;
    else CopOrMin = 1;
    new giveplayerid = MakeInfo[number][mkPlayerId];

    MakeInfo[number][mkStatus] = 2;
    if(MakeInfo[number][mkWhoParam] == -1)
    {
        if(IsOnline(giveplayerid))
        {
            if(MakeInfo[number][mkWhoType] != 3) OnlineInfo[giveplayerid][oServiceMake][1] = MAKE_AUTOCLOSE_TIME;
            SuccessMessage(giveplayerid, "{99ff66}Вызов принят\n\n{cccccc}Пожалуйста, не покидайте радиус вызова (200 метров), до тех пор пока не приедет служба");
            SendClientMessage(giveplayerid, COLOR_GREY, " {AFAFAF}Запрос Принят, ожидайте прибытия служб. Пожалуйста, не покидайте радиус вызова (200 метров).");
        }
    }
    MakeInfo[number][mkWhoTake] = fraction(playerid);
    MakeInfo[number][mkWhoTakePlayer] = playerid;
    MakeInfo[number][mkWho] = CopOrMin;
    OnlineInfo[playerid][oTakeMake] = number;

    SendClientMessage(playerid, COLOR_GREY, "{ccffff}Вы приняли вызов. Отмечено в вашем GPS {ffcc66}[ Повторная активация GPS /findmake ]");
    if((MakeInfo[number][mkWhoType] == 0 || MakeInfo[number][mkWhoType] == 3) && IsOnline(giveplayerid))
    {
        SendClientMessage(playerid, COLOR_GREY, "{ccffff}Вызов совершил %s[%d]", rpplayername(giveplayerid), giveplayerid);
    }
    //if(CopOrMin == 1) SendClientMessage(playerid, COLOR_GREY, "{ccffff}По приезду на вызов закройте его [ /closemake ]");
    FindMake(playerid,number);
}

stock FindMake(playerid,number)
{
    if(MakeInfo[number][mkStatus] == 2 && MakeInfo[number][mkWhoParam] == -1)
    {
        if(ZoneTimer[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вас активна зона поиска, дождитесь её окончания");
        new findraiontolist = FindRaionPos(MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2]);
        ShowFindZone(playerid, MakeInfo[number][mkPlayerId], MakeInfo[number][mkCord][0], MakeInfo[number][mkCord][1],findraiontolist);
    }
    else if(MakeInfo[number][mkStatus] == 2 && MakeInfo[number][mkWhoParam] != -1)
    {
        if(MakeInfo[number][mkWhoType] == 1) // Вызвали на машину
        {
            if(VehInfo[MakeInfo[number][mkWhoParam]][vAlarmSystem] == 2 && VehInfo[MakeInfo[number][mkWhoParam]][vAlarmUnix]+604800 > gettime())
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
                ShowFindZone(playerid, MakeInfo[number][mkPlayerId], X, Y,findraiontolist);
            }
            else
            {
                if(ZoneTimer[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вас активна зона поиска, дождитесь её окончания");
                new findraiontolist = FindRaionPos(MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2]);
                ShowFindZone(playerid, MakeInfo[number][mkPlayerId], MakeInfo[number][mkCord][0], MakeInfo[number][mkCord][1],findraiontolist);
            }
        }
        else if(MakeInfo[number][mkWhoType] == 2) // Вызвали в дом
        {
            if(ZoneTimer[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вас активна зона поиска, дождитесь её окончания");
            new findraiontolist = FindRaionPos(MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2]);
            ShowFindZone(playerid, MakeInfo[number][mkPlayerId], MakeInfo[number][mkCord][0], MakeInfo[number][mkCord][1],findraiontolist);
        }
        else if(MakeInfo[number][mkWhoType] == 0 || MakeInfo[number][mkWhoType] == 3) // Вызов был от человека (поэтому сразу создаём GPS)
        {
            new giveplayerid = MakeInfo[number][mkPlayerId];
            if(IsOnline(giveplayerid))
            {
                new Float:pos_find[3];
                GetPlayerRealPos(giveplayerid, pos_find[0], pos_find[1], pos_find[2]);
                CreateGps(playerid, pos_find[0], pos_find[1], pos_find[2], OnlineInfo[giveplayerid][oWorldPlayer], OnlineInfo[giveplayerid][oInteriorPlayer], 2.0);
            }
            else ErrorMessage(playerid, "{FF6347}Ошибка! Игрок который совершил вызов вышел из игры");
        }
    }
    else return ErrorMessage(playerid,"{FF6347}Ошибка! Данный вызов нельзя отследить. Он не принят или недоступен");
    return 1;
}

CMD:findmake(playerid)
{
    if(OnlineInfo[playerid][oTakeMake] == -1) return ErrorMessage(playerid, "{FF6347}Вы не приняли вызов от другого игрока");
    FindMake(playerid, OnlineInfo[playerid][oTakeMake]);
    return 1;
}

CMD:acceptmake(playerid,const params[])
{
    new number;
    if(sscanf(params, "d",number)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Принять вызов {ffcc00}[ /acceptmake ID ]");
    if(number == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Принять вызов {ffcc00}[ /acceptmake ID ]");
    number--;
    if(MakeInfo[number][mkStatus] == 0) return ErrorMessage(playerid,"{FF6347}Данный вызов недоступен или его просто нет");
    new g = fraction(playerid);
    if(OnlineInfo[playerid][oTakeMake] != -1) return ErrorMessage(playerid,"{FF6347}У вас уже есть принятый вызов");
    if(MakeInfo[number][mkWho] == 1)
    {
        if(g != 1 && g != 11 && g != 21) return ErrorMessage(playerid,"{FF6347}Вы не работаете в SAPD");
        TakeMake(playerid,number);
    }
    else if(MakeInfo[number][mkWho] == 2)
    {
        if(g != 4) return ErrorMessage(playerid,"{FF6347}Вы не работаете в ASGH");
        TakeMake(playerid,number);
    }
    return 1;
}

CMD:closemake(playerid)
{
    if(OnlineInfo[playerid][oTakeMake] == -1) return ErrorMessage(playerid, "{FF6347}Вы не приняли вызов от другого игрока");
    new number = OnlineInfo[playerid][oTakeMake];
    if(MakeInfo[number][mkWhoParam] != -1 && MakeInfo[number][mkWhoType] == 1)
    {
        new Float:x,Float:y,Float:z;
        GetVehiclePos(MakeInfo[number][mkWhoParam],x,y,z);
        if(VehInfo[MakeInfo[number][mkWhoParam]][vAlarmSystem] == 2 && VehInfo[MakeInfo[number][mkWhoParam]][vAlarmUnix]+604800 > gettime())
        {
            if(!IsPlayerInRangeOfPoint(playerid,80.0,x,y,z)) return ErrorMessage(playerid,"{ff6347}Вы не можете завершить вызов находясь далеко от места вызова");
        }
        else
        {
            if(!IsPlayerInRangeOfPoint(playerid,80.0,MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2])) return ErrorMessage(playerid,"{ff6347}Вы не можете завершить вызов находясь далеко от места вызова");
        }
        CloseMake(playerid,number);
    }
    if(MakeInfo[number][mkStatus] != 2) return ErrorMessage(playerid,"{ff6347}Вы не можете завершить вызов, который никто не принял");
    if(MakeInfo[number][mkWhoTakePlayer] != playerid && MakeInfo[number][mkWhoTakePlayer] != -1) return ErrorMessage(playerid,"{ff6347}Вы не можете завершить вызов, который принял другой человек");
    if(!IsPlayerInRangeOfPoint(playerid,80.0,MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2])) return ErrorMessage(playerid,"{ff6347}Вы не можете завершить вызов находясь далеко от места вызова");
    CloseMake(playerid, number);
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
		ShowDialog(playerid,598,DIALOG_STYLE_MSGBOX,"{ff9000}Сервис","\n{ff9000}Вы уверены, что хотите вызвать {0066ff}полицию?\n\n{FF6347}Внимание! {cccccc}В случае ложного вызова вам придётся заплатить штраф\n","Да","Нет");
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
    if(IsPoliceMember(playerid)) CopOrMin = 1;
    else CopOrMin = 2;
    new line[214],lines[4048];
    format(line,sizeof(line),"№ Вызвавший\tСтатус\tРайон\tОсталось"), strcat(lines,line);
    new quan, targetid,findraiontolist,timemake[20];
    for(new z = 0; z < MAX_MAKE_AMOUNT; z++) 
    {
        if(MakeInfo[z][mkPlayerId] == -1) continue;

        if((MakeInfo[z][mkStatus] == 1 || MakeInfo[z][mkStatus] == 2) && CopOrMin == 1 && MakeInfo[z][mkWho] == 1)
        {
            if(MakeInfo[z][mkWhoType] > 0) timemake = "Срочный вызов";
            else timemake = fine_time(OnlineInfo[MakeInfo[z][mkPlayerId]][oServiceMake][1]);
            if(playerid != -1)
            {
                targetid = MakeInfo[z][mkPlayerId];
                findraiontolist = FindRaionPos(MakeInfo[z][mkCord][0],MakeInfo[z][mkCord][1],MakeInfo[z][mkCord][2]);
                if(MakeInfo[z][mkStatus] == 1) format(line,sizeof(line),"\n%d. %s[%d]\t{99ff66}В ожидании\t{cccccc}%s\t%s", quan+1, rpplayername(targetid), targetid, gSAZones[findraiontolist][zName],timemake), strcat(lines,line);
                else format(line,sizeof(line),"\n%d. %s[%d]\t{FF6347}Принят\t{cccccc}%s\t%s", quan+1, rpplayername(targetid), targetid, gSAZones[findraiontolist][zName],timemake), strcat(lines,line);
            }
            else
            {
                findraiontolist = FindRaionPos(MakeInfo[z][mkCord][0],MakeInfo[z][mkCord][1],MakeInfo[z][mkCord][2]);
                if(MakeInfo[z][mkStatus] == 1) format(line,sizeof(line),"\n%d. Неизвестно\t{99ff66}В ожидании\t{cccccc}%s\t%s", quan+1,gSAZones[findraiontolist][zName],timemake), strcat(lines,line);
                else format(line,sizeof(line),"\n%d. Неизвестно\t{FF6347}Принят\t{cccccc}%s\t%s", quan+1,gSAZones[findraiontolist][zName],timemake), strcat(lines,line);
            }
            List[quan][playerid] = z;
            quan++;
        }
        else if((MakeInfo[z][mkStatus] == 1 || MakeInfo[z][mkStatus] == 2) && CopOrMin == 2 && MakeInfo[z][mkWho] == 2)
        {
            if(playerid != -1)
            {
                timemake = fine_time(OnlineInfo[MakeInfo[z][mkPlayerId]][oServiceMake][1]);
                targetid = MakeInfo[z][mkPlayerId];
                findraiontolist = FindRaionPos(MakeInfo[z][mkCord][0],MakeInfo[z][mkCord][1],MakeInfo[z][mkCord][2]);
                if(MakeInfo[z][mkStatus] == 1) format(line,sizeof(line),"\n%d. %s[%d]\t{99ff66}В ожидании\t{cccccc}%s\t%s", quan+1, rpplayername(targetid), targetid, gSAZones[findraiontolist][zName],timemake), strcat(lines,line);
                else format(line,sizeof(line),"\n%d. %s[%d]\t{FF6347}Принят\t{cccccc}%s\t%s", quan+1, rpplayername(targetid), targetid, gSAZones[findraiontolist][zName],timemake), strcat(lines,line);
            }
            else
            {
                timemake = fine_time(OnlineInfo[MakeInfo[z][mkPlayerId]][oServiceMake][1]);
                targetid = MakeInfo[z][mkPlayerId];
                findraiontolist = FindRaionPos(MakeInfo[z][mkCord][0],MakeInfo[z][mkCord][1],MakeInfo[z][mkCord][2]);
                if(MakeInfo[z][mkStatus] == 1) format(line,sizeof(line),"\n%d. %s\t{99ff66}В ожидании\t{cccccc}%s\t%s", quan+1,gSAZones[findraiontolist][zName],timemake), strcat(lines,line);
                else format(line,sizeof(line),"\n%d. %s\t{FF6347}Принят\t{cccccc}%s\t%s", quan+1 ,gSAZones[findraiontolist][zName],timemake), strcat(lines,line);
            }
            List[quan][playerid] = z;
            quan++;
        }
        else if((MakeInfo[z][mkStatus] == 1 || MakeInfo[z][mkStatus] == 2) && CopOrMin == 0)
        {
            targetid = MakeInfo[z][mkPlayerId];
            findraiontolist = FindRaionPos(MakeInfo[z][mkCord][0],MakeInfo[z][mkCord][1],MakeInfo[z][mkCord][2]);
            if(MakeInfo[z][mkStatus] == 1) format(line,sizeof(line),"\n%d. %s[%d]\t{99ff66}В ожидании\t%d\t{cccccc}%s\t%s", quan+1, rpplayername(targetid), targetid, gSAZones[findraiontolist][zName],fine_time(OnlineInfo[playerid][oServiceMake][1])), strcat(lines,line);
            else format(line,sizeof(line),"\n%d. %s[%d]\t{FF6347}Принят\t%d\t{cccccc}%s\t%s", quan+1, rpplayername(targetid), targetid, gSAZones[findraiontolist][zName],fine_time(OnlineInfo[playerid][oServiceMake][1])), strcat(lines,line);
            
            List[quan][playerid] = z;
            quan++;
        }
        else
        {
            continue;
        }
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
            if(listitem < 0 || listitem > MAX_MAKE_AMOUNT) return ErrorMessage(playerid,"{ff6347}Выбрана не правильная строка.");
            new listselect = List[listitem][playerid],findraiontolist;
            DP[4][playerid] = listselect;
            new string[160], showMake;
            if(MakeInfo[listselect][mkStatus] == 2)
            {
                PlayerPlaySound(playerid,4203,0,0,0);
                format(string,sizeof(string),"{ff6347}Вызов уже принят: %s. Принял: %s",frakeasyName[MakeInfo[listselect][mkWhoTake]],rpplayername(MakeInfo[listselect][mkWhoTakePlayer]));
                Login[2][playerid] = 0;
                ShowDialog(playerid,1504,DIALOG_STYLE_MSGBOX,"Информация о вызове",string,"Закрыть","");
            }
            else if(MakeInfo[listselect][mkStatus] == 1 && OnlineInfo[playerid][oTakeMake] == -1) showMake = 1;
            else showMake = 2;

            if(showMake > 0)
            {
                findraiontolist = FindRaionPos(MakeInfo[listselect][mkCord][0], MakeInfo[listselect][mkCord][1], MakeInfo[listselect][mkCord][2]);
                format(string,sizeof(string),"{ff9000}Вызов от: %s\
                                            \n{cccccc}В районе: %s\
                                            \n\nВы хотите принять вызов?",rpplayername(MakeInfo[listselect][mkPlayerId]),gSAZones[findraiontolist][zName]);
                Login[2][playerid] = 0;
                ShowDialog(playerid,1479,DIALOG_STYLE_MSGBOX,"Информация о вызове",string,"Принять","Назад");
            }
        }
        else return pc_cmd_mdc(playerid);
        return true;
    }
    if(dialogid == 1479)
    {
        if(response)
        {
            new listselect = List[DP[4][playerid]][playerid];
            TakeMake(playerid,listselect);
        }
        else return MakeList(playerid);
        return true;
    }
    if(dialogid == 1504) MakeList(playerid);
    return false;
}

CMD:resetmakes(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 10) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать");
    new count = 0;
    for (new i = 0; i < MAX_MAKE_AMOUNT; i++)
    {
        if (MakeInfo[i][mkWho] != 0 && MakeInfo[i][mkStatus] == 1) // никто не взялся за заказ
        {
            if (MakeInfo[i][mkPlayerId] >= 0)
            {
                OnlineInfo[MakeInfo[i][mkPlayerId]][oServiceMake][0] = 0;
                OnlineInfo[MakeInfo[i][mkPlayerId]][oServiceMake][1] = 0;
                OnlineInfo[MakeInfo[i][mkPlayerId]][oServiceMake][2] = 0;
            }

			MakeInfo[i][mkPlayerId] = -1;
			MakeInfo[i][mkWho] = 0;
			MakeInfo[i][mkStatus] = 0;

            count++;
        }
    }
    SendClientMessage(playerid, COLOR_GREY, "Очищено: %d вызовов", count);
    return 1;
}

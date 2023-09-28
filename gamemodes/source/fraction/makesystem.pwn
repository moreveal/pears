#define MAX_MAKE 100 // Максимальное количество вызовов

enum mkInfo
{
    mkPlayerId, // playerid Создателя заявки
    mkWho, // Куда заявка. 0 нет вызова
    mkStatus, // проверка статуса
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

    format(lines,sizeof(lines),""); // Очищаем Lines
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
    around_player_audio(playerid, 3600, 0, 5.0);

    MakeInfo[findslot][mkPlayerId] = playerid;
    MakeInfo[findslot][mkWho] = whom;
    MakeInfo[findslot][mkStatus] = 1;

    GetPlayerRealPos(playerid, MakeInfo[findslot][mkCord][0], MakeInfo[findslot][mkCord][1], MakeInfo[findslot][mkCord][2]);

    OnlineInfo[playerid][oServiceMake][0] = whom; // servie id
    OnlineInfo[playerid][oServiceMake][1] = 300;
    OnlineInfo[playerid][oServiceMake][2] = findslot; // make id
    return 1;
}

stock CloseMake(playerid)
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
    OnlineInfo[playerid][oServiceMake][1] = 600;
    SendClientMessage(MakeInfo[number][mkPlayerId], COLOR_GREY, " {AFAFAF}Запрос Принят, ожидайте прибытия служб.");
    SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Вы приняли вызов.");
    SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Получение координат GPS доступно через бортовой ПК.");
}

stock FindMake(playerid,number)
{
    if(MakeInfo[number][mkStatus] == 2)
    {
        CreateGps(playerid,MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1],MakeInfo[number][mkCord][2], 0, 0, 50.0);
    }
    else return ErrorMessage(playerid,"{FF6347}Ошибка! Данный вызов нельзя отследить");
    return 1;
}

CMD:findmake(playerid,const params[])
{
    new number;
    if(sscanf(params, "d",number)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Принять вызов {ffcc00}[ /findmake ID ]");
    FindMake(playerid,number);
    return 1;
}

CMD:acceptmake(playerid,const params[])
{
    new number;
    if(sscanf(params, "d",number)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Принять вызов {ffcc00}[ /accaptmake ID ]");
    new g = fraction(playerid);
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
stock CallService(playerid, whom)
{
	if(OnlineInfo[playerid][oServiceMake][0] > 0)
    {
        new s = OnlineInfo[playerid][oServiceMake][0];
        if(whom != OnlineInfo[playerid][oServiceMake][0]) return format(store,sizeof(store),"{FF6347}Вы уже вызвали %s\n\n{cccccc}К сожалению, вы не можете вызвать два сервиса одновременно", serviceName[s]), ErrorMessage(playerid, store);
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
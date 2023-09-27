#define MAX_MAKE 50 // Максимальное количество вызовов

enum mkInfo
{
    mkPlayerId, // playerid Создателя заявки
    mkWho, // Куда заявка. 0 нет вызова
    mkStatus, // проверка статуса
    Float:mkCord[3], // Корды
}
new MakeInfo[MAX_MAKE][mkInfo];

stock MakeCreate(playerid,whom)
{
    new string[70];
    if(MPGO[playerid] != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я на мероприятии");
    if(CnnVed[playerid] >= 11) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я смотрю CNN Channel");
    if(PlayerInfo[playerid][pBkyrenie] >= 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чего, блин ?! Я не на земле");
    if(howstun(playerid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мне плохо...");
    if(GetPVarInt(playerid,"Boot") != 9999) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я в багажнике");
    if(Sleep[playerid] >= 1 || SleepRP[playerid] >= 1) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я сплю");
    if(Make[0][playerid] >= 1) return format(string, sizeof(string), "[ Мысли ]: Я уже жду службы [ Через %d сек. ]", Make[0][playerid]), SendClientMessage(playerid, COLOR_GREY, string), cmd_phone(playerid);
    new findslot = -1;
    for(new z = 0; z < MAX_MAKE; z++) 
    {
        if(MakeInfo[z][mkWho] == 0)
        {
            findslot = z;
            break;
        }
    }
    if(findslot == -1) return ErrorMessage(playerid,"В данный момент 50 активных вызовов.");
    PlayerInfo[playerid][makeID] = findslot;
    MakeInfo[findslot][mkPlayerId] = playerid;
    MakeInfo[findslot][mkWho] = whom;
    MakeInfo[findslot][mkStatus] = 1;
    new Float:X,Float:Y,Float:Z;
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0)
    {
        X = PlayerInfo[playerid][find_X];
        Y = PlayerInfo[playerid][find_Y];
        Z = PlayerInfo[playerid][find_Z];
    } 
    else 
    {
      GetPlayerPos(playerid, X,Y,Z);
    }
    MakeInfo[findslot][mkCord][0] = X;
    MakeInfo[findslot][mkCord][1] = Y;
    MakeInfo[findslot][mkCord][2] = Z;
    if(whom == 1)
    {
        if(PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pLeader] == 1 || PlayerInfo[playerid][pMember] == 11 || PlayerInfo[playerid][pLeader] == 11 || PlayerInfo[playerid][pMember] == 21 || PlayerInfo[playerid][pLeader] == 21) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я полицейский");
        SetPlayerChatBubble(playerid,"вызывает полицию",COLOR_PURPLE,20.0,9000);
        SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Вызов: {0066ff}[ Полиция ]");
        SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Статус: {ccffff}Ожидание");
        SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Запрос выполнен. Ожидайте...");
        SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Не покидайте место вызова. Иначи получите штраф...");
        SuccessMessage(playerid, "ОСТОРОЖНО\nЕсли вы покинете место вызова, вам могут выписать штраф!");
        // Вот как всем ПД кинуть, или найти самый ближайший патруль и только им?
    }
    else if(whom == 2)
    {
            if(PlayerInfo[playerid][pMember] == 4 || PlayerInfo[playerid][pLeader] == 4) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я Доктор");
        	SetPlayerChatBubble(playerid,"вызывает скорую помощь",COLOR_PURPLE,20.0,9000);
			SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Вызов: {0066ff}[ Скорая Помощь ]");
			SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Статус: {ccffff}Ожидание");
			SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Запрос выполнен. Ожидайте...");
    }
    Make[0][playerid] = 300;
}

stock CloseMake(playerid)
{
    new findslot = PlayerInfo[playerid][makeID];
    PlayerInfo[playerid][makeID] = -1;
    MakeInfo[findslot][mkPlayerId] = -1;
    MakeInfo[findslot][mkWho] = 0;
    MakeInfo[findslot][mkStatus] = 0;
    Make[0][playerid] = 0;
    if(IsPlayerConnected(playerid))
    {
        SendClientMessage(playerid, COLOR_GREY, "[Мысли] Время активности вашего вызова истекло.");
        SendClientMessage(playerid, COLOR_GREY, "[Мысли] Если проблема актуально, наверное стоит сделать вызов по новой?");
        SuccessMessage(playerid, "Время активности вашего вызова истекло.\nЕсли проблема актуально, наверное стоит сделать вызов по новой?");
    }
}

stock TakeMake(playerid,number)
{
    MakeInfo[number][mkStatus] = 2;
    Make[0][MakeInfo[number][mkPlayerId]] = 600;
    SendClientMessage(MakeInfo[number][mkPlayerId], COLOR_GREY, " {AFAFAF}Запрос Принят, ожидайте прибытия служб.");
    SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Вы приняли вызов.");
    SendClientMessage(playerid, COLOR_GREY, " {AFAFAF}Получение координат GPS доступно через бортовой ПК.");
}

stock FindMake(playerid,number)
{
    if(MakeInfo[number][mkStatus] == 2)
    {
        ShowFindZone(playerid,MakeInfo[number][mkCord][0],MakeInfo[number][mkCord][1]);
    }
    else return ErrorMessage(playerid,"Данный вызов нельзя отследить");
}
CMD:findmake(playerid,const params[])
{
    new number;
    if(sscanf(params, "d",number)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Принять вызов {ffcc00}[ /findmake ID ]");
    FindMake(playerid,number);
}

CMD:acceptmake(playerid,const params[])
{
    new number;
    if(sscanf(params, "d",number)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Принять вызов {ffcc00}[ /accaptmake ID ]");
    new g = fraction(playerid);
    if(MakeInfo[number][mkWho] == 1)
    {
        if(g != 1 && g != 11 && g != 21 && g != 1) return ErrorMessage(playerid,"Я не работаю в LSPD/SFPD/LVPD");
        TakeMake(playerid,number);
    }
    else if(MakeInfo[number][mkWho] == 2)
    {
        if(g != 3) return ErrorMessage(playerid,"Я не работаю в Мин.Здраве");
        TakeMake(playerid,number);
    }
    return 1;
}
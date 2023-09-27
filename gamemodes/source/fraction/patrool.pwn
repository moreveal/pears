#define MAX_PATROOL 50 // Максимальное количество патрульных

enum plInfo
{
    plGlav, // playerid Создателя патруля
    plStatus, // Статус[патрулирует, на вызове]
    plCoop[3], // Участники
}
new PatroolInfo[MAX_PATROOL][plInfo];

stock CreatePatrool(playerid, p0, p1, p2, g)
{
    if(g != 1 && g != 11 && g != 21) return ErrorMessage(playerid,"Вы не состоите в LSPD/SFPD/LVPD");
    new findslot = -1;
    for(new z = 0; z < MAX_PATROOL; z++) 
    {
        if(PatroolInfo[z][plGlav] == -1)
        {
            findslot = z;
            break;
        }
    }
    if(findslot == -1) return ErrorMessage(playerid,"В данный момент 50 патрульных машин.");
    new veh = GetPlayerVehicleID(playerid);
	new model = GetVehicleModel(veh);
	if(model != 596 && model != 597 && model != 598 && model != 599) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не на спец.транспорте(Police Car)");

    PlayerInfo[playerid][patroolID] == findslot;
    PatroolInfo[findslot][plGlav] = playerid;
    PatroolInfo[findslot][plStatus] = 0;
    new string[70];
    format(string,sizeof(string),"[ Мысли ]: Я вступил в патруль под руководством %s",PlayerInfo[playerid][pName]);
    if (p0 != -1)
    {
        PatroolInfo[findslot][plCoop][0] = p0;
        PlayerInfo[p0][patroolID] == findslot;
        SendClientMessage(p0,COLOR_GREY,string);
    }
    if (p1 != -1)
    {
        PatroolInfo[findslot][plCoop][1] = p1;
        PlayerInfo[p1][patroolID] == findslot;
        SendClientMessage(p1,COLOR_GREY,string);
    }
    if (p2 != -1)
    {
        PatroolInfo[findslot][plCoop][2] = p2;
        PlayerInfo[p2][patroolID] == findslot;
        SendClientMessage(p2,COLOR_GREY,string);
    }
    return SuccessMessage(playerid,"Я начал патруль");
}

stock ClosePatrool(playerid,g)
{
    new findslot = PlayerInfo[playerid][patroolID];
    if(PatroolInfo[findslot][plGlav] != playerid) return ErrorMessage(playerid,"Я не глава патруля");
    PatroolInfo[findslot][plGlav] = -1;
    PatroolInfo[findslot][plStatus] = 0;
    new p0 = PatroolInfo[findslot][plCoop][0];
    new p1 = PatroolInfo[findslot][plCoop][1];
    new p2 = PatroolInfo[findslot][plCoop][2];
    new string[70];
    format(string,sizeof(string),"[ Мысли ]: Руководитель %, распустил патруль",PlayerInfo[playerid][pName]);
    if (p0 != -1)
    {
        PatroolInfo[findslot][plCoop][0] = 0;
        PlayerInfo[p0][patroolID] == -1;
        SendClientMessage(p0,COLOR_GREY,string);
    }
    if (p1 != -1)
    {
        PatroolInfo[findslot][plCoop][1] = p1;
        PlayerInfo[p1][patroolID] == -1;
        SendClientMessage(p1,COLOR_GREY,string);
    }
    if (p2 != -1)
    {
        PatroolInfo[findslot][plCoop][2] = p2;
        PlayerInfo[p2][patroolID] == -1;
        SendClientMessage(p2,COLOR_GREY,string);
    }
    return SuccessMessage(playerid,"Вы распустили патруль");
}

CMD:createpatrool(playerid, const params[])
{
	if(PlayerInfo[playerid][pBkyrenie] >= 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чего, блин ?! Я не на земле");
	if(PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pLeader] == 1
	|| PlayerInfo[playerid][pLeader] == 11 || PlayerInfo[playerid][pMember] == 11
	|| PlayerInfo[playerid][pLeader] == 21 || PlayerInfo[playerid][pMember] == 21
    || PlayerInfo[playerid][pLeader] == 22 || PlayerInfo[playerid][pMember] == 22)
	{
        new g = fraction(playerid);
		if(sscanf(params, "s[144]s[144]s[144]", params[0], params[1], params[2])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Создание патруля {ffcc00}[ /createpatrool ID ID ID]");
		if(strlen(params[0]) > 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Слишком длинное имя [ Лимит 20 символов ]");
  		new giveplayerid0 = ReturnUser(params[0]);
        new giveplayerid1 = ReturnUser(params[1]);
        new giveplayerid2 = ReturnUser(params[2]);
        // Проверку на нуль какую-то чтоль сделать?
  		//if(giveplayerid0 == playerid || giveplayerid1 == playerid|| giveplayerid2 == playerid) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Зачем мне искать себя ?");
    	if(IsPlayerConnected(giveplayerid0))
    	{
            CreatePatrool(playerid,giveplayerid0,giveplayerid1,giveplayerid2,g);
		}
		else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу ехать один в патруль");
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу создать патруль");
	return 1;
}

CMD:closepatrool(playerid)
{
	if(PlayerInfo[playerid][pBkyrenie] >= 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чего, блин ?! Я не на земле");
	if(PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pLeader] == 1
	|| PlayerInfo[playerid][pLeader] == 11 || PlayerInfo[playerid][pMember] == 11
	|| PlayerInfo[playerid][pLeader] == 21 || PlayerInfo[playerid][pMember] == 21)
	{
        new g = fraction(playerid);
        ClosePatrool(playerid,g);
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу создать патруль");
	return 1;
}
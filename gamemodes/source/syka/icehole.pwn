new Float:IceHoleCoord[MAX_REALPLAYERS][3]; // Координаты для проруби
new bool:IceHoleStatus[MAX_REALPLAYERS]; // Статус проруби, активна или нет
new Text3D:IceHoleLabel[MAX_REALPLAYERS][2]; // Лейбл проруби
new IceHolePickUp[MAX_REALPLAYERS][2]; // Пикапы для проруби
new IceHoleUnix[MAX_REALPLAYERS]; // Таймер на удаление.

stock CreateIceHol(playerid)
{
    GetPlayerPos(playerid,IceHoleCoord[playerid][0],IceHoleCoord[playerid][1],IceHoleCoord[playerid][2]);
    IceHoleStatus[playerid] = true, IceHoleUnix[playerid] = 300;

    new string[100];
    format(string,sizeof(string),"{ff9000}Прорубь игрока \n{444444}%s",rpplayername(playerid));
    IceHoleLabel[playerid][0] = CreateDynamic3DTextLabel(string, 0xA9C4E4FF, IceHoleCoord[playerid][0],IceHoleCoord[playerid][1],IceHoleCoord[playerid][2], 5.0, .worldid = 0, .interiorid = 0);
    IceHoleLabel[playerid][1] = CreateDynamic3DTextLabel(string, 0xA9C4E4FF, IceHoleCoord[playerid][0],IceHoleCoord[playerid][1],IceHoleCoord[playerid][2] - 4.0, 5.0, .worldid = 0, .interiorid = 0);
    IceHolePickUp[playerid][0] = CreateDynamicPickup(1318, 1, IceHoleCoord[playerid][0],IceHoleCoord[playerid][1],IceHoleCoord[playerid][2], 0 ,0);
    IceHolePickUp[playerid][1] = CreateDynamicPickup(1318, 1, IceHoleCoord[playerid][0],IceHoleCoord[playerid][1],IceHoleCoord[playerid][2] - 4.0, 0 ,0);
    return true;
}

stock DestroyIceHole(playerid)
{
    if(!IceHoleLabel[playerid][0] || !IceHoleLabel[playerid][1] || !IceHolePickUp[playerid][0] || !IceHolePickUp[playerid][1]) return 0;
    DestroyDynamicPickup(IceHolePickUp[playerid][0]),DestroyDynamicPickup(IceHolePickUp[playerid][1]);
    DestroyDynamic3DTextLabel(IceHoleLabel[playerid][0]),DestroyDynamic3DTextLabel(IceHoleLabel[playerid][1]);
    IceHoleStatus[playerid] = false, IceHoleUnix[playerid] = 0;
    IceHoleCoord[playerid][0] = 0.0,IceHoleCoord[playerid][1]= 0.0,IceHoleCoord[playerid][2] = 0.0;
    return true;
}

stock IsAIceHole(playerid, &type)
{
    new result = -1;
    for(new p; p < MAX_REALPLAYERS; p++)
    {
        if(!IsPlayerConnected(p)) continue;
        if(IsPlayerInRangeOfPoint(playerid, 0.5, IceHoleCoord[p][0],IceHoleCoord[p][1],IceHoleCoord[p][2]))
        {
            type = 0;
            result = p;
            break;
        }
        else if(IsPlayerInRangeOfPoint(playerid, 0.5, IceHoleCoord[p][0],IceHoleCoord[p][1],IceHoleCoord[p][2] - 4.0))
        {
            type = 1;
            result = p;
            break;
        }
    }
    return result;
}

stock MovingToIceHole(playerid, hole, type)
{
    if(GetPVarInt(playerid,"antiflood") > 0) return ErrorMessage(playerid, "{FF6347}Пожалуйста, не флудите");
	SetPVarInt(playerid,"antiflood",5);
    if(type) PPSetPlayerPos(playerid, IceHoleCoord[hole][0],IceHoleCoord[hole][1],IceHoleCoord[hole][2]);
    else PPSetPlayerPos(playerid, IceHoleCoord[hole][0],IceHoleCoord[hole][1],IceHoleCoord[hole][2] - 4.0);
    return true;
}

stock Pump_IceHole(playerid)
{
	SetPVarInt(playerid, "oryjtemp", GetPVarInt(playerid, "oryjtemp") + 1 + random(3));

    new IceHoleX = GetPVarInt(playerid,"IceHoleX"), IceHoleY = GetPVarInt(playerid,"IceHoleY"),IceHoleZ = GetPVarInt(playerid,"IceHoleZ");
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, IceHoleX,IceHoleY,IceHoleZ)) 
    {
        SetPVarInt(playerid, "IceHoleX", 0),SetPVarInt(playerid, "IceHoleY", 0),SetPVarInt(playerid, "IceHoleZ", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
        return ErrorMessage(playerid, "{ff6347}Вы далеко отошли от проруби которую долбили, долбежка прервана!");
    }
    if(Hold[playerid] != 9)
    {
        SetPVarInt(playerid, "IceHoleX", 0),SetPVarInt(playerid, "IceHoleY", 0),SetPVarInt(playerid, "IceHoleZ", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
        return ErrorMessage(playerid, "{ff6347}Вы убрали монтировку из рук, долбежка прервана!");
    }
	if(GetPVarInt(playerid,"oryjtemp") >= 100)
	{
	 	GameTextForPlayer(playerid, RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Долбежка проруби: ~w~100/100"), 1500, 3);
        CreateIceHol(playerid);
        SetPVarInt(playerid, "IceHoleX", 0),SetPVarInt(playerid, "IceHoleY", 0),SetPVarInt(playerid, "IceHoleZ", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
	}
	else
	{
		new string[75];
		format(string, sizeof(string), RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Долбежка проруби: ~w~%d/100"), GetPVarInt(playerid, "oryjtemp"));
	 	GameTextForPlayer(playerid, string, 1500, 3);
	 	ApplyAnimation(playerid,"SWORD","sword_4",2.0, false, false, false, false, false);
 	}
 	return true;
}

stock Pump_StartIceHole(playerid)
{
    if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return 0;
    if(GetPVarInt(playerid, "Arobsklad") > 0) return 0;

    if(get_invent4(playerid, 90, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет монтировки");
    if(Hold[playerid] != 9) return ErrorMessage(playerid, "{FF6347}Возьмите в руки монтировку, чтобы начать долбить прорубь [ N ]");
    
    if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0) return ErrorMessage(playerid,"{ff6347}Вы находитесь не на улице");
    if(IceHoleStatus[playerid] || IceHoleUnix[playerid] > 0) 
    {
        CreateGps(playerid, IceHoleCoord[playerid][0], IceHoleCoord[playerid][1], IceHoleCoord[playerid][2], 0, 0, 5.0);
        return ErrorMessage(playerid,"{ff6347}У вас уже есть прорубь. Ждите пока она замерзнет");
    }
    if(!CA_IsPlayerNearWater(playerid)) return ErrorMessage(playerid,"{ff6347}В этом месте нельзя сделать прорубь");

    new Float:IceHoleX,Float:IceHoleY,Float:IceHoleZ;
    GetPlayerPos(playerid,IceHoleX,IceHoleY,IceHoleZ);
    SetPVarInt(playerid, "IceHoleX", floatround(IceHoleX, floatround_round));
    SetPVarInt(playerid, "IceHoleY", floatround(IceHoleY, floatround_round));
    SetPVarInt(playerid, "IceHoleZ", floatround(IceHoleZ, floatround_round));
    SetPVarInt(playerid, "oryjtemp", 0); SetPVarInt(playerid, "Arobsklad", 16);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Теперь мне нужно начать долбить прорубь {ff9000}[ Нажимайте %s ]", buttonName[Device[playerid]]);

    return true;
}
#define MAX_WILDPET 10

enum WildPetPos { Float:WildPetX, Float:WildPetY, Float:WildPetZ }
new WildPetCords[][WildPetPos] =
{
    { 1013.6417,-1007.0270,32.1016  },
    { 1284.5198,-1239.4286,14.1721  },
    { 1414.1638,-1305.2906,9.5477   },
    { 1421.8083,-1353.6865,13.5682  },
    { 1526.1659,-1233.8147,14.5054  },
    { 1617.1320,-1202.9979,19.8303  },
    { 1746.5835,-1356.4272,15.760   },
    { 1877.6028,-1434.2565,10.359   },
    { 1714.3312,-1544.9229,13.5469  },
    { 1719.6655,-1703.1714,13.5000  },
    { 1699.0656,-1777.3300,3.9862   },
    { 1341.2310,-1776.3857,13.4955  }
};
new WildPetPosOccupied[sizeof(WildPetCords)];

enum wildpet_Events
{
    WILDPET_WALKING,
    WILDPET_SIT,
    WILDPET_RUN,
    WILDPET_FOLLOW
}; 

enum wildpetnpc
{
	NPC:wildpetID, // ID бота
    wildpetPos, // Позиция спавна
    wildpetType, // Скин 
    wildpetHungry, // Кормление
    wildpet_Events: wildpetEvent, // Задачки
    wildpetEventUnix, // Время на задачки
    wildpetPlayer,
    wildpetUnix, // Таймер на спавн.
    wildpetAnim, // Статус анимки
    wildpetSoundUnix, // КД на звук дикого питомца
    Float:wildpetTaskCoord[3], // Координаты куда идти
    bool:wildpetDestinationStatus // Пришел или нет
}
new WildPetInfo[MAX_WILDPET][wildpetnpc];

stock FindRandomWildPet()
{
    new quanpet = random(5), quan, result = -1;
    for(new i = 0; i < MAX_PETS_TYPE; i++)
    {
        if(PetsParam[i][3] == 1)
        {
            quan++;
            if(quan >= quanpet) 
            {
                result = i;
                break;
            }
        }
    }
    return result;
}

stock FindWildPetPos()
{
    new result = -1;
    for(new i = 0; i < sizeof(WildPetCords); i++)
    {
        if(WildPetPosOccupied[i] == 0)
        {
            result = i;
            WildPetPosOccupied[i] = 1;
            break;
        }
    }
    return result;
}

stock CreateWildPet(pet)
{
    if(IsValidNpc(WildPetInfo[pet][wildpetID])) return false;
    new pos = FindWildPetPos();

    if(pos == -1) return false;

    WildPetInfo[pet][wildpetType] = FindRandomWildPet();
    WildPetInfo[pet][wildpetUnix] = gettime();
    WildPetInfo[pet][wildpetPos] = pos;
    WildPetInfo[pet][wildpetPlayer] = INVALID_PLAYER_ID;
    WildPetInfo[pet][wildpetHungry] = 0;
    WildPetInfo[pet][wildpetID] = CreateNpc(PetsParam[WildPetInfo[pet][wildpetType]][0], WildPetCords[pos][WildPetX], WildPetCords[pos][WildPetY], WildPetCords[pos][WildPetZ]);
    SetNpcInvulnerable(WildPetInfo[pet][wildpetID], true);
    SetNpcStunAnimationEnabled(WildPetInfo[pet][wildpetID], false);

    CreateTaskWalkingWildPet(pet);

    return true;
}

CMD:gotowildpet(playerid, const params[])
{
    new pet = 0;
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "i",pet)) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Телепортироваться к дикому питомцу [ /gotowildpet ID ]");
	if(pet < 0 || pet > MAX_WILDPET-1) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: ID не меньше 1 и не больше %d",MAX_WILDPET-1);
    if(!IsValidNpc(WildPetInfo[pet][wildpetID])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Животного под указанным номером нет!");
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ;
    GetNpcPosition(WildPetInfo[pet][wildpetID],AnimalX,AnimalY,AnimalZ);
    PPSetPlayerPos(playerid, AnimalX, AnimalY, AnimalZ);
    return true;
}

stock Pump_FeedWildPet(playerid)
{
	SetPVarInt(playerid, "oryjtemp", GetPVarInt(playerid, "oryjtemp") + 1);

    new pet = GetPVarInt(playerid,"wildpet");
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ;
    GetNpcPosition(WildPetInfo[pet][wildpetID],AnimalX,AnimalY,AnimalZ);
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, AnimalX,AnimalY,AnimalZ)) 
    {
        SetPVarInt(playerid, "wildpet", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
        return ErrorMessage(playerid, "{ff6347}Вы далеко отошли от питомца, кормление прервано!");
    }
    if(HoldStat[playerid] != 262)
    {
        SetPVarInt(playerid, "wildpet", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
        return ErrorMessage(playerid, "{ff6347}Вы убрали колбасу из рук, кормление прервано!");
    }
	if(GetPVarInt(playerid,"oryjtemp") >= 10)
	{
	 	GameTextForPlayer(playerid, RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Кормление: ~w~10/10"), 1500, 3);
	 	
        switch(random(10) + WildPetInfo[pet][wildpetHungry])
        {
            case 0..9:
            {
                WildPetInfo[pet][wildpetHungry]++;
                ErrorMessage(playerid, "{ff6347}Питомец съел всю колбасу... Нужно попробывать еще\n\n{cccccc}Шанс на успешное приручение был повышен!");
            }
            default: GivePlayerWildPet(playerid,pet);
        }

        stopdrink(playerid);
        RemovePlayerAttachedObject(playerid,1);

	 	ClearAnim(playerid);
        SetPVarInt(playerid, "wildpet", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
	}
	else
	{
		new string[75];
		format(string, sizeof(string), RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Кормление: ~w~%d/10"), GetPVarInt(playerid, "oryjtemp"));
	 	GameTextForPlayer(playerid, string, 1500, 3);
	 	ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, false, true, true, true, true);
 	}
 	return true;
}

stock FindWildPet(playerid)
{
    for(new pet = 0; pet < MAX_WILDPET; pet++)
    {
        if(WildPetInfo[pet][wildpetPlayer] == playerid)
        {
            Pump_StartFeedWildPet(playerid,pet);
            break;
        }       
    }
    return true;
}

stock GivePlayerWildPet(playerid,pet)
{
    new put_inva = GiveThingPlayer(playerid, PetsParam[WildPetInfo[pet][wildpetType]][2], 1, 0, 0, 6, 0, 9999);
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");

    DestroyWildPet(pet);
    SuccessMessage(playerid, "{44ff99}Я получил питомца. Теперь он в моем инвентаре!");

    return true;
}

stock Pump_StartFeedWildPet(playerid, pet)
{
    if(server != 0) return 0;
    if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return 0;
    if(GetPVarInt(playerid, "Arobsklad") > 0) return 0;

    if(get_invent4(playerid, 262, 0) <= 0 || get_para(playerid,262) < gettime()) return ErrorMessage(playerid, "{FF6347}У вас нет колбасы [ Приготовьте её на плите ]");
    if(HoldStat[playerid] != 262) return ErrorMessage(playerid, "{FF6347}Возьмите в руки колбасу, чтобы начать кормить питомца [ N ]");
    
    if(WildPetInfo[pet][wildpetPlayer] != playerid) return ErrorMessage(playerid, "{FF6347}Я не могу кормить животное которое шло не ко мне");
    SetPVarInt(playerid, "wildpet", pet), SetPVarInt(playerid, "oryjtemp", 0); SetPVarInt(playerid, "Arobsklad", 18);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Теперь мне нужно начать кормить питомца {ff9000}[ Нажимайте %s ]", buttonName[Device[playerid]]);

    return true;
}

stock LifeWildPet(pet)
{
    if(!IsValidNpc(WildPetInfo[pet][wildpetID])) 
    {
        if(WildPetInfo[pet][wildpetUnix] + 3600 < gettime()) CreateWildPet(pet);
        else return false;
    }
    
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ = 50;
    GetNpcPosition(WildPetInfo[pet][wildpetID],AnimalX,AnimalY,AnimalZ);

    WildPetPlaySound(pet);
    if(WildPetInfo[pet][wildpetEventUnix] < gettime())
    {
        if(WildPetInfo[pet][wildpetEvent] == WILDPET_WALKING) WildPetInfo[pet][wildpetEvent] = WILDPET_SIT, WildPetInfo[pet][wildpetAnim] = 0,WildPetInfo[pet][wildpetEventUnix] = gettime()+10;
        else WildPetInfo[pet][wildpetEvent] = WILDPET_WALKING, CreateTaskWalkingWildPet(pet),WildPetInfo[pet][wildpetEventUnix] = gettime()+20;
    }

    if(WildPetInfo[pet][wildpetEvent] == WILDPET_WALKING)
    {
        if(GetDistanceBetweenPoints2D(AnimalX, AnimalY, WildPetInfo[pet][wildpetTaskCoord][0], WildPetInfo[pet][wildpetTaskCoord][1]) <= 5.0) WildPetInfo[pet][wildpetDestinationStatus] = true;
        if(WildPetInfo[pet][wildpetDestinationStatus]) CreateTaskWalkingWildPet(pet);
    }
    if(WildPetInfo[pet][wildpetEvent] == WILDPET_SIT)
    {
        if(WildPetInfo[pet][wildpetAnim] == 0)
        {
            TaskNpcStandStill(WildPetInfo[pet][wildpetID]);
            TaskNpcPlayAnimation(WildPetInfo[pet][wildpetID],"PED", "WEAPON_CROUCH", 4.1, true, false, false, true, 0), WildPetInfo[pet][wildpetAnim] = 1;
        }
    }
    if(WildPetInfo[pet][wildpetEvent] == WILDPET_FOLLOW || WildPetInfo[pet][wildpetEvent] == WILDPET_RUN)
    {
        if(GetDistanceBetweenPoints2D(AnimalX, AnimalY, WildPetInfo[pet][wildpetTaskCoord][0], WildPetInfo[pet][wildpetTaskCoord][1]) >= 100.0) DestroyWildPet(pet);
    }
    return true;
}

stock CreateTaskWalkingWildPet(pet)
{
    new pos = WildPetInfo[pet][wildpetPos];
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ;
    AnimalX = random(40)-20 + WildPetCords[pos][WildPetX], AnimalY = random(40)-20 + WildPetCords[pos][WildPetY];
    CA_FindZ_For2DCoord(AnimalX,AnimalY,AnimalZ);
    AnimalZ += 1.0;
    
    WildPetInfo[pet][wildpetDestinationStatus] = false;
    WildPetInfo[pet][wildpetTaskCoord][0] = AnimalX, WildPetInfo[pet][wildpetTaskCoord][1] = AnimalY, WildPetInfo[pet][wildpetTaskCoord][2] = AnimalZ;

    TaskNpcGoToPoint(WildPetInfo[pet][wildpetID], AnimalX,AnimalY,AnimalZ, NPC_MOVE_MODE_WALK);
    return true;
}

stock DestroyWildPet(pet)
{
    if(IsValidNpc(WildPetInfo[pet][wildpetID])) DestroyNpc(WildPetInfo[pet][wildpetID]);
    WildPetPosOccupied[WildPetInfo[pet][wildpetPos]] = 0;
    // Очищаем все переменные WildPet
	for(new wildpetnpc:i; i < wildpetnpc; ++i) WildPetInfo[pet][i] = 0;
    WildPetInfo[pet][wildpetUnix] += 3600;

    return true;
}

stock WildPetPlaySound(pet)
{
    if(!IsValidNpc(WildPetInfo[pet][wildpetID])) return false;
    if(WildPetInfo[pet][wildpetSoundUnix] > gettime()) return false;
    WildPetInfo[pet][wildpetSoundUnix] = gettime()+5;
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ, Float:AnimalA;
    GetNpcPosition(WildPetInfo[pet][wildpetID],AnimalX,AnimalY,AnimalZ);
    new Float: PcordX, Float: PcordY, Float: PcordZ;
    foreach(Player,playerid)
    {
        if(!IsPlayerConnected(playerid)) continue;
        if(!IsPlayerInRangeOfPoint(playerid,30.0,AnimalX,AnimalY,AnimalZ)) continue;
        GetPlayerPos(playerid, PcordX, PcordY, PcordZ);
        new model = 0;
        GetPlayerAttachedObject(playerid, 1, model);

        if(model == 12727 && IsPlayerAttachedObjectSlotUsed(playerid, 1))
        {
            if(WildPetInfo[pet][wildpetEvent] == WILDPET_FOLLOW) return false;
            TaskNpcFollowPlayer(WildPetInfo[pet][wildpetID], playerid);
            WildPetInfo[pet][wildpetEvent] = WILDPET_FOLLOW;
            WildPetInfo[pet][wildpetPlayer] = playerid;
        }
        else
        {
            //if(WildPetInfo[pet][wildpetEvent] == WILDPET_RUN) return false;
            if(WildPetInfo[pet][wildpetEvent] == WILDPET_FOLLOW) TaskNpcStandStill(WildPetInfo[pet][wildpetID]);
            AnimalA = atan2(PcordY - AnimalY, PcordX-AnimalX) + 90.0;
            SetNpcFacingAngle(WildPetInfo[pet][wildpetID], AnimalA);

            AnimalX=AnimalX+500*floatsin(-AnimalA,degrees);
            AnimalY=AnimalY+500*floatcos(-AnimalA,degrees);
            
            WildPetInfo[pet][wildpetEvent] = WILDPET_RUN;
            TaskNpcGoToPoint(WildPetInfo[pet][wildpetID],AnimalX,AnimalY,AnimalZ, NPC_MOVE_MODE_RUN);
            WildPetInfo[pet][wildpetEventUnix] = gettime()+1000;
            WildPetInfo[pet][wildpetPlayer] = INVALID_PLAYER_ID;
        }
    }
    return true;
}

stock dialogInformationWildPets(playerid)
{
	new lines[700], string[60];
	format(lines,sizeof(lines),"\n{0088ff}Что за кошки/собаки гуляют по улицам?\n\
                                \n{cccccc}- Это дикие питомцы, их можно приручить и начать ухаживать за ними.\
								\n{cccccc}- Что бы приручить питомца вам нужно приготовить колбасу на кухонной плите.\
                                \n{cccccc}- Приготовьте несколько колбас. Шанс что питомец станет вашем с первой колбасы очень мал\
                                \n{cccccc}но с каждой колбасой шанс на приручение становится больше!\
                                \n{cccccc}- Дикие питомцы очень слабые, их прокачка займет много времени!\
                                \n{cccccc}- Питомцы спавнятся раз в час на территории Лос-Сантоса, в закаулках, у мусорок и т.п.");
	format(string,sizeof(string),"{ff9000}Что за кошки/собаки гуляют по улицам?");
	ShowDialog(playerid,PETS_HELP_LIST,DIALOG_STYLE_MSGBOX, string, lines, "Назад", "");
	return true;
}
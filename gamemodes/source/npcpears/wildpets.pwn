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
    wildpet_Events: wildpetEvent, // Задачки
    wildpetEventUnix, // Время на задачки
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

        if(model == 19847 && IsPlayerAttachedObjectSlotUsed(playerid, 1))
        {
            if(WildPetInfo[pet][wildpetEvent] == WILDPET_FOLLOW) return false;
            TaskNpcFollowPlayer(WildPetInfo[pet][wildpetID], playerid);
            WildPetInfo[pet][wildpetEvent] = WILDPET_FOLLOW;
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
        }
    }
    return true;
}
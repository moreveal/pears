#define MAX_WILD_ANIMALS_NPS 100
#define MAX_WILD_ANIMALS_AREA 20
#define MAX_WILD_ANIMALS_ZONE 5
#define MAX_WILD_ANIMALS_TYPE 5

new AnimalsParam[MAX_WILD_ANIMALS_TYPE][2] =
{
    { 15793, 500 },     // Медведь
    { 15794, 400 },     // Олень
    { 15795, 200 },     // Лиса
    { 15796, 100 },      // зайка
    { 15797, 300 }      // Волк
};

enum wildanimalsnpc
{
	NPC:waID, // ID бота
    bool:waDestinationStatus, // Идет или пришел
    waEvent, // 0 - ходит. 1 - атакует. 2 - убегает.
    waUnix, // Время убийства для деспавна
    waType, // Тип животного
    waArea, // Зона где заспавнился.
    waAttactID, // Кого атакует
    waKillerID, // кто убил
    Float:waHealth, // ХПшка
    Float:waTaskCoord[3], // Куда идет NPC
    waSoundUnix, // Кд на звук
    waBulletCount, // Сколько раз попали по животному
}
new WildAnimals[MAX_WILD_ANIMALS_NPS][wildanimalsnpc];

new WildAnimalsArea[MAX_WILD_ANIMALS_ZONE][2];
new HuntZone[MAX_REALPLAYERS][MAX_WILD_ANIMALS_ZONE];
new HuntGangZone[MAX_WILD_ANIMALS_ZONE];
new SittingStatus[MAX_REALPLAYERS];
new bool:LoadBag;

stock LoadAnimalsArea()
{
    WildAnimalsArea[0][0] = CreateDynamicCube(-1041.2166,-2752.3936, 0.0, -298.5008,-1658.5681, 250.0, 0, 0);   // Лес Флинт округ
    WildAnimalsArea[1][0] = CreateDynamicCube(-643.5008,-1582.5681, 0.0, -8.5008,-972.5681, 250.0, 0, 0);       // Поля Флинт округ
    WildAnimalsArea[2][0] = CreateDynamicCube(-73.0886,-823.3384, 0.0, 582.9846,-380.0188, 250.0, 0, 0);        // Лес туманный округ
    WildAnimalsArea[3][0] = CreateDynamicCube(1782.0000,-904.5643, 0.0, 2664.0000,-305.5643, 250.0, 0, 0);      // Лес у Шахты
    WildAnimalsArea[4][0] = CreateDynamicCube(2372.3381,-244.9590, 0.0, 2789.9521,270.7919, 250.0, 0, 0);       // Лес через ЖД над шахтой

    HuntGangZone[0] = GangZoneCreate(-1041.2166,-2752.3936, -298.5008,-1658.5681);
    HuntGangZone[1] = GangZoneCreate(-643.5008,-1582.5681, -8.5008,-972.5681);
    HuntGangZone[2] = GangZoneCreate(-73.0886,-823.3384, 582.9846,-380.0188);
    HuntGangZone[3] = GangZoneCreate(1782.0000,-904.5643, 2664.0000,-305.5643);
    HuntGangZone[4] = GangZoneCreate(2372.3381,-244.9590, 2789.9521,270.7919);
}

CMD:reloadanimals(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 15) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу использовать эту команду");
    for(new a; a < MAX_WILD_ANIMALS_NPS; a++)
    {
        WildAnimals[a][waUnix] = 0;
        DestroyAnimals(a);
    }
    for(new area; area < MAX_WILD_ANIMALS_ZONE; area++)
    {
        WildAnimalsArea[area][1] = 0;
        LoadWildAnimals(area);
    }
    SuccessMessage(playerid,"{44ff99}Я зареспавнил всех животных во всех зонах");
    return 1;
}
stock LoadWildAnimals(area)
{
    if(WildAnimalsArea[area][1]) return false;
    WildAnimalsArea[area][1] = 1;

    new type,typeanimal;
    for(new a = MAX_WILD_ANIMALS_AREA*area; a < MAX_WILD_ANIMALS_AREA*(1+area); a++)
    {
        type = random(MAX_WILD_ANIMALS_TYPE*5);
        switch(type)
        {
            case 0..10: typeanimal = 3;
            case 11..14: typeanimal = 2; 
            case 15..18: typeanimal = 4; 
            case 19..23: typeanimal = 1;
            case 24..25: typeanimal = 0; 
            default: typeanimal = 3;
        }
        if(IsValidNpc(WildAnimals[a][waID]))
        {
            if(WildAnimals[a][waUnix] != 0 && WildAnimals[a][waUnix] > gettime()) continue;
        }
        else {
            WildAnimals[a][waType] = typeanimal;
            WildAnimals[a][waArea] = area;
            CreateAnimals(a,area);
        }
    }
    return 1;
}

CMD:gotoanimal(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Телепортироваться к животному [ /gotoanimal ID ]");
	if(params[0] < 0 || params[0] > MAX_WILD_ANIMALS_NPS-1) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: ID не меньше 1 и не больше %d",MAX_WILD_ANIMALS_NPS-1);
    if(!IsValidNpc(WildAnimals[params[0]][waID])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Животного под указанным номером нет!");
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ;
    GetNpcPosition(WildAnimals[params[0]][waID],AnimalX,AnimalY,AnimalZ);
    PPSetPlayerPos(playerid, AnimalX, AnimalY, AnimalZ);
    return true;
}

stock CreateAnimals(a,area)
{
    if(IsValidNpc(WildAnimals[a][waID]))
    {
        if(WildAnimals[a][waUnix] != 0 && WildAnimals[a][waUnix] > gettime()) return false;
    }
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ = 50;
    if(area == 0) {
        AnimalX= random(743)-1041, AnimalY= random(1094)-2752;
        if(WildAnimals[a][waType] == 3 || WildAnimals[a][waType] == 1 || WildAnimals[a][waType] == 2) WildAnimals[a][waType] = 4;
    }
    else if(area == 1) {AnimalX= random(635)-643, AnimalY= random(610)-1582,WildAnimals[a][waType] = 3;}
    else if(area == 2) {AnimalX= random(509)-73, AnimalY= random(443)-380;}
    else if(area == 3) {AnimalX= random(882)+1782, AnimalY= random(599)-904;}
    else if(area == 4) {AnimalX= random(417)+2372, AnimalY= random(514)-244;}
    CA_FindZ_For2DCoord(AnimalX,AnimalY,AnimalZ);
    AnimalZ += 1.5;

    WildAnimals[a][waAttactID] = INVALID_PLAYER_ID;
    WildAnimals[a][waKillerID] = INVALID_PLAYER_ID;
    WildAnimals[a][waUnix] = 0;
    WildAnimals[a][waBulletCount] = 0;
    WildAnimals[a][waSoundUnix] = 0;
    WildAnimals[a][waID] = CreateNpc(AnimalsParam[WildAnimals[a][waType]][0], AnimalX, AnimalY, AnimalZ);
    WildAnimals[a][waHealth] = float(AnimalsParam[WildAnimals[a][waType]][1]);
    SetNpcStunAnimationEnabled(WildAnimals[a][waID], false);
    SetNpcVirtualWorld(WildAnimals[a][waID], 0);
    SetNpcHealth(WildAnimals[a][waID], WildAnimals[a][waHealth]);
    CreateTaskWalkingAnimals(a,area);
    return true;
}

stock DestroyAnimals(a)
{
    if(!IsValidNpc(WildAnimals[a][waID])) return 0;
    DestroyNpc(WildAnimals[a][waID]);
    WildAnimals[a][waID] = NPC:0;
    return true;
}

stock LifeWildAnimals(a)
{
    if(!IsValidNpc(WildAnimals[a][waID])) return 0;

    if(WildAnimals[a][waUnix] != 0 && WildAnimals[a][waUnix] < gettime()) return DestroyAnimals(a), WildAnimals[a][waUnix] = gettime()+300;    

    if(IsNpcInvulnerable(WildAnimals[a][waID])) return 0;
    
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ = 50;
    GetNpcPosition(WildAnimals[a][waID],AnimalX,AnimalY,AnimalZ);
    if(!IsPointInDynamicArea(WildAnimalsArea[WildAnimals[a][waArea]][0], AnimalX,AnimalY,AnimalZ) && WildAnimals[a][waEvent] != 1) return DestroyAnimals(a),WildAnimals[a][waUnix] = gettime()+300,WildAnimalsArea[WildAnimals[a][waArea]][1] = 0; // Не в зоне своей территории, удаляем.
    GetNpcHealth(WildAnimals[a][waID],WildAnimals[a][waHealth]);
    if(WildAnimals[a][waEvent] == 0) // Прогулка
    {
        if(GetDistanceBetweenPoints2D(AnimalX, AnimalY, WildAnimals[a][waTaskCoord][0], WildAnimals[a][waTaskCoord][1]) <= 20.0) WildAnimals[a][waDestinationStatus] = true;
        if(WildAnimals[a][waDestinationStatus]) CreateTaskWalkingAnimals(a, WildAnimals[a][waArea]);
    }
    if(WildAnimals[a][waEvent] == 1) // Атакует
    {
        WildAnimalPlaySound(a,0);
        if(!IsOnline(WildAnimals[a][waAttactID])) WildAnimals[a][waAttactID] = INVALID_PLAYER_ID;
        if(WildAnimals[a][waAttactID] == INVALID_PLAYER_ID || GetPlayerState(WildAnimals[a][waAttactID]) != PLAYER_STATE_ONFOOT || DeathInfo[WildAnimals[a][waAttactID]][deathStatus]) WildAnimals[a][waEvent] = 0, WildAnimals[a][waDestinationStatus] = true;
        else{
            new Float: PcordX, Float: PcordY, Float: PcordZ;
            GetPlayerPos(WildAnimals[a][waAttactID],PcordX,PcordY,PcordZ);
            if(GetDistancePoint(AnimalX,AnimalY,AnimalZ,PcordX, PcordY, PcordZ) >= 100 || GetPlayerState(WildAnimals[a][waAttactID]) == PLAYER_STATE_SPECTATING) WildAnimals[a][waEvent] = 0, WildAnimals[a][waDestinationStatus] = true, WildAnimals[a][waAttactID] = INVALID_PLAYER_ID;
        }
    }
    if(WildAnimals[a][waEvent] == 2) WildAnimalPlaySound(a,0);
    return true;
}

stock CreateTaskWalkingAnimals(a,area)
{
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ = 50;
    if(area == 0) AnimalX= random(743)-1041, AnimalY= random(1094)-2752;
    if(area == 1) AnimalX= random(635)-643, AnimalY= random(610)-1582;
    if(area == 2) AnimalX= random(509)-73, AnimalY= random(443)-380;
    if(area == 3) AnimalX= random(882)+1782, AnimalY= random(599)-904;
    if(area == 4) AnimalX= random(417)+2372, AnimalY= random(514)-244;
    CA_FindZ_For2DCoord(AnimalX,AnimalY,AnimalZ);
    AnimalZ += 1.0;
    
    WildAnimals[a][waEvent] = 0;
    WildAnimals[a][waDestinationStatus] = false;
    WildAnimals[a][waTaskCoord][0] = AnimalX, WildAnimals[a][waTaskCoord][1] = AnimalY, WildAnimals[a][waTaskCoord][2] = AnimalZ;

    TaskNpcGoToPoint(WildAnimals[a][waID], AnimalX,AnimalY,AnimalZ, NPC_MOVE_MODE_WALK);
    return true;
}

stock IsAreaWildAnimals(areaid)
{
    if(areaid == WildAnimalsArea[0][0]) return 0;
    else if(areaid == WildAnimalsArea[1][0]) return 1;
    else if(areaid == WildAnimalsArea[2][0]) return 2;
    else if(areaid == WildAnimalsArea[3][0]) return 3;
    else if(areaid == WildAnimalsArea[4][0]) return 4;
    return -1;
}

stock IsPlayerInWildZone(playerid)
{
    if(IsPlayerInDynamicArea(playerid, WildAnimalsArea[0][0])) return 0;
    else if(IsPlayerInDynamicArea(playerid, WildAnimalsArea[1][0])) return 1;
    else if(IsPlayerInDynamicArea(playerid, WildAnimalsArea[2][0])) return 2;
    else if(IsPlayerInDynamicArea(playerid, WildAnimalsArea[3][0])) return 3;
    else if(IsPlayerInDynamicArea(playerid, WildAnimalsArea[4][0])) return 4;
	return -1;
}

stock EventHandlerActionWildAnimalsMore(playerid,area,setrange)
{
    for(new a = MAX_WILD_ANIMALS_AREA*area; a < MAX_WILD_ANIMALS_AREA*(1+area); a++)
    {
       EventHandlerActionWildAnimals(playerid,a,setrange);
    }
    return true;
}

stock EventHandlerActionWildAnimals(playerid,a,setrange)
{
    new Float: PcordX, Float: PcordY, Float: PcordZ;
    GetPlayerPos(playerid, PcordX, PcordY, PcordZ);
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ, Float:AnimalA;
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 0;
    if(IsValidNpc(WildAnimals[a][waID]))
    {
        if(WildAnimals[a][waUnix] != 0 && WildAnimals[a][waUnix] > gettime()) return false;
        if(WildAnimals[a][waEvent] != 0) return false;
    }
    GetNpcPosition(WildAnimals[a][waID],AnimalX,AnimalY,AnimalZ);
    if(GetDistancePoint(AnimalX,AnimalY,AnimalZ,PcordX, PcordY, PcordZ) > setrange) return false;
    else
    {
        if(WildAnimals[a][waType] == 0 || WildAnimals[a][waType] == 4)
        {
            if(WildAnimals[a][waAttactID] != INVALID_PLAYER_ID && DeathInfo[playerid][deathStatus]) return false;
            else WildAnimals[a][waAttactID] = playerid, TaskNpcAttackPlayer(WildAnimals[a][waID], playerid, .aggressive = true);
            WildAnimals[a][waEvent] = 1;
            if(server == 0) SendClientMessageToAll(-1, "Зверек %d[%d] атакует игрока %d", _:WildAnimals[a][waID],WildAnimals[a][waType], playerid);
        }
        else
        {
            AnimalA = atan2(PcordY - AnimalY, PcordX-AnimalX) + 90.0;
            SetNpcFacingAngle(WildAnimals[a][waID], AnimalA);

            AnimalX=AnimalX+500*floatsin(-AnimalA,degrees);
            AnimalY=AnimalY+500*floatcos(-AnimalA,degrees);
            
            WildAnimals[a][waEvent] = 2;
            TaskNpcGoToPoint(WildAnimals[a][waID],AnimalX,AnimalY,AnimalZ, NPC_MOVE_MODE_RUN);
            if(server == 0) SendClientMessageToAll(-1, "Зверек %d[%d]  дал по съебам от игрока %d", _:WildAnimals[a][waID],WildAnimals[a][waType], playerid);
        }
    }
    return true;
}

stock EventHandlerHuntWildAnimalsShooting(playerid,area,WEAPON:weaponid)
{
    new setrange;
    if(weaponid == WEAPON:33 || weaponid == WEAPON:34) setrange = 30;
    else if((weaponid >= WEAPON:22 && weaponid <= WEAPON:32) || weaponid == WEAPON:38) setrange = 100;
    if(setrange == 0) return false;

    EventHandlerActionWildAnimalsMore(playerid,area,setrange);

    return true;
}

stock EventHandlerHuntWildAnimalsWalking(playerid, area) // При нажатие на C(типо крадемся на картах)
{   
    new setrange;
    // Залупа не хочет работать как надо, поэтому пока радиус будет такой
    if(SittingStatus[playerid]) setrange = 10;
    else setrange = 30;

    EventHandlerActionWildAnimalsMore(playerid,area,setrange);

    return true;
}

stock WildAnimals_OnPlayerTakeDamageNpc(NPC:npc, issuerid, Float:amount, weaponid, bodypart)
{
    #pragma unused amount
    #pragma unused weaponid
    #pragma unused bodypart
    
    new findSlot = -1;
    for(new a = 0; a < MAX_WILD_ANIMALS_NPS; a++)
    {
        if(WildAnimals[a][waID] == npc)
        {
            findSlot = a;
            break;
        }
    }

    if(findSlot >= 0)
    {
        new Float:damage = 1.0;
        if(WildAnimals[findSlot][waType] == 4) damage *= 25;
        else if(WildAnimals[findSlot][waType] == 0) damage *= 50;
        new Float: health = HealthAC[issuerid] - damage;

        // Устанавливаем HP игроку
        ACSetPlayerHealth(issuerid, health);
        if(health <= 0.0) WildAnimals[findSlot][waAttactID] = INVALID_PLAYER_ID;
        
        return 0;
    }
    return 1;
}

stock WildAnimals_OnPlayerGiveDamageNpc(NPC:npc, damagerid, Float:amount, weaponid, bodypart)
{
    #pragma unused bodypart
    
    if(GiveDamagePlayerToWildAnimals(npc,damagerid,weaponid,amount)) return true;
    return true;
}

stock GiveDamagePlayerToWildAnimals(NPC:npc,damagerid,weaponid,Float:amount)
{
    new findSlot = -1;
    for(new a = 0; a < MAX_WILD_ANIMALS_NPS; a++)
    {
        if(WildAnimals[a][waID] == npc)
        {
            findSlot = a;
            break;
        }
    }

    if(findSlot >= 0)
    {
        if(weaponid == 24) WildAnimals[findSlot][waBulletCount] += 20;
        else if(weaponid >= 25 && weaponid <= 27) WildAnimals[findSlot][waBulletCount] += 40;
        else if(weaponid >= 28 && weaponid <= 32) WildAnimals[findSlot][waBulletCount] += 4;
        else if(weaponid >= 33 && weaponid <= 34) WildAnimals[findSlot][waBulletCount] += 2;
        else WildAnimals[findSlot][waBulletCount] += 2;

        EventHandlerActionWildAnimals(damagerid,findSlot, 300);
        new Float:AnimalX, Float:AnimalY, Float:AnimalZ;
        GetNpcPosition(WildAnimals[findSlot][waID],AnimalX,AnimalY,AnimalZ);
        
        WildAnimals[findSlot][waHealth] -= amount;
        //SetNpcHealth(WildAnimals[findSlot][waID],WildAnimals[findSlot][waHealth]);
        if(WildAnimals[findSlot][waHealth] <= 0.0)
        {
            WildAnimals[findSlot][waSoundUnix] = 0, WildAnimalPlaySound(findSlot,1);
            SetNpcHealth(WildAnimals[findSlot][waID], 5000.0);
            WildAnimals[findSlot][waHealth] = 5000.0;
            SetNpcInvulnerable(WildAnimals[findSlot][waID], true);
            TaskNpcStandStill(WildAnimals[findSlot][waID]);
            TaskNpcPlayAnimation(WildAnimals[findSlot][waID],"CRACK", "crckdeth2",4.1,true, false, false, true, 500);
            
            WildAnimals[findSlot][waUnix] = gettime()+300;
            SetPlayerHudTask(damagerid, "Разделка туши животного", "Вы убили животное, подойдите к его трупу, возьмите в руку нож и нажмите [ ALT ] чтобы разделать его");
            WildAnimals[findSlot][waKillerID] = damagerid;
            CompletingDaily(damagerid, 6, 1), CompletingDaily(damagerid, WildAnimals[findSlot][waType]+22, 1);
            if(WildAnimals[findSlot][waType] == 4 && PlayerInfo[damagerid][pAchieve][134] == 0) AchievePlayer(damagerid, 134, 1);
            if(PlayerInfo[damagerid][pAchieve][135] == 0) AchievePlayer(damagerid, 135, 1);
            
            CreateGps(damagerid,AnimalX, AnimalY, AnimalZ, 0, 0, 2.0);
        }
        else WildAnimalPlaySound(findSlot,0);
        if(IsNpcInvulnerable(WildAnimals[findSlot][waID]))
        {
            TaskNpcPlayAnimation(WildAnimals[findSlot][waID],"CRACK", "crckdeth2",4.1,true, false, false, true, 500);
        }
        return true;
    }
    return false;
}

stock FindCarveAnimals(playerid) // Делаю пока так, ибо я рот ебал делать нагрузку дополнительную с чеком животных...
{
    new area = IsPlayerInWildZone(playerid);
    if(area == -1) return -1;

    new Float: PcordX, Float: PcordY, Float: PcordZ;
    GetPlayerPos(playerid, PcordX, PcordY, PcordZ);
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ;

    new result = -1;
    for(new a = MAX_WILD_ANIMALS_AREA*area; a < MAX_WILD_ANIMALS_AREA*(1+area); a++)
    {
        if(!IsValidNpc(WildAnimals[a][waID])) continue;
        if(WildAnimals[a][waHealth] > 0.0 && WildAnimals[a][waHealth] < 1000.0) continue;
        else if(WildAnimals[a][waUnix] != 0 && WildAnimals[a][waUnix] > gettime())
        {
            GetNpcPosition(WildAnimals[a][waID],AnimalX,AnimalY,AnimalZ);
            if(GetDistancePoint(AnimalX,AnimalY,AnimalZ,PcordX, PcordY, PcordZ) > 2.0) continue;
            else
            {   
                result = a;
                break;
            }
        }
    }
    return result;
}

stock CarveAnimals(playerid,a)
{
    if(!IsValidNpc(WildAnimals[a][waID])) return ErrorMessage(playerid,"{ff6347}Туши животного не найдено!");
    SetPlayerChatBubble(playerid,"разделывает тушу животного",COLOR_PURPLE,20.0,5000);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 3.0, false, true, true, false, false);
    if(getillness(playerid, 18) == -1) PlayerInfo[playerid][pMechSkill] --;
    update_ability(playerid, 4, 1);

    new ability = get_ability(playerid, 4);

    new chance = 100-WildAnimals[a][waBulletCount];
    if(ability >= 3 && ability <= 4) chance += 10;
    else if(ability >= 5 && ability <= 7) chance += 20;
    else if(ability >= 8 && ability <= 9) chance += 30;
    else if(ability >= 10) chance += 50;

    if(chance >= 100) chance = 99;
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ = 50.0;
    GetNpcPosition(WildAnimals[a][waID],AnimalX,AnimalY,AnimalZ);
    CA_FindZ_For2DCoord(AnimalX,AnimalY,AnimalZ);

    new CountMeat, TypeSkin;
    if(WildAnimals[a][waType] == 0) CountMeat = random(3)+7,TypeSkin = 247;
    else if(WildAnimals[a][waType] == 1) CountMeat = random(3)+5,TypeSkin = 248;
    else if(WildAnimals[a][waType] == 2) CountMeat = random(3)+2,TypeSkin = 245;
    else if(WildAnimals[a][waType] == 3) CountMeat = random(2)+1,TypeSkin = 244;
    else if(WildAnimals[a][waType] == 4) CountMeat = random(2)+2,TypeSkin = 246;

    if(chance <= 0)
    {
        SetThrow(-1, 22, 22, CountMeat, 0, 0, 0, 0, 0, 0, AnimalX,AnimalY, AnimalZ, 0.0, 0.0, 0.0, 600, 0, 0);
        SendClientMessage(playerid, COLOR_GRAY,"[ Мысли ] Я разделал%s тушку животного и получил%s только мясо.",gender(playerid),gender(playerid));
        SendClientMessage(playerid, COLOR_GRAY,"[ Мысли ] Мной было сделано много выстрелов... Вся шкура разорвана");
    }
    else
    {
        SetThrow(-1, 22, 22, CountMeat, gettime()+259200, 0, 0, 0, 0, 0, AnimalX,AnimalY, AnimalZ, 0.0, 0.0, 0.0, 600, 0, 0);
        SetThrow(-1, TypeSkin, TypeSkin, 1, chance, 0, 0, 0, 0, 0, AnimalX+0.3,AnimalY, AnimalZ, 0.0, 0.0, 0.0, 600, 0, 0);
        SendClientMessage(playerid, COLOR_GRAY,"[ Мысли ] Я разделал%s тушку животного и получил%s мясо и шкуру с качеством {ff9000}%d%%.",gender(playerid),gender(playerid),chance);
    }
    if(Hold[playerid] == 14)
    {
    	Hold[playerid] = 0, HoldStat[playerid] = 0, HoldFrisk[playerid] = 0, HoldQuan[playerid] = 0, HoldInva[playerid] = 0, HoldPara[playerid] = 0, HoldQara[playerid] = 0;
		RemovePlayerAttachedObject(playerid,1), PlayerPlaySound(playerid,5601,0,0,0), ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0, false, true, true, false, false);
    }
    HidePlayerHudTask(playerid);
    DestroyAnimals(a),WildAnimals[a][waUnix] = gettime()+300,WildAnimalsArea[WildAnimals[a][waArea]][1] = 0; // Удаляем зверушку и ставим КД
    return true;
}

stock Pump_CarveAnimals(playerid)
{
	SetPVarInt(playerid, "oryjtemp", GetPVarInt(playerid, "oryjtemp") + 1 + random(3));

    new a = GetPVarInt(playerid,"wildanimals");
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ;
    GetNpcPosition(WildAnimals[a][waID],AnimalX,AnimalY,AnimalZ);
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, AnimalX,AnimalY,AnimalZ)) 
    {
        SetPVarInt(playerid, "wildanimals", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
        return ErrorMessage(playerid, "{ff6347}Вы далеко отошли от животного, разделка прервана!");
    }
    if(Hold[playerid] != 14)
    {
        SetPVarInt(playerid, "wildanimals", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
        return ErrorMessage(playerid, "{ff6347}Вы убрали нож из рук, разделка прервана!");
    }
	if(GetPVarInt(playerid,"oryjtemp") >= 100)
	{
	 	GameTextForPlayer(playerid, RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Разделка туши: ~w~100/100"), 1500, 3);
	 	if(LoadBag && WildAnimals[a][waEvent] != 3) CreateBagWildAnimals(playerid, a);
        else CarveAnimals(playerid, a);
	 	ClearAnim(playerid);
        SetPVarInt(playerid, "wildanimals", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
	}
	else
	{
		new string[75];
		format(string, sizeof(string), RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Разделка туши: ~w~%d/100"), GetPVarInt(playerid, "oryjtemp"));
	 	GameTextForPlayer(playerid, string, 1500, 3);
	 	ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, false, true, true, true, true);
 	}
 	return true;
}

stock Pump_StartCarveAnimals(playerid, a)
{
    if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return 0;
    if(GetPVarInt(playerid, "Arobsklad") > 0) return 0;

    if(get_invent4(playerid, 97, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет ножа [ Купите его в супермаркете ]");
    if(Hold[playerid] != 14) return ErrorMessage(playerid, "{FF6347}Возьмите в руки нож, чтобы начать разделывать тушу [ N ]");
    
    if(WildAnimals[a][waKillerID] != playerid) return ErrorMessage(playerid, "{FF6347}Я не могу разделать тушу животного, которого убил не я");
    SetPVarInt(playerid, "wildanimals", a), SetPVarInt(playerid, "oryjtemp", 0); SetPVarInt(playerid, "Arobsklad", 15);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Теперь мне нужно начать разделывать тушу {ff9000}[ Нажимайте %s ]", buttonName[Device[playerid]]);

    return true;
}

CMD:loadbag(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 10) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(LoadBag) LoadBag = false, SuccessMessage(playerid, "{44ff99}Баг был исправлен");
    else LoadBag = true, SuccessMessage(playerid, "{44ff99}Баг был создан");
    return true;
}

stock CreateBagWildAnimals(playerid,a)
{
    SetNpcHealth(WildAnimals[a][waID],1);
    SetNpcInvulnerable(WildAnimals[a][waID],false);
    WildAnimals[a][waEvent] = 3;
    TaskNpcAttackPlayer(WildAnimals[a][waID], playerid, .aggressive = true);
    return true;
}

stock huntermap(playerid)
{
	if(get_invent4(playerid, 203, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет карты охотника");
	if(Dei[playerid] == 203)
	{
    	SetPlayerChatBubble(playerid,"сворачивает и убирает карту охотника",COLOR_PURPLE,30.0,8000);
  		Dei[playerid] = 0, PlayerPlaySound(playerid,5600,0,0,0);
  		Close_Huntmap(playerid);
	}
	else
	{
		if(Dei[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}У вашего персонажа заняты руки");
		if(HealthAC[playerid] <= 0 || howstun(playerid)) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
		infohuntermap(playerid);
  		SetPlayerChatBubble(playerid,"достаёт и разворачивает карту охотника",COLOR_PURPLE,30.0,8000);
  		Dei[playerid] = 203, PlayerPlaySound(playerid,5601,0,0,0);
  		TextDrawShowForPlayer(playerid, MapDrawHunt[0]);
		Update_Huntmap(playerid);
        ShowWildAnimalsZone(playerid);
    }
	return true;
}

stock infohuntermap(playerid)
{
	new stro[94],sctringo[1310];
	format(stro,sizeof(stro),"{0088ff}Как пользоваться картой Охотника?"), strcat(sctringo,stro);
	format(stro,sizeof(stro),"\n{cccccc}- Карта показывает кто находится в зоне диких животных"), strcat(sctringo,stro);
	format(stro,sizeof(stro),"\n{cccccc}- Если карта пустая, значит рядом с вами никого нет (кроме кроликов)"), strcat(sctringo,stro);
	format(stro,sizeof(stro),"\n{cccccc}- Волк: в данный момента в этой зоне есть волк"), strcat(sctringo,stro);
	format(stro,sizeof(stro),"\n{cccccc}- Лиса: в данный момента в этой зоне есть лиса"), strcat(sctringo,stro);
	format(stro,sizeof(stro),"\n{cccccc}- Олень: в данный момента в этой зоне есть олень"), strcat(sctringo,stro);
	format(stro,sizeof(stro),"\n{cccccc}- Медведь: в данный момента в этой зоне есть медведь"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n\n{cccccc}Также, на миникарте появляются границы районов охоты и их цвет зависит от типов животных в районе"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n- {FF1111}Красный:{cccccc} в данный зоне есть только агрессивные животные"), strcat(sctringo,stro);
	format(stro,sizeof(stro),"\n- {FDF136}Оранжевый:{cccccc} в данный зоне есть агрессивные и мирные животные"), strcat(sctringo,stro);
	format(stro,sizeof(stro),"\n- {30D130}Зеленый:{cccccc} в данный зоне есть только мирные животные"), strcat(sctringo,stro);
	ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Карта Охотника",sctringo,"Ок","");
	return true;
}

stock Update_Huntmap(playerid)
{
	new wildzone = IsPlayerInWildZone(playerid), yes[5];
    if(wildzone == -1)
    {
        TextDrawHideForPlayer(playerid, MapDrawHunt[1]);
        TextDrawHideForPlayer(playerid, MapDrawHunt[2]);
        TextDrawHideForPlayer(playerid, MapDrawHunt[3]);
        TextDrawHideForPlayer(playerid, MapDrawHunt[4]);
        HuntZone[playerid][0] = 0;
        HuntZone[playerid][1] = 0;
        HuntZone[playerid][2] = 0;
        HuntZone[playerid][4] = 0;
    }
    else
    {
        new AnimalId = 20*wildzone;
        for(new a = AnimalId; a < AnimalId+20; a++)
        {
            if(!IsValidNpc(WildAnimals[a][waID])) continue;
            else yes[WildAnimals[a][waType]] = 1;
        }
        if(yes[0] && !HuntZone[playerid][0]) TextDrawShowForPlayer(playerid,MapDrawHunt[1]),HuntZone[playerid][0] = 1;
        if(yes[1] && !HuntZone[playerid][1]) TextDrawShowForPlayer(playerid,MapDrawHunt[2]),HuntZone[playerid][1] = 1;
        if(yes[2] && !HuntZone[playerid][2]) TextDrawShowForPlayer(playerid,MapDrawHunt[3]),HuntZone[playerid][2] = 1;
        if(yes[4] && !HuntZone[playerid][4]) TextDrawShowForPlayer(playerid,MapDrawHunt[4]),HuntZone[playerid][4] = 1;
    }

	return true;
}

stock Close_Huntmap(p)
{
	TextDrawHideForPlayer(p, MapDrawHunt[0]);
	TextDrawHideForPlayer(p, MapDrawHunt[1]);
	TextDrawHideForPlayer(p, MapDrawHunt[2]);
	TextDrawHideForPlayer(p, MapDrawHunt[3]);
	TextDrawHideForPlayer(p, MapDrawHunt[4]);
    HuntZone[p][0] = 0;
    HuntZone[p][1] = 0;
    HuntZone[p][2] = 0;
    HuntZone[p][4] = 0;
	Dei[p] = 0;
    for(new g; g < MAX_WILD_ANIMALS_ZONE; g++)
    {
        GangZoneHideForPlayer(p, HuntGangZone[g]);
    }
    return true;
}

stock ShowWildAnimalsZone(playerid)
{
    new color[MAX_WILD_ANIMALS_ZONE], animalstype[MAX_WILD_ANIMALS_TYPE];
    for(new z; z < MAX_WILD_ANIMALS_ZONE; z++)
    {
        animalstype[0] = 0, animalstype[1] = 0,animalstype[2] = 0, animalstype[3] = 0,animalstype[4] = 0;
        for(new a=z*20; a < z*20+20; a++)
        {
            if(!IsValidNpc(WildAnimals[a][waID])) continue;
            animalstype[WildAnimals[a][waType]] = 1;
        }
        if(animalstype[0] == 0 && animalstype[4] == 0) color[z] = 0x30D130AA;
        else if((animalstype[0] != 0 || animalstype[4] != 0) && (animalstype[1] != 0 || animalstype[2] != 0 || animalstype[3] != 0)) color[z] = 0xFDF136AA;
        else if((animalstype[0] != 0 || animalstype[4] != 0) && (animalstype[1] == 0 && animalstype[2] == 0 && animalstype[3] == 0)) color[z] = 0xFF1111AA;
        else color[z] = 0xFDF136AA;
        GangZoneShowForPlayer(playerid, HuntGangZone[z], color[z]);
    }
}

stock WildAnimalPlaySound(a,type)
{
    if(!IsValidNpc(WildAnimals[a][waID])) return false;
    if(WildAnimals[a][waSoundUnix] > gettime()) return false;
    WildAnimals[a][waSoundUnix] = gettime()+5;
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ;
    GetNpcPosition(WildAnimals[a][waID],AnimalX,AnimalY,AnimalZ);
    foreach(Player,playerid)
    {
        if(!IsPlayerConnected(playerid)) continue;
        if(OnlineInfo[playerid][oListenRadioPears] != 0) continue;
        if(!IsPlayerInRangeOfPoint(playerid,30.0,AnimalX,AnimalY,AnimalZ)) continue;
        if(WildAnimals[a][waType] == 0) // Beer
        {
            if(type == 0) // Атакует
            {
                switch(random(5))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/bear/bear_attack0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/bear/bear_attack1.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 2: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/bear/bear_attack2.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 3: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/bear/bear_attack3.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 4: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/bear/bear_attack4.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/bear/bear_attack0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                }
            }
            else // dead
            {
                PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/bear/bear_death0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
            }
        }
        else if(WildAnimals[a][waType] == 1) // Олень
        {
            if(type == 0) // Атакует/убегает
            {
                switch(random(2))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/deer/deer_run0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/deer/deer_run1.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/deer/deer_run0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                }
            }
            else // dead
            {
                switch(random(3))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/deer/deer_death0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/deer/deer_death1.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/deer/deer_death2.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                }
            }
        }
        else if(WildAnimals[a][waType] == 2) // fox
        {
            if(type == 0) // Атакует/убегает
            {
                switch(random(3))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/fox/fox_run0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/fox/fox_run1.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/fox/fox_run2.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                }
            }
            else // dead
            {
                switch(random(3))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/fox/fox_death0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/fox/fox_death1.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/fox/fox_death2.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                }
            }
        }
        else if(WildAnimals[a][waType] == 3) // rabbit
        {
            if(type == 0) // Атакует/убегает
            {
                PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/rabbit/rabbit_run0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
            }
            else // dead
            {
                switch(random(3))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/rabbit/rabbit_death0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/rabbit/rabbit_death1.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/rabbit/rabbit_death2.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                }
            }
        }
        else if(WildAnimals[a][waType] == 4) // wolf
        {
            if(type == 0) // Атакует
            {
                switch(random(5))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/wolf/wolf_attack0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/wolf/wolf_attack1.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 2: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/wolf/wolf_attack2.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 3: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/wolf/wolf_attack3.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 4: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/wolf/wolf_attack4.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/wolf/wolf_attack5.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                }
            }
            else
            {
                switch(random(4))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/wolf/wolf_death0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/wolf/wolf_death1.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 2: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/wolf/wolf_death2.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    case 3: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/wolf/wolf_death3.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/wolf/wolf_death0.mp3",AnimalX, AnimalY, AnimalZ, 30.0, true);
                }
            }
        }
    }
    return true;
}


//=========================================================
//=================== Касцена Охота=====================
new NPC:WildAnimalsNPC[MAX_PLAYERS][5];
new WildAnimalsTimer[MAX_PLAYERS][2];

stock WildAnimalsCuteScene(playerid)
{
    TogglePlayerControllable(playerid,false);
    new Float:X, Float:Y, Float:Z, Float:A;
    GetPlayerPos(playerid, X, Y, Z); GetPlayerFacingAngle(playerid, A);
    SpA[playerid]=A;SpX[playerid]=X;SpY[playerid]=Y;SpZ[playerid]=Z;
    PPSetPlayerPos(playerid,2623.2979,-849.8397,74.8496);
    SetPlayerVirtualWorld(playerid, playerid);
    SetCameraBehindPlayer(playerid);
    SetPlayerCameraPos(playerid, 2623.2979,-849.8397,74.8496);
    SetPVarInt(playerid,"qweststat",75), SetPVarInt(playerid,"qwesttime",1);
    WildAnimalsTimer[playerid][1] = SetTimerEx("WildAnimalsTimers2", 2000, true, "d", playerid);
    PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/forester/forester0.mp3");
    return true;
}

stock DestroyWildAnimalsCuteScene(playerid)
{
    if(WildAnimalsTimer[playerid][0] > 0)
    {
        PPSetPlayerPos(playerid,SpX[playerid],SpY[playerid],SpZ[playerid]);
        SetPlayerVirtualWorld(playerid,0);
        SetPlayerFacingAngle(playerid, SpA[playerid]);
        SetCameraBehindPlayer(playerid);
        KillTimer(WildAnimalsTimer[playerid][0]);
        WildAnimalsTimer[playerid][0] = 0;
        TogglePlayerControllable(playerid,true);
        DoneHintPlayer(playerid,3);
        for(new a; a < 5; a++)
        {
            DestroyNpc(WildAnimalsNPC[playerid][a]);
            WildAnimalsNPC[playerid][a] = NPC:0;
        }
        return true;
    }
    return false;
}

function WildAnimalsTimers(playerid)
{
    DestroyWildAnimalsCuteScene(playerid);
    return true;
}

stock DestroyWildAnimalsCuteScene2(playerid)
{
    if(WildAnimalsTimer[playerid][1] > 0)
    {
        WildAnimalsTimer[playerid][0] = SetTimerEx("WildAnimalsTimers", 45000, true, "d", playerid);
        WildAnimalsNPC[playerid][0] = CreateNpc(15796, 2595.1147,-825.8525,78.5166);
        WildAnimalsNPC[playerid][1] = CreateNpc(15797, 2605.4377,-827.4437,77.5653);
        WildAnimalsNPC[playerid][2] = CreateNpc(15795, 2505.5630,-860.6196,92.3974);
        WildAnimalsNPC[playerid][3] = CreateNpc(15794, 2453.4192,-840.2479,106.7003);
        WildAnimalsNPC[playerid][4] = CreateNpc(15793, 2439.4397,-795.5780,112.2216);
        SetNpcVirtualWorld(WildAnimalsNPC[playerid][0], playerid);
        TaskNpcGoToPoint(WildAnimalsNPC[playerid][0], 2552.0205,-800.5846,86.5453, NPC_MOVE_MODE_RUN);
        SetNpcVirtualWorld(WildAnimalsNPC[playerid][1], playerid);
        TaskNpcGoToPoint(WildAnimalsNPC[playerid][1], 2553.0205,-800.5846,86.5453, NPC_MOVE_MODE_RUN);
        new Float:AnimalX,Float:AnimalY,Float:AnimalZ;
        for(new a = 2; a < 5; a++)
        {
            SetNpcVirtualWorld(WildAnimalsNPC[playerid][a], playerid);
            AnimalX= random(882)+1782, AnimalY= random(599)-904;
            TaskNpcGoToPoint(WildAnimalsNPC[playerid][a], AnimalX,AnimalY,AnimalZ, NPC_MOVE_MODE_WALK);
        }
        FlyCameraPos(playerid, 2454.396484, -803.477600, 112.390365, 2454.953369, -808.368957, 111.515983, 45000, 2000);
        WildAnimalsTimer[playerid][1] = 0;
        KillTimer(WildAnimalsTimer[playerid][1]);
        return true;
    }
    return false;
}

function WildAnimalsTimers2(playerid)
{
    DestroyWildAnimalsCuteScene2(playerid);
    return true;
}
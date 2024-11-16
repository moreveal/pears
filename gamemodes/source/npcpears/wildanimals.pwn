#define MAX_WILD_ANIMALS_NPS 100
#define MAX_WILD_ANIMALS_AREA 20
#define MAX_WILD_ANIMALS_TYPE 5

new friskQualityColorAndText[5][] =
{
    { "{FF6347}Ужасное" },
    { "{D2B48C}Плохое" },
    { "{54FF9F}Нормальное" }, 
    { "{8B00FF}Хорошее" }, 
    { "{ffd700}Отличное" }
};

new AnimalsParam[MAX_WILD_ANIMALS_TYPE][2] =
{
    { 15793, 300 },     // Медведь
    { 15794, 200 },     // Олень
    { 15795, 100 },     // Лиса
    { 15796, 50 },      // зайка
    { 15797, 200 }      // Волк
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
    waBulletCount, // Сколько раз попали по животному
}
new WildAnimals[MAX_WILD_ANIMALS_NPS][wildanimalsnpc];

new WildAnimalsArea[5][2];
new SittngStatus[MAX_REALPLAYERS];
new bool:LoadBag;

stock LoadAnimalsArea()
{
    WildAnimalsArea[0][0] = CreateDynamicCube(-1041.2166,-2752.3936, 0.0, -298.5008,-1658.5681, 250.0, 0, 0);   // Лес Флинт округ
    WildAnimalsArea[1][0] = CreateDynamicCube(-643.5008,-1582.5681, 0.0, -8.5008,-972.5681, 250.0, 0, 0);       // Поля Флинт округ
    WildAnimalsArea[2][0] = CreateDynamicCube(-73.0886,-823.3384, 0.0, 582.9846,-380.0188, 250.0, 0, 0);        // Лес туманный округ
    WildAnimalsArea[3][0] = CreateDynamicCube(1782.0000,-904.5643, 0.0, 2664.0000,-305.5643, 250.0, 0, 0);      // Лес у Шахты
    WildAnimalsArea[4][0] = CreateDynamicCube(2372.3381,-244.9590, 0.0, 2789.9521,270.7919, 250.0, 0, 0);       // Лес через ЖД над шахтой
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
            else continue;
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
    if(area == 0) {AnimalX= random(743)-1041, AnimalY= random(1094)-2752;}
    else if(area == 1) {AnimalX= random(635)-643, AnimalY= random(610)-1582,WildAnimals[a][waType] = 3;}
    else if(area == 2) {AnimalX= random(509)-73, AnimalY= random(443)-380;}
    else if(area == 3) {AnimalX= random(882)+1782, AnimalY= random(599)-904;}
    else if(area == 4) {AnimalX= random(417)+2372, AnimalY= random(514)-244;}
    CA_FindZ_For2DCoord(AnimalX,AnimalY,AnimalZ);
    AnimalZ += 1.5;

    WildAnimals[a][waAttactID] = INVALID_PLAYER_ID;
    WildAnimals[a][waBulletCount] = 0;
    WildAnimals[a][waID] = CreateNpc(AnimalsParam[WildAnimals[a][waType]][0], AnimalX, AnimalY, AnimalZ);
    WildAnimals[a][waHealth] = AnimalsParam[WildAnimals[a][waType]][1];
    SetNpcStunAnimationEnabled(WildAnimals[a][waID], false);
    SetNpcVirtualWorld(WildAnimals[a][waID], 0);
    SetNpcHealth(WildAnimals[a][waID], AnimalsParam[WildAnimals[a][waType]][1]);
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

    GetNpcHealth(WildAnimals[a][waID],WildAnimals[a][waHealth]);

    new Float:AnimalX, Float:AnimalY, Float:AnimalZ = 50;
    GetNpcPosition(WildAnimals[a][waID],AnimalX,AnimalY,AnimalZ);
    if(!IsPointInDynamicArea(WildAnimalsArea[WildAnimals[a][waArea]][0], AnimalX,AnimalY,AnimalZ) && WildAnimals[a][waEvent] != 1) return DestroyAnimals(a),WildAnimals[a][waUnix] = gettime()+300,WildAnimalsArea[WildAnimals[a][waArea]][1] = 0; // Не в зоне своей территории, удаляем.
    if(WildAnimals[a][waHealth] <= 0.0 || WildAnimals[a][waHealth] >= 1000.0) return 0;
    if(WildAnimals[a][waEvent] == 0) // Прогулка
    {
        if(GetDistancePoint(AnimalX, AnimalY,AnimalZ, WildAnimals[0][waTaskCoord][0], WildAnimals[0][waTaskCoord][1],WildAnimals[a][waTaskCoord][2]) <= 20.0) WildAnimals[a][waDestinationStatus] = true;
        if(WildAnimals[a][waDestinationStatus]) CreateTaskWalkingAnimals(a, WildAnimals[a][waArea]);
    }
    if(WildAnimals[a][waEvent] == 1) // Атакует
    {
        if(!IsOnline(WildAnimals[a][waAttactID])) WildAnimals[a][waAttactID] = INVALID_PLAYER_ID;
        if(WildAnimals[a][waAttactID] == INVALID_PLAYER_ID || GetPlayerState(WildAnimals[a][waAttactID]) != PLAYER_STATE_ONFOOT) WildAnimals[a][waEvent] = 0, WildAnimals[a][waDestinationStatus] = true;
        else{
            new Float: PcordX, Float: PcordY, Float: PcordZ;
            GetPlayerPos(WildAnimals[a][waAttactID],PcordX,PcordY,PcordZ);
            if(GetDistancePoint(AnimalX,AnimalY,AnimalZ,PcordX, PcordY, PcordZ) >= 100 || GetPlayerState(WildAnimals[a][waAttactID]) == PLAYER_STATE_SPECTATING) WildAnimals[a][waEvent] = 0, WildAnimals[a][waDestinationStatus] = true, WildAnimals[a][waAttactID] = INVALID_PLAYER_ID;
        }
    }
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

stock EventHandlerActionWildAnimals(playerid,area,setrange)
{
    new Float: PcordX, Float: PcordY, Float: PcordZ;
    GetPlayerPos(playerid, PcordX, PcordY, PcordZ);
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ, Float:AnimalA;
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 0;
    for(new a = MAX_WILD_ANIMALS_AREA*area; a < MAX_WILD_ANIMALS_AREA*(1+area); a++)
    {
        if(IsValidNpc(WildAnimals[a][waID]))
        {
            if(WildAnimals[a][waUnix] != 0 && WildAnimals[a][waUnix] > gettime()) continue;
            if(WildAnimals[a][waEvent] != 0) continue;
        }
        GetNpcPosition(WildAnimals[a][waID],AnimalX,AnimalY,AnimalZ);
        if(GetDistancePoint(AnimalX,AnimalY,AnimalZ,PcordX, PcordY, PcordZ) > setrange) continue;
        else
        {
            if(WildAnimals[a][waType] == 0 || WildAnimals[a][waType] == 4)
            {
                if(WildAnimals[a][waAttactID] != INVALID_PLAYER_ID) continue;
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
    }
    return true;
}

stock EventHandlerHuntWildAnimalsShooting(playerid,area,WEAPON:weaponid)
{
    new setrange;
    if(weaponid == WEAPON:33 || weaponid == WEAPON:34) setrange = 30;
    else if((weaponid >= WEAPON:22 && weaponid <= WEAPON:32) || weaponid == WEAPON:38) setrange = 100;
    if(setrange == 0) return false;

    EventHandlerActionWildAnimals(playerid,area,setrange);

    return true;
}

stock EventHandlerHuntWildAnimalsWalking(playerid, area) // При нажатие на C(типо крадемся на картах)
{   
    new setrange;
    // Залупа не хочет работать как надо, поэтому пока радиус будет такой
    if(SittngStatus[playerid]) setrange = 10;
    else setrange = 30;

    EventHandlerActionWildAnimals(playerid,area,setrange);

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

        GetNpcHealth(WildAnimals[findSlot][waID],WildAnimals[findSlot][waHealth]);
        WildAnimals[findSlot][waHealth] -= amount;
        if(WildAnimals[findSlot][waHealth] <= 0.0)
        {
            new Float:AnimalX, Float:AnimalY, Float:AnimalZ;
            GetNpcPosition(WildAnimals[findSlot][waID],AnimalX,AnimalY,AnimalZ);

            DestroyNpc(WildAnimals[findSlot][waID]);

            WildAnimals[findSlot][waID] = CreateNpc(AnimalsParam[WildAnimals[findSlot][waType]][0], AnimalX, AnimalY, AnimalZ);
            SetNpcStunAnimationEnabled(WildAnimals[findSlot][waID], false);
            SetNpcVirtualWorld(WildAnimals[findSlot][waID], 0);
            SetNpcHealth(WildAnimals[findSlot][waID], 100000);

            #pragma warning disable 202
            TaskNpcPlayAnimation(WildAnimals[findSlot][waID],"CRACK", "crckdeth2");

            WildAnimals[findSlot][waUnix] = gettime()+300;
            SetPlayerHudTask(damagerid, "Разделка туши животного", "Вы убили животного, подойдите к его трупу, возьмите в руку нож и нажмите [ ALT ] что бы разделать его");
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
            if(GetDistancePoint(AnimalX,AnimalY,AnimalZ,PcordX, PcordY, PcordZ) > 5.0) continue;
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
    SetPlayerChatBubble(playerid,"Разделывает тушу животного",COLOR_PURPLE,20.0,5000);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 3.0, false, true, true, false, false);
    if(getillness(playerid, 18) == -1) PlayerInfo[playerid][pMechSkill] --;
    update_ability(playerid, 4, 1);

    new ability = get_ability(playerid, 4);

    new chance = 100-WildAnimals[a][waBulletCount];
    if(ability >= 3 && ability <= 4) chance += 10;
    else if(ability >= 5 && ability <= 7) chance += 20;
    else if(ability >= 8 && ability <= 9) chance += 30;
    else if(ability >= 10) chance += 50;

    if(chance > 100) chance = 100;
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
    HidePlayerHudTask(playerid);
    DestroyAnimals(a),WildAnimals[a][waUnix] = gettime()+300,WildAnimalsArea[WildAnimals[a][waArea]][1] = 0; // Удаляем зверушку и ставим КД
    return true;
}

stock Pump_CarveAnimals(playerid)
{
	SetPVarInt(playerid, "oryjtemp", GetPVarInt(playerid, "oryjtemp") + 1 + random(3));
	if(GetPVarInt(playerid,"oryjtemp") >= 100)
	{
	 	GameTextForPlayer(playerid, RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Разделка туши: ~w~100/100"), 1500, 3);
        new a = GetPVarInt(playerid,"wildanimals");
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
 	return 1;
}

stock Pump_StartCarveAnimals(playerid, a)
{
    if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return 0;
    if(GetPVarInt(playerid, "Arobsklad") > 0) return 0;

    if(get_invent4(playerid, 97, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет ножа [ Купите его в супермаркете ]");
    if(Hold[playerid] != 14) return ErrorMessage(playerid, "{FF6347}Возьмите в руки нож, чтобы начать разделывать тушу [ N ]");
    
    SetPVarInt(playerid, "wildanimals", a), SetPVarInt(playerid, "oryjtemp", 0); SetPVarInt(playerid, "Arobsklad", 15);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Теперь мне нужно начать разделывать тушу {ff9000}[ Нажимайте %s ]", buttonName[Device[playerid]]);

    return 1;
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
    WildAnimals[a][waEvent] = 3;
    TaskNpcAttackPlayer(WildAnimals[a][waID], playerid, .aggressive = true);
    return true;
}
// MAX_PETS_AT_PLAYER - pears.pwn Кол-во загружаемых петов
#define MAX_PETS_TYPE 24 // Тип животинки
#define MAX_PETS_PARAM 2 // Кол-во параметров для животных
#define MAX_PETS 2000 // Общие кол-во питомцев на сервере

new PetsParam[MAX_PETS_TYPE][4] =
{   // Skin, HP, skin, может заспавнится как дикий
    { 15797, 50, 609, 0 },      // Волк
    { 15814, 50, 626, 0 },      // Кошка белая с зелеными глазами
    { 15815, 50, 627, 1 },      // Кошка рыжий с белой грудкой
    { 15816, 50, 628, 1 },      // Кошка Черно с серыми пятнами и белой грудкой
    { 15817, 50, 629, 0 },      // Кошка Сиамская
    { 15818, 50, 630, 1 },      // Кошка Серая с рыжими пятнами и белой грудкой
    { 15819, 50, 631, 0 },      // Кошка черная с желтыми глазами
    { 15820, 50, 632, 0 },      // Барбос типо питбуль коричнивый с пятнами 
    { 15821, 50, 633, 0 },      // Барбос типо питбуль светло-коричнивый
    { 15822, 50, 634, 0 },      // Барбос типо питбуль черный и коричнивыми пятнами
    { 15823, 50, 635, 0 },      // Чихуахуя белый
    { 15824, 50, 636, 0 },      // Барбос типо питбуль черный с кричнивыми
    { 15825, 50, 637, 0 },      // Чихуахуя черный
    { 15826, 50, 638, 0 },      // Барбос типо питбуль оранжевый с белой грудкой
    { 15827, 50, 639, 0 },      // Доберман черный с рыжими пятнами
    { 15828, 50, 640, 0 },      // Бультерьер серый с белой грудкой 
    { 15829, 50, 641, 1 },      // Барбос без хвоста серый с белой грудкой
    { 15830, 50, 642, 0 },      // Сибу-ину УПОРОТЫЙ
    { 15831, 50, 643, 1 },      // Мухтар
    { 15832, 50, 644, 0 },      // Барбас белый демон
    { 15833, 50, 645, 0 },      // Хаски?
    { 15834, 50, 646, 0 },      // Пудиль
    { 15835, 50, 647, 0 },      // Гончая
    { 15836, 50, 648, 0 }      // Долматинец
};

enum pet_TaskToNpc
{
    PET_TASK_ATTAC,
    PET_TASK_WALKING,
    PET_TASK_GOSEATCAR,
    PET_TASK_SEATCAR,
    PET_TASK_SEAT,
    PET_TASK_ATTACNPC,
    PET_TASK_AUTO,
    PET_TASK_SNIFF,
}; 

enum pet_Skills
{
    PET_SKILL_VOICE,
    PET_SKILL_ATTAC_PLAYER,
    PET_SKILL_ATTAC_NPC,
    PET_SKILL_FOLLOWME,
    PET_SKILL_SNIFF,
    PET_SKILL_SIT,
    PET_SKILL_SITCAR
};

enum petsnpc
{
	NPC:petID, // ID бота
    petPlayer, // playerid владельца
    petHunger, // Голод 
    petLevel, // Уровень
    petExp, // Экспулечка
    petPoint, // Очки прокачки
    petPower, // Сила
    petAgility, // Ловкость
    petEndurance, // Выносливость
    petFeatures[10], // Особенности питомца
    bool:petDestinationStatus, // Идет или пришел
    pet_TaskToNpc: petEvent,
    pet_Skills: petSkills[pet_Skills],
    petUnix, // Время убийства для деспавна
    petType, // Тип животного
    petAttactID, // Кого атакует
    NPC:petAttactNpcID, // Кого атакует из NPC
    bool:petStartAttactNpcID, // Тумблер
    bool:petStartAttactID, // Тумблер
    petKillerID, // кто убил
    Float:petHealth, // ХПшка
    Float:petTaskCoord[3], // Куда идет NPC
    petSoundUnix, // Кд на звук
    petAnim, // Анимка
    petVehicle, // Машина куда должен сесть NPC
    bool:petAuto // Для автотаски
}
new PetInfo[MAX_PETS][petsnpc];

stock FindPet(thingid)
{
    new result = -1;
    for(new i; i< MAX_PETS_TYPE; i++)
    {
        if(thingid == PetsParam[i][2])
        {
            result = i;
            break;
        }
    }
    return result;
}

stock CreatePet(playerid, pet, petSkin)
{
    if(IsValidNpc(PetInfo[pet][petID])) return false;
    new Float:PetX, Float:PetY, Float:PetZ = 50;
    GetPlayerPos(playerid,PetX,PetY,PetZ);
    CA_FindZ_For2DCoord(PetX,PetY,PetZ);
    PetZ += 1.5;

    new PetParam = FindPet(petSkin);
    if(PetParam == -1) return ErrorMessage(playerid,"{ff6347}Данный питомец не найден в списке питомцев");

    PetInfo[pet][petPlayer] = playerid;
    PetInfo[pet][petAttactID] = INVALID_PLAYER_ID;
    PetInfo[pet][petAttactNpcID] = INVALID_NPC;
    PetInfo[pet][petKillerID] = INVALID_PLAYER_ID;
    PetInfo[pet][petType] = PetParam;
    PetInfo[pet][petUnix] = 0;
    PetInfo[pet][petAnim] = 0;
    PetInfo[pet][petSoundUnix] = 0;
    PetInfo[pet][petAuto] = false;
    PetInfo[pet][petEvent] = pet_TaskToNpc:PET_TASK_WALKING;
    PetInfo[pet][petID] = CreateNpc(PetsParam[PetInfo[pet][petType]][0], PetX + 0.5, PetY + 0.5, PetZ);
    PetInfo[pet][petHealth] = float(PetsParam[PetInfo[pet][petType]][1]);
    SetNpcStunAnimationEnabled(PetInfo[pet][petID], true);
    SetNpcVirtualWorld(PetInfo[pet][petID], GetPlayerVirtualWorld(playerid));
    SetNpcHealth(PetInfo[pet][petID], PetInfo[pet][petHealth]);

    return true;
}

stock DestroyPet(playerid, slotpet)
{
    if(OnlineInfo[playerid][oPet][slotpet] == -1) return ErrorMessage(playerid, "{ff6347}У меня не загружен данный питомец");
    new pet = OnlineInfo[playerid][oPet][slotpet];
    OnlineInfo[playerid][oPet][slotpet] = -1;
    OnlineInfo[playerid][oPetID][slotpet] = -1;

    if(IsValidNpc(PetInfo[pet][petID])) DestroyNpc(PetInfo[pet][petID]);

    return true;
}

stock LifePet(pet)
{
    if(!IsValidNpc(PetInfo[pet][petID])) return 0;
    
    new Float:PetX, Float:PetY, Float:PetZ = 50;
    GetNpcPosition(PetInfo[pet][petID],PetX,PetY,PetZ);

    new Float: PcordX, Float: PcordY, Float: PcordZ;
    GetPlayerPos(PetInfo[pet][petPlayer],PcordX,PcordY,PcordZ);
    GetNpcHealth(PetInfo[pet][petID],PetInfo[pet][petHealth]);
    if(PetInfo[pet][petHealth] <= 0.0) return 0;
    if((PetInfo[pet][petEvent] == PET_TASK_AUTO || PetInfo[pet][petAuto]) && PetInfo[pet][petEvent] != PET_TASK_ATTACNPC && PetInfo[pet][petEvent] != PET_TASK_ATTAC)
    {
        if(!IsNpcInAnyVehicle(PetInfo[pet][petID]) && IsPlayerInAnyVehicle(PetInfo[pet][petPlayer])) HandlerCreateTaskPets(pet, PET_TASK_GOSEATCAR);
        else if(IsNpcInAnyVehicle(PetInfo[pet][petID]) && IsPlayerInAnyVehicle(PetInfo[pet][petPlayer])) HandlerCreateTaskPets(pet,PET_TASK_SEATCAR);
        else if(IsNpcInAnyVehicle(PetInfo[pet][petID]) && !IsPlayerInAnyVehicle(PetInfo[pet][petPlayer])) HandlerCreateTaskPets(pet,PET_TASK_WALKING);
        else 
        {
            if(PetInfo[pet][petEvent] != PET_TASK_WALKING) HandlerCreateTaskPets(pet,PET_TASK_WALKING);
        }
    }
    if(PetInfo[pet][petEvent] == PET_TASK_SEAT) // Приказали сидеть
    {
        if(!PetInfo[pet][petAnim])
        {
            TaskNpcStandStill(PetInfo[pet][petID]);
            TaskNpcPlayAnimation(PetInfo[pet][petID],"PED", "WEAPON_CROUCH", 4.1, true, false, false, true, 0), PetInfo[pet][petAnim] = 1;
        }
    }
    if(PetInfo[pet][petEvent] == PET_TASK_WALKING) // Прогулка
    {
        if(GetDistanceBetweenPoints2D(PetX, PetY, PcordX, PcordY) <= 10.0)
        {
            PetInfo[pet][petDestinationStatus] = true;
            if(!PetInfo[pet][petAnim])
            {
                TaskNpcStandStill(PetInfo[pet][petID]);
                TaskNpcPlayAnimation(PetInfo[pet][petID],"PED", "WEAPON_CROUCH", 4.1, true, false, false, true, 0), PetInfo[pet][petAnim] = 1;
            }
        }
        else if(PetInfo[pet][petDestinationStatus]) TaskNpcFollowPlayer(PetInfo[pet][petID], PetInfo[pet][petPlayer]), PetInfo[pet][petAnim] = 0;
    }
    if(PetInfo[pet][petEvent] == PET_TASK_ATTAC) // Атакует
    {
        if(!IsOnline(PetInfo[pet][petAttactID])) PetInfo[pet][petAttactID] = INVALID_PLAYER_ID;
        if(PetInfo[pet][petAttactID] == INVALID_PLAYER_ID || GetPlayerState(PetInfo[pet][petAttactID]) != PLAYER_STATE_ONFOOT || DeathInfo[PetInfo[pet][petAttactID]][deathStatus]) HandlerCreateTaskPets(pet, PET_TASK_WALKING);
        else{
            GetPlayerPos(PetInfo[pet][petAttactID],PcordX,PcordY,PcordZ);
            if(GetDistancePoint(PetX,PetY,PetZ,PcordX, PcordY, PcordZ) >= 100 || GetPlayerState(PetInfo[pet][petAttactID]) == PLAYER_STATE_SPECTATING) HandlerCreateTaskPets(pet, PET_TASK_WALKING), PetInfo[pet][petAttactID] = INVALID_PLAYER_ID;
            if(!PetInfo[pet][petStartAttactID]) TaskNpcAttackPlayer(PetInfo[pet][petID], PetInfo[pet][petAttactID], true), PetInfo[pet][petStartAttactID] = true;
        }
    }
    if(PetInfo[pet][petEvent] == PET_TASK_GOSEATCAR) // Топает в машину
    {
        new Float:VehX,Float:VehY,Float:VehZ;
        GetVehiclePos(PetInfo[pet][petVehicle],VehX,VehY,VehZ);
        if(GetDistanceBetweenPoints2D(PetX, PetY, VehX, VehY) > 100.0) HandlerCreateTaskPets(pet, PET_TASK_WALKING);
        else {
            TaskNpcGoToPoint(PetInfo[pet][petID], VehX,VehY,VehZ);
        }
        if(GetDistanceBetweenPoints2D(PetX, PetY, VehX, VehY) < 4.0) 
        {
            TaskNpcStandStill(PetInfo[pet][petID]);
            PetTaskSeatInCar(pet); 
        }
    }
    if(PetInfo[pet][petEvent] == PET_TASK_SEATCAR)
    {
        if(GetNpcVehicleID(PetInfo[pet][petID]) != GetPlayerVehicleID(PetInfo[pet][petPlayer])) HandlerCreateTaskPets(pet, PET_TASK_WALKING),RemoveNpcFromVehicle(PetInfo[pet][petID]);
    }
    if(PetInfo[pet][petEvent] == PET_TASK_ATTACNPC)
    {
        if(!PetInfo[pet][petStartAttactNpcID]) TaskNpcStandStill(PetInfo[pet][petID]);
        new Float:tempHealth;
        if(IsValidNpc(PetInfo[pet][petAttactNpcID])) GetNpcHealth(PetInfo[pet][petAttactNpcID],tempHealth);
        if(!IsValidNpc(PetInfo[pet][petAttactNpcID]) || tempHealth <= 0.0) return HandlerCreateTaskPets(pet, PET_TASK_WALKING);
        if(!PetInfo[pet][petStartAttactNpcID]) TaskNpcAttackNpc(PetInfo[pet][petID], PetInfo[pet][petAttactNpcID], true), PetInfo[pet][petStartAttactNpcID] = true;
    }
    if(PetInfo[pet][petEvent] == PET_TASK_SNIFF)
    {
        new tempUser = PetTaskGoFindSniffTarget(pet);
        if(tempUser != -1)
        {
            PlayAudioStreamForPlayer(PetInfo[pet][petPlayer], "https://cdn.pears.fun/sound/animals/bear/bear_attack0.mp3",PetX, PetY, PcordX, 30.0, true);
        }
        HandlerCreateTaskPets(pet,PET_TASK_WALKING);
    }
    return true;
}

stock HandlerCreateTaskPets(pet, pet_TaskToNpc: type, targetid = INVALID_PLAYER_ID, NPC:targetidNpc = INVALID_NPC)
{
    if(!IsValidNpc(PetInfo[pet][petID])) return false;
    TaskNpcStandStill(PetInfo[pet][petID]);
    switch(type)
    {
        case PET_TASK_ATTAC:
        {
            PetInfo[pet][petAttactID] = targetid;
            PetInfo[pet][petEvent] = PET_TASK_ATTAC;
            PetInfo[pet][petStartAttactID] = false;
        }
        case PET_TASK_WALKING:
        {
            PetInfo[pet][petEvent] = PET_TASK_WALKING;
            PetInfo[pet][petDestinationStatus] = false;
            PetInfo[pet][petAttactNpcID] = INVALID_NPC;
            PetInfo[pet][petVehicle] = INVALID_VEHICLE_ID;
            PetInfo[pet][petAttactID] = INVALID_PLAYER_ID;
            PetInfo[pet][petStartAttactNpcID] = false;
            PetInfo[pet][petStartAttactID] = false;
            if(IsNpcInAnyVehicle(PetInfo[pet][petID])) RemoveNpcFromVehicle(PetInfo[pet][petID]);
        }
        case PET_TASK_GOSEATCAR:
        {
            PetInfo[pet][petVehicle] = GetPlayerVehicleID(PetInfo[pet][petPlayer]);
            PetInfo[pet][petEvent] = PET_TASK_GOSEATCAR;
        }
        case PET_TASK_SEATCAR:
        {
            PetInfo[pet][petVehicle] = GetPlayerVehicleID(PetInfo[pet][petPlayer]);
            PetInfo[pet][petEvent] = PET_TASK_SEATCAR;
        }
        case PET_TASK_SEAT:
        {
            PetInfo[pet][petEvent] = PET_TASK_SEAT;
            PetInfo[pet][petDestinationStatus] = false;
            PetInfo[pet][petAttactNpcID] = INVALID_NPC;
            PetInfo[pet][petVehicle] = INVALID_VEHICLE_ID;
            PetInfo[pet][petAttactID] = INVALID_PLAYER_ID;
            PetInfo[pet][petStartAttactNpcID] = false;
            PetInfo[pet][petAnim] = 0;
        }
        case PET_TASK_ATTACNPC:
        {
            PetInfo[pet][petEvent] = PET_TASK_ATTACNPC;
            PetInfo[pet][petAttactNpcID] = targetidNpc;
            PetInfo[pet][petStartAttactNpcID] = false;
        }
        case PET_TASK_AUTO:
        {
            PetInfo[pet][petEvent] = PET_TASK_AUTO;
        }
        case PET_TASK_SNIFF:
        {
            PetInfo[pet][petEvent] = PET_TASK_SNIFF;
        }
    }
    return true;
}

stock LoadPlayerPet(playerid,slotpet, petId)
{
    if(OnlineInfo[playerid][oPet][slotpet] != -1) return ErrorMessage(playerid, "{ff6347}У меня уже есть загруженный питомец!");
    for(new pet = 0; pet < MAX_PETS; pet++)
    {
        if(IsValidNpc(PetInfo[pet][petID])) continue;
        OnlineInfo[playerid][oPet][slotpet] = pet;
        OnlineInfo[playerid][oPetID][slotpet] = petId;
        CreatePet(playerid,pet,petId);
        break;
    }
    return true;
}

CMD:mypets(playerid)
{
    dialogPetsList(playerid);
    return true;
}

stock PetTaskGoSeatInCar(playerid,pet)
{
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Я не сижу в транспорте что бы позвать питомца к себе!");
    if(!IsAFarNpcToPlayer(pet)) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Питомец далеко, и не может получить команду!");
    HandlerCreateTaskPets(pet, PET_TASK_GOSEATCAR);
    return true;
}

stock PetTaskAttacNPC(pet, NPC:npc)
{
    if(PetInfo[pet][petEvent] == PET_TASK_ATTACNPC || PetInfo[pet][petID] == npc || !PetInfo[pet][petAuto]) return false;
    HandlerCreateTaskPets(pet, PET_TASK_ATTACNPC, INVALID_PLAYER_ID, npc);
    return true;
}

stock PetTaskSeatInCar(pet)
{
    new veh = PetInfo[pet][petVehicle];
    new seats_count,model = VehInfo[veh][vModel], empty_seatid = -1, bool: occupied_seats[3 + 1];

    seats_count = GetVehicleMaxPassengers(GetVehModelOriginal(model));
    if (seats_count >= 1 && seats_count <= 3)
    {
        foreach(Player, i)
        {
            if (GetPlayerVehicleID(i) != veh) continue;

            for (new seatid = 1; seatid <= seats_count; seatid++) {
                if (GetPlayerVehicleSeat(i) == seatid) {
                    occupied_seats[seatid] = true;
                    break;
                }
            }
        }
        for (new i; i < MAX_PETS; i++)
        {
            if(!IsValidNpc(PetInfo[i][petID])) continue;
            if(!IsNpcInAnyVehicle(PetInfo[i][petID])) continue;
            if(GetNpcVehicleID(PetInfo[i][petID]) != veh) continue;
            for (new seatid = 1; seatid <= seats_count; seatid++) {
                if (GetNpcVehicleSeat(PetInfo[i][petID]) == seatid) {
                    occupied_seats[seatid] = true;
                    break;
                }
            }
        }
        for (new seatid = seats_count; seatid >= 1; seatid--) {
            if (!occupied_seats[seatid]) {
                empty_seatid = seatid;
                break;
            }
        }
    }

    if(empty_seatid == -1) HandlerCreateTaskPets(pet, PET_TASK_WALKING);
    else HandlerCreateTaskPets(pet, PET_TASK_SEATCAR);
    PutNpcInVehicle(PetInfo[pet][petID],veh,empty_seatid);
    return true;
}

stock IsAFarNpcToPlayer(pet)
{
    new Float:PetX, Float:PetY, Float:PetZ;
    GetNpcPosition(PetInfo[pet][petID],PetX,PetY,PetZ);

    new Float: PcordX, Float: PcordY, Float: PcordZ;
    GetPlayerPos(PetInfo[pet][petPlayer],PcordX,PcordY,PcordZ);

    if(GetDistanceBetweenPoints2D(PetX, PetY, PcordX, PcordY) > 10.0) return 0;
    if(GetNpcVirtualWorld(PetInfo[pet][petID]) != GetPlayerVirtualWorld(PetInfo[pet][petPlayer])) return 0;
    
    TaskNpcGoToPoint(PetInfo[pet][petID],PcordX,PcordY,PcordZ, NPC_MOVE_MODE_RUN);

    return 1;
}

stock IsAPetExisting(pet)
{
    if(pet == 609 || pet >= 626 && pet <= 648) return 1;
    return 0;
}

stock dialogPetsList(playerid)
{
	new line[100],lines[4000];
	format(line,sizeof(line),"{ffcc00}Название \t {444444}ID"), strcat(lines,line);

    ClearList(playerid);

	new quan, temptext[10];
	for(new i = 0; i < 40; i++)
	{
        if(PlayerInfo[playerid][pInven][i] == 0 || PlayerInfo[playerid][pInvenType][i] != 6) continue;
        format(temptext, 10, "{cccccc}");
        for(new pet = 0; pet < MAX_PETS_AT_PLAYER; pet++)
        {
            if(OnlineInfo[playerid][oPetID][pet] == PlayerInfo[playerid][pInven][i]) 
            {
                format(temptext, 10, "{ff9000}");
                ListParam[quan][playerid] = pet+1;
                break;
            }
        }
        format(line,sizeof(line),"\n%s%d. %s \t[%d]",temptext, quan + 1, GetSkinName(PlayerInfo[playerid][pInven][i]), PlayerInfo[playerid][pInvenPara][i]), strcat(lines,line);
        List[quan][playerid] = i;
        quan ++;
        if(quan > 20) return ErrorMessage(playerid,"{ff6347}У вас в инвентаре больше 20 питомцев! Загрузка прервана");
	}
    if(quan == 0) return ErrorMessage(playerid,"{ff6347}У меня нет питомцев в инвентаре. Питомцы станут доступны после нового года");
    ShowDialog(playerid,PETS_SHOW_LIST,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Мои питомцы",lines,"Выбрать","Отмена");
    return true;
}

stock dialogPetMenagment(playerid,slot)
{
    new pet = OnlineInfo[playerid][oPet][slot];
    DP[0][playerid] = slot;
    new type = PetInfo[pet][petType];

	new lines[500], string[60];
	format(lines,sizeof(lines),"{ff9000}Питомец: %s\t Голод: %d"\
                                "\n{ff9000}Уровень {99ff66}%d\t{cccccc}Опыт [ {99ff66}%d{cccccc}/1000 ]"\
                                "\n{0088ff}Выгрузить питомца\t "\
                                "\n{0088ff}Команды питомцу\t "\
								"\n{0088ff}Всегда следовать за мной %s\t ",
                                GetSkinName(PetsParam[type][2]), PetInfo[pet][petHunger],
                                PetInfo[pet][petLevel],PetInfo[pet][petExp],
                                PetInfo[pet][petAuto] ? "{44ff99} [ On ]" : "{ff6347}[ Off ]");
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE,DIALOG_STYLE_TABLIST_HEADERS, string, lines, "Принять", "Отмена");
	return true;
}

stock dialogPetInformation(playerid,pet)
{
	new lines[1024], string[60];
	format(lines,sizeof(lines),"{ff9000}Уровень {99ff66}%d\t{cccccc}Опыт [ {99ff66}%d{cccccc}/1000 ]\tОчков прокачки: %d"\
                                "\nОсобенности питомца\t \t"\
                                "\n{0088ff}Сила\t \t{cccccc}%d"\
                                "\n{0088ff}Ловкость\t \t{cccccc}%d"\
                                "\n{0088ff}Выносливость\t \t{cccccc}%d"\
								"\n{0088ff}Прокачка навыков питомца\t ",
                                PetInfo[pet][petLevel],PetInfo[pet][petExp], PetInfo[pet][petPoint],
                                PetInfo[pet][petPower],PetInfo[pet][petAgility], PetInfo[pet][petEndurance]);
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE_INFORMATION,DIALOG_STYLE_TABLIST_HEADERS, string, lines, "Принять", "Отмена");
	return true;
}

stock dialogPetCreateTask(playerid,slot)
{
    new pet = OnlineInfo[playerid][oPet][slot];
    DP[0][playerid] = slot;
    new type = PetInfo[pet][petType];

	new lines[500], string[60];
	format(lines,sizeof(lines),"{ff9000}Питомец: %s \t Доступность навыка \t "\
                                "\n{0088ff}Голос\t%s\t%s"\
                                "\n{0088ff}Фас на игрока\t%s\t%s"\
                                "\n{0088ff}Фас на NPC\t%s\t%s"\
                                "\n{0088ff}За мной\t%s\t%s"\
                                "\n{0088ff}Принюхивайся\t%s\t%s"\
								"\n{0088ff}Жди здесь\t%s\t%s"\
                                "\n{0088ff}Садись в машину\t%s\t%s",
                                GetSkinName(PetsParam[type][2]),
                                PetInfo[pet][petSkills][PET_SKILL_VOICE] ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petUnix] ? "{44ff99}Выполняет" : "", 
                                PetInfo[pet][petSkills][PET_SKILL_ATTAC_PLAYER] ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petEvent] == PET_TASK_ATTAC ? "{44ff99}Выполняет" : "", 
                                PetInfo[pet][petSkills][PET_SKILL_ATTAC_NPC] ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petEvent] == PET_TASK_ATTACNPC ? "{44ff99}Выполняет" : "", 
                                PetInfo[pet][petSkills][PET_SKILL_FOLLOWME] ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petEvent] == PET_TASK_WALKING ? "{44ff99}Выполняет" : "", 
                                PetInfo[pet][petSkills][PET_SKILL_SNIFF] ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petEvent] == PET_TASK_SNIFF ? "{44ff99}Выполняет" : "", 
                                PetInfo[pet][petSkills][PET_SKILL_SIT] ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petEvent] == PET_TASK_SEAT ? "{44ff99}Выполняет" : "", 
                                PetInfo[pet][petSkills][PET_SKILL_SITCAR] ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petEvent] == PET_TASK_SEATCAR ? "{44ff99}Выполняет" : "");
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE_TASK,DIALOG_STYLE_TABLIST_HEADERS, string, lines, "Принять", "Отмена");
	return true;
}

CMD:givepet(playerid, const params[]) // Выдать питомца в инвентарь
{
	if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 15+ ]");
	new tmp[34], giveplayerid;
	if(sscanf(params, "s[34]i",tmp,params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать питомца /givepet [ID] [ID питомца]");
	if(!IsAPetExisting(params[1])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID питомца [ Доступные: 609, 626 - 648 ]");
	giveplayerid = ReturnUser(tmp, 1);

	if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети или он не залогинился");
    
    new put_inva = GiveThingPlayer(giveplayerid, params[1], 1, 0, 0, 6, 0, 9999);
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре");

	new string[100];
    format(string, sizeof(string), "Администратор %s выдал вам питомца %s[ %d ]", PlayerInfo[playerid][pName],GetSkinName(params[1]), params[1]);
    SendClientMessage(giveplayerid, COLOR_WHITE, string);
    format(string, sizeof(string), "Вы выдали %s питомца %s[ %d ]", PlayerInfo[giveplayerid][pName],GetSkinName(params[1]),params[1]);
    SendClientMessage(playerid, COLOR_WHITE, string);
    AdminLog("givepet", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], params[1], "");
	return 1;
}

stock dialogCase_Pets(playerid, dialogid, response, listitem) {
    switch (e_DialogId: dialogid) {
        case PETS_SHOW_LIST: {
            if(!response) return true;
            new loadtype = ListParam[listitem][playerid];
            if(loadtype != 0) return dialogPetMenagment(playerid,loadtype-1);
            else 
            {
                new inva = List[listitem][playerid], bool:yes;
                for(new pet = 0; pet < MAX_PETS_AT_PLAYER; pet++)
                {
                    if(OnlineInfo[playerid][oPetID][pet] != -1) continue;
                    LoadPlayerPet(playerid, pet, PlayerInfo[playerid][pInven][inva]);
                    yes = true;
                    break;   
                }
                if(!yes) return ErrorMessage(playerid,"{ff6347}У меня нет слотов для загрузки питомцев!");
            }
        }
        case PETS_SHOW_PETMANAGE: {
            if(!response) dialogPetsList(playerid);
            else 
            {
                new slot = DP[0][playerid];
                new pet = OnlineInfo[playerid][oPet][slot];
                if(listitem == 0) dialogPetInformation(playerid, pet);
                if(listitem == 1) DestroyPet(playerid,slot);
                if(listitem == 2) dialogPetCreateTask(playerid,slot);
                if(listitem == 3) 
                {
                   if(!PetInfo[pet][petAuto]) HandlerCreateTaskPets(pet, PET_TASK_AUTO), PetInfo[pet][petAuto] = true;
                   else HandlerCreateTaskPets(pet, PET_TASK_WALKING), PetInfo[pet][petAuto] = false;
                }
            }
        }
        case PETS_SHOW_PETMANAGE_TASK: {
            new slot = DP[0][playerid];
            new pet = OnlineInfo[playerid][oPet][slot];
            if(!response) dialogPetMenagment(playerid,slot);
            switch(listitem)
            {
                case 0: PlayAudioStreamForPlayer(playerid,"https://cdn.pears.fun/sound/characters/maniac/screamer0.mp3");
                case 1..2: HandlerCreateTaskPets(pet, PET_TASK_AUTO), PetInfo[pet][petAuto] = true;// Фас на игрока/NPC включаем режим авто, на атаку игрока
                case 3: HandlerCreateTaskPets(pet,PET_TASK_WALKING);// идти за мной
                case 4: HandlerCreateTaskPets(pet,PET_TASK_SNIFF); // принюхаться
                case 5: HandlerCreateTaskPets(pet,PET_TASK_SEAT);// сидеть на месте
                case 6: PetTaskGoSeatInCar(playerid,pet);// сидеть на месте
                default: dialogPetMenagment(playerid,slot);
            }
        }
        case PET_CREATETASK_ATTAC: {
            if(!response) show_interaction(playerid, Moiplayer[playerid]);
            new pet = OnlineInfo[playerid][oPet][listitem];
            HandlerCreateTaskPets(pet, PET_TASK_ATTAC, Moiplayer[playerid]);
        }
        case PET_CREATETASK_SNIFF: {
            if(!response) show_interaction(playerid, Moiplayer[playerid]);
            new pet = OnlineInfo[playerid][oPet][listitem];
            if(PetSniffPlayer(Moiplayer[playerid]) > 0) SendClientMessage(playerid,COLOR_GRAY,"[ Мысли ] Кажется питомец что-то учуял у %s",rpplayername(Moiplayer[playerid]));
            else SendClientMessage(playerid,COLOR_GRAY,"[ Мысли ] Питомец ничего не чует у %s",rpplayername(Moiplayer[playerid]));
        }
        case PETS_SHOW_PETMANAGE_INFORMATION: {
            new slot = DP[0][playerid];
            new pet = OnlineInfo[playerid][oPet][slot];
            if(!response) dialogPetMenagment(playerid,slot);
        }
    }
    return false;
}

stock GetPlayerLoadPet(playerid)
{
    new quan = 0;
	for(new pet = 0; pet < MAX_PETS_AT_PLAYER; pet++)
	{
		if(OnlineInfo[playerid][oPet][pet] != -1) 
		{
            quan++;
		}
	}
    if(quan > 0) return quan;
    else return false;
}

stock ListPlayerLoadPet(playerid,type)
{
    new line[100],lines[100*MAX_PETS_AT_PLAYER];
    new quan = 0;
	for(new pet = 0; pet < MAX_PETS_AT_PLAYER; pet++)
	{
		if(OnlineInfo[playerid][oPet][pet] != -1) 
		{
            format(line,sizeof(line),"{cccccc}%d. %s\n", quan + 1, GetSkinName(PetsParam[PetInfo[OnlineInfo[playerid][oPet][pet]][petType]][2])), strcat(lines,line);
			List[quan][playerid] = pet+1;
            quan ++;
		}
	}
    if(quan == 0) return false;
    if(type == 0) ShowDialog(playerid,PET_CREATETASK_ATTAC,DIALOG_STYLE_TABLIST,"{ff9000}Выберите питомца для атаки",lines,"Выбрать","Отмена");
    else if(type == 1) ShowDialog(playerid,PET_CREATETASK_SNIFF,DIALOG_STYLE_TABLIST,"{ff9000}Выберите питомца для атаки",lines,"Выбрать","Отмена");
    return true;
}

stock PetSniffPlayer(playerid)
{
    new drugfind = 0;
    
    for(new i = 4; i < 8; i++)
    {
        if(i == 5) continue;
        drugfind = get_drugs_and_backpack(playerid, i);
        if(drugfind) break;
    }

    return drugfind;
}

stock PetTaskGoFindSniffTarget(pet)
{
    new Float:PetX = 0.0, Float:PetY = 0.0, Float:PetZ = 0.0, PetWorld = GetNpcVirtualWorld(PetInfo[pet][petID]), PetFind = -1;
    GetNpcPosition(PetInfo[pet][petID],PetX,PetY,PetZ);
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 0) continue;
        if(IsPlayerInRangeOfPoint(i,10.0,PetX,PetY,PetZ) && GetPlayerVirtualWorld(i) == PetWorld)
        {
            if(i == PetInfo[pet][petPlayer]) continue;
            if(PetSniffPlayer(i) > 0)
            {
                PetFind = i;
                break;
            }
        }
    }
    return PetFind;
}
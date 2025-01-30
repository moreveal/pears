// MAX_PETS_AT_PLAYER - pears.pwn Кол-во загружаемых петов
#define MAX_PETS_TYPE 24 // Тип животинки
#define MAX_PETS_PARAM 2 // Кол-во параметров для животных
#define MAX_PETS 2000 // Общие кол-во питомцев на сервере

new PlayingWithPetProcessTime[MAX_REALPLAYERS];
new bool: PlayingWithPetProcessTimers[MAX_REALPLAYERS];
new PlayingWithPetObject[MAX_REALPLAYERS];
new PlayingWithPetObjectTimer[MAX_REALPLAYERS];

new PetsParam[MAX_PETS_TYPE][4] =
{   // Skin, HP, skin, может заспавнится как дикий
    { 15797, 100, 609, 0 },      // Волк
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

new PetsFeaturesName[][] =
{
    "Грязные когти", // 0
    "Сточеные зубы", // 1
    "Быстрые лапки", // 2
    "Острый нюх", // 3
    "Громкий голос" // 4
};

new PetsFeaturesSetting[sizeof(PetsFeaturesName)][2] =
{
    // 1 - Rare, 2 - Count
    { 0, 1},        // 0 
    { 1, 1},        // 1
    { 2, 3},        // 2
    { 1, 3},         // 3
    { 0, 25}         // 4
};

new PetsFeaturesColor[][] =
{
    "{D2B48C}",
    "{54FF9F}",
    "{D93A49}"
};

new PetsFeaturesDescription[][] =
{
    "Заражает (ТОЛЬКО ИГРОКА) болезнью Акне"\
    "   \n- Заражение не дает эффекта сразу, болезнь будет прогрессировать со временем"\
    "   \n- Эффект данной особенности означает какой шанс на заражение", // 0
    "Урон питомца повышается по игроку/NPC"\
    "   \n- Повышает базовый урон питомца по игроку/NPC в процентах", // 1
    "Питомец уворачивается от пуль"\
    "   \n- Эффект данной особенности это шанс с которого ваш питомец не получит урона", // 2
    "Раз в час может найти какой-то предмет на земле"\
    "   \n- Эффект данной особенности означает шанс на успешную находку предмета", // 3
    "Оглушения проходят быстрее"\
    "   \n- Эффект данной особенности - это на сколько времени сокращается длительность оглушения" // 4
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
    PET_TASK_PLAYING
}; 

enum pet_Skills
{
    PET_SKILL_INVALID,
    PET_SKILL_VOICE,
    PET_SKILL_ATTAC,
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
    petDonateFeatures, // кол-во купленных слотов
    bool:petDestinationStatus, // Идет или пришел
    pet_TaskToNpc: petEvent,
    petSkills[pet_Skills:pet_Skills],
    petUnix, // Время убийства для деспавна
    petPlayingUnix, // Юникс для игры
    petUnixLastEating, // Последнее время кормежки
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
    PetInfo[pet][petSkills][PET_SKILL_FOLLOWME] = 10;
    PetInfo[pet][petUnix] = 0;
    PetInfo[pet][petAnim] = 0;
    PetInfo[pet][petSoundUnix] = 0;
    PetInfo[pet][petHunger] = 100;
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
    GetHungryPet(pet);
    if(PetInfo[pet][petHunger] <= 0)
    {
        SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY, "[ Мысли ]: Я забыл покормить своего питомца, и кажется он умер...");
        for(new i = 0; i < MAX_PETS; i++)
        {
            if(OnlineInfo[PetInfo[pet][petPlayer]][oPet][i] == pet) return DestroyPet(pet,i);
        }
    }
    if((PetInfo[pet][petEvent] == PET_TASK_AUTO || PetInfo[pet][petAuto]) && PetInfo[pet][petEvent] != PET_TASK_ATTACNPC && PetInfo[pet][petEvent] != PET_TASK_ATTAC)
    {
        if(!IsNpcInAnyVehicle(PetInfo[pet][petID]) && IsPlayerInAnyVehicle(PetInfo[pet][petPlayer]) && PetInfo[pet][petSkills][PET_SKILL_SITCAR] == 10) HandlerCreateTaskPets(pet, PET_TASK_GOSEATCAR);
        else if(IsNpcInAnyVehicle(PetInfo[pet][petID]) && IsPlayerInAnyVehicle(PetInfo[pet][petPlayer]) && PetInfo[pet][petSkills][PET_SKILL_SITCAR] == 10) HandlerCreateTaskPets(pet,PET_TASK_SEATCAR);
        else if(IsNpcInAnyVehicle(PetInfo[pet][petID]) && !IsPlayerInAnyVehicle(PetInfo[pet][petPlayer]) && PetInfo[pet][petSkills][PET_SKILL_FOLLOWME] == 10) HandlerCreateTaskPets(pet,PET_TASK_WALKING);
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
        else SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Питомец принюхался и ничего не учаял");
        HandlerCreateTaskPets(pet,PET_TASK_WALKING);
    }
    if(PetInfo[pet][petEvent] == PET_TASK_PLAYING)
    {
        if(DP[0][PetInfo[pet][petPlayer]] <= 3 && !PetInfo[pet][petDestinationStatus])
        {
            new Float:PcordA;
            GetPlayerFacingAngle(PetInfo[pet][petPlayer], PcordA);

            new Float:x=PcordX+5.0*floatsin(-PcordA,degrees);
            new Float:y=PcordY+5.0*floatcos(-PcordA,degrees);
            PcordA = atan2(PetY - y, PetX-x) + 90.0;

            SetNpcFacingAngle(PetInfo[pet][petID], PcordA);

            TaskNpcGoToPoint(PetInfo[pet][petID], x, y, PetZ, NPC_MOVE_MODE_RUN);
            PetInfo[pet][petDestinationStatus] = true;
        }
        else TaskNpcGoToPoint(PetInfo[pet][petID],  PcordX, PcordY,PcordZ, NPC_MOVE_MODE_RUN), PetInfo[pet][petDestinationStatus] = false;
    }
    return true;
}

stock CheckTaskValid(pet, pet_TaskToNpc: PetTask, bool: msg = true)
{
    new pet_Skills:typeSkill = PET_SKILL_INVALID;
    if(PetTask == PET_TASK_ATTAC || PetTask == PET_TASK_ATTACNPC) {
            typeSkill = PET_SKILL_ATTAC;
    }
    else if(PetTask == PET_TASK_WALKING) {
            typeSkill = PET_SKILL_FOLLOWME;
    }
    else if(PetTask == PET_TASK_GOSEATCAR || PetTask == PET_TASK_SEATCAR) {
            typeSkill = PET_SKILL_SITCAR;
    }
    else if(PetTask == PET_TASK_SEAT) {
            typeSkill = PET_SKILL_SIT;
    }
    else if(PetTask == PET_TASK_SNIFF) {
            typeSkill = PET_SKILL_SNIFF;
    }
    if(typeSkill == PET_SKILL_INVALID) return false;
    if(PetInfo[pet][petSkills][typeSkill] < 10 && msg) 
    {
        SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY, "[ Мысли ]: Мой питомец не умеет выполнять данную команду [ Требуется открытие навыка ]");
        dialogPetCreateTask(PetInfo[pet][petPlayer], DP[0][PetInfo[pet][petPlayer]]);
        return false;
    }
    else return true;
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
        case PET_TASK_PLAYING:
        {
            PetInfo[pet][petEvent] = PET_TASK_PLAYING;
            PetInfo[pet][petAuto] = false;
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

CMD:petgivepoint(playerid)
{
    new pet = OnlineInfo[playerid][oPet][0];
    PetInfo[pet][petPoint] = 100;
    return true;
}

CMD:mypets(playerid)
{
    dialogPetsList(playerid);
    return true;
}

stock GetHungryPet(pet)
{
    if(PetInfo[pet][petHunger] <= 0) return false, PetInfo[pet][petHunger] = 0;
    new tempUnix = PetInfo[pet][petUnixLastEating] - gettime();
    if(tempUnix < 0) return false;
    new GetHungryInTenMinuts = tempUnix/600;
    if(GetHungryInTenMinuts > 0 && PetInfo[pet][petHunger] > 0) PetInfo[pet][petUnixLastEating] = gettime()+600, PetInfo[pet][petHunger] -= GetHungryInTenMinuts;
    if(PetInfo[pet][petHunger] < 0) PetInfo[pet][petHunger] = 0;
    return true;
}
stock PetTaskGoPlaying(playerid,pet)
{
    if(!IsAFarNpcToPlayer(pet)) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Питомец далеко, и не может получить команду!");
    if(PetInfo[pet][petPlayingUnix] > gettime()) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Питомец не хочет играть в данный момент. Поиграть можно будет через %s минут", fine_time(PetInfo[pet][petPlayingUnix] - gettime()));
    if(PetInfo[pet][petHunger] < 50) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Питомец сильно голоден, и не может получить команду!");
    HandlerCreateTaskPets(pet, PET_TASK_PLAYING);
    if(OnlineInfo[playerid][oShowInterface] == 2) CloseSmartfon(playerid);
    PlayingWithPetStartProcess(playerid);
    return true;
}

stock PetTaskGoSeatInCar(playerid,pet)
{
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Я не сижу в транспорте что бы позвать питомца к себе!");
    if(!IsAFarNpcToPlayer(pet, true)) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Питомец далеко, и не может получить команду!");
    if(CheckTaskValid(pet, PET_TASK_GOSEATCAR)) 
    {
        HandlerCreateTaskPets(pet, PET_TASK_GOSEATCAR);
        SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Я дал команду питомцу сесть со мной в машину");
    }
    return true;
}

stock PetTaskAttacGeneral(pet)
{
    if(PetInfo[pet][petEvent] == PET_TASK_ATTACNPC || PetInfo[pet][petEvent] == PET_TASK_ATTAC || !PetInfo[pet][petAuto]) return false;
    if(!IsAFarNpcToPlayer(pet)) return SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Питомец далеко, и не может получить команду!");
    if(CheckTaskValid(pet, PET_TASK_ATTACNPC))
    {
        SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY, "[ Мысли ]: Теперь мне нужно атаковать кого-то что бы питомец напал на него!");
        HandlerCreateTaskPets(pet, PET_TASK_AUTO), PetInfo[pet][petAuto] = true;
    }
    return true;
}

stock PetTaskAttacNPC(pet, NPC:npc, bool:msg = false)
{
    if(PetInfo[pet][petEvent] == PET_TASK_ATTACNPC || PetInfo[pet][petID] == npc || !PetInfo[pet][petAuto]) return false;
    if(!IsAFarNpcToPlayer(pet) && msg) return SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Питомец далеко, и не может получить команду!");
    if(CheckTaskValid(pet, PET_TASK_ATTACNPC, msg)) 
    {
        HandlerCreateTaskPets(pet, PET_TASK_ATTACNPC, INVALID_PLAYER_ID, npc);
        SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Я дал команду питомцу атаковать НПС");
    }
    return true;
}

stock PetTaskAttac(pet, targetid, bool:msg = false)
{
    if(PetInfo[pet][petEvent] == PET_TASK_ATTAC || PetInfo[pet][petPlayer] == targetid || !PetInfo[pet][petAuto]) return false;
    if(!IsAFarNpcToPlayer(pet) && msg) return SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Питомец далеко, и не может получить команду!");
    if(CheckTaskValid(pet, PET_TASK_ATTAC, msg)) 
    {
        HandlerCreateTaskPets(pet, PET_TASK_ATTAC, targetid);
        if(msg) SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Я дал команду фас питомцу на игрока %s", rpplayername(targetid));
    }
    return true;
}

stock PetTaskSniff(pet)
{
    if(!IsAFarNpcToPlayer(pet)) return SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Питомец далеко, и не может получить команду!");
    if(CheckTaskValid(pet, PET_TASK_SNIFF)) 
    {
        HandlerCreateTaskPets(pet, PET_TASK_SNIFF);
        SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Я дал команду питомцу вынюхивать");
    }
    return true;
}

stock PetTaskSit(pet)
{
    if(!IsAFarNpcToPlayer(pet)) return SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Питомец далеко, и не может получить команду!");
    if(CheckTaskValid(pet, PET_TASK_SEAT)) 
    {
        HandlerCreateTaskPets(pet, PET_TASK_SEAT);
        SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Я дал команду питомцу сидеть на месте");
    }
    return true;
}

stock PetTaskFollowMe(pet)
{
    if(!IsAFarNpcToPlayer(pet)) return SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Питомец далеко, и не может получить команду!");
    if(CheckTaskValid(pet, PET_TASK_WALKING)) 
    {
        HandlerCreateTaskPets(pet, PET_TASK_WALKING);
        SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Я дал команду питомцу следовать за мной");
    }
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

stock IsAFarNpcToPlayer(pet, bool:FollowMe = false)
{
    new Float:PetX, Float:PetY, Float:PetZ;
    GetNpcPosition(PetInfo[pet][petID],PetX,PetY,PetZ);

    new Float: PcordX, Float: PcordY, Float: PcordZ;
    GetPlayerPos(PetInfo[pet][petPlayer],PcordX,PcordY,PcordZ);

    if(GetDistanceBetweenPoints2D(PetX, PetY, PcordX, PcordY) > 10.0) return 0;
    if(GetNpcVirtualWorld(PetInfo[pet][petID]) != GetPlayerVirtualWorld(PetInfo[pet][petPlayer])) return 0;
    
    if(FollowMe) TaskNpcGoToPoint(PetInfo[pet][petID],PcordX,PcordY,PcordZ, NPC_MOVE_MODE_RUN);

    return 1;
}

stock IsAPetType(pet)
{
    if(pet == 609 || pet >= 632 && pet <= 648) return 1; // Собака
    if(pet >= 626 && pet <= 631) return 2; // Кошки
    return 0;
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
                                "\n{ff9000}Уровень {99ff66}%d\t{cccccc}Опыт [ {99ff66}%d{cccccc}/100 ]"\
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
	format(lines,sizeof(lines),"{ff9000}Уровень {99ff66}%d\t{cccccc}Опыт [ {99ff66}%d{cccccc}/100 ]\tОчков прокачки: %d"\
                                "\n{0088ff}Особенности питомца\t \t"\
                                "\n{0088ff}Сила\t \t{cccccc}%d"\
                                "\n{0088ff}Ловкость\t \t{cccccc}%d"\
                                "\n{0088ff}Выносливость\t \t{cccccc}%d"\
								"\n{0088ff}Прокачка команд питомца\t \t ",
                                PetInfo[pet][petLevel],PetInfo[pet][petExp], PetInfo[pet][petPoint],
                                PetInfo[pet][petPower],PetInfo[pet][petAgility], PetInfo[pet][petEndurance]);
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE_INFORMATION,DIALOG_STYLE_TABLIST_HEADERS, string, lines, "Принять", "Отмена");
	return true;
}

stock dialogPetPower(playerid,pet)
{
	new lines[512], string[60];
	format(lines,sizeof(lines),"{ff9000}%s Уровень {99ff66}%d\t{cccccc}Опыт [ {99ff66}%d{cccccc}/100 ]\tОчков прокачки: %d"\
                                "\n{ff9000}Что дает сила?\t \t"\
                                "\n{cccccc} - Сила увеличивает урон питомца на (БАЗОВОЕ ЗНАЧЕНИЕ*Сила)"\
                                "\n{cccccc} - Сила влияет на кол-во здоровья питомца (БАЗОВОЕ ЗНАЧЕНИЕ+5*(Сила+Выносливость)).\t \t"\
                                "\n\n{0088ff}Силу можно прокачать за поинты, а так же скормив специальную вкусняшку\t \t",
                                GetSkinName(PetsParam[PetInfo[pet][petType]][2]),PetInfo[pet][petLevel],PetInfo[pet][petExp], PetInfo[pet][petPoint]);
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE_POWER,DIALOG_STYLE_MSGBOX, string, lines, "Повысить", "Назад");
	return true;
}

stock dialogPetAgility(playerid,pet)
{
	new lines[512], string[60];
	format(lines,sizeof(lines),"{ff9000}%s Уровень {99ff66}%d\t{cccccc}Опыт [ {99ff66}%d{cccccc}/100 ]\tОчков прокачки: %d"\
                                "\n{ff9000}Что дает Ловкость?\t \t"\
                                "\n{cccccc} - Ловкость уменьшает кол-во получаемого урона у питомцу на (Урон/(Ловкость+Выносливость)."\
                                "\n\n{0088ff}Ловкость можно прокачать за поинты, а так же скормив специальную вкусняшку\t \t",
                                GetSkinName(PetsParam[PetInfo[pet][petType]][2]),PetInfo[pet][petLevel],PetInfo[pet][petExp], PetInfo[pet][petPoint]);
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE_AGILITY,DIALOG_STYLE_MSGBOX, string, lines, "Повысить", "Назад");
	return true;
}

stock dialogPetEndurence(playerid,pet)
{
	new lines[512], string[60];
	format(lines,sizeof(lines),"{ff9000}%s Уровень {99ff66}%d\t{cccccc}Опыт [ {99ff66}%d{cccccc}/100 ]\tОчков прокачки: %d"\
                                "\n{ff9000}Что дает Выносливость?\t \t"\
                                "\n{cccccc} - Выносливость влияет на кол-во здоровья питомца (БАЗОВОЕ ЗНАЧЕНИЕ+5*(Сила+Выносливость))."\
                                "\n{cccccc} - Выносливость уменьшает кол-во получаемого урона у питомцу на (Урон/(Ловкость+Выносливость)."\
                                "\n\n{0088ff}Выносливость можно прокачать за поинты, а так же скормив специальную вкусняшку\t \t",
                                GetSkinName(PetsParam[PetInfo[pet][petType]][2]),PetInfo[pet][petLevel],PetInfo[pet][petExp], PetInfo[pet][petPoint]);
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE_ENDURENCE,DIALOG_STYLE_MSGBOX, string, lines, "Повысить", "Назад");
	return true;
}

stock PetUpdateCharacteristic(playerid,pet, charactreristic)
{
    if(PetInfo[pet][petPoint] < 1) return dialogPetInformation(playerid, pet);
    switch(charactreristic)
    {
        case 0: PetInfo[pet][petPower]++;
        case 1: PetInfo[pet][petAgility]++;
        case 2: PetInfo[pet][petEndurance]++;
    }
    PetInfo[pet][petPoint]--;
    return dialogPetInformation(playerid, pet);
}

stock PetUpdateSkill(playerid, pet, skill)
{
    if(PetInfo[pet][petPoint] < 1) return dialogPetUpdateSkill(playerid, pet), SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: У питомца недостаточно очков для прокачки");
    if(PetInfo[pet][petSkills][pet_Skills:skill] == 10) return dialogPetUpdateSkill(playerid, pet), SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Этот скилл и так максимального уровня");
    PetInfo[pet][petSkills][pet_Skills:skill]++;
    PetInfo[pet][petPoint]--;
    return dialogPetUpdateSkill(playerid, pet);
}

stock dialogPetUpdateSkill(playerid,pet)
{
    new type = PetInfo[pet][petType];

	new lines[500], string[60];
	format(lines,sizeof(lines),"{ff9000}%s Уровень {99ff66}%d\t{cccccc}Опыт [ {99ff66}%d{cccccc}/100 ]\tОчков прокачки: %d"\
                                "\n{0088ff}Голос\t \t[ %d/10 ]"\
                                "\n{0088ff}Фас\t \t[ %d/10 ]"\
                                "\n{0088ff}За мной\t \t[ %d/10 ]"\
                                "\n{0088ff}Принюхивайся\t \t[ %d/10 ]"\
								"\n{0088ff}Жди здесь\t \t[ %d/10 ]"\
                                "\n{0088ff}Садись в машину\t \t[ %d/10 ]",
                                GetSkinName(PetsParam[type][2]),PetInfo[pet][petLevel],PetInfo[pet][petExp], PetInfo[pet][petPoint],
                                PetInfo[pet][petSkills][PET_SKILL_VOICE], 
                                PetInfo[pet][petSkills][PET_SKILL_ATTAC], 
                                PetInfo[pet][petSkills][PET_SKILL_FOLLOWME], 
                                PetInfo[pet][petSkills][PET_SKILL_SNIFF], 
                                PetInfo[pet][petSkills][PET_SKILL_SIT], 
                                PetInfo[pet][petSkills][PET_SKILL_SITCAR]);
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE_UPDATESKILL,DIALOG_STYLE_TABLIST_HEADERS, string, lines, "Принять", "Отмена");
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
                                "\n{0088ff}Фас\t%s\t%s"\
                                "\n{0088ff}За мной\t%s\t%s"\
                                "\n{0088ff}Принюхивайся\t%s\t%s"\
								"\n{0088ff}Жди здесь\t%s\t%s"\
                                "\n{0088ff}Садись в машину\t%s\t%s"\
                                "\n{0088ff}Давай играть\t%s\t%s",
                                GetSkinName(PetsParam[type][2]),
                                PetInfo[pet][petSkills][PET_SKILL_VOICE] == 10 ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petUnix] ? "{44ff99}Выполняет" : "", 
                                PetInfo[pet][petSkills][PET_SKILL_ATTAC] == 10 ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petEvent] == PET_TASK_ATTAC ? "{44ff99}Выполняет" : "", 
                                PetInfo[pet][petSkills][PET_SKILL_FOLLOWME] == 10 ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petEvent] == PET_TASK_WALKING ? "{44ff99}Выполняет" : "", 
                                PetInfo[pet][petSkills][PET_SKILL_SNIFF] == 10 ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petEvent] == PET_TASK_SNIFF ? "{44ff99}Выполняет" : "", 
                                PetInfo[pet][petSkills][PET_SKILL_SIT] == 10 ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petEvent] == PET_TASK_SEAT ? "{44ff99}Выполняет" : "", 
                                PetInfo[pet][petSkills][PET_SKILL_SITCAR] == 10 ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petEvent] == PET_TASK_SEATCAR ? "{44ff99}Выполняет" : "", 
                                PetInfo[pet][petPlayingUnix] < gettime() ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petEvent] == PET_TASK_PLAYING ? "{44ff99}Выполняет" : "");
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
                else dialogPetsList(playerid);
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
                case 1: PetTaskAttacGeneral(pet); // Фас игрока/npc
                case 2: PetTaskFollowMe(pet);// идти за мной
                case 3: PetTaskSniff(pet); // принюхаться
                case 4: PetTaskSit(pet);// сидеть на месте
                case 5: PetTaskGoSeatInCar(playerid,pet);// сесть в машину
                case 6: PetTaskGoPlaying(playerid,pet);// Играть
                default: dialogPetMenagment(playerid,slot);
            }
        }
        case PET_CREATETASK_ATTAC: {
            if(!response) show_interaction(playerid, Moiplayer[playerid]);
            new pet = OnlineInfo[playerid][oPet][listitem];
            PetTaskAttac(pet, Moiplayer[playerid], true);
        }
        case PET_CREATETASK_SNIFF: {
            if(!response) show_interaction(playerid, Moiplayer[playerid]);
            if(PetSniffPlayer(Moiplayer[playerid]) > 0) SendClientMessage(playerid,COLOR_GRAY,"[ Мысли ] Кажется питомец что-то учуял у %s",rpplayername(Moiplayer[playerid]));
            else SendClientMessage(playerid,COLOR_GRAY,"[ Мысли ] Питомец ничего не чует у %s",rpplayername(Moiplayer[playerid]));
        }
        case PETS_SHOW_PETMANAGE_INFORMATION: {
            new slot = DP[0][playerid];
            new pet = OnlineInfo[playerid][oPet][slot];
            if(!response) dialogPetMenagment(playerid,slot);
            else{
                switch(listitem)
                {
                    case 1: dialogPetPower(playerid,pet);
                    case 2: dialogPetAgility(playerid,pet);
                    case 3: dialogPetEndurence(playerid,pet);
                    case 4: dialogPetUpdateSkill(playerid,pet);
                }
            }
        }
        case PETS_SHOW_PETMANAGE_POWER:{
            new slot = DP[0][playerid];
            new pet = OnlineInfo[playerid][oPet][slot];
            if(!response) dialogPetInformation(playerid,pet);
            else PetUpdateCharacteristic(playerid, pet,0);
        }
        case PETS_SHOW_PETMANAGE_AGILITY:{
            new slot = DP[0][playerid];
            new pet = OnlineInfo[playerid][oPet][slot];
            if(!response) dialogPetInformation(playerid,pet);
            else PetUpdateCharacteristic(playerid, pet,1);
        }
        case PETS_SHOW_PETMANAGE_ENDURENCE:{
            new slot = DP[0][playerid];
            new pet = OnlineInfo[playerid][oPet][slot];
            if(!response) dialogPetInformation(playerid,pet);
            else PetUpdateCharacteristic(playerid, pet,2);
        }
        case PETS_SHOW_PETMANAGE_UPDATESKILL:{
            new slot = DP[0][playerid];
            new pet = OnlineInfo[playerid][oPet][slot];
            if(!response) dialogPetInformation(playerid,slot);
            else PetUpdateSkill(playerid,pet,listitem+1);
        }
        case PETS_HELP: {
            if(!response) pc_cmd_help(playerid);
            else
            {
                switch(listitem)
                {
                    case 0: dialogInformationWildPets(playerid);
                    case 1: dialogInformationPets(playerid);
                    case 2: dialogInformationPetsFeatures(playerid);
                    default: pc_cmd_help(playerid);
                }
            }
        }
        case PETS_HELP_LIST: {
            dialogHelpPet(playerid);
        }
        case PETS_HELP_LIST_FEATURES: {
            if(!response) dialogHelpPet(playerid);
            else dialogInformationPetsFeaturesItem(playerid, listitem);
        }
        case PETS_HELP_FEATURES: {
            dialogInformationPetsFeatures(playerid);
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

stock dialogHelpPet(playerid)
{
	new lines[1020], string[60];
	format(lines,sizeof(lines),"\n{cccccc}Что за кошки/собаки гуляют по улицам?\n"\
                                "\n{cccccc}Что за питомцы и чем они полезны?"\
                                "\n{cccccc}Особые навыки питомцев");
	format(string,sizeof(string),"{ff9000}Питомцы");
	ShowDialog(playerid,PETS_HELP,DIALOG_STYLE_TABLIST, string, lines, "Выбрать", "Отмена");
	return true;
}

stock dialogInformationPets(playerid)
{
	new lines[2400], string[60];
	format(lines,sizeof(lines),"\n{0088ff}Что дают питомцы?\n"\
                                "\n{cccccc}- Питомцы являются вашим компаньоном в игре. Они будут сопровождать вас пешком/в машине"\
                                "\n{cccccc}Они будут так же сражаться с вами в битве с NPC/Игроками, если вы прокачаете своего питомца\n"\
                                "\n{cccccc}Так же если вас атакует игрок/НПС то питомец будет вас защищать(При включенной команде фас)\n"\
                                "\n{cccccc}- Питомцу можно давать команды, но для этого его нужно прокачать играясь с ним в миниигру и постоянно кормя его"\
                                "\n{cccccc}Примеры команд: Фас на игрока/NPC, принюхаться(найти запрещенные предметы у игроков рядом), следовать за мной и сидеть на месте"\
                                "\n{cccccc}голос, играть. Этот список будет пополняться с будущими обновлениями!\n"\
                                "\n{cccccc}- У питомцев так же есть несколько особенностей, разных уровней: %sБазовые, %sРедкие, %sЛегендарные"\
								"\n{cccccc}Примеры особенностей можно посмотреть в /help > Питомцы > Особенности питомцев"\
                                "\n{cccccc}- Можно иметь только одного загруженного питомца. А с раширением только двух загружаемыех питомцев"\
                                "\n{cccccc}- В данный момент на сервере есть %s разных видов питомцев.\n"\
                                "\n{ff6347}ВНИМАНИЕ!!"\
                                "\n{cccccc}- Если питомца не кормить, то он умрет. Не совершайте ошибок, ухаживайте за братьями нашими меньшими!"\
                                "\n{cccccc}- Дальше я забил хуй что-то писать, потом сделаю!",PetsFeaturesColor[0],PetsFeaturesColor[1],PetsFeaturesColor[2], MAX_PETS_TYPE - 1);
	format(string,sizeof(string),"{ff9000}Что дают питомцы?");
	ShowDialog(playerid,PETS_HELP_LIST,DIALOG_STYLE_MSGBOX, string, lines, "Назад", "");
	return true;
}

stock dialogInformationPetsFeatures(playerid)
{
	new line[120],lines[120*sizeof(PetsFeaturesName)+500];

    for(new i = 0; i < sizeof(PetsFeaturesName); i++)
    {
        format(line,sizeof(line),"{ffffff}%d. %s%s\t{cccccc}Эффект: %d%%\n",i+1,PetsFeaturesColor[PetsFeaturesSetting[i][0]], PetsFeaturesName[i], PetsFeaturesSetting[i][1]), strcat(lines,line);
    }
    ShowDialog(playerid,PETS_HELP_LIST_FEATURES,DIALOG_STYLE_TABLIST,"{ff9000}Особые навыки питомцев",lines,"Выбрать","Отмена");
    return true;
}

stock dialogInformationPetsFeaturesItem(playerid, listitem)
{
	new lines[500],string[100];
	format(lines,sizeof(lines),"{cccccc}%s", PetsFeaturesDescription[listitem]);
	format(string,sizeof(string),"%s%s {cccccc}Эффект: %d%%",PetsFeaturesColor[PetsFeaturesSetting[listitem][0]],PetsFeaturesName[listitem],PetsFeaturesSetting[listitem][1]);
	ShowDialog(playerid,PETS_HELP_FEATURES,DIALOG_STYLE_MSGBOX, string, lines, "Назад", "");
    return true;
}


stock PlayingWithPetStopProcess(playerid, stat)
{
    ClearAnimations(playerid);
	ClearAnim(playerid);

    DP[0][playerid] = 0;
    InputProcess[playerid] = 0;
	InputID[playerid] = 0;
    InputType[playerid] = 0;
    PlayingWithPetProcessTime[playerid] = 0;
    PlayingWithPetProcessTimers[playerid] = false;
    if(PlayingWithPetObject[playerid]) DestroyDynamicObject(PlayingWithPetObject[playerid]);

    new pet = FindPlayingWithPet(playerid);
    if (stat == 0) {
        PlayerPlaySound(playerid, 31202);
    } else if (stat == 1) {
        PlayerPlaySound(playerid, 31205);
        if(pet != -1) GivePetsExp(pet, 25), PetInfo[pet][petPlayingUnix] = gettime() + 18000;
    }
    if(pet != -1) PetHunger(pet, 5), HandlerCreateTaskPets(pet, PET_TASK_WALKING);

    for (new i = 0; i <= 5; i++) TextDrawHideForPlayer(playerid, InputDraw[i]);
    PlayerTextDrawHide(playerid, InputDraw1);
	PlayerTextDrawHide(playerid, InputDraw2);

    return 1;
}

stock PlayingWithPetStartProcess(playerid)
{
    PlayerTextDrawShow(playerid, InputDraw1);
    PlayerTextDrawShow(playerid, InputDraw2);
    TextDrawShowForPlayer(playerid, InputDraw[1]);
    processbar2(playerid, 0);
    ShowInput(playerid);
    InputType[playerid] = 3;
    PlayingWithPetProcessTime[playerid] = 10;
    PlayingWithPetProcessTimers[playerid] = true;
    PlayingWithPetProcessTimer(playerid);
    return true;
}

function PlayingWithPetProcessTimer(playerid)
{
    if (!PlayingWithPetProcessTimers[playerid] || !IsOnline(playerid)) return 0;

    if(InputProcess[playerid] >= 5)
	{
		if(!PlayingWithPetProcessDistance(playerid)) return 1;
		InputProcess[playerid] -= 5;
		processbar2(playerid, InputProcess[playerid]);
	}
	else
	{
        if(PlayingWithPetProcessTime[playerid] > 0) PlayingWithPetProcessTime[playerid]--;
		else
		{
			PlayingWithPetStopProcess(playerid, 0);
		}
	}
	TextDrawHideForPlayer(playerid, InputDraw[0]), TextDrawHideForPlayer(playerid, InputDraw[5]);

	return SetTimerEx("PlayingWithPetProcessTimer", 300, false, "d", playerid);
}

stock PlayingWithPet_OnPlayerDisconnect(playerid)
{
    if (PlayingWithPetProcessTimers[playerid])
    {
        PlayingWithPetStopProcess(playerid, 0);
    }
    return 1;
}

stock FindPlayingWithPet(playerid)
{
    new pet = -1;
    for(new i = 0; i < MAX_PETS_AT_PLAYER; i++)
	{
		if(OnlineInfo[playerid][oPet][i] != -1) 
		{
            if(PetInfo[OnlineInfo[playerid][oPet][i]][petEvent] == PET_TASK_PLAYING)
            {
                pet = OnlineInfo[playerid][oPet][i];
                break;
            }
		}
	}
    return pet;
}

stock PlayingWithPetProcessDistance(playerid)
{
    new pet = FindPlayingWithPet(playerid);
    if(pet == -1) return false;
    if(IsAFarNpcToPlayer(pet))
    {
        return true;
    }
    return false;
}

stock CreateObjectForPlayingWithPets(playerid)
{
    new pet = FindPlayingWithPet(playerid);
    if(pet == -1) return false;

    new Float:AnimalX, Float:AnimalY, Float:AnimalZ;
    GetNpcPosition(PetInfo[pet][petID], AnimalX,AnimalY,AnimalZ);

    new Float: PcordX, Float: PcordY, Float: PcordZ;
    GetPlayerPos(playerid,PcordX,PcordY,PcordZ);

    new Float:PcordA = float(random(360));
    SetPlayerFacingAngle(playerid, PcordA);

    PlayingWithPetObject[playerid] = CreateDynamicObject(3000,PcordX,PcordY,PcordZ+1.0, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

    new Float:x=PcordX+5.0*floatsin(-PcordA,degrees);
	new Float:y=PcordY+5.0*floatcos(-PcordA,degrees);
    new Float:z;
    CA_FindZ_For2DCoord(x, y, z);

    MoveDynamicObject(PlayingWithPetObject[playerid], x, y, z, 8);
    PlayingWithPetObjectTimer[playerid] = SetTimerEx("DestroyPlayingWithPetObject", 800, false, "d", playerid);
    return true;
}

function DestroyPlayingWithPetObject(playerid)
{
    StopDynamicObject(PlayingWithPetObject[playerid]);
    KillTimer(PlayingWithPetObjectTimer[playerid]);
    if(PlayingWithPetObject[playerid]) DestroyDynamicObject(PlayingWithPetObject[playerid]);
    PlayingWithPetObject[playerid] = 0;
    return true;
}

stock GivePetsExp(pet, exp)
{
    if(PetInfo[pet][petExp] + exp >= 100)
    {
        PetInfo[pet][petLevel] += (PetInfo[pet][petExp]+exp) / 100;
        PetInfo[pet][petExp] = (PetInfo[pet][petExp]+exp) % 100;
        PetInfo[pet][petPoint]++;
    }
    else PetInfo[pet][petExp] += exp;

    new string[110];
    format(string, sizeof(string), "{0088ff}Вы поиграли с питомцем и он получил {99ff66}%d {0088ff}опыта",exp);
    SendClientMessage(PetInfo[pet][petPlayer], COLOR_GREY, string);
    return true;
}

stock PetHunger(pet, hunger)
{
    PetInfo[pet][petHunger] -= hunger;
    if(PetInfo[pet][petHunger] < 0) PetInfo[pet][petHunger] = 0;
    return true;
}

stock Pump_FeedPet(playerid)
{
	SetPVarInt(playerid, "oryjtemp", GetPVarInt(playerid, "oryjtemp") + 1);

    new pet = GetPVarInt(playerid,"pet");
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ;
    GetNpcPosition(PetInfo[pet][petID],AnimalX,AnimalY,AnimalZ);
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, AnimalX,AnimalY,AnimalZ)) 
    {
        SetPVarInt(playerid, "pet", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
        return ErrorMessage(playerid, "{ff6347}Вы далеко отошли от питомца, кормление прервано!");
    }
    if(HoldStat[playerid] != 262)
    {
        SetPVarInt(playerid, "pet", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
        return ErrorMessage(playerid, "{ff6347}Вы убрали колбасу из рук, кормление прервано!");
    }
	if(GetPVarInt(playerid,"oryjtemp") >= 10)
	{
	 	GameTextForPlayer(playerid, RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Кормление: ~w~10/10"), 1500, 3);
        PetInfo[pet][petHunger]+=20;
        stopdrink(playerid);
        RemovePlayerAttachedObject(playerid,1);

	 	ClearAnim(playerid);
        SetPVarInt(playerid, "pet", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
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

stock Pump_StartFeedPet(playerid, pet)
{
    if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return 0;
    if(GetPVarInt(playerid, "Arobsklad") > 0) return 0;
    if(PetInfo[pet][petHunger] > 80) return ErrorMessage(playerid, "{FF6347}Питомец не голоден. Попробуйте позже!");

    if(get_invent4(playerid, 262, 0) <= 0 || get_para(playerid,262) < gettime()) return ErrorMessage(playerid, "{FF6347}У вас нет колбасы [ Приготовьте её на плите ]");
    if(HoldStat[playerid] != 262) return ErrorMessage(playerid, "{FF6347}Возьмите в руки колбасу, чтобы начать кормить питомца [ N ]");
    
    if(PetInfo[pet][petPlayer] != playerid) return ErrorMessage(playerid, "{FF6347}Я не могу кормить питомца, который не мой");
    SetPVarInt(playerid, "pet", pet), SetPVarInt(playerid, "oryjtemp", 0); SetPVarInt(playerid, "Arobsklad", 19);
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Теперь мне нужно начать кормить питомца {ff9000}[ Нажимайте %s ]", buttonName[Device[playerid]]);

    return true;
}

stock FindLoadedPet(playerid)
{
    new Float:AnimalX, Float:AnimalY, Float:AnimalZ;
    for(new pet = 0; pet < MAX_PETS; pet++)
    {
        GetNpcPosition(PetInfo[pet][petID],AnimalX,AnimalY,AnimalZ);
        if(IsPlayerInRangeOfPoint(playerid,2.0,AnimalX,AnimalY,AnimalZ) && GetPlayerVirtualWorld(playerid) == GetNpcVirtualWorld(PetInfo[pet][petID]))
        {
            Pump_StartFeedPet(playerid,pet);
            break;
        }    
    }
    return true;
}
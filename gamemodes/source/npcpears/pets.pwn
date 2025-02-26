// MAX_PETS_AT_PLAYER - pears.pwn Кол-во загружаемых петов
#define MAX_PETS_TYPE 24 // Тип животинки
#define MAX_PETS_PARAM 2 // Кол-во параметров для животных
#define MAX_PETS 2000 // Общие кол-во питомцев на сервере
#define MAX_PETS_FEATURES 10 // Сколько максимально способностей может быть у питомца
#define PRICE_RESURRECT 100000 // Стоимость воскрешения питомца
#define PRICE_FEATURES_PET 90 // Стоимость предмета питомца


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

enum pet_FeaturesQuality
{
    PET_FEATURES_USUAL,
    PET_FEATURES_RARE,
    PET_FEATURES_LEGENDARY
}
new QuanFeatures[3];
new PetsFeaturesName[][] =
{
    "", // 0
    "Грязные когти", // 1
    "Сточеные зубы", // 2
    "Быстрые лапки", // 3
    "Громкий голос" // 4
};

new PetsFeaturesSetting[sizeof(PetsFeaturesName)][2] =
{
    // 1 - Rare, 2 - Count
    { -1, -1},                        // 0
    { PET_FEATURES_USUAL, 20},        // 1 
    { PET_FEATURES_RARE, 10},        // 2
    { PET_FEATURES_LEGENDARY, 5},        // 3
    { PET_FEATURES_USUAL, 25}         // 4
};

new PetsFeaturesColor[][] =
{
    "{D2B48C}",
    "{54FF9F}",
    "{D93A49}"
};

new PetsFeaturesDescription[][] =
{
    "", // 0
    "Заражает (ТОЛЬКО ИГРОКА) болезнью Акне"\
    "   \n- Заражение не дает эффекта сразу, болезнь будет прогрессировать со временем"\
    "   \n- Эффект данной особенности означает какой шанс на заражение", // 1
    "Урон питомца повышается по игроку/питомцу"\
    "   \n- Повышает базовый урон питомца по игроку/питомцу в процентах", // 2
    "Питомец уворачивается от пуль"\
    "   \n- Эффект данной особенности это шанс с которого ваш питомец не получит урона", // 3
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

enum pet_Sound
{
    PET_SOUND_CRY,
    PET_SOUND_ANGRY,
    PET_SOUND_HAPPY,
    PET_SOUND_ASKS,
    PET_SOUND_VERYANGRY,
    PET_SOUND_SNIFF
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
    petNewID, // New id
	NPC:petID, // ID бота
    petName[20], // Имя
    petPlayer, // playerid владельца
    petHunger, // Голод 
    petLevel, // Уровень
    petExp, // Экспулечка
    petPoint, // Очки прокачки
    petPower, // Сила
    petAgility, // Ловкость
    petEndurance, // Выносливость
    petFeatures[MAX_PETS_FEATURES], // Особенности питомца
    petDonateFeatures, // кол-во купленных слотов
    bool:petDestinationStatus, // Идет или пришел
    pet_TaskToNpc: petEvent,
    petSkills[pet_Skills:pet_Skills],
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
    bool:petAuto, // Для автотаски
    bool:petLoad // Тумблер
}
new PetInfo[MAX_PETS][petsnpc];

stock ClearPetVariable(pet)
{
    // Очищаем все переменные PlayerInfo
	for(new petsnpc:i; i < petsnpc; ++i) PetInfo[pet][i] = 0;
    for(new pet_Skills:i; i < pet_Skills; ++i) PetInfo[pet][petSkills][i] = 0;
    for(new i; i < MAX_PETS_FEATURES; ++i) PetInfo[pet][petFeatures][i] = 0;
    return true;
}
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

stock GetPetParam(type)
{
    for(new i = 0; i < MAX_PETS_TYPE; i++)
    {
        if(PetsParam[i][3] == 0 && i == type)
        {
            return true;
        }
    }
    return false;
}

stock CreatePet(playerid, pet)
{
    if(IsValidNpc(PetInfo[pet][petID])) return false;
    new Float:PetX, Float:PetY, Float:PetZ = 50;
    GetPlayerPos(playerid,PetX,PetY,PetZ);
    new Float:tempZ = PetZ;
    CA_FindZ_For2DCoord(PetX,PetY,PetZ);
    if(PetZ >= tempZ + 1.0) PetZ = tempZ;
    else PetZ += 1.5;

    PetInfo[pet][petPlayer] = playerid;
    PetInfo[pet][petAttactID] = INVALID_PLAYER_ID;
    PetInfo[pet][petAttactNpcID] = INVALID_NPC;
    PetInfo[pet][petKillerID] = INVALID_PLAYER_ID;

    PetInfo[pet][petAnim] = 0;
    PetInfo[pet][petSoundUnix] = 0;

    PetInfo[pet][petAuto] = false;
    PetInfo[pet][petEvent] = pet_TaskToNpc:PET_TASK_WALKING;
    
    new skin = FindPet(PetInfo[pet][petType]);
    PetInfo[pet][petID] = CreateNpc(PetsParam[skin][0], PetX + 0.5, PetY + 0.5, PetZ);

    SetNpcStunAnimationEnabled(PetInfo[pet][petID], true);
    SetNpcVirtualWorld(PetInfo[pet][petID], GetPlayerVirtualWorld(playerid));
    SetNpcHealth(PetInfo[pet][petID], PetInfo[pet][petHealth]);

    OnlineInfo[playerid][oPetLoad] = 0;
    PetInfo[pet][petLoad] = true;
    return true;
}

stock DestroyPet(playerid, slotpet)
{
    if(OnlineInfo[playerid][oPet][slotpet] == -1) return ErrorMessage(playerid, "{ff6347}У меня не загружен данный питомец");
    new pet = OnlineInfo[playerid][oPet][slotpet];
    SavePet(playerid,pet);
    OnlineInfo[playerid][oPet][slotpet] = -1;
    OnlineInfo[playerid][oPetID][slotpet] = -1;
    if(IsValidNpc(PetInfo[pet][petID])) DestroyNpc(PetInfo[pet][petID]);
    ClearPetVariable(pet);

    return true;
}

stock LifePet(pet)
{
    if(!IsValidNpc(PetInfo[pet][petID])) return 0;
    if(!PetInfo[pet][petLoad]) return 0;
    
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
        for(new i = 0; i < MAX_PETS_AT_PLAYER; i++)
        {
            if(OnlineInfo[PetInfo[pet][petPlayer]][oPet][i] == pet) return DestroyPet(PetInfo[pet][petPlayer],i);
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
        PetPlaySound(pet, PET_SOUND_VERYANGRY);
        if(!IsOnline(PetInfo[pet][petAttactID])) PetInfo[pet][petAttactID] = INVALID_PLAYER_ID;
        if(PlayerInGreenZonePosition(PetInfo[pet][petAttactID]) || PlayerInGreenZonePosition(PetInfo[pet][petPlayer])) return HandlerCreateTaskPets(pet, PET_TASK_WALKING), PetInfo[pet][petAttactID] = INVALID_PLAYER_ID;
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
        PetPlaySound(pet, PET_SOUND_VERYANGRY);
        if(!PetInfo[pet][petStartAttactNpcID]) TaskNpcStandStill(PetInfo[pet][petID]);
        new Float:tempHealth;
        if(IsValidNpc(PetInfo[pet][petAttactNpcID])) GetNpcHealth(PetInfo[pet][petAttactNpcID],tempHealth);
        if(!IsValidNpc(PetInfo[pet][petAttactNpcID]) || tempHealth <= 0.0) return HandlerCreateTaskPets(pet, PET_TASK_WALKING);
        if(!PetInfo[pet][petStartAttactNpcID]) TaskNpcAttackNpc(PetInfo[pet][petID], PetInfo[pet][petAttactNpcID], true), PetInfo[pet][petStartAttactNpcID] = true;
    }
    if(PetInfo[pet][petEvent] == PET_TASK_SNIFF)
    {
        PetPlaySound(pet, PET_SOUND_SNIFF);
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
        PetPlaySound(pet, PET_SOUND_HAPPY);
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

stock SetPetNames(playerid,pet)
{
    if(IsEmptyString(PetInfo[pet][petName])) ShowDialog(playerid,PETS_SET_NAME,DIALOG_STYLE_INPUT,"{ff9000}Имя Питомцу","{cccccc}Введите кличку которую хотите дать питомцу {ff9000}[1 - 20 символов]","Принять","Отмена");
    else ShowDialog(playerid,PETS_SET_DONATENAME,DIALOG_STYLE_MSGBOX,"{ff9000}Имя Питомцу","{cccccc}У вашего питомца уже есть имя \n{ff9000}Хотите изменить его за {ffcc00}90G","Принять","Отмена");
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
    else if(PetInfo[pet][petSkills][typeSkill] < 10) return false;
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

stock LoadPlayerPet(playerid,slotpet, petId, inva)
{
    if(OnlineInfo[playerid][oPet][slotpet] != -1) return ErrorMessage(playerid, "{ff6347}У меня уже есть загруженный питомец!");
    for(new pet = 0; pet < MAX_PETS; pet++)
    {
        if(IsValidNpc(PetInfo[pet][petID])) continue;
        OnlineInfo[playerid][oPet][slotpet] = pet;
        new string_mysql[300];
        if(petId == 0)
        {
            mysql_format(pearsq, string_mysql, sizeof(string_mysql), "INSERT INTO `pets` SET `petHunger` = '50',`petPower` = '1',`petAgility` = '1',`petEndurance` = '1',`petHealth` = '100', `petUnixLastEating` = '%d'",gettime()+1200);
			mysql_tquery(pearsq, string_mysql, "Call_getidPet", "ddd", playerid, slotpet, inva);
        }
        else{
            mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT * FROM `pets` WHERE `petID` = '%d'", petId);
            mysql_tquery(pearsq, string_mysql, "OnPlayerPetLoad", "ddddd",playerid, g_MysqlRaceCheck[playerid],slotpet, pet, inva);
        }
        break;
    }
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
    if(tempUnix < 0) tempUnix = abs(tempUnix);
    new GetHungryInTenMinuts = tempUnix/600;
    if(GetHungryInTenMinuts > 0 && PetInfo[pet][petHunger] > 0) PetInfo[pet][petUnixLastEating] = gettime()+600, PetInfo[pet][petHunger] -= GetHungryInTenMinuts;
    if(PetInfo[pet][petHunger] < 0) PetInfo[pet][petHunger] = 0;
    SavePet(PetInfo[pet][petPlayer], pet);
    return true;
}

stock PetTaskGoPlaying(playerid,pet)
{
    if(!IsAFarNpcToPlayer(pet)) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Питомец далеко, и не может получить команду!");
    if(PetInfo[pet][petPlayingUnix] > gettime()) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Питомец не хочет играть в данный момент. Поиграть можно будет через %s минут", fine_time(PetInfo[pet][petPlayingUnix] - gettime()));
    if(PetInfo[pet][petHunger] < 50) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Питомец сильно голоден, и не может получить команду!");
    HandlerCreateTaskPets(pet, PET_TASK_PLAYING);
    if(OnlineInfo[playerid][oShowInterface] == 2) CloseSmartfon(playerid), CancelSelectTextDraw(playerid);
    PlayingWithPetStartProcess(playerid);
    return true;
}

stock PetTaskGoVoice(playerid,pet)
{
    if(!IsAFarNpcToPlayer(pet)) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Питомец далеко, и не может получить команду!");
    if(PetInfo[pet][petSoundUnix] > gettime()) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Питомец уже давал голос недавно. Подождите!");
    if(PetInfo[pet][petHunger] < 50) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Питомец сильно голоден, и не может получить команду!");
    if(CheckTaskValid(pet, PET_TASK_GOSEATCAR)) 
    {
        PetPlaySound(pet,PET_SOUND_ANGRY);
        SendClientMessage(PetInfo[pet][petPlayer],COLOR_GREY,"[ Мысли ]: Я дал команду питомцу Голос");
    }
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
    if(PlayerInGreenZonePosition(targetid) || PlayerInGreenZonePosition(PetInfo[pet][petPlayer])) return false;
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

stock DeletePet(petid)
{
	new string_mysql[128];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql),"DELETE FROM `pets` WHERE `petID` = '%d'", petid);
	query_empty(pearsq, string_mysql);
	return 1;
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
    new id = FindPet(PetInfo[pet][petType]);
    new skin = PetsParam[id][2];
    if(skin == 609 || skin >= 632 && skin <= 648) return 1; // Собака
    if(skin >= 626 && skin <= 631) return 2; // Кошки
    return 0;
}

stock IsAPetExisting(pet)
{
    if(pet == 609 || pet >= 626 && pet <= 648) return 1;
    return 0;
}

stock dialogPetsListZoo(playerid)
{
    if(OnlineInfo[playerid][oPetLoad] == 1) return ErrorMessage(playerid,"{ff6347}В данный момент у вас загружается питомец!");
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
            if(OnlineInfo[playerid][oPetID][pet] == PlayerInfo[playerid][pInvenPara][i]) 
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
    if(quan == 0) return ErrorMessage(playerid,"{ff6347}У меня нет питомцев в инвентаре.");
    ShowDialog(playerid,PETS_SELECTZOO,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Мои питомцы",lines,"Выбрать","Отмена");
    return true;
}

stock dialogPetsList(playerid)
{
    i_resetveshi(playerid);

    if(OnlineInfo[playerid][oPetLoad] == 1) return ErrorMessage(playerid,"{ff6347}В данный момент у вас загружается питомец!");
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
            if(OnlineInfo[playerid][oPetID][pet] == PlayerInfo[playerid][pInvenPara][i]) 
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
    if(quan == 0) return ErrorMessage(playerid,"{ff6347}У меня нет питомцев в инвентаре.");
    ShowDialog(playerid,PETS_SHOW_LIST,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Мои питомцы",lines,"Выбрать","Отмена");
    return true;
}

stock dialogPetMenagment(playerid,slot)
{
    if(slot < 0) return false;

    new pet = OnlineInfo[playerid][oPet][slot];
    DP[0][playerid] = slot;
    new type = FindPet(PetInfo[pet][petType]);

	new lines[600], string[60];
	format(lines,sizeof(lines),"{ff9000}Питомец: %s [ %s ]\t Голод: %d\t HP: %.0f"\
                                "\n{ff9000}Уровень {99ff66}%d\t{cccccc}Опыт [ {99ff66}%d{cccccc}/100 ]\t "\
                                "\n{ff6347}Выгрузить питомца\t \t "\
                                "\n{0088ff}Команды питомцу\t \t "\
								"\n{0088ff}Автоматизация действий %s\t \t ",
                                PetInfo[pet][petName], GetSkinName(PetsParam[type][2]), PetInfo[pet][petHunger], PetInfo[pet][petHealth],
                                PetInfo[pet][petLevel],PetInfo[pet][petExp],
                                PetInfo[pet][petAuto] ? "{44ff99} [ On ]" : "{ff6347}[ Off ]");
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE,DIALOG_STYLE_TABLIST_HEADERS, string, lines, "Принять", "Отмена");
	return true;
}

stock dialogPetZooShop(playerid)
{
	new lines[1024], string[60];
	format(lines,sizeof(lines),"\n{0088ff}Воскрестить питомца\t{444444}Воскрешает мертвого питомца\t{44ff99}%d$"\
                                "\n{0088ff}%s\t{444444}Предмет пополняющий здоровье питомцу\t{44ff99}%d$"\
                                "\n{0088ff}%s\t{444444}Пополняет голод питомцу (только для кошек)\t{44ff99}%d$"\
                                "\n{0088ff}%s\t{444444}Пополняет голод питомцу (только для собак)\t{44ff99}%d$"\
                                "\n{0088ff}%s\t{444444}Дает один случайный особый навык\t{ffcc00}%d Gold"\
                                "\n{0088ff}Кейс с питомцами\t{444444}В кейсе находится питомец, которого нет на улицах\t{ffcc00}%d Gold",
                                PRICE_RESURRECT, friskName[283],friskPrice[283],
                                friskName[280],friskPrice[280],
                                friskName[281],friskPrice[281],
                                friskName[282],PRICE_FEATURES_PET,
                                donatePrice[19]);
	format(string,sizeof(string),"{ff9000}Зоомагазин");
	ShowDialog(playerid,PETS_ZOOSHOP,DIALOG_STYLE_TABLIST, string, lines, "Принять", "Отмена");
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
								"\n{ff9000}Прокачка команд питомца\t \t "\
                                "\n{ffcc00}Изменить кличку питомцу\t \t ",
                                PetInfo[pet][petLevel],PetInfo[pet][petExp], PetInfo[pet][petPoint],
                                PetInfo[pet][petPower],PetInfo[pet][petAgility], PetInfo[pet][petEndurance]);
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE_INFORMATION,DIALOG_STYLE_TABLIST_HEADERS, string, lines, "Принять", "Отмена");
	return true;
}

stock dialogPetPower(playerid,pet)
{
    new type = FindPet(PetInfo[pet][petType]);
	new lines[512], string[60];
	format(lines,sizeof(lines),"{ff9000}%s Уровень {99ff66}%d\t{cccccc}Опыт [ {99ff66}%d{cccccc}/100 ]\tОчков прокачки: %d"\
                                "\n{ff9000}Что дает сила?\t \t"\
                                "\n{cccccc} - Сила увеличивает урон питомца на (БАЗОВОЕ ЗНАЧЕНИЕ*Сила)"\
                                "\n{cccccc} - Сила влияет на кол-во здоровья питомца (БАЗОВОЕ ЗНАЧЕНИЕ+5*(Сила+Выносливость)).\t \t"\
                                "\n\n{0088ff}Силу можно прокачать за поинты, а так же скормив специальную вкусняшку\t \t",
                                GetSkinName(PetsParam[type][2]),PetInfo[pet][petLevel],PetInfo[pet][petExp], PetInfo[pet][petPoint]);
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE_POWER,DIALOG_STYLE_MSGBOX, string, lines, "Повысить", "Назад");
	return true;
}

stock dialogPetAgility(playerid,pet)
{
    new type = FindPet(PetInfo[pet][petType]);
	new lines[512], string[60];
	format(lines,sizeof(lines),"{ff9000}%s Уровень {99ff66}%d\t{cccccc}Опыт [ {99ff66}%d{cccccc}/100 ]\tОчков прокачки: %d"\
                                "\n{ff9000}Что дает Ловкость?\t \t"\
                                "\n{cccccc} - Ловкость уменьшает кол-во получаемого урона у питомцу на (Урон/(Ловкость+Выносливость)."\
                                "\n\n{0088ff}Ловкость можно прокачать за поинты, а так же скормив специальную вкусняшку\t \t",
                                GetSkinName(PetsParam[type][2]),PetInfo[pet][petLevel],PetInfo[pet][petExp], PetInfo[pet][petPoint]);
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE_AGILITY,DIALOG_STYLE_MSGBOX, string, lines, "Повысить", "Назад");
	return true;
}

stock dialogPetEndurence(playerid,pet)
{
    new type = FindPet(PetInfo[pet][petType]);
	new lines[512], string[60];
	format(lines,sizeof(lines),"{ff9000}%s Уровень {99ff66}%d\t{cccccc}Опыт [ {99ff66}%d{cccccc}/100 ]\tОчков прокачки: %d"\
                                "\n{ff9000}Что дает Выносливость?\t \t"\
                                "\n{cccccc} - Выносливость влияет на кол-во здоровья питомца (БАЗОВОЕ ЗНАЧЕНИЕ+5*(Сила+Выносливость))."\
                                "\n{cccccc} - Выносливость уменьшает кол-во получаемого урона у питомцу на (Урон/(Ловкость+Выносливость)."\
                                "\n\n{0088ff}Выносливость можно прокачать за поинты, а так же скормив специальную вкусняшку\t \t",
                                GetSkinName(PetsParam[type][2]),PetInfo[pet][petLevel],PetInfo[pet][petExp], PetInfo[pet][petPoint]);
	format(string,sizeof(string),"{ff9000}Управление питомцем");
	ShowDialog(playerid,PETS_SHOW_PETMANAGE_ENDURENCE,DIALOG_STYLE_MSGBOX, string, lines, "Повысить", "Назад");
	return true;
}

stock dialogPetsFeatures(playerid,pet, featur = 0)
{
    new slot = DP[0][playerid];
	new line[120],lines[120*MAX_PETS_FEATURES+500], quan = 0;
    for(new features = 0; features < PetInfo[pet][petDonateFeatures]; features++)
    {
        if(PetInfo[pet][petFeatures][features] == 0) continue;
        format(line,sizeof(line),"{ffffff}%d. %s%s\t{cccccc}Эффект: %d%%\n",
        features+1,PetsFeaturesColor[PetsFeaturesSetting[PetInfo[pet][petFeatures][features]][0]], PetsFeaturesName[PetInfo[pet][petFeatures][features]], 
        PetsFeaturesSetting[PetInfo[pet][petFeatures][features]][1]), strcat(lines,line);
        quan++;
    }
    if(featur == 0)
    {
        if(quan == 0) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: У моего питомца нет способностей"), dialogPetMenagment(playerid,slot);
        ShowDialog(playerid,PETS_SHOW_FEATURES_LIST,DIALOG_STYLE_TABLIST,"{ff9000}Особые навыки питомца",lines,"Выбрать","Отмена");
    }
    else 
    {
        DP[1][playerid] = featur;
        ShowDialog(playerid,PETS_SHOW_FEATURES_CHOICE,DIALOG_STYLE_TABLIST,"{ff9000}Выберите навык для замены",lines,"Выбрать","Отмена");
    }
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
    if(PetInfo[pet][petSkills][pet_Skills:skill] == 10) return dialogPetUpdateSkill(playerid, pet), SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Этот скилл и так максимального уровня");
    if(PetInfo[pet][petPoint] < 1) return dialogPetUpdateSkill(playerid, pet), SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: У питомца недостаточно очков для прокачки");
    PetInfo[pet][petSkills][pet_Skills:skill]++;
    PetInfo[pet][petPoint]--;
    return dialogPetUpdateSkill(playerid, pet);
}

stock dialogPetUpdateSkill(playerid,pet)
{
    new type = FindPet(PetInfo[pet][petType]);

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
    new type = FindPet(PetInfo[pet][petType]);

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
                                PetInfo[pet][petSkills][PET_SKILL_VOICE] == 10 ? "{44ff99}[ Доступно ]" : "{ff6347}[ Недоступно ]", PetInfo[pet][petSoundUnix] ? "{44ff99}Выполняет" : "", 
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

stock dialogCase_Pets(playerid, dialogid, response, listitem, const inputtext[]) {
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
                    if(OnlineInfo[playerid][oPetID][pet] != -1 || OnlineInfo[playerid][oPet][pet] != -1) continue;
                    LoadPlayerPet(playerid, pet, PlayerInfo[playerid][pInvenPara][inva], inva);
                    OnlineInfo[playerid][oPetLoad] = 1;
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
            if(!response) return dialogPetMenagment(playerid,slot);
            switch(listitem)
            {
                case 0: PetTaskGoVoice(playerid, pet);
                case 1: PetTaskAttacGeneral(pet); // Фас игрока/npc
                case 2: PetTaskFollowMe(pet);// идти за мной
                case 3: PetTaskSniff(pet); // принюхаться
                case 4: PetTaskSit(pet);// сидеть на месте
                case 5: PetTaskGoSeatInCar(playerid,pet);// сесть в машину
                case 6: PetTaskGoPlaying(playerid,pet);// Играть
                default: dialogPetMenagment(playerid,slot);
            }
            return dialogPetCreateTask(playerid,slot);
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
                    case 0: dialogPetsFeatures(playerid,pet);
                    case 1: dialogPetPower(playerid,pet);
                    case 2: dialogPetAgility(playerid,pet);
                    case 3: dialogPetEndurence(playerid,pet);
                    case 4: dialogPetUpdateSkill(playerid,pet);
                    case 5: SetPetNames(playerid,pet);
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
            DP[0][playerid] = 9999;
            if(!response) dialogHelpPet(playerid);
            else dialogInformationPetsFeaturesItem(playerid, listitem+1);
        }
        case PETS_HELP_FEATURES: {
            new pet, slot;
            if(DP[0][playerid] == 9999) dialogInformationPetsFeatures(playerid), DP[0][playerid] = 0;
            else 
            {
                slot = DP[0][playerid];
                pet = OnlineInfo[playerid][oPet][slot];
                dialogPetsFeatures(playerid,pet);
            }
        }
        case PETS_SHOW_FEATURES_ACCEPT:{
            new pet = DP[0][playerid];
            new features = DP[1][playerid];
            if(!response) return false;
            else{
                PetSetFeaturesOrChoiceSlot(playerid,pet,features);
            }
        }
        case PETS_SHOW_FEATURES_LIST:{
            new slot = DP[0][playerid];
            new pet = OnlineInfo[playerid][oPet][slot];
            if(!response) return dialogPetInformation(playerid,pet);
            else dialogInformationPetsFeaturesItem(playerid, PetInfo[pet][petFeatures][listitem]);
        }
        case PETS_SHOW_FEATURES_CHOICE:{
            new slot = DP[0][playerid];
            new pet = OnlineInfo[playerid][oPet][slot];
            new features = DP[1][playerid];
            if(!response) return dialogPetInformation(playerid,pet);
            else {
                PetInfo[pet][petFeatures][listitem] = features;
                SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Я заменил одну из способностей питомца на новую");
                dialogPetInformation(playerid,pet);
                SavePet(playerid,pet);
            }
        }
        case PETS_SET_DONATENAME:{
            new slot = DP[0][playerid];
            new pet = OnlineInfo[playerid][oPet][slot];
            if(!response) return dialogPetInformation(playerid,pet);
            else{
                if(PlayerInfo[playerid][pDonateMoney] < 90) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: У меня недостаточно золота!"), dialogPetInformation(playerid,pet);
                else {
                    DP[2][playerid] = 1;
                    ShowDialog(playerid,PETS_SET_NAME,DIALOG_STYLE_INPUT,"{ff9000}Имя Питомцу","{cccccc}Введите кличку которую хотите дать питомцу {ff9000}[1 - 20 символов]","Принять","Отмена");
                }
            }
        }
        case PETS_SET_NAME:{
            new slot = DP[0][playerid];
            new pet = OnlineInfo[playerid][oPet][slot];
            new donate = DP[2][playerid];
            if(!response) return dialogPetInformation(playerid,pet);
            if(strlen(inputtext) < 0 || strlen(inputtext) > 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Кличка не меньше 0 и не больше 20 символов"), dialogPetInformation(playerid,pet);
		    if(checksimvol(inputtext)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я использую запрещённый символ [ Только буквы, цифры и стандартные символы ]"), dialogPetInformation(playerid,pet);
            if(PlayerInfo[playerid][pDonateMoney] < 90) return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: У меня недостаточно золота!"), dialogPetInformation(playerid,pet);
            format(PetInfo[pet][petName],20, inputtext);
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я успешно сменил кличку своему питомцу!");
            if(donate) PlayerInfo[playerid][pDonateMoney] -= 90, mysql_save(playerid, 4), tclArifmetikAllGold -= 90;
        }
        case PETS_ZOOSHOP:{
            if(!response) return false;
            else{
                switch(listitem)
                {
                    case 0: dialogPetsListZoo(playerid);
                    case 1: {
                        if(oGetPlayerMoney(playerid) < friskPrice[283]) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
                        oGivePlayerMoney(playerid, -friskPrice[283]);
                        GiveThingPlayer(playerid, 283, 1, 0, 0, 0, 0, 9999);
                        SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Я купил лекарство для питомца за %d$",friskPrice[280]);
                        MoneyLog("ZooShop", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", friskPrice[283], "Купил предмет");
                        dialogPetZooShop(playerid);
                        PlayerPlaySound(playerid,6401,0,0,0);
                    }
                    case 2: {
                        if(oGetPlayerMoney(playerid) < friskPrice[280]) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
                        oGivePlayerMoney(playerid, -friskPrice[280]);
                        GiveThingPlayer(playerid, 280, 1, 0, 0, 0, 0, 9999);
                        SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Я купил корм для питомца за %d$",friskPrice[280]);
                        MoneyLog("ZooShop", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", friskPrice[280], "Купил предмет");
                        dialogPetZooShop(playerid);
                        PlayerPlaySound(playerid,6401,0,0,0);
                    }
                    case 3: {
                        if(oGetPlayerMoney(playerid) < friskPrice[281]) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
                        oGivePlayerMoney(playerid, -friskPrice[281]);
                        GiveThingPlayer(playerid, 281, 1, 0, 0, 0, 0, 9999);
                        SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Я купил корм для питомца за %d$",friskPrice[281]);
                        MoneyLog("ZooShop", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", friskPrice[281], "Купил предмет");
                        dialogPetZooShop(playerid);
                        PlayerPlaySound(playerid,6401,0,0,0);
                    }
                    case 4:{
                        if(PlayerInfo[playerid][pDonateMoney] < PRICE_FEATURES_PET) return pc_cmd_donate(playerid), ErrorText(playerid, "[ Мысли ]: Мне не хватает золота");
                        PlayerInfo[playerid][pDonateMoney] -= PRICE_FEATURES_PET;
                        tclArifmetikAllGold -= PRICE_FEATURES_PET;
                        mysql_save(playerid, 4);
                        GiveThingPlayer(playerid, 282, 1, 0, 0, 0, 0, 9999);
                        SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Я купил корм для питомца за %d GOLD",PRICE_FEATURES_PET);
                        MoneyLog("ZooShop", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", PRICE_FEATURES_PET, "Купил предмет за GOLD");
                        dialogPetZooShop(playerid);
                        PlayerPlaySound(playerid,6401,0,0,0);
                    }
                    case 5:{
                        DP[0][playerid] = 3;
                        new line[214],lines[4096];
                        format(line,sizeof(line),"{ff9000}Вы хотите приобрести {ff9000}Питомцев {cccccc}шкатулку?"), strcat(lines,line);
                        format(line,sizeof(line),"\n{cccccc}Стоимость: {ffcc00}%dG", donatePrice[19]), strcat(lines,line);
                        format(line,sizeof(line),"\n\n{ffcc66}Что может выпасть в шкатулке?"), strcat(lines,line);
                        format(line,sizeof(line),"\n{ff9000}- Только редкие питомцы которых нельзя приручить с улицы"), strcat(lines,line);
                        ShowDialog(playerid,440,DIALOG_STYLE_MSGBOX,"{ff9000}Donate",lines,"Да","Нет");
                    }
                }
            }
        }
        case PETS_SELECTZOO:{
            if(!response) return true;
            new loadtype = ListParam[listitem][playerid];
            if(loadtype != 0) return ErrorMessage(playerid,"{ff6347}Данный питомец загружен, его нельзя воскрестить");
            else{
                new inva = List[listitem][playerid];
                if(PlayerInfo[playerid][pInvenPara][inva] == 0) return ErrorMessage(playerid,"{ff6347}Данный питомец не имеет ID, его нельзя воскрестить");
                new string_mysql[840];
                mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT * FROM `pets` WHERE `petID` = '%d'", PlayerInfo[playerid][pInvenPara][inva]);
                mysql_tquery(pearsq, string_mysql, "GetPetStats", "ddd",playerid, g_MysqlRaceCheck[playerid], PlayerInfo[playerid][pInvenPara][inva]);
            }
        }
    }
    return false;
}

function GetPetStats(playerid, race_check, petid)
{
    new rows;
	cache_get_row_count(rows);

	if(rows)
	{
	    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);
        new Float:tempHealth, tempHunger;
        cache_get_value_name_float(0,"petHealth",tempHealth);
        cache_get_value_name_int(0,"petHunger",tempHunger);
        if(tempHealth > 0.0 && tempHunger > 0) return ErrorMessage(playerid,"Данного питомца нельзя воскрестить, у него полное здоровье!");
        else{
            tempHunger = 5;
            tempHealth = 50.0;
            if(oGetPlayerMoney(playerid) < PRICE_RESURRECT) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
            oGivePlayerMoney(playerid, -PRICE_RESURRECT);
            MoneyLog("ZooShop", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", friskPrice[280], "Купил предмет");
            SuccessMessage(playerid, "{44ff99}Я успешно воскрестил своего питомца.\nТеперь мне нужно пополнить ему здоровье и покормить его!");
            new string_mysql[840];
            mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pets` SET `petHunger`= '%d',`petHealth`= '%f',`petUnixLastEating`= '%d' WHERE `petID` = '%d'",
            tempHunger,tempHealth, gettime()+1200, petid);
            mysql_tquery(pearsq, string_mysql);
        }
    }
    else ErrorMessage(playerid,"Питомец не найден. Обратитесь к администрации!");
    return true;
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
            new id = FindPet(PetInfo[OnlineInfo[playerid][oPet][pet]][petType]);
            format(line,sizeof(line),"{cccccc}%d. %s\n", quan + 1, GetSkinName(PetsParam[id][2])), strcat(lines,line);
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
	new lines[240], string[60];
	format(lines,sizeof(lines),"\n{cccccc}Что за кошки/собаки гуляют по улицам?\n"\
                                "\n{cccccc}Что за питомцы и чем они полезны?"\
                                "\n{cccccc}Способности питомцев");
	format(string,sizeof(string),"{ff9000}Питомцы");
	ShowDialog(playerid,PETS_HELP,DIALOG_STYLE_TABLIST, string, lines, "Выбрать", "Отмена");
	return true;
}

stock dialogPetRepleceFeatures(playerid,pet, features)
{
    DP[0][playerid] = pet;
    DP[1][playerid] = features;
	new lines[1020], string[60];
	format(lines,sizeof(lines),"\n{ff9000}Вам выпала способность %s%s\n"\
                                "\n{cccccc}Данная способность дает следующие бонусы или шанс на срабатывание: %s%d%%"\
                                "\n{cccccc}%s\n\n"\
                                "{ff9000}Хотите оставить данную способность?",
                                PetsFeaturesColor[PetsFeaturesSetting[features][0]], PetsFeaturesName[features],PetsFeaturesColor[PetsFeaturesSetting[features][0]],
                                PetsFeaturesSetting[features][1], PetsFeaturesDescription[features]);
	format(string,sizeof(string),"{ff9000}Питомцы");
	ShowDialog(playerid,PETS_SHOW_FEATURES_ACCEPT,DIALOG_STYLE_MSGBOX, string, lines, "Да", "Нет");
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
                                "\n{cccccc}- У питомцев так же есть несколько способностей, разных уровней: %sБазовые, %sРедкие, %sЛегендарные"\
								"\n{cccccc}Примеры способностей можно посмотреть в /help > Питомцы > Особенности питомцев"\
                                "\n{cccccc}Получить способность можно покормив питомца 'Лакомством для питомца'(Покупается в магазине 4 Лапы)"\
                                "\n{cccccc}- Можно иметь только двух загруженных питомцев."\
                                "\n{cccccc}- В данный момент на сервере есть %d разных видов питомцев.\n"\
                                "\n{ff6347}ВНИМАНИЕ!!"\
                                "\n{cccccc}- Если питомца не кормить, то он умрет. Не совершайте ошибок, ухаживайте за братьями нашими меньшими!"\
                                "\n{cccccc}- Если питомец потерял хп, то его можно будет вылечить специальным лекарством."\
                                "\n{cccccc}Лекарство можно купить в магазине 4 Лапы, там же можно воскрестить мертвого питомца!",PetsFeaturesColor[0],PetsFeaturesColor[1],PetsFeaturesColor[2], MAX_PETS_TYPE - 1);
	format(string,sizeof(string),"{ff9000}Что дают питомцы?");
	ShowDialog(playerid,PETS_HELP_LIST,DIALOG_STYLE_MSGBOX, string, lines, "Назад", "");
	return true;
}

stock dialogInformationPetsFeatures(playerid)
{
	new line[120],lines[120*sizeof(PetsFeaturesName)+500];

    for(new i = 1; i < sizeof(PetsFeaturesName); i++)
    {
        format(line,sizeof(line),"{ffffff}%d. %s%s\t{cccccc}Эффект: %d%%\n",i,PetsFeaturesColor[PetsFeaturesSetting[i][0]], PetsFeaturesName[i], PetsFeaturesSetting[i][1]), strcat(lines,line);
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
    if(pet != -1) PetHunger(pet, 10), HandlerCreateTaskPets(pet, PET_TASK_WALKING);

    for (new i = 0; i <= 5; i++) TextDrawHideForPlayer(playerid, InputDraw[i]);
    PlayerTextDrawHide(playerid, InputDraw1);
	PlayerTextDrawHide(playerid, InputDraw2);

    return 1;
}


CMD:givepetexp(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    for(new i = 0; i < MAX_PETS_AT_PLAYER; i++)
    {
        if(OnlineInfo[playerid][oPet][i] >= 0)
        {
            GivePetsExp(OnlineInfo[playerid][oPet][i], 25);
        }
    }
    return true;
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

    SavePet(PetInfo[pet][petPlayer],pet);
    return true;
}

stock PetHunger(pet, hunger)
{
    PetInfo[pet][petHunger] -= hunger;
    if(PetInfo[pet][petHunger] < 0) PetInfo[pet][petHunger] = 0;
    SavePet(PetInfo[pet][petPlayer],pet);
    return true;
}

stock LoadPetFeaturesQuan()
{
    for(new pet_FeaturesQuality:i; i < pet_FeaturesQuality; i++)
    {
        for(new features = 1; features < sizeof(PetsFeaturesName); features++)
        {
            if(PetsFeaturesSetting[features][0] == _:i) QuanFeatures[i]++;
        }
    }
    printf("[MODE]: Способности питомцев загружены [L:%d][R:%d][U:%d]", QuanFeatures[2], QuanFeatures[1], QuanFeatures[0]);
    return true;
}
stock PetRandomFeatures(playerid, pet)
{
    new chance = PetInfo[pet][petLevel]/10;
    new pet_FeaturesQuality: features;
    new selectFeatures = 0;
    new chanceRandom = 100;

    if(GetPetParam(PetInfo[pet][petType])) chanceRandom = 50;
    if(chanceRandom == 100)
    {
        if(chance >= 100) chance = 99;
    }
    else if(chanceRandom == 50)
    {
        if(chance >= 50) chance = 40;
    }

    switch(random(chanceRandom-chance))
    {
        case 0..1: features = PET_FEATURES_LEGENDARY;
        case 2..30: features = PET_FEATURES_RARE;
        default: features = PET_FEATURES_USUAL;
    }

    new tempQuan = 0;
    switch(features)
    {
        case PET_FEATURES_LEGENDARY:{
            new randomQuan = random(QuanFeatures[2]);
            for(new i = 1; i < sizeof(PetsFeaturesName); i++)
            {
                if(PetsFeaturesSetting[i][0] == _:PET_FEATURES_LEGENDARY) tempQuan++;
                if(tempQuan == randomQuan) 
                {
                    selectFeatures = i;
                    break;
                }
            }
        }
        case PET_FEATURES_RARE:{
            new randomQuan = random(QuanFeatures[1]);
            for(new i = 1; i < sizeof(PetsFeaturesName); i++)
            {
                if(PetsFeaturesSetting[i][0] == _:PET_FEATURES_RARE) tempQuan++;
                if(tempQuan == randomQuan) 
                {
                    selectFeatures = i;
                    break;
                }
            }
        }
        case PET_FEATURES_USUAL:{
            new randomQuan = random(QuanFeatures[0]);
            for(new i = 1; i < sizeof(PetsFeaturesName); i++)
            {
                if(PetsFeaturesSetting[i][0] == _:PET_FEATURES_USUAL) tempQuan++;
                if(tempQuan == randomQuan) 
                {
                    selectFeatures = i;
                    break;
                }
            }
        }
    }
    if(selectFeatures == 0) selectFeatures = 1;
    return dialogPetRepleceFeatures(playerid, pet, selectFeatures);
}

stock PetSetFeaturesOrChoiceSlot(playerid,pet,features)
{
    new slot = -1;
    for(new i = 0; i < PetInfo[pet][petDonateFeatures]; i++)
    {
        if(PetInfo[pet][petFeatures][i] == 0)
        {
            slot = i;
            break;
        }
    }
    if(slot == -1) return dialogPetsFeatures(playerid,pet,features);
    PetInfo[pet][petFeatures][slot] = features;
    SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Мой питомец получил новую способность");
    dialogPetsFeatures(playerid,pet);
    SavePet(playerid,pet);
    return true;
}

stock SetPetHealth(pet)
{
    new id = FindPet(PetInfo[pet][petType]);
    new Float:healthPet = float(PetsParam[id][1]);
    SendClientMessageToAll(-1, "Pet health: %f", healthPet);
    healthPet += float(5*(PetInfo[pet][petEndurance]+PetInfo[pet][petPower]));
    SendClientMessageToAll(-1, "Pet health 2: %f", healthPet);
    SetNpcHealth(PetInfo[pet][petID], healthPet);
    PetInfo[pet][petHealth] = healthPet;
    SavePet(PetInfo[pet][petPlayer],pet);
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
    if(HoldStat[playerid] != 262 && (HoldStat[playerid] < 280 || HoldStat[playerid] > 283))
    {
        SetPVarInt(playerid, "pet", 0), SetPVarInt(playerid, "oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0);
        return ErrorMessage(playerid, "{ff6347}Вы убрали предмет из рук, кормление прервано!");
    }
	if(GetPVarInt(playerid,"oryjtemp") >= 10)
	{
	 	GameTextForPlayer(playerid, RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Кормление: ~w~10/10"), 1500, 3);

        if(HoldStat[playerid] == 262 || (HoldStat[playerid] >= 280 && HoldStat[playerid] <= 281))
        {
            if(HoldStat[playerid] == 262)
            {
                PetInfo[pet][petHunger]+=5;
            }
            else
            {
                if(PetInfo[pet][petHunger] <= 80) PetInfo[pet][petHunger] += 10;
                else PetInfo[pet][petHunger] = 100;
                PetInfo[pet][petPlayingUnix] -= 7200;
            }
        }
        else if(HoldStat[playerid] == 282) PetRandomFeatures(playerid, pet);
        else if(HoldStat[playerid] == 283) SetPetHealth(pet);

        ClearPlayerInven(playerid, HoldInva[playerid]);
	    Hold[playerid] = 0, HoldStat[playerid] = 0, HoldQuan[playerid] = 0, HoldInva[playerid] = -1;
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

    if((HoldStat[playerid] > 283 || HoldStat[playerid] < 280) && HoldStat[playerid] != 262) return ErrorMessage(playerid,"{ff6347}У меня в руках нет предмета для взаимодействия с питомцем!");
    else
    {
        if(HoldStat[playerid] == 262) // Колбаса
        {
            if(HoldPara[playerid] < gettime()) return ErrorMessage(playerid,"{ff6347}У вас в руках испорченная колбаса. Нужно приготовить свежею\n\nКолбасу можно приготовить на кухонной плите!");
            if(PetInfo[pet][petHunger] > 80) return ErrorMessage(playerid, "{FF6347}Питомец не голоден. Попробуйте позже!");
        }
        if(HoldStat[playerid] == 280 || HoldStat[playerid] == 281)
        {
            if(IsAPetType(pet) == 2 && HoldStat[playerid] == 281) return ErrorMessage(playerid,"Зачем мне кормить кошку, собачьим кормом?");
            if(IsAPetType(pet) == 1 && HoldStat[playerid] == 280) return ErrorMessage(playerid,"Зачем мне кормить собаку, кошачьим кормом?");
            if(HoldPara[playerid] < gettime()) return ErrorMessage(playerid,"{ff6347}У вас в руках испорченная консерва!\nЕё можно только выкинуть");
        }
    }
    
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
            return true;
        }    
    }
    return false;
}

stock PetPlaySound(pet, pet_Sound: typesound)
{
    if(!IsValidNpc(PetInfo[pet][petID])) return false;
    if(PetInfo[pet][petSoundUnix] > gettime()) return false;
    PetInfo[pet][petSoundUnix] = gettime()+10;
    new Float:PetX, Float:PetY, Float:PetZ;
    GetNpcPosition(PetInfo[pet][petID],PetX,PetY,PetZ);
    new npcworld = GetNpcVirtualWorld(PetInfo[pet][petID]);
    new type = IsAPetType(pet);
    foreach(Player,playerid)
    {
        if(!IsPlayerConnected(playerid)) continue;
        if(OnlineInfo[playerid][oListenRadioPears] != 0) continue;
        if(!IsPlayerInRangeOfPoint(playerid,30.0,PetX,PetY,PetZ)) continue;
        if(GetPlayerVirtualWorld(playerid) != npcworld) continue;
        if(IsPlayerAfk(playerid)) continue;
        if(typesound == PET_SOUND_ANGRY)
        {
            if(type == 1) // Собаки
            {
                switch(random(3))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/gaf0.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/gaf1.mp3",PetX,PetY,PetZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/gaf2.mp3",PetX,PetY,PetZ, 30.0, true);
                }
            }
            else if(type == 2) // Кошки
            {
                switch(random(3))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "http://cdn.pears.fun/sound/animals/cat/fr0.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "http://cdn.pears.fun/sound/animals/cat/fr1.mp3",PetX,PetY,PetZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "http://cdn.pears.fun/sound/animals/cat/fr2.mp3",PetX,PetY,PetZ, 30.0, true);
                }
            }
        }
        else if(typesound == PET_SOUND_CRY)
        {
            if(type == 1) // Собаки
            {
                switch(random(9))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/cry0.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/cry1.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 2: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/cry2.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 3: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/cry3.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 4: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/cry4.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 5: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/cry5.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 6: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/cry6.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 7: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/cry7.mp3",PetX,PetY,PetZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/cry8.mp3",PetX,PetY,PetZ, 30.0, true);
                }
            }
            else if(type == 2) // Кошки
            {
                switch(random(5))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "http://cdn.pears.fun/sound/animals/cat/cry0.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "http://cdn.pears.fun/sound/animals/cat/cry1.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 2: PlayAudioStreamForPlayer(playerid, "http://cdn.pears.fun/sound/animals/cat/cry2.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 3: PlayAudioStreamForPlayer(playerid, "http://cdn.pears.fun/sound/animals/cat/cry3.mp3",PetX,PetY,PetZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "http://cdn.pears.fun/sound/animals/cat/cry4.mp3",PetX,PetY,PetZ, 30.0, true);
                }
            }
        }
        else if(typesound == PET_SOUND_HAPPY)
        {
            if(type == 1) // Собаки
            {
                switch(random(3))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/funny_gaf.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/game.mp3",PetX,PetY,PetZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/heh0.mp3",PetX,PetY,PetZ, 30.0, true);
                }
            }
            else if(type == 2) // Кошки
            {
                switch(random(3))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/cat/mrr0.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/cat/mrr1.mp3",PetX,PetY,PetZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/cat/mrr2.mp3",PetX,PetY,PetZ, 30.0, true);
                }
            }
        }
        else if(typesound == PET_SOUND_SNIFF)
        {
            if(type == 1) // Собаки
            {
                PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/sniffs0.mp3",PetX,PetY,PetZ, 30.0, true);
            }
            else if(type == 2) // Кошки
            {
                switch(random(3))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/cat/mrr0.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/cat/mrr1.mp3",PetX,PetY,PetZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/cat/mrr2.mp3",PetX,PetY,PetZ, 30.0, true);
                }
            }
        }
        else if(typesound == PET_SOUND_VERYANGRY)
        {
            if(type == 1) // Собаки
            {
                switch(random(3))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/rik0.mp3",PetX,PetY,PetZ, 30.0, true);
                    case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/rik1.mp3",PetX,PetY,PetZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/dog/rik2.mp3",PetX,PetY,PetZ, 30.0, true);
                }
            }
            else if(type == 2) // Кошки
            {
                switch(random(2))
                {
                    case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/cat/scream0.mp3",PetX,PetY,PetZ, 30.0, true);
                    default: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/animals/cat/scream1.mp3",PetX,PetY,PetZ, 30.0, true);
                }
            }
        }
    }
    return true;
}

stock UsePetItem(playerid, inva)
{
    if(Hold[playerid] == 262 || (Hold[playerid] >= 280 && Hold[playerid] <= 283))
    {
        Hold[playerid] = 0, HoldStat[playerid] = 0, HoldFrisk[playerid] = 0, HoldQuan[playerid] = 0, HoldInva[playerid] = 0, HoldPara[playerid] = 0, HoldQara[playerid] = 0;
        RemovePlayerAttachedObject(playerid,1), PlayerPlaySound(playerid,5601,0,0,0), ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0, false, true, true, false, false);
        return 1;
    }
    if(howstun(playerid)) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
    if(!IsPlayerInAnyVehicle(playerid) && GetPlayerSpeed(playerid) > 3) return ErrorMessage(playerid, "{FF6347}Нельзя достать предмет в движении");
    if(Hand[playerid] > 0 || Hold[playerid] > 0 || (GetPlayerWeapon(playerid) >= WEAPON:2 && GetPlayerWeapon(playerid) != WEAPON:46) || OnlineInfo[playerid][oInHandThing][0] > 0
    || Piss[playerid] == 6 || Piss[playerid] == 2 || Piss[playerid] == 1 || Sleep[playerid] >= 1
    || SleepRP[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Ваш персонаж не может сейчас достать предмет [ Заняты руки или выполняется действие ]");

    new string[400];
    format(string, sizeof(string), "{ffcc66}Вы взяли в руки %s {ff9000}[ Это предмет для взаимодействия с питомцами ]\n{cccccc}Подойдите к вашему питомцу и начните взаимодействовать с ним: Кнопка ALT\n{cccccc}Далее кличкайте %s для взаимодействия",friskName[PlayerInfo[playerid][pInven][inva]], buttonName[Device[playerid]]);
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",string,"*","");
    in_hand_item(playerid, inva, PlayerInfo[playerid][pInven][inva], PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenQara][inva], PlayerInfo[playerid][pInvenQuan][inva]);
    return 1;
}

stock OnPlayerLoadPet(playerid,slot, pet, inva)
{
    if(!IsAPetExisting(PlayerInfo[playerid][pInven][inva]))
    {
        OnlineInfo[playerid][oPet][slot] = -1;
        OnlineInfo[playerid][oPetID][slot] = -1;
        OnlineInfo[playerid][oPetLoad] = 0;
        return ErrorMessage(playerid, "{ff6347}Питомец не загружен. Предмет в инвентаре переместился");
    }
    cache_get_value_name_int(0,"petID",PetInfo[pet][petNewID]);
    OnlineInfo[playerid][oPetID][slot] = PetInfo[pet][petNewID];
    PlayerInfo[playerid][pInvenPara][inva] = PetInfo[pet][petNewID];
    PetInfo[pet][petType] = PlayerInfo[playerid][pInven][inva];
    SaveInvent(playerid, inva);

	cache_get_value_name(0,"petName",PetInfo[pet][petName], 24);
    cache_get_value_name_int(0,"petHunger",PetInfo[pet][petHunger]);
    cache_get_value_name_int(0,"petLevel",PetInfo[pet][petLevel]);
    cache_get_value_name_int(0,"petExp",PetInfo[pet][petExp]);
    cache_get_value_name_int(0,"petPoint",PetInfo[pet][petPoint]);
    cache_get_value_name_int(0,"petPower",PetInfo[pet][petPower]);
    cache_get_value_name_int(0,"petAgility",PetInfo[pet][petAgility]);
    cache_get_value_name_int(0,"petEndurance",PetInfo[pet][petEndurance]);
    if(PetInfo[pet][petPower] == 0) PetInfo[pet][petPower] = 1;
    if(PetInfo[pet][petAgility] == 0) PetInfo[pet][petAgility] = 1;
    if(PetInfo[pet][petEndurance] == 0) PetInfo[pet][petEndurance] = 1;

    cache_get_value_name_int(0,"petDonateFeatures",PetInfo[pet][petDonateFeatures]);
    if(PetInfo[pet][petDonateFeatures] == 0) PetInfo[pet][petDonateFeatures] = 2;

    cache_get_value_name_int(0,"petPlayingUnix",PetInfo[pet][petPlayingUnix]);
    cache_get_value_name_int(0,"petUnixLastEating",PetInfo[pet][petUnixLastEating]);
    cache_get_value_name_float(0,"petHealth",PetInfo[pet][petHealth]);

    if(PetInfo[pet][petHealth] <= 0.0)
    {
        OnlineInfo[playerid][oPet][slot] = -1;
        OnlineInfo[playerid][oPetID][slot] = -1;
        OnlineInfo[playerid][oPetLoad] = 0;
        return ErrorMessage(playerid, "{ff6347}Питомец не загружен. У него нет здоровья!\nВоскрестить питомца можно в зоомагазине!");
    }
    if(PetInfo[pet][petHunger] <= 0)
    {
        OnlineInfo[playerid][oPet][slot] = -1;
        OnlineInfo[playerid][oPetID][slot] = -1;
        OnlineInfo[playerid][oPetLoad] = 0;
        return ErrorMessage(playerid, "{ff6347}Питомец не загружен. У него нет здоровья!\nВоскрестить питомца можно в зоомагазине!");
    }
    new bool:is_null = false;
    cache_is_value_name_null(0, "petFeatures", is_null);

    if(is_null == false)
    {
        new string_json[512];
        cache_get_value_name(0, "petFeatures", string_json, 512);

        new JsonNode:node = JSON_INVALID_NODE;
        if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
        {
            JSON_GetInt(node, "features0", PetInfo[pet][petFeatures][0]);
            JSON_GetInt(node, "features1", PetInfo[pet][petFeatures][1]);
            JSON_GetInt(node, "features2", PetInfo[pet][petFeatures][2]);
            JSON_GetInt(node, "features3", PetInfo[pet][petFeatures][3]);
            JSON_GetInt(node, "features4", PetInfo[pet][petFeatures][4]);
            JSON_GetInt(node, "features5", PetInfo[pet][petFeatures][5]);
            JSON_GetInt(node, "features6", PetInfo[pet][petFeatures][6]);
            JSON_GetInt(node, "features7", PetInfo[pet][petFeatures][7]);
            JSON_GetInt(node, "features8", PetInfo[pet][petFeatures][8]);
            JSON_GetInt(node, "features9", PetInfo[pet][petFeatures][9]);
        }
    }

    is_null = false;
    cache_is_value_name_null(0, "petSkills", is_null);
    if(is_null == false)
    {
        new string_json[512];
        cache_get_value_name(0, "petSkills", string_json, 512);

        new JsonNode:node = JSON_INVALID_NODE;
        if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
        {
            JSON_GetInt(node, "PET_SKILL_VOICE", PetInfo[pet][petSkills][PET_SKILL_VOICE]);
            JSON_GetInt(node, "PET_SKILL_ATTAC", PetInfo[pet][petSkills][PET_SKILL_ATTAC]);
            JSON_GetInt(node, "PET_SKILL_FOLLOWME", PetInfo[pet][petSkills][PET_SKILL_FOLLOWME]);
            JSON_GetInt(node, "PET_SKILL_SNIFF", PetInfo[pet][petSkills][PET_SKILL_SNIFF]);
            JSON_GetInt(node, "PET_SKILL_SIT", PetInfo[pet][petSkills][PET_SKILL_SIT]);
            JSON_GetInt(node, "PET_SKILL_SITCAR", PetInfo[pet][petSkills][PET_SKILL_SITCAR]);
        }
    }
    if(PetInfo[pet][petSkills][PET_SKILL_FOLLOWME] == 0) PetInfo[pet][petSkills][PET_SKILL_FOLLOWME] = 10;
    CreatePet(playerid,pet);
	return 1;
}

function OnPlayerPetLoad(playerid, race_check,slot, pet, inva)
{
	new rows;
	cache_get_row_count(rows);

	if(rows)
	{
	    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);
		OnPlayerLoadPet(playerid,slot, pet, inva);
	}
	return 1;
}

stock SavePet(playerid, pet)
{
	new JsonNode:nodeFeatures, JsonNode:nodeSkills;
	CreateJsonPetFeatures(pet, nodeFeatures);
    CreateJsonPetSkills(pet, nodeSkills);
    new string_jsonFeatures[512], string_jsonSkills[512];
    if (JSON_Stringify(nodeFeatures, string_jsonFeatures) == JSON_CALL_NO_ERR && JSON_Stringify(nodeSkills, string_jsonSkills) == JSON_CALL_NO_ERR) 
    {
        new string_mysql[840];
        mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pets` SET `petName`= '%e',`petHunger`= '%d',`petLevel`= '%d',`petExp`= '%d',\
        `petPoint`= '%d',`petPower`= '%d',`petAgility`= '%d',`petEndurance`= '%d',`petFeatures`= '%e',`petSkills`= '%e',`petDonateFeatures` ='%d',\
        `petPlayingUnix`= '%d',`petUnixLastEating`= '%d',`petType`= '%d',`petHealth`= '%f',`petLastUserName`= '%e',`petLastUserID`= '%d' WHERE `petID` = '%d'",
        PetInfo[pet][petName], PetInfo[pet][petHunger], PetInfo[pet][petLevel], PetInfo[pet][petExp], 
        PetInfo[pet][petPoint], PetInfo[pet][petPower], PetInfo[pet][petAgility], PetInfo[pet][petEndurance], string_jsonFeatures, string_jsonSkills, PetInfo[pet][petDonateFeatures],
        PetInfo[pet][petPlayingUnix], PetInfo[pet][petUnixLastEating], PetInfo[pet][petType], PetInfo[pet][petHealth],PlayerInfo[playerid][pName],PlayerInfo[playerid][pID], PetInfo[pet][petNewID]);
        mysql_tquery(pearsq, string_mysql);
    }
	return 1;
}

stock CreateJsonPetFeatures(pet, &JsonNode:node)
{
	node = JSON_Object(
        "features0", JSON_Int(PetInfo[pet][petFeatures][0]),
        "features1", JSON_Int(PetInfo[pet][petFeatures][1]),
        "features2", JSON_Int(PetInfo[pet][petFeatures][2]),
        "features3", JSON_Int(PetInfo[pet][petFeatures][3]),
        "features4", JSON_Int(PetInfo[pet][petFeatures][4]),
        "features5", JSON_Int(PetInfo[pet][petFeatures][5]),
        "features6", JSON_Int(PetInfo[pet][petFeatures][6]),
        "features7", JSON_Int(PetInfo[pet][petFeatures][7]),
        "features8", JSON_Int(PetInfo[pet][petFeatures][8]),
        "features9", JSON_Int(PetInfo[pet][petFeatures][9])
	);

	return 1;
}

stock CreateJsonPetSkills(pet, &JsonNode:node)
{
	node = JSON_Object(
        "PET_SKILL_VOICE", JSON_Int(PetInfo[pet][petSkills][PET_SKILL_VOICE]),
        "PET_SKILL_ATTAC", JSON_Int(PetInfo[pet][petSkills][PET_SKILL_ATTAC]),
        "PET_SKILL_FOLLOWME", JSON_Int(PetInfo[pet][petSkills][PET_SKILL_FOLLOWME]),
        "PET_SKILL_SNIFF", JSON_Int(PetInfo[pet][petSkills][PET_SKILL_SNIFF]),
        "PET_SKILL_SIT", JSON_Int(PetInfo[pet][petSkills][PET_SKILL_SIT]),
        "PET_SKILL_SITCAR", JSON_Int(PetInfo[pet][petSkills][PET_SKILL_SITCAR])
	);

	return 1;
}

function Call_getidPet(playerid,slot, inva) {
	OnlineInfo[playerid][oPetID][slot] = cache_insert_id();
	new string_mysql[256];
    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT * FROM `pets` WHERE `petID` = '%d'", OnlineInfo[playerid][oPetID][slot]);
    mysql_tquery(pearsq, string_mysql, "OnPlayerPetLoad", "ddddd",playerid, g_MysqlRaceCheck[playerid],slot, OnlineInfo[playerid][oPet][slot],inva);
    return 1;
}

stock Pet_OnNpcGiveDamageNpc(NPC:npc, NPC:damager, Float:amount, weaponid, bodypart)
{
    #pragma unused weaponid
    #pragma unused bodypart
    new npc_id_takedamage = -1, npc_id_givedamage = -1;
    for (new i = 0; i < MAX_PETS; i++)
    {
        if (PetInfo[i][petID] == npc)
        {
            npc_id_takedamage = i;
            break;
        }
    }

    for (new i = 0; i < MAX_PETS; i++)
    {
        if (PetInfo[i][petID] == damager)
        {
            npc_id_givedamage = i;
            break;
        }
    }
    
    if(npc_id_takedamage >= 0)
    {
        if(npc_id_givedamage != -1){
            if(IsAPetType(npc_id_givedamage) == 1) amount = 5.0;
            else amount = 3.0;

            amount *= float(PetInfo[npc_id_givedamage][petPower]);
            if(PetSkillHandler(npc_id_givedamage, 2)) amount += amount * float(PetsFeaturesSetting[2][1]/100);

            amount /= float(PetInfo[npc_id_takedamage][petAgility] + PetInfo[npc_id_takedamage][petEndurance]);

            new Float:tempHealth = 0.0;

            GetNpcHealth(npc, tempHealth);
            tempHealth -= amount;
            SetNpcHealth(npc, tempHealth);
            PetInfo[npc_id_takedamage][petHealth] = tempHealth;
        }
        return true;
    }
    return false;
}

stock Pet_OnPlayerGiveDamageNpc(NPC: npc, damagerid, Float: amount, weaponid, bodypart)
{
    #pragma unused amount
    #pragma unused damagerid
    #pragma unused weaponid
    #pragma unused bodypart
    
    new npc_id = -1;
    for (new i = 0; i < MAX_PETS; i++)
    {
        if (PetInfo[i][petID] == npc)
        {
            npc_id = i;
            break;
        }
    }

    if (npc_id > -1)
    {
        if(PetSkillHandler(npc_id, 3))
        {
            new rand = random(100);
            if(rand >= 0 && rand <= PetsFeaturesSetting[3][1]) return true;
        }
        new Float:tempHealth = 0.0;
        GetNpcHealth(PetInfo[npc_id][petID], tempHealth);
        tempHealth -= amount;
        PetInfo[npc_id][petHealth] = tempHealth;
        SetNpcHealth(PetInfo[npc_id][petID], tempHealth);

        return false;
    }

    return true;
}

stock Pet_OnPlayerTakeDamageNpc(NPC:npc, issuerid, Float:amount, weaponid, bodypart)
{
    #pragma unused amount
    #pragma unused weaponid
    #pragma unused bodypart
    
    new npc_id = -1;
    for (new i = 0; i < MAX_PETS; i++)
    {
        if (PetInfo[i][petID] == npc)
        {
            npc_id = i;
            break;
        }
    }

    if(npc_id >= 0)
    {
        new Float:damage;
        if(IsAPetType(npc_id) == 1) damage = 5.0;
        else damage = 3.0;
        damage *= PetInfo[npc_id][petPower];
        if(PetSkillHandler(npc_id, 2)) damage += damage * float(PetsFeaturesSetting[2][1]/100);
        new Float: health = HealthAC[issuerid] - damage;

        if(PetSkillHandler(npc_id, 1))
        {
            new rand = random(100);
            if(rand >= 0 && rand <= PetsFeaturesSetting[1][1]) infect(issuerid, 8, 2000);
        }
        ACSetPlayerHealth(issuerid, health);

        return 0;
    }
    return 1;
}

stock PetSkillHandler(pet, skill)
{
    new bool:yes = false;
    for(new featur; featur < MAX_PETS_FEATURES; featur++)
    {
        if(PetInfo[pet][petFeatures][featur] == skill) 
        {
            yes = true;
            break;
        }
    }
    return yes;
}
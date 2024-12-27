
#define PRICE_GYM 6900 // Стоимость абонемента в спортзал на 7 дней

//=================================================================
//=========================== Гантели =============================

/* 
Как добавить местоположение новой гантели?
- Просто добавить координаты, world и interior в DumbbellsPos
*/

enum DUMBBELLSINFO { Float:Dumb_X, Float:Dumb_Y, Float:Dumb_Z, World, Interior }
new DumbbellsPos[][DUMBBELLSINFO] =
{
    // Спортзал
    { 1750.771118, -1231.240966, 80.646705, WORLD_GYM, INT_GYM },
    { 1750.771118, -1228.211181, 80.646705, WORLD_GYM, INT_GYM },
    { 1750.771118, -1225.241210, 80.646705, WORLD_GYM, INT_GYM },
    { 1742.880371, -1213.900878, 81.606719, WORLD_GYM, INT_GYM },
    { 1742.880371, -1211.410888, 81.606719, WORLD_GYM, INT_GYM },
    { 1742.880371, -1208.910522, 81.606719, WORLD_GYM, INT_GYM },
    { 1742.880371, -1206.400634, 81.606719, WORLD_GYM, INT_GYM },

    // Тюрьма
    { 1020.114685, 2450.089355, 9.987168, 0, 0 }, // Улица

    // Спортзал Департамента (Sportshall)
    { 1378.507568, -15.214787, 1500.477636, -1, 248 }
};

stock CreateDumbbells()
{
    for(new i = 0; i < sizeof(DumbbellsPos); i++)
	{
        CreateDynamic3DTextLabel("{0088ff}Гантели {cccccc}ALT", 0xFFFFFFFF, DumbbellsPos[i][Dumb_X], DumbbellsPos[i][Dumb_Y], DumbbellsPos[i][Dumb_Z],3.0,
            INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,DumbbellsPos[i][World],DumbbellsPos[i][Interior]);
    }
    return true;
}

// Ищем гантели рядом
stock IsADumbbells(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return false;

    for(new i = 0; i < sizeof(DumbbellsPos); i++)
	{
        if(IsPlayerInRangeOfPoint(playerid, 1.0, DumbbellsPos[i][Dumb_X], DumbbellsPos[i][Dumb_Y], DumbbellsPos[i][Dumb_Z])
            && (DumbbellsPos[i][World] == -1 || GetPlayerVirtualWorld(playerid) == DumbbellsPos[i][World])
            && GetPlayerInterior(playerid) == DumbbellsPos[i][Interior])
        {
            return true;
        }
    }
	return false;
}

// Начинаем заниматься с гантелями
stock dumbbells(playerid)
{
	if(Hand[playerid] >= 1 || Hold[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}У вас заняты руки");
	if(PlayerInfo[playerid][pMechSkill] <= 0) return ErrorMessage(playerid, "{FF6347}Ваш персонаж устал и хочет спать");
	if(GetPVarInt(playerid,"gantel") == 0 && GetPVarInt(playerid,"sport") == 0)
	{
		if(GetPVarInt(playerid,"antiflood") > 0) return GameTextForPlayer(playerid, "~r~Stop Flood", 1300, 4);

		GetPlayerPos(playerid, Job_X[playerid], Job_Y[playerid], Job_Z[playerid]); // Записываем позицию для действия
		SetPVarInt(playerid,"antiflood",3), SetPVarInt(playerid,"gantel",1), SetPVarInt(playerid,"ganteltime",0);
		RemovePlayerAttachedObject(playerid,1), RemovePlayerAttachedObject(playerid,2);
		SetPlayerAttachedObject(playerid, 1, 2916, 5, 0.062999, 0.028000, -0.030999, 6.000000, -94.699981, 1.099999, 1.000000, 1.000000, 1.000000, 0, 0);
		SetPlayerAttachedObject(playerid, 2, 2916, 6, 0.062999, 0.028000, -0.007999, 6.000000, -94.699981, 1.099999, 1.000000, 1.000000, 1.000000, 0, 0);
		ApplyAnimation(playerid,"Freeweights","gym_free_loop",4.0, false, true, true, true, true);
		SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Надо подкачаться [ {99ff66}%s {cccccc}] [ {cccccc}Положить гантелю - {FF6347}ALT {cccccc}]", buttonName[Device[playerid]]);
	}
	return 1;
}

stock ProcessDumbbells(playerid)
{
    if(GetPVarInt(playerid,"gantel") == 1 || GetPVarInt(playerid,"gantel") == 2)
    {
        if(GetPlayerWeapon(playerid) > WEAPON:1 || PlayerInfo[playerid][pMechSkill] < 10)
        {
            if(GetPlayerWeapon(playerid) > WEAPON:1) ErrorMessage(playerid, "{FF6347}Нельзя заниматься спортом с оружием в руках");
            if(PlayerInfo[playerid][pMechSkill] < 10) ErrorMessage(playerid, "{FF6347}Ваш персонаж устал и хочет спать");
            SetPlayerChatBubble(playerid,"кладёт гантели",COLOR_PURPLE,20.0,3000);
            SetPVarInt(playerid,"gantel",0), RemovePlayerAttachedObject(playerid,1);
            RemovePlayerAttachedObject(playerid,2);
            ApplyAnimation(playerid,"Freeweights","gym_free_putdown",4.0, false, true, true, false, true);
            return 1;
        }
        if(GetPVarInt(playerid,"ganteltime") == 0)
        {
            if(GetPVarInt(playerid,"gantel") == 1) 
            {
                SetPVarInt(playerid,"ganteltime",2);
                SetPVarInt(playerid,"gantel",2);
                ApplyAnimation(playerid,"Freeweights","gym_free_A",4.0, false, true, true, true, true);
                PlayerPlaySound(playerid,1150,0,0,0);
                update_power(playerid, 1);
                fatigue(playerid, 10);
            }
            else if(GetPVarInt(playerid,"gantel") == 2) 
            {
                SetPVarInt(playerid,"ganteltime",1);
                SetPVarInt(playerid,"gantel",1);
                ApplyAnimation(playerid,"Freeweights","gym_free_down",4.0, false, true, true, true, true);
            }
        }
        return true;
    }
    return false;
}

// Проверяем где находится игрок, когда занимается с гантелями
stock CheckDumbbellsPosistion(playerid)
{
    if(!IsPlayerInRangeOfPoint(playerid, 1.5, Job_X[playerid], Job_Y[playerid], Job_Z[playerid])) 
    {
        CloseDumbbells(playerid);
        return true;
    }
    return false;
}

// Завершаем тягание гантелей для игрока
stock CloseDumbbells(playerid)
{
    SetPVarInt(playerid,"gantel",0);
    RemovePlayerAttachedObject(playerid,1);
    RemovePlayerAttachedObject(playerid,2);
    PlayerPlaySound(playerid,4203,0,0,0);
    ClearAnimations(playerid);
    ClearAnim(playerid);
    return true;
}

// Кладём гантелю на место (корректным действием)
stock PutDumbbells(playerid)
{
    if(GetPVarInt(playerid,"gantel") > 0)
    {
        CloseDumbbells(playerid);
        SetPlayerChatBubble(playerid,"кладёт гантели",COLOR_PURPLE,20.0,3000);
        ApplyAnimation(playerid,"Freeweights","gym_free_putdown",4.0, false, true, true, false, true);
        return true;
    }
	return false;
}


//=================================================================
//============================ Шанга ==============================

enum WEIGHTSINFO { Float:Weights_X, Float:Weights_Y, Float:Weights_Z, Float:Weights_A, World, Interior }
new WeightsPos[][WEIGHTSINFO] =
{
    // Спортзал
    { 1747.8209,-1223.7607,81.5208,270.5512, WORLD_GYM, INT_GYM },
    { 1747.7800,-1226.7611,81.5208,271.4913, WORLD_GYM, INT_GYM },
    { 1747.8130,-1229.7771,81.5208,271.1779, WORLD_GYM, INT_GYM },
    { 1745.1808,-1229.6971,81.5208,91.0096, WORLD_GYM, INT_GYM },
    { 1745.1410,-1226.7081,81.5208,91.9496, WORLD_GYM, INT_GYM },
    { 1745.1957,-1223.7195,81.5208,90.0695, WORLD_GYM, INT_GYM },

    // Тюрьма Улица
    { 1021.5828,2456.0637,10.8566,270.0, 0, 0 },
    { 1021.5883,2452.2444,10.8647,270.0, 0, 0 },

    // Спортзал Департамента (Sportshall)
    { 1377.504272, -9.961143, 1500.420288, 90.0, -1, 248 },
    { 1377.504272, -12.151155, 1500.420288, 90.0, -1, 248 }
};

stock CreateWeights()
{
    for(new i = 0; i < sizeof(DumbbellsPos); i++)
	{
        CreateDynamic3DTextLabel("{0088ff}Штанга {cccccc}ALT", 0xFFFFFFFF, WeightsPos[i][Weights_X], WeightsPos[i][Weights_Y], WeightsPos[i][Weights_Z],3.0,
            INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,WeightsPos[i][World],WeightsPos[i][Interior]);
    }
    return true;
}

// Ищем штанги рядом
stock IsAWeights(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return -1;

    new pos = -1;
    for(new i = 0; i < sizeof(WeightsPos); i++)
	{
        if(IsPlayerInRangeOfPoint(playerid, 1.0, WeightsPos[i][Weights_X], WeightsPos[i][Weights_Y], WeightsPos[i][Weights_Z])
            && (WeightsPos[i][World] == -1 || GetPlayerVirtualWorld(playerid) == WeightsPos[i][World])
            && GetPlayerInterior(playerid) == WeightsPos[i][Interior])
        {
            pos = i;
            break;
        }
    }
	return pos;
}

// Проверяем, занята ли штанга
stock CheckWeightsBusy(playerid, s)
{
    foreach(Player,i)
	{
		if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid) && GetPlayerInterior(i) == GetPlayerInterior(playerid) // В моём инте и вирт мире
            && GetPVarInt(i,"tips") == 1 // Занимается со штангой
            && IsPlayerInRangeOfPoint(i, 1.0, WeightsPos[s][Weights_X], WeightsPos[s][Weights_Y], WeightsPos[s][Weights_Z])) // В точке штанги
		{
            return true;
        }
    }
    return false;
}

// Начинаем заниматься со штангой
stock weights(playerid, s)
{
	if(Hand[playerid] >= 1 || Hold[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}У вас заняты руки");
	if(PlayerInfo[playerid][pMechSkill] <= 0) return ErrorMessage(playerid, "{FF6347}Ваш персонаж устал и хочет спать");
	if(GetPVarInt(playerid,"gantel") == 0 && GetPVarInt(playerid,"sport") == 0)
	{
		if(GetPVarInt(playerid,"antiflood") > 0) return GameTextForPlayer(playerid, "~r~Stop Flood", 1300, 4);
        if(CheckWeightsBusy(playerid, s)) return ErrorMessage(playerid, "{FF6347}На этом тренажёре кто-то занимается");

        PPSetPlayerPos(playerid, WeightsPos[s][Weights_X], WeightsPos[s][Weights_Y], WeightsPos[s][Weights_Z]);
        PPSetPlayerFacingAngle(playerid, WeightsPos[s][Weights_A]);

		GetPlayerPos(playerid, Job_X[playerid], Job_Y[playerid], Job_Z[playerid]); // Записываем позицию для действия
		SetPVarInt(playerid,"antiflood",3);
        NoAnim[playerid] = 1;
        SetPVarInt(playerid,"sport",1);
        SetPVarInt(playerid,"tips",1); // Тип Тренировки
        SetPVarInt(playerid,"ganteltime",3);
        ApplyAnimation(playerid,"benchpress","gym_bp_geton",4.0, false, false, false, true, false, SYNC_ALL);
        SendClientMessage(playerid, COLOR_GREY, "{cccccc}[ Мысли ]: Надо подкачаться [ {99ff66}%s {cccccc}] [ {cccccc}Положить штангу - {FF6347}ALT {cccccc}]", buttonName[Device[playerid]]);
	}
	return 1;
}

stock ProcessWeights(playerid)
{
    if(GetPVarInt(playerid,"tips") == 1)
    {
        if(GetPVarInt(playerid,"sport") == 1)
        {
            if(GetPlayerWeapon(playerid) <= WEAPON:1)
            {
                if(GetPVarInt(playerid,"ganteltime")==0)
                {
                    SetPVarInt(playerid,"ganteltime",2);
                    if(PlayerInfo[playerid][pMechSkill] >= 10)
                    {
                        RemovePlayerAttachedObject(playerid,1);
                        SetPlayerAttachedObject(playerid, 1, 2913, 6, -0.040000, 0.063999, -0.125999, 4.399999, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
                        SetPVarInt(playerid,"sport",2);
                        ApplyAnimation(playerid,"benchpress","gym_bp_up_A",4.0, false, false, false, true, false);
                        PlayerPlaySound(playerid,1150,0,0,0);
                        new Float:health = HealthAC[playerid];
                        ACSetPlayerHealth(playerid, health+0.5);
                        update_power(playerid, 2);
                        fatigue(playerid, 10);
                    }
                    else
                    {
                        ErrorMessage(playerid, "{FF6347}Ваш персонаж устал и хочет спать");
                        PutWeights(playerid);
                    }
                }
            }
            else
            {
                ErrorMessage(playerid, "{FF6347}Вашему персонажу не удобно заниматься с оружием в руках");
                PutWeights(playerid);
            }
        }
        else if(GetPVarInt(playerid,"sport") == 2)
        {
            if(GetPlayerWeapon(playerid) <= WEAPON:1)
            {
                if(GetPVarInt(playerid,"ganteltime") == 0) SetPVarInt(playerid,"ganteltime",1), SetPVarInt(playerid,"sport",1), ApplyAnimation(playerid,"benchpress","gym_bp_down",4.0, false, false, false, true, false);
            }
            else
            {
                ErrorMessage(playerid, "{FF6347}Вашему персонажу не удобно заниматься с оружием в руках");
                PutWeights(playerid);
            }
        }
        return true;
    }
    return false;
}

stock PutWeights(playerid, bool:clearAnim = false)
{
    if(GetPVarInt(playerid,"tips") == 1)
    {
        CloseWeights(playerid, clearAnim);
        ApplyAnimation(playerid,"benchpress","gym_bp_getoff",4.0, false, false, false, false, false);
	    SetPlayerChatBubble(playerid,"кладёт штангу",COLOR_PURPLE,20.0,3000);
        return true;
    }
	return false;
}

// Проверяем где находится игрок, когда занимается со штангой
stock CheckWeightsPosistion(playerid)
{
    if(!IsPlayerInRangeOfPoint(playerid,1.5,Job_X[playerid], Job_Y[playerid], Job_Z[playerid])) return CloseWeights(playerid, true);
    return false;
}

stock CloseWeights(playerid, bool:clearAnim = false)
{
    if(GetPVarInt(playerid,"tips") == 1)
    {
        NoAnim[playerid] = 0;
        SetPVarInt(playerid,"sport",0);
        SetPVarInt(playerid,"ganteltime",0);
        SetPVarInt(playerid,"tips",0);

        if(clearAnim == true)
        {
            ClearAnimations(playerid);
            ClearAnim(playerid);
        }
        
        PlayerPlaySound(playerid,4203,0,0,0);
        RemovePlayerAttachedObject(playerid, 1);
        return true;
    }
    return false;
}

//=================================================================
//======================== Кардиотренажёры ========================

enum TRAINERINFO { Float:Trainer_X, Float:Trainer_Y, Float:Trainer_Z, Float:Trainer_A, World, Interior, Type }
new TrainerPos[][TRAINERINFO] =
{
    //================
    // Беговые дорожки 0

    // Спортзал
    { 1763.1578,-1227.4719,81.5208,271.5149, WORLD_GYM, INT_GYM, 0 },
    { 1763.2512,-1229.1783,81.5208,271.5150, WORLD_GYM, INT_GYM, 0 },
    { 1763.2213,-1230.9622,81.5208,270.5750, WORLD_GYM, INT_GYM, 0 },
    { 1763.1353,-1232.8452,81.5208,269.3217, WORLD_GYM, INT_GYM, 0 },
    { 1748.2528,-1204.3182,81.5208,269.3217, WORLD_GYM, INT_GYM, 0 },
    { 1748.3595,-1207.5068,81.5208,270.5750, WORLD_GYM, INT_GYM, 0 },
    { 1744.1036,-1204.3224,81.5208,269.6351, WORLD_GYM, INT_GYM, 0 },
    { 1744.1544,-1207.5020,81.5208,270.2618, WORLD_GYM, INT_GYM, 0 },

    // Спортзал Департамента (Sportshall)
    { 1381.693481, -27.161195, 1500.420288, 0.0, -1, 248, 0 },
    { 1383.685424, -27.161195, 1500.420288, 0.0, -1, 248, 0 },

    //================
    // Велотренажёры 1

    // Спортзал
    { 1760.1810,-1227.0424,81.5208,268.1643, WORLD_GYM, INT_GYM, 1 },
    { 1760.2150,-1228.7526,81.5208,271.2977, WORLD_GYM, INT_GYM, 1 },
    { 1760.2426,-1230.4730,81.5208,271.2977, WORLD_GYM, INT_GYM, 1 },
    { 1760.2190,-1232.3236,81.5208,271.2977, WORLD_GYM, INT_GYM, 1 },
    { 1743.8115,-1232.2635,81.5208,271.9244, WORLD_GYM, INT_GYM, 1 },
    { 1748.1538,-1232.2638,81.5208,269.4177, WORLD_GYM, INT_GYM, 1 },

    // Спортзал Департамента (Sportshall)
    { 1393.845825, -22.711174, 1500.610473, 90.0, -1, 248, 1 },
    { 1393.845825, -20.751152, 1500.610473, 90.0, -1, 248, 1 },
    { 1393.845825, -18.691110, 1500.610473, 90.0, -1, 248, 1 }
};

stock CreateTrainer()
{
    for(new i = 0; i < sizeof(TrainerPos); i++)
	{
        if(TrainerPos[i][Type] == 0)
        {
            CreateDynamic3DTextLabel("{0088ff}Беговая Дорожка {cccccc}ALT", 0xFFFFFFFF, TrainerPos[i][Trainer_X], TrainerPos[i][Trainer_Y], TrainerPos[i][Trainer_Z],3.0,
                INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,TrainerPos[i][World],TrainerPos[i][Interior]);
        }
        else
        {
            CreateDynamic3DTextLabel("{0088ff}Велотренажер {cccccc}ALT", 0xFFFFFFFF, TrainerPos[i][Trainer_X], TrainerPos[i][Trainer_Y], TrainerPos[i][Trainer_Z],3.0,
                INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,TrainerPos[i][World],TrainerPos[i][Interior]);
        }
    }
    return true;
}

// Ищем тренажёр рядом
stock IsATrainer(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return -1;

    new pos = -1;
    for(new i = 0; i < sizeof(TrainerPos); i++)
	{
        if(IsPlayerInRangeOfPoint(playerid, 1.0, TrainerPos[i][Trainer_X], TrainerPos[i][Trainer_Y], TrainerPos[i][Trainer_Z])
            && (TrainerPos[i][World] == -1 || GetPlayerVirtualWorld(playerid) == TrainerPos[i][World])
            && GetPlayerInterior(playerid) == TrainerPos[i][Interior])
        {
            pos = i;
            break;
        }
    }
	return pos;
}

// Проверяем, занят ли тренажер
stock CheckTrainerBusy(playerid, s)
{
    foreach(Player,i)
	{
		if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid) && GetPlayerInterior(i) == GetPlayerInterior(playerid) // В моём инте и вирт мире
            && GetPVarInt(i,"tips") > 1 // Занимается на тренажёре
            && IsPlayerInRangeOfPoint(i, 1.0, TrainerPos[s][Trainer_X], TrainerPos[s][Trainer_Y], TrainerPos[s][Trainer_Z])) // В точке тренажера
		{
            return true;
        }
    }
    return false;
}

// Нажимаем ALT рядом с тренажёром
stock trainer(playerid, s)
{
	if(Hand[playerid] >= 1 || Hold[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}У вас заняты руки");
	if(PlayerInfo[playerid][pMechSkill] <= 0) return ErrorMessage(playerid, "{FF6347}Ваш персонаж устал и хочет спать");
	if(GetPVarInt(playerid,"gantel") == 0 && GetPVarInt(playerid,"sport") == 0)
	{
        DP[0][playerid] = s;
        ShowDialog(playerid,441,DIALOG_STYLE_INPUT,"Спортзал","{cccccc}Введите время тренировки в минутах {0088ff}[ 1 мин. = 10 skill ]\n\nМинимум: {ff9000}1 минута\n{cccccc}Максимум: {ff9000}10 минут","Принять","Отмена");
	}
	return 1;
}

stock trainer_go(playerid, s, const inputtext[])
{
    if(s < 0 || s >= sizeof(TrainerPos)) return false;

    if(Hand[playerid] >= 1 || Hold[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}У вас заняты руки");
	if(PlayerInfo[playerid][pMechSkill] <= 0) return ErrorMessage(playerid, "{FF6347}Ваш персонаж устал и хочет спать");
	if(GetPVarInt(playerid,"gantel") == 0 && GetPVarInt(playerid,"sport") == 0)
	{
        new input = strval(inputtext); // Время Тренировки
        if(input > 10 || input < 1) return ErrorMessage(playerid, "{FF6347}Не меньше 1 и не больше 10");

        if(GetPVarInt(playerid,"antiflood") > 0) return GameTextForPlayer(playerid, "~r~Stop Flood", 1300, 4);
        if(CheckTrainerBusy(playerid, s)) return ErrorMessage(playerid, "{FF6347}На этом тренажёре кто-то занимается");

        PPSetPlayerPos(playerid, TrainerPos[s][Trainer_X], TrainerPos[s][Trainer_Y], TrainerPos[s][Trainer_Z]);
        PPSetPlayerFacingAngle(playerid, TrainerPos[s][Trainer_A]);
        GetPlayerPos(playerid, Job_X[playerid], Job_Y[playerid], Job_Z[playerid]); // Записываем позицию для действия

        NoAnim[playerid] = 1;
        SetPVarInt(playerid,"sport", input);
        SetPVarInt(playerid,"ganteltime", input * 60);

        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Отменить Тренировку: [ {ff6347}Левая Кнопка Мыши {cccccc}]");

        new string[100];
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~y~CЊOPЏ: ~w~%d cek",input * 60);
		GameTextForPlayer(playerid, string, 1200, 3);

        // Беговая дорожка
        if(TrainerPos[s][Type] == 0)
        {
            ApplyAnimation(playerid,"GYMNASIUM","gym_tread_geton",4.2, false, false, false, true, false, SYNC_ALL);
            SetPVarInt(playerid,"tips", 2);
        }

        // Велотренажер
        else
        {
            ApplyAnimation(playerid,"GYMNASIUM","gym_bike_geton",4.2, false, false, false, true, false, SYNC_ALL);
            SetPVarInt(playerid,"tips", 3);
        }
        return true;
    }
    return false;
}

// Закрываем процесс в тренажёре
stock CloseTrainer(playerid, bool:clearAnim = false)
{
    if(GetPVarInt(playerid,"tips") == 2 || GetPVarInt(playerid,"tips") == 3)
	{
        NoAnim[playerid] = 0;
        SetPVarInt(playerid,"sport",0);
		SetPVarInt(playerid,"ganteltime",0);
		PlayerPlaySound(playerid,4203,0,0,0);
		SetPVarInt(playerid,"tips",0);

        if(clearAnim == true)
        {
            ClearAnimations(playerid);
            ClearAnim(playerid);
        }
        return true;
    }
    return false;
}

// Выходим из тренажёра
stock ExitTrainer(playerid, bool:clearAnim = false)
{
    if(GetPVarInt(playerid,"tips") == 2 || GetPVarInt(playerid,"tips") == 3)
	{
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~r~O¦Їe®a", 5000, 3);
        if(GetPVarInt(playerid,"tips") == 2) ApplyAnimation(playerid,"GYMNASIUM","gym_walk_falloff",4.0, false, false, false, false, false, SYNC_ALL);
		else if(GetPVarInt(playerid,"tips") == 3) ApplyAnimation(playerid,"GYMNASIUM","gym_bike_getoff",4.0, false, false, false, false, false, SYNC_ALL);

        CloseTrainer(playerid, clearAnim);
        return true;
    }
    return false;
}

stock CloseSport(playerid)
{
    if(GetPVarInt(playerid,"tips") == 1) CloseWeights(playerid);
    else if(GetPVarInt(playerid,"tips") > 1) ExitTrainer(playerid);
    return false;
}

// Игрок в тренажёре (беговая дорожка или велотренажер)
stock ProcessTrainer(playerid)
{
    if(GetPVarInt(playerid,"ganteltime") >= 1)
    {
        if(GetPVarInt(playerid,"tips") == 2) ApplyAnimation(playerid,"GYMNASIUM","gym_tread_jog",4.0, true, false, false, true, false, SYNC_ALL);
        else if(GetPVarInt(playerid,"tips") == 3) ApplyAnimation(playerid,"GYMNASIUM","gym_bike_slow",4.0, true, false, false, true, false, SYNC_ALL);
        new string[60];
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~y~CЊOPЏ: ~w~%d cek", GetPVarInt(playerid,"ganteltime"));
		GameTextForPlayer(playerid, string, 1200, 3);
        format(string, sizeof(string), "Тренируется: %d",GetPVarInt(playerid,"ganteltime"));
        SetPlayerChatBubble(playerid,string,COLOR_LIGHTBLUE,20.0,1500);

        if(!IsPlayerInRangeOfPoint(playerid,1.5, Job_X[playerid], Job_Y[playerid], Job_Z[playerid])) CloseTrainer(playerid, true);
    }
    else if(GetPVarInt(playerid,"ganteltime") == 0)
    {
        update_power(playerid, GetPVarInt(playerid,"sport")*10);
        ExitTrainer(playerid);
    }
    return false;
}

stock gymlift(playerid)
{
	if(IsAGymLift(playerid))
	{
        ShowDialog(playerid,742,DIALOG_STYLE_LIST,"{ff9000}Лифт","{ff9000}1 Этаж\
                                                                \n{ff9000}2 Этаж","Ок","Отмена");
        PlayerPlaySound(playerid,40405,0,0,0);
        return true;
	}
	return false;
}

stock IsAGymLift(playerid)
{
    // 1 этаж
    if(IsPlayerInRangeOfPoint(playerid,2.0,2182.3889,1932.0560,68.0881)
        && GetPlayerVirtualWorld(playerid) == WORLD_GYM_HALL && GetPlayerInterior(playerid) == INT_GYM_HALL

    // 2 Этаж
    || IsPlayerInRangeOfPoint(playerid,2.0,1733.1602,-1218.9449,81.5080)
        && GetPlayerVirtualWorld(playerid) == WORLD_GYM && GetPlayerInterior(playerid) == INT_GYM

    ) return true;

    return false;
}

stock IsAGymReception(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid,2.0,2191.7822,1929.7301,68.0781)
        && GetPlayerVirtualWorld(playerid) == WORLD_GYM_HALL && GetPlayerInterior(playerid) == INT_GYM_HALL) return true;
    return false;
}

// Ресепшен спортзала
stock GymReception(playerid)
{
    if(IsAGymReception(playerid))
    {
        new string[80];
        format(string, sizeof(string), "{ff9000}Абонемент на 7 дней\t{99ff66}%d$", PRICE_GYM);
        ShowDialog(playerid,743,DIALOG_STYLE_TABLIST,"{ff9000}Спортзал",string,"Ок","Отмена");
        PlayerPlaySound(playerid,40405,0,0,0);
        return true;
    }
    return false;
}

stock BuyGymAbonement(playerid)
{
    if(PlayerInfo[playerid][pGymUnix] - gettime() > 86400) return ErrorMessage(playerid, "{FF6347}У вас есть активный абонемент в спортзал [ /time ]");
    if(oGetPlayerMoney(playerid) < PRICE_GYM) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");

    oGivePlayerMoney(playerid, -PRICE_GYM);
    MoneyLog("gym", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -PRICE_GYM, "Абонемент в спортзал");
    PlayerInfo[playerid][pGymUnix] = gettime() + 604800;
    payanim(playerid, 0);

    new string[100];
    format(string,sizeof(string),"{99ff66}Вы приобрели абонемент в спортзал на 7 дней\nСтоимость: %d$", PRICE_GYM);
    SuccessMessage(playerid, string);

    mysql_format(pearsq, string, sizeof(string),"UPDATE `pp_igroki` SET `pGymUnix` = '%d' WHERE `user_id` = '%d'", PlayerInfo[playerid][pGymUnix], PlayerInfo[playerid][pID]);
    mysql_tquery(pearsq, string);
    return false;
}

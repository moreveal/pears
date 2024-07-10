
#include "../gamemodes/source/custom/skin_custom.pwn" // pwn для добавления новых скинов в мод

#define MAX_MODELS_SKIN 312 + MAX_SKIN_CUSTOM // Количество моделей скинов на сервере
#define MAX_SKIN_NAME 34 // Длина названия никнейма

new SkinGos[MAX_MODELS_SKIN]; // Стоимости скинов
new SkinGold[MAX_MODELS_SKIN]; // Gold стоимости скинов
new SkinBuy[MAX_MODELS_SKIN]; // Подсчет покупок скинов за вирты
new SkinBuyGold[MAX_MODELS_SKIN]; // Подсчет покупок скинов за голду
new SkinSale[MAX_MODELS_SKIN]; // Доступен ли скин для продажи
new SkinName[MAX_MODELS_SKIN][MAX_SKIN_NAME]; // Название скина

new skinNameAll[][] =
{
    "Сиджей", "The Truth", "Maccer", "Andre", "Mini Bear", "Big Bear", "Emmet", "Taxi Driver", "Janitor", // 0 - 8
    "Normal Ped", "Old Woman", "Casino croupier", "Rich Woman", "Street Girl", "Normal Ped", "Mr.Whittaker", "Airport Worker", "Businessman", "Beach Visitor", // 9 - 18
    "DJ", "Rich Guy", "Normal Ped", "Normal Ped", "BMXer", "M.D. Bodyguard", "M.D. Bodyguard", "Backpacker", "Construction Worker", "Drug Dealer", // 19 - 28
    "Drug Dealer", "Drug Dealer", "Farm Inhabitant", "Farm Inhabitant", "Farm Inhabitant", "Farm Inhabitant", "Gardener", "Golfer", "Golfer", "Normal Ped", // 29 - 38
    "Normal Ped", "Normal Ped", "Normal Ped", "Jethro", "Normal Ped", "Normal Ped", "Beach Visitor", "Normal Ped", "Normal Ped", "Normal Ped", // 39 - 48
    "Da Nang", "Mechanic", "Mountain Biker", "Mountain Biker", "Normal Ped", "Normal Ped", "Normal Ped", "Normal Ped", "Oriental Ped", "Oriental Ped", "Normal Ped", // 49 - 59
    "Normal Ped", "Pilot", "Colonel Fuhrberger", "Prostitute", "Prostitute", "Kendl Johnson", "Pool Player", "Pool Player", "Preacher", // 60 - 68
    "Normal Ped", "Scientist", "Security Guard", "Hippy", "Hippy", "Unknown", "Prostitute", "Stewardess", "Homeless", "Homeless", "Homeless", // 69 - 79
    "Boxer", "Boxer", "Black Elvis", "White Elvis", "Blue Elvis", "Prostitute", "Ryder Mask", "Stripper", "Normal Ped", "Normal Ped", "Jogger", // 80 - 90
    "Rich Woman", "Rollerskater", "Normal Ped", "Normal Ped", "Normal Ped", "Jogger", "Lifeguard", "Normal Ped", // 91 - 98
    "Rollerskater", "Biker", "Normal Ped", "Balla", "Balla", "Balla", "Grove", "Grove", // 99 - 106
    "Grove", "Vagos", "Vagos", "Vagos", "Russian Mafia", "Russian Mafia", "Russian Mafia", "Aztecas", "Aztecas", "Aztecas", // 107 - 116
    "Triad", "Triad", "Johhny Sindacco", "Triad Boss", "Da Nang Boy", "Da Nang Boy", "Da Nang Boy", "The Mafia", "The Mafia", "The Mafia", // 117 - 126
    "The Mafia", "Farm Inhabitant", "Farm Inhabitant", "Farm Inhabitant", "Farm Inhabitant", "Farm Inhabitant", "Farm Inhabitant", "Homeless", "Homeless", "Normal Ped", // 127 - 136
    "Homeless", "Beach Visitor", "Beach Visitor", "Beach Visitor", "Businesswoman", "Taxi Driver", "Crack Maker", "Crack Maker", "Crack Maker", "Crack Maker", "Businessman", // 137 - 147
    "Businesswoman", "Big Smoke Armored", "Businesswoman", "Normal Ped", "Prostitute", "Construction Worker", "Beach Visitor", "Pizza Worker", "Barber", "Hillbilly", "Farmer", // 148 - 158
    "Hillbilly", "Hillbilly", "Farmer", "Hillbilly", "Black Bouncer", "White Bouncer", "White MIB agent", "Black MIB agent", "Cluckin' Bell Worker", "Chilli Dog Vendor", "Normal Ped", // 159 - 169
    "Normal Ped", "Blackjack Dealer", "Casino croupier", "Rifa", "Rifa", "Rifa", "Barber", "Barber", "Whore", "Ammunation", // 170 - 179
    "Tattoo Artist", "Punk", "Cab Driver", "Normal Ped", "Normal Ped", "Normal Ped", "Normal Ped", "Businessman", "Normal Ped", "Valet", "Barbara Schternvart", // 180 - 190
    "Helena Wankstein", "Michelle Cannes", "Katie Zhan", "Millie Perkins", "Denise Robinson", "Farm Inhabitan", "Hillbill", "Farm Inhabitan", "Farm Inhabitan", // 191 - 199
    "Hillbilly", "Farmer", "Farmer", "Karate Teacher", "Karate Teacher", "Burger Shot Cashier", "Cab Driver", "Prostitute", "Su Xi Mu", "Noodle Vendor", // 200 - 209 
    "School Instructor", "Shop Staff", "Homeless", "Weird old man", "Maria Latore", "Normal Ped", "Normal Ped", "Shop Staff", "Normal Ped", "Rich Woman", // 210 - 219
	"Cab Driver", "Normal Ped", "Normal Ped", "Normal Ped", "Normal Ped", "Normal Ped", "Normal Ped", "Oriental Businessman", "Oriental Ped", "Oriental Ped", // 220 - 229
	"Homeless", "Normal Ped", "Normal Ped", "Normal Ped", "Cab Driver", "Normal Ped", "Normal Ped", "Prostitute", "Prostitute", "Homeless", // 230 - 239
	"The D.A", "Afro-American", "Mexican", "Prostitute", "Stripper", "Prostitute", "Stripper", "Biker", "Biker", "Pimp", // 240 - 249
	"Normal Ped", "Lifeguard", "Naked Valet", "Bus Driver", "Biker Drug Dealer", "Chauffeu", "Stripper", "Stripper", "Heckler", "Heckler", // 250 - 259
	"Construction Worker", "Cab driver", "Cab driver", "Normal Ped", "Clown", "Frank Tenpenny", "Eddie Pulaski", "Jimmy Hernandez", "Dwayne", "Big Smoke", // 260 - 269
	"Sweet", "Ryder", "Mafia Boss", "T-Bone Mendez", "Paramedic", "Paramedic", "Paramedic", "Firefighter", "Firefighter", "Firefighter", // 270 - 279
	"Police Officer", "Police Officer", "Police Officer", "County Sheriff", "Motorbike Cop", "Special Forces", "Federal Agent", "Army", "Desert Sheriff", "Zero", // 280 - 289
	"Ken Rosenberg", "Kent Paul", "Cesar Vialpando", "OG Loc", "Wu Zi Mu", "Michael Toreno", "Jizzy", "Madd Dogg", "Catalina", "Claude", // 290 - 299
	"Police Officer", "Police Officer", "Police Officer", "Police Officer", "Police Officer", "Police Officer", "Police Officer", "Police Officer", "Paramedic", "Police Officer", // 300 - 309
	"Country Sheriff", "Desert Sheriff" // 310 - 311
};

// Проверка на доступные ID скинов
stock IsASkinExisting(s)
{
    if(s >= 1 && s <= 73 || s >= 75 && s <= 311 // Стандартные скины сампа (0 - cj, 74 косячина сампа - не используем его)

    || s >= 312 && s <= MAX_MODELS_SKIN) return 1; // Кастомные скины пирса
    return 0;
}

stock GetSkinName(skin)
{
	new skinName[34];
	if(skin >= sizeof(skinNameAll)) 
	{
		if(!strcmp(SkinName[skin],"\0",true) || !strcmp(SkinName[skin],"NULL",true)) format(skinName, sizeof(skinName), "Одежда");
		else format(skinName, sizeof(skinName), "%s", SkinName[skin]);
	}
	else format(skinName, sizeof(skinName), "%s", skinNameAll[skin]);
	return skinName;
}

// Получаем id скина для другого игрока forplayerid +
stock GetSkinPresentation(forplayerid, playerid)
{
    new skinId;
	new showModel = GetPlayerSyncSkin(playerid);
    if(IsPlayerSyncModels(forplayerid)) // Если моды установлены
	{
		if(showModel >= 312) showModel += 15188;
		skinId = showModel;
	}
    else skinId = GetSkinModelOriginal(showModel); // Если моды НЕ установлены, показываем оригинальный скин
    return skinId;
}

// Получаем модель скина с учётом наличия модпака +
stock GetModelSkin(playerid, s)
{
    new skinId;
    if(IsPlayerSyncModels(playerid)) // Мод установлен
	{
		if(s >= 312) s += 15188;
		skinId = s;
	}
    else skinId = GetSkinModelOriginal(s);
    return skinId;
}

stock GetPlayerModelSkinOriginal(playerid) // Получаем оригинальный скин игрока
{
	new showModel = GetPlayerSyncSkin(playerid);
	new skinId = GetSkinModelOriginal(showModel);
	return skinId;
}

CMD:getskin(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 15) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 15+ ]");

	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Получить информацию о скине игрока [ /getskin ID ]");	

	new showModel = GetPlayerSyncSkin(params[0]);
	new skinId = GetSkinModelOriginal(showModel);

	new string[100];
	format(string, sizeof(string), " %s SkinID: %d SkinOriginal: %d", PlayerInfo[params[0]][pName], showModel, skinId);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}

CMD:setskin(playerid, const params[]) // Сменить активную одежду игрока
{
	if(PlayerInfo[playerid][pSoska] < 15) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 15+ ]");

    new tmp[34], giveplayerid;
	if(sscanf(params, "s[34]i",tmp,params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить одежду [ /setskin ID ID Скина ]");
    giveplayerid = ReturnUser(tmp, 1);

	if(!IsASkinExisting(params[1])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID скина [1 - 311, кастомные 312 и выше]");
	if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети или он не залогинился");
	if(IsPlayerInAnyVehicle(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока в транспорте");
	if(NoAnim[giveplayerid] == 1) return ErrorMessage(playerid, "{FF6347}Нельзя сменить скин во время активного действия игрока");

	PlayerInfo[giveplayerid][pModel] = params[1];
	PlayerInfo[giveplayerid][pModel2] = 0;
	PlayerInfo[giveplayerid][pModel3] = 0;

	new string[90];
	if(giveplayerid != playerid)
	{
		format(string, sizeof(string), "Администратор %s изменил вашу одежду", PlayerInfo[playerid][pName]);
		SendClientMessage(giveplayerid, COLOR_WHITE, string);
	}

	if(server == 0)
	{
		new sexText[14];
		if(GetSkinSex(params[1]) == 1) sexText = "Мужской";
		else if(GetSkinSex(params[1]) == 2) sexText = "Женский";
		else sexText = "Без пола";
		format(string, sizeof(string), "Вы изменили %s одежду на ID %d (%s)", PlayerInfo[giveplayerid][pName], params[1], sexText);
	}
	else format(string, sizeof(string), "Вы изменили %s одежду на ID %d", PlayerInfo[giveplayerid][pName],params[1]);
	SendClientMessage(playerid, COLOR_WHITE, string);

	m_custom_sync_SetPlayerSkin(giveplayerid, PlayerInfo[giveplayerid][pModel]);
	
	AdminLog("setskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], params[1], "");
	return 1;
}

CMD:giveskin(playerid, const params[]) // Выдать одежду в инвентарь
{
	if(PlayerInfo[playerid][pSoska] < 15) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 15+ ]");
	new tmp[34], giveplayerid;
	if(sscanf(params, "s[34]i",tmp,params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать одежду /giveskin [ID] [ID Скина]");
	if(!IsASkinExisting(params[1])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID скина [1 - 311, кастомные 312 и выше]");
	giveplayerid = ReturnUser(tmp, 1);

	if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети или он не залогинился");
    
    new put_inva = GiveThingPlayer(giveplayerid, params[1], 1, 0, 0, 3, 0, 9999);
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре");

	new string[100];
    format(string, sizeof(string), "Администратор %s выдал вам одежду ID: %d", PlayerInfo[playerid][pName], params[1]);
    SendClientMessage(giveplayerid, COLOR_WHITE, string);
    format(string, sizeof(string), "Вы выдали %s одежду ID %d (Общего Доступа)", PlayerInfo[giveplayerid][pName],params[1]);
    SendClientMessage(playerid, COLOR_WHITE, string);
    AdminLog("giveskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], params[1], "");
	return 1;
}

CMD:skin(playerid, const params[]) // Временно сменить скин себе
{
	if(PlayerInfo[playerid][pSoska] < 20 && PlayerInfo[playerid][pMedia] < 3) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(gSkafandr[playerid] > 0 || gFormavvs[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Вы не можете переодеться в форме");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Временно сменить скин [ /skin ID Скина ]");
	if(!IsASkinExisting(params[0])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID скина [1 - 311, кастомные 312 и выше]");

	new string[80];
	format(string, sizeof(string), "Вы временно сменили скин ID %d",params[0]);
	SendClientMessage(playerid, COLOR_WHITE, string);

	m_custom_sync_SetPlayerSkin(playerid, params[0]);
	return 1;
}

CMD:setskinmp(playerid, const params[]) // Временно сменить скин игроку
{
	if(PlayerInfo[playerid][pSoska] < 4 && PlayerInfo[playerid][pMedia] != 3) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 4+ ]");

    new tmp[34], giveplayerid;
	if(sscanf(params, "s[34]i",tmp,params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Временно изменить скин [ /setskinmp ID ID Скина ]");
	if(!IsASkinExisting(params[1])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID скина [1 - 311, кастомные 312 и выше]");
	if(Pognalinamp == 0 && PlayerInfo[playerid][pSoska] <= 9) return ErrorMessage(playerid, "{FF6347}Эта команда доступна вам только во время мероприятия");

    giveplayerid = ReturnUser(tmp, 1);
	if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети или он не залогинился");

	new string[100];
	format(string, sizeof(string), "Администратор %s временно изменил ваш скин", PlayerInfo[playerid][pName]);
	SendClientMessage(giveplayerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Вы временно изменили %s скин %d.", PlayerInfo[giveplayerid][pName], params[1]);
	SendClientMessage(playerid, COLOR_WHITE, string);

	m_custom_sync_SetPlayerSkin(giveplayerid, params[1]);

    AdminLog("setskinmp", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], params[1], "");
	return 1;
}

CMD:setskingro(playerid, const params[]) // Временно сменить скин всем игрокам в радиусе 30 метров
{
    if(PlayerInfo[playerid][pSoska] < 4 && PlayerInfo[playerid][pMedia] != 3) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 4+ ]");
	if (sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Временно изменить скин всем вокруг себя [ /setskingro ID Скина ]");
    if(!IsASkinExisting(params[0])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID скина [1 - 311, кастомные 312 и выше]");
    if(Pognalinamp == 0 && PlayerInfo[playerid][pSoska] <= 9) return ErrorMessage(playerid, "{FF6347}Эта команда доступна вам только во время мероприятия");

	new string[100];
    foreach (Player, i)
    {
        if(playerid == i) continue;
        if(OnlineInfo[i][oLogged] == 0) continue;

        if(GetDistanceBetweenPlayers(playerid, i) < 30)
        {
            format(string, sizeof(string), "Администратор %s временно изменил ваш скин", PlayerInfo[playerid][pName]);
            SendClientMessage(i, COLOR_WHITE, string);

			m_custom_sync_SetPlayerSkin(i, params[0]);
        }
    }
    format(string, sizeof(string), "Вы временно изменили скин игрокам возле себя ID: %d",params[0]);
    SendClientMessage(playerid, COLOR_WHITE, string);
    format(string, sizeof(string), " [ ADM ]: Админ %s изменил скин всем игрокам возле себя ID: [%d]", PlayerInfo[playerid][pName],params[0]);
    ABroadCast(COLOR_ADM,string,1);
    AdminLog("setskingro", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "");
	return 1;
}

// Возвращаем позицию игрока
stock WeReturnToPosition(playerid)
{
	keep(playerid); // Подморозим, чтобы не провалился
	S_SetPlayerVirtualWorld(playerid, OnlineInfo[playerid][oSpawnWorld], OnlineInfo[playerid][oSpawnInt]), PPSetPlayerInterior(playerid, OnlineInfo[playerid][oSpawnInt]);
	if(PlayerInfo[playerid][pBeret] == 0) Protect_MyWeapon(playerid); // Возвращаем оружие
	SetPlayerToTeamColor(playerid); // Возвращаем цвет

	// Возвращаем аксессуары
	if(PlayerInfo[playerid][pOdet][0] > 0) Odet(playerid, 5);
	if(PlayerInfo[playerid][pOdet][1] > 0) Odet(playerid, 6);
	if(PlayerInfo[playerid][pOdet][2] > 0) Odet(playerid, 7);
	if(PlayerInfo[playerid][pOdet][3] > 0) Odet(playerid, 8);
	if(PlayerInfo[playerid][pOdet][4] > 0) Odet(playerid, 9);

	if(!VehShopInfo[playerid][vsTest]) ApplyAnimation(playerid,"PED","Turn_R",4.0, false, true, true, false, false);

    OnlineInfo[playerid][oTempSpawn] = false; // Спавн завершён
    return 1;
}

function loadDrop_Clothes(playerid)
{
	if(gSkafandr[playerid] == 0 && gFormavvs[playerid] == 0)
	{
		RemovePlayerAttachedObject(playerid, 5);
		m_custom_sync_SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
	}
	OnlineInfo[playerid][oFittingRoom] = 0;
	GameTextForPlayer(playerid," ",2000,3);
	return 1;
}

// Снять одежду
stock player_undress(playerid)
{
    PlayerPlaySound(playerid,5601,0,0,0);
    TakeOffClothes(playerid);
    PlayerInfo[playerid][pModel2] = 0, PlayerInfo[playerid][pModel3] = 0;
    ApplyAnimation(playerid,"PED","Turn_R",4.0, false, true, true, false, false);
    if(OnlineInfo[playerid][oShowInterface] == 1) PlayerTextDrawSetPreviewModel(playerid, PlaNestOthe[0][playerid], PlayerInfo[playerid][pModel]), PlayerTextDrawShow(playerid, PlaNestOthe[0][playerid]);
    
    if(PlayerInfo[playerid][pOdet][0] > 0) RemovePlayerAttachedObject(playerid, 5);
	if(PlayerInfo[playerid][pOdet][1] > 0) RemovePlayerAttachedObject(playerid, 6);
	if(PlayerInfo[playerid][pOdet][2] > 0) RemovePlayerAttachedObject(playerid, 7);
	if(PlayerInfo[playerid][pOdet][3] > 0) RemovePlayerAttachedObject(playerid, 8);
	if(PlayerInfo[playerid][pOdet][4] > 0) RemovePlayerAttachedObject(playerid, 9);

	mysql_save(playerid, 75);
	return 1;
}

// Меняем скин, когда снимаем одежду (Голый мужчина или женщина)
stock TakeOffClothes(playerid)
{
    if(PlayerInfo[playerid][pSex] == 1) SetPlayerSkinEx(playerid, 154), PlayerInfo[playerid][pModel] = 154;
 	else SetPlayerSkinEx(playerid, 140), PlayerInfo[playerid][pModel] = 140;
    return 1;
}

// Проверка на голого персонажа (По скину)
stock isnaked(playerid)
{
	if(PlayerInfo[playerid][pModel] == 154 || PlayerInfo[playerid][pModel] == 18 || PlayerInfo[playerid][pModel] == 140 || PlayerInfo[playerid][pModel] == 139) return 1;
	return 0;
}


// Магазин Одежды
stock CreateClothesActor(playerid, skin)
{
    DestroyClothesActor(playerid);
    OnlineInfo[playerid][oActorShop] = CreateDynamicActor(skin, 1536.977905, -1452.003784, 45.906265, 205.815200, true, 100.0, playerid+1, 0, playerid, 50.0, -1, 0);
    return 1;
}
stock DestroyClothesActor(playerid)
{
    if(OnlineInfo[playerid][oActorShop] != INVALID_VARIABLE)
    {
        DestroyDynamicActor(OnlineInfo[playerid][oActorShop]);
        OnlineInfo[playerid][oActorShop] = INVALID_VARIABLE;
    }
    return 1;
}
stock GoShmot(playerid, stat)
{
	S_SetPlayerVirtualWorld(playerid, playerid+1, 0);
 	PPSetPlayerInterior(playerid, 0);
	PPSetPlayerPos(playerid, 1542.2922,-1451.5934,45.9063), PPSetPlayerFacingAngle(playerid, 36.3980);
 	TogglePlayerControllable(playerid, false);
	InterpolateCameraPos(playerid, 1540.998779, -1459.510864, 46.879333, 1538.850585, -1455.088989, 46.521511, 1000);
	InterpolateCameraLookAt(playerid, 1538.275634, -1455.370727, 46.213356, 1536.296020, -1450.861206, 45.747303, 1000);
	SelectColorDraw(playerid);
	SetPVarInt(playerid, "SelectCharPlace", 0);
	SetPVarInt(playerid, "SkinLave", 0);
	OnlineInfo[playerid][oShowInterface] = 18;
	if(stat == 1)
	{
		TextDrawShowForPlayer(playerid, DressDraw[0]), TextDrawShowForPlayer(playerid, DressDraw[1]), TextDrawShowForPlayer(playerid, DressDraw[2]); // Фон Меню
		TextDrawShowForPlayer(playerid, DressDraw[3]), TextDrawShowForPlayer(playerid, DressDraw[4]); // Влево
		TextDrawShowForPlayer(playerid, DressDraw[5]), TextDrawShowForPlayer(playerid, DressDraw[6]); // Вправо
		TextDrawShowForPlayer(playerid, DressDraw[7]), TextDrawShowForPlayer(playerid, DressDraw[8]), TextDrawShowForPlayer(playerid, DressDraw[9]); // Select
	    if(Fractia[playerid] == 100) // Магазин Одежды
	    {
	    	show_skin(playerid, 100, 0, 0);
	    	TextDrawShowForPlayer(playerid, DressDraw[14]), TextDrawShowForPlayer(playerid, DressDraw[15]); // Список
	    	PlayerTextDrawSetString(playerid, PlaDressDraw[1], "CIVIL [1/50]");
			PlayerTextDrawShow(playerid, PlaDressDraw[1]);
	    }
		else if(Fractia[playerid] == 400) //Gold Shop
	    {
	    	show_skin(playerid, 400, 0, 0);
	    	PlayerTextDrawSetString(playerid, PlaDressDraw[1], "CIVIL");
			PlayerTextDrawShow(playerid, PlaDressDraw[1]);
	    }
	    else if(Fractia[playerid] >= 1 && Fractia[playerid] <= 22) // Раздевалка в Организации
		{
		    new g = Fractia[playerid];
			show_skin(playerid, g, 0, 0);
			if(g == 1) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "SAPD");
			else if(g == 2) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "FBI");
			else if(g == 3) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "NGSA");
			else if(g == 4) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "ASGH");
			else if(g == 5) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "COSA NOSTRA");
			else if(g == 6) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "YAKUZA");
			else if(g == 7) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "GOVERNMENT");
			else if(g == 8) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "ICA");
			else if(g == 9) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "CNN");
			else if(g == 10) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "TRIADA");
			else if(g == 11) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "SFPD");
			else if(g == 12) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "RUSSIAN MAFIA");
			else if(g == 13) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "GROVE STREET");
			else if(g == 14) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "BALLAS GANG");
			else if(g == 15) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "VAGOS GANG");
			else if(g == 16) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "LOS AZTECAS");
			else if(g == 18) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "ARABIAN MAFIA");
			else if(g == 21) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "LVPD");
			else if(g == 22) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "SWAT");
			PlayerTextDrawShow(playerid, PlaDressDraw[1]);
		}
	}
	else // При регистрации
	{
		Fractia[playerid] = 200;
		show_skin(playerid, 200, 0, 0);
		TextDrawShowForPlayer(playerid, DressDraw[3]), TextDrawShowForPlayer(playerid, DressDraw[4]);
		TextDrawShowForPlayer(playerid, DressDraw[5]), TextDrawShowForPlayer(playerid, DressDraw[6]);
		TextDrawShowForPlayer(playerid, DressDraw[7]), TextDrawShowForPlayer(playerid, DressDraw[8]), TextDrawShowForPlayer(playerid, DressDraw[9]);
		TextDrawShowForPlayer(playerid, DressDraw[10]), TextDrawShowForPlayer(playerid, DressDraw[11]);
		TextDrawShowForPlayer(playerid, DressDraw[12]), TextDrawShowForPlayer(playerid, DressDraw[13]);
	}
	return 1;
}

stock left_skin(playerid)
{
	PlayerPlaySound(playerid,17803,0,0,0);
	new select = GetPVarInt(playerid, "SelectCharPlace"), g = Fractia[playerid];
	if(g <= 22)
	{
		if(select >= 1) select --;
		else
		{
			for(new gs = MAX_SKIN_ORGANIZATION - 1; gs > 0; gs--)
			{
				if(OrganInfo[g][gSkin][gs] > 0)
				{
					select = gs;
					break;
				}
			}
		}
	}
	else if(g == 100) // Магазин
	{
		if(select >= 1) select --;
		else select = 49;
	}
	else if(g == 200) // Регистрация
	{
		if(select <= 0) select = MAX_SKIN_REG - 1;
		else select --;
	}
	SetPVarInt(playerid, "SelectCharPlace", select);
	show_skin(playerid, g, select, 1);
	return 1;
}

stock right_skin(playerid)
{
	PlayerPlaySound(playerid,17803,0,0,0);
	new select = GetPVarInt(playerid, "SelectCharPlace"), g = Fractia[playerid];
	if(g <= 22) // Организация
	{
		if(select < MAX_SKIN_ORGANIZATION - 1)
		{
			select ++;
			if(OrganInfo[g][gSkin][select] == 0) select = 0;
		}
		else select = 0;
	}
	else if(g == 100) // Магазин
	{
		if(select < 49) select ++;
		else select = 0;
	}
	else if(g == 200) // Регистрация
	{
		if(select >= MAX_SKIN_REG - 1) select = 0;
		else select ++;
	}
	else if(g == 400) // Gold Магазин
	{
		select ++;
	}
	SetPVarInt(playerid, "SelectCharPlace", select);
	show_skin(playerid, g, select, 0);
	return 1;
}

stock ExitShmot(playerid)
{
	SetPVarInt(playerid, "SelectCharPlace",0);
	keep(playerid);
	S_SetPlayerVirtualWorld(playerid, SkinWorld[playerid], SkinInt[playerid]);
   	PPSetPlayerInterior(playerid, SkinInt[playerid]);
	PPSetPlayerPos(playerid, SkinX[playerid], SkinY[playerid], SkinZ[playerid]);
 	PPSetPlayerFacingAngle(playerid, SkinA[playerid]);

	SetCameraBehindPlayer(playerid);
	CancelSelectTextDraw(playerid);

	RemovePlayerAttachedObject(playerid,5);
	DestroyClothesActor(playerid);

	if(PlayerInfo[playerid][pOdet][0] > 0) Odet(playerid, 5); // Возвращаем аксессуар в пятом слоте (Ибо примерка идёт на пятый слот)
	return 1;
}

stock CloseShmot(playerid)
{
	OnlineInfo[playerid][oShowInterface] = 0;
	Fractia[playerid] = 0;
	HidePlayerDialog(playerid);
	for(new t = 0; t < 16; t++) TextDrawHideForPlayer(playerid, DressDraw[t]);
	for(new pt = 0; pt < 5; pt++) PlayerTextDrawHide(playerid, PlaDressDraw[pt]);
	return 1;
}

stock ClickTextDraw_ClothesShop(playerid, Text:clickedid)
{
    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, Aftextdraw[playerid]);
    if(interval < 800) return 0; // Блокируем, если игрок клацает часто на кнопку

    if(clickedid == DressDraw[3]) // Выбор скина стрелка влево
    {
        if(Fractia[playerid] >= 1 && Fractia[playerid] <= 200 || Fractia[playerid] == 400) left_skin(playerid);
        else if(Fractia[playerid] == 300) left_akses(playerid);
    }
    if(clickedid == DressDraw[5]) // Выбор скина стрелка вправо
    {
        if(Fractia[playerid] >= 1 && Fractia[playerid] <= 200 || Fractia[playerid] == 400) right_skin(playerid);
        else if(Fractia[playerid] == 300) right_akses(playerid);
    }

    Aftextdraw[playerid] = current_tick;
    return 1;
}

stock skinprice(playerid, page) // Настройки гос. цен одежды
{
	new max_line = 40, yesNext, minlist, thisPage;
	new line[214],lines[4096];

	// Настраиваем отображение фильтров и страниц
	LoadPageSorting(playerid, 1075, 311 + MAX_SKIN_CUSTOM, minlist, page, thisPage);

	format(line,sizeof(line),"{cccccc}Одежда [ID]\t{cccccc}Цена\t{cccccc}Gold\t{cccccc}Куплено за Вирты / Gold"), strcat(lines,line);
	if(IsActiveSorting(playerid)) format(line,sizeof(line),"\n{ff9000}Фильтр {99ff66}[Активен]\t\t\t"), strcat(lines,line);
    else format(line,sizeof(line),"\n{ff9000}Фильтр\t\t\t"), strcat(lines,line);

	new one;
	for(new s = minlist; s < MAX_MODELS_SKIN; s++)
	{
		if(s == 0 || s == 74) continue; // Пропускаем косячные скины

		if(one == 0) OnlineInfo[playerid][oDialogMenu][4] = s, one = 1; // Записывали первый list

		if(CheckSortingLineSkinPrice(playerid, s)) format(line,sizeof(line),"%s", ShowLineSkinPrice(playerid, s)), strcat(lines,line);

		if(OnlineInfo[playerid][oDialogMenu][0] >= max_line) // Сбрасываем дальнейший вывод строк, если дошли до лимита на странице
        {
			yesNext = 1;
            break;
        }

		if(s >= 311 + MAX_SKIN_CUSTOM && page > 0)
		{
			yesNext = 1; // Последний list, отображаем Next Page
			OnlineInfo[playerid][oDialogMenu][5] = 1; // Записываем, что эта страница была последней
		}
	}
	if(yesNext == 1) format(line,sizeof(line),"\n{cccccc}Next Page >>\t\t\t"), strcat(lines,line);
	new header[60];
    format(header,sizeof(header),"Гос Стоимость Одежды [ Страница %d ]", page + 1);
    ShowDialog(playerid,1075,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Выбрать","Выход");
    return 1;
}

stock CheckSortingLineSkinPrice(playerid, s)
{
	if(OnlineInfo[playerid][oSorting][1] > 0) // Фильтр по ID
	{
		new sortingID[14], skinId[14];
		valstr(sortingID, OnlineInfo[playerid][oSorting][1]);
		valstr(skinId, s);

		if(strfind(skinId, sortingID, true) != -1) {} // Отображаем схожие ID
		else return 0; // Отображаем только фильтрованные id
	}

	if(!strcmp(OnlineInfo[playerid][oSortingName],"\0",true)) {} // Фильтр по названию не включен
	else
	{
		if(strfind(GetSkinName(s), OnlineInfo[playerid][oSortingName], true) != -1) {} // Отображаем схожую строку
		else return 0; // Отображаем только фильтрованные названия
	}
	return 1;
}

stock ShowLineSkinPrice(playerid, s)
{
	new line[214], atext[7], btext[7];

    List[OnlineInfo[playerid][oDialogMenu][0]][playerid] = s;
    OnlineInfo[playerid][oDialogMenu][0] ++; // Подсчитываем строки
	OnlineInfo[playerid][oDialogMenu][2] = s;

	// Custom or default
	if(s >= 312) atext = "0088ff";
	else atext = "cccccc";

	// Available for sale
	if(SkinSale[s]) btext = "99ff66";
	else btext = "cccccc";

    format(line,sizeof(line),"\n{%s}%s {cccccc}[%d]\t{%s}%d$ {cccccc}[%s]\t{ffcc00}%dG\t{cccccc}%d / %d", atext, GetSkinName(s), s, btext, SkinGos[s], get_k(SkinGos[s]), SkinGold[s], SkinBuy[s], SkinBuyGold[s]);
    return line;
}

stock SettingGosPriceSkin(playerid, list)
{
	new line[120],lines[600];
    if(list >= 312) format(line,sizeof(line),"{0088ff}%s {cccccc}ID: %d\t", GetSkinName(list), list), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}%s ID: %d\t", GetSkinName(list), list), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Стоимость:\t{99ff66}%d$ {cccccc}[%s]", SkinGos[list], get_k(SkinGos[list])), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Gold:\t{ffcc00}%dG", SkinGold[list]), strcat(lines,line);
	if(SkinSale[list]) format(line,sizeof(line),"\n{cccccc}Доступ к продаже:\t{99ff66}[ On ]"), strcat(lines,line);
	else format(line,sizeof(line),"\n{cccccc}Доступ к продаже:\t{FF6347}[ Off ]"), strcat(lines,line);
	if(list >= 312)
	{
		if(!strcmp(SkinName[list],"\0",true) || !strcmp(SkinName[list],"NULL",true)) format(line,sizeof(line),"\n{cccccc}Название: {FF6347}отсутствует\n"), strcat(lines,line);
		else format(line,sizeof(line),"\n{cccccc}Название: {0088ff}%s\n", SkinName[list]), strcat(lines,line);
	}
    ShowDialog(playerid,971,DIALOG_STYLE_TABLIST_HEADERS,"Гос Стоимость Одежды",lines,"Выбрать","Назад");
	return 1;
}

stock showFittingRoom(playerid)
{
	ShowDialog(playerid,1088,DIALOG_STYLE_TABLIST,"Доступные Товары","{ff9000}Одежда\n{ff9000}Аксессуары","Выбрать","Выход");
	return 1;
}

stock showDialogFittingRoomSkin(playerid, page)
{
	new max_line = 40, yesNext, minlist, thisPage;
	new line[214],lines[4096];

	// Настраиваем отображение фильтров и страниц
	LoadPageSorting(playerid, 1089, 311 + MAX_SKIN_CUSTOM, minlist, page, thisPage);

	format(line,sizeof(line),"{cccccc}Одежда [ID]\t{cccccc}Цена"), strcat(lines,line);
	if(IsActiveSorting(playerid)) format(line,sizeof(line),"\n{ff9000}Фильтр {99ff66}[Активен]\t"), strcat(lines,line);
    else format(line,sizeof(line),"\n{ff9000}Фильтр\t"), strcat(lines,line);

	new one;
	for(new s = minlist; s < MAX_MODELS_SKIN; s++)
	{
		if(s == 0 || s == 74 || SkinSale[s] <= 0) continue; // Пропускаем

		if(one == 0) OnlineInfo[playerid][oDialogMenu][4] = s, one = 1; // Записывали первый list

		if(CheckSortingLineSkinPrice(playerid, s)) format(line,sizeof(line),"%s", ShowLineFittingRoom(playerid, s)), strcat(lines,line);

		if(OnlineInfo[playerid][oDialogMenu][0] >= max_line) // Сбрасываем дальнейший вывод строк, если дошли до лимита на странице
        {
			yesNext = 1;
            break;
        }

		if(s >= 311 + MAX_SKIN_CUSTOM && page > 0)
		{
			yesNext = 1; // Последний list, отображаем Next Page
			OnlineInfo[playerid][oDialogMenu][5] = 1; // Записываем, что эта страница была последней
		}
	}
	if(yesNext == 1) format(line,sizeof(line),"\n{cccccc}Next Page >>\t\t\t"), strcat(lines,line);
	new header[60];
    format(header,sizeof(header),"Одежда [ Страница %d ]", page + 1);
    ShowDialog(playerid,1089,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Выбрать","Выход");
    return 1;
}

stock ShowLineFittingRoom(playerid, s)
{
	new line[214], atext[7];

    List[OnlineInfo[playerid][oDialogMenu][0]][playerid] = s;
    OnlineInfo[playerid][oDialogMenu][0] ++; // Подсчитываем строки
	OnlineInfo[playerid][oDialogMenu][2] = s;

	// Custom or default
	if(s >= 312) atext = "0088ff";
	else atext = "cccccc";

    format(line,sizeof(line),"\n{%s}%s {cccccc}[%d]\t{99ff66}%d$ {cccccc}[%s]", atext, GetSkinName(s), s, SkinGos[s], get_k(SkinGos[s]));
    return line;
}

stock dialogCase_Clothes(playerid, dialogid, response, listitem, const inputtext[])
{
	if(dialogid == 1075)
	{
		if(response)
		{
			if(listitem == 0) DialogMenuSorting(playerid);

			if(OnlineInfo[playerid][oDialogMenu][0] > 0) // Есть строки на странице
			{
				if(listitem >= 1 && listitem <= OnlineInfo[playerid][oDialogMenu][0]) // Отображаемые List
				{
					new list = List[listitem-1][playerid];
					OnlineInfo[playerid][oDialogMenu][3] = list;
					SettingGosPriceSkin(playerid, list);
				}
				else if(listitem == OnlineInfo[playerid][oDialogMenu][0] + 1) skinprice(playerid, OnlineInfo[playerid][oDialogMenu][1] + 1); // Следующая страница
			}
		}
		else pc_cmd_economy(playerid);
	}
	else if(dialogid == 971)
	{
		if(response)
		{
			new list = OnlineInfo[playerid][oDialogMenu][3];
			if(listitem == 0)
			{
				new line[100],lines[300];
				format(line,sizeof(line),"{cccccc}Введите гос. стоимость для {ff9000}%s", GetSkinName(list)), strcat(lines,line);
				format(line,sizeof(line),"\n\n{cccccc}Текущая Стоимость: {99ff66}%d$ {cccccc}[%s]", SkinGos[list], get_k(SkinGos[list])), strcat(lines,line);
				format(line,sizeof(line),"\n{cccccc}Не меньше 1$ и не больше 900.000.000$"), strcat(lines,line);
				ShowDialog(playerid,970,DIALOG_STYLE_INPUT,"Одежда",lines,"Принять","Отмена");
			}
			else if(listitem == 1)
			{
				new line[100],lines[300];
				format(line,sizeof(line),"{cccccc}Введите Gold стоимость для {ff9000}%s", GetSkinName(list)), strcat(lines,line);
				format(line,sizeof(line),"\n\n{cccccc}Текущая Стоимость: {ffcc00}%dG", SkinGold[list]), strcat(lines,line);
				format(line,sizeof(line),"\n{cccccc}Не меньше 0G и не больше 100.000G"), strcat(lines,line);
				ShowDialog(playerid,946,DIALOG_STYLE_INPUT,"Одежда",lines,"Принять","Отмена");
			}
			else if(listitem == 2)
			{
				if(SkinSale[list]) SkinSale[list] = 0;
				else SkinSale[list] = 1;
				SaveSkinSale(list);
				SettingGosPriceSkin(playerid, list);
			}
			else if(listitem == 3)
			{
				if(list < 312) return ErrorText(playerid, "{FF6347}Ошибка! Нельзя изменить название стандартного скина"), SettingGosPriceSkin(playerid, list);
				new line[100],lines[300];
				format(line,sizeof(line),"{cccccc}Введите название для {ff9000}%s", GetSkinName(list)), strcat(lines,line);
				format(line,sizeof(line),"\n{cccccc}Количество символов не меньше 1 и не больше 30"), strcat(lines,line);
				ShowDialog(playerid,574,DIALOG_STYLE_INPUT,"Одежда",lines,"Принять","Отмена");
			}
		}
		else skinprice(playerid, OnlineInfo[playerid][oDialogMenu][1]);
	}
	else if(dialogid == 970)
	{
		if(response)
		{
			new input = strval(inputtext);
			new list = OnlineInfo[playerid][oDialogMenu][3];
			if(input < 1 || input > 900000000) return ErrorText(playerid, "{FF6347}Не меньше 1$ и не больше 900.000.000$"), SettingGosPriceSkin(playerid, list);
			SkinGos[list] = input;

			PlayerPlaySound(playerid, 6401, 0,0,0);
			SaveSkinEconomy(list);

			new string[180];
			format(string,sizeof(string),"[ Мысли ]: Гос. стоимость одежды %s ID %d теперь составляет: {99ff66}%d$ [%s]", GetSkinName(list), list, SkinGos[list], get_k(SkinGos[list]));
  			SendClientMessage(playerid,COLOR_GREY,string);
  			format(string, sizeof(string), "[Правительство] %s изменяет гос. стоимость одежды %s ID %d {99ff66}%d$ [%s]", PlayerInfo[playerid][pName], GetSkinName(list), list, SkinGos[list], get_k(SkinGos[list]));
  			SendDepartMessage(COLOR_ALLDEPT, string);
			SettingGosPriceSkin(playerid, OnlineInfo[playerid][oDialogMenu][3]);
     		format(string,sizeof(string),"Одежда ID %d", list);
     		OrgLog(7, "minfin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", input, string);

			// Сбрасываем ценники в Магазинах с Одеждой
     		for(new b = 173; b < 182; b++) ResetBizzPriceItem(playerid, b, list, 3, input);
		}
		else SettingGosPriceSkin(playerid, OnlineInfo[playerid][oDialogMenu][3]);
	}
	else if(dialogid == 946)
	{
		if(response)
		{
			new list = OnlineInfo[playerid][oDialogMenu][3];
			if(PlayerInfo[playerid][pSoska] < 20) return ErrorText(playerid, "{FF6347}Только для администраторов 20+ уровня"), SettingGosPriceSkin(playerid, list);
			new input = strval(inputtext);
			if(input < 0 || input > 100000) return ErrorText(playerid, "{FF6347}Не меньше 0G и не больше 100.000G"), SettingGosPriceSkin(playerid, list);
			SkinGold[list] = input;

			PlayerPlaySound(playerid, 6401, 0,0,0);
			SaveSkinGold(list);

			new string[180];
			format(string,sizeof(string),"[ Мысли ]: Gold стоимость одежды %s ID %d теперь составляет: {ffcc00}%dG", GetSkinName(list), list, SkinGold[list]);
  			SendClientMessage(playerid,COLOR_GREY,string);
  			SettingGosPriceSkin(playerid, OnlineInfo[playerid][oDialogMenu][3]);

			format(string,sizeof(string),"%dG %s", input, GetSkinName(list));
			AdminLog("skingold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", list, string);
		}
		else SettingGosPriceSkin(playerid, OnlineInfo[playerid][oDialogMenu][3]);
	}
	else if(dialogid == 574)
	{
		if(response)
		{
			new list = OnlineInfo[playerid][oDialogMenu][3];
			if(PlayerInfo[playerid][pSoska] < 20) return ErrorText(playerid, "{FF6347}Только для администраторов 20+ уровня"), SettingGosPriceSkin(playerid, list);
			if(!strlen(inputtext)) return SettingGosPriceSkin(playerid, list);
			if(strlen(inputtext) < 1 || strlen(inputtext) > 30) return ErrorText(playerid, "{FF6347}Не меньше одного и не больше 30 символов"), SettingGosPriceSkin(playerid, list);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "{FF6347}Вы используете запрещённый символ в названии"), SettingGosPriceSkin(playerid, list);

			format(SkinName[list], MAX_SKIN_NAME ,"%s", inputtext);
			PlayerPlaySound(playerid, 6401, 0,0,0);
			SaveSkinName(list);

			new string[180];
  			SendClientMessage(playerid,COLOR_GREY,"[ Мысли ]: Название одежды ID %d теперь: {0088ff}%s", list, SkinName[list]);
  			SettingGosPriceSkin(playerid, OnlineInfo[playerid][oDialogMenu][3]);

			format(string,sizeof(string),"ID %d %s", list, SkinName[list]);
			AdminLog("skinname", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", list, string);
		}
		else SettingGosPriceSkin(playerid, OnlineInfo[playerid][oDialogMenu][3]);
	}
	else if(dialogid == 1089)
	{
		if(response)
		{
			if(listitem == 0) DialogMenuSorting(playerid);

			if(OnlineInfo[playerid][oDialogMenu][0] > 0) // Есть строки на странице
			{
				if(listitem >= 1 && listitem <= OnlineInfo[playerid][oDialogMenu][0]) // Отображаемые List
				{
					new list = List[listitem-1][playerid];
					OnlineInfo[playerid][oDialogMenu][3] = list;
					OpenListClothes(playerid, list);
				}
				else if(listitem == OnlineInfo[playerid][oDialogMenu][0] + 1) showDialogFittingRoomSkin(playerid, OnlineInfo[playerid][oDialogMenu][1] + 1); // Следующая страница
			}
		}
		else 
		{
			if(DP[4][playerid] == 0) showFittingRoom(playerid); // В примерочной
			else ShowOrderThing(playerid, DP[4][playerid]); // В меню бизнеса
		}
	}
	return 1;
}

stock OpenListClothes(playerid, list)
{
	new b = DP[4][playerid];
	if(b > 0) // Открыли в меню бизнеса (Значит тут мы заказываем его)
	{
		AddThingToOrder(playerid, b, list, 3); // biz, thingId, thingType
		return 1;
	}
	else
	{
		if(IsPlayerInRangeOfPoint(playerid,80.0,1383.9026,-26.2840,1000.9112) && GetPlayerVirtualWorld(playerid) == 10 && GetPlayerInterior(playerid) == 10)
		{
			if(gSkafandr[playerid] > 0 || gFormavvs[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Снимите форму, чтобы примерить одежду\n{cccccc}На вас надета какая-то форма, костюм или временный скин");

			TryOnClothes(playerid, list, 0);
			ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы запустили просмотр одежды\n\n{ff9000}Правая Кнопка Мыши - вперёд\nЛевая Кнопка Мыши - назад","*","");
			SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Правая Кнопка Мыши - вперёд | Левая Кнопка Мыши - назад");
		}
		else ErrorMessage(playerid, "{FF6347}Вы покинули примерочную");
	}
	return 1;
}

stock TryOnClothes(playerid, skin, status)
{
	OnlineInfo[playerid][oFittingRoom] = skin;
	m_custom_sync_SetPlayerSkin(playerid, skin);
	PlayerPlaySound(playerid,5600,0,0,0);

	new string[60];
	format(string, sizeof(string), "примеряет одежду ID %d", skin);
	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 20.0, 5000);

	if(status == 0) format(string, sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Skin ID: ~y~%d", skin);
	else if(status == 1) format(string, sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Skin ID: ~y~%d~n~~r~>>", skin);
	else if(status == 2) format(string, sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Skin ID: ~y~%d~n~~r~<<", skin);
	GameTextForPlayer(playerid, string, 8000, 3);
	return 1;
}

stock NextOnClothes(playerid)
{
	new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, Afclick[playerid]);
    if(interval < 700) return 0; // Блокируем, если игрок клацает часто на кнопку
	Afclick[playerid] = current_tick;

	new findSkin;
	OnlineInfo[playerid][oFittingRoom] ++;
	if(OnlineInfo[playerid][oFittingRoom] >= 311 + MAX_SKIN_CUSTOM) OnlineInfo[playerid][oFittingRoom] = 1; // Открыт максимальный, значит перелистываем на начало 1

	for(new s = OnlineInfo[playerid][oFittingRoom]; s < MAX_MODELS_SKIN; s++)
	{
		if(s == 0 || s == 74 || SkinSale[s] <= 0) continue; // Пропускаем
		if(findSkin == 0)
		{
			findSkin = s;
			break;
		}
	}

	// Так и не нашли скин, тогда открываем первый
	if(findSkin == 0)
	{
		for(new s = 1; s < MAX_MODELS_SKIN; s++)
		{
			if(s == 0 || s == 74 || SkinSale[s] <= 0) continue; // Пропускаем
			if(findSkin == 0)
			{
				findSkin = s;
				break;
			}
		}
	}

	TryOnClothes(playerid, findSkin, 1);
	return 1;
}

stock BackOnClothes(playerid)
{
	new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, Afclick[playerid]);
    if(interval < 700) return 0; // Блокируем, если игрок клацает часто на кнопку
	Afclick[playerid] = current_tick;

	new findSkin;
	OnlineInfo[playerid][oFittingRoom] --;

	if(OnlineInfo[playerid][oFittingRoom] <= 0) OnlineInfo[playerid][oFittingRoom] = 311 + MAX_SKIN_CUSTOM; // Открыт первый, значит перелистываем в конец

	for(new s = OnlineInfo[playerid][oFittingRoom]; s > 0; s--)
	{
		if(s == 0 || s == 74 || SkinSale[s] <= 0) continue; // Пропускаем
		if(findSkin == 0)
		{
			findSkin = s;
			break;
		}
	}

	// Так и не нашли скин, тогда открываем последний
	if(findSkin == 0)
	{
		for(new s = MAX_MODELS_SKIN - 1; s > 0; s--)
		{
			if(s == 0 || s == 74 || SkinSale[s] <= 0) continue; // Пропускаем
			if(findSkin == 0)
			{
				findSkin = s;
				break;
			}
		}
	}

	TryOnClothes(playerid, findSkin, 2);
	return 1;
}

stock buy_SkinShop(playerid)
{
	if(Fractia[playerid] == 0) return 1;

	new g = Fractia[playerid], sel = GetPVarInt(playerid, "SelectCharPlace"), skin, price, srank, b = Bid[playerid]-173, quan;
	if(g >= 1 && g <= 22) skin = OrganInfo[g][gSkin][sel], price = OrganInfo[g][gSkinPrice][sel], srank = OrganInfo[g][gSkinRank][sel];
	else if(g == 100) skin = StoreItem[b][sel], price = StorePrice[b][sel], quan = StoreQuan[b][sel];
	else if(g == 400) skin = GetPVarInt(playerid, "SkinLave");

	if(skin == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! В слоте нет одежды");
	if(GetSkinSex(skin) == 2 && PlayerInfo[playerid][pSex] == 1) return ErrorMessage(playerid, "{FF6347}Вы не можете купить женскую одежду");
	else if(GetSkinSex(skin) == 1 && PlayerInfo[playerid][pSex] == 2) return ErrorMessage(playerid, "{FF6347}Вы не можете купить мужскую одежду");

	new gold = SkinGold[skin];
	new string[144], yesBuy;
	if(g >= 1 && g <= 22)
	{
		if(g != fraction(playerid)) return ErrorMessage(playerid, "{FF6347}Вы не можете носить эту одежду [ Другая организация ]");
		if(PlayerInfo[playerid][pRank] < srank) return format(string, sizeof(string),"{FF6347}Эта одежда доступна с %d ранга", srank), ErrorMessage(playerid, string);
		yesBuy = 1;
	}
	else if(g == 100 || g == 400)
	{
		if(quan <= 0 && g == 100) return ErrorMessage(playerid, "{FF6347}Ошибка! Одежды нет в магазине [ Возможно её кто-то купил ]");
		if(DP[0][playerid] == 0 && price <= 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Этой одежде не установлена стоимость");
		if(DP[0][playerid] == 1 && gold <= 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Этой одежде не установлена gold стоимость");
		g = 0;
		yesBuy = 1;
	}

	if(yesBuy)
	{
		if(DP[0][playerid] == 0)
		{
			if(oGetPlayerMoney(playerid) < price) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
			new put_inva = GiveThingPlayer(playerid, skin, 1, g, 0, 3, 0, 9999);
			if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");

			PlayerPlaySound(playerid,6401,0,0,0);
			if(price == 0)
			{
				if(PlayerInfo[playerid][pSex] == 1) format(string, sizeof(string),"[ Мысли ]: Я взял одежду {ff9000}[ID: %d] (Одежда в инвентаре)", skin), SendClientMessage(playerid, COLOR_GREY, string);
				else format(string, sizeof(string),"[ Мысли ]: Я взяла одежду {ff9000}[ID: %d] (Одежда в инвентаре)", skin), SendClientMessage(playerid, COLOR_GREY, string);
			}
			else
			{
				format(string, sizeof(string),"[ Мысли ]: Я купил%s одежду за {99ff66}%d$ {ff9000}[ID: %d] (Одежда в инвентаре)", gender(playerid), price, skin);
				SendClientMessage(playerid, COLOR_GREY, string);
				oGivePlayerMoney(playerid, -price);
				format(string, sizeof(string),"Одежда ID: %d", skin);
				MoneyLog("buyskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, string);

				GiveQuanBuySkin(skin, 0);
			}

			if(g >= 1 && g <= 22)
			{
				OrganInfo[g][glave] += price, OrganInfo[g][gUpdate] = 1;
			}
			else if(g == 100)
			{
				paybiz(Bid[playerid], price);
				if(BizzInfo[b+173][bSost] > 0) StoreQuan[b][sel] -= 1;
				if(StoreQuan[b][sel] <= 0)
				{
					StoreItem[b][sel] = 0, StorePrice[b][sel] = 0;
					foreach(Player,i)
					{
						if(Fractia[i] != 100) continue;
						if(GetPVarInt(i, "SelectCharPlace") != sel) continue;
						show_skin(i, 100, sel, 0);
						if(i != playerid)  ErrorMessage(i, "{FF6347}Внимание! Кто-то только что купил последнюю одежду, которую вы просматривали");
					}
				}
				SaveBizzStore(b, sel);
			}
		}
		else if(DP[0][playerid] == 1)
		{
			if(gold <= 0) return ErrorMessage(playerid, "{FF6347}Эта одежда не продаётся за Gold");
			if(PlayerInfo[playerid][pDonateMoney] < gold) return ErrorMessage(playerid, "{FF6347}Вам не хватает золота [ Y >> Donate ]");
			new put_inva = GiveThingPlayer(playerid, skin, 1, g, 0, 3, 0, 9999);
			if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");

			PlayerPlaySound(playerid,6401,0,0,0);
			format(string, sizeof(string),"[ Мысли ]: Я купил%s одежду за {ffcc00}%dG {ff9000}[ID: %d] (Одежда в инвентаре)", gender(playerid), gold, skin);
			SendClientMessage(playerid, COLOR_GREY, string);
			format(string, sizeof(string),"Одежда ID: %d", skin);
            DonateLog("buyskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -gold, string);
			PlayerInfo[playerid][pDonateMoney] -= gold;
            mysql_save(playerid, 4);

			GiveQuanBuySkin(skin, 0);
		}
	}
	return 1;
}

stock FindNextGoldSkin(find)
{
    new findSkin = -1; // Инициализируем переменную значением, указывающим на "не найдено"

    // Первый проход: ищем скин после значения 'find'
    for(new s = find + 1; s < MAX_MODELS_SKIN; s++)
    {
        if(s == 0 || s == 74) continue;
        if(SkinSale[s] == 1 && SkinGold[s] > 0)
        {
            findSkin = s;
            break;
        }
    }

    // Если скин не найден в первом проходе, делаем второй проход от начала
    if(findSkin == -1)
    {
        for(new s = 0; s <= find; s++)
        {
            if(s == 0 || s == 74) continue;
            if(SkinSale[s] == 1 && SkinGold[s] > 0)
            {
                findSkin = s;
                break;
            }
        }
    }
    return findSkin;
}
stock FindPreviousGoldSkin(find)
{
    new findSkin = -1; // Инициализация переменной значением "не найдено"

    // Первый проход: ищем скин перед значением 'find'
    for(new s = find - 1; s >= 0; s--)
    {
        if(s == 0 || s == 74) continue;
        if(SkinSale[s] == 1 && SkinGold[s] > 0)
        {
            findSkin = s;
            break;
        }
    }

    // Если скин не найден в первом проходе, делаем второй проход от конца
    if(findSkin == -1)
    {
        for(new s = MAX_MODELS_SKIN - 1; s > find; s--)
        {
            if(s == 0 || s == 74) continue;
            if(SkinSale[s] == 1 && SkinGold[s] > 0)
            {
                findSkin = s;
                break;
            }
        }
    }
    return findSkin;
}

stock GiveQuanBuySkin(s, typeBuy)
{
    if(typeBuy == 0) SkinBuy[s] ++, SaveSkinBuy(s);
    else if(typeBuy == 1) SkinBuyGold[s] ++, SaveSkinBuyGold(s);
    return 1;
}

stock IsAClothesNearby(playerid)
{
	if(GetPlayerVirtualWorld(playerid) >= 173 && GetPlayerVirtualWorld(playerid) <= 182 
	&& (IsPlayerInRangeOfPoint(playerid,1.0,202.8426,-107.7787,1005.1328)
		|| IsPlayerInRangeOfPoint(playerid,1.0,199.0932,-162.7284,1000.5234)
		|| IsPlayerInRangeOfPoint(playerid,1.0,210.8270,-127.6644,1003.5152)
		|| IsPlayerInRangeOfPoint(playerid,1.0,197.9495,-40.3282,1001.8047)
		|| IsPlayerInRangeOfPoint(playerid,1.0,210.9073,-4.5470,1001.2109)
		|| IsPlayerInRangeOfPoint(playerid,1.0,145.9741,-83.2575,1001.8047))) return 1;
	return 0;
}

stock IsAGoldClothesNearby(playerid)
{
	if(GetPlayerVirtualWorld(playerid) >= 173 && GetPlayerVirtualWorld(playerid) <= 182 
	&& (IsPlayerInRangeOfPoint(playerid,1.0,212.5430,-107.8574,1005.1328)
		|| IsPlayerInRangeOfPoint(playerid,1.0,209.6027,-162.7853,1000.5234)
		|| IsPlayerInRangeOfPoint(playerid,1.0,216.0805,-132.9592,1003.5078)
		|| IsPlayerInRangeOfPoint(playerid,1.0,208.5516,-45.2005,1001.8047)
		|| IsPlayerInRangeOfPoint(playerid,1.0,213.2845,-4.5177,1001.2109)
		|| IsPlayerInRangeOfPoint(playerid,1.0,169.7810,-83.5137,1001.8120))) return 1;
	return 0;
}

// Одежда
stock IsAShmot(playerid)
{
 	if(IsPlayerInRangeOfPoint(playerid,1.0,2496.0188,-1695.8295,2073.9805) && GetPlayerVirtualWorld(playerid) == 212 && GetPlayerInterior(playerid) == 212 // Grove
	|| IsPlayerInRangeOfPoint(playerid,1.0,2488.1748,-2021.3531,2052.2808) && GetPlayerVirtualWorld(playerid) == 213 && GetPlayerInterior(playerid) == 213 // Ballas
	|| IsPlayerInRangeOfPoint(playerid,1.0,2261.6941,-1459.2672,2089.4438) && GetPlayerVirtualWorld(playerid) == 214 && GetPlayerInterior(playerid) == 214 // Vagos
	|| IsPlayerInRangeOfPoint(playerid,1.0,1684.0817,-2098.6365,2091.8000) && GetPlayerVirtualWorld(playerid) == 215 && GetPlayerInterior(playerid) == 215 // Aztecas
	|| IsPlayerInRangeOfPoint(playerid,1.0,2607.8682,918.0507,1551.0000) // Department Раздевалка
	|| IsPlayerInRangeOfPoint(playerid,1.0,1383.1306,-1.3530,1000.9217) && GetPlayerVirtualWorld(playerid) == 9 && GetPlayerInterior(playerid) == 5 // Госпиталь
 	|| IsPlayerInRangeOfPoint(playerid,1.0,-1507.6846,1957.5139,1357.0326) && GetPlayerVirtualWorld(playerid) == 5 && GetPlayerInterior(playerid) == 1 // Cosa Nostra
	|| IsPlayerInRangeOfPoint(playerid,1.0,1539.6632,1319.2186,16.0415) 
		&& GetPlayerVirtualWorld(playerid) == WORLD_YAKUZA_1LVL && GetPlayerInterior(playerid) == INT_YAKUZA_1LVL // Yakuza Mafia
	|| IsPlayerInRangeOfPoint(playerid,1.0,-2008.8141,152.5642,1666.0313) && GetPlayerInterior(playerid) == 7 && GetPlayerVirtualWorld(playerid) == 7 // Правительство
	|| IsPlayerInRangeOfPoint(playerid,1.0,-506.7065,-87.0514,964.8114) && GetPlayerVirtualWorld(playerid) == 8 && GetPlayerInterior(playerid) == 8 // Hitman Agency
	|| IsPlayerInRangeOfPoint(playerid,1.0,1416.2957,-1212.1395,124.0505)
		&& GetPlayerVirtualWorld(playerid) == WORLD_CNN_2LVL && GetPlayerInterior(playerid) == INT_CNN_2LVL // CNN
	|| IsPlayerInRangeOfPoint(playerid,1.0,-1997.9194,1110.0148,1018.6735) && GetPlayerVirtualWorld(playerid) == 12 && GetPlayerInterior(playerid) == 1 // Russian Mafia
	|| IsPlayerInRangeOfPoint(playerid,1.0,-1928.6663,906.0461,1402.0776) && GetPlayerVirtualWorld(playerid) == 10 && GetPlayerInterior(playerid) == 10 // Triada Mafia
	|| IsPlayerInRangeOfPoint(playerid,1.0,919.1400,1378.4596,1029.4221) 
		&& GetPlayerVirtualWorld(playerid) == WORLD_ARABIAN_M1LVL && GetPlayerInterior(playerid) == INT_ARABIAN_M1LVL // Arabian Mafia
	|| IsAClothesNearby(playerid)
	|| IsAGoldClothesNearby(playerid)) // Магаз одежды
    {
		return 1;
	}
	return 0;
}

function LoadPriceSkin()
{
	new time = GetTickCount();
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new skinList;
		for(new s = 0; s < MAX_MODELS_SKIN; s++)
		{
			cache_get_value_name_int(s, "skin", skinList); // Получаем id для переменной

			cache_get_value_name_int(s, "SkinGos", SkinGos[skinList]);
			cache_get_value_name_int(s, "SkinGold", SkinGold[skinList]);
			cache_get_value_name_int(s, "SkinSale", SkinSale[skinList]);
			cache_get_value_name_int(s, "SkinBuy", SkinBuy[skinList]);
			cache_get_value_name_int(s, "SkinBuyGold", SkinBuyGold[skinList]);
			cache_get_value_name(s, "SkinName", SkinName[skinList], MAX_SKIN_NAME);
		}
		printf("[MODE]: Настройки Скинов [%d ms]", GetTickCount() - time);

		// Собираем набор скинов для кейса
		CreateSkinGiftCase();
	}
	return 1;
}

// Сохраняем стоимость скина за вирты
stock SaveSkinEconomy(s)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceskin` SET `SkinGos` = '%d' WHERE `skin` = '%d'", SkinGos[s], s);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем стоимость скина за голду
stock SaveSkinGold(s)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceskin` SET `SkinGold` = '%d' WHERE `skin` = '%d'", SkinGold[s], s);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем статус продажи скина
stock SaveSkinSale(s)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceskin` SET `SkinSale` = '%d' WHERE `skin` = '%d'", SkinSale[s], s);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем количество продаж скинов за вирты
stock SaveSkinBuy(s)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceskin` SET `SkinBuy` = '%d' WHERE `skin` = '%d'", SkinBuy[s], s);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем количество продаж скинов за голду
stock SaveSkinBuyGold(s)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceskin` SET `SkinBuyGold` = '%d' WHERE `skin` = '%d'", SkinBuyGold[s], s);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем название скина
stock SaveSkinName(s)
{
    new string_mysql[200];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceskin` SET `SkinName` = '%e' WHERE `skin` = '%d'", SkinName[s], s);
	query_empty(pearsq, string_mysql);
    return 1;
}

CMD:rskinquan(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 25) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

	mysql_tquery(pearsq, "START TRANSACTION;");
	for(new s = 0; s < MAX_MODELS_SKIN; s++)
	{
		if(SkinBuy[s] > 0) 
		{
			SkinBuy[s] = 0;
			SaveSkinBuy(s);
		}

		if(SkinBuyGold[s] > 0) 
		{
			SkinBuyGold[s] = 0;
			SaveSkinBuyGold(s);
		}
	}

	mysql_tquery(pearsq, "COMMIT;");

	new string[144];
	format(string, sizeof(string), " [ ADM ]: %s сбросил подсчёт всех скинов (SkinBuy, SkinBuyGold)", PlayerInfo[playerid][pName]);
 	ABroadCast(COLOR_ADM,string,1);
	AdminLog("rskinquan", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
	return 1;
}

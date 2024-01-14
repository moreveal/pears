
/*
Как добавить новый кастомный скин на сервер?
1. Добавить в stock AddCustomSkins новый AddCharSyncModel (Оригинальный скин, Новый ID следующий по порядку)
2. Увеличить define MAX_SKIN_CUSTOM
3. Если скин мужской - добавить новый ID в stock GetSkinSex

Как добавить скин в магазины?
1. В настройках гос цен правительства указываешь ценник и доступ для заказа в магазы (и УСЁ)
*/

#define MAX_SKIN_CUSTOM 113

new SkinGos[312 + MAX_SKIN_CUSTOM]; // Стоимости скинов
new bool:skingosUpdate;
new SkinGold[312 + MAX_SKIN_CUSTOM]; // Gold стоимости скинов
new SkinBuy[312 + MAX_SKIN_CUSTOM]; // Подсчет покупок скинов за вирты
new SkinBuyGold[312 + MAX_SKIN_CUSTOM]; // Подсчет покупок скинов за голду
new SkinSale[312 + MAX_SKIN_CUSTOM]; // Доступен ли скин для продажи
new bool:skinsaleUpdate;

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

stock AddCustomSkins()
{
	// AddCarSyncModel(Оригинальный, Новый) ID в сборке с 15500 до 15999
	// Plus 15188

	// В целом добавить ещё скинов
	AddCharSyncModel(294, 312); // 15500, pearspedcu male
	AddCharSyncModel(60, 313); // pearspeda (Значит не 313, а 15501) male
	AddCharSyncModel(233, 314); // pearspedb (Значит не 314, а 15502)
	AddCharSyncModel(19, 315); // 15503 pearspedc male
	AddCharSyncModel(59, 316); // 15504 pearspedd male
	AddCharSyncModel(93, 317); // 15505, pearspede
	AddCharSyncModel(19, 318); // 15506, pearspedf male
	AddCharSyncModel(59, 319); // 15507, pearspedg male
	AddCharSyncModel(125, 320); // 15508, pearspedh male
	AddCharSyncModel(23, 321); // 15509, pearspedi male
	AddCharSyncModel(21, 322); // 15510, pearspedj male
	AddCharSyncModel(216, 323); // 15511, pearspedk
	AddCharSyncModel(55, 324); // 15512, pearspedl
	AddCharSyncModel(93, 325); // 15513, pearspedm
	AddCharSyncModel(7, 326); // 15514, pearspedn male
	AddCharSyncModel(125, 327); // 15515, pearspedo male
	AddCharSyncModel(1, 328); // 15516, pearspedp male
	AddCharSyncModel(248, 329); // 15517, pearspedq male
	AddCharSyncModel(29, 330); // 15518, pearspedr male
	AddCharSyncModel(121, 331); // 15519, pearspeds male
	AddCharSyncModel(125, 332); // 15520, pearspedt male
	AddCharSyncModel(240, 333); // 15521, pearspedu male
	AddCharSyncModel(223, 334); // 15522, pearspedv male
	AddCharSyncModel(28, 335); // 15523, pearspedw male
	AddCharSyncModel(25, 336); // 15524, pearspedx male
	AddCharSyncModel(150, 337); // 15525, pearspedy
	AddCharSyncModel(237, 338); // 15526, pearspedz
	AddCharSyncModel(93, 339); // 15527, pearspedaa
	AddCharSyncModel(12, 340); // 15528, pearspedab
	AddCharSyncModel(40, 341); // 15529, pearspedac
	AddCharSyncModel(178, 342); // 15530, pearspedad
	AddCharSyncModel(233, 343); // 15531, pearspedae
	AddCharSyncModel(93, 344); // 15532, pearspedaf
	AddCharSyncModel(226, 345); // 15533, pearspedag 
	AddCharSyncModel(223, 346); // 15534, pearspedah
	AddCharSyncModel(233, 347); // 15535, pearspedai
	AddCharSyncModel(233, 348); // 15536, pearspedaj
	AddCharSyncModel(233, 349); // 15537, pearspedak
	AddCharSyncModel(93, 350); // 15538, pearspedal
	AddCharSyncModel(233, 351); // 15539, pearspedam
	AddCharSyncModel(223, 352); // 15540, pearspedan male
	AddCharSyncModel(240, 353); // 15541, pearspedao male
	AddCharSyncModel(126, 354); // 15542, pearspedap male
	AddCharSyncModel(93, 355); // 15543, pearspedaq
	AddCharSyncModel(240, 356); // 15544, pearspedar male
	AddCharSyncModel(93, 357); // 15545, pearspedas
	AddCharSyncModel(93, 358); // 15546, pearspedat
	AddCharSyncModel(91, 359); // 15547, pearspedau
	AddCharSyncModel(233, 360); // 15548, pearspedav
	AddCharSyncModel(216, 361); // 15549, pearspedaw
	AddCharSyncModel(216, 362); // 15550, pearspedax
	AddCharSyncModel(93, 363); // 15551, pearspeday
	AddCharSyncModel(240, 364); // 15552, pearspedaz male
	AddCharSyncModel(180, 365); // 15553, pearspedba male
	AddCharSyncModel(226, 366); // 15554, pearspedbb
	AddCharSyncModel(60, 367); // 15555, pearspedbc male
	AddCharSyncModel(257, 368); // 15556, pearspedbd
	AddCharSyncModel(257, 369); // 15557, pearspedbe
	AddCharSyncModel(41, 370); // 15558, pearspedbf
	AddCharSyncModel(40, 371); // 15559, pearspedbg
	AddCharSyncModel(233, 372); // 15560, pearspedbh
	AddCharSyncModel(233, 373); // 15561, pearspedbi
	AddCharSyncModel(93, 374); // 15562, pearspedbj
	AddCharSyncModel(233, 375); // 15563, pearspedbk
	AddCharSyncModel(98, 376); // 15564, pearspedbl male
	AddCharSyncModel(98, 377); // 15565, pearspedbm male
	AddCharSyncModel(98, 378); // 15566, pearspedbn male
	AddCharSyncModel(98, 379); // 15567, pearspedbo male
	AddCharSyncModel(112, 380); // 15568, pearspedbp male
	AddCharSyncModel(127, 381); // 15569, pearspedbq male
	AddCharSyncModel(127, 382); // 15570, pearspedbr male
	AddCharSyncModel(240, 383); // 15571, pearspedbs male
	AddCharSyncModel(240, 384); // 15572, pearspedbt male
	AddCharSyncModel(240, 385); // 15573, pearspedbu male
	AddCharSyncModel(45, 386); // 15574, pearspedbv male
	AddCharSyncModel(91, 387); // 15575, pearspedbw
	AddCharSyncModel(98, 388); // 15576, pearspedbx male
	AddCharSyncModel(216, 389); // 15577, pearspedby
	AddCharSyncModel(25, 390); // 15578, pearspedbz male
	AddCharSyncModel(120, 391); // 15579, pearspedca male
	AddCharSyncModel(179, 392); // 15580, pearspedcb male
	AddCharSyncModel(233, 393); // 15581, pearspedcc
	AddCharSyncModel(12, 394); // 15582, pearspedcd
	AddCharSyncModel(40, 395); // 15583, pearspedce
	AddCharSyncModel(85, 396); // 15584, pearspedcf
	AddCharSyncModel(233, 397); // 15585, pearspedcg
	AddCharSyncModel(233, 398); // 15586, pearspedct
	AddCharSyncModel(233, 399); // 15587, pearspedch
	AddCharSyncModel(12, 400); // 15588, pearspedci
	AddCharSyncModel(217, 401); // 15589, pearspedcj male
	AddCharSyncModel(12, 402); // 15590, pearspedck
	AddCharSyncModel(7, 403); // 15591, pearspedcl male
	AddCharSyncModel(93, 404); // 15592, pearspedcm
	AddCharSyncModel(98, 405); // 15593, pearspedcn male
	AddCharSyncModel(143, 406); // 15594, pearspedco male
	AddCharSyncModel(93, 407); // 15595, pearspedcp
	AddCharSyncModel(91, 408); // 15596, pearspedcq
	AddCharSyncModel(40, 409); // 15597, pearspedcr
	AddCharSyncModel(46, 410); // 15598, pearspedcs male
	AddCharSyncModel(40, 411); // 15599, pedaraba
	AddCharSyncModel(221, 412); // 15600, pedarabb male
	AddCharSyncModel(142, 413); // 15601, pedarabc male
	AddCharSyncModel(42, 414); // 15602, prisonmex male
	AddCharSyncModel(311, 415); // 15603, pearscop male
	AddCharSyncModel(287, 416); // 15604, pearsarmy1 male
	AddCharSyncModel(287, 417); // 15605, pearsarmy2 male
	AddCharSyncModel(285, 418); // 15606, pearsswat1 male
	AddCharSyncModel(285, 419); // 15607, pearsswat2 male
	AddCharSyncModel(300, 420); // 15608, pearscop2 male
	AddCharSyncModel(301, 421); // 15609, pearsswat4 male
	AddCharSyncModel(300, 422); // 15610, pearsswat5 male
	AddCharSyncModel(300, 423); // 15611, pearscop3 male
	AddCharSyncModel(305, 424); // 15612, pearscop4 male
	AddCharSyncModel(303, 425); // 15613, pearscop5 male
    return 1;
}

// Получаем пол по скину
stock GetSkinSex(s)
{
	if(s >= 0 && s <= 8 || s >= 14 && s <= 30 || s >= 32 && s <= 37
	|| s >= 42 && s <= 52 || s >= 57 && s <= 62 || s >= 66 && s <= 68 || s >= 42 && s <= 52 || s >= 70 && s <= 74
	|| s >= 78 && s <= 84 || s == 86 || s >= 94 && s <= 128 || s >= 132 && s <= 137 || s >= 142 && s <= 144 || s == 146 || s == 147 || s == 149
	|| s >= 153 && s <= 156 || s >= 158 && s <= 168 || s == 170 || s == 171 || s >= 173 && s <= 177 || s >= 179 && s <= 189 || s == 200
	|| s >= 202 && s <= 204 || s == 206 || s >= 208 && s <= 210 || s == 212 || s == 213 || s == 217 || s >= 220 && s <= 223 || s >= 227 && s <= 230
 	|| s >= 234 && s <= 236 || s >= 239 && s <= 242 || s >= 247 && s <= 250 || s >= 252 && s <= 255 || s >= 258 && s <= 262 || s >= 264 && s <= 297
 	|| s >= 299 && s <= 305 || s >= 310 && s <= 311

	// Кастомные -15188
	|| s == 313 || s == 315 || s == 316 || s >= 318 && s <= 322 || s >= 326 && s <= 15523
	|| s == 336 || s == 353 || s == 354 || s == 356 || s == 364 || s == 365 || s == 367
	|| s >= 376 && s <= 386 || s == 388 || s == 390 || s == 391 || s == 392 || s == 401
	|| s == 403 || s == 405 || s == 406 || s == 410 || s == 412 || s == 413 || s == 414
	|| s == 415 || s == 416 || s == 417 || s == 418 || s == 419 || s == 420 || s == 421
	|| s == 422 || s == 423 || s == 424 || s == 425) return 0; // 0 - мужской скин
 	else return 1; // Все остальные 1, значит женские
}

// Проверка на доступные ID скинов
stock IsASkinExisting(s)
{
    if(s >= 1 && s <= 73 || s >= 75 && s <= 311 // Стандартные скины сампа (0 - cj, 74 косячина сампа - не используем его)

    || s >= 312 && s <= 312 + MAX_SKIN_CUSTOM) return 1; // Кастомные скины пирса
    return 0;
}

stock GetSkinName(skin)
{
	new skinName[34];
	if(skin >= sizeof(skinNameAll)) format(skinName, sizeof(skinName), "Одежда");
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
    else skinId = showModel; // Если моды НЕ установлены, показываем оригинальный скин
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

CMD:setskin(playerid, const params[]) // Сменить активную одежду игрока
{
	if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 19+ ]");

    new tmp[34], giveplayerid;
	if(sscanf(params, "s[34]i",tmp,params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить одежду [ /setskin ID ID Скина ]");
    giveplayerid = ReturnUser(tmp, 1);

	if(!IsASkinExisting(params[1])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID скина [1 - 311, далее кастомные ID есть на форуме]");
	if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети или он не залогинился");
	if(IsPlayerInAnyVehicle(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока в транспорте");
	if(NoAnim[giveplayerid] == 1) return ErrorMessage(playerid, "{FF6347}Нельзя сменить скин во время активного действия игрока");

	PlayerInfo[giveplayerid][pModel] = params[1];
	PlayerInfo[giveplayerid][pModel2] = 0;
	PlayerInfo[giveplayerid][pModel3] = 0;

	new string[90];
	format(string, sizeof(string), "Администратор %s изменил вашу одежду", PlayerInfo[playerid][pName]);
	SendClientMessage(giveplayerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Вы изменили %s одежду на ID %d (Общий Доступ)", PlayerInfo[giveplayerid][pName],params[1]);
	SendClientMessage(playerid, COLOR_WHITE, string);

    OnlineInfo[giveplayerid][oTempSkin] = 0;
	TempSpawnPlayer(giveplayerid);
	
	AdminLog("setskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], params[1], "");
	return 1;
}

CMD:giveskin(playerid, const params[]) // Выдать одежду в инвентарь
{
	if(PlayerInfo[playerid][pSoska] < 19) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 19+ ]");
	new tmp[34], giveplayerid;
	if(sscanf(params, "s[34]i",tmp,params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать одежду /giveskin [ID] [ID Скина]");
	if(!IsASkinExisting(params[1])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID скина [1 - 311, далее кастомные ID есть на форуме]");
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
	if(PlayerInfo[playerid][pMedia] == 0) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(gSkafandr[playerid] > 0 || gFormavvs[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Вы не можете переодеться в форме");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Временно сменить скин [ /skin ID Скина ]");
	if(!IsASkinExisting(params[0])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID скина [1 - 311, далее кастомные ID есть на форуме]");

	new string[80];
	format(string, sizeof(string), "Вы временно сменили скин ID %d",params[0]);
	SendClientMessage(playerid, COLOR_WHITE, string);

    OnlineInfo[playerid][oTempSkin] = params[0];
	TempSpawnPlayer(playerid);
	return 1;
}

CMD:setskinmp(playerid, const params[]) // Временно сменить скин игроку
{
	if(PlayerInfo[playerid][pSoska] < 4) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 4+ ]");

    new tmp[34], giveplayerid;
	if(sscanf(params, "s[34]i",tmp,params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Временно изменить скин [ /setskinmp ID ID Скина ]");
	if(!IsASkinExisting(params[1])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID скина [1 - 311, далее кастомные ID есть на форуме]");
	if(Pognalinamp == 0 && PlayerInfo[playerid][pSoska] <= 9) return ErrorMessage(playerid, "{FF6347}Эта команда доступна вам только во время мероприятия");

    giveplayerid = ReturnUser(tmp, 1);
	if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети или он не залогинился");

	new string[100];
	format(string, sizeof(string), "Администратор %s временно изменил ваш скин", PlayerInfo[playerid][pName]);
	SendClientMessage(giveplayerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Вы временно изменили %s скин %d.", PlayerInfo[giveplayerid][pName], params[1]);
	SendClientMessage(playerid, COLOR_WHITE, string);

    OnlineInfo[giveplayerid][oTempSkin] = params[1];
    TempSpawnPlayer(giveplayerid);

    AdminLog("setskinmp", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], params[1], "");
	return 1;
}

CMD:setskingro(playerid, const params[]) // Временно сменить скин всем игрокам в радиусе 30 метров
{
    if(PlayerInfo[playerid][pSoska] < 4) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 4+ ]");
	if (sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Временно изменить скин всем вокруг себя [ /setskingro ID Скина ]");
    if(!IsASkinExisting(params[0])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID скина [1 - 311, далее кастомные ID есть на форуме]");
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

            OnlineInfo[i][oTempSkin] = params[0];
            TempSpawnPlayer(i);
        }
    }
    format(string, sizeof(string), "Вы временно изменили скин игрокам возле себя ID: %d",params[0]);
    SendClientMessage(playerid, COLOR_WHITE, string);
    format(string, sizeof(string), " [ ADM ]: Админ %s изменил скин всем игрокам возле себя ID: [%d]", PlayerInfo[playerid][pName],params[0]);
    ABroadCast(COLOR_ADM,string,1);
    AdminLog("setskingro", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "");
	return 1;
}

// Меняем скин игрока ограниченным спавном
stock TempSpawnPlayer(playerid)
{
    if(OnlineInfo[playerid][oShowInterface] == 1) CloseFrisk(playerid), CancelSelectTextDraw(playerid);

    OnlineInfo[playerid][oSkinSpawn] = true; // Активируем не полный спавн
    
    GetPlayerPos(playerid, OnlineInfo[playerid][oSpawnTempPos][0], OnlineInfo[playerid][oSpawnTempPos][1], OnlineInfo[playerid][oSpawnTempPos][2]);
	OnlineInfo[playerid][oSpawnTempPos][2] -= 0.5;
	GetPlayerFacingAngle(playerid, OnlineInfo[playerid][oSpawnTempPos][3]);

	OnlineInfo[playerid][oSpawnInt] = GetPlayerInterior(playerid);
	OnlineInfo[playerid][oSpawnWorld] = GetPlayerVirtualWorld(playerid);
	
	PPSpawnPlayer(playerid);
	return 1;
}

// Возвращаем позицию игрока после временного спавна
stock WeReturnToPosition(playerid)
{
    PPSpawn[playerid] = false;

	keep(playerid); // Подморозим, чтобы не провалился
	S_SetPlayerVirtualWorld(playerid, OnlineInfo[playerid][oSpawnWorld], OnlineInfo[playerid][oSpawnInt]), SetPlayerInterior(playerid, OnlineInfo[playerid][oSpawnInt]);
	if(PlayerInfo[playerid][pBeret] == 0) Protect_MyWeapon(playerid); // Возвращаем оружие
	SetPlayerToTeamColor(playerid); // Возвращаем цвет

	// Возвращаем аксессуары
	if(PlayerInfo[playerid][pOdet][0] > 0) Odet(playerid, 5);
	if(PlayerInfo[playerid][pOdet][1] > 0) Odet(playerid, 6);
	if(PlayerInfo[playerid][pOdet][2] > 0) Odet(playerid, 7);
	if(PlayerInfo[playerid][pOdet][3] > 0) Odet(playerid, 8);
	if(PlayerInfo[playerid][pOdet][4] > 0) Odet(playerid, 9);

	if(!VehShopInfo[playerid][vsTest]) ApplyAnimation(playerid,"PED","Turn_R",4.0,0,1,1,0,0);

    OnlineInfo[playerid][oSkinSpawn] = false; // Спавн завершён
    return 1;
}

function loadDrop_Clothes(playerid)
{
	if(gSkafandr[playerid] == 0 && gFormavvs[playerid] == 0)
	{
		RemovePlayerAttachedObject(playerid, 5);
		OnlineInfo[playerid][oTempSkin] = 0;
		TempSpawnPlayer(playerid);
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
    ApplyAnimation(playerid,"PED","Turn_R",4.0,0,1,1,0,0);
    if(OnlineInfo[playerid][oShowInterface] == 1) PlayerTextDrawSetPreviewModel(playerid, PlaNestOthe[0][playerid], PlayerInfo[playerid][pModel]), PlayerTextDrawShow(playerid, PlaNestOthe[0][playerid]);
    
    if(PlayerInfo[playerid][pOdet][0] > 0) RemovePlayerAttachedObject(playerid, 5);
	if(PlayerInfo[playerid][pOdet][1] > 0) RemovePlayerAttachedObject(playerid, 6);
	if(PlayerInfo[playerid][pOdet][2] > 0) RemovePlayerAttachedObject(playerid, 7);
	if(PlayerInfo[playerid][pOdet][3] > 0) RemovePlayerAttachedObject(playerid, 8);
	if(PlayerInfo[playerid][pOdet][4] > 0) RemovePlayerAttachedObject(playerid, 9);
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
    OnlineInfo[playerid][oActorShop] = CreateDynamicActor(GetModelSkin(playerid, skin), 1536.977905, -1452.003784, 45.906265, 205.815200, true, 100.0, playerid+1, 0, playerid, 50.0, -1, 0);
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
	PPSetPlayerPos(playerid, 1542.2922,-1451.5934,45.9063), SetPlayerFacingAngle(playerid, 36.3980);
	S_SetPlayerVirtualWorld(playerid, playerid+1, 0);
 	SetPlayerInterior(playerid, 0);
 	TogglePlayerControllable(playerid, 0);
	InterpolateCameraPos(playerid, 1540.998779, -1459.510864, 46.879333, 1538.850585, -1455.088989, 46.521511, 1000);
	InterpolateCameraLookAt(playerid, 1538.275634, -1455.370727, 46.213356, 1536.296020, -1450.861206, 45.747303, 1000);
	SelectColorDraw(playerid);
	SetPVarInt(playerid, "SelectCharPlace", 0);
	OnlineInfo[playerid][oShowInterface] = 18;
	if(stat == 1)
	{
		TextDrawShowForPlayer(playerid, DressDraw[0]), TextDrawShowForPlayer(playerid, DressDraw[1]), TextDrawShowForPlayer(playerid, DressDraw[2]); // Фон Меню
		TextDrawShowForPlayer(playerid, DressDraw[3]), TextDrawShowForPlayer(playerid, DressDraw[4]); // Влево
		TextDrawShowForPlayer(playerid, DressDraw[5]), TextDrawShowForPlayer(playerid, DressDraw[6]); // Вправо
		TextDrawShowForPlayer(playerid, DressDraw[7]), TextDrawShowForPlayer(playerid, DressDraw[8]), TextDrawShowForPlayer(playerid, DressDraw[9]); // Select
	    if(Fractia[playerid] == 100) // Магазин Одежды
	    {
	    	show_skin(playerid, 100, 0);
	    	TextDrawShowForPlayer(playerid, DressDraw[14]), TextDrawShowForPlayer(playerid, DressDraw[15]); // Список
	    	PlayerTextDrawSetString(playerid, PlaDressDraw[1], "CIVIL [1/50]");
			PlayerTextDrawShow(playerid, PlaDressDraw[1]);
	    }
	    else if(Fractia[playerid] >= 1 && Fractia[playerid] <= 22) // Раздевалка в Организации
		{
		    new g = Fractia[playerid];
			show_skin(playerid, g, 0);
			if(g == 1) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "LSPD");
			else if(g == 2) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "FBI");
			else if(g == 3) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "NGSA");
			else if(g == 4) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "ASGH");
			else if(g == 5) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "COSA NOSTRA");
			else if(g == 6) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "YAKUZA");
			else if(g == 7) PlayerTextDrawSetString(playerid, PlaDressDraw[1], "GOVERMENT");
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
	else
	{
		Fractia[playerid] = 200;
		show_skin(playerid, 200, 0);
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
	else if(g == 200)
	{
		if(select >= 1) select --;
		else select = 2;
	}
	SetPVarInt(playerid, "SelectCharPlace", select);
	show_skin(playerid, g, select);
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
		if(select <= 1) select ++;
		else select = 0;
	}
	SetPVarInt(playerid, "SelectCharPlace", select);
	show_skin(playerid, g, select);
	return 1;
}

stock ExitShmot(playerid)
{
	SetPVarInt(playerid, "SelectCharPlace",0);
	keep(playerid);
	PPSetPlayerPos(playerid, SkinX[playerid], SkinY[playerid], SkinZ[playerid]);
 	SetPlayerFacingAngle(playerid, SkinA[playerid]);
  	S_SetPlayerVirtualWorld(playerid, SkinWorld[playerid], SkinInt[playerid]);
   	SetPlayerInterior(playerid, SkinInt[playerid]);

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
	ShowDialog(playerid,-1,DIALOG_STYLE_MSGBOX," "," ","*","");
	for(new t = 0; t < 16; t++) TextDrawHideForPlayer(playerid, DressDraw[t]);
	for(new pt = 0; pt < 4; pt++) PlayerTextDrawHide(playerid, PlaDressDraw[pt]);
	return 1;
}

stock ClickTextDraw_ClothesShop(playerid, Text:clickedid)
{
    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, Aftextdraw[playerid]);
    if(interval < 800) return 0; // Блокируем, если игрок клацает часто на кнопку

    if(clickedid == DressDraw[3]) // Выбор скина стрелка влево
    {
        if(Fractia[playerid] >= 1 && Fractia[playerid] <= 200) left_skin(playerid);
        else if(Fractia[playerid] == 300) left_akses(playerid);
    }
    if(clickedid == DressDraw[5]) // Выбор скина стрелка вправо
    {
        if(Fractia[playerid] >= 1 && Fractia[playerid] <= 200) right_skin(playerid);
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
	for(new s = minlist; s < 312 + MAX_SKIN_CUSTOM; s++)
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

	if(!strcmp(OnlineInfo[playerid][oSortingName],"0",true)) {} // Фильтр по названию не включен
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
	new line[120],lines[480];
    if(list >= 312) format(line,sizeof(line),"{0088ff}%s {cccccc}ID: %d\t", GetSkinName(list), list), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}%s ID: %d\t", GetSkinName(list), list), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Стоимость:\t{99ff66}%d$ {cccccc}[%s]", SkinGos[list], get_k(SkinGos[list])), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Gold:\t{ffcc00}%dG", SkinGold[list]), strcat(lines,line);
	if(SkinSale[list]) format(line,sizeof(line),"\n{cccccc}Доступ к продаже:\t{99ff66}[ On ]"), strcat(lines,line);
	else format(line,sizeof(line),"\n{cccccc}Доступ к продаже:\t{FF6347}[ Off ]"), strcat(lines,line);
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
	for(new s = minlist; s < 312 + MAX_SKIN_CUSTOM; s++)
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
		else cmd_economy(playerid);
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
				ShowDialog(playerid,970,DIALOG_STYLE_INPUT,"Гос Стоимость Одежды",lines,"Принять","Отмена");
			}
			else if(listitem == 1)
			{
				new line[100],lines[300];
				format(line,sizeof(line),"{cccccc}Введите Gold стоимость для {ff9000}%s", GetSkinName(list)), strcat(lines,line);
				format(line,sizeof(line),"\n\n{cccccc}Текущая Стоимость: {ffcc00}%dG", SkinGold[list]), strcat(lines,line);
				format(line,sizeof(line),"\n{cccccc}Не меньше 1G и не больше 100.000G"), strcat(lines,line);
				ShowDialog(playerid,946,DIALOG_STYLE_INPUT,"Гос Стоимость Одежды",lines,"Принять","Отмена");
			}
			else if(listitem == 2)
			{
				if(SkinSale[list]) SkinSale[list] = 0;
				else SkinSale[list] = 1;
				skinsaleUpdate = true;
				SettingGosPriceSkin(playerid, list);
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
			skingosUpdate = true;
			// SaveSkinEconomy();

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
			if(input < 1 || input > 100000) return ErrorText(playerid, "{FF6347}Не меньше 1G и не больше 100.000G"), SettingGosPriceSkin(playerid, list);
			SkinGold[list] = input;

			PlayerPlaySound(playerid, 6401, 0,0,0);
			SaveSkinGold();

			new string[180];
			format(string,sizeof(string),"[ Мысли ]: Gold стоимость одежды %s ID %d теперь составляет: {ffcc00}%dG", GetSkinName(list), list, SkinGold[list]);
  			SendClientMessage(playerid,COLOR_GREY,string);
  			SettingGosPriceSkin(playerid, OnlineInfo[playerid][oDialogMenu][3]);

			format(string,sizeof(string),"%dG %s", input, GetSkinName(list));
			AdminLog("skingold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", list, string);
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
	OnlineInfo[playerid][oTempSkin] = skin;
	TempSpawnPlayer(playerid);
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

	for(new s = OnlineInfo[playerid][oFittingRoom]; s < 312 + MAX_SKIN_CUSTOM; s++)
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
		for(new s = 1; s < 312 + MAX_SKIN_CUSTOM; s++)
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
		for(new s = 312 + MAX_SKIN_CUSTOM - 1; s > 0; s--)
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
	|| IsPlayerInRangeOfPoint(playerid,1.0,1374.8009,719.3740,2112.2515) && GetPlayerVirtualWorld(playerid) == 6 && GetPlayerInterior(playerid) == 1 // Yakuza Mafia
	|| IsPlayerInRangeOfPoint(playerid,1.0,-2008.8141,152.5642,1666.0313) && GetPlayerInterior(playerid) == 7 && GetPlayerVirtualWorld(playerid) == 7 // Правительство
	|| IsPlayerInRangeOfPoint(playerid,1.0,-506.7065,-87.0514,964.8114) && GetPlayerVirtualWorld(playerid) == 8 && GetPlayerInterior(playerid) == 8 // Hitman Agency
	|| IsPlayerInRangeOfPoint(playerid,1.0,-1760.2249,799.6393,137.4583) // CNN
	|| IsPlayerInRangeOfPoint(playerid,1.0,-1997.9194,1110.0148,1018.6735) && GetPlayerVirtualWorld(playerid) == 12 && GetPlayerInterior(playerid) == 1 // Russian Mafia
	|| IsPlayerInRangeOfPoint(playerid,1.0,-1928.6663,906.0461,1402.0776) && GetPlayerVirtualWorld(playerid) == 10 && GetPlayerInterior(playerid) == 10 // Triada Mafia
	|| IsPlayerInRangeOfPoint(playerid,1.0,1393.0143,1821.3657,10.8662) && GetPlayerVirtualWorld(playerid) == 182 && GetPlayerInterior(playerid) == 18 // Arabian Mafia
	|| IsAClothesNearby(playerid)
	|| IsAGoldClothesNearby(playerid)) // Магаз одежды
    {
		return 1;
	}
	return 0;
}

function LoadGosSkin()
{
	new rows, time = GetTickCount();
	cache_get_row_count(rows);
	if(rows)
	{
		new string[4096];
		cache_get_value_name(0, "SkinGos", string, sizeof(string));
		ParseStringToArray(string, SkinGos, sizeof(SkinGos));
		printf("[MODE]: Стоимость Скинов [%d ms]", GetTickCount() - time);
	}
	return 1;
}

function LoadGoldSkin()
{
	new rows, time = GetTickCount();
	cache_get_row_count(rows);
	if(rows)
	{
		new string[4096];
		cache_get_value_name(0, "SkinGold", string, sizeof(string));
		ParseStringToArray(string, SkinGold, sizeof(SkinGold));
		printf("[MODE]: Gold Стоимость Скинов [%d ms]", GetTickCount() - time);
	}
	return 1;
}

function LoadSaleSkin()
{
	new rows, time = GetTickCount();
	cache_get_row_count(rows);
	if(rows)
	{
		new string[4096];
		cache_get_value_name(0, "SkinSale", string, sizeof(string));
		ParseStringToArray(string, SkinSale, sizeof(SkinSale));
		printf("[MODE]: Доступ скинов в магазинах [%d ms]", GetTickCount() - time);
	}
	return 1;
}

stock SaveSkinEconomy()
{
	new string_mysql[4096];
	format(string_mysql, sizeof(string_mysql), "UPDATE `pp_skinprice` SET `SkinGos` = '%s' WHERE `newid` = '1'", StringifyArray(SkinGos, sizeof(SkinGos)));
	query_empty(pearsq, string_mysql);
	return 1;
}

stock SaveSkinGold()
{
	new string_mysql[4096];
	format(string_mysql, sizeof(string_mysql), "UPDATE `pp_skinprice` SET `SkinGold` = '%s' WHERE `newid` = '1'", StringifyArray(SkinGold, sizeof(SkinGold)));
	query_empty(pearsq, string_mysql);
	return 1;
}

stock SaveSkinSale()
{
	new string_mysql[4096];
	format(string_mysql, sizeof(string_mysql), "UPDATE `pp_skinprice` SET `SkinSale` = '%s' WHERE `newid` = '1'", StringifyArray(SkinSale, sizeof(SkinSale)));
	query_empty(pearsq, string_mysql);
	return 1;
}

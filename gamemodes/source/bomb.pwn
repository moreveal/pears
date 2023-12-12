
 #define MAX_BOMB 10 // Максимальное количество взрывов или активных бомб
 #define MAX_OBJECT_RUINS 7 // Количество объектов после взрыва

enum boInfo
{
    boStat, // Статус взрыва или бомбы
    Float: boPos[3], // Позиция взрыва
    boWorld, // Вирт мир
    boInterior, // Интерьер
    boObject[MAX_OBJECT_RUINS], // ID объектов после взрыва
    boProcess, // Статус руин
    boTrainRoad, // Лежат ли руины на жд путях
    Text3D:boRuinsLabel
}
new RuinsInfo[MAX_BOMB][boInfo];


stock PlantBomb(playerid, time)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || HealthAC[playerid] <= 0) return 0;
    if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0) return ErrorMessage(playerid, "{FF6347}Нельзя установить бомбу в помещении");
    if(IsAAntidm(playerid)) return ErrorMessage(playerid, "{FF6347}Вы находитесь в зелёной зоне");
    if(box[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы на ринге");
    if(get_invent4(playerid, 11, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет бомбы");
    if(IsATrainStation(playerid)) return ErrorMessage(playerid, "{FF6347}Нельзя установить бомбу на железнодорожной станции\n{cccccc}Установите бомбу где-то в лесу, за городом");
    if(IsANotMoney(playerid)) return ErrorMessage(playerid, "{FF6347}Нельзя установить бомбу на территории города\n{cccccc}Установите бомбу где-то в лесу, за городом");
    if(!IsCreateBomb(playerid)) return 0;

    if(time < 10 || time > 300) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не меньше 10 и не больше 300 секунд");

    new result = Throw(playerid, 11, 1, time, 0, 0, 0); // Кладём предмет на землю
    if(!result) return 1;

    TakeInvent(playerid, 11, 1, 0, 999);
    if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);

    PlayerPlaySound(playerid,25800,0,0,0);
    format(store,sizeof(store),"{99ff66}Бомба установлена и взорвётся через %d секунд\n\n{cccccc}Отойдите как можно дальше, радиус взрыва более 50-ти метров", time);
    SuccessMessage(playerid, store);
    format(store,sizeof(store),"[ Мысли ]: Я установил%s бомбу {0088ff}[ Взрыв произойдёт через %d секунд ]", gender(playerid), time);
    SendClientMessage(playerid, COLOR_GREY, store);
	return 1;
}

stock dialogCase_Bomb(playerid, dialogid, response, const inputtext[])
{
	if(dialogid == 1335) // Установка таймера бомбы
	{
        if(response)
        {
            new input;
			if(sscanf(inputtext, "i", input)) return 0;
            PlantBomb(playerid, input);
        }
    }
    return 1;
}

CMD:gotoruins(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] <= 0) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "i", params[0])) return format(store,sizeof(store),"[ Мысли ]: Телепорт к руинам от бомбы [ /gotoruins ID 0 - %d ]", MAX_BOMB - 1), SendClientMessage(playerid, COLOR_GREY, store);
    if(params[0] < 0 || params[0] >= MAX_BOMB) return format(store,sizeof(store),"[ Мысли ]: Не меньше 0 и не больше %d", MAX_BOMB - 1), SendClientMessage(playerid, COLOR_GREY, store);
    
    new r = params[0];
    if(RuinsInfo[r][boStat] == 0) return ErrorMessage(playerid, "{FF6347}Руин под этим ID не существует");
    S_SetPlayerVirtualWorld(playerid, RuinsInfo[r][boWorld], RuinsInfo[r][boInterior]), SetPlayerInterior(playerid, RuinsInfo[r][boInterior]);
	PPSetPlayerPos(playerid, RuinsInfo[r][boPos][0],RuinsInfo[r][boPos][1],RuinsInfo[r][boPos][2]);
    return 1;
}

stock IsCreateBomb(playerid) // Создаём бомбу
{
    new quan;

    // Проверка на, рядом лежащие руины + считаем количество
    new stopNearbyRuins;
    for(new r; r < MAX_BOMB; ++r)
	{
        if(RuinsInfo[r][boStat] > 0)
        {
            if(IsPlayerInRangeOfPoint(playerid,200.0, RuinsInfo[r][boPos][0],RuinsInfo[r][boPos][1],RuinsInfo[r][boPos][2]) 
                && GetPlayerVirtualWorld(playerid) == RuinsInfo[r][boWorld] && GetPlayerInterior(playerid) == RuinsInfo[r][boInterior])
            {
                stopNearbyRuins = 1;
                break;
            }
            quan ++;
        }
    }
    if(stopNearbyRuins == 1)
    {
        ErrorMessage(playerid, "{FF6347}Слишком близко к другой, взорвавшейся бомбе\n\n{cccccc}Расстояние не менее 200 метров");
        return 0;
    }

    // Проверка на, рядом установленную бомбу + считаем количество
    new stopNearbyPlant;
    for(new g = 0; g < MAX_THROW; g++)
	{
		if(ThrowInfo[g][tId] == 11 && ThrowInfo[g][tType] == 0 && ThrowInfo[g][tBombPlant] == true) 
        {
            if(IsPlayerInRangeOfPoint(playerid,200.0, ThrowInfo[g][tX], ThrowInfo[g][tY], ThrowInfo[g][tZ]) 
                && GetPlayerVirtualWorld(playerid) == ThrowInfo[g][tWorld] && GetPlayerInterior(playerid) == ThrowInfo[g][tInt])
            {
                stopNearbyPlant = 1;
                break;
            }
            quan ++;
        }
    }
    if(stopNearbyPlant == 1)
    {
        ErrorMessage(playerid, "{FF6347}Слишком близко к другой, установленной бомбе\n\n{cccccc}Расстояние не менее 200 метров");
        return 0;
    }

    // Проверка на лимит бомб в данный момент
    if(quan >= 10)
    {
        ErrorMessage(playerid, "{FF6347}Вы не можете установить новую бомбу\n\n{cccccc}На сервере взорвалось или установлено 10 бомб\nВы можете найти завалы от бомбы и устранить их, освободив слоты");
        return 0;
    }
    return 1;
}

stock CreateRuinsAndExplosion(t) // Взрываем бомбу и создаём руины
{
    new r = -1;
    for(new i; i < MAX_BOMB; ++i)
	{
        if(RuinsInfo[i][boStat] == 0)
        {
            r = i;
            break;
        }
    }
    if(r == -1) return 0;
    CreateExplosion(ThrowInfo[t][tX], ThrowInfo[t][tY] , ThrowInfo[t][tZ], 7, 40);
	CreateExplosion(ThrowInfo[t][tX]-2, ThrowInfo[t][tY] , ThrowInfo[t][tZ], 7, 40);
	CreateExplosion(ThrowInfo[t][tX]+2, ThrowInfo[t][tY] , ThrowInfo[t][tZ], 7, 40);
	CreateExplosion(ThrowInfo[t][tX], ThrowInfo[t][tY]-2 , ThrowInfo[t][tZ], 7, 40);
	CreateExplosion(ThrowInfo[t][tX], ThrowInfo[t][tY]+2 , ThrowInfo[t][tZ], 7, 40);

    // Записываем точку взрыва, для создания руин
    RuinsInfo[r][boPos][0] = ThrowInfo[t][tX];
    RuinsInfo[r][boPos][1] = ThrowInfo[t][tY];
    RuinsInfo[r][boPos][2] = ThrowInfo[t][tZ];
    RuinsInfo[r][boWorld] = ThrowInfo[t][tWorld];
    RuinsInfo[r][boInterior] = ThrowInfo[t][tInt];

    if(ThrowInfo[t][tQara] > 0) RuinsInfo[r][boTrainRoad] = ThrowInfo[t][tQara] - 1; // Бомба на жд путях

    DestroyThrow(t); // Удаляем бомбу

    // Создаём объекты
    CreateObjectRuins(r, RuinsInfo[r][boPos][0],RuinsInfo[r][boPos][1],RuinsInfo[r][boPos][2], RuinsInfo[r][boWorld], RuinsInfo[r][boInterior]);


    RuinsInfo[r][boRuinsLabel] = CreateDynamic3DTextLabel("{ff9000}Завалы после взрыва бомбы\n{cccccc}Убрать завалы - Кувалда в руках + ПКМ",
        0xA9C4E4FF,RuinsInfo[r][boPos][0],RuinsInfo[r][boPos][1],RuinsInfo[r][boPos][2],5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,RuinsInfo[r][boWorld], RuinsInfo[r][boInterior]);

    RuinsInfo[r][boProcess] = 200; // Статус руин (Сколько раз по ним нужно долбить игрокам, чтобы расчистить)
    RuinsInfo[r][boStat] = 1; // Статус - развалины лежат
    return 1;
}

stock CreateObjectRuins(r, Float:x, Float:y, Float:z, world, int)
{
    new object_world = 17, object_int = 228; // Временно скрываем созданные объекты
    RuinsInfo[r][boObject][0] = CreateDynamicObject(807, 1338.224121, 1570.133666, 9.930312, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][0], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][0], world, int);
    RuinsInfo[r][boObject][1] = CreateDynamicObject(868, 1338.411743, 1567.012817, 10.181000, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][1], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][1], world, int);
    RuinsInfo[r][boObject][2] = CreateDynamicObject(868, 1337.818847, 1568.278564, 10.181000, 0.000000, 0.000000, -17.299972, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][2], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][2], world, int);
    RuinsInfo[r][boObject][3] = CreateDynamicObject(868, 1339.605957, 1566.887939, 10.151001, 0.000000, 0.000000, 109.500015, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][3], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][3], world, int);
    RuinsInfo[r][boObject][4] = CreateDynamicObject(868, 1340.984008, 1568.182739, 10.181000, 0.000000, 0.000000, 80.700027, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][4], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][4], world, int);
    RuinsInfo[r][boObject][5] = CreateDynamicObject(868, 1340.567016, 1569.584960, 10.180319, 0.000000, 0.000000, 124.299995, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][5], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][5], world, int);
    RuinsInfo[r][boObject][6] = CreateDynamicObject(868, 1337.989624, 1569.360473, 10.180319, 0.000000, 0.000000, -55.300010, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(RuinsInfo[r][boObject][6], 0, 10765, "airportgnd_sfse", "coasty_bit3_sfe", 0x00000000);
    gadd(RuinsInfo[r][boObject][6], world, int);

    MatrixDynamicObjectPos(0, x, y, z, 0.0, 0.0, 0.0);
    return 1;
}

stock DestroyObjects(r)
{
    for(new i; i < MAX_OBJECT_RUINS; ++i) DestroyDynamicObject(RuinsInfo[r][boObject][i]);
    return 1;
}

stock IsAPointRuins(playerid, Float:dist) // Находим ближайшие руины от бомбы
{
    new ruinsId = -1;
    for(new r; r < MAX_BOMB; ++r)
	{
        if(RuinsInfo[r][boStat] == 0) continue;

        if(IsPlayerInRangeOfPoint(playerid, dist, RuinsInfo[r][boPos][0], RuinsInfo[r][boPos][1], RuinsInfo[r][boPos][2])
            && GetPlayerVirtualWorld(playerid) == RuinsInfo[r][boWorld] && GetPlayerInterior(playerid) == RuinsInfo[r][boInterior])
        {
            ruinsId = r;
            break;
        }
    }
    return ruinsId;
}

stock PressCleanUpRuins(playerid) // Нажимаем на кнопку PKM
{
    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, Afclick[playerid]);
    if(interval < 800) return 0;
    Afclick[playerid] = current_tick;

    new r = IsAPointRuins(playerid, 3.0);
    if(r >= 0)
    {
        if(Dei[playerid] != 4) return ErrorMessage(playerid, "{FF6347}У вас в руках нет кувалды [ Если завалы на ж/д путях, кувалда висит на поезде ]");
        if(RuinsInfo[r][boProcess] > 0)
        {   
            RuinsInfo[r][boProcess] --;
            if(PlayerInfo[playerid][pID] == 1) RuinsInfo[r][boProcess] -= 9; // Elon Musk
            format(store, sizeof(store), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~%d/200", RuinsInfo[r][boProcess]);
            GameTextForPlayer(playerid,store,2000,3);
            ApplyAnimation(playerid,"SWORD","sword_4",2.0,0,0,0,0,0,1);

            if(RuinsInfo[r][boProcess] <= 0) // Завалы разгребли
            {
                DestroyObjects(r);
                RuinsInfo[r][boStat] = 0;
                DestroyDynamic3DTextLabel(RuinsInfo[r][boRuinsLabel]);

                Dei[playerid] = 0, RemovePlayerAttachedObject(playerid,1);
                GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Done",2000,3);

                // Поезд стоит по причине этих руин
                if(TrainMoved == 0 && ReasonToStopTrain > 0)
                {
                    new Float:pos[3];
	                GetVehiclePos(train, pos[0], pos[1], pos[2]);

                    // Запускаем таймер для начала движения поезда
                    TrainGoing = 1;
                    SetTimer("TrainStart", 20000, false);

                    // Пишем сообщение всем армейцам, которые рядом тусуются
                    foreach(Player,i)
                    {
                        if(OnlineInfo[i][oLogged] == 0 || fraction(i) != 3 || GetPlayerState(i) == PLAYER_STATE_SPECTATING
                            || GetPlayerVirtualWorld(i) != 0 || GetPlayerInterior(i) != 0) continue;
                        if(IsPlayerInRangeOfPoint(i,200.0, pos[0], pos[1], pos[2])) 
                        {
                            MessageTrainStartOnRuins(i);
                            if(Dei[i] == 4) Dei[i] = 0, RemovePlayerAttachedObject(i,1);
                        }
                    }
                }
            }
        }
    }
    return 1;
}

CMD:bomba(playerid)
{
	if(!IsPlayerInRangeOfPoint(playerid,1.0,-628.8907,2632.4429,2104.9768)) return 1;
	if(PlayerInfo[playerid][pMember] != 18 && PlayerInfo[playerid][pLeader] != 18) return ErrorMessage(playerid, "{FF6347}Вы не участник Arabian Mafia");
	if(get_invent(playerid, 10, 0) >= 1) return ErrorMessage(playerid, "{FF6347}У вас есть пояс со взрывчаткой [ Вы не можете сейчас взять бомбу ]");
	if(get_invent(playerid, 11, 0) >= 1) return ErrorMessage(playerid, "{FF6347}У вас уже есть бомба");
    if(Piss[playerid] >= 1 || Hold[playerid] >= 1 || Piss[playerid] == 7 || Dei[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вашего персонажа заняты руки");	

    if(get_invent4(playerid, 182, 0) < 1) return ErrorMessage(playerid, "{FF6347}У вас не хватает Изоленты\n\n{cccccc}1 Бомба  = 1 изоленты");
    if(get_invent4(playerid, 181, 0) < 3) return ErrorMessage(playerid, "{FF6347}У вас не хватает Деталий бомбы\n\n{cccccc}1 Бомба  = 3 детали бомбы");
    if(get_invent4(playerid, 19, 0) < 1) return ErrorMessage(playerid, "{FF6347}У вас не хватает Веревки\n\n{cccccc}1 Бомба = 1 веревка");
    if(get_invent4(playerid, 13, 0) < 3) return ErrorMessage(playerid, "{FF6347}У вас не хватает Отмычек\n\n{cccccc}1 Бомба  = 3 отмычки");

    Dei[playerid] = 7, PlayerPlaySound(playerid,5601,0,0,0);
    ApplyAnimation(playerid,"OTB","betslp_loop",2.0, 1, 0, 0, 0, 0);
    GetPlayerPos(playerid, Job_X[playerid], Job_Y[playerid], Job_Z[playerid]);
    SetPVarInt(playerid,"oryjtemp", 0);
    SetPVarInt(playerid,"Arobsklad", 30);
    TextDrawShowForPlayer(playerid, MindDraw[3]);
    if(Device[playerid] == 0) PlayerTextDrawSetString(playerid, HintButton, "RMB");
    else if(Device[playerid] == 1) PlayerTextDrawSetString(playerid, HintButton, "H");
    PlayerTextDrawShow(playerid, HintButton);
    GameTextForPlayer(playerid,RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~0/100"), 5000, 3);
    RemovePlayerAttachedObject(playerid,1);
    SetPlayerAttachedObject(playerid, 1, 19583, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
	return 1;
}

stock ArabianCraft(playerid)
{
    new thingId;
    if (GetPVarInt(playerid,"Arobsklad") == 30) thingId = 11;
	else return ErrorMessage(playerid, "{FF6347}Шакал на Филине допустил где-то ошибку"), SetPVarInt(playerid,"Arobsklad",0);
    new current_tick = GetTickCount();
	new interval = GetTickDiff(current_tick, Aftextdraw[playerid]);
	if(interval > 300)
	{
		SetPVarInt(playerid,"oryjtemp",GetPVarInt(playerid,"oryjtemp")+1*5);
		if(!IsPlayerInRangeOfPoint(playerid,3.0,Job_X[playerid], Job_Y[playerid], Job_Z[playerid]))
		{
			SetPVarInt(playerid,"oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0), ClearAnimations(playerid), TextDrawHideForPlayer(playerid, MindDraw[3]), PlayerTextDrawHide(playerid, HintButton), PlayerPlaySound(playerid,4203,0,0,0);
			Dei[playerid] = 7, GameTextForPlayer(playerid,RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Вы отошли стола"), 5000, 3), RemovePlayerAttachedObject(playerid,1);
		}
        
		new string[58];
		format(string, sizeof(string), RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~%d/100"),GetPVarInt(playerid,"oryjtemp")), GameTextForPlayer(playerid,string, 1500, 3);
		ApplyAnimation(playerid,"OTB","betslp_loop",2.0, 1, 0, 0, 0, 0);
		if(GetPVarInt(playerid,"oryjtemp") >= 100)
		{
			RemovePlayerAttachedObject(playerid,1), ClearAnim(playerid), ClearAnimations(playerid), Dei[playerid] = 0, TextDrawHideForPlayer(playerid, MindDraw[3]), PlayerTextDrawHide(playerid, HintButton), SetPVarInt(playerid,"oryjtemp", 0);

			if(get_invent4(playerid, 182, 0) < 1) return ErrorMessage(playerid, "{FF6347}У вас не хватает Изоленты\n\n{cccccc}1 Бомба  = 1 изоленты");
			if(get_invent4(playerid, 181, 0) < 3) return ErrorMessage(playerid, "{FF6347}У вас не хватает Деталий бомбы\n\n{cccccc}1 Бомба  = 3 детали бомбы");
			if(get_invent4(playerid, 19, 0) < 1) return ErrorMessage(playerid, "{FF6347}У вас не хватает Веревки\n\n{cccccc}1 Бомба = 1 веревка");
			if(get_invent4(playerid, 13, 0) < 3) return ErrorMessage(playerid, "{FF6347}У вас не хватает Отмычек\n\n{cccccc}1 Бомба  = 3 отмычки");

			new put_inva = GiveThingPlayer(playerid, thingId, 1, 0, 0, 0, 0, 9999);
			if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре");
			
			TakeInvent(playerid, 182, 1, 0, 999); 
            TakeInvent(playerid, 181, 1, 0, 999); 
            TakeInvent(playerid, 181, 1, 0, 999); 
            TakeInvent(playerid, 181, 1, 0, 999); 
			TakeInvent(playerid, 19, 1, 0, 999); 
            TakeInvent(playerid, 13, 3, 0, 999);

  			format(lines,sizeof(lines),""); // Очищаем Lines
  			format(line,sizeof(line),"{808000}Вы изготовили бомбу!"), strcat(lines,line);
  			format(line,sizeof(line),"\n{cccccc}Для того, чтобы активировать её нажмите на неё два раза в инвентаре."), strcat(lines,line);
			ShowDialog(playerid,1995,DIALOG_STYLE_MSGBOX,"{808000}Arabian Mafia",lines,"*","");
			
			SetPVarInt(playerid,"Arobsklad",0);
		}
		Aftextdraw[playerid] = current_tick;
	}
    return 1;
}
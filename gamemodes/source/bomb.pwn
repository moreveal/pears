
 #define MAX_BOMB 10 // Максимальное количество взрывов или активных бомб
 #define MAX_OBJECT_RUINS 10 // Количество объектов после взрыва

enum boInfo
{
    boStat, // Статус взрыва или бомбы
    Float: boPos[3], // Позиция взрыва
    boWorld, // Вирт мир
    boInterior, // Интерьер
    boObject[MAX_OBJECT_RUINS], // ID объектов после взрыва
    boObjectStat[MAX_OBJECT_RUINS], // Статус объекта
    boQuanObject, // Подсчёт текущего количества объектов
    boTrainRoad // Лежат ли руины на жд путях
}
new RuinsInfo[MAX_BOMB][boInfo];

new SlotInteraction[MAX_REALPLAYERS]; // Записываем всегда и везде объект, с которым происходит взаимодействие


stock PlantBomb(playerid, time)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || HealthAC[playerid] <= 0) return 0;
    if(IsAAntidm(playerid)) return ErrorMessage(playerid, "{FF6347}Вы находитесь в зелёной зоне");
    if(box[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы на ринге");
    if(get_invent4(playerid, 11, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет бомбы");
    if(!IsCreateBomb(playerid)) return 0;

    if(time < 1 || time > 5) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не меньше 1 и не больше 5 минут");

    Throw(playerid, 11, 1, time*60, 0, 0, 0); // Кладём предмет на землю
    TakeInvent(playerid, 11, 1, 0, 999);

    if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);

    PlayerPlaySound(playerid,25800,0,0,0);
    format(store,sizeof(store),"{99ff66}Успешный успех. Бомба установлена и взорвётся через %d минут", time);
    SuccessMessage(playerid, store);
    format(store,sizeof(store),"[ Мысли ]: Я установил%s бомбу {0088ff}[ Взрыв произойдёт через %d минут ]", gender(playerid), time);
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

stock IsCreateBomb(playerid) // Создаём бомбу
{
    new quan;
    for(new b; b < MAX_BOMB; ++b)
	{
        if(RuinsInfo[b][boStat] == 0) quan ++;
    }
    if(quan == 0)
    {
        ErrorMessage(playerid, "{FF6347}Вы не можете установить новую бомбу [ Лимит 10 штук на сервере ]");
        return 0;
    }
    return 1;
}

stock CreateRuinsAndExplosion(t) // Взрываем бомбу и создаём руины
{
    new r = -1;
    for(new i; i < MAX_OBJECT_RUINS; ++i)
	{
        if(RuinsInfo[i][boStat] == 1) continue;
        r = i;
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

    // Вокруг бомбы объекты (0, 1 и т.д.)
    RuinsInfo[r][boObject][0] = CreateDynamicObject(901, RuinsInfo[r][boPos][0],RuinsInfo[r][boPos][1],RuinsInfo[r][boPos][2], 0, 0, 0,RuinsInfo[r][boWorld], RuinsInfo[r][boInterior], -1, 300.00, 300.00);
    RuinsInfo[r][boObjectStat][0] = 11; // 10 раз уебать по камню + 1 для удаления его (Поскольку 0 - камня нет)
    
    RuinsInfo[r][boStat] = 1; // Статус - развалины лежат
    RuinsInfo[r][boQuanObject] = 1; // Количество объектов на руинах
    return 1;
}

stock IsAPointRuins(playerid, Float:dist) // Находим ближайшие руины от бомбы
{
    new ruinsId = -1;
    for(new r; r < MAX_OBJECT_RUINS; ++r)
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

stock IsAPointObjectRuins(playerid,r) // Получаем координаты объекта на руинах
{
    new objectid = -1, Float:object_pos[3];
    for(new slot; slot < MAX_OBJECT_RUINS; ++slot)
    {
        if(RuinsInfo[r][boObjectStat][slot] == 0) continue;
        GetDynamicObjectPos(RuinsInfo[r][boObject][slot], object_pos[0], object_pos[1], object_pos[2]); // Получаем координаты объекта
        if(IsPlayerInRangeOfPoint(playerid, 3.0, object_pos[0], object_pos[1], object_pos[2]))
        {
            objectid = slot;
            break;
        }
    }
    return objectid;
}

stock PressCleanUpRuins(playerid) // Нажимаем на кнопку PKM
{
    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, Aftextdraw[playerid]);
    if(interval < 500) return 0;
    Aftextdraw[playerid] = current_tick;

    new r = IsAPointRuins(playerid, 20.0);
    if(r >= 0)
    {
        if(SlotInteraction[playerid] == 0) SlotInteraction[playerid] = IsAPointObjectRuins(playerid,r) + 1;
        if(SlotInteraction[playerid] > 0)
        {
            new slot = SlotInteraction[playerid]-1;

            if(RuinsInfo[r][boObjectStat][slot] > 0)
            {   
                new Float:object_pos[3];
                GetDynamicObjectPos(RuinsInfo[r][boObject][slot], object_pos[0], object_pos[1], object_pos[2]); // Получаем координаты объекта
                if(!IsPlayerInRangeOfPoint(playerid, 3.0, object_pos[0], object_pos[1], object_pos[2])) SlotInteraction[playerid] = 0;
                
                RuinsInfo[r][boObjectStat][slot] --;
                format(store, sizeof(store), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Pizdic: ~w~%d/10", RuinsInfo[r][boObjectStat][slot]), GameTextForPlayer(playerid,store,2000,3);
			    ApplyAnimation(playerid,"SWORD","sword_4",2.0,0,0,0,0,0,1);

                if(RuinsInfo[r][boObjectStat][slot] == 0) // Мы разрушили камень (сломали его)
                {
                    DestroyDynamicObject(RuinsInfo[r][boObject][slot]);
                    RuinsInfo[r][boQuanObject] --;

                    if(RuinsInfo[r][boQuanObject] <= 0)
                    {
                        RuinsInfo[r][boStat] = 0;
                    }
                    // Здесь проверка есть ли объекты ещё
                }
            }
            else SlotInteraction[playerid] = 0;
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
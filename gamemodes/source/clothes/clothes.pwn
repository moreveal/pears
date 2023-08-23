
/*
Как добавить новый кастомный скин на сервер?
1. Добавить в stock AddCustomSkins новый AddCharSyncModel(Оригинальный скин, Новый ID)
2. Добавить в stock IsASkinExisting новый ID скина
3. Если скин мужской - добавить новый ID в stock GetSkinSex
*/

stock AddCustomSkins()
{
	AddCharSyncModel(60, 312); // Пацанчик pearspeda
	AddCharSyncModel(6, 313); // jason
	AddCharSyncModel(91, 314); // pearspedb
    return 1;
}

// Проверка на доступные ID скинов
stock IsASkinExisting(s)
{
    if(s >= 1 && s <= 73 || s >= 75 && s <= 311 // Стандартные скины сампа (0 - cj, 74 косячина сампа - не используем его)
    || s >= 312 && s <= 314) return 1; // Кастомные скины пирса
    return 0;
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

	// Кастомные
	|| s == 312 || s == 313) return 0; // 0 - мужской скин
 	else return 1; // Все остальные 1, значит женские
}

// Получаем id скина для другого игрока forplayerid
stock GetSkinPresentation(forplayerid, playerid)
{
    new skinId;
    if(IsPlayerSyncModels(forplayerid)) skinId = GetPlayerSyncSkin(playerid); // Если моды установлены, показываем модельку с учётом модов
    else skinId = GetSkinOriginal(playerid); // Если моды НЕ установлены, показываем оригинальный скин
    return skinId;
}

// Получаем модель скина с учётом наличия модпака
stock GetModelSkin(playerid, s)
{
    new skinId;
    if(IsPlayerSyncModels(playerid)) skinId = s; // Мод установлен
    else skinId = GetSkinModelOriginal(playerid);
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

	format(store, sizeof(store), "Администратор %s изменил вашу одежду", PlayerInfo[playerid][pName]);
	SendClientMessage(giveplayerid, COLOR_WHITE, store);
	format(store, sizeof(store), "Вы изменили %s одежду на ID %d (Общий Доступ)", PlayerInfo[giveplayerid][pName],params[1]);
	SendClientMessage(playerid, COLOR_WHITE, store);

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

    format(store, sizeof(store), "Администратор %s выдал вам одежду ID: %d", PlayerInfo[playerid][pName], params[1]);
    SendClientMessage(giveplayerid, COLOR_WHITE, store);
    format(store, sizeof(store), "Вы выдали %s одежду ID %d (Общего Доступа)", PlayerInfo[giveplayerid][pName],params[1]);
    SendClientMessage(playerid, COLOR_WHITE, store);
    AdminLog("giveskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], params[1], "");
	return 1;
}

CMD:skin(playerid, const params[]) // Временно сменить скин себе
{
	if(PlayerInfo[playerid][pMedia] == 0) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(gSkafandr[playerid] > 0 || gFormavvs[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Вы не можете переодеться в форме");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Временно сменить скин [ /skin ID Скина ]");
	if(!IsASkinExisting(params[0])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID скина [1 - 311, далее кастомные ID есть на форуме]");

	format(store, sizeof(store), "Вы временно сменили скин ID %d",params[0]);
	SendClientMessage(playerid, COLOR_WHITE, store);

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

	format(store, sizeof(store), "Администратор %s временно изменил ваш скин", PlayerInfo[playerid][pName]);
	SendClientMessage(giveplayerid, COLOR_WHITE, store);
	format(store, sizeof(store), "Вы временно изменили %s скин %d.", PlayerInfo[giveplayerid][pName], params[1]);
	SendClientMessage(playerid, COLOR_WHITE, store);

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

    foreach (Player, i)
    {
        if(playerid == i) continue;
        if(OnlineInfo[i][oLogged] == 0) continue;

        if(GetDistanceBetweenPlayers(playerid, i) < 30)
        {
            format(store, sizeof(store), "Администратор %s временно изменил ваш скин", PlayerInfo[playerid][pName]);
            SendClientMessage(i, COLOR_WHITE, store);

            OnlineInfo[i][oTempSkin] = params[0];
            TempSpawnPlayer(i);
        }
    }
    format(store, sizeof(store), "Вы временно изменили скин игрокам возле себя ID: %d",params[0]);
    SendClientMessage(playerid, COLOR_WHITE, store);
    format(store, sizeof(store), " [ ADM ]: Админ %s изменил скин всем игрокам возле себя ID: [%d]", PlayerInfo[playerid][pName],params[0]);
    ABroadCast(COLOR_ADM,store,1);
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

    OnlineInfo[playerid][oSkinSpawn] = false; // Спавн завершён


    ApplyAnimation(playerid,"PED","Turn_R",4.0,0,1,1,0,0);
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

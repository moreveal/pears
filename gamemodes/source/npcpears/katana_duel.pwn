
#define GODJO_SATORU_HEALTH 60
#define GODJO_SATORU_CD_WIN 14400
#define GODJO_SATORU_CD_LOOSE 3600

new NPC:KatanaBot[MAX_REALPLAYERS] = { INVALID_NPC, ... };
new Float:SaveHealth[MAX_REALPLAYERS]; // Здоровье перед началом битвы

alias:rkatana("rcdkatana")
CMD:rkatana(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сбросить кд для дуэли с годжо [ /rkatana ID ]");
    if(!IsOnline(params[0])) return ErrorMessage(playerid, "{FF6347}Игрок не в сети");

    PlayerInfo[params[0]][pCDKatana] = 0;

    new string[120];
    mysql_format(pearsq, string, sizeof(string),"UPDATE `pp_igroki` SET `pCDKatana` = '0' WHERE `user_id` = '%d'", PlayerInfo[params[0]][pID]);
    mysql_tquery(pearsq, string);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "** Вы очистили кд на дуэль с Годжо для %s **", PlayerInfo[params[0]][pName]);
    if(playerid != params[0]) SendClientMessage(params[0], COLOR_LIGHTBLUE, "** %s очистил вам кд на дуэль с Годжо **", PlayerInfo[playerid][pName]);

    AdminLog("rkatana", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[params[0]][pID], PlayerInfo[params[0]][pName], PlayerInfo[params[0]][pPlaIP], 0, "");
    return 1;
}

stock InitializationKatanaDuel()
{
    new actorid = CreateDynamicActor(49, 1511.6743,717.7614,10.8659,90.8572, true, 100.0, WORLD_YAKUZA_SPORTSHALL, INT_YAKUZA_SPORTSHALL, -1, 100.0, -1, 0);
    CreateDynamic3DTextLabel("{cccccc}Дед Годжо Сатору [ALT]",0xA9C4E4FF, 1511.6743,717.7614,10.8659 + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, WORLD_YAKUZA_SPORTSHALL, INT_YAKUZA_SPORTSHALL);
    ApplyDynamicActorAnimation(actorid, "PARK","Tai_Chi_Loop" , 3.8, true, false, false, true, false);

    CreateDynamicPickup(19132, 1, 1499.4641,750.6773,11.0635, 0, 0); // вход
    CreateDynamic3DTextLabel("{ff9000}Выход ALT",0xA9C4E4FF, 1493.1527,711.9808,10.8901, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, INT_YAKUZA_SPORTSHALL);
    return true;
}

// Находится ли игрок внутри спортзала yakuza
stock PlayerInInteriorKatanaDuel(playerid)
{
    if(GetPlayerVirtualWorld(playerid) == WORLD_YAKUZA_SPORTSHALL && GetPlayerInterior(playerid) == INT_YAKUZA_SPORTSHALL
        || PlayerInPersonalInteriorKatanaDuel(playerid)) return true;
    return false;
}

// Находится ли игрок внутри личного инта 
stock PlayerInPersonalInteriorKatanaDuel(playerid)
{
    if((GetPlayerVirtualWorld(playerid) == playerid + 1) && GetPlayerInterior(playerid) == INT_YAKUZA_SPORTSHALL) return true;
    return false;
}


// Записываем последнюю позицию как вход в интерьер
stock KatanaDuel_WriteLastPlayerPosition(playerid)
{
    return WriteLastPlayerPosition(playerid, 1495.6964,750.7087,11.0635,90.5439, 0, 0);
}

// Входы выходы в спортзал якудзы
stock KatanaDuel_Door(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid,1.0,1499.4641,750.6773,11.0635) && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
	{
        S_SetPlayerVirtualWorld(playerid, WORLD_YAKUZA_SPORTSHALL, INT_YAKUZA_SPORTSHALL);
        PPSetPlayerInterior(playerid, INT_YAKUZA_SPORTSHALL);
        PPSetPlayerPos(playerid,1496.3229,711.8731,10.9101);
        PPSetPlayerFacingAngle(playerid,270.7123);
        SetCameraBehindPlayer(playerid);
        return true;
    }

    // Выход
    else if(IsPlayerInRangeOfPoint(playerid,1.0,1493.1527,711.9808,10.8901) 
        && PlayerInInteriorKatanaDuel(playerid))
	{
        S_SetPlayerVirtualWorld(playerid, 0, 0);
        PPSetPlayerInterior(playerid, 0);
        PPSetPlayerPos(playerid,1495.6964,750.7087,11.0635), PPSetPlayerFacingAngle(playerid,90.5439);
        SetCameraBehindPlayer(playerid);

        // Выход из катана дуэли
        CloseKatanaDuel(playerid);
        return true;
    }

    return false;
}

// Меню для старта дуэли на катанах
stock KatanaDuelMenu(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid,1.0,1511.6743,717.7614,10.8659) 
        && GetPlayerVirtualWorld(playerid) == WORLD_YAKUZA_SPORTSHALL && GetPlayerInterior(playerid) == INT_YAKUZA_SPORTSHALL)
	{
        KatanaDuelShowDialogMenu(playerid);
        return true;
    }
    return false;
}

stock KatanaDuelShowDialogMenu(playerid)
{
    new lines[100];
   	format(lines,sizeof(lines),"{ff9000}Начать Дуэль\
   	                        \n{cccccc}Купить Пропуск {99ff66}%d$", ServerInfo[35]);
	ShowDialog(playerid, KATANA_DUEL_MENU, DIALOG_STYLE_TABLIST, "{ff9000}Годжо Сатору", lines, "Выбор","Отмена");

    if(OnlineInfo[playerid][oListenRadioPears] == 0)
    {
        switch(random(4))
        {
            case 0: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/godjo/godjo0.mp3");
            case 1: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/godjo/godjo1.mp3");
            case 2: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/godjo/godjo2.mp3");
            case 3: PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/godjo/godjo3.mp3");
        }
    }
    return true;
}

stock ShowDialogSettingKatanaDuel(playerid)
{
	ShowDialog(playerid,KATANA_DUEL_PRICE,DIALOG_STYLE_INPUT,"{ff9000}Организация","{cccccc}Введите максимальную стоимость дуэли с Годжо Сатору\
																	\n{FF6347}Не меньше 1$ и не больше 200.000$","Принять","Отмена");
	return true;
}

// Настраиваем стоимость дуэли
stock SettingKatanaDuel(playerid, const inputtext[])
{
	new input = strval(inputtext);
	if(input < 1 || input > 200000) return ShowDialogSettingKatanaDuel(playerid);

	PlayerPlaySound(playerid,6401,0,0,0);
	ServerInfo[35] = input;
	SaveServer(35);
	showDialogOrganizationMenu(playerid);

	OrgLog(fraction(playerid), "katanaprice", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", input, "Стоимость дуэли");
	return true;
}

stock dialogCase_KatanaDuel(playerid, dialogid, response, listitem, const inputtext[])
{
    switch (e_DialogId: dialogid)
    {
        case KATANA_DUEL_MENU:
        {
            if(response)
            {
                if(!IsPlayerSyncModels(playerid)) return ErrorMessage(playerid, "{FF6347}Квест доступен только с лаунчером Pears Project\n{ffcc66}Скачайте его с нашего официального сайта pears.fun");
                if(listitem == 0)
                {
                    if(PlayerInfo[playerid][pMember] != 6)
                    {
                        new slot = get_invent2_Slot(playerid, 239, 0);
                        if(slot == -1) return ErrorMessage(playerid, "{FF6347}У вас нет пропуска\n{ffcc66}Приобретите его прямо здесь");
                        if(PlayerInfo[playerid][pInvenPara][slot] < gettime()) return ErrorMessage(playerid, "{FF6347}Ваш пропуск на дуэль, который лежит в инвентаре, недействителен");
                    }
                    if(PlayerInfo[playerid][pCDKatana] > gettime()) return ErrorMessage(playerid, "{FF6347}Вы не можете так часто сражаться с годжо\nПосмотреть время, через которое можно придти [ /time ]");
                    
		            ShowDialog(playerid, KATANA_DUEL_CONFIRM, DIALOG_STYLE_MSGBOX,"Годжо Сатору", 
                        "{ff9000}Вы уверены, что хотите начать дуэль на катанах?\n{ffcc66}Рекомендация: Пополните хп до максимума и наденьте бронежилет","Да","Нет");
                }
                else if(listitem == 1)
                {
                    if(PlayerInfo[playerid][pMember] == 6) return ErrorMessage(playerid, "{FF6347}Вы состоите в Yakuza и вам не нужно покупать пропуск");

                    new price = ServerInfo[35];
                    if(oGetPlayerMoney(playerid) < price) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
                    new slot = get_invent2_Slot(playerid, 239, 0);
                    if(slot >= 0) return ErrorMessage(playerid, "{FF6347}У вас в инвентаре уже лежит пропуск Годжо");

                    new put_inva = GiveThingPlayer(playerid, 239, 1, 0, 0, 0, 0);
                    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}В инвентаре не хватает места");
                    oGivePlayerMoney(playerid, -price);
                    MoneyLog("godjo", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, "Купил пропуск godjo");
                    payanim(playerid, 0);

                    OrganInfo[6][glave] += price;
                    OrganInfo[6][gUpdate] = 1;

                    new string[100];
                    format(string,sizeof(string),"{99ff66}Вы купили %s", friskName[239]);
                    SuccessMessage(playerid, string);
                }
            }
            return true;
        }
        case KATANA_DUEL_PRICE:
        {
		    if(response) SettingKatanaDuel(playerid, inputtext);
		    else showDialogOrganizationMenu(playerid);
		    return true;
        }
        case KATANA_DUEL_CONFIRM:
        {
		    if(response) CreateKatanaDuel(playerid);
		    return true;
        }
        case KATANA_DUEL_QUEST:
        {
            if(response)
            {
                ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Место проведения дуэлей на катанах отмечена в вашем GPS","*","");
                CreateGps(playerid, 1499.4641,750.6773,11.0635, 0, 0, 5.0);
            }
            else pc_cmd_quest(playerid);
        }
    }
    return false;
}

// Создаём дуэль с игроком
stock CreateKatanaDuel(playerid)
{
    if(KatanaBot[playerid] != INVALID_NPC) return false;

    KatanaBot[playerid] = CreateNpc(49, 1512.7740,717.8445,10.8659);
    SetNpcVirtualWorld(KatanaBot[playerid], playerid + 1);
    SetNpcWeapon(KatanaBot[playerid], WEAPON_KATANA);
    SetNpcHealth(KatanaBot[playerid], GODJO_SATORU_HEALTH);
    TaskNpcAttackPlayer(KatanaBot[playerid], playerid, true);
    SetNpcStunAnimationEnabled(KatanaBot[playerid], false); // Выключаем анимацию стана при нанесении дамага

    S_SetPlayerVirtualWorld(playerid, playerid + 1, INT_YAKUZA_SPORTSHALL);
    PPSetPlayerPos(playerid,1499.9072,717.9248,10.8659);
    PPSetPlayerFacingAngle(playerid,270.0);
    SetCameraBehindPlayer(playerid);

    // Временно отнимаем оружие
	TempTake(playerid, 0);
    Protect_GiveWeapons(playerid, 8, 1, 0, 0); // Выдаём нам катану
    SaveHealth[playerid] = HealthAC[playerid]; // Сохраняем хп до битвы

    PlayerInfo[playerid][pCDKatana] = gettime() + GODJO_SATORU_CD_LOOSE;
    new string[100];
    mysql_format(pearsq, string, sizeof(string),"UPDATE `pp_igroki` SET `pCDKatana` = '%d' WHERE `user_id` = '%d'", PlayerInfo[playerid][pCDKatana], PlayerInfo[playerid][pID]);
    mysql_tquery(pearsq, string);
    return true;
}

// Удаляем дуэль с ботом
stock DestroyKatanaDuel(playerid)
{
    if(KatanaBot[playerid] == INVALID_NPC) return false;
    if(!IsValidNpc(KatanaBot[playerid])) return false;

    DestroyNpc(KatanaBot[playerid]);
    KatanaBot[playerid] = INVALID_NPC;
    return true;
}

// Завершение битвы с ботом
stock CloseKatanaDuel(playerid)
{
    if(KatanaBot[playerid] != INVALID_NPC) ACSetPlayerHealth(playerid, SaveHealth[playerid]); // Возвращаем хп если дуэль активна
    DestroyKatanaDuel(playerid);
    TempGive(playerid);
    return true;
}

// Убили бота на дуэли
stock OnDeathKatanaDuel(NPC:npc, killerid)
{
    if(KatanaBot[killerid] == INVALID_NPC) return false;

    if(npc == KatanaBot[killerid])
    {
        if(PlayerInfo[killerid][pAchieve][132] == 0) AchievePlayer(killerid, 132, 1);

        new Float:npc_pos[3];
        GetNpcPosition(KatanaBot[killerid], npc_pos[0], npc_pos[1], npc_pos[2]);
        switch(random(2))
        {
            case 0: // Кладём шкатулку Yakuza
            {
                // Формируем шкатулку
                new thingId, thingQuan, thingType, thingPara, thingPack;
                CreateCasePlayer(killerid, thingId, thingQuan, thingType, thingPara, thingPack, "yakuza");
                CalculateVehicleLimited(thingId, thingType);

                SetThrow(-1, thingId, thingId, thingQuan, thingPara, 0, thingType, thingPack, GetNpcVirtualWorld(KatanaBot[killerid]), INT_YAKUZA_SPORTSHALL, 
                    npc_pos[0] + random(2), npc_pos[1] + random(2), npc_pos[2] - 1.0, 0.0, 0.0, 0.0 + random(90), 600, 0, 0, 0, PlayerInfo[killerid][pID]);
            }
            case 1: // Кладём ключ yakuza
            {
                SetThrow(-1, 235, 235, 1, 0, 0, 0, 0, GetNpcVirtualWorld(KatanaBot[killerid]), INT_YAKUZA_SPORTSHALL, 
                    npc_pos[0] + random(2), npc_pos[1] + random(2), npc_pos[2] - 1.0, 0.0, 0.0, 0.0 + random(90), 600, 0, 0, 0, PlayerInfo[killerid][pID]);
            }
        }

        CloseKatanaDuel(killerid);

        PlayerInfo[killerid][pCDKatana] = gettime() + GODJO_SATORU_CD_WIN;
        new string[100];
        mysql_format(pearsq, string, sizeof(string),"UPDATE `pp_igroki` SET `pCDKatana` = '%d' WHERE `user_id` = '%d'", PlayerInfo[killerid][pCDKatana], PlayerInfo[killerid][pID]);
        mysql_tquery(pearsq, string);

        new lines[200];
        format(lines,sizeof(lines),"{99ff66}Вы победили Годжо Сатору!\
                                    \n{ffcc66}Подберите приз, который лежит на полу [ N >> Рядом ]\
                                    \n{ffcc66}Вы можете вернуться и сразиться повторно через %d минут [ /time ]", GODJO_SATORU_CD_WIN / 60);
        SuccessMessage(killerid, lines);

        SendClientMessage(killerid, COLOR_GREY, "[ Мысли ]: Омагад... Я победил%s Годжо Сатору [ Подберите приз с пола N >> Рядом ]", gender(killerid));
        SendClientMessage(killerid, COLOR_GREY, "[ Мысли ]: Я могу вернуться и сразиться повторно через %d минут [ /time ]", GODJO_SATORU_CD_WIN / 60);

        CompleteBattlePassTask(killerid, 37, 1);
        if(OnlineInfo[killerid][oListenRadioPears] == 0)
        {
            switch(random(2))
            {
                case 0: PlayAudioStreamForPlayer(killerid, "https://cdn.pears.fun/sound/characters/godjo/godjo7.mp3");
                case 1: PlayAudioStreamForPlayer(killerid, "https://cdn.pears.fun/sound/characters/godjo/godjo8.mp3");
            }
        }
        return true;
    }
    return false;
}

// Бот наносит урон по игроку
stock KatanaDuel_OnPlayerTakeDamageNpc(NPC:npc, issuerid, Float:amount, weaponid, bodypart)
{
    #pragma unused amount
    #pragma unused weaponid
    #pragma unused bodypart

    if(KatanaBot[issuerid] == INVALID_NPC) return false;

    if(npc == KatanaBot[issuerid])
    {
        new Float:health;
	    GetPlayerHealth(issuerid, health);
        if(health <= 20)
        {
            CloseKatanaDuel(issuerid);
            PlayerPlaySound(issuerid,31202,0,0,0);

            new lines[200];
            format(lines,sizeof(lines),"{ffcc66}Вы проиграли!\
   	                        \n{FF6347}Сразиться повторно можно будет через %d минут", GODJO_SATORU_CD_LOOSE / 60);
            ShowDialog(issuerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");

            if(OnlineInfo[issuerid][oListenRadioPears] == 0)
            {
                switch(random(3))
                {
                    case 0: PlayAudioStreamForPlayer(issuerid, "https://cdn.pears.fun/sound/characters/godjo/godjo4.mp3");
                    case 1: PlayAudioStreamForPlayer(issuerid, "https://cdn.pears.fun/sound/characters/godjo/godjo5.mp3");
                    case 2: PlayAudioStreamForPlayer(issuerid, "https://cdn.pears.fun/sound/characters/godjo/godjo6.mp3");
                }
            }
        }
        return true;
    }
    return false;
}


new Follow[MAX_REALPLAYERS];
new FollowTime[MAX_REALPLAYERS];

stock ProcessFollowMe(playerid)
{
    if(Follow[playerid] != 9999 && FollowTime[playerid] == 0 && HealthAC[playerid] != 0
		&& DeathInfo[playerid][deathStatus] == false)
	{
		new copid = Follow[playerid];
		if(IsOnline(copid))
		{
			new Float:distcop = GetPlayerDistanceFromPoint(playerid, Protect_X[copid], Protect_Y[copid], Protect_Z[copid]);
			if(!IsPlayerInAnyVehicle(playerid))
			{
			    new w = GetPlayerVirtualWorld(copid), i = GetPlayerInterior(copid);
			    if((w != GetPlayerVirtualWorld(playerid) || i != GetPlayerInterior(playerid))) S_SetPlayerVirtualWorld(playerid, w, i), PPSetPlayerInterior(playerid, i);

				// Если мы дальше 4 метров и ближе 20 заставляем игрока идти за нами
				if(distcop >= 4.0)
				{
					TurnPlayerFaceToPlayer(playerid, copid); // Поворачиваем лицом
					if(GetPVarInt(playerid, "Follow_Run") == 0)
					{
						ApplyAnimation(playerid,"PED","sprint_panic",4.0, true, true, true, false, 0);
						SetPVarInt(playerid, "Follow_Run", 1);
					}
				}

				// Подошли близко, останавливаем
				if(distcop <= 3.9 && GetPVarInt(playerid, "Follow_Run") == 1) StopFollowMe(playerid);
			}
		}
	}
    return 1;
}

// Встаём
stock StopFollowMe(playerid)
{
	ApplyAnimation(playerid,"PED","facanger",4.0, false, true, true, false, false);
	ClearAnimations(playerid);
	SetPVarInt(playerid, "Follow_Run", 0);
	return 1;
}

// Ставим в позицию игрока, которого ведём за собой
stock SetPlayerPosFollowMe(playerid) 
{
	// Этот stock встроен в SetPlayerFaclingAngle
	// Потому что, чтобы игрока правильно поставить перед лицом нам нужно заранее знать, куда мы будем смотреть после входа

	if(Follow[playerid] != 9999 // Имеет id игрока
		&& FollowTime[playerid] == 1) // Я веду игрока
	{
		new followid = Follow[playerid];
		if(IsOnline(followid))
		{
			StopFollowMe(followid); // Останавливаем
			keep(followid); // Морозим игрока

			// Меняем вирт мир и инт
			new world = OnlineInfo[playerid][oWorldPlayer], interior = OnlineInfo[playerid][oInteriorPlayer];
			S_SetPlayerVirtualWorld(followid, world, interior);
			PPSetPlayerInterior(followid, interior);

			// Обновляем объекты стримера (Потому что мы игрока можем поставить в экстерьер)
			Streamer_Update(followid, STREAMER_TYPE_OBJECT);

			// Ставим перед лицом
			new Float:copx,Float:copy, Float:copz, Float:copa;
			frontme(playerid, 2.0, copx, copy, copz, copa, true);
        	SetPlayerLookAt(followid, copx, copy);
        	PPSetPlayerPos(followid, copx, copy, copz);
		}
	}
    return 1;
}

alias:followme("fme", "gotome", "gme")
CMD:followme(playerid, const params[])
{
	if(!IsACop(playerid)
		&& PlayerInfo[playerid][pMember] != 4
		&& PlayerInfo[playerid][pMember] != 3
		&& PlayerInfo[playerid][pMember] != 7) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не сотрудник правоохранительных органов");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я в транспорте");
	if(NoAnim[playerid] == 1)  return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Сейчас не момент для этого действия {ff9000}[ Enter или Л.К.М. ]");
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerInfo[playerid][pSoska] == 0) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я нахожусь в слежке");
	if(PlayerInfo[playerid][pJailed] > 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я нахожусь в заключении");
	if(CnnVed[playerid] >= 11) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я смотрю CNN Channel");
	if(box[playerid] >= 1) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Я на ринге");
	if(MPGO[playerid] != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я на мероприятии");
	if(PlayerInfo[playerid][pBkyrenie] >= 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чего, блин ?! Я не на земле");
	if(GetPVarInt(playerid,"Boot") != 9999) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я в багажнике");
  	if(howstun(playerid) || HealthAC[playerid] <= 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мне плохо");
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Вести за собой [ /fme ID ]");
	if(params[0] == playerid) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чтоо..?");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Его вообще нет..");
	if(!ProxDetectorS(5.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я слишком далеко");
	if(GetPlayerState(params[0]) == PLAYER_STATE_SPECTATING && gSpectateID[params[0]] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я слишком далеко");
	if(CheckPlayerNpc(playerid, params[0])) return 1;
	if(IsPlayerInAnyVehicle(params[0]) && GetVehicleSpeed(params[0]) > 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Нельзя тащить за собой из транспорта на ходу");
	if(GetPVarInt(params[0],"afksystem") >= 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Подозреваемый уснул..");
	if(Follow[playerid] == 9999)
	{
		if(Stun[4][params[0]] >= 1 || Stun[5][params[0]] >= 1 || Stun[0][params[0]] >= 1)
		{
			if(PlayerInfo[params[0]][pJailed] > 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Он находится под заключением");

			// Если игрок дохлый, лечим его
			if(DeathInfo[params[0]][deathStatus]) ACSetPlayerHealth(params[0], 100);

			new string[144];
			Follow[playerid] = params[0], FollowTime[playerid] = 1;
			Follow[params[0]] = playerid, FollowTime[params[0]] = 0;
			format(string, sizeof(string), "* Вы ведёте за собой %s.", playername(params[0]));
			SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* %s ведёт за собой %s.", playername(playerid), playername(params[0]));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			format(string, sizeof(string), "ведёт за собой %s", playername(params[0]));
			SetPlayerChatBubble(playerid,string,COLOR_PURPLE,30.0,10000);
			PlayerPlaySound(playerid, 6401, 0.0, 0.0, 0.0);
			PlayerPlaySound(params[0], 1052, 0.0, 0.0, 0.0);
		}
		else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Нужно обездвижить [ /cuff /stun /tie ]");
	}
	else
	{
	    if(FollowTime[playerid] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Меня ведут за собой");
		new string[144];
		new s = Follow[playerid];
		if(IsPlayerConnected(s))
		{
			if(OnlineInfo[s][oLogged] == 1)
			{
				Follow[s] = 9999, FollowTime[s] = 0;
				format(string, sizeof(string), "* Вы отпустили %s.", playername(s));
				SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* %s отпускает %s.", playername(playerid), playername(s));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				format(string, sizeof(string), "отпускает %s", playername(s));
				SetPlayerChatBubble(playerid,string,COLOR_PURPLE,30.0,10000);
			}
		}
		Follow[playerid] = 9999, FollowTime[playerid] = 0;
	}
   	return 1;
}

stock StopFollow(p)
{
    if(Follow[p] == 9999) return 1;

	new s = Follow[p];
	if(IsPlayerConnected(s))
	{
		if(OnlineInfo[s][oLogged] == 1) Follow[s] = 9999, FollowTime[s] = 0;
	}
	Follow[p] = 9999, FollowTime[p] = 0;
	return 1;
}

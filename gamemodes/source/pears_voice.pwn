
#define MAZ_ZONE_AREAV 5
new Float:AreaV_X[MAZ_ZONE_AREAV], Float:AreaV_Y[MAZ_ZONE_AREAV], Float:AreaV_Z[MAZ_ZONE_AREAV];
new AreaVWorld[MAZ_ZONE_AREAV], AreaVInt[MAZ_ZONE_AREAV], bool:AreaVStat[MAZ_ZONE_AREAV], AreaVRad[MAZ_ZONE_AREAV];

new AudioStream:adm_stream = INVALID_AUDIOSTREAM;
new AudioStream:lstream[MAX_REALPLAYERS] = { INVALID_AUDIOSTREAM, ... };

// https://cdn.pears.fun/sound/music/test.mp3

CMD:areav(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 4) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Создать зону в которой нельзя использовать голосовой чат [ /areav Радиус Действия ]");
	if(params[0] > 500 || params[0] < 10) return ErrorMessage(playerid, "{FF6347}Радиус зоны не меньше 10 и не больше 500 метров");
	new zon = -1;
	for(new z = 0; z < MAZ_ZONE_AREAV; z++)
	{
	    if(!AreaVStat[z])
	    {
			zon = z;
			break;
		}
	}

	if(zon >= 0)
	{
		GetPlayerPos(playerid, AreaV_X[zon], AreaV_Y[zon], AreaV_Z[zon]);
		AreaVWorld[zon] = GetPlayerVirtualWorld(playerid);
		AreaVInt[zon] = GetPlayerInterior(playerid);
		AreaVStat[zon] = true;
		AreaVRad[zon] = params[0];
		new string[110];
		format(string, sizeof(string), " [ ADM ]: %s установил зону [ID: %d] без голосового чата (Радиус: %d м.)",PlayerInfo[playerid][pName],zon+1,params[0]);
		ABroadCast(COLOR_ADM,string,1);
	}
    else ErrorMessage(playerid, "{FF6347}Нет свободных слотов для создания новой зоны\n{cccccc}Удалите старые зоны /delareav");
	return 1;
}

CMD:gotoareav(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 4) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Телепортироваться в зону без голосового чата [ /gotoareav ID Зоны ]");
	if(params[0] > MAZ_ZONE_AREAV || params[0] < 1) return ErrorMessage(playerid, "{FF6347}Неверный id зоны");
	
    new z = params[0]-1;
	if(!AreaVStat[z]) return ErrorMessage(playerid, "{FF6347}Эта зона не установлена");

	S_SetPlayerVirtualWorld(playerid, AreaVWorld[z], AreaVInt[z]), PPSetPlayerInterior(playerid, AreaVInt[z]);
	PPSetPlayerPos(playerid, AreaV_X[z], AreaV_Y[z], AreaV_Z[z]);
    PPSetPlayerFacingAngle(playerid, 0.0);
	return 1;
}

CMD:delareav(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 4) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Удалить зону в которой нельзя использовать голосовой чат [ /delareav ID Зоны ]");
	if(params[0] > MAZ_ZONE_AREAV || params[0] < 1) return ErrorMessage(playerid, "{FF6347}Неверный id зоны");
	
    new z = params[0]-1;
	if(!AreaVStat[z]) return ErrorMessage(playerid, "{FF6347}Эта зона не установлена");
	AreaVStat[z] = false;
	new string[110];
	format(string, sizeof(string), " [ ADM ]: %s свернул зону [ID: %d] без голосового чата",PlayerInfo[playerid][pName], params[0]);
	ABroadCast(COLOR_ADM,string,1);
	return 1;
}

CMD:rvoice(playerid, const params[])
{
    new tmp[24];
    if(!sscanf(params, "s[24]",tmp))
	{
        if(PlayerInfo[playerid][pSoska] == 0) return ErrorMessage(playerid, "{FF6347}Только администратор может перезагрузить voice другому игроку");
        new giveplayerid = ReturnUser(tmp, 1);
     	if(IsOnline(giveplayerid))
	 	{
            if(OnlineInfo[giveplayerid][oLogged] == 0) return ErrorMessage(playerid, "{FF6347}Игрок не залогинился");
            if(ReloadVoice(giveplayerid) == 0) return ErrorMessage(playerid, "{FF6347}У игрока не запущен голосовой чат");
            if(playerid != giveplayerid) SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы перезагрузили голосовой чат %s", PlayerInfo[giveplayerid][pName]);
			SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "* %s перезагрузил ваш голосовой чат", PlayerInfo[playerid][pName]);
        }
        else ErrorMessage(playerid, "{FF6347}Игрока нет в сети");
    }
    else
    {
        if(ReloadVoice(playerid) == 0) return ErrorMessage(playerid, "{FF6347}У вас не запущен голосовой чат");
        SuccessMessage(playerid, "{99ff66}Голосовой чат перезагружен");
    }
    return 1;
}

// Перезагружаем войс игроку
stock ReloadVoice(playerid)
{
    if(PlayerInfo[playerid][pVoice] == false) return 0;

    Sampvoice3DestroyPlayer(playerid);
    Sampvoice3InitializationPlayer(playerid);
    return 1;
}

// Отключаем пиздёж в войс (например во время мута)
stock SampvoiceStopTalking(playerid)
{
    if(PlayerInfo[playerid][pVoice] == false) return false;

    //SvDetachSpeakerFromStream(lstream[playerid], playerid);
    //SvDetachSpeakerFromStream(adm_stream, playerid);
    return true;
}

stock Sampvoice3InitializationMode()
{
    adm_stream = CreateAudioStream("A", 0xff0000ff);
    printf("[MODE]: Pears Voice Compiled");
    return 1;
}

stock Sampvoice3InitializationPlayer(playerid) // Запускаем игроку sampvoice
{
    if(IsPlayerSyncModels(playerid))
    {
        PlayerInfo[playerid][pVoice] = true;

        if(lstream[playerid] == INVALID_AUDIOSTREAM)
        {
            lstream[playerid] = CreateAudioStream();
            AttachAudioStreamToPlayer(lstream[playerid], playerid);
            SetAudioStreamAutostreamState(lstream[playerid], true);
            SetAudioStreamAutostreamDist(lstream[playerid], 22.0);
            SetAudioStreamMinDistance(lstream[playerid], 1.5);
            SetAudioStreamMaxDistance(lstream[playerid], 15.0);
            SetAudioStreamSpatialState(lstream[playerid], true);
            AttachAudioStreamSpeaker(lstream[playerid], playerid);
        }

        //if(PlayerInfo[playerid][pSoska] > 0) Sampvoice3AttachAdmin(playerid);
    }
    return 1;
}

stock Sampvoice3AttachAdmin(playerid)
{
    if(PlayerInfo[playerid][pVoice] == false) return 0;
    if (adm_stream != INVALID_AUDIOSTREAM)
    {
        gAvoi[playerid] = true;
		if(adm_stream) AttachAudioStreamListener(adm_stream, playerid);
    }
    return 1;
}

stock Sampvoice3DestroyPlayer(playerid) // Отключаем игроку sampvoice при выходе из игры
{
    if(PlayerInfo[playerid][pVoice] == false) return 0;

    if(lstream[playerid] != INVALID_AUDIOSTREAM) 
    {
        DeleteAudioStream(lstream[playerid]);
        lstream[playerid] = INVALID_AUDIOSTREAM;
    }

    SampvoiceDetachAdmin(playerid);
    return 1;
}

stock SampvoiceDetachAdmin(playerid)
{
    if(PlayerInfo[playerid][pVoice] == false) return 0;

    if(gAvoi[playerid] == true && adm_stream)
	{
        gAvoi[playerid] = false;
        DetachAudioStreamListener(adm_stream, playerid);
    }
    return 1;
}  

public bool:OnPlayerVoiceSpeak(playerid, AudioStream:stream)
{
    if(PlayerInfo[playerid][pVoice] == false) return false;
    if(isamute(playerid) == 1) return false;

    return true;
}

/*public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid,SV_UINT:keyid)
{
    if(PlayerInfo[playerid][pVoice] == false) return 0;
    if(isamute(playerid) == 1) return 0;

    if(keyid == 0x42)
    {
        new net = -1;
        for(new z = 0; z < MAZ_ZONE_AREAV; z++)
        {
            if(IsPlayerInRangeOfPoint(playerid, AreaVRad[z], AreaV_X[z], AreaV_Y[z], AreaV_Z[z]) && AreaVStat[z] 
                && GetPlayerVirtualWorld(playerid) == AreaVWorld[z] && GetPlayerInterior(playerid) == AreaVInt[z]) 
            {
                net = z;
                break;
            }
        }

        if(net >= 0)
        {
            new string[130];
            format(string,sizeof(string), "{FF6347}Здесь находится зона без голосового чата (Радиус %d м.) \n{cccccc}Администратор может удалить зону /delareav %d", AreaVRad[net], net + 1);
            ErrorMessage(playerid, string);
            return 1;
        }

        if(HealthAC[playerid] <= 0.0 && DeathInfo[playerid][deathStatus] == false) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо и он не может разговаривать");
        if(lstream[playerid]) SvAttachSpeakerToStream(lstream[playerid], playerid);
    }
    else if(keyid == 0x5A)
    {
        if(gAvoi[playerid] == true && adm_stream) SvAttachSpeakerToStream(adm_stream, playerid);
    }
    return 1;
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid,SV_UINT:keyid)
{
    if(PlayerInfo[playerid][pVoice] == false) return 0;

    if(keyid == 0x42)
    {
        if(lstream[playerid]) SvDetachSpeakerFromStream(lstream[playerid], playerid);
    }

    if(keyid == 0x5A)
    {
        if(adm_stream) SvDetachSpeakerFromStream(adm_stream, playerid);
    }
    return 1;
}*/

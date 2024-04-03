
new SV_GSTREAM:adm_stream = SV_NULL;
new SV_LSTREAM:lstream[MAX_REALPLAYERS] = { SV_NULL, ... };

// https://cdn.pears.fun/sound/music/test.mp3

stock Sampvoice3InitializationMode()
{
    SvDebug(SV_TRUE);

    new string[4];
    format(string, sizeof(string), "A");
   	adm_stream = SvCreateGStream(0xff0000ff, string); // SAMPVOICE

    printf("[MODE]: SampVoice 3.1 Compiled");
    return 1;
}

stock Sampvoice3ExitMode()
{
    if(adm_stream) SvDeleteStream(adm_stream); // SAMPVOICE
    return 1;
}

stock Sampvoice3InitializationPlayer(playerid) // Запускаем игроку sampvoice
{
	if(!SvGetVersion(playerid)) SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ SampVoice ]: {ffcc66}Плагин голосового чата не установлен");
	else if(!SvHasMicro(playerid)) SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ SampVoice ]: {ffcc66}Микрофон не обнаружен");
	else 
    {
        PlayerInfo[playerid][pVoice] = true;

        if(!lstream[playerid])
        {
            SvAddKey(playerid, 0x42);
            new string[4];
            format(string, sizeof(string), "L");
            lstream[playerid] = SvCreateDLStreamAtPlayer(30.0, SV_INFINITY, playerid, -1, string); //lstream[p] = SvCreateDLStreamAtPlayer(40.0, SV_INFINITY, p, 0xffffffff, "L");
        }

        if(PlayerInfo[playerid][pSoska] > 0) Sampvoice3AttachAdmin(playerid);
    }
    return 1;
}

stock Sampvoice3AttachAdmin(playerid)
{
    if(PlayerInfo[playerid][pVoice] == false) return 0;
    if (adm_stream != SV_NULL)
    {
        gAvoi[playerid] = true;
        SvAddKey(playerid, 0x5A);
		if(adm_stream) SvAttachListenerToStream(adm_stream, playerid);
    }
    return 1;
}

stock Sampvoice3DestroyPlayer(playerid) // Отключаем игроку sampvoice при выходе из игры
{
    if(PlayerInfo[playerid][pVoice] == false) return 0;

    if(lstream[playerid]) SvDeleteStream(lstream[playerid]), lstream[playerid] = SV_NULL;
	if(PlayerInfo[playerid][pSoska] > 0)
    {
        if(gAvoi[playerid] == true)
	    {
            if(adm_stream) gAvoi[playerid] = false, SvDetachListenerFromStream(adm_stream, playerid), SvRemoveKey(playerid, 0x5A);
        }
    }
    return 1;
}

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid,SV_UINT:keyid)
{
	if(PlayerInfo[playerid][pMuteTime] == 0)
	{
	    new net;
	    if((IsPlayerInRangeOfPoint(playerid, AreaVRad[0], AreaV_X[0], AreaV_Y[0], AreaV_Z[0]) && AreaVStat[0] 
		|| IsPlayerInRangeOfPoint(playerid, AreaVRad[1], AreaV_X[1], AreaV_Y[1], AreaV_Z[1]) && AreaVStat[1]
		|| IsPlayerInRangeOfPoint(playerid, AreaVRad[2], AreaV_X[2], AreaV_Y[2], AreaV_Z[2]) && AreaVStat[2]) && PlayerInfo[playerid][pSoska] == 0) net = 1;
		if(keyid == 0x42)
		{
			if(lstream[playerid] 
                && HealthAC[playerid] > 0 
                && net == 0 
                && DeathInfo[playerid][deathStatus] == false) SvAttachSpeakerToStream(lstream[playerid], playerid);
		}
        else if(keyid == 0x5A)
        {
            if(gAvoi[playerid] == true && adm_stream) SvAttachSpeakerToStream(adm_stream, playerid);
        }
	}
	else isamute(playerid);
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid,SV_UINT:keyid)
{
    if(keyid == 0x42)
    {
        if(lstream[playerid]) SvDetachSpeakerFromStream(lstream[playerid], playerid);
    }

    else if(keyid == 0x5A)
    {
        if(adm_stream) SvDetachSpeakerFromStream(adm_stream, playerid);
    }
}


#define ADMIN_CHANNEL 0
#define LOCAL_CHANNEL 1

new SV_UINT:adm_stream = SV_NONE;
new SV_UINT:lstream[MAX_REALPLAYERS] = { SV_NONE, ... };

stock SampvoiceInitializationMode()
{
    SvEnableDebug(); // Режим отладки Sampvoice

    adm_stream = SvCreateStream();

    printf("[MODE]: SampVoice Compiled");
    return 1;
}

stock SampvoiceExitMode()
{
    if (adm_stream != SV_NONE)
    {
        SvDeleteStream(adm_stream);
        adm_stream = SV_NONE;
    }
    return 1;
}

stock SampvoiceInitializationPlayer(playerid) // Запускаем игроку sampvoice
{
    if(SvGetVersion(playerid) == 0) SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ SampVoice ]: {ffcc66}Плагин голосового чата не установлен");
    else if(SvHasMicro(playerid) == SV_FALSE) SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ SampVoice ]: {ffcc66}Микрофон не обнаружен");
    else
    {
        if ((lstream[playerid] = SvCreateStream(40.0)) != SV_NONE) // Чат рядом с игроками
        {
            PlayerInfo[playerid][pVoice] = true;
            SvSetKey(playerid, 0x5A, LOCAL_CHANNEL); // Z key
            SvAttachStream(playerid, lstream[playerid], LOCAL_CHANNEL);
            SvSetTarget(lstream[playerid], SvMakePlayer(playerid));
            SvSetIcon(lstream[playerid], "speaker");
        }

        if(PlayerInfo[playerid][pSoska] > 0) SampvoiceAttachAdmin(playerid);
    }
    return 1;
}

stock SampvoiceAttachAdmin(playerid)
{
    if(PlayerInfo[playerid][pVoice] == false) return 0;
    if (adm_stream != SV_NONE)
    {
        SvSetKey(playerid, 0x42, ADMIN_CHANNEL); // B key
        SvAttachStream(playerid, adm_stream, ADMIN_CHANNEL);
        SvAttachListener(adm_stream, playerid);
        SvSetIcon(adm_stream, "speaker");

        SvEnableSpeaker(playerid, ADMIN_CHANNEL);
        SvEnableListener(playerid);
    }
    return 1;
}

stock SampvoiceStopPlayer(playerid) // Отключаем игроку sampvoice (например выдали мут, чтобы он не мог продолжать говорить)
{
    if(PlayerInfo[playerid][pVoice] == false) return 0;
    SvDisableSpeaker(playerid, LOCAL_CHANNEL);
    return 1;
}

stock SampvoiceDestroyPlayer(playerid) // Отключаем игроку sampvoice при выходе из игры
{
    if(PlayerInfo[playerid][pVoice] == false) return 0;
    PlayerInfo[playerid][pVoice] = false;

    if(lstream[playerid]) // Удаляем личный поток
    {
        SvDeleteStream(lstream[playerid]);
        lstream[playerid] = SV_NONE;
    }
	//if(PlayerInfo[playerid][pSoska] > 0) StopVoice(playerid, 228);
    return 1;
}

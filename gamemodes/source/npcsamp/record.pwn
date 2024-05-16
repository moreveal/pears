
CMD:record(playerid, const params[])
{
    if(server != 0) return 0;
    if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    new name[64];
    if(sscanf(params, "s[64]", name)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Записать сценарий NPC [ /record Название ]");

	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) StartRecordingPlayerData(playerid, PLAYER_RECORDING_TYPE_DRIVER, name);
	else if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) StartRecordingPlayerData(playerid, PLAYER_RECORDING_TYPE_ONFOOT, name);
	else ErrorMessage(playerid, "{FF6347}Записать сценарий можно только за рулём транспорта или пешком");

	SendClientMessage(playerid, COLOR_RED, "Recording: started.");
	return 1;
}

CMD:stoprecord(playerid)
{
    if(server != 0) return 0;
    if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	StopRecordingPlayerData(playerid);
	SendClientMessage(playerid, COLOR_RED, "Recording: stopped.");
	return 1;
}

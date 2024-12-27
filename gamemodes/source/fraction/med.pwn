
alias:heal("mheal", "pheal")
CMD:heal(playerid, const params[])
{
	if(PlayerInfo[playerid][pMember] != 4) return ErrorMessage(playerid, "{FF6347}Вы не доктор");
    if(ServerInfo[9] <= 0 || ServerInfo[9] > 10000) return ErrorMessage(playerid, "{FF6347}Стоимость лечения не настроена\n{ffcc66}Лидеру необходимо настроить стоимость [ Y >> Организация ]");
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я могу вылечить кого угодно [ /heal ID ]");
	if(params[0] == playerid) return ErrorMessage(playerid, "{FF6347}Вы не можете вылечить себя");
	if(!IsOnline(params[0])) return ErrorMessage(playerid, "{FF6347}Этого игрока нет в сети");
	if(GetPlayerState(params[0]) == PLAYER_STATE_SPECTATING
		&& gSpectateID[params[0]] != INVALID_PLAYER_ID
		|| !ProxDetectorS(3.0, playerid, params[0])) return ErrorMessage(playerid, "{FF6347}Вы далеко от пациента");
	if(MPGO[playerid] != 0) return ErrorMessage(playerid, "{FF6347}Вы на мероприятии");
	if(HealthAC[params[0]] >= GetMaxPlayerHealth(params[0])) return ErrorMessage(playerid, "{FF6347}У пациента полная полоса здоровья и ему не требуется лечение");
	if(MedHeal[params[0]] > 0) return ErrorMessage(playerid, "{FF6347}Пациенту уже предложили лечение");

	new string[150];
	PlayerPlaySound(params[0],40405,0,0,0);

	MedHeal[params[0]] = ServerInfo[9];
	DP[0][params[0]] = playerid;
	format(string, sizeof(string), "{cccccc}Доктор {ff6666}%s {cccccc}предлагает вам лечение\n{cccccc}Стоимость: {99ff66}%d$\n\n{ff9000}Вы согласны?", 
		rpplayername(playerid), ServerInfo[9]);
	ShowDialog(params[0],1506,DIALOG_STYLE_MSGBOX,"{ff6666}Лечение",string,"Да","Нет");

	format(string, sizeof(string), "предлагает %s лечение", rpplayername(params[0]));
	SetPlayerChatBubble(playerid, string, COLOR_PURPLE,20.0,3000);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы предложили %s лечение", rpplayername(params[0]));
	return true;
}

// Мгновенно лечим игрока за лаве
stock HealPlayer(playerid)
{
	new price = MedHeal[playerid];
	if(price == 0) return ErrorMessage(playerid, "{FF6347}Вам не предлагали лечение");
	MedHeal[playerid] = 0;
    if(HealthAC[playerid] >= GetMaxPlayerHealth(playerid)) return ErrorMessage(playerid, "{FF6347}У вас полная полоса здоровья и лечение не требуется");

	new giveplayerid = DP[0][playerid];

	if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Доктор куда-то делся\n{ffcc66}Вероятно, он вышел из игры");
	if(GetPlayerState(giveplayerid) == PLAYER_STATE_SPECTATING
		&& gSpectateID[giveplayerid] != INVALID_PLAYER_ID
		|| !ProxDetectorS(3.0, playerid, giveplayerid)) return ErrorMessage(playerid, "{FF6347}Я далеко от доктора");

	if(oGetPlayerMoney(playerid) >= price) oGivePlayerMoney(playerid, -price);
	else if(PlayerInfo[playerid][pAccount] >= price) oGivePlayerBank(playerid, -price);
	else return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");

    ResetHeal(playerid);
    ACSetPlayerHealth(playerid, GetMaxPlayerHealth(playerid)); // Пополняем хп
    new string[20];
    format(string, sizeof string, "+%.1f HP", 100 - HealthAC[playerid]);
    SetPlayerChatBubble(playerid, string, COLOR_GREEN, 45.0, 4000);

	OrganInfo[4][glave] += price;
	OrganInfo[4][gUpdate] = 1;
    GiveUnit(giveplayerid, 22);

	MoneyLog("heal", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, "Медик вылечил игрока");
	return true;
}

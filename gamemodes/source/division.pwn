/*
Важное поясниение!
В этом pwn много где в получении или передаче переменных имеется +1 или -1, т.е. какие-то вычеты
Организации, это id начиная с 1 и так далее, а внутри переменных подфракций счёт идёт с 0
Поэтому в зависимости от того, откуда мы берём переменную или куда мы её применяем, я делаю -1 или +1
Переменная pDivision не может иметь 0 (0 значит нет подфракции), поэтому если беру отсюда, то плюсую
Переменная pLeader pMember и функция ftaction(playerid) не могут иметь 0 (0 значит нет подфракции), так-же плюсуем

DP[0] - используется в /lmenu
DP[1] - id organization
DP[2] - id division
DP[3] - информация о доступе к управлению подфракцией
DP[4] - слот цвета для транспорта, последний id игрока на страницах divmembersoff
DP[5] - номер страницы в divmembersoff
*/

// Список всех подфракций (Меню для лидера)
CMD:alldiv(playerid)
{
	new g = fraction(playerid);
	if(PlayerInfo[playerid][pLeader] > 0
		|| g > 0 && PlayerInfo[playerid][pRank] >= get_maxrank(g) - 1)
	{
    	PlayerPlaySound(playerid,1150,0,0,0);
    	showDialogAllDivisions(playerid);
	}
	else ErrorMessage(playerid, "{FF6347}У вас нет доступа к настройкам всех подфракций");
	return 1;
}
stock showDialogAllDivisions(playerid)
{
    new g = fraction(playerid) - 1;
	DP[1][playerid] = g; // Сохраняем id организации

	new line[160],lines[1760];
    format(line,sizeof(line),"ID\tНазвание\tАббревиатура"), strcat(lines,line);
    for(new i = 0; i < MAX_DIVISION_ORG; i++)
	{
        format(line,sizeof(line),"\n{ff9000}%d.\t{cccccc}{%s}%s\t%s", i+1, DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName], DivisionInfo[g][i][divAbbreviation]), strcat(lines,line);
    }
	ShowDialog(playerid, _:DIVISION_MENU,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Подфракции",lines,"Выбрать","Выход");
    return 1;
}

// Меню подфракции
alias:division("div")
CMD:division(playerid)
{
	if(PlayerInfo[playerid][pDivision][0] == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в подфракции");
	if(fraction(playerid) == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");

	DP[1][playerid] = fraction(playerid)-1;
	DP[2][playerid] = PlayerInfo[playerid][pDivision][0] - 1;

	DP[6][playerid] = 0;
    PlayerPlaySound(playerid,1150,0,0,0);
    showDialogMenuDivision(playerid);
	return 1;
}

// Цвет подфракции
CMD:divcolor(playerid) {
	new g = fraction(playerid),
		i = PlayerInfo[playerid][pDivision][0] - 1;

	if(i < 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в подфракции");
	if(g < 1) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");

	new div_color = GetDivisionColor(g, i);
	if (GetPlayerColor(playerid) == div_color) {
		SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Значок отличия подфракции выключен");
		SetPlayerColor(playerid, INV_COLOR);
	} else {
		SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я включил значок отличия подфракции");
		SetPlayerColor(playerid, div_color);
	}

	return 1;
}

stock showDialogMenuDivision(playerid)
{
	new g = DP[1][playerid]; // Получаем id организации
	new i = DP[2][playerid]; // Получаем id подфракции
	DP[3][playerid] = 0; // Сбрасываем доступ к управлению

	new line[120],lines[1680];
	format(line,sizeof(line),"{cccccc}Информация\t"), strcat(lines,line);
	format(line,sizeof(line),"\n{555555}Участники {99ff66}Online\t"), strcat(lines,line);

	// Настройки подфракции для лидеров, замов и глав подфракции
	if(PlayerInfo[playerid][pLeader] > 0 
	|| PlayerInfo[playerid][pMember] > 0 && PlayerInfo[playerid][pRank] >= get_maxrank(g+1)-1
	|| PlayerInfo[playerid][pDivision][0] == i+1 && PlayerInfo[playerid][pDivRank][0] >= DivisionInfo[g][i][divRanks])
	{
		DP[3][playerid] = 1; // Даём доступ к управлению подфракцией

		format(line,sizeof(line),"\n{555555}Участники {FF6347}Offline\t"), strcat(lines,line);
		format(line,sizeof(line),"\n{555555}Пригласить\t"), strcat(lines,line);
		format(line,sizeof(line),"\n{555555}Исключить\t"), strcat(lines,line);

		format(line,sizeof(line),"\n{cccccc}Название: \t{%s}%s", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}Аббревиатура: \t{%s}%s", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divAbbreviation]), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}Количество рангов: \t{555555}%d", DivisionInfo[g][i][divRanks]), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}Названия рангов {%s}>>\t", DivisionInfo[g][i][divColorHex]), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}Доступные оружия {%s}>>\t", DivisionInfo[g][i][divColorHex]), strcat(lines,line);
		if(DivisionInfo[g][i][divSpawnPos][0] == 0.0) format(line,sizeof(line),"\n{cccccc}Спавн \t{FF6347}[Не установлен]"), strcat(lines,line);
		else format(line,sizeof(line),"\n{cccccc}Спавн \t{99ff66}[Установлен]"), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}Цвет: \t{%s}||||||||||", DivisionInfo[g][i][divColorHex]), strcat(lines,line);
		//format(line,sizeof(line),"\n{cccccc}1 Цвет транспорта \t{%s}|||||||||| {555555}[ ID %d ]", VehicleColoursTableHex[DivisionInfo[g][i][divColorVeh][0]], DivisionInfo[g][i][divColorVeh][0]), strcat(lines,line);
		//format(line,sizeof(line),"\n{cccccc}2 Цвет транспорта \t{%s}|||||||||| {555555}[ ID %d ]", VehicleColoursTableHex[DivisionInfo[g][i][divColorVeh][1]], DivisionInfo[g][i][divColorVeh][1]), strcat(lines,line);
		
		if(PlayerInfo[playerid][pDivision][0] != i+1) format(line,sizeof(line),"\n{99ff66}Войти в подфракцию >> \t"), strcat(lines,line);
		else format(line,sizeof(line),"\n{FF6347}Покинуть подфракцию >> \t"), strcat(lines,line);
	}

	new header[80];
    format(header,sizeof(header),"{ff9000}Подфракция {%s}%s", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);
	ShowDialog(playerid,_:DIVISION_SETTINGS,DIALOG_STYLE_TABLIST,header,lines,"Выбрать","Выход");
	return 1;
}

// Список участников подфракции
CMD:dmembers(playerid, const params[]) return pc_cmd_divmembers(playerid, params);
CMD:divmembers(playerid, const params[])
{
	if(fraction(playerid) <= 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");

	new i;
	if(!sscanf(params, "i", params[0]))
	{
		if(params[0] < 0 || params[0] >= MAX_DIVISION_ORG) return ErrorMessage(playerid, "{FF6347}Неверный ID подфракции");
		i = params[0];
	}
	else i = PlayerInfo[playerid][pDivision][0];
	if(i <= 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в подфракции");
    showDialogMembersDivision(playerid, fraction(playerid), i);
	return 1;
}
stock showDialogMembersDivision(playerid, org, div)
{
	new line[214],lines[4096];
	format(line,sizeof(line),"{cccccc}Имя\t{cccccc}Ранг\t{444444}AFK"), strcat(lines,line);

	new atext[10], btext[10], quan, rank, fineTime[24];
	new year, month, day;
	getdate(year, month, day);

	DP[1][playerid] = org-1;
	DP[2][playerid] = div-1;

	foreach(Player,i)
	{
		if(OnlineInfo[i][oLogged] == 1 
			&& (PlayerInfo[i][pMember] == org && PlayerInfo[i][pDivision][0] == div || org == 2 && PlayerInfo[i][pFbi] > 0 && PlayerInfo[i][pDivision][1] == div))
		{
			rank = PlayerInfo[i][pDivRank][0];
			if(rank <= 0) rank = 1;
			if (rank > MAX_RANK_ORG) rank = MAX_RANK_ORG;

			// Получаем информацию о рации (Включена или нет)
			if(PlayerInfo[i][pTransmitterOff][2]) atext = "{FF6347}*";
			else atext = "{00ff66}*";

			// Получаем информацию о главе подфракции
			if(PlayerInfo[i][pFbi] == 0)
			{
				if(rank >= DivisionInfo[org-1][div-1][divRanks]) format(btext,sizeof(btext),"%s", DivisionInfo[org-1][div-1][divColorHex]);
				else btext = "cccccc";
			}

			// Получаем информацию о FBI под прикрытием
			if(org == 2)
			{
				if(PlayerInfo[i][pFbi] > 0)
				{
					btext = "333333";
					rank = PlayerInfo[i][pFbi];
				}
			}

			// Записываем инфу об AFK
			if(GetPVarInt(i,"afksystem") > 8) format(fineTime,sizeof(fineTime),"%s", fine_time(GetPVarInt(i,"afksystem")));
			else format(fineTime,sizeof(fineTime),"");

			if(org == 8) // ICA
			{
				if(PlayerInfo[playerid][pRank] >= OrganInfo[8][gAcc][40]) format(line,sizeof(line),"\n%s {%s}%s %s{cccccc}\t%s [%d]\t{444444}%s", atext, btext, PlayerInfo[i][pName], PlayerInfo[i][pCallSign], DivisionRankName[org-1][div-1][rank-1], rank, fineTime), strcat(lines,line);
				else format(line,sizeof(line),"\n%s {%s}%s{cccccc}\t%s [%d]\t{444444}%s", atext, btext, getPlayerNameTransmitter(i), DivisionRankName[org-1][div-1][rank-1], rank, fineTime), strcat(lines,line);
			}
			else format(line,sizeof(line),"\n%s {%s}%s{cccccc}\t%s [%d]\t{444444}%s", atext, btext, getPlayerNameTransmitter(i), DivisionRankName[org-1][div-1][rank-1], rank, fineTime), strcat(lines,line);
			quan ++;
		}
	}

	new header[140];
	format(header,sizeof(header),"{cccccc}Участники {%s}%s {99ff66}Online: %d {ff9000}[%02d.%02d.%d]", DivisionInfo[org-1][div-1][divColorHex], DivisionInfo[org-1][div-1][divName], quan ,day, month, year);
   	ShowDialog(playerid,_:DIVISION_MEMBERS,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"*","");
	return 1;
}
stock divmembersoff(playerid)
{
	if(AntiFloodMysqlRequest(playerid, 10)) return 1;
	ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Участники Подфракции {ff0000}Offline","{cccccc}Поиск участников...","*","");

	new org = DP[1][playerid] + 1; // Получаем id организации
	new div = DP[2][playerid] + 1; // Получаем id подфракции

	DP[4][playerid] = 0;
	DP[5][playerid] = 0;

	new string_mysql[400];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT user_id, Name, Member, Rank, pDivRank0, pDivRank1, Fbi, Offtime, CallSign FROM `pp_igroki` WHERE \
		`Division0` = '%d' AND `Member`='%d' AND `Online` = '0' \
		OR `Division1` = '%d' AND `Fbi` > '0' AND `Online` = '0' LIMIT 40", div, org, div);
	mysql_tquery(pearsq, string_mysql, "call_membersdiv", "ddd", playerid, org, div);
	return 1;
}
function call_membersdiv(playerid, org, div)
{
	if (org < 1 || div < 1) return ErrorMessage(playerid, "{ff6347}Ошибка при получении информации об участниках");

	new year, month, day, rows;
	getdate(year, month, day);
	cache_get_row_count(rows);

	new playerLoad[6], playerName[24], rank, offTime[24], signName[24], btext[9];
	new line[214],lines[4096];
	format(line,sizeof(line),"{cccccc}Имя\t{cccccc}Ранг\t{444444}Последняя Активность"), strcat(lines,line);
	
	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name(i, "Name", playerName, 24);
		cache_get_value_name_int(i, "pDivRank0", playerLoad[0]);
		cache_get_value_name_int(i, "Fbi", playerLoad[1]);
		cache_get_value_name_int(i, "Member", playerLoad[2]);
		cache_get_value_name_int(i, "user_id", playerLoad[3]);
		cache_get_value_name(i, "Offtime", offTime, 24);
		cache_get_value_name(i, "CallSign", signName, 24);

		rank = playerLoad[0];

		// Получаем информацию о главе подфракции
		if(playerLoad[1] == 0)
		{
			if(playerLoad[0] >= DivisionInfo[org-1][div-1][divRanks]) format(btext,sizeof(btext),"%s", DivisionInfo[org-1][div-1][divColorHex]);
			else btext = "cccccc";
		}

		// Получаем информацию о FBI под прикрытием
		if(org == 2)
		{
			if(playerLoad[1] > 0)
			{
				btext = "333333";
				cache_get_value_name_int(i, "pDivRank1", rank);
			}
		}

		if (rank < 1) continue;

		if(org == 8) // ICA
		{
			if(PlayerInfo[playerid][pRank] >= OrganInfo[8][gAcc][40]) format(line,sizeof(line),"\n{%s}%s %s{cccccc}\t%s [%d]\t{444444}%s", btext, playerName, signName, DivisionRankName[org-1][div-1][rank-1], rank, offTime), strcat(lines,line);
			else format(line,sizeof(line),"\n{%s}%s{cccccc}\t%s [%d]\t{444444}%s", btext, signName, DivisionRankName[org-1][div-1][rank-1], rank, offTime), strcat(lines,line);
		}
		else format(line,sizeof(line),"\n{%s}%s{cccccc}\t%s [%d]\t{444444}%s", btext, playerName, DivisionRankName[org-1][div-1][rank-1], rank, offTime), strcat(lines,line);

		DP[4][playerid] = playerLoad[3];
	}

	if(rows > 0)
	{
		new header[140];
		DP[5][playerid] ++;
		format(header,sizeof(header),"{cccccc}Участники {%s}%s {FF6347}Offline: %d {ff9000}[%02d.%02d.%d] Страница %d", DivisionInfo[org-1][div-1][divColorHex], DivisionInfo[org-1][div-1][divName], rows , day, month, year, DP[5][playerid]);

		if(rows >= 40) ShowDialog(playerid,_:DIVISION_MEMBERS_LIST,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Далее","");
		else ShowDialog(playerid,_:DIVISION_MEMBERS,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"*","");
	}
    else if(rows == 0) ShowDialog(playerid,_:DIVISION_MEMBERS,DIALOG_STYLE_MSGBOX,"{ff9000}Участники Подфракции","{cccccc}Участники Offline в подфракции не найдены","*","");
	return 1;
}

alias:giverankdiv("giverankd", "divrank", "divrang")
CMD:giverankdiv(playerid, const params[])
{
	DivisionGiveRank(playerid, params);
	return true;
}

stock DivisionGiveRank(playerid, const params[], i = -1)
{	
	if(PlayerInfo[playerid][pGoogle] == 0 && server != 0) return ErrorMessage(playerid, "{FF6347}У вас не привязан Google Authenticator [ Y >> Меню >> Аккаунт ]");
	new g = fraction(playerid);
	if(i == -1) i = PlayerInfo[playerid][pDivision][0] - 1;

	if(g == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");
	if(i < 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в подфракции");

	if(PlayerInfo[playerid][pLeader] > 0 
	|| PlayerInfo[playerid][pMember] > 0 && PlayerInfo[playerid][pRank] >= get_maxrank(g)-1
	|| PlayerInfo[playerid][pDivision][0] == i+1 && PlayerInfo[playerid][pDivRank][0] >= DivisionInfo[g - 1][i][divRanks])
	{
		new playerName[24], giveplayerid, rank;
		if(sscanf(params, "s[24]i", playerName, rank)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить ранг игрока в подфракции [ /divrank ID Ранг ]");

		giveplayerid = ReturnUser(playerName);
		if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока нет на сервере");
		if(g != fraction(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Этот игрок не состоит в вашей организации");
		if(PlayerInfo[giveplayerid][pDivision][0] - 1 != i) return ErrorMessage(playerid, "{FF6347}Этот игрок не состоит в вашей подфракции");
		if(rank < 0 || rank > DivisionInfo[g - 1][i][divRanks]) return ErrorMessage(playerid, "{ff6347}Некорректный номер ранга");

		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы изменили ранг %s на %d", getPlayerNameTransmitter(giveplayerid), rank);
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "* %s изменил ваш ранг в подфракции на %d", getPlayerNameTransmitter(playerid), rank);

		PlayerInfo[giveplayerid][pDivRank][0] = rank;
		mysql_SaveDivision(PlayerInfo[giveplayerid][pID], 0, PlayerInfo[giveplayerid][pDivision][0], PlayerInfo[giveplayerid][pDivRank][0]);

		new string[84];
		format(string, sizeof(string), "Изменил ранг в %s на %d", DivisionInfo[g - 1][i][divAbbreviation], rank);
		OrgLog(g, "giverankdiv", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], i + 1, string);
	}
	else ErrorMessage(playerid, "{FF6347}Доступно только для главы подфракции");
	return true;
}

alias:divinvite("divin")
CMD:divinvite(playerid, const params[])
{
	DivisionInvite(playerid, params);
	return true;
}

stock DivisionInvite(playerid, const params[], i = -1)
{	
	if(PlayerInfo[playerid][pGoogle] == 0 && server != 0) return ErrorMessage(playerid, "{FF6347}У вас не привязан Google Authenticator [ Y >> Меню >> Аккаунт ]");
	new g = fraction(playerid);
	if(i == -1) i = PlayerInfo[playerid][pDivision][0] - 1;

	if(g == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");
	if(i < 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в подфракции");
	if(PlayerInfo[playerid][pDivRank][0] < DivisionInfo[g-1][i][divRanks]
		&& PlayerInfo[playerid][pLeader] == 0) return ErrorMessage(playerid, "{FF6347}Доступно только для главы подфракции");

	if(PlayerInfo[playerid][pLeader] > 0 
	|| PlayerInfo[playerid][pMember] > 0 && PlayerInfo[playerid][pRank] >= get_maxrank(g)-1
	|| PlayerInfo[playerid][pDivision][0] == i+1 && PlayerInfo[playerid][pDivRank][0] >= DivisionInfo[g - 1][i][divRanks])
	{
		new playerName[24], giveplayerid;
		if(sscanf(params, "s[24]", playerName)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Пригласить игрока в подфракцию [ /divinvite ID ]");

		giveplayerid = ReturnUser(playerName);
		if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока нет на сервере");
		if(!ProxDetectorS(2.0, playerid, giveplayerid) || GetPlayerState(giveplayerid) == PLAYER_STATE_SPECTATING) return ErrorMessage(playerid, "{FF6347}Вы слишком далеко от игрока");
		if(PlayerInfo[giveplayerid][pDivision][0] > 0) return ErrorMessage(playerid, "{FF6347}Игрок уже находится в подфракции");
		if(g != fraction(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Этот игрок не состоит в вашей организации");

		new string[120];
		// Записываем чела, которого приглашаем
		format(string, sizeof(string), "* Вы отправили приглашение %s на вступление в %s", getPlayerNameTransmitter(giveplayerid), DivisionInfo[g - 1][i][divName]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		PlayerPlaySound(playerid,40405,0,0,0);

		// Записываем этому челу инфу, куда приглашаем и кто приглашает
		DP[0][giveplayerid] = i + 1;
		DP[7][giveplayerid] = playerid;
		format(string, sizeof(string), "{ffcc66}%s{33CCFF}, приглашает вас в %s\n\n{33CCFF}Вы согласны?", getPlayerNameTransmitter(playerid), DivisionInfo[g - 1][i][divName]);
		ShowDialog(giveplayerid,_:DIVISION_INVITE,DIALOG_STYLE_MSGBOX,"{ff9000}Приглашение",string,"Да","Нет");
		PlayerPlaySound(giveplayerid,40405,0,0,0);

		OrgLog(g, "divin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], i + 1, DivisionInfo[g - 1][i][divName]);
	}
	else ErrorMessage(playerid, "{FF6347}Доступно только для главы подфракции");
	return true;
}

alias:divuninvite("divun", "divkick")
CMD:divuninvite(playerid, const params[])
{
	DivisionUninvite(playerid, params);
	return 1;
}

stock DivisionUninvite(playerid, const params[], i = -1)
{	
	if(PlayerInfo[playerid][pGoogle] == 0 && server != 0) return ErrorMessage(playerid, "{FF6347}У вас не привязан Google Authenticator [ Y >> Меню >> Аккаунт ]");
	new g = fraction(playerid);
	if(i == -1) i = PlayerInfo[playerid][pDivision][0] - 1;

	if(g == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");
	if(i < 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в подфракции");

	if(PlayerInfo[playerid][pLeader] > 0 
	|| PlayerInfo[playerid][pMember] > 0 && PlayerInfo[playerid][pRank] >= get_maxrank(g)-1
	|| PlayerInfo[playerid][pDivision][0] == i+1 && PlayerInfo[playerid][pDivRank][0] >= DivisionInfo[g - 1][i][divRanks])
	{
		new playerName[24], giveplayerid, reason[24];
		if(sscanf(params, "s[24]s[24]", playerName, reason)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Исключить участника из подфракции [ /divuninvite ID Причина ]");

		if(strlen(playerName) > 24 || strlen(playerName) < 1) return ErrorText(playerid, "[ Мысли ]: Имя не меньше 1 и не больше 24 символов");
		if(strlen(reason) > 24 || strlen(reason) < 1) return ErrorText(playerid, "[ Мысли ]: Причина не меньше 1 и не больше 24 символов");
		if(checksimvol(reason)) return ErrorMessage(playerid, "{FF6347}Вы используете запрещённый символ\n{cccccc}Используйте, буквы и цифры");

		giveplayerid = ReturnUser(playerName);
		if(IsPlayerConnected(giveplayerid))
		{
			if(OnlineInfo[giveplayerid][oLogged] == 0) return ErrorMessage(playerid, "{FF6347}Игрок не залогинился");
			if(PlayerInfo[giveplayerid][pDivision][0] != i && PlayerInfo[giveplayerid][pDivision][1] != i) return ErrorMessage(playerid, "{FF6347}Игрок не состоит в вашей подфракции");
			if(g == 2)
			{
				if(fraction(giveplayerid) != 2 && PlayerInfo[giveplayerid][pFbi] == 0) return ErrorMessage(playerid, "{FF6347}Этот игрок не состоит в вашей организации");
			}
			else 
			{
				if(fraction(giveplayerid) != g) return ErrorMessage(playerid, "{FF6347}Этот игрок не состоит в вашей организации");
			}

			new string[120];
			PlayerPlaySound(playerid, 6801, 0, 0, 0); // Отказ
			format(string, sizeof(string), "* Вы исключили %s из %s по причине: %s", getPlayerNameTransmitter(giveplayerid), DivisionInfo[g - 1][i][divName], reason);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, string);

			PlayerPlaySound(giveplayerid, 6801, 0, 0, 0); // Отказ
			format(string, sizeof(string), "* %s исключает вас из %s по причине: %s", getPlayerNameTransmitter(playerid), DivisionInfo[g - 1][i][divName], reason);
			SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);

			// Исключаем
			uninviteDivision(giveplayerid, g);

			OrgLog(g, "divkick", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], i + 1, reason);
		}
		else
		{
			if(!CheckRP_Nickname(playerName)) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети [ Используйте никнейм, чтобы уволить Offline ]");

			new string_mysql[180];
			ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}*","{cccccc}Поиск игрока...","*","");
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT user_id, Member, Leader, Fbi, Division0, Division1 FROM `pp_igroki` WHERE `Name` = '%e'", playerName);
			mysql_tquery(pearsq, string_mysql, "call_divuninvite", "dddssd", playerid, g - 1, i, playerName, reason, g_MysqlRaceCheck[playerid]);
		}
	}
	else ErrorMessage(playerid, "{FF6347}Доступно только для главы подфракции");
	return true;
}


function call_divuninvite(playerid, g, i, const str_name[], const reason[], race_check) // Offline исключение из подфракции
{
	if(!IsOnline(playerid)) return 0; // Если тот, кто посылал запрос вышел из игры

	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid); // Защита от супермедленного ответа

		// Грузим необходимую информацию об игроке
		new playerLoad[6];
		cache_get_value_name_int(0, "Division0", playerLoad[0]);
		cache_get_value_name_int(0, "Division1", playerLoad[1]);
		cache_get_value_name_int(0, "Member", playerLoad[2]);
		cache_get_value_name_int(0, "Leader", playerLoad[3]);
		cache_get_value_name_int(0, "Fbi", playerLoad[4]);
		cache_get_value_name_int(0, "user_id", playerLoad[5]);

		if(playerLoad[0] != i && playerLoad[1] != i) return ErrorMessage(playerid, "{FF6347}Игрок не состоит в вашей подфракции");
		if(g == 2)
		{
			if(playerLoad[2] != 2 && playerLoad[3] != 2 && playerLoad[4] == 0) return ErrorMessage(playerid, "{FF6347}Этот игрок не состоит в вашей организации");
		}
		else
		{
			if(playerLoad[2] != g && playerLoad[3] != g) return ErrorMessage(playerid, "{FF6347}Этот игрок не состоит в вашей организации");
		}

		new whichDiv, outOrg;
		if(playerLoad[3] > 0) outOrg = playerLoad[3];
		else outOrg = playerLoad[2];
		uninviteDivisionKey(outOrg, playerLoad[4], whichDiv); // Ищем, какую подфракцию будем очищать
		mysql_SaveDivision(playerLoad[5], whichDiv, 0, 0); // Сохраняем в базу

		PlayerPlaySound(playerid, 6801, 0, 0, 0); // Отказ
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Вы исключили %s из %s по причине: %s", str_name, DivisionInfo[g - 1][i - 1][divName], reason);

		OrgLog(g, "divkick", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], playerLoad[5], str_name, "", i + 1, reason);
	}
	else ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
	return 1;
}
stock uninviteDivision(playerid, outOrg) // Исключаем из подфракции Online
{
	new whichDiv;
	uninviteDivisionKey(outOrg, PlayerInfo[playerid][pFbi], whichDiv); // Ищем, какую подфракцию будем очищать
	PlayerInfo[playerid][pDivision][whichDiv] = 0; // Очищаем
	PlayerInfo[playerid][pDivRank][whichDiv] = 0; // Очищаем
	CheckAndRemoveSniperRifle(playerid);
	mysql_SaveDivision(PlayerInfo[playerid][pID], whichDiv, 0, 0); // Сохраняем в базу

	new getOrg, getDiv, getReadRac;
	resetTransmitterDivisionKey(PlayerInfo[playerid][pDivision][0], fraction(playerid), getOrg, getDiv, getReadRac); // Ищем, какую рацию нужно выключать
	racDivisionSetting(playerid, getOrg, getDiv, getReadRac); // Переключаем
	return 1;
}
stock uninviteDivisionKey(outOrg, fbi, &whichDiv) // Получаем информацию об исключении из подфракции
{
	if(outOrg == 2 && fbi > 0) whichDiv = 1; // Если чел под прикрытие и увольняют из FBI
	else whichDiv = 0;
	return 1;
}
stock mysql_SaveDivision(str_id, whichDiv, value, rank)
{
	new string_mysql[100];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `pp_igroki` SET `Division%d` = '%d', `pDivRank%d` = '%d' WHERE `user_id` = '%d'", 
		whichDiv, value, whichDiv, rank, str_id);
	query_empty(pearsq, string_mysql);
	return 1;
}

CMD:dleave(playerid) return pc_cmd_divleave(playerid);
CMD:divleave(playerid)
{
	new g = fraction(playerid);
	new i = PlayerInfo[playerid][pDivision][0] - 1;
	if(i < 0 || g == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в подфракции");
	g -= 1;

   	PlayerPlaySound(playerid,40405,0,0,0);
   	DP[5][playerid] = 0; // Сбрасываем счетчик уточнений

	DP[1][playerid] = g; // Записываем id организации
	DP[2][playerid] = i; // Записываем id подфракции

	new string[140];
   	format(string, sizeof(string), "{cccccc}Вы уверены, что хотите покинуть {%s}%s{cccccc}?", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);
	ShowDialog(playerid,_:DIVISION_LEAVE,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция",string,"Да","Нет");
	return 1;
}

stock SetDivisionAvailableWeapon(g, i, weaponid, bool: status) {
	if(i < 0 || g < 0) return 1;
	DivisionInfo[g][i][divAvailableWeapons][weaponid] = status;

	return 1;
}

stock DivisionIsAvailableWeapon(g, i, weaponid) {
	g--;
	if(i < 0 || g < 0) return 0;
	return DivisionInfo[g][i][divAvailableWeapons][weaponid];
}

stock showDialogSettingDivisionWeapons(playerid, g, i) { // Меню настройки оружий доступных для взятия со склада для подфракции
	if(i < 0 || g < 0) return 1;
	if (!IsAFunctionOrganization(1, g + 1, playerid)) return ErrorText(playerid, "Ваша организация не может заказывать оружие на склад");
	
	new dialog_header[128];
	format(dialog_header, sizeof(dialog_header), "{ff9000}Доступное оружие {%s}%s", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);

	DP[1][playerid] = g;
	DP[2][playerid] = i;

	new dialog_text[256], quan;

	for (new weaponid = 0; weaponid < 38; weaponid++) {
		if (!IsDefaultOrderDepartWeapon(weaponid)) continue;

		format(dialog_text, sizeof(dialog_text), "%s\n{%s}%s", dialog_text, DivisionInfo[g][i][divAvailableWeapons][weaponid] ? "99ff66" : "ff6347", GetNameThing(0, weaponid, 1, 0));

		List[quan][playerid] = weaponid;
		quan++;
	}

	ShowDialog(playerid, _:DIVISION_ORDER_WEAPONS, DIALOG_STYLE_LIST, dialog_header, dialog_text, "Выбрать", "Назад");
	
	return 1;
}

stock showDialogSettingDivisionRank(playerid) // Меню настройки названий рангов в подфракции
{
	new g = DP[1][playerid]; // Получаем id организации
	new i = DP[2][playerid]; // Получаем id подфракции

	if(DivisionInfo[g][i][divRanks] <= 0) return ErrorText(playerid, "{cccccc}[ Мысли ]: Мне нужно указать количество рангов, прежде чем редактировать названия"), showDialogMenuDivision(playerid);

	new line[130],lines[4096];
    format(line,sizeof(line),"Названия рангов"), strcat(lines,line);
    for(new r = 0; r < DivisionInfo[g][i][divRanks]; r++)
	{
		if(r == DivisionInfo[g][i][divRanks]-1) format(line,sizeof(line),"\n{ff9000}%d. %s", r+1, DivisionRankName[g][i][r]), strcat(lines,line); // Ранг руководителя подфракции
		else format(line,sizeof(line),"\n{ff9000}%d. {cccccc}%s", r+1, DivisionRankName[g][i][r]), strcat(lines,line); // Прочие ранги
	}
	ShowDialog(playerid,_:DIVISION_RANK_SETNAME,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Подфракция",lines,"Выбрать","Выход");
	return 1;
}

stock showDialogInfoDivision(playerid)
{
	new line[50],lines[350];

	format(line,sizeof(line),"Команды:"), strcat(lines,line);
	format(line,sizeof(line),"\n/div - меню подфракции"), strcat(lines,line);
	format(line,sizeof(line),"\n/dmembers - участники online"), strcat(lines,line);
	format(line,sizeof(line),"\n/dleave - покинуть подфракцию"), strcat(lines,line);
	format(line,sizeof(line),"\n/divin - пригласить"), strcat(lines,line);
	format(line,sizeof(line),"\n/divun - исключить"), strcat(lines,line);
	format(line,sizeof(line),"\n/divrank - изменить ранг в подфракции"), strcat(lines,line);
	format(line,sizeof(line),"\n/i /ib - канал рации"), strcat(lines,line);
	ShowDialog(playerid,_:DIVISION_MEMBERS,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция",lines,"*","");
	return 1;
}

stock dialogCase_Division(playerid, dialogid, response, listitem, const inputtext[])
{
	if(dialogid == _:DIVISION_MENU) // Меню списка подфракций
	{
		if(response)
		{
			if(listitem < 0 || listitem >= MAX_DIVISION_ORG) return 0;
			DP[2][playerid] = listitem; // Сохраняем id выбранной подфракции

			DP[6][playerid] = -228;
			showDialogMenuDivision(playerid);
		}
		else showDialogOrganizationMenu(playerid);
	}
	if(dialogid == _:DIVISION_SETTINGS) // Меню настройки подфракции
	{
		if(response)
		{
			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции

			if(listitem == 0) return showDialogInfoDivision(playerid);

			new string[160];
			if(listitem == 1) 
			{
				format(string,sizeof(string),"%d", i + 1);
				pc_cmd_divmembers(playerid, string);
			}
			if(listitem == 2) divmembersoff(playerid);
			if(listitem == 3)
			{
				ShowDialog(playerid,_:DIVISION_INVITE_SAVE,DIALOG_STYLE_INPUT,"{ff9000}Подфракция","{cccccc}Введите {ff9000}id или Никнейм {cccccc}игрока, чтобы {99ff66}пригласить {cccccc}его в подфракцию","Принять","Отмена");
			}
			if(listitem == 4)
			{
				ShowDialog(playerid,_:DIVISION_UNINVITE_SAVE,DIALOG_STYLE_INPUT,"{ff9000}Подфракция","{cccccc}Введите {ff9000}id или Никнейм {cccccc}игрока, чтобы {FF6347}исключить {cccccc}его из подфракции","Принять","Отмена");
			}

			if(listitem >= 5)
			{
				if(DP[3][playerid] == 0) return 0; // Блокируем другие листы, если нет доступа (не отрисованный listitem могут вызвать внешними скриптами)
			}
			if(listitem == 5) // Название
			{
				format(string,sizeof(string),"{cccccc}Введите название подфракции [1 - %d символов]", MAX_NAME_LENGTH-1);
				ShowDialog(playerid,_:DIVISION_SETNAME,DIALOG_STYLE_INPUT,"{ff9000}Подфракция",string,"Принять","Отмена");
			}
			if(listitem == 6) // Абреввиатура
			{
				format(string,sizeof(string),"{cccccc}Введите аббревиатуру подфракции [1 - %d символов]\n\n{555555}Она будет отображаться в /r, /d, /i чатах. Пример: [ABC]", MAX_NAME_DIVISION_ABBREVIATION_LENGTH-1);
				ShowDialog(playerid,_:DIVISION_ABBREVIATION,DIALOG_STYLE_INPUT,"{ff9000}Подфракция",string,"Принять","Отмена");
			}
			if(listitem == 7) // Количество рангов
			{
				format(string,sizeof(string),"{cccccc}Введите количество рангов в подфракции [2 - %d рангов]\n\n{FF6347}Внимание! Максимальный ранг будет являться главой подфракции", get_maxrank(g+1));
				ShowDialog(playerid,_:DIVISION_RANK_AMOUNT,DIALOG_STYLE_INPUT,"{ff9000}Подфракция",string,"Принять","Отмена");
			}
			if(listitem == 8) showDialogSettingDivisionRank(playerid); // Названия рангов
			if(listitem == 9) { // Доступное оружие
				showDialogSettingDivisionWeapons(playerid, g, i);
			}
			if(listitem == 10) // Спавн
			{
				ShowDialog(playerid,_:DIVISION_SPAWN,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция","{cccccc}Вы уверены, что хотите установить {ff9000}эту позицию {cccccc}в качестве спавна участников подфракции?\n\n{FF6347}Внимание! Учитывайте, в какую сторону повёрнут ваш персонаж лицом, в данный момент","Да","Нет");
			}
			if(listitem == 11) // Цвет
			{
				ShowDialog(playerid,_:DIVISION_SETCOLOR,DIALOG_STYLE_INPUT,"{ff9000}Подфракция","{cccccc}Введите Hex код цвета подфракции [6 Символов]\nПример: ff9000","Принять","Отмена");
			}
			/*if(listitem == 12) // Цвет Транспорта 1
			{
				DP[4][playerid] = 0; // слот цвета транспорта
				ShowDialog(playerid,_:DIVISION_SETVEHCOLOR,DIALOG_STYLE_INPUT,"{ff9000}Подфракция","{cccccc}Введите id цвета транспорта [0 - 255]\n\nПосмотреть, как выглядят цвета транспорта, можно на форуме сервера pears-project.com","Принять","Отмена");
			}
			if(listitem == 13) // Цвет Транспорта 2
			{
				DP[4][playerid] = 1; // слот цвета транспорта
				ShowDialog(playerid,_:DIVISION_SETVEHCOLOR,DIALOG_STYLE_INPUT,"{ff9000}Подфракция","{cccccc}Введите id цвета транспорта [0 - 255]\n\nПосмотреть, как выглядят цвета транспорта, можно на форуме сервера pears-project.com","Принять","Отмена");
			}*/
			if(listitem == 12) // Войти в подфракцию
			{
				if(PlayerInfo[playerid][pDivision][0] == i + 1) return pc_cmd_divleave(playerid);

				PlayerInfo[playerid][pDivision][0] = i + 1;
				PlayerInfo[playerid][pDivRank][0] = DivisionInfo[g][i][divRanks];
				mysql_SaveDivision(PlayerInfo[playerid][pID], 0, PlayerInfo[playerid][pDivision][0], PlayerInfo[playerid][pDivRank][0]); // Сохраняем в базу

				// Включаем отображение рации /i
				if(PlayerInfo[playerid][pTransmitterOff][2] == true) PlayerInfo[playerid][pTransmitterOff][2] = false, PlayerInfo[playerid][pTransmitterUpdate] = true;

				// Включаем рацию в доступ
				racDivisionSetting(playerid, fraction(playerid), PlayerInfo[playerid][pDivision][0] , 1);

				format(string, sizeof(string), "[ Мысли ]: Теперь я нахожусь в подфракции %s {ff9000}[ /div ]", DivisionInfo[g][i][divName]);
				SendClientMessage(playerid, COLOR_GREY, string);

				showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			}
		}
		else
		{
			if(PlayerInfo[playerid][pLeader] > 0 && DP[6][playerid] == -228) showDialogAllDivisions(playerid);
		}
	}
	if(dialogid == _:DIVISION_SETNAME) // Название
	{
		if(response)
		{
			if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);
			new string[100];
          	if(strlen(inputtext) < 1 || strlen(inputtext) >= MAX_NAME_LENGTH) return format(string,sizeof(string),"[ Мысли ]: Не меньше 1 и не больше %d символов", MAX_NAME_LENGTH-1), ErrorText(playerid, string), showDialogMenuDivision(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogMenuDivision(playerid);

			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции

			format(DivisionInfo[g][i][divName], MAX_NAME_LENGTH, "%s", inputtext);

			format(string, sizeof(string), "** [%s] Руководитель %s изменил%s название подфракции: %s.", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid), inputtext);
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, string);
			format(string, sizeof(string), "[ Мысли ]: Я изменил%s название подфракции: %s", gender(playerid), inputtext);
			SendClientMessage(playerid, COLOR_GREY, string);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			DivisionSave(g, i); // Сохраняем

			OrgLog(g + 1, "divName", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, inputtext);
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == _:DIVISION_ABBREVIATION) // Аббревиатура
	{
		if(response)
		{
			if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);

			new string[100];
          	if(strlen(inputtext) < 1 || strlen(inputtext) >= MAX_NAME_DIVISION_ABBREVIATION_LENGTH) return format(string,sizeof(string),"[ Мысли ]: Не меньше 1 и не больше %d символов", MAX_NAME_DIVISION_ABBREVIATION_LENGTH-1), ErrorText(playerid, string), showDialogMenuDivision(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogMenuDivision(playerid);

			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции

			format(DivisionInfo[g][i][divAbbreviation], MAX_NAME_DIVISION_ABBREVIATION_LENGTH, "%s", inputtext);

			format(string, sizeof(string), "** [%s] Руководитель %s изменил%s аббревиатуру подфракции: %s.", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid), inputtext);
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, string);
			format(string, sizeof(string), "[ Мысли ]: Я изменил%s аббревиатуру подфракции: %s", gender(playerid), inputtext);
			SendClientMessage(playerid, COLOR_GREY, string);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			DivisionSave(g, i); // Сохраняем

			OrgLog(g + 1, "divAbbr", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, inputtext);
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == _:DIVISION_RANK_AMOUNT) // Количество рангов
	{
		if(response)
		{
			new input;
			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции

			if(sscanf(inputtext, "i", input)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);

			new string[100];
			if(input > get_maxrank(g+1) || input < 2) return format(string,sizeof(string),"[ Мысли ]: Не меньше 2 и не больше %d рангов", get_maxrank(g+1)), ErrorText(playerid, string), showDialogMenuDivision(playerid);

			if(DivisionInfo[g][i][divRanks] == input) return ErrorText(playerid, "[ Мысли ]: Это количество рангов уже указано"), showDialogMenuDivision(playerid);
			DivisionInfo[g][i][divRanks] = input;

			format(string, sizeof(string), "** [%s] Руководитель %s изменил%s количество рангов: %d.", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid), input);
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, string);
			format(string, sizeof(string), "[ Мысли ]: Я изменил%s количество рангов в подфракции: %d", gender(playerid), input);
			SendClientMessage(playerid, COLOR_GREY, string);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			DivisionSave(g, i); // Сохраняем

			format(string,sizeof(string),"%d Рангов", input);
			OrgLog(g + 1, "divRanks", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, string);
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == _:DIVISION_RANK_SETNAME) // Названия рангов
	{
		if(response)
		{
			if(listitem < 0 || listitem >= MAX_RANK_ORG) return 0;
			DP[3][playerid] = listitem; // Сохраняем id выбранного ранга

			new string[90];
			format(string,sizeof(string),"{cccccc}Введите название %d ранга [1 - %d символов]", listitem + 1, MAX_NAME_LENGTH-1);
			ShowDialog(playerid,_:DIVISION_RANK_SETNAME_SAVE,DIALOG_STYLE_INPUT,"{ff9000}Подфракция",string,"Принять","Отмена");
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == _:DIVISION_RANK_SETNAME_SAVE) // Название рангов
	{
		if(response)
		{
			if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogSettingDivisionRank(playerid);

			new string[100];
          	if(strlen(inputtext) < 1 || strlen(inputtext) >= MAX_NAME_LENGTH) return format(string,sizeof(string),"[ Мысли ]: Не меньше 1 и не больше %d символов", MAX_NAME_LENGTH-1), ErrorText(playerid, string), showDialogSettingDivisionRank(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogSettingDivisionRank(playerid);

			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции
			new r = DP[3][playerid]; // Получаем id ранга

			format(DivisionRankName[g][i][r], MAX_NAME_LENGTH, "%s", inputtext);

			format(string, sizeof(string), "** [%s] Руководитель %s изменил%s название %d ранга: %s.", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid), r + 1, inputtext);
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, string);
			format(string, sizeof(string), "[ Мысли ]: Я изменил%s название %d ранга: %s", gender(playerid), r + 1, inputtext);
			SendClientMessage(playerid, COLOR_GREY, string);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogSettingDivisionRank(playerid); // Открываем меню настройки подфракции
			DivisionSaveRankName(g, i, r); // Сохраняем

			format(string,sizeof(string),"%d. %s", r + 1, inputtext);
			OrgLog(g + 1, "divRankName", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, string);
		}
		else showDialogSettingDivisionRank(playerid);
	}
	if(dialogid == _:DIVISION_SPAWN) // Спавн
	{
		if(response)
		{
			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции

			if(IsPlayerInSquare(playerid,-1739.7145, -103.8218,-1694.4082,-27.3040) 
			|| IsPlayerInSquare(playerid,2401.7756,-2641.1243,2447.0828,-2564.6064)) return ErrorText(playerid, "[ Мысли ]: Это место недоступно [ Ангар мафии ]"), showDialogMenuDivision(playerid);
            if((IsPlayerInSquare(playerid,61.6997,1731.2677,426.7695,2141.7856) || IsPlayerInSquare(playerid,-1562.9559,259.8604,-1211.1649,501.0728)) && Protect_Z[playerid] >= -30.0 && Protect_Z[playerid] <= 40.0
			|| GetPlayerInterior(playerid) == 241 && GetPlayerVirtualWorld(playerid) == 241 
			|| GetPlayerInterior(playerid) == 242 && GetPlayerVirtualWorld(playerid) == 242) return ErrorText(playerid, "[ Мысли ]: Это место недоступно [ Территория NGSA ]"), showDialogMenuDivision(playerid);
			if(MPGO[playerid] != 0) return ErrorText(playerid, "[ Мысли ]: Я на мероприятии"), showDialogMenuDivision(playerid);
			if(IsAGangCapt(playerid))
			{
				if(CaptInfo[cCaptStat] == true) return ErrorText(playerid, "[ Мысли ]: Не могу изменить во время капта"), showDialogMenuDivision(playerid);
			}

			GetPlayerPos(playerid, DivisionInfo[g][i][divSpawnPos][0], DivisionInfo[g][i][divSpawnPos][1], DivisionInfo[g][i][divSpawnPos][2]);
		    GetPlayerFacingAngle(playerid, DivisionInfo[g][i][divSpawnPos][3]);
		    DivisionInfo[g][i][divSpawnInterior] = GetPlayerInterior(playerid);
		    DivisionInfo[g][i][divSpawnWorld] = GetPlayerVirtualWorld(playerid);

			new string[120];
			format(string, sizeof(string), "** [%s] Руководитель %s установил%s новый спавн.", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid));
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, string);
			format(string, sizeof(string), "[ Мысли ]: Я установил%s новый спавн для %s", gender(playerid), DivisionInfo[g][i][divName]);
			SendClientMessage(playerid, COLOR_GREY, string);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);

			showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			DivisionSave(g, i); // Сохраняем

			OrgLog(g + 1, "divSpawn", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, "");
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == _:DIVISION_SETCOLOR) // Цвет подфракции Hex
	{
		if(response)
		{
			if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);
          	if(strlen(inputtext) != 6) return ErrorText(playerid, "[ Мысли ]: Только 6 символов"), showDialogMenuDivision(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogMenuDivision(playerid);

			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции

			format(DivisionInfo[g][i][divColorHex], 7, "%s", inputtext);

			new string[120];
			format(string, sizeof(string), "** [%s] Руководитель %s изменил%s цвет {%s}%s.", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid), inputtext, DivisionInfo[g][i][divName]);
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, string);
			format(string, sizeof(string), "[ Мысли ]: Я изменил%s цвет подфракции {%s}%s", gender(playerid), inputtext, DivisionInfo[g][i][divName]);
			SendClientMessage(playerid, COLOR_GREY, string);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			DivisionSave(g, i); // Сохраняем

			OrgLog(g + 1, "divColorHex", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, inputtext);
		}
		else showDialogMenuDivision(playerid);
	}
	/*if(dialogid == _:DIVISION_SETVEHCOLOR) // Цвета транспорта
	{
		if(response)
		{
			new input;
			if(sscanf(inputtext, "i", input)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);

			new string[120];
			if(input > MAX_COLOR_VEHICLE || input < 0) return format(string,sizeof(string),"[ Мысли ]: Не меньше 0 и не больше %d", MAX_COLOR_VEHICLE), ErrorText(playerid, string), showDialogMenuDivision(playerid);

			new g = DP[1][playerid]; // Получаем id организации
			new i = DP[2][playerid]; // Получаем id подфракции
			new s = DP[4][playerid]; // Получаем слот цвета

			if(DivisionInfo[g][i][divColorVeh][s] == input) return ErrorText(playerid, "[ Мысли ]: Этот цвет уже указан"), showDialogMenuDivision(playerid);
			DivisionInfo[g][i][divColorVeh][s] = input;

			format(string, sizeof(string), "** [%s] Руководитель %s изменил%s цвет транспорта {%s}[ ID: %d ]", DivisionInfo[g][i][divAbbreviation], getPlayerNameTransmitter(playerid), gender(playerid), VehicleColoursTableHex[input], input);
			SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, string);
			format(string, sizeof(string), "[ Мысли ]: Я изменил%s цвет транспорта в подфракции {%s}[ ID: %d ]", gender(playerid), VehicleColoursTableHex[input], input);
			SendClientMessage(playerid, COLOR_GREY, string);
			PlayerPlaySound(playerid, 6401, 0, 0, 0);
			
			showDialogMenuDivision(playerid); // Открываем меню настройки подфракции
			DivisionSave(g, i); // Сохраняем

			format(string,sizeof(string),"ID: %d Slot: %d", input, s);
			OrgLog(g + 1, "divColorVeh", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, string);
		}
		else showDialogMenuDivision(playerid);
	}*/
	if(dialogid == _:DIVISION_LEAVE) // Покинуть подфракцию
	{
		if(response)
		{
			new goLeave;
			new g = fraction(playerid)-1;
			new i = PlayerInfo[playerid][pDivision][0]-1;
			if(PlayerInfo[playerid][pLeader] >= 1
			|| PlayerInfo[playerid][pMember] > 0 && PlayerInfo[playerid][pRank] >= get_maxrank(g + 1)-1) goLeave = 1;
			
			new string[120];
			if(goLeave == 1 || DP[5][playerid] == 4) // Да, увольняемся
			{
				uninviteDivision(playerid, 0);

				format(string,sizeof(string),"{99ff66}Готово! Вы покинули подфракцию %s", DivisionInfo[g][i][divName]);
				SuccessMessage(playerid, string);
				format(string, sizeof(string), "[ Мысли ]: Я покинул%s подфракцию %s", gender(playerid), DivisionInfo[g][i][divName]);
				SendClientMessage(playerid, COLOR_GREY, string);

				if(goLeave == 0) OrgLog(g + 1, "divleave", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i + 1, "");
				return 1;
			}

			if(DP[5][playerid] == 0)
			{
				DP[5][playerid] = 1;
   				format(string, sizeof(string), "{cccccc}Вы точно уверены, что хотите покинуть {%s}%s{cccccc}?", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);
				ShowDialog(playerid,_:DIVISION_LEAVE,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция",string,"Да","Нет");
			}
			else if(DP[5][playerid] == 1)
			{
				DP[5][playerid] = 2;
   				format(string, sizeof(string), "{cccccc}Вы точно точно точно уверены, что хотите покинуть {%s}%s{cccccc}?", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);
				ShowDialog(playerid,_:DIVISION_LEAVE,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция",string,"Да","Нет");
			}
			else if(DP[5][playerid] == 2)
			{
				DP[5][playerid] = 3;
   				format(string, sizeof(string), "{cccccc}Прям точнее точного хотите покинуть {%s}%s{cccccc}?", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);
				ShowDialog(playerid,_:DIVISION_LEAVE,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция",string,"Да","Нет");
			}
			else if(DP[5][playerid] == 3)
			{
				DP[5][playerid] = 4;
   				format(string, sizeof(string), "{cccccc}Всё всё... Последний раз, просто уточнить. Вы покидаете {%s}%s{cccccc}?", DivisionInfo[g][i][divColorHex], DivisionInfo[g][i][divName]);
				ShowDialog(playerid,_:DIVISION_LEAVE,DIALOG_STYLE_MSGBOX,"{ff9000}Подфракция",string,"Да","Нет");
			}
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == _:DIVISION_MEMBERS) showDialogMenuDivision(playerid); // divmembers или просто возвращаем меню
	if(dialogid == _:DIVISION_INVITE) // divinvite
	{
		new giveplayerid = DP[7][playerid];
		new g = fraction(playerid);
		new i = DP[0][playerid];
		if(g == 0) return 0;

		new string[120];
		if(response)
		{
			PlayerInfo[playerid][pDivision][0] = i;
			PlayerInfo[playerid][pDivRank][0] = 1;
			mysql_SaveDivision(PlayerInfo[playerid][pID], 0, PlayerInfo[playerid][pDivision][0], PlayerInfo[playerid][pDivRank][0]); // Сохраняем в базу

			// Включаем отображение рации /i
			if(PlayerInfo[playerid][pTransmitterOff][2] == true) PlayerInfo[playerid][pTransmitterOff][2] = false, PlayerInfo[playerid][pTransmitterUpdate] = true;

			// Включаем рацию в доступ
			racDivisionSetting(playerid, fraction(playerid), PlayerInfo[playerid][pDivision][0] , 1);

			format(string, sizeof(string), "[ Мысли ]: Теперь я нахожусь в подфракции %s {ff9000}[ /div ]", DivisionInfo[g - 1][i - 1][divName]);
			SendClientMessage(playerid, COLOR_GREY, string);


			PlayerPlaySound(playerid, 6401, 0, 0, 0); // Done
			if(IsOnline(giveplayerid) && ProxDetectorS(10.0, playerid, giveplayerid))
			{
				PlayerPlaySound(giveplayerid, 6401, 0, 0, 0); // Done
				format(string, sizeof(string), "* %s принимает приглашение и вступает в %s", getPlayerNameTransmitter(playerid), DivisionInfo[g - 1][i - 1][divName]);
				SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
			}
		}
		else
		{
			PlayerPlaySound(playerid, 6801, 0, 0, 0); // Отказ
			if(IsOnline(giveplayerid) && ProxDetectorS(10.0, playerid, giveplayerid))
			{
				PlayerPlaySound(giveplayerid, 6801, 0, 0, 0); // Отказ
				format(string, sizeof(string), "* %s отказывается от вашего предложения вступить в %s", getPlayerNameTransmitter(playerid), DivisionInfo[g - 1][i - 1][divName]);
				SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
			}
		}
	}
	if(dialogid == _:DIVISION_INVITE_SAVE)
	{
		if(response)
		{
			if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);
          	if(strlen(inputtext) > 24 || strlen(inputtext) < 1) return ErrorText(playerid, "[ Мысли ]: Не меньше 1 и не больше 24 символов"), showDialogMenuDivision(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogMenuDivision(playerid);

			new i = DP[2][playerid]; // Получаем id подфракции
			DivisionInvite(playerid, inputtext, i);
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == _:DIVISION_UNINVITE_SAVE)
	{
		if(response)
		{
			if(!strlen(inputtext)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу"), showDialogMenuDivision(playerid);
          	if(strlen(inputtext) > 24 || strlen(inputtext) < 1) return ErrorText(playerid, "[ Мысли ]: Не меньше 1 и не больше 24 символов"), showDialogMenuDivision(playerid);
           	if(checksimvol(inputtext)) return ErrorText(playerid, "[ Мысли ]: Хм... я пытаюсь написать какие-то каракули... [ Запрещённый Символ ]"), showDialogMenuDivision(playerid);

			new i = DP[2][playerid]; // Получаем id подфракции
			DivisionUninvite(playerid, inputtext, i);
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == _:DIVISION_MEMBERS_LIST)
	{
		if(response)
		{
			if(AntiFloodMysqlRequest(playerid, 10)) return 1;
			ShowDialog(playerid,1996,DIALOG_STYLE_MSGBOX,"{ff9000}Участники Подфракции {ff0000}Offline","{cccccc}Поиск участников...","*","");

			new org = DP[1][playerid] + 1; // Получаем id организации
			new div = DP[2][playerid] + 1; // Получаем id подфракции
			if (org < 0 || div < 0) return 0;

			new string_mysql[360];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT user_id, Name, Member, Rank, Fbi, Offtime, CallSign FROM `pp_igroki` WHERE \
				`Division0` = '%d' AND `Member`='%d' AND `Online` = '0' AND `user_id`>'%d' \
				OR `Division1` = '%d' AND `Member`='%d' AND `Online` = '0' AND `user_id`>'%d' LIMIT 40", div, org, DP[4][playerid], div ,org, DP[4][playerid]);
			mysql_tquery(pearsq, string_mysql, "call_membersdiv", "ddd", playerid, org, div);
		}
		else showDialogMenuDivision(playerid);
	}
	if(dialogid == _:DIVISION_ORDER_WEAPONS) { // Доступное оружие
		if (!response) return showDialogMenuDivision(playerid);

		new g = DP[1][playerid],
			i = DP[2][playerid],
			weaponid = List[listitem][playerid];

		SetDivisionAvailableWeapon(g, i, weaponid, !DivisionInfo[g][i][divAvailableWeapons][weaponid]);
		DivisionSave(g, i);

		showDialogSettingDivisionWeapons(playerid, g, i);
	}
	return 1;
}

stock racDivisionSetting(playerid, g, i , readRac)
{
	PlayerInfo[playerid][pRacDiv][0] = g;
	PlayerInfo[playerid][pRacDiv][1] = i;
	PlayerInfo[playerid][pRacDiv][2] = readRac;
	return 1;
}

stock DivisionSave(g, i) // Сохраняем в базу (моментальное сохранение при любом изменении)
{
	new string_mysql[500 + MAX_NAME_LENGTH + MAX_NAME_DIVISION_ABBREVIATION_LENGTH + 40 * 2];
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `division` SET `divRanks` = '%d', `divName` = '%e', `divAbbreviation` = '%e', `divSpawnPos0` = '%f',\
	`divSpawnPos1` = '%f', `divSpawnPos2` = '%f', `divSpawnPos3` = '%f'",
    DivisionInfo[g][i][divRanks], DivisionInfo[g][i][divName], DivisionInfo[g][i][divAbbreviation], DivisionInfo[g][i][divSpawnPos][0], DivisionInfo[g][i][divSpawnPos][1],
	DivisionInfo[g][i][divSpawnPos][2], DivisionInfo[g][i][divSpawnPos][3]); // 179 + 11 + 31 + 11 + 80

	new available_weapons_str[40 * 2];
	for (new weaponid = 0; weaponid < 38; weaponid++)
		format(available_weapons_str, sizeof(available_weapons_str), "%s%d|", available_weapons_str, DivisionInfo[g][i][divAvailableWeapons][weaponid]);

	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"%s, `divSpawnWorld` = '%d', `divSpawnInterior` = '%d', `divColorHex` = '%e', `divAvailableWeapons` = '%e' WHERE `org`='%d' AND `divid`='%d'", 
	string_mysql, DivisionInfo[g][i][divSpawnWorld], DivisionInfo[g][i][divSpawnInterior], DivisionInfo[g][i][divColorHex], available_weapons_str, g, i); // 110 + 44 + 7

    // Отправляем запрос
    query_empty(pearsq, string_mysql); // 473
    return 1;
}

stock DivisionSaveRankName(g, i, r) // Сохраняем название ранга в базу (моментальное сохранение)
{
	new string_mysql[79 + 33 + MAX_NAME_LENGTH];
    mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `division` SET `divRankName%d` = '%e' WHERE `org`='%d' AND `divid`='%d'", 
		r, DivisionRankName[g][i][r], g, i);
    query_empty(pearsq, string_mysql);
	return 1;
}

function LoadDivision() // Загрузка из базы
{
	new time = GetTickCount(); // Записываем текущий tick (чтобы узнать время загрузки в ms)
	new rows, g, i, load_max_rank, string[20];
	cache_get_row_count(rows); // Получаем количество найденных строк
	for(new f = 0; f < rows; f++)
	{
    	cache_get_value_name_int(f, "org", g); // Получаем id организации
		cache_get_value_name_int(f, "divid", i); // Получаем id подфракции

    	cache_get_value_name_int(f, "divRanks", DivisionInfo[g][i][divRanks]);
		cache_get_value_name(f, "divName", DivisionInfo[g][i][divName], MAX_NAME_LENGTH);
		cache_get_value_name(f, "divAbbreviation", DivisionInfo[g][i][divAbbreviation], MAX_NAME_DIVISION_ABBREVIATION_LENGTH);
		cache_get_value_name_float(f, "divSpawnPos0", DivisionInfo[g][i][divSpawnPos][0]);
		cache_get_value_name_float(f, "divSpawnPos1", DivisionInfo[g][i][divSpawnPos][1]);
		cache_get_value_name_float(f, "divSpawnPos2", DivisionInfo[g][i][divSpawnPos][2]);
		cache_get_value_name_float(f, "divSpawnPos3", DivisionInfo[g][i][divSpawnPos][3]);
		cache_get_value_name_int(f, "divSpawnWorld", DivisionInfo[g][i][divSpawnWorld]);
		cache_get_value_name_int(f, "divSpawnInterior", DivisionInfo[g][i][divSpawnInterior]);
		cache_get_value_name(f, "divColorHex", DivisionInfo[g][i][divColorHex], 7);
		//cache_get_value_name_int(f, "divColorVeh0", DivisionInfo[g][i][divColorVeh][0]);
		//cache_get_value_name_int(f, "divColorVeh1", DivisionInfo[g][i][divColorVeh][1]);

		// Если нет никакого цвета у подфракции, присвоим серенький
		if(isnull(DivisionInfo[g][i][divColorHex])) format(DivisionInfo[g][i][divColorHex], 7, "cccccc");

		{
			new available_weapons_str[256];
			cache_get_value_name(f, "divAvailableWeapons", available_weapons_str);

			if (isnull(available_weapons_str)) {
				// Если нет информации по доступным оружиям - делаем доступными все
				for (new weaponid = 0; weaponid < 38; weaponid++) SetDivisionAvailableWeapon(g, i, weaponid, true);
			} else {
				sscanf(available_weapons_str, "p<|>a<i>[38]", DivisionInfo[g][i][divAvailableWeapons]);
			}
		}

		// Получаем названия рангов
		if(DivisionInfo[g][i][divRanks] > 0)
		{
			load_max_rank = DivisionInfo[g][i][divRanks];
			if(DivisionInfo[g][i][divRanks] > MAX_RANK_ORG) load_max_rank = MAX_RANK_ORG;

			for(new r = 0; r < load_max_rank; r++)
			{
				format(string,sizeof(string),"divRankName%d",r);
				cache_get_value_name(f, string, DivisionRankName[g][i][r], MAX_NAME_LENGTH);
			}
		}
	}
	printf("[MODE]: Подфракции [%d ms]", GetTickCount() - time);
	return 1;
}

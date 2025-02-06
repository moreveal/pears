
/* Как добавить новый канал или рацию в настройку?
1. Плюсуем дефайн MAX_TRANSMITTER
2. Добавляем название рации в TransmitterName
3. Топаем в stock MenuSettingTransmitter и с него начинаем по цепочке редактировать всё что необходимо
*/

new TransmitterName[][] =
{
    "Рация организации /r /rb", "Рация /d /db /u /ub", "Рация подфракции /i /ib", "Рация семьи /f /fb", "Действия Администрации", // 0 - 4
    "Волна Преступлений", "Чат Администрации /a", "Чат Медиа /y", "Общие Объявления /ao /o /oo /gov", "Новости CNN /news /live" // 5 - 9
};

stock checkTransmitterPermission(playerid) // Проверки разрешений рации (чтобы не дублировать одну и ту же херню в каждую команду)
{
	if(PlayerInfo[playerid][pBkyrenie] >= 2)
	{
		ErrorMessage(playerid, "{FF6347}Ваш персонаж находится в космосе");
		return 1;
	}
	if(get_invent4(playerid, 21, 0) <= 0)
	{
		ErrorMessage(playerid, "{FF6347}У вас нет рации [ Y >> GPS >> Услуги >> Магазины с Техникой ]");
		return 1;
	}
	if(get_para(playerid, 21) == 1) 
	{
		ErrorMessage(playerid, "{FF6347}Ваша рация сломана [ Y >> GPS >> Услуги >> Магазины с Техникой ]");
		return 1;
	}
	if(Sleep[playerid] >= 1 || SleepRP[playerid] >= 1)
	{
		ErrorMessage(playerid, "{FF6347}Ваш персонаж спит");
		return 1;
	}
	if(isamute(playerid) == 1) return 1;
	return 0;
}

stock checkTransmitterOrgMute(playerid) // Проверка мута рации организации
{
    if(PlayerInfo[playerid][pFmuteTime] >= 1)
	{
        new string[90];
	    if(PlayerInfo[playerid][pFmuteTime] >= 61) format(string, sizeof(string), "{FF6347}У вас бан чата организации [ Осталось %d минут ]", PlayerInfo[playerid][pFmuteTime]/60);
	 	else format(string, sizeof(string), "{FF6347}У вас бан чата организации [ Осталось %d секунд ]", PlayerInfo[playerid][pFmuteTime]);
	 	ErrorMessage(playerid, string);
	    return 1;
	}
    return 0;
}

stock resetPlayerTransmitter(playerid) // Сбрасываем чтение раций
{
    new g = fraction(playerid);
    if(g == 0)
    {
        PlayerInfo[playerid][pRacOrg][0] = 0;
        PlayerInfo[playerid][pRacOrg][1] = 0;

        PlayerInfo[playerid][pRacDep][0] = 0;
        PlayerInfo[playerid][pRacDep][1] = 0;

        racDivisionSetting(playerid, 0, 0, 0);
    }
    else
    {
        PlayerInfo[playerid][pRacOrg][0] = g;
        PlayerInfo[playerid][pRacOrg][1] = g;

        PlayerInfo[playerid][pRacDep][0] = g;
        PlayerInfo[playerid][pRacDep][1] = g;

        if(PlayerInfo[playerid][pDivision][0] > 0) racDivisionSetting(playerid, g, PlayerInfo[playerid][pDivision][0], 1);
        else if(PlayerInfo[playerid][pDivision][1] > 0) racDivisionSetting(playerid, 2, PlayerInfo[playerid][pDivision][1], 1);
        else if(PlayerInfo[playerid][pDivision][0] == 0 && PlayerInfo[playerid][pDivision][1] == 0) racDivisionSetting(playerid, 0, 0, 0);
    }
    return 1;
}
stock resetTransmitterDivisionKey(div0, playerOrg, &getOrg, &getDiv, &getReadRac) // Получаем инфу о том, что делаем с рацией /i
{
	if(div0 > 0 && playerOrg > 0) // Если у игрока есть организация и подфракция
	{
		getOrg = playerOrg;
		getDiv = div0;
		getReadRac = 1;
	}
	else // Если нет, доступ к /i должен быть выключен
	{
		getOrg = 0;
		getDiv = 0;
		getReadRac = 0;
	}
	return 1;
}

stock PermissionTracking(playerid, giveplayerid)
{
	if(MPGO[playerid] != 0) return ErrorMessage(playerid, "{FF6347}Вы на мероприятии");
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return ErrorMessage(playerid, "{FF6347}Ваш персонаж должен быть пешком");
	if(playerid == giveplayerid) return ErrorMessage(playerid, "{FF6347}Вы не моежет прикрепить жучок к себе");
	if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети");
	if(GetPlayerState(giveplayerid) == PLAYER_STATE_SPECTATING || !ProxDetectorS(3.0, playerid, giveplayerid)) return ErrorMessage(playerid, "{FF6347}Вы далеко от игрока");
	if(IsPlayerInAnyVehicle(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Гражданин в транспорте");
    return 0;
}

CMD:tracking(playerid, const params[])
{
    new g = fraction(playerid);
	if(!IsAFunctionOrganization(31, g, playerid) && PlayerInfo[playerid][pFbi] == 0) return ErrorMessage(playerid, "{FF6347}Вы не агент FBI");
	if(!GetAccessRankOrg(playerid, 2, 31, PlayerInfo[playerid][pFbi])) return 1;

    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Жучок для прослушки [ /tacking ID ]");
    if(PermissionTracking(playerid, params[0])) return 1;
	PlayerPlaySound(playerid,40405,0,0,0);
	DP[0][playerid] = params[0];
	ShowDialog(playerid,958,DIALOG_STYLE_LIST,"{cccccc}Система Слежения FBI","{ff9000}Жучок на Смартфон\n{0088ff}Жучок на Рацию","Выбрать","Отмена");
	return 1;
}

CMD:force(playerid, const params[])
{
	new frakid = fraction(playerid);
	if(frakid == 0) return ErrorMessage(playerid, "{FF6347}Вы не состоите в организации");
	if(!GetAccessRankOrg(playerid, frakid, 14, NO_FBI)) return 1;
	if(PlayerInfo[playerid][pGoogle] == 0) return ErrorMessage(playerid, "{FF6347}У вас не привязан Google Authenticator");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Принудительно включить рацию подчинённому [ /force ID ]");
	if(!IsOnline(params[0])) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети");
	if(PlayerInfo[params[0]][pLeader] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете принудительно включить рацию лидеру");
	if(frakid != PlayerInfo[params[0]][pMember]) return ErrorMessage(playerid, "{FF6347}Он не состоит с вами в одной организации");
	if(playerid == params[0]) return ErrorMessage(playerid, "{FF6347}Вы не можете себе принудительно включить рацию");
	if(PlayerInfo[params[0]][pRank] >= PlayerInfo[playerid][pRank]) return ErrorMessage(playerid, "{FF6347}Вы можете принудительно включить рацию только подчинённому");
	if(PlayerInfo[params[0]][pTransmitterOff][0] == false) return ErrorMessage(playerid, "{FF6347}У него включена рация");
	PlayerInfo[params[0]][pTransmitterOff][0] = false;
    PlayerInfo[params[0]][pTransmitterUpdate] = true;
	new string[90];
 	format(string, sizeof(string), "Вы принудительно включили рацию %s",PlayerInfo[params[0]][pName]);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "[ Мысли ]: {0088ff}%s {cccccc}принудительно включил мою рацию",PlayerInfo[playerid][pName]);
	SendClientMessage(params[0], COLOR_GREY, string);
    PlayerPlaySound(playerid,6400,0,0,0);
	PlayerPlaySound(params[0],6400,0,0,0);
 	return 1;
}

CMD:famforce(playerid, const params[])
{
	if(PlayerInfo[playerid][pFamily] == 0) return ErrorMessage(playerid, "{FF6347}У вас нет семьи\n{cccccc}Звучит печально ;(");
	new f = PlayerInfo[playerid][pFamily], string[144];
	if(FamilyInfo[f][fSost] == 0) return SendClientMessage(playerid, COLOR_GREY, "Ошибка! [ Code: 3039 ]"), PlayerPlaySound(playerid,4203,0,0,0), PlayerInfo[playerid][pFamily] = 0;
    if(PlayerInfo[playerid][pFamrank] < FamilyInfo[f][fAccfamfo]) return format(string,sizeof(string),"{FF6347}Вы не можете включить рацию участнику семьи [ %d+ Ранг ]",FamilyInfo[f][fAccfamfo]), ErrorMessage(playerid, string);
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Принудительно включить рацию участнику семьи [ /famforce ID ]");
	if(!IsOnline(params[0])) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети");
	if(PlayerInfo[playerid][pFamily] != PlayerInfo[params[0]][pFamily]) return ErrorMessage(playerid, "{FF6347}Это не участник вашей семьи");
	if(PlayerInfo[params[0]][pFamrank] >= PlayerInfo[playerid][pFamrank]) return ErrorMessage(playerid, "{FF6347}Вы можете включить рацию только младшим по рангу");
	if(PlayerInfo[params[0]][pTransmitterOff][3] == false) return ErrorMessage(playerid, "{FF6347}У этого участника семьи включена рация");
	PlayerInfo[params[0]][pTransmitterOff][3] = false;
    PlayerInfo[params[0]][pTransmitterUpdate] = true;
	format(string, sizeof(string), "Вы принудительно включили рацию %s",PlayerInfo[params[0]][pName]);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "[ Мысли ]: {0088ff}%s {cccccc}принудительно включил мою семейную рацию",PlayerInfo[playerid][pName]);
	SendClientMessage(params[0], COLOR_GREY, string);
	PlayerPlaySound(playerid,6400,0,0,0);
	PlayerPlaySound(params[0],6400,0,0,0);
 	return 1;
}

CMD:y(playerid, const params[])
{
	if(PlayerInfo[playerid][pMedia] == 0 && !admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)) return ErrorMessage(playerid, "{FF6347}Вы не медиа партнёр");
	if(PlayerInfo[playerid][pTransmitterOff][7] == true) return ErrorMessage(playerid, "{FF6347}У вас выключен чат медиа\n{cccccc}Y >> Меню >> Настройки Чата");
	if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чат медиа /y текст");
	new string[144];
	format(string, sizeof(string), "{444444}[ Media ] {ff6699}%s[%d]: {66cc66}%s", PlayerInfo[playerid][pName], playerid, params[0]);
	SendMediaMessage(COLOR_GREY, string);
	return 1;
}

CMD:o(playerid, const params[])
{
	if(noooc == 1 || PlayerInfo[playerid][pSoska] >= 2 || PlayerInfo[playerid][pDjpears] >= 4)
	{
		if(isamute(playerid) == 1) return 1;
		if(PlayerInfo[playerid][pTransmitterOff][8] == true) return ErrorMessage(playerid, "{FF6347}У вас выключен этот чат\n{cccccc}Y >> Меню >> Настройки Чата");
		if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Общий чат [ /o текст ]");
		
		new string[160];
		format(string, sizeof(string), "{0088ff}(( %s[%d]: {FFFFFF}%s {0088ff}))",PlayerInfo[playerid][pName],playerid, params[0]);
		OOCOff(COLOR_GREY,string);
    }
    else ErrorMessage(playerid, "{FF6347}Общий чат отключён администрацией сервера");
	return 1;
}

CMD:oo(playerid, const params[])
{
    if(noooc2 == 0) return ErrorMessage(playerid, "{FF6347}Общий чат отключён администрацией сервера");
    if(PlayerInfo[playerid][pLevel] <= 2) return ErrorMessage(playerid, "{FF6347}Сообщения в общий чат можно отправлять только с 3 уровня");
    if(PlayerInfo[playerid][pTransmitterOff][8] == true) return ErrorMessage(playerid, "{FF6347}У вас выключен этот чат\n{cccccc}Y >> Меню >> Настройки Чата");
    if(GetPVarInt(playerid,"antiflood") > 0) return ErrorMessage(playerid, "{FF6347}Пожалуйста подождите.. Отправить сообщение можно один раз в 30 секунд");
    if(isamute(playerid) == 1) return 1;
	if (sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Общий чат [ /oo текст ]");

    new string[160];
	format(string, sizeof(string), "{FFFFFF}(( {cccccc}%s[%d]: %s {FFFFFF}))",PlayerInfo[playerid][pName],playerid, params[0]);
	OOCOff(COLOR_GREY,string);
	SetPVarInt(playerid,"antiflood",31);
	return 1;
}

CMD:ao(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 2) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(PlayerInfo[playerid][pTransmitterOff][8] == true) return ErrorMessage(playerid, "{FF6347}У вас выключен этот чат\n{cccccc}Y >> Меню >> Настройки Чата");
	if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чат новостей администрации [ /ao текст ]");

    new string[160];
	format(string, sizeof(string), "{ff9000}* [ADM] %s[%d]: {FF0000}%s {0088ff}*", PlayerInfo[playerid][pName], playerid, params[0]);
	OOCOff(COLOR_WHITE,string);
	return 1;
}

// Команды /r и /rb (Рация организаций) - Работает для всех организаций и учитывает прикрытием FBI (Переключается в /mm)
CMD:r(playerid, const params[])
{
	commandR(playerid, 0, params);
	return 1;
}
CMD:rb(playerid, const params[])
{
	commandR(playerid, 1, params);
	return 1;
}
stock commandR(playerid, typeCommand, const params[])
{
	if(checkTransmitterPermission(playerid)) return 1; // Проверки разрешений рации

    new g, writeRac;
    g = PlayerInfo[playerid][pRacOrg][0]; // Организация
    writeRac = PlayerInfo[playerid][pRacOrg][1]; // Возможность написать в подключённый канал рации

    if(PlayerInfo[playerid][pTransmitterOff][0] == true) return ErrorMessage(playerid, "{FF6347}В вашей рации выключен канал организации /r /rb [ Y >> Меню >> Настройки Чата ]");
    if(writeRac == 0 || g == 0) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к каналу организации\n{cccccc}Вы можете настроить каналы рации [ Y >> Меню >> Настройки Чата ]");
	if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Канал рации организации /r или /rb текст");

    if(checkTransmitterOrgMute(playerid)) return 1; // Проверка мута рации организации
	if(AntiFloodText(playerid, params)) return 1; // Антифлуд

    new nameRank[MAX_NAME_LENGTH], nameAbb[MAX_NAME_DIVISION_ABBREVIATION_LENGTH];
    if(g == 2 && PlayerInfo[playerid][pFbi] > 0) // Получаем ранг FBI под прикрытием в своём чате
    {
        format(nameRank,sizeof(nameRank), "%s", getNameRankPlayer(g, PlayerInfo[playerid][pFbi], PlayerInfo[playerid][pDivision][1], PlayerInfo[playerid][pDivRank][1]));
        format(nameAbb,sizeof(nameAbb), "%s", getNameAbbreviationOrganization(playerid, g, 1));
    }
    else // Получаем ранг организации с учётом подфракции
    {
        format(nameRank,sizeof(nameRank), "%s", getNameRank(playerid));
        format(nameAbb,sizeof(nameAbb), "%s", getNameAbbreviation(playerid));
    }

    new string[240];
    if(!strcmp(nameRank,"\0",true)) return format(string, sizeof(string), "{FF6347}В %s у вашего ранга нет названия\n{cccccc}Обратитесь к лидеру вашей организации или к администрации", frakeasyName[g]), ErrorMessage(playerid, string);
    if(IsADepartID(g) || g == 9) // Законные организации
    {
        if(typeCommand == 0) format(string, sizeof(string), "** %s%s {00C6FF}%s: %s", nameAbb, nameRank, getPlayerNameTransmitter(playerid), params[0]);
        else format(string, sizeof(string), "** %s%s {00C6FF}%s: (( %s ))", nameAbb, nameRank, getPlayerNameTransmitter(playerid), params[0]);
        SendRadioMessage(g, COLOR_WHITE, string);
    }
    else // Прочие организации
    {
        new colorPlayerRac[7];
        new maxRank = get_maxrank(g);
        if(PlayerInfo[playerid][pRank] >= maxRank-1) format(colorPlayerRac, sizeof(colorPlayerRac), "01C6FF");
        else format(colorPlayerRac, sizeof(colorPlayerRac), "F3F3F3");

        if(typeCommand == 0) format(string, sizeof(string), "** %s%s %s: {%s}%s", nameAbb, nameRank, getPlayerNameTransmitter(playerid), colorPlayerRac, params[0]);
        else format(string, sizeof(string), "** %s%s %s: {%s}(( %s ))", nameAbb, nameRank, getPlayerNameTransmitter(playerid), colorPlayerRac, params[0]);
		SendRadioMessage(g, TEAM_AZTECAS_COLOR, string);
    }
	return 1;
}

// Команды /d /db /u /ub (Рация департамента и союза банд мафий) - Работает для всех организаций и учитывает прикрытием FBI (Переключается в /mm)
CMD:u(playerid, const params[]) return pc_cmd_d(playerid, params);
CMD:d(playerid, const params[])
{
	commandD(playerid, 0, params);
	return 1;
}
CMD:ub(playerid, const params[]) return pc_cmd_db(playerid, params);
CMD:db(playerid, const params[])
{
	commandD(playerid, 1, params);
	return 1;
}
stock commandD(playerid, typeCommand, const params[])
{
	if(checkTransmitterPermission(playerid)) return 1; // Проверки разрешений рации

    new g, writeRac;
    g = PlayerInfo[playerid][pRacDep][0]; // Организация
    writeRac = PlayerInfo[playerid][pRacDep][1]; // Возможность написать в подключённый канал рации

    if(PlayerInfo[playerid][pTransmitterOff][1] == true) return ErrorMessage(playerid, "{FF6347}В вашей рации выключен общий канал /d /db /u /ub [ Y >> Меню >> Настройки Чата ]");
    if(writeRac == 0 || g == 0 || g == 9) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к общему каналу\n{cccccc}Вы можете настроить каналы рации [ Y >> Меню >> Настройки Чата ]");
	if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Общий канал организаций /d /u или /db /ub текст");

    if(checkTransmitterOrgMute(playerid)) return 1; // Проверка мута рации организации
	if(AntiFloodText(playerid, params)) return 1; // Антифлуд

    new nameRank[MAX_NAME_LENGTH], nameAbb[MAX_NAME_DIVISION_ABBREVIATION_LENGTH];
    if(g == 2 && PlayerInfo[playerid][pFbi] > 0) // Получаем ранг FBI под прикрытием в своём чате
    {
        format(nameRank,sizeof(nameRank), "%s", getNameRankPlayer(g, PlayerInfo[playerid][pFbi], PlayerInfo[playerid][pDivision][1], PlayerInfo[playerid][pDivRank][1]));
        format(nameAbb,sizeof(nameAbb), "%s", getNameAbbreviationOrganization(playerid, g, 1));
    }
    else // Получаем ранг организации с учётом подфракции
    {
        format(nameRank,sizeof(nameRank), "%s", getNameRank(playerid));
        format(nameAbb,sizeof(nameAbb), "%s", getNameAbbreviation(playerid));
    }

    new string[240];
    if(!strcmp(nameRank,"\0",true)) return format(string, sizeof(string), "{FF6347}В %s у вашего ранга нет названия\n{cccccc}Обратитесь к лидеру вашей организации или к администрации", frakeasyName[g]), ErrorMessage(playerid, string);  

    if(IsADepartID(g) || IsAGangID(g) || IsAMafiaID(g))
    {
        if(PlayerInfo[playerid][pSoska] <= 0 && !GetAccessRankOrg(playerid, g, 39, PlayerInfo[playerid][pFbi])) return 1;

        new realRank = PlayerInfo[playerid][pRank];
        if(g == 2 && PlayerInfo[playerid][pFbi] > 0) realRank = PlayerInfo[playerid][pFbi];

        new maxRank = get_maxrank(g);
        if(realRank >= maxRank - 1) // Лидеры и Замы
        {
            if(typeCommand == 0) format(string, sizeof(string), "** [%s] %s%s%s {FF8282}%s: %s **", AbbName[g], FrakColor[g], nameAbb, nameRank, getPlayerNameTransmitter(playerid), params[0]);
            else format(string, sizeof(string), "** [%s] %s%s%s {FF8282}%s: (( %s )) **", AbbName[g], FrakColor[g], nameAbb, nameRank, getPlayerNameTransmitter(playerid), params[0]);
        }
        else 
        {
            if(typeCommand == 0) format(string, sizeof(string), "** [%s] %s%s %s: %s **", AbbName[g], nameAbb, nameRank, getPlayerNameTransmitter(playerid), params[0]);
            else format(string, sizeof(string), "** [%s] %s%s %s: (( %s )) **", AbbName[g], nameAbb, nameRank, getPlayerNameTransmitter(playerid), params[0]);
        }
        if(IsADepartID(g)) SendDepartMessage(COLOR_ALLDEPT, string);
        else if(IsAGangID(g)) SendGangMessage(COLOR_ALLDEPT, string);
        else if(IsAMafiaID(g)) SendMafiaMessage(COLOR_ALLDEPT, string);
    }
	return 1;
}

// Команды /i и /ib (Рация подфракций) - Работает для всех организаций и учитывает прикрытием FBI (Переключается в /mm)
CMD:i(playerid, const params[])
{
	commandI(playerid, 0, params);
	return 1;
}
CMD:ib(playerid, const params[])
{
	commandI(playerid, 1, params);
	return 1;
}
stock commandI(playerid, typeCommand, const params[])
{
	if(checkTransmitterPermission(playerid)) return 1; // Проверки разрешений рации

    new g, i, writeRac;
    g = PlayerInfo[playerid][pRacDiv][0]; // Организация
    i = PlayerInfo[playerid][pRacDiv][1]; // Подфракция
    writeRac = PlayerInfo[playerid][pRacDiv][2]; // Возможность написать в подключённый канал рации

    if(PlayerInfo[playerid][pTransmitterOff][2] == true) return ErrorMessage(playerid, "{FF6347}В вашей рации выключен канал подфракции /i /ib [ Y >> Меню >> Настройки Чата ]");
    if(writeRac == 0 || g == 0 || i == 0) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к каналу подфракции\n{cccccc}Вы можете настроить каналы рации [ Y >> Меню >> Настройки Чата ]");
	if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Канал рации подфракции /i или /ib текст");

    if(checkTransmitterOrgMute(playerid)) return 1; // Проверка мута рации организации
	if(AntiFloodText(playerid, params)) return 1; // Антифлуд

    new nameRank[MAX_NAME_LENGTH];
    if(g == 2 && PlayerInfo[playerid][pFbi] > 0) // Получаем ранг FBI под прикрытием в своём чате
    {
        format(nameRank,sizeof(nameRank), "%s", getNameRankPlayer(g, PlayerInfo[playerid][pFbi], PlayerInfo[playerid][pDivision][1], PlayerInfo[playerid][pDivRank][1]));
    }
    else // Получаем ранг организации с учётом подфракции
    {
        format(nameRank,sizeof(nameRank), "%s", getNameRank(playerid));
    }

    new string[240];
    if(!strcmp(nameRank,"\0",true)) return format(string, sizeof(string), "{FF6347}В %s [%s] у вашего ранга нет названия\n{cccccc}Обратитесь к лидеру вашей организации или к администрации", frakeasyName[g], DivisionInfo[g][i][divAbbreviation]), ErrorMessage(playerid, string);

    g -= 1, i -= 1; // Исправления, для корректного получения названий переменных
	if(typeCommand == 0) format(string, sizeof(string), "** [%s] %s %s: %s", DivisionInfo[g][i][divAbbreviation], nameRank, getPlayerNameTransmitter(playerid), params[0]);
	else format(string, sizeof(string), "** [%s] %s %s: (( %s ))", DivisionInfo[g][i][divAbbreviation], nameRank, getPlayerNameTransmitter(playerid), params[0]);
	SendDivisionMessage(g + 1, i + 1, COLOR_DIVISION_CHAT, string);
	return 1;
}

// Команды /f и /fb (Рация семьи)
CMD:f(playerid, const params[])
{
	commandF(playerid, 0, params);
	return 1;
}
CMD:fb(playerid, const params[])
{
	commandF(playerid, 1, params);
	return 1;
}
stock commandF(playerid, typeCommand, const params[])
{
    if(PlayerInfo[playerid][pFamily] == 0) return ErrorMessage(playerid, "{FF6347}У вас нет семьи");
    if(GetPVarInt(playerid, "adminreadfam")) return ErrorMessage(playerid, "{FF6347}Нельзя писать в чат семьи, когда вы её прослушиваете");

	if(checkTransmitterPermission(playerid)) return 1; // Проверки разрешений рации

    if(PlayerInfo[playerid][pTransmitterOff][3] == true) return ErrorMessage(playerid, "{FF6347}В вашей рации выключен канал семьи /f /fb [ Y >> Меню >> Настройки Чата ]");
	if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Канал рации семьи /f или /fb текст");

    new string[240];
    if(PlayerInfo[playerid][pRukzWorld] >= 1)
	{
        if(PlayerInfo[playerid][pRukzWorld] >= 61) format(string, sizeof(string), "{FF6347}У вас бан чата семьи [ Осталось %d минут ]", PlayerInfo[playerid][pRukzWorld]/60);
        else format(string, sizeof(string), "{FF6347}У вас бан чата семьи [ Осталось %d секунд ]", PlayerInfo[playerid][pRukzWorld]);
        ErrorMessage(playerid, string);
        return 1;
	}
	if(AntiFloodText(playerid, params)) return 1; // Антифлуд

    new f = PlayerInfo[playerid][pFamily];
    if(FamilyInfo[f][fSost] == 0 || f >= MAX_FAMILY) return ErrorMessage(playerid, "{FF6347}Ошибка! Семья не создана или была удалена"), PlayerInfo[playerid][pFamily] = 0;

    new r = PlayerInfo[playerid][pFamrank];
    if(typeCommand == 0) format(string, sizeof(string), "[F] %s {%s}%s[%d]: {%s}%s", FamilyRankName[f][r - 1], ColorFam1(f), PlayerInfo[playerid][pName], playerid, ColorFam2(f), params[0]);
    else format(string, sizeof(string), "[F] %s {%s}%s[%d]: {%s}(( %s ))", FamilyRankName[f][r - 1], ColorFam1(f), PlayerInfo[playerid][pName], playerid, ColorFam2(f), params[0]);
	SendFamilyMessage(f, 0x66ffffAA, string);
	return 1;
}

stock getNameRank(playerid) // Получаем общее название ранга
{
    new nameRank[MAX_NAME_LENGTH];
    new g = fraction(playerid);

    if(g == 0 && PlayerInfo[playerid][pSoska] > 0) format(nameRank,sizeof(nameRank), "Админ");
    else if(g > 0) format(nameRank,sizeof(nameRank), getNameRankPlayer(g, PlayerInfo[playerid][pRank], PlayerInfo[playerid][pDivision][0], PlayerInfo[playerid][pDivRank][0]));
    else format(nameRank,sizeof(nameRank), "None");
    return nameRank;
}
stock getNameRankPlayer(g, r, i, ri) // Получаем название ранга внутри организации (с учётом подфракции)
{
    new nameRank[MAX_NAME_LENGTH];
    if(i > 0) format(nameRank,sizeof(nameRank), getNameRankDivision(g, i, ri)); // Если состоит в подфракции
    else format(nameRank,sizeof(nameRank), getNameRankOrganization(g, r));
    return nameRank;
}

stock getNameRankDivision(g, i, r)
{
    new nameRank[MAX_NAME_LENGTH];
    if(g == 0 || i == 0 || r == 0) format(nameRank,sizeof(nameRank), "None");
    else 
    {
        new maxRankDiv = DivisionInfo[g - 1][i - 1][divRanks];
        if (maxRankDiv <= 0) format(nameRank,sizeof(nameRank), "None"); 
        else if(r > maxRankDiv) format(nameRank,sizeof(nameRank), DivisionRankName[g - 1][i - 1][maxRankDiv - 1]); // Если ранг выше максимального, отображаем предыдущее
        else format(nameRank,sizeof(nameRank), DivisionRankName[g - 1][i - 1][r - 1]);
    }
    return nameRank;
}

stock getNameRankOrganization(g, r)
{
    new nameRank[MAX_NAME_LENGTH];
    if(g == 0 || r == 0) format(nameRank,sizeof(nameRank), "None");
    else 
    {
        new maxRankOrg = get_maxrank(g);
        if(r >= maxRankOrg) format(nameRank,sizeof(nameRank), RankOrg[g][maxRankOrg - 1]); // Если ранг выше максимального, отображаем максимальный
        format(nameRank,sizeof(nameRank), RankOrg[g][r - 1]); // g не корректируем намеренно, на нём нам насрать
    }
    return nameRank;
}

stock getNameAbbreviation(playerid)
{
    new nameAbb[MAX_NAME_DIVISION_ABBREVIATION_LENGTH];
    new g = fraction(playerid);
    if(g > 0) format(nameAbb,sizeof(nameAbb), "%s", getNameAbbreviationOrganization(playerid, g, 0));
    return nameAbb;
}
stock getNameAbbreviationOrganization(playerid, g, typeFbi)
{
    new nameAbb[MAX_NAME_DIVISION_ABBREVIATION_LENGTH];
    new i;
    if(typeFbi == 0) i = PlayerInfo[playerid][pDivision][0] - 1;
    else if(typeFbi == 1) i = PlayerInfo[playerid][pDivision][1] - 1;
    if(i >= 0) format(nameAbb, sizeof(nameAbb), "[%s] ", DivisionInfo[g - 1][i][divAbbreviation]);
    return nameAbb;
}
stock getPlayerNameTransmitter(playerid) // Получение имени для раций /i /ib /f /fb
{
    new PlayerName[34];
	if(PlayerInfo[playerid][pLeader] == 8 || PlayerInfo[playerid][pMember] == 8) // ICA
	{
		if(PlayerInfo[playerid][pSignTransmitter] == false) format(PlayerName,sizeof(PlayerName), "%s[%d]", PlayerInfo[playerid][pName], playerid); // Включено отображением имени
		else format(PlayerName,sizeof(PlayerName), "%s", PlayerInfo[playerid][pCallSign]);  // Отображение имени выключено, значит всегда видно только звание (позывной)
	}
	else format(PlayerName,sizeof(PlayerName), "%s[%d]", PlayerInfo[playerid][pName], playerid);
	return PlayerName;
}

stock getPlayerNameTransmitterOffline(g, bool:singStatus, const playerName[], const signName[]) // Получение имени offline для раций /i /ib /f /fb
{
    new PlayerName[34];
	if(g == 8) // ICA
	{
		if(singStatus == false) format(PlayerName,sizeof(PlayerName), "%s", playerName); // Включено отображением имени
		else format(PlayerName,sizeof(PlayerName), "%s", signName);  // Отображение имени выключено, значит всегда видно только звание (позывной)
	}
	else format(PlayerName,sizeof(PlayerName), "%s", playerName);
	return PlayerName;
}

stock IsADepartID(g) // Получение списка законных организаций, которые видят /d чат департамента
{
    if(g == 1 || g == 2 || g == 3 || g == 4 || g == 7 || g == 11 || g == 21 || g == 22) return 1;
    return 0;
}
stock IsAGangID(g) // Получение списка банд, которые видят /d или /u общий чат
{
    if(g == 13 || g == 14 || g == 15 || g == 16 || g == 17) return 1;
    return 0;
}
stock IsAMafiaID(g) // Получение списка мафий, которые видят /d или /u общий чат
{
    if(g == 5 || g == 6 || g == 10 || g == 12 || g == 18) return 1;
    return 0;
}

function SendRadioMessage(g, color, const string[]) // Чат организации (Кто будет видеть отправленное сообщение)
{
    if(g > 0)
	{
		foreach (Player, i)
		{
			if(OnlineInfo[i][oLogged] == 0 // Не залогинился - игнорим
                || PlayerInfo[i][pBkyrenie] >= 2 // В космосе - игнорим
                || PlayerInfo[i][pTransmitterOff][0] == true) continue; // Канал выключен - игнорим

			if(PlayerInfo[i][pRacOrg][0] == g || GetPVarInt(i, "komp2") == g) // Показываем только тем, кто читает эту рацию (Не важно, каким образом он её читает)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
}

function SendDepartMessage(color, const string[]) // Общий чат департамента (Кто будет видеть отправленное сообщение)
{
    foreach (Player, i)
    {
        if(OnlineInfo[i][oLogged] == 0 // Не залогинился - игнорим
                || PlayerInfo[i][pBkyrenie] >= 2 // В космосе - игнорим
                || PlayerInfo[i][pTransmitterOff][1] == true // Канал выключен - игнорим
                || PlayerInfo[i][pRacDep][0] == 0) continue; // Не читаем никакую рацию - игнорим

        if(IsADepartID(PlayerInfo[i][pRacDep][0]) || IsADepartID(GetPVarInt(i, "komp2"))) // Показываем только тем, кто читает эту рацию (Не важно, каким образом он её читает)
        {
            SendClientMessage(i, color, string);
        }
    }
}

function SendGangMessage(color, const string[]) // Общий чат банд (Кто будет видеть отправленное сообщение)
{
    foreach (Player, i)
    {
        if(OnlineInfo[i][oLogged] == 0 // Не залогинился - игнорим
                || PlayerInfo[i][pBkyrenie] >= 2 // В космосе - игнорим
                || PlayerInfo[i][pTransmitterOff][1] == true // Канал выключен - игнорим
                || PlayerInfo[i][pRacDep][0] == 0) continue; // Не читаем никакую рацию - игнорим

        if(IsAGangID(PlayerInfo[i][pRacDep][0]) || IsAGangID(GetPVarInt(i, "komp2"))) // Показываем только тем, кто читает эту рацию (Не важно, каким образом он её читает)
        {
            SendClientMessage(i, color, string);
        }
    }
}

function SendMafiaMessage(color, const string[]) // Общий чат мафий (Кто будет видеть отправленное сообщение)
{
    foreach (Player, i)
    {
        if(OnlineInfo[i][oLogged] == 0 // Не залогинился - игнорим
                || PlayerInfo[i][pBkyrenie] >= 2 // В космосе - игнорим
                || PlayerInfo[i][pTransmitterOff][1] == true // Канал выключен - игнорим
                || PlayerInfo[i][pRacDep][0] == 0) continue; // Не читаем никакую рацию - игнорим

        if(IsAMafiaID(PlayerInfo[i][pRacDep][0]) || IsAMafiaID(GetPVarInt(i, "komp2"))) // Показываем только тем, кто читает эту рацию (Не важно, каким образом он её читает)
        {
            SendClientMessage(i, color, string);
        }
    }
}

function SendDivisionMessage(g, div, color, const string[]) // Чат подфракции (Кто будет видеть отправленное сообщение)
{
	if(g > 0)
	{
		foreach (Player, i)
		{
			if(OnlineInfo[i][oLogged] == 0 //  Не залогинился - игнорим
                || PlayerInfo[i][pBkyrenie] >= 2 // В космосе - игнорим
                || PlayerInfo[i][pTransmitterOff][2] == true // Канал выключен - игнорим
                || PlayerInfo[i][pRacDiv][0] == 0 || PlayerInfo[i][pRacDiv][1] == 0) continue; // Не читаем никакую рацию - игнорим

			if(PlayerInfo[i][pRacDiv][0] == g && PlayerInfo[i][pRacDiv][1] == div) // Показываем только тем, кто читает эту рацию (Не важно, каким образом он её читает)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
}

function SendFamilyMessage(f, color, const string[])
{
	foreach (Player, i)
	{
        new familyid = f;
        if(GetPVarInt(i, "adminreadfam")) familyid = GetPVarInt(i, "adminreadfam"); // Меняем номер семьи при чтении [ /readfam ]

        if(OnlineInfo[i][oLogged] == 0 // Не залогинился - игнорим
            || PlayerInfo[i][pBkyrenie] >= 2 // В космосе - игнорим
            || PlayerInfo[i][pTransmitterOff][3] == true // Канал выключен - игнорим
            || PlayerInfo[i][pFamily] != familyid) continue;

		SendClientMessage(i, color, string);
	}
}

function AllMessage(color, const string[]) // Действия Администрации
{
    foreach (Player, i)
    {
        if(OnlineInfo[i][oLogged] == 1 && PlayerInfo[i][pTransmitterOff][4] == false) SendClientMessage(i, color, string);
    }
}

function WaveMess(color, const string[]) // Мат медиков
{
    // Ничего не выводим (необходимость вывода матов медикам под вопросом)
	/*foreach (Player, i)
	{
		if(OnlineInfo[i][oLogged] == 1 && PlayerInfo[i][pMember] == 4 && PlayerInfo[i][pTransmitterOff][5] == false) SendClientMessage(i, color, string);
	}*/
	return 1;
}

function SendAdminMessage(color, const string[]) // Чат админов /a
{
	foreach (Player, i)
	{
	    if(OnlineInfo[i][oLogged] == 1 && PlayerInfo[i][pTransmitterOff][6] == false
            && (PlayerInfo[i][pSoska] > 0 || PlayerInfo[i][pHidden] > 0)) SendClientMessage(i, color, string);
	}
	return 1;
}

function SendMediaMessage(color, const string[]) // Чат медиа /y
{
	foreach (Player, i)
	{
	    if(OnlineInfo[i][oLogged] == 1 && PlayerInfo[i][pTransmitterOff][7] == false
            && (PlayerInfo[i][pMedia] > 0 || admin_right(PlayerInfo[i][pSoska], ADM_SPHERE_MANAGER))) SendClientMessage(i, color, string);
	}
	return 1;
}

function OOCOff(color, const string[]) // Чат /ao /o /oo /gov и прочие объявления на весь сервер
{
    foreach (Player, i)
    {
        if(OnlineInfo[i][oLogged] == 1 && PlayerInfo[i][pBkyrenie] <= 1 && PlayerInfo[i][pTransmitterOff][8] == false) SendClientMessage(i, color, string);
    }
    return 1;
}

function OOCNews(color, const string[]) // Новости CNN /news /live
{
    foreach (Player, i)
    {
        if(OnlineInfo[i][oLogged] == 1 && PlayerInfo[i][pBkyrenie] <= 1 && PlayerInfo[i][pTransmitterOff][9] == false) SendClientMessage(i, color, string);
    }
    return 1;
}

stock dialogCase_Transmitter(playerid, dialogid, response, listitem)
{
    if(dialogid == 490)
    {
        if(response)
        {
            if(listitem < 0 || listitem >= sizeof(TransmitterName)) return 1;
            DP[0][playerid] = listitem;
            MenuSettingTransmitter(playerid, listitem);
        }
        else pc_cmd_mm(playerid);
    }
    else if(dialogid == 491)
    {
        if(response)
        {
            new tid = DP[0][playerid];
            if(listitem == 0)
            {
                if(tid == 5) // Волна нарушений
                {
				    if(!IsPoliceMember(playerid) && PlayerInfo[playerid][pFbi] == 0 
                        && PlayerInfo[playerid][pMember] != 4) return ErrorMessage(playerid, "{FF6347}Волна нарушений для вас не отображается\n{cccccc}Доступна только сотрудникам правоохранительных органов и докторам");
                }
                else if(tid == 6) // Чат Администрации
                {
                    if(PlayerInfo[playerid][pSoska] == 0 && PlayerInfo[playerid][pHidden] == 0) return ErrorMessage(playerid, "{FF6347}Вам недоступен чат администрации");
                }
                else if(tid == 7) // Чат Медиа /y
                {
                    if(PlayerInfo[playerid][pMedia] == 0 
                        && !admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_MANAGER)) return ErrorMessage(playerid, "{FF6347}Вам недоступен чат медиа");
                }
                PlayerInfo[playerid][pTransmitterOff][tid] = !PlayerInfo[playerid][pTransmitterOff][tid];
                PlayerInfo[playerid][pTransmitterUpdate] = true;
                MenuSettingTransmitter(playerid, tid);
            }
            else if(listitem == 1) SettingChannelTransmitter(playerid, tid);
        }
        else SettingTransmitter(playerid);
    }
    else if(dialogid == 506)
    {
        new bool: open_by_cmd = bool: GetPVarInt(playerid, "OpenChannelTransmitterByCMD");

        new tid = DP[0][playerid];
        
        if(response)
        {
            if(listitem < 0 || listitem >= MAX_ORG) return 1;
            new g = List[listitem][playerid];

            if(tid == 0) // "Рация организации /r /rb"
            {
                PlayerInfo[playerid][pRacOrg][0] = g;
                PlayerInfo[playerid][pRacOrg][1] = g;
            }
            else if(tid == 1) // "Рация /d /db /u /ub"
            {
                PlayerInfo[playerid][pRacDep][0] = g;
                PlayerInfo[playerid][pRacDep][1] = g;
            }
            else if(tid == 2) // "Рация подфракции /i /ib"
            {
                new i = ListParam[listitem][playerid];
                if(g == 0 || i == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! ID организации или подфракции не может быть 0");

                PlayerInfo[playerid][pRacDiv][0] = g; // Организация
                PlayerInfo[playerid][pRacDiv][1] = i; // Подфракция
                PlayerInfo[playerid][pRacDiv][2] = 1; // Возможность писать в рацию подфракции
            }
            
            if (!open_by_cmd) MenuSettingTransmitter(playerid, tid);
            else {
                new str[64];
                format(str, sizeof(str), "{99ff66}Ваш текущий канал рации: %s", frakName[g]);
                SuccessMessage(playerid, str);
            }

            PlayerPlaySound(playerid, 6401, 0, 0, 0);
        }
        else if (!open_by_cmd) MenuSettingTransmitter(playerid, tid);

        DeletePVar(playerid, "OpenChannelTransmitterByCMD");
    }
    else if(dialogid == 958)
	{
		if(response)
		{
			new giveplayerid = DP[0][playerid];
			if(PermissionTracking(playerid, giveplayerid)) return 1;

			new unixtime = gettime();
            new string[120];
			if(listitem == 0) // Жучок на Смартфон
			{
				if(get_invent4(giveplayerid, 26, 0) == 0) return ErrorMessage(playerid, "{FF6347}У него нет смартфона");
				if(get_para(giveplayerid, 26) == 1) return ErrorMessage(playerid, "{FF6347}Его смартфон сломан");
				if(PlayerInfo[giveplayerid][pTrackSm] >= unixtime)
				{
					format(string,sizeof(string),"[ Мысли ]: Я переустановил%s жучок на {ff9000}смартфоне {99ff66}%s", gender(playerid), rpplayername(giveplayerid));
                    SendClientMessage(playerid, COLOR_GREY, string);
					SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Время действия в системе слежения FBI: {ff9000}10 дней");
				}
				else
				{
					format(string,sizeof(string),"[ Мысли ]: Я установил%s жучок на {ff9000}смартфон {99ff66}%s", gender(playerid), rpplayername(giveplayerid));
                    SendClientMessage(playerid, COLOR_GREY, string);
					SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Время действия в системе слежения FBI: {ff9000}10 дней");
				}
				if(PlayerInfo[giveplayerid][pLeader] != 8 && PlayerInfo[giveplayerid][pMember] != 8) PlayerInfo[giveplayerid][pTrackSm] = gettime()+604800;
				PlayerPlaySound(playerid,6400,0,0,0);
				ApplyAnimation(playerid,"DEALER","DRUGS_BUY",4.0, false, false, false, false, false);
			}
			if(listitem == 1) // Жучок на Рацию
			{
				if(get_invent4(giveplayerid, 21, 0) == 0) return ErrorMessage(playerid, "{FF6347}У него нет рации");
				if(get_para(giveplayerid, 21) == 1) return ErrorMessage(playerid, "{FF6347}Его рация сломана");
				if(PlayerInfo[giveplayerid][pTrackRac] >= unixtime)
				{
					format(string,sizeof(string),"[ Мысли ]: Я переустановил%s жучок на {ff9000}рации {99ff66}%s", gender(playerid), rpplayername(giveplayerid));
                    SendClientMessage(playerid, COLOR_GREY, string);
					SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Время действия в системе слежения FBI: {ff9000}10 дня");
				}
				else
				{
					format(string,sizeof(string),"[ Мысли ]: Я установил%s жучок на {ff9000}рации {99ff66}%s", gender(playerid), rpplayername(giveplayerid));
                    SendClientMessage(playerid, COLOR_GREY, string);
					SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Время действия в системе слежения FBI: {ff9000}10 дня");
				}
				if(PlayerInfo[giveplayerid][pLeader] != 8 && PlayerInfo[giveplayerid][pMember] != 8) PlayerInfo[giveplayerid][pTrackRac] = gettime()+604800;
				PlayerPlaySound(playerid,6400,0,0,0);
				ApplyAnimation(playerid,"DEALER","DRUGS_BUY",4.0, false, false, false, false, false);
			}
		}
	}
    return 1;
}

stock SettingTransmitter(playerid)
{
    new line[214],lines[2096];

    format(line,sizeof(line),"Каналы"), strcat(lines,line);
    for(new i = 0; i < sizeof(TransmitterName); i++)
    {
        format(line,sizeof(line),"\n{ff9000}%s",TransmitterName[i]), strcat(lines,line);
    }
    ShowDialog(playerid,490,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Настройки Чата",lines,"Выбор","Отмена");
    return 1;
}

stock MenuSettingTransmitter(playerid, tid)
{
    new line[214],lines[2096];
    format(line,sizeof(line),"{ff9000}%s", TransmitterName[tid]), strcat(lines,line);

    // Переключение отображения и доступа к чату
    if(PlayerInfo[playerid][pTransmitterOff][tid] == false) format(line,sizeof(line),"\n{cccccc}Статус: {99ff66}[ On ]"), strcat(lines,line);
    else format(line,sizeof(line),"\n{cccccc}Статус: {FF6347}[ Off ]"), strcat(lines,line);

    // Дополнительные настройки чата
    if(tid == 0) // "Рация организации /r /rb"
    {
        new g = PlayerInfo[playerid][pRacOrg][0];
        format(line,sizeof(line),"\n{cccccc}Канал: %s", fraklastName[g]), strcat(lines,line);
    }
    else if(tid == 1) // "Рация /d /db /u /ub"
    {
        new g = PlayerInfo[playerid][pRacDep][0];
        format(line,sizeof(line),"\n{cccccc}Канал: %s", fraklastName[g]), strcat(lines,line);
    }
    else if(tid == 2) // "Рация подфракции /i /ib"
    {
        new g = PlayerInfo[playerid][pRacDiv][0];
        new i = PlayerInfo[playerid][pRacDiv][1];
        if(g > 0 && i > 0 && g <= MAX_ORG && i <= MAX_DIVISION_ORG) format(line,sizeof(line),"\n{cccccc}Канал: %s {%s}[ %s ]", fraklastName[g], DivisionInfo[g - 1][i - 1][divColorHex], DivisionInfo[g - 1][i - 1][divAbbreviation]), strcat(lines,line);
        else format(line,sizeof(line),"\n{cccccc}Канал: нет"), strcat(lines,line);
    }
    ShowDialog(playerid,491,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Настройки Рации",lines,"Выбор","Отмена");
    return 1;
}

stock SettingChannelTransmitter(playerid, tid)
{
    new line[214], lines[2096], quan;
    format(line,sizeof(line),"{ff9000}%s", TransmitterName[tid]), strcat(lines,line);

    DP[0][playerid] = tid;

    if(tid == 0) // "Рация организации /r /rb"
    {
        for(new g = 0; g < MAX_ORG; g++)
        {
            List[g][playerid] = 0;
            if(IsAllowedTransmitterR(playerid, g)) 
            {
                format(line,sizeof(line),"\n%s", fraklastName[g]), strcat(lines,line);
                List[quan][playerid] = g;
                quan ++;
            }
        }
    }
    else if(tid == 1) // "Рация /d /db /u /ub"
    {
        for(new g = 0; g < MAX_ORG; g++)
        {
            List[g][playerid] = 0;
            if(IsAllowedTransmitterD(playerid, g)) 
            {
                format(line,sizeof(line),"\n%s", fraklastName[g]), strcat(lines,line);
                List[quan][playerid] = g;
                quan ++;
            }
        }
    }
    else if(tid == 2) // "Рация подфракции /i /ib"
    {
        new g = fraction(playerid);
        new i = PlayerInfo[playerid][pDivision][0]; // Подфракция
        new ifbi = PlayerInfo[playerid][pDivision][1]; // Подфракция FBI (При внедрении в другую организацию)

        if(i > 0)
        {
            List[quan][playerid] = g;
            ListParam[quan][playerid] = i;
            quan ++;
            format(line,sizeof(line),"\n{cccccc}Подфракция: %s {%s}[ %s ]", fraklastName[g], DivisionInfo[g - 1][i - 1][divColorHex], DivisionInfo[g - 1][i - 1][divAbbreviation]), strcat(lines,line);
        }
        else List[quan][playerid] = 0;

        if(ifbi > 0)
        {
            g = 2;
            List[quan][playerid] = g;
            ListParam[quan][playerid] = ifbi;
            //quan ++;
            format(line,sizeof(line),"\n{cccccc}Подфракция: %s {%s}[ %s ]", fraklastName[g], DivisionInfo[g - 1][ifbi - 1][divColorHex], DivisionInfo[g - 1][ifbi - 1][divAbbreviation]), strcat(lines,line);
        }
        else List[quan][playerid] = 0;
    }
    ShowDialog(playerid,506,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Настройки Рации",lines,"Выбор","Отмена");
    return 1;
}

stock IsAllowedTransmitterR(playerid, g)
{
    if(PlayerInfo[playerid][pSoska] >= 1) // Админам доступны каналы всех организаций
    {
        if(g >= 0 && g <= MAX_ORG) return 1;
    }
    else if(PlayerInfo[playerid][pFbi] > 0) // FBI под прикрытием, своя и FBI
    {
        if(g == 2 || PlayerInfo[playerid][pMember] == g) return 1;
    }
    else if(PlayerInfo[playerid][pMember] == 7) // Правительству все законные организации
    {
        if(GetAccessRankOrgMay(playerid, PlayerInfo[playerid][pMember], 55, NO_FBI))
        {
            if(g == 1 || g == 2 || g == 3 || g == 4 || g == 7 || g == 11 || g == 21 || g == 22) return 1;
        }
    }
    else // Всем прочим только организация, в которой игрок состоит
    {
        if(PlayerInfo[playerid][pMember] == g) return 1;
    }
    return 0;
}

stock IsAllowedTransmitterD(playerid, g)
{
    if(PlayerInfo[playerid][pSoska] >= 1) // Админам доступны каналы всех организаций
    {
        if(g >= 0 && g <= MAX_ORG) return 1;
    }
    else if(PlayerInfo[playerid][pFbi] > 0) // FBI под прикрытием, своя и FBI
    {
        if(g == 2 || PlayerInfo[playerid][pMember] == g) return 1;
    }
    else // Всем прочим только организация, в которой игрок состоит
    {
        if(PlayerInfo[playerid][pMember] == g) return 1;
    }
    return 0;
}

// Новый сток загрузки настроек рации
stock OnPlayerLoadTransmitter(playerid)
{
    new bool:is_null;
    cache_is_value_name_null(0, "pTransmitter", is_null);

    if(is_null == false)
    {
        new string_json[512];
        cache_get_value_name(0, "pTransmitter", string_json, 512);

        new JsonNode:node = JSON_INVALID_NODE;
        if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
        {
            for(new i = 0; i < MAX_TRANSMITTER; i++)
	        {
                new string[6];
                format(string, sizeof(string), "t%d", i);
                JSON_GetBool(node, string, PlayerInfo[playerid][pTransmitterOff][i]);
            }
        }
    }
	return 1;
}

stock SaveTransmitterOff(playerid)
{
    PlayerInfo[playerid][pTransmitterUpdate] = false;

    new JsonNode:node = JSON_Object(
		"t0", JSON_Bool(PlayerInfo[playerid][pTransmitterOff][0]),
        "t1", JSON_Bool(PlayerInfo[playerid][pTransmitterOff][1]),
        "t2", JSON_Bool(PlayerInfo[playerid][pTransmitterOff][2]),
        "t3", JSON_Bool(PlayerInfo[playerid][pTransmitterOff][3]),
        "t4", JSON_Bool(PlayerInfo[playerid][pTransmitterOff][4]),
        "t5", JSON_Bool(PlayerInfo[playerid][pTransmitterOff][5]),
        "t6", JSON_Bool(PlayerInfo[playerid][pTransmitterOff][6]),
        "t7", JSON_Bool(PlayerInfo[playerid][pTransmitterOff][7]),
        "t8", JSON_Bool(PlayerInfo[playerid][pTransmitterOff][8]),
        "t9", JSON_Bool(PlayerInfo[playerid][pTransmitterOff][9])
	);

    new string_json[512];
    if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
    {
        new string_mysql[640];
        mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_igroki` SET `pTransmitter`= '%e' WHERE `user_id` = '%d'", string_json, PlayerInfo[playerid][pID]);
        mysql_tquery(pearsq, string_mysql);
    }
	return 1;
}

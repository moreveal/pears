
/* Как добавить новый канал или рацию в настройку?
1. Плюсуем дефайн MAX_TRANSMITTER
2. Добавляем название рации в TransmitterName
3. Топаем в stock MenuSettingTransmitter и с него начинаем по цепочке редактировать всё что необходимо
*/

new TransmitterName[][] =
{
    "Рация /r /rb", "Рация /d /db /u /ub", "Рация /i /ib", "Рация /f /fb", "Действия Администрации", "Волна Преступлений", "Чат Администрации /a",
    "Чат Медиа /y"
};

stock checkTransmitterPermission(playerid) // Проверки разрешений рации (чтобы не дублировать одну и ту-же херню в каждую команду)
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
    if(writeRac == 0 || g == 0) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к каналу организации");
	if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Канал рации организации /r или /rb текст");

    if(checkTransmitterOrgMute(playerid)) return 1; // Проверка мута рации организации
	if(antiflood(playerid, params) == 1) return 1; // Антифлуд

    new nameRank[MAX_NAME_LENGTH], nameAbb[MAX_NAME_DIVISION_ABBREVIATION_LENGTH];
    if(g == 2 && PlayerInfo[playerid][pFbi] > 0) // Получаем ранг FBI под прикрытием в своём чате
    {
        format(nameRank,sizeof(nameRank), "%s", getNameRankOrganization(g, PlayerInfo[playerid][pDivision][1], PlayerInfo[playerid][pFbi]));
        format(nameAbb,sizeof(nameAbb), "%s", getNameAbbreviationOrganization(playerid, g, 1));
    }
    else // Получаем ранг организации с учётом подфракции
    {
        format(nameRank,sizeof(nameRank), "%s", getNameRank(playerid));
        format(nameAbb,sizeof(nameAbb), "%s", getNameAbbreviation(playerid));
    }

    new string[240];
    if(IsADepartID(g)) // Законные организации
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
CMD:u(playerid, const params[]) return cmd_d(playerid, params);
CMD:d(playerid, const params[])
{
	commandD(playerid, 0, params);
	return 1;
}
CMD:ub(playerid, const params[]) return cmd_db(playerid, params);
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
    if(writeRac == 0 || g == 0) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к общему каналу");
	if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Общий канал организаций /d /u или /db /ub текст");

    if(checkTransmitterOrgMute(playerid)) return 1; // Проверка мута рации организации
	if(antiflood(playerid, params) == 1) return 1; // Антифлуд

    new nameRank[MAX_NAME_LENGTH], nameAbb[MAX_NAME_DIVISION_ABBREVIATION_LENGTH];
    if(g == 2 && PlayerInfo[playerid][pFbi] > 0) // Получаем ранг FBI под прикрытием в своём чате
    {
        format(nameRank,sizeof(nameRank), "%s", getNameRankOrganization(g, PlayerInfo[playerid][pDivision][1], PlayerInfo[playerid][pFbi]));
        format(nameAbb,sizeof(nameAbb), "%s", getNameAbbreviationOrganization(playerid, g, 1));
    }
    else // Получаем ранг организации с учётом подфракции
    {
        format(nameRank,sizeof(nameRank), "%s", getNameRank(playerid));
        format(nameAbb,sizeof(nameAbb), "%s", getNameAbbreviation(playerid));
    }

    if(IsAGangID(g)) // Банды
    {
	    if(!GetAccessRankOrg(playerid, g, 39, NO_FBI)) return 1;
    }        

    if(IsADepartID(g) || IsAGangID(g) || IsAMafiaID(g))
    {
        new string[240];
        new maxRank = get_maxrank(g);
        if(PlayerInfo[playerid][pRank] >= maxRank-1) // Лидеры и Замы
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
    if(writeRac == 0 || g == 0 || i == 0) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к каналу подфракции");
	if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Канал рации подфракции /i или /ib текст");

    if(checkTransmitterOrgMute(playerid)) return 1; // Проверка мута рации организации
	if(antiflood(playerid, params) == 1) return 1; // Антифлуд

    new nameRank[MAX_NAME_LENGTH];
    if(g == 2 && PlayerInfo[playerid][pFbi] > 0) // Получаем ранг FBI под прикрытием в своём чате
    {
        format(nameRank,sizeof(nameRank), "%s", getNameRankOrganization(g, PlayerInfo[playerid][pDivision][1], PlayerInfo[playerid][pFbi]));
    }
    else // Получаем ранг организации с учётом подфракции
    {
        format(nameRank,sizeof(nameRank), "%s", getNameRank(playerid));
    }

    new string[240];
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
	if(antiflood(playerid, params) == 1) return 1; // Антифлуд

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
    else if(g > 0) format(nameRank,sizeof(nameRank), getNameRankOrganization(g, PlayerInfo[playerid][pDivision][0], PlayerInfo[playerid][pRank]));
    else format(nameRank,sizeof(nameRank), "None");
    return nameRank;
}
stock getNameRankOrganization(g, i, r) // Получаем название ранга внутри организации (с учётом подфракции)
{
    new nameRank[MAX_NAME_LENGTH];
    if(i > 0)  // Если состоит в подфракции
    {
        g -= 1, i -= 1, r -= 1; // Исправления, для корректного получения названий переменных
        format(nameRank,sizeof(nameRank), DivisionRankName[g][i][r]);
    }
    else 
    {
        r -= 1; // Исправления, для корректного получения названий переменных
        format(nameRank,sizeof(nameRank), RankOrg[g][r]);
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
    new PlayerName[24];
	if(PlayerInfo[playerid][pLeader] == 8 || PlayerInfo[playerid][pMember] == 8) // ICA
	{
		if(PlayerInfo[playerid][pSignTransmitter] == false) format(PlayerName,sizeof(PlayerName), "%s[%d]", PlayerInfo[playerid][pName], playerid); // Включено отображением имени
		else format(PlayerName,sizeof(PlayerName), PlayerInfo[playerid][pCallSign]); // Отображение имени выключено, значит всегда видно только звание (позывной)
	}
	else format(PlayerName,sizeof(PlayerName), "%s[%d]", PlayerInfo[playerid][pName], playerid);
	return PlayerName;
}

stock IsADepartID(g) // Получение списка законных организаций, которые видят /d чат департамента
{
    if(g == 1 || g == 2 || g == 3 || g == 4 || g == 7 || g == 9 || g == 11 || g == 21 || g == 22) return 1;
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
			if(OnlineInfo[i][oLogged] == 0) continue; // Не залогинился - игнорим
			if(PlayerInfo[i][pBkyrenie] >= 2) continue; // В космосе - игнорим
            if(PlayerInfo[i][pTransmitterOff][0] == true) continue; // Канал выключен - игнорим

			if(PlayerInfo[i][pRacOrg][0] == g) // Показываем только тем, кто читает эту рацию (Не важно, каким образом он её читает)
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
        if(OnlineInfo[i][oLogged] == 0) continue; // Не залогинился - игнорим
        if(PlayerInfo[i][pBkyrenie] >= 2) continue; // В космосе - игнорим
        if(PlayerInfo[i][pTransmitterOff][1] == true) continue; // Канал выключен - игнорим
        if(PlayerInfo[i][pRacDep][0] == 0) continue; // Не читаем никакую рацию - игнорим

        if(IsADepartID(PlayerInfo[i][pRacDep][0])) // Показываем только тем, кто читает эту рацию (Не важно, каким образом он её читает)
        {
            SendClientMessage(i, color, string);
        }
    }
}
function SendGangMessage(color, const string[]) // Общий чат банд (Кто будет видеть отправленное сообщение)
{
    foreach (Player, i)
    {
        if(OnlineInfo[i][oLogged] == 0) continue; // Не залогинился - игнорим
        if(PlayerInfo[i][pBkyrenie] >= 2) continue; // В космосе - игнорим
        if(PlayerInfo[i][pTransmitterOff][1] == true) continue; // Канал выключен - игнорим
        if(PlayerInfo[i][pRacDep][0] == 0) continue; // Не читаем никакую рацию - игнорим

        if(IsAGangID(PlayerInfo[i][pRacDep][0])) // Показываем только тем, кто читает эту рацию (Не важно, каким образом он её читает)
        {
            SendClientMessage(i, color, string);
        }
    }
}
function SendMafiaMessage(color, const string[]) // Общий чат мафий (Кто будет видеть отправленное сообщение)
{
    foreach (Player, i)
    {
        if(OnlineInfo[i][oLogged] == 0) continue; // Не залогинился - игнорим
        if(PlayerInfo[i][pBkyrenie] >= 2) continue; // В космосе - игнорим
        if(PlayerInfo[i][pTransmitterOff][1] == true) continue; // Канал выключен - игнорим
        if(PlayerInfo[i][pRacDep][0] == 0) continue; // Не читаем никакую рацию - игнорим

        if(IsAMafiaID(PlayerInfo[i][pRacDep][0])) // Показываем только тем, кто читает эту рацию (Не важно, каким образом он её читает)
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
			if(OnlineInfo[i][oLogged] == 0) continue; //  Не залогинился - игнорим
			if(PlayerInfo[i][pBkyrenie] >= 2) continue; // В космосе - игнорим
            if(PlayerInfo[i][pTransmitterOff][2] == true) continue; // Канал выключен - игнорим
            if(PlayerInfo[i][pRacDiv][0] == 0 || PlayerInfo[i][pRacDiv][1] == 0) continue; // Не читаем никакую рацию - игнорим

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
        if(OnlineInfo[i][oLogged] == 0) continue; // Не залогинился - игнорим
		if(PlayerInfo[i][pBkyrenie] >= 2) continue; // В космосе - игнорим
        if(PlayerInfo[i][pTransmitterOff][3] == true) continue; // Канал выключен - игнорим

		if(PlayerInfo[i][pFamily] == f) SendClientMessage(i, color, string);
	}
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
        else cmd_mm(playerid);
    }
    else if(dialogid == 491)
    {
        if(response)
        {
            new tid = DP[0][playerid];
            if(listitem == 0)
            {
                if(PlayerInfo[playerid][pTransmitterOff][tid] == false) PlayerInfo[playerid][pTransmitterOff][tid] = true;
                else PlayerInfo[playerid][pTransmitterOff][tid] = false;
                MenuSettingTransmitter(playerid, tid);
            }
            else if(listitem == 1) SettingChannelTransmitter(playerid, tid);
        }
        else SettingTransmitter(playerid);
    }
    else if(dialogid == 506)
    {
        new tid = DP[0][playerid];
        if(response)
        {
            if(listitem < 0 || listitem >= MAX_ORG) return 1;
            new g = List[listitem][playerid];
            if(g == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Не получен id организации");

            if(tid == 0) // "Рация /r /rb"
            {
                PlayerInfo[playerid][pRacOrg][0] = g;
                PlayerInfo[playerid][pRacOrg][1] = g;
            }
            else if(tid == 1) // "Рация /d /db /u /ub"
            {
                PlayerInfo[playerid][pRacDep][0] = g;
                PlayerInfo[playerid][pRacDep][1] = g;
            }
            MenuSettingTransmitter(playerid, tid);
            PlayerPlaySound(playerid,6401,0,0,0);
        }
        else MenuSettingTransmitter(playerid, tid);
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

    if(PlayerInfo[playerid][pTransmitterOff][tid] == false) format(line,sizeof(line),"\n{cccccc}Статус: {99ff66}[ On ]"), strcat(lines,line);
    else format(line,sizeof(line),"\n{cccccc}Статус: {FF6347}[ Off ]"), strcat(lines,line);

    if(tid == 0) // "Рация /r /rb"
    {
        new g = PlayerInfo[playerid][pRacOrg][0];
        format(line,sizeof(line),"\n{cccccc}Канал: %s", frakeasyName[g]), strcat(lines,line);
    }
    else if(tid == 1) // "Рация /d /db /u /ub"
    {
        new g = PlayerInfo[playerid][pRacDep][0];
        format(line,sizeof(line),"\n{cccccc}Канал: %s", frakeasyName[g]), strcat(lines,line);
    }
    else if(tid == 2) // "Рация /i /ib"
    {
        new g = PlayerInfo[playerid][pRacDiv][0];
        new i = PlayerInfo[playerid][pRacDiv][1];
        format(line,sizeof(line),"\n{cccccc}Канал: %s {%s}[ %s ]", frakeasyName[g], DivisionInfo[g - 1][i - 1][divColorHex], DivisionInfo[g - 1][i - 1][divAbbreviation]), strcat(lines,line);
    }
    ShowDialog(playerid,491,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Настройки Рации",lines,"Выбор","Отмена");
    return 1;
}

stock SettingChannelTransmitter(playerid, tid)
{
    new line[214], lines[2096], quan;
    format(line,sizeof(line),"{ff9000}%s", TransmitterName[tid]), strcat(lines,line);

    if(tid == 0) // "Рация /r /rb"
    {
        for(new g = 1; g < MAX_ORG; g++)
        {
            List[g][playerid] = 0;
            if(IsAllowedTransmitterR(playerid, g)) 
            {
                format(line,sizeof(line),"\n%s", frakeasyName[g]), strcat(lines,line);
                List[quan][playerid] = g;
                quan ++;
            }
        }
    }
    else if(tid == 1) // "Рация /d /db /u /ub"
    {
        for(new g = 1; g < MAX_ORG; g++)
        {
            List[g][playerid] = 0;
            if(IsAllowedTransmitterD(playerid, g)) 
            {
                format(line,sizeof(line),"\n%s", frakeasyName[g]), strcat(lines,line);
                List[quan][playerid] = g;
                quan ++;
            }
        }
    }
    ShowDialog(playerid,506,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Настройки Рации",lines,"Выбор","Отмена");
    return 1;
}

stock IsAllowedTransmitterR(playerid, g)
{
    if(PlayerInfo[playerid][pSoska] >= 1) // Админам доступны каналы всех организаций
    {
        if(g >= 1 && g <= MAX_ORG) return 1;
    }
    else if(PlayerInfo[playerid][pFbi] > 0) // FBI под прикрытием, своя и FBI
    {
        if(g == 2 || PlayerInfo[playerid][pMember] == g) return 1;
    }
    else if(PlayerInfo[playerid][pMember] == 7) // Правительству все законные организации
    {
        if(GetAccessRankOrgMay(playerid, PlayerInfo[playerid][pMember], 55, NO_FBI))
        {
            if(g == 1 || g == 2 || g == 3 || g == 4 || g == 7 || g == 9 || g == 11 || g == 21 || g == 22) return 1;
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
        if(g >= 1 && g <= MAX_ORG) return 1;
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
/*
pRacOrg[2], // Чтение рации организации (1 - возможность написать в рацию)
	pRacDep[2], // Чтение рации общей (1 - возможность написать в рацию)
	pRacDiv[3], // Чтение рации подфракции (2 - возможность написать в рацию)
    
new TransmitterName[][] =
{
    "Рация /r /rb", "Рация /d /db /u /ub", "Рация /i /ib", "Рация /f /fb", "Действия Администрации", "Волна Преступлений", "Чат Администрации /a",
    "Чат Медиа /y"
};

stock SettingTransmitter(playerid)
{
    new line[214],lines[2096];

    format(line,sizeof(line),"Каналы"), strcat(lines,line);
    for(new i = 0; i < sizeof(TransmitterName); i++)
    {
        format(line,sizeof(line),"\n{ff9000}%s",TransmitterName[i]), strcat(lines,line);
    }
    ShowDialog(playerid,490,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Настройки Рации",lines,"Выбор","Отмена");
    return 1;
}*/

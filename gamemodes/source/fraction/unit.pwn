
/*
Как добавить новую настройку юнитов?
1. Добавляем в MAX_UNIT (В базе до gUnit 50 уже добавлено)
2. Прописываем название в unitName
3. Прописываем дефолт значение в unitDefault
4. К какой организации принадлежит эта настройка в stock IsAUnitOrganization
5. 
*/

new unitName[][] = // Названия настроек юниты
{
    "Доставка ящика на склад", // 0
    "1 минута на блок посту", // 1
    "RP Арест", // 2
    "Non RP Арест", // 3
    "Возвращение украденного предмета", // 4
    "Килл на капте", // 5
    "Урон за 1 хп на капте", // 6
    "Арест недвижимости", // 7
    "Арест бизнеса", // 8
    "Рассмотрение установки бизнеса", // 9
    "Диагноз пациенту", // 10
    "Угон транспорта", // 11
    "Найденный угнанный транспорт", // 12
    "Закрытие судебного дела", // 13 -
    "Создание автобусного маршрута", // 14 -
    "Доставка боеприпасов", // 15 -
    "Покраска граффити", // 16 -
    "Закрытие вызова", // 17
    "Снятие денег с бизнеса", // 18
    "Участие в стреле", // 19
    "Участие в захвате порта", // 20
    "Реанимация пострадавшего", // 21
    "Лечение /heal", // 22
    "Оформление автомобильных номеров", // 23
    "Фиксирование нарушений скоростного режима", // 24
    "Обработанное объявление", // 25
    "Обработанное премиум объявление" // 26
};

new unitDefault[] =
{
    1, // 0
    200, // 1
    3000, // 2
    100, // 3
    5000, // 4
    100, // 5
    1, // 6
    5000, // 7
    5000, // 8
    3000, // 9
    1000, // 10
    5000, // 11
    5000, // 12
    1000, // 13
    10000, // 14
    5000, // 15
    500, // 16
    1500, // 17
    1000, // 18
    15000, // 19
    15000, // 20
    3000, // 21
    700, // 22
    400, // 23
    50, // 24
    500, // 25
    1000 // 26
};

stock IsAUnitOrganization(unitid, fraction, playerid)
{
    switch (unitid) {
        case 0: return fraction != 9; // Доставка ящика на склад своей организации (Доступно всем, кроме CNN)
        case 1..4: return IsPoliceMember(playerid); // 1 минута на блок посту; RP/NRP арест; Возвращение украденного предмета
        case 5, 6: return IsAGangCapt(playerid); // Килл на капте, Урон за 1хп на капте
        case 7: return IsAFunctionOrganization(57, fraction, playerid) && GetAccessRankOrgMay(playerid, fraction, 57, NO_FBI); // Арест недвижимости
        case 8: return IsAFunctionOrganization(58, fraction, playerid) && GetAccessRankOrgMay(playerid, fraction, 58, NO_FBI); // Арест бизнеса
        case 9: return IsAFunctionOrganization(60, fraction, playerid) && GetAccessRankOrgMay(playerid, fraction, 60, NO_FBI); // Рассмотрение установки бизнеса
        case 10: return fraction == 4; // Диагноз пациенту
        case 11: return IsGangMember(playerid) || IsMafiaMember(playerid); // Угон транспорта
        case 12: return IsPolice(fraction); // Найденный транспорт
        case 13: return fraction == 7 && PlayerInfo[playerid][pDivision] == 1; // Рассмотрение заявки в суд (Дополнить покумекав с Владом как правильно!)
        case 14: return fraction == 7; // Создание автобусного маршрута
        case 15: return fraction == 3; // Доставка БП у NGSA
        case 16: return IsGangMember(playerid); // Покраска граффити
        case 17: return IsPoliceMember(playerid); // Закрытие вызова
        case 18..20: return IsMafiaMember(playerid); // Снятие денег с бизнеса; Стрела; Порт
        case 21, 22: return fraction == 4; // Реанимация пострадавшего; Лечение [/heal]
        case 23, 24: return IsPoliceMember(playerid); // Оформление автомобильных номеров; Фиксирование нарушений скоростного режима
        case 25, 26: return fraction == 9; // Обработанное объявление
    }

    return 0;
}

stock GiveUnit(playerid, unitid) // ВНИМАНИЕ! unitid - тут мы выдаём юниты по id из системы юнитов
{
    if(IsAUnitOrganization(unitid, PlayerInfo[playerid][pMember], playerid))
    {
        GivePlayerUnit(playerid, OrganInfo[PlayerInfo[playerid][pMember]][gUnit][unitid]);
    }
    return 1;
}

stock GivePlayerUnit(playerid, unit) // ВНИМАНИЕ! unit - тут мы выдаём напрямую количество юнитов
{
	if(unit == 0) return 1; // Если вдруг юниты не были настроены, отменяем выдачу

	PlayerInfo[playerid][pUnit] += unit;

	new string[80];
	if(unit > 0) 
	{
		format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Unit: ~w~+%d", unit);
		GameTextForPlayer(playerid,string,3000,3);
	}
	else if(unit < 0)
	{
		format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Unit: ~r~-%d", unit);
		GameTextForPlayer(playerid,string,3000,3);
	}

	mysql_save(playerid, 41);
	return 1;
}

CMD:jac(playerid) // Меню настроек оплаты (Юниты)
{
	if(PlayerInfo[playerid][pLeader] <= 0) return ErrorText(playerid, "{FF6347}Вы не лидер организации"), showDialogOrganizationMenu(playerid);

    new player_fraction = PlayerInfo[playerid][pMember];
    DP[0][playerid] = 0;
 	DP[1][playerid] = player_fraction;
	for(new i = 0; i < 200; i++) List[i][playerid] = 0; // Очищаем list
	
    new line[214],lines[4096];
    format(line,sizeof(line),"{cccccc}Интервал вывода юнитов \t{0088ff}1 раз в %d дней\n", OrganInfo[player_fraction][gUnitStat][3]), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Макс. сумма вывода\t{99ff66}%d$\n", OrganInfo[player_fraction][gUnitStat][4]), strcat(lines,line);

    for(new unitid = 0; unitid < sizeof(unitName); unitid++)
    {
        if(IsAUnitOrganization(unitid, player_fraction, playerid)) format(line,sizeof(line), detail_jac(playerid, unitid)), strcat(lines,line);
    }
    new header[60];
    format(header,sizeof(header),"{cccccc}Настройки Unit: %s", fraklastName[player_fraction]);
	ShowDialog(playerid,642,DIALOG_STYLE_TABLIST,header,lines,"Выбрать","Отмена");
   	return 1;
}

stock detail_jac(playerid, detail)
{
    List[DP[0][playerid]][playerid] = detail;
    DP[0][playerid] += 1;
    new text[84];

    format(text, sizeof(text), "{cccccc}%s \t{9900ff}[ %dU ]\n", unitName[detail], OrganInfo[DP[1][playerid]][gUnit][detail]);
	return text;
}

stock showDialogSettingUnit(playerid, unitid)
{
    DP[0][playerid] = unitid;
    new g = DP[1][playerid];

    new line[120],lines[1200];
    format(line,sizeof(line), "{cccccc}Настройка: {9900ff}%s", unitName[unitid]), strcat(lines,line);
    format(line,sizeof(line), "\n{cccccc}Текущее количество юнитов: %dU", OrganInfo[g][gUnit][unitid]), strcat(lines,line);
    if(unitid == 0)
    {
        format(line,sizeof(line),"\n{cccccc}Патроны, Вещества - количество в ящике умножается на {9900ff}значение юнитов\n"), strcat(lines,line);
		format(line,sizeof(line),"\n{cccccc}Броня, Оружие - 1 предмет в ящике умножается на 1000 и на {9900ff}значение юнитов\n"), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}Аптечки, Бинты - 1 предмет в ящике умножается на 100 и на {9900ff}значение юнитов\n"), strcat(lines,line);
    } else if (unitid == 23) {
        format(line,sizeof(line),"\n\n{cccccc}Стоимость автомобильного номера делится на 1000 и умножается на {9900ff}значение юнитов\n"), strcat(lines,line);
    } else if (unitid == 24) {
        format(line,sizeof(line),"\n\n{cccccc}Прибыль организации от полученных штрафов делится на 100 и умножается на {9900ff}значение юнитов\n"), strcat(lines,line);
    }

    format(line,sizeof(line), "\n{ff9000}Введите новое значение [ Не меньше 1U и не больше 100.000U ]"), strcat(lines,line);
    format(line,sizeof(line), "\n\n{FF6347}Внимание! Ответственно относитесь к установке юнитов."), strcat(lines,line);
    format(line,sizeof(line), "\n{ffcc66}Участникам вашей организации будут начисляться юниты за выполняемые действия,"), strcat(lines,line);
    format(line,sizeof(line), "\n{ffcc66}но они смогут обменять юниты на деньги только со счёта вашей организации."), strcat(lines,line);
    format(line,sizeof(line), "\n{ffcc66}Участник не сможет получить свою зарплату, если на счету организации"), strcat(lines,line);
    format(line,sizeof(line), "\n{ffcc66}будет недостаточно средств."), strcat(lines,line);
    ShowDialog(playerid,644,DIALOG_STYLE_INPUT,"{cccccc}Настройки Unit", lines, "Принять","Отмена");
    return 1;
}

stock dialogCase_Unit(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == 642)
    {
        if(response)
        {
            if(listitem == 0)
            {
                DP[0][playerid] = 3;
				ShowDialog(playerid,643,DIALOG_STYLE_INPUT,"{cccccc}Настройки Unit",
                    "{cccccc}Введите количество дней через которое участник сможет {ff9000}брать со счёта организации\n{cccccc}Рекомендуется: {9900ff}7",
                    "Принять","Отмена");
            }
            else if(listitem == 1)
            {
                DP[0][playerid] = 4;
				ShowDialog(playerid,643,DIALOG_STYLE_INPUT,"{cccccc}Настройки Unit",
                    "{cccccc}Введите максимальную сумму, которую участник сможет {ff9000}брать со счёта организации\n{cccccc}Рекомендуется: {99ff66}300.000$",
                    "Принять","Отмена");
            }
            else
            {
                if(listitem >= 200) return 1;
                new unitid = List[listitem - 2][playerid];
                showDialogSettingUnit(playerid, unitid);
            }
        }
        else showDialogOrganizationMenu(playerid);
        return 1;
    }
    else if(dialogid == 643)
    {
        if(response)
        {
			if(!strlen(inputtext)) return pc_cmd_jac(playerid);
			new fr = strval(inputtext);
			if(DP[0][playerid] == 3 || DP[0][playerid] == 4)
			{
                new atext[30], g = PlayerInfo[playerid][pMember];
				if(DP[0][playerid] == 3)
				{
					if(fr > 30 || fr < 0) return ErrorText(playerid, "[ Мысли ]: Ограничение вывода средств по суткам [ 0 - 30 дней ]"), pc_cmd_jac(playerid);
                    atext = "Интервал вывода";
				}
				if(DP[0][playerid] == 4)
				{
					if(fr > 10000000 || fr < 1) return ErrorText(playerid, "[ Мысли ]: Максимальная сумма вывода [ 1 - 10.000.000$ ]"), pc_cmd_jac(playerid);
					atext = "Макс. сумма вывода";
				}
				OrganInfo[g][gUnitStat][DP[0][playerid]] = fr;
				SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Настройки оплаты [ {0088ff}%s {cccccc}] установлено: {ff9000}%d", atext, fr);
				OrgLog(g, "jac", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fr, atext);
				SaveOrganUnit(g, DP[0][playerid]);
				PlayerPlaySound(playerid,6401,0,0,0);
				pc_cmd_jac(playerid);
			}
        }
        else pc_cmd_jac(playerid);
        return 1;
    }
    else if(dialogid == 644)
    {
        if(response)
        {
			if(!strlen(inputtext)) return pc_cmd_jac(playerid);
			new fr = strval(inputtext);
            new g = PlayerInfo[playerid][pMember];
            new unitid = DP[0][playerid];
            
            OrganInfo[g][gUnit][unitid] = fr;
            SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Настройки оплаты [ {0088ff}%s {cccccc}] установлено: {ff9000}%d", unitName[unitid], fr);
            OrgLog(g, "jac", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fr, unitName[unitid]);
            SaveUnit(g, unitid);
            PlayerPlaySound(playerid,6401,0,0,0);
            pc_cmd_jac(playerid);
        }
        else pc_cmd_jac(playerid);
        return 1;
    }
    return 0;
}

// Загрузка новых юнитов из базы
stock OnLoadUnitSetting(idx, f)
{
    new string[20];
    for(new i = 0; i < sizeof(unitDefault); i++)
    {
        format(string, sizeof(string), "gUnit%d", i);
        cache_get_value_name_int(f, string, OrganInfo[idx][gUnit][i]);
    }
    return 1;
}

// Сохраняем все новые юниты
stock SaveUnitAll(idx)
{
    for(new i = 0; i < sizeof(unitDefault); i++) SaveUnit(idx, i);
    return true;
}

// Сохранение новых юнитов
stock SaveUnit(idx, unitid)
{
	new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_organization` SET `gUnit%d`='%d' WHERE `frakid`='%d'", 
        unitid, OrganInfo[idx][gUnit][unitid], idx);
	query_empty(pearsq, string_mysql);
	return true;
}

// Сохранение старых настроек юнитов
stock SaveOrganUnit(idx, unitid)
{
	new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_organization` SET `unitstat%d`='%d' WHERE `frakid`='%d'", 
        unitid, OrganInfo[idx][gUnitStat][unitid], idx);
	query_empty(pearsq, string_mysql);
	return true;
}

// Сохранение всех старых настроек юнитов
stock SaveOrganUnitAll(idx)
{
	new string_mysql[1800];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_organization` SET `unitstat0`='%d',`unitstat1`='%d',\
	`unitstat2`='%d',`unitstat3`='%d',`unitstat4`='%d',`unitstat5`='%d',`unitstat6`='%d',`unitstat7`='%d',`unitstat8`='%d',`unitstat9`='%d',",OrganInfo[idx][gUnitStat][0],OrganInfo[idx][gUnitStat][1],
	OrganInfo[idx][gUnitStat][2],OrganInfo[idx][gUnitStat][3],OrganInfo[idx][gUnitStat][4],OrganInfo[idx][gUnitStat][5],OrganInfo[idx][gUnitStat][6],OrganInfo[idx][gUnitStat][7],OrganInfo[idx][gUnitStat][8],OrganInfo[idx][gUnitStat][9]);
	format(string_mysql, sizeof(string_mysql), "%s`unitstat10`='%d',`unitstat11`='%d',`unitstat12`='%d',`unitstat13`='%d',`unitstat14`='%d',`unitstat15`='%d',`unitstat16`='%d',`unitstat17`='%d',`unitstat18`='%d',\
	`unitstat19`='%d',`unitstat20`='%d',`unitstat21`='%d',`unitstat22`='%d',`unitstat23`='%d' WHERE `frakid`='%d'",  string_mysql,
	OrganInfo[idx][gUnitStat][10],OrganInfo[idx][gUnitStat][11],OrganInfo[idx][gUnitStat][12],OrganInfo[idx][gUnitStat][13],OrganInfo[idx][gUnitStat][14],OrganInfo[idx][gUnitStat][15],OrganInfo[idx][gUnitStat][16],OrganInfo[idx][gUnitStat][17],
	OrganInfo[idx][gUnitStat][18],OrganInfo[idx][gUnitStat][19],OrganInfo[idx][gUnitStat][20],OrganInfo[idx][gUnitStat][21],OrganInfo[idx][gUnitStat][22],OrganInfo[idx][gUnitStat][23],idx);
	query_empty(pearsq, string_mysql);
	return true;
}

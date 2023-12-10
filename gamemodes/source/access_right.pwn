/*
Как добавить новую команду или функцию в права доступа?
1. Добавляем название в конец accessRightName (Сейчас их в базе до 100 слотов)
2. Добавляем в stock IsAFunctionOrganization по accessId какая организация может использовать эту функцию
3. Добавляем проверку IsAFunctionOrganization в ту команду или функцию, которую мы добавляем (Смотрим пример в CMD:rmute)
4. Добавляем проверку GetAccessRankOrg в ту команду или функцию, которую мы добавляем (Смотрим пример в CMD:rmute)
*/

new accessRightName[][] = // Команды и настройки в организации
{
    "/membersoff", // 0
    "Заказ боеприпасов", // 1 [Department]
    "/nabor", // 2
    "/dip", // 3
    "Счет", // 4
    "Настройки рангов", // 5
    "Просмотр лога", // 6
    "Гараж организации", // 7
	"/invite", // 8
    "/uninvite", // 9
    "/giverank", // 10
    "/vig", // 11
    "/unvig", // 12
    "/rmute", // 13
    "/force", // 14
    "/dismiss", // 15
	"/capture /zahvat", // 16
    "/cob /eob /dob /iob /3d", // 17
    "/endorse", // 18 выдать доступ к помещению
    "/omap управление картами", // 19
    "/payment", // 20
    "Арендованный склад", // 21
    "Настройки одежды", // 22
    "Внесение в ЧС", // 23
    "Исключение из ЧС", // 24
    "/frisk /take", // 25
	"/mafia", // 26 Забить стрелу [Mafia]
    "/gov", // 27
    "/numbercar", // 28
    "/gac настройки склада", // 29
    "/camera", // 30 установить камеру слежения [FBI]
    "/tracking", // 31
    "/su /pursuit", // 32
    "/lawyer", // 33
    "/zarest", // 34
    "/radar", // 35
    "/delradar", // 36
    "/cuff /uncuff", // 37
    "/stun /unstun", // 38
    "/u /ub", // 39
    "Отображение имён", // 40
	"Внесение в ЧС Обр. Центра", // 41
    "Исключение из ЧС Обр. Центра", // 42
    "/callsign", // 43 Изменить позывной [ICA]
    "/ram", // 44 Войти в закрытый дом
    "/access /tank", // 45 Рарешение на транспорт в LSPD, SFPD, LVPD | Доступ к танку в NGSA
    "/arestcar", // 46 арестовать личный транспорт
    "/assent", // 47 выдать разрешение на спец. задание (Увал под прикрытием) [FBI]
    "/setcolor", // 48 использовать цвет другой организации
    "/formavvs", // 49 Надеть форму ВВС [NGSA]
    "/psih", // 50 Отправить на лечение [ASGH]
    "Доставка Боеприпасов", // 51 [NGSA]
    "/appoint", // 52 Назначить лидера [Goverment]
    "/suspend", // 53 Снять лидера [Goverment]
    "/free", // 54 Система освобождения преступников (Адвокаты) (В будущем судьи /judge) [Goverment]
    "/readr", // 55 Использование волны рации другой организации [Goverment]
    "/debt /deprive", // 56 Налоговые должники + изъять задолженность [Goverment]
    "/arestdom", // 57 Арестовать дом [Goverment]
    "/arestbiz", // 58 Арестовать бизнес [Goverment]
    "/arestroom", // 59 Арестовать квартиру [Goverment]
    "/acbiz /denybiz", // 60 Контроль расположения бизнесов [Goverment]
    "/busstop", // 61 Автобусные остановки + сюда маршруты [Goverment]
    "/minfin", // 62 Министерство Финансов [Goverment]
    "/mdc", // 63 База Данных
    "/news", // 64 Вещать в общий чат [CNN]
    "/channel", // 65 Телеканал [CNN]
    "/live", // 66 Интервью [CNN]
    "/hmenu /contractas", // 67 Доступ к меню агенства [ICA]
    "/goc", // 68 Принять контракт [ICA]
    "/givec", // 69 Порушить контракт [ICA]
    "/nametag", // 70 Отключить / Включить никнейм [ICA]
    "/sign" // 71 Сменить имя [ICA]
};

stock IsAFunctionOrganization(accessId, g, playerid) // Права доступа команды или функции на организацию
{
    if(accessId == 1) // 1 Заказ боеприпасов // 1
    {
        if(IsAGunSkladDepart(g)) return 1;
    }
    else if(accessId == 3) // 3 /dip // 3 [Gang Mafia]
    {
        if(IsAGang(playerid) || IsAMafia(playerid)) return 1;
    }
    else if(accessId == 7) // Гараж организации // 7
    {
        if(IsAGang(playerid) || IsAMafia(playerid)) return 1;
    }
    else if(accessId == 16) // /capture /zahvat // 16
    {
        if(IsAGang(playerid)) return 1;
    }
    else if(accessId == 17) // /cob /eob /dob /iob /3d // 17
    {
        if(IsAGang(playerid)) return 1;
    }
    else if(accessId == 18) // /endorse // 18 выдать доступ к помещению
    {
        if(IsAUpdateMapOrganization(g)) return 1;
    }
    else if(accessId == 19) // /omap управление картами // 19
    {
        if(IsAGang(playerid)) return 1;
    }
    else if(accessId == 21) // Арендованный склад // 21
    {
        if(IsAGang(playerid) || IsAMafia(playerid) || g == 8) return 1;
    }
    else if(accessId == 25) // /frisk /take // 25
    {
        if(IsAPoliceFunction(g) || g == 7) return 1;
    }
    else if(accessId == 26) // /mafia", // 26 Забить стрелу [Mafia]
    {
        if(IsAMafia(playerid))  return 1;
    }
    else if(accessId == 27) // /gov", // 27
    {
        if(IsADepart(playerid))  return 1;
    }
    else if(accessId == 28) // /numbercar", // 28
    {
        if(IsAPolice(g))  return 1;
    }
    else if(accessId == 30) // /camera", // 30 установить камеру слежения [FBI]
    {
        if(g == 2)  return 1;
    }
    else if(accessId == 31) // /tracking", // 31
    {
        if(g == 2)  return 1;
    }
    else if(accessId == 32) // /su /pursuit", // 32
    {
        if(IsAPoliceFunction(g))  return 1;
    }
    else if(accessId == 33) // /lawyer", // 33
    {
        if(IsAPoliceFunction(g))  return 1;
    }
    else if(accessId == 34) // /zarest", // 34
    {
        if(IsAPoliceFunction(g))  return 1;
    }
    else if(accessId == 35) // /radar", // 35
    {
        if(IsAPolice(g))  return 1;
    }
    else if(accessId == 36) // /delradar", // 36
    {
        if(IsAPolice(g))  return 1;
    }
    else if(accessId == 37) // /cuff /uncuff", // 37
    {
        if(IsAPoliceFunction(g) || g == 7)  return 1;
    }
    else if(accessId == 38) // /stun /unstun", // 38 [ASGH]
    {
        if(g == 4)  return 1;
    }
    else if(accessId == 39) // /u /ub", // 39
    {
        if(IsAGang(playerid) || IsAMafia(playerid))  return 1;
    }
    else if(accessId == 40) // Отображение имён Вместе с позывными  // 40 [ICA]
    {
        if(g == 8)  return 1;
    }
    else if(accessId == 41) // Внесение в ЧС Обр. Центра", // 41
    {
        if(IsAPoliceFunction(g) || g == 7)  return 1;
    }
    else if(accessId == 42) // Исключение из ЧС Обр. Центра", // 42
    {
        if(IsAPoliceFunction(g) || g == 7)  return 1;
    }
    else if(accessId == 43) // /callsign", // 43 Изменить позывной [ICA]
    {
        if(g == 8)  return 1;
    }
    else if(accessId == 44) // /ram", // 44 Войти в закрытый дом
    {
        if(IsAPoliceFunction(g) || g == 7 || g == 4)  return 1;
    }
    else if(accessId == 45) // /access /tank", // 45 Рарешение на транспорт в LSPD, SFPD, LVPD | Доступ к танку в NGSA
    {
        if(IsAPolice(g) || g == 3)  return 1;
    }
    else if(accessId == 46) // /arestcar", // 46 арестовать личный транспорт
    {
        if(IsAPolice(g) || g == 7 || g == 22)  return 1;
    }
    else if(accessId == 47) // /assent", // 47 выдать разрешение на спец. задание (Увал под прикрытием) [FBI]
    {
        if(g == 2)  return 1;
    }
    else if(accessId == 48) // /setcolor", // 48 использовать цвет другой организации
    {
        if(g == 2 || g == 8 || g == 18)  return 1;
    }
    else if(accessId == 49) // /formavvs", // 49 Надеть форму ВВС [NGSA]
    {
        if(g == 3)  return 1;
    }
    else if(accessId == 50) // /psih", // 50 Отправить на лечение [ASGH]
    {
        if(g == 4)  return 1;
    }
    else if(accessId == 51) // Доставка Боеприпасов" // 51 [NGSA]
    {
        if(g == 3)  return 1;
    }
    else if(accessId >= 52 && accessId <= 62)
    {
        // /appoint", // 52 Назначить лидера [Goverment]
        // /suspend", // 53 Снять лидера [Goverment]
        // /free", // 54 Система освобождения преступников (Адвокаты) (В будущем судьи /judge) [Goverment]
        // /readr", // 55 Использование волны рации другой организации [Goverment]
        // /debt /deprive", // 56 Налоговые должники + изъять задолженность [Goverment]
        // /arestdom", // 57 Арестовать дом [Goverment]
        // /arestbiz", // 58 Арестовать бизнес [Goverment]
        // /arestroom", // 59 Арестовать квартиру [Goverment]
        // /acbiz /denybiz", // 60 Контроль расположения бизнесов [Goverment]
        // /busstop", // 61 Автобусные остановки + сюда маршруты [Goverment]
        // /minfin", // 62 Министерство Финансов [Goverment]
        if(g == 7)  return 1;
    }
    else if(accessId == 63) // /mdc", // 63 База Данных
    {
        if(IsAPoliceFunction(g) || g == 7)  return 1;
    }
    else if(accessId >= 64 && accessId <= 66)
    {
        // /news", // 64 Вещать в общий чат [CNN]
        // /channel", // 65 Телеканал [CNN]
        // /live", // 66 Интервью [CNN]
        if(g == 4)  return 1;
    }
    else if(accessId >= 67 && accessId <= 71)
    {
        // /hmenu", // 67 Доступ к меню агенства [ICA]
        // /goc", // 68 Принять контракт [ICA]
        // /givehit", // 69 Порушить контракт [ICA]
        // /nametag", // 70 Отключить / Включить никнейм [ICA]
        // /sign", // 71 Сменить имя [ICA]
        if(g == 8)  return 1;
    }
    else return 1;
    return 0;
}

stock detail_oac(playerid, detail)
{
    List[DP[0][playerid]][playerid] = detail;
    DP[0][playerid] += 1;
    new text[84];

    if(OrganInfo[DP[1][playerid]][gAccDiv][detail] > 0)
    {
        new i = OrganInfo[DP[1][playerid]][gAccDiv][detail] - 1;
        format(text, 84, "{cccccc}%s \t{ff9000}[ %d + Ранг ]\t{cccccc}%s\n", accessRightName[detail], OrganInfo[DP[1][playerid]][gAcc][detail], DivisionInfo[DP[1][playerid] - 1][i][divAbbreviation]);
    }
    else format(text, 84, "{cccccc}%s \t{ff9000}[ %d + Ранг ]\t\n", accessRightName[detail], OrganInfo[DP[1][playerid]][gAcc][detail]);
	return text;
}

CMD:oac(playerid) // Меню настроек прав доступа
{
	if(PlayerInfo[playerid][pLeader] <= 0) return ErrorText(playerid, "{FF6347}Вы не лидер организации"), showDialogOrganizationMenu(playerid);

	new g = PlayerInfo[playerid][pLeader];
    DP[0][playerid] = 0;
 	DP[1][playerid] = g;
	for(new i = 0; i < 200; i++) List[i][playerid] = 0; // Очищаем list
	
    format(lines,sizeof(lines),""); // Очищаем Lines

    for(new i = 0; i < sizeof(accessRightName); i++)
    {
        if(IsAFunctionOrganization(i, g, playerid)) format(line,sizeof(line), detail_oac(playerid, i)), strcat(lines,line);
    }
    format(store,sizeof(store),"{cccccc}Права Доступа: %s", fraklastName[g]);
	ShowDialog(playerid,616,DIALOG_STYLE_TABLIST,store,lines,"Выбрать","Отмена");
   	return 1;
}

stock showDialogSettingAccessRight(playerid, accessId)
{
    DP[0][playerid] = accessId;
    new g = DP[1][playerid];

    format(lines,sizeof(lines),""); // Очищаем Lines

    format(line,sizeof(line), "{ff9000}%s \t", accessRightName[accessId]), strcat(lines,line);
    format(line,sizeof(line), "\n{cccccc}Ранг: \t{ff9000}%d+", OrganInfo[g][gAcc][accessId]), strcat(lines,line);
    if(OrganInfo[g][gAccDiv][accessId] > 0) 
    {
        new i = OrganInfo[DP[1][playerid]][gAccDiv][accessId] - 1;
        format(line,sizeof(line), "\n{cccccc}Подфракция: \t{%s}%s", DivisionInfo[g - 1][i][divColorHex], DivisionInfo[g - 1][i][divAbbreviation]), strcat(lines,line);
    }
    else format(line,sizeof(line), "\n{cccccc}Подфракция: \t{555555}нет"), strcat(lines,line);

    format(store,sizeof(store),"{cccccc}Права Доступа: %s", fraklastName[g]);
	ShowDialog(playerid,614,DIALOG_STYLE_TABLIST_HEADERS,store,lines,"Выбрать","Отмена");
    return 1;
}

stock dialogCase_AccessRight(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == 613)
    {
        new accessId = DP[0][playerid];
        if(response)
        {
            if(listitem < 0 || listitem > MAX_DIVISION_ORG) return 1;
            new g = DP[1][playerid];

            if(OrganInfo[g][gAccDiv][accessId] == listitem) return ErrorText(playerid, "{FF6347}Эта настройка уже установлена"), showDialogSettingAccessRight(playerid, accessId);
            if(listitem > 0)
            {
                if(!strcmp(DivisionInfo[g - 1][listitem - 1][divName],"0",true)) return ErrorText(playerid, "{FF6347}Эта подфракция не настроена и не имеет названия"), showDialogSettingAccessRight(playerid, accessId);

			    format(store,sizeof(store),"[ Мысли ]: Права [ {ff9000}%s {cccccc}] установлена на {%s}%s", accessRightName[accessId], DivisionInfo[g - 1][listitem - 1][divColorHex], DivisionInfo[g - 1][listitem - 1][divName]);
			    SendClientMessage(playerid, COLOR_GREY, store);
            }
            else
            {
                format(store,sizeof(store),"[ Мысли ]: Права [ {ff9000}%s {cccccc}] установлена на {555555}без подфракции", accessRightName[accessId]);
			    SendClientMessage(playerid, COLOR_GREY, store);
            }
            OrganInfo[g][gAccDiv][accessId] = listitem;
			PlayerPlaySound(playerid,6401,0,0,0);
			SaveOrganAccess(g, accessId);
			showDialogSettingAccessRight(playerid, accessId);
        }
        else showDialogSettingAccessRight(playerid, accessId);
    }
    else if(dialogid == 614)
    {
        if(response)
        {
			new g = DP[1][playerid];
            if(listitem == 0)
            {
			    format(store,sizeof(store),"{cccccc}Введите {ff9000}номер ранга{cccccc}, с которого будет доступна эта функция\n\n{ff9000}%s\nТекущий ранг: %d\n{cccccc}(1 - %d ранг)", accessRightName[DP[0][playerid]], OrganInfo[g][gAcc][DP[0][playerid]], get_maxrank(g));
			    ShowDialog(playerid,617,DIALOG_STYLE_INPUT,"{cccccc}Права Доступа",store,"Принять","Отмена");
            }
            else if(listitem == 1)
            {
                format(lines,sizeof(lines),""); // Очищаем Lines
                format(line,sizeof(line),"ID\tНазвание\tАббревиатура"), strcat(lines,line);

                format(line,sizeof(line),"\n{555555}Без подфракции"), strcat(lines,line);
                for(new i = 0; i < MAX_DIVISION_ORG; i++)
                {
                    format(line,sizeof(line),"\n{ff9000}%d.\t{cccccc}{%s}%s", i+1, DivisionInfo[g - 1][i][divColorHex], DivisionInfo[g - 1][i][divName]), strcat(lines,line);
                }
                ShowDialog(playerid,613,DIALOG_STYLE_TABLIST_HEADERS,"{cccccc}Права Доступа",lines,"Выбрать","Выход");
            }
        }
        else cmd_oac(playerid);
    }
    else if(dialogid == 616)
   	{
   		if(response)
        {
            if(listitem < 0 || listitem > 199) return 1;
			if(PlayerInfo[playerid][pLeader] <= 0) return ErrorMessage(playerid, "{FF6347}Вы не лидер организации"), showDialogOrganizationMenu(playerid);

            showDialogSettingAccessRight(playerid, List[listitem][playerid]);
        }
        else showDialogOrganizationMenu(playerid);
	}
    else if(dialogid == 617)
   	{
        new accessId = DP[0][playerid];
   		if(response)
        {
			new g = DP[1][playerid];
			if(!strlen(inputtext)) return cmd_oac(playerid);
			new fr = strval(inputtext);
			if(fr > get_maxrank(g) || fr < 1) return format(store,sizeof(store),"[ Мысли ]: Ранг не меньше 1 и не больше %d", get_maxrank(g)), ErrorText(playerid, store), showDialogSettingAccessRight(playerid, DP[0][playerid]);
			if(OrganInfo[g][gAcc][accessId] == listitem) return ErrorText(playerid, "{FF6347}Эта настройка уже установлена"), showDialogSettingAccessRight(playerid, accessId);
            format(store,sizeof(store),"[ Мысли ]: Права [ {ff9000}%s {cccccc}] установлены на {ff9000}%d+ Ранг", accessRightName[accessId], fr);
			SendClientMessage(playerid, COLOR_GREY, store);
			OrganInfo[g][gAcc][accessId] = fr;
			PlayerPlaySound(playerid,6401,0,0,0);
			SaveOrganAccess(g, accessId);
			showDialogSettingAccessRight(playerid, accessId);
		}
		else showDialogSettingAccessRight(playerid, accessId);
	}
    return 1;
}

stock GetAccessRankOrgMay(playerid, g, accessId, fbi) // Результат доступа
{
    new realOrg = g;
    new realRank = PlayerInfo[playerid][pRank];
    if(fbi > 0)
    {
        realOrg = 2;
        realRank = PlayerInfo[playerid][pFbi];
    }

    if(OrganInfo[realOrg][gAccDiv][accessId] > 0) // Есть подфракция у команды
    {
        if(PlayerInfo[playerid][pDivision][0] == OrganInfo[realOrg][gAccDiv][accessId]
            && realRank >= OrganInfo[realOrg][gAcc][accessId]) return 1; // Игрок в подфракции + ранг совпадает
    }
    else
    {    
        if(realRank >= OrganInfo[realOrg][gAcc][accessId]) return 1; // Ранг совпадает
    }
	return 0;
}

stock GetAccessRankOrg(playerid, g, accessId, fbi) // Ответ с сообщением
{
	if(!GetAccessRankOrgMay(playerid, g, accessId, fbi))
	{
        format(lines,sizeof(lines),""); // Очищаем Lines

        format(line,sizeof(line),"{FF6347}Вам недоступна эта функция [ %s ]", accessRightName[accessId]), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}Требуется ранг: {FF6347}%d+", OrganInfo[g][gAcc][accessId]), strcat(lines,line);
        if(OrganInfo[g][gAccDiv][accessId] > 0)
        {
            new i = OrganInfo[g][gAccDiv][accessId] - 1;
            format(line,sizeof(line),"\n{cccccc}Подфракция: {FF6347}%s [ID %d]", DivisionInfo[g - 1][i][divName], i + 1), strcat(lines,line);
        }
        else format(line,sizeof(line),"\n{cccccc}Подфракция: {555555}не требуется"), strcat(lines,line);

        format(line,sizeof(line),"\n\n{cccccc}Настройки прав доступа доступны только лидеру организации"), strcat(lines,line);
		ErrorMessage(playerid, lines);
		return 0;
	}
	return 1;
}

stock SaveOrganAccess(idx, accid)
{
	format(big_query, sizeof(big_query), "UPDATE `pp_organization` SET `acc%d`='%d', `accdiv%d`='%d' WHERE `frakid`='%d'", accid, OrganInfo[idx][gAcc][accid], accid, OrganInfo[idx][gAccDiv][accid], idx);
	query_empty(pearsq_2, big_query);
	return true;
}

stock SaveOrganAccessAll(idx)
{
  format(big_query, sizeof(big_query), "UPDATE `pp_organization` SET `acc0`='%d',`acc1`='%d',\
  `acc2`='%d',`acc3`='%d',`acc4`='%d',`acc5`='%d',`acc6`='%d',`acc7`='%d',`acc8`='%d',`acc9`='%d',",OrganInfo[idx][gAcc][0],OrganInfo[idx][gAcc][1],
  OrganInfo[idx][gAcc][2],OrganInfo[idx][gAcc][3],OrganInfo[idx][gAcc][4],OrganInfo[idx][gAcc][5],OrganInfo[idx][gAcc][6],OrganInfo[idx][gAcc][7],OrganInfo[idx][gAcc][8],OrganInfo[idx][gAcc][9]);
  format(big_query, sizeof(big_query), "%s`acc10`='%d',`acc11`='%d',`acc12`='%d',`acc13`='%d',`acc14`='%d',`acc15`='%d',`acc16`='%d',`acc17`='%d',`acc18`='%d',\
  `acc19`='%d',`acc20`='%d',`acc21`='%d',`acc22`='%d',`acc23`='%d',",  big_query,
  OrganInfo[idx][gAcc][10],OrganInfo[idx][gAcc][11],OrganInfo[idx][gAcc][12],OrganInfo[idx][gAcc][13],OrganInfo[idx][gAcc][14],OrganInfo[idx][gAcc][15],OrganInfo[idx][gAcc][16],OrganInfo[idx][gAcc][17],
  OrganInfo[idx][gAcc][18],OrganInfo[idx][gAcc][19],OrganInfo[idx][gAcc][20],OrganInfo[idx][gAcc][21],OrganInfo[idx][gAcc][22],OrganInfo[idx][gAcc][23]);
  format(big_query, sizeof(big_query), "%s`acc24`='%d',`acc25`='%d',`acc26`='%d',`acc27`='%d',`acc28`='%d',`acc29`='%d',`acc30`='%d',`acc31`='%d',`acc32`='%d',\
  `acc33`='%d',`acc34`='%d',`acc35`='%d',`acc36`='%d',`acc37`='%d',`acc38`='%d',`acc39`='%d',`acc40`='%d',`acc41`='%d',`acc42`='%d',`acc43`='%d',",  big_query,
  OrganInfo[idx][gAcc][24],OrganInfo[idx][gAcc][25],OrganInfo[idx][gAcc][26],OrganInfo[idx][gAcc][27],OrganInfo[idx][gAcc][28],OrganInfo[idx][gAcc][29],OrganInfo[idx][gAcc][30],OrganInfo[idx][gAcc][31],OrganInfo[idx][gAcc][32],
  OrganInfo[idx][gAcc][33],OrganInfo[idx][gAcc][34],OrganInfo[idx][gAcc][35],OrganInfo[idx][gAcc][36],OrganInfo[idx][gAcc][37],OrganInfo[idx][gAcc][38],OrganInfo[idx][gAcc][39],OrganInfo[idx][gAcc][40],OrganInfo[idx][gAcc][41],
  OrganInfo[idx][gAcc][42],OrganInfo[idx][gAcc][43]);
  format(big_query, sizeof(big_query), "%s`acc44`='%d',`acc45`='%d',`acc46`='%d',`acc47`='%d',`acc48`='%d',`acc49`='%d',`acc50`='%d',`acc51`='%d',`acc52`='%d',\
  `acc53`='%d',`acc54`='%d',`acc55`='%d',`acc56`='%d',`acc57`='%d',`acc58`='%d',`acc59`='%d',`acc60`='%d',`acc61`='%d',`acc62`='%d',`acc63`='%d',",  big_query,
  OrganInfo[idx][gAcc][44],OrganInfo[idx][gAcc][45],OrganInfo[idx][gAcc][46],OrganInfo[idx][gAcc][47],OrganInfo[idx][gAcc][48],OrganInfo[idx][gAcc][49],OrganInfo[idx][gAcc][50],OrganInfo[idx][gAcc][51],OrganInfo[idx][gAcc][52],
  OrganInfo[idx][gAcc][53],OrganInfo[idx][gAcc][54],OrganInfo[idx][gAcc][55],OrganInfo[idx][gAcc][56],OrganInfo[idx][gAcc][57],OrganInfo[idx][gAcc][58],OrganInfo[idx][gAcc][59],OrganInfo[idx][gAcc][60],OrganInfo[idx][gAcc][61],
  OrganInfo[idx][gAcc][62],OrganInfo[idx][gAcc][63]);
  format(big_query, sizeof(big_query), "%s`acc64`='%d',`acc65`='%d',`acc66`='%d',`acc67`='%d',`acc68`='%d',`acc69`='%d',`acc70`='%d',`acc71`='%d',`acc72`='%d',\
  `acc73`='%d',`acc74`='%d',`acc75`='%d',`acc76`='%d',`acc77`='%d',`acc78`='%d',`acc79`='%d',`acc80`='%d',`acc81`='%d',`acc82`='%d',`acc83`='%d',",  big_query,
  OrganInfo[idx][gAcc][64],OrganInfo[idx][gAcc][65],OrganInfo[idx][gAcc][66],OrganInfo[idx][gAcc][67],OrganInfo[idx][gAcc][68],OrganInfo[idx][gAcc][69],OrganInfo[idx][gAcc][70],OrganInfo[idx][gAcc][71],OrganInfo[idx][gAcc][72],
  OrganInfo[idx][gAcc][73],OrganInfo[idx][gAcc][74],OrganInfo[idx][gAcc][75],OrganInfo[idx][gAcc][76],OrganInfo[idx][gAcc][77],OrganInfo[idx][gAcc][78],OrganInfo[idx][gAcc][79],OrganInfo[idx][gAcc][80],OrganInfo[idx][gAcc][81],
  OrganInfo[idx][gAcc][82],OrganInfo[idx][gAcc][83]);
  format(big_query, sizeof(big_query), "%s`acc84`='%d',`acc85`='%d',`acc86`='%d',`acc87`='%d',`acc88`='%d',`acc89`='%d',`acc90`='%d',`acc91`='%d',`acc92`='%d',`acc93`='%d',`acc94`='%d',`acc95`='%d',`acc96`='%d',\
  `acc97`='%d',`acc98`='%d',`acc99`='%d' WHERE `frakid`='%d'", big_query,
  OrganInfo[idx][gAcc][84],OrganInfo[idx][gAcc][85],OrganInfo[idx][gAcc][86],OrganInfo[idx][gAcc][87],OrganInfo[idx][gAcc][88],OrganInfo[idx][gAcc][89],OrganInfo[idx][gAcc][90],OrganInfo[idx][gAcc][91],
  OrganInfo[idx][gAcc][92],OrganInfo[idx][gAcc][93],OrganInfo[idx][gAcc][94],OrganInfo[idx][gAcc][95],OrganInfo[idx][gAcc][96],OrganInfo[idx][gAcc][97],OrganInfo[idx][gAcc][98],OrganInfo[idx][gAcc][99],idx);
  query_empty(pearsq_2, big_query);
  return true;
}

stock SendAdvertiseMessage(const text[], const sender[], index, bool: premium = false)
{
    new id_str[6];
    foreach (new id : Player)
    {
        if (!strcmp(PlayerInfo[id][pName], sender)) {
            format(id_str, sizeof(id_str), "[%d]", id);
            break;
        }
    }

    new str[144];
    if (premium) {
        format(str, sizeof(str), "* [AD]: {FFA200}%s, {FF6C00}от: {FFA200}%s%s {FF6C00}(#%04d) *", text, sender, id_str, index);
    } else {
        format(str, sizeof(str), "* [AD]: {99ff33}%s, {9ACD32}от: {99ff33}%s%s {9ACD32}(#%04d) *", text, sender, id_str, index);
    }

    return SendClientMessageToAll(premium ? 0xFF6C00FF : 0x9ACD32FF, str);
}

function SendAdInZero() {
    new year, month, day, hour, minute, second;
    new date[32];
    gettime(hour, minute, second);
    getdate(year, month, day);

    // Ещё не время или в очереди пусто
    if (second != 0 || !AdvertiseQueue[0][adsSender]) return 0;

    for (new j = 1; j < CNN_AD_LIST_MAX; j++) {
        if (!isnull(AdvertiseList[j][cnnAdsText])) continue;

        strcat(AdvertiseList[j][cnnAdsText], AdvertiseQueue[0][adsText]);
        strcat(AdvertiseList[j][cnnAdsSender], AdvertiseQueue[0][adsSender]);
        if (!isnull(AdvertiseQueue[0][adsHandler])) strcat(AdvertiseList[j][cnnAdsHandler], AdvertiseQueue[0][adsHandler]);
        format(date, sizeof(date), "%02d.%02d.%d %02d:%02d", day, month, year, hour, minute);
        strcat(AdvertiseList[j][cnnAdsTime], date);

        SendAdvertiseMessage(AdvertiseQueue[0][adsText], AdvertiseQueue[0][adsSender], j);

        DeleteAdFromQueue(0);
        for (new q = 0; q < CNN_AD_QUEUE_MAX - 1; q++) { // Смещение объявлений
            if (isnull(AdvertiseQueue[q][adsText])) {
                AdvertiseQueue[q] = AdvertiseQueue[q + 1];
                DeleteAdFromQueue(q + 1);
            }
        }

        return 1;
    }

    return 0;
}

stock ClearAds() { // Очищает список взятых объявлений (CNN)
	for (new i = 0; i < CNN_AD_EDIT_MAX; i++) {
		TakeAdvertise[i] = -1;
	}
}

stock DeleteAdFromEditList(number) { // Удаление объявления (CNN)
	Advertise[number][adsText][0] = 0;
	Advertise[number][adsID] = 0;
}

stock DeleteAdFromQueue(number) { // Удаление объявления (CNN)
	AdvertiseQueue[number][adsSender][0] = 0;
    AdvertiseQueue[number][adsHandler][0] = 0;
    AdvertiseQueue[number][adsText][0] = 0;
}
stock CNN_EditDialog(playerid, i) { // Диалог с обработкой объявления (CNN)
    DP[0][playerid] = i;

	new str1[256];
	TakeAdvertise[i] = playerid;
	format(str1, sizeof(str1), "{cccccc}%s{ff9000} [%d]\n{ff9000}Отредактировать\n{99ff66}>> Опубликовать\n{ff6347}<< Отклонить", PlayerInfo[Advertise[i][adsID]][pName], Advertise[i][adsID]);
	return ShowDialog(playerid, CNN_DIALOG_EDIT_AD, DIALOG_STYLE_TABLIST_HEADERS, "{cccccc}** Объявления {ffcc66}CNN", str1, "Выбрать", "Назад");
}

stock CNN_EditPriceDialog(playerid, stat = 0)
{
    new dialog_text[256];
    if (stat == 0)
    {
        format(dialog_text, sizeof(dialog_text), 
            "{cccccc}Стоимость обычного объявления\t{ff9000}>>\n" \
            "{cccccc}Стоимость премиум объявления\t{ff9000}>>"
        );
        
        ShowDialog(playerid, CNN_DIALOG_EDIT_PRICE_SELECT, DIALOG_STYLE_TABLIST, "{ff9000}Стоимость объявления", dialog_text, "Выбор", "Назад");
    }
    else {
        if (stat == 1) {
            format(dialog_text, sizeof(dialog_text), "{ffcc66}Укажите стоимость публикации обычного объявления:\n\n{cccccc}Текущая: %s$", FormatNumberWithCommas(ServerInfo[65]));  
        } else if (stat == 2) {
            format(dialog_text, sizeof(dialog_text), "{ffcc66}Укажите стоимость публикации премиум объявления:\n\n{cccccc}Текущая: %s$", FormatNumberWithCommas(ServerInfo[66]));  
        }

        if (OnlineInfo[playerid][oDialogID] == _:CNN_DIALOG_EDIT_PRICE_ENTER) strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}Лимит: 1.000$ - 50.000$");

        ShowDialog(playerid, CNN_DIALOG_EDIT_PRICE_ENTER, DIALOG_STYLE_INPUT, "{ff9000}Стоимость объявления", dialog_text, "Выбор", "Назад");
    }

    return 1;
}

stock CNN_ChooseTypeDialog(playerid)
{
    new dialog_text[256];

    format(dialog_text, sizeof(dialog_text),
        "{cccccc}Тип\t{cccccc}Цена\n" \
        \
        "{cccccc}Обычное\t{99ff66}%s$\n" \
        "{ff9000}Премиум\t{99ff66}%s$",

        FormatNumberWithCommas(ServerInfo[65]),
        FormatNumberWithCommas(ServerInfo[66])
    );

    return ShowDialog(playerid, CNN_DIALOG_CHOOSE_TYPE, DIALOG_STYLE_TABLIST_HEADERS, "{cccccc}** Объявления {ffcc66}CNN", dialog_text, "Выбрать", "Отмена");
}

stock dialogCase_CNN(playerid, dialogid, response, listitem, const inputtext[])
{
    switch (e_DialogId: dialogid)
    {
        case CNN_DIALOG_SEND_AD: 
        {
            if (response) 
            {
                format(ListName[playerid], 64, "%s", inputtext);
                if(10 > strlen(inputtext) > 64) 
                {
                    return ErrorMessage(playerid, "{FF6347}Длина объявления должна быть от 10 до 64");
                }
                CNN_ChooseTypeDialog(playerid);
            }
        }
        case CNN_DIALOG_CHOOSE_TYPE:
        {
            if (!response) return 0;

            PlayerInfo[playerid][pCDAd] = gettime();

            new msg[128];
            if (listitem == 0)
            {
                new cnnonline;
                foreach (new id: Player) {
                    if (fraction(id) == 9) cnnonline++;
                }
                if (cnnonline <= 0) {
                    for (new j = 0; j < CNN_AD_QUEUE_MAX; j++) {
                        if (isnull(AdvertiseQueue[j][adsSender])) { 
                            new hour, minute, second;
                            gettime(hour, minute, second);

                            strcat(AdvertiseQueue[j][adsText], ListName[playerid]);
                            strcat(AdvertiseQueue[j][adsSender], PlayerInfo[playerid][pName]);

                            format(msg, sizeof(msg), "{0088ff}** [ CNN ] {ffffff}Объявление не обработано, так как сотрудников CNN нет, и будет опубликовано в %02d:%02d", hour + (minute + 1 + j) / 60, (minute + 1 + j) % 60);
                            SendClientMessage(playerid, 0xFF8282FF, msg);
                            oGivePlayerBank(playerid, -ServerInfo[65]);
                            OrganInfo[9][glave] += ServerInfo[65];

                            return 1;
                        }
                    }
                }
	
                for (new i = 0; i < CNN_AD_EDIT_MAX; i++) {
                    if (!isnull(Advertise[i][adsText])) continue;

                    strcat(Advertise[i][adsText], ListName[playerid]);
                    Advertise[i][adsID] = playerid;

                    new msgtext[32];
                    if (strlen(ListName[playerid]) > 29) {
                        format(msgtext, sizeof(msgtext), ListName[playerid]);
                        strdel(msgtext, 28, strlen(ListName[playerid])); 
                        strcat(msgtext, "...");
                    } else strcat(msgtext, ListName[playerid]);

                    format(msg, sizeof(msg), "{0088ff}** [ CNN ] {ffffff}Новое объявление от %s[%d]: %s {0088ff}[ /editad ]", PlayerInfo[playerid][pName], playerid, msgtext);
                    SendRadioMessage(9, 0xFF8282FF, msg);

                    SendClientMessage(playerid, 0xFF8282FF, "{0088ff}** [ CNN ] {ffffff}Ваше объявление отправлено сотрудникам CNN на обработку");
                    
                    return 1;
                }

                return ErrorMessage(playerid, "{FF6347}Все слоты редактирования заняты");
            }
            if (listitem == 1)
            {
                new cnnonline;
                foreach (new id: Player) {
                    if (fraction(id) == 9) cnnonline++;
                }

                if (cnnonline <= 0) {
                    for (new j = 1; j < CNN_AD_LIST_MAX; j++) {
                        if (!isnull(AdvertiseList[j][cnnAdsText])) continue;
                    
                        new date[32];
                        new year, month, day, hour, minute, second;
                        gettime(hour, minute, second);
                        getdate(year, month, day);
                        strcat(AdvertiseList[j][cnnAdsText], ListName[playerid]);
                        strcat(AdvertiseList[j][cnnAdsSender], PlayerInfo[playerid][pName]);
                        format(date, sizeof(date), "%02d.%02d.%d %d:%02d", day, month, year, hour, minute);
                        strcat(AdvertiseList[j][cnnAdsTime], date);

                        SendAdvertiseMessage(ListName[playerid], PlayerInfo[playerid][pName], j, .premium = true);
                        
                        oGivePlayerBank(playerid, -ServerInfo[66]);
                        OrganInfo[9][glave] += ServerInfo[66];

                        return 1;
                    }
                }
	
                for (new i = 0; i < CNN_AD_EDIT_MAX; i++) {
                    if (!isnull(Advertise[i][adsText])) continue;

                    strcat(Advertise[i][adsText], ListName[playerid]);
                    Advertise[i][adsType] = listitem;
                    Advertise[i][adsID] = playerid;

                    new msgtext[32];
                    if (strlen(ListName[playerid]) > 29) {
                        format(msgtext, sizeof(msgtext), ListName[playerid]);
                        strdel(msgtext, 28, strlen(ListName[playerid])); 
                        strcat(msgtext, "...");
                    } else strcat(msgtext, ListName[playerid]);

                    format(msg, sizeof(msg), "{0088ff}** [ CNN ] {ffffff}Новое объявление от %s[%d]: %s {0088ff}[ /editad ]", PlayerInfo[playerid][pName], playerid, msgtext);
                    SendRadioMessage(9, 0xFF8282FF, msg);

                    SendClientMessage(playerid, COLOR_GREY, "Ваше объявление отправлено сотрудникам CNN на обработку");

                    return 1;
                }

                return ErrorMessage(playerid, "{FF6347}Все слоты редактирования заняты");
            }
            return 1;
        }
        case CNN_DIALOG_LIST_AD: 
        {
            if (!response) return 1;
            for (new i = 0; i < CNN_AD_EDIT_MAX; i++) {
                if (listitem == i && !isnull(Advertise[i][adsText]) && (TakeAdvertise[i] == -1 || TakeAdvertise[i] == playerid)) {
                    CNN_EditDialog(playerid, i);
                }
                if (listitem == i && !isnull(Advertise[i][adsText]) && (TakeAdvertise[i] != -1 && TakeAdvertise[i] != playerid)) {
                    new str[128];
                    format(str, sizeof(str), "[ Мысли ]: Это объявление обрабатывает %s[%d].", PlayerInfo[TakeAdvertise[i]][pName], TakeAdvertise[i]);
                    SendClientMessage(playerid, COLOR_GREY, str);
                }
                if (listitem == i && isnull(Advertise[i][adsText])) SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Этого объявления не существует.");
            }
            return 1;
        }
        case CNN_DIALOG_EDIT_AD: {
            new i = DP[0][playerid];
            if (TakeAdvertise[i] != playerid) return ErrorMessage(playerid, "{FF6347}Объявление не найдено");
            if (!response) { TakeAdvertise[i] = -1; return pc_cmd_editad(playerid); }

            if (listitem == 0) { // Отредактировать
                new str[128];
                format(str, sizeof(str), "{ff9000}%s[%d]\n{cccccc}Исходный текст объявления:\n%s", PlayerInfo[Advertise[i][adsID]][pName], Advertise[i][adsID], Advertise[i][adsText]);
                return ShowDialog(playerid, CNN_DIALOG_EDIT_INPUT_AD, DIALOG_STYLE_INPUT, "{cccccc}** Объявление {ffcc66}CNN", str, "Принять", "Отменить");
            } 

            if (listitem == 1) { // Опубликовать
                if (Advertise[i][adsType] == 0) {
                    new str[128];
                    for (new j = 0; j < CNN_AD_QUEUE_MAX; j++) {
                        if (!isnull(AdvertiseQueue[j][adsSender])) continue;
                        
                        new hour, minute, second;
                        gettime(hour, minute, second);

                        strcat(AdvertiseQueue[j][adsText], Advertise[i][adsText]);
                        strcat(AdvertiseQueue[j][adsSender], PlayerInfo[Advertise[i][adsID]][pName]);
                        strcat(AdvertiseQueue[j][adsHandler], PlayerInfo[playerid][pName]);

                        format(str, sizeof(str), "{0088ff}** [ CNN ] {ffffff}Объявление обработано и будет опубликовано в %02d:%02d", hour + (minute + 1 + j) / 60, (minute + 1 + j) % 60);
                        SendClientMessage(playerid, 0xFF8282FF, str);

                        if (playerid != Advertise[i][adsID]) 
                        {
                            SendClientMessage(Advertise[i][adsID], 0xFF8282FF, str);
                            GiveUnit(playerid, 25);
                        }

                        oGivePlayerBank(Advertise[i][adsID], -ServerInfo[65]);
                        OrganInfo[9][glave] += ServerInfo[65];

                        DeleteAdFromEditList(i);
                        TakeAdvertise[i] = -1;
                        for (new q = i; q < CNN_AD_EDIT_MAX - 1; q++) { // Смещение объявлений
                            if (isnull(Advertise[q][adsText])) {
                                Advertise[q] = Advertise[q + 1];
                                DeleteAdFromEditList(q + 1);
                            }
                        }

                        return 1;
                    }
                }

                if (Advertise[i][adsType] == 1) {
                    for (new j = 1; j < CNN_AD_LIST_MAX; j++) {
                        if (!isnull(AdvertiseList[j][cnnAdsSender])) continue;

                        new date[32];
                        new year, month, day, hour, minute, second;
                        gettime(hour, minute, second);
                        getdate(year, month, day);
                        strcat(AdvertiseList[j][cnnAdsText], Advertise[i][adsText]);
                        strcat(AdvertiseList[j][cnnAdsSender], PlayerInfo[Advertise[i][adsID]][pName]);
                        strcat(AdvertiseList[j][cnnAdsHandler], PlayerInfo[playerid][pName]);
                        format(date, sizeof(date), "%0d.%02d.%d %d:%02d:%02d", day, month, year, hour, minute, second);
                        strcat(AdvertiseList[j][cnnAdsTime], date);

                        SendAdvertiseMessage(Advertise[i][adsText], PlayerInfo[Advertise[i][adsID]][pName], j, .premium = true);

                        if (playerid != Advertise[i][adsID]) GiveUnit(playerid, 26);

                        oGivePlayerBank(Advertise[i][adsID], -ServerInfo[66]);
                        OrganInfo[9][glave] += ServerInfo[66];
                        
                        DeleteAdFromEditList(i);
                        
                        TakeAdvertise[i] = -1;
                        for (new q = i; q < CNN_AD_EDIT_MAX - 1; q++) { // Смещение объявлений
                            if (isnull(Advertise[q][adsText])) {
                                Advertise[q] = Advertise[q + 1];
                                DeleteAdFromEditList(q + 1);
                            }
                        }

                        return 1;
                    }
                }
            }
            if (listitem == 2) { // Отклонить
                new str[128];
                format(str, sizeof(str), "{ff9000}%s[%d]\n{cccccc}Укажите причину отказа объявления:\n%s", PlayerInfo[Advertise[i][adsID]][pName], Advertise[i][adsID], Advertise[i][adsText]);
                return ShowDialog(playerid, CNN_DIALOG_CANCEL_INPUT_AD, DIALOG_STYLE_INPUT, "{cccccc}** Объявление {ffcc66}CNN", str, "Принять", "Отменить");
            }
        }
        case CNN_DIALOG_EDIT_INPUT_AD: {
            new i = DP[0][playerid];
            if (!response || isnull(inputtext)) return CNN_EditDialog(playerid, i);
            if (TakeAdvertise[i] != playerid) return ErrorMessage(playerid, "{FF6347}Объявление не найдено"); 
            
            Advertise[i][adsText][0] = 0;
            strcat(Advertise[i][adsText], inputtext);
            SendClientMessage(playerid, COLOR_GREY, "Новый текст: %s", Advertise[i][adsText]);

            return CNN_EditDialog(playerid, i);
        }
        case CNN_DIALOG_CANCEL_INPUT_AD: {
            new i = DP[0][playerid], str[128];
            if (!response) return CNN_EditDialog(playerid, i);
            if (TakeAdvertise[i] != playerid) return ErrorMessage(playerid, "{FF6347}Объявление не найдено");

            Advertise[i][adsText][0] = 0;
            strcat(Advertise[i][adsText], inputtext);
            format(str, sizeof(str), "{0088ff}** [ CNN ] {ffffff}%s[%d] отказал объявление %s[%d]. Причина: %s", PlayerInfo[playerid][pName], playerid, PlayerInfo[Advertise[i][adsID]][pName], Advertise[i][adsID], Advertise[i][adsText]);
            SendRadioMessage(9, 0xFF8282FF, str);
            format(str, sizeof(str), "{0088ff}** [ CNN ] {ffffff}%s[%d] отказал ваше объявление. Причина: %s", PlayerInfo[playerid][pName], playerid, Advertise[i][adsText]);
            SendClientMessage(Advertise[i][adsID], 0xFF8282FF, str);
            PlayerPlaySound(Advertise[i][adsID], 1084, 0.0, 0.0, 0.0);

            DeleteAdFromEditList(i);
            TakeAdvertise[i] = -1;
            for (new q = i; q < CNN_AD_EDIT_MAX - 1; q++) { // Смещение объявлений
                if (isnull(Advertise[q][adsText])) {
                    Advertise[q] = Advertise[q + 1];
                    DeleteAdFromEditList(q + 1);
                }
            }
        }
        case CNN_DIALOG_EDIT_PRICE_SELECT:
        {
            if (!response) return pc_cmd_lmenu(playerid);

            DP[0][playerid] = listitem + 1;
            return CNN_EditPriceDialog(playerid, DP[0][playerid]);
        }
        case CNN_DIALOG_EDIT_PRICE_ENTER:
        {
            if (!response) return CNN_EditPriceDialog(playerid, 0);
            
            new ad_type = DP[0][playerid];

            new price;
            if (sscanf(inputtext, "d", price)) return CNN_EditPriceDialog(playerid, ad_type);
            if (price < 1000 || price > 50000) return CNN_EditPriceDialog(playerid, ad_type);

            if (ad_type == 1) {
                ServerInfo[65] = price;
                SaveServer(65);
            } else if (ad_type == 2) {
                ServerInfo[66] = price;
                SaveServer(66);
            }

            
            PlayerPlaySound(playerid, 40405);
            return CNN_EditPriceDialog(playerid, 0);
        }
        default: return 0;
    }
    return 1;
}

cmd:ad(playerid, const params[]) { // Отправка объявления (CNN)
    if (PlayerInfo[playerid][pSoska] < 22 && gettime() - PlayerInfo[playerid][pCDAd] < CNN_AD_COOLDOWN) {
        new str[128];
        format(str, sizeof(str), "{FF6347}Нельзя подавать объявления так часто [ Осталось: %d сек. ]", CNN_AD_COOLDOWN - (gettime() - PlayerInfo[playerid][pCDAd]));
        return ErrorMessage(playerid, str);
    }

    if (!IsPlayerInRangeOfPoint(playerid,5.0,957.6464,1457.2570,1029.3549) && !GetPlayerVip(playerid)) return ErrorMessage(playerid, "{FF6347}Нужно находиться в офисе CNN\n\n{cccccc}С VIP-статусом подавать объявление можно в любом месте");
    if (PlayerInfo[playerid][pBkyrenie] >= 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чего, блин ?! Я не на земле");
    PlayerPlaySound(playerid, 40405);

    if (PlayerInfo[playerid][pAccount] < ServerInfo[65])
    {
        new nomoney[128]; 
        format(nomoney, sizeof(nomoney), "{FF6347}На вашем банковском счету не хватает %d$ для отправки объявления.", ServerInfo[65]);
        return ErrorMessage(playerid, nomoney);
    }

    new str[128];
    sscanf(params, "s[128]", str);

    if(10 > strlen(str) > 64) 
    {
        return ErrorMessage(playerid, "{FF6347}Длина объявления должна быть от 10 до 64");
    }
    
    if (isnull(str)) 
    {
        ShowDialog(playerid, CNN_DIALOG_SEND_AD, DIALOG_STYLE_INPUT, "{cccccc}** Объявления {ffcc66}CNN", "{cccccc}Введите текст будущего объявления:", "Ввод", "Отменить");
    } else {
        format(ListName[playerid], 64, "%s", str);
        CNN_ChooseTypeDialog(playerid);
    }

    return 1;
}

cmd:editad(playerid) { // Редактирование объявления (CNN)
    new g = fraction(playerid);
    if(!IsAFunctionOrganization(79, g, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не сотрудник CNN.");
	if(!GetAccessRankOrg(playerid, g, 79, NO_FBI)) return 1;

	new summary_text[64 * 50 + 50 * 2];	
	for (new i = 0; i < CNN_AD_EDIT_MAX; i++) {
		if (Advertise[i][adsText]) {
			format(summary_text, sizeof(summary_text), "%s{ff9000}%d. {cccccc}%s[%d]\n", summary_text, i+1, PlayerInfo[Advertise[i][adsID]][pName], Advertise[i][adsID]);
		}
	}

	if (isnull(Advertise[0][adsText])) return ErrorMessage(playerid, "{FF6347}Список объявлений пуст");

	ShowDialog(playerid, CNN_DIALOG_LIST_AD, DIALOG_STYLE_LIST, "{cccccc}** Объявления {ffcc66}CNN", summary_text, "Выбрать", "Отменить");
	return 1;
}

cmd:checkad(playerid, const params[]) {
    new number;
    if (sscanf(params, "d", number)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Просмотреть информацию об объявлении [ /checkad Номер ]");

    if (!isnull(AdvertiseList[number][cnnAdsText])) {
        new str[1024];
        new title[128];
        new handler[128];

        if (AdvertiseList[number][cnnAdsHandler]) format(handler, sizeof(handler), "\n\nОбработал: {ffcc66}%s", AdvertiseList[number][cnnAdsHandler]); else format(handler, sizeof(handler), "");

        format(str, sizeof(str),
            "{ff9000}------------------------------------------------------------------------------------------------------------------------------\n\n" \
            "{ff9000}%s\n\n" \
            \
            "{cccccc}%s%s\n\n" \
            \
            "{ff9000}%s\n\n" \
            \
            "{ff9000}------------------------------------------------------------------------------------------------------------------------------",

            AdvertiseList[number][cnnAdsSender], AdvertiseList[number][cnnAdsText], handler, AdvertiseList[number][cnnAdsTime]
        );
        format(title, sizeof(title), "{cccccc}* Объявление {ff9000}#%d", number);

        ShowDialog(playerid, CNN_DIALOG_CHECK_AD, DIALOG_STYLE_MSGBOX, title, str, "Закрыть", "");

    } else ErrorMessage(playerid, "{FF6347}Объявление не найдено");

    return 1;
}
alias:checkad("adinfo")
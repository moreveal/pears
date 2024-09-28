/*
    NPC: Хэнк (Чёрный рынок) - не имеет отношения к автомеханику Хенку :)

    Позволяет приобрести различные запрещённые товары (например, улучшенный детектор и глушилка радаров)
    Также предоставляет участникам мафий квесты и позволяет им воспользоваться различными незаконными услугами (подкупные агенты и т.п.)

    -------------------------------------------------------------------------------------------------------------------------------------
    Добавление нового предмета в товары:
        1. Добавить ID предмета в Hank_IsGood
        2. Добавить описание предмета в Hank_Dialog_Buy
*/

stock Hank_IsGood(thingid) {
    new things[] = {232, 233, 236};
    for (new i = 0; i < sizeof(things); i++) {
        if (thingid == things[i]) return true;
    }
    return false;
}

stock Hank_GetDatabaseActiveName(e_DatabaseActive: active) {
    new name[24];
    switch (active)
    {
        case DATABASE_ACTIVE_NONE: strcat(name, "Не выбрано");
        case DATABASE_ACTIVE_DATA_SORT: strcat(name, "Сортировка данных");
        case DATABASE_ACTIVE_READY_MADE: strcat(name, "На готовенькое");
        case DATABASE_ACTIVE_OVERLOAD: strcat(name, "Перегрузка");
        case DATABASE_ACTIVE_SHORT_CIRCUIT: strcat(name, "Короткое замыкание");
        default: strcat(name, "Неизвестно");
    }
    return name;
}

stock Hank_GetDatabaseActivePrice(e_DatabaseActive: active)
{
    switch (active)
    {
        case DATABASE_ACTIVE_NONE: return 0;
        case DATABASE_ACTIVE_DATA_SORT: return 50000;
        case DATABASE_ACTIVE_READY_MADE: return 150000;
        case DATABASE_ACTIVE_OVERLOAD: return 250000;
        case DATABASE_ACTIVE_SHORT_CIRCUIT: return 250000;
        default: return 0;
    }
    return 0;
}

stock Hank_Dialog_Main(playerid) {
    return ShowDialog(
        playerid, HANK_DIALOG_MAIN, DIALOG_STYLE_TABLIST,
        "{ff9000}Меню",

        "{cccccc}Кто ты?\n" \
        "{ff6347}Нелегальные товары\t{ff6347}>>\n" \
        "{ff6347}Поддержка при взломе базы данных\t>>\n" \
        "{555555}Услуги подкупных агентов\t>>",

        "Выбор", "Закрыть"
    );
}

stock Hank_Dialog_AboutMe(playerid) {
    return ShowDialog(
        playerid, HANK_DIALOG_ABOUT_ME, DIALOG_STYLE_MSGBOX,
        "{ff9000}Кто ты?",

        "{cccccc}Ну что ж, рад представиться. Меня зовут {ff9000}Хэнк{cccccc}. Я здесь главный... эээ, скажем так, \"поставщик возможностей\".\n" \
        "Если тебе нужны специальные товары или услуги, которые в других местах достать непросто, ты пришёл по адресу.\n" \
        "И да, я знаю, что ты слышал про мои \"особые\" связи с некоторыми парнями в форме. Они тоже люди, им иногда нужны...\n" \
        "скажем так, особые стимулы. Но это уже другая история.\n\n" \
        \
        "Я просто обеспечиваю людям возможности, которые у них отобрали. Да и самому это помогает держаться на плаву.\n" \
        "Тут ведь всё просто: или ты управляешь ситуацией, или она тобой. Я выбрал первый вариант.",

        "Назад", ""
    );
}

stock Hank_Dialog_Goods(playerid) {
    new dialog_text[512];

    new currentTime = gettime();
    for (new quan, thingid = 0; thingid < sizeof(friskName); thingid++) {
        if (!Hank_IsGood(thingid)) continue;

        new itemname[128];
        new price = getThingPriceGos(thingid, 0);

        // Если есть устройство с устаревшей прошивкой - выводим цену вдвое меньше
        if (PerishableThing(thingid, 0) && get_invent2(playerid, thingid, 0) > 0 && get_para(playerid, thingid) < currentTime) {
            price /= 2;
            format(itemname, sizeof(itemname), "%s [Обновление ПО]", GetNameThing(0, thingid, 0, 0));
        } else {
            strcat(itemname, GetNameThing(0, thingid, 0, 0));
        }

        format(dialog_text, sizeof(dialog_text), "%s{ff9000}%s\t{99ff66}$%d\n", dialog_text, itemname, price);
        List[quan++][playerid] = thingid;
    }

    PlayerPlaySound(playerid, 40405);
    return ShowDialog(playerid, HANK_DIALOG_GOODS, DIALOG_STYLE_TABLIST, "{ff9000}Товары", dialog_text, "Выбор", "Назад");
}

stock Hank_Dialog_Database_Actives(playerid)
{
    new dialog_text[1024];

    strcat(dialog_text, "{cccccc}Подробнее о типах поддержки\t>>");

    for (new quan, i = 1; i < _:DATABASE_ACTIVE_MAX; i++)
    {
        new bool: is_owned = _:PlayerInfo[playerid][pDatabaseActive] == i;
        new e_DatabaseActive: active = e_DatabaseActive: i;

        format(dialog_text, sizeof(dialog_text), "%s\n{%s}%s {99ff66}(%s$)\t{%s}>>",
            dialog_text,
            (is_owned ? "FF9000" : "7F7F7F"),
            Hank_GetDatabaseActiveName(active),
            FormatNumberWithCommas(Hank_GetDatabaseActivePrice(active)),
            (is_owned ? "FF9000" : "7F7F7F")
        );
        List[++quan][playerid] = i;
    }
    List[0][playerid] = DATABASE_ACTIVE_NONE;

    return ShowDialog(playerid, HANK_DIALOG_DATABASE_ACTIVES, DIALOG_STYLE_TABLIST, "{ff9000}Поддержка", dialog_text, "Выбор", "Назад");
}

stock Hank_Dialog_Database_Actives_About(playerid)
{
    return ShowDialog(playerid, HANK_DIALOG_DATABASE_ACTIVES_ABOUT, DIALOG_STYLE_MSGBOX, "{cccccc}Подробнее о типах поддержки",
        "{ff9000}Типы поддержки (активы) {cccccc}представляют собой специализированные инструменты или ресурсы, которые игроки\n" \
        "могут использовать для облегчения процесса взлома полицейской базы данных.\n\n" \
        \
        "Разрешается использовать только один тип поддержки одновременно.\n" \
        "Если нужно воспользоваться другим - текущий актив необходимо вернуть.\n\n" \
        \
        "Каждый тип поддержки имеет свои уникальные преимущества.\n" \
        "Некоторые могут предложить возврат денег, потраченных на его активацию, при отмене актива игроком.\n" \
        "Другие напротив, не предусматривают возврат средств, что делает их более рискованными, но потенциально\n" \
        "более полезными в конкретных ситуациях.\n\n" \
        \
        "Выбор и управление типами поддержки требуют стратегического мышления, поскольку\n" \
        "правильное использование может существенно облегчить взлом базы данных и снизить риск обнаружения.\n" \
        "Вам нужно тщательно взвешивать, какой актив взять перед началом, в зависимости от текущих задач и условий.",

        "Назад", ""
    );
}

stock Hank_IsDatabaseActiveRefundable(e_DatabaseActive: active)
{
    switch (active)
    {
        case DATABASE_ACTIVE_OVERLOAD, DATABASE_ACTIVE_SHORT_CIRCUIT: {
            return true;
        }
    }
    return false;
}

stock Hank_Dialog_Database_Actives_Select(playerid, e_DatabaseActive: active)
{
    DP[0][playerid] = active;

    new dialog_text[1024];
    format(dialog_text, sizeof(dialog_text),
        "{FF9000}%s%s\n\n{cccccc}",
        
        Hank_GetDatabaseActiveName(active),
        (PlayerInfo[playerid][pDatabaseActive] == active ? " {cccccc}[ Выбрано ]" : "")
    );

    switch (active)
    {
        case DATABASE_ACTIVE_DATA_SORT: {
            strcat(dialog_text, 
                "Хэнк позаботится о том, чтобы базу данных \"приготовили\" к вашему приходу:\n" \
                "нужные люди отсортируют всю информацию, сильно сократив время взлома.\n\n" \
                \
                "{ff9000}Сокращает прохождение первого этапа в 2 раза [SAPD / FBI]"
            );
        }
        case DATABASE_ACTIVE_READY_MADE: {
            strcat(dialog_text,
                "Хэнк занесёт деньги людям из руководства полиции и сообщит вам код для 2 этапа.\n\n" \
                \
                "{ff9000}Вы заранее узнаете код, который должны будете ввести на втором этапе [SAPD]"
            );
        }
        case DATABASE_ACTIVE_OVERLOAD: {
            strcat(dialog_text,
                "Хэнк заплатит электрикам, которые будут обслуживать здание федерального бюро,\n" \
                "вызвав тем самым неисправности в оборудовании.\n\n" \
                \
                "{ff9000}После отключения одного из электрощитков, остальные отключатся автоматически [FBI]"
            );
        }
        case DATABASE_ACTIVE_SHORT_CIRCUIT: {
            strcat(dialog_text,
                "Хэнк попросит нужных людей устроить короткое замыкание в проводке здания федерального бюро,\n" \
                "вызвав тем самым неисправности в оборудовании.\n\n" \
                \
                "{ff9000}Генераторы отключатся сами после отключения электрощитков [FBI]"
            );
        }
        default: return 0;
    }

    format(dialog_text, sizeof(dialog_text), "%s\n\n{99ff66}Стоимость: %s$", dialog_text, FormatNumberWithCommas(Hank_GetDatabaseActivePrice(active)));

    return ShowDialog(playerid, HANK_DIALOG_DATABASE_ACTIVES_SELECT, DIALOG_STYLE_MSGBOX, "{cccccc}Выбор типа поддержки",
        dialog_text,
        (PlayerInfo[playerid][pDatabaseActive] == active ? "Вернуть" : "Купить"), "Назад"
    );
}

stock Hank_Dialog_Active_Refund(playerid, e_DatabaseActive: active)
{
    new dialog_text[512];
    format(dialog_text, sizeof(dialog_text),
        "{cccccc}Возврат актива: {ff9000}%s\n" \
        "{cccccc}Вы действительно хотите отказаться от приобретённого актива?",

        Hank_GetDatabaseActiveName(active)
    );
    if (!Hank_IsDatabaseActiveRefundable(active)) {
        strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}Данный тип поддержки не предполагает возврата потраченных на него средств");
    }

    return ShowDialog(playerid, HANK_DIALOG_DATABASE_ACTIVES_REFUND, DIALOG_STYLE_MSGBOX, "{ff9000}Отказ от поддержки", dialog_text, "Да", "Назад");
}

stock Hank_Dialog_Active_Buy(playerid, e_DatabaseActive: active)
{
    if (PlayerInfo[playerid][pDatabaseActive] != DATABASE_ACTIVE_NONE)
    {
        ErrorText(playerid, "{FF6347}Вы не можете приобрести более одного типа поддержки");
        return Hank_Dialog_Database_Actives(playerid);
    }

    new dialog_text[512];
    format(dialog_text, sizeof(dialog_text),
        "{cccccc}Приобретение актива: {ff9000}%s {99ff66}(%s$)\n" \
        "{cccccc}Вы действительно хотите приобрести этот тип поддержки?",

        Hank_GetDatabaseActiveName(active),
        FormatNumberWithCommas(Hank_GetDatabaseActivePrice(active))
    );
    if (!Hank_IsDatabaseActiveRefundable(active)) {
        strcat(dialog_text, "\n\n{ff0000}[!] {ff6347}Вы не сможете вернуть потраченные средства при отказе от этого типа поддержки");
    }

    return ShowDialog(playerid, HANK_DIALOG_DATABASE_ACTIVES_BUY, DIALOG_STYLE_MSGBOX, "{ff9000}Приобретение поддержки", dialog_text, "Да", "Назад");
}

stock Hank_Dialog_Buy(playerid, thingid) {
    if (!Hank_IsGood(thingid)) return 0;
    DP[0][playerid] = thingid; // ID предмета
    DP[1][playerid] = 0; // Обновление прошивки

    new currentTime = gettime();

    new dialog_header[128];
    format(dialog_header, sizeof(dialog_header), "{FF9000}Покупка: %s", GetNameThing(0, thingid, 0, 0));

    new dialog_text[1024];

    // Основное:
    switch (thingid) {
        case 232: {
            strcat(dialog_text, 
                "{cccccc}Устройство предупреждает о наличии радара за "#RADAR_ENHANCED_DETECT_RADIUS" метров от него\n" \
                "Этот тип детектора помечает радар на мини-карте на 120 метрах от него, а также обладает индикатором,\n" \
                "отражающим вашу скорость, относительно ограничения скорости у радара"
            );
        }
        case 233: {
            strcat(dialog_text,
                "{cccccc}Устройство позволяет заглушать радары, мимо которых вы проезжаете, на небольшой промежуток времени\n" \
                "Глушилка срабатывает не чаще чем 1 раз в "#RADAR_JAMMER_COOLDOWN" секунд и выключает радар для всех в течение "#RADAR_JAMMED_TIME" секунд\n" \
                "Также будет функционировать, если находится в багажнике автомобиля\nДевайс будет оставаться рабочим "#RADAR_JAMMER_SOFTWARE_TIME" дней с момента покупки, далее - требуется обновление ПО"
            );
        }
        case 236: {
            strcat(dialog_text,
                "{cccccc}Устройство позволяет вам отслеживать местоположение полицейских.\n" \
                "Отслеживание полицейского можно активировать 1 раз в "#RADIO_INTERCEPTOR_FIND_COOLDOWN" минут.\n" \
                "После активации его позиция будет подсвечена на карте в течение 2 минут с периодичным обновлением местоположения.\n\n" \
                \
                "Кроме того, устройство может перехватывать сообщения полицейских.\n" \
                "Доступны следующие опции (одновременно можно активировать не более двух):\n" \
                "{ffcc66}- Перехват выдачи розыска [ /su ]\n" \
                "{ffcc66}- Перехват начала преследования [ /pursuit ]\n" \
                "{ffcc66}- Перехват задержаний [ /cuff ]\n" \
                "{cccccc}Девайс будет оставаться рабочим "#RADIO_INTERCEPTOR_SOFTWARE_TIME" дней с момента покупки, далее - требуется настройка частоты"
            );
        }
        default: return 0;
    }

    strcat(dialog_text, "\n\n{ff6347}Предмет является нелегальным и может быть изъят");

    // Обновление прошивки:
    if (PerishableThing(thingid, 0) && get_invent2(playerid, thingid, 0) > 0 && get_para(playerid, thingid) < currentTime) {
        DP[1][playerid] = 1;

        new update_price = getThingPriceGos(thingid, 0) / 2;
        switch (thingid) {
            case 233: {
                format(dialog_text, sizeof(dialog_text), "%s\n\n{FF9000}Нет необходимости приобретать устройство вновь!\nУ вас уже есть глушилка с устаревшим ПО, обновление будет стоить: %s$", dialog_text, FormatNumberWithCommas(update_price));
            }
            case 236: {
                format(dialog_text, sizeof(dialog_text), "%s\n\n{FF9000}Нет необходимости приобретать устройство вновь!\nУ вас уже есть перехватчик с устаревшей частотой радиопередачи, обновление будет стоить: %s$", dialog_text, FormatNumberWithCommas(update_price));
            }
        }
    }

    strcat(dialog_text, "\n\n{99ff66}Желаете приобрести?");

    return ShowDialog(playerid, HANK_DIALOG_BUY, DIALOG_STYLE_MSGBOX, dialog_header, dialog_text, "Купить", "Назад");
}

stock dialogCase_HankActor(playerid, dialogid, response, listitem, const inputtext[]) {
    #pragma unused inputtext

    switch (e_DialogId: dialogid) {
        case HANK_DIALOG_MAIN: {
            if (!response) return 1;

            switch (listitem) {
                case 0: return Hank_Dialog_AboutMe(playerid);
                case 1: return Hank_Dialog_Goods(playerid);
                case 2: return Hank_Dialog_Database_Actives(playerid); 
                case 3: return ErrorMessage(playerid, "{FF6347}В разработке");
            }
        }
        case HANK_DIALOG_ABOUT_ME: {
            return Hank_Dialog_Main(playerid);
        }
        case HANK_DIALOG_GOODS: {
            if (!response) return Hank_Dialog_Main(playerid);
            
            new thingid = List[listitem][playerid];
            return Hank_Dialog_Buy(playerid, thingid);
        }
        case HANK_DIALOG_BUY: {
            if (!response) return Hank_Dialog_Goods(playerid);

            new thingid = DP[0][playerid];
            new bool: firmwareUpdate = DP[1][playerid] == 1;
            new price = getThingPriceGos(thingid, 0);

            new string[256], log_str[128];
            if (!firmwareUpdate) {
                if(oGetPlayerMoney(playerid) < price) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
                if(JustOneThingInventory(thingid, 0) && get_invent(playerid, thingid, 0) > 0) return ErrorMessage(playerid, "{FF6347}У вас уже есть этот предмет");
                
                new put_inva = GiveThingPlayer(playerid, thingid, 1, 0, 0, 0, 0, 9999);
                if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}В инвентаре нет места");

                new const hankReplies[][] = {
                    "Если что, ты меня не видел",
                    "Смотри не попадись с этой штукой...",
                    "Будь аккуратнее, у тебя могут появиться проблемы из-за этого",
                    "Ты не знаешь меня - я не знаю тебя",
                    "Не стоит показывать это кому-то",
                    "Только без глупостей, не маши этим перед федералами",
                    "Держи эту штуку при себе, думаю ты смышлённый парень",
                    "Бери, точно не пожалеешь, но лучше прячь получше",
                    "Не совсем легальная штука, но явно тебе поможет"
                };
                SendDynamicActorMessage(playerid, hankActor, hankReplies[random(sizeof(hankReplies))]);

                format(string,sizeof(string),"{99ff66}Вы приобрели: %s\n{cccccc}Стоимость: {99ff66}%d$", GetNameThing(0, thingid, 0, 0), price);
                SuccessMessage(playerid, string);

                format(log_str, sizeof(log_str), "Приобрёл %s", GetNameThing(0, thingid, 0, 0));
            } else {
                price /= 2;

                format(string,sizeof(string),"{99ff66}Вы приобрели: {FF9000}Обновление прошивки [%s]\n{cccccc}Стоимость: {99ff66}%d$", GetNameThing(0, thingid, 0, 0), price);
                SuccessMessage(playerid, string);

                new const hankReplies[][] = {
                    "Самая последняя модель, готов поклясться жизнью, что она работает",
                    "Софт от лучших поставщиков, не подведёт",
                    "Если в этом мире и есть то, чему я могу доверять больше чем себе - то только эта прошивка",
                    "Уверяю, у конкурентов хуже",
                    "Никогда не подводила, и я не думаю, что когда-либо подведет!",
                    "Полная поддержка новых частот и алгоритмов детекции"
                };
                SendDynamicActorMessage(playerid, hankActor, hankReplies[random(sizeof(hankReplies))]);

                new _unused_, para;
                ThingParameters(playerid, thingid, _unused_, para);
                set_para(playerid, thingid, para);

                format(log_str, sizeof(log_str), "Приобрёл обновление прошивки [%s]", GetNameThing(0, thingid, 0, 0));
            }
            oGivePlayerMoney(playerid, -price);
            payanim(playerid, 0);
            ApplyDynamicActorAnimation(hankActor, "DEALER","DRUGS_BUY",10.0,0,1,1,0,0);
            MoneyLog("buy", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, log_str);

            if(PlayerInfo[playerid][pAchieve][70] == 0) AchievePlayer(playerid, 70, 1); // Выдаём ачивку за покупку предмета у нелегального торговца
        }
        case HANK_DIALOG_DATABASE_ACTIVES:
        {
            if (!response) return Hank_Dialog_Main(playerid);

            new e_DatabaseActive: active = e_DatabaseActive: List[listitem][playerid];
            if (active == DATABASE_ACTIVE_NONE) return Hank_Dialog_Database_Actives_About(playerid);
            return Hank_Dialog_Database_Actives_Select(playerid, active);
        }
        case HANK_DIALOG_DATABASE_ACTIVES_ABOUT:
        {
            return Hank_Dialog_Database_Actives(playerid);
        }
        case HANK_DIALOG_DATABASE_ACTIVES_SELECT:
        {
            if (!response) return Hank_Dialog_Database_Actives(playerid);
            
            new e_DatabaseActive: active = e_DatabaseActive: DP[0][playerid];
            if (PlayerInfo[playerid][pDatabaseActive] == active) { // Возврат
                Hank_Dialog_Active_Refund(playerid, active);
            } else { // Покупка
                Hank_Dialog_Active_Buy(playerid, active);
            }
        }
        case HANK_DIALOG_DATABASE_ACTIVES_BUY:
        {
            new e_DatabaseActive: active = e_DatabaseActive: DP[0][playerid];
            if (!response) return Hank_Dialog_Database_Actives_Select(playerid, active);

            new price = Hank_GetDatabaseActivePrice(active);
            if (oGetPlayerMoney(playerid) - price < 0) {
                ErrorText(playerid, "{FF6347}У вас недостаточно денег для приобретения этого типа поддержки");
                return Hank_Dialog_Database_Actives(playerid);
            }
            oGivePlayerMoney(playerid, -price);

            PlayerInfo[playerid][pDatabaseActive] = active;

            new log_str[64];
            format(log_str, sizeof(log_str), "Покупка у Хэнка [ %s ]", Hank_GetDatabaseActiveName(active));
            MoneyLog("activebuy", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], -price, log_str);

            new const hankReplies[][] = {
                "За качество своих услуг - отвечаю головой",
                "Молодец, перестраховка ещё никому не мешала",
                "Уверен, теперь твои шансы стали втрое выше",
                "Да, лучше перестраховаться, чем потом сожалеть",
                "С такой поддержкой любое дело по плечу",
                "Теперь у тебя точно всё получится"
            };
            SendDynamicActorMessage(playerid, hankActor, hankReplies[random(sizeof(hankReplies))]);
            ApplyDynamicActorAnimation(hankActor, "DEALER","DRUGS_BUY",10.0,0,1,1,0,0);
        }
        case HANK_DIALOG_DATABASE_ACTIVES_REFUND:
        {
            if (!response) return Hank_Dialog_Database_Actives(playerid);

            new const hankReplies[][] = {
                "Странно, что тебе это не понадобится, ну ладно, дело за тобой...",
                "Я бы не стал отказываться от такой помощи, но ладно уж...",
                "Настолько самоуверенный? Делай, что считаешь нужным",
                "Действительно, полагаться в жизни стоит только на себя",
                "Не счёл бы это верным решением, но ладно уж",
                "Лучше перестраховаться, чем потом сожалеть",
                "Осторожность - лучшая часть храбрости"
            };
            SendDynamicActorMessage(playerid, hankActor, hankReplies[random(sizeof(hankReplies))]);

            new e_DatabaseActive: active = e_DatabaseActive: DP[0][playerid];
            if (Hank_IsDatabaseActiveRefundable(active))
            {
                new price = Hank_GetDatabaseActivePrice(active);
                oGivePlayerMoney(playerid, price);
                ApplyDynamicActorAnimation(hankActor, "DEALER","DRUGS_BUY",10.0,0,1,1,0,0);

                new log_str[64];
                format(log_str, sizeof(log_str), "Возврат у Хэнка [ %s ]", Hank_GetDatabaseActiveName(active));
                MoneyLog("activerefund", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], price, log_str);
            }

            SuccessMessage(playerid, "{99ff66}Вы успешно отказались от указанного типа поддержки");
            PlayerInfo[playerid][pDatabaseActive] = DATABASE_ACTIVE_NONE;
        }
    }

    return 1;
}
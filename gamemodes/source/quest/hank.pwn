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

stock Hank_Dialog_Main(playerid) {
    return ShowDialog(
        playerid, HANK_DIALOG_MAIN, DIALOG_STYLE_TABLIST,
        "{ff9000}Меню",

        "{cccccc}Кто ты?\n" \
        "{ff6347}Нелегальные товары\t{ff6347}>>\n" \
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
                case 2: return ErrorMessage(playerid, "{FF6347}В разработке");
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
    }

    return 1;
}
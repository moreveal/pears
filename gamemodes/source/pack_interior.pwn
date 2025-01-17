
#define MAX_PACK_INTERIORS 50
#define BUY_SLOTS_PACK 5 // Количество покупаемых слотов за один раз

enum PackInteriorsInfo
{
    piNewid, // id в базе
    piName[44], // название инта
	piCreateUnix, // unix создания интерьера
    piEditUnix, // unix последнего сохранения интерьера
    piPrice, // цена инта после последнего сохранения
	piObjects, // количество объектов при последнем сохранении
    piTypeInterior, // для дома или биза (0 дом, 1 биз)
    piUserid, // id аккаунта владельца инта
    piClass // class интерьера для дома
};
new PackInteriors[MAX_REALPLAYERS][MAX_PACK_INTERIORS][PackInteriorsInfo]; // Набор интерьеров в личном архиве каждого игрока
new bool:LoadPackInteriors[MAX_REALPLAYERS];
new bool:CDProcessInterior[MAX_REALPLAYERS];

new interiorsType[][] =
{
    "Дом", "Бизнес"
};

stock ClearVariablePackInterior(playerid)
{
    LoadPackInteriors[playerid] = false;
    CDProcessInterior[playerid] = false;
    for(new i = 0; i < MAX_PACK_INTERIORS; i++)
    {
        PackInteriors[playerid][i][piNewid] = 0;
        PackInteriors[playerid][i][piCreateUnix] = 0;
        PackInteriors[playerid][i][piEditUnix] = 0;
        PackInteriors[playerid][i][piPrice] = 0;
        PackInteriors[playerid][i][piObjects] = 0;
        PackInteriors[playerid][i][piTypeInterior] = 0;
        PackInteriors[playerid][i][piUserid] = 0;
        PackInteriors[playerid][i][piClass] = 0;
    }
    return true;
}

function Call_OnPlayerPackInteriorLoad(playerid, race_check)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);

        for(new i = 0; i < rows; i++)
        {
            if(i >= MAX_PACK_INTERIORS) break; // Если найдено интов больше лимита, обрываем загрузку

            new slot;
            cache_get_value_name_int(i, "slot", slot);

            if(slot >= MAX_PACK_INTERIORS) continue; // Слот подозрительно большой, пропускаем

            cache_get_value_name_int(i, "piNewid", PackInteriors[playerid][slot][piNewid]);
            cache_get_value_name(i, "piName", PackInteriors[playerid][slot][piName], 44);
            cache_get_value_name_int(i, "piCreateUnix", PackInteriors[playerid][slot][piCreateUnix]);
            cache_get_value_name_int(i, "piEditUnix", PackInteriors[playerid][slot][piEditUnix]);
            cache_get_value_name_int(i, "piPrice", PackInteriors[playerid][slot][piPrice]);
            cache_get_value_name_int(i, "piObjects", PackInteriors[playerid][slot][piObjects]);
            cache_get_value_name_int(i, "piTypeInterior", PackInteriors[playerid][slot][piTypeInterior]);
            cache_get_value_name_int(i, "piUserid", PackInteriors[playerid][slot][piUserid]);
            cache_get_value_name_int(i, "piClass", PackInteriors[playerid][slot][piClass]);
        }
	}
    LoadPackInteriors[playerid] = true;
	return 1;
}

CMD:myint(playerid)
{
    if(LoadPackInteriors[playerid] == false) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения загрузки набора интерьеров");
    showDialogPackInteriors(playerid);
    return true;
}

stock showDialogPackInteriors(playerid)
{
    if(PlayerInfo[playerid][pPackInteriors] == 0) PlayerInfo[playerid][pPackInteriors] = 2; // Всем игрокам доступно 2 слота для архива интерьеров домов
    DP[4][playerid] = 0; // Сбрасываем выбор покупки слота
    DP[5][playerid] = 0; // Сбрасываем выбор покупки нескольких слотов

    new typeInterior;
    new ownerID;
    WherePlayerInInterior(playerid, typeInterior, ownerID);

    new line[214],lines[4096], id_interior, atext[34];

    if(typeInterior == 0) id_interior = DomInfo[ownerID][dInteriorPack];
    else if(typeInterior == 1) id_interior = BizzInfo[ownerID][bInteriorPack];

    format(line,sizeof(line),"Название\tТип\tСтоимость\t "), strcat(lines,line);
    for(new i = 0; i < MAX_PACK_INTERIORS; i++)
    {
        if(PackInteriors[playerid][i][piNewid] > 0)
        {
            if(id_interior > 0 && PackInteriors[playerid][i][piNewid] == id_interior) atext = "{0088ff}Используется";
            else atext = " ";

            format(line,sizeof(line),"\n{ff9000}%d. %s\t{cccccc}%s\t{99ff66}%d$ (%s)\t %s", i + 1,
                PackInteriors[playerid][i][piName], 
                interiorsType[PackInteriors[playerid][i][piTypeInterior]], 
                PackInteriors[playerid][i][piPrice],
                get_k(PackInteriors[playerid][i][piPrice]),
                atext), strcat(lines,line);
        }
        else
        {
            if(PlayerInfo[playerid][pPackInteriors] > i) format(line,sizeof(line),"\n{cccccc}%d. ...\t \t \t ", i + 1), strcat(lines,line);
            else if(i < MAX_PACK_INTERIORS)
            {
                DP[4][playerid] = i;
                format(line,sizeof(line),"\n{ffcc00}Покупаю Слот %dG", donatePrice[17]), strcat(lines,line);

                if(i + BUY_SLOTS_PACK < MAX_PACK_INTERIORS)
                {
                    DP[5][playerid] = i + 1; // Следующая строка, поэтому + 1
                    format(line,sizeof(line),"\n{ffcc00}Покупаю %d слотов %dG", BUY_SLOTS_PACK, donatePrice[18]), strcat(lines,line);
                }
                break;
            }
        }
    }
	ShowDialog(playerid, PACK_INTERIORS_MENU, DIALOG_STYLE_TABLIST_HEADERS, "{ff9000}Архив Интерьеров", lines, "Выбор", "Отмена");
    return true;
}

stock showDialogSettingPackInterior(playerid)
{
    new i = DP[0][playerid];
    if(i < 0 || i >= MAX_PACK_INTERIORS) return false;

    new line[100], lines[1000];

    if(PackInteriors[playerid][i][piNewid] > 0)
    {
        format(line,sizeof(line),"{ff9000}%d. %s {cccccc}%s", i + 1, 
            PackInteriors[playerid][i][piName], 
            interiorsType[PackInteriors[playerid][i][piTypeInterior]]), strcat(lines,line);
    }
    else format(line,sizeof(line),"{cccccc}%d. Свободный слот", i + 1), strcat(lines,line);

    format(line,sizeof(line),"\n{99ff66}Сохранить"), strcat(lines,line);
    if(PackInteriors[playerid][i][piNewid] > 0)
    {
        format(line,sizeof(line),"\n{ff9000}Установить >>"), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}Изменить Название"), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}Информация >>"), strcat(lines,line);
        format(line,sizeof(line),"\n{FF6347}Удалить"), strcat(lines,line);
    }
    ShowDialog(playerid, PACK_INTERIORS_SETTING, DIALOG_STYLE_TABLIST_HEADERS, "{ff9000}Архив Интерьеров", lines, "Выбор", "Отмена");
    return true;
}

stock showDialogNamePackInterior(playerid)
{
    new i = DP[0][playerid];
    new string[160];
    format(string,sizeof(string),"{cccccc}Введите {ff9000}название {cccccc}интерьера № %d\n\n{ffcc66}Используйте только буквы и цифры\n{ffcc66}Не меньше 3 и не больше 30 символов", i + 1);
    ShowDialog(playerid,PACK_INTERIORS_NAME,DIALOG_STYLE_INPUT, "{ff9000}Архив Интерьеров",string,"Принять","Отмена");
    return true;
}

stock showDialogInfoPackInterior(playerid)
{
    new i = DP[0][playerid];
    if(i < 0 || i >= MAX_PACK_INTERIORS) return false;
    if(PackInteriors[playerid][i][piNewid] == 0) return false;

    new line[100], lines[1400];
    new tyear, tmonth, tday, thour, tminute, tsecond;
	
    format(line,sizeof(line),"{ff9000}Личный Интерьер № %d {444444}[ %d database id ]\n", i + 1, PackInteriors[playerid][i][piNewid]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Название: {ff9000}%s", PackInteriors[playerid][i][piName]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Тип: {ff9000}%s", interiorsType[PackInteriors[playerid][i][piTypeInterior]]), strcat(lines,line);
    if(PackInteriors[playerid][i][piTypeInterior] == 0)
    {
        if(PackInteriors[playerid][i][piClass] == 5) format(line,sizeof(line),"\n{cccccc}Класс: {ff9000}VIP"), strcat(lines,line);
        else if(PackInteriors[playerid][i][piClass] > 0) format(line,sizeof(line),"\n{cccccc}Класс: %d", PackInteriors[playerid][i][piClass]), strcat(lines,line);
    }
    format(line,sizeof(line),"\n{cccccc}Объектов: %d", PackInteriors[playerid][i][piObjects]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Гос стоимость: {99ff66}%d$ {cccccc}(%s)", PackInteriors[playerid][i][piPrice], get_k(PackInteriors[playerid][i][piPrice])), strcat(lines,line);

    stamp2datetime(PackInteriors[playerid][i][piCreateUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
    format(line,sizeof(line),"\n{cccccc}Дата добавления: %02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute), strcat(lines,line);

    if(PackInteriors[playerid][i][piEditUnix] > 0)
    {
        stamp2datetime(PackInteriors[playerid][i][piEditUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
        format(line,sizeof(line),"\n{cccccc}Последнее сохранение: %02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute), strcat(lines,line);
    }
    ShowDialog(playerid, PACK_INTERIORS_INFO, DIALOG_STYLE_MSGBOX, "{ff9000}Архив Интерьеров", lines, "Ок", "");
    return true;
}

stock dialogCase_PackInterior(playerid, dialogid, response, listitem, const inputtext[])
{
    switch (e_DialogId: dialogid) 
    {
        case PACK_INTERIORS_MENU: // Открываем выбранный интерьер
        {
            if(response) 
            {
                if(DP[4][playerid] > 0 && DP[4][playerid] == listitem)
                {
                    DP[6][playerid] = 1;
					new line[120];
					format(line,sizeof(line),"{ff9000}Вы хотите приобрести {ff9000}Слот архива интерьеров?\n{cccccc}Стоимость: {ffcc00}%dG", donatePrice[17]);
					ShowDialog(playerid, PACK_INTERIORS_DONATE, DIALOG_STYLE_MSGBOX,"{ff9000}Donate", line, "Да", "Нет");
                }
                else if(DP[5][playerid] > 0 && DP[5][playerid] == listitem)
                {
                    DP[6][playerid] = BUY_SLOTS_PACK;
					new line[120];
					format(line,sizeof(line),"{ff9000}Вы хотите приобрести {ff9000}%d слотов архива интерьеров?\n{cccccc}Стоимость: {ffcc00}%dG", BUY_SLOTS_PACK, donatePrice[18]);
					ShowDialog(playerid, PACK_INTERIORS_DONATE, DIALOG_STYLE_MSGBOX,"{ff9000}Donate", line, "Да", "Нет");
                }
                else
                {
                    DP[0][playerid] = listitem;
                    showDialogSettingPackInterior(playerid);
                }
            }
            return true;
        }

        case PACK_INTERIORS_DONATE:
        {
            if(response)
            {
                new price;
                if(DP[6][playerid] == BUY_SLOTS_PACK) price = donatePrice[18];
                else price = donatePrice[17];

                if(PlayerInfo[playerid][pDonateMoney] < price) return showDialogPackInteriors(playerid), ErrorText(playerid, "[ Мысли ]: Мне не хватает золота");
                if(PlayerInfo[playerid][pPackInteriors] >= MAX_PACK_INTERIORS) return showDialogPackInteriors(playerid), ErrorText(playerid, "[ Мысли ]: У меня куплены все слоты");

                if(DP[6][playerid] == BUY_SLOTS_PACK) PlayerInfo[playerid][pPackInteriors] += 5;
                else PlayerInfo[playerid][pPackInteriors] ++;
                new string_mysql[120];
                mysql_format(pearsq, string_mysql ,sizeof(string_mysql), "UPDATE `pp_igroki` SET `pPackInteriors` = '%d' WHERE `user_id` = '%d'", 
                    PlayerInfo[playerid][pPackInteriors], PlayerInfo[playerid][pID]);
                mysql_tquery(pearsq, string_mysql);

                PlayerInfo[playerid][pDonateMoney] -= price;
                tclArifmetikAllGold -= price;
                mysql_save(playerid, 4);

                showDialogPackInteriors(playerid);
                PlayerPlaySound(playerid,6401,0,0,0);

                new string[90];
                if(DP[6][playerid] == BUY_SLOTS_PACK) format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d C‡OЏO‹ KYЊ‡EHO: ~y~-%dG", BUY_SLOTS_PACK, price);
                else format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~C‡OЏ KYЊ‡EH: ~y~-%dG", price);
                GameTextForPlayer(playerid,string,4000,3);
                DonateLog("buypackint",PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -price, "");
            }
            else showDialogPackInteriors(playerid);
        }

        case PACK_INTERIORS_SETTING:
        {
            if(response)
            {
                if(listitem == 0) // Сохранить
                {
                    new string[300];
                    new typeInterior;
                    new ownerID;
                    WherePlayerInInterior(playerid, typeInterior, ownerID);
                    if(ownerID == 0) return ErrorMessage(playerid, "{FF6347}Вы должны находиться в интерьере дома или бизнеса, чтобы его сохранить");
                    if(typeInterior == 0 && AccessRightDomInterior(playerid, ownerID)) return true; // Проверка прав доступа на редактирование интерьера в доме
                    if(typeInterior == 1)
                    {
                        if(!IsABizInteriorFrame(ownerID)) return ErrorMessage(playerid, "{FF6347}В этом бизнесе нет системы интерьеров и мебели");
                        if(!GetAccessBiz(playerid, ownerID, 7)) return false; // Проверка прав доступа на редактирование интерьа в бизе
                        if(IsAJizzyBiz(ownerID)) return ErrorMessage(playerid, "{FF6347}Из этого бизнеса запрещено сохранять планировку");
                    }

                    DP[2][playerid] = typeInterior;
                    DP[3][playerid] = ownerID;

                    new id_interior;
                    if(typeInterior == 0) id_interior = DomInfo[ownerID][dInteriorPack];
                    else if(typeInterior == 1) id_interior = BizzInfo[ownerID][bInteriorPack];

                    // Сохраняем интерьер в новый слот (значит считаем бабосик)
                    if(((typeInterior == 0 && DomInfo[ownerID][dInteriorPack] > 0) || (typeInterior == 1 && BizzInfo[ownerID][bInteriorPack] > 0))
                    && PackInteriors[playerid][DP[0][playerid]][piNewid] == 0
                    || id_interior != PackInteriors[playerid][DP[0][playerid]][piNewid] && id_interior > 0)
                    {
                        new price = GetPriceInterior(typeInterior, ownerID);
                        DP[1][playerid] = price;
                        format(string, sizeof(string),"{cccccc}Стоимость сохранения интерьера в новый слот: {99ff66}%d$ {cccccc}(%s)\n\n{FF6347}Внимание! В этот слот сохранится тот интерьер, в котором вы сейчас находитесь\n{ff9000}Вы уверены, что хотите сохранить интерьер?", price, get_k(price));
                        ShowDialog(playerid, PACK_INTERIORS_SAVE, DIALOG_STYLE_MSGBOX, "{ff9000}Архив Интерьеров", string, "Да", "Нет");
                    }
                    else
                    {
                        DP[1][playerid] = 0;
                        format(string, sizeof(string),"{cccccc}Стоимость сохранения интерьера: {99ff66}Бесплатно\n\n{FF6347}Внимание! В этот слот сохранится тот интерьер, в котором вы сейчас находитесь\n{ff9000}Вы уверены, что хотите сохранить интерьер?");
                        ShowDialog(playerid, PACK_INTERIORS_SAVE, DIALOG_STYLE_MSGBOX, "{ff9000}Архив Интерьеров", string, "Да", "Нет");
                    }
                }
                else if(listitem == 1) // Установить
                {
                    new i = DP[0][playerid];

                    new typeInterior;
                    new ownerID;
                    WherePlayerInInterior(playerid, typeInterior, ownerID);
                    if(ownerID == 0) return ErrorMessage(playerid, "{FF6347}Вы должны находиться в интерьере дома или бизнеса, чтобы его сохранить");
                    if(typeInterior != PackInteriors[playerid][i][piTypeInterior]) return ErrorMessage(playerid, "{FF6347}Тип интерьера не подходит для помещения в котором вы находитесь\n{ffcc66}Интерьер для домов подходит только домам, а бизнесы только бизнесам");
                    if(typeInterior == 0) 
                    {
                        if(AccessRightDomInterior(playerid, ownerID)) return true; // Проверка прав доступа на редактирование интерьера в доме
                        if(PackInteriors[playerid][i][piClass] > 0 && DomInfo[ownerID][dClass] > PackInteriors[playerid][i][piClass] 
                            && DomInfo[ownerID][dClass] != 5) return ErrorMessage(playerid, "{FF6347}Класс интерьера не подходит для класса этого дома");
                        if(PackInteriors[playerid][i][piObjects] > 301 && DomInfo[ownerID][dMoreIntObjects] == false) return ErrorMessage(playerid, "{FF6347}В этот дом нельзя установить интерьер с таким количеством объектов\n{ffcc66}В доме необходимо приобрести увеличенный лимит объектов [ /mydom >> Донат ]");
                    }
                    else if(typeInterior == 1)
                    {
                        if(!IsABizInteriorFrame(ownerID)) return ErrorMessage(playerid, "{FF6347}В этом бизнесе нет системы интерьеров и мебели");
                        if(!GetAccessBiz(playerid, ownerID, 7)) return false; // Проверка прав доступа на редактирование интерьа в бизе
                        if(IsAJizzyBiz(ownerID)) return ErrorMessage(playerid, "{FF6347}В этот бизнес запрещено устанавливать другие интерьеры");
                        if(PackInteriors[playerid][i][piObjects] >= MAX_OBJECT_INT_BIZ) return ErrorMessage(playerid, "{FF6347}В этот бизнес нельзя установить интерьер с таким количеством объектов");
                    }

                    DP[2][playerid] = typeInterior;
                    DP[3][playerid] = ownerID;
                    
                    new string[200];
                    format(string, sizeof(string),"{cccccc}Вы уверены, что хотите установить интерьер?\n{FF6347}Внимание! Все текущие объекты будут удалены, включая планировку и улицу!");
                    ShowDialog(playerid, PACK_INTERIORS_INSTALL, DIALOG_STYLE_MSGBOX, "{ff9000}Архив Интерьеров", string, "Да", "Нет");
                }
                else if(listitem == 2) // Название
                {
                    showDialogNamePackInterior(playerid);
                }
                else if(listitem == 3) // Информация
                {
                    showDialogInfoPackInterior(playerid);
                }
                else if(listitem == 4) // Удалить
                {
                    ShowDialog(playerid, PACK_INTERIORS_DELETE, DIALOG_STYLE_MSGBOX, "{ff9000}Архив Интерьеров", "{FF6347}Вы уверены, что хотите удалить интерьер?", "Да", "Нет");
                }
            }
            else showDialogPackInteriors(playerid);
        }
        case PACK_INTERIORS_INFO: showDialogSettingPackInterior(playerid);
        case PACK_INTERIORS_NAME:
        {
            new i = DP[0][playerid];
            if(response)
            {
                if(strlen(inputtext) < 3 || strlen(inputtext) > 30 || checksimvol(inputtext)) return showDialogNamePackInterior(playerid);

                format(PackInteriors[playerid][i][piName], 44, "%s", inputtext);

                new string_mysql[140];
                mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `pp_pack_interiors` SET `piName`='%e' WHERE `piNewid`='%d'", 
                    PackInteriors[playerid][i][piName], PackInteriors[playerid][i][piNewid]);
                query_empty(pearsq, string_mysql);

                showDialogSettingPackInterior(playerid);
            }
            else showDialogSettingPackInterior(playerid);
        }
        case PACK_INTERIORS_INSTALL:
        {
            if(response)
            {
                new i = DP[0][playerid];
                if(PackInteriors[playerid][i][piNewid] == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Интерьера не существует");
                
                new typeInterior = DP[2][playerid];
                new ownerID = DP[3][playerid];
                if(PauseInstallInterior(playerid, typeInterior, ownerID)) return true;
                
                new string_mysql[200];
                mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT data FROM `pp_pack_interiors` WHERE `piNewid` = '%d'", PackInteriors[playerid][i][piNewid]);
			    mysql_tquery(pearsq, string_mysql, "LoadPackInterior", "ddddd", playerid, DP[2][playerid], DP[3][playerid], PackInteriors[playerid][i][piNewid], i);
            }
            else showDialogSettingPackInterior(playerid);
        }
        case PACK_INTERIORS_SAVE:
        {
            if(response)
            {
                if(DP[1][playerid] > PlayerInfo[playerid][pAccount]) return ErrorMessage(playerid, "{FF6347}На вашем банковском счету недостаточно средств");
                if(GetPVarInt(playerid,"antiflood") > 0) return ErrorMessage(playerid, "{FF6347}Пожалуйста, подождите 3 секунды и повторите попытку");

                new typeInterior = DP[2][playerid];
                new ownerID = DP[3][playerid];
                if(PauseInstallInterior(playerid, typeInterior, ownerID)) return true;

                SetPVarInt(playerid,"antiflood",3);
                SaveThisInteriors(playerid, DP[0][playerid], typeInterior, ownerID);

                if(DP[1][playerid] > 0)
                {
                    oGivePlayerBank(playerid, -DP[1][playerid]);
                    MoneyLog("int_save", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -DP[1][playerid], "Сохранил интерьер");
                }
            }
            else showDialogSettingPackInterior(playerid);
        }
        case PACK_INTERIORS_DELETE:
        {
            if(response)
            {
                new i = DP[0][playerid];
                if(PackInteriors[playerid][i][piNewid] == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Интерьера не существует");

                new string_mysql[200];
                mysql_format(pearsq, string_mysql, sizeof(string_mysql),"DELETE FROM `pp_pack_interiors` WHERE `piNewid` = '%d'", PackInteriors[playerid][i][piNewid]);
			    mysql_tquery(pearsq, string_mysql);
            
                new string[60];
			    format(string,sizeof(string),"Удалил интерьер %d", PackInteriors[playerid][i][piNewid]);
			    UserLog("int_delete", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, string);
                PackInteriors[playerid][i][piNewid] = 0;

                PlayerPlaySound(playerid,31200,0,0,0);
                showDialogPackInteriors(playerid);
            }
            else showDialogSettingPackInterior(playerid);
        }
    }
    return false;
}

// Проверка и установка паузы для загрузки и сохранения интерьера
stock PauseInstallInterior(playerid, typeInterior, ownerID)
{
    if(CDProcessInterior[playerid] == true) return ErrorMessage(playerid, "{FF6347}Ошибка! Дождитесь завершения загрузки или установки интерьера");
    CDProcessInterior[playerid] = true;

    if(typeInterior == 0)
    {
        if(ownerID < 0 || ownerID >= MAX_DOM) return false;
        if(DomInfo[ownerID][dCDInstallInterior] == true) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения установки или сохранения интерьера");
        DomInfo[ownerID][dCDInstallInterior] = true;
    }
    else if(typeInterior == 1)
    {
        if(ownerID < 0 || ownerID >= MAX_BIZ) return false;
        if(BizzInfo[ownerID][bCDInstallInterior] == true) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения установки или сохранения интерьера");
        BizzInfo[ownerID][bCDInstallInterior] = true;
    }
    return false;
}

// Очищаем паузу установки интерьера
stock ClearPauseInstallInterior(playerid, typeInterior, ownerID)
{
    CDProcessInterior[playerid] = false;
    if(typeInterior == 0) DomInfo[ownerID][dCDInstallInterior] = false;
    else if(typeInterior == 1) BizzInfo[ownerID][bCDInstallInterior] = false;
    return true;
}

// Начинаем сохранять интерьер в архив
stock SaveThisInteriors(playerid, slot, typeInterior, ownerID)
{
    // Создаём общую ноду для всех объектов и считаем их стоимость
    new price, quanObjects, classInt;
    new JsonNode:node;
    CreatePackInteriorsNodeObjects(node, typeInterior, ownerID, price, quanObjects, classInt);

    static text[120000];
    if (JSON_Stringify(node, text) == JSON_CALL_NO_ERR)
    {
        if(PackInteriors[playerid][slot][piNewid] > 0)
        {
            PackInteriors[playerid][slot][piTypeInterior] = typeInterior;
            PackInteriors[playerid][slot][piPrice] = price;
            PackInteriors[playerid][slot][piObjects] = quanObjects;
            PackInteriors[playerid][slot][piEditUnix] = gettime();
            PackInteriors[playerid][slot][piClass] = classInt;

            static string_mysql[120000];
            mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `pp_pack_interiors` SET \
                `piTypeInterior` = '%d', `piPrice` = '%d', `piObjects` = '%d', `piEditUnix` = '%d', `piClass` = '%d', `data` = '%e' WHERE `piNewid` = '%d'",
                    PackInteriors[playerid][slot][piTypeInterior],
                    PackInteriors[playerid][slot][piPrice],
                    PackInteriors[playerid][slot][piObjects],
                    PackInteriors[playerid][slot][piEditUnix],
                    PackInteriors[playerid][slot][piClass],
                    text,
                    PackInteriors[playerid][slot][piNewid]);
            mysql_tquery(pearsq, string_mysql);

            ClearPauseInstallInterior(playerid, typeInterior, ownerID);
        }
        else
        {
            PackInteriors[playerid][slot][piUserid] = PlayerInfo[playerid][pID];
            PackInteriors[playerid][slot][piTypeInterior] = typeInterior;
            PackInteriors[playerid][slot][piPrice] = price;
            PackInteriors[playerid][slot][piObjects] = quanObjects;
            PackInteriors[playerid][slot][piCreateUnix] = gettime();
            PackInteriors[playerid][slot][piClass] = classInt;
            format(PackInteriors[playerid][slot][piName], 44, "Инт %d от %s", slot + 1, PlayerInfo[playerid][pName]);

            static string_mysql[120000];
            mysql_format(pearsq, string_mysql, sizeof(string_mysql), "INSERT INTO `pp_pack_interiors` \
                (`piUserid`, `piTypeInterior`, `piPrice`, `piObjects`, `piCreateUnix`, `piName`, `slot`, `piClass`, `data`) \
            VALUES ('%d', '%d', '%d', '%d', '%d', '%s', '%d', '%d', '%e')", 
                PackInteriors[playerid][slot][piUserid], 
                PackInteriors[playerid][slot][piTypeInterior],
                PackInteriors[playerid][slot][piPrice],
                PackInteriors[playerid][slot][piObjects],
                PackInteriors[playerid][slot][piCreateUnix],
                PackInteriors[playerid][slot][piName],
                slot,
                PackInteriors[playerid][slot][piClass],
                text);

            mysql_tquery(pearsq, string_mysql, "Call_Getid_PackInterior", "dddd", playerid, slot, typeInterior, ownerID);
        }
    }

    SuccessMessage(playerid, "{99ff66}Интерьер сохранён!");
    return true;
}

// Интерьер добавлен в архив, записываем id
function Call_Getid_PackInterior(playerid, slot, typeInterior, ownerID)
{
    PackInteriors[playerid][slot][piNewid] = cache_insert_id();

    if(typeInterior == 0) SetDomThisInterior(ownerID, PackInteriors[playerid][slot][piNewid]);
    else if(typeInterior == 1) SetBizThisInterior(ownerID, PackInteriors[playerid][slot][piNewid]);

    ClearPauseInstallInterior(playerid, typeInterior, ownerID);
    return 1;
}

// Собираем все объекты интерьеров в одну ноду (кроме уличных)
stock CreatePackInteriorsNodeObjects(&JsonNode:node, typeInterior, ownerID, &price, &quanObjects, &classInt)
{
    new max_Objects;
    if(typeInterior == 0) 
    {
        classInt = GetClassOnObjectFrame(DomInfo[ownerID][dOmodel][0]);
        max_Objects = MAX_OBJECT_INT;
    }
    else if(typeInterior == 1) 
    {
        classInt = GetClassOnObjectFrame(BizzInfo[ownerID][bOmodel][0]);
        max_Objects = MAX_OBJECT_INT_BIZ;
    }

    node = JSON_Array();
    for(new slot = 0; slot < max_Objects; slot++)
    {
        new objectid, model;
        if(typeInterior == 0) objectid = DomInfo[ownerID][dObject][slot];
        else if(typeInterior == 1) objectid = BizzInfo[ownerID][bObject][slot];

        if (!IsValidDynamicObject(objectid)) continue;
        if(GetDynamicObjectVirtualWorld(objectid) == 0 || GetDynamicObjectInterior(objectid) == 0) continue; // Объект на улице не упаковываем
        model = GetDynamicObjectModel(objectid);

        // Объект является каркасом
        if(slot < IsAQuanInterior(model))
        {
            if(slot == 0) price += getFrameObjectPrice(model); // У планировки получаем цену из набора планировок
        }
        else price += getIkeaObjectPrice(model); // Получаем цену объекта из IKEA

        new JsonNode:object_node;
        SerializeDynamicObjectProperties(objectid, object_node); // Получаем ноду каждого объекта
        JSON_ArrayAppendEx(node, object_node); // Кладём каждый объект в нашу большую ноду со всеми объектами

        quanObjects ++;
    }
    return true;
}

stock GetPriceInterior(typeInterior, ownerID)
{
    new max_Objects, price;
    if(typeInterior == 0) max_Objects = MAX_OBJECT_INT;
    else if(typeInterior == 1) max_Objects = MAX_OBJECT_INT_BIZ;

    for(new slot = 0; slot < max_Objects; slot++)
    {
        new objectid, model;
        if(typeInterior == 0) objectid = DomInfo[ownerID][dObject][slot];
        else if(typeInterior == 1) objectid = BizzInfo[ownerID][bObject][slot];

        if (!IsValidDynamicObject(objectid)) continue;
        if(GetDynamicObjectVirtualWorld(objectid) == 0 || GetDynamicObjectInterior(objectid) == 0) continue; // Объект на улице не упаковываем
        model = GetDynamicObjectModel(objectid);

        // Объект является каркасом
        if(slot < IsAQuanInterior(model))
        {
            if(slot == 0) price += getFrameObjectPrice(model); // У планировки получаем цену из набора планировок
        }
        else price += getIkeaObjectPrice(model); // Получаем цену объекта из IKEA
    }
    return price;
}

// Получаем свободный слот интерьера их архива
stock GetFreeSlotPackInteriors(playerid)
{
    new slots = -1;
    for(new i = 0; i < MAX_PACK_INTERIORS; i++)
    {
        if(PackInteriors[playerid][i][piNewid] == 0)
        {
            slots = i;
            break;
        }
    }
    return slots;
}

/*
if(PackInteriors[playerid][i][piObjects] > 301 && DomInfo[ownerID][dMoreIntObjects] == false) return ErrorMessage(playerid, "{FF6347}В этот дом нельзя установить интерьер с таким количеством объектов\n{ffcc66}В доме необходимо приобрести увеличенный лимит объектов [ /mydom >> Донат ]");

if(PackInteriors[playerid][i][piObjects] >= MAX_OBJECT_INT_BIZ) return ErrorMessage(playerid, "{FF6347}В этот бизнес нельзя установить интерьер с таким количеством объектов");
*/

// Чекаем чё там по количеству объектов с учетом уличных
stock CheckInstallInteriorObjects(playerid, typeInterior, ownerID, i, quanStreetObjects, maxObjects)
{
    if(PackInteriors[playerid][i][piObjects] + quanStreetObjects > maxObjects)
    {
        new string[150];
        format(string, sizeof(string), "{FF6347}Не хватает %d слотов объектов для установки интерьера\n/
        {ffcc66}Вероятно, объекты на улице занимают недостающее количество слотов", 
            maxObjects - PackInteriors[playerid][i][piObjects] + quanStreetObjects);
        ErrorMessage(playerid, string);

        ClearPauseInstallInterior(playerid, typeInterior, ownerID); // Прервали процесс - тогда очищаем кд на загрузку
        return false;
    }
    return false;
}

function LoadPackInterior(playerid, typeInterior, ownerID, newid, i)
{
    new rows;
    cache_get_row_count(rows);

    if(rows)
    {
        new world;
        new interior;

        // Действия и проверки перед установкой
        if(typeInterior == 0) // Объекты грузятся в дом
        {
            new quanStreetObjects = GetQuanObjectsStreetDom(ownerID);
            new maxObjects = GetMaxDomObjects(ownerID);
            if(CheckInstallInteriorObjects(playerid, typeInterior, ownerID, i, quanStreetObjects, maxObjects)) return false;

            EjectDom(ownerID, playerid, false); // Выгоняем игроков из помещения
            world = ownerID + 1000;
            interior = 90;

            // Удаляем объекты в интерьере из дома
            DestroyAllInteriorObjectsDom(ownerID);
        }
        else if(typeInterior == 1) // Объекты грузятся в биз
        {
            new quanStreetObjects = GetQuanObjectsStreetBiz(ownerID);
            new maxObjects = GetMaxBizObjects(ownerID);
            if(CheckInstallInteriorObjects(playerid, typeInterior, ownerID, i, quanStreetObjects, maxObjects)) return false;

            EjectBiz(ownerID, playerid, false); // Выгоняем игроков из помещения
            world = ownerID + 3000;
            interior = 90;

            // Удаляем объекты из бизнеса
            DestroyAllInteriorObjectsVBiz(ownerID);
        }

        static string_json[120000];
        cache_get_value_name(0, "data", string_json, sizeof(string_json));

        new JsonNode:node = JSON_INVALID_NODE;
        if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
        {
            new JsonNode:json_object;
            new index = -1;
            new object;
            while(!JSON_ArrayIterate(node, index, json_object))
            {
                new slot;
                if(typeInterior == 0) slot = GetFreeSlotObjectDom(ownerID);
                else if(typeInterior == 1) slot = GetFreeSlotObjectBiz(ownerID);

                if(slot == -1) // Слот не нашли, останавливаем процесс
                {
                    ClearPauseInstallInterior(playerid, typeInterior, ownerID);
                    break;
                }

                DeserializeDynamicObjectProperties(json_object, object);
                SetDynamicObjectVirtualWorld(object, world);
                SetDynamicObjectInterior(object, interior);

                if(typeInterior == 0) // Объекты грузятся в дом
                {
                    DomInfo[ownerID][dObject][slot] = object;
                    DomInfo[ownerID][dUser][slot] = PlayerInfo[playerid][pID];
                    DomInfo[ownerID][dOmodel][slot] = GetDynamicObjectModel(object);

                    // Сохраняем каждый объект в базу
			        UpdateObject(ownerID, slot);
                }
                else if(typeInterior == 1) // Объекты грузятся в бизнес
                {
                    BizzInfo[ownerID][bObject][slot] = object;
                    BizzInfo[ownerID][bUser][slot] = PlayerInfo[playerid][pID];
                    BizzInfo[ownerID][bOmodel][slot] = GetDynamicObjectModel(object);

                    // Сохраняем каждый объект в базу
			        UpdateObjectBiz(ownerID, slot);
                }
            }
        }

        if(typeInterior == 0) SetDomThisInterior(ownerID, newid);
        else if(typeInterior == 1) SetBizThisInterior(ownerID, newid);
    }
    else ErrorMessage(playerid, "{FF6347}Ошибка! Интерьер не найден в базе данных");

    ClearPauseInstallInterior(playerid, typeInterior, ownerID);
    return 1;
}


// Личное хранилище текстур
enum ObjectMaterialInfo
{
    copy_modelid,
    copy_texturelib[32],
	copy_texturename[32],
    copy_materialcolor
};
new CopyMaterial[MAX_REALPLAYERS][16][ObjectMaterialInfo]; // Набор интерьеров в личном архиве каждого игрока

// Очищаем переменные текстур
stock ClearVariableCopyMaterial(playerid)
{
    for(new i = 0; i < 16; i++) CopyMaterial[playerid][i][copy_modelid] = 0, CopyMaterial[playerid][i][copy_materialcolor] = 0;
    return true;
}

// Копируем текстуры с объекта
stock CopyMaterialsFromObject(playerid, objectid)
{
    if(!IsValidDynamicObject(objectid)) return 0;

    new quan;
    for(new i = 0; i < 16; i++)
    {
        new yesText;
        CopyMaterial[playerid][i][copy_modelid] = 0; // Очищаем переменную
        yesText = GetDynamicObjectMaterial(objectid, i, CopyMaterial[playerid][i][copy_modelid], CopyMaterial[playerid][i][copy_texturelib], CopyMaterial[playerid][i][copy_texturename], CopyMaterial[playerid][i][copy_materialcolor]);
        if(!yesText) CopyMaterial[playerid][i][copy_modelid] = 0; // Если тексты в слоте не оказалось, чистим
        
        if(CopyMaterial[playerid][i][copy_modelid] > 0) quan ++; // Считаем записанные текстуры
    }
    return quan;
}

stock PasteMaterialsToObject(playerid, objectid)
{
    if(!IsValidDynamicObject(objectid)) return true;

    new quan;
    for(new i = 0; i < 16; i++)
    {
        if(CopyMaterial[playerid][i][copy_modelid] > 0)
        {
            quan ++;
            SetDynamicObjectMaterial(objectid, i, CopyMaterial[playerid][i][copy_modelid], CopyMaterial[playerid][i][copy_texturelib], CopyMaterial[playerid][i][copy_texturename], CopyMaterial[playerid][i][copy_materialcolor]);
        }
    }
    if(quan == 0) return false;

    return true;
}

// Количество текстур в буфере обмена
stock GetQuanCopyMaterial(playerid)
{
    new quan;
    for(new i = 0; i < 16; i++)
    {
        if(CopyMaterial[playerid][i][copy_modelid] > 0) quan ++;
    }
    return quan;
}

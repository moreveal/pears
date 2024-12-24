
#define MAX_FUND_RAISERS 50
#define MAX_FUND_GIFT 3

enum fundInfo
{
    fundNewid, // id в базе
    bool:fundStat, // Создан ли сбор
    bool:fundActive, // Включен ли сбор
    fundName[44], // Название сбора
    fundText[84], // Описание сбора
    fundMoney, // Собранное лаве
    fundRequired, // Сколько требуется собрать
    Float:fundPos[3], // Позиция сбора
    fundUnix, // Дата начала сбора
    fundQuan, // Количество пожертвований
    fundMaxMoney, // Максимальное пожертвование сумма
    fundMaxPlayerid, // Максимальное пожертвование id аккаунта
    fundMaxPlayerName[24], // Максимальное пожертвование имя игрока
    fundMaxUnix, // Дата и время максимального пожертвования

    bool:fundGift, // Подарки при пожертвовании
    fundGiftThingId[MAX_FUND_GIFT], // ID Подарка при пожертвовании
    fundGiftThingQuan[MAX_FUND_GIFT], // Количество Предмета
    fundGiftThingType[MAX_FUND_GIFT], // Тип Предмета
    fundGiftPrice[MAX_FUND_GIFT], // От какой суммы пожертвования этот подарок

    fundPickup,
    Text3D:fundLabel
}
new FundRaisersInfo[MAX_FUND_RAISERS][fundInfo];
new QuanFundRaisers; // Количество активных пожертвований

new aFloodFund[MAX_REALPLAYERS];

CMD:fund(playerid)
{
    if(PlayerInfo[playerid][pSoska] >= 19)
    {
        FundRaisers(playerid);
        PlayerPlaySound(playerid,40405,0,0,0);
    }
    else ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    return 1;
}

stock ShowFundRaisers(playerid)
{
    new fundId;
    for(new i = 0; i < MAX_FUND_RAISERS; i++) 
    {
        if(FundRaisersInfo[i][fundStat])
        {
            if(IsPlayerInRangeOfPoint(playerid,2.0,FundRaisersInfo[i][fundPos][0], FundRaisersInfo[i][fundPos][1], FundRaisersInfo[i][fundPos][2]))
			{
                fundId = i + 1;
                DP[0][playerid] = i;
                MenuFundRaisers(playerid, i);
                PlayerPlaySound(playerid,40405,0,0,0);
                break;
            }
        }
    }
    return fundId;
}

stock MenuFundRaisers(playerid, i)
{
    new line[80],lines[240];
    format(line,sizeof(line),"{cccccc}%s\t", FundRaisersInfo[i][fundName]), strcat(lines,line);
    format(line,sizeof(line),"\n{ff9000}Информация >>"), strcat(lines,line);
    format(line,sizeof(line),"\n{99ff66}Пожертвовать"), strcat(lines,line);
    ShowDialog(playerid,1408,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Сбор Средств",lines,"Выбрать","Выход");
    return 1;
}

stock FundRaisers(playerid)
{
    new line[140],lines[4096];
    format(line,sizeof(line),"{cccccc}Название\tСобрано"), strcat(lines,line);
    for(new i = 0; i < MAX_FUND_RAISERS; i++) 
    {
        if(FundRaisersInfo[i][fundActive])
        {
            format(line,sizeof(line),"\n{ff9000}%d. %s\t{99ff66}%d$ / {cccccc}%d$", i + 1, FundRaisersInfo[i][fundName], FundRaisersInfo[i][fundMoney], FundRaisersInfo[i][fundRequired]), strcat(lines,line);
        }
        else format(line,sizeof(line),"\n{cccccc}%d. Добавить >>\t", i + 1), strcat(lines,line);
    }
    new header[60];
	format(header,sizeof(header),"{ff9000}Сбор Средств {cccccc}[ Сборов: %d ]", QuanFundRaisers);
	ShowDialog(playerid,1401,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Выбрать","Выход");
}

stock SettingFundRaisers(playerid, i)
{
    new line[100],lines[900];
    format(line,sizeof(line),"{cccccc}Настройки Сбора\t"), strcat(lines,line);
    format(line,sizeof(line),"\n{ff9000}Информация >>"), strcat(lines,line);

    if(FundRaisersInfo[i][fundActive]) format(line,sizeof(line),"\n{cccccc}Статус сбора:\t{99ff66}Активен"), strcat(lines,line);
    else format(line,sizeof(line),"\n{cccccc}Статус сбора:\t{FF6347}Неактивен"), strcat(lines,line);

    format(line,sizeof(line),"\n{cccccc}Название:\t%s", FundRaisersInfo[i][fundName]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Описание\t"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Требуется собрать:\t{99ff66}%d$", FundRaisersInfo[i][fundRequired]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Позиция сбора >>\t"), strcat(lines,line);
    format(line,sizeof(line),"\n{F4254F}Подарки при пожертвовании >> \t"), strcat(lines,line);
    format(line,sizeof(line),"\n{FF6347}Завершить сбор\t"), strcat(lines,line);
    new header[60];
    format(header,sizeof(header),"{ff9000}Сбор Средств {cccccc}[ Сборов: %d ]", QuanFundRaisers);
    ShowDialog(playerid,1402,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Выбрать","Выход");
    return 1;
}

stock SettingFundRaisersGift(playerid, i)
{
    new line[140],lines[4096];

    for(new g = 0; g < MAX_FUND_GIFT; g++) 
    {
        if(FundRaisersInfo[i][fundGiftThingId][g] > 0) 
        {
            format(line,sizeof(line),"{cccccc}%d. {BF91F8}%s\n", g + 1, GetNameThing(0, FundRaisersInfo[i][fundGiftThingId][g], FundRaisersInfo[i][fundGiftThingType][g], 0));
        }
        else format(line,sizeof(line),"{cccccc}%d. Настроить >>\n", g + 1);
        strcat(lines,line);
    }
    ShowDialog(playerid,1411,DIALOG_STYLE_TABLIST,"{ff9000}Сбор Средств",lines,"Выбрать","Выход");
    return 1;
}

stock InfoFundRaisers(playerid, i)
{
    new tyear, tmonth, tday, thour, tminute, tsecond;
    stamp2datetime(FundRaisersInfo[i][fundUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
    new line[130],lines[4096];

    if(!FundRaisersInfo[i][fundName]) format(line,sizeof(line),"{FF6347}Название не заполнено"), strcat(lines,line);
    else format(line,sizeof(line),"{ff9000}%s", FundRaisersInfo[i][fundName]), strcat(lines,line);
    if(!FundRaisersInfo[i][fundText]) format(line,sizeof(line),"\n{FF6347}Описание не заполнено"), strcat(lines,line);
    else format(line,sizeof(line),"\n{cccccc}%s", FundRaisersInfo[i][fundText]), strcat(lines,line);

    format(line,sizeof(line),"\n\n{cccccc}Собрано: {99ff66}%d$", FundRaisersInfo[i][fundMoney]), strcat(lines,line);
    if(!FundRaisersInfo[i][fundRequired]) format(line,sizeof(line),"\n{cccccc}Требуется: {FF6347}не заполнено"), strcat(lines,line);
    else format(line,sizeof(line),"\n{cccccc}Требуется: {99ff66}%d$", FundRaisersInfo[i][fundRequired]), strcat(lines,line);

    format(line,sizeof(line),"\n\n{cccccc}Количество пожертвований: {ff9000}%d", FundRaisersInfo[i][fundQuan]), strcat(lines,line);
    if(FundRaisersInfo[i][fundUnix] > 0) format(line,sizeof(line),"\n{cccccc}Начало сбора: {555555}%02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute), strcat(lines,line);
    else format(line,sizeof(line),"\n{cccccc}Начало сбора: {555555}не начат"), strcat(lines,line);
    
    format(line,sizeof(line),"\n\n\n{99ff66}Максимальное Пожертвование"), strcat(lines,line);
    if(FundRaisersInfo[i][fundMaxPlayerid])
    {
        new tyear2, tmonth2, tday2, thour2, tminute2, tsecond2;
        stamp2datetime(FundRaisersInfo[i][fundMaxUnix], tyear2, tmonth2, tday2, thour2, tminute2, tsecond2, 3);
        format(line,sizeof(line),"\n{D9F26E}%s", FundRaisersInfo[i][fundMaxPlayerName]), strcat(lines,line);
        format(line,sizeof(line),"\n{99ff66}%d$", FundRaisersInfo[i][fundMaxMoney]), strcat(lines,line);
        format(line,sizeof(line),"\n{555555}%02d.%02d.%d %02d:%02d", tday2, tmonth2, tyear2, thour2, tminute2), strcat(lines,line);
    }
    else format(line,sizeof(line),"\n{555555}нет пожертвований"), strcat(lines,line);

    format(line,sizeof(line),"\n\n\n{F4254F}Подарки при Пожертвовании"), strcat(lines,line);
    if(FundRaisersInfo[i][fundGift])
    {
        for(new g = 0; g < MAX_FUND_GIFT; g++) 
        {
            if(FundRaisersInfo[i][fundGiftThingId][g] > 0)
            {
                format(line,sizeof(line),"\n{D9F26E}От %d$ {BF91F8}%s", FundRaisersInfo[i][fundGiftPrice][g], GetNameThing(0, FundRaisersInfo[i][fundGiftThingId][g], FundRaisersInfo[i][fundGiftThingType][g], 0)), strcat(lines,line);
            }
        }
        format(line,sizeof(line),"\n{cccccc}- Только от требуемой суммы"), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}- Вы получаете все подарки одновременно, если требуемая сумма соблюдена"), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}- Вы НЕ можете получить повторно один и тот-же подарок"), strcat(lines,line);
    }
    else format(line,sizeof(line),"\n{555555}нет"), strcat(lines,line);
    new header[60];
    format(header,sizeof(header),"{ff9000}Сбор Средств {cccccc}[ Сборов: %d ]", QuanFundRaisers);

    if(DP[2][playerid] == 1) ShowDialog(playerid,1403,DIALOG_STYLE_MSGBOX,header,lines,"Ок",""); // Настройки
    else ShowDialog(playerid,1414,DIALOG_STYLE_MSGBOX,header,lines,"Ок",""); // Меню
    return 1;
}

stock UpdateFundRaisers(i)
{
    if(FundRaisersInfo[i][fundStat])
    {
        DestroyDynamicPickup(FundRaisersInfo[i][fundPickup]);
        DestroyDynamic3DTextLabel(FundRaisersInfo[i][fundLabel]);
        FundRaisersInfo[i][fundStat] = false;
    }

    if(FundRaisersInfo[i][fundActive])
    {
        FundRaisersInfo[i][fundPickup] = CreateDynamicPickup(19134, 1, FundRaisersInfo[i][fundPos][0], FundRaisersInfo[i][fundPos][1], FundRaisersInfo[i][fundPos][2], 0, 0, -1, 100.0);

        new line[130],lines[1170];
        format(line,sizeof(line),"\n{ff9000}*** Сбор Средств ***"), strcat(lines,line);
        format(line,sizeof(line),"\n{D9F26E}%s", FundRaisersInfo[i][fundName]), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}Собрано: {99ff66}%d$ / {cccccc}%d$", FundRaisersInfo[i][fundMoney], FundRaisersInfo[i][fundRequired]), strcat(lines,line);

        if(FundRaisersInfo[i][fundGift]) format(line,sizeof(line),"\n{cccccc}Подарки при Пожертвовании: {F4254F}Есть"), strcat(lines,line);
        else format(line,sizeof(line),"\n{cccccc}Подарки при Пожертвовании: {555555}Отсутствуют"), strcat(lines,line);

        format(line,sizeof(line),"\n\n{99ff66}Максимальное Пожертвование"), strcat(lines,line);
        if(FundRaisersInfo[i][fundMaxPlayerid])
        {
            format(line,sizeof(line),"\n{D9F26E}%s", FundRaisersInfo[i][fundMaxPlayerName]), strcat(lines,line);
            format(line,sizeof(line),"\n{99ff66}%d$", FundRaisersInfo[i][fundMaxMoney]), strcat(lines,line);
        }
        else format(line,sizeof(line),"\n{555555}нет пожертвований"), strcat(lines,line);

        format(line,sizeof(line),"\n\n{cccccc}[ ALT - меню сбора ]"), strcat(lines,line);
        FundRaisersInfo[i][fundLabel] = CreateDynamic3DTextLabel(lines,-1,FundRaisersInfo[i][fundPos][0], FundRaisersInfo[i][fundPos][1], FundRaisersInfo[i][fundPos][2],10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);

        FundRaisersInfo[i][fundStat] = true;
    }
    return 1;
}

function LoadFundRaisers()
{
	new time = GetTickCount();
	new rows, i, string[30];
	cache_get_row_count(rows);
	for(new f; f < rows; ++f)
	{
        if(i >= MAX_FUND_RAISERS) break;

        cache_get_value_name_int(f, "fundNewid", FundRaisersInfo[i][fundNewid]);
        cache_get_value_name_bool(f, "fundActive", FundRaisersInfo[i][fundActive]);
        cache_get_value_name(f, "fundName", FundRaisersInfo[i][fundName], 44);
        cache_get_value_name(f, "fundText", FundRaisersInfo[i][fundText], 84);
        cache_get_value_name_int(f, "fundMoney", FundRaisersInfo[i][fundMoney]);
        cache_get_value_name_int(f, "fundRequired", FundRaisersInfo[i][fundRequired]);
        cache_get_value_name_float(f, "fundPos0", FundRaisersInfo[i][fundPos][0]);
        cache_get_value_name_float(f, "fundPos1", FundRaisersInfo[i][fundPos][1]);
        cache_get_value_name_float(f, "fundPos2", FundRaisersInfo[i][fundPos][2]);
        cache_get_value_name_int(f, "fundUnix", FundRaisersInfo[i][fundUnix]);
        cache_get_value_name_int(f, "fundQuan", FundRaisersInfo[i][fundQuan]);
        cache_get_value_name_int(f, "fundMaxMoney", FundRaisersInfo[i][fundMaxMoney]);
        cache_get_value_name_int(f, "fundMaxPlayerid", FundRaisersInfo[i][fundMaxPlayerid]);
        cache_get_value_name(f, "fundMaxPlayerName", FundRaisersInfo[i][fundMaxPlayerName], 24);
        cache_get_value_name_int(f, "fundMaxUnix", FundRaisersInfo[i][fundMaxUnix]);
        cache_get_value_name_bool(f, "fundGift", FundRaisersInfo[i][fundGift]);
        for(new g = 0; g < MAX_FUND_GIFT; g++) 
        {
            format(string, sizeof(string),"fundGiftThingId%d", g);
            cache_get_value_name_int(f, string, FundRaisersInfo[i][fundGiftThingId][g]);
            format(string, sizeof(string),"fundGiftThingQuan%d", g);
            cache_get_value_name_int(f, string, FundRaisersInfo[i][fundGiftThingQuan][g]);
            format(string, sizeof(string),"fundGiftThingType%d", g);
            cache_get_value_name_int(f, string, FundRaisersInfo[i][fundGiftThingType][g]);
            format(string, sizeof(string),"fundGiftPrice%d", g);
            cache_get_value_name_int(f, string, FundRaisersInfo[i][fundGiftPrice][g]);
        }
        if(FundRaisersInfo[i][fundActive]) QuanFundRaisers ++;
        UpdateFundRaisers(i);
        i ++;
    }

    printf("[MODE]: Сбор Средств [%d Quan][%d ms]",rows,GetTickCount() - time);
    return 1;
}

function Call_pay_fundraisers(playerid, i, amount, race_check)
{
    new rows;
	cache_get_row_count(rows);
    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);

    new unix = gettime();
    new input = amount;
    if (input <= 0)
    {
        // снимаем флуд, так как не получилось закинуть
        aFloodFund[playerid] = 0;

        return ErrorMessage(playerid, "{FF6347}Введите корректную сумму");
    }
    new realMoney = FundRaisersInfo[i][fundMoney];
    new realRequired = FundRaisersInfo[i][fundRequired];
    if(realMoney + input > realRequired)
    {
        // снимаем флуд, так как не получилось закинуть
        aFloodFund[playerid] = 0;

        return ErrorMessage(playerid, "{FF6347}Цель сбора требует меньше денежных средств, чем Вы пытаетесь пожертвовать");
    }

    oGivePlayerMoney(playerid, -input);
    payanim(playerid, 0);

    CompleteBattlePassTask(playerid, 41, 1, input);

    new tempMoney = FundRaisersInfo[i][fundMoney] + input;
    FundRaisersInfo[i][fundMoney] = tempMoney;
    FundRaisersInfo[i][fundQuan] ++;

    new line[100],lines[700];
    format(line,sizeof(line),"{99ff66}Благодарим вас за пожертвование в размере {D9F26E}%d$", input), strcat(lines,line);

    // Максимальное Пожертвование
    if(input > FundRaisersInfo[i][fundMaxMoney])
    {
        FundRaisersInfo[i][fundMaxMoney] = input;
        FundRaisersInfo[i][fundMaxPlayerid] = PlayerInfo[playerid][pID];
        format(FundRaisersInfo[i][fundMaxPlayerName], 24, "%s", PlayerInfo[playerid][pName]);
        FundRaisersInfo[i][fundMaxUnix] = unix;

        new string_mysql[260];
        mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `fund_raisers` SET `fundMaxMoney`='%d', `fundMaxPlayerid`='%d',\
            `fundMaxPlayerName`='%e', `fundMaxUnix`='%d' WHERE `fundNewid`='%d'", 
            FundRaisersInfo[i][fundMaxMoney], FundRaisersInfo[i][fundMaxPlayerid], FundRaisersInfo[i][fundMaxPlayerName], 
            FundRaisersInfo[i][fundMaxUnix], FundRaisersInfo[i][fundNewid]);
        query_empty(pearsq, string_mysql);

        format(line,sizeof(line),"\n{ff9000}Ого! Вы сделали максимальное пожертвование!"), strcat(lines,line);
    }

    // Собираем лог пожертвований (информация о подарках)
    if(FundRaisersInfo[i][fundGift])
    {
        new bool:GiftLog[MAX_FUND_GIFT];
        if(rows)
        {
            new priceLog[24], priceSum;
            for(new f; f < rows; ++f)
            {
                cache_get_value_name(f, "quan", priceLog, 24);
                priceSum = strval(priceLog);

                if(priceSum >= FundRaisersInfo[i][fundGiftPrice][0]) GiftLog[0] = true;
                if(priceSum >= FundRaisersInfo[i][fundGiftPrice][1]) GiftLog[1] = true;
                if(priceSum >= FundRaisersInfo[i][fundGiftPrice][2]) GiftLog[2] = true;
            }
        }

        new quanGift, giftFall;
        for(new g = 0; g < MAX_FUND_GIFT; g++) 
        {
            if(FundRaisersInfo[i][fundGiftThingId][g] > 0 && GiftLog[g] == false)
            {
                if(input >= FundRaisersInfo[i][fundGiftPrice][g])
                {
                    quanGift ++;
                    new plit = GiveThingPlayer(playerid, FundRaisersInfo[i][fundGiftThingId][g], FundRaisersInfo[i][fundGiftThingQuan][g], 0, 0, FundRaisersInfo[i][fundGiftThingType][g], 1, 9999);
                    if(plit == -1)
                    {
                        giftFall ++;
                        Throw(playerid, FundRaisersInfo[i][fundGiftThingId][g], FundRaisersInfo[i][fundGiftThingQuan][g], 0, 0, FundRaisersInfo[i][fundGiftThingType][g], 1);
                    }
                }
            }
        }
        if(quanGift > 0)
        {
            if(giftFall > 0) 
            {
                SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ Pears Project ]: {ffcc66}В инвентаре не хватило места [ Подарок упал на землю ]");
                format(line,sizeof(line),"\n\n{F4254F}В инвентаре не хватило места [ Подарок упал на землю ]"), strcat(lines,line);
            }
            else 
            {
                SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ Pears Project ]: {ffcc66}Проверьте инвентарь, вы получили подарок!");
                format(line,sizeof(line),"\n\n{F4254F}Проверьте инвентарь, вы получили подарок!"), strcat(lines,line);
            }
        }
    }

    SuccessMessage(playerid, lines);
    UpdateFundRaisers(i);

    new string_mysql[140];
    mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `fund_raisers` SET `fundMoney`='%d', `fundQuan`='%d' WHERE `fundNewid`='%d'", 
        FundRaisersInfo[i][fundMoney], FundRaisersInfo[i][fundQuan], FundRaisersInfo[i][fundNewid]);
    query_empty(pearsq, string_mysql);

    MoneyLog("fund", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -input, FundRaisersInfo[i][fundName]);
    FundLog(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], input, FundRaisersInfo[i][fundName], FundRaisersInfo[i][fundNewid]);

    return 1;
}

stock AreYouSureFundRaisersActive(playerid, i)
{
    QuanFundRaisers ++;
    FundRaisersInfo[i][fundActive] = true;
    FundRaisersInfo[i][fundUnix] = gettime();
    UpdateFundRaisers(i);
    SettingFundRaisers(playerid, i);
    PlayerPlaySound(playerid,6401,0,0,0);

    new string_mysql[140];
    mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `fund_raisers` SET `fundActive`='%i', `fundUnix`='%d' WHERE `fundNewid`='%d'", 
        FundRaisersInfo[i][fundActive], FundRaisersInfo[i][fundUnix], FundRaisersInfo[i][fundNewid]);
    query_empty(pearsq, string_mysql);

    AdminLog("fund", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, FundRaisersInfo[i][fundName]);
    return 1;
}

stock dialogCase_FundRaisers(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == 1401)
    {
        if(response) 
        {
            if(listitem < 0 || listitem >= MAX_FUND_RAISERS) return 0;
            DP[0][playerid] = listitem;
            SettingFundRaisers(playerid, DP[0][playerid]);
        }
    }

    else if(dialogid == 1402)
    {
        new i = DP[0][playerid];
        if(response)
        {
            if(listitem == 0) DP[2][playerid] = 1, InfoFundRaisers(playerid, i);
            else if(listitem == 1)
            {
                if(FundRaisersInfo[i][fundActive]) 
                {
                    QuanFundRaisers --;
                    FundRaisersInfo[i][fundActive] = false;
                    UpdateFundRaisers(i);

                    new string_mysql[140];
                    mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `fund_raisers` SET `fundActive`='%d' WHERE `fundNewid`='%d'", 
                        FundRaisersInfo[i][fundActive], FundRaisersInfo[i][fundNewid]);
	                query_empty(pearsq, string_mysql);
                }
                else
                {
                    if(FundRaisersInfo[i][fundPos][0] == 0.0 
                        || !strcmp(FundRaisersInfo[i][fundName],"\0",true) || !strcmp(FundRaisersInfo[i][fundText],"\0",true) 
                        || FundRaisersInfo[i][fundRequired] <= 0)
                        return ErrorText(playerid, "{FF6347}Вы не настроили сбор средств полностью\n{cccccc}Название, Описание, Требуется собрать, Позиция"), SettingFundRaisers(playerid, i);
                    
                    ShowDialog(playerid,1413,DIALOG_STYLE_MSGBOX,"{ff9000}Сбор Средств","{cccccc}Вы уверены, что хотите активировать сбор средств?\n\n{FF6347}Elon_Musk: Убедись, что в подарках нет идиотских и косячных предметов\nЕсли там окажется какая-то херня - я выдерну ноги","Да","Нет");
                }
            }
            else if(listitem == 2)
            {
                ShowDialog(playerid,1404,DIALOG_STYLE_INPUT,"{ff9000}Сбор Средств","{cccccc}Введите название сбора\n\n{FF6347}1 - 40 символов","Принять","Отмена");
            }
            else if(listitem == 3)
            {
                ShowDialog(playerid,1405,DIALOG_STYLE_INPUT,"{ff9000}Сбор Средств","{cccccc}Введите описание сбора\n\n{FF6347}1 - 80 символов","Принять","Отмена");
            }
            else if(listitem == 4)
            {
                ShowDialog(playerid,1406,DIALOG_STYLE_INPUT,"{ff9000}Сбор Средств","{cccccc}Введите сумму, которую необходимо собрать\n\n{FF6347}10.000 - 999.000.000","Принять","Отмена");
            }
            else if(listitem == 5)
            {
                if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return ErrorMessage(playerid, "{FF6347}Только пешечком");
                if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0) return ErrorMessage(playerid, "{FF6347}Только на улице");
		        ShowDialog(playerid,1407,DIALOG_STYLE_MSGBOX,"{ff9000}Сбор Средств","{cccccc}Хотите установить позицию, в которой стоите точкой {ff9000}сбора средств?","Да","Нет");
            }
            else if(listitem == 6) SettingFundRaisersGift(playerid, i);
            else if(listitem == 7)
            {
                if(!FundRaisersInfo[i][fundActive]) return ErrorText(playerid, "{FF6347}Нельзя завершить неактивный сбор"), SettingFundRaisers(playerid, DP[0][playerid]);
		        ShowDialog(playerid,1410,DIALOG_STYLE_MSGBOX,"{ff9000}Сбор Средств","{cccccc}Вы уверены, что хотите {FF6347}завершить {cccccc}этот сбор средств?","Да","Нет");
            }
        }
        else FundRaisers(playerid);
    }

    else if(dialogid == 1403) SettingFundRaisers(playerid, DP[0][playerid]);

    else if(dialogid == 1404)
    {
        new i = DP[0][playerid];
        if(response)
        {
            if(strlen(inputtext) < 1 || strlen(inputtext) > 40) return ShowDialog(playerid,1404,DIALOG_STYLE_INPUT,"{ff9000}Сбор Средств","{cccccc}Введите название сбора\n\n{ff0000}1 - 40 символов","Принять","Отмена");
           	if(checksimvol(inputtext)) return ShowDialog(playerid,1404,DIALOG_STYLE_INPUT,"{ff9000}Сбор Средств","{cccccc}Введите название сбора\n\n{FF6347}1 - 40 символов","Принять","Отмена");

            format(FundRaisersInfo[i][fundName], 44, "%s", inputtext);
            UpdateFundRaisers(i);
            SettingFundRaisers(playerid, i);

            new string_mysql[140];
            mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `fund_raisers` SET `fundName`='%e' WHERE `fundNewid`='%d'", 
                FundRaisersInfo[i][fundName], FundRaisersInfo[i][fundNewid]);
	        query_empty(pearsq, string_mysql);
        }
        else SettingFundRaisers(playerid, i);
    }

    else if(dialogid == 1405)
    {
        new i = DP[0][playerid];
        if(response)
        {
            if(strlen(inputtext) < 1 || strlen(inputtext) > 80) return ShowDialog(playerid,1405,DIALOG_STYLE_INPUT,"{ff9000}Сбор Средств","{cccccc}Введите описание сбора\n\n{ff0000}1 - 80 символов","Принять","Отмена");
           	if(checksimvol(inputtext)) return ShowDialog(playerid,1405,DIALOG_STYLE_INPUT,"{ff9000}Сбор Средств","{cccccc}Введите описание сбора\n\n{FF6347}1 - 80 символов","Принять","Отмена");

            format(FundRaisersInfo[i][fundText], 34, "%s", inputtext);
            SettingFundRaisers(playerid, i);

            new string_mysql[140];
            mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `fund_raisers` SET `fundText`='%e' WHERE `fundNewid`='%d'", 
                FundRaisersInfo[i][fundText], FundRaisersInfo[i][fundNewid]);
	        query_empty(pearsq, string_mysql);
        }
        else SettingFundRaisers(playerid, i);
    }

    else if(dialogid == 1406)
    {
        new i = DP[0][playerid];
        if(response)
        {
            if(!checknum(inputtext) || checksimvol(inputtext)) 
                return ShowDialog(playerid,1406,DIALOG_STYLE_INPUT,"{ff9000}Сбор Средств","{cccccc}Введите сумму, которую необходимо собрать\n\n{FF6347}10.000 - 999.000.000","Принять","Отмена");

            new input = strval(inputtext);
            if(input < 10000 || input > 999000000) 
                return ShowDialog(playerid,1406,DIALOG_STYLE_INPUT,"{ff9000}Сбор Средств","{cccccc}Введите сумму, которую необходимо собрать\n\n{FF6347}10.000 - 999.000.000","Принять","Отмена");
           	
            FundRaisersInfo[i][fundRequired] = input;
            UpdateFundRaisers(i);
            SettingFundRaisers(playerid, i);

            new string_mysql[140];
            mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `fund_raisers` SET `fundRequired`='%d' WHERE `fundNewid`='%d'",
                FundRaisersInfo[i][fundRequired], FundRaisersInfo[i][fundNewid]);
	        query_empty(pearsq, string_mysql);
        }
        else SettingFundRaisers(playerid, i);
    }

    else if(dialogid == 1407)
    {
        new i = DP[0][playerid];
        if(response)
        {
            if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return ErrorMessage(playerid, "{FF6347}Только пешечком");
            if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0) return ErrorMessage(playerid, "{FF6347}Только на улице");

            GetPlayerPos(playerid, FundRaisersInfo[i][fundPos][0], FundRaisersInfo[i][fundPos][1], FundRaisersInfo[i][fundPos][2]);
            UpdateFundRaisers(i);
            SettingFundRaisers(playerid, i);
            PlayerPlaySound(playerid,6400,0,0,0);

            new string_mysql[160];
            mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `fund_raisers` SET `fundPos0`='%f', `fundPos1`='%f', `fundPos2`='%f' WHERE `fundNewid`='%d'", 
                FundRaisersInfo[i][fundPos][0], FundRaisersInfo[i][fundPos][1], FundRaisersInfo[i][fundPos][2], FundRaisersInfo[i][fundNewid]);
	        query_empty(pearsq, string_mysql);
        }
        else SettingFundRaisers(playerid, i);
    }

    else if(dialogid == 1408)
    {
        new i = DP[0][playerid];
        if(response)
        {
            if(listitem == 0) DP[2][playerid] = 0, InfoFundRaisers(playerid, i);
            if(listitem == 1)
            {
                new line[90],lines[270];
                format(line,sizeof(line),"{cccccc}Введите сумму, которую хотите пожертвовать на {ff9000}%s", FundRaisersInfo[i][fundName]), strcat(lines,line);
                format(line,sizeof(line),"\n\n{FF6347}100$ - 99.000.000$"), strcat(lines,line);
                if(FundRaisersInfo[i][fundGift]) format(line,sizeof(line),"\n{99ff66}Посмотрите в информации о требованиях для получения подарка"), strcat(lines,line);
                ShowDialog(playerid,1409,DIALOG_STYLE_INPUT,"{ff9000}Сбор Средств",lines,"Принять","Отмена");
            }
        }
    }

    else if(dialogid == 1409)
    {
        new i = DP[0][playerid];
        if(response)
        {
            if(!checknum(inputtext) || checksimvol(inputtext)) 
                return ErrorMessage(playerid, "{FF6347}Используйте только цифры");

            new input = strval(inputtext);
            if(input < 100 || input > 99000000) 
                return ErrorMessage(playerid, "{FF6347}Не меньше 100$ и не больше 99.000.000$");

            if(oGetPlayerMoney(playerid) < input) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");

            new unix = gettime();
           	if(aFloodFund[playerid] > unix) return ErrorMessage(playerid, "{FF6347}Пожалуйста, для повторного пожертвования, подождите 20 секунд");
            aFloodFund[playerid] = unix + 20;

            new string_mysql[180];
            mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT * FROM `fund_logs` WHERE `fundid` = '%d' AND `senderid` = '%d' LIMIT 500", 
                FundRaisersInfo[i][fundNewid], PlayerInfo[playerid][pID]);
		    mysql_tquery(pearsq, string_mysql, "Call_pay_fundraisers", "dddd", playerid, i, input, g_MysqlRaceCheck[playerid]);
        }
        else MenuFundRaisers(playerid, i);
    }

    else if(dialogid == 1410)
    {
        new i = DP[0][playerid];
        if(response)
        {
            if(!FundRaisersInfo[i][fundActive]) return ErrorMessage(playerid, "{FF6347}Сбор уже завершён");

            FundRaisersInfo[i][fundActive] = false;
            QuanFundRaisers --;
            UpdateFundRaisers(i);

            new string[140];
            format(string,sizeof(string),"{99ff66}Вы завершили сбор средств {ff9000}%s\n\n{cccccc}Собрано: {99ff66}%d$ {cccccc}из %d$", FundRaisersInfo[i][fundName],  FundRaisersInfo[i][fundMoney], FundRaisersInfo[i][fundRequired]);
            SuccessMessage(playerid, string);

            ClearFundLog(FundRaisersInfo[i][fundNewid]); // Очищаем лог пожертвований по этому сбору (В moneylog история остаётся)

            format(FundRaisersInfo[i][fundName], 44, "");
            format(FundRaisersInfo[i][fundText], 84, "");
            FundRaisersInfo[i][fundMoney] = 0;
            FundRaisersInfo[i][fundRequired] = 0;
            FundRaisersInfo[i][fundMaxMoney] = 0;
            FundRaisersInfo[i][fundMaxPlayerid] = 0;
            format(FundRaisersInfo[i][fundMaxPlayerName], 24, "");
            FundRaisersInfo[i][fundMaxUnix] = 0;
            FundRaisersInfo[i][fundQuan] = 0;

            FundRaisersInfo[i][fundGift] = false;
            for(new g = 0; g < MAX_FUND_GIFT; g++) FundRaisersInfo[i][fundGiftThingId][g] = 0;

            new string_mysql[500];
            mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `fund_raisers` SET `fundActive`='%i', `fundName`='%e', `fundText`='%e', `fundMoney`='%d', \ 
                `fundMaxMoney`='%d', `fundMaxPlayerid`='0', \
                `fundQuan`='0', `fundRequired`='%d', `fundGift`='%d', `fundGiftThingId0`='0', `fundGiftThingId1`='0', `fundGiftThingId2`='0' WHERE `fundNewid`='%d'", 
                FundRaisersInfo[i][fundActive], FundRaisersInfo[i][fundName], FundRaisersInfo[i][fundText], 
                FundRaisersInfo[i][fundMoney], FundRaisersInfo[i][fundMaxMoney], FundRaisersInfo[i][fundRequired], FundRaisersInfo[i][fundGift], 
                FundRaisersInfo[i][fundNewid]); // 263 + 33 + 44 + 84 + 24 + 24
            query_empty(pearsq, string_mysql); // 445

            AdminLog("closefund", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, FundRaisersInfo[i][fundName]);
        }
        else SettingFundRaisers(playerid, i);
    }

    else if(dialogid == 1411)
    {
        new i = DP[0][playerid];
        if(response)
        {
            if(listitem < 0 || listitem >= MAX_FUND_GIFT) return 0;
            DP[1][playerid] = listitem;
            ShowDialog(playerid,1412,DIALOG_STYLE_INPUT,"{ff9000}Сбор Средств","{cccccc}Введите через пробел настройки подарка {FF6347}[Внимание! -1 удалить подарок]\n{ff9000}Тип ID Количество Сумма {cccccc}(От которой этот подарок будет доступен)\n\n{555555}Подробности о предметах и их ID вы можете найти на форуме","Принять","Отмена");
        }
        else SettingFundRaisers(playerid, i);
    }

    else if(dialogid == 1412)
    {
        new i = DP[0][playerid];
        new g = DP[1][playerid];
        if(response)
        {
            if(!checknumSpace(inputtext)) return ErrorMessage(playerid, "{FF6347}Используйте только цифры");

            new input[4];
            if(sscanf(inputtext, "iiii", input[0], input[1], input[2], input[3]))
            {
                ShowDialog(playerid,1412,DIALOG_STYLE_INPUT,"{ff9000}Сбор Средств","{cccccc}Введите через пробел настройки подарка {FF6347}[Внимание! -1 удалить подарок]\n{ff0000}Тип ID Количество Сумма {cccccc}(От которой этот подарок будет доступен)\n\n{555555}Подробности о предметах и их ID вы можете найти на форуме","Принять","Отмена");
                return 1;
            }

            new string[120];
            if(input[0] == 0) // Обычный Предмет 
            {
                if(input[1] <= 0 || input[1] >= sizeof(friskName)) return format(string,sizeof(string),"{FF6347}ID Предмета не меньше 1 и не больше %d", sizeof(friskName)), ErrorMessage(playerid, string);
                if(input[2] < 0 || input[2] > 100) return ErrorMessage(playerid, "{FF6347}Количество для предмета не меньше 1 не больше 100");
                if(NotGiveThing(input[1], 0, 0)) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя добавить");
            }
            else if(input[0] == 2) // Аксессуар
            {
                if(input[1] <= 320 || input[1] > MAX_OBJECT_MODEL_ID) return format(string,sizeof(string),"{FF6347}ID Аксессуара не меньше 321 и не больше %d", MAX_OBJECT_MODEL_ID), ErrorMessage(playerid, string);
                if(!GetAccessory(input[1])) return ErrorMessage(playerid, "{FF6347}Вы можете добавить аксессуар только из одобренного списка аксессуаров [ /accessory ]");
                if(input[2] < 0 || input[2] > 1) return ErrorMessage(playerid, "{FF6347}Аксессуар в подарке может быть только один");
            }
            else if(input[0] == 3) // Одежда
            {
                if(!IsASkinExisting(input[1])) return ErrorMessage(playerid, "{FF6347}Несуществующий ID скина [1 - 311, далее кастомные ID есть на форуме]");
                if(input[2] < 0 || input[2] > 1) return ErrorMessage(playerid, "{FF6347}Одежда в подарке может быть только одна");
            }
            else if(input[0] == 5) // Транспорт
            {
                if(input[1] < 400 || input[1] > 611) return ErrorMessage(playerid, "{FF6347}Модель транспорта не меньше 400 и не больше 611");
                if(input[2] < 0 || input[2] > 1) return ErrorMessage(playerid, "{FF6347}Транспорт в подарке может быть только один");
            }
            else if(input[0] == -1) // Удаляем подарок
            {
                FundRaisersInfo[i][fundGiftThingId][g] = 0;
                FundRaisersInfo[i][fundGiftThingQuan][g] = 0;
                FundRaisersInfo[i][fundGiftThingType][g] = 0;
                FundRaisersInfo[i][fundGiftPrice][g] = 0;

                new quan;
                for(new gf = 0; gf < MAX_FUND_GIFT; gf++) 
                {
                    if(FundRaisersInfo[i][fundGiftThingId][gf]) quan ++;
                }
                if(quan == 0) FundRaisersInfo[i][fundGift] = false;
            }
            else ErrorMessage(playerid, "{FF6347}Недоступный тип (-1 удалить подарок, 0 предмет, 2 аксессуар, 3 одежда, 5 транспорт)");

            if(input[0] >= 1 && input[3] < 10000 || input[3] > 99000000) return ErrorMessage(playerid, "{FF6347}Сумма пожертвования, от которого доступен подарок, не меньше 10.000$ и не больше 99.000.000$");

            if(input[0] >= 0)
            {
                FundRaisersInfo[i][fundGift] = true;
                FundRaisersInfo[i][fundGiftThingId][g] = input[1];
                FundRaisersInfo[i][fundGiftThingQuan][g] = input[2];
                FundRaisersInfo[i][fundGiftThingType][g] = input[0];
                FundRaisersInfo[i][fundGiftPrice][g] = input[3];
            }

            UpdateFundRaisers(i);
            SettingFundRaisersGift(playerid, i);
            PlayerPlaySound(playerid,6401,0,0,0);

            format(string,sizeof(string),"%s (%s)", FundRaisersInfo[i][fundName], GetNameThing(0, FundRaisersInfo[i][fundGiftThingId][g], FundRaisersInfo[i][fundGiftThingType][g], 0));
            AdminLog("fundgift", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i, string);

            new string_mysql[185 + 110];
            mysql_format(pearsq, string_mysql, sizeof(string_mysql),"UPDATE `fund_raisers` SET `fundGift`='%i', `fundGiftThingId%d`='%d', `fundGiftThingQuan%d`='%d',\
            `fundGiftThingType%d`='%d', `fundGiftPrice%d`='%d' WHERE `fundNewid`='%d'", 
                FundRaisersInfo[i][fundGift], g, FundRaisersInfo[i][fundGiftThingId][g], g, FundRaisersInfo[i][fundGiftThingQuan][g], 
                g, FundRaisersInfo[i][fundGiftThingType][g], g, FundRaisersInfo[i][fundGiftPrice][g],
                FundRaisersInfo[i][fundNewid]);
            query_empty(pearsq, string_mysql);
        }
        else SettingFundRaisersGift(playerid, i);
    }

    else if(dialogid == 1413)
    {
        new i = DP[0][playerid];
        if(response) AreYouSureFundRaisersActive(playerid, i);
        else SettingFundRaisers(playerid, i);
    }

    else if(dialogid == 1414) MenuFundRaisers(playerid, DP[0][playerid]);
    return 1;
}

stock FundLog(senderid, const sender[], const senderip[], quan, const name[], fundid)
{
    new string_mysql[300];
    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "INSERT INTO `fund_logs`\
	(`senderid`,`sender`,`senderip`,`quan`,`name`,`fundid`,`unix`) VALUES ('%d','%e','%e','%d','%e','%d','%d')",
    senderid, sender, senderip, quan, name, fundid, gettime());
	mysql_tquery(pearsq, string_mysql);
}

stock ClearFundLog(fundid)
{
    new string_mysql[90];
    mysql_format(pearsq, string_mysql, sizeof(string_mysql), "DELETE FROM `fund_logs` WHERE `fundid` = '%d'", fundid);
	query_empty(pearsq, string_mysql);
    return 1;
}

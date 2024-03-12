
#define MAX_AQUARIUM 1
#define MAX_FISH_IN_AQUARIUM 3

enum aquaINFO
{ 
    aqNewid,
    aqFishStat[MAX_FISH_IN_AQUARIUM], // Статус рыбки (0 нету, 1 всё ок, 2 сдохла)
    aqFishObject[MAX_FISH_IN_AQUARIUM], // Объекты рыбки
    aqFishSatiety[MAX_FISH_IN_AQUARIUM], // Сытость рыбки
    aqFishSide[MAX_FISH_IN_AQUARIUM], // Куда плывет рыба (0 в лево, 1 в право)
    aqTextObject[MAX_FISH_IN_AQUARIUM], // Объект имени и статуса рыбки
    Float:aqFishZ[MAX_FISH_IN_AQUARIUM], // По какой высоте плавает рыбка

    Float:aqTop, // Верхняя часть аквариума
    Float:aqBottom, // Нижняя часть аквариума
    Float:aqLeft, // Левая часть аквариума
    Float:aqRight, // Правая часть аквариума
    Float:aqDistX, // Расстояние от аквариума слева направо
    Float:aqDistY, // Расстояние от аквариума снизу вверх

    aqFeedFish, // Кормление рыбок
    aqFullSatiety[MAX_FISH_IN_AQUARIUM], // Рыбка похавала
    aqCdFeed // Кд на кормление рыбок
};
new AquariumInfo[MAX_AQUARIUM][aquaINFO];
new FishName[MAX_AQUARIUM][MAX_FISH_IN_AQUARIUM][11]; // Имя рыбки

stock CreateFish(aquaid, fishid)
{
    new w_gov1 = 189, i_gov1 = 0;
    new model;
    if(fishid == 0) model = 1599;
    else if(fishid == 1) model = 1600;
    else if(fishid == 2) model = 1604;
    AquariumInfo[aquaid][aqFishObject][fishid] = CreateDynamicObject(model, -2785.761718, 382.885467, 7.964013, 0.000000, 0.000000, 270.000000, w_gov1, i_gov1, -1, 300.00, 300.00); // fish0 (maxZ and Left)
    return 1;
}

stock PutFishInAquarium(aquaid, fishid)
{
    if(AquariumInfo[aquaid][aqFishStat][fishid] == 1) // Рыбка живая и плавает
    {
        switch(random(2))
        {
            case 0:
            {
                AquariumInfo[aquaid][aqFishSide][fishid] = 0;
                SetDynamicObjectRot(AquariumInfo[aquaid][aqFishObject][fishid], 0.0000, 0.0000, 90.000000); // Смотрит влево
            }
            case 1:
            {
                AquariumInfo[aquaid][aqFishSide][fishid] = 1;
                SetDynamicObjectRot(AquariumInfo[aquaid][aqFishObject][fishid], 0.0000, 0.0000, 270.000000); // Смотрит вправо
            }
        }
        new Float:rand_y; // 1.530006
        switch(random(7))
        {
            case 0: rand_y = 0.2;
            case 1: rand_y = 0.4;
            case 2: rand_y = 0.6;
            case 3: rand_y = 0.8;
            case 4: rand_y = 1.0;
            case 5: rand_y = 1.2;
            case 6: rand_y = 1.4;
        }
        AquariumInfo[aquaid][aqFishZ][fishid] = AquariumInfo[aquaid][aqBottom] + rand_y;
        SetDynamicObjectPos(AquariumInfo[aquaid][aqFishObject][fishid], AquariumInfo[aquaid][aqLeft] + random(6), 382.885467, AquariumInfo[aquaid][aqFishZ][fishid]);
    }
    else if(AquariumInfo[aquaid][aqFishStat][fishid] == 2) // Рыбка дохлая
    {
        switch(random(2))
        {
            case 0:
            {
                AquariumInfo[aquaid][aqFishSide][fishid] = 0;
                SetDynamicObjectRot(AquariumInfo[aquaid][aqFishObject][fishid], 0.0000, 180.0000, 90.000000); // Смотрит влево
            }
            case 1:
            {
                AquariumInfo[aquaid][aqFishSide][fishid] = 1;
                SetDynamicObjectRot(AquariumInfo[aquaid][aqFishObject][fishid], 0.0000, 180.0000, 270.000000); // Смотрит вправо
            }
        }
        SetDynamicObjectPos(AquariumInfo[aquaid][aqFishObject][fishid], AquariumInfo[aquaid][aqLeft] + random(6), 382.885467, AquariumInfo[aquaid][aqTop]);
    }
    return 1;
}

stock UpdateTextFish(aquaid, fishid)
{
    new string[60];
    if(AquariumInfo[aquaid][aqFishStat][fishid] == 2) format(string, sizeof(string), "%s\n{FF6347}Рыбка умерла", FishName[aquaid][fishid]);
    else
    {
        if(AquariumInfo[aquaid][aqFishSatiety][fishid] <= 10) format(string, sizeof(string), "%s\n{FF6347}Eat: %d / 100", FishName[aquaid][fishid], AquariumInfo[aquaid][aqFishSatiety][fishid]);
        else format(string, sizeof(string), "%s\nEat: %d / 100", FishName[aquaid][fishid], AquariumInfo[aquaid][aqFishSatiety][fishid]);
    }

    if(fishid == 1) SetDynamicObjectMaterialText(AquariumInfo[aquaid][aqTextObject][fishid], 0, string, 140, "Arial", 65, 1, 0xFF999999, 0x00000000, 2);
    else SetDynamicObjectMaterialText(AquariumInfo[aquaid][aqTextObject][fishid], 0, string, 140, "Arial", 65, 1, 0xFF999999, 0x00000000, 0);
    return 1;
}

stock MoveFish(aquaid, fishid)
{
    new ms_fihish;
    StopDynamicObject(AquariumInfo[aquaid][aqFishObject][fishid]);

    new Float:rand_x;
    if(AquariumInfo[aquaid][aqFishSide][fishid] == 0)
    {
        AquariumInfo[aquaid][aqFishSide][fishid] = 1;
        switch(random(4))
        {
            case 0: rand_x = AquariumInfo[aquaid][aqRight] - 0.5;
            case 1: rand_x = AquariumInfo[aquaid][aqRight] - 1.0;
            case 2: rand_x = AquariumInfo[aquaid][aqRight] - 1.5;
            case 3: rand_x = AquariumInfo[aquaid][aqRight] - 2.0;
        }
        SetDynamicObjectRot(AquariumInfo[aquaid][aqFishObject][fishid], 0.0000, 0.0000, 270.000000); // Смотрит вправо
        ms_fihish = MoveDynamicObject(AquariumInfo[aquaid][aqFishObject][fishid], rand_x, 382.885467, AquariumInfo[aquaid][aqFishZ][fishid], 0.6); // Плывёт вправо
    }
    else if(AquariumInfo[aquaid][aqFishSide][fishid] == 1)
    {
        AquariumInfo[aquaid][aqFishSide][fishid] = 0;
        switch(random(4))
        {
            case 0: rand_x = AquariumInfo[aquaid][aqLeft] + 0.5;
            case 1: rand_x = AquariumInfo[aquaid][aqLeft] + 1.0;
            case 2: rand_x = AquariumInfo[aquaid][aqLeft] + 1.5;
            case 3: rand_x = AquariumInfo[aquaid][aqLeft] + 2.0;
        }
        SetDynamicObjectRot(AquariumInfo[aquaid][aqFishObject][fishid], 0.0000, 0.0000, 90.000000); // Смотрит влево
        ms_fihish = MoveDynamicObject(AquariumInfo[aquaid][aqFishObject][fishid], rand_x, 382.885467, AquariumInfo[aquaid][aqFishZ][fishid], 0.6); // Плывёт влево
    }
    if(ms_fihish - 1000 > 0) ms_fihish -= 1000;
    SetTimerEx("FinishSwimFish", ms_fihish, 0, "dd", aquaid, fishid);
    return 1;
}

function FinishSwimFish(aquaid, fishid)
{
    if(AquariumInfo[aquaid][aqFishStat][fishid] == 2)
    {
        StopDynamicObject(AquariumInfo[aquaid][aqFishObject][fishid]);
        
        if(AquariumInfo[aquaid][aqFishSide][fishid] == 1) SetDynamicObjectRot(AquariumInfo[aquaid][aqFishObject][fishid], 0.0000, 180.0000, 270.000000);
        else if(AquariumInfo[aquaid][aqFishSide][fishid] == 0) SetDynamicObjectRot(AquariumInfo[aquaid][aqFishObject][fishid], 0.0000, 180.0000, 90.000000);

        new Float:object_pos[3];
	    GetDynamicObjectPos(AquariumInfo[aquaid][aqFishObject][fishid], object_pos[0], object_pos[1], object_pos[2]);
        SetDynamicObjectRot(AquariumInfo[aquaid][aqFishObject][fishid], 0.0000, 180.0000, 270.000000);
        MoveDynamicObject(AquariumInfo[aquaid][aqFishObject][fishid], object_pos[0], object_pos[1], AquariumInfo[aquaid][aqTop] + 0.1, 0.6);
    }
    else if(AquariumInfo[aquaid][aqFishStat][fishid] == 1) MoveFish(aquaid, fishid);
    return 1;
}

stock AquariumMenu(playerid, aquaid)
{
    if(aquaid >= MAX_AQUARIUM) return 1;
    new line[70],lines[490];
    
    DP[0][playerid] = aquaid;
    format(line,sizeof(line),"{cccccc}Имя\t{cccccc}Статус"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Покормить Рыбок: {99ff66}%d$", getThingPriceGos(195, 0)), strcat(lines,line);
    for(new i = 0; i < MAX_FISH_IN_AQUARIUM; i++)
    {
        if(AquariumInfo[aquaid][aqFishStat][i] == 0)
        {
            format(line,sizeof(line),"\n{555555}Нет рыбки \t {cccccc}Купить {99ff66}>>"), strcat(lines,line);
        }
        else if(AquariumInfo[aquaid][aqFishStat][i] == 1)
        {
            if(AquariumInfo[aquaid][aqFishSatiety][i] <= 10) format(line,sizeof(line),"\n{ff9000}%s \t {FF6347}%d / 100", FishName[aquaid][i], AquariumInfo[aquaid][aqFishSatiety][i]);
            else format(line,sizeof(line),"\n{ff9000}%s \t {B1FA61}%d / 100", FishName[aquaid][i], AquariumInfo[aquaid][aqFishSatiety][i]);
            strcat(lines,line);
        }
        else if(AquariumInfo[aquaid][aqFishStat][i] == 2)
        {
            format(line,sizeof(line),"\n{FF6347}%s \t {FF6347}Рыбка умерла", FishName[aquaid][i]), strcat(lines,line);
        }
    }
    ShowDialog(playerid,499,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Аквариум",lines,"Выбор","Отмена");
    PlayerPlaySound(playerid,40405,0,0,0);
    return 1;
}

stock AquariumFish(playerid, aquaid, fishid)
{
    if(AquariumInfo[aquaid][aqFishStat][fishid] == 0 || AquariumInfo[aquaid][aqFishStat][fishid] == 2)
    {
        DP[2][playerid] = getThingPriceGos(194, 0);
        new string[100];
        if(AquariumInfo[aquaid][aqFishStat][fishid] == 0) format(string, sizeof(string),"{cccccc}Введите имя рыбки [ 2 - 10 Символов ]\n\nСтоимость: {99ff66}%d$", DP[2][playerid]);
        else if(AquariumInfo[aquaid][aqFishStat][fishid] == 2) format(string, sizeof(string),"{cccccc}Введите имя новой рыбки [ 2 - 10 Символов ]\n\nСтоимость: {99ff66}%d$", DP[2][playerid]);
		ShowDialog(playerid,498,DIALOG_STYLE_INPUT,"{ff9000}Аквариум",string,"Принять","Отмена");
    }
    else
    {
        new line[70],lines[140];
        format(line,sizeof(line),"{ff9000}%s {cccccc}| Eat: %d / 100", FishName[aquaid][fishid], AquariumInfo[aquaid][aqFishSatiety][fishid]), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}Переименовать Рыбку >>"), strcat(lines,line);
        ShowDialog(playerid,497,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Аквариум",lines,"Выбор","Отмена");
    }
    return 1;
}

stock FeedTheFish(aquaid)
{
    if(AquariumInfo[aquaid][aqFeedFish] > 0)
    {
        new feed_quan, feed_end;
        for(new i; i < MAX_FISH_IN_AQUARIUM; ++i)
        {
            if(AquariumInfo[aquaid][aqFishStat][i] == 1)
            {
                feed_quan = 2 + random(8);
                if(AquariumInfo[aquaid][aqFishSatiety][i] + feed_quan >= 100) 
                {
                    AquariumInfo[aquaid][aqFishSatiety][i] = 100;
                    if(AquariumInfo[aquaid][aqFullSatiety][i] == 0) AquariumInfo[aquaid][aqFullSatiety][i] = 1, feed_end ++;
                }
                else AquariumInfo[aquaid][aqFishSatiety][i] += feed_quan;
                UpdateTextFish(aquaid, i);
            }
            else
            {
                if(AquariumInfo[aquaid][aqFullSatiety][i] == 0) AquariumInfo[aquaid][aqFullSatiety][i] = 1, feed_end ++;
            }
        }

        AquariumInfo[aquaid][aqFeedFish] -= feed_end; // Завершение кормёжки у рыбок
    }
    return 1;
}

stock dialogCase_Aquarium(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == 499) // Главное меню
    {
        if(response)
        {
            if(listitem == 0)
            {
                new aquaid = DP[0][playerid];
                if(AquariumInfo[aquaid][aqFeedFish] > 0) return ErrorMessage(playerid, "{FF6347}Рыбки уже кушают");
                if(AquariumInfo[aquaid][aqCdFeed] > gettime())
                {
                    new string[120];
                    format(string, sizeof(string), "{FF6347}Рыбок кормили совсем недавно\n{cccccc}Покормить повторно можно будет через %s", fine_time(AquariumInfo[aquaid][aqCdFeed] - gettime()));
                    ErrorMessage(playerid, string);
                    return 1;
                }

                new price = getThingPriceGos(195, 0);
                if(oGetPlayerMoney(playerid) < price) return ErrorMessage(playerid, "{FF6347}У вас не хватает денег");

                new full_feed, null_fish;
                for(new i; i < MAX_FISH_IN_AQUARIUM; ++i)
                {
                    if(AquariumInfo[aquaid][aqFishStat][i] == 1)
                    {
                        if(AquariumInfo[aquaid][aqFishSatiety][i] >= 100) full_feed ++;
                    }
                    else full_feed ++, null_fish ++;
                }
                if(null_fish >= MAX_FISH_IN_AQUARIUM) return ErrorMessage(playerid, "{FF6347}В аквариуме нет живых рыбок");
                if(full_feed >= MAX_FISH_IN_AQUARIUM) return ErrorMessage(playerid, "{FF6347}Все рыбки сыты");

                SuccessMessage(playerid, "{99ff66}Вы покормили рыбок\n{cccccc}Теперь рыбки будут счастливы :)");
                oGivePlayerMoney(playerid, -price);
                putkazna(2, price);
                payanim(playerid, 0);

                for(new i; i < MAX_FISH_IN_AQUARIUM; ++i) AquariumInfo[aquaid][aqFullSatiety][i] = 0; 
                AquariumInfo[aquaid][aqFeedFish] = MAX_FISH_IN_AQUARIUM; // Процесс кормёжки
                AquariumInfo[aquaid][aqCdFeed] = gettime() + 600; // Кд на кормление (10 минут)
            }
            else if(listitem >= 1 && listitem <= MAX_FISH_IN_AQUARIUM + 1)
            {
                DP[1][playerid] = listitem - 1;
                AquariumFish(playerid, DP[0][playerid], DP[1][playerid]);
            }
        }
    }
    else if(dialogid == 498) // Покупка новой рыбки
    {
        if(response)
        {
            if(!strlen(inputtext)) return AquariumMenu(playerid, DP[0][playerid]);
            if(strlen(inputtext) < 2 || strlen(inputtext) > 10) return ErrorMessage(playerid, "{FF6347}Не меньше 1 и не больше 10 символов");
           	if(checksimvol(inputtext)) return ErrorMessage(playerid, "{FF6347}Запрещённый символ в тексте");

            new price = DP[2][playerid];
            if(oGetPlayerMoney(playerid) < price) return ErrorMessage(playerid, "{FF6347}У вас не хватает денег");
            
            new string[100];
            format(string,sizeof(string),"{99ff66}Вы приобрели: %s\n{cccccc}Стоимость: {99ff66}%d$", GetNameThing(0, 194, 0, 0), price);
            SuccessMessage(playerid, string);
            oGivePlayerMoney(playerid, -price);
            putkazna(2, price);
            payanim(playerid, 0);

            new aquaid = DP[0][playerid], fishid = DP[1][playerid];
            if(AquariumInfo[aquaid][aqFishStat][fishid] == 0) CreateFish(aquaid, fishid);
            AquariumInfo[aquaid][aqFishStat][fishid] = 1;
            AquariumInfo[aquaid][aqFishSatiety][fishid] = 100;
            PutFishInAquarium(aquaid, fishid);
            MoveFish(aquaid, fishid);
            format(FishName[aquaid][fishid], 11, "%s", inputtext);
            UpdateTextFish(aquaid, fishid);
            SaveAquarium(aquaid, fishid);

            Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
        }
        else AquariumMenu(playerid, DP[0][playerid]);
    }
    else if(dialogid == 497) // Меню рыбки
    {
        if(response)
        {
            if(listitem == 0) // Переименовать
            {
                if(DP[0][playerid] == 0 && PlayerInfo[playerid][pLeader] != 7 
                    && PlayerInfo[playerid][pSoska] == 0) return ErrorMessage(playerid, "{FF6347}Только лидер правительства или администратор может переименовать рыбку");

		        ShowDialog(playerid,496,DIALOG_STYLE_INPUT,"{ff9000}Аквариум","{cccccc}Введите новое имя рыбки [ 2 - 10 Символов ]","Принять","Отмена");
            }
        }
        else AquariumMenu(playerid, DP[0][playerid]);
    }
    else if(dialogid == 496) // Переименовывание рыбки
    {
        if(response)
        {
            if(!strlen(inputtext)) return AquariumMenu(playerid, DP[0][playerid]);
            if(strlen(inputtext) < 2 || strlen(inputtext) > 10) return ErrorMessage(playerid, "{FF6347}Не меньше 1 и не больше 10 символов");
           	if(checksimvol(inputtext)) return ErrorMessage(playerid, "{FF6347}Запрещённый символ в тексте");
            
            new aquaid = DP[0][playerid], fishid = DP[1][playerid];
            if(AquariumInfo[aquaid][aqFishStat][fishid] != 1) return ErrorMessage(playerid, "{FF6347}Рыбка умерла или её нет в аквариуме [ Купите новую ]");

            new string[100];
            format(string,sizeof(string),"{99ff66}Рыбка %s теперь имеет новое имя: {ff9000}%s", FishName[aquaid][fishid], inputtext);
            SuccessMessage(playerid, string);

            format(FishName[aquaid][fishid], 11, "%s", inputtext);
            UpdateTextFish(aquaid, fishid);
            SaveAquarium(aquaid, fishid);
        }
        else AquariumMenu(playerid, DP[0][playerid]);
    }
    return 1;
}

function LoadAquarium()
{
    new w_gov1 = 189, i_gov1 = 0;
    AquariumInfo[0][aqTextObject][0] = CreateDynamicObject(19475, -2787.407714, 382.085937, 6.803994, -0.000018, 0.000007, -89.999855, w_gov1, i_gov1, -1, 300.00, 300.00); // text_fish0 (maxsize_name 10)
	AquariumInfo[0][aqTextObject][1] = CreateDynamicObject(19475, -2787.778076, 382.085937, 6.553992, -0.000018, 0.000007, -89.999855, w_gov1, i_gov1, -1, 300.00, 300.00); // text_fish1 (maxsize_name 10)
	AquariumInfo[0][aqTextObject][2] = CreateDynamicObject(19475, -2787.417724, 382.085937, 6.253999, -0.000018, 0.000007, -89.999855, w_gov1, i_gov1, -1, 300.00, 300.00); // text_fish2 (maxsize_name 10)

	new time = GetTickCount();
	for(new f; f < MAX_AQUARIUM; ++f)
	{
        InitializeAquarium(f);

    	cache_get_value_name_int(f, "newid", AquariumInfo[f][aqNewid]);
    	cache_get_value_name_int(f, "aqFishStat0", AquariumInfo[f][aqFishStat][0]);
        cache_get_value_name_int(f, "aqFishStat1", AquariumInfo[f][aqFishStat][1]);
        cache_get_value_name_int(f, "aqFishStat2", AquariumInfo[f][aqFishStat][2]);
        cache_get_value_name_int(f, "aqFishSatiety0", AquariumInfo[f][aqFishSatiety][0]);
        cache_get_value_name_int(f, "aqFishSatiety1", AquariumInfo[f][aqFishSatiety][1]);
        cache_get_value_name_int(f, "aqFishSatiety2", AquariumInfo[f][aqFishSatiety][2]);
        cache_get_value_name(f, "FishName0", FishName[f][0], 11);
        cache_get_value_name(f, "FishName1", FishName[f][1], 11);
        cache_get_value_name(f, "FishName2", FishName[f][2], 11);

        for(new i; i < MAX_FISH_IN_AQUARIUM; ++i)
        {
            if(AquariumInfo[f][aqFishStat][i] > 0)
            {
                CreateFish(f, i);
                PutFishInAquarium(f, i);
                UpdateTextFish(f, i);
                if(AquariumInfo[f][aqFishStat][i] == 1) MoveFish(f, i);
            }
        }
	}
	printf("[MODE]: Аквариумы [%d ms]", GetTickCount() - time);
	return 1;
}

CMD:fishsatiety(playerid, const params[])
{
    if(server != 0) return 0;

    if(AquariumInfo[0][aqFeedFish] > 0) return ErrorMessage(playerid, "{FF6347}Дождитесь пока рыбки в аквариуме покушают");
    if(!sscanf(params, "ii",params[0],params[1]))
    {
        if(params[0] < 0 || params[0] >= MAX_FISH_IN_AQUARIUM) return ErrorMessage(playerid, "{FF6347}Неверный id рыбки");
        if(params[1] < 0 || params[1] > 100) return ErrorMessage(playerid, "{FF6347}Сытость не меньше 0 и не больше 100");
        new i = params[0];
        if(AquariumInfo[0][aqFishStat][i] == 0) return ErrorMessage(playerid, "{FF6347}Этой рыбки не существует");
        if(AquariumInfo[0][aqFishStat][i] == 2) return ErrorMessage(playerid, "{FF6347}Этой рыбка мертва");
        AquariumInfo[0][aqCdFeed] = 0;
        AquariumInfo[0][aqFishSatiety][i] = params[1];

        if(AquariumInfo[0][aqFishSatiety][i] <= 0)
        {
            StopDynamicObject(AquariumInfo[0][aqFishObject][i]);
            AquariumInfo[0][aqFishStat][i] = 2;
            MoveFish(0, i);
        }
        UpdateTextFish(0, i);
    }
    else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить сытость рыбки [ /fishsatiety ID Сытость ]");
    return 1;
}

stock InitializeAquarium(aquaid)
{
    AquariumInfo[aquaid][aqTop] = 7.964013;
    AquariumInfo[aquaid][aqBottom] = 6.434007;
    AquariumInfo[aquaid][aqLeft] = -2785.761718;
    AquariumInfo[aquaid][aqRight] = -2778.857421;
    AquariumInfo[aquaid][aqDistX] = 6.907508;
    AquariumInfo[aquaid][aqDistY] = 1.530006;
    return 1;
}

stock SaveAquarium(aquaid, fishid)
{
    new f_str[11];
	mysql_escape_string(FishName[aquaid][fishid], f_str, sizeof(f_str));

    new string_mysql[102 + 66 + 11];
    format(string_mysql, sizeof(string_mysql), "UPDATE `aquarium` SET `aqFishStat%d`='%d',`aqFishSatiety%d`='%d',`FishName%d`='%s' WHERE `newid`='%d'",
        fishid, AquariumInfo[aquaid][aqFishStat][fishid], fishid, AquariumInfo[aquaid][aqFishSatiety][fishid], fishid, f_str, AquariumInfo[aquaid][aqNewid]);
    query_empty(pearsq, string_mysql);
	return 1;
}

stock AquariumFishSatiety(aquaid)
{
    new fishid = random(MAX_FISH_IN_AQUARIUM);

    if(AquariumInfo[aquaid][aqFishStat][fishid] == 1)
    {
        new yes;
        if(AquariumInfo[aquaid][aqFishSatiety][fishid] > 0) AquariumInfo[aquaid][aqFishSatiety][fishid] --, yes = 1;
        if(yes == 1)
        {
            UpdateTextFish(aquaid, fishid);
            if(AquariumInfo[aquaid][aqFishSatiety][fishid] <= 0)
            {
                AquariumInfo[aquaid][aqFishStat][fishid] = 2;
                AquariumInfo[aquaid][aqFishSatiety][fishid] = 0;
                MoveFish(aquaid, fishid);
                SaveAquarium(aquaid, fishid);
            }
            else
            {
                new string_mysql[120];
                format(string_mysql, sizeof(string_mysql), "UPDATE `aquarium` SET `aqFishSatiety%d`='%d' WHERE `newid`='%d'",
                    fishid, AquariumInfo[aquaid][aqFishSatiety][fishid], AquariumInfo[aquaid][aqNewid]);
                query_empty(pearsq, string_mysql);
            }
        }
    }
    return 1;
}
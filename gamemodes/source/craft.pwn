
/*
Как добавить новый предмет для крафта? (Создание нового из других деталей)
1. В stock GetThingForCraft прописываем зависимости для создания предмета
2. В stock ClickTextDraw_CraftProcess находим меню Верстака, Кухонной Плиты или Хим Стола и добавляем новую строку
*/

#define MAX_DRAW_CRAFTPROCESS 22
#define MAX_CRAFT_ITEM 5
#define MAX_CRAFT_ITEM_QUAN 5

new PlayerText:CraftProcessDraw[MAX_DRAW_CRAFTPROCESS][MAX_REALPLAYERS]; // Переменные для хранения текстдравов (Создаваемые)
new CraftProcessTimer[MAX_REALPLAYERS];
new ProcessQuan[MAX_REALPLAYERS];
new Float:ProcessOne[MAX_REALPLAYERS];
new SizeGreen[MAX_REALPLAYERS];
new PosGreen[MAX_REALPLAYERS][3];
new bool:DoneGreen[MAX_REALPLAYERS][3];
new CraftInvent[MAX_REALPLAYERS]; // Слот предмета в инвентаре
new ThingNeed[MAX_REALPLAYERS]; // Какой id предмета требуется
new CreateThingID[MAX_REALPLAYERS]; // Какой предмет создаём
new CreateThingType[MAX_REALPLAYERS]; // Какой тип предмета создаём
new InvaCraft[MAX_REALPLAYERS][MAX_CRAFT_ITEM]; // Из какого слота лежат предметы в ячейках для крафта
new InvaCraftQuan[MAX_REALPLAYERS][MAX_CRAFT_ITEM][MAX_CRAFT_ITEM_QUAN]; // Из какого слота лежат предметы в ячейках для крафта

// Зависимости для создания новых предметов (Крафт)
stock GetThingForCraft(thingId, &i0, &q0, &t0, &i1, &q1, &t1, &i2, &q2, &t2, &i3, &q3, &t3, &i4, &q4, &t4)
{
    if(thingId == 11) // Бомба (Инженер)
    {
        i0 = 182, q0 = 3, t0 = 0; // Деталь Бомбы 3 Штуки
    }
    else if(thingId == 64) // Exlosive Ammo 20,8mm (Инженер)
    {
        i0 = 60, q0 = 12, t0 = 0; // Палладий 12 грамм
        i1 = 27, q1 = 1, t1 = 0; // Ammo 20,8mm
    }
    else if(thingId == 65) // Exlosive Ammo 11,43mm (Инженер)
    {
        i0 = 60, q0 = 12, t0 = 0; // Палладий 12 грамм
        i1 = 28, q1 = 1, t1 = 0; // Ammo 11,43mm
    }
    else if(thingId == 66) // Exlosive Ammo 5,45mm (Инженер)
    {
        i0 = 60, q0 = 12, t0 = 0; // Палладий 12 грамм
        i1 = 29, q1 = 1, t1 = 0; // Ammo 5,45mm
    }
    else if(thingId == 67) // Ammo 45mm (Инженер)
    {
        i0 = 60, q0 = 12, t0 = 0; // Палладий 12 грамм
        i1 = 30, q1 = 1, t1 = 0; // Ammo 45mm
    }
    else if(thingId == 182) // Деталь Бомбы (Инженер)
    {
        i0 = 181, q0 = 3, t0 = 0; // Изолента 3 Штуки
        i1 = 60, q1 = 40, t1 = 0; // Палладий 40 грамм
        i2 = 61, q2 = 10, t2 = 0; // Гелий 3 10 мл
    }
    else if(thingId == 180) // Таблетка Защиты (Химик)
    {
        i0 = 6, q0 = 20, t0 = 0; // Грибы 20 Штук
        i1 = 112, q1 = 1, t1 = 0; // Водка 1 Бутылка
        i2 = 5, q2 = 1, t2 = 0; // Оболочка Таблетки 1 шт
    }
    else if(thingId == 198) // Таблетка Атаки (Химик)
    {
        i0 = 6, q0 = 20, t0 = 0; // Грибы 40 Штук
        i1 = 112, q1 = 2, t1 = 0; // Водка 2 Бутылки
        i2 = 5, q2 = 1, t2 = 0; // Оболочка Таблетки 1 шт
    }
    else if(thingId == 90) // Монтировка
    {
        i0 = 201, q0 = 1, t0 = 0; // Труба
    }
    else if(thingId == 19) // отмычка
    {
        i0 = 202, q0 = 1, t0 = 0; // вилка
    }
    else if(thingId == 205) // Бомба Липучка (Инженер)
    {
        i0 = 182, q0 = 1, t0 = 0; // Деталь Бомбы 1 Штуки
    }
    else
    {
        new ingId[6], ingQuan[6];
        new result = menuEatIngredient(thingId, ingId[0], ingId[1], ingId[2], ingId[3], ingId[4], ingId[5], ingQuan[0], ingQuan[1], ingQuan[2], ingQuan[3], ingQuan[4], ingQuan[5]);
        if(result)
        {
            if(ingId[0] > 0) i0 = ingId[0], q0 = ingQuan[0], t0 = 0;
            if(ingId[1] > 0) i1 = ingId[1], q1 = ingQuan[1], t1 = 0;
            if(ingId[2] > 0) i2 = ingId[2], q2 = ingQuan[2], t2 = 0;
            if(ingId[3] > 0) i3 = ingId[3], q3 = ingQuan[3], t3 = 0;
            if(ingId[4] > 0) i4 = ingId[4], q4 = ingQuan[4], t4 = 0;
        }
    }
    return 1;
}

stock PutThingCraft(playerid, slot)
{
    if(CreateThingID[playerid] == 0) return ErrorMessage(playerid, "{FF6347}Сначала выберите предмет, который хотите создать или улучшить"), i_resetveshi(playerid);
    if(OnlineInfo[playerid][oInventSelectLeft] == 9999) return ErrorMessage(playerid, "{FF6347}Выберите предмет в инвентаре, а затем положите его в ячейку");

    new inva = OnlineInfo[playerid][oInventSelectLeft];
    new thingId = PlayerInfo[playerid][pInven][inva], thingQuan = PlayerInfo[playerid][pInvenQuan][inva];
    new thingType = PlayerInfo[playerid][pInvenType][inva], thingPack = PlayerInfo[playerid][pInvenPack][inva];

    if(thingId == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! В ячейке ничего нет");
    if(thingPack > 0) return ErrorMessage(playerid, "{FF6347}Этот премет в упаковке и его нельзя использовать"), i_resetveshi(playerid);

    new craftId[MAX_CRAFT_ITEM], craftQuan[MAX_CRAFT_ITEM], craftType[MAX_CRAFT_ITEM];
    GetThingForCraft(CreateThingID[playerid], craftId[0], craftQuan[0], craftType[0], craftId[1], craftQuan[1], craftType[1], craftId[2], craftQuan[2], craftType[2], craftId[3], craftQuan[3], craftType[3], craftId[4], craftQuan[4], craftType[4]);
    
    new yes = -1;
    for(new i = 0; i < MAX_CRAFT_ITEM; i ++)
    {
        if(craftId[i] == thingId && craftType[i] == thingType)
        {
            yes = i;
            break;
        }
    }
    if(yes == -1) return ErrorMessage(playerid, "{FF6347}Этот предмет не используется для крафта\n{cccccc}Нажмите на предмет, который вы хотите скрафтить или улучшить,\n{cccccc}чтобы увидеть список требуемых предметов"), i_resetveshi(playerid);
    if(CheckThingQuan(craftId[yes]) == 1 && craftType[yes] == 0)
    {
        if(craftQuan[yes] > thingQuan) return ErrorMessage(playerid, "{FF6347}Количества этого предмета в вашем инвентаре недостаточно для крафта"), i_resetveshi(playerid);
    }

    PlayerPlaySound(playerid,17803,0,0,0);
    if(InvaCraft[playerid][slot] > 0) // Что-то уже лежит в этом слоте
    {
        new alreadyInva = InvaCraft[playerid][slot] - 1;
        if(PlayerInfo[playerid][pInven][alreadyInva] == thingId && PlayerInfo[playerid][pInvenType][alreadyInva] == thingType) // Такой-же предмет, значит стакаем
        {
            if(CheckThingQuan(thingId) == 1 && thingType == 0) return ErrorMessage(playerid, "{FF6347}Вы уже положили этот предмет\n{cccccc}Необходимое количество будет изъято по окончанию процесса"), i_resetveshi(playerid);
            else
            {
                if(GetInvaInCraftSlot(playerid, inva + 1)) return ErrorMessage(playerid, "{FF6347}Вы уже добавили этот предмет в одну из ячеек"), i_resetveshi(playerid);
            }
            if(!PutSlot(playerid, slot, inva)) return 1;
        }
        else return ErrorMessage(playerid, "{FF6347}Этот слот занят другим предметом\n{cccccc}Вы можете складывать в одну ячейку только одинаковые предметы"), i_resetveshi(playerid);
    }
    else
    {
        if(GetInvaInCraftSlot(playerid, inva + 1)) return ErrorMessage(playerid, "{FF6347}Вы уже добавили этот предмет в одну из ячеек"), i_resetveshi(playerid);
        InvaCraft[playerid][slot] = inva + 1;
        InvaCraftQuan[playerid][slot][0] = inva + 1;
    }
    UpdateDrawInvaThing(playerid, slot);
    i_resetveshi(playerid);
    return 1;
}

stock PutSlot(playerid, slot, inva)
{
    new yes;
    for(new i = 0; i < MAX_CRAFT_ITEM_QUAN; i ++)
    {
        if(InvaCraftQuan[playerid][slot][i] == 0)
        {
            InvaCraftQuan[playerid][slot][i] = inva + 1;
            yes = 1;
            break;
        }
    }
    if(yes == 0)
    {
        ErrorMessage(playerid, "{FF6347}В этой ячейке больше нет места для одинаковых предметов"), i_resetveshi(playerid);
        return 0;
    }
    return 1;
}

stock GetInvaInCraftSlot(playerid, inva) // Добавлен ли предмет из этого inva слота в ячейку крафта
{
    new yes;
    for(new i = 0; i < MAX_CRAFT_ITEM_QUAN; i ++)
    {
        if(InvaCraft[playerid][i] == inva)
        {   
            yes = 1;
            break;
        }

        for(new it = 0; it < MAX_CRAFT_ITEM_QUAN; it ++)
        {
            if(InvaCraftQuan[playerid][i][it] == inva)
            {
                yes = 1;
                break;
            }
        }
    }
    return yes;
}

stock CheckCraftReady(playerid)
{
    if((Tabs_Load[playerid] == 11 || Tabs_Load[playerid] == 12 || Tabs_Load[playerid] == 13)
        && CreateThingID[playerid] > 0)
    {
        if(ClearCraftThingItems(playerid)) PlayerPlaySound(playerid,6801,0,0,0);
        if(CraftProcessTimer[playerid] > 0)
        {
            ClearCraftProcess(playerid);
            HideDrawCraftProcess(playerid);
            ErrorMessage(playerid, "{FF6347}Вы переложили какие-то предметы и провалили процесс\n{cccccc}Не перекладывайте предметы до завершения крафта");
        }
    }
    return 1;
}

stock GetFullThingForCraft(playerid, type_message) // Проверяем, все ли требуемые предметы лежат в слотах
{
    new craftId[MAX_CRAFT_ITEM], craftQuan[MAX_CRAFT_ITEM], craftType[MAX_CRAFT_ITEM];
    GetThingForCraft(CreateThingID[playerid], craftId[0], craftQuan[0], craftType[0], craftId[1], craftQuan[1], craftType[1], craftId[2], craftQuan[2], craftType[2], craftId[3], craftQuan[3], craftType[3], craftId[4], craftQuan[4], craftType[4]);
    
    new quan, noFull;
    for(new i = 0; i < MAX_CRAFT_ITEM; i ++)
    {
        if(craftId[i] > 0) // Есть требования
        {
            quan = GetThingInCraftSlot(playerid, craftId[i], craftType[i]);
            if(craftQuan[i] > quan)
            {
                noFull = 1;
                break;
            }
        }
    }
    if(noFull == 1)
    {
        new thingId = CreateThingID[playerid];
        if(type_message == 0)
        {
            new line[100],lines[1000];
            format(line,sizeof(line),"{FF6347}Вы не собрали все предметы для: %s", GetNameThing(0, thingId, 0, 0)), strcat(lines,line);
            format(line,sizeof(line),"\n\n{cccccc}Для крафта этого предмета требуются:"), strcat(lines,line);
            for(new i = 0; i < MAX_CRAFT_ITEM; i ++)
            {
                if(craftId[i] > 0) format(line,sizeof(line),"\n{0088ff}- %s | Количество: %d", GetNameThing(0, craftId[i], craftType[i], 0), craftQuan[i]), strcat(lines,line);
            }
            ErrorMessage(playerid, lines);
        }
        else if(type_message == 1) 
        {
            ClearCraftThingItems(playerid);
            ErrorMessage(playerid, "{FF6347}Ошибка! Вы переложили какой-то предмет или его количество уменьшилось\n{cccccc}Не перекладывайте выбранные предметы до завершения крафта");
        }
        return 0;
    }
    return 1;
}

stock GetThingInCraftSlot(playerid, thingId, thingType) // Ищем предмет по слотам
{
    new inva, quan, inva_slot;
    for(new i = 0; i < MAX_CRAFT_ITEM_QUAN; i ++)
    {
        if(InvaCraft[playerid][i] > 0)
        {   
            inva = InvaCraft[playerid][i] - 1;
            if(PlayerInfo[playerid][pInven][inva] == thingId && PlayerInfo[playerid][pInvenType][inva] == thingType)
            {
                for(new it = 0; it < MAX_CRAFT_ITEM_QUAN; it ++)
                {
                    if(InvaCraftQuan[playerid][i][it] > 0)
                    {
                        inva_slot = InvaCraftQuan[playerid][i][it] - 1;
                        if(PlayerInfo[playerid][pInven][inva_slot] == thingId && PlayerInfo[playerid][pInvenType][inva_slot] == thingType)
                        {
                            if(CheckThingQuan(thingId) == 1 && thingType == 0) quan += PlayerInfo[playerid][pInvenQuan][inva_slot];
                            else quan ++;
                        }
                    }
                }
            }
        }
    }
    return quan;
}

stock TakeThingForCraft(playerid) // Собираем инфу о предметах, которые нужно забрать
{
    new craftId[MAX_CRAFT_ITEM], craftQuan[MAX_CRAFT_ITEM], craftType[MAX_CRAFT_ITEM];
    GetThingForCraft(CreateThingID[playerid], craftId[0], craftQuan[0], craftType[0], craftId[1], craftQuan[1], craftType[1], craftId[2], craftQuan[2], craftType[2], craftId[3], craftQuan[3], craftType[3], craftId[4], craftQuan[4], craftType[4]);
    
    for(new i = 0; i < MAX_CRAFT_ITEM; i ++)
    {
        if(craftId[i] > 0) TakeThingInCraftSlot(playerid, craftId[i], craftType[i], craftQuan[i]);
    }
    return 1;
}

stock TakeThingInCraftSlot(playerid, thingId, thingType, thingQuan) // Забираем предметы по окончанию
{
    new inva, quan;
    for(new i = 0; i < MAX_CRAFT_ITEM_QUAN; i ++)
    {
        if(InvaCraft[playerid][i] > 0)
        {   
            for(new it = 0; it < MAX_CRAFT_ITEM_QUAN; it ++)
            {
                if(InvaCraftQuan[playerid][i][it] > 0)
                {
                    inva = InvaCraftQuan[playerid][i][it] - 1;
                    TakeInvent(playerid, thingId, thingQuan, thingType, inva);
                }
            }
        }
    }
    return quan;
}

stock UpdateDrawInvaThing(playerid, slot) // Обновляем отображение ячеек для крафта
{
    if(OnlineInfo[playerid][oCraftDraw] == false) return 0;

    new i = slot + 12;
    PlayerTextDrawHide(playerid, CraftProcessDraw[i + MAX_CRAFT_ITEM][playerid]);

    if(InvaCraft[playerid][slot] == 0) // Пусто
    {
        PlayerTextDrawFont(playerid, CraftProcessDraw[i][playerid], TEXT_DRAW_FONT:4);
        PlayerTextDrawBackgroundColour(playerid, CraftProcessDraw[i][playerid], PlayerInfo[playerid][pStyle1]);
        PlayerTextDrawColour(playerid, CraftProcessDraw[i][playerid], PlayerInfo[playerid][pStyle1]);
        PlayerTextDrawBoxColour(playerid, CraftProcessDraw[i][playerid], 0);
    }
    else // Чё-то есть
    {
        PlayerTextDrawFont(playerid, CraftProcessDraw[i][playerid], TEXT_DRAW_FONT:5);
        PlayerTextDrawBackgroundColour(playerid, CraftProcessDraw[i][playerid], PlayerInfo[playerid][pStyle1]);
        PlayerTextDrawColour(playerid, CraftProcessDraw[i][playerid], -1);
        PlayerTextDrawBoxColour(playerid, CraftProcessDraw[i][playerid], 0);
        
        new inva = InvaCraft[playerid][slot] - 1;
        new thingId = PlayerInfo[playerid][pInven][inva], thingQuan = PlayerInfo[playerid][pInvenQuan][inva], thingPara = PlayerInfo[playerid][pInvenPara][inva];
        new thingType = PlayerInfo[playerid][pInvenType][inva], thingPack = PlayerInfo[playerid][pInvenPack][inva];

        new yesFindModel = GetModelPickItem(playerid, thingId, thingType, thingPara, thingPack, 0);
        if(yesFindModel > 0)
        {
            new Float:modelPos[4], findIt;
            GetModelTextDraw(yesFindModel, thingType,thingPack, modelPos[0], modelPos[1], modelPos[2], modelPos[3], findIt);
            PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[i][playerid], yesFindModel);
            if(thingType == 5) PlayerTextDrawSetPreviewVehicleColours(playerid, CraftProcessDraw[i][playerid], thingQuan, thingQuan);
            PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[i][playerid], modelPos[0], modelPos[1], modelPos[2], modelPos[3]);
        }

        new quanSlot;
        for(new it = 0; it < MAX_CRAFT_ITEM_QUAN; it ++)
        {
            if(InvaCraftQuan[playerid][slot][it] > 0) quanSlot ++;
        }
        if(quanSlot >= 2)
        {
            new string[4];
            format(string,sizeof(string),"%d", quanSlot);
            PlayerTextDrawSetString(playerid, CraftProcessDraw[i + MAX_CRAFT_ITEM][playerid], string);
            PlayerTextDrawShow(playerid, CraftProcessDraw[i + MAX_CRAFT_ITEM][playerid]);
        }
    }
    PlayerTextDrawShow(playerid, CraftProcessDraw[i][playerid]);
    return 1;
}

stock SelectThingCraft(playerid, thingId, thingType) // Выбрали предмет, который будем создавать
{
    PlayerPlaySound(playerid,1052,0,0,0);
    CreateThingID[playerid] = thingId;
    CreateThingType[playerid] = thingType;
    
    new line[100],lines[1000];
    format(line,sizeof(line),"{ff9000}Вы выбрали %s", GetNameThing(0, thingId, thingType, 0)), strcat(lines,line);
    format(line,sizeof(line),"\n\n{cccccc}Для крафта этого предмета требуются:"), strcat(lines,line);
    new craftId[MAX_CRAFT_ITEM], craftQuan[MAX_CRAFT_ITEM], craftType[MAX_CRAFT_ITEM];
    GetThingForCraft(thingId, craftId[0], craftQuan[0], craftType[0], craftId[1], craftQuan[1], craftType[1], craftId[2], craftQuan[2], craftType[2], craftId[3], craftQuan[3], craftType[3], craftId[4], craftQuan[4], craftType[4]);
    for(new i = 0; i < MAX_CRAFT_ITEM; i ++)
    {
        if(craftId[i] > 0) format(line,sizeof(line),"\n{0088ff}- %s | Количество: %d", GetNameThing(0, craftId[i], craftType[i], 0), craftQuan[i]), strcat(lines,line);
    }
    format(line,sizeof(line),"\n\n{cccccc}Выберите необходимые предметы в вашем инвентаре"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}А затем поместите их в свободные ячейки для создания"), strcat(lines,line);
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");

    UpdateDrawCraftThing(playerid, thingId);
    return 1;
}

stock UpdateDrawCraftThing(playerid, thingId) // Обновляем отображение выбранного предмета
{
    if(OnlineInfo[playerid][oCraftDraw] == false) return 0;

    // Получаем расположение инвентаря
    new Float:back_pos[2], Float:back_size[2];
    PlayerTextDrawGetPos(playerid, PlaInventDraw[5][playerid], back_pos[0], back_pos[1]);
    PlayerTextDrawGetTextSize(playerid, PlaInventDraw[5][playerid], back_size[0], back_size[1]);

    // Собираем расположение основы инвентаря
    new Float:min_pos[2], Float:max_pos[2];
    min_pos[0] = back_pos[0]; // Min Up
    min_pos[1] = back_pos[1]; // Min Left
    max_pos[0] = back_pos[0] + back_size[0]; // Max Down
    max_pos[1] = back_pos[1] + back_size[1]; // Max Right

    new Float:one[2];
    one[0] = (max_pos[0] - min_pos[0]) / 100; // 1 proc X
    one[1] = (max_pos[1] - min_pos[1]) / 100; // 1 proc Y

    new Float:centr[2];
    centr[0] = back_pos[0] + back_size[0] / 2; // centr X
    centr[1] = back_pos[1] + back_size[1] / 2; // centr Y

    // Получаем размер иконок инвентаря
    new Float:PlaPickSizeX, Float:PlaPickSizeY;
    PlayerTextDrawGetTextSize(playerid, PlaNestPick[20][playerid], PlaPickSizeX, PlaPickSizeY);

    new Float:draw1[2];
    draw1[1] = 30.0;
    FixTextDrawSquare_Y(draw1[1] * one[1], draw1[0]);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[1][playerid], draw1[0], draw1[1] * one[1]);

    if(thingId == 0)
    {
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[1][playerid], (centr[0] - draw1[0] / 2) + PlaPickSizeX / 2, back_pos[1] + one[1] * 35);
        PlayerTextDrawColour(playerid, CraftProcessDraw[1][playerid], 100); // -1
        PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[1][playerid], 1956);
        PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[1][playerid], -10.000000, 0.000000, 0.000000, 1.000000);
    }
    else
    {
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[1][playerid], (centr[0] - draw1[0] / 2) + PlaPickSizeX / 2, back_pos[1] + one[1] * 28);
        PlayerTextDrawColour(playerid, CraftProcessDraw[1][playerid], -1);
        PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[1][playerid], friskPick[thingId]);
        new Float:modelPos[4], findIt;
		GetModelTextDraw(friskPick[thingId], 0,0, modelPos[0], modelPos[1], modelPos[2], modelPos[3], findIt);
        PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[1][playerid], modelPos[0], modelPos[1], modelPos[2], modelPos[3]);
    }

    PlayerTextDrawShow(playerid, CraftProcessDraw[1][playerid]);
    return 1;
}

stock ClickTextDraw_CraftProcess(playerid, PlayerText:playertextid)
{
    if(playertextid == CraftProcessDraw[1][playerid]) // Кнопка двигателя
    {
        new vehicleid = OnlineInfo[playerid][oShowTabs];
        new model = VehInfo[vehicleid][vModel];

        if(CraftProcessTimer[playerid] > 0) return ErrorMessage(playerid, "{ffcc66}Нажимайте на кнопку возле полосы загрузки,\nкогда полоска будет на зелёной линии"), i_resetveshi(playerid);

        if(Tabs_Load[playerid] == 10) // Двигатель
        {
            if(OnlineInfo[playerid][oInventSelectLeft] == 9999) DiagnosVehicle(playerid, vehicleid, 0);
            else
            {
                new Float:health;
                GetVehicleHealth(vehicleid, health);
                if(health > 500.0) return ErrorMessage(playerid, "{FF6347}Двигатель не повреждён и не нуждается в ремонте"), i_resetveshi(playerid);

                new inva = OnlineInfo[playerid][oInventSelectLeft];
                new thingId = PlayerInfo[playerid][pInven][inva];

                if(IsAMoto(model)) ThingNeed[playerid] = 190;
                else if(IsAPlane(model)) ThingNeed[playerid] = 191;
                else if(IsABoat(model)) ThingNeed[playerid] = 192;
                else ThingNeed[playerid] = 183;

                if(thingId != ThingNeed[playerid])
                {
                    new string[90];
                    format(string,sizeof(string),"{FF6347}Для ремонта этого транспорта требуется {cccccc}%s", friskName[ThingNeed[playerid]]);
                    ErrorMessage(playerid, string);
                    i_resetveshi(playerid);
                    return 1;
                }

                ClearCraftProcess(playerid);

                CraftInvent[playerid] = inva;
                PPP15[playerid] = 6;
                CraftProcessTimer[playerid] = SetTimerEx("CraftProcess", 200, true, "dd", playerid, Tabs_Load[playerid]);

                around_player_audio(playerid, 32000, 0, 5.0, 0);
                i_resetveshi(playerid);
            }
        }
        else
        {
            PlayerPlaySound(playerid,17803,0,0,0);
            if(CreateThingID[playerid] > 0) // Предмет уже выбран, решаем чё с ним делать (Отбой или чё)
            {
                new thingId = CreateThingID[playerid];
                new line[100],lines[1000];
                format(line,sizeof(line),"{ff9000}Вы выбрали %s", GetNameThing(0, thingId, CreateThingType[playerid], 0)), strcat(lines,line);
                format(line,sizeof(line),"\n\n{cccccc}Для крафта этого предмета требуются:"), strcat(lines,line);
                new craftId[MAX_CRAFT_ITEM], craftQuan[MAX_CRAFT_ITEM], craftType[MAX_CRAFT_ITEM];
                GetThingForCraft(thingId, craftId[0], craftQuan[0], craftType[0], craftId[1], craftQuan[1], craftType[1], craftId[2], craftQuan[2], craftType[2], craftId[3], craftQuan[3], craftType[3], craftId[4], craftQuan[4], craftType[4]);
                for(new i = 0; i < MAX_CRAFT_ITEM; i ++)
                {
                    if(craftId[i] > 0) format(line,sizeof(line),"\n{0088ff}- %s | Количество: %d", GetNameThing(0, craftId[i], craftType[i], 0), craftQuan[i]), strcat(lines,line);
                }
                format(line,sizeof(line),"\n\n{FF6347}Хотите отменить создание этого предмета?"), strcat(lines,line);
                ShowDialog(playerid,535,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"Да","Нет");
            }
            else
            {
                new line[100],lines[800];
                if(Tabs_Load[playerid] == 11) // Верстак
                {
                    if(OnlineInfo[playerid][oInventSelectLeft] == 9999) // Ничего не выбрано для улучшений, значит открываем меню создания
                    {
                        format(line,sizeof(line),"{ff9000}Взрывной патрон Ammo 20,8mm {cccccc}| Дробовик"), strcat(lines,line);
                        format(line,sizeof(line),"\n{ff9000}Взрывной патрон Ammo 11,43mm {cccccc}| Пистолет, Пистолет-пулемёт"), strcat(lines,line);
                        format(line,sizeof(line),"\n{ff9000}Взрывной патрон Ammo 5,45mm {cccccc}| Автомат"), strcat(lines,line);
                        format(line,sizeof(line),"\n{ff9000}Взрывной патрон Ammo 45mm {cccccc}| Винтовка"), strcat(lines,line);
                        format(line,sizeof(line),"\n{ff9000}Деталь Бомбы"), strcat(lines,line);
                        format(line,sizeof(line),"\n{ff9000}Бомба"), strcat(lines,line);
                        format(line,sizeof(line),"\n{ff9000}Монтировка"), strcat(lines,line);
                        format(line,sizeof(line),"\n{ff9000}Отмычка"), strcat(lines,line);
                        format(line,sizeof(line),"\n{ff9000}Бомба Липучка"), strcat(lines,line);
                        ShowDialog(playerid,1132,DIALOG_STYLE_LIST,"{ff9000}Верстак",lines,"Выбор","Отмена");
                    }
                    else
                    {
                        // Отсюда берём предмет, который будем не крафтить, а улучшать
                        // - Чистить оружие оружейным маслом
                        // - Улучшать качество стрельбы из оружия
                    }
                }
                else if(Tabs_Load[playerid] == 12) // Кухонная Плита
                {
                    format(line,sizeof(line),"{ff9000}Пицца Домашняя"), strcat(lines,line);
                    format(line,sizeof(line),"\n{ff9000}Апельсиновый сок"), strcat(lines,line);
                    format(line,sizeof(line),"\n{ff9000}Яблочный сок"), strcat(lines,line);
                    ShowDialog(playerid,1393,DIALOG_STYLE_LIST,"{ff9000}Кухонная Плита",lines,"Выбор","Отмена");
                }
                else if(Tabs_Load[playerid] == 13) // Химический Стол
                {
                    format(line,sizeof(line),"{ff9000}Таблетка Защиты {cccccc}| -20 проц. дамага"), strcat(lines,line);
                    format(line,sizeof(line),"\n{ff9000}Таблетка Атаки {cccccc}| +20 проц. к дамагу"), strcat(lines,line);
                    ShowDialog(playerid,1391,DIALOG_STYLE_LIST,"{ff9000}Химический Стол",lines,"Выбор","Отмена");
                }
            }
        }
        return 1;
    }
    if(playertextid == CraftProcessDraw[4][playerid]) // Кнопка ремонта
    {
        if(CraftProcessTimer[playerid] == 0)
        {
            i_resetveshi(playerid);
            new line[100],lines[1000];

            if(Tabs_Load[playerid] == 10) // Двигатель
            {
                format(line,sizeof(line),"\n{444444}Выберите {ff9000}Рем. комплект {444444}в инвентаре"), strcat(lines,line);
                format(line,sizeof(line),"\n{444444}Затем повторно нажмите на двигатель, чтобы начать ремонт"), strcat(lines,line);

                format(line,sizeof(line),"\n\n{ffcc66}Нажимайте на кнопку с гаечным ключём в тот момент,\nкогда полоса загрузки находится на зелёной зоне"), strcat(lines,line);
                ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Двигатель",lines,"*","");
            }
            else
            {
                if(CreateThingID[playerid] > 0) // Предмет уже выбран, значит запускаем крафт
                {
                    if(AntiFloodMysqlRequest(playerid, 1)) return 1;
                    if(!GetFullThingForCraft(playerid, 0)) return 1;

                    HidePlayerDialog(playerid);
                    ClearCraftProcess(playerid);
                    CraftInvent[playerid] = 0;
                    PPP15[playerid] = 6;
                    CraftProcessTimer[playerid] = SetTimerEx("CraftProcess", 200, true, "dd", playerid, Tabs_Load[playerid]);
                    return 1;
                }
                if(Tabs_Load[playerid] == 11) // Верстак
                {
                    format(line,sizeof(line),"\n{ff9000}Создание Предметов"), strcat(lines,line);
                    format(line,sizeof(line),"\n{444444}1. Нажмите на {ff9000}пустую область в кружочке сверху"), strcat(lines,line);
                    format(line,sizeof(line),"\n{444444}2. Выберите предмет, который хотите создать"), strcat(lines,line);
                    format(line,sizeof(line),"\n{444444}3. Положите требуемые детали или предметы из инвентаря в пустые ячейки"), strcat(lines,line);

                    format(line,sizeof(line),"\n\n{ff9000}Улучшение Предметов"), strcat(lines,line);
                    format(line,sizeof(line),"\n{444444}1. Выберите {ff9000}предмет в инвентаре{444444}, который хотите улучшить"), strcat(lines,line);
                    format(line,sizeof(line),"\n{444444}2. Затем нажмите на пустую область в кружочке"), strcat(lines,line);
                    format(line,sizeof(line),"\n{444444}3. Положите требуемые детали или предметы из инвентаря в пустые ячейки"), strcat(lines,line);

                    format(line,sizeof(line),"\n\n{ffcc66}После выбора предмета и сбора деталей нажмите"), strcat(lines,line);
                    format(line,sizeof(line),"\n{ffcc66}на кнопку с галочкой, чтобы начать процесс"), strcat(lines,line);
                    ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Верстак",lines,"*","");
                }
                else if(Tabs_Load[playerid] == 12) // Кухонная Плита
                {
                    format(line,sizeof(line),"\n{ff9000}Готовка Еды"), strcat(lines,line);
                    format(line,sizeof(line),"\n{444444}1. Нажмите на {ff9000}пустую область в кружочке сверху"), strcat(lines,line);
                    format(line,sizeof(line),"\n{444444}2. Выберите продукт, который хотите приготовить"), strcat(lines,line);
                    format(line,sizeof(line),"\n{444444}3. Положите требуемые ингредиенты из инвентаря в пустые ячейки"), strcat(lines,line);

                    format(line,sizeof(line),"\n\n{ffcc66}После выбора предмета и сбора деталей нажмите"), strcat(lines,line);
                    format(line,sizeof(line),"\n{ffcc66}на кнопку с галочкой, чтобы начать процесс"), strcat(lines,line);
                    ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Кухонная Плита",lines,"*","");
                }
                else if(Tabs_Load[playerid] == 13) // Химический Стол
                {
                    format(line,sizeof(line),"\n{ff9000}Создание Предметов"), strcat(lines,line);
                    format(line,sizeof(line),"\n{444444}1. Нажмите на {ff9000}пустую область в кружочке сверху"), strcat(lines,line);
                    format(line,sizeof(line),"\n{444444}2. Выберите предмет, который хотите создать"), strcat(lines,line);
                    format(line,sizeof(line),"\n{444444}3. Положите требуемые детали или предметы из инвентаря в пустые ячейки"), strcat(lines,line);

                    format(line,sizeof(line),"\n\n{ffcc66}После выбора предмета и сбора деталей нажмите"), strcat(lines,line);
                    format(line,sizeof(line),"\n{ffcc66}на кнопку с галочкой, чтобы начать процесс"), strcat(lines,line);
                    ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Химический Стол",lines,"*","");
                }
            }
            return 1;
        }

        ClickCraftProcess(playerid, Tabs_Load[playerid]);
        return 1;
    }
    if(playertextid >= CraftProcessDraw[12][playerid] && playertextid <= CraftProcessDraw[16][playerid]) // Ячейки для крафта
    {
        if(playertextid == CraftProcessDraw[12][playerid]) PutThingCraft(playerid, 0);
        else if(playertextid == CraftProcessDraw[13][playerid]) PutThingCraft(playerid, 1);
        else if(playertextid == CraftProcessDraw[14][playerid]) PutThingCraft(playerid, 2);
        else if(playertextid == CraftProcessDraw[15][playerid]) PutThingCraft(playerid, 3);
        else if(playertextid == CraftProcessDraw[16][playerid]) PutThingCraft(playerid, 4);
    }
    return 1;
}

stock ClearCraftProcess(playerid)
{
    ProcessQuan[playerid] = 0;
    DoneGreen[playerid][0] = false;
    DoneGreen[playerid][1] = false;
    DoneGreen[playerid][2] = false;

    if(CraftProcessTimer[playerid] > 0) 
    {
        PPP15[playerid] = 0;
        KillTimer(CraftProcessTimer[playerid]);
        CraftProcessTimer[playerid] = 0;
        ClearAnimations(playerid);
        ClearAnim(playerid);
    }
    return 1;
}

stock ClickCraftProcess(playerid, tabs_load)
{
    new Float:done_process = ProcessOne[playerid] * ProcessQuan[playerid];
    new Float:minx[3], Float:maxx[3];
    GetDiapasonCraft(playerid, minx[0], minx[1], minx[2], maxx[0], maxx[1], maxx[2]);

    if(done_process >= minx[0] && done_process <= maxx[0]
        || done_process >= minx[1] && done_process <= maxx[1]
        || done_process >= minx[2] && done_process <= maxx[2])
    {
        if(DoneGreen[playerid][0] == false && done_process >= minx[0] && done_process <= maxx[0]) DoneProcessCraft(playerid, 0, tabs_load);
        else if(DoneGreen[playerid][1] == false && done_process >= minx[1] && done_process <= maxx[1]) DoneProcessCraft(playerid, 1, tabs_load);
        else if(DoneGreen[playerid][2] == false && done_process >= minx[2] && done_process <= maxx[2]) DoneProcessCraft(playerid, 2, tabs_load);
    }
    else
    {
        ClearCraftProcess(playerid);
        HideDrawCraftProcess(playerid);
        ErrorMessage(playerid, "{FF6347}Вы не попали в зелёную зону и провалили процесс");

        if(tabs_load == 10) ErrorMessageQuestProcess(playerid); // Ремонт Двигателя
    }
    return 1;
}

stock CheckCraftThing(playerid)
{
    new inva = CraftInvent[playerid];
    new thingId = PlayerInfo[playerid][pInven][inva];
    if(thingId != ThingNeed[playerid])
    {
        ClearCraftProcess(playerid);
        HideDrawCraftProcess(playerid);
        ErrorMessage(playerid, "{FF6347}Вы переложили предмет в инвентаре, который нужен для процесса");
        return 0;
    }
    return 1;
}

stock DoneProcessCraft(playerid, doneId, tabs_load)
{
    if(tabs_load == 10) // Ремонт Двигателя
    {
        if(!CheckCraftThing(playerid)) return 1;
    }

    if(DoneGreen[playerid][doneId] == false)
    {
        DoneGreen[playerid][doneId] = true;
        new drawId;
        if(doneId == 0) drawId = 9;
        else if(doneId == 1) drawId = 10;
        else if(doneId == 2) drawId = 11;
        PlayerTextDrawSetString(playerid, CraftProcessDraw[drawId][playerid], "ld_chat:thumbup");
        PlayerTextDrawShow(playerid, CraftProcessDraw[drawId][playerid]);
        if(doneId <= 1)
        {
            PlayerTextDrawSetString(playerid, CraftProcessDraw[drawId + 1][playerid], "ld_beat:down");
            PlayerTextDrawShow(playerid, CraftProcessDraw[drawId + 1][playerid]);
        }
    }
    if(Tabs_Load[playerid] == 10) around_player_audio(playerid, 32000, 0, 5.0, 0);
    else PlayerPlaySound(playerid,1150,0,0,0);
    return 1;
}

stock HideDrawCraftProcess(playerid)
{
    PlayerTextDrawHide(playerid, CraftProcessDraw[5][playerid]); // Green line 1
    PlayerTextDrawHide(playerid, CraftProcessDraw[6][playerid]); // Green line 2
    PlayerTextDrawHide(playerid, CraftProcessDraw[7][playerid]); // Green line 3
    PlayerTextDrawHide(playerid, CraftProcessDraw[8][playerid]); // bar load
    PlayerTextDrawHide(playerid, CraftProcessDraw[9][playerid]); // done 1
    PlayerTextDrawHide(playerid, CraftProcessDraw[10][playerid]); // done 2
    PlayerTextDrawHide(playerid, CraftProcessDraw[11][playerid]); // done 3
    return 1;
}

stock GetDiapasonCraft(playerid, &Float:minx0, &Float:minx1, &Float:minx2, &Float:maxx0, &Float:maxx1, &Float:maxx2)
{
    minx0 = PosGreen[playerid][0] * ProcessOne[playerid] - 2;
    minx1 = PosGreen[playerid][1] * ProcessOne[playerid] - 2;
    minx2 = PosGreen[playerid][2] * ProcessOne[playerid] - 2;

    maxx0 = (PosGreen[playerid][0] + SizeGreen[playerid]) * ProcessOne[playerid] - 2;
    maxx1 = (PosGreen[playerid][1] + SizeGreen[playerid]) * ProcessOne[playerid] - 2;
    maxx2 = (PosGreen[playerid][2] + SizeGreen[playerid]) * ProcessOne[playerid] - 2;
    return 1;
}

function CraftProcess(playerid, tabs_load)
{
    new ability;
    if(tabs_load == 10) ability = get_ability(playerid, 8); // Навык автомеханика Ремонт Двигателя
    else ability = 1; // Во всех остальных крафтах скорость полоски не зависит от навыка (Только шанс успеха)

    new Float:size_bar[2];
    PlayerTextDrawGetTextSize(playerid, CraftProcessDraw[8][playerid], size_bar[0], size_bar[1]);

    if(ProcessQuan[playerid] == 0) // Первый запуск
    {
        new Float:size_fon_bar[2];
        PlayerTextDrawGetTextSize(playerid, CraftProcessDraw[2][playerid], size_fon_bar[0], size_fon_bar[1]);
        size_bar[0] = size_fon_bar[0] - 4;
        size_bar[1] = size_fon_bar[1] - 4;
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[8][playerid], size_bar[0], size_bar[1]);
        
        ProcessOne[playerid] = size_bar[0] / 200; // Получаем 1 процент заполнения бара

        // Размер зелёных полосок
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[5][playerid], (10 + ability) * ProcessOne[playerid], size_bar[1] + 6);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[6][playerid], (10 + ability) * ProcessOne[playerid], size_bar[1] + 6);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[7][playerid], (10 + ability) * ProcessOne[playerid], size_bar[1] + 6);
        SizeGreen[playerid] = 10 + ability;
        new Float:size_green = SizeGreen[playerid] * ProcessOne[playerid];

        // Положение зелёных полосок
        new Float:pos_bar[2];
        PlayerTextDrawGetPos(playerid, CraftProcessDraw[2][playerid], pos_bar[0], pos_bar[1]);
        new Float:pos_green[3];
        PosGreen[playerid][0] = 20 + random(30);
        PosGreen[playerid][1] = 80 + random(30);
        PosGreen[playerid][2] = 150 + random(30);
        pos_green[0] = pos_bar[0] + PosGreen[playerid][0] * ProcessOne[playerid];
        pos_green[1] = pos_bar[0] + PosGreen[playerid][1] * ProcessOne[playerid];
        pos_green[2] = pos_bar[0] + PosGreen[playerid][2] * ProcessOne[playerid];

        PlayerTextDrawSetPos(playerid, CraftProcessDraw[5][playerid], pos_green[0], pos_bar[1] - 1);
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[6][playerid], pos_green[1], pos_bar[1] - 1);
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[7][playerid], pos_green[2], pos_bar[1] - 1);

        // Размер галочек
        new Float:fix_y, Float:size_done_x = 20 * ProcessOne[playerid];
        FixTextDrawSquare_X(size_done_x, fix_y);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[9][playerid], size_done_x, fix_y);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[10][playerid], size_done_x, fix_y);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[11][playerid], size_done_x, fix_y);

        // Внешний вид галочек
        PlayerTextDrawSetString(playerid, CraftProcessDraw[9][playerid], "ld_beat:down");
        PlayerTextDrawSetString(playerid, CraftProcessDraw[10][playerid], "ld_beat:down");
        PlayerTextDrawSetString(playerid, CraftProcessDraw[11][playerid], "ld_beat:down");

        // Положение галочек
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[9][playerid], (pos_green[0] + (size_green / 2)) - (size_done_x / 2), pos_bar[1] - fix_y * 1.5);
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[10][playerid], (pos_green[1] + (size_green / 2)) - (size_done_x / 2), pos_bar[1] - fix_y * 1.5);
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[11][playerid], (pos_green[2] + (size_green / 2)) - (size_done_x / 2), pos_bar[1] - fix_y * 1.5);

        // Показываем зелёные полоски
        PlayerTextDrawShow(playerid, CraftProcessDraw[5][playerid]);
        PlayerTextDrawShow(playerid, CraftProcessDraw[6][playerid]);
        PlayerTextDrawShow(playerid, CraftProcessDraw[7][playerid]);

        // Показываем первую галочку
        PlayerTextDrawShow(playerid, CraftProcessDraw[9][playerid]);
    }

    if(ability <= 2) ProcessQuan[playerid] ++;
    else if(ability >= 3 && ability <= 6) ProcessQuan[playerid] += 2;
    else if(ability >= 7 && ability <= 9) ProcessQuan[playerid] += 3;
    else ProcessQuan[playerid] += 4;

    new Float:done_process = ProcessOne[playerid] * ProcessQuan[playerid];
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[8][playerid], done_process, size_bar[1]);
    PlayerTextDrawShow(playerid, CraftProcessDraw[8][playerid]);

    // Проверка действий процесса
    new Float:minx[3], Float:maxx[3];
    GetDiapasonCraft(playerid, minx[0], minx[1], minx[2], maxx[0], maxx[1], maxx[2]);

    if(done_process > maxx[0] && DoneGreen[playerid][0] == false
    || done_process > maxx[1] && DoneGreen[playerid][1] == false
    || done_process > maxx[2] && DoneGreen[playerid][2] == false)
    {
        ClearCraftProcess(playerid);
        HideDrawCraftProcess(playerid);
        ErrorMessage(playerid, "{FF6347}Вы пропустили зелёную зону и провалили процесс");

        if(tabs_load == 10) ErrorMessageQuestProcess(playerid); // Ремонт Двигателя
        return 1;
    }

    if(ProcessQuan[playerid] >= 200)
    {
        ClearCraftProcess(playerid);
        HideDrawCraftProcess(playerid);

        if(Tabs_Load[playerid] == 10) // Ремонт Двигателя (Капот)
        {
            if(!CheckCraftThing(playerid)) return 1;

            i_del(playerid, CraftInvent[playerid]); // Забираем предмет

            new vehicleid = OnlineInfo[playerid][oShowTabs], minus = 10 - get_ability(playerid, 8);
            new Float:health = MaxVehicleHealth(VehInfo[vehicleid][vModel]) - (100 * minus);
            ACSetVehicleHealth(vehicleid, health);
            update_ability(playerid, 8, 15);

            // Квест ремонт транспорта
            if(NoCompleteQuest(playerid, 4) && IsACar(VehInfo[vehicleid][vModel]))
            {
                PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_repair6.mp3");
                SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Четко! Новый рем комплект можешь купить самостоятельно в любом автосервисе");
                SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Найди его в GPS навигаторе на своём смартфоне");
                SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Всё. До связи");

                PlayerInfo[playerid][pQuest][4] = 1;
                SaveQuest(playerid);
            }

            new line[90],lines[270];
            format(line,sizeof(line),"{99ff66}Выполнено!"), strcat(lines,line);
            format(line,sizeof(line),"\n\n{ffcc66}Максимальное HP этого транспорта: %d", MaxVehicleHealth(VehInfo[vehicleid][vModel])), strcat(lines,line);
            format(line,sizeof(line),"\n{ffcc66}Ваш навык автомеханика позволил выполнить ремонт на %.0f", health), strcat(lines,line);
            SuccessMessage(playerid, lines);
        }
        else // Крафт
        {
            if(!GetFullThingForCraft(playerid, 1)) return 1; // Проверка, на месте ли все предметы и хватает ли их количества

            // Создали новый предмет
            if(CreateThingID[playerid] > 0) CreateThingAfterCraft(playerid);
        }
    }
    return 1;
}

stock CreateThingAfterCraft(playerid)
{
    new yes, ability;
    if(Tabs_Load[playerid] == 11) ability = get_ability(playerid, 3); // Верстак (Инженер)
    else if(Tabs_Load[playerid] == 13) ability = get_ability(playerid, 7); // Химический Стол (Химик)

    if(Tabs_Load[playerid] == 11 || Tabs_Load[playerid] == 13) // Расчитываем шанс
    {
        new chance = 2;
        if(ability >= 3 && ability <= 4) chance = 3;
        else if(ability >= 5 && ability <= 7) chance = 4;
        else if(ability >= 8 && ability <= 9) chance = 5;
        else if(ability >= 10) chance = 6;
        switch(random(chance))
        {
            case 0: yes = 0;
            default: yes = 1;
        }
    }
    else yes = 1; // Кухонный Стол и все остальные

    if(yes == 1) // Удачный шанс создания предмета
    {
	    if(CheckThingQuan(CreateThingID[playerid]) == 1) // Количественный предмет
		{
            new getQuan, getLimit;
            i_limit(playerid, CreateThingID[playerid], getQuan, getLimit);
            if(getQuan+1 > getLimit)
            {
                new string[160];
                format(string,sizeof(string),"{FF6347}У вас нет места в инвентаре\nЛимит для этого предмета: %d\n\n{cccccc}Предметы учитываются из раздела торговли и упаковок с подарками", getLimit);
                ErrorMessage(playerid, string);
                return 1;
            }
        }

        new put_inva = GiveThingPlayer(playerid, CreateThingID[playerid], 1, 0, 0, CreateThingType[playerid], 0, 9999); // Выдаём предмет игроку
	    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}В вашем инвентаре не хватает места");

        SuccessMessage(playerid, "{99ff66}Выполнено!");
    }
    else // Проёба
    {
        PlayerPlaySound(playerid,31202,0,0,0);

        new line[90],lines[450];
        format(line,sizeof(line),"{FF6347}Потрачено..."), strcat(lines,line);
        format(line,sizeof(line),"\n\n{FF6347}У вас не получилось создать %s", GetNameThing(0, CreateThingID[playerid], CreateThingType[playerid], 0)), strcat(lines,line);
        format(line,sizeof(line),"\n{FF6347}Предметы, которые вы применяли, были использованы"), strcat(lines,line);
        if(Tabs_Load[playerid] == 11) format(line,sizeof(line),"\n{cccccc}Чем выше навык инженера, тем вероятнее шанс успеха"), strcat(lines,line);
        else if(Tabs_Load[playerid] == 13) format(line,sizeof(line),"\n{cccccc}Чем выше навык химика, тем вероятнее шанс успеха"), strcat(lines,line);
        format(line,sizeof(line),"\n{cccccc}Навык пополняется, даже если вы потерпели неудачу"), strcat(lines,line);
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
    }

    if(Tabs_Load[playerid] == 11)
    {
        update_ability(playerid, 3, 10); // Пополняем навык

        if(yes == 1 && IsAExplosiveAmmo(CreateThingID[playerid], CreateThingType[playerid])) // Ачивки, если создали взрывной патрон
        {
            if(PlayerInfo[playerid][pAchieve][86] == 0) AchievePlayer(playerid, 86, 1);
            if(PlayerInfo[playerid][pAchieve][101] == 0)
            {
                new quan_eammo[4];
                quan_eammo[0] = get_invent(playerid, 64, 0);
                quan_eammo[1] = get_invent(playerid, 65, 0);
                quan_eammo[2] = get_invent(playerid, 66, 0);
                quan_eammo[3] = get_invent(playerid, 67, 0);
                if(quan_eammo[0]+quan_eammo[1]+quan_eammo[2]+quan_eammo[3] >= 100) AchievePlayer(playerid, 101, 1);
            }
        }
    }
    else if(Tabs_Load[playerid] == 13) update_ability(playerid, 7, 10); // Пополняем навык

    TakeThingForCraft(playerid); // Забираем предметы
    ClearCraftThingItems(playerid);
    return 1;
}

stock IsAExplosiveAmmo(thingId, thingType)
{
    if(thingId >= 64 && thingId <= 67 && thingType == 0) return 1;
    return 0;
}

stock ErrorMessageQuestProcess(playerid)
{
    // Квест ремонт транспорта
    if(NoCompleteQuest(playerid, 4) && IsACar(VehInfo[OnlineInfo[playerid][oShowTabs]][vModel]))
    {
        if(PlayerInfo[playerid][pSex] == 1) 
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_repair5.mp3");
            SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Дружище, во время ремонта, нажимай на гаечный ключ, когда полоска будет на зелёной линии");
        }
        else 
        {
            PlayAudioStreamForPlayer(playerid, "https://cdn.pears.fun/sound/characters/jone/jone_repair55.mp3");
            SendClientMessage(playerid, COLOR_YELLOW,"Джоне (голосовое): Продруга, во время ремонта, нажимай на гаечный ключ, когда полоска будет на зелёной линии");
        }
    }
    return 1;
}

stock bonet_close(playerid)
{
    if(OnlineInfo[playerid][oShowTabs] != 9999)
    {
		new kolka = 0;
		foreach(Player, i)
		{
			if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[playerid][oShowTabs] == OnlineInfo[i][oShowTabs] && Tabs_Load[i] == 10) kolka ++;
		}
	    if(kolka <= 1)
	    {
    		if(IsABootFront(OnlineInfo[playerid][oShowTabs])) // Морда
    		{
    			GetVehicleParamsEx(OnlineInfo[playerid][oShowTabs], engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(OnlineInfo[playerid][oShowTabs], engine, lights, alarm, doors, bonnet, false, objective);
    		}
    		else // Жопа
    		{
				GetVehicleParamsEx(OnlineInfo[playerid][oShowTabs], engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(OnlineInfo[playerid][oShowTabs], engine, lights, alarm, doors, false, boot, objective);
			}
			VehInfo[OnlineInfo[playerid][oShowTabs]][vBonnet] = 0;
            if(VehInfo[OnlineInfo[playerid][oShowTabs]][vNospawn] != 2) VehInfo[OnlineInfo[playerid][oShowTabs]][vNospawn] = 0;
		}
        OnlineInfo[playerid][oShowTabs] = 9999;
	}
	PlayerTextDrawHide(playerid, PlaNestAct[0][playerid]);
	PlayerTextDrawHide(playerid, PlaNestAct[1][playerid]);

    destroyDraw_CraftProcess(playerid); // Удаляем текстдравы ремонта
   	return 1;
}

stock showDraw_CraftProcess(playerid, type)
{
    CreateThingID[playerid] = 0;
    CreateThingType[playerid] = 0;
    for(new i = 0; i < MAX_CRAFT_ITEM; i ++) 
    {
        InvaCraft[playerid][i] = 0;
        for(new it = 0; it < MAX_CRAFT_ITEM_QUAN; it ++) InvaCraftQuan[playerid][i][it] = 0;
    }

    createDraw_CraftProcess(playerid, type);
    PlayerTextDrawShow(playerid, CraftProcessDraw[0][playerid]); // Фон
    PlayerTextDrawShow(playerid, CraftProcessDraw[1][playerid]); // Кнопка для предмета который мы ремонтируем, улучшаем или крафтим
    PlayerTextDrawShow(playerid, CraftProcessDraw[2][playerid]); // Фон бара загрузки
    PlayerTextDrawShow(playerid, CraftProcessDraw[3][playerid]); // Фон кнопки выполнения действия
    PlayerTextDrawShow(playerid, CraftProcessDraw[4][playerid]); // Кнопка выполнения действия

    // Режим крафта (Отображаем иконки)
    if(type >= 1)
    {
        for(new i = 0; i < 5; i ++) PlayerTextDrawShow(playerid, CraftProcessDraw[i + 12][playerid]);
    }
    return 1;
}

stock ClearCraftThingItems(playerid)
{
    new quan;
    for(new i = 0; i < MAX_CRAFT_ITEM; i ++) 
    {
        if(InvaCraft[playerid][i] > 0)
        {
            quan ++;
            InvaCraft[playerid][i] = 0;
            UpdateDrawInvaThing(playerid, i);
            for(new it = 0; it < MAX_CRAFT_ITEM_QUAN; it ++) InvaCraftQuan[playerid][i][it] = 0;
        }
    }
    return quan;
}

stock destroyDraw_CraftProcess(playerid)
{
    CreateThingID[playerid] = 0;
    CreateThingType[playerid] = 0;
    ClearCraftProcess(playerid);

    if(OnlineInfo[playerid][oCraftDraw] == false) return 0;

    for(new i = 0; i < MAX_DRAW_CRAFTPROCESS; i++)
    {
        PlayerTextDrawHide(playerid, CraftProcessDraw[i][playerid]);
        PlayerTextDrawDestroy(playerid, CraftProcessDraw[i][playerid]);
    }
    OnlineInfo[playerid][oCraftDraw] = false;
    return 1;
}

stock DiagnosVehicle(playerid, vehicleid, stat)
{
    new Float:health;
    GetVehicleHealth(vehicleid, health);
    PlayerPlaySound(playerid,40405,0,0,0);
    
    new line[130],lines[2210];
    format(line,sizeof(line),"{ff9000}%s",GetVehicleName(VehInfo[vehicleid][vModel])), strcat(lines,line);
    format(line,sizeof(line),"\n{ff9000}Состояние: {cccccc}%.0f Health\n", health), strcat(lines,line);

    for(new i = 0; i < 13; i++)
    {
        if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE:i) != 0)
        {
            format(line,sizeof(line),"\n{ff9000}* {cccccc}%s",detalName[GetVehicleComponentInSlot(vehicleid, CARMODTYPE:i)]), strcat(lines,line);
        }
    }

    if(stat == 0)
    {
        format(line,sizeof(line),"\n\n{444444}Выберите {ff9000}Рем. комплект {444444}в инвентаре"), strcat(lines,line);
        format(line,sizeof(line),"\n{444444}Затем повторно нажмите на двигатель, чтобы начать ремонт"), strcat(lines,line);
    }
    ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Диагностика",lines,"*","");
}

stock posDraw_CraftProcess(playerid, type)
{
    if(OnlineInfo[playerid][oCraftDraw] == false || DrawInvent[playerid] == false) return 0;

    // Получаем расположение инвентаря
    new Float:back_pos[2], Float:back_size[2];
    PlayerTextDrawGetPos(playerid, PlaInventDraw[5][playerid], back_pos[0], back_pos[1]);
    PlayerTextDrawGetTextSize(playerid, PlaInventDraw[5][playerid], back_size[0], back_size[1]);

    // Собираем расположение основы инвентаря
    new Float:min_pos[2], Float:max_pos[2];
    min_pos[0] = back_pos[0]; // Min Up
    min_pos[1] = back_pos[1]; // Min Left
    max_pos[0] = back_pos[0] + back_size[0]; // Max Down
    max_pos[1] = back_pos[1] + back_size[1]; // Max Right

    new Float:one[2];
    one[0] = (max_pos[0] - min_pos[0]) / 100; // 1 proc X
    one[1] = (max_pos[1] - min_pos[1]) / 100; // 1 proc Y

    new Float:centr[2];
    centr[0] = back_pos[0] + back_size[0] / 2; // centr X
    centr[1] = back_pos[1] + back_size[1] / 2; // centr Y

    new Float:size_bar_x, Float:size_bar_y;
    if(type == 0) // Двигатель
    {
        // Фон двигателя
        new Float:draw0[2];
        draw0[1] = 60.0;
        FixTextDrawSquare_Y(draw0[1] * one[1], draw0[0]);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[0][playerid], draw0[0], draw0[1] * one[1]);
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[0][playerid], centr[0] - draw0[0] / 2, back_pos[1] + one[1] * 14);

        // Двигатель
        new Float:draw1[2];
        draw1[1] = 30.0;
        FixTextDrawSquare_Y(draw1[1] * one[1], draw1[0]);

        PlayerTextDrawTextSize(playerid, CraftProcessDraw[1][playerid], draw1[0], draw1[1] * one[1]);
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[1][playerid], centr[0] - draw1[0] / 2, back_pos[1] + one[1] * 25);

        // Размеры бара загрузки, фона кнопки ремонта и кнопки ремонта
        size_bar_x = 35 * one[1], size_bar_y = 8 * one[1];
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[2][playerid], size_bar_x, size_bar_y);
        new Float:fix_y, Float:size_fonbutton_x = 16 * one[1];
        FixTextDrawSquare_X(size_fonbutton_x, fix_y);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[3][playerid], size_fonbutton_x, fix_y);
        new Float:fix_y2, Float:size_button_x = 12 * one[1];
        FixTextDrawSquare_X(size_button_x, fix_y2);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[4][playerid], size_button_x, fix_y2);

        // Положение бара загрузки, фона кнопки ремонта и кнопки ремонта
        new Float:temp_x = centr[0] - ((size_bar_x) / 2) - ((size_fonbutton_x) / 2), Float:temp_y = back_pos[1] + one[1] * 77;
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[2][playerid], temp_x, temp_y);
        new Float:centr_bar = temp_y + (size_bar_y) / 2;
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[3][playerid], temp_x + size_bar_x + size_fonbutton_x/6, centr_bar - fix_y/2);
        new Float:fonbar_pos[2];
        PlayerTextDrawGetPos(playerid, CraftProcessDraw[3][playerid], fonbar_pos[0], fonbar_pos[1]); // Получаем координаты фона кнопки
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[4][playerid], fonbar_pos[0] + size_fonbutton_x/2 - size_button_x/2, centr_bar - fix_y2/2);
    }
    else if(type >= 1) // Верстак
    {   
        // Получаем размер иконок инвентаря
        new Float:PlaPickSizeX, Float:PlaPickSizeY;
        PlayerTextDrawGetTextSize(playerid, PlaNestPick[20][playerid], PlaPickSizeX, PlaPickSizeY);

        // Получаем расположение иконок инвентаря
        new Float:PlaPickPosX[5], Float:PlaPickPosY[5];
        for(new i = 0; i < 5; i ++)
        {
            // Получаем положение иконок
            PlayerTextDrawGetPos(playerid, PlaNestPick[i + 20][playerid], PlaPickPosX[i], PlaPickPosY[i]);

            PlayerTextDrawSetPos(playerid, CraftProcessDraw[i + 12][playerid], PlaPickPosX[i], PlaPickPosY[i]); // Положение иконок
            PlayerTextDrawTextSize(playerid, CraftProcessDraw[i + 12][playerid], PlaPickSizeX, PlaPickSizeY); // Размер иконок
        }

        // Цифры на всех ячейках
        new Float:sized_x = PlayerInfo[playerid][pDrawSize_X][6], Float:sized_y = PlayerInfo[playerid][pDrawSize_Y][6], Float:vrem_x, Float:vrem_y;
        for(new i = 0; i < 5; i ++)
        {
            PlayerTextDrawGetPos(playerid, CraftProcessDraw[i + 12][playerid], vrem_x, vrem_y);
            PlayerTextDrawSetPos(playerid, CraftProcessDraw[i + 17][playerid], vrem_x+2.0, vrem_y+1.0);
            PlayerTextDrawLetterSize(playerid, CraftProcessDraw[i + 17][playerid], 0.121666+sized_x*(0.121666/20), 0.608296+sized_y*(0.608296/20));
        }

        // Фон предмета, который крафтим или улучшаем
        new Float:draw0[2];
        draw0[1] = 60.0;
        FixTextDrawSquare_Y(draw0[1] * one[1], draw0[0]);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[0][playerid], draw0[0], draw0[1] * one[1]);
        new Float:fon_x = (centr[0] - draw0[0] / 2) + PlaPickSizeX / 2, Float:fon_y = back_pos[1] + one[1] * 14;
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[0][playerid], fon_x, fon_y);

        // Кнопка предмета, который крафтим или улучшаем
        new Float:draw1[2];
        draw1[1] = 30.0;
        FixTextDrawSquare_Y(draw1[1] * one[1], draw1[0]);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[1][playerid], draw1[0], draw1[1] * one[1]);
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[1][playerid], (centr[0] - draw1[0] / 2) + PlaPickSizeX / 2, back_pos[1] + one[1] * 35);


        // Размеры фона бара загрузки
        size_bar_x = 30 * one[1], size_bar_y = 8 * one[1];
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[2][playerid], size_bar_x, size_bar_y);

        // Размер фона кнопки
        new Float:fix_y, Float:size_fonbutton_x = 16 * one[1];
        FixTextDrawSquare_X(size_fonbutton_x, fix_y);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[3][playerid], size_fonbutton_x, fix_y);

        // Размер кнопки
        new Float:fix_y2, Float:size_button_x = 12 * one[1];
        FixTextDrawSquare_X(size_button_x, fix_y2);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[4][playerid], size_button_x, fix_y2);

        new Float:opstyp_fonbutton = PlaPickSizeX - PlaPickSizeX/4; // Отступ фона кнопки
        // Положение фона бара загрузки
        new Float:temp_x = fon_x + draw0[0] / 2 - (size_bar_x / 2) - (size_fonbutton_x / 2) - opstyp_fonbutton, Float:temp_y = back_pos[1] + one[1] * 77;
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[2][playerid], temp_x + opstyp_fonbutton + PlaPickSizeX/4, temp_y);

        // Положение фона кнопки
        new Float:centr_bar = temp_y + (size_bar_y) / 2;
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[3][playerid], temp_x + opstyp_fonbutton + size_bar_x + PlaPickSizeX/4, centr_bar - fix_y/2);

        // Положение кнопки
        new Float:fonbar_pos[2];
        PlayerTextDrawGetPos(playerid, CraftProcessDraw[3][playerid], fonbar_pos[0], fonbar_pos[1]); // Получаем координаты фона кнопки
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[4][playerid], fonbar_pos[0] + size_fonbutton_x/2 - size_button_x/2, centr_bar - fix_y2/2);
    }

    // Положение бара загрузки
    new Float:fon_bar[2];
    PlayerTextDrawGetPos(playerid, CraftProcessDraw[2][playerid], fon_bar[0], fon_bar[1]);
    PlayerTextDrawSetPos(playerid, CraftProcessDraw[8][playerid], fon_bar[0] + 2, fon_bar[1] + 2);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[8][playerid], size_bar_x - 4, size_bar_y - 4);
    return 1;
}

stock FixTextDrawSquare_X(Float:x, &Float:fix_y)
{
    new Float:one = x / 100;
    fix_y = x + one * 15;
}
stock FixTextDrawSquare_Y(Float:y, &Float:fix_x)
{
    new Float:one = y / 100;
    fix_x = y - one * 15;
}

stock createDraw_CraftProcess(playerid, type)
{
    if(OnlineInfo[playerid][oCraftDraw] == true) return 0; // Если эти текстдравы уже созданы, возвращаем 0

    CraftProcessDraw[0][playerid] = CreatePlayerTextDraw(playerid, 87.333267, 141.037063, "ld_beat:chit"); // Фон двигателя
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[0][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[0][playerid], 130.000015, 154.725921);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[0][playerid], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, CraftProcessDraw[0][playerid], 168430200);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[0][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[0][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[0][playerid], TEXT_DRAW_FONT:4);

    CraftProcessDraw[1][playerid] = CreatePlayerTextDraw(playerid, 113.000007, 164.266784, "dvigatel"); // Двигатель + кнопка
    PlayerTextDrawBackgroundColour(playerid, CraftProcessDraw[1][playerid], 0);
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[1][playerid], 0.024666, 0.265481);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[1][playerid], 78.666694, 91.259277);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[1][playerid], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawUseBox(playerid, CraftProcessDraw[1][playerid], true);
    PlayerTextDrawBoxColour(playerid, CraftProcessDraw[1][playerid], 0);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[1][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[1][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[1][playerid], TEXT_DRAW_FONT:5);
    PlayerTextDrawSetSelectable(playerid, CraftProcessDraw[1][playerid], true);

    if(type == 0) // Ремонт Двигателя
    {
        PlayerTextDrawColour(playerid, CraftProcessDraw[1][playerid], -1);
        PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[1][playerid], 19917);
        PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[1][playerid], -40.000000, 0.000000, 0.000000, 1.000000);
    }
    else if(type >= 1) // Крафт предметов
    {
        PlayerTextDrawColour(playerid, CraftProcessDraw[1][playerid], 100); // -1
        PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[1][playerid], 1956);
        PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[1][playerid], -10.000000, 0.000000, 0.000000, 1.000000);
    }

    CraftProcessDraw[2][playerid] = CreatePlayerTextDraw(playerid, 104.333343, 291.200012, "bar_fon"); // Фон бара загрузки
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[2][playerid], 0.016000, 0.223999);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[2][playerid], 82.333305, 17.837022);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[2][playerid], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, CraftProcessDraw[2][playerid], -1);
    PlayerTextDrawUseBox(playerid, CraftProcessDraw[2][playerid], true);
    PlayerTextDrawBoxColour(playerid, CraftProcessDraw[2][playerid], 0);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[2][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[2][playerid], 0);
    PlayerTextDrawBackgroundColour(playerid, CraftProcessDraw[2][playerid], 168429944);
    PlayerTextDrawFont(playerid, CraftProcessDraw[2][playerid], TEXT_DRAW_FONT:5);
    PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[2][playerid], 2709);
    PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[2][playerid], 0.000000, 0.000000, 0.000000, -2.000000);

    CraftProcessDraw[3][playerid] = CreatePlayerTextDraw(playerid, 188.333328, 278.755523, "ld_beat:chit"); // Фон кнопки ремонта
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[3][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[3][playerid], 36.000007, 42.725891);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[3][playerid], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, CraftProcessDraw[3][playerid], 168430200);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[3][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[3][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[3][playerid], TEXT_DRAW_FONT:4);
    PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[3][playerid], 3096);
    PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[3][playerid], 0.000000, 0.000000, 0.000000, 1.000000);

    CraftProcessDraw[4][playerid] = CreatePlayerTextDraw(playerid, 194.000061, 285.807403, "remont_button"); // Кнопка ремонта
    PlayerTextDrawBackgroundColour(playerid, CraftProcessDraw[4][playerid], 0);
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[4][playerid], 0.012666, 0.149333);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[4][playerid], 23.666654, 28.622215);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[4][playerid], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, CraftProcessDraw[4][playerid], -1);
    PlayerTextDrawUseBox(playerid, CraftProcessDraw[4][playerid], true);
    PlayerTextDrawBoxColour(playerid, CraftProcessDraw[4][playerid], 0);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[4][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[4][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[4][playerid], TEXT_DRAW_FONT:5);
    PlayerTextDrawSetSelectable(playerid, CraftProcessDraw[4][playerid], true);
    if(type == 0) // Двигатель
    {
        PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[4][playerid], 3096);
        PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[4][playerid], 0.000000, 0.000000, 0.000000, 1.000000);
    }
    else // Крафт
    {
        PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[4][playerid], 19131);
        PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[4][playerid], 0.000000, 90.000000, 90.000000, 1.000000);
    }

    CraftProcessDraw[5][playerid] = CreatePlayerTextDraw(playerid, 118.666648, 291.614837, "LD_SPAC:white"); // Зелёная полоска 1
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[5][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[5][playerid], 3.000002, 17.422197);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[5][playerid], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, CraftProcessDraw[5][playerid], 13793535);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[5][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[5][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[5][playerid], TEXT_DRAW_FONT:4);

    CraftProcessDraw[6][playerid] = CreatePlayerTextDraw(playerid, 142.666595, 291.370361, "LD_SPAC:white"); // Зелёная полоска 2
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[6][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[6][playerid], 3.000002, 17.422197);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[6][playerid], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, CraftProcessDraw[6][playerid], 13793535);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[6][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[6][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[6][playerid], TEXT_DRAW_FONT:4);

    CraftProcessDraw[7][playerid] = CreatePlayerTextDraw(playerid, 164.666610, 291.125885, "LD_SPAC:white"); // Зелёная полоска 3
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[7][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[7][playerid], 3.000002, 17.422197);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[7][playerid], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, CraftProcessDraw[7][playerid], 13793535);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[7][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[7][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[7][playerid], TEXT_DRAW_FONT:4);

    CraftProcessDraw[8][playerid] = CreatePlayerTextDraw(playerid, 105.666664, 292.444458, "LD_SPAC:white"); // Бар загрузки
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[8][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[8][playerid], 53.333351, 15.348165);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[8][playerid], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, CraftProcessDraw[8][playerid], PlayerInfo[playerid][pStyle1]);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[8][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[8][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[8][playerid], TEXT_DRAW_FONT:4);

    CraftProcessDraw[9][playerid] = CreatePlayerTextDraw(playerid, 115.333335, 277.096405, "ld_beat:down"); // Статус первой полоски
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[9][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[9][playerid], 9.333340, 11.199990);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[9][playerid], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, CraftProcessDraw[9][playerid], -1);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[9][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[9][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[9][playerid], TEXT_DRAW_FONT:4);

    CraftProcessDraw[10][playerid] = CreatePlayerTextDraw(playerid, 139.333328, 277.266754, "ld_chat:thumbup"); // Статус второй полоски
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[10][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[10][playerid], 9.333340, 11.199990);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[10][playerid], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, CraftProcessDraw[10][playerid], -1);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[10][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[10][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[10][playerid], TEXT_DRAW_FONT:4);

    CraftProcessDraw[11][playerid] = CreatePlayerTextDraw(playerid, 161.666671, 277.437103, "ld_chat:thumbup"); // Статус третьей полоски
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[11][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[11][playerid], 9.333340, 11.199990);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[11][playerid], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, CraftProcessDraw[11][playerid], -1);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[11][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[11][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[11][playerid], TEXT_DRAW_FONT:4);

    // Кнопки предметов для крафта
    CraftProcessDraw[12][playerid] = CreatePlayerTextDraw(playerid, 146.666671, 138.963012, "LD_SPAC:white");
    CraftProcessDraw[13][playerid] = CreatePlayerTextDraw(playerid, 146.666671, 138.963012, "LD_SPAC:white");
    CraftProcessDraw[14][playerid] = CreatePlayerTextDraw(playerid, 146.666671, 138.963012, "LD_SPAC:white");
    CraftProcessDraw[15][playerid] = CreatePlayerTextDraw(playerid, 146.666671, 138.963012, "LD_SPAC:white");
    CraftProcessDraw[16][playerid] = CreatePlayerTextDraw(playerid, 146.666671, 138.963012, "LD_SPAC:white");
    for(new i = 12; i <= 16; i ++)
	{
        PlayerTextDrawLetterSize(playerid, CraftProcessDraw[i][playerid], 0.000000, 0.000000);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[i][playerid], 32.999992, 32.355594);
        PlayerTextDrawAlignment(playerid, CraftProcessDraw[i][playerid], TEXT_DRAW_ALIGN:1);
        PlayerTextDrawColour(playerid, CraftProcessDraw[i][playerid], PlayerInfo[playerid][pStyle1]);
        PlayerTextDrawUseBox(playerid, CraftProcessDraw[i][playerid], true);
        PlayerTextDrawBoxColour(playerid, CraftProcessDraw[i][playerid], 0);
        PlayerTextDrawSetShadow(playerid, CraftProcessDraw[i][playerid], 0);
        PlayerTextDrawSetOutline(playerid, CraftProcessDraw[i][playerid], 0);
        PlayerTextDrawFont(playerid, CraftProcessDraw[i][playerid], TEXT_DRAW_FONT:4);
        PlayerTextDrawSetProportional(playerid, CraftProcessDraw[i][playerid], true);
        PlayerTextDrawSetSelectable(playerid, CraftProcessDraw[i][playerid], true);
    }

    // Цифры текстдравов крафта
    CraftProcessDraw[17][playerid] = CreatePlayerTextDraw(playerid, 399.333557, 275.437103, "100000000");
    CraftProcessDraw[18][playerid] = CreatePlayerTextDraw(playerid, 399.333557, 275.437103, "100000000");
    CraftProcessDraw[19][playerid] = CreatePlayerTextDraw(playerid, 399.333557, 275.437103, "100000000");
    CraftProcessDraw[20][playerid] = CreatePlayerTextDraw(playerid, 399.333557, 275.437103, "100000000");
    CraftProcessDraw[21][playerid] = CreatePlayerTextDraw(playerid, 399.333557, 275.437103, "100000000");
	for(new i = 17; i <= 21; i ++)
	{
		PlayerTextDrawLetterSize(playerid, CraftProcessDraw[i][playerid], 0.131666, 0.600296);
		PlayerTextDrawAlignment(playerid, CraftProcessDraw[i][playerid], TEXT_DRAW_ALIGN:1);
		if(PlayerInfo[playerid][pSty] == 6 || PlayerInfo[i][pSty] == 11) PlayerTextDrawColour(playerid, CraftProcessDraw[i][playerid], 673720575);
		else PlayerTextDrawColour(playerid, CraftProcessDraw[i][playerid], -1);
		PlayerTextDrawSetShadow(playerid, CraftProcessDraw[i][playerid], 0);
		PlayerTextDrawSetOutline(playerid, CraftProcessDraw[i][playerid], 0);
		PlayerTextDrawBackgroundColour(playerid, CraftProcessDraw[i][playerid], 51);
		PlayerTextDrawFont(playerid, CraftProcessDraw[i][playerid], TEXT_DRAW_FONT:2);
		PlayerTextDrawSetProportional(playerid, CraftProcessDraw[i][playerid], true);
	}

    OnlineInfo[playerid][oCraftDraw] = true;
    posDraw_CraftProcess(playerid, type);
    return 1;
}

stock IsAVerstak(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid,1.0,2490.801025, -1703.421997, 2074.027832) && GetPlayerInterior(playerid) == 212 && GetPlayerVirtualWorld(playerid) == 212 
    || IsPlayerInRangeOfPoint(playerid,1.0,2473.290771, -2024.834960, 2052.320800) && GetPlayerInterior(playerid) == 213 && GetPlayerVirtualWorld(playerid) == 213
	|| IsPlayerInRangeOfPoint(playerid,1.0,2252.442871, -1466.458496, 2089.403564) && GetPlayerInterior(playerid) == 214 && GetPlayerVirtualWorld(playerid) == 214 
    || IsPlayerInRangeOfPoint(playerid,1.0,1685.440063, -2092.027587, 2091.805908) && GetPlayerInterior(playerid) == 215 && GetPlayerVirtualWorld(playerid) == 215
	|| IsPlayerInRangeOfPoint(playerid,1.0,1395.275878, 1826.201904, 10.886253) && GetPlayerVirtualWorld(playerid) == 182 && GetPlayerInterior(playerid) == 18
    || IsPlayerInRangeOfPoint(playerid,1.0,1532.1577,1337.9738,12.7373) && GetPlayerVirtualWorld(playerid) == WORLD_YAKUZA_1LVL && GetPlayerInterior(playerid) == INT_YAKUZA_1LVL
    || IsPlayerInRangeOfPoint(playerid,1.0,916.6561,2489.6909,10.8461) && GetPlayerVirtualWorld(playerid) == WORLD_PRISON_WORKING && GetPlayerInterior(playerid) == INT_PRISON_WORKING // тюрьма
    || IsPlayerInRangeOfPoint(playerid,1.0,916.6563,2495.2856,10.8461) && GetPlayerVirtualWorld(playerid) == WORLD_PRISON_WORKING && GetPlayerInterior(playerid) == INT_PRISON_WORKING // тюрьма
    || IsPlayerInRangeOfPoint(playerid,1.0,916.6584,2500.8748,10.8461) && GetPlayerVirtualWorld(playerid) == WORLD_PRISON_WORKING && GetPlayerInterior(playerid) == INT_PRISON_WORKING // тюрьма
    || IsPlayerInRangeOfPoint(playerid,1.0,920.1514,2501.0066,10.8461) && GetPlayerVirtualWorld(playerid) == WORLD_PRISON_WORKING && GetPlayerInterior(playerid) == INT_PRISON_WORKING // тюрьма
    || IsPlayerInRangeOfPoint(playerid,1.0,920.1552,2495.4194,10.8461) && GetPlayerVirtualWorld(playerid) == WORLD_PRISON_WORKING && GetPlayerInterior(playerid) == INT_PRISON_WORKING // тюрьма
    ) return 1;

    return 0;
}

stock showworkbehch(playerid, v)
{
	OnlineInfo[playerid][oShowTabs] = v;
	i_tabs(playerid, 4, 1);

	showDraw_CraftProcess(playerid, 1); // Грузим и отображаем текстдравы крафта
	return 1;
}

stock workbench_close(playerid)
{
    if(OnlineInfo[playerid][oShowTabs] != 9999)
    {
        OnlineInfo[playerid][oShowTabs] = 9999;
	}

    destroyDraw_CraftProcess(playerid); // Удаляем текстдравы крафта
   	return 1;
}

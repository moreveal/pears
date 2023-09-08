
#define MAX_DRAW_VEHICLESHOP 17 // Количество текстдравов в меню

new PlayerText:VehicleShopDraw[MAX_DRAW_VEHICLESHOP][MAX_REALPLAYERS]; // Переменные для хранения текстдравов (Создаваемые)
enum vsInfo
{
    vsVehicleID, // Переменная, для хранения id транспорта при просмотре в автосалоне
    vsModel, // id модели транспорта в автосалоне
    bool:vsVehicleLoad, // Статус создан ли транспорт в автосалоне
    bool:vsTextDrawLoad, // Статус, загружены ли текстдравы автосалона
    vsColor[2], // Цвета транспорта
    bool:vsTest, // Test Drive Статус
    vsTimer // Таймер, перезагружающий камеру (Bug Fix)
}
new VehShopInfo[MAX_REALPLAYERS][vsInfo];

enum BUYCARENUM { Float:bcar_X, Float:bcar_Y, Float:bcar_Z, bcar_World, bcar_Int }
new BuyCarPos[][BUYCARENUM] =
{
    { -1656.8024,1210.3347,7.2500, 0, 0}, // 77
    { 1350.0997,1588.4250,10.8269, 3078, 186}, // 78
    { 1350.0997,1588.4250,10.8269, 3079, 186}, // 79
    { -1953.7754,297.7653,35.4687, 0, 0}, // 80
    { 1350.0997,1588.4250,10.8269, 3081, 186}, // 81
    { 1350.0997,1588.4250,10.8269, 3082, 186}, // 82
    { 1350.0997,1588.4250,10.8269, 3083, 186}, // 83
    { 1350.0997,1588.4250,10.8269, 3084, 186}, // 84
    { 1350.0997,1588.4250,10.8269, 3085, 186}, // 85
    { 1350.0997,1588.4250,10.8269, 3086, 186}, // 86
    { 1334.8636,1588.0709,10.8364, 3087, 185}, // 87
    { 1334.8636,1588.0709,10.8364, 3088, 185}, // 88
    { 1334.8636,1588.0709,10.8364, 3089, 185}, // 89
    { 1357.2124,1584.3049,10.8461, 3090, 184}, // 90 // sf
    { 1357.2124,1584.3049,10.8461, 3091, 184}, // 91 // ls
    { 1357.2124,1584.3049,10.8461, 3092, 184} // 92 // lv
};


stock buy_VehicleShop(playerid)
{  
    new bizId = TP[0][playerid];
    new productId = TP[1][playerid];
    new modelId = BizzInfo[bizId][bProduct][productId], price = BizzInfo[bizId][bPrice][productId];

    if(BizzInfo[bizId][bItem][productId] <= 0) return ErrorMessage(playerid, "{FF6347}Нет в наличии\n\n{cccccc}Вы можете отправиться в другой автосалон или в центр обмена [ Y >> GPS >> Услуги >> Центр Обмена ]");
    if(modelId == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Слот пустой или транспорт не загрузился");
    if(oGetPlayerMoney(playerid) < price) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");

    PlayerPlaySound(playerid,40405,0,0,0);
    format(store, sizeof(store), "{cccccc}Название: {ff9000}%s\n{cccccc}Стоимость: {99ff66}%d$ {cccccc}[%s]\n\n{ff9000}Вы уверены, что хотите купить транспорт?", vehName[modelId], price, get_k(price));
	ShowDialog(playerid,1341,DIALOG_STYLE_MSGBOX,"{ff9000}Транспорт",store,"Да","Нет");
    return 1;
}

stock openMenu_VehicleShop(playerid)
{
    new b = -1;
    for(new i = 0; i < sizeof(BuyCarPos); i++)
    {
        if(IsPlayerInRangeOfPoint(playerid,2.0,BuyCarPos[i][bcar_X],BuyCarPos[i][bcar_Y],BuyCarPos[i][bcar_Z]) 
        && GetPlayerVirtualWorld(playerid) == BuyCarPos[i][bcar_World]
        && GetPlayerInterior(playerid) == BuyCarPos[i][bcar_Int])
        {
            b = i + 77;
            break;
        }

    }

    if(b >= 0)
    {
        TP[1][playerid] = 0;
	    showMenu_VehicleShop(playerid, b, -1);
        return 1;
    }
    else return 0;
}

stock closeTestDrive_VehicleShop(playerid)
{
    VehShopInfo[playerid][vsTest] = false;
    
    new b = TP[0][playerid];
    new s = TP[1][playerid];

    destroyVehicle_VehicleShop(playerid);
    showMenu_VehicleShop(playerid, b, s);
    return 1;
}
stock openTestDrive_VehicleShop(playerid)
{
    if(VehShopInfo[playerid][vsVehicleLoad] == false) return ErrorMessage(playerid, "{FF6347}Ошибка! Транспорт не создан");

    VehShopInfo[playerid][vsTest] = true;

    ShowDialog(playerid,-1,DIALOG_STYLE_MSGBOX," "," ","*",""); // Сбрасываем диалоговые окна
    destroyDraw_VehicleShop(playerid); // Удаляем текстдравы
    OnlineInfo[playerid][oShowInterface] = 0;

    CancelSelectTextDraw(playerid); // Убираем мышку
	TogglePlayerControllable(playerid, 1); // Unfreeze

    SetPlayerInterior(playerid, 0);
    LinkVehicleToInterior(VehShopInfo[playerid][vsVehicleID], 0);

    Gas[VehShopInfo[playerid][vsVehicleID]] = 100; // Топливо максимальное количество

    new modelId = VehInfo[VehShopInfo[playerid][vsVehicleID]][vModel];
    if(IsACar(modelId)) // Авто
    {
        SetVehiclePos(VehShopInfo[playerid][vsVehicleID], 1477.6282,1217.3895,11.0);
        SetVehicleZAngle(VehShopInfo[playerid][vsVehicleID], 0.0);
    }
    else if(IsAMoto(modelId)) // Мото
    {
        SetVehiclePos(VehShopInfo[playerid][vsVehicleID], 1477.4413,1215.6592,10.0);
        SetVehicleZAngle(VehShopInfo[playerid][vsVehicleID], 0.0);
    }
    else if(IsABoat(modelId) || modelId == 460) // Катер и Skimmer
    {
        SetVehiclePos(VehShopInfo[playerid][vsVehicleID], 2435.5557,483.9736,2.0);
        SetVehicleZAngle(VehShopInfo[playerid][vsVehicleID], 270.0);
    }
    else if(IsAPlane(modelId)) // Авиа
    {
        new Float:plus;
        if(modelId == 553) plus = 2.0; // Большой самолёты, требуется координата Z по выше
        SetVehiclePos(VehShopInfo[playerid][vsVehicleID], 1477.6621,1236.6989,11.0 + plus);
        SetVehicleZAngle(VehShopInfo[playerid][vsVehicleID], 0.0);
    }

    Protect_PutPlayerInVehicle(playerid, VehShopInfo[playerid][vsVehicleID], 0); // Садим в транспорт
    SetCameraBehindPlayer(playerid); // Возвращаем камеру

    SuccessMessage(playerid, "{99ff66}Вы запустили Test Drive {cccccc}[ Выйти: кнопка N ]");
    return 1;
}
stock left_VehicleShop(playerid) // Предыдущий транспорт (Листаем влево)
{
    new b = TP[0][playerid];
    new s = TP[1][playerid];

    if(s == 0) // Если текущий слот 0, ищем максимальный последний
    {
        for(new gs = MAX_BIZ_ITEM - 1; gs > 0; gs--)
        {
            if(BizzInfo[b][bProduct][gs] > 0)
            {
                TP[1][playerid] = gs;
                break;
            }
        }
    }
    else TP[1][playerid] --;

    ShowDialog(playerid,-1,DIALOG_STYLE_MSGBOX," "," ","*","");
    destroyVehicle_VehicleShop(playerid);
    createVehicle_VehicleShop(playerid, b, TP[1][playerid]);
    return 1;
}
stock right_VehicleShop(playerid) // Следующий транспорт (Листаем вправо)
{
    new b = TP[0][playerid];
    new s = TP[1][playerid];

    if(s + 1 >= MAX_BIZ_ITEM) TP[1][playerid] = 0; // Если следующий слот последний, показываем 0 слот
    else if(BizzInfo[b][bProduct][s + 1] == 0) TP[1][playerid] = 0; // Если в следующем слоте нет транспорта, показываем 0 слот
    else TP[1][playerid] ++;

    ShowDialog(playerid,-1,DIALOG_STYLE_MSGBOX," "," ","*","");
    destroyVehicle_VehicleShop(playerid);
    createVehicle_VehicleShop(playerid, b, TP[1][playerid]);
    return 1;
}
stock changeColor_VehicleShop(playerid, slot) // Меняем цвет транспорта с учётом текстдрава
{
    ChangeVehicleColor(VehShopInfo[playerid][vsVehicleID], VehShopInfo[playerid][vsColor][0], VehShopInfo[playerid][vsColor][1]);

    if(slot == 0)
    {
        new hexColor[11];
        format(hexColor,sizeof(hexColor),"%sFF", VehicleColoursTableHex[VehShopInfo[playerid][vsColor][0]]);
        new color = HexToInt(hexColor);

        PlayerTextDrawColor(playerid, VehicleShopDraw[15][playerid], color);
        PlayerTextDrawShow(playerid, VehicleShopDraw[15][playerid]);
    }
    return 1;
}
stock destroyVehicle_VehicleShop(playerid)
{
    if(VehShopInfo[playerid][vsVehicleLoad] == false) return 0;

    ACDestroyVehicle(VehShopInfo[playerid][vsVehicleID]);
    VehShopInfo[playerid][vsVehicleLoad] = false;
    return 1;
}
stock createVehicle_VehicleShop(playerid, bizId, productId)
{
    new modelId = BizzInfo[bizId][bProduct][productId], price = BizzInfo[bizId][bPrice][productId];

    if(modelId < 400 || modelId > MAX_VEHICLE_ID
    || VehShopInfo[playerid][vsVehicleLoad] == true) return 0;

     // Создаём транспорт
    new Float:pos[4], interiorId;
    new type = GetVehicleType(modelId);
    new class = GetVehicleClass(modelId);
    TP[2][playerid] = class;

    if(type == 1 || type == 2) // Авто и Мото
    {
        interiorId = 191;
        if(class <= 4) pos[0] = 1337.6630, pos[1] = 1570.6387, pos[2] = 10.6414, pos[3] = 154.5664;
        else if(class >= 5) pos[0] = 1316.2491, pos[1] = 1575.4805, pos[2] = 11.5481, pos[3] = 180.1429;
    }
    else if(type == 3) // Катера (Лодки)
    {
        interiorId = 0;
        if(bizId == 90) pos[0] = -1464.1099, pos[1] = 740.3231, pos[2] = 1.0, pos[3] = 270.0; // SF
        else if(bizId == 91) pos[0] = 2634.9102, pos[1] = -2320.7798, pos[2] = 1.0, pos[3] = 360.0; // LS
        else if(bizId == 92) pos[0] = 2388.7817, pos[1] = 533.4385, pos[2] = 1.0, pos[3] = 180.0; // LV
    }
    else if(type == 4 || type == 5) // Вертолёты и Самолёты
    {
        interiorId = 190;
        if(type == 4) pos[0] = 1547.9121, pos[1] = 1579.5526, pos[2] = 11.5170, pos[3] = 357.8251; // Вертолёты
        else
        {
            if(modelId == 519) pos[0] = 1547.6863, pos[1] = 1580.7811, pos[2] = 11.7588, pos[3] = 358.6555; // Shamal
            else if(modelId == 553) pos[0] = 1547.9331, pos[1] = 1579.3274, pos[2] = 12.1786, pos[3] = 359.3345; // Nevada
            else pos[0] = 1547.6884, pos[1] = 1581.3282, pos[2] = 11.7980, pos[3] = 359.6021; // Dodo and other
        }
    }
    VehShopInfo[playerid][vsModel] = modelId;
    VehShopInfo[playerid][vsVehicleID] = PP_CreateVehicle(VehShopInfo[playerid][vsVehicleID] , modelId, pos[0],pos[1],pos[2],pos[3], VehShopInfo[playerid][vsColor][0], VehShopInfo[playerid][vsColor][1], 9000, 0, -1, 0.0);
    SetVehicleVirtualWorld(VehShopInfo[playerid][vsVehicleID], playerid + 1);
    LinkVehicleToInterior(VehShopInfo[playerid][vsVehicleID], interiorId);
    VehShopInfo[playerid][vsVehicleLoad] = true;

    // Название
    format(store,sizeof(store),"%s", vehName[modelId]);
    PlayerTextDrawSetString(playerid, VehicleShopDraw[7][playerid], store);
    PlayerTextDrawShow(playerid, VehicleShopDraw[7][playerid]);

    // Цена
    format(store,sizeof(store),"%d$", price);
    PlayerTextDrawSetString(playerid, VehicleShopDraw[8][playerid], store);
    PlayerTextDrawShow(playerid, VehicleShopDraw[8][playerid]);

    if(BizzInfo[bizId][bItem][productId] > 0) PlayerTextDrawHide(playerid, VehicleShopDraw[9][playerid]);
    else PlayerTextDrawShow(playerid, VehicleShopDraw[0][playerid]);
    return 1;
}
stock closeMenu_VehicleShop(playerid)
{
    destroyVehicle_VehicleShop(playerid); // Удаляем транспорт

    ShowDialog(playerid,-1,DIALOG_STYLE_MSGBOX," "," ","*",""); // Сбрасываем диалоговые окна
    destroyDraw_VehicleShop(playerid); // Удаляем текстдравы
    OnlineInfo[playerid][oShowInterface] = 0;

    CancelSelectTextDraw(playerid); // Убираем мышку
	keep(playerid); // Подмораживаем

    S_SetPlayerVirtualWorld(playerid, SpWorld[playerid], SpInt[playerid]);
    SetPlayerInterior(playerid, SpInt[playerid]);

    PPSetPlayerPos(playerid, SpX[playerid], SpY[playerid], SpZ[playerid]);
    SetPlayerFacingAngle(playerid, SpA[playerid]);

    SetCameraBehindPlayer(playerid); // Возвращаем камеру

    ClearAnimations(playerid), ClearAnim(playerid); // Сбрасываем все анимки
    return 1;
}
stock showMenu_VehicleShop(playerid, bizId, slot) // Открываем меню автосалона
{
    if(OnlineInfo[playerid][oShowInterface] > 0) return ErrorMessage(playerid, "{FF6347}У вас открыто меню [ Прежде чем открыть другое, закройте его ]");

    ShowDialog(playerid,-1,DIALOG_STYLE_MSGBOX," "," ","*",""); // Сбрасываем диалоговые окна

    if(slot == -1) // Первый запуск меню
    {
        TP[0][playerid] = bizId; // Записываем id бизнеса, из которого смотрим транспорт

        slot = 0;
        // Сбрасываем цвета транспорта
        VehShopInfo[playerid][vsColor][0] = 1;
        VehShopInfo[playerid][vsColor][1] = 1;
        // Записываем координаты
        savePositionPlayerForMenu(playerid);
    }

    createDraw_VehicleShop(playerid); // Создаём текстдравы

    // Отображаем текстдравы
    for(new i = 0; i < MAX_DRAW_VEHICLESHOP; i++) PlayerTextDrawShow(playerid, VehicleShopDraw[i][playerid]);

    // Создаём транспорт из первого слота
    createVehicle_VehicleShop(playerid, bizId, slot);

    // Ставим игрока на позицию
    new Float:pos[4], world, interior;
    GetPlayerVehicleShopPos(playerid, bizId, pos[0], pos[1], pos[2], pos[3], world, interior);

    S_SetPlayerVirtualWorld(playerid, world, interior);
    SetPlayerInterior(playerid, interior);
    PPSetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    SetPlayerFacingAngle(playerid, pos[3]);

    SelectColorDraw(playerid); // Кликабельность
    PlayerPlaySound(playerid, 40405, 0, 0, 0); // Тилинь
    OnlineInfo[playerid][oShowInterface] = 16; // Записываем id открытого меню

    // Отображением камеры
    new class = GetVehicleClass(VehShopInfo[playerid][vsModel]);
    TP[2][playerid] = class;
    loadCam_VehicleShop(playerid);

    VehShopInfo[playerid][vsTimer] = SetTimerEx("loadCam_VehicleShop", 500, false, "d", playerid); // Bug Fix Камеры
    return 1;
}

function loadCam_VehicleShop(playerid)
{
    if(OnlineInfo[playerid][oShowInterface] != 16) return 0;

    new bizId = TP[0][playerid];
    new class = TP[2][playerid];
    if(bizId >= 77 && bizId <= 81 || bizId >= 82 && bizId <= 86) // Автосалоны и Мотосалоны
    {
        if(class <= 4)
        {
            InterpolateCameraPos(playerid, 1330.292724, 1566.204101, 11.441653, 1330.292724, 1566.204101, 11.441653, 1000);
            InterpolateCameraLookAt(playerid, 1334.468139, 1568.908325, 10.938600, 1334.468139, 1568.908325, 10.938600, 1000);
        }
        else if(class >= 5)
        {
            InterpolateCameraPos(playerid, 1324.793701, 1565.077514, 11.338315, 1324.793701, 1565.077514, 11.338315, 2000);
            InterpolateCameraLookAt(playerid, 1321.078002, 1568.421386, 11.225045, 1321.078002, 1568.421386, 11.225045, 2000);
        }
    }
    else if(bizId >= 87 && bizId <= 89) // Авиасалоны
    {
        InterpolateCameraPos(playerid, 1564.415893, 1597.437255, 11.052239, 1564.415893, 1597.437255, 11.052239, 1000);
        InterpolateCameraLookAt(playerid, 1561.107910, 1593.689208, 11.149888, 1561.107910, 1593.689208, 11.149888, 1000);
    }
    else if(bizId == 90) // Салон Катеров SF
    {
        InterpolateCameraPos(playerid, -1445.834228, 752.435607, 1.804146, -1445.834228, 752.435607, 1.804146, 1000);
        InterpolateCameraLookAt(playerid, -1449.700805, 749.277587, 1.526945, -1449.700805, 749.277587, 1.526945, 1000);
    }
    else if(bizId == 91) // Салон Катеров LS
    {
        InterpolateCameraPos(playerid, 2620.168945, -2300.133300, 1.827390, 2620.168945, -2300.133300, 1.827390, 1000);
        InterpolateCameraLookAt(playerid, 2623.240234, -2304.076416, 1.960187, 2623.240234, -2304.076416, 1.960187, 1000);
    }
    else if(bizId == 92) // Салоны Катеров
    {
        InterpolateCameraPos(playerid, 2401.330078, 514.935241, 2.140674, 2401.330078, 514.935241, 2.140674, 1000);
        InterpolateCameraLookAt(playerid, 2398.289550, 518.904052, 2.082082, 2398.289550, 518.904052, 2.082082, 1000);
    }
    return 1;
}

stock GetPlayerVehicleShopPos(playerid, bizId, &Float:x, &Float:y, &Float:z, &Float:a, &world, &interior)
{
    if(bizId >= 77 && bizId <= 81 || bizId >= 82 && bizId <= 86) // Автосалоны и Мотосалоны
    {
        world = playerid + 1;
        interior = 191;
        x = 1325.2312, y = 1563.8182, z = 10.8662;
        a = 302.9293;
    }
    else if(bizId >= 87 && bizId <= 89) // Авиасалоны
    {
        world = playerid + 1;
        interior = 190;
        x = 1573.1488, y = 1603.1798, z = 10.8403;
        a = 132.9289;
    }
    else if(bizId >= 90 && bizId <= 92) // Салоны Катеров
    {
        world = playerid + 1;
        interior = 0;
        if(bizId == 90) x = 2603.0642, y = -2323.0300, z = 1.8984, a = 270.0;
        else if(bizId == 91) x = -1484.0221, y = 757.7109, z = 7.2423, a = 176.8678;
        if(bizId == 90) x = -1484.0221, y = 757.7109, z = 7.2423, a = 176.8678;
        else if(bizId == 91) x = 2603.0642, y = -2323.0300, z = 1.8984, a = 270.0;
        else if(bizId == 92) x = 2349.5464, y = 522.8445, z = 1.7969, a = 273.1955;
    }
    return 1;
}

stock ClickTextDraw_VehicleShop(playerid, PlayerText:playertextid) // Кликаем по текстдравам
{
    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, Aftextdraw[playerid]);
    if(interval < 500) return 0; // Блокируем, если игрок клацает часто на кнопку

    if(playertextid == VehicleShopDraw[0][playerid]) // Left
    {
        PlayerPlaySound(playerid,17803,0,0,0);
        left_VehicleShop(playerid);
    }
    if(playertextid == VehicleShopDraw[2][playerid]) // Right
    {
        PlayerPlaySound(playerid,17803,0,0,0);
        right_VehicleShop(playerid);
    }
    if(playertextid == VehicleShopDraw[10][playerid]) // Buy
    {
        PlayerPlaySound(playerid,17803,0,0,0);
        buy_VehicleShop(playerid);
    }
    if(playertextid == VehicleShopDraw[13][playerid]) // Test Drive
    {
        PlayerPlaySound(playerid,17803,0,0,0);
        PlayerPlaySound(playerid,30800,0,0,0);
        openTestDrive_VehicleShop(playerid);
    }
    if(playertextid == VehicleShopDraw[15][playerid]) // Цвет транспорта
    {
        PlayerPlaySound(playerid,17803,0,0,0);
        showDialogVehicleShopColor(playerid);
    }
    Aftextdraw[playerid] = current_tick;
    return 1;
}
stock showDialogVehicleShopColor(playerid)
{
    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"Первый Цвет: \t{%s}|||||||||| {555555}[ ID %d ]", VehicleColoursTableHex[VehShopInfo[playerid][vsColor][0]], VehShopInfo[playerid][vsColor][0]), strcat(lines,line);
    format(line,sizeof(line),"\nВторой Цвет: \t{%s}|||||||||| {555555}[ ID %d ]", VehicleColoursTableHex[VehShopInfo[playerid][vsColor][1]], VehShopInfo[playerid][vsColor][1]), strcat(lines,line);
    ShowDialog(playerid,1332,DIALOG_STYLE_TABLIST,"{ff9000}*",lines,"Выбрать","Выход");
    return 1;
}
stock dialogCase_VehicleShop(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == 1332) // Цвет транспорта
    {
        if(listitem < 0 || listitem > 1) return 0;
        if(response)
        {
            DP[4][playerid] = listitem;
			ShowDialog(playerid,1333,DIALOG_STYLE_TABLIST,"{ff9000}*","{cccccc}Свой Цвет {ff9000}>>\n{33ccff}Голубой\n{00cc66}Зелёный\n{ffcc00}Жёлтый\n{ff3333}Красный\n{444444}Чёрный\n{ffffff}Белый","Выбрать","Назад");
        }
    }
    if(dialogid == 1333)
    {
        if(response)
        {
            if(listitem == 0)
            {
			    ShowDialog(playerid,1334,DIALOG_STYLE_INPUT,"{ff9000}*","{cccccc}Введите id цвета транспорта [0 - 255]\n\nПосмотреть, как выглядят цвета транспорта, можно на форуме сервера pears-project.com","Принять","Отмена");
            }

            if(listitem >= 1 && listitem <= 6)
            {
                if(VehShopInfo[playerid][vsVehicleLoad] == false) return 0;

                new color, slot = DP[4][playerid];
                if(listitem == 1) color = 135;
                if(listitem == 2) color = 137;
                if(listitem == 3) color = 6;
                if(listitem == 4) color = 3;
                if(listitem == 5) color = 0;
                if(listitem == 6) color = 1;

                PlayerPlaySound(playerid,1134,0,0,0);
                VehShopInfo[playerid][vsColor][slot] = color;
                changeColor_VehicleShop(playerid, slot);
            }
        }
        else showDialogVehicleShopColor(playerid);
    }
    if(dialogid == 1334)
	{
		if(response)
		{
            if(VehShopInfo[playerid][vsVehicleLoad] == false) return 0;
			new color;
			if(sscanf(inputtext, "i", color)) return ErrorText(playerid, "[ Мысли ]: Я ничего не ввожу");
			if(color > MAX_COLOR_VEHICLE || color < 0) return format(store,sizeof(store),"[ Мысли ]: Не меньше 0 и не больше %d", MAX_COLOR_VEHICLE), ErrorText(playerid, store);

            new slot = DP[4][playerid];
			if(VehShopInfo[playerid][vsColor][slot] == color) return ErrorText(playerid, "[ Мысли ]: Этот цвет уже выбран");
            
            PlayerPlaySound(playerid,1134,0,0,0);
            VehShopInfo[playerid][vsColor][slot] = color;
            changeColor_VehicleShop(playerid, slot);
		}
		else showDialogVehicleShopColor(playerid);
	}
    if(dialogid == 1341)
	{
        if(response)
		{
            new freeSlot = GetPlayerFreeVehSlot(playerid);
            if(freeSlot == -1) return ErrorMessage(playerid, "{FF6347}У вас нет свободного слота для транспорта\n\n{cccccc}Вы можете приобрести до 20 слотов {ffcc00}[ Y >> Donate ]");

            new bizId = TP[0][playerid];
            new productId = TP[1][playerid];
            new modelId = BizzInfo[bizId][bProduct][productId], price = BizzInfo[bizId][bPrice][productId];

            if(BizzInfo[bizId][bItem][productId] <= 0) return ErrorMessage(playerid, "{FF6347}Нет в наличии\n\n{cccccc}Вы можете отправиться в другой автосалон или в центр обмена [ Y >> GPS >> Услуги >> Центр Обмена ]");
            if(modelId == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Слот пустой или транспорт не загрузился");
            if(oGetPlayerMoney(playerid) < price) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");

            BizzInfo[bizId][bItem][productId] -= 1;
            BizzInfo[bizId][bUpdate] = 1;

            oGivePlayerMoney(playerid, -price);
            format(store,sizeof(store),"{0088ff}Поздравляем! Вы купили %s {ffcc66}[ Y >> Транспорт или /car ]", vehName[modelId]);
            SendClientMessage(playerid, COLOR_GREY, store);
            format(store,sizeof(store),"{99ff66}Поздравляем!\n{cccccc}Вы купили {ff9000}%s {cccccc}за {99ff66}%d$ {cccccc}[%s]\n\nУправление транспортом: {444444}[ Y >> Транспорт или /car ]", vehName[modelId], price, get_k(price));
            SuccessMessage(playerid, store);

            new posId;
            if(bizId >= 90 && bizId <= 92) posId = random(4);
            else posId = random(7);

            new Float:pos[4];
            GetCoordBuyVehicle(bizId, posId, pos[0], pos[1], pos[2], pos[3]);
            GiveCar(playerid, freeSlot, modelId, pos[0], pos[1], pos[2], pos[3],0, VehShopInfo[playerid][vsColor][0], VehShopInfo[playerid][vsColor][1]);

            CarLog("buycar", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], modelId, vehSumma[modelId], "");
            if(PlayerInfo[playerid][pAchieve][12] == 0) AchievePlayer(playerid, 12, 1);
        }
    }
    return 1;
}
stock destroyDraw_VehicleShop(playerid) // Удаляем текстдравы
{
    if(VehShopInfo[playerid][vsTextDrawLoad] == false) return 0; // Если текстдравы не созданы, возвращаем 0

    for(new i = 0; i < MAX_DRAW_VEHICLESHOP; i++)
    {
        PlayerTextDrawHide(playerid, VehicleShopDraw[i][playerid]);
        PlayerTextDrawDestroy(playerid, VehicleShopDraw[i][playerid]);
    }

    VehShopInfo[playerid][vsTextDrawLoad] = false;
    return 1;
}
stock DynamicPickupVehiceShop()
{
    for(new i = 0; i < sizeof(BuyCarPos); i++)
    {
        if(i <= 4) 
        {
            CreateDynamicPickup(2485, 1, BuyCarPos[i][bcar_X],BuyCarPos[i][bcar_Y],BuyCarPos[i][bcar_Z], BuyCarPos[i][bcar_World], BuyCarPos[i][bcar_Int]);
            CreateDynamic3DTextLabel("{ff9000}Автосалон\n{444444}[ ALT ]",-1,BuyCarPos[i][bcar_X],BuyCarPos[i][bcar_Y],BuyCarPos[i][bcar_Z],7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,BuyCarPos[i][bcar_World], BuyCarPos[i][bcar_Int]);
        }
        else if(i >= 5 && i <= 9) 
        {
            CreateDynamicPickup(2485, 1, BuyCarPos[i][bcar_X],BuyCarPos[i][bcar_Y],BuyCarPos[i][bcar_Z], BuyCarPos[i][bcar_World], BuyCarPos[i][bcar_Int]);
            CreateDynamic3DTextLabel("{ff9000}Мотосалон\n{444444}[ ALT ]",-1,BuyCarPos[i][bcar_X],BuyCarPos[i][bcar_Y],BuyCarPos[i][bcar_Z],7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,BuyCarPos[i][bcar_World], BuyCarPos[i][bcar_Int]);
        }
        else if(i >= 10 && i <= 12) 
        {
            CreateDynamicPickup(2511, 1, BuyCarPos[i][bcar_X],BuyCarPos[i][bcar_Y],BuyCarPos[i][bcar_Z], BuyCarPos[i][bcar_World], BuyCarPos[i][bcar_Int]);
            CreateDynamic3DTextLabel("{ff9000}Авиасалон\n{444444}[ ALT ]",-1,BuyCarPos[i][bcar_X],BuyCarPos[i][bcar_Y],BuyCarPos[i][bcar_Z],7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,BuyCarPos[i][bcar_World], BuyCarPos[i][bcar_Int]);
        }
        else if(i >= 13) 
        {
            CreateDynamicPickup(2484, 1, BuyCarPos[i][bcar_X],BuyCarPos[i][bcar_Y],BuyCarPos[i][bcar_Z], BuyCarPos[i][bcar_World], BuyCarPos[i][bcar_Int]);
            CreateDynamic3DTextLabel("{ff9000}Салон Катеров\n{444444}[ ALT ]",-1,BuyCarPos[i][bcar_X],BuyCarPos[i][bcar_Y],BuyCarPos[i][bcar_Z],7.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,BuyCarPos[i][bcar_World], BuyCarPos[i][bcar_Int]);
        }
    }
	return 1;
}
stock createDraw_VehicleShop(playerid) // Создаём текстдравы
{
    if(VehShopInfo[playerid][vsTextDrawLoad] == true) return 0; // Если эти текстдравы уже созданы, возвращаем 0

    VehicleShopDraw[0][playerid] = CreatePlayerTextDraw(playerid, 299.333282, 348.444519, "ld_beat:chit"); // кнопка влево
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[0][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, VehicleShopDraw[0][playerid], 60.333343, 74.666694);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[0][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[0][playerid], 80);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[0][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[0][playerid], 0);
    PlayerTextDrawFont(playerid, VehicleShopDraw[0][playerid], 4);
    PlayerTextDrawSetSelectable(playerid, VehicleShopDraw[0][playerid], true);
    PlayerTextDrawSetPreviewModel(playerid, VehicleShopDraw[0][playerid], 19134);
    PlayerTextDrawSetPreviewRot(playerid, VehicleShopDraw[0][playerid], 0.000000, 90.000000, 90.000000, 1.000000);

    VehicleShopDraw[1][playerid] = CreatePlayerTextDraw(playerid, 307.333312, 362.962829, "LD_SPAC:white"); // кнопка влево (иконка)
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[1][playerid], 0.011333, 0.319407);
    PlayerTextDrawTextSize(playerid, VehicleShopDraw[1][playerid], 39.333309, 45.629642);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[1][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[1][playerid], 110);
    PlayerTextDrawUseBox(playerid, VehicleShopDraw[1][playerid], true);
    PlayerTextDrawBoxColor(playerid, VehicleShopDraw[1][playerid], 0);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[1][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[1][playerid], 0);
    PlayerTextDrawFont(playerid, VehicleShopDraw[1][playerid], 5);
    PlayerTextDrawSetPreviewModel(playerid, VehicleShopDraw[1][playerid], 19134);
    PlayerTextDrawSetPreviewRot(playerid, VehicleShopDraw[1][playerid], 0.000000, 90.000000, 90.000000, 1.000000);
    PlayerTextDrawBackgroundColor(playerid, VehicleShopDraw[1][playerid], 0);

    VehicleShopDraw[2][playerid] = CreatePlayerTextDraw(playerid, 374.666625, 348.444519, "ld_beat:chit"); // кнопка вправо
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[2][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, VehicleShopDraw[2][playerid], 60.333343, 74.666694);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[2][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[2][playerid], 80);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[2][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[2][playerid], 0);
    PlayerTextDrawFont(playerid, VehicleShopDraw[2][playerid], 4);
    PlayerTextDrawSetSelectable(playerid, VehicleShopDraw[2][playerid], true);
    PlayerTextDrawSetPreviewModel(playerid, VehicleShopDraw[2][playerid], 19134);
    PlayerTextDrawSetPreviewRot(playerid, VehicleShopDraw[2][playerid], 0.000000, 90.000000, 90.000000, 1.000000);

    VehicleShopDraw[3][playerid] = CreatePlayerTextDraw(playerid, 387.666717, 362.962829, "LD_SPAC:white"); // кнопка вправо (иконка)
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[3][playerid], 0.011333, 0.319407);
    PlayerTextDrawTextSize(playerid, VehicleShopDraw[3][playerid], 39.333309, 45.629642);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[3][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[3][playerid], 110);
    PlayerTextDrawUseBox(playerid, VehicleShopDraw[3][playerid], true);
    PlayerTextDrawBoxColor(playerid, VehicleShopDraw[3][playerid], 0);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[3][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[3][playerid], 0);
    PlayerTextDrawFont(playerid, VehicleShopDraw[3][playerid], 5);
    PlayerTextDrawSetPreviewModel(playerid, VehicleShopDraw[3][playerid], 19134);
    PlayerTextDrawSetPreviewRot(playerid, VehicleShopDraw[3][playerid], 0.000000, -90.000000, 90.000000, 1.000000);
    PlayerTextDrawBackgroundColor(playerid, VehicleShopDraw[3][playerid], 0);

    VehicleShopDraw[4][playerid] = CreatePlayerTextDraw(playerid, 79.333274, 306.963226, "LD_SPAC:white"); // Фон меню
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[4][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, VehicleShopDraw[4][playerid], 116.333374, 46.459289);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[4][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[4][playerid], 168429055);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[4][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[4][playerid], 0);
    PlayerTextDrawFont(playerid, VehicleShopDraw[4][playerid], 4);

    VehicleShopDraw[5][playerid] = CreatePlayerTextDraw(playerid, 55.333297, 296.318463, "ld_beat:chit"); // Левое скругление меню
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[5][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, VehicleShopDraw[5][playerid], 50.333347, 68.288903);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[5][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[5][playerid], 168429055);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[5][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[5][playerid], 0);
    PlayerTextDrawFont(playerid, VehicleShopDraw[5][playerid], 4);
    PlayerTextDrawSetPreviewModel(playerid, VehicleShopDraw[5][playerid], 19134);
    PlayerTextDrawSetPreviewRot(playerid, VehicleShopDraw[5][playerid], 0.000000, 90.000000, 90.000000, 1.000000);

    VehicleShopDraw[6][playerid] = CreatePlayerTextDraw(playerid, 170.999816, 296.318463, "ld_beat:chit"); // Правое скругление меню
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[6][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, VehicleShopDraw[6][playerid], 50.333347, 68.288903);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[6][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[6][playerid], 168429055);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[6][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[6][playerid], 0);
    PlayerTextDrawFont(playerid, VehicleShopDraw[6][playerid], 4);
    PlayerTextDrawSetPreviewModel(playerid, VehicleShopDraw[6][playerid], 19134);
    PlayerTextDrawSetPreviewRot(playerid, VehicleShopDraw[6][playerid], 0.000000, 90.000000, 90.000000, 1.000000);

    VehicleShopDraw[7][playerid] = CreatePlayerTextDraw(playerid, 85.000015, 314.014831, "Bloodring_Banger"); // Название
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[7][playerid], 0.302666, 1.309629);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[7][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[7][playerid], -1061109505);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[7][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[7][playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, VehicleShopDraw[7][playerid], 51);
    PlayerTextDrawFont(playerid, VehicleShopDraw[7][playerid], 1);
    PlayerTextDrawSetProportional(playerid, VehicleShopDraw[7][playerid], 1);

    VehicleShopDraw[8][playerid] = CreatePlayerTextDraw(playerid, 85.000007, 331.363067, "100000000$"); // Ценник
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[8][playerid], 0.302666, 1.309629);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[8][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[8][playerid], 1353989375);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[8][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[8][playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, VehicleShopDraw[8][playerid], 51);
    PlayerTextDrawFont(playerid, VehicleShopDraw[8][playerid], 1);
    PlayerTextDrawSetProportional(playerid, VehicleShopDraw[8][playerid], 1);

    VehicleShopDraw[9][playerid] = CreatePlayerTextDraw(playerid, 196.999984, 293.859313, "HEЏ ‹ HA‡…Ќ……!"); // Нет в наличии
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[9][playerid], 0.207999, 0.898963);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[9][playerid], 3);
    PlayerTextDrawColor(playerid, VehicleShopDraw[9][playerid], -282906369);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[9][playerid], 1);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[9][playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, VehicleShopDraw[9][playerid], 51);
    PlayerTextDrawFont(playerid, VehicleShopDraw[9][playerid], 1);
    PlayerTextDrawSetProportional(playerid, VehicleShopDraw[9][playerid], 1);

    VehicleShopDraw[10][playerid] = CreatePlayerTextDraw(playerid, 168.333099, 357.496124, "ld_beat:chit"); // Фон и сама кнопка купить
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[10][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, VehicleShopDraw[10][playerid], 52.999984, 64.711105);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[10][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[10][playerid], 168429055);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[10][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[10][playerid], 0);
    PlayerTextDrawFont(playerid, VehicleShopDraw[10][playerid], 4);
    PlayerTextDrawSetSelectable(playerid, VehicleShopDraw[10][playerid], true);
    PlayerTextDrawSetPreviewModel(playerid, VehicleShopDraw[10][playerid], 19134);
    PlayerTextDrawSetPreviewRot(playerid, VehicleShopDraw[10][playerid], 0.000000, 90.000000, 90.000000, 1.000000);

    VehicleShopDraw[11][playerid] = CreatePlayerTextDraw(playerid, 170.333175, 360.570312, "ld_beat:chit"); // Типо кнопка купить
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[11][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, VehicleShopDraw[11][playerid], 48.666667, 58.074077);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[11][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[11][playerid], 916677887);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[11][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[11][playerid], 0);
    PlayerTextDrawFont(playerid, VehicleShopDraw[11][playerid], 4);
    PlayerTextDrawSetPreviewModel(playerid, VehicleShopDraw[11][playerid], 19134);
    PlayerTextDrawSetPreviewRot(playerid, VehicleShopDraw[11][playerid], 0.000000, 90.000000, 90.000000, 1.000000);

    VehicleShopDraw[12][playerid] = CreatePlayerTextDraw(playerid, 194.333297, 383.874176, "BUY"); // Надпись купить
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[12][playerid], 0.252666, 1.122964);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[12][playerid], 2);
    PlayerTextDrawColor(playerid, VehicleShopDraw[12][playerid], 255796479);
    PlayerTextDrawUseBox(playerid, VehicleShopDraw[12][playerid], true);
    PlayerTextDrawBoxColor(playerid, VehicleShopDraw[12][playerid], 0);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[12][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[12][playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, VehicleShopDraw[12][playerid], 51);
    PlayerTextDrawFont(playerid, VehicleShopDraw[12][playerid], 3);
    PlayerTextDrawSetProportional(playerid, VehicleShopDraw[12][playerid], 1);

    VehicleShopDraw[13][playerid] = CreatePlayerTextDraw(playerid, 52.666648, 246.155670, "ld_beat:chit"); // Тест драйв
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[13][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, VehicleShopDraw[13][playerid], 50.666675, 60.977802);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[13][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[13][playerid], 80);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[13][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[13][playerid], 0);
    PlayerTextDrawFont(playerid, VehicleShopDraw[13][playerid], 4);
    PlayerTextDrawSetSelectable(playerid, VehicleShopDraw[13][playerid], true);
    PlayerTextDrawSetPreviewModel(playerid, VehicleShopDraw[13][playerid], 19134);
    PlayerTextDrawSetPreviewRot(playerid, VehicleShopDraw[13][playerid], 0.000000, 90.000000, 90.000000, 1.000000);

    VehicleShopDraw[14][playerid] = CreatePlayerTextDraw(playerid, 64.666687, 257.185028, "LD_SPAC:white"); // Тест драйв (иконка)
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[14][playerid], 0.009333, 0.149333);
    PlayerTextDrawTextSize(playerid, VehicleShopDraw[14][playerid], 27.999990, 35.259262);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[14][playerid], 1);
    PlayerTextDrawColor(playerid, VehicleShopDraw[14][playerid], 110);
    PlayerTextDrawUseBox(playerid, VehicleShopDraw[14][playerid], true);
    PlayerTextDrawBoxColor(playerid, VehicleShopDraw[14][playerid], 0);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[14][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[14][playerid], 0);
    PlayerTextDrawFont(playerid, VehicleShopDraw[14][playerid], 5);
    PlayerTextDrawSetPreviewModel(playerid, VehicleShopDraw[14][playerid], 2485);
    PlayerTextDrawSetPreviewRot(playerid, VehicleShopDraw[14][playerid], 0.000000, 0.000000, -50.000000, 1.000000);
    PlayerTextDrawBackgroundColor(playerid, VehicleShopDraw[14][playerid], 0);

    VehicleShopDraw[15][playerid] = CreatePlayerTextDraw(playerid, 179.999847, 312.036651, "ld_beat:chit"); // Кнопка цвет (она будет менять цвет в зависимости от цвета авто в меню выбора)
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[15][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, VehicleShopDraw[15][playerid], 22.999996, 26.962993);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[15][playerid], 1);
    new hexColor[11];
    format(hexColor,sizeof(hexColor),"%sFF", VehicleColoursTableHex[VehShopInfo[playerid][vsColor][0]]);
    PlayerTextDrawColor(playerid, VehicleShopDraw[15][playerid], HexToInt(hexColor));
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[15][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[15][playerid], 0);
    PlayerTextDrawFont(playerid, VehicleShopDraw[15][playerid], 4);
    PlayerTextDrawSetSelectable(playerid, VehicleShopDraw[15][playerid], true);

    VehicleShopDraw[16][playerid] = CreatePlayerTextDraw(playerid, 191.333358, 338.244262, "COLOR"); // Надпись Цвет
    PlayerTextDrawLetterSize(playerid, VehicleShopDraw[16][playerid], 0.131333, 0.633481);
    PlayerTextDrawAlignment(playerid, VehicleShopDraw[16][playerid], 2);
    PlayerTextDrawColor(playerid, VehicleShopDraw[16][playerid], 2021161110);
    PlayerTextDrawSetShadow(playerid, VehicleShopDraw[16][playerid], 0);
    PlayerTextDrawSetOutline(playerid, VehicleShopDraw[16][playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, VehicleShopDraw[16][playerid], 51);
    PlayerTextDrawFont(playerid, VehicleShopDraw[16][playerid], 1);
    PlayerTextDrawSetProportional(playerid, VehicleShopDraw[16][playerid], 1);

    VehShopInfo[playerid][vsTextDrawLoad] = true;
    return 1;
}
stock ForBizVehicleClassAndType(b, vehicleType, vehicleClass) // Расчитываем бизнесы салона, по типу и классу транспорта
{
	// Автосалоны
	if(b == 77 && vehicleType == 1 && vehicleClass == 1) return 1; // Premium Class (77 Biz)
	else if(b == 78 && vehicleType == 1 && vehicleClass == 2) return 1; // Middle Class (78 Biz)
	else if(b == 79 && vehicleType == 1 && vehicleClass == 3) return 1; // Economy Class (79 Biz)
	else if(b == 80 && vehicleType == 1 && vehicleClass == 4) return 1; // Off-Road Class (80 Biz)
	else if(b == 81 && vehicleType == 1 && vehicleClass == 5) return 1; // Special Class (81 Biz)

    // Мотосалоны
    else if(b >= 82 && b <= 86 && vehicleType == 2 && vehicleClass <= 5) return 1; // Moto

    // Авиасалоны
    else if(b >= 87 && b <= 89 && (vehicleType == 4 || vehicleType == 5) && vehicleClass <= 5) return 1; // Helicopter and Plane

    // Салоны Катеров
    else if(b >= 90 && b <= 92 && vehicleType == 3 && vehicleClass <= 5) return 1; // Boat
	return 0;
}
stock GetVehicleType(model) // Получаем тип транспорта
{
    new type;

    // Автомобили (Требуются водительские права) Car
    if(model == 400 || model == 401 || model == 402 || model == 403 || model == 404 || model == 405
    || model == 406 || model == 407 || model == 408 || model == 409 || model == 410 || model == 411 || model == 412
    || model == 413 || model == 414 || model == 415 || model == 416 || model == 418 || model == 419 || model == 420
    || model == 421 || model == 422 || model == 423 || model == 424 || model == 426 || model == 427 || model == 428
    || model == 429 || model == 431 || model == 432 || model == 433 || model == 434 || model == 436 || model == 437
    || model == 438 || model == 439 || model == 440 || model == 442 || model == 443 || model == 444 || model == 445
    || model == 451 || model == 455 || model == 456 || model == 457 || model == 458 || model == 459 || model == 466 || model == 467
    || model == 470 || model == 474 || model == 475 || model == 477 || model == 478 || model == 479
    || model == 480 || model == 482 || model == 483 || model == 485 || model == 486 || model == 489 || model == 490 || model == 491
    || model == 492 || model == 494 || model == 495 || model == 496 || model == 498 || model == 499 || model == 500
    || model == 502 || model == 503 || model == 504 || model == 505 || model == 506 || model == 507 || model == 508
    || model == 514 || model == 515 || model == 516 || model == 517 || model == 518 || model == 524 || model == 525
    || model == 526 || model == 527 || model == 528 || model == 529 || model == 530 || model == 531 || model == 532 || model == 533 || model == 534
    || model == 535 || model == 536 || model == 540 || model == 541 || model == 542 || model == 543
    || model == 544 || model == 545 || model == 546 || model == 547 || model == 549 || model == 550 || model == 551
    || model == 552 || model == 554 || model == 555 || model == 556 || model == 557 || model == 558 || model == 559
    || model == 560 || model == 561 || model == 562 || model == 565 || model == 566 || model == 567 || model == 568
    || model == 572 || model == 573 || model == 574 || model == 575 || model == 576 || model == 578 || model == 579
    || model == 580 || model == 582 || model == 583 || model == 585 || model == 587 || model == 588 || model == 589
    || model == 596 || model == 597 || model == 598 || model == 599 || model == 600 || model == 601 || model == 602
    || model == 603 || model == 604 || model == 605 || model == 609) type = 1;

    // Мототранспорт (Требуется лицензия на мото транспорт) Moto
    else if(model == 448 || model == 461 || model == 462 || model == 463 || model == 468 || model == 471 || model == 521
    || model == 522 || model == 523 || model == 571 || model == 581 || model == 586) type = 2;

    // Водный Транспорт (Требуется лицензия на катер) Boat
    else if(model == 430 || model == 446 || model == 452 || model == 453 || model == 454 || model == 472
    || model == 473 || model == 484 || model == 493 || model == 539 || model == 595) type = 3;

    // Вертолёты (Требуется лицензия на вертолёт) Helicopter
    else if(model == 417 || model == 425 || model == 447 || model == 469 || model == 487 || model == 488 || model == 497 
    || model == 548 || model == 563) type = 4;

    // Самолёты (Требуется лицензия на самолёт) Plane
    else if(model == 460 || model == 476 || model == 511 || model == 512 || model == 513 || model == 519 || model == 520 
    || model == 553 || model == 577 || model == 592 || model == 593) type = 5;

    // Велотранспорт (Лицензия не требуется) Bicycle
    else if(model == 481 || model == 509 || model == 510) type = 6;
    return type;
}
stock GetVehicleClass(m)
{
    new class;

    // Premium Class (1) - Премиум
    if(m == 402 || m == 409 || m == 411 || m == 415 || m == 429 || m == 446 || m == 451 || m == 454 || m == 477 || m == 493 
    || m == 494 || m == 502 || m == 503 || m == 506 || m == 519 || m == 521 || m == 522 || m == 535 || m == 541 || m == 559
    || m == 560 || m == 562 || m == 565 || m == 580 || m == 586) class = 1;

    // Middle Class (2) - Средний
    else if(m == 401 || m == 405 || m == 418 || m == 419 || m == 421 || m == 426 || m == 439 || m == 445 || m == 452 || m == 460
    || m == 461 || m == 463 || m == 468 || m == 469 || m == 471 || m == 480 || m == 484 || m == 487 || m == 491 || m == 496
    || m == 507 || m == 511 || m == 516 || m == 533 || m == 534 || m == 550 || m == 551 || m == 555 || m == 558 || m == 561
    || m == 581 || m == 585 || m == 587 || m == 589 || m == 602 || m == 603) class = 2;

    // Economy Class (3) - Бомж
    else if(m == 404 || m == 410 || m == 412 || m == 436 || m == 453 || m == 458 || m == 462 || m == 466 || m == 467 || m == 472
    || m == 474 || m == 475 || m == 479 || m == 492 || m == 512 || m == 513 || m == 517 || m == 518 || m == 526 || m == 527
    || m == 529 || m == 536 || m == 540 || m == 542 || m == 546 || m == 547 || m == 549 || m == 553 || m == 566 || m == 567
    || m == 575 || m == 576 || m == 593 || m == 595 || m == 600) class = 3;

    // Off-Road Class (4) - Внедорожник
    else if(m == 400 || m == 422 || m == 489 || m == 495 || m == 500 || m == 543 || m == 554 || m == 579) class = 4;

    // Special Class (5) - Грузовая и Спец Техника
    else if(m == 403 || m == 413 || m == 414 || m == 417 || m == 440 || m == 455 || m == 456
    || m == 459 || m == 478 || m == 482 || m == 498 || m == 499 || m == 508 || m == 514 || m == 515 || m == 578) class = 5;

    // Unique Class (6) - Уникальный Транспорт
    else if(m == 423 || m == 424 || m == 431 || m == 434 || m == 437 || m == 442 || m == 443 || m == 444 || m == 457 || m == 473 
    || m == 476 || m == 481 || m == 483
    || m == 504 || m == 509 || m == 510 || m == 530 || m == 531 || m == 532 || m == 545 || m == 556 || m == 557 || m == 571 
    || m == 573 || m == 577 || m == 588 || m == 592) class = 6;

    // Goverment Class (7) - Государственный Транспорт
    else if(m == 406 || m == 407 || m == 408 || m == 416 || m == 420 || m == 425 || m == 427 || m == 428 || m == 430 || m == 432 
    || m == 438 || m == 447 || m == 448 || m == 470 || m == 485 || m == 486 || m == 488 || m == 490 || m == 497 || m == 520
    || m == 523 || m == 524 || m == 525 || m == 528 || m == 539 || m == 544 || m == 548 || m == 552 || m == 563 || m == 572 
    || m == 574 || m == 582 || m == 583 || m == 596 || m == 597 || m == 598 || m == 599 || m == 601) class = 7;

    else class = 0; // 0 Класс недоступен для продажи (неизвестный транспорт)
    return class;
}

static Float: BuyCar77[7][4] = {
{-1630.7909,1289.8961,6.7233,133.9130},
{-1634.4467,1293.3676,6.7226,135.1459},
{-1638.0880,1296.9481,6.7203,134.9994},
{-1641.8350,1300.3325,6.7160,134.3995},
{-1645.1599,1304.0277,6.7132,134.1048},
{-1648.7629,1307.6307,6.7155,133.6979},
{-1655.9745,1314.6727,6.7232,134.3809}
};
static Float: BuyCar78[7][4] = {
{532.0536,-1280.5724,16.9271,217.1556},
{536.1943,-1277.5929,16.9260,217.2419},
{540.1298,-1274.5122,16.9266,216.9094},
{544.0961,-1271.4668,16.9310,217.2381},
{548.2017,-1268.6083,16.9261,217.0673},
{552.3049,-1265.5759,16.9260,217.4240},
{527.5638,-1283.0762,16.9273,217.3314}
};
static Float: BuyCar79[7][4] = {
{1062.1146,-1749.0371,13.1348,270.4561},
{1062.5253,-1752.0280,13.1278,269.9294},
{1062.5251,-1754.9524,13.1156,270.3059},
{1062.4055,-1757.9939,13.1012,270.2939},
{1062.4971,-1760.8866,13.0875,270.4417},
{1062.4679,-1763.8151,13.0759,270.2054},
{1062.5671,-1766.7223,13.0639,270.0496}
};
static Float: BuyCar80[7][4] = {
{-1987.6846,275.6537,34.8600,268.7078},
{-1988.0031,270.6844,34.8609,269.0689},
{-1987.7682,265.6169,34.8637,269.4496},
{-1987.9283,260.6807,34.8635,269.9476},
{-1988.2604,255.7881,34.8561,270.1007},
{-1989.2034,250.7520,34.8551,268.6367},
{-1988.3507,245.7601,34.8561,269.8934}
};
static Float: BuyCar81[7][4] = {
{2143.9771,1395.8309,11.4183,179.1647},
{2135.9590,1395.8420,11.4251,180.2891},
{2125.3210,1395.8994,11.4214,181.2749},
{2117.7529,1396.7042,11.4230,179.1614},
{2100.4199,1410.6488,11.4261,358.8225},
{2109.0889,1410.5594,11.4263,359.4589},
{2124.3748,1410.2053,11.4228,0.1071}
};
static Float: BuyCar82[7][4] = {
{1132.0004,-932.6567,42.5154,1.4432},
{1127.6670,-932.9992,42.5332,3.7311},
{1123.0734,-933.2482,42.5812,2.5520},
{1116.5576,-934.0265,42.6499,358.6103},
{1110.3676,-934.1944,42.7139,358.8516},
{1104.8970,-934.6085,42.6952,0.9331},
{1099.7186,-935.0287,42.6253,4.2258}
};
static Float: BuyCar83[7][4] = {
{403.7985,-1305.8121,14.4329,211.8875},
{399.7332,-1307.5780,14.4045,205.1489},
{398.3560,-1312.4043,14.3829,299.3748},
{400.0142,-1315.1615,14.3839,297.7711},
{401.9518,-1318.2799,14.3857,298.5741},
{404.1087,-1322.2328,14.3862,298.5989},
{406.0754,-1326.3326,14.3854,299.4590}
};
static Float: BuyCar84[7][4] = {
{-1929.2098,584.6361,34.6552,181.2564},
{-1932.4238,585.0105,34.6480,181.3788},
{-1935.2765,584.6690,34.6512,179.5882},
{-1938.3234,584.7221,34.6480,179.9484},
{-1944.3535,584.7836,34.6534,180.4886},
{-1947.3428,584.2746,34.6610,179.5666},
{-1950.3081,585.1459,34.6457,178.7887}
};
static Float: BuyCar85[7][4] = {
{2102.5063,2098.9026,10.3405,91.1212},
{2102.6211,2095.5642,10.3403,89.2317},
{2102.6328,2092.2688,10.3405,90.4166},
{2102.4646,2089.0681,10.3406,91.9509},
{2102.8884,2085.7156,10.3406,90.3522},
{2102.5286,2082.4377,10.3404,89.4777},
{2102.6335,2075.8909,10.3405,90.3599}
};
static Float: BuyCar86[7][4] = {
{2007.6624,2444.8066,10.3402,91.9059},
{2007.6847,2449.8921,10.3405,90.4368},
{2007.7234,2455.0188,10.3404,90.6159},
{2007.8347,2460.0581,10.3403,89.5767},
{2007.8131,2465.0256,10.3405,89.6958},
{2007.6920,2470.0945,10.3403,89.9302},
{2007.7465,2475.1460,10.3406,90.3066}
};
static Float: BuyCar87[7][4] = { // LS
{1857.4624,-2458.1062,14.6,179.1131},
{1814.8027,-2457.9297,14.6,179.0126},
{1777.9696,-2459.0693,14.6,180.4165},
{1727.0154,-2453.6843,14.6,178.2594},
{1687.1891,-2459.4014,14.6,179.0270},
{1642.0822,-2457.8945,14.6,180.6221},
{1548.5597,-2454.3894,14.6,177.7081}
};
static Float: BuyCar88[7][4] = { // SF
{-1377.9741, -222.2255, 16.5110, -45.0000},
{-1337.9648, -264.0585, 16.5110, -45.0000},
{-1298.5092, -248.9697, 16.5110, -45.0000},
{-1359.8944, -184.7916, 16.5110, -45.0000},
{-1344.5437, -141.3732, 16.5110, -45.0000},
{-1251.8223, -234.6633, 16.5110, -45.0000},
{-1316.9381, -201.5269, 16.5110, -45.0000}
};
static Float: BuyCar89[7][4] = { // LV
{1590.6488, 1321.9851, 13.6479, 90.0000},
{1568.5382, 1293.3616, 13.6479, 90.0000},
{1551.7075, 1254.2162, 13.6479, 90.0000},
{1521.1948, 1173.8835, 13.6479, 0.0000},
{1555.1497, 1339.5554, 13.6479, 90.0000},
{1530.2264, 1296.7860, 13.6479, 90.0000},
{1522.7865, 1360.0215, 13.6479, 90.0000}
};
static Float: BuyCar90[4][4] = { // SF
{-1460.5208,700.4496,1.0,270.0},
{-1459.9456,719.3024,1.0,270.0},
{-1458.9069,729.9988,1.0,270.0},
{-1460.8375,740.2239,1.0,270.0}
};
static Float: BuyCar91[4][4] = { // LS
{2726.8130,-2299.0430,1.0,0.0},
{2715.1313,-2298.6047,1.0,0.0},
{2703.0364,-2299.2717,1.0,0.0},
{2691.0002,-2298.9663,1.0,0.0}
};
static Float: BuyCar92[4][4] = { // LV
{2307.5518,531.0103,1.0,180.0},
{2318.5366,530.5410,1.0,180.0},
{2329.6873,530.6938,1.0,180.0},
{2340.7705,529.8237,1.0,180.0}
};

stock GetCoordBuyVehicle(bizId, posId, &Float:x, &Float:y, &Float:z, &Float:a)
{
    if(bizId == 77) x = BuyCar77[posId][0], y = BuyCar77[posId][1], z = BuyCar77[posId][2], a = BuyCar77[posId][3];
    else if(bizId == 78) x = BuyCar78[posId][0], y = BuyCar78[posId][1], z = BuyCar78[posId][2], a = BuyCar78[posId][3];
    else if(bizId == 79) x = BuyCar79[posId][0], y = BuyCar79[posId][1], z = BuyCar79[posId][2], a = BuyCar79[posId][3];
    else if(bizId == 80) x = BuyCar80[posId][0], y = BuyCar80[posId][1], z = BuyCar80[posId][2], a = BuyCar80[posId][3];
    else if(bizId == 81) x = BuyCar81[posId][0], y = BuyCar81[posId][1], z = BuyCar81[posId][2], a = BuyCar81[posId][3];
    else if(bizId == 82) x = BuyCar82[posId][0], y = BuyCar82[posId][1], z = BuyCar82[posId][2], a = BuyCar82[posId][3];
    else if(bizId == 83) x = BuyCar83[posId][0], y = BuyCar83[posId][1], z = BuyCar83[posId][2], a = BuyCar83[posId][3];
    else if(bizId == 84) x = BuyCar84[posId][0], y = BuyCar84[posId][1], z = BuyCar84[posId][2], a = BuyCar84[posId][3];
    else if(bizId == 85) x = BuyCar85[posId][0], y = BuyCar85[posId][1], z = BuyCar85[posId][2], a = BuyCar85[posId][3];
    else if(bizId == 86) x = BuyCar86[posId][0], y = BuyCar86[posId][1], z = BuyCar86[posId][2], a = BuyCar86[posId][3];
    else if(bizId == 87) x = BuyCar87[posId][0], y = BuyCar87[posId][1], z = BuyCar87[posId][2], a = BuyCar87[posId][3];
    else if(bizId == 88) x = BuyCar88[posId][0], y = BuyCar88[posId][1], z = BuyCar88[posId][2], a = BuyCar88[posId][3];
    else if(bizId == 89) x = BuyCar89[posId][0], y = BuyCar89[posId][1], z = BuyCar89[posId][2], a = BuyCar89[posId][3];
    else if(bizId == 90) x = BuyCar90[posId][0], y = BuyCar90[posId][1], z = BuyCar90[posId][2], a = BuyCar90[posId][3];
    else if(bizId == 91) x = BuyCar91[posId][0], y = BuyCar91[posId][1], z = BuyCar91[posId][2], a = BuyCar91[posId][3];
    else if(bizId == 92) x = BuyCar92[posId][0], y = BuyCar92[posId][1], z = BuyCar92[posId][2], a = BuyCar92[posId][3];
    return 1;
}
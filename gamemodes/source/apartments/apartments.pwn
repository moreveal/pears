#define MAX_APARTMENTS 20 // кол-во доступных квартир
#define MAX_APARTMENTS_CLASS 4 // максимальный класс
#define MAX_APARTMENTS_FLOOR 10 // Кол.во этажей
#define MAX_APARTMENTS_ROOM_IN_FLOOR 4 // Кол.во квартир
#define START_WORLD_APARTMENTS 15000 // Стартовый мир для матиматики
#define MAX_APARTMENTS_TABLE MAX_APARTMENTS*MAX_APARTMENTS_FLOOR*MAX_APARTMENTS_ROOM_IN_FLOOR // Кол.во тумб в квартирах
#define MAX_APARTMENTS_TABLE_SLOTS 20 // кол.во слотов в тумбе

new ApartmentsPickup[MAX_APARTMENTS];
new Text3D:ApartmentsLabel[MAX_APARTMENTS];
new ApartmentsPickupInt[MAX_APARTMENTS*(MAX_APARTMENTS_FLOOR*MAX_APARTMENTS_ROOM_IN_FLOOR+1)];
new Text3D:ApartmentsIntLabel[MAX_APARTMENTS*(MAX_APARTMENTS_FLOOR*MAX_APARTMENTS_ROOM_IN_FLOOR+1)];
new Text3D:ApartmentsElevatorLabel[MAX_APARTMENTS*MAX_APARTMENTS_FLOOR+MAX_APARTMENTS];
new ApartmentsLastPickUp = -1;
new ApartmentsNumber = 0; // Для подсчета номеров квартир и записи в Енум
new ApartmentsLastPickUpTumbler = -1; // В случае удаление необходима перезапись LastPickUp
new ApartmentsMapIcon[MAX_APARTMENTS];
new ApartmentsActorResepshen[MAX_APARTMENTS];
new ApartmentsActorTalk[MAX_APARTMENTS][2];



enum apartmentsEnum
{
    apNewId, // new id
    apId, // ID многоквартирного дома
    apStatus, // Статус(1 - установлена)
    apClass, // Класс
    apFloor, // Количество Этажей
    apPrice, // Госка в виртах
    apPriceGold, // Госка в голде
    apInt, // Инт
    apPickupStart, // первый пикап квартиры
    apPickupEnd, // последний пикап квартиры
    Float:apCoord[3], // координаты входа
    Float:apElevatorCoord[3], // координаты лифта 1 этаж
    Float:apElevatorCoordFloor[3], // координаты лифта этажи
    Float:apHolCoord[3], // координаты Хола
    Float:apRoomCoordOne[3], // координаты входа в квартиру
    Float:apRoomCoordTwo[3], // координаты входа в квартиру
    Float:apRoomCoordThree[3], // координаты входа в квартиру
    Float:apRoomCoordFour[3], // координаты входа в квартиру
    Float:apRoomCoordOneExit[3], // координаты выхода из квартиру
    Float:apRoomCoordTwoExit[3], // координаты выхода из квартиру
    Float:apRoomCoordThreeExit[3], // координаты выхода из квартиру
    Float:apRoomCoordFourExit[3], // координаты выхода из квартиру
    Float:apRoomCoordExclusiveExit[3], // координаты выхода из квартиру
    apWorldDefineEntrance, // Подъезд
}
new Apartments[MAX_APARTMENTS][apartmentsEnum];

new ApartmentsClass[][] = // Название квартирного дома
{
    "Обычный","Элитный(Exculsiv)","Элитный","None","None"
};

enum apartmentsRoomEnum
{
    aprID, // ID квартиры по newid
    aprApartmentsID, // ID квартирного дома
    aprStatus, // Статус(1 - куплена)
    aprSellOwn, // Ценник продажи от самого игрока
    aprOwn, // Владелец
    aprOwnName[24], // Никнейм Владельца
    aprLock, // Статус двери (0 окрыто, 1 закрыто)
    aprWorld, // Мир
    aprTaxes, // Налог
    aprTaxday, // Дни
    aprArest, // 1 - Арестована
    aprInvent[MAX_APARTMENTS_TABLE_SLOTS],
	aprInv[MAX_APARTMENTS_TABLE_SLOTS],
	aprInvPara[MAX_APARTMENTS_TABLE_SLOTS],
	aprInvQara[MAX_APARTMENTS_TABLE_SLOTS],
	aprInvType[MAX_APARTMENTS_TABLE_SLOTS],
	aprInvPack[MAX_APARTMENTS_TABLE_SLOTS]
}
new ApartmentsRoom[MAX_APARTMENTS*MAX_APARTMENTS_FLOOR*MAX_APARTMENTS_ROOM_IN_FLOOR][apartmentsRoomEnum];


CMD:createapartments(playerid,const params[])
{
    new class,floor;
    if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "ii",class,floor)) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Создать Многоквартирный Дом [ /createapartments класс кол.во этажей ]");
    class--;
    if(floor > MAX_APARTMENTS_FLOOR || floor < 2) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Максимальное количество этажей: %d. Минимальное: 3", MAX_APARTMENTS_FLOOR);
    if(class > MAX_APARTMENTS_CLASS || class < 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Максимальное класс Квартирного Дома: %d", MAX_APARTMENTS_CLASS);
    new result = -1;
    for(new i; i < MAX_APARTMENTS; i++)
    {
        if(Apartments[i][apStatus] > 0) continue;
        else 
        {
            result = i;
            break;
        }
    }
    if(result == -1) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: В данный момент все слоты под Квартирные Дома заняты");
    CreateApartments(playerid,result,class,floor);
    return 1;
}

CMD:firstloadapartmentsroom(playerid)
{
    if(PlayerInfo[playerid][pSoska] >= 23 && (strfind(PlayerInfo[playerid][pName],"Elon_Musk",true) != (-1) || strfind(PlayerInfo[playerid][pName],"Cardinale_Reveal",true) != (-1)) )
	{
        for(new i; i < MAX_APARTMENTS*MAX_APARTMENTS_ROOM_IN_FLOOR*MAX_APARTMENTS_FLOOR;i++)
        {
            new string[180];
	        mysql_format(pearsq, string, sizeof(string), "INSERT INTO `apartmentsRoom` SET `aprID` = '%d'", i), mysql_tquery(pearsq, string);
        }
    }
    return 1;
}

stock ShowDialogElevator(playerid)
{
    new id = DP[0][playerid];
    new line[90],lines[4096],lineheader[90];
    format(lineheader,sizeof(lineheader),"Лифт");
    format(line,sizeof(line),"{cccccc}Подъезд"), strcat(lines,line);
    for(new i = 0; i < Apartments[id][apFloor]; i++)
	{
		format(line,sizeof(line),"\n{ff9000}%d.{cccccc}Этаж", i+1), strcat(lines,line);
	}
	ShowDialog(playerid,APARTMENTS_DIALOG_ELIVATOR,DIALOG_STYLE_TABLIST,lineheader,lines,"Выбрать","Выход");
    return 1;
}

stock CreateApartments(playerid,id,class,floor)
{
    if(Apartments[id][apStatus] > 0) return 0;
    GetPlayerPos(playerid, Apartments[id][apCoord][0], Apartments[id][apCoord][1], Apartments[id][apCoord][2]);

    Apartments[id][apClass] = class;
    Apartments[id][apFloor] = floor;
    Apartments[id][apStatus] = 1;

    if(id != 0) Apartments[id][apWorldDefineEntrance] = Apartments[id-1][apWorldDefineEntrance] + MAX_APARTMENTS_ROOM_IN_FLOOR * Apartments[id-1][apFloor] + Apartments[id-1][apFloor] + 1;
    else Apartments[id][apWorldDefineEntrance] = START_WORLD_APARTMENTS;

    CreateDynamicActorApartmetns(id);
    UpdateClassApartments(id,class,0);
    CreatePickUpApartments(id,0);
    SaveApartments(id);
    return 1;
}

stock CreateDynamicActorApartmetns(apid)
{
    if(Apartments[apid][apClass] == 0)
    {
        ApartmentsActorResepshen[apid] = CreateDynamicActor(141, 572.6284,-1369.0701,14.4780,188.6132, true, 100.0, Apartments[apid][apWorldDefineEntrance], Apartments[apid][apInt]);
        ApartmentsActorTalk[apid][0] = CreateDynamicActor(68, 567.7714,-1375.4067,14.4780,341.8347, true, 100.0, Apartments[apid][apWorldDefineEntrance], Apartments[apid][apInt]);
        ApplyDynamicActorAnimation(ApartmentsActorTalk[apid][0],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApartmentsActorTalk[apid][1] = CreateDynamicActor(60, 568.2419,-1373.9905,14.4780,161.0397, true, 100.0, Apartments[apid][apWorldDefineEntrance], Apartments[apid][apInt]);
        ApplyDynamicActorAnimation(ApartmentsActorTalk[apid][1],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    }
    else if(Apartments[apid][apClass] == 1 || Apartments[apid][apClass] == 2)
    {
        ApartmentsActorResepshen[apid] = CreateDynamicActor(141, 1523.8877,1441.8868,10.9330,182.6944, true, 100.0, Apartments[apid][apWorldDefineEntrance], Apartments[apid][apInt]);
        ApartmentsActorTalk[apid][0] = CreateDynamicActor(98, 1532.4541,1431.4595,10.9330,140.0806, true, 100.0, Apartments[apid][apWorldDefineEntrance], Apartments[apid][apInt]);
        ApplyDynamicActorAnimation(ApartmentsActorTalk[apid][0],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
        ApartmentsActorTalk[apid][1] = CreateDynamicActor(147, 1531.0443,1429.4236,10.9330,321.1890, true, 100.0, Apartments[apid][apWorldDefineEntrance], Apartments[apid][apInt]);
        ApplyDynamicActorAnimation(ApartmentsActorTalk[apid][1],"PED","IDLE_CHAT",4.1,1,0,0,0,0);
    }
    return 1;
}

stock DestroyDynamicActorApartmetns(apid)
{
    if(!ApartmentsActorResepshen[apid] || !ApartmentsActorTalk[apid][0] || !ApartmentsActorTalk[apid][1]) return 0;
    DestroyDynamicActor(ApartmentsActorResepshen[apid]);
    DestroyDynamicActor(ApartmentsActorTalk[apid][0]);
    DestroyDynamicActor(ApartmentsActorTalk[apid][1]);
    return 1;
}
stock UpdateClassApartments(id,class,status)
{
    if(class == 0) // Старые квартиры
    {
        //Ценники
        Apartments[id][apPrice] = 3000000;
        Apartments[id][apPriceGold] = 900;

        // Интерьер
        Apartments[id][apInt] = 0;

        //лифт 0 этаж
        Apartments[id][apElevatorCoord][0] = 580.6958;
        Apartments[id][apElevatorCoord][1] = -1370.7643;
        Apartments[id][apElevatorCoord][2] = 14.4780;

        //лифт на этажах
        Apartments[id][apElevatorCoordFloor][0] = 539.6387;
        Apartments[id][apElevatorCoordFloor][1] = -1373.3655;
        Apartments[id][apElevatorCoordFloor][2] = 48.0500;

        //Вход на 0 этаже
        Apartments[id][apHolCoord][0] = 575.7531;
        Apartments[id][apHolCoord][1] = -1384.2601;
        Apartments[id][apHolCoord][2] = 14.4780;

        //Входы в квартиру(этаж)
        Apartments[id][apRoomCoordOne][0] = 600.0446;
        Apartments[id][apRoomCoordOne][1] = -1364.0137;
        Apartments[id][apRoomCoordOne][2] = 48.0660;

        Apartments[id][apRoomCoordTwo][0] = 593.8374;
        Apartments[id][apRoomCoordTwo][1] = -1365.3285;
        Apartments[id][apRoomCoordTwo][2] = 48.0660;

        Apartments[id][apRoomCoordThree][0] = 572.2968;
        Apartments[id][apRoomCoordThree][1] = -1369.8928;
        Apartments[id][apRoomCoordThree][2] = 48.0660;

        Apartments[id][apRoomCoordFour][0] = 549.1239;
        Apartments[id][apRoomCoordFour][1] = -1374.9537;
        Apartments[id][apRoomCoordFour][2] = 48.0660;

        //Выходы из квартир(Внутри каждой)
        Apartments[id][apRoomCoordOneExit][0] = 600.8337;
        Apartments[id][apRoomCoordOneExit][1] = -1366.8418;
        Apartments[id][apRoomCoordOneExit][2] = 48.0660;

        Apartments[id][apRoomCoordTwoExit][0] = 594.5170;
        Apartments[id][apRoomCoordTwoExit][1] = -1368.4880;
        Apartments[id][apRoomCoordTwoExit][2] = 48.0660;

        Apartments[id][apRoomCoordThreeExit][0] = 572.6982;
        Apartments[id][apRoomCoordThreeExit][1] = -1372.4946;
        Apartments[id][apRoomCoordThreeExit][2] = 48.0660;

        Apartments[id][apRoomCoordFourExit][0] = 549.8488;
        Apartments[id][apRoomCoordFourExit][1] = -1378.0646;
        Apartments[id][apRoomCoordFourExit][2] = 48.0660;
    }
    else if(class == 1 || class == 2) // Новые квартиры, class 1 это с виктора квартирой, class 2 без
    {
        //Ценники
        Apartments[id][apPrice] = 29000000;
        Apartments[id][apPriceGold] = 12000;

        // Интерьер
        Apartments[id][apInt] = 163;

        //лифт 0 этаж
        Apartments[id][apElevatorCoord][0] = 1529.0000;
        Apartments[id][apElevatorCoord][1] = 1445.2300;
        Apartments[id][apElevatorCoord][2] = 10.9330;

        //лифт на этажах
        Apartments[id][apElevatorCoordFloor][0] = 1553.1550;
        Apartments[id][apElevatorCoordFloor][1] = 1435.0576;
        Apartments[id][apElevatorCoordFloor][2] = 10.8785;

        //Вход на 0 этаже
        Apartments[id][apHolCoord][0] = 1523.1573;
        Apartments[id][apHolCoord][1] = 1429.7328;
        Apartments[id][apHolCoord][2] = 10.9330;

        //Входы в квартиру(этаж)
        Apartments[id][apRoomCoordOne][0] = 1560.5701;
        Apartments[id][apRoomCoordOne][1] = 1437.7412;
        Apartments[id][apRoomCoordOne][2] = 10.8785;

        Apartments[id][apRoomCoordTwo][0] = 1558.6697;
        Apartments[id][apRoomCoordTwo][1] = 1440.6064;
        Apartments[id][apRoomCoordTwo][2] = 10.8785;

        Apartments[id][apRoomCoordThree][0] = 1547.8158;
        Apartments[id][apRoomCoordThree][1] = 1440.6118;
        Apartments[id][apRoomCoordThree][2] = 10.8785;

        Apartments[id][apRoomCoordFour][0] = 1545.8545;
        Apartments[id][apRoomCoordFour][1] = 1437.6134;
        Apartments[id][apRoomCoordFour][2] = 10.8785;
 
        //Выходы из квартир(Внутри каждой)
        Apartments[id][apRoomCoordOneExit][0] = 1502.9694; 
        Apartments[id][apRoomCoordOneExit][1] = 1374.5793;
        Apartments[id][apRoomCoordOneExit][2] = 10.9010;

        Apartments[id][apRoomCoordTwoExit][0] = 1502.9694; 
        Apartments[id][apRoomCoordTwoExit][1] = 1374.5793;
        Apartments[id][apRoomCoordTwoExit][2] = 10.9010;

        Apartments[id][apRoomCoordThreeExit][0] = 1502.9694; 
        Apartments[id][apRoomCoordThreeExit][1] = 1374.5793;
        Apartments[id][apRoomCoordThreeExit][2] = 10.9010;

        Apartments[id][apRoomCoordFourExit][0] = 1502.9694; 
        Apartments[id][apRoomCoordFourExit][1] = 1374.5793;
        Apartments[id][apRoomCoordFourExit][2] = 10.9010;

        if(class == 1)
        {
            Apartments[id][apRoomCoordExclusiveExit][0] = 1494.0314;
            Apartments[id][apRoomCoordExclusiveExit][1] = 1264.2478;
            Apartments[id][apRoomCoordExclusiveExit][2] = 10.8507;
        }
    }
    if(status == 1) SaveApartments(id);
    return 1;
}

stock CreatePickUpApartmentsElevator(id,floor)
{
    new world = Apartments[id][apWorldDefineEntrance] + floor - START_WORLD_APARTMENTS;
    new label[512];
    format(label, sizeof(label),
        "{ff9000}Лифт\n" \
        "{FFFFFF}[ ALT ]\n"
    );
    if(floor == 0)
    {
        ApartmentsElevatorLabel[world] = CreateDynamic3DTextLabel(label,-1,Apartments[id][apElevatorCoord][0], Apartments[id][apElevatorCoord][1], Apartments[id][apElevatorCoord][2]+0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,world+START_WORLD_APARTMENTS,Apartments[id][apInt]);
    }
    ApartmentsElevatorLabel[world+1] = CreateDynamic3DTextLabel(label,-1,Apartments[id][apElevatorCoordFloor][0], Apartments[id][apElevatorCoordFloor][1], Apartments[id][apElevatorCoordFloor][2]+0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,world+START_WORLD_APARTMENTS+1,Apartments[id][apInt]);
    return 1;
}

stock CreatePickUpApartments(id, status)
{
    ApartmentsPickup[id] = CreateDynamicPickup(19524, 1, Apartments[id][apCoord][0], Apartments[id][apCoord][1], Apartments[id][apCoord][2], 0, 0);
    ApartmentsMapIcon[id] = CreateDynamicMapIcon(Apartments[id][apCoord][0], Apartments[id][apCoord][1], Apartments[id][apCoord][2],35,0,-1,-1,-1,200.0);
    new label[512];
    format(label, sizeof(label),
        "{ff9000}Квартирный Дом №%d\n" \
        "{FFFFFF}[ Количество этажей: %d ]\n" \
        "{FFFFFF}[ Количество квартир: %d ]",

        id + 1,
        Apartments[id][apFloor],
        Apartments[id][apFloor]*MAX_APARTMENTS_ROOM_IN_FLOOR
    );
    ApartmentsLabel[id] = CreateDynamic3DTextLabel(label,-1,Apartments[id][apCoord][0], Apartments[id][apCoord][1], Apartments[id][apCoord][2]+0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0,0);
    if(status == 0) CreatePickUpApartmentsFloor(id);
    return 1;
}

stock CreatePickUpApartmentsInt(z,f,id)
{
    ApartmentsNumber++;
    ApartmentsLastPickUp++;
    if(ApartmentsNumber > Apartments[id][apFloor]*MAX_APARTMENTS_ROOM_IN_FLOOR) return 1;
    ApartmentsRoom[ApartmentsLastPickUp][aprApartmentsID] = id;
    ApartmentsRoom[ApartmentsLastPickUp][aprWorld] = Apartments[id][apWorldDefineEntrance] + Apartments[id][apFloor] + z + f + 1;
    new world = Apartments[id][apWorldDefineEntrance] + 1 + z/MAX_APARTMENTS_ROOM_IN_FLOOR;
    new label[512];
    if(ApartmentsRoom[ApartmentsLastPickUp][aprOwn] == 0) {
        format(label, sizeof(label),
        "{ff9000}Квартира №%d\n" \
        "{FFFFFF}[ Продается за: {44ff99}%d${FFFFFF} ]\n" \
        "{FFFFFF}[ Владелец: Нет ]",

        ApartmentsLastPickUp+1,
        Apartments[id][apPrice]
        );
    }
    else
    {
        if(ApartmentsRoom[ApartmentsLastPickUp][aprSellOwn] == 0) 
        {
            format(label, sizeof(label),
            "{ff9000}Квартира №%d\n" \
            "{FFFFFF}[ Владелец: %s ]",

            ApartmentsLastPickUp+1,
            ApartmentsRoom[ApartmentsLastPickUp][aprOwnName]
            );
        }
        else
        {
            format(label, sizeof(label),
            "{ff9000}Квартира №%d\n" \
            "{FFFFFF}[ Продается владельцем за: {44ff99}%d${FFFFFF} ]\n" \
            "{FFFFFF}[ Владелец: %s ]",

            ApartmentsLastPickUp+1,
            ApartmentsRoom[ApartmentsLastPickUp][aprSellOwn],
            ApartmentsRoom[ApartmentsLastPickUp][aprOwnName]
            );
        }
    }
    switch(f % 4)
    {
        case 0:{
            ApartmentsIntLabel[ApartmentsLastPickUp] = CreateDynamic3DTextLabel(label,-1,Apartments[id][apRoomCoordOne][0], Apartments[id][apRoomCoordOne][1], Apartments[id][apRoomCoordOne][2]+0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1, world, Apartments[id][apInt]);
            ApartmentsPickupInt[ApartmentsLastPickUp] = CreateDynamicPickup(1318, 1, Apartments[id][apRoomCoordOne][0], Apartments[id][apRoomCoordOne][1], Apartments[id][apRoomCoordOne][2], world, Apartments[id][apInt]);
        }
        case 1:{
            ApartmentsIntLabel[ApartmentsLastPickUp] = CreateDynamic3DTextLabel(label,-1,Apartments[id][apRoomCoordTwo][0], Apartments[id][apRoomCoordTwo][1], Apartments[id][apRoomCoordTwo][2]+0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,world,Apartments[id][apInt]);
            ApartmentsPickupInt[ApartmentsLastPickUp] = CreateDynamicPickup(1318, 1, Apartments[id][apRoomCoordTwo][0], Apartments[id][apRoomCoordTwo][1], Apartments[id][apRoomCoordTwo][2], world, Apartments[id][apInt]);
        }
        case 2:{
            ApartmentsIntLabel[ApartmentsLastPickUp] = CreateDynamic3DTextLabel(label,-1,Apartments[id][apRoomCoordThree][0], Apartments[id][apRoomCoordThree][1], Apartments[id][apRoomCoordThree][2]+0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,world,Apartments[id][apInt]);
            ApartmentsPickupInt[ApartmentsLastPickUp] = CreateDynamicPickup(1318, 1, Apartments[id][apRoomCoordThree][0], Apartments[id][apRoomCoordThree][1], Apartments[id][apRoomCoordThree][2], world, Apartments[id][apInt]);
        }
        case 3:{
            ApartmentsIntLabel[ApartmentsLastPickUp] = CreateDynamic3DTextLabel(label,-1,Apartments[id][apRoomCoordFour][0], Apartments[id][apRoomCoordFour][1], Apartments[id][apRoomCoordFour][2]+0.5,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,world,Apartments[id][apInt]);
            ApartmentsPickupInt[ApartmentsLastPickUp] = CreateDynamicPickup(1318, 1, Apartments[id][apRoomCoordFour][0], Apartments[id][apRoomCoordFour][1], Apartments[id][apRoomCoordFour][2], world, Apartments[id][apInt]);
        }
    }
    return 1;
}

stock CreatePickUpApartmentsFloor(id)
{
    new temp;
    if(ApartmentsLastPickUpTumbler == -1) Apartments[id][apPickupStart] = ApartmentsLastPickUp+1;

    else 
    {
        Apartments[id][apPickupStart] = Apartments[ApartmentsLastPickUpTumbler][apPickupStart];
        temp = ApartmentsLastPickUp;
        ApartmentsLastPickUp = Apartments[ApartmentsLastPickUpTumbler][apPickupStart];
    }
    for(new z = 0; z < MAX_APARTMENTS_FLOOR; z++) // Создаем Пикапы и Лейблы Квартир внутри этажа
    {
        CreatePickUpApartmentsElevator(id,z);
        for(new f = 0; f < MAX_APARTMENTS_ROOM_IN_FLOOR; f++) // Создаем Пикапы и Лейблы Квартир единично
        {
            CreatePickUpApartmentsInt(z*MAX_APARTMENTS_ROOM_IN_FLOOR,f,id);
        }
    }
    Apartments[id][apPickupEnd] = ApartmentsLastPickUp;
    if(ApartmentsLastPickUpTumbler != -1) ApartmentsLastPickUp = temp;
    ApartmentsLastPickUpTumbler = -1;
    ApartmentsNumber = 0;
    return 1;
}

stock ApartmentsHolEnterPickUp(playerid)
{
    for(new i;i<MAX_APARTMENTS;i++)
    {
        if(!IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[i][apCoord][0], Apartments[i][apCoord][1], Apartments[i][apCoord][2])) continue;

        if(!IsPlayerSyncModels(playerid))
        {
            ErrorMessage(playerid, "{FF6347}Вы не используете лаунчер\n{cccccc}Зайти в данный интерьер нельзя");
        }
        else
        {
            keep(playerid);
            PPSetPlayerPos(playerid,Apartments[i][apHolCoord][0],Apartments[i][apHolCoord][1],Apartments[i][apHolCoord][2]); 
            PPSetPlayerInterior(playerid,Apartments[i][apInt]);
            S_SetPlayerVirtualWorld(playerid,Apartments[i][apWorldDefineEntrance]);
        }
        break;
    }
    return 1;
}

stock ApartmentsEnterPickUp(playerid)
{
    new world = GetPlayerVirtualWorld(playerid),worldroom,result = -1;
    for(new id; id < MAX_APARTMENTS; id++)
    {
        if(Apartments[id][apStatus] == 0) continue;
        if(world >= Apartments[id][apWorldDefineEntrance] 
        && world <= Apartments[id][apWorldDefineEntrance] + MAX_APARTMENTS_ROOM_IN_FLOOR * Apartments[id][apFloor] + Apartments[id][apFloor]) 
        {
            result = id;
            break;
        }
        else continue;
    }
    if(result == -1) return 0;
    if(world == Apartments[result][apWorldDefineEntrance])
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apHolCoord][0],Apartments[result][apHolCoord][1],Apartments[result][apHolCoord][2]))
        {
            keep(playerid);
            PPSetPlayerPos(playerid,Apartments[result][apCoord][0], Apartments[result][apCoord][1], Apartments[result][apCoord][2]); 
            PPSetPlayerInterior(playerid,0);
            S_SetPlayerVirtualWorld(playerid,0);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apElevatorCoord][0],Apartments[result][apElevatorCoord][1],Apartments[result][apElevatorCoord][2]))
        {
            DP[0][playerid] = result;
            ShowDialogElevator(playerid);
        }
    }
    for(new i;i < Apartments[result][apFloor]; i++)
    {
        worldroom = Apartments[result][apWorldDefineEntrance] + Apartments[result][apFloor] + i*MAX_APARTMENTS_ROOM_IN_FLOOR;
        DP[0][playerid] = result;
        DP[1][playerid] = worldroom;
        if(Apartments[result][apWorldDefineEntrance] +1 + i == world)
        {
            if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordOne][0], Apartments[result][apRoomCoordOne][1], Apartments[result][apRoomCoordOne][2]))
            {
                ApartmentsPlayerEnter(playerid,1);
                break;
            }
            else if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordTwo][0], Apartments[result][apRoomCoordTwo][1], Apartments[result][apRoomCoordTwo][2])) 
            {
                ApartmentsPlayerEnter(playerid,1);
                break;
            }
            else if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordThree][0], Apartments[result][apRoomCoordThree][1], Apartments[result][apRoomCoordThree][2])) 
            {
                ApartmentsPlayerEnter(playerid,1);
                break;
            }
            else if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordFour][0], Apartments[result][apRoomCoordFour][1], Apartments[result][apRoomCoordFour][2]))
            {
                ApartmentsPlayerEnter(playerid,1);
                break;
            }
            else if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apElevatorCoordFloor][0],Apartments[result][apElevatorCoordFloor][1],Apartments[result][apElevatorCoordFloor][2]))
            {
                ShowDialogElevator(playerid);
                break;
            }
        }
        else if(world >= worldroom && world <= worldroom+MAX_APARTMENTS_ROOM_IN_FLOOR)
        {
            new worldroomback = world - worldroom + Apartments[result][apWorldDefineEntrance]+i;
            if(worldroom+1 == world && IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordOneExit][0],Apartments[result][apRoomCoordOneExit][1],Apartments[result][apRoomCoordOneExit][2]))
            {
                keep(playerid);
                PPSetPlayerPos(playerid,Apartments[result][apRoomCoordOne][0], Apartments[result][apRoomCoordOne][1], Apartments[result][apRoomCoordOne][2]); 
                PPSetPlayerInterior(playerid,Apartments[result][apInt]);
                S_SetPlayerVirtualWorld(playerid,worldroomback);
                break;
            }
            else if(worldroom+2 == world && IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordTwoExit][0],Apartments[result][apRoomCoordTwoExit][1],Apartments[result][apRoomCoordTwoExit][2]))
            {
                keep(playerid);
                PPSetPlayerPos(playerid,Apartments[result][apRoomCoordTwo][0], Apartments[result][apRoomCoordTwo][1], Apartments[result][apRoomCoordTwo][2]); 
                PPSetPlayerInterior(playerid,Apartments[result][apInt]);
                S_SetPlayerVirtualWorld(playerid,worldroomback-1);
                break;
            }
            else if(worldroom+3 == world && IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordThreeExit][0], Apartments[result][apRoomCoordThreeExit][1], Apartments[result][apRoomCoordThreeExit][2]))
            {
                keep(playerid);
                PPSetPlayerPos(playerid,Apartments[result][apRoomCoordThree][0], Apartments[result][apRoomCoordThree][1], Apartments[result][apRoomCoordThree][2]); 
                PPSetPlayerInterior(playerid,Apartments[result][apInt]);
                S_SetPlayerVirtualWorld(playerid,worldroomback-2);
                break;
            }
            else if(worldroom+4 == world && IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordFourExit][0],Apartments[result][apRoomCoordFourExit][1],Apartments[result][apRoomCoordFourExit][2]))
            {
                keep(playerid);
                PPSetPlayerPos(playerid,Apartments[result][apRoomCoordFour][0], Apartments[result][apRoomCoordFour][1], Apartments[result][apRoomCoordFour][2]); 
                PPSetPlayerInterior(playerid,Apartments[result][apInt]);
                S_SetPlayerVirtualWorld(playerid,worldroomback-3);
                break;
            }
            else if(worldroom+4 == world && IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordExclusiveExit][0],Apartments[result][apRoomCoordExclusiveExit][1],Apartments[result][apRoomCoordExclusiveExit][2]))
            {
                keep(playerid);
                PPSetPlayerPos(playerid,Apartments[result][apRoomCoordFour][0], Apartments[result][apRoomCoordFour][1], Apartments[result][apRoomCoordFour][2]); 
                PPSetPlayerInterior(playerid,Apartments[result][apInt]);
                S_SetPlayerVirtualWorld(playerid,worldroomback-3);
                break;
            }
        }
    }
    return 1;
}

// ALT у входа в дом
stock ApartmentsPlayerEnter(playerid, type)
{
    new result = DP[0][playerid];
    new worldroom = DP[1][playerid];
    if(type == 0)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordOne][0], Apartments[result][apRoomCoordOne][1], Apartments[result][apRoomCoordOne][2]))
        {
            PPSetPlayerPos(playerid,Apartments[result][apRoomCoordOneExit][0],Apartments[result][apRoomCoordOneExit][1],Apartments[result][apRoomCoordOneExit][2]); 
            PPSetPlayerInterior(playerid,Apartments[result][apInt]);
            S_SetPlayerVirtualWorld(playerid,worldroom+1);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordTwo][0], Apartments[result][apRoomCoordTwo][1], Apartments[result][apRoomCoordTwo][2])) 
        {
            PPSetPlayerPos(playerid,Apartments[result][apRoomCoordTwoExit][0],Apartments[result][apRoomCoordTwoExit][1],Apartments[result][apRoomCoordTwoExit][2]); 
            PPSetPlayerInterior(playerid,Apartments[result][apInt]);
            S_SetPlayerVirtualWorld(playerid,worldroom+2);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordThree][0], Apartments[result][apRoomCoordThree][1], Apartments[result][apRoomCoordThree][2])) 
        {
            PPSetPlayerPos(playerid,Apartments[result][apRoomCoordThreeExit][0],Apartments[result][apRoomCoordThreeExit][1],Apartments[result][apRoomCoordThreeExit][2]); 
            PPSetPlayerInterior(playerid,Apartments[result][apInt]);
            S_SetPlayerVirtualWorld(playerid,worldroom+3);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordFour][0], Apartments[result][apRoomCoordFour][1], Apartments[result][apRoomCoordFour][2]))
        {
            if(Apartments[result][apClass] == 1 && Apartments[result][apWorldDefineEntrance] + Apartments[result][apFloor] == GetPlayerVirtualWorld(playerid))
            {
                PPSetPlayerPos(playerid,Apartments[result][apRoomCoordExclusiveExit][0],Apartments[result][apRoomCoordExclusiveExit][1],Apartments[result][apRoomCoordExclusiveExit][2]); 
                PPSetPlayerInterior(playerid,Apartments[result][apInt]);
                S_SetPlayerVirtualWorld(playerid,worldroom+4);
            }
            else
            {
                PPSetPlayerPos(playerid,Apartments[result][apRoomCoordFourExit][0],Apartments[result][apRoomCoordFourExit][1],Apartments[result][apRoomCoordFourExit][2]); 
                PPSetPlayerInterior(playerid,Apartments[result][apInt]);
                S_SetPlayerVirtualWorld(playerid,worldroom+4);
            }
        }
    }
    // Меню покупки дом
    if(type == 1)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordOne][0], Apartments[result][apRoomCoordOne][1], Apartments[result][apRoomCoordOne][2]))
        {
            ShowDialogMenuBuyApartments(playerid,result,0);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordTwo][0], Apartments[result][apRoomCoordTwo][1], Apartments[result][apRoomCoordTwo][2])) 
        {
            ShowDialogMenuBuyApartments(playerid,result,1);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordThree][0], Apartments[result][apRoomCoordThree][1], Apartments[result][apRoomCoordThree][2])) 
        {
            ShowDialogMenuBuyApartments(playerid,result,2);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2.0, Apartments[result][apRoomCoordFour][0], Apartments[result][apRoomCoordFour][1], Apartments[result][apRoomCoordFour][2]))
        {
            ShowDialogMenuBuyApartments(playerid,result,3);
        }
    }
	return 1;
}

stock GetRoomIdInFloor(playerid,apid,room)
{
    new world = GetPlayerVirtualWorld(playerid);
    new result = -1,roomIdOld;
    if(world < 15000 && world > MAX_APARTMENTS*MAX_APARTMENTS_FLOOR*MAX_APARTMENTS*MAX_APARTMENTS_ROOM_IN_FLOOR*MAX_APARTMENTS_FLOOR + START_WORLD_APARTMENTS) return -1;
    for(new i; i < Apartments[apid][apFloor]; i++)
    {
        if(world == Apartments[apid][apWorldDefineEntrance] + 1 + i)
        {
            for(new z; z < apid;z++)
            {
                if(Apartments[apid][apStatus] > 0) roomIdOld += MAX_APARTMENTS_FLOOR * MAX_APARTMENTS_ROOM_IN_FLOOR;
            }
            result = i;
            break;
        }
    }
    if(result != -1) 
    {
        result = result*MAX_APARTMENTS_ROOM_IN_FLOOR+roomIdOld+room;
    }
    return result;
}
// Меню у входа в квартиру
stock ShowDialogMenuBuyApartments(playerid, apid,room)
{
    new roomid = GetRoomIdInFloor(playerid, apid,room);
    if(ApartmentsRoom[roomid][aprLock] == 0 && ApartmentsRoom[roomid][aprOwn] > 0 && ApartmentsRoom[roomid][aprSellOwn] == 0 && !IsAFunctionOrganization(57, fraction(playerid), playerid) && ApartmentsRoom[roomid][aprArest] == 0) return ApartmentsPlayerEnter(playerid,0);
	PlayerPlaySound(playerid,1150,0,0,0);
    DP[3][playerid] = roomid;
    DP[4][playerid] = apid;
    new line[100],lines[300];
    if(ApartmentsRoom[roomid][aprLock] == 0) format(line,sizeof(line),"{cccccc}Войти {ff9000}>>\t {99ff66}Открыто"), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}Войти {99ff66}>>\t {FF6347}Заперто"), strcat(lines,line);

    if(ApartmentsRoom[roomid][aprOwn] == 0) 
	{
		format(line,sizeof(line),"\n{cccccc}Купить за {99ff66}%d$ {cccccc}(гос. цена)\t", Apartments[apid][apPrice]), strcat(lines,line);
		if(Apartments[apid][apPriceGold] > 0) format(line,sizeof(line),"\n{cccccc}Купить за {ffcc00}%dG\t", Apartments[apid][apPriceGold]), strcat(lines,line);
	}
    else if(ApartmentsRoom[roomid][aprSellOwn] > 0)
    {
        format(line,sizeof(line),"\n{cccccc}Купить за {99ff66}%d$ {cccccc}(Цена от владельца)\t", ApartmentsRoom[roomid][aprSellOwn]), strcat(lines,line);
    }
    else if(ApartmentsRoom[roomid][aprOwn] > 0 && IsAFunctionOrganization(57, fraction(playerid), playerid) && ApartmentsRoom[roomid][aprArest] == 0)
    {
        format(line,sizeof(line),"\n{cccccc}Арестовать Квартиру\t"), strcat(lines,line);
    }

	format(line,sizeof(line),"{ff9000}Квартира");
  	ShowDialog(playerid,APARTMENTS_DIALOG_ENTER,DIALOG_STYLE_TABLIST, line, lines, "Выбор", "Выход");
	return 1;
}

stock GetPlayerApartmentsRoom(playerid, apid)
{
    new world = GetPlayerVirtualWorld(playerid);
    if(world < Apartments[apid][apWorldDefineEntrance] + MAX_APARTMENTS_FLOOR 
    && world > Apartments[apid][apWorldDefineEntrance] + MAX_APARTMENTS_FLOOR + (MAX_APARTMENTS_FLOOR*MAX_APARTMENTS_ROOM_IN_FLOOR)) return -1;
    new result = -1;
    for(new i = Apartments[apid][apPickupStart];i < Apartments[apid][apPickupEnd]; i++)
    {
        if(world == ApartmentsRoom[i][aprWorld])
        {
            result = i;
            break;
        }
    }
    return result;
}
stock GetPlayerApartmentsId(playerid)
{
    new apid = -1,world = GetPlayerVirtualWorld(playerid);
    for(new id; id < MAX_APARTMENTS; id++)
    {
        if(Apartments[id][apStatus] == 0) continue;
        if(world >= Apartments[id][apWorldDefineEntrance] 
        && world <= Apartments[id][apWorldDefineEntrance] + MAX_APARTMENTS_ROOM_IN_FLOOR * Apartments[id][apFloor] + Apartments[id][apFloor]) 
        {
            apid = id;
            break;
        }
        else continue;
    }
    return apid;
}

stock TempBlockBuyRoom(playerid)
{
    new haveroom;
    for(new i; i < 10; i++)
    {
        if(PlayerInfo[playerid][pApartmentsRoom][i] != 0)
        {
            haveroom = 1;
            break;
        }
    }
    new year, month,day;
 	getdate(year, month, day);
  	if(month == 10 && day >= 7) return 0;
    else return haveroom;
}
stock BuyApartmentsRoom(playerid, typeBuy, aprid, roomid) // typeBuy 0 - $, 1 - gold, 2 $ own
{
	if(typeBuy != 0 && typeBuy != 1 && typeBuy != 2) return 1;
	new result = -1,haveroom = -1;
    if(TempBlockBuyRoom(playerid)) return ErrorMessage(playerid,"{ff6347}Временно ограничено кол.во квартир на аккаунте. Доступна к покупке только одна квартира.\n\n Лимит снимится 7 октября");
    for(new i; i < 10; i++)
    {
        if(PlayerInfo[playerid][pApartmentsRoom][i] != 0)
        {
            if(PlayerInfo[playerid][pApartmentsRoom][i] == aprid+1 && typeBuy == 2)
            {
                haveroom = aprid+1;
            }
            else continue;
        }
        else
        {
            result = i;
            break;
        }
    }
    if(result == -1) return ErrorMessage(playerid, "{FF6347}У вас нет свободных слотов под квартиру");
    if(haveroom != -1) return ErrorMessage(playerid, "{FF6347}Нельзя купить свою же квартиру");
    if(ApartmentsRoom[roomid][aprOwn] != 0 && typeBuy != 2) return ErrorMessage(playerid, "{FF6347}Эта квартира куплена и не продается");
	new string[240];
	// Покупаем за вирты
	if(typeBuy == 0)
	{
		if(oGetPlayerMoney(playerid) < Apartments[aprid][apPrice]) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
		oGivePlayerMoney(playerid, -Apartments[aprid][apPrice]);
        format(string, sizeof(string), "Купил квартиру %d в квартирном доме %d",ApartmentsRoom[roomid][aprID], aprid+1);
        MoneyLog("buyapartmentsroom", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", Apartments[aprid][apPrice], string);
	}
	else if(typeBuy == 1)
	{
		if(Apartments[aprid][apPriceGold] == 0) return ErrorMessage(playerid, "{FF6347}Эту квартиру нельзя купить за Gold");

		if(PlayerInfo[playerid][pDonateMoney] < Apartments[aprid][apPriceGold]) return ErrorMessage(playerid, "{FF6347}Вам не хватает золота для покупки дома\n{ffcc66}Приобрести золото можно на нашем сайте pears.fun [ Y >> Донат ]");
		PlayerInfo[playerid][pDonateMoney] -= Apartments[aprid][apPriceGold];
		tclArifmetikAllGold -= Apartments[aprid][apPriceGold];
		mysql_save(playerid, 4);

		format(string, sizeof(string), "Купил квартиру %d в квартирном доме %d за голду",ApartmentsRoom[roomid][aprID], aprid+1);
		MoneyLog("buyapartmentsroom", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", Apartments[aprid][apPrice], string);
	}
    else if(typeBuy == 2)
	{
		new para1;
        para1 = ReturnUser(ApartmentsRoom[roomid][aprOwn], 1);
        if(IsPlayerConnected(para1))
        {
            if(ApartmentsRoom[roomid][aprOwn] == PlayerInfo[para1][pID])
            {
                new result2 = -1;
                PlayerInfo[para1][pAccount] += ApartmentsRoom[roomid][aprSellOwn];
                for(new i; i < 10; i++)
                {
                    if(PlayerInfo[playerid][pApartmentsRoom][i]-1 == ApartmentsRoom[roomid][aprID])
                    {
                        result2 = i;
                        break;
                    }
                }
                if(result2 == -1) return ErrorMessage(playerid, "{FF6347}Ошибка! У Владельца квартиры нет этой квартиры");
                PlayerInfo[para1][pApartmentsRoom][result2] = 0;
                if(OnlineInfo[para1][oLogged] == 1)
                {
                    format(string, sizeof(string), "{0088ff}[ Риэлторское Агентство ]: Ваша {ffcc66}Квартира № %d {0088ff}только что была куплена %s", ApartmentsRoom[roomid][aprID], PlayerInfo[playerid][pName]);
                    SendClientMessage(para1, COLOR_GREY, string);
                    format(string, sizeof(string), "{0088ff}[ Риэлторское Агентство ]: Деньги в размере {99ff66}%d$ {0088ff}перечислены на ваш бансковский счёт", ApartmentsRoom[roomid][aprSellOwn]);
                    SendClientMessage(para1, COLOR_GREY, string);
                    format(string, sizeof(string), "{cccccc}Ваша {ff9000}Квартира № %d {cccccc}только что была куплена {ff9000}%s\n{cccccc}Деньги в размере {99ff66}%d$ {cccccc}перечислены на ваш банковский счёт", ApartmentsRoom[roomid][aprID], PlayerInfo[playerid][pName], ApartmentsRoom[roomid][aprSellOwn]);
                    ShowDialog(para1,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Риэлторское Агентство",string,"Oк","");

                    mysql_save(para1, 0);
                    mysql_save(para1, 8);
                }
                else
                {
                    if(OnlineInfo[para1][oLogged] == 0) return ErrorText(playerid, "{FF6347}Дождитесь пока владелец квартиры авторизуется и повторите попытку");
                }
            }
        }
        else
        {
            mysql_format(pearsq, string,sizeof(string),"SELECT * FROM `pp_igroki` WHERE `user_id` = '%d'", ApartmentsRoom[roomid][aprOwn]);
            mysql_tquery(pearsq, string, "Call_OfflineBuyApartments", "d", roomid);
        }
	    if(PlayerInfo[playerid][pAchieve][10] == 0) AchievePlayer(playerid, 10, 1);
	}

    format(string, sizeof(string), "Купил Квартиру в квартирном доме %d у игрока %s",aprid+1,ApartmentsRoom[roomid][aprOwnName]);
    HouseLog(1, "buyapartmentsroom", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], ApartmentsRoom[roomid][aprID], -ApartmentsRoom[roomid][aprSellOwn], string);
    format(string, sizeof(string), "Продал Квартиру в квартирном доме %d игроку %s",aprid+1, PlayerInfo[playerid][pName]);
    HouseLog(1, "sellapartmentsroom", ApartmentsRoom[roomid][aprOwn], ApartmentsRoom[roomid][aprOwnName], "", ApartmentsRoom[roomid][aprID], ApartmentsRoom[roomid][aprSellOwn], string);

	PlayerInfo[playerid][pApartmentsRoom][result] = ApartmentsRoom[roomid][aprID]+1;
	ApartmentsRoom[roomid][aprOwn] = PlayerInfo[playerid][pID];
	ApartmentsRoom[roomid][aprStatus] = 1;
    ApartmentsRoom[roomid][aprSellOwn] = 0;
	format(ApartmentsRoom[roomid][aprOwnName], 24,"%s", PlayerInfo[playerid][pName]);
	mysql_save(playerid, 8);
	PlayerPlayMusic(playerid);
	SaveApartmentsRoom(roomid);
	UpdateLabelApartments(roomid);
	PlayerPlaySound(playerid, 1052, 0, 0, 0);
	format(string, sizeof(string),"{cccccc}Поздравляем с покупкой {ff9000}Квартиры");
	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX, "{ff9000}Риэлторское Агентство", string, "Ок", "");

	SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ Риэлторское Агентство ]: Поздравляем с покупкой Квартиры");
	return 1;
}

function Call_OfflineBuyApartments(roomid)
{
    new datad1, datad2, datad[10],string[16],result = -1,f_str[144];
    cache_get_value_name_int(0, "Account", datad1);
    cache_get_value_name_int(0, "user_id", datad2);
    for(new i; i < 10; i++)
    {
        format(string, sizeof(string), "pApartmentsRoom%d",i);
        cache_get_value_name_int(0, "string", datad[i]);
        if(datad[i] == roomid) 
        {
            result = i;
            break;
        }
    }
    new pluslave = datad1 + ApartmentsRoom[roomid][aprSellOwn];
    if(ApartmentsRoom[roomid][aprOwn] == datad2) 
    {
        mysql_format(pearsq, f_str,sizeof(f_str),"UPDATE `pp_igroki` SET `Account` = '%d', `pApartmentsRoom%d` = '0' WHERE `user_id` = '%d'",pluslave, result, datad2);
        query_empty(pearsq, f_str);
    }
	return true;
}
stock UpdateLabelApartments(roomid)
{
    new label[512];
    if(ApartmentsRoom[roomid][aprSellOwn] > 0)
    {
        format(label, sizeof(label),
        "{ff9000}Квартира №%d\n" \
        "{FFFFFF}[ Продается владельцем за: {44ff99}%d${FFFFFF} ]\n" \
        "{FFFFFF}[ Владелец: %s ]",

        roomid+1,
        ApartmentsRoom[roomid][aprSellOwn],
        ApartmentsRoom[roomid][aprOwnName]
        );
    }
    else if(ApartmentsRoom[roomid][aprOwn] > 0)
    {
        format(label, sizeof(label),
        "{ff9000}Квартира №%d\n" \
        "{FFFFFF}[ Владелец: %s ]",

        roomid+1,
        ApartmentsRoom[roomid][aprOwnName]
        );
    }
    else
    {
        format(label, sizeof(label),
        "{ff9000}Квартира №%d\n" \
        "{FFFFFF}[ Продается за: {44ff99}%d${FFFFFF} ]\n" \
        "{FFFFFF}[ Владелец: Нет ]",

        roomid+1,
        Apartments[ApartmentsRoom[roomid][aprApartmentsID]][apPrice]
        );
    }
    UpdateDynamic3DTextLabelText(ApartmentsIntLabel[roomid],-1,label);
    return 1;
}
stock dialogCase_Apartments(playerid, dialogid, response, listitem, const inputtext[])
{
    switch (e_DialogId: dialogid)
    {
        case APARTMENTS_DIALOG_ELIVATOR:
        {
            if(response)
            {
                new id = DP[0][playerid];
                if(listitem >= 0 && listitem <= Apartments[id][apFloor])
                {
                    if(listitem == 0)
                    {
                        PPSetPlayerPos(playerid, Apartments[id][apElevatorCoord][0],Apartments[id][apElevatorCoord][1],Apartments[id][apElevatorCoord][2]); 
                        PPSetPlayerInterior(playerid,Apartments[id][apInt]);
                        S_SetPlayerVirtualWorld(playerid,Apartments[id][apWorldDefineEntrance]);
                    }
                    else if(listitem > 0)
                    {
                        PPSetPlayerPos(playerid,Apartments[id][apElevatorCoordFloor][0],Apartments[id][apElevatorCoordFloor][1],Apartments[id][apElevatorCoordFloor][2]); 
                        PPSetPlayerInterior(playerid,Apartments[id][apInt]);
                        S_SetPlayerVirtualWorld(playerid,Apartments[id][apWorldDefineEntrance]+listitem);
                    }
                }       
            }
        }
        case APARTMENTS_DIALOG_ENTER:
        {
            if(response)
            {
                new roomid = DP[3][playerid];
                new apid = DP[4][playerid];
                new string[140];
                if(listitem == 0) 
                {
                    if(ApartmentsRoom[roomid][aprArest] == 0) ApartmentsPlayerEnter(playerid,0);
                    else ErrorMessage(playerid,"{ff6347}Квартира арестована за неуплату налогов");
                }
                else if(listitem == 1 && ApartmentsRoom[roomid][aprSellOwn] == 0 && IsAFunctionOrganization(57, fraction(playerid), playerid) && ApartmentsRoom[roomid][aprOwn] != 0) arestroom(playerid,roomid);
                else if(listitem == 1) 
                {
                    if(ApartmentsRoom[roomid][aprSellOwn] != 0) DP[2][playerid] = 2;
                    else DP[2][playerid] = 0;

                    if(ApartmentsRoom[roomid][aprOwn] != 0 && ApartmentsRoom[roomid][aprSellOwn] == 0) return ErrorMessage(playerid, "{FF6347}Эта квартира куплена и не продается");

                    if(ApartmentsRoom[roomid][aprSellOwn] == 0) format(string, sizeof(string), "{ff9000}Вы уверены, что хотите приобрести кваритру?\n{cccccc}Стоимость: {99ff66}%d$ {cccccc}(%s)", Apartments[apid][apPrice], get_k(Apartments[apid][apPrice]));
                    else format(string, sizeof(string), "{ff9000}Вы уверены, что хотите приобрести кваритру?\n{cccccc}Стоимость: {99ff66}%d$ {cccccc}(%s)", ApartmentsRoom[roomid][aprSellOwn], get_k(ApartmentsRoom[roomid][aprSellOwn]));
                    ShowDialog(playerid,APARTMENTS_DIALOG_BUY,DIALOG_STYLE_MSGBOX,"{ff9000}Риэлторское Агентство",string,"Да","Нет");
                }
                else if(listitem == 2 && ApartmentsRoom[roomid][aprSellOwn] > 0 && IsAFunctionOrganization(57, fraction(playerid), playerid)) arestroom(playerid,roomid);
                else if(listitem == 2) 
                {
                    DP[2][playerid] = 1;
                    
                    if(ApartmentsRoom[roomid][aprOwn] != 0) return ErrorMessage(playerid, "{FF6347}Эта квартира куплена");
                    if(Apartments[apid][apPriceGold] == 0) return ErrorMessage(playerid, "{FF6347}Эту квартиру нельзя купить за Gold");
                    format(string, sizeof(string), "{ff9000}Вы уверены, что хотите приобрести квартиру?\n{cccccc}Стоимость: {ffcc00}%dG",Apartments[apid][apPriceGold]);
                    ShowDialog(playerid,APARTMENTS_DIALOG_BUY,DIALOG_STYLE_MSGBOX,"{ff9000}Риэлторское Агентство",string,"Да","Нет");
                }
            }
        }
        case APARTMENTS_DIALOG_BUY:
        {
            new i = DP[2][playerid];
            new roomid = DP[4][playerid];
            new aprid = DP[3][playerid];
            if(response) BuyApartmentsRoom(playerid, i, roomid, aprid);
            else ApartmentsPlayerEnter(playerid, 1);
        }
        case APARTMENTS_DIALOG_TABLETAKE:
        {
            if(response)
            {
                new string[240];
                i_resetveshi(playerid);
                i_resettabs(playerid);
                new inva = DP[0][playerid], i = OnlineInfo[playerid][oShowTabs];

                new thingId = ApartmentsRoom[i][aprInvent][inva];
                new thingQuan = ApartmentsRoom[i][aprInv][inva];
                new thingPara = ApartmentsRoom[i][aprInvPara][inva];
                new thingQara = ApartmentsRoom[i][aprInvQara][inva];
                new thingType = ApartmentsRoom[i][aprInvType][inva];
                new thingPack = ApartmentsRoom[i][aprInvPack][inva];
                
                new useinva = OnlineInfo[playerid][oInventSelectLeft];
                if(OnlineInfo[playerid][oShowInterface] != 1 || thingId <= 0 || i == 9999 || thingType != 0 || CheckThingQuan(thingId) != 1 || thingPack > 0
                || Tabs_Load[playerid] != 15) return 1;

                if(IsAApartmentsTable(playerid) == -1) return ErrorMessage(playerid, "{FF6347}Вы далеко от тумбы"), closetab(playerid, 1);

                if(useinva != 9999)
                {
                    if(PlayerInfo[playerid][pInven][useinva] != ApartmentsRoom[i][aprInvent][inva] && PlayerInfo[playerid][pInven][useinva] != 0) return 1;
                }
                
                HidePlayerDialog(playerid);
                new input;
                if(sscanf(inputtext, "i", input)) return ErrorMessage(playerid, "{FF6347}Вы ничего не ввели");
                if(input > 1000000 || input < 1) return ErrorMessage(playerid, "{FF6347}Не меньше 1 и не больше 1.000.000");
                if(input > thingQuan) return ErrorMessage(playerid, "{FF6347}В этой ячейке нет такого количества"), i_resettabs(playerid);
                
                new getQuan, getLimit;
                i_limit(playerid, thingId, getQuan, getLimit);
                if(getQuan+input > getLimit) return format(string,sizeof(string),"{FF6347}У вас нет места в инвентаре\nЛимит для этого предмета: %d\n\n{cccccc}Предметы учитываются из раздела торговли и упаковок с подарками", getLimit), ErrorMessage(playerid, string);
                
                new put_inva = GiveThingPlayer(playerid, thingId, input, thingPara, thingQara, thingType, thingPack, useinva);
                if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
                
                TakeApartmentsTable(i, thingId, input, thingType, inva);

                format(string,sizeof(string),"Взял %d: %s", i, GetNameThing(1, thingId, thingType, thingPack));
                UserLog("gAprTable", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", input, string);
            }
        }
        case APARTMENTS_DIALOG_TABLEPUT:
        {
            if(response)
            {
                if(OnlineInfo[playerid][oInventSelectLeft] == 9999 || OnlineInfo[playerid][oInventSelectRight] == 9999 
                || OnlineInfo[playerid][oShowTabs] == 9999 || Tabs_Load[playerid] != 15) return i_resetveshi(playerid), i_resettabs(playerid);
                
                new inva = OnlineInfo[playerid][oInventSelectLeft], fpick = PlayerInfo[playerid][pInven][inva], thingType = PlayerInfo[playerid][pInvenType][inva], thingPack = PlayerInfo[playerid][pInvenPack][inva], pt = OnlineInfo[playerid][oShowTabs];
                if(fpick == 0 || thingType != 0 || thingPack > 0) return i_resetveshi(playerid), i_resettabs(playerid);

                if(ApartmentsRoom[pt][aprInvent][OnlineInfo[playerid][oInventSelectRight]] == fpick || ApartmentsRoom[pt][aprInvent][OnlineInfo[playerid][oInventSelectRight]] == 0)
                {
                    if(CheckThingQuan(fpick) != 1) return i_resetveshi(playerid), i_resettabs(playerid);
                    new input = strval(inputtext);
                    if(sscanf(inputtext, "i", input)) return ErrorMessage(playerid, "{FF6347}Вы ничего не ввели"), i_resetveshi(playerid), i_resettabs(playerid);
                    if(input > 1000000 || input < 1) return ErrorMessage(playerid, "{FF6347}Не меньше 1 и не больше 1.000.000"), i_resetveshi(playerid), i_resettabs(playerid);
                    if(input > PlayerInfo[playerid][pInvenQuan][inva]) return ErrorMessage(playerid, "{FF6347}У вас нет такого количества в этой ячейке"), i_resettabs(playerid);
                    put_ApartmentsTable(playerid, OnlineInfo[playerid][oInventSelectLeft], pt, fpick, input, OnlineInfo[playerid][oInventSelectRight], thingType, 0);
                }
                else i_resetveshi(playerid), i_resettabs(playerid);
            }
            else i_resetveshi(playerid), i_resettabs(playerid);
        }
        case APARTMENTS_DIALOG_MENU:
        {
            if(response)
            {
                if(listitem > DP[0][playerid] || listitem < 0) return ErrorMessage(playerid,"Ошибка мода, обратитесь к администрации");
                DP[1][playerid] = PlayerInfo[playerid][pApartmentsRoom][List[listitem][playerid]]-1;
                ShowMenuApartmentsRoomDetail(playerid,List[listitem][playerid]);
            }
            else return pc_cmd_myhouse(playerid);
        }
        case APARTMENTS_DIALOG_MYROOMS:
        {
            if(response)
            {
                new roomid = DP[1][playerid],string[240];
                if(listitem > 3 || listitem < 0) return ErrorMessage(playerid,"Ошибка мода, обратитесь к администрации");
                if(listitem == 0) return ShowMenuApartmentsRoomInfo(playerid,roomid);
                else if(listitem == 1)
                {
                    if(ApartmentsRoom[roomid][aprLock] == 1) ApartmentsRoom[roomid][aprLock] = 0;
                    else ApartmentsRoom[roomid][aprLock] = 1;
                    return ShowMenuApartmentsRoomDetail(playerid,roomid);
                }
                else if(listitem == 2)
                {
                    if(ApartmentsRoom[roomid][aprSellOwn] == 0) ShowDialog(playerid,APARTMENTS_DIALOG_SELLROOM, DIALOG_STYLE_INPUT,"{ff9000}Укажите стоимость квартиры","Выставить квартиру на продажу можно максимум в два раза дороже гос.стоимости\n{cccccc}Пример: {44ff99}100000$","Принять","Отмена");
                    else
                    {
                        ApartmentsRoom[roomid][aprSellOwn] = 0;
                        SaveApartmentsRoom(roomid); 
                        UpdateLabelApartments(roomid);
                        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я снял свою квартиру с продажи");
                        return ShowMenuApartmentsRoomDetail(playerid,roomid);
                    }
                }
                else if(listitem == 3)
                {
                    format(string, sizeof(string), "{0088ff}** {FFFFFF}Вы уверены, что хотите продать квартиру ?\n\n{0088ff}** {FF0000}Продавая квартиру государству, вы получите половину её стоимости [{44ff99}%d${FF0000}]",Apartments[ApartmentsRoom[roomid][aprApartmentsID]][apPrice]/2);
                    ShowDialog(playerid,APARTMENTS_DIALOG_SELLROOMGOS,DIALOG_STYLE_MSGBOX,"{0088ff}*** {ffffff}  Продажа Квартиры {0088ff}***",string,"Да","Нет");
                }
            }
            else return pc_cmd_myhouse(playerid);
        }
        case APARTMENTS_DIALOG_SELLROOM:
        {
            new roomid = DP[1][playerid];
            if(response)
            {
                new price = strval(inputtext);
                if(!sscanf(inputtext, "i", price))
                {
                    if(price > Apartments[ApartmentsRoom[roomid][aprApartmentsID]][apPrice]*2 || price < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Цена не может быть выше %d$ и ниже 1$",Apartments[ApartmentsRoom[roomid][aprApartmentsID]][apPrice]*2), ShowMenuApartmentsRoomDetail(playerid,roomid);
                    if(ApartmentsRoom[roomid][aprTaxes] > 0) return ErrorMessage(playerid,"{ff6347}Сначала нужно оплатить налог на квартиру");
                    ApartmentsRoom[roomid][aprSellOwn] = price;
                    SaveApartmentsRoom(roomid); 
                    UpdateLabelApartments(roomid);
                    return 1;
                }
                else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не указал ценник"), ShowMenuApartmentsRoomDetail(playerid,roomid);
            }
            else return ShowMenuApartmentsRoomDetail(playerid,roomid);
        }
        case APARTMENTS_DIALOG_SELLROOMGOS:
        {
            new roomid = DP[1][playerid],string[240];
            if(response)
            {
                if(ApartmentsRoom[roomid][aprOwn] == PlayerInfo[playerid][pID])
                {
                    ApartmentsRoom[roomid][aprOwn] = 0;
                    ApartmentsRoom[roomid][aprStatus] = 0;
                    ApartmentsRoom[roomid][aprTaxday] = 0;
                    ApartmentsRoom[roomid][aprTaxes] = 0;
                    strmid(ApartmentsRoom[roomid][aprOwnName], "Нет", 0, strlen("Нет"), 255);
                    UpdateLabelApartments(roomid);
                    SaveApartmentsRoom(roomid);
                    oGivePlayerMoney(playerid,Apartments[ApartmentsRoom[roomid][aprApartmentsID]][apPrice]/2);
                    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
                    format(string, sizeof(string), RusToGame("~w~Вы продали Квартиру за %d$"),Apartments[ApartmentsRoom[roomid][aprApartmentsID]][apPrice]/2);
                    GameTextForPlayer(playerid, string, 10000, 3);
                    for(new i; i < 10; i++)
                    {
                        if(PlayerInfo[playerid][pApartmentsRoom][i] == roomid+1)
                        {
                            PlayerInfo[playerid][pApartmentsRoom][i] = 0;
                            break;
                        }
                    }
                    SendClientMessage(playerid, COLOR_GREY, "{0088ff}[ Риэлторское Агентство ]: Поздравляем с продажей Квартиры");
                    HouseLog(1, "sellroom", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], ApartmentsRoom[roomid][aprID], Apartments[ApartmentsRoom[roomid][aprApartmentsID]][apPrice]/2, "Продал Квартиру (Гос)");
                    MoneyLog("sellroom", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", Apartments[ApartmentsRoom[roomid][aprApartmentsID]][apPrice]/2, "Продал Квартиру (Гос)");
                    mysql_save(playerid, 8);
                }
                else ErrorMessage(playerid,"Ошибка, у меня нет квартиры");
            }
            else return ShowMenuApartmentsRoomDetail(playerid,roomid);
        }
        case APARTMENTS_DIALOG_ROOMINFO:
        {
            new roomid = DP[1][playerid];
            return ShowMenuApartmentsRoomDetail(playerid,roomid);
        }
        case APARTMENTS_DIALOG_GPS:
        {
            if(!response) pc_cmd_gps(playerid);
            new apid = List[listitem][playerid];
            SuccessMessage(playerid, "{99ff66}Квартирный дом отмечен на карте");
            CreateGps(playerid,Apartments[apid][apCoord][0],Apartments[apid][apCoord][1],Apartments[apid][apCoord][2], 0, 0, 5.0);
        }
    }
    return 1;
}

stock SaveApartments(id) {
    new query_string[2048];

    mysql_format(pearsq, query_string, sizeof(query_string),
        "REPLACE INTO `apartments` (`newid`,`apId`, `apStatus`, `apInt`, `apClass`, `apFloor`, `apWorldDefineEntrance`, `apCoord0`, `apCoord1`, `apCoord2`, `apElevatorCoord0`, `apElevatorCoord1`, `apElevatorCoord2`,\
        `apPrice`, `apPriceGold`,`apElevatorCoordFloor0`, `apElevatorCoordFloor1`, `apElevatorCoordFloor2`, `apHolCoord0`, `apHolCoord1`, `apHolCoord2`,\
        `apRoomCoordOne0`, `apRoomCoordOne1`, `apRoomCoordOne2`, `apRoomCoordTwo0`, `apRoomCoordTwo1`, `apRoomCoordTwo2`,\
        `apRoomCoordThree0`, `apRoomCoordThree1`, `apRoomCoordThree2`, `apRoomCoordFour0`, `apRoomCoordFour1`, `apRoomCoordFour2`,\
        `apRoomCoordOneExit0`, `apRoomCoordOneExit1`, `apRoomCoordOneExit2`, `apRoomCoordTwoExit0`, `apRoomCoordTwoExit1`, `apRoomCoordTwoExit2`,\
        `apRoomCoordThreeExit0`, `apRoomCoordThreeExit1`, `apRoomCoordThreeExit2`, `apRoomCoordFourExit0`, `apRoomCoordFourExit1`, `apRoomCoordFourExit2`, `apRoomCoordExclusiveExit0`, `apRoomCoordExclusiveExit1`, `apRoomCoordExclusiveExit2`) \
        VALUES(%d, %d, %d, %d, %d, %d, %d, %f, %f, %f, %f, %f, %f,%d,%d, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f,  %f, %f, %f)",
        
        Apartments[id][apNewId],
        Apartments[id][apId],
        Apartments[id][apStatus],
        Apartments[id][apInt],
        Apartments[id][apClass],
        Apartments[id][apFloor],
        Apartments[id][apWorldDefineEntrance],
        Apartments[id][apCoord][0], Apartments[id][apCoord][1], Apartments[id][apCoord][2], Apartments[id][apElevatorCoord][0], Apartments[id][apElevatorCoord][1], Apartments[id][apElevatorCoord][2],
        Apartments[id][apPrice],
        Apartments[id][apPriceGold],
        Apartments[id][apElevatorCoordFloor][0], Apartments[id][apElevatorCoordFloor][1], Apartments[id][apElevatorCoordFloor][2], Apartments[id][apHolCoord][0], Apartments[id][apHolCoord][1], Apartments[id][apHolCoord][2],
        Apartments[id][apRoomCoordOne][0], Apartments[id][apRoomCoordOne][1], Apartments[id][apRoomCoordOne][2], Apartments[id][apRoomCoordTwo][0], Apartments[id][apRoomCoordTwo][1], Apartments[id][apRoomCoordTwo][2],
        Apartments[id][apRoomCoordThree][0], Apartments[id][apRoomCoordThree][1], Apartments[id][apRoomCoordThree][2], Apartments[id][apRoomCoordFour][0], Apartments[id][apRoomCoordFour][1], Apartments[id][apRoomCoordFour][2],
        Apartments[id][apRoomCoordOneExit][0], Apartments[id][apRoomCoordOneExit][1], Apartments[id][apRoomCoordOneExit][2], Apartments[id][apRoomCoordTwoExit][0], Apartments[id][apRoomCoordTwoExit][1], Apartments[id][apRoomCoordTwoExit][2],
        Apartments[id][apRoomCoordThreeExit][0], Apartments[id][apRoomCoordThreeExit][1], Apartments[id][apRoomCoordThreeExit][2], Apartments[id][apRoomCoordFourExit][0], Apartments[id][apRoomCoordFourExit][1], Apartments[id][apRoomCoordFourExit][2],
        Apartments[id][apRoomCoordExclusiveExit][0], Apartments[id][apRoomCoordExclusiveExit][1], Apartments[id][apRoomCoordExclusiveExit][2]
    );
     
    query_empty(pearsq, query_string);
}

stock SaveApartmentsRoom(id) {
    new query_string[248];
    mysql_format(pearsq, query_string,sizeof(query_string),"UPDATE `apartmentsRoom` SET `aprStatus` = '%d',`aprOwn` = '%d',`aprOwnName` = '%e',`aprApartmentsID` = '%d',`aprSellOwn` = '%d',`aprTaxes` = '%d',`aprTaxday` = '%d',`aprArest` = '%d' WHERE `aprID` = '%d'",
    ApartmentsRoom[id][aprStatus],ApartmentsRoom[id][aprOwn],ApartmentsRoom[id][aprOwnName],ApartmentsRoom[id][aprApartmentsID],ApartmentsRoom[id][aprSellOwn],ApartmentsRoom[id][aprTaxes],ApartmentsRoom[id][aprTaxday],ApartmentsRoom[id][aprArest], id);
     
    query_empty(pearsq, query_string);
}

function LoadApartmentsRoom() {
    new rows;
    cache_get_row_count(rows);
    for (new f = 0; f < MAX_APARTMENTS_TABLE; f++) {
        cache_get_value_name_int(f, "aprID", ApartmentsRoom[f][aprID]);
        cache_get_value_name_int(f, "aprStatus", ApartmentsRoom[f][aprStatus]);
        cache_get_value_name_int(f, "aprOwn", ApartmentsRoom[f][aprOwn]);
        cache_get_value_name_int(f, "aprSellOwn", ApartmentsRoom[f][aprSellOwn]);
        cache_get_value_name_int(f, "aprTaxes", ApartmentsRoom[f][aprTaxes]);
        cache_get_value_name_int(f, "aprTaxday", ApartmentsRoom[f][aprTaxday]);
        cache_get_value_name_int(f, "aprArest", ApartmentsRoom[f][aprArest]);
        cache_get_value_name(f, "aprOwnName", ApartmentsRoom[f][aprOwnName],24);
        OnLoadInventApartmentsRoom(f);
    }
}

function LoadApartments() {
    new rows;
    cache_get_row_count(rows);

    for (new i = 0; i < rows; i++) {
        cache_get_value_name_int(i, "newid", Apartments[i][apNewId]);
        cache_get_value_name_int(i, "apId", Apartments[i][apId]);
        cache_get_value_name_int(i, "apStatus", Apartments[i][apStatus]);
        cache_get_value_name_int(i, "apInt", Apartments[i][apInt]);
        cache_get_value_name_int(i, "apClass", Apartments[i][apClass]);
        cache_get_value_name_int(i, "apFloor", Apartments[i][apFloor]);
        cache_get_value_name_int(i, "apWorldDefineEntrance", Apartments[i][apWorldDefineEntrance]);
        cache_get_value_name_int(i, "apPrice", Apartments[i][apPrice]);
        cache_get_value_name_int(i, "apPriceGold", Apartments[i][apPriceGold]);

        cache_get_value_name_float(i, "apCoord0", Apartments[i][apCoord][0]);
        cache_get_value_name_float(i, "apCoord1", Apartments[i][apCoord][1]);
        cache_get_value_name_float(i, "apCoord2", Apartments[i][apCoord][2]);
        cache_get_value_name_float(i, "apElevatorCoordFloor0", Apartments[i][apElevatorCoordFloor][0]);
        cache_get_value_name_float(i, "apElevatorCoordFloor1", Apartments[i][apElevatorCoordFloor][1]);
        cache_get_value_name_float(i, "apElevatorCoordFloor2", Apartments[i][apElevatorCoordFloor][2]);
        cache_get_value_name_float(i, "apHolCoord0", Apartments[i][apHolCoord][0]);
        cache_get_value_name_float(i, "apHolCoord1", Apartments[i][apHolCoord][1]);
        cache_get_value_name_float(i, "apHolCoord2", Apartments[i][apHolCoord][2]);
        cache_get_value_name_float(i, "apElevatorCoord0", Apartments[i][apElevatorCoord][0]);
        cache_get_value_name_float(i, "apElevatorCoord1", Apartments[i][apElevatorCoord][1]);
        cache_get_value_name_float(i, "apElevatorCoord2", Apartments[i][apElevatorCoord][2]);

        cache_get_value_name_float(i, "apRoomCoordOne0", Apartments[i][apRoomCoordOne][0]);
        cache_get_value_name_float(i, "apRoomCoordOne1", Apartments[i][apRoomCoordOne][1]);
        cache_get_value_name_float(i, "apRoomCoordOne2", Apartments[i][apRoomCoordOne][2]);
        cache_get_value_name_float(i, "apRoomCoordTwo0", Apartments[i][apRoomCoordTwo][0]);
        cache_get_value_name_float(i, "apRoomCoordTwo1", Apartments[i][apRoomCoordTwo][1]);
        cache_get_value_name_float(i, "apRoomCoordTwo2", Apartments[i][apRoomCoordTwo][2]);
        cache_get_value_name_float(i, "apRoomCoordThree0", Apartments[i][apRoomCoordThree][0]);
        cache_get_value_name_float(i, "apRoomCoordThree1", Apartments[i][apRoomCoordThree][1]);
        cache_get_value_name_float(i, "apRoomCoordThree2", Apartments[i][apRoomCoordThree][2]);
        cache_get_value_name_float(i, "apRoomCoordFour0", Apartments[i][apRoomCoordFour][0]);
        cache_get_value_name_float(i, "apRoomCoordFour1", Apartments[i][apRoomCoordFour][1]);
        cache_get_value_name_float(i, "apRoomCoordFour2", Apartments[i][apRoomCoordFour][2]);

        cache_get_value_name_float(i, "apRoomCoordOneExit0", Apartments[i][apRoomCoordOneExit][0]);
        cache_get_value_name_float(i, "apRoomCoordOneExit1", Apartments[i][apRoomCoordOneExit][1]);
        cache_get_value_name_float(i, "apRoomCoordOneExit2", Apartments[i][apRoomCoordOneExit][2]);
        cache_get_value_name_float(i, "apRoomCoordTwoExit0", Apartments[i][apRoomCoordTwoExit][0]);
        cache_get_value_name_float(i, "apRoomCoordTwoExit1", Apartments[i][apRoomCoordTwoExit][1]);
        cache_get_value_name_float(i, "apRoomCoordTwoExit2", Apartments[i][apRoomCoordTwoExit][2]);
        cache_get_value_name_float(i, "apRoomCoordThreeExit0", Apartments[i][apRoomCoordThreeExit][0]);
        cache_get_value_name_float(i, "apRoomCoordThreeExit1", Apartments[i][apRoomCoordThreeExit][1]);
        cache_get_value_name_float(i, "apRoomCoordThreeExit2", Apartments[i][apRoomCoordThreeExit][2]);
        cache_get_value_name_float(i, "apRoomCoordFourExit0", Apartments[i][apRoomCoordFourExit][0]);
        cache_get_value_name_float(i, "apRoomCoordFourExit1", Apartments[i][apRoomCoordFourExit][1]);
        cache_get_value_name_float(i, "apRoomCoordFourExit2", Apartments[i][apRoomCoordFourExit][2]);
        cache_get_value_name_float(i, "apRoomCoordExclusiveExit0", Apartments[i][apRoomCoordExclusiveExit][0]);
        cache_get_value_name_float(i, "apRoomCoordExclusiveExit1", Apartments[i][apRoomCoordExclusiveExit][1]);
        cache_get_value_name_float(i, "apRoomCoordExclusiveExit2", Apartments[i][apRoomCoordExclusiveExit][2]);

        CreatePickUpApartments(i,0);
        CreateDynamicActorApartmetns(i);
    }
}

alias:checkapartmentsroom("checkar")
CMD:checkapartmentsroom(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] <= 0 && PlayerInfo[playerid][pHidden] == 0 && PlayerInfo[playerid][pMedia] != 3) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу выполнить эту команду");
	
	if(sscanf(params, "s[121]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Посмотреть квартиры игрока [ /checkar ID ]");
	if(strlen(params[0]) > 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Длина никнейма не больше 20-ти символов");

	new giveplayerid, user_id = -1;
 	giveplayerid = ReturnUser(params[0], 1);
	if(IsPlayerConnected(giveplayerid)) user_id = PlayerInfo[giveplayerid][pID];

	new string[128];
	if(CheckRP_Nickname(params[0]))
	{
		mysql_format(pearsq, string,sizeof(string),"SELECT user_id, Name FROM `pp_igroki` WHERE `Name` = '%e'", params[0]);
		mysql_tquery(pearsq, string, "Call_finduser_checkapartmentsroom", "dd", playerid, -1);
	}
	else
	{
		if(!checknum(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Неверное имя или номер аккаунта [ /checkar Номер Аккаунта или Никнейм ]");
		if(user_id == -1) user_id = strval(params[0]);
		mysql_format(pearsq, string,sizeof(string),"SELECT user_id, Name FROM `pp_igroki` WHERE `user_id` = '%d'", user_id);
		mysql_tquery(pearsq, string, "Call_finduser_checkapartmentsroom", "dd", playerid, giveplayerid);
	}
	return 1;
}

// Поиск аккаунта для просмотра квартир игрока оффлайн
function Call_finduser_checkapartmentsroom(playerid, giveplayerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new user_id, name[24];
		cache_get_value_name_int(0, "user_id", user_id);
		cache_get_value_name(0, "Name", name, sizeof(name));

		new string[100];
		mysql_format(pearsq, string,sizeof(string),"SELECT aprId, aprStatus, aprOwn, aprOwnName FROM `apartmentsRoom` WHERE `aprOwn` = '%d'", user_id);
		mysql_tquery(pearsq, string, "Call_checkapartmentsroom", "dsdd", playerid, name, user_id, giveplayerid);
	}
	else ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
}

// Отображаем все
function Call_checkapartmentsroom(playerid, const str_name[], user_id, giveplayerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new line[214],lines[4096];
		format(line,sizeof(line),"{cccccc}Квартиры {ff9000}%s\n", str_name), strcat(lines,line);

		new newid;
		for(new f = 0; f < rows; f++)
		{
			cache_get_value_name_int(f, "aprId", newid);

            format(line,sizeof(line),"\n{cccccc}Слот %d | Квартира: %d [ № Квартирного дома: %d ]", f+1, ApartmentsRoom[newid][aprID]+1, ApartmentsRoom[newid][aprApartmentsID]+1), strcat(lines,line);
		}
		ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{999999}*",lines,"*","");
	}
	else ErrorMessage(playerid, "{FF6347}У этого игрока нет квартир");
	return true;
}

CMD:asellroom(playerid,const params[])
{
    new targetplayerid,aprid,string[120];
    if(PlayerInfo[playerid][pSoska] < 10) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i",aprid)) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Слить квартиру в продажу [ /asellroom Номер квартиры ]");
    aprid--;
    if(aprid > MAX_APARTMENTS_TABLE || aprid < 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Укажите корректный слот от 1 до 1600");
    targetplayerid = ReturnUser(ApartmentsRoom[aprid][aprOwn], 1);
	if(IsPlayerConnected(targetplayerid))
	{
		if(OnlineInfo[targetplayerid][oLogged] == 1) format(string, sizeof(string), "* Администратор %s продал вашу Квартиру №%d.", PlayerInfo[playerid][pName], aprid+1), SendClientMessage(targetplayerid, COLOR_LIGHTBLUE, string);
		for(new i; i < 10; i++)
        {   
            if(PlayerInfo[playerid][pApartmentsRoom][i] == aprid+1) 
            {
                PlayerInfo[playerid][pApartmentsRoom][i] = 0;
                break;
            }
        }
	}
	SlivApartments(aprid);
    return 1;
}

alias:moveapartments("mapartments")
CMD:moveapartments(playerid,const params[])
{
    new apid;
    if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
    if(sscanf(params, "i",apid)) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Создать Многоквартирный Дом [ /moveapartments Номер квартирного дома ]");
    if(apid > MAX_APARTMENTS || apid < 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Укажите корректный номер квартирного дома от 1 до %d", MAX_APARTMENTS);
    apid--;
    if(Apartments[apid][apStatus] == 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Нет такого квартирного дома");
    GetPlayerPos(playerid, Apartments[apid][apCoord][0], Apartments[apid][apCoord][1], Apartments[apid][apCoord][2]);
    DestroyDynamic3DTextLabel(ApartmentsLabel[apid]);
    DestroyDynamicPickup(ApartmentsPickup[apid]);
    DestroyDynamicMapIcon(ApartmentsMapIcon[apid]);
    CreatePickUpApartments(apid, 1);
    SaveApartments(apid);
    return 1;
}

alias:editclassapartments("ecapartments")
CMD:editclassapartments(playerid,const params[])
{
    new apid,class;
    if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
    if(sscanf(params, "ii",apid,class)) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Создать Многоквартирный Дом [ /editclassapartments Номер квартирного дома и Класс ]");
    if(apid > MAX_APARTMENTS || apid < 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Укажите корректный номер квартирного дома от 1 до %d", MAX_APARTMENTS);
    if(class > MAX_APARTMENTS_CLASS || class < 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Максимальное класс Квартирного Дома: %d", MAX_APARTMENTS_CLASS);
    apid--, class--;
    if(Apartments[apid][apStatus] == 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Нет такого квартирного дома");
    Apartments[apid][apClass] = class;
    UpdateClassApartments(apid,class,1);
    SaveApartments(apid);
    SuccessMessage(playerid, "Вы успешно сменили класс апартаментов.");
    return 1;
}

alias:editfloorapartments("efapartments")
CMD:editfloorapartments(playerid,const params[])
{
    new apid,floor;
    if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
    if(sscanf(params, "ii",apid,floor)) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Создать Многоквартирный Дом [ /editfloorapartments Номер квартирного дома и Кол.во Этажей ]");
    if(apid > MAX_APARTMENTS || apid < 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Укажите корректный номер квартирного дома от 1 до %d", MAX_APARTMENTS);
    if(floor > MAX_APARTMENTS_FLOOR || floor < 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Максимальное кол.во этажей: %d", MAX_APARTMENTS_FLOOR);
    apid--;
    if(Apartments[apid][apStatus] == 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Нет такого квартирного дома");
    Apartments[apid][apFloor] = floor;
    SaveApartments(apid);
    SuccessMessage(playerid, "Вы успешно сменили кол.во этажей апартаментов. Изменения вступят в силу после рестарта");
    return 1;
}

alias:deleteapartments("dapartments")
CMD:deleteapartments(playerid,const params[])
{
    new apid;
    if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
    if(sscanf(params, "i",apid)) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Удалить Многоквартирный Дом [ /deleteapartments Номер квартирного дома ]");
    if(apid > MAX_APARTMENTS || apid < 1) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Укажите корректный номер квартирного дома от 1 до %d", MAX_APARTMENTS);
    apid--;
    if(Apartments[apid][apStatus] == 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Нет такого квартирного дома");
    ApartmentsDelete(apid);
    SaveApartments(apid);
    SendClientMessage(playerid, COLOR_GRAY, "Вы успешно удалили квартирный дом %d", apid+1);
    SuccessMessage(playerid, "{44ff99}Вы успешно удалили Квартирный дом. \n\nЕсли вы не собираетесь создавать квартирный Дом то можете удалять еще\nЕсли же хотите создать, то сначала создайте, а потом удаляйте еще.");
    return 1;
}

stock ApartmentsDelete(apid)
{
    Apartments[apid][apStatus] = 0;
    Apartments[apid][apCoord][0] = 0.0;
    Apartments[apid][apCoord][1] = 0.0;
    Apartments[apid][apCoord][2] = 0.0;
    DestroyDynamicActorApartmetns(apid);
    DestroyDynamicPickup(ApartmentsPickup[apid]);
    DestroyDynamic3DTextLabel(ApartmentsLabel[apid]);
    DestroyDynamicMapIcon(ApartmentsMapIcon[apid]);
    new world;
    for(new i; i < MAX_APARTMENTS_FLOOR+1; i++)
    {
        world = Apartments[apid][apWorldDefineEntrance] + i - START_WORLD_APARTMENTS;
        DestroyDynamic3DTextLabel(ApartmentsElevatorLabel[world]);
    }
    for(new z = Apartments[apid][apPickupStart]; z < Apartments[apid][apPickupEnd]; z++)
    {
        DestroyDynamic3DTextLabel(ApartmentsIntLabel[z]);
        DestroyDynamicPickup(ApartmentsPickupInt[z]);
    }
    ApartmentsLastPickUpTumbler = apid;
    return 1;
}

stock ShowMenuApartmentsRoom(playerid)
{
    new line[100],lines[1000], quan = -1;
    for(new f; f < 10; f++)
    {
        List[f][playerid] = 0;
        if(PlayerInfo[playerid][pApartmentsRoom][f] != 0) 
        {
            format(line,sizeof(line),"{ff9000}Слот %d | {cccccc}№ Квартирного дома: %d [ Квартира: %d ]\n", f+1, ApartmentsRoom[PlayerInfo[playerid][pApartmentsRoom][f]-1][aprApartmentsID]+1, ApartmentsRoom[PlayerInfo[playerid][pApartmentsRoom][f]-1][aprID]+1), strcat(lines,line);
            quan++;
            List[quan][playerid] = f;
        }
    }
    if(quan == -1) return ErrorMessage(playerid,"У вас нет квартиры");
    DP[0][playerid] = quan;
    ShowDialog(playerid,APARTMENTS_DIALOG_MENU,DIALOG_STYLE_TABLIST,"{cccccc}Мои Квартиры",lines,"Выбрать","Назад");
    return 1;
}

stock ShowMenuApartmentsRoomDetail(playerid,roomid)
{
    new line[100],lines[500];
    format(line,sizeof(line),"{cccccc}Информация\n"), strcat(lines,line);
    if(ApartmentsRoom[roomid][aprLock] == 0) format(line,sizeof(line),"{cccccc}Дверь {99ff66}[ Открыта ]\n"), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}Дверь {FF6347}[ Закрыта ]\n"), strcat(lines,line);
    if(ApartmentsRoom[roomid][aprSellOwn] == 0) format(line,sizeof(line),"{99ff66}Выставить{cccccc} на продажу\n"), strcat(lines,line);
	else format(line,sizeof(line),"{ff6347}Снять{cccccc} с продажи\n"), strcat(lines,line);
    format(line,sizeof(line),"{ff6347}Слить в гос"), strcat(lines,line);
    ShowDialog(playerid,APARTMENTS_DIALOG_MYROOMS,DIALOG_STYLE_TABLIST,"{cccccc}Мои Квартиры",lines,"Выбрать","Назад");
    return 1;
}

stock ShowMenuApartmentsRoomInfo(playerid,roomid)
{
    new line[100],lines[500];
    format(line,sizeof(line),"{ff9000}Информация о квартире %d %s\n\n", ApartmentsRoom[roomid][aprID], ApartmentsRoom[roomid][aprArest] != 0 ? "{ff6347}[АРЕСТОВАНА]" : " "), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Номер квартирного дома: %d\n", ApartmentsRoom[roomid][aprApartmentsID]+1), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Класс квартирного дома: %s\n\n", ApartmentsClass[Apartments[ApartmentsRoom[roomid][aprApartmentsID]][apClass]]), strcat(lines,line);
    format(line,sizeof(line),"{cccccc}Гос.стоимость квартиры: {99ff66} %d$\n", Apartments[ApartmentsRoom[roomid][aprApartmentsID]][apPrice]), strcat(lines,line);
    if(ApartmentsRoom[roomid][aprSellOwn] > 0) format(line,sizeof(line),"{cccccc}Квартира выставлена на продажу вами за: {99ff66} %d$\n", ApartmentsRoom[roomid][aprSellOwn]), strcat(lines,line);
    ShowDialog(playerid,APARTMENTS_DIALOG_ROOMINFO,DIALOG_STYLE_MSGBOX,"{cccccc}Мои Квартиры",lines,"*","");
    return 1;
}

alias:gotoapartments("gotoa")
CMD:gotoapartments(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 1 && PlayerInfo[playerid][pMedia] == 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Телепортироваться к бизнесу [ /gotoa ID ]");
	if(params[0] >= 1 && params[0] <= MAX_APARTMENTS)
	{
	    if(Apartments[params[0]-1][apStatus] == 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Данный квартирный дом не установлен");
		SaveReturnCoord(playerid);
		S_SetPlayerVirtualWorld(playerid,0,0), PPSetPlayerInterior(playerid,0);
		PPSetPlayerPos(playerid,Apartments[params[0]-1][apCoord][0],Apartments[params[0]-1][apCoord][1],Apartments[params[0]-1][apCoord][2]);
		PPSetPlayerFacingAngle(playerid,0.0);
	}
	else SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Номер квартирного дома не меньше 1 и не больше %d",MAX_APARTMENTS);
	return 1;
}

alias:giveapartmentsroom("givea")
cmd:giveapartmentsroom(playerid,const params[]) 
{
    if(PlayerInfo[playerid][pSoska] < 19) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу использовать эту команду");
    new string[144], playa, tmp[24];
	if(sscanf(params, "s[24]i", tmp,params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать квартиру игроку [ /givea ID Номер квартиры ]");
	if(params[1] > 1600 || params[1] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Номер квартиры не меньше 1 и не больше 1600");
	if(ApartmentsRoom[params[1]-1][aprOwn] >= 1) return SendClientMessage(playerid, COLOR_GRAD5, "[ Мысли ]: Эта квартира занята [ /asellroom ]");
	playa = ReturnUser(tmp, 1);
    new result = -1;
	if(IsPlayerConnected(playa))
	{
        for(new i; i < 10; i++)
        {
            if(PlayerInfo[playa][pApartmentsRoom][i] != 0) continue;
            else
            {
                result = i;
                break;
            }
        }
        if(result == -1) return ErrorMessage(playerid, "{FF6347}У него нет свободных слотов под квартиру");
        PlayerInfo[playa][pApartmentsRoom][result] = ApartmentsRoom[params[1]-1][aprID]+1;
        ApartmentsRoom[params[1]-1][aprOwn] = PlayerInfo[playa][pID];
        ApartmentsRoom[params[1]-1][aprStatus] = 1;
        ApartmentsRoom[params[1]-1][aprSellOwn] = 0;
        format(ApartmentsRoom[params[1]-1][aprOwnName], 24,"%s", PlayerInfo[playa][pName]);
        SaveApartmentsRoom(params[1]-1);
        UpdateLabelApartments(params[1]-1);
        mysql_save(playa, 8);
        PlayerPlayMusic(playa);
		format(string, sizeof(string),"{0088ff}* [! ! !]: {FFFFFF}Администратор выдал вам Квартиру № %d {0088ff}[ /myhouse ]",params[1]);
		ShowDialog(playa,1700, 0, "{0088ff}*** {ffffff}  Установка Квартиры {0088ff}***", string, "Ок", "");
		format(string, sizeof(string), "{0088ff}* [! ! !]: {FFFFFF}Администратор выдал вам Квартиру № %d {0088ff}[ /myhouse ]",params[1]);
		SendClientMessage(playa, COLOR_LIGHTBLUE, string);
		BizLog("givea", PlayerInfo[playa][pID], PlayerInfo[playa][pName], PlayerInfo[playa][pPlaIP], params[1], 0, "Получил от Администратора");
		AdminLog("givea", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[playa][pID], PlayerInfo[playa][pName], PlayerInfo[playa][pPlaIP], params[1], "Выдал квартиру");
	}
    else
    {
        if(!CheckRP_Nickname(tmp)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
        mysql_format(pearsq, string,sizeof(string),"SELECT * FROM `pp_igroki` WHERE `Name` = '%e'", tmp);
        mysql_tquery(pearsq, string, "Call_OfflineGiveApartments", "d", params[1]-1);
    }
    return 1;
}

function Call_OfflineGiveApartments(roomid)
{
    new rows;
    cache_get_row_count(rows);
    new datad1, datad2[24], datad[10],string[16],result = -1,f_str[144];
    cache_get_value_name_int(0, "user_id", datad1);
    cache_get_value_name(0, "Name", datad2, sizeof(datad2));
    for(new i; i < 10; i++)
    {
        format(string, sizeof(string), "pApartmentsRoom%d",i);
        cache_get_value_name_int(0, "string", datad[i]);
        if(datad[i] == 0) 
        {
            result = i;
            break;
        }
    }

    ApartmentsRoom[roomid][aprOwn] = datad1;
    format(ApartmentsRoom[roomid][aprOwnName], 24,"%s", datad2);
    ApartmentsRoom[roomid][aprStatus] = 1;
    ApartmentsRoom[roomid][aprSellOwn] = 0;
    SaveApartmentsRoom(roomid);
    UpdateLabelApartments(roomid);

    mysql_format(pearsq, f_str,sizeof(f_str),"UPDATE `pp_igroki` SET `pApartmentsRoom%d` = '%d' WHERE `user_id` = '%d'", result,roomid+1, datad1);
    query_empty(pearsq, f_str);

	return true;
}

stock arestroom(playerid, roomid)
{
	new g = fraction(playerid);
	if(!IsAFunctionOrganization(57, g, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не сотрудник Правительства");
	if(!GetAccessRankOrg(playerid, g, 57, NO_FBI)) return 1;

	new string[144];
    if(ApartmentsRoom[roomid][aprArest] == 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Квартира уже арестован");
    if(ApartmentsRoom[roomid][aprTaxday] <= 15) return format(string, sizeof(string), "[ Мысли ]: Арест квартиры только при неуплате налогов от 16 дней [Эта Квартира: %d дней]", ApartmentsRoom[roomid][aprTaxday]), SendClientMessage(playerid, COLOR_GREY, string);
    if(ApartmentsRoom[roomid][aprSellOwn] >= 1) ApartmentsRoom[roomid][aprSellOwn] = 0;

    ApartmentsRoom[roomid][aprArest] = 1;
    SaveApartmentsRoom(roomid);
    PlayerPlaySound(playerid,6401,0,0,0);
    format(string, sizeof(string), "{FFFFFF}** [%s] {00C6FF}%s арестовал Квартиру № {ffffff}%d **", getNameRank(playerid), PlayerInfo[playerid][pName],roomid+1);
    SendRadioMessage(7, COLOR_ALLDEPT, string);
    format(string, sizeof(string), "<< %s %s арестовал Квартиру № %d >>", getNameRank(playerid), PlayerInfo[playerid][pName], roomid+1);
    OOCOff(COLOR_LIGHTRED, string);
    UpdateLabelApartments(roomid);
    OrgLog(7, "arestroom", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", roomid, "Арестовал Квартиру");
    HouseLog(1, "arestroom", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], roomid, 0, "Арестовал Квартиру");
    GiveUnit(playerid, 7);
    ApplyAnimation(playerid,"PED","endchat_01",4.0, false, true, true, false, false);
    notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], ApartmentsRoom[roomid][aprOwn], ApartmentsRoom[roomid][aprOwnName], "Квартира арестована за неуплату налогов");
    return 1;
}
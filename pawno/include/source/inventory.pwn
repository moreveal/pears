//==================================
//=====[ Параметры Инвентарей ]=====
//==================================
// Добавление нового Предмета:
// 0. INVENTER + 1 предмет
// 1. fdrawName и fdrawNameEN - его название в текстдравах
// 2. friskName - просто его название
// 3. friskPick - его модель объекта на текстдравах
// 4. friskKol - имеет ли предмет множественное количество
// 5. friskDefault - гос. цена предмета

// Не количественный:
// 6. player_tile (юзать его только и всё)

// Количественный:
// 6.  player_tile (юзать предмет)
// 7.  v_limit - лимиты багажника (сколько помещается)
// 8.  d_limit - лимиты дома (сколько помещается)
// 9. i_limit - лимиты инвентаря (сколько помещается)

#define INVENTER 181 // Максимальный ID (обычный предмет)

// Тип товара (0 обычный, 1 оружие, 2 аксессуар, 3 одежда, 4 мебель)

new fdrawName[][] = // Название Вещи
{
    "","X‡EЂ","€O‡OЏOE_KO‡’‰O","ЂYЏ‘‡KA","ЏPA‹A","Њyc¦a¬ Џa—ћe¦ka","‚P…Ђ‘","ЊOPOЋOK","AЊЏEЌKA","KAH…CЏPA","ЊO•C_CO_‹€P‘‹ЌAЏKO…",
    "ЂOMЂA","ѓEЏOHAЏOP","‹EPE‹KA","Њ…‹O","none","ЊAЌKA_C…‚APEЏ","ЂPOH•","HA„…‹KA","OЏM‘ЌK…","P‘ЂA","PA‰…•",
    "M•CO","MEЋOK","ЋAЋKA_ЏAKC…","ѓEH’‚…","CMAPЏЃOH","AMMO 20,8mm","AMMO 11,43mm","AMMO 5,45mm","AMMO 45mm","YѓOЌKA","ЃOHAP…K",
	"BOX","TOY","MAN","CHRISTMAS GIFT","ЋAMЊAHCKOE","ЂOKA‡","YЊAKO‹KA","ЃE…EP‹EPK","ЂEH‚A‡’CK…E O‚H…","HOYЏЂYK","ЋOKEP",
	"‡OЊAЏA","KAPЏA MOP•KA","MOPCKA• €‹E€ѓA","PAKYЋKA","HAѓY‹HA• ‡OѓKA","CYHѓYK C COKPO‹…ЉAM…", "‡O‹YЋKA ѓ‡• AKY‡‘","ЊACЊOPЏ",
	"Y‚‡…","€A„…‚A‡KA","„APEHOE M•CO","„APEHA• P‘ЂA","Џ…ЏAH","MO‡…ЂѓEH","YPAH","MEЏEOP…Џ","ЊA‡‡Aѓ……","‚E‡…… 3","PlayBoy",
	"MEѓ KAPЏA","E-AMMO 20,8mm","E-AMMO 11,43mm","E-AMMO 5,45mm","E-AMMO 45mm","MYCOP","TPYЊ","Ђ…HT","ЊPE€EP‹AЏ…‹‘",
	"‡EKAPCЏ‹O","‡EKAPCЏ‹O","‡EKAPCЏ‹O","‡EKAPCЏ‹O","‡EKAPCЏ‹O","‡EKAPCЏ‹O","‡EKAPCЏ‹O","‡EKAPCЏ‹O","‡EKAPCЏ‹O","‡EKAPCЏ‹O",
	"‡EKAPCЏ‹O","‡EKAPCЏ‹O","‡EKAPCЏ‹O","‡EKAPCЏ‹O","‡EKAPCЏ‹O","‡EKAPCЏ‹O","CEMEHA","KAPЏOЋKA","MOHЏ…PO‹KA","KAPЏA COKPO‹…Љ",
	"ѓPE‹H•• ‹A3A","YPHA","C‡…ЏOK","CЏAЏY“ЏKA","ЂOKA‡ C KPO‹’”","KYXOHH‘† HO„","ЂOKA‡ C KPO‹’”","ЂAHAH","•Ђ‡OKO","AЊE‡’C…H",
	"MO‡OKO","Џ‘K‹A","KAPЏOЋKA","ЏOMAЏ","YѓOЂPEH…E","Ђ‘Ќ’• KPO‹’","CEMEHA Џ‘K‹‘","CEMEHA_ЏOMAЏO‹","PACCAѓA","KOCЏ…",
	"‹OѓKA","‹…HO","‹…CK…","KOH’•K","ЂP“Hѓ…","C…ѓP","C…ѓP","Њ…‹O","SPRUNK","KOЃE",
	"ЂOKA‡","KPY„KA","SPRUNK","ЂYP‚EP","ЂYP‚EP","PO‡‡","HAЂOP_1","HAЂOP_2","HAЂOP_3","HAЂOP_4",
	"HAЂOP_5","HAЂOP_6","HAЂOP_7","HAЂOP_8","HAЂOP_9","HAЂOP_10","HAЂOP_11","SPRUNK","KOC•K","XOЏ ѓO‚",
	"C…‚APEЏA","C…‚APA","YЌEЂH…K","YЌEЂH…K","YЌEЂH…K","YЌEЂH…K","YЌEЂH…K","YЌEЂH…K","YЌEЂH…K","YЌEЂH…K",
	"YЌEЂH…K","YЌEЂH…K","YЌEЂH…K","YЌEЂH…K","ЊPA‹A","‡…‰EH3…•","ЊPA‹A","‡…‰EH3…•","ѓЊ…‡OM","‡…‰EH3…•",
	"‡…‰EH3…•","TOPT","KYCOK ЏOPЏA", "Њ…‰‰A", "Њ…‰‰A ѓOM.", "KYCOK Њ…‰‰‘", "M•CO ‹ YЊAK.", "C‘PO† CЏE†K", "„APEH‘† CЏE†K", "‡OMЏ…K X‡EЂA",
	"COK AЊE‡’C…H.", "COK •Ђ‡OЌ.", "O‹OЉ…", "C…‚HA‡…?A‰…•", "C…‚HA‡…?A‰…•", "C…‚HA‡…?A‰…•", "ЏOЊ‡…‹O", "MOPO„EHOE", "CЊ…ѓ‘", "…3O‡EHЏA",
	"3AЊЌACЏ’ ЂOMЂ‘"
};
new fdrawNameEN[][] = // Название Вещи на Английском
{
    "","BREAD","WEDDING RING","BOTTLE","WEED","NULL PILL","MUSHROOMS","POWDER","AID KIT","CANISTER","EXPLOSIVES",
    "BOMB","DETONATOR","ROPE","BEER","POISON","CIGARETTES","ARMOR","BAIT","MASTER KEY","FISH","TRANSMITTER",
    "MEAT","BAG","TAXI CHECKER","MONEY","SMARTPHONE","AMMO 20,8mm","AMMO 11,43mm","AMMO 5,45mm","AMMO 45mm","FISHING ROD","LANTERN",
	"BOX","TOY","MAN","CHRISTMAS GIFT","CHAMPAGNE","GLASS","PACKAGING","FIREWORK","SPARKLER","LAPTOP","SHOCKER",
	"SHOVEL","SEA MAP","STARFISH","SEASHELL","INFLATABLE BOAT","TREASURES", "SHARK TRAP","PASSPORT",
	"COALS","LIGHTER","FRIED MEAT","FRIED FISH","TITANIUM","MOLYBDENUM","URANUS","METEORITE","PALLADIUM","HELIUM 3","PLAYBOY",
	"MEDICAL CARD","E-AMMO 20,8mm","E-AMMO 11,43mm","E-AMMO 5,45mm","E-AMMO 45mm","TRASH","CORPSE","BANDAGE","CONDOMS",
	"MEDICINE","MEDICINE","MEDICINE","MEDICINE","MEDICINE","MEDICINE","MEDICINE","MEDICINE","MEDICINE","MEDICINE",
	"MEDICINE","MEDICINE","MEDICINE","MEDICINE","MEDICINE","MEDICINE","SEEDS","POTATO","TIRE IRON","TREASURE MAP",
	"ANCIENT VASE","URN","GOLD","STATUETTE","GLASS OF BLOOD","KITCHEN KNIFE","GLASS OF BLOOD","BANANA","APPLE","ORANGE",
	"MILK","PUMPKIN","POTATO","TOMATO","FERTILIZER","BOVINE BLOOD","PUMPKIN SEEDS","TOMATO SEEDS","POTATO SEEDLINGS","DICE",
	"VODKA","WINE","WHISKEY","COGNAC","BRANDY","APPLE CIDER","CHERRY CIDER","DRAFT BEER","SPRUNK","COFFEE",
	"GLASS","CUP","SPRUNK","BURGER","BURGER","ROLL","SET_1","SET_2","SET_3","SET_4",
	"SET_5","SET_6","SET_7","SET_8","SET_9","SET_10","SET_11","SPRUNK","JOINT","HOT DOG",
	"CIGARETTE","CIGAR","TEXTBOOK","TEXTBOOK","TEXTBOOK","TEXTBOOK","TEXTBOOK","TEXTBOOK","TEXTBOOK","TEXTBOOK",
	"TEXTBOOK","TEXTBOOK","TEXTBOOK","TEXTBOOK","LICENSE","LICENSE","LICENSE","LICENSE","DIPLOMA","GUN LICENSE 1",
	"GUN LICENSE 2","WEDDING CAKE","PIECE OF CAKE","PIZZA","PIZZA HOME","SLICE OF PIZZA","MEAT IN A PACK","RAW STEAK","FRIED STEAK","SLICE OF BREAD",
	"ORANGE JUICE","APPLE JUICE","VEGETABLES","ALARM","ALARM","ALARM","FUEL", "ICE CREAM", "PILL", "DUCT TAPE",
	"BOMB SPARE PART"
};
new friskName[][] = // Название Вещи
{
    "","Хлеб","Золотое Кольцо","Бутылка","Трава","Таблетки П.","Грибы","Порошок","Аптечка","Канистра","Пояс с Взрывчаткой", // 0 - 10
    "Бомба","Пульт от Бомбы","Верёвка","Пиво","Яд","Пачка Сигарет","Броня","Наживка","Отмычки","Рыба","Рация", // 11 - 21
    "Мясо","Мешок","Шашка Такси","Деньги","Смартфон","Ammo 20,8mm","Ammo 11,43mm","Ammo 5,45mm","Ammo 45mm","Удочка","Фонарик", // 22 - 32
	"Ящик","Ящик с Товаром","Человек","Новогодний Подарок","Шампанское","Бокал","Упаковка","Феиерверк","Бенгальские Свечи","Ноутбук","Шокер", // 33 - 43
	"Лопата","Карта Моряка","Морская Звезда","Ракушка","Надувная Лодка","Сундук с Сокровищами","Ловушка для Акулы","Паспорт", // 44 - 51
	"Угли","Зажигалка","Жареное Мясо","Жареная Рыба","Титан","Молибден","Уран","Метеорит","Палладий","Гелий 3","PlayBoy", // 52 - 62
	"Мед.Карта","E-Ammo 20,8mm","E-Ammo 11,43mm","E-Ammo 5,45mm","E-Ammo 45mm","Мусор","Труп","Бинт","Презервативы", // 63 - 71
	"Хламидиуберин","Гоногон","Сифистоп","Радиануклин","Перитонин","Грибкоубивин","Дерматитогон","Акнестопин","Порошкозаменин","Никотиновый пластырь", // 72 - 81
	"Бухлозаменин","Гастритоуберин","Язвазаживин","Колдрекс","Терафлю","Анвимакс","Семена травы","Картошка","Монтировка", "Карта сокровищ", // 82 - 91
	"Древняя Ваза","Урна с прахом","Слиток золота","Статуэтка","Бокал с кровью","Кухонный Нож","Бокал с кровью","Банан","Яблоко","Апельсин", // 92 - 101
	"Молоко","Тыква","Картошка","Томат","Удобрение","Бычья Кровь","Семена Тыквы","Семена Томатов","Картошка Рассада","Кости", // 102 - 111
	"Водка","Вино","Виски","Коньяк","Брэнди","Сидр Яблочный","Сидр Вишневый","Пиво Разливное","Sprunk","Кофе", // 112 - 121
	"Бокал", "Кружка", "Sprunk в стакане", "Бургер", "Бургер", "Ролл", "Набор 1", "Набор 2", "Набор 3", "Набор 4",  // 122 - 131
	"Набор 5", "Набор 6", "Набор 7", "Набор 8", "Набор 9", "Набор 10", "Набор 11", "Sprunk Открытый", "Косяк", "Хот-дог", // 132 - 141
	"Сигарета", "Сигара", "Учебник ПДД", "Основы вождения", "Основы пилотирования", "Винтокрылые машины", "Управление катерами", "Основы мототранспорта", "Учебник русского языка", "Учебник японского языка", // 142 - 151
	"Учебник итальянского языка", "Учебник китайского языка", "Учебник испанского языка", "Учебник арабского языка", "Водительские права", "Лицензия пилота", "Права на катер", "Лицензия мототранспорта", "Диплом о высшем образовании", "Лицензия на оружие 1", // 152 - 161
	"Лицензия на оружие 2","Свадебный торт", "Кусок торта", "Пицца", "Пицца Домашняя", "Кусок пиццы", "Мясо в упаковке", "Сырой стейк", "Жареный стейк", "Ломтик хлеба",  // 162 - 171
	"Апельсиновый сок", "Яблочный сок", "Овощи", "Дом Сигнализация 1 ур.", "Дом Сигнализация 2 ур.", "Дом Сигнализация 3 ур.", "Топливо", "Мороженое", "Таблетка","Изолента", // 172 - 181
	"Запчасть бомбы" // 182 --
};
new friskPick[] = // ID Модельки в Инвентаре (обычный предмет)
{
    0,19579,2710,1520,19473,1241,1578,1279,11738,1650,19515, // 0 - 10
    1654,364,19088,1486,2057,19897,19142,1455,18644,19630,19942, // 11 - 21
    2806,2060,19308,1212,18872,2061,2061,2061,2061,18632,18641, // 22 - 32
    3014,2484,1314,19054,19824,19819,19921,3016,19616,19893,18642, // 33 - 43
    337,19171,902,2782,473,2969,2803,1581, // 44 - 51
    19573,19998,19882,19630,3930,3930,3930,3931,2040,2976,2826, // 52 - 62
    2894,2061,2061,2061,2061,1265,2908,11747,321, // 63 - 71
    11748,11748,11748,11748,11748,11748,11748,11748,11748,11748, // 72 - 81
    11748,11748,11748,11748,11748,11748,19562,19575,18634,19169, // 82 - 91
    14705,2709,19941,1276,1667,19583,1667,19578,19576,19574, // 92 - 101
    19569,19320,19575,19577,1644,1667,2752,2752,2060,1852, // 102 - 111
    1668,19822,19821,19820,19823,1544,1543,1951,2601,19835, // 112 - 121
    19818,1666,1546,2703,2768,2769,2212,2213,2214,2215,  // 122 - 131
    2216,2217,2221,2222,2223,2353,2354, 2601,3027,19346, // 132 - 141
    19625,3044,2894,2894,2894,2894,2894,2894,2894,2894, // 142 - 151
    2894,2894,2894,2894,2684,2684,2684,2684,2684,2684, // 152 - 161
    2684,19525,11739, 19571,19580,2702,19560,19582,19882,19883, // 162 - 171
    19563,19564,19572,1614,1616,1622,3465,19568, 1241,11747, // 172 - 181
	3082
};
new friskKol[] = // Имеет ли предмет множественное количество (обычный предмет)
{
    0,0,0,0,1,1,1,1,1,1,0,
    0,0,0,0,0,0,0,1,1,1,0,
    0,0,0,1,0,1,1,1,1,0,0,
    0,0,0,0,0,0,0,0,1,0,0,
    0,0,1,1,0,0,0,0,
    0,0,0,1,0,0,0,0,1,1,0,
    0,1,1,1,1,0,0,0,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,1,0,1,1,1,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,1,0,
    1,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,1,0,1,1,
	0
};
new friskDefault[] = // Гос. стоимости предметов
{
    0,60,3500,5,500,1000,500,1000,3000,100,1, // 10
    1,1,450,60,1,150,5000,30,650,50,3500, // 21
    700,900,1100,1,25000,60,35,20,50,1500,700, // 32
    1,1,1,1,550,250,1500,2300,150,75000,3000, // 43
    2500,900,500,1000,45000,350000,500,1, // 51
    450,100,2300,50,1,1,1,1,900,800,2500, // 62
    1,600,350,200,500,1,5000,900,300, // 71
    7000,5000,8000,13000,23000,19000,16000,14000,24500,1300, // 81
    2000,3000,9000,900,900,900,350,50,850,35000, // 91
	150,150,10,9600,950000,490,7000,40,40,40, // 101
	10,3500,350,350,1500,7900,1200,400,400,5900, // 111
	450,690,1300,3900,7900,80,80,190,80,90, // 121
	250,150,80,190,190,250,1200,1350,1450,1490, // 131
	1490,1800,850,950,1030,700,750,80,500,130, // 141
	15,900,1500,1500,1500,1500,1500,1500,1500,1500, // 151
	1500,1500,1500,1500,15000,350000,60000,26000,500000,30000, // 161
	150000,45000,100,1200,1200,200,500,500,800,10, // 171
	200,200,1,30000,120000,390000,40,300,1000, 1000, // 181
	1000 // 182
};
new friskPrice[INVENTER];
//==================================
//==================================
//==================================


new gunName[][] =
{
    "Кулак", "Кастет", "Клюшка", "Полицейская дубинка", "Нож", "Бита", "Лопата", "Кий", "Катана", "Бензопила",
    "Фаллоимитатор", "Фаллоимитатор", "Фаллоимитатор", "Фаллоимитатор", "Цветы", "Трость", "Граната", "Дымовая шашка", "Коктейль молотова","none","none","none", "Colt",
    "Электрошокер", "Desert eagle", "Дробовик", "Обрез", "Скорострельный дробовик", "Uzi", "MP5", "AK-47", "M4",
    "Tec-9", "Винтовка", "Снайперская винтовка", "RPG", "Базука", "Огнемёт", "Миниган", "Взрыв. пакет", "Детонатор", "Балончик",
    "Огнетушитель", "Фотоаппарат", "Ночное видение", "Тепловизор", "Парашют", "Каска" ,"", "Транспорт", "Винты Вертолёта",
	"Взрыв","","Утонул","Падение"
};
new gunDraw[][] =
{
    "NONE", "KNUCKLES", "GOLFCLUB", "NITESTICK", "KNIFE", "BAT", "SHOVEL", "POOLSTICK", "KATANA", "CHAINSAW",
    "DILDO", "DILDO", "DILDO", "DILDO", "FLOWER", "CANE", "GRENADE", "TEARGAS", "MOLTOV","","","", "COLT",
    "SHOCKER", "DESERT_EAGLE", "SHOTGUN", "SAWEDOFF", "SHOTGSPA", "UZI", "MP5", "AK47", "M4",
    "TEC9", "RIFLE", "SNIPER_RIFLE", "RPG", "HS ROCKET", "FLAMETHROWER", "MINIGUN", "SATCHEL", "DETONATOR", "SPRAYCAN",
    "FIRE", "CAMERA", "NIGHT", "TERMAL", "PARACHUTE", "Fake Pistol" ,"", "Транспорт", "Винты Вертолёта",
	"Взрыв","","Утонул","Падение"
};
new friskGun[] = // ID Модельки Оружия в Инвентарях
{
    0,331,333,334,335,336,337,338,339,341,321,
    322,323,324,325,326,342,343,344,0,0,0,
    346,347,348,349,350,351,352,353,355,356,372,
    357,358,359,360,361,362,363,364,365,366,367,368,369,371
};
new gunPrice[48];


new Page[MAX_REALPLAYERS]; // Какая страница открыта в инвентаре
new Pagetwo[MAX_REALPLAYERS]; // Какая страница открыта во второй вкладке инвентаря

new PlayerText:PlaNestPick[40][MAX_REALPLAYERS]; // Кнопка предмета в инвентаре
new PlayerText:PlaNestPickNum[40][MAX_REALPLAYERS]; // Текст каждой кнопки предмета (отображение количества)
new PlayerText:PlaNestOthe[3][MAX_REALPLAYERS]; // Скин персонажа и выбранный предмет
new PlayerText:PlaNestPrice[MAX_REALPLAYERS]; // Стоимость товара

CMD:gthing(playerid, const params[]) // Выдать предмет (НЕ ИСПОЛЬЗОВАТЬ эту команду без надобности, она не учитывает кучу условий для разных предметов)
{
    if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не администратор");
    if(sscanf(params, "iii",params[0],params[1],params[2])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать предмет в инвентарь [ ID, Предмет, Кол-во ]");
    
    // Тип товара (0 обычный, 1 оружие, 2 аксессуар, 3 одежда, 4 мебель, 5 транспорт)
    new put_inva = GiveThingPlayer(params[0], params[1], params[2], 0, 0, 0, 0, 9999);
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре");
	return 1;
}

CMD:gthingunix(playerid, const params[]) // Выдать предмет (НЕ ИСПОЛЬЗОВАТЬ эту команду без надобности, она не учитывает кучу условий для разных предметов)
{
    if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не администратор");
    if(sscanf(params, "iiii",params[0],params[1],params[2],params[3])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать предмет в инвентарь [ ID, Предмет, Кол-во, UNIX ]");
    new unix = gettime();
    // Тип товара (0 обычный, 1 оружие, 2 аксессуар, 3 одежда, 4 мебель, 5 транспорт)
    new put_inva = GiveThingPlayer(params[0], params[1], params[2], unix+params[3], 0, 0, 0, 9999);
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре");
	return 1;
}

stock tile_second(playerid, invatab) // Клацаем по ячейкам в правом разделе
{
	if(OnlineInfo[playerid][oShowInterface] != 1) return 0;
	PlayerPlaySound(playerid,17803,0,0,0);
	if(LoadPick[playerid] != 9999) return reset_aksess_tile(playerid); // Сбрасываем выбранные аксесуары
	if(LoadGun[playerid] != 9999) return reset_gun_tile(playerid); // Сбрасываем выбранное оружие
	
	new fpick, tab, inva = invatab-20, fpara, thingType, thingPack;
	if(Tabs_Load[playerid] == 1) // Лавка Товаров
	{
	    tab = OnlineInfo[playerid][oShowInterfaceGoods];
	    if(!IsOnline(tab)) return closetab(playerid);
		fpick = PlayerInfo[tab][pMarkInven][inva];
		fpara = PlayerInfo[tab][pMarkInvenPara][inva];
		thingType = PlayerInfo[tab][pMarkInvenType][inva];
		thingPack = PlayerInfo[tab][pMarkInvenPack][inva];
	}
	else if(Tabs_Load[playerid] == 2) // Дом
	{
		tab = OnlineInfo[playerid][oShowInterfaceDom];
		fpick = DomInfo[tab][dInvent][inva];
		fpara = DomInfo[tab][dInvPara][inva];
		thingType = DomInfo[tab][dInvType][inva];
		thingPack = DomInfo[tab][dInvPack][inva];
	}
	else if(Tabs_Load[playerid] == 3) // Склад Организации
	{
		tab = OnlineInfo[playerid][oShowInterfaceSklad];
		fpick = OrganInfo[tab][gInvent][inva];
		thingType = OrganInfo[tab][gInvType][inva];
		thingPack = 0;
	}
	else if(Tabs_Load[playerid] == 4) // Арендованный Склад
	{
		tab = OnlineInfo[playerid][oShowInterfaceRent];
		fpick = WhInfo[tab][wInvent][inva];
		thingType = WhInfo[tab][wInvType][inva];
		thingPack = 0;
	}
	else if(Tabs_Load[playerid] == 5) // Багажник
	{
		tab = OnlineInfo[playerid][oShowInterfaceVeh];
		fpick = VehInfo[tab][vInvent][inva];
		fpara = VehInfo[tab][vInvPara][inva];
		thingType = VehInfo[tab][vInvType][inva];
		thingPack = VehInfo[tab][vInvPack][inva];
	}
	else if(Tabs_Load[playerid] == 6) // Мои Товары
	{
		fpick = PlayerInfo[playerid][pMarkInven][inva];
		fpara = PlayerInfo[playerid][pMarkInvenPara][inva];
		thingType = PlayerInfo[playerid][pMarkInvenType][inva];
		thingPack = PlayerInfo[playerid][pMarkInvenPack][inva];
	}
	else if(Tabs_Load[playerid] == 7) // Выбошенные Предметы
	{
		if(MyThrow[inva][playerid] >= 0)
		{
			fpick = ThrowInfo[MyThrow[inva][playerid]][tId];
			fpara = ThrowInfo[MyThrow[inva][playerid]][tPara];
			thingType = ThrowInfo[MyThrow[inva][playerid]][tType];
			thingPack = ThrowInfo[MyThrow[inva][playerid]][tPack];
		}
	}
	else if(Tabs_Load[playerid] == 8) // Мусорный Контейнер
	{
		tab = OnlineInfo[playerid][oShowInterfaceTrash];
		fpick = gTrash[inva][tab];
		fpara = gTrashPara[inva][tab];
		thingType = gTrashType[inva][tab];
		thingPack = gTrashPack[inva][tab];
	}
	else if(Tabs_Load[playerid] == 9) // Биз
	{
		tab = OnlineInfo[playerid][oShowInterfaceBiz];
		fpick = BizzInfo[tab][bInvent][inva];
		fpara = BizzInfo[tab][bInvPara][inva];
		thingType = BizzInfo[tab][bInvType][inva];
		thingPack = BizzInfo[tab][bInvPack][inva];
	}
	
	if(fpick == 0) // Если клацаем по пустой ячейке
	{
		if(OnlineInfo[playerid][oInventSelectLeft] == 9999) // Если ячейка в левом разделе не выбрана
		{
			if(OnlineInfo[playerid][oInventSelectRight] != 9999 && OnlineInfo[playerid][oInventSelectRight] != inva) // Перекладываем
			{
				if(Tabs_Load[playerid] == 2) shift_dom(playerid, tab, OnlineInfo[playerid][oInventSelectRight], inva);
				else if(Tabs_Load[playerid] == 3) shift_sklad(playerid, tab, OnlineInfo[playerid][oInventSelectRight], inva);
				else if(Tabs_Load[playerid] == 4) shift_rent(playerid, tab, OnlineInfo[playerid][oInventSelectRight], inva);
				else if(Tabs_Load[playerid] == 5) shift_boot(playerid, tab, OnlineInfo[playerid][oInventSelectRight], inva);
				else if(Tabs_Load[playerid] == 6) shift_goods(playerid, OnlineInfo[playerid][oInventSelectRight], inva);
				else if(Tabs_Load[playerid] == 9) shift_biz(playerid, tab, OnlineInfo[playerid][oInventSelectRight], inva);
				else i_resettabs(playerid);
			}
		}
		else if(OnlineInfo[playerid][oInventSelectLeft] != 9999) // Кладём предмет из инвентаря в другой
		{
		    new myinva = OnlineInfo[playerid][oInventSelectLeft], myfpick = PlayerInfo[playerid][pInven][myinva], myThingType = PlayerInfo[playerid][pInvenType][myinva], myThingPack = PlayerInfo[playerid][pInvenPack][myinva];
		    if(NotGiveThing(myfpick, myThingType)) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя передавать, продавать или убирать"), i_resetveshi(playerid);
		    if(Tabs_Load[playerid] == 2) // Дом
			{
			    if(myThingType == 0 && myThingPack == 0)
			    {
			        if(friskKol[myfpick] == 1)
			        {
			            OnlineInfo[playerid][oInventSelectRight] = inva;
						format(store,sizeof(store),"{cccccc}Чтобы положить в дом {ff9000}%s {cccccc}введите количество\nНе меньше 1 и не больше 1.000.000",GetNameThing(1, myfpick, myThingType, myThingPack));
						ShowDialog(playerid,773,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",store,"Принять","Отмена");
						return 1;
			        }
			    }
			    put_dom(playerid, myinva, tab, myfpick, PlayerInfo[playerid][pInvenQuan][myinva], inva, myThingType, myThingPack);
			}
			else if(Tabs_Load[playerid] == 3 || Tabs_Load[playerid] == 4) return ErrorMessage(playerid, "{FF6347}Вы не можете положить предметы на склад\n\n{cccccc}Только ящики с оружием и аммуницией"), i_resetveshi(playerid); // Склады
			else if(Tabs_Load[playerid] == 5) // Багажник
			{
			    if(myThingType == 0 && myThingPack == 0)
			    {
			        if(friskKol[myfpick] == 1)
			        {
			            OnlineInfo[playerid][oInventSelectRight] = inva;
						format(store,sizeof(store),"{cccccc}Чтобы положить в багажник {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(1, myfpick, myThingType, myThingPack));
						ShowDialog(playerid,775,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",store,"Принять","Отмена");
						return 1;
			        }
			    }
			    put_boot(playerid, myinva, tab, myfpick, PlayerInfo[playerid][pInvenQuan][myinva], inva, myThingType, myThingPack);
			}
			else if(Tabs_Load[playerid] == 6) // Мои Товары
			{
			    if(myThingType == 0 && myThingPack == 0)
			    {
			        if(friskKol[myfpick] == 1)
			        {
			            OnlineInfo[playerid][oInventSelectRight] = inva;
						format(store,sizeof(store),"{cccccc}Чтобы выставить на продажу {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(1, myfpick, myThingType, myThingPack));
						ShowDialog(playerid,1103,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",store,"Принять","Отмена");
						return 1;
			        }
			    }
			    new put_invent = put_goods(playerid, myinva, myfpick, PlayerInfo[playerid][pInvenQuan][myinva], inva);
			    if(put_invent == -1) return ErrorMessage(playerid, "{FF6347}В разделе товаров нет места"), i_resetveshi(playerid);
			}
			else if(Tabs_Load[playerid] == 9) return ErrorMessage(playerid, "{FF6347}На склад бизнеса нельзя класть обычные предметы\n\n{cccccc}Только мебель из IKEA или багажника автомобиля"), i_resetveshi(playerid);
			else i_resetveshi(playerid);
		}
	}
	else if(fpick > 0) // Что-то Лежит
	{
		if(OnlineInfo[playerid][oInventSelectRight] == 9999) // Выделяем
		{
		    if(Pagetwo[playerid] == 0 && inva <= 19) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva+20][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva+20][playerid]);
			else if(Pagetwo[playerid] == 1 && inva >= 20 && inva <= 39) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva][playerid]);
			else if(Pagetwo[playerid] == 2 && inva >= 40 && inva <= 59) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva-20][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva-20][playerid]);
			else if(Pagetwo[playerid] == 3 && inva >= 60 && inva <= 79) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva-40][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva-40][playerid]);
			i_infofpick(playerid, fpick, inva, Tabs_Load[playerid], fpara, thingType, thingPack);
			OnlineInfo[playerid][oInventSelectRight] = inva;
			if(OnlineInfo[playerid][oInventSelectLeft] != 9999) // Кладём (Если предмет количественный, мы складируем его поверх такого-же)
			{
			    if(Tabs_Load[playerid] == 9) return ErrorMessage(playerid, "{FF6347}На склад бизнеса нельзя класть обычные предметы\n\n{cccccc}Только мебель из IKEA или багажника автомобиля"), i_resetveshi(playerid);
				if(Tabs_Load[playerid] == 1 || Tabs_Load[playerid] == 6 || Tabs_Load[playerid] == 7) return i_resetveshi(playerid);
			    new myinva = OnlineInfo[playerid][oInventSelectLeft];
			    if(PlayerInfo[playerid][pInven][myinva] == 0 || PlayerInfo[playerid][pInven][myinva] != fpick) return i_resetveshi(playerid);
			    new myfpick = PlayerInfo[playerid][pInven][myinva], myThingType = PlayerInfo[playerid][pInvenType][myinva], myThingPack = PlayerInfo[playerid][pInvenPack][myinva];
			    
			    if(myThingType == 0 && myThingPack == 0)
			    {
			        if(friskKol[myfpick] == 1)
			        {
			        	if(Tabs_Load[playerid] == 2) // Дом
						{
							format(store,sizeof(store),"{cccccc}Чтобы положить в дом {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(1, myfpick, myThingType, myThingPack));
							ShowDialog(playerid,773,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",store,"Принять","Отмена");
						}
						else if(Tabs_Load[playerid] == 3 || Tabs_Load[playerid] == 4) return ErrorMessage(playerid, "{FF6347}Вы не можете положить предметы на склад\n\n{cccccc}Только ящики с оружием и аммуницией"), i_resetveshi(playerid); // Склады
						else if(Tabs_Load[playerid] == 5) // Багажник
						{
							format(store,sizeof(store),"{cccccc}Чтобы положить в багажник {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",friskName[myfpick]);
							ShowDialog(playerid,775,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",store,"Принять","Отмена");
						}
			        }
			        else i_resetveshi(playerid);
       			}
       			else i_resetveshi(playerid);
			}
		}
		else if(OnlineInfo[playerid][oInventSelectRight] == inva) // Выполняем
		{
			if(Tabs_Load[playerid] == 1) return use_goods(playerid, tab, inva);
			else if(Tabs_Load[playerid] == 2) return use_dom(playerid, tab, inva, 9999);
			else if(Tabs_Load[playerid] == 3) return use_sklad(playerid, tab, inva, 9999);
			else if(Tabs_Load[playerid] == 4) return use_rent(playerid, tab, inva);
			else if(Tabs_Load[playerid] == 5) return use_boot(playerid, tab, inva, 9999);
			else if(Tabs_Load[playerid] == 6) return use_mygoods(playerid, inva, 9999);
			else if(Tabs_Load[playerid] == 7) return use_throw(playerid, inva, 9999);
			else if(Tabs_Load[playerid] == 8) return use_trash(playerid, tab, inva, 9999);
			else if(Tabs_Load[playerid] == 9) return use_biz(playerid, tab, inva, 9999);
		}
		else if(OnlineInfo[playerid][oInventSelectRight] != 9999 && OnlineInfo[playerid][oInventSelectRight] != inva)
		{
			if(Tabs_Load[playerid] == 1 || Tabs_Load[playerid] == 6 || Tabs_Load[playerid] == 7 || Tabs_Load[playerid] == 3 || Tabs_Load[playerid] == 4 || Tabs_Load[playerid] == 9) return i_resettabs(playerid);
		    new tabfpick, tabType, tabPack;
			if(Tabs_Load[playerid] == 2) tabfpick = DomInfo[tab][dInvent][OnlineInfo[playerid][oInventSelectRight]], tabType = DomInfo[tab][dInvType][OnlineInfo[playerid][oInventSelectRight]], tabPack = DomInfo[tab][dInvPack][OnlineInfo[playerid][oInventSelectRight]]; // Дом
			else if(Tabs_Load[playerid] == 5) tabfpick = VehInfo[tab][vInvent][OnlineInfo[playerid][oInventSelectRight]], tabType = VehInfo[tab][vInvType][OnlineInfo[playerid][oInventSelectRight]], tabPack = VehInfo[tab][vInvType][OnlineInfo[playerid][oInventSelectRight]]; // Багажник
			if(tabfpick > 0 && fpick == tabfpick)
			{
			    if(tabType == 0 && tabPack == 0) // Только обычные предметы
			    {
			    	if(friskKol[fpick] == 1) // Если количественные, складываем их в одну ячейку
					{
						if(Tabs_Load[playerid] == 2) return mix_dom(playerid, tab, OnlineInfo[playerid][oInventSelectRight], inva);
						else if(Tabs_Load[playerid] == 5) return mix_boot(playerid, tab, OnlineInfo[playerid][oInventSelectRight], inva);
					}
				}
			}
			i_resettabs(playerid); // Сбрасываем Выбор
		}
	}
	return 1;
}
stock PreviouslySellThingPlayer(playerid, giveplayerid, const inputtext[])
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || OnlineInfo[playerid][oInventSelectLeft] == 9999) return 1;

	new inva = OnlineInfo[playerid][oInventSelectLeft];
	new fpick = PlayerInfo[playerid][pInven][inva], thingType = PlayerInfo[playerid][pInvenType][inva], thingPack = PlayerInfo[playerid][pInvenPack][inva];
	if(fpick <= 0) return 1;
	
	if(thingPack == 1) return ErrorMessage(playerid, "{FF6347}Подарок нельзя продать\n\n{cccccc}Подарите его кому-нибудь ;)");
	if(thingPack >= 2) return ErrorMessage(playerid, "{FF6347}Нельзя продать упакованный предмет");
	
	if(fpick == 48 && thingType == 0 && OnlineInfo[playerid][oInflatableBoat] != NON) return ErrorMessage(playerid, "{FF6347}Вам нужно сдуть лодку, прежде чем её продать");
	if(NotGiveThing(fpick, thingType)) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя продать этому игроку");

	if(giveplayerid == -1)
	{
	    if(!strlen(inputtext)) return ErrorMessage(playerid, "{FF6347}Вы не ввели текст");
		if(checksimvol(inputtext)) return ErrorMessage(playerid, "{FF6347}Вы используете запрещённый символ");
		giveplayerid = ReturnUser(inputtext);
	}
	if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрок не в сети");
	if(playerid == giveplayerid) return ErrorMessage(playerid, "{FF6347}Вы не можете продавать предметы себе");
    if(OnlineInfo[giveplayerid][oSaleThing] != 0) return ErrorMessage(playerid, "{FF6347}У игрока уже есть предложение о покупке\n\n{cccccc}Ему необходимо согласиться /yes или отказаться /no");

    DP[0][playerid] = giveplayerid;
    DP[1][playerid] = inva;
    DP[2][playerid] = fpick;
    DP[3][playerid] = 1;
	if(thingType == 0 && thingPack == 0)
	{
	    if(friskKol[fpick] == 1)
	    {
		    format(store,sizeof(store),"{cccccc}Покупатель: %s\nПредмет: {99ff66}%s\n{cccccc}Введите количество\n\nНе меньше 1 и не больше 100.000", rpplayername(giveplayerid), GetNameThing(1, fpick, thingType, thingPack));
			ShowDialog(playerid,1096,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",store,"Принять","Отмена");
			return 1;
		}
	}
	format(store,sizeof(store),"{cccccc}Покупатель: %s\nПредмет: {99ff66}%s\n{cccccc}Введите стоимость\n\nНе меньше 1$ и не больше 100.000.000$", rpplayername(giveplayerid), GetNameThing(1, fpick, thingType, thingPack));
	ShowDialog(playerid,1097,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",store,"Принять","Отмена");
	return 1;
}
stock give_invent(playerid, giveplayerid, fpick, fquan, thingType, thingPack, inva)
{
	Veshi[playerid] = 0, i_resetveshi(playerid);
	if(OnlineInfo[playerid][oShowInterface] != 1 || fpick != PlayerInfo[playerid][pInven][inva] || fquan > PlayerInfo[playerid][pInvenQuan][inva]
	|| fpick <= 0 || playerid == giveplayerid) return 1;

	// Простые проверки
	if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрок не в сети");
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerInfo[playerid][pSoska] == 0) return ErrorMessage(playerid, "{FF6347}Вы находитесь в слежке");
	if(GetPlayerState(giveplayerid) == PLAYER_STATE_SPECTATING || !ProxDetectorS(5.0, playerid,giveplayerid)) return ErrorMessage(playerid, "{FF6347}Вы далеко от игрока {cccccc}[ Не дальше 5-ти метров ]");
	if(GetPVarInt(playerid,"svzyal") >= 1 || GetPVarInt(giveplayerid,"svzyal") >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя передавать предметы во время покупок в супермаркете");
	
	// Проверка на особые предметы
	if(NotGiveThing(fpick, thingType)) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя передать этому игроку");
	if(fpick == 48 && thingType == 0 && OnlineInfo[playerid][oInflatableBoat] != NON) return ErrorMessage(playerid, "{FF6347}Вам нужно сдуть лодку, прежде чем её передать или убрать");

	// Проверка на наличие особых аксессуаров (Каска и Броня)
	if(IsHelmet(fpick) && thingType == 2 && (PlayerInfo[giveplayerid][pOdet][0] == fpick || PlayerInfo[giveplayerid][pOdet][1] == fpick || PlayerInfo[giveplayerid][pOdet][2] == fpick || PlayerInfo[giveplayerid][pOdet][3] == fpick || PlayerInfo[giveplayerid][pOdet][4] == fpick)) return ErrorMessage(playerid, "{FF6347}У игрока уже есть этот предмет");
	if(IsArmor(fpick) && thingType == 2 && PlayerInfo[giveplayerid][pArmor] >= 1) return ErrorMessage(playerid, "{FF6347}У игрока уже есть этот предмет");

	new fpara = PlayerInfo[playerid][pInvenPara][inva], fqara = PlayerInfo[playerid][pInvenQara][inva];

	// Проверка на лимиты количественного предмета
	new quanThing;
	if(thingType == 0) // Обычный предмет
	{
	    if(friskKol[fpick] == 1) // Предмет имеет количество
		{
		    if(thingPack == 0) quanThing = 1;
		    new getQuan, getLimit;
		    i_limit(giveplayerid, fpick, getQuan, getLimit);
		    if(getQuan+fquan > getLimit)
		    {
		        format(store,sizeof(store),"{FF6347}У игрока нет места в инвентаре\nЛимит для этого предмета: %d\n\n{cccccc}Предметы учитываются из раздела торговли и упаковок с подарками", getLimit);
		        ErrorMessage(playerid, store);
				i_resetveshi(playerid);
				i_resettabs(playerid);
				return 1;
		    }
		}
	}

    // Передача предмета
    if(JustOneThingInventory(fpick, thingType) && get_invent(giveplayerid, fpick, thingType) > 0) return ErrorMessage(playerid, "{FF6347}У игрока уже есть этот предмет");

    new put_inva = GiveThingPlayer(giveplayerid, fpick, fquan, fpara, fqara, thingType, thingPack, 9999); // Выдаём предмет игроку
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет

    if(quanThing == 1) take_away(playerid, fquan, inva); // Отнимаем предмет (по количеству)
    else i_del(playerid, inva); // Отнимаем предмет (целиком)

    format(store, sizeof(store), "[ Мысли ]: Я передал%s %s предмет: {333333}%s", gender(playerid), playername(giveplayerid), GetNameThing(1, fpick, thingType, thingPack));
	SendClientMessage(playerid, COLOR_GREY, store);
	format(store, sizeof(store), "[ Мысли ]: %s передал%s мне предмет: {333333}%s", playername(playerid), gender(playerid), GetNameThing(0, fpick, thingType, thingPack));
	SendClientMessage(giveplayerid, COLOR_GREY, store);
	format(store, sizeof(store), "* %s достаёт %s и передаёт %s.", playername(playerid), GetNameThing(0, fpick, thingType, thingPack), playername(giveplayerid));
	ProxDetector(20.0, playerid, store, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
    PlayerPlaySound(playerid,1053,0,0,0), PlayerPlaySound(giveplayerid,1052,0,0,0);

    if(thingPack == 1 && (IsANewYear() || PlayerInfo[playerid][pSoska] >= 22)) doneqwest(playerid, 4); // Если передали подарок
    
    SaveInvent(playerid, inva);
    SaveInvent(giveplayerid, put_inva);

    // Логируем передачу
    format(store,sizeof(store),"Передал: %s", GetNameThing(1, fpick, thingType, thingPack));
	UserLog("give", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], fquan, store);
	return 1;
}
stock PreviouslyGiveThingPlayer(playerid, giveplayerid, const inputtext[])
{
	if(OnlineInfo[playerid][oShowInterface] != 1 || OnlineInfo[playerid][oInventSelectLeft] == 9999) return 1;

	new inva = OnlineInfo[playerid][oInventSelectLeft];
	new fpick = PlayerInfo[playerid][pInven][inva], fquan = PlayerInfo[playerid][pInvenQuan][inva], thingType = PlayerInfo[playerid][pInvenType][inva], thingPack = PlayerInfo[playerid][pInvenPack][inva];
	if(fpick <= 0) return 1;
	
	if(giveplayerid == -1)
	{
	    if(!strlen(inputtext)) return ErrorMessage(playerid, "{FF6347}Вы не ввели текст");
		if(checksimvol(inputtext)) return ErrorMessage(playerid, "{FF6347}Вы используете запрещённый символ");
		giveplayerid = ReturnUser(inputtext);
	}
	if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрок не в сети");
	if(playerid == giveplayerid) return ErrorMessage(playerid, "{FF6347}Вы не можете передать предметы себе");

	if(thingType == 0 && thingPack == 0)
	{
	    if(friskKol[fpick] == 1)
	    {
	        DP[0][playerid] = giveplayerid;
	        DP[1][playerid] = inva;
	        DP[2][playerid] = fpick;
	    	format(store,sizeof(store),"{cccccc}Чтобы передать %s {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 100.000", playername(giveplayerid), GetNameThing(1, fpick, thingType, thingPack));
			ShowDialog(playerid,906,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",store,"Принять","Отмена");
			return 1;
		}
	}
	give_invent(playerid, giveplayerid, fpick, fquan, thingType, thingPack, inva);
	return 1;
}
//=================================
// Интерфейс Инвентаря
stock i_infofpick(playerid, fpick, inva, sels, fpara, thingType, thingPack) // Отображение выбранного предмета
{
	new yesFindModel;
	if(thingPack == 1)
	{
	    if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(store, sizeof(store), "ЊOѓAPOK");
		else format(store, sizeof(store), "GIFT");
		yesFindModel = 19054;
	}
	else if(thingPack == 2)
	{
	    if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(store, sizeof(store), "•Љ…K");
		else format(store, sizeof(store), "BOX");
		yesFindModel = 3014;
	}
	else
	{
	    if(thingType == 0) // Обычный предмет
	    {
	        if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(store, sizeof(store), "%s", fdrawName[fpick]);
			else format(store, sizeof(store), "%s", fdrawNameEN[fpick]);
			yesFindModel = friskPick[fpick];
	    }
	    else if(thingType == 1) // Оружие
	    {
		    if(fpara <= 0 && (sels == 0 || sels == 1 || sels == 2 || sels == 5 || sels == 6 || sels == 7 || sels == 8))
		    {
		    	if(fpick == 25 || fpick == 26 || fpick == 27) yesFindModel = 2034;
		    	else if(fpick == 22 || fpick == 24) yesFindModel = 2034;
		    	else if(fpick == 30 || fpick == 31) yesFindModel = 2035;
		        else if(fpick == 33 || fpick == 34) yesFindModel = 2036;
		        else yesFindModel = friskGun[fpick];
		    }
		    else yesFindModel = friskGun[fpick];
		    format(store, sizeof(store), "%s", gunDraw[fpick]);

	    }
	    else if(thingType == 2) // Аксессуар
	    {
			if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(store, sizeof(store), "AKCECCYAP");
			else format(store, sizeof(store), "ACCESSORY");
			yesFindModel = fpick;
		}
		else if(thingType == 3) // Одежда
	    {
			if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(store, sizeof(store), "OѓE„ѓA");
			else format(store, sizeof(store), "CLOTHES");
			yesFindModel = fpick;
		}
		else if(thingType == 4) // Мебель
	    {
			if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(store, sizeof(store), "MEЂE‡’");
			else format(store, sizeof(store), "FURNITURE");
			yesFindModel = fpick;
		}
	}
	
	if(yesFindModel > 0)
	{
	    new Float:modelPos[4], findIt;
		GetModelTextDraw(yesFindModel, modelPos[0], modelPos[1], modelPos[2], modelPos[3], findIt);
		PlayerTextDrawSetPreviewModel(playerid, PlaNestOthe[2][playerid], yesFindModel);
		PlayerTextDrawSetPreviewRot(playerid, PlaNestOthe[2][playerid], modelPos[0], modelPos[1], modelPos[2], modelPos[3]);
	}
	
	PlayerTextDrawSetString(playerid, PlaNestOthe[1][playerid], store);
	PlayerTextDrawColor(playerid, PlaNestOthe[2][playerid], -1);
	PlayerTextDrawSetSelectable(playerid, PlaNestOthe[2][playerid], true);
	PlayerTextDrawShow(playerid, PlaNestOthe[1][playerid]);
	PlayerTextDrawShow(playerid, PlaNestOthe[2][playerid]);

	if(sels == 1 || sels == 6)
	{
		if(Tabs_Load[playerid] == 6) format(store, sizeof(store), "%d$", PlayerInfo[playerid][pMarkPrice][inva]), PlayerTextDrawSetString(playerid, PlaNestPrice[playerid], store), PlayerTextDrawShow(playerid, PlaNestPrice[playerid]);
		else if(Tabs_Load[playerid] == 1)
		{
		    new p = Tabs_ID[playerid];
		    if(IsOnline(p)) format(store, sizeof(store), "%d$", PlayerInfo[p][pMarkPrice][inva]), PlayerTextDrawSetString(playerid, PlaNestPrice[playerid], store), PlayerTextDrawShow(playerid, PlaNestPrice[playerid]);
		}
	}
	return 1;
}
stock i_page(playerid, page) // Переключаем страницы главного раздела
{
	if(page == 0 && Page[playerid] != 0)
	{
		PlayerPlaySound(playerid,17803,0,0,0);
		Page[playerid] = 0;
		i_switches(playerid, 0, 1);
		i_switches(playerid, 1, 0);
		for(new inva = 0; inva < 20; inva++) i_tile(playerid, PlayerInfo[playerid][pInven][inva], PlayerInfo[playerid][pInvenQuan][inva], inva, PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenType][inva], PlayerInfo[playerid][pInvenPack][inva]);
	}
	else if(page == 1 && Page[playerid] != 1)
	{
		PlayerPlaySound(playerid,17803,0,0,0);
		Page[playerid] = 1;
		i_switches(playerid, 0, 0);
		i_switches(playerid, 1, 1);
		for(new inva = 20; inva < 40; inva++) i_tile(playerid, PlayerInfo[playerid][pInven][inva], PlayerInfo[playerid][pInvenQuan][inva], inva, PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenType][inva], PlayerInfo[playerid][pInvenPack][inva]);
	}
	return 1;
}
stock i_resetveshi(p) // Сброс отображения выбранной ячейки основного раздела
{
	if(OnlineInfo[p][oShowInterface] == 1 && OnlineInfo[p][oInventSelectLeft] != 9999)
	{
		if(Page[p] == 1 && OnlineInfo[p][oInventSelectLeft] >= 20) PlayerTextDrawBackgroundColor(p, PlaNestPick[OnlineInfo[p][oInventSelectLeft]-20][p], PlayerInfo[p][pStyle1]),PlayerTextDrawShow(p, PlaNestPick[OnlineInfo[p][oInventSelectLeft]-20][p]);
		else if(Page[p] == 0 && OnlineInfo[p][oInventSelectLeft] <= 19) PlayerTextDrawBackgroundColor(p, PlaNestPick[OnlineInfo[p][oInventSelectLeft]][p], PlayerInfo[p][pStyle1]),PlayerTextDrawShow(p, PlaNestPick[OnlineInfo[p][oInventSelectLeft]][p]);
		OnlineInfo[p][oInventSelectLeft] = 9999;
		if(OnlineInfo[p][oInventSelectRight] == 9999) reset_pick_othe(p), PlayerTextDrawShow(p, PlaNestOthe[2][p]);
	}
	return 1;
}
stock i_resettabs(p) // Сброс отображения выбранной ячейки второго раздела
{
	if(OnlineInfo[p][oShowInterface] == 1 && OnlineInfo[p][oInventSelectRight] != 9999)
	{
	    if(OnlineInfo[p][oShowInterfaceGoods] != 9999 || OnlineInfo[p][oShowInterfaceDom] != 0 || OnlineInfo[p][oShowInterfaceBiz] != 0 || OnlineInfo[p][oShowInterfaceSklad] != 0 || OnlineInfo[p][oShowInterfaceRent] != 9999 || OnlineInfo[p][oShowInterfaceVeh] != 9999 || OnlineInfo[p][oShowInterfaceTrash] != 9999 || Tabs_Load[p] == 6 || Tabs_Load[p] == 7)
	    {
	        new plusitem = 1000;
			if(Pagetwo[p] == 0 && OnlineInfo[p][oInventSelectRight] >= 0 && OnlineInfo[p][oInventSelectRight] <= 19) plusitem = 20;
			else if(Pagetwo[p] == 1 && OnlineInfo[p][oInventSelectRight] >= 20 && OnlineInfo[p][oInventSelectRight] <= 39) plusitem = 0;
			else if(Pagetwo[p] == 2 && OnlineInfo[p][oInventSelectRight] >= 40 && OnlineInfo[p][oInventSelectRight] <= 59) plusitem = -20;
			else if(Pagetwo[p] == 3 && OnlineInfo[p][oInventSelectRight] >= 60 && OnlineInfo[p][oInventSelectRight] <= 79) plusitem = -40;

			if(plusitem != 1000)
			{
				if(OnlineInfo[p][oShowInterfaceGoods] != 9999 || Tabs_Load[p] == 6) PlayerTextDrawBackgroundColor(p, PlaNestPick[OnlineInfo[p][oInventSelectRight]+plusitem][p], PlayerInfo[p][pStyle2]);
				else if(Tabs_Load[p] == 7)
				{
					new t = MyThrow[OnlineInfo[p][oInventSelectRight]][p];
					if(ThrowInfo[t][tPlayerid] == PlayerInfo[p][pID]) PlayerTextDrawBackgroundColor(p, PlaNestPick[OnlineInfo[p][oInventSelectRight]+plusitem][p], -226); // Если предмет оставил этот игрок
					else PlayerTextDrawBackgroundColor(p, PlaNestPick[OnlineInfo[p][oInventSelectRight]+plusitem][p], 40); // Если предмет оставил хер знает кто
				}
				else PlayerTextDrawBackgroundColor(p, PlaNestPick[OnlineInfo[p][oInventSelectRight]+plusitem][p], PlayerInfo[p][pStyle1]);
				PlayerTextDrawShow(p, PlaNestPick[OnlineInfo[p][oInventSelectRight]+plusitem][p]);
			}

			OnlineInfo[p][oInventSelectRight] = 9999;
			if(Tabs_Load[p] == 1 || Tabs_Load[p] == 6) PlayerTextDrawHide(p, PlaNestPrice[p]);
			if(OnlineInfo[p][oInventSelectLeft] == 9999) reset_pick_othe(p), PlayerTextDrawShow(p, PlaNestOthe[2][p]);
		}
	}
	return 1;
}
stock i_tile(playerid, item, quan, cell, para, thingType, thingPack) // Отображаем ячейку
{
	if(Page[playerid] == 0 && cell <= 19 || Page[playerid] == 1 && cell >= 20)
	{
		new cell2 = cell;
		if(Page[playerid] == 1) cell = cell-20;
		PlayerTextDrawFont(playerid, PlaNestPick[cell][playerid], 4);
		PlayerTextDrawBackgroundColor(playerid, PlaNestPick[cell][playerid], PlayerInfo[playerid][pStyle1]);
		PlayerTextDrawColor(playerid, PlaNestPick[cell][playerid], PlayerInfo[playerid][pStyle1]);
		PlayerTextDrawShow(playerid, PlaNestPick[cell][playerid]);
		PlayerTextDrawHide(playerid, PlaNestPickNum[cell][playerid]);
		if(item >= 1)
		{
			PlayerTextDrawBackgroundColor(playerid, PlaNestPick[cell][playerid], PlayerInfo[playerid][pStyle1]);
			PlayerTextDrawColor(playerid, PlaNestPick[cell][playerid], -1);
			PlayerTextDrawBoxColor(playerid, PlaNestPick[cell][playerid], 0);
			PlayerTextDrawFont(playerid, PlaNestPick[cell][playerid], 5);
			
			new yesFindModel;
			if(thingPack == 1) yesFindModel = 19054; // Подарок
			else if(thingPack == 2) yesFindModel = 3014; // Ящик
			else if(thingPack == 3) yesFindModel = 2060; // Мешок
			else if(thingPack == 0) // Без упаковки
			{
				if(thingType == 0) // Обычный предмет
				{
				    yesFindModel = friskPick[item];
					if(friskKol[item] == 1) // Количественный
					{
						new string[6];
						format(string, sizeof(string), "%d", quan);
						PlayerTextDrawSetString(playerid, PlaNestPickNum[cell][playerid], string);
						if(PlayerInfo[playerid][pSty] == 6 || PlayerInfo[playerid][pSty] == 11) PlayerTextDrawColor(playerid, PlaNestPickNum[cell][playerid], 673720575);
						else PlayerTextDrawColor(playerid, PlaNestPickNum[cell][playerid], -1);
		  				PlayerTextDrawShow(playerid, PlaNestPickNum[cell][playerid]);
					}
				}
				if(thingType == 1) // Оружие
				{
				    yesFindModel = friskGun[item];
				    if(para <= 0)
				    {
				    	if(item == 25 || item == 26 || item == 27) yesFindModel = 2034;
				    	else if(item == 22 || item == 24) yesFindModel = 2034;
				    	else if(item == 30 || item == 31) yesFindModel = 2035;
				        else if(item == 33 || item == 34) yesFindModel = 2036;
				    }
				}
				if(thingType == 2) yesFindModel = item; // Аксессуары
			 	if(thingType == 3) yesFindModel = item; // Одежда
			}
			if(OnlineInfo[playerid][oInventSelectLeft] == cell2) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[cell][playerid], PlayerInfo[playerid][pStyle3]);
			
			if(yesFindModel > 0)
			{
			    new Float:modelPos[4], findIt;
				GetModelTextDraw(yesFindModel, modelPos[0], modelPos[1], modelPos[2], modelPos[3], findIt);
				PlayerTextDrawSetPreviewModel(playerid, PlaNestPick[cell][playerid], yesFindModel);
				PlayerTextDrawSetPreviewRot(playerid, PlaNestPick[cell][playerid], modelPos[0], modelPos[1], modelPos[2], modelPos[3]);
			}
			
			PlayerTextDrawShow(playerid, PlaNestPick[cell][playerid]);
		}
	}
	return 1;
}
stock item_second(playerid, fpick, fquan, inva, stat, fpara, thingType, thingPack, throwPlayerId)
{
    if(Pagetwo[playerid] == 0 && inva <= 19 || Pagetwo[playerid] == 1 && inva >= 20 && inva <= 39 || Pagetwo[playerid] == 2 && inva >= 40 && inva <= 59 || Pagetwo[playerid] == 3 && inva >= 60 && inva <= 79)
	{
	    if(fpara == 0) fpara = 0;
	    new inva2 = inva;
		if(Pagetwo[playerid] == 0) inva = inva+20;
		else if(Pagetwo[playerid] == 1) { }
        else if(Pagetwo[playerid] == 2) inva = inva-20;
        else if(Pagetwo[playerid] == 3) inva = inva-40;
        PlayerTextDrawHide(playerid, PlaNestPickNum[inva][playerid]);
        
        new yesFindModel;
       	if(fpick == 0)
		{
	 		if(stat == 0)
	 		{
	 			PlayerTextDrawFont(playerid, PlaNestPick[inva][playerid], 4);
			 	PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
			 	PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
			 	PlayerTextDrawBoxColor(playerid, PlaNestPick[inva][playerid], 0);
		 	}
	 		else if(stat == 1)
	 		{
			 	PlayerTextDrawFont(playerid, PlaNestPick[inva][playerid], 4);
			 	PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle2]);
			 	PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle2]);
			 	PlayerTextDrawBoxColor(playerid, PlaNestPick[inva][playerid], 0);
		 	}
	 		else if(stat == 2)
		 	{
		 		PlayerTextDrawFont(playerid, PlaNestPick[inva][playerid], 5);
		 		PlayerTextDrawSetPreviewModel(playerid, PlaNestPick[inva][playerid], 2485);
				PlayerTextDrawSetPreviewRot(playerid, PlaNestPick[inva][playerid], 0.0, 0.0, 0.0, -1.0);
				PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], 150); // 40
			 	PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], 60);
			 	PlayerTextDrawBoxColor(playerid, PlaNestPick[inva][playerid], 0);
		 	}
			PlayerTextDrawHide(playerid, PlaNestPickNum[inva][playerid]);
		}
		else
		{
			new string[28];
			if(stat == 0)
	 		{
				PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
				PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], -1);
				PlayerTextDrawBoxColor(playerid, PlaNestPick[inva][playerid], 0);
				PlayerTextDrawFont(playerid, PlaNestPick[inva][playerid], 5);
			}
			else if(stat == 1)
	 		{
				PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle2]);
				PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], -1);
				PlayerTextDrawBoxColor(playerid, PlaNestPick[inva][playerid], 0);
				PlayerTextDrawFont(playerid, PlaNestPick[inva][playerid], 5);
			}
			else if(stat == 2)
	 		{
				PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], 40);
				PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], -1);
				PlayerTextDrawBoxColor(playerid, PlaNestPick[inva][playerid], 0);
				PlayerTextDrawFont(playerid, PlaNestPick[inva][playerid], 5);
				
				if(throwPlayerId == PlayerInfo[playerid][pID]) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], -226); // Если предмет оставил этот игрок
				else PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], 40); // Если предмет оставил хер знает кто
			}
			
			if(thingPack == 1) yesFindModel = 19054; // Подарок
			else if(thingPack == 2) yesFindModel = 3014; // Ящик
			else if(thingPack == 3) yesFindModel = 2060; // Мешок
			else if(thingPack == 0) // Без упаковки
			{
				if(thingType == 0) // Обычный предмет
				{
				    yesFindModel = friskPick[fpick];
					if(friskKol[fpick] == 1) // Количественный
					{
						format(string, sizeof(string), "%d", fquan);
						PlayerTextDrawSetString(playerid, PlaNestPickNum[inva][playerid], string);
						if(PlayerInfo[playerid][pSty] == 6 || PlayerInfo[playerid][pSty] == 11) PlayerTextDrawColor(playerid, PlaNestPickNum[inva][playerid], 673720575);
						else PlayerTextDrawColor(playerid, PlaNestPickNum[inva][playerid], -1);
		  				PlayerTextDrawShow(playerid, PlaNestPickNum[inva][playerid]);
					}
				}
				if(thingType == 1) // Оружие
				{
				    yesFindModel = friskGun[fpick];
				    if(fpara <= 0)
				    {
				    	if(fpick == 25 || fpick == 26 || fpick == 27) yesFindModel = 2034;
				    	else if(fpick == 22 || fpick == 24) yesFindModel = 2034;
				    	else if(fpick == 30 || fpick == 31) yesFindModel = 2035;
				        else if(fpick == 33 || fpick == 34) yesFindModel = 2036;
				    }
				}
				if(thingType == 2) yesFindModel = fpick; // Аксессуары
			 	if(thingType == 3) yesFindModel = fpick; // Одежда
				if(thingType == 4) yesFindModel = fpick; // Мебель
			}
			if(OnlineInfo[playerid][oShowInterfaceSklad] > 0 || OnlineInfo[playerid][oShowInterfaceRent] != 9999)
			{
				format(string, sizeof(string), "%d", fquan);
	    		PlayerTextDrawSetString(playerid, PlaNestPickNum[inva][playerid], string);
	    		if(PlayerInfo[playerid][pSty] == 6 || PlayerInfo[playerid][pSty] == 11) PlayerTextDrawColor(playerid, PlaNestPickNum[inva][playerid], 673720575);
				else PlayerTextDrawColor(playerid, PlaNestPickNum[inva][playerid], -1);
	    		PlayerTextDrawShow(playerid, PlaNestPickNum[inva][playerid]);
			}
		}
		if(OnlineInfo[playerid][oInventSelectRight] == inva2) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle3]);
		
		if(yesFindModel > 0)
		{
		    new Float:modelPos[4], findIt;
			GetModelTextDraw(yesFindModel, modelPos[0], modelPos[1], modelPos[2], modelPos[3], findIt);
			PlayerTextDrawSetPreviewModel(playerid, PlaNestPick[inva][playerid], yesFindModel);
			PlayerTextDrawSetPreviewRot(playerid, PlaNestPick[inva][playerid], modelPos[0], modelPos[1], modelPos[2], modelPos[3]);
		}
		
		PlayerTextDrawShow(playerid, PlaNestPick[inva][playerid]);
	}
	return 1;
}
//=================================
//=================================
stock CheckGoods(playerid)
{
	new free;
    for(new i = 0; i < 40; i ++)
    {
		if(PlayerInfo[playerid][pMarkInven][i] == 0)
		{
			free ++;
			break; // Остановим, поскольку мы не возвращаем количество свободных слотов, нам не нужно считать все
		}
    }
    if(free == 0) return 0;
    else return 1;
}
stock CheckInvent(playerid)
{
	new free;
    for(new i = 0; i < 40; i ++)
    {
		if(PlayerInfo[playerid][pInven][i] == 0)
		{
			free ++;
			break; // Остановим, поскольку мы не возвращаем количество свободных слотов, нам не нужно считать все
		}
    }
    if(free == 0) return 1;
    else return 0;
}
stock free_invent(playerid, quan)
{
	new free;
    for(new i = 0; i < 40; i ++)
    {
    	if(PlayerInfo[playerid][pInven][i] == 0) free ++;
   	}
	if(free >= quan) return 1;
	return 0;
}
stock get_and_take_invent(playerid, thingId, takeQuan) // Изымаем предмет и возвращаем количество
{
    new quan = 0;
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInvenQuan][i] >= 1 && PlayerInfo[playerid][pInven][i] == thingId && PlayerInfo[playerid][pInvenType][i] == 0 && PlayerInfo[playerid][pInvenPack][i] == 0)
		{
			quan += PlayerInfo[playerid][pInvenQuan][i];
			if(quan >= takeQuan) take_away(playerid, takeQuan, i);
			else take_away(playerid, quan, i);
		}
	}
	return quan;
}
stock get_invent(playerid, thingId, thingType) // Поиск предмета в инвентаре (Основные страницы + Торговля)
{
	new quan = 0;
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] == thingId && PlayerInfo[playerid][pInvenQuan][i] > 0 && PlayerInfo[playerid][pInvenType][i] == thingType) quan += PlayerInfo[playerid][pInvenQuan][i];
		if(i < 20)
		{
		    if(PlayerInfo[playerid][pMarkInven][i] == thingId && PlayerInfo[playerid][pMarkInvenQuan][i] > 0 && PlayerInfo[playerid][pMarkInvenType][i] == thingType) quan += PlayerInfo[playerid][pMarkInvenQuan][i];
		}
	}
	return quan;
}
stock get_invent2(playerid, stat, thingType) // Поиск предмета в инвентаре (Только две страницы основного инвентаря)
{
	new quan = 0;
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] == stat && PlayerInfo[playerid][pInvenType][i] == thingType && PlayerInfo[playerid][pInvenQuan][i] > 0) quan += PlayerInfo[playerid][pInvenQuan][i];
	}
	return quan;
}
stock get_invent3(playerid, stat, unix) // Поиск при продаже не испорченного товара в лавках лесника
{
	new kolvo = 0;
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInvenQuan][i] >= 1)
		{
			if(PlayerInfo[playerid][pInven][i] == stat && PlayerInfo[playerid][pInvenPara][i] > unix && PlayerInfo[playerid][pInvenType][i] == 0 && PlayerInfo[playerid][pInvenPack][i] == 0) kolvo += PlayerInfo[playerid][pInvenQuan][i];
		}
	}
	return kolvo;
}
stock get_invent4(playerid, stat, thingType) // Поиск предмета в инвентаре (Только две страницы основного инвентаря) и БЕЗ УПАКОВКИ
{
	new quan = 0;
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] == stat && PlayerInfo[playerid][pInvenType][i] == thingType && PlayerInfo[playerid][pInvenPack][i] == 0 && PlayerInfo[playerid][pInvenQuan][i] > 0) quan += PlayerInfo[playerid][pInvenQuan][i];
	}
	return quan;
}
stock i_setinvent(playerid, thingId, quan) // Установить значение в ячейке инвентаря
{
	new inva;
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] == thingId && PlayerInfo[playerid][pInvenType][i] == 0)
		{
			PlayerInfo[playerid][pInvenQuan][i] = quan;
			inva = i;
			break;
		}
	}
	if(OnlineInfo[playerid][oShowInterface] == 1) i_tile(playerid, PlayerInfo[playerid][pInven][inva], PlayerInfo[playerid][pInvenQuan][inva], inva, PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenType][inva], PlayerInfo[playerid][pInvenPack][inva]);
}
stock DelInvent(playerid, thingId, input, thingType) // Удалить предметы из инвентаря одного id по количеству и типу
{
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] == thingId && PlayerInfo[playerid][pInvenType][i] == thingType && PlayerInfo[playerid][pInvenPack][i] == 0)
		{
			PlayerInfo[playerid][pInven][i] = 0, PlayerInfo[playerid][pInvenQuan][i] = 0, PlayerInfo[playerid][pInvenPara][i] = 0, PlayerInfo[playerid][pInvenQara][i] = 0, i_takehands(playerid, thingId);
			input --;
			if(input == 0) break;
		}
	}
	return 1;
}
stock DelInvent2(playerid, stat, unix)
{
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] == stat && PlayerInfo[playerid][pInvenPara][i] > unix && PlayerInfo[playerid][pInvenType][i] == 0 && PlayerInfo[playerid][pInvenPack][i] == 0)
		{
		    ClearPlayerInven(playerid, i);
		    i_takehands(playerid, stat);
		}
	}
	return 1;
}
stock DelInvent3(playerid, stat)
{
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] == stat && PlayerInfo[playerid][pInvenType][i] == 0)
		{
			ClearPlayerInven(playerid, i);
			i_takehands(playerid, stat);
			if(OnlineInfo[playerid][oShowInterface] == 1) i_tile(playerid, PlayerInfo[playerid][pInven][i], PlayerInfo[playerid][pInvenQuan][i], i, PlayerInfo[playerid][pInvenPara][i], PlayerInfo[playerid][pInvenType][i], PlayerInfo[playerid][pInvenPack][i]), PlayerPlaySound(playerid,1053,0,0,0), i_resetveshi(playerid);
		}
		if(i < 20)
		{
			if(PlayerInfo[playerid][pMarkInven][i] == stat && PlayerInfo[playerid][pMarkInvenType][i] == 0)
			{
			    ClearMyGoods(playerid, i);
				PlayerInfo[playerid][pM_Update][i] = true;
				updategoods(playerid, i);
			}
		}
	}
	return 1;
}
stock DelLesson(playerid)
{
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] >= 145 && PlayerInfo[playerid][pInven][i] <= 155 && PlayerInfo[playerid][pInvenType][i] == 0) ClearPlayerInven(playerid, i);
		if(i < 20)
		{
		    if(PlayerInfo[playerid][pMarkInven][i] >= 145 && PlayerInfo[playerid][pMarkInven][i] <= 155 && PlayerInfo[playerid][pMarkInvenType][i] == 0) ClearMyGoods(playerid, i);
		}
	}
	return 1;
}
stock check_invent_free(playerid) // Поиск количества свободных слотов
{
	new kolvo = 0;
	for(new inva = 0; inva < 40; inva++)
	{
		if(PlayerInfo[playerid][pInven][inva] <= 0) kolvo ++;
	}
	return kolvo;
}
stock get_helmet(playerid, &thingId, &fpara, &fqara, &inva, &fpack) // Поиск каски в инвентаре для команды /usehelm
{
	for(new i = 0; i < 40; i++)
	{
		if(IsHelmet(PlayerInfo[playerid][pInven][i]) && PlayerInfo[playerid][pInvenPara][i] > 0 && PlayerInfo[playerid][pInvenType][i] == 2)
		{
		    thingId = PlayerInfo[playerid][pInven][i];
			fpara = PlayerInfo[playerid][pInvenPara][i];
			fqara = PlayerInfo[playerid][pInvenQara][i];
			fpack = PlayerInfo[playerid][pInvenPack][i];
			inva = i;
		}
	}
	return 1;
}
stock get_armor(playerid, &thingId, &fpara, &fqara, &inva, &fpack) // Поиск бронежилета в инвентаре для команды /usearm
{
	for(new i = 0; i < 40; i++)
	{
		if(IsArmor(PlayerInfo[playerid][pInven][i]) && PlayerInfo[playerid][pInvenPara][i] > 0 && PlayerInfo[playerid][pInvenType][i] == 2)
		{
		    thingId = PlayerInfo[playerid][pInven][i];
			fpara = PlayerInfo[playerid][pInvenPara][i];
			fqara = PlayerInfo[playerid][pInvenQara][i];
			fpack = PlayerInfo[playerid][pInvenPack][i];
			inva = i;
		}
	}
	return 1;
}
stock get_lic(playerid, stat) // Поиск лицензий (Которые принадлежат игроку)
{
	new kolvo = 0;
	for(new i = 0; i < 40; i++)
	{
	    if(PlayerInfo[playerid][pInven][i] == stat && PlayerInfo[playerid][pInvenType][i] == 0 && PlayerInfo[playerid][pInvenPara][i] == PlayerInfo[playerid][pID]) kolvo ++;
	    if(i < 20)
		{
			if(PlayerInfo[playerid][pMarkInven][i] == stat && PlayerInfo[playerid][pMarkInvenType][i] == 0 && PlayerInfo[playerid][pMarkInvenPara][i] == PlayerInfo[playerid][pID]) kolvo ++;
		}
	}
	return kolvo;
}
stock get_watch(playerid) // Поиск лицензий (Чужих, добровольно отданных)
{
	new slot = -1;
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInvenType][i] == 2)
		{
		    if(PlayerInfo[playerid][pInven][i] >= 19039 && PlayerInfo[playerid][pInven][i] <= 19053) 
			{
				slot = i;
				break;
			}
		}
	}
	return slot;
}
stock get_alienlic(playerid, &s0, &s1, &s2, &s3, &s4, &s5, &s6) // Поиск лицензий (Чужих, добровольно отданных)
{
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInvenPara][i] != PlayerInfo[playerid][pID] && PlayerInfo[playerid][pInvenType][i] == 0)
		{
		    if(PlayerInfo[playerid][pInven][i] == 156) s0 = 1;
	        if(PlayerInfo[playerid][pInven][i] == 157) s1 = 1;
	        if(PlayerInfo[playerid][pInven][i] == 158) s2 = 1;
	        if(PlayerInfo[playerid][pInven][i] == 159) s3 = 1;
	        if(PlayerInfo[playerid][pInven][i] == 161) s4 = 1;
	        if(PlayerInfo[playerid][pInven][i] == 162) s5 = 1;
	        if(PlayerInfo[playerid][pInven][i] == 160) s6 = 1;
		}
	    if(i < 20)
		{
		    if(PlayerInfo[playerid][pMarkInvenPara][i] != PlayerInfo[playerid][pID] && PlayerInfo[playerid][pMarkInvenType][i] == 0)
		    {
		        if(PlayerInfo[playerid][pMarkInven][i] == 156) s0 = 1;
		        if(PlayerInfo[playerid][pMarkInven][i] == 157) s1 = 1;
		        if(PlayerInfo[playerid][pMarkInven][i] == 158) s2 = 1;
		        if(PlayerInfo[playerid][pMarkInven][i] == 159) s3 = 1;
		        if(PlayerInfo[playerid][pMarkInven][i] == 161) s4 = 1;
		        if(PlayerInfo[playerid][pMarkInven][i] == 162) s5 = 1;
		        if(PlayerInfo[playerid][pMarkInven][i] == 160) s6 = 1;
		    }
		}
	}
	return 1;
}
stock get_stolenlic(playerid, &s0, &s1, &s2, &s3, &s4, &s5) // Поиск лицензий (Украденной)
{
	for(new i = 0; i < 40; i++)
	{
	    if(PlayerInfo[playerid][pInvenQara][i] > 0 && PlayerInfo[playerid][pInvenType][i] == 0)
	    {
	        if(PlayerInfo[playerid][pInven][i] == 156) s0 = 1;
	        if(PlayerInfo[playerid][pInven][i] == 157) s1 = 1;
	        if(PlayerInfo[playerid][pInven][i] == 158) s2 = 1;
	        if(PlayerInfo[playerid][pInven][i] == 159) s3 = 1;
	        if(PlayerInfo[playerid][pInven][i] == 161) s4 = 1;
	        if(PlayerInfo[playerid][pInven][i] == 162) s5 = 1;
	    }
	    if(i < 20)
		{
		    if(PlayerInfo[playerid][pMarkInvenQara][i] > 0 && PlayerInfo[playerid][pMarkInvenType][i] == 0)
			{
			    if(PlayerInfo[playerid][pMarkInven][i] == 156) s0 = 1;
		        if(PlayerInfo[playerid][pMarkInven][i] == 157) s1 = 1;
		        if(PlayerInfo[playerid][pMarkInven][i] == 158) s2 = 1;
		        if(PlayerInfo[playerid][pMarkInven][i] == 159) s3 = 1;
		        if(PlayerInfo[playerid][pMarkInven][i] == 161) s4 = 1;
		        if(PlayerInfo[playerid][pMarkInven][i] == 162) s5 = 1;
			}
		}
	}
	return 1;
}
stock get_para(playerid, fpick) // Параметр предмета
{
	new para = 0;
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] == fpick && PlayerInfo[playerid][pInvenType][i] == 0)
		{
			para = PlayerInfo[playerid][pInvenPara][i];
			break;
		}
	}
	return para;
}
stock get_qara(playerid, fpick) // Второй параметр предмета
{
	new qara = 0;
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] == fpick && PlayerInfo[playerid][pInvenType][i] == 0)
		{
			qara = PlayerInfo[playerid][pInvenQara][i];
			break;
		}
	}
	return qara;
}
stock get_drugs(playerid, stat) // Поиск веществ
{
	new kolvo = 0;
	for(new i = 0; i < 40; i++)
	{
	    if(PlayerInfo[playerid][pInven][i] == stat && PlayerInfo[playerid][pInvenQuan][i] >= 1 && PlayerInfo[playerid][pInvenType][i] == 0) kolvo ++;
	    if(i < 20)
		{
			if(PlayerInfo[playerid][pMarkInven][i] == stat && PlayerInfo[playerid][pMarkInvenQuan][i] >= 1 && PlayerInfo[playerid][pMarkInvenType][i] == 0) kolvo ++;
		}
	}
	return kolvo;
}
stock set_para(playerid, fpick, para) // Установка параметра предмета
{
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] != fpick || PlayerInfo[playerid][pInvenQuan][i] == 0 || PlayerInfo[playerid][pInvenType][i] != 0) continue;
		PlayerInfo[playerid][pInvenPara][i] = para;
	}
}
stock TakeInvent(playerid, stat, quan, thingType, dopinf) // Сток для изъятия предмета из инвентаря (id, id премета, количество, ячейка)
{
	new plit;
	if(dopinf == 999) // Если мы НЕ знаем ячейку, нам нужно найти её (999)
	{
		for(new i = 0; i < 40; i++)
		{
			if(PlayerInfo[playerid][pInven][i] == stat && PlayerInfo[playerid][pInvenType][i] == thingType && PlayerInfo[playerid][pInvenPack][i] == 0)
			{
			    plit = i;
			    take_away(playerid, quan, i);
				break;
			}
		}
	}
	else // Если знаем ячейку, нам не нужно её искать)
	{
	    plit = dopinf;
	    if(PlayerInfo[playerid][pInven][dopinf] == stat && PlayerInfo[playerid][pInvenType][dopinf] == thingType) take_away(playerid, quan, dopinf);
	}
	if(OnlineInfo[playerid][oShowInterface] == 1) i_tile(playerid, PlayerInfo[playerid][pInven][plit], PlayerInfo[playerid][pInvenQuan][plit], plit, PlayerInfo[playerid][pInvenPara][plit], PlayerInfo[playerid][pInvenType][plit], PlayerInfo[playerid][pInvenPack][plit]), PlayerPlaySound(playerid,1053,0,0,0), i_resetveshi(playerid);
	i_takehands(playerid, stat);
	return 1;
}
stock take_away(playerid, quan, i) // Изымаем предмет, если он был точно найден в ячейке
{
	if(PlayerInfo[playerid][pInvenQuan][i]-quan <= 0) // Если при изъятии ничего не останется - очищаем полностью
	{
	    if(PlayerInfo[playerid][pInvenType][i] == 0) i_takehands(playerid, PlayerInfo[playerid][pInven][i]);
		PlayerInfo[playerid][pInven][i] = 0;
		PlayerInfo[playerid][pInvenQuan][i] = 0;
		PlayerInfo[playerid][pInvenPara][i] = 0;
		PlayerInfo[playerid][pInvenQara][i] = 0;
		PlayerInfo[playerid][pInvenType][i] = 0;
		PlayerInfo[playerid][pInvenPack][i] = 0;
	}
	else PlayerInfo[playerid][pInvenQuan][i] -= quan;
	if(OnlineInfo[playerid][oShowInterface] == 1) i_tile(playerid, PlayerInfo[playerid][pInven][i], PlayerInfo[playerid][pInvenQuan][i], i, PlayerInfo[playerid][pInvenPara][i], PlayerInfo[playerid][pInvenType][i], PlayerInfo[playerid][pInvenPack][i]);
	return 1;
}
stock i_del(playerid, i)
{
    if(PlayerInfo[playerid][pInvenType][i] == 0) i_takehands(playerid, PlayerInfo[playerid][pInven][i]);
	PlayerInfo[playerid][pInven][i] = 0;
	PlayerInfo[playerid][pInvenQuan][i] = 0;
	PlayerInfo[playerid][pInvenPara][i] = 0;
	PlayerInfo[playerid][pInvenQara][i] = 0;
	PlayerInfo[playerid][pInvenType][i] = 0;
	PlayerInfo[playerid][pInvenPack][i] = 0;
	if(OnlineInfo[playerid][oShowInterface] == 1) i_tile(playerid, 0, 0, i, 0, 0, 0);
}
stock GiveThingPlayer(playerid, thingId, quan, para, qara, thingType, thingPack, useinva) // Даём игроку предмет в инвентарь
{
    new inva = -1;
	if(thingId == 0) return inva; // Малоли где то ошибка может быть (0 - не пропускаем выдачу предмета)
	
	if(useinva == 9999) // Не знаем в какую ячейку класть
	{
	    if(thingType == 0) // Обычный предмет
		{
		    if(friskKol[thingId] == 1) // Предмет имеет количество (Складывается в одну ячейку)
		    {
		        new find;
		    	for(new i = 0; i < 40; i++)
				{
					if(PlayerInfo[playerid][pInven][i] == thingId && PlayerInfo[playerid][pInvenType][i] == thingType && PlayerInfo[playerid][pInvenPack][i] == thingPack) // Ищем тот, где уже предмет лежит
					{
					    inva = i;
		  				put_thing_player(playerid, thingId, quan, para, 0, thingType, thingPack, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
		  				find = 1;
			   			break;
					}
				}
				if(find == 0) // Если не нашли, ищем пустую
				{
					for(new i = 0; i < 40; i++)
					{
						if(PlayerInfo[playerid][pInven][i] == 0) // Ищем пустую ячейку
						{
						    inva = i;
			  				put_thing_player(playerid, thingId, quan, para, 0, thingType, thingPack, i); // qara 0 - поскольку количественные предметы не могут иметь статус краденного
				   			break;
						}
					}
				}
			}
			else if(friskKol[thingId] == 0) // Объект не имеет количество
			{
			    for(new i = 0; i < 40; i++)
				{
					if(PlayerInfo[playerid][pInven][i] == 0) // Ищем пустую ячейку
					{
					    inva = i;
		  				put_thing_player(playerid, thingId, quan, para, qara, thingType, thingPack, i);
			   			break;
					}
				}
			}
		}
		else // Все остальные предметы не имеют количества или возможности складываться в одну ячейку
		{
		    for(new i = 0; i < 40; i++)
			{
				if(PlayerInfo[playerid][pInven][i] == 0) // Ищем пустую ячейку
				{
				    inva = i;
	  				put_thing_player(playerid, thingId, quan, para, qara, thingType, thingPack, i);
		   			break;
				}
			}
		}
	}
	else inva = put_thing_player(playerid, thingId, quan, para, qara, thingType, thingPack, useinva); // Знаем в какую ячейку класть
	return inva;
}
stock put_thing_player(playerid, thingId, quan, para, qara, thingType, thingPack, i)
{
	if(PlayerInfo[playerid][pInven][i] != 0 && PlayerInfo[playerid][pInven][i] != thingId) return -1; // Защита от ошибки, на всякий случай

    if(qara == PlayerInfo[playerid][pID]) qara = 0; // Удаляем статус краденного предмета, если он принадлежит этому игроку
    
    // Выдача особых предметов
    if(thingType == 0) // Обычные предметы
    {
        new unix = gettime();
        if(thingId == 1 && para == 0) quan = GetFullThingQuan(thingId), para = unix+432000; // Хлеб (Время до испорченности)
        else if(thingId == 14 && para == 0) quan = GetFullThingQuan(thingId), para = unix+7776000; // Пиво (Время до испорченности + количество)
        else if(thingId == 16 && quan == 0) quan = GetFullThingQuan(thingId); // Пачка сигарет (Полный комплект)
        else if(thingId == 19 && quan == 0) quan = GetFullThingQuan(thingId); // Отмычки (Полный комплект)
		else if(thingId == 26 && PlayerInfo[playerid][pDrugPerk] == 0) quan = GetFullThingQuan(thingId), NumberSmartfonPlayer(playerid); // Смартфон (Номер телефона)
		else if(thingId == 37 && quan == 0) quan = GetFullThingQuan(thingId); // Шампанское (Количество)
		else if(thingId == 41 && quan == 0) quan = GetFullThingQuan(thingId); // Бенгальские свечи (Полный комплект)
		else if(thingId == 62) quan = GetFullThingQuan(thingId), SetPVarInt(playerid,"PlayBoy", 1); // Если выдаём Журнал PlayBoy
		else if(thingId == 88 && quan == 0) quan = GetFullThingQuan(thingId); // Семена травы (Полный комплект)
		else if(thingId == 121 && para == 0) quan = GetFullThingQuan(thingId), para = unix+86400; // Кофе
		else if(thingId == 124 && para == 0) quan = GetFullThingQuan(thingId), para = unix+86400; // Спранк стакан
		else if(thingId == 120 && para == 0) quan = GetFullThingQuan(thingId), para = unix+1209600; // Sprunk Банка
		else if(thingId == 127 && para == 0) SetSatiety(thingId, quan), para = unix+86400; // Ролл
		else if(thingId == 141 && para == 0) SetSatiety(thingId, quan), para = unix+86400; // ХОТЕ ДОГЕ
		else if(thingId == 163 && para == 0) quan = GetFullThingQuan(thingId), para = unix+604800; // Свадебный торт (Время до испорченности + количество)
		else if(thingId == 166 && para == 0) SetSatiety(thingId, quan), para = unix+86400; // Пицца
		else if(thingId == 172 && para == 0) SetSatiety(thingId, quan), para = unix+86400; // А. Сок
		else if(thingId == 173 && para == 0) SetSatiety(thingId, quan), para = unix+86400; // Я. Сок
		else
		{
		    if(quan == 0) quan = GetFullThingQuan(thingId);
		}
	}
	else if(thingType == 2) // Аксессуары с особыми возможностями
    {
        if(IsHelmet(thingId) && para == 0) para = 3; // Каска
        if(IsArmor(thingId) && para == 0) para = 100; // Бронежилет
    }
	
	PlayerInfo[playerid][pInven][i] = thingId; // Ставим предмет в слот
	PlayerInfo[playerid][pInvenQuan][i] += quan; // Ставим количество в слот
	
	// (Техника сломана или нет, Одежда какой организации принадлежит, Unix время свежести продуктов, Изношенность оружия, Прнадлежность лицензии к ID игрока, Тип крепления аксессуара)
	if(PerishableThing(thingId, thingType)) // Проверка на портящиеся продукты - у них используется Unix (Добавляя испорченный продукт к свежему, портиться должно всё)
	{
	    if(PlayerInfo[playerid][pInvenPara][i] > 0)
		{
			if(PlayerInfo[playerid][pInvenPara][i] > para) PlayerInfo[playerid][pInvenPara][i] = para;
		}
		else PlayerInfo[playerid][pInvenPara][i] = para;
	}
	else PlayerInfo[playerid][pInvenPara][i] = para;
	PlayerInfo[playerid][pInvenQara][i] = qara; // Статус краденного предмета
	PlayerInfo[playerid][pInvenType][i] = thingType; // Тип предмета
	PlayerInfo[playerid][pInvenPack][i] = thingPack; // Упаковка предмета
	
	if(OnlineInfo[playerid][oShowInterface] == 1) i_tile(playerid, PlayerInfo[playerid][pInven][i], PlayerInfo[playerid][pInvenQuan][i], i, PlayerInfo[playerid][pInvenPara][i], PlayerInfo[playerid][pInvenType][i], PlayerInfo[playerid][pInvenPack][i]), PlayerPlaySound(playerid,1052,0,0,0);
	return i;
}
stock GetFullThingQuan(thingId)
{
	new quan;
    if(thingId == 1) quan = 1; // Хлеб
    else if(thingId == 14) quan = 6; // Пиво
    else if(thingId == 16) quan = 50; // Пачка сигарет
    else if(thingId == 19) quan = 5; // Отмычки
	else if(thingId == 37) quan = 15; // Шампанское
	else if(thingId == 41) quan = 5; // Бенгальские свечи 
	else if(thingId == 62) quan = 1; // PlayBoy
	else if(thingId == 88) quan = 5; // Семена травы
	else if(thingId == 163) quan = 21; // Свадебный торт
	else if(thingId == 121) quan = 4; // Кофе
	else if(thingId == 124) quan = 4; // Спранк стакан
	else if(thingId == 120) quan = 4; // Sprunk Банка
	else quan = 1;
	return quan;
}
stock SaveInventAll(playerid) // Сохранение всего инвентаря по цилку
{
	format(big_query,sizeof(big_query),"UPDATE `pp_igroki` SET `Inven1` = '%d', `InvenKol1` = '%d', `InvenPara1` = '%d', `InvenQara1` = '%d', `InvenType1` = '%d', `InvenPack1` = '%d'",
	PlayerInfo[playerid][pInven][0], PlayerInfo[playerid][pInvenQuan][0], PlayerInfo[playerid][pInvenPara][0], PlayerInfo[playerid][pInvenQara][0], PlayerInfo[playerid][pInvenType][0], PlayerInfo[playerid][pInvenPack][0]);
	for(new i = 1; i < 20; i++) format(big_query,sizeof(big_query),"%s, `Inven%d` = '%d', `InvenKol%d` = '%d', `InvenPara%d` = '%d', `InvenQara%d` = '%d', `InvenType%d` = '%d', `InvenPack%d` = '%d'", big_query,
	i+1, PlayerInfo[playerid][pInven][i], i+1, PlayerInfo[playerid][pInvenQuan][i], i+1, PlayerInfo[playerid][pInvenPara][i], i+1, PlayerInfo[playerid][pInvenQara][i], i+1, PlayerInfo[playerid][pInvenType][i], i+1, PlayerInfo[playerid][pInvenPack][i]);
    format(big_query,sizeof(big_query),"%s WHERE `id` = '%d'", big_query, PlayerInfo[playerid][pID]);
	query_empty(pearsq, big_query);
	
	format(big_query,sizeof(big_query),"UPDATE `pp_igroki` SET `Inven21` = '%d', `InvenKol21` = '%d', `InvenPara21` = '%d', `InvenQara21` = '%d', `InvenType21` = '%d', `InvenPack21` = '%d'",
	PlayerInfo[playerid][pInven][20], PlayerInfo[playerid][pInvenQuan][20], PlayerInfo[playerid][pInvenPara][20], PlayerInfo[playerid][pInvenQara][20], PlayerInfo[playerid][pInvenType][20], PlayerInfo[playerid][pInvenPack][20]);
	for(new i = 21; i < 40; i++) format(big_query,sizeof(big_query),"%s, `Inven%d` = '%d', `InvenKol%d` = '%d', `InvenPara%d` = '%d', `InvenQara%d` = '%d', `InvenType%d` = '%d', `InvenPack%d` = '%d'", big_query,
	i+1, PlayerInfo[playerid][pInven][i], i+1, PlayerInfo[playerid][pInvenQuan][i], i+1, PlayerInfo[playerid][pInvenPara][i], i+1, PlayerInfo[playerid][pInvenQara][i], i+1, PlayerInfo[playerid][pInvenType][i], i+1, PlayerInfo[playerid][pInvenPack][i]);
    format(big_query,sizeof(big_query),"%s WHERE `id` = '%d'", big_query, PlayerInfo[playerid][pID]);
	query_empty(pearsq, big_query);
	return 1;
}
stock SaveInvent(playerid, i) // Сохранение одной ячейки инвентаря
{
	format(big_query, sizeof(big_query), "UPDATE `pp_igroki` SET `Inven%d`='%d',`InvenKol%d`='%d',`InvenPara%d`='%d',`InvenQara%d`='%d',`InvenType%d`='%d',`InvenPack%d`='%d' WHERE `id`='%d'",
	i+1,PlayerInfo[playerid][pInven][i],i+1,PlayerInfo[playerid][pInvenQuan][i],i+1,PlayerInfo[playerid][pInvenPara][i],i+1,PlayerInfo[playerid][pInvenQara][i],i+1,PlayerInfo[playerid][pInvenType][i],i+1,PlayerInfo[playerid][pInvenPack][i],PlayerInfo[playerid][pID]);
	query_empty(pearsq, big_query);
    return 1;
}
stock NumberSmartfonPlayer(playerid) // Устанавливаем номер телефона игроку, исходя из уже существующих
{
    if(ServerInfo[54] <= 0) ServerInfo[54] = 500000; // Если в конфиге нет номера телефона
	ServerInfo[54] += 1;
	PlayerInfo[playerid][pDrugPerk] = ServerInfo[54];
	SaveServer(54);
	return 1;
}
stock ClearPlayerInven(playerid, inva)
{
    PlayerInfo[playerid][pInven][inva] = 0;
	PlayerInfo[playerid][pInvenQuan][inva] = 0;
	PlayerInfo[playerid][pInvenPara][inva] = 0;
	PlayerInfo[playerid][pInvenQara][inva] = 0;
	PlayerInfo[playerid][pInvenType][inva] = 0;
    PlayerInfo[playerid][pInvenPack][inva] = 0;
    if(OnlineInfo[playerid][oShowInterface] == 1) i_tile(playerid, 0, 0, inva, 0, 0, 0);
	return 1;
}
stock GetNameThing(readStatus, thingId, thingType, thingPack) // Получаем обычное имя предмета по его типу (Для текста, диалоговых окон и логов)
{
	new nameProduct[84];
	// Тип товара (0 обычный, 1 оружие, 2 аксессуар, 3 одежда, 4 мебель)
	if(thingPack == 0)
	{
	    if(thingType == 0) format(nameProduct,sizeof(nameProduct),"%s", friskName[thingId]);
		else if(thingType == 1) format(nameProduct,sizeof(nameProduct),"%s", gunName[thingId]);
		else if(thingType == 2) format(nameProduct,sizeof(nameProduct),"%s", GetNameAccessory(thingId));
		else if(thingType == 3) format(nameProduct,sizeof(nameProduct),"Одежда ID %d", thingId);
		else if(thingType == 4) format(nameProduct,sizeof(nameProduct),"%s", object_name(thingId));
		else if(thingType == 5) format(nameProduct,sizeof(nameProduct),"%s", vehName[thingId]);
	}
	else if(thingPack >= 1) // 0 предмет, 1 подарок, 2 ящик, 3 Мешок (помещается только 1 предмет и занимает 1 ячейку)
	{
	    new hideName[8];
	    if(thingPack == 1) format(hideName,sizeof(hideName),"Подарок");
    	else if(thingPack == 2) format(hideName,sizeof(hideName),"Ящик");
    	else if(thingPack == 3) format(hideName,sizeof(hideName),"Мешок");
	    
	    if(readStatus == 0) format(nameProduct,sizeof(nameProduct),"%s", hideName);
	    else // Читаемый, для логов и просмотра содержимого администрацией
		{
			if(thingType == 0) format(nameProduct,sizeof(nameProduct),"%s (%s)", hideName, friskName[thingId]);
			else if(thingType == 1) format(nameProduct,sizeof(nameProduct),"%s (%s)", hideName, gunName[thingId]);
			else if(thingType == 2) format(nameProduct,sizeof(nameProduct),"%s (%s)", hideName, GetNameAccessory(thingId));
			else if(thingType == 3) format(nameProduct,sizeof(nameProduct),"%s (Одежда ID %d)", hideName, thingId);
			else if(thingType == 4) format(nameProduct,sizeof(nameProduct),"%s (%s)", hideName, object_name(thingId));
		}
	}
	return nameProduct;
}
stock JustOneThingInventory(i, type) // Проверка на наличие предметов, которые не могут повторяться в инвентаре (Только 1)
{
	if(type == 0 && (i == 10 || i == 11 || i == 12 || i == 13 || i == 17 || i == 21 || i == 23 || i == 26
	|| i == 42 || i == 43 || i == 48 || i == 51 || i == 63 || i == 91)
	|| type == 2 && (IsHelmet(i) || IsArmor(i))) return 1; // Каски, Броник
	return 0;
}
stock IsHelmet(i)
{
	if(i == 19093 || i == 19160 || i == 2053 || i == 18638 || i >= 19106 && i <= 19120 || i == 19519 || i == 18640 || i == 19330 || i == 19331) return 1;
	return 0;
}
stock IsWatch(i)
{
	if(i >= 19039 && i <= 19053) return 1;
	return 0;
}
stock IsArmor(i)
{
	if(i == 19142) return 1;
	return 0;
}
stock PerishableThing(i, type) //  Проверка на портящиеся продукты
{
    if(type == 0 && (i == 1 || i == 6 || i == 18 || i == 20 || i == 22 || i == 54 || i == 55 || i == 96 || i == 98 || i == 99 || i == 100 || i == 101 || i == 102
 	|| i == 103 || i == 104 || i == 105 || i == 107 || i == 14 || i == 117 || i == 118 || i == 119 || i == 120 || i == 121 || i == 124 || i == 125
  	|| i == 126 || i == 127 || i >= 128 && i <= 138 || i == 139 || i == 163 || i == 164)) return 1;
	return 0;
}
stock NotGiveThing(i, type)
{
	if(type == 0 && (i == 10 || i == 12 || i == 17 || i == 43 || i == 51 || i == 63)
	|| type == 1 && (i == 34)) return 1;
	return 0;
}
stock i_limit(playerid, thingId, &getQuan, &getLimit) // Проверяем лимиты инвентаря
{
	new lim[INVENTER], pow = get_power(playerid);
	for(new i = 0; i < INVENTER; i++) lim[i] = 1;
	lim[8] = 2, lim[19] = 5, lim[41] = 10, lim[25] = 999000000; // Аптечки, Отмычки, Бенгальские Свечи, Деньги 999кк
	lim[4] = 100*pow, lim[5] = 100*pow, lim[6] = 100*pow, lim[7] = 100*pow, lim[9] = 20, lim[18] = 100*pow, lim[20] = 10*pow, lim[27] = 100*pow, lim[28] = 100*pow, lim[29] = 100*pow, lim[30] = 100*pow;
	lim[46] = 5*pow, lim[47] = 5*pow, lim[55] = 10, lim[60] = 100, lim[61] = 50, lim[64] = 100*pow, lim[65] = 100*pow, lim[66] = 100*pow, lim[67] = 100*pow, lim[71] = 5;
	lim[72] = 10, lim[73] = 10, lim[74] = 10, lim[75] = 10, lim[76] = 10, lim[77] = 10, lim[78] = 10, lim[79] = 10, lim[80] = 10, lim[81] = 10;
	lim[82] = 10, lim[83] = 10, lim[84] = 10, lim[85] = 10, lim[86] = 10, lim[87] = 10, lim[88] = 10, lim[89] = 10, lim[106] = 12, lim[108] = 20, lim[109] = 20, lim[110] = 20;
	lim[140] = 100, lim[141] = 100, lim[142] = 10, lim[180] = 50;

    getQuan = get_invent(playerid, thingId, 0);
    getLimit = lim[thingId];
	return 1;
}


stock use_sklad(playerid, wh, inva, useinva)
{
    i_resettabs(playerid);
	i_resetveshi(playerid);

	new fpick = OrganInfo[wh][gInvent][inva], thingType = OrganInfo[wh][gInvType][inva], unixtime = gettime();
    if(useinva != 9999)
	{
 		if(PlayerInfo[playerid][pInven][useinva] != OrganInfo[wh][gInvent][inva] && PlayerInfo[playerid][pInven][useinva] != 0) return i_resettabs(playerid);
	}
	if(JustOneThingInventory(fpick, thingType) && get_invent(playerid, fpick, thingType) > 0) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет");

	new yes, giveThing;
	if(IsHelmet(fpick) && thingType == 2) // Каска (Тип аксессуар)
	{
	    if(PlayerInfo[playerid][pGacc][6]+OrganInfo[wh][gUnitStat][20]*60 > unixtime) return format(store,sizeof(store),"{FF6347}Вы не можете сейчас взять каску [ Через %d мин. ]", ((PlayerInfo[playerid][pGacc][6]+OrganInfo[wh][gUnitStat][20]*60)-unixtime)/60), ErrorMessage(playerid, store);
	    if(PlayerInfo[playerid][pOdet][0] == fpick || PlayerInfo[playerid][pOdet][1] == fpick || PlayerInfo[playerid][pOdet][2] == fpick || PlayerInfo[playerid][pOdet][3] == fpick || PlayerInfo[playerid][pOdet][4] == fpick) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет");
	    giveThing = 6;
	    yes = 1;
	}
	else if(IsArmor(fpick) && thingType == 2) // Бронежилет (Тип аксессуар)
	{
	    if(PlayerInfo[playerid][pGacc][7]+OrganInfo[wh][gUnitStat][21]*60 > unixtime) return format(store,sizeof(store),"{FF6347}Вы не можете сейчас взять бронежилет [ Через %d мин. ]", ((PlayerInfo[playerid][pGacc][7]+OrganInfo[wh][gUnitStat][21]*60)-unixtime)/60), ErrorMessage(playerid, store);
	    if(PlayerInfo[playerid][pArmor] >= 1) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет");
	    giveThing = 7;
	    yes = 1;
	}
	else if(thingType == 1) // Оружие
	{
	    if(PlayerInfo[playerid][pGacc][4]+OrganInfo[wh][gUnitStat][18]*60 > unixtime) return format(store,sizeof(store),"{FF6347}Вы не можете сейчас взять оружие [ Через %d мин. ]", ((PlayerInfo[playerid][pGacc][4]+OrganInfo[wh][gUnitStat][18]*60)-unixtime)/60), ErrorMessage(playerid, store);
	    giveThing = 4;
	    yes = 1;
	}
	else if(thingType == 0)
	{
	    if(friskKol[fpick] == 1) // Предмет имеет количество
		{
		    DP[0][playerid] = inva;
			new maxQuan = 1000, maxTime;
			if(fpick == 27) maxQuan = OrganInfo[wh][gUnitStat][10], maxTime = PlayerInfo[playerid][pGacc][0]+OrganInfo[wh][gUnitStat][14]*60;
			else if(fpick == 28) maxQuan = OrganInfo[wh][gUnitStat][11], maxTime = PlayerInfo[playerid][pGacc][1]+OrganInfo[wh][gUnitStat][15]*60;
			else if(fpick == 29) maxQuan = OrganInfo[wh][gUnitStat][12], maxTime = PlayerInfo[playerid][pGacc][2]+OrganInfo[wh][gUnitStat][16]*60;
			else if(fpick == 30) maxQuan = OrganInfo[wh][gUnitStat][13], maxTime = PlayerInfo[playerid][pGacc][3]+OrganInfo[wh][gUnitStat][17]*60;
			else if(fpick >= 4 && fpick <= 7) maxQuan = OrganInfo[wh][gUnitStat][22], maxTime = PlayerInfo[playerid][pGacc][8]+OrganInfo[wh][gUnitStat][23]*60;
			
			if(maxTime > 0 && maxTime > unixtime) return format(store,sizeof(store),"{FF6347}Вы не можете сейчас взять этот предмет [ Через %d мин. ]\n\n{cccccc}Ограничения устанавливает руководитель", maxQuan), ErrorMessage(playerid, store);
			format(store,sizeof(store),"{cccccc}Чтобы взять {ff9000}%s {cccccc}введите количество\n\n{cccccc}Не меньше 1 и не больше %d\nЛимиты устанавливает руководитель",friskName[fpick], maxQuan);
			ShowDialog(playerid,967,DIALOG_STYLE_INPUT,"{ff9000}Склад",store,"Принять","Отмена");
			return 1;
		}
		if(fpick == 8) // Аптечка
		{
			if(PlayerInfo[playerid][pGacc][5]+OrganInfo[wh][gUnitStat][19]*60 > unixtime) return format(store,sizeof(store),"{FF6347}Вы не можете сейчас взять предмет [ Через %d мин. ]\n\n{cccccc}Ограничения устанавливает руководитель", ((PlayerInfo[playerid][pGacc][5]+OrganInfo[wh][gUnitStat][19]*60)-unixtime)/60), ErrorMessage(playerid, store);
			giveThing = 5;
		}
		yes = 1;
	}

	if(yes == 1)
	{
	    new fpara;
	    if(thingType == 1) fpara = 300000;
	    if(IsHelmet(fpick) && thingType == 2) fpara = 3;
	    if(IsArmor(fpick) && thingType == 2) fpara = 100;
	    OrganInfo[wh][gInvPara][inva] = fpara;
	
		new put_inva = GiveThingPlayer(playerid, fpick, 1, OrganInfo[wh][gInvPara][inva], 0, OrganInfo[wh][gInvType][inva], 0, useinva); // Выдаём предмет игроку
    	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У меня нет места в инвентаре"); // Получили -1 в ответ, значит не нашли ячейку, куда класть предмет
    	SaveInvent(playerid, put_inva);

    	TakeSklad(wh, fpick, 1, thingType, inva);
		PlayerPlaySound(playerid,1052,0,0,0);
    	PlayerPlaySound(playerid, 36401, 0.0, 0.0, 0.0);

    	if(giveThing > 0) PlayerInfo[playerid][pGacc][giveThing] = unixtime;
    	format(store, sizeof(store), "берёт со склада: %s", GetNameThing(0, fpick, thingType, 0));
		SetPlayerChatBubble(playerid,store,COLOR_PURPLE,20.0,5000);
    	OrgLog(wh, "sklad", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 1, GetNameThing(1, fpick, thingType, 0));
	}
	return 1;
}
stock shift_sklad(playerid, wh, getinva, putinva) // Перемещение предметов внутри инвентаря склада организации (с одной ячейки на другую)
{
	if(OnlineInfo[playerid][oShowInterfaceSklad] == wh)
	{
	    if(PlayerInfo[playerid][pLeader] == 0) return ErrorMessage(playerid, "{FF6347}Перемещать предметы может только лидер"), i_resettabs(playerid);
		if(OrganInfo[wh][gInvent][getinva] == 0) return i_resettabs(playerid);
		else if(OrganInfo[wh][gInvent][putinva] != 0) return 1;
		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
		    if(OnlineInfo[playerid][oShowInterfaceSklad] != OnlineInfo[i][oShowInterfaceSklad]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
		    format(store, sizeof(store), "{FF6347}Склад просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, store);
			i_resettabs(playerid);
			return 1;
		}
		OrganInfo[wh][gInvent][putinva] = OrganInfo[wh][gInvent][getinva];
		OrganInfo[wh][gInv][putinva] = OrganInfo[wh][gInv][getinva];
		OrganInfo[wh][gInvType][putinva] = OrganInfo[wh][gInvType][getinva];
		OrganInfo[wh][gInvPara][putinva] = OrganInfo[wh][gInvPara][getinva];
		OrganInfo[wh][gInvent][getinva] = 0;
		OrganInfo[wh][gInv][getinva] = 0;
		OrganInfo[wh][gInvType][getinva] = 0;
		OrganInfo[wh][gInvPara][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, 0, 0, getinva, 0, 0, 0, 0, 0);
		item_second(playerid, OrganInfo[wh][gInvent][putinva], OrganInfo[wh][gInv][putinva], putinva, 0, 300000, OrganInfo[wh][gInvType][putinva], 0, 0);
		OrganInfo[wh][gUpdateSklad] = 1;
	}
	return 1;
}
stock putsklad(wh, pick, kol, fpara, thingType,checklimit)
{
	new put_inva = -1, getLimit, bool:stopFind;
	sklad_limit(pick, thingType, getLimit);
	
	for(new inva = 0; inva < 20; inva++)
	{
		if(OrganInfo[wh][gInvent][inva] == pick && OrganInfo[wh][gInvType][inva] == thingType)
		{
		    if(OrganInfo[wh][gInv][inva]+kol > getLimit && checklimit == 1) // Встроенная проверка на лимит
		    {
		        stopFind = true;
		    }
			else OrganInfo[wh][gInv][inva] += kol, put_inva = inva;
			break;
		}
	}
	if(put_inva == -1 && stopFind == false)
	{
		for(new inva = 0; inva < 20; inva++)
		{
			if(OrganInfo[wh][gInvent][inva] == 0)
			{
				OrganInfo[wh][gInvent][inva] = pick, OrganInfo[wh][gInv][inva] += kol, OrganInfo[wh][gInvPara][inva] = fpara, OrganInfo[wh][gInvType][inva] = thingType, put_inva = inva;
				break;
			}
		}
 	}
 	if(put_inva >= 0)
 	{
 		OrganInfo[wh][gUpdate] = 1;
	 	foreach(Player,i)
		{
			if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowInterfaceSklad] == wh) tilesklad(i, OrganInfo[wh][gInvent][put_inva], OrganInfo[wh][gInv][put_inva], put_inva, thingType);
		}
	}
	return put_inva;
}
stock TakeSklad(g, thingId, quan, thingType, dopinf)
{
	if(OrganInfo[g][gInvent][dopinf] == thingId && OrganInfo[g][gInvType][dopinf] == thingType)
	{
		if(OrganInfo[g][gInv][dopinf]-quan <= 0)
		{
	   		OrganInfo[g][gInvent][dopinf] = 0;
	   		OrganInfo[g][gInv][dopinf] = 0;
	   		OrganInfo[g][gInvType][dopinf] = 0;
	   		OrganInfo[g][gInvPara][dopinf] = 0;
		}
		else OrganInfo[g][gInv][dopinf] -= quan;
	}
	OrganInfo[g][gUpdate] = 1;
	foreach(Player, i)
	{
		if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowInterfaceSklad] == g) tilesklad(i, OrganInfo[g][gInvent][dopinf], OrganInfo[g][gInv][dopinf], dopinf, OrganInfo[g][gInvType][dopinf]);
	}
	return 1;
}
stock SaveSklad(idx) // Сохранение всего склада организации по циклу
{
	format(big_query,sizeof(big_query),"UPDATE `pp_organization` SET `Invent0` = '%d', `Inv0` = '%d', `InvType0` = '%d', `InvPara0` = '%d'",
	OrganInfo[idx][gInvent][0], OrganInfo[idx][gInv][0], OrganInfo[idx][gInvType][0], OrganInfo[idx][gInvPara][0]);

	for(new i = 1; i < 20; i++) format(big_query,sizeof(big_query),"%s, `Invent%d` = '%d', `Inv%d` = '%d', `InvType%d` = '%d', `InvPara%d` = '%d'", big_query,
	i, OrganInfo[idx][gInvent][i], i, OrganInfo[idx][gInv][i], i, OrganInfo[idx][gInvType][i], i, OrganInfo[idx][gInvPara][i]);

    format(big_query,sizeof(big_query),"%s WHERE `frakid` = '%d'", big_query, idx);
	query_empty(pearsq_2, big_query);
	return 1;
}
stock sklad_limit(thingId, thingType, &getLimit) // Проверяем лимиты склада организации
{
	if(thingType == 0) // Обычные Предметы
	{
	    if(thingId >= 4 && thingId <= 8) getLimit = 10000; // Вещества
	    else if(thingId >= 27 && thingId <= 30) getLimit = 20000; // Патроны
	    else getLimit = 1000; // На случай ошибки, остальные предметы лимит 1к
 	}
	else if(thingType == 1) getLimit = 500; // Оружие
    else if(thingType == 2) getLimit = 1000; // Каски и Бронежилеты (Аксессуары)
    else getLimit = 1000; // На случай ошибки, остальные предметы лимит 1к
	return 1;
}

stock get_sklad(g, thingId, thingType) // Поиск при добавлении нового предмета
{
	new quan = 0;
	for(new inva = 0; inva < 20; inva++)
	{
		if(OrganInfo[g][gInvent][inva] == thingId && OrganInfo[g][gInvType][inva] == thingType) quan += OrganInfo[g][gInv][inva];
	}
	return quan;
}
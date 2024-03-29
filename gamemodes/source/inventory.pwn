//==================================
//=====[ Параметры Инвентарей ]=====
//==================================
// Добавление нового Предмета:
// 0. INVENTER + 1 предмет
// 1. fdrawName и fdrawNameEN - его название в текстдравах
// 2. friskName - просто его название
// 3. friskPick - его модель объекта на текстдравах
// 4. friskDefault - гос. цена предмета

// Не количественный:
// 5. player_tile (юзать его только и всё)

// Количественный:
// 6. stock CheckThingQuan (добавить туда id предмета, который имеет количество)
// 7. player_tile (юзать предмет)
// 8. v_limit - лимиты багажника (сколько помещается)
// 9. d_limit - лимиты дома (сколько помещается)
// 10. i_limit - лимиты инвентаря (сколько помещается)
// 11. pt_limit - лимиты тумбы в тюрьме

#define INVENTER 204 // Максимальный ID (обычный предмет)

// Тип товара (0 обычный, 1 оружие, 2 аксессуар, 3 одежда, 4 мебель, 5 транспорт)
// Упаковка (0 предмет, 1 подарок, 2 ящик, 3 Мешок, 4 Запечатанный Ящик, 5 Кейс)

new fdrawName[][] = // Название Вещи
{
    "","X‡EЂ","€O‡OЏOE_KO‡’‰O","ЂYЏ‘‡KA","ЏPA‹A","OЂO‡OЌKA ЏAЂ‡EЏK…","‚P…Ђ‘","ЊOPOЋOK","AЊЏEЌKA","KAH…CЏPA","ЊO•C_CO_‹€P‘‹ЌAЏKO…",
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
	"YЌEЂH…K","YЌEЂH…K","YЌEЂH…K","YЌEЂH…K","ЊPA‹A HA A‹ЏO","A‹…A ‡…‰EH3…•","ЊPA‹A HA KAЏEP","MOЏO ‡…‰EH3…•","ѓЊ…‡OM","‡…‰EH3…• HA OPY„…E 1",
	"‡…‰EH3…• HA OPY„…E 2","TOPT","KYCOK ЏOPЏA", "Њ…‰‰A", "Њ…‰‰A ѓOM.", "KYCOK Њ…‰‰‘", "M•CO ‹ YЊAK.", "C‘PO† CЏE†K", "„APEH‘† CЏE†K", "‡OMЏ…K X‡EЂA",
	"COK AЊE‡’C…H.", "COK •Ђ‡OЌ.", "O‹OЉ…", "C…‚HA‡…?A‰…•", "C…‚HA‡…?A‰…•", "C…‚HA‡…?A‰…•", "ЏOЊ‡…‹O", "MOPO„EHOE", "ЏAЂ‡EЏKA 3AЉ…Џ‘", "…3O‡EHЏA",
	"ѓEЏA‡’ ЂOMЂ‘","PEM.KOMЊ‡EKЏ A‹ЏO","KPACKA ѓ‡• ЏPAHCЊOPЏA","ABTOMO6NLJHSE_DNCKN","FNDPABLNKA","3AKNCJ_A3OTA","DETALJ_TUHNHFA","KENC","PEM.KOMЊ‡EKЏ MOЏO","PEM.KOMЊ‡EKЏ A‹…A",
	"PEM.KOMЊ‡EKЏ KAЏEPO‹","HAMA3‡‘K","P‘ЂKA", "KOPM ѓ‡• P‘ЂOK","ЊAKEЏ", "ЂA‡OHЌ…K C KPACKO†","ЏAЂ‡EЏKA AЏAK…","OЂ‘ЌHA• C…‚HA‡…3A‰…•","Y‡YЌЋEHHA• C…‚HA‡…3A‰…•","MEЏA‡…ЌECKA• ЏPYЂA",
	"‹…‡KA", "KAPЏ‘ ѓOCЏYЊA Џ”P’M‘"
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
	"ORANGE JUICE","APPLE JUICE","VEGETABLES","ALARM","ALARM","ALARM","FUEL", "ICE CREAM", "PILL DEFENCE", "DUCT TAPE",
	"BOMB SPARE PART","REPAIR KIT AUTO","VEHICLE PAINT","CAR WHEELS","HYDRAULICS","NITROUS OXIDE","TUNING COMPONENT","CASE","REPAIR KIT MOTO","REPAIR KIT AVIA",
	"REPAIR KIT BOAT","NAMAZLYK","AQUA FISH", "FISH FOOD", "PACKAGE", "CANS OF PAINT","PILL ATTACK","IMPROVED ALARM SYSTEM","THE USUAL ALARM SYSTEM","METAL PIPE",
	"FORK","PRISON ACCESS CARDS"
};
new friskName[][] = // Название Вещи
{
    "","Хлеб","Золотое Кольцо","Бутылка","Трава","Оболочка Таблетки","Грибы","Порошок","Аптечка","Канистра","Пояс с Взрывчаткой", // 0 - 10
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
	"Апельсиновый сок", "Яблочный сок", "Овощи", "Дом Сигнализация 1 ур.", "Дом Сигнализация 2 ур.", "Дом Сигнализация 3 ур.", "Топливо", "Мороженое", "Таблетка Защиты","Изолента", // 172 - 181
	"Деталь бомбы","Рем.комплект Авто","Краска для транспорта","Автомобильные диски","Гидравлика","Закись Азота","Деталь Тюнинга","Кейс","Рем.комплект Мото","Рем.комплект Авиа", // 182 - 191
	"Рем.комплект Катеров","Намазлык","Аквариумная рыбка", "Корм для рыбок", "Пакет", "Баллончик с краской","Таблетка Атаки","Обычная Сигнализация","Улучшенная Сигнализация","Металическая Труба", // 192 - 201
	"Вилка","Карта доступа Тюрьмы" // 202 - 203
};
new friskPick[] = // ID Модельки в Инвентаре (обычный предмет)
{
    0,19579,2710,1520,19473,1241,1578,1279,11738,1650,19515, // 0 - 10
    1654,364,19088,1486,2057,19897,19142,1455,18644,19630,19942, // 11 - 21
    2806,2060,19308,1212,18872,2061,2061,2061,2061,18632,18641, // 22 - 32
    3014,2484,1314,19054,19824,19819,19057,3016,19616,19893,18642, // 33 - 43
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
	3082,19921,365,0,0,0,0,19918,19921,19921, // 182 - 191
	19921,2833,1599,19561,1575,365,1241,1614,1615,1135, // 192 - 201
	11715,1581
};

stock CheckThingQuan(t) // Имеет ли предмет количество (1 да, 0 нет)
{
	if(t >= 4 && t <= 9 || t >= 18 && t <= 20 || t == 25 || t >= 27 && t <= 30 || t == 41 || t == 46 || t == 47 || t == 55 || t == 60 || t == 61
	|| t >= 64 && t <= 67 || t >= 71 && t <= 89 || t == 106 || t == 108 || t == 109 || t == 110 || t == 140 || t == 142 || t == 178 || t == 180
	|| t == 181 || t == 197 || t == 198) return 1;
	return 0;
}

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
	1000,1500,3500,1500,7500,10000,10000,0,1000,3000, // 191
	2000,1500,3000,10,100,100,100,10000,50000, 1, // 201
	1,1
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

#define MAX_PRISON_TABLE 16
#define MAX_PRISON_TABLE_SLOTS 20
enum prisTableInfo
{
	ptInvent[MAX_PRISON_TABLE_SLOTS],
	ptInv[MAX_PRISON_TABLE_SLOTS],
	ptInvPara[MAX_PRISON_TABLE_SLOTS],
	ptInvQara[MAX_PRISON_TABLE_SLOTS],
	ptInvType[MAX_PRISON_TABLE_SLOTS],
	ptInvPack[MAX_PRISON_TABLE_SLOTS],
	ptInvPlayer[MAX_PRISON_TABLE_SLOTS]
};
new PrisonTableInfo[MAX_PRISON_TABLE][prisTableInfo];

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

	if(Tabs_Load[playerid] != 6 && Tabs_Load[playerid] != 7)
	{
		if(OnlineInfo[playerid][oShowTabs] == 9999) return ErrorMessage(playerid, "{FF6347}Ошибка! Вкладка с выбранным предметом закрылась");
	}
	
	new fpick, tab, inva = invatab-20, fpara, thingQuan, thingType, thingPack;
	if(Tabs_Load[playerid] == 1) // Лавка Товаров
	{
	    tab = OnlineInfo[playerid][oShowTabs];
	    if(!IsOnline(tab)) return closetab(playerid, 1);
		fpick = PlayerInfo[tab][pMarkInven][inva];
		thingQuan = PlayerInfo[tab][pMarkInvenQuan][inva];
		fpara = PlayerInfo[tab][pMarkInvenPara][inva];
		thingType = PlayerInfo[tab][pMarkInvenType][inva];
		thingPack = PlayerInfo[tab][pMarkInvenPack][inva];
	}
	else if(Tabs_Load[playerid] == 2) // Дом
	{
		tab = OnlineInfo[playerid][oShowTabs];
		fpick = DomInfo[tab][dInvent][inva];
		thingQuan = DomInfo[tab][dInv][inva];
		fpara = DomInfo[tab][dInvPara][inva];
		thingType = DomInfo[tab][dInvType][inva];
		thingPack = DomInfo[tab][dInvPack][inva];
	}
	else if(Tabs_Load[playerid] == 3) // Склад Организации
	{
		tab = OnlineInfo[playerid][oShowTabs];
		fpick = OrganInfo[tab][gInvent][inva];
		thingQuan = OrganInfo[tab][gInv][inva];
		thingType = OrganInfo[tab][gInvType][inva];
		thingPack = 0;
	}
	else if(Tabs_Load[playerid] == 4) // Арендованный Склад
	{
		tab = OnlineInfo[playerid][oShowTabs];
		fpick = WhInfo[tab][wInvent][inva];
		thingQuan = WhInfo[tab][wInv][inva];
		thingType = WhInfo[tab][wInvType][inva];
		thingPack = 0;
	}
	else if(Tabs_Load[playerid] == 5) // Багажник
	{
		tab = OnlineInfo[playerid][oShowTabs];
		fpick = VehInfo[tab][vInvent][inva];
		thingQuan = VehInfo[tab][vInv][inva];
		fpara = VehInfo[tab][vInvPara][inva];
		thingType = VehInfo[tab][vInvType][inva];
		thingPack = VehInfo[tab][vInvPack][inva];
	}
	else if(Tabs_Load[playerid] == 6) // Мои Товары
	{
		fpick = PlayerInfo[playerid][pMarkInven][inva];
		thingQuan = PlayerInfo[playerid][pMarkInvenQuan][inva];
		fpara = PlayerInfo[playerid][pMarkInvenPara][inva];
		thingType = PlayerInfo[playerid][pMarkInvenType][inva];
		thingPack = PlayerInfo[playerid][pMarkInvenPack][inva];
	}
	else if(Tabs_Load[playerid] == 7) // Выбошенные Предметы
	{
		if(MyThrow[inva][playerid] >= 0)
		{
			fpick = ThrowInfo[MyThrow[inva][playerid]][tId];
			thingQuan = ThrowInfo[MyThrow[inva][playerid]][tQuan];
			fpara = ThrowInfo[MyThrow[inva][playerid]][tPara];
			thingType = ThrowInfo[MyThrow[inva][playerid]][tType];
			thingPack = ThrowInfo[MyThrow[inva][playerid]][tPack];
		}
	}
	else if(Tabs_Load[playerid] == 8) // Мусорный Контейнер
	{
		tab = OnlineInfo[playerid][oShowTabs];
		fpick = gTrash[inva][tab];
		thingQuan = gTrashKol[inva][tab];
		fpara = gTrashPara[inva][tab];
		thingType = gTrashType[inva][tab];
		thingPack = gTrashPack[inva][tab];
	}
	else if(Tabs_Load[playerid] == 9) // Биз
	{
		tab = OnlineInfo[playerid][oShowTabs];
		fpick = BizzInfo[tab][bInvent][inva];
		thingQuan = BizzInfo[tab][bInv][inva];
		fpara = BizzInfo[tab][bInvPara][inva];
		thingType = BizzInfo[tab][bInvType][inva];
		thingPack = BizzInfo[tab][bInvPack][inva];
	}
	else if(Tabs_Load[playerid] == 14) // Тумба
	{
		tab = OnlineInfo[playerid][oShowTabs];
		fpick = PrisonTableInfo[tab][ptInvent][inva];
		thingQuan = PrisonTableInfo[tab][ptInv][inva];
		fpara = PrisonTableInfo[tab][ptInvPara][inva];
		thingType = PrisonTableInfo[tab][ptInvType][inva];
		thingPack = PrisonTableInfo[tab][ptInvPack][inva];
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
				else if(Tabs_Load[playerid] == 14) shift_prisontable(playerid, tab, OnlineInfo[playerid][oInventSelectRight], inva);
				else i_resettabs(playerid);
			}
		}
		else if(OnlineInfo[playerid][oInventSelectLeft] != 9999) // Кладём предмет из инвентаря в другой
		{
		    new myinva = OnlineInfo[playerid][oInventSelectLeft], myfpick = PlayerInfo[playerid][pInven][myinva], myThingType = PlayerInfo[playerid][pInvenType][myinva], myThingPack = PlayerInfo[playerid][pInvenPack][myinva];
		    if(NotGiveThing(myfpick, myThingType, PlayerInfo[playerid][pInvenQuan][myinva])) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя передавать, продавать или убирать"), i_resetveshi(playerid);
		    
			new string[120];
			if(Tabs_Load[playerid] == 2) // Дом
			{
			    if(myThingType == 0 && myThingPack == 0)
			    {
			        if(CheckThingQuan(myfpick) == 1)
			        {
			            OnlineInfo[playerid][oInventSelectRight] = inva;
						format(string,sizeof(string),"{cccccc}Чтобы положить в дом {ff9000}%s {cccccc}введите количество\nНе меньше 1 и не больше 1.000.000",GetNameThing(1, myfpick, myThingType, myThingPack));
						ShowDialog(playerid,773,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
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
			        if(CheckThingQuan(myfpick) == 1)
			        {
			            OnlineInfo[playerid][oInventSelectRight] = inva;
						format(string,sizeof(string),"{cccccc}Чтобы положить в багажник {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(1, myfpick, myThingType, myThingPack));
						ShowDialog(playerid,775,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
						return 1;
			        }
			    }
			    put_boot(playerid, myinva, tab, myfpick, PlayerInfo[playerid][pInvenQuan][myinva], inva, myThingType, myThingPack);
			}
			else if(Tabs_Load[playerid] == 6) // Мои Товары
			{
			    if(myThingType == 0 && myThingPack == 0)
			    {
			        if(CheckThingQuan(myfpick) == 1)
			        {
			            OnlineInfo[playerid][oInventSelectRight] = inva;
						format(string,sizeof(string),"{cccccc}Чтобы выставить на продажу {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(1, myfpick, myThingType, myThingPack));
						ShowDialog(playerid,1103,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
						return 1;
			        }
			    }
			    new put_invent = put_goods(playerid, myinva, myfpick, PlayerInfo[playerid][pInvenQuan][myinva], inva);
			    if(put_invent == -1) return ErrorMessage(playerid, "{FF6347}В разделе товаров нет места"), i_resetveshi(playerid);
			}
			else if(Tabs_Load[playerid] == 9) return ErrorMessage(playerid, "{FF6347}На склад бизнеса нельзя класть обычные предметы\n\n{cccccc}Только мебель из IKEA или багажника автомобиля"), i_resetveshi(playerid);
			else if(Tabs_Load[playerid] == 14) // Тумба
			{
			    if(myThingType == 0 && myThingPack == 0)
			    {
			        if(CheckThingQuan(myfpick) == 1)
			        {
			            OnlineInfo[playerid][oInventSelectRight] = inva;
						format(string,sizeof(string),"{cccccc}Чтобы положить в тумбу {ff9000}%s {cccccc}введите количество\nНе меньше 1 и не больше 1.000.000",GetNameThing(1, myfpick, myThingType, myThingPack));
						ShowDialog(playerid,929,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
						return 1;
			        }
			    }
			    put_prisontable(playerid, myinva, tab, myfpick, PlayerInfo[playerid][pInvenQuan][myinva], inva, myThingType, myThingPack);
			}
			else i_resetveshi(playerid);
		}
	}
	else if(fpick > 0) // Что-то Лежит
	{
		if(OnlineInfo[playerid][oInventSelectRight] == 9999) // Выделяем
		{
		    if(Pagetwo[playerid] == 0 && inva <= 19) PlayerTextDrawBackgroundColour(playerid, PlaNestPick[inva+20][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva+20][playerid]);
			else if(Pagetwo[playerid] == 1 && inva >= 20 && inva <= 39) PlayerTextDrawBackgroundColour(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva][playerid]);
			else if(Pagetwo[playerid] == 2 && inva >= 40 && inva <= 59) PlayerTextDrawBackgroundColour(playerid, PlaNestPick[inva-20][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva-20][playerid]);
			else if(Pagetwo[playerid] == 3 && inva >= 60 && inva <= 79) PlayerTextDrawBackgroundColour(playerid, PlaNestPick[inva-40][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva-40][playerid]);
			i_infofpick(playerid, fpick, thingQuan, inva, Tabs_Load[playerid], fpara, thingType, thingPack);
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
			        if(CheckThingQuan(myfpick) == 1)
			        {
						new string[130];
			        	if(Tabs_Load[playerid] == 2) // Дом
						{
							format(string,sizeof(string),"{cccccc}Чтобы положить в дом {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(1, myfpick, myThingType, myThingPack));
							ShowDialog(playerid,773,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
						}
						else if(Tabs_Load[playerid] == 3 || Tabs_Load[playerid] == 4) return ErrorMessage(playerid, "{FF6347}Вы не можете положить предметы на склад\n\n{cccccc}Только ящики с оружием и аммуницией"), i_resetveshi(playerid); // Склады
						else if(Tabs_Load[playerid] == 5) // Багажник
						{
							format(string,sizeof(string),"{cccccc}Чтобы положить в багажник {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(1, myfpick, myThingType, myThingPack));
							ShowDialog(playerid,775,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
						}
						else if(Tabs_Load[playerid] == 14) // Тумба
						{
							format(string,sizeof(string),"{cccccc}Чтобы положить в тумбу {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 1.000.000",GetNameThing(1, myfpick, myThingType, myThingPack));
							ShowDialog(playerid,929,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
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
			else if(Tabs_Load[playerid] == 14) return use_prisontable(playerid, tab, inva, 9999);
		}
		else if(OnlineInfo[playerid][oInventSelectRight] != 9999 && OnlineInfo[playerid][oInventSelectRight] != inva)
		{
			if(Tabs_Load[playerid] == 1 || Tabs_Load[playerid] == 6 || Tabs_Load[playerid] == 7 || Tabs_Load[playerid] == 3 || Tabs_Load[playerid] == 4 || Tabs_Load[playerid] == 9) return i_resettabs(playerid);
		    new tabfpick, tabType, tabPack;
			if(Tabs_Load[playerid] == 2) tabfpick = DomInfo[tab][dInvent][OnlineInfo[playerid][oInventSelectRight]], tabType = DomInfo[tab][dInvType][OnlineInfo[playerid][oInventSelectRight]], tabPack = DomInfo[tab][dInvPack][OnlineInfo[playerid][oInventSelectRight]]; // Дом
			else if(Tabs_Load[playerid] == 5) tabfpick = VehInfo[tab][vInvent][OnlineInfo[playerid][oInventSelectRight]], tabType = VehInfo[tab][vInvType][OnlineInfo[playerid][oInventSelectRight]], tabPack = VehInfo[tab][vInvType][OnlineInfo[playerid][oInventSelectRight]]; // Багажник
			else if(Tabs_Load[playerid] == 14) tabfpick = PrisonTableInfo[tab][ptInvent][OnlineInfo[playerid][oInventSelectRight]], tabType = PrisonTableInfo[tab][ptInvType][OnlineInfo[playerid][oInventSelectRight]], tabPack = PrisonTableInfo[tab][ptInvType][OnlineInfo[playerid][oInventSelectRight]]; // Тумба
			
			if(tabfpick > 0 && fpick == tabfpick)
			{
			    if(tabType == 0 && tabPack == 0) // Только обычные предметы
			    {
			    	if(CheckThingQuan(fpick) == 1) // Если количественные, складываем их в одну ячейку
					{
						if(Tabs_Load[playerid] == 2) return mix_dom(playerid, tab, OnlineInfo[playerid][oInventSelectRight], inva);
						else if(Tabs_Load[playerid] == 5) return mix_boot(playerid, tab, OnlineInfo[playerid][oInventSelectRight], inva);
						else if(Tabs_Load[playerid] == 14) return mix_prisontable(playerid, tab, OnlineInfo[playerid][oInventSelectRight], inva);
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
	if(NotGiveThing(fpick, thingType, PlayerInfo[playerid][pInvenQuan][inva])) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя продать этому игроку");

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

	new string[180];
	if(thingType == 0 && thingPack == 0)
	{
	    if(CheckThingQuan(fpick) == 1)
	    {
		    format(string,sizeof(string),"{cccccc}Покупатель: %s\nПредмет: {99ff66}%s\n{cccccc}Введите количество\n\nНе меньше 1 и не больше 100.000", rpplayername(giveplayerid), GetNameThing(1, fpick, thingType, thingPack));
			ShowDialog(playerid,1096,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
			return 1;
		}
	}
	format(string,sizeof(string),"{cccccc}Покупатель: %s\nПредмет: {99ff66}%s\n{cccccc}Введите стоимость\n\nНе меньше 1$ и не больше 100.000.000$", rpplayername(giveplayerid), GetNameThing(1, fpick, thingType, thingPack));
	ShowDialog(playerid,1097,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
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
	if(NotGiveThing(fpick, thingType, PlayerInfo[playerid][pInvenQuan][inva])) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя передать этому игроку");
	if(fpick == 48 && thingType == 0 && OnlineInfo[playerid][oInflatableBoat] != NON) return ErrorMessage(playerid, "{FF6347}Вам нужно сдуть лодку, прежде чем её передать или убрать");

	// Проверка на наличие особых аксессуаров (Каска и Броня)
	if(IsArmor(fpick) && thingType == 2 && PlayerInfo[giveplayerid][pArmor] >= 1) return ErrorMessage(playerid, "{FF6347}У игрока уже есть этот предмет\n\n{cccccc}Учитывается надетая броня");

	new fpara = PlayerInfo[playerid][pInvenPara][inva], fqara = PlayerInfo[playerid][pInvenQara][inva];

	new string[180];
	// Проверка на лимиты количественного предмета
	new quanThing;
	if(thingType == 0) // Обычный предмет
	{
	    if(CheckThingQuan(fpick) == 1) // Предмет имеет количество
		{
		    if(thingPack == 0) quanThing = 1;
		    new getQuan, getLimit;
		    i_limit(giveplayerid, fpick, getQuan, getLimit);
		    if(getQuan+fquan > getLimit)
		    {
		        format(string,sizeof(string),"{FF6347}У игрока нет места в инвентаре\nЛимит для этого предмета: %d\n\n{cccccc}Учитываются упакованные предметы, а так-же раздел товаров", getLimit);
		        ErrorMessage(playerid, string);
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

    format(string, sizeof(string), "[ Мысли ]: Я передал%s %s предмет: {444444}%s", gender(playerid), playername(giveplayerid), GetNameThing(1, fpick, thingType, thingPack));
	SendClientMessage(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "[ Мысли ]: %s передал%s мне предмет: {444444}%s", playername(playerid), gender(playerid), GetNameThing(0, fpick, thingType, thingPack));
	SendClientMessage(giveplayerid, COLOR_GREY, string);
	format(string, sizeof(string), "* %s достаёт %s и передаёт %s.", playername(playerid), GetNameThing(0, fpick, thingType, thingPack), playername(giveplayerid));
	ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
    PlayerPlaySound(playerid,1053,0,0,0), PlayerPlaySound(giveplayerid,1052,0,0,0);
    
    SaveInvent(playerid, inva);
    SaveInvent(giveplayerid, put_inva);

    // Логируем передачу
    format(string,sizeof(string),"Передал: %s", GetNameThing(1, fpick, thingType, thingPack));
	UserLog("give", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], fquan, string);
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
	    if(CheckThingQuan(fpick) == 1)
	    {
	        DP[0][playerid] = giveplayerid;
	        DP[1][playerid] = inva;
	        DP[2][playerid] = fpick;
			new string[140];
	    	format(string,sizeof(string),"{cccccc}Чтобы передать %s {ff9000}%s {cccccc}введите количество\n\nНе меньше 1 и не больше 100.000", playername(giveplayerid), GetNameThing(1, fpick, thingType, thingPack));
			ShowDialog(playerid,906,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
			return 1;
		}
	}
	give_invent(playerid, giveplayerid, fpick, fquan, thingType, thingPack, inva);
	return 1;
}
//=================================
// Интерфейс Инвентаря
stock i_infofpick(playerid, fpick, thingQuan, inva, sels, fpara, thingType, thingPack) // Отображение выбранного предмета
{
	new string[60];
	new yesFindModel;
	if(thingPack == 1)
	{
	    if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(string, sizeof(string), "ЊOѓAPOK");
		else format(string, sizeof(string), "GIFT");
	}
	else if(thingPack == 2)
	{
	    if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(string, sizeof(string), "•Љ…K");
		else format(string, sizeof(string), "BOX");
	}
	else if(thingPack == 4)
	{
	    if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(string, sizeof(string), "3AЊEЌAЏAHH‘† •Љ…K");
		else format(string, sizeof(string), "SEALED BOX");
	}
	else if(thingPack == 5)
	{
	    if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(string, sizeof(string), "KE†C");
		else format(string, sizeof(string), "CASE");
	}
	else
	{
	    if(thingType == 0) // Обычный предмет
	    {
	        if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(string, sizeof(string), "%s", fdrawName[fpick]);
			else format(string, sizeof(string), "%s", fdrawNameEN[fpick]);
	    }
	    else if(thingType == 1) // Оружие
	    {
		    format(string, sizeof(string), "%s", gunDraw[fpick]);
	    }
	    else if(thingType == 2) // Аксессуар
	    {
			if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(string, sizeof(string), "AKCECCYAP");
			else format(string, sizeof(string), "ACCESSORY");
		}
		else if(thingType == 3) // Одежда
	    {
			if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(string, sizeof(string), "OѓE„ѓA");
			else format(string, sizeof(string), "CLOTHES");
		}
		else if(thingType == 4) // Мебель
	    {
			if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(string, sizeof(string), "MEЂE‡’");
			else format(string, sizeof(string), "FURNITURE");
		}
		else if(thingType == 5) // Транспорт
	    {
			if(PlayerInfo[playerid][pDrawLanguage] == false && Device[playerid] != 1) format(string, sizeof(string), "ЏPAHCЊOPЏ");
			else format(string, sizeof(string), "VEHICLE");
		}
	}
	
	yesFindModel = GetModelPickItem(playerid, fpick, thingType, fpara, thingPack, sels);
	if(yesFindModel > 0)
	{
	    new Float:modelPos[4], findIt;
		GetModelTextDraw(yesFindModel, thingType,thingPack, modelPos[0], modelPos[1], modelPos[2], modelPos[3], findIt);
		PlayerTextDrawSetPreviewModel(playerid, PlaNestOthe[2][playerid], yesFindModel);

		if(thingType == 5) PlayerTextDrawSetPreviewVehicleColours(playerid, PlaNestOthe[2][playerid], thingQuan, thingQuan);
		PlayerTextDrawSetPreviewRot(playerid, PlaNestOthe[2][playerid], modelPos[0], modelPos[1], modelPos[2], modelPos[3]);
	}
	
	PlayerTextDrawSetString(playerid, PlaNestOthe[1][playerid], string);
	PlayerTextDrawColour(playerid, PlaNestOthe[2][playerid], -1);
	PlayerTextDrawSetSelectable(playerid, PlaNestOthe[2][playerid], true);
	PlayerTextDrawShow(playerid, PlaNestOthe[1][playerid]);
	PlayerTextDrawShow(playerid, PlaNestOthe[2][playerid]);

	if(sels == 1 || sels == 6)
	{
		if(Tabs_Load[playerid] == 6) format(string, sizeof(string), "%d$", PlayerInfo[playerid][pMarkPrice][inva]), PlayerTextDrawSetString(playerid, PlaNestPrice[playerid], string), PlayerTextDrawShow(playerid, PlaNestPrice[playerid]);
		else if(Tabs_Load[playerid] == 1)
		{
		    new p = Tabs_ID[playerid];
		    if(IsOnline(p)) format(string, sizeof(string), "%d$", PlayerInfo[p][pMarkPrice][inva]), PlayerTextDrawSetString(playerid, PlaNestPrice[playerid], string), PlayerTextDrawShow(playerid, PlaNestPrice[playerid]);
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
		if(Page[p] == 1 && OnlineInfo[p][oInventSelectLeft] >= 20) PlayerTextDrawBackgroundColour(p, PlaNestPick[OnlineInfo[p][oInventSelectLeft]-20][p], PlayerInfo[p][pStyle1]),PlayerTextDrawShow(p, PlaNestPick[OnlineInfo[p][oInventSelectLeft]-20][p]);
		else if(Page[p] == 0 && OnlineInfo[p][oInventSelectLeft] <= 19) PlayerTextDrawBackgroundColour(p, PlaNestPick[OnlineInfo[p][oInventSelectLeft]][p], PlayerInfo[p][pStyle1]),PlayerTextDrawShow(p, PlaNestPick[OnlineInfo[p][oInventSelectLeft]][p]);
		OnlineInfo[p][oInventSelectLeft] = 9999;
		if(OnlineInfo[p][oInventSelectRight] == 9999) reset_pick_othe(p), PlayerTextDrawShow(p, PlaNestOthe[2][p]);
	}
	return 1;
}
stock i_resettabs(p) // Сброс отображения выбранной ячейки второго раздела
{
	if(OnlineInfo[p][oShowInterface] == 1 && OnlineInfo[p][oInventSelectRight] != 9999)
	{
	    if(Tabs_Load[p] > 0)
	    {
	        new plusitem = 1000;
			if(Pagetwo[p] == 0 && OnlineInfo[p][oInventSelectRight] >= 0 && OnlineInfo[p][oInventSelectRight] <= 19) plusitem = 20;
			else if(Pagetwo[p] == 1 && OnlineInfo[p][oInventSelectRight] >= 20 && OnlineInfo[p][oInventSelectRight] <= 39) plusitem = 0;
			else if(Pagetwo[p] == 2 && OnlineInfo[p][oInventSelectRight] >= 40 && OnlineInfo[p][oInventSelectRight] <= 59) plusitem = -20;
			else if(Pagetwo[p] == 3 && OnlineInfo[p][oInventSelectRight] >= 60 && OnlineInfo[p][oInventSelectRight] <= 79) plusitem = -40;

			if(plusitem != 1000)
			{
				if(Tabs_Load[p] == 6) PlayerTextDrawBackgroundColour(p, PlaNestPick[OnlineInfo[p][oInventSelectRight]+plusitem][p], PlayerInfo[p][pStyle2]);
				else if(Tabs_Load[p] == 7)
				{
					new t = MyThrow[OnlineInfo[p][oInventSelectRight]][p];
					if(t != -1)
					{
						if(ThrowInfo[t][tPlayerid] == PlayerInfo[p][pID]) PlayerTextDrawBackgroundColour(p, PlaNestPick[OnlineInfo[p][oInventSelectRight]+plusitem][p], -226); // Если предмет оставил этот игрок
						else PlayerTextDrawBackgroundColour(p, PlaNestPick[OnlineInfo[p][oInventSelectRight]+plusitem][p], 40); // Если предмет оставил хер знает кто
					}
				}
				else PlayerTextDrawBackgroundColour(p, PlaNestPick[OnlineInfo[p][oInventSelectRight]+plusitem][p], PlayerInfo[p][pStyle1]);
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
		PlayerTextDrawHide(playerid, PlaNestPickNum[cell][playerid]);

		ShowPickItem(playerid, cell, cell2, 0, item, quan, para, thingType, thingPack, -1, PlaNestPick[cell][playerid], PlaNestPickNum[cell][playerid], 0);
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

		ShowPickItem(playerid, inva, inva2, stat, fpick, fquan, fpara, thingType, thingPack, throwPlayerId, PlaNestPick[inva][playerid], PlaNestPickNum[inva][playerid], 1);
	}
	return 1;
}
stock textPickInventory(playerid, inva, const text[])
{
	PlayerTextDrawSetString(playerid, PlaNestPickNum[inva][playerid], text);
	if(PlayerInfo[playerid][pSty] == 6 || PlayerInfo[playerid][pSty] == 11) PlayerTextDrawColour(playerid, PlaNestPickNum[inva][playerid], 673720575);
	else PlayerTextDrawColour(playerid, PlaNestPickNum[inva][playerid], -1);
	PlayerTextDrawShow(playerid, PlaNestPickNum[inva][playerid]);
	return 1;
}

stock ShowPickItem(playerid, inva, inva2, stat, thingId, thingQuan, thingPara, thingType, thingPack, throwPlayerId, PlayerText:textdraw, PlayerText:textdrawnum, razdel)
{
	new yesFindModel;
	if(thingId == 0) // Пустая ячейка
	{
		if(stat == 0) // Основные вкладки
		{
			PlayerTextDrawFont(playerid, textdraw, TEXT_DRAW_FONT:4);
			PlayerTextDrawBackgroundColour(playerid, textdraw, PlayerInfo[playerid][pStyle1]);
			PlayerTextDrawColour(playerid, textdraw, PlayerInfo[playerid][pStyle1]);
			PlayerTextDrawBoxColour(playerid, textdraw, 0);
		}
		else if(stat == 1) // Раздел торговли
		{
			PlayerTextDrawFont(playerid, textdraw, TEXT_DRAW_FONT:4);
			PlayerTextDrawBackgroundColour(playerid, textdraw, PlayerInfo[playerid][pStyle2]);
			PlayerTextDrawColour(playerid, textdraw, PlayerInfo[playerid][pStyle2]);
			PlayerTextDrawBoxColour(playerid, textdraw, 0);
		}
		else if(stat == 2) // Рядом
		{
			PlayerTextDrawFont(playerid, textdraw, TEXT_DRAW_FONT:5);
			PlayerTextDrawSetPreviewModel(playerid, textdraw, 2485);
			PlayerTextDrawSetPreviewRot(playerid, textdraw, 0.0, 0.0, 0.0, -1.0);
			PlayerTextDrawBackgroundColour(playerid, textdraw, 80);
			PlayerTextDrawColour(playerid, textdraw, -1);
			PlayerTextDrawBoxColour(playerid, textdraw, 0);
		}
		PlayerTextDrawHide(playerid, textdrawnum);
	}
	else
	{
		new string[28];
		if(stat == 0)
		{
			PlayerTextDrawBackgroundColour(playerid, textdraw, PlayerInfo[playerid][pStyle1]);
			PlayerTextDrawColour(playerid, textdraw, -1);
			PlayerTextDrawBoxColour(playerid, textdraw, 0);
			PlayerTextDrawFont(playerid, textdraw, TEXT_DRAW_FONT:5);
		}
		else if(stat == 1)
		{
			PlayerTextDrawBackgroundColour(playerid, textdraw, PlayerInfo[playerid][pStyle2]);
			PlayerTextDrawColour(playerid, textdraw, -1);
			PlayerTextDrawBoxColour(playerid, textdraw, 0);
			PlayerTextDrawFont(playerid, textdraw, TEXT_DRAW_FONT:5);
		}
		else if(stat == 2)
		{
			PlayerTextDrawColour(playerid, textdraw, -1);
			PlayerTextDrawBoxColour(playerid, textdraw, 0);
			PlayerTextDrawFont(playerid, textdraw, TEXT_DRAW_FONT:5);
			
			if(throwPlayerId == PlayerInfo[playerid][pID]) PlayerTextDrawBackgroundColour(playerid, textdraw, -226); // Если предмет оставил этот игрок
			else PlayerTextDrawBackgroundColour(playerid, textdraw, 80); // Если предмет оставил хер знает кто
		}
		
		yesFindModel = GetModelPickItem(playerid, thingId, thingType, thingPara, thingPack, Tabs_Load[playerid]);
		if(thingType == 0 && thingPack == 0) // Обычный предмет
		{
			if(CheckThingQuan(thingId) == 1) // Количественный
			{
				format(string, sizeof(string), "%d", thingQuan), textPickInventory(playerid, inva, string);
			}
		}
		else if(thingType == 3 && thingPack == 0) // Одежда (Отображаем ID)
		{
			format(string, sizeof(string), "ID %d", thingId), textPickInventory(playerid, inva, string);
		}

		if(razdel == 1 && (Tabs_Load[playerid] == 3 || Tabs_Load[playerid] == 4) && OnlineInfo[playerid][oShowTabs] != 9999) // Склады
		{
			format(string, sizeof(string), "%d", thingQuan), textPickInventory(playerid, inva, string);
		}
	}
	if(OnlineInfo[playerid][oInventSelectRight] == inva2) PlayerTextDrawBackgroundColour(playerid, textdraw, PlayerInfo[playerid][pStyle3]);
	
	if(yesFindModel > 0)
	{
		new Float:modelPos[4], findIt;
		GetModelTextDraw(yesFindModel, thingType,thingPack, modelPos[0], modelPos[1], modelPos[2], modelPos[3], findIt);
		PlayerTextDrawSetPreviewModel(playerid, textdraw, yesFindModel);
		if(thingType == 5 && thingPack == 0) PlayerTextDrawSetPreviewVehicleColours(playerid, textdraw, thingQuan, thingQuan);
		PlayerTextDrawSetPreviewRot(playerid, textdraw, modelPos[0], modelPos[1], modelPos[2], modelPos[3]);
	}
	
	PlayerTextDrawShow(playerid, textdraw);
	return 1;
}

stock GetModelPickItem(playerid, thingId, thingType, thingPara, thingPack, sels)
{
	new yesFindModel;
	if(thingPack == 1) yesFindModel = 19054; // Подарок
	else if(thingPack == 2 || thingPack == 4) yesFindModel = 3014; // Ящик
	else if(thingPack == 3) yesFindModel = 2060; // Мешок
	else if(thingPack == 5) yesFindModel = 19918; // Кейс
	else if(thingPack == 0) // Без упаковки
	{
		if(thingType == 0) yesFindModel = friskPick[thingId]; // Обычный предмет
		if(thingType == 1) // Оружие
		{
			yesFindModel = friskGun[thingId];
			if(thingPara <= 0 && (sels == 0 || sels == 1 || sels == 2 || sels == 5 || sels == 6 || sels == 7 || sels == 8))
			{
				new weaponType = WeaponAmmoType(thingId);
				if(weaponType == 1) yesFindModel = 2034; // Дробовики
				else if(weaponType == 2) yesFindModel = 2034; // Пистолеты
				else if(weaponType == 3) yesFindModel = 2044; // Пистолеты-Пулемёты
				else if(weaponType == 4) yesFindModel = 2035; // Автомат
				else if(weaponType == 5) yesFindModel = 2036; // Дробовик
			}
		}
		if(thingType == 2) yesFindModel = thingId; // Аксессуары
		if(thingType == 3) yesFindModel = GetModelSkin(playerid, thingId); // Одежда
		if(thingType == 4) yesFindModel = thingId; // Мебель
		if(thingType == 5) yesFindModel = GetVehicleModelSync(playerid, thingId); // Транспорт
	}
	return yesFindModel;
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
stock get_clothes(playerid) // Поиск, есть ли у игрока одежда (с проверкой под его пол)
{
	new yesSKin;
	for(new i = 0; i < 40; i++)
	{
		if(PlayerInfo[playerid][pInven][i] == 0) continue;
		if(PlayerInfo[playerid][pInvenType][i] == 3) 
		{
			if(PlayerInfo[playerid][pSex] == 1) // Man
			{
				if(GetSkinSex(PlayerInfo[playerid][pInven][i]) == 1)
				{
					yesSKin = 1;
					break;
				}
			}
			else // Woman
			{
				if(GetSkinSex(PlayerInfo[playerid][pInven][i]) == 2)
				{
					yesSKin = 1;
					break;
				}
			}
		}
	}
	return yesSKin;
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
stock get_watch(playerid) // Поиск аксессуаров часов
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
	new plit = -1;
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
	return plit;
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
	
	if(useinva == 9999 || -1) // Не знаем в какую ячейку класть
	{
	    if(thingType == 0 && thingPack == 0) // Обычный предмет
		{
		    if(CheckThingQuan(thingId) == 1) // Предмет имеет количество (Складывается в одну ячейку)
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
			else if(CheckThingQuan(thingId) == 0) // Объект не имеет количество
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

stock ThingParameters(playerid, thingId, &quan, &para)
{
	new unix = gettime();
	if(thingId == 1 && para == 0) quan = GetFullThingQuan(thingId), para = unix+432000; // Хлеб (Время до испорченности)
	else if(thingId == 6 && para == 0)
	{
		if(quan == 0) quan = GetFullThingQuan(thingId);
		para = unix+604800; // Грибы
	}
	else if(thingId == 14 && para == 0) quan = GetFullThingQuan(thingId), para = unix+7776000; // Пиво (Время до испорченности + количество)
	else if(thingId == 16 && quan == 0) quan = GetFullThingQuan(thingId); // Пачка сигарет (Полный комплект)
	else if(thingId == 18 && para == 0) quan = GetFullThingQuan(thingId), para = unix+604800; // Наживка
	else if(thingId == 19 && quan == 0) quan = GetFullThingQuan(thingId); // Отмычки (Полный комплект)
	else if(thingId == 20 && para == 0) quan = GetFullThingQuan(thingId), para = unix+259200; // Рыба
	else if(thingId == 22 && para == 0) quan = GetFullThingQuan(thingId), para = unix+259200; // Мясо
	else if(thingId == 26 && PlayerInfo[playerid][pDrugPerk] == 0) quan = GetFullThingQuan(thingId), NumberSmartfonPlayer(playerid); // Смартфон (Номер телефона)
	else if(thingId == 37 && quan == 0) quan = GetFullThingQuan(thingId); // Шампанское (Количество)
	else if(thingId == 41 && quan == 0) quan = GetFullThingQuan(thingId); // Бенгальские свечи (Полный комплект)
	else if(thingId == 48 && para == 0) para = 100; // Надувная лодка (даём ей 100 литров бенза)
	else if(thingId == 54 && para == 0) quan = GetFullThingQuan(thingId), para = unix+259200; // Жареное Мясо
	else if(thingId == 55 && para == 0) quan = GetFullThingQuan(thingId), para = unix+259200; // Жареная Рыба
	else if(thingId == 62) quan = GetFullThingQuan(thingId), SetPVarInt(playerid,"PlayBoy", 1); // Если выдаём Журнал PlayBoy
	else if(thingId == 88 && quan == 0) quan = GetFullThingQuan(thingId); // Семена травы (Полный комплект)
	else if(thingId == 96 && para == 0) quan = GetFullThingQuan(thingId), para = unix+864000; // Кровь вампира
	else if(thingId == 98 && para == 0) quan = GetFullThingQuan(thingId), para = unix+864000; // Кровь человека
	else if(thingId == 99 && para == 0) quan = GetFullThingQuan(thingId), para = unix+604800; // Банан
	else if(thingId == 100 && para == 0) quan = GetFullThingQuan(thingId), para = unix+604800; // Яблоко
	else if(thingId == 101 && para == 0) quan = GetFullThingQuan(thingId), para = unix+604800; // Апельсин
	else if(thingId == 102 && para == 0) quan = GetFullThingQuan(thingId), para = unix+604800; // Молоко
	else if(thingId == 103 && para == 0) quan = GetFullThingQuan(thingId), para = unix+604800; // Тыква
	else if(thingId == 104 && para == 0) quan = GetFullThingQuan(thingId), para = unix+604800; // Картошка
	else if(thingId == 105 && para == 0) quan = GetFullThingQuan(thingId), para = unix+604800; // Томат
	else if(thingId == 107 && para == 0) quan = GetFullThingQuan(thingId), para = unix+864000; // Бычья кровь
	else if(thingId == 112 && quan == 0) quan = GetFullThingQuan(thingId); // бухло
	else if(thingId == 113 && quan == 0) quan = GetFullThingQuan(thingId); // бухло
	else if(thingId == 114 && quan == 0) quan = GetFullThingQuan(thingId); // бухло
	else if(thingId == 115 && quan == 0) quan = GetFullThingQuan(thingId); // бухло
	else if(thingId == 116 && quan == 0) quan = GetFullThingQuan(thingId); // бухло
	else if(thingId == 117 && para == 0) quan = GetFullThingQuan(thingId), para = unix+604800; // Сидр Яблочный
	else if(thingId == 118 && para == 0) quan = GetFullThingQuan(thingId), para = unix+604800; // Сидр Вишневый
	else if(thingId == 119 && para == 0) quan = GetFullThingQuan(thingId), para = unix+604800; // Пиво Разливное
	else if(thingId == 120 && para == 0) quan = GetFullThingQuan(thingId), para = unix+2592000; // Sprunk Банка
	else if(thingId == 121 && para == 0) quan = GetFullThingQuan(thingId), para = unix+172800; // Кофе
	else if(thingId == 124 && para == 0) quan = GetFullThingQuan(thingId), para = unix+172800; // Спранк стакан
	else if(thingId == 125 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Бургер
	else if(thingId == 126 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Бургер (Хз второй)
	else if(thingId == 127 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Ролл
	else if(thingId >= 128 && thingId <= 138 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Наборы с Едой (Подносы)
	else if(thingId == 139 && para == 0) quan = GetFullThingQuan(thingId), para = unix+172800; // Sprunk Открытая банка
	else if(thingId == 141 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // ХОТЕ ДОГЕ
	else if(thingId == 163 && para == 0) quan = GetFullThingQuan(thingId), para = unix+259200; // Свадебный торт (Время до испорченности + количество)
	else if(thingId == 164 && para == 0) SetSatiety(thingId, quan), para = unix+259200; // Кусок торта
	else if(thingId == 165 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Пицца
	else if(thingId == 166 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Пицца Домашняя
	else if(thingId == 167 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Кусок пиццы
	else if(thingId == 168 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Мясо в упаковке
	else if(thingId == 169 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Сырой стейк
	else if(thingId == 170 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Жареный стейк
	else if(thingId == 171 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Ломтик хлеба
	else if(thingId == 172 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // А. Сок
	else if(thingId == 173 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Я. Сок
	else if(thingId == 174 && para == 0) SetSatiety(thingId, quan), para = unix+172800; // Овощи
	else
	{
		if(quan == 0) quan = GetFullThingQuan(thingId);
	}
	return 1;
}
stock put_thing_player(playerid, thingId, quan, para, qara, thingType, thingPack, i)
{
	if(PlayerInfo[playerid][pInven][i] != 0 && PlayerInfo[playerid][pInven][i] != thingId) return -1; // Защита от ошибки, на всякий случай

    if(qara == PlayerInfo[playerid][pID]) qara = 0; // Удаляем статус краденного предмета, если он принадлежит этому игроку
    
    // Выдача особых предметов
    if(thingType == 0) // Обычные предметы
    {
        ThingParameters(playerid, thingId, quan, para);
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
	else if(thingId == 37) quan = 11; // Шампанское
	else if(thingId == 41) quan = 5; // Бенгальские свечи 
	else if(thingId == 62) quan = 1; // PlayBoy
	else if(thingId == 88) quan = 5; // Семена травы
	else if(thingId == 112) quan = 11; // // бухло
	else if(thingId == 113) quan = 11; // // бухло
	else if(thingId == 114) quan = 11; // // бухло
	else if(thingId == 115) quan = 11; // // бухло
	else if(thingId == 116) quan = 11; // // бухло
	else if(thingId == 117) quan = 6; // // бухло
	else if(thingId == 118) quan = 6; // // бухло
	else if(thingId == 119) quan = 6; // // бухло
	else if(thingId == 163) quan = 21; // Свадебный торт
	else if(thingId == 165) quan = 7; // Пицца
	else if(thingId == 166) quan = 10; // Пицца Домашняя
	else if(thingId == 120) quan = 4; // Sprunk Банка
	else if(thingId == 121) quan = 4; // Кофе
	else if(thingId == 124) quan = 4; // Спранк стакан
	else if(thingId == 197) quan = 10; // Баллончик с краской
	else quan = 1;
	return quan;
}

// Сохраняем весь инвентарь
stock SaveInventAll(playerid, bool:transaction = true)
{
	// Начало транзакции
	if(transaction == true) mysql_tquery(pearsq, "START TRANSACTION;");

	for(new i = 0; i < MAX_INVEN; i++) SaveInvent(playerid, i);

	// Завершение транзакции
	if(transaction == true) mysql_tquery(pearsq, "COMMIT;");
	return 1;
}

stock CreateJsonInvent(playerid, i, &JsonNode:node)
{
	if(PlayerInfo[playerid][pInven][i] == 0) 
	{
		node = JSON_INVALID_NODE;
		return 1;
	}

	node = JSON_Object(
		"id", JSON_Int(PlayerInfo[playerid][pInven][i]),
		"quan", JSON_Int(PlayerInfo[playerid][pInvenQuan][i]),
		"para", JSON_Int(PlayerInfo[playerid][pInvenPara][i]),
		"qara", JSON_Int(PlayerInfo[playerid][pInvenQara][i]),
		"type", JSON_Int(PlayerInfo[playerid][pInvenType][i]),
		"pack", JSON_Int(PlayerInfo[playerid][pInvenPack][i])
	);
	return 1;
}

// Сохраняем одну ячейку инвентаря
stock SaveInvent(playerid, i)
{
	new JsonNode:node;
	CreateJsonInvent(playerid, i, node);
	SaveInventByUserID(PlayerInfo[playerid][pID], i, node);
	return 1;
}

stock SaveInventByUserID(user_id, i, JsonNode:node, bool:isMark = false)
{
	if(node == JSON_INVALID_NODE)
	{
		new string_mysql[140];
		format(string_mysql, sizeof(string_mysql), "UPDATE `pp_igroki_inventory` SET `%s_slot_%d`= NULL WHERE `user_id` = '%d'", (isMark ? "m" : "i"), i, user_id);
		mysql_tquery(pearsq, string_mysql);
	}
	else
	{
		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_igroki_inventory` SET `%s_slot_%d`= '%e' WHERE `user_id` = '%d'",
			(isMark ? "m" : "i"), i, string_json, user_id);
			mysql_tquery(pearsq, string_mysql);
		}
	}
	return 1;
}

// Запрос для загрузки инвентаря
function OnPlayerInventoryLoad(playerid, race_check)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);
		OnPlayerLoadInventory(playerid);
		printf("OnPlayerLoadInventory(%s) Инвентарь Найден", PlayerInfo[playerid][pName]);
	}
	return 1;
}

// Новый сток загрузки инвентаря
stock OnPlayerLoadInventory(playerid)
{
	new string[20];
	for(new i = 0; i < MAX_INVEN; i++)
	{
		new bool:is_null;
		format(string, sizeof(string), "i_slot_%d", i);
		cache_is_value_name_null(0, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(0, string, string_json, 512);

			new JsonNode:node = JSON_INVALID_NODE;
			if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
			{
				JSON_GetInt(node, "id", PlayerInfo[playerid][pInven][i]);
				JSON_GetInt(node, "quan", PlayerInfo[playerid][pInvenQuan][i]);
				JSON_GetInt(node, "para", PlayerInfo[playerid][pInvenPara][i]);
				JSON_GetInt(node, "qara", PlayerInfo[playerid][pInvenQara][i]);
				JSON_GetInt(node, "type", PlayerInfo[playerid][pInvenType][i]);
				JSON_GetInt(node, "pack", PlayerInfo[playerid][pInvenPack][i]);

				//new slotLol[512];
				//JSON_GetString(node, "lol", slotLol);
			}
		}
	}

	for(new i = 0; i < MAX_MARK; i++)
	{
		new bool:is_null;
		format(string, sizeof(string), "m_slot_%d", i);
		cache_is_value_name_null(0, string, is_null);

		if(is_null == false)
		{
			new string_json[512];
			cache_get_value_name(0, string, string_json, 512);

			new JsonNode:node = JSON_INVALID_NODE;
			if (JSON_Parse(string_json, node) == JSON_CALL_NO_ERR) 
			{
				JSON_GetInt(node, "id", PlayerInfo[playerid][pMarkInven][i]);
				JSON_GetInt(node, "quan", PlayerInfo[playerid][pMarkInvenQuan][i]);
				JSON_GetInt(node, "para", PlayerInfo[playerid][pMarkInvenPara][i]);
				JSON_GetInt(node, "qara", PlayerInfo[playerid][pMarkInvenQara][i]);
				JSON_GetInt(node, "type", PlayerInfo[playerid][pMarkInvenType][i]);
				JSON_GetInt(node, "pack", PlayerInfo[playerid][pMarkInvenPack][i]);
				JSON_GetInt(node, "price", PlayerInfo[playerid][pMarkPrice][i]);
			}
		}
	}
	return 1;
}

stock OnPlayerFriskOffline(playerid)
{
	new string_mysql[100];
	format(string_mysql,sizeof(string_mysql),"SELECT * FROM `%s` WHERE `user_id` = '%d'", 
		((DP[1][playerid] == 1 || DP[1][playerid] == 2) ? "pp_igroki_inventory" : "pp_igroki"), DP[0][playerid]);
	mysql_tquery(pearsq, string_mysql, "Call_frisk", "ds", playerid, ListName[playerid]);
	return 1;
}

stock OnPlayerTakeOffline(playerid)
{
	new string_mysql[100];
	format(string_mysql,sizeof(string_mysql),"SELECT * FROM `%s` WHERE `user_id` = '%d'", 
		((DP[1][playerid] == 1 || DP[1][playerid] == 2) ? "pp_igroki_inventory" : "pp_igroki"), DP[0][playerid]);
	mysql_tquery(pearsq, string_mysql, "Call_takefrisk", "dsd", playerid, ListName[playerid], ListInva[DP[3][playerid]][playerid]);
	return 1;
}

stock NumberSmartfonPlayer(playerid) // Устанавливаем номер телефона игроку, исходя из уже существующих
{
    if(ServerInfo[54] <= 0) ServerInfo[54] = 9000000; // Если в конфиге нет номера телефона
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
		else if(thingType == 4) format(nameProduct,sizeof(nameProduct),"%s", getIkeaObjectName(thingId));
		else if(thingType == 5) format(nameProduct,sizeof(nameProduct),"%s", GetVehicleName(thingId));
	}
	else if(thingPack >= 1) // 0 предмет, 1 подарок, 2 ящик, 3 Мешок, 4 Запечатанный ящик, 5 кейс (помещается только 1 предмет и занимает 1 ячейку)
	{
	    new hideName[8];
	    if(thingPack == 1) format(hideName,sizeof(hideName),"Подарок");
    	else if(thingPack == 2) format(hideName,sizeof(hideName),"Ящик");
    	else if(thingPack == 3) format(hideName,sizeof(hideName),"Мешок");
		else if(thingPack == 4) format(hideName,sizeof(hideName),"Запечатанный Ящик");
		else if(thingPack == 5) format(hideName,sizeof(hideName),"Кейс");
	    
	    if(readStatus == 0 || thingPack == 5) format(nameProduct,sizeof(nameProduct),"%s", hideName);
	    else // Читаемый, для логов и просмотра содержимого администрацией
		{
			if(thingType == 0) format(nameProduct,sizeof(nameProduct),"%s (%s)", hideName, friskName[thingId]);
			else if(thingType == 1) format(nameProduct,sizeof(nameProduct),"%s (%s)", hideName, gunName[thingId]);
			else if(thingType == 2) format(nameProduct,sizeof(nameProduct),"%s (%s)", hideName, GetNameAccessory(thingId));
			else if(thingType == 3) format(nameProduct,sizeof(nameProduct),"%s (Одежда ID %d)", hideName, thingId);
			else if(thingType == 4) format(nameProduct,sizeof(nameProduct),"%s (%s)", hideName, getIkeaObjectName(thingId));
			else if(thingType == 5) format(nameProduct,sizeof(nameProduct),"%s (%s)", hideName, GetVehicleName(thingId));
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
stock IsAOpenEbalo(i)
{
	if(i == 19801) return 1;
	return 0;
}
stock DocumentThing(i, thingType)
{
	if(i >= 156 && i <= 162 && thingType == 0) return 1;
	return 0;
}
stock PerishableThing(i, type) //  Проверка на портящиеся продукты
{
    if(type == 0 && (i == 1 || i == 6 || i == 18 || i == 20 || i == 22 || i == 54 || i == 55 || i == 96 || i == 98 || i == 99 || i == 100 || i == 101 || i == 102
 	|| i == 103 || i == 104 || i == 105 || i == 107 || i == 14 || i == 117 || i == 118 || i == 119 || i == 120 || i == 121 || i == 124 || i == 125
  	|| i == 126 || i == 127 || i >= 128 && i <= 138 || i == 139 || i == 141 || i == 163 || i == 164 || i == 165 || i == 166 || i == 167
	|| i == 168 || i == 169 || i == 170 || i == 171 || i == 172 || i == 173 || i == 174)) return 1;
	return 0;
}
stock NotGiveThing(i, type, quan)
{
	if(type == 0 && (i == 10 || i == 12 || i == 17 || i == 43 || i == 51 || i == 63 || i == 156 && quan == 2)
		|| type == 1 && (i == 34)
		|| type == 5) return 1;
	return 0;
}
stock i_limit(playerid, thingId, &getQuan, &getLimit) // Проверяем лимиты инвентаря
{
	new lim[INVENTER];
	new pow = get_power(playerid);
	for(new i = 0; i < INVENTER; i++) lim[i] = 1;
	lim[8] = 2, lim[19] = 5, lim[41] = 10, lim[25] = 999000000; // Аптечки, Отмычки, Бенгальские Свечи, Деньги 999кк
	lim[4] = 100*pow, lim[5] = 100*pow, lim[6] = 100*pow, lim[7] = 100*pow, lim[9] = 20, lim[18] = 100*pow, lim[20] = 10*pow, lim[27] = 100*pow, lim[28] = 100*pow, lim[29] = 100*pow, lim[30] = 100*pow;
	lim[46] = 5*pow, lim[47] = 5*pow, lim[55] = 10, lim[60] = 100, lim[61] = 50, lim[64] = 100*pow, lim[65] = 100*pow, lim[66] = 100*pow, lim[67] = 100*pow, lim[71] = 5;
	lim[72] = 10, lim[73] = 10, lim[74] = 10, lim[75] = 10, lim[76] = 10, lim[77] = 10, lim[78] = 10, lim[79] = 10, lim[80] = 10, lim[81] = 10;
	lim[82] = 10, lim[83] = 10, lim[84] = 10, lim[85] = 10, lim[86] = 10, lim[87] = 10, lim[88] = 10, lim[89] = 10, lim[106] = 12, lim[108] = 20, lim[109] = 20, lim[110] = 20;
	lim[140] = 100, lim[141] = 100, lim[142] = 10, lim[180] = 50, lim[181] = 10, lim[197] = 10, lim[198] = 50;

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

	new string[160];
	new yes, giveThing;
	if(IsHelmet(fpick) && thingType == 2) // Каска (Тип аксессуар)
	{
	    if(PlayerInfo[playerid][pGacc][6]+OrganInfo[wh][gUnitStat][20]*60 > unixtime) return format(string,sizeof(string),"{FF6347}Вы не можете сейчас взять каску [ Через %d мин. ]", ((PlayerInfo[playerid][pGacc][6]+OrganInfo[wh][gUnitStat][20]*60)-unixtime)/60), ErrorMessage(playerid, string);
	    if(PlayerInfo[playerid][pOdet][0] == fpick || PlayerInfo[playerid][pOdet][1] == fpick || PlayerInfo[playerid][pOdet][2] == fpick || PlayerInfo[playerid][pOdet][3] == fpick || PlayerInfo[playerid][pOdet][4] == fpick) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет");
	    giveThing = 6;
	    yes = 1;
	}
	else if(IsArmor(fpick) && thingType == 2) // Бронежилет (Тип аксессуар)
	{
	    if(PlayerInfo[playerid][pGacc][7]+OrganInfo[wh][gUnitStat][21]*60 > unixtime) return format(string,sizeof(string),"{FF6347}Вы не можете сейчас взять бронежилет [ Через %d мин. ]", ((PlayerInfo[playerid][pGacc][7]+OrganInfo[wh][gUnitStat][21]*60)-unixtime)/60), ErrorMessage(playerid, string);
	    if(PlayerInfo[playerid][pArmor] >= 1) return ErrorMessage(playerid, "{FF6347}У меня уже есть этот предмет");
	    giveThing = 7;
	    yes = 1;
	}
	else if(thingType == 1) // Оружие
	{
	    if(PlayerInfo[playerid][pGacc][4]+OrganInfo[wh][gUnitStat][18]*60 > unixtime) return format(string,sizeof(string),"{FF6347}Вы не можете сейчас взять оружие [ Через %d мин. ]", ((PlayerInfo[playerid][pGacc][4]+OrganInfo[wh][gUnitStat][18]*60)-unixtime)/60), ErrorMessage(playerid, string);
	    giveThing = 4;
	    yes = 1;
	}
	else if(thingType == 0)
	{
	    if(CheckThingQuan(fpick) == 1) // Предмет имеет количество
		{
		    DP[0][playerid] = inva;
			new maxQuan = 1000, maxTime;
			if(fpick == 27) maxQuan = OrganInfo[wh][gUnitStat][10], maxTime = PlayerInfo[playerid][pGacc][0]+OrganInfo[wh][gUnitStat][14]*60;
			else if(fpick == 28) maxQuan = OrganInfo[wh][gUnitStat][11], maxTime = PlayerInfo[playerid][pGacc][1]+OrganInfo[wh][gUnitStat][15]*60;
			else if(fpick == 29) maxQuan = OrganInfo[wh][gUnitStat][12], maxTime = PlayerInfo[playerid][pGacc][2]+OrganInfo[wh][gUnitStat][16]*60;
			else if(fpick == 30) maxQuan = OrganInfo[wh][gUnitStat][13], maxTime = PlayerInfo[playerid][pGacc][3]+OrganInfo[wh][gUnitStat][17]*60;
			else if(fpick >= 4 && fpick <= 7) maxQuan = OrganInfo[wh][gUnitStat][22], maxTime = PlayerInfo[playerid][pGacc][8]+OrganInfo[wh][gUnitStat][23]*60;
			
			if(maxTime > 0 && maxTime > unixtime) return format(string,sizeof(string),"{FF6347}Вы не можете сейчас взять этот предмет [ Через %d мин. ]\n\n{cccccc}Ограничения устанавливает руководитель", maxQuan), ErrorMessage(playerid, string);
			format(string,sizeof(string),"{cccccc}Чтобы взять {ff9000}%s {cccccc}введите количество\n\n{cccccc}Не меньше 1 и не больше %d\nЛимиты устанавливает руководитель",friskName[fpick], maxQuan);
			ShowDialog(playerid,967,DIALOG_STYLE_INPUT,"{ff9000}Склад",string,"Принять","Отмена");
			return 1;
		}
		if(fpick == 8) // Аптечка
		{
			if(PlayerInfo[playerid][pGacc][5]+OrganInfo[wh][gUnitStat][19]*60 > unixtime) return format(string,sizeof(string),"{FF6347}Вы не можете сейчас взять предмет [ Через %d мин. ]\n\n{cccccc}Ограничения устанавливает руководитель", ((PlayerInfo[playerid][pGacc][5]+OrganInfo[wh][gUnitStat][19]*60)-unixtime)/60), ErrorMessage(playerid, string);
			giveThing = 5;
		}
		yes = 1;
	}

	if(yes == 1)
	{
	    new fpara;
	    if(thingType == 1) fpara = GUN_HEALTH;
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
    	format(string, sizeof(string), "берёт со склада: %s", GetNameThing(0, fpick, thingType, 0));
		SetPlayerChatBubble(playerid,string,COLOR_PURPLE,20.0,5000);
    	OrgLog(wh, "sklad", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 1, GetNameThing(1, fpick, thingType, 0));
	}
	return 1;
}
stock shift_sklad(playerid, wh, getinva, putinva) // Перемещение предметов внутри инвентаря склада организации (с одной ячейки на другую)
{
	if(OnlineInfo[playerid][oShowTabs] == wh)
	{
	    if(PlayerInfo[playerid][pLeader] == 0) return ErrorMessage(playerid, "{FF6347}Перемещать предметы может только лидер"), i_resettabs(playerid);
		if(OrganInfo[wh][gInvent][getinva] == 0) return i_resettabs(playerid);
		else if(OrganInfo[wh][gInvent][putinva] != 0) return 1;
		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
			if(Tabs_Load[i] != 3) continue;
		    if(OnlineInfo[playerid][oShowTabs] != OnlineInfo[i][oShowTabs]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			new string[80];
		    format(string, sizeof(string), "{FF6347}Склад просматривают %d чел. [ Перемещение предмета невозможно ]", quanPlayer-1);
			ErrorMessage(playerid, string);
			i_resettabs(playerid);
			return 1;
		}
		OrganInfo[wh][gInvent][putinva] = OrganInfo[wh][gInvent][getinva];
		OrganInfo[wh][gInv][putinva] = OrganInfo[wh][gInv][getinva];
		OrganInfo[wh][gInvType][putinva] = OrganInfo[wh][gInvType][getinva];
		OrganInfo[wh][gInvPara][putinva] = OrganInfo[wh][gInvPara][getinva];
		OrganInfo[wh][gInvUpdate][putinva] = true;

		OrganInfo[wh][gInvent][getinva] = 0;
		OrganInfo[wh][gInv][getinva] = 0;
		OrganInfo[wh][gInvType][getinva] = 0;
		OrganInfo[wh][gInvPara][getinva] = 0;
		OrganInfo[wh][gInvUpdate][getinva] = true;

		i_resettabs(playerid);
		item_second(playerid, 0, 0, getinva, 0, 0, 0, 0, 0);
		item_second(playerid, OrganInfo[wh][gInvent][putinva], OrganInfo[wh][gInv][putinva], putinva, 0, 300000, OrganInfo[wh][gInvType][putinva], 0, 0);
		OrganInfo[wh][gUpdateSklad] = 1;
	}
	return 1;
}
stock putsklad(wh, pick, kol, fpara, thingType, checklimit)
{
	new put_inva = -1, getLimit, bool:stopFind;
	getLimit = sklad_limit(pick, thingType);
	
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
		OrganInfo[wh][gInvUpdate][put_inva] = true;
		OrganInfo[wh][gUpdateSklad] = 1;
	 	foreach(Player,i)
		{
			if(Tabs_Load[i] != 3) continue;
			if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowTabs] == wh) tilesklad(i, OrganInfo[wh][gInvent][put_inva], OrganInfo[wh][gInv][put_inva], put_inva, thingType);
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

	OrganInfo[g][gInvUpdate][dopinf] = true;
	OrganInfo[g][gUpdateSklad] = 1;
	foreach(Player, i)
	{
		if(Tabs_Load[i] != 3) continue;
		if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowTabs] == g) tilesklad(i, OrganInfo[g][gInvent][dopinf], OrganInfo[g][gInv][dopinf], dopinf, OrganInfo[g][gInvType][dopinf]);
	}
	return 1;
}
stock SaveSklad(idx, bool:transaction = true) // Сохранение всего склада организации по циклу
{
	// Начало транзакции
	if(transaction == true) mysql_tquery(pearsq_2, "START TRANSACTION;");

	for(new i = 0; i < 20; i++) 
	{
		if(OrganInfo[idx][gInvUpdate][i] == true) SaveSkladOne(idx, i);
	}

	// Завершение транзакции
	if(transaction == true) mysql_tquery(pearsq_2, "COMMIT;");
	return 1;
}

stock SaveSkladOne(idx, i)
{
	if(OrganInfo[idx][gInvent][i] == 0)
	{
		new string_mysql[140];
		format(string_mysql, sizeof(string_mysql), "UPDATE `pp_organization` SET `g_slot_%d`= NULL WHERE `frakid` = '%d'", i, idx);
		mysql_tquery(pearsq_2, string_mysql);
	}
	else
	{
		new JsonNode:node = JSON_Object(
			"id", JSON_Int(OrganInfo[idx][gInvent][i]),
			"quan", JSON_Int(OrganInfo[idx][gInv][i]),
			"para", JSON_Int(OrganInfo[idx][gInvPara][i]),
			"type", JSON_Int(OrganInfo[idx][gInvType][i])
		);

		new string_json[512];
		if (JSON_Stringify(node, string_json) == JSON_CALL_NO_ERR) 
		{
			new string_mysql[640];
			mysql_format(pearsq_2, string_mysql, sizeof(string_mysql), "UPDATE `pp_organization` SET `g_slot_%d`= '%e' WHERE `frakid` = '%d'", i, string_json, idx);
			mysql_tquery(pearsq_2, string_mysql);
		}
	}
	OrganInfo[idx][gInvUpdate][i] = false;
	return 1;
}

stock sklad_limit(thingId, thingType) // Проверяем лимиты склада организации
{
	new getLimit;
	if(thingType == 0) // Обычные Предметы
	{
	    if(thingId >= 4 && thingId <= 8) getLimit = 10000; // Вещества
	    else if(thingId >= 27 && thingId <= 30) getLimit = 10000; // Патроны
	    else getLimit = 1000; // На случай ошибки, остальные предметы лимит 1к
 	}
	else if(thingType == 1) getLimit = 100; // Оружие
    else if(thingType == 2) getLimit = 1000; // Каски и Бронежилеты (Аксессуары)
    else getLimit = 1000; // На случай ошибки, остальные предметы лимит 1к
	return getLimit;
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
stock player_tile(playerid, inva)
{
	if(OnlineInfo[playerid][oLogged] == 0 || Veshi[playerid] >= 1) return 1;
	PlayerPlaySound(playerid,17803,0,0,0);
	if(LoadPick[playerid] != 9999) return reset_aksess_tile(playerid);
	if(LoadGun[playerid] != 9999) return reset_gun_tile(playerid);
	new fpick = PlayerInfo[playerid][pInven][inva], fquan = PlayerInfo[playerid][pInvenQuan][inva], fpara = PlayerInfo[playerid][pInvenPara][inva], thingType = PlayerInfo[playerid][pInvenType][inva], thingPack = PlayerInfo[playerid][pInvenPack][inva];
	if(fpick == 0)
	{
		reset_pick_othe(playerid), PlayerTextDrawShow(playerid, PlaNestOthe[2][playerid]);
		if(Hold[playerid] == 4) Hold[playerid] = 0;
	}
	if(fpick == 0) // Ничего нет
	{
		if(OnlineInfo[playerid][oInventSelectRight] == 9999)
		{
			if(OnlineInfo[playerid][oInventSelectLeft] != 9999 && OnlineInfo[playerid][oInventSelectLeft] != inva) // Перекладываем
			{
				if(Hold[playerid] == 2 || Hold[playerid] == 3 && HoldStat[playerid] > 0)
		    	{
		    	    if(HoldInva[playerid] == OnlineInfo[playerid][oInventSelectLeft]) HoldInva[playerid] = inva;
		    	}
		    	
				PlayerInfo[playerid][pInven][inva] = PlayerInfo[playerid][pInven][OnlineInfo[playerid][oInventSelectLeft]];
				PlayerInfo[playerid][pInvenQuan][inva] = PlayerInfo[playerid][pInvenQuan][OnlineInfo[playerid][oInventSelectLeft]];
				PlayerInfo[playerid][pInvenPara][inva] = PlayerInfo[playerid][pInvenPara][OnlineInfo[playerid][oInventSelectLeft]];
				PlayerInfo[playerid][pInvenQara][inva] = PlayerInfo[playerid][pInvenQara][OnlineInfo[playerid][oInventSelectLeft]];
				PlayerInfo[playerid][pInvenType][inva] = PlayerInfo[playerid][pInvenType][OnlineInfo[playerid][oInventSelectLeft]];
				PlayerInfo[playerid][pInvenPack][inva] = PlayerInfo[playerid][pInvenPack][OnlineInfo[playerid][oInventSelectLeft]];
				i_tile(playerid, PlayerInfo[playerid][pInven][inva], PlayerInfo[playerid][pInvenQuan][inva], inva, PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenType][inva], PlayerInfo[playerid][pInvenPack][inva]);

				// Старую плитку удаляем
				PlayerInfo[playerid][pInven][OnlineInfo[playerid][oInventSelectLeft]] = 0;
				PlayerInfo[playerid][pInvenQuan][OnlineInfo[playerid][oInventSelectLeft]] = 0;
				PlayerInfo[playerid][pInvenPara][OnlineInfo[playerid][oInventSelectLeft]] = 0;
				PlayerInfo[playerid][pInvenQara][OnlineInfo[playerid][oInventSelectLeft]] = 0;
				PlayerInfo[playerid][pInvenType][OnlineInfo[playerid][oInventSelectLeft]] = 0;
				PlayerInfo[playerid][pInvenPack][OnlineInfo[playerid][oInventSelectLeft]] = 0;
				i_tile(playerid, PlayerInfo[playerid][pInven][OnlineInfo[playerid][oInventSelectLeft]], PlayerInfo[playerid][pInvenQuan][OnlineInfo[playerid][oInventSelectLeft]], OnlineInfo[playerid][oInventSelectLeft], PlayerInfo[playerid][pInvenPara][OnlineInfo[playerid][oInventSelectLeft]], PlayerInfo[playerid][pInvenType][OnlineInfo[playerid][oInventSelectLeft]], PlayerInfo[playerid][pInvenPack][OnlineInfo[playerid][oInventSelectLeft]]);
				OnlineInfo[playerid][oInventSelectLeft] = 9999;

				CheckCraftReady(playerid);
			}
		}
		else if(OnlineInfo[playerid][oInventSelectRight] != 9999) // Берём Откуда-то
		{
			OnlineInfo[playerid][oInventSelectLeft] = inva;
			if(Tabs_Load[playerid] == 2)
			{
				if(OnlineInfo[playerid][oShowTabs] != 9999) return use_dom(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
			}
			else if(Tabs_Load[playerid] == 3)
			{
				if(OnlineInfo[playerid][oShowTabs] != 9999) return use_sklad(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
			}
			else if(Tabs_Load[playerid] == 4)
			{
				if(OnlineInfo[playerid][oShowTabs] != 9999) return use_rent(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight]);
			}
			else if(Tabs_Load[playerid] == 5)
			{
				if(OnlineInfo[playerid][oShowTabs] != 9999) return use_boot(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
			}
			else if(Tabs_Load[playerid] == 6) return use_mygoods(playerid, OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
			else if(Tabs_Load[playerid] == 7) return use_throw(playerid, OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
			else if(Tabs_Load[playerid] == 8) return use_trash(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
			else if(Tabs_Load[playerid] == 14)
			{
				if(OnlineInfo[playerid][oShowTabs] != 9999) return use_prisontable(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
			}
			else i_resettabs(playerid);
		}
	}
	else if(fpick > 0) // Что-то Лежит
	{
		if(OnlineInfo[playerid][oInventSelectLeft] == 9999) // Выделяем
		{
			if(Page[playerid] == 0 && inva <= 19) PlayerTextDrawBackgroundColour(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva][playerid]);
			else if(Page[playerid] == 1 && inva >= 20) PlayerTextDrawBackgroundColour(playerid, PlaNestPick[inva-20][playerid], PlayerInfo[playerid][pStyle3]), PlayerTextDrawShow(playerid, PlaNestPick[inva-20][playerid]);
			i_infofpick(playerid, fpick, fquan, inva, 0, fpara, thingType, thingPack);
			OnlineInfo[playerid][oInventSelectLeft] = inva;
			if(OnlineInfo[playerid][oInventSelectRight] != 9999) // Кладём
			{
			    new myinva = OnlineInfo[playerid][oInventSelectRight], myfpick;
			    if(Tabs_Load[playerid] == 2)
				{
					if(OnlineInfo[playerid][oShowTabs] != 9999) myfpick = DomInfo[OnlineInfo[playerid][oShowTabs]][dInvent][myinva];
				}
				else if(Tabs_Load[playerid] == 3)
				{
					if(OnlineInfo[playerid][oShowTabs] != 9999) myfpick = OrganInfo[OnlineInfo[playerid][oShowTabs]][gInvent][myinva];
				}
				else if(Tabs_Load[playerid] == 5)
				{
					if(OnlineInfo[playerid][oShowTabs] != 9999) myfpick = VehInfo[OnlineInfo[playerid][oShowTabs]][vInvent][myinva];
				}
			    if(myfpick == 0 || myfpick != fpick) return i_resettabs(playerid), i_resetveshi(playerid);
				if(thingType == 0 && thingPack == 0)
				{
					if(CheckThingQuan(myfpick) == 1)
					{
						if(Tabs_Load[playerid] == 2)
						{
							if(OnlineInfo[playerid][oShowTabs] != 9999) return use_dom(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
						}
						else if(Tabs_Load[playerid] == 3)
						{
							if(OnlineInfo[playerid][oShowTabs] != 9999) return use_sklad(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
						}
						else if(Tabs_Load[playerid] == 5)
						{
							if(OnlineInfo[playerid][oShowTabs] != 9999) return use_boot(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
						}
						else if(Tabs_Load[playerid] == 6) return use_mygoods(playerid, OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
						else if(Tabs_Load[playerid] == 7) return use_throw(playerid, OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
						else if(Tabs_Load[playerid] == 8)
						{
							if(OnlineInfo[playerid][oShowTabs] != 9999) return use_trash(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
						}
						else if(Tabs_Load[playerid] == 14)
						{
							if(OnlineInfo[playerid][oShowTabs] != 9999) return use_prisontable(playerid, OnlineInfo[playerid][oShowTabs], OnlineInfo[playerid][oInventSelectRight], OnlineInfo[playerid][oInventSelectLeft]);
						}
					}
					else i_resetveshi(playerid);
				}
				else i_resetveshi(playerid);
			}
		}
		else if(OnlineInfo[playerid][oInventSelectLeft] != 9999 && OnlineInfo[playerid][oInventSelectLeft] != inva) i_resetveshi(playerid); // Сбрасываем Выбор
        else if(OnlineInfo[playerid][oInventSelectLeft] != 9999 && OnlineInfo[playerid][oInventSelectLeft] == inva) // Выполняем
		{
			// Упаковываем подарок
			if(Hold[playerid] == 4)
			{
			    if(NotGiveThing(fpick, thingType, fquan)) return ErrorMessage(playerid, "{FF6347}Этот предмет нельзя упаковать в подарок");
			    if(thingPack > 0) return ErrorMessage(playerid, "{FF6347}Этот предмет уже упакован");
			    if(fpick == 51 || fpick == 63 || DocumentThing(fpick, thingType)) return ErrorMessage(playerid, "{FF6347}Документы нельзя упаковать в подарок");
			    
			    Veshi[playerid] = 1;
			    DP[0][playerid] = inva;
				new string[140];
				format(string,sizeof(string),"{cccccc}Вы уверены, что хотите упаковать в {ff0000}Подарок {ff9000}%s ?",GetNameThing(0, fpick, thingType, thingPack));
				ShowDialog(playerid,930,DIALOG_STYLE_MSGBOX,"{FF9000}Инвентарь",string,"Да","Нет");
			    return 1;
			}
			
			// Распаковываем подарок или кейс
			if(thingPack == 1 || thingPack == 5) return i_unpackgift(playerid, inva, thingPack);
			
			// Возвращаем украденный предмет
		    if(PlayerInfo[playerid][pInvenQara][inva] > 0)
		    {
		    	if(IsACop(playerid) || PlayerInfo[playerid][pFbi] >= 1)
		    	{
		    	    if(IsPlayerInRangeOfPoint(playerid,1.5,1578.7206,-1688.5414,6.2508) && GetPlayerVirtualWorld(playerid) == 257 || IsPlayerInRangeOfPoint(playerid,1.5,2544.0967,911.8699,1551.0039) && GetPlayerVirtualWorld(playerid) == 2
					|| IsPlayerInRangeOfPoint(playerid,1.5,-1595.5094,726.3425,-4.8892) && GetPlayerVirtualWorld(playerid) == 208 || IsPlayerInRangeOfPoint(playerid,1.5,2544.0967,911.8699,1551.0039) && GetPlayerVirtualWorld(playerid) == 22)
					{
					    comeback_item(playerid, inva);
					}
					else ErrorMessage(playerid, "{FF6347}Это украденный предмет\n\nВерните предмет владельцу и получите вознаграждение\n{cccccc}Для этого отправляйтесь на склад своей организации и выберите предмет"), i_resetveshi(playerid);
					return 1;
		    	}
		    }
		    
			new string[120];
		    // Используем предмет
		    if(thingType == 0) // Обычный предмет
		    {
				if(fpick == 1) return format(string, sizeof(string), "%d", inva), cmd_eatbread(playerid, string), i_resetveshi(playerid); // Хлеб
				else if(fpick == 2) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Обручальное кольцо используется для церемонии бракосочетаний [ Y >> GPS >> Прочее >> Церковь ]","*",""), i_resetveshi(playerid); // Обручальное кольцо
				else if(fpick == 3) return seeds(playerid, 1003), i_resetveshi(playerid); // Бутылка
			 	else if(fpick == 4) return cmd_usedrugs1(playerid), i_resetveshi(playerid); // Трава
			 	else if(fpick == 5) return ErrorMessage(playerid,"Это таблетка пустышка"), i_resetveshi(playerid); // Спиды
			 	else if(fpick == 6) return cmd_usedrugs3(playerid), i_resetveshi(playerid); // Грибы
			 	else if(fpick == 7) return format(string, sizeof(string), "%d", inva), cmd_usedrugs4(playerid, string), i_resetveshi(playerid); // Порошок
			 	else if(fpick == 8) return FindTargetRevival(playerid), i_resetveshi(playerid); // Аптечка
			 	else if(fpick == 9)
				{
					if(Dei[playerid] == 1003) return cmd_molotov(playerid), i_resetveshi(playerid); // Создаём коктейль молотова
					else return kani(playerid), i_resetveshi(playerid); // Канистра
				}
			 	else if(fpick == 10) return cmd_allahakbar(playerid), i_resetveshi(playerid); // Пояс со взрывчаткой
			 	else if(fpick == 11)
				{
					ShowDialog(playerid,1335,DIALOG_STYLE_INPUT,"{ff9000}Бомба","\n{cccccc}Введите время, через которое бомба взорвётся [ 10 - 300 секунд ]","Принять","Отмена");
					return 1;
				}
			 	else if(fpick == 13) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Верёвка нужна для того, чтобы кого-нибудь связать [ /tie ]","*",""), i_resetveshi(playerid);
			 	//else if(fpick == 15) // ЯД (Пустое Значение)
			 	else if(fpick == 16) return format(string, sizeof(string), "%d", inva), cmd_smoke(playerid, string), i_resetveshi(playerid); // Сигареты
			 	else if(fpick == 17) return cmd_usearm(playerid), i_resetveshi(playerid); // Бронежилет
			 	else if(fpick == 18) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Наживка используется для рыбалки [ Y >> GPS >> Работа >> Рыболов ]","*",""), i_resetveshi(playerid);
			 	else if(fpick == 19) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Отмычки используются для взлома замков и дверей [ ALT у дверей ]","*",""), i_resetveshi(playerid);
			 	else if(fpick == 20) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы можете продать рыбу в бухте [ Y >> GPS >> Работа >> Рыболов ]\n\n{ff9000}Или приготовить на костре и употребить в качестве еды [ Купите уголь и зажигалку в супермаркете ]","*",""), i_resetveshi(playerid);
			 	else if(fpick == 21) return SettingTransmitter(playerid), i_resetveshi(playerid);
			 	else if(fpick == 22) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы можете продать мясо в лавке лесника [ Y >> GPS >> Работа >> Охота ]\n\n{ff9000}Или приготовить на костре и употребить в качестве еды [ Купите уголь и зажигалку в супермаркете ]","*",""), i_resetveshi(playerid);
			 	else if(fpick == 23) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы можете надеть мешок на голову другого игрока [ /bag ]","*",""), i_resetveshi(playerid);
			 	else if(fpick == 24) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Шашка таксиста используется для работы в такси {444444}[ /gotaxi в транспорте ]","*",""), i_resetveshi(playerid);
			 	//else if(fpick == 25) // Деньги очкую добавлять в инвентарь
			 	else if(fpick == 26) return ShowSmartfon(playerid); // Смартфон
			 	else if(fpick == 31) return CloseFrisk(playerid), CancelSelectTextDraw(playerid), cmd_ydo(playerid); // Удочка
			 	else if(fpick == 32) return CloseFrisk(playerid), CancelSelectTextDraw(playerid), cmd_fonar(playerid); // Фонарик
			 	else if(fpick == 38 || fpick == 122) return glass(playerid, fpick, inva), i_resetveshi(playerid); // Бокал
			 	else if(fpick == 39) // Подарочная Упаковка
			 	{
			 		if(Piss[playerid] >= 1 || Hold[playerid] >= 1 || Piss[playerid] == 7) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня заняты руки.."), i_resetveshi(playerid);
		 		 	Hold[playerid] = 4;
		 		 	DP[1][playerid] = inva;
		 		 	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Выберите предмет, чтобы упаковать его в подарок","*","");
				}
			 	else if(fpick == 40) return format(string, sizeof(string), "%d", inva), cmd_firework(playerid, string), CloseFrisk(playerid), CancelSelectTextDraw(playerid); // Фейерверк
			 	else if(fpick == 41) // Бенгальская Свеча
			 	{
			 		if(Piss[playerid] >= 1 || Hold[playerid] >= 1 || Piss[playerid] == 7)
			 		{
			 			i_resetveshi(playerid);
			 			if(Piss[playerid] == 7) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня в руке уже есть бенгальская свеча");
			 			if(Piss[playerid] >= 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я сейчас не могу [ Справляю нужду или моюсь ]");
			 			if(Hold[playerid] >= 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня заняты руки..");
			 		}
				 	RemovePlayerAttachedObject(playerid,1);
		   			RemovePlayerAttachedObject(playerid,2);
			 		Piss[playerid] = 7;
			 		PissTime[playerid] = 30;
			 		if(PlayerInfo[playerid][pSex] == 1) SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я зажёг бенгальскую свечу {ff9000}[ 30 секунд ]");
					else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я зажгла бенгальскую свечу {ff9000}[ 30 секунд ]");
					SetPlayerChatBubble(playerid,"достаёт и зажигает бенгальскую свечу",COLOR_PURPLE,20.0,3000);
					SetPlayerAttachedObject(playerid, 1, 18717, 5, 0.126999, 0.222999, 1.338000, 173.000289, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0); // огонёк
					SetPlayerAttachedObject(playerid, 2, 18644, 5, 0.117999, 0.034000, -0.001000, 0.000000, -1.699997, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0); // стержень
					TakeInvent(playerid, fpick, 1, thingType, inva);
					if(PlayerInfo[playerid][pAchieve][115] == 0) AchievePlayer(playerid, 115, 1);
				}
				else if(fpick == 42) return notebook(playerid, inva), i_resetveshi(playerid); // Ноутбук
			 	else if(fpick == 43)
			 	{
			 		if(fquan <= 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мой электрошокер разряжен");
					if(!IsACop(playerid) && PlayerInfo[playerid][pLeader] != 7 && PlayerInfo[playerid][pMember] != 7
					&& PlayerInfo[playerid][pLeader] != 4 && PlayerInfo[playerid][pMember] != 4) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не сотрудник правоохранительных органов");
			 		CloseFrisk(playerid), CancelSelectTextDraw(playerid), cmd_tazer(playerid); // Электрошокер
			 		return 1;
		 		}
		 		else if(fpick == 44) return CloseFrisk(playerid), CancelSelectTextDraw(playerid), cmd_shovel(playerid); // Лопата
		 		else if(fpick == 45) return CloseFrisk(playerid), CancelSelectTextDraw(playerid), cmd_seamap(playerid); // Карта Моряка
		 		else if(fpick == 46) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я могу продать морскую звезду на рыбацкой бухте {ff9000}[ Y >> GPS >> Работа >> Рыбалов ]"), i_resetveshi(playerid); // Морская Звезда
		 		else if(fpick == 47) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я могу продать ракушку на рыбацкой бухте {ff9000}[ Y >> GPS >> Работа >> Рыбалов ]"), i_resetveshi(playerid); // Ракушка
		 		else if(fpick == 48) return CloseFrisk(playerid), CancelSelectTextDraw(playerid), cmd_boat(playerid); // Надувная Лодка
		 		else if(fpick == 49) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я могу продать сундук с сокровищами на рыбацкой бухте {ff9000}[ Y >> GPS >> Работа >> Рыбалов ]"), i_resetveshi(playerid); // Ракушка
		 		else if(fpick == 50) return CloseFrisk(playerid), CancelSelectTextDraw(playerid), cmd_trap(playerid); // Ловушка для Акул
		 		else if(fpick == 51)
			 	{
			 	    i_resetveshi(playerid);
			 	    if(IsPlayerInRangeOfPoint(playerid,3.0,1739.9813,-2421.0430,13.5767) || IsPlayerInRangeOfPoint(playerid,3.0,1739.9819,-2425.4553,13.5767) || IsPlayerInRangeOfPoint(playerid,3.0,1739.9834,-2429.8330,13.5767)
					|| IsPlayerInRangeOfPoint(playerid,3.0,1582.8757,1423.6699,10.8726) || IsPlayerInRangeOfPoint(playerid,3.0,1578.5564,1423.7529,10.8726) || IsPlayerInRangeOfPoint(playerid,3.0,1574.1172,1423.6882,10.8726))
			 	    {
			 	        if(NoCompleteQuest(playerid, 0)) dokaerols(playerid);
			 	        else ErrorMessage(playerid, "{FF6347}Вы уже прошли паспортный контроль");
			 	        return 1;
			 	    }
				 	ShowDialog(playerid,1069,DIALOG_STYLE_INPUT,"{ff9000}Паспорт","\n{cccccc}Введите {ff9000}ID игрока{cccccc}, чтобы показать ему {ff9000}паспорт\n","Принять","Отмена"); // Паспорт
				 	return 1;
			 	}
		 		else if(fpick == 52) return format(string, sizeof(string), "%d", inva), cmd_campfire(playerid, string), i_resetveshi(playerid); // Уголь
		 		else if(fpick == 53) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Зажигалка нужна для розжига костра и курения"), i_resetveshi(playerid); // Зажигалка
		 		else if(fpick == 54) return format(string, sizeof(string), "%d", inva), cmd_eatmeat(playerid, string), i_resetveshi(playerid); // Жареное Мясо
		 		else if(fpick == 55) return format(string, sizeof(string), "%d", inva), cmd_eatfish(playerid, string), i_resetveshi(playerid); // Жареная Рыба
		 		else if(fpick == 60) return cmd_thing(playerid), i_resetveshi(playerid); // Палладий
		 		else if(fpick == 61) return CloseFrisk(playerid), CancelSelectTextDraw(playerid), gelium(playerid); // Гелий 3
		 		else if(fpick == 62) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Журнал нужен для увеличения скорости онанизма"), i_resetveshi(playerid); // PlayBoy
		 		else if(fpick == 63) // Мед. карта
			 	{
			 		if(GetPlayerInterior(playerid) == 5) ShowDialog(playerid,1129,DIALOG_STYLE_INPUT,"{ff9000}Мед Карта","\n{cccccc}Введите {ff9000}ID игрока{cccccc}, чтобы показать ему {ff9000}мед. карту\n","Принять","Отмена"), i_resetveshi(playerid);
			 		else return format(string, sizeof(string), "%d", playerid), cmd_med(playerid, string), i_resetveshi(playerid);
		 		}
		 		else if(fpick == 70) return format(string, sizeof(string), "%d", inva), cmd_bandage(playerid, string), i_resetveshi(playerid); // Бинт
		 		else if(fpick == 71) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Презервативы нужны для безопасного секса [ /sex ]"), i_resetveshi(playerid);
		 		else if(fpick >= 72 && fpick <= 87) format(string, sizeof(string), "%d", fpick-71), cmd_remedy(playerid, string), i_resetveshi(playerid); // Лекарства
		 		else if(fpick == 88) return seeds(playerid, 88), i_resetveshi(playerid); // Семена травы
		 		else if(fpick == 89) return format(string, sizeof(string), "%d", inva), cmd_eatpotato(playerid, string), i_resetveshi(playerid); // Радиоактивная Картошка
		 		else if(fpick == 90) return cmd_mount(playerid), i_resetveshi(playerid); // Бомба
		 		else if(fpick == 91) return CloseFrisk(playerid), CancelSelectTextDraw(playerid), format(string, sizeof(string), "%d", inva), cmd_riches(playerid, string); // Карта Сокровищ
		 		else if(fpick == 92) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я могу продать древнюю вазу на археологических раскопках"), i_resetveshi(playerid);
		 		else if(fpick == 93) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я могу продать урну с прахом на археологических раскопках"), i_resetveshi(playerid);
		 		else if(fpick == 94) return DP[0][playerid] = inva, ShowDialog(playerid,1153,DIALOG_STYLE_MSGBOX,"{ff9000}Золото","{99ff66}Вы уверены, что хотите обменять золото на {ff9000}Donate Валюту?\n\n{ffcc00}[ 1 Слиток = 8 Gold ]","Да","Нет"), i_resetveshi(playerid);
		 		else if(fpick == 95) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я могу продать статуэтку на археологических раскопках"), i_resetveshi(playerid);
		 		else if(fpick == 96) return format(string, sizeof(string), "%d", inva), cmd_bloodvampire(playerid, string), i_resetveshi(playerid); // Бокал с кровью вампира
		 		else if(fpick == 97) return useknife(playerid, inva), i_resetveshi(playerid); // Кухонный нож
		 		else if(fpick == 98) return format(string, sizeof(string), "%d", inva), cmd_useblood(playerid, string), i_resetveshi(playerid); // Бокал с обычной кровью
		 		
				/*else if(fpick == 99) return format(string, sizeof(string), "%d", inva), cmd_eatbanana(playerid, string), i_resetveshi(playerid); // Банан
		 		else if(fpick == 100) return format(string, sizeof(string), "%d", inva), cmd_eatapple(playerid, string), i_resetveshi(playerid); // Яблоко
		 		else if(fpick == 101) return format(string, sizeof(string), "%d", inva), cmd_eatorange(playerid, string), i_resetveshi(playerid); // Апельсин
		 		else if(fpick == 102) return format(string, sizeof(string), "%d", inva), cmd_eatmilk(playerid, string), i_resetveshi(playerid); // Молоко
		 		else if(fpick == 103) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Тыкву можно продать в здании фермы","*",""), i_resetveshi(playerid); // Тыква
		 		else if(fpick == 104) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Картошку можно продать в здании фермы","*",""), i_resetveshi(playerid); // Картошка
		 		else if(fpick == 105) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Томат можно продать в здании фермы","*",""), i_resetveshi(playerid); // Томат
				*/
		 		//else if(fpick == 106) return seeds(playerid, 106), i_resetveshi(playerid); // Удобрение
		 		else if(fpick == 107) return format(string, sizeof(string), "%d", inva), cmd_bullsblood(playerid, string), i_resetveshi(playerid); // Бычья Кровь
		 		//else if(fpick == 108) return seeds(playerid, 108), i_resetveshi(playerid); // Семена тыквы
		 		//else if(fpick == 109) return seeds(playerid, 109), i_resetveshi(playerid); // Семена томатов
		 		//else if(fpick == 110) return seeds(playerid, 110), i_resetveshi(playerid); // Рассада картошки
		 		else if(fpick == 111)
			 	{
			 		ShowDialog(playerid,1207,DIALOG_STYLE_INPUT,"{ff9000}Игральные Кости","\n{cccccc}Введите {99ff66}сумму{cccccc}, на которую будете играть с другим игроком [1 - 10кк]\n\n{FF6347}Внимание!\nЕсли вы договоритесь с кем-либо играть на более крупные суммы -\nадминистрация не вмешается в случае если вас обманут\nНе рекомендуется выходить за рамки ограничений","Принять","Отмена"), i_resetveshi(playerid);
			 		return 1;
		 		}
		 		else if(fpick == 14 || fpick == 37 || fpick >= 112 && fpick <= 121 || fpick == 124 || fpick == 125 ||
				fpick == 139 || fpick == 164 || fpick == 172 || fpick == 166 || fpick == 173 || fpick == 1 || fpick == 54 ||
				fpick == 55 || fpick == 89 ||fpick == 99 ||fpick == 100 ||fpick == 101 ||fpick == 103 || fpick == 104 || fpick == 126 ||
				fpick == 127 || fpick == 141 || fpick == 163 || fpick == 167) return drink_eat(playerid, inva, fpick), i_resetveshi(playerid); // Алкашка / Еда
				else if(fpick == 144) return cmd_pdd(playerid), i_resetveshi(playerid);
		 		else if(fpick >= 145 && fpick <= 155)
			 	{
			 	    if(SitPlayer[playerid] >= 78 && SitPlayer[playerid] <= 101)
			 	    {
			 	        new stat = fpick-144;
			 	        if(isanot_lesson(playerid, stat) == 0) return i_resetveshi(playerid);
	        			AshTime[playerid] = 180;
	        			Ash[playerid] = stat;
	        			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~300 cek", 1500, 3);
	        			if(OnlineInfo[playerid][oShowInterface] == 1) CloseFrisk(playerid), CancelSelectTextDraw(playerid);
	        			ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Дождитесь завершения обучения","*","");
					}
				 	else ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Учебники и книги нужны для обучения навыкам\n\n{cccccc}1. Отправляйтесь в аудиторию образовательного центра\n2. Займите свободное место за партой - ALT\n3. Откройте инвентарь и выберите нужный учебник","*","");
				 	i_resetveshi(playerid);
		 		    return 1;
		 		}
		 		else if(DocumentThing(fpick, thingType)) return format(string, sizeof(string), "{ffcc66}Документы: %s\n{cccccc}Показать документы другому игроку возможно только через паспорт [ /pas ]", friskName[fpick]), ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",string,"*",""), i_resetveshi(playerid);
		 		else if(fpick >= 175 && fpick <= 177) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Домашняя сигнализация [ Поместите в инвентарь дома для установки ]","*",""), i_resetveshi(playerid);
		 		else if(fpick == 181) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Изолента используется в крафтах [ Подробнее можно узнать на верстаке ]","*","");
				else if(fpick == 168) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Мясо в упакове используется в крафтах [ Подробнее можно узнать на кухонной плите ]","*","");
				else if(fpick == 27)
			 	{
			 		if(PlayerInfo[playerid][pBeret] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас взять оружие [ Временное лишение ]");
					new weaponType = WeaponAmmoType(ProtectInfo[playerid][prWeapon][3]);
			 		if((weaponType == 1) && ProtectInfo[playerid][prAmmo][3] >= 1)
					{
						DP[0][playerid] = fpick, DP[1][playerid] = inva;
						ShowDialog(playerid,904,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь","{cccccc}Чтобы взять патроны {ff9000}[ Ammo 20,8mm ] {cccccc}введите количество [ 1 - 1000 ]\n\nПатроны подходят к {ff9000}Дробовикам","Принять","Отмена");
					}
					else ErrorMessage(playerid, "{FF6347}У вас нет в руках дробовика");
			   		return 1;
			 	}
			 	else if(fpick == 28)
			 	{
			 		if(PlayerInfo[playerid][pBeret] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас взять оружие [ Временное лишение ]");
			 		if(WeaponAmmoType(ProtectInfo[playerid][prWeapon][2]) == 2 && ProtectInfo[playerid][prAmmo][2] >= 1 
						|| WeaponAmmoType(ProtectInfo[playerid][prWeapon][4]) == 3 && ProtectInfo[playerid][prAmmo][4] >= 1)
					{
						DP[0][playerid] = fpick, DP[1][playerid] = inva;
						ShowDialog(playerid,904,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь","{cccccc}Чтобы взять патроны {ff9000}[ Ammo 11,43mm ] {cccccc}введите количество [ 1 - 1000 ]\n\nПатроны подходят к {ff9000}Пистолетам","Принять","Отмена");
					}
					else ErrorMessage(playerid, "{FF6347}У вас нет в руках пистолета или пистолета пулемёта");
			   		return 1;
			 	}
			 	else if(fpick == 29)
			 	{
			 		if(PlayerInfo[playerid][pBeret] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас взять оружие [ Временное лишение ]");
					new weaponType = WeaponAmmoType(ProtectInfo[playerid][prWeapon][5]);
			 		if((weaponType == 4) && ProtectInfo[playerid][prAmmo][5] >= 1)
					{
						DP[0][playerid] = fpick, DP[1][playerid] = inva;
						ShowDialog(playerid,904,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь","{cccccc}Чтобы взять патроны {ff9000}[ Ammo 5,45mm ] {cccccc}введите количество [ 1 - 1000 ]\n\nПатроны подходят к {ff9000}Автоматам","Принять","Отмена");
					}
					else ErrorMessage(playerid, "{FF6347}У вас нет в руках автомата");
			   		return 1;
			 	}
			 	else if(fpick == 30)
			 	{
			 		if(PlayerInfo[playerid][pBeret] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас взять оружие [ Временное лишение ]");
					new weaponType = WeaponAmmoType(ProtectInfo[playerid][prWeapon][6]);
			 		if((weaponType == 5) && ProtectInfo[playerid][prAmmo][6] >= 1)
					{
						DP[0][playerid] = fpick, DP[1][playerid] = inva;
						ShowDialog(playerid,904,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь","{cccccc}Чтобы взять патроны {ff9000}[ Ammo 45mm ] {cccccc}введите количество [ 1 - 1000 ]\n\nПатроны подходят к {ff9000}Винтовкам","Принять","Отмена");
					}
					else ErrorMessage(playerid, "{FF6347}У вас нет в руках винтовки");
			   		return 1;
			 	}
			 	else if(fpick == 64)
			 	{
			 		if(PlayerInfo[playerid][pBeret] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас взять оружие [ Временное лишение ]");
					new weaponType = WeaponAmmoType(ProtectInfo[playerid][prWeapon][3]);
			 		if((weaponType == 1) && ProtectInfo[playerid][prAmmo][3] >= 1)
					{
						DP[0][playerid] = fpick, DP[1][playerid] = inva;
						ShowDialog(playerid,1134,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь","{cccccc}Чтобы взять {FF6347}разрывные {cccccc}патроны {ff9000}[ Ammo 20,8mm ] {cccccc}введите количество [ 1 - 1000 ]\nПатроны подходят к {ff9000}Дробовикам\n\n{FF6347}Внимание! Установленные патроны нельзя будет вернуть в инвентарь","Принять","Отмена");
					}
					else ErrorMessage(playerid, "{FF6347}У вас нет в руках дробовика");
			   		return 1;
			 	}
			 	else if(fpick == 65)
			 	{
			 		if(PlayerInfo[playerid][pBeret] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас взять оружие [ Временное лишение ]");
					if(WeaponAmmoType(ProtectInfo[playerid][prWeapon][2]) == 2 && ProtectInfo[playerid][prAmmo][2] >= 1 
						|| WeaponAmmoType(ProtectInfo[playerid][prWeapon][4]) == 3 && ProtectInfo[playerid][prAmmo][4] >= 1)
					{
						DP[0][playerid] = fpick, DP[1][playerid] = inva;
						ShowDialog(playerid,1134,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь","{cccccc}Чтобы взять {FF6347}разрывные {cccccc}патроны {ff9000}[ Ammo 11,43mm ] {cccccc}введите количество [ 1 - 1000 ]\nПатроны подходят к {ff9000}Пистолетам\n\n{FF6347}Внимание! Установленные патроны нельзя будет вернуть в инвентарь","Принять","Отмена");
					}
					else ErrorMessage(playerid, "{FF6347}У вас нет в руках пистолета или пистолета пулемёта");
			   		return 1;
			 	}
			 	else if(fpick == 66)
			 	{
			 		if(PlayerInfo[playerid][pBeret] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас взять оружие [ Временное лишение ]");
					new weaponType = WeaponAmmoType(ProtectInfo[playerid][prWeapon][5]);
			 		if((weaponType == 4) && ProtectInfo[playerid][prAmmo][5] >= 1)
					{
						DP[0][playerid] = fpick, DP[1][playerid] = inva;
						ShowDialog(playerid,1134,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь","{cccccc}Чтобы взять {FF6347}разрывные {cccccc}патроны {ff9000}[ Ammo 5,45mm ] {cccccc}введите количество [ 1 - 1000 ]\nПатроны подходят к {ff9000}Автоматам\n\n{FF6347}Внимание! Установленные патроны нельзя будет вернуть в инвентарь","Принять","Отмена");
					}
					else ErrorMessage(playerid, "{FF6347}У вас нет в руках автомата");
			   		return 1;
			 	}
			 	else if(fpick == 67)
			 	{
			 		if(PlayerInfo[playerid][pBeret] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас взять оружие [ Временное лишение ]");
					new weaponType = WeaponAmmoType(ProtectInfo[playerid][prWeapon][6]);
			 		if((weaponType == 5) && ProtectInfo[playerid][prAmmo][6] >= 1)
					{
						DP[0][playerid] = fpick, DP[1][playerid] = inva;
						ShowDialog(playerid,1134,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь","{cccccc}Чтобы взять {FF6347}разрывные {cccccc}патроны {ff9000}[ Ammo 45mm ] {cccccc}введите количество [ 1 - 1000 ]\nПатроны подходят к {ff9000}Винтовкам\n\n{FF6347}Внимание! Установленные патроны нельзя будет вернуть в инвентарь","Принять","Отмена");
					}
					else ErrorMessage(playerid, "{FF6347}У вас нет в руках винтовки");
			   		return 1;
			 	}

				else if(fpick == 183) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Этот рем. комплект используется для ремонта автомобилей\n\nПодойдите к капоту транспорта и откройте вкладку в инвентаре, для ремонта","*",""), i_resetveshi(playerid);
				else if(fpick == 190) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Этот рем. комплект используется для ремонта мототранспорта\n\nПодойдите к транспорту и откройте вкладку в инвентаре, для ремонта","*",""), i_resetveshi(playerid);
				else if(fpick == 191) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Этот рем. комплект используется для ремонта авиатранспорта\n\nПодойдите к транспорту и откройте вкладку в инвентаре, для ремонта","*",""), i_resetveshi(playerid);
				else if(fpick == 192) return ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Этот рем. комплект используется для ремонта лодок и катеров\n\nПодойдите к транспорту и откройте вкладку в инвентаре, для ремонта","*",""), i_resetveshi(playerid);
				//else if(fpick == 189) {}
				else if(fpick == 193) return format(string, sizeof(string), "%d", inva), cmd_namaz(playerid, string), i_resetveshi(playerid); // Намазлык
				else if(fpick == 197) return cmd_spray(playerid), i_resetveshi(playerid); // балончик
				else if(fpick == 180) return usedrugs2(playerid,1), i_resetveshi(playerid); // Таблетка защиты
				else if(fpick == 198) return usedrugs2(playerid,2), i_resetveshi(playerid); // Таблетка Атаки

	 		}
	 		
	 		else if(thingType == 2) // Аксессуары
		    {
		 	    if(gSkafandr[playerid] > 0 || gFormavvs[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Вы не можете надеть аксессуар в форме"), i_resetveshi(playerid);
		 		if(PlayerInfo[playerid][pOdet][0] != 0 && PlayerInfo[playerid][pOdet][1] != 0 && PlayerInfo[playerid][pOdet][2] != 0 && PlayerInfo[playerid][pOdet][3] != 0 && PlayerInfo[playerid][pOdet][4] != 0) return ErrorMessage(playerid, "{FF6347}Вы уже надели 5 аксессуаров [ Лимит 5 ]"), i_resetveshi(playerid);
		 		if(fpick == 11712)
		 		{
				 	if(getillness(playerid, 18)) DP[0][playerid] = inva, ShowDialog(playerid,1152,DIALOG_STYLE_MSGBOX,"{ff9000}Распятие","{99ff66}Вы уверены, что хотите надеть Распятие?\n\n{ff9000}Вы вампир! Надев распятие вы излечитесь от вампиризма","Да","Нет");
				 	else CreateOdet(playerid, fpick, inva);
			 	}
		 		else CreateOdet(playerid, fpick, inva);
			}

			else if(thingType == 5) // Транспорт
			{
				DP[0][playerid] = inva;
				format(string,sizeof(string),"{cccccc}Вы уверены, что хотите распаковать {ff9000}%s ?", GetVehicleName(fpick));
				ShowDialog(playerid,493,DIALOG_STYLE_MSGBOX,"{ff9000}Транспорт",string,"Да","Нет");
				return 1;
			}
			/*
			1 позвоночник
			2 головы
			3 левого плеча
			4 правое предплечье
			5 левая рука
			6 правая рука
			7 левое бедро
			8 правое бедро
			9 левая нога
			10 правая нога
			11 правой голени
			12 левой голени
			13 левое предплечье
			14 правое предплечье
			15 левая ключица (плечо)
			16 правая ключица (плечо)
			17 шея
			18 челюсть
			*/
			else if(thingType == 3) wear(playerid, fpick, inva), i_resetveshi(playerid); // Одежда
			
			else if(thingType == 1) // Оружие
		 	{
		 		if(PlayerInfo[playerid][pBeret] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете сейчас взять оружие [ Временное лишение ]");
		 	    new weapon = fpick, ammo = PlayerInfo[playerid][pInvenQuan][inva];
		 	    new sl = Protect_Slot(weapon);
		 	    if(ProtectInfo[playerid][prWeapon][sl] >= 1 && ProtectInfo[playerid][prAmmo][sl] >= 1) return format(string, sizeof(string), "{FF6347}У вас в руках %s\n\n{cccccc}Это оружие одного типа",gunName[ProtectInfo[playerid][prWeapon][sl]]), ErrorMessage(playerid, string);
			 	if(weapon >= 2 && weapon <= 15)
				{
					Protect_GiveWeapons(playerid, weapon, ammo, fpara, PlayerInfo[playerid][pInvenQara][inva]);
					TakeInvent(playerid, fpick, 1, thingType, inva);
					UpdateGun(playerid);
					PlayerPlaySound(playerid, 36401, 0,0,0);
		 	        return 1;
		 	    }

				new weaponType = WeaponAmmoType(weapon);
				if(fpara <= 0) return ErrorMessage(playerid, "{FF6347}Оружие испорчено"), i_resetveshi(playerid);
		 	    if(weaponType == 1) // Дробовик (Ammo 20,8mm)
				{
					if(get_invent4(playerid, 27, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет патронов к дробовику [ Ammo 20,8mm ]"), i_resetveshi(playerid);
					DP[0][playerid] = weapon;
					DP[1][playerid] = inva;
					format(string,sizeof(string),"{cccccc}Чтобы взять {ff9000}[ %s ] {cccccc}введите количество патронов",gunName[weapon]);
					ShowDialog(playerid,903,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
				}
				else if(weaponType == 2 || weaponType == 3) // Пистолет или Пистолет-Пулемёт (Ammo 11,43mm)
				{
					if(get_invent4(playerid, 28, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет патронов к пистолету [ Ammo 11,43mm ]"), i_resetveshi(playerid);
					DP[0][playerid] = weapon;
					DP[1][playerid] = inva;
					format(string,sizeof(string),"{cccccc}Чтобы взять {ff9000}[ %s ] {cccccc}введите количество патронов",gunName[weapon]);
					ShowDialog(playerid,903,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
				}
				else if(weaponType == 4) // Автомат (Ammo 5,45mm)
				{
					if(get_invent4(playerid, 29, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет патронов к автомату [ Ammo 5,45mm ]"), i_resetveshi(playerid);
					DP[0][playerid] = weapon;
					DP[1][playerid] = inva;
					format(string,sizeof(string),"{cccccc}Чтобы взять {ff9000}[ %s ] {cccccc}введите количество патронов",gunName[weapon]);
					ShowDialog(playerid,903,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
				}
				else if(weaponType == 5) // Винтовка (Ammo 45mm)
				{
					if(get_invent4(playerid, 30, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет патронов к винтовке [ Ammo 45mm ]"), i_resetveshi(playerid);
					if(weapon == 34)
					{
						if(PlayerInfo[playerid][pLeader] != 8 && PlayerInfo[playerid][pMember] != 8 && PlayerInfo[playerid][pLeader] != 22 && PlayerInfo[playerid][pMember] != 22) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать снайперскую винтовку\n{cccccc}Только для ICA, SWAT"), i_resetveshi(playerid);
					}
					DP[0][playerid] = weapon;
					DP[1][playerid] = inva;
					format(string,sizeof(string),"{cccccc}Чтобы взять {ff9000}[ %s ] {cccccc}введите количество патронов",gunName[weapon]);
					ShowDialog(playerid,903,DIALOG_STYLE_INPUT,"{ff9000}Инвентарь",string,"Принять","Отмена");
				}
		 	}
			OnlineInfo[playerid][oInventSelectLeft] = 9999;
			return 1;
		}
	}
	return 1;
}

stock UpdateInventTwoBlock(playerid, type, stat) // Подгоняем фон правой вкладки под тип открытого меню
{
	new Float:pos_vklad_x, Float:pos_vklad_y;
	new Float:size_vklad_x, Float:size_vklad_y;
	PlayerTextDrawGetPos(playerid, PlaInventDraw[5][playerid], pos_vklad_x, pos_vklad_y);
	PlayerTextDrawGetTextSize(playerid, PlaInventDraw[5][playerid], size_vklad_x, size_vklad_y);

	new Float:sized_y = PlayerInfo[playerid][pDrawSize_Y][6];
	new Float:otstyp_y = 4.0+sized_y/8;

	if(type == 0) // Все вкладки закрыты
	{
		new Float:temp_size_x, Float:temp_size_y;
		PlayerTextDrawGetTextSize(playerid, PlaNestTabs[2][playerid], temp_size_x, temp_size_y);
		PlayerTextDrawTextSize(playerid, PlaInventDraw[5][playerid], size_vklad_x, temp_size_y + otstyp_y*2);
	}
	else if(type == 2 || type == 9) // Дом, Бизнес
	{
		if(stat == 0) // Без нижней кнопки
		{
			new Float:temp_pos_x, Float:temp_pos_y;
			PlayerTextDrawGetPos(playerid, PlaInventDraw[4][playerid], temp_pos_x, temp_pos_y);
			PlayerTextDrawTextSize(playerid, PlaInventDraw[5][playerid], size_vklad_x, temp_pos_y-pos_vklad_y);
		}
		else
		{
			new Float:temp_pos_x, Float:temp_pos_y;
			new Float:temp_size_x, Float:temp_size_y;
			PlayerTextDrawGetPos(playerid, PlaInventDraw[4][playerid], temp_pos_x, temp_pos_y);
			PlayerTextDrawGetTextSize(playerid, PlaInventDraw[4][playerid], temp_size_x, temp_size_y);

			PlayerTextDrawTextSize(playerid, PlaInventDraw[5][playerid], size_vklad_x, temp_pos_y-pos_vklad_y + temp_size_y + otstyp_y);
		}
	}
	else if(type == 1 || type == 6) // Товары, Мои Товары
	{
		new Float:temp_pos_x, Float:temp_pos_y;
		PlayerTextDrawGetPos(playerid, PlaInventDraw[4][playerid], temp_pos_x, temp_pos_y);
		PlayerTextDrawTextSize(playerid, PlaInventDraw[5][playerid], size_vklad_x, temp_pos_y-pos_vklad_y);
	}
	else if(type == 5) // Багажник
	{
		new Float:temp_pos_x, Float:temp_pos_y;
		new Float:temp_size_x, Float:temp_size_y;
		PlayerTextDrawGetPos(playerid, PlaInventDraw[4][playerid], temp_pos_x, temp_pos_y);
		PlayerTextDrawGetTextSize(playerid, PlaInventDraw[4][playerid], temp_size_x, temp_size_y);

		PlayerTextDrawTextSize(playerid, PlaInventDraw[5][playerid], size_vklad_x, temp_pos_y-pos_vklad_y + temp_size_y + otstyp_y);
	}
	else // Все остальные (В том числе капот и верстак)
	{
		new Float:temp_pos_x, Float:temp_pos_y;
		new Float:temp_size_x, Float:temp_size_y;
		PlayerTextDrawGetPos(playerid, PlaInventDraw[6][playerid], temp_pos_x, temp_pos_y);
		PlayerTextDrawGetTextSize(playerid, PlaInventDraw[6][playerid], temp_size_x, temp_size_y);

		PlayerTextDrawTextSize(playerid, PlaInventDraw[5][playerid], size_vklad_x, temp_pos_y - pos_vklad_y + temp_size_y + otstyp_y);
	}

	PlayerTextDrawShow(playerid, PlaInventDraw[5][playerid]);
	return 1;
}

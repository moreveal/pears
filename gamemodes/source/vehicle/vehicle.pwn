
/*
Как добавить новый тс?
1. Добавляем в AddCustomVehice заменку и следующий id
2. Добавляем в IsAVehExisting новую цифру для создания транспорта
3. Добавляем имя транспорта в vehNameCustom[
4. Добавляем гос стоимость в vehSummaCustom[
5. Добавляем в GetVehicleType (что это за тип транспорта)
6. stock GetVehicleClass - класс авто
7. stock IsABoot Есть ли у него багажник
8. stock IsABootFront - если у транспорта, багажник спереди а двигатель сзади
9. stock IsA_Gen5, IsA_Gen10, IsA_Gen15 - сколько по дефолту слотов в багажнике (если не указать, будет 20 слотов)
10. stock IsATaxi - доступен ли транспорт работать в такси [сейчас там уже ВСЕ >= 2000]
11. stock IsAZad - есть ли задние двери в транспорте
12. Добавляем в define MAX_VEHICLE_CUSTOM (в целом, там сейчас с запасом до 200 кастомных авто)
*/

#define MAX_VEHICLE_CUSTOM 200 // Кастомный транспорт
#define MAX_MODELS_VEHICLE 212 + MAX_VEHICLE_CUSTOM // Количество моделей транспорта на сервере

new VehGos[MAX_MODELS_VEHICLE]; // Стоимости транспорта
new VehGold[MAX_MODELS_VEHICLE]; // Gold стоимости транспорта
new VehBuy[MAX_MODELS_VEHICLE]; // Подсчет покупок транспорта за вирты
new VehBuyGold[MAX_MODELS_VEHICLE]; // Подсчет покупок транспорта за голду
new VehLimited[MAX_MODELS_VEHICLE]; // Информация о лимитированном транспорте
new VehQuan[MAX_MODELS_VEHICLE]; // Количество на руках игроков транспортных средств
new VehSale[MAX_MODELS_VEHICLE]; // Статус доступности продажи транспорта (1 продаётся, 0 нет)
new VehLimitedCase[MAX_MODELS_VEHICLE]; // Статус лимитированного транспорта, выданного в кейсах в данный момент

new vehClassName[][] =
{
    "Undefiend", "Premium", "Middle", "Economy", "Off-Road", "Special", "Unique", "Government"
};

new vehNameCustom[][] =
{
    "Lamborghini Murcielago", "BMW E36 328i", "BMW M4 G82", "Mercedes S63", "Acura Integra", "Hummer H2", "Nissan GT-R R35 RB", 
	"Impreza WRX STi", "Skoda Octavia", "Mercedes C63", "Nissan 350Z", "Audi Q7", "BMW 530i", "BMW M635CSI E24",
	"Mercedes G63 B800 Brabus", "Ford Raptor", "Audi RS5", "BMW 325i E30", "BMW X6M", "Volkswagen Golf", "Cadillac Fleetwood", "BMW 750il E38",
	"Dodge Super Bee", "Ford GT", "Lamborghini Centenario", "Mercedes W124", "Mercedes SL 65", "Nissan 240SX", "Porsche 911 GT2",
	"Shelby GT 500", "Toyota Supra MK5", "Toyota AE86", "Prison Bus", "Mercedes AMG GT63", "Bentley Continental GT", "BMW 325I E30",
	"Arm Cargo", "Ford Raptor", "Charger Police", "Charger Dep", "Enforcer SWAT", "Truck SWAT", "F1 Ferrari",
	"Ford Crown Victoria", "Ford Crown Victoria Dep", "Expedition", "Explorer Dep", "Explorer Police", "Ford Focus ST", "Silvia S13",
	"Jeep Wrangler", "Lexus LS400", "Lexus RCF", "Mazda RX7", "Audi RS6 C5", "Mercedes Sprinter", "Ferrari Enzo",
	"Mercedes E63", "Mitsubishi Eclipse", "Nissan Silvia S14", "Hummer H1", "Plymouth Hemi", "Toyota Camry Taxi", "Vaz 2106", "Vaz 2105",
	"Volkswagen Golf MK2", "BMW 760i", "Toyota Chaser JZX100", "BMW M5 F90", "Audi R8", "Rolls-Royce Wraith", "Rolls-Royce Cullinan", "Pagani Zonda",
	"Audi RS3", "Nissan GT-R R34", "Silvia S15", "Nissan GT-R R35", "Charger RT 69","Mars Rover", "Mars Rider", "Mars RC Car", "Ingenuity",
	"Peugeot 406 2003","Alfa-Romeo 159 Ti","Aston-Martin DB11","Chevrolet Corvette C6 ZR1", "Tesla Model X P100D","BMW E34 Alpina",
	"Porsche 911 JS Edition","Bentley Turbo R 1991","Chevrolet Express","Ford Econoline Pack","Audi RS7","Bentley Continental GT",
	"Chevrolet Tahoe","Dodge Charger SRT Hellcat","Dodge Viper","Enforcer CIRG","FBI Car","FBI APC","Motorcycle","Ferrari 348",
	"Ford Crown Victoria Killer Marauder","Jeep Cherokee 1984 Sand Edition","Lamborghini Miura P400 SV","Lamborghini Gallardo Superleggera",
	"Mazda RX-8","McLaren 720s Spider","Porsche 911","Porsche Carrera GT","Dron FBI","Subaru BRZ","FBIWater","Volvo XC90",
	"BMW X5","Yamaha DT180","Yamaha Vino","Yamaha Vino Pizza","BMW M2 Competition","BMW X7","BMW M3 Competition","BMW M3",
	"Dodge Charger SRT Hellcat","Bugatti Chiron","Bugatti Divo","Volvo Polestar One","Toyota Chaser BN Sports","Mazda RX-7",
	"SAPD Helicopter","MH-6 Little Bird","FBI Helicopter","Cyberpunk Turbo-R","Cyberpunk Type-66","BMW M5 Competition Sport"
};

new vehName[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster A", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Topfun Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "APC", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster B", "Monster C",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT 400", "DFT 30",
    "Huntley", "Stafford", "BF 400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car", "Police Car", "Police Car",
    "Police Ranger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

new vehSummaCustom[] = // Гос цены на авто (Дефолтные) Кастомный транспорт
{
    19000000,900000,10000000,11000000,400000,3500000,12000000,2500000,1100000,2800000, // 2000 - 2009
	1400000,5000000,3000000,500000,9000000,4200000,10000000,600000,4500000,400000, // 2010 - 2019
	2500000,950000,7000000,4000000,60000000,6000000,7000000,1300000,3000000,3200000, // 2020 - 2029
	5000000,1200000,1300000,15000000,24000000,1500000, // 2030 - 2035
	31000000,4200000,5000000,5000000,4500000,4000000,300000000, // 2036 - 2042
	1200000,1200000,7000000,3500000,3500000,500000,1200000, // 2043 - 2049
	3000000,900000,4700000,700000,1200000,17000000,70000000, // 2050 - 2056
	11000000,1800000,2100000,9000000,6000000,2900000,500000,500000, // 2057 - 2064
	300000, 5500000, 750000, 15000000, 7000000, 28000000, 32000000, 70000000, // 2065 - 2072
	3200000, 2900000, 2500000, 5200000, 1300000,200000000,200000000,200000000,200000000,4500000, // 2073 - 2082
	1400000,15000000,6000000,30000000,1000000,40000000,20000000,1000000,1000000,11000000,40000000, //2083 - 2093
	1000000,7000000,12000000,10000000,10000000,30000000,500000,14000000,10000000,5000000,17000000, //2094 - 2104
	22000000,800000,22000000,13000000,22000000,60000000,2300000,30000000,3000000,3000000,300000,100000,120000,//2105 - 2117
	7000000,9000000,9000000,7500000,6000000,65000000,70000000,3600000,1600000,900000,50000000,50000000, //2118 - 2129
	50000000,12000000,12000000,13000000 //2130 - 2131
};

new vehSumma[] = // Гос цены на авто (Дефолтные)
{
    790000, 650000, 900000, 4500000, 350000, 750000, 190000000, 3900000, 2900000, // 400 - 408					+
    1900000, 320000, 4900000, 290000, 450000, 490000, 2500000, 3000000, 55000000, 550000,  // 409 - 418			+
    330000, 390000, 390000, 290000, 590000, 650000, 1500000000, 390000, 8900000, // 419 - 427					+
    6000000, 1800000, 12000000, 1600000, 900000000, 8900000, 6500000, 900000, 290000, 1600000, // 428 - 437		+
    150000, 180000, 350000, 200000, 260000, 1700000, 12000000, 390000, 8000000, 48000000, // 438 - 447			+
    24000, 100000000, 900000, 2600000, 1500000, 900000, 18000000, 1100000, 800000, 405000, 360000, // 448 - 458	+
    360000, 11150000, 600000, 89000, 330000, 20000000, 400000, 130000, 130000, // 459 - 467						+
    120000, 4000000, 3500000, 170000, 200000, 90000, 140000, 170000, 90000000, 1500000, 210000, // 468 - 478	+
    110000, 250000, 18000, 210000, 370000, 7200000, 80000, 2000000, 30000000, 29000000, 460000, // 479 - 489	+
    560000, 190000, 150000, 7000000, 2500000, 3500000, 280000, 35000000, // 490 - 497     						+
    260000, 250000, 280000, 200000, 2500000, 2500000, 2100000, 1200000, // 498 - 505							+
    2300000, 390000, 700000, 11000, 30000, 25000000, 15000000, 17000000, 5000000, 7500000, // 506 - 515         +
    250000, 180000, 170000, 50000000, 2000000000, 750000, 1250000, 600000, 4000000, 1000000, // 516 - 525       +
    450000, 370000, 5000000, 290000, 500000, 300000, 10000000, 600000, 450000, 500000, // 526 - 535				+
    400000, 100000000, 100000000, 900000, 325000, 4000000, 150000, 100000, 4900000, 200000, 260000, // 536 - 546+
    290000, 55000000, 80000, 450000, 310000, 1200000, 50000000, 870000, 325000, 60000000, 60000000, // 547 - 557+
    760000, 2300000, 2600000, 1000000, 1800000, 65000000, 20000000, 850000, 300000, 340000, 1500000, // 558 - 568
    100000000, 100000000, 2500000, 480000, 6000000, 400000, 670000, 400000, 60000000, 2500000, // 569 - 578
    900000, 500000, 700000, 2700000, 390000, 1500000, 370000, 300000, 1250000, 5000000, 560000, // 579 - 589
    100000000, 900000, 150000000, 10000000, 10000000, 60000000, 390000, 390000, 350000, // 590 - 598
    360000, 280000, 20000000, 1400000, 700000, 150000, 150000, 900000, 900000, 900000, // 599 - 608
    900000, 900000, 900000 // 609 - 611
};

new vehSpeed[] =
{
    179, 167, 212, 124, 151, 186, 125, 168, 113, // 400 - 408
	179, 147, 252, 191, 125, 120, 218, 175, 0, 131, // 409 - 418
	169, 164, 174, 159, 112, 153, 0, 197, 188, // 419 - 427
	178, 229, 210, 148, 107, 125, 189, 0, 169, 179, // 428 - 437
	162, 191, 154, 85, 158, 143, 125, 186, 0, 0, // 438 - 447
	130, 205, 0, 220, 0, 0, 0, 179, 120, 108, 179, // 448 - 458
	130, 205, 0, 220, 0, 0, 0, 179, 120, 108, 179, // 459 - 467
	163, 0, 178, 125, 0, 0, 169, 196, 0, 212, 133, // 468 - 478
	159, 209, 0, 178, 139, 0, 113, 72, 0, 0, 158, // 479 - 489
	178, 169, 159, 0, 244, 200, 185, 0, // 490 - 497
	122, 139, 159, 0, 244, 244, 196, 158, // 498 - 505
	203, 188, 122, 450, 450, 0, 0, 0, 136, 161, // 506 - 515
	178, 178, 186, 0, 0, 184, 195, 170, 148, 182, // 516 - 525
	179, 169, 200, 169, 68, 79, 125, 190, 191, 179, // 526 - 535
	196, 0, 0, 113, 169, 230, 187, 171, 168, 167, 169, // 536 - 546
	162, 0, 174, 164, 179, 137, 0, 163, 179, 125, 125, // 547 - 557
	177, 202, 192, 175, 202, 0, 0, 187, 181, 196, 166, // 558 - 568
	0, 0, 105, 68, 125, 68, 179, 179, 0, 148, // 569 - 578
	179, 173, 168, 154, 97, 0, 173, 155, 187, 122, 184, // 579 - 589
	0, 0, 0, 0, 0, 0, 199, 199, 199, // 590 - 598
	179, 171, 125, 192, 194, 167, 171, 0, 0, 0, // 599 - 608
	122, 0, 0 // 609 - 611
};

stock AddCustomVehice() // Добавляем тс на карту
{
	AddVehicleSyncModel(451, 2000); // Lamba Murcielago (Turismo)
	AddVehicleSyncModel(602, 2001); // BMW E36 328i (Alpha)
	AddVehicleSyncModel(411, 2002); // BMW M4 G82 (Infernus)
	AddVehicleSyncModel(494, 2003); // Mercedes S63 Coupe (Hotring)
	AddVehicleSyncModel(559, 2004); // Acura Integra (Jester)
	AddVehicleSyncModel(579, 2005); // Hummer H2 (Huntley)
	AddVehicleSyncModel(503, 2006); // Nissan GT-R R35 (Hotrinb)
	AddVehicleSyncModel(561, 2007); // Impreza WRX STi (Stratum)
	AddVehicleSyncModel(426, 2008); // Shkoda Octavia (Premier)
	AddVehicleSyncModel(551, 2009); // Mercedes C63 W204 (Merit)
	AddVehicleSyncModel(602, 2010); // Nissan 350Z (Alpha)
	AddVehicleSyncModel(579, 2011); // Audi Q7 (Huntley)
	AddVehicleSyncModel(426, 2012); // BMW 530i (Premier)
	AddVehicleSyncModel(602, 2013); // BMW M635CSI E24 (Alpha)
	AddVehicleSyncModel(579, 2014); // Mercedes Brabus B800 (Huntley)
	AddVehicleSyncModel(554, 2015); // Ford Raptor (Yosomite)
	AddVehicleSyncModel(602, 2016); // Audi RS5	(Alpha)
	AddVehicleSyncModel(551, 2017);	// BMW 325i E30 (Merit)
	AddVehicleSyncModel(579, 2018); // BMW X6M (Huntley)
	AddVehicleSyncModel(589, 2019);	// VW Golf	(Club)
	AddVehicleSyncModel(421, 2020); // Cadillac Fleetwood (Washing)
	AddVehicleSyncModel(551, 2021);	// BMW 750il E38 (merit)
	AddVehicleSyncModel(475, 2022);	// Dodge Super Bee (Sabre)
	AddVehicleSyncModel(541, 2023);	// Ford GT	(Bullet)
	AddVehicleSyncModel(541, 2024);	// Lamba Centenario (BULLET)
	AddVehicleSyncModel(445, 2025);	// Mercedes W124 (Huntley)
	AddVehicleSyncModel(602, 2026);	// Mercedes SL 65 (Alpha)
	AddVehicleSyncModel(602, 2027);	// Nissan 240SX (Alpha)
	AddVehicleSyncModel(451, 2028); // Porsche 911 GT2 (Turismo)
	AddVehicleSyncModel(402, 2029);	// Shelby GT 500 (Buffalo)
	AddVehicleSyncModel(562, 2030); // Toyota Supra MK5 (Elegy)
	AddVehicleSyncModel(558, 2031); // Toyota GT AE86 (Uranus)
	AddVehicleSyncModel(431, 2032); // Prison Bus (Bus)
	AddVehicleSyncModel(560, 2033); // Mercedes AMG GT63 (Sultan)
	AddVehicleSyncModel(533, 2034); // Bentley Continental GT (Feltzer)
	AddVehicleSyncModel(502, 2035); // BMW 325i E30	(Hotring Racer A)
	AddVehicleSyncModel(548, 2036); // Arm Cargo (cargobob)
	AddVehicleSyncModel(554, 2037); // Ford Raptor (Yosomite)
	AddVehicleSyncModel(596, 2038); // Charger Police (copcarla)
	AddVehicleSyncModel(426, 2039); // Charger Dep (Premier)
	AddVehicleSyncModel(427, 2040); // Enforcer SWAT (enforcer)
	AddVehicleSyncModel(528, 2041); // Truck SWAT (fbitruck)
	AddVehicleSyncModel(494, 2042); // Ferrari F1 (hotring)
	AddVehicleSyncModel(426, 2043); // Ford Crown Victoria (Premier)
	AddVehicleSyncModel(426, 2044); // Ford Crown Victoria Dep (Premier)
	AddVehicleSyncModel(490, 2045); // Ford Expedition (fbirancher)
	AddVehicleSyncModel(490, 2046); // Ford Explorer Dep (fbirancher)
	AddVehicleSyncModel(490, 2047); // Ford Explorer Police (fbirancher)
	AddVehicleSyncModel(589, 2048); // Ford Focus ST (Club)
	AddVehicleSyncModel(503, 2049); // Nissan Silvia s13 (hotrinb)
	AddVehicleSyncModel(500, 2050); // Jeep Wrangler (mesa)
	AddVehicleSyncModel(551, 2051); // Lexus LS400 (merit)
	AddVehicleSyncModel(602, 2052); // Lexus RCF (alpha)
	AddVehicleSyncModel(477, 2053); // Mazda RX7 (zr350)
	AddVehicleSyncModel(560, 2054); // Audi RS6 C5(sultan)
	AddVehicleSyncModel(482, 2055); // Mercedes Sprinter (Burrito)
	AddVehicleSyncModel(541, 2056); // Ferrari Enzo (bullet)
	AddVehicleSyncModel(560, 2057); // Mercedes E63 (sultan)
	AddVehicleSyncModel(559, 2058); // Mitsu Eclipse (jester)
	AddVehicleSyncModel(558, 2059); // Silvia S14 (uranus)
	AddVehicleSyncModel(470, 2060); // Hummer H1 (patriot)
	AddVehicleSyncModel(475, 2061); // Plymouth Hemi Cuda (sabre)
	AddVehicleSyncModel(420, 2062); // Camry Taxi (taxi)
	AddVehicleSyncModel(492, 2063); // Vaz 2106 (greenwoo)
	AddVehicleSyncModel(492, 2064); // Vaz 2105 (greenwoo)
	AddVehicleSyncModel(589, 2065); // VW Golf MK2 (Club)
	AddVehicleSyncModel(560, 2066); // BMW 760i
	AddVehicleSyncModel(560, 2067); // Chaser JZX100
	AddVehicleSyncModel(560, 2068); // BMW M5 F90
	AddVehicleSyncModel(415, 2069); // Audi R8
	AddVehicleSyncModel(411, 2070); // Rolls Wraith
	AddVehicleSyncModel(579, 2071); // Rolls Cullinan
	AddVehicleSyncModel(541, 2072); // Pagani Zonda
	AddVehicleSyncModel(560, 2073); // Audi RS3
	AddVehicleSyncModel(562, 2074); // Nissan GT-R R34
	AddVehicleSyncModel(558, 2075); // Silvia S15
	AddVehicleSyncModel(562, 2076); // Nissan GT-R R35
	AddVehicleSyncModel(402, 2077); // Charger RT 69
	AddVehicleSyncModel(573, 2078); // Mars Rover
	AddVehicleSyncModel(573, 2079); // Mars Rider
	AddVehicleSyncModel(594, 2080); // Mars RC Car
	AddVehicleSyncModel(465, 2081); // Mars RC Heli
	AddVehicleSyncModel(560, 2082); // Peugeot 406 (2003)
	
	/*
	AddVehicleSyncModel(551, 2083); // Alfa-Romeo 159 Ti
	AddVehicleSyncModel(402, 2084); // Aston-Martin DB11
	AddVehicleSyncModel(402, 2085); // Chevrolet Corvette C6 ZR1
	AddVehicleSyncModel(560, 2086); // Tesla Model X P100D
	AddVehicleSyncModel(560, 2087); // BMW E34 Alpina
	AddVehicleSyncModel(477, 2088); // Porsche 911 JS Edition
	AddVehicleSyncModel(580, 2089); // Bentley Turbo R 1991
	AddVehicleSyncModel(413, 2090); // Chevrolet Express
	AddVehicleSyncModel(482, 2091); // Ford Econoline Pack
	AddVehicleSyncModel(405, 2092); // Audi RS7 2014
	AddVehicleSyncModel(602, 2093); // Bentley Continental GT
	AddVehicleSyncModel(579, 2094); // Chevrolet Tahoe
	AddVehicleSyncModel(560, 2095); // Dodge Charger SRT Hellcat
	AddVehicleSyncModel(429, 2096); // Dodge Viper
	AddVehicleSyncModel(427, 2097); // Enforcer CIRG
	AddVehicleSyncModel(490, 2098); // FBI Car
	AddVehicleSyncModel(528, 2099); // FBI APC
	AddVehicleSyncModel(521, 2100); // Motorcycle
	AddVehicleSyncModel(415, 2101); // Ferrari 348
	AddVehicleSyncModel(494, 2102); // Ford Crown Victoria Killer Maraude
	AddVehicleSyncModel(495, 2103); // Jeep Cherokee 1984 Sand Edition
	AddVehicleSyncModel(541, 2104); // Lamborghini Miura P400 SV
	AddVehicleSyncModel(411, 2105); // Lamborghini Gallardo Superleggera
	AddVehicleSyncModel(551, 2106); // Mazda RX-8
	AddVehicleSyncModel(541, 2107); // McLaren 720s Spider
	AddVehicleSyncModel(480, 2108); // Porsche 911
	AddVehicleSyncModel(541, 2109); // Porsche Carrera GT
	AddVehicleSyncModel(465, 2110); // Dron FBI
	AddVehicleSyncModel(559, 2111); // Subaru BRZ
	AddVehicleSyncModel(601, 2112); // FBI Water
	AddVehicleSyncModel(579, 2113); // Volvo XC90
	AddVehicleSyncModel(579, 2114); // BMW X5
	AddVehicleSyncModel(468, 2115); // Yamaha DT180
	AddVehicleSyncModel(462, 2116); // Yamaha Vino
	AddVehicleSyncModel(448, 2117); // Yamaha Vino Pizza
	AddVehicleSyncModel(429, 2118); // BMW M2 Competition
	AddVehicleSyncModel(579, 2119); // BMW X7
	AddVehicleSyncModel(560, 2120); // BMW M3 Competition
	AddVehicleSyncModel(560, 2121); // BMW M3
	AddVehicleSyncModel(560, 2122); // Dodge Charger SRT Hellcat
	AddVehicleSyncModel(541, 2123); // Bugatti Chiron
	AddVehicleSyncModel(541, 2124); // Bugatti Divo
	AddVehicleSyncModel(559, 2125); // Volvo Polestar One
	AddVehicleSyncModel(551, 2126); // Toyota Chaser BN Sports
	AddVehicleSyncModel(587, 2127); // Mazda RX-7
	AddVehicleSyncModel(497, 2128); // SAPD Helicopter
	AddVehicleSyncModel(487, 2129); // MH-6 Little Bird
	AddVehicleSyncModel(497, 2130); // FBI Helicopter
	AddVehicleSyncModel(411, 2131); // Cyberpunk Turbo-R
	AddVehicleSyncModel(541, 2132); // Cyberpunk Type-66
	AddVehicleSyncModel(560, 2133); // BMW M5 Competition Sport
	*/
	return 1;
}

// Проверка на доступный транспорт
stock IsAVehExisting(v)
{
    if(v >= 400 && v <= 611 // Стандартный транспорт gta

    || v >= 2000 && v <= 2082) return 1; // Кастомный транспорт пирса

	if(v == 537 || v == 538) return 0; // Поезд создавать через /veh нельзя
    return 0;
}

stock GetVehicleName(model)
{
	new vehicleName[34];
	if(model >= 400 && model <= 611) format(vehicleName, sizeof(vehicleName), "%s", vehName[model - 400]);
	else if(model >= 2000) 
	{
		if(model - 2000 >= sizeof(vehNameCustom)) format(vehicleName, sizeof(vehicleName), "Unknown");
		else format(vehicleName, sizeof(vehicleName), "%s", vehNameCustom[model - 2000]);
	}
	return vehicleName;
}

stock GetVehiclePrice(v)
{
	new price;
	if(v >= 400 && v <= 611) price = vehSumma[v - 400];
	else if(v >= 2000)
	{
		if(v - 2000 > sizeof(vehSummaCustom)) price = 0;
		else price = vehSummaCustom[v - 2000];
	}
	return price;
}

stock GetVehiclePriceGos(v)
{
	v = CorrectVehicleID(v);
	return VehGos[v];
}

stock GetVehiclePriceGold(v)
{
	v = CorrectVehicleID(v);
	return VehGold[v];
}

stock GetVehicleSpeedMax(v)
{
	new speed;
	if(v >= 400 && v <= 611) speed = vehSpeed[v - 400];
	else speed = vehSpeed[GetVehModelOriginal(v) - 2000];
	return speed;
}

/* СУПЕР ПУПЕР ВАЖНО добавляя новые диапазоны моделей транспорта
stock GetVehicleModelSync
stock ReadVehicleIDE
CS_RPC_WorldVehicleAdd
*/

stock GetVehicleModelSync(playerid, model) // Получаем модель транспорта с учётом наличия модпака +
{
    new vehId;
    if(IsPlayerSyncModels(playerid)) // Мод установлен
	{
		if(model >= 612 && model <= 15265) model += 13066;
		else if(model >= 15266) model += 13266;
		vehId = model;
	}
    else vehId = GetVehModelOriginal(model);
    return vehId;
}

stock PP_CreateVehicle(model,Float:x,Float:y,Float:z,Float:a, col1, col2, sek, siren, timerspawn, Float:health)
{
	if(QuantityVehicles + 1 >= SKOKOCAROV) return -1; // Лимит транспортных средств на серверах SAMP

	new id = m_custom_sync_CreateVehicle(model, x, y, z, a, col1, col2, sek, bool:siren);

	LinkVehicleToInterior(id, 0);
	SetVehicleVirtualWorld(id, 0);

	GetVehicleParamsEx(id, engine, lights, alarm, doors, bonnet, boot, objective);
   	SetVehicleParamsEx(id, false, false, false, false, false, false, objective);

	VehInfo[id][vStat] = 1;
	VehInfo[id][vVehcol1] = col1, VehInfo[id][vVehcol2] = col2;
	VehInfo[id][vModel] = model;
	VehInfo[id][vTimerSpawn] = timerspawn;

	VehInfo[id][vPanels] = 0;
	VehInfo[id][vDoors] = 0;
	VehInfo[id][vFara] = 0;
	VehInfo[id][vTires] = 0;

	if(!health) health = MaxVehicleHealth(model, id);
	VehInfo[id][vHealth] = health;
	SetVehicleHealth(id, VehInfo[id][vHealth]);

	QuantityVehicles ++;
	return id;
}

stock PP_AddStaticVehicleEx(modelID, Float: spawn_X, Float: spawn_Y, Float: spawn_Z, Float: z_Angle, color1, color2, respawn_Delay, siren = 0, Float:health = 0.0)
{
	new id = m_custom_sync_AddStaticVehEx(modelID, spawn_X, spawn_Y, spawn_Z, z_Angle, color1, color2, respawn_Delay, bool:siren);

	GetVehicleParamsEx(id, engine, lights, alarm, doors, bonnet, boot, objective);
   	SetVehicleParamsEx(id, false, false, false, false, false, false, objective);

    VehInfo[id][vStat] = 1;
    VehInfo[id][vVehcol1] = color1, VehInfo[id][vVehcol2] = color2;
    VehInfo[id][vModel] = modelID;
	VehInfo[id][vTimerSpawn] -= 1;

	VehInfo[id][vPanels] = 0;
	VehInfo[id][vDoors] = 0;
	VehInfo[id][vFara] = 0;
	VehInfo[id][vTires] = 0;

	if(!health) health = MaxVehicleHealth(modelID, id);
	VehInfo[id][vHealth] = health;
	SetVehicleHealth(id, VehInfo[id][vHealth]);

	QuantityVehicles ++;
    return id;
}

stock AddShopVehicleVisual()
{
	LinkVehicleToInterior(bizsalonveh[0], 186);
	SetVehicleVirtualWorld(bizsalonveh[0], 3078);

	SetVehicleVirtualWorld(bizsalonveh[1], 3079);
	LinkVehicleToInterior(bizsalonveh[1], 186);

	SetVehicleVirtualWorld(bizsalonveh[2], 3081);
	LinkVehicleToInterior(bizsalonveh[2], 186);

	SetVehicleVirtualWorld(bizsalonveh[3], 3082);
	LinkVehicleToInterior(bizsalonveh[3], 186);

	SetVehicleVirtualWorld(bizsalonveh[4], 3083);
	LinkVehicleToInterior(bizsalonveh[4], 186);

	SetVehicleVirtualWorld(bizsalonveh[5], 3084);
	LinkVehicleToInterior(bizsalonveh[5], 186);

	SetVehicleVirtualWorld(bizsalonveh[6], 3085);
	LinkVehicleToInterior(bizsalonveh[6], 186);

	SetVehicleVirtualWorld(bizsalonveh[7], 3086);
	LinkVehicleToInterior(bizsalonveh[7], 186);

	SetVehicleVirtualWorld(bizsalonveh[8], 3087);
	LinkVehicleToInterior(bizsalonveh[8], 185);

	SetVehicleVirtualWorld(bizsalonveh[9], 3088);
	LinkVehicleToInterior(bizsalonveh[9], 185);

	SetVehicleVirtualWorld(bizsalonveh[10], 3089);
	LinkVehicleToInterior(bizsalonveh[10], 185);
}

stock veh_openbonnet(v)
{
	GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);
	if(IsABootFront(v)) SetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, true, objective);
	else SetVehicleParamsEx(v, engine, lights, alarm, doors, true, boot, objective);
	VehInfo[v][vBonnet] = 1;
	if(VehInfo[v][vNospawn] != 2) VehInfo[v][vNospawn] = 1;
}
stock veh_openboot(v)
{
	GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);
	if(IsABootFront(v)) SetVehicleParamsEx(v, engine, lights, alarm, doors, true, boot, objective);
	else SetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, true, objective);
	VehInfo[v][vBoot] = 1;
	if(VehInfo[v][vNospawn] != 2) VehInfo[v][vNospawn] = 1;
}

stock IsAPosBootOrBonet(playerid, &type)
{
	new vehicleid = -1;
	new Float:pos_veh[3];
	for(new v = 0; v < SKOKOCAROV; v++)
	{
		if(VehInfo[v][vModel] == 0) continue;
		// if(!IsVehicleOpen(playerid, v)) continue;
		if(GetVehicleInterior(v) != GetPlayerInterior(playerid) || GetVehicleVirtualWorld(v) != GetPlayerVirtualWorld(playerid)) continue;

		if(IsAMoto(VehInfo[v][vModel]) || IsABoat(VehInfo[v][vModel]))
		{
			GetVehiclePos(v, pos_veh[0], pos_veh[1], pos_veh[2]);
			if(IsPlayerInRangeOfPoint(playerid, 2.0, pos_veh[0], pos_veh[1], pos_veh[2]))
			{
				vehicleid = v;
				type = 2;
				break;
			}
		}
		else if(IsAPlane(VehInfo[v][vModel]))
		{
			GetVehiclePos(v, pos_veh[0], pos_veh[1], pos_veh[2]);
			if(IsPlayerInRangeOfPoint(playerid, 4.0, pos_veh[0], pos_veh[1], pos_veh[2]))
			{
				vehicleid = v;
				type = 2;
				break;
			}
		}
		else
		{
			type = GetVehicleNear_Side(playerid, v);
			if(type > 0)
			{
				vehicleid = v;
				break;
			}
		}
	}
	return vehicleid;
}
stock IsAPosBoot(playerid) // Ищем транспорт с багажником рядом
{
	new vehicleid;
	for(new v = 0; v < SKOKOCAROV; v++)
	{
		if(VehInfo[v][vModel] == 0
			|| !IsABoot(v)
			|| GetVehicleInterior(v) != GetPlayerInterior(playerid) || GetVehicleVirtualWorld(v) != GetPlayerVirtualWorld(playerid)
			|| !IsVehicleOpen(playerid, v)
			|| !GetVehicleNear_Boot(playerid, v)) continue;

		vehicleid = v;
		break;
	}
	return vehicleid;
}

// Ищем транспорт с багажником рядом, который можно открыть только бомбой липучкой
stock IsAPosBootHardLock(playerid)
{
	new vehicleid;
	for(new v = 0; v < SKOKOCAROV; v++)
	{
		if(VehInfo[v][vModel] == 0
			|| !IsABoot(v)
			|| GetVehicleInterior(v) != GetPlayerInterior(playerid) || GetVehicleVirtualWorld(v) != GetPlayerVirtualWorld(playerid)
			|| !GetVehicleNear_Boot(playerid, v)
			|| !IsAHardLockVeicle(VehInfo[v][vModel])) continue;

		vehicleid = v;
		break;
	}
	return vehicleid;
}

stock GetVehicleNear_Boot(playerid, v) // Получаем инфу, стоим ли мы у багажника авто
{
    new Float:pos_veh[3];
    if(IsABootFront(v)) // Багажник спереди
    {
        GetCoordBonnetVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 1.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
    else // Багажник сзади
    {
        GetCoordBootVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 1.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
	return 0;
}
stock GetVehicleNear_Bonet(playerid, v) // Получаем инфу, стоим ли мы у капота авто
{
    new Float:pos_veh[3];
    if(IsABootFront(v)) // Багажник спереди
    {
        GetCoordBootVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 1.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
    else // Багажник сзади
    {
        GetCoordBonnetVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 1.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
	return 0;
}
stock GetVehicleNear_Side(playerid, v) // Получаем инфу, у какой части транспорта мы стоим
{
	new Float:boot_veh[3], Float:bonet_veh[3], sideId;
	if(IsABootFront(v)) // Багажник спереди
	{
        GetCoordBonnetVehicle(v, bonet_veh[0], bonet_veh[1], bonet_veh[2]);
        GetCoordBootVehicle(v, boot_veh[0], boot_veh[1], boot_veh[2]);
		if(IsPlayerInRangeOfPoint(playerid, 1.0, bonet_veh[0], bonet_veh[1], bonet_veh[2])) 
        {
            if(IsABoot(v)) sideId = 1; // Багажник
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1.0, boot_veh[0], boot_veh[1], boot_veh[2])) 
		{
			if(!IsANoEngine(VehInfo[v][vModel])) sideId = 2; // Капот
		}
	}
	else // Багажник сзади
	{
        GetCoordBonnetVehicle(v, bonet_veh[0], bonet_veh[1], bonet_veh[2]);
        GetCoordBootVehicle(v, boot_veh[0], boot_veh[1], boot_veh[2]);
		if(IsPlayerInRangeOfPoint(playerid, 1.0, bonet_veh[0], bonet_veh[1], bonet_veh[2])) 
		{
			if(!IsANoEngine(VehInfo[v][vModel])) sideId = 2; // Капот
		}
        else if(IsPlayerInRangeOfPoint(playerid, 1.0, boot_veh[0], boot_veh[1], boot_veh[2]))
        {
            if(IsABoot(v)) sideId = 1; // Багажник
        }
	}
	return sideId;
}

CMD:getside(playerid, const params[])
{
	if(server != 0) return 0;
	if(sscanf(params, "ii", params[0], params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: /getside id side (side 0 перед, side 1 зад)");
	
	GetDetailPosVehicle(playerid, params[0], params[1]);
	return 1;
}

stock GetDetailPosVehicle(playerid, vehicleid, typeSide)
{
	if(typeSide < 0 || typeSide > 1) return ErrorMessage(playerid, "{FF6347}Side 0 перед, side 1 зад");
	if(vehicleid < 0 || vehicleid >= 2000) return ErrorMessage(playerid, "{FF6347}Не меньше 0 и не больше 1999");
	if(!IsValidVehicle(vehicleid)) return ErrorMessage(playerid, "{FF6347}Транспорта с этим id не существует");

	new Float:pos[3];
	if(typeSide == 0) GetCoordBonnetVehicle(vehicleid, pos[0], pos[1], pos[2]);
	else if(typeSide == 1) GetCoordBootVehicle(vehicleid, pos[0], pos[1], pos[2]);
	CreateGps(playerid, pos[0], pos[1], pos[2], 0, 0, 2.0);
	return 1;
}

stock IsATrashBoot(playerid) // Позиция багажника в мусоровоза
{
	new Float:Boot[3];
	for(new v = 0; v < SKOKOCAROV; v++)
	{
		if(VehInfo[v][vModel] != 408) continue;
		if(GetVehicleInterior(v) != GetPlayerInterior(playerid) || GetVehicleVirtualWorld(v) != GetPlayerVirtualWorld(playerid)) continue;
		
		GetCoordBootVehicle(v, Boot[0], Boot[1], Boot[2]);
		if(IsPlayerInRangeOfPoint(playerid, 2.5, Boot[0], Boot[1], Boot[2]))
		{
			return v;
		}
	}
	return 0;
}

stock MaxVehicleHealth(model, vehicleid = 0)
{
	new maxhealth;
    if(model == 428 || model == 470 || model == 528) maxhealth = 3000;
    else if(model == 427 || model == 433 || model == 425 || model == 548 || model == 601) maxhealth = 4000;
    else if(model == 432) maxhealth = 6000;
	else if(model == 537 || model == 538 || model == 2032) maxhealth = 10000; // train
    else maxhealth = 2000;

	if(vehicleid > 0) maxhealth += floatround(VehInfo[vehicleid][vArmor], floatround_round);
	return maxhealth;
}

stock IsVehicleOpen(playerid, v)
{
	if((VehInfo[v][vSost] == PlayerInfo[playerid][pID] || VehInfo[v][vKey] == PlayerInfo[playerid][pID] && VehInfo[v][vKeyUnix] > gettime()) 
		&& GetPlayerVip(playerid) > 0) return 1; // Личный или есть ключи + VIP
	else
	{
		if(VehInfo[v][vCarLock] == 0) return 1; // Транспорт открыт
	}
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
    || model == 603 || model == 604 || model == 605 || model == 609
	|| model >= 2000 && model <= 2035 || model >= 2037 && model <= 2079 
	|| model >= 2082 && model <= 2099 || model >= 2101 && model <= 2109 || model >= 2111 && model <= 2114
	|| model >= 2118 && model <= 2127 || model >= 2131 && model <= 2133) type = 1;


    // Мототранспорт (Требуется лицензия на мото транспорт) Moto
    else if(model == 448 || model == 461 || model == 462 || model == 463 || model == 468 || model == 471 || model == 521
    || model == 522 || model == 523 || model == 571 || model == 581 || model == 586 || model == 2100 || model == 2115
	|| model == 2116 || model == 2117) type = 2;

    // Водный Транспорт (Требуется лицензия на катер) Boat
    else if(model == 430 || model == 446 || model == 452 || model == 453 || model == 454 || model == 472
    || model == 473 || model == 484 || model == 493 || model == 539 || model == 595) type = 3;

    // Вертолёты (Требуется лицензия на вертолёт) Helicopter
    else if(model == 417 || model == 425 || model == 447 || model == 469 || model == 487 || model == 488 || model == 497 
    || model == 548 || model == 563 || model == 2036 || model == 2128 || model == 2129 || model == 2130) type = 4;

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
    || m == 560 || m == 562 || m == 565 || m == 580 || m == 586
	|| m == 2000 || m == 2002 || m == 2003 || m == 2020 || m == 2022 || m == 2023 || m == 2024 || m == 2033 || m == 2034
	|| m == 2052 || m == 2057 || m == 2056 || m == 2066 || m == 2068 || m == 2069 || m == 2070 || m == 2071 || m == 2072
	|| m == 2084 || m == 2085 || m == 2086 || m == 2089 || m == 2092 || m == 2093 || m == 2096 || m == 2101 || m == 2104
	|| m == 2105 || m == 2107 || m == 2108 || m == 2109 || m == 2123 || m == 2124) class = 1;

    // Middle Class (2) - Средний
    else if(m == 401 || m == 405 || m == 418 || m == 419 || m == 421 || m == 426 || m == 439 || m == 445 || m == 452 || m == 460
    || m == 461 || m == 463 || m == 468 || m == 469 || m == 471 || m == 480 || m == 484 || m == 487 || m == 491 || m == 496
    || m == 507 || m == 511 || m == 516 || m == 533 || m == 534 || m == 550 || m == 551 || m == 555 || m == 558 || m == 561
    || m == 581 || m == 585 || m == 587 || m == 589 || m == 602 || m == 603
	|| m == 2001 || m == 2006 || m == 2007 || m == 2008 || m == 2009 || m == 2010 || m == 2012 || m == 2016
	|| m == 2018 || m == 2026 || m == 2027 || m == 2028 || m == 2029 || m == 2030 || m == 2039 || m == 2049 
	|| m == 2073 || m == 2076 || m == 2083 || m == 2087 || m == 2095 || m == 2100 || m == 2106 || m == 2111 || m == 2118
	|| m == 2121 || m == 2122 || m == 2125) class = 2;

    // Economy Class (3) - Бомж
    else if(m == 404 || m == 410 || m == 412 || m == 436 || m == 453 || m == 458 || m == 462 || m == 466 || m == 467 || m == 472
    || m == 474 || m == 475 || m == 479 || m == 492 || m == 512 || m == 513 || m == 517 || m == 518 || m == 526 || m == 527
    || m == 529 || m == 536 || m == 540 || m == 542 || m == 546 || m == 547 || m == 549 || m == 553 || m == 566 || m == 567
    || m == 575 || m == 576 || m == 593 || m == 595 || m == 600
	|| m == 2004 || m == 2019 || m == 2021 || m == 2031 || m == 2043 || m == 2048 || m == 2051 || m == 2053 || m == 2059 || m == 2061
	|| m == 2065 || m == 2013 || m == 2017 || m == 2025 || m == 2054 || m == 2067 || m == 2074 || m == 2075 || m == 2077
	|| m == 2082 || m == 2115 || m == 2116 || m == 2126 || m == 2127) class = 3;

    // Off-Road Class (4) - Внедорожник
    else if(m == 400 || m == 422 || m == 489 || m == 495 || m == 500 || m == 543 || m == 554 || m == 579
	|| m == 2005 || m == 2011 || m == 2014 || m == 2015 || m == 2050 || m == 2094 || m == 2103 || m == 2113 || m == 2114 || m == 2119) class = 4;

    // Special Class (5) - Грузовая и Спец Техника
    else if(m == 403 || m == 413 || m == 414 || m == 417 || m == 440 || m == 455 || m == 456
    || m == 459 || m == 478 || m == 482 || m == 498 || m == 499 || m == 508 || m == 514 || m == 515 || m == 578
	|| m == 2055 || m == 2090 || m == 2091) class = 5;

    // Unique Class (6) - Уникальный Транспорт
    else if(m == 423 || m == 424 || m == 431 || m == 434 || m == 437 || m == 442 || m == 443 || m == 444 || m == 457 || m == 473 
    || m == 476 || m == 481 || m == 483
    || m == 504 || m == 509 || m == 510 || m == 530 || m == 531 || m == 532 || m == 545 || m == 556 || m == 557 || m == 571 
    || m == 573 || m == 577 || m == 588 || m == 592 || m == 2035 || m == 2042 || m == 2058 || m == 2062 || m == 2063 || m == 2064
	|| m == 2088 || m == 2102 || m == 2117 || m == 2120 || m == 2131 || m == 2132 || m == 2133) class = 6;

    // Goverment Class (7) - Государственный Транспорт
    else if(m == 406 || m == 407 || m == 408 || m == 416 || m == 420 || m == 425 || m == 427 || m == 428 || m == 430 || m == 432 
    || m == 438 || m == 447 || m == 448 || m == 470 || m == 485 || m == 486 || m == 488 || m == 490 || m == 497 || m == 520
    || m == 523 || m == 524 || m == 525 || m == 528 || m == 539 || m == 544 || m == 548 || m == 552 || m == 563 || m == 572 
    || m == 574 || m == 582 || m == 583 || m == 596 || m == 597 || m == 598 || m == 599 || m == 601 
	|| m == 2032 || m == 2036 || m == 2037 || m == 2038 || m == 2040 || m == 2041 || m == 2044 || m == 2045 || m == 2046
	|| m == 2047 || m == 2060 || m == 2097 || m == 2098 || m == 2099 || m == 2112 || m == 2128 || m == 2129 || m == 2130) class = 7;

    else class = 0; // 0 Класс недоступен для продажи (неизвестный транспорт)
    return class;
}

stock IsABoot(carid) // Транспорт, у которых есть багажник
{
	new model = VehInfo[carid][vModel];
	if(model == 400 || model == 401 || model == 402 || model == 404 || model == 405 || model == 409 || model == 410 || model == 411 || model == 412 || model == 413
    || model == 415 || model == 418 || model == 419 || model == 420 || model == 421 || model == 422 || model == 426 || model == 428 || model == 429 || model == 433 || model == 434 || model == 436
    || model == 438 || model == 439 || model == 440 || model == 442 || model == 444 || model == 445 || model == 451 || model == 458 || model == 459 || model == 466 || model == 467
    || model == 470 || model == 474 || model == 475 || model == 477 || model == 479 || model == 480 || model == 489 || model == 490 || model == 491
    || model == 492 || model == 494 || model == 495 || model == 496 || model == 498 || model == 500 || model == 502 || model == 503 || model == 504 || model == 505 || model == 506
    || model == 507 || model == 516 || model == 517 || model == 518 || model == 526 || model == 527 || model == 528 || model == 529 || model == 533 || model == 534 || model == 535
    || model == 536 || model == 540 || model == 541 || model == 542 || model == 543 || model == 545 || model == 546 || model == 547 || model == 549 || model == 550 || model == 551
    || model == 554 || model == 555 || model == 556 || model == 557 || model == 558 || model == 559 || model == 560 || model == 561 || model == 562 || model == 565 || model == 566
    || model == 567 || model == 573 || model == 575 || model == 576 || model == 579 || model == 580 || model == 585 || model == 587 || model == 589 || model == 596 || model == 597
    || model == 598 || model == 599 || model == 600 || model == 602 || model == 603 || model == 604 || model == 605 || model == 609
	|| model >= 2000 && model <= 2031 || model >= 2033 && model <= 2035
	|| model >= 2037 && model <= 2041 || model >= 2043 && model <= 2077
	|| model >= 2082 && model <= 2087 || model >= 2089 && model <= 2098 || model ==  2102 || model ==  2103 || model ==  2106 || model ==  2111 || model ==  2113
	|| model ==  2114 || model ==  2118 || model >= 2118 && model <= 2127 || model ==  2133) return 1;
	return 0;
}

stock IsABootFront(carid)
{
	new m = VehInfo[carid][vModel];
	if(m == 415 || m == 424 || m == 437 || m == 451 || m == 483 || m == 486 || m == 530 || m == 532 
	|| m == 541 || m == 568 || m == 588 || m == 601
	|| m == 2000 || m == 2023 || m == 2024 || m == 2028 || m == 2041 || m == 2056 || m == 2069 || m == 2072
	|| m == 2088 || m == 2101 || m == 2104 || m == 2105 || m ==  2107 || m ==  2108 || m ==  2109 || m ==  2131 || m ==  2132) return 1;
	return 0;
}

stock IsA_Gen5(carid) // 5 слотов в багажнике
{
	new model = VehInfo[carid][vModel];
	if(model == 400 || model == 401 || model == 402 || model == 404 || model == 405 || model == 409 || model == 410 || model == 411 || model == 412 || model == 415
    || model == 419 || model == 420 || model == 421 || model == 426 || model == 429 || model == 434 || model == 436 || model == 438 || model == 439 || model == 442 || model == 445
    || model == 451 || model == 458 || model == 466 || model == 467 || model == 470 || model == 474 || model == 475 || model == 477 || model == 479 || model == 480 || model == 489
    || model == 490 || model == 491 || model == 492 || model == 495 || model == 496 || model == 500 || model == 504 || model == 505 || model == 506 || model == 507 || model == 516
    || model == 517 || model == 518 || model == 526 || model == 527 || model == 529 || model == 533 || model == 534 || model == 536 || model == 540 || model == 541 || model == 542
    || model == 545 || model == 546 || model == 547 || model == 549 || model == 550 || model == 551 || model == 555 || model == 558 || model == 559 || model == 560 || model == 561
    || model == 562 || model == 565 || model == 566 || model == 567 || model == 575 || model == 576 || model == 579 || model == 580 || model == 585 || model == 587 || model == 589
    || model == 596 || model == 597 || model == 598 || model == 599 || model == 602 || model == 603 || model == 604
	|| model == 2000 || model == 2001 || model == 2002 || model == 2003 || model == 2004 || model == 2006 || model == 2007
	|| model == 2008 || model == 2009 || model == 2010 || model == 2012 || model == 2013 || model == 2016 || model == 2017
	|| model == 2019 || model == 2020 || model == 2021 || model == 2022 || model == 2023 || model == 2024 || model == 2026
	|| model == 2027 || model == 2028 || model == 2029 || model == 2030 || model == 2031 || model == 2033 || model == 2034
	|| model == 2035 || model == 2038 || model == 2039 || model == 2043 || model == 2044 || model == 2048 || model == 2049
	|| model == 2050 || model == 2051 || model == 2052 || model == 2053 || model == 2054 || model == 2056 || model == 2057 || model == 2058
	|| model == 2059 || model == 2061 || model == 2062 || model == 2063 || model == 2064 || model >= 2065 && model <= 2077
	|| model == 2082 || model >= 2083 && model <= 2087 || model == 2089 || model >= 2092 && model <= 2096 || model >= 2101 && model <= 2109
	|| model ==  2111 || model ==  2113 || model ==  2114 || model >= 2118 && model <= 2127 || model >= 2131 && model <= 2133) return 1;
	return 0;
}

stock IsA_Gen10(carid) // 10 слотов в багажнике
{
	new model = VehInfo[carid][vModel];
	if(model == 418 || model == 422 || model == 444 || model == 543 || model == 554 || model == 556 || model == 557 || model == 600 || model == 605
	|| model == 2005 || model == 2011 || model == 2014 || model == 2018 || model == 2025 || model == 2037 || model == 2045
	|| model == 2046 || model == 2047) return 1;
	return 0;
}

stock IsA_Gen15(carid) // 15 слотов в багажнике
{
	new model = VehInfo[carid][vModel];
	if(model == 413 || model == 414 || model == 440 || model == 459 || model == 478 || model == 482 || model == 498 || model == 499 || model == 609
	|| model == 2015 || model == 2041 || model == 2060) return 1;
	return 0;
}

stock IsATaxi(carid) // Транспорт, который разрешён для работы в такси
{
	new model = VehInfo[carid][vModel];
	if(model >= 400 && model <= 424 || model >= 426 && model <= 429 || model == 431 || model == 433 || model == 434 || model >= 436 && model <= 440 || model >= 442 && model <= 445
 	|| model == 447 || model == 448 || model == 451 || model >= 455 && model <= 463 || model >= 466 && model <= 471 || model == 474 || model == 475 || model >= 477 && model <= 480
 	|| model == 482 || model == 483 || model >= 487 && model <= 492 || model >= 494 && model <= 500 || model >= 502 && model <= 508 || model == 511 || model >= 514 && model <= 518
 	|| model >= 521 && model <= 529 || model >= 533 && model <= 536 || model >= 540 && model <= 552 || model >= 554 && model <= 563 || model >= 565 && model <= 567
 	|| model >= 573 && model <= 576 || model >= 578 && model <= 582 || model >= 585 && model <= 589 || model == 593 || model >= 596 && model <= 605 || model == 609
	|| model >= 2000 && model <= 2077
	|| model == 2082 || model == 2083 || model == 2086 || model == 2087 || model == 2089 || model == 2092 || model == 2094 || model == 2095 || model == 2106
	|| model == 2113 || model == 2114 || model == 2119 || model == 2121 || model == 2122 || model == 2125 || model == 2126 || model == 2127) return 1;
	return 0;
}

stock IsAVello(carid) // Велики
{
	new model = VehInfo[carid][vModel];
	new type = GetVehicleType(model);
	if(type == 6) return 1;
	return 0;
}

stock IsAZad(model) // Транспорт с задними окнами
{
    if(model == 404 || model == 405 || model == 409 || model == 420 || model == 421 || model == 426 || model == 438
	|| model == 445 || model == 458 || model == 466 || model == 467 || model == 470 || model == 479 || model == 490
 	|| model == 492 || model == 507 || model == 516 || model == 529 || model == 540 || model == 546 || model == 547
  	|| model == 550 || model == 551 || model == 560 || model == 561 || model == 566 || model == 579 || model == 580
   	|| model == 585 || model == 596 || model == 597 || model == 598 || model == 604
	|| model == 2005 || model == 2007 || model == 2008 || model == 2009 || model == 2011 || model == 2012 || model == 2014
	|| model == 2015 || model == 2017 || model == 2018 || model == 2020 || model == 2021 || model == 2025 || model == 2033 || model == 2034
	|| model >= 2037 && model <= 2047 || model == 2051 || model == 2054 || model == 2057 || model == 2060 || model == 2062
	|| model >= 2066 && model <= 2068 || model == 2071 || model == 2073 
	|| model == 2082 || model == 2083 || model == 2086 || model == 2087 || model == 2089 || model == 2092 || model == 2094 || model == 2095
	|| model == 2106 || model == 2113 || model == 2114 || model == 2119 || model == 2120 || model == 2121 || model == 2122
	|| model == 2126 || model == 2133) return 1;
	return 0;
}

stock IsABus(model)
{
	if(model == 431 || model == 437 
		|| GetVehModelOriginal(model) == 431
		|| GetVehModelOriginal(model) == 437) return 1;
	return 0;
}

stock IsACar(model) // Авто
{
	new type = GetVehicleType(model);
	if(type == 1) return 1;
	return 0;
}

stock IsANotTuning(model) // Запрещено ставить тюнинг
{
    if(model == 539) return 1;
	return 0;
}

stock IsABoat(model) // Лодки
{
	new type = GetVehicleType(model);
	if(type == 3) return 1;
	return 0;
}

// Воздушный ТС Самолёты и Вертолёты
stock IsAPlane(model)
{
	new type = GetVehicleType(model);
	if(type == 4 || type == 5) return 1;
	return 0;
}

// Самолёты
stock IsAAir(model)
{
	new type = GetVehicleType(model);
	if(type == 5) return 1;
	return 0;
}
// Вертолёты
stock IsAHeli(model)
{
	new type = GetVehicleType(model);
	if(type == 4) return 1;
	return 0;
}

stock IsAMoto(model)
{
	new type = GetVehicleType(model);
	if(type == 2) return 1;
	return 0;
}

stock IsAScooter(model)
{
	if(model == 462) return 1;
	return 0;
}

stock IsAEnforcer(model)
{
	if(model == 427 || model == 2040) return 1;
	return 0;
}

stock IsARC(model)
{
    if(model == 441 || model == 464 || model == 465 || model == 501 || model == 564 || model == 594) return 1;
	return 0;
}

stock IsANoEngine(model)
{
	if(model == 435 || model == 441 || model == 450 || model == 464 || model == 465 || model == 509 || model == 510 
	|| model == 564 || model == 584 || model == 590 || model == 591 || model == 594
	|| model == 606 || model == 607 || model == 608 || model == 610 || model == 611) return 1;
	return 0;
}

stock IsATrain(model)
{
    if(model == 537 || model == 538 || model == 569 || model == 570 || model == 590) return 1;
	return 0;
}

stock IsAShassi(model)
{
    if(model == 460 || model == 476 || model == 511 || model == 512 || model == 513 || model == 519 || model == 520 || model == 553 || model == 577
    || model == 592|| model == 593) return 1;
	return 0;
}

stock IsABig(model)
{
    if(model == 403 || model == 406 || model == 407 || model == 408 || model == 414 || model == 416 || model == 427 || model == 428
	|| model == 431 || model == 432 || model == 433 || model == 437 || model == 443 || model == 444 || model == 445 || model == 456
	|| model == 486 || model == 498 || model == 499 || model == 508 || model == 514 || model == 515 || model == 524 || model == 528
 	|| model == 532 || model == 544 || model == 556 || model == 557 || model == 573 || model == 578 || model == 582 || model == 588
  	|| model == 601 || model == 609 || model == 455 || model == 531) return 1;
	return 0;
}

stock IsATun(model) // Транспорт, на который можно на сервере устанавливать обвесы
{
    if(model == 558 || model == 559 || model == 560 || model == 561 || model == 562 || model == 565) return 1;
	return 0;
}

stock IsAMafCar(model) // Транспорт для мафий
{
    if(model == 405 || model == 609 || model == 445 || model == 562 || model == 461 || model == 579 || model == 540
    || model == 602 || model == 580 || model == 409 || model == 439 || model == 477 || model == 489 || model == 507
	|| model == 529 || model == 533 || model == 550 || model == 555 || model == 589 || model == 402 || model == 439
 	|| model == 451 || model == 506 || model == 521 || model == 560) return 1;
	return 0;
}

stock IsAGangCar(model) // Транспорт для банд
{
    if(model == 492 || model == 567 || model == 536 || model == 535 || model == 475 || model == 468 || model == 412 || model == 566
    || model == 517 || model == 576 || model == 575 || model == 467 || model == 466 || model == 482 || model == 419 || model == 518
	|| model == 534 || model == 404 || model == 413 || model == 422 || model == 471 || model == 474 || model == 479 || model == 491
 	|| model == 496 || model == 498 || model == 529 || model == 533 || model == 542 || model == 549 || model == 581 || model == 600
  	|| model == 603) return 1;
	return 0;
}

// Ищем транспорт в нужных нам координатах по модели
stock GetNeedVehicleNearby(model, Float:x, Float:y, Float:z, Float:radius)
{
	new yes;
	for(new v = 0; v < SKOKOCAROV; v++)
	{
		if(VehInfo[v][vModel] != model) continue;

		new Float:dist = GetVehicleDistanceFromPoint(v, x, y, z);
		if(dist <= radius)
		{
			yes = 1;
			break;
		}
	}
	return yes;
}

stock vehprice(playerid, page) // Настройки гос. цен транспорта
{
	new max_line = 40, yesNext, minlist, thisPage;
	new line[214],lines[4096];

	// Настраиваем отображение фильтров и страниц
	LoadPageSorting(playerid, 1066, 211 + sizeof(vehNameCustom) + 1, minlist, page, thisPage);

	format(line,sizeof(line),"{cccccc}Транспорт [Модель]\t{cccccc}Цена\t{cccccc}Gold\t{cccccc}Куплено за Вирты / Gold"), strcat(lines,line);
	if(IsActiveSorting(playerid)) format(line,sizeof(line),"\n{ff9000}Фильтр {99ff66}[Активен]\t\t\t"), strcat(lines,line);
    else format(line,sizeof(line),"\n{ff9000}Фильтр\t\t\t"), strcat(lines,line);

	new one;
	for(new v = minlist; v < 211 + sizeof(vehNameCustom) + 1; v++)
	{
		if(one == 0) OnlineInfo[playerid][oDialogMenu][4] = v, one = 1; // Записывали первый vehicleList

		if(CheckSortingLineVehPrice(playerid, v)) format(line,sizeof(line),"%s", ShowLineVehPrice(playerid, v)), strcat(lines,line);

		if(OnlineInfo[playerid][oDialogMenu][0] >= max_line) // Сбрасываем дальнейший вывод строк, если дошли до лимита на странице
        {
			yesNext = 1;
            break;
        }

		if(v > 211 + sizeof(vehNameCustom) + 1 && page > 0)
		{
			yesNext = 1; // Последний транспорт, отображаем Next Page
			OnlineInfo[playerid][oDialogMenu][5] = 1; // Записываем, что эта страница была последней
		}
	}
	if(yesNext == 1) format(line,sizeof(line),"\n{cccccc}Next Page >>\t\t\t"), strcat(lines,line);
	new header[60];
    format(header,sizeof(header),"Гос Стоимость Транспорта [ Страница %d ]", page + 1);
    ShowDialog(playerid,1066,DIALOG_STYLE_TABLIST_HEADERS,header,lines,"Выбрать","Выход");
    return 1;
}

stock CheckSortingLineVehPrice(playerid, v)
{
	new vehicleList = v;
	v = CorrectVehicleList(vehicleList);
	
	if(OnlineInfo[playerid][oSorting][1] > 0) // Фильтр по ID
	{
		new sortingID[14], vehicleID[14];
		valstr(sortingID, OnlineInfo[playerid][oSorting][1]);
		valstr(vehicleID, v);

		if(strfind(vehicleID, sortingID, true) != -1) {} // Отображаем схожие ID
		else return 0; // Отображаем только фильтрованные id транспортных средств
	}

	if(!strcmp(OnlineInfo[playerid][oSortingName],"\0",true)) {} // Фильтр по названию не включен
	else
	{
		if(strfind(GetVehicleName(v), OnlineInfo[playerid][oSortingName], true) != -1) {} // Отображаем схожую строку
		else return 0; // Отображаем только фильтрованные названия транспортных средств
	}
	return 1;
}

stock ShowLineVehPrice(playerid, v)
{
	new line[214], atext[14];
	new vehicleList = v;
	v = CorrectVehicleList(vehicleList);

    List[OnlineInfo[playerid][oDialogMenu][0]][playerid] = vehicleList;
    OnlineInfo[playerid][oDialogMenu][0] ++; // Подсчитываем строки
	OnlineInfo[playerid][oDialogMenu][2] = vehicleList;

	if(VehLimited[vehicleList] > 0) atext = "D39EE0"; // Лимитированный транспорт
	else
	{
		if(v >= 2000) atext = "0088ff"; // Custom
		else atext = "cccccc"; // Обычный транспорт
	}

	if(VehSale[vehicleList]) format(line,sizeof(line),"\n{%s}%s {cccccc}[%d]\t{99ff66}%d$ {cccccc}[%s]\t{ffcc00}%dG\t{cccccc}%d / %d", atext, GetVehicleName(v), v, VehGos[vehicleList], get_k(VehGos[vehicleList]), VehGold[vehicleList], VehBuy[vehicleList], VehBuyGold[vehicleList]);
    else format(line,sizeof(line),"\n{%s}%s {cccccc}[%d]\t%d$ {cccccc}[%s]\t%dG\t{cccccc}%d / %d", atext, GetVehicleName(v), v, VehGos[vehicleList], get_k(VehGos[vehicleList]), VehGold[vehicleList], VehBuy[vehicleList], VehBuyGold[vehicleList]);
	return line;
}

stock SettingGosPriceVehicle(playerid, vehicleList)
{
	new v = CorrectVehicleList(vehicleList);

	new line[120],lines[360];
    if(v >= 2000) format(line,sizeof(line),"{0088ff}%s\t \t", GetVehicleName(v)), strcat(lines,line);
	else format(line,sizeof(line),"{cccccc}%s\t \t", GetVehicleName(v)), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Стоимость:\t{99ff66}%d$ {cccccc}[%s] \t", VehGos[vehicleList], get_k(VehGos[vehicleList])), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Gold:\t{ffcc00}%dG \t", VehGold[vehicleList]), strcat(lines,line);
	if(VehLimited[vehicleList] == 0) format(line,sizeof(line),"\n{cccccc}Limited:\t{99ff66}Не ограничено \t"), strcat(lines,line);
	else format(line,sizeof(line),"\n{cccccc}Limited:\t{D39EE0}%d \t На руках %d", VehLimited[vehicleList], VehQuan[vehicleList]), strcat(lines,line);

	if(VehSale[vehicleList]) format(line,sizeof(line),"\n{cccccc}Доступ к продаже:\t{99ff66}[ On ]"), strcat(lines,line);
	else format(line,sizeof(line),"\n{cccccc}Доступ к продаже:\t{FF6347}[ Off ]"), strcat(lines,line);
    ShowDialog(playerid,1086,DIALOG_STYLE_TABLIST_HEADERS,"Гос Стоимость Транспорта",lines,"Выбрать","Назад");
	return 1;
}

stock CorrectVehicleList(vehicleList)
{
	new v = vehicleList;
	if(v >= 212) v += 1788;
	else v += 400;
	return v;
}

stock CorrectVehicleID(model)
{
	if(model >= 2000) model -= 1788;
	else if(model >= 400 && model <= 611) model -= 400;
	return model;
}

stock dialogCase_Vehicle(playerid, dialogid, response, listitem, const inputtext[])
{
	if(dialogid == 1066)
	{
		if(response)
		{
			if(listitem == 0) DialogMenuSorting(playerid);

			if(OnlineInfo[playerid][oDialogMenu][0] > 0) // Есть строки на странице
			{
				if(listitem >= 1 && listitem <= OnlineInfo[playerid][oDialogMenu][0]) // Отображаемые List
				{
					new vehicleList = List[listitem-1][playerid];
					OnlineInfo[playerid][oDialogMenu][3] = vehicleList;
					SettingGosPriceVehicle(playerid, vehicleList);
				}
				else if(listitem == OnlineInfo[playerid][oDialogMenu][0] + 1) vehprice(playerid, OnlineInfo[playerid][oDialogMenu][1] + 1); // Следующая страница
			}
		}
		else pc_cmd_economy(playerid);
	}
	else if(dialogid == 1067)
	{
		if(response)
		{
			new input = strval(inputtext);
			new vehicleList = OnlineInfo[playerid][oDialogMenu][3];
			if(input < 1 || input > 900000000) return ErrorText(playerid, "{FF6347}Не меньше 1$ и не больше 900.000.000$"), SettingGosPriceVehicle(playerid, vehicleList);
			VehGos[vehicleList] = input;

			new v = CorrectVehicleList(vehicleList);
			PlayerPlaySound(playerid, 6401, 0,0,0);
			SaveVehiclePrice(vehicleList);

			new string[180];
			format(string,sizeof(string),"[ Мысли ]: Гос. стоимость %s теперь составляет: {99ff66}%d$ [%s]", GetVehicleName(v), VehGos[vehicleList], get_k(VehGos[vehicleList]));
  			SendClientMessage(playerid,COLOR_GREY,string);
  			format(string, sizeof(string), "[Правительство] %s изменяет гос. стоимость: %s {99ff66}%d$ [%s]", PlayerInfo[playerid][pName], GetVehicleName(v), VehGos[vehicleList], get_k(VehGos[vehicleList]));
  			SendDepartMessage(COLOR_ALLDEPT, string);
			SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);
     		OrgLog(7, "minfin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", input, GetVehicleName(v));

			// Сбрасываем ценники в Бизнесах: Все Аренды Транспорта, Автосалоны, Мотосалоны, Авиасалоны, Салоны Катеров
     		for(new b = 42; b < 92; b++) ResetBizzPriceItem(playerid, b, v, 5, input);
		}
		else SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);
	}
	else if(dialogid == 1086)
	{
		if(response)
		{
			new vehicleList = OnlineInfo[playerid][oDialogMenu][3];
			new v = CorrectVehicleList(vehicleList);
			if(listitem == 0)
			{
				new line[100],lines[300];
				format(line,sizeof(line),"{cccccc}Введите гос. стоимость для {ff9000}%s", GetVehicleName(v)), strcat(lines,line);
				format(line,sizeof(line),"\n\n{cccccc}Текущая Стоимость: {99ff66}%d$ {cccccc}[%s]", VehGos[vehicleList], get_k(VehGos[vehicleList])), strcat(lines,line);
				format(line,sizeof(line),"\n{cccccc}Не меньше 1$ и не больше 900.000.000$"), strcat(lines,line);
				ShowDialog(playerid,1067,DIALOG_STYLE_INPUT,"Гос Стоимость Транспорта",lines,"Принять","Отмена");
			}
			else if(listitem == 1)
			{
				if(PlayerInfo[playerid][pSoska] < 20) return ErrorText(playerid, "{FF6347}Только для администраторов 20+ уровня"), SettingGosPriceVehicle(playerid, vehicleList);

				new line[100],lines[300];
				format(line,sizeof(line),"{cccccc}Введите Gold стоимость для {ff9000}%s", GetVehicleName(v)), strcat(lines,line);
				format(line,sizeof(line),"\n\n{cccccc}Текущая Стоимость: {ffcc00}%dG", VehGold[vehicleList]), strcat(lines,line);
				format(line,sizeof(line),"\n{cccccc}Не меньше 0G и не больше 100.000G"), strcat(lines,line);
				ShowDialog(playerid,1133,DIALOG_STYLE_INPUT,"Гос Стоимость Транспорта",lines,"Принять","Отмена");
			}
			else if(listitem == 2)
			{
				if(PlayerInfo[playerid][pSoska] < 20) return ErrorText(playerid, "{FF6347}Только для администраторов 20+ уровня"), SettingGosPriceVehicle(playerid, vehicleList);

				new line[100],lines[600];
				format(line,sizeof(line),"{cccccc}Введите лимитированность для {ff9000}%s", GetVehicleName(v)), strcat(lines,line);
				if(VehLimited[vehicleList] == 0) format(line,sizeof(line),"\n\n{cccccc}Текущее количество: {99ff66}Не ограничено"), strcat(lines,line);
				else format(line,sizeof(line),"\n\n{cccccc}Текущее количество: {D39EE0}%d", VehLimited[vehicleList]), strcat(lines,line);
				format(line,sizeof(line),"\n{cccccc}Не меньше 0 и не больше 100.000"), strcat(lines,line);
				format(line,sizeof(line),"\n\n{FF6347}Внимание! {ffcc66}Лимит влияет только на рандомное выпадение"), strcat(lines,line);
				format(line,sizeof(line),"\n{ffcc66}Примеры: Кейсы, Контейнеры"), strcat(lines,line);
				ShowDialog(playerid,1139,DIALOG_STYLE_INPUT,"Гос Стоимость Транспорта",lines,"Принять","Отмена");
			}
			else if(listitem == 3)
			{
				if(PlayerInfo[playerid][pSoska] < 20) return ErrorText(playerid, "{FF6347}Только для администраторов 20+ уровня"), SettingGosPriceVehicle(playerid, vehicleList);

				if(VehSale[vehicleList]) VehSale[vehicleList] = 0;
				else VehSale[vehicleList] = 1;
				SaveVehicleSale(vehicleList);
				SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);

				// Пересобираем подарки с транспортом
				CreateVehicleGiftCase();
			}
		}
		else vehprice(playerid, OnlineInfo[playerid][oDialogMenu][1]);
	}
	else if(dialogid == 1133)
	{
		if(response)
		{
			new vehicleList = OnlineInfo[playerid][oDialogMenu][3];
			if(PlayerInfo[playerid][pSoska] < 20) return ErrorText(playerid, "{FF6347}Только для администраторов 20+ уровня"), SettingGosPriceVehicle(playerid, vehicleList);
			new input = strval(inputtext);
			if(input < 0 || input > 100000) return ErrorText(playerid, "{FF6347}Не меньше 0G и не больше 100.000G"), SettingGosPriceVehicle(playerid, vehicleList);
			VehGold[vehicleList] = input;

			new v = CorrectVehicleList(vehicleList);
			PlayerPlaySound(playerid, 6401, 0,0,0);

			SaveVehicleGold(vehicleList);

			new string[180];
			format(string,sizeof(string),"[ Мысли ]: Gold стоимость %s теперь составляет: {ffcc00}%dG", GetVehicleName(v), VehGold[vehicleList]);
  			SendClientMessage(playerid,COLOR_GREY,string);
  			SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);

			format(string,sizeof(string),"%dG %s", input, GetVehicleName(v));
			AdminLog("vehgold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", v, string);
		}
		else SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);
	}
	else if(dialogid == 1139)
	{
		if(response)
		{
			new vehicleList = OnlineInfo[playerid][oDialogMenu][3];
			if(PlayerInfo[playerid][pSoska] < 20) return ErrorText(playerid, "{FF6347}Только для администраторов 20+ уровня"), SettingGosPriceVehicle(playerid, vehicleList);
			new input = strval(inputtext);
			if(input < 1 || input > 100000) return ErrorText(playerid, "{FF6347}Не меньше 0 и не больше 100.000"), SettingGosPriceVehicle(playerid, vehicleList);
			VehLimited[vehicleList] = input;

			new v = CorrectVehicleList(vehicleList);
			PlayerPlaySound(playerid, 6401, 0,0,0);

			SaveVehicleLimited(vehicleList);

			new string[180];
			format(string,sizeof(string),"[ Мысли ]: Limited Vehicle %s теперь составляет: {D39EE0}%d", GetVehicleName(v), VehLimited[vehicleList]);
  			SendClientMessage(playerid,COLOR_GREY,string);
  			SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);

			format(string,sizeof(string),"%d %s", input, GetVehicleName(v));
			AdminLog("vehlimited", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", v, string);

			// Пересобираем подарки с транспортом
			CreateVehicleGiftCase();
		}
		else SettingGosPriceVehicle(playerid, OnlineInfo[playerid][oDialogMenu][3]);
	}
	return 1;
}

// Подсчитываем транспорт на руках игроков
stock VehicleQuan(model, quan)
{
	new v = CorrectVehicleID(model);
	VehQuan[v] += quan;
	SaveVehicleQuan(v);
	return 1;
}

// Сохраняем стоимость транспорта в виртах
stock SaveVehiclePrice(v)
{
	new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehGos` = '%d' WHERE `model` = '%d'", VehGos[v], v);
	query_empty(pearsq, string_mysql);
	return 1;
}

// Сохраняем gold стоимость транспорта
stock SaveVehicleGold(v)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehGold` = '%d' WHERE `model` = '%d'", VehGold[v], v);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем количество покупок транспорта за вирты в салонах
stock SaveVehicleBuy(v)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehBuy` = '%d' WHERE `model` = '%d'", VehBuy[v], v);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем количество покупок транспорта за голду в салонах
stock SaveVehicleBuyGold(v)
{
	new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehBuyGold` = '%d' WHERE `model` = '%d'", VehBuyGold[v], v);
	query_empty(pearsq, string_mysql);
	return 1;
}

// Сохраняем лимитированное количествов транспорта
stock SaveVehicleLimited(v)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehLimited` = '%d' WHERE `model` = '%d'", VehLimited[v], v);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем количество экземпляров транспорта на руках игроков
stock SaveVehicleQuan(v)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehQuan` = '%d' WHERE `model` = '%d'", VehQuan[v], v);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем статус продажи транспорта
stock SaveVehicleSale(v)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehSale` = '%d' WHERE `model` = '%d'", VehSale[v], v);
	query_empty(pearsq, string_mysql);
    return 1;
}

// Сохраняем лимитированное количествов транспорта в кейсах (до тех пор, пока игрок не распакует)
stock SaveVehicleLimitedCase(v)
{
    new string_mysql[140];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "UPDATE `pp_priceveh` SET `VehLimitedCase` = '%d' WHERE `model` = '%d'", VehLimitedCase[v], v);
	query_empty(pearsq, string_mysql);
    return 1;
}


new bool:ReloadLimitedProcess; // Пауза на применение команды

alias:reloadlimited("rlimit", "rlimited", "rlimitveh", "rvehlimit", "rlimitedveh")
CMD:reloadlimited(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 9) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(ReloadLimitedProcess == true) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения пересчёта транспорта");

	new vehiclename[64];
	if(sscanf(params, "s[64]", vehiclename)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Пересчитать количество транспорта на руках [ /rlimit Model ]");
	new model = ReturnVehicle(vehiclename);
	if(model == -1) return ErrorMessage(playerid, "{FF6347}Неверный ID или название транспорта (400 - 612, 2000 и выше - кастомные авто)");
	if(!IsAVehExisting(model)) return ErrorMessage(playerid, "{FF6347}Неверный ID или название транспорта (400 - 612, 2000 и выше - кастомные авто)");

	ReloadLimitedVehicle(model); // Пересчитываем
	new string[140];
	format(string, sizeof(string), " [ ADM ]: %s пересчитал %s на руках игроков", PlayerInfo[playerid][pName], GetVehicleName(model));
	ABroadCast(COLOR_ADM,string,1);
	AdminLog("reloadlimited", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", model, "");
	return 1;
}

// Получаем количество лимитированных тачек
stock ReloadLimitedVehicle(model)
{
	new v = CorrectVehicleID(model); // Получаем слот в переменной

	ReloadLimitedProcess = true;
	new string_mysql[120];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT newid, model FROM `pp_cars` WHERE `model` = '%d'", model);
	mysql_tquery(pearsq, string_mysql, "Call_ReloadLimitedVehicle", "d", v);
	return 1;
}

function Call_ReloadLimitedVehicle(v)
{
	new rows;
	cache_get_row_count(rows);
	VehQuan[v] = rows;
	SaveVehicleQuan(v);

	VehLimitedCase[v] = 0;
	SaveVehicleLimitedCase(v);

	ReloadLimitedProcess = false;
	return 1;
}


alias:vehlimit("limitedveh", "limitedvehicle", "limitveh", "vehlimited")
CMD:vehlimit(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 9) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

	new vehiclename[64];
	if(sscanf(params, "s[64]", vehiclename)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Посмотреть список владельцев транспорта [ /vehlimit Model ]");
	new model = ReturnVehicle(vehiclename);
	if(model == -1) return ErrorMessage(playerid, "{FF6347}Неверный ID или название транспорта (400 - 612, 2000 и выше - кастомные авто)");
	if(!IsAVehExisting(model)) return ErrorMessage(playerid, "{FF6347}Неверный ID или название транспорта (400 - 612, 2000 и выше - кастомные авто)");

	new v = CorrectVehicleID(model);
	if(VehLimited[v] == 0) return ErrorMessage(playerid, "{FF6347}Это не лимитированный транспорт");

	new string_mysql[120];
	mysql_format(pearsq, string_mysql, sizeof(string_mysql), "SELECT sost FROM `pp_cars` WHERE `model` = '%d'", model);
	mysql_tquery(pearsq, string_mysql, "Call_CheckLimitedVehicle", "ddd", playerid, model, v);
	return 1;
}

function Call_CheckLimitedVehicle(playerid, model, v)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new user_id, line[214], lines[4096];
		format(line,sizeof(line),"{ff9000}%s {cccccc}[ Лимит: %d | На руках: %d ]\n", GetVehicleName(model), VehLimited[v], VehQuan[v]), strcat(lines,line);

		for(new i = 0; i < rows; i++)
		{
			cache_get_value_name_int(i, "sost", user_id);
			format(line,sizeof(line),"\n{cccccc}user_id: %d", user_id), strcat(lines,line);
		}
		ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{999999}*",lines,"*","");
	}
	else return ErrorMessage(playerid, "{FF6347}Этого транспорта нет на руках игроков");
	return 1;
}

alias:rvehcrime("vehcrime", "crimeveh", "rcrimeveh")
CMD:rvehcrime(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 9) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	
	new string_mysql[120];
	mysql_format(pearsq, string_mysql,sizeof(string_mysql),"UPDATE `pp_cars` SET `Sklad` = '0'");
	query_empty(pearsq, string_mysql);

	// Очищаем все угоны авто
	ReloadVehicleInCrime();

	new string[140];
	format(string, sizeof(string), " [ ADM ]: %s очистил весь транспорт из угона", PlayerInfo[playerid][pName]);
	ABroadCast(COLOR_ADM,string,1);
	AdminLog("rvehcrime", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
	return 1;
}



new PlayerText3D:CustomVehLabel[MAX_REALPLAYERS][SKOKOCAROV];
new bool:CustomLabelBusy[MAX_REALPLAYERS][SKOKOCAROV];

stock CreateCustomVehicleLabel(playerid, vehicleid, Float:dist)
{
	if(IsPlayerSyncModels(playerid)) return 1; // У игрока есть лаунчер
	if(CustomLabelBusy[playerid][vehicleid] == true) return 1;

	new string[100];
	format(string, sizeof(string), "{0088ff}%s\n{666666}Доступен с лаунчером", GetVehicleName(VehInfo[vehicleid][vModel]));
	CustomVehLabel[playerid][vehicleid] = CreatePlayer3DTextLabel(playerid, string, 0xA9C4E4FF, 0.0,0.0,0.0 + 0.2, dist, INVALID_PLAYER_ID, vehicleid, false);
	CustomLabelBusy[playerid][vehicleid] = true;
	return 1;
}

stock DestroyCustomVehicleLabel(playerid, vehicleid)
{
	if(IsPlayerSyncModels(playerid)) return 1; // У игрока есть лаунчер

	if(CustomLabelBusy[playerid][vehicleid] == true)
	{
		DeletePlayer3DTextLabel(playerid, CustomVehLabel[playerid][vehicleid]);
		CustomLabelBusy[playerid][vehicleid] = false;
	}
	return 1;
}

stock DestroyAllCustomVehicleLabels(playerid)
{
	for(new i = 0; i < SKOKOCAROV; i++)
	{
		if(CustomLabelBusy[playerid][i] == true)
		{
			DeletePlayer3DTextLabel(playerid, CustomVehLabel[playerid][i]);
			CustomLabelBusy[playerid][i] = false;
		}
	}
	return 1;
}

function LoadPriceVeh()
{
	new time = GetTickCount();
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new vehicleList;
		for(new v = 0; v < 211 + sizeof(vehNameCustom) + 1; v++)
		{
			cache_get_value_name_int(v, "model", vehicleList); // Получаем id для переменной

			cache_get_value_name_int(v, "VehGos", VehGos[vehicleList]);
			cache_get_value_name_int(v, "VehGold", VehGold[vehicleList]);
			cache_get_value_name_int(v, "VehBuy", VehBuy[vehicleList]);
			cache_get_value_name_int(v, "VehBuyGold", VehBuyGold[vehicleList]);
			cache_get_value_name_int(v, "VehLimited", VehLimited[vehicleList]);
			cache_get_value_name_int(v, "VehQuan", VehQuan[vehicleList]);
			cache_get_value_name_int(v, "VehSale", VehSale[vehicleList]);
			cache_get_value_name_int(v, "VehLimitedCase", VehLimitedCase[vehicleList]);

			// Если гос 0, сразу прописываем из дефолт цен
			if(VehGos[vehicleList] == 0)
			{
				if(v <= 211) VehGos[vehicleList] = vehSumma[vehicleList];
				else VehGos[vehicleList] = vehSummaCustom[vehicleList - 212];
			}

			// Пересчитываем лимитированный транспорт
			if(VehLimited[vehicleList] > 0)
			{
				if(VehLimitedCase[vehicleList] >= VehLimited[vehicleList] // Если лимитированный транспорт в кейсах больше или равняется лимиту транспорта
					&& VehQuan[vehicleList] < VehLimitedCase[vehicleList]) // Если количество на руках меньше чем количество в кейсах
				{
					VehLimitedCase[vehicleList] = 0;
				}
			}
		}

		// Собираем набор транспорта для кейсов
		new quanVehicleCase = CreateVehicleGiftCase();

		printf("[MODE]: Настройки Транспорта [В кейсах %d тс][%d ms]", quanVehicleCase, GetTickCount() - time);
	}
	return 1;
}

// Поиска id транспорта по названию
stock ReturnVehicle(const vehiclename[])
{
	new model = -1;

	// Если указан id, просто передаём id
	if(IsNumeric(vehiclename)) model = strval(vehiclename);
	else
	{
		// Ищем по названию среди обычного транспорта
		for(new i = 0; i < sizeof(vehName); i++)
		{
			if(strfind(vehName[i], vehiclename, true) != -1)
			{
				model = i + 400;
				break;
			}
		}

		// Ищем по названию среди кастомного транспорта
		if(model == -1)
		{
			for(new i = 0; i < sizeof(vehNameCustom); i++)
			{
				if(strfind(vehNameCustom[i], vehiclename, true) != -1)
				{
					model = i + 2000;
					break;
				}
			}
		}
	}
    return model;
}

// Замки транспорта, которые невозможно взломать отмычками и требуется бомба липучка
stock IsAHardLockVeicle(model)
{
	if(model == 428) return 1;
	return 0;
}

// Транспорт, в котором не нужно оповещать о том, что в нём не сохраняются предметы в багажнике
stock IsNoMessageVehicle(vehicleid)
{
	if(vehicleid == collectorveh) return 1;
	return 0;
}

CMD:rvehquan(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 25) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

	mysql_tquery(pearsq, "START TRANSACTION;");
	for(new v = 0; v < 211 + sizeof(vehNameCustom) + 1; v++)
	{
		if(VehBuy[v] > 0) 
		{
			VehBuy[v] = 0;
			SaveVehicleBuy(v);
		}

		if(VehBuyGold[v] > 0) 
		{
			VehBuyGold[v] = 0;
			SaveVehicleBuyGold(v);
		}

		if(VehQuan[v] > 0) 
		{
			VehQuan[v] = 0;
			SaveVehicleQuan(v);
		}

		if(VehLimitedCase[v] > 0) 
		{
			VehLimitedCase[v] = 0;
			SaveVehicleLimitedCase(v);
		}
	}

	mysql_tquery(pearsq, "COMMIT;");

	new string[144];
	format(string, sizeof(string), " [ ADM ]: %s сбросил подсчёт всех тс на руках (VehBuy, VehBuyGold, VehQuan, VehLimitedCase)", PlayerInfo[playerid][pName]);
 	ABroadCast(COLOR_ADM,string,1);
	AdminLog("rvehquan", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
	return 1;
}

CMD:vgall(playerid, const params[]) return pc_cmd_vehgoldall(playerid, params);
CMD:vehgoldall(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 22) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

	if(sscanf(params, "ii",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить gold стоимость всех тс [ /vehgoldall Курс ]");
	if(params[0] > 10000 || params[0] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Курс не меньше 1 и не больше 10.000");

	mysql_tquery(pearsq, "START TRANSACTION;");
	for(new v = 0; v < 211 + sizeof(vehNameCustom) + 1; v++)
	{
		if(VehGos[v] > 0) 
		{
			VehGold[v] = VehGos[v]/params[0];
			SaveVehicleGold(v);
		}
	}
	mysql_tquery(pearsq, "COMMIT;");

	new string[144];
	format(string, sizeof(string), " [ ADM ]: %s изменил gold стоимости всех тс по курсу %d$", PlayerInfo[playerid][pName], params[0]);
 	ABroadCast(COLOR_ADM,string,1);
	AdminLog("vehgoldall", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "Gold цена тс");
	return 1;
}

stock PPAddVehicleComponent(vehicleid, component)
{
	if(VehInfo[vehicleid][vModel] >= 2000) // Если кастомная
	{
		if(component != 1010  // Азот
			&& component != 1087 // Гидравлика
			&& !IsAWheels(component)) // Диски
		{
			return false;
		}
	}
	return AddVehicleComponent(vehicleid, component);
}

#if defined _ALS_AddVehicleComponent
    #undef AddVehicleComponent
#else
    #define _ALS_AddVehicleComponent
#endif
#define AddVehicleComponent PPAddVehicleComponent

// Диски на транспорт
stock IsAWheels(component)
{
	if(component == 1025 || component >= 1073 && component <= 1085 
		|| component == 1096 || component == 1097 || component == 1098) return 1;
	return 0;
}

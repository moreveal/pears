// last update 04.11.2024 zver
/*
Как добавить новый тс?
1. Добавляем в define MAX_VEHICLE_CUSTOM (в целом, там сейчас с запасом до 200 кастомных авто)
2. Добавляем имя транспорта в vehNameCustom[
3. Добавляем гос стоимость в vehSummaCustom[
4. Добавляем в AddCustomVehicle заменку и следующий id (Внимание! От заменки зависит расположение двигателя, количество дверей и наличие багажника)
5. Добавляем в IsAVehExisting новую цифру для создания транспорта
6. stock GetVehicleClass - класс авто
*/

#define MAX_VEHICLE_CUSTOM 200 // Кастомный транспорт

new vehNameCustom[][] =
{
    "Lamborghini Murcielago", // 2000
    "BMW E36 328i", // 2001
    "BMW M4 G82", // 2002
    "Mercedes-Benz S63", // 2003
    "Acura Integra", // 2004
    "Hummer H2", // 2005
    "Nissan GT-R R35 RB", // 2006
	"Subaru Impreza WRX STi", // 2007
    "Skoda Octavia", // 2008
    "Mercedes-Benz C63", // 2009
    "Nissan 350Z", // 2010
    "Audi RSQ8", // 2011
    "BMW 530i", // 2012
    "BMW M635 CSI E24",// 2013
	"Mercedes-Benz G63 B800", // 2014
    "Ford Raptor", // 2015
    "Audi RS5", // 2016
    "BMW 325i E30", // 2017
    "BMW X6M", // 2018
    "Volkswagen Golf", // 2019
    "Cadillac Fleetwood", // 2020
    "BMW 750il E38",// 2021
	"Dodge Super Bee", // 2022
    "Ford GT", // 2023
    "Lamborghini Centenario", // 2024
    "Mercedes-Benz W124", // 2025
    "Mercedes-Benz SL 65", // 2026
    "Nissan 240SX", // 2027
    "Porsche 911 GT2",// 2028
	"Shelby GT 500", // 2029
    "Toyota Supra MK5", // 2030
    "Toyota AE86", // 2031
    "Prison Bus", // 2032
    "Mercedes-Benz AMG GT63", // 2033
    "Bentley Mulliner Bacalar", // 2034
    "BMW 325I E30",// 2035
	"Arm Cargo", // 2036
    "Ford Raptor", // 2037
    "Dodge Charger Police", // 2038
    "Dodge Charger Dep", // 2039
    "Enforcer SWAT", // 2040
    "Truck SWAT", // 2041
    "F1 Ferrari",// 2042
	"Ford Crown Victoria", // 2043
    "Ford Crown Victoria Dep", // 2044
    "Ford Expedition", // 2045
    "Ford Explorer Dep", // 2046
    "Ford Explorer Police", // 2047
    "Ford Focus ST", // 2048
    "Nissan Silvia S13", // 2049
	"Jeep Wrangler", // 2050
    "Lexus LS400", // 2051
    "Lexus RCF", // 2052
    "Mazda RX7", // 2053
    "Audi RS6 C5", // 2054
    "Mercedes-Benz Sprinter", // 2055
    "Ferrari Enzo",// 2056
	"Mercedes-Benz E63", // 2057
    "Mitsubishi Eclipse", // 2058
    "Nissan Silvia S14", // 2059
    "Hummer H1 Army", // 2060
    "Plymouth Hemi", // 2061
    "Toyota Camry Taxi", // 2062
    "Vaz 2106", // 2063
    "Vaz 2105",// 2064
	"Volkswagen Golf R32", // 2065
    "BMW G11", // 2066
    "Toyota Chaser JZX100", // 2067
    "BMW M5 F90", // 2068
    "Audi R8", // 2069
    "Rolls-Royce Wraith", // 2070
    "Rolls-Royce Cullinan", // 2071
    "Pagani Zonda",// 2072
	"Audi RS3", // 2073
    "Nissan GT-R R34", // 2074
    "Silvia S15", // 2075
    "Nissan GT-R R35", // 2076
    "Charger RT 69", // 2077
    "Mars Rover", // 2078
    "Mars Rider", // 2079
    "Mars RC Car", // 2080
    "Ingenuity",// 2081
	"Peugeot 406", // 2082
    "Alfa-Romeo 159 Ti", // 2083
    "Aston-Martin DB11", // 2084
    "Chevrolet Corvette C6 ZR1", // 2085
    "Tesla Model X P100D", // 2086
    "Bugatti Chiron", // 2087
	"Porsche 911 JS Edition", // 2088
    "Bentley Turbo R 1991", // 2089
    "Chevrolet Express", // 2090
    "Ford Econoline Pack", // 2091
    "Audi RS7 2014", // 2092
    "Bentley Continental GT",// 2093
	"Chevrolet Tahoe", // 2094
    "SA Bus", // 2095
    "Paramedic", // 2096
    "Mercedes-Benz CLS 63 AMG", // 2097
    "Bugatti Divo", // 2098
    "Toyota Chaser BN Sports", // 2099
    "SAPD Helicopter", // 2100
    "MH-6 Little Bird", // 2101
    "FBI Helicopter", // 2102
    "McLaren 720s Spider", // 2103
    "Lamborghini Miura P400 SV", // 2104
    "Lamborghini Gallardo Superleggera", // 2105
    "Ferrari 348", // 2106
    "Jeep Cherokee 1984 Sand Edition", // 2107
    "Mercedes-Benz CLS 63 AMG Police", // 2108
    "Volvo Polestar One", // 2109
    "Mazda RX7 Tune body", // 2110
    "Dodge Viper", // 2111
    "BMW M5 E60", // 2112
    "BMW M8 Competition Gran Coupe", // 2113
    "Chevrolet Camaro ZL1", // 2114
    "Motorcycle Kawasaki", // 2115
    "Lamborghini Aventador", // 2116
    "BMW X5M", // 2117
    "BMW X7M", // 2118
    "Toyota Land Cruiser 200", // 2119
    "VAZ 2101 Drift", // 2120
    "Audi RS7 2022", // 2121
    "MRAP", // 2122
    "Ford Mustang GT 2015", // 2123
    "Газ-21 Волга", // 2124
    "DeLorean DMC-12", // 2125
    "Газ-24 Волга", // 2126
    "BMW M5 F90 UNMARKED", // 2127
    "BMW M5 Competition Sport", // 2128
    "SA News Helicopter", // 2129
    "Robinson R44", // 2130
    "Buckingham SuperVolito Carbon", // 2131
    "Bell UH-1 Iroquois", // 2132
    "Buckingham Volatus", // 2133
    "Mercedes-Benz Maybach S650", // 2134
    "Cadillac Escalade SA News", // 2135
    "Audi E-Tron GT", // 2136
    "BMW i7", // 2137
    "Ford Mustang E-Tech", // 2138
    "Porsche Taycan Turbo S", // 2139
    "Tesla Cybertruck Police", // 2140
    "Tesla Cybertruck", // 2141
    "Tesla Model S", // 2142
    "Tesla Model 3", // 2143
    "Ducati Corse", // 2144
    "Harley Davidson 1986", // 2145
    "Honda CBR 1000RR", // 2146
    "NRG 600 Racing", // 2147
    "Pegassi Bati 901s", // 2148
    "Pegassi Ruffian", // 2149
    "Suzuki GSX-R 1000", // 2150
    "Ford GT Police Highway Patrol", // 2151
    "Dodge Challenger Hellcat", // 2152
    "Rolls-Royce Phantom", // 2153
    "1959 Chevrolet Impala", // 2154
    "1996 Chevrolet Impala SS", // 2155
    "1976 Ford Gran Torino", // 2156
    "Bravado Antares", // 2157
    "Canis Seminole Frontier", // 2158
    "1982 Mercury Cougar", // 2159
    "Chevrolet Corvette C3", // 2160
    "Cadillac CTS-V", // 2161
    "Cadillac Fleetwood Hearse", // 2162
    "Albany Lurcher", // 2163
    "Cadillac Escalade Army", // 2164
    "BMW M3 Competition", // 2165
    "BMW M3 G81", // 2166
    "Cadillac XT6-V", // 2167
    "Dodge Ram", // 2168
    "Ford Raptor", // 2169
    "Jeep Grand Cherokee SRT 12", // 2170
    "Ferrari LaFerrari", // 2171
    "Daewoo Matiz", // 2172
    "Mercedes Benz W140", // 2173
    "Range Rover Sport", // 2174
    "Volvo XC90" // 2175
    };

new vehSummaCustom[] = // Гос цены на авто (Дефолтные) Кастомный транспорт
{
    19000000, // Lamba Murcielago // 2000
    900000, // BMW E36 328i // 2001
    10000000, // BMW M4 G82 // 2002
    11000000, // Mercedes S63 // 2003
    400000, // Acura Integra // 2004
    3500000, // Hummer H2 // 2005
    12000000, // Nissan GT-R R35 RB // 2006
    2500000, // Impreza WRX STi // 2007
    1100000, // Skoda Octavia // 2008
    2800000, // Mercedes C63 // 2009
	1400000, // Nissan 350Z // 2010
    5000000, // Audi Q7 // 2011
    3000000, // BMW 530i // 2012
    500000, // BMW M635CSI E24 // 2013
    9000000, // Mercedes G63 B800 // 2014
    4200000, // Ford Raptor // 2015
    10000000, // Audi RS5 // 2016
    600000, // BMW 325i E30 // 2017
    4500000, // BMW X6M // 2018
    400000, // Volkswagen Golf // 2019
	2500000, // Cadillac Fleetwood // 2020
    950000, // BMW 750il E38 // 2021
    7000000, // Dodge Super Bee // 2022
    4000000, // Ford GT // 2023
    60000000, // Lamba Centenario // 2024
    6000000, // Mercedes W124 // 2025
    7000000, // Mercedes SL 65 // 2026
    1300000, // Nissan 240SX // 2027
    3000000, // Porsche 911 GT2// 2028
    3200000, // Shelby GT 500 // 2029
	5000000, // Toyota Supra MK5 // 2030
    1200000, // Toyota AE86 // 2031
    1300000, // Prison Bus // 2032
    15000000, // Mercedes AMG GT63 // 2033
    24000000, // Bentley Mulliner Bacalar // 2034
    1500000, // BMW 325I E30 // 2035
	31000000, // Arm Cargo // 2036
    4200000, // Ford Raptor // 2037
    5000000, // Charger Police // 2038
    5000000, // Charger Dep // 2039
    4500000, // Enforcer SWAT // 2040
    4000000, // Truck SWAT // 2041
    300000000, // F1 Ferrari // 2042
	1200000, // Ford Crown Victoria // 2043
    1200000, // Ford Crown Victoria Dep // 2044
    7000000, // Expedition // 2045
    3500000, // Explorer Dep // 2046
    3500000, // Explorer Police // 2047
    500000, // Ford Focus ST // 2048
    1200000, // Silvia S13 // 2049
	3000000, // Jeep Wrangler // 2050
    900000, // Lexus LS400 // 2051
    4700000, // Lexus RCF // 2052
    700000, // Mazda RX7 // 2053
    1200000, // Audi RS6 C5 // 2054
    17000000, // Mercedes Sprinter // 2055
    70000000, // Ferrari Enzo // 2056
	11000000, // Mercedes E63 // 2057
    1800000, // Mitsubishi Eclipse // 2058
    2100000, // Nissan Silvia S14 // 2059
    9000000, // Hummer H1 // 2060
    6000000, // Plymouth Hemi // 2061
    2900000, // Toyota Camry Taxi // 2062
    500000, // Vaz 2106 // 2063
    500000, // Vaz 2105 // 2064
	300000,  // Volkswagen Golf R32 // 2065
    5500000,  // BMW G11 // 2066
    750000,  // Toyota Chaser JZX100 // 2067
    15000000,  // BMW M5 F90 // 2068
    7000000,  // Audi R8 // 2069
    28000000,  // Rolls-Royce Wraith // 2070
    32000000,  // Rolls-Royce Cullinan // 2071
    70000000, // Pagani Zonda // 2072
	3200000,  // Audi RS3 // 2073
    2900000,  // Nissan GT-R R34 // 2074
    2500000,  // Silvia S15 // 2075
    5200000,  // Nissan GT-R R35 // 2076
    1300000, // Charger RT 69 // 2077
    200000000, // Mars Rover // 2078
    200000000, // Mars Rider // 2079
    200000000, // Mars RC Car // 2080
    200000000, // Ingenuity // 2081
    45000000, // Peugeot 406 2003 // 2082
	1400000, // Alfa-Romeo 159 Ti // 2083
    15000000, // Aston-Martin DB11 // 2084
    6000000, // Chevrolet Corvette C6 ZR1 // 2085
    30000000, // Tesla Model X P100D // 2086
    90000000, // Chiron // 2087
    40000000, // Porsche 911 JS Edition // 2088
    20000000, // Bentley Turbo R 1991 // 2089
    1000000, // Chevrolet Express // 2090
    1000000, // Ford Econoline Pack // 2091
    11000000, // Audi RS7 // 2092
    40000000, // Bentley Continental GT// 2093
	1000000, // Chevrolet Tahoe // 2094
    4000000, // Sa Bus // 2095
    5000000, // Paramedic // 2096
    10000000, // Mercedes-Benz CLS 63 AMG // 2097
    100000000, // Bugatti Divo // 2098
    1500000, // Toyota Chaser BN Sports // 2099
    50000000, // SAPD Helicopter // 2100
    50000000, // MH-6 Little Bird // 2101
    50000000, // FBI Helicopter // 2102
    30000000, // McLaren 720s Spider // 2103
    22000000, // Lamborghini Miura P400 SV // 2104
    25000000, // Lamborghini Gallardo Superleggera // 2105
    20000000, // Ferrari 348 // 2106
    3000000, // Jeep Cherokee 1984 Sand Edition // 2107
    10000000, // Mercedes-Benz CLS 63 AMG Police // 2108
    4000000, // Volvo Polestar One // 2109
    2500000, // Mazda RX7 Tune body // 2110
    13000000, // Dodge Viper // 2111
    5000000, // "BMW M5 E60", // 2112
    12000000, // "BMW M8 Competition Gran Coupe", // 2113
    5000000, // "Chevrolet Camaro ZL1", // 2114
    1500000, // "Motorcycle Kawasaki" // 2115
    45000000, // Lamborghini Aventador", // 2116
    4000000, // BMW X5M", // 2117
    9000000, // BMW X7M", // 2118
    6000000, // Toyota Land Cruiser 200", // 2119
    40000000, // VAZ 2101 Drift", // 2120
    12000000, // "Audi RS7", // 2121
    400000000, // "MRAP" // 2122
    5600000, // "Ford Mustang GT 2015" // 2123
    20000000, // "Газ-21 Волга" // 2124
    20000000, // "DeLorean DMC-12" // 2125
    20000000, // "Газ-24 Волга" // 2126
    20000000, // "BMW M5 F90 UNMARKED", // 2127
    20000000, // "BMW M5 Competition Sport // 2128
    70000000, // "SA News Helicopter", // 2129
    50000000, // "Robinson R44", // 2130
    60000000, // "Buckingham SuperVolito Carbon", // 2131
    70000000, // "Bell UH-1 Iroquois", // 2132
    70000000, // "Buckingham Volatus" // 2133
    15000000, // "Mercedes-Benz Maybach S650" // 2134
    15000000, // "Cadillac Escalade SA News" // 2135
    10000000, // "Audi E-Tron GT", // 2136
    17000000, // "BMW i7", // 2137
    7000000, // "Ford Mustang E-Tech", // 2138
    14000000, // "Porsche Taycan Turbo S", // 2139
    50000000, // "Tesla Cybertruck Police", // 2140
    24000000, // "Tesla Cybertruck", // 2141
    10000000, // "Tesla Model S", // 2142
    5000000, // "Tesla Model 3" // 2143
    1500000, // "Ducati Corse", // 2144
    800000, // "Harley Davidson 1986", // 2145
    3000000, // "Honda CBR 1000RR", // 2146
    2000000, // "NRG 600 Racing", // 2147
    2300000, // "Pegassi Bati 901s", // 2148
    2200000, // "Pegassi Ruffian", // 2149
    2800000, // "Suzuki GSX-R 1000", // 2150
    50000000, // "Ford GT Police Highway Patrol" // 2151
    6600000, // "Dodge Challenger Hellcat", // 2152
    37000000, // "Rolls-Royce Phantom" // 2153
    2000000, // "1959 Chevrolet Impala", // 2154
    2500000, // "1996 Chevrolet Impala SS", // 2155
    2000000, // "1976 Ford Gran Torino", // 2156
    2300000, // "Bravado Antares", // 2157
    1800000, // "Canis Seminole Frontier", // 2158
    10000000, // "1982 Mercury Cougar", // 2159
    10000000, // "Chevrolet Corvette C3", // 2160
    10000000, // "Cadillac CTS-V" // 2161
    10000000, // "Cadillac Fleetwood Hearse", // 2162
    10000000, // "Albany Lurcher" // 2163
    20000000, // "Cadillac Escalade SA Army" // 2164
    9000000, // "BMW M3 Competition", //2165
    9000000, // "BMW M3 G81", // 2166
    7000000, // "Cadillac XT6-V", // 216
    7300000, // "Dodge Ram", // 2168
    7400000, // "Ford Raptor", // 2169
    6000000, // "Jeep Grand Cherokee SRT 12 2170
    60000000, // "Ferrari LaFerrari", // 2171
    800000, // "Daewoo Matiz", // 2172
    1000000, // "Mercedes Benz W140", // 2173
    7500000, // "Range Rover Sport", // 2174
    5000000, // "Volvo XC90" // 2175
};

stock AddCustomVehicle() // Добавляем тс на карту
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
	AddVehicleSyncModel(533, 2034); // Bentley Mulliner Bacalar (Feltzer)
	AddVehicleSyncModel(502, 2035); // BMW 325i E30	(Hotring Racer A)
	AddVehicleSyncModel(487, 2036); // Arm Cargo (Maverick)
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
	AddVehicleSyncModel(589, 2065); // VW Golf R32 (Club)
	AddVehicleSyncModel(560, 2066); // BMW G11
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
	AddVehicleSyncModel(551, 2083); // Alfa-Romeo 159 Ti
	AddVehicleSyncModel(402, 2084); // Aston-Martin DB11
	AddVehicleSyncModel(402, 2085); // Chevrolet Corvette C6 ZR1
	AddVehicleSyncModel(560, 2086); // Tesla Model X P100D
	AddVehicleSyncModel(415, 2087); // Chiron
	AddVehicleSyncModel(477, 2088); // Porsche 911 JS Edition
	AddVehicleSyncModel(580, 2089); // Bentley Turbo R 1991
	AddVehicleSyncModel(413, 2090); // Chevrolet Express
	AddVehicleSyncModel(482, 2091); // Ford Econoline Pack
	AddVehicleSyncModel(405, 2092); // Audi RS7 2014
	AddVehicleSyncModel(602, 2093); // Bentley Continental GT
	AddVehicleSyncModel(579, 2094); // Chevrolet Tahoe
	AddVehicleSyncModel(431, 2095); // Sa Bus (Bus)
	AddVehicleSyncModel(416, 2096); // Paramedic
    AddVehicleSyncModel(560, 2097); // Mercedes-Benz CLS 63 AMG // 2097
    AddVehicleSyncModel(541, 2098); // Bugatti Divo // 2098
    AddVehicleSyncModel(551, 2099); // Toyota Chaser BN Sports // 2099
    AddVehicleSyncModel(497, 2100); // SAPD Helicopter // 2100
    AddVehicleSyncModel(487, 2101); // MH-6 Little Bird // 2101
    AddVehicleSyncModel(497, 2102); // FBI Helicopter // 2102
    AddVehicleSyncModel(541, 2103); // McLaren 720s Spider // 2103
    AddVehicleSyncModel(541, 2104); // Lamborghini Miura P400 SV // 2104
    AddVehicleSyncModel(411, 2105); // Lamborghini Gallardo Superleggera // 2105
    AddVehicleSyncModel(415, 2106); // Ferrari 348 // 2106
    AddVehicleSyncModel(495, 2107); // Jeep Cherokee 1984 Sand Edition // 2107
    AddVehicleSyncModel(596, 2108); // Mercedes-Benz CLS 63 AMG Police // 2108
    AddVehicleSyncModel(559, 2109); // Volvo Polestar One // 2109
    AddVehicleSyncModel(558, 2110); // Mazda RX7 Tune body // 2110
    AddVehicleSyncModel(429, 2111); // Dodge Viper // 2111
    AddVehicleSyncModel(560, 2112); // "BMW M5 E60", // 2112
    AddVehicleSyncModel(560, 2113); // "BMW M8 Competition Gran Coupe", // 2113
    AddVehicleSyncModel(402, 2114); // "Chevrolet Camaro ZL1", // 2114
    AddVehicleSyncModel(521, 2115); // "Motorcycle Kawasaki" // 2115
    AddVehicleSyncModel(415, 2116); // Lamborghini Aventador", // 2116
    AddVehicleSyncModel(579, 2117); // BMW X5m", // 2117
    AddVehicleSyncModel(579, 2118); // BMW X7m", // 2118
    AddVehicleSyncModel(579, 2119); // Toyota Land Cruiser 200", // 2119
    AddVehicleSyncModel(562, 2120); // VAZ 2101 Drift" // 2120
    AddVehicleSyncModel(560, 2121); // "Audi RS7 2022", // 2121
    AddVehicleSyncModel(427, 2122); // "MRAP" // 2122
    AddVehicleSyncModel(602, 2123); // "Ford Mustang GT 2015" // 2123
    AddVehicleSyncModel(421, 2124); // "Газ-21 Волга" // 2124
    AddVehicleSyncModel(415, 2125); // "DeLorean DMC-12" // 2125
    AddVehicleSyncModel(566, 2126); // "Газ-24 Волга" // 2126
    AddVehicleSyncModel(560, 2127); // "BMW M5 F90 UNMARKED" // 2127
    AddVehicleSyncModel(560, 2128); // "BMW M5 Competition Sport // 2128
    AddVehicleSyncModel(488, 2129); // "SA News Helicopter", // 2129
    AddVehicleSyncModel(487, 2130); // "Robinson R44", // 2130
    AddVehicleSyncModel(487, 2131); // "Buckingham SuperVolito Carbon", // 2131
    AddVehicleSyncModel(487, 2132); // "Bell UH-1 Iroquois", // 2132
    AddVehicleSyncModel(487, 2133); // "Buckingham Volatus" // 2133
    AddVehicleSyncModel(580, 2134); // "Mercedes-Benz Maybach S650" // 2134
    AddVehicleSyncModel(579, 2135); // "Cadillac Escalade SA News" // 2135
    AddVehicleSyncModel(560, 2136); // "Audi E-Tron GT", // 2136
    AddVehicleSyncModel(580, 2137); // "BMW i7", // 2137
    AddVehicleSyncModel(579, 2138); // "Ford Mustang E-Tech", // 2138
    AddVehicleSyncModel(560, 2139); // "Porsche Taycan Turbo S", // 2139
    AddVehicleSyncModel(579, 2140); // "Tesla Cybertruck Police", // 2140
    AddVehicleSyncModel(579, 2141); // "Tesla Cybertruck", // 2141
    AddVehicleSyncModel(551, 2142); // "Tesla Model S", // 2142
    AddVehicleSyncModel(551, 2143); // "Tesla Model 3" // 2143
    AddVehicleSyncModel(522, 2144); // "Ducati Corse", // 2144
    AddVehicleSyncModel(463, 2145); // "Harley Davidson 1986", // 2145
    AddVehicleSyncModel(522, 2146); // "Honda CBR 1000RR", // 2146
    AddVehicleSyncModel(521, 2147); // "NRG 600 Racing", // 2147
    AddVehicleSyncModel(521, 2148); // "Pegassi Bati 901s", // 2148
    AddVehicleSyncModel(521, 2149); // "Pegassi Ruffian", // 2149
    AddVehicleSyncModel(581, 2150); // "Suzuki GSX-R 1000", // 2150
    AddVehicleSyncModel(541, 2151); // "Ford GT Police Highway Patrol" // 2151
    AddVehicleSyncModel(402, 2152); // "Dodge Challenger Hellcat", // 2152
    AddVehicleSyncModel(580, 2153); // "Rolls-Royce Phantom" // 2153
    AddVehicleSyncModel(412, 2154); // "1959 Chevrolet Impala", // 2154
    AddVehicleSyncModel(426, 2155); // "1996 Chevrolet Impala SS", // 2155
    AddVehicleSyncModel(491, 2156); // "1976 Ford Gran Torino", // 2156
    AddVehicleSyncModel(603, 2157); // "Bravado Antares", // 2157
    AddVehicleSyncModel(579, 2158); // "Canis Seminole Frontier", // 2158
    AddVehicleSyncModel(507, 2159); // "1982 Mercury Cougar", // 2159
    AddVehicleSyncModel(603, 2160); // "Chevrolet Corvette C3", // 2160
    AddVehicleSyncModel(560, 2161); // "Cadillac CTS-V" // 2161
    AddVehicleSyncModel(442, 2162); // "Cadillac Fleetwood Hearse", // 2162
    AddVehicleSyncModel(442, 2163); // "Albany Lurcher" // 2163
    AddVehicleSyncModel(579, 2164); // "Cadillac Escalade Army" // 2164
    AddVehicleSyncModel(560, 2165); // "BMW M3 Competition", // 2165
    AddVehicleSyncModel(560, 2166); // "BMW M3 G81", // 2166
    AddVehicleSyncModel(579, 2167); // "Cadillac XT6-V", // 2167
    AddVehicleSyncModel(470, 2168); // "Dodge Ram", // 2168
    AddVehicleSyncModel(554, 2169); // "Ford Raptor", // 2169
    AddVehicleSyncModel(579, 2170); // "Jeep Grand Cherokee SRT 12", // 2170
    AddVehicleSyncModel(451, 2171); // "Ferrari LaFerrari", // 2171
    AddVehicleSyncModel(405, 2172); // "Daewoo Matiz", // 2172
    AddVehicleSyncModel(560, 2173); // "Mercedes Benz W140", // 2173
    AddVehicleSyncModel(579, 2174); // "Range Rover Sport", // 2174
    AddVehicleSyncModel(579, 2175); // "Volvo XC90" // 2175
    return 1;
}

// Проверка на доступный транспорт
stock IsAVehExisting(v)
{
    if(v >= 400 && v <= 611 // Стандартный транспорт gta

    || v >= 2000 && v <= 2175) return 1; // Кастомный транспорт пирса

	if(v == 537 || v == 538) return 0; // Поезд создавать через /veh нельзя
    return 0;
}


stock GetVehicleClass(m)
{
    new class;

    // Premium Class (1) - Премиум

    if(m == 402 || m == 409 || m == 411 || m == 415 || m == 429 || m == 446 || m == 451 || m == 454 || m == 477 || m == 493 
    || m == 494 || m == 502 || m == 503 || m == 506 || m == 519 || m == 521 || m == 522 || m == 535 || m == 541 || m == 559
    || m == 560 || m == 562 || m == 565 || m == 580 || m == 586
	|| m == 2000 || m == 2002 || m == 2003 || m == 2020 || m == 2022 || m == 2023 || m == 2024 || m == 2033 || m == 2034
	|| m == 2052 || m == 2057 || m == 2056 || m == 2066 || m == 2068 || m == 2069 || m == 2070 || m == 2072
	|| m == 2084 || m == 2085 || m == 2086 || m == 2087 || m == 2089 || m == 2092 || m == 2093 || m == 2098 || m == 2103
    || m == 2105 || m == 2111 || m == 2113 || m == 2116 || m == 2131 || m == 2133 || m == 2136 || m == 2137 || m == 2139
    || m == 2146 || m == 2150 || m == 2171) class = 1;

    // Middle Class (2) - Средний
    else if(m == 401 || m == 405 || m == 418 || m == 419 || m == 421 || m == 426 || m == 439 || m == 445 || m == 452 || m == 460
    || m == 461 || m == 463 || m == 468 || m == 469 || m == 471 || m == 480 || m == 484 || m == 487 || m == 491 || m == 496
    || m == 507 || m == 511 || m == 516 || m == 533 || m == 534 || m == 550 || m == 551 || m == 555 || m == 558 || m == 561
    || m == 581 || m == 585 || m == 587 || m == 589 || m == 602 || m == 603
	|| m == 2001 || m == 2006 || m == 2007 || m == 2008 || m == 2009 || m == 2010 || m == 2012 || m == 2016
	|| m == 2026 || m == 2027 || m == 2028 || m == 2029 || m == 2030 || m == 2039 || m == 2049 
	|| m == 2073 || m == 2076 || m == 2083 || m == 2097 || m == 2109 || m == 2112 || m == 2114 || m == 2115 || m == 2121
    || m == 2123 || m == 2130 || m == 2138 || m == 2141 || m == 2142 || m == 2144 || m == 2152  || m == 2165
    || m == 2166 || m == 2173) class = 2;

    // Economy Class (3) - Бомж
    else if(m == 404 || m == 410 || m == 412 || m == 436 || m == 453 || m == 458 || m == 462 || m == 466 || m == 467 || m == 472
    || m == 474 || m == 475 || m == 479 || m == 492 || m == 512 || m == 513 || m == 517 || m == 518 || m == 526 || m == 527
    || m == 529 || m == 536 || m == 540 || m == 542 || m == 546 || m == 547 || m == 549 || m == 553 || m == 566 || m == 567
    || m == 575 || m == 576 || m == 593 || m == 595 || m == 600
	|| m == 2004 || m == 2019 || m == 2021 || m == 2031 || m == 2043 || m == 2048 || m == 2051 || m == 2053 || m == 2059 || m == 2061
	|| m == 2065 || m == 2013 || m == 2017 || m == 2025 || m == 2054 || m == 2067 || m == 2074 || m == 2075 || m == 2077
	|| m == 2082 || m == 2099 || m == 2110 || m == 2143 || m == 2145 || m == 2147 || m == 2148 || m == 2149
    || m == 2154 || m == 2155 || m == 2156 || m == 2157 || m == 2158 || m == 2172) class = 3;

    // Off-Road Class (4) - Внедорожник
    else if(m == 400 || m == 422 || m == 489 || m == 495 || m == 500 || m == 543 || m == 554 || m == 579
	|| m == 2005 || m == 2011 || m == 2014 || m == 2015 || m == 2050 || m == 2094 || m == 2107 || m == 2018
    || m == 2071 || m == 2117 || m == 2118 || m == 2119 || m == 2167 || m == 2168 || m == 2169 || m == 2170 || m == 2174
    || m == 2175) class = 4;

    // Special Class (5) - Грузовая и Спец Техника
    else if(m == 403 || m == 413 || m == 414 || m == 417 || m == 440 || m == 455 || m == 456
    || m == 459 || m == 478 || m == 482 || m == 498 || m == 499 || m == 508 || m == 514 || m == 515 || m == 578
	|| m == 2055 || m == 2090 || m == 2091) class = 5;

    // Unique Class (6) - Уникальный Транспорт
    else if(m == 423 || m == 424 || m == 431 || m == 434 || m == 437 || m == 442 || m == 443 || m == 444 || m == 457 || m == 473 
    || m == 476 || m == 481 || m == 483
    || m == 504 || m == 509 || m == 510 || m == 530 || m == 531 || m == 532 || m == 545 || m == 556 || m == 557 || m == 571 
    || m == 573 || m == 577 || m == 588 || m == 592 || m == 2035 || m == 2042 || m == 2058 || m == 2062
	|| m == 2095 || m == 2125) class = 6;

    // Goverment Class (7) - Государственный Транспорт
    else if(m == 406 || m == 407 || m == 408 || m == 416 || m == 420 || m == 425 || m == 427 || m == 428 || m == 430 || m == 432 
    || m == 438 || m == 447 || m == 448 || m == 470 || m == 485 || m == 486 || m == 488 || m == 490 || m == 497 || m == 520
    || m == 523 || m == 524 || m == 525 || m == 528 || m == 539 || m == 544 || m == 548 || m == 552 || m == 563 || m == 572 
    || m == 574 || m == 582 || m == 583 || m == 596 || m == 597 || m == 598 || m == 599 || m == 601 
	|| m == 2032 || m == 2036 || m == 2037 || m == 2038 || m == 2040 || m == 2041 || m == 2044 || m == 2045 || m == 2046
	|| m == 2047 || m == 2060 || m == 2096 || m == 2100 || m == 2101 || m == 2102 || m == 2108 || m == 2122 || m == 2127
    || m == 2129 || m == 2129 || m == 2132 || m == 2134 || m == 2135 || m == 2140 || m == 2151 || m == 2164) class = 7;

    // Новый класс, типо лимитированные (8)
    else if(m == 2063 || m == 2064 || m == 2088 || m == 2104 || m == 2120 || m == 2124 || m == 2126 || m == 2128 || m == 2153
    || m == 2159 || m == 2160 || m == 2161 || m == 2162 || m == 2163) class = 8;

    else class = 0; // 0 Класс недоступен для продажи (неизвестный транспорт)
    return class;
}

// Перечисляем транспорт с покрасочными работами
stock IsAVehiclesPaintJob(model)
{
    if(model == 2042) return 4; // Ferrari F1 имеет 4 покрасочные работы
    return 0;
}

// Перечисляем кастомные модели дисков для транспорта (Сюды добавлять новые)
stock IsAWheelsForVehicleCustom(model)
{
    if(model == 12246) return true;
    return false;
}

// Перечисляем стандартные модели дисков для транспорта
stock IsAWheelsForVehicleDefault(model)
{
    if(model == 1025 || model >= 1073 && model <= 1085 || model >= 1096 && model <= 1098) return true;
    return false;
}

// Проверка дисков для трансопрта
stock IsAWheelForVehicles(model)
{
    if(IsAWheelsForVehicleDefault(model)
        || IsAWheelsForVehicleCustom(model)) return true;
    return false;
}

stock IsElectroCarModel(model) // Транспорт с электродвигателем
{
	if(model == 2078 || model == 2079 || model == 2086 || model == 2136 || model == 2137 || model == 2138 || model == 2139 || model == 2140 || model == 2141 || model == 2142
    || model == 2143) return 1;
	return 0;
}

// Транспорт, на котором можно ехать стоя на нём
stock IsARideOnVehicle(model)
{
	if(model == 406 || model == 422 || model == 478 || model == 543 || model == 554 
	|| model == 537 || model == 538 || model == 569 || model == 570 || model == 2141 
	|| model == 2036 || model == 2168 || model == 2169) return true;
	return false;
}

// ХЕЛИКОПТЕР ХЕЛИКОПТЕР
stock IsAHelicopter(model)
{
    if(model == 417 || model == 447 || model == 469 || model == 487 || model == 488 
	|| model == 497 || model == 548 || model == 563 || model == 2100 || model == 2102 
	|| model == 2129) return true;
	return false;
}
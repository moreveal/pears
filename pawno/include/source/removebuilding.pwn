
stock DeleteObject(playerid)
{
    new year, month,day;
 	getdate(year, month, day);
 	
 	// 550 удалённх объектов

	// Сервис Самолётов и Вертолётов LV
	RemoveBuildingForPlayer(playerid, 8253, 1278.020, 1324.250, 13.750, 0.250);
	RemoveBuildingForPlayer(playerid, 8252, 1278.020, 1324.250, 13.750, 0.250);
	RemoveBuildingForPlayer(playerid, 8251, 1278.300, 1361.449, 13.750, 0.250);
	RemoveBuildingForPlayer(playerid, 8127, 1278.300, 1361.449, 13.750, 0.250);

    // Порт SF (Аренда, Сервис, Салон Катеров)
    RemoveBuildingForPlayer(playerid, 1232, -1486.3281, 680.3906, 8.8047, 0.25);
    RemoveBuildingForPlayer(playerid, 1232, -1486.3281, 729.2344, 8.8047, 0.25);

    // Порт LS (Аренда, Сервис, Салон Катеров)
    RemoveBuildingForPlayer(playerid, 3689, 2685.379, -2366.050, 19.953, 0.250);
    RemoveBuildingForPlayer(playerid, 3690, 2685.379, -2366.050, 19.953, 0.250);
    RemoveBuildingForPlayer(playerid, 3574, 2771.070, -2372.449, 15.218, 0.250);
    RemoveBuildingForPlayer(playerid, 3744, 2771.070, -2372.449, 15.218, 0.250);
    RemoveBuildingForPlayer(playerid, 1226, 2692.679, -2387.479, 16.414, 0.250);

	// Автосалон LS 0
	RemoveBuildingForPlayer(playerid, 1211, 555.156, -1251.930, 16.640, 0.250); // Гидрант при въезде

	// Автосалон SF 1
	RemoveBuildingForPlayer(playerid, 9953, -1668.839, 1215.750, 19.226, 0.250);
	RemoveBuildingForPlayer(playerid, 10107, -1668.839, 1215.750, 19.226, 0.250);

	// Автосалон SF 2
	RemoveBuildingForPlayer(playerid, 11317, -1947.219, 280.820, 45.273, 0.250);
	RemoveBuildingForPlayer(playerid, 11321, -1947.219, 280.820, 45.273, 0.250);

	// Игровой Заказ 2 (2022)
	RemoveBuildingForPlayer(playerid, 3402, 1019.380, -300.242, 72.984, 0.250);
	RemoveBuildingForPlayer(playerid, 3404, 1019.380, -300.242, 72.984, 0.250);
	RemoveBuildingForPlayer(playerid, 3402, 1045.560, -300.601, 72.984, 0.250);
	RemoveBuildingForPlayer(playerid, 3404, 1045.560, -300.601, 72.984, 0.250);
	RemoveBuildingForPlayer(playerid, 3375, 1070.479, -355.164, 77.335, 0.250);
	RemoveBuildingForPlayer(playerid, 3376, 1070.479, -355.164, 77.335, 0.250);

	// Церковь
    RemoveBuildingForPlayer(playerid, 8679, 2497.129, 923.156, 10.718, 0.250);
    
	//--------------------------------------------------------------------------
	//--------------------------------[ NASA База ]-----------------------------
    RemoveBuildingForPlayer(playerid, 16367, -892.890, 2695.530, 43.000, 0.250);
	RemoveBuildingForPlayer(playerid, 16759, -905.320, 2685.949, 41.382, 0.250);
	RemoveBuildingForPlayer(playerid, 16364, -917.507, 2668.949, 41.367, 0.250);
	RemoveBuildingForPlayer(playerid, 16608, -917.507, 2668.949, 41.367, 0.250);
	//--------------------------------------------------------------------------
	//--------------------------------[ Ферма ]---------------------------------
    RemoveBuildingForPlayer(playerid, 12919, -43.898, 41.109, 2.109, 0.250);
	RemoveBuildingForPlayer(playerid, 13056, -43.898, 41.109, 2.109, 0.250);
	RemoveBuildingForPlayer(playerid, 12915, -69.046, 86.835, 2.109, 0.250);
	RemoveBuildingForPlayer(playerid, 13052, -69.046, 86.835, 2.109, 0.250);
	RemoveBuildingForPlayer(playerid, 3276, -71.835, 58.875, 2.882, 0.250);
	RemoveBuildingForPlayer(playerid, 3276, -94.523, 31.617, 2.882, 0.250);
	RemoveBuildingForPlayer(playerid, 3276, -90.531, 42.148, 2.882, 0.250);
	RemoveBuildingForPlayer(playerid, 3276, -133.3281, -7.3047, 2.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -127.1328, 9.5859, 2.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3375, -15.523, 68.453, 6.664, 0.250);
	RemoveBuildingForPlayer(playerid, 3376, -15.523, 68.453, 6.664, 0.250);
	RemoveBuildingForPlayer(playerid, 3276, -81.898, 56.851, 2.882, 0.250);
 	//--------------------------------------------------------------------------
	//----------------------[ Нефтеперерабатывающий Завод ]---------------------
 	RemoveBuildingForPlayer(playerid, 7169, 2514.5859, 2822.9531, 13.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 7102, 2514.5859, 2822.9531, 13.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3474, 2523.9688, 2818.4922, 16.7422, 0.25);
 	//--------------------------------------------------------------------------
	//--------------------------[ Доска Почёта Гетто ]--------------------------
 	RemoveBuildingForPlayer(playerid, 1226, 2250.4688, -1753.5625, 16.4219, 0.25);
 	//--------------------------------------------------------------------------
	//----------------------------[ Заправка SF-4 ]-----------------------------
 	RemoveBuildingForPlayer(playerid, 18548, -1560.6719, -2728.3984, 47.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 1522, -1562.5234, -2732.1406, 47.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 18282, -1560.6719, -2728.3984, 47.7422, 0.25);
 	//--------------------------------------------------------------------------
	//----------------------------[ Штраф Стоянка ]-----------------------------
 	RemoveBuildingForPlayer(playerid, 7227, 2232.257, 2017.609, 11.203, 0.250);
 	//--------------------------------------------------------------------------
	//-------------------------------[ Army SF ]--------------------------------
 	RemoveBuildingForPlayer(playerid, 10886, -1561.632, 434.164, 9.273, 0.250);
	RemoveBuildingForPlayer(playerid, 10887, -1675.093, 324.578, 9.281, 0.250);
	RemoveBuildingForPlayer(playerid, 10885, -1675.093, 324.578, 9.281, 0.250);
	RemoveBuildingForPlayer(playerid, 10835, -1561.632, 434.164, 9.273, 0.250);
	RemoveBuildingForPlayer(playerid, 968, -1526.437, 481.382, 6.906, 0.250);
	RemoveBuildingForPlayer(playerid, 966, -1526.390, 481.382, 6.179, 0.250);
	RemoveBuildingForPlayer(playerid, 10829, -1523.257, 486.796, 6.156, 0.250);
	RemoveBuildingForPlayer(playerid, 3115, -1456.721069, 501.283203, 17.020845, 1.0); // Крышка Авианосца
 	//--------------------------------------------------------------------------
	//-------------------------------[ Зона 51 ]--------------------------------
 	RemoveBuildingForPlayer(playerid, 1411, 347.195, 1799.265, 18.756, 0.250);
	RemoveBuildingForPlayer(playerid, 1411, 342.937, 1796.288, 18.756, 0.250);
	RemoveBuildingForPlayer(playerid, 16670, 330.789, 1813.218, 17.827, 0.250);
	RemoveBuildingForPlayer(playerid, 16094, 191.139, 1870.038, 21.475, 0.250);
	RemoveBuildingForPlayer(playerid, 16671, 193.953, 2051.795, 20.179, 0.250);
	RemoveBuildingForPlayer(playerid, 16668, 357.937, 2049.420, 16.843, 0.250);
	RemoveBuildingForPlayer(playerid, 16669, 380.256, 1914.959, 17.429, 0.250);
	RemoveBuildingForPlayer(playerid, 16590, 199.343, 1943.789, 18.203, 0.250);
	RemoveBuildingForPlayer(playerid, 16619, 199.335, 1943.875, 18.203, 0.250);
	RemoveBuildingForPlayer(playerid, 1697, 220.382, 1835.343, 23.234, 0.250);
	RemoveBuildingForPlayer(playerid, 1697, 228.796, 1835.343, 23.234, 0.250);
	RemoveBuildingForPlayer(playerid, 1697, 236.992, 1835.343, 23.234, 0.250);
	RemoveBuildingForPlayer(playerid, 16203, 199.343, 1943.789, 18.203, 0.250);
	RemoveBuildingForPlayer(playerid, 16323, 199.335, 1943.875, 18.203, 0.250);
	RemoveBuildingForPlayer(playerid, 3268, 276.656, 1955.770, 16.632, 0.250);
	RemoveBuildingForPlayer(playerid, 3366, 276.656, 1955.770, 16.632, 0.250);
	RemoveBuildingForPlayer(playerid, 3268, 276.656, 2023.760, 16.632, 0.250);
	RemoveBuildingForPlayer(playerid, 3366, 276.656, 2023.760, 16.632, 0.250);
	RemoveBuildingForPlayer(playerid, 3268, 276.656, 1989.550, 16.632, 0.250);
	RemoveBuildingForPlayer(playerid, 3366, 276.656, 1989.550, 16.632, 0.250);
	RemoveBuildingForPlayer(playerid, 3279, 262.0938, 1807.6719, 16.8203, 0.25);
	//RemoveBuildingForPlayer(playerid, 18656, 262.133880, 1807.660522, 35.790237, 3.0); // Прожектор
 	//--------------------------------------------------------------------------
	//------------------------[ Мафиозный Корабль LS ]--------------------------
 	RemoveBuildingForPlayer(playerid, 3689, 2430.5859, -2583.9453, 20.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 3690, 2430.5859, -2583.9453, 20.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 3688, 2450.8750, -2680.4531, 17.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3769, 2400.9063, -2577.3359, 15.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 2410.9766, -2632.8750, 16.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3625, 2400.9063, -2577.3359, 15.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 3621, 2450.8750, -2680.4531, 17.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1635, 2430.5781, -2653.9453, 23.7188, 0.25);
 	//--------------------------------------------------------------------------
	//------------------------[ Мафиозный Корабль SF ]--------------------------
 	RemoveBuildingForPlayer(playerid, 10840, -1666.1250, -62.0781, 10.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 10843, -1711.4688, -107.5703, 10.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 10892, -1711.4688, -107.5703, 10.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 10910, -1681.1094, -24.6797, 5.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 10911, -1711.2031, -47.7109, 5.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 10912, -1666.1250, -62.0781, 10.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, -1728.6016, -95.8516, 6.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, -1725.9609, -64.7969, 5.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 10845, -1711.2031, -47.7109, 5.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 10844, -1681.1094, -24.6797, 5.4766, 0.25);
 	//--------------------------------------------------------------------------
	//----------------------------------[ SWAT ]--------------------------------
 	RemoveBuildingForPlayer(playerid, 1350, 2397.899, 2518.770, 9.804, 0.25);
 	//--------------------------------------------------------------------------
	//-------------------------------[ Аэропорт LS ]----------------------------
	RemoveBuildingForPlayer(playerid, 4990, 1646.1953, -2414.0703, 17.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 5010, 1646.1953, -2414.0703, 17.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3663, 1580.0938, -2433.8281, 14.5703, 0.25); // Трап возле самолёта
	RemoveBuildingForPlayer(playerid, 4832, 1610.7969, -2285.8359, 52.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 4948, 1610.7969, -2285.8359, 52.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1525, 1624.6250, -2296.2422, 14.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 3657, 1612.6094, -2333.2109, 13.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 3660, 1613.8281, -2334.6797, 14.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1586.2109, -2272.2422, 12.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1586.2109, -2302.2656, 12.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1619.5078, -2267.2031, 20.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1619.5078, -2305.8125, 20.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1650.7969, -2271.1953, 5.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1650.7891, -2303.5313, 5.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1653.9609, -2267.7344, -4.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1653.9609, -2301.9063, -4.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1658.1641, -2300.5703, 8.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 4992, 1654.5391, -2286.8047, 13.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1673.2969, -2301.9063, -4.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1673.2969, -2267.7344, -4.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1695.2578, -2301.9063, -4.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1697.7031, -2302.9531, 5.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1695.2578, -2267.7344, -4.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1696.0859, -2271.1953, 5.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1712.3203, -2303.1484, 5.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1715.7031, -2301.9063, -4.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1715.7031, -2267.7344, -4.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1712.3203, -2271.1953, 5.2344, 0.25);
 	//--------------------------------------------------------------------------
	//--------------------------[ Для Прозрачного Пола ]------------------------
 	RemoveBuildingForPlayer(playerid, 14795, 1388.882, -20.882, 1005.203, 0.250);
 	//--------------------------------------------------------------------------
	//---------------------------------[ IKEA ]---------------------------------
 	RemoveBuildingForPlayer(playerid, 6944, 2834.6875, 2502.2500, 15.6250, 0.25); // Обязательное удаление
	RemoveBuildingForPlayer(playerid, 7111, 2834.6875, 2502.2500, 15.6250, 0.25); // Обязательное удаление
	RemoveBuildingForPlayer(playerid, 1268, 2861.0234, 2437.9063, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1268, 2841.1484, 2418.0313, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1268, 2823.6016, 2418.1797, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1268, 2783.0078, 2458.7813, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1268, 2802.8750, 2438.7344, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1268, 2763.1406, 2478.6563, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1268, 2881.0703, 2457.7656, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1268, 2901.6250, 2478.5000, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 7305, 2774.2188, 2467.4922, 24.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 7306, 2814.3828, 2427.2344, 24.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 7307, 2852.3203, 2429.1172, 24.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 7308, 2897.7500, 2463.1875, 28.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1259, 2823.6016, 2418.1797, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1259, 2841.1484, 2418.0313, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1259, 2783.0078, 2458.7813, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1259, 2802.8750, 2438.7344, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1259, 2881.0703, 2457.7656, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1259, 2861.0234, 2437.9063, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1259, 2763.1406, 2478.6563, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1259, 2901.6250, 2478.5000, 17.9688, 0.25);
 	//--------------------------------------------------------------------------
	//-------------------------------[ Отель Pears ]----------------------------
 	RemoveBuildingForPlayer(playerid, 14784, 1281.140, -30.093, 1009.409, 0.250);
 	//--------------------------------------------------------------------------
	//--------------------------[ Территориальные Объекты ]---------------------
	RemoveBuildingForPlayer(playerid, 10938, -1909.5547, 497.2188, 25.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 11144, -1909.5547, 497.2188, 25.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 762, 1175.3594, -1420.1875, 19.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 615, 1166.3516, -1417.6953, 13.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 10850, -1875.0234, -65.3281, 15.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 10919, -1875.0234, -65.3281, 15.0625, 0.25);
 	//--------------------------------------------------------------------------
	//--------------------------------[ Секта ]---------------------------------
 	RemoveBuildingForPlayer(playerid, 18267, -2816.1797, -1524.2813, 139.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 18230, -2811.0313, -1523.9141, 140.1250, 0.25);
 	//--------------------------------------------------------------------------
	//---------------------------[ Разрушаемое Здание ]-------------------------
 	RemoveBuildingForPlayer(playerid, 4579, 1666.4922, -1246.1797, 123.0859, 0.25);
	RemoveBuildingForPlayer(playerid, 4717, 1666.4922, -1246.1797, 123.0859, 0.25);
	RemoveBuildingForPlayer(playerid, 4564, 1666.4922, -1246.1797, 123.0859, 0.25);
 	//--------------------------------------------------------------------------
	//--------------------------------[ Психушка ]------------------------------
 	RemoveBuildingForPlayer(playerid, 5578, 2049.867, -1400.890, 20.679, 0.250);
	RemoveBuildingForPlayer(playerid, 5579, 2050.070, -1401.210, 33.679, 0.250);
	RemoveBuildingForPlayer(playerid, 5403, 2050.070, -1401.210, 33.679, 0.250);
	RemoveBuildingForPlayer(playerid, 5402, 2049.867, -1400.890, 20.679, 0.250);
 	//--------------------------------------------------------------------------
	//--------------------------------[ Пожарные ]------------------------------
 	RemoveBuildingForPlayer(playerid, 11034, -2137.195, 70.281, 42.312, 0.250);
	RemoveBuildingForPlayer(playerid, 10988, -2137.195, 70.281, 42.312, 0.250);
 	//--------------------------------------------------------------------------
	//---------------------------------[ SFPD ]---------------------------------
 	RemoveBuildingForPlayer(playerid, 10042, -1606.560, 731.437, 39.335, 0.250);
	RemoveBuildingForPlayer(playerid, 10057, -1669.218, 723.468, 57.546, 0.250);
	RemoveBuildingForPlayer(playerid, 10248, -1680.992, 683.234, 19.046, 0.250);
	RemoveBuildingForPlayer(playerid, 967, -1700.929, 688.867, 23.882, 0.250);
	RemoveBuildingForPlayer(playerid, 966, -1701.429, 687.593, 23.882, 0.250);
	RemoveBuildingForPlayer(playerid, 10029, -1680.210, 704.851, 27.203, 0.250);
	RemoveBuildingForPlayer(playerid, 966, -1572.203, 658.835, 6.078, 0.250);
	RemoveBuildingForPlayer(playerid, 967, -1572.703, 657.601, 6.078, 0.250);
	RemoveBuildingForPlayer(playerid, 1496, -1618.601, 680.914, 6.171, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, -1707.109, 681.445, 27.742, 0.250);
 	//--------------------------------------------------------------------------
	//----------------------------[ Дальнобойщики ]-----------------------------

	RemoveBuildingForPlayer(playerid, 985, 2497.4063, 2777.0703, 11.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 986, 2497.4063, 2769.1094, 11.5313, 0.25);
 	//--------------------------------------------------------------------------
	//------------------------------[ Triada ]----------------------------------
 	RemoveBuildingForPlayer(playerid, 9901, -1459.1016, 920.0938, 31.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 9963, -1459.1016, 920.0938, 31.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1232, -1510.6641, 918.0234, 8.8047, 0.25);
 	//--------------------------------------------------------------------------
	//------------------------------[ Казино ]----------------------------------
 	RemoveBuildingForPlayer(playerid, 8663, 1955.800, 1011.900, 33.898, 0.250);
	RemoveBuildingForPlayer(playerid, 8704, 1955.800, 1011.900, 33.898, 0.250);
 	//--------------------------------------------------------------------------
	//---------------------[ Последний Пидорский Заказ ]------------------------
 	RemoveBuildingForPlayer(playerid, 17351, -1432.5469, -1545.8672, 108.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 17354, -1458.4531, -1522.6328, 100.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 17053, -1458.4531, -1522.6328, 100.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 17056, -1462.0156, -1532.5313, 101.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 17059, -1458.7656, -1535.5703, 100.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 17335, -1432.5469, -1545.8672, 108.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 17050, -1411.2188, -1530.5547, 100.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -1411.1641, -1561.1016, 101.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -1403.1719, -1528.8359, 101.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -1402.6719, -1540.2031, 101.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -1406.4219, -1550.8438, 101.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 17049, -1412.8438, -1520.3984, 100.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -1405.3828, -1517.0469, 101.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 3425, -1439.7891, -1520.9375, 112.1250, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -1407.5938, -1505.7188, 101.4844, 0.25);
 	//--------------------------------------------------------------------------
	//--------------------------------[ Тюрьма ]--------------------------------
 	RemoveBuildingForPlayer(playerid, 706, 1430.5078, -150.4453, 22.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 705, 1461.9766, -173.3047, 24.3750, 0.25);
 	//--------------------------------------------------------------------------
	//----------------------------[ Yakuza Mafia ]------------------------------
 	RemoveBuildingForPlayer(playerid, 710, 1402.0859, 785.1172, 25.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1402.5469, 762.4453, 25.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1402.0859, 737.8828, 25.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1402.0859, 716.0313, 25.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1402.0859, 690.7266, 25.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 710, 1402.6172, 668.3828, 25.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 8145, 1493.9297, 751.0156, 20.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 8146, 1544.6172, 676.2109, 20.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 8285, 1477.3906, 730.5938, 10.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 8286, 1477.3906, 730.5938, 10.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 8287, 1477.3906, 730.5938, 10.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1338.9844, 715.0938, 14.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1355.5781, 682.1016, 14.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1355.7500, 744.9063, 14.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1402.6016, 673.0469, 9.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1453.7969, 736.9609, 9.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 8131, 1544.6172, 676.2109, 20.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 8130, 1493.9297, 751.0156, 20.9141, 0.25);
 	//--------------------------------------------------------------------------
	//----------------------------[ Главная Ёлка ]------------------------------
 	if(month == 12 || month == 1)
 	{
	    RemoveBuildingForPlayer(playerid, 6107, 1251.7891, -1541.2813, 36.9141, 0.25);
		RemoveBuildingForPlayer(playerid, 6195, 1236.5234, -1488.1641, 40.6875, 0.25);
		RemoveBuildingForPlayer(playerid, 1524, 1295.1797, -1465.2188, 10.2813, 0.25);
		RemoveBuildingForPlayer(playerid, 6224, 1264.0469, -1488.3516, 21.1016, 0.25);
		RemoveBuildingForPlayer(playerid, 6100, 1251.7891, -1541.2813, 36.9141, 0.25);
		RemoveBuildingForPlayer(playerid, 1231, 1236.7188, -1520.1484, 15.1953, 0.25);
		RemoveBuildingForPlayer(playerid, 1231, 1263.3047, -1520.1484, 15.1953, 0.25);
		RemoveBuildingForPlayer(playerid, 6223, 1264.0469, -1488.3516, 21.1016, 0.25);
	}
    //--------------------------------------------------------------------------
	//----------------------------[ Hitman Agency ]-----------------------------
    RemoveBuildingForPlayer(playerid, 3420, -488.0313, -175.2734, 77.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 3419, -488.0313, -175.2734, 77.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 13004, -510.6719, -177.9141, 78.5703, 0.25);
    //--------------------------------------------------------------------------
	//--------------------------[ Тюнинг Салон LS ]-----------------------------
    RemoveBuildingForPlayer(playerid, 5858, 1214.1484, -913.4453, 43.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 6010, 1214.1484, -913.4453, 43.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 5742, 1197.3203, -899.2109, 45.0938, 0.25);
	//--------------------------------------------------------------------------
	//--------------------------[ Тюнинг Салон SF ]-----------------------------
    RemoveBuildingForPlayer(playerid, 10505, -2285.5234, -157.1094, 40.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 10388, -2285.5234, -157.1094, 40.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 1500, -2271.0313, -156.7266, 34.3125, 0.25);
	//--------------------------------------------------------------------------
	//--------------------------[ Тюнинг Салон LV ]-----------------------------
	RemoveBuildingForPlayer(playerid, 8300, 1542.6484, 998.8984, 12.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 8301, 1542.6484, 998.8984, 12.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 640, 1553.7656, 1016.1328, 10.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 640, 1545.5156, 1016.1328, 10.5156, 0.25);
    //--------------------------------------------------------------------------
	//----------------------------[ Ледовый Дворец ]----------------------------
    RemoveBuildingForPlayer(playerid, 11025, -2199.3281, 264.3281, 42.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 10973, -2199.3281, 264.3281, 42.1953, 0.25);
    //--------------------------------------------------------------------------
	//--------------------------[ Пидорский Заказ №3 ]--------------------------
    RemoveBuildingForPlayer(playerid, 3778, 337.4531, -1875.0000, 3.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3615, 337.4531, -1875.0000, 3.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 345.3125, -1775.9453, 7.4531, 0.25);
    //--------------------------------------------------------------------------
	//--------------------------[ Пидорский Заказ №2 ]--------------------------
    RemoveBuildingForPlayer(playerid, 3276, -118.9688, -165.6719, 2.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 672, -112.4766, -158.2422, 2.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 672, -149.3359, -160.5078, 3.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -130.8203, -160.7656, 2.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -116.6172, -153.6328, 2.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -124.4297, -136.6172, 2.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -108.0234, -114.6563, 2.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -119.0156, -112.8672, 2.9063, 0.25);
    //--------------------------------------------------------------------------
	//----------------------------[ Русская Мафия ]-----------------------------
    RemoveBuildingForPlayer(playerid, 10284, -2010.9844, 1117.9375, 68.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 9931, -2010.9844, 1117.9375, 68.8438, 0.25);
    //--------------------------------------------------------------------------
	//--------------------------[ Утиль Автомобилей ]---------------------------
    RemoveBuildingForPlayer(playerid, 3300, 26.2188, 925.9063, 24.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 3297, 20.5391, 906.3594, 24.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 3242, 20.5391, 906.3594, 24.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 3285, 26.2188, 925.9063, 24.4844, 0.25);
    //--------------------------------------------------------------------------
	//----------------------------[ Правительство ]-----------------------------
    RemoveBuildingForPlayer(playerid, 10319, -2722.5391, -341.7422, 34.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 10396, -2752.1016, -252.2422, 7.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 10397, -2752.1328, -252.2344, 10.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 640, -2733.4219, -333.0703, 6.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 10398, -2722.5391, -341.7422, 34.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 640, -2712.4141, -311.8125, 6.8672, 0.25);
    //--------------------------------------------------------------------------
	//------------------------------[ Заправки ]---------------------------------
	// ---- LS 1
    RemoveBuildingForPlayer(playerid, 5535, 1918.8516, -1776.3281, 16.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 1524, 1910.1641, -1779.6641, 18.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1917.3203, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1927.8516, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1922.5859, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 5681, 1921.4844, -1778.9141, 18.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 5409, 1918.8516, -1776.3281, 16.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1778.4531, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1774.3125, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 955, 1928.7344, -1772.4453, 12.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1771.3438, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1767.2891, 14.1406, 0.25);
	// ---- LS 2
	RemoveBuildingForPlayer(playerid, 6430, 121.0313, -1580.4063, 10.4688, 0.25);
	// ---- SF 1
	RemoveBuildingForPlayer(playerid, 11281, -1680.6016, 417.9453, 8.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1686, -1685.9688, 409.6406, 6.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 10789, -1680.6016, 417.9453, 8.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1686, -1679.3594, 403.0547, 6.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1686, -1681.8281, 413.7813, 6.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1532, -1677.0078, 431.9297, 6.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1686, -1675.2188, 407.1953, 6.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1686, -1676.5156, 419.1172, 6.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1686, -1669.9063, 412.5313, 6.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1686, -1672.1328, 423.5000, 6.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1686, -1665.5234, 416.9141, 6.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 11417, -1650.6328, 423.1641, 11.0547, 0.25);
	// ---- SF 2
	RemoveBuildingForPlayer(playerid, 11162, -2111.2578, 11.0625, 37.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 11163, -2110.8281, -27.3594, 36.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 11092, -2110.8281, -27.3594, 36.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 11102, -2102.9297, -16.0547, 36.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 11093, -2111.2578, 11.0625, 37.3906, 0.25);
	// ---- LV 2
	RemoveBuildingForPlayer(playerid, 7118, 2263.1250, 2391.5469, 9.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 2240.9453, 2401.6797, 11.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 1532, 2248.4297, 2395.7656, 9.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 6946, 2263.1250, 2391.5469, 9.8203, 0.25);
    //--------------------------------------------------------------------------
	//-----------------------------[ Археология ]-------------------------------
	RemoveBuildingForPlayer(playerid, 16021, -312.937, 1780.979, 41.437, 0.250);
    //--------------------------------------------------------------------------
	//------------------------[ Образовательный Центр ]-------------------------
    RemoveBuildingForPlayer(playerid, 3980, 1481.189, -1785.069, 22.382, 0.250);
	RemoveBuildingForPlayer(playerid, 4044, 1481.189, -1785.069, 22.382, 0.250);
	RemoveBuildingForPlayer(playerid, 4002, 1479.869, -1790.400, 56.023, 0.250);
	RemoveBuildingForPlayer(playerid, 4024, 1479.869, -1790.400, 56.023, 0.250);
	RemoveBuildingForPlayer(playerid, 4003, 1481.079, -1747.030, 33.523, 0.250);
	RemoveBuildingForPlayer(playerid, 1527, 1448.229, -1755.900, 14.523, 0.250);
    //--------------------------------------------------------------------------
	//------------------------------[ Спортзал ]--------------------------------
    RemoveBuildingForPlayer(playerid, 4606, 1825.0000, -1413.9297, 12.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 4594, 1825.0000, -1413.9297, 12.5547, 0.25);
    //--------------------------------------------------------------------------
	//------------------------------[ Автосалон ]-------------------------------
    RemoveBuildingForPlayer(playerid, 4025, 1777.8359, -1773.9063, 12.5234, 0.25);
    RemoveBuildingForPlayer(playerid, 4070, 1719.7422, -1770.7813, 23.4297, 0.25);
    RemoveBuildingForPlayer(playerid, 1531, 1724.7344, -1741.5000, 14.1016, 0.25);
    RemoveBuildingForPlayer(playerid, 4215, 1777.5547, -1775.0391, 36.7500, 0.25);
    RemoveBuildingForPlayer(playerid, 3986, 1719.7422, -1770.7813, 23.4297, 0.25);
    RemoveBuildingForPlayer(playerid, 4019, 1777.8359, -1773.9063, 12.5234, 0.25);
    //--------------------------------------------------------------------------
	//--------------------------[ Оружейка Ghetto ]-----------------------------
    RemoveBuildingForPlayer(playerid, 17765, 2436.2188, -1788.5625, 15.0234, 0.25);
    RemoveBuildingForPlayer(playerid, 17523, 2436.2188, -1788.5625, 15.0234, 0.25);
    //--------------------------------------------------------------------------
	//--------------------------------[ LSPD ]----------------------------------
	RemoveBuildingForPlayer(playerid, 4064, 1571.601, -1675.750, 35.679, 0.250);
	RemoveBuildingForPlayer(playerid, 1525, 1549.890, -1714.523, 15.101, 0.250);
	RemoveBuildingForPlayer(playerid, 3976, 1571.601, -1675.750, 35.679, 0.250);
	RemoveBuildingForPlayer(playerid, 1536, 1555.9297, -1677.1250, 15.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1536, 1555.8906, -1674.1094, 15.1797, 0.25);
    //--------------------------------------------------------------------------
	//------------------------[ ВУЗ Аэропорт Удалённые ]------------------------
    RemoveBuildingForPlayer(playerid, 5031, 2037.0469, -2313.5469, 18.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1975.7266, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1979.6797, -2207.8438, 18.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 1983.8047, -2224.1641, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2010.3984, -2207.6172, 18.4219, 0.25);
    //--------------------------------------------------------------------------
	//--------------------------[ Мафиозный Корабль ]---------------------------
	RemoveBuildingForPlayer(playerid, 10793, -1604.0391, 22.7266, 35.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 10794, -1550.8281, 75.9297, 7.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 10795, -1552.4375, 74.3203, 17.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 11329, -1552.4375, 74.3203, 17.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 11330, -1604.0391, 22.7266, 35.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 11331, -1550.8281, 75.9297, 7.0000, 0.25);
    //--------------------------------------------------------------------------
    //-------------------------[ Автомастерская Хенка ]-------------------------
    RemoveBuildingForPlayer(playerid, 3645, 2069.6172, -1556.7031, 15.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 3645, 2070.7578, -1586.0156, 15.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 5633, 2089.3594, -1643.9297, 18.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 1524, 2074.1797, -1579.1484, 14.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 3644, 2070.7578, -1586.0156, 15.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 3644, 2069.6172, -1556.7031, 15.0625, 0.25);
	// NEW NEW NEW
	RemoveBuildingForPlayer(playerid, 6208, 954.2734, -1720.7969, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 6205, 954.2734, -1720.7969, 20.7734, 0.25);
//--------------------------------------------------------------------------
    //----------------------------[ Arabian Mafia Удалённые ]------------------------
    RemoveBuildingForPlayer(playerid, 1413, 2824.0938, -2131.1719, 11.0469, 0.25);
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
//-------------------------[ Оружейный Завод Удалённые ]--------------------
//--------------------------------------------------------------------------
    RemoveBuildingForPlayer(playerid, 4719, 1760.1641, -1127.2734, 43.6641, 0.25);
    RemoveBuildingForPlayer(playerid, 4748, 1760.1641, -1127.2734, 43.6641, 0.25);
    RemoveBuildingForPlayer(playerid, 1215, 1755.3047, -1142.8438, 23.6094, 0.25);
    RemoveBuildingForPlayer(playerid, 4718, 1760.1641, -1127.2734, 43.6641, 0.25);
    RemoveBuildingForPlayer(playerid, 1227, 1789.9063, -1112.6406, 23.8906, 0.25);
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
//-------------------------[ Grove Street Удалённые ]-----------------------
    RemoveBuildingForPlayer(playerid, 3706, 2520.1875, -1694.8516, 14.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 3646, 2520.1875, -1694.8516, 14.8828, 0.25);
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
//---------------------------[ Ballas Gang Удалённые ]----------------------
    RemoveBuildingForPlayer(playerid, 3654, 2506.9766, -1991.7813, 14.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 3591, 2465.2891, -1991.8359, 15.0859, 0.25);
	RemoveBuildingForPlayer(playerid, 3590, 2465.2891, -1991.8359, 15.0859, 0.25);
	RemoveBuildingForPlayer(playerid, 5150, 2482.7031, -2010.9688, 23.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 1535, 2482.6484, -1994.9609, 12.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 671, 2498.7344, -1993.1484, 12.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 3649, 2506.9766, -1991.7813, 14.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 1460, 2540.3594, -2013.4375, 13.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 1460, 2540.3125, -2008.8594, 13.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 1460, 2540.3125, -2004.2813, 13.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 5341, 2489.5156, -1987.4219, 14.9453, 0.25);
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------- Los Aztecas Gang -----------------------------
    RemoveBuildingForPlayer(playerid, 3669, 1734.1016, -2092.7031, 15.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 3669, 1711.6328, -2095.9609, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 3669, 1695.4844, -2131.1094, 15.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 3670, 1713.8672, -2136.1953, 15.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 3634, 1695.4844, -2131.1094, 15.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 3634, 1711.6328, -2095.9609, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 3635, 1713.8672, -2136.1953, 15.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 5025, 1728.0703, -2125.8047, 21.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 3634, 1734.1016, -2092.7031, 15.2266, 0.25);
//----- Интерьер
    RemoveBuildingForPlayer(playerid, 1709, 2330.6172, -1067.3359, 1048.0078, 0.25);
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //------------------------------ Vagos Gang --------------------------------
	RemoveBuildingForPlayer(playerid, 3562, 2232.3984, -1464.7969, 25.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 3562, 2247.5313, -1464.7969, 25.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 3562, 2263.7188, -1464.7969, 25.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 3562, 2243.7109, -1401.7813, 25.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 3562, 2230.6094, -1401.7813, 25.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 3562, 2256.6641, -1401.7813, 25.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 3582, 2230.6094, -1401.7813, 25.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 3582, 2243.7109, -1401.7813, 25.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 3582, 2256.6641, -1401.7813, 25.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 645, 2239.5703, -1468.8047, 22.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3582, 2232.3984, -1464.7969, 25.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2241.8906, -1458.9297, 22.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 3582, 2247.5313, -1464.7969, 25.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2267.4688, -1470.1953, 21.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 3582, 2263.7188, -1464.7969, 25.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 1221, 2251.2891, -1461.8281, 23.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 5682, 2241.4297, -1433.6719, 31.2813, 0.25);
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------------- Лесопилка ------------------------------
    RemoveBuildingForPlayer(playerid, 18529, -2077.2344, -2444.9375, 29.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 18535, -2001.0313, -2388.0859, 38.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 18536, -2055.6328, -2461.0156, 29.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 790, -1979.7188, -2371.9063, 34.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 18233, -2055.6328, -2461.0156, 29.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 790, -1989.7813, -2462.3281, 34.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 18204, -2088.6484, -2454.2969, 41.1250, 0.25);
	RemoveBuildingForPlayer(playerid, 18238, -2077.2344, -2444.9375, 29.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 698, -2057.4375, -2417.0859, 34.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 790, -2081.9609, -2367.0000, 34.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 790, -2069.9297, -2401.0469, 34.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 790, -2035.7266, -2432.6563, 34.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 698, -2041.8281, -2448.4063, 34.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 790, -2051.2813, -2316.8750, 34.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 18365, -2001.0313, -2388.0859, 38.4531, 0.25);
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //----------------------------- Электростанция -----------------------------
    RemoveBuildingForPlayer(playerid, 3683, 2739.9844, -2089.0547, 18.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 2739.9844, -2119.7891, 17.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 2768.0469, -2104.4844, 17.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 2794.8047, -2074.5156, 17.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 2766.5234, -2074.5156, 18.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 2739.9844, -2119.7891, 17.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 2739.9844, -2089.0547, 18.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 2766.5234, -2074.5156, 18.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 2768.0469, -2104.4844, 17.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 2794.8047, -2074.5156, 17.7578, 0.25);
	//--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //------------------------------ Cosa Nostra -------------------------------
    RemoveBuildingForPlayer(playerid, 4917, 1145.9531, -2037.0000, 65.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 4920, 1224.4297, -2037.0078, 62.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 4987, 1102.9141, -2036.9844, 76.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 1530, 1118.9063, -2008.2422, 75.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1127.2422, -2080.7813, 66.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 1144.0781, -2076.3750, 68.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 661, 1159.9766, -2075.1563, 67.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 618, 1155.3672, -2072.5547, 67.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 1175.6094, -2079.4688, 67.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 4826, 1102.9141, -2036.9844, 77.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 4825, 1145.9531, -2037.0000, 65.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 762, 1189.7734, -2078.3672, 70.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 661, 1197.8516, -2074.6172, 67.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 1207.6094, -2079.0781, 66.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1208.7109, -2059.3203, 75.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1280.2031, -2062.1016, 63.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1208.4297, -2045.2422, 75.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 4824, 1224.4297, -2037.0078, 62.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 1290.8750, -2042.6094, 55.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1208.9141, -2025.9297, 75.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 762, 1290.9766, -2025.9375, 60.1875, 0.25);
	RemoveBuildingForPlayer(playerid, 661, 1284.9844, -2020.2500, 57.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 618, 1139.1797, -1997.7656, 67.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 618, 1146.1328, -1998.4688, 67.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 762, 1157.3750, -1989.4609, 67.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 661, 1148.7031, -1992.9844, 67.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 618, 1165.1328, -1994.1172, 66.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1208.9141, -2012.8516, 75.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 1208.6484, -2000.0703, 67.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 618, 1190.1953, -1995.4531, 66.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 1205.2734, -1987.8203, 63.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 1291.0469, -2007.0703, 54.8828, 0.25);
    //--------------------------------------------------------------------------
	return 1;
}
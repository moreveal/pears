
CMD:givemats(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу использовать эту команду");
	if(sscanf(params, "iiii",params[0],params[1],params[2],params[3])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать предметы на склад [ /givemats Организация Предмет Тип Количество ]");
	if(params[2] < 0 || params[2] > 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Тип предметов [ 0 Вещества и патроны, 1 Оружие, 2 Каска и броня ]");
	if(params[0] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: ID Организации 1 - 22 [ 29 Надзиратели, 33 ВМС ]");
	if(params[3] < 1 || params[3] > 50000) return ErrorMessage(playerid, "{FF6347}Не меньше 1 и не больше 50.000");
	
	if(params[0] <= 22 || params[0] == 29 || params[0] == 33) // ID Организаций
	{
		new yes;
	    if(params[2] == 0) // Обычные Предметы
	    {
	        if(params[1] >= 4 && params[1] <= 8 || params[1] >= 27 && params[1] <= 30) yes = 1; // Только вещества и патроны
	        else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: ID Предметов [ 4-8 Вещества, 27-30 Патроны ]");
	    }
	    else if(params[2] == 1) // Оружие
	    {
	        if(params[1] >= 2 && params[1] <= 15 || params[1] == 24 || params[1] == 25 || params[1] == 27 || params[1] == 30 || params[1] == 31 || params[1] == 33 || params[1] == 34) yes = 1; // Только оружие
	        else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: ID Оружия [ 2-15, 24, 25, 27, 30, 31, 33, 34 ]");
	    }
	    else if(params[2] == 2) // Аксессуары
	    {
	        if(IsArmor(params[1]) || IsHelmet(params[1])) yes = 1;
	        else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: ID Аксессуаров [ 19142 Бронежилет, 19106 Каска ]");
	    }
	
		if(yes == 1)
		{
		    new put_inva = putsklad(params[0], params[1], params[3], 0, params[2],1); // Кладём предмет
			if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}На складе организации, для этого предмета, нет места");

			format(store, sizeof(store), " [ ADM ]: %s выдал %s [Кол-во: %d] на склад %s",PlayerInfo[playerid][pName], GetNameThing(1, params[1], params[2], 0), params[2], frakName[params[0]]);
			ABroadCast(COLOR_ADM,store,1);
			AdminLog("givemats", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "Положил на склад предметы");
		}
	}
	else ErrorMessage(playerid, "{FF6347}Организации под этим ID не существует");
	return 1;
}
CMD:delmats(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу использовать эту команду");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Удалить боеприпасы со склада [ /delmats ID Организации ]");
	if(params[0] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не меньше 1 и не больше 22 [ 29 Надзиратели | 33 ВМС ]");
	if(params[0] <= 22 || params[0] == 29 || params[0] == 33)
	{
		new string[144];
	  	format(string, sizeof(string), " [ ADM ]: Админ %s очистил склад: %s",PlayerInfo[playerid][pName],frakName[params[0]]), ABroadCast(COLOR_ADM,string,1);
	   	for(new inva = 0; inva < 20; inva++) OrganInfo[params[0]][gInvent][inva] = 0, OrganInfo[params[0]][gInv][inva]= 0, OrganInfo[params[0]][gInvType][inva]= 0, OrganInfo[params[0]][gInvPara][inva]= 0;
		OrganInfo[params[0]][gUpdate] = 1;
		foreach(Player,i)
		{
			if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowInterfaceSklad] > 0) tabs_close(i, 2), OnlineInfo[i][oShowInterfaceSklad] = 0, Tabs_Type[i] = 0;
		}
		AdminLog("delmats", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "Очистил Склад");
		OrgLog(params[0], "delmats", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Очистил Склад");
	}
	else return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Такого значения нет..");
	return 1;
}
CMD:philin(playerid)
{	
	if(PlayerInfo[playerid][pSoska] >= 20)
	{
	new Float:x,Float:y,Float:z,Float:a,string[90];
	GetPlayerFacingAngle(playerid,a);
	GetPlayerPos(playerid,x,y,z);
	
	format(string, sizeof(string),"X: %f | Y: %f | Z: %f | A: %f",x,y,z,a);
	SendClientMessage(playerid,0xFFFFFFFF,string);
	}
	return 1;
}
CMD:readsit(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 20)
	{
	    if(readsit == 0) readsit = 1, SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Теперь я считываю ID всех стульев");
		else readsit = 0, SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Считывание отключено");
	}
	return 1;
}
CMD:readput(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 20)
	{
	    if(readput == 0) readput = 1, SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Теперь я считываю ID объектов, на которые кладутся предметы");
		else readput = 0, SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Считывание отключено");
	}
	return 1;
}
CMD:mytug(playerid)
{
	new str[144];
	new veh = GetPlayerVehicleID(playerid);
	format(str,sizeof(str),"Я сижу в машине и у неё прицеп VEH ID: %d",GetVehicleTrailer(veh));
	SendClientMessage(playerid, COLOR_GREY, str);
	return 1;
}
CMD:tug(playerid)
{
	new str[144];
	new veh = LichCarID[playerid];
	format(str,sizeof(str),"Моя личная тачка на прицепе у VEH ID: %d",gettug(veh));
	SendClientMessage(playerid, COLOR_GREY, str);
	format(str,sizeof(str),"Моя личная тачка на прицепе у VEH ID: %d {00CC00}NEW",GetVehicleTrailer(veh));
	SendClientMessage(playerid, COLOR_GREY, str);
	return 1;
}
CMD:mysql(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 10) return 1;
	mysql_tquery(pearsq,"SET NAMES 'cp1251'", "", "");
 	mysql_tquery(pearsq,"SET CHARACTER SET 'cp1251'", "", "");
 	//mysql_tquery(pearsq, "SET NAMES 'utf8'", "", "");
 	//mysql_tquery(pearsq, "SET CHARACTER SET 'utf8'", "", "");
 	SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Кодировка основной базы переустановлена");
    return true;
}
CMD:mysql2(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 10) return 1;
	mysql_tquery(pearsq_2,"SET NAMES 'cp1251'", "", "");
 	mysql_tquery(pearsq_2,"SET CHARACTER SET 'cp1251'", "", "");
 	//mysql_tquery(pearsq, "SET NAMES 'utf8'", "", "");
 	//mysql_tquery(pearsq, "SET CHARACTER SET 'utf8'", "", "");
 	SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Кодировка второй базы переустановлена");
    return true;
}
CMD:stopmaf(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 5) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 5+ ]");
	if(MafGz[0][mStat] == 0) return ErrorMessage(playerid, "{FF6347}В данный момент битва не ведётся");
	MafGz[0][mStat] = 2;
	CheckMafWar(0, 1);
	format(store, sizeof(store), " [ ADM ]: %s завершил мафиозную войну", PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,store,1);
	return 1;
}
CMD:gotobiz(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 3) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Телепортироваться к бизнесу [ /gotobiz ID ]");
	if(params[0] >= 1 && params[0] <= 200)
	{
	    if(BizzInfo[params[0]][bLab] == 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Позиция бизнеса недоступна [ Только в Бизнес Центре | Тп к терминалу /gototerm ]");
		PPSetPlayerPos(playerid,BizzInfo[params[0]][bX],BizzInfo[params[0]][bY],BizzInfo[params[0]][bZ]);
		S_SetPlayerVirtualWorld(playerid,0,0), SetPlayerInterior(playerid,0);
	}
	else SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Номер бизнеса не меньше 1 и не больше 200");
	return 1;
}
CMD:pricevehup(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Повысить цены транспортных средств [ /pricevehup Сумма ]");
	if(params[0] < 1 || params[0] > 1000000) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Сумма не меньше 1$ и не больше 1.000.000$");
	for(new v = 0; v < 212; v++)
	{
		VehGos[v] += params[0], SaveEconomy(v+400);
	}
	format(store, sizeof(store), " [ ADM ]: %s повысил цены всех т.с. на %d$", PlayerInfo[playerid][pName],params[0]), ABroadCast(COLOR_ADM,store,1);
	AdminLog("pricevehup", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Повысил Цены");
	return 1;
}
CMD:pricevehdown(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Понизить цены транспортных средств [ /pricevehdown Сумма ]");
	if(params[0] < 1 || params[0] > 1000000) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Сумма не меньше 1$ и не больше 1.000.000$");
	for(new v = 0; v < 212; v++)
	{
		if(VehGos[v]-params[0] >= 1000) VehGos[v] -= params[0], SaveEconomy(v+400);
	}
	format(store, sizeof(store), " [ ADM ]: %s понизил цены всех т.с. на %d$", PlayerInfo[playerid][pName],params[0]), ABroadCast(COLOR_ADM,store,1);
	AdminLog("pricevehdown", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Понизил Цены");
	return 1;
}
CMD:reloadpricefrisk(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	for(new s = 0; s < INVENTER; s++)
	{
		friskPrice[s] = friskDefault[s];
		SavePriceFrisk(s);
	}
	format(store, sizeof(store), " [ ADM ]: %s сбросил гос. цены на все предметы", PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,store,1);
	AdminLog("reloadpricefrisk", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Цены");
	return 1;
}
CMD:reloadpricegun(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	for(new g = 1; g < 48; g++)
	{
		gunPrice[g] = gunDefault[g];
		SavePriceGun(g);
	}
	format(store, sizeof(store), " [ ADM ]: %s сбросил гос. цены на всё оружие", PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,store,1);
	AdminLog("reloadpricegun", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Цены");
	return 1;
}
CMD:reloadpriceveh(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	for(new v = 0; v < 212; v++)
	{
		VehGos[v] = vehSumma[v+400];
		SaveEconomy(v+400);
	}
	format(store, sizeof(store), " [ ADM ]: %s сбросил гос. цены на все транспортные средства", PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,store,1);
	AdminLog("reloadveh", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Цены");
	return 1;
}
CMD:reloadpriceskin(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	for(new s = 0; s < 312; s++)
	{
		SkinGos[s] = 10000;
		SaveSkinEconomy(s);
	}
	format(store, sizeof(store), " [ ADM ]: %s сбросил гос. цены на все скины", PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,store,1);
	AdminLog("reloadskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Цены");
	return 1;
}
CMD:reloadbiz(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Сбросить продукты и тарифы бизнеса [ /reloadbiz ID ][ 0 - Сбросить Все ]");
	new string[128];
	if(params[0] == 0)
	{
		for(new b = 0; b < sizeof(BizzInfo); b++) relprodbiz(b);
		format(string, sizeof(string), " [ ADM ]: %s сбросил тарифы и продукты всех бизнесов", PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,string,1);
	}
	else if(params[0] >= 1 && params[0] <= 200)
	{
		relprodbiz(params[0]);
		format(string, sizeof(string), " [ ADM ]: %s сбросил тарифы и продукты бизнеса %s № %d", PlayerInfo[playerid][pName],bizname(params[0]), params[0]), ABroadCast(COLOR_ADM,string,1);
	}
	else SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Номер бизнеса не меньше 1 и не больше 200 [ 0 - Сбросить Все ]");
	return 1;
}
CMD:reloadbizpos(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] <= 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Сбросить позицию бизнеса [ /reloadbizpos ID ][ 0 - Сбросить Все ]");
	new string[128];
	if(params[0] == 0)
	{
		for(new b = 0; b < sizeof(BizzInfo); b++) relposbiz(b);
		format(string, sizeof(string), " [ ADM ]: %s сбросил позицию всех бизнесов", PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,string,1);
	}
	else if(params[0] >= 1 && params[0] <= 200)
	{
		relposbiz(params[0]);
		format(string, sizeof(string), " [ ADM ]: %s сбросил позицию бизнеса %s № %d", PlayerInfo[playerid][pName],bizname(params[0]), params[0]), ABroadCast(COLOR_ADM,string,1);
	}
	else SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Номер бизнеса не меньше 1 и не больше 200 [ 0 - Сбросить Все ]");
	return 1;
}
CMD:rasformbiz(playerid)
{
	if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_LEADER)) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
	for(new b = 0; b < sizeof(BizzInfo); b++)
	{
	    if(b == 10 || b == 20 || b == 30 || b == 40 || b == 50 || b == 60 || b == 70 || b == 80 || b == 90 || b == 100 || b == 110 || b == 120
		|| b == 130 || b == 140 || b == 150 || b == 160 || b == 170 || b == 180 || b == 190 || b == 200 || b == 1 || b == 11 || b == 21
		|| b == 31 || b == 41 || b == 51 || b == 61 || b == 71 || b == 81 || b == 91 || b == 101 || b == 111
		|| b == 121 || b == 131 || b == 141 || b == 151 || b == 161 || b == 171 || b == 181 || b == 191) BizzInfo[b][bMafia] = 5; // Cosa Nostra

	    if(b == 2 || b == 12 || b == 22 || b == 32 || b == 42 || b == 52 || b == 62 || b == 72 || b == 82 || b == 92 || b == 102 || b == 112
	    || b == 122 || b == 132 || b == 142 || b == 152 || b == 162 || b == 172 || b == 182 || b == 192 || b == 3 || b == 13 || b == 23
	 	|| b == 33 || b == 43 || b == 53 || b == 63 || b == 73 || b == 83 || b == 93 || b == 103 || b == 113
	    || b == 123 || b == 133 || b == 143 || b == 153 || b == 163 || b == 173 || b == 183 || b == 193) BizzInfo[b][bMafia] = 6; // Yakuza Mafia

	    if(b == 4 || b == 14 || b == 24 || b == 34 || b == 44 || b == 54 || b == 64 || b == 74 || b == 84 || b == 94 || b == 104 || b == 114
	    || b == 124 || b == 134 || b == 144 || b == 154 || b == 164 || b == 174 || b == 184 || b == 194 || b == 5 || b == 15 || b == 25
	 	|| b == 35 || b == 45 || b == 55 || b == 65 || b == 75 || b == 85 || b == 95 || b == 105 || b == 115
	    || b == 125 || b == 135 || b == 145 || b == 155 || b == 165 || b == 175 || b == 185 || b == 195) BizzInfo[b][bMafia] = 10; // Triada Mafia

	    if(b == 6 || b == 16 || b == 26 || b == 36 || b == 46 || b == 56 || b == 66 || b == 76 || b == 86 || b == 96 || b == 106 || b == 116
	    || b == 126 || b == 136 || b == 146 || b == 156 || b == 166 || b == 176 || b == 186 || b == 196 || b == 7 || b == 17 || b == 27
	 	|| b == 37 || b == 47 || b == 57 || b == 67 || b == 77 || b == 87 || b == 97 || b == 107 || b == 117
	    || b == 127 || b == 137 || b == 147 || b == 157 || b == 167 || b == 177 || b == 187 || b == 197) BizzInfo[b][bMafia] = 12; // Russian Mafia

	    if(b == 8 || b == 18 || b == 28 || b == 38 || b == 48 || b == 58 || b == 68 || b == 78 || b == 88 || b == 98 || b == 108 || b == 118
	    || b == 128 || b == 138 || b == 148 || b == 158 || b == 168 || b == 178 || b == 188 || b == 198 || b == 9 || b == 19 || b == 29
	 	|| b == 39 || b == 49 || b == 59 || b == 69 || b == 79 || b == 89 || b == 99 || b == 109 || b == 119
	    || b == 129 || b == 139 || b == 149 || b == 159 || b == 169 || b == 179 || b == 189 || b == 199) BizzInfo[b][bMafia] = 18; // Arabian Mafia

	    BizzInfo[b][bMafunix] = 0;
		if(BizzInfo[b][bLab] == 1) UpdateBizLabel(b, BizzInfo[b][bLab]);
	    SaveBizz(b);
  	}
  	new string[128];
	format(string, sizeof(string), " [ ADM ]: Админ %s расформировал все бизнесы для мафий",PlayerInfo[playerid][pName]);
	ABroadCast(COLOR_ADM,string,1);
	SendRadioMessage(5,COLOR_LIGHTRED,"{ff9000}[ Mafia War ]: {ffffff}Администрация расформировала все бизнесы");
	SendRadioMessage(6,COLOR_LIGHTRED,"{ff9000}[ Mafia War ]: {ffffff}Администрация расформировала все бизнесы");
	SendRadioMessage(10,COLOR_LIGHTRED,"{ff9000}[ Mafia War ]: {ffffff}Администрация расформировала все бизнесы");
	SendRadioMessage(12,COLOR_LIGHTRED,"{ff9000}[ Mafia War ]: {ffffff}Администрация расформировала все бизнесы");
	SendRadioMessage(18,COLOR_LIGHTRED,"{ff9000}[ Mafia War ]: {ffffff}Администрация расформировала все бизнесы");
	AdminLog("rasformbiz", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
	return 1;
}
CMD:bizmaf(playerid, const params[])
{
	if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_LEADER)) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
	if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Установить бизнес мафии [ /bizmaf ID Фракции № Бизнеса ]");
	if(params[0] != 5 && params[0] != 6 && params[0] != 10 && params[0] != 12 && params[0] != 18) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Только номер мафии [ 5,6,10,12,18 ]");
	if(params[1] > 200 || params[1] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Бизнес не меньше 1 и не больше 200");
	new string[128];
	format(string, sizeof(string), " [ ADM ]: Админ %s установил %s для %s",PlayerInfo[playerid][pName], bizname(params[1]),frakName[params[0]]);
	ABroadCast(COLOR_ADM,string,1);
  	BizzInfo[params[1]][bMafia] = params[0];
  	BizzInfo[params[1]][bMafunix] = 0;
  	if(BizzInfo[params[1]][bLab] == 1) UpdateBizLabel(params[1], BizzInfo[params[1]][bLab]);
  	SaveBizz(params[1]);
	format(string,sizeof(string),"{ff9000}[ Mafia War ]: {ffffff}Администрация передала %s под ваш контроль",bizname(params[1]));
	SendRadioMessage(params[0],COLOR_LIGHTRED,string);
	return 1;
}
CMD:mafship(playerid, const params[])
{
	if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_LEADER)) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Запустить корабль мафии [ /mafship 0 - SF | 1 - LS ]");
	if(mafstat == 1 || mafstat == 3) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Корабль находится в порту San Fierro");
	if(mafstat == 2 || mafstat == 4) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Корабль находится в порту Los Santos");
	if(mafstat == 5) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Корабль покидает порт");
	if(params[0] < 0 || params[0] >= 2) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Такого кода запуска не существует [ /mafship 0 - SF | 1 - LS ]");
	new string[144];
	if(params[0] == 0) format(string, sizeof(string), " [ ADM ]: Админ %s запустил корабль мафии в порт SF",PlayerInfo[playerid][pName]), Mafia_Ship(3);
	else format(string, sizeof(string), " [ ADM ]: Админ %s запустил корабль мафии в порт LS",PlayerInfo[playerid][pName]), Mafia_Ship(4);
	ABroadCast(COLOR_ADM,string,1);
	return 1;
}
CMD:showdip(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] == 0) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Показать дипломатию банд и мафий [ /showdip ID Фракции ]");
	if(params[0] == 5 || params[0] == 6 || params[0] == 10 || params[0] == 12 || params[0] == 13 || params[0] == 14
	|| params[0] == 15 || params[0] == 16 || params[0] == 17 || params[0] == 18 || params[0] == 19 || params[0] == 20)
	{
		ShowDip(playerid, params[0]);
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Дипломатия банд и мафий [ ID 5,6,10,12,13,14,15,16,17,18,19,20 ]");
	return 1;
}
CMD:hpgro(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 4 || PlayerInfo[playerid][pHidden] > 0 || PlayerInfo[playerid][pMedia] >= 2)
	{
		foreach (Player, i)
		{
			if(GetDistanceBetweenPlayers(playerid,i) < 32 && playerid != i)
			{
				ACSetPlayerHealth(i,100);
				SendClientMessage(i, COLOR_GRAD1, "Администратор пополнил вам здоровье.");
			}
		}
		ACSetPlayerHealth(playerid,100);
		SendClientMessage(playerid, COLOR_GRAD1, "Вы пополнили здоровье рядом находящимся игрокам.");
	}
	return 1;
}
CMD:armgro(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 4) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
	foreach (Player, i)
	{
		if(GetDistanceBetweenPlayers(playerid,i) < 32 && playerid != i)
		{
			ACSetPlayerArmour(i, 100);
			SendClientMessage(i, COLOR_GRAD1, " Администратор пополнил вам Броню.");
		}
	}
	ACSetPlayerArmour(playerid, 100);
	SendClientMessage(playerid, COLOR_GRAD1, " Вы пополнили броню рядом находящимся игрокам.");
	return 1;
}
CMD:delaction(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] <= 0) return ErrorMessage(playerid, "{FF6347}Эта команда доступна только администрации");
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Удалить созданные ситуации игрока [ /delaction ID ]");
	if(!IsPlayerConnected(params[0])) return ErrorMessage(playerid, "{FF6347}Этого игрока нет в сети [ Неверный ID ]");
	new kol = 0;
	for(new i = 0; i < 5; i++)
	{
		if(gAction[i][params[0]] == 1) DestroyDynamic3DTextLabel(ActionLabel[i][params[0]]), gAction[i][params[0]] = 0, kol ++, format(ActionText[i][playerid], 20, " ");
	}
	if(kol == 0) return ErrorMessage(playerid, "{FF6347}У этого игрока нет RP ситуаций");
	new string[128];
	format(string, sizeof(string), "* Администратор %s удалил все ваши RP ситуации.", PlayerInfo[playerid][pName]);
	SendClientMessage(params[0], COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), " [ ADM ]: %s[%d] удалил все RP ситуации %s[%d]", PlayerInfo[playerid][pName],playerid,PlayerInfo[params[0]][pName],params[0]);
	ABroadCast(COLOR_ADM,string,1);
	return 1;
}
CMD:veh(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 4) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 4+ ]");
    if(sscanf(params, "iii", params[0],params[1],params[2])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Создать транспорт /veh Модель Цвет1 Цвет2");
	if(params[0] < 400 || params[0] > 611) return ErrorMessage(playerid, "{FF6347}Модель транспорта не меньше 400 и не больше 611");
	if(params[1] < 0 || params[1] > 255 || params[2] < 0 || params[2] > 255) return ErrorMessage(playerid, "{FF6347}Цвет не меньше 0 и не больше 255");
	if(QuanCar >= MAX_MAPVEH) return format(store, sizeof(store), "{FF6347}Лимит создания транспорта: %d", MAX_MAPVEH), ErrorMessage(playerid, store);
    new createid = -1;
    for(new i = 0; i < MAX_MAPVEH; i++)
	{
	    if(CreatedCars[i] == 0) createid = i;
 	}
 	if(createid == -1) return ErrorMessage(playerid, "{FF6347}Ошибка! Нет свободных слотов для транспорта");
    new Float:X,Float:Y,Float:Z,Float:A;
	GetPlayerPos(playerid, X,Y,Z);
	GetPlayerFacingAngle(playerid,A);
	X=X+7.0*floatsin(-A,degrees);
    Y=Y+7.0*floatcos(-A,degrees);
    if(IsABig(params[0])) CreatedCars[createid] = PP_CreateVehicle(CreatedCars[createid], params[0], X,Y,Z+2.0, A+180.0, params[1], params[2], 60000,0);
    else CreatedCars[createid] = PP_CreateVehicle(CreatedCars[createid], params[0], X,Y,Z, A+180.0, params[1], params[2], 60000,0);
	LinkVehicleToInterior(CreatedCars[createid], GetPlayerInterior(playerid));
	SetVehicleVirtualWorld(CreatedCars[createid], GetPlayerVirtualWorld(playerid));
	QuanCar ++;
	Cars[CreatedCars[createid]] = 9999;
	Gas[CreatedCars[createid]] = GasMax;
	AdminLog("veh", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "");
	format(store, sizeof(store), "{0088ff}%s Модель: {ffcc66}%d {0088ff}ID: {ffcc66}%d", vehName[params[0]], params[0], CreatedCars[createid]);
	SendClientMessage(playerid, COLOR_GREY, store);
	return 1;
}
CMD:delveh(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 4) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 4+ ]");
    if(QuanCar <= 0) return ErrorMessage(playerid, "{FF6347}На сервере нет созданного транспорта");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Удалить транспорт /delveh ID (ID транспорта в /dl)");
	if(params[0] < 0 || params[0] >= SKOKOCAROV) return ErrorMessage(playerid, "{FF6347}ID транспорта не меньше 0 и не больше 1999");
	if(Cars[params[0]] == 0) return ErrorMessage(playerid, "{FF6347}Транспорта не существует");
	if(Cars[params[0]] != 9999) return ErrorMessage(playerid, "{FF6347}Этот транспорт не создан администрацией");
	
	for(new i = 0; i < MAX_MAPVEH; i++)
	{
	    if(CreatedCars[i] == params[0])
		{
			ACDestroyVehicle(CreatedCars[i]);
			CreatedCars[i] = 0;
			break;
		}
 	}
 	QuanCar --;
 	PlayerPlaySound(playerid,6801,0,0,0);
	AdminLog("delveh", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "");
	format(store, sizeof(store), "{0088ff}Транспорт ID %d {FF6347}удалён", params[0]);
	SendClientMessage(playerid, COLOR_GREY, store);
	return 1;
}
CMD:rvc(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 4) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 4+ ]");
	if(QuanCar <= 0) return ErrorMessage(playerid, "{FF6347}На сервере нет созданного транспорта");
    for(new i = 0; i < MAX_MAPVEH; i++)
	{
	    if(CreatedCars[i] > 0) ACDestroyVehicle(CreatedCars[i]), CreatedCars[i] = 0;
 	}
    QuanCar = 0;
    format(store, sizeof(store), " [ ADM ]: %s удалил весь созданный транспорт",PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,store,1);
    AdminLog("rvc", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
	return 1;
}
CMD:philinsalon(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 21) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 4+ ]");
	format(store, sizeof(store), "{0088ff}ID Салона: %d", gAutosalon[playerid]);
	SendClientMessage(playerid, COLOR_GREY, store);
	return 1;
}
CMD:tp(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 1 || PlayerInfo[playerid][pHidden] > 0 || PlayerInfo[playerid][pMedia] > 0 || server == 0)
 	{
  		ShowDialog(playerid,75,DIALOG_STYLE_LIST,"{ff9000}Телепорты 1","Тихое Место\nАвтомеханик Хенк\nЛесопилка\nРыбацкая Бухта\nБаза Дальнобойщиков\nЦерковь\nЛавка Лесника\nЧиллиад\nАвтосалон\nГоспиталь\nОружейный Завод\nБанк\nЛуна\nNASA\nКвартиры (1)\nАрхеология\nОбразовательный Центр\nАвиасалон\nЛедовый Дворец","Выбрать","Отмена");
    	return 1;
    }
   	return 1;
}
CMD:tp2(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 1 || PlayerInfo[playerid][pHidden] > 0 || PlayerInfo[playerid][pMedia] > 0 || server == 0)
	{
		ShowDialog(playerid,77,DIALOG_STYLE_LIST,"{ff9000}Телепорты 2","Тихущее Место\nТюнинг SF\nДПС LS-1\nФерма\nКазино 4 Дракона\nТюрьма\nСалон Катеров\nДальнобойщики\nМарс\nКомпьютерный Клуб\nСауна\nAlhambra\nPig Pen\nJizzy","Выбрать","Отмена");
	}
   	return 1;
}
CMD:tp3(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 1 || PlayerInfo[playerid][pHidden] > 0 || PlayerInfo[playerid][pMedia] > 0 || server == 0)
	{
		ShowDialog(playerid,79,DIALOG_STYLE_LIST,"{ff9000}Телепорты 3","IKEA\nЛапландия\nГлавная Ёлка\nЦентр Обмена\nБизнес Центр\nШтраф Стоянка\nВход в Серверную SWAT\nНефтеперерабатывающий Завод\nГосударственный Склад\nРынок LS\nЧёрный Рынок\nСпермобанк\nКлининг LS\nКлининг SF\nКлининг LV\nТрейлерный парк\nИнкассаторы","Выбрать","Отмена");
	}
   	return 1;
}
CMD:spawns(playerid)
{
	if (PlayerInfo[playerid][pSoska] >= 1 || PlayerInfo[playerid][pHidden] > 0 || PlayerInfo[playerid][pMedia] > 0 || server == 0)
 	{
  		ShowDialog(playerid,76,DIALOG_STYLE_LIST,"{0088ff}Телепорты по респам *[RP]Project*","Аэропорт LS\nLSPD\nArmy СВ\nArmy ВМС\nYakuza Mafia\nRussian Mafia\nGrove Street\nBallas Gang\nVagos Gang\nLos Aztecas\nArabian Mafia\nFBI\nПравительство\nCNN\nHitman Agency\nSWAT\nTriada Mafia\nГоспиталь LS\nПожарное Депо\nПсихушка\nSFPD\nCosa Nostra","Выбрать","Отмена");
 	}
	return 1;
}
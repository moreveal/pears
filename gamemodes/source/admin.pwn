
CMD:givemats(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(sscanf(params, "iiii",params[0],params[1],params[2],params[3])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать предметы на склад [ /givemats Организация Предмет Тип Количество ]");
	if(params[2] < 0 || params[2] > 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Тип предметов [ 0 Вещества и патроны, 1 Оружие, 2 Броня ]");
	if(params[3] < 1 || params[3] > 50000) return ErrorMessage(playerid, "{FF6347}Не меньше 1 и не больше 50.000");
	
	new yes;
	if(params[2] == 0) // Обычные Предметы
	{
		if(params[1] >= 4 && params[1] <= 8 || params[1] >= 27 && params[1] <= 30) yes = 1; // Только вещества и патроны
		else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: ID Предметов [ 4-8 Вещества, 27-30 Патроны ]");
	}
	else if(params[2] == 1) // Оружие
	{
		if(params[1] >= 2 && params[1] <= 15 || params[1] == 22 || params[1] == 24 || params[1] == 25 || params[1] == 26 || params[1] == 27 
			|| params[1] == 28 || params[1] == 29 || params[1] == 30 || params[1] == 31 || params[1] == 32 || params[1] == 33 || params[1] == 34) yes = 1; // Только оружие
		else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: ID Оружия [ 2-15, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34 ]");
	}
	else if(params[2] == 2) // Аксессуары
	{
		if(IsArmor(params[1])) yes = 1;
		else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: ID Аксессуаров [ 19142 Бронежилет ]");
	}

	if(yes == 1)
	{
		if(params[0] >= 1 && params[0] <= 22) 
		{
			new put_inva = putsklad(params[0], params[1], params[3], 0, params[2],1); // Кладём предмет
			if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}На складе организации, для этого предмета, нет места");
			new string[160];
			format(string, sizeof(string), " [ ADM ]: %s выдал %s [Кол-во: %d] на склад %s",PlayerInfo[playerid][pName], GetNameThing(1, params[1], params[2], 0), params[2], frakName[params[0]]);
			ABroadCast(COLOR_ADM,string,1);
			AdminLog("givemats", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "Положил на склад предметы");
		}
		else if(params[0] == 0)
		{
			new quan;
			for(new g = 1; g < MAX_ORG; g++) 
			// В организациях никогда не используем OrganInfo[0], всегда g начинается с 1 OrganInfo[1] это LSPD 
			// в OrganInfo[0] сохранения разных других систем не связанных напрямую с организациями
			{
				new put_inva = putsklad(params[0], params[1], params[3], 0, params[2],1); // Кладём предмет
				if(put_inva >= 0) quan ++;
			}

			new string[160];
			format(string, sizeof(string), " [ ADM ]: %s выдал %s [Кол-во: %d] на склад %d организаций из %d",PlayerInfo[playerid][pName], GetNameThing(1, params[1], params[2], 0), params[2], quan, MAX_ORG);
			ABroadCast(COLOR_ADM,string,1);
			AdminLog("givemats", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "Положил на склад предметы");
		}
		else ErrorMessage(playerid, "{FF6347}Организации под этим ID не существует");
	}
	return 1;
}

CMD:delmats(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Удалить боеприпасы со склада [ /delmats ID Организации ]");
	if(params[0] >= 1 && params[0] <= 22)
	{
		new string[144];
	  	format(string, sizeof(string), " [ ADM ]: Админ %s очистил склад: %s",PlayerInfo[playerid][pName],frakName[params[0]]), ABroadCast(COLOR_ADM,string,1);
	   	for(new inva = 0; inva < 20; inva++) 
		{
			OrganInfo[params[0]][gInvent][inva] = 0;
			OrganInfo[params[0]][gInv][inva] = 0;
			OrganInfo[params[0]][gInvType][inva] = 0;
			OrganInfo[params[0]][gInvPara][inva] = 0;
			OrganInfo[params[0]][gInvUpdate][inva] = true;
		}
		OrganInfo[params[0]][gUpdateSklad] = 1;
		foreach(Player,i)
		{
			if(Tabs_Load[i] != 3) continue;
			if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowTabs] != 9999) closetab(i, 1);
		}
		AdminLog("delmats", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], "Очистил Склад");
		OrgLog(params[0], "delmats", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Очистил Склад");
	}
	else ErrorMessage(playerid, "{FF6347}Организации под этим ID не существует");
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
/*CMD:tug(playerid)
{
	new str[144];
	new veh = LichCarID[playerid];
	format(str,sizeof(str),"Моя личная тачка на прицепе у VEH ID: %d",gettug(veh));
	SendClientMessage(playerid, COLOR_GREY, str);
	format(str,sizeof(str),"Моя личная тачка на прицепе у VEH ID: %d {00CC00}NEW",GetVehicleTrailer(veh));
	SendClientMessage(playerid, COLOR_GREY, str);
	return 1;
}*/
CMD:mysql(playerid)
{
	new stats[300];
	mysql_stat(stats, sizeof(stats), pearsq);

	printf("%s\n", stats);
    return true;
}
CMD:stopmaf(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 5) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 5+ ]");
	if(MafGz[0][mStat] == 0) return ErrorMessage(playerid, "{FF6347}В данный момент битва не ведётся");
	MafGz[0][mStat] = 2;
	CheckMafWar(0, 1);

	new string[120];
	format(string, sizeof(string), " [ ADM ]: %s завершил мафиозную войну", PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,string,1);
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
		S_SetPlayerVirtualWorld(playerid,0,0), PPSetPlayerInterior(playerid,0);
	}
	else SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Номер бизнеса не меньше 1 и не больше 200");
	return 1;
}
CMD:pricevehup(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Повысить цены транспортных средств [ /pricevehup Сумма ]");
	if(params[0] < 1 || params[0] > 1000000) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Сумма не меньше 1$ и не больше 1.000.000$");
	for(new v = 0; v < 211 + sizeof(vehNameCustom) + 1; v++)
	{
		VehGos[v] += params[0];
		SaveVehiclePrice(v);
	}
	new string[120];
	format(string, sizeof(string), " [ ADM ]: %s повысил цены всех т.с. на %d$", PlayerInfo[playerid][pName],params[0]), ABroadCast(COLOR_ADM,string,1);
	AdminLog("pricevehup", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Повысил Цены");
	return 1;
}
CMD:pricevehdown(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Понизить цены транспортных средств [ /pricevehdown Сумма ]");
	if(params[0] < 1 || params[0] > 1000000) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Сумма не меньше 1$ и не больше 1.000.000$");
	for(new v = 0; v < 211 + sizeof(vehNameCustom) + 1; v++)
	{
		if(VehGos[v]-params[0] >= 1000) VehGos[v] -= params[0], SaveVehiclePrice(v);
	}
	new string[120];
	format(string, sizeof(string), " [ ADM ]: %s понизил цены всех т.с. на %d$", PlayerInfo[playerid][pName],params[0]), ABroadCast(COLOR_ADM,string,1);
	AdminLog("pricevehdown", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Понизил Цены");
	return 1;
}
CMD:reloadpricefrisk(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	for(new s = 0; s < sizeof(friskName); s++)
	{
		friskPrice[s] = friskDefault[s];
		SavePriceFrisk(s);
	}
	new string[120];
	format(string, sizeof(string), " [ ADM ]: %s сбросил гос. цены на все предметы", PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,string,1);
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
	new string[120];
	format(string, sizeof(string), " [ ADM ]: %s сбросил гос. цены на всё оружие", PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,string,1);
	AdminLog("reloadpricegun", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Цены");
	return 1;
}
CMD:reloadpriceveh(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	for(new v = 0; v < 211 + sizeof(vehNameCustom) + 1; v++)
	{
		if(v <= 211) VehGos[v] = vehSumma[v];
		else VehGos[v] = vehSummaCustom[v - 212];
		SaveVehiclePrice(v);
	}
	new string[120];
	format(string, sizeof(string), " [ ADM ]: %s сбросил гос. цены на все транспортные средства", PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,string,1);
	AdminLog("reloadveh", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Цены");
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
	SendRadioMessage(5,COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: {ffcc66}Администрация расформировала все бизнесы");
	SendRadioMessage(6,COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: {ffcc66}Администрация расформировала все бизнесы");
	SendRadioMessage(10,COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: {ffcc66}Администрация расформировала все бизнесы");
	SendRadioMessage(12,COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: {ffcc66}Администрация расформировала все бизнесы");
	SendRadioMessage(18,COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: {ffcc66}Администрация расформировала все бизнесы");
	AdminLog("rasformbiz", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
	return 1;
}
CMD:bizmaf(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 10) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
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
	format(string,sizeof(string),"{0088ff}[ Mafia War ]: {ffcc66}Администрация передала %s под ваш контроль",bizname(params[1]));
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

	new vehiclename[64], color1, color2;
    if(!sscanf(params, "s[64]ii", vehiclename,color1,color2)) AdmCmdVeh(playerid, vehiclename, color1, color2);
	else if(!sscanf(params, "s[64]", vehiclename))
	{
		new colorveh = 1 + random(254); // Color Vehicle
		AdmCmdVeh(playerid, vehiclename, colorveh, colorveh);
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Создать транспорт [ /veh VehID or Name Color1 Color2 ]");
	return 1;
}

stock AdmCmdVeh(playerid, const vehiclename[], color1, color2)
{
	new model = ReturnVehicle(vehiclename);
	if(model == -1) return ErrorMessage(playerid, "{FF6347}Неверный ID или название транспорта (400 - 612, 2000 и выше - кастомные авто)");
	if(!IsAVehExisting(model)) return ErrorMessage(playerid, "{FF6347}Неверный ID или название транспорта (400 - 612, 2000 и выше - кастомные авто)");

	if(color1 < 0 || color1 > 255 || color2 < 0 || color2 > 255) return ErrorMessage(playerid, "{FF6347}Цвет не меньше 0 и не больше 255");
	if(QuanCar >= MAX_MAPVEH) return ErrorMessage(playerid, "{FF6347}Лимит создания транспорта администрацией");
    new createid = -1;
    for(new i = 0; i < MAX_MAPVEH; i++)
	{
	    if(CreatedCars[i] == 0) createid = i;
 	}
 	if(createid == -1) return ErrorMessage(playerid, "{FF6347}Ошибка! Нет свободных слотов для транспорта");

	new Float:frontme_pos[4];
	frontme(playerid, 7.0, frontme_pos[0], frontme_pos[1], frontme_pos[2], frontme_pos[3]);
    if(IsABig(model)) CreatedCars[createid] = PP_CreateVehicle(model, frontme_pos[0], frontme_pos[1], frontme_pos[2]+2.0, frontme_pos[3]+180.0, color1, color2, -1,0, -1, 0.0);
    else CreatedCars[createid] = PP_CreateVehicle(model, frontme_pos[0], frontme_pos[1], frontme_pos[2], frontme_pos[3]+180.0, color1, color2, -1,0, -1, 0.0);
	LinkVehicleToInterior(CreatedCars[createid], GetPlayerInterior(playerid));
	SetVehicleVirtualWorld(CreatedCars[createid], GetPlayerVirtualWorld(playerid));
	QuanCar ++;
	Cars[CreatedCars[createid]] = 9999;
	Gas[CreatedCars[createid]] = GasMax;
	AdminLog("veh", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", model, "");
	SendClientMessage(playerid, COLOR_GREY, "{0088ff}%s Модель: {ffcc66}%d {0088ff}ID: {ffcc66}%d {cccccc}(col1 %d, col2 %d)", GetVehicleName(model), model, CreatedCars[createid], color1, color2);
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
	SendClientMessage(playerid, COLOR_GREY, "{0088ff}Транспорт ID %d {FF6347}удалён", params[0]);
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
	new string[140];
    format(string, sizeof(string), " [ ADM ]: %s удалил весь созданный транспорт",PlayerInfo[playerid][pName]), ABroadCast(COLOR_ADM,string,1);
    AdminLog("rvc", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
	return 1;
}
CMD:philinsalon(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 21) return ErrorMessage(playerid, "{FF6347}Это действие вам недоступно [ Админ 4+ ]");
	SendClientMessage(playerid, COLOR_GREY, "{0088ff}ID Салона: %d", gAutosalon[playerid]);
	return 1;
}
CMD:tp(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 1 || PlayerInfo[playerid][pHidden] > 0 || PlayerInfo[playerid][pMedia] > 0 || server == 0)
 	{
  		ShowDialog(playerid,75,DIALOG_STYLE_LIST,"{ff9000}Телепорты 1","Тихое Место\nАвтомеханик Хенк\nЛесопилка\nРыбацкая Бухта\nБаза Дальнобойщиков\nЦерковь\nЛавка Лесника\nЧиллиад\nГоспиталь\nОружейный Завод\nБанк\nЛуна\nNASA\nКвартиры (1)\nАрхеология\nОбразовательный Центр\nЛедовый Дворец","Выбрать","Отмена");
    	return 1;
    }
   	return 1;
}
CMD:tp2(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 1 || PlayerInfo[playerid][pHidden] > 0 || PlayerInfo[playerid][pMedia] > 0 || server == 0)
	{
		ShowDialog(playerid,77,DIALOG_STYLE_LIST,"{ff9000}Телепорты 2","Тихущее Место\nТюнинг SF\nДПС LS-1\nФерма\nКазино 4 Дракона\nТюрьма\nСалон Катеров\nДальнобойщики\nМарс\nКомпьютерный Клуб\nСауна\nУтиль\nNGSA Train","Выбрать","Отмена");
	}
   	return 1;
}
CMD:tp3(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 1 || PlayerInfo[playerid][pHidden] > 0 || PlayerInfo[playerid][pMedia] > 0 || server == 0)
	{
		ShowDialog(playerid,79,DIALOG_STYLE_LIST,"{ff9000}Телепорты 3","IKEA\nЦентр Обмена\nБизнес Центр\nШтраф Стоянка\nВход в Серверную SWAT\nНефтеперерабатывающий Завод\nГосударственный Склад\nРынок LS\nЧёрный Рынок\nСпермобанк\nКлининг LS\nКлининг SF\nКлининг LV\nТрейлерный парк\nИнкассаторы","Выбрать","Отмена");
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
CMD:readconnect(playerid)
{
	if(PlayerInfo[playerid][pSoska] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(GetPVarInt(playerid,"Readcon") == 0) SetPVarInt(playerid,"Readcon",1), SendClientMessage(playerid, COLOR_GREY, "[ Мысли ADM ]: {ffcc66}Просмотр Connect Log {99ff66}Активирован");
	else SetPVarInt(playerid,"Readcon",0), SendClientMessage(playerid, COLOR_GREY, "[ Мысли ADM ]: {ffcc66}Просмотр Connect Log {FF6347}Отключён");
	return 1;
}
CMD:readkill(playerid)
{
	if(PlayerInfo[playerid][pSoska] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(GetPVarInt(playerid,"Readkill") == 0) SetPVarInt(playerid,"Readkill",1), SendClientMessage(playerid, COLOR_GREY, "[ Мысли ADM ]: {ffcc66}Просмотр смертей {99ff66}Активирован");
	else SetPVarInt(playerid,"Readkill",0), SendClientMessage(playerid, COLOR_GREY, "[ Мысли ADM ]: {ffcc66}Просмотр смертей {FF6347}Отключён");
  	return 1;
}
CMD:readdm(playerid)
{
	if(PlayerInfo[playerid][pSoska] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(GetPVarInt(playerid,"Readdm") == 0) SetPVarInt(playerid,"Readdm",1), SendClientMessage(playerid, COLOR_GREY, "[ Мысли ADM ]: {ffcc66}Просмотр нарушений DeathMath {99ff66}Активирован");
	else SetPVarInt(playerid,"Readdm",0), SendClientMessage(playerid, COLOR_GREY, "[ Мысли ADM ]: {ffcc66}Просмотр нарушений DeathMath {FF6347}Отключён");
	return 1;
}
CMD:readhit(playerid)
{
	if(PlayerInfo[playerid][pSoska] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(GetPVarInt(playerid,"Readhit") == 0) SetPVarInt(playerid,"Readhit",1), SendClientMessage(playerid, COLOR_GREY, "[ Мысли ADM ]: {ffcc66}Просмотр попаданий {99ff66}Активирован");
	else SetPVarInt(playerid,"Readhit",0), SendClientMessage(playerid, COLOR_GREY, "[ Мысли ADM ]: {ffcc66}Просмотр попаданий {FF6347}Отключён");
  	return 1;
}
CMD:rvanka(playerid)
{
	if(PlayerInfo[playerid][pSoska] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(GetPVarInt(playerid,"Readcheat") == 0) SetPVarInt(playerid,"Readcheat",1), SendClientMessage(playerid, COLOR_GREY, "[ Мысли ADM ]: {ffcc66}Просмотр rvanka {99ff66}Активирован");
	else SetPVarInt(playerid,"Readcheat",0), SendClientMessage(playerid, COLOR_GREY, "[ Мысли ADM ]: {ffcc66}Просмотр rvanka {FF6347}Отключён");
  	return 1;
}
CMD:setbiz(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
	if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Установить номер бизнеса игроку [ /setbiz ID номер ]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Его вообще нет..");
	PlayerInfo[params[0]][pBusiness] = params[1];
	new string[144];
	format(string, sizeof(string), "{FFFFFF}Игроку %s установлен номер бизнеса {0088ff}%d", PlayerInfo[params[0]][pName],params[1]);
	SendClientMessage(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "{FFFFFF}Администрация установила вам номер бизнеса %d",params[1]);
	SendClientMessage(params[0], COLOR_GREY, string);
	return 1;
}
CMD:setdom(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
	if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Установить номер дома игроку [ /setdom ID номер ]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Его вообще нет..");
	PlayerInfo[params[0]][pDom]=params[1];
	new string[144];
	format(string, sizeof(string), "{FFFFFF}Игроку %s установлен номер дома {0088ff}%d", PlayerInfo[params[0]][pName],params[1]);
	SendClientMessage(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "{FFFFFF}Администрация установила вам номер дома %d",params[1]);
	SendClientMessage(params[0], COLOR_GREY, string);
	return 1;
}
CMD:setroom(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");
	if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Установить номер квартиры игроку [ /setroom ID номер ]");
	if(!IsPlayerConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Его вообще нет..");
	PlayerInfo[params[0]][pRoom]=params[1];
	new string[144];
	format(string, sizeof(string), "{FFFFFF}Игроку %s установлен номер квартиры {0088ff}%d", PlayerInfo[params[0]][pName],params[1]);
	SendClientMessage(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "{FFFFFF}Администрация установила вам номер квартиры %d",params[1]);
	SendClientMessage(params[0], COLOR_GREY, string);
	return 1;
}
CMD:rkasino(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 20) return 1;
	OrganInfo[0][gdrugs2] = 0;
	OrganInfo[0][gdrugs1] = 0;
	SaveOrgan(0);
	SendClientMessage(playerid, COLOR_GREY, "[ Pears ] Соотношение побед в казино очищено");
	return 1;
}
CMD:checkas(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 22) return 1;
	new year, month,day;
 	getdate(year, month, day);
	new str[100],sctring[400];
   	if(ServerInfo[56] != month) format(str,sizeof(str),"\n{99ff66}Будет в этом месяце: {cccccc}%d числа %d проц",ServerInfo[57], ServerInfo[58]), strcat(sctring,str);
	else format(str,sizeof(str),"\n{FF6347}Будет в следующем месяце: {cccccc}%d числа %d проц",ServerInfo[57], ServerInfo[58]), strcat(sctring,str);
    ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{0088ff}Информация",sctring,"Oк","");
	return 1;
}
CMD:invest(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 10 && PlayerInfo[playerid][pMedia] <= 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать");
	new str[100],sctring[600];
 	format(str,sizeof(str),"{ff9000} Общак Администрации");
  	strcat(sctring,str);
   	format(str,sizeof(str),"\n{cccccc}Сумма: {99ff66}%d$ [%s]",ServerInfo[32], get_k(ServerInfo[32]));
    strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}Золото: {ffcc00}%dG",ServerInfo[33]);
    strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}Взять Деньги {ffffff}/getinvest");
    strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}Взять Золото {ffffff}/getgold {cccccc}(только для кураторов)");
    strcat(sctring,str);
    format(str,sizeof(str),"\n\n{cccccc}- Никогда не берите слишком много в качестве приза на мероприятия");
    strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}- Обязательно делайте скриншоты растрат из общака");
    strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}- Не ломайте экономику сервера заоблачными суммами");
    strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}- Помните, что любые манипуляции с деньгами или золотом тщательно логируются");
    strcat(sctring,str);
    ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Общак Администрации",sctring,"Oк","");
	return 1;
}
CMD:giveinvest(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] >= 22 && (strfind(PlayerInfo[playerid][pName],"Elon_Musk",true) != (-1) || strfind(PlayerInfo[playerid][pName],"Cardinale_Reveal",true) != (-1)))
    {
		if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Положить 0-деньги | 1-золото в общак администрации [ /giveinvest ID Количество ]");
		if(params[0] > 1 || params[0] < 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: 0-деньги 1-золото");
		new string[144];
		if(params[0] == 1)
		{
			if(params[1] > 100000 || params[1] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не больше 100.000 и не меньше 1");
			ServerInfo[33] += params[1];
			SaveServer(33);
			format(string, sizeof(string), " [ ADM ]: %s начислил в общак администрации {ffcc00}%d грамм золота",PlayerInfo[playerid][pName] ,params[1]);
			ABroadCast(COLOR_ADM,string,1);
			AdminLog("giveinvest", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[1], "Начислил Золото");
		}
		else
		{
			if(params[1] > 100000000 || params[1] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не больше 100.000.000 и не меньше 1");
			ServerInfo[32] += params[1];
			SaveServer(32);
			format(string, sizeof(string), " [ ADM ]: %s начислил в общак администрации {99ff66}%d$ [%s]",PlayerInfo[playerid][pName] ,params[1], get_k(params[1]));
			ABroadCast(COLOR_ADM,string,1);
			AdminLog("giveinvest", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[1], "Начислил Деньги");
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Кхм.. я не могу это сделать");
	return 1;
}
CMD:getinvest(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] >= 10 || PlayerInfo[playerid][pMedia] >= 2)
    {
		if(sscanf(params, "is[24]",params[0],params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Взять деньги из общака администрации [ /getinvest Количество Причина ]");
		if(PlayerInfo[playerid][pSoska] >= 10)
		{
			if(params[0] > 10000000 || params[0] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не больше 10.000.000$ и не меньше 1$");
		}
		else
		{
			if(params[0] > 1000000 || params[0] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не больше 1.000.000$ и не меньше 1$");
		}
		if(checksimvol(params[1])) return ErrorMessage(playerid, "{FF6347}Вы используете запрещённый символ\n{cccccc}Используйте, буквы и цифры");
		if(ServerInfo[32] < params[0]) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: В общаке администрации нет столько денег");
		if(strlen(params[1]) > 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Максимальное количество символов: 20");
		new string[144];
		ServerInfo[32] -= params[0];
		SaveServer(32);
		oGivePlayerMoney(playerid, params[0]);
		PlayerPlaySound(playerid,6400,0,0,0);
		if(PlayerInfo[playerid][pSoska] >= 10) format(string, sizeof(string), " [ ADM ]: Админ %s берёт из общака администрации %d$ [%s] [Цель: %s]",PlayerInfo[playerid][pName] ,params[0],get_k(params[0]),params[1]);
		else format(string, sizeof(string), " [ ADM ]: Медиа %s берёт из общака администрации %d$ [%s] [Цель: %s]",PlayerInfo[playerid][pName] ,params[0],get_k(params[0]),params[1]);
		ABroadCast(COLOR_ADM,string,1);
		MoneyLog("getinvest", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], params[1]);
		AdminLog("getinvest", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], params[1]);
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Кхм.. я не могу это сделать");
	return 1;
}
CMD:getgold(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] <= 13) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать");
	if(sscanf(params, "is[144]",params[0],params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Взять золото из общака администрации [ /getgold Количество Причина ]");
	if(params[0] > 10000 || params[0] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не больше 10000 и не меньше 1");
	if(ServerInfo[33] < params[0]) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: В общаке администрации нет столько золота");
	if(strlen(params[1]) > 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Максимальное количество символов: 20");
	if(checksimvol(params[1])) return ErrorMessage(playerid, "{FF6347}Вы используете запрещённый символ\n{cccccc}Используйте, буквы и цифры");
	new string[144];
	ServerInfo[33] -= params[0];
	SaveServer(33);
	PlayerInfo[playerid][pDonateMoney] += params[0];
	if(PlayerInfo[playerid][pAchieve][26] == 0 && PlayerInfo[playerid][pDonateMoney] >= 10000) AchievePlayer(playerid, 26, 1);
	mysql_save(playerid, 4);
	PlayerPlaySound(playerid,6400,0,0,0);
	format(string, sizeof(string), " [ ADM ]: %s берёт из общака администрации %d грамм золота [Цель: %s]",PlayerInfo[playerid][pName] ,params[0],params[1]);
	ABroadCast(COLOR_ADM,string,1);
	AdminLog("getgold", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", params[0], params[1]);
	return 1;
}
CMD:block(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 20) return 1;
	if(!sscanf(params, "i",params[0]))
	{
		if(params[0] > 3 || params[0] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: [1 Рулетка] [2 Центр Обмена] [3 Редактор Мебели]");
		if(params[0] == 1)
		{
			if(Blockas[2] == 0)
			{
				Blockas[2] = 1;
				SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Рулетка: {ff0000}Закрыта");
			}
			else if(Blockas[2] == 1)
			{
				Blockas[2] = 0;
				SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Рулетка: {00cc00}Открыта");
			}
		}
		else if(params[0] == 1)
		{
			if(Blockas[3] == 0)
			{
				Blockas[3] = 1;
				SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Центр Обмена: {ff0000}Закрыт");
			}
			else if(Blockas[3] == 1)
			{
				Blockas[3] = 0;
				SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Центр Обмена: {00cc00}Открыт");
			}
		}
		else if(params[0] == 2)
		{
			if(Blockas[4] == 0)
			{
				Blockas[4] = 1;
				SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Редактор Мебели: {ff0000}Закрыт");
			}
			else if(Blockas[4] == 1)
			{
				Blockas[4] = 0;
				SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Редактор Мебели: {00cc00}Открыт");
			}
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: [1 Рулетка] [2 Центр Обмена] [3 Редактор Мебели]");
	return 1;
}
CMD:slapper(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 22) return 1;
	if(!sscanf(params, "i",params[0])) 
	{
		kogofind = params[0];
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehicleZAngle(GetPlayerVehicleID(playerid), 180.0);
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чек координат ID");
	return 1;
}
CMD:veloc(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 22) return 1;
	if(!sscanf(params, "i",params[0])) camerni = params[0];
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чек скорости пешком включён");
	return 1;
}
CMD:coord(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 22) return 1;
	if(!sscanf(params, "i",params[0])) coordmasta = params[0];
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Просмотр сдвига по координатам");
	return 1;
}
CMD:knoper(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 22) return 1;
	if(knoper == 0) knoper = 1, SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чек кнопок On");
	else knoper = 0, SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чек кнопок Off");
	return 1;
}
CMD:animer(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] < 22) return 1;
	if(!sscanf(params, "i",params[0])) testanti = params[0];
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чек анимации ID");
	return 1;
}
CMD:protect(playerid)
{
	if(PlayerInfo[playerid][pSoska] >= 22 && (strfind(PlayerInfo[playerid][pName],"Elon_Musk",true) != (-1) || strfind(PlayerInfo[playerid][pName],"Cardinale_Reveal",true) != (-1)) )
	{
		PlayerPlaySound(playerid,40405,0,0,0);
       	new str[150],sctring[900];
       	if(protect[0] == 0) format(str,sizeof(str),"{cccccc}Air Slap Vehicle RakNet {00cc00}[On]\n"),strcat(sctring,str);
       	else if(protect[0] == 1) format(str,sizeof(str),"{cccccc}Air Slap Vehicle RakNet {ffcc00}[Chat]\n"),strcat(sctring,str);
       	else if(protect[0] == 2) format(str,sizeof(str),"{cccccc}Air Slap Vehicle RakNet {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[1] == 0) format(str,sizeof(str),"{cccccc}Trolling Vehicle {00cc00}[On]\n"),strcat(sctring,str);
       	else if(protect[1] == 1) format(str,sizeof(str),"{cccccc}Trolling Vehicle  {ffcc00}[Chat]\n"),strcat(sctring,str);
       	else if(protect[1] == 2) format(str,sizeof(str),"{cccccc}Trolling Vehicle  {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[2] == 0) format(str,sizeof(str),"{cccccc}Teleport in Vehicle {00cc00}[On]\n"),strcat(sctring,str);
       	else if(protect[2] == 1) format(str,sizeof(str),"{cccccc}Teleport in Vehicle {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[3] == 0) format(str,sizeof(str),"{cccccc}Flood Component {00cc00}[On]\n"),strcat(sctring,str);
       	else if(protect[3] == 1) format(str,sizeof(str),"{cccccc}Flood Component {ffcc00}[Chat]\n"),strcat(sctring,str);
       	else if(protect[3] == 2) format(str,sizeof(str),"{cccccc}Flood Component {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[4] == 0) format(str,sizeof(str),"{cccccc}Car Changer {00cc00}[On]\n"),strcat(sctring,str);
       	else if(protect[4] == 1) format(str,sizeof(str),"{cccccc}Car Changer {ffcc00}[Chat]\n"),strcat(sctring,str);
       	else if(protect[4] == 2) format(str,sizeof(str),"{cccccc}Car Changer {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[5] == 0) format(str,sizeof(str),"{cccccc}Teleport Player {00cc00}[On]\n"),strcat(sctring,str);
       	else if(protect[5] == 1) format(str,sizeof(str),"{cccccc}Teleport Player {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[6] == 0) format(str,sizeof(str),"{cccccc}Протокол игнорирования рассинхрона {00cc00}[On]\n"),strcat(sctring,str);
       	else if(protect[6] == 1) format(str,sizeof(str),"{cccccc}Протокол игнорирования рассинхрона {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[7] == 0) format(str,sizeof(str),"{cccccc}Защита от ошибочного кика на спавне {00cc00}[On]\n"),strcat(sctring,str);
       	else if(protect[7] == 1) format(str,sizeof(str),"{cccccc}Защита от ошибочного кика на спавне {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[8] == 0) format(str,sizeof(str),"{cccccc}Invalid Spawn {00cc00}[On]\n"),strcat(sctring,str);
       	else if(protect[8] == 1) format(str,sizeof(str),"{cccccc}Invalid Spawn {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[9] == 0) format(str,sizeof(str),"{cccccc}Rvanka Vehicle Update {00cc00}[On]\n"),strcat(sctring,str);
       	else if(protect[9] == 1) format(str,sizeof(str),"{cccccc}Rvanka Vehicle Update {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[10] == 0) format(str,sizeof(str),"{cccccc}Teleport Player Reset Pos {00cc00}[On]\n"),strcat(sctring,str);
       	else if(protect[10] == 1) format(str,sizeof(str),"{cccccc}Teleport Player Reset Pos {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[12] == 0) format(str,sizeof(str),"{cccccc}Fly (warning) {99ff66}[On]\n"),strcat(sctring,str);
       	else if(protect[12] == 1) format(str,sizeof(str),"{cccccc}Fly (warning) {ffcc00}[Chat]\n"),strcat(sctring,str);
       	else if(protect[12] == 2) format(str,sizeof(str),"{cccccc}Fly (warning) {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[13] == 0) format(str,sizeof(str),"{cccccc}CoordMaster {99ff66}[On]\n"),strcat(sctring,str);
       	else if(protect[13] == 1) format(str,sizeof(str),"{cccccc}CoordMaster {ffcc00}[Chat]\n"),strcat(sctring,str);
       	else if(protect[13] == 2) format(str,sizeof(str),"{cccccc}CoordMaster {ff0000}[Off]\n"),strcat(sctring,str);
       	if(protect[14] == 0) format(str,sizeof(str),"{cccccc}Damager {99ff66}[On]\n"),strcat(sctring,str);
       	else if(protect[14] == 1) format(str,sizeof(str),"{cccccc}Damager {ffcc00}[Chat]\n"),strcat(sctring,str);
       	else if(protect[14] == 2) format(str,sizeof(str),"{cccccc}Damager {ff0000}[Off]\n"),strcat(sctring,str);
    	ShowDialog(playerid,868,DIALOG_STYLE_LIST,"{0088ff}Protect Project",sctring,"Выбор","Отмена");
	}
	return 1;
}
CMD:antieblo(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 22) return 1;
	if(antieblo == 0){ antieblo = 1; SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: АнтиЧит на телепорт Транспорта {00cc00}Включен");}
	else { antieblo = 0;  SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: АнтиЧит на телепорт Транспорта {ff0000}Отключен");}
	return 1;
}
CMD:gpci(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] <= 2 && PlayerInfo[playerid][pHidden] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Посмотреть хеш Windows [ /gpci ID ]");
	if(!IsOnline(params[0])) return ErrorText(playerid, "[ Мысли ]: Игрока нет в сети");
	new string[144],buffer[50+1];
    GetPlayerClientID(params[0], buffer);
 	format(string, sizeof(string), "%s GPCI: {ff9000}%s", PlayerInfo[params[0]][pName], buffer);
    SendClientMessage(playerid, COLOR_GREY, string);
 	return 1;
}
CMD:loss(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] <= 0 && PlayerInfo[playerid][pHidden] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Посмотреть потерянные пакеты игрока [ /loss ID ]");
	if(!IsOnline(params[0])) return ErrorText(playerid, "[ Мысли ]: Игрока нет в сети");
	new string[144];
 	format(string, sizeof(string), "%s потерянные пакеты: %.2f проц.", PlayerInfo[params[0]][pName], NetStats_PacketLossPercent(params[0]));
    SendClientMessage(playerid, COLOR_GREY, string);
 	return 1;
}
CMD:geo(playerid, const params[])
{
	if(PlayerInfo[playerid][pSoska] <= 2 && PlayerInfo[playerid][pHidden] == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Посмотреть геолокацию игрока [ /geo ID ]");
	if(!IsOnline(params[0])) return ErrorText(playerid, "[ Мысли ]: Игрока нет в сети");
	new country[144], city[144], isp[144], string[144];
 	//GetPlayerCountry(params[0], country, sizeof(country));
 	//GetPlayerISP(params[0], isp, sizeof(isp));
 	//GetPlayerCity(params[0], city, sizeof(city));
 	format(string, sizeof(string), "%s: {FF3300}%s {FFFFFF}| {1975FF}%s {33CC00}| %s", PlayerInfo[params[0]][pName], country, isp, city);
    SendClientMessage(playerid, COLOR_GREY, string);
 	return 1;
}


function Call_Punishments(playerid)
{
	new rows, str[480], sctring[12800], datad1[24], datad2[24], datad3[24], datun, datro[64], kol, qwer[60], tyear, tmonth, tday, thour, tminute, tsecond;
	cache_get_row_count(rows);
	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name(i, "player", datad1, 24);
		cache_get_value_name(i, "sender", datad3, 24);
		cache_get_value_name(i, "action", datad2, 24);
		cache_get_value_name_int(i, "unix", datun);
		cache_get_value_name(i, "rows", datro,64 );
		stamp2datetime(datun, tyear, tmonth, tday, thour, tminute, tsecond, 3);
		format(str,sizeof(str),"{cccccc}[ %02d.%02d.%d %02d:%02d ] /%s %s от %s. Причина: %s.\n", tday, tmonth, tyear, thour, tminute, datad2, datad1,datad3, datro), strcat(sctring,str);
		kol ++;
	}
	if(kol >= 1)
	{
		format(qwer,sizeof(qwer),"{0088ff}Лог наказаний %s",datad1);
		ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,qwer,sctring,"Ок","");
	}
	else if(kol == 0) ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{000000}.","{cccccc}По запросу ничего не найдено","Ок","");
	return 1;
}

function Call_PunishmentsName(playerid, const parama)
{
	new string[310];
	new rows, datad1;
	cache_get_row_count(rows);
	if(rows)
	{
		cache_get_value_name_int(0, "user_id", datad1);
		format(string, sizeof(string), "SELECT * FROM `admin_logs` WHERE `playerid` = '%d' AND (`action` = 'warn' OR `action` = 'unwarn' OR `action` = 'mute' OR `action` = 'unmute' OR `action` = 'prison' OR `action` = 'unprison' OR `action` = 'ban' OR `action` = 'unban' OR `action` = 'kick') ORDER BY `unix` DESC LIMIT 40", datad1);
		mysql_tquery(pearsq_2, string, "Call_Punishments", "d", playerid);
	}
	else ErrorMessage(playerid, "{FF6347}Аккаунт не найден");
	return 1;
}

stock PunishmentsLogs(playerid, target)
{
	if(AntiFloodMysqlRequest(playerid, 30)) return 1;
	new string[310];
	ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{000000}.","{cccccc}Поиск логов...","*","");
	format(string, sizeof(string), "SELECT * FROM `admin_logs` WHERE `playerid` = '%d' AND (`action` = 'warn' OR `action` = 'unwarn' OR `action` = 'mute' OR `action` = 'unmute' OR `action` = 'prison' OR `action` = 'unprison' OR `action` = 'ban' OR `action` = 'unban' OR `action` = 'kick') ORDER BY `unix` DESC LIMIT 40", PlayerInfo[target][pID]);
	mysql_tquery(pearsq_2, string, "Call_Punishments", "d", playerid);
	return 1;
}
CMD:punishments(playerid,const params[])
{
	if(PlayerInfo[playerid][pSoska] == 0) return 0;
	if(sscanf(params, "s[121]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Посмотреть нарушения игрока [ /punishments ID/NickName ]");
	if(strlen(params[0]) > 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Длинна никнейма не больше 20-ти символов");
	new giveplayerid;
	giveplayerid = ReturnUser(params[0], 1);
	if(IsPlayerConnected(giveplayerid)) PunishmentsLogs(playerid, giveplayerid);
	else
	{
		if(!CheckRP_Nickname(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Игрок offline, попробую использовать его никнейм. Пример: Lol_Lolkin");
		new string[128];
		format(string,sizeof(string),"SELECT * FROM `pp_igroki` WHERE `Name` = '%s'", params[0]);
		mysql_tquery(pearsq, string, "Call_PunishmentsName", "ds", playerid, params[0]);
	}
	return 1;
}
CMD:cp(playerid, const params[]) return cmd_punishments(playerid, params);
CMD:checkpunish(playerid, const params[]) return cmd_punishments(playerid, params);
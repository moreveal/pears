stock showDialogInteriorDom(playerid)
{
    if(MenuInfo[playerid][zStat] > 0) return 1;
    if(DP[0][playerid] == 0) ShowDialog(playerid,920,DIALOG_STYLE_LIST,"{ff9000}Дом {cccccc}[Переместить Предмет]","{cccccc}Список {ff9000}>>\n{cccccc}Выбрать Предмет","Выбрать","Отмена");
	else if(DP[0][playerid] == 1) ShowDialog(playerid,911,DIALOG_STYLE_LIST,"{ff9000}Дом {cccccc}[Изменить Текстуры]","{cccccc}Список {ff9000}>>\n{cccccc}Выбрать Предмет","Выбрать","Отмена");
	else if(DP[0][playerid] == 2) ShowDialog(playerid,921,DIALOG_STYLE_LIST,"{ff9000}Дом {cccccc}[Убрать Предмет]","{cccccc}Список {ff9000}>>\n{cccccc}Выбрать Предмет","Выбрать","Отмена");
	return 1;
}

stock setDomDefaultFrame(d) // Ставим дефолтный каркас в дом
{
	DomInfo[d][dOmodel][0] = 14713;
	GetCoordFrame(14713, DomInfo[d][dOx][0], DomInfo[d][dOy][0], DomInfo[d][dOz][0], DomInfo[d][dOrx][0], DomInfo[d][dOry][0], DomInfo[d][dOrz][0]);
	DomInfo[d][dObject][0] = CreateDynamicObject(DomInfo[d][dOmodel][0], DomInfo[d][dOx][0], DomInfo[d][dOy][0], DomInfo[d][dOz][0], DomInfo[d][dOrx][0], DomInfo[d][dOry][0], DomInfo[d][dOrz][0], d+1000, 90, -1, 100.00, 100.00);
	DomInfo[d][dEnterX] = 1387.4436, DomInfo[d][dEnterY] = -16.2143, DomInfo[d][dEnterZ] = 1000.8868, DomInfo[d][dEnterA] = 359.7609, DomInfo[d][dInterior] = 90;
	DomInfo[d][dFrame] = DomInfo[d][dOmodel][0];
	UpdateObject(d, 0);
	return 1;
}

stock RemoveAllObject(playerid, dom) // Удаляем объекты и отключаем взаимодействие
{
	for(new oba = 1; oba < MAX_OBJECT_INT; oba++)
	{
	    if(DomInfo[dom][dOmodel][oba] >= 1) DestroyDynamicObject(DomInfo[dom][dObject][oba]), DomInfo[dom][dOmodel][oba] = 0, DomInfo[dom][dQara][oba] = 0, DelObject(dom, oba);
	}
	if(DomInfo[dom][dIncup] >= 1) DestroyDynamic3DTextLabel(IncupLabel[dom]), DomInfo[dom][dIncup] = 0;
	if(DomInfo[dom][dIntoi] >= 1) DestroyDynamic3DTextLabel(IntoiLabel[dom]), DomInfo[dom][dIntoi] = 0;
	if(DomInfo[dom][dInsin] >= 1) DestroyDynamic3DTextLabel(InsinLabel[dom]), DomInfo[dom][dInsin] = 0;
	if(DomInfo[dom][dInsou] >= 1) DestroyDynamic3DTextLabel(InsouLabel[dom]), DomInfo[dom][dInsou] = 0;
	if(DomInfo[dom][dInspa] >= 1) DomInfo[dom][dInspa] = 0;
	if(DomInfo[dom][dInbedL] >= 1) DomInfo[dom][dInbedL] = 0;
	if(DomInfo[dom][dInbedR] >= 1) DomInfo[dom][dInbedR] = 0;
	SaveDom(dom);
	HouseLog(0, "rdomobject", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], dom, 0, "Удалил всю мебель");
	return 1;
}

stock CheckObject(dom) // Проверяем есть ли свободные слоты для установки объекта мебели
{
	new quan;
	for(new oba = 0; oba < MAX_OBJECT_INT; oba++)
	{
		if(DomInfo[dom][dOmodel][oba] > 0) quan ++;
	}
	if(quan >= MAX_OBJECT_INT) return 1;
	return 0;
}

forward LoadObject();
public LoadObject() // Грузим объекты интерьера для дома
{
	new time = GetTickCount();
	new rows, sla, nd;
	cache_get_row_count(rows);
	for(new f; f<rows; ++f)
	{
    	cache_get_value_name_int(f, "slot", sla);
    	cache_get_value_name_int(f, "dom", nd);
    	cache_get_value_name_int(f, "user", DomInfo[nd][dUser][sla]);
    	cache_get_value_name_int(f, "model", DomInfo[nd][dOmodel][sla]);
    	cache_get_value_name_int(f, "qara", DomInfo[nd][dQara][sla]);
		cache_get_value_name_float(f, "ox", DomInfo[nd][dOx][sla]);
		cache_get_value_name_float(f, "oy", DomInfo[nd][dOy][sla]);
		cache_get_value_name_float(f, "oz", DomInfo[nd][dOz][sla]);
		cache_get_value_name_float(f, "orx", DomInfo[nd][dOrx][sla]);
		cache_get_value_name_float(f, "ory", DomInfo[nd][dOry][sla]);
		cache_get_value_name_float(f, "orz", DomInfo[nd][dOrz][sla]);
		cache_get_value_name_int(f, "idtext0", DomTexture[nd][sla][0]);
		cache_get_value_name_int(f, "idtext1", DomTexture[nd][sla][1]);
		cache_get_value_name_int(f, "idtext2", DomTexture[nd][sla][2]);
		cache_get_value_name_int(f, "idtext3", DomTexture[nd][sla][3]);
		cache_get_value_name_int(f, "idtext4", DomTexture[nd][sla][4]);
		cache_get_value_name_int(f, "idtext5", DomTexture[nd][sla][5]);
		cache_get_value_name_int(f, "idtext6", DomTexture[nd][sla][6]);
		cache_get_value_name_int(f, "idtext7", DomTexture[nd][sla][7]);
		cache_get_value_name_int(f, "idtext8", DomTexture[nd][sla][8]);
		cache_get_value_name_int(f, "idtext9", DomTexture[nd][sla][9]);
		cache_get_value_name_int(f, "idtext10", DomTexture[nd][sla][10]);
		cache_get_value_name_int(f, "idtext11", DomTexture[nd][sla][11]);
		cache_get_value_name_int(f, "idtext12", DomTexture[nd][sla][12]);
		cache_get_value_name_int(f, "idtext13", DomTexture[nd][sla][13]);
		cache_get_value_name_int(f, "idtext14", DomTexture[nd][sla][14]);
		cache_get_value_name_int(f, "idtext15", DomTexture[nd][sla][15]);
		cache_get_value_name_int(f, "idtext16", DomTexture[nd][sla][16]);
		cache_get_value_name_int(f, "idtext17", DomTexture[nd][sla][17]);
		cache_get_value_name_int(f, "idtext18", DomTexture[nd][sla][18]);
		cache_get_value_name_int(f, "idtext19", DomTexture[nd][sla][19]);
		cache_get_value_name_int(f, "idtext20", DomTexture[nd][sla][20]);
		cache_get_value_name_int(f, "idtext21", DomTexture[nd][sla][21]);
		cache_get_value_name_int(f, "idtext22", DomTexture[nd][sla][22]);
		cache_get_value_name_int(f, "idtext23", DomTexture[nd][sla][23]);
		cache_get_value_name_int(f, "idtext24", DomTexture[nd][sla][24]);
		cache_get_value_name_int(f, "idtext25", DomTexture[nd][sla][25]);
		cache_get_value_name_int(f, "idtext26", DomTexture[nd][sla][26]);
		cache_get_value_name_int(f, "idtext27", DomTexture[nd][sla][27]);
		cache_get_value_name_int(f, "idtext28", DomTexture[nd][sla][28]);
		cache_get_value_name_int(f, "idtext29", DomTexture[nd][sla][29]);
		cache_get_value_name_int(f, "idtext30", DomTexture[nd][sla][30]);
		cache_get_value_name_int(f, "idtext31", DomTexture[nd][sla][31]);
		cache_get_value_name_int(f, "idtext32", DomTexture[nd][sla][32]);
		cache_get_value_name_int(f, "idtext33", DomTexture[nd][sla][33]);
		cache_get_value_name_int(f, "idtext34", DomTexture[nd][sla][34]);
		cache_get_value_name_int(f, "idtext35", DomTexture[nd][sla][35]);
		cache_get_value_name_int(f, "idtext36", DomTexture[nd][sla][36]);
		cache_get_value_name_int(f, "idtext37", DomTexture[nd][sla][37]);
  		if(DomInfo[nd][dOmodel][sla] >= 1) DomInfo[nd][dObject][sla] = CreateDynamicObject(DomInfo[nd][dOmodel][sla], DomInfo[nd][dOx][sla], DomInfo[nd][dOy][sla], DomInfo[nd][dOz][sla], DomInfo[nd][dOrx][sla], DomInfo[nd][dOry][sla], DomInfo[nd][dOrz][sla], nd+1000, 90, -1, 100.00, 100.00);
		for(new t = 0; t < 38; t++)
		{
			if(DomTexture[nd][sla][t] >= 1)
			{
				new textid = DomTexture[nd][sla][t]-1;
				SetDynamicObjectMaterial(DomInfo[nd][dObject][sla], t, ObjectTextures[textid][TModel], ObjectTextures[textid][TXDName], ObjectTextures[textid][TextureName], 0x00000000);
			}
		}
	}
	printf("[MODE]: Объекты [%d Quan][%d ms]",rows, GetTickCount() - time);
	return 1;
}

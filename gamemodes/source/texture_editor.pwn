#define MAX_TEXTURE_OBJECT 38 // Максимальное количество текстур на объекте
#define MAX_TEXTURE_LIBRARY 100 // Текстуры избранные или в поиске

enum zInfo //  Enum отвечающий за редактор текстур
{
	zStat,
	Float:zRotation,
	Float:zAddingX,
	Float:zAddingY,
	zPick[12],
	Float:zPosX[12],
	Float:zPosY[12],
	Float:zPosZ[12],
	zLoadPick[12],
	zSelect,
	zList,
	zItems,
	zObject,
	zTextid,
	zDom,
	zBiz,
	zSaveTexture[MAX_TEXTURE_OBJECT],
	zTexture[MAX_TEXTURE_OBJECT],
	Float:zEditX,
	Float:zEditY,
	Float:zEditZ,
	Float:zEditRX,
	Float:zEditRY,
	Float:zEditRZ,
	zChange,
	zDynamicObject, // ID dynamic object
	zLibraryStatus, // Статус какая библиотека с текстурами сейчас отображается
	zLibraryTexture[MAX_TEXTURE_LIBRARY], // Текстуры, загруженные из избранного или из поиска
	zLibraryQuan // Количество загруженных текстур
};
new MenuInfo[MAX_REALPLAYERS][zInfo];
new PlayerText:TextDrawTextureMenu[MAX_TEXTURES_ON_OBJECTS * 2 + 1][MAX_REALPLAYERS]; // Текстдравы меню ретекстура

new QuanTextures = sizeof(ObjectTextures); // Записываем полное количество текстур в библиотеке

stock CreateTexture(playerid) // Сохраняем текстуры на объекте
{
	if(Texture[playerid] == 1 && MenuInfo[playerid][zStat] == 1)
	{
	    new nd = MenuInfo[playerid][zDom];
	    new b = MenuInfo[playerid][zBiz];
	    new oba = MenuInfo[playerid][zObject];

	    if(nd > 0) DomInfo[nd][dUser][oba] = PlayerInfo[playerid][pID];
		else BizzInfo[b][bUser][oba] = PlayerInfo[playerid][pID];
		
		if(nd > 0 || b > 0) // Сохраняем только если редактировали объект в дома или бизнеса
		{
			for(new t = 0; t < MAX_TEXTURE_OBJECT; t++)
			{
				if(MenuInfo[playerid][zDom] > 0) DomTexture[nd][oba][t] = 0;
				else BizzTexture[b][oba][t] = 0;

				MenuInfo[playerid][zSaveTexture][t] = MenuInfo[playerid][zTexture][t];
				if(MenuInfo[playerid][zTexture][t] >= 1)
				{
					new textid = MenuInfo[playerid][zTexture][t];
					if(MenuInfo[playerid][zDom] > 0) DomTexture[nd][oba][t] = textid;
					else BizzTexture[b][oba][t] = textid;
				}
			}
			if(MenuInfo[playerid][zChange] > 0)
			{
				if(nd > 0) UpdateObject(nd, oba, false, true); // Обновляем только текстуры
				else UpdateObjectBiz(b, oba);
			}
		}
		MenuInfo[playerid][zChange] = 0;
		PlayerPlaySound(playerid,6401,0,0,0);
	}
	return 1;
}

stock ObjectToTexture(playerid, slot) // Отправляем объект на ретекстур (Дом, Бизнес, Личный редактор)
{
	Texture[playerid] = 1; // Ретекстур объекта
	MenuInfo[playerid][zObject] = slot; // ID объекта внутри системы, которой он принадлежит
	MenuInfo[playerid][zChange] = 0; // Количество изменений
	if(MenuInfo[playerid][zDom] > 0)
	{
		Streamer_SetIntData(STREAMER_TYPE_OBJECT, DomInfo[MenuInfo[playerid][zDom]][dObject][slot], STREAMER_EDITABLE_DYNAMIC_OBJECT, 1); // Editable Dynamic Object
		MenuInfo[playerid][zDynamicObject] = DomInfo[MenuInfo[playerid][zDom]][dObject][slot];
		for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS; i++) 
		{
			MenuInfo[playerid][zTexture][i] = DomTexture[MenuInfo[playerid][zDom]][slot][i];
			MenuInfo[playerid][zSaveTexture][i] = MenuInfo[playerid][zTexture][i];
		}
	}
	else if(MenuInfo[playerid][zBiz] > 0)
	{
		Streamer_SetIntData(STREAMER_TYPE_OBJECT, BizzInfo[MenuInfo[playerid][zBiz]][bObject][slot], STREAMER_EDITABLE_DYNAMIC_OBJECT, 1); // Editable Dynamic Object
		MenuInfo[playerid][zDynamicObject] = BizzInfo[MenuInfo[playerid][zBiz]][bObject][slot];
		for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS; i++) 
		{
			MenuInfo[playerid][zTexture][i] = BizzTexture[MenuInfo[playerid][zBiz]][slot][i];
			MenuInfo[playerid][zSaveTexture][i] = MenuInfo[playerid][zTexture][i];
		}
	}
	return 1;
}

stock RemoveObjectToTexture(playerid) // Снимаем информацию о редактируемом объекте
{
	if(MenuInfo[playerid][zDynamicObject] > 0)
	{
		Streamer_SetIntData(STREAMER_TYPE_OBJECT, MenuInfo[playerid][zDynamicObject], STREAMER_EDITABLE_DYNAMIC_OBJECT, 0); // Editable Dynamic Object

		// Отменяем изменения, если они не были сохранены
		if(MenuInfo[playerid][zChange] > 0)
		{
			for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS; i++) 
			{
				// Если текстуры изначально не было, а потом появилась - стираем
				if(MenuInfo[playerid][zSaveTexture][i] == 0 && MenuInfo[playerid][zTexture][i] > 0)
				{
					RemoveDynamicObjectMaterial(MenuInfo[playerid][zDynamicObject], i);
				}

				// Если текстура изначально была, возвращаем
				else if(MenuInfo[playerid][zSaveTexture][i] > 0)
				{
					new textid = MenuInfo[playerid][zSaveTexture][i];
					SetDynamicObjectMaterial(MenuInfo[playerid][zDynamicObject], i, ObjectTextures[textid][TModel], ObjectTextures[textid][TXDName], ObjectTextures[textid][TextureName], 0x00000000);
				}
			}
		}
	}
	Texture[playerid] = 0;
	return 1;
}

stock Create3DMenu(playerid, stat, dom) // Создаём 3D Menu выбора текстур
{
	if(MenuInfo[playerid][zStat] == 0)
	{
		new Float:plapos[4];
    	frontme(playerid, 4.0, plapos[0], plapos[1], plapos[2], plapos[3]);
		new Float:NextLineX,Float:NextLineY;
		new lineindx,binc;
		MenuInfo[playerid][zStat] = 1;
		MenuInfo[playerid][zSelect] = -1;
		MenuInfo[playerid][zRotation] = plapos[3];
		MenuInfo[playerid][zAddingX] = 0.25*floatsin(plapos[3],degrees);
		MenuInfo[playerid][zAddingY] = -floatcos(plapos[3],degrees)*0.25;
		MenuInfo[playerid][zObject] -= 1;
		if(stat == 0) MenuInfo[playerid][zDom] = dom, MenuInfo[playerid][zBiz] = 0;
		else MenuInfo[playerid][zBiz] = dom, MenuInfo[playerid][zDom] = 0;
		MenuInfo[playerid][zTextid] = 0;
		NextLineX = floatcos(plapos[3],degrees)+0.05*floatcos(plapos[3],degrees);
		NextLineY = floatsin(plapos[3],degrees)+0.05*floatsin(plapos[3],degrees);

		SetPaletteTexture(playerid, 0); // VREMENNO (запускаем при открытии стандартную палитру)
		// Создаём объекты для палитры текстур
		for(new b = 0; b < 12; b++)
		{
			if(b%4 == 0 && b != 0) lineindx++,binc+=4;
   			MenuInfo[playerid][zPick][b] = CreatePlayerObject(playerid, 2661, plapos[0]+NextLineX*lineindx, plapos[1]+NextLineY*lineindx, plapos[2]+1.65-0.55*(b-binc), 0, 0, plapos[3], 100.0);
      		GetPlayerObjectPos(playerid, MenuInfo[playerid][zPick][b],MenuInfo[playerid][zPosX][b],MenuInfo[playerid][zPosY][b],MenuInfo[playerid][zPosZ][b]);
			UpdatePalettePlayerObject(playerid, b);
		}
	}
	return 1;
}

stock Destroy3DMenu(playerid) // Удаляем 3D Menu Редактора Текстур
{
    if(Texture[playerid] == 1) RemoveObjectToTexture(playerid);
	if(MenuInfo[playerid][zStat] == 1)
	{
	    MenuInfo[playerid][zObject] = -1;
		MenuInfo[playerid][zStat] = 0;
		MenuInfo[playerid][zRotation] = 0.0;
		MenuInfo[playerid][zAddingX] = 0.0;
		MenuInfo[playerid][zAddingY] = 0.0;
		MenuInfo[playerid][zDynamicObject] = 0;
		for(new b = 0; b < 12; b++) DestroyPlayerObject(playerid, MenuInfo[playerid][zPick][b]);
	}
	return 1;
}

stock UpdatePalettePlayerObject(playerid, b) // Обновляем отображение текстуры в ячейке
{
	if(MenuInfo[playerid][zLoadPick][b] > 0) // Есть текстура в этом слоте
	{
		new textid = MenuInfo[playerid][zLoadPick][b];

		if(MenuInfo[playerid][zSelect] == b) { // Выбранную ячейку (Подсвечиваем)
			SetPlayerObjectMaterial(playerid, MenuInfo[playerid][zPick][b], 0, ObjectTextures[textid][TModel], ObjectTextures[textid][TXDName], ObjectTextures[textid][TextureName], 0x00000000);
		}
		else {
			SetPlayerObjectMaterial(playerid, MenuInfo[playerid][zPick][b], 0, ObjectTextures[textid][TModel], ObjectTextures[textid][TXDName], ObjectTextures[textid][TextureName], 0xFF999999);
		}
	}
	else // Нет текстуры, делаем слот невидимым
	{
		SetPlayerObjectMaterial(playerid, MenuInfo[playerid][zPick][b], 0, ObjectTextures[8955][TModel], ObjectTextures[8955][TXDName], ObjectTextures[8955][TextureName], 0xFF999999);
	}
	return 1;
}

stock SetPaletteTexture(playerid, status)
{
	MenuInfo[playerid][zLibraryStatus] = status; // Устанавливаем статус палитры
	MenuInfo[playerid][zItems] = 1; // Сбрасываем подсчёт последней отображаемой текстуры
	MenuInfo[playerid][zList] = 0; // Сбрасываем страницы с текстурами
	return 1;
}

stock Back3DBox(playerid)
{
	new maxQuan = GetMaxTextures(playerid);

	PlayerPlaySound(playerid,17803,0,0,0);
 	if(MenuInfo[playerid][zItems] <= 13) MenuInfo[playerid][zItems] = maxQuan - 12;
 	else MenuInfo[playerid][zItems] -= 24;
	Show3DBox(playerid);
	return 1;
}

stock Next3DBox(playerid)
{
	new maxQuan = GetMaxTextures(playerid);

	PlayerPlaySound(playerid,17803,0,0,0);
 	if(MenuInfo[playerid][zItems] >= maxQuan) MenuInfo[playerid][zItems] = 1; // Если страница последняя, открываем первую
	Show3DBox(playerid);
	return 1;
}

stock Show3DBox(playerid) // Обновляем ячейки
{
	new maxQuan = GetMaxTextures(playerid);

	if(MenuInfo[playerid][zItems] >= maxQuan) MenuInfo[playerid][zItems] = 1;
	for(new b = 0; b < 12; b++)
	{
		MenuInfo[playerid][zLoadPick][b] = 0;
		if(MenuInfo[playerid][zItems] < maxQuan)
		{
			if(MenuInfo[playerid][zLibraryStatus] == 0) MenuInfo[playerid][zLoadPick][b] = MenuInfo[playerid][zItems];
			else MenuInfo[playerid][zLoadPick][b] = MenuInfo[playerid][zLibraryTexture][MenuInfo[playerid][zItems]];
		}
		MenuInfo[playerid][zItems] ++;
		UpdatePalettePlayerObject(playerid, b);
	}
	MenuInfo[playerid][zList] ++;

	NameTexture(playerid);
	return 1;
}

stock NameTexture(playerid)
{
	new maxQuan = GetMaxTextures(playerid);
	new textid = MenuInfo[playerid][zItems]-12 + MenuInfo[playerid][zSelect];
	if(textid >= 0 && textid < maxQuan)
	{
		new string[100];
		format(string, sizeof(string), "[%d/%d][Page: %d] %s %s", textid, maxQuan, MenuInfo[playerid][zItems]/12, ObjectTextures[textid][TXDName], ObjectTextures[textid][TextureName]);
		PlayerTextDrawSetString(playerid, PlaMenu, string);
		PlayerTextDrawShow(playerid, PlaMenu);
	}
	return 1;
}

stock GetMaxTextures(playerid)
{
	if(MenuInfo[playerid][zLibraryStatus] == 0) return QuanTextures;
	else return MenuInfo[playerid][zLibraryQuan];
}

stock Go3DBox(playerid, stat)
{
    new ab = MenuInfo[playerid][zSelect];
	if(stat == 0) // Вверх
	{
		if(ab == -1) Move3DBox(playerid, 0);
		else if(ab == 0) Move3DBox(playerid, 11);
		else if(ab == 1) Move3DBox(playerid, 0);
		else if(ab == 2) Move3DBox(playerid, 1);
		else if(ab == 3) Move3DBox(playerid, 2);
		else if(ab == 4) Move3DBox(playerid, 3);
		else if(ab == 5) Move3DBox(playerid, 4);
		else if(ab == 6) Move3DBox(playerid, 5);
		else if(ab == 7) Move3DBox(playerid, 6);
		else if(ab == 8) Move3DBox(playerid, 7);
		else if(ab == 9) Move3DBox(playerid, 8);
		else if(ab == 10) Move3DBox(playerid, 9);
		else if(ab == 11) Move3DBox(playerid, 10);
	}
	else if(stat == 1) // Вниз
	{
		if(ab == -1) Move3DBox(playerid, 0);
		else if(ab == 0) Move3DBox(playerid, 1);
		else if(ab == 1) Move3DBox(playerid, 2);
		else if(ab == 2) Move3DBox(playerid, 3);
		else if(ab == 3) Move3DBox(playerid, 4);
		else if(ab == 4) Move3DBox(playerid, 5);
		else if(ab == 5) Move3DBox(playerid, 6);
		else if(ab == 6) Move3DBox(playerid, 7);
		else if(ab == 7) Move3DBox(playerid, 8);
		else if(ab == 8) Move3DBox(playerid, 9);
		else if(ab == 9) Move3DBox(playerid, 10);
		else if(ab == 10) Move3DBox(playerid, 11);
		else if(ab == 11) Move3DBox(playerid, 0);
	}
	return 1;
}

stock Move3DBox(playerid, b) // Смещаем выбранную текстуру
{
	if(!MenuInfo[playerid][zLoadPick][b]) return 0; // Не сдигаем выбор, если на этой иконке нет текстуры
	new ab = MenuInfo[playerid][zSelect];
	if(ab >= 0)
	{
		new model,txd[32],texture[32], color, btxdnamelen, btexturenamelen;
		MovePlayerObject(playerid, MenuInfo[playerid][zPick][ab],MenuInfo[playerid][zPosX][ab],MenuInfo[playerid][zPosY][ab],MenuInfo[playerid][zPosZ][ab],1.2);
		GetPlayerObjectMaterial(playerid, MenuInfo[playerid][zPick][b], 0, model, txd, btxdnamelen, texture, btexturenamelen, color);
 		SetPlayerObjectMaterial(playerid, MenuInfo[playerid][zPick][ab],0, model, txd, texture, 0xFF999999);
	}
	new bmodel,btxd[32],btexture[32], bcolor, txdnamelen, texturenamelen;
	MenuInfo[playerid][zSelect] = b;
	MovePlayerObject(playerid, MenuInfo[playerid][zPick][b],MenuInfo[playerid][zPosX][b]+MenuInfo[playerid][zAddingX],MenuInfo[playerid][zPosY][b]+MenuInfo[playerid][zAddingY],MenuInfo[playerid][zPosZ][b],1.2);
	GetPlayerObjectMaterial(playerid, MenuInfo[playerid][zPick][b], 0, bmodel, btxd, txdnamelen, btexture, texturenamelen, bcolor);
	SetPlayerObjectMaterial(playerid, MenuInfo[playerid][zPick][b],0, bmodel, btxd, btexture, 0x00000000);
	NameTexture(playerid);
	return 1;
}

stock ClearTextureObject(playerid, slot) // Снять текстуру с объекта
{
	if(MenuInfo[playerid][zDynamicObject] == 0) return 1;
	if(MenuInfo[playerid][zTexture][slot] == 0) return ErrorMessage(playerid, "{FF6347}В этом слоте нет текстуры");

	RemoveDynamicObjectMaterial(MenuInfo[playerid][zDynamicObject], slot); // Снимаем текстуру с объекта
	MenuInfo[playerid][zTexture][slot] = 0; // Очищаем в редакторе текстур
	MenuInfo[playerid][zChange] ++; // Добавляем количество изменений
	PlayerPlaySound(playerid,6801,0,0,0);

	UpdateTextDraw3DMenu(playerid, slot);
	return 1;
}

stock SelectTextureObject(playerid, slot) // Выбираем слот текстуры
{
	if(MenuInfo[playerid][zDynamicObject] == 0) return 1;

	PlayerPlaySound(playerid,17803,0,0,0);
	PlayerTextDrawColor(playerid, TextDrawTextureMenu[MenuInfo[playerid][zTextid]][playerid], -1); // Меняем цвет предыдущего слота
	PlayerTextDrawShow(playerid, TextDrawTextureMenu[MenuInfo[playerid][zTextid]][playerid]);
	MenuInfo[playerid][zTextid] = slot;
	PlayerTextDrawColor(playerid, TextDrawTextureMenu[slot][playerid], -5963521); // Меняем цвет нового слота
	PlayerTextDrawShow(playerid, TextDrawTextureMenu[slot][playerid]);

	// Если текстура выбрана и в слоте пусто, сразу надеваем текстуру без лишней ебалы
	if(MenuInfo[playerid][zSelect] >= 0 && MenuInfo[playerid][zTexture][slot] == 0) ApplyTextureObject(playerid);
	return 1;
}

stock ApplyTextureObject(playerid)
{
	if(MenuInfo[playerid][zDynamicObject] == 0) return 1;
	
	new slot = MenuInfo[playerid][zTextid];
	new selectTexture = MenuInfo[playerid][zSelect];
	if(selectTexture == -1) return ErrorMessage(playerid, "{FF6347}Вы не выбрали текстуру");

	new textid = MenuInfo[playerid][zLoadPick][selectTexture];
	MenuInfo[playerid][zTexture][slot] = textid; // Добавляем в редакторе текстур
	MenuInfo[playerid][zChange] ++; // Добавляем количество изменений

	SetDynamicObjectMaterial(MenuInfo[playerid][zDynamicObject], slot, ObjectTextures[textid][TModel], ObjectTextures[textid][TXDName], ObjectTextures[textid][TextureName], 0x00000000);
	PlayerPlaySound(playerid,40404,0,0,0);

	UpdateTextDraw3DMenu(playerid, slot);
	return 1;
}

stock ClickTextDraw_TextureEditor(playerid, PlayerText:playertextid)
{
	for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS; i++)
	{
		if(playertextid == TextDrawTextureMenu[i + MAX_TEXTURES_ON_OBJECTS][playerid]) // X
		{
			ClearTextureObject(playerid, i);
			break;
		}
		else if(playertextid == TextDrawTextureMenu[i][playerid]) // Texture Slot
		{
			SelectTextureObject(playerid, i);
			break;
		}
	}
	return 1;
}

// Меню Ретекстура
stock ShowDraw3DMenu(playerid)
{
	if(MenuInfo[playerid][zDynamicObject] == 0) return 1;
	if(DrawTextdrawEditor[playerid] == true) return 1;
	CreateTextDraw3DMenu(playerid, MenuInfo[playerid][zDynamicObject]);
	DrawTextdrawEditor[playerid] = true;
	return 1;
}

stock CloseDraw3DMenu(playerid)
{
	if(DrawTextdrawEditor[playerid] == false) return 1;
	for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS * 2 + 1; i++)
	{
		PlayerTextDrawHide(playerid, TextDrawTextureMenu[i][playerid]);
		PlayerTextDrawDestroy(playerid, TextDrawTextureMenu[i][playerid]);
	}
	DrawTextdrawEditor[playerid] = false;
	return 1;
}

stock UpdateTextDraw3DMenu(playerid, slot)
{
	if(DrawTextdrawEditor[playerid] == false) return 1;
	new string[84];
	if(MenuInfo[playerid][zTexture][slot] > 0) 
	{
		new textid = MenuInfo[playerid][zTexture][slot];
		format(string, sizeof(string),"%d._%d_%s_%s", slot, ObjectTextures[textid][TModel], ObjectTextures[textid][TXDName], ObjectTextures[textid][TextureName]);
		PlayerTextDrawShow(playerid, TextDrawTextureMenu[slot + MAX_TEXTURES_ON_OBJECTS][playerid]);
	}
	else 
	{
		format(string, sizeof(string),"%d._Texture_Slot", slot);
		PlayerTextDrawHide(playerid, TextDrawTextureMenu[slot + MAX_TEXTURES_ON_OBJECTS][playerid]);
	}
	PlayerTextDrawSetString(playerid, TextDrawTextureMenu[slot][playerid], string);
	PlayerTextDrawShow(playerid, TextDrawTextureMenu[slot][playerid]);
	return 1;
}

// object_material(BizzInfo[b][bOmodel][oba]); // максимальное количество текстур на объекте

stock CreateTextDraw3DMenu(playerid, objectid)
{
	new string[84];
	new Float:slotpos_y = 16.0, Float:slotpos_x = 433.0, Float:offset_x = 9.0;
	new Float:closepos_y = 7.0;
	for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS; i++)
	{
		new bmodel, btxd[32], btexture[32], bcolor;
		GetDynamicObjectMaterial(objectid, i, bmodel, btxd, btexture, bcolor);

		if(bmodel >= 1) format(string, sizeof(string),"%d._%d_%s_%s", i, bmodel, btxd, btexture);
		else format(string, sizeof(string),"%d._Texture_Slot", i);

		TextDrawTextureMenu[i][playerid] = CreatePlayerTextDraw(playerid, slotpos_y, slotpos_x, string);
		PlayerTextDrawLetterSize(playerid, TextDrawTextureMenu[i][playerid], 0.115333, 0.616889);
		PlayerTextDrawTextSize(playerid, TextDrawTextureMenu[i][playerid], 160.0, 8.0);
		PlayerTextDrawAlignment(playerid, TextDrawTextureMenu[i][playerid], 1);
		if(MenuInfo[playerid][zTextid] == i) PlayerTextDrawColor(playerid, TextDrawTextureMenu[i][playerid], -5963521);
		else PlayerTextDrawColor(playerid, TextDrawTextureMenu[i][playerid], -1);
		PlayerTextDrawUseBox(playerid, TextDrawTextureMenu[i][playerid], true);
		PlayerTextDrawBoxColor(playerid, TextDrawTextureMenu[i][playerid], 146);
		PlayerTextDrawSetShadow(playerid, TextDrawTextureMenu[i][playerid], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawTextureMenu[i][playerid], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawTextureMenu[i][playerid], 505290495);
		PlayerTextDrawFont(playerid, TextDrawTextureMenu[i][playerid], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawTextureMenu[i][playerid], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawTextureMenu[i][playerid], true);

		new x = i + MAX_TEXTURES_ON_OBJECTS;
		TextDrawTextureMenu[x][playerid] = CreatePlayerTextDraw(playerid, closepos_y, slotpos_x - 1.325607, "X");
		PlayerTextDrawLetterSize(playerid, TextDrawTextureMenu[x][playerid], 0.238333, 0.853333);
		PlayerTextDrawTextSize(playerid, TextDrawTextureMenu[x][playerid], 12.333332, 7.8);
		PlayerTextDrawAlignment(playerid, TextDrawTextureMenu[x][playerid], 1);
		PlayerTextDrawColor(playerid, TextDrawTextureMenu[x][playerid], -16765441);
		PlayerTextDrawUseBox(playerid, TextDrawTextureMenu[x][playerid], true);
		PlayerTextDrawBoxColor(playerid, TextDrawTextureMenu[x][playerid], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawTextureMenu[x][playerid], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawTextureMenu[x][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawTextureMenu[x][playerid], 505290495);
		PlayerTextDrawFont(playerid, TextDrawTextureMenu[x][playerid], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawTextureMenu[x][playerid], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawTextureMenu[x][playerid], true);

		// Смещаем позицию для следующей строки
		slotpos_x -= offset_x;

		PlayerTextDrawShow(playerid, TextDrawTextureMenu[i][playerid]);
		if(bmodel >= 1) PlayerTextDrawShow(playerid, TextDrawTextureMenu[x][playerid]);
	}

	// Подсказка
	new p = MAX_TEXTURES_ON_OBJECTS * 2;
	TextDrawTextureMenu[p][playerid] = CreatePlayerTextDraw(playerid, 482.666412, 370.0, "ЊKM_-_Њokaџa¦©_ЇЁҐky~n~Y_-_‹ўepx~n~N_-_‹®њџ~n~Num_4_-_‹ћeўo~n~Num_6_-_‹Јpaўo~n~~y~ALT_-_ЊpњЇe®њ¦©_¦ekc¦ypy");
	PlayerTextDrawLetterSize(playerid, TextDrawTextureMenu[p][playerid], 0.329999, 1.305481);
	PlayerTextDrawAlignment(playerid, TextDrawTextureMenu[p][playerid], 1);
	PlayerTextDrawColor(playerid, TextDrawTextureMenu[p][playerid], -1061109505);
	PlayerTextDrawUseBox(playerid, TextDrawTextureMenu[p][playerid], true);
	PlayerTextDrawBoxColor(playerid, TextDrawTextureMenu[p][playerid], 0);
	PlayerTextDrawSetShadow(playerid, TextDrawTextureMenu[p][playerid], 0);
	PlayerTextDrawSetOutline(playerid, TextDrawTextureMenu[p][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, TextDrawTextureMenu[p][playerid], 505290495);
	PlayerTextDrawFont(playerid, TextDrawTextureMenu[p][playerid], 1);
	PlayerTextDrawSetProportional(playerid, TextDrawTextureMenu[p][playerid], 1);
	PlayerTextDrawShow(playerid, TextDrawTextureMenu[p][playerid]);
	return 1;
}

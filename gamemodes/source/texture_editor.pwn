#define MAX_TEXTURE_OBJECT 38 // Максимальное количество текстур на объекте
#define MAX_TEXTURE_LIBRARY 200 // Текстуры избранные или в поиске
#define MAX_DRAW_TEXTURE_BUTTON 12 // Текстдравы основного меню

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
	zLibraryQuan, // Количество загруженных текстур
	zMaxTexturesOnObject // Макс количество слотов текстур на объекте
};
new MenuInfo[MAX_REALPLAYERS][zInfo];

new zTxtModel[MAX_REALPLAYERS][MAX_TEXTURE_OBJECT];

new zTxtSaveModel[MAX_REALPLAYERS][MAX_TEXTURE_OBJECT];
new zTxtSaveTxd[MAX_REALPLAYERS][MAX_TEXTURE_OBJECT][32];
new zTxtSaveTexture[MAX_REALPLAYERS][MAX_TEXTURE_OBJECT][32];
new zTxtSaveMaterial[MAX_REALPLAYERS][MAX_TEXTURE_OBJECT];

new PlayerText:TextDrawTextureMenu[MAX_TEXTURES_ON_OBJECTS * 2][MAX_REALPLAYERS]; // Текстдравы меню ретекстура
new PlayerText:DrawTextureButton[MAX_DRAW_TEXTURE_BUTTON][MAX_REALPLAYERS]; // Кнопки меню ретекстура

new QuanTextures = sizeof(ObjectTextures); // Записываем полное количество текстур в библиотеке


CMD:to(playerid, const params[]) return cmd_texture(playerid, params);
CMD:textureobject(playerid, const params[]) return cmd_texture(playerid, params);
CMD:textur(playerid, const params[]) return cmd_texture(playerid, params);
CMD:texture(playerid, const params[])
{
    if(Device[playerid] == 1) return ErrorMessage(playerid, "{FF6347}Недоступно во время игры на смартфоне");
    if(gRedakt[playerid] != 0) return ErrorMessage(playerid, "{FF6347}Вы используете редактор объектов");

	if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Ретекстур объекта /texture ID объекта");
	if(LabelsInfo[playerid][labelCreate] == 0) return ErrorMessage(playerid, "{FF6347}Активируйте отображение 3D Лейблов на объектах\n{cccccc}Для домов: /dedit >> 3D Лейблы\n{cccccc}Для бизнесов: /bedit >> 3D Лейблы");
	
	if(LabelsInfo[playerid][labelCreate] > 0 && LabelsInfo[playerid][labelType] == 1) return EditTextureDom(playerid, LabelsInfo[playerid][labelCreate], params[0]);
	else if(LabelsInfo[playerid][labelCreate] > 0 && LabelsInfo[playerid][labelType] == 2) return EditTextureBiz(playerid, LabelsInfo[playerid][labelCreate], params[0]);
	return 1;
}

stock Show3DMenu(playerid)
{
	if(OnlineInfo[playerid][oShowInterface] > 0) return 1;
	CreateTextDrawTextureButton(playerid);

	ClearDeathBox(playerid, 5);
	if(OnlineInfo[playerid][oShowInterface] == 1) CloseFrisk(playerid);
	else if(OnlineInfo[playerid][oShowInterface] == 2) CloseSmartfon(playerid);
	if(gVidga[playerid] == true) DelUpdate(playerid);
  	if(gMifga[playerid] != 9999) DelMaf(playerid);

  	ShowDialog(playerid,-1,DIALOG_STYLE_MSGBOX," "," ","*","");
  	TextDrawHideForPlayer(playerid, PissDraw), TextDrawHideForPlayer(playerid, PissDraw2);
	gRedakt[playerid] = 0;
	OnlineInfo[playerid][oShowInterface] = 19;

	PearsWeather(playerid);
	PearsTime(playerid);
	return 1;
}

stock Close3DMenu(playerid)
{
	if(OnlineInfo[playerid][oShowInterface] != 19) return 1;
	
	if(DrawTextdrawEditor[playerid] == true) CloseDraw3DMenu(playerid);

	for(new i = 0; i < MAX_DRAW_TEXTURE_BUTTON; i++) 
	{
		PlayerTextDrawHide(playerid, DrawTextureButton[i][playerid]);
		PlayerTextDrawDestroy(playerid, DrawTextureButton[i][playerid]);
	}

	CancelSelectTextDraw(playerid);
	RemoveObjectToTexture(playerid);
	ShowDialog(playerid,-1,DIALOG_STYLE_MSGBOX," "," ","*","");
	OnlineInfo[playerid][oShowInterface] = 0;

	PearsWeather(playerid);
	PearsTime(playerid);
	return 1;
}

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
				GetDynamicObjectMaterial(MenuInfo[playerid][zDynamicObject], t, zTxtSaveModel[playerid][t], zTxtSaveTxd[playerid][t], zTxtSaveTexture[playerid][t], zTxtSaveMaterial[playerid][t]);
			}
			if(MenuInfo[playerid][zChange] > 0)
			{
				if(nd > 0) UpdateObject(nd, oba, false, true); // Обновляем только текстуры
				else UpdateObjectBiz(b, oba, false, true);
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

	new objectid;
	if(MenuInfo[playerid][zDom] > 0) objectid = DomInfo[MenuInfo[playerid][zDom]][dObject][slot];
	else if(MenuInfo[playerid][zBiz] > 0) objectid = BizzInfo[MenuInfo[playerid][zBiz]][bObject][slot];

	Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, STREAMER_EDITABLE_DYNAMIC_OBJECT, 1); // Editable Dynamic Object
	MenuInfo[playerid][zDynamicObject] = objectid;
	for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS; i++) 
	{
		ClearTexturesEditorVariableAll(playerid, i);
		new modelid;
		new txdname[32];
		new texturename[32];
		new materialcolor;
		GetDynamicObjectMaterial(MenuInfo[playerid][zDynamicObject], i, modelid, txdname, texturename, materialcolor);
		zTxtModel[playerid][i] = modelid;
		GetDynamicObjectMaterial(MenuInfo[playerid][zDynamicObject], i, zTxtSaveModel[playerid][i], zTxtSaveTxd[playerid][i], zTxtSaveTexture[playerid][i], zTxtSaveMaterial[playerid][i]);
	}

	new model = GetDynamicObjectModel(MenuInfo[playerid][zDynamicObject]);
	MenuInfo[playerid][zMaxTexturesOnObject] = GetTexturesOnObject(model);
	return 1;
}

stock ClearTexturesEditorVariableAll(playerid, i)
{
	ClearTexturesEditorVariable(playerid, i);
	ClearTexturesEditorVariableSave(playerid, i);
}

stock ClearTexturesEditorVariable(playerid, i)
{
	zTxtModel[playerid][i] = 0;
}

stock ClearTexturesEditorVariableSave(playerid, i)
{
	zTxtSaveModel[playerid][i] = 0;
	zTxtSaveTxd[playerid][i][0] = EOS;
	zTxtSaveTexture[playerid][i][0] = EOS;
	zTxtSaveMaterial[playerid][i] = 0;
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
				if(zTxtSaveModel[playerid][i] == 0 && zTxtModel[playerid][i] > 0)
				{
					RemoveDynamicObjectMaterial(MenuInfo[playerid][zDynamicObject], i);
				}
				// Если текстура изначально была, возвращаем
				else if(zTxtSaveModel[playerid][i] > 0)
				{
					SetDynamicObjectMaterial(MenuInfo[playerid][zDynamicObject], i, zTxtSaveModel[playerid][i], zTxtSaveTxd[playerid][i], zTxtSaveTexture[playerid][i], zTxtSaveMaterial[playerid][i]);
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
		// Находим координату перед лицом
		new Float:plapos[4];
    	frontme(playerid, 2.0, plapos[0], plapos[1], plapos[2], plapos[3]);

		// Смещаем чуть-чуть влево
		plapos[0] = plapos[0] + 1.0*floatsin(-plapos[3]-90,degrees);
		plapos[1] = plapos[1] + 1.0*floatcos(-plapos[3]-90,degrees);

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
			
			LoadPaletteTexture(playerid, b);
			UpdatePalettePlayerObject(playerid, b);
		}
		Move3DBox(playerid, 0);
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

stock GetFirstItems(playerid)
{
	if(MenuInfo[playerid][zLibraryStatus] == 0) return 1;
	else return 0;
}

stock SetPaletteTexture(playerid, status)
{
	MenuInfo[playerid][zLibraryStatus] = status; // Устанавливаем статус палитры
	MenuInfo[playerid][zItems] = GetFirstItems(playerid); // Сбрасываем подсчёт последней отображаемой текстуры
	MenuInfo[playerid][zList] = 0; // Сбрасываем страницы с текстурами
	return 1;
}

stock Back3DBox(playerid)
{
	if(MenuInfo[playerid][zLibraryStatus] != 0 && MenuInfo[playerid][zLibraryQuan] <= 12) return 1;
	new maxQuan = GetMaxTextures(playerid);

	PlayerPlaySound(playerid,17803,0,0,0);
 	if(MenuInfo[playerid][zItems] <= 13) 
	{
		new realPages = maxQuan / 12;
		new item = realPages * 12;
		MenuInfo[playerid][zItems] = item;
	}
 	else MenuInfo[playerid][zItems] -= 24;
	Show3DBox(playerid);
	return 1;
}

stock Next3DBox(playerid)
{
	if(MenuInfo[playerid][zLibraryStatus] != 0 && MenuInfo[playerid][zLibraryQuan] <= 12) return 1;
	new maxQuan = GetMaxTextures(playerid);

	PlayerPlaySound(playerid,17803,0,0,0);
 	if(MenuInfo[playerid][zItems] >= maxQuan) MenuInfo[playerid][zItems] = GetFirstItems(playerid);
	Show3DBox(playerid);
	return 1;
}

stock Show3DBox(playerid) // Обновляем ячейки
{
	new maxQuan = GetMaxTextures(playerid);

	if(MenuInfo[playerid][zItems] >= maxQuan) MenuInfo[playerid][zItems] = GetFirstItems(playerid);
	for(new b = 0; b < 12; b++)
	{
		LoadPaletteTexture(playerid, b);
		UpdatePalettePlayerObject(playerid, b);
	}
	MenuInfo[playerid][zList] ++;

	if(MenuInfo[playerid][zSelect] == -1) Move3DBox(playerid, 0); // Если никакой не выбран, отображаем 0
	else 
	{
		if(MenuInfo[playerid][zLoadPick][MenuInfo[playerid][zSelect]] == 0) Move3DBox(playerid, 0); // Если выбранный пустой, отображаем 0
	}

	NameTexture(playerid);
	return 1;
}

stock LoadPaletteTexture(playerid, b)
{
	new maxQuan = GetMaxTextures(playerid);
	MenuInfo[playerid][zLoadPick][b] = 0;
	if(MenuInfo[playerid][zItems] >= 0 && MenuInfo[playerid][zItems] < maxQuan)
	{
		if(MenuInfo[playerid][zLibraryStatus] == 0) MenuInfo[playerid][zLoadPick][b] = MenuInfo[playerid][zItems];
		else 
		{
			MenuInfo[playerid][zLoadPick][b] = MenuInfo[playerid][zLibraryTexture][MenuInfo[playerid][zItems]];
		}
	}
	MenuInfo[playerid][zItems] ++;
	return 1;
}

stock NameTexture(playerid)
{
	if(MenuInfo[playerid][zSelect] >= 0 && OnlineInfo[playerid][oShowInterface] == 19)
	{
		new textid = MenuInfo[playerid][zLoadPick][MenuInfo[playerid][zSelect]];
		if(textid >= 0 && textid < QuanTextures)
		{
			new maxQuan = GetMaxTextures(playerid); // Полное количество текстур

			new dopPage;
			new ostatok = maxQuan % 12; // Есть ли остаток при делении на 12 ячеек
			if(ostatok > 0 || maxQuan < 12) dopPage = 1; // Есть остаток или количество текстур меньше 12 (значит добавляем одну страницу в отображении)

			new string[100];
			if(MenuInfo[playerid][zLibraryStatus] == 0) format(string, sizeof(string), "[%d/%d][Page: %d/%d] %d %s %s", textid, QuanTextures - 1, MenuInfo[playerid][zItems]/12, maxQuan/12, ObjectTextures[textid][TModel], ObjectTextures[textid][TXDName], ObjectTextures[textid][TextureName]);
			else
			{
				format(string, sizeof(string), "[%d][Page: %d/%d] %d %s %s", textid, MenuInfo[playerid][zItems]/12, maxQuan/12 + dopPage, ObjectTextures[textid][TModel], ObjectTextures[textid][TXDName], ObjectTextures[textid][TextureName]);
			}
			PlayerTextDrawSetString(playerid, DrawTextureButton[11][playerid], string);
		}
		else PlayerTextDrawSetString(playerid, DrawTextureButton[11][playerid], " ");
	}
	else PlayerTextDrawSetString(playerid, DrawTextureButton[11][playerid], " ");
	PlayerTextDrawShow(playerid, DrawTextureButton[11][playerid]);
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
	MenuInfo[playerid][zSelect] = b;

	if(ab >= 0) // Предыдущая выбранная текстура (Делаем её серой)
	{
		MovePlayerObject(playerid, MenuInfo[playerid][zPick][ab],MenuInfo[playerid][zPosX][ab],MenuInfo[playerid][zPosY][ab],MenuInfo[playerid][zPosZ][ab],1.2);
		UpdatePalettePlayerObject(playerid, ab);
	}
	MovePlayerObject(playerid, MenuInfo[playerid][zPick][b],MenuInfo[playerid][zPosX][b]+MenuInfo[playerid][zAddingX],MenuInfo[playerid][zPosY][b]+MenuInfo[playerid][zAddingY],MenuInfo[playerid][zPosZ][b],1.2);
	UpdatePalettePlayerObject(playerid, b);

	NameTexture(playerid);
	return 1;
}

stock ClearTextureObject(playerid, slot) // Снять текстуру с объекта
{
	if(MenuInfo[playerid][zDynamicObject] == 0) return 1;
	if(zTxtModel[playerid][slot] == 0) return ErrorMessage(playerid, "{FF6347}В этом слоте нет текстуры");

	RemoveDynamicObjectMaterial(MenuInfo[playerid][zDynamicObject], slot); // Снимаем текстуру с объекта
	ClearTexturesEditorVariable(playerid, slot);
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
	if(MenuInfo[playerid][zSelect] >= 0 && zTxtModel[playerid][slot] == 0) ApplyTextureObject(playerid);
	return 1;
}

stock ApplyTextureObject(playerid)
{
	if(MenuInfo[playerid][zDynamicObject] == 0) return 1;
	
	new slot = MenuInfo[playerid][zTextid];
	new selectTexture = MenuInfo[playerid][zSelect];
	if(selectTexture == -1) return ErrorMessage(playerid, "{FF6347}Вы не выбрали текстуру");
	if(slot >= MenuInfo[playerid][zMaxTexturesOnObject]) return ErrorMessage(playerid, "{FF6347}Ошибка! У объекта нет этого слота для текстуры");

	new textid = MenuInfo[playerid][zLoadPick][selectTexture];
	MenuInfo[playerid][zChange] ++; // Добавляем количество изменений

	SetDynamicObjectMaterial(MenuInfo[playerid][zDynamicObject], slot, ObjectTextures[textid][TModel], ObjectTextures[textid][TXDName], ObjectTextures[textid][TextureName], 0x00000000);
	
	zTxtModel[playerid][slot] = ObjectTextures[textid][TModel];

	PlayerPlaySound(playerid,40404,0,0,0);
	UpdateTextDraw3DMenu(playerid, slot);
	return 1;
}

stock FindTexture(playerid, const inputtext[])
{
	if(MenuInfo[playerid][zStat] == 0) return 1;

	if(!strlen(inputtext)) return ErrorMessage(playerid, "{FF6347}Вы ничего не ввели");
	if(strlen(inputtext) < 3 || strlen(inputtext) > 30) return ErrorMessage(playerid, "{FF6347}3 - 30 символов");
    if(checksimvol(inputtext)) return ErrorMessage(playerid, "{FF6347}Вы используете запрещённый символ");

	new typeSorting;
	// Если числа, значит ищем по модели объекта
	if(IsNumeric(inputtext)) typeSorting = 1;

	new findQuan, textid;
	for(new i = 0; i < QuanTextures; i++)
	{
		MenuInfo[playerid][zLibraryTexture][findQuan] = 0;

		if(SortingTexture(typeSorting, i, inputtext, textid))
		{
			MenuInfo[playerid][zLibraryTexture][findQuan] = textid;
			findQuan ++;
			if(findQuan >= MAX_TEXTURE_LIBRARY) break;
		}
	}

	if(findQuan > 0)
	{
		MenuInfo[playerid][zLibraryQuan] = findQuan;
		new string[80];
		format(string, sizeof(string), "{ffcc66}Поиск: %s\nНайдено %d текстур\n\n{666666}Лимит поиска: %d", inputtext, findQuan, MAX_TEXTURE_LIBRARY);
		ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",string,"*","");
		SetPaletteTexture(playerid, 1);
		Show3DBox(playerid);
		Move3DBox(playerid, 0);
	}
	else ErrorMessage(playerid, "{FF6347}Текстуры не найдены");
	return 1;
}

stock SortingTexture(typeSorting, i, const inputtext[], &textid)
{
	if(typeSorting == 0) // По тексту
	{
		if(strfind(ObjectTextures[i][TXDName], inputtext, true) != -1
			|| strfind(ObjectTextures[i][TextureName], inputtext, true) != -1
			|| strfind(ObjectTextures[i][TextureTag], inputtext, true) != -1)
		{
			textid = i;
			return 1;
		}
	}
	else if(typeSorting == 1) // По числам
	{
		new modeltextureID[32];
		valstr(modeltextureID, ObjectTextures[i][TModel]);

		if(strfind(modeltextureID, inputtext, true) != -1)
		{
			textid = i;
			return 1;
		}
	}
	return 0;
}

stock ClearSortingTexture(playerid)
{
	if(MenuInfo[playerid][zStat] == 0) return 1;
	if(MenuInfo[playerid][zLibraryStatus] == 0) return ErrorMessage(playerid, "{FF6347}Текстуры не отсортированы");

	SetPaletteTexture(playerid, 0);
	Show3DBox(playerid);
	return 1;
}

stock ClickTextDraw_TextureEditor(playerid, PlayerText:playertextid)
{
	if(DrawTextdrawEditor[playerid] == true)
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
	}

	if(playertextid == DrawTextureButton[0][playerid]) // Поиск
	{
		PlayerPlaySound(playerid,40405,0,0,0);
		ShowDialog(playerid,910,DIALOG_STYLE_LIST,"{ff9000}Поиск Текстур","{cccccc}Страница\n{cccccc}Название\n{FF6347}Сбросить Фильтр","Выбор","Отмена");
	}
	else if(playertextid == DrawTextureButton[4][playerid]) // Объекты
	{
		if(MenuInfo[playerid][zObject] >= 0)
		{
			DP[1][playerid] = 4;
			if(MenuInfo[playerid][zDom] > 0) ShowAllObject(playerid, MenuInfo[playerid][zDom], DP[1][playerid]);
			else ShowAllObjectBiz(playerid, MenuInfo[playerid][zBiz], DP[1][playerid]);
		}
	}
	else if(playertextid == DrawTextureButton[6][playerid]) // Save
	{
		if(MenuInfo[playerid][zChange] == 0) return ErrorMessage(playerid, "{FF6347}Вы не вносили изменений в текстуры объекта");
		CreateTexture(playerid);
	}
	else if(playertextid == DrawTextureButton[8][playerid]) // Exit
	{
		Destroy3DMenu(playerid);
		Close3DMenu(playerid);
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
	for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS * 2; i++)
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
	new string[90];
	if(IsDynamicObjectMaterialUsed(MenuInfo[playerid][zDynamicObject], slot))
	{
		new modelid;
		new txdname[32];
        new texturename[32];
        new materialcolor;
		GetDynamicObjectMaterial(MenuInfo[playerid][zDynamicObject], slot, modelid, txdname, texturename, materialcolor);

		format(string, sizeof(string),"%d._%d_%s_%s", slot, modelid, txdname, texturename);
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
		PlayerTextDrawBackgroundColor(playerid, TextDrawTextureMenu[i][playerid], COLOR_TEXTDRAW_STROKE_GREY);
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
		PlayerTextDrawBackgroundColor(playerid, TextDrawTextureMenu[x][playerid], COLOR_TEXTDRAW_STROKE_GREY);
		PlayerTextDrawFont(playerid, TextDrawTextureMenu[x][playerid], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawTextureMenu[x][playerid], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawTextureMenu[x][playerid], true);

		// Смещаем позицию для следующей строки
		slotpos_x -= offset_x;

		// Отображаем только определённое количество слотов под текстуры
		if(i + 1 <= MenuInfo[playerid][zMaxTexturesOnObject])
		{
			PlayerTextDrawShow(playerid, TextDrawTextureMenu[i][playerid]);
			if(bmodel >= 1) PlayerTextDrawShow(playerid, TextDrawTextureMenu[x][playerid]);
		}
	}
	return 1;
}

stock CreateTextDrawTextureButton(playerid)
{
	new Float:tpos_x[5], Float:tpos_y = 400.0;
	new Float:offset_x = 3.0; // Расстояние между квадратами

	// Размеры квадратов
	new Float:fix_x = 36.0, Float:fix_y = 41.0;
	//FixTextDrawSquare_X(Float:x, &Float:fix_y)(fix_x, fix_y);

	// Цвет текста в квадратах
	new colorText = COLOR_TEXTDRAW_GREY;
	if(PlayerInfo[playerid][pSty] == 6 || PlayerInfo[playerid][pSty] == 11) colorText = COLOR_TEXTDRAW_BLACK;

	tpos_x[0] = 176.0 + offset_x * 3;
	DrawTextureButton[0][playerid] = CreatePlayerTextDraw(playerid, tpos_x[0], tpos_y, "LD_SPAC:white"); // Кнопка Поиск
	PlayerTextDrawLetterSize(playerid, DrawTextureButton[0][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, DrawTextureButton[0][playerid], fix_x, fix_y);
	PlayerTextDrawAlignment(playerid, DrawTextureButton[0][playerid], 1);
	PlayerTextDrawColor(playerid, DrawTextureButton[0][playerid], PlayerInfo[playerid][pStyle1]);
	PlayerTextDrawFont(playerid, DrawTextureButton[0][playerid], 4);
	PlayerTextDrawSetSelectable(playerid, DrawTextureButton[0][playerid], true);

	DrawTextureButton[1][playerid] = CreatePlayerTextDraw(playerid, tpos_x[0] + fix_x/2, tpos_y + fix_y/2 - 4.0, "ЊO…CK"); // Поиск
	PlayerTextDrawLetterSize(playerid, DrawTextureButton[1][playerid], 0.181927, 0.871999);
	PlayerTextDrawAlignment(playerid, DrawTextureButton[1][playerid], 2);
	PlayerTextDrawColor(playerid, DrawTextureButton[1][playerid], colorText);
	PlayerTextDrawUseBox(playerid, DrawTextureButton[1][playerid], true);
	PlayerTextDrawBoxColor(playerid, DrawTextureButton[1][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DrawTextureButton[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DrawTextureButton[1][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DrawTextureButton[1][playerid], COLOR_TEXTDRAW_STROKE_GREY);
	PlayerTextDrawFont(playerid, DrawTextureButton[1][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DrawTextureButton[1][playerid], 1);

	tpos_x[1] = tpos_x[0] + fix_x + offset_x;
	DrawTextureButton[2][playerid] = CreatePlayerTextDraw(playerid, tpos_x[1], tpos_y, "LD_SPAC:white"); // Кнопка Мои Текстуры
	PlayerTextDrawLetterSize(playerid, DrawTextureButton[2][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, DrawTextureButton[2][playerid], fix_x, fix_y);
	PlayerTextDrawAlignment(playerid, DrawTextureButton[2][playerid], 1);
	PlayerTextDrawColor(playerid, DrawTextureButton[2][playerid], PlayerInfo[playerid][pStyle1]);
	PlayerTextDrawFont(playerid, DrawTextureButton[2][playerid], 4);
	PlayerTextDrawSetSelectable(playerid, DrawTextureButton[2][playerid], true);

	DrawTextureButton[3][playerid] = CreatePlayerTextDraw(playerid, tpos_x[1] + fix_x/2, tpos_y + fix_y/2 - 8.0, "MO…~n~ЏEKCЏYP‘"); // Мои Текстуры
	PlayerTextDrawLetterSize(playerid, DrawTextureButton[3][playerid], 0.181927, 0.871999);
	PlayerTextDrawAlignment(playerid, DrawTextureButton[3][playerid], 2);
	PlayerTextDrawColor(playerid, DrawTextureButton[3][playerid], colorText);
	PlayerTextDrawUseBox(playerid, DrawTextureButton[3][playerid], true);
	PlayerTextDrawBoxColor(playerid, DrawTextureButton[3][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DrawTextureButton[3][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DrawTextureButton[3][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DrawTextureButton[3][playerid], COLOR_TEXTDRAW_STROKE_GREY);
	PlayerTextDrawFont(playerid, DrawTextureButton[3][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DrawTextureButton[3][playerid], 1);
	
	// tpos_x[2] = tpos_x[1] + fix_x + offset_x; // Временно убираю кнопку Мои Текстуры (Система избранных текстур не готова)
	tpos_x[2] = tpos_x[0] + fix_x + offset_x;
	DrawTextureButton[4][playerid] = CreatePlayerTextDraw(playerid, tpos_x[2], tpos_y, "LD_SPAC:white"); // Кнопка Объекты
	PlayerTextDrawLetterSize(playerid, DrawTextureButton[4][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, DrawTextureButton[4][playerid], fix_x, fix_y);
	PlayerTextDrawAlignment(playerid, DrawTextureButton[4][playerid], 1);
	PlayerTextDrawColor(playerid, DrawTextureButton[4][playerid], PlayerInfo[playerid][pStyle1]);
	PlayerTextDrawFont(playerid, DrawTextureButton[4][playerid], 4);
	PlayerTextDrawSetSelectable(playerid, DrawTextureButton[4][playerid], true);

	DrawTextureButton[5][playerid] = CreatePlayerTextDraw(playerid, tpos_x[2] + fix_x/2, tpos_y + fix_y/2 - 4.0, "OЂђEKЏ‘"); // Объекты
	PlayerTextDrawLetterSize(playerid, DrawTextureButton[5][playerid], 0.181927, 0.871999);
	PlayerTextDrawAlignment(playerid, DrawTextureButton[5][playerid], 2);
	PlayerTextDrawColor(playerid, DrawTextureButton[5][playerid], colorText);
	PlayerTextDrawUseBox(playerid, DrawTextureButton[5][playerid], true);
	PlayerTextDrawBoxColor(playerid, DrawTextureButton[5][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DrawTextureButton[5][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DrawTextureButton[5][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DrawTextureButton[5][playerid], COLOR_TEXTDRAW_STROKE_GREY);
	PlayerTextDrawFont(playerid, DrawTextureButton[5][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DrawTextureButton[5][playerid], 1);
	
	tpos_x[3] = tpos_x[2] + fix_x + offset_x;
	DrawTextureButton[6][playerid] = CreatePlayerTextDraw(playerid, tpos_x[3], tpos_y, "LD_SPAC:white"); // Кнопка Save
	PlayerTextDrawLetterSize(playerid, DrawTextureButton[6][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, DrawTextureButton[6][playerid], fix_x, fix_y);
	PlayerTextDrawAlignment(playerid, DrawTextureButton[6][playerid], 1);
	PlayerTextDrawColor(playerid, DrawTextureButton[6][playerid], PlayerInfo[playerid][pStyle1]);
	PlayerTextDrawFont(playerid, DrawTextureButton[6][playerid], 4);
	PlayerTextDrawSetSelectable(playerid, DrawTextureButton[6][playerid], true);

	DrawTextureButton[7][playerid] = CreatePlayerTextDraw(playerid, tpos_x[3] + fix_x/2, tpos_y + fix_y/2 - 4.0, "SAVE"); // Save
	PlayerTextDrawLetterSize(playerid, DrawTextureButton[7][playerid], 0.181927, 0.871999);
	PlayerTextDrawAlignment(playerid, DrawTextureButton[7][playerid], 2);
	PlayerTextDrawColor(playerid, DrawTextureButton[7][playerid], colorText);
	PlayerTextDrawUseBox(playerid, DrawTextureButton[7][playerid], true);
	PlayerTextDrawBoxColor(playerid, DrawTextureButton[7][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DrawTextureButton[7][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DrawTextureButton[7][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DrawTextureButton[7][playerid], COLOR_TEXTDRAW_STROKE_GREY);
	PlayerTextDrawFont(playerid, DrawTextureButton[7][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DrawTextureButton[7][playerid], 1);

	tpos_x[4] = tpos_x[3] + fix_x + offset_x;
	DrawTextureButton[8][playerid] = CreatePlayerTextDraw(playerid, tpos_x[4], tpos_y, "LD_SPAC:white"); // Кнопка Exit
	PlayerTextDrawLetterSize(playerid, DrawTextureButton[8][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, DrawTextureButton[8][playerid], fix_x, fix_y);
	PlayerTextDrawAlignment(playerid, DrawTextureButton[8][playerid], 1);
	PlayerTextDrawColor(playerid, DrawTextureButton[8][playerid], PlayerInfo[playerid][pStyle1]);
	PlayerTextDrawFont(playerid, DrawTextureButton[8][playerid], 4);
	PlayerTextDrawSetSelectable(playerid, DrawTextureButton[8][playerid], true);

	DrawTextureButton[9][playerid] = CreatePlayerTextDraw(playerid, tpos_x[4] + fix_x/2, tpos_y + fix_y/2 - 4.0, "EXIT"); // Exit
	PlayerTextDrawLetterSize(playerid, DrawTextureButton[9][playerid], 0.181927, 0.871999);
	PlayerTextDrawAlignment(playerid, DrawTextureButton[9][playerid], 2);
	PlayerTextDrawColor(playerid, DrawTextureButton[9][playerid], colorText);
	PlayerTextDrawUseBox(playerid, DrawTextureButton[9][playerid], true);
	PlayerTextDrawBoxColor(playerid, DrawTextureButton[9][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DrawTextureButton[9][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DrawTextureButton[9][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DrawTextureButton[9][playerid], COLOR_TEXTDRAW_STROKE_GREY);
	PlayerTextDrawFont(playerid, DrawTextureButton[9][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DrawTextureButton[9][playerid], 1);

	DrawTextureButton[10][playerid] = CreatePlayerTextDraw(playerid, 482.666412, 370.0, "ЊKM_-_Њokaџa¦©_ЇЁҐky~n~Y_-_‹ўepx~n~N_-_‹®њџ~n~Num_4_-_‹ћeўo~n~Num_6_-_‹Јpaўo~n~~y~ALT_-_ЊpњЇe®њ¦©_¦ekc¦ypy");
	PlayerTextDrawLetterSize(playerid, DrawTextureButton[10][playerid], 0.329999, 1.305481);
	PlayerTextDrawAlignment(playerid, DrawTextureButton[10][playerid], 1);
	PlayerTextDrawColor(playerid, DrawTextureButton[10][playerid], COLOR_TEXTDRAW_GREY);
	PlayerTextDrawUseBox(playerid, DrawTextureButton[10][playerid], true);
	PlayerTextDrawBoxColor(playerid, DrawTextureButton[10][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DrawTextureButton[10][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DrawTextureButton[10][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DrawTextureButton[10][playerid], COLOR_TEXTDRAW_STROKE_GREY);
	PlayerTextDrawFont(playerid, DrawTextureButton[10][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DrawTextureButton[10][playerid], 1);
	PlayerTextDrawShow(playerid, DrawTextureButton[10][playerid]);

	DrawTextureButton[11][playerid] = CreatePlayerTextDraw(playerid, tpos_x[0], tpos_y - 10.0, "Text"); // Name Texture and Pages
	PlayerTextDrawLetterSize(playerid, DrawTextureButton[11][playerid], 0.209420, 0.881332);
	PlayerTextDrawAlignment(playerid, DrawTextureButton[11][playerid], 1);
	PlayerTextDrawColor(playerid, DrawTextureButton[11][playerid], COLOR_TEXTDRAW_GREY);
	PlayerTextDrawUseBox(playerid, DrawTextureButton[11][playerid], true);
	PlayerTextDrawBoxColor(playerid, DrawTextureButton[11][playerid], 0);
	PlayerTextDrawSetShadow(playerid, DrawTextureButton[11][playerid], 0);
	PlayerTextDrawSetOutline(playerid, DrawTextureButton[11][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DrawTextureButton[11][playerid], COLOR_TEXTDRAW_STROKE_GREY);
	PlayerTextDrawFont(playerid, DrawTextureButton[11][playerid], 1);
	PlayerTextDrawSetProportional(playerid, DrawTextureButton[11][playerid], 1);

	PlayerTextDrawShow(playerid, DrawTextureButton[0][playerid]);
	PlayerTextDrawShow(playerid, DrawTextureButton[1][playerid]);
	//PlayerTextDrawShow(playerid, DrawTextureButton[2][playerid]); // Временно закоментил кнопку избранных текстур
	//PlayerTextDrawShow(playerid, DrawTextureButton[3][playerid]);
	PlayerTextDrawShow(playerid, DrawTextureButton[4][playerid]);
	PlayerTextDrawShow(playerid, DrawTextureButton[5][playerid]);
	PlayerTextDrawShow(playerid, DrawTextureButton[6][playerid]);
	PlayerTextDrawShow(playerid, DrawTextureButton[7][playerid]);
	PlayerTextDrawShow(playerid, DrawTextureButton[8][playerid]);
	PlayerTextDrawShow(playerid, DrawTextureButton[9][playerid]);
	PlayerTextDrawShow(playerid, DrawTextureButton[10][playerid]);
	return 1;
}

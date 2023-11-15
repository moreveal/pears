#define MAX_TEXTURE_OBJECT 38 // Максимальное количество текстур на объекте

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
	bool:zLoadPick[12],
	zSelect,
	zList,
	zLibrary,
	zObject,
	zTextid,
	zDom,
	zBiz,
	zTexture[MAX_TEXTURE_OBJECT],
	Float:zEditX,
	Float:zEditY,
	Float:zEditZ,
	Float:zEditRX,
	Float:zEditRY,
	Float:zEditRZ,
	zChange,
};
new MenuInfo[MAX_REALPLAYERS][zInfo];

//new PlayerText:PlayerTextureEditorDraw[16][MAX_REALPLAYERS]; // Текстдравы редактора текстур

stock ObjectToTexture(playerid, i) // Отправляем объект на ретекстур (Дом, Бизнес, Личный редактор)
{
	Texture[playerid] = 1; // Ретекстур объекта
	MenuInfo[playerid][zObject] = i; // ID объекта внутри системы, которой он принадлежит
	MenuInfo[playerid][zChange] = 0; // Количество изменений
	if(MenuInfo[playerid][zDom] > 0) 
	{
		Streamer_SetIntData(STREAMER_TYPE_OBJECT, DomInfo[MenuInfo[playerid][zDom]][dObject][i], STREAMER_EDITABLE_DYNAMIC_OBJECT, 1); // Editable Dynamic Object
	}
	else if(MenuInfo[playerid][zBiz] > 0)
	{
		Streamer_SetIntData(STREAMER_TYPE_OBJECT, BizzInfo[MenuInfo[playerid][zBiz]][bObject][i], STREAMER_EDITABLE_DYNAMIC_OBJECT, 1); // Editable Dynamic Object
	}
	return 1;
}
stock RemoveObjectToTexture(playerid) // Снимаем информацию о редактируемом объекте
{
	if(MenuInfo[playerid][zObject] >= 0)
	{
	    if(MenuInfo[playerid][zDom] > 0)
		{
			Streamer_SetIntData(STREAMER_TYPE_OBJECT, DomInfo[MenuInfo[playerid][zDom]][dObject][MenuInfo[playerid][zObject]], STREAMER_EDITABLE_DYNAMIC_OBJECT, 0); // Editable Dynamic Object
		}
	    else if(MenuInfo[playerid][zBiz] > 0)
		{
			Streamer_SetIntData(STREAMER_TYPE_OBJECT, BizzInfo[MenuInfo[playerid][zBiz]][bObject][MenuInfo[playerid][zObject]], STREAMER_EDITABLE_DYNAMIC_OBJECT, 0); // Editable Dynamic Object
		}
	}
	return 1;
}

/*
Texture[
TextureObj[
TextureMenuDraw[6]
*/
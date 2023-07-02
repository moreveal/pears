#define MAX_TEXTURE_OBJECT 38 // РњР°РєСЃРёРјР°Р»СЊРЅРѕРµ РєРѕР»РёС‡РµСЃС‚РІРѕ С‚РµРєСЃС‚СѓСЂ РЅР° РѕР±СЉРµРєС‚Рµ

enum zInfo //  Enum РѕС‚РІРµС‡Р°СЋС‰РёР№ Р·Р° СЂРµРґР°РєС‚РѕСЂ С‚РµРєСЃС‚СѓСЂ
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

//new PlayerText:PlayerTextureEditorDraw[16][MAX_REALPLAYERS]; // РўРµРєСЃС‚РґСЂР°РІС‹ СЂРµРґР°РєС‚РѕСЂР° С‚РµРєСЃС‚СѓСЂ

stock ObjectToTexture(playerid, i) // РћС‚РїСЂР°РІР»СЏРµРј РѕР±СЉРµРєС‚ РЅР° СЂРµС‚РµРєСЃС‚СѓСЂ (Р”РѕРј, Р‘РёР·РЅРµСЃ, Р›РёС‡РЅС‹Р№ СЂРµРґР°РєС‚РѕСЂ)
{
	Texture[playerid] = 1; // Р РµС‚РµРєСЃС‚СѓСЂ РѕР±СЉРµРєС‚Р°
	MenuInfo[playerid][zObject] = i; // ID РѕР±СЉРµРєС‚Р° РІРЅСѓС‚СЂРё СЃРёСЃС‚РµРјС‹, РєРѕС‚РѕСЂРѕР№ РѕРЅ РїСЂРёРЅР°РґР»РµР¶РёС‚
	MenuInfo[playerid][zChange] = 0; // РљРѕР»РёС‡РµСЃС‚РІРѕ РёР·РјРµРЅРµРЅРёР№
	if(MenuInfo[playerid][zDom] > 0) DomInfo[MenuInfo[playerid][zDom]][dStio][i] = 1;
	else if(MenuInfo[playerid][zBiz] > 0) BizzInfo[MenuInfo[playerid][zBiz]][bStioInt][i] = 1;
	return 1;
}
stock RemoveObjectToTexture(playerid) // РЎРЅРёРјР°РµРј РёРЅС„РѕСЂРјР°С†РёСЋ Рѕ СЂРµРґР°РєС‚РёСЂСѓРµРјРѕРј РѕР±СЉРµРєС‚Рµ
{
	if(MenuInfo[playerid][zObject] >= 0)
	{
	    if(MenuInfo[playerid][zDom] > 0) DomInfo[MenuInfo[playerid][zDom]][dStio][MenuInfo[playerid][zObject]] = 0;
	    else if(MenuInfo[playerid][zBiz] > 0) BizzInfo[MenuInfo[playerid][zBiz]][bStioInt][MenuInfo[playerid][zObject]] = 0;
	}
	return 1;
}

/*
Texture[
TextureObj[
TextureMenuDraw[6]
*/
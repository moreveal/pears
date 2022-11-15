//AttachEdit FilterScript by ^_^, version 0.1b
//Special for pro-pawn.ru
//Credits to Daniel Cortez for help and DC_CMD plugin.
#include <a_samp>
#include <zcmd>
//#if !defined DC_CMD
//	#error To use this filterscript you need DC_CMD plugin, you can grab it here: pro-pawn.ru/showthread.php?1028-DC_CMD
//#endif

enum{
	DLG_ATTACHEDIT_MAIN	= 5000,
	DLG_ATTACHEDIT_BEGIN,
	DLG_ATTACHEDIT_OBJECT,
	DLG_ATTACHEDIT_RESET,
	DLG_ATTACHEDIT_SLOT,
	DLG_ATTACHEDIT_BONE,
	DLG_ATTACHEDIT_CLRS,
	DLG_ATTACHEDIT_CLR1,
	DLG_ATTACHEDIT_CLR2,
	DLG_ATTACHEDIT_SAVE,
};

enum _objInfo{
	o_mid,
	o_idx,
	o_bone,
	Float:o_X,
	Float:o_Y,
	Float:o_Z,
	Float:o_rX,
	Float:o_rY,
	Float:o_rZ,
	Float:o_sX,
	Float:o_sY,
	Float:o_sZ,
	o_mc1,
	o_mc2
};
static object_info[MAX_PLAYERS][_objInfo];
static bool:editing_object[MAX_PLAYERS char];

stock ShowAttachEditMainMenu(playerid)
	return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_MAIN, DIALOG_STYLE_LIST,
							"Редактор PlayerAttachedObject",
								"- Ид обьекта\n"\
								"- Слот обьекта\n"\
								"- Часть тела\n"\
								"- Редактировать параметры обьекта(координаты, ротация, размер)\n"\
								"- Цвет обьекта\n"\
								"- Сохранить",
							"Выбрать", "Закрыть");

CMD:attachedit(playerid, params[]){
	if(!editing_object{playerid})
		return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_BEGIN, DIALOG_STYLE_MSGBOX,
								"Редактор PlayerAttachedObject",
									"Вы хотите приступить к редактированию PlayerAttachedObject?",
								"Да", "Закрыть");
	return ShowAttachEditMainMenu(playerid);
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	switch(dialogid){
		case DLG_ATTACHEDIT_BEGIN:{
			if(response == 0)
				return 1;
			editing_object{playerid} = true;
			object_info[playerid][o_mid] = 0;
			object_info[playerid][o_idx] = 0;
			object_info[playerid][o_bone] = 1;
			object_info[playerid][o_X] = 0;
			object_info[playerid][o_Y] = 0;
			object_info[playerid][o_Z] = 0;
			object_info[playerid][o_rX] = 0;
			object_info[playerid][o_rY] = 0;
			object_info[playerid][o_rZ] = 0;
			object_info[playerid][o_sX] = 1;
			object_info[playerid][o_sY] = 1;
			object_info[playerid][o_sZ] = 1;
			object_info[playerid][o_mc1] = 0;
			object_info[playerid][o_mc2] = 0;
			return ShowAttachEditMainMenu(playerid);
		}
		case DLG_ATTACHEDIT_MAIN:{
			if(response == 0)
				return 1;
			switch(listitem){
				case 0:
					return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_OBJECT, DIALOG_STYLE_INPUT,
											"Ид обьекта", "Введите действительный ид обьекта:", "Выбрать", "Закрыть");
				case 1:
					return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_SLOT, DIALOG_STYLE_INPUT,
											"Ид слота",
												"Введите ид слота для данного обьекта - от 0 до 9 \n"\
												"(на данном слоте должен быть прикриплён только один предмет)",
											"Ввод", "Закрыть");
				case 2:
					return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_BONE, DIALOG_STYLE_LIST,
											"Ид части тела",
												"1 - Спина\n"\
												"2 - Голова\n"\
												"3 - Плечо левой руки\n"\
												"4 - Плечо правой руки\n"\
												"5 - Левая рука\n"\
												"6 - Правая рука\n"\
												"7 - Левое бедро\n"\
												"8 - Правое бедро\n"\
												"9 - Левая нога\n"\
												"10 - Правая нога\n"\
												"11 - Правые икры\n"\
												"12 - Левые икры\n"\
												"13 - Левое предплечье\n"\
												"14 - Правое предплечье\n"\
												"15 - Левая ключица\n"\
												"16 - Правая ключица\n"\
												"17 - Шея\n"\
												"18 - Челюсть",
											"Ввод", "Закрыть");
				case 3:
					if(object_info[playerid][o_mid])
						return EditAttachedObject(playerid, object_info[playerid][o_idx]);
					else
						return SendClientMessage(playerid, -1, "{E82E2E} Сперва нужно указать ID обьекта");
				case 4:
					return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_CLRS, DIALOG_STYLE_LIST,
											"Цвета обьекта", "- Цвет 1\n- Цвет 2", "Выбрать", "Закрыть");
				case 5:
					if(object_info[playerid][o_mid])
						return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_SAVE, DIALOG_STYLE_INPUT,
												"Сохранение",
													"Введите название файла в котором будут сохранены параметры обьекта:",
												"Ввод", "Назад");
					else
						return SendClientMessage(playerid, -1, "{E82E2E} Нет обьекта для сохранения.");
			}
		}
		case DLG_ATTACHEDIT_OBJECT:{
			if(response){
				#define oI object_info[playerid]
				SetPlayerAttachedObject(playerid, oI[o_idx], oI[o_mid] = strval(inputtext), oI[o_bone],
										oI[o_X], oI[o_Y], oI[o_Z], oI[o_rX], oI[o_rY], oI[o_rZ], oI[o_sX], oI[o_sY], oI[o_sZ],
										oI[o_mc1], oI[o_mc2]);
				if(oI[o_mid])
					return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_RESET, DIALOG_STYLE_MSGBOX,
											"Ид обьекта", "Хотите удалить параметры предыдущего обьекта?", "Да", "Нет");
				return ShowAttachEditMainMenu(playerid);
				#undef oI
			}
			return ShowAttachEditMainMenu(playerid);
		}
		case DLG_ATTACHEDIT_RESET:{
			if(response)
				SetPlayerAttachedMObject(playerid, _, _, _, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0);
			return ShowAttachEditMainMenu(playerid);
		}
		case DLG_ATTACHEDIT_SLOT:{
			if(response){
				new slot = strval(inputtext);
				if(!(1 <= slot <= 9))
					return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_SLOT, DIALOG_STYLE_INPUT,
											"Ид слота",
												"Введите ид слота для данного обьекта - от 0 до 9 "\
												"(на данном слоте должен быть прикриплён только один предмет)",
											"Ввод", "Закрыть");
				SetPlayerAttachedMObject(playerid, slot);
				return ShowAttachEditMainMenu(playerid);
			}
		}
		case DLG_ATTACHEDIT_BONE:{
			if(response)
				SetPlayerAttachedMObject(playerid, _, _, listitem+1);
			return ShowAttachEditMainMenu(playerid);
		}
		case DLG_ATTACHEDIT_CLRS:{
			if(response){
				if(listitem == 0)
					return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_CLR1, DIALOG_STYLE_INPUT, "Цвет 1", "Введите первый цвет обьетка (формат ARGB):", "Ввод", "Закрыть");
				return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_CLR2, DIALOG_STYLE_INPUT, "Цвет 2", "Введите второй цвет обьетка (формат ARGB):", "Ввод", "Закрыть");
			}

		}
		case DLG_ATTACHEDIT_CLR1:{
			if(response)
				SetPlayerAttachedMObject(playerid, _, _, _, _, _, _, _, _, _, _, _, _, HexToInt(inputtext), _);
			return ShowAttachEditMainMenu(playerid);
		}
		case DLG_ATTACHEDIT_CLR2:{
			if(response)
				SetPlayerAttachedMObject(playerid, _, _, _, _, _, _, _, _, _, _, _, _, _, HexToInt(inputtext));
			return ShowAttachEditMainMenu(playerid);
		}
		case DLG_ATTACHEDIT_SAVE:{
			new File:tmp, string[512], buffer[128];
            static const str_postfix[] = ".txt";
			if(strlen(inputtext) > sizeof(buffer)-sizeof(str_postfix))
    			return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_SAVE, DIALOG_STYLE_INPUT,
						"Сохранение",
						"Слишком длиное название файла.\n"\
						"Введите другое название файла в котором будут сохранены параметры обьекта:",
						"Ввод", "Назад");
			format(buffer, sizeof(buffer), "%s%s", inputtext, str_postfix);
			if(fexist(buffer))
				return ShowPlayerDialog(playerid, DLG_ATTACHEDIT_SAVE, DIALOG_STYLE_INPUT,
										"Сохранение",
											"Файл уже используется!\n"\
											"Введите другое название файла в котором будут сохранены параметры обьекта:",
										"Ввод", "Назад");
			tmp = fopen(buffer, io_write);
			fclose(tmp);
			tmp = fopen(buffer, io_append);
			#define	oI	object_info[playerid]
			format(string, sizeof(string),
					"SetPlayerAttachedObject(playerid, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f, %d, %d);\r\n",
					oI[o_idx], oI[o_mid], oI[o_bone],
					oI[o_X], oI[o_Y], oI[o_Z], oI[o_rX], oI[o_rY], oI[o_rZ], oI[o_sX], oI[o_sY], oI[o_sZ],
					oI[o_mc1], oI[o_mc2]);
			#undef	oI
			fwrite(tmp, string);
			fclose(tmp);
			return SendClientMessage(playerid, 0xF0F0F0FF, "Позиция сохранена.");
		}
	}
	return 0;
}

SetPlayerAttachedMObject(	playerid, index = -1, modelid = -1, bone = -1,
							Float:fOffsetX = -50.0, Float:fOffsetY = -50.0, Float:fOffsetZ = -50.0,
							Float:fRotX = -50.0, Float:fRotY = -50.0, Float:fRotZ = -50.0,
							Float:fScaleX = -50.0, Float:fScaleY = -50.0, Float:fScaleZ = -50.0,
							materialcolor1 = -1, materialcolor2 = -1){
	#define oI object_info[playerid]
	if(modelid != -1) oI[o_mid] = modelid;
	RemovePlayerAttachedObject(playerid, object_info[playerid][o_idx]);
	if(index != -1) oI[o_idx] = index;
	if(bone != -1) oI[o_bone] = bone;
	if(fOffsetX != -50.0) oI[o_X] = fOffsetX;
	if(fOffsetY != -50.0) oI[o_Y] = fOffsetY;
	if(fOffsetZ != -50.0)oI[o_Z] = fOffsetZ;
	if(fRotX != -50.0) oI[o_rX] = fRotX;
	if(fRotY != -50.0) oI[o_rY] = fRotY;
	if(fRotZ != -50.0) oI[o_rZ] = fRotZ;
	if(fScaleX != -50.0) oI[o_sX] = fScaleX;
	if(fScaleY != -50.0) oI[o_sY] = fScaleY;
	if(fScaleZ != -50.0) oI[o_sZ] = fScaleZ;
	if(materialcolor1 != -1) oI[o_mc1] = materialcolor1;
	if(materialcolor2 != -1) oI[o_mc2] = materialcolor2;
	return SetPlayerAttachedObject(	playerid, oI[o_idx], oI[o_mid], oI[o_bone],
									oI[o_X], oI[o_Y], oI[o_Z], oI[o_rX], oI[o_rY], oI[o_rZ], oI[o_sX], oI[o_sY], oI[o_sZ],
									oI[o_mc1], oI[o_mc2]);
	#undef oI
}
public OnPlayerEditAttachedObject(	playerid, response, index, modelid, boneid,
									Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,
									Float:fRotX, Float:fRotY, Float:fRotZ,
									Float:fScaleX, Float:fScaleY, Float:fScaleZ){
	if(response){
		SendClientMessage(playerid, -1, "{3DDB7A} Параметры обьекта успешно обновлены.");
		SetPlayerAttachedMObject(playerid, _, _, _, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
	}
	else{
		SendClientMessage(playerid, -1, "{E82E2E} Отмена, параметры обьекта не изменены.");
		SetPlayerAttachedMObject(playerid, 0);
	}
	return ShowAttachEditMainMenu(playerid);
}

public OnFilterScriptExit()
	for(new i; i <= GetMaxPlayers()-1; i++)
		for(new j; j <= MAX_PLAYER_ATTACHED_OBJECTS; j++)
			RemovePlayerAttachedObject(i, j);

HexToInt(string[]){
	if(string[0]==0)
		return 0;
	new i;
	new cur=1;
	new res=0;
	for(i=strlen(string);i>0;i--){
		if(string[i-1]<58)
			res=res+cur*(string[i-1]-48);
		else
			res=res+cur*(string[i-1]-65+10);
		cur=cur*16;
	}
	return res;
 }

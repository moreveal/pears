#define MAX_CRAFT_SKIN 3
#define DOP_SKIN_BUST 0
#define MAX_CLASS_SKIN 2

new SkinCraftList[MAX_CRAFT_SKIN][16] =
{
    { 610, 258, 10, 0, 246, 1, 0, 248, 1, 0, 247, 1, 0, 0, 0, 0 },            // Хим женщина
    { 611, 258, 10, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Хим мужик
    { 625, 258, 10, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 }              // Лесной
};

new SkinCraftListBust[MAX_CRAFT_SKIN+DOP_SKIN_BUST][4] =
{
    { 610, 0, 50, 0},           // Хим женщина
    { 611, 0, 50, 0},         // Хим мужик
    { 625, 1, 1, 0}          // Лесной
};

new friskQualityBustSkin[MAX_CLASS_SKIN][] =
{
    { "Защита от наркотиков в процентах" },
    { "Скрывает маркер на карте" }
};

stock FindItemSkinCraft(thingid)
{
    new result = -1;
    for(new i; i< MAX_CRAFT_SKIN+DOP_SKIN_BUST; i++)
    {
        if(thingid == SkinCraftListBust[i][0])
        {
            result = i;
            break;
        }
    }
    return result;
}

stock GetBustSkin(skinID,skinType)
{
    new result = -1;
    for(new i; i< MAX_CRAFT_SKIN+DOP_SKIN_BUST; i++)
    {
        if(skinType != SkinCraftListBust[i][1]) continue;

        if(skinID == SkinCraftListBust[i][0])
        {
            result = SkinCraftListBust[i][3];
            break;
        }
    }
    return result;
}

stock ResultCountBustSkin(skinID, skinType, SkinParam)
{
    if(FindItemSkinCraft(skinID) == -1) return 0;
    SkinParam -= 50;
    new result = 0;
    if(skinType == 1)
    {
        new Float:count = GetBustSkin(skinID,skinType);
        new Float:math = float(SkinParam)/float(1000);
        if(math > 0.5) math = 1.0;
        else if(math <= 0.1) math = -0.5;
        count *= 1 + math;
        result = floatround(count, floatround_floor);
    }
    else 
    {
        result = 1;
    }
    return result;
}

stock CreateSkinListCraft(playerid)
{
    new line[100],lines[sizeof(friskQualityBustSkin)*100],quan =-1;
    for(new i = 0; i< MAX_CRAFT_SKIN+DOP_SKIN_BUST; i++)
    {
        if(SkinCraftListBust[i][1] != quan)
        {
            quan++;
            format(line,sizeof(line),"{ff9000}%s\n",friskQualityBustSkin[quan]), strcat(lines,line);
        }
    }
    ShowDialog(playerid,SKINCRAFT_LIST_TYPE,DIALOG_STYLE_LIST,"{ff9000}Станок",lines,"Выбор","Отмена");
    return true;
}

stock CreateSkinListCraftType(playerid)
{
    new line[100],lines[MAX_CRAFT_SKIN*100],quan;
    ClearList(playerid);
    format(line,sizeof(line),"{ff9000}Бонус: {0088ff}%s\n",friskQualityBustSkin[DP[0][playerid]]), strcat(lines,line);
    for(new i = 0; i< MAX_CRAFT_SKIN; i++)
    {
        if(SkinCraftListBust[i][1] == DP[0][playerid])
        {
            format(line,sizeof(line),"{cccccc}%s\n",GetNameThing(1,SkinCraftListBust[i][0],3,0)), strcat(lines,line);
            List[quan][playerid] = i;
            quan++;
        }
    }
    ShowDialog(playerid,SKINCRAFT_LIST,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Станок",lines,"Выбор","Отмена");
    return true;
}

stock dialogCraftList(playerid)
{
    new lines[300];
	format(lines,sizeof(lines),"{cccccc}Расходники"\
                                "\n{cccccc}Аксессуары"\
                                "\n{cccccc}Скины");
	ShowDialog(playerid,CRAFT_LIST,DIALOG_STYLE_TABLIST, "{ff9000}Станок", lines, "Выбор", "Отмена");
	return true;
}

stock dialogCraftConsumablesList(playerid)
{
    new lines[300];
	format(lines,sizeof(lines),"{cccccc}Уплотненная Кожа"\
                                "\n{cccccc}Нитки"\
                                "\n{cccccc}Ткань"\
                                "\n{cccccc}Иголки");
	ShowDialog(playerid,CRAFT_CONSUMABLES_LIST,DIALOG_STYLE_TABLIST, "{ff9000}Станок", lines, "Выбор", "Отмена");
	return true;
}
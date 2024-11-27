#define MAX_CRAFT_AKS 18
#define DOP_AKS_BUST 4
#define MAX_CLASS_AKS 4

new AccessoryCraftList[MAX_CRAFT_AKS][16] =
{
    { 12355, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар разгрузка 1
    { 12356, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Пояс 1
    { 12357, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Кабура 1
    { 12358, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Подсумок 1
    { 12359, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Разгрузка 2
    { 12361, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Пояс 2
    { 12362, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Подсумок 2
    { 12363, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Разгрузка 3
    { 12364, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Разгрузка 4
    { 12365, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Разгрузка 5
    { 12366, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Разгрузка 6
    { 12367, 245, 2, 0, 246, 1, 0, 247, 1, 0, 248, 1, 0, 0, 0, 0 },          // Аксессуар Рюкзак охота 1
    { 12368, 245, 2, 0, 246, 1, 0, 247, 1, 0, 248, 1, 0, 0, 0, 0 },          // Аксессуар Рюкзак охота 2
    { 12369, 245, 2, 0, 246, 1, 0, 247, 1, 0, 248, 1, 0, 0, 0, 0 },          // Аксессуар Рюкзак охота 3
    { 12370, 245, 2, 0, 246, 1, 0, 247, 1, 0, 248, 1, 0, 0, 0, 0 },          // Аксессуар Рюкзак охота 4
    { 12371, 245, 2, 0, 246, 1, 0, 247, 1, 0, 248, 1, 0, 0, 0, 0 },          // Аксессуар Рюкзак охота 5
    { 12372, 245, 2, 0, 246, 1, 0, 247, 1, 0, 248, 1, 0, 0, 0, 0 },          // Аксессуар Рюкзак охота 6
    { 12373, 245, 2, 0, 246, 1, 0, 247, 1, 0, 248, 1, 0, 0, 0, 0 }           // Аксессуар Рюкзак охота 7
};

new AccessoryCraftListBust[MAX_CRAFT_AKS+DOP_AKS_BUST][3] =
{
    { 12355, 0, 300},         // Аксессуар разгрузка 1
    { 12356, 0, 300},         // Аксессуар Пояс 1
    { 12357, 0, 300},         // Аксессуар Кабура 1
    { 12358, 0, 300},         // Аксессуар Подсумок 1
    { 12359, 0, 300},         // Аксессуар Разгрузка 2
    { 12361, 0, 300},         // Аксессуар Пояс 2
    { 12362, 0, 300},         // Аксессуар Подсумок 2
    { 12363, 0, 300},         // Аксессуар Разгрузка 3
    { 12364, 0, 300},         // Аксессуар Разгрузка 4
    { 12365, 0, 300},         // Аксессуар Разгрузка 5
    { 12366, 0, 300},         // Аксессуар Разгрузка 6
    { 12367, 1, 3},         // Аксессуар Рюкзак охота 1
    { 12368, 1, 3},         // Аксессуар Рюкзак охота 2
    { 12369, 1, 3},         // Аксессуар Рюкзак охота 3
    { 12370, 1, 3},         // Аксессуар Рюкзак охота 4
    { 12371, 1, 3},         // Аксессуар Рюкзак охота 5
    { 12372, 1, 3},         // Аксессуар Рюкзак охота 6
    { 12373, 1, 3},         // Аксессуар Рюкзак охота 7
    { 12136, 2, 10},         // Катана
    { 12101, 2, 15},         // Са бля
    { 12444, 3, 20},         // Apple Vision Pro
    { 12290, 3, 5}         // Очки гари шпротера
};

new friskQualityBust[MAX_CLASS_AKS][] =
{
    { "Кол-во дополнительных переносимых патрон" },
    { "Дополнительных страниц инвентаря" },
    { "Урон по НПС процентов" },
    { "Дополнительный опыт к навыкам" }
};

new friskQualityBustShot[MAX_CLASS_AKS][] =
{
    { "Разгрузка" },
    { "Рюкзак" },
    { "Оружие" },
    { "Очки" }
};

new friskQualityColorAndText[6][] =
{
    { "{FF6347}Ужасное" },
    { "{D2B48C}Плохое" },
    { "{54FF9F}Нормальное" }, 
    { "{8B00FF}Хорошее" }, 
    { "{ffd700}Отличное" },
    { "{d7eb02}Легендарное" }
};

stock FindRandomItemAccessoryCraft(akstype)
{
    new quan,quanstart;
    for(new i; i< MAX_CRAFT_AKS+DOP_AKS_BUST; i++)
    {
        if(akstype == AccessoryCraftListBust[i][1])
        {
            if(quanstart == 0) quanstart = i;
            quan++;
        }
    }
    new result = random(quan)+quanstart;
    return result;
}
stock FindItemAccessoryCraft(thingid)
{
    new result = -1;
    for(new i; i< MAX_CRAFT_AKS+DOP_AKS_BUST; i++)
    {
        if(thingid == AccessoryCraftListBust[i][0])
        {
            result = i;
            break;
        }
    }
    return result;
}


stock CreateAcsListCraft(playerid)
{
    new line[100],lines[sizeof(friskQualityBust)*100],quan =-1;
    for(new i; i< MAX_CRAFT_AKS+DOP_AKS_BUST; i++)
    {
        if(AccessoryCraftListBust[i][1] != quan)
        {
            quan++;
            format(line,sizeof(line),"{ff9000}%s\n",friskQualityBustShot[quan]), strcat(lines,line);
        }
    }
    ShowDialog(playerid,ACCESSORYCRAFT_LIST_TYPE,DIALOG_STYLE_LIST,"{ff9000}Станок",lines,"Выбор","Отмена");
    return 1;
}

stock CreateAcsListCraftType(playerid)
{
    new line[100],lines[MAX_CRAFT_AKS*100],quan;
    ClearList(playerid);
    format(line,sizeof(line),"{ff9000}Бонус: {0088ff}%s\n",friskQualityBust[DP[0][playerid]]), strcat(lines,line);
    for(new i; i< MAX_CRAFT_AKS; i++)
    {
        if(AccessoryCraftListBust[i][1] == DP[0][playerid])
        {
            format(line,sizeof(line),"{cccccc}%s\n",GetNameThing(1,AccessoryCraftList[i][0],2,0)), strcat(lines,line);
            List[quan][playerid] = i;
            quan++;
        }
    }
    if(quan == 0) return AcsListCraftInformation(playerid);
    ShowDialog(playerid,ACCESSORYCRAFT_LIST,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Станок",lines,"Выбор","Отмена");
    return 1;
}

stock AcsListCraftInformation(playerid)
{
    new line[150],lines[1400];
    format(line,sizeof(line),"{ff9000}Вы выбрали %s", friskQualityBustShot[DP[0][playerid]]), strcat(lines,line);
    format(line,sizeof(line),"\n\n{cccccc}Но данный тип аксессуара увы нельзя скрафтить!"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Он может выпасть в кейсе, или выдаваться администрацией в конкурсах/мероприятиях"), strcat(lines,line);
    format(line,sizeof(line),"\n\n{ff9000}Список аксессуаров и их бонусов:"), strcat(lines,line);
    for(new i = 0; i < sizeof(AccessoryCraftListBust); i ++)
    {
        if(AccessoryCraftListBust[i][1] == DP[0][playerid]) format(line,sizeof(line),"\n{cccccc}- {0088ff}%s {cccccc}| {444444}%s: +%d", GetNameThing(0, AccessoryCraftListBust[i][0], 2, 0), friskQualityBust[DP[0][playerid]],AccessoryCraftListBust[i][2]), strcat(lines,line);
    }
    format(line,sizeof(line),"\n\n{cccccc}Подробнее об бонусах и акссеуарах можно узнать из видео об данной системе"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Либо спросив администрацию в /report"), strcat(lines,line);
    ShowDialog(playerid,ACCESSORYCRAFT_INFORMATION,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
    return 1;
}

stock GetBustAksType(AksId)
{
    new result = -1;
    for(new i; i< MAX_CRAFT_AKS+DOP_AKS_BUST; i++)
    {
        if(AksId == AccessoryCraftListBust[i][0])
        {
            result = AccessoryCraftListBust[i][1];
            break;
        }
    }
    return result;
}

stock GetBustAks(AksId,AksType)
{
    new result;
    for(new i; i< MAX_CRAFT_AKS+DOP_AKS_BUST; i++)
    {
        if(AksType != AccessoryCraftListBust[i][1]) continue;

        if(AksId == AccessoryCraftListBust[i][0])
        {
            result = AccessoryCraftListBust[i][2];
            break;
        }
    }
    return result;
}

stock ResultCountBustAks(AksId, AksType, AksParam)
{
    if(FindItemAccessoryCraft(AksId) == -1) return 0;
    new result;
    if(AksType != 1)
    {
        new Float:count = GetBustAks(AksId,AksType);
        new Float:math = float(AksParam)/float(1000);
        if(math > 0.5) math = 1.0;
        else if(math <= 0.1) math = -0.5;
        count *= 1 + math;
        result = floatround(count, floatround_floor);
    }
    else 
    {
        new count = AksParam/100;
        if(count >= 4) result = GetBustAks(AksId,AksType) + 1;
        else if(count >= 2) result = GetBustAks(AksId,AksType);
        else result = GetBustAks(AksId,AksType)-1;
    }
    return result;
}

stock IsABackPack(AksId)
{
    if(AksId == 12104 || (AksId >= 12114 && AksId <= 12133) || AksId == 12171 || AksId == 12172 || AksId == 12137 || (AksId >= 12114 && AksId <= 12133) 
    || (AksId >= 12175 && AksId <= 12195) || AksId == 12331 || AksId == 12348 || (AksId >= 12367 && AksId <= 12373) || GetBustAksType(AksId) == 1) return true;
    else return false;
}

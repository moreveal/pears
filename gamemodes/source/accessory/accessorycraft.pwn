#define MAX_CRAFT_AKS 19

new AccessoryCraftList[MAX_CRAFT_AKS][16] =
{
    { 12355, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар разгрузка 1
    { 12356, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Пояс 1
    { 12357, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Кабура 1
    { 12358, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Подсумок 1
    { 12359, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Разгрузка 2
    { 12360, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Кабура 2
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

new AccessoryCraftListBust[MAX_CRAFT_AKS][3] =
{
    { 12355, 0, 300},         // Аксессуар разгрузка 1
    { 12356, 0, 300},         // Аксессуар Пояс 1
    { 12357, 0, 300},         // Аксессуар Кабура 1
    { 12358, 0, 300},         // Аксессуар Подсумок 1
    { 12359, 0, 300},         // Аксессуар Разгрузка 2
    { 12360, 0, 300},         // Аксессуар Кабура 2
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
    { 12373, 1, 3}         // Аксессуар Рюкзак охота 7
};

new friskQualityBust[2][] =
{
    { "Кол-во дополнительных переносимых патрон" },
    { "Дополнительных страниц инвентаря(рюкзака)" }
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

stock FindItemAccessoryCraft(thingid)
{
    new result = -1;
    for(new i; i< MAX_CRAFT_AKS; i++)
    {
        if(thingid == AccessoryCraftList[i][0])
        {
            result = i;
            break;
        }
    }
    return result;
}

stock CreateAcsListCraft(playerid)
{
    new line[100],lines[MAX_CRAFT_AKS*100];
    for(new i; i< MAX_CRAFT_AKS; i++)
    {
        format(line,sizeof(line),"{ff9000}%s\n",GetNameThing(1,AccessoryCraftList[i][0],2,0)), strcat(lines,line);
    }
    ShowDialog(playerid,ACCESSORYCRAFT_LIST,DIALOG_STYLE_LIST,"{ff9000}Станок",lines,"Выбор","Отмена");
    return 1;
}

stock GetBustAksType(AksId)
{
    new result = -1;
    for(new i; i< MAX_CRAFT_AKS; i++)
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
    for(new i; i< MAX_CRAFT_AKS; i++)
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

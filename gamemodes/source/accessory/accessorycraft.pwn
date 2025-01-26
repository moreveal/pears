#define MAX_CRAFT_AKS 18
#define DOP_AKS_BUST 6
#define MAX_CLASS_AKS 5

new AccessoryCraftList[MAX_CRAFT_AKS][16] =
{
    { 12355, 244, 2, 0, 246, 1, 0, 248, 1, 0, 247, 1, 0, 0, 0, 0 },            // Аксессуар разгрузка 1
    { 12356, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Пояс 1
    { 12357, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Кабура 1
    { 12358, 244, 3, 0, 246, 1, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Подсумок 1
    { 12359, 244, 1, 0, 246, 1, 0, 248, 1, 0, 245, 1, 0, 247, 1, 0 },            // Аксессуар Разгрузка 2
    { 12361, 244, 2, 0, 246, 2, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Пояс 2
    { 12362, 244, 2, 0, 246, 2, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Подсумок 2
    { 12363, 244, 2, 0, 246, 2, 0, 248, 1, 0, 0, 0, 0, 0, 0, 0 },            // Аксессуар Разгрузка 3
    { 12364, 244, 1, 0, 246, 2, 0, 248, 1, 0, 247, 1, 0, 0, 0, 0 },            // Аксессуар Разгрузка 4
    { 12365, 244, 1, 0, 246, 2, 0, 248, 1, 0, 247, 1, 0, 0, 0, 0 },            // Аксессуар Разгрузка 5
    { 12366, 244, 1, 0, 246, 2, 0, 248, 1, 0, 247, 1, 0, 0, 0, 0 },            // Аксессуар Разгрузка 6
    { 12367, 0, 0, 0, 246, 1, 0, 247, 3, 0, 248, 1, 0, 0, 0, 0 },          // Аксессуар Рюкзак охота 1
    { 12368, 0, 0, 0, 246, 1, 0, 247, 3, 0, 248, 1, 0, 0, 0, 0 },          // Аксессуар Рюкзак охота 2
    { 12369, 0, 0, 0, 246, 1, 0, 247, 3, 0, 248, 1, 0, 0, 0, 0 },          // Аксессуар Рюкзак охота 3
    { 12370, 245, 1, 0, 246, 1, 0, 247, 1, 0, 248, 2, 0, 0, 0, 0 },          // Аксессуар Рюкзак охота 4
    { 12371, 245, 1, 0, 246, 1, 0, 247, 1, 0, 248, 2, 0, 0, 0, 0 },          // Аксессуар Рюкзак охота 5
    { 12372, 245, 1, 0, 246, 1, 0, 247, 1, 0, 248, 2, 0, 0, 0, 0 },          // Аксессуар Рюкзак охота 6
    { 12373, 245, 1, 0, 246, 1, 0, 247, 1, 0, 248, 2, 0, 0, 0, 0 }           // Аксессуар Рюкзак охота 7
};

new AccessoryCraftListBust[MAX_CRAFT_AKS+DOP_AKS_BUST][5] =
{
    { 12355, 0, 1, 500, 0},         // Аксессуар разгрузка 1
    { 12356, 0, 1, 300, 0},         // Аксессуар Пояс 1
    { 12357, 0, 8, 300, 0},         // Аксессуар Кабура 1
    { 12358, 0, 1, 300, 0},         // Аксессуар Подсумок 1
    { 12359, 0, 1, 600, 0},         // Аксессуар Разгрузка 2
    { 12361, 0, 1, 400, 0},         // Аксессуар Пояс 2
    { 12362, 0, 1, 400, 0},         // Аксессуар Подсумок 2
    { 12363, 0, 1, 400, 0},         // Аксессуар Разгрузка 3
    { 12364, 0, 1, 450, 0},         // Аксессуар Разгрузка 4
    { 12365, 0, 1, 450, 0},         // Аксессуар Разгрузка 5
    { 12366, 0, 1, 450, 0},         // Аксессуар Разгрузка 6
    { 12367, 1, 1, 3, 0},         // Аксессуар Рюкзак охота 1
    { 12368, 1, 1, 3, 0},         // Аксессуар Рюкзак охота 2
    { 12369, 1, 1, 3, 0},         // Аксессуар Рюкзак охота 3
    { 12370, 1, 1, 2, 0},         // Аксессуар Рюкзак охота 4
    { 12371, 1, 1, 2, 0},         // Аксессуар Рюкзак охота 5
    { 12372, 1, 1, 2, 0},         // Аксессуар Рюкзак охота 6
    { 12373, 1, 1, 2, 0},         // Аксессуар Рюкзак охота 7
    { 12136, 2, 1, 10, 0},         // Катана
    { 12101, 2, 1, 15, 0},         // Са бля
    { 12461, 2, 1, 15, 1},         // Катана New Year
    { 12444, 3, 0, 20, 0},         // Apple Vision Pro
    { 12290, 3, 0, 5, 0},         // Очки гари шпротера
    { 12492, 4, 17, 1, 1}           // Лучший админ // ДВИНУТЬ ПОТОМ ИЛИ ПЕРЕПИСАТЬ
};

new friskQualityBust[MAX_CLASS_AKS][] =
{
    { "Кол-во дополнительных переносимых патрон" },
    { "Дополнительных страниц инвентаря" },
    { "Урон по НПС процентов" },
    { "Дополнительный опыт к навыкам" },
    { "X2 Point и Score, норма онлайна вдвое меньше"}
};

new friskQualityBustShot[MAX_CLASS_AKS][] =
{
    { "Разгрузка" },
    { "Рюкзак" },
    { "Оружие" },
    { "Очки" },
    { "Цепь" }
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
        if(akstype == AccessoryCraftListBust[i][1] && !AccessoryCraftListBust[i][4])
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
            if(quan == 4) continue;
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
    format(line,sizeof(line),"\n\n{cccccc}Но данный тип аксессуара, увы, нельзя скрафтить!"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Он может выпасть в шкатулке, или выдаваться администрацией в конкурсах/мероприятиях"), strcat(lines,line);
    format(line,sizeof(line),"\n\n{ff9000}Список аксессуаров и их бонусов:"), strcat(lines,line);
    for(new i = 0; i < sizeof(AccessoryCraftListBust); i ++)
    {
        if(AccessoryCraftListBust[i][1] == DP[0][playerid]) format(line,sizeof(line),"\n{cccccc}- {0088ff}%s {cccccc}| {444444}%s: +%d", GetNameThing(0, AccessoryCraftListBust[i][0], 2, 0), friskQualityBust[DP[0][playerid]],AccessoryCraftListBust[i][3]), strcat(lines,line);
    }
    format(line,sizeof(line),"\n\n{cccccc}Подробнее об бонусах и аксессуарах можно узнать из видео о данной системе"), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Либо спросив администрацию в [ /report ]"), strcat(lines,line);
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
            result = AccessoryCraftListBust[i][3];
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
    else if(AksType == 4)
    {
        result = 1;
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

alias:giveaccessorycraft("giveakscraft")
cmd:giveaccessorycraft(playerid, const params[])
{
    new targetid,aksid,para;
	if(PlayerInfo[playerid][pSoska] < 15) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "iii", targetid,aksid,para)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать крафтовый аксессуар с бонусом игроку [ /giveaccessorycraft ID AKSID Параметр]");
	if(!IsOnline(targetid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Его вообще нет..");
    if(FindItemAccessoryCraft(aksid) == -1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Данного аксессуара нет в списке крафтов");
    if(para < 1 || para > 599) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Параметр не должен быть выше 599 и не ниже 1!");

    new put_inva = GiveThingPlayer(targetid, aksid, 1, para, 0, 2, 0, 9999);
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре");

    new string[100];
    format(string, sizeof(string), "Администратор %s выдал вам крафтовый аксессуар ID: %d", PlayerInfo[playerid][pName], aksid);
    SendClientMessage(targetid, COLOR_WHITE, string);
    format(string, sizeof(string), "Вы выдали %s крафтовый аксессуар ID %d", PlayerInfo[targetid][pName],aksid);
    SendClientMessage(playerid, COLOR_WHITE, string);
    AdminLog("giveaccessorycraft", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[targetid][pID], PlayerInfo[targetid][pName], PlayerInfo[targetid][pPlaIP], aksid, "");

	return 1;
}
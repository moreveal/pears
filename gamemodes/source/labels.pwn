
// Система личных лейблов

enum labelsENUM
{
    labelCreate,
    labelType,
    PlayerText3D:label3D[MAX_OBJECT_INT],
    labelStatus[MAX_OBJECT_INT]
};
new LabelsInfo[MAX_REALPLAYERS][labelsENUM];

new LabelsInfoTypeName[][] =
{
    "нет", "Дом", "Бизнес", "Мап Админов", "Мап Банд", "Личый Редактор", "NPC Боты"
};

stock CreateForPlayer3DLabel(playerid, labelid, Float:x, Float:y, Float:z) // Создаём один лейбл для игрока в нужной точке
{
    if(LabelsInfo[playerid][labelStatus][labelid] != 0) return 0;
    LabelsInfo[playerid][label3D][labelid] = CreatePlayer3DTextLabel(playerid,"   ",0x008080FF, x, y, z, 100.0);
    LabelsInfo[playerid][labelStatus][labelid] = 1;
    return 1;
}

stock UpdateForPlayer3DLabel(playerid, labelid, const text[]) // Обновляем текст лейбла для игрока
{
    if(LabelsInfo[playerid][labelStatus][labelid] == 0) return 0;
	UpdatePlayer3DTextLabelText(playerid, LabelsInfo[playerid][label3D][labelid], 0xA9C4E4FF, text);
    return 1;
}

stock DeleteForPlayer3DLabel(playerid, labelid) // Удаляем один лейбл для игрока
{
    LabelsInfo[playerid][labelStatus][labelid] = 0;
    DeletePlayer3DTextLabel(playerid, LabelsInfo[playerid][label3D][labelid]);
    return 1;
}

stock DeleteAllForPlayer3DLabel(playerid)
{
    for(new i = 0; i < MAX_OBJECT_INT; i++)
    {
        if(LabelsInfo[playerid][labelStatus][i] != 0) DeleteForPlayer3DLabel(playerid, i);
    }
}

stock ClosePlayer3DLabelAll(playerid) // Удаляем все лейблы для игрока
{
    DeleteAllForPlayer3DLabel(playerid);
    LabelsInfo[playerid][labelCreate] = 0;
    LabelsInfo[playerid][labelType] = 0;
    return 1;
}

stock DeleteAll3DLabel(id, type) // Удаляем все лейблы разом для игрока, у которого они отображаются
{
    foreach(Player,i)
	{
        if(LabelsInfo[i][labelCreate] == id && LabelsInfo[i][labelType] == type) ClosePlayer3DLabelAll(i);
    }
    return 1;
}

stock CheckLabelsNearby(playerid)
{
    new type = LabelsInfo[playerid][labelType];
    new id = LabelsInfo[playerid][labelCreate];
    new world = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);

    new bool:yesClose;
    if(type == 1) // Лейблы домов
    {
        if(world == 0 && interior == 0) 
        {
            if(!IsPlayerInRangeOfPoint(playerid,50.0, DomInfo[id][dKoordinatX], DomInfo[id][dKoordinatY], DomInfo[id][dKoordinatZ])) yesClose = true;
        }
        else if(world == id + 1000)
        {
		    if(!IsPlayerInRangeOfPoint(playerid,200.0, DomInfo[id][dEnterX], DomInfo[id][dEnterY], DomInfo[id][dEnterZ])) yesClose = true;
        }
        else yesClose = true;
    }
    else if(type == 2) // Лейблы бизов
    {
        if(world == 0 && interior == 0) 
        {
            if(!IsPlayerInRangeOfPoint(playerid,50.0, BizzInfo[id][bEnterX],BizzInfo[id][bEnterY],BizzInfo[id][bEnterZ])) yesClose = true;
        }
        else if(world == id + 3000)
        {
		    if(!IsPlayerInRangeOfPoint(playerid,200.0, BizzInfo[id][bInteriorX], BizzInfo[id][bInteriorY], BizzInfo[id][bInteriorZ])) yesClose = true;
        }
        else yesClose = true;
    }

    if(yesClose)
    {
        ClosePlayer3DLabelAll(playerid);
        ErrorMessage(playerid, "{FF6347}Отображение 3D Лейблов было отключено\n{cccccc}Вы далеко отошли от редактируемых объектов");
    }
    return 1;
}


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

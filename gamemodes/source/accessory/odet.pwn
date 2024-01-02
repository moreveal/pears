
#define MAX_ODET 5 // Максимальное количество аксессуаров на игроке

// Отображаем аксессуар на игроке
stock Odet(playerid, slot)
{
	new sl;
	if(slot == 5) sl = 0;
	else if(slot == 6) sl = 1;
	else if(slot == 7) sl = 2;
	else if(slot == 8) sl = 3;
	else if(slot == 9) sl = 4;
	RemovePlayerAttachedObject(playerid, slot);
	SetPlayerAttachedObject(playerid, slot, PlayerInfo[playerid][pOdet][sl], PlayerInfo[playerid][pOdetBone][sl], PlayerInfo[playerid][pOdet_X][sl], PlayerInfo[playerid][pOdet_Y][sl], PlayerInfo[playerid][pOdet_Z][sl], PlayerInfo[playerid][pOdet_rX][sl], PlayerInfo[playerid][pOdet_rY][sl], PlayerInfo[playerid][pOdet_rZ][sl], PlayerInfo[playerid][pOdet_sX][sl], PlayerInfo[playerid][pOdet_sY][sl], PlayerInfo[playerid][pOdet_sZ][sl], 0, 0);
	
	if(IsArmor(PlayerInfo[playerid][pOdet][sl]) && PlayerInfo[playerid][pArmor] <= 0)
	{
	    PlayerInfo[playerid][pOdet][sl] = 0;
		PlayerInfo[playerid][pOdetPara][sl] = 0;
		PlayerInfo[playerid][pOdetQara][sl] = 0;
		RemovePlayerAttachedObject(playerid, slot);
	}
}

// Сохраняем 1 слот аксессуара
stock UpdateOdet(playerid, sl)
{
	new mysl = sl + 1;

	new string_mysql[600];
	format(string_mysql, sizeof(string_mysql), "UPDATE `pp_igroki` SET `Odet%d`='%d',`Odet_X%d`='%f',`Odet_Y%d`='%f',`Odet_Z%d`='%f',\
	`Odet_rX%d`='%f',`Odet_rY%d`='%f',`Odet_rZ%d`='%f',`Odet_sX%d`='%f',`Odet_sY%d`='%f',`Odet_sZ%d`='%f',`OdetPara%d`='%d',\
	`OdetQara%d`='%d',`OdetBone%d`='%d' WHERE `id`='%d'",
	mysl,PlayerInfo[playerid][pOdet][sl],mysl,PlayerInfo[playerid][pOdet_X][sl],mysl,PlayerInfo[playerid][pOdet_Y][sl],mysl,PlayerInfo[playerid][pOdet_Z][sl],
	mysl,PlayerInfo[playerid][pOdet_rX][sl],mysl,PlayerInfo[playerid][pOdet_rY][sl],mysl,PlayerInfo[playerid][pOdet_rZ][sl],
	mysl,PlayerInfo[playerid][pOdet_sX][sl],mysl,PlayerInfo[playerid][pOdet_sY][sl],mysl,PlayerInfo[playerid][pOdet_sZ][sl],mysl,PlayerInfo[playerid][pOdetPara][sl],mysl,PlayerInfo[playerid][pOdetQara][sl],
	mysl,PlayerInfo[playerid][pOdetBone][sl],PlayerInfo[playerid][pID]); // 265 + 55 + 26 + 180
	query_empty(pearsq, string_mysql); // 526
    return 1;
}

// Сохраняем все слоты аксессуаров
stock UpdateAllOdet(playerid)
{
	new string_mysql[3000];
    format(string_mysql,sizeof(string_mysql),"UPDATE `pp_igroki` SET `Odet1`='%d',`Odet_X1`='%f',`Odet_Y1`='%f',`Odet_Z1`='%f',\
	`Odet_rX1`='%f',`Odet_rY1`='%f',`Odet_rZ1`='%f',`Odet_sX1`='%f',`Odet_sY1`='%f',`Odet_sZ1`='%f',`OdetPara1`='%d',`OdetQara1`='%d',`OdetBone1`='%d'",
	PlayerInfo[playerid][pOdet][0],PlayerInfo[playerid][pOdet_X][0],PlayerInfo[playerid][pOdet_Y][0],PlayerInfo[playerid][pOdet_Z][0],
	PlayerInfo[playerid][pOdet_rX][0],PlayerInfo[playerid][pOdet_rY][0],PlayerInfo[playerid][pOdet_rZ][0],
	PlayerInfo[playerid][pOdet_sX][0],PlayerInfo[playerid][pOdet_sY][0],PlayerInfo[playerid][pOdet_sZ][0],PlayerInfo[playerid][pOdetPara][0],PlayerInfo[playerid][pOdetQara][0],
	PlayerInfo[playerid][pOdetBone][0]); // 232 + 44 + 180

    new mysl;
	for(new i = 1; i < MAX_ODET; i++)
    {
        mysl = i + 1;
        format(string_mysql,sizeof(string_mysql),"%s, `Odet%d`='%d',`Odet_X%d`='%f',`Odet_Y%d`='%f',`Odet_Z%d`='%f',\
	        `Odet_rX%d`='%f',`Odet_rY%d`='%f',`Odet_rZ%d`='%f',`Odet_sX%d`='%f',`Odet_sY%d`='%f',`Odet_sZ%d`='%f',`OdetPara%d`='%d',`OdetQara%d`='%d',`OdetBone%d`='%d'", string_mysql,
	    mysl,PlayerInfo[playerid][pOdet][i],mysl,PlayerInfo[playerid][pOdet_X][i],mysl,PlayerInfo[playerid][pOdet_Y][i],mysl,PlayerInfo[playerid][pOdet_Z][i],
        mysl,PlayerInfo[playerid][pOdet_rX][i],mysl,PlayerInfo[playerid][pOdet_rY][i],mysl,PlayerInfo[playerid][pOdet_rZ][i],
        mysl,PlayerInfo[playerid][pOdet_sX][i],mysl,PlayerInfo[playerid][pOdet_sY][i],mysl,PlayerInfo[playerid][pOdet_sZ][i],mysl,PlayerInfo[playerid][pOdetPara][i],mysl,PlayerInfo[playerid][pOdetQara][i],
        mysl,PlayerInfo[playerid][pOdetBone][i]); // 234 + 26 + 44 + 180 (2420)
    }
    format(string_mysql,sizeof(string_mysql),"%s WHERE `id`='%d'", string_mysql, PlayerInfo[playerid][pID]); // 19 + 11
	query_empty(pearsq, string_mysql);
    return 1;
}
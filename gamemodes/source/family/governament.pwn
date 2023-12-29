enum rallygov
{
    rallyStatus, // Статус митинга.
    rallyInfo[40], // Название.
    rallyInfo[120], // Тема митинга.
    rallyFam, // Семья начавшая митинг.
    rallyPoint, // Количество очков.
}
new RallyInfo[1][rallygov]

stock StartRally(playerid)
{
    new fam = PlayerInfo[playerid][pID];
    if(FamilyInfo[fam][fType] != 2) return ErrorMessage(playerid,"{ff6347}Начать митинг может только участник партии!")
    ShowDialog(playerid,1455,DIALOG_STYLE_INPUT,"{ff9000}Напишите назвиние митинга","{cccccc}Введите краткое{ff9000}название {cccccc}для митинга\n\nПример: Отмена нового закана №32","Принять","Отмена");
}

stock rally(playerid,status)
{
    if(RallyInfo[0][rallyStatus] = 0) return ErrorMessage(playerid,"{ff6347}Сейччас нет митинга!")
    SetPlayerAttachedObject(selectplayerid, 3, 3461, 6, -0.079999, -0.008000, 0.315000, -172.200027, -158.500000, 0.000000, 0.344999, 0.379999, 0.424000, 0, 0); // Факел
    if(status == 1) OnlinIno[playerid][oRally] = 1;
    else(status ==2 =) OnlinIno[playerid][oRally] = 2;
    SuccessMessage(playerid,"{66ff99} Вы начали участвовать в митиинг");
    return 1;
}

stock SetRallyPoint(playerid)
{
    if(OnlinIno[playerid][oRally] == 0) r 
    if(OnlinIno[playerid][oRally] == 1) RallyInfo[0][rallyPoint] += 1;
    else(OnlinIno[playerid][oRally] == 2) RallyInfo[0][rallyPoint] -= 1; 
}
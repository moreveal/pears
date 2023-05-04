stock IsAQuestActor(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid,5.0,2530.8591,-1664.4253,15.1665)) return 1;
	return 0;
}

stock dailyquest(playerid)
{
	if(PlayerInfo[playerid][pMember] >= 13 && PlayerInfo[playerid][pMember] <= 18) return ErrorMessage(playerid, "{FF6347}Вы не состоите в банде");
	
	format(lines,sizeof(lines),""); // Очищаем Lines
	
	if(PlayerInfo[playerid][pAchieve][124] == 0) 
	{
		format(line,sizeof(line),"{99ff66}Подрочить \t {ffff00}[ Невыполнен ]\n"), strcat(lines,line);
	}
	else
	{
	format(line,sizeof(line),"{99ff66}Подрочить \t {00cc00}[ Выполнен ]\n"), strcat(lines,line);
	}
	if(PlayerInfo[playerid][pAchieve][125] == 0) 
	{
		format(line,sizeof(line),"{99ff66}Посрать \t {ffff00}[ Невыполнен ]\n"), strcat(lines,line);
	}
	else
	{
	format(line,sizeof(line),"{99ff66}Посрать \t {00cc00}[ Выполнен ]\n"), strcat(lines,line);
	}
	ShowDialog(playerid,1400,DIALOG_STYLE_TABLIST,"{ff9000}Ежедневные квесты",lines,"Выбор","Отмена");
	return 1;
}
alias:media("test")
CMD:media(playerid)
{
	if(PlayerInfo[playerid][pMedia] == 0 && server > 0) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

	// Выдаём медийку на тестовом сервере
	if(server == 0 && PlayerInfo[playerid][pSoska] < 15) PlayerInfo[playerid][pMedia] = 2;

	PlayerPlaySound(playerid,40405,0,0,0);
	new str[70], sctring[1000];
	format(str,sizeof(str),"{ff9000}Список Команд \t\t"), strcat(sctring,str);
	format(str,sizeof(str),"\n{cccccc}Медиа партнёры \t\t"), strcat(sctring,str);
	format(str,sizeof(str),"\n{cccccc}Активации Промокода \t\t"), strcat(sctring,str);
	format(str,sizeof(str),"\n{cccccc}Рефералы \t{ff9000}[%d]\t",PlayerInfo[playerid][pRefreg]), strcat(sctring,str);
	
	format(str, sizeof(str), "\n{cccccc}Чат Медиа \t%s\t{ff9000}/y", PlayerInfo[playerid][pTransmitterOff][7] ? "{FF6347}[ Off ]" : "{99ff66}[ On ]"), strcat(sctring, str);

	// Голосовой Чат
	if(gAvoi[playerid]) format(str,sizeof(str),"\n{cccccc}Voice Администрации \t{99ff66}[ On ]\t{ff9000}Кнопка Z"), strcat(sctring,str);
	else format(str,sizeof(str),"\n{cccccc}Voice Администрации \t{FF6347}[ Off ]\t{ff9000}Кнопка Z"), strcat(sctring,str);
	
	if(get_invent2(playerid, 156, 0) >= 1) format(str,sizeof(str),"\n{444444}%s \t{cccccc}[ Имеется ]\t", friskName[156]), strcat(sctring,str);
	else format(str,sizeof(str),"\n{444444}Получить: %s \t\t", friskName[156]), strcat(sctring,str);
	if(get_invent2(playerid, 157, 0) >= 1) format(str,sizeof(str),"\n{444444}%s \t{cccccc}[ Имеется ]\t", friskName[157]), strcat(sctring,str);
	else format(str,sizeof(str),"\n{444444}Получить: %s \t\t", friskName[157]), strcat(sctring,str);
	if(get_invent2(playerid, 158, 0) >= 1) format(str,sizeof(str),"\n{444444}%s \t{cccccc}[ Имеется ]\t", friskName[158]), strcat(sctring,str);
	else format(str,sizeof(str),"\n{444444}Получить: %s \t\t", friskName[158]), strcat(sctring,str);
	if(get_invent2(playerid, 159, 0) >= 1) format(str,sizeof(str),"\n{444444}%s\t{cccccc}[ Имеется ]\t", friskName[159]), strcat(sctring,str);
	else format(str,sizeof(str),"\n{444444}Получить: %s \t\t", friskName[159]), strcat(sctring,str);
	
	if(PlayerInfo[playerid][pBilet] == 1) format(str,sizeof(str),"\n{444444}Военный Билет \t{cccccc}[ Имеется ]\t"), strcat(sctring,str);
	else format(str,sizeof(str),"\n{444444}Получить Военный Билет \t\t"), strcat(sctring,str);

	if(server == 0)
	{
		format(str,sizeof(str),"\n{444444}Получить (test project): {99ff66}10.000.000$ \t\t"), strcat(sctring,str);
		format(str,sizeof(str),"\n{444444}Получить (test project): {ffcc66}10.000G \t\t"), strcat(sctring,str);
	}

	ShowDialog(playerid,1188,DIALOG_STYLE_TABLIST,"{ff9000}Медиа",sctring,"Выбор","Отмена");
	return 1;
}

CMD:ahelpmedia(playerid)
{
    if(PlayerInfo[playerid][pMedia] < 3) return ErrorMessage(playerid, "{FF6347}Эти команды доступны только для медиа партнёров 3 Уровня\n{cccccc}У вас есть доступ к некоторым функциям в этом меню только на тестовом сервере");
    new stro[90],sctringo[1720];
    format(stro,sizeof(stro),"\n{ff9000}Команды Медиа:"), strcat(sctringo,stro);
	format(stro,sizeof(stro),"\n{cccccc}/veh /delveh - создание и удаление транспорта"), strcat(sctringo,stro);
	format(stro,sizeof(stro),"\n{cccccc}/skin - выдать себе временный визуальный скин"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/sp /spoff - Слежка за игроком"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/izol /unizol - Поместить/вытащить игрока в изолятор"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/mir /unmir - поместить в отдельный вирт мир"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/readconnect /readkill /readdm /readhit /rvanka - вывод лога в чат"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/loc - локации обычноый ГТА"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/pames | /delpames - Список игроков с описанием | удалить описание игрока"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/delaction - Удалить /action игроку"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/bump | /slap - Воткнуть в землю | Поднять над землей"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/sprays /checkveh /checkmed /checkgoods /checkskill /checkpotreb"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/trigger - Срабатование античита"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/jetpack | /geo - Джетпак | Откуда игрок"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/plworld | /plint - установить Мир/Интерьер"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/freezeall | /unfreezeall - Заморозить/разморозить игроков в радиусе 50 метров"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/freeze | /unfreeze - Заморозить/разморозить игрока"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/animbot /bottext /bot /delbot - Взаимодействие с ботами"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/cobject /eobject /dobject /map - Маппинг"), strcat(sctringo,stro);
    format(stro,sizeof(stro),"\n{cccccc}/map /setskingro /setskinmp /makeparty /givegungro - Для мероприятия"), strcat(sctringo,stro);
	format(stro,sizeof(stro),"\n{cccccc}/paygold - Передать золото игроку"), strcat(sctringo,stro);
    ShowDialog(playerid,1187,DIALOG_STYLE_MSGBOX,"{ff9000}Медиа",sctringo,"Oк","");
    return 1;
}

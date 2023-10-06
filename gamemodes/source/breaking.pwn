#define MAX_SCALES 6

new Float:breakingdraw_x = 255.000000, Float:breakingdraw_y = 197.000000; // Относительное расположение текстдравов на экране

new bool:breakingDraw[MAX_REALPLAYERS];
new BreakingTimer[MAX_REALPLAYERS]; //  ID таймера для движения шкалы
new BreakingScale[MAX_REALPLAYERS]; // Какая шкала в данный момент движется (0-5)
new BreakingMaxScales[MAX_REALPLAYERS]; // Количество шкал в момент взлома
new Float:BreakingScaleStat[MAX_REALPLAYERS]; // Прогресс движения шкалы
new Float:BreakingThickness[MAX_REALPLAYERS]; // Толщина зелёной зоны шкал
new Float:BreakingMinYPos[MAX_SCALES][MAX_REALPLAYERS]; // Нижняя граница зеленой зоны
new Float:BreakingMaxYPos[MAX_SCALES][MAX_REALPLAYERS]; // Верхняя граница зеленой зоны
new BreakingType[MAX_REALPLAYERS]; // Тип взлома (Что взламываем 0 дом, 1 дверь транспорта)
new BreakingTypeID[MAX_REALPLAYERS]; // ID Того, что мы взламываем (ID дома или транспорта)

new PlayerText:BreakingPlayerDraw[14][MAX_REALPLAYERS]; // Текстдравов взлома (оформление, рамки и ключик)
new PlayerText:BreakingScalePlayerDraw[24][MAX_REALPLAYERS]; // Текстдравы бара для взлома

stock CreateBreaking(playerid, type, breakingId, hardLevel) // Открываем мини игру для взлома
{
	if(get_invent4(playerid, 19, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет отмычек\nY >> GPS >> Услуги >> Супермаркеты");
    if(breakingDraw[playerid]) return ErrorMessage(playerid, "{FF6347}Вы уже взламываете замок");
    BreakingScaleStat[playerid] = 0.0;
    LoadBreakingType(playerid, type, breakingId);
    
    SetPlayerChatBubble(playerid,"достаёт отмычки и начинает взламывать замок",COLOR_PURPLE,20.0,3000);
    ApplyAnimation(playerid,"COP_AMBIENT","Copbrowse_loop",4.0,0,1,1,1,1,1);
    
    if(hardLevel == 0) BreakingThickness[playerid] = -8.0, CreateBreakingDraw(playerid, 3);
    else if(hardLevel == 1) BreakingThickness[playerid] = -6.0, CreateBreakingDraw(playerid, 4);
    else if(hardLevel == 2) BreakingThickness[playerid] = -4.0, CreateBreakingDraw(playerid, 5);
    else if(hardLevel == 3) BreakingThickness[playerid] = -2.0, CreateBreakingDraw(playerid, 6);

    SelectBreakingScale(playerid, 0); // Начинаем действие с первой шкалы взлома (0)
	for(new i = 0; i < 14; i++) PlayerTextDrawShow(playerid, BreakingPlayerDraw[i][playerid]);
	for(new i = 0; i < 24; i++)
	{
	    if(i != 3 && i != 7 && i != 11 && i != 15 && i != 19 && i != 23){ // Показываем все, кроме галочек
			PlayerTextDrawShow(playerid, BreakingScalePlayerDraw[i][playerid]);
		}
	}
	SelectColorDraw(playerid); // Включаем кликабельность текстдравов
	BreakingTimer[playerid] = SetTimerEx("BreakingProcess", 100, true, "d", playerid,1); // Запускаем таймер для заполнения шкалы
	return 1;
}
stock LoadBreakingType(playerid, type, breakingId) // Отмечаем ту дверь, которую взламываем
{
	PlayerInfo[playerid][pFixCamera] = 0;
    BreakingType[playerid] = type;
    BreakingTypeID[playerid] = breakingId;
	if(type == 0) // Взламываем дом
	{
	    if(DomInfo[breakingId][dBreaking] > 0) return ErrorMessage(playerid, "{FF6347}Эту дверь уже кто-то взламывает");
	    DomInfo[breakingId][dBreaking] = PlayerInfo[playerid][pID];
	}
	else if(type == 1) // Взламываем дверь транспорта
	{
	    if(VehInfo[breakingId][vBreaking] > 0) return ErrorMessage(playerid, "{FF6347}Этот транспорт уже кто-то взламывает");
	    VehInfo[breakingId][vBreaking] = PlayerInfo[playerid][pID];
		PlayerInfo[playerid][pFixCamera] = IsPlayerRangeOfCamer(playerid);
	}
	else if(type == 2) // Взламываем двигатель
	{
	    if(VehInfo[breakingId][vBreaking] > 0) return ErrorMessage(playerid, "{FF6347}Этот транспорт уже кто-то взламывает");
	    VehInfo[breakingId][vBreaking] = PlayerInfo[playerid][pID];
		PlayerInfo[playerid][pFixCamera] = IsPlayerRangeOfCamer(playerid);
	}
	return 1;
}
CMD:stopbreaking(playerid)
{
	StopBreaking(playerid);
}
forward BreakingProcess(playerid);
public BreakingProcess(playerid) // Таймер заполнения шкалы
{
	if(BreakingScale[playerid] >= 0 && BreakingScale[playerid] < MAX_SCALES)
	{
		if(BreakingScaleStat[playerid] > -31.0) // Двигаем шкалу
		{
    		BreakingScaleStat[playerid] -= 2.0;
    		UpdateTextDrawBreakingScale(playerid);
		}
		else // Шкала добралась до верхней позиции. Взлом проёбан
		{
		    StopBreaking(playerid);
		   	ErrorMessage(playerid, "{FF6347}У вас не получилось взломать замок");
		   	new mkey = get_and_take_invent(playerid, 19, 1); // Отнимаем отмычки при проёбе
	    	if(mkey > 0)
	    	{
				format(store,sizeof(store),RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~-1~n~~r~Отмычки: ~w~%d"), mkey-1);
				GameTextForPlayer(playerid,store,8000,3);
			}
		}
	}
	return 1;
}
stock ClickBreaking(playerid) // Кликаем на ключик
{
    if(BreakingMinYPos[BreakingScale[playerid]][playerid] <= floatabs(BreakingScaleStat[playerid])
	&& BreakingMaxYPos[BreakingScale[playerid]][playerid] >= floatabs(BreakingScaleStat[playerid])) // Попал в зеленую зону клика (Green)
	{
	    // Отображаем галочку
		PlayerTextDrawShow(playerid, BreakingScalePlayerDraw[GetScaleDrawId(playerid)+3][playerid]);
		
	    if(BreakingScale[playerid] < BreakingMaxScales[playerid]-1){
	        PlayerPlaySound(playerid,17803,0,0,0);
        	SelectBreakingScale(playerid, BreakingScale[playerid]+1); // Начинаем взламывать следующую шкалу
    	}
    	else // Удачный Взлом
    	{
    	    StopBreaking(playerid);
    	    PlayerPlaySound(playerid,1137,0,0,0);
    	    if(BreakingType[playerid] == 0)
			{
				DomInfo[BreakingTypeID[playerid]][dBreaking] = 0;
				DomInfo[BreakingTypeID[playerid]][dLock] = 0;
			}
			else if(BreakingType[playerid] == 1)
			{
				VehInfo[BreakingTypeID[playerid]][vBreaking] = 0;
				LockCar(BreakingTypeID[playerid], 0);
			}
			else if(BreakingType[playerid] == 2)
			{
				VehInfo[BreakingTypeID[playerid]][vBreaking] = 0;
				GetVehicleParamsEx(BreakingTypeID[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(BreakingTypeID[playerid], true, lights, alarm, doors, bonnet, boot, objective);
				SetPlayerChatBubble(playerid,"запускает двигатель",COLOR_PURPLE,25.0,5000);
				VehInfo[BreakingTypeID[playerid]][vEngine] = 1, CheckBenz(playerid);
				new tmphour,tmpminute,tmpsecond;
				gettime(tmphour, tmpminute, tmpsecond);
				if(tmphour >= 20 || tmphour >= 0 && tmphour <= 6)
				{
					GetVehicleParamsEx(BreakingTypeID[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
					SetVehicleParamsEx(BreakingTypeID[playerid], engine, true, alarm, doors, bonnet, boot, objective);
					VehInfo[BreakingTypeID[playerid]][vLights] = 1;
				}
				UpdateVehEngine(playerid);
			}
			GameTextForPlayer(playerid,RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Взломано"),5000,3);
    	}
	}
	else // Не попал в зелёную зону клика (Red)
	{
	    new mkey = get_and_take_invent(playerid, 19, 1);
	    if(mkey <= 0) return StopBreaking(playerid), ErrorMessage(playerid, "{FF6347}У вас кончились отмычки");
	    format(store,sizeof(store),RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~-1~n~~r~Отмычки: ~w~%d"), mkey-1);
		GameTextForPlayer(playerid,store,8000,3);
		PlayerPlaySound(playerid,43000,0,0,0);
	}
	return 1;
}
stock SelectBreakingScale(playerid, scaleId) // Выбираем шкалу, которую будем двигать
{
    BreakingScale[playerid] = scaleId;
    BreakingScaleStat[playerid] = -1.0;
    UpdateTextDrawBreakingScale(playerid);
	return 1;
}
stock GetScaleDrawId(playerid)
{
	new scaleId;
    if(BreakingScale[playerid] == 0) scaleId = 0;
	else if(BreakingScale[playerid] == 1) scaleId = 4;
	else if(BreakingScale[playerid] == 2) scaleId = 8;
	else if(BreakingScale[playerid] == 3) scaleId = 12;
	else if(BreakingScale[playerid] == 4) scaleId = 16;
	else if(BreakingScale[playerid] == 5) scaleId = 20;
	return scaleId;
}
stock UpdateTextDrawBreakingScale(playerid) // Обновляем отображение выбранной шкалы
{
	new scaleId = GetScaleDrawId(playerid);
    PlayerTextDrawTextSize(playerid, BreakingScalePlayerDraw[scaleId+2][playerid], 4.0, BreakingScaleStat[playerid]);
    PlayerTextDrawShow(playerid, BreakingScalePlayerDraw[scaleId+2][playerid]);
	return 1;
}
stock StopBreaking(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
		ClearAnimations(playerid);
    	ClearAnim(playerid);
	}
	if(BreakingType[playerid] == 0) DomInfo[BreakingTypeID[playerid]][dBreaking] = 0;
	else if(BreakingType[playerid] == 1) VehInfo[BreakingTypeID[playerid]][vBreaking] = 0;
	else if(BreakingType[playerid] == 2) VehInfo[BreakingTypeID[playerid]][vBreaking] = 0;
    ShowDialog(playerid,-1,DIALOG_STYLE_MSGBOX," "," ","•","");
    GameTextForPlayer(playerid," ",8000,3);
    if(BreakingTimer[playerid]) KillTimer(BreakingTimer[playerid]);
	if(breakingDraw[playerid]) DestroyBreakingDraw(playerid), CancelSelectTextDraw(playerid);
	return 1;
}
stock DestroyBreakingDraw(playerid)
{
    for(new i = 0; i < 14; i++) PlayerTextDrawHide(playerid, BreakingPlayerDraw[i][playerid]), PlayerTextDrawDestroy(playerid, BreakingPlayerDraw[i][playerid]);
	for(new i = 0; i < 24; i++) PlayerTextDrawHide(playerid, BreakingScalePlayerDraw[i][playerid]), PlayerTextDrawDestroy(playerid, BreakingScalePlayerDraw[i][playerid]);
	breakingDraw[playerid] = false;
	return 1;
}
stock CreateBreakingDraw(playerid, quan_breaking) // Создание текстдравов взлома (оформление, рамки и ключик)
{
    BreakingPlayerDraw[0][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x, breakingdraw_y, "LD_SPAC:white"); // Фон Взлома
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[0][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[0][playerid], 133.473937, 95.000000);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[0][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[0][playerid], 589505535);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[0][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[0][playerid], 4);

	BreakingPlayerDraw[1][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x-7.699997, breakingdraw_y-8.0, "LD_BEAT:chit"); // Рамка (Верхний левый кружок)
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[1][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[1][playerid], 10.872862, 13.533335);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[1][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[1][playerid], 252645375);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[1][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[1][playerid], 4);

	BreakingPlayerDraw[2][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x-2.0, breakingdraw_y-5.800004, "LD_SPAC:white"); // Рамка (Верхняя полоска)
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[2][playerid], 0.005998, 0.046666);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[2][playerid], 133.473907, 7.0);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[2][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[2][playerid], 252645375);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[2][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[2][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[2][playerid], 4);

	BreakingPlayerDraw[3][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x+126.0, breakingdraw_y-8.0, "LD_BEAT:chit"); // Рамка (Верхний правый кружок)
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[3][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[3][playerid], 10.872862, 13.533336);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[3][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[3][playerid], 252645375);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[3][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[3][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[3][playerid], 4);

	BreakingPlayerDraw[4][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x-2.0, breakingdraw_y+93.299987, "LD_SPAC:white"); // Рамка (Нижняя полоска)
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[4][playerid], 0.005998, 0.046666);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[4][playerid], 133.473907, 7.0);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[4][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[4][playerid], 252645375);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[4][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[4][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[4][playerid], 4);

	BreakingPlayerDraw[5][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x+126.0, breakingdraw_y+89.0, "LD_BEAT:chit"); // Рамка (Нижний левый кружок)
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[5][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[5][playerid], 10.872862, 13.533336);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[5][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[5][playerid], 252645375);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[5][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[5][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[5][playerid], 4);

	BreakingPlayerDraw[6][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x-6.0, breakingdraw_y-1.0, "LD_SPAC:white"); // Рамка (Левая полоска)
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[6][playerid], 0.005998, 0.046666);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[6][playerid], 6.000000, 96.600006);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[6][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[6][playerid], 252645375);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[6][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[6][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[6][playerid], 4);

	BreakingPlayerDraw[7][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x-7.699997, breakingdraw_y+89.0, "LD_BEAT:chit"); // Рамка (Нижний правый кружок)
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[7][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[7][playerid], 10.872862, 13.533335);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[7][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[7][playerid], 252645375);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[7][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[7][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[7][playerid], 4);

	BreakingPlayerDraw[8][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x+129.100006, breakingdraw_y-1.0, "LD_SPAC:white"); // Рамка (Правая полоска)
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[8][playerid], 0.005998, 0.046666);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[8][playerid], 6.000000, 96.600006);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[8][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[8][playerid], 252645375);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[8][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[8][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[8][playerid], 4);

	BreakingPlayerDraw[9][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x+135.0, breakingdraw_y+24.0, "LD_SPAC:white"); // Фон кнопки ключа
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[9][playerid], 0.005998, 0.046666);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[9][playerid], 39.367290, 46.200000);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[9][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[9][playerid], 252645375);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[9][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[9][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[9][playerid], 4);

	BreakingPlayerDraw[10][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x+115.0, breakingdraw_y, "key"); // Кнопка ключа
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[10][playerid], 0.013497, 0.256666);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[10][playerid], 75.735168, 89.600021);
	PlayerTextDrawBackgroundColor(playerid, BreakingPlayerDraw[10][playerid], 0);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[10][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[10][playerid], -1);
	PlayerTextDrawUseBox(playerid, BreakingPlayerDraw[10][playerid], true);
	PlayerTextDrawBoxColor(playerid, BreakingPlayerDraw[10][playerid], 0);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[10][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[10][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[10][playerid], 5);
	PlayerTextDrawSetSelectable(playerid, BreakingPlayerDraw[10][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, BreakingPlayerDraw[10][playerid], 11746);
	PlayerTextDrawSetPreviewRot(playerid, BreakingPlayerDraw[10][playerid], 0.000000, 180.000000, 180.000000, 1.000000);

	BreakingPlayerDraw[11][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x+168.899993, breakingdraw_y+21.699996, "LD_BEAT:chit"); // Рамка кнопки (Верхний кружок)
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[11][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[11][playerid], 10.872863, 13.533336);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[11][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[11][playerid], 252645375);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[11][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[11][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[11][playerid], 4);

	BreakingPlayerDraw[12][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x+168.899993, breakingdraw_y+58.899993, "LD_BEAT:chit"); // Рамка кнопки (Нижний кружок)
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[12][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[12][playerid], 10.872863, 13.533336);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[12][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[12][playerid], 252645375);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[12][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[12][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[12][playerid], 4);

	BreakingPlayerDraw[13][playerid] = CreatePlayerTextDraw(playerid, breakingdraw_x+173.700012, breakingdraw_y+27.0, "LD_SPAC:white"); // Рамка кнопки (Полоска правая)
	PlayerTextDrawLetterSize(playerid, BreakingPlayerDraw[13][playerid], 0.005998, 0.046666);
	PlayerTextDrawTextSize(playerid, BreakingPlayerDraw[13][playerid], 4.124178, 39.666656);
	PlayerTextDrawAlignment(playerid, BreakingPlayerDraw[13][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingPlayerDraw[13][playerid], 252645375);
	PlayerTextDrawSetShadow(playerid, BreakingPlayerDraw[13][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingPlayerDraw[13][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingPlayerDraw[13][playerid], 4);

	new Float:x_size = 3.0, next_draw = 0;

	BreakingMaxScales[playerid] = quan_breaking;
	if(quan_breaking == 2)
	{
		CreateBreakingDrawBar(playerid, next_draw, (breakingdraw_x+63.6369685-x_size)-10.0, 0);
		CreateBreakingDrawBar(playerid, next_draw+4, (breakingdraw_x+63.6369685-x_size)+10.0, 1);
	}
	else if(quan_breaking == 3)
	{
		CreateBreakingDrawBar(playerid, next_draw, (breakingdraw_x+63.6369685-x_size)-20.0, 0);
		CreateBreakingDrawBar(playerid, next_draw+4, (breakingdraw_x+63.6369685-x_size), 1);
		CreateBreakingDrawBar(playerid, next_draw+8, (breakingdraw_x+63.6369685-x_size)+20.0, 2);
	}
	else if(quan_breaking == 4)
	{
		CreateBreakingDrawBar(playerid, next_draw, (breakingdraw_x+63.6369685-x_size)-30.0, 0);
		CreateBreakingDrawBar(playerid, next_draw+4, (breakingdraw_x+63.6369685-x_size)-10.0, 1);
		CreateBreakingDrawBar(playerid, next_draw+8, (breakingdraw_x+63.6369685-x_size)+10.0, 2);
		CreateBreakingDrawBar(playerid, next_draw+12, (breakingdraw_x+63.6369685-x_size)+30.0, 3);
	}
	else if(quan_breaking == 5)
	{
	    CreateBreakingDrawBar(playerid, next_draw, (breakingdraw_x+63.6369685-x_size)-40.0, 0);
		CreateBreakingDrawBar(playerid, next_draw+4, (breakingdraw_x+63.6369685-x_size)-20.0, 1);
		CreateBreakingDrawBar(playerid, next_draw+8, (breakingdraw_x+63.6369685-x_size), 2);
		CreateBreakingDrawBar(playerid, next_draw+12, (breakingdraw_x+63.6369685-x_size)+20.0, 3);
		CreateBreakingDrawBar(playerid, next_draw+16, (breakingdraw_x+63.6369685-x_size)+40.0, 4);
	}
	else if(quan_breaking == 6)
	{
		CreateBreakingDrawBar(playerid, next_draw, (breakingdraw_x+63.6369685-x_size)-50.0, 0);
		CreateBreakingDrawBar(playerid, next_draw+4, (breakingdraw_x+63.6369685-x_size)-30.0, 1);
		CreateBreakingDrawBar(playerid, next_draw+8, (breakingdraw_x+63.6369685-x_size)-10.0, 2);
		CreateBreakingDrawBar(playerid, next_draw+12, (breakingdraw_x+63.6369685-x_size)+10.0, 3);
		CreateBreakingDrawBar(playerid, next_draw+16, (breakingdraw_x+63.6369685-x_size)+30.0, 4);
		CreateBreakingDrawBar(playerid, next_draw+20, (breakingdraw_x+63.6369685-x_size)+50.0, 5);
	}
	breakingDraw[playerid] = true;
	return 1;
}
stock CreateBreakingDrawBar(playerid, barid, Float:x_pos, scaleID) // Создание бара для взлома
{
	BreakingScalePlayerDraw[barid][playerid] = CreatePlayerTextDraw(playerid, x_pos, breakingdraw_y+55.5, "LD_SPAC:white"); // Бар полоски
	PlayerTextDrawLetterSize(playerid, BreakingScalePlayerDraw[barid][playerid], 0.100000, 0.100000);
	PlayerTextDrawTextSize(playerid, BreakingScalePlayerDraw[barid][playerid], 6.0, -33.0);
	PlayerTextDrawAlignment(playerid, BreakingScalePlayerDraw[barid][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingScalePlayerDraw[barid][playerid], -2139062017);
	PlayerTextDrawSetShadow(playerid, BreakingScalePlayerDraw[barid][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingScalePlayerDraw[barid][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingScalePlayerDraw[barid][playerid], 4);

	new Float:pos_Y_scale = breakingdraw_y+54.5; // Относительная координата шкалы заполнения
	new Float:pos_Y_green = breakingdraw_y+27.5+random(20); // Относительная координата зелёной полосы
    BreakingMinYPos[scaleID][playerid] = pos_Y_scale-pos_Y_green; // Находим нижнюю границу
    BreakingMaxYPos[scaleID][playerid] = BreakingMinYPos[scaleID][playerid]+floatabs(BreakingThickness[playerid]); // Находим верхнюю границу
    
	BreakingScalePlayerDraw[barid+1][playerid] = CreatePlayerTextDraw(playerid, x_pos-1.0, pos_Y_green, "LD_SPAC:white"); // Зелёная позиция взаимодействия
	PlayerTextDrawLetterSize(playerid, BreakingScalePlayerDraw[barid+1][playerid], 0.100000, 0.100000);
	PlayerTextDrawTextSize(playerid, BreakingScalePlayerDraw[barid+1][playerid], 8.0, BreakingThickness[playerid]); // Дефолт -4.0
	PlayerTextDrawAlignment(playerid, BreakingScalePlayerDraw[barid+1][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingScalePlayerDraw[barid+1][playerid], 1137072127);
	PlayerTextDrawSetShadow(playerid, BreakingScalePlayerDraw[barid+1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingScalePlayerDraw[barid+1][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingScalePlayerDraw[barid+1][playerid], 4);

	BreakingScalePlayerDraw[barid+2][playerid] = CreatePlayerTextDraw(playerid, x_pos+1.0, pos_Y_scale, "LD_SPAC:white"); // Бар заполняющей полоски
	PlayerTextDrawLetterSize(playerid, BreakingScalePlayerDraw[barid+2][playerid], 0.100000, 0.100000);
	PlayerTextDrawTextSize(playerid, BreakingScalePlayerDraw[barid+2][playerid], 4.0, -1.0); // -31.0 Максимальное значение
	PlayerTextDrawAlignment(playerid, BreakingScalePlayerDraw[barid+2][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingScalePlayerDraw[barid+2][playerid], -463714049);
	PlayerTextDrawSetShadow(playerid, BreakingScalePlayerDraw[barid+2][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingScalePlayerDraw[barid+2][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingScalePlayerDraw[barid+2][playerid], 4);

	BreakingScalePlayerDraw[barid+3][playerid] = CreatePlayerTextDraw(playerid, x_pos-0.5, breakingdraw_y+60.133361, "ld_chat:thumbup"); // Удачно выполненная полоска
	PlayerTextDrawLetterSize(playerid, BreakingScalePlayerDraw[barid+3][playerid], 0.017246, 0.139999);
	PlayerTextDrawTextSize(playerid, BreakingScalePlayerDraw[barid+3][playerid], 7.873464, 9.333343);
	PlayerTextDrawAlignment(playerid, BreakingScalePlayerDraw[barid+3][playerid], 1);
	PlayerTextDrawColor(playerid, BreakingScalePlayerDraw[barid+3][playerid], -1);
	PlayerTextDrawSetShadow(playerid, BreakingScalePlayerDraw[barid+3][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BreakingScalePlayerDraw[barid+3][playerid], 0);
	PlayerTextDrawFont(playerid, BreakingScalePlayerDraw[barid+3][playerid], 4);
	return 1;
}


#define MAX_DRAW_CRAFTPROCESS 12

new PlayerText:CraftProcessDraw[MAX_DRAW_CRAFTPROCESS][MAX_REALPLAYERS]; // Переменные для хранения текстдравов (Создаваемые)
new CraftProcessTimer[MAX_REALPLAYERS];
new ProcessQuan[MAX_REALPLAYERS];
new Float:ProcessOne[MAX_REALPLAYERS];
new SizeGreen[MAX_REALPLAYERS];
new PosGreen[MAX_REALPLAYERS][3];
new bool:DoneGreen[MAX_REALPLAYERS][3];
new CraftInvent[MAX_REALPLAYERS]; // Слот предмета в инвентаре
new ThingNeed[MAX_REALPLAYERS]; // Какой id предмета требуется

stock ClickTextDraw_RepairVehicle(playerid, PlayerText:playertextid)
{
    if(playertextid == CraftProcessDraw[1][playerid]) // Кнопка двигателя
    {
        new vehicleid = OnlineInfo[playerid][oShowTabs];
        new model = VehInfo[vehicleid][vModel];

        if(CraftProcessTimer[playerid] > 0) return ErrorMessage(playerid, "{ffcc66}Нажимайте на кнопку с гаечным ключём в тот момент,\nкогда полоса загрузки находится на зелёной зоне"), i_resetveshi(playerid);

        if(OnlineInfo[playerid][oInventSelectLeft] == 9999) DiagnosVehicle(playerid, vehicleid, 0);
        else
        {
            new Float:health;
 			GetVehicleHealth(vehicleid, health);
            if(health > 500.0) return ErrorMessage(playerid, "{FF6347}Двигатель не повреждён и не нуждается в ремонте"), i_resetveshi(playerid);

            new inva = OnlineInfo[playerid][oInventSelectLeft];
            new thingId = PlayerInfo[playerid][pInven][inva];

            if(IsAMoto(model)) ThingNeed[playerid] = 190;
            else if(IsAPlane(model)) ThingNeed[playerid] = 191;
            else if(IsABoat(model)) ThingNeed[playerid] = 192;
            else ThingNeed[playerid] = 183;

            if(thingId != ThingNeed[playerid]) return format(store,sizeof(store),"{FF6347}Для ремонта этого транспорта требуется {cccccc}%s", friskName[ThingNeed[playerid]]), ErrorMessage(playerid, store), i_resetveshi(playerid);

            ClearCraftProcess(playerid);

            CraftInvent[playerid] = inva;
            PPP15[playerid] = 6;
            CraftProcessTimer[playerid] = SetTimerEx("CraftProcess", 200, true, "d", playerid);

            around_player_audio(playerid, 32000, 0, 5.0, 0);
            i_resetveshi(playerid);
        }
        return 1;
    }
    if(playertextid == CraftProcessDraw[4][playerid]) // Кнопка ремонта
    {
        if(CraftProcessTimer[playerid] == 0)
        {
            format(lines,sizeof(lines),""); // Очищаем Lines

            format(line,sizeof(line),"\n{444444}Выберите {ff9000}Рем. комплект {444444}в инвентаре"), strcat(lines,line);
            format(line,sizeof(line),"\n{444444}Затем повторно нажмите на двигатель, чтобы начать ремонт"), strcat(lines,line);

            format(line,sizeof(line),"\n\n{ffcc66}Нажимайте на кнопку с гаечным ключём в тот момент,\nкогда полоса загрузки находится на зелёной зоне"), strcat(lines,line);
            ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Ремонт двигателя",lines,"*","");
            i_resetveshi(playerid);
            return 1;
        }

        ClickCraftProcess(playerid);
        return 1;
    }
    return 1;
}

stock ClearCraftProcess(playerid)
{
    ProcessQuan[playerid] = 0;
    DoneGreen[playerid][0] = false;
    DoneGreen[playerid][1] = false;
    DoneGreen[playerid][2] = false;

    if(CraftProcessTimer[playerid] > 0) 
    {
        PPP15[playerid] = 0;
        KillTimer(CraftProcessTimer[playerid]);
        CraftProcessTimer[playerid] = 0;
        ClearAnimations(playerid);
        ClearAnim(playerid);
    }
    return 1;
}

stock ClickCraftProcess(playerid)
{
    new Float:done_process = ProcessOne[playerid] * ProcessQuan[playerid];
    new Float:minx[3], Float:maxx[3];
    GetDiapasonCraft(playerid, minx[0], minx[1], minx[2], maxx[0], maxx[1], maxx[2]);


    if(done_process >= minx[0] && done_process <= maxx[0] || done_process >= minx[1] && done_process <= maxx[1] || done_process >= minx[2] && done_process <= maxx[2]) 
    {
        if(DoneGreen[playerid][0] == false) DoneProcessCraft(playerid, 0);
        else if(DoneGreen[playerid][1] == false) DoneProcessCraft(playerid, 1);
        else if(DoneGreen[playerid][2] == false) DoneProcessCraft(playerid, 2);
    }
    else 
    {
        ClearCraftProcess(playerid);
        HideDrawCraftProcess(playerid);
        ErrorMessage(playerid, "{FF6347}Вы не попали в зелёную зону и провалили процесс");
    }
    return 1;
}

stock CheckCraftThing(playerid)
{
    new inva = CraftInvent[playerid];
    new thingId = PlayerInfo[playerid][pInven][inva];
    if(thingId != ThingNeed[playerid])
    {
        ClearCraftProcess(playerid);
        HideDrawCraftProcess(playerid);
        ErrorMessage(playerid, "{FF6347}Вы переложили предмет в инвентаре, который нужен для процесса");
        return 0;
    }
    return 1;
}

stock DoneProcessCraft(playerid, doneId)
{
    if(!CheckCraftThing(playerid)) return 1;

    if(DoneGreen[playerid][doneId] == false)
    {
        DoneGreen[playerid][doneId] = true;
        new drawId;
        if(doneId == 0) drawId = 9;
        else if(doneId == 1) drawId = 10;
        else if(doneId == 2) drawId = 11;
        PlayerTextDrawSetString(playerid, CraftProcessDraw[drawId][playerid], "ld_chat:thumbup");
        PlayerTextDrawShow(playerid, CraftProcessDraw[drawId][playerid]);
        if(doneId <= 1)
        {
            PlayerTextDrawSetString(playerid, CraftProcessDraw[drawId + 1][playerid], "ld_beat:down");
            PlayerTextDrawShow(playerid, CraftProcessDraw[drawId + 1][playerid]);
        }
    }
    if(Tabs_Load[playerid] == 10) around_player_audio(playerid, 32000, 0, 5.0, 0);
    else PlayerPlaySound(playerid,1150,0,0,0);
    return 1;
}

stock HideDrawCraftProcess(playerid)
{
    PlayerTextDrawHide(playerid, CraftProcessDraw[5][playerid]); // Green line 1
    PlayerTextDrawHide(playerid, CraftProcessDraw[6][playerid]); // Green line 2
    PlayerTextDrawHide(playerid, CraftProcessDraw[7][playerid]); // Green line 3
    PlayerTextDrawHide(playerid, CraftProcessDraw[8][playerid]); // bar load
    PlayerTextDrawHide(playerid, CraftProcessDraw[9][playerid]); // done 1
    PlayerTextDrawHide(playerid, CraftProcessDraw[10][playerid]); // done 2
    PlayerTextDrawHide(playerid, CraftProcessDraw[11][playerid]); // done 3
    return 1;
}

stock GetDiapasonCraft(playerid, &Float:minx0, &Float:minx1, &Float:minx2, &Float:maxx0, &Float:maxx1, &Float:maxx2)
{
    minx0 = PosGreen[playerid][0] * ProcessOne[playerid] - 2;
    minx1 = PosGreen[playerid][1] * ProcessOne[playerid] - 2;
    minx2 = PosGreen[playerid][2] * ProcessOne[playerid] - 2;

    maxx0 = (PosGreen[playerid][0] + SizeGreen[playerid]) * ProcessOne[playerid] - 2;
    maxx1 = (PosGreen[playerid][1] + SizeGreen[playerid]) * ProcessOne[playerid] - 2;
    maxx2 = (PosGreen[playerid][2] + SizeGreen[playerid]) * ProcessOne[playerid] - 2;
    return 1;
}

function CraftProcess(playerid)
{
    new Float:size_bar[2], ability = get_ability(playerid, 8);
    PlayerTextDrawGetTextSize(playerid, CraftProcessDraw[8][playerid], size_bar[0], size_bar[1]);

    if(ProcessQuan[playerid] == 0) // Первый запуск
    {
        new Float:size_fon_bar[2];
        PlayerTextDrawGetTextSize(playerid, CraftProcessDraw[2][playerid], size_fon_bar[0], size_fon_bar[1]);
        size_bar[0] = size_fon_bar[0] - 4;
        size_bar[1] = size_fon_bar[1] - 4;
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[8][playerid], size_bar[0], size_bar[1]);
        
        ProcessOne[playerid] = size_bar[0] / 200; // Получаем 1 процент заполнения бара

        // Размер зелёных полосок
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[5][playerid], (10 + ability) * ProcessOne[playerid], size_bar[1] + 6);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[6][playerid], (10 + ability) * ProcessOne[playerid], size_bar[1] + 6);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[7][playerid], (10 + ability) * ProcessOne[playerid], size_bar[1] + 6);
        SizeGreen[playerid] = 10 + ability;
        new Float:size_green = SizeGreen[playerid] * ProcessOne[playerid];

        // Положение зелёных полосок
        new Float:pos_bar[2];
        PlayerTextDrawGetPos(playerid, CraftProcessDraw[2][playerid], pos_bar[0], pos_bar[1]);
        new Float:pos_green[3];
        PosGreen[playerid][0] = 20 + random(30);
        PosGreen[playerid][1] = 80 + random(30);
        PosGreen[playerid][2] = 150 + random(30);
        pos_green[0] = pos_bar[0] + PosGreen[playerid][0] * ProcessOne[playerid];
        pos_green[1] = pos_bar[0] + PosGreen[playerid][1] * ProcessOne[playerid];
        pos_green[2] = pos_bar[0] + PosGreen[playerid][2] * ProcessOne[playerid];

        PlayerTextDrawSetPos(playerid, CraftProcessDraw[5][playerid], pos_green[0], pos_bar[1] - 1);
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[6][playerid], pos_green[1], pos_bar[1] - 1);
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[7][playerid], pos_green[2], pos_bar[1] - 1);
        // Размер галочек
        new Float:fix_y, Float:size_done_x = 20 * ProcessOne[playerid];
        FixTextDrawSquare_X(size_done_x, fix_y);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[9][playerid], size_done_x, fix_y);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[10][playerid], size_done_x, fix_y);
        PlayerTextDrawTextSize(playerid, CraftProcessDraw[11][playerid], size_done_x, fix_y);

        // Положение галочек
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[9][playerid], (pos_green[0] + (size_green / 2)) - (size_done_x / 2), pos_bar[1] - fix_y * 1.5);
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[10][playerid], (pos_green[1] + (size_green / 2)) - (size_done_x / 2), pos_bar[1] - fix_y * 1.5);
        PlayerTextDrawSetPos(playerid, CraftProcessDraw[11][playerid], (pos_green[2] + (size_green / 2)) - (size_done_x / 2), pos_bar[1] - fix_y * 1.5);

        // Показываем зелёные полоски
        PlayerTextDrawShow(playerid, CraftProcessDraw[5][playerid]);
        PlayerTextDrawShow(playerid, CraftProcessDraw[6][playerid]);
        PlayerTextDrawShow(playerid, CraftProcessDraw[7][playerid]);

        // Показываем первую галочку
        PlayerTextDrawShow(playerid, CraftProcessDraw[9][playerid]);
    }

    if(ability <= 2) ProcessQuan[playerid] ++;
    else if(ability >= 3 && ability <= 6) ProcessQuan[playerid] += 2;
    else if(ability >= 7 && ability <= 9) ProcessQuan[playerid] += 3;
    else ProcessQuan[playerid] += 4;

    new Float:done_process = ProcessOne[playerid] * ProcessQuan[playerid];
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[8][playerid], done_process, size_bar[1]);
    PlayerTextDrawShow(playerid, CraftProcessDraw[8][playerid]);

    // Проверка действий процесса
    new Float:minx[3], Float:maxx[3];
    GetDiapasonCraft(playerid, minx[0], minx[1], minx[2], maxx[0], maxx[1], maxx[2]);

    if(done_process > maxx[0] && DoneGreen[playerid][0] == false
    || done_process > maxx[1] && DoneGreen[playerid][1] == false
    || done_process > maxx[2] && DoneGreen[playerid][2] == false)
    {
        ClearCraftProcess(playerid);
        HideDrawCraftProcess(playerid);
        ErrorMessage(playerid, "{FF6347}Вы пропустили зелёную зону и провалили процесс");
        return 1;
    }

    if(ProcessQuan[playerid] >= 200) 
    {
        if(!CheckCraftThing(playerid)) return 1;

        i_del(playerid, CraftInvent[playerid]); // Забираем предмет
        ClearCraftProcess(playerid);
        HideDrawCraftProcess(playerid);
        SuccessMessage(playerid, "{99ff66}Выполнено!");

        if(Tabs_Load[playerid] == 10)
        {
            if(ability >= 9) ACSetVehicleHealth(OnlineInfo[playerid][oShowTabs], 1000.0);
            else ACSetVehicleHealth(OnlineInfo[playerid][oShowTabs], 800.0);
            update_ability(playerid, 8, 15);
        }

    }
    return 1;
}

stock bonet_close(playerid)
{
    if(OnlineInfo[playerid][oShowTabs] != 9999)
    {
		new kolka = 0;
		foreach(Player, i)
		{
			if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[playerid][oShowTabs] == OnlineInfo[i][oShowTabs] && Tabs_Load[i] == 10) kolka ++;
		}
	    if(kolka <= 1)
	    {
    		if(IsABootFront(OnlineInfo[playerid][oShowTabs])) // Морда
    		{
    			GetVehicleParamsEx(OnlineInfo[playerid][oShowTabs], engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(OnlineInfo[playerid][oShowTabs], engine, lights, alarm, doors, bonnet, false, objective);
    		}
    		else // Жопа
    		{
				GetVehicleParamsEx(OnlineInfo[playerid][oShowTabs], engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(OnlineInfo[playerid][oShowTabs], engine, lights, alarm, doors, false, boot, objective);
			}
			VehInfo[OnlineInfo[playerid][oShowTabs]][vBonnet] = 0;
            if(VehInfo[OnlineInfo[playerid][oShowTabs]][vNospawn] != 2) VehInfo[OnlineInfo[playerid][oShowTabs]][vNospawn] = 0;
		}
        OnlineInfo[playerid][oShowTabs] = 9999;
	}
	PlayerTextDrawHide(playerid, PlaNestAct[0][playerid]);
	PlayerTextDrawHide(playerid, PlaNestAct[1][playerid]);

    destroyDraw_RepairVehicle(playerid); // Удаляем текстдравы ремонта
   	return 1;
}

stock showDraw_RepairVehicle(playerid)
{
    createDraw_RepairVehicle(playerid);
    PlayerTextDrawShow(playerid, CraftProcessDraw[0][playerid]);
    PlayerTextDrawShow(playerid, CraftProcessDraw[1][playerid]);
    PlayerTextDrawShow(playerid, CraftProcessDraw[2][playerid]);
    PlayerTextDrawShow(playerid, CraftProcessDraw[3][playerid]);
    PlayerTextDrawShow(playerid, CraftProcessDraw[4][playerid]);
    return 1;
}

stock destroyDraw_RepairVehicle(playerid)
{
    ClearCraftProcess(playerid);

    if(OnlineInfo[playerid][oRepairVehDraw] == false) return 0;

    for(new i = 0; i < MAX_DRAW_CRAFTPROCESS; i++)
    {
        PlayerTextDrawHide(playerid, CraftProcessDraw[i][playerid]);
        PlayerTextDrawDestroy(playerid, CraftProcessDraw[i][playerid]);
    }
    OnlineInfo[playerid][oRepairVehDraw] = false;
    return 1;
}

stock DiagnosVehicle(playerid, vehicleid, stat)
{
    new Float:health;
    GetVehicleHealth(vehicleid, health);
    PlayerPlaySound(playerid,40405,0,0,0);
    
    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"{ff9000}%s",vehName[VehInfo[vehicleid][vModel]]), strcat(lines,line);
    format(line,sizeof(line),"\n{ff9000}Состояние: {cccccc}%.0f Health\n", health), strcat(lines,line);

    for(new i = 0; i < 13; i++)
    {
        if(GetVehicleComponentInSlot(vehicleid, i) != 0)
        {
            format(line,sizeof(line),"\n{ff9000}* {cccccc}%s",detalName[GetVehicleComponentInSlot(vehicleid,i)]), strcat(lines,line);
        }
    }

    if(stat == 0)
    {
        format(line,sizeof(line),"\n\n{444444}Выберите {ff9000}Рем. комплект {444444}в инвентаре"), strcat(lines,line);
        format(line,sizeof(line),"\n{444444}Затем повторно нажмите на двигатель, чтобы начать ремонт"), strcat(lines,line);
    }
    ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Диагностика",lines,"*","");
}

stock posDraw_RepairVehicle(playerid)
{
    if(OnlineInfo[playerid][oRepairVehDraw] == false || DrawInvent[playerid] == false) return 0;

    // Получаем расположение инвентаря
    new Float:back_pos[2], Float:back_size[2];
    PlayerTextDrawGetPos(playerid, PlaInventDraw[5][playerid], back_pos[0], back_pos[1]);
    PlayerTextDrawGetTextSize(playerid, PlaInventDraw[5][playerid], back_size[0], back_size[1]);

    // Собираем расположение основы инвентаря
    new Float:min_pos[2], Float:max_pos[2];
    min_pos[0] = back_pos[0]; // Min Up
    min_pos[1] = back_pos[1]; // Min Left
    max_pos[0] = back_pos[0] + back_size[0]; // Max Down
    max_pos[1] = back_pos[1] + back_size[1]; // Max Right

    new Float:one[2];
    one[0] = (max_pos[0] - min_pos[0]) / 100; // 1 proc X
    one[1] = (max_pos[1] - min_pos[1]) / 100; // 1 proc Y

    new Float:centr[2];
    centr[0] = back_pos[0] + back_size[0] / 2; // centr X
    centr[1] = back_pos[1] + back_size[1] / 2; // centr Y


    // Фон двигателя
    new Float:draw0[2];
    draw0[1] = 60.0;
    FixTextDrawSquare_Y(draw0[1] * one[1], draw0[0]);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[0][playerid], draw0[0], draw0[1] * one[1]);
    PlayerTextDrawSetPos(playerid, CraftProcessDraw[0][playerid], centr[0] - draw0[0] / 2, back_pos[1] + one[1] * 14);

    // Двигатель
    new Float:draw1[2];
    draw1[1] = 30.0;
    new Float:circle_pos[2]; // Получаем центр кружочка
    PlayerTextDrawGetPos(playerid, CraftProcessDraw[0][playerid], circle_pos[0], circle_pos[1]);
    FixTextDrawSquare_Y(draw1[1] * one[1], draw1[0]);

    PlayerTextDrawTextSize(playerid, CraftProcessDraw[1][playerid], draw1[0], draw1[1] * one[1]);
    PlayerTextDrawSetPos(playerid, CraftProcessDraw[1][playerid], centr[0] - draw1[0] / 2, back_pos[1] + one[1] * 25);

    // Размеры бара загрузки, фона кнопки ремонта и кнопки ремонта
    new Float:size_bar_x = 35 * one[1], Float:size_bar_y = 8 * one[1];
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[2][playerid], size_bar_x, size_bar_y);
    new Float:fix_y, Float:size_fonbutton_x = 16 * one[1];
    FixTextDrawSquare_X(size_fonbutton_x, fix_y);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[3][playerid], size_fonbutton_x, fix_y);
    new Float:fix_y2, Float:size_button_x = 12 * one[1];
    FixTextDrawSquare_X(size_button_x, fix_y2);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[4][playerid], size_button_x, fix_y2);

    // Положение бара загрузки, фона кнопки ремонта и кнопки ремонта
    new Float:temp_x = centr[0] - ((size_bar_x) / 2) - ((size_fonbutton_x) / 2), Float:temp_y = back_pos[1] + one[1] * 77;
    PlayerTextDrawSetPos(playerid, CraftProcessDraw[2][playerid], temp_x, temp_y);
    new Float:centr_bar = temp_y + (size_bar_y) / 2;
    PlayerTextDrawSetPos(playerid, CraftProcessDraw[3][playerid], temp_x + size_bar_x + size_fonbutton_x/6, centr_bar - fix_y/2);
    new Float:fonbar_pos[2];
    PlayerTextDrawGetPos(playerid, CraftProcessDraw[3][playerid], fonbar_pos[0], fonbar_pos[1]); // Получаем координаты фона кнопки
    PlayerTextDrawSetPos(playerid, CraftProcessDraw[4][playerid], fonbar_pos[0] + size_fonbutton_x/2 - size_button_x/2, centr_bar - fix_y2/2);

    // Положение бара загрузки
    new Float:fon_bar[2];
    PlayerTextDrawGetPos(playerid, CraftProcessDraw[2][playerid], fon_bar[0], fon_bar[1]);
    PlayerTextDrawSetPos(playerid, CraftProcessDraw[8][playerid], fon_bar[0] + 2, fon_bar[1] + 2);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[8][playerid], size_bar_x - 4, size_bar_y - 4);
    return 1;
}

stock FixTextDrawSquare_X(Float:x, &Float:fix_y)
{
    new Float:one = x / 100;
    fix_y = x + one * 15;
}
stock FixTextDrawSquare_Y(Float:y, &Float:fix_x)
{
    new Float:one = y / 100;
    fix_x = y - one * 15;
}

stock createDraw_RepairVehicle(playerid)
{
    if(OnlineInfo[playerid][oRepairVehDraw] == true) return 0; // Если эти текстдравы уже созданы, возвращаем 0

    CraftProcessDraw[0][playerid] = CreatePlayerTextDraw(playerid, 87.333267, 141.037063, "ld_beat:chit"); // Фон двигателя
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[0][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[0][playerid], 130.000015, 154.725921);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[0][playerid], 1);
    PlayerTextDrawColor(playerid, CraftProcessDraw[0][playerid], 168430200);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[0][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[0][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[0][playerid], 4);

    CraftProcessDraw[1][playerid] = CreatePlayerTextDraw(playerid, 113.000007, 164.266784, "dvigatel"); // Двигатель + кнопка
    PlayerTextDrawBackgroundColor(playerid, CraftProcessDraw[1][playerid], 0);
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[1][playerid], 0.024666, 0.265481);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[1][playerid], 78.666694, 91.259277);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[1][playerid], 1);
    PlayerTextDrawColor(playerid, CraftProcessDraw[1][playerid], -1);
    PlayerTextDrawUseBox(playerid, CraftProcessDraw[1][playerid], true);
    PlayerTextDrawBoxColor(playerid, CraftProcessDraw[1][playerid], 0);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[1][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[1][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[1][playerid], 5);
    PlayerTextDrawSetSelectable(playerid, CraftProcessDraw[1][playerid], true);
    PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[1][playerid], 19917);
    PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[1][playerid], -40.000000, 0.000000, 0.000000, 1.000000);

    CraftProcessDraw[2][playerid] = CreatePlayerTextDraw(playerid, 104.333343, 291.200012, "bar_fon"); // Фон бара загрузки
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[2][playerid], 0.016000, 0.223999);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[2][playerid], 82.333305, 17.837022);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[2][playerid], 1);
    PlayerTextDrawColor(playerid, CraftProcessDraw[2][playerid], -1);
    PlayerTextDrawUseBox(playerid, CraftProcessDraw[2][playerid], true);
    PlayerTextDrawBoxColor(playerid, CraftProcessDraw[2][playerid], 0);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[2][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[2][playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, CraftProcessDraw[2][playerid], 168429944);
    PlayerTextDrawFont(playerid, CraftProcessDraw[2][playerid], 5);
    PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[2][playerid], 2709);
    PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[2][playerid], 0.000000, 0.000000, 0.000000, -2.000000);

    CraftProcessDraw[3][playerid] = CreatePlayerTextDraw(playerid, 188.333328, 278.755523, "ld_beat:chit"); // Фон кнопки ремонта
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[3][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[3][playerid], 36.000007, 42.725891);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[3][playerid], 1);
    PlayerTextDrawColor(playerid, CraftProcessDraw[3][playerid], 168430200);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[3][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[3][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[3][playerid], 4);
    PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[3][playerid], 3096);
    PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[3][playerid], 0.000000, 0.000000, 0.000000, 1.000000);

    CraftProcessDraw[4][playerid] = CreatePlayerTextDraw(playerid, 194.000061, 285.807403, "remont_button"); // Кнопка ремонта
    PlayerTextDrawBackgroundColor(playerid, CraftProcessDraw[4][playerid], 0);
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[4][playerid], 0.012666, 0.149333);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[4][playerid], 23.666654, 28.622215);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[4][playerid], 1);
    PlayerTextDrawColor(playerid, CraftProcessDraw[4][playerid], -1);
    PlayerTextDrawUseBox(playerid, CraftProcessDraw[4][playerid], true);
    PlayerTextDrawBoxColor(playerid, CraftProcessDraw[4][playerid], 0);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[4][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[4][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[4][playerid], 5);
    PlayerTextDrawSetSelectable(playerid, CraftProcessDraw[4][playerid], true);
    PlayerTextDrawSetPreviewModel(playerid, CraftProcessDraw[4][playerid], 3096);
    PlayerTextDrawSetPreviewRot(playerid, CraftProcessDraw[4][playerid], 0.000000, 0.000000, 0.000000, 1.000000);

    CraftProcessDraw[5][playerid] = CreatePlayerTextDraw(playerid, 118.666648, 291.614837, "LD_SPAC:white"); // Зелёная полоска 1
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[5][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[5][playerid], 3.000002, 17.422197);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[5][playerid], 1);
    PlayerTextDrawColor(playerid, CraftProcessDraw[5][playerid], 13793535);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[5][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[5][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[5][playerid], 4);

    CraftProcessDraw[6][playerid] = CreatePlayerTextDraw(playerid, 142.666595, 291.370361, "LD_SPAC:white"); // Зелёная полоска 2
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[6][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[6][playerid], 3.000002, 17.422197);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[6][playerid], 1);
    PlayerTextDrawColor(playerid, CraftProcessDraw[6][playerid], 13793535);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[6][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[6][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[6][playerid], 4);

    CraftProcessDraw[7][playerid] = CreatePlayerTextDraw(playerid, 164.666610, 291.125885, "LD_SPAC:white"); // Зелёная полоска 3
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[7][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[7][playerid], 3.000002, 17.422197);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[7][playerid], 1);
    PlayerTextDrawColor(playerid, CraftProcessDraw[7][playerid], 13793535);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[7][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[7][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[7][playerid], 4);

    CraftProcessDraw[8][playerid] = CreatePlayerTextDraw(playerid, 105.666664, 292.444458, "LD_SPAC:white"); // Бар загрузки
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[8][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[8][playerid], 53.333351, 15.348165);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[8][playerid], 1);
    PlayerTextDrawColor(playerid, CraftProcessDraw[8][playerid], PlayerInfo[playerid][pStyle1]);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[8][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[8][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[8][playerid], 4);

    CraftProcessDraw[9][playerid] = CreatePlayerTextDraw(playerid, 115.333335, 277.096405, "ld_beat:down"); // Статус первой полоски
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[9][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[9][playerid], 9.333340, 11.199990);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[9][playerid], 1);
    PlayerTextDrawColor(playerid, CraftProcessDraw[9][playerid], -1);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[9][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[9][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[9][playerid], 4);

    CraftProcessDraw[10][playerid] = CreatePlayerTextDraw(playerid, 139.333328, 277.266754, "ld_chat:thumbup"); // Статус второй полоски
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[10][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[10][playerid], 9.333340, 11.199990);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[10][playerid], 1);
    PlayerTextDrawColor(playerid, CraftProcessDraw[10][playerid], -1);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[10][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[10][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[10][playerid], 4);

    CraftProcessDraw[11][playerid] = CreatePlayerTextDraw(playerid, 161.666671, 277.437103, "ld_chat:thumbup"); // Статус третьей полоски
    PlayerTextDrawLetterSize(playerid, CraftProcessDraw[11][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, CraftProcessDraw[11][playerid], 9.333340, 11.199990);
    PlayerTextDrawAlignment(playerid, CraftProcessDraw[11][playerid], 1);
    PlayerTextDrawColor(playerid, CraftProcessDraw[11][playerid], -1);
    PlayerTextDrawSetShadow(playerid, CraftProcessDraw[11][playerid], 0);
    PlayerTextDrawSetOutline(playerid, CraftProcessDraw[11][playerid], 0);
    PlayerTextDrawFont(playerid, CraftProcessDraw[11][playerid], 4);

    OnlineInfo[playerid][oRepairVehDraw] = true;
    posDraw_RepairVehicle(playerid);
    return 1;
}
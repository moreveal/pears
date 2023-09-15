
#define MAX_DRAW_REPAIRVEHICLE 12

new PlayerText:RepairVehicleDraw[MAX_DRAW_VEHICLESHOP][MAX_REALPLAYERS]; // Переменные для хранения текстдравов (Создаваемые)
new RepairVehTimer[MAX_REALPLAYERS];
new RepairProcess[MAX_REALPLAYERS];
new Float:ProcessOne[MAX_REALPLAYERS];

stock ClickTextDraw_RepairVehicle(playerid, PlayerText:playertextid)
{
    if(playertextid == RepairVehicleDraw[1][playerid]) // Кнопка двигателя
    {
        new vehicleid = OnlineInfo[playerid][oShowTabs];
        new model = VehInfo[vehicleid][vModel];

        if(RepairVehTimer[playerid] > 0) return ErrorMessage(playerid, "{ffcc66}Нажимайте на кнопку с гаечным ключём в тот момент,\nкогда полоса загрузки находится на зелёной зоне"), i_resetveshi(playerid);

        if(OnlineInfo[playerid][oInventSelectLeft] == 9999) DiagnosVehicle(playerid, vehicleid, 0);
        else
        {
            new Float:health;
 			GetVehicleHealth(vehicleid, health);
            if(health > 500.0) return ErrorMessage(playerid, "{FF6347}Двигатель не повреждён и не нуждается в ремонте"), i_resetveshi(playerid);

            new inva = OnlineInfo[playerid][oInventSelectLeft];
            new thingId = PlayerInfo[playerid][pInven][inva];

            new needThindId;
            if(IsAMoto(model)) needThindId = 190;
            else if(IsAPlane(model)) needThindId = 191;
            else if(IsABoat(model)) needThindId = 192;
            else needThindId = 183;

            if(thingId != needThindId) return format(store,sizeof(store),"{FF6347}Для ремонта этого транспорта требуется {cccccc}%s", friskName[needThindId]), ErrorMessage(playerid, store), i_resetveshi(playerid);

            ClearVehicleRepair(playerid);

            PPP15[playerid] = 6;
            RepairVehTimer[playerid] = SetTimerEx("RepairVehicleProcess", 200, true, "d", playerid);

            around_player_audio(playerid, 32000, 0, 5.0);
            i_resetveshi(playerid);
        }
    }
    return 1;
}

stock ClearVehicleRepair(playerid)
{
    RepairProcess[playerid] = 0;
    if(RepairVehTimer[playerid] > 0) 
    {
        PPP15[playerid] = 0;
        KillTimer(RepairVehTimer[playerid]);
        RepairVehTimer[playerid] = 0;
        ClearAnimations(playerid);
        ClearAnim(playerid);
    }
    return 1;
}

function RepairVehicleProcess(playerid)
{
    new Float:size_bar[2], ability = get_ability(playerid, 8);
    PlayerTextDrawGetTextSize(playerid, RepairVehicleDraw[8][playerid], size_bar[0], size_bar[1]);
    if(RepairProcess[playerid] == 0)
    {
        ProcessOne[playerid] = size_bar[0] / 200;
    }

    if(ability <= 2) RepairProcess[playerid] ++;
    else if(ability >= 3 && ability <= 6) RepairProcess[playerid] += 2;
    else if(ability >= 7 && ability <= 9) RepairProcess[playerid] += 3;
    else RepairProcess[playerid] += 4;

    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[8][playerid], ProcessOne[playerid] * RepairProcess[playerid], size_bar[1]);
    PlayerTextDrawShow(playerid, RepairVehicleDraw[8][playerid]);

    if(RepairProcess[playerid] >= 200) 
    {
        ClearVehicleRepair(playerid);

        if(ability >= 9) ACSetVehicleHealth(OnlineInfo[playerid][oShowTabs], 1000.0);
        else ACSetVehicleHealth(OnlineInfo[playerid][oShowTabs], 800.0);
        SuccessMessage(playerid, "{99ff66}Двигатель отремонтирован");
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
            VehInfo[OnlineInfo[playerid][oShowTabs]][vNospawn] = 0;
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
    PlayerTextDrawShow(playerid, RepairVehicleDraw[0][playerid]);
    PlayerTextDrawShow(playerid, RepairVehicleDraw[1][playerid]);
    PlayerTextDrawShow(playerid, RepairVehicleDraw[2][playerid]);
    PlayerTextDrawShow(playerid, RepairVehicleDraw[3][playerid]);
    PlayerTextDrawShow(playerid, RepairVehicleDraw[4][playerid]);
    return 1;
}

stock destroyDraw_RepairVehicle(playerid)
{
    ClearVehicleRepair(playerid);

    if(OnlineInfo[playerid][oRepairVehDraw] == false) return 0;

    for(new i = 0; i < MAX_DRAW_REPAIRVEHICLE; i++)
    {
        PlayerTextDrawHide(playerid, RepairVehicleDraw[i][playerid]);
        PlayerTextDrawDestroy(playerid, RepairVehicleDraw[i][playerid]);
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
    draw0[1] = 50.0;
    FixTextDrawSquare_Y(draw0[1] * one[1], draw0[0]);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[0][playerid], draw0[0], draw0[1] * one[1]);
    PlayerTextDrawSetPos(playerid, RepairVehicleDraw[0][playerid], centr[0] - draw0[0] / 2, back_pos[1] + one[1] * 12); // 14 процентов от высоты всего квадрата

    // Двигатель
    new Float:draw1[2];
    draw1[1] = 25.0;
    new Float:circle_pos[2]; // Получаем центр кружочка
    PlayerTextDrawGetPos(playerid, RepairVehicleDraw[0][playerid], circle_pos[0], circle_pos[1]);
    FixTextDrawSquare_Y(draw1[1] * one[1], draw1[0]);

    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[1][playerid], draw1[0], draw1[1] * one[1]);
    PlayerTextDrawSetPos(playerid, RepairVehicleDraw[1][playerid], centr[0] - draw1[0] / 2, back_pos[1] + one[1] * 22);

    // Размеры бара загрузки, фона кнопки ремонта и кнопки ремонта
    new Float:size_bar_x = 30 * one[1], Float:size_bar_y = 7 * one[1];
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[2][playerid], size_bar_x, size_bar_y);
    new Float:fix_y, Float:size_fonbutton_x = 14 * one[1];
    FixTextDrawSquare_X(size_fonbutton_x, fix_y);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[3][playerid], size_fonbutton_x, fix_y);
    new Float:fix_y2, Float:size_button_x = 10 * one[1];
    FixTextDrawSquare_X(size_button_x, fix_y2);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[4][playerid], size_button_x, fix_y2);

    // Положение бара загрузки, фона кнопки ремонта и кнопки ремонта
    new Float:temp_x = centr[0] - ((size_bar_x) / 2) - ((size_fonbutton_x) / 2), Float:temp_y = back_pos[1] + one[1] * 65;
    PlayerTextDrawSetPos(playerid, RepairVehicleDraw[2][playerid], temp_x, temp_y);
    new Float:centr_bar = temp_y + (size_bar_y) / 2;
    PlayerTextDrawSetPos(playerid, RepairVehicleDraw[3][playerid], temp_x + size_bar_x + size_fonbutton_x/6, centr_bar - fix_y/2);
    new Float:fonbar_pos[2];
    PlayerTextDrawGetPos(playerid, RepairVehicleDraw[3][playerid], fonbar_pos[0], fonbar_pos[1]); // Получаем координаты фона кнопки
    PlayerTextDrawSetPos(playerid, RepairVehicleDraw[4][playerid], fonbar_pos[0] + size_fonbutton_x/2 - size_button_x/2, centr_bar - fix_y2/2);

    // Положение бара загрузки
    new Float:fon_bar[2];
    PlayerTextDrawGetPos(playerid, RepairVehicleDraw[2][playerid], fon_bar[0], fon_bar[1]);
    PlayerTextDrawSetPos(playerid, RepairVehicleDraw[8][playerid], fon_bar[0] + 2, fon_bar[1] + 2);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[8][playerid], size_bar_x - 4, size_bar_y - 4);
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

/*
24,725921

12,592583
*/

stock createDraw_RepairVehicle(playerid)
{
    if(OnlineInfo[playerid][oRepairVehDraw] == true) return 0; // Если эти текстдравы уже созданы, возвращаем 0

    RepairVehicleDraw[0][playerid] = CreatePlayerTextDraw(playerid, 87.333267, 141.037063, "ld_beat:chit"); // Фон двигателя
    PlayerTextDrawLetterSize(playerid, RepairVehicleDraw[0][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[0][playerid], 130.000015, 154.725921);
    PlayerTextDrawAlignment(playerid, RepairVehicleDraw[0][playerid], 1);
    PlayerTextDrawColor(playerid, RepairVehicleDraw[0][playerid], 168430200);
    PlayerTextDrawSetShadow(playerid, RepairVehicleDraw[0][playerid], 0);
    PlayerTextDrawSetOutline(playerid, RepairVehicleDraw[0][playerid], 0);
    PlayerTextDrawFont(playerid, RepairVehicleDraw[0][playerid], 4);

    RepairVehicleDraw[1][playerid] = CreatePlayerTextDraw(playerid, 113.000007, 164.266784, "dvigatel"); // Двигатель + кнопка
    PlayerTextDrawBackgroundColor(playerid, RepairVehicleDraw[1][playerid], 0);
    PlayerTextDrawLetterSize(playerid, RepairVehicleDraw[1][playerid], 0.024666, 0.265481);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[1][playerid], 78.666694, 91.259277);
    PlayerTextDrawAlignment(playerid, RepairVehicleDraw[1][playerid], 1);
    PlayerTextDrawColor(playerid, RepairVehicleDraw[1][playerid], -1);
    PlayerTextDrawUseBox(playerid, RepairVehicleDraw[1][playerid], true);
    PlayerTextDrawBoxColor(playerid, RepairVehicleDraw[1][playerid], 0);
    PlayerTextDrawSetShadow(playerid, RepairVehicleDraw[1][playerid], 0);
    PlayerTextDrawSetOutline(playerid, RepairVehicleDraw[1][playerid], 0);
    PlayerTextDrawFont(playerid, RepairVehicleDraw[1][playerid], 5);
    PlayerTextDrawSetSelectable(playerid, RepairVehicleDraw[1][playerid], true);
    PlayerTextDrawSetPreviewModel(playerid, RepairVehicleDraw[1][playerid], 19917);
    PlayerTextDrawSetPreviewRot(playerid, RepairVehicleDraw[1][playerid], -40.000000, 0.000000, 0.000000, 1.000000);

    RepairVehicleDraw[2][playerid] = CreatePlayerTextDraw(playerid, 104.333343, 291.200012, "bar_fon"); // Фон бара загрузки
    PlayerTextDrawLetterSize(playerid, RepairVehicleDraw[2][playerid], 0.016000, 0.223999);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[2][playerid], 82.333305, 17.837022);
    PlayerTextDrawAlignment(playerid, RepairVehicleDraw[2][playerid], 1);
    PlayerTextDrawColor(playerid, RepairVehicleDraw[2][playerid], -1);
    PlayerTextDrawUseBox(playerid, RepairVehicleDraw[2][playerid], true);
    PlayerTextDrawBoxColor(playerid, RepairVehicleDraw[2][playerid], 0);
    PlayerTextDrawSetShadow(playerid, RepairVehicleDraw[2][playerid], 0);
    PlayerTextDrawSetOutline(playerid, RepairVehicleDraw[2][playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, RepairVehicleDraw[2][playerid], 168429944);
    PlayerTextDrawFont(playerid, RepairVehicleDraw[2][playerid], 5);
    PlayerTextDrawSetPreviewModel(playerid, RepairVehicleDraw[2][playerid], 2709);
    PlayerTextDrawSetPreviewRot(playerid, RepairVehicleDraw[2][playerid], 0.000000, 0.000000, 0.000000, -2.000000);

    RepairVehicleDraw[3][playerid] = CreatePlayerTextDraw(playerid, 188.333328, 278.755523, "ld_beat:chit"); // Фон кнопки ремонта
    PlayerTextDrawLetterSize(playerid, RepairVehicleDraw[3][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[3][playerid], 36.000007, 42.725891);
    PlayerTextDrawAlignment(playerid, RepairVehicleDraw[3][playerid], 1);
    PlayerTextDrawColor(playerid, RepairVehicleDraw[3][playerid], 168430200);
    PlayerTextDrawSetShadow(playerid, RepairVehicleDraw[3][playerid], 0);
    PlayerTextDrawSetOutline(playerid, RepairVehicleDraw[3][playerid], 0);
    PlayerTextDrawFont(playerid, RepairVehicleDraw[3][playerid], 4);
    PlayerTextDrawSetPreviewModel(playerid, RepairVehicleDraw[3][playerid], 3096);
    PlayerTextDrawSetPreviewRot(playerid, RepairVehicleDraw[3][playerid], 0.000000, 0.000000, 0.000000, 1.000000);

    RepairVehicleDraw[4][playerid] = CreatePlayerTextDraw(playerid, 194.000061, 285.807403, "remont_button"); // Кнопка ремонта
    PlayerTextDrawBackgroundColor(playerid, RepairVehicleDraw[4][playerid], 0);
    PlayerTextDrawLetterSize(playerid, RepairVehicleDraw[4][playerid], 0.012666, 0.149333);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[4][playerid], 23.666654, 28.622215);
    PlayerTextDrawAlignment(playerid, RepairVehicleDraw[4][playerid], 1);
    PlayerTextDrawColor(playerid, RepairVehicleDraw[4][playerid], -1);
    PlayerTextDrawUseBox(playerid, RepairVehicleDraw[4][playerid], true);
    PlayerTextDrawBoxColor(playerid, RepairVehicleDraw[4][playerid], 0);
    PlayerTextDrawSetShadow(playerid, RepairVehicleDraw[4][playerid], 0);
    PlayerTextDrawSetOutline(playerid, RepairVehicleDraw[4][playerid], 0);
    PlayerTextDrawFont(playerid, RepairVehicleDraw[4][playerid], 5);
    PlayerTextDrawSetSelectable(playerid, RepairVehicleDraw[4][playerid], true);
    PlayerTextDrawSetPreviewModel(playerid, RepairVehicleDraw[4][playerid], 3096);
    PlayerTextDrawSetPreviewRot(playerid, RepairVehicleDraw[4][playerid], 0.000000, 0.000000, 0.000000, 1.000000);

    RepairVehicleDraw[5][playerid] = CreatePlayerTextDraw(playerid, 118.666648, 291.614837, "LD_SPAC:white"); // Зелёная полоска 1
    PlayerTextDrawLetterSize(playerid, RepairVehicleDraw[5][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[5][playerid], 3.000002, 17.422197);
    PlayerTextDrawAlignment(playerid, RepairVehicleDraw[5][playerid], 1);
    PlayerTextDrawColor(playerid, RepairVehicleDraw[5][playerid], 13793535);
    PlayerTextDrawSetShadow(playerid, RepairVehicleDraw[5][playerid], 0);
    PlayerTextDrawSetOutline(playerid, RepairVehicleDraw[5][playerid], 0);
    PlayerTextDrawFont(playerid, RepairVehicleDraw[5][playerid], 4);

    RepairVehicleDraw[6][playerid] = CreatePlayerTextDraw(playerid, 142.666595, 291.370361, "LD_SPAC:white"); // Зелёная полоска 2
    PlayerTextDrawLetterSize(playerid, RepairVehicleDraw[6][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[6][playerid], 3.000002, 17.422197);
    PlayerTextDrawAlignment(playerid, RepairVehicleDraw[6][playerid], 1);
    PlayerTextDrawColor(playerid, RepairVehicleDraw[6][playerid], 13793535);
    PlayerTextDrawSetShadow(playerid, RepairVehicleDraw[6][playerid], 0);
    PlayerTextDrawSetOutline(playerid, RepairVehicleDraw[6][playerid], 0);
    PlayerTextDrawFont(playerid, RepairVehicleDraw[6][playerid], 4);

    RepairVehicleDraw[7][playerid] = CreatePlayerTextDraw(playerid, 164.666610, 291.125885, "LD_SPAC:white"); // Зелёная полоска 3
    PlayerTextDrawLetterSize(playerid, RepairVehicleDraw[7][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[7][playerid], 3.000002, 17.422197);
    PlayerTextDrawAlignment(playerid, RepairVehicleDraw[7][playerid], 1);
    PlayerTextDrawColor(playerid, RepairVehicleDraw[7][playerid], 13793535);
    PlayerTextDrawSetShadow(playerid, RepairVehicleDraw[7][playerid], 0);
    PlayerTextDrawSetOutline(playerid, RepairVehicleDraw[7][playerid], 0);
    PlayerTextDrawFont(playerid, RepairVehicleDraw[7][playerid], 4);

    RepairVehicleDraw[8][playerid] = CreatePlayerTextDraw(playerid, 105.666664, 292.444458, "LD_SPAC:white"); // Бар загрузки
    PlayerTextDrawLetterSize(playerid, RepairVehicleDraw[8][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[8][playerid], 53.333351, 15.348165);
    PlayerTextDrawAlignment(playerid, RepairVehicleDraw[8][playerid], 1);
    PlayerTextDrawColor(playerid, RepairVehicleDraw[8][playerid], 11599871);
    PlayerTextDrawSetShadow(playerid, RepairVehicleDraw[8][playerid], 0);
    PlayerTextDrawSetOutline(playerid, RepairVehicleDraw[8][playerid], 0);
    PlayerTextDrawFont(playerid, RepairVehicleDraw[8][playerid], 4);

    RepairVehicleDraw[9][playerid] = CreatePlayerTextDraw(playerid, 115.333335, 277.096405, "ld_chat:thumbup"); // Статус первой полоски
    PlayerTextDrawLetterSize(playerid, RepairVehicleDraw[9][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[9][playerid], 9.333340, 11.199990);
    PlayerTextDrawAlignment(playerid, RepairVehicleDraw[9][playerid], 1);
    PlayerTextDrawColor(playerid, RepairVehicleDraw[9][playerid], -1);
    PlayerTextDrawSetShadow(playerid, RepairVehicleDraw[9][playerid], 0);
    PlayerTextDrawSetOutline(playerid, RepairVehicleDraw[9][playerid], 0);
    PlayerTextDrawFont(playerid, RepairVehicleDraw[9][playerid], 4);

    RepairVehicleDraw[10][playerid] = CreatePlayerTextDraw(playerid, 139.333328, 277.266754, "ld_chat:thumbup"); // Статус второй полоски
    PlayerTextDrawLetterSize(playerid, RepairVehicleDraw[10][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[10][playerid], 9.333340, 11.199990);
    PlayerTextDrawAlignment(playerid, RepairVehicleDraw[10][playerid], 1);
    PlayerTextDrawColor(playerid, RepairVehicleDraw[10][playerid], -1);
    PlayerTextDrawSetShadow(playerid, RepairVehicleDraw[10][playerid], 0);
    PlayerTextDrawSetOutline(playerid, RepairVehicleDraw[10][playerid], 0);
    PlayerTextDrawFont(playerid, RepairVehicleDraw[10][playerid], 4);

    RepairVehicleDraw[11][playerid] = CreatePlayerTextDraw(playerid, 161.666671, 277.437103, "ld_beat:down"); // Статус третьей полоски
    PlayerTextDrawLetterSize(playerid, RepairVehicleDraw[11][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, RepairVehicleDraw[11][playerid], 9.333340, 11.199990);
    PlayerTextDrawAlignment(playerid, RepairVehicleDraw[11][playerid], 1);
    PlayerTextDrawColor(playerid, RepairVehicleDraw[11][playerid], -1);
    PlayerTextDrawSetShadow(playerid, RepairVehicleDraw[11][playerid], 0);
    PlayerTextDrawSetOutline(playerid, RepairVehicleDraw[11][playerid], 0);
    PlayerTextDrawFont(playerid, RepairVehicleDraw[11][playerid], 4);

    OnlineInfo[playerid][oRepairVehDraw] = true;
    posDraw_RepairVehicle(playerid);
    return 1;
}
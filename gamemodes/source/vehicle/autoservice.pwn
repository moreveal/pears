
// Диалоговое окно о начале покупки
stock showDialogBuyAutoserviceDetail(playerid, slot)
{
    new b = gAutosalon[playerid];
	DP[6][playerid] = slot; // Записали слот товара в бизнесе
	new line[140],lines[700];
	format(line,sizeof(line),"{ff9000}Вы уверены, что хотите приобрести %s?", GetNameThing(0, BizzInfo[b][bProduct][slot], BizzInfo[b][bTypeProduct][slot], 0)), strcat(lines,line);
	format(line,sizeof(line),"\n{cccccc}Стоимость: {99ff66}%d$", BizzInfo[b][bPrice][slot]), strcat(lines,line);
	ShowDialog(playerid,436,DIALOG_STYLE_MSGBOX,"{ff9000}Автосервис",lines,"Да","Нет");
	return 1;
}

// Покупка и установка предмета в автосервисе
stock buyThingAutoserice(playerid, slot)
{
	new b = gAutosalon[playerid];
	new vehicleid = OnlineInfo[playerid][oAutoserviceVeh];
    if(BizzInfo[b][bItem][slot] <= 0) return ErrorMessage(playerid, "{FF6347}Товара нет в наличии\n{ffcc66}Вы можете отправить в другой автосервис");
	if(Cars[vehicleid] != 88) return ErrorMessage(playerid, "{FF6347}Установить эту деталь можно только на личный транспорт");
	if(oGetPlayerMoney(playerid) < BizzInfo[b][bPrice][slot]) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
	
	new thingId = BizzInfo[b][bProduct][slot], thingType = BizzInfo[b][bTypeProduct][slot];
    new maxHealth = MaxVehicleHealth(VehInfo[vehicleid][vModel], 0);
    if(VehInfo[vehicleid][vHealth] < maxHealth) return ErrorMessage(playerid, "{FF6347}Отремонтируйте ваш транспорт прежде чем установить деталь");

	if(thingId == 226)
	{
		if(VehInfo[vehicleid][vArmor] == 1000) return ErrorMessage(playerid, "{FF6347}Эта деталь уже установлена");
		VehInfo[vehicleid][vArmor] = 1000;
        SetVehicleArmor(vehicleid);
	}
	else if(thingId == 227)
	{
		if(VehInfo[vehicleid][vArmor] == 2000) return ErrorMessage(playerid, "{FF6347}Эта деталь уже установлена");
		VehInfo[vehicleid][vArmor] = 2000;
        SetVehicleArmor(vehicleid);
	}
	else if(thingId == 228)
	{
		if(VehInfo[vehicleid][vArmor] == 3000) return ErrorMessage(playerid, "{FF6347}Эта деталь уже установлена");
		VehInfo[vehicleid][vArmor] = 3000;
        SetVehicleArmor(vehicleid);
	}

    BizzInfo[b][bItem][slot] -= 1, BizzInfo[b][bUpdate] = 1;

	SaveCar(vehicleid);
	oGivePlayerMoney(playerid, -BizzInfo[b][bPrice][slot]);
	paybiz(b, BizzInfo[b][bPrice][slot]);

	new string[100];
	format(string,sizeof(string),"Купил %s в бизе %d", GetNameThing(0, thingId, thingType, 0), b);
    MoneyLog("autoservice", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -BizzInfo[b][bPrice][slot], string);

	format(string,sizeof(string),"{99ff66}Вы купили %s", GetNameThing(0, thingId, thingType, 0));
	SuccessMessage(playerid, string);
	return 1;
}

stock SetVehicleArmor(vehicleid)
{
    new maxHealth = MaxVehicleHealth(VehInfo[vehicleid][vModel], 0);
    ACSetVehicleHealth(vehicleid, maxHealth + VehInfo[vehicleid][vArmor]);
    return 1;
}

stock CheckAutoInRangeService(playerid)
{
    new b = gAutosalon[playerid];
    new quan = -1, veh;
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT && GetPlayerInterior(playerid) != 223) return 0;
    for(new i = 0; i < MAX_MYVEHICLE; i++)
	{
		if(PlayerInfo[playerid][pMyVeh][i] > 0)
        {
			if(PlayerInfo[playerid][pMyVehID][i] > 0)
			{
                if(!IsVehicleInRangeOfPoint(PlayerInfo[playerid][pMyVehID][i], 50.0,  BizzInfo[b][bX], BizzInfo[b][bY], BizzInfo[b][bZ])) continue;
                quan = i;
                veh = PlayerInfo[playerid][pMyVehID][i];
                break;
			}
		}
	}
    if(quan == -1) return ErrorMessage(playerid,"{ff6347}Рядом с Автосервисом нет вашего транспорта");
    new v = GetPlayerVehicleID(playerid);
    if(Cars[v] != 88) return ErrorMessage(playerid, "{FF6347}Установить эту деталь можно только на личный транспорт");
    if(VehInfo[v][vSost] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid,"{ff6347}Вы сидите не в своем транспорте");
    if(VehInfo[v][vHandlingModel] == GetVehicleRealModel(veh)) return ErrorMessage(playerid, "{FF6347}Характеристики этой машины такой же как и в транспорте, с которого хотите перенести");

    // Ищем дефолтные характеристики той тачки
    new vehicleHandlingID = FindVehicleModelHandling(GetVehicleRealModel(veh));
    if(vehicleHandlingID == -1) return ErrorMessage(playerid, "{FF6347}Ошибка! Характеристики транспорта не были найдены");
    VehInfo[v][vHandlingModelTemp] = 0;
    // Снимаем тюнинг с нашей тачки и кладём в багажник
    TakeAllTunningVehicle(v);

    // Перекидываем тюнинг с другой тачки на нашу
    ReversVehicleTunning(v, veh);

    // Записали характеристики другой тачки на нашу
    VehInfo[v][vHandlingModel] = GetVehicleRealModel(veh);

    // Устанавливаем все характеристики на транспорт
    SetHandlingTotal(v);

    // Сохраняем тюнинг на транспорте
    SaveTunning(v);
    
    new string[160];
    format(string, sizeof(string),"{99ff66}Корпус вашего транспорта был совмещён с %s\n{ffcc66}%s был разобран на запчасти", GetVehicleName(VehInfo[veh][vModel]), GetVehicleName(VehInfo[veh][vModel]));
    SuccessMessage(playerid, string);
    if(oGetPlayerMoney(playerid) < BizzInfo[b][bPrice][9]) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
    SaveCar(v);
    oGivePlayerMoney(playerid, -BizzInfo[b][bPrice][9]);

    format(string, sizeof(string),"Замена хендлинга %s (%s) в бизе %d", GetVehicleName(VehInfo[veh][vModel]), GetVehicleName(VehInfo[veh][vModel]), b);
    MoneyLog("autoservice", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -BizzInfo[b][bPrice][9], string);
    paybiz(b, BizzInfo[b][bPrice][9]);
    DeleteMyVeh(playerid, quan);
    return 1;
}

stock ShowDetailHandling(playerid, tuningType)
{
    new quan = 0;
    for(new i; i < MAX_DETAIL; i++)
    {
        ListParam[i][playerid] = 0;
        if(friskDetail[i][1] == tuningType)
        {
            ListParam[quan][playerid] = i;
            quan++;
        }
    }
    if(quan == 0) return ErrorMessage(playerid,"{ff6347}Кажется данных деталей тюнинга нет");
    DP[0][playerid] = quan+1;
    DP[1][playerid] = tuningType;
    new v = GetPlayerVehicleID(playerid);
    new lineHeader[30];
    format(lineHeader,sizeof(lineHeader),"Тюнинг {ff9000}%s",friskDetailTypeName[tuningType]);
    new line[70],lines[10*70];
    if(tuningType == 0) format(line,sizeof(line),"{ff9000}Деталь\t{cccccc}[Скорость | Ускорение]\t{99ff66}Цена"), strcat(lines,line);
    else if(tuningType == 1) format(line,sizeof(line),"{ff9000}Деталь\t{cccccc}[Ускорение]\t{99ff66}Цена"), strcat(lines,line);
    else if(tuningType == 2) format(line,sizeof(line),"{ff9000}Деталь\t{cccccc}[Качество поворотов]\t{99ff66}Цена"), strcat(lines,line);
    else if(tuningType == 3) format(line,sizeof(line),"{ff9000}Деталь\t{cccccc}[Сцепление с дорогой]\t{99ff66}Цена"), strcat(lines,line);
    else if(tuningType == 4) format(line,sizeof(line),"{ff9000}Деталь\t{cccccc}[Качество тормозов]\t{99ff66}Цена"), strcat(lines,line);
    for(new i; i<quan;i++)
    {
        if(tuningType == 0) format(line,sizeof(line),"\n{ff9000}%s\t{cccccc}[+%s %% | +%s %%]\t{99ff66}%d$",friskName[friskDetail[ListParam[i][playerid]][0]],friskDetailPoint[ListParam[i][playerid]][0],friskDetailPoint[ListParam[i][playerid]][1],BizzInfo[gAutosalon[playerid]][bPrice][friskDetail[ListParam[i][playerid]][2]]), strcat(lines,line);
        else if(tuningType >= 1 && tuningType <= 4) 
        {
            format(line,sizeof(line),"\n{ff9000}%s\t{cccccc}[+%s %%]\t{99ff66}%d$",friskName[friskDetail[ListParam[i][playerid]][0]],friskDetailPoint[ListParam[i][playerid]][0],BizzInfo[gAutosalon[playerid]][bPrice][friskDetail[ListParam[i][playerid]][2]]), strcat(lines,line);
        }
        else format(line,sizeof(line),"\n{ff9000}%s\t{cccccc}[Пусто]\t{99ff66}%d$",friskName[friskDetail[ListParam[i][playerid]][0]],BizzInfo[gAutosalon[playerid]][bPrice][friskDetail[ListParam[i][playerid]][2]]), strcat(lines,line);
    }
    format(line,sizeof(line),"\n{ff9000}Снять временную деталь %s",friskDetailTypeName[tuningType]), strcat(lines,line);
    if(GetVehicleDetailTunning(v, tuningType) != -1) format(line,sizeof(line),"\n{ff9000}Снять деталь %s",friskDetailTypeName[tuningType]), strcat(lines,line);
    ShowDialog(playerid,576,DIALOG_STYLE_TABLIST_HEADERS,lineHeader,lines,"Выбор","Отмена");
    return 1;
}

stock ShowMenuBonnet(playerid)
{
    new v = OnlineInfo[playerid][oShowTabs];
    if(v == 9999) return true;
    
    new line[60],lines[360];
    format(line,sizeof(line),"{ff9000}Диагностика"), strcat(lines,line);
    for(new i; i<sizeof(friskDetailTypeName);i++)
    {
        if(GetVehicleDetailTunning(v, i) != -1) 
        {
            format(line,sizeof(line),"\n{ff9000}Снять деталь %s",friskDetailTypeName[i]), strcat(lines,line);
            List[i][playerid] = i;
        }
    }
    ShowDialog(playerid,1502,DIALOG_STYLE_TABLIST,"{ff9000}Тюнинг",lines,"Выбор","Отмена");
    return 1;
}

stock ShowAllTypeDetail(playerid)
{
    new line[60],lines[360];
    format(line,sizeof(line),"{ff9000}Деталь\t{cccccc}Характеристики"), strcat(lines,line);
    format(line,sizeof(line),"\n{ff9000}Двигатель\t{cccccc}[Скорость | Ускорение]"), strcat(lines,line);
    format(line,sizeof(line),"\n{ff9000}Трансмиссия\t{cccccc}[Ускорение]"), strcat(lines,line);
    format(line,sizeof(line),"\n{ff9000}Подвеска\t{cccccc}[Качество поворотов]"), strcat(lines,line);
    format(line,sizeof(line),"\n{ff9000}Шины\t{cccccc}[Сцепление с дорогой]"), strcat(lines,line);
    format(line,sizeof(line),"\n{ff9000}Тормоза\t{cccccc}[Качество тормоза]"), strcat(lines,line);
    ShowDialog(playerid,575,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Тюнинг",lines,"Выбор","Отмена");
    return 1;
}

stock dialogCase_AutoService(playerid, dialogid, response, listitem,const inputtext[])
{
    if(dialogid == 575)
    {
        if(response)
        {
            if(listitem > 5 || listitem < 0) return 0;
            ShowDetailHandling(playerid,listitem);
        }
        else CloseTuning(playerid);
    }
    if(dialogid == 576)
    {
        if(response)
        {
            new v = GetPlayerVehicleID(playerid);
            if(Cars[v] != 88) return ErrorMessage(playerid, "{FF6347}Установить эту деталь можно только на личный транспорт");
            DP[2][playerid] = gAutosalon[playerid];
            if(listitem < 0 && listitem > DP[0][playerid]) return ErrorMessage(playerid,"{ff6347}Ошибка строки");
            if(listitem == DP[0][playerid])
            {
                new slot = GetVehicleDetailTunning(v, DP[1][playerid]);
                if(slot == -1) return ErrorMessage(playerid,"{ff6347}В вашем транспорте не стоит тип детали");
                new put_inva = PutThingBoot(v, VehInfo[v][vTunningID][slot], 1, VehInfo[v][vTunningType][slot], VehInfo[v][vTunningQara][slot], 0, 0, 999);
                if(put_inva == -1) return ErrorMessage(playerid,"{ff6347}В багажнике авто нет места что бы положить туда деталь");
                {
                    new stringlog[64];
                    format(stringlog,sizeof(stringlog),"Снял деталь тюнинга %s в СТО %d",friskName[VehInfo[v][vTunningID][slot]],gAutosalon[playerid]);
                    CarLog("settun", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], VehInfo[v][vModel], VehInfo[v][vTunningID][slot], stringlog);
                }
                RemoveDetailTunningSlot(v, slot);
                SaveOneTunning(v, slot);
                return SuccessMessage(playerid,"{44ff99}Вы успешно сняли деталь тюнинга");
            }
            if(listitem == DP[0][playerid]-1)
            {
                if(TempDetail[playerid][DP[1][playerid]] == 0) return ErrorMessage(playerid,"{ff6347}В вашем транспорте нет временного типа детали");
                TempDetail[playerid][DP[1][playerid]] = 0;
                return SuccessMessage(playerid,"{44ff99}Вы успешно сняли временную деталь тюнинга");
            }
            TempDetail[playerid][friskDetail[ListParam[listitem][playerid]][1]] = friskDetail[ListParam[listitem][playerid]][0];
            SuccessMessage(playerid,"{44ff99}Вы успешно установили временно деталь тюнинга\n\nПосле выхода из автосервиса вам предложит купить весь временный тюнинг");
        }
        else return ShowAllTypeDetail(playerid);
    }
    if(dialogid == 713)
    {
        if(response)
        {
            new temp[4],value;
            new v = GetPlayerVehicleID(playerid);
            if(sscanf(inputtext, "i", value)) return ErrorMessage(playerid,"{ff6347}Вы ничего не ввели");
            if((value < 5 || value > 9) && value != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Введите от 5 до 9, чтобы изменить высоту подвески или 0 что бы убрать");
            if(value == 0)
            {
                VehInfo[v][vTunningBPANTemp] = 0;
                VehInfo[v][vTunningBPAN] = 0;
                SetVehicleHandlingFloat(v, HANDLING_SUSPFORCELEVEL, HandlingVehInfo[v][HD_SuspensionForceLevel]);
                SuccessMessage(playerid,"{44ff99}Вы успешно вернули стандартные настройки высоты подвески");
                return 1;
            }
            format(temp,4,"0.%d",value);
            VehInfo[v][vTunningBPANTemp] = floatstr(temp);
            SetVehicleHandlingFloat(v, HANDLING_SUSPFORCELEVEL, floatstr(temp));
            SuccessMessage(playerid,"{44ff99}Вы успешно установили временно деталь тюнинга");
        }
        else CloseTuning(playerid);
    }
    if(dialogid == 708)
    {
        if(response)
        {
            new v = GetPlayerVehicleID(playerid);
            new b = gAutosalon[playerid];
            new money;
            for(new i;i< sizeof(friskDetailTypeName);i++)
            {
                if(TempDetail[playerid][i] > 0)
                {
                    money += BizzInfo[b][bPrice][friskDetail[TempDetail[playerid][i] - 207][2]];
                }
            }
            if(oGetPlayerMoney(playerid) < money) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");
            new stringlog[128];
            for(new i;i< sizeof(friskDetailTypeName);i++)
            {
                new slot = -1;
                if(TempDetail[playerid][i] > 0)
                {
                    slot = GetVehicleDetailTunning(v, friskDetail[TempDetail[playerid][i] - 207][1]);
                    if(slot == -1)
                    {
                        new slot2 = SetVehicleDetailTunning(v, TempDetail[playerid][i], 0,friskDetail[TempDetail[playerid][i] - 207][1]);
                        if(slot2 == -1)
                        {
                            ErrorMessage(playerid, "{FF6347}В транспорте нет слотов для установки тюнинга(какие-то детали могли установится)");
                            break;
                        }
                        else
                        {
                            BizzInfo[b][bItem][friskDetail[TempDetail[playerid][i]-207][2]] -= 1;
                        }
                    }
                    else
                    {
                        format(stringlog,sizeof(stringlog),"Деталь %s заменена в автосервисе",friskName[VehInfo[v][vTunningID][slot]]);
                        CarLog("PutThingBoot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], VehInfo[v][vModel], VehInfo[v][vTunningID][slot], stringlog);
                        PutThingBoot(v, VehInfo[v][vTunningID][slot], 1, VehInfo[v][vTunningType][slot], VehInfo[v][vTunningQara][slot], 0, 0, 999);
                        VehInfo[v][vTunningID][slot] = TempDetail[playerid][i];
                        VehInfo[v][vTunningQara][slot] = 0;
                        VehInfo[v][vTunningType][slot] = friskDetail[TempDetail[playerid][i]-207][1];
                        BizzInfo[b][bItem][friskDetail[TempDetail[playerid][i]-207][2]] -= 1;
                    }
                    format(stringlog,sizeof(stringlog),"Купил деталь тюнинга %s, в бизе %d, за %d$",friskName[TempDetail[playerid][i]],b,BizzInfo[b][bPrice][friskDetail[TempDetail[playerid][i] - 207][2]]);
                    CarLog("buytun", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], VehInfo[v][vModel], TempDetail[playerid][i], stringlog);
                    TempDetail[playerid][i] = 0;
                }
            }
            SaveTunning(v);
            BizzInfo[b][bUpdate] = 1;
            oGivePlayerMoney(playerid, -money);

            new string[120];
            format(string, sizeof(string),"Купил тюнинг в бизе %d", b);
            MoneyLog("autoservice", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -money, string);
            paybiz(b, money);
            SuccessMessage(playerid,"{99ff66}Вы успешно установили детали тюнинга");
            return ExitTuning(playerid);
        }
        else CloseTuning(playerid);
    }
    if(dialogid == 551)
    {
        if(response)
        {
            new b = gAutosalon[playerid];
            new quan = -1, veh;
            if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT && GetPlayerInterior(playerid) != 223) return 0;
            for(new i = 0; i < MAX_MYVEHICLE; i++)
            {
                if(PlayerInfo[playerid][pMyVeh][i] > 0)
                {
                    if(PlayerInfo[playerid][pMyVehID][i] > 0)
                    {
                        if(!IsVehicleInRangeOfPoint(PlayerInfo[playerid][pMyVehID][i], 50.0,  BizzInfo[b][bX], BizzInfo[b][bY], BizzInfo[b][bZ])) continue;
                        quan = i;
                        veh = PlayerInfo[playerid][pMyVehID][i];
                        break;
                    }
                }
            }
            if(quan == -1) return ErrorMessage(playerid,"{ff6347}Рядом с Автосервисом нет вашего транспорта");
            new v = GetPlayerVehicleID(playerid);
            if(VehInfo[v][vSost] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid,"{ff6347}Вы сидите не в своем транспорте");
            if(VehInfo[v][vHandlingModel] == GetVehicleRealModel(veh)) return ErrorMessage(playerid, "{FF6347}Характеристики этой машины такой же как и в транспорте, с которого хотите перенести");
            new vehicleHandlingID = FindVehicleModelHandling(GetVehicleRealModel(veh));

            // Если не нашли хендлинг транспорта, останавливаем установку
            if(vehicleHandlingID <= 0) return 1;
            SetVehicleHandlingDefault(v,vehicleHandlingID);
            VehInfo[v][vHandlingModelTemp] = GetVehicleRealModel(veh);
            SuccessMessage(playerid,"{44ff99}Временный хендлинг для TestDrive установлен");
        }
        else CloseTuning(playerid);
    }
    if(dialogid == 1502)
    {
        if(response)
        {
            new v = OnlineInfo[playerid][oShowTabs];
            if(listitem < 0 || listitem > 6) return 0;
            if(listitem == 0) DiagnosVehicle(playerid, v, 0);
            if(listitem >= 1 && listitem <= 6)
            {
                new stringlog[50];
                if(Cars[v] != 88) return ErrorMessage(playerid, "{FF6347}Снимать деталь можно только с личного транспорта");
                if(VehInfo[v][vSost] != PlayerInfo[playerid][pID]) return ErrorMessage(playerid,"{ff6347}Это не ваш личный транспорт");
                if(!IsACar(VehInfo[v][vModel])) return ErrorMessage(playerid,"{ff6347}Тюнинг можно снимать только с автомобиля!");
                new slot = GetVehicleDetailTunning(v, List[listitem-1][playerid]);
                if(slot == -1) return ErrorMessage(playerid,"{ff6347}В вашем транспорте не стоит тип детали");
                new put_inva = GiveThingPlayer(playerid, VehInfo[v][vTunningID][slot], 1, 0, VehInfo[v][vTunningQara][slot], 0, 0, 9999); // Выдаём предмет игроку
                if(put_inva == -1) return ErrorMessage(playerid,"{ff6347}В инвентаре нет места чтобы положить туда деталь");
                format(stringlog,sizeof(stringlog),"Снял деталь тюнинга %s",friskName[VehInfo[v][vTunningID][slot]]);
                CarLog("settun", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], VehInfo[v][vModel], VehInfo[v][vTunningID][slot], stringlog);
                RemoveDetailTunningSlot(v, slot);
                SaveOneTunning(v, slot);
                return SuccessMessage(playerid,"{44ff99}Вы успешно сняли деталь тюнинга");
            }
        }
    }
    return 1;
}

stock ExitTuningOrSave(playerid)
{
    new veh = GetPlayerVehicleID(playerid);
    new line[90],lines[2500];
    format(line,sizeof(line),"{cccccc}Неоплаченный тюнинг транспорта\n"), strcat(lines,line);
    format(line,sizeof(line),"{ff6347}- Детали того же типа, что уже установлены на транспорт будут заменены!\n"), strcat(lines,line);
    new b = gAutosalon[playerid];
    for(new i;i< sizeof(friskDetailTypeName);i++)
    {
        if(TempDetail[playerid][i] > 0)
        {
            format(line,sizeof(line),"\n{cccccc}%s: %s [ + %s%% ] {99ff66}[ %d$ ]",friskDetailTypeName[friskDetail[TempDetail[playerid][i]-207][1]],friskName[TempDetail[playerid][i]],friskDetailPoint[TempDetail[playerid][i]-207][0],BizzInfo[b][bPrice][friskDetail[TempDetail[playerid][i]-207][2]]), strcat(lines,line);
        }
    }
    format(line,sizeof(line),"\n\n{cccccc}Имеющийся тюнинг"), strcat(lines,line);
    for(new i;i< MAX_TUNNING_VEHICLE;i++)
    {
        if(VehInfo[veh][vTunningID][i] > 0)
        {
            format(line,sizeof(line),"\n{cccccc}%s: %s [ + %s%% ]",friskDetailTypeName[friskDetail[VehInfo[veh][vTunningID][i]-207][1]],friskName[VehInfo[veh][vTunningID][i]], friskDetailPoint[VehInfo[veh][vTunningID][i]-207][0]), strcat(lines,line);
        }
    }
    format(line,sizeof(line),"\n\n{ff6347}Оплатить тюнинг?"), strcat(lines,line);
    ShowDialog(playerid,708,DIALOG_STYLE_MSGBOX,"{ff9000}Тюнинг Транспорта",lines,"Да","Нет");
    return 1;
}

CMD:checktun(playerid,const param[])
{
    if(sscanf(param, "i",param[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Для просмотра тюнинга машины нужен ID [ /checktun ID ]");
    new veh = param[0];
    new line[50],lines[2500];
    format(line,sizeof(line),"Тюнинг транспорта:{ff0000} %s\n",GetVehicleName(veh)), strcat(lines,line);
    for(new i;i< MAX_TUNNING_VEHICLE;i++)
    {
        if(VehInfo[veh][vTunningID][i] > 0)
        {
            format(line,sizeof(line),"\n%s",friskName[VehInfo[veh][vTunningID][i]]), strcat(lines,line);
        }
    }
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ff9000}Тюнинг Транспорта",lines,"ОК","");
    return 1;
}
stock ClickTextDraw_Autoservice(playerid, Text:clickedid) // Кликаем по текстдравам
{
    if(clickedid == TuningDraw[17]) // Кнопка Test Drive
	{
        PlayerPlaySound(playerid,17803,0,0,0);
        PlayerPlaySound(playerid,30800,0,0,0);
        openTestDrive_Autoservice(playerid);
        return 1;
    }
    return 0;
}

stock showPlayerAutoserviceMenu(playerid)
{
    playerDefaultCameraAutoservice(playerid);
    PlayerPlaySound(playerid, 30801, 0.0, 0.0, 0.0);
    TogglePlayerControllable(playerid, false);

    S_SetPlayerVirtualWorld(playerid,playerid+1,223);
    PPSetPlayerInterior(playerid,223);

    OnlineInfo[playerid][oShowInterface] = 20; // Интерфейс автосервиса
    TextDrawShowForPlayer(playerid, TuningDraw[0]);
    TextDrawShowForPlayer(playerid, TuningDraw[1]);
    TextDrawShowForPlayer(playerid, TuningDraw[2]);
    TextDrawShowForPlayer(playerid, TuningDraw[3]);
    TextDrawShowForPlayer(playerid, TuningDraw[4]);
    TextDrawShowForPlayer(playerid, TuningDraw[5]);
    TextDrawShowForPlayer(playerid, TuningDraw[6]);
    TextDrawShowForPlayer(playerid, TuningDraw[7]);
    TextDrawShowForPlayer(playerid, TuningDraw[8]);
    TextDrawShowForPlayer(playerid, TuningDraw[9]);
    TextDrawShowForPlayer(playerid, TuningDraw[10]);
    TextDrawShowForPlayer(playerid, TuningDraw[17]);
    TextDrawShowForPlayer(playerid, TuningDraw[18]);
    SelectColorDraw(playerid);
    NoAnim[playerid] = 1;

    SetPVarInt(playerid,"tunstat",0);
    if(PlayerInfo[playerid][pDrawVisible][7] == false && setting_pos_draw[playerid] != 8 && setting_size_draw[playerid] != 8) CloseVehSpeed(playerid);
    HideOldHint(playerid);

    // Воспроизводим музыку в автосервисе
    PlayMenuMusicForPlayer(playerid, 2);
    return 1;
}

stock playerDefaultCameraAutoservice(playerid)
{
    new vehicleid = OnlineInfo[playerid][oAutoserviceVeh];
    new model = VehInfo[vehicleid][vModel];
    if(IsAMoto(model))
    {
        InterpolateCameraPos(playerid, -1131.184082, 2869.335693, 919.213500, -1131.184082, 2869.335693, 919.213500, 1000);
        InterpolateCameraLookAt(playerid, -1136.030883, 2868.354980, 918.474060, -1136.030883, 2868.354980, 918.474060, 1000);
    }
    else if(IsABig(model))
    {
        InterpolateCameraPos(playerid, -1124.197387, 2869.546875, 920.400634, -1124.197387, 2869.546875, 920.400634, 1000);
        InterpolateCameraLookAt(playerid, -1125.660156, 2874.268066, 919.644958, -1125.660156, 2874.268066, 919.644958, 1000);
    }
    else
    {
        InterpolateCameraPos(playerid, -1130.384399, 2875.142333, 919.587463, -1130.384399, 2875.142333, 919.587463, 1000);
        InterpolateCameraLookAt(playerid, -1135.326416, 2874.769531, 918.925659, -1135.326416, 2874.769531, 918.925659, 1000);
    }
    return 1;
}

stock vehiclePositionAutoservice(vehicleid, playerid)
{
    VehInfo[vehicleid][vTestDrive] = 0;
    new model = VehInfo[vehicleid][vModel];
    if(IsAMoto(model))
    {
        ACSetVehiclePos(vehicleid,-1137.9078,2867.5972,917.8622);
        SetVehicleZAngle(vehicleid, 250.4064);
    }
    else if(IsABig(model))
    {
        ACSetVehiclePos(vehicleid,-1126.8308,2880.2805,918.4659);
        SetVehicleZAngle(vehicleid, 179.0594);
    }
    else
    {
        ACSetVehiclePos(vehicleid,-1138.4857,2875.1323,917.9734);
        SetVehicleZAngle(vehicleid, 249.8055);
    }
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, false, false, alarm, doors, bonnet, boot, objective);
    VehInfo[vehicleid][vEngine] = 0;
    VehInfo[vehicleid][vLights] = 0;
    SetVehicleVirtualWorld(vehicleid, playerid+1);
    LinkVehicleToInterior(vehicleid, 223);
    return 1;
}

stock openTestDrive_Autoservice(playerid)
{
    if(gAutosalon[playerid] == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Вы не находитесь в автосервисе");
    new vehicleid = GetPlayerVehicleID(playerid);
    if(Cars[vehicleid] != 88) return ErrorMessage(playerid, "{FF6347}Test Drive доступен только для личного транспорта");
    if(GetPVarInt(playerid,"tunstat") > 0) return ErrorMessage(playerid, "{FF6347}Сохраните или отмените выбранную деталь\n{ffcc66}Test Drive доступен только для проверки характеристик транспорта");
    if(OnlineInfo[playerid][oTimerAutoservice] > 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Дождитесь завершения выхода из тест драйва");

    new Float:health, Float:max_health = MaxVehicleHealth(VehInfo[vehicleid][vModel], vehicleid);
    GetVehicleHealth(vehicleid, health);
    if(health < max_health) return ErrorMessage(playerid, "{FF6347}Почините двигатель транспорта, прежде чем использовать Test Drive");

    if(IsACar(VehInfo[vehicleid][vModel]))
    {
        new panels, vehdoors, vehlights, tires;
        GetVehicleDamageStatus(vehicleid, VEHICLE_PANEL_STATUS:panels, VEHICLE_DOOR_STATUS:vehdoors, VEHICLE_LIGHT_STATUS:vehlights, VEHICLE_TYRE_STATUS:tires);
        if(panels != 0 || vehdoors != 0 || vehlights != 0 || tires != 0) return ErrorMessage(playerid, "{FF6347}Почините транспорт, прежде чем использовать Test Drive");
    }
    
    VehShopInfo[playerid][vsTest] = true;

    HidePlayerDialog(playerid); // Сбрасываем диалоговые окна
    hideDraw_Autoservice(playerid); // Удаляем текстдравы
    OnlineInfo[playerid][oShowInterface] = 0;

    CancelSelectTextDraw(playerid); // Убираем мышку
	TogglePlayerControllable(playerid, true); // Unfreeze

    PPSetPlayerInterior(playerid, 0);
    LinkVehicleToInterior(vehicleid, 0);

	VehInfo[vehicleid][vTestDrive] = playerid + 1; // Транспорт находится в Test Drive
    positionVehicleTestDrive(vehicleid);

    SetCameraBehindPlayer(playerid); // Возвращаем камеру
    SuccessMessage(playerid, "{99ff66}Вы запустили Test Drive {cccccc}[ Выйти: кнопка N ]");

    // Запускаем транспорт
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, true, true, alarm, doors, bonnet, boot, objective);
    VehInfo[vehicleid][vLights] = 1;
    VehInfo[vehicleid][vEngine] = 1;
    SetHandlingTotalForTestDrive(playerid,vehicleid);

    if(PlayerInfo[playerid][pDrawVisible][7] == false && setting_pos_draw[playerid] != 8 && setting_size_draw[playerid] != 8) ShowVehSpeed(playerid);

    // Выключаем музыку
    if(OnlineInfo[playerid][oListenRadioPears] == 0) StopAudioStreamForPlayer(playerid), HidePlayerHudPopup(playerid);
    return 1;
}

// Закрываем текстдравы автосервиса
stock hideDraw_Autoservice(playerid)
{
    TextDrawHideForPlayer(playerid, TuningDraw[0]);
    TextDrawHideForPlayer(playerid, TuningDraw[1]);
    TextDrawHideForPlayer(playerid, TuningDraw[2]);
    TextDrawHideForPlayer(playerid, TuningDraw[3]);
    TextDrawHideForPlayer(playerid, TuningDraw[4]);
    TextDrawHideForPlayer(playerid, TuningDraw[5]);
    TextDrawHideForPlayer(playerid, TuningDraw[6]);
    TextDrawHideForPlayer(playerid, TuningDraw[7]);
    TextDrawHideForPlayer(playerid, TuningDraw[8]);
    TextDrawHideForPlayer(playerid, TuningDraw[9]);
    TextDrawHideForPlayer(playerid, TuningDraw[10]);
    TextDrawHideForPlayer(playerid, TuningDraw[12]);
    TextDrawHideForPlayer(playerid, TuningDraw[13]);
    TextDrawHideForPlayer(playerid, TuningDraw[14]);
    TextDrawHideForPlayer(playerid, TuningDraw[15]);
    TextDrawHideForPlayer(playerid, TuningDraw[16]);
    TextDrawHideForPlayer(playerid, TuningDraw[17]);
    TextDrawHideForPlayer(playerid, TuningDraw[18]);
    return 1;
}

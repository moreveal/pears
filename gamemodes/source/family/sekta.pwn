enum sektaInfo
{
    sektaTimer, // Таймер CNN
    sektaRiteStatus,// Статус обряда
}
new Sekta[MAX_FAMILY][sektaInfo];
new SektaMessage[1]; // Оповещание для фибов
new SektaCNN[2]; // Ведется ли эфир сейчас // 0 семья кто ведет 1 кто ведет
new SektaFind[1]; // Зона с финдом
new SektaActor[MAX_FAMILY]; // Актер у алтаря

stock ShowSektaMenu(playerid,family)
{
    DP[0][playerid] = family;
    new line[30],lines[90];
    format(line,sizeof(line),"Рейтинг влияния в штате"), strcat(lines,line);
    format(line,sizeof(line),"\nОбъявить сбор"), strcat(lines,line);
    format(line,sizeof(line),"\nПроведения обряда"), strcat(lines,line);
    ShowDialog(playerid,1472,DIALOG_STYLE_TABLIST,"{FF6347}Sekta Menu",lines,"Выбрать","Назад");
    return 1;
}

stock ShowSektaAltarMenu(playerid)
{
    new fam = DP[0][playerid];
    new line[40],lines[120];
    if(Sekta[fam][sektaRiteStatus] == 0) format(line,sizeof(line),"Начать проведение обряда"), strcat(lines,line);
    if(Sekta[fam][sektaRiteStatus] == 1) format(line,sizeof(line),"Закончить обряд"), strcat(lines,line);
    format(line,sizeof(line),"\nМетка к Алатарю"), strcat(lines,line);
    if(Sekta[fam][sektaRiteStatus] == 0 && FamilyInfo[fam][fsAltarStatus] > 0) format(line,sizeof(line),"\nАлтарь {66ff99}[ Установлен ]"), strcat(lines,line);
    else if(Sekta[fam][sektaRiteStatus] == 0 && FamilyInfo[fam][fsAltarStatus] == 0) format(line,sizeof(line),"\nАлтарь {FF6347}[ Не установлен ]"), strcat(lines,line);
    ShowDialog(playerid,1473,DIALOG_STYLE_TABLIST,"{FF6347}Sekta Menu",lines,"Выбрать","Назад");
    return 1;
}

stock RaitingSekta(playerid)
{
    new line[60],lines[4048];
    format(line,sizeof(line),"№.Название\tВлияние"), strcat(lines,line);
    for(new i; i < MAX_FAMILY; i++)
    {
        if(FamilyInfo[i][fType] != 3) continue;
        format(line,sizeof(line),"\n%d.%s\t{FF6347}%d", i+1,FamilyInfo[i][fName],SetRaitingSekta(i)), strcat(lines,line);
    }
    ShowDialog(playerid,11111,DIALOG_STYLE_TABLIST_HEADERS,"{FF6347}Sekta Menu",lines,"Выбрать","Назад");
    return 1;
}

stock RemoveMask(fam)
{
    Sekta[fam][sektaRiteStatus] = 0;
    FamilyInfo[fam][fsUnixRite] = gettime();
    FamilyInfo[fam][fInfluenceTemp] += 800;
    DestroyDynamicActor(SektaActor[fam]);
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 0) continue;
        if(PlayerInfo[i][pFamily] == fam)
        {
            RemovePlayerAttachedObject(i,3);
            RemovePlayerAttachedObject(i,4);
        }
    }
}
stock SetRaitingSekta(f)
{
    new raiting;
    for(new fb = 0; fb < 10; fb++)
	{
		if(FamilyInfo[f][fBiz][fb] == 0) continue;
        new b = FamilyInfo[f][fBiz][fb];
        if(BizType(b) >= 0 && BizType(b) <= 2 || BizType(b) >= 15 && BizType(b) <= 16 || BizType(b) == 19) raiting += 4;
        else raiting += 2;
	}
    raiting += FamilyInfo[f][fInfluence];
    raiting += FamilyInfo[f][fInfluenceTemp];
    return raiting;
}

stock CallBackRankPoint(frak)
{
    new point;
    if(frak == 1 || frak == 22 || frak == 11 || frak == 2 || frak == 4) point = 2;
    else if(frak == 2 || frak == 7) point = 3;
    else if(frak == 0) point = 0;
    else point = 3;
    return point;
}
stock SetRaitingSektaInFrak(playerid,frak,rank)
{
    new fam = PlayerInfo[playerid][pFamily];
    new lastrank = PlayerInfo[playerid][pLastRank];
    new lastfrak = PlayerInfo[playerid][pLastFrak];
    if(lastrank == rank && lastfrak == frak) return 0;
    PlayerInfo[playerid][pLastRank] = rank;
    PlayerInfo[playerid][pLastFrak] = frak;
    if(FamilyInfo[fam][fType] == 3)
    {
        new point,ritePoint;
        point = rank*CallBackRankPoint(frak);
        ritePoint = lastrank*CallBackRankPoint(lastfrak);
        if(ritePoint > point)
        {
            FamilyInfo[fam][fInfluence] -= ritePoint - point;
        }
        else if(ritePoint < point)
        {
            FamilyInfo[fam][fInfluence] += point - ritePoint;
        }
        SaveFamilySekta(fam);
    }
    mysql_save(playerid,9);
    return 1;
}
stock SektaCNNZapus()
{
    SektaCNN[0] = -1;
    SektaCNN[1] = -1;
    SektaMessage[0] = -1;
}
stock SektaCNNClose()
{
    FamilyInfo[SektaCNN[0]][fsUnixCNN] = gettime();
    FamilyInfo[SektaCNN[0]][fInfluenceTemp] += 600-Sekta[SektaCNN[0]][sektaTimer];
    SaveFamilySekta(SektaCNN[0]);
    SektaCNN[0] = -1;
    SektaCNN[1] = -1;
    SektaMessage[0] = -1;
    GangZoneDestroy(SektaFind[0]);
    SektaFind[0] = -1;
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 0) continue;
        if(PlayerInfo[i][pMember] == 2 || PlayerInfo[i][pFbi] > 0)
        {
            showGangZones(i);
        }
    }
    return 1;
}

stock SektaCNNStart()
{
    Sekta[SektaCNN[0]][sektaTimer]-=30;
    if(SektaFind[0] != -1) GangZoneDestroy(SektaFind[0]);
    new fam = SektaCNN[0];
    new playerid = SektaCNN[1];
    new Float:x,Float:y,Float:z;
    GetPlayerRealPos(playerid,x,y,z);
    new zone;
    if(Sekta[fam][sektaTimer] > 300)
    {
        zone = 1200;
        if(SektaMessage[0] == -1) SektaMessage[0] = 0;
    }
    else if(Sekta[fam][sektaTimer] < 300)
    {
        zone = 500;
        if(SektaMessage[0] == 1) SektaMessage[0] = 2;
    }
    new Float:rand_x = 5 + random(30), Float:rand_y = 5 + random(30);
    switch(random(4))
    {
      case 0: x += rand_x, y += rand_y;
      case 1: x -= rand_x, y -= rand_y;
      case 2: x += rand_x, y -= rand_y;
      case 3: x -= rand_x, y += rand_y;
    }
    SektaFind[0] = GangZoneCreate(x - zone, y - zone, x + zone, y + zone);
    return 1;
}

stock SektaKillAltar(fam)
{
    DestroyDynamicObject(SektaObject[fam]);
    for(new i; i < 6; i++)
    {
        FamilyInfo[fam][fsAltarPos][i] = 0.0;
    }
    SektaObject[fam] = 0;
    FamilyInfo[fam][fInfluenceTemp] -= 2000;
    FamilyInfo[fam][fsAltarStatus] = 0;
    SaveFamilySekta(fam);
    return 1;
}
stock SektaCNNUpdate(i)
{
    if(PlayerInfo[i][pMember] == 2 || PlayerInfo[i][pFbi] > 0)
    {
        hideGangZones(i);
        GangZoneShowForPlayer(i, SektaFind[0], 0xff0000AA);
        if(SektaMessage[0] == 0)
        {
            SektaMessage[0] = 1;
            SendClientMessage(i, COLOR_GREY, "[ Мысли ]: Кто-то из секты начал вести эфир его надо найти");
            SendClientMessage(i, COLOR_GREY, "[ Мысли ]: На карте отмечена зона откуда ведется эфир");
        }
        else if(SektaMessage[0] == 2)
        {
            SektaMessage[0] = 3;
            SendClientMessage(i, COLOR_GREY, "[ Мысли ]: Зона поиска откуда ведется эфир стала меньше, надо поторопиться!");
        }
    }
}

stock SektaEat(playerid,targetid)
{
    new atext[20];
    DeathEnd(targetid,0);
    switch(random(4))
    {
        case 0:
        {
            atext = "Сердце";
            ApplyAnimation(playerid,"FOOD","EAT_Pizza",4.1,0,0,0,0,0);
            EatPlayer(playerid, 40);
            PlayerInfo[playerid][pMechSkill] = 1000;
        }
        case 1:
        {
            atext = "Печень";
            ApplyAnimation(playerid,"FOOD","EAT_Pizza",4.1,0,0,0,0,0);
            EatPlayer(playerid, 40);
            PlayerInfo[playerid][pCap] = 100;
        }
        case 2:
        {
            atext = "Желудок";
            ApplyAnimation(playerid,"FOOD","EAT_Pizza",4.1,0,0,0,0,0);
            EatPlayer(playerid, -40);
        }
        case 3:
        {
            atext = "Легкие";
            ApplyAnimation(playerid,"FOOD","EAT_Pizza",4.1,0,0,0,0,0);
            EatPlayer(playerid, 40);
        }
    }
    PlayerInfo[playerid][pInfoload] = 0, UpdatePotreb(playerid);
}
CMD:gnews(playerid, const params[])
{
	new string[220];
	if(isamute(playerid) == 1) return 1;
	if(sscanf(params, "s[144]",params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Новости CNN [ /gnews Текст ]");
    new fam = PlayerInfo[playerid][pFamily];

    if(PlayerInfo[playerid][pTransmitterOff][9] == true) return ErrorMessage(playerid, "{FF6347}У вас выключен этот чат\n{cccccc}Y >> Меню >> Настройки Чата");
    if(FamilyInfo[fam][fsUnixCNN]+86400 > gettime())
    {
        new tyear, tmonth, tday, thour, tminute, tsecond;
	    stamp2datetime(FamilyInfo[fam][fsUnixCNN]+86400, tyear, tmonth, tday, thour, tminute, tsecond, 3);
        format(string, sizeof(string),"{ff6457} Лимит: 1 эфир в день. Следующий эфир станет доступен %02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute);
        return ErrorMessage(playerid,string);
    }

	if(PlayerInfo[playerid][pFamrank] >= FamilyInfo[fam][fRanks] - 1 && FamilyInfo[fam][fType] == 3)
	{
		new newcar = GetPlayerVehicleID(playerid);
		if(newcar >= cnncar[0] && newcar <= cnncar[1] || IsPlayerInRangeOfPoint(playerid,5.0,-1750.7061,801.5389,137.4583) || Cars[newcar] == 9)
		{
            if(AntiFloodText(playerid, params[0])) return 1;

            if(SektaCNN[0] != fam && SektaCNN[0] != -1) return ErrorMessage(playerid,"{FF6347}Какая-то секта уже ведет эфир!");
            else if(SektaCNN[0] == -1)
            {
                SektaCNN[0] = fam;
                SektaCNN[1] = playerid;
                Sekta[fam][sektaTimer] = 630;
                SuccessMessage(playerid,"{66ff99} Вы успешно начали вести эфир, вас уже ищут FBI у вас есть 10 минут");
                SektaCNNStart();
            }
			format(string, sizeof(string), "{FFFFFF}* CNN * Сектант: {AA8C00}%s *", params[0]);
			OOCNews(COLOR_GREY,string);
			if(PlayerInfo[playerid][pSoska]==0 && PlayerInfo[playerid][pLeader]==0)PlayerInfo[playerid][pWorked1]++;
		}
		else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не в Студии или Транспорте CNN");
	}
	else ErrorMessage(playerid, "{FF6347}Эфир секты может начинать только глава семьи или его заместитель");
 	return 1;
}

stock dialogCase_Sekta(playerid, dialogid, response, listitem)
{
	if(dialogid == 1472)
   	{
        new fam = DP[0][playerid];
   	    if(response)
        {
            if(listitem == 0)
            {
                RaitingSekta(playerid);
            }
            else if(listitem == 1)
            {
                if(GetPVarInt(playerid,"Boot") != 9999) return ErrorMessage(playerid,"{FF6347}Я в багажнике");
                if(PlayerInfo[playerid][pBkyrenie] >= 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чего, блин ?! Я не на земле");
                new Float:x,Float:y,Float:z;
                GetPlayerRealPos(playerid,x,y,z);
                foreach(Player,i)
                {
                    if(OnlineInfo[i][oLogged] == 0) continue;
                    if(PlayerInfo[i][pFamily] == fam)
                    {
                        CreateGps(i,x,y,z, 0, 0, 5.0);
                    }
                }
            }
            else if(listitem == 2)
            {
                ShowSektaAltarMenu(playerid);
            }
        }
        else cmd_fam(playerid);
    }
    else if(dialogid == 1473)
    {
        new fam = DP[0][playerid];
        if(response)
        {
            if(listitem == 0)
            {
                if((FamilyInfo[fam][fsAltarPos][0] == 0.0 && FamilyInfo[fam][fsAltarPos][1] == 0.0)) return ErrorMessage(playerid,"{FF6347}Вы должны установить все физичиские объекты!");
                new line[60],lines[120];
                if(Sekta[fam][sektaRiteStatus] == 0)
                {                
                    format(line,sizeof(line),"\nВы уверены что хотите начать обряд?"), strcat(lines,line);
                    format(line,sizeof(line),"\nВсе игроки должны быть под эффектом грибов"), strcat(lines,line);
                    ShowDialog(playerid,1474,DIALOG_STYLE_MSGBOX,"{FF6347}Sekta Menu",lines,"Да","Нет");
                }
                else
                {
                    format(line,sizeof(line),"\nВы уверены что хотите закончить обряд?"), strcat(lines,line);
                    ShowDialog(playerid,1475,DIALOG_STYLE_MSGBOX,"{FF6347}Sekta Menu",lines,"Да","Нет");
                }
            }
            if(listitem == 2)
            {
                new Float:f_pos[4];
                frontme(playerid, 2.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
                CreateEditPlayerObject(playerid, 26, 0, 0, 0, 19527,f_pos[0], f_pos[1], f_pos[2], 0.0, 0.0, 0.0);
            }
            if(listitem == 1)
            {
                CreateGps(playerid,FamilyInfo[fam][fsAltarPos][0],FamilyInfo[fam][fsAltarPos][1],FamilyInfo[fam][fsAltarPos][2], 0, 0, 5.0);
            }
        }
        else ShowSektaMenu(playerid,fam);
    }
    else if(dialogid == 1474)
    {
        new fam = DP[0][playerid];
        if(response)
        {
            if(FamilyInfo[fam][fsUnixRite]+86400 > gettime())
            {
                new tyear, tmonth, tday, thour, tminute, tsecond;
                stamp2datetime(FamilyInfo[fam][fsUnixRite]+86400, tyear, tmonth, tday, thour, tminute, tsecond, 3);
                new string[140];
                format(string, sizeof(string),"{ff6457} Лимит: 1 обряд в день. Следующий обряд станет доступен %02d.%02d.%d %02d:%02d", tday, tmonth, tyear, thour, tminute);
                return ErrorMessage(playerid,string);
            }
            if(Sekta[fam][sektaRiteStatus] == 1) return ErrorMessage(playerid,"{ff6347}Сейчас уже проходит обряд");
            new quan,quanaccept,memberrite[50],checkingPlayerObject = -1;
            new Float:X,Float:Y,Float:Z,Float:A,world,int;
            foreach(Player,i)
            {
                if(OnlineInfo[i][oLogged] == 0) continue;
                if(IsPlayerInRangeOfPoint(i,5.0,FamilyInfo[fam][fsAltarPos][0],FamilyInfo[fam][fsAltarPos][1],FamilyInfo[fam][fsAltarPos][2]) && PlayerInfo[i][pFamily] != fam && Stun[0][i])
                {
                    checkingPlayerObject = i;
                    GetPlayerRealPos(i,X,Y,Z);
                    GetPlayerFacingAngle(i, A);
                    world = GetPlayerVirtualWorld(i), int = GetPlayerInterior(i);
                }
                if(IsPlayerInRangeOfPoint(i,20.0,FamilyInfo[fam][fsAltarPos][0],FamilyInfo[fam][fsAltarPos][1],FamilyInfo[fam][fsAltarPos][2]) && PlayerInfo[i][pFamily] == fam)
                {
                   quan++;
                   if(quan >= 50)
                   {
                        ErrorMessage(playerid,"{ff6347} Слишком много участников для обряда");
                        break;
                   }
                   if(Effect[i] == 3) 
                   {
                        memberrite[quanaccept] = i+1;
                        quanaccept++;
                   }
                }
            }
            if(quan >= 50) return 1;
            if(checkingPlayerObject == -1) return ErrorMessage(playerid,"{ff6347}Рядом с алтарем нет связанной жертвы");
            if(quan == quanaccept)
            {
                for(new i;i < 50; i++)
                {
                    new selectplayerid = memberrite[i]-1;
                    if(selectplayerid == -1) continue;
                    if(IsPlayerInRangeOfPoint(selectplayerid,20.0,FamilyInfo[fam][fsAltarPos][0],FamilyInfo[fam][fsAltarPos][1],FamilyInfo[fam][fsAltarPos][2]) && PlayerInfo[selectplayerid][pFamily] == fam)
                    {
                        SetPlayerAttachedObject(selectplayerid, 3, 3461, 6, -0.079999, -0.008000, 0.315000, -172.200027, -158.500000, 0.000000, 0.344999, 0.379999, 0.424000, 0, 0); // Факел
                        if(PlayerInfo[selectplayerid][pFamrank] >= FamilyInfo[fam][fRanks]-1)SetPlayerAttachedObject(selectplayerid, 4, 6865, 2, 0.000000, 0.000000, 0.000000, 0.000000, 82.999984, -141.599960, 0.149999, 0.168999, 0.135999, 0, 0); // Маска Лидера
                        else SetPlayerAttachedObject(selectplayerid, 4, 11704, 2, 0.067000, 0.108000, -0.004999, 176.500030, 95.700019, -0.200000, 0.461000, 0.865000, 0.504000, 0, 0);
                    }
                }
                SektaActor[fam] = CreateDynamicActor(GetSkinModelOriginal(PlayerInfo[checkingPlayerObject][pModel]), X,Y,Z,A, true, 100.0, world, int, -1, 100.0, -1, 0);
                ApplyDynamicActorAnimation(SektaActor[fam],"CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
                DeathEnd(checkingPlayerObject,0);
                Sekta[fam][sektaRiteStatus] = 1;
            }
            else return ErrorMessage(playerid,"{ff6347} Не все участники секты находятся под эффектом грибов");
        }
        else ShowSektaAltarMenu(playerid);
    }
    else if(dialogid == 1475)
    {
        new fam = DP[0][playerid];
        if(response)
        {
            DestroyDynamicActor(SektaActor[fam]);
            RemoveMask(fam);
            SuccessMessage(playerid, "{99ff66} Обряд завершён, возьмите приготовленную таблетки у алтаря.");
            SetThrow(-1, 180, 180, 1, 1, 0, 0, 0, 0, 0, FamilyInfo[fam][fsAltarPos][0], FamilyInfo[fam][fsAltarPos][1]-2.066, FamilyInfo[fam][fsAltarPos][2]+0.674, 0.0, 0.0, 0.0, 600, 0, 0);
            SetThrow(-1, 198, 198, 1, 1, 0, 0, 0, 0, 0, FamilyInfo[fam][fsAltarPos][0], FamilyInfo[fam][fsAltarPos][1]-2.066, FamilyInfo[fam][fsAltarPos][2]+0.674, 0.0, 0.0, 0.0, 600, 0, 0);
        }
        else ShowSektaAltarMenu(playerid);
    }
    return 1;
}

stock SaveFamilySekta(idx)
{
    new string_mysql[500];
	format(string_mysql, sizeof(string_mysql), "UPDATE `pp_family` SET `influence`='%d',`influenceTemp`='%d',`unixcnn`='%d',`unixrite`='%d',`altarPosX`='%.2f',`altarPosY`='%.2f',`altarPosZ`='%.2f',`altarPosXR`='%.2f',`altarPosYR`='%.2f',`altarPosZR`='%.2f',\
	`unixAltar`='%d',`altarStatus`='%d' WHERE `id`='%d'",
	FamilyInfo[idx][fInfluence],FamilyInfo[idx][fInfluenceTemp],FamilyInfo[idx][fsUnixCNN],FamilyInfo[idx][fsUnixRite],FamilyInfo[idx][fsAltarPos][0],FamilyInfo[idx][fsAltarPos][1],FamilyInfo[idx][fsAltarPos][2],FamilyInfo[idx][fsAltarPos][3],FamilyInfo[idx][fsAltarPos][4],FamilyInfo[idx][fsAltarPos][5],
	FamilyInfo[idx][fsUnixAltar],FamilyInfo[idx][fsAltarStatus],idx); // 246 + 66 + 120 (432)
	query_empty(pearsq, string_mysql);
}
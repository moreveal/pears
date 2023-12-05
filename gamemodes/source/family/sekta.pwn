enum sektaInfo
{
    sektaTimer, // Таймер CNN
    Float:sektaPosAltar[6], // Позиция Тележки
}
new Sekta[MAX_FAMILY][sektaInfo];
new SektaObject[MAX_FAMILY];
new SektaCNN[2]; // Ведется ли эфир сейчас // 0 семья кто ведет 1 кто ведет

stock ShowSektaMenu(playerid,family)
{
    DP[0][playerid] = family;
    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"Рейтинг влияния в штате"), strcat(lines,line);
    format(line,sizeof(line),"\nОбъявить сбор"), strcat(lines,line);
    format(line,sizeof(line),"\nПроведения обряда"), strcat(lines,line);
    ShowDialog(playerid,1472,DIALOG_STYLE_TABLIST,"{FF6347}Sekta Menu",lines,"Выбрать","Назад");
    return 1;
}

stock ShowSektaAltarMenu(playerid)
{
    new fam = DP[0][Playerid];
    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"Начать проведение обряда"), strcat(lines,line);
    if(Sekta[fam][sektaPosAltar][0] == 0.0 && Sekta[fam][sektaPosAltar][1] == 0.0) format(line,sizeof(line),"\nАлтарь {FF6347}[ Не установлен ]"), strcat(lines,line);
    else if(Sekta[fam][sektaPosAltar][0] != 0.0 && Sekta[fam][sektaPosAltar][1] != 0.0)format(line,sizeof(line),"\nАлтарь {99ff66}[ Установлен ]"), strcat(lines,line);
    ShowDialog(playerid,1473,DIALOG_STYLE_TABLIST,"{FF6347}Sekta Menu",lines,"Выбрать","Назад");
    return 1;
}

stock RaitingSekta(playerid)
{
    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"№.Название\tВлияние"), strcat(lines,line);
    for(new i; i < MAX_FAMILY; i++)
    {
        if(FamilyInfo[i][fType] != 3) continue;
        format(line,sizeof(line),"\n%d.%s\t{FF6347}%d", i+1,FamilyInfo[i][fName],SetRaitingSekta(i)), strcat(lines,line);
    }
    ShowDialog(playerid,11111,DIALOG_STYLE_TABLIST_HEADERS,"{FF6347}Sekta Menu",lines,"Выбрать","Назад");
    return 1;
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
        FamilyInfo[fam][fUpdate] = 1;
    }
    mysql_save(playerid,9);
    return 1;
}
stock SektaCNNwork()
{
    new fam = SektaCNN[0];
    new playerid = SektaCNN[1];
    if(Sekta[fam][sektaTimer] > 600)
    {
        // всем фбрам опракинуть маркер на чела
    }
}

CMD:gnews(playerid, const params[])
{
	new string[144];
	if(isamute(playerid) == 1) return 1;
	if(sscanf(params, "s[144]",params[0])) return  SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Новости CNN [ /gnews Текст ]");
    new fam = PlayerInfo[playerid][pFamily];
    if(SektaCNN[0] != fam && SektaCNN[0] != -1) return ErrorMessage(playerid,"{FF6347}Какая-то секта уже ведет эфир!");
    else if(SektaCNN[0] == -1)
    {
        SektaCNN[0] = fam;
        Sekta[fam][sektaTimer] == 600;
        SuccessMessage(playerid,"{66ff99} Вы успешно начали вести эфир, вас уже ищут FBI у вас есть 10 минут");
        FamilyInfo[fam][fsUnixCNN] = gettime();
        FamilyInfo[fam][fUpdate] = 1;
    }
	if(PlayerInfo[playerid][pFamrank] >= 9 && FamilyInfo[fam][fType] == 3)
	{
		new newcar = GetPlayerVehicleID(playerid);
		if(newcar >= cnncar[0] && newcar <= cnncar[1] || IsPlayerInRangeOfPoint(playerid,5.0,-1750.7061,801.5389,137.4583) || Cars[newcar] == 9)
		{
			//=====[ Anti Flood ]=====
			if(checkflood(playerid, params[0]))
			{
				if(Acheck[playerid] >= 1)
				{
				 	SendClientMessage(playerid, COLOR_LIGHTRED, "Большое количество повторяющегося текста приводит к кровотечению из глаз");
					SendClientMessage(playerid, COLOR_LIGHTRED, "Пожалуйста... не флудите. Мы заботимся о вас [Code 0138]"), PlayerPlaySound(playerid,4203,0,0,0);
					Achtim[playerid] = 4;
					return 1;
		  		}
		  		else Acheck[playerid] ++;
		   	}
			else Acheck[playerid] = 0;
			iflood(playerid, params[0]);
			//========================
			format(string, sizeof(string), "{FFFFFF}* CNN * Сектант: {AA8C00}%s *", params[0]);
			OOCNews(COLOR_GREY,string);
			if(PlayerInfo[playerid][pSoska]==0 && PlayerInfo[playerid][pLeader]==0)PlayerInfo[playerid][pWorked1]++;
		}
		else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не в Студии или Транспорте CNN");
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Только для участников Секты");
 	return 1;
}

stock dialogCase_Sekta(playerid, dialogid, response, listitem,const inputtext[])
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
                if((Sekta[fam][sektaPosAltar][0] == 0.0 && Sekta[fam][sektaPosAltar][1] == 0.0)) return ErrorMessage(playerid,"{FF6347}Вы должны установить все физичиские объекты!");
                format(lines,sizeof(lines),""); // Очищаем Lines

                format(line,sizeof(line),"\nВы уверены что хотите начать обряд?"), strcat(lines,line);
                format(line,sizeof(line),"\nВсе игроки заморозятся на время, и будет заниматься выполнением обряда"), strcat(lines,line);
                ShowDialog(playerid,1474,DIALOG_STYLE_MSGBOX,"{FF6347}Sekta Menu",lines,"Да","Нет");
            }
            if(listitem == 1)
            {
                /*new moving;
                if(Sekta[fam][sektaPosAltar][0] == 0.0 && Sekta[fam][sektaPosAltar][1] == 0.0) moving = 0;
                else if(Sekta[fam][sektaPosAltar][0] != 0.0 && Sekta[fam][sektaPosAltar][1] != 0.0) moving = 1;
                DP[0][playerid] = moving;

                new Float:f_pos[4];
                frontme(playerid, 5.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
                if(moving == 0) CreateEditPlayerObject(playerid, 0, 0, 0, 0, 19527, f_pos[0], f_pos[1], f_pos[2], 0.0, 0.0, 0.0);
                else if(moving == 1)
                {
                    GoEditDynamicObject(playerid, 0, 1, 0, 0, SektaObject[fam], 0);
                }*/
                // ВЛАДИК ПОМАГИ
            }
        }
        else ShowSektaMenu(playerid,fam);
    }
    else if(dialogid == 1473)
    {
        new fam = DP[0][playerid];
        if(response)
        {
            foreach(Player,i)
            {
                if(OnlineInfo[i][oLogged] == 0) continue;
                if(IsPlayerInRangeOfPoint(i,20.0,Sekta[fam][sektaPosAltar][0],Sekta[fam][sektaPosAltar][1],Sekta[fam][sektaPosAltar][2]) || PlayerInfo[i][pFamily] == fam)
                {
                    // Нужно анимку всем ебануть на минуту, и тыры пыры, я чет проебался с этим.
                }
            }
        }
        else ShowSektaAltarMenu(playerid);
    }
    return 1;
}
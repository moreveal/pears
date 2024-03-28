
#define MAX_SPAWNDRAWCHOISE 13

new Text:SpawnChoiseDraw[MAX_SPAWNDRAWCHOISE];

/*
0 - Организация
1 - Точка выхода
2 - Family
3 - Division
4 - Home
5 - Room
6 - Family Home
7 - Rent Home
8 - Hotel
*/

stock SaveLastPlayerPosition(playerid)
{
    if(SetPosa[playerid] > 0 
        || MPGO[playerid] == 1 // На мероприятии
        || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING // В слежке (спеке)
        || OnlineInfo[playerid][oShowInterface] == 14 
        || OnlineInfo[playerid][oShowInterface] == 16 // Меню салонов транспорта
        || VehShopInfo[playerid][vsTest] == true // Тестдрайв
        || OnlineInfo[playerid][oShowInterface] == 18
        || gAutosalon[playerid] > 0 // В автосервисе
        || Fractia[playerid] > 0  // В выборе одежды
        || computerClubPlayerInfo[playerid][ccpiInGame] == true) // В комп клубе
    {
        PlayerInfo[playerid][pLastPos][0] = SpX[playerid];
        PlayerInfo[playerid][pLastPos][1] = SpY[playerid];
        PlayerInfo[playerid][pLastPos][2] = SpZ[playerid];
        PlayerInfo[playerid][pLastPos][3] = SpA[playerid];
        PlayerInfo[playerid][pLastWorld] = SpWorld[playerid];
        PlayerInfo[playerid][pLastInt] = SpInt[playerid];
    }
    else
    {
        new Float:pos[4];
        GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
        GetPlayerFacingAngle(playerid,pos[3]);

        if(!IsValidFloat(pos[0]) || !IsValidFloat(pos[1]) || !IsValidFloat(pos[2]) || !IsValidFloat(pos[3])) return false;

        PlayerInfo[playerid][pLastPos][0] = pos[0];
        PlayerInfo[playerid][pLastPos][1] = pos[1];
        PlayerInfo[playerid][pLastPos][2] = pos[2];
        PlayerInfo[playerid][pLastPos][3] = pos[3];

        // Если последняя точка в динамической зоне квеста и квест выполнен значит сохраняем вирт мир 0
        if((IsPlayerInDynamicArea(playerid, ZoneQuest1) || IsPlayerInDynamicArea(playerid, ZoneQuest2)) && QuestInfo[playerid][QuestBot])
        {
            PlayerInfo[playerid][pLastWorld] = 0;
        }
        else PlayerInfo[playerid][pLastWorld] = GetPlayerVirtualWorld(playerid);
        PlayerInfo[playerid][pLastInt] = GetPlayerInterior(playerid);
    }
    return 1;
}

stock CloseSpawnChoise(playerid)
{
    Login[4][playerid] = 0;
    OnlineInfo[playerid][oShowInterface] = 0;
    for(new i = 0; i < MAX_SPAWNDRAWCHOISE; i++) TextDrawHideForPlayer(playerid, SpawnChoiseDraw[i]);
    return 1;
}

stock GoSpawn(playerid)
{
    if(PlayerInfo[playerid][pTut] == 0) return GoGame(playerid); // Если игрок не завершил регистрацию

    if(PlayerInfo[playerid][pJailed] > 0 
        || PlayerInfo[playerid][pBkyrenie] >= 2 
        || DeathInfo[playerid][deathStatus] == true
        || PlayerInfo[playerid][pQuest][0] == 0) return GoGame(playerid); // Если игроку нельзя выбирать спавн

    HidePlayerDialog(playerid);
    Login[4][playerid] = 1;

    OnlineInfo[playerid][oShowInterface] = 17;
    TextDrawHideForPlayer(playerid, NameServerDraw[0]), TextDrawHideForPlayer(playerid, NameServerDraw[1]);
    for(new i = 0; i < MAX_SPAWNDRAWCHOISE; i++) TextDrawShowForPlayer(playerid, SpawnChoiseDraw[i]);
    SelectColorDraw(playerid);

    if(IsACristmas()) TextDrawHideForPlayer(playerid,ChristmasDraw[0]); // Выключаем нг текстдрав
    return 1;
}

stock SelectSpawnChoise(playerid, spawnId)
{
    PlayerInfo[playerid][pSelectspawn] = spawnId;
    OnlineInfo[playerid][oNoClick] = false;

    if(IsPlayerSyncModels(playerid)) PlayerPlaySound(playerid, 4400, 0,0,0);
    else PlayerPlaySound(playerid,17803,0,0,0);
    if(Login[4][playerid] == 1) GoGame(playerid); // Спавн при входе в игру
    else // Через команду /spawnchange
    {
		SuccessMessage(playerid, "{cccccc}Вы изменили свой {99ff66}спавн");
        CloseSpawnChoise(playerid);
        CancelSelectTextDraw(playerid);
        PlayerInfo[playerid][pSpawnchange] = spawnId;
        PlayerInfo[playerid][pSelectspawn] = spawnId;
        mysql_save(playerid, 29);
    }
    return 1;
}

stock ClickDraw_SpawnChoise(playerid, Text:clickedid)
{
    if(OnlineInfo[playerid][oNoClick]) return 1;

    PlayerPlaySound(playerid,17803,0,0,0);

    if(clickedid == SpawnChoiseDraw[0]) 
    {
        if(OnlineInfo[playerid][oLogged] == 1) return ErrorMessage(playerid, "{FF6347}Последнюю позицию можно выбрать только при входе на сервер");
        if(PlayerInfo[playerid][pLastPos][0] == 0.0 && PlayerInfo[playerid][pLastPos][1] == 0.0) return ErrorMessage(playerid, "{FF6347}У вашего персонажа нет последней, сохранённой позиции\n\n{cccccc}Вы всегда можете выбрать спавн в Отеле {ff9000}Жильё >> Отель");

        /*if(IsAGang(playerid))
        {
            new g = fraction(playerid);
            if(Kapt[g] > 0 && ZoneCapt)
            {
                if(IsPointInDynamicArea(ZoneCapt, PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2]))
                {
                    ErrorMessage(playerid, "{FF6347}Вы не можете сейчас выбрать последнюю точку\n{cccccc}Она находится на территории активного капта вашей банды");
                    return 1;
                }
            }
        }*/

        if(IsAMafia(playerid))
        {
            new g = fraction(playerid);
            if(MafGz[0][mStat] > 0 && MafGz[0][mZone] > 0
                && (MafGz[0][mNapad] == g || MafGz[0][mZashita] == g))
            {
                if(IsPointInDynamicArea(MafGz[0][mZone], PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2]))
                {
                    ErrorMessage(playerid, "{FF6347}Вы не можете сейчас выбрать последнюю точку\n{cccccc}Она находится на территории активной стрелы вашей мафии");
                    return 1;
                }
            }
        }

        SelectSpawnChoise(playerid, 1); // End Position
    }
    else if(clickedid == SpawnChoiseDraw[3]) // Organization
    {
        new g = fraction(playerid);
        new i = PlayerInfo[playerid][pDivision][0];
        if(g == 0) return ErrorMessage(playerid, "{FF6347}Ваш персонаж не стоит в организации\n\n{cccccc}Вы всегда можете выбрать спавн в Отеле {ff9000}Жильё >> Отель");
        if(i > 0) // Есть подфракция
        {
            OnlineInfo[playerid][oNoClick] = true;
            new line[100],lines[200];
			format(line,sizeof(line),"%s", frakName[g]), strcat(lines,line);
            format(line,sizeof(line),"\n{%s}%s", DivisionInfo[g - 1][i - 1][divColorHex], DivisionInfo[g - 1][i - 1][divName]), strcat(lines,line);
		    ShowDialog(playerid,502,DIALOG_STYLE_TABLIST,"{ff9000}Выбор спавна",lines,"Выбор","Отмена");
        }
        else SelectSpawnChoise(playerid, 8);
    }
    else if(clickedid == SpawnChoiseDraw[6]) // Home
    {
        OnlineInfo[playerid][oNoClick] = true;
        new line[100],lines[500];
    
        new quan;
        if(PlayerInfo[playerid][pDom])
        {
            List[quan][playerid] = 4; // Home
            ListParam[quan][playerid] = PlayerInfo[playerid][pDom];
            quan ++;
            format(line,sizeof(line),"{cccccc}Дом № {ff9000}%d\n", PlayerInfo[playerid][pDom]), strcat(lines,line);
        }
        if(PlayerInfo[playerid][pHouserent])
        {
            List[quan][playerid] = 7; // Rent Home
            ListParam[quan][playerid] = PlayerInfo[playerid][pHouserent];
            quan ++;
            format(line,sizeof(line),"{cccccc}Арендованный Дом № {ff9000}%d\n", PlayerInfo[playerid][pHouserent]), strcat(lines,line);
        }
        if(PlayerInfo[playerid][pFamily])
        {
            new fam = PlayerInfo[playerid][pFamily];
            if(FamilyInfo[fam][fDop5] && DomInfo[FamilyInfo[fam][fDop5]][dFam] == fam)
            {
                List[quan][playerid] = 6; // Family Home
                ListParam[quan][playerid] = FamilyInfo[fam][fDop5];
                quan ++;
                format(line,sizeof(line),"{cccccc}Семейный Дом № {ff9000}%d\n", FamilyInfo[fam][fDop5]), strcat(lines,line);
            }
        }
        if(PlayerInfo[playerid][pRoom])
        {
            List[quan][playerid] = 5;
            ListParam[quan][playerid] = PlayerInfo[playerid][pRoom];
            quan ++;
            format(line,sizeof(line),"{cccccc}Квартира № {ff9000}%d\n", PlayerInfo[playerid][pRoom]), strcat(lines,line);
        }
        if(PlayerInfo[playerid][pTrailer])
        {
            List[quan][playerid] = 9;
            ListParam[quan][playerid] = PlayerInfo[playerid][pTrailer] - 1;
            quan ++;
            format(line,sizeof(line),"{cccccc}Трейлер № {ff9000}%d\n", PlayerInfo[playerid][pTrailer]), strcat(lines,line);
        }

        List[quan][playerid] = 0;
        quan ++;
        if(PlayerInfo[playerid][pKomnata] != 9999 && PlayerInfo[playerid][pKomnata] >= 1)
      	{
            if(PlayerInfo[playerid][pKomnataCity] == 3) format(line,sizeof(line),"{cccccc}Отель {ff9000}Las Venturas\n"), strcat(lines,line);
            else format(line,sizeof(line),"{cccccc}Отель {ff9000}Los Santos\n"), strcat(lines,line);
        }
        else
        {
            if(PlayerInfo[playerid][pKomnataCity] == 3) format(line,sizeof(line),"{cccccc}Улица Отеля {ff9000}Las Venturas\n"), strcat(lines,line);
            else format(line,sizeof(line),"{cccccc}Улица Отеля {ff9000}Los Santos\n"), strcat(lines,line);
        }
        ShowDialog(playerid,503,DIALOG_STYLE_TABLIST,"{ff9000}Выбор спавна",lines,"Выбор","Отмена");
    }
    else if(clickedid == SpawnChoiseDraw[9]) // Family
    {
        if(PlayerInfo[playerid][pFamily] == 0) return ErrorMessage(playerid, "{FF6347}У вашего персонажа нет семьи\n\n{cccccc}Вы всегда можете выбрать спавн в Отеле {ff9000}Жильё >> Отель");
        new f = PlayerInfo[playerid][pFamily];
        if(FamilyInfo[f][fSost] == 0) return ErrorMessage(playerid, "{FF6347}Ошибка! Вашей семьи не существует\n\n{cccccc}Вы всегда можете выбрать спавн в Отеле {ff9000}Жильё >> Отель");
        if(FamilyInfo[f][fStatusSpawn] == 0) return ErrorMessage(playerid, "{FF6347}У вашей семьи нет своего спавна\n\n{cccccc}Вы всегда можете выбрать спавн в Отеле {ff9000}Жильё >> Отель");
		if(FamilyInfo[f][fSpawnX] == 0.0) return ErrorMessage(playerid, "{FF6347}У вашей семьи нет своего спавна\n\n{cccccc}Вы всегда можете выбрать спавн в Отеле {ff9000}Жильё >> Отель");

        SelectSpawnChoise(playerid, 2);
    }
    return 1;
}

stock dialogCase_SpawnChoise(playerid, dialogid, response, listitem)
{
    if(dialogid == 502)
    {
        OnlineInfo[playerid][oNoClick] = false;
        if(response)
        {
            if(listitem == 0) SelectSpawnChoise(playerid, 8);
            else if(listitem == 1) 
            {
                new g = fraction(playerid);
                new i = PlayerInfo[playerid][pDivision][0];

                if(DivisionInfo[g - 1][i - 1][divSpawnPos][0] == 0.0) return ErrorMessage(playerid, "{FF6347}В подфракции не установлен отдельный спавн");
                SelectSpawnChoise(playerid, 3);
            }
        }
    }
    if(dialogid == 503)
    {
        OnlineInfo[playerid][oNoClick] = false;
        if(response)
        {
            if(listitem < 0 || listitem > 4) return 1;

            new spawnId = List[listitem][playerid];
            new numSpawn = ListParam[listitem][playerid];

            if(spawnId == 4 || spawnId == 6 || spawnId == 7) // Dom
            {
                if(DomInfo[numSpawn][dArest] == 1) return ErrorMessage(playerid, "{FF6347}Этот дом арестован\n\n{cccccc}Если это ваш дом, оплатите налоги для снятия ареста");
            }
            else if(spawnId == 5) // Room
            {
                if(RoomInfo[numSpawn][rArest] == 1) return ErrorMessage(playerid, "{FF6347}Этот квартира арестована\n\n{cccccc}Если это ваша квартира, оплатите налоги для снятия ареста");
            }
            else if(spawnId == 9) // Trailer
            {
                if(trailerInfo[numSpawn][tActive] == false) return ErrorMessage(playerid, "{FF6347}Этот трейлер не установлен\n\n{cccccc}Вы всегда можете выбрать спавн в Отеле {ff9000}Жильё >> Отель");
            }
            
            SelectSpawnChoise(playerid, spawnId);
        }
    }
    return 1;
}

stock CreateDrawSpawnChoise()
{
    new Float:tempX, Float:tempY;
    new Float:sizeX, Float:sizeY;

    // End Position
    SpawnChoiseDraw[0] = TextDrawCreate(159.0, 155.0, "LD_SPAC:white");
    TextDrawLetterSize(SpawnChoiseDraw[0], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[0], 70.000000, 130.0); // 35
    TextDrawAlignment(SpawnChoiseDraw[0], 1);
    TextDrawColor(SpawnChoiseDraw[0], 421075440);
    TextDrawSetShadow(SpawnChoiseDraw[0], 0);
    TextDrawSetOutline(SpawnChoiseDraw[0], 0);
    TextDrawFont(SpawnChoiseDraw[0], 4);
    TextDrawSetSelectable(SpawnChoiseDraw[0], true);

    TextDrawGetPos(SpawnChoiseDraw[0], tempX, tempY);
    TextDrawGetTextSize(SpawnChoiseDraw[0], sizeX, sizeY);

    SpawnChoiseDraw[1] = TextDrawCreate((tempX + sizeX / 2) -  22.5, 185.0, "LD_SPAC:white");
    TextDrawBackgroundColor(SpawnChoiseDraw[1], 0);
    TextDrawLetterSize(SpawnChoiseDraw[1], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[1], 43.000000, 48.0);
    TextDrawAlignment(SpawnChoiseDraw[1], 1);
    TextDrawColor(SpawnChoiseDraw[1], -1);
    TextDrawUseBox(SpawnChoiseDraw[1], true);
    TextDrawBoxColor(SpawnChoiseDraw[1], 0);
    TextDrawSetShadow(SpawnChoiseDraw[1], 0);
    TextDrawSetOutline(SpawnChoiseDraw[1], 0);
    TextDrawFont(SpawnChoiseDraw[1], 5);
    TextDrawSetPreviewModel(SpawnChoiseDraw[1], 1277);
    TextDrawSetPreviewRot(SpawnChoiseDraw[1], 0.000000, 0.000000, 180.000000, 1.000000);

    SpawnChoiseDraw[2] = TextDrawCreate(tempX + sizeX / 2, 268.0, "ЊOC‡EѓHEE MECЏO");
    TextDrawLetterSize(SpawnChoiseDraw[2], 0.204666, 0.907259);
    TextDrawAlignment(SpawnChoiseDraw[2], 2);
    TextDrawColor(SpawnChoiseDraw[2], -1061109505);
    TextDrawSetShadow(SpawnChoiseDraw[2], 1);
    TextDrawSetOutline(SpawnChoiseDraw[2], 0);
    TextDrawBackgroundColor(SpawnChoiseDraw[2], 51);
    TextDrawFont(SpawnChoiseDraw[2], 1);
    TextDrawSetProportional(SpawnChoiseDraw[2], 1);

    // Organization
    SpawnChoiseDraw[3] = TextDrawCreate(243.0, 155.0, "LD_SPAC:white");
    TextDrawLetterSize(SpawnChoiseDraw[3], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[3], 70.000000, 130.0); // 35
    TextDrawAlignment(SpawnChoiseDraw[3], 1);
    TextDrawColor(SpawnChoiseDraw[3], 421075440);
    TextDrawSetShadow(SpawnChoiseDraw[3], 0);
    TextDrawSetOutline(SpawnChoiseDraw[3], 0);
    TextDrawFont(SpawnChoiseDraw[3], 4);
    TextDrawSetSelectable(SpawnChoiseDraw[3], true);

    TextDrawGetPos(SpawnChoiseDraw[3], tempX, tempY);
    TextDrawGetTextSize(SpawnChoiseDraw[3], sizeX, sizeY);

    SpawnChoiseDraw[4] = TextDrawCreate((tempX + sizeX / 2) -  22.5, 185.0, "LD_SPAC:white");
    TextDrawBackgroundColor(SpawnChoiseDraw[4], 0);
    TextDrawLetterSize(SpawnChoiseDraw[4], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[4], 43.000000, 48.0);
    TextDrawAlignment(SpawnChoiseDraw[4], 1);
    TextDrawColor(SpawnChoiseDraw[4], -1);
    TextDrawUseBox(SpawnChoiseDraw[4], true);
    TextDrawBoxColor(SpawnChoiseDraw[4], 0);
    TextDrawSetShadow(SpawnChoiseDraw[4], 0);
    TextDrawSetOutline(SpawnChoiseDraw[4], 0);
    TextDrawFont(SpawnChoiseDraw[4], 5);
    TextDrawSetPreviewModel(SpawnChoiseDraw[4], 1275);
    TextDrawSetPreviewRot(SpawnChoiseDraw[4], 0.000000, 0.000000, 180.000000, 1.000000);

    SpawnChoiseDraw[5] = TextDrawCreate(tempX + sizeX / 2, 268.0, "OP‚AH…3A‰…•");
    TextDrawLetterSize(SpawnChoiseDraw[5], 0.204666, 0.907259);
    TextDrawAlignment(SpawnChoiseDraw[5], 2);
    TextDrawColor(SpawnChoiseDraw[5], -1061109505);
    TextDrawSetShadow(SpawnChoiseDraw[5], 1);
    TextDrawSetOutline(SpawnChoiseDraw[5], 0);
    TextDrawBackgroundColor(SpawnChoiseDraw[5], 51);
    TextDrawFont(SpawnChoiseDraw[5], 1);
    TextDrawSetProportional(SpawnChoiseDraw[5], 1);

    // Home
    SpawnChoiseDraw[6] = TextDrawCreate(327.000000, 155.0, "LD_SPAC:white"); // Home
    TextDrawLetterSize(SpawnChoiseDraw[6], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[6], 70.000000, 130.0); // 35
    TextDrawAlignment(SpawnChoiseDraw[6], 1);
    TextDrawColor(SpawnChoiseDraw[6], 421075440);
    TextDrawSetShadow(SpawnChoiseDraw[6], 0);
    TextDrawSetOutline(SpawnChoiseDraw[6], 0);
    TextDrawFont(SpawnChoiseDraw[6], 4);
    TextDrawSetSelectable(SpawnChoiseDraw[6], true);

    TextDrawGetPos(SpawnChoiseDraw[6], tempX, tempY);
    TextDrawGetTextSize(SpawnChoiseDraw[6], sizeX, sizeY);

    SpawnChoiseDraw[7] = TextDrawCreate((tempX + sizeX / 2) -  22.5, 185.0, "LD_SPAC:white");
    TextDrawBackgroundColor(SpawnChoiseDraw[7], 0);
    TextDrawLetterSize(SpawnChoiseDraw[7], 1.1, 1.1);
    TextDrawTextSize(SpawnChoiseDraw[7], 43.000000, 48.0);
    TextDrawAlignment(SpawnChoiseDraw[7], 1);
    TextDrawColor(SpawnChoiseDraw[7], -1);
    TextDrawUseBox(SpawnChoiseDraw[7], true);
    TextDrawBoxColor(SpawnChoiseDraw[7], 0);
    TextDrawSetShadow(SpawnChoiseDraw[7], 0);
    TextDrawSetOutline(SpawnChoiseDraw[7], 0);
    TextDrawFont(SpawnChoiseDraw[7], 5);
    TextDrawSetPreviewModel(SpawnChoiseDraw[7], 1273);
    TextDrawSetPreviewRot(SpawnChoiseDraw[7], 0.000000, 0.000000, 180.000000, 1.000000);

    SpawnChoiseDraw[8] = TextDrawCreate(tempX + sizeX / 2, 268.0, "„…‡’E");
    TextDrawLetterSize(SpawnChoiseDraw[8], 0.204666, 0.907259);
    TextDrawAlignment(SpawnChoiseDraw[8], 2);
    TextDrawColor(SpawnChoiseDraw[8], -1061109505);
    TextDrawSetShadow(SpawnChoiseDraw[8], 1);
    TextDrawSetOutline(SpawnChoiseDraw[8], 0);
    TextDrawBackgroundColor(SpawnChoiseDraw[8], 51);
    TextDrawFont(SpawnChoiseDraw[8], 1);
    TextDrawSetProportional(SpawnChoiseDraw[8], 1);

    // Family
    SpawnChoiseDraw[9] = TextDrawCreate(411.0, 155.0, "LD_SPAC:white");
    TextDrawLetterSize(SpawnChoiseDraw[9], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[9], 70.000000, 130.0); // 35
    TextDrawAlignment(SpawnChoiseDraw[9], 1);
    TextDrawColor(SpawnChoiseDraw[9], 421075440);
    TextDrawSetShadow(SpawnChoiseDraw[9], 0);
    TextDrawSetOutline(SpawnChoiseDraw[9], 0);
    TextDrawFont(SpawnChoiseDraw[9], 4);
    TextDrawSetSelectable(SpawnChoiseDraw[9], true);

    TextDrawGetPos(SpawnChoiseDraw[9], tempX, tempY);
    TextDrawGetTextSize(SpawnChoiseDraw[9], sizeX, sizeY);

    SpawnChoiseDraw[10] = TextDrawCreate((tempX + sizeX / 2) -  22.5, 185.0, "LD_SPAC:white");
    TextDrawBackgroundColor(SpawnChoiseDraw[10], 0);
    TextDrawLetterSize(SpawnChoiseDraw[10], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[10], 43.000000, 48.0);
    TextDrawAlignment(SpawnChoiseDraw[10], 1);
    TextDrawColor(SpawnChoiseDraw[10], -1);
    TextDrawUseBox(SpawnChoiseDraw[10], true);
    TextDrawBoxColor(SpawnChoiseDraw[10], 0);
    TextDrawSetShadow(SpawnChoiseDraw[10], 0);
    TextDrawSetOutline(SpawnChoiseDraw[10], 0);
    TextDrawFont(SpawnChoiseDraw[10], 5);
    TextDrawSetPreviewModel(SpawnChoiseDraw[10], 1314);
    TextDrawSetPreviewRot(SpawnChoiseDraw[10], 0.000000, 0.000000, 180.000000, 1.000000);

    SpawnChoiseDraw[11] = TextDrawCreate(tempX + sizeX / 2, 268.0, "CEM’•");
    TextDrawLetterSize(SpawnChoiseDraw[11], 0.204666, 0.907259);
    TextDrawAlignment(SpawnChoiseDraw[11], 2);
    TextDrawColor(SpawnChoiseDraw[11], -1061109505);
    TextDrawSetShadow(SpawnChoiseDraw[11], 1);
    TextDrawSetOutline(SpawnChoiseDraw[11], 0);
    TextDrawBackgroundColor(SpawnChoiseDraw[11], 51);
    TextDrawFont(SpawnChoiseDraw[11], 1);
    TextDrawSetProportional(SpawnChoiseDraw[11], 1);

    SpawnChoiseDraw[12] = TextDrawCreate(320.0, 318.0, "‹‘ЂEP…ЏE CЊA‹H ‹AЋE‚O ЊEPCOHA„A");
    TextDrawLetterSize(SpawnChoiseDraw[12], 0.354000, 1.471407);
    TextDrawAlignment(SpawnChoiseDraw[12], 2);
    TextDrawColor(SpawnChoiseDraw[12], -1);
    TextDrawSetShadow(SpawnChoiseDraw[12], 1);
    TextDrawSetOutline(SpawnChoiseDraw[12], 0);
    TextDrawBackgroundColor(SpawnChoiseDraw[12], 51);
    TextDrawFont(SpawnChoiseDraw[12], 1);
    TextDrawSetProportional(SpawnChoiseDraw[12], 1);
    return 1;
}
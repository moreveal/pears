#define MAX_COURTS 100 // Максимальное количество заявок

enum courtsInfo
{
    courtsPlayerId, // playerid Создателя заявки
    courtsStatus, // Статус заявки
    courtsTakeUserid, // Ид судьи
    courtsClass // Статус стока
}
new CourtsInfo[MAX_COURTS][courtsInfo];

stock GoCourtsProcess(playerid,targetid)
{
    S_SetPlayerVirtualWorld(playerid,172,0);
    PPSetPlayerInterior(playerid,0);
    PPSetPlayerPos(playerid, -2776.8091,417.6989,12.6403);
    PPSetPlayerFacingAngle(playerid, 90.0);
    new slot = OnlineInfo[playerid][oCourtsID]-1;
    CourtsInfo[slot][courtsStatus] = 2;
    CourtsInfo[slot][courtsTakeUserid] = targetid;
    return 1;
}

stock CloseCourtsProcess(playerid)
{
    new slot = OnlineInfo[playerid][oCourtsID]-1;
    if(CourtsInfo[slot][courtsStatus] != 2) return 0;
    if(CourtsInfo[slot][courtsClass] == 0) // Отклоняем заявку
    {
        S_SetPlayerVirtualWorld(playerid,WORLD_PRISON_CELLS,INT_PRISON_CELLS);
        PPSetPlayerInterior(playerid,INT_PRISON_CELLS);
        PPSetPlayerPos(playerid, 1032.6429,2443.3469,10.8509);
        PPSetPlayerFacingAngle(playerid, 0.0);
        PlayerInfo[playerid][pCourtsStatus] = 2;
    }
    else if(CourtsInfo[slot][courtsClass] == 1) // Отпускаем по УДО
    {
        SuccessMessage(playerid,"{44ff99}Вас отпустили по УДО. Вы свободны");
    }
    else if(CourtsInfo[slot][courtsClass] == 2) // Отпускаем по УДО + залог
    {
        if(PlayerInfo[playerid][pMoney] <= PlayerInfo[playerid][pJailTime]*10)
        {
            ErrorMessage(CourtsInfo[slot][courtsTakeUserid],"{ff6347}У заключенного не хватает денег на руках для оплаты залога");
            return ErrorMessage(playerid,"{ff6347}У вас не достаточно денег на руках для оплаты выхода под залог");
        }
        else oGivePlayerMoney(playerid, -PlayerInfo[playerid][pJailTime]*10); // Забираем бабки равные Срокзаключения * 100
        SuccessMessage(playerid,"{44ff99}Вас отпустили по УДО и залог. Вы свободны");
    }
    else if(CourtsInfo[slot][courtsClass] == 3) // Сокращаем срок в половину за залог
    {
        if(PlayerInfo[playerid][pMoney] <= PlayerInfo[playerid][pJailTime]*10)
        {
            ErrorMessage(CourtsInfo[slot][courtsTakeUserid],"{ff6347}У заключенного не хватает денег на руках для оплаты залога");
            return ErrorMessage(playerid,"{ff6347}У вас не достаточно денег на руках для оплаты сокращения срока под залог");
        }
        else oGivePlayerMoney(playerid, -PlayerInfo[playerid][pJailTime]*10); // Забираем бабки равные Срокзаключения * 100
        S_SetPlayerVirtualWorld(playerid,WORLD_PRISON_CELLS,INT_PRISON_CELLS);
        PPSetPlayerInterior(playerid,INT_PRISON_CELLS);
        PPSetPlayerPos(playerid, 1032.6429,2443.3469,10.8509);
        PPSetPlayerFacingAngle(playerid, 0.0);
        PlayerInfo[playerid][pJailTime]= PlayerInfo[playerid][pJailTime]/2;
        PlayerInfo[playerid][pCourtsStatus] = 2;
        SuccessMessage(playerid,"{44ff99}Вам сократили срок в половину за залог.Вы возвращены в тюрьму");
    }
    else if(CourtsInfo[slot][courtsClass] == 4) // Отпускаем по УДО + Отработка
    {
        PlayerInfo[playerid][pCourtsDeposit] = PlayerInfo[playerid][pJailTime]*10;
        SuccessMessage(playerid,"{44ff99}Вас отпустили по УДО и назначали исправительные работы. Вы обязаны их отработать.\n\nВ случае не отработки работ в ближайшее время, вас снова могут посадить в тюрьму
{684F7D}Отрабаотать нужно на работе у Клининговой Компании
        
{684F7D}Посмотреть сумму отработки можно в БАНК ОНЛАЙН");
    }
    if(CourtsInfo[slot][courtsClass] == 4 || CourtsInfo[slot][courtsClass] == 2 || CourtsInfo[slot][courtsClass] == 1)
    {
        PlayerInfo[playerid][pCourtsStatus] = 0;
        PPSetPlayerPos(playerid, -2780.8091,417.6989,12.6403);
        PPSetPlayerFacingAngle(playerid, 90.0);
        PlayerInfo[playerid][pHodka] ++;
        PlayerInfo[playerid][pJailed] = 0;PlayerInfo[playerid][pJailTime] = 0;
        PlayerInfo[playerid][pRab] = 0;
        ClearAllWantedPlayer(playerid);
        TempGive(playerid);
        GameTextForPlayer(playerid, RusToGame("~w~Вы ~g~Свободны"), 5000, 3);
        SetPlayerToTeamColor(playerid);
        GF_OnPlayerUpdate(playerid);
    }
    GiveUnit(CourtsInfo[slot][courtsTakeUserid], 13);
    DeleteOrderToCourts(CourtsInfo[slot][courtsPlayerId]);
    return 1;
}

stock CourtsList(playerid)
{
    new line[100],lines[4048];
    format(line,sizeof(line),"№ Человек\tВремя заключения\tУровень Преступности\tСтатус"), strcat(lines,line);
    new quan,timemake[20],targetid;
    for(new z = 0; z < MAX_COURTS; z++) 
    {
        targetid = CourtsInfo[z][courtsPlayerId];
        timemake = fine_time(PlayerInfo[targetid][pJailTime]);
        if(PlayerInfo[targetid][pJailTime] > 600 && CourtsInfo[z][courtsStatus] == 1 && !(GetPVarInt(targetid,"afksystem") >= 3))
        {
            format(line,sizeof(line),"\n%d. %s\t%s\t%d\tВ ожидание", quan+1, rpplayername(targetid),timemake,PlayerInfo[targetid][pCrimes]), strcat(lines,line);
        }
        else if(PlayerInfo[targetid][pJailTime] > 600 && CourtsInfo[z][courtsStatus] == 2 && !(GetPVarInt(targetid,"afksystem") >= 3))
        {
            format(line,sizeof(line),"\n%d. %s\t%s\t%d\tВ процессе рассмотрения", quan+1, rpplayername(targetid),timemake,PlayerInfo[targetid][pCrimes]), strcat(lines,line);
        }
        else if(PlayerInfo[targetid][pJailTime] > 600 && CourtsInfo[z][courtsStatus] == 3 && !(GetPVarInt(targetid,"afksystem") >= 3))
        {
            format(line,sizeof(line),"\n%d. %s\t%s\t%d\tРассмотрено", quan+1, rpplayername(targetid),timemake,PlayerInfo[targetid][pCrimes]), strcat(lines,line);
        }
        else
        {
            continue;
        }
        List[z][playerid] = quan;
        quan++;
    }
    if(quan == 0) return ErrorMessage(playerid,"{FF6347}В данный момент нет заявок в суд");
    else ShowDialog(playerid,1496,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список заявок в суд",lines,"Выбрать","Выход");
    return 1;
}

stock CreateNewOrderToCourts(playerid, bool:message = true)
{
    if(OnlineInfo[playerid][oCourtsID] > 0 && message == true) return ErrorMessage(playerid,"{ff6347}У вас уже есть заявка в суд, ожидайте вызова в суд!");
    if(!(PlayerInfo[playerid][pJailTime] > 0 && PlayerInfo[playerid][pJailed] == 1)) return 0;
    new slot = -1;
    for(new i; i < MAX_COURTS; i++)
    {
        if(CourtsInfo[i][courtsStatus] == 0)
        {
            slot = i;
            break;
        }
    }
    if(slot == -1)
    {
        if(message == true) ErrorMessage(playerid,"{ff6347}В данный момоент максимальное количество заявок в суд");
        return 1;
    }
    CourtsInfo[slot][courtsStatus] = 1;
    PlayerInfo[playerid][pCourtsStatus] = 1;
    CourtsInfo[slot][courtsPlayerId] = playerid;
    OnlineInfo[playerid][oCourtsID] = slot+1;
    if(message == true) SuccessMessage(playerid,"{44ff99}Вы успешно отправили заявку в суд для рассмотрения дела");
    return 1;
}

stock DeleteOrderToCourts(playerid)
{
    if(OnlineInfo[playerid][oCourtsID] == 0) return 1;
    new slot = OnlineInfo[playerid][oCourtsID]-1;
    OnlineInfo[playerid][oCourtsID] = 0;
    CourtsInfo[slot][courtsStatus] = 0;
    CourtsInfo[slot][courtsPlayerId] = 0;
    return 1;
}

stock dialogCase_CourtsSystem(playerid, dialogid, response, listitem)
{
    if(dialogid == 1496)
    {
        if(response)
        {
            if(listitem < 0 || listitem > MAX_COURTS) return ErrorMessage(playerid,"{ff6347}Выбрана не правильная строка.");
            new listselect = List[listitem][playerid];
            DP[4][playerid] = listselect;
            new string[100];
            if(CourtsInfo[listselect][courtsStatus] == 3)
            {
                format(string,sizeof(string),"Дело: %s. Заявку принял: %s.\nСтатус: Рассмотрено",rpplayername(CourtsInfo[listselect][courtsPlayerId]),rpplayername(CourtsInfo[listselect][courtsTakeUserid]));
                ShowDialog(playerid,1497,DIALOG_STYLE_MSGBOX,"Информация о деле",string,"Закрыть","");
            }
            if(CourtsInfo[listselect][courtsStatus] == 2)
            {
                new line[110],lines[660];
                format(line,sizeof(line),"{ff9000}Действие\t{cccccc}Мера наказания"), strcat(lines,line);
                format(line,sizeof(line),"\n{ff6347}Отказать в заявке\t{cccccc}[Вернет в тюрьму]"), strcat(lines,line);
                format(line,sizeof(line),"\n{ff9000}Предоставить УДО\t{cccccc}[Выпустить заключенного]"), strcat(lines,line);
                format(line,sizeof(line),"\n{ff9000}Предоставить УДО под залог\t{cccccc}[Выпустить заключенного и оплатить залог]"), strcat(lines,line);
                format(line,sizeof(line),"\n{ff9000}Сокращение срока под залог\t{cccccc}[Уменьшить срок в половину и оплатить залог]"), strcat(lines,line);
                format(line,sizeof(line),"\n{ff9000}Предоставить УДО и исправительные работы\t{cccccc}[Выпустит и установит кол.во денег для отработки]"), strcat(lines,line);
                ShowDialog(playerid,1500,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Тюнинг",lines,"Выбор","Отмена");
            }
            if(CourtsInfo[listselect][courtsStatus] == 1)
            {
                format(string,sizeof(string),"Дело: %s. Статус: Ожидание\n\nВы хотите предложить рассмотреть его дело?",rpplayername(CourtsInfo[listselect][courtsPlayerId]));
                ShowDialog(playerid,1498,DIALOG_STYLE_MSGBOX,"Информация о деле",string,"Принять","Назад");
            }
            return 1;
        }
        else return pc_cmd_goverment(playerid);
    }
    if(dialogid == 1497)
    {
        if(response) return CourtsList(playerid);
        else return 1;
    }
    if(dialogid == 1498)
    {
        if(response)
        {
            new listselect = DP[4][playerid];
            new targetid = CourtsInfo[listselect][courtsPlayerId];
            DP[1][targetid] = playerid;
            if(GetPVarInt(targetid,"afksystem") >= 3) 
            {
                ErrorText(playerid,"{ff6347}Игрок в афк, попробуйте чуть позже, или выберите другую заявку");
                return CourtsList(playerid);
            }
            SuccessMessage(playerid,"{44ff99}Вы отправили заявку на рассмотрения дела Заключенного");
            new str[600];
            format(str,sizeof(str),"{cccccc}Судья %s, вызывает вас на рассмотрения дела\
                \n\n{684F7D}Что это такое?\
                {cccccc}- Во время рассмотрения дела вам могут уменьшить срок заключения.\
                {cccccc}- Либо заменить его на исправительные работы, или оплатить на месте.\
                {cccccc}сумму для выхода под залог.\n\
                {ff6347}Хотите что бы ваше дело рассмотрели?",rpplayername(playerid));
            ShowDialog(targetid,1499,DIALOG_STYLE_MSGBOX,"Суд",str,"Да","Нет");
        }
        else return 1;
    }
    if(dialogid == 1499)
    {
        if(response)
        {
            return GoCourtsProcess(playerid,DP[1][playerid]);
        }
        else
        {
            DeleteOrderToCourts(playerid);
            PlayerInfo[playerid][pCourtsStatus] = 0;
            SendClientMessage(DP[1][playerid],COLOR_GREY,"Заключенный %s отказался от рассмотрения дела",rpplayername(playerid));
            return 1;
        }
    }
    if(dialogid == 1500)
    {
        if(response)
        {
            new slot = DP[4][playerid];
            if(slot < 0 || slot >= MAX_COURTS) return false;
            if(CourtsInfo[slot][courtsStatus] != 2) return 0;
            CourtsInfo[slot][courtsClass] = listitem;
            return CloseCourtsProcess(CourtsInfo[slot][courtsPlayerId]);
        }
        return true;
    }
    return 1;
}
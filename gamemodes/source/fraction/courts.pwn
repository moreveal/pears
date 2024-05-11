#define MAX_COURTS 100 // Максимальное количество заявок

enum courtsInfo
{
    courtsPlayerId, // playerid Создателя заявки
    courtsStatus, // Статус заявки
    courtsTakeUserid, // Ид судьи
    courtsClass, // Статус стока
    courtsDeposit // Денег для отработки
}
new CourtsInfo[MAX_COURTS][courtsInfo];

CMD:sud(playerid)
{
    return CourtsList(playerid);
}

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

stock GoCloseProcess(playerid)
{
    new slot = OnlineInfo[playerid][oCourtsID]-1;
    if(CourtsInfo[slot][courtsStatus] == 1) // Отклоняем заявку
    {
        S_SetPlayerVirtualWorld(playerid,WORLD_PRISON_CELLS,INT_PRISON_CELLS);
        PPSetPlayerInterior(playerid,INT_PRISON_CELLS);
        PPSetPlayerPos(playerid, 1032.6429,2443.3469,10.8509);
        PPSetPlayerFacingAngle(playerid, 0.0);
        PlayerInfo[playerid][pCourtsStatus] = 2;
    }
    else if(CourtsInfo[slot][courtsStatus] == 1) // Отпускаем по УДО / залог
    {
        PPSetPlayerPos(playerid, -2780.8091,417.6989,12.6403);
        PPSetPlayerFacingAngle(playerid, 90.0);
        PlayerInfo[playerid][pCourtsStatus] = 0;
    }
    else if(CourtsInfo[slot][courtsStatus] == 1) // Отпускаем по УДО + Отработка
    {
        PPSetPlayerPos(playerid, -2780.8091,417.6989,12.6403);
        PPSetPlayerFacingAngle(playerid, 90.0);
        PlayerInfo[playerid][pCourtsStatus] = 0;
        PlayerInfo[playerid][pCourtsDeposit] = CourtsInfo[slot][courtsDeposit];
    }
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

stock CreateNewOrderToCourts(playerid)
{
    if(OnlineInfo[playerid][oCourtsID] > 0) return ErrorMessage(playerid,"{ff6347}У вас уже есть заявка в суд, ожидайте вызова в суд!");
    new slot = -1;
    for(new i; i < MAX_COURTS; i++)
    {
        if(CourtsInfo[i][courtsStatus] == 0)
        {
            slot = i;
            break;
        }
    }
    if(slot == -1) return ErrorMessage(playerid,"{ff6347}В данный момоент максимальное количество заявок в суд");
    CourtsInfo[slot][courtsStatus] = 1;
    PlayerInfo[playerid][pCourtsStatus] = 1;
    CourtsInfo[slot][courtsPlayerId] = playerid;
    OnlineInfo[playerid][oCourtsID] = slot+1;
    return 1;
}

stock DeleteOrderToCourts(playerid)
{
    new slot = OnlineInfo[playerid][oCourtsID]-1;
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
                new line[90],lines[360];
                format(line,sizeof(line),"{ff9000}Действие\t{cccccc}производное"), strcat(lines,line);
                format(line,sizeof(line),"\n{ff9000}Предоставить УДО\t{cccccc}[Выпустит заключенного]"), strcat(lines,line);
                format(line,sizeof(line),"\n{ff9000}Предоставить УДО под залог\t{cccccc}[Выпустит заключенного после оплаты]"), strcat(lines,line);
                format(line,sizeof(line),"\n{ff9000}Сокращение срока под залог\t{cccccc}[ПУК]"), strcat(lines,line);
                ShowDialog(playerid,11111,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Тюнинг",lines,"Выбор","Отмена");
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
            Moiplayer[targetid] = playerid;
            if(GetPVarInt(targetid,"afksystem") >= 3) 
            {
                ErrorText(playerid,"{ff6347}Игрок в афк, попробуйте чуть позже, или выберите другую заявку");
                return CourtsList(playerid);
            }
            SuccessMessage(playerid,"{44ff99}Вы отправили заявку на рассмотрения дела Заключенного");
            new str[600];
            format(str,sizeof(str),"{cccccc}Судья %s, вызывает вас на рассмотрения дела\n\n
            {684F7D}Что это такое?\n
            {cccccc}- Во время рассмотрения дела вам могут уменьшить срок заключения.\n
            {cccccc}- Либо заменить его на исправительные работы, или оплатить на месте.\n
            {cccccc}сумму для выхода под залог.\n\n
            {ff6347}Хотите что бы ваше дело рассмотрели?
            ",rpplayername(playerid));
            ShowDialog(targetid,1499,DIALOG_STYLE_MSGBOX,"Суд",str,"Да","Нет");
        }
        else return 1;
    }
    if(dialogid == 1498)
    {
        if(response)
        {
            return GoCourtsProcess(playerid,Moiplayer[playerid]);
        }
        else
        {
            DeleteOrderToCourts(playerid);
            PlayerInfo[playerid][pCourtsStatus] = 0;
            SendClientMessage(Moiplayer[playerid],COLOR_GREY,"Заключенный %s отказался от рассмотрения дела",rpplayername(playerid));
            return 1;
        }
    }
    return 1;
}
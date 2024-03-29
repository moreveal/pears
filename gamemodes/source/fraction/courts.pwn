#define MAX_COURTS 100 // Максимальное количество заявок

enum courtsInfo
{
    courtsPlayerId, // playerid Создателя заявки
    courtsStatus, // Статус заявки
    courtsUserid, // проверка статуса
    courtsTakeName, // Имя судьи
    courtsTakeUserid, // Ид судьи
    courtsReason, // Причина
}
new CourtsInfo[MAX_COURTS][courtsInfo];


stock CourtsList(playerid)
{
    new line[100],lines[4048];
    format(line,sizeof(line),"№ Человек\tВремя заключения\tУровень Преступности\tСтатус"), strcat(lines,line);
    new quan,timemake[20],targetid;
    for(new z = 0; z < MAX_MAKE; z++) 
    {
        targetid = CourtsInfo[z][courtsPlayerId];
        if(PlayerInfo[targetid][pJailTime] > 600 && CourtsInfo[z][courtsStatus] == 0 && !(GetPVarInt(targetid,"afksystem") >= 3))
        {
            timemake = fine_time(PlayerInfo[targetid][pJailTime]);
            format(line,sizeof(line),"\n%d. %s\t%s\t%d\tВ ожидание", quan+1, rpplayername(targetid),timemake,PlayerInfo[targetid][pCrimes]), strcat(lines,line);
        }
        else if(PlayerInfo[targetid][pJailTime] > 600 && CourtsInfo[z][courtsStatus] > 0 && !(GetPVarInt(targetid,"afksystem") >= 3))
        {
            timemake = fine_time(PlayerInfo[targetid][pJailTime]);
            format(line,sizeof(line),"\n%d. %s\t%s\t%d\tРасмотренно", quan+1, rpplayername(targetid),timemake,PlayerInfo[targetid][pCrimes]), strcat(lines,line);
        }
        else
        {
            continue;
        }
        List[z][playerid] = quan;
        quan++;
    }
    if(quan == 0) return ErrorMessage(playerid,"{FF6347}В данный момент нет вызовов");
    else ShowDialog(playerid,1496,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список вызовов",lines,"Выбрать","Выход");
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
            if(CourtsInfo[listselect][courtsStatus] > 0)
            {
                format(string,sizeof(string),"Заявку принял: %s.\nИтог заявки:%s\nПричина:%s");
                ShowDialog(playerid,1497,DIALOG_STYLE_MSGBOX,"Информация о деле",string,"Закрыть","");
            }
            if(CourtsInfo[listselect][courtsStatus] == 0)
            {
                format(string,sizeof(string),"Дело: %s. Статус: Ожидание\n\nВы хотите предложить рассмотреть его дело?");
                ShowDialog(playerid,1479,DIALOG_STYLE_MSGBOX,"Информация о деле",string,"Принять","Назад");
            }
        }
        else return cmd_goverment(playerid);
    }
    if(dialogid == 1496)
    {
        if(response) return CourtsList(playerid);
    }
    return 1;
}
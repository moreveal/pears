#define MAX_PATROOL 50 // Максимальное количество патрульных

enum plInfo
{
    plGlav, // playerid Создателя патруля
    plStatus, // Статус[патрулирует, на вызове]
    plCoop[3], // Участники
}
new PatroolInfo[MAX_PATROOL][plInfo];

stock CreatePatrool(playerid, p0, p1, p2)
{
    new findslot = -1, findPlayer[3];
    for(new z = 0; z < MAX_PATROOL; z++) 
    {
        if(PatroolInfo[z][plGlav] == -1)
        {
            findslot = z;
            break;
        }
    }
    if(findslot == -1) return ErrorMessage(playerid,"{FF6347}В данный момент 50 патрульных машин");

    PlayerInfo[playerid][patroolID] = findslot;
    PatroolInfo[findslot][plGlav] = playerid;
    PatroolInfo[findslot][plStatus] = 0;

    findPlayer[0] = p0;
    findPlayer[1] = p1;
    findPlayer[2] = p2;

    new g;
    for(new i = 0; i < 3; i ++)
    {
        if(findPlayer[i] >= 0)
        {
            g = fraction(findPlayer[i]);
            if(g == 1 || g == 11 || g == 21)
            {
                PatroolInfo[findslot][plCoop][i] = findPlayer[i];
                PlayerInfo[findPlayer[i]][patroolID] = findslot;
                format(store,sizeof(store),"[ Мысли ]: Я вступил в патруль под руководством %s",PlayerInfo[playerid][pName]);
                SendClientMessage(findPlayer[i],COLOR_GREY,store);
            }
        }
        else PatroolInfo[findslot][plCoop][i] = -1;
    }
    return SuccessMessage(playerid,"{99ff66}Вы создали патруль");
}

stock ClosePatrool(playerid, stat)
{
    new findslot = PlayerInfo[playerid][patroolID];
    if(findslot == -1) return 0;

    if(PatroolInfo[findslot][plGlav] != playerid)
    {
        for(new i = 0; i < 3; i ++)
        {
            if(PatroolInfo[findslot][plCoop][i] == playerid)
            {
                PatroolInfo[findslot][plCoop][i] = -1;
                break;
            }
        }
        PlayerInfo[playerid][patroolID] = -1;
        if(stat == 0) ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы покинули патруль","*","");
        else if(stat == 1) ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Глава патруля исключил вас из участия в патруле","*","");
        return 1;
    }
    else
    {
        ShowDialog(PatroolInfo[findslot][plGlav],1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы распустили патруль","*","");
    }

    PlayerInfo[PatroolInfo[findslot][plGlav]][patroolID] = -1;
    PatroolInfo[findslot][plGlav] = -1;
    PatroolInfo[findslot][plStatus] = 0;

    for(new i = 0; i < 3; i ++)
    {
        if(PatroolInfo[findslot][plCoop][i] >= 0)
        {
            if(IsOnline(PatroolInfo[findslot][plCoop][i]))
            {
                PlayerInfo[PatroolInfo[findslot][plCoop][i]][patroolID] = -1;
                format(store,sizeof(store),"{ffcc66}Глава патруля {FF6347}%s {ffcc66}распустил патруль",PlayerInfo[playerid][pName]);
                ShowDialog(PatroolInfo[findslot][plCoop][i],1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",store,"*","");

                format(store,sizeof(store),"[ Мысли ]: Глава патруля %s распустил патруль",PlayerInfo[playerid][pName]);
                SendClientMessage(PatroolInfo[findslot][plCoop][i],COLOR_GREY,store);
            }
            PatroolInfo[findslot][plCoop][i] = -1;
        }
    }
    return 1;
}

CMD:createpatrool(playerid, const params[])
{
	if(PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pMember] == 11
	|| PlayerInfo[playerid][pMember] == 21 || PlayerInfo[playerid][pMember] == 22)
	{
		if(!sscanf(params, "s[144]s[144]s[144]", params[0], params[1], params[2]))
        {
            new giveplayerid0 = ReturnUser(params[0]);
            new giveplayerid1 = ReturnUser(params[1]);
            new giveplayerid2 = ReturnUser(params[2]);
            if(!IsOnline(giveplayerid0) || !IsOnline(giveplayerid1) || !IsOnline(giveplayerid2)) return ErrorMessage(playerid, "{FF6347}Один из игроков не в сети");

            if(!ProxDetectorS(10.0, playerid, giveplayerid0) 
                || !ProxDetectorS(10.0, playerid, giveplayerid1) 
                || !ProxDetectorS(10.0, playerid, giveplayerid2)) return ErrorMessage(playerid, "{FF6347}Один из игроков далеко от вас [ Не больше 10 метров ]");
            if(giveplayerid0 == playerid || giveplayerid1 == playerid || giveplayerid2 == playerid) return ErrorMessage(playerid, "{FF6347}Вы не можете пригласить себя в патруль");
            if(giveplayerid0 == giveplayerid1 || giveplayerid0 == giveplayerid2 || giveplayerid1 == giveplayerid2) return ErrorMessage(playerid, "{FF6347}Вы используете одинаковые id игроков");
	
            CreatePatrool(playerid,giveplayerid0,giveplayerid1,giveplayerid2);
        }
        else if(!sscanf(params, "s[144]s[144]", params[0], params[1]))
        {
            new giveplayerid0 = ReturnUser(params[0]);
            new giveplayerid1 = ReturnUser(params[1]);
            if(!IsOnline(giveplayerid0) || !IsOnline(giveplayerid1)) return ErrorMessage(playerid, "{FF6347}Один из игроков не в сети");

            if(!ProxDetectorS(10.0, playerid, giveplayerid0) 
                || !ProxDetectorS(10.0, playerid, giveplayerid1)) return ErrorMessage(playerid, "{FF6347}Один из игроков далеко от вас [ Не больше 10 метров ]");
            if(giveplayerid0 == playerid || giveplayerid1 == playerid) return ErrorMessage(playerid, "{FF6347}Вы не можете пригласить себя в патруль");
            if(giveplayerid0 == giveplayerid1) return ErrorMessage(playerid, "{FF6347}Вы используете одинаковые id игроков");
            
            CreatePatrool(playerid,giveplayerid0,giveplayerid1,-1);
        }
        else if(!sscanf(params, "s[144]", params[0]))
        {
            new giveplayerid0 = ReturnUser(params[0]);
            if(!IsOnline(giveplayerid0)) return ErrorMessage(playerid, "{FF6347}Игрок не в сети");
            
            if(!ProxDetectorS(10.0, playerid, giveplayerid0)) return ErrorMessage(playerid, "{FF6347}Игрок далеко от вас [ Не больше 10 метров ]");

            if(giveplayerid0 == playerid) return ErrorMessage(playerid, "{FF6347}Вы не можете пригласить себя в патруль");

            CreatePatrool(playerid,giveplayerid0,-1,-1);
        }
        else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Создание патруля {ffcc00}[ /patrool ID ID ID]");
	}
	else ErrorMessage(playerid, "{FF6347}Вы не можете создать патруль");
	return 1;
}

CMD:invitepatrool(playerid, const params[])
{
	if(PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pMember] == 11
	|| PlayerInfo[playerid][pMember] == 21 || PlayerInfo[playerid][pMember] == 22)
	{
        new findslot = PlayerInfo[playerid][patroolID];
        if(findslot == -1) return ErrorMessage(playerid, "{FF6347}Ошибка! У вас нет активного патруля");
        if(PatroolInfo[findslot][plGlav] != playerid) return ErrorMessage(playerid, "{FF6347}Вы не глава патруля");

        if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Пригласить в патруль [ /invitepatrool ID ]");
        new giveplayerid = ReturnUser(params[0]);
        if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрок не в сети");
        if(!ProxDetectorS(10.0, playerid, giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрок далеко от вас [ Не больше 10 метров ]");

        new freeSlotP = -1, yesPlayer;
        for(new i = 0; i < 3; i++)
        {
            if(PatroolInfo[findslot][plCoop][i] != -1 && PatroolInfo[findslot][plCoop][i] == giveplayerid)
            {
                yesPlayer = 1;
                break;
            }
        }
        if(yesPlayer) return ErrorMessage(playerid, "{FF6347}Этот игрок уже в вашем патруле");

        for(new i = 0; i < 3; i++)
        {
            if(PatroolInfo[findslot][plCoop][i] == -1)
            {
                freeSlotP = i;
                break;
            }
        }
        if(freeSlotP == -1) return ErrorMessage(playerid, "{FF6347}Ошибка! В вашем патруле нет свободных мест");


        new g = fraction(giveplayerid);
        if(g == 1 || g == 11 || g == 21 || g == 22)
        {
            PatroolInfo[findslot][plCoop][freeSlotP] = giveplayerid;
            PlayerInfo[giveplayerid][patroolID] = findslot;
            format(store,sizeof(store),"[ Мысли ]: %s пригласил вас в свой патруль", PlayerInfo[playerid][pName]);
            SendClientMessage(giveplayerid,COLOR_GREY,store);
            format(store,sizeof(store),"{99ff66}%s {ffcc66}пригласил вас в свой патруль",PlayerInfo[giveplayerid][pName]);
            ShowDialog(giveplayerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",store,"*","");

            format(store,sizeof(store),"{ffcc66}Вы пригласили {99ff66}%s {ffcc66}в свой патруль",PlayerInfo[giveplayerid][pName]);
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",store,"*","");
        }
        else ErrorMessage(playerid, "{FF6347}Вы можете пригласить в патруль только сотрудника правоохранительных органов");
	}
	else ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
	return 1;
}

CMD:patrool(playerid)
{
	if(PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pMember] == 11
	|| PlayerInfo[playerid][pMember] == 21 || PlayerInfo[playerid][pMember] == 22)
	{
        SettingPatrool(playerid);
    }
    else ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    return 1;
}

stock SettingPatrool(playerid)
{
    new findslot = PlayerInfo[playerid][patroolID];
    format(lines,sizeof(lines),""); // Очищаем Lines
    if(findslot == -1)
    {
        format(line,sizeof(line),"{cccccc}Нет активного патруля \t"), strcat(lines,line);
        format(line,sizeof(line),"\n{99ff66}Создать Патруль \t"), strcat(lines,line);
    }
    else
    {
        format(line,sizeof(line),"{cccccc}Глава Патруля: {ff9000}%s \t", PlayerInfo[PatroolInfo[findslot][plGlav]][pName]), strcat(lines,line);
        if(PatroolInfo[findslot][plGlav] == playerid) format(line,sizeof(line),"\n{cccccc}Распустить Патруль \t"), strcat(lines,line);
        else format(line,sizeof(line),"\n{cccccc}Покинуть Патруль \t"), strcat(lines,line);

        for(new i = 0; i < 3; i++)
        {
            if(PatroolInfo[findslot][plCoop][i] == -1)
            {
                format(line,sizeof(line),"\n{cccccc}Участник %d: нет \t{99ff66}Пригласить", i + 1), strcat(lines,line);
            }
            else
            {
                format(line,sizeof(line),"\n{cccccc}Участник %d: %s \t{FF6347}Исключить", i + 1, PlayerInfo[PatroolInfo[findslot][plCoop][i]][pName]), strcat(lines,line);
            }
        }
    }
    ShowDialog(playerid,802,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Патруль",lines,"Выбрать","Выход");
    return 1;
}

stock PatroolList(playerid)
{
    format(lines,sizeof(lines),""); // Очищаем Lines
    format(line,sizeof(line),"№ Глава\tУчастников\tРайон\tФракция"), strcat(lines,line);
    new quan, targetid,findraiontolist,kol;
    for(new z = 0; z < MAX_PATROOL; z++) 
    {
        if(PatroolInfo[z][plGlav] != -1)
        {
            targetid = PatroolInfo[z][plGlav];
            new g = fraction(targetid);
            findraiontolist = FindRaion(targetid);
            for(new i = 0; i < 3; i++)
            {
                if(PatroolInfo[z][plCoop][i] != -1) kol++;
            }
            format(line,sizeof(line),"\n%d. %s\t%d\t%s\t%s", quan+1, rpplayername(targetid),kol,gSAZones[findraiontolist][zName],fraklastName[g]), strcat(lines,line);
            quan++;
        }
    }
    if(quan == 0) return ErrorMessage(playerid,"{FF6347}В данный момент нет патрульных машин");
    else ShowDialog(playerid,11111,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Список патрульных машин",lines,"Выбрать","Выход");
    return 1;
}
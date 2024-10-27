#define MAX_LOBBY_PLAYER 10

enum LOBBYINFO
{
	lobbyLeader, // PlayerID главного в лобби
    lobbySatellite[MAX_LOBBY_PLAYER], // PlayerID участников лобби.
    lobbyStatus, // Статус лобби(в какой игре они задействованы)
    lobbyParam // Параметр
}
new LobbyInfo[MAX_REALPLAYERS][LOBBYINFO];

CMD:mylobby(playerid)
{
    if(LobbyInfo[playerid][lobbyLeader] == -1 && OnlineInfo[playerid][oLobby] == 0) LobbyCreate(playerid);
    new lobby;
    if(LobbyInfo[playerid][lobbyLeader] == -1) lobby = OnlineInfo[playerid][oLobby]-1;
    else lobby = playerid;
    if(LobbyInfo[lobby][lobbyStatus] > 0) return ErrorMessage(playerid,"{ff6347}Нельзя редактировать лобби когда оно задействовано в игре!");
    new lines[660], line[60];
    format(line,sizeof(line),"{ff9000}Лидер: {cccccc}%s\n", rpplayername(lobby)), strcat(lines,line);
    for(new i; i < MAX_LOBBY_PLAYER; i++)
    {
        if(LobbyInfo[lobby][lobbySatellite][i] != -1) format(line,sizeof(line),"{ff9000}%d.{cccccc} %s\n",i+1,rpplayername(LobbyInfo[lobby][lobbySatellite][i])), strcat(lines,line);
        else format(line,sizeof(line),"{ff9000}%d.{cccccc} Пусто\n",i+1), strcat(lines,line);
    }
    if(LobbyInfo[lobby][lobbyLeader] == playerid) format(line,sizeof(line),"{FF6347}Распустить Лобби"), strcat(lines,line);
    else format(line,sizeof(line),"{FF6347}Покинуть Лобби"), strcat(lines,line);
	ShowDialog(playerid,LOBBY_LIST,DIALOG_STYLE_TABLIST_HEADERS, "Лобби", lines, "Принять", "Отмена");
    return 1;
}

stock LobbyLoad()
{
    for(new i; i < MAX_REALPLAYERS; i++)
    {
        LobbyInfo[i][lobbyLeader] = -1;
        for(new p; p < MAX_LOBBY_PLAYER; p++)
        {
            if(LobbyInfo[i][lobbySatellite][p] != -1) LobbyInfo[i][lobbySatellite][p] = -1;
        }
    }
    return 1;
}

stock LobbyCreate(playerid)
{
    if(LobbyInfo[playerid][lobbyLeader] == -1)
    {
        LobbyInfo[playerid][lobbyLeader] = playerid;
        LobbyInfo[playerid][lobbySatellite][0] = playerid;
    }
    return 1;
}

stock LobbyInvite(playerid, targetid)
{
    new bool:result = false;
    for(new i, i < MAX_LOBBY_PLAYER; i++)
    {
        if(LobbyInfo[playerid][lobbySatellite][i] != -1) continue;
        else 
        {
            LobbyInfo[playerid][lobbySatellite][i] = targetid; OnlineInfo[targetid][oLobby] = playerid+1, result = true;
            break;
        }
    }
    if(!result) ErrorMessage(playerid,"{ff6347}К сожалению у вас заняты все ваши слоты в лобби. [ /mylobby ]");
    return 1;
}

stock LeaveLobby(playerid, type)
{
    if(OnlineInfo[playerid][oLobby] == 0) return 0;
    new lobby = OnlineInfo[playerid][oLobby]-1;
    for(new i; i < MAX_LOBBY_PLAYER; i++)
    {
        if(LobbyInfo[lobby][lobbySatellite][i] != playerid) continue;
        else
        {
            LobbyInfo[lobby][lobbySatellite][i] = -1;
            OnlineInfo[playerid][oLobby] = 0;
            break;
        }
    }
    if(type) 
    {
        SuccessMessage(playerid, "{44ff99}Я успешно покинул лобби");
        SendClientMessage(LobbyInfo[lobby][lobbyLeader],COLOR_GREY,"[ Мысли ] Игрок %s покинул мое лобби",rpplayername(playerid));
    }
    return 1;
}

stock LobbyDestroy(playerid,type)
{
    LobbyInfo[playerid][lobbyLeader] = -1;
    LobbyInfo[playerid][lobbyStatus] = 0;
    LobbyInfo[playerid][lobbyParam] = 0;
    for(new i; i < MAX_LOBBY_PLAYER; i++)
    {
        if(LobbyInfo[playerid][lobbySatellite][i] != -1)
        {
            if(!type) SendClientMessage(LobbyInfo[playerid][lobbySatellite][i], COLOR_GREY, "[ Мысли ]: Лидер лобби {ff9000} %s {cccccc}вышел из игры, лобби было распущенно.", rpplayername(playerid));
            else SendClientMessage(LobbyInfo[playerid][lobbySatellite][i], COLOR_GREY, "[ Мысли ]: Лидер лобби {ff9000} %s {cccccc}распутил лобби.", rpplayername(playerid));
            OnlineInfo[LobbyInfo[playerid][lobbySatellite][i]][oLobby] = 0;
            LobbyInfo[playerid][lobbySatellite][i] = -1;
        }
    }
    return 1;
}

stock dialogCase_Lobby(playerid, dialogid, response, listitem,const inputtext[])
{
    switch (e_DialogId: dialogid) {
        case LOBBY_LIST: {
            if(!response) return 0;
            new slot = listitem, lobby;
            DP[0][playerid] = slot;
            if(LobbyInfo[playerid][lobbyLeader] == -1 && OnlineInfo[playerid][oLobby] != 0) lobby = OnlineInfo[playerid][oLobby]-1;
            else lobby = playerid;
            if(slot >= MAX_LOBBY_PLAYER && LobbyInfo[lobby][lobbyLeader] == playerid) return LobbyDestroy(playerid, 1);
            else if(slot >= MAX_LOBBY_PLAYER) return LeaveLobby(playerid,1);
            if(LobbyInfo[lobby][lobbyLeader] != playerid) return SendClientLongMessage(playerid, COLOR_GREY, "[ Мысли ] Я не лидер лобби и не могу им управлять"), pc_cmd_mylobby(playerid);
            if(listitem == 0) return 0;
            if(LobbyInfo[lobby][lobbySatellite][listitem] == -1)
            {
                return ShowDialog(playerid,LOBBY_INVITE,DIALOG_STYLE_INPUT, "{ff9000}Приглашение в лобби", "{cccccc}Введите НикНейм или ID игрока для приглашение его в лобби", "Принять", "Отмена");
            }
            else
            {
                new line[100];
                format(line,sizeof(line),"Вы уверены что хотите исключить из лобби %s[%d]",rpplayername(LobbyInfo[lobby][lobbySatellite][listitem]),LobbyInfo[lobby][lobbySatellite][listitem]);
                return ShowDialog(playerid,LOBBY_UNINVITE,DIALOG_STYLE_MSGBOX, "Исключение из лобби",line, "Выгнать", "Отмена");
            }
        }
        case LOBBY_INVITE: {
            if(!response) return 0;
            new line[100];
            new giveplayerid = ReturnUser(inputtext),bool:result;
	    	if(!IsOnline(giveplayerid)) return ErrorText(playerid, "[ Мысли ]: Игрока нет в сети"), pc_cmd_mylobby(playerid);
	    	if(playerid == giveplayerid) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Зачем я буду приглашать себя?"), pc_cmd_mylobby(playerid);
	    	if(!ProxDetectorS(5.0, playerid,giveplayerid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я слишком далеко.."), pc_cmd_mylobby(playerid);
            for(new i; i < MAX_LOBBY_PLAYER; i++)
            {
                if(LobbyInfo[playerid][lobbySatellite][i] != giveplayerid) continue;
                result = true;
                break;
            }
            if(result) return ErrorText(playerid, "[ Мысли ]: Он уже в моем лобби"), pc_cmd_mylobby(playerid); 
            DP[0][giveplayerid] = playerid;
            format(line, sizeof(line), "{ffcc66}%s{FFFFFF}, приглашает вас в свое лобби\n\n{FFFFFF}Вы согласны?", PlayerInfo[playerid][pName]);
            ShowDialog(giveplayerid,LOBBY_ACCEPTINVITE,DIALOG_STYLE_MSGBOX,"Приглашение",line,"Да","Нет");
        }
        case LOBBY_ACCEPTINVITE: {
            if(!response) return 0;
            new lobby = DP[0][playerid], bool:result;
            if(LobbyInfo[lobby][lobbyLeader] == -1) return ErrorMessage(playerid,"{ff6347}Лобби было распущено");
            for(new i; i < MAX_LOBBY_PLAYER; i++)
            {
                if(LobbyInfo[lobby][lobbySatellite][i] != -1) continue;
                LobbyInfo[lobby][lobbySatellite][i] = playerid;
                OnlineInfo[playerid][oLobby] = lobby+1;
                result = true;
                break;
            }
            if(!result) return ErrorMessage(playerid,"{ff6347}Все слоты в лобби заняты");
            SendClientMessage(playerid,COLOR_GREY,"[ Мысли ] Я принял заявку в лобби от игрока %s", rpplayername(lobby));
            SendClientMessage(lobby,COLOR_GREY,"[ Мысли ] %s принял заявку в лобби", rpplayername(playerid));
        }
        case LOBBY_UNINVITE: {
            if(!response) return 0;
            new slot = DP[0][playerid];
            new target = LobbyInfo[playerid][lobbySatellite][slot];
            SendClientMessage(playerid,COLOR_GREY,"[ Мысли ] Я исключил из своего лобби игрока %s", rpplayername(target));
            SendClientMessage(target,COLOR_GREY,"[ Мысли ] %s исключил вас из своего лобби", rpplayername(playerid));
            LeaveLobby(target,0);
        }
        case LOBBY_ACCEPTHALLOWEEN: {
            if(!response) return 0;
            if(PlayerInfo[playerid][pHalloweenQuestUnix] < gettime()) HalloweenSetPosition(playerid);
            else return SendClientMessage(playerid,COLOR_GREY,"[ Мысли ] Время для битвы еще не пришло. Битва станет доступа через: %s!", fine_time(PlayerInfo[playerid][pHalloweenQuestUnix] - gettime()));
        }
    }
    return true;
}
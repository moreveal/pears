
#define MAX_NEAR_PLAYERS_IN_SHOWER 10

new soapObject;
new Text3D:soapLabel;

CMD:checklook(playerid, const params[]) // VREMENNO
{
    if(server != 0) return 1;
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Узнать на кого смотрит игрок [ /checklook ID ]");
    if(!IsOnline(params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Его нет..");
    new playerTarget = GetPlayerCameraTargetPlayer(params[0]);

    new string[90];
    if(playerTarget == INVALID_PLAYER_ID)
    {
        format(string, sizeof(string), "[ Мысли ]: %s[%d] ни на кого не смотрит", PlayerInfo[params[0]][pName], params[0]);
        SendClientMessage(playerid, COLOR_GREY, string);
    }
    else
    {
        format(string, sizeof(string), "[ Мысли ]: %s[%d] смотрит на %s[%d]", PlayerInfo[params[0]][pName], params[0], PlayerInfo[playerTarget][pName], playerTarget);
        SendClientMessage(playerid, COLOR_GREY, string);
    }
    return 1;
}

stock PrisonShowerSoap(playerid) // Роняем мыло
{
    if(soapObject) return 1;
    if(IsPlayerInSquare(playerid, 1020.423889, 2445.421142, 1028.551879, 2455.094238) && GetPlayerVirtualWorld(playerid) == WORLD_PRISON_LAUNDY && GetPlayerInterior(playerid) == INT_PRISON_LAUNDY)
    {
        new fallSoap = random(2);
        if(fallSoap == 1) // Роняем мыло
        {
            new string[90];
            format(string, sizeof(string), "[ Мысли ]: Упс.. Я уронил%s мыло. Может поднять? [ ALT ]", gender(playerid));
            SendClientMessage(playerid, COLOR_GREY, string);
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Упс! Вы уронили мыло. Рискнёте поднять? [ ALT ]","*","");
            PlayerPlaySound(playerid, 6801, 0,0,0);

            new Float:pos[4];
            GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
            GetPlayerFacingAngle(playerid, pos[3]);

            new Float:cor_z;
            object_correct_z(19874, cor_z);
            soapObject = CreateDynamicObject(19874, pos[0], pos[1], pos[2] - 1.0 + cor_z, 0.0, 0.0, pos[3], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 50.0, 50.0);
            soapLabel = CreateDynamic3DTextLabel("{0088ff}Мыло {ffffff}[ ALT - поднять ]",0xA9C4E4FF,pos[0], pos[1], pos[2] - 1.0 + cor_z,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

            Streamer_Update(playerid);
        }
    }
    return 1;
}

stock PickupSoap(playerid) // Подбираем мыло
{
    if(!soapObject) return 0;

    new Float:object_pos[3];
    GetDynamicObjectPos(soapObject, object_pos[0], object_pos[1], object_pos[2]);

    if(IsPlayerInRangeOfPoint(playerid, 1.5, object_pos[0], object_pos[1], object_pos[2]))
    {
        DestroyDynamicObject(soapObject);
        soapObject = 0;
        DestroyDynamic3DTextLabel(soapLabel);

        new string[60];
        format(string, sizeof(string), "поднял%s мыло с пола", gender(playerid));
        SetPlayerChatBubble(playerid,string,COLOR_PURPLE,20.0,3000);
        ApplyAnimation(playerid,"CARRY","liftup",2.0,0,1,1,0,0);
        PlayerPlaySound(playerid, 5601, 0,0,0);

        HeLooksAtHowIPicksUpTheSoap(playerid);
        return 1;
    }
    return 0;
}

new TextShowerChatMan[][] =
{
    "и резко отвёл взгляд", 
    "и облизнулся", 
    "и покраснел", 
    "и прикрылся",
    "и положил руки себе на пах"
};
new TextShowerChatWoman[][] =
{
    "и резко отвела взгляд", 
    "и облизнулась", 
    "и покраснела", 
    "и прикрылась",
    "и положила руки себе на пах"
};

stock GenderTextShower(playerid, textId)
{
    new text[22];
    if(PlayerInfo[playerid][pSex] == 1) format(text, sizeof(text), "%s", TextShowerChatMan[textId]);
    else format(text, sizeof(text), "%s", TextShowerChatWoman[textId]);
    return text;
}

stock HeLooksAtHowIPicksUpTheSoap(playerid)
{
    new watchPlayers[MAX_NEAR_PLAYERS_IN_SHOWER], nearPlayers[MAX_NEAR_PLAYERS_IN_SHOWER], quanAll, quanWatch, quanNear;
    foreach(Player,i)
	{
        if(i == playerid) continue;
        if(OnlineInfo[i][oLogged] == 0) continue;
        if(GetPlayerState(i) != PLAYER_STATE_ONFOOT) continue;
        if(GetPlayerVirtualWorld(i) == WORLD_PRISON_LAUNDY && GetPlayerInterior(i) == INT_PRISON_LAUNDY) // Prison Laundy
        {
            if(IsPlayerInSquare(i, 1020.423889, 2445.421142, 1028.551879, 2455.094238)) // Нашли всех, кто тоже в душе
            {
                new playerTarget = GetPlayerCameraTargetPlayer(i);
                if(playerTarget == playerid && GetPVarInt(i,"afksystem") <= 3) watchPlayers[quanWatch] = i + 1, quanWatch ++; // Смотрит на меня
                else nearPlayers[quanNear] = i + 1, quanNear ++; // Не смотрит
                quanAll ++;
                if(quanAll >= MAX_NEAR_PLAYERS_IN_SHOWER) break;
            }
        }
    }

    new string[180];
    if(quanAll == 0)
    {
        format(string, sizeof(string), "[ Мысли ]: Я поднял%s мыло. Фух.. хорошо что рядом никого не было", gender(playerid));
        SendClientMessage(playerid, COLOR_GREY, string);
        ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Вы подняли мыло и вам повезло. Рядом никого не было","*","");
    }
    else
    {
        if(quanWatch > 0) // Есть те, кто смотрели+
        {
            new watchSlot = random(quanWatch);
            new giveplayerid = watchPlayers[watchSlot] - 1;
            new randText = random(5);

            // Мысли
            format(string, sizeof(string), "[ Мысли ]: Я поднял%s мыло. %s посмотрел%s на меня %s", gender(playerid), rpplayername(giveplayerid), gender(giveplayerid), GenderTextShower(giveplayerid, randText));
            SendClientMessage(playerid, COLOR_GREY, string);

            // Диалог
            new line[90],lines[360];
            format(line,sizeof(line),"{ffcc66}Вы наклонились и подняли мыло с пола"), strcat(lines,line);
            format(line,sizeof(line),"\n{ffcc66}Рядом стоял%s %s", gender(giveplayerid), rpplayername(giveplayerid)), strcat(lines,line);
            format(line,sizeof(line),"\n{ffcc66}%s посмотрел%s на вас %s", rpplayername(giveplayerid), gender(giveplayerid), GenderTextShower(giveplayerid, randText)), strcat(lines,line);
            format(line,sizeof(line),"\n\n{cccccc}Осторожнее... Всякое может произойти в тюрьме"), strcat(lines,line);
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");

            // Bubble
            format(string, sizeof(string), "посмотрел%s на %s %s", gender(giveplayerid), rpplayername(playerid), GenderTextShower(giveplayerid, randText));
            SetPlayerChatBubble(giveplayerid,string,COLOR_PURPLE,20.0,5000);

            //Prox
            format(string, sizeof(string), "* %s посмотрел%s на %s %s", rpplayername(giveplayerid), gender(giveplayerid), rpplayername(playerid), GenderTextShower(giveplayerid, randText));
		    ProxDetectorScream(20.0, giveplayerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

            if(PlayerInfo[playerid][pAchieve][126] == 0) AchievePlayer(playerid, 126, 1);
        }
        else if(quanWatch == 0 && quanNear > 0) // Никто не смотрел, но есть те кто был рядом
        {
            new nearSlot = random(quanNear);
            new giveplayerid = nearPlayers[nearSlot] - 1;

            // Мысли
            format(string, sizeof(string), "[ Мысли ]: Я поднял%s мыло. %s был%s занят%s своими делами и не стал%s на меня смотреть", gender(playerid), rpplayername(giveplayerid), gender(giveplayerid), gender(giveplayerid), gender(giveplayerid));
            SendClientMessage(playerid, COLOR_GREY, string);

            // Диалог
            new line[90],lines[360];
            format(line,sizeof(line),"{ffcc66}Вы наклонились и подняли мыло с пола"), strcat(lines,line);
            format(line,sizeof(line),"\n{ffcc66}Рядом стоял%s %s", gender(giveplayerid), rpplayername(giveplayerid)), strcat(lines,line);
            format(line,sizeof(line),"\n{ffcc66}%s был%s занят%s своими делами и не стал%s на вас смотреть", rpplayername(giveplayerid), gender(giveplayerid), gender(giveplayerid), gender(giveplayerid)), strcat(lines,line);
            format(line,sizeof(line),"\n\n{cccccc}Вам повезло... А может быть нет?"), strcat(lines,line);
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",lines,"*","");
        }
    }
    return 1;
}
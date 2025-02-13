
#define COLOR_ZOMBIE_GAME 0x5c7057FF
#define COLOR_PLAYER_ZOMBIE_GAME 0xa6d8b3FF

new bool:PlayerZombieGame[MAX_REALPLAYERS];
new bool:PlayerIsZombie[MAX_REALPLAYERS];
new ZombieGameStatus;

CMD:zombie(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 4) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    if(ZombieGameStatus == 0) StartZombie(playerid);
    else CloseZombie();
    return true;
}

stock ZombieGameDamage(playerid, damagedid, weaponid)
{
    if(ZombieGameStatus == 0) return false; // Игра не включена
    if(PlayerIsZombie[playerid] == false) return false; // Первый игрок не зомби
    if(PlayerIsZombie[damagedid] == true) return false; // Второй игрок уже зомби
    if(!IsPlayerZombieGame(playerid, damagedid)) return false; // Кто-то из игроков не участвует

    if(ProxDetectorS(4.0, playerid, damagedid) && weaponid == 0)
    {
        GiveZombieStatus(damagedid, true);
    }
    return true;
}

// Оба игрока участвуют в игре
stock IsPlayerZombieGame(playerid, damagedid)
{
    if(PlayerZombieGame[playerid] == true && PlayerZombieGame[damagedid] == true) return true;
    return false;
}

stock GiveZombieStatus(playerid, bool:FindNext)
{
    if(PlayerInfo[playerid][pSex] == 2) SetPlayerChatBubble(playerid,"стала зомби",COLOR_ZOMBIE_GAME,20.0,3000);
    else SetPlayerChatBubble(playerid,"стал зомби",COLOR_ZOMBIE_GAME,20.0,3000);

    PlayerIsZombie[playerid] = true;
    keep(playerid, true);
    m_custom_sync_SetPlayerSkin(playerid, 505);
    SetPlayerColor(playerid, COLOR_ZOMBIE_GAME);

    if(FindNext == true)
    {
        new quanPlayers, quanZombie, lastPlayerid;
        foreach(Player,i)
        {
            if(OnlineInfo[i][oLogged] == 1)
            {
                if(PlayerZombieGame[i] == true) 
                {
                    if(PlayerIsZombie[i] == false) quanPlayers ++, lastPlayerid = i;
                }
                if(PlayerIsZombie[i] == true) quanZombie ++;
            }
        }

        // Отсался один игрок в игре
        if(quanPlayers <= 1)
        {
            foreach(Player,i)
            {
                if(OnlineInfo[i][oLogged] == 1)
                {
                    if(PlayerZombieGame[i] == true)
                    {
                        PlayerPlaySound(i,6401,0,0,0);
                        SendClientMessage(i, COLOR_LIGHTBLUE, "Zombie Game завершена! Последний выживший %s[%d]", PlayerInfo[lastPlayerid][pName], lastPlayerid);
                    }
                }
            }
            CloseZombie();
        }
        else SoundZombie(playerid);
    }  
    else SoundZombie(playerid);
    return true;
}

stock SoundZombie(playerid)
{
    ApplyAnimation(playerid,"SWEET","LaFin_Sweet", 4.0, false, true, true, false, false, SYNC_ALL);

    new Float:pla_pos[3];
    GetPlayerPos(playerid, pla_pos[0],pla_pos[1],pla_pos[2]);

    new atext[10], string[100];
    format(atext, sizeof(atext), "zombie%d", random(6));
    format(string, sizeof(string), "https://cdn.pears.fun/sound/zombie/%s.mp3", atext);
    PlayAudioStreamAround(string, pla_pos[0],pla_pos[1],pla_pos[2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), 30.0);
    return true;
}

// Вспомогательная функция для проверки наличия игрока в массиве
stock bool:IsPlayerInEligibleList(playerid, const list[], count)
{
    for(new i = 0; i < count; i++)
    {
        if(list[i] == playerid)
            return true;
    }
    return false;
}

stock StartZombie(playerid)
{
    new eligiblePlayers[MAX_REALPLAYERS], count = 0;

    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 1 && !IsPlayerAfk(i) && !IsPlayerNPC(i))
        {
            if(GetDistanceBetweenPlayers(playerid,i) < 100 
                && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)
                && GetPlayerInterior(playerid) == GetPlayerInterior(i))
			{
                eligiblePlayers[count++] = i;
            }
        }
    }
    if(count <= 2) return ErrorMessage(playerid, "{FF6347}Минимум 3 игрока для начала игры в Zombie");

    // Выбираем случайного зомби
    new zombieId = eligiblePlayers[random(count)];
    
    // Устанавливаем параметры для всех участников
    foreach(new i : Player)
    {
        if(IsPlayerInEligibleList(i, eligiblePlayers, count))
        {
            PlayerZombieGame[i] = true;
            
            if(i == zombieId)
            {   
                GiveZombieStatus(i, false);
                SendClientMessage(i, COLOR_LIGHTBLUE, "Администратор %s пригласил вас поиграть в игру Zombie {5c7057}[ Вы первый зомби ]", PlayerInfo[playerid][pName]);
            }
            else
            {
                SetPlayerColor(i, COLOR_PLAYER_ZOMBIE_GAME);
                SendClientMessage(i, COLOR_LIGHTBLUE, "Администратор %s запустил Zombie! Первый зомби: %s[%d]", 
                    PlayerInfo[playerid][pName], PlayerInfo[zombieId][pName], zombieId);
            }
        }
    }

    ZombieGameStatus = 1;
    return true;
}

stock CloseZombie()
{
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 1)
        {
            if(PlayerZombieGame[i] == true)
            {
                PlayerZombieGame[i] = false;
                keep(i);
                if(PlayerIsZombie[i] == true) 
                {
                    m_custom_sync_SetPlayerSkin(i, PlayerInfo[i][pModel]);
                    PlayerIsZombie[i] = false;
                }
                SetPlayerToTeamColor(i);
            }
        }
    }

    ZombieGameStatus = 0;
    return true;
}

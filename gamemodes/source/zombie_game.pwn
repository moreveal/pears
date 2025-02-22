
#define COLOR_ZOMBIE_GAME 0x5c7057FF
#define COLOR_PLAYER_ZOMBIE_GAME 0xcee0cc00 // Игрок не зомби, не имеет клиста на карте (чтобы могли прятаться)

new bool:PlayerZombieGame[MAX_REALPLAYERS]; // Статус участия в игре
new bool:PlayerIsZombie[MAX_REALPLAYERS]; // Статус зомби
new PersonalZombiePeople[MAX_REALPLAYERS]; // Количество обращенных мною людей в зомби

new ZombieGameStatus; // Статус игры
new ZombieQuan;
new PeopleQuan;
new Float:ZombieGamePosition[3];
new ZombieGameWorld;
new ZombieGameInterior;

//==================== Новая заморозка игрока ===============

new bool:keepPlayer[MAX_REALPLAYERS];
new keepTime[MAX_REALPLAYERS];

// Очищаем переменные заморозки
stock KeepClear_ClearVariation(playerid)
{
    keepPlayer[playerid] = false;
    keepTime[playerid] = 0;
    return true;
}

stock KeepClear_Freeze(playerid, bool:freezeLong = false)
{
    TogglePlayerControllable(playerid,false), keepPlayer[playerid] = true;
    if(freezeLong == true) keepTime[playerid] = 4;
    else
	{
		if(GetPlayerPing(playerid) >= 150) keepTime[playerid] = 3; // Высокий пинг, морозим чуть дольше
		else keepTime[playerid] = 2; // Норм пинг, морозим как обычно
	}
    return true;
}

// Процесс разморозки игрока (с очищением анимки после разморозки)
stock KeepClear_Process(playerid)
{
    if(keepPlayer[playerid] == true)
    {
        if(keepTime[playerid] > 0)
        {
            keepTime[playerid] --;
            if(keepTime[playerid] == 0)
            {
                keepPlayer[playerid] = false;
                TogglePlayerControllable(playerid, true);
                ClearAnimations(playerid);
            }
        }
        return true;
    }
    return false;
}

//===========================================================

stock ClearVariableZombieGame(playerid)
{
    PlayerZombieGame[playerid] = false;
    PlayerIsZombie[playerid] = false;
    PersonalZombiePeople[playerid] = 0;
    return true;
}

CMD:zombie(playerid)
{
    if(PlayerInfo[playerid][pSoska] < 4) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");

    if(ZombieGameStatus == 0)
    {
        if(Pognalinamp == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мне нужно запустить мероприятие для этого...");
        StartZombie(playerid);
    }
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
        PersonalZombiePeople[playerid] ++;
    
        new quanPlayers = GiveZombieStatus(damagedid, true);
        if(quanPlayers > 0)
        {
            new string[144];
            format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~3APA„EHO: ~r~%d / %d~n~~y~‹AЋ…: ~r~%d", ZombieQuan, ZombieQuan + PeopleQuan, PersonalZombiePeople[playerid]);
		    GameTextForPlayer(playerid,string,8000,3);
        }
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
    KeepClear_Freeze(playerid, true);
    m_custom_sync_SetPlayerSkin(playerid, 505);
    SetPlayerColor(playerid, COLOR_ZOMBIE_GAME);
    OffAccessory(playerid); // Скрываем аксы

    ZombieQuan ++;
    PeopleQuan --;

    new quanPlayers;
    if(FindNext == true)
    {
        quanPlayers = CountingPlayersZombie();
        ZombieQuan = quanPlayers; // Записываем количество зомбарей

        if(quanPlayers >= 2) SoundZombie(playerid);
    }  
    else SoundZombie(playerid);
    return quanPlayers;
}

stock CountingPlayersZombie()
{
    new quanPlayers, quanZombie, lastPlayerid;
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 1)
        {
            if(PlayerZombieGame[i] == true) 
            {
                // Если вдруг один из участников оказался далеко от игры, кикаем его
                if(GetPlayerDistanceFromPoint(i, ZombieGamePosition[0], ZombieGamePosition[1], ZombieGamePosition[2]) >= 500.0
                    || GetPlayerVirtualWorld(i) != ZombieGameWorld || GetPlayerInterior(i) != ZombieGameInterior
                    || GetPlayerState(i) == PLAYER_STATE_SPECTATING)
                {
                    ClosePlayerZombieGame(i); // Закрываем игру одному из участников
                }

                if(PlayerIsZombie[i] == false) quanPlayers ++, lastPlayerid = i;
                if(PlayerIsZombie[i] == true) quanZombie ++;
            }
        }
    }

    // Отсался один игрок в игре
    if(quanPlayers <= 1)
    {
        ShowTopZombiePlayers(lastPlayerid); // Подсчитываем и отображаем результаты в чат
        CloseZombie(); // Выключаем игру
    }
    return quanPlayers;
}

stock SoundZombie(playerid)
{
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
    PeopleQuan = 0;

    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 1 && !IsPlayerAfk(i) && !IsPlayerNPC(i) && ADUTY[i] == 0 && GetPlayerState(i) != PLAYER_STATE_SPECTATING)
        {
            eligiblePlayers[count++] = i;
        }
    }
    if(count <= 2) return ErrorMessage(playerid, "{FF6347}Минимум 3 игрока для начала игры в Zombie");

    GetPlayerPos(playerid, ZombieGamePosition[0], ZombieGamePosition[1], ZombieGamePosition[2]);
    ZombieGameWorld = GetPlayerVirtualWorld(playerid);
    ZombieGameInterior = GetPlayerInterior(playerid);

    // Выбираем случайного зомби
    new zombieId = eligiblePlayers[random(count)];
    
    // Устанавливаем параметры для всех участников
    foreach(new i : Player)
    {
        if(IsPlayerInEligibleList(i, eligiblePlayers, count))
        {
            PlayerZombieGame[i] = true;
            PlayerIsZombie[i] = false;
            PersonalZombiePeople[i] = 0;
            PeopleQuan ++; // Записываем количество людей (не зомби)
            
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

    new chat_msg[144];
	format(chat_msg, sizeof(chat_msg), " [ ADM ]: %s запустил%s режим Zombie на мероприятии!", PlayerInfo[playerid][pName], gender(playerid));
	ABroadCast(COLOR_ADM,chat_msg,1);

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
                KeepClear_Freeze(i);
                ExitPlayerZombie(i);
            }
        }
    }

    ZombieGameStatus = 0;
    PeopleQuan = 0;
    ZombieQuan = 0;
    return true;
}

// Игрок покинул игру зомби (помер, заспавнился, вышел)
stock ExitPlayerZombie(playerid, bool:countMembers = false)
{
    if(PlayerZombieGame[playerid] == true)
    {
        ClosePlayerZombieGame(playerid);
        if(countMembers == true) CountingPlayersZombie(); // Считаем участников, если необходимо (например смерть или выход из игры)
    }
    return true;
}

stock ClosePlayerZombieGame(playerid)
{
    if(PlayerZombieGame[playerid] == true)
    {
        KeepClear_Freeze(playerid);
        if(PlayerIsZombie[playerid] == true) 
        {
            m_custom_sync_SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]); // Возвращаем скин
            BackAccessory(playerid); // Возвращаем аксы
            ZombieQuan --;
        }
        else PeopleQuan --;
        SetPlayerToTeamColor(playerid);
        ClearVariableZombieGame(playerid); // Очищаем переменные
    }
    return true;
}

// Отображаем победителя и топ зомби в конце игры
stock ShowTopZombiePlayers(winplayerid) 
{
    new playerCount = 0;
    new playerList[MAX_REALPLAYERS][2]; // [0] playerid, [1] значение

    // Собираем данные игроков
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 1 && PlayerZombieGame[i] == true)
        {
            playerList[playerCount][0] = i;
            playerList[playerCount][1] = PersonalZombiePeople[i];
            playerCount++;
        }
    }

    // Сортировка пузырьком по убыванию
    for(new i = 0; i < playerCount; i++) 
    {
        for(new j = i + 1; j < playerCount; j++) 
        {
            if(playerList[i][1] < playerList[j][1]) 
            {
                // Меняем местами
                new tmpId = playerList[i][0];
                new tmpVal = playerList[i][1];
                
                playerList[i][0] = playerList[j][0];
                playerList[i][1] = playerList[j][1];
                
                playerList[j][0] = tmpId;
                playerList[j][1] = tmpVal;
            }
        }
    }

    // Вывод в чат
    foreach(Player,i)
    {
        if(OnlineInfo[i][oLogged] == 1 && (PlayerZombieGame[i] == true || PlayerInfo[i][pSoska] >= 2))
        {
            PlayerPlaySound(i,6401,0,0,0);
            SendClientMessage(i, COLOR_GREY, "{0088ff}Zombie Game {ffcc66}| Выживший %s[%d]", PlayerInfo[winplayerid][pName], winplayerid);

            for(new p = 0; p < 5 && p < playerCount; p++) 
            {
                SendClientMessage(i, COLOR_GREY, "{ffcc66}%d. %s[%d] {cccccc}- %d заражений", p + 1, PlayerInfo[playerList[p][0]][pName], playerList[p][0], playerList[p][1]);
            }
        }
    }
    return true;
}

#define MAX_NARCO_FARMS_NPC            20 // Максимальное количество NPC на наркоферме
#define KD_FARM_BATTLE                 7200 // КД на битву за наркоферму

enum e_NarcoFarmBattleInfo {
    dfbiAttackFraction, // Организация, которая атакует
    dfbiDefendFraction, // Организация, которая защищает
    dfbiAttackers[MAX_REALPLAYERS], // ID аккаунтов атакующих
    dfbiDefenders[MAX_REALPLAYERS], // ID аккаунтов защитников
    dfbiAttackScore, // Количество убитых атакующих
    dfbiAttackCount,
    dfbiDefendScore, // Количество убитых защитников
    dfbiDefendCount,
    dfbiStartTime, // Время начала битвы
    dfbiEndTime, // Время окончания битвы
    dfbiPrepareTimer, // Таймер подготовки
    dfbiPrepareTime // Unix времени со старта подготовки
};
new NarcoFarmBattleInfo[MAX_NARCO_FARMS][e_NarcoFarmBattleInfo];

new Float: NarcoFarmNpcPositions[MAX_NARCO_FARMS][][] = {
    { // Наркоферма №1
        {-1072.5118, -1621.3663, 76.3672, 90.2119},
        {-1069.8340, -1615.5408, 76.3740, 134.3532},
        {-1025.5366, -1630.7111, 76.3672, 59.3719},
        {-1030.7235, -1610.2457, 76.3672, 123.4492},
        {-1005.8781, -1658.4083, 76.3672, 62.5052},
        {-1023.6003, -1698.0419, 78.2735, 7.1231},
        {-1029.9368, -1711.6129, 77.1998, 15.7398},
        {-1028.1853, -1700.3972, 78.2406, 36.8900},
        {-1041.1727, -1694.9735, 77.7922, 356.6263},
        {-1082.4069, -1686.1134, 76.1184, 22.6331},
        {-1094.5631, -1686.3789, 76.2721, 356.6654},
        {-1119.6791, -1686.6664, 76.3672, 37.3599},
        {-1119.4342, -1678.8231, 76.3841, 355.4901},
        {-1116.2383, -1658.7780, 76.3831, 3.2451},
        {-1109.3564, -1660.0305, 76.3831, 2.8925},
        {-1057.9308, -1664.0775, 76.8050, 50.0261},
        {-973.5616, -1687.7821, 76.0539, 98.7500},
        {-1005.4888, -1734.2405, 77.6193, 11.7599},
        {-1048.2386, -1701.5541, 76.8424, 18.6142},
        {-1091.5515, -1663.9252, 77.6527, 359.1482}
    }
};
new NPC: NarcoFarmNPC[MAX_NARCO_FARMS][MAX_NARCO_FARMS_NPC];
new NarcoFarmNpcAttac[MAX_NARCO_FARMS][MAX_NARCO_FARMS_NPC];
new bool:NarcoFarmNpcDeath[MAX_NARCO_FARMS][MAX_NARCO_FARMS_NPC];

function NarcoFarmCreateBattleDelay(farmid, bool: force)
{
    if (NarcoFarmBattleInfo[farmid][dfbiPrepareTime] == 0) return false;
    NarcoFarmBattleInfo[farmid][dfbiPrepareTimer] = 0;

    return NarcoFarmCreateBattle(farmid, force);
}

stock NarcoFarmCreatePrepareTimer(farmid, bool: force = false, delay = 600000)
{
    if (IsValidTimer(NarcoFarmBattleInfo[farmid][dfbiPrepareTimer]))
    {
        KillTimer(NarcoFarmBattleInfo[farmid][dfbiPrepareTimer]);
        NarcoFarmBattleInfo[farmid][dfbiPrepareTimer] = 0;
    }
    NarcoFarmBattleInfo[farmid][dfbiPrepareTimer] = SetTimerEx("NarcoFarmCreateBattleDelay", delay, false, "ii", farmid, force);

    return 1;
}

stock NarcoFarmPrepareBattle(farmid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    if (NarcoFarmIsBattleActive(farmid)) return 0;

    NarcoFarmCreatePrepareTimer(farmid, true);

    return 1;
}

stock NarcoFarmCreateBattle(farmid, bool: force = false)
{
    if (!force && !NarcoFarmIsBattleReady(farmid)) return 0;
    if (!NarcoFarmIsBattleActive(farmid)) return 0;

    if (!IsAMafiaID(NarcoFarmInfo[farmid][dfiFraction])) // Никому не принадлежит
    {
        #pragma warning disable 204
        new skins[] = {1, 32, 133, 132};
        new weapons[] = {24, 25, 30, 33};
        for (new i = 0; i < MAX_NARCO_FARMS_NPC; i++)
        {
            if (NarcoFarmNpcPositions[farmid][i][0] == 0.0) continue;
            NarcoFarmNPC[farmid][i] = CreateNpc(skins[random(sizeof(skins))],NarcoFarmNpcPositions[farmid][i][0],NarcoFarmNpcPositions[farmid][i][1],NarcoFarmNpcPositions[farmid][i][2]);
            SetNpcVirtualWorld(NarcoFarmNPC[farmid][i], 0);
            SetNpcHealth(NarcoFarmNPC[farmid][i], 100.0);
            SetNpcWeapon(NarcoFarmNPC[farmid][i], WEAPON:weapons[random(sizeof(weapons))]);
            NarcoFarmNpcDeath[farmid][i] = false;
        }
    }
    NarcoFarmTeleportVehicles(farmid);
    NarcoFarmRespawnPlayers(farmid);
    NarcoFarmUpdateBattle(farmid);
    SendRadioMessage(NarcoFarmBattleInfo[farmid][dfbiDefendFraction],COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: Битва началась! {ffcc66}Вперед!");
    SendRadioMessage(NarcoFarmBattleInfo[farmid][dfbiAttackFraction],COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: Битва началась! {ffcc66}Вперед!");
    NarcoFarmBattleInfo[farmid][dfbiStartTime] = gettime();
    NarcoFarmBattleInfo[farmid][dfbiPrepareTime] = 0;
    return 1;
}

stock NarcoFarmIsBattleActive(farmid)
{
    return NarcoFarmBattleInfo[farmid][dfbiAttackFraction] > 0;
}

stock NarcoFarmIsPrepareBattleActive(farmid)
{
    return IsValidTimer(NarcoFarmBattleInfo[farmid][dfbiPrepareTime]);
}

stock NarcoFarmIsMafiaBattleActive(fractionid)
{
    for (new farmid = 0; farmid < MAX_NARCO_FARMS; farmid++)
    {
        if (NarcoFarmInfo[farmid][dfiFraction] != fractionid) continue;

        if (NarcoFarmIsBattleActive(farmid) || NarcoFarmIsPrepareBattleActive(farmid))
        {
            return true;
        }
    }
    return false;
}

stock NarcoFarmFinishBattle(farmid, fraction, bool: defenderwin = true)
{
    if (!NarcoFarmIsBattleActive(farmid)) return 0;

    if(defenderwin)
    {
        if(NarcoFarmBattleInfo[farmid][dfbiDefendFraction] != 0) SendRadioMessage(fraction,COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: Вы выиграли! {ffcc66}Ферма осталась под нашим контролем!");
    }
    else
    {
        SendRadioMessage(fraction,COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: Вы выиграли! {ffcc66}Теперь эта ферма под вашим контролем!");
        NarcoFarmInfo[farmid][dfiFraction] = fraction;
        NarcoFarmCreatePickup(farmid);
        NarcoFarmSave(farmid);
        for(new e_NarcoFarmBattleInfo:i; i < e_NarcoFarmBattleInfo; ++i) NarcoFarmBattleInfo[farmid][i] = 0;
        for(new i; i < MAX_REALPLAYERS; i++) NarcoFarmBattleInfo[farmid][dfbiAttackers][i] = 0, NarcoFarmBattleInfo[farmid][dfbiDefenders][i] = 0;
    }
    if(NarcoFarmBattleInfo[farmid][dfbiDefendFraction] == 0)
    {
        for(new npc = 0; npc < MAX_NARCO_FARMS_NPC; npc++)
        {
            if(IsValidNpc(NarcoFarmNPC[farmid][npc])) DestroyNpc(NarcoFarmNPC[farmid][npc]);
        }
    }
    NarcoFarmBattleInfo[farmid][dfbiEndTime] = gettime();
    foreach(Player,i)
    {
        if(gNarkoFarm[i] != 9999 && OnlineInfo[i][oLogged] == 1)
        {
            DelMaf(i);
        }
    }
    return 1;
}

stock NarcoFarmNotifyAboutBattle(farmid, status)
{
    if (NarcoFarmBattleInfo[farmid][dfbiAttackFraction] <= 0) return 0;

    new fractionid = NarcoFarmInfo[farmid][dfiFraction],
        attack_fraction = NarcoFarmBattleInfo[farmid][dfbiAttackFraction];

    if(status)
    {
        SendRadioMessage(fractionid,COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: Началась подготовка к битве за ферму {ffcc66}Не покидайте территорию фермы!");
        SendRadioMessage(attack_fraction,COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: Началась подготовка к битве за ферму {ffcc66}Не покидайте территорию фермы!");
        foreach(Player, playerid)
        {
            if(fraction(playerid) != attack_fraction) continue;
            SendClientMessage(playerid, COLOR_GRAY, "[ Мысли ]: Нападаение происходит на ферму %d. Метка GPS установлена на неё", NarcoFarmInfo[farmid][dfiID]);
            CreateGps(playerid, NarcoFarmInfo[farmid][dfiSpawnAttackersPos][0], NarcoFarmInfo[farmid][dfiSpawnAttackersPos][1], NarcoFarmInfo[farmid][dfiSpawnAttackersPos][2], -1, -1, 2.0);
        }
    }
    else {
        SendRadioMessage(fractionid,COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: Ваша мафия снизила время на подготовку. Осталось 30 секунд!");
        SendRadioMessage(attack_fraction,COLOR_LIGHTRED,"{0088ff}[ Mafia War ]: Владельцы фермы снизили время на подготовку. Осталось 30 секунд!");
    }
    return 1;
}

stock NarcoFarmTeleportVehicles(farmid)
{
    new Float: x, Float: y, Float: z;
    foreach (new vehicleid : Vehicle)
    {
        GetVehiclePos(vehicleid, x, y, z);
        if (!IsPointInDynamicArea(NarcoFarmInfo[farmid][dfiArea], x, y, z)) continue;

        PP_SetVehicleToRespawn(vehicleid);
    }
    return 1;
}

stock NarcoFarmRespawnPlayers(farmid)
{
    foreach (new playerid : Player)
    {
        if (fraction(playerid) == NarcoFarmBattleInfo[farmid][dfbiDefendFraction] && farmid == NarcoFarmGetNearest(playerid))
        {
            PPSetPlayerPos(
                playerid,
                NarcoFarmInfo[farmid][dfiSpawnDefendersPos][0] + frand(-NARCO_FARMS_SPAWN_RADIUS, NARCO_FARMS_SPAWN_RADIUS),
                NarcoFarmInfo[farmid][dfiSpawnDefendersPos][1] + frand(-NARCO_FARMS_SPAWN_RADIUS, NARCO_FARMS_SPAWN_RADIUS),
                NarcoFarmInfo[farmid][dfiSpawnDefendersPos][2]
            );
            PPSetPlayerFacingAngle(playerid, NarcoFarmInfo[farmid][dfiSpawnDefendersPos][3]);
        } else if (fraction(playerid) == NarcoFarmBattleInfo[farmid][dfbiAttackFraction] && farmid == NarcoFarmGetNearest(playerid))
        {
            PPSetPlayerPos(
                playerid,
                NarcoFarmInfo[farmid][dfiSpawnAttackersPos][0] + frand(-NARCO_FARMS_SPAWN_RADIUS, NARCO_FARMS_SPAWN_RADIUS),
                NarcoFarmInfo[farmid][dfiSpawnAttackersPos][1] + frand(-NARCO_FARMS_SPAWN_RADIUS, NARCO_FARMS_SPAWN_RADIUS),
                NarcoFarmInfo[farmid][dfiSpawnAttackersPos][2]
            );
            PPSetPlayerFacingAngle(playerid, NarcoFarmInfo[farmid][dfiSpawnAttackersPos][3]);
        } else continue; // скип всех прочих

        PlayerPlaySound(playerid,3201,0,0,0);
    }
    return 1;
}

function NarcoFarmUpdateBattle(farmid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    if (!NarcoFarmIsBattleActive(farmid)) return 0;

    if (!NarcoFarmHasAttackers(farmid)) return NarcoFarmFinishBattle(farmid,NarcoFarmBattleInfo[farmid][dfbiDefendFraction],true);
    if (!NarcoFarmHasDefenders(farmid)) return NarcoFarmFinishBattle(farmid,NarcoFarmBattleInfo[farmid][dfbiAttackFraction],false);

    return SetTimerEx("NarcoFarmUpdateBattle", 1000, false, "i", farmid);
}

stock NarcoFarmIsBattleReady(farmid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    if (!NarcoFarmHasAttackers(farmid)) return 0;
    if (!NarcoFarmHasDefenders(farmid) && NarcoFarmBattleInfo[farmid][dfbiDefendFraction] != 0) return 0;

    return 1;
}

stock NarcoFarmIsAttacker(farmid, playerid)
{
    if (!NarcoFarmIsBattleActive(farmid) || !IsOnline(playerid)) return 0;

    new g = fraction(playerid);
    return NarcoFarmBattleInfo[farmid][dfbiAttackFraction] == g && GetAccessRankOrg(playerid, g, 26, NO_FBI);
}

stock NarcoFarmIsDefender(farmid, playerid)
{
    if (!NarcoFarmIsBattleActive(farmid) || !IsOnline(playerid)) return 0;

    new g = fraction(playerid);
    return NarcoFarmBattleInfo[farmid][dfbiDefendFraction] == g && GetAccessRankOrg(playerid, g, 26, NO_FBI);
}

stock NarcoFarmHasAttackers(farmid)
{
    return NarcoFarmGetAttackersAmount(farmid) > 0;
}

stock NarcoFarmHasDefenders(farmid)
{
    return NarcoFarmGetDefendersAmount(farmid) > 0;
}

stock NarcoFarmGetAttackersAmount(farmid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;

    new count = 0;
    foreach (new id : Player)
    {
        if (NarcoFarmIsInside(id, farmid) && NarcoFarmIsAttacker(farmid, id))
        {
            count++;
        }
    }
    NarcoFarmBattleInfo[farmid][dfbiAttackCount] = count;
    return count;
}

stock NarkoFerm_TaskNpcAttackPlayer(NPC:npc, playerid, i, farmid)
{
    TaskNpcAttackPlayer(npc, playerid, true);
    NarcoFarmNpcAttac[farmid][i] = playerid;
    return true;
}

stock LifeNarkoFermNpc()
{
    for(new i = 0; i < MAX_NARCO_FARMS; i++)
    {
        if(!NarcoFarmIsBattleActive(i)) continue;
        else{
            for(new npc; npc < MAX_NARCO_FARMS_NPC; npc++)
            {
                if(!IsNpcDead(NarcoFarmNPC[i][npc]))
                {
                    AttackNarkoFermNpcNearbyPlayer(i, npc);
                }
            }
        }
    }
    return true;
}

stock AttackNarkoFermNpcNearbyPlayer(farmid, i)
{
    new latestid = FindClosestPlayerToNarkoFermNpc(NarcoFarmNPC[farmid][i], i, farmid);

    if(latestid != -1 && latestid != INVALID_PLAYER_ID) 
    {
        NarkoFerm_TaskNpcAttackPlayer(NarcoFarmNPC[farmid][i], latestid, i, farmid);
    }

    else if(latestid == INVALID_PLAYER_ID)
    {
        // А че бля, в рекурсию вгонять тут или шо?
    }
    return true;
}

stock FindClosestPlayerToNarkoFermNpc(NPC:npc, i, farmid) 
{
    new Float:npc_x, Float:npc_y, Float:npc_z;
    GetNpcPosition(npc, npc_x, npc_y, npc_z);

    new Float:dist = 99999.0;
    new latestId = INVALID_PLAYER_ID;

    foreach (Player, playerid) 
    {
        if(gNarkoFarm[playerid] == 9999) continue;

        new Float:thisDist = GetPlayerDistanceFromPoint(playerid, npc_x, npc_y, npc_z);
        if (thisDist < dist) 
        {
            dist = thisDist;
            latestId = playerid;
        }
    }

    if(NarcoFarmNpcAttac[farmid][i] == latestId 
        && latestId != INVALID_PLAYER_ID) return -1;

    return latestId;
}

stock NarcoFarmGetDefendersAmount(farmid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    
    new count = 0;
    if(NarcoFarmBattleInfo[farmid][dfbiDefendFraction] != 0)
    {
        foreach (new id : Player)
        {
            if (NarcoFarmIsInside(id, farmid) && NarcoFarmIsDefender(farmid, id))
            {
                count++;
            }
        }
    }
    else
    {
        for (new i = 0; i < MAX_NARCO_FARMS_NPC; i++)
        {
            if (IsValidNpc(NarcoFarmNPC[farmid][i]))
            {
                new Float:tempHealt;
                GetNpcHealth(NarcoFarmNPC[farmid][i],tempHealt);
                if(tempHealt > 0.0) count++;
            }
        }
    }
    NarcoFarmBattleInfo[farmid][dfbiDefendCount] = count;
    return count;
}

stock CheckMafFarmKill(playerid, killerid)
{
    #pragma unused killerid
    new farmid = NarcoFarmGetNearest(playerid);
    if(fraction(playerid) == NarcoFarmBattleInfo[farmid][dfbiAttackFraction])
    {
        for(new i = 0; i < MAX_REALPLAYERS; i++)
        {
            if(NarcoFarmBattleInfo[farmid][dfbiAttackers][i] == 0) continue;
            if(NarcoFarmBattleInfo[farmid][dfbiAttackers][i] == PlayerInfo[playerid][pID])
            {
                NarcoFarmBattleInfo[farmid][dfbiDefendScore]++,NarcoFarmBattleInfo[farmid][dfbiAttackers][i] = 0;
                break;
            }
        }
    }
    else if(fraction(playerid) == NarcoFarmBattleInfo[farmid][dfbiDefenders])
    {
        for(new i = 0; i < MAX_REALPLAYERS; i++)
        {
            if(NarcoFarmBattleInfo[farmid][dfbiDefenders][i] == 0) continue;
            if(NarcoFarmBattleInfo[farmid][dfbiDefenders][i] == PlayerInfo[playerid][pID])
            {
                NarcoFarmBattleInfo[farmid][dfbiAttackScore]++,NarcoFarmBattleInfo[farmid][dfbiDefenders][i] = 0;
                break;
            }
        }
    }
    return 1;
}

stock NarcoFarmBattle_OnPlayerGiveDamageNpc(NPC: npc, damagerid, Float: amount, weaponid, bodypart)
{
    #pragma unused weaponid
    #pragma unused bodypart

    new farmid = NarcoFarmGetNearest(damagerid);
    if(farmid == INVALID_NARCOFARM_ID) return 1;

    new npc_id = -1;
    for (new i = 0; i < MAX_NARCO_FARMS_NPC; i++)
    {
        if (NarcoFarmNPC[farmid][i] == npc)
        {
            npc_id = i;
            break;
        }
    }

    if (npc_id > -1)
    {
        new Float:tempHealt = 0.0;
        GetNpcHealth(NarcoFarmNPC[farmid][npc_id], tempHealt);
        if(tempHealt - amount <= 0.0 && NarcoFarmNpcDeath[farmid][npc_id] == false) 
        {
            NarcoFarmBattleInfo[farmid][dfbiAttackScore]++;
            NarcoFarmNpcDeath[farmid][npc_id] = true;
        }
        return false;
    }

    return 1;
}

stock NarcoFarmEnterDynamicArea(playerid, farmid)
{
    #pragma unused playerid
    if(NarcoFarmIsBattleActive(farmid))
    {
        //if(NarcoFarmBattleInfo[farmid][dfbiAttackFraction] == fraction(playerid)) CreateGps(playerid, NarcoFarmInfo[farmid][dfiSpawnDefendersPos][0], NarcoFarmInfo[farmid][dfiSpawnDefendersPos][1], NarcoFarmInfo[farmid][dfiSpawnDefendersPos][2], -1, -1, 2.0);
        //else if(NarcoFarmBattleInfo[farmid][dfbiDefendFraction] == fraction(playerid)) CreateGps(playerid, NarcoFarmInfo[farmid][dfiSpawnAttackersPos][0], NarcoFarmInfo[farmid][dfiSpawnAttackersPos][1], NarcoFarmInfo[farmid][dfiSpawnAttackersPos][2], -1, -1, 2.0);
    }
    return 1;
}

stock NarcoFarmLeaveDynamicArea(playerid, farmid)
{
    if(NarcoFarmIsBattleActive(farmid))
    {
        DestroyGps(playerid);
        if(fraction(playerid) == NarcoFarmBattleInfo[farmid][dfbiAttackFraction])
        {
            for(new i = 0; i < MAX_REALPLAYERS; i++)
            {
                if(NarcoFarmBattleInfo[farmid][dfbiDefenders][i] == 0) continue;
                if(NarcoFarmBattleInfo[farmid][dfbiDefenders][i] == PlayerInfo[playerid][pID]) NarcoFarmBattleInfo[farmid][dfbiAttackScore]++,NarcoFarmBattleInfo[farmid][dfbiDefenders][i] = 0;
            }
        }
        else if(fraction(playerid) == NarcoFarmBattleInfo[farmid][dfbiDefenders])
        {
            for(new i = 0; i < MAX_REALPLAYERS; i++)
            {
                if(NarcoFarmBattleInfo[farmid][dfbiAttackers][i] == 0) continue;
                if(NarcoFarmBattleInfo[farmid][dfbiAttackers][i] == PlayerInfo[playerid][pID]) NarcoFarmBattleInfo[farmid][dfbiDefendScore]++,NarcoFarmBattleInfo[farmid][dfbiAttackers][i] = 0;
            }
        }
    }
    return 1;
}

stock IsPlayerHaveMafFarmAccess(playerid)
{
    return GetAccessRankOrg(playerid, fraction(playerid), 26, NO_FBI);
}

DIALOG_GENERATOR:mafiafarm(playerid)
{
    new farmid = NarcoFarmGetNearest(playerid);
    if (farmid == INVALID_NARCOFARM_ID) return ErrorMessage(playerid, "{FF6347}Вы не находитесь на территории фермы мафии");
    if(NarcoFarmBattleInfo[farmid][dfbiEndTime]+KD_FARM_BATTLE > gettime())
    {
        return ErrorMessage(playerid, "{FF6347}За данную ферму недавно была битва. Нужно подождать!\nСледующая битва станет доступна через {ff9000}%s",fine_time(NarcoFarmBattleInfo[farmid][dfbiEndTime]+KD_FARM_BATTLE));
    }

    new dialog_text[1024];
    if(GetAccessRankOrg(playerid, fraction(playerid), 26, NO_FBI) && fraction(playerid) == NarcoFarmInfo[farmid][dfiFraction] && NarcoFarmBattleInfo[farmid][dfbiAttackFraction] > 0)
    {
        format(dialog_text, sizeof(dialog_text),"{cccccc}Для начала битвы ознакомьтесь с правилами данного ивента\n"\
                                            "{cccccc}Время на подготовку будет снижено до 30 секунд!\n"\
                                            "{cccccc}Во время захвата важно находится на территории или битва будет проиграна\n"\
                                            "{cccccc}Весь транспорт, который на территории фермы, будет заспавнен\n\n"\
                                            "{0088ff}Готовы начать битву?");
    }
    else{
        format(dialog_text, sizeof(dialog_text),"{cccccc}Прежде чем запустить битву, прочитайте правила данного ивента\n"\
                                            "{cccccc}Перед началом у вас будет время на подготовку к битве (10 минут)\n"\
                                            "{cccccc}Во время захвата важно находится на территории или битва будет проиграна\n"\
                                            "{cccccc}Весь транспорт, который на территории фермы, будет заспавнен\n\n"\
                                            "{0088ff}Готовы начать битву?");
    }

    SetDialogContextInt(playerid, "farmid", farmid);
    return ShowAdvancedDialog(playerid, "mafiafarm", DIALOG_STYLE_MSGBOX, "{ff9000}Битва за ферму мафии", dialog_text, "Да", "Нет");
}

DIALOG:mafiafarm(playerid, response, listitem, const inputtext[]){
    if (!response) return false;
    new farmid = GetDialogContextInt(playerid,"farmid");
    if(NarcoFarmInfo[farmid][dfiFraction] == fraction(playerid) && NarcoFarmBattleInfo[farmid][dfbiPrepareTime] != 0)
    {
        if(NarcoFarmBattleInfo[farmid][dfbiPrepareTime] < gettime() + 570)
        {
            NarcoFarmCreatePrepareTimer(farmid, true, 30000), NarcoFarmBattleInfo[farmid][dfbiPrepareTime] = 570 + gettime();
            NarcoFarmNotifyAboutBattle(farmid, false);
        }
        else return false;
    }
    else if(NarcoFarmBattleInfo[farmid][dfbiPrepareTime] == 0) 
    {
        if(NarcoFarmInfo[farmid][dfiFraction] == 0) NarcoFarmCreatePrepareTimer(farmid, true, 30000), NarcoFarmBattleInfo[farmid][dfbiPrepareTime] = gettime() + 570;
        else NarcoFarmCreatePrepareTimer(farmid, true), NarcoFarmBattleInfo[farmid][dfbiPrepareTime] = gettime();
        NarcoFarmBattleInfo[farmid][dfbiAttackFraction] = fraction(playerid);
        NarcoFarmBattleInfo[farmid][dfbiDefendFraction] = NarcoFarmInfo[farmid][dfiFraction];
        NarcoFarmNotifyAboutBattle(farmid, true);
        new quanattac = 0, quandefender = 0;
        foreach(Player,i)
        {
            if(gNarkoFarm[i] == 9999 && OnlineInfo[i][oLogged] == 1)
            {
                if(fraction(i) == NarcoFarmBattleInfo[farmid][dfbiAttackFraction])
                {
                    //CreateGps(i, NarcoFarmInfo[farmid][dfiSpawnDefendersPos][0], NarcoFarmInfo[farmid][dfiSpawnDefendersPos][1], NarcoFarmInfo[farmid][dfiSpawnDefendersPos][2], -1, -1, 2.0);
                    GetNarkoFermFractionName(i, farmid, NarcoFarmBattleInfo[farmid][dfbiDefendFraction]);
                    NarcoFarmBattleInfo[farmid][dfbiAttackers][quanattac] = PlayerInfo[i][pID];
                    quanattac++;
                }
                if(fraction(i) == NarcoFarmBattleInfo[farmid][dfbiDefendFraction]) 
                {
                    GetNarkoFermFractionName(i, farmid, NarcoFarmBattleInfo[farmid][dfbiAttackFraction]);
                    //CreateGps(i, NarcoFarmInfo[farmid][dfiSpawnAttackersPos][0], NarcoFarmInfo[farmid][dfiSpawnAttackersPos][1], NarcoFarmInfo[farmid][dfiSpawnAttackersPos][2], -1, -1, 2.0);
                    NarcoFarmBattleInfo[farmid][dfbiDefenders][quandefender] = PlayerInfo[i][pID];
                    quandefender++;
                }
            }
        }
    }
    return true;
}

CMD:mafiafarm(playerid, const params[])
{
    new g = fraction(playerid);
    if(!IsAFunctionOrganization(26, g, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не участник мафии");
	if(!GetAccessRankOrg(playerid, g, 26, NO_FBI)) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к захвату фермы мафии");
    if(!NarcoFarmIsInside(playerid)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь на территории фермы мафии");
    if(!NarkoFerm_ReadyBattleAccess(playerid)) return false;

    return ShowAdvancedDialogGen<mafiafarm>(playerid);
}

stock NarkoFerm_ReadyBattleAccess(playerid)
{
    new farmid = NarcoFarmGetNearest(playerid);
    if (farmid == INVALID_NARCOFARM_ID) {
        ErrorMessage(playerid, "{FF6347}Вы не находитесь на территории фермы мафии"); 
        return false;
    }

    if((NarcoFarmInfo[farmid][dfiSpawnDefendersPos][0] == 0.0 && NarcoFarmInfo[farmid][dfiSpawnDefendersPos][1] == 0.0 ) || NarcoFarmInfo[farmid][dfiSpawnAttackersPos][0] == 0.0 && NarcoFarmInfo[farmid][dfiSpawnAttackersPos][1] == 0.0) {
        ErrorMessage(playerid, "{FF6347}У данной фермы мафии не установлены спавны [ Обратитесь к администрации ]");
        return false;
    }
    if(NarcoFarmInfo[farmid][dfiFraction] != 0 && NarcoFarmInfo[farmid][dfiFraction] != fraction(playerid))
    {
        new frakID = NarcoFarmInfo[farmid][dfiFraction];
        if(Strel[frakID] > 0 || Zahvat[frakID] > 0 || NarcoFarmIsMafiaBattleActive(frakID)) 
        {
            ErrorMessage(playerid, "{FF6347}У данной мафии сейчас идет битва. Нельзя начинать захват!");
            return false;
        }
        new bool:result = false;
        if(frakID != 0 && frakID != fraction(playerid))
        {
            foreach(Player, i)
            {
                if(OnlineInfo[i][oLogged] != 1) continue;
                if(fraction(i) != frakID) continue;
                if(GetAccessRankOrg(i, frakID, 26, NO_FBI)) 
                {
                    result = true;
                    break;
                }
            }
        }
        if(!result) {
            ErrorMessage(playerid, "{FF6347}Вы не можете начать захват во время отсутствия руководителя мафии!"); 
            return false;
        }
    }
    if(NarcoFarmInfo[farmid][dfiFraction] != fraction(playerid) && NarcoFarmBattleInfo[farmid][dfbiPrepareTime] != 0) {
        ErrorMessage(playerid, "{FF6347}Уже идёт подготовка к захвату, не покидайте территорию фермы!");
        return false;
    }
    else if(NarcoFarmInfo[farmid][dfiFraction] == fraction(playerid) && NarcoFarmBattleInfo[farmid][dfbiPrepareTime]+540 < gettime() && NarcoFarmBattleInfo[farmid][dfbiPrepareTime] != 0) {
        ErrorMessage(playerid, "{FF6347}Невозможно ускорить подготовку к битве, она вот-вот начнется!");
        return false;
    }
    else if(NarcoFarmInfo[farmid][dfiFraction] == fraction(playerid) && NarcoFarmBattleInfo[farmid][dfbiPrepareTime] == 0) {
        ErrorMessage(playerid, "{FF6347}Эта ферма уже принадлежит вашей организации");
        return false;
    }
    return true;
}

stock UpdateNarkoFarmDraw(playerid) //+
{
    new farmid = gNarkoFarm[playerid];
    if(farmid == INVALID_NARCOFARM_ID) return DelMaf(playerid);
	if(OnlineInfo[playerid][oLogged] >= 1)
    {
		if(NarcoFarmBattleInfo[farmid][dfbiPrepareTime] != 0) // Подготовка к Битве
		{
	  		new sotring[24];
            new preparetime;
            if(NarcoFarmBattleInfo[farmid][dfbiPrepareTime] < gettime()) preparetime = NarcoFarmBattleInfo[farmid][dfbiPrepareTime]-gettime()+600;
            else preparetime = NarcoFarmBattleInfo[farmid][dfbiPrepareTime]-gettime()-540;
            format(sotring, sizeof(sotring), "%s", fine_time(preparetime));
         	PlayerTextDrawSetString(playerid, PlayerGangDraw[9][playerid], sotring);
         	PlayerTextDrawShow(playerid, PlayerGangDraw[9][playerid]);
		}
	    else if(NarcoFarmBattleInfo[farmid][dfbiStartTime] != 0)
		{
            PlayerTextDrawSetString(playerid, PlayerGangDraw[9][playerid], " ");
         	PlayerTextDrawShow(playerid, PlayerGangDraw[9][playerid]);
            if(fraction(playerid) == NarcoFarmBattleInfo[farmid][dfbiAttackFraction]) // Если обновляем тому, кто нападает
            {
                new string[24];
                format(string, sizeof(string), "%02d", NarcoFarmBattleInfo[farmid][dfbiAttackScore]);
                PlayerTextDrawSetString(playerid, PlayerGangDraw[7][playerid], string);

                new sctring[24];
                format(sctring, sizeof(sctring), "%02d", NarcoFarmBattleInfo[farmid][dfbiDefendScore]);
                PlayerTextDrawSetString(playerid, PlayerGangDraw[8][playerid], sctring);
            }
            if(fraction(playerid) == NarcoFarmBattleInfo[farmid][dfbiDefendFraction]) // Если обновляем тому, кто защищается
            {
                new string[24];
                format(string, sizeof(string), "%02d", NarcoFarmBattleInfo[farmid][dfbiDefendScore]);
                PlayerTextDrawSetString(playerid, PlayerGangDraw[7][playerid], string);

                new sctring[24];
                format(sctring, sizeof(sctring), "%02d", NarcoFarmBattleInfo[farmid][dfbiAttackScore]);
                PlayerTextDrawSetString(playerid, PlayerGangDraw[8][playerid], sctring);
            }
            PlayerTextDrawShow(playerid, PlayerGangDraw[7][playerid]);
            PlayerTextDrawShow(playerid, PlayerGangDraw[8][playerid]);
		}
	}
	return 1;
}

stock GetNarkoFermFractionName(playerid,farmid, protiv) // +
{
	if(gNarkoFarm[playerid] == 9999 && OnlineInfo[playerid][oLogged] == 1 && setting_pos_draw[playerid] != 1 && setting_size_draw[playerid] != 1)
	{
		gNarkoFarm[playerid] = farmid;
		PlayerPlaySound(playerid,3201,0,0,0);
		PlayerTextDrawShow(playerid, PlayerGangDraw[0][playerid]);
		PlayerTextDrawShow(playerid, PlayerGangDraw[3][playerid]);
		PlayerTextDrawShow(playerid, PlayerGangDraw[4][playerid]);
		UpdateNarkoFarmDraw(playerid);

		new string[24];
		format(string, sizeof(string), "%s", frakDraw[fraction(playerid)]);
		PlayerTextDrawSetString(playerid,PlayerGangDraw[1][playerid], string);
		PlayerTextDrawShow(playerid, PlayerGangDraw[1][playerid]);

        format(string, sizeof(string), "%s", frakDraw[protiv]);
		PlayerTextDrawSetString(playerid,PlayerGangDraw[2][playerid], string);
		PlayerTextDrawShow(playerid, PlayerGangDraw[2][playerid]);
	}
	return 1;
}

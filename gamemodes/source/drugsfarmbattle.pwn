/*
    Захват наркофермы участниками других мафий

    TODO:
        Если ферма кому-то принадлежит:
            1.  Приезжает чел у которого есть доступ к /mafia(-farm) на территорию нужной фермы, вводит команду и нажимает что хочет ее захватить
                Проверка доступа: 
            2.  Если нет ни одного игрока с доступом к участию в другой мафии - выбиваем ошибку
                Если у обороняющейся/нападающей мафии уже активная стрела, или активный захват наркофермы - выбиваем ошибку, что у них активная битва
                    Strel[fractionid] > 0 || Zahvat[fractionid] > 0
                Если не установлены спавны хотя бы одной из организаций - выбиваем ошибку

                Также в диалоге написать, что нужно быть ознакомленым с правилами, что будет время на подготовку, что весь транспорт должен быть за пределами фермы, потому что он заспавнится
                и что следует оставаться на территории фермы всем участвующим

                Если есть - отправляем уведомление участникам обоих мафий, имеющих доступ, и говорим готовиться

                    Команде атакующих ставим GPS-метку на их спавн, если они уже на территории, или ставим ее при вхождении на нее
                    Команде защищающихся тоже ставим GPS-метку на их спавн, если они уже на территории, или ставим ее при вхождении на нее
                    
                    Спавны: NarcoFarmInfo[farmid][dfiSpawnDefendersPos][0] - x
                            NarcoFarmInfo[farmid][dfiSpawnDefendersPos][1] - y
                            NarcoFarmInfo[farmid][dfiSpawnDefendersPos][2] - z

                            NarcoFarmInfo[farmid][dfiSpawnAttackersPos][0] - x
                            NarcoFarmInfo[farmid][dfiSpawnAttackersPos][1] - y
                            NarcoFarmInfo[farmid][dfiSpawnAttackersPos][2] - z

                После окончания подготовки (вызов NarcoFarmCreateBattle) проверяем нахождение всех участников в квадрате, если кого-то вовсе нет - автоматически засчитываем их поражение
                (fraction(playerid) == NarcoFarmInfo[farmid][dfiFraction] && GetAccessRankOrg(playerid, NarcoFarmInfo[farmid][dfiFraction], 26, NO_FBI))

                NarcoFarmInfo[farmid][dfiFraction] - защита
                номер организации атаки заносится в NarcoFarmBattleInfo[farmid][dfbiAttackFraction] при объявлении
            3.  Заносим номера аккаунтов (PlayerInfo[playerid][pID]) участников в массив, и будем убирать от туда при их смерти, чтобы не учитывать их в дальнейших подсчетах и предотвратить возвращение на территорию вновь
            4.  Начинаем битву
                    Спавним всех участников захвата (и атакующих и защитников)
                    Спавним весь находящийся транспорт на территории фермы (IsPointInDynamicArea(NarcoFarmInfo[farmid][dfiArea], x, y, z))
                        foreach (new vehicleid : Vehicle)
                        {
                            new Float: x, Float: y, Float: z;
                            GetVehiclePos(vehicleid, x, y, z);
                            if (!IsPointInDynamicArea(NarcoFarmInfo[farmid][dfiArea], x, y, z)) continue;
                            
                            PP_SetVehicleToRespawn(vehicleid);
                        }
                    
                    Выводим текстдрав и инициируем запуск таймера обновления битвы (NarcoFarmUpdateBattle)
                    Таймер сам себя вызывает каждую секунду, пока битва активна, поэтому можно не беспокоиться о его завершении

                Далее проводим обработку в NarcoFarmUpdateBattle (каждую секунду вызывается)
            5.  Завершаем битву если из квадрата уходят все участники одной из организаций в пользу второй
                Завершаем битву если убийство привело к тому, что на территории не осталось ни одного игрока из одной из организаций в пользу убившей
            6.  После окончания битвы (вызов NarcoFarmFinishBattle) определяем победителя, и в зависимости от этого:
                    Выводим соответствующее уведомление в чат типа:
                    SendRadioMessage(fractionid,COLOR_LIGHTRED,""{0088ff}[ Mafia War ]: Вы выиграли! {ffcc66}Ферма №%d теперь принадлежит вашей мафии");
                    (остальные уведы такж можно со стрел скопировать)

                    Если победила атакующая сторона - забираем ферму::
                        NarcoFarmInfo[farmid][dfiFraction] = fractionid;
                        NarcoFarmCreatePickup(farmid);
                        NarcoFarmSave(farmid);
                        
                    Если победили защитники - оставляем им, поздравляем с победой

        Если ферма никому не принадлежит:
            - То же самое, за исключением отсутствия необходимости уведомлять о чем-то вторую организацию и т.п.

            - Проверяем, если хоть один из участников без лаунчера - отменяем захват фулл
            - Спавнить NPC и отдельно обрабатывать их убийства (NarcoFarmBattle_OnPlayerGiveDamageNpc)
            - Как только убиваем всех - отдаем ферму атакующей мафии
            - Если все игроки умерли (в стадии) или вышли с территории - отменяем захват, вешаем кд может даже
*/

#define MAX_NARCO_FARMS_NPC            30 // Максимальное количество NPC на наркоферме

enum e_NarcoFarmBattleInfo {
    dfbiAttackFraction, // Организация, которая атакует
    dfbiDefendFraction, // Организация, которая защищает
    dfbiAttackers[MAX_REALPLAYERS], // ID аккаунтов атакующих
    dfbiDefenders[MAX_REALPLAYERS], // ID аккаунтов защитников
    dfbiAttackScore, // Количество убитых атакующих
    dfbiDefendScore, // Количество убитых защитников
    dfbiStartTime, // Время начала битвы
    dfbiEndTime, // Время окончания битвы
    dfbiPrepareTimer // Таймер подготовки
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

function NarcoFarmCreateBattleDelay(farmid, attack_fraction, bool: force)
{
    if (NarcoFarmIsBattleActive(farmid)) return 0;
    return NarcoFarmCreateBattle(farmid, attack_fraction, force);
}

stock NarcoFarmCreatePrepareTimer(farmid, attack_fraction, bool: force = false, delay = 600000)
{
    if (IsValidTimer(NarcoFarmBattleInfo[farmid][dfbiPrepareTimer])) KillTimer(NarcoFarmBattleInfo[farmid][dfbiPrepareTimer]);
    NarcoFarmBattleInfo[farmid][dfbiPrepareTimer] = SetTimerEx("NarcoFarmCreateBattleDelay", delay, false, "iii", farmid, attack_fraction, force);

    return 1;
}

stock NarcoFarmPrepareBattle(farmid, attack_fraction)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    if (NarcoFarmIsBattleActive(farmid)) return 0;

    NarcoFarmNotifyAboutBattle(farmid);
    NarcoFarmCreatePrepareTimer(farmid, attack_fraction, false);

    return 1;
}

stock NarcoFarmCreateBattle(farmid, attack_fraction, bool: force = false)
{
    if (!force && !NarcoFarmIsBattleReady(farmid)) return 0;
    if (NarcoFarmIsBattleActive(farmid)) return 0;

    if (!IsAMafiaID(NarcoFarmInfo[farmid][dfiFraction])) // Никому не принадлежит
    {
        for (new i = 0; i < MAX_NARCO_FARMS_NPC; i++)
        {
            if (NarcoFarmNpcPositions[farmid][i][0] == 0.0) continue;

            // TODO: Спавн NPC (помещаем ID в NarcoFarmNPC[farmid][i])
        }
    }
    
    NarcoFarmBattleInfo[farmid][dfbiAttackFraction] = attack_fraction;
    NarcoFarmBattleInfo[farmid][dfbiDefendFraction] = NarcoFarmInfo[farmid][dfiFraction];
    NarcoFarmTeleportVehicles(farmid);
    NarcoFarmRespawnPlayers(farmid);
    NarcoFarmUpdateBattle(farmid);

    return 1;
}

stock NarcoFarmIsBattleActive(farmid)
{
    return NarcoFarmBattleInfo[farmid][dfbiAttackFraction] > 0;
}

stock NarcoFarmFinishBattle(farmid)
{
    if (!NarcoFarmIsBattleActive(farmid)) return 0;

    // TODO: Определяем победителя, завершаем битву

    return 1;
}

stock NarcoFarmNotifyAboutBattle(farmid)
{
    if (NarcoFarmInfo[farmid][dfiAttackFraction] <= 0) return 0;

    new fractionid = NarcoFarmInfo[farmid][dfiFraction],
        attack_fraction = NarcoFarmInfo[farmid][dfiAttackFraction];

    // TODO: Отправка сообщений в обе мафии о предстоящем захвате фермы №%d

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
        if (fraction(playerid) == NarcoFarmBattleInfo[farmid][dfbiDefendFraction] && IsPlayerHaveMafFarmAccess(playerid))
        {
            PPSetPlayerPos(
                playerid,
                NarcoFarmInfo[farmid][dfiSpawnDefendersPos][0] + frand(-NARCO_FARMS_SPAWN_RADIUS, NARCO_FARMS_SPAWN_RADIUS),
                NarcoFarmInfo[farmid][dfiSpawnDefendersPos][1] + frand(-NARCO_FARMS_SPAWN_RADIUS, NARCO_FARMS_SPAWN_RADIUS),
                NarcoFarmInfo[farmid][dfiSpawnDefendersPos][2]
            );
            PPSetPlayerFacingAngle(playerid, NarcoFarmInfo[farmid][dfiSpawnDefendersPos][3]);
        } else if (fraction(playerid) == NarcoFarmBattleInfo[farmid][dfbiAttackFraction] && IsPlayerHaveMafFarmAccess(playerid))
        {
            PPSetPlayerPos(
                playerid,
                NarcoFarmInfo[farmid][dfiSpawnAttackersPos][0] + frand(-NARCO_FARMS_SPAWN_RADIUS, NARCO_FARMS_SPAWN_RADIUS),
                NarcoFarmInfo[farmid][dfiSpawnAttackersPos][1] + frand(-NARCO_FARMS_SPAWN_RADIUS, NARCO_FARMS_SPAWN_RADIUS),
                NarcoFarmInfo[farmid][dfiSpawnAttackersPos][2]
            );
            PPSetPlayerFacingAngle(playerid, NarcoFarmInfo[farmid][dfiSpawnAttackersPos][3]);
        } else continue; // скип всех прочих

        // TODO: PlayerPlaySound (возможно)
    }
    return 1;
}

function NarcoFarmUpdateBattle(farmid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    if (!NarcoFarmIsBattleActive(farmid)) return 0;

    // TODO: Отображаем/обновляем текстдрав с колвом убитых, временем и т.п. (просто взять со стрел - PlayerGangDraw, за исключением режима стрельбы и прочего)

    return SetTimerEx("NarcoFarmUpdateBattle", 1000, false, "i", farmid);
}

stock NarcoFarmIsBattleReady(farmid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    if (!NarcoFarmHasAttackers(farmid)) return 0;
    if (!NarcoFarmHasDefenders(farmid)) return 0;

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
        if (NarcoFarmIsInside(farmid) && NarcoFarmIsAttacker(farmid, id))
        {
            count++;
        }
    }
    return count;
}

stock NarcoFarmGetDefendersAmount(farmid)
{
    if (!NarcoFarmIsExists(farmid)) return 0;
    
    new count = 0;
    foreach (new id : Player)
    {
        if (NarcoFarmIsInside(farmid) && NarcoFarmIsDefender(farmid, id))
        {
            count++;
        }
    }
    return count;
}

stock CheckMafFarmKill(playerid, killerid)
{
    // Вызывается только при убийстве в пределах наркофермы

    // TODO: Обработка киллов игроков

    return 1;
}

stock NarcoFarmBattle_OnPlayerGiveDamageNpc(NPC: npc, damagerid, Float: amount, weaponid, bodypart)
{
    new farmid = NarcoFarmGetNearest(damagerid);
    
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
        if (!NarcoFarmIsExists(farmid)) return 0; // Отменяем урон по NPC, если атакующий вне фермы

        // TODO: Обработка дамага NPC (при первом захвате фермы)
    }

    return 1;
}

stock NarcoFarmEnterDynamicArea(playerid, farmid)
{
    // TODO: Обработка захода на территорию фермы
    return 1;
}

stock NarcoFarmLeaveDynamicArea(playerid, farmid)
{
    // TODO: Обработка выхода с территории фермы
    return 1;
}

stock IsPlayerHaveMafFarmAccess(playerid)
{
    return GetAccessRankOrg(playerid, fraction(playerid), 26, NO_FBI);
}

DIALOG_GENERATOR:mafiafarm(playerid)
{
    new farmid = NarcoFarmGetNearest(playerid);
    if (farmid == INVALID_NARCOFARM_ID) return ErrorMessage(playerid, "{FF6347}Вы не находитесь на территории наркофермы");

    /* TODO:
        Если команду вводит лидер/зам обороняющейся фраки на этапе подготовки - предлагаем скипнуть подготовку и начинаем через 30 сек:
        NarcoFarmCreatePrepareTimer(farmid, fraction(playerid), false, 30000); */

    SetDialogContextInt(playerid, "farmid", farmid);
    return 1;
}

CMD:mafiafarm(playerid, const params[])
{
    new g = fraction(playerid);
    if(!IsAFunctionOrganization(26, g, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не участник мафии");
	if(!GetAccessRankOrg(playerid, g, 26, NO_FBI)) return ErrorMessage(playerid, "{FF6347}У вас нет доступа к захвату наркофермы");
    if(!NarcoFarmIsInside(playerid)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь на территории наркофермы");

    return ShowAdvancedDialog(playerid, "mafiafarm");
}

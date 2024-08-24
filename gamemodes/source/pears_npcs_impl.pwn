static NPC:created_npcs[1024] = {INVALID_NPC, ...};

stock bool:IsValidNpcSlot(slotid) {
    return slotid >= 0 && slotid < sizeof(created_npcs);
}

stock bool:IsValidNpcInSlot(slotid) {
    return IsValidNpcSlot(slotid) && IsValidNpc(created_npcs[slotid]);
}

stock NPC:GetNpcInSlot(slotid) {
    return IsValidNpcInSlot(slotid) ? created_npcs[slotid] : INVALID_NPC;
}

stock FindAvailableNpcSlot() {
    for (new i = 0; i < sizeof(created_npcs); ++i) {
        if (!IsValidNpcInSlot(i)) {
            return i;
        }
    }
    return -1;
}

stock CreateNpcSlot(skinid, Float:x, Float:y, Float:z, world) {
    new available_slot = FindAvailableNpcSlot();
    if (available_slot == -1) return -1;
    created_npcs[available_slot] = CreateNpc(skinid, x, y, z);
    SetNpcVirtualWorld(created_npcs[available_slot], world);
    return available_slot;
}

stock bool:DestroyNpcSlot(slotid) {
    if (!IsValidNpcInSlot(slotid)) return false;

    DestroyNpc(created_npcs[slotid]);
    created_npcs[slotid] = INVALID_NPC;
    return true;
}

#define ASSERT_NPC_EXISTS(%0,%1)                                                            \
    new NPC:%0 = GetNpcInSlot(%1);                                                          \
    if (npc == INVALID_NPC) {                                                               \
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Данного бота не существует.");  \
        return 1;                                                                           \
    }

CMD:create_npc(playerid, const params[]) {
    if (PlayerInfo[playerid][pSoska] < 8) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

    new skinid = 0;
    if (sscanf(params, "i", skinid)) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Создать интерактивного бота [ /create_npc Скин ]");
        return 1;
    }

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    x += 0.25;
    y += 0.25;
    z += 0.25;
    
    new npc_slot = CreateNpcSlot(skinid, x, y, z, GetPlayerVirtualWorld(playerid));
    if (!IsValidNpcInSlot(npc_slot)) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Переполнен буфер возможных интерактивных ботов");
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Очистите их: [ /clear_npcs ]");
        return 1;
    }

    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Бот создан! ID: %d", npc_slot);
    return 1;
}

CMD:npc_attack(playerid, const params[]) {
    if (PlayerInfo[playerid][pSoska] < 8) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

    new npcid, targetid, bool: aggressive;
    if (sscanf(params, "iiI(0)", npcid, targetid, aggressive)) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Поручить боту атаковать игрока [ /npc_attack ID бота ID Цели Агрессивность* ]");
        return 1;
    }

    if (!IsPlayerConnected(targetid) || IsPlayerNPC(targetid)) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Он не в сети...");
        return 1;
    }
    
    if (npcid != -1) {
        ASSERT_NPC_EXISTS(npc, npcid)

        TaskNpcAttackPlayer(npc, targetid, aggressive);
    } else {
        for (new i = 0; i < sizeof(created_npcs); ++i) {
            if (!IsValidNpcInSlot(i)) continue;
            new NPC:npc = GetNpcInSlot(i);
            new Float:npc_x, Float:npc_y, Float:npc_z;
            GetNpcPosition(npc, npc_x, npc_y, npc_z);
            if (GetPlayerDistanceFromPoint(playerid, npc_x, npc_y, npc_z) <= 30.0) {
                TaskNpcAttackPlayer(npc, targetid, aggressive);
            }
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Готово!");
    return 1;
}

CMD:npc_stand(playerid, const params[]) {
    if (PlayerInfo[playerid][pSoska] < 8) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

    new npcid;
    if (sscanf(params, "i", npcid)) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Поручить боту стоять на месте [ /npc_stand ID бота ]");
        return 1;
    }
    
    if (npcid != -1) {
        ASSERT_NPC_EXISTS(npc, npcid)

        TaskNpcStandStill(npc);
    } else {
        for (new i = 0; i < sizeof(created_npcs); ++i) {
            if (!IsValidNpcInSlot(i)) continue;
            new NPC:npc = GetNpcInSlot(i);
            new Float:npc_x, Float:npc_y, Float:npc_z;
            GetNpcPosition(npc, npc_x, npc_y, npc_z);
            if (GetPlayerDistanceFromPoint(playerid, npc_x, npc_y, npc_z) <= 30.0) {
                TaskNpcStandStill(npc);
            }
        }
    }
    
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Готово!");
    return 1;
}

CMD:npc_go_here(playerid, const params[]) {
    if (PlayerInfo[playerid][pSoska] < 8) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

    new npcid, mode;
    if (sscanf(params, "ii", npcid, mode) || !(mode >= 0 && mode <= 2) ) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Поручить боту подойти ко мне [ /npc_go_here ID бота Режим ]");
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Режим: 0 - пешком, 1 - слегка бегая, 2 - спринт");
        return 1;
    }
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    if (npcid != -1) {
        ASSERT_NPC_EXISTS(npc, npcid)

        TaskNpcGoToPoint(npc, x, y, z, NPC_MOVE_MODE:mode);
    } else {
        for (new i = 0; i < sizeof(created_npcs); ++i) {
            if (!IsValidNpcInSlot(i)) continue;
            new NPC:npc = GetNpcInSlot(i);
            new Float:npc_x, Float:npc_y, Float:npc_z;
            GetNpcPosition(npc, npc_x, npc_y, npc_z);
            if (GetPlayerDistanceFromPoint(playerid, npc_x, npc_y, npc_z) <= 30.0) {
                TaskNpcGoToPoint(npc, x, y, z, NPC_MOVE_MODE:mode);
            }
        }
    }
    
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Готово!");
    return 1;
}

CMD:npc_go_random(playerid, const params[]) {
    if (PlayerInfo[playerid][pSoska] < 8) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

    new npcid, mode;
    if (sscanf(params, "ii", npcid, mode) || !(mode >= 0 && mode <= 2) ) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Поручить боту пойти в рандомном направлении вокруг меня [ /npc_go_random ID бота Режим ]");
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Режим: 0 - пешком, 1 - слегка бегая, 2 - спринт");
        return 1;
    }

    if (npcid != -1) {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);

        x += 10 + random(15);
        y += 10 + random(15);

        ASSERT_NPC_EXISTS(npc, npcid)
        TaskNpcGoToPoint(npc, x, y, z, NPC_MOVE_MODE:mode);
    } else {
        for (new i = 0; i < sizeof(created_npcs); ++i) {
            if (!IsValidNpcInSlot(i)) continue;

            new Float:x, Float:y, Float:z;
            GetPlayerPos(playerid, x, y, z);

            x += 10 + random(15);
            y += 10 + random(15);

            new NPC:npc = GetNpcInSlot(i);
            new Float:npc_x, Float:npc_y, Float:npc_z;
            GetNpcPosition(npc, npc_x, npc_y, npc_z);
            if (GetPlayerDistanceFromPoint(playerid, npc_x, npc_y, npc_z) <= 30.0) {
                TaskNpcGoToPoint(npc, x, y, z, NPC_MOVE_MODE:mode);
            }
        }
    }
    
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Готово!");
    return 1;
}

CMD:npc_follow(playerid, const params[]) {
    if (PlayerInfo[playerid][pSoska] < 8) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

    new npcid, targetid;
    if (sscanf(params, "ii", npcid, targetid)) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Поручить боту следовать за игроком [ /npc_attack ID бота ID Цели ]");
        return 1;
    }

    if (!IsPlayerConnected(targetid) || IsPlayerNPC(targetid)) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Он не в сети...");
        return 1;
    }
    
    if (npcid != -1) {
        ASSERT_NPC_EXISTS(npc, npcid)
        TaskNpcFollowPlayer(npc, targetid);
    } else {
        for (new i = 0; i < sizeof(created_npcs); ++i) {
            if (!IsValidNpcInSlot(i)) continue;
            new NPC:npc = GetNpcInSlot(i);
            new Float:npc_x, Float:npc_y, Float:npc_z;
            GetNpcPosition(npc, npc_x, npc_y, npc_z);
            if (GetPlayerDistanceFromPoint(playerid, npc_x, npc_y, npc_z) <= 30.0) {
                TaskNpcFollowPlayer(npc, targetid);
            }
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Готово!");
    return 1;
}

CMD:npc_sethp(playerid, const params[]) {
    if (PlayerInfo[playerid][pSoska] < 8) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

    new npcid, Float:amount;
    if (sscanf(params, "if", npcid, amount)) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Назначить боту кол-во ХП [ /npc_sethp ID бота Кол-во ХП ]");
        return 1;
    }
    
    if (npcid != -1) {
        ASSERT_NPC_EXISTS(npc, npcid)
        SetNpcHealth(npc, amount);
    } else {
        for (new i = 0; i < sizeof(created_npcs); ++i) {
            if (!IsValidNpcInSlot(i)) continue;
            new NPC:npc = GetNpcInSlot(i);
            new Float:npc_x, Float:npc_y, Float:npc_z;
            GetNpcPosition(npc, npc_x, npc_y, npc_z);
            if (GetPlayerDistanceFromPoint(playerid, npc_x, npc_y, npc_z) <= 30.0) {
                SetNpcHealth(npc, amount);
            }
        }
    }
    
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Готово!");
    return 1;
}

CMD:npc_setweapon(playerid, const params[]) {
    if (PlayerInfo[playerid][pSoska] < 8) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

    new npcid, weaponid;
    if (sscanf(params, "ii", npcid, weaponid)) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Дать боту оружие [ /npc_sethp ID бота ID оружия ]");
        return 1;
    }

    if (npcid != -1) {
        ASSERT_NPC_EXISTS(npc, npcid)
        SetNpcWeapon(npc, WEAPON:weaponid);
    } else {
        for (new i = 0; i < sizeof(created_npcs); ++i) {
            if (!IsValidNpcInSlot(i)) continue;
            new NPC:npc = GetNpcInSlot(i);
            new Float:npc_x, Float:npc_y, Float:npc_z;
            GetNpcPosition(npc, npc_x, npc_y, npc_z);
            if (GetPlayerDistanceFromPoint(playerid, npc_x, npc_y, npc_z) <= 30.0) {
                 SetNpcWeapon(npc, WEAPON:weaponid);
            }
        }
    }
    
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Готово!");
    return 1;
}

alias:npc_delete("npc_remove", "npc_clear", "npc_destroy")
CMD:npc_delete(playerid, const params[]) {
    if (PlayerInfo[playerid][pSoska] < 8) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

    new npcid;
    if (sscanf(params, "i", npcid)) {
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Удалить интерактивного бота [ /npc_delete ID бота ]");
        return 1;
    }
    
    if (npcid != -1) {
        ASSERT_NPC_EXISTS(npc, npcid)
        DestroyNpcSlot(npcid);
    } else {
        for (new i = 0; i < sizeof(created_npcs); ++i) {
            if (!IsValidNpcInSlot(i)) continue;
            new NPC:npc = GetNpcInSlot(i);
            new Float:npc_x, Float:npc_y, Float:npc_z;
            GetNpcPosition(npc, npc_x, npc_y, npc_z);
            if (GetPlayerDistanceFromPoint(playerid, npc_x, npc_y, npc_z) <= 30.0) {
                DestroyNpcSlot(npcid);
            }
        }
    }
    
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Готово!");
    return 1;
}

CMD:clear_npcs(playerid, const params[]) {
    if (PlayerInfo[playerid][pSoska] < 8) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
    
    new amount = 0;
    for (new i = 0; i < sizeof(created_npcs); ++i) {
        if (DestroyNpcSlot(i)) {
            ++amount;
        }
    }
    
    SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Готово! Очищено: %d", amount);
    return 1;
}

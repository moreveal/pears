#if !defined PEARS_HUD_INC_
    #define PEARS_HUD_INC_

    #define PEARS_HUD_RPC_ID 182

    enum HudRpcType {
        HUD_RPC_SET_HUNGER,
        HUD_RPC_SET_TIME_DATE,
        HUD_RPC_SET_HINTS_RENDER,
        HUD_RPC_SET_TASK_NAME_DESC,

        HUD_RPC_MAX
    };

    #if !defined __cplusplus
        stock SetPlayerHudHunger(const playerid, const hunger) {
            new BitStream:bs = BS_New();
            BS_WriteUint8(bs, _:HUD_RPC_SET_HUNGER);
            BS_WriteUint8(bs, hunger);
            PR_SendRPC(bs, playerid, PEARS_HUD_RPC_ID);
            BS_Delete(bs);
            return 1;
        }

        stock SetPlayerHudTimeDate(const playerid, const time_[], const date_[]) {
            new BitStream:bs = BS_New();
            BS_WriteUint8(bs, _:HUD_RPC_SET_TIME_DATE);
            BS_WriteUint8(bs, strlen(time_));
            BS_WriteString(bs, time_);
            BS_WriteUint8(bs, strlen(date_));
            BS_WriteString(bs, date_);
            PR_SendRPC(bs, playerid, PEARS_HUD_RPC_ID);
            BS_Delete(bs);
            return 1;
        }

        stock SetPlayerHudHintsRenderState(const playerid, const bool:enabled) {
            new BitStream:bs = BS_New();
            BS_WriteUint8(bs, _:HUD_RPC_SET_HINTS_RENDER);
            BS_WriteUint8(bs, enabled ? 1 : 0);
            PR_SendRPC(bs, playerid, PEARS_HUD_RPC_ID);
            BS_Delete(bs);
            return 1;
        }

        stock SetPlayerHudTask(const playerid, const name[], const description[]) {
            new BitStream:bs = BS_New();
            BS_WriteUint8(bs, _:HUD_RPC_SET_TASK_NAME_DESC);
            BS_WriteUint8(bs, strlen(name));
            BS_WriteString(bs, name);
            BS_WriteUint8(bs, strlen(description));
            BS_WriteString(bs, description);
            PR_SendRPC(bs, playerid, PEARS_HUD_RPC_ID);
            BS_Delete(bs);
            return 1;
        }
    #endif // !defined __cplusplus
#endif // PEARS_HUD_INC_

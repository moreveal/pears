const
    RPC_PLAYERGIVEDAMAGE = 115,
    RPC_SENDCLIENTMESSAGE = 93;

public OnIncomingRPC(playerid, rpcid, BitStream:bs)
{
    switch (rpcid)
    {
        case RPC_PLAYERGIVEDAMAGE:
        {
            new bool: type, id, Float: damage, weaponid, bodypart;
            BS_ReadValue(bs,
                PR_BOOL, type,
                PR_UINT16, id,
                PR_FLOAT, damage,
                PR_UINT32, weaponid,
                PR_UINT32, bodypart
            );
            if (type) {
                // Если урон получен вследствие взрыва - отправить его на обработку
                if (weaponid == 51) PlayerGiveDamageHandler(playerid, playerid, damage, weaponid, bodypart);
            }
        }
    }
    return 1;
}
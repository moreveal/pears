enum e_InfectProtectionTypes {
    INFECT_PROTECTION_NONE,
    INFECT_PROTECTION_SUPER_LOW,
    INFECT_PROTECTION_VERY_LOW,
    INFECT_PROTECTION_LOW,
    INFECT_PROTECTION_MEDIUM,
    INFECT_PROTECTION_HIGH,
    INFECT_PROTECTION_VERY_HIGH,
    INFECT_PROTECTION_EXTREME,
    INFECT_PROTECTION_ULTIMATE
};

stock e_InfectProtectionTypes: GetPlayerInfectProtectionType(playerid)
{
    new bool: medical_mask, bool: respirator, bool: mask, bool: enhanced_mask;
    
    for (new i = 0; i < 5; i++)
    {
        if (PlayerInfo[playerid][pOdet][i] == 12205)
            medical_mask = true;
        else if (PlayerInfo[playerid][pOdet][i] == 12376)
            respirator = true;
        else if (PlayerInfo[playerid][pOdet][i] == 12139)
            mask = true;
        else if (PlayerInfo[playerid][pOdet][i] == 12377)
            enhanced_mask = true;
    }

    new bool: black = PlayerInfo[playerid][pModel] == 613;
    new bool: orange =
        PlayerInfo[playerid][pModel] == 547 ||
        PlayerInfo[playerid][pModel] == 548 ||
        PlayerInfo[playerid][pModel] == 610 ||
        PlayerInfo[playerid][pModel] == 611;

    new bool: walter_white = PlayerInfo[playerid][pModel] == 614;
    new bool: white = PlayerInfo[playerid][pModel] == 612;

    if (walter_white)
        return INFECT_PROTECTION_ULTIMATE;
    if (enhanced_mask && orange)
        return INFECT_PROTECTION_ULTIMATE;
    if ((enhanced_mask || mask) && orange)
        return INFECT_PROTECTION_EXTREME;
    if ((enhanced_mask || mask) && black)
        return INFECT_PROTECTION_VERY_HIGH;
    if (respirator && black)
        return INFECT_PROTECTION_HIGH;
    if (respirator && white)
        return INFECT_PROTECTION_MEDIUM;
    if (medical_mask && white)
        return INFECT_PROTECTION_LOW;
    if (respirator || mask || enhanced_mask)
        return INFECT_PROTECTION_VERY_LOW;
    if (medical_mask)
        return INFECT_PROTECTION_SUPER_LOW;

     
    return INFECT_PROTECTION_NONE;
}

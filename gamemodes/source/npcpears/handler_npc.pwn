

forward IsNpcInRangeOfPoint(NPC:npc, Float:radius, Float:x, Float:y, Float:z);
public IsNpcInRangeOfPoint(NPC:npc, Float:radius, Float:x, Float:y, Float:z)
{
    new Float:posX, Float:posY, Float:posZ;
    GetNpcPosition(npc, posX, posY, posZ);
    
    new Float:distance = GetDistanceBetweenCoords3d(posX, posY, posZ, x, y, z);

    if(distance <= radius) return true;
    return false;
}

forward IsNpcNearby(Float:radi, playerid, NPC:npc);
public IsNpcNearby(Float:radi, playerid, NPC:npc)
{
    if(IsPlayerConnected(playerid) && IsValidNpc(npc))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		GetNpcPosition(npc, posx, posy, posz);

		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		tempposz = (oldposz -posz);

		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			if(GetPlayerVirtualWorld(playerid) == GetNpcVirtualWorld(npc))
			{
				return 1;
			}
		}
	}
	
	return 0;
}

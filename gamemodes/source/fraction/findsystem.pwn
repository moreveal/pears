#define MAX_FIND_ZONE 50
new FindZones[MAX_FIND_ZONE];
new ZoneTimer[MAX_FIND_ZONE];

new FindZone[MAX_REALPLAYERS];

stock CreateFindZone(Float:X, Float:Y)
{
  new findz;
  for(new z = 0; z < MAX_FIND_ZONE; z++) 
  {
    if(FindZones[z] == 0)
    {
      FindZones[z] = GangZoneCreate(X - 60.0, Y - 60.0, X + 60.0, Y + 60.0);
      findz = z;
      break;
    }
  }
  return findz+88;
}

stock ShowFindZone(playerid, Float:x,Float:y)
{
  FindZone[playerid] = CreateFindZone(x, y);
  if(FindZone[playerid] == 0) return ErrorMessage(playerid, "Нельзя найти на данный момент человека, попробуйте позже");
  hideGangZones(playerid);
  GangZoneShowForPlayer(playerid, FindZone[playerid], 0xff0000AA);
  ZoneTimer[playerid] = 12;
  return 1;
}
stock DestroyFindZone(playerid)
{
  if(FindZone[playerid] == 0) return 0;
  new number = FindZone[playerid];
  FindZones[number-88] = 0;
  GangZoneDestroy(FindZone[playerid]);
  FindZone[playerid] = 0;
  showGangZones(playerid);
  return 1;
}

CMD:find(playerid, const params[])
{
	if(PlayerInfo[playerid][pBkyrenie] >= 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Чего, блин ?! Я не на земле");
	if(PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pLeader] == 1 || PlayerInfo[playerid][pLeader] == 2 || PlayerInfo[playerid][pMember] == 2 || PlayerInfo[playerid][pLeader] == 3 || PlayerInfo[playerid][pMember] == 3 || PlayerInfo[playerid][pFbi] >= 1
	|| PlayerInfo[playerid][pLeader] == 8 || PlayerInfo[playerid][pMember] == 8 || PlayerInfo[playerid][pLeader] == 4 || PlayerInfo[playerid][pMember] == 4 || PlayerInfo[playerid][pLeader] == 11 || PlayerInfo[playerid][pMember] == 11
	|| PlayerInfo[playerid][pLeader] == 21 || PlayerInfo[playerid][pMember] == 21|| PlayerInfo[playerid][pLeader] == 22 || PlayerInfo[playerid][pMember] == 22)
	{
		if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Поиск человека {ffcc00}[ /find ID ]");
		if(strlen(params[0]) > 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Слишком длинное имя [ Лимит 20 символов ]");
  		new giveplayerid = ReturnUser(params[0]);
  		// if(giveplayerid == playerid) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Зачем мне искать себя ?");
    	if(IsPlayerConnected(giveplayerid))
    	{
        if(ZoneTimer[playerid] > 0) return ErrorMessage(playerid, "У вас активна зона поиска, дождитесь её окончания");
        //if(ADUTY[giveplayerid] == 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Этот человек в другом помещении, я не могу его найти");
        //if(GetPlayerState(giveplayerid) == PLAYER_STATE_SPECTATING && gSpectateID[giveplayerid] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Этот человек в другом помещении, я не могу его найти");
        //if(GetPlayerColor(giveplayerid) == 0xFFFFFF00) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Этот человек в другом помещении, я не могу его найти");
        new Float:X,Float:Y,Float:Z;
        if(GetPlayerInterior(giveplayerid) != 0 || GetPlayerVirtualWorld(giveplayerid) != 0)
        {
          X = PlayerInfo[giveplayerid][find_X];
          Y = PlayerInfo[giveplayerid][find_Y];
        } 
        else 
        {
          GetPlayerPos(giveplayerid, X,Y,Z);
        }
        new rand = random(12);
        switch(rand)
        {
          case 0: X+=10.0, Y-=10.0;
          case 1: X-=10.0, Y+=10.0;
          case 2: X+=10.0, Y+=10.0;
          case 3: X-=10.0, Y-=10.0;
          case 4: X+=20.0, Y-=10.0;
          case 5: X-=20.0, Y+=10.0;
          case 6: X+=20.0, Y+=10.0;
          case 7: X-=20.0, Y-=10.0;
          case 8: X+=10.0, Y-=20.0;
          case 9: X-=10.0, Y+=20.0;
          case 10: X+=10.0, Y+=20.0;
          case 11: X-=10.0, Y-=20.0;
        }
        ShowFindZone(playerid, X, Y);
		}
		else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не знаю кого искать");
	}
	else SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу искать человека");
	return 1;
}
#define MAX_FIND_ZONE 50
new zoneId[MAX_FIND_ZONE];
new ZoneTimer[MAX_REALPLAYERS];

new FindZone[MAX_REALPLAYERS] = {-1, ...};
new FindCd[MAX_REALPLAYERS];

stock CreateFindZone(playerid, Float:X, Float:Y)
{
  DestroyFindZone(playerid);

  new ability = get_ability(playerid, 9); // Навык сыщика
  new Float:zone;

  if(ability >= 10) zone = 50;
  else if(ability == 9) zone = 62;
  else if(ability == 8) zone = 74;
  else if(ability == 7) zone = 86;
  else if(ability == 6) zone = 98;
  else if(ability == 5) zone = 110;
  else if(ability == 4) zone = 122;
  else if(ability == 3) zone = 134;
  else if(ability == 2) zone = 146;
  else zone = 158;

  new findz = -1;
  for(new z = 0; z < MAX_FIND_ZONE; z++) 
  {
    if(zoneId[z] == 0)
    {
      zoneId[z] = GangZoneCreate(X - zone, Y - zone, X + zone, Y + zone);
      findz = z;
      break;
    }
  }
  return findz;
}

stock ShowFindZone(playerid, giveplayerid, Float:x, Float:y, findraiontolist, bool: message = true)
{
  FindZone[playerid] = CreateFindZone(playerid, x, y);
  if(FindZone[playerid] == -1) return ErrorMessage(playerid, "{FF6347}Нельзя найти на данный момент человека, попробуйте позже");

  new string[160];
  new unix = gettime();
  if(FindCd[playerid] > unix)
  {
    if (message) {
      format(string,sizeof(string), "{FF6347}Вы можете повторно использовать поиск через %s\n\n{cccccc}Ограничение становится меньше с повышением навыка", fine_time(FindCd[playerid] - unix));
      ErrorMessage(playerid, string);
    }
    return 1;
  }

  hideGangZones(playerid);
  GangZoneShowForPlayer(playerid, zoneId[FindZone[playerid]], 0xff0000AA);
  SetPVarInt(playerid, "GP", 1);
  SetPlayerCheckpoint(playerid, x, y, 20.0, 5.0);
  ZoneTimer[playerid] = 12;

  new ability = get_ability(playerid, 9);
  new cd;
  if(ability >= 10) cd = 0;
  else if(ability == 9) cd = 10;
  else if(ability == 8) cd = 20;
  else if(ability == 7) cd = 30;
  else if(ability == 6) cd = 40;
  else if(ability == 5) cd = 50;
  else if(ability == 4) cd = 60;
  else if(ability == 3) cd = 70;
  else if(ability == 2) cd = 80;
  else cd = 90;
  FindCd[playerid] = unix + cd;

  /*new line[140],lines[420];
  format(line,sizeof(line),"{ffcc66}Поиск %s активирован\n{0088ff}Гражданин находится в области {FF6347}красной зоны {0088ff}на карте", rpplayername(giveplayerid)), strcat(lines,line);
  format(line,sizeof(line), "\n\n{cccccc}Отображение зоны продлится в течении 12 секунд"), strcat(lines,line);
  format(line,sizeof(line), "\n{cccccc}Размер зоны поиска зависит от вашего навыка детектива"), strcat(lines,line);
  SuccessMessage(playerid, lines);*/
  PlayerPlaySound(playerid,6400,0,0,0);
  if (message)
  {
    format(string,sizeof(string),"{cccccc}[ Мысли ]: Я начал поиск {FFD700}%s{cccccc}, квадрат отмечен на GPS. Он в районе: {FFD700}%s.", rpplayername(giveplayerid), gSAZones[findraiontolist][zName]);
    SendClientMessage(playerid,COLOR_GREY,string);
    update_ability(playerid, 9, 10 + random(5));
  }
  return 1;
}
stock DestroyFindZone(playerid)
{
  if(FindZone[playerid] == -1) return 0;

  DisablePlayerCheckpoint(playerid);
  DeletePVar(playerid, "GP");

  new number = FindZone[playerid];
  GangZoneDestroy(zoneId[number]);
  zoneId[number] = 0;
  FindZone[playerid] = -1;
  showGangZones(playerid);
  
  return 1;
}

CMD:find(playerid, const params[])
{
  if(PlayerInfo[playerid][pMember] == 1 || PlayerInfo[playerid][pLeader] == 1 || PlayerInfo[playerid][pLeader] == 2 || PlayerInfo[playerid][pMember] == 2 || PlayerInfo[playerid][pLeader] == 3 || PlayerInfo[playerid][pMember] == 3 || PlayerInfo[playerid][pFbi] >= 1
  || PlayerInfo[playerid][pLeader] == 8 || PlayerInfo[playerid][pMember] == 8 || PlayerInfo[playerid][pLeader] == 4 || PlayerInfo[playerid][pMember] == 4 || PlayerInfo[playerid][pLeader] == 11 || PlayerInfo[playerid][pMember] == 11
  || PlayerInfo[playerid][pLeader] == 21 || PlayerInfo[playerid][pMember] == 21|| PlayerInfo[playerid][pLeader] == 22 || PlayerInfo[playerid][pMember] == 22)
  {
    if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Поиск человека {ffcc00}[ /find ID ]");
    if(strlen(params[0]) > 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Слишком длинное имя [ Лимит 20 символов ]");
    new giveplayerid = ReturnUser(params[0]);
    if(giveplayerid == playerid && server > 0) return ErrorMessage(playerid, "{FF6347}Вы не можете искать себя");
    if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Этот игрок не в сети, или ещё не залогинился");
    if(IsARealNPC(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Это NPC");

    if(MPGO[giveplayerid]) return ErrorMessage(playerid, "{FF6347}Этот игрок на мероприятии");

    if(ZoneTimer[playerid] > 0) return ErrorMessage(playerid, "{FF6347}У вас активна зона поиска, дождитесь её окончания");
    if(PlayerInfo[giveplayerid][pBkyrenie] >= 2) return ErrorMessage(playerid, "{FF6347}Спутники не могут зафиксировать местоположение этого гражданина\n\n{cccccc}Возможно, он участник экспедиции NASA");

    new Float:X,Float:Y,Float:Z;
    GetPlayerRealPos(giveplayerid, X, Y, Z);

    if(X == 0.0 && Y == 0.0) return ErrorMessage(playerid, "{FF6347}Спутники не могут зафиксировать местоположение этого гражданина\n\n{cccccc}Игрок только зашёл на сервер и находится в неизвестной точке спавна");
    
    new Float:rand_x = 5 + random(30), Float:rand_y = 5 + random(30);
    switch(random(4))
    {
      case 0: X += rand_x, Y += rand_y;
      case 1: X -= rand_x, Y -= rand_y;
      case 2: X += rand_x, Y -= rand_y;
      case 3: X -= rand_x, Y += rand_y;
    }
    new findraiontolist = FindRaionPos(X,Y,Z);
    ShowFindZone(playerid, giveplayerid, X, Y,findraiontolist);
  }
  else ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду\n\n{cccccc}Только для сотрудников правоохранительных органов");
  return 1;
}

CMD:clearfinds(playerid)
{
  if(PlayerInfo[playerid][pSoska] < 20) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу выполнить это действие");

  new total = 0;
  for (new i = 0; i < MAX_REALPLAYERS; i++)
  {
    if (DestroyFindZone(i))
    {
      if (IsPlayerConnected(i))
      {
        SendClientMessage(playerid, -1, "%s (%d) очищен", PlayerInfo[i][pName], i);
      }
      else
      {
        SendClientMessage(playerid, -1, "Оффлайн (%d) очищен", i);
      }
      ZoneTimer[i] = 0;
      total++;
    }
  }
  SendClientMessage(playerid, -1, "Очищено: %d", total);
  return 1;
}

stock WhiteFindPlayerPos(playerid, Float:x, Float:y, Float:z)
{
	PlayerInfo[playerid][find_X] = x;
	PlayerInfo[playerid][find_Y] = y;
	PlayerInfo[playerid][find_Z] = z;
	return 1;
}
stock GetPlayerRealPos(playerid, &Float:x, &Float:y, &Float:z)
{
  new boot_vehicleid = GetPVarInt(playerid, "Boot");
  if(boot_vehicleid > 0) // В багажнике
  {
      GetVehiclePos(boot_vehicleid, x, y, z);
  }
  else if(IsPlayerInRangeOfPoint(playerid,30.0,1305.7756,1604.4343,19.7263) && GetPlayerVirtualWorld(playerid) == 180 && GetPlayerInterior(playerid) == 179) // В поезде
  {
      GetVehiclePos(train, x, y, z);
  }
  else 
  {
      if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) // В интерьере
      {
          x = PlayerInfo[playerid][find_X];
          y = PlayerInfo[playerid][find_Y];
          z = PlayerInfo[playerid][find_Z];
      } 
      else if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) // На улице
      {
          x = Protect_X[playerid];
          y = Protect_Y[playerid];
          z = Protect_Z[playerid];
      }
  }
  return 1;
}

stock FindRaion(playerid)
{
  new districtId;
  new Float:X,Float:Y,Float:Z;
  GetPlayerRealPos(playerid, X, Y, Z);
  for(new i;i < sizeof(gSAZones);i ++)
  {
    if(IsPosInCube(X,Y,Z, gSAZones[i][FindZonePos][0], gSAZones[i][FindZonePos][1], gSAZones[i][FindZonePos][2], gSAZones[i][FindZonePos][3], gSAZones[i][FindZonePos][4], gSAZones[i][FindZonePos][5]))
    {
      districtId = i;
      break;
    }
  }
  return districtId;
}

stock FindRaionPos(Float:x,Float:y,Float:z)
{
  new districtId;
  for(new i;i < sizeof(gSAZones);i ++)
  {
    if(IsPosInCube(x,y,z,gSAZones[i][FindZonePos][0], gSAZones[i][FindZonePos][1], gSAZones[i][FindZonePos][2], gSAZones[i][FindZonePos][3], gSAZones[i][FindZonePos][4], gSAZones[i][FindZonePos][5]))
    {
      districtId = i;
      break;
    }
  }
  return districtId;
}

stock IsPlayerInCubeForFind(playerid, Float:minx, Float:miny, Float:minz, Float:maxx, Float:maxy, Float:maxz)
{
  new Float:x, Float:y, Float:z;
  GetPlayerPos(playerid, x, y, z);
  if(GetPlayerVirtualWorld(playerid) > 0)
  {
    x = PlayerInfo[playerid][find_X];
    y = PlayerInfo[playerid][find_Y];
    z = PlayerInfo[playerid][find_Z];
  }
  if(x > minx && x < maxx && y > miny && y < maxy && z > minz && z < maxz) return 1;
  return 0;
}

stock IsPlayerRealPosInRangeOfPoint(playerid, Float:radius, Float:get_x, Float:get_y, Float:get_z)
{
  new Float:x, Float:y, Float:z;
  GetPlayerPos(playerid, x, y, z);
  if(GetPlayerVirtualWorld(playerid) > 0)
  {
    x = PlayerInfo[playerid][find_X];
    y = PlayerInfo[playerid][find_Y];
    z = PlayerInfo[playerid][find_Z];
  }
    
  // Вычисляем расстояние от игрока до заданной точки
  new Float:distance = GetDistanceBetweenCoords3d(x, y, z, get_x, get_y, get_z);
    
  // Проверяем, находится ли игрок в заданном радиусе
  if(distance <= radius)
  {
    return true;
  }
  return false;
}

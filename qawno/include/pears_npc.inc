#if defined _INC_npc_plugin
	#endinput
#endif
#define _INC_npc_plugin

#pragma tabsize 4

#define INVALID_NPC NPC:0xFFFF

enum NPC_MOVE_MODE
{
  NPC_MOVE_MODE_WALK   = 0,
  NPC_MOVE_MODE_RUN    = 1,
  NPC_MOVE_MODE_SPRINT = 2
};

enum NPC_SKILL_TYPE
{
  NPC_SKILL_TYPE_POOR = 0,
  NPC_SKILL_TYPE_STD  = 1,
  NPC_SKILL_TYPE_PRO  = 2
};

/*
                                                                           
    888b      88                       88                                      
    8888b     88                ,d     ""                                      
    88 `8b    88                88                                             
    88  `8b   88  ,adPPYYba,  MM88MMM  88  8b       d8   ,adPPYba,  ,adPPYba,  
    88   `8b  88  ""     `Y8    88     88  `8b     d8'  a8P_____88  I8[    ""  
    88    `8b 88  ,adPPPPP88    88     88   `8b   d8'   8PP"""""""   `"Y8ba,   
    88     `8888  88,    ,88    88,    88    `8b,d8'    "8b,   ,aa  aa    ]8I  
    88      `888  `"8bbdP"Y8    "Y888  88      "8"       `"Ybbd8"'  `"YbbdP"'  
                                                                           
                                                                           

*/

native NPC:CreateNpc(skin, Float:x, Float:y, Float:z);
native bool:DestroyNpc(NPC:npc);
native bool:IsValidNpc(NPC:npc);

native bool:IsNpcStreamedIn(NPC:npc, playerid);

native GetNpcVirtualWorld(NPC:npc);
native bool:SetNpcVirtualWorld(NPC:npc, worldid);

native bool:GetNpcPosition(NPC:npc, &Float:x, &Float:y, &Float:z);
native bool:SetNpcPosition(NPC:npc, Float:x, Float:y, Float:z);

native bool:GetNpcFacingAngle(NPC:npc, &Float:health);
native bool:SetNpcFacingAngle(NPC:npc, Float:health);

native bool:IsNpcInvulnerable(NPC:npc);
native bool:SetNpcInvulnerable(NPC:npc, bool:invulnerable = true);

native bool:IsNpcStunAnimationEnabled(NPC:npc);
native bool:SetNpcStunAnimationEnabled(NPC:npc, bool:enabled = true);

native bool:GetNpcHealth(NPC:npc, &Float:health);
native bool:SetNpcHealth(NPC:npc, Float:health);

native GetNpcSkin(NPC:npc);
native bool:SetNpcSkin(NPC:npc, skin);

native WEAPON:GetNpcWeapon(NPC:npc);
native bool:SetNpcWeapon(NPC:npc, WEAPON:weaponid);
native bool:SetNpcWeaponShootingAccuracy(NPC:npc, accuracy);
native bool:SetNpcWeaponShootingRate(NPC:npc, shootingrate);
native bool:SetNpcWeaponSkill(NPC:npc, NPC_SKILL_TYPE:skill);

native bool:PutNpcInVehicle(NPC:npc, vehicleid, seat);
native bool:RemoveNpcFromVehicle(NPC:npc);
native GetNpcVehicleID(NPC:npc);
native GetNpcVehicleSeat(NPC:npc);
native bool:IsNpcInVehicle(NPC:npc, vehicleid);
native bool:IsNpcInAnyVehicle(NPC:npc);

native bool:TaskNpcStandStill(NPC:npc);
native bool:TaskNpcAttackPlayer(NPC:npc, playerid, bool:aggressive = false);
native bool:TaskNpcAttackNpc(NPC:npc, NPC:target, bool:aggressive = false);
native bool:TaskNpcGoToPoint(NPC:npc, Float:x, Float:y, Float:z, NPC_MOVE_MODE:mode = NPC_MOVE_MODE_WALK);
native bool:TaskNpcFollowPlayer(NPC:npc, playerid);
native bool:TaskNpcPlayAnimation(NPC:npc, const animationLibrary[], const animationName[], Float:delta, bool:loop, bool:lockX, bool:lockY, bool:freeze, time);

/*

      ,ad8888ba,               88  88  88                                   88
     d8"'    `"8b              88  88  88                                   88
    d8'                        88  88  88                                   88
    88             ,adPPYYba,  88  88  88,dPPYba,   ,adPPYYba,   ,adPPYba,  88   ,d8   ,adPPYba,
    88             ""     `Y8  88  88  88P'    "8a  ""     `Y8  a8"     ""  88 ,a8"    I8[    ""
    Y8,            ,adPPPPP88  88  88  88       d8  ,adPPPPP88  8b          8888[       `"Y8ba,
     Y8a.    .a8P  88,    ,88  88  88  88b,   ,a8"  88,    ,88  "8a,   ,aa  88`"Yba,   aa    ]8I
      `"Y8888Y"'   `"8bbdP"Y8  88  88  8Y"Ybbd8"'   `"8bbdP"Y8   `"Ybbd8"'  88   `Y8a  `"YbbdP"'



*/

forward bool:OnPlayerGiveDamageNpc(NPC:npc, damagerid, Float:amount, weaponid, bodypart);
forward bool:OnNpcGiveDamageNpc(NPC:npc, NPC:damager, Float:amount, weaponid, bodypart);
forward OnPlayerTakeDamageNpc(NPC:npc, issuerid, Float:amount, weaponid, bodypart);
forward OnNpcDeath(NPC:npc, killerid, reason);

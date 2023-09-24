/*

	About: Supports SAMP 0.3.7-0.3.DL sync custom models v2.6.3
	Author: PawnoCoder

*/

#if !defined _samp_included
	#error "Please include a_samp or a_npc before m_custom-sync"
#endif

#if !defined PAWNRAKNET_INC_
	#error "You must have Pawn.RakNet include in order to use this one."
#endif

#if defined _m_custom_sync_included_
	#endinput
#endif
#define _m_custom_sync_included_

/*
	Define const
*/

#if !defined MAX_TEAMS
	#define MAX_TEAMS 256
#endif

#if !defined MAX_CUSTOM_MODEL_ID
	#define MAX_CUSTOM_MODEL_ID 5000
#endif

#if !defined NO_CHAR_MODEL_FILE
	#define NO_CHAR_MODEL_FILE 1
#endif

#if !defined NO_VEHICLE_MODEL_FILE
	#define NO_VEHICLE_MODEL_FILE 400
#endif

#if !defined NO_OBJECT_MODEL_FILE
	#define NO_OBJECT_MODEL_FILE 18631
#endif

#if !defined M_CUSTOM_CustomForPlayers
	#define M_CUSTOM_CustomForPlayers 1
#else
	#undef M_CUSTOM_CustomForPlayers
	#define M_CUSTOM_CustomForPlayers 0
#endif

#if !defined M_CUSTOM_CustomForActors
	#define M_CUSTOM_CustomForActors 1
#else
	#undef M_CUSTOM_CustomForActors
	#define M_CUSTOM_CustomForActors 0
#endif

#if !defined M_CUSTOM_CustomForVehicles
	#define M_CUSTOM_CustomForVehicles 1
#else
	#undef M_CUSTOM_CustomForVehicles
	#define M_CUSTOM_CustomForVehicles 0
#endif

#if !defined M_CUSTOM_CustomForObjects
	#define M_CUSTOM_CustomForObjects 0
#else
	#undef M_CUSTOM_CustomForObjects
	#define M_CUSTOM_CustomForObjects 1
#endif

/*
	Natives
*/

#if !defined IsValidVehicle
	native IsValidVehicle(vehicleid);
#endif

/*
	Consts
*/

#if M_CUSTOM_CustomForPlayers
	const CS_RPC_WorldPlayerAdd = 32;
	const CS_RPC_SetSpawnInfo = 68;
	const CS_RPC_RequestClass = 128;
	const CS_RPC_SetPlayerSkin = 153;
#endif
#if M_CUSTOM_CustomForActors
	const CS_RPC_ShowActor = 171;
#endif
#if M_CUSTOM_CustomForVehicles
	const CS_RPC_WorldVehicleAdd = 164;
#endif
#if M_CUSTOM_CustomForObjects
	const CS_RPC_CreateObject = 44;
#endif

/*
	Vars
*/

static
	bool:c_player_sync_models[MAX_PLAYERS char];

#if M_CUSTOM_CustomForPlayers
	static
		c_team_model_id[MAX_TEAMS],
		c_player_model_id[MAX_PLAYERS];
#endif

#if M_CUSTOM_CustomForActors
	static
		c_actor_model_id[MAX_ACTORS];
#endif

#if M_CUSTOM_CustomForVehicles
	static
		c_vehicle_model_id[MAX_VEHICLES];
#endif

#if M_CUSTOM_CustomForPlayers || M_CUSTOM_CustomForActors || M_CUSTOM_CustomForVehicles || M_CUSTOM_CustomForObjects
	static
		c_custom_models[MAX_CUSTOM_MODEL_ID] = {-1, ...};
#endif

/*
	SetPlayerSyncModels
*/

stock SetPlayerSyncModels(playerid, bool:toggle)
{
	c_player_sync_models{playerid} = toggle;
	return 1;
}

/*
	IsPlayerSyncModels
*/

stock IsPlayerSyncModels(playerid)
{
	return _:c_player_sync_models{playerid};
}

#if M_CUSTOM_CustomForPlayers || M_CUSTOM_CustomForActors

	/*
		AddCharSyncModel
	*/

	stock AddCharSyncModel(baseid, newid)
	{
		if (!(312 <= newid < MAX_CUSTOM_MODEL_ID))
			return 0;
		c_custom_models[newid] = baseid;
		return 1;
	}

	#if M_CUSTOM_CustomForPlayers

		/*
			GetPlayerSyncSkin
		*/

		stock GetPlayerSyncSkin(playerid)
		{
			if (!IsPlayerConnected(playerid))
				return 0;
			if(c_player_model_id[playerid] >= 15500) return c_player_model_id[playerid] - 15100;
			else return c_player_model_id[playerid];
		}

		// Получаем id оригинального скина игрока
		stock GetSkinOriginal(playerid)
		{
			new skinId;
			if(GetPlayerSyncSkin(playerid) > 311) skinId = c_custom_models[GetPlayerSyncSkin(playerid)]; // Если скин кастомный, возвращаем id оригинальной заменки
			else skinId = GetPlayerSyncSkin(playerid); // Если скин обычный, возвращаем обычную модель
			return skinId;
		}

		stock GetSkinModelOriginal(s)
		{
			new skinId;
			if(s > 311) skinId = c_custom_models[s - 15100];
			else skinId = s;
			return skinId;
		}

	#endif
#endif

#if M_CUSTOM_CustomForVehicles

	/*
		AddVehicleSyncModel
	*/

	stock AddVehicleSyncModel(baseid, newid)
	{
		if (!(612 <= newid < MAX_CUSTOM_MODEL_ID))
			return 0;
		c_custom_models[newid] = baseid;
		return 1;
	}

	/*
		GetVehicleSyncModel
	*/

	stock GetVehicleSyncModel(vehicleid)
	{
		if (!IsValidVehicle(vehicleid))
			return 0;
		return c_vehicle_model_id[vehicleid];
	}
#endif

#if M_CUSTOM_CustomForObjects

	/*
		AddSimpleSyncModel
	*/

	stock AddSimpleSyncModel(baseid, newid)
	{
		if (!(612 <= newid < MAX_CUSTOM_MODEL_ID))
			return 0;
		c_custom_models[newid] = baseid;
		return 1;
	}
#endif

#if M_CUSTOM_CustomForPlayers

	/*
		SetPlayerSkin
	*/

	stock m_custom_sync_SetPlayerSkin(playerid, skinid)
	{
		new realskin = skinid;
		if(skinid >= 15500) skinid -= 15100;

		new
			newid = skinid;

		if (312 <= realskin < MAX_CUSTOM_MODEL_ID) {
			if (c_custom_models[skinid] != -1)
				skinid = c_custom_models[skinid];
			else
			{
				newid =
				skinid = NO_CHAR_MODEL_FILE;
			}
		}

		if(realskin >= 15500) 
		{
			skinid += 15100;
			newid = skinid;
		}

		c_player_model_id[playerid] = newid;

		return SetPlayerSkin(playerid, skinid);
	}
	#if defined _ALS_SetPlayerSkin
		#undef SetPlayerSkin
	#else
		#define _ALS_SetPlayerSkin
	#endif

	#define SetPlayerSkin( m_custom_sync_SetPlayerSkin(

	/*
		SetSpawnInfo
	*/

	stock m_custom_sync_SetSpawnInfo(playerid, team, skin, Float:x, Float:y, Float:z, Float:rotation, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo)
	{
		new realskin = skin;
		if(skin >= 15500) skin -= 15100;

		new
			newid = skin;

		if (312 <= realskin < MAX_CUSTOM_MODEL_ID) {
			if (c_custom_models[skin] != -1)
				skin = c_custom_models[skin];
			else
			{
				newid =
				skin = NO_CHAR_MODEL_FILE;
			}
		}
		if(realskin >= 15500) 
		{
			skin += 15100;
			newid = skin;
		}

		c_team_model_id[team] =
		c_player_model_id[playerid] = newid;

		return SetSpawnInfo(playerid, team, skin, x, y, z, rotation, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo);
	}
	#if defined _ALS_SetSpawnInfo
		#undef SetSpawnInfo
	#else
		#define _ALS_SetSpawnInfo
	#endif

	#define SetSpawnInfo( m_custom_sync_SetSpawnInfo(
#endif

#if M_CUSTOM_CustomForActors

	/*
		CreateActor
	*/

	stock m_custom_sync_CreateActor(modelid, Float:X, Float:Y, Float:Z, Float:Rotation)
	{
		new
			newid = modelid;

		if (312 <= modelid < MAX_CUSTOM_MODEL_ID) {
			if (c_custom_models[modelid] != -1)
				modelid = c_custom_models[modelid];
			else
				newid =
				modelid = NO_CHAR_MODEL_FILE;
		}

		new
			actorid = CreateActor(modelid, X, Y, Z, Rotation);

		if (actorid != INVALID_ACTOR_ID)
			c_actor_model_id[actorid] = newid;
		return actorid;
	}
	#if defined _ALS_CreateActor
		#undef CreateActor
	#else
		#define _ALS_CreateActor
	#endif

	#define CreateActor( m_custom_sync_CreateActor(
#endif

#if M_CUSTOM_CustomForVehicles

	/*
		AddStaticVehicle
	*/

	stock m_custom_sync_AddStaticVehicle(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2)
	{
		new
			newid = modelid;

		if (612 <= modelid < MAX_CUSTOM_MODEL_ID) {
			if (c_custom_models[modelid] != -1)
				modelid = c_custom_models[modelid];
			else
				newid =
				modelid = NO_VEHICLE_MODEL_FILE;
		}

		new
			vehicleid = AddStaticVehicle(modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2);

		if (vehicleid != INVALID_VEHICLE_ID)
			c_vehicle_model_id[vehicleid] = newid;
		return vehicleid;
	}
	#if defined _ALS_AddStaticVehicle
		#undef AddStaticVehicle
	#else
		#define _ALS_AddStaticVehicle
	#endif

	#define AddStaticVehicle( m_custom_sync_AddStaticVehicle(

	/*
		AddStaticVehicleEx
	*/

	stock m_custom_sync_AddStaticVehEx(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2, respawn_delay, addsiren=0)
	{
		new
			newid = modelid;

		if (612 <= modelid < MAX_CUSTOM_MODEL_ID) {
			if (c_custom_models[modelid] != -1)
				modelid = c_custom_models[modelid];
			else
				newid =
				modelid = NO_VEHICLE_MODEL_FILE;
		}

		new
			vehicleid = AddStaticVehicleEx(modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2, respawn_delay, addsiren);

		if (vehicleid != INVALID_VEHICLE_ID)
			c_vehicle_model_id[vehicleid] = newid;
		return vehicleid;
	}
	#if defined _ALS_AddStaticVehicleEx
		#undef AddStaticVehicleEx
	#else
		#define _ALS_AddStaticVehicleEx
	#endif

	#define AddStaticVehicleEx( m_custom_sync_AddStaticVehEx(

	/*
		CreateVehicle
	*/

	stock m_custom_sync_CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren=0)
	{
		new
			newid = vehicletype;

		if (612 <= vehicletype < MAX_CUSTOM_MODEL_ID) {
			if (c_custom_models[vehicletype] != -1)
				vehicletype = c_custom_models[vehicletype];
			else
				newid =
				vehicletype = NO_VEHICLE_MODEL_FILE;
		}

		new
			vehicleid = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, respawn_delay, addsiren);

		if (vehicleid != INVALID_VEHICLE_ID)
			c_vehicle_model_id[vehicleid] = newid;
		return vehicleid;
	}
	#if defined _ALS_CreateVehicle
		#undef CreateVehicle
	#else
		#define _ALS_CreateVehicle
	#endif

	#define CreateVehicle( m_custom_sync_CreateVehicle(
#endif

/*
	OnPlayerDisconnect
*/

public OnPlayerDisconnect(playerid, reason)
{
	c_player_sync_models{playerid} = false;

	#if defined m_custom_sync_OnPlayerDisconnec
		return m_custom_sync_OnPlayerDisconnec(playerid, reason);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect m_custom_sync_OnPlayerDisconnec
#if defined m_custom_sync_OnPlayerDisconnec
	forward m_custom_sync_OnPlayerDisconnec(playerid, reason);
#endif

/*
	ORPC
*/

#if M_CUSTOM_CustomForPlayers
	ORPC:CS_RPC_WorldPlayerAdd(playerid, BitStream:bs)
	{
		static
			wPlayerID;

		BS_ReadUint16(bs, wPlayerID);

		if (312 <= c_player_model_id[wPlayerID] < MAX_CUSTOM_MODEL_ID) 
		{

			static
				offset;

			BS_GetWriteOffset(bs, offset);

			BS_SetWriteOffset(bs, 24);

			if (c_player_sync_models{playerid} == false)
			{
				new updateid;
				if(c_player_model_id[wPlayerID] >= 15500) updateid = c_player_model_id[wPlayerID] -= 15100;
				else updateid = c_player_model_id[wPlayerID];

				BS_WriteUint32(bs, c_custom_models[updateid]);
			}
			else
				BS_WriteUint32(bs, c_player_model_id[wPlayerID]);

			BS_SetWriteOffset(bs, offset);

			#if defined PR_SendRPC
				PR_SendRPC(bs, playerid, CS_RPC_WorldPlayerAdd);
			#else
				BS_RPC(bs, playerid, CS_RPC_WorldPlayerAdd);
			#endif
			return 0;
		}

		return 1;
	}

	ORPC:CS_RPC_SetSpawnInfo(playerid, BitStream:bs)
	{
		static
			byteTeam;

		BS_ReadUint8(bs, byteTeam);

		if (312 <= c_team_model_id[byteTeam] < MAX_CUSTOM_MODEL_ID) {

			static
				offset;

			BS_GetWriteOffset(bs, offset);

			BS_SetWriteOffset(bs, 8);

			if (c_player_sync_models{playerid} == false)
			{
				new updateid;
				if(c_team_model_id[byteTeam] >= 15500) updateid = c_team_model_id[byteTeam] - 15100;
				else updateid = c_team_model_id[byteTeam];

				BS_WriteInt32(bs, c_custom_models[updateid]);
			}
			else
				BS_WriteInt32(bs, c_team_model_id[byteTeam]);

			BS_SetWriteOffset(bs, offset);

			#if defined PR_SendRPC
				PR_SendRPC(bs, playerid, CS_RPC_SetSpawnInfo);
			#else
				BS_RPC(bs, playerid, CS_RPC_SetSpawnInfo);
			#endif
			return 0;
		}

		return 1;
	}

	ORPC:CS_RPC_RequestClass(playerid, BitStream:bs)
	{
		static
			byteTeam;

		BS_SetReadOffset(bs, 8);
		BS_ReadUint8(bs, byteTeam);

		if (312 <= c_team_model_id[byteTeam] < MAX_CUSTOM_MODEL_ID) {

			static
				offset;

			BS_GetWriteOffset(bs, offset);

			BS_SetWriteOffset(bs, 16);

			if (c_player_sync_models{playerid} == false)
			{
				new updateid;
				if(c_team_model_id[byteTeam] >= 15500) updateid = c_team_model_id[byteTeam] - 15100;
				else updateid = c_team_model_id[byteTeam];

				BS_WriteInt32(bs, c_custom_models[updateid]);
			}
			else
				BS_WriteInt32(bs, c_team_model_id[byteTeam]);

			BS_SetWriteOffset(bs, offset);

			#if defined PR_SendRPC
				PR_SendRPC(bs, playerid, CS_RPC_RequestClass);
			#else
				BS_RPC(bs, playerid, CS_RPC_RequestClass);
			#endif
			return 0;
		}

		return 1;
	}

	ORPC:CS_RPC_SetPlayerSkin(playerid, BitStream:bs)
	{
		static
			wPlayerID;

		#if defined GetPlayerCustomSkin
			BS_ReadUint16(bs, wPlayerID);
		#else
			BS_ReadUint32(bs, wPlayerID);
		#endif

		if (312 <= c_player_model_id[wPlayerID] < MAX_CUSTOM_MODEL_ID) {

			static
				offset;

			BS_GetWriteOffset(bs, offset);

			#if defined GetPlayerCustomSkin
				BS_SetWriteOffset(bs, 16);
			#else
				BS_SetWriteOffset(bs, 32);
			#endif

			if (c_player_sync_models{playerid} == false)
			{
				new updateid;
				if(c_player_model_id[wPlayerID] >= 15500) updateid = c_player_model_id[wPlayerID] -= 15100;
				else updateid = c_player_model_id[wPlayerID];

				BS_WriteUint32(bs, c_custom_models[updateid]);
			}
			else
				BS_WriteUint32(bs, c_player_model_id[wPlayerID]);

			BS_SetWriteOffset(bs, offset);

			#if defined PR_SendRPC
				PR_SendRPC(bs, playerid, CS_RPC_SetPlayerSkin);
			#else
				BS_RPC(bs, playerid, CS_RPC_SetPlayerSkin);
			#endif
			return 0;
		}

		return 1;
	}
#endif

#if M_CUSTOM_CustomForActors
	ORPC:CS_RPC_ShowActor(playerid, BitStream:bs)
	{
		static
			wActorID;

		BS_ReadUint16(bs, wActorID);

		if (312 <= c_actor_model_id[wActorID] < MAX_CUSTOM_MODEL_ID) {

			static
				offset;

			BS_GetWriteOffset(bs, offset);

			BS_SetWriteOffset(bs, 16);

			if (c_player_sync_models{playerid} == false)
				BS_WriteUint32(bs, c_custom_models[c_actor_model_id[wActorID]]);
			else
				BS_WriteUint32(bs, c_actor_model_id[wActorID]);

			BS_SetWriteOffset(bs, offset);

			#if defined PR_SendRPC
				PR_SendRPC(bs, playerid, CS_RPC_ShowActor);
			#else
				BS_RPC(bs, playerid, CS_RPC_ShowActor);
			#endif
			return 0;
		}

		return 1;
	}
#endif

#if M_CUSTOM_CustomForVehicles
	ORPC:CS_RPC_WorldVehicleAdd(playerid, BitStream:bs)
	{
		static
			wVehicleID;

		BS_ReadInt16(bs, wVehicleID);

		if (612 <= c_vehicle_model_id[wVehicleID] < MAX_CUSTOM_MODEL_ID) {

			static
				offset;

			BS_GetWriteOffset(bs, offset);

			BS_SetWriteOffset(bs, 16);

			if (c_player_sync_models{playerid} == false)
				BS_WriteInt32(bs, c_custom_models[c_vehicle_model_id[wVehicleID]]);
			else
				BS_WriteInt32(bs, c_vehicle_model_id[wVehicleID]);

			BS_SetWriteOffset(bs, offset);

			#if defined PR_SendRPC
				PR_SendRPC(bs, playerid, CS_RPC_WorldVehicleAdd);
			#else
				BS_RPC(bs, playerid, CS_RPC_WorldVehicleAdd);
			#endif
			return 0;
		}

		return 1;
	}
#endif

#if M_CUSTOM_CustomForObjects
	ORPC:CS_RPC_CreateObject(playerid, BitStream:bs)
	{
		if (c_player_sync_models{playerid} == true)
			return 1;

		static
			ModelID;

		BS_SetReadOffset(bs, 16);
		BS_ReadInt32(bs, ModelID);

		if (612 <= c_custom_models[ModelID] < MAX_CUSTOM_MODEL_ID) {

			static
				offset;

			BS_GetWriteOffset(bs, offset);

			BS_SetWriteOffset(bs, 16);
			BS_WriteInt32(bs, NO_OBJECT_MODEL_FILE);

			BS_SetWriteOffset(bs, offset);

			#if defined PR_SendRPC
				PR_SendRPC(bs, playerid, CS_RPC_CreateObject);
			#else
				BS_RPC(bs, playerid, CS_RPC_CreateObject);
			#endif
			return 0;
		}

		return 1;
	}
#endif
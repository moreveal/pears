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

		stock GetPlayerSyncSkin(playerid) // +
		{
			if (!IsPlayerConnected(playerid))
				return 0;
			return c_player_model_id[playerid];
		}

		stock GetSkinModelOriginal(s) // +
		{
			new skinId;
			if(s >= 312) skinId = c_custom_models[s];
			else skinId = s;
			return skinId;
		}

		stock GetVehModelOriginal(s) // +
		{
			new skinId;
			if(s > 611) skinId = c_custom_models[s];
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
		new
			newid = skinid;

		if (312 <= skinid < MAX_CUSTOM_MODEL_ID) {
			if (c_custom_models[skinid] != -1)
			{
				skinid = c_custom_models[skinid];
			}
			else
				newid =
				skinid = NO_CHAR_MODEL_FILE;
		}
		c_player_model_id[playerid] = newid;

		if(skinid >= 312) skinid += 15188;
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
		new
			newid = skin;

		if (312 <= skin < MAX_CUSTOM_MODEL_ID) {
			if (c_custom_models[skin] != -1)
				skin = c_custom_models[skin];
			else
				newid =
				skin = NO_CHAR_MODEL_FILE;
		}
		c_team_model_id[team] =
		c_player_model_id[playerid] = newid;

		if(skin >= 312) skin += 15188;
		return SetSpawnInfo(playerid, team, skin, x, y, z, rotation, WEAPON:weapon1, weapon1_ammo, WEAPON:weapon2, weapon2_ammo, WEAPON:weapon3, weapon3_ammo);
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
		CreateDynamicActor
	*/

	stock m_custom_sync_CreateDActor(modelid, Float:X, Float:Y, Float:Z, Float:Rotation, invulnerable = true, Float:health = 100.0, worldid = 0, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_ACTOR_SD, STREAMER_TAG_AREA:areaid = STREAMER_TAG_AREA:-1, priority = 0)
	{
		//c_actor_model_id[actorid] = newid;

		if(modelid >= 312) modelid += 15188;
		new actorid = CreateDynamicActor(modelid, X, Y, Z, Rotation, invulnerable, health, worldid, interiorid, playerid, streamdistance, areaid, priority);

		return actorid;
	}

/*
	stock m_custom_sync_SetPlayerSkin(playerid, skinid)
	{
		new
			newid = skinid;

		if (312 <= skinid < MAX_CUSTOM_MODEL_ID) {
			if (c_custom_models[skinid] != -1)
				skinid = c_custom_models[skinid];
			else
				newid =
				skinid = NO_CHAR_MODEL_FILE;
		}
		c_player_model_id[playerid] = newid;

		if(skinid >= 312) skinid += 15188;
		return SetPlayerSkin(playerid, skinid);
	}
	*/





	#if defined _ALS_CreateDynamicActor
		#undef CreateDynamicActor
	#else
		#define _ALS_CreateDynamicActor
	#endif

	#define CreateDynamicActor( m_custom_sync_CreateDActor(
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

	stock m_custom_sync_AddStaticVehEx(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2, respawn_delay, bool:addsiren = false)
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

	stock m_custom_sync_CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, bool:addsiren = false)
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
		if(playerid == -1) return false;

		static
			wPlayerID;

		BS_ReadUint16(bs, wPlayerID);

		if (312 <= c_player_model_id[wPlayerID] < MAX_CUSTOM_MODEL_ID) {

			static
				offset;

			BS_GetWriteOffset(bs, offset);

			BS_SetWriteOffset(bs, 24);

			if (c_player_sync_models{playerid} == false) BS_WriteUint32(bs, c_custom_models[c_player_model_id[wPlayerID]]); // No Launcher
			else
			{
				new showModel = c_player_model_id[wPlayerID];
				if(showModel >= 312) showModel += 15188;
				BS_WriteUint32(bs, showModel);
			}
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
		if(playerid == -1) return false;
		
		static
			byteTeam;

		BS_ReadUint8(bs, byteTeam);

		if (312 <= c_team_model_id[byteTeam] < MAX_CUSTOM_MODEL_ID) {

			static
				offset;

			BS_GetWriteOffset(bs, offset);

			BS_SetWriteOffset(bs, 8);

			if (c_player_sync_models{playerid} == false) BS_WriteInt32(bs, c_custom_models[c_team_model_id[byteTeam]]); // No Launcher
			else 
			{
				new showModel = c_team_model_id[byteTeam];
				if(showModel >= 312) showModel += 15188;
				BS_WriteInt32(bs, showModel);
			}

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
		if(playerid == -1) return false;

		static
			byteTeam;

		BS_SetReadOffset(bs, 8);
		BS_ReadUint8(bs, byteTeam);

		if (312 <= c_team_model_id[byteTeam] < MAX_CUSTOM_MODEL_ID) {

			static
				offset;

			BS_GetWriteOffset(bs, offset);

			BS_SetWriteOffset(bs, 16);

			if (c_player_sync_models{playerid} == false) BS_WriteInt32(bs, c_custom_models[c_team_model_id[byteTeam]]); // No Launcher
			else
			{
				new showModel = c_team_model_id[byteTeam];
				if(showModel >= 312) showModel += 15188;
				BS_WriteInt32(bs, showModel);
			}
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
		if(playerid == -1) return false;

		static
			wPlayerID;

		/*#if defined GetPlayerCustomSkin
			BS_ReadUint16(bs, wPlayerID);
		#else
			BS_ReadUint32(bs, wPlayerID);
		#endif*/

		BS_ReadUint32(bs, wPlayerID);

		if (312 <= c_player_model_id[wPlayerID] < MAX_CUSTOM_MODEL_ID) {

			static
				offset;

			BS_GetWriteOffset(bs, offset);

			/*#if defined GetPlayerCustomSkin
				BS_SetWriteOffset(bs, 16);
			#else
				BS_SetWriteOffset(bs, 32);
			#endif*/

			BS_SetWriteOffset(bs, 32);

			if (c_player_sync_models{playerid} == false) BS_WriteUint32(bs, c_custom_models[c_player_model_id[wPlayerID]]); // No Launcher
			else
			{
				new showModel = c_player_model_id[wPlayerID];
				if(showModel >= 312) showModel += 15188;
				BS_WriteUint32(bs, showModel);
			}
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
		if(playerid == -1) return false;

		static wActorID = -1, wModelID;

		BS_ReadUint16(bs, wActorID);
		BS_ReadUint32(bs, wModelID);

		if(wActorID >= 0)
		{
			if(wModelID >= 15500) 
			{
				static offset;

				BS_GetWriteOffset(bs, offset);
				BS_SetWriteOffset(bs, 16);

				if (c_player_sync_models{playerid} == false) BS_WriteUint32(bs, c_custom_models[wModelID - 15188]); // No Launcher
				else
				{
					new showModel = wModelID;
					BS_WriteUint32(bs, showModel);
				}
				BS_SetWriteOffset(bs, offset);

				#if defined PR_SendRPC
					PR_SendRPC(bs, playerid, CS_RPC_ShowActor);
				#else
					BS_RPC(bs, playerid, CS_RPC_ShowActor);
				#endif
				return 0;
			}
		}

		return 1;
	}
#endif

#if M_CUSTOM_CustomForVehicles
	ORPC:CS_RPC_WorldVehicleAdd(playerid, BitStream:bs)
	{
		if(playerid == -1) return false;

		static
			wVehicleID;

		BS_ReadInt16(bs, wVehicleID);

		if (612 <= c_vehicle_model_id[wVehicleID] < MAX_CUSTOM_MODEL_ID) {

			static
				offset;

			BS_GetWriteOffset(bs, offset);

			BS_SetWriteOffset(bs, 16);

			if (c_player_sync_models{playerid} == false) BS_WriteUint32(bs, c_custom_models[c_vehicle_model_id[wVehicleID]]); // No Launcher
			else
			{
				new showModel = c_vehicle_model_id[wVehicleID];
				if(showModel >= 612) showModel += 13066;
				BS_WriteUint32(bs, showModel);
			}
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
		if(playerid == -1) return false;

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

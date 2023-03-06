/*

	About: Supports SAMP 0.3.7-0.3.DL sync custom models v2.4
	Author: Noname

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

#if !defined MAX_CUSTOM_CHARS
	#define MAX_CUSTOM_CHARS 5000
#endif

#if !defined MAX_CUSTOM_VEHICLES
	#define MAX_CUSTOM_VEHICLES 5000
#endif

#if !defined NO_CHAR_MODEL_FILE
	#define NO_CHAR_MODEL_FILE 1
#endif

#if !defined NO_VEHICLE_MODEL_FILE
	#define NO_VEHICLE_MODEL_FILE 400
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
	const RPC_WorldPlayerAdd = 32;
	const RPC_SetSpawnInfo = 68;
	const RPC_RequestClass = 128;
	const RPC_SetPlayerSkin = 153;
#endif
#if M_CUSTOM_CustomForActors
	const RPC_ShowActor = 171;
#endif
#if M_CUSTOM_CustomForVehicles
	const RPC_WorldVehicleAdd = 164;
#endif

/*
	Vars
*/

static
	bool:c_player_launcher[MAX_PLAYERS char];

#if M_CUSTOM_CustomForPlayers || M_CUSTOM_CustomForActors
	static
		c_char_models[MAX_CUSTOM_CHARS] = {-1, ...};

	#if M_CUSTOM_CustomForPlayers
		static
			c_team_model_id[MAX_TEAMS],
			c_player_model_id[MAX_PLAYERS];
	#endif

	#if M_CUSTOM_CustomForActors
		static
			c_actor_model_id[MAX_ACTORS];
	#endif
#endif

#if M_CUSTOM_CustomForVehicles
	static
		c_vehicle_models[MAX_CUSTOM_VEHICLES] = {-1, ...},
		c_vehicle_model_id[MAX_VEHICLES];
#endif

/*
	SetPlayerLauncher
*/

stock SetPlayerLauncher(playerid, bool:toggle)
{
	c_player_launcher{playerid} = toggle;
	return 1;
}

/*
	IsPlayerLauncher
*/

stock IsPlayerLauncher(playerid)
{
	return _:c_player_launcher{playerid};
}

#if M_CUSTOM_CustomForPlayers || M_CUSTOM_CustomForActors

	/*
		AddCharSyncModel
	*/

	stock AddCharSyncModel(baseid, newid)
	{
		if (!(312 <= newid <= MAX_CUSTOM_CHARS))
			return 0;
		c_char_models[newid] = baseid;
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
			return c_player_model_id[playerid];
		}
	#endif
#endif

#if M_CUSTOM_CustomForVehicles

	/*
		AddVehicleSyncModel
	*/

	stock AddVehicleSyncModel(baseid, newid)
	{
		if (!(612 <= newid <= MAX_CUSTOM_VEHICLES))
			return 0;
		c_vehicle_models[newid] = baseid;
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

/*
	OnOutcomingRPC
*/

#if M_CUSTOM_CustomForPlayers || M_CUSTOM_CustomForActors || M_CUSTOM_CustomForVehicles
	public OnOutcomingRPC(playerid, rpcid, BitStream:bs)
	{
		switch (rpcid) {
		#if M_CUSTOM_CustomForPlayers
			case RPC_WorldPlayerAdd: {

				static
					wPlayerID;

				BS_ReadUint16(bs, wPlayerID);

				if (312 <= c_player_model_id[wPlayerID] <= MAX_CUSTOM_CHARS) 
				{

					static
						offset;

					BS_GetWriteOffset(bs, offset);

					BS_SetWriteOffset(bs, 24);

					if (c_player_launcher{playerid} == false)
						BS_WriteUint32(bs, c_char_models[c_player_model_id[wPlayerID]]);
					else
						BS_WriteUint32(bs, c_player_model_id[wPlayerID]);

					BS_SetWriteOffset(bs, offset);

					PR_SendRPC(bs, playerid, rpcid);
					return 0;
				}
			}
			case RPC_SetSpawnInfo: {

				static
					byteTeam;

				BS_ReadUint8(bs, byteTeam);

				if (312 <= c_team_model_id[byteTeam] <= MAX_CUSTOM_CHARS) {

					static
						offset;

					BS_GetWriteOffset(bs, offset);

					BS_SetWriteOffset(bs, 8);

					if (c_player_launcher{playerid} == false)
						BS_WriteInt32(bs, c_char_models[c_team_model_id[byteTeam]]);
					else
						BS_WriteInt32(bs, c_team_model_id[byteTeam]);

					BS_SetWriteOffset(bs, offset);

					PR_SendRPC(bs, playerid, rpcid);
					return 0;
				}
			}
			case RPC_RequestClass: {

				static
					byteTeam;

				BS_SetReadOffset(bs, 8);
				BS_ReadUint8(bs, byteTeam);

				if (312 <= c_team_model_id[byteTeam] <= MAX_CUSTOM_CHARS) {

					static
						offset;

					BS_GetWriteOffset(bs, offset);

					BS_SetWriteOffset(bs, 16);

					if (c_player_launcher{playerid} == false)
						BS_WriteInt32(bs, c_char_models[c_team_model_id[byteTeam]]);
					else
						BS_WriteInt32(bs, c_team_model_id[byteTeam]);

					BS_SetWriteOffset(bs, offset);

					PR_SendRPC(bs, playerid, rpcid);
					return 0;
				}
			}
			case RPC_SetPlayerSkin: {

				static
					wPlayerID;

				#if defined GetPlayerCustomSkin
					BS_ReadUint16(bs, wPlayerID);
				#else
					BS_ReadUint32(bs, wPlayerID);
				#endif

				if (312 <= c_player_model_id[wPlayerID] <= MAX_CUSTOM_CHARS) {

					static
						offset;

					BS_GetWriteOffset(bs, offset);

					#if defined GetPlayerCustomSkin
						BS_SetWriteOffset(bs, 16);
					#else
						BS_SetWriteOffset(bs, 32);
					#endif

					if (c_player_launcher{playerid} == false)
						BS_WriteUint32(bs, c_char_models[c_player_model_id[wPlayerID]]);
					else
						BS_WriteUint32(bs, c_player_model_id[wPlayerID]);

					BS_SetWriteOffset(bs, offset);

					PR_SendRPC(bs, playerid, rpcid);
					return 0;
				}
			}
		#endif
		#if M_CUSTOM_CustomForActors
			case RPC_ShowActor: {

				static
					wActorID;

				BS_ReadUint16(bs, wActorID);

				if (312 <= c_actor_model_id[wActorID] <= MAX_CUSTOM_CHARS) {

					static
						offset;

					BS_GetWriteOffset(bs, offset);

					BS_SetWriteOffset(bs, 16);

					if (c_player_launcher{playerid} == false)
						BS_WriteUint32(bs, c_char_models[c_actor_model_id[wActorID]]);
					else
						BS_WriteUint32(bs, c_actor_model_id[wActorID]);

					BS_SetWriteOffset(bs, offset);

					PR_SendRPC(bs, playerid, rpcid);
					return 0;
				}
			}
		#endif
		#if M_CUSTOM_CustomForVehicles
			case RPC_WorldVehicleAdd: {

				static
					wVehicleID;

				BS_ReadInt16(bs, wVehicleID);

				if (612 <= c_vehicle_model_id[wVehicleID] <= MAX_CUSTOM_VEHICLES) {

					static
						offset;

					BS_GetWriteOffset(bs, offset);

					BS_SetWriteOffset(bs, 16);

					if (c_player_launcher{playerid} == false)
						BS_WriteInt32(bs, c_vehicle_models[c_vehicle_model_id[wVehicleID]]);
					else
						BS_WriteInt32(bs, c_vehicle_model_id[wVehicleID]);

					BS_SetWriteOffset(bs, offset);

					PR_SendRPC(bs, playerid, rpcid);
					return 0;
				}
			}
		#endif
		}

		#if defined m_custom_sync_OnOutcomingRPC
			return m_custom_sync_OnOutcomingRPC(playerid, rpcid, bs);
		#else
			return 1;
		#endif
	}

	#if defined _ALS_OnOutcomingRPC
		#undef OnOutcomingRPC
	#else
		#define _ALS_OnOutcomingRPC
	#endif
	#define OnOutcomingRPC m_custom_sync_OnOutcomingRPC
	#if defined m_custom_sync_OnOutcomingRPC
		forward m_custom_sync_OnOutcomingRPC(playerid, rpcid, BitStream:bs);
	#endif
#endif

#if M_CUSTOM_CustomForPlayers

	/*
		SetPlayerSkin
	*/

	stock m_custom_sync_SetPlayerSkin(playerid, skinid)
	{
		new
			newid = skinid;

		if (312 <= skinid <= MAX_CUSTOM_CHARS) 
		{
			if (c_char_models[skinid] != -1)
			{
				skinid = c_char_models[skinid];
			}
			else
			{
				newid =
				skinid = NO_CHAR_MODEL_FILE;
			}
		}
		c_player_model_id[playerid] = newid;
		return SetPlayerSkin(playerid, skinid);
	}
	#if defined _ALS_SetPlayerSkin
		#undef SetPlayerSkin
	#else
		#define _ALS_SetPlayerSkin
	#endif

	#define SetPlayerSkin m_custom_sync_SetPlayerSkin

	/*
		SetSpawnInfo
	*/

	stock m_custom_sync_SetSpawnInfo(playerid, team, skin, Float:x, Float:y, Float:z, Float:rotation, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo)
	{
		new
			newid = skin;

		if (312 <= skin <= MAX_CUSTOM_CHARS) {
			if (c_char_models[skin] != -1)
				skin = c_char_models[skin];
			else
				newid =
				skin = NO_CHAR_MODEL_FILE;
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

	#define SetSpawnInfo m_custom_sync_SetSpawnInfo
#endif

#if M_CUSTOM_CustomForActors

	/*
		CreateActor
	*/

	stock m_custom_sync_CreateActor(modelid, Float:X, Float:Y, Float:Z, Float:Rotation)
	{
		new
			newid = modelid;

		if (312 <= modelid <= MAX_CUSTOM_CHARS) {
			if (c_char_models[modelid] != -1)
				modelid = c_char_models[modelid];
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

	#define CreateActor m_custom_sync_CreateActor
#endif

#if M_CUSTOM_CustomForVehicles

	/*
		AddStaticVehicle
	*/

	stock m_custom_sync_AddStaticVehicle(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2)
	{
		new
			newid = modelid;

		if (612 <= modelid <= MAX_CUSTOM_VEHICLES) {
			if (c_vehicle_models[modelid] != -1)
				modelid = c_vehicle_models[modelid];
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

	#define AddStaticVehicle m_custom_sync_AddStaticVehicle

	/*
		AddStaticVehicleEx
	*/

	stock m_custom_sync_AddStaticVehEx(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2, respawn_delay, addsiren=0)
	{
		new
			newid = modelid;

		if (612 <= modelid <= MAX_CUSTOM_VEHICLES) {
			if (c_vehicle_models[modelid] != -1)
				modelid = c_vehicle_models[modelid];
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

	#define AddStaticVehicleEx m_custom_sync_AddStaticVehEx

	/*
		CreateVehicle
	*/

	stock m_custom_sync_CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren=0)
	{
		new
			newid = vehicletype;

		if (612 <= vehicletype <= MAX_CUSTOM_VEHICLES) {
			if (c_vehicle_models[vehicletype] != -1)
				vehicletype = c_vehicle_models[vehicletype];
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

	#define CreateVehicle m_custom_sync_CreateVehicle
#endif
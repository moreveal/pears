/*
    include guard
*/

#if defined _numerous_cp_included
    #endinput
#endif
#define _numerous_cp_included

/*
	check libs
*/

#if !defined _streamer_included
    #error "Please included <streamer> before include <numerous_cp>"
#endif

#if !defined _FOREACH_LOCAL_VERSION
    #error "Please included <foreach> before include <numerous_cp>"
#endif

/* 
    definitions
*/

const Float: NCP_VERSION = 1.0;

#if !defined NCP_INVALID_DYNAMIC_AREA
    const NCP_INVALID_DYNAMIC_AREA = -1;
#endif

#if !defined NCP_INVALID_ID
    const NCP_INVALID_ID = -1;
#endif 

#if !defined MAX_NCP_COUNT
    const MAX_NCP_COUNT = 100;
#endif

/*
	enums
*/

enum E_PLAYER_NCP_INFO
{
    bool: E_PLAYER_NCP_IS_SHOW[MAX_NCP_COUNT],
    E_PLAYER_NCP_AREA[MAX_NCP_COUNT]
};

/*
	vars
*/

static
	g_ncp_object_id,
    g_player_ncp_info[MAX_PLAYERS][E_PLAYER_NCP_INFO],
    Iterator: g_ncp_iterator<MAX_NCP_COUNT>;

static const NULL_g_player_ncp_info[E_PLAYER_NCP_INFO] = 
{
    false,
    NCP_INVALID_DYNAMIC_AREA
};

/* 
    forwards
*/

forward OnPlayerEnterNCP(playerid, ncpid);
forward OnPlayerLeaveNCP(playerid, ncpid);

/*  
    hook OnGameModeInit
*/

public OnGameModeInit()
{
    print("----------------------------------");
    printf("Numerous checkpoints: система успешно загружена. Версия: %.1f", NCP_VERSION);
    print("by: aureliusnull\nСпециально для pawn-wiki.ru");
    print("----------------------------------"); 

    #if defined ncp_OnGameModeInit
		return ncp_OnGameModeInit();
	#else
		return true;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif

#define OnGameModeInit ncp_OnGameModeInit
#if defined ncp_OnGameModeInit
    forward ncp_OnGameModeInit();
#endif

/*
    hook OnPlayerConnect
*/

public OnPlayerConnect(playerid)
{
    foreach (new i : g_ncp_iterator) {
        g_player_ncp_info[playerid][E_PLAYER_NCP_IS_SHOW][i] = NULL_g_player_ncp_info[E_PLAYER_NCP_IS_SHOW];
        g_player_ncp_info[playerid][E_PLAYER_NCP_AREA][i] = NULL_g_player_ncp_info[E_PLAYER_NCP_AREA];
    }

	#if defined ncp_OnPlayerConnect
		return ncp_OnPlayerConnect(playerid);
	#else
		return true;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect ncp_OnPlayerConnect
#if defined ncp_OnPlayerConnect
    forward ncp_OnPlayerConnect(playerid);
#endif

/* 
    hook OnPlayerDisconnect
*/

public OnPlayerDisconnect(playerid, reason)
{
    foreach (new i : g_ncp_iterator) {
        if (!ncp_IsPlayerEntered(playerid, i)) {
            continue;
        }

		ncp_PlayerDestroy(playerid, i);
    }

	#if defined ncp_OnPlayerDisconnect
		return ncp_OnPlayerDisconnect(playerid, reason);
	#else
		return true;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect ncp_OnPlayerDisconnect
#if defined ncp_OnPlayerDisconnect
	forward ncp_OnPlayerDisconnect(playerid, reason);
#endif

/* 
    hook OnPlayerEnterDynamicArea
*/

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    foreach (new i : g_ncp_iterator) {
		if (areaid == g_player_ncp_info[playerid][E_PLAYER_NCP_AREA][i]) {
			#if defined FILTERSCRIPT
				CallRemoteFunction("OnPlayerEnterNCP", "dd", playerid, i);
			#else
				CallLocalFunction("OnPlayerEnterNCP", "dd", playerid, i);
			#endif
		}
	}
	#if defined ncp_OnPlayerEnterDynamicArea
		return ncp_OnPlayerEnterDynamicArea(playerid, areaid);
	#else
		return true;
	#endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif

#define OnPlayerEnterDynamicArea ncp_OnPlayerEnterDynamicArea
#if defined ncp_OnPlayerEnterDynamicArea
	forward ncp_OnPlayerEnterDynamicArea(playerid, areaid);
#endif

/* 
    hook OnPlayerLeaveDynamicArea
*/

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    foreach (new i : g_ncp_iterator) {
		if (areaid == g_player_ncp_info[playerid][E_PLAYER_NCP_AREA][i]) {
			#if defined FILTERSCRIPT
				CallRemoteFunction("OnPlayerLeaveNCP", "dd", playerid, i);
			#else
				CallLocalFunction("OnPlayerLeaveNCP", "dd", playerid, i);
			#endif
		}
	}
	#if defined ncp_OnPlayerLeaveDynamicArea
		return ncp_OnPlayerLeaveDynamicArea(playerid, areaid);
	#else
		return true;
	#endif
}
#if defined _ALS_OnPlayerLeaveDynamicArea
	#undef OnPlayerLeaveDynamicArea
#else
	#define _ALS_OnPlayerLeaveDynamicArea
#endif

#define OnPlayerLeaveDynamicArea ncp_OnPlayerLeaveDynamicArea
#if defined ncp_OnPlayerLeaveDynamicArea
	forward ncp_OnPlayerLeaveDynamicArea(playerid, areaid);
#endif

/* 
    hook ALS SetPlayerMapIcon
*/

stock ncp_SetPlayerMapIcon(playerid, iconid, Float: x, Float: y, Float: z, markertype, color, MAPICON: style = MAPICON_LOCAL)
{
    g_player_ncp_info[playerid][E_PLAYER_NCP_IS_SHOW][iconid] = true;
   
    SetPlayerMapIcon(playerid, iconid, x, y, z, markertype, color, style);
    return true;
}
#if defined _ALS_SetPlayerMapIcon
	#undef SetPlayerMapIcon
#else
	#define _ALS_SetPlayerMapIcon
#endif
#define SetPlayerMapIcon ncp_SetPlayerMapIcon

/* 
    hook ALS RemovePlayerMapIcon
*/

stock ncp_RemovePlayerMapIcon(playerid, iconid)
{
	g_player_ncp_info[playerid][E_PLAYER_NCP_IS_SHOW][iconid] = NULL_g_player_ncp_info[E_PLAYER_NCP_IS_SHOW];

    if (ncp_IsPlayerEntered(playerid, iconid)) {
		DestroyDynamicArea(g_player_ncp_info[playerid][E_PLAYER_NCP_AREA][iconid]);
		g_player_ncp_info[playerid][E_PLAYER_NCP_AREA][iconid] = NCP_INVALID_DYNAMIC_AREA;
	}

    RemovePlayerMapIcon(playerid, iconid);
    return true;
}
#if defined _ALS_RemovePlayerMapIcon
	#undef RemovePlayerMapIcon
#else
	#define _ALS_RemovePlayerMapIcon
#endif
#define RemovePlayerMapIcon ncp_RemovePlayerMapIcon

/*  
    functions
*/

stock ncp_PlayerCreate(playerid, Float: x, Float: y, Float: z)
{
    new free_idx = Iter_Free(g_ncp_iterator);

    if (free_idx == ITER_NONE) {
        return NCP_INVALID_ID;
    }

    if (g_player_ncp_info[playerid][E_PLAYER_NCP_IS_SHOW][free_idx]) {
        return false;
    }

    Iter_Add(g_ncp_iterator, free_idx);
	
	SetPlayerMapIcon(playerid, free_idx, x, y, z, 0, 0xAA00000FF, MAPICON_GLOBAL_CHECKPOINT);

	g_player_ncp_info[playerid][E_PLAYER_NCP_AREA][free_idx] = CreateDynamicCylinder(
        x, 
		y, 
		z - 0.5, 
		z + 0.5, 
		1.3, 
		.playerid = playerid
    );

	g_ncp_object_id = CreateDynamicObject(
		1317, 
		x, 
		y, 
		z - 1.0, 
		0.0, 
		0.0, 
		0.0
	);
	SetDynamicObjectMaterial(g_ncp_object_id, 0, -1, "none", "none", 0xFFFF0000);

    return free_idx;
}

stock ncp_PlayerDestroy(playerid, ncp_id)
{
	if (!ncp_IsValid(ncp_id)) {
		return NCP_INVALID_ID;
	}

	if (g_player_ncp_info[playerid][E_PLAYER_NCP_AREA][ncp_id] == NULL_g_player_ncp_info[E_PLAYER_NCP_AREA]) {
		return false;
	}

	if (IsValidDynamicObject(g_ncp_object_id)) {
		DestroyDynamicObject(g_ncp_object_id);
	}
	
    Iter_Remove(g_ncp_iterator, ncp_id);

	DestroyDynamicArea(g_player_ncp_info[playerid][E_PLAYER_NCP_AREA][ncp_id]);

	g_player_ncp_info[playerid][E_PLAYER_NCP_AREA][ncp_id] = NULL_g_player_ncp_info[E_PLAYER_NCP_AREA];
	
    RemovePlayerMapIcon(playerid, ncp_id);

	return true;
}

stock ncp_IsPlayerEntered(playerid, ncp_id) 
{
    return (g_player_ncp_info[playerid][E_PLAYER_NCP_AREA][ncp_id] != NULL_g_player_ncp_info[E_PLAYER_NCP_AREA]);
}

stock ncp_IsValid(ncp_id)
{
	return (Iter_Contains(g_ncp_iterator, ncp_id));
}
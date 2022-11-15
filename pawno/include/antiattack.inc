/*

			Anti-Attack Module
				BJIADOKC & Co.
	Remove this copyright, if you want to be a superman!
*/





#if !defined _samp_included
#error Include 'antiattack.inc' after 'a_samp.inc' !
#endif

#if defined _aat_included
#endinput
#endif

#define _aat_included

#define SAMP_CURRENT_VERSION 		"0.3x"
//#define MAX_BANDWIDTH_PER_SECOND	760
#define MAX_FUNCTION_CALL_MS		150
#define MAX_FUNCTION_CALL_WARNS		5
#define MAX_CONNECTS_FROM_IP		3

#define AAT_ERROR			0x7FFFFFFF
//#define aat_DEBUG






enum
{
	ATTACK_TYPE_BAD_RCON_ATTEMPT = 0,
	ATTACK_TYPE_INVALID_CLIENT,
	ATTACK_TYPE_SERVER_FULL,
	ATTACK_TYPE_INVALID_NPC,
	ATTACK_TYPE_INVALID_RCON
}

enum
{
	ATTACK_TYPE_DIALOG_RESPONSE = 0,
	ATTACK_TYPE_DIALOG_EXPLOIT,
	ATTACK_TYPE_RCON_EXPLOIT,
	ATTACK_TYPE_PACKET_MODIFIED,
	ATTACK_TYPE_REMOTE_PORT_REFUSED,
	ATTACK_TYPE_ONESLOT_FLOOD,
	ATTACK_TYPE_INVALID_VERSION,
	ATTACK_TYPE_MAX_IP_LIMIT,
	ATTACK_TYPE_OPRC_FLOOD,
	ATTACK_TYPE_OPRS_FLOOD,
	ATTACK_TYPE_OPS_FLOOD,
	ATTACK_TYPE_OPD_FLOOD,
	ATTACK_TYPE_OPPUP_FLOOD,
	ATTACK_TYPE_OPSMR_FLOOD,
	ATTACK_TYPE_OPEM_FLOOD,
	ATTACK_TYPE_OPCP_FLOOD,
	ATTACK_TYPE_OPIC_FLOOD,
	ATTACK_TYPE_SELFKILL,
	ATTACK_TYPE_INVALID_KILLERID,
	ATTACK_TYPE_INVALID_PING,
	ATTACK_TYPE_NULL_COMMAND,
	ATTACK_TYPE_INVALID_CLICK_SRC
}

enum (<<= 1)
{
	CALLBACK_DATA_OPC = 1,
	CALLBACK_DATA_OPD,
	CALLBACK_DATA_OPCT,
	CALLBACK_DATA_OPRC,
	CALLBACK_DATA_OPRS,
	CALLBACK_DATA_OPS,
	CALLBACK_DATA_OPD_,
	CALLBACK_DATA_OPPUP,
	CALLBACK_DATA_OPSMR,
	CALLBACK_DATA_OPEM,
	CALLBACK_DATA_OPCP,
	CALLBACK_DATA_OPIC,
	CALLBACK_DATA_ORLA,
	CALLBACK_DATA_ORAA,
	CALLBACK_DATA_OPGD,
	CALLBACK_DATA_OPTD,
	CALLBACK_DATA_OIAA
}







new aat_playerConnected[MAX_PLAYERS char];
new aat_maxPlayers, aat_CALLBACK_DATA;

native aat_init();
native aat_check(checkid);
native aat_Chain:aat_push(pushid);
native aat_Chain:aat_push_str(pushstr[]);
native aat_pop(aat_Chain:popid);
native aat_netstats(stats[]);
native gpci(playerid, dest[], maxlength);



forward OnRemoteAttackAttempt(attackType, data[]);
forward OnIngameAttackAttempt(attackType, data);
forward InvokeFunction();



#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	aat_init();
	aat_maxPlayers = GetMaxPlayers();

	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerConnect") != -1) ? CALLBACK_DATA_OPC : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerDisconnect") != -1) ? CALLBACK_DATA_OPD : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerCommandText") != -1) ? CALLBACK_DATA_OPCT : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerRequestClass") != -1) ? CALLBACK_DATA_OPRC : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerRequestSpawn") != -1) ? CALLBACK_DATA_OPRS : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerSpawn") != -1) ? CALLBACK_DATA_OPS : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerDeath") != -1) ? CALLBACK_DATA_OPD_ : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerPickUpPickup") != -1) ? CALLBACK_DATA_OPPUP : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerSelectedMenuRow") != -1) ? CALLBACK_DATA_OPSMR : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerExitedMenu") != -1) ? CALLBACK_DATA_OPEM : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerClickPlayer") != -1) ? CALLBACK_DATA_OPCP : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerInteriorChange") != -1) ? CALLBACK_DATA_OPIC : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnRconLoginAttempt") != -1) ? CALLBACK_DATA_ORLA : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnRemoteAttackAttempt") != -1) ? CALLBACK_DATA_ORAA : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnIngameAttackAttempt") != -1) ? CALLBACK_DATA_OIAA : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerTakeDamage") != -1) ? CALLBACK_DATA_OPTD : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerGiveDamage") != -1) ? CALLBACK_DATA_OPGD : 0;

	#if defined aat_DEBUG
	printf("Anti-Attack: Callback data: %b\n", aat_CALLBACK_DATA);
	#endif

	if(funcidx("aat_OnFilterScriptInit") != -1) return CallLocalFunction("aat_OnFilterScriptInit", "");

	return 1;
}

#if defined _ALS_OnFilterScriptInit
#undef OnFilterScriptInit
#else
#define _ALS_OnFilterScriptInit
#endif

#define OnFilterScriptInit aat_OnFilterScriptInit

forward aat_OnFilterScriptInit();




public OnFilterScriptExit()
{
	if(funcidx("aat_OnFilterScriptExit") != -1) return CallLocalFunction("aat_OnFilterScriptExit", "");

	return 1;
}

#if defined _ALS_OnFilterScriptExit
#undef OnFilterScriptExit
#else
#define _ALS_OnFilterScriptExit
#endif

#define OnFilterScriptExit aat_OnFilterScriptExit

forward aat_OnFilterScriptExit();

#else

public OnGameModeInit()
{
	aat_init();
	aat_maxPlayers = GetMaxPlayers();

	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerConnect") != -1) ? CALLBACK_DATA_OPC : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerDisconnect") != -1) ? CALLBACK_DATA_OPD : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerCommandText") != -1) ? CALLBACK_DATA_OPCT : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerRequestClass") != -1) ? CALLBACK_DATA_OPRC : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerRequestSpawn") != -1) ? CALLBACK_DATA_OPRS : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerSpawn") != -1) ? CALLBACK_DATA_OPS : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerDeath") != -1) ? CALLBACK_DATA_OPD_ : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerPickUpPickup") != -1) ? CALLBACK_DATA_OPPUP : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerSelectedMenuRow") != -1) ? CALLBACK_DATA_OPSMR : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerExitedMenu") != -1) ? CALLBACK_DATA_OPEM : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerClickPlayer") != -1) ? CALLBACK_DATA_OPCP : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerInteriorChange") != -1) ? CALLBACK_DATA_OPIC : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnRconLoginAttempt") != -1) ? CALLBACK_DATA_ORLA : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnRemoteAttackAttempt") != -1) ? CALLBACK_DATA_ORAA : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnIngameAttackAttempt") != -1) ? CALLBACK_DATA_OIAA : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerTakeDamage") != -1) ? CALLBACK_DATA_OPTD : 0;
	aat_CALLBACK_DATA |= (funcidx("aat_OnPlayerGiveDamage") != -1) ? CALLBACK_DATA_OPGD : 0;

	#if defined aat_DEBUG
	printf("Anti-Attack: Callback data: %b\n", aat_CALLBACK_DATA);
	#endif

	if(funcidx("aat_OnGameModeInit") != -1) return CallLocalFunction("aat_OnGameModeInit", "");

	return 1;
}

#if defined _ALS_OnGameModeInit
#undef OnGameModeInit
#else
#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit aat_OnGameModeInit

forward aat_OnGameModeInit();




public OnGameModeExit()
{
	if(funcidx("aat_OnGameModeExit") != -1) return CallLocalFunction("aat_OnGameModeExit", "");

	return 1;
}

#if defined _ALS_OnGameModeExit
#undef OnGameModeExit
#else
#define _ALS_OnGameModeExit
#endif

#define OnGameModeExit aat_OnGameModeExit

forward aat_OnGameModeExit();

#endif





public OnRemoteAttackAttempt(attackType, data[])
{
	if(data[0] <= '\1')
	{
		printf("Anti-Attack Warning: NULL data passed to callback \"OnRemoteAttackAttempt\" %i|\"\"", attackType);

		return 1;
	}

	if(!(7 <= strlen(data) <= 15))
	{
		printf("Anti-Attack Warning: Invalid data LEN in callback \"OnRemoteAttackAttempt\" %i|\"%s\" (LEN: %i)", attackType, data, strlen(data));

		return 1;
	}

	new aat_dest[16];

	switch(attackType)
	{
	case ATTACK_TYPE_BAD_RCON_ATTEMPT: // BAD RCON ATTEMPT BY ...
		{
			format(aat_dest, sizeof aat_dest, "banip %s", data);
			SendRconCommand(aat_dest);

			printf("Anti-Attack Warning: IP %s was banned (Reason: Bad RCON attempt attack)", data);

			return 1;
		}

	case ATTACK_TYPE_INVALID_CLIENT: // Invalid client connecting from ...
		{
			format(aat_dest, sizeof aat_dest, "banip %s", data);
			SendRconCommand(aat_dest);

			printf("Anti-Attack Warning: IP %s was banned (Reason: Invalid client)", data);

			return 1;
		}

	case ATTACK_TYPE_SERVER_FULL: // Blocking ... due to a 'server full' attack
		{
			format(aat_dest, sizeof aat_dest, "banip %s", data);
			SendRconCommand(aat_dest);

			printf("Anti-Attack Warning: IP %s was banned (Reason: 'Server full' attack)", data);

			return 1;
		}

	case ATTACK_TYPE_INVALID_NPC: // NPC Connect: Bad player ID (...)
		{
			format(aat_dest, sizeof aat_dest, "banip %s", data);
			SendRconCommand(aat_dest);

			printf("Anti-Attack Warning: IP %s was banned (Reason: Invalid NPC attack)", data);

			return 1;
		}

	case ATTACK_TYPE_INVALID_RCON: // RCON is invalid, ...
		{
			format(aat_dest, sizeof aat_dest, "banip %s", data);
			SendRconCommand(aat_dest);

			printf("Anti-Attack Warning: IP %s was banned (Reason: Invalid RCON)", data);

			return 1;
		}

	default:
		{
			printf("Anti-Attack Warning: Incorrect data passed to callback \"OnRemoteAttackAttempt\" %i|\"%s\"", attackType, data);

			return 1;
		}
	}

	if(aat_CALLBACK_DATA & CALLBACK_DATA_ORAA) return CallLocalFunction("aat_OnRemoteAttackAttempt", "is", attackType, data);

	return 1;
}

#if defined _ALS_OnRemoteAttackAttempt
#undef OnRemoteAttackAttempt
#else
#define _ALS_OnRemoteAttackAttempt
#endif

#define OnRemoteAttackAttempt aat_OnRemoteAttackAttempt

forward aat_OnRemoteAttackAttempt(attackType, data[]);
stock PVarControll(playerid,pvar[])
{
	SetPVarInt(playerid,pvar,GetPVarInt(playerid,pvar)+1);
	if(GetPVarInt(playerid,pvar)>=5)
	{
		DeletePVar(playerid,pvar);
		return 1;
	}
	return 0;
}




public OnIngameAttackAttempt(attackType, data)
{
	#if !defined aat_DEBUG
	if(!IsPlayerConnected(data)) return 1;
	#endif

	switch(attackType)
	{
	case ATTACK_TYPE_DIALOG_RESPONSE: // PlayerDialogResponse ... dialog ID doesn't match last sent dialog ID
		{
			if(PVarControll(data,"DialogMI")==1) BanEx(data, "PlayerDialogResponse attack (Dialog match)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: PlayerDialogResponse attack (Dialog match))", data);

			return 1;
		}

	case ATTACK_TYPE_DIALOG_EXPLOIT: // PlayerDialogResponse crash exploit from ...
		{
			Kick(data);
			printf("Anti-Attack Warning: Player %i was banned (Reason: PlayerDialogResponse attack (Crash exploit))", data);

			return 1;
		}

	case ATTACK_TYPE_RCON_EXPLOIT: // /rcon command exploit from ...
		{
			BanEx(data, "RCON attack (Crash exploit)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: RCON command attack (Crash exploit))", data);

			return 1;
		}

	case ATTACK_TYPE_PACKET_MODIFIED: // Packet was modified, sent by ...
		{
			if(PVarControll(data,"PacketMO")==1)Kick(data); // �� ��������
			printf("Anti-Attack Warning: Player %i was banned (Reason: Modified packet attack)", data);

			return 1;
		}

	case ATTACK_TYPE_REMOTE_PORT_REFUSED: // Remote Port Refused for ...
		{
			BanEx(data, "Client attack (Remote port refused)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: Refusing port attack)", data);

			return 1;
		}

	case ATTACK_TYPE_ONESLOT_FLOOD: // 100 Joins per sec
		{
			BanEx(data, "Client attack (One-slot flood)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: One-slot flood attack)", data);

			return 1;
		}

	case ATTACK_TYPE_INVALID_VERSION: // Version of client is not conform to valid
		{
			Kick(data);
			printf("Anti-Attack Warning: Player %i was banned (Reason: Invalid client version)", data);

			return 1;
		}

	case ATTACK_TYPE_MAX_IP_LIMIT: // Many connects from 1 IP
		{
			Kick(data);
			printf("Anti-Attack Warning: Player %i was kicked (Reason: %i connections from 1 IP)", data, MAX_CONNECTS_FROM_IP);

			return 1;
		}

	case ATTACK_TYPE_OPRC_FLOOD: // OnPlayerRequestClass flood
		{
			/*BanEx(data, "Client attack (OnPlayerRequestClass flood)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: OnPlayerRequestClass flood)", data);*/

			return 1;
		}

	case ATTACK_TYPE_OPRS_FLOOD: // OnPlayerRequestSpawn flood
		{
			/*BanEx(data, "Client attack (OnPlayerRequestSpawn flood)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: OnPlayerRequestSpawn flood)", data);*/

			return 1;
		}

	case ATTACK_TYPE_OPS_FLOOD: // OnPlayerSpawn flood
		{
			/*BanEx(data, "Client attack (OnPlayerSpawn flood)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: OnPlayerSpawn flood)", data);*/

			return 1;
		}

	case ATTACK_TYPE_OPD_FLOOD: // OnPlayerDeath flood
		{
			BanEx(data, "Client attack (OnPlayerDeath flood)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: OnPlayerDeath flood)", data);

			return 1;
		}

	case ATTACK_TYPE_OPPUP_FLOOD: // OnPlayerPickUpPickup flood
		{
			/*BanEx(data, "Client attack (OnPlayerPickUpPickup flood)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: OnPlayerPickUpPickup flood)", data);*/

			return 1;
		}

	case ATTACK_TYPE_OPSMR_FLOOD: // OnPlayerSelectedMenuRow flood
		{
			/*BanEx(data, "Client attack (OnPlayerSelectedMenuRow flood)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: OnPlayerSelectedMenuRow flood)", data);*/

			return 1;
		}

	case ATTACK_TYPE_OPEM_FLOOD: // OnPlayerExitedMenu flood
		{
			/*BanEx(data, "Client attack (OnPlayerExitedMenu flood)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: OnPlayerExitedMenu flood)", data);*/

			return 1;
		}

	case ATTACK_TYPE_OPCP_FLOOD: // OnPlayerClickPlayer flood
		{
			BanEx(data, "Client attack (OnPlayerClickPlayer flood)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: OnPlayerClickPlayer flood)", data);

			return 1;
		}

	case ATTACK_TYPE_OPIC_FLOOD: // OnPlayerInteriorChange flood
		{
			/*BanEx(data, "Client attack (OnPlayerInteriorChange flood)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: OnPlayerInteriorChange flood)", data);*/

			return 1;
		}

	case ATTACK_TYPE_SELFKILL: // player killed himself (unreal :O)
		{
			BanEx(data, "Client attack (SelfKill)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: SelfKill)", data);

			return 1;
		}

	case ATTACK_TYPE_INVALID_KILLERID: // killerid is not connected and not equal 65535
		{
			//BanEx(data, "Client attack (Invalid killerid)"); // �� ��������
			printf("Anti-Attack Warning: Player %i was banned (Reason: Invalid killerid)", data);

			return 1;
		}

	case ATTACK_TYPE_INVALID_PING: // player's ping = -1, lol
		{
			Kick(data);
			printf("Anti-Attack Warning: Player %i was kicked (Reason: Invalid ping)", data);

			return 1;
		}

	case ATTACK_TYPE_NULL_COMMAND: // sended "" command, unreal :O
		{
			BanEx(data, "Client attack (NULL command)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: NULL command)", data);

			return 1;
		}

	case ATTACK_TYPE_INVALID_CLICK_SRC: // clicked on != 0 source, unreal :O
		{
			BanEx(data, "Client attack (Invalid clicked source)");
			printf("Anti-Attack Warning: Player %i was banned (Reason: Invalid clicked source)", data);

			return 1;
		}

	default:
		{
			printf("Anti-Attack Warning: Incorrect data passed to callback \"OnIngameAttackAttempt\" %i|%i", attackType, data);

			return 1;
		}
	}

	if(aat_CALLBACK_DATA & CALLBACK_DATA_OIAA) return CallLocalFunction("aat_OnIngameAttackAttempt", "ii", attackType, data);

	return 1;
}

#if defined _ALS_OnIngameAttackAttempt
#undef OnIngameAttackAttempt
#else
#define _ALS_OnIngameAttackAttempt
#endif

#define OnIngameAttackAttempt aat_OnIngameAttackAttempt

forward aat_OnIngameAttackAttempt(attackType, data);


forward CheckTime(playerid);
public CheckTime(playerid)
{
	new buf[380];
	GetPlayerNetworkStats(playerid,buf,380);
	aat_netstats(buf);
	//	printf("%d",temp);
	return 1;
}






public OnPlayerConnect(playerid)
{
	SetTimerEx("CheckTime",500,0,"i",playerid);
	
	if(aat_check(playerid)==1)
	{
		CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_INVALID_VERSION, playerid);
		printf("Banned %d\n",playerid);
		return 1;
	}

	if(aat_playerConnected{playerid}) 
	{
		CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_ONESLOT_FLOOD, playerid);

		return 1;
	}

	aat_playerConnected{playerid} = 1;

	new aat_dest[16];

	GetPlayerVersion(playerid, aat_dest, sizeof aat_dest);

	if(strcmp(aat_dest, SAMP_CURRENT_VERSION, false, 4))	
	{
		CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_INVALID_VERSION, playerid);
		printf("Banned %d %s\n",playerid,aat_dest);
		return 1;
	}

	GetPlayerIp(playerid, aat_dest, sizeof aat_dest);
	SetPVarInt(playerid,"DialogMI",0);
	SetPVarInt(playerid,"PacketMO",0);
	for(new i, f, aat_sub[16]; i != aat_maxPlayers; i++)
	{
		if(!IsPlayerConnected(i) || IsPlayerNPC(i) || i == playerid) continue;

		GetPlayerIp(i, aat_sub, sizeof aat_sub);

		if(!strcmp(aat_dest, aat_sub, false))
		{
			if(++f >= MAX_CONNECTS_FROM_IP)
			{
				CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_MAX_IP_LIMIT, playerid);

				break;
			}
		}
	}

	//ShowPlayerDialog(playerid, -1, -1, "", "", "", "");

	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPC) return CallLocalFunction("aat_OnPlayerConnect", "i", playerid);

	return 1;
}

#if defined _ALS_OnPlayerConnect
#undef OnPlayerConnect
#else
#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect aat_OnPlayerConnect

forward aat_OnPlayerConnect(playerid);





public OnPlayerDisconnect(playerid, reason)
{
	playerid &= 65535;
	aat_playerConnected{playerid} = 0;

	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPD) return CallLocalFunction("aat_OnPlayerDisconnect", "ii", playerid, reason);

	return 1;
}

#if defined _ALS_OnPlayerDisconnect
#undef OnPlayerDisconnect
#else
#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect aat_OnPlayerDisconnect

forward aat_OnPlayerDisconnect(playerid, reason);





public OnPlayerCommandText(playerid, cmdtext[])
{
	playerid &= 65535;

	if(!cmdtext[0])
	{
		CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_NULL_COMMAND, playerid);

		return 0;
	}

	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPCT) return CallLocalFunction("aat_OnPlayerCommandText", "is", playerid, cmdtext);

	return 0;
}

#if defined _ALS_OnPlayerCommandText
#undef OnPlayerCommandText
#else
#define _ALS_OnPlayerCommandText
#endif

#define OnPlayerCommandText aat_OnPlayerCommandText

forward aat_OnPlayerCommandText(playerid, cmdtext[]);





public OnPlayerRequestClass(playerid, classid)
{
	playerid &= 65535;

	if(GetTickCount() <= GetPVarInt(playerid, "OPRC_flood"))
	{
		if((GetPVarInt(playerid, "OPRC_flood_w") + 1) >= MAX_FUNCTION_CALL_WARNS)
		{
			CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_OPRC_FLOOD, playerid);

			return 0;
		}

		SetPVarInt(playerid, "OPRC_flood_w", (GetPVarInt(playerid, "OPRC_flood_w") + 1));
	}

	SetPVarInt(playerid, "OPRC_flood", (GetTickCount() + MAX_FUNCTION_CALL_MS));

	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPRC) return CallLocalFunction("aat_OnPlayerRequestClass", "ii", playerid, classid);

	return 1;
}

#if defined _ALS_OnPlayerRequestClass
#undef OnPlayerRequestClass
#else
#define _ALS_OnPlayerRequestClass
#endif

#define OnPlayerRequestClass aat_OnPlayerRequestClass

forward aat_OnPlayerRequestClass(playerid, classid);





public OnPlayerRequestSpawn(playerid)
{
	playerid &= 65535;

	if(GetTickCount() <= GetPVarInt(playerid, "OPRS_flood"))
	{
		if((GetPVarInt(playerid, "OPRS_flood_w") + 1) >= MAX_FUNCTION_CALL_WARNS)
		{
			CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_OPRS_FLOOD, playerid);

			return 0;
		}

		SetPVarInt(playerid, "OPRS_flood_w", (GetPVarInt(playerid, "OPRS_flood_w") + 1));
	}

	SetPVarInt(playerid, "OPRS_flood", (GetTickCount() + MAX_FUNCTION_CALL_MS));

	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPRS) return CallLocalFunction("aat_OnPlayerRequestSpawn", "i", playerid);

	return 1;
}

#if defined _ALS_OnPlayerRequestSpawn
#undef OnPlayerRequestSpawn
#else
#define _ALS_OnPlayerRequestSpawn
#endif

#define OnPlayerRequestSpawn aat_OnPlayerRequestSpawn

forward aat_OnPlayerRequestSpawn(playerid);





public OnPlayerSpawn(playerid)
{
	playerid &= 65535;

	if(GetTickCount() <= GetPVarInt(playerid, "OPS_flood"))
	{
		if((GetPVarInt(playerid, "OPS_flood_w") + 1) >= MAX_FUNCTION_CALL_WARNS)
		{
			CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_OPS_FLOOD, playerid);

			return 0;
		}

		SetPVarInt(playerid, "OPS_flood_w", (GetPVarInt(playerid, "OPS_flood_w") + 1));
	}

	SetPVarInt(playerid, "OPS_flood", (GetTickCount() + MAX_FUNCTION_CALL_MS));

	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPS) return CallLocalFunction("aat_OnPlayerSpawn", "i", playerid);

	return 1;
}

#if defined _ALS_OnPlayerSpawn
#undef OnPlayerSpawn
#else
#define _ALS_OnPlayerSpawn
#endif

#define OnPlayerSpawn aat_OnPlayerSpawn

forward aat_OnPlayerSpawn(playerid);





public OnPlayerDeath(playerid, killerid, reason)
{
	playerid &= 65535;
	killerid &= 65535;
	/*
	if(playerid == killerid)
	{
		CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_SELFKILL, playerid);

		return 0;
	}

	if(!IsPlayerConnected(killerid) && killerid != 65535)
	{
		CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_INVALID_KILLERID, playerid);

		return 0;
	}*/

	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPD_) return CallLocalFunction("aat_OnPlayerDeath", "iii", playerid, killerid, reason);

	return 1;
}

#if defined _ALS_OnPlayerDeath
#undef OnPlayerDeath
#else
#define _ALS_OnPlayerDeath
#endif

#define OnPlayerDeath aat_OnPlayerDeath

forward aat_OnPlayerDeath(playerid, killerid, reason);





public OnPlayerPickUpPickup(playerid, pickupid)
{
	playerid &= 65535;
	/*
	if(GetTickCount() <= GetPVarInt(playerid, "OPPUP_flood"))
	{
		if((GetPVarInt(playerid, "OPPUP_flood_w") + 1) >= MAX_FUNCTION_CALL_WARNS)
		{
			CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_OPPUP_FLOOD, playerid);

			return 0;
		}

		SetPVarInt(playerid, "OPPUP_flood_w", (GetPVarInt(playerid, "OPPUP_flood_w") + 1));
	}

	SetPVarInt(playerid, "OPPUP_flood", (GetTickCount() + MAX_FUNCTION_CALL_MS));
*/
	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPPUP) return CallLocalFunction("aat_OnPlayerPickUpPickup", "ii", playerid, pickupid);

	return 1;
}

#if defined _ALS_OnPlayerPickUpPickup
#undef OnPlayerPickUpPickup
#else
#define _ALS_OnPlayerPickUpPickup
#endif

#define OnPlayerPickUpPickup aat_OnPlayerPickUpPickup

forward aat_OnPlayerPickUpPickup(playerid, pickupid);





public OnPlayerSelectedMenuRow(playerid, row)
{
	playerid &= 65535;
	/*
	if(GetTickCount() <= GetPVarInt(playerid, "OPSMR_flood"))
	{
		if((GetPVarInt(playerid, "OPSMR_flood_w") + 1) >= MAX_FUNCTION_CALL_WARNS)
		{
			CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_OPSMR_FLOOD, playerid);

			return 0;
		}

		SetPVarInt(playerid, "OPSMR_flood_w", (GetPVarInt(playerid, "OPSMR_flood_w") + 1));
	}

	SetPVarInt(playerid, "OPSMR_flood", (GetTickCount() + MAX_FUNCTION_CALL_MS));
*/
	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPSMR) return CallLocalFunction("aat_OnPlayerSelectedMenuRow", "ii", playerid, row);

	return 1;
}

#if defined _ALS_OnPlayerSelectedMenuRow
#undef OnPlayerSelectedMenuRow
#else
#define _ALS_OnPlayerSelectedMenuRow
#endif

#define OnPlayerSelectedMenuRow aat_OnPlayerSelectedMenuRow

forward aat_OnPlayerSelectedMenuRow(playerid, row);





public OnPlayerExitedMenu(playerid)
{
	playerid &= 65535;
	/*
	if(GetTickCount() <= GetPVarInt(playerid, "OPEM_flood"))
	{
		if((GetPVarInt(playerid, "OPEM_flood_w") + 1) >= MAX_FUNCTION_CALL_WARNS)
		{
			CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_OPEM_FLOOD, playerid);

			return 0;
		}

		SetPVarInt(playerid, "OPEM_flood_w", (GetPVarInt(playerid, "OPEM_flood_w") + 1));
	}

	SetPVarInt(playerid, "OPEM_flood", (GetTickCount() + MAX_FUNCTION_CALL_MS));
*/
	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPEM) return CallLocalFunction("aat_OnPlayerExitedMenu", "i", playerid);

	return 1;
}

#if defined _ALS_OnPlayerExitedMenu
#undef OnPlayerExitedMenu
#else
#define _ALS_OnPlayerExitedMenu
#endif

#define OnPlayerExitedMenu aat_OnPlayerExitedMenu

forward aat_OnPlayerExitedMenu(playerid);





public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	playerid &= 65535;
	clickedplayerid &= 65535;

	//0.3a => ???

	if(source)
	{
		CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_INVALID_CLICK_SRC, playerid);

		return 0;
	}

	if(GetTickCount() <= GetPVarInt(playerid, "OPCP_flood"))
	{
		if((GetPVarInt(playerid, "OPCP_flood_w") + 1) >= MAX_FUNCTION_CALL_WARNS)
		{
			CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_OPCP_FLOOD, playerid);

			return 0;
		}

		SetPVarInt(playerid, "OPCP_flood_w", (GetPVarInt(playerid, "OPCP_flood_w") + 1));
	}

	SetPVarInt(playerid, "OPCP_flood", (GetTickCount() + MAX_FUNCTION_CALL_MS));

	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPCP) return CallLocalFunction("aat_OnPlayerClickPlayer", "iii", playerid, clickedplayerid, source);

	return 1;
}

#if defined _ALS_OnPlayerClickPlayer
#undef OnPlayerClickPlayer
#else
#define _ALS_OnPlayerClickPlayer
#endif

#define OnPlayerClickPlayer aat_OnPlayerClickPlayer

forward aat_OnPlayerClickPlayer(playerid, clickedplayerid, source);





public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	playerid &= 65535;
	/*
	if(GetTickCount() <= GetPVarInt(playerid, "OPIC_flood"))
	{
		if((GetPVarInt(playerid, "OPIC_flood_w") + 1) >= MAX_FUNCTION_CALL_WARNS)
		{
			CallLocalFunction("OnIngameAttackAttempt", "ii", ATTACK_TYPE_OPIC_FLOOD, playerid);

			return 0;
		}

		SetPVarInt(playerid, "OPIC_flood_w", (GetPVarInt(playerid, "OPIC_flood_w") + 1));
	}

	*/
	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPIC) return CallLocalFunction("aat_OnPlayerInteriorChange", "iii", playerid, newinteriorid, oldinteriorid);

	return 1;
}

#if defined _ALS_OnPlayerInteriorChange
#undef OnPlayerInteriorChange
#else
#define _ALS_OnPlayerInteriorChange
#endif

#define OnPlayerInteriorChange aat_OnPlayerInteriorChange

forward aat_OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid);





public OnRconLoginAttempt(ip[], password[], success)
{
	if(!success)
	{
		CallLocalFunction("OnRemoteAttackAttempt", "is", ATTACK_TYPE_INVALID_RCON, ip);

		return 0;
	}

	if(aat_CALLBACK_DATA & CALLBACK_DATA_ORLA) return CallLocalFunction("aat_OnRconLoginAttempt", "ssi", ip, password, success);

	return 1;
}

#if defined _ALS_OnRconLoginAttempt
#undef OnRconLoginAttempt
#else
#define _ALS_OnRconLoginAttempt
#endif

#define OnRconLoginAttempt aat_OnRconLoginAttempt

forward aat_OnRconLoginAttempt(ip[], password[], success);





public InvokeFunction()
{
	new Float:fVar;
	new Var[256];
	new iVar;

	// a_samp.inc

	SendClientMessage(0, 0, "");
	SendClientMessageToAll(0, "");
	SendDeathMessage(0, 0, 0);
	GameTextForAll("", 0, 0);
	GameTextForPlayer(0, "", 0, 0);
	GetTickCount();
	GetMaxPlayers();
	SetGameModeText("");
	SetTeamCount(0);
	AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(0, 0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	AddStaticVehicle(0, 0.0, 0.0, 0.0, 0.0, 0, 0);
	AddStaticVehicleEx(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0);
	AddStaticPickup(0, 0, 0.0, 0.0, 0.0);
	ShowNameTags(0);
	ShowPlayerMarkers(0);
	GameModeExit();
	SetWorldTime(0);
	GetWeaponName(0, Var, sizeof Var);
	EnableTirePopping(0);
	AllowInteriorWeapons(0);
	SetWeather(0);
	SetGravity(0.0);
	AllowAdminTeleport(0);
	SetDeathDropAmount(0);
	CreateExplosion(0.0, 0.0, 0.0, 0, 0.0);
	//SetDisabledWeapons();
	EnableZoneNames(0);
	IsPlayerAdmin(0);
	Kick(0);
	Ban(0);
	SendRconCommand("");
	ShowPlayerDialog(0, 0, 0, "", "", "", "");

	// a_players.inc

	SetSpawnInfo(0, 0, 0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0,0);
	SpawnPlayer(0);
	SetPlayerPos(0, 0.0, 0.0, 0.0);
	//SetPlayerPosFindZ(0, 0.0, 0.0, 0.0);
	GetPlayerPos(0, fVar, fVar, fVar);
	SetPlayerFacingAngle(0, 0.0);
	GetPlayerFacingAngle(0, fVar);
	SetPlayerInterior(0, 0);
	GetPlayerInterior(0);
	SetPlayerHealth(0, 0.0);
	GetPlayerHealth(0, fVar);
	SetPlayerArmour(0, 0.0);
	GetPlayerArmour(0, fVar);
	SetPlayerAmmo(0, 0,0);
	GetPlayerAmmo(0);
	SetPlayerTeam(0, 0);
	GetPlayerTeam(0);
	SetPlayerScore(0, 0);
	GetPlayerScore(0);
	SetPlayerColor(0, 0);
	GetPlayerColor(0);
	SetPlayerSkin(0, 0);
	GivePlayerWeapon(0, 0,0);
	ResetPlayerWeapons(0);
	GetPlayerWeaponData(0, 0, iVar, iVar);
	GivePlayerMoney(0, 0);
	ResetPlayerMoney(0);
	SetPlayerName(0, "");
	GetPlayerMoney(0);
	GetPlayerState(0);
	GetPlayerIp(0, Var, sizeof Var);
	ApplyAnimation(0, "", "", 1.0, 0, 0, 0, 0, 0);
	gpci(0, Var, sizeof Var);
	GetPlayerPing(0);
	GetPlayerWeapon(0);
	GetPlayerKeys(0, iVar, iVar, iVar);
	GetPlayerName(0, Var, sizeof Var);
	PutPlayerInVehicle(0, 0,0);
	GetPlayerVehicleID(0);
	RemovePlayerFromVehicle(0);
	TogglePlayerControllable(0, 0);
	PlayerPlaySound(0, 0, 0.0, 0.0,0.0);
	SetPlayerCheckpoint(0, 0.0, 0.0, 0.0,0.0);
	DisablePlayerCheckpoint(0);
	SetPlayerRaceCheckpoint(0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,0.0);
	DisablePlayerRaceCheckpoint(0);
	SetPlayerWorldBounds(0, 0.0, 0.0, 0.0, 0.0);
	SetPlayerMarkerForPlayer(0, 0,0);
	ShowPlayerNameTagForPlayer(0, 0,0);
	SetPlayerMapIcon(0, 0, 0.0, 0.0, 0.0, 0,0);
	RemovePlayerMapIcon(0, 0);
	SetPlayerCameraPos(0, 0.0, 0.0, 0.0);
	SetPlayerCameraLookAt(0, 0.0, 0.0, 0.0);
	SetCameraBehindPlayer(0);
	AllowPlayerTeleport(0,0);
	IsPlayerConnected(0);
	IsPlayerInVehicle(0, 0);
	IsPlayerInAnyVehicle(0);
	IsPlayerInCheckpoint(0);
	IsPlayerInRaceCheckpoint(0);
	SetPlayerTime(0, 0, 0);
	TogglePlayerClock(0, 0);
	SetPlayerWeather(0, 0);
	GetPlayerTime(0,iVar,iVar);
	SetPlayerVirtualWorld(0, 0);
	GetPlayerVirtualWorld(0);

	// a_vehicle.inc

	CreateVehicle(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0);
	DestroyVehicle(0);
	GetVehiclePos(0, fVar, fVar, fVar);
	SetVehiclePos(0, 0.0, 0.0, 0.0);
	GetVehicleZAngle(0, fVar);
	SetVehicleZAngle(0, 0.0);
	SetVehicleParamsForPlayer(0, 0, 0, 0);
	SetVehicleToRespawn(0);
	LinkVehicleToInterior(0, 0);
	AddVehicleComponent(0, 0);
	ChangeVehicleColor(0, 0, 0);
	ChangeVehiclePaintjob(0, 0);
	SetVehicleHealth(0, 0.0);
	GetVehicleHealth(0, fVar);
	AttachTrailerToVehicle(0, 0);
	DetachTrailerFromVehicle(0);
	IsTrailerAttachedToVehicle(0);
	GetVehicleModel(0);
	SetVehicleNumberPlate(0, "");
	SetVehicleVirtualWorld(0, 0);
	GetVehicleVirtualWorld(0);

	// a_objects.inc

	CreateObject(0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	SetObjectPos(0, 0.0, 0.0, 0.0);
	GetObjectPos(0, fVar, fVar, fVar);
	SetObjectRot(0, 0.0, 0.0, 0.0);
	GetObjectRot(0, fVar, fVar, fVar);
	IsValidObject(0);
	DestroyObject(0);
	MoveObject(0, 0.0, 0.0, 0.0, 0.0);
	StopObject(0);
	CreatePlayerObject(0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	SetPlayerObjectPos(0, 0, 0.0, 0.0, 0.0);
	GetPlayerObjectPos(0, 0, fVar, fVar, fVar);
	GetPlayerObjectRot(0, 0, fVar, fVar, fVar);
	SetPlayerObjectRot(0, 0, 0.0, 0.0, 0.0);
	IsValidPlayerObject(0, 0);
	DestroyPlayerObject(0, 0);
	MovePlayerObject(0, 0, 0.0, 0.0, 0.0, 0.0);
	StopPlayerObject(0, 0);

	// Menu's

	CreateMenu("", 0, 0.0, 0.0, 0.0, 0.0);
	DestroyMenu(Menu:0);
	AddMenuItem(Menu:0, 0, "");
	SetMenuColumnHeader(Menu:0, 0, "");
	ShowMenuForPlayer(Menu:0, 0);
	HideMenuForPlayer(Menu:0, 0);
	IsValidMenu(Menu:0);
	DisableMenu(Menu:0);
	DisableMenuRow(Menu:0, 0);

	// Textdraw

	TextDrawCreate(0.0, 0.0, "");
	TextDrawDestroy(Text:0);
	TextDrawLetterSize(Text:0, 0.0, 0.0);
	TextDrawTextSize(Text:0, 0.0, 0.0);
	TextDrawAlignment(Text:0, 0);
	TextDrawColor(Text:0, 0);
	TextDrawUseBox(Text:0, 0);
	TextDrawBoxColor(Text:0, 0);
	TextDrawSetShadow(Text:0, 0);
	TextDrawSetOutline(Text:0, 0);
	TextDrawBackgroundColor(Text:0, 0);
	TextDrawFont(Text:0, 0);
	TextDrawSetProportional(Text:0, 0);
	TextDrawShowForPlayer(0, Text:0);
	TextDrawHideForPlayer(0, Text:0);
	TextDrawShowForAll(Text:0);
	TextDrawHideForAll(Text:0);

	// Others

	funcidx("");
	gettime(iVar, iVar, iVar);
	getdate(iVar, iVar, iVar);
	tickcount(iVar);

	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	if(issuerid != INVALID_PLAYER_ID)
	{
		new string[128], victim[MAX_PLAYER_NAME], attacker[MAX_PLAYER_NAME];
		new weaponname[24];
		GetPlayerName(playerid, victim, sizeof (victim));
		GetPlayerName(issuerid, attacker, sizeof (attacker));
		GetWeaponName(weaponid, weaponname, sizeof (weaponname));
		printf(string, sizeof(string), "%s has made %.0f damage to %s, weapon: %s", attacker, amount, victim, weaponname);
		
	}
	else
	{
		new string[128], victim[MAX_PLAYER_NAME];
		GetPlayerName(playerid, victim, sizeof (victim));
		printf(string, sizeof(string), "A Ghost has made %.0f damage to %s, weapon: %s", amount, victim);
	}
	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPTD) return CallLocalFunction("aat_OnPlayerTakeDamage", "iifi",playerid, issuerid, Float: amount, weaponid);

	return 1;
}

#if defined _ALS_OnPlayerTakeDamage
#undef OnPlayerTakeDamage
#else
#define _ALS_OnPlayerTakeDamage
#endif

#define OnPlayerTakeDamage aat_OnPlayerTakeDamage

forward aat_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid);

public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
{
	new string[128], victim[MAX_PLAYER_NAME], attacker[MAX_PLAYER_NAME];
	new weaponname[24];
	GetPlayerName(playerid, attacker, sizeof (attacker));
	GetPlayerName(damagedid, victim, sizeof (victim));

	GetWeaponName(weaponid, weaponname, sizeof (weaponname));
	printf(string, sizeof(string), "%s has made %.0f damage to %s, weapon: %s", attacker, amount, victim, weaponname);

	if(aat_CALLBACK_DATA & CALLBACK_DATA_OPGD) return CallLocalFunction("aat_OnPlayerGiveDamage", "iifi",playerid, damagedid, Float: amount, weaponid);

	return 1;
}
#if defined _ALS_OnPlayerGiveDamage
#undef OnPlayerGiveDamage
#else
#define _ALS_OnPlayerGiveDamage
#endif

#define OnPlayerGiveDamage aat_OnPlayerGiveDamage


forward aat_OnPlayerGiveDamage(playerid, damagedid , Float: amount, weaponid);
#pragma tabsize 4
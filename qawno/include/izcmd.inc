/*******************************************************************************************************************************
 Improved ZCMD (iZCMD)

 This include is just a re-make of the ZCMD Command Processor ( V0.3.1 31/10/2009) originnaly developed by Zeex.

 Version: 0.2.3.0 (August 1st 2016)

 GitHub Link: https://github.com/YashasSamaga/I-ZCMD

 Credits:
 Zeex for ZCMD (the very idea of making publics for each command was introduced by Zeex in ZCMD)
 Yashas
*******************************************************************************************************************************/
#if defined _I_ZCMD_INCLUDED
	#endinput
#endif
#define _I_ZCMD_INCLUDED
#define _I_ZCMD_INCLUDED_V0_2_3_0_
/******************************************************************************************************************************/
#define MAX_CLIENT_MSG_LENGTH (144)
#define MAX_FUNC_NAME (32)

#define COMMAND:%1(%2)          \
			forward cmd_%1(%2); \
			public cmd_%1(%2)

#define CMD:%1(%2) \
			COMMAND:%1(%2)

#define command(%1,%2,%3) \
			COMMAND:%1(%2, %3)

#define cmd(%1,%2,%3) \
			COMMAND:%1(%2, %3)

#define CMD_SUCCESS 1
#define CMD_FAILURE 0

#if !defined isnull
        #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif
/******************************************************************************************************************************/
#if defined OnPlayerCommandReceived
	forward OnPlayerCommandReceived(playerid,cmdtext[]);
#endif
#if defined OnPlayerCommandPerformed
	forward OnPlayerCommandPerformed(playerid,cmdtext[], success);
#endif
/******************************************************************************************************************************/
public OnPlayerCommandText(playerid, cmdtext[])
{
	#if defined OnPlayerCommandReceived
	    if(!OnPlayerCommandReceived(playerid, cmdtext)) return 1;
	#endif
	
	static funcname[MAX_CLIENT_MSG_LENGTH] = "cmd_";

	#if defined IZCMD_ENABLE_CASE_SENSITIVITY
		static pos;

		if((pos = strfind(cmdtext, " ", false, 1)) == -1)
		{
      		funcname[4] = 0;
			strcat(funcname, cmdtext[1], MAX_FUNC_NAME - 4);

		   	#if defined OnPlayerCommandPerformed
		 		return OnPlayerCommandPerformed(playerid, cmdtext, CallLocalFunction(funcname, "is", playerid, "\1"));
			#else
				return CallLocalFunction(funcname, "is", playerid, "\1");
			#endif
		}
		else
		{
			funcname[4] = 0;
			strcat(funcname, cmdtext[1], pos + 4);

	    	while (cmdtext[pos] == ' ') pos++;

			if(cmdtext[pos])
			{
		  		#if defined OnPlayerCommandPerformed
					return OnPlayerCommandPerformed(playerid, cmdtext, CallLocalFunction(funcname, "is", playerid, cmdtext[pos]));
				#else
					return CallLocalFunction(funcname, "is", playerid, cmdtext[pos]);
				#endif
			}
			else
			{
			   	#if defined OnPlayerCommandPerformed
					return OnPlayerCommandPerformed(playerid, cmdtext, CallLocalFunction(funcname, "is", playerid, "\1"));
				#else
					return CallLocalFunction(funcname, "is", playerid, "\1");
				#endif
			}
		}
	#else
		new pos = 1, tmp;

		while((tmp = cmdtext[pos]) > ' ')
			if('A' <= tmp <= 'Z') funcname[pos++ + 3] = tmp | 0x20;
			else funcname[pos++ + 3] = tmp;

		funcname[pos + 3] = 0;

		while (cmdtext[pos] == ' ') pos++;
	
		if(cmdtext[pos])
		{
	  		#if defined OnPlayerCommandPerformed
				return OnPlayerCommandPerformed(playerid, cmdtext, CallLocalFunction(funcname, "is", playerid, cmdtext[pos]));
			#else
				return CallLocalFunction(funcname, "is", playerid, cmdtext[pos]);
			#endif
		}
		else
		{
		   	#if defined OnPlayerCommandPerformed
				return OnPlayerCommandPerformed(playerid, cmdtext, CallLocalFunction(funcname, "is", playerid, "\1"));
			#else
				return CallLocalFunction(funcname, "is", playerid, "\1");
			#endif
		}
	#endif
}

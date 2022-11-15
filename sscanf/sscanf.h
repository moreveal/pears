/*  
 *  Version: MPL 1.1
 *  
 *  The contents of this file are subject to the Mozilla Public License Version 
 *  1.1 (the "License"); you may not use this file except in compliance with 
 *  the License. You may obtain a copy of the License at 
 *  http://www.mozilla.org/MPL/
 *  
 *  Software distributed under the License is distributed on an "AS IS" basis,
 *  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 *  for the specific language governing rights and limitations under the
 *  License.
 *  
 *  The Original Code is the sscanf 2.0 SA:MP plugin.
 *  
 *  The Initial Developer of the Original Code is Alex "Y_Less" Cole.
 *  Portions created by the Initial Developer are Copyright (C) 2010
 *  the Initial Developer. All Rights Reserved.
 *  
 *  Contributor(s):
 *  
 *  Special Thanks to:
 *  
 *  SA:MP Team past, present and future
 */

#pragma once

typedef
	void (* logprintf_t)(char *, ...);

typedef
	char * (* GetServer_t)();

// 0.3 compatible
/*typedef
	unsigned short
	PLAYERID;

#define SERVER_VERSION_0221	(0x0221)
#define SERVER_VERSION_0222	(0x0222)
#define SERVER_VERSION_0223	(0x0223)
#define SERVER_VERSION_0224	(0x0224)
#define SERVER_VERSION_0200	(0x0200)
#define SERVER_VERSION_0300	(0x0300)
#define SERVER_VERSION_0340	(0x0340) // 0.3d
#define SERVER_VERSION_0342 (0x0342) // 0.3dR2


#define MAX_PLAYERS_0200       (200)
#define INVALID_PLAYER_ID_0200 (255)

// Change after 0.3 real release.
#define MAX_PLAYERS_0300       (500)
#define INVALID_PLAYER_ID_0300 (65535)

#define MAX_PLAYER_NAME  (24)

#ifndef NULL
	#define NULL (0)
#endif

#ifdef WIN32
	#define LOGPRINTF_0221	((logprintf_t)0x00476D90)
	#define LOGPRINTF_0222	((logprintf_t)0x00477020)
	#define LOGPRINTF_0223	((logprintf_t)3)
	#define LOGPRINTF_0224	((logprintf_t)0x0046A590)
	// Change after final release.
	#define LOGPRINTF_0300  ((logprintf_t)0x00476380)
	#define LOGPRINTF_0340  ((logprintf_t)0x004823D0) // Maybe 0x004823D0
	#define LOGPRINTF_0342  ((logprintf_t)0x00482400) // by dnee`THA
#else
	#define LOGPRINTF_0221	((logprintf_t)1)
	#define LOGPRINTF_0222	((logprintf_t)2)
	#define LOGPRINTF_0223	((logprintf_t)3)
	#define LOGPRINTF_0224	((logprintf_t)0x0807D760)
	// Change after final release.
	#define LOGPRINTF_0300  ((logprintf_t)5)
	#define LOGPRINTF_0340  ((logprintf_t)0x080765D0)
	#define LOGPRINTF_0342  ((logprintf_t)0x08076600) // by dnee`THA
#endif*/

#define SSCANF_FAIL_RETURN (-1)
#define SSCANF_CONT_RETURN (((unsigned int)-1) >> 1)
#define SSCANF_TRUE_RETURN (0)

// Capped for memory reasons.  I chose 32 because it's a reasonable length for
// many uses and frankly if they get warnings and don't fix them it's their
// own fault if they have problems with strings!
#define SSCANF_MAX_LENGTH (32)

// 32 bit special float values.
#define FLOAT_INFINITY          (0x7F800000)
#define FLOAT_NEG_INFINITY      (0xFF800000)
#define FLOAT_NAN               (0xFFFFFFFF)
#define FLOAT_NAN_E             (0x7FFFFFFF)
#define FLOAT_NEGATIVE_INFINITY (FLOAT_NEG_INFINITY)

#define SSCANF_QUIET 0

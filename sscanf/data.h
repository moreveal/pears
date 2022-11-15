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

char
	GetSingleType(char ** format);

char *
	GetMultiType(char ** format);

char *
	GetMultiType(char ** format);

unsigned int
	GetUserString(char * string, char ** end);

int
	GetDec(char ** const input);

int
	GetOct(char ** const input);

int
	GetHex(char ** const input);

int
	GetBool(char ** const input);

int
	GetNumber(char ** const input);

bool
	GetLogical(char ** const input);

void
	SkipDefault(char ** const str);

void
	SkipDefaultEx(char ** const data);

void
	SkipLength(char ** const input);

int
	GetLength(char ** const input, bool error);

bool
	FindDefaultStart(char ** const str);

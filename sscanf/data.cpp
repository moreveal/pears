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

#include "sscanf.h"
#include "utils.h"

extern unsigned int
	g_iTrueMax;

extern logprintf_t
	logprintf;

char
	GetSingleType(char ** format)
{
	char
		* cur = *format,
		tmp = *cur;
	if (tmp == '<')
	{
		++cur;
		char
			ret = *cur;
		if (ret)
		{
			++cur;
			if (*cur == '>')
			{
				*format += 3;
				return ret;
			}
			else
			{
				logprintf("sscanf warning: Unclosed specifier parameter, assuming '<', consider using something like p<<>.");
			}
		}
		else
		{
			logprintf("sscanf warning: Unenclosed specifier parameters are deprecated, consider using something like p<<>.");
		}
		++(*format);
		return '<';
	}
	else if (tmp)
	{
		// Legacy support.
		logprintf("sscanf warning: Unenclosed specifier parameters are deprecated, consider using something like p<%c>.", tmp);
		++(*format);
		return tmp;
	}
	else
	{
		logprintf("sscanf warning: No specified parameter found.");
		return ' ';
	}
}

char *
	GetMultiType(char ** format)
{
	char
		* cur = *format,
		* ret = cur;
	if (*cur == '<')
	{
		++ret;
		bool
			reop = false,
			escape = false;
		do
		{
			if (*cur == '\\')
			{
				escape = !escape;
			}
			else
			{
				escape = false;
			}
			++cur;
			if (!escape)
			{
				if (reop)
				{
					if (*cur == '>')
					{
						reop = false;
						++cur;
					}
				}
				else
				{
					if (*cur == '<')
					{
						reop = true;
						++cur;
					}
				}
			}
		}
		while (*cur && (reop || escape || *cur != '>'));
		if (*cur)
		{
			// Only gets here if there is a closing '>'.
			*cur = '\0';
			*format = cur + 1;
			return ret;
		}
		else
		{
			logprintf("sscanf error: Unclosed specifier parameters.");
		}
	}
	else
	{
		logprintf("sscanf error: No specified parameters found.");
	}
	*format = cur;
	return 0;
}

unsigned int
	GetUserString(char * string, char ** end)
{
	unsigned int
		id = 0;
	char
		cur;
	// Get the full name, they can't contain spaces in this code.  If a
	// player's name manages to contain spaces (e.g. via SetPlayerName), then
	// you can only do the part of the name up to the space.
	while ((cur = *string) && !IsSpacer(cur))
	{
		// Valid string item.
		++string;
		if ((unsigned char)(cur - '0') >= 10)
		{
			// Invalid number, so not an ID.
			break;
		}
		// Still a valid ID, continue collecting.
		id = (id * 10) + (cur - '0');
	}
	*end = string;
	// Don't use extra checks every loop any more, just one will do.
	if (!IsSpacer(cur))
	{
		// Invalid ID, just find the end of the name.
		FindSpacer(end);
		// Save the ID as too large for detection later.
		id = g_iTrueMax;
	}
	return id;
}

int
	GetDecValue(char ** const input)
{
	char *
		str = *input;
	int
		val = 0;
	unsigned char
		cur;
	// Convert to a number and test it.
	while ((cur = (unsigned char)(*str - '0')) < 10)
	{
		// Update the current value.
		val = (val * 10) + cur;
		// Update the current pointer.
		++str;
	}
	// Save the pointer.
	*input = str;
	// Covert the sign and return without an if.
	return val;
}

int
	GetDec(char ** const input)
{
	char *
		str = *input;
	int
		neg = 1;
	switch (*str)
	{
		case '-':
			neg = -1;
			// FALLTHROUGH
		case '+':
			// Check there is valid data after
			if (((unsigned char)(*(++str) - '0')) >= 10)
			{
				// Just return now, the caller will recognise this as bad.
				return 0;
			}
	}
	*input = str;
	return GetDecValue(input) * neg;
}

int
	GetOctValue(char ** const input)
{
	char *
		str = *input;
	int
		val = 0;
	unsigned char
		cur;
	// Convert to a number and test it.
	while ((cur = (unsigned char)(*str - '0')) < 8)
	{
		// Update the current value.
		val = (val * 8) + cur;
		// Update the current pointer.
		++str;
	}
	// Save the pointer.
	*input = str;
	// Covert the sign and return without an if.
	return val;
}

int
	GetOct(char ** const input)
{
	char *
		str = *input;
	int
		neg = 1;
	switch (*str)
	{
		case '-':
			neg = -1;
			// FALLTHROUGH
		case '+':
			// Check there is valid data after
			if (((unsigned char)(*(++str) - '0')) >= 8)
			{
				// Just return now, the caller will recognise this as bad.
				return 0;
			}
	}
	*input = str;
	return GetOctValue(input) * neg;
}

int
	GetHexValue(char ** const input)
{
	char *
		str = *input;
	int
		val = 0;
	// Rewrote it using a big switch.
	for ( ; ; )
	{
		switch (*str)
		{
			case '0':
				val = (val * 16) + 0x00;
				break;
			case '1':
				val = (val * 16) + 0x01;
				break;
			case '2':
				val = (val * 16) + 0x02;
				break;
			case '3':
				val = (val * 16) + 0x03;
				break;
			case '4':
				val = (val * 16) + 0x04;
				break;
			case '5':
				val = (val * 16) + 0x05;
				break;
			case '6':
				val = (val * 16) + 0x06;
				break;
			case '7':
				val = (val * 16) + 0x07;
				break;
			case '8':
				val = (val * 16) + 0x08;
				break;
			case '9':
				val = (val * 16) + 0x09;
				break;
			case 'a':
			case 'A':
				val = (val * 16) + 0x0A;
				break;
			case 'b':
			case 'B':
				val = (val * 16) + 0x0B;
				break;
			case 'c':
			case 'C':
				val = (val * 16) + 0x0C;
				break;
			case 'd':
			case 'D':
				val = (val * 16) + 0x0D;
				break;
			case 'e':
			case 'E':
				val = (val * 16) + 0x0E;
				break;
			case 'f':
			case 'F':
				val = (val * 16) + 0x0F;
				break;
			default:
				// UGLY UGLY UGLY!
				goto sscanf_hex_switch;
		}
		++str;
	}
	// UGLY UGLY UGLY - Needed for the double level break, which isn't native
	// in C.
	sscanf_hex_switch:
	// Save the pointer.
	*input = str;
	// Covert the sign and return without an if.
	return val;
}

int
	GetHex(char ** const input)
{
	char *
		str = *input;
	int
		neg = 1;
	switch (*str)
	{
		case '-':
			neg = -1;
			// FALLTHROUGH
		case '+':
			// Check there is valid data after
			if (((unsigned char)(*(++str) - '0')) >= 10)
			{
				// Just return now, the caller will recognise this as bad.
				return 0;
			}
	}
	if (*str == '0')
	{
		if (*(str + 1) == 'x' || *(str + 1) == 'X')
		{
			// Check there is real data, otherwise it's bad.
			str += 2;
			if ((*str < '0') || ((*str > '9') && ((*str | 0x20) < 'a')) || ((*str | 0x20) > 'f'))
			{
				*input = str - 1;
				return 0;
			}
		}
	}
	else if ((*str < '0') || ((*str > '9') && ((*str | 0x20) < 'a')) || ((*str | 0x20) > 'f'))
	{
		*input = str;
		return 0;
	}
	*input = str;
	return GetHexValue(input) * neg;
	// Convert to a number and test it.  Horribly manually optimised - one of
	// these days I'll try write an ASM hex reader and see how well that works.
	// Actually I think I have written one before, but I don't know where it is
	// and I'm not sure how optimised it is.  Anyway, this version works and
	// avoids loads of big switches (although a single large switch may be more
	// efficient thinking about it).
	/*while ((cur = (unsigned char)((*str | 0x20) - '0')))
	{
		if (cur < 10)
		{
			// 0 - 9
			val = (val * 16) + cur;
		}
		else
		{
			cur -= ('a' - '0');
			if (cur < 6)
			{
				// A - F, a - f
				val = (val * 16) + cur + 10;
			}
			else
			{
				// End of the number.
				// Save the pointer.
				*input = str;
				// Covert the sign and return without an if.
				return val * neg;
			}
		}
	}*/
}

unsigned int
	GetBoolValue(char ** const input)
{
	char *
		str = *input;
	unsigned int
		val = 0;
	for ( ; ; ++str)
	{
		if (*str == '0')
		{
			val <<= 1;
		}
		else if (*str == '1')
		{
			val = (val << 1) | 1;
		}
		else
		{
			break;
		}
	}
	// Save the pointer.
	*input = str;
	return val;
}

int
	GetBool(char ** const input)
{
	char *
		str = *input;
	if (*str == '0')
	{
		if (*(str + 1) == 'b' || *(str + 1) == 'B')
		{
			// Check there is real data, otherwise it's bad.
			str += 2;
			if (*str != '0' && *str != '1')
			{
				*input = str - 1;
				return 0;
			}
		}
	}
	else if (*str != '1')
	{
		*input = str;
		return 0;
	}
	*input = str;
	return (int)GetBoolValue(input);
}

int
	GetNumber(char ** const input)
{
	char *
		str = *input;
	int
		neg = 1;
	switch (*str)
	{
		case '-':
			neg = -1;
			// FALLTHROUGH
		case '+':
			// Check there is valid data after
			if (((unsigned char)(*(++str) - '0')) >= 10)
			{
				// Just return now, the caller will recognise this as bad.
				return 0;
			}
	}
	if (*str == '0')
	{
		++str;
		switch (*str)
		{
			case 'x':
			case 'X':
				// Hex.
				++str;
				if (((*str >= '0') && (*str <= '9')) || (((*str | 0x20) >= 'a') && ((*str | 0x20) <= 'f')))
				{
					*input = str;
					return GetHexValue(input) * neg;
				}
				else
				{
					*input = str - 1;
					return 0;
				}
			case 'b':
			case 'B':
				// Bool.
				if (neg == -1)
				{
					// Can't have negative booleans.
					*input = str;
					return 0;
				}
				else
				{
					++str;
					if ((*str == '0') || (*str == '1'))
					{
						*input = str;
						return (int)GetBoolValue(input);
					}
					else
					{
						*input = str - 1;
						return 0;
					}
				}
			case '0':
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
				// Octal.
				*input = str;
				return GetOctValue(input) * neg;
			case '8':
			case '9':
				// Decimal.
				break;
			default:
				*input = str;
				return 0;
		}
	}
	else if ((*str < '0') || (*str > '9'))
	{
		*input = str;
		return 0;
	}
	*input = str;
	return GetDecValue(input) * neg;
}

bool
	GetLogical(char ** const input)
{
	// Boolean values - if it's not '0' or 'false' then it's  true.  I could be
	// strict and make them enter '1' or 'true' for true, but I'm not going to.
	char *
		string = *input;
	bool
		ret;
	switch (*string++)
	{
		case '0':
			// Set the value to false till we decide otherwise.
			ret = false;
			while (!IsSpacer(*string))
			{
				if (*string++ != '0')
				{
					// Value is not false, thus is true.
					ret = true;
					break;
				}
			}
			// Let the cleanup code below handle excess chars.
			break;
		case 'f':
		case 'F':
			// Default to true unless we find "false" exactly.
			ret = true;
			if ((*string | 0x20) == 'a')
			{
				++string;
				if ((*string | 0x20) == 'l')
				{
					++string;
					if ((*string | 0x20) == 's')
					{
						++string;
						if ((*string | 0x20) == 'e')
						{
							++string;
							// We have the whole word, check that it's on its
							// own, i.e. is followed by a space or delimiter
							// Note that if your delimiter is in the word
							// "false", you may have a bug here but they seem
							// like odd delimiter characters tbh.
							if (IsSpacer(*string))
							{
								// Exact word found on its own so save the fact
								// that it's false.
								ret = false;
							}
						}
					}
				}
			}
			break;
		default:
			ret = true;
		break;
	}
	// Skip the rest of the data.
	*input = string;
	FindSpacer(input);
	return ret;
}

bool
	FindDefaultStart(char ** const str)
{
	// Skip the default value passed for optional parameters.
	if (**str == '(')
	{
		++(*str);
		SkipWhitespace(str);
		return true;
	}
	else
	{
		logprintf("sscanf warning: No default value found.");
	}
	return false;
}

void
	SkipDefault(char ** const str)
{
	if (FindDefaultStart(str))
	{
		// Default value found - skip it.
		do
		{
			++(*str);
		}
		while (**str && **str != ')');
		if (**str)
		{
			// Current pointer points to the close bracket, skip it.
			++(*str);
		}
		else
		{
			logprintf("sscanf warning: Unclosed default value.");
		}
	}
}

void
	SkipDefaultEx(char ** const data)
{
	// Skip the default value passed for optional parameters.
	char *
		str = *data;
	if (*str == '(')
	{
		// Default value found - skip it.
		bool
			escape = false;
		while (*str && (escape || *str != ')'))
		{
			if (*str == '\\')
			{
				// Invert the escape, they may do:
				// S(a\)
				// Where the default string is "a\", in which case we need a
				// way to tell the system not to include the close bracket,
				// which would be:
				// S(a\\)
				// Or, in real PAWN terms:
				// S(a\\\\)
				// Of course, they can also do:
				// S(\\\\\\\\\\))
				// To get a final string of "\\)".  Yes, you need FOUR slashes
				// in a PAWN string to get just one in the output string.
				escape = !escape;
			}
			else
			{
				escape = false;
			}
			++str;
		}
		if (*str)
		{
			// Current pointer points to the close bracket, skip it.
			++str;
		}
		else
		{
			logprintf("sscanf warning: Unclosed default value.");
		}
	}
	else
	{
		logprintf("sscanf warning: No default value found.");
	}
	*data = str;
}

void
	SkipLength(char ** const input)
{
	// Get an easy pointer to the data to manipulate.
	char *
		str = *input;
	if (*str == '[')
	{
		while (*(++str))
		{
			// Don't check the length is valid, that's effort and slow.
			if (*str == ']')
			{
				*input = str + 1;
				return;
			}
		}
		// If we get here then the end of the string was reached before the
		// valid end of the length.
		*input = str;
		logprintf("sscanf warning: Missing string length end.");
	}
	else
	{
		logprintf("sscanf warning: Arrays without a length are deprecated, please add a destination size.");
	}
}

int
	GetLength(char ** const input, bool error)
{
	if (**input == '[')
	{
		++(*input);
		int
			length = GetDec(input);
		char *
			str = *input;
		if (length <= 0)
		{
			if (error)
			{
				length = 0;
				logprintf("sscanf error: Invalid data length.");
			}
			else
			{
				length = SSCANF_MAX_LENGTH;
				logprintf("sscanf warning: Invalid data length.");
			}
		}
		if (*str == ']')
		{
			// Valid end: [number]
			*input = str + 1;
			return length;
		}
		else if (*str)
		{
			// Invalid character: [numberX]
			logprintf("sscanf warning: Invalid character in data length.");
			// Loop through the string till we find an end to the size.
			while (*(++str))
			{
				if (*str == ']')
				{
					// Valid end: [numberX]
					*input = str + 1;
					return length;
				}
			}
		}
		// Invalid end: [number
		logprintf("sscanf warning: Missing length end.");
		*input = str;
		return length;
	}
	else if (error)
	{
		logprintf("sscanf error: String/array must include a length, please add a destination size.");
		return 0;
	}
	else
	{
		logprintf("sscanf warning: Strings without a length are deprecated, please add a destination size.");
		return SSCANF_MAX_LENGTH;
	}
}

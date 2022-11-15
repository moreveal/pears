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

#include "SDK/amx/amx.h"

#include "utils.h"
#include "specifiers.h"
#include "data.h"
#include "sscanf.h"

extern logprintf_t
	logprintf;

#define SAVE_VALUE(m)            \
	if (cptr)                    \
		*cptr++ = m

#define SAVE_VALUE_F(m)          \
	if (cptr) {                  \
		float f = (float)m;      \
		*cptr++ = amx_ftoc(f); }

#define UPDATE_VALUES(m)         \
	if (defaults) {              \
		if (count) {             \
			diff.c = m - last.c; \
			last.c = m;          \
		} else {                 \
			last.c = m;          \
			diff.c = 0; } }      \
	SkipOneSpacer(&string);      \
	++count

#define UPDATE_VALUES_F(m)       \
	if (defaults) {              \
		if (count) {             \
			diff.d = m - last.d; \
			last.d = m;          \
		} else {                 \
			last.d = m;          \
			diff.d = 0; } }      \
	SkipOneSpacer(&string);      \
	++count

#define DO_LOOP(n)                                 \
	count < length && *string && Do##n(&string, &b)

// Macros for the regular values.
#define DO(m,n)                     \
	{m b;                           \
	while (DO_LOOP(n)) {            \
		SAVE_VALUE((cell)b);        \
		UPDATE_VALUES((cell)b); } } \
	break;

#define DOV(m,n)                        \
	{m b;                               \
	while (count < length && *string) { \
		Do##n(&string, &b);             \
		SAVE_VALUE((cell)b);            \
		UPDATE_VALUES((cell)b); } }     \
	break;

#define DOF(m,n)                \
	{m b;                       \
	while (DO_LOOP(n)) {        \
		SAVE_VALUE_F(b)         \
		UPDATE_VALUES_F(b); } } \
	break;

#define OPTIONAL_INVALID \
	logprintf("sscanf warning: Optional types invalid in array specifiers, consider using 'A'.")

#define DX(m,n) \
	OPTIONAL_INVALID;

#define DXF(m,n) \
	OPTIONAL_INVALID;

union update_u
{
	cell
		c;
	double
		d;
};

int
	DoArrayValues(char type, char ** input, cell * cptr, int length, bool defaults)
{
	int
		count = 0;
	union update_u
		last,
		diff;
	last.d = 0;
	diff.d = 0;
	char *
		string = *input;
	switch (type)
	{
		// Copied directly from the main loop, just with different macros.
		case 'L':
			DX(bool, L)
			// FALLTHROUGH
		case 'l':
			{
				// The only custom code here.  If the result is either "true"
				// or "false" it makes no sense to alternate in defaults as we
				// will just end up with larger values of true.
				bool
					b;
				while (count < length && *string)
				{
					DoL(&string, &b);
					SAVE_VALUE((cell)b);
					if (defaults)
					{
						last.c = (cell)b;
					}
					SkipOneSpacer(&string);
					++count;
				}
			}
			break;
		case 'B':
			DX(int, B)
			// FALLTHROUGH
		case 'b':
			DO(int, B)
		case 'N':
			DX(int, N)
			// FALLTHROUGH
		case 'n':
			DO(int, N)
		case 'C':
			DX(char, C)
			// FALLTHROUGH
		case 'c':
			DO(char, C)
		case 'I':
		case 'D':
			DX(int, I)
			// FALLTHROUGH
		case 'i':
		case 'd':
			DO(int, I)
		case 'H':
		case 'X':
			DX(int, H)
			// FALLTHROUGH
		case 'h':
		case 'x':
			DO(int, H)
		case 'O':
			DX(int, O)
			// FALLTHROUGH
		case 'o':
			DO(int, O)
		case 'F':
			DXF(double, F)
			// FALLTHROUGH
		case 'f':
			DOF(double, F)
		case 'G':
			DXF(double, G)
			// FALLTHROUGH
		case 'g':
			{
				double
					b;
				while (DO_LOOP(G))
				{
					float
						f = (float)b;
					if (cptr)
					{
						*cptr++ = amx_ftoc(f);
					}
					if (defaults)
					{
						switch (amx_ftoc(f))
						{
							default:
								if (count)
								{
									diff.d = b - last.d;
									last.d = b;
									break;
								}
								// FALLTHROUGH
							case FLOAT_NEG_INFINITY:
							case FLOAT_INFINITY:
							case FLOAT_NAN:
							case FLOAT_NAN_E:
								last.d = b;
								diff.d = 0;
								break;
						}
					}
					SkipOneSpacer(&string);
					++count;
				}
			}
			break;
		case 'U':
			DX(int, U)
			// FALLTHROUGH
		case 'u':
			DOV(int, U)
			break;
		case 'Q':
			DX(int, Q)
			// FALLTHROUGH
		case 'q':
			DOV(int, Q)
			break;
		case 'R':
			DX(int, R)
			// FALLTHROUGH
		case 'r':
			DOV(int, R)
			break;
		case 'A':
		case 'a':
			logprintf("sscanf error: Multi-dimensional arrays are not supported.");
			return SSCANF_FAIL_RETURN;
		case '\'':
			logprintf("sscanf error: Search strings are not supported in arrays.");
			return SSCANF_FAIL_RETURN;
		case 'P':
		case 'p':
			logprintf("sscanf error: Delimiters are not supported in arrays.");
			return SSCANF_FAIL_RETURN;
		case 'Z':
		case 'z':
		case 'S':
		case 's':
			logprintf("sscanf error: Strings are not supported in arrays.");
			return SSCANF_FAIL_RETURN;
		case '{':
		case '}':
			logprintf("sscanf error: Quiet sections are not supported in arrays.");
			return SSCANF_FAIL_RETURN;
		default:
			logprintf("sscanf error: Unknown format specifier '%c'.", type);
			return SSCANF_FAIL_RETURN;
	}
	// Save the end of the string.
	*input = string;
	if (defaults)
	{
		if (count < length)
		{
			if (*string)
			{
				// Error in format specifier.
				logprintf("sscanf warning: Invalid values in array defaults.");
			}
			else if (((type | 0x20) == 'f') || ((type | 0x20) == 'g'))
			{
				// Float type.
				do
				{
					last.d += diff.d;
					SAVE_VALUE_F(last.d);
					++count;
				}
				while (count < length);
			}
			else
			{
				do
				{
					// Other type.
					while (count < length)
					{
						last.c += diff.c;
						SAVE_VALUE(last.c);
						++count;
					}
				}
				while (count < length);
			}
		}
		else if (*string)
		{
			logprintf("sscanf warning: Excess array defaults found.");
		}
	}
	else
	{
		if (count < length)
		{
			if (*string)
			{
				// Invalid value entered.
				return SSCANF_FAIL_RETURN;
			}
			else
			{
				// Ran out of values - check if this is an optional array at a
				// higher level.
				return SSCANF_CONT_RETURN;
			}
		}
	}
	return SSCANF_TRUE_RETURN;
}

bool
	DoA(char ** defaults, char ** input, cell * cptr, bool optional)
{
	// First, get the type of the array.
	char
		type = GetSingleType(defaults),
		* opts = 0;
	if (optional)
	{
		// Optional parameters - just collect the data for
		// now and use it later.
		if (**defaults == '(')
		{
			// Find the end of the options.  Based on
			// SkipDefaultEx, but saving the start point.
			++(*defaults);
			SkipWhitespace(defaults);
			// Got the start of the values.
			opts = *defaults;
			// Skip the defaults for now, we don't know the length yet.
			while (**defaults && **defaults != ')')
			{
				// Don't need to check for escaped ")"s here as you can't have
				// arrays of strings, which is the only place that would be.
				++(*defaults);
			}
			if (**defaults)
			{
				if (opts == *defaults)
				{
					// No defaults found.
					logprintf("sscanf warning: Empty default values.");
					optional = false;
				}
				// Found a valid end.  Make it null for
				// later array getting (easy to detect a
				// null end and we'll never need to
				// backtrack to here in the specifiers).
				**defaults = '\0';
				++(*defaults);
			}
			else
			{
				logprintf("sscanf warning: Unclosed default value.");
			}
		}
		else
		{
			logprintf("sscanf warning: No default value found.");
			optional = false;
		}
	}
	// GetLength has "true" as arrays, being new, MUST have lengths.
	int
		length = GetLength(defaults, true);
	if (length)
	{
		// Got the length of the array, it's all good.
		if (optional)
		{
			// Optional parameters are always separated by commans, not
			// whatever the coder may choose.
			TempDelimiter(',');
			if (DoArrayValues(type, &opts, cptr, length, true) == SSCANF_FAIL_RETURN)
			{
				RestoreDelimiter();
				return false;
			}
			RestoreDelimiter();
		}
		if (input)
		{
			switch (DoArrayValues(type, input, cptr, length, false))
			{
				case SSCANF_CONT_RETURN:
					if (optional)
					{
						return true;
					}
					else
					{
						return false;
					}
				case SSCANF_TRUE_RETURN:
					return true;
				default:
					return false;
			}
		}
		else
		{
			return true;
		}
	}
	// Default fail - only gets here if there is no length.
	return false;
}

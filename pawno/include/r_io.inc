/**
--------------------------------------------------------------------------
|           |==============================================|             |
|           |          Binary Read/Write funtions          |             |
|           |============================ v0.2 ============|             |
|                                                                        |
|		    |=== Authors: =================================|             |
|		    |=> Aleks10           (Aleksey.al09@gmail.com) |             |
|           |=> Romanius               (romanius@namba.kg) |             |
|		    |==============================================|             |
|                                                                        |
|  This script is free software: you can redistribute it and/or modify   |
|  it under the terms of the GNU General Public License as published by  |
|  the Free Software Foundation, either version 3 of the License, or     |
|  (at your option) any later version.                                   |
|                                                                        |
|  This script is distributed in the hope that it will be useful,        |
|  but WITHOUT ANY WARRANTY; without even the implied warranty of        |
|  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         |
|  GNU General Public License for more details.                          |
|                                                                        |
|  You should have received a copy of the GNU General Public License     |
|  along with this script.  If not, see <http://www.gnu.org/licenses/>.  |
|																		 |
--------------------------------------------------------------------------
**/

#if defined _r_io_included
	#endinput
#endif
#define _r_io_included

#include <file>

// Считывает 1 байт из файла
stock readByte(File:f)
{
	new b;
	
	b = fgetchar(f, b, false);
	
	return b;
}

// Считывает 2 байта из файла
stock readInt16(File:f)
{
	new b[2];
	
	b[0] = fgetchar(f, b[0], false);
	b[1] = fgetchar(f, b[1], false);
	
	return (b[1] << 8) | b[0];
}

// Считывает 4 байта из файла
stock readInt32(File:f)
{
	new b[4];
	
	b[0] = fgetchar(f, b[0], false);
	b[1] = fgetchar(f, b[1], false);
	b[2] = fgetchar(f, b[2], false);
	b[3] = fgetchar(f, b[3], false);
	
	return (b[3] << 24) | (b[2] << 16) | (b[1] << 8) | b[0];
}

// Записывает 1 байт в фаил
stock writeByte(File:f, data)
{
	fputchar(f, data, false);
}

// Записывает 2 байта в фаил
stock writeInt16(File:f, data)
{
	new b[2];
	
	b[0] = (data & 0xFF00) >> 8;
	b[1] = data & 0xFF;
	
	fputchar(f, b[1], false);
	fputchar(f, b[0], false);
}

// Записывает 4 байта в фаил
stock writeInt32(File:f, data)
{
	new b[4];
	
	b[0] = (data & 0xFF000000) >> 24;
	b[1] = (data & 0x00FF0000) >> 16;
	b[2] = (data & 0x0000FF00) >> 8;
	b[3] = data & 0x000000FF;
	
	fputchar(f, b[3], false);
	fputchar(f, b[2], false);
	fputchar(f, b[1], false);
	fputchar(f, b[0], false);
}
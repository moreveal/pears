
#if !defined BYTES_PER_CELL
	#define BYTES_PER_CELL (cellbits / 8)
#endif

/*
	Создание новой подобной функции:

	1. Скопировать этот код в новую функцию.
	2. Изменить DEFAULT_ARGS на количество аргументов до const format[].
	3. При необходимости изменить размер буфера BUFFER_SIZE.
*/
stock ErrorMessage(playerid, const str[], {_,Float}: ...)
{
	const
		DEFAULT_ARGS = 1,
		STACK_OFFSET = -4,
		BUFFER_SIZE = 1024,
        _BYTES_PER_CELL = BYTES_PER_CELL; // trick for pass it to #emit

	static buffer[BUFFER_SIZE], num_args, va_args_addr, i;
	
	// get args count and last arg offset
	{
		#emit load.s.pri 8
		#emit stor.pri num_args
		#emit const.alt 8
		#emit add
		#emit stor.pri va_args_addr
	}

	num_args /= BYTES_PER_CELL;
	if (num_args == DEFAULT_ARGS + 1)
	{
		buffer[0] = 0;
		strcat(buffer, str);
	}
	else
	{
		// copy args, call format()
		{
			num_args -= DEFAULT_ARGS;

			// copy args to lower stack
			#emit stack STACK_OFFSET
			for (i = 0; i < num_args; i++)
			{
				static offset;
				offset = i * BYTES_PER_CELL;
				
				#emit addr.alt 0
				#emit load.pri va_args_addr
				#emit add
				#emit load.alt offset
				#emit sub
				#emit load.i
				#emit push.pri
			}

			num_args *= BYTES_PER_CELL;

			// format(output[], len, const format[], ...)
			#emit push.c BUFFER_SIZE
			#emit push.c buffer
			#emit load.pri num_args
			#emit const.alt _BYTES_PER_CELL
			#emit shl.c.alt 1 // buffer + size
            #emit add
			#emit push.pri
			#emit sysreq.c format

			// restore stack
			#emit lctrl 5
			#emit sctrl 4
		}
	}

    ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, "{ff0000}*", buffer, "*", "");
    PlayerPlaySound(playerid, 4203);

    return 1;
}

stock SuccessMessage(playerid, const str[], {_,Float}: ...)
{
	const
		DEFAULT_ARGS = 1,
		STACK_OFFSET = -4,
		BUFFER_SIZE = 1024,
        _BYTES_PER_CELL = BYTES_PER_CELL; // trick for pass it to #emit

	static buffer[BUFFER_SIZE], num_args, va_args_addr, i;
	
	// get args count and last arg offset
	{
		#emit load.s.pri 8
		#emit stor.pri num_args
		#emit const.alt 8
		#emit add
		#emit stor.pri va_args_addr
	}

	num_args /= BYTES_PER_CELL;
	if (num_args == DEFAULT_ARGS + 1)
	{
		buffer[0] = 0;
		strcat(buffer, str);
	}
	else
	{
		// copy args, call format()
		{
			num_args -= DEFAULT_ARGS;

			// copy args to lower stack
			#emit stack STACK_OFFSET
			for (i = 0; i < num_args; i++)
			{
				static offset;
				offset = i * BYTES_PER_CELL;
				
				#emit addr.alt 0
				#emit load.pri va_args_addr
				#emit add
				#emit load.alt offset
				#emit sub
				#emit load.i
				#emit push.pri
			}

			num_args *= BYTES_PER_CELL;

			// format(output[], len, const format[], ...)
			#emit push.c BUFFER_SIZE
			#emit push.c buffer
			#emit load.pri num_args
			#emit const.alt _BYTES_PER_CELL
			#emit shl.c.alt 1 // buffer + size
            #emit add
			#emit push.pri
			#emit sysreq.c format

			// restore stack
			#emit lctrl 5
			#emit sctrl 4
		}
	}

    ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, "{99ff66}*", buffer, "*", "");
    PlayerPlaySound(playerid, 6401);

    return 1;
}

stock ErrorText(playerid, const str[], {_,Float}: ...)
{
	const
		DEFAULT_ARGS = 1,
		STACK_OFFSET = -4,
		BUFFER_SIZE = 144,
        _BYTES_PER_CELL = BYTES_PER_CELL; // trick for pass it to #emit

	static buffer[BUFFER_SIZE], num_args, va_args_addr, i;
	
	// get args count and last arg offset
	{
		#emit load.s.pri 8
		#emit stor.pri num_args
		#emit const.alt 8
		#emit add
		#emit stor.pri va_args_addr
	}

	num_args /= BYTES_PER_CELL;
	if (num_args == DEFAULT_ARGS + 1)
	{
		buffer[0] = 0;
		strcat(buffer, str);
	}
	else
	{
		// copy args, call format()
		{
			num_args -= DEFAULT_ARGS;

			// copy args to lower stack
			#emit stack STACK_OFFSET
			for (i = 0; i < num_args; i++)
			{
				static offset;
				offset = i * BYTES_PER_CELL;
				
				#emit addr.alt 0
				#emit load.pri va_args_addr
				#emit add
				#emit load.alt offset
				#emit sub
				#emit load.i
				#emit push.pri
			}

			num_args *= BYTES_PER_CELL;

			// format(output[], len, const format[], ...)
			#emit push.c BUFFER_SIZE
			#emit push.c buffer
			#emit load.pri num_args
			#emit const.alt _BYTES_PER_CELL
			#emit shl.c.alt 1 // buffer + size
            #emit add
			#emit push.pri
			#emit sysreq.c format

			// restore stack
			#emit lctrl 5
			#emit sctrl 4
		}
	}

    SendClientMessage(playerid, COLOR_GREY, buffer);
    PlayerPlaySound(playerid, 4203);

    return 1;
}

#if !defined BYTES_PER_CELL
  #define BYTES_PER_CELL (cellbits / 8)
#endif

/*
  Создание новой подобной функции:

  1. Скопировать этот код в новую функцию.
  2. Изменить DEFAULT_ARGS на количество аргументов до const format[].
  3. Добавить обработку, если доп. параметры не были переданы (numargs() == DEFAULT_ARGS + 1)
  4. Сохранить значения под "save all values" (прибавлять по 4 для каждого)
  5. Добавить восстановление значений под "restore stack" (в обратном порядке)
*/
stock ErrorMessage(playerid, const str[], {_,Float}: ...)
{
    const
    STATIC_ARGS = 3, // постоянные аргументы (frm, ret, args_size)
    DEFAULT_ARGS = 1, // кол-во аргументов до const format[]
    _BYTES_PER_CELL = BYTES_PER_CELL;

    if (numargs() == DEFAULT_ARGS + 1) 
    {
        ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, "{ff6347}*", str, "*", "");
        PlayerPlaySound(playerid, 4203);
        return 1;
    }

    static buffer[144], size = sizeof(buffer), WRITE_OFFSET = (STATIC_ARGS + DEFAULT_ARGS) * BYTES_PER_CELL;
    static _base, _frm, _ret, _args, _playerid;

    // save all values
    #emit lctrl 4
    #emit stor.pri _base
    #emit load.s.pri 0
    #emit stor.pri _frm
    #emit load.s.pri 4
    #emit stor.pri _ret
    #emit load.s.pri 8
    #emit stor.pri _args
    #emit load.s.pri 12
    #emit stor.pri _playerid

    #pragma warning disable 226
    _playerid = playerid;
    #pragma warning enable 226

    // format(output[], len, const format[], ...)
    #emit load.pri _base
    #emit load.alt WRITE_OFFSET
    #emit add
    #emit sctrl 4
    #emit push size
    #emit push.c buffer

    // calculate args amount
    #emit load.pri _args
    #emit const.alt _BYTES_PER_CELL
    #emit udiv
    #emit const.alt DEFAULT_ARGS
    #emit sub
    #emit const.alt 2 // buffer, sizeof(buffer)
    #emit add
    #emit const.alt _BYTES_PER_CELL
    #emit umul
    #emit push.pri
    #emit sysreq.c format

    // restore stack
    #emit load.pri _base
    #emit load.alt WRITE_OFFSET
    #emit add
    #emit sctrl 4
    #emit push _playerid
    #emit push _args
    #emit push _ret
    #emit push _frm

    ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, "{ff6437}*", buffer, "*", "");
    PlayerPlaySound(playerid, 4203);

    return 1;
}

stock SuccessMessage(playerid, const str[], {_,Float}: ...)
{
    const
    STATIC_ARGS = 3, // постоянные аргументы (frm, ret, args_size)
    DEFAULT_ARGS = 1, // кол-во аргументов до const format[]
    _BYTES_PER_CELL = BYTES_PER_CELL;

    if (numargs() == DEFAULT_ARGS + 1) 
    {
        ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, "{99ff66}*", str, "*", "");
        PlayerPlaySound(playerid, 6401);
        return 1;
    }

    static buffer[144], size = sizeof(buffer), WRITE_OFFSET = (STATIC_ARGS + DEFAULT_ARGS) * BYTES_PER_CELL;
    static _base, _frm, _ret, _args, _playerid;

    // save all values
    #emit lctrl 4
    #emit stor.pri _base
    #emit load.s.pri 0
    #emit stor.pri _frm
    #emit load.s.pri 4
    #emit stor.pri _ret
    #emit load.s.pri 8
    #emit stor.pri _args
    #emit load.s.pri 12
    #emit stor.pri _playerid

    #pragma warning disable 226
    _playerid = playerid;
    #pragma warning enable 226

    // format(output[], len, const format[], ...)
    #emit load.pri _base
    #emit load.alt WRITE_OFFSET
    #emit add
    #emit sctrl 4
    #emit push size
    #emit push.c buffer

    // calculate args amount
    #emit load.pri _args
    #emit const.alt _BYTES_PER_CELL
    #emit udiv
    #emit const.alt DEFAULT_ARGS
    #emit sub
    #emit const.alt 2 // buffer, sizeof(buffer)
    #emit add
    #emit const.alt _BYTES_PER_CELL
    #emit umul
    #emit push.pri
    #emit sysreq.c format

    // restore stack
    #emit load.pri _base
    #emit load.alt WRITE_OFFSET
    #emit add
    #emit sctrl 4
    #emit push _playerid
    #emit push _args
    #emit push _ret
    #emit push _frm

    ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, "{99ff66}*", buffer, "*", "");
    PlayerPlaySound(playerid, 6401);

    return 1;
}

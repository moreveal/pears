
/*stock PPcache_get_value_name_int(zalupa, const text[], hyi)
{
	if (!cache_get_value_name_int(zalupa, text, hyi)) 
	{
		PrintBacktrace();
		return 0;
	}
	return 1;
}

#if defined _ALS_cache_get_value_name_int
    #undef cache_get_value_name_int
#else
    #define _ALS_cache_get_value_name_int
#endif
#define cache_get_value_name_int PPcache_get_value_name_int*/

// Закрываем диалоговое окно (Перехват функции)
stock PPHidePlayerDialog(playerid)
{
	SetPVarInt(playerid,"DialogID",-1);
	HidePlayerDialog(playerid);
	return true;
}

#if defined _ALS_HidePlayerDialog
    #undef HidePlayerDialog
#else
    #define _ALS_HidePlayerDialog
#endif
#define HidePlayerDialog PPHidePlayerDialog


// Аттач транспорта к транспорту (Перехват функции)
stock PPAttachTrailerToVehicle(trailerid, vehicleid)
{
	VehInfo[vehicleid][vAttachTrailer] = trailerid;
	AttachTrailerToVehicle(trailerid, vehicleid);
	return true;
}

#if defined _ALS_AttachTrailerToVehicle
    #undef AttachTrailerToVehicle
#else
    #define _ALS_AttachTrailerToVehicle
#endif
#define AttachTrailerToVehicle PPAttachTrailerToVehicle


/*stock PPmysql_format(MySQL:handle, output[], max_len, const format[], {MySQL, Float,_}:...)
{
    if(!mysql_format(handle, output, max_len, format, {MySQL, Float,_}:...))
    {
        PrintBacktrace();
    }
	return true;
}

#if defined _ALS_mysql_format
    #undef mysql_format
#else
    #define _ALS_mysql_format
#endif
#define mysql_format PPmysql_format*/

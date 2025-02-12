#define GEO_IP_INFO_DETECT_URL          "ip-api.com/csv/"
#define GEO_IP_INFO_DETECT_URL_FIELDS   "?fields=131793"
 
#define GEO_MAX_IP_LENGTH               16
#define GEO_MAX_COUNTRY_NAME_LENGTH     32
#define GEO_MAX_CITY_NAME_LENGTH        64
#define GEO_MAX_LAT_LON_LENGTH          24
#define GEO_MAX_PROVIDER_NAME_LENGTH    32
#define GEO_MAX_PROXY_LENGTH            12
 
enum e_PLAYER_GEO_INFORMATION
{
    player_ip[GEO_MAX_IP_LENGTH],
    player_country[GEO_MAX_COUNTRY_NAME_LENGTH],
    player_city[GEO_MAX_CITY_NAME_LENGTH],
    player_lat[GEO_MAX_LAT_LON_LENGTH],
    player_lon[GEO_MAX_LAT_LON_LENGTH],
    player_provider[GEO_MAX_PROVIDER_NAME_LENGTH],
    player_proxy[GEO_MAX_PROXY_LENGTH]
};
new
    player_geoInfo[MAX_PLAYERS][e_PLAYER_GEO_INFORMATION];
 
#define GetPlayerCountry(%0)        player_geoInfo[%0][player_country]
#define GetPlayerCity(%0)           player_geoInfo[%0][player_city]
#define GetPlayerLatitude(%0)       player_geoInfo[%0][player_lat]
#define GetPlayerLongtitude(%0)     player_geoInfo[%0][player_lon]
#define GetPlayerProvider(%0)       player_geoInfo[%0][player_provider]
#define GetPlayerProxyStatus(%0)    player_geoInfo[%0][player_proxy]

function p_geo_OnInformationRequested(playerid, response_code, data[])
{
    if(response_code == 200)
    {
        sscanf(data, "p<,>s[*]s[*]s[*]s[*]s[*]s[*]",
            GEO_MAX_COUNTRY_NAME_LENGTH, player_geoInfo[playerid][player_country],
            GEO_MAX_CITY_NAME_LENGTH, player_geoInfo[playerid][player_city],
            GEO_MAX_LAT_LON_LENGTH, player_geoInfo[playerid][player_lat],
            GEO_MAX_LAT_LON_LENGTH, player_geoInfo[playerid][player_lon],
            GEO_MAX_PROVIDER_NAME_LENGTH, player_geoInfo[playerid][player_provider],
            GEO_MAX_PROXY_LENGTH, player_geoInfo[playerid][player_proxy]);
    }
    else
    {
        strmid(player_geoInfo[playerid][player_country], "Неизвестно", 0, GEO_MAX_COUNTRY_NAME_LENGTH);
        strmid(player_geoInfo[playerid][player_city], "Неизвестно", 0, GEO_MAX_CITY_NAME_LENGTH);
        strmid(player_geoInfo[playerid][player_lat], "Неизвестно", 0, GEO_MAX_LAT_LON_LENGTH);
        strmid(player_geoInfo[playerid][player_lon], "Неизвестно", 0, GEO_MAX_LAT_LON_LENGTH);
        strmid(player_geoInfo[playerid][player_provider], "Неизвестно", 0, GEO_MAX_PROVIDER_NAME_LENGTH);
        strmid(player_geoInfo[playerid][player_proxy], "Неизвестно", 0, GEO_MAX_PROXY_LENGTH);
    }
    return 1;
}

stock PlayerGeo_OnPlayerConnect(playerid) {
    GetPlayerIp(playerid, player_geoInfo[playerid][player_ip], GEO_MAX_IP_LENGTH);
 
    new request[31 - 2 + GEO_MAX_IP_LENGTH];
 
    strcat(request, GEO_IP_INFO_DETECT_URL);
    strcat(request, player_geoInfo[playerid][player_ip]);
    strcat(request, GEO_IP_INFO_DETECT_URL_FIELDS);
 
    HTTP(playerid, HTTP_GET, request, "", "p_geo_OnInformationRequested");
}

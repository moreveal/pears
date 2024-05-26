#define MAX_WEATHER 2 // Максимальное количество заявок
// CreateDynamicCircle
new WeatherID = -1; // ID погоды
new WeatherCount; // Кол-во шагов
new dyn_zone_WeatherBasic[2];
new dyn_zone_WeatherNotBasic[2];

enum weatherInfo
{
    weatherUnix, // Время запуска погоды
    weatherStatus, // Статус погоды. 0 - нет. 1 - идет. 2 - прошла
    weatherID, // Ид погоды(8(0) - дождик 9(1) - туман 16(2) - гроза 19(3) - песчанная буря
    weatherDirection, // Направление
    Float:weatherDirectionCordStart[2], // Откуда полетит
    Float:weatherDirectionCordStop[2] // Куда полетит
}
new Weather[MAX_WEATHER][weatherInfo];

CMD:startweather(playerid)
{
    WeatherStart(0);
    return 1;
}

CMD:gotoweather(playerid)
{
    if(PlayerInfo[playerid][pSoska] == 0) return 0;
    if(WeatherID == -1) return ErrorMessage(playerid, "{ff6347} В данный момент нет зоны погоды");
    PPSetPlayerPos(playerid,Weather[WeatherID][weatherDirectionCordStart][0]+10*WeatherCount,Weather[WeatherID][weatherDirectionCordStart][1]+10*WeatherCount, 15.0);
    return 1;
}

stock WeatherStart(i)
{
    WeatherID = i;
    WeatherCount = 1;
    Weather[i][weatherStatus] = 1;
    dyn_zone_WeatherBasic[0] = CreateDynamicCircle(Weather[i][weatherDirectionCordStart][0],Weather[i][weatherDirectionCordStart][1], 800, 0,0,-1);
    dyn_zone_WeatherBasic[1] = CreateDynamicCircle(Weather[i][weatherDirectionCordStart][0]+10,Weather[i][weatherDirectionCordStart][1]+10, 800, 0,0,-1);
    dyn_zone_WeatherNotBasic[0] = CreateDynamicCircle(Weather[i][weatherDirectionCordStart][0],Weather[i][weatherDirectionCordStart][1], 1000, 0,0,-1);
    dyn_zone_WeatherNotBasic[1] = CreateDynamicCircle(Weather[i][weatherDirectionCordStart][0]+10,Weather[i][weatherDirectionCordStart][1]+10, 1000, 0,0,-1);
    return 1;
}

stock WeatherMoving()
{
    if(WeatherID == -1) return 0;
    new i = WeatherID;
    WeatherCount++;
    new county,countx;
    if(Weather[i][weatherDirection] == 2) 
    {
        county = 10*WeatherCount;
        if(Weather[i][weatherDirectionCordStart][1]+10*WeatherCount < Weather[i][weatherDirectionCordStop][1]) countx = 10*WeatherCount;
    }
    else if(Weather[i][weatherDirection] == 3) 
    {
        county = -10*WeatherCount;
        if(Weather[i][weatherDirectionCordStart][1]+10*WeatherCount < Weather[i][weatherDirectionCordStop][1]) countx = 10*WeatherCount;
    }
    else if(Weather[i][weatherDirection] == 0) 
    {
        countx = 10*WeatherCount;
        if(Weather[i][weatherDirectionCordStart][0]+10*WeatherCount < Weather[i][weatherDirectionCordStop][0]) county = 10*WeatherCount;
    }
    else if(Weather[i][weatherDirection] == 1) 
    {
        countx = -10*WeatherCount;
        if(Weather[i][weatherDirectionCordStart][0]+10*WeatherCount < Weather[i][weatherDirectionCordStop][0]) county = 10*WeatherCount;
    }
    if(WeatherCount % 2 == 0)
    {
        DestroyDynamicArea(dyn_zone_WeatherBasic[0]);
        DestroyDynamicArea(dyn_zone_WeatherNotBasic[0]);
        dyn_zone_WeatherBasic[0] = CreateDynamicCircle(Weather[i][weatherDirectionCordStart][0]+countx,Weather[i][weatherDirectionCordStart][1]+county, 800, 0,0,-1);
        dyn_zone_WeatherNotBasic[0] = CreateDynamicCircle(Weather[i][weatherDirectionCordStart][0]+countx,Weather[i][weatherDirectionCordStart][1]+county, 1000, 0,0,-1);
    }
    else
    {
        DestroyDynamicArea(dyn_zone_WeatherBasic[1]);
        DestroyDynamicArea(dyn_zone_WeatherNotBasic[1]);
        dyn_zone_WeatherBasic[1] = CreateDynamicCircle(Weather[i][weatherDirectionCordStart][0]+countx,Weather[i][weatherDirectionCordStart][1]+county, 800, 0,0,-1);
        dyn_zone_WeatherNotBasic[1] = CreateDynamicCircle(Weather[i][weatherDirectionCordStart][0]+countx,Weather[i][weatherDirectionCordStart][1]+county, 1000, 0,0,-1);
    }
    printf("Погода движется: %f, %f Шаг: %d", Weather[i][weatherDirectionCordStart][0],Weather[i][weatherDirectionCordStart][1]+county,WeatherCount);
    return 1;
}

stock UpdateWeatherPlayer(playerid)
{
    if(IsPlayerInDynamicArea(playerid, dyn_zone_WeatherBasic[0]) || IsPlayerInDynamicArea(playerid, dyn_zone_WeatherBasic[1])) // Находимся в центре
    {
        SetPlayerWeather(playerid, Weather[WeatherID][weatherID]);
        return true;
    }
    else if(IsPlayerInDynamicArea(playerid, dyn_zone_WeatherNotBasic[0]) || IsPlayerInDynamicArea(playerid, dyn_zone_WeatherNotBasic[1])) // Находимся во внешней погоде
    {
        SetPlayerWeather(playerid, 4);
        return true;
    }
    return false;
}

stock IsAreaWeather(areaid)
{
    if(areaid == dyn_zone_WeatherBasic[0] || areaid == dyn_zone_WeatherBasic[1]
        || areaid == dyn_zone_WeatherNotBasic[0] || areaid == dyn_zone_WeatherNotBasic[1]) return true;
    return false;
}

stock CompletionWeather()
{
    Pogoda = 1; // Погода всегда по дефолту

    for(new i; i < MAX_WEATHER; i++)
    {
        if(i == 0) Weather[i][weatherUnix] = gettime() + random(86400/MAX_WEATHER);
        else Weather[i][weatherUnix] = Weather[i-1][weatherUnix] + random(7200);
        Weather[i][weatherStatus] = 0;
        Weather[i][weatherID] = random(3);
        if(Weather[i][weatherID] == 0) Weather[i][weatherID] = 8;
        else if(Weather[i][weatherID] == 1) Weather[i][weatherID] = 9;
        else if(Weather[i][weatherID] == 2) Weather[i][weatherID] = 16;
        else if(Weather[i][weatherID] == 3) Weather[i][weatherID] = 19;
        Weather[i][weatherDirection] = random(3);
        switch(Weather[i][weatherDirection])
        {
            case 0:
            {
                Weather[i][weatherDirectionCordStart][0] = -4000.0;
                Weather[i][weatherDirectionCordStart][1] = random(6000)-3000;
                Weather[i][weatherDirectionCordStop][0] = 4000.0;
                Weather[i][weatherDirectionCordStop][1] = random(6000);
            }
            case 1:
            {
                Weather[i][weatherDirectionCordStart][0] = 4000.0;
                Weather[i][weatherDirectionCordStart][1] = random(6000)-3000;
                Weather[i][weatherDirectionCordStop][0] = -4000.0;
                Weather[i][weatherDirectionCordStop][1] = random(6000)-3000;
            }
            case 2:
            {
                Weather[i][weatherDirectionCordStart][0] = random(6000)-3000;
                Weather[i][weatherDirectionCordStart][1] = -4000.0;
                Weather[i][weatherDirectionCordStop][0] = random(6000)-3000;
                Weather[i][weatherDirectionCordStop][1] = 4000.0;
            }
            case 3:
            {
                Weather[i][weatherDirectionCordStart][0] = random(6000)-3000;
                Weather[i][weatherDirectionCordStart][1] = 4000.0;
                Weather[i][weatherDirectionCordStop][0] = random(6000)-3000;
                Weather[i][weatherDirectionCordStop][1] = -4000.0;
            }
        }
        printf("Номер погоды: %d. Направление: %d Идет из: %f %f к: %f %f",Weather[i][weatherID],Weather[i][weatherDirection], Weather[i][weatherDirectionCordStart][0],Weather[i][weatherDirectionCordStart][1],Weather[i][weatherDirectionCordStop][0],Weather[i][weatherDirectionCordStop][1]);
    }
    return 1;
}

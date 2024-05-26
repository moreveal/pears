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

stock GetWeatherBasicArea(areaid)
{
	new bool:yes;
	for(new i; i < 2; i++)
	{
		if(areaid == dyn_zone_WeatherBasic[i])
		{
			yes = true;
			break;
		}
	}
	return yes;
}

stock GetWeatherNotBasicArea(areaid)
{
	new bool:yes;
	for(new i; i < 2; i++)
	{
		if(areaid == dyn_zone_WeatherNotBasic[i])
		{
			yes = true;
			break;
		}
	}
	return yes;
}

stock CompletionWeather()
{
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


CMD:forecast(playerid)
{
	new str[100],sctring[1400];
    if(Pogoda <= 17) format(str,sizeof(str),"\n{cccccc}Сегодня: {ff9000}%s", weatherName[Pogoda]), strcat(sctring,str);
    new tyear[13], tmonth[13], tday[13], thour[13], tminute[13], tsecond[13], unix = gettime();
	stamp2datetime(unix+86400, tyear[0], tmonth[0], tday[0], thour[0], tminute[0], tsecond[0], 3);
	stamp2datetime(unix+172800, tyear[1], tmonth[1], tday[1], thour[1], tminute[1], tsecond[1], 3);
	stamp2datetime(unix+259200, tyear[2], tmonth[2], tday[2], thour[2], tminute[2], tsecond[2], 3);
	stamp2datetime(unix+345600, tyear[3], tmonth[3], tday[3], thour[3], tminute[3], tsecond[3], 3);
	stamp2datetime(unix+432000, tyear[4], tmonth[4], tday[4], thour[4], tminute[4], tsecond[4], 3);
	stamp2datetime(unix+518400, tyear[5], tmonth[5], tday[5], thour[5], tminute[5], tsecond[5], 3);
	stamp2datetime(unix+604800, tyear[6], tmonth[6], tday[6], thour[6], tminute[6], tsecond[6], 3);
	stamp2datetime(unix+691200, tyear[7], tmonth[7], tday[7], thour[7], tminute[7], tsecond[7], 3);
	stamp2datetime(unix+777600, tyear[8], tmonth[8], tday[8], thour[8], tminute[8], tsecond[8], 3);
	stamp2datetime(unix+864000, tyear[9], tmonth[9], tday[9], thour[9], tminute[9], tsecond[9], 3);
	stamp2datetime(unix+950400, tyear[10], tmonth[10], tday[10], thour[10], tminute[10], tsecond[10], 3);
	stamp2datetime(unix+1036800, tyear[11], tmonth[11], tday[11], thour[11], tminute[11], tsecond[11], 3);
	stamp2datetime(unix+1123200, tyear[12], tmonth[12], tday[12], thour[12], tminute[12], tsecond[12], 3);
    format(str,sizeof(str),"\n{cccccc}Завтра %02d.%02d.%d: {ff9000}%s", tday[0], tmonth[0], tyear[0], weatherName[dayweat[1]]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}%02d.%02d.%d: {ff9000}%s", tday[1], tmonth[1], tyear[1], weatherName[dayweat[2]]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}%02d.%02d.%d: {ff9000}%s", tday[2], tmonth[2], tyear[2], weatherName[dayweat[3]]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}%02d.%02d.%d: {ff9000}%s", tday[3], tmonth[3], tyear[3], weatherName[dayweat[4]]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}%02d.%02d.%d: {ff9000}%s", tday[4], tmonth[4], tyear[4], weatherName[dayweat[5]]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}%02d.%02d.%d: {ff9000}%s", tday[5], tmonth[5], tyear[5], weatherName[dayweat[6]]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}%02d.%02d.%d: {ff9000}%s", tday[6], tmonth[6], tyear[6], weatherName[dayweat[7]]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}%02d.%02d.%d: {ff9000}%s", tday[7], tmonth[7], tyear[7], weatherName[dayweat[8]]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}%02d.%02d.%d: {ff9000}%s", tday[8], tmonth[8], tyear[8], weatherName[dayweat[9]]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}%02d.%02d.%d: {ff9000}%s", tday[9], tmonth[9], tyear[9], weatherName[dayweat[10]]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}%02d.%02d.%d: {ff9000}%s", tday[10], tmonth[10], tyear[10], weatherName[dayweat[11]]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}%02d.%02d.%d: {ff9000}%s", tday[11], tmonth[11], tyear[11], weatherName[dayweat[12]]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}%02d.%02d.%d: {ff9000}%s", tday[12], tmonth[12], tyear[12], weatherName[dayweat[13]]), strcat(sctring,str);
  	ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Прогноз Погоды",sctring,"*","");
	return 1;
}
#define MAX_WEATHER 6 // Максимальное количество заявок
// CreateDynamicCircle
new WeatherID = -1; // ID погоды
new WeatherCount; // Кол-во шагов
new dyn_zone_WeatherBasic[2];
new dyn_zone_WeatherNotBasic[2];

new weatherName[][] =
{
    "Солнечно","Солнечно","Солнечно","Солнечно","Облачно","Солнечно"," ","Пасмурно","Дождь","Туман",
    "Солнечно","Солнечно","Солнечно"," "," "," ","Гроза","Солнечно","Солнечно","Песчанная Буря"
};

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

CMD:startweather(playerid, const params[])
{
    new number;
    if(PlayerInfo[playerid][pSoska] < 9) return 0;
    if(sscanf(params, "d",number)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Запустить погоду {ffcc00}[ /startweather ID погоды ]");
    number--;
    Weather[number][weatherUnix] = gettime();
    if(number > MAX_WEATHER || number < 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Запустить погоду {ffcc00}[ /startweather ID погоды ]");
    WeatherStart(number);
    return 1;
}

CMD:showweather(playerid)
{
    if(PlayerInfo[playerid][pMember] != 9 && PlayerInfo[playerid][pLeader] != 9) return 0;
    WeatherShowMenu(playerid);
    return 1;
}

CMD:gotoweather(playerid)
{
    if(PlayerInfo[playerid][pSoska] == 0) return 0;
    if(WeatherID == -1) return ErrorMessage(playerid, "{ff6347} В данный момент нет зоны погоды");
    PPSetPlayerPos(playerid,Weather[WeatherID][weatherDirectionCordStart][0]+10*WeatherCount,Weather[WeatherID][weatherDirectionCordStart][1]+10*WeatherCount, 15.0);
    return 1;
}

stock WeatherShowMenu(playerid)
{
    new line[100],lines[200*MAX_WEATHER];
    format(line,sizeof(line),"№ Погода\tДо старта\tСтатус\tНаправление"), strcat(lines,line);
    for(new i; i < MAX_WEATHER; i++)
    {
        new text[40], textstatus[7];
        if(Weather[i][weatherDirection] == 0) text = "С Юга на Север";
        else if(Weather[i][weatherDirection] == 1) text = "С Севера на ЮГ";
        else if(Weather[i][weatherDirection] == 2) text = "С Запада на Восток";
        else if(Weather[i][weatherDirection] == 3) text = "С Востока на Запад";
        if(Weather[i][weatherStatus] == 0) textstatus = "Будет";
        else if(Weather[i][weatherStatus] == 1) textstatus = "Идет";
        else if(Weather[i][weatherStatus] == 2) textstatus = "Прошла";
        new tyear, tmonth, tday, thour, tminute, tsecond;
        stamp2datetime(Weather[i][weatherUnix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
        format(line,sizeof(line),"\n%d. %s\t%s [ %02d:%02d ]\t%s\t%s", i+1,weatherName[Weather[i][weatherID]], fine_time(Weather[i][weatherUnix]-gettime()),thour, tminute,textstatus,text), strcat(lines,line);
    }
    ShowDialog(playerid,1700,DIALOG_STYLE_TABLIST_HEADERS,"{ff9000}Прогноз погоды",lines,"Выбрать","Выход");
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
    if(Weather[i][weatherDirectionCordStart][0]+countx > 8000 || Weather[i][weatherDirectionCordStart][1]+county > 8000 || Weather[i][weatherDirectionCordStart][1]+county < -4000 || Weather[i][weatherDirectionCordStart][0]+countx < -4000)
    {
        DestroyDynamicArea(dyn_zone_WeatherBasic[0]);
        DestroyDynamicArea(dyn_zone_WeatherNotBasic[0]);
        DestroyDynamicArea(dyn_zone_WeatherBasic[1]);
        DestroyDynamicArea(dyn_zone_WeatherNotBasic[1]);
        Weather[i][weatherStatus] = 2;
    }
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
        else Weather[i][weatherUnix] = Weather[i-1][weatherUnix] +7200+ random(14400);
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

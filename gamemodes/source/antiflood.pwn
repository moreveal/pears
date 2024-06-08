
static const infoPublics[][] =
{
    {120, 8},  //0 OnDialogResponse
    {800, 2},  //1 OnEnterExitModShop
    {250, 8},  //2 OnPlayerClickMap
    {400, 5},  //3 OnPlayerClickPlayer
    {50, 11},  //4 OnPlayerClickTextDraw
    {400, 8},  //5 OnPlayerCommandText >> OnPlayerCommandReceived
    {50, 8},  //6 OnPlayerEnterVehicle
    {50, 11},  //7 OnPlayerExitVehicle
    {50, 11},  //8 OnPlayerPickUpPickup
    {150, 8},  //9 OnPlayerRequestClass
    {120, 8},  //10 OnPlayerSelectedMenuRow
    {600, 8},  //11 OnPlayerStateChange
    {450, 2},  //12 OnVehicleMod
    {450, 2},  //13 OnVehiclePaintjob
    {450, 2},  //14 OnVehicleRespray
    {300, 1},  //15 OnVehicleDeath
    {450, 8},  //16 OnPlayerText
    {150, 8},  //17 OnPlayerEnterCheckpoint
    {150, 8},  //18 OnPlayerLeaveCheckpoint
    {150, 5},  //19 OnPlayerRequestSpawn
    {120, 8},  //20 OnPlayerExitedMenu
    {150, 8},  //21 OnPlayerEnterRaceCheckpoint
    {150, 8},  //22 OnPlayerLeaveRaceCheckpoint
    {50, 11},  //23 OnPlayerClickPlayerTextDraw
    {60, 9},  //24 OnVehicleDamageStatusUpdate
    {150, 8},  //25 OnVehicleSirenStateChange
    {150, 5},  //26 OnPlayerSelectObject
    {50, 11}  //27 Cross-public
};

enum afInfo
{
	afCall[sizeof(infoPublics)], // Tick вызова паблика
    afQuan[sizeof(infoPublics)] // Количество слишком частых вызовов паблика
}
new AntiFloodInfo[MAX_REALPLAYERS][afInfo];

/*
Кладём вот так в паблики в самое начало
if(CallPublic(playerid, publicid)) return false;
*/

stock CallPublic(playerid, publicid)
{
    if(OnlineInfo[playerid][oKickTimer] > 0) return 1; // Если игрока уже кикаем, пшёл нафиг

    if(CallOnePublic(playerid, publicid)) return 1;
    if(CallOnePublic(playerid, 27)) return 1;
    return 0;
}

stock CallOnePublic(playerid, publicid)
{
    new current_tick = GetTickCount();
    new interval = GetTickDiff(current_tick, AntiFloodInfo[playerid][afCall][publicid]);

    if(interval < infoPublics[publicid][0])
    {
        AntiFloodInfo[playerid][afQuan][publicid] ++;
        if(AntiFloodInfo[playerid][afQuan][publicid] >= infoPublics[publicid][1])
        {
            printf("[SProtect Kick]: AntiFlood CallPublic publicid %d %s", publicid, PlayerInfo[playerid][pName]);
            SendClientMessage(playerid, COLOR_LIGHTRED, "* {0066ff}Protect Project: {FF6347}Вы были кикнуты сервером [AntiFlood publicid %d]", publicid);
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ff0000}Protect Project","{ff0000}Вы были кикнуты сервером [AntiFlood]","*","");
            Kickx(playerid);
            return 1;
        }
    }
    else AntiFloodInfo[playerid][afQuan][publicid] = 0, AntiFloodInfo[playerid][afCall][publicid] = current_tick;
    return 0;
}

stock ClearAntifloodVariable(playerid)
{
    for(new i = 0; i < sizeof(infoPublics); i++) AntiFloodInfo[playerid][afCall][i] = 0, AntiFloodInfo[playerid][afQuan][i] = 0;
    return 1;
}

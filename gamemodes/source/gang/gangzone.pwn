
#define GZONES 88 // Количество гангзон на сервере

// Ганг зоны
enum GzoneInfo
{
	gFrakVlad,
	gID,
	gBitva,
	gCherez,
}
new GZInfo[GZONES][GzoneInfo];

// Координаты ганг зон
new ZoneCapt; // ID Zone Quest в Los Santos
enum GANGZONEENUM { Float:gzMinX, Float:gzMinY, Float:gzMaxX, Float:gzMaxY, defaultOrg }
new GangZone[][GANGZONEENUM] =
{
    { 2434.23828125, -1935.9375, 2544.23828125, -1825.9375, 14 },
    { 2434.23828125, -1825.9375, 2544.23828125, -1715.9375, 13 },
    { 2544.23828125, -1825.9375, 2764.23828125, -1715.9375, 14 },
    { 2544.23828125, -1715.9375, 2654.23828125, -1605.9375, 13 },
    { 2544.23828125, -1605.9375, 2654.23828125, -1495.9375, 13 },
    { 2434.23828125, -1605.9375, 2544.23828125, -1495.9375, 13 },
    { 2324.23828125, -1605.9375, 2434.23828125, -1495.9375, 13 },
    { 2214.23828125, -1605.9375, 2324.23828125, -1495.9375, 15 },
    { 2104.23828125, -1605.9375, 2214.23828125, -1495.9375, 15 },
    { 2104.2377319335938, -1495.9374389648438, 2214.2377319335938, -1385.9374389648438, 15 },
    { 2104.2377319335938, -1385.9374694824219, 2214.2377319335938, -1275.9374694824219, 15 },
    { 2324.23828125, -1495.9375, 2434.23828125, -1385.9375, 15 },
    { 2214.2377319335938, -1385.9374694824219, 2324.2377319335938, -1275.9374694824219, 15 },
    { 2214.2377319335938, -1275.9374694824219, 2324.2377319335938, -1165.9374694824219, 15 },
    { 2324.23828125, -1715.9375, 2434.23828125, -1605.9375, 13 },
    { 2214.236328125, -1715.9378356933594, 2324.236328125, -1605.9378356933594, 14 },
    { 2104.23828125, -1715.9375, 2214.23828125, -1605.9375, 16 },
    { 1994.23828125, -1715.9375, 2104.23828125, -1605.9375, 16 },
    { 1884.23828125, -1715.9375, 1994.23828125, -1605.9375, 16 },
    { 1884.23828125, -1605.9375, 1994.23828125, -1495.9375, 16 },
    { 1994.23828125, -1605.9375, 2104.23828125, -1495.9375, 16 },
    { 1994.23828125, -1495.9375, 2104.23828125, -1385.9375, 16 },
    { 1884.23828125, -1495.9375, 1994.23828125, -1385.9375, 16 },
    { 1884.23828125, -1385.9375, 1994.23828125, -1275.9375, 16 },
    { 1994.2377319335938, -1385.9374694824219, 2104.2377319335938, -1275.9374694824219, 16 },
    { 1884.23828125, -1275.9375, 1994.23828125, -1165.9375, 15 },
    { 1994.2377319335938, -1275.9374694824219, 2104.2377319335938, -1165.9374694824219, 15 },
    { 2104.2377319335938, -1275.9374694824219, 2214.2377319335938, -1165.9374694824219, 15 },
    { 1884.23828125, -1165.9375, 1994.23828125, -1055.9375, 15 },
    { 1994.23828125, -1165.9375, 2104.23828125, -1055.9375, 15 },
    { 2104.2377319335938, -1165.9374542236328, 2214.2377319335938, -1055.9374542236328, 15 },
    { 2214.2377319335938, -1165.9374542236328, 2324.2377319335938, -1055.9374542236328, 15 },
    { 2544.23828125, -1935.9375, 2654.23828125, -1825.9375, 14 },
    { 2544.23828125, -2045.9375, 2654.23828125, -1935.9375, 14 },
    { 2544.23828125, -2155.9375, 2654.23828125, -2045.9375, 14 },
    { 2434.23828125, -2155.9375, 2544.23828125, -2045.9375, 14 },
    { 2324.23828125, -2155.9375, 2434.23828125, -2045.9375, 14 },
    { 2214.23828125, -2155.9375, 2324.23828125, -2045.9375, 14 },
    { 2324.23828125, -2045.9375, 2434.23828125, -1935.9375, 14 },
    { 2214.23828125, -2045.9375, 2324.23828125, -1935.9375, 14 },
    { 2324.23828125, -1935.9375, 2434.23828125, -1825.9375, 14 },
    { 2214.23828125, -1935.9375, 2324.23828125, -1825.9375, 14 },
    { 2324.23828125, -1825.9375, 2434.23828125, -1715.9375, 14 },
    { 2214.23828125, -1825.9375, 2324.23828125, -1715.9375, 14 },
    { 2104.23828125, -1825.9375, 2214.23828125, -1715.9375, 16 },
    { 1994.23828125, -1825.9375, 2104.23828125, -1715.9375, 16 },
    { 1884.23828125, -1825.9375, 1994.23828125, -1715.9375, 16 },
    { 1884.23828125, -1935.9375, 1994.23828125, -1825.9375, 16 },
    { 1994.23828125, -1935.9375, 2104.23828125, -1825.9375, 16 },
    { 2104.23828125, -1935.9375, 2214.23828125, -1825.9375, 16 },
    { 1884.23828125, -2045.9375, 1994.23828125, -1935.9375, 16 },
    { 1774.23828125, -2045.9375, 1884.23828125, -1935.9375, 16 },
    { 1994.23828125, -2045.9375, 2104.23828125, -1935.9375, 16 },
    { 2104.23828125, -2045.9375, 2214.23828125, -1935.9375, 16 },
    { 2104.23828125, -2155.9375, 2214.23828125, -2045.9375, 16 },
    { 1994.23828125, -2155.9375, 2104.23828125, -2045.9375, 16 },
    { 1884.23828125, -2155.9375, 1994.23828125, -2045.9375, 16 },
    { 2654.23828125, -2155.9375, 2764.23828125, -2045.9375, 14 },
    { 2654.23828125, -2045.9375, 2764.23828125, -1935.9375, 14 },
    { 2654.23828125, -1935.9375, 2764.23828125, -1825.9375, 14 },
    { 2654.23828125, -1715.9375, 2764.23828125, -1605.9375, 14 },
    { 2654.23828125, -1605.9375, 2764.23828125, -1495.9375, 14 },
    { 2764.23828125, -1605.9375, 2874.23828125, -1495.9375, 14 },
    { 2434.23828125, -1495.9375, 2544.23828125, -1385.9375, 13 },
    { 2544.23828125, -1495.9375, 2654.23828125, -1385.9375, 13 },
    { 2654.23828125, -1495.9375, 2764.23828125, -1385.9375, 13 },
    { 2764.23828125, -1495.9375, 2874.23828125, -1385.9375, 13 },
    { 2324.2374267578125, -1385.9376525878906, 2434.2374267578125, -1275.9376525878906, 15 },
    { 2324.23779296875, -1165.9376525878906, 2434.23779296875, -1055.9376525878906, 15 },
    { 2434.23779296875, -1165.9376525878906, 2544.23779296875, -1055.9376525878906, 13 },
    { 2544.23779296875, -1165.9376525878906, 2654.23779296875, -1055.9376525878906, 13 },
    { 2654.23779296875, -1165.9376525878906, 2764.23779296875, -1055.9376525878906, 13 },
    { 2324.23779296875, -1275.9376525878906, 2434.23779296875, -1165.9376525878906, 15 },
    { 2434.23779296875, -1275.9376525878906, 2544.23779296875, -1165.9376525878906, 13 },
    { 2544.23779296875, -1275.9376525878906, 2654.23779296875, -1165.9376525878906, 13 },
    { 2654.23779296875, -1275.9376525878906, 2764.23779296875, -1165.9376525878906, 13 },
    { 2434.23779296875, -1385.9376525878906, 2544.23779296875, -1275.9376525878906, 13 },
    { 2544.23779296875, -1385.9376525878906, 2654.23779296875, -1275.9376525878906, 13 },
    { 2654.23779296875, -1385.9376525878906, 2764.23779296875, -1275.9376525878906, 13 },
    { 2764.23779296875, -1385.9376525878906, 2874.23779296875, -1275.9376525878906, 13 },
    { 1994.236328125, -1055.9376831054688, 2104.236328125, -945.9376831054688, 15 },
    { 2104.236328125, -1055.9376831054688, 2214.236328125, -945.9376831054688, 15 },
    { 2214.236328125, -1055.9203186035156, 2324.236328125, -945.9203186035156, 15 },
    { 2324.236328125, -1055.9203186035156, 2434.236328125, -945.9203186035156, 15 },
    { 2434.236328125, -1055.937744140625, 2544.236328125, -945.937744140625, 15 },
    { 2544.236328125, -1055.937744140625, 2654.236328125, -945.937744140625, 13 },
    { 2764.236328125, -1715.9378356933594, 2874.236328125, -1605.9378356933594, 14 },
    { 2764.236328125, -1275.9376678466797, 2874.236328125, -1165.9376678466797, 13 }
};

CMD:zahvat(playerid, const params[])
{
	new frakid = fraction(playerid);
	if(!IsAFunctionOrganization(16, frakid, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не бандит");
	if(!GetAccessRankOrg(playerid, frakid, 16, NO_FBI)) return 1;

	if(IsPlayerInAnyVehicle(playerid)) return ErrorMessage(playerid, "{FF6347}Вы в транспорте");
	if(Zach[frakid] == 1) return ErrorMessage(playerid, "{FF6347}Сейчас нельзя начать захват территории, вашу банду зачищают");
	if(OrganInfo[frakid][gstat2] == 1) return ErrorMessage(playerid, "{FF6347}Ваша банда временно закрыта администрацией [ Вероятно, отсутствует лидер ]");
	new tmphour, tmpminute, tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	new unixtime = gettime();
	if(tmphour >= 0 && tmphour < 10 && PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Нельзя захватить территорию ночью [ 00:00 - 10:00 ]");
	if(FrakCD[frakid] > unixtime) return format(store,sizeof(store),"{FF6347}Вам и вашим людям необходимо отдохнуть {cccccc}[ Осталось %d сек. ]",FrakCD[frakid]-unixtime), ErrorMessage(playerid, store);
	new Float:Pos[3];
	GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
	if(Pos[2] >= 90.000) return  ErrorMessage(playerid, "{FF6347}Вы слишком высоко над городом");
	if(Kapt[frakid] > 0) return ErrorMessage(playerid, "{FF6347}Ваша банда уже сражается за территорию");
	if(CaptInfo[cCaptStat] == true) return format(store,sizeof(store),"{FF6347}В гетто происходит конфликт {cccccc}[ Капт закончится через: %d ]", CaptInfo[cTime]), ErrorMessage(playerid, store);
	if(CaptInfo[cCaptReset] >= 1) return format(store,sizeof(store),"{FF6347}Сейчас... ещё немного {cccccc}[ Пауза после предыдущего капта: %d ]", CaptInfo[cCaptReset]), ErrorMessage(playerid, store);
	
	new findCapt;
	for(new i = 0;i<GZONES;i++)
	{
		if(IsPlayerInSquare(playerid,GangZone[i][gzMinX],GangZone[i][gzMinY],GangZone[i][gzMaxX],GangZone[i][gzMaxY]))
		{
			new etafraka = GZInfo[i][gFrakVlad];
			if(etafraka == frakid) return ErrorMessage(playerid, "{FF6347}Вы не можете начать захват своей территории");
			if(GZInfo[i][gCherez] > unixtime) return format(store,sizeof(store),"{FF6347}На этой территории совсем недавно была битва {cccccc}[ Осталось %d сек. ]",GZInfo[i][gCherez]-unixtime), ErrorMessage(playerid, store);
			if(OrganInfo[etafraka][gstat2] == 1) return ErrorMessage(playerid, "{FF6347}Банда, которой принадлежит эта территория, временно закрыта [ Вероятно, у них нет лидера ]");
 			if(!IsPlayerInBandOnline(etafraka) && PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете начать захват территории, которую некому защищать [ Участники Offline ]");
 			if(etafraka >= 1)
  			{
				if(Zach[GZInfo[i][gFrakVlad]] == 1) return ErrorMessage(playerid, "{FF6347}Нельзя начать захват территории банды, которую зачищают законники");

				CreateCaptZone(i); // Создаем куб для отключение болезний
				CaptInfo[cCaptStat] = true; // Включаем капт в штате
				CaptInfo[cTime] = 600;
				CaptInfo[cZoneID] = i;
				CaptInfo[cUnix] = unixtime;
				Kapt[frakid] = GZInfo[i][gFrakVlad]; // Ставим противников
				Kapt[GZInfo[i][gFrakVlad]] = frakid; // Ставим противников
				format(store,sizeof(store),"{ff0000}[ GANG ZONE ]: Внимание! {ffffff}Вашу территорию атакует: %s",frakName[frakid]);
  				SendRadioMessage(GZInfo[i][gFrakVlad],COLOR_LIGHTRED,store);
  				SendRadioMessage(GZInfo[i][gFrakVlad],COLOR_LIGHTRED,"{ff0000}[ GANG ZONE ]: {ffffff}У вас есть 10 минут на то, чтобы отстоять свою зону!");
    			format(store,sizeof(store),"{0088ff}[ GANG ZONE ]: {ffffff}%s начал захват территории %s",playername(playerid),frakName[GZInfo[i][gFrakVlad]]);
     			SendRadioMessage(frakid,COLOR_LIGHTRED,store);
      			SetPlayerChatBubble(playerid,"начинает захват территории",COLOR_PURPLE,35.0,10000);
      			CaptInfo[cAttack] = frakid; // ID Банды, которая атакует
      			CaptInfo[cCaptPresenceCD] = 30;
      			CaptInfo[cDefend] = GZInfo[i][gFrakVlad]; // ID Банды, которая защищается
      			CaptInfo[cQuanityA] = 0;
      			CaptInfo[cQuanityD] = 0;
      			CaptInfo[cKillA] = 0;
      			CaptInfo[cKillD] = 0;
      			CaptInfo[cPresenceA] = 0;
				CaptInfo[cPresenceD] = 0;
				CaptInfo[cLogQuanA] = 0;
				CaptInfo[cLogQuanD] = 0;
				CaptInfo[cLogHealthA] = 0;
				CaptInfo[cLogHealthD] = 0;
				CaptInfo[cLogMedA] = 0;
				CaptInfo[cLogMedD] = 0;
				CaptInfo[cLogDrugA][0] = 0, CaptInfo[cLogDrugA][1] = 0, CaptInfo[cLogDrugA][2] = 0, CaptInfo[cLogDrugA][3] = 0;
				CaptInfo[cLogDrugD][0] = 0, CaptInfo[cLogDrugD][1] = 0, CaptInfo[cLogDrugD][2] = 0, CaptInfo[cLogDrugD][3] = 0;
				CaptInfo[cCbug] = 0;
				GZInfo[i][gBitva] = frakid;
				ServerInfo[42] ++;
				SaveServer(42);
				format(store, sizeof(store), " [ ADM ]: %s[%d] начал капт № %d {FF8282}[ Проследите за соблюдением правил ]", PlayerInfo[playerid][pName], playerid, ServerInfo[42]);
				ABroadCast(COLOR_ADM,store,1);
				OrgLog(frakid, "zahvat", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", ServerInfo[42], "");
       			// Включаем режимы исходя из настроек
				if(unixtime > OrganInfo[frakid][gSanCbug])
				{
       				if(OrganInfo[frakid][gRejim2] == true)
	   				{
	   					if(OrganInfo[frakid][gSCbug] == false) GoC[frakid] = 1, GoC[GZInfo[i][gFrakVlad]] = 1, CaptInfo[cCbug] = 1;//, OrganInfo[frakid][gSCbug] = true;
	   					else OrganInfo[frakid][gSCbug] = false;
   					}
   					else OrganInfo[frakid][gSCbug] = false;
				}
				else OrganInfo[frakid][gSCbug] = false;

				foreach(Player,x)
				{
					if(MPGO[x] == 0)
					{
						if(PlayerInfo[x][pMember] == GZInfo[i][gFrakVlad] || PlayerInfo[x][pLeader] == GZInfo[i][gFrakVlad]) GiveUpdate(x, CaptInfo[cAttack]), PlayerPlaySound(x,3201,0,0,0), SetPlayerToTeamColor(x);
						if(PlayerInfo[x][pMember] == CaptInfo[cAttack] || PlayerInfo[x][pLeader] == CaptInfo[cAttack]) GiveUpdate(x, GZInfo[i][gFrakVlad]), PlayerPlaySound(x,3201,0,0,0), SetPlayerToTeamColor(x);
					}
				}
				GangZoneFlashForAll(GZInfo[i][gID],0xff0000AA); // Устанавливаем мигающий цвет зоны
    		}

			findCapt = 1;
			break;
		}
	}
	if(findCapt == 0) ErrorMessage(playerid, "{FF6347}Вам нужно встать на территорию, которую хотите захватить");
	return 1;
}

CMD:sellgz(playerid, const params[])
{
    if(PlayerInfo[playerid][pLeader] == 14
    || PlayerInfo[playerid][pLeader] == 13 || PlayerInfo[playerid][pLeader] == 15
    || PlayerInfo[playerid][pLeader] == 16)
    {
        for(new i = 0;i<GZONES;i++)
        {
            if(IsPlayerInSquare(playerid,GangZone[i][gzMinX],GangZone[i][gzMinY],GangZone[i][gzMaxX],GangZone[i][gzMaxY]))
            {
                if(GZInfo[i][gFrakVlad] != PlayerInfo[playerid][pLeader]) return ErrorMessage(playerid, "{FF6347}Эта территория не принадлежит вашей банде");
                if(GZInfo[i][gBitva] != 0) return ErrorMessage(playerid, "{FF6347}За эту территорию идёт битва");
                if(sscanf(params, "ii",params[0],params[1])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Продать территорию [ /sellgz ID Цена ]");

                if(!ProxDetectorS(3.0, playerid, params[0])) return ErrorMessage(playerid, "{FF6347}Покупатель далеко от вас");
                if(PlayerInfo[params[0]][pLeader]==0) return ErrorMessage(playerid, "{FF6347}Вы можете продать территорию только лидеру");
                if(PlayerInfo[playerid][pLeader]==PlayerInfo[params[0]][pLeader]) return ErrorMessage(playerid, "{FF6347}Вы не можете продать территорию лидеру своей банды");
                if(PlayerInfo[params[0]][pLeader]!=13&&PlayerInfo[params[0]][pLeader]!=14
                &&PlayerInfo[params[0]][pLeader]!=15&&PlayerInfo[params[0]][pLeader]!=16) return ErrorMessage(playerid, "{FF6347}Вы не можете продать территорию этому лидеру");
                if(params[1] > 500000 || params[1] < 10000) return ErrorMessage(playerid, "{FF6347}Не меньше 10.000$ и больше 500.000$");
                if(OnlineInfo[params[0]][oLogged] == 0) return ErrorMessage(playerid, "{FF6347}Этот игрок не залогинился");
                if(playerid == params[0]) return ErrorMessage(playerid, "{FF6347}Вы не можете передать территорию себе");
                if(oGetPlayerMoney(params[0]) < params[1]) return ErrorMessage(playerid, "{FF6347}Покупателю не хватает денег");

                format(store, sizeof(store), "{cccccc}[ Мысли ]: Я продаю эту территорию лидеру {99ff66}%s{cccccc}за {99ff66}%d$", playername(params[0]),params[1]);
                SendClientMessage(playerid, COLOR_GREY, store);

                DP[0][params[0]] = playerid;
                DP[1][params[0]] = i;
                DP[2][params[0]] = params[1];
                format(store, sizeof(store), "{0088ff}%s{FFFFFF} предлагает вам купить эту территорию за {99ff66}%d$\n{FFFFFF}Купить ?",playername(playerid),params[1]);
                ShowDialog(params[0],425,DIALOG_STYLE_MSGBOX,"{FFFFFF}* {0088ff}[ GANG ZONE ] {FFFFFF}*",store,"Да","Нет");

                break;
            }
        }
    }
    else ErrorMessage(playerid, "{FF6347}Вы не можете продавать территории [ Только для лидера ]");
    return 1;
}

CMD:capture(playerid)
{
	new frakid = fraction(playerid);
	if(!IsAFunctionOrganization(16, frakid, playerid)) return ErrorMessage(playerid, "{FF6347}Вы не бандит");
	if(!GetAccessRankOrg(playerid, frakid, 16, NO_FBI)) return 1;
	if(Kapt[frakid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете изменять условия во время битвы за территорию");

	PlayerPlaySound(playerid,40405,0,0,0);
	new str[100],sctring[400];
	new unixtime = gettime();
	if(OrganInfo[frakid][gSanCbug] > unixtime)
	{
		new tyear, tmonth, tday, thour, tminute, tsecond;
		stamp2datetime(OrganInfo[frakid][gSanCbug], tyear, tmonth, tday, thour, tminute, tsecond, 3);
		format(str,sizeof(str),"{cccccc}+C {FF6347}[ Запрещено до: %02d.%02d.%d %02d:%02d ]\n", tday, tmonth, tyear, thour, tminute), strcat(sctring,str);
	}
	else
	{
		if(OrganInfo[frakid][gSCbug] == false)
		{
			if(OrganInfo[frakid][gRejim2] == false) format(str,sizeof(str),"{cccccc}+C {FF6347}[ Off ]\n"), strcat(sctring,str);
			else if(OrganInfo[frakid][gRejim2] == true) format(str,sizeof(str),"{cccccc}+C {99ff66}[ On ]\n"), strcat(sctring,str);
		}
		else if(OrganInfo[frakid][gSCbug] == true)
		{
			if(OrganInfo[frakid][gRejim2] == false) format(str,sizeof(str),"{cccccc}+C {FF6347}[ Off ] {ffcc00}[Использовался]\n"), strcat(sctring,str);
			else if(OrganInfo[frakid][gRejim2] == true) format(str,sizeof(str),"{cccccc}+C {99ff66}[ On ] {ffcc00}[Использовался]\n"), strcat(sctring,str);
		}
	}
	ShowDialog(playerid,841,DIALOG_STYLE_LIST,"{ff9000}Capture",sctring,"Выбор","Отмена");
	return 1;
}

CMD:stopgz(playerid)
{
	if(PlayerInfo[playerid][pSoska] < 10) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(CaptInfo[cCaptStat] == false) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: В гетто не происходит битва за территорию");
	new g = CaptInfo[cZoneID], string[144];
	CaptInfo[cCaptStat] = false;
	foreach(Player,i)
	{
		if(gVidga[i] == true) DelUpdate(i);
	}
	Kapt[CaptInfo[cAttack]] = 0, Kapt[CaptInfo[cDefend]] = 0;
 	FrakCD[CaptInfo[cAttack]] = 0, FrakCD[CaptInfo[cDefend]] = 0;
	ChutC[CaptInfo[cAttack]] = 0, ChutC[CaptInfo[cDefend]] = 0;
	GoC[CaptInfo[cAttack]] = 0, GoC[CaptInfo[cDefend]] = 0;

    if(GZInfo[g][gFrakVlad] >= 1)
    {
   		format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {cccccc}Администратор %s отменил ваш бой за территорию",PlayerInfo[playerid][pName]);
   		SendRadioMessage(GZInfo[g][gFrakVlad],COLOR_GREY,string);
    }
    if(CaptInfo[cAttack] >= 1)
    {
   		format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {cccccc}Администратор %s отменил ваш бой за территорию",PlayerInfo[playerid][pName]);
   		SendRadioMessage(CaptInfo[cAttack],COLOR_GREY,string);
    }
	GZInfo[g][gBitva] = 0;
    GZInfo[g][gCherez] = 0;
	GangZoneShowForAll(g,GetGZColorF(GZInfo[g][gFrakVlad]));
	SaveGangZone(g);
	format(string, sizeof(string), " [ ADM ]: Админ %s отменил битву за территорию № %d", PlayerInfo[playerid][pName],g);
	ABroadCast(COLOR_ADM,string,1);
	AdminLog("stopgz", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", g, "Отменил капт");
	return 1;
}
CMD:reloadgz(playerid)
{
	if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_LEADER)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(CaptInfo[cCaptStat] == true) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Нельзя во время капта");
	if(CaptInfo[cCaptReset] >= 1) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Нельзя сразу после капта [ 10 секунд для сохранения ]");
	ShowDialog(playerid,1008,DIALOG_STYLE_MSGBOX,"{ff9000}Сброс Территорий","{cccccc}Вы уверены, что хотите сбросить {FF6347}все территории гетто?","Да","Нет");
	return 1;
}
CMD:setgz(playerid, const params[])
{
	if(!admin_right(PlayerInfo[playerid][pSoska], ADM_SPHERE_LEADER)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");
	if(sscanf(params, "i",params[0])) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: Установить территорию [ /setgz ID Фракции ]");
	if(params[0] > 16 || params[0] < 13) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не меньше 13 и не больше 16");
	for(new i = 0; i < GZONES; i++)
	{
		if(IsPlayerInSquare(playerid,GangZone[i][gzMinX],GangZone[i][gzMinY],GangZone[i][gzMaxX],GangZone[i][gzMaxY]))
		{
			if(GZInfo[i][gBitva] >= 1) return SendClientMessage(playerid,COLOR_GREY, "[ Мысли ]: За эту территорию ведётся битва");
			GangZoneShowForAll(i,GetGZColorF(params[0]));
			GZInfo[i][gFrakVlad] = params[0];
			SaveGangZone(i);
			AdminLog("setgz", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", i, "");
		}
	}
 	UpdateHonor(0);
	return 1;
}

stock dialogCase_GangZone(playerid, dialogid, response, listitem)
{
	if(dialogid == 425) // Покупка ганг зоны
   	{
   	    if(response)// да
        {
	        new gz = DP[1][playerid]; // Номер ганг зоны
	        if(IsPlayerInSquare(playerid,GangZone[gz][gzMinX],GangZone[gz][gzMinY],GangZone[gz][gzMaxX],GangZone[gz][gzMaxY]))
	        {
				if(GZInfo[gz][gBitva] != 0) return ErrorMessage(playerid, "{FF6347}Стоп! На территории началась битва");
				new cena = DP[2][playerid]; // Цена ганг зоны
				new giveplayerid = DP[0][playerid]; // Ид продавца ганг зоны
				if(!IsOnline(giveplayerid)) return ErrorMessage(playerid, "{FF6347}Игрока нет в сети");
				if(oGetPlayerMoney(playerid) < cena) return ErrorMessage(playerid, "{FF6347}Вам не хватает денег");

				oGivePlayerMoney(playerid, -cena); // Снимаем бабло с покупателя
				oGivePlayerMoney(giveplayerid, cena); // Даём бабло продавцу

				format(store,sizeof(store),"{ff0000}[ GANG ZONE ]: {ffffff}Лидер %s купил территорию у %s {ffffff}за {00cc00}%d$",PlayerInfo[playerid][pName],frakName[PlayerInfo[giveplayerid][pLeader]],cena);
				SendRadioMessage(PlayerInfo[playerid][pLeader],COLOR_LIGHTRED,store);
				format(store,sizeof(store),"{0088ff}[ GANG ZONE ]: {ffffff}Лидер %s продал территорию банде %s {ffffff}за {00cc00}%d$",PlayerInfo[giveplayerid][pName],frakName[PlayerInfo[playerid][pLeader]],cena);
				SendRadioMessage(PlayerInfo[giveplayerid][pLeader],COLOR_LIGHTRED,store);

				GangZoneShowForAll(gz,GetGZColorF(PlayerInfo[playerid][pLeader])); // Врубаем цвет новых владельцев
				GZInfo[gz][gFrakVlad] = PlayerInfo[playerid][pLeader]; // Устанавливаем цифру новых владельцев

				OrgLog(PlayerInfo[giveplayerid][pLeader], "sellgz", PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], gz, "");
				OrgLog(PlayerInfo[playerid][pLeader], "buygz", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], gz, "");
				SaveGangZone(gz); // Сохраняем
				OrganInfo[PlayerInfo[giveplayerid][pLeader]][gCapture][9] ++, OrganInfo[PlayerInfo[giveplayerid][pLeader]][gCapture][10] ++;
				OrganInfo[PlayerInfo[playerid][pLeader]][gCapture][11] ++, OrganInfo[PlayerInfo[playerid][pLeader]][gCapture][12] ++;
				SaveCapt(PlayerInfo[giveplayerid][pLeader]), SaveCapt(PlayerInfo[playerid][pLeader]);
				UpdateHonor(0);
				return 0;
	        }
	        else ErrorMessage(playerid, "{FF6347}Стоп! Вы не находитесь на продаваемой территории");
	    }
	}
    else if(dialogid == 841) // Настройка каптов
	{
		if(response)
		{
			new frakid = fraction(playerid);
            if(!IsAGang(playerid)) return ErrorMessage(playerid, "{FF6347}Вы не участник банды");
			if(Kapt[frakid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы не можете изменять условия во время битвы за территорию");

			if(listitem == 0)
			{
				if(OrganInfo[frakid][gRejim2] == false)
				{
					new unixtime = gettime();
					if(OrganInfo[frakid][gSanCbug] > unixtime) return ErrorText(playerid, "[ Мысли ]: Нельзя нападать с этим режимом [ Ограничение администрации ]"), cmd_capture(playerid);
				    if(OrganInfo[frakid][gSCbug] == true) return ErrorText(playerid, "[ Мысли ]: Прошлая битва была с этим режимом. Нельзя повторно!"), cmd_capture(playerid);
					OrganInfo[frakid][gRejim2] = true;
					format(store,sizeof(store),"{0088ff}[ GANG ZONE ]: {ffffff}%s изменил условия следующей битвы {cccccc}[ +C Активирован ]",PlayerInfo[playerid][pName]);
  					SendRadioMessage(frakid,COLOR_GREY,store);
  					OrgLog(frakid, "capture", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "+C: ON");
				}
				else if(OrganInfo[frakid][gRejim2] == true)
				{
					OrganInfo[frakid][gRejim2] = false;
					format(store,sizeof(store),"{0088ff}[ GANG ZONE ]: {ffffff}%s изменил условия следующей битвы {cccccc}[ +C Отключён ]",PlayerInfo[playerid][pName]);
  					SendRadioMessage(frakid,COLOR_GREY,store);
  					OrgLog(frakid, "capture", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "+C: OFF");
				}
			}
			OrganInfo[frakid][gUpdate] = 1;
			cmd_capture(playerid);
		}
	}
    else if(dialogid == 1008) // Сброс каптов
	{
		if(response)
		{
			if(CaptInfo[cCaptStat] == true) return ErrorMessage(playerid, "{FF6347}Нельзя во время капта");
			if(CaptInfo[cCaptReset] >= 1) return ErrorMessage(playerid, "{FF6347}Нельзя сразу после капта [ 10 секунд для сохранения ]");
			for(new i = 0; i < GZONES; i++)
			{
                GZInfo[i][gFrakVlad] = GangZone[i][defaultOrg];
				GangZoneShowForAll(i,GetGZColorF(GZInfo[i][gFrakVlad]));
				SaveGangZone(i);
			}

			for(new i = 13; i < 16; i++)
			{
				OrganInfo[i][gCapture][1] = 0, OrganInfo[i][gCapture][3] = 0, OrganInfo[i][gCapture][5] = 0, OrganInfo[i][gCapture][7] = 0, OrganInfo[i][gCapture][9] = 0;
				OrganInfo[i][gCapture][11] = 0;
			}
			ServerInfo[41] ++;
			SaveServer(41);
			UpdateHonor(0),UpdateHonor(1),UpdateHonor(2);
			format(store, sizeof(store), "{ffffff}** {ffffff}%s {00C6FF}сбросил все территории {cccccc}[ Подсчёт войны обновлён ] **",PlayerInfo[playerid][pName]);
			SendGangMessage(COLOR_ALLDEPT, store);
			format(store, sizeof(store), " [ ADM ]: %s сбросил все территории в гетто", PlayerInfo[playerid][pName]);
            ABroadCast(COLOR_ADM,store,1);
			AdminLog("reloadgz", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "");
		}
	}
    return 1;
}

CMD:gzona(playerid)
{
	if(PlayerInfo[playerid][pMember] == 13 || PlayerInfo[playerid][pMember] == 15 || PlayerInfo[playerid][pMember] == 14
	|| PlayerInfo[playerid][pLeader] == 16 || PlayerInfo[playerid][pSoska] >= 1
	|| PlayerInfo[playerid][pLeader] == 13 || PlayerInfo[playerid][pLeader] == 15 || PlayerInfo[playerid][pLeader] == 14 || PlayerInfo[playerid][pMember] == 16)
	{
		new str[128],sctring[1224];
		if(CaptInfo[cCaptStat] == false) return ErrorMessage(playerid, "{FF6347}Сейчас в гетто не происходит битвы за территорию");
		new i = CaptInfo[cZoneID];
		format(str,sizeof(str),"\n{cccccc}Территория №: %d",i), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}Принадлежит: %s",frakName[GZInfo[i][gFrakVlad]]), strcat(sctring,str);
		format(str,sizeof(str),"\n{FF6347}Территорию захватывают: %s",frakName[CaptInfo[cAttack]]), strcat(sctring,str);
		format(str,sizeof(str),"\n{FF6347}Капт завершится через: %d сек.",CaptInfo[cTime]), strcat(sctring,str);

		format(str,sizeof(str),"\n\n%s:",frakName[CaptInfo[cAttack]]), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}Убийств: {FF6347}%d",CaptInfo[cKillA]), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}На капте: %d чел. | Max: %d чел.",CaptInfo[cQuanityA], CaptInfo[cLogQuanA]), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}Присутствие: %d сек.",CaptInfo[cPresenceA]), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}Нанесено урона противнику: %d hp.",CaptInfo[cLogHealthA]), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}Использовано аптечек: %d шт.",CaptInfo[cLogMedA]), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}Трава: %d раз | Speede: %d раз | Грибы: %d раз | Порошок: %d раз",CaptInfo[cLogDrugA][0],CaptInfo[cLogDrugA][1],CaptInfo[cLogDrugA][2],CaptInfo[cLogDrugA][3]), strcat(sctring,str);

		format(str,sizeof(str),"\n\n%s:",frakName[CaptInfo[cDefend]]), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}Убийств: {FF6347}%d",CaptInfo[cKillD]), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}На капте: %d чел. | Max: %d чел.",CaptInfo[cQuanityD], CaptInfo[cLogQuanD]), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}Присутствие: %d сек.",CaptInfo[cPresenceD]), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}Нанесено урона противнику: %d hp.",CaptInfo[cLogHealthD]), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}Использовано аптечек: %d шт.",CaptInfo[cLogMedD]), strcat(sctring,str);
		format(str,sizeof(str),"\n{cccccc}Трава: %d раз | Speede: %d раз | Грибы: %d раз | Порошок: %d раз\n\n",CaptInfo[cLogDrugD][0],CaptInfo[cLogDrugD][1],CaptInfo[cLogDrugD][2],CaptInfo[cLogDrugD][3]), strcat(sctring,str);

		if(CaptInfo[cCbug] == 1) format(str,sizeof(str),"{cccccc}+C: {99ff66}[ On ]\n"), strcat(sctring,str);
		else if(CaptInfo[cCbug] == 0) format(str,sizeof(str),"{cccccc}+C: {FF6347}[ Off ]\n"), strcat(sctring,str);
		ShowDialog(playerid,1742,DIALOG_STYLE_MSGBOX,"{ff9000}Текущий Капт",sctring,"*","");
		return 1;
	}
	else ErrorMessage(playerid, "{FF6347}Вы не можете посмотреть информацию о текущей битве");
	return 1;
}

stock timerGangZones()
{
    if(CaptInfo[cCaptReset] >= 1) CaptInfo[cCaptReset] --;
	if(CaptInfo[cCaptPresenceCD] >= 1) CaptInfo[cCaptPresenceCD] --;
	if(CaptInfo[cCaptStat] == true)
	{
	    // Respawn Транспорта, каждые 15 сек
		if(CaptInfo[cRespawn] >= 15) CaptInfo[cRespawn] = 0, RespawnSquare();
		else CaptInfo[cRespawn] ++;
		//================
		new schetnap = 0,schetpro = 0;
		new g = CaptInfo[cZoneID];
		if(CaptInfo[cTime] >= 1) CaptInfo[cTime] --;
		if(CaptInfo[cTime] >= 1)
		{
			foreach(Player, i)
			{
                if(OnlineInfo[i][oLogged] == 0) continue;
                if(GetPVarInt(i,"afksystem") >= 5) continue;
                if(ADUTY[i] == 1) continue;

				if(IsPlayerInSquare(i,GangZone[g][gzMinX],GangZone[g][gzMinY],GangZone[g][gzMaxX],GangZone[g][gzMaxY]))
				{
					new Float:Pos[3];
					GetPlayerPos(i,Pos[0],Pos[1],Pos[2]);
					if((CaptInfo[cAttack] == PlayerInfo[i][pMember] || CaptInfo[cAttack] == PlayerInfo[i][pLeader]) && IsPlayerInSquare(i,GangZone[g][gzMinX],GangZone[g][gzMinY],GangZone[g][gzMaxX],GangZone[g][gzMaxY]) && Pos[2] <= 90.000) schetnap ++;
					if((CaptInfo[cDefend] == PlayerInfo[i][pMember] || CaptInfo[cDefend] == PlayerInfo[i][pLeader]) && IsPlayerInSquare(i,GangZone[g][gzMinX],GangZone[g][gzMinY],GangZone[g][gzMaxX],GangZone[g][gzMaxY]) && Pos[2] <= 90.000) schetpro ++;
				}
			}
			CaptInfo[cQuanityA] = schetnap;
            CaptInfo[cQuanityD] = schetpro;
            if(schetnap > CaptInfo[cLogQuanA]) CaptInfo[cLogQuanA] = schetnap;
            if(schetpro > CaptInfo[cLogQuanD]) CaptInfo[cLogQuanD] = schetpro;
            if(schetnap >= 1 && CaptInfo[cCaptPresenceCD] == 0) CaptInfo[cPresenceA] ++;
            if(schetpro >= 1) CaptInfo[cPresenceD] ++;
		}
		if(CaptInfo[cTime] == 0) CheckGangZone();
	}
    return 1;
}

stock CheckGangKill(playerid, killerid) // Капт
{
	if(CaptInfo[cCaptStat] == true)
	{
	    new g = CaptInfo[cZoneID];
 		if(GZInfo[g][gBitva] != 0)
		{
			if(IsPlayerInSquare(killerid,GangZone[g][gzMinX]-20.0,GangZone[g][gzMinY]-20.0,GangZone[g][gzMaxX]+20.0,GangZone[g][gzMaxY]+20.0) // Если убийца в зоне гангзоны
			&& IsPlayerInSquare(playerid,GangZone[g][gzMinX]-20.0,GangZone[g][gzMinY]-20.0,GangZone[g][gzMaxX]+20.0,GangZone[g][gzMaxY]+20.0)) // Если жертва в зоне гангзоны
			{
				if((PlayerInfo[playerid][pMember] == CaptInfo[cAttack] || PlayerInfo[playerid][pLeader] == CaptInfo[cAttack]) && (PlayerInfo[killerid][pMember] == CaptInfo[cDefend] || PlayerInfo[killerid][pLeader] == CaptInfo[cDefend]))
				{
	  				CaptInfo[cKillD]++; // Если тот, кто умер был нападающим, даём плюс защищающимся
	  				if(CBug[killerid] > gettime()) PlayerInfo[killerid][pGangTemp][1] ++, PlayerInfo[playerid][pGangTemp][3] ++;
	  				else PlayerInfo[killerid][pGangTemp][0] ++, PlayerInfo[playerid][pGangTemp][2] ++;
	  				if(PlayerInfo[killerid][pAchieve][54] == 0) AchievePlayer(killerid, 54, 1);
			  	}
              	else if((PlayerInfo[playerid][pMember] == CaptInfo[cDefend] || PlayerInfo[playerid][pLeader] == CaptInfo[cDefend]) && (PlayerInfo[killerid][pMember] == CaptInfo[cAttack] || PlayerInfo[killerid][pLeader] == CaptInfo[cAttack]))
			  	{
			  		CaptInfo[cKillA]++; // Если тот, кто умер был защищающимся, даём плюс нападающим
			  		if(CBug[killerid] > gettime()) PlayerInfo[killerid][pGangTemp][1] ++, PlayerInfo[playerid][pGangTemp][3] ++;
	  				else PlayerInfo[killerid][pGangTemp][0] ++, PlayerInfo[playerid][pGangTemp][2] ++;
	  				if(PlayerInfo[killerid][pAchieve][54] == 0) AchievePlayer(killerid, 54, 1);
		  		}
			}
		}
	}
	return 1;
}

stock CheckGangZone() // Распределение результатов по окончанию капта
{
	CaptInfo[cCaptStat] = false;
	CaptInfo[cCaptReset] = 10;
	new g = CaptInfo[cZoneID], head, cbug;
	if(ZoneCapt) DestroyDynamicArea(ZoneCapt), ZoneCapt = 0;
	foreach(Player,i)
	{
		if(OnlineInfo[i][oLogged] == 1)
		{
			if(PlayerInfo[i][pMember] == CaptInfo[cAttack] || PlayerInfo[i][pLeader] == CaptInfo[cAttack]
			|| PlayerInfo[i][pMember] == CaptInfo[cDefend] || PlayerInfo[i][pLeader] == CaptInfo[cDefend])
			{
				if(OnlineInfo[i][oActiviti] == 1) OnlineInfo[i][oActiviti] = 0;
			    new org = fraction(i), nauniti;
			    // Начисляем Юниты
				new vremun = PlayerInfo[i][pGangTemp][0]+PlayerInfo[i][pGangTemp][1];
				if(OrganInfo[org][gUnitStat][0] >= 1) nauniti += vremun*OrganInfo[org][gUnitStat][0];
				if(OrganInfo[org][gUnitStat][1] >= 1) nauniti += PlayerInfo[i][pGangTemp][4]*OrganInfo[org][gUnitStat][1];
				// Если война новая, очищаем сохранения старой войны
				if(PlayerInfo[i][pMyWar] >= 1 && PlayerInfo[i][pMyWar] != ServerInfo[41])
				{
					for(new gp = 0; gp < 16; gp++) PlayerInfo[i][pGangCapt][gp] = 0;
				}
				PlayerInfo[i][pUnit] += nauniti;
				PlayerInfo[i][pMyWar] = ServerInfo[41];
				for(new gp2 = 0; gp2 < 16; gp2++)
				{
					PlayerInfo[i][pGangCapt][gp2] += PlayerInfo[i][pGangTemp][gp2];
					PlayerInfo[i][pGangAll][gp2] += PlayerInfo[i][pGangTemp][gp2];
					PlayerInfo[i][pGangTemp][gp2] = 0;
				}
				SavePlayerCapt(i);
				mysql_save(i, 41);
			}
			if(gVidga[i] == true) DelUpdate(i), ClearDeathBox(i, 5);
		}
	}
	TopKiller(); // Формируем Топ
  	Kapt[CaptInfo[cAttack]] = 0;
 	Kapt[CaptInfo[cDefend]] = 0;
  	if(GoC[CaptInfo[cAttack]] >= 1 || GoC[CaptInfo[cDefend]] >= 1) ChutC[CaptInfo[cAttack]] = 10, ChutC[CaptInfo[cDefend]] = 10, cbug = 1;
  	GoC[CaptInfo[cAttack]] = 0;
  	GoC[CaptInfo[cDefend]] = 0;
	new unixtime = gettime();
	FrakCD[CaptInfo[cAttack]] = unixtime+ServerInfo[39]*60; // Устанавливаем кд между каптами
	new atext[24], btext[24], string[144];
	switch(random(7))
 	{
  		case 0: atext = "Красавчики", btext = "Позорище";
  		case 1: atext = "Респектосик", btext = "Фаршмаки";
  		case 2: atext = "Уважуха", btext = "Лахи";
  		case 3: atext = "Молочики", btext = "Как детей";
  		case 4: atext = "Пацаны, ваще ребята", btext = "Как девулю";
  		case 5: atext = "Зарешали", btext = "Натянули";
  		case 6: atext = "Раскатали", btext = "Сасамба";
	}
	// Подсчёт Результатов
	if(CaptInfo[cPresenceA] <= 299 && CaptInfo[cPresenceD] >= 300) // Захват не удался по ВРЕМЕНИ
	{
		if(CaptInfo[cDefend] >= 1)
		{
			format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {00cc00}Неплохо. {ffffff}Территория осталась под вашим контролем. %s{ffffff} обломалась!",frakName[CaptInfo[cAttack]]);
			SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,string);
			SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,"{0088ff}[ GANG ZONE ]: {ffffff}Противники больше половины времени битвы отсутствовали на территории");
		}
		if(CaptInfo[cAttack] >= 1)
		{
			format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ff0000}%s! {ffffff}Захват территории %s{ffffff} не удался", btext,frakName[CaptInfo[cDefend]]);
			SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,string);
			SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,"{0088ff}[ GANG ZONE ]: {ffffff}Ваша банда больше половины времени битвы отсутствовала на территории");
		}
		GZInfo[g][gBitva] = 0, GZInfo[g][gCherez] = unixtime+ServerInfo[40]*60;
		GangZoneShowForAll(g, GetGZColorF(CaptInfo[cDefend]));
		SaveGangZone(g);
		capt_win(CaptInfo[cDefend]);
		capt_loose(CaptInfo[cAttack]);
		// Логируем
		CaptLog(head, cbug, CaptInfo[cDefend], 0);
		return 1;
	}
	if(CaptInfo[cPresenceD] <= 299 && CaptInfo[cPresenceA] >= 300) // Захват удался по ВРЕМЕНИ
	{
		if(CaptInfo[cDefend] >= 1)
		{
			format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ff0000}Вы проиграли! {ffffff}Ваша территория теперь под контролем: %s",frakName[CaptInfo[cAttack]]);
			SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,string);
			SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,"{0088ff}[ GANG ZONE ]: {ffffff}Ваша банда больше половины времени битвы отсутствовала на территории");
		}
		if(CaptInfo[cAttack] >= 1)
		{
			format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ffffff}%s! Территория %s {ffffff}теперь под вашим контролем",atext,frakName[CaptInfo[cDefend]]);
			SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,string);
			SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,"{0088ff}[ GANG ZONE ]: {ffffff}Противники больше половины времени битвы отсутствовали на территории");
		}
		GangZoneShowForAll(g,GetGZColorF(CaptInfo[cAttack]));
		GZInfo[g][gBitva] = 0, GZInfo[g][gFrakVlad] = CaptInfo[cAttack];
		GZInfo[g][gCherez] = unixtime+ServerInfo[40]*60;
		SaveGangZone(g);
		InfoSendZone(CaptInfo[cAttack]);
		capt_loose(CaptInfo[cDefend]);
		capt_win(CaptInfo[cAttack]);
		// Логируем
		CaptLog(head, cbug, CaptInfo[cAttack], 1);
		return 1;
	}
  	if(CaptInfo[cQuanityA] >= 1 && CaptInfo[cQuanityD] >= 1) // По окончанию обе стороны на капте
  	{
		if(CaptInfo[cKillA] == 0 && CaptInfo[cKillD] == 0) // Никто никого не убил
		{
			if(CaptInfo[cDefend] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ff0000}Вы проиграли! {ffffff}Ваша территория теперь под контролем: %s",frakName[CaptInfo[cAttack]]);
				SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,string);
				SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,"{0088ff}[ GANG ZONE ]: {ffffff}Вы отреагировали на битву, но никого не смогли убить!");
			}
			if(CaptInfo[cAttack] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ffffff}%s! Территория %s {ffffff}теперь под вашим контролем",atext,frakName[CaptInfo[cDefend]]);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,string);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,"{0088ff}[ GANG ZONE ]: {ffffff}Противники отреагировали на битву, но никого не смогли убить!");
			}
			GangZoneShowForAll(g,GetGZColorF(CaptInfo[cAttack]));
			GZInfo[g][gBitva] = 0, GZInfo[g][gFrakVlad] = CaptInfo[cAttack];
			GZInfo[g][gCherez] = unixtime+ServerInfo[40]*60;
			SaveGangZone(g);
			InfoSendZone(CaptInfo[cAttack]);
			capt_loose(CaptInfo[cDefend]);
			capt_win(CaptInfo[cAttack]);
			// Логируем
			CaptLog(head, cbug, CaptInfo[cAttack], 2);
			return 1;
		}
		else if(CaptInfo[cKillA] == CaptInfo[cKillD]) // Счёт одинаковый
		{
			if(CaptInfo[cDefend] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {00cc00}Неплохо. {ffffff}Территория осталась под вашим контролем. %s{ffffff} обломалась!", frakName[CaptInfo[cAttack]]);
				SendRadioMessage(CaptInfo[cDefend], COLOR_LIGHTRED, string);
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: %s{ffffff}: %d убийств   {ff0000}|   %s{ffffff}: %d убийств",frakName[CaptInfo[cDefend]],CaptInfo[cKillD],frakName[CaptInfo[cAttack]],CaptInfo[cKillA]);
				SendRadioMessage(CaptInfo[cDefend], COLOR_LIGHTRED, string);
			}
			if(CaptInfo[cAttack] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ff0000}%s! {ffffff}Захват территории %s{ffffff} не удался", btext,frakName[CaptInfo[cDefend]]);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,string);
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: %s{ffffff}: %d убийств   {ff0000}|   %s{ffffff}: %d убийств",frakName[CaptInfo[cAttack]],CaptInfo[cKillA],frakName[CaptInfo[cDefend]],CaptInfo[cKillD]);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,string);
			}
			GZInfo[g][gBitva] = 0, GZInfo[g][gCherez] = unixtime+ServerInfo[40]*60;
			GangZoneShowForAll(g,GetGZColorF(CaptInfo[cDefend]));
			SaveGangZone(g);
			capt_win(CaptInfo[cDefend]);
			capt_loose(CaptInfo[cAttack]);
			// Логируем
			CaptLog(head, cbug, CaptInfo[cDefend], 3);
			return 1;
		}
		else if(CaptInfo[cKillA] > CaptInfo[cKillD]) // Атакующие больше убили
		{
			if(CaptInfo[cDefend] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ff0000}Вы проиграли! {ffffff}Ваша территория теперь под контролем: %s",frakName[CaptInfo[cAttack]]);
				SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,string);
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: %s{ffffff}: %d убийств   {ff0000}|   %s{ffffff}: %d убийств",frakName[CaptInfo[cDefend]],CaptInfo[cKillD],frakName[CaptInfo[cAttack]],CaptInfo[cKillA]);
				SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,string);
			}
			if(CaptInfo[cAttack] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ffffff}%s! Территория %s {ffffff}теперь под вашим контролем.",atext,frakName[CaptInfo[cDefend]]);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,string);
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: %s{ffffff}: %d убийств   {ff0000}|   %s{ffffff}: %d убийств",frakName[CaptInfo[cAttack]],CaptInfo[cKillA],frakName[CaptInfo[cDefend]],CaptInfo[cKillD]);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,string);
			}
			GangZoneShowForAll(g,GetGZColorF(CaptInfo[cAttack]));
			GZInfo[g][gBitva] = 0, GZInfo[g][gFrakVlad] = CaptInfo[cAttack];
			GZInfo[g][gCherez] = unixtime+ServerInfo[40]*60;
			SaveGangZone(g);
			InfoSendZone(CaptInfo[cAttack]);
			capt_loose(CaptInfo[cDefend]);
			capt_win(CaptInfo[cAttack]);
			// Логируем
			CaptLog(head, cbug, CaptInfo[cAttack], 4);
			return 1;
		}
		else if(CaptInfo[cKillD] > CaptInfo[cKillA]) // Защищающиеся больше убили
		{
			if(CaptInfo[cDefend] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {00cc00}Неплохо. {ffffff}Территория осталась под вашим контролем. %s{ffffff} обломалась!",frakName[CaptInfo[cAttack]]);
				SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,string);
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: %s{ffffff}: %d убийств   {ff0000}|   %s{ffffff}: %d убийств",frakName[CaptInfo[cDefend]],CaptInfo[cKillD],frakName[CaptInfo[cAttack]],CaptInfo[cKillA]);
				SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,string);
			}
			if(CaptInfo[cAttack] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ff0000}%s! {ffffff}Захват территории %s{ffffff} не удался",btext,frakName[CaptInfo[cDefend]]);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,string);
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: %s{ffffff}: %d убийств   {ff0000}|   %s{ffffff}: %d убийств",frakName[CaptInfo[cAttack]],CaptInfo[cKillA],frakName[CaptInfo[cDefend]],CaptInfo[cKillD]);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,string);
			}
			GZInfo[g][gBitva] = 0, GangZoneShowForAll(g,GetGZColorF(CaptInfo[cDefend]));
			GZInfo[g][gCherez] = unixtime+ServerInfo[40]*60;
			SaveGangZone(g);
			capt_win(CaptInfo[cDefend]);
			capt_loose(CaptInfo[cAttack]);
			// Логируем
			CaptLog(head, cbug, CaptInfo[cDefend], 5);
			return 1;
		}
  	}
  	else // Никого на капте не осталось
  	{
		if(CaptInfo[cQuanityA] == CaptInfo[cQuanityD]) // Одинаковое количество в конце на капте
		{
			if(CaptInfo[cDefend] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {00cc00}Неплохо. {ffffff}Территория осталась под вашим контролем. %s{ffffff} обломалась!",frakName[CaptInfo[cAttack]]);
				SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,string);
				SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,"{0088ff}[ GANG ZONE ]: {ffffff}Ваши противники оставили территорию без контроля!");
			}
			if(CaptInfo[cAttack] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ff0000}%s! {ffffff}Захват территории %s{ffffff} не удался",btext,frakName[CaptInfo[cDefend]]);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,string);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,"{0088ff}[ GANG ZONE ]:{ffffff}Вы оставили территорию без контроля!");
			}
			GZInfo[g][gBitva] = 0, GZInfo[g][gCherez] = unixtime+ServerInfo[40]*60;
			GangZoneShowForAll(g,GetGZColorF(CaptInfo[cDefend]));
			SaveGangZone(g);
			capt_win(CaptInfo[cDefend]);
			capt_loose(CaptInfo[cAttack]);
			// Логируем
			CaptLog(head, cbug, CaptInfo[cDefend], 6);
			return 1;
		}
		else if(CaptInfo[cQuanityA] > CaptInfo[cQuanityD]) // Если нападающие есть, а защищающиеся бросили территорию
		{
			if(CaptInfo[cDefend] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ff0000}Вы проиграли! {ffffff}Ваша территория теперь под контролем: %s",frakName[CaptInfo[cAttack]]);
				SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,string);
				SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,"{0088ff}[ GANG ZONE ]: {ffffff}Вы оставили территорию без контроля!");
			}
			if(CaptInfo[cAttack] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ffffff}%s! Территория %s {ffffff}теперь под вашим контролем",atext,frakName[CaptInfo[cDefend]]);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,string);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,"{0088ff}[ GANG ZONE ]: {ffffff}Ваши противники оставили территорию без контроля!");
			}
			GangZoneShowForAll(g,GetGZColorF(CaptInfo[cAttack]));
			GZInfo[g][gBitva] = 0, GZInfo[g][gFrakVlad] = CaptInfo[cAttack];
			GZInfo[g][gCherez] = unixtime+ServerInfo[40]*60;
			SaveGangZone(g);
			InfoSendZone(CaptInfo[cAttack]);
			capt_loose(CaptInfo[cDefend]);
			capt_win(CaptInfo[cAttack]);
			// Логируем
			CaptLog(head, cbug, CaptInfo[cAttack], 7);
			return 1;
		}
		else if(CaptInfo[cQuanityD] > CaptInfo[cQuanityA]) // Если нападающие съебались, а защищающиеся есть на терре
		{
			if(CaptInfo[cDefend] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {00cc00}Неплохо. {ffffff}Территория осталась под вашим контролем. %s{ffffff} обломалась!",frakName[CaptInfo[cAttack]]);
				SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,string);
				SendRadioMessage(CaptInfo[cDefend],COLOR_LIGHTRED,"{0088ff}[ GANG ZONE ]: {ffffff}Ваши противники оставили территорию без контроля!");
			}
			if(CaptInfo[cAttack] >= 1)
			{
				format(string,sizeof(string),"{0088ff}[ GANG ZONE ]: {ff0000}%s! {ffffff}Захват территории %s{ffffff} не удался",btext,frakName[CaptInfo[cDefend]]);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,string);
				SendRadioMessage(CaptInfo[cAttack],COLOR_LIGHTRED,"{0088ff}[ GANG ZONE ]: {ffffff}Вы оставили территорию без контроля!");
			}
			GZInfo[g][gBitva] = 0, GangZoneShowForAll(g,GetGZColorF(CaptInfo[cDefend]));
			GZInfo[g][gCherez] = unixtime+ServerInfo[40]*60;
			SaveGangZone(g);
			capt_win(CaptInfo[cDefend]);
			capt_loose(CaptInfo[cAttack]);
			// Логируем
			CaptLog(head, cbug, CaptInfo[cDefend], 8);
			return 1;
		}
  	}
  	return 1;
}

stock InfoSendZone(g) // Оповещение в чат о результатах количества территорий банды
{
 	new zgang;
	for(new z = 0; z < GZONES; z++) { if(GZInfo[z][gFrakVlad] == g) zgang ++; }
	if(zgang >= GZONES)
	{
		format(store, sizeof(store), "** [%s] Под контролем %s {FF8282}%d территорий {ff9000}[ Короли Гетто ] {FF8282}**", AbbName[g], frakName[g], zgang);
		SendGangMessage(COLOR_ALLDEPT, store);
		format(store, sizeof(store), " [ ADM ]: Внимание! Всё гетто полностью захвачено %s {cccccc}[ Требуется сброс /reloadgz ]", frakName[g]);
		ABroadCast(COLOR_ADM,store,1);
		OrganInfo[g][gCapture][0] ++;
		OrgLog(g, "ghetto", 0, "", "", 0, "", "", 0, "Короли Гетто");
	}
	else
	{
		format(store, sizeof(store), "** [%s] Под контролем %s {FF8282}%d территорий **", AbbName[g], frakName[g], zgang);
		SendGangMessage(COLOR_ALLDEPT, store);
	}
	return 1;
}
stock hideGangZones(playerid)
{
  for(new g = 0;g < GZONES; g++) GangZoneHideForPlayer(playerid, g);
  return 1;
}

stock showGangZones(playerid)
{
    for(new g = 0;g < GZONES; g++)
	{
		GangZoneShowForPlayer(playerid, g, GetGangZoneColor(g));
		if(GZInfo[g][gBitva] != 0) GangZoneFlashForPlayer(playerid,g,0xff0000AA);
	}
    return 1;
}

stock IsAPlayerInZone(playerid)
{
	if(CaptInfo[cCaptStat] == true)
	{
		new g = CaptInfo[cZoneID];
 		if(GZInfo[g][gBitva] != 0)
		{
	    	new Float:Pos[3];
			GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
	    	if(IsPlayerInSquare(playerid,GangZone[g][gzMinX],GangZone[g][gzMinY],GangZone[g][gzMaxX],GangZone[g][gzMaxY]) && ADUTY[playerid] == 0 && GetPVarInt(playerid,"afksystem") < 5 && OnlineInfo[playerid][oLogged] == 1 && Pos[2] <= 90.000)
	    	{
				return 1;
			}
			return 0;
		}
		return 0;
	}
	return 0;
}
stock IsAZoneCapt(playerid)
{
	new org = fraction(playerid);
	if(CaptInfo[cCaptStat] == true && org >= 1)
	{
		new g = CaptInfo[cZoneID];
 		if(GZInfo[g][gBitva] != 0)
		{
		    if(CaptInfo[cAttack] == org || CaptInfo[cDefend] == org)
		    {
		    	new Float:Pos[3];
				GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
		    	if(IsPlayerInSquare(playerid,GangZone[g][gzMinX],GangZone[g][gzMinY],GangZone[g][gzMaxX],GangZone[g][gzMaxY]) && ADUTY[playerid] == 0 && GetPVarInt(playerid,"afksystem") < 5 && OnlineInfo[playerid][oLogged] == 1 && Pos[2] <= 90.000)
		    	{
					return 1;
				}
				return 0;
		    }
		    return 0;
		}
		return 0;
	}
	return 0;
}

stock IsACapt(playerid) // Проверка, находится ли игрок в зоне активного капта
{
	new yesCapt;
	for(new g = 0; g < GZONES; g++)
	{
		if(GZInfo[g][gBitva] > 0) continue;

		if(IsPlayerInSquare(playerid,GangZone[g][gzMinX],GangZone[g][gzMinY],GangZone[g][gzMaxX],GangZone[g][gzMaxY]))
		{
			yesCapt = 1;
			break;
		}
	}
    return yesCapt;
}

stock IsAGhetto(playerid) // Проверка, находится ли игрок на территории гетто
{
    new yesGhetto;
	for(new g = 0; g < GZONES; g++)
	{
		if(IsPlayerInSquare(playerid,GangZone[g][gzMinX],GangZone[g][gzMinY],GangZone[g][gzMaxX],GangZone[g][gzMaxY]))
        {
            yesGhetto = 1;
            break;
        }
	}
    return yesGhetto;
}

stock RespawnSquare()
{
	new g = CaptInfo[cZoneID];
	new bool:unwanted[SKOKOCAROV];
	foreach(Player,i)
	{
       	if(IsPlayerInAnyVehicle(i)) { unwanted[GetPlayerVehicleID(i)] = true; }
       	if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(i))) { unwanted[GetVehicleTrailer(GetPlayerVehicleID(i))] = true; }
	}
	for(new car = 1; car < SKOKOCAROV; car++)
	{
		if(!unwanted[car])
		{
			if(IsVehicleInSquare(car, GangZone[g][gzMinX]-20.0, GangZone[g][gzMinY]-20.0,GangZone[g][gzMaxX]+20.0,GangZone[g][gzMaxY]+20.0)) PP_SetVehicleToRespawn(car);
		}
	}
	return 1;
}

function LoadGangZone() // Грузим зоны из базы
{
	new time = GetTickCount();
	new rows, idx;
	cache_get_row_count(rows);
	for(new f; f < GZONES; ++f)
	{
        cache_get_value_name_int(f, "id", idx);
	    cache_get_value_name_int(f, "FrakVlad", GZInfo[idx][gFrakVlad]);
		GZInfo[idx][gID] = GangZoneCreate(GangZone[idx][gzMinX],GangZone[idx][gzMinY],GangZone[idx][gzMaxX],GangZone[idx][gzMaxY]);
		GZInfo[idx][gBitva] = 0;
	}
 	UpdateHonor(0); // Показываем количество территорий банд
	printf("[MODE]: Gang Zone [%d Quan][%d ms]",rows,GetTickCount() - time);
	return 1;
}

stock SaveGangZone(idx) // Сохраняем зону
{
    format(big_query, sizeof(big_query), "UPDATE `pp_zones` SET `FrakVlad`='%d', `data` = NOW() WHERE `id` = '%d'", GZInfo[idx][gFrakVlad], idx);
    query_empty(pearsq, big_query);
    return 1;
}

stock GetGangZoneColor(gangzonex)
{
    new zx;
    switch(GZInfo[gangzonex][gFrakVlad])
    {
        case 13: zx = 0x00cc00AA; // Grove Street
        case 14: zx = 0x9900ccAA; // Ballas Gang
        case 15: zx = 0xffcc33AA; // Vagos Gang
        case 16: zx = 0x00ffffAA; // Los Aztecas Gang
        default: zx = 0xffffffAA; // Отсутствие параметра
    }
    return zx;
}
stock GetGZColorF(fnumber)
{
    new zx;
    switch(fnumber)
    {
        case 13: zx = 0x00cc00AA; // Grove Street
        case 14: zx = 0x9900ccAA; // Ballas Gang
        case 15: zx = 0xffcc33AA; // Vagos Gang
        case 16: zx = 0x00ffffAA; // Los Aztecas Gang
        default: zx = 0xffffffAA; // Отсутствие параметра
    }
    return zx;
}

stock CreateCaptZone(i) // Создаём детали для квеста
{
	if(ZoneCapt) DestroyDynamicArea(ZoneCapt);
    ZoneCapt = CreateDynamicCube(GangZone[i][gzMinX] - 50.0,GangZone[i][gzMinY] - 50.0, -50.0, GangZone[i][gzMaxX] + 50.0,GangZone[i][gzMaxY] + 50.0, 200.0, 0, 0);
    return 1;
}
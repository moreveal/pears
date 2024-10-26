
#define MOVE_SPEED              100.0
#define ACCEL_RATE              0.03

#define CAMERA_MODE_NONE    	0
#define CAMERA_MODE_FLY     	1

#define MOVE_FORWARD    		1
#define MOVE_BACK       		2
#define MOVE_LEFT       		3
#define MOVE_RIGHT      		4
#define MOVE_FORWARD_LEFT       5
#define MOVE_FORWARD_RIGHT      6
#define MOVE_BACK_LEFT          7
#define MOVE_BACK_RIGHT         8

enum noclipenum
{
	cameramode,
	flyobject,
	mode,
	lrold,
	udold,
	lastmove,
	Float:accelmul,
	vehicleAttach,
	Float:posAttach[3]
}
new noclipdata[MAX_REALPLAYERS][noclipenum];


alias:flycam("flymode", "fly")
CMD:flycam(playerid)
{
    if(PlayerInfo[playerid][pSoska] >= 4 || PlayerInfo[playerid][pMedia] > 0)
    {
		if(CnnVed[playerid] >= 11) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: [ /tv ]");
		if(OverHear[playerid] >= 1) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Невозможно во время использования камер слежения");
		if(DeskStatus[playerid] == 1) return SendClientMessage(playerid, COLOR_GREY,"[ Мысли ]: Нужно выйти из-за стола и уже после лететь в слежку");
  		if(noclipdata[playerid][cameramode] == CAMERA_MODE_FLY) CancelFlyMode(playerid);
        else
		{
           if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я нахожусь в наблюдении");
           if(setting_pos_draw[playerid] > 0 || setting_size_draw[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Завершите редактирование текстдравов");
           if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
           {
	            if(PlayerInfo[playerid][pSped]==0 && UpdateSpeed[playerid] >= 1) // Удаляем 3D спидометр
				{
	              UpdateSpeed[playerid] = 0;
	              DestroyDynamicObject(SpdObj[playerid][0]);
	              DestroyDynamicObject(SpdObj[playerid][1]);
	              SpdObj[playerid][0] = INVALID_STREAMER_ID;
	              SpdObj[playerid][1] = INVALID_STREAMER_ID;
		        }
		        if(PlayerInfo[playerid][pDrawVisible][7] == false) CloseVehSpeed(playerid);
           }

		   SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: W,A,S,D - управление | Num 4, Num 6 - скорость | Левая кнопка мыши - сбросить скорость");
		   FlyMode(playerid);
        }
 		return 1;
    }
	return 1;
}

alias:flyveh("vehfly", "vehcam", "camveh")
CMD:flyveh(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] >= 4 || PlayerInfo[playerid][pMedia] > 0)
    {
		if(noclipdata[playerid][cameramode] != CAMERA_MODE_FLY) return ErrorMessage(playerid, "{FF6347}Для начала запустите /flycam");

		if(noclipdata[playerid][vehicleAttach] > 0) // Отключаем крепление камеры от транспорта
		{
			new Float:x, Float:y, Float:z;
			if(IsValidVehicle(noclipdata[playerid][vehicleAttach])) GetVehiclePos(noclipdata[playerid][vehicleAttach], x, y, z);
			else GetPlayerObjectPos(playerid, noclipdata[playerid][flyobject], x, y, z);
			noclipdata[playerid][vehicleAttach] = 0;
			DestroyPlayerObject(playerid, noclipdata[playerid][flyobject]);
			noclipdata[playerid][flyobject] = CreatePlayerObject(playerid, 19300, x, y, z, 0.0, 0.0, 0.0);
			AttachCameraToPlayerObject(playerid, noclipdata[playerid][flyobject]);
		}
		else // Крепим камеру к транспорту
		{
			if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Прикрепить камеру к транспорту [ /flyveh VehID ]");
			if(!IsValidVehicle(params[0])) return ErrorMessage(playerid, "{FF6347}Этого транспорта не существует");
			noclipdata[playerid][vehicleAttach] = params[0];
			FlyCamVehicleNewPos(playerid);
			FlyCamVehiclePos(playerid);
			SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: W,A,S,D - перемещать камеру относительно транспорта | LMB - вверх, RMB - вниз");
		}
	}
	return true;
}

stock FlyCamProcess(playerid)
{
    new keys,ud,lr;
    GetPlayerKeys(playerid,KEY:keys,ud,lr);

    if(noclipdata[playerid][vehicleAttach] > 0) FlyCamVehicleMove(playerid, KEY:keys, ud, lr);
    else
    {
        new current_tick = GetTickCount();
        new interval = GetTickDiff(current_tick, noclipdata[playerid][lastmove]);
        if(noclipdata[playerid][mode] && (interval > 100))
        {
            MoveCamera(playerid);
        }
        if(noclipdata[playerid][udold] != ud || noclipdata[playerid][lrold] != lr)
        {
            if((noclipdata[playerid][udold] != 0 || noclipdata[playerid][lrold] != 0) && ud == 0 && lr == 0)
            {
                StopPlayerObject(playerid, noclipdata[playerid][flyobject]);
                noclipdata[playerid][mode]      = 0;
                noclipdata[playerid][accelmul]  = 0.0;
            }
            else
            {
                noclipdata[playerid][mode] = GetMoveDirectionFromKeys(ud, lr);
                MoveCamera(playerid);
            }
        }
        noclipdata[playerid][udold] = ud; noclipdata[playerid][lrold] = lr;
    }
    return true;
}

stock FlyCamResetVariable(playerid)
{
    noclipdata[playerid][cameramode] 	= CAMERA_MODE_NONE;
	noclipdata[playerid][lrold]	   	 	= 0;
	noclipdata[playerid][udold]   		= 0;
	noclipdata[playerid][mode]   		= 0;
	noclipdata[playerid][lastmove]   	= 0;
	noclipdata[playerid][accelmul]   	= 0.0;
    return true;
}

stock FlyMode(playerid)
{
	new Float:X, Float:Y, Float:Z, Float:A;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, A);
	SpA[playerid] = A;
	SpX[playerid] = X;
	SpY[playerid] = Y;
	SpZ[playerid] = Z;
	SpInt[playerid] = GetPlayerInterior(playerid);
	SpWorld[playerid] = GetPlayerVirtualWorld(playerid);
	noclipdata[playerid][flyobject] = CreatePlayerObject(playerid, 19300, X, Y, Z, 0.0, 0.0, 0.0);
	PPTogglePlayerSpectating(playerid, true);
	AttachCameraToPlayerObject(playerid, noclipdata[playerid][flyobject]);
	noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
	noclipdata[playerid][vehicleAttach] = 0;
	noclipdata[playerid][posAttach][0] = 0.0;
	noclipdata[playerid][posAttach][1] = 0.0;
	noclipdata[playerid][posAttach][2] = 0.0;
	return 1;
}

stock CancelFlyMode(playerid)
{
	SetPosa[playerid] = 1;
	PPExitSpectating(playerid);
	noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	DestroyPlayerObject(playerid, noclipdata[playerid][flyobject]);
	noclipdata[playerid][lrold]= 0;
	noclipdata[playerid][udold]= 0;
	noclipdata[playerid][mode]= 0;
	noclipdata[playerid][lastmove]= 0;
	noclipdata[playerid][accelmul]= 0.0;
	return 1;
}

// Двигаем камеру по направлению
stock MoveCamera(playerid)
{
	new Float:FV[3], Float:CP[3];
	GetPlayerCameraPos(playerid, CP[0], CP[1], CP[2]);
    GetPlayerCameraFrontVector(playerid, FV[0], FV[1], FV[2]);
	if(noclipdata[playerid][accelmul] <= 1) noclipdata[playerid][accelmul] += ACCEL_RATE;

	new Float:realSpeed = OnlineInfo[playerid][oFlycamSpeed];
	if(realSpeed == 0.0) realSpeed = MOVE_SPEED * noclipdata[playerid][accelmul];

	new Float:X, Float:Y, Float:Z;
	GetNextCameraPosition(noclipdata[playerid][mode], CP, FV, X, Y, Z);
	MovePlayerObject(playerid, noclipdata[playerid][flyobject], X, Y, Z, realSpeed);
	noclipdata[playerid][lastmove] = GetTickCount();
	return 1;
}

// Записываем положение камеры в чат
stock SavePositionFlyCam(playerid)
{
	const Float:fScale = 5.0;

	new Float:fPX, Float:fPY, Float:fPZ, 
		Float:fVX, Float:fVY, Float:fVZ, 
		Float:object_x, Float:object_y, Float:object_z;
	GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
    GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);

	object_x = fPX + floatmul(fVX, fScale);
	object_y = fPY + floatmul(fVY, fScale);
	object_z = fPZ + floatmul(fVZ, fScale);
	SendClientMessage(playerid, COLOR_GREY, "FlyCameraPos(playerid, %f, %f, %f, %f, %f, %f, 1000, 1200);", fPX, fPY, fPZ, object_x, object_y, object_z);
	return true;
}

// Сбрасываем настройки скорости камеры
stock ResetFlycamSpeed(playerid)
{
	OnlineInfo[playerid][oFlycamSpeed] = 0.0;
	noclipdata[playerid][accelmul] = 0;
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Reset Flycam Speed", 1000, 3);
	return 1;
}

// Увеличиваем скорость камеры
stock FoldFlycamSpeed(playerid)
{
	if(OnlineInfo[playerid][oFlycamSpeed] >= 0.20) OnlineInfo[playerid][oFlycamSpeed] += 0.1;
	else OnlineInfo[playerid][oFlycamSpeed] += 0.01;

	new string[54];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~%.2f", OnlineInfo[playerid][oFlycamSpeed]);
	GameTextForPlayer(playerid,string, 800, 3);
	return 1;
}

// Уменьшаем скорость камеры
stock SubtractFlycamSpeed(playerid)
{
	if(OnlineInfo[playerid][oFlycamSpeed] > 0.0)
	{
		if(OnlineInfo[playerid][oFlycamSpeed] >= 0.30) OnlineInfo[playerid][oFlycamSpeed] -= 0.1;
		else OnlineInfo[playerid][oFlycamSpeed] -= 0.01;

		new string[54];
		format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~%.2f", OnlineInfo[playerid][oFlycamSpeed]);
		GameTextForPlayer(playerid,string, 800, 3);
	}
	return 1;
}
stock GetMoveDirectionFromKeys(ud, lr)
{
	new direction = 0;
    if(lr < 0)
	{
		if(ud < 0) 		direction = MOVE_FORWARD_LEFT;
		else if(ud > 0) direction = MOVE_BACK_LEFT;
		else            direction = MOVE_LEFT;
	}
	else if(lr > 0)
	{
		if(ud < 0)      direction = MOVE_FORWARD_RIGHT;
		else if(ud > 0) direction = MOVE_BACK_RIGHT;
		else			direction = MOVE_RIGHT;
	}
	else if(ud < 0) 	direction = MOVE_FORWARD;
	else if(ud > 0) 	direction = MOVE_BACK;

	return direction;
}
stock GetNextCameraPosition(move_mode, const Float:CP[3], const Float:FV[3], &Float:X, &Float:Y, &Float:Z)
{
    #define OFFSET_X (FV[0]*6000.0)
	#define OFFSET_Y (FV[1]*6000.0)
	#define OFFSET_Z (FV[2]*6000.0)
	switch(move_mode)
	{
		case MOVE_FORWARD:
		{
			X = CP[0]+OFFSET_X;
			Y = CP[1]+OFFSET_Y;
			Z = CP[2]+OFFSET_Z;
		}
		case MOVE_BACK:
		{
			X = CP[0]-OFFSET_X;
			Y = CP[1]-OFFSET_Y;
			Z = CP[2]-OFFSET_Z;
		}
		case MOVE_LEFT:
		{
			X = CP[0]-OFFSET_Y;
			Y = CP[1]+OFFSET_X;
			Z = CP[2];
		}
		case MOVE_RIGHT:
		{
			X = CP[0]+OFFSET_Y;
			Y = CP[1]-OFFSET_X;
			Z = CP[2];
		}
		case MOVE_BACK_LEFT:
		{
			X = CP[0]+(-OFFSET_X - OFFSET_Y);
 			Y = CP[1]+(-OFFSET_Y + OFFSET_X);
		 	Z = CP[2]-OFFSET_Z;
		}
		case MOVE_BACK_RIGHT:
		{
			X = CP[0]+(-OFFSET_X + OFFSET_Y);
 			Y = CP[1]+(-OFFSET_Y - OFFSET_X);
		 	Z = CP[2]-OFFSET_Z;
		}
		case MOVE_FORWARD_LEFT:
		{
			X = CP[0]+(OFFSET_X  - OFFSET_Y);
			Y = CP[1]+(OFFSET_Y  + OFFSET_X);
			Z = CP[2]+OFFSET_Z;
		}
		case MOVE_FORWARD_RIGHT:
		{
			X = CP[0]+(OFFSET_X  + OFFSET_Y);
			Y = CP[1]+(OFFSET_Y  - OFFSET_X);
			Z = CP[2]+OFFSET_Z;
		}
	}
}

stock FlyCamVehicleNewPos(playerid)
{
	noclipdata[playerid][posAttach][0] = 0.0;
	noclipdata[playerid][posAttach][1] = 0.0;
	noclipdata[playerid][posAttach][2] = 2.0;
	return true;
}

stock FlyCamVehicleMove(playerid, KEY:keys, ud, lr)
{
	if(lr == KEY_LEFT) noclipdata[playerid][posAttach][0] -= 0.1;
	else if(lr == KEY_RIGHT) noclipdata[playerid][posAttach][0] += 0.1;

	else if(ud == KEY_UP) noclipdata[playerid][posAttach][1] += 0.1;
	else if(ud == KEY_DOWN) noclipdata[playerid][posAttach][1] -= 0.1;

	else if(keys == KEY:KEY_FIRE) noclipdata[playerid][posAttach][2] += 0.1;
	else if(keys == KEY:KEY_RIGHT) noclipdata[playerid][posAttach][2] -= 0.1;

	FlyCamVehiclePos(playerid);
	return true;
}

stock FlyCamVehiclePos(playerid)
{
	AttachPlayerObjectToVehicle(playerid, noclipdata[playerid][flyobject], noclipdata[playerid][vehicleAttach], noclipdata[playerid][posAttach][0], noclipdata[playerid][posAttach][1], noclipdata[playerid][posAttach][2], 0.0, 0.0, 0.0);
	AttachCameraToPlayerObject(playerid, noclipdata[playerid][flyobject]);
	return true;
}

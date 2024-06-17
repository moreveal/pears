stock GetVehicleRotation(vehicleid,&Float:rx,&Float:ry,&Float:rz){
	new Float: qw, Float: qx, Float: qy, Float: qz;
    GetVehicleRotationQuat(vehicleid, qw, qx, qy, qz);

	// Преобразование в углы Эйлера
	rx = asin(2 * qy * qz - 2 * qx * qw);
    ry = -atan2(qx * qz + qy * qw, 0.5 - qx * qx - qy * qy);
    rz = -atan2(qx * qy + qz * qw, 0.5 - qx * qx - qz * qz);

    // Нормализация
    rx = fmod(rx + 360.0, 360.0);
    ry = fmod(ry + 360.0, 360.0);
    rz = fmod(rz + 360.0, 360.0);
}

stock VehicleOnPlayerDisconnect(playerid)
{
	// Если был прикреплен трейлер
	new tid = GetPlayerTrailerID(playerid);
	if (tid > -1) {
		if (trailerInfo[tid][tAttached]) {
			new trailerid = GetVehicleTrailer(trailerInfo[tid][tAttached]);
			if (trailerid > 0) ACDestroyVehicle(trailerid);
			else KillTimer(trailerInfo[tid][tTimerID]);
		}
	}
	return 1;
}

stock IsVehicleStandingGround(vehicleid) {
	if (!IsValidVehicle(vehicleid)) return false;

	new Float: vehicle_pos[3], Float: z;
	GetVehiclePos(vehicleid, vehicle_pos[0], vehicle_pos[1], vehicle_pos[2]);
	CA_FindZ_For2DCoord(vehicle_pos[0], vehicle_pos[1], z);

	return abs(vehicle_pos[2] - z) <= 1.0;
}

stock SetVehicleSpeed(vehicleid, speed_mph)
{
	if (speed_mph < 1) speed_mph = 1;
	new Float: v[3], Float:cur_speed_mph;
	GetVehicleVelocity(vehicleid, v[0], v[1], v[2]);
	cur_speed_mph = GetVehicleSpeed(vehicleid);
	if (cur_speed_mph <= 0)
	{
		new Float: zAngle;
		GetVehicleZAngle(vehicleid, zAngle);
		new Float:newVelX = floatcos((zAngle -= 270.0), degrees) *speed_mph / 200;
		SetVehicleVelocity(vehicleid, newVelX, floattan(zAngle,degrees) *newVelX, 0.0);
		return;
	}
	new Float: vMultiplier = float(speed_mph) / cur_speed_mph;
	SetVehicleVelocity(vehicleid, v[0] *vMultiplier, v[1] *vMultiplier, v[2] *vMultiplier);
}

stock GetClosestVehicle(playerid, Float:maxDistance = 3.0) {
	if (IsPlayerInAnyVehicle(playerid)) return GetPlayerVehicleID(playerid);
	
	new Float:last_dist = 99999.0;
	new last_vehicleid = INVALID_VEHICLE_ID;
	new Float:px, Float:py, Float:pz; GetPlayerPos(playerid, px, py, pz);

	foreach (new vehicleid : Vehicle) {
		if (IsVehicleStreamedIn(vehicleid, playerid)) {
			new Float:dist = GetVehicleDistanceFromPoint(vehicleid, px, py, pz);
			if (dist <= last_dist && dist <= maxDistance)
			{
				last_dist = dist;
				last_vehicleid = vehicleid;
			}
		}
	}
	return last_vehicleid;
}
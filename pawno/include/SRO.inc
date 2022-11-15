#include <a_samp>
////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
//  ++////////////////////////////////////////////////////////////////////////////////////////++  //
//  //                                                                                        //  //
//  //    Smoothly Rotate Objects                                                             //  //
//  //    _________________________                                                           //  //
//  //    By NoZer0                                                                           //  //
//  //                                                                                        //  //
//  //    Functions:                                                                          //  //
//  //                                                                                        //  //
//  //    native RotateObject(Objectid, Float:RotX, Float:RotY, Float:RotZ, Float:Speed=2.0)  //  //
//  //                                                                                        //  //
//  ++////////////////////////////////////////////////////////////////////////////////////////++  //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////

forward Core_UpdateRotating(Objectid, Float:RotX, Float:RotY, Float:RotZ, Float:Speed, LastUpdate, xDone, yDone, zDone);
forward OnObjectRotated(objectid);

////////////////////////////////////////////////////////////////////////////////////////////////////

#if !defined SRO_UPDATE_TIME
	#define SRO_UPDATE_TIME 5
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

stock RotateObject(Objectid, Float:RotX, Float:RotY, Float:RotZ, Float:Speed=5.0)
{
	SetTimerEx("Core_UpdateRotating", SRO_UPDATE_TIME, 0, "dffffdddddd", Objectid, RotX, RotY, RotZ, Speed/100, GetTickCount(), 0, 0, 0);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

public Core_UpdateRotating(Objectid, Float:RotX, Float:RotY, Float:RotZ, Float:Speed, LastUpdate, xDone, yDone, zDone)
{
	new Float:curX, Float:curY, Float:curZ;
	GetObjectRot(Objectid, curX, curY, curZ);
	if (!xDone)
	{
		if (curX < RotX)
		{
			curX += (Speed * (GetTickCount() - LastUpdate));
			if (curX >= RotX)
			{
			    xDone = true;
			    curX = RotX;
			}
		}
		else
		{
			curX -= (Speed * (GetTickCount() - LastUpdate));
			if (curX <= RotX)
			{
			    xDone = true;
				curX = RotX;
			}
		}
	}
	if (!yDone)
	{
		if (curY < RotY)
		{
			curY += (Speed * (GetTickCount() - LastUpdate));
			if (curY >= RotY)
			{
			    yDone = true;
			    curY = RotY;
			}
		}
		else
		{
			curY -= (Speed * (GetTickCount() - LastUpdate));
			if (curY <= RotY)
			{
			    yDone = true;
				curY = RotY;
			}
		}
	}
	if (!zDone)
	{
		if (curZ < RotZ)
		{
			curZ += (Speed * (GetTickCount() - LastUpdate));
			if (curZ >= RotZ)
			{
			    zDone = true;
			    curZ = RotZ;
			}
		}
		else
		{
			curZ -= (Speed * (GetTickCount() - LastUpdate));
			if (curZ <= RotZ)
			{
			    zDone = true;
				curZ = RotZ;
			}
		}
	}
	SetObjectRot(Objectid, curX, curY, curZ);
	if (!xDone || !yDone || !zDone)
	{
		SetTimerEx("Core_UpdateRotating", SRO_UPDATE_TIME, 0, "dffffdddd", Objectid, RotX, RotY, RotZ, Speed, GetTickCount(), xDone, yDone, zDone);
	}
	else
	{
		SetTimerEx("OnObjectRotated", 500, 0, "d", Objectid);
	}
	return 1;
}


#define RECORDING_TYPE 1

#include <a_npc>

main(){}

public OnRecordingPlaybackEnd() StopRecordingPlayback();
public OnNPCEnterVehicle(vehicleid, seatid)
{
	PlayBackNext();
}
public OnNPCExitVehicle() StopRecordingPlayback();

stock PlayBackNext()
{
	new destination = CheckDestination();
	if(destination == 0) StartRecordingPlayback(RECORDING_TYPE, "dominic_start");
	else if(destination == 1) StartRecordingPlayback(RECORDING_TYPE, "dominic_race1");
	else if(destination == 2) StartRecordingPlayback(RECORDING_TYPE, "dominic_race2");
}

stock CheckDestination()
{
    new File:handle = fopen("dominic.txt", io_read);
	new buf[5];
	if(handle)
	{
		fread(handle, buf);
		fclose(handle);
		
		if(strval(buf) == 1) return 1;
		else if(strval(buf) == 2) return 2;
		else return 0;
	}
	return 0;
}


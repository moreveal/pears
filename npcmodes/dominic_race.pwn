
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
	else
	{
	    new string[40];
	    format(string,sizeof(string),"dominic_race%d", destination);
	    StartRecordingPlayback(RECORDING_TYPE, string);
	}
}

stock CheckDestination()
{
    new File:handle = fopen("dominic.txt", io_read);
	new buf[5];
	if(handle)
	{
		fread(handle, buf);
		fclose(handle);
		
		new result = strval(buf);
		return result;
	}
	return 0;
}


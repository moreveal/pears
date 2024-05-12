
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
	switch(random(7))
	{
		case 0: StartRecordingPlayback(RECORDING_TYPE, "test_fly");
		case 1: StartRecordingPlayback(RECORDING_TYPE, "fly0");
		case 2: StartRecordingPlayback(RECORDING_TYPE, "fly1");
		case 3: StartRecordingPlayback(RECORDING_TYPE, "fly2");
		case 4: StartRecordingPlayback(RECORDING_TYPE, "fly3");
		case 5: StartRecordingPlayback(RECORDING_TYPE, "fly4");
		case 6: StartRecordingPlayback(RECORDING_TYPE, "fly5");
	}
}


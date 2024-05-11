
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
  StartRecordingPlayback(RECORDING_TYPE, "test_fly");
}


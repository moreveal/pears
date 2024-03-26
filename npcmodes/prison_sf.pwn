
#define RECORDING_TYPE 1

#include <a_npc>
main(){}

new PartPlayback;

public OnRecordingPlaybackEnd() PlayBackNext();
public OnNPCEnterVehicle(vehicleid, seatid) PlayBackNext();
public OnNPCExitVehicle() StopRecordingPlayback();

stock PlayBackNext()
{
  if(PartPlayback == 0) StartRecordingPlayback(RECORDING_TYPE, "prison_sf0"), PartPlayback = 1;
  else if(PartPlayback == 1) StartRecordingPlayback(RECORDING_TYPE, "prison_sf1"), PartPlayback = 2;
  else if(PartPlayback == 2) StartRecordingPlayback(RECORDING_TYPE, "prison_end"), PartPlayback = 3;
  else if(PartPlayback == 3) StopRecordingPlayback(), PartPlayback = 0;
}

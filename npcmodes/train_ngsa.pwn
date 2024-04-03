
#define RECORDING_TYPE 1

#include <a_npc>
main(){}

new PartPlayback;

public OnRecordingPlaybackEnd() PlayBackNext();
public OnNPCEnterVehicle(vehicleid, seatid) PlayBackNext();
public OnNPCExitVehicle() StopRecordingPlayback();

stock PlayBackNext()
{
  if(GetDesciptionName("[LS]"))
  {
    if(PartPlayback == 0) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_ls0"), PartPlayback = 1;
    else if(PartPlayback == 1) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_ls1"), PartPlayback = 2;
    else if(PartPlayback == 2) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_ls2"), PartPlayback = 3;
    else if(PartPlayback == 3) StopRecordingPlayback(), PartPlayback = 0;
  }
  else if(GetDesciptionName("[SF]"))
  {
    if(PartPlayback == 0) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_sf0"), PartPlayback = 1;
    else if(PartPlayback == 1) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_sf1"), PartPlayback = 2;
    else if(PartPlayback == 2) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_sf2"), PartPlayback = 3;
    else if(PartPlayback == 3) StopRecordingPlayback(), PartPlayback = 0;
  }
  else if(GetDesciptionName("[LV]"))
  {
    if(PartPlayback == 0) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_lv0"), PartPlayback = 1;
    else if(PartPlayback == 1) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_lv1"), PartPlayback = 2;
    else if(PartPlayback == 2) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_lv2"), PartPlayback = 3;
    else if(PartPlayback == 3) StopRecordingPlayback(), PartPlayback = 0;
  }
}

stock GetDesciptionName(const, text[])
{
  new npcname[MAX_PLAYER_NAME];
  GetPlayerName(2, npcname, sizeof(npcname));

  if(strfind(npcname, text, true) != -1) return 1; // Поиск совпадения в имени
  return 0;
}

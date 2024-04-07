
#define RECORDING_TYPE 1

#include <a_npc>

main(){}

new PartPlayback;

public OnRecordingPlaybackEnd() StopRecordingPlayback();
public OnNPCEnterVehicle(vehicleid, seatid)
{
	PlayBackNext();
	PartPlayback ++;
	if(PartPlayback == 3) PartPlayback = 0;
}
public OnNPCExitVehicle() StopRecordingPlayback();

stock PlayBackNext()
{
  new destination = CheckDestination();
  if(destination == 0)
  {
    if(PartPlayback == 0) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_ls0"); // Едем до первой остановки (место где поезд можно ограбить)
	else if(PartPlayback == 1) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_ls1"); // Едем до места назначения (город в который везём боеприпасы)
    else if(PartPlayback == 2) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_ls2"); // Едем обратно до базы
    else if(PartPlayback == 3) StopRecordingPlayback();
  }
  else if(destination == 1)
  {
    if(PartPlayback == 0) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_sf0"); // Едем до первой остановки (место где поезд можно ограбить)
	else if(PartPlayback == 1) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_sf1"); // Едем до места назначения (город в который везём боеприпасы)
    else if(PartPlayback == 2) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_sf2"); // Едем обратно до базы
    else if(PartPlayback == 3) StopRecordingPlayback();
  }
  else if(destination == 2)
  {
    if(PartPlayback == 0) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_lv0"); // Едем до первой остановки (место где поезд можно ограбить)
	else if(PartPlayback == 1) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_lv1"); // Едем до места назначения (город в который везём боеприпасы)
    else if(PartPlayback == 2) StartRecordingPlayback(RECORDING_TYPE, "ngsa_train_lv2"); // Едем обратно до базы
    else if(PartPlayback == 3) StopRecordingPlayback();
  }
}

stock CheckDestination()
{
    new File:handle = fopen("ngsa_train.txt", io_read);
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


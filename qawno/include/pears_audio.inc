#if defined _INC_audio_stream_plugin
	#endinput
#endif
#define _INC_audio_stream_plugin

#pragma tabsize 4

#define INVALID_AUDIOSTREAM AudioStream:0xFFFF

/*
                                                                           
    888b      88                       88                                      
    8888b     88                ,d     ""                                      
    88 `8b    88                88                                             
    88  `8b   88  ,adPPYYba,  MM88MMM  88  8b       d8   ,adPPYba,  ,adPPYba,  
    88   `8b  88  ""     `Y8    88     88  `8b     d8'  a8P_____88  I8[    ""  
    88    `8b 88  ,adPPPPP88    88     88   `8b   d8'   8PP"""""""   `"Y8ba,   
    88     `8888  88,    ,88    88,    88    `8b,d8'    "8b,   ,aa  aa    ]8I  
    88      `888  `"8bbdP"Y8    "Y888  88      "8"       `"Ybbd8"'  `"YbbdP"'  
                                                                           
                                                                           

*/

native AudioStream:CreateAudioStream(const name[] = "", colour = -1);
native bool:DeleteAudioStream(AudioStream:stream);

native bool:AttachAudioStreamToPlayer(AudioStream:stream, vehicleid);
native bool:AttachAudioStreamToVehicle(AudioStream:stream, vehicleid);

native bool:AttachAudioStreamListener(AudioStream:stream, playerid);
native bool:DetachAudioStreamListener(AudioStream:stream, playerid);
native bool:IsAudioStreamListenerAttached(AudioStream:stream, playerid);

native bool:AttachAudioStreamSpeaker(AudioStream:stream, playerid);
native bool:DetachAudioStreamSpeaker(AudioStream:stream, playerid);
native bool:IsAudioStreamSpeakerAttached(AudioStream:stream, playerid);
native bool:IsAudioStreamSpeakerSpeaking(AudioStream:stream, playerid);
native bool:IsPlayerSpeaking(playerid);

native bool:SetAudioStreamAutostreamState(AudioStream:stream, bool:enabled);
native bool:SetAudioStreamAutostreamDist(AudioStream:stream, Float:dist);
native bool:IsAudioStreamAutostreamEnabled(AudioStream:stream);

native bool:SetAudioStreamMinDistance(AudioStream:stream, Float:dist);
native bool:SetAudioStreamMaxDistance(AudioStream:stream, Float:dist);

native bool:SetAudioStreamSpatialState(AudioStream:stream, bool:enabled);
native bool:IsAudioStreamSpatialEnabled(AudioStream:stream);

native bool:SetAudioStreamUrl(AudioStream:stream, const url[], bool:withTiming = true);

native bool:GetAudioStreamVirtualWorld(AudioStream:stream);
native bool:GetAudioStreamPosition(AudioStream:stream, &Float:x, &Float:y, &Float:z);
native bool:SetAudioStreamVirtualWorld(AudioStream:stream, worldid);
native bool:SetAudioStreamPosition(AudioStream:stream, Float:x, Float:y, Float:z);

/*

      ,ad8888ba,               88  88  88                                   88
     d8"'    `"8b              88  88  88                                   88
    d8'                        88  88  88                                   88
    88             ,adPPYYba,  88  88  88,dPPYba,   ,adPPYYba,   ,adPPYba,  88   ,d8   ,adPPYba,
    88             ""     `Y8  88  88  88P'    "8a  ""     `Y8  a8"     ""  88 ,a8"    I8[    ""
    Y8,            ,adPPPPP88  88  88  88       d8  ,adPPPPP88  8b          8888[       `"Y8ba,
     Y8a.    .a8P  88,    ,88  88  88  88b,   ,a8"  88,    ,88  "8a,   ,aa  88`"Yba,   aa    ]8I
      `"Y8888Y"'   `"8bbdP"Y8  88  88  8Y"Ybbd8"'   `"8bbdP"Y8   `"Ybbd8"'  88   `Y8a  `"YbbdP"'



*/

forward bool:OnPlayerVoiceSpeak(playerid, AudioStream:stream);

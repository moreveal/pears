
#define MAX_MUSIC_ZONE 100
#define MAX_LENGTH_MUSIC 84
#define DISTANCE_MUSIC_AROUND 50.0

enum musInfo
{
    bool:musStat, // Статус зоны музыки
    musLink[MAX_LENGTH_MUSIC], // Ссылка на музыку
	musZone, // Зона музыки
    musTimer, // Таймер музыки
    musUserid, // ID аккаунта, который создал точку
    musPlayerid, // ID игрока, который создал точку
    musUnix, // Unix время когда запустили музыку
}
new MusicInfo[MAX_MUSIC_ZONE][musInfo];

CMD:music(playerid, const params[])
{
    new inputLength = strlen(params[0]);
    if(inputLength <= 0 || inputLength >= MAX_LENGTH_MUSIC) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Поставить точку музыки [ /music link ]");
	if(sscanf(params, "s[MAX_LENGTH_MUSIC]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Поставить точку музыки [ /music link ]");

    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    CreateMusic(playerid, pos[0], pos[1], pos[2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), DISTANCE_MUSIC_AROUND, params[0]);
	return 1;
}

stock OnPlayerEnterMusicZone(playerid)
{
    for(new i = 0; i < MAX_MUSIC_ZONE; i++)
    {
        if(MusicInfo[i][musStat] == true)
        {

            break;
        }
    }
    return 1;
}

stock PlayMusicZone(playerid)

stock CreateMusic(playerid, Float:x, Float:y, Float:z, world, interior, Float:distance, const link[]) // Создаём зону музыки
{
    new i = GetFreeSlotMusic();
    if(i == -1) return ErrorMessage(playerid, "{FF6347}На сервере создано максимальное количество зон с музыкой\n{cccccc}Пожалуйста подождите и повторите попытку позже");
    
    MusicInfo[i][musStat] = true;
    MusicInfo[i][musUserid] = PlayerInfo[playerid][pID];
    MusicInfo[i][musPlayerid] = playerid;
    format(MusicInfo[i][musLink], MAX_LENGTH_MUSIC, "%s", link);
    MusicInfo[i][musZone] = CreateDynamicSphere(x, y, z, distance, world, interior);
    MusicInfo[i][musTimer] = SetTimerEx("DestroyMusicZone", 600000, false, "d", i);
    return 1;
}

stock DestroyMusicZone(i)
{
    if(MusicInfo[i][musStat] == false) return 0;

    MusicInfo[i][musStat] = false;
    MusicInfo[i][musUserid] = 0;
    MusicInfo[i][musPlayerid] = 0;
    DestroyDynamicArea(MusicInfo[i][musZone]);
    KillTimer(MusicInfo[i][musTimer]);
    return 1;
}

stock GetFreeSlotMusic() // Получаем свободный слот для создания точки музыки
{
    for(new i = 0; i < MAX_MUSIC_ZONE; i++)
    {
       if(MusicInfo[i][musStat] == false) return i;
    }
    return -1;
}

stock PlayAudioStreamForPlayer(const playerid, const url[], const Float:posX = 0.0, const Float:posY = 0.0, const Float:posZ = 0.0, const Float:distance = 50.0, const usepos = 0, const seconds = 0)
{
    new BS:bs = BS_New();
    BS_WriteUint8(bs, strlen(url));
    BS_WriteString(bs, url);
    BS_WriteFloat(bs, posX);
    BS_WriteFloat(bs, posY);
    BS_WriteFloat(bs, posZ);
    BS_WriteFloat(bs, distance);
    BS_WriteUint8(bs, usepos == 0 ? 0 : 1);
    if (seconds > 0) {
        BS_WriteUint16(bs, seconds);
    }
    PR_SendRPC(bs, playerid, 41);
    BS_Delete(bs);
    return 1;
}
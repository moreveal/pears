#pragma library SART
native CreateArt(text[], type, Float:sX, Float:sY, Float:sZ, Float:aX, Float:aY, Float:aZ, Float:dist=200.0);
native CreateDynamicArt(text[], type, Float:sX, Float:sY, Float:sZ, Float:aX, Float:aY, Float:aZ, wid=-1, iid=-1, pid=-1, Float:sdist=200.0, Float:ddist=0.0);
native DestroyArt(artid);
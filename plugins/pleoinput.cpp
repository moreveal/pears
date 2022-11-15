
#include <Windows.h>
#include "SDK\amx\amx.h"
#include "SDK\plugincommon.h"

typedef void (*logprintf_t)(char* format, ...);

logprintf_t logprintf;
extern void *pAMXFunctions;

cell AMX_NATIVE_CALL GetVirtualKeyState(AMX* amx, cell* params)
{
	if(GetAsyncKeyState(params[1]) & 0x8000)
		return true;

	return false;
}

cell AMX_NATIVE_CALL GetScreenSize(AMX* amx, cell* params)
{
	RECT Screen;
	GetWindowRect(GetDesktopWindow(), &Screen);

	cell* Addr;

	amx_GetAddr(amx, params[1], &Addr);
	*Addr = Screen.right;

	amx_GetAddr(amx, params[2], &Addr);
	*Addr = Screen.bottom;

	return 1;
}

cell AMX_NATIVE_CALL GetMousePos(AMX* amx, cell* params)
{
    POINT Cursor; 
	GetCursorPos(&Cursor);

	cell* Addr;

	amx_GetAddr(amx, params[1], &Addr);
	*Addr = Cursor.x;

	amx_GetAddr(amx, params[2], &Addr);
	*Addr = Cursor.y;

    return 1;
}

cell AMX_NATIVE_CALL SetMousePos(AMX* amx, cell* params)
{
	SetCursorPos(params[1], params[2]);
    return 1;
}

PLUGIN_EXPORT unsigned int PLUGIN_CALL Supports() 
{
    return SUPPORTS_VERSION | SUPPORTS_AMX_NATIVES;
}

PLUGIN_EXPORT bool PLUGIN_CALL Load(void **ppData) 
{
    pAMXFunctions = ppData[PLUGIN_DATA_AMX_EXPORTS];
    logprintf = (logprintf_t) ppData[PLUGIN_DATA_LOGPRINTF];

    logprintf("\n* iPLEOMAX's Device Input for SA-MP Plugin loaded!\n> Intended for adding keyboard/mouse support for custom filterscript tools.\n");
    return true;
}

PLUGIN_EXPORT void PLUGIN_CALL Unload()
{
    logprintf("* PLEOINPUT unloaded.");
}

AMX_NATIVE_INFO PluginNatives[] =
{
	{"GetVirtualKeyState", GetVirtualKeyState},
	{"GetScreenSize", GetScreenSize},
    {"GetMousePos", GetMousePos},
	{"SetMousePos", SetMousePos},
    {0, 0}
};

PLUGIN_EXPORT int PLUGIN_CALL AmxLoad( AMX *amx ) 
{
    return amx_Register(amx, PluginNatives, -1);
}


PLUGIN_EXPORT int PLUGIN_CALL AmxUnload( AMX *amx ) 
{
    return AMX_ERR_NONE;
}
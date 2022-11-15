/*
 * SA-MP Clientside Anticheat (SAMPCAC)
 * Version:         v0.10.0
 * Author:          0xCAC
 * Compatible with: SA-MP 0.3.7 Server
 * Site:            https://SAMPCAC.xyz
 * Documentation:   https://SAMPCAC.xyz/docs
 */

#if defined _sampcac_included
	#endinput
#endif
#define _sampcac_included

/* 
 * Include version:
 */

public const CAC_INCLUDE_MAJOR = 0;
public const CAC_INCLUDE_MINOR = 10;
public const CAC_INCLUDE_PATCH = 0;

/* 
 * Client hardware ID definitions:
 */

#define CAC__MAX_HARDWARE_ID                           64 // maximum size (NUL included) of hardware ID

/* 
 * Cheat definitions:
 * Used as:
 *   `cheat_id` in `CAC_OnCheatDetect`
 */

#define CAC_CHEAT__AIMBOT_1                             0 // aimbot
#define CAC_CHEAT__AIMBOT_2                             1 // aimbot
#define CAC_CHEAT__TRIGGERBOT_1                         2 // triggerbot
#define CAC_CHEAT__TRIGGERBOT_2                         3 // triggerbot
#define CAC_CHEAT__NAMETAG_1                            4 // nametag ESP
#define CAC_CHEAT__ESP_1                                5 // general ESP
// NOTE: sets `opt1` to the virtual key code of the key pressed by macro
// NOTE: some recording softwares (eg: Fraps) are detected as macros on injection, so you shouldn't take action immediately for this cheat
#define CAC_CHEAT__MACRO_1                              6 // macro/keybinder
#define CAC_CHEAT__FAKE_PING_1                          7 // fake ping #1
#define CAC_CHEAT__WEAPON_INFO_1                        8 // "weapon.dat" changes (accuracy, fire range etc)
#define CAC_CHEAT__NORECOIL_1                           9 // no-recoil
#define CAC_CHEAT__NORECOIL_2                          10 // no-recoil
#define CAC_CHEAT__AIMBOT_3                            11 // aimbot
#define CAC_CHEAT__AIMBOT_4                            12 // aimbot
#define CAC_CHEAT__CLEO                                13 // CLEO.asi
#define CAC_CHEAT__AIMBOT_5                            14 // aimbot
#define CAC_CHEAT__AIMBOT_6                            15 // aimbot
#define CAC_CHEAT__NORECOIL_3                          16 // no-recoil
#define CAC_CHEAT__UNTRUSTED_1                         17 // various actions
#define CAC_CHEAT__UNTRUSTED_2                         18 // various actions
#define CAC_CHEAT__UNTRUSTED_3                         19 // various actions
#define CAC_CHEAT__UNTRUSTED_4                         20 // various actions
#define CAC_CHEAT__ALL                                 21

/* 
 * Glitch definitions:
 * Used as:
 *   `glitch_id` in `CAC_SetGlitchStatus`
 *   `glitch_id` in `CAC_GetGlitchStatus`
 *   `glitch_id` in `CAC_PlayerSetGlitchSettings`
 */

#define CAC_GLITCH__QUICKRELOAD                         0
#define CAC_GLITCH__FASTFIRE                            1
#define CAC_GLITCH__FASTMOVE                            2
#define CAC_GLITCH__CROUCHBUG                           3
#define CAC_GLITCH__FASTSPRINT                          4
#define CAC_GLITCH__QUICKSTAND                          5
#define CAC_GLITCH__ALL                                 6

/* 
 * Game option definitions:
 * Used as:
 *   `option_id` in `CAC_SetGameOptionStatus`
 *   `option_id` in `CAC_GetGameOptionStatus`
 *   `option_id` in `CAC_PlayerSetGameOption`
 */

#define CAC_GAMEOPTION__VEHICLEBLIPS                    0 // show/hide radar blips
#define CAC_GAMEOPTION__MANUALRELOADING                 1 // press 'R' to reload
#define CAC_GAMEOPTION__DRIVEONWATER                    2 // car = boat (SEAWAYS cheat code from GTA:VC)
#define CAC_GAMEOPTION__FIREPROOF                       3 // ped won't take any damage from fire
#define CAC_GAMEOPTION__SPRINT                          4 // see CAC_GAMEOPTION_STATUS__SPRINT_* definitions
#define CAC_GAMEOPTION__INFINITESPRINT                  5 // infinite sprint (swimming too)
#define CAC_GAMEOPTION__INFINITEOXYGEN                  6 // infinite breath under water
#define CAC_GAMEOPTION__INFINITEAMMO                    7 // infinite ammo (no reload)
#define CAC_GAMEOPTION__NIGHTVISION                     8 // show/hide night vision effect
#define CAC_GAMEOPTION__THERMALVISION                   9 // show/hide thermal vision effect
#define CAC_GAMEOPTION__ALL                            10

/* 
 * Game option status definitions for sprinting type:
 * Note:
 *   Used only when `option_id` = `CAC_GAMEOPTION__SPRINT`
 * Used as:
 *   `status` in `CAC_SetGameOptionStatus`
 *   `returned value` in `CAC_GetGameOptionStatus`
 *   `status` in `CAC_PlayerSetGameOption`
 */
 
#define CAC_GAMEOPTION_STATUS__SPRINT_DEFAULT           0 // sprint on certain surfaces only (default GTA:SA behaviour)
#define CAC_GAMEOPTION_STATUS__SPRINT_ALLSURFACES       1 // sprint on all surfaces (+ interiors)
#define CAC_GAMEOPTION_STATUS__SPRINT_DISABLED          2 // can't sprint at all

/* 
 * Kick definitions:
 * Used as:
 *   `reason_id` in `CAC_OnPlayerKick`
 */

#define CAC_KICKREASON__CONNECTION_ISSUE                0 // internal issues
#define CAC_KICKREASON__VERSION_NOT_COMPATIBLE          1 // client version incompatible
#define CAC_KICKREASON__ALL                             2

/* 
 * Game resource pseudo-model ID definitions:
 * Used as:
 *   `model_id` in `CAC_OnGameResourceMismatch`
 */

#define CAC_GAMERESOURCE_MODELID__ONLY_IF_MODDED       -1 // used when `report_type` = `CAC_GAMERESOURCE_REPORTTYPE__ONLY_IF_MODDED`
#define CAC_GAMERESOURCE_MODELID__PEDIFP      		20000

/* 
 * Game resource model type flag definitions:
 * Note: 
 *   These flags can be combined with bitwise OR operator (example below)
 *     report_flags = CAC_GAMERESOURCE_MODELTYPEFLAG__PEDS | CAC_GAMERESOURCE_MODELTYPEFLAG__WEAPONS;
 * Used as:
 *   `model_type_flag` in `CAC_SetGameResourceReportStatus`
 *   `model_type_flag` in `CAC_GetGameResourceReportStatus`
 *   `report_flags` in `CAC_PlayerSetGameResource`
 */

#define CAC_GAMERESOURCE_MODELTYPEFLAG__PEDS        0x01 // ped/skin models (0.3.7 only skins are included)
#define CAC_GAMERESOURCE_MODELTYPEFLAG__VEHICLES    0x02 // vehicle models (paintjobs are not included)
#define CAC_GAMERESOURCE_MODELTYPEFLAG__WEAPONS     0x04 // weapon models
#define CAC_GAMERESOURCE_MODELTYPEFLAG__OTHERS      0x08 // remaining models (eg: buildings, fences, streets etc)
#define CAC_GAMERESOURCE_MODELTYPEFLAG__PEDIFP      0x10 // ped.ifp file
#define CAC_GAMERESOURCE_MODELTYPEFLAG__ALL         0xFF

/* 
 * Game resource report type definitions:
 * Used as:
 *   `report_type` in `CAC_SetGameResourceReportType`
 *   `returned value` in `CAC_GetGameResourceReportType`
 *   `report_type` in `CAC_PlayerSetGameResource`
 */

#define CAC_GAMERESOURCE_REPORTTYPE__DISABLED          0 // no game resource checks are done
#define CAC_GAMERESOURCE_REPORTTYPE__ONLY_IF_MODDED    1 // will call `CAC_OnGameResourceMismatch` only once per player session with `model_id` = `CAC_GAMERESOURCE_MODELID__ONLY_IF_MODDED` if game resources are modded
#define CAC_GAMERESOURCE_REPORTTYPE__FULL              2 // will call `CAC_OnGameResourceMismatch` for every modded game resource (may use a lot of bandwidth)

/* 
 * Game resource component type definitions:
 * Used as:
 *   `component_type` in `CAC_OnGameResourceMismatch`
 */

#define CAC_GAMERESOURCE_COMPONENTTYPE__DFF         0x00 // DFF of `model_id` is modded
#define CAC_GAMERESOURCE_COMPONENTTYPE__TXD         0x01 // TXD of `model_id` is modded
#define CAC_GAMERESOURCE_COMPONENTTYPE__ANIM        0x02 // ANIM of `model_id` is modded
#define CAC_GAMERESOURCE_COMPONENTTYPE__INVALID     0xFF // `model_id` is not in range of valid game models [0, 19999], thus it can't have a component

/* 
 * General natives:
 */

native CAC_GetStatus(player_id);
native CAC_GetClientVersion(player_id, &major, &minor, &patch);
native CAC_GetServerVersion(&major, &minor, &patch);
native CAC_GetHardwareID(player_id, hardware_id[], max_size = sizeof(hardware_id));
native CAC_ReadMemory(player_id, address, size);

/* 
 * GTA:SA glitch natives:
 */

native CAC_SetGlitchStatus(glitch_id, status);
native CAC_GetGlitchStatus(glitch_id);
native CAC_PlayerSetGlitchSettings(player_id, glitch_id, status);

/* 
 * Game option natives:
 */

native CAC_SetGameOptionStatus(option_id, status);
native CAC_GetGameOptionStatus(option_id);
native CAC_PlayerSetGameOption(player_id, option_id, status);

/* 
 * Game resource check natives:
 */

native CAC_SetGameResourceReportStatus(model_type_flag, status);
native CAC_GetGameResourceReportStatus(model_type_flag);
native CAC_SetGameResourceReportType(report_type);
native CAC_GetGameResourceReportType();
native CAC_PlayerSetGameResource(player_id, report_flags, report_type); 

/* 
 * Callbacks:
 */

forward CAC_OnCheatDetect(player_id, cheat_id, opt1, opt2);
forward CAC_OnPlayerKick(player_id, reason_id);
forward CAC_OnMemoryRead(player_id, address, size, const content[]);
forward CAC_OnGameResourceMismatch(player_id, model_id, component_type, checksum);
forward CAC_OnScreenshotTaken(player_id);
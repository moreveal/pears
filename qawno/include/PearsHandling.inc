// MIT License

// Copyright (c) 2023 Northn

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if !defined HANDLING_INC_
    #define HANDLING_INC_

    #define VEHICLE_HANDLING_RPC_ID 151

    enum HandlingEntry {
        HANDLING_RESET,

        HANDLING_MASS,                                      // m_fMass
        HANDLING_TURNMASS,                                  // m_fTurnMass
        HANDLING_DRAGMULT,                                  // m_fDragMult
        HANDLING_CENTREOFMASS_X,                            // m_vecCentreOfMass.x
        HANDLING_CENTREOFMASS_Y,                            // m_vecCentreOfMass.y
        HANDLING_CENTREOFMASS_Z,                            // m_vecCentreOfMass.z
        HANDLING_TRACTIONMULTIPLIER,                        // m_fTractionMultiplier
        HANDLING_TRACTIONLOSS,                              // m_fTractionLoss
        HANDLING_TRACTIONBIAS,                              // m_fTractionBias
        HANDLING_NUMOFGEARS,                                // m_transmissionData.m_nNumberOfGears
        HANDLING_MAXVELOCITY,                               // m_transmissionData.m_fMaxGearVelocity
        HANDLING_ENGINEACCELERATION,                        // m_transmissionData.m_fEngineAcceleration
        HANDLING_ENGINEINERTIA,                             // m_transmissionData.m_fEngineInertia
        HANDLING_DRIVETYPE,                                 // m_transmissionData.m_nDriveType
        HANDLING_BRAKEDECELERATION,                         // m_fBrakeDeceleration
        HANDLING_BRAKEBIAS,                                 // m_fBrakeBias
        HANDLING_ABS,                                       // m_bABS
        HANDLING_STEERINGLOCK,                              // m_fSteeringLock
        HANDLING_SUSPFORCELEVEL,                            // m_fSuspensionForceLevel
        HANDLING_SUSPDAMPINGLEVEL,                          // m_fSuspensionDampingLevel
        HANDLING_SUSPHIGHSPDCOMDAMP,                        // m_fSuspensionHighSpdComDamp
        HANDLING_SUSPUPPERLIMIT,                            // m_fSuspensionUpperLimit
        HANDLING_SUSPLOWERLIMIT,                            // m_fSuspensionLowerLimit
        HANDLING_SUSPBIASBETWEEN,                           // m_fSuspensionBiasBetweenFrontAndRear
        HANDLING_WHEELSCALE,                                // custom: CVehicle->m_fWheelScale
        HANDLING_WHEELTILT,                                 // custom: wheel_tilt

        HANDLING_MAX
    };

    enum HandlingEntryType {
        HANDLING_TYPE_NONE,
        HANDLING_TYPE_BOOL,
        HANDLING_TYPE_FLOAT,
        HANDLING_TYPE_INT,
        HANDLING_TYPE_MAX
    };

    enum HandlingEntryAddModeType {
      HANDLING_ADD_NONE,
      HANDLING_ADD_SIMPLE,
      HANDLING_ADD_MULTIPLIER,

      HANDLING_ADD_MAX
    };

    #if !defined __cplusplus
        const WORLDVEHADD_RPC_PAWN = 164;

        new BitStream:vehicleHandlingsRpcs[MAX_VEHICLES];

        stock IsVehicleHandlingModified(const vehicleid) {
            return _:vehicleHandlingsRpcs[vehicleid] != 0;
        }

        stock HandlingEntryType:GetHandlingEntryType(const HandlingEntry:entry) {
            switch (entry) {
            case HANDLING_RESET:
                return HANDLING_TYPE_NONE;
            case HANDLING_MASS,
                HANDLING_TURNMASS,
                HANDLING_DRAGMULT,
                HANDLING_CENTREOFMASS_X,
                HANDLING_CENTREOFMASS_Y,
                HANDLING_CENTREOFMASS_Z,
                HANDLING_TRACTIONMULTIPLIER,
                HANDLING_TRACTIONLOSS,
                HANDLING_TRACTIONBIAS,
                HANDLING_MAXVELOCITY,
                HANDLING_ENGINEACCELERATION,
                HANDLING_ENGINEINERTIA,
                HANDLING_BRAKEDECELERATION,
                HANDLING_BRAKEBIAS,
                HANDLING_STEERINGLOCK,
                HANDLING_SUSPFORCELEVEL,
                HANDLING_SUSPDAMPINGLEVEL,
                HANDLING_SUSPHIGHSPDCOMDAMP,
                HANDLING_SUSPUPPERLIMIT,
                HANDLING_SUSPLOWERLIMIT,
                HANDLING_SUSPBIASBETWEEN,
                HANDLING_WHEELSCALE,
                HANDLING_WHEELTILT:
                return HANDLING_TYPE_FLOAT;
            case HANDLING_NUMOFGEARS,
                HANDLING_DRIVETYPE,
                HANDLING_ABS:
                return HANDLING_TYPE_INT;
            default:
                return HANDLING_TYPE_MAX;
            }
            return HANDLING_TYPE_MAX;
        }

        stock SetVehicleHandlingFloat(const vehicleid, const HandlingEntry:entry, const Float:value, const HandlingEntryAddModeType:addMode = HANDLING_ADD_NONE) {
            if (GetVehicleModel(vehicleid) == 0) return 0;
            if (GetHandlingEntryType(entry) != HANDLING_TYPE_FLOAT) return 0;
            if (!IsVehicleHandlingModified(vehicleid)) {
                vehicleHandlingsRpcs[vehicleid] = BS_New();
                BS_WriteUint16(vehicleHandlingsRpcs[vehicleid], vehicleid);
            }
            new replaced = 0;
            new usedBytes;
            BS_GetNumberOfBitsUsed(vehicleHandlingsRpcs[vehicleid], usedBytes);
            BS_SetReadOffset(vehicleHandlingsRpcs[vehicleid], 16);
#pragma warning push
#pragma warning disable 206 // warning 206: redundant test: constant expression is non-zero
            while (1) {
#pragma warning pop
                new unreadBits;
                BS_GetNumberOfUnreadBits(vehicleHandlingsRpcs[vehicleid], unreadBits);
                if (unreadBits < 8 + 8 + (4 * 8)) {
                    break;
                }
                new HandlingEntry:entryId;
                BS_ReadUint8(vehicleHandlingsRpcs[vehicleid], _:entryId);
                if (entryId == entry) {
                    new readOffset;
                    BS_GetReadOffset(vehicleHandlingsRpcs[vehicleid], readOffset);
                    BS_SetWriteOffset(vehicleHandlingsRpcs[vehicleid], readOffset);
                    BS_WriteUint8(vehicleHandlingsRpcs[vehicleid], _:addMode);
                    BS_WriteFloat(vehicleHandlingsRpcs[vehicleid], value);
                    replaced = 1;
                    break;
                }
                BS_IgnoreBits(vehicleHandlingsRpcs[vehicleid], 8 + 4 * 8);
            }
            BS_SetWriteOffset(vehicleHandlingsRpcs[vehicleid], usedBytes);
            if (!replaced) {
                BS_WriteUint8(vehicleHandlingsRpcs[vehicleid], _:entry);
                BS_WriteUint8(vehicleHandlingsRpcs[vehicleid], _:addMode);
                BS_WriteFloat(vehicleHandlingsRpcs[vehicleid], value);
            }
            BS_ResetReadPointer(vehicleHandlingsRpcs[vehicleid]);
            BroadcastVehicleHandling(vehicleid);
            return 1;
        }

        stock SetVehicleHandlingInt(const vehicleid, const HandlingEntry:entry, const value) {
            if (GetVehicleModel(vehicleid) == 0) return 0;
            if (GetHandlingEntryType(entry) != HANDLING_TYPE_INT) return 0;

            if (!IsVehicleHandlingModified(vehicleid)) {
                vehicleHandlingsRpcs[vehicleid] = BS_New();
                BS_WriteUint16(vehicleHandlingsRpcs[vehicleid], vehicleid);
            }
            new replaced = 0;
            new usedBytes;
            BS_GetNumberOfBitsUsed(vehicleHandlingsRpcs[vehicleid], usedBytes);
            BS_SetReadOffset(vehicleHandlingsRpcs[vehicleid], 16);
#pragma warning push
#pragma warning disable 206 // warning 206: redundant test: constant expression is non-zero
            while (1) {
#pragma warning pop
                new unreadBits;
                BS_GetNumberOfUnreadBits(vehicleHandlingsRpcs[vehicleid], unreadBits);
                if (unreadBits < 8 + 8 + (4 * 8)) {
                    break;
                }
                new HandlingEntry:entryId;
                BS_ReadUint8(vehicleHandlingsRpcs[vehicleid], _:entryId);
                if (entryId == entry) {
                    new readOffset;
                    BS_GetReadOffset(vehicleHandlingsRpcs[vehicleid], readOffset);
                    BS_SetWriteOffset(vehicleHandlingsRpcs[vehicleid], readOffset);
                    BS_WriteUint8(vehicleHandlingsRpcs[vehicleid], _:HANDLING_ADD_NONE);
                    BS_WriteInt32(vehicleHandlingsRpcs[vehicleid], value);
                    replaced = 1;
                    break;
                }
                BS_IgnoreBits(vehicleHandlingsRpcs[vehicleid], 8 + 4 * 8);
            }
            BS_SetWriteOffset(vehicleHandlingsRpcs[vehicleid], usedBytes);
            if (!replaced) {
                BS_WriteUint8(vehicleHandlingsRpcs[vehicleid], _:entry);
                BS_WriteUint8(vehicleHandlingsRpcs[vehicleid], _:HANDLING_ADD_NONE);
                BS_WriteInt32(vehicleHandlingsRpcs[vehicleid], value);
            }
            BS_ResetReadPointer(vehicleHandlingsRpcs[vehicleid]);
            BroadcastVehicleHandling(vehicleid);
            return 1;
        }

        stock IsVehicleHandlingTypeModified(const vehicleid, const HandlingEntry:entry) {
            if (GetVehicleModel(vehicleid) == 0) return 0;
            if (!IsVehicleHandlingModified(vehicleid)) return 0;
            new usedBytes;
            BS_GetNumberOfBitsUsed(vehicleHandlingsRpcs[vehicleid], usedBytes);
            BS_SetReadOffset(vehicleHandlingsRpcs[vehicleid], 16);
#pragma warning push
#pragma warning disable 206 // warning 206: redundant test: constant expression is non-zero
            while (1) {
#pragma warning pop
                new unreadBits;
                BS_GetNumberOfUnreadBits(vehicleHandlingsRpcs[vehicleid], unreadBits);
                if (unreadBits < 8 + 8 + (4 * 8)) {
                    break;
                }
                new HandlingEntry:entryId;
                BS_ReadUint8(vehicleHandlingsRpcs[vehicleid], _:entryId);
                if (entryId == entry) {
                    return 1;
                }
                BS_IgnoreBits(vehicleHandlingsRpcs[vehicleid], 8 + 4 * 8);
            }
            return 0;
        }

        stock ResetVehicleHandling(const vehicleid) {
            if (!IsVehicleHandlingModified(vehicleid)) return 0;
            if (GetVehicleModel(vehicleid) != 0) {
                BS_SetWriteOffset(vehicleHandlingsRpcs[vehicleid], 16);
                BS_WriteUint8(vehicleHandlingsRpcs[vehicleid], _:HANDLING_RESET);
                BS_WriteUint8(vehicleHandlingsRpcs[vehicleid], 0);
                BS_WriteInt32(vehicleHandlingsRpcs[vehicleid], 0);
                BroadcastVehicleHandling(vehicleid);
            }
            BS_Delete(vehicleHandlingsRpcs[vehicleid]);
            return 1;
        }



        stock BroadcastVehicleHandling(const vehicleid, const onlyplayerid = INVALID_PLAYER_ID) {
            if (!IsVehicleHandlingModified(vehicleid)) return 0;
            if (onlyplayerid != INVALID_PLAYER_ID) {
                PR_SendRPC(vehicleHandlingsRpcs[vehicleid], onlyplayerid, VEHICLE_HANDLING_RPC_ID);
            } else {
                PR_SendRPCToVehicleStream(vehicleHandlingsRpcs[vehicleid], vehicleid, VEHICLE_HANDLING_RPC_ID);
            }
            return 1;
        }

        forward SendVehicleHandling(const playerid, const vehicleid);
        public SendVehicleHandling(const playerid, const vehicleid) {
            BroadcastVehicleHandling(vehicleid, playerid);
            return 1;
        }

        ORPC:WORLDVEHADD_RPC_PAWN(playerid, BitStream:bs) {
            new vehicleid;

            BS_ReadUint16(bs, vehicleid);
            SetTimerEx("SendVehicleHandling", 500, false, "ii", playerid, vehicleid);
            return 1;
        }
    #endif // !defined __cplusplus
#endif // HANDLING_INC_

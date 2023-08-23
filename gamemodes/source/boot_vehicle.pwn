stock use_boot(playerid, v, inva, useinva)
{
 	if(!IsABoot(v)) return boot_close(playerid), tabs_close(playerid, 2), OnlineInfo[playerid][oShowInterfaceVeh] = 9999, Tabs_Type[playerid] = 0;
 	
 	new Float:Boot[3], Float:Bonnet[3];
 	GetCoordBonnetVehicle(v, Bonnet[0], Bonnet[1], Bonnet[2]);
	GetCoordBootVehicle(v, Boot[0], Boot[1], Boot[2]);
	if(IsABootFront(v))
	{
		if(!IsPlayerInRangeOfPoint(playerid, 1.0, Bonnet[0], Bonnet[1], Bonnet[2])) return boot_close(playerid), tabs_close(playerid, 2), OnlineInfo[playerid][oShowInterfaceVeh] = 9999, Tabs_Type[playerid] = 0;
	}
	else
	{
		if(!IsPlayerInRangeOfPoint(playerid, 1.0, Boot[0], Boot[1], Boot[2])) return boot_close(playerid), tabs_close(playerid, 2), OnlineInfo[playerid][oShowInterfaceVeh] = 9999, Tabs_Type[playerid] = 0;
	}
	if((v == LichCarID[playerid] || v == LichMotoID[playerid]) && GetPlayerVip(playerid) > 0) {}
	else
	{
		if(VehInfo[v][vCarLock] >= 1) return boot_close(playerid), tabs_close(playerid, 2), OnlineInfo[playerid][oShowInterfaceVeh] = 9999, Tabs_Type[playerid] = 0;
	}

 	new fpick = VehInfo[v][vInvent][inva], fquan = VehInfo[v][vInv][inva], thingPara = VehInfo[v][vInvPara][inva], thingQara = VehInfo[v][vInvQara][inva], thingType = VehInfo[v][vInvType][inva], thingPack = VehInfo[v][vInvPack][inva];
 	if(useinva != 9999)
	{
 		if(PlayerInfo[playerid][pInven][useinva] != VehInfo[v][vInvent][inva] && PlayerInfo[playerid][pInven][useinva] != 0) return i_resettabs(playerid);
	}
	if(fpick == 0) return 1;
	
	if(thingPack == 4) return ErrorMessage(playerid, "{FF6347}пїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ\n\nпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅ пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅ"), i_resettabs(playerid);
	else if(thingPack == 2) // пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅ
	{
	    if(OnlineInfo[playerid][oInHandThing] >= 1 || Hand[playerid] >= 1 || Hold[playerid] >= 1 || GetPlayerWeapon(playerid) >= 2) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ ]"), i_resettabs(playerid);
	    
	    if(IsHelmet(fpick)) thingPara = 3; // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ 3 пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
        if(IsArmor(fpick)) thingPara = 100; // пїЅпїЅпїЅпїЅпїЅ 100 пїЅпїЅ

        OnlineInfo[playerid][oInHandThing][0] = fpick; // ID пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
        OnlineInfo[playerid][oInHandThing][1] = fquan; // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
        OnlineInfo[playerid][oInHandThing][2] = thingPara; // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
        OnlineInfo[playerid][oInHandThing][3] = thingQara; // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
        OnlineInfo[playerid][oInHandThing][4] = thingType; // пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
        OnlineInfo[playerid][oInHandThing][5] = 2; // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ

	    ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,1,1,1,1,1);
	    PPP15[playerid] = 3, RemovePlayerAttachedObject(playerid,1);
	    SetPlayerAttachedObject(playerid,1 , 3014, 6, 0.120000, 0.199448, -0.120000, 254.000000, 0.900000, 70.000000);
	    i_resettabs(playerid);
	    TakeBoot(v, fpick, fquan, thingType, inva);
	    return 1;
	}
	else if(thingType == 0 && thingPack == 0)
	{
	    if(CheckThingQuan(fpick) == 1)
		{
		    DP[0][playerid] = inva;
		    format(store,sizeof(store),"{cccccc}пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ {ff9000}%s {cccccc}пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ\n\nпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ 1 пїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ 1.000.000",GetNameThing(0, fpick, thingType, thingPack));
			ShowDialog(playerid,896,DIALOG_STYLE_INPUT,"{ff9000}пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ",store,"пїЅпїЅпїЅпїЅпїЅпїЅпїЅ","пїЅпїЅпїЅпїЅпїЅпїЅ");
			return 1;
		}
		if(fpick == 35) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
		{
		    new para1 = get_boot(v, 35);
		    if(IsOnline(para1))
		    {
	    		format(store, sizeof(store), "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ %s", playername(para1));
				SetPlayerChatBubble(playerid,store,COLOR_PURPLE,20.0,5000);
				format(store, sizeof(store), "* %s пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ %s", playername(playerid), playername(para1));
				ProxDetector(20.0, playerid, store, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	    		GameTextForPlayer(para1, RusToGame("~g~пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ"), 7000, 4);
	    		EjectBoot(para1, v);
		    }
		    else ErrorMessage(playerid, "{FF6347}пїЅпїЅпїЅпїЅпїЅпїЅ! пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ"), TakeBoot(v, fpick, fquan, thingType, inva), VehInfo[v][vPeople] = 0;
			i_resettabs(playerid);
			return 1;
		}
		else if(fpick == 36) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ (пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ)
       	{
       	    if(OnlineInfo[playerid][oInHandThing] >= 1 || Hand[playerid] >= 1 || Hold[playerid] >= 1 || GetPlayerWeapon(playerid) >= 2) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ ]"), i_resettabs(playerid);
       		ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,1,1,1,1,1);
        	SetPVarInt(playerid,"Arobsklad",11);
        	SetPlayerAttachedObject(playerid, 1, 19054, 6, 0.013999, 0.184000, -0.201000, -100.799942, -9.799992, -11.000021, 0.333000, 0.306999, 0.322000, 0, 0);
        	TakeBoot(v, fpick, fquan, thingType, inva);
        	if(JobStat[playerid] >= 1)
        	{
        	    new randhouse = JobStat[playerid];
        		SetPVarInt(playerid,"GP",1);
				PlayerPlaySound(playerid,6400,0,0,0);
        		SetPlayerCheckpoint(playerid,DomInfo[randhouse][dKoordinatX],DomInfo[randhouse][dKoordinatY],DomInfo[randhouse][dKoordinatZ],2.0);
			}
			i_resettabs(playerid);
			return 1;
		}
	}
	
	i_resettabs(playerid);
	i_resetveshi(playerid);
	// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ (пїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅ)
	if(IsHelmet(fpick) && thingType == 2 && (PlayerInfo[playerid][pOdet][0] == fpick || PlayerInfo[playerid][pOdet][1] == fpick || PlayerInfo[playerid][pOdet][2] == fpick || PlayerInfo[playerid][pOdet][3] == fpick || PlayerInfo[playerid][pOdet][4] == fpick)) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ");
	if(IsArmor(fpick) && thingType == 2 && PlayerInfo[playerid][pArmor] >= 1) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ");

	// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	if(JustOneThingInventory(fpick, thingType) && get_invent(playerid, fpick, thingType) > 0) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ");
	
	if(thingType == 0)
	{
	    if(CheckThingQuan(fpick) == 1)
		{
			new getQuan, getLimit;
    		i_limit(playerid, fpick, getQuan, getLimit);
    		if(getQuan+fquan > getLimit) return format(store,sizeof(store),"{FF6347}пїЅ пїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ\nпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ: %d\n\n{cccccc}пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", getLimit), ErrorMessage(playerid, store);
 		}
	}

	new put_inva = GiveThingPlayer(playerid, fpick, fquan, thingPara, thingQara, thingType, thingPack, useinva);
	if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ"); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ -1 пїЅ пїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ
    TakeBoot(v, fpick, fquan, thingType, inva);

    SaveInvent(playerid, put_inva); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ, пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ

    format(store,sizeof(store),"пїЅпїЅпїЅпїЅ пїЅпїЅ %s: %s", vehName[VehInfo[v][vModel]], GetNameThing(1, fpick, thingType, thingPack));
	UserLog("getboot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fquan, store);
	return 1;
}
stock put_boot(playerid, inva, v, fpick, fquan, binva, thingType, thingPack)
{
    new put_inva = -1;
	if(OnlineInfo[playerid][oShowInterface] != 1 || binva == 9999 || OnlineInfo[playerid][oInventSelectLeft] == 9999 || v == INVALID_VEHICLE_ID || !IsABoot(v)
	|| PlayerInfo[playerid][pInven][inva] <= 0 || PlayerInfo[playerid][pInven][inva] != fpick || PlayerInfo[playerid][pInvenQuan][inva] < fquan) return 1;
	
	if(fpick == 48 && thingType == 0 && OnlineInfo[playerid][oInflatableBoat] != NON) return ErrorMessage(playerid, "{FF6347}пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ"), i_resetveshi(playerid);
    if(NotGiveThing(fpick, thingType)) return ErrorMessage(playerid, "{FF6347}пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ"), i_resetveshi(playerid);
    if((v == LichCarID[playerid] || v == LichMotoID[playerid]) && GetPlayerVip(playerid) > 0) {}
	else
	{
		if(VehInfo[v][vCarLock] >= 1) return ErrorMessage(playerid, "{FF6347}пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ"), i_resetveshi(playerid);
	}
    new Float:Boot[3], Float:Bonnet[3];
	GetCoordBonnetVehicle(v, Bonnet[0], Bonnet[1], Bonnet[2]);
	GetCoordBootVehicle(v, Boot[0], Boot[1], Boot[2]);
	if(IsPlayerInRangeOfPoint(playerid, 1.0, Boot[0], Boot[1], Boot[2]) && !IsABootFront(v) || IsPlayerInRangeOfPoint(playerid, 1.0, Bonnet[0], Bonnet[1], Bonnet[2]) && IsABootFront(v))
	{
	    if(VehInfo[v][vUpgrade] == 0) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
		{
			if(IsA_Gen5(v) && binva >= 5) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ [ Y >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]"), i_resetveshi(playerid);

			if(IsA_Gen10(v) && binva >= 10) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ [ Y >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]"), i_resetveshi(playerid);

		 	if(IsA_Gen15(v) && binva >= 15) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ [ Y >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]"), i_resetveshi(playerid);
		}
	
	    new quanThing;
		if(thingType == 0)
		{
			if(CheckThingQuan(fpick) == 1)
			{
			    if(VehInfo[v][vInvent][binva] != 0 && VehInfo[v][vInvent][binva] != PlayerInfo[playerid][pInven][inva]) return ErrorMessage(playerid, "{FF6347}пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ"), i_resetveshi(playerid);
			    if(thingPack == 0) quanThing = 1;
			    if(PlayerInfo[playerid][pInvenQuan][inva] < fquan) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ"), i_resetveshi(playerid);
			    new getQuan, getLimit;
			    v_limit(v, fpick, getQuan, getLimit);
			    if(getQuan+fquan > getLimit)
			    {
			        format(store,sizeof(store),"{FF6347}пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ\n\nпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ: %d", getLimit);
			        ErrorMessage(playerid, store);
					i_resetveshi(playerid);
					i_resettabs(playerid);
					return 1;
			    }
			}
		}
		if(VehInfo[v][vInvent][binva] > 0 && quanThing == 0) return ErrorMessage(playerid, "{FF6347}пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ"), i_resetveshi(playerid);

		put_inva = put_thing_boot(v, fpick, fquan, PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenQara][inva], thingType, thingPack, binva);
		if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ"), i_resetveshi(playerid); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ -1 пїЅ пїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ

		if(quanThing == 1) take_away(playerid, fquan, inva); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ (пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ)
	 	else i_del(playerid, inva); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ (пїЅпїЅпїЅпїЅпїЅпїЅпїЅ)
	 	SaveInvent(playerid, inva); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ

		format(store,sizeof(store),"пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ %d: %s", GetNameThing(1, fpick, thingType, thingPack));
		UserLog("putboot", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", fquan, store);

		i_resetveshi(playerid);
		i_resettabs(playerid);
    }
	else ErrorMessage(playerid, "{FF6347}пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ");
	return put_inva;
}
stock PutThingBoot(v, thingId, quan, para, qara, thingType, thingPack, useinva) // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
{
    new inva = -1;
	if(thingId == 0) return inva; // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ (0 - пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ)
	
	if(useinva == 999) // пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	{
	    if(thingType == 0) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ
		{
		    if(CheckThingQuan(thingId) == 1) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ (пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ)
		    {
		        new find;
		    	for(new i = 0; i < 20; i++)
				{
					if(VehInfo[v][vInvent][i] == thingId && VehInfo[v][vInvType][i] == thingType) // пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ, пїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
					{
					    inva = i;
		  				put_thing_boot(v, thingId, quan, para, 0, thingType, thingPack, i); // qara 0 - пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
		  				find = 1;
			   			break;
					}
				}
				if(find == 0) // пїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
				{
					for(new i = 0; i < 20; i++)
					{
						if(VehInfo[v][vInvent][i] == 0) // пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
						{
						    inva = i;
			  				put_thing_boot(v, thingId, quan, para, 0, thingType, thingPack, i); // qara 0 - пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
				   			break;
						}
					}
				}
			}
			else if(CheckThingQuan(thingId) == 0) // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
			{
			    for(new i = 0; i < 20; i++)
				{
					if(VehInfo[v][vInvent][i] == 0) // пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
					{
					    inva = i;
		  				put_thing_boot(v, thingId, quan, para, qara, thingType, thingPack, i);
			   			break;
					}
				}
			}
		}
		else // пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
		{
		    for(new i = 0; i < 20; i++)
			{
				if(VehInfo[v][vInvent][i] == 0) // пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
				{
				    inva = i;
	  				put_thing_boot(v, thingId, quan, para, qara, thingType, thingPack, i);
		   			break;
				}
			}
		}
	}
	else inva = put_thing_boot(v, thingId, quan, para, qara, thingType, thingPack, useinva); // пїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
	return inva;
}
stock put_thing_boot(v, thingId, quan, para, qara, thingType, thingPack, i)
{
	if(VehInfo[v][vInvent][i] != 0 && VehInfo[v][vInvent][i] != thingId) return -1; // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ

	if(VehInfo[v][vSost] > 0 && qara == VehInfo[v][vSost]) qara = 0; // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ

	VehInfo[v][vInvent][i] = thingId; // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ
	VehInfo[v][vInv][i] += quan; // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅ

	// (пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ, Unix пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ ID пїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ)
	if(PerishableThing(thingId, thingType)) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ - пїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ Unix (пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ)
	{
	    if(VehInfo[v][vInvPara][i] > 0)
		{
			if(VehInfo[v][vInvPara][i] > para) VehInfo[v][vInvPara][i] = para;
		}
		else VehInfo[v][vInvPara][i] = para;
	}
	else VehInfo[v][vInvPara][i] = para;
	VehInfo[v][vInvQara][i] = qara; // пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	VehInfo[v][vInvType][i] = thingType; // пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	VehInfo[v][vInvPack][i] = thingPack; // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

	if(thingId != 35) SaveOneBoot(v, i);
	foreach(Player,x)
	{
		if(OnlineInfo[x][oLogged] == 1 && OnlineInfo[x][oShowInterface] == 1 && OnlineInfo[x][oShowInterfaceVeh] == v) item_second(x, thingId, VehInfo[v][vInv][i], i, 0, VehInfo[v][vInvPara][i], thingType, thingPack, 0);
	}
	return i;
}
stock TakeBoot(veh, stat, kolvo, thingType, dopinf)
{
	new plalit;
	if(dopinf == 999)
	{
		for(new inva = 0; inva < 20; inva++)
		{
			if(VehInfo[veh][vInvent][inva] == stat && VehInfo[veh][vInvType][inva] == thingType)
			{
				if(VehInfo[veh][vInv][inva]-kolvo <= 0) VehInfo[veh][vInvent][inva] = 0, VehInfo[veh][vInv][inva] = 0, VehInfo[veh][vInvPara][inva] = 0, VehInfo[veh][vInvQara][inva] = 0, VehInfo[veh][vInvType][inva] = 0, VehInfo[veh][vInvPack][inva] = 0;
				else VehInfo[veh][vInv][inva] -= kolvo;
				plalit = inva;
				break;
			}
		}
	}
	else
	{
		if(VehInfo[veh][vInvent][dopinf] == stat && VehInfo[veh][vInvType][dopinf] == thingType)
		{
			if(VehInfo[veh][vInv][dopinf]-kolvo <= 0) VehInfo[veh][vInvent][dopinf] = 0, VehInfo[veh][vInv][dopinf] = 0, VehInfo[veh][vInvPara][dopinf] = 0, VehInfo[veh][vInvQara][dopinf] = 0, VehInfo[veh][vInvType][dopinf] = 0, VehInfo[veh][vInvPack][dopinf] = 0;
			else VehInfo[veh][vInv][dopinf] -= kolvo;
		}
		plalit = dopinf;
	}
	SaveOneBoot(veh, plalit);
	foreach(Player,i)
	{
		if(OnlineInfo[i][oLogged] == 1 && OnlineInfo[i][oShowInterface] == 1 && OnlineInfo[i][oShowInterfaceVeh] == veh) item_second(i, VehInfo[veh][vInvent][plalit], VehInfo[veh][vInv][plalit], plalit, 0, VehInfo[veh][vInvPara][plalit], VehInfo[veh][vInvType][plalit], VehInfo[veh][vInvPack][plalit], 0);
	}
	return 1;
}
stock mix_boot(playerid, v, getinva, putinva) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
{
	if(OnlineInfo[playerid][oShowInterfaceVeh] != 9999)
	{
		if(VehInfo[v][vInvent][getinva] == 0) return i_resettabs(playerid);
		else if(VehInfo[v][vInvent][putinva] != VehInfo[v][vInvent][getinva]) return i_resettabs(playerid);
		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
		    if(OnlineInfo[playerid][oShowInterfaceVeh] != OnlineInfo[i][oShowInterfaceVeh]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
			format(store, sizeof(store), "{FF6347}пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ %d пїЅпїЅпїЅ. [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]", quanPlayer-1);
			ErrorMessage(playerid, store);
			i_resettabs(playerid);
			return 1;
		}
		VehInfo[v][vInv][putinva] += VehInfo[v][vInv][getinva];
		if(VehInfo[v][vInvPara][putinva] > VehInfo[v][vInvPara][getinva]) VehInfo[v][vInvPara][putinva] = VehInfo[v][vInvPara][getinva];
		VehInfo[v][vInvent][getinva] = 0;
		VehInfo[v][vInv][getinva] = 0;
		VehInfo[v][vInvPara][getinva] = 0;
		VehInfo[v][vInvQara][getinva] = 0;
		VehInfo[v][vInvType][getinva] = 0;
		VehInfo[v][vInvPack][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, VehInfo[v][vInvent][getinva], VehInfo[v][vInv][getinva], getinva, 0, VehInfo[v][vInvPara][getinva], VehInfo[v][vInvType][getinva], VehInfo[v][vInvPack][getinva], 0);
		item_second(playerid, VehInfo[v][vInvent][putinva], VehInfo[v][vInv][putinva], putinva, 0, VehInfo[v][vInvPara][putinva], VehInfo[v][vInvType][putinva], VehInfo[v][vInvPack][putinva], 0);
		SaveOneBoot(v, getinva);
		SaveOneBoot(v, putinva);
	}
	return 1;
}
stock shift_boot(playerid, v, getinva, putinva) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ (пїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ)
{
	if(OnlineInfo[playerid][oShowInterfaceVeh] != 9999)
	{
		if(VehInfo[v][vInvent][getinva] == 0) return i_resettabs(playerid);
		else if(VehInfo[v][vInvent][putinva] != 0) return 1;
		new quanPlayer;
		foreach(Player,i)
		{
		    if(OnlineInfo[i][oLogged] == 0) continue;
		    if(OnlineInfo[i][oShowInterface] != 1) continue;
		    if(OnlineInfo[playerid][oShowInterfaceVeh] != OnlineInfo[i][oShowInterfaceVeh]) continue;
			quanPlayer ++;
		}
		if(quanPlayer >= 2)
		{
		    format(store, sizeof(store), "{FF6347}пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ %d пїЅпїЅпїЅ. [ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]", quanPlayer-1);
			ErrorMessage(playerid, store);
			i_resettabs(playerid);
			return 1;
		}
		if(VehInfo[v][vUpgrade] == 0)
		{
			if(IsA_Gen5(v) && putinva >= 5) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ [ Y >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]"), i_resetveshi(playerid);
			if(IsA_Gen10(v) && putinva >= 10) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ [ Y >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]"), i_resetveshi(playerid);
		 	if(IsA_Gen15(v) && putinva >= 15) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ [ Y >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]"), i_resetveshi(playerid);
		}
		VehInfo[v][vInvent][putinva] = VehInfo[v][vInvent][getinva];
		VehInfo[v][vInv][putinva] = VehInfo[v][vInv][getinva];
		VehInfo[v][vInvPara][putinva] = VehInfo[v][vInvPara][getinva];
		VehInfo[v][vInvQara][putinva] = VehInfo[v][vInvQara][getinva];
		VehInfo[v][vInvType][putinva] = VehInfo[v][vInvType][getinva];
		VehInfo[v][vInvPack][putinva] = VehInfo[v][vInvPack][getinva];
		VehInfo[v][vInvent][getinva] = 0;
		VehInfo[v][vInv][getinva] = 0;
		VehInfo[v][vInvPara][getinva] = 0;
		VehInfo[v][vInvQara][getinva] = 0;
		VehInfo[v][vInvType][getinva] = 0;
		VehInfo[v][vInvPack][getinva] = 0;
		i_resettabs(playerid);
		item_second(playerid, 0, 0, getinva, 0, 0, 0, 0, 0);
		item_second(playerid, VehInfo[v][vInvent][putinva], VehInfo[v][vInv][putinva], putinva, 0, VehInfo[v][vInvPara][putinva], VehInfo[v][vInvType][putinva], VehInfo[v][vInvPack][putinva], 0);
		SaveOneBoot(v, getinva);
		SaveOneBoot(v, putinva);
	}
	return 1;
}
stock put_bootbox(playerid, v) // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
{
	if(OnlineInfo[playerid][oInHandThing][0] > 0 && OnlineInfo[playerid][oInHandThing][5] == 2)
	{
	    new put_inva = PutThingBoot(v, OnlineInfo[playerid][oInHandThing][0], OnlineInfo[playerid][oInHandThing][1], OnlineInfo[playerid][oInHandThing][2], OnlineInfo[playerid][oInHandThing][3], OnlineInfo[playerid][oInHandThing][4], OnlineInfo[playerid][oInHandThing][5], 999);
	    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ");
	    
	    InHandClear(playerid);
		SetPlayerChatBubble(playerid,"пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ",COLOR_PURPLE,20.0,3000);
		RemovePlayerAttachedObject(playerid,1), PPP15[playerid] = 0;
   		ClearAnimations(playerid);
   		ClearAnim(playerid);
   		PlayerPlaySound(playerid,1053,0,0,0);
	}
	else ErrorMessage(playerid, "{FF6347}пїЅ пїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ {cccccc}[ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ: N >> пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ]");
	return 1;
}
stock item_boot(playerid, v, fpick, fquan, inva, fpara, thingType, thingPack)
{
    inva = inva+20;
	if(fpick == 0)
	{
		new blocker = 0;
		if(VehInfo[v][vUpgrade] == 1) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]), PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
		else
		{
   			if(IsA_Gen5(v))
		 	{
		 		if(inva <= 24) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]), PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
  				else blocker = 1;
   			}
		 	else if(IsA_Gen10(v))
		 	{
		 		if(inva <= 29) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]), PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
		 		else blocker = 1;
		 	}
		 	else if(IsA_Gen15(v))
		 	{
		 		if(inva <= 34) PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]), PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
		 		else blocker = 1;
		 	}
		 	else PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]), PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
		}
		if(blocker == 1)
		{
			PlayerTextDrawSetPreviewModel(playerid, PlaNestPick[inva][playerid], 2485);
			PlayerTextDrawSetPreviewRot(playerid, PlaNestPick[inva][playerid], 0.0, 0.0, 0.0, -1.0);
			PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], 150);
			PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], 60);
			PlayerTextDrawBoxColor(playerid, PlaNestPick[inva][playerid], 0);
			PlayerTextDrawFont(playerid, PlaNestPick[inva][playerid], 5);
		}
	 	else if(blocker == 0) PlayerTextDrawFont(playerid, PlaNestPick[inva][playerid], 4);
	 	PlayerTextDrawShow(playerid, PlaNestPick[inva][playerid]);
	}
	else
	{
		new string[28], yesFindModel;
		PlayerTextDrawBackgroundColor(playerid, PlaNestPick[inva][playerid], PlayerInfo[playerid][pStyle1]);
		PlayerTextDrawColor(playerid, PlaNestPick[inva][playerid], -1);
		PlayerTextDrawBoxColor(playerid, PlaNestPick[inva][playerid], 0);
		PlayerTextDrawFont(playerid, PlaNestPick[inva][playerid], 5);
		
		if(thingPack == 1) yesFindModel = 19054; // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ
		else if(thingPack == 2) yesFindModel = 3014; // пїЅпїЅпїЅпїЅ
		else if(thingPack == 3) yesFindModel = 2060; // пїЅпїЅпїЅпїЅпїЅ
		else if(thingPack == 0) // пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
		{
			if(thingType == 0) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ
			{
			    yesFindModel = friskPick[fpick];
				if(CheckThingQuan(fpick) == 1) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
				{
					format(string, sizeof(string), "%d", fquan);
					PlayerTextDrawSetString(playerid, PlaNestPickNum[inva][playerid], string);
					if(PlayerInfo[playerid][pSty] == 6 || PlayerInfo[playerid][pSty] == 11) PlayerTextDrawColor(playerid, PlaNestPickNum[inva][playerid], 673720575);
					else PlayerTextDrawColor(playerid, PlaNestPickNum[inva][playerid], -1);
	  				PlayerTextDrawShow(playerid, PlaNestPickNum[inva][playerid]);
				}
			}
			if(thingType == 1) // пїЅпїЅпїЅпїЅпїЅпїЅ
			{
			    yesFindModel = friskGun[fpick];
			    if(fpara <= 0)
			    {
			    	if(fpick == 25 || fpick == 26 || fpick == 27) yesFindModel = 2034;
			    	else if(fpick == 22 || fpick == 24) yesFindModel = 2034;
			    	else if(fpick == 30 || fpick == 31) yesFindModel = 2035;
			        else if(fpick == 33 || fpick == 34) yesFindModel = 2036;
			    }
			}
			if(thingType == 2) yesFindModel = fpick; // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
		 	if(thingType == 3) yesFindModel = fpick; // пїЅпїЅпїЅпїЅпїЅпїЅ
			if(thingType == 4) yesFindModel = fpick; // пїЅпїЅпїЅпїЅпїЅпїЅ
		}
		
		if(yesFindModel > 0)
		{
		    new Float:modelPos[4], findIt;
			GetModelTextDraw(yesFindModel, modelPos[0], modelPos[1], modelPos[2], modelPos[3], findIt);
			PlayerTextDrawSetPreviewModel(playerid, PlaNestPick[inva][playerid], yesFindModel);
			PlayerTextDrawSetPreviewRot(playerid, PlaNestPick[inva][playerid], modelPos[0], modelPos[1], modelPos[2], modelPos[3]);
		}
	}
	PlayerTextDrawShow(playerid, PlaNestPick[inva][playerid]);
	return 1;
}
stock SaveBoot(v) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
{
    if(Cars[v] == 88 || Cars[v] == 99)
	{
		if(VehInfo[v][vDatabase] >= 1 && VehInfo[v][vDatabase] <= 5)
		{
			format(big_query,sizeof(big_query),"UPDATE `pp_cars` SET `Inven1` = '%d', `InvenKol1` = '%d', `InvenPara1` = '%d', `InvenQara1` = '%d', `InvenType1` = '%d', `InvenPack1` = '%d'",
			VehInfo[v][vInvent][0], VehInfo[v][vInv][0], VehInfo[v][vInvPara][0], VehInfo[v][vInvQara][0], VehInfo[v][vInvType][0], VehInfo[v][vInvPack][0]);

			for(new i = 1; i < 20; i++) format(big_query,sizeof(big_query),"%s, `Inven%d` = '%d', `InvenKol%d` = '%d', `InvenPara%d` = '%d', `InvenQara%d` = '%d', `InvenType%d` = '%d', `InvenPack%d` = '%d'", big_query,
			i+1, VehInfo[v][vInvent][i], i+1, VehInfo[v][vInv][i], i+1, VehInfo[v][vInvPara][i], i+1, VehInfo[v][vInvQara][i], i+1, VehInfo[v][vInvType][i], i+1, VehInfo[v][vInvPack][i]);

		    format(big_query,sizeof(big_query),"%s WHERE `newid` = '%d'", big_query, VehInfo[v][vNewid]);
			query_empty(pearsq, big_query);
		}
	}
	return 1;
}
stock SaveOneBoot(veh, inva) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
{
    if(Cars[veh] == 88 || Cars[veh] == 99)
	{
		if(VehInfo[veh][vDatabase] >= 1 && VehInfo[veh][vDatabase] <= 5)
		{
			format(big_query, sizeof(big_query), "UPDATE `pp_cars` SET `Inven%d`='%d',`InvenKol%d`='%d',`InvenPara%d`='%d',`InvenQara%d`='%d',`InvenType%d`='%d',`InvenPack%d`='%d' WHERE `newid`='%d'",
			inva+1,VehInfo[veh][vInvent][inva], inva+1,VehInfo[veh][vInv][inva], inva+1,VehInfo[veh][vInvPara][inva], inva+1,VehInfo[veh][vInvQara][inva], inva+1,VehInfo[veh][vInvType][inva], inva+1,VehInfo[veh][vInvPack][inva], VehInfo[veh][vNewid]);
			query_empty(pearsq, big_query);
		}
	}
	return 1;
}
stock IsABoot(carid) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
{
	new model=GetVehicleModel(carid);
	if(model == 400 || model == 401 || model == 402 || model == 404 || model == 405 || model == 409 || model == 410 || model == 411 || model == 412 || model == 413
    || model == 415 || model == 418 || model == 419 || model == 420 || model == 421 || model == 422 || model == 426 || model == 429 || model == 433 || model == 434 || model == 436
    || model == 438 || model == 439 || model == 440 || model == 442 || model == 444 || model == 445 || model == 451 || model == 458 || model == 459 || model == 466 || model == 467
    || model == 470 || model == 474 || model == 475 || model == 477 || model == 479 || model == 480 || model == 483 || model == 489 || model == 490 || model == 491
    || model == 492 || model == 494 || model == 495 || model == 496 || model == 498 || model == 500 || model == 502 || model == 503 || model == 504 || model == 505 || model == 506
    || model == 507 || model == 516 || model == 517 || model == 518 || model == 526 || model == 527 || model == 528 || model == 529 || model == 533 || model == 534 || model == 535
    || model == 536 || model == 540 || model == 541 || model == 542 || model == 543 || model == 545 || model == 546 || model == 547 || model == 549 || model == 550 || model == 551
    || model == 554 || model == 555 || model == 556 || model == 557 || model == 558 || model == 559 || model == 560 || model == 561 || model == 562 || model == 565 || model == 566
    || model == 567 || model == 573 || model == 575 || model == 576 || model == 579 || model == 580 || model == 585 || model == 587 || model == 589 || model == 596 || model == 597
    || model == 598 || model == 599 || model == 600 || model == 601 || model == 602 || model == 603 || model == 604 || model == 605 || model == 609){return 1;}
	return 0;
}
stock v_limit(v, thingId, &getQuan, &getLimit) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ
{
	new lim[INVENTER];
	for(new i = 0; i < INVENTER; i++) lim[i] = 1;
	lim[8] = 100, lim[19] = 100, lim[41] = 1000, lim[25] = 1000000; // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅ 1пїЅпїЅ
	lim[4] = 10000, lim[5] = 10000, lim[6] = 10000, lim[7] = 10000, lim[9] = 20, lim[18] = 1000, lim[20] = 10000, lim[27] = 10000, lim[28] = 10000, lim[29] = 10000, lim[30] = 10000;
	lim[46] = 100, lim[47] = 100, lim[55] = 100, lim[60] = 1000, lim[61] = 100, lim[64] = 1000, lim[65] = 1000, lim[66] = 1000, lim[67] = 1000, lim[71] = 100;
	lim[72] = 100, lim[73] = 100, lim[74] = 100, lim[75] = 100, lim[76] = 100, lim[77] = 100, lim[78] = 100, lim[79] = 100, lim[80] = 100, lim[81] = 100;
	lim[82] = 100, lim[83] = 100, lim[84] = 100, lim[85] = 100, lim[86] = 100, lim[87] = 100, lim[88] = 100, lim[89] = 1000, lim[106] = 100, lim[108] = 100, lim[109] = 100, lim[110] = 100;
	lim[140] = 1000, lim[141] = 1000, lim[142] = 100;

    getQuan = get_boot(v, thingId);
    getLimit = lim[thingId];
	return 1;
}
stock get_boot(v, stat) // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
{
	new kolvo = 0, yes = 0;
	for(new inva = 0; inva < 20; inva++)
	{
		if(VehInfo[v][vInvent][inva] == stat && VehInfo[v][vInvType][inva] == 0) kolvo += VehInfo[v][vInv][inva], yes = 1;
	}
	if(yes == 1) return kolvo;
	else return -1;
}
stock get_boot2(v, stat, inva) // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
{
	if(VehInfo[v][vInvent][inva] == stat && VehInfo[v][vInvType][inva] == 0)
	{
		return VehInfo[v][vInv][inva];
	}
	else return -1;
}
stock ClearBootVehcile(v, i)
{
    VehInfo[v][vInvent][i] = 0;
	VehInfo[v][vInv][i] = 0;
	VehInfo[v][vInvPara][i] = 0;
	VehInfo[v][vInvQara][i] = 0;
	VehInfo[v][vInvType][i] = 0;
    VehInfo[v][vInvPack][i] = 0;
	return 1;
}
stock CheckBoot(v)
{
	if(VehInfo[v][vUpgrade] == 1)
	{
		if(VehInfo[v][vInvent][0] >= 1 && VehInfo[v][vInvent][1] >= 1 && VehInfo[v][vInvent][2] >= 1 && VehInfo[v][vInvent][3] >= 1 && VehInfo[v][vInvent][4] >= 1
		&& VehInfo[v][vInvent][5] >= 1 && VehInfo[v][vInvent][6] >= 1 && VehInfo[v][vInvent][7] >= 1 && VehInfo[v][vInvent][8] >= 1 && VehInfo[v][vInvent][9] >= 1
		&& VehInfo[v][vInvent][10] >= 1 && VehInfo[v][vInvent][11] >= 1 && VehInfo[v][vInvent][12] >= 1 && VehInfo[v][vInvent][13] >= 1 && VehInfo[v][vInvent][14] >= 1
		&& VehInfo[v][vInvent][15] >= 1 && VehInfo[v][vInvent][16] >= 1 && VehInfo[v][vInvent][17] >= 1 && VehInfo[v][vInvent][18] >= 1 && VehInfo[v][vInvent][19] >= 1) return 1;
	}
	else if(IsA_Gen5(v) && VehInfo[v][vUpgrade] == 0)
	{
	    if(VehInfo[v][vInvent][0] >= 1 && VehInfo[v][vInvent][1] >= 1 && VehInfo[v][vInvent][2] >= 1 && VehInfo[v][vInvent][3] >= 1 && VehInfo[v][vInvent][4] >= 1) return 1;
 	}
 	else if(IsA_Gen10(v) && VehInfo[v][vUpgrade] == 0)
	{
	    if(VehInfo[v][vInvent][0] >= 1 && VehInfo[v][vInvent][1] >= 1 && VehInfo[v][vInvent][2] >= 1 && VehInfo[v][vInvent][3] >= 1 && VehInfo[v][vInvent][4] >= 1
		&& VehInfo[v][vInvent][5] >= 1 && VehInfo[v][vInvent][6] >= 1 && VehInfo[v][vInvent][7] >= 1 && VehInfo[v][vInvent][8] >= 1 && VehInfo[v][vInvent][9] >= 1) return 1;
 	}
 	else if(IsA_Gen15(v) && VehInfo[v][vUpgrade] == 0)
	{
	    if(VehInfo[v][vInvent][0] >= 1 && VehInfo[v][vInvent][1] >= 1 && VehInfo[v][vInvent][2] >= 1 && VehInfo[v][vInvent][3] >= 1 && VehInfo[v][vInvent][4] >= 1
		&& VehInfo[v][vInvent][5] >= 1 && VehInfo[v][vInvent][6] >= 1 && VehInfo[v][vInvent][7] >= 1 && VehInfo[v][vInvent][8] >= 1 && VehInfo[v][vInvent][9] >= 1
		&& VehInfo[v][vInvent][10] >= 1 && VehInfo[v][vInvent][11] >= 1 && VehInfo[v][vInvent][12] >= 1 && VehInfo[v][vInvent][13] >= 1 && VehInfo[v][vInvent][14] >= 1) return 1;
 	}
 	else
 	{
		if(VehInfo[v][vInvent][0] >= 1 && VehInfo[v][vInvent][1] >= 1 && VehInfo[v][vInvent][2] >= 1 && VehInfo[v][vInvent][3] >= 1 && VehInfo[v][vInvent][4] >= 1
		&& VehInfo[v][vInvent][5] >= 1 && VehInfo[v][vInvent][6] >= 1 && VehInfo[v][vInvent][7] >= 1 && VehInfo[v][vInvent][8] >= 1 && VehInfo[v][vInvent][9] >= 1
		&& VehInfo[v][vInvent][10] >= 1 && VehInfo[v][vInvent][11] >= 1 && VehInfo[v][vInvent][12] >= 1 && VehInfo[v][vInvent][13] >= 1 && VehInfo[v][vInvent][14] >= 1
		&& VehInfo[v][vInvent][15] >= 1 && VehInfo[v][vInvent][16] >= 1 && VehInfo[v][vInvent][17] >= 1 && VehInfo[v][vInvent][18] >= 1 && VehInfo[v][vInvent][19] >= 1) return 1;
	}
	return 0;
}
new buttonName[][] = // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
{
    "пїЅпїЅпїЅ", "H"
};

new MindTimer[MAX_REALPLAYERS];

new Text:MindDraw[5]; // пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
new PlayerText:HintButton; // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

new PlayerText:MindDraw1; //  пїЅпїЅпїЅпїЅпїЅ (пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ)
new PlayerText:MindDraw2; // пїЅпїЅпїЅпїЅпїЅ (пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ)

forward SendMindMessage(playerid, const text[], const texttwo[]);
public SendMindMessage(playerid, const text[], const texttwo[]) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
{
	if(OnlineInfo[playerid][oMind])
	{
		KillTimer(MindTimer[playerid]);
		PlayerTextDrawHide(playerid, MindDraw1), PlayerTextDrawHide(playerid, MindDraw2);
	}
	OnlineInfo[playerid][oMind] = true;
	MindTimer[playerid] = SetTimerEx("DelMind", 7000, false, "d", playerid); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ 7 пїЅпїЅпїЅпїЅпїЅпїЅ
	TextDrawShowForPlayer(playerid, MindDraw[0]);
	TextDrawShowForPlayer(playerid, MindDraw[1]);
	TextDrawShowForPlayer(playerid, MindDraw[2]);

	format(store, sizeof(store), "%s",text);
	PlayerTextDrawSetString(playerid, MindDraw1, store);
	PlayerTextDrawShow(playerid, MindDraw1);

	format(store, sizeof(store), "%s",texttwo);
	PlayerTextDrawSetString(playerid, MindDraw2, store);
	PlayerTextDrawShow(playerid, MindDraw2);
	return 1;
}

forward DelMind(playerid);
public DelMind(playerid) // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
{
    KillTimer(MindTimer[playerid]);
    ClearMind(playerid);
    return 1;
}
stock ClearMind(playerid)
{
    OnlineInfo[playerid][oMind] = false;
    PlayerTextDrawHide(playerid, MindDraw1);
    PlayerTextDrawHide(playerid, MindDraw2);
    TextDrawHideForPlayer(playerid, MindDraw[0]);
	TextDrawHideForPlayer(playerid, MindDraw[1]);
	TextDrawHideForPlayer(playerid, MindDraw[2]);
	return 1;
}
stock CreateGlobalTextDrawMind()
{
	MindDraw[0] = TextDrawCreate(434.666687, 129.422195, "LD_POOL:ball"); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ
	TextDrawLetterSize(MindDraw[0], 0.000000, 0.000000);
	TextDrawTextSize(MindDraw[0], 92.666671, 109.096328);
	TextDrawAlignment(MindDraw[0], 1);
	TextDrawColor(MindDraw[0], -156);
	TextDrawSetShadow(MindDraw[0], 0);
	TextDrawSetOutline(MindDraw[0], 0);
	TextDrawFont(MindDraw[0], 4);

	MindDraw[1] = TextDrawCreate(452.333404, 97.651802, "LD_POOL:ball"); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	TextDrawLetterSize(MindDraw[1], 0.000000, 0.000000);
	TextDrawTextSize(MindDraw[1], 21.666664, 26.133358);
	TextDrawAlignment(MindDraw[1], 1);
	TextDrawColor(MindDraw[1], -156);
	TextDrawSetShadow(MindDraw[1], 0);
	TextDrawSetOutline(MindDraw[1], 0);
	TextDrawFont(MindDraw[1], 4);

	MindDraw[2] = TextDrawCreate(470.333404, 72.933288, "LD_POOL:ball"); // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	TextDrawLetterSize(MindDraw[2], 0.000000, 0.000000);
	TextDrawTextSize(MindDraw[2], 14.666664, 17.422246);
	TextDrawAlignment(MindDraw[2], 1);
	TextDrawColor(MindDraw[2], -156);
	TextDrawSetShadow(MindDraw[2], 0);
	TextDrawSetOutline(MindDraw[2], 0);
	TextDrawFont(MindDraw[2], 4);
	return 1;
}
stock CreateGlobalTextDrawHintButton()
{
	MindDraw[3] = TextDrawCreate(144.333404, 408.763122, "PRESS:");
	TextDrawLetterSize(MindDraw[3], 0.327999, 1.351111);
	TextDrawAlignment(MindDraw[3], 1);
	TextDrawColor(MindDraw[3], -2139062017);
	TextDrawSetShadow(MindDraw[3], 1);
	TextDrawSetOutline(MindDraw[3], 0);
	TextDrawBackgroundColor(MindDraw[3], 51);
	TextDrawFont(MindDraw[3], 1);
	TextDrawSetProportional(MindDraw[3], 1);

	MindDraw[4] = TextDrawCreate(443.666809, 78.655654, "usebox");
	TextDrawLetterSize(MindDraw[4], 0.000000, 1.888684);
	TextDrawTextSize(MindDraw[4], 475.333312, 0.000000);
	TextDrawAlignment(MindDraw[4], 1);
	TextDrawColor(MindDraw[4], 0);
	TextDrawUseBox(MindDraw[4], true);
	TextDrawBoxColor(MindDraw[4], 45);
	TextDrawSetShadow(MindDraw[4], 0);
	TextDrawSetOutline(MindDraw[4], 0);
	TextDrawFont(MindDraw[4], 0);
	return 1;
}

// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
stock SuccessMessage(playerid, const string[])
{
	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{99ff66}*",string,"*",""), PlayerPlaySound(playerid,6401,0,0,0);
	return 1;
}
stock ErrorMessage(playerid, const string[])
{
	ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ff0000}*",string,"*",""), PlayerPlaySound(playerid,4203,0,0,0);
	return 1;
}
stock ErrorText(playerid, const string[])
{
	SendClientMessage(playerid, COLOR_GREY, string), PlayerPlaySound(playerid,4203,0,0,0);
	return 1;
}

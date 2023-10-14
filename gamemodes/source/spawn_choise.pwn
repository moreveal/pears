
#define MAX_SPAWNDRAWCHOISE 13

new Text:SpawnChoiseDraw[MAX_SPAWNDRAWCHOISE];

CMD:textdrawchoise(playerid)
{
    if(server != 0) return 1;
    for(new i = 0; i < MAX_SPAWNDRAWCHOISE; i++) TextDrawShowForPlayer(playerid, SpawnChoiseDraw[i]);
    return 1;
}

stock CreateDrawSpawnChoise()
{
    new Float:tempX, Float:tempY;
    new Float:sizeX, Float:sizeY;

    // End Position
    SpawnChoiseDraw[0] = TextDrawCreate(159.0, 155.0, "LD_SPAC:white");
    TextDrawLetterSize(SpawnChoiseDraw[0], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[0], 70.000000, 130.0); // 35
    TextDrawAlignment(SpawnChoiseDraw[0], 1);
    TextDrawColor(SpawnChoiseDraw[0], 421075440);
    TextDrawSetShadow(SpawnChoiseDraw[0], 0);
    TextDrawSetOutline(SpawnChoiseDraw[0], 0);
    TextDrawFont(SpawnChoiseDraw[0], 4);
    TextDrawSetSelectable(SpawnChoiseDraw[0], true);

    TextDrawGetPos(SpawnChoiseDraw[0], tempX, tempY);
    TextDrawGetTextSize(SpawnChoiseDraw[0], sizeX, sizeY);

    SpawnChoiseDraw[1] = TextDrawCreate((tempX + sizeX / 2) -  22.5, 185.0, "LD_SPAC:white");
    TextDrawBackgroundColor(SpawnChoiseDraw[1], 0);
    TextDrawLetterSize(SpawnChoiseDraw[1], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[1], 43.000000, 48.0);
    TextDrawAlignment(SpawnChoiseDraw[1], 1);
    TextDrawColor(SpawnChoiseDraw[1], -1);
    TextDrawUseBox(SpawnChoiseDraw[1], true);
    TextDrawBoxColor(SpawnChoiseDraw[1], 0);
    TextDrawSetShadow(SpawnChoiseDraw[1], 0);
    TextDrawSetOutline(SpawnChoiseDraw[1], 0);
    TextDrawFont(SpawnChoiseDraw[1], 5);
    TextDrawSetPreviewModel(SpawnChoiseDraw[1], 1277);
    TextDrawSetPreviewRot(SpawnChoiseDraw[1], 0.000000, 0.000000, 180.000000, 1.000000);

    SpawnChoiseDraw[2] = TextDrawCreate(tempX + sizeX / 2, 268.0, "ЊOC‡EѓHEE MECЏO");
    TextDrawLetterSize(SpawnChoiseDraw[2], 0.204666, 0.907259);
    TextDrawAlignment(SpawnChoiseDraw[2], 2);
    TextDrawColor(SpawnChoiseDraw[2], -1061109505);
    TextDrawSetShadow(SpawnChoiseDraw[2], 1);
    TextDrawSetOutline(SpawnChoiseDraw[2], 0);
    TextDrawBackgroundColor(SpawnChoiseDraw[2], 51);
    TextDrawFont(SpawnChoiseDraw[2], 1);
    TextDrawSetProportional(SpawnChoiseDraw[2], 1);

    // Organization
    SpawnChoiseDraw[3] = TextDrawCreate(243.0, 155.0, "LD_SPAC:white");
    TextDrawLetterSize(SpawnChoiseDraw[3], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[3], 70.000000, 130.0); // 35
    TextDrawAlignment(SpawnChoiseDraw[3], 1);
    TextDrawColor(SpawnChoiseDraw[3], 421075440);
    TextDrawSetShadow(SpawnChoiseDraw[3], 0);
    TextDrawSetOutline(SpawnChoiseDraw[3], 0);
    TextDrawFont(SpawnChoiseDraw[3], 4);
    TextDrawSetSelectable(SpawnChoiseDraw[3], true);

    TextDrawGetPos(SpawnChoiseDraw[3], tempX, tempY);
    TextDrawGetTextSize(SpawnChoiseDraw[3], sizeX, sizeY);

    SpawnChoiseDraw[4] = TextDrawCreate((tempX + sizeX / 2) -  22.5, 185.0, "LD_SPAC:white");
    TextDrawBackgroundColor(SpawnChoiseDraw[4], 0);
    TextDrawLetterSize(SpawnChoiseDraw[4], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[4], 43.000000, 48.0);
    TextDrawAlignment(SpawnChoiseDraw[4], 1);
    TextDrawColor(SpawnChoiseDraw[4], -1);
    TextDrawUseBox(SpawnChoiseDraw[4], true);
    TextDrawBoxColor(SpawnChoiseDraw[4], 0);
    TextDrawSetShadow(SpawnChoiseDraw[4], 0);
    TextDrawSetOutline(SpawnChoiseDraw[4], 0);
    TextDrawFont(SpawnChoiseDraw[4], 5);
    TextDrawSetPreviewModel(SpawnChoiseDraw[4], 1275);
    TextDrawSetPreviewRot(SpawnChoiseDraw[4], 0.000000, 0.000000, 180.000000, 1.000000);

    SpawnChoiseDraw[5] = TextDrawCreate(tempX + sizeX / 2, 268.0, "OP‚AH…3A‰…•");
    TextDrawLetterSize(SpawnChoiseDraw[5], 0.204666, 0.907259);
    TextDrawAlignment(SpawnChoiseDraw[5], 2);
    TextDrawColor(SpawnChoiseDraw[5], -1061109505);
    TextDrawSetShadow(SpawnChoiseDraw[5], 1);
    TextDrawSetOutline(SpawnChoiseDraw[5], 0);
    TextDrawBackgroundColor(SpawnChoiseDraw[5], 51);
    TextDrawFont(SpawnChoiseDraw[5], 1);
    TextDrawSetProportional(SpawnChoiseDraw[5], 1);

    // Home
    SpawnChoiseDraw[6] = TextDrawCreate(327.000000, 155.0, "LD_SPAC:white"); // Home
    TextDrawLetterSize(SpawnChoiseDraw[6], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[6], 70.000000, 130.0); // 35
    TextDrawAlignment(SpawnChoiseDraw[6], 1);
    TextDrawColor(SpawnChoiseDraw[6], 421075440);
    TextDrawSetShadow(SpawnChoiseDraw[6], 0);
    TextDrawSetOutline(SpawnChoiseDraw[6], 0);
    TextDrawFont(SpawnChoiseDraw[6], 4);
    TextDrawSetSelectable(SpawnChoiseDraw[6], true);

    TextDrawGetPos(SpawnChoiseDraw[6], tempX, tempY);
    TextDrawGetTextSize(SpawnChoiseDraw[6], sizeX, sizeY);

    SpawnChoiseDraw[7] = TextDrawCreate((tempX + sizeX / 2) -  22.5, 185.0, "LD_SPAC:white");
    TextDrawBackgroundColor(SpawnChoiseDraw[7], 0);
    TextDrawLetterSize(SpawnChoiseDraw[7], 1.1, 1.1);
    TextDrawTextSize(SpawnChoiseDraw[7], 43.000000, 48.0);
    TextDrawAlignment(SpawnChoiseDraw[7], 1);
    TextDrawColor(SpawnChoiseDraw[7], -1);
    TextDrawUseBox(SpawnChoiseDraw[7], true);
    TextDrawBoxColor(SpawnChoiseDraw[7], 0);
    TextDrawSetShadow(SpawnChoiseDraw[7], 0);
    TextDrawSetOutline(SpawnChoiseDraw[7], 0);
    TextDrawFont(SpawnChoiseDraw[7], 5);
    TextDrawSetPreviewModel(SpawnChoiseDraw[7], 1273);
    TextDrawSetPreviewRot(SpawnChoiseDraw[7], 0.000000, 0.000000, 180.000000, 1.000000);

    SpawnChoiseDraw[8] = TextDrawCreate(tempX + sizeX / 2, 268.0, "ѓOM");
    TextDrawLetterSize(SpawnChoiseDraw[8], 0.204666, 0.907259);
    TextDrawAlignment(SpawnChoiseDraw[8], 2);
    TextDrawColor(SpawnChoiseDraw[8], -1061109505);
    TextDrawSetShadow(SpawnChoiseDraw[8], 1);
    TextDrawSetOutline(SpawnChoiseDraw[8], 0);
    TextDrawBackgroundColor(SpawnChoiseDraw[8], 51);
    TextDrawFont(SpawnChoiseDraw[8], 1);
    TextDrawSetProportional(SpawnChoiseDraw[8], 1);

    // Family
    SpawnChoiseDraw[9] = TextDrawCreate(411.0, 155.0, "LD_SPAC:white");
    TextDrawLetterSize(SpawnChoiseDraw[9], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[9], 70.000000, 130.0); // 35
    TextDrawAlignment(SpawnChoiseDraw[9], 1);
    TextDrawColor(SpawnChoiseDraw[9], 421075440);
    TextDrawSetShadow(SpawnChoiseDraw[9], 0);
    TextDrawSetOutline(SpawnChoiseDraw[9], 0);
    TextDrawFont(SpawnChoiseDraw[9], 4);
    TextDrawSetSelectable(SpawnChoiseDraw[9], true);

    TextDrawGetPos(SpawnChoiseDraw[9], tempX, tempY);
    TextDrawGetTextSize(SpawnChoiseDraw[9], sizeX, sizeY);

    SpawnChoiseDraw[10] = TextDrawCreate((tempX + sizeX / 2) -  22.5, 185.0, "LD_SPAC:white");
    TextDrawBackgroundColor(SpawnChoiseDraw[10], 0);
    TextDrawLetterSize(SpawnChoiseDraw[10], 1.0, 1.0);
    TextDrawTextSize(SpawnChoiseDraw[10], 43.000000, 48.0);
    TextDrawAlignment(SpawnChoiseDraw[10], 1);
    TextDrawColor(SpawnChoiseDraw[10], -1);
    TextDrawUseBox(SpawnChoiseDraw[10], true);
    TextDrawBoxColor(SpawnChoiseDraw[10], 0);
    TextDrawSetShadow(SpawnChoiseDraw[10], 0);
    TextDrawSetOutline(SpawnChoiseDraw[10], 0);
    TextDrawFont(SpawnChoiseDraw[10], 5);
    TextDrawSetPreviewModel(SpawnChoiseDraw[10], 1314);
    TextDrawSetPreviewRot(SpawnChoiseDraw[10], 0.000000, 0.000000, 180.000000, 1.000000);

    SpawnChoiseDraw[11] = TextDrawCreate(tempX + sizeX / 2, 268.0, "CEM’•");
    TextDrawLetterSize(SpawnChoiseDraw[11], 0.204666, 0.907259);
    TextDrawAlignment(SpawnChoiseDraw[11], 2);
    TextDrawColor(SpawnChoiseDraw[11], -1061109505);
    TextDrawSetShadow(SpawnChoiseDraw[11], 1);
    TextDrawSetOutline(SpawnChoiseDraw[11], 0);
    TextDrawBackgroundColor(SpawnChoiseDraw[11], 51);
    TextDrawFont(SpawnChoiseDraw[11], 1);
    TextDrawSetProportional(SpawnChoiseDraw[11], 1);

    SpawnChoiseDraw[12] = TextDrawCreate(320.0, 318.0, "‹‘ЂEP…ЏE CЊA‹H ‹AЋE‚O ЊEPCOHA„A");
    TextDrawLetterSize(SpawnChoiseDraw[12], 0.354000, 1.471407);
    TextDrawAlignment(SpawnChoiseDraw[12], 2);
    TextDrawColor(SpawnChoiseDraw[12], -1);
    TextDrawSetShadow(SpawnChoiseDraw[12], 1);
    TextDrawSetOutline(SpawnChoiseDraw[12], 0);
    TextDrawBackgroundColor(SpawnChoiseDraw[12], 51);
    TextDrawFont(SpawnChoiseDraw[12], 1);
    TextDrawSetProportional(SpawnChoiseDraw[12], 1);
    return 1;
}
stock opencase(playerid,para)
{   
    new fpick;
    new quan = 1;
    new thingType = 0;
    if(para <= 0 || para >= 5) return ErrorMessage(playerid,"Слушай, кейс поломан, параметр не в границе массива");
    else if (para == 1)
    {
        switch(random(10))
        {
            case 0..4: fpick = 1;
            case 5..9: fpick = 4, quan = 2;
        }
    }
    else if (para == 2)
    {
        switch(random(10))
        {
            case 0..4: fpick = 1;
            case 5..9: fpick = 4;
        }
    }
    else if (para == 3)
    {
        switch(random(10))
        {
            case 0..4: fpick = 1;
            case 5..9: fpick = 4;
        }
    }
    else if (para == 4)
    {
        switch(random(10))
        {
            case 0..4: fpick = 1;
            case 5..9: fpick = 4;
        }
    }
    new put_inva = GiveThingPlayer(playerid, fpick, quan, 0,thingType, 0, 9999);
	if(put_inva == -1)
    {
        Throw(playerid, fpick, quan, 0,thingType, 0,);
        format(store,sizeof(store),"{ffcc66}В кейсе был: %d %s. \nУ вас нет места в инвентаре и предмет упал на землю",quan, friskName[fpick]);
	    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",store,"*","");
    }
}

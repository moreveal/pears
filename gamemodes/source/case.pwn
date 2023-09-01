/*
Добавляем кейс, Указываем параметры рандома, условно:
case 0..1 - Значит шанс равен 2%
case 2..99 - Значит шанс равен 98%

fpick - Оставляем ноль если выдаем предмет не в инвентарь
quan - Оставляем один если выдаем один предмет.

*/

stock opencase(playerid,para,slot)
{   
    if(get_invent(playerid,189,0) < 1) return ErrorMessage(playerid,"Нет Кейса в инвентаре");
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
    TakeInvent(playerid, 189, 1, 0, slot);
    if(fpick > 0)
    {
        new put_inva = GiveThingPlayer(playerid, fpick, quan, 0,0, thingType, 0, 9999);
        if(put_inva == -1)
        {
            Throw(playerid, fpick, quan, 0, 0, thingType, 0);
            format(store,sizeof(store),"{ffcc66}В кейсе был: %d %s. \nУ вас нет места в инвентаре и предмет упал на землю",quan, friskName[fpick]);
            ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",store,"*","");
        }
    } 
    else if(fpick == 0)
    {

    }
    return 1;   
}

CMD:givecase(playerid, const params[])
{
    if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не администратор");
    if(sscanf(params, "iii",params[0],params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выдать предмет в инвентарь [ ID ]");
    
    new put_inva = GiveThingPlayer(params[0], 189, 1, params[1], 0, 0, 0, 9999);
    if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У игрока нет места в инвентаре");
	return 1;
}

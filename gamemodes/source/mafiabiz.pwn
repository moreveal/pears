
#define MAFIA_BABKI 2

CMD:mafiabiz(playerid)
{
    PlayerPlaySound(playerid,40405,0,0,0);
    DP[0][playerid] = 0;
    ShowMafiaBiz(playerid, 1, 50);
 	return 1;
}

stock ShowMafiaBiz(playerid, mina, maxa)
{
	new stro[184], sctringo[3600];
    PlayerPlaySound(playerid,40405,0,0,0);
    format(stro,sizeof(stro),"{444444}Далее >>\n"), strcat(sctringo,stro);
    for(new b = mina; b <= maxa; b++)
	{
		if(BizzInfo[b][bMafia] >= 1) format(stro,sizeof(stro),"{ff9000}№ %d {cccccc}| Под Контролем: %s\n", b, frakName[BizzInfo[b][bMafia]]), strcat(sctringo,stro);
		else format(stro,sizeof(stro),"{ff9000}№ %d {cccccc}| Свободен\n", b), strcat(sctringo,stro);
    }
    format(stro,sizeof(stro),"{444444}Далее >>"), strcat(sctringo,stro);
    if(mina >= 50) ShowDialog(playerid,989,DIALOG_STYLE_LIST,"{ff9000}Рейдерский Захват",sctringo,"Выбрать","Назад");
    else ShowDialog(playerid,989,DIALOG_STYLE_LIST,"{ff9000}Рейдерский Захват",sctringo,"Выбрать","Выход");
}

stock InfoMafiaBiz(playerid, b)
{
	new str[100],sctring[400];
	new tyear, tmonth, tday, thour, tminute, tsecond;
	stamp2datetime(BizzInfo[b][bMafunix], tyear, tmonth, tday, thour, tminute, tsecond, 3);
 	format(str,sizeof(str),"\n\n{444444}Бизнес {ff9000}%s [%d]", bizname(b), b), strcat(sctring,str);
 	format(str,sizeof(str),"\n\n{cccccc}Владелец: %s",BizzInfo[b][bVlad]), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}Под контролем: %s", frakName[BizzInfo[b][bMafia]]), strcat(sctring,str);
 	format(str,sizeof(str),"\n{cccccc}Доля с дохода за крышевание: {ffffff}%d %%", MAFIA_BABKI), strcat(sctring,str);
    format(str,sizeof(str),"\n{cccccc}Денег в бизнесе: {44ff99}%d$",BizzInfo[b][bMafiaSchet]), strcat(sctring,str);
 	if(BizzInfo[b][bMafunix] >= 1) format(str,sizeof(str),"\n{cccccc}Дата и время захвата: [ %02d.%02d.%d %02d:%02d ]\n\n", tday, tmonth, tyear, thour, tminute), strcat(sctring,str);
 	else format(str,sizeof(str),"\n{cccccc}Дата и время захвата: {ffffff}Передан администрацией\n\n"), strcat(sctring,str);
	ShowDialog(playerid,990,DIALOG_STYLE_MSGBOX,"{ff9000}Рейдерский Захват",sctring,"Ок","");
}

stock TakeMoneyMafiaBiz(playerid,b)
{
    new string[80];
    new g = fraction(playerid);
    if(BizzInfo[b][bMafia] != g) return ErrorMessage(playerid,"{ff6347}Ваша мафия не крышует этот бизнес");
    if(BizzInfo[b][bMafiaSchet] < 10000) return ErrorMessage(playerid,"{ff6347}В сейфе бизнеса не накопилось 10.000$, вернитесь позже.\nПосмотреть деньги на счете бизнеса можно командой [ /mafiabiz ]");
    bigint_add(OrganInfo[g][glave], BizzInfo[b][bMafiaSchet]);
    OrganInfo[g][gUpdate] = 1;

    SuccessMessage(playerid,"{44ff99}Вы успешно забрали деньги мафии\n{cccccc}Деньги начислены на счет вашей мафии");
    GiveUnit(playerid,18);

    format(string, sizeof(string), "Взял деньги [%d$] за крышевания с бизнеса %d", BizzInfo[b][bMafiaSchet],b);
    OrgLog(g, "takemoneymafiabiz", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, string);

    BizzInfo[b][bMafiaSchet] = 0;
    BizzInfo[b][bUpdate] = 1;

    return 1;
}

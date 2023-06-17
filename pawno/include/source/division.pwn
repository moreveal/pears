
#define MAX_DIVISION_ORG 10 // Максимальное количество подфракций в организациях

enum divInfo
{
    divRanks, // Максимальное количество рангов
    divName[34], // Название
    divAbbreviation[9], // Аббревиатура
    Float:divSpawnPos[4], // Координаты спавна
    divSpawnWorld, // Вирт мира спавна
    divSpawnInterior, // Interior спавна
    divColorHex[7] // Цвет подфракции (никнеймов игроков)
};
new DivisionInfo[MAX_ORG][MAX_DIVISION_ORG][divInfo];
//new DivisionRankName[MAX_ORG][MAX_RANK_ORG][34]; // Названия рангов

CMD:setdiv(playerid) // Команда управления подфракциями
{
	if(PlayerInfo[playerid][pLeader] == 0) return ErrorMessage(playerid, "{FF6347}Вы не лидер организации");

    PlayerPlaySound(playerid,1150,0,0,0);
    showDialogSetdiv(playerid);
	return 1;
}
stock showDialogSetdiv(playerid) // Меню всех подфракций
{
    new g = fraction(playerid);
	format(lines,sizeof(lines),""); // Очищаем Lines

    format(line,sizeof(line),"ID\tНазвание\tАббревиатура"), strcat(lines,line);
    for(new i = 0; i < MAX_DIVISION_ORG; i++)
	{
        format(line,sizeof(line),"\n%d.\t%s\t%s", i+1, DivisionInfo[g][i][divName], DivisionInfo[g][i][divAbbreviation]), strcat(lines,line);
    }
	ShowDialog(playerid,1315,DIALOG_STYLE_TABLIST_HEADERS,"Управление Подфракциями",lines,"Выбрать","Отмена");
    return 1;
}

/*CMD:div(playerid) return cmd_division(playerid);
CMD:division(playerid)
{
	new g = fraction(playerid);
	if(g == 0) return ErrorMessage(playerid, "{FF6347}Ваш персонаж не состоит в организации");

	PlayerPlaySound(playerid,1150,0,0,0);
	format(lines,sizeof(lines),""); // Очищаем Lines

    format(line,sizeof(line),"Участники\n"), strcat(lines,line);
    format(line,sizeof(line),"Участники\n"), strcat(lines,line);

	format(str,sizeof(str), detail_lmenu(playerid, 1)), strcat(sctring,str);  // Информация
	format(str,sizeof(str), detail_lmenu(playerid, 2)), strcat(sctring,str); // Участники Online
	format(str,sizeof(str), detail_lmenu(playerid, 3)), strcat(sctring,str); // Участники Offline
	format(str,sizeof(str), detail_lmenu(playerid, 4)), strcat(sctring,str); // Статус набора
	format(str,sizeof(str), detail_lmenu(playerid, 5)), strcat(sctring,str); // Переводы на счет
	format(str,sizeof(str), detail_lmenu(playerid, 7)), strcat(sctring,str); // Названия рангов
	format(str,sizeof(str), detail_lmenu(playerid, 8)), strcat(sctring,str); // Лог
	format(str,sizeof(str), detail_lmenu(playerid, 10)), strcat(sctring,str); // Черный список
	if(IsAGang(playerid) || IsAMafia(playerid))
	{
	    format(str,sizeof(str), detail_lmenu(playerid, 6)), strcat(sctring,str); // Дипломатия
	    format(str,sizeof(str), detail_lmenu(playerid, 9)), strcat(sctring,str); // Управление гаражем
	}
	format(str,sizeof(str), detail_lmenu(playerid, 12)), strcat(sctring,str); // Настройки склада
	if(PlayerInfo[playerid][pLeader] >= 1)
	{
		format(str,sizeof(str), detail_lmenu(playerid, 11)), strcat(sctring,str); // Права доступа
		format(str,sizeof(str), detail_lmenu(playerid, 13)), strcat(sctring,str); // Настройки оплаты
	}
	new lol[64];
	format(lol,sizeof(lol),"{cccccc}Меню: %s",fraklastName[g]);
	ShowDialog(playerid,615,DIALOG_STYLE_LIST,lol,sctring,"Выбрать","Отмена");
	return 1;
}*/

#define MAX_DONATE_SERVICE 13

new donatePrice[MAX_DONATE_SERVICE];

// Активация Скидки
stock discount()
{
	for(new i = 0; i < MAX_DONATE_SERVICE; i++)
    {
        if(donatePrice[i] > 0)
        {
            donatePrice[i] = donatePrice[i]-(donatePrice[i]/100*ServerInfo[55]);
        }
    }
}

// Установка ценников на донаты
stock defaultPriceDonate()
{
    donatePrice[0] = 6; // Временная VIP (стоимость 1 день випки)
    donatePrice[1] = 900; // Premium VIP
    donatePrice[2] = 600; // Создание семьи
    donatePrice[3] = 50; // Сменить ник
    donatePrice[4] = 50; // Занять ник (резервирование никнейма)
    donatePrice[5] = 200; // Сменить номер телефона
    donatePrice[6] = 200; // Снять warn
    donatePrice[7] = 600; // Снять ban
    donatePrice[8] = 8; // Снять мут (стоимость 1 минуты мута)
    donatePrice[9] = 190; // Открыть слот транспорта
    donatePrice[10] = 50; // +1 уровень навыка
    donatePrice[11] = 90; // Максимальное знание языка
    donatePrice[12] = 140; // Стоимость кейса
}

// Меню покупки навыков
stock showDialogDonateSkills(playerid)
{
    new line[214],lines[4096];

	format(line,sizeof(line),"{cccccc}Max Владение Русским Языком \t {ffcc00}[%d G]", donatePrice[11]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Max Владение Японским Языком \t {ffcc00}[%d G]", donatePrice[11]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Max Владение Итальянским Языком \t {ffcc00}[%d G]", donatePrice[11]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Max Владение Китайским Языком \t {ffcc00}[%d G]", donatePrice[11]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Max Владение Испанским Языком \t {ffcc00}[%d G]", donatePrice[11]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Max Владение Арабским Языком \t {ffcc00}[%d G]", donatePrice[11]), strcat(lines,line);
    format(line,sizeof(line),"\n{cccccc}Навык Силы +1 уровень \t {ffcc00}[%d G]", donatePrice[10]), strcat(lines,line);

    // Далее новые навыки
    new quan;
    for(new i = 0; i < MAX_ABILITY; i++)
    {
        List[quan][playerid]= i;
        quan ++;
        format(line,sizeof(line),"\n{cccccc}%s +1 уровень \t {ffcc00}[%d G]", abilityName[i], donatePrice[10]), strcat(lines,line);
    }
    ShowDialog(playerid,509,DIALOG_STYLE_TABLIST,"{ff9000}Donate",lines,"Выбор","Назад");
    return true;
}

stock showDialogConfirmationDonateSkills(playerid, ability)
{
    if(ability < 0 || ability >= MAX_ABILITY) return false; // Защита от несуществующих навыков
    DP[0][playerid] = ability;

    new line[100], lines[300];
    format(line,sizeof(line),"{cccccc}Покупка: {0088ff}%s", abilityName[ability]), strcat(lines,line);
    if(ServerInfo[55] > 0) format(line,sizeof(line),"\n{cccccc}Стоимость: {ffcc00}%dG {ff9000}[ Сегодня скида %d проц. ]", donatePrice[10], ServerInfo[55]), strcat(lines,line);
    else format(line,sizeof(line),"\n{cccccc}Стоимость: {ffcc00}%dG", donatePrice[10]), strcat(lines,line);
    format(line,sizeof(line),"\n\n{ff9000}Вы уверены, что хотите оплатить покупку?"), strcat(lines,line);
    ShowDialog(playerid,856,DIALOG_STYLE_MSGBOX,"{ff9000}Donate",lines,"Да","Нет");
    return true;
}

stock dialogCase_DonateMenu(playerid, dialogid, response, listitem)
{
    if(dialogid == 509)
    {
        if(response)
        {
            // Покупка новых скилов
            if(listitem >= 7) return showDialogConfirmationDonateSkills(playerid, listitem - 7);

		    new atext[100], cena;
			if(listitem == 0) atext = "{cccccc}Владение Русским Языком", DP[0][playerid] = 16, cena = donatePrice[11];
			else if(listitem == 1) atext = "{cccccc}Владение Японским Языком", DP[0][playerid] = 17, cena = donatePrice[11];
			else if(listitem == 2) atext = "{cccccc}Владение Итальянским Языком", DP[0][playerid] = 18, cena = donatePrice[11];
			else if(listitem == 3) atext = "{cccccc}Владение Китайским Языком", DP[0][playerid] = 19, cena = donatePrice[11];
			else if(listitem == 4) atext = "{cccccc}Владение Испанским Языком", DP[0][playerid] = 20, cena = donatePrice[11];
			else if(listitem == 5) atext = "{cccccc}Владение Арабским Языком", DP[0][playerid] = 22, cena = donatePrice[11];
			else if(listitem == 6) atext = "{cccccc}Навык Силы +1 Уровень", DP[0][playerid] = 14, cena = donatePrice[10];

			new str[130],sctring[860];
			format(str,sizeof(str),"{cccccc}Покупка: {0088ff}%s\n", atext), strcat(sctring,str);
			if(ServerInfo[55] > 0) format(str,sizeof(str),"{cccccc}Стоимость: {ffcc00}%dG {ff9000}[ Сегодня скида %d проц. ]\n", cena, ServerInfo[55]), strcat(sctring,str);
			else format(str,sizeof(str),"{cccccc}Стоимость: {ffcc00}%dG\n", cena), strcat(sctring,str);
			format(str,sizeof(str),"\n\n{ff9000}Вы уверены, что хотите оплатить покупку?"), strcat(sctring,str);
			ShowDialog(playerid,852,DIALOG_STYLE_MSGBOX,"{ff9000}Donate",sctring,"Да","Нет");
	    }
        else pc_cmd_donate(playerid);
        return true;
    }
    else if(dialogid == 856)
    {
        if(response)
        {
            new ability = DP[0][playerid];
            if(ability < 0 || ability >= MAX_ABILITY) return false; // Защита от несуществующих навыков

            if(PlayerInfo[playerid][pAbilStat][ability] >= 10) return ErrorText(playerid, "{FF6347}Этот навык максимально прокачен"), showDialogDonateSkills(playerid);
            if(PlayerInfo[playerid][pDonateMoney] < donatePrice[10]) return ErrorText(playerid, "{FF6347}Вам не хватает золота для покупки"), showDialogDonateSkills(playerid);

	    	PlayerInfo[playerid][pDonateMoney] -= donatePrice[10];
			tclArifmetikAllGold -= donatePrice[10];
            mysql_save(playerid, 4);

            new string[200];
            format(string, sizeof(string), "{99ff66}Вы приобрели {ff9000}%s +1 Уровень\
                                            \n{cccccc}Стоимость: {ffcc66}%dG", 
                                            abilityName[ability], donatePrice[10]);
            SuccessMessage(playerid, string);

            new maxAbility = getability_max(PlayerInfo[playerid][pAbility][ability]);
            PlayerInfo[playerid][pAbility][ability] = maxAbility;
            update_ability(playerid, ability, 1);

            DonateLog("buyability",PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", -donatePrice[10], abilityName[ability]);
        }
        else showDialogDonateSkills(playerid);
        return true;
    }
    return false;
}

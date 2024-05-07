
// Шифруем пароль для регистрации
forward OnPasswordHashRegister(playerid);
public OnPasswordHashRegister(playerid)
{
	bcrypt_get_hash(PlayerInfo[playerid][pKey]);

	Login[3][playerid] = 1;
    registerhelp(playerid, 1);
	return 1;
}

// Сверяем пароль при логине
forward OnPasswordHashLogin(playerid, bool:success);
public OnPasswordHashLogin(playerid, bool:success)
{
    if (success)
    {
        DialogLoadAccount(playerid, 1);
        OnPlayerLogin(playerid, 0);
    } 
    else
    {
        PlayerPlaySound(playerid,4203,0,0,0);
        gPlayerLogTries[playerid] ++;
        new loginmsg[174];
        format(loginmsg,sizeof(loginmsg),"{cccccc}Привет, {ff9000}%s\n{FF6347}Пароль введён неверно {ff0000}[ %d/3 ]\n\n{cccccc}Если вы забыли пароль, нажмите ESC или Отмена",PlayerInfo[playerid][pName],gPlayerLogTries[playerid]);
        if(PlayerInfo[playerid][pTypoihyi] == 0) ShowDialog(playerid,1,DIALOG_STYLE_PASSWORD,"{ff9000}Авторизация",loginmsg,"Далее","Отмена");
        else ShowDialog(playerid,1,DIALOG_STYLE_INPUT,"{ff9000}Авторизация",loginmsg,"Далее","Отмена");

        if(gPlayerLogTries[playerid] == 3)
        {
            ShowDialog(playerid,1995,DIALOG_STYLE_MSGBOX,"{ff9000}Авторизация",
            "{FF6347}Вы 3 раза ввели неверно пароль и были кикнуты\
            \n\n{cccccc}Забыли пароль?\
            \n{FF6347}Перезайдите и попробуйте восстановить доступ к аккаунту","Ок","");
            Kickx(playerid);
        }
    }
    return 1;
}

// Шифруем пароль при смене пароля
forward OnPasswordHashSetnewpass(playerid, const password[]);
public OnPasswordHashSetnewpass(playerid, const password[])
{
	bcrypt_get_hash(PlayerInfo[playerid][pKey]);

    new string[180];
	SendClientMessage(playerid, COLOR_GREY, "{ffffff}* Ваш новый пароль: {0088ff}%s", password);
	SendClientMessage(playerid, COLOR_GREY, "{ffffff}* Чтобы вы не забыли, новый пароль отправлен на Email {ff9000}%s",PlayerInfo[playerid][pMail]);
	format(string, sizeof(string), "UPDATE `pp_igroki` SET `Key` = '%s' WHERE `user_id` = '%d'", PlayerInfo[playerid][pKey], PlayerInfo[playerid][pID]);
	query_empty(pearsq, string);

	format(string, sizeof(string), "ID аккаунта: %d | Никнейм: %s | Новый пароль: %s", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], password);
	SendMail(PlayerInfo[playerid][pMail], "Смена Пароля", string, PlayerInfo[playerid][pName]);

  	PlayerPlaySound(playerid,6401,0,0,0);
    gPlayerLogged22[playerid] = 0;
	return 1;
}

// Шифруем пароль при vzlom offline
forward OnPasswordHashVzlomOffline(playerid, const str_name[], const password[], user_id, const mail[]);
public OnPasswordHashVzlomOffline(playerid, const str_name[], const password[], user_id, const mail[])
{
    new dest[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(dest);

    new string[180];
	format(string,sizeof(string),"UPDATE `pp_igroki` SET `Key` = '%s' WHERE `Name` = '%s'", dest, str_name);
    query_empty(pearsq, string);

    format(string, sizeof(string), "Администратор %s сгенерировал%s новый пароль для вашего аккаунта. Никнейм: %s | Пароль: %s", 
        PlayerInfo[playerid][pName], gender(playerid), str_name, password);
    SendMail(mail, "Защита Аккаунта", string, str_name);

    format(string, sizeof(string), "[PP]: %s защитил%s аккаунт %s",PlayerInfo[playerid][pName], gender(playerid), str_name);
    AllMessage(COLOR_LIGHTRED, string);

    format(string, sizeof(string), "{FF8282}Игрок Offline | Аккаунт: {FFFFFF}%s {FF8282}| Email: {FFFFFF}%s",str_name,mail);
    ABroadCast(COLOR_YELLOW,string,1);

    AdminLog("vzlom", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], user_id, str_name, "", 0, "");
    work_admin(playerid, 9);
    notify(PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], user_id, str_name, "Аккаунт защищён (новый пароль отправлен на Email)");

    if(serverType == 0) printf("OnPasswordHashVzlomOffline %s %s", str_name, password);
	return 1;
}

// Шифруем пароль при vzlom
forward OnPasswordHashVzlom(playerid, const password[], giveplayerid);
public OnPasswordHashVzlom(playerid, const password[], giveplayerid)
{
    new dest[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(dest);

    new string[180];
    new year, month,day;
    getdate(year, month, day);
    format(string, sizeof(string), "[PP]: %s защитил%s аккаунт %s",PlayerInfo[playerid][pName], gender(playerid), PlayerInfo[giveplayerid][pName]);
    AllMessage(COLOR_LIGHTRED, string);

    format(PlayerInfo[giveplayerid][pKey], 120, dest);

    format(string, sizeof(string), "Администратор %s сгенерировал%s новый пароль для вашего аккаунта. Никнейм: %s | Пароль: %s", 
        PlayerInfo[playerid][pName], gender(playerid), PlayerInfo[giveplayerid][pName], password);
    SendMail(PlayerInfo[giveplayerid][pMail], "Защита Аккаунта", string, PlayerInfo[giveplayerid][pName]);

    // Офаем автологин
    PlayerInfo[giveplayerid][pBdPoletDayz] = 1;
    format(string,sizeof(string),"UPDATE `pp_igroki` SET `Key` = '%s',`BdPoletDayz` = '1' WHERE `user_id` = '%d'",PlayerInfo[giveplayerid][pKey], PlayerInfo[giveplayerid][pID]);
    query_empty(pearsq, string);
    format(string, sizeof(string), "{FF8282}IP: {FFFFFF}%s {FF8282}| Аккаунт: {FFFFFF}%s {FF8282}| Email: {FFFFFF}%s",PlayerInfo[giveplayerid][pPlaIP],PlayerInfo[giveplayerid][pName],PlayerInfo[giveplayerid][pMail]);
    ABroadCast(COLOR_YELLOW,string,1);
    SendClientMessage(giveplayerid,COLOR_LIGHTRED, "Этот аккаунт защитил администратор %s из-за возможного Взлома (%d-%d-%d)", PlayerInfo[playerid][pName],day,month,year);
    SendClientMessage(giveplayerid,COLOR_LIGHTRED, "Пароль аккаунта изменён и отправлен на Email: {FFFFFF}%s", PlayerInfo[giveplayerid][pMail]);
    SendClientMessage(giveplayerid,COLOR_LIGHTRED, "Администрация приносит извинения, если это была ошибка. Сохранение аккаунта каждого игрока, для нас превышего всего!");
    SendClientMessage(giveplayerid,COLOR_LIGHTRED, "Если вы по каким-либо причинам, не можете узнать новый пароль, отправленный на Email, свяжитесь с администрацией!");
    SendClientMessage(giveplayerid,COLOR_LIGHTRED, "{ff0000}Обязательно сделайте в данный момент Screenshot [ Кнопка: F8 ]");
    format(string, sizeof(string),"{00cc00}Этот аккаунт защитил администратор %s (%d-%d-%d)\n{0088ff}из-за возможного Взома\n{0088ff}Пароль аккаунта изменён и отправлен на Email: {FFFFFF}%s",PlayerInfo[playerid][pName],day,month,year, PlayerInfo[giveplayerid][pMail]);
    ShowDialog(giveplayerid, 32761, 0, "******* {00cc00}*Аккаунт Защищён* {FFFFFF}*******", string, "Ок", "");
    PlayAudioStreamForPlayer(giveplayerid, "https://cdn.pears.fun/sound/banned.mp3");
    AdminLog("vzlom", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], 0, "");
    Kickx(giveplayerid);
    work_admin(playerid, 9);

    if(serverType == 0) printf("OnPasswordHashVzlom %s %s", PlayerInfo[giveplayerid][pName], password);
    return 1;
}

forward OnPasswordHashSetpasOffline(playerid, const password[], const str_name[], user_id);
public OnPasswordHashSetpasOffline(playerid, const password[], const str_name[], user_id)
{
	new dest[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(dest);

    new string[180];
    format(string,sizeof(string),"UPDATE `pp_igroki` SET `Key` = '%s' WHERE `Name` = '%s'", dest, str_name);
    query_empty(pearsq, string);
    SendClientMessage(playerid, COLOR_WHITE, "{ffffff}[ {0088ff}ADM {ffffff}] Игроку %s изменён пароль {0088ff}%s", str_name, password);
    AdminLog("setpas", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], user_id, str_name, "", 0, "");
	return 1;
}

forward OnPasswordHashSetpas(playerid, const password[], giveplayerid);
public OnPasswordHashSetpas(playerid, const password[], giveplayerid)
{
    bcrypt_get_hash(PlayerInfo[giveplayerid][pKey]);

    new string[180];
    format(string,sizeof(string),"UPDATE `pp_igroki` SET `Key` = '%s' WHERE `user_id` = '%d'", PlayerInfo[giveplayerid][pKey], PlayerInfo[giveplayerid][pID]);
    query_empty(pearsq, string);
    SendClientMessage(playerid, COLOR_WHITE, "{ffffff}[ {0088ff}ADM {ffffff}] Игроку %s изменён пароль {0088ff}%s", PlayerInfo[giveplayerid][pName], password);
    PlayerInfo[giveplayerid][pBdPoletDayz] = 1;
    AdminLog("setpas", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName], PlayerInfo[giveplayerid][pPlaIP], 0, "");
	return 1;
}

forward OnPasswordHashCreateHidden(playerid, const password[]);
public OnPasswordHashCreateHidden(playerid, const password[])
{
	new dest[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(dest);

    new string[320];
    format(string, sizeof(string), "INSERT INTO `pp_igroki` SET `Name`='Pirzz_Prezest',`Ammo5`='%d',`RegData`='%d',`Key`='%s',`Tut`='1',\
        `DrugPerk`='%d',`Model`='23',`Money`='2000',`Komnata`='5',`Qwest`='100',`Sex`='1',`Neon`='100',`Cap`='100',`Infoload`='1000',`Age`='18',`Keyhidden`='%s'", 
            PlayerInfo[playerid][pID], gettime(), dest, ServerInfo[54], password);
    query_empty(pearsq, string);

    PlayerPlaySound(playerid,6401,0,0,0);
    cmd_hidden(playerid);
    return 1;
}

forward OnPasswordHashPasswordHidden(playerid, const password[], user_id);
public OnPasswordHashPasswordHidden(playerid, const password[], user_id)
{
	new dest[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(dest);

    new string[180];
    format(string,sizeof(string),"UPDATE `pp_igroki` SET `Key`='%s', `Keyhidden`='%s' WHERE `Ammo5` = '%d'", 
            dest, password, user_id);
    query_empty(pearsq, string);
    return 1;
}

forward OnPasswordHashResetPassword(playerid, const password[]);
public OnPasswordHashResetPassword(playerid, const password[])
{
    bcrypt_get_hash(PlayerInfo[playerid][pKey]);

    OnlineInfo[playerid][oRecoveryPassword] = 0;
    OnlineInfo[playerid][oRecoveryTry] = 0;
    OnlineInfo[playerid][oRecoveryAccess] = false;

    new string[220];
    format(string, sizeof(string), "ID аккаунта: %d | Никнейм: %s | Новый пароль: %s", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], password);
    SendMail(PlayerInfo[playerid][pMail], "Смена Пароля", string, PlayerInfo[playerid][pName]);


    new string_mysql[200];
    format(string_mysql, sizeof(string_mysql), "UPDATE `pp_igroki` SET `Key` = '%s' WHERE `user_id` = '%d'", PlayerInfo[playerid][pKey], PlayerInfo[playerid][pID]);
    query_empty(pearsq, string_mysql);

    format(string,sizeof(string),"{cccccc}Привет, {ff9000}%s\n{99ff66}Введите ваш новый пароль\n\n{cccccc}Если вы забыли пароль, нажмите ESC или Отмена",PlayerInfo[playerid][pName]);
    if(PlayerInfo[playerid][pTypoihyi] == 0) ShowDialog(playerid,1,DIALOG_STYLE_PASSWORD,"{ff9000}Авторизация",string,"Далее","Отмена");
    else ShowDialog(playerid,1,DIALOG_STYLE_INPUT,"{ff9000}Авторизация",string,"Далее","Отмена");

    OnlineInfo[playerid][oProccessPassword] = false;

    if(serverType == 0) printf("OnPasswordHashResetPassword %s %s", PlayerInfo[playerid][pName], password);
    return 1;
}

stock UseDrugs(playerid, e_DrugsType: type, slot = 999)
{
    if(PlayerInfo[playerid][pBkyrenie] >= 2) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я сейчас участвую в экспедиции NASA..");
	if(box[playerid] >= 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я участвую в бою на ринге..");
	if(PlayerInfo[playerid][pJailed] == 4 || PlayerInfo[playerid][pJailed] == 7) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я в больнице..");
	if(MPGO[playerid] != 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я участвую в мероприятии..");
	if(howstun(playerid)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мне плохо...");
	if(!IsPlayerInAnyVehicle(playerid) && GetPlayerSpeed(playerid) > 3) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу закинуться на бегу..");
	if(get_invent4(playerid, DrugsInfo[type][diItem], 0) <= 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня нет с собой этого вещества..");
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && WatchSpeed[playerid] >= 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу на ходу за рулём");
    if(DrugsInfo[type][diCooldown] > 0 && DrugsCooldown[playerid] > 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Не могу использовать прямо сейчас [Осталось: %s]", fine_time(DrugsCooldown[playerid]));
    //if(HealthAC[playerid] >= GetMaxPlayerHealth(playerid)) return ErrorMessage(playerid, "{FF6347}У вашего персонажа полная полоса здоровья");

    if(PortInfo[wStat] == 1 && IsPlayerInSquare(playerid,-1739.7145, -103.8218,-1694.4082,-27.3040) ||
	PortInfo[wStat] == 2 && IsPlayerInSquare(playerid,2401.7756,-2641.1243,2447.0828,-2564.6064)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Мне сейчас некогда [ Запрещено во время битвы ]");

    new cooldownTime = DrugsInfo[type][diCooldown];

    new string[144];
    switch (type)
    {
        case DRUGS_TYPE_WEED: {
            if(get_invent4(playerid, 53, 0) <= 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня нет зажигалки");

            if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "SMOKING", "M_smk_in", 3.0, false, false, false, false, false, SYNC_ALL);
            SetPlayerChatBubble(playerid, "забивает косяк и прикуривает его", COLOR_PURPLE, 20.0, 7000);
            
            if(IsAZoneCapt(playerid))
            {
                new org = fraction(playerid);
                if(CaptInfo[cAttack] == org) CaptInfo[cLogDrugA][1] ++;
                if(CaptInfo[cDefend] == org) CaptInfo[cLogDrugD][1] ++;
                PlayerInfo[playerid][pGangTemp][8]++;
            }
            TakeInvent(playerid, DrugsInfo[type][diItem], 1, 0, slot);
            ACSetPlayerHealth(playerid, HealthAC[playerid] + DrugsInfo[type][diHeal]);
        }
        case DRUGS_TYPE_COCAINE: {
            if(gettime() < GetPVarInt(playerid, "CocoCD")) return ErrorMessage(playerid, "{FF6347}Подождите некоторое время перед повторным использованием");
            if(!HealthPlayer(playerid, 6, DrugsInfo[type][diHeal], slot, DrugsInfo[type][diItem])) return ErrorMessage(playerid, "{FF6347}Дождитесь окончания процесса лечения");

            // Если порошок юзают вне капта - не накладываем КД
            if (IsAZoneCapt(playerid)) cooldownTime = 0;

            if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, true, false, false, false, SYNC_ALL);
            SetPlayerChatBubble(playerid, "высыпает дорожку и вдыхает её через нос", COLOR_PURPLE, 20.0, 7000);

            SetPVarInt(playerid,"afdrugs", gettime() + 60);
        }
        case DRUGS_TYPE_BLUE_COCAINE:
        {
            if(gettime() < GetPVarInt(playerid, "CocoCD")) return ErrorMessage(playerid, "{FF6347}Подождите некоторое время перед повторным использованием");
            if(!HealthPlayer(playerid, 6, OnlineInfo[playerid][oMaxHealth], slot, DrugsInfo[type][diItem])) return ErrorMessage(playerid, "{FF6347}Дождитесь окончания процесса лечения");

            // Если порошок юзают вне капта - не накладываем КД
            if (IsAZoneCapt(playerid)) cooldownTime = 0;

            if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, true, false, false, false, SYNC_ALL);
            SetPlayerChatBubble(playerid, "высыпает дорожку и вдыхает её через нос", COLOR_PURPLE, 20.0, 7000);

            SetPVarInt(playerid,"afdrugs", gettime() + 60);
        }
        case DRUGS_TYPE_DUMMY_BLUE_COCAINE:
        {
            if(gettime() < GetPVarInt(playerid, "CocoCD")) return ErrorMessage(playerid, "{FF6347}Подождите некоторое время перед повторным использованием");
            if(!HealthPlayer(playerid, 6, DrugsInfo[type][diHeal], slot, DrugsInfo[type][diItem])) return ErrorMessage(playerid, "{FF6347}Дождитесь окончания процесса лечения");

            // Если порошок юзают вне капта - не накладываем КД
            if (IsAZoneCapt(playerid)) cooldownTime = 0;

            if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, true, false, false, false, SYNC_ALL);
            SetPlayerChatBubble(playerid, "высыпает дорожку и вдыхает её через нос", COLOR_PURPLE, 20.0, 7000);

            SetPVarInt(playerid,"afdrugs", gettime() + 60);
        }
        case DRUGS_TYPE_ECSTASY:
        {
            if (PlayerInfo[playerid][pNeon] < 200) return ErrorMessage(playerid, "{FF6347}Нельзя употреблять это вещество на пустой желудок");
            if (PlayerInfo[playerid][pMechSkill] >= 700) return ErrorMessage(playerid, "{FF6347}У вас и так высокий уровень бодрости");

            PlayerInfo[playerid][pNeon] -= 200; // Убавляем сытость
            PlayerInfo[playerid][pMechSkill] += 150; // Прибавляем бодрость
            
            if(NoAnim[playerid] == 0) ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, true, false, false, false, SYNC_ALL);
            ACSetPlayerHealth(playerid, HealthAC[playerid] + DrugsInfo[type][diHeal]);
            SetPlayerChatBubble(playerid, "проглатывает таблетку", COLOR_PURPLE, 20.0, 7000);
            TakeInvent(playerid, DrugsInfo[type][diItem], 1, 0, slot);
        }
        case DRUGS_TYPE_MUSHROOMS:
        {
            if(get_invent4(playerid, DrugsInfo[type][diItem], 0) < 10) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: У меня нет с собой достаточного количества грибов [ Минимум: 10 ]");

            if(NoAnim[playerid] == 0) ApplyAnimation(playerid,"FOOD","EAT_Burger",4.1,false,true,false,false,false,SYNC_ALL);
            ACSetPlayerHealth(playerid, HealthAC[playerid] + DrugsInfo[type][diHeal]);
            SetPlayerChatBubble(playerid,"съедает грибы",COLOR_PURPLE,20.0,7000);

            new para = get_para(playerid, DrugsInfo[type][diItem]), unix = gettime();
	        TakeInvent(playerid, DrugsInfo[type][diItem], 10, 0, slot, false);

            if(IsAZoneCapt(playerid))
            {
                new org = fraction(playerid);
                if(CaptInfo[cAttack] == org) CaptInfo[cLogDrugA][2] ++;
                if(CaptInfo[cDefend] == org) CaptInfo[cLogDrugD][2] ++;
                PlayerInfo[playerid][pGangTemp][9] ++;
            }
            if(unix > para) EatPlayer(playerid, -800), SetPVarInt(playerid, "qweststat", 64), SetPVarInt(playerid, "qwesttime", 8);
            if(unix > para && PlayerInfo[playerid][pAchieve][113] == 0) AchievePlayer(playerid, 113, 1);
        }
        default: return 0;
    }

    Effect[playerid] = DrugsInfo[type][diEffect];
    EffectTime[playerid] += DrugsInfo[type][diEffectTime];
    PearsWeather(playerid), PearsTime(playerid);

    if (Effect[playerid] > 0 && EffectTime[playerid] > 0)
    {
        format(string, sizeof(string), RusToGame("~p~%d ~w~Секунд"), EffectTime[playerid]), GameTextForPlayer(playerid, string, 7000, 1);
        SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Эффект будет длиться в течение {ff9000}%d секунд..", EffectTime[playerid]);
    }

    if (cooldownTime > 0) DrugsCooldown[playerid] = cooldownTime;

    return 1;
}

stock Drugs_IsPackage(thingid)
{
    new dummy[2];
    return Drugs_GetPackageAmount(thingid, dummy[0], dummy[1]);
}

stock Drugs_GetPackageAmount(thingid, &fpick, &fquan)
{
    switch (thingid)
    {
        case 271: fpick = 4, fquan = 10;
        case 272: fpick = 7, fquan = 4;
        case 277: fpick = 263, fquan = 20;
        case 278: fpick = 264, fquan = 20;
        default: return 0;
    }

    return 1;
}

stock Drugs_OnPlayerDisconnect(playerid)
{
    DrugsCooldown[playerid] = 0;
    NarcoSpot_OnPlayerDisconnect(playerid);

    return 1;
}

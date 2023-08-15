
/*
1- Хлеб
102 - Молоко
104 - Картошка
120 - Sprunk Банка
121 - Кофе
168 - Мясо
174 - Овощи
179 - Мороженное

*/

// Получение ингредиентов для создания еды
stock menuEatIngredient(thingId, &ing1, &ing2, &ing3, &ing4, &ing5, &ing6, &ingQuan1, &ingQuan2, &ingQuan3, &ingQuan4, &ingQuan5, &ingQuan6)
{
	if(thingId == 121) // Кофе
	{
		ing1 = 121, ingQuan1 = 1; // Кофе
		ing2 = 102, ingQuan2 = 1; // Молоко
	}
	else if(thingId == 124 || thingId == 120) // Sprunk Стакан или Sprunk Банка
	{
		ing1 = 120, ingQuan1 = 1; // Sprunk Банка
	}
	else if(thingId == 125 || thingId == 126) // Бургер (126 - в упаковке)
	{
		ing1 = 1, ingQuan1 = 1; // Хлеб
		ing2 = 168, ingQuan2 = 1; // Мясо
		ing3 = 174, ingQuan3 = 1; // Овощи
	}
	else if(thingId == 127) // Ролл
	{
		ing1 = 1, ingQuan1 = 1; // Хлеб
		ing2 = 168, ingQuan2 = 1; // Мясо
		ing3 = 174, ingQuan3 = 1; // Овощи
	}
	else if(thingId == 128) // Набор 1
	{
		ing1 = 1, ingQuan1 = 1; // Хлеб
		ing2 = 168, ingQuan2 = 1; // Мясо
		ing3 = 174, ingQuan3 = 1; // Овощи
		ing4 = 120, ingQuan4 = 1; // Sprunk Банка
		ing5 = 179, ingQuan5 = 1; // Мороженое
		ing6 = 104, ingQuan6 = 1; // Картошка
	}
	else if(thingId == 129) // Набор 2
	{
		ing1 = 168, ingQuan1 = 1; // Мясо
		ing2 = 120, ingQuan2 = 1; // Sprunk Банка
		ing3 = 179, ingQuan3 = 1; // Мороженое
	}
	else if(thingId == 130) // Набор 3
	{
		ing1 = 1, ingQuan1 = 1; // Хлеб
		ing2 = 168, ingQuan2 = 1; // Мясо
		ing3 = 174, ingQuan3 = 1; // Овощи
		ing4 = 120, ingQuan4 = 1; // Sprunk Банка
		ing5 = 179, ingQuan5 = 1; // Мороженое
		ing6 = 104, ingQuan6 = 1; // Картошка
	}
	else if(thingId == 131) // Набор 4
	{
		ing1 = 168, ingQuan1 = 1; // Мясо
		ing2 = 120, ingQuan2 = 1; // Sprunk Банка
		ing3 = 104, ingQuan3 = 1; // Картошка
	}
	else if(thingId == 132) // Набор 5
	{
		ing1 = 1, ingQuan1 = 2; // Хлеб
		ing2 = 168, ingQuan2 = 2; // Мясо
		ing3 = 174, ingQuan3 = 2; // Овощи
		ing4 = 120, ingQuan4 = 1; // Sprunk Банка
		ing5 = 104, ingQuan5 = 1; // Картошка
	}
	else if(thingId == 133) // Набор 6
	{
		ing1 = 1, ingQuan1 = 2; // Хлеб
		ing2 = 168, ingQuan2 = 4; // Мясо
		ing3 = 174, ingQuan3 = 2; // Овощи
		ing4 = 120, ingQuan4 = 1; // Sprunk Банка
		ing5 = 104, ingQuan5 = 1; // Картошка
	}
	else if(thingId == 134) // Набор 7
	{
		ing1 = 1, ingQuan1 = 2; // Хлеб
		ing2 = 121, ingQuan2 = 1; // Кофе
		ing3 = 102, ingQuan3 = 1; // Молоко
	}
	else if(thingId == 135) // Набор 8
	{
		ing1 = 1, ingQuan1 = 9; // Хлеб
		ing2 = 121, ingQuan2 = 1; // Кофе
		ing3 = 102, ingQuan3 = 1; // Молоко
	}
	else if(thingId == 136) // Набор 9
	{
		ing1 = 1, ingQuan1 = 5; // Хлеб
		ing2 = 121, ingQuan2 = 1; // Кофе
		ing3 = 102, ingQuan3 = 1; // Молоко
	}
	else if(thingId == 137) // Набор 10
	{
		ing1 = 1, ingQuan1 = 1; // Хлеб
		ing2 = 174, ingQuan2 = 2; // Овощи
		ing3 = 168, ingQuan3 = 1; // Мясо
		ing4 = 120, ingQuan4 = 1; // Sprunk Банка
	}
	else if(thingId == 138) // Набор 11
	{
		ing1 = 168, ingQuan1 = 1; // Мясо
		ing2 = 174, ingQuan2 = 1; // Овощи
		ing3 = 120, ingQuan3 = 1; // Sprunk Банка
		ing4 = 179, ingQuan4 = 1; // Мороженое
	}
	else if(thingId == 141) // Хот Дог
	{
		ing1 = 1, ingQuan1 = 1; // Хлеб
		ing2 = 168, ingQuan2 = 1; // Мясо
	}
	else if(thingId == 165) // Пицца
	{
		ing1 = 1, ingQuan1 = 1; // Хлеб
		ing2 = 168, ingQuan2 = 1; // Мясо
	}
	else if(thingId == 166) // Пицца Домашняя
	{
		ing1 = 1, ingQuan1 = 1; // Хлеб
		ing2 = 168, ingQuan2 = 1; // Мясо
	}
	else if(thingId == 172) // Апельсиновый сок
	{
		ing1 = 101, ingQuan1 = 3; // Апельсин
	}	
	else if(thingId == 173) // Яблочный сок
	{
		ing1 = 100, ingQuan1 = 3; // Яблачко
	}
	return 1;
}

stock SetSatiety(thingId, &fquan) //
{	
	new ingId[6], ingQuan[6];
	menuEatIngredient(thingId, ingId[0], ingId[1], ingId[2], ingId[3], ingId[4], ingId[5], ingQuan[0], ingQuan[1], ingQuan[2], ingQuan[3], ingQuan[4], ingQuan[5]);
	for(new i = 0; i < 6; i++)
    {
		if(ingId[i] > 0)
		{
			if(ingId[i] == 1) fquan += 1*ingQuan[i];//хлеб
			else if(ingId[i] == 102) fquan += 2*ingQuan[i];//Молоко
			else if(ingId[i] == 104) fquan += 1*ingQuan[i];//Картошка
			else if(ingId[i] == 120) fquan += 4*ingQuan[i];//Sprunk Банка
			else if(ingId[i] == 121) fquan += 2*ingQuan[i];//Кофе
			else if(ingId[i] == 168) fquan += 8*ingQuan[i];//мясо
			else if(ingId[i] == 174) fquan += 2*ingQuan[i];//Овощи
			else if(ingId[i] == 179) fquan += 2*ingQuan[i];//Мороженное
			else if(ingId[i] == 101) fquan += 3*ingQuan[i];//апельсинка
			else if(ingId[i] == 100) fquan += 3*ingQuan[i];//яблоко
		}
	}
	printf("Кусков:%d | Блюдо:%s", fquan, friskName[thingId]);
	return 1;
}

stock checkHaveWarePlayer(playerid, thingId) // Проверка на наличие ингредиентов при готовке
{
	new ingId[6], ingQuan[6], noProduct;
	menuEatIngredient(thingId, ingId[0], ingId[1], ingId[2], ingId[3], ingId[4], ingId[5], ingQuan[0], ingQuan[1], ingQuan[2], ingQuan[3], ingQuan[4], ingQuan[5]);

	for(new i = 0; i < 6; i++)
	{
		if(ingId[i] > 0)
		{
			if(get_invent3(playerid, ingId[i], 1) < ingQuan[i]) 
			{
				noProduct = 1;
				break;
			}
		}
	}
	if(noProduct) return 1;
	return 0;
}

stock takeWarePlayer(playerid, thingId) // Забираем предмет из инвентаря
{
	new ingId[6], ingQuan[6];
	menuEatIngredient(thingId, ingId[0], ingId[1], ingId[2], ingId[3], ingId[4], ingId[5], ingQuan[0], ingQuan[1], ingQuan[2], ingQuan[3], ingQuan[4], ingQuan[5]);

	for(new i = 0; i < 6; i++)
    {
		if(ingId[i] > 0)
		{	
			for(new t = 0; t < ingQuan[i]; t++)
			{
				TakeInvent(playerid, ingId[i], 1, 0, 999);
			}
		}
	}
	return 1;
}

stock CookingHome(playerid)
{	
	new thingId, quan = 0;
	if (GetPVarInt(playerid,"Arobsklad") == 20) thingId = 166;
	else if (GetPVarInt(playerid,"Arobsklad") == 21) thingId = 172;
	else if (GetPVarInt(playerid,"Arobsklad") == 22) thingId = 173;
	else return ErrorMessage(playerid, "{FF6347}Шакал на Филине допустил где-то ошибку"), SetPVarInt(playerid,"Arobsklad",0);
	
	new unix = gettime();
	new current_tick = GetTickCount();
	new interval = GetTickDiff(current_tick, Aftextdraw[playerid]);
	if(interval > 300)
	{
		//SetPVarInt(playerid,"oryjtemp",GetPVarInt(playerid,"oryjtemp")+1*get_ability(playerid, 3));
		SetPVarInt(playerid,"oryjtemp",GetPVarInt(playerid,"oryjtemp")+1*10);
		if(!IsPlayerInRangeOfPoint(playerid,3.0,Job_X[playerid], Job_Y[playerid], Job_Z[playerid]))
		{
			SetPVarInt(playerid,"oryjtemp", 0), SetPVarInt(playerid,"Arobsklad",0), ClearAnimations(playerid), TextDrawHideForPlayer(playerid, MindDraw[3]), PlayerTextDrawHide(playerid, HintButton), PlayerPlaySound(playerid,4203,0,0,0);
			Dei[playerid] = 7, GameTextForPlayer(playerid,RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Вы отошли от плиты"), 5000, 3), RemovePlayerAttachedObject(playerid,1);
		}
		new string[58];
		format(string, sizeof(string), RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~%d/100"),GetPVarInt(playerid,"oryjtemp")), GameTextForPlayer(playerid,string, 1500, 3);
		ApplyAnimation(playerid,"OTB","betslp_loop",2.0, 1, 0, 0, 0, 0);
		if(GetPVarInt(playerid,"oryjtemp") >= 100)
		{
			RemovePlayerAttachedObject(playerid,1), ClearAnim(playerid), ClearAnimations(playerid), Dei[playerid] = 0, TextDrawHideForPlayer(playerid, MindDraw[3]), PlayerTextDrawHide(playerid, HintButton), SetPVarInt(playerid,"oryjtemp", 0);

			if(checkHaveWarePlayer(playerid,thingId)) return ErrorMessage(playerid, "{FF6347}Блин блинский... \nУ меня нет всех ингредиентов для приготовления этого блюда");
			SetSatiety(thingId, quan);
			new put_inva = GiveThingPlayer(playerid, thingId, quan, unix+86400, 0, 0, 0, 9999);
			if(put_inva == -1) return ErrorMessage(playerid, "{FF6347}У вас нет места в инвентаре"), SetPVarInt(playerid,"Arobsklad",0);
			
			takeWarePlayer(playerid, thingId);
			GameTextForPlayer(playerid," ", 3000, 3);
			PlayerPlaySound(playerid,6401,0,0,0);
			ShowDialog(playerid, 1700, 0, "{ff9000}Плита", "{cccccc}Отлично! {99ff66}Готовка завершена", "Ок", "");
			
			SetPVarInt(playerid,"Arobsklad",0);
		}
		Aftextdraw[playerid] = current_tick;
	}
 	return 1;
}

stock godrink(playerid)
{
	if(Hold[playerid] == 2 && HoldQuan[playerid] <= 0) return ErrorMessage(playerid, "{FF6347}Ваш бокал пуст [ Налейте в него выпивку N ]");
	if(HoldQuan[playerid] <= 1) return stopdrink(playerid), PlayerPlaySound(playerid,5601,0,0,0), RemovePlayerAttachedObject(playerid,1);
	if(HoldStat[playerid] == 120)
	{
	    around_player_audio(playerid, 4604, 0, 20.0);
	    PlayerInfo[playerid][pInven][HoldInva[playerid]] = 139;
		PlayerInfo[playerid][pInvenPara][HoldInva[playerid]] = gettime()+172800;
		HoldStat[playerid] = 139, HoldFrisk[playerid] = 139;
		ApplyAnimation(playerid,"OTB","betslp_loop",4.0,0,1,1,0,0);
  		SetPlayerChatBubble(playerid,"открывает банку sprunk",COLOR_PURPLE,30.0,5000);
		return 1;
	}
	if(HoldStat[playerid] == 126)
	{
	    around_player_audio(playerid, 20800, 0, 20.0);
		PlayerInfo[playerid][pInven][HoldInva[playerid]] = 125;
		HoldStat[playerid] = 125, HoldFrisk[playerid] = 125;
		ApplyAnimation(playerid,"OTB","betslp_loop",4.0,0,1,1,0,0);
  		SetPlayerChatBubble(playerid,"распаковывает бургер",COLOR_PURPLE,30.0,5000);
  		RemovePlayerAttachedObject(playerid,1);
    	object_in_hand(playerid, friskPick[125]);
		return 1;
	}
	if(HoldStat[playerid] == 163) return ErrorMessage(playerid, "{FF6347}Свадебный торт нужно поставить на стол и резать кухонным ножом [ Кнопка F ]");
	if(Hold[playerid] == 3 && HoldStat[playerid] > 0)
	{
	    if(PlayerInfo[playerid][pInven][HoldInva[playerid]] == HoldStat[playerid]) PlayerInfo[playerid][pInvenQuan][HoldInva[playerid]] --;
	}

	new alco, coffe, eat;
	if(!IsPlayerInAnyVehicle(playerid) && NoAnim[playerid] == 0)
	{
		if(HoldStat[playerid] == 125 || HoldStat[playerid] == 127 || HoldStat[playerid] == 141|| HoldStat[playerid] == 163|| HoldStat[playerid] == 105|| HoldStat[playerid] == 104|| HoldStat[playerid] == 103 || HoldStat[playerid] == 101 || HoldStat[playerid] == 102 || HoldStat[playerid] == 100 || HoldStat[playerid] == 99 || HoldStat[playerid] == 89) ApplyAnimation(playerid,"FOOD","EAT_Pizza",4.1,0,0,0,0,0);
		else ApplyAnimation(playerid,"BAR","dnk_stndM_loop",2.0,0,0,0,0,0);
	}
	if(HoldStat[playerid] == 14 || HoldStat[playerid] == 117 || HoldStat[playerid] == 118 || HoldStat[playerid] == 119 || HoldStat[playerid] == 120 || HoldStat[playerid] == 121 || HoldStat[playerid] == 124)
	{
	    new unix = gettime();
		if(unix > HoldPara[playerid])
		{
			EatPlayer(playerid, -800), SetPVarInt(playerid, "qweststat", 64), SetPVarInt(playerid, "qwesttime", 3);
			if(PlayerInfo[playerid][pAchieve][113] == 0) AchievePlayer(playerid, 113, 1);
		}
		else
		{
		    if(HoldStat[playerid] == 121)
			{
			    coffe = 20;
				if(PlayerInfo[playerid][pMechSkill]+coffe <= 1000) PlayerInfo[playerid][pMechSkill] += coffe;
				else PlayerInfo[playerid][pMechSkill] = 1000;
			}
		}
	}
	
	HoldQuan[playerid] --;
	// Жидкости
    if(HoldStat[playerid] == 14 || HoldStat[playerid] == 37 || HoldStat[playerid] >= 112 && HoldStat[playerid] <= 124 || HoldStat[playerid] == 139 || HoldStat[playerid] == 172 || HoldStat[playerid] == 173)
    {
        if(PlayerInfo[playerid][pCap] >= 1) PlayerInfo[playerid][pCap] --;
		EatPlayer(playerid, 10), eat = 1;
    }
    else
	{
	    around_player_audio(playerid, 32200, 0, 20.0);
		EatPlayer(playerid, 20), eat = 1; // Хавчик
		if(HoldQuan[playerid] <= 1) Eat[playerid] = 1, EatTime[playerid] = 4, stopdrink(playerid);
	}
	if(HoldStat[playerid] == 14 || HoldStat[playerid] == 117 || HoldStat[playerid] == 118 || HoldStat[playerid] == 119) Effect[playerid] = 5, EffectTime[playerid] += 10, infect(playerid, 11, 2), alco = 10; // Пиво, Сидры, Пиво разливное
	else if(HoldStat[playerid] == 37)
	{
		Effect[playerid] = 5, EffectTime[playerid] += 20, infect(playerid, 11, 5), alco = 20; // Шампанское
		if(IsANewYear() || PlayerInfo[playerid][pSoska] >= 22)
		{
			if(IsPlayerInRangeOfPoint(playerid, 80.0,719.0646,-3313.4468,2.7862) || IsPlayerInRangeOfPoint(playerid, 60.0,1282.9220,-1545.0332,13.2139)) doneqwest(playerid, 6);
		}
	}
	else if(HoldStat[playerid] == 112) Effect[playerid] = 5, EffectTime[playerid] += 40, infect(playerid, 11, 10), alco = 40; // Водка
	else if(HoldStat[playerid] == 113) Effect[playerid] = 5, EffectTime[playerid] += 15, infect(playerid, 11, 5), alco = 15; // Вино
	else if(HoldStat[playerid] == 114 || HoldStat[playerid] == 115 || HoldStat[playerid] == 116) Effect[playerid] = 5, EffectTime[playerid] += 30, infect(playerid, 11, 10), alco = 30; // Виски, Коньяк, Брэнди
	if(alco > 0)
	{
		format(store,sizeof(store),RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~+%d~n~~y~%d сек"), alco, EffectTime[playerid]);
		GameTextForPlayer(playerid,store,2500,3);
	}
	else if(coffe > 0)
	{
		format(store,sizeof(store),RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~+%d~n~~y~%d/100"), coffe/10, PlayerInfo[playerid][pMechSkill]/10);
		GameTextForPlayer(playerid,store,2500,3);
	}
	else if(eat > 0)
	{
	    format(store,sizeof(store),RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~+%d~n~~y~%d/100"), eat, PlayerInfo[playerid][pNeon]/10);
		GameTextForPlayer(playerid,store,2500,3);
	}
	
	if(HoldStat[playerid] == 14 || HoldStat[playerid] == 37 || HoldStat[playerid] >= 112 && HoldStat[playerid] <= 119)
	{
	    PearsTime(playerid);
		PearsWeather(playerid);
		// Сильно пьяный - блюёт
		if(EffectTime[playerid] > 1000)
		{
		    switch(random(5))
		    {
		        case 0: EatPlayer(playerid, -800), SetPVarInt(playerid, "qweststat", 64), SetPVarInt(playerid, "qwesttime", 8);
				default: {}
			}
		}
	}
	return 1;
}
stock goeat_podnos(playerid)
{
    new t = HoldStat[playerid];
	new fpick = ThrowInfo[t][tId];
	if(ThrowInfo[t][tId] > 0 && HoldFrisk[playerid] == ThrowInfo[t][tId])
	{
	    ThrowInfo[t][tQuan] --;
	    around_player_audio(playerid, 32200, 0, 20.0);
	    EatPlayer(playerid, 20);
	    format(store,sizeof(store),RusToGame("~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~+5~n~~y~%d/100"), PlayerInfo[playerid][pNeon]/10);
		GameTextForPlayer(playerid,store,1800,3);
		if(fpick == 134 || fpick == 135 || fpick == 136) // Если поднос с кофе
		{
			if(PlayerInfo[playerid][pMechSkill]+20 <= 1000) PlayerInfo[playerid][pMechSkill] += 20;
			else PlayerInfo[playerid][pMechSkill] = 1000;
		}
	    new unix = gettime();
		if(unix > ThrowInfo[t][tPara])
		{
			EatPlayer(playerid, -800), SetPVarInt(playerid, "qweststat", 64), SetPVarInt(playerid, "qwesttime", 3);
			if(PlayerInfo[playerid][pAchieve][113] == 0) AchievePlayer(playerid, 113, 1);
		}
		if(ThrowInfo[t][tQuan] <= 1)
	    {
	        DestroyThrow(t);
			updatethrowall(t);
			Hold[playerid] = 0, HoldStat[playerid] = 0, HoldFrisk[playerid] = 0;
			if(playerSeat[playerid]) TextDrawShowForPlayer(playerid, MindDraw[3]), PlayerTextDrawSetString(playerid, HintButton, "ENTER"), PlayerTextDrawShow(playerid, HintButton);
			if(PlayerInfo[playerid][pQwest] == 16)
			{
				PlayerInfo[playerid][pQwest] = 17, mysql_save(playerid, 69);
				ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*","{ffcc66}Чудесно! Ваш персонаж покушал\nВы можете купить с собой пару бургеров (по желаниию) и выйти на улицу","*","");
			}
	    }
	}
	return 1;
}

stock glass(playerid, fpick, inva)
{
	if(Hold[playerid] == 0)
 	{
 	    if(Hold[playerid] > 0 || Hand[playerid] > 0 || GetPlayerWeapon(playerid) >= 2) return ErrorMessage(playerid, "{FF6347}У вас заняты руки [Предмет, действие или оружие]");
 	    new model;
 	    if(fpick == 38) model = 19819;
 	    else if(fpick == 122) model = 19818;
 	    Eat[playerid] = 0;
 	    PlayerPlaySound(playerid,5600,0,0,0), ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0,0,1,1,0,0);
  		RemovePlayerAttachedObject(playerid,1), SetPlayerAttachedObject(playerid, 1, model, 6, 0.108999, 0.033000, 0.031000, 9.500002, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
  		SetPlayerChatBubble(playerid,"берёт в руки бокал",COLOR_PURPLE,30.0,8000);
  		HoldNoinvent[playerid] = 0;
  		Hold[playerid] = 2, HoldFrisk[playerid] = fpick, HoldStat[playerid] = fpick, HoldQuan[playerid] = 1, HoldInva[playerid] = inva;
    }
    else if(Hold[playerid] == 2)
    {
        if(HoldStat[playerid] > 0) TextDrawHideForPlayer(playerid, MindDraw[3]), PlayerTextDrawHide(playerid, HintButton);
        Hold[playerid] = 0, HoldFrisk[playerid] = 0, HoldStat[playerid] = 0, HoldQuan[playerid] = 0, HoldInva[playerid] = -1;
        PlayerPlaySound(playerid,5601,0,0,0), ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0,0,1,1,0,0);
   		RemovePlayerAttachedObject(playerid,1);
    	SetPlayerChatBubble(playerid,"убирает бокал",COLOR_PURPLE,30.0,8000);
	}
	return 1;
}
stock stopdrink(playerid)
{
    if(Hold[playerid] == 3 && HoldStat[playerid] != 124) ClearPlayerInven(playerid, HoldInva[playerid]);
	Hold[playerid] = 0, HoldStat[playerid] = 0, HoldQuan[playerid] = 0, HoldInva[playerid] = -1;
	TextDrawHideForPlayer(playerid, MindDraw[3]), PlayerTextDrawHide(playerid, HintButton);
	return 1;
}
stock drink_eat(playerid, inva, fpick)
{
	if(box[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вы участник боя на ринге");
	if(PlayerInfo[playerid][pJailed] == 4 || PlayerInfo[playerid][pJailed] == 7) return ErrorMessage(playerid, "{FF6347}Вы пациент госпиталя");
	if(howstun(playerid)) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
	if(fpick == 14 || fpick == 37 || fpick >= 112 && fpick <= 119)
	{
	    if(PlayerInfo[playerid][pBkyrenie] >= 2) return ErrorMessage(playerid, "{FF6347}Вы учасник экспедиции NASA [ Вам запрещено употреблять алкоголь ]");
	    if(fraction(playerid) == 18) return ErrorMessage(playerid, "{FF6347}Ваша религия не позволяет употреблять алкоголь [Arabian Mafia]");
	}
	if(Hold[playerid] == 3)
	{
	    Hold[playerid] = 0, HoldStat[playerid] = 0, HoldQuan[playerid] = 0, PlayerPlaySound(playerid,5601,0,0,0), RemovePlayerAttachedObject(playerid,1);
     	ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0,0,1,1,0,0);
     	TextDrawHideForPlayer(playerid, MindDraw[3]), PlayerTextDrawHide(playerid, HintButton);
		return 1;
	}
	if(Dei[playerid] > 0 || Hold[playerid] > 0 && Hold[playerid] != 2 || Hand[playerid] > 0 || GetPlayerWeapon(playerid) > 1) return ErrorMessage(playerid, "{FF6347}У вас заняты руки [Предмет или оружие]");
	if(Hold[playerid] == 2)
	{
	    if(fpick == 120 || fpick == 124) return ErrorMessage(playerid, "{FF6347}Sprunk нельзя налить в бокал {cccccc}[ Уберите бокал и пейте напиток из банки ]");
	    if(fpick == 121) return ErrorMessage(playerid, "{FF6347}Кофе нельзя налить в бокал {cccccc}[ Уберите бокал и пейте напиток из кружки ]");
	    if(fpick == 125 || fpick == 126 || fpick == 127 || fpick == 1 ||fpick == 54 ||fpick == 55 ||fpick == 89 ||fpick == 99 ||fpick == 100 ||fpick == 101 ||fpick == 103 ||fpick == 104 ||fpick == 126 ||fpick == 127 ||fpick == 141 ||fpick == 163) return ErrorMessage(playerid, "{FF6347}У вас заняты руки [Предмет или оружие]");
	    if(HoldQuan[playerid] > 1) return ErrorMessage(playerid, "{FF6347}В вашем бокале ещё есть содержимое {cccccc}[ Допейте или поставьте бокал F ]");
	    if(PlayerInfo[playerid][pInvenQuan][inva] <= 1) return ErrorMessage(playerid, "{FF6347}Эта бутылка пустая");
	    ApplyAnimation(playerid,"OTB","betslp_loop",4.0,0,1,1,0,0);
	    HoldPara[playerid] = PlayerInfo[playerid][pInvenPara][inva], HoldQara[playerid] = PlayerInfo[playerid][pInvenQara][inva];
	    if(PlayerInfo[playerid][pInvenQuan][inva]-3 >= 0) HoldQuan[playerid] += 3;
	    else HoldQuan[playerid] = PlayerInfo[playerid][pInvenQuan][inva];
	    if(PlayerInfo[playerid][pInvenQuan][inva]-3 <= 0)
		{
			PlayerInfo[playerid][pInvenQuan][inva] = 0, PlayerInfo[playerid][pInven][inva] = 0, PlayerInfo[playerid][pInvenPara][inva] = 0, PlayerInfo[playerid][pInvenQara][inva] = 0, PlayerInfo[playerid][pInvenType][inva] = 0;
			if(OnlineInfo[playerid][oShowInterface] == 1) i_tile(playerid, 0, 0, inva, 0, 0, 0);
		}
		else PlayerInfo[playerid][pInvenQuan][inva] -= 3;
	    HoldStat[playerid] = fpick;
	    if(PlayerInfo[playerid][pSex] == 1) format(store,sizeof(store),"открыл бутылку и налил в бокал %s", friskName[fpick]);
	    else format(store,sizeof(store),"открыла бутылку и налила в бокал %s", friskName[fpick]);
	    SetPlayerChatBubble(playerid,store,COLOR_PURPLE,20.0,5000);
	    format(store,sizeof(store),"{ffcc66}Вы налили в бокал %s {ff9000}[ Сделать глоток: %s ]", friskName[fpick], buttonName[Device[playerid]]);
	    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",store,"*","");
        TextDrawShowForPlayer(playerid, MindDraw[3]);
		if(Device[playerid] == 0) PlayerTextDrawSetString(playerid, HintButton, "RMB");
		else if(Device[playerid] == 1) PlayerTextDrawSetString(playerid, HintButton, "H");
		PlayerTextDrawShow(playerid, HintButton);
	}
	else
	{
	    in_hand_eat(playerid, 3, fpick, fpick, PlayerInfo[playerid][pInvenQuan][inva], inva, PlayerInfo[playerid][pInvenPara][inva], PlayerInfo[playerid][pInvenQara][inva], 0);
	    PlayerPlaySound(playerid,5600,0,0,0), ApplyAnimation(playerid,"GANGS","DRUGS_BUY",3.0,0,1,1,0,0);
	}
	return 1;
}
stock in_hand_eat(playerid, hold, fpick, soder, quan, inva, para, qara, noinventer)
{
    Eat[playerid] = 0;
    HoldNoinvent[playerid] = noinventer;
    Hold[playerid] = hold, HoldFrisk[playerid] = fpick, HoldStat[playerid] = soder, HoldQuan[playerid] = quan, HoldInva[playerid] = inva;
    HoldPara[playerid] = para, HoldQara[playerid] = qara;
    RemovePlayerAttachedObject(playerid,1);
    object_in_hand(playerid, friskPick[fpick]);
    if(fpick == 125 || fpick == 126 || fpick == 127 || fpick == 164 || fpick == 141) format(store,sizeof(store),"{ffcc66}Вы взяли в руки %s (%d гр.) {ff9000}[ Кушать: %s ]", friskName[fpick], (HoldQuan[playerid]-1)*10, buttonName[Device[playerid]]);
	else if(fpick == 163)
	{
		format(store,sizeof(store),"{ffcc66}Вы взяли в руки %s (%d гр.) {ff9000}[ Поставьте на стол F и порежьте кухонным ножом ]", friskName[fpick], (HoldQuan[playerid]-1)*10);
		PPP15[playerid] = 7, ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,1,1,1,1,1);
	}
	else
	{
    	if(hold == 2) format(store,sizeof(store),"{ffcc66}Вы взяли в руки %s %s (%d мл.) {ff9000}[ Сделать глоток: %s ]\n{cccccc}Поставить на стол или пол: Кнопка F", friskName[fpick], friskName[soder], (HoldQuan[playerid]-1)*10, buttonName[Device[playerid]]);
		else format(store,sizeof(store),"{ffcc66}Вы взяли в руки %s {ff9000}[ Сделать глоток: %s ]\n{cccccc}Поставить на стол или пол: Кнопка F", friskName[fpick], buttonName[Device[playerid]]);
	}
    ShowDialog(playerid,1700,DIALOG_STYLE_MSGBOX,"{ffcc00}*",store,"*","");
	TextDrawShowForPlayer(playerid, MindDraw[3]);
	if(fpick == 163) PlayerTextDrawSetString(playerid, HintButton, "F"), PlayerTextDrawShow(playerid, HintButton);
	else
	{
		if(Device[playerid] == 0) PlayerTextDrawSetString(playerid, HintButton, "RMB");
		else if(Device[playerid] == 1) PlayerTextDrawSetString(playerid, HintButton, "H");
		PlayerTextDrawShow(playerid, HintButton);
	}
	return 1;
}
stock in_hand_podnos(playerid, fpick, fquan, fpara, fqara)
{
    new string[314];
    PPP15[playerid] = 7, ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,1,1,1,1,1);
    RemovePlayerAttachedObject(playerid,1);
    object_in_hand(playerid, friskPick[fpick]), Hold[playerid] = 12;
    HoldNoinvent[playerid] = 1;
    HoldFrisk[playerid] = fpick, HoldStat[playerid] = fpick, HoldQuan[playerid] = fquan;
    HoldInva[playerid] = -1;
    HoldPara[playerid] = fpara, HoldQara[playerid] = fqara;
    Eat[playerid] = 0;
    format(string,sizeof(string),"{99ff66}У вас в руках %s\n\n{ff9000}Как кушать?\n{cccccc}1. Положите поднос на стол [ Кнопка - F ]\n2. Сядьте на стул рядом с подносом [ Кнопка - ALT ]\n3. Откройте инвентарь и выберите в разделе << Рядом >> ваш поднос\n4. Ваш поднос будет отмечен белым фоном, в отличии от других", friskName[HoldStat[playerid]]);
	SuccessMessage(playerid, string);
	return 1;
}
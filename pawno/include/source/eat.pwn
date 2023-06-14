
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
			if(ingId[i] == 1) fquan += 1;
			else if(ingId[i] == 102) fquan += 2;
			else if(ingId[i] == 104) fquan += 1;
			else if(ingId[i] == 120) fquan += 4;
			else if(ingId[i] == 121) fquan += 2;
			else if(ingId[i] == 168) fquan += 8;
			else if(ingId[i] == 174) fquan += 2;
			else if(ingId[i] == 179) fquan += 2;
		}
	}
	return 1;
}
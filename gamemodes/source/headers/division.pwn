#define MAX_DIVISION_ORG 10 // Количество подфракций
#define MAX_NAME_DIVISION_ABBREVIATION_LENGTH 11 // Длинна аббревиатуры

enum divInfo
{
    divRanks, //  Количество рангов
    divName[MAX_NAME_LENGTH], // Название
    divAbbreviation[MAX_NAME_DIVISION_ABBREVIATION_LENGTH], // Аббревиатура
    Float:divSpawnPos[4], // Позиция спавна
	bool:divAvailableWeapons[38], // Оружия доступные для заказа (организации департамента)
    divSpawnWorld, // Вирт мир спавна
    divSpawnInterior, // Интерьер спавна
    divColorHex[7] // hex цвет
	//divColorVeh[2] // Цвет транспорта (0 и 1) - у транспорта цвет, это число (id)
};
new DivisionInfo[MAX_ORG][MAX_DIVISION_ORG][divInfo];
new DivisionRankName[MAX_ORG][MAX_DIVISION_ORG][MAX_RANK_ORG][MAX_NAME_LENGTH]; // Названия рангов
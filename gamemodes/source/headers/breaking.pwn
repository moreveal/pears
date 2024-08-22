#define MAX_SCALES 6

new Float:breakingdraw_x = 255.000000, Float:breakingdraw_y = 197.000000; // Относительное расположение текстдравов на экране

enum e_BreakingType {
	BREAKING_TYPE_HOUSE,
	BREAKING_TYPE_VEHICLE,
	BREAKING_TYPE_ENGINE,
	BREAKING_TYPE_TRAILER,
	BREAKING_TYPE_PRISON_CAMERA,
	BREAKING_TYPE_ELECTRICAL_SHIELD
};

new bool:breakingDraw[MAX_REALPLAYERS];
new BreakingTimer[MAX_REALPLAYERS]; //  ID таймера для движения шкалы
new BreakingScale[MAX_REALPLAYERS]; // Какая шкала в данный момент движется (0-5)
new BreakingMaxScales[MAX_REALPLAYERS]; // Количество шкал в момент взлома
new Float:BreakingScaleStat[MAX_REALPLAYERS]; // Прогресс движения шкалы
new Float:BreakingThickness[MAX_REALPLAYERS]; // Толщина зелёной зоны шкал
new Float:BreakingMinYPos[MAX_SCALES][MAX_REALPLAYERS]; // Нижняя граница зеленой зоны
new Float:BreakingMaxYPos[MAX_SCALES][MAX_REALPLAYERS]; // Верхняя граница зеленой зоны
new e_BreakingType: BreakingType[MAX_REALPLAYERS]; // Тип взлома
new BreakingTypeID[MAX_REALPLAYERS]; // ID Того, что мы взламываем (ID дома или транспорта)

new PlayerText:BreakingPlayerDraw[14][MAX_REALPLAYERS]; // Текстдравов взлома (оформление, рамки и ключик)
new PlayerText:BreakingScalePlayerDraw[24][MAX_REALPLAYERS]; // Текстдравы бара для взлома
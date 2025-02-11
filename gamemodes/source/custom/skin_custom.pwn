
/*
Как добавить новый кастомный скин на сервер?
1. Добавить новую строку в new SkinPearsInfo (инструкция для переменной внизу)
2. Если хотим добавить скин в организацию, добавляем его в public ReloadSkin

Как добавить скин в магазины?
1. В настройках гос цен правительства указываешь ценник и доступ для заказа в магазы (и УСЁ)
*/

/*
Инструкция для переменной SkinPearsInfo

bool:eCustomSkin false обычный скин, true кастомный скин
eSampSkinID ID скина заменка на дефолтную (если скин true кастомный), если обычный, тогда 0
eSkinPrice цена в виртах
eSkinGold цена в голде
eSkinName название скина
eSkinClass класс скина (0 - 4)
eSkinSex (0 нет пола, 1 мужской, 2 женский)

name класса пишется: при просмотре подробной инфы о скине в инвентаре, при выпадении из кейса (желательно)

0 класс - любая продажа в магазах одежды оффнута, не сливаемый скупщику, не дропается с кейсов
name: Системный, цвет #444444

1 класс - доступен в магазах одежды, выпадает только с кейса одежды, голд ценник: $ / 2500
name: Обычный, цвет #a2a0a0

2 класс - доступен в магазах одежды, выпадает с кейса одежды и голд кейса, голд ценник: $ / 2000
name: Необычный, цвет #66ca55

3 класс - недоступен в магазах одежды за вирты, выпадает только с голд кейса, голд ценник: $ / 1500
name: Редкий, цвет #6d48e2

4 класс - недоступен в магазах одежды, выпадает только с голд кейса, голд ценник: $ / 1000 или кастом
name: Легендарный, цвет #d90763
*/

enum SKINENUM { bool:eCustomSkin, eSampSkinID, eSkinPrice, eSkinGold, eSkinName[64], eSkinClass, eSkinSex }
new SkinPearsInfo[][SKINENUM] =
{
    { false, 0, 30000, 0, "CJ", 0, 1 }, // 0
    { false, 0, 15000, 0, "The Truth", 0, 1 }, // 1
    { false, 0, 150000, 50, "Maccer", 1, 1 }, // 2
    { false, 0, 100000, 50, "Andre", 1, 1 }, // 3
    { false, 0, 150000, 75, "Mini Bear", 1, 1 }, // 4
    { false, 0, 0, 0, "Big Bear", 0, 1 }, // 5
    { false, 0, 150000, 75, "Emmet", 1, 1 }, // 6
    { false, 0, 200000, 100, "Taxi Driver", 1, 1 }, // 7
    { false, 0, 400000, 150, "Janitor", 2, 1 }, // 8
    { false, 0, 75000, 50, "Normal Ped", 1, 2 }, // 9
    { false, 0, 0, 0, "Old Woman", 0, 2 }, // 10
    { false, 0, 0, 0, "Casino croupier", 0, 2 }, // 11
    { false, 0, 0, 0, "Rich Woman", 0, 2 }, // 12
    { false, 0, 0, 0, "Street Girl", 0, 2 }, // 13
    { false, 0, 150000, 75, "Normal Ped", 0, 1 }, // 14
    { false, 0, 150000, 75, "Mr.Whittaker", 0, 1 }, // 15
    { false, 0, 400000, 200, "Airport Worker", 0, 1 }, // 16
    { false, 0, 20000, 0, "Businessman", 0, 1 }, // 17
    { false, 0, 15000, 0, "Beach Visitor", 0, 1 }, // 18
    { false, 0, 0, 0, "DJ", 0, 1 }, // 19
    { false, 0, 500000, 250, "Rich Guy", 2, 1 }, // 20
    { false, 0, 100000, 60, "Normal Ped", 1, 1 }, // 21
    { false, 0, 650000, 325, "Normal Ped", 2, 1 }, // 22
    { false, 0, 650000, 325, "BMXer", 2, 1 }, // 23
    { false, 0, 500000, 0, "M.D. Bodyguard", 0, 1 }, // 24
    { false, 0, 1000000, 0, "M.D. Bodyguard", 0, 1 }, // 25
    { false, 0, 0, 0, "Backpacker", 0, 1 }, // 26
    { false, 0, 45000, 0, "Construction Worker", 0, 1 }, // 27
    { false, 0, 45000, 0, "Drug Dealer", 0, 1 }, // 28
    { false, 0, 2000000, 2000, "Drug Dealer", 4, 1 }, // 29
    { false, 0, 0, 0, "Drug Dealer", 0, 1 }, // 30
    { false, 0, 0, 0, "Farm Inhabitant", 0, 2 }, // 31
    { false, 0, 300000, 150, "Farm Inhabitant", 2, 1 }, // 32
    { false, 0, 600000, 450, "Farm Inhabitant", 3, 1 }, // 33
    { false, 0, 300000, 150, "Farm Inhabitant", 2, 1 }, // 34
    { false, 0, 0, 0, "Gardener", 0, 1 }, // 35
    { false, 0, 200000, 100, "Golfer", 1, 1 }, // 36
    { false, 0, 200000, 100, "Golfer", 1, 1 }, // 37
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 38
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 39
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 40
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 41
    { false, 0, 0, 0, "Jethro", 0, 1 }, // 42
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 43
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 44
    { false, 0, 0, 0, "Beach Visitor", 0, 1 }, // 45
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 46
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 47
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 48
    { false, 0, 0, 0, "Da Nang", 0, 1 }, // 49
    { false, 0, 0, 0, "Mechanic", 0, 1 }, // 50
    { false, 0, 0, 0, "Mountain Biker", 0, 1 }, // 51
    { false, 0, 0, 0, "Mountain Biker", 0, 1 }, // 52
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 53
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 54
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 55
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 56
    { false, 0, 0, 0, "Oriental Ped", 0, 1 }, // 57
    { false, 0, 0, 0, "Oriental Ped", 0, 1 }, // 58
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 59
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 60
    { false, 0, 0, 0, "Pilot", 0, 1 }, // 61
    { false, 0, 0, 0, "Colonel Fuhrberger", 0, 1 }, // 62
    { false, 0, 0, 0, "Prostitute", 0, 2 }, // 63
    { false, 0, 0, 0, "Prostitute", 0, 2 }, // 64
    { false, 0, 0, 0, "Kendl Johnson", 0, 2 }, // 65
    { false, 0, 0, 0, "Pool Player", 0, 1 }, // 66
    { false, 0, 0, 0, "Pool Player", 0, 1 }, // 67
    { false, 0, 0, 0, "Preacher", 0, 1 }, // 68
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 69
    { false, 0, 0, 0, "Scientist", 0, 1 }, // 70
    { false, 0, 0, 0, "Security Guard", 0, 1 }, // 71
    { false, 0, 0, 0, "Hippy", 0, 1 }, // 72
    { false, 0, 0, 0, "Hippy", 0, 1 }, // 73
    { false, 0, 0, 0, "Unknown", 0, 1 }, // 74
    { false, 0, 0, 0, "Prostitute", 0, 2 }, // 75
    { false, 0, 0, 0, "Stewardess", 0, 2 }, // 76
    { false, 0, 0, 0, "Homeless", 0, 2 }, // 77
    { false, 0, 0, 0, "Homeless", 0, 1 }, // 78
    { false, 0, 0, 0, "Homeless", 0, 1 }, // 79
    { false, 0, 0, 0, "Boxer", 0, 1 }, // 80
    { false, 0, 0, 0, "Boxer", 0, 1 }, // 81
    { false, 0, 0, 0, "Black Elvis", 0, 1 }, // 82
    { false, 0, 0, 0, "White Elvis", 0, 1 }, // 83
    { false, 0, 0, 0, "Blue Elvis", 0, 1 }, // 84
    { false, 0, 0, 0, "Prostitute", 0, 2 }, // 85
    { false, 0, 0, 0, "Ryder Mask", 0, 1 }, // 86
    { false, 0, 0, 0, "Stripper", 0, 2 }, // 87
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 88
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 89
    { false, 0, 0, 0, "Jogger", 0, 2 }, // 90
    { false, 0, 700000, 450, "Rich Woman", 3, 2 }, // 91
    { false, 0, 0, 0, "Rollerskater", 0, 2 }, // 92
    { false, 0, 400000, 200, "Normal Ped", 2, 2 }, // 93
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 94
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 95
    { false, 0, 0, 0, "Jogger", 0, 1 }, // 96
    { false, 0, 0, 0, "Lifeguard", 0, 1 }, // 97
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 98
    { false, 0, 0, 0, "Rollerskater", 0, 1 }, // 99
    { false, 0, 0, 0, "Biker", 0, 1 }, // 100
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 101
    { false, 0, 0, 0, "Balla", 0, 1 }, // 102
    { false, 0, 0, 0, "Balla", 0, 1 }, // 103
    { false, 0, 0, 0, "Balla", 0, 1 }, // 104
    { false, 0, 0, 0, "Grove", 0, 1 }, // 105
    { false, 0, 0, 0, "Grove", 0, 1 }, // 106
    { false, 0, 0, 0, "Grove", 0, 1 }, // 107
    { false, 0, 0, 0, "Vagos", 0, 1 }, // 108
    { false, 0, 0, 0, "Vagos", 0, 1 }, // 109
    { false, 0, 0, 0, "Vagos", 0, 1 }, // 110
    { false, 0, 0, 0, "Russian Mafia", 0, 1 }, // 111
    { false, 0, 0, 0, "Russian Mafia", 0, 1 }, // 112
    { false, 0, 0, 0, "Russian Mafia", 0, 1 }, // 113
    { false, 0, 0, 0, "Aztecas", 0, 1 }, // 114
    { false, 0, 0, 0, "Aztecas", 0, 1 }, // 115
    { false, 0, 0, 0, "Aztecas", 0, 1 }, // 116
    { false, 0, 0, 0, "Triad", 0, 1 }, // 117
    { false, 0, 0, 0, "Triad", 0, 1 }, // 118
    { false, 0, 0, 0, "Johhny Sindacco", 0, 1 }, // 119
    { false, 0, 0, 0, "Triad Boss", 0, 1 }, // 120
    { false, 0, 0, 0, "Da Nang Boy", 0, 1 }, // 121
    { false, 0, 0, 0, "Da Nang Boy", 0, 1 }, // 122
    { false, 0, 0, 0, "Da Nang Boy", 0, 1 }, // 123
    { false, 0, 0, 0, "The Mafia", 0, 1 }, // 124
    { false, 0, 0, 0, "The Mafia", 0, 1 }, // 125
    { false, 0, 0, 0, "The Mafia", 0, 1 }, // 126
    { false, 0, 0, 0, "The Mafia", 0, 1 }, // 127
    { false, 0, 300000, 150, "Farm Inhabitant", 2, 1 }, // 128
    { false, 0, 0, 0, "Farm Inhabitant", 0, 2 }, // 129
    { false, 0, 0, 0, "Farm Inhabitant", 0, 2 }, // 130
    { false, 0, 0, 0, "Farm Inhabitant", 0, 2 }, // 131
    { false, 0, 300000, 150, "Farm Inhabitant", 2, 1 }, // 132
    { false, 0, 0, 0, "Farm Inhabitant", 0, 1 }, // 133
    { false, 0, 0, 0, "Farm Inhabitant", 0, 1 }, // 134
    { false, 0, 0, 0, "Farm Inhabitant", 0, 1 }, // 135
    { false, 0, 0, 0, "Farm Inhabitant", 0, 1 }, // 136
    { false, 0, 0, 0, "Homeless", 0, 1 }, // 137
    { false, 0, 0, 0, "Homeless", 0, 2 }, // 138
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 139
    { false, 0, 0, 0, "Homeless", 0, 2 }, // 140
    { false, 0, 0, 0, "Beach Visitor", 0, 2 }, // 141
    { false, 0, 0, 0, "Beach Visitor", 0, 1 }, // 142
    { false, 0, 0, 0, "Beach Visitor", 0, 1 }, // 143
    { false, 0, 0, 0, "Businesswoman", 0, 1 }, // 144
    { false, 0, 0, 0, "Taxi Driver", 0, 2 }, // 145
    { false, 0, 0, 0, "Crack Maker", 0, 1 }, // 146
    { false, 0, 0, 0, "Crack Maker", 0, 1 }, // 147
    { false, 0, 0, 0, "Crack Maker", 0, 2 }, // 148
    { false, 0, 0, 0, "Crack Maker", 0, 1 }, // 149
    { false, 0, 0, 0, "Businessman", 0, 2 }, // 150
    { false, 0, 0, 0, "Businesswoman", 0, 2 }, // 151
    { false, 0, 0, 0, "Big Smoke Armored", 0, 2 }, // 152
    { false, 0, 0, 0, "Businesswoman", 0, 1 }, // 153
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 154
    { false, 0, 0, 0, "Prostitute", 0, 1 }, // 155
    { false, 0, 250000, 125, "Construction Worker", 2, 1 }, // 156
    { false, 0, 0, 0, "Beach Visitor", 0, 2 }, // 157
    { false, 0, 300000, 150, "Pizza Worker", 2, 1 }, // 158
    { false, 0, 0, 0, "Barber", 0, 1 }, // 159
    { false, 0, 0, 0, "Hillbilly", 0, 1 }, // 160
    { false, 0, 300000, 150, "Farmer", 2, 1 }, // 161
    { false, 0, 300000, 150, "Hillbilly", 2, 1 }, // 162
    { false, 0, 0, 0, "Hillbilly", 0, 1 }, // 163
    { false, 0, 0, 0, "Farmer", 0, 1 }, // 164
    { false, 0, 0, 0, "Hillbilly", 0, 1 }, // 165
    { false, 0, 0, 0, "Black Bouncer", 0, 1 }, // 166
    { false, 0, 0, 0, "White Bouncer", 0, 1 }, // 167
    { false, 0, 0, 0, "White MIB agent", 0, 1 }, // 168
    { false, 0, 0, 0, "Black MIB agent", 0, 2 }, // 169
    { false, 0, 0, 0, "Cluckin' Bell Worker", 0, 1 }, // 170
    { false, 0, 800000, 500, "Chilli Dog Vendor", 3, 1 }, // 171
    { false, 0, 800000, 500, "Normal Ped", 3, 2 }, // 172
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 173
    { false, 0, 0, 0, "Blackjack Dealer", 0, 1 }, // 174
    { false, 0, 0, 0, "Casino croupier", 0, 1 }, // 175
    { false, 0, 500000, 250, "Rifa", 2, 1 }, // 176
    { false, 0, 900000, 600, "Rifa", 3, 1 }, // 177
    { false, 0, 0, 0, "Rifa", 0, 2 }, // 178
    { false, 0, 0, 0, "Barber", 0, 1 }, // 179
    { false, 0, 500000, 250, "Barber", 2, 1 }, // 180
    { false, 0, 0, 0, "Whore", 0, 1 }, // 181
    { false, 0, 0, 0, "Ammunation", 0, 1 }, // 182
    { false, 0, 0, 0, "Tattoo Artist", 0, 1 }, // 183
    { false, 0, 0, 0, "Punk", 0, 1 }, // 184
    { false, 0, 0, 0, "Cab Driver", 0, 1 }, // 185
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 186
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 187
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 188
    { false, 0, 700000, 550, "Normal Ped", 3, 1 }, // 189
    { false, 0, 0, 0, "Businessman", 0, 2 }, // 190
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 191
    { false, 0, 0, 0, "Valet", 0, 2 }, // 192
    { false, 0, 0, 0, "Barbara Schternvart", 0, 2 }, // 193
    { false, 0, 900000, 700, "Helena Wankstein", 3, 2 }, // 194
    { false, 0, 0, 0, "Michelle Cannes", 0, 2 }, // 195
    { false, 0, 0, 0, "Katie Zhan", 0, 2 }, // 196
    { false, 0, 0, 0, "Millie Perkins", 0, 2 }, // 197
    { false, 0, 0, 0, "Denise Robinson", 0, 2 }, // 198
    { false, 0, 0, 0, "Farm Inhabitan", 0, 2 }, // 199
    { false, 0, 0, 0, "Hillbill", 0, 1 }, // 200
    { false, 0, 0, 0, "Farm Inhabitan", 0, 2 }, // 201
    { false, 0, 0, 0, "Farm Inhabitan", 0, 1 }, // 202
    { false, 0, 0, 0, "Hillbilly", 0, 1 }, // 203
    { false, 0, 0, 0, "Farmer", 0, 1 }, // 204
    { false, 0, 0, 0, "Farmer", 0, 2 }, // 205
    { false, 0, 0, 0, "Karate Teacher", 0, 1 }, // 206
    { false, 0, 0, 0, "Karate Teacher", 0, 2 }, // 207
    { false, 0, 0, 0, "Burger Shot Cashier", 0, 1 }, // 208
    { false, 0, 0, 0, "Cab Driver", 0, 1 }, // 209
    { false, 0, 0, 0, "Prostitute", 0, 1 }, // 210
    { false, 0, 450000, 225, "Su Xi Mu", 2, 2 }, // 211
    { false, 0, 0, 0, "Noodle Vendor", 0, 1 }, // 212
    { false, 0, 0, 0, "School Instructor", 0, 1 }, // 213
    { false, 0, 0, 0, "Shop Staff", 0, 2 }, // 214
    { false, 0, 0, 0, "Homeless", 0, 2 }, // 215
    { false, 0, 0, 0, "Weird old man", 0, 2 }, // 216
    { false, 0, 0, 0, "Maria Latore", 0, 1 }, // 217
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 218
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 219
    { false, 0, 0, 0, "Shop Staff", 0, 1 }, // 220
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 221
    { false, 0, 0, 0, "Rich Woman", 0, 1 }, // 222
    { false, 0, 0, 0, "Cab Driver", 0, 1 }, // 223
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 224
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 225
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 226
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 227
    { false, 0, 0, 0, "Oriental Businessman", 0, 1 }, // 228
    { false, 0, 0, 0, "Oriental Ped", 0, 1 }, // 229
    { false, 0, 0, 0, "Oriental Ped", 0, 1 }, // 230
    { false, 0, 0, 0, "Homeless", 0, 2 }, // 231
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 232
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 233
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 234
    { false, 0, 0, 0, "Cab Driver", 0, 1 }, // 235
    { false, 0, 500000, 400, "Normal Ped", 3, 1 }, // 236
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 237
    { false, 0, 0, 0, "Prostitute", 0, 2 }, // 238
    { false, 0, 0, 0, "Prostitute", 0, 1 }, // 239
    { false, 0, 0, 0, "Homeless", 0, 1 }, // 240
    { false, 0, 0, 0, "The D.A", 0, 1 }, // 241
    { false, 0, 0, 0, "Afro-American", 0, 1 }, // 242
    { false, 0, 0, 0, "Mexican", 0, 2 }, // 243
    { false, 0, 0, 0, "Prostitute", 0, 2 }, // 244
    { false, 0, 0, 0, "Stripper", 0, 2 }, // 245
    { false, 0, 0, 0, "Prostitute", 0, 2 }, // 246
    { false, 0, 0, 0, "Stripper", 0, 1 }, // 247
    { false, 0, 0, 0, "Biker", 0, 1 }, // 248
    { false, 0, 1000000, 750, "Biker", 3, 1 }, // 249
    { false, 0, 0, 0, "Pimp", 0, 1 }, // 250
    { false, 0, 0, 0, "Normal Ped", 0, 2 }, // 251
    { false, 0, 0, 0, "Lifeguard", 0, 1 }, // 252
    { false, 0, 0, 0, "Naked Valet", 0, 1 }, // 253
    { false, 0, 0, 0, "Bus Driver", 0, 1 }, // 254
    { false, 0, 0, 0, "Biker Drug Dealer", 0, 1 }, // 255
    { false, 0, 0, 0, "Chauffeu", 0, 2 }, // 256
    { false, 0, 0, 0, "Stripper", 0, 2 }, // 257
    { false, 0, 500000, 250, "Stripper", 2, 1 }, // 258
    { false, 0, 500000, 250, "Heckler", 2, 1 }, // 259
    { false, 0, 0, 0, "Heckler", 0, 1 }, // 260
    { false, 0, 0, 0, "Construction Worker", 0, 1 }, // 261
    { false, 0, 0, 0, "Cab driver", 0, 1 }, // 262
    { false, 0, 0, 0, "Cab driver", 0, 2 }, // 263
    { false, 0, 0, 0, "Normal Ped", 0, 1 }, // 264
    { false, 0, 0, 0, "Dwayne", 0, 1 }, // 265
    { false, 0, 0, 0, "Big Smoke", 0, 1 }, // 266
    { false, 0, 0, 0, "Sweet", 0, 1 }, // 267
    { false, 0, 0, 0, "Ryder", 0, 1 }, // 268
    { false, 0, 0, 0, "Mafia Boss", 0, 1 }, // 269
    { false, 0, 0, 0, "T-Bone Mendez", 0, 1 }, // 270
    { false, 0, 0, 0, "Paramedic", 0, 1 }, // 271
    { false, 0, 0, 0, "Paramedic", 0, 1 }, // 272
    { false, 0, 0, 0, "Paramedic", 0, 1 }, // 273
    { false, 0, 0, 0, "Firefighter", 0, 1 }, // 274
    { false, 0, 0, 0, "Firefighter", 0, 1 }, // 275
    { false, 0, 0, 0, "Firefighter", 0, 1 }, // 276
    { false, 0, 0, 0, "Police Officer", 0, 1 }, // 277
    { false, 0, 0, 0, "Police Officer", 0, 1 }, // 278
    { false, 0, 0, 0, "Police Officer", 0, 1 }, // 279
    { false, 0, 0, 0, "County Sheriff", 0, 1 }, // 280
    { false, 0, 0, 0, "Motorbike Cop", 0, 1 }, // 281
    { false, 0, 0, 0, "Special Forces", 0, 1 }, // 282
    { false, 0, 0, 0, "Federal Agent", 0, 1 }, // 283
    { false, 0, 0, 0, "Army", 0, 1 }, // 284
    { false, 0, 0, 0, "Desert Sheriff", 0, 0 }, // 285
    { false, 0, 0, 0, "Zero", 0, 1 }, // 286
    { false, 0, 0, 0, "Ken Rosenberg", 0, 1 }, // 287
    { false, 0, 0, 0, "Kent Paul", 0, 1 }, // 288
    { false, 0, 0, 0, "Cesar Vialpando", 0, 1 }, // 289
    { false, 0, 800000, 550, "OG Loc", 3, 1 }, // 290
    { false, 0, 600000, 450, "Wu Zi Mu", 0, 1 }, // 291
    { false, 0, 0, 0, "Michael Toreno", 0, 1 }, // 292
    { false, 0, 0, 0, "Jizzy", 0, 1 }, // 293
    { false, 0, 0, 0, "Madd Dogg", 0, 1 }, // 294
    { false, 0, 0, 0, "Catalina", 0, 1 }, // 295
    { false, 0, 0, 0, "Claude", 0, 1 }, // 296
    { false, 0, 0, 0, "Police Officer", 0, 1 }, // 297
    { false, 0, 0, 0, "Police Officer", 0, 2 }, // 298
    { false, 0, 0, 0, "Police Officer", 0, 1 }, // 299
    { false, 0, 0, 0, "Police Officer", 0, 1 }, // 300
    { false, 0, 0, 0, "Police Officer", 0, 1 }, // 301
    { false, 0, 0, 0, "Police Officer", 0, 1 }, // 302
    { false, 0, 0, 0, "Police Officer", 0, 1 }, // 303
    { false, 0, 0, 0, "Police Officer", 0, 1 }, // 304
    { false, 0, 0, 0, "Paramedic", 0, 1 }, // 305
    { false, 0, 0, 0, "Police Officer", 0, 2 }, // 306
    { false, 0, 0, 0, "Country Sheriff", 0, 2 }, // 307
    { false, 0, 0, 0, "Desert Sheriff", 0, 2 }, // 308
    { false, 0, 0, 0, "Desert Sheriff", 0, 2 }, // 309
    { false, 0, 0, 0, "Desert Sheriff", 0, 1 }, // 310
    { false, 0, 0, 0, "Desert Sheriff", 0, 1 }, // 311
    { true, 294, 300000, 120, "Парень в черном", 1, 1 }, // 312 15500, pearspedcu (Значит не 312, а 15500) male
    { true, 60, 1000000, 660, "Стильный мужик", 3, 1 }, // 313 pearspeda (Значит не 313, а 15501) male
    { true, 233, 350000, 140, "Девушка в белом платье", 1, 2 }, // 314 pearspedb (Значит не 314, а 15502)
    { true, 19, 500000, 250, "Парень с тату", 2, 1 }, // 315  15503 pearspedc male
    { true, 59, 700000, 280, "Парень в кофте с черепами", 1, 1 }, // 316  15504 pearspedd male
    { true, 93, 700000, 280, "Девушка в костюме Adidas", 1, 2 }, // 317  15505, pearspede
    { true, 19, 500000, 200, "Парень с тату в кепке", 1, 1 }, // 318  15506, pearspedf male
    { true, 59, 1000000, 500, "Мужчина в подтяжках", 2, 1 }, // 319  15507, pearspedg male
    { true, 125, 2900000, 2000, "МакГрегор", 3, 1 }, // 320   15508, pearspedh male
    { true, 23, 1, 1, "Парень в красных вансах", 0, 1 }, // 321  15509, pearspedi male
    { true, 21, 1, 1, "Мужчина в Одежде Луи Витон", 0, 1 }, // 322  15510, pearspedj male
    { true, 216, 500000, 250, "Женщина в зеленом платье", 2, 2 }, // 323   15511, pearspedk
    { true, 55, 400000, 200, "Женщина в платье скелете", 2, 2 }, // 324  15512, pearspedl
    { true, 93, 1000000, 650, "Женщина в костюме Nike", 3, 2 }, // 325  15513, pearspedm
    { true, 7, 1, 1, "Мужчина в простой одежде", 0, 1 }, // 326 15514, pearspedn male
    { true, 125, 500000, 250, "Мужчина с тату", 2, 1 }, // 327 15515, pearspedo male
    { true, 1, 500000, 250, "Мужчина в майке с тату", 2, 1 }, // 328 15516, pearspedp male
    { true, 248, 0, 0, "Мужчина в джинсовой одежде", 0, 1 }, // 329  15517, pearspedq male
    { true, 29, 0, 0, "Мужчина в капюшоне и джинсовке", 0, 1 }, // 330 15518, pearspedr male
    { true, 121, 0, 0, "Мужчина в джинсовых вещах", 0, 1 }, // 331  15519, pearspeds male
    { true, 125, 0, 0, "Мужчина в джинсовых вещах", 0, 1 }, // 332  15520, pearspedt male
    { true, 240, 100000, 50, "Мужчина в черной куртке", 1, 1 }, // 333  15521, pearspedu male
    { true, 223, 3000000, 2000, "Мужчина в фирменой одежде", 3, 1 }, // 334  15522, pearspedv male
    { true, 28, 1, 1, "Мужчина в белом худи", 0, 1 }, // 335 15523, pearspedw male
    { true, 25, 2500000, 1650, "Мужчина в куртке", 3, 1 }, // 336 15524, pearspedx male
    { true, 150, 600000, 240, "Женщина в черном пальто", 2, 2 }, // 337  15525, pearspedy
    { true, 237, 500000, 250, "Женщина в черно-белой одежде", 2, 2 }, // 338  15526, pearspedz
    { true, 131, 1, 1, "Женщина в черной одежде", 0, 2 }, // 339  15527, pearspedaa
    { true, 12, 300000, 120, "Девушка в топе с вишенкой", 1, 2 }, // 340 15528, pearspedab
    { true, 40, 300000, 120, "Девушка в топе", 1, 2 }, // 341 15529, pearspedac
    { true, 178, 0, 0, "Сексуальная девушка", 0, 2 }, // 342  15530, pearspedad
    { true, 233, 500000, 250, "Девушка в Gucci", 2, 2 }, // 343  15531, pearspedae
    { true, 93, 1, 1, "Девушка в черной одежде", 0, 2 }, // 344 15532, pearspedaf
    { true, 157, 1, 1, "Девушка в зеленом", 0, 2 }, // 345  15533, pearspedag 
    { true, 223, 500000, 200, "Девушка в белой одежде", 1, 2 }, // 346  15534, pearspedah
    { true, 233, 600000, 240, "Девушка в клетчатой рубашке", 1, 2 }, // 347  15535, pearspedai
    { true, 233, 500000, 250, "Девушка в розовой одежде", 2, 2 }, // 348  15536, pearspedaj
    { true, 233, 400000, 160, "Девушка в светлой одежде", 1, 2 }, // 349  15537, pearspedak
    { true, 93, 2500000, 1650, "Девушка гот", 3, 2 }, // 350 15538, pearspedal
    { true, 233, 250000, 100, "Девушка в топе с бабочкой", 1, 2 }, // 351  15539, pearspedam
    { true, 223, 1, 1, "Мужчина в коричневом худи", 0, 1 }, // 352  15540, pearspedan male
    { true, 240, 1500000, 1000, "Мужчина в сером бомбере", 3, 1 }, // 353  15541, pearspedao male
    { true, 126, 1000000, 700, "Мужчина в свитшоте", 3, 1 }, // 354  15542, pearspedap male
    { true, 93, 900000, 600, "Девушка в бомбере", 3, 2 }, // 355 15543, pearspedaq
    { true, 240, 400000, 200, "Мужчина в черной футболке", 2, 1 }, // 356  15544, pearspedar male
    { true, 93, 2500000, 1700, "Девушка в черной одежде", 3, 2 }, // 357 15545, pearspedas
    { true, 93, 500000, 200, "Девушка в черной одежде", 1, 2 }, // 358 15546, pearspedat
    { true, 91, 3000000, 3000, "Девушка в свадебном платье", 4, 2 }, // 359 15547, pearspedau
    { true, 233, 1500000, 1000, "Беловолосая девушка в полушубе", 3, 2 }, // 360  15548, pearspedav
    { true, 216, 600000, 300, "Девушка в зеленом", 2, 2 }, // 361  15549, pearspedaw
    { true, 216, 0, 0, "Девушка в полотенце", 0, 2 }, // 362  15550, pearspedax
    { true, 93, 2300000, 1500, "Девушка в белой куртке", 3, 2 }, // 363 15551, pearspeday
    { true, 240, 0, 0, "Парень в рубахе", 0, 1 }, // 364  15552, pearspedaz male
    { true, 180, 200000, 80, "Парень в свитшоте с сердцем", 1, 1 }, // 365  15553, pearspedba male
    { true, 226, 1, 1, "Девушка в футболке", 0, 2 }, // 366  15554, pearspedbb
    { true, 60, 1, 1, "Парень в черном", 0, 1 }, // 367 15555, pearspedbc male
    { true, 257, 700000, 350, "Девушка в топе в сеточку", 2, 2 }, // 368  15556, pearspedbd
    { true, 257, 0, 0, "Проститутка", 0, 2 }, // 369  15557, pearspedbe
    { true, 41, 1, 1, "Девушка в белой куртке", 0, 2 }, // 370 15558, pearspedbf
    { true, 40, 1, 1, "Девушка в черном платье", 0, 2 }, // 371 15559, pearspedbg
    { true, 233, 0, 0, "Девушка в купальнике", 0, 2 }, // 372  15560, pearspedbh
    { true, 233, 0, 0, "Девушка в купальнике", 0, 2 }, // 373  15561, pearspedbi
    { true, 93, 800000, 400, "Девушка в черном платье", 2, 2 }, // 374 15562, pearspedbj
    { true, 233, 1000000, 500, "Девушка в розовой кофте", 2, 2 }, // 375  15563, pearspedbk
    { true, 98, 900000, 450, "Мужчина в пиджаке", 2, 1 }, // 376 15564, pearspedbl male
    { true, 98, 900000, 450, "Мужчина в синем костюме", 2, 1 }, // 377 15565, pearspedbm male
    { true, 98, 1500000, 1000, "Мужчина в черной куртке", 3, 1 }, // 378 15566, pearspedbn male
    { true, 98, 1200000, 800, "Мужчина в черном костюме", 3, 1 }, // 379 15567, pearspedbo male
    { true, 112, 800000, 400, "Лысый хрен в красных спортах", 2, 1 }, // 380 15568, pearspedbp male
    { true, 127, 600000, 300, "Мужчина в белом костюме", 2, 1 }, // 381 15569, pearspedbq male
    { true, 127, 500000, 250, "Мужчина в черном костюме", 2, 1 }, // 382 15570, pearspedbr male
    { true, 240, 300000, 120, "Парень в кофте", 1, 1 }, // 383 15571, pearspedbs male
    { true, 240, 300000, 120, "Парень в куртке", 1, 1 }, // 384 15572, pearspedbt male
    { true, 240, 400000, 200, "Парень в кофте", 2, 1 }, // 385 15573, pearspedbu male
    { true, 45, 250000, 100, "Парень с голым торсом", 1, 1 }, // 386 15574, pearspedbv male
    { true, 91, 400000, 200, "Девушка в топе и юбке", 2, 2 }, // 387 15575, pearspedbw
    { true, 98, 1000000, 500, "Мужчина в костюме", 2, 1 }, // 388 15576, pearspedbx male
    { true, 216, 1500000, 1000, "Девушка в розовой кофте", 3, 2 }, // 389 15577, pearspedby
    { true, 25, 1100000, 720, "Мужчина в белой одежде", 3, 1 }, // 390 15578, pearspedbz male
    { true, 120, 1000000, 750, "Мужчина в черной одежде", 3, 1 }, // 391 15579, pearspedca male
    { true, 179, 0, 0, "Мужчина в камуфляжной форме", 0, 1 }, // 392 15580, pearspedcb male
    { true, 233, 1, 1, "Девушка в спортивном стиле", 0, 2 }, // 393 15581, pearspedcc
    { true, 12, 700000, 350, "Девушка в голубой блузке", 2, 2 }, // 394 15582, pearspedcd
    { true, 40, 800000, 400, "Девушка в красном топе", 2, 2 }, // 395 15583, pearspedce
    { true, 85, 2000000, 1300, "Девушка в шубе", 3, 2 }, // 396 15584, pearspedcf
    { true, 233, 700000, 350, "Девушка в белом топе", 2, 2 }, // 397 15585, pearspedcg
    { true, 233, 800000, 400, "Девушка в розовой одежде", 2, 2 }, // 398 15586, pearspedct
    { true, 233, 700000, 350, "Девушка в белом топе", 2, 2 }, // 399 15587, pearspedch
    { true, 12, 900000, 450, "Девушка в черном пальто", 2, 2 }, // 400 15588, pearspedci
    { true, 217, 800000, 400, "Мужчина в черно-белой одежде", 2, 1 }, // 401 15589, pearspedcj male
    { true, 12, 2200000, 2200, "Ким Кардашьян", 4, 2 }, // 402 15590, pearspedck
    { true, 59, 1, 1, "Парень в простой одежде", 0, 1 }, // 403 15591, pearspedcl male
    { true, 93, 1500000, 1000, "Девушка в черных легинсах", 3, 2 }, // 404 15592, pearspedcm
    { true, 98, 2100000, 1400, "Парень в жилетке", 3, 1 }, // 405 15593, pearspedcn male
    { true, 143, 800000, 400, "Мужчина в куртке", 2, 1 }, // 406 15594, pearspedco male
    { true, 93, 1000000, 500, "Девушка в белых штанах", 2, 2 }, // 407 15595, pearspedcp
    { true, 91, 1100000, 550, "Девушка в красной куртке", 2, 2 }, // 408 15596, pearspedcq
    { true, 40, 1600000, 1050, "Девушка в Nike", 3, 2 }, // 409 15597, pearspedcr
    { true, 46, 2000000, 2000, "Мужчина в костюме", 4, 1 }, // 410 15598, pearspedcs
    { true, 40, 0, 0, "Девушка в парандже", 0, 2 }, // 411 15599, pedaraba
    { true, 221, 0, 0, "Мужчина в парандже", 0, 1 }, // 412 15600, pedarabb male
    { true, 142, 0, 0, "Мужчина в маске", 0, 1 }, // 413 15601, pedarabc male
    { true, 42, 0, 0, "Мужчина бандит", 0, 1 }, // 414 15602, prisonmex male
    { true, 311, 0, 0, "Полицейский", 0, 1 }, // 415 15603, pearscop male
    { true, 287, 0, 0, "Военный", 0, 1 }, // 416 15604, pearsarmy1 male
    { true, 287, 0, 0, "Военный", 0, 1 }, // 417 15605, pearsarmy2 male
    { true, 5, 0, 0, "Мужчина толстый", 0, 1 }, // 418 15606, pearsswat1 male (жирный араб)
    { true, 285, 0, 0, "Полицейский в броне", 0, 1 }, // 419 15607, pearsswat2 male
    { true, 300, 0, 0, "Полицейский", 0, 1 }, // 420 15608, pearscop2 male
    { true, 301, 0, 0, "Полицейский в броне", 0, 1 }, // 421 15609, pearsswat4 male
    { true, 300, 0, 0, "Полицейский в броне", 0, 1 }, // 422 15610, pearsswat5 male
    { true, 300, 0, 0, "Полицейский с кепкой", 0, 1 }, // 423 15611, pearscop3 male
    { true, 305, 1200000, 600, "Мужчина в красной рубашке", 2, 1 }, // 424 15612, pearscop4 male
    { true, 303, 0, 0, "Полицейский", 0, 1 }, // 425 15613, pearscop5 male
    { true, 142, 2000000, 12000, "Неизвестный в маске", 4, 0 }, // 426 15614, pearspedcv male
    { true, 221, 0, 0, "Неизвестный в белом", 0, 0 }, // 427 15615, pearspedcw male
    { true, 277, 0, 0, "Космонавт", 0, 0 }, // 428 15616, astronaut all
    { true, 6, 0, 0, "Маньяк Джейсон", 0, 1 }, // 429 15617, jason male
    { true, 21, 0, 0, "Парень в оранжевом комбинизоне", 0, 1 }, // 430 15618, prisonblack male
    { true, 141, 1800000, 1800, "Монахиня", 4, 2 }, // 431 15619, pearspedcx female
    { true, 144, 1500000, 1000, "Спортик", 3, 1 }, // 432 15620, pearspedcy male
    { true, 287, 0, 0, "Военный", 0, 1 }, // 433 15621, pearspedcz male
    { true, 146, 1600000, 1050, "Качок в майке", 3, 1 }, // 434 15622, pearspedda male
    { true, 42, 600000, 300, "Мужчина в спортивном костюме", 2, 1 }, // 435 15623, pearspeddb male
    { true, 287, 0, 0, "Полицейский", 0, 1 }, // 436 15624, pearspeddc male
    { true, 307, 0, 0, "Полицейский (жен.)", 0, 2 }, // 437 15625, pearspeddd female
    { true, 310, 0, 0, "Полицейский", 0, 1 }, // 438 15626, pearspedde male
    { true, 306, 0, 0, "Полицейский (жен.)", 0, 2 }, // 439 15627, pearscop6 female
    { true, 281, 0, 0, "Полицейский", 0, 1 }, // 440 15628, pearspeddf male
    { true, 280, 0, 0, "Полицейский", 0, 1 }, // 441 15629, pearspeddg male
    { true, 265, 0, 0, "Полицейский", 0, 1 }, // 442 15630, pearspeddh male
    { true, 310, 0, 0, "Полицейский", 0, 1 }, // 443 15631, pearspeddi male
    { true, 306, 0, 0, "Полицейский (жен.)", 0, 2 }, // 444 15632, pearspeddj female
    { true, 306, 0, 0, "Полицейский в шлеме (жен.)", 0, 2 }, // 445 15633, pearspeddk female
    { true, 282, 0, 0, "Полицейский", 0, 1 }, // 446 15634, pearspeddl male
    { true, 282, 0, 0, "Полицейский в очках", 0, 1 }, // 447 15635, pearspeddm male
    { true, 282, 0, 0, "Полицейский (галстук)", 0, 1 }, // 448 15636, pearspeddn male
    { true, 282, 0, 0, "Полицейский", 0, 1 }, // 449 15637, pearspeddo male
    { true, 282, 0, 0, "Полицейский", 0, 1 }, // 450 15638, pearspeddp male
    { true, 282, 0, 0, "Полицейский", 0, 1 }, // 451 15639, pearspeddq male
    { true, 306, 0, 0, "Полицейский (жен.)", 0, 2 }, // 452 15640, pearspeddr female
    { true, 121, 0, 0, "Доминик", 0, 1 }, // 453 15641, pearspedds male
    { true, 165, 0, 0, "Агент ФБР в бронежилете", 0, 1 }, // 454 15642, pearspeddt male
    { true, 286, 0, 0, "Агент ФБР", 0, 1 }, // 455 15643, pearspeddu male
    { true, 286, 0, 0, "Агент ФБР", 0, 1 }, // 456 15644, pearspeddv male
    { true, 295, 0, 0, "Агент ФБР", 0, 1 }, // 457 15645, pearspeddw male
    { true, 286, 0, 0, "Агент ФБР", 0, 1 }, // 458 15646, pearspeddx male
    { true, 286, 0, 0, "Агент ФБР", 0, 1 }, // 459 15647, pearspeddy male
    { true, 285, 0, 0, "Спецназ ФБР", 0, 0 }, // 460 15648, pearspeddz all
    { true, 285, 0, 0, "Спецназ ФБР", 0, 0 }, // 461 15649, pearspedea all
    { true, 165, 0, 0, "Спец.агент ФБР", 0, 1 }, // 462 15650, pearspedeb male
    { true, 286, 0, 0, "Агент ФБР", 0, 1 }, // 463 15651, pearspedec male
    { true, 286, 0, 0, "Агент ФБР", 0, 1 }, // 464 15652, pearspeded male
    { true, 150, 0, 0, "Агент ФБР (жен.)", 0, 2 }, // 465 15653, pearspedee female
    { true, 286, 0, 0, "Агент ФБР", 0, 1 }, // 466 15654, pearspedef male
    { true, 29, 1300000, 850, "Мужчина в белом худи", 3, 1 }, // 467 15655, zverworks male
    { true, 121, 0, 0, "Азиат с татуировками", 0, 1 }, // 468 15656, pearspedeg male Yakuza
    { true, 118, 0, 0, "Азиат в пиджаке", 0, 1 }, // 469 15657, pearspedeh male Yakuza
    { true, 123, 0, 0, "Мужчина в спортивках", 0, 1 }, // 470 15658, pearspedei male Yakuza
    { true, 118, 0, 0, "Мужчина в японском костюме", 0, 1 }, // 471 15659, pearspedej male Yakuza
    { true, 119, 0, 0, "Русский в куртке", 0, 1 }, // 472 15660, pearspedek male RM
    { true, 66, 800000, 400, "Мужчина в открытой рубашке", 2, 1 }, // 473 15661, pearspedel male
    { true, 60, 0, 0, "Русский с фингалом", 0, 1 }, // 474 15662, pearspedem male RM
    { true, 113, 0, 0, "Русский с крестом", 0, 1 }, // 475 15663, pearspeden male RM
    { true, 68, 1500000, 1000, "Дед в куртке", 3, 1 }, // 476 15664, pearspedeo male
    { true, 68, 2000000, 2000, "Дед в смокинге", 4, 1 }, // 477 15665, pearspedep male
    { true, 113, 1400000, 950, "Мужчина в тёмном", 3, 1 }, // 478 15666, pearspedeq male
    { true, 66, 800000, 400, "Парень в веселой футболке", 2, 1 }, // 479 15667, pearspeder male
    { true, 111, 0, 0, "Русский в темной куртке", 0, 1 }, // 480 15668, pearspedes male RM
    { true, 247, 1600000, 1050, "Мужчина с бородой", 3, 1 }, // 481 15669, pearspedet male
    { true, 46, 0, 0, "Русский в открытой рубашке", 0, 1 }, // 482 15670, pearspedeu male RM
    { true, 223, 2000000, 1300, "Мужчина в розовом пиджаке", 3, 1 }, // 483 15671, pearspedev male
    { true, 111, 0, 0, "Русский в кожаной куртке", 0, 1 }, // 484 15672, pearspedew male RM
    { true, 46, 0, 0, "Русский с татуировками", 0, 1 }, // 485 15673, pearspedex male RM
    { true, 60, 900000, 450, "Парень в балаклаве и очках", 2, 1 }, // 486 15674, pearspedey male
    { true, 29, 800000, 400, "Парень в майке", 2, 1 }, // 487 15675, pearspedfz male
    { true, 117, 0, 0, "Азиат в костюме", 0, 1 }, // 488  15676, pearspedfa male Yakuza
    { true, 121, 2200000, 1450, "Грозный мужчина", 3, 1 }, // 489  15677, pearspedfb male
    { true, 272, 0, 0, "Серьёзный русский", 0, 1 }, // 490  15678, pearspedfc male RM
    { true, 126, 0, 0, "Русский в костюме", 0, 1 }, // 491  15679, pearspedfd male RM
    { true, 125, 3000000, 2000, "Мужчина в белом костюме", 3, 1 }, // 492  15680, pearspedfe male
    { true, 294, 4000000, 4000, "Золотой Вузи", 4, 1 }, // 493  15681, pearspedff male
    { true, 285, 0, 0, "Армейский лётчик", 0, 1 }, // 494  15682, pearsvvs male
    { true, 70, 0, 0, "Доктор в очках", 0, 1 }, // 495 15683, pearsdoctor male
    { true, 308, 0, 0, "Сотрудник больницы (жен.)", 0, 2 }, // 496  15684, pearsmedg1 famale
    { true, 308, 0, 0, "Сотрудник больницы (жен.)", 0, 2 }, // 497  15685, pearsmedg2 famale
    { true, 308, 0, 0, "Сотрудник больницы (жен.)", 0, 2 }, // 498  15686, pearsmedg3 famale
    { true, 308, 0, 0, "Сотрудник больницы (жен.)", 0, 2 }, // 499  15687, pearsmedg4 famale
    { true, 275, 0, 0, "Сотрудник больницы", 0, 1 }, // 500  15688, pearsmedm1 male
    { true, 276, 0, 0, "Сотрудник больницы", 0, 1 }, // 501  15689, pearsmedm2 male
    { true, 275, 0, 0, "Сотрудник больницы", 0, 1 }, // 502  15690, pearsmedm3 male
    { true, 276, 0, 0, "Сотрудник больницы", 0, 1 }, // 503  15691, pearsmedm4 male
    { true, 274, 0, 0, "Сотрудник больницы", 0, 1 }, // 504  15692, pearsmedm5 male
    { true, 146, 0, 0, "Скромник", 0, 1 }, // 505  15693, pearsebalai male
    { true, 264, 0, 0, "Воплощенный вампир", 0, 1 }, // 506  15694, pearsvampir male
    { true, 168, 0, 0, "Маньяк", 0, 1 }, // 507  15695, pearsbenzop male
    { true, 130, 0, 0, "Овца", 0, 0 }, // 508  15696, pearsovechka -
    { true, 31, 0, 0, "Корова", 0, 0 }, // 509  15697, pearskorova -
    { true, 153, 0, 0, "Крик", 0, 0 }, // 510   15698, pearsscream -
    { true, 264, 0, 0, "Пенисвайз", 0, 0 }, // 511   15699, pearsclown -
    { true, 82, 0, 0, "Зомби", 0, 1 }, // 512  15700, pearszombie1 male
    { true, 83, 0, 0, "Зомби", 0, 1 }, // 513  15701, pearszombie2 male
    { true, 84, 0, 0, "Зомби", 0, 1 }, // 514  15702, pearszombie3 male
    { true, 82, 0, 0, "Зомби", 0, 1 }, // 515  15703, pearszombie4 male
    { true, 83, 0, 0, "Зомби", 0, 1 }, // 516  15704, pearszombie5 male
    { true, 75, 0, 0, "Зомби (жен.)", 0, 2 }, // 517  15705, pearszombie6 famale
    { true, 77, 0, 0, "Зомби (жен.)", 0, 2 }, // 518  15706, pearszombie7 famale
    { true, 82, 0, 0, "Зомби", 0, 1 }, // 519  15707, pearszombie8 male
    { true, 83, 0, 0, "Зомби", 0, 1 }, // 520  15708, pearszombie9 male
    { true, 59, 400000, 160, "Парень с челкой", 1, 1 }, // 521 pearskortu
    { true, 60, 600000, 240, "Парень в темной одежде", 1, 1 }, // 522 pearsmajodin
    { true, 98, 650000, 260, "Парень в белой футболке", 1, 1 }, // 523 pearsmajodva
    { true, 23, 700000, 280, "Парень в белом с цепью", 1, 1 }, // 524 pearsmajotri
    { true, 248, 1800000, 1200, "Мужчина в веселой жилетке", 3, 1 }, // 525 pearsjil
    { true, 247, 0, 0, "Парень в веселой жилетке", 0, 1 }, // 526 pearsjildva
    { true, 187, 1400000, 950, "Мужчина в пижаме", 3, 1 }, // 527 pearskosb
    { true, 91, 1200000, 800, "Девушка в платье", 3, 2 }, // 528 pearsmegno woman
    { true, 19, 1000000, 650, "Парень с полотенцем", 3, 1 }, // 529 pearsgheze
    { true, 93, 750000, 375, "Девушка в джинсах", 2, 2 }, // 530 pearswjns woman
    { true, 184, 700000, 350, "Пожилой в спортивном", 2, 1 }, // 531 pearsdedsp
    { true, 223, 1200000, 800, "Пожилой в костюме", 3, 1 }, // 532 pearssuitold
    { true, 186, 1350000, 900, "Пожилой в темном наряде", 3, 1 }, // 533 pearssuoldv
    { true, 208, 1000000, 500, "Мужчина в темном", 2, 1 }, // 534 pearsdetsu
    { true, 66, 600000, 300, "Парень в куртке", 2, 1 }, // 535 pearskurng
    { true, 80, 1400000, 950, "Боец UFC", 3, 1 }, // 536 pearsufcng
    { true, 109, 0, 0, "Бандит Vagos в темном", 0, 1 }, // 537 pearsvago vagos 
    { true, 110, 0, 0, "Бандит Vagos в кепке", 0, 1 }, // 538 pearsvagtr vagos
    { true, 106, 0, 0, "Бандит Grove в кепке", 0, 1 }, // 539 pearsgroveo Grove
    { true, 107, 0, 0, "Бандит Grove в куртке", 0, 1 }, // 540 pearsgrovet Grove
    { true, 195, 0, 0, "Бандит Grove (жен.)", 0, 2 }, // 541 pearsgroveg grove woman
    { true, 102, 0, 0, "Бандит Ballas", 0, 1 }, // 542 pearsballo ballas
    { true, 102, 0, 0, "Бандит Ballas в жилетке", 0, 1 }, // 543 pearsballt ballas
    { true, 13, 0, 0, "Бандит Ballas (жен.)", 0, 2 }, // 544 pearsballg ballas woman
    { true, 104, 0, 0, "Бандит Ballas в темном", 0, 1 }, // 545 pearsballtr ballas 
    { true, 91, 900000, 600, "Девушка в белом поло", 3, 2 }, // 546 pearsbecky woman
    { true, 42, 0, 0, "Неизв. в желтом комбинизоне", 0, 1 }, // 547 pearsorm 
    { true, 42, 0, 0, "Неизв. в противогазе", 0, 1 }, // 548 pearsorgm
    { true, 258, 1250000, 830, "Мужчина со шрамом", 3, 1 }, // 549 pearsamkr
    { true, 30, 900000, 450, "Парень в футболке с цепью", 2, 1 }, // 550 pearsrcep
    { true, 56, 500000, 200, "Женщина в зеленой блузке", 1, 2 }, // 551 pearsgigre woman
    { true, 259, 700000, 300, "Пожилой с весом в футболке", 1, 1 }, // 552 pearsolbat
    { true, 258, 800000, 320, "Пожилой в синей куртке", 1, 1 }, // 553 pearssimsui
    { true, 259, 800000, 400, "Пожилой в темно-синей рубашке", 2, 1 }, // 554 pearssimpol
    { true, 252, 850000, 425, "Пожилой в трусах", 2, 1 }, // 555 pearssimnud
    { true, 217, 1200000, 600, "Мужчина в темном", 2, 1 }, // 556 pearsardbl
    { true, 171, 1500000, 1000, "Мужчина в синем костюме", 3, 1 }, // 557 pearsardsui
    { true, 208, 1800000, 1200, "Мужчина в темно-полосатом костюме", 3, 1 }, // 558 pearsardsuib
    { true, 240, 1600000, 1050, "Мужчина в темно-полосатой жилетке", 3, 1 }, // 559 pearsardjil
    { true, 46, 3000000, 2000, "Мужчина в белом костюме с розой", 3, 1 }, // 560 pearsardjen
    { true, 223, 1100000, 750, "Мужчина в джинсовке", 3, 1 }, // 561 pearsardjens
    { true, 211, 1200000, 800, "Девушка в темно-короткой кофте", 3, 2 }, // 562 pearsgibl woman
    { true, 216, 1000000, 650, "Девушка в топе и шортах сердечки", 3, 2 }, // 563 pearsgipink woman 
    { true, 247, 1200000, 800, "Байкер в огненной футболке и жилетке", 3, 1 }, // 564 pearsgjo
    { true, 248, 1500000, 1000, "Байкер в поло и шортах-трико", 3, 1 }, // 565 pearsgjt
    { true, 254, 900000, 450, "Байкер в жилетке и белой футболке", 2, 1 }, // 566 pearsgjtr
    { true, 100, 1500000, 1000, "Байкер в жилетке и джинсах", 3, 1 }, // 567 pearsgjf
    { true, 113, 1800000, 1200, "Пожилой в темном костюме и цепью-крест", 3, 1 }, // 568 pearsvicbs
    { true, 111, 800000, 400, "Мужчина в болотной кофте", 2, 1 }, // 569 pearsvicsrg
    { true, 125, 1000000, 500, "Мужчина в куртке и спортивках", 2, 1 }, // 570 pearsvicrm
    { true, 144, 0, 0, "Террорист с камуфляжной шляпой", 0, 1 }, // 571 pearsterro
    { true, 143, 0, 0, "Террорист в бандане со шлемом", 0, 1 }, // 572 pearsterrt
    { true, 176, 0, 0, "Террорист в тюрбане и бронежилете", 0, 1 }, // 573 pearsterrtr
    { true, 177, 0, 0, "Террорист в камуфляжном бронежилете", 0, 1 }, // 574 pearsterrf
    { true, 177, 0, 0, "Террорист в тюрбане и камуфляжном бронежилете", 0, 1 }, // 575 pearsterrfm
    { true, 183, 0, 0, "Террорист в балаклаве и бронежилете", 0, 1 }, // 576 pearsterrfi
    { true, 241, 0, 0, "Террорист с зарядами РПГ", 0, 1 }, // 577 pearsterrs
    { true, 273, 1500000, 750, "Мужчина с голым торсом в татуировках", 2, 1 }, // 578 pearsmono
    { true, 184, 1600000, 800, "Мужчина в футболке череп с татуировками", 2, 1 }, // 579 pearsmont 
    { true, 119, 1200000, 600, "Байкер в темном с жилеткой", 2, 1 }, // 580 pearsmontr
    { true, 47, 1300000, 650, "Парень в белой футболке с цепью", 2, 1 }, // 581 pearsmonf
    { true, 45, 1400000, 900, "Татуированный мужчина с усами и голым торсом", 3, 1 }, // 582 pearsnudta
    { true, 300, 0, 0, "Полицейский", 0, 1 }, // 583 pearsguo
    { true, 300, 0, 0, "Полицейский", 0, 1 }, // 584 pearsgut
    { true, 301, 0, 0, "Полицейский", 0, 1 }, // 585 pearsgutr
    { true, 178, 2500000, 2500, "Кибер-женщина", 4, 2 }, // 586 fpearshall1
    { true, 178, 2500000, 2500, "Женщина в кошачьей маске с кнутом", 4, 2 }, // 587 fpearshall2
    { true, 152, 1500000, 1000, "Девушка в хэллоуинском костюме", 3, 2 }, // 588 fpearshall3
    { true, 90, 800000, 400, "Девушка в боди хэллоуин", 2, 2 }, // 589 fpearshall4
    { true, 195, 1300000, 850, "Девушка в футболке котик", 3, 2 }, // 590 fpearshall5
    { true, 90, 700000, 350, "Девушка в топе с летучими мышами", 2, 2 }, // 591 fpearshall6
    { true, 137, 1000000, 1000, "Бомж-убийца", 4, 1 }, // 592 mpearshall1
    { true, 252, 1200000, 800, "Садамаза мужик", 3, 1 }, // 593 mpearshall2
    { true, 264, 5000000, 900, "Карлик", 0, 1 }, // 594 mpearshall3
    { true, 258, 1200000, 120, "Франкенштейн", 0, 1 }, // 595 mpearshall4
    { true, 222, 7000000, 1000, "Мумия", 0, 1 }, // 596 mpearshall5
    { true, 212, 1000000, 650, "Бешенный деревенский", 3, 1 }, // 597 mpearshall6
    { true, 211, 750000, 350, "Девушка в черном", 2, 2 }, // 598 pearsranfem1
    { true, 214, 1100000, 750, "Девушка в белом", 3, 2 }, // 599 pearsranfem2
    { true, 101, 0, 0, "Мужчина в серой куртке", 0, 1 }, // 600 pearsranma1
    { true, 171, 0, 0, "Мужчина в черном с перчатками", 0, 1 }, // 601 pearsranma2
    { true, 167, 0, 0, "Анубис", 0, 1 }, // 602 pearsanubis
    { true, 1, 0, 0, "Скелет", 0, 0 }, // 603 pearsbfost
    { true, 7, 0, 0, "Призрак", 0, 0 }, // 604 pearsbmori
    { true, 162, 0, 0, "Медведь", 0, 0 }, // 605 pearsbear
    { true, 157, 0, 0, "Олень", 0, 0 }, // 606 pearsdeer
    { true, 157, 0, 0, "Лиса", 0, 0 }, // 607 pearsfox
    { true, 157, 0, 0, "Заяц", 0, 0 }, // 608 pearsrabbit
    { true, 162, 0, 0, "Волк", 0, 0 }, // 609 pearswolf
    { true, 145, 1500000, 7000, "Женщина в жёлтом комбинизоне", 4, 2 }, // 610 pearsfhaz
    { true, 146, 1500000, 7000, "Мужчина в жёлтом комбинизоне", 4, 1 }, // 611 pearsmhaz1
    { true, 144, 0, 0, "Мужчина в белом комбинизоне", 0, 1 }, // 612 pearsmhaz2
    { true, 146, 0, 0, "Парень в сером комбинизоне", 0, 1 }, // 613 pearsmhaz3
    { true, 30, 0, 0, "Уолтер Уайт", 0, 1 }, // 614 pearshaizenberg
    { true, 60, 0, 0, "Азиат в белой рубашке", 0, 1 }, // 615 pearskitaec
    { true, 111, 0, 0, "Мужчина в темном костюме", 0, 1 }, // 616 pearsruski1
    { true, 25, 0, 0, "Мужчина в пуховике с белой футболкой", 0, 1 }, // 617 pearswinneg
    { true, 191, 0, 0, "Девушка в зеленом комбинизоне", 0, 2 }, // 618 pearswarm1
    { true, 287, 0, 0, "Военный зимняя", 0, 1 }, // 619 pearswinarm1
    { true, 287, 0, 0, "Военный зимняя", 0, 1 }, // 620 pearswinarm2
    { true, 191, 0, 0, "Военный зимняя (жен.)", 0, 2 }, // 621 pearswinarw1
    { true, 216, 0, 0, "Девушка в оранжевой полушубе", 0, 2 }, // 622 pearswinw1
    { true, 150, 0, 0, "Женщина-врач", 0, 2 }, // 623 pearsdocw1
    { true, 193, 0, 0, "Девушка в новогоднем", 0, 2 }, // 624 pearswinw2
    { true, 179, 2000000, 10000, "Маскхалат", 4, 1 }, // 625 pearswinarm3
    { true, 152, 0, 0, "Белая кошка", 0, 0 }, // 626 pearscat1,
    { true, 152, 0, 0, "Рыжая кошка", 0, 0 }, // 627 pearscat2,
    { true, 152, 0, 0, "Серая кошка", 0, 0 }, // 628 pearscat3,
    { true, 152, 0, 0, "Сиамская кошка", 0, 0 }, // 629 pearscat4,
    { true, 152, 0, 0, "Пятнистая кошка", 0, 0 }, // 630 pearscat5,
    { true, 152, 0, 0, "Черная кошка", 0, 0 }, // 631 pearscat6,
    { true, 153, 0, 0, "Полосатый ротвейлер", 0, 0 }, // 632 pearsdog1,
    { true, 153, 0, 0, "Рыжий ротвейлер", 0, 0 }, // 633 pearsdog2,
    { true, 153, 0, 0, "Черный ротвейлер", 0, 0 }, // 634 pearsdog3,
    { true, 153, 0, 0, "Белый бостон терьер", 0, 0 }, // 635 pearsdog4,
    { true, 153, 0, 0, "Ротвейлер с зеленым ошейником", 0, 0 }, // 636 pearsdog5,
    { true, 153, 0, 0, "Черный бостон терьер", 0, 0 }, // 637 pearsdog6,
    { true, 153, 0, 0, "Рыжий стаффорд терьер", 0, 0 }, // 638 pearsdog7,
    { true, 153, 0, 0, "Черный доберман", 0, 0 }, // 639 pearsdog8,
    { true, 153, 0, 0, "Коричнево-белый бультерьер", 0, 0 }, // 640 pearsdog9,
    { true, 153, 0, 0, "Серо-белый бультерьер ", 0, 0 }, // 641 pearsdog10
    { true, 153, 0, 0, "Светло-коричневый шиба ину", 0, 0 }, // 642 pearsdog11
    { true, 153, 0, 0, "Серая немецкая овчарка", 0, 0 }, // 643 pearsdog12
    { true, 153, 0, 0, "Белый бультерьер", 0, 0 }, // 644 pearsdog13
    { true, 153, 0, 0, "Сибирский хаски", 0, 0 }, // 645 pearsdog14
    { true, 153, 0, 0, "Золотистый ретривер", 0, 0 }, // 646 pearsdog15
    { true, 153, 0, 0, "Коричнево-белый пойнтер", 0, 0 }, // 647 pearsdog16
    { true, 153, 0, 0, "Далматин", 0, 1 }, // 648 pearsdog17
    { true, 1, 0, 0, "Санта Клаус", 0, 2 }, // 649 pearssanta
    { true, 40, 2000000, 2000, "Женщина в розовом с шляпой", 4, 2 }, // 650 pearsfwint1
    { true, 55, 1300000, 850, "Женщина-байкер", 3, 2 }, // 651 pearsfwint2
    { true, 56, 700000, 350, "Женщина в пуховике", 2, 2 }, // 652 pearsfwint3
    { true, 55, 600000, 300, "Девушка в красной толстовке", 2, 2 }, // 653 pearsfwint4
    { true, 60, 800000, 400, "Парень в синей зимней куртке", 2, 1 }, // 654 pearsmwint1
    { true, 25, 600000, 300, "Парень в темном пуховике", 2, 1 }, // 655 pearsmwint2
    { true, 46, 1400000, 950, "Мужчина в шубе", 3, 1 }, // 656 pearsmwint3
    { true, 78, 0, 0, "Бомж Клаус", 0, 1 }, // 657 pearsmwint4
    { true, 93, 0, 0, "Женщина в спец. костюме", 0, 2 }, // 658 pearsfwp1  
    { true, 265, 0, 0, "Полицейский зимняя", 0, 1 }, // 659 pearsmwp1
    { true, 280, 0, 0, "Полицейский зимняя", 0, 1 }, // 660 pearsmwp2
    { true, 281, 0, 0, "Полицейский в кепке зимняя", 0, 1 }, // 661 pearsmwp3
    { true, 280, 0, 0, "Полицейский в шапке зимняя", 0, 1 }, // 662 pearsmwp4
    { true, 266, 0, 0, "Полицейский зимняя", 0, 1 } // 663 pearsmwp5
};

#define MAX_MODELS_SKIN sizeof(SkinPearsInfo)

// Добавляем скины в мод при запуске сервера
stock AddCustomSkins()
{
	for(new s = 311; s < sizeof(SkinPearsInfo); s++)
	{
		if(SkinPearsInfo[s][eCustomSkin] == true)
		{
			AddCharSyncModel(SkinPearsInfo[s][eSampSkinID], s);
		}
	}
    return 1;
}

stock IsSpecialSystemSkin(skinid)
{
	// Скромник (SCP)
	if (skinid == 505) return 1;
	// Горилла, Маньяк, Овца, Корова, Крик, Пеннивайз
	if (skinid >= 506 && skinid <= 511) return 1;
	// Хеллоуин
	if (skinid >= 594 && skinid <= 596) return 1;
	// Зомби
	if (skinid >= 512 && skinid <= 520) return 1;
	// Раскопка могил и гробница
	if (skinid >= 602 && skinid <= 604) return 1;
	// Звери
	if (skinid >= 605 && skinid <= 609) return 1;
	// Домашние животные + Санта
	if (skinid >= 626 && skinid <= 649) return 1;
	return 0;
}

stock DeleteSpecialSystemSkins(playerid)
{
	if (IsPlayerNPC(playerid)) return 0;
	
	if (IsSpecialSystemSkin(PlayerInfo[playerid][pModel])) {
		TakeOffClothes(playerid);
	}
	for(new i = 0; i < 40; i++)
	{
		if (PlayerInfo[playerid][pInvenType][i] != 3) continue;
		new quan = PlayerInfo[playerid][pInvenQuan][i];
		if (quan < 1) continue;
		new skinid = PlayerInfo[playerid][pInven][i];
		if (IsSpecialSystemSkin(skinid)) {
			TakeInvent(playerid, skinid, quan, 3, i);
		}
	}
	return 1;
}

// Получаем пол по скину
stock GetSkinSex(s)
{
	if(SkinPearsInfo[s][eSkinSex] == 1) return 1; // 1 - мужской скин
	else if(SkinPearsInfo[s][eSkinSex] == 2) return 2; // 2 - женский скин
	else return 0; // Не имеет пола (подходит для мужчин и женщин)
}

// Сюда добавляются скины для организаций (Максимально 50 слотов, значит 49 ПОСЛЕДНИЙ)
forward ReloadSkin(playerid, g);
public ReloadSkin(playerid, g)
{
	for(new i = 0; i < MAX_SKIN_ORGANIZATION; i++) OrganInfo[g][gSkin][i] = 0;

	if(g == 1 || g == 11 || g == 21 || g == 22) // SAPD
	{
		OrganInfo[g][gSkin][0] = 300, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 284, OrganInfo[g][gSkinPrice][1] = 10000, OrganInfo[g][gSkinRank][1] = 2;
		OrganInfo[g][gSkin][2] = 301, OrganInfo[g][gSkinPrice][2] = 20000, OrganInfo[g][gSkinRank][2] = 3;
		OrganInfo[g][gSkin][3] = 302, OrganInfo[g][gSkinPrice][3] = 30000, OrganInfo[g][gSkinRank][3] = 4;
		OrganInfo[g][gSkin][4] = 265, OrganInfo[g][gSkinPrice][4] = 40000, OrganInfo[g][gSkinRank][4] = 10;
		OrganInfo[g][gSkin][5] = 266, OrganInfo[g][gSkinPrice][5] = 50000, OrganInfo[g][gSkinRank][5] = 10;
		OrganInfo[g][gSkin][6] = 267, OrganInfo[g][gSkinPrice][6] = 60000, OrganInfo[g][gSkinRank][6] = 10;
		OrganInfo[g][gSkin][7] = 303, OrganInfo[g][gSkinPrice][7] = 70000, OrganInfo[g][gSkinRank][7] = 6;
		OrganInfo[g][gSkin][8] = 304, OrganInfo[g][gSkinPrice][8] = 80000, OrganInfo[g][gSkinRank][8] = 6;
		OrganInfo[g][gSkin][9] = 305, OrganInfo[g][gSkinPrice][9] = 90000, OrganInfo[g][gSkinRank][9] = 6;
		OrganInfo[g][gSkin][10] = 310, OrganInfo[g][gSkinPrice][10] = 100000, OrganInfo[g][gSkinRank][10] = 14;
		OrganInfo[g][gSkin][11] = 311, OrganInfo[g][gSkinPrice][11] = 150000, OrganInfo[g][gSkinRank][11] = 14;
		OrganInfo[g][gSkin][12] = 306, OrganInfo[g][gSkinPrice][12] = 0, OrganInfo[g][gSkinRank][12] = 1;
		OrganInfo[g][gSkin][13] = 307, OrganInfo[g][gSkinPrice][13] = 10000, OrganInfo[g][gSkinRank][13] = 5;
		OrganInfo[g][gSkin][14] = 309, OrganInfo[g][gSkinPrice][14] = 50000, OrganInfo[g][gSkinRank][14] = 10;
		OrganInfo[g][gSkin][15] = 150, OrganInfo[g][gSkinPrice][15] = 100000, OrganInfo[g][gSkinRank][15] = 14;
		OrganInfo[g][gSkin][16] = 423, OrganInfo[g][gSkinPrice][16] = 10000, OrganInfo[g][gSkinRank][16] = 1;
		OrganInfo[g][gSkin][17] = 420, OrganInfo[g][gSkinPrice][17] = 10000, OrganInfo[g][gSkinRank][17] = 1;
		OrganInfo[g][gSkin][18] = 424, OrganInfo[g][gSkinPrice][18] = 100000, OrganInfo[g][gSkinRank][18] = 10;
		OrganInfo[g][gSkin][19] = 425, OrganInfo[g][gSkinPrice][19] = 100000, OrganInfo[g][gSkinRank][19] = 10;
		OrganInfo[g][gSkin][20] = 415, OrganInfo[g][gSkinPrice][20] = 200000, OrganInfo[g][gSkinRank][20] = 14;
		OrganInfo[g][gSkin][21] = 440, OrganInfo[g][gSkinPrice][21] = 30000, OrganInfo[g][gSkinRank][21] = 2;
		OrganInfo[g][gSkin][22] = 441, OrganInfo[g][gSkinPrice][22] = 30000, OrganInfo[g][gSkinRank][22] = 2;
		OrganInfo[g][gSkin][23] = 442, OrganInfo[g][gSkinPrice][23] = 90000, OrganInfo[g][gSkinRank][23] = 5;
		OrganInfo[g][gSkin][24] = 443, OrganInfo[g][gSkinPrice][24] = 250000, OrganInfo[g][gSkinRank][24] = 14;
		OrganInfo[g][gSkin][25] = 444, OrganInfo[g][gSkinPrice][25] = 250000, OrganInfo[g][gSkinRank][25] = 14;
		OrganInfo[g][gSkin][26] = 285, OrganInfo[g][gSkinPrice][26] = 0, OrganInfo[g][gSkinRank][26] = 1;
		OrganInfo[g][gSkin][27] = 419, OrganInfo[g][gSkinPrice][27] = 10000, OrganInfo[g][gSkinRank][27] = 5;
		OrganInfo[g][gSkin][28] = 421, OrganInfo[g][gSkinPrice][28] = 20000, OrganInfo[g][gSkinRank][28] = 6;
		OrganInfo[g][gSkin][29] = 422, OrganInfo[g][gSkinPrice][29] = 20000, OrganInfo[g][gSkinRank][29] = 6;
		OrganInfo[g][gSkin][30] = 445, OrganInfo[g][gSkinPrice][30] = 10000, OrganInfo[g][gSkinRank][30] = 2;
		// Для LVPD
		OrganInfo[g][gSkin][32] = 446, OrganInfo[g][gSkinPrice][32] = 30000, OrganInfo[g][gSkinRank][32] = 2;
		OrganInfo[g][gSkin][33] = 447, OrganInfo[g][gSkinPrice][33] = 30000, OrganInfo[g][gSkinRank][33] = 2;
		OrganInfo[g][gSkin][34] = 448, OrganInfo[g][gSkinPrice][34] = 90000, OrganInfo[g][gSkinRank][34] = 5;
		OrganInfo[g][gSkin][35] = 449, OrganInfo[g][gSkinPrice][35] = 90000, OrganInfo[g][gSkinRank][35] = 5;
		OrganInfo[g][gSkin][36] = 450, OrganInfo[g][gSkinPrice][36] = 90000, OrganInfo[g][gSkinRank][36] = 5;
		OrganInfo[g][gSkin][37] = 451, OrganInfo[g][gSkinPrice][37] = 90000, OrganInfo[g][gSkinRank][37] = 5;
		OrganInfo[g][gSkin][38] = 452, OrganInfo[g][gSkinPrice][38] = 30000, OrganInfo[g][gSkinRank][38] = 2;
		OrganInfo[g][gSkin][39] = 443, OrganInfo[g][gSkinPrice][39] = 250000, OrganInfo[g][gSkinRank][39] = 14;
		OrganInfo[g][gSkin][40] = 444, OrganInfo[g][gSkinPrice][40] = 250000, OrganInfo[g][gSkinRank][40] = 14;
		OrganInfo[g][gSkin][41] = 583, OrganInfo[g][gSkinPrice][41] = 50000, OrganInfo[g][gSkinRank][41] = 3;
		OrganInfo[g][gSkin][42] = 584, OrganInfo[g][gSkinPrice][42] = 50000, OrganInfo[g][gSkinRank][42] = 3;
		OrganInfo[g][gSkin][43] = 585, OrganInfo[g][gSkinPrice][43] = 50000, OrganInfo[g][gSkinRank][43] = 3;
		// зимние
		OrganInfo[g][gSkin][44] = 658, OrganInfo[g][gSkinPrice][44] = 10000, OrganInfo[g][gSkinRank][44] = 1;
		OrganInfo[g][gSkin][45] = 659, OrganInfo[g][gSkinPrice][45] = 70000, OrganInfo[g][gSkinRank][45] = 5;
		OrganInfo[g][gSkin][46] = 660, OrganInfo[g][gSkinPrice][46] = 30000, OrganInfo[g][gSkinRank][46] = 2;
		OrganInfo[g][gSkin][47] = 661, OrganInfo[g][gSkinPrice][47] = 10000, OrganInfo[g][gSkinRank][47] = 1;
		OrganInfo[g][gSkin][48] = 662, OrganInfo[g][gSkinPrice][48] = 10000, OrganInfo[g][gSkinRank][48] = 1;
		OrganInfo[g][gSkin][49] = 663, OrganInfo[g][gSkinPrice][49] = 10000, OrganInfo[g][gSkinRank][49] = 1;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 2) // FBI
	{
        // Custom
        OrganInfo[g][gSkin][0] = 454, OrganInfo[g][gSkinPrice][0] = 30000, OrganInfo[g][gSkinRank][0] = 7;
        OrganInfo[g][gSkin][1] = 455, OrganInfo[g][gSkinPrice][1] = 0, OrganInfo[g][gSkinRank][1] = 1;
        OrganInfo[g][gSkin][2] = 456, OrganInfo[g][gSkinPrice][2] = 0, OrganInfo[g][gSkinRank][2] = 1;
        OrganInfo[g][gSkin][3] = 457, OrganInfo[g][gSkinPrice][3] = 0, OrganInfo[g][gSkinRank][3] = 1;
        OrganInfo[g][gSkin][4] = 458, OrganInfo[g][gSkinPrice][4] = 0, OrganInfo[g][gSkinRank][4] = 1;
        OrganInfo[g][gSkin][5] = 459, OrganInfo[g][gSkinPrice][5] = 0, OrganInfo[g][gSkinRank][5] = 1;
        OrganInfo[g][gSkin][6] = 460, OrganInfo[g][gSkinPrice][6] = 10000, OrganInfo[g][gSkinRank][6] = 3;
        OrganInfo[g][gSkin][7] = 461, OrganInfo[g][gSkinPrice][7] = 10000, OrganInfo[g][gSkinRank][7] = 3;
        OrganInfo[g][gSkin][8] = 462, OrganInfo[g][gSkinPrice][8] = 25000, OrganInfo[g][gSkinRank][8] = 6;
        OrganInfo[g][gSkin][9] = 463, OrganInfo[g][gSkinPrice][9] = 35000, OrganInfo[g][gSkinRank][9] = 7;
        OrganInfo[g][gSkin][10] = 464, OrganInfo[g][gSkinPrice][10] = 35000, OrganInfo[g][gSkinRank][10] = 7;
        OrganInfo[g][gSkin][11] = 465, OrganInfo[g][gSkinPrice][11] = 0, OrganInfo[g][gSkinRank][11] = 1;
        OrganInfo[g][gSkin][12] = 466, OrganInfo[g][gSkinPrice][12] = 35000, OrganInfo[g][gSkinRank][12] = 7;
        // Old скины
		OrganInfo[g][gSkin][13] = 286, OrganInfo[g][gSkinPrice][13] = 0, OrganInfo[g][gSkinRank][13] = 1;
		OrganInfo[g][gSkin][14] = 164, OrganInfo[g][gSkinPrice][14] = 50000, OrganInfo[g][gSkinRank][14] = 5;
		OrganInfo[g][gSkin][15] = 165, OrganInfo[g][gSkinPrice][15] = 100000, OrganInfo[g][gSkinRank][15] = 10;
		OrganInfo[g][gSkin][16] = 166, OrganInfo[g][gSkinPrice][16] = 150000, OrganInfo[g][gSkinRank][16] = 10;
		OrganInfo[g][gSkin][17] = 141, OrganInfo[g][gSkinPrice][17] = 0, OrganInfo[g][gSkinRank][17] = 1;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 3) // NGSA
	{
		OrganInfo[g][gSkin][0] = 73, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 287, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 2;
		OrganInfo[g][gSkin][2] = 179, OrganInfo[g][gSkinPrice][2] = 50000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 253, OrganInfo[g][gSkinPrice][3] = 70000, OrganInfo[g][gSkinRank][3] = 10;
		OrganInfo[g][gSkin][4] = 61, OrganInfo[g][gSkinPrice][4] = 100000, OrganInfo[g][gSkinRank][4] = 12;
		OrganInfo[g][gSkin][5] = 295, OrganInfo[g][gSkinPrice][5] = 150000, OrganInfo[g][gSkinRank][5] = 18;
		OrganInfo[g][gSkin][6] = 191, OrganInfo[g][gSkinPrice][6] = 0, OrganInfo[g][gSkinRank][6] = 0;
		OrganInfo[g][gSkin][7] = 141, OrganInfo[g][gSkinPrice][7] = 0, OrganInfo[g][gSkinRank][7] = 10;
		OrganInfo[g][gSkin][8] = 392, OrganInfo[g][gSkinPrice][8] = 200000, OrganInfo[g][gSkinRank][8] = 10;
		OrganInfo[g][gSkin][9] = 416, OrganInfo[g][gSkinPrice][9] = 170000, OrganInfo[g][gSkinRank][9] = 10;
		OrganInfo[g][gSkin][10] = 417, OrganInfo[g][gSkinPrice][10] = 290000, OrganInfo[g][gSkinRank][10] = 10;
		OrganInfo[g][gSkin][11] = 433, OrganInfo[g][gSkinPrice][11] = 190000, OrganInfo[g][gSkinRank][11] = 5;
		OrganInfo[g][gSkin][12] = 436, OrganInfo[g][gSkinPrice][12] = 90000, OrganInfo[g][gSkinRank][12] = 10;
		OrganInfo[g][gSkin][13] = 437, OrganInfo[g][gSkinPrice][13] = 90000, OrganInfo[g][gSkinRank][13] = 10;
		OrganInfo[g][gSkin][14] = 438, OrganInfo[g][gSkinPrice][14] = 90000, OrganInfo[g][gSkinRank][14] = 10;
		OrganInfo[g][gSkin][15] = 439, OrganInfo[g][gSkinPrice][15] = 90000, OrganInfo[g][gSkinRank][15] = 10;
		OrganInfo[g][gSkin][16] = 494, OrganInfo[g][gSkinPrice][16] = 20000, OrganInfo[g][gSkinRank][16] = 2;
		OrganInfo[g][gSkin][17] = 618, OrganInfo[g][gSkinPrice][17] = 20000, OrganInfo[g][gSkinRank][17] = 2;
		OrganInfo[g][gSkin][18] = 619, OrganInfo[g][gSkinPrice][18] = 20000, OrganInfo[g][gSkinRank][18] = 2;
		OrganInfo[g][gSkin][19] = 620, OrganInfo[g][gSkinPrice][19] = 20000, OrganInfo[g][gSkinRank][19] = 2;
		OrganInfo[g][gSkin][20] = 621, OrganInfo[g][gSkinPrice][20] = 20000, OrganInfo[g][gSkinRank][20] = 2;
		OrganInfo[g][gSkin][21] = 625, OrganInfo[g][gSkinPrice][21] = 20000, OrganInfo[g][gSkinRank][21] = 2;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 4) // ASGH (Медики)
	{
		OrganInfo[g][gSkin][0] = 274, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 275, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 3;
		OrganInfo[g][gSkin][2] = 276, OrganInfo[g][gSkinPrice][2] = 50000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 156, OrganInfo[g][gSkinPrice][3] = 70000, OrganInfo[g][gSkinRank][3] = 7;
		OrganInfo[g][gSkin][4] = 70, OrganInfo[g][gSkinPrice][4] = 100000, OrganInfo[g][gSkinRank][4] = 10;
		OrganInfo[g][gSkin][5] = 308, OrganInfo[g][gSkinPrice][5] = 0, OrganInfo[g][gSkinRank][5] = 0;
		OrganInfo[g][gSkin][6] = 219, OrganInfo[g][gSkinPrice][6] = 70000, OrganInfo[g][gSkinRank][6] = 10;
		OrganInfo[g][gSkin][7] = 495, OrganInfo[g][gSkinPrice][7] = 90000, OrganInfo[g][gSkinRank][7] = 7;
		OrganInfo[g][gSkin][8] = 496, OrganInfo[g][gSkinPrice][8] = 10000, OrganInfo[g][gSkinRank][8] = 1;
		OrganInfo[g][gSkin][9] = 497, OrganInfo[g][gSkinPrice][9] = 10000, OrganInfo[g][gSkinRank][9] = 1;
		OrganInfo[g][gSkin][10] = 498, OrganInfo[g][gSkinPrice][10] = 10000, OrganInfo[g][gSkinRank][10] = 1;
		OrganInfo[g][gSkin][11] = 499, OrganInfo[g][gSkinPrice][11] = 10000, OrganInfo[g][gSkinRank][11] = 1;
		OrganInfo[g][gSkin][12] = 500, OrganInfo[g][gSkinPrice][12] = 10000, OrganInfo[g][gSkinRank][12] = 1;
		OrganInfo[g][gSkin][13] = 501, OrganInfo[g][gSkinPrice][13] = 10000, OrganInfo[g][gSkinRank][13] = 1;
		OrganInfo[g][gSkin][14] = 502, OrganInfo[g][gSkinPrice][14] = 10000, OrganInfo[g][gSkinRank][14] = 1;
		OrganInfo[g][gSkin][15] = 503, OrganInfo[g][gSkinPrice][15] = 10000, OrganInfo[g][gSkinRank][15] = 1;
		OrganInfo[g][gSkin][16] = 504, OrganInfo[g][gSkinPrice][16] = 10000, OrganInfo[g][gSkinRank][16] = 1;
		OrganInfo[g][gSkin][17] = 623, OrganInfo[g][gSkinPrice][17] = 10000, OrganInfo[g][gSkinRank][17] = 1;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 5) // Cosa Nostra
	{
		OrganInfo[g][gSkin][0] = 124, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 126, OrganInfo[g][gSkinPrice][1] = 20000, OrganInfo[g][gSkinRank][1] = 2;
		OrganInfo[g][gSkin][2] = 127, OrganInfo[g][gSkinPrice][2] = 30000, OrganInfo[g][gSkinRank][2] = 3;
		OrganInfo[g][gSkin][3] = 185, OrganInfo[g][gSkinPrice][3] = 40000, OrganInfo[g][gSkinRank][3] = 4;
		OrganInfo[g][gSkin][4] = 98, OrganInfo[g][gSkinPrice][4] = 70000, OrganInfo[g][gSkinRank][4] = 6;
		OrganInfo[g][gSkin][5] = 223, OrganInfo[g][gSkinPrice][5] = 70000, OrganInfo[g][gSkinRank][5] = 7;
		OrganInfo[g][gSkin][6] = 94, OrganInfo[g][gSkinPrice][6] = 70000, OrganInfo[g][gSkinRank][6] = 7;
		OrganInfo[g][gSkin][7] = 113, OrganInfo[g][gSkinPrice][7] = 100000, OrganInfo[g][gSkinRank][7] = 8;
		OrganInfo[g][gSkin][8] = 12, OrganInfo[g][gSkinPrice][8] = 0, OrganInfo[g][gSkinRank][8] = 1;
		OrganInfo[g][gSkin][9] = 214, OrganInfo[g][gSkinPrice][9] = 100000, OrganInfo[g][gSkinRank][9] = 8;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 6) // Yakuza Mafia
	{
		OrganInfo[g][gSkin][0] = 468, OrganInfo[g][gSkinPrice][0] = 50000, OrganInfo[g][gSkinRank][0] = 3;
		OrganInfo[g][gSkin][1] = 469, OrganInfo[g][gSkinPrice][1] = 0, OrganInfo[g][gSkinRank][1] = 1;
		OrganInfo[g][gSkin][2] = 470, OrganInfo[g][gSkinPrice][2] = 90000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 471, OrganInfo[g][gSkinPrice][3] = 90000, OrganInfo[g][gSkinRank][3] = 6;
		OrganInfo[g][gSkin][4] = 488, OrganInfo[g][gSkinPrice][4] = 70000, OrganInfo[g][gSkinRank][4] = 6;
		
		OrganInfo[g][gSkin][5] = 122, OrganInfo[g][gSkinPrice][5] = 0, OrganInfo[g][gSkinRank][5] = 1;
		OrganInfo[g][gSkin][6] = 123, OrganInfo[g][gSkinPrice][6] = 40000, OrganInfo[g][gSkinRank][6] = 4;
		OrganInfo[g][gSkin][7] = 203, OrganInfo[g][gSkinPrice][7] = 50000, OrganInfo[g][gSkinRank][7] = 5;
		OrganInfo[g][gSkin][8] = 49, OrganInfo[g][gSkinPrice][8] = 100000, OrganInfo[g][gSkinRank][8] = 8;
		OrganInfo[g][gSkin][9] = 55, OrganInfo[g][gSkinPrice][9] = 0, OrganInfo[g][gSkinRank][9] = 0;
		OrganInfo[g][gSkin][10] = 169, OrganInfo[g][gSkinPrice][10] = 100000, OrganInfo[g][gSkinRank][10] = 8;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 7) // Правительство
	{
		OrganInfo[g][gSkin][0] = 255, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 163, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 1;
		OrganInfo[g][gSkin][2] = 187, OrganInfo[g][gSkinPrice][2] = 40000, OrganInfo[g][gSkinRank][2] = 1;
		OrganInfo[g][gSkin][3] = 240, OrganInfo[g][gSkinPrice][3] = 60000, OrganInfo[g][gSkinRank][3] = 6;
		OrganInfo[g][gSkin][4] = 57, OrganInfo[g][gSkinPrice][4] = 70000, OrganInfo[g][gSkinRank][4] = 7;
		OrganInfo[g][gSkin][5] = 227, OrganInfo[g][gSkinPrice][5] = 100000, OrganInfo[g][gSkinRank][5] = 7;
		OrganInfo[g][gSkin][6] = 228, OrganInfo[g][gSkinPrice][6] = 100000, OrganInfo[g][gSkinRank][6] = 7;
		OrganInfo[g][gSkin][7] = 147, OrganInfo[g][gSkinPrice][7] = 100000, OrganInfo[g][gSkinRank][7] = 7;
		OrganInfo[g][gSkin][8] = 290, OrganInfo[g][gSkinPrice][8] = 100000, OrganInfo[g][gSkinRank][8] = 7;
		OrganInfo[g][gSkin][9] = 295, OrganInfo[g][gSkinPrice][9] = 100000, OrganInfo[g][gSkinRank][9] = 7;
		OrganInfo[g][gSkin][10] = 68, OrganInfo[g][gSkinPrice][10] = 100000, OrganInfo[g][gSkinRank][10] = 15;
		OrganInfo[g][gSkin][11] = 194, OrganInfo[g][gSkinPrice][11] = 0, OrganInfo[g][gSkinRank][11] = 1;
		OrganInfo[g][gSkin][12] = 150, OrganInfo[g][gSkinPrice][12] = 30000, OrganInfo[g][gSkinRank][12] = 1;
		OrganInfo[g][gSkin][13] = 141, OrganInfo[g][gSkinPrice][13] = 50000, OrganInfo[g][gSkinRank][13] = 5;
		OrganInfo[g][gSkin][14] = 91, OrganInfo[g][gSkinPrice][14] = 100000, OrganInfo[g][gSkinRank][14] = 15;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 8) // ICA
	{
		OrganInfo[g][gSkin][0] = 33, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 29, OrganInfo[g][gSkinPrice][1] = 1, OrganInfo[g][gSkinRank][1] = 11;
		OrganInfo[g][gSkin][2] = 208, OrganInfo[g][gSkinPrice][2] = 1, OrganInfo[g][gSkinRank][2] = 11;
		OrganInfo[g][gSkin][3] = 294, OrganInfo[g][gSkinPrice][3] = 1, OrganInfo[g][gSkinRank][3] = 11;
		OrganInfo[g][gSkin][4] = 285, OrganInfo[g][gSkinPrice][4] = 1, OrganInfo[g][gSkinRank][4] = 11;
		OrganInfo[g][gSkin][5] = 11, OrganInfo[g][gSkinPrice][5] = 0, OrganInfo[g][gSkinRank][5] = 1;
		OrganInfo[g][gSkin][6] = 211, OrganInfo[g][gSkinPrice][6] = 1, OrganInfo[g][gSkinRank][6] = 11;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 9) // CNN
	{
		OrganInfo[g][gSkin][0] = 188, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 186, OrganInfo[g][gSkinPrice][1] = 20000, OrganInfo[g][gSkinRank][1] = 2;
		OrganInfo[g][gSkin][2] = 291, OrganInfo[g][gSkinPrice][2] = 30000, OrganInfo[g][gSkinRank][2] = 3;
		OrganInfo[g][gSkin][3] = 297, OrganInfo[g][gSkinPrice][3] = 50000, OrganInfo[g][gSkinRank][3] = 5;
		OrganInfo[g][gSkin][4] = 290, OrganInfo[g][gSkinPrice][4] = 100000, OrganInfo[g][gSkinRank][4] = 8;
		OrganInfo[g][gSkin][5] = 148, OrganInfo[g][gSkinPrice][5] = 0, OrganInfo[g][gSkinRank][5] = 1;
		OrganInfo[g][gSkin][6] = 12, OrganInfo[g][gSkinPrice][6] = 30000, OrganInfo[g][gSkinRank][6] = 3;
		OrganInfo[g][gSkin][7] = 76, OrganInfo[g][gSkinPrice][7] = 50000, OrganInfo[g][gSkinRank][7] = 8;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 10) // Triada Mafia
	{
		OrganInfo[g][gSkin][0] = 117, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 118, OrganInfo[g][gSkinPrice][1] = 20000, OrganInfo[g][gSkinRank][1] = 2;
		OrganInfo[g][gSkin][2] = 120, OrganInfo[g][gSkinPrice][2] = 30000, OrganInfo[g][gSkinRank][2] = 3;
		OrganInfo[g][gSkin][3] = 208, OrganInfo[g][gSkinPrice][3] = 50000, OrganInfo[g][gSkinRank][3] = 5;
		OrganInfo[g][gSkin][4] = 204, OrganInfo[g][gSkinPrice][4] = 70000, OrganInfo[g][gSkinRank][4] = 7;
		OrganInfo[g][gSkin][5] = 229, OrganInfo[g][gSkinPrice][5] = 100000, OrganInfo[g][gSkinRank][5] = 8;
		OrganInfo[g][gSkin][6] = 263, OrganInfo[g][gSkinPrice][6] = 0, OrganInfo[g][gSkinRank][6] = 1;
		OrganInfo[g][gSkin][7] = 225, OrganInfo[g][gSkinPrice][7] = 50000, OrganInfo[g][gSkinRank][7] = 8;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 12) // Russian Mafia
	{
		OrganInfo[g][gSkin][0] = 472, OrganInfo[g][gSkinPrice][0] = 70000, OrganInfo[g][gSkinRank][0] = 8;
		OrganInfo[g][gSkin][1] = 474, OrganInfo[g][gSkinPrice][1] = 0, OrganInfo[g][gSkinRank][1] = 1;
		OrganInfo[g][gSkin][2] = 475, OrganInfo[g][gSkinPrice][2] = 30000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 480, OrganInfo[g][gSkinPrice][3] = 40000, OrganInfo[g][gSkinRank][3] = 3;
		OrganInfo[g][gSkin][4] = 482, OrganInfo[g][gSkinPrice][4] = 80000, OrganInfo[g][gSkinRank][4] = 7;
		OrganInfo[g][gSkin][5] = 484, OrganInfo[g][gSkinPrice][5] = 19000, OrganInfo[g][gSkinRank][5] = 2;
		OrganInfo[g][gSkin][6] = 485, OrganInfo[g][gSkinPrice][6] = 95000, OrganInfo[g][gSkinRank][6] = 6;
		OrganInfo[g][gSkin][7] = 490, OrganInfo[g][gSkinPrice][7] = 60000, OrganInfo[g][gSkinRank][7] = 6;
		OrganInfo[g][gSkin][8] = 491, OrganInfo[g][gSkinPrice][8] = 80000, OrganInfo[g][gSkinRank][8] = 7;

		OrganInfo[g][gSkin][9] = 112, OrganInfo[g][gSkinPrice][9] = 0, OrganInfo[g][gSkinRank][9] = 1;
		OrganInfo[g][gSkin][10] = 111, OrganInfo[g][gSkinPrice][10] = 20000, OrganInfo[g][gSkinRank][10] = 2;
		OrganInfo[g][gSkin][11] = 125, OrganInfo[g][gSkinPrice][11] = 30000, OrganInfo[g][gSkinRank][11] = 3;
		OrganInfo[g][gSkin][12] = 46, OrganInfo[g][gSkinPrice][12] = 50000, OrganInfo[g][gSkinRank][12] = 5;
		OrganInfo[g][gSkin][13] = 272, OrganInfo[g][gSkinPrice][13] = 100000, OrganInfo[g][gSkinRank][13] = 8;
		OrganInfo[g][gSkin][14] = 192, OrganInfo[g][gSkinPrice][14] = 0, OrganInfo[g][gSkinRank][14] = 1;
		OrganInfo[g][gSkin][15] = 85, OrganInfo[g][gSkinPrice][15] = 100000, OrganInfo[g][gSkinRank][15] = 8;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 13) // Grove Street
	{
		OrganInfo[g][gSkin][0] = 105, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 106, OrganInfo[g][gSkinPrice][1] = 20000, OrganInfo[g][gSkinRank][1] = 2;
		OrganInfo[g][gSkin][2] = 107, OrganInfo[g][gSkinPrice][2] = 30000, OrganInfo[g][gSkinRank][2] = 3;
		OrganInfo[g][gSkin][3] = 269, OrganInfo[g][gSkinPrice][3] = 40000, OrganInfo[g][gSkinRank][3] = 4;
		OrganInfo[g][gSkin][4] = 270, OrganInfo[g][gSkinPrice][4] = 50000, OrganInfo[g][gSkinRank][4] = 5;
		OrganInfo[g][gSkin][5] = 271, OrganInfo[g][gSkinPrice][5] = 100000, OrganInfo[g][gSkinRank][5] = 8;
		OrganInfo[g][gSkin][6] = 207, OrganInfo[g][gSkinPrice][6] = 0, OrganInfo[g][gSkinRank][6] = 1;
		OrganInfo[g][gSkin][7] = 65, OrganInfo[g][gSkinPrice][7] = 90000, OrganInfo[g][gSkinRank][7] = 8;
		OrganInfo[g][gSkin][8] = 539, OrganInfo[g][gSkinPrice][8] = 10000, OrganInfo[g][gSkinRank][8] = 2;
		OrganInfo[g][gSkin][9] = 540, OrganInfo[g][gSkinPrice][9] = 10000, OrganInfo[g][gSkinRank][9] = 2;
		OrganInfo[g][gSkin][10] = 541, OrganInfo[g][gSkinPrice][10] = 10000, OrganInfo[g][gSkinRank][10] = 2;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 14) // Ballas Gang
	{
		OrganInfo[g][gSkin][0] = 103, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 102, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 3;
		OrganInfo[g][gSkin][2] = 104, OrganInfo[g][gSkinPrice][2] = 50000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 296, OrganInfo[g][gSkinPrice][3] = 100000, OrganInfo[g][gSkinRank][3] = 8;
		OrganInfo[g][gSkin][4] = 243, OrganInfo[g][gSkinPrice][4] = 0, OrganInfo[g][gSkinRank][4] = 1;
		OrganInfo[g][gSkin][5] = 13, OrganInfo[g][gSkinPrice][5] = 90000, OrganInfo[g][gSkinRank][5] = 8;
		OrganInfo[g][gSkin][6] = 542, OrganInfo[g][gSkinPrice][6] = 10000, OrganInfo[g][gSkinRank][6] = 2;
		OrganInfo[g][gSkin][7] = 543, OrganInfo[g][gSkinPrice][7] = 10000, OrganInfo[g][gSkinRank][7] = 2;
		OrganInfo[g][gSkin][8] = 544, OrganInfo[g][gSkinPrice][8] = 10000, OrganInfo[g][gSkinRank][8] = 2;
		OrganInfo[g][gSkin][9] = 545, OrganInfo[g][gSkinPrice][9] = 10000, OrganInfo[g][gSkinRank][9] = 2;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 15) // Vagos Gang
	{
		OrganInfo[g][gSkin][0] = 108, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 109, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 3;
		OrganInfo[g][gSkin][2] = 110, OrganInfo[g][gSkinPrice][2] = 50000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 47, OrganInfo[g][gSkinPrice][3] = 100000, OrganInfo[g][gSkinRank][3] = 8;
		OrganInfo[g][gSkin][4] = 63, OrganInfo[g][gSkinPrice][4] = 0, OrganInfo[g][gSkinRank][4] = 1;
		OrganInfo[g][gSkin][5] = 12, OrganInfo[g][gSkinPrice][5] = 90000, OrganInfo[g][gSkinRank][5] = 8;
		OrganInfo[g][gSkin][6] = 537, OrganInfo[g][gSkinPrice][6] = 10000, OrganInfo[g][gSkinRank][6] = 2;
		OrganInfo[g][gSkin][7] = 538, OrganInfo[g][gSkinPrice][7] = 10000, OrganInfo[g][gSkinRank][7] = 2;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 16) // Los Aztecas
	{
		OrganInfo[g][gSkin][0] = 114, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 115, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 3;
		OrganInfo[g][gSkin][2] = 116, OrganInfo[g][gSkinPrice][2] = 50000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 292, OrganInfo[g][gSkinPrice][3] = 100000, OrganInfo[g][gSkinRank][3] = 8;
		OrganInfo[g][gSkin][4] = 298, OrganInfo[g][gSkinPrice][4] = 0, OrganInfo[g][gSkinRank][4] = 1;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 18) // Arabian
	{
		OrganInfo[g][gSkin][0] = 142, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 220, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 3;
		OrganInfo[g][gSkin][2] = 222, OrganInfo[g][gSkinPrice][2] = 50000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 221, OrganInfo[g][gSkinPrice][3] = 100000, OrganInfo[g][gSkinRank][3] = 8;
		OrganInfo[g][gSkin][4] = 40, OrganInfo[g][gSkinPrice][4] = 0, OrganInfo[g][gSkinRank][4] = 1;

		// Custom
		OrganInfo[g][gSkin][5] = 411, OrganInfo[g][gSkinPrice][5] = 20000, OrganInfo[g][gSkinRank][5] = 5;
		OrganInfo[g][gSkin][6] = 412, OrganInfo[g][gSkinPrice][6] = 200000, OrganInfo[g][gSkinRank][6] = 8;
		OrganInfo[g][gSkin][7] = 413, OrganInfo[g][gSkinPrice][7] = 100000, OrganInfo[g][gSkinRank][7] = 5;
		OrganInfo[g][gSkin][8] = 418, OrganInfo[g][gSkinPrice][8] = 150000, OrganInfo[g][gSkinRank][8] = 7;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	return 1;
}

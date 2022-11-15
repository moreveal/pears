////////////////////////////////////////////////////////////////////////////////
//
//
//        #### ########   ######     ######## ########    ###    ##     ##
//         ##  ##     ## ##    ##       ##    ##         ## ##   ###   ###
//         ##  ##     ## ##             ##    ##        ##   ##  #### ####
//         ##  ########   ######        ##    ######   ##     ## ## ### ##
//         ##  ##              ##       ##    ##       ######### ##     ##
//         ##  ##        ##    ##       ##    ##       ##     ## ##     ##
//        #### ##         ######        ##    ######## ##     ## ##     ##
//
//
//								TextDrawMove v1.5
//
/*					 ______          ______           _       
//					 | ___ \         | ___ \         | |      
//					 | |_/ /_   _    | |_/ /_ _ _   _| | ___  
//					 | ___ \ | | |   |  __/ _` | | | | |/ _ \ 
//					 | |_/ / |_| |_  | | | (_| | |_| | | (_) |
//					 \____/ \__, (_) \_|  \__,_|\__,_|_|\___/ 
//							 __/ |                            
//						    |___/                             
*/                            
//           	Agradecimento especial à Drakins(Otimizou ResetArray)
//
//            !!!   Mova facilmente e dinamicamente suas TextDraws   !!!
//
//          [iPs]TeaM soluções de programação em geral (agora com cursos)
//
//                  http://ips-team.forumeiros.com/ (contate-nos)
//
/////////////////////////////////////////////////////////////////////////////////

#define Function%0(%1) forward%0(%1); public%0(%1)

#define PT_MOVE_BOX 0
#define PT_MOVE_TEXT 1

#define ResetArray(%0); new ArrayReset[MAX_TEXT_DRAWS]; %0 = ArrayReset;

new PT_Text[Text:MAX_TEXT_DRAWS][800 char],
	Float:PT_X[Text:MAX_TEXT_DRAWS],
	Float:PT_Y[Text:MAX_TEXT_DRAWS],
	PT_Alig[Text:MAX_TEXT_DRAWS char],
	PT_BackCor[Text:MAX_TEXT_DRAWS],
	PT_BoxCor[Text:MAX_TEXT_DRAWS],
	PT_Cor[Text:MAX_TEXT_DRAWS],
	PT_Font[Text:MAX_TEXT_DRAWS char],
	Float:PT_lX[Text:MAX_TEXT_DRAWS],
	Float:PT_lY[Text:MAX_TEXT_DRAWS],
	PT_Line[Text:MAX_TEXT_DRAWS char],
	PT_Prop[Text:MAX_TEXT_DRAWS char],
	PT_Sombra[Text:MAX_TEXT_DRAWS char],
	PT_Box[Text:MAX_TEXT_DRAWS char],
	Float:PT_tX[Text:MAX_TEXT_DRAWS],
	Float:PT_tY[Text:MAX_TEXT_DRAWS],
	PT_Timer[Text:MAX_TEXT_DRAWS char],
	bool:PT_Movendo[Text:MAX_TEXT_DRAWS char],
	bool:PT_Fadding[Text:MAX_TEXT_DRAWS char];

stock TextDrawMove(Text:Td, Float:fX, Float:fY, Float:fX2, Float:fY2, Speed, Move, playerid = INVALID_PLAYER_ID) {
	if(!Speed || PT_Movendo{Td} || (PT_X[Td] == fX && PT_Y[Td] == fY && PT_tX[Td] == fX2 && PT_tY[Td] == fY2)) return 1;
	static MaiorDist;
	if(floatabs(PT_X[Td]-fX) > floatabs(PT_Y[Td]-fY)) MaiorDist = floatround(floatabs(PT_X[Td]-fX));
	else MaiorDist = floatround(floatabs(PT_Y[Td]-fY));
	if(floatabs(PT_tX[Td]-fX2) > floatabs(PT_tY[Td]-fY2) && floatabs(PT_tX[Td]-fX2) > MaiorDist) MaiorDist = floatround(floatabs(PT_tX[Td]-fX2));
	else if(floatabs(PT_tY[Td]-fY2) > MaiorDist) MaiorDist = floatround(floatabs(PT_tY[Td]-fY2));
	PT_Timer{Td} = SetTimerEx(#MoveTd, ((MaiorDist/Speed)/20), false, #iffffiiii, _:Td, (fX == 0.0 ? PT_X[Td] : fX), (fY == 0.0 ? PT_Y[Td] : fY), (fX2 == 0.0 ? PT_tX[Td] : fX2), (fY2 == 0.0 ? PT_tY[Td] : fY2), ((MaiorDist/Speed)/20), MaiorDist, Move, playerid);
	return PT_Movendo{Td} = true;
}

stock TextDrawFade(Text:Td, Color, Speed, playerid = INVALID_PLAYER_ID) {
	if(PT_Fadding{Td}) return 1;
	new Cor[2][11]; HexStr(Color, Cor[0]), HexStr((PT_Box{Td} ? PT_BoxCor[Td] : PT_Cor[Td]), Cor[1]);
	PT_Timer{Td} = SetTimerEx(#FadeTd, Speed*30, false, #iiiii, _:Td, (HexInt(Cor[0]) > HexInt(Cor[1]) ? HexInt(Cor[0])-HexInt(Cor[1]) : HexInt(Cor[1])-HexInt(Cor[0])), (Color > (PT_Box{Td} ? PT_BoxCor[Td] : PT_Cor[Td]) ? true : false), Speed*30, playerid);
	return PT_Fadding{Td} = true;
}

stock Text:TextDrawCreateEx(Float:x, Float:y, text[]) {
	static Text:Td; Td = TextDrawCreate(x, y, text);
	PT_X[Td] = x; PT_Y[Td] = y; format(PT_Text[Td], 800, text);
	return Td;
}

stock TextDrawAlignmentEx(Text:text, alignment) {
	TextDrawAlignment(text, alignment);
	PT_Alig{text} = alignment;
}

stock TextDrawBackgroundColorEx(Text:text, color) {
	TextDrawBackgroundColor(text, color);
	PT_BackCor[text] = color;
}

stock TextDrawBoxColorEx(Text:text, color) {
	TextDrawBoxColor(text, color); new Cor[11]; HexStr(color, Cor);
	PT_BoxCor[text] = HexInt(Cor);
}

stock TextDrawColorEx(Text:text, color) {
	TextDrawColor(text, color); new Cor[11]; HexStr(color, Cor);
	PT_Cor[text] = HexInt(Cor);
}

stock TextDrawFontEx(Text:text, font) {
	TextDrawFont(text, font);
	PT_Font{text} = font;
}

stock TextDrawLetterSizeEx(Text:text, Float:x, Float:y) {
	TextDrawLetterSize(text, x, y);
	PT_lX[text] = x; PT_lY[text] = y;
}

stock TextDrawSetOutlineEx(Text:text, size) {
	TextDrawSetOutline(text, size);
	PT_Line{text} = size;
}

stock TextDrawSetProportionalEx(Text:text, set) {
	TextDrawSetProportional(text, set);
	PT_Prop{text} = set;
}

stock TextDrawSetShadowEx(Text:text, size) {
	TextDrawSetShadow(text, size);
	PT_Sombra{text} = size;
}

stock TextDrawTextSizeEx(Text:text, Float:x, Float:y) {
	TextDrawTextSize(text, x, y);
	PT_tX[text] = x; PT_tY[text] = y;
}

stock TextDrawUseBoxEx(Text:text, use) {
	TextDrawUseBox(text, use);
	PT_Box{text} = use;
}

stock TextDrawGetXAndYPos(Text:text, Float:Var[2]) return (Var[0] = PT_X[text], Var[1] = PT_Y[text], 1);

stock TextDrawGetXAndYTextSize(Text:text, Float:Var[2]) return (Var[0] = PT_tX[text], Var[1] = PT_tY[text], 1);

stock TextDrawGetXAndYLetterSize(Text:text, Float:Var[2]) return (Var[0] = PT_lX[text], Var[1] = PT_lY[text], 1);

stock TextDrawDestroyEx(Text:text) {
	TextDrawDestroy(text);
	ResetArray(PT_Text[text]);
	PT_X[text] = 0;
	PT_Y[text] = 0;
	PT_Alig{text} = 0;
	PT_BackCor[text] = 0;
	PT_BoxCor[text] = 0;
	PT_Cor[text] = 0;
	PT_Font{text} = 0;
	PT_lX[text] = 0;
	PT_lY[text] = 0;
	PT_Line{text} = 0;
	PT_Prop{text} = 0;
	PT_Sombra{text} = 0;
	PT_Box{text} = 0;
	PT_tX[text] = 0;
	PT_tY[text] = 0;
}

stock HexStr(Int, Color[11]) { //Baseado DOF2
	static Caracters[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'}; Color = "0x";
	for(new i; i != 8; ++i) Color[i+2] = Caracters[(Int >>> ((7 - i) << 2)) & 0x0F];
	return Color;
}

stock StrHex(Str[]) { //Baseado DOF2
	new i, Int;
	if(Str[0] == '0' && (Str[1] == 'x' || Str[1] == 'X')) i = 2;
    while(Str[i]) {
		Int <<= 4;
		switch(Str[i]) {
		    case '0'..'9': Int |= Str[i] - '0';
			case 'A'..'F': Int |= Str[i] - 'A' + 10;
            case 'a'..'f': Int |= Str[i] - 'a' + 10;
			default: return 0;
		}
		++i;
    }
    return Int;
}

stock HexInt(Str[]) { //Baseado Wiki
	if(!Str[0]) return 0;
	new Calc = 1, Result;
	for(new i = strlen(Str); i != 0; i--) {
		if(Str[i-2] == '0' && (Str[i-1] == 'x' || Str[i-1] == 'X')) continue;
		if(Str[i-1] < 58) Result += Calc*(Str[i-1]-48);
		else Result += Calc*(Str[i-1]-65+10);
		Calc = Calc*0x10;
	}
	return Result;
}

Function MoveTd(Text:Td, Float:fX, Float:fY, Float:fX2, Float:fY2, Time, MaiorDist, Move, playerid) {
	static i; i++; TextDrawDestroy(Td);
	Td = TextDrawCreate((PT_X[Td] < fX ? (PT_X[Td]+i < fX ? PT_X[Td]+i : fX) : (PT_X[Td]-i > fX ? PT_X[Td]-i : fX)), (PT_Y[Td] < fY ? (PT_Y[Td]+i < fY ? PT_Y[Td]+i : fY) : (PT_Y[Td]-i > fY ? PT_Y[Td]-i : fY)), PT_Text[Td]);
	TextDrawAlignment(Td, PT_Alig{Td});
	TextDrawBackgroundColor(Td, PT_BackCor[Td]);
	TextDrawBoxColor(Td, PT_BoxCor[Td]);
	TextDrawColor(Td, PT_Cor[Td]);
	TextDrawFont(Td, PT_Font{Td});
	TextDrawLetterSize(Td, PT_lX[Td], PT_lY[Td]);
	TextDrawSetOutline(Td, PT_Line{Td});
	TextDrawSetProportional(Td, PT_Prop{Td});
	TextDrawSetShadow(Td, PT_Sombra{Td});
	TextDrawUseBox(Td, PT_Box{Td});
	if(Move == PT_MOVE_BOX) TextDrawTextSize(Td, (PT_tX[Td] < fX2 ? (PT_tX[Td]+i < fX2 ? PT_tX[Td]+i : fX2) : (PT_tX[Td]-i > fX2 ? PT_tX[Td]-i : fX2)), (PT_tY[Td] < fY2 ? (PT_tY[Td]+i < fY2 ? PT_tY[Td]+i : fY2) : (PT_tY[Td]-i > fY2 ? PT_tY[Td]-i : fY2)));
	else TextDrawTextSize(Td, PT_tX[Td], PT_tY[Td]);
	if(playerid == INVALID_PLAYER_ID) TextDrawShowForAll(Td);
	else TextDrawShowForPlayer(playerid, Td);
	if(i >= MaiorDist) return PT_X[Td] = fX, PT_Y[Td] = fY, PT_tX[Td] = fX2, PT_tY[Td] = fY2, PT_Movendo{Td} = false, i = 0;
	return PT_Timer{Td} = SetTimerEx(#MoveTd, Time, false, #iffffiiii, _:Td, fX, fY, fX2, fY2, Time, MaiorDist, Move, playerid);
}

Function FadeTd(Text:Td, Cor, bool:Calc, Time, playerid) {
	static i = 5; i--;
	if(PT_Box{Td}) TextDrawBoxColor(Td, (Calc ? (PT_BoxCor[Td]+(Cor/i)) : (PT_BoxCor[Td]-(Cor/i))));
	else TextDrawColor(Td, (Calc ? (PT_Cor[Td]+(Cor/i)) : (PT_Cor[Td]-(Cor/i))));
	if(playerid == INVALID_PLAYER_ID) TextDrawShowForAll(Td);
	else TextDrawShowForPlayer(playerid, Td);
	if(i == 1) return (PT_Box{Td} ? (PT_BoxCor[Td] = (Calc ? (PT_BoxCor[Td]+Cor) : (PT_BoxCor[Td]-Cor))) : (PT_Cor[Td] = (Calc ? (PT_Cor[Td]+Cor) : (PT_Cor[Td]-Cor)))), i = 5, PT_Fadding{Td} = false;
	return PT_Timer{Td} = SetTimerEx(#FadeTd, Time, false, #iiiii, _:Td, Cor, Calc, Time, playerid);
}

#define TextDrawCreate TextDrawCreateEx
#define TextDrawAlignment TextDrawAlignmentEx
#define TextDrawBackgroundColor TextDrawBackgroundColorEx
#define TextDrawBoxColor TextDrawBoxColorEx
#define TextDrawColor TextDrawColorEx
#define TextDrawFont TextDrawFontEx
#define TextDrawLetterSize TextDrawLetterSizeEx
#define TextDrawSetOutline TextDrawSetOutlineEx
#define TextDrawSetProportional TextDrawSetProportionalEx
#define TextDrawSetShadow TextDrawSetShadowEx
#define TextDrawUseBox TextDrawUseBoxEx
#define TextDrawTextSize TextDrawTextSizeEx
#define TextDrawDestroy TextDrawDestroyEx
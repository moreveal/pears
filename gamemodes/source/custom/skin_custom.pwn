
/*
Как добавить новый кастомный скин на сервер?
1. Увеличить define MAX_SKIN_CUSTOM (в базе строки до 600 id скина)
2. Добавить в stock AddCustomSkins новый AddCharSyncModel (Оригинальный скин, Новый ID следующий по порядку)
3. Если скин мужской - добавить новый ID в stock GetSkinSex
4. Если добавляем специальный скин, использующийся только в системе - добавить новый ID в stock IsSpecialSystemSkin
5. Если хотим добавить скин в организацию, добавляем его в public ReloadSkin

Как добавить скин в магазины?
1. В настройках гос цен правительства указываешь ценник и доступ для заказа в магазы (и УСЁ)
*/

#define MAX_SKIN_CUSTOM 297 

stock AddCustomSkins()
{
	// AddCharSyncModel(Оригинальный, Новый) ID в сборке с 15500 до 15999
	// Plus 15188

	// В целом добавить ещё скинов
	AddCharSyncModel(294, 312); // 15500, pearspedcu (Значит не 312, а 15500) male
	AddCharSyncModel(60, 313); // pearspeda (Значит не 313, а 15501) male
	AddCharSyncModel(233, 314); // pearspedb (Значит не 314, а 15502)
	AddCharSyncModel(19, 315); // 15503 pearspedc male
	AddCharSyncModel(59, 316); // 15504 pearspedd male
	AddCharSyncModel(93, 317); // 15505, pearspede
	AddCharSyncModel(19, 318); // 15506, pearspedf male
	AddCharSyncModel(59, 319); // 15507, pearspedg male
	AddCharSyncModel(125, 320); // 15508, pearspedh male
	AddCharSyncModel(23, 321); // 15509, pearspedi male
	AddCharSyncModel(21, 322); // 15510, pearspedj male
	AddCharSyncModel(216, 323); // 15511, pearspedk
	AddCharSyncModel(55, 324); // 15512, pearspedl
	AddCharSyncModel(93, 325); // 15513, pearspedm
	AddCharSyncModel(7, 326); // 15514, pearspedn male
	AddCharSyncModel(125, 327); // 15515, pearspedo male
	AddCharSyncModel(1, 328); // 15516, pearspedp male
	AddCharSyncModel(248, 329); // 15517, pearspedq male
	AddCharSyncModel(29, 330); // 15518, pearspedr male
	AddCharSyncModel(121, 331); // 15519, pearspeds male
	AddCharSyncModel(125, 332); // 15520, pearspedt male
	AddCharSyncModel(240, 333); // 15521, pearspedu male
	AddCharSyncModel(223, 334); // 15522, pearspedv male
	AddCharSyncModel(28, 335); // 15523, pearspedw male
	AddCharSyncModel(25, 336); // 15524, pearspedx male
	AddCharSyncModel(150, 337); // 15525, pearspedy
	AddCharSyncModel(237, 338); // 15526, pearspedz
	AddCharSyncModel(131, 339); // 15527, pearspedaa
	AddCharSyncModel(12, 340); // 15528, pearspedab
	AddCharSyncModel(40, 341); // 15529, pearspedac
	AddCharSyncModel(178, 342); // 15530, pearspedad
	AddCharSyncModel(233, 343); // 15531, pearspedae
	AddCharSyncModel(93, 344); // 15532, pearspedaf
	AddCharSyncModel(157, 345); // 15533, pearspedag 
	AddCharSyncModel(223, 346); // 15534, pearspedah
	AddCharSyncModel(233, 347); // 15535, pearspedai
	AddCharSyncModel(233, 348); // 15536, pearspedaj
	AddCharSyncModel(233, 349); // 15537, pearspedak
	AddCharSyncModel(93, 350); // 15538, pearspedal
	AddCharSyncModel(233, 351); // 15539, pearspedam
	AddCharSyncModel(223, 352); // 15540, pearspedan male
	AddCharSyncModel(240, 353); // 15541, pearspedao male
	AddCharSyncModel(126, 354); // 15542, pearspedap male
	AddCharSyncModel(93, 355); // 15543, pearspedaq
	AddCharSyncModel(240, 356); // 15544, pearspedar male
	AddCharSyncModel(93, 357); // 15545, pearspedas
	AddCharSyncModel(93, 358); // 15546, pearspedat
	AddCharSyncModel(91, 359); // 15547, pearspedau
	AddCharSyncModel(233, 360); // 15548, pearspedav
	AddCharSyncModel(216, 361); // 15549, pearspedaw
	AddCharSyncModel(216, 362); // 15550, pearspedax
	AddCharSyncModel(93, 363); // 15551, pearspeday
	AddCharSyncModel(240, 364); // 15552, pearspedaz male
	AddCharSyncModel(180, 365); // 15553, pearspedba male
	AddCharSyncModel(226, 366); // 15554, pearspedbb
	AddCharSyncModel(60, 367); // 15555, pearspedbc male
	AddCharSyncModel(257, 368); // 15556, pearspedbd
	AddCharSyncModel(257, 369); // 15557, pearspedbe
	AddCharSyncModel(41, 370); // 15558, pearspedbf
	AddCharSyncModel(40, 371); // 15559, pearspedbg
	AddCharSyncModel(233, 372); // 15560, pearspedbh
	AddCharSyncModel(233, 373); // 15561, pearspedbi
	AddCharSyncModel(93, 374); // 15562, pearspedbj
	AddCharSyncModel(233, 375); // 15563, pearspedbk
	AddCharSyncModel(98, 376); // 15564, pearspedbl male
	AddCharSyncModel(98, 377); // 15565, pearspedbm male
	AddCharSyncModel(98, 378); // 15566, pearspedbn male
	AddCharSyncModel(98, 379); // 15567, pearspedbo male
	AddCharSyncModel(112, 380); // 15568, pearspedbp male
	AddCharSyncModel(127, 381); // 15569, pearspedbq male
	AddCharSyncModel(127, 382); // 15570, pearspedbr male
	AddCharSyncModel(240, 383); // 15571, pearspedbs male
	AddCharSyncModel(240, 384); // 15572, pearspedbt male
	AddCharSyncModel(240, 385); // 15573, pearspedbu male
	AddCharSyncModel(45, 386); // 15574, pearspedbv male
	AddCharSyncModel(91, 387); // 15575, pearspedbw
	AddCharSyncModel(98, 388); // 15576, pearspedbx male
	AddCharSyncModel(216, 389); // 15577, pearspedby
	AddCharSyncModel(25, 390); // 15578, pearspedbz male
	AddCharSyncModel(120, 391); // 15579, pearspedca male
	AddCharSyncModel(179, 392); // 15580, pearspedcb male
	AddCharSyncModel(233, 393); // 15581, pearspedcc
	AddCharSyncModel(12, 394); // 15582, pearspedcd
	AddCharSyncModel(40, 395); // 15583, pearspedce
	AddCharSyncModel(85, 396); // 15584, pearspedcf
	AddCharSyncModel(233, 397); // 15585, pearspedcg
	AddCharSyncModel(233, 398); // 15586, pearspedct
	AddCharSyncModel(233, 399); // 15587, pearspedch
	AddCharSyncModel(12, 400); // 15588, pearspedci
	AddCharSyncModel(217, 401); // 15589, pearspedcj male
	AddCharSyncModel(12, 402); // 15590, pearspedck
	AddCharSyncModel(59, 403); // 15591, pearspedcl male
	AddCharSyncModel(93, 404); // 15592, pearspedcm
	AddCharSyncModel(98, 405); // 15593, pearspedcn male
	AddCharSyncModel(143, 406); // 15594, pearspedco male
	AddCharSyncModel(93, 407); // 15595, pearspedcp
	AddCharSyncModel(91, 408); // 15596, pearspedcq
	AddCharSyncModel(40, 409); // 15597, pearspedcr
	AddCharSyncModel(46, 410); // 15598, pearspedcs male
	AddCharSyncModel(40, 411); // 15599, pedaraba
	AddCharSyncModel(221, 412); // 15600, pedarabb male
	AddCharSyncModel(142, 413); // 15601, pedarabc male
	AddCharSyncModel(42, 414); // 15602, prisonmex male
	AddCharSyncModel(311, 415); // 15603, pearscop male
	AddCharSyncModel(287, 416); // 15604, pearsarmy1 male
	AddCharSyncModel(287, 417); // 15605, pearsarmy2 male
	AddCharSyncModel(5, 418); // 15606, pearsswat1 male (жирный араб)
	AddCharSyncModel(285, 419); // 15607, pearsswat2 male
	AddCharSyncModel(300, 420); // 15608, pearscop2 male
	AddCharSyncModel(301, 421); // 15609, pearsswat4 male
	AddCharSyncModel(300, 422); // 15610, pearsswat5 male
	AddCharSyncModel(300, 423); // 15611, pearscop3 male
	AddCharSyncModel(305, 424); // 15612, pearscop4 male
	AddCharSyncModel(303, 425); // 15613, pearscop5 male
	AddCharSyncModel(142, 426); // 15614, pearspedcv male
	AddCharSyncModel(221, 427); // 15615, pearspedcw male
	AddCharSyncModel(277, 428); // 15616, astronaut all
	AddCharSyncModel(6, 429); // 15617, jason male
	AddCharSyncModel(21, 430); // 15618, prisonblack male
	AddCharSyncModel(141, 431); // 15619, pearspedcx female
	AddCharSyncModel(144, 432); // 15620, pearspedcy male
	AddCharSyncModel(287, 433); // 15621, pearspedcz male
	AddCharSyncModel(146, 434); // 15622, pearspedda male
	AddCharSyncModel(42, 435); // 15623, pearspeddb male
	AddCharSyncModel(287, 436); // 15624, pearspeddc male
	AddCharSyncModel(307, 437); // 15625, pearspeddd female
	AddCharSyncModel(310, 438); // 15626, pearspedde male
	AddCharSyncModel(306, 439); // 15627, pearscop6 female
	AddCharSyncModel(281, 440); // 15628, pearspeddf male
	AddCharSyncModel(280, 441); // 15629, pearspeddg male
	AddCharSyncModel(265, 442); // 15630, pearspeddh male
	AddCharSyncModel(310, 443); // 15631, pearspeddi male
	AddCharSyncModel(306, 444); // 15632, pearspeddj female
	AddCharSyncModel(306, 445); // 15633, pearspeddk female
	AddCharSyncModel(282, 446); // 15634, pearspeddl male
	AddCharSyncModel(282, 447); // 15635, pearspeddm male
	AddCharSyncModel(282, 448); // 15636, pearspeddn male
	AddCharSyncModel(282, 449); // 15637, pearspeddo male
	AddCharSyncModel(282, 450); // 15638, pearspeddp male
	AddCharSyncModel(282, 451); // 15639, pearspeddq male
	AddCharSyncModel(306, 452); // 15640, pearspeddr female
	AddCharSyncModel(121, 453); // 15641, pearspedds male
    AddCharSyncModel(165, 454); // 15642, pearspeddt male
    AddCharSyncModel(286, 455); // 15643, pearspeddu male
    AddCharSyncModel(286, 456); // 15644, pearspeddv male
    AddCharSyncModel(295, 457); // 15645, pearspeddw male
    AddCharSyncModel(286, 458); // 15646, pearspeddx male
    AddCharSyncModel(286, 459); // 15647, pearspeddy male
    AddCharSyncModel(285, 460); // 15648, pearspeddz all
    AddCharSyncModel(285, 461); // 15649, pearspedea all
    AddCharSyncModel(165, 462); // 15650, pearspedeb male
    AddCharSyncModel(286, 463); // 15651, pearspedec male
    AddCharSyncModel(286, 464); // 15652, pearspeded male
    AddCharSyncModel(150, 465); // 15653, pearspedee female
    AddCharSyncModel(286, 466); // 15654, pearspedef male
	AddCharSyncModel(29, 467); // 15655, zverworks male
	AddCharSyncModel(121, 468); // 15656, pearspedeg male Yakuza
	AddCharSyncModel(118, 469); // 15657, pearspedeh male Yakuza
	AddCharSyncModel(123, 470); // 15658, pearspedei male Yakuza
	AddCharSyncModel(118, 471); // 15659, pearspedej male Yakuza
	AddCharSyncModel(119, 472); // 15660, pearspedek male RM
	AddCharSyncModel(66, 473); // 15661, pearspedel male
	AddCharSyncModel(60, 474); // 15662, pearspedem male RM
	AddCharSyncModel(113, 475); // 15663, pearspeden male RM
	AddCharSyncModel(68, 476); // 15664, pearspedeo male
	AddCharSyncModel(68, 477); // 15665, pearspedep male
	AddCharSyncModel(113, 478); // 15666, pearspedeq male
	AddCharSyncModel(66, 479); // 15667, pearspeder male
	AddCharSyncModel(111, 480); // 15668, pearspedes male RM
	AddCharSyncModel(247, 481); // 15669, pearspedet male
	AddCharSyncModel(46, 482); // 15670, pearspedeu male RM
	AddCharSyncModel(223, 483); // 15671, pearspedev male
	AddCharSyncModel(111, 484); // 15672, pearspedew male RM
	AddCharSyncModel(46, 485); // 15673, pearspedex male RM
	AddCharSyncModel(60, 486); // 15674, pearspedey male
	AddCharSyncModel(29, 487); // 15675, pearspedfz male
	AddCharSyncModel(117, 488); // 15676, pearspedfa male Yakuza
	AddCharSyncModel(121, 489); // 15677, pearspedfb male
	AddCharSyncModel(272, 490); // 15678, pearspedfc male RM
	AddCharSyncModel(126, 491); // 15679, pearspedfd male RM
	AddCharSyncModel(125, 492); // 15680, pearspedfe male
	AddCharSyncModel(294, 493); // 15681, pearspedff male
	AddCharSyncModel(285, 494); // 15682, pearsvvs male
	AddCharSyncModel(70, 495); // 15683, pearsdoctor male
	AddCharSyncModel(308, 496); // 15684, pearsmedg1 famale
	AddCharSyncModel(308, 497); // 15685, pearsmedg2 famale
	AddCharSyncModel(308, 498); // 15686, pearsmedg3 famale
	AddCharSyncModel(308, 499); // 15687, pearsmedg4 famale
	AddCharSyncModel(275, 500); // 15688, pearsmedm1 male
	AddCharSyncModel(276, 501); // 15689, pearsmedm2 male
	AddCharSyncModel(275, 502); // 15690, pearsmedm3 male
	AddCharSyncModel(276, 503); // 15691, pearsmedm4 male
	AddCharSyncModel(274, 504); // 15692, pearsmedm5 male
	AddCharSyncModel(146, 505); // 15693, pearsebalai male
	AddCharSyncModel(264, 506); // 15694, pearsvampir male
	AddCharSyncModel(168, 507); // 15695, pearsbenzop male
	AddCharSyncModel(130, 508); // 15696, pearsovechka -
	AddCharSyncModel(31, 509); //  15697, pearskorova -
	AddCharSyncModel(153, 510); //  15698, pearsscream -
	AddCharSyncModel(264, 511); //  15699, pearsclown -
	AddCharSyncModel(82, 512); //  15700, pearszombie1 male
	AddCharSyncModel(83, 513); //  15701, pearszombie2 male
	AddCharSyncModel(84, 514); //  15702, pearszombie3 male
	AddCharSyncModel(82, 515); //  15703, pearszombie4 male
	AddCharSyncModel(83, 516); //  15704, pearszombie5 male
	AddCharSyncModel(75, 517); //  15705, pearszombie6 famale
	AddCharSyncModel(77, 518); //  15706, pearszombie7 famale
	AddCharSyncModel(82, 519); //  15707, pearszombie8 male
	AddCharSyncModel(83, 520); //  15708, pearszombie9 male
	AddCharSyncModel(59, 521); // pearskortu
	AddCharSyncModel(60, 522); // pearsmajodin
	AddCharSyncModel(98, 523); // pearsmajodva
	AddCharSyncModel(23, 524); // pearsmajotri
	AddCharSyncModel(248, 525); // pearsjil
	AddCharSyncModel(247, 526); // pearsjildva
	AddCharSyncModel(187, 527); // pearskosb
	AddCharSyncModel(91, 528); // pearsmegno woman
	AddCharSyncModel(19, 529); // pearsgheze
	AddCharSyncModel(93, 530); // pearswjns woman
	AddCharSyncModel(184, 531); // pearsdedsp
	AddCharSyncModel(223, 532); // pearssuitold
	AddCharSyncModel(186, 533); // pearssuoldv
	AddCharSyncModel(208, 534); // pearsdetsu
	AddCharSyncModel(66, 535); // pearskurng
	AddCharSyncModel(80, 536); // pearsufcng
	AddCharSyncModel(109, 537); // pearsvago vagos 
	AddCharSyncModel(110, 538); // pearsvagtr vagos
	AddCharSyncModel(106, 539); // pearsgroveo Grove
	AddCharSyncModel(107, 540); // pearsgrovet Grove
	AddCharSyncModel(195, 541); // pearsgroveg grove woman
	AddCharSyncModel(102, 542); // pearsballo ballas
	AddCharSyncModel(102, 543); // pearsballt ballas
	AddCharSyncModel(13, 544); // pearsballg ballas woman
	AddCharSyncModel(104, 545); // pearsballtr ballas 
	AddCharSyncModel(91, 546); // pearsbecky woman
	AddCharSyncModel(42, 547); // pearsorm 
	AddCharSyncModel(42, 548); // pearsorgm
	AddCharSyncModel(258, 549); // pearsamkr
	AddCharSyncModel(30, 550); // pearsrcep
	AddCharSyncModel(56, 551); // pearsgigre woman
	AddCharSyncModel(259, 552); // pearsolbat
	AddCharSyncModel(258, 553); // pearssimsui
	AddCharSyncModel(259, 554); // pearssimpol
	AddCharSyncModel(252, 555); // pearssimnud
	AddCharSyncModel(217, 556); // pearsardbl
	AddCharSyncModel(171, 557); // pearsardsui
	AddCharSyncModel(208, 558); // pearsardsuib
	AddCharSyncModel(240, 559); // pearsardjil
	AddCharSyncModel(46, 560); // pearsardjen
	AddCharSyncModel(223, 561); // pearsardjens
	AddCharSyncModel(211, 562); // pearsgibl woman
	AddCharSyncModel(216, 563); // pearsgipink woman 
	AddCharSyncModel(247, 564); // pearsgjo
	AddCharSyncModel(248, 565); // pearsgjt
	AddCharSyncModel(254, 566); // pearsgjtr
	AddCharSyncModel(100, 567); // pearsgjf
	AddCharSyncModel(113, 568); // pearsvicbs
	AddCharSyncModel(111, 569); // pearsvicsrg
	AddCharSyncModel(125, 570); // pearsvicrm
	AddCharSyncModel(144, 571); // pearsterro
	AddCharSyncModel(143, 572); // pearsterrt
	AddCharSyncModel(176, 573); // pearsterrtr
	AddCharSyncModel(177, 574); // pearsterrf
	AddCharSyncModel(177, 575); // pearsterrfm
	AddCharSyncModel(183, 576); // pearsterrfi
	AddCharSyncModel(241, 577); // pearsterrs
	AddCharSyncModel(273, 578); // pearsmono
	AddCharSyncModel(184, 579); // pearsmont 
	AddCharSyncModel(119, 580); // pearsmontr
	AddCharSyncModel(47, 581); // pearsmonf
	AddCharSyncModel(45, 582); // pearsnudta
	AddCharSyncModel(300, 583); // pearsguo
	AddCharSyncModel(300, 584); // pearsgut
	AddCharSyncModel(301, 585); // pearsgutr
	// halloween
	AddCharSyncModel(178, 586); // fpearshall1
	AddCharSyncModel(178, 587); // fpearshall2
	AddCharSyncModel(152, 588); // fpearshall3
	AddCharSyncModel(90, 589); // fpearshall4
	AddCharSyncModel(195, 590); // fpearshall5
	AddCharSyncModel(90, 591); // fpearshall6
	AddCharSyncModel(137, 592); // mpearshall1
	AddCharSyncModel(252, 593); // mpearshall2
	AddCharSyncModel(264, 594); // mpearshall3
	AddCharSyncModel(258, 595); // mpearshall4
	AddCharSyncModel(222, 596); // mpearshall5
	AddCharSyncModel(212, 597); // mpearshall6
	AddCharSyncModel(211, 598); // pearsranfem1
	AddCharSyncModel(214, 599); // pearsranfem2
	AddCharSyncModel(101, 600); // pearsranma1
	AddCharSyncModel(171, 601); // pearsranma2
	AddCharSyncModel(167, 602); // pearsanubis
	AddCharSyncModel(1, 603); // pearsbfost
	AddCharSyncModel(7, 604); // pearsbmori
	// animals
	AddCharSyncModel(162, 605); // pearsbear
	AddCharSyncModel(157, 606); // pearsdeer
	AddCharSyncModel(157, 607); // pearsfox
	AddCharSyncModel(157, 608); // pearsrabbit
	AddCharSyncModel(162, 609); // pearswolf
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
	if(s >= 0 && s <= 8 || s >= 14 && s <= 30 || s >= 32 && s <= 37
	|| s >= 42 && s <= 52 || s >= 57 && s <= 62 || s >= 66 && s <= 68 || s >= 42 && s <= 52 || s >= 70 && s <= 74
	|| s >= 78 && s <= 84 || s == 86 || s >= 94 && s <= 128 || s >= 132 && s <= 137 || s >= 142 && s <= 144 || s == 146 || s == 147 || s == 149
	|| s >= 153 && s <= 156 || s >= 158 && s <= 168 || s == 170 || s == 171 || s >= 173 && s <= 177 || s >= 179 && s <= 189 || s == 200
	|| s >= 202 && s <= 204 || s == 206 || s >= 208 && s <= 210 || s == 212 || s == 213 || s == 217 || s >= 220 && s <= 223 || s >= 227 && s <= 230
 	|| s >= 234 && s <= 236 || s >= 239 && s <= 242 || s >= 247 && s <= 250 || s >= 252 && s <= 255 || s >= 258 && s <= 262 || s >= 264 && s <= 297
 	|| s >= 299 && s <= 305 || s >= 310 && s <= 311

	// Кастомные -15188
	|| s == 312
	|| s == 313 || s == 315 || s == 316 || s >= 318 && s <= 322 || s >= 326 && s <= 336
	|| s == 352 || s == 353 || s == 354 || s == 356 || s == 364 || s == 365 || s == 367
	|| s >= 376 && s <= 386 || s == 388 || s == 390 || s == 391 || s == 392 || s == 401
	|| s == 403 || s == 405 || s == 406 || s == 410 || s >= 412 && s <= 425 || s == 429
	|| s == 430 || s >= 432 && s <= 436 || s == 438 || s >= 440 && s <= 443 || s >= 446 && s <= 451
	|| s == 453 || s >= 454 && s <= 459 || s >= 462 && s <= 464 || s >= 466 && s <= 495 || s >= 500 && s <= 507
	|| s >= 512 && s <= 516 || s >= 519 && s <= 527 || s == 529 || s >= 531 && s <= 540 || s >= 542 && s <= 543
	|| s == 545 || s >= 547 && s <= 550 || s >= 552 && s <= 561 || s >= 564 && s <= 585 || s >= 592 && s <= 597
	|| s >= 600 && s <= 602) return 1; // 1 - мужской скин

	else if(s == 285 || s == 426 || s == 427 || s == 428 || s == 460 || s == 461 || s == 508 || s == 509 ||
	s == 510 || s == 511 || s >= 603 && s <= 609) return 0; // Не имеет пола (подходит для мужчин и женщин)

 	else return 2; // Все остальные 2, значит женские
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

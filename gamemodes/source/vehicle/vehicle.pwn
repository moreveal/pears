
stock PP_CreateVehicle(id, model,Float:x,Float:y,Float:z,Float:a, col1, col2, sek, siren, timerspawn, Float:health)
{
	if(QuantityVehicles + 1 >= SKOKOCAROV) return -1; // Лимит транспортных средств на серверах SAMP

	id = CreateVehicle(model, x, y, z, a, col1, col2, sek, siren);

	LinkVehicleToInterior(id, 0);
	SetVehicleVirtualWorld(id, 0);

	GetVehicleParamsEx(id, engine, lights, alarm, doors, bonnet, boot, objective);
   	SetVehicleParamsEx(id, false, false, false, false, false, false, objective);

	VehInfo[id][vStat] = 1;
	VehInfo[id][vVehcol1] = col1, VehInfo[id][vVehcol2] = col2;
	VehInfo[id][vModel] = model;
	VehInfo[id][vTimerSpawn] = timerspawn;

	VehInfo[id][vPanels] = 0;
	VehInfo[id][vDoors] = 0;
	VehInfo[id][vFara] = 0;
	VehInfo[id][vTires] = 0;

	if(!health) health = MaxVehicleHealth(model);
	VehInfo[id][vHealth] = health;
	SetVehicleHealth(id, VehInfo[id][vHealth]);

	QuantityVehicles ++;
	return id;
}

stock PP_AddStaticVehicleEx(modelID, Float: spawn_X, Float: spawn_Y, Float: spawn_Z, Float: z_Angle, color1, color2, respawn_Delay, siren, Float:health)
{
    new id = AddStaticVehicleEx(modelID, spawn_X, spawn_Y, spawn_Z, z_Angle, color1, color2, respawn_Delay, siren);

	GetVehicleParamsEx(id, engine, lights, alarm, doors, bonnet, boot, objective);
   	SetVehicleParamsEx(id, false, false, false, false, false, false, objective);

    VehInfo[id][vStat] = 1;
    VehInfo[id][vVehcol1] = color1, VehInfo[id][vVehcol2] = color2;
    VehInfo[id][vModel] = modelID;
	VehInfo[id][vTimerSpawn] -= 1;

	VehInfo[id][vPanels] = 0;
	VehInfo[id][vDoors] = 0;
	VehInfo[id][vFara] = 0;
	VehInfo[id][vTires] = 0;

	if(!health) health = MaxVehicleHealth(modelID);
	VehInfo[id][vHealth] = health;
	SetVehicleHealth(id, VehInfo[id][vHealth]);

	QuantityVehicles ++;
    return id;
}

stock veh_openbonnet(v)
{
	GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);
	if(IsABootFront(v)) SetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, true, objective);
	else SetVehicleParamsEx(v, engine, lights, alarm, doors, true, boot, objective);
	VehInfo[v][vBonnet] = 1;
	VehInfo[v][vNospawn] = 1;
}
stock veh_openboot(v)
{
	GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);
	if(IsABootFront(v)) SetVehicleParamsEx(v, engine, lights, alarm, doors, true, boot, objective);
	else SetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, true, objective);
	VehInfo[v][vBoot] = 1;
	VehInfo[v][vNospawn] = 1;
}

stock IsAPosBootOrBonet(playerid, &type)
{
	new vehicleid = -1;
	if(GetPlayerVirtualWorld(playerid) == 0)
	{
		new Float:pos_veh[3];
		for(new v = 0; v < SKOKOCAROV; v++)
		{
            if(VehInfo[v][vModel] == 0) continue;
			if(!IsVehicleOpen(playerid, v)) continue;

			if(IsAMoto(VehInfo[v][vModel]) || IsABoat(VehInfo[v][vModel]))
			{
				GetVehiclePos(v, pos_veh[0], pos_veh[1], pos_veh[2]);
				if(IsPlayerInRangeOfPoint(playerid, 2.0, pos_veh[0], pos_veh[1], pos_veh[2]))
				{
					vehicleid = v;
                    type = 2;
					break;
				}
			}
			else if(IsAPlane(VehInfo[v][vModel]))
			{
				GetVehiclePos(v, pos_veh[0], pos_veh[1], pos_veh[2]);
				if(IsPlayerInRangeOfPoint(playerid, 4.0, pos_veh[0], pos_veh[1], pos_veh[2]))
				{
					vehicleid = v;
                    type = 2;
					break;
				}
			}
			else
			{
				type = GetVehicleNear_Side(playerid, v);
                if(type > 0)
                {
					vehicleid = v;
					break;
				}
			}
		}
	}
	return vehicleid;
}
stock IsAPosBoot(playerid) // Ищем транспорт с багажником рядом
{
	new vehicleid;
	if(GetPlayerVirtualWorld(playerid) == 0)
	{
		for(new v = 0; v < SKOKOCAROV; v++)
		{
            if(VehInfo[v][vModel] == 0) continue;
			if(!IsVehicleOpen(playerid, v)) continue;
            if(!IsABoot(v)) continue;
			if(!GetVehicleNear_Boot(playerid, v)) continue;

			vehicleid = v;
			break;
		}
	}
	return vehicleid;
}
stock GetVehicleNear_Boot(playerid, v) // Получаем инфу, стоим ли мы у багажника авто
{
    new Float:pos_veh[3];
    if(IsABootFront(v)) // Багажник спереди
    {
        GetCoordBonnetVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 1.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
    else // Багажник сзади
    {
        GetCoordBootVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 1.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
	return 0;
}
stock GetVehicleNear_Bonet(playerid, v) // Получаем инфу, стоим ли мы у капота авто
{
    new Float:pos_veh[3];
    if(IsABootFront(v)) // Багажник спереди
    {
        GetCoordBootVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 1.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
    else // Багажник сзади
    {
        GetCoordBonnetVehicle(v, pos_veh[0], pos_veh[1], pos_veh[2]);
        if(IsPlayerInRangeOfPoint(playerid, 1.0, pos_veh[0], pos_veh[1], pos_veh[2])) return 1;
    }
	return 0;
}
stock GetVehicleNear_Side(playerid, v) // Получаем инфу, у какой части транспорта мы стоим
{
	new Float:boot_veh[3], Float:bonet_veh[3], sideId;
	if(IsABootFront(v)) // Багажник спереди
	{
        GetCoordBonnetVehicle(v, bonet_veh[0], bonet_veh[1], bonet_veh[2]);
        GetCoordBootVehicle(v, boot_veh[0], boot_veh[1], boot_veh[2]);
		if(IsPlayerInRangeOfPoint(playerid, 1.0, bonet_veh[0], bonet_veh[1], bonet_veh[2])) 
        {
            if(IsABoot(v)) sideId = 1; // Багажник
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1.0, boot_veh[0], boot_veh[1], boot_veh[2])) sideId = 2; // Капот
	}
	else // Багажник сзади
	{
        GetCoordBonnetVehicle(v, bonet_veh[0], bonet_veh[1], bonet_veh[2]);
        GetCoordBootVehicle(v, boot_veh[0], boot_veh[1], boot_veh[2]);
		if(IsPlayerInRangeOfPoint(playerid, 1.0, bonet_veh[0], bonet_veh[1], bonet_veh[2])) sideId = 2; // Капот
        else if(IsPlayerInRangeOfPoint(playerid, 1.0, boot_veh[0], boot_veh[1], boot_veh[2]))
        {
            if(IsABoot(v)) sideId = 1; // Багажник
        }
	}
	return sideId;
}

stock IsATrashBoot(playerid) // Позиция багажника в мусоровоза
{
	if(GetPlayerVirtualWorld(playerid) == 0)
	{
		new Float:Boot[3];
		for(new v = 0; v < SKOKOCAROV; v++)
		{
		    if(VehInfo[v][vModel] != 408) continue;
			
			GetCoordBootVehicle(v, Boot[0], Boot[1], Boot[2]);
			if(IsPlayerInRangeOfPoint(playerid, 2.5, Boot[0], Boot[1], Boot[2]))
			{
				return v;
			}
		}
	}
	return 0;
}

stock MaxVehicleHealth(model)
{
	new maxhealth;
    if(model == 428 || model == 470 || model == 528) maxhealth = 2000;
    else if(model == 427 || model == 433 || model == 425 || model == 548 || model == 601) maxhealth = 3000;
    else if(model == 432) maxhealth = 5000;
	else if(model == 537 || model == 538) maxhealth = 10000; // train
    else maxhealth = 1000;
	return maxhealth;
}

stock IsVehicleOpen(playerid, v)
{
	if((VehInfo[v][vSost] == PlayerInfo[playerid][pID] || VehInfo[v][vKey] == PlayerInfo[playerid][pID] && VehInfo[v][vKeyUnix] > gettime()) 
	&& GetPlayerVip(playerid) > 0) return 1; // Личный или есть ключи + VIP
	else
	{
		if(VehInfo[v][vCarLock] == 0) return 1; // Транспорт открыт
	}
	return 0;
}

stock GetVehicleType(model) // Получаем тип транспорта
{
    new type;

    // Автомобили (Требуются водительские права) Car
    if(model == 400 || model == 401 || model == 402 || model == 403 || model == 404 || model == 405
    || model == 406 || model == 407 || model == 408 || model == 409 || model == 410 || model == 411 || model == 412
    || model == 413 || model == 414 || model == 415 || model == 416 || model == 418 || model == 419 || model == 420
    || model == 421 || model == 422 || model == 423 || model == 424 || model == 426 || model == 427 || model == 428
    || model == 429 || model == 431 || model == 432 || model == 433 || model == 434 || model == 436 || model == 437
    || model == 438 || model == 439 || model == 440 || model == 442 || model == 443 || model == 444 || model == 445
    || model == 451 || model == 455 || model == 456 || model == 457 || model == 458 || model == 459 || model == 466 || model == 467
    || model == 470 || model == 474 || model == 475 || model == 477 || model == 478 || model == 479
    || model == 480 || model == 482 || model == 483 || model == 485 || model == 486 || model == 489 || model == 490 || model == 491
    || model == 492 || model == 494 || model == 495 || model == 496 || model == 498 || model == 499 || model == 500
    || model == 502 || model == 503 || model == 504 || model == 505 || model == 506 || model == 507 || model == 508
    || model == 514 || model == 515 || model == 516 || model == 517 || model == 518 || model == 524 || model == 525
    || model == 526 || model == 527 || model == 528 || model == 529 || model == 530 || model == 531 || model == 532 || model == 533 || model == 534
    || model == 535 || model == 536 || model == 540 || model == 541 || model == 542 || model == 543
    || model == 544 || model == 545 || model == 546 || model == 547 || model == 549 || model == 550 || model == 551
    || model == 552 || model == 554 || model == 555 || model == 556 || model == 557 || model == 558 || model == 559
    || model == 560 || model == 561 || model == 562 || model == 565 || model == 566 || model == 567 || model == 568
    || model == 572 || model == 573 || model == 574 || model == 575 || model == 576 || model == 578 || model == 579
    || model == 580 || model == 582 || model == 583 || model == 585 || model == 587 || model == 588 || model == 589
    || model == 596 || model == 597 || model == 598 || model == 599 || model == 600 || model == 601 || model == 602
    || model == 603 || model == 604 || model == 605 || model == 609) type = 1;

    // Мототранспорт (Требуется лицензия на мото транспорт) Moto
    else if(model == 448 || model == 461 || model == 462 || model == 463 || model == 468 || model == 471 || model == 521
    || model == 522 || model == 523 || model == 571 || model == 581 || model == 586) type = 2;

    // Водный Транспорт (Требуется лицензия на катер) Boat
    else if(model == 430 || model == 446 || model == 452 || model == 453 || model == 454 || model == 472
    || model == 473 || model == 484 || model == 493 || model == 539 || model == 595) type = 3;

    // Вертолёты (Требуется лицензия на вертолёт) Helicopter
    else if(model == 417 || model == 425 || model == 447 || model == 469 || model == 487 || model == 488 || model == 497 
    || model == 548 || model == 563) type = 4;

    // Самолёты (Требуется лицензия на самолёт) Plane
    else if(model == 460 || model == 476 || model == 511 || model == 512 || model == 513 || model == 519 || model == 520 
    || model == 553 || model == 577 || model == 592 || model == 593) type = 5;

    // Велотранспорт (Лицензия не требуется) Bicycle
    else if(model == 481 || model == 509 || model == 510) type = 6;
    return type;
}
stock GetVehicleClass(m)
{
    new class;

    // Premium Class (1) - Премиум
    if(m == 402 || m == 409 || m == 411 || m == 415 || m == 429 || m == 446 || m == 451 || m == 454 || m == 477 || m == 493 
    || m == 494 || m == 502 || m == 503 || m == 506 || m == 519 || m == 521 || m == 522 || m == 535 || m == 541 || m == 559
    || m == 560 || m == 562 || m == 565 || m == 580 || m == 586) class = 1;

    // Middle Class (2) - Средний
    else if(m == 401 || m == 405 || m == 418 || m == 419 || m == 421 || m == 426 || m == 439 || m == 445 || m == 452 || m == 460
    || m == 461 || m == 463 || m == 468 || m == 469 || m == 471 || m == 480 || m == 484 || m == 487 || m == 491 || m == 496
    || m == 507 || m == 511 || m == 516 || m == 533 || m == 534 || m == 550 || m == 551 || m == 555 || m == 558 || m == 561
    || m == 581 || m == 585 || m == 587 || m == 589 || m == 602 || m == 603) class = 2;

    // Economy Class (3) - Бомж
    else if(m == 404 || m == 410 || m == 412 || m == 436 || m == 453 || m == 458 || m == 462 || m == 466 || m == 467 || m == 472
    || m == 474 || m == 475 || m == 479 || m == 492 || m == 512 || m == 513 || m == 517 || m == 518 || m == 526 || m == 527
    || m == 529 || m == 536 || m == 540 || m == 542 || m == 546 || m == 547 || m == 549 || m == 553 || m == 566 || m == 567
    || m == 575 || m == 576 || m == 593 || m == 595 || m == 600) class = 3;

    // Off-Road Class (4) - Внедорожник
    else if(m == 400 || m == 422 || m == 489 || m == 495 || m == 500 || m == 543 || m == 554 || m == 579) class = 4;

    // Special Class (5) - Грузовая и Спец Техника
    else if(m == 403 || m == 413 || m == 414 || m == 417 || m == 440 || m == 455 || m == 456
    || m == 459 || m == 478 || m == 482 || m == 498 || m == 499 || m == 508 || m == 514 || m == 515 || m == 578) class = 5;

    // Unique Class (6) - Уникальный Транспорт
    else if(m == 423 || m == 424 || m == 431 || m == 434 || m == 437 || m == 442 || m == 443 || m == 444 || m == 457 || m == 473 
    || m == 476 || m == 481 || m == 483
    || m == 504 || m == 509 || m == 510 || m == 530 || m == 531 || m == 532 || m == 545 || m == 556 || m == 557 || m == 571 
    || m == 573 || m == 577 || m == 588 || m == 592) class = 6;

    // Goverment Class (7) - Государственный Транспорт
    else if(m == 406 || m == 407 || m == 408 || m == 416 || m == 420 || m == 425 || m == 427 || m == 428 || m == 430 || m == 432 
    || m == 438 || m == 447 || m == 448 || m == 470 || m == 485 || m == 486 || m == 488 || m == 490 || m == 497 || m == 520
    || m == 523 || m == 524 || m == 525 || m == 528 || m == 539 || m == 544 || m == 548 || m == 552 || m == 563 || m == 572 
    || m == 574 || m == 582 || m == 583 || m == 596 || m == 597 || m == 598 || m == 599 || m == 601) class = 7;

    else class = 0; // 0 Класс недоступен для продажи (неизвестный транспорт)
    return class;
}

stock IsABoot(carid) // Транспорт, у которых есть багажник
{
	new model = GetVehicleModel(carid);
	if(model == 400 || model == 401 || model == 402 || model == 404 || model == 405 || model == 409 || model == 410 || model == 411 || model == 412 || model == 413
    || model == 415 || model == 418 || model == 419 || model == 420 || model == 421 || model == 422 || model == 426 || model == 429 || model == 433 || model == 434 || model == 436
    || model == 438 || model == 439 || model == 440 || model == 442 || model == 444 || model == 445 || model == 451 || model == 458 || model == 459 || model == 466 || model == 467
    || model == 470 || model == 474 || model == 475 || model == 477 || model == 479 || model == 480 || model == 483 || model == 489 || model == 490 || model == 491
    || model == 492 || model == 494 || model == 495 || model == 496 || model == 498 || model == 500 || model == 502 || model == 503 || model == 504 || model == 505 || model == 506
    || model == 507 || model == 516 || model == 517 || model == 518 || model == 526 || model == 527 || model == 528 || model == 529 || model == 533 || model == 534 || model == 535
    || model == 536 || model == 540 || model == 541 || model == 542 || model == 543 || model == 545 || model == 546 || model == 547 || model == 549 || model == 550 || model == 551
    || model == 554 || model == 555 || model == 556 || model == 557 || model == 558 || model == 559 || model == 560 || model == 561 || model == 562 || model == 565 || model == 566
    || model == 567 || model == 573 || model == 575 || model == 576 || model == 579 || model == 580 || model == 585 || model == 587 || model == 589 || model == 596 || model == 597
    || model == 598 || model == 599 || model == 600 || model == 601 || model == 602 || model == 603 || model == 604 || model == 605 || model == 609) return 1;
	return 0;
}

stock IsABootFront(carid)
{
	new model = GetVehicleModel(carid);
	if(model == 415 || model == 424 || model == 451 || model == 483 || model == 486 || model == 541 || model == 568) return 1;
	return 0;
}

stock IsA_Gen5(carid) // 5 слотов в багажнике
{
	new model = GetVehicleModel(carid);
	if(model == 400 || model == 401 || model == 402 || model == 404 || model == 405 || model == 409 || model == 410 || model == 411 || model == 412 || model == 415
    || model == 419 || model == 420 || model == 421 || model == 426 || model == 429 || model == 434 || model == 436 || model == 438 || model == 439 || model == 442 || model == 445
    || model == 451 || model == 458 || model == 466 || model == 467 || model == 470 || model == 474 || model == 475 || model == 477 || model == 479 || model == 480 || model == 489
    || model == 490 || model == 491 || model == 492 || model == 495 || model == 496 || model == 500 || model == 504 || model == 505 || model == 506 || model == 507 || model == 516
    || model == 517 || model == 518 || model == 526 || model == 527 || model == 529 || model == 533 || model == 534 || model == 536 || model == 540 || model == 541 || model == 542
    || model == 545 || model == 546 || model == 547 || model == 549 || model == 550 || model == 551 || model == 555 || model == 558 || model == 559 || model == 560 || model == 561
    || model == 562 || model == 565 || model == 566 || model == 567 || model == 575 || model == 576 || model == 579 || model == 580 || model == 585 || model == 587 || model == 589
    || model == 596 || model == 597 || model == 598 || model == 599 || model == 602 || model == 603 || model == 604){return 1;}
	return 0;
}
stock IsA_Gen10(carid) // 10 слотов в багажнике
{
	new model = GetVehicleModel(carid);
	if(model == 418 || model == 422 || model == 444 || model == 543 || model == 554 || model == 556 || model == 557 || model == 600 || model == 605){return 1;}
	return 0;
}
stock IsA_Gen15(carid) // 15 слотов в багажнике
{
	new model = GetVehicleModel(carid);
	if(model == 413 || model == 414 || model == 440 || model == 459 || model == 478 || model == 482 || model == 498 || model == 499 || model == 609){return 1;}
	return 0;
}

stock IsATaxi(carid) // Транспорт, который разрешён для работы в такси
{
	new model = GetVehicleModel(carid);
	if(model >= 400 && model <= 424 || model >= 426 && model <= 429 || model == 431 || model == 433 || model == 434 || model >= 436 && model <= 440 || model >= 442 && model <= 445
 	|| model == 447 || model == 448 || model == 451 || model >= 455 && model <= 463 || model >= 466 && model <= 471 || model == 474 || model == 475 || model >= 477 && model <= 480
 	|| model == 482 || model == 483 || model >= 487 && model <= 492 || model >= 494 && model <= 500 || model >= 502 && model <= 508 || model == 511 || model >= 514 && model <= 518
 	|| model >= 521 && model <= 529 || model >= 533 && model <= 536 || model >= 540 && model <= 552 || model >= 554 && model <= 563 || model >= 565 && model <= 567
 	|| model >= 573 && model <= 576 || model >= 578 && model <= 582 || model >= 585 && model <= 589 || model == 593 || model >= 596 && model <= 605 || model == 609) return 1;
	return 0;
}

stock IsAVello(carid) // Велики
{
	new model = GetVehicleModel(carid);
	new type = GetVehicleType(model);
	if(type == 6) return 1;
	return 0;
}

stock IsAZad(model) // Транспорт с задними окнами
{
    if(model == 404 || model == 405 || model == 409 || model == 420 || model == 421 || model == 426 || model == 438
	|| model == 445 || model == 458 || model == 466 || model == 467 || model == 470 || model == 479 || model == 490
 	|| model == 492 || model == 507 || model == 516 || model == 529 || model == 540 || model == 546 || model == 547
  	|| model == 550 || model == 551 || model == 560 || model == 561 || model == 566 || model == 579 || model == 580
   	|| model == 585 || model == 596 || model == 597 || model == 598 || model == 604) return 1;
	return 0;
}

stock IsACar(model) // Авто
{
	new type = GetVehicleType(model);
	if(type == 1) return 1;
	return 0;
}

stock IsANotTuning(model) // Запрещено ставить тюнинг
{
    if(model == 539) return 1;
	return 0;
}

stock IsABoat(model) // Лодки
{
	new type = GetVehicleType(model);
	if(type == 3) return 1;
	return 0;
}

// Воздушный ТС Самолёты и Вертолёты
stock IsAPlane(model)
{
	new type = GetVehicleType(model);
	if(type == 4 || type == 5) return 1;
	return 0;
}

// Самолёты
stock IsAAir(model)
{
	new type = GetVehicleType(model);
	if(type == 5) return 1;
	return 0;
}
// Вертолёты
stock IsAHeli(model)
{
	new type = GetVehicleType(model);
	if(type == 4) return 1;
	return 0;
}

stock IsAMoto(model)
{
	new type = GetVehicleType(model);
	if(type == 2) return 1;
	return 0;
}

stock IsATrain(model)
{
    if(model == 537 || model == 538 || model == 569 || model == 570 || model == 590) return 1;
	return 0;
}

stock IsAShassi(model)
{
    if(model == 460 || model == 476 || model == 511 || model == 512 || model == 513 || model == 519 || model == 520 || model == 553 || model == 577
    || model == 592|| model == 593) return 1;
	return 0;
}

stock IsABig(model)
{
    if(model == 403 || model == 406 || model == 407 || model == 408 || model == 414 || model == 416 || model == 427 || model == 428
	|| model == 431 || model == 432 || model == 433 || model == 437 || model == 443 || model == 444 || model == 445 || model == 456
	|| model == 486 || model == 498 || model == 499 || model == 508 || model == 514 || model == 515 || model == 524 || model == 528
 	|| model == 532 || model == 544 || model == 556 || model == 557 || model == 573 || model == 578 || model == 582 || model == 588
  	|| model == 601 || model == 609 || model == 455 || model == 531) return 1;
	return 0;
}

stock IsATun(model) // Транспорт, на который можно на сервере устанавливать обвесы
{
    if(model == 558 || model == 559 || model == 560 || model == 561 || model == 562 || model == 565) return 1;
	return 0;
}

stock IsAMafCar(model) // Транспорт для мафий
{
    if(model == 405 || model == 609 || model == 445 || model == 562 || model == 461 || model == 579 || model == 540
    || model == 602 || model == 580 || model == 409 || model == 439 || model == 477 || model == 489 || model == 507
	|| model == 529 || model == 533 || model == 550 || model == 555 || model == 589 || model == 402 || model == 439
 	|| model == 451 || model == 506 || model == 521 || model == 560) return 1;
	return 0;
}

stock IsAGangCar(model) // Транспорт для банд
{
    if(model == 492 || model == 567 || model == 536 || model == 535 || model == 475 || model == 468 || model == 412 || model == 566
    || model == 517 || model == 576 || model == 575 || model == 467 || model == 466 || model == 482 || model == 419 || model == 518
	|| model == 534 || model == 404 || model == 413 || model == 422 || model == 471 || model == 474 || model == 479 || model == 491
 	|| model == 496 || model == 498 || model == 529 || model == 533 || model == 542 || model == 549 || model == 581 || model == 600
  	|| model == 603) return 1;
	return 0;
}
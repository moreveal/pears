 stock ThefThingFromDom(playerid)
{
    new findObject = -1;
    if(GetPlayerVirtualWorld(playerid) >= 1001 && GetPlayerVirtualWorld(playerid) <= 3000)
    {
        if(Hold[playerid] == 1)
		{
            new dom = GetPlayerVirtualWorld(playerid) - 1000;
            if(dom == PlayerInfo[playerid][pDom]) return ErrorMessage(playerid, "{FF6347}Вы не можете ограбить свой дом");
            if(dom == PlayerInfo[playerid][pHouserent]) return ErrorMessage(playerid, "{FF6347}Вы не можете ограбить дом, в котором проживаете");
            if(DomInfo[dom][dFam] >= 1 && PlayerInfo[playerid][pFamily] == DomInfo[dom][dFam]) return ErrorMessage(playerid, "{FF6347}Вы не можете ограбить дом своей семьи");
            if(!IsGangMember(playerid) && !IsMafiaMember(playerid)) return ErrorMessage(playerid, "{FF6347}Украсть мебель может только участник преступной группировки (Банда, Мафия)");
            if(OnlineInfo[playerid][oOnBackThing][0] > 0) return ErrorMessage(playerid, "{FF6347}У вас уже есть предмет в мешке\n\n{cccccc}Отправляйтесь на арендованный склад своей организации, чтобы получить юниты");
            if(DomInfo[dom][dTheftQuan] > 0 && DomInfo[dom][dTheft] < gettime()) return ErrorMessage(playerid, "{FF6347}Закончилось время активного ограбления или ограбление не начато");
            if(DomInfo[dom][dTheftQuan] >= 4) return ErrorMessage(playerid, "{FF6347}За одно ограбление, можно украсть не больше 4-ёх предметов мебели");
            if(get_invent4(playerid, 23, 0) <= 0) return ErrorMessage(playerid, "{FF6347}У вас нет мешка, куда складывать награбленное {cccccc}[ Y >> GPS >> Услуги >> Супермаркет ]");
            ApplyAnimation(playerid,"PED","flee_lkaround_01",4.0, false, false, false, false, false);
            findObject = FindTheftDomObject(playerid, dom); // Ищем объект
            if(findObject == -1)
            {
                ErrorMessage(playerid, "{FF6347}Вы не нашли предмет, который можно украсть из дома\nПопробуйте поискать в другой комнате\n\n{cccccc}Украсть можно только предмет, который продаётся в IKEA");
            }
            else // Нашли предмет
            {
                if(DomInfo[dom][dTheftCd] < gettime()) DomInfo[dom][dTheftCd] = gettime() + 604800; // Записываем кд на ограбление дома
                if(DomInfo[dom][dTheft] < gettime()) // Объявляем новое ограбление
                {
                    DomInfo[dom][dTheft] = gettime() + 300;
                    DomInfo[dom][dTheftQuan] = 0;
                }
                DomInfo[dom][dTheftQuan] ++;
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, true, true, false, false);
                PlayerPlaySound(playerid,1053,0,0,0);
                OnlineInfo[playerid][oOnBackThing][0] = GetDynamicObjectModel(DomInfo[dom][dObject][findObject]);
                OnlineInfo[playerid][oOnBackThing][1] = 1;
                OnlineInfo[playerid][oOnBackThing][2] = findObject; // Записываем номер объекта мебели в системе
                OnlineInfo[playerid][oOnBackThing][3] = dom; // Краденый (записываем номер дома!)
                OnlineInfo[playerid][oOnBackThing][4] = 4;
                OnlineInfo[playerid][oOnBackThing][5] = 3; // Упаковываем в мешок
                SetPlayerAttachedObject(playerid, 2, 2060, 1, 0.076999, -0.155999, 0.000000, 91.999961, 0.000000, 0.000000, 0.610000, 0.649999, 0.664000, 0, 0);
                SuccessMessage(playerid, "{99ff66}Ай какой ты молодец, спёр мебель из дома\n\n{cccccc}Отнеси мешок на склад вашей организации, чтобы получить юниты");
            }
        }
    }
    return findObject;
}

stock FindTheftInIkea(model)
{
    new yesFind;
    for(new i = 0; i < MAX_IKEA; i++)
    {
        if(IkeaInfo[i][iModel] == model)
        {
            yesFind = 1;
            break;
        }
    }
    return yesFind;
}

stock FindTheftDomObject(playerid, dom)
{
    new findObject = -1, Float:table_pos[3];
    for(new i = 1; i < MAX_OBJECT_INT; i++)
    {
        if(IsValidDynamicObject(DomInfo[dom][dObject][i]))
        {
            if(DomInfo[dom][dObject][i])
            {
                GetDynamicObjectPos(DomInfo[dom][dObject][i], table_pos[0], table_pos[1], table_pos[2]);
                if(IsPlayerInRangeOfPoint(playerid,5.0, table_pos[0], table_pos[1], table_pos[2]))
                {
                    if(FindTheftInIkea(GetDynamicObjectModel(DomInfo[dom][dObject][i])))
                    {
                        findObject = i;
                        break;
                    }
                }
            }
        }
    }
    return findObject;
}
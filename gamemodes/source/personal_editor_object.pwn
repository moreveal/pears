
/*
- Сделать адм команду (1 раз предупреждение, 2 раз блокировка к личному редактору, админ выставит время блокировки) - в случае если чел в интерьер общего доступа (дом, биз) поставил хуету
- Добавить unix для каждого объекта и карты в целом (чтобы можно было в будущем удалять не используемые мапы в личных редакторах)

- Сохранение в базу (изменение строк, добавление и удаление лишних)
- Отправление интерьера из личного редактора на одобрение админам
- Админ команды одобрения и отказа в публикации интерьера в шоурум
- Создать быструю установку интерьера в дом или бизнес за 500 gold (в обход системы ремонта)


- /mtset - замена текстуры на объекте по слоту и номеру текстуры
- /mtsetall - замена текстур на всех объектах одной модели по слоту и номеру текстуры
- на кнопку N - открывать редактор текстур перед лицом, а не внутри хрен знает чего и летающей камеры
- на кнопку Y - открывать список редактируемых текстур на объекте в виде текстдравов на экране
- Убираю стандартный редактор текстур из редактора интерьеров домов и бизнесов
- Нужно учитывать класс и тип планировки при загрузке интерьера и его публикации

- При загрузке интерьера и включённом отображении лейблов - отображать сразу все лейблы на объектах (/loadmap)

Редактор текстур:
- Сделать поиск по ID
- Сделать поиск по названию или названию библиотеки
- Сделать добавление текстур в избранное
- Отображение слотов текстур на объекте в виде текстдравов справа
*/

#define MAX_TEXT_OBJECT_LENGTH 124 // Максимальное количество символов текст на объекте
#define MAX_OBJECT_TEXTURES 38 // Максимальное количество текстур на объекте
#define         MAX_MATERIALS               16
#define         MAX_TEXT_LENGTH             129

enum peoEnum // Enum отвечающий за личный редактор объектов
{
    bool:peoInEditor, // Статус - находится ли игрок внутри редактора

    // Переменные отвечающие за загруженный интерьер (для админов, он может быть и чужим)
    peoNewid, // id из базы данных
    bool:peoLoaded, // Статус - загружен из базы или нет
    peoName[34], // Название интерьера
    peoQuanUpdates, // Количество изменений в интерьере с момента сохранения или загрузки
    peoQuanObjects, // Количество объектов в интерьере
    peoCreatorId, // ID создателя интерьера
    peoCreatorName[24], // Имя создателя интерьера
    bool:peoStatusLoad, // Статус загружается ли интерьер в данный момент
    peoPriceInterior, // Стоимость интерьера без учёта мебели и текстур
    peoPublicationStatus, // Статус публикации интерьера в шоурум
    peoSelObject, // Выбранный объект для редактирования

    // Переменные отвечающие за объекты
    peoObject[MAX_OBJECT_INT], // ID Объекта присваеваемый в Streamer
    peoModel[MAX_OBJECT_INT], // id модели объекта
    Float:peoX[MAX_OBJECT_INT], // координата объекта
    Float:peoY[MAX_OBJECT_INT], // координата объекта
    Float:peoZ[MAX_OBJECT_INT], // координата объекта
    Float:peoRX[MAX_OBJECT_INT], // координата объекта
    Float:peoRY[MAX_OBJECT_INT], // координата объекта
    Float:peoRZ[MAX_OBJECT_INT], // координата объекта
    Text3D:peoObjectLabel[MAX_OBJECT_INT], // Label объектов
    bool:peoObjectLabelStatus, // Статус отображения 3d лейблов на объектах
};
new peoInfo[MAX_REALPLAYERS][peoEnum];
new peoTexture[MAX_REALPLAYERS][MAX_OBJECT_INT][MAX_TEXTURES_ON_OBJECTS]; // Переменные хранения текстур на объекте

stock showDialogPersonalEditor(playerid, targetid)
{
    new line[90],lines[990];
    format(line,sizeof(line),"Изменений: %d \t ", peoInfo[targetid][peoQuanUpdates]), strcat(lines,line);

    format(line,sizeof(line),"\n{A86CFB}* {cccccc}Объекты >> \t {cccccc}[ %d ]", peoInfo[targetid][peoQuanObjects]), strcat(lines,line);
    format(line,sizeof(line),"\n{A86CFB}* {cccccc}Планировка \t "), strcat(lines,line);
    format(line,sizeof(line),"\n{A86CFB}* {cccccc}Название интерьера \t {FF9000}%s", peoInfo[targetid][peoName]), strcat(lines,line);
    format(line,sizeof(line),"\n{A86CFB}* {cccccc}Стоимость интерьера \t {99ff66}%d$", peoInfo[targetid][peoPriceInterior]), strcat(lines,line);

    if(!peoInfo[targetid][peoObjectLabelStatus]) format(line,sizeof(line),"\n{A86CFB}* {cccccc}3D Text Label \t {FF6347}[ Off ]"), strcat(lines,line);
    else format(line,sizeof(line),"\n{A86CFB}* {cccccc}3D Text Label \t {99ff66}[ On ]"), strcat(lines,line);

    if(!peoInfo[targetid][peoLoaded]) format(line,sizeof(line),"\n{A86CFB}* {cccccc}Загрузить сохранённый интерьер \t "), strcat(lines,line);
    else format(line,sizeof(line),"\n{A86CFB}* {cccccc}Выгрузить интерьер \t {99ff66}[ Загружен ]"), strcat(lines,line);

    format(line,sizeof(line),"\n{A86CFB}* {cccccc}Использовать доступный интерьер \t "), strcat(lines,line);

    format(line,sizeof(line),"\n{A86CFB}* {99ff66}Сохранить интерьер \t "), strcat(lines,line);
    format(line,sizeof(line),"\n{FF6347}Выйти из редактора\t "), strcat(lines,line);
    format(line,sizeof(line),"\n{666666}Команды редактора {A86CFB}>> \t "), strcat(lines,line);
    ShowDialog(playerid,1292,DIALOG_STYLE_TABLIST_HEADERS,"{A86CFB}Редактор Интерьера",lines,"Выбрать","Выход");
    return 1;
}

stock showDialogAllObjectsPeo(playerid, targetid)
{
	PlayerPlaySound(playerid,40405,0,0,0);

    new line[100],lines[4048];
    format(line,sizeof(line),"ID ModelID Название \t Гос. цена"), strcat(lines,line);
 	for(new i = 0; i < MAX_OBJECT_INT; i++)
	{
	    if(peoInfo[targetid][peoModel][i] > 0)
	    {
	        if(i == 0) format(line,sizeof(line),"\n{cccccc}%d. Планировка \t {99ff66}%d$", i, getFrameObjectPrice(peoInfo[targetid][peoModel][i])), strcat(lines,line);
	        else format(line,sizeof(line),"\n{cccccc}%d. %d (%s) \t {99ff66}%d$", i, peoInfo[targetid][peoModel][i], getIkeaObjectName(peoInfo[targetid][peoModel][i]), getIkeaObjectPrice(peoInfo[targetid][peoModel][i])), strcat(lines,line);
		}
		else format(line,sizeof(line),"\n{cccccc}%d. ... \t ",i), strcat(lines,line);
	}
    ShowDialog(playerid,1295,DIALOG_STYLE_TABLIST_HEADERS,"{A86CFB}Редактор Интерьера",lines,"*","");
	return 1;
}

stock showUseInterior(playerid) // Показываем список интерьеров, которые игрок может загрузить в личный редактор
{
    PlayerPlaySound(playerid,40405,0,0,0);
    new line[100],lines[1400];

    for(new i = 0; i < 200; i++) List[i][playerid] = 0, ListParam[i][playerid] = 0;

    new quan;
    // Собственный дом
    if(PlayerInfo[playerid][pDom] > 0)
    {
        List[quan][playerid] = PlayerInfo[playerid][pDom];
        ListParam[quan][playerid] = 0;
        quan ++;
        format(line,sizeof(line),"{cccccc}Дом № {ff9000}%d\n", PlayerInfo[playerid][pDom]), strcat(lines,line);
    }

    // Арендованный дом
    if(PlayerInfo[playerid][pHouserent] > 0)
    {
        new d = PlayerInfo[playerid][pHouserent];
        if(DomInfo[d][dAccfur] == 1 || DomInfo[d][dAccfur] == 3)
        {
            List[quan][playerid] = d;
            ListParam[quan][playerid] = 0;
            quan ++;
            format(line,sizeof(line),"{cccccc}Арендованный Дом № {ff9000}%d\n", d), strcat(lines,line);
        }
    }

    // Семейный Дом
    if(PlayerInfo[playerid][pFamily] > 0)
    {
        new f = PlayerInfo[playerid][pFamily];
        new d = FamilyInfo[f][fDop5];
        if(d > 0)
        {
            if(DomInfo[d][dFam] == f && DomInfo[d][dAccfur] >= 2) 
            {
                List[quan][playerid] = d;
                ListParam[quan][playerid] = 0;
                quan ++;
                format(line,sizeof(line),"{cccccc}Семейный Дом № {ff9000}%d\n", d), strcat(lines,line);
            }
        }
    }

    // Личный Бизнес
    if(PlayerInfo[playerid][pBusiness] > 0)
    {
        List[quan][playerid] = PlayerInfo[playerid][pBusiness];
        ListParam[quan][playerid] = 1;
        quan ++;
        format(line,sizeof(line),"{cccccc}%s № {ff9000}%d\n", bizname(PlayerInfo[playerid][pBusiness]), PlayerInfo[playerid][pBusiness]), strcat(lines,line);
    }

    // Семейные бизнесы
    new b;
    if(PlayerInfo[playerid][pFamily] > 0)
    {
        new f = PlayerInfo[playerid][pFamily];
        for(new fb = 0; fb < 10; fb++)
        {
            if(FamilyInfo[f][fBiz][fb] == 0) continue;
            b = FamilyInfo[f][fBiz][fb];
            if(!IsABizInteriorFrame(b)) continue;

            List[quan][playerid] = b;
            ListParam[quan][playerid] = 1;
            quan ++;
            format(line,sizeof(line),"{cccccc}%s № {ff9000}%d\n", bizname(b), b), strcat(lines,line);
        }
    }
    ShowDialog(playerid,1298,DIALOG_STYLE_TABLIST,"{A86CFB}Редактор Интерьера",lines,"Выбрать","Назад");
    return 1;
}

stock CreateObjectPeoInterior(playerid, peoId, modelId, slotId, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, world, interior) // Сток создания объекта
{
    peoInfo[peoId][peoModel][slotId] = modelId;
    peoInfo[peoId][peoX][slotId] = x;
    peoInfo[peoId][peoY][slotId] = y;
    peoInfo[peoId][peoZ][slotId] = z;
    peoInfo[peoId][peoRX][slotId] = rx;
    peoInfo[peoId][peoRY][slotId] = ry;
    peoInfo[peoId][peoRZ][slotId] = rz;
    peoInfo[peoId][peoObject][slotId] = CreateDynamicObject(modelId, x, y, z, rx, ry, rz, world, interior, -1, 100.00, 100.00);

    if(slotId > 0)
    {
        if(peoInfo[playerid][peoObjectLabelStatus]) create3dtextLabel(playerid, slotId); // 3d label ставим, если включено отображение
    }
    return 1;
}

CMD:loadtobiz(playerid, const params[])
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");
    if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Загрузить интерьер из личного редактора в бизнес [ /loadtobiz ID Бизнеса ]");
    if(params[0] <= 0 || params[0] >= MAX_BIZ) return ErrorMessage(playerid, "{FF6347}Неверный ID бизнеса");
    if(!IsABizInteriorFrame(params[0])) return ErrorMessage(playerid, "{FF6347}В этом бизнесе недоступна система интерьеров");
    if(IsAJizzyBiz(params[0])) return ErrorMessage(playerid, "{FF6347}В этот бизнес нельзя установить интерьер\n{cccccc}Пример: Бизнес Jizzy имеет собственный каркас из нескольких частей");
    LoadInteriorToBiz(playerid, params[0]);
    return 1;
}
stock LoadInteriorToBiz(playerid, b)
{
    new peoId = GetPlayerVirtualWorld(playerid)-4000;

    // Переменные для хранения информации об объекте
    new Float:pos[6];

    new text[MAX_TEXT_LENGTH];
    new materialsize;
    new fontface[12];
    new fontsize;
    new bold;
    new fontcolor;
    new backcolor, textalignment;
    new yestext;

    new quan, quanTextures;

    // Начало транзакции
	mysql_tquery(pearsq, "START TRANSACTION;");

    for(new i = 0; i < MAX_OBJECT_INT; i++)
    {
        // Удаляем текущие объекты из бизнеса
        if(BizzInfo[b][bOmodel][i] > 0) 
        {
            DestroyDynamicObject(BizzInfo[b][bObject][i]);
            if(peoInfo[peoId][peoObject][i] == 0 || peoInfo[peoId][peoModel][i] == 0) DelObjectBiz(b, i); // Удаляем только если не перезаписываем
        }

        if(peoInfo[peoId][peoObject][i] == 0 || peoInfo[peoId][peoModel][i] == 0)  continue;

        // Получаем инфу об объекте
        GetDynamicObjectPos(peoInfo[peoId][peoObject][i], pos[0], pos[1], pos[2]);
        GetDynamicObjectRot(peoInfo[peoId][peoObject][i], pos[3], pos[4], pos[5]);

        // Создаём объект
        BizzInfo[b][bOmodel][i] = peoInfo[peoId][peoModel][i];
        BizzInfo[b][bObject][i] = CreateDynamicObject(BizzInfo[b][bOmodel][i], pos[0], pos[1], pos[2], pos[3], pos[4], pos[5], b+3000, 90, -1, 100.00, 100.00);
        BizzInfo[b][bQara][i] = 0;
        BizzInfo[b][bUser][i] = PlayerInfo[playerid][pID];

        // загрузка текстур и текста
        for(new m = 0; m < MAX_OBJECT_TEXTURES; m++)
        {
            new modelid, txdname[44], texturename[44], materialcolor;
            GetDynamicObjectMaterial(peoInfo[peoId][peoObject][i], m, modelid, txdname, texturename, materialcolor);
            if(modelid > 0)
            {
                SetDynamicObjectMaterial(BizzInfo[b][bObject][i], m, modelid, txdname, texturename, materialcolor);
                //modelid = 0;
                quanTextures ++;
            }

            yestext = GetDynamicObjectMaterialText(peoInfo[peoId][peoObject][i], m, text, materialsize, fontface, fontsize, bold, fontcolor, backcolor, textalignment);
            if(yestext) 
            {
                SetDynamicObjectMaterialText(BizzInfo[b][bObject][i], m, text, materialsize, fontface, fontsize, bold, fontcolor, backcolor, textalignment);
                yestext = 0;
            }
        }

        UpdateObjectBiz(b, i); // Сохраняем сразу в базу
        quan ++;
    }

    // Завершение транзакции
	mysql_tquery(pearsq, "COMMIT;");

    SaveBizz(b);

    new string[144];
    format(string, sizeof(string), "{99ff66}Вы установили интерьер из личного редактора в бизнес № %d\nКоличество объектов: %d\nКоличество текстур: %d", b, quan, quanTextures);
    SuccessMessage(playerid, string);
	BizLog("loadtobiz", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], b, 0, "Установил интерьер");
    return 1;
}

stock useAvailableInterior(playerid, propId, typeProperty)
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");
    if(peoInfo[playerid][peoStatusLoad]) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения загрузки интерьера");
    if(gRedakt[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Завершите редактирование объекта");
    if(OnlineInfo[playerid][oShowInterface] == 14) return ErrorMessage(playerid, "{FF6347}Покиньте меню выбора планировки");

    DestroyPeoInterior(playerid); // Удаляем все объекты

    new modelid;
    new txdname[32];
    new texturename[32];
    new materialcolor;

    new text[MAX_TEXT_LENGTH];
    new materialsize;
    new fontface[12];
    new fontsize;
    new bold;
    new fontcolor;
    new backcolor, textalignment;
    new yestext;

    // Грузим объекты из дома
    if(typeProperty == 0)
    {
        for(new i = 0; i < MAX_OBJECT_INT; i++)
        {
            if(DomInfo[propId][dOmodel][i] > 0) 
            {
                new Float:pos[3], Float:rot[3];
                GetDynamicObjectPos(DomInfo[propId][dObject][i], pos[0], pos[1], pos[2]);
                GetDynamicObjectRot(DomInfo[propId][dObject][i], rot[0], rot[1], rot[2]);

                CreateObjectPeoInterior(playerid, playerid, DomInfo[propId][dOmodel][i], i, pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], playerid+4000, 90);
                peoInfo[playerid][peoQuanObjects] ++;

                for(new t = 0; t < MAX_TEXTURES_ON_OBJECTS; t++)
                {
                    GetDynamicObjectMaterial(DomInfo[propId][dObject][i], i, modelid, txdname, texturename, materialcolor);
                    if(modelid > 0)
                    {
                        SetDynamicObjectMaterial(DomInfo[propId][dObject][i], i, modelid, txdname, texturename, materialcolor);
                        modelid = 0;
                    }

                    yestext = GetDynamicObjectMaterialText(DomInfo[propId][dObject][i], i, text, materialsize, fontface, fontsize, bold, fontcolor, backcolor, textalignment);
                    if(yestext)
                    {
                        SetDynamicObjectMaterialText(DomInfo[propId][dObject][i], i, text, materialsize, fontface, fontsize, bold, fontcolor, backcolor, textalignment);
                        yestext = 0;
                    }
                }
            }
        }
    }
    // Грузим объекты из бизнеса
    else if(typeProperty == 1)
    {
        for(new i = 0; i < MAX_OBJECT_INT; i++)
        {
            if(BizzInfo[propId][bOmodel][i] > 0) 
            {
                new Float:pos[3], Float:rot[3];
                GetDynamicObjectPos(BizzInfo[propId][bObject][i], pos[0], pos[1], pos[2]);
                GetDynamicObjectRot(BizzInfo[propId][bObject][i], rot[0], rot[1], rot[2]);

                CreateObjectPeoInterior(playerid, playerid, BizzInfo[propId][bOmodel][i], i, pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], playerid+4000, 90);
                peoInfo[playerid][peoQuanObjects] ++;

                for(new t = 0; t < MAX_TEXTURES_ON_OBJECTS; t++)
                {
                    GetDynamicObjectMaterial(BizzInfo[propId][bObject][i], t, modelid, txdname, texturename, materialcolor);
                    if(modelid > 0) 
                    {
                        SetDynamicObjectMaterial(BizzInfo[propId][bObject][i], t, modelid, txdname, texturename, materialcolor);
                        modelid = 0;
                    }

                    yestext = GetDynamicObjectMaterialText(BizzInfo[propId][bObject][i], t, text, materialsize, fontface, fontsize, bold, fontcolor, backcolor, textalignment);
                    if(yestext) 
                    {
                        SetDynamicObjectMaterialText(BizzInfo[propId][bObject][i], t, text, materialsize, fontface, fontsize, bold, fontcolor, backcolor, textalignment);
                        yestext = 0;
                    }
                }
            }
        }
    }
    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

    new string[90];
    if(typeProperty == 0) format(string,sizeof(string),"{99ff66}Вы загрузили в личный редактор интерьер {ff9000}Дома № %d", propId);
    else if(typeProperty == 1) format(string,sizeof(string),"{99ff66}Вы загрузили в личный редактор интерьер {ff9000}Бизнеса № %d", propId);
	SuccessMessage(playerid, string);
    return 1;
}

stock showDialogCommandEditor(playerid)
{
    new line[80],lines[1120];
	format(line,sizeof(line),"\n{A86CFB}/loadinterior {cccccc}- загрузить сохранённый интерьер"), strcat(lines,line);
	format(line,sizeof(line),"\n{A86CFB}/unloadinterior {cccccc}- выгрузить интерьер"), strcat(lines,line);
    format(line,sizeof(line),"\n{A86CFB}/nameinterior {cccccc}- название интерьера"), strcat(lines,line);
    format(line,sizeof(line),"\n{A86CFB}/priceinterior {cccccc}- указать стоимость интерьера"), strcat(lines,line);
    format(line,sizeof(line),"\n{A86CFB}/exiteditor {cccccc}- выйти из редактора"), strcat(lines,line);

	format(line,sizeof(line),"\n\n{A86CFB}/cobject {cccccc}- создать объект"), strcat(lines,line);
    format(line,sizeof(line),"\n{A86CFB}/sel {cccccc}- выбрать объект"), strcat(lines,line);
	format(line,sizeof(line),"\n{A86CFB}/eobject {cccccc}- переместить объект"), strcat(lines,line);
	format(line,sizeof(line),"\n{A86CFB}/dobject {cccccc}- удалить объект"), strcat(lines,line);
	format(line,sizeof(line),"\n{A86CFB}/ox /oy /oz /rx /ry /rz {cccccc}- установка угла объекта"), strcat(lines,line);
    format(line,sizeof(line),"\n{A86CFB}/label3d {cccccc}- 3d label для отображения id объектов"), strcat(lines,line);
    format(line,sizeof(line),"\n{A86CFB}/clone {cccccc}- копировать выбранный объект"), strcat(lines,line);
    format(line,sizeof(line),"\n{A86CFB}/model {cccccc}- заменить модель выбранного объекта"), strcat(lines,line);

    if(PlayerInfo[playerid][pSoska] >= 22) format(line,sizeof(line),"\n{A86CFB}/loadmap {cccccc}- загрузить мап из map_interior.db"), strcat(lines,line);
	ShowDialog(playerid,1295,DIALOG_STYLE_MSGBOX,"{A86CFB}Редактор Интерьера",lines,"*","");
    return 1;
}

CMD:editor(playerid) // Команда для открытия диалогового окна с управлением редактором
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");
    showDialogPersonalEditor(playerid, playerid);
    return 1;
}

CMD:priceinterior(playerid, const params[])
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");
    new world = GetPlayerVirtualWorld(playerid);
    new peoId = world-4000;
    if(peoId != playerid) return ErrorMessage(playerid, "{FF6347}Вы находитесь в чужом личном редакторе");

    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Стоимость интерьера в личном редакторе [ /priceinterior Стоимость ]");
    if(params[0] <= 0 || params[0] > 100000000) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Стоимость не меньше 1 и не больше 100.000.000$");

    peoInfo[playerid][peoPriceInterior] = params[0];
    peoInfo[playerid][peoQuanUpdates] ++;
    showDialogPersonalEditor(playerid, playerid);
    return 1;
}

CMD:nameinterior(playerid, const params[])
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");
    new world = GetPlayerVirtualWorld(playerid);
    new peoId = world-4000;
    if(peoId != playerid) return ErrorMessage(playerid, "{FF6347}Вы находитесь в чужом личном редакторе");
    new inputtext[34];
    if(sscanf(params, "s[34]", inputtext)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Изменить название интерьера в личном редакторе [ /nameinterior Имя ]");
    if(!strlen(inputtext)) return 1;
    if(strlen(inputtext) < 3 || strlen(inputtext) > 34) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Название не меньше 3 и не больше 34 символов");
    if(checksimvol(inputtext)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Хм... я пытаюсь указать в названии какие-то каракули... [ Запрещённый Символ ]");

    format(peoInfo[playerid][peoName],34,"%s", inputtext);
    peoInfo[playerid][peoQuanUpdates] ++;
    showDialogPersonalEditor(playerid, playerid);
    return 1;
}

CMD:sel(playerid, const params[])
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");
    new world = GetPlayerVirtualWorld(playerid);
    new peoId = world-4000;
    if(peoId != playerid) return ErrorMessage(playerid, "{FF6347}Вы находитесь в чужом личном редакторе");
    if(gRedakt[playerid] != 0) return ErrorMessage(playerid, "{FF6347}Вы используете редактор объектов");
    if(peoInfo[playerid][peoStatusLoad]) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения загрузки интерьера");

    if(sscanf(params, "i", params[0]))  return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Выбрать объект для редактирования [ /sel ID ]");
    if(params[0] <= 0 || params[0] >= MAX_OBJECT_INT)
    {
        new string[60];
        format(string,sizeof(string),"{FF6347}ID объекта не меньше 1 и не больше %d", MAX_OBJECT_INT);
        ErrorMessage(playerid, string);
        return 1;
    }
    if(peoInfo[peoId][peoModel][params[0]] == 0) return ErrorMessage(playerid, "{FF6347}Объекта с этим ID не существует");

    new prewSel = peoInfo[peoId][peoSelObject]; // Получаем ID предыдущего выбранного объекта
    peoInfo[peoId][peoSelObject] = params[0]; // Записываем выбранный новый объект
    update3dtextLabel(playerid, params[0]); // Обновляем label нового объекта
    if(peoInfo[peoId][peoModel][prewSel] > 0) update3dtextLabel(playerid, prewSel); // Обновляем label предыдущего объекта

    PlayerPlaySound(playerid,17803,0,0,0);
    return 1;
}

CMD:ox(playerid, const params[])
{
    new Float:input;
    if(sscanf(params, "f", input)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сдвинуть объект по X координате [ /ox Координата ]");
    SetObjectPosPersonalEditor(playerid, peoInfo[playerid][peoSelObject], input, 0);
    return 1;
}

CMD:oy(playerid, const params[])
{
    new Float:input;
    if(sscanf(params, "f", input)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сдвинуть объект по Y координате [ /oy Координата ]");
    SetObjectPosPersonalEditor(playerid, peoInfo[playerid][peoSelObject], input, 1);
    return 1;
}

CMD:oz(playerid, const params[])
{
    new Float:input;
    if(sscanf(params, "f", input)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Сдвинуть объект по Z координате [ /oz Координата ]");
    SetObjectPosPersonalEditor(playerid, peoInfo[playerid][peoSelObject], input, 2);
    return 1;
}

CMD:rx(playerid, const params[])
{
    new Float:input;
    if(sscanf(params, "f", input)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Повернуть объект по RX координате [ /rx Координата ]");
    SetObjectPosPersonalEditor(playerid, peoInfo[playerid][peoSelObject], input, 3);
    return 1;
}

CMD:ry(playerid, const params[])
{
    new Float:input;
    if(sscanf(params, "f", input)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Повернуть объект по RY координате [ /ry Координата ]");
    SetObjectPosPersonalEditor(playerid, peoInfo[playerid][peoSelObject], input, 4);
    return 1;
}

CMD:rz(playerid, const params[])
{
    new Float:input;
    if(sscanf(params, "f", input)) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Повернуть объект по RZ координате [ /rz Координата ]");
    SetObjectPosPersonalEditor(playerid, peoInfo[playerid][peoSelObject], input, 5);
    return 1;
}

CMD:gclone(playerid) return cmd_clone(playerid);
CMD:clone(playerid)
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе [ /loadeditor ]");
    if(peoInfo[playerid][peoSelObject] == 0) return ErrorMessage(playerid, "{FF6347}Выберите объект, чтобы его клонировать [ /sel ]");
    CloneObjectPersonalEditor(playerid, peoInfo[playerid][peoSelObject]);
    return 1;
}

CMD:mtset(playerid, const params[])
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе [ /loadeditor ]");
    if(peoInfo[playerid][peoSelObject] == 0) return ErrorMessage(playerid, "{FF6347}Выберите объект, чтобы изменить текстуру [ /sel ]");
    if(sscanf(params, "ii", params[0], params[1])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Заменить текстуру [ /mtset Слот Текстуры ID Текстуры ]");
    if(params[0] < 0 || params[0] >= MAX_OBJECT_TEXTURES)
    {
        new string[60];
        format(string,sizeof(string),"{FF6347}Слот текстуры не меньше 0 и не больше %d", MAX_OBJECT_TEXTURES - 1);
        ErrorMessage(playerid, string);
        return 1;
    }
    if(params[1] <= 0 || params[1] > 9064) return ErrorMessage(playerid, "{FF6347}ID текстуры не меньше 1 и не больше 9064");
    if(gRedakt[playerid] != 0) return ErrorMessage(playerid, "{FF6347}Вы используете редактор объектов");
    if(peoInfo[playerid][peoStatusLoad]) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения загрузки интерьера");
    new peoId = GetPlayerVirtualWorld(playerid)-4000;
    if(peoId != playerid) return ErrorMessage(playerid, "{FF6347}Вы находитесь в чужом личном редакторе");
    if(peoInfo[peoId][peoModel][0] == 0) return ErrorMessage(playerid, "{FF6347}Выберите планировку для вашего интерьера");
    new getSlotId = peoInfo[playerid][peoSelObject];
    if(peoInfo[peoId][peoModel][getSlotId] == 0) return ErrorMessage(playerid, "{FF6347}Этого объекта не существует");
    if(!IsValidDynamicObject(peoInfo[peoId][peoObject][getSlotId])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");

    SetDynamicObjectMaterial(peoInfo[peoId][peoObject][getSlotId], params[0], ObjectTextures[params[1]][TModel], ObjectTextures[params[1]][TXDName], ObjectTextures[params[1]][TextureName], 0x00000000);
    PlayerPlaySound(playerid,1084,0,0,0);
    return 1;
}

CMD:oprop(playerid, const params[]) return cmd_model(playerid, params);
CMD:model(playerid, const params[])
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе [ /loadeditor ]");
    if(gRedakt[playerid] != 0) return ErrorMessage(playerid, "{FF6347}Вы уже используете редактор объектов");
    if(peoInfo[playerid][peoSelObject] == 0) return ErrorMessage(playerid, "{FF6347}Выберите объект, чтобы заменить его модель [ /sel ]");
    if(sscanf(params, "i", params[0])) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Заменить модель выбранного объекта [ /model ModelID ]");
    if(params[0] > MAX_OBJECT_MODEL_ID || params[0] <= 320)
    {
        new string[60];
        format(string,sizeof(string),"{FF6347}ID Объекта не меньше 321 и не больше %d", MAX_OBJECT_MODEL_ID);
        ErrorMessage(playerid, string);
        return 1;
    }
    if(params[0] >= 400 && params[0] <= 611) return ErrorMessage(playerid, "{FF6347}Эту model объекта нельзя использовать");

    ModelObjectPersonalEditor(playerid, peoInfo[playerid][peoSelObject], params[0]);
    return 1;
}

stock SetObjectPosPersonalEditor(playerid, slotId, Float:pos, posId)
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе [ /loadeditor ]");
    if(gRedakt[playerid] != 0) return ErrorMessage(playerid, "{FF6347}Вы используете редактор объектов");
    if(peoInfo[playerid][peoStatusLoad]) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения загрузки интерьера");
    new world = GetPlayerVirtualWorld(playerid);
    new peoId = world-4000;
    if(peoId != playerid) return ErrorMessage(playerid, "{FF6347}Вы находитесь в чужом личном редакторе");
    if(peoInfo[peoId][peoModel][0] == 0) return ErrorMessage(playerid, "{FF6347}Выберите планировку для вашего интерьера");

    if(slotId <= 0 || slotId >= MAX_OBJECT_INT)
    {
        new string[60];
        format(string,sizeof(string),"{FF6347}ID объекта не меньше 1 и не больше %d", MAX_OBJECT_INT);
        ErrorMessage(playerid, string);
        return 1;
    }
    if(peoInfo[peoId][peoModel][slotId] == 0) return ErrorMessage(playerid, "{FF6347}Объекта с этим ID не существует");

    if(posId >= 3) // Углы наклона
    {
        if(pos < -360.0 || pos > 360.0) return ErrorMessage(playerid, "{FF6347}Не меньше -360.0 и не больше 360.0");
    }
    else // Сдвиг в сторону
    {
        if(pos < -200.0 || pos > 200.0) return ErrorMessage(playerid, "{FF6347}Не меньше -200.0 и не больше 200.0");
        new Float:maxDistFromInterior = GetDistancePoint(1387.4436,-16.2143,1000.8868,peoInfo[playerid][peoX][slotId]+pos,peoInfo[playerid][peoY][slotId]+pos,peoInfo[playerid][peoZ][slotId]+pos);
        if(maxDistFromInterior >= 200.0) return ErrorMessage(playerid, "{FF6347}Нельзя переносить объект дальше чем на 200 метров от точки входа в интерьер");
    }

    if(!IsValidDynamicObject(peoInfo[peoId][peoObject][slotId])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");

    if(posId == 0) peoInfo[playerid][peoX][slotId] += pos; // x
    else if(posId == 1) peoInfo[playerid][peoY][slotId] += pos; // y
    else if(posId == 2) peoInfo[playerid][peoZ][slotId] += pos; // z
    else if(posId == 3) peoInfo[playerid][peoRX][slotId] += pos; // rx
    else if(posId == 4) peoInfo[playerid][peoRY][slotId] += pos; // ry
    else if(posId == 5) peoInfo[playerid][peoRZ][slotId] += pos; // rz

    SetDynamicObjectPos(peoInfo[peoId][peoObject][slotId], peoInfo[playerid][peoX][slotId], peoInfo[playerid][peoY][slotId], peoInfo[playerid][peoZ][slotId]);
    SetDynamicObjectRot(peoInfo[peoId][peoObject][slotId], peoInfo[playerid][peoRX][slotId], peoInfo[playerid][peoRY][slotId], peoInfo[playerid][peoRZ][slotId]);
    peoInfo[playerid][peoQuanUpdates] ++;

    if(peoInfo[playerid][peoObjectLabelStatus]) update3dtextLabelPos(playerid, slotId);
    return 1;
}

stock CreateObjectPersonalEditor(playerid, modelId, world, interior) // Создание объекта в личном редакторе
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе [ /loadeditor ]");
    if(gRedakt[playerid] != 0) return ErrorMessage(playerid, "{FF6347}Вы используете редактор объектов");
    if(peoInfo[playerid][peoStatusLoad]) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения загрузки интерьера");
    new peoId = world-4000;
    if(peoId != playerid) return ErrorMessage(playerid, "{FF6347}Вы находитесь в чужом личном редакторе");
    if(peoInfo[peoId][peoModel][0] == 0) return ErrorMessage(playerid, "{FF6347}Выберите планировку для вашего интерьера");

    new slotId = getFreeObjectSlot(peoId);
    if(slotId == -1)
    {
        new string[60];
        format(string,sizeof(string),"{FF6347}Лимит объектов для интерьеров: %d", MAX_OBJECT_INT-1);
        ErrorMessage(playerid, string);
        return 1;
    }

    // Ищем координату перед игроком
    new Float:f_pos[4];
    frontme(playerid, 4.0, f_pos[0], f_pos[1], f_pos[2], f_pos[3]);
    CreateObjectPeoInterior(playerid, peoId, modelId, slotId, f_pos[0], f_pos[1], f_pos[2], 0.0, 0.0, 0.0, world, interior);

    GoEditDynamicObject(playerid, 20, 0, peoId, slotId, peoInfo[peoId][peoObject][slotId], 0);
    return 1;
}

stock CloneObjectPersonalEditor(playerid, getSlotId) // Клонируем объект
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе [ /loadeditor ]");
    if(gRedakt[playerid] != 0) return ErrorMessage(playerid, "{FF6347}Вы используете редактор объектов");
    if(peoInfo[playerid][peoStatusLoad]) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения загрузки интерьера");
    new peoId = GetPlayerVirtualWorld(playerid)-4000;
    if(peoId != playerid) return ErrorMessage(playerid, "{FF6347}Вы находитесь в чужом личном редакторе");
    if(peoInfo[peoId][peoModel][0] == 0) return ErrorMessage(playerid, "{FF6347}Выберите планировку для вашего интерьера");
    if(peoInfo[peoId][peoModel][getSlotId] == 0) return ErrorMessage(playerid, "{FF6347}Этого объекта не существует");
    if(!IsValidDynamicObject(peoInfo[peoId][peoObject][getSlotId])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");

    new slotId = getFreeObjectSlot(peoId);
    if(slotId == -1)
    {
        new string[60];
        format(string,sizeof(string),"{FF6347}Лимит объектов для интерьеров: %d", MAX_OBJECT_INT-1);
        ErrorMessage(playerid, string);
        return 1;
    }


    CreateObjectPeoInterior(playerid, peoId, peoInfo[peoId][peoModel][getSlotId], slotId, peoInfo[peoId][peoX][slotId], peoInfo[peoId][peoY][slotId], peoInfo[peoId][peoZ][slotId],peoInfo[peoId][peoRX][slotId],peoInfo[peoId][peoRY][slotId],peoInfo[peoId][peoRZ][slotId], GetPlayerVirtualWorld(playerid), 90);

    for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS; i++) // Грузим текстуры
    {
        if(peoTexture[peoId][getSlotId][i] >= 1)
        {
            peoTexture[peoId][slotId][i] = peoTexture[peoId][getSlotId][i];
            new textureId = peoTexture[peoId][slotId][i];
            SetDynamicObjectMaterial(peoInfo[peoId][peoObject][slotId], i, ObjectTextures[textureId][TModel], ObjectTextures[textureId][TXDName], ObjectTextures[textureId][TextureName], 0x00000000);
        }
    }

    peoInfo[peoId][peoSelObject] = slotId; // Записываем выбранный новый объект
    if(peoInfo[playerid][peoObjectLabelStatus]) 
    {
        if(peoInfo[peoId][peoModel][getSlotId] > 0) update3dtextLabel(playerid, getSlotId); // Обновляем label предыдущего объекта
    }

    peoInfo[peoId][peoQuanObjects] ++;
    peoInfo[peoId][peoQuanUpdates] ++;
    PlayerPlaySound(playerid,1084,0,0,0);
    return 1;
}

stock ModelObjectPersonalEditor(playerid, slotId, modelId) // Заменяем модель объекта
{
    if(peoInfo[playerid][peoStatusLoad]) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения загрузки интерьера");
    new peoId = GetPlayerVirtualWorld(playerid)-4000;
    if(peoId != playerid) return ErrorMessage(playerid, "{FF6347}Вы находитесь в чужом личном редакторе");
    if(peoInfo[peoId][peoModel][0] == 0) return ErrorMessage(playerid, "{FF6347}Выберите планировку для вашего интерьера");
    if(peoInfo[peoId][peoModel][slotId] == 0) return ErrorMessage(playerid, "{FF6347}Этого объекта не существует");
    if(!IsValidDynamicObject(peoInfo[peoId][peoObject][slotId])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");

    DestroyDynamicObject(peoInfo[peoId][peoObject][slotId]);

    peoInfo[peoId][peoModel][slotId] = modelId;
    peoInfo[peoId][peoObject][slotId] = CreateDynamicObject(peoInfo[peoId][peoModel][slotId],peoInfo[peoId][peoX][slotId], peoInfo[peoId][peoY][slotId], peoInfo[peoId][peoZ][slotId],peoInfo[peoId][peoRX][slotId],peoInfo[peoId][peoRY][slotId],peoInfo[peoId][peoRZ][slotId], GetPlayerVirtualWorld(playerid), 90, -1, 100.00, 100.00);
    
    for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS; i++) // Грузим текстуры
    {
        if(peoTexture[peoId][slotId][i] >= 1)
        {
            new textureId = peoTexture[peoId][slotId][i];
            SetDynamicObjectMaterial(peoInfo[peoId][peoObject][slotId], i, ObjectTextures[textureId][TModel], ObjectTextures[textureId][TXDName], ObjectTextures[textureId][TextureName], 0x00000000);
        }
    }
    if(peoInfo[playerid][peoObjectLabelStatus]) update3dtextLabel(playerid, slotId); // Обновляем label

    peoInfo[peoId][peoQuanUpdates] ++;
    PlayerPlaySound(playerid,1084,0,0,0);

    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
    return 1;
}

stock EditObjectPersonalEditor(playerid, slotId, world) // Перемещение объекта в личном редакторе
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе [ /loadeditor ]");
    if(peoInfo[playerid][peoStatusLoad]) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения загрузки интерьера");
    new peoId = world-4000;
    if(peoId != playerid) return ErrorMessage(playerid, "{FF6347}Вы находитесь в чужом личном редакторе");

    if(slotId <= 0 || slotId >= MAX_OBJECT_INT)
    {
        new string[60];
        format(string,sizeof(string),"{FF6347}ID объекта не меньше 1 и не больше %d", MAX_OBJECT_INT);
        ErrorMessage(playerid, string);
        return 1;
    }
    if(peoInfo[peoId][peoModel][slotId] == 0) return ErrorMessage(playerid, "{FF6347}Объекта с этим ID не существует");

    if(!IsValidDynamicObject(peoInfo[peoId][peoObject][slotId])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");
    new Float:dobject_pos[3];
    GetDynamicObjectPos(peoInfo[peoId][peoObject][slotId], dobject_pos[0], dobject_pos[1], dobject_pos[2]);
    if(!IsPlayerInRangeOfPoint(playerid, 100.0, dobject_pos[0], dobject_pos[1], dobject_pos[2])) return ErrorMessage(playerid, "{FF6347}Вы слишком далеко от объекта [ Не дальше 100 метров ]");

    GoEditDynamicObject(playerid, 21, 1, peoId, slotId, peoInfo[peoId][peoObject][slotId], 0);
    return 1;
}

stock DeleteObjectPersonalEditor(playerid, slotId, world) // Перемещение объекта в личном редакторе
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе [ /loadeditor ]");
    if(peoInfo[playerid][peoStatusLoad]) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения загрузки интерьера");
    new peoId = world-4000;
    if(peoId != playerid) return ErrorMessage(playerid, "{FF6347}Вы находитесь в чужом личном редакторе");
    if(slotId <= 0 || slotId >= MAX_OBJECT_INT)
    {
        new string[60];
        format(string,sizeof(string),"{FF6347}ID объекта не меньше 1 и не больше %d", MAX_OBJECT_INT);
        ErrorMessage(playerid, string);
        return 1;
    }
    if(peoInfo[peoId][peoModel][slotId] == 0) return ErrorMessage(playerid, "{FF6347}Объекта с этим ID не существует");
    if(!IsValidDynamicObject(peoInfo[peoId][peoObject][slotId])) return ErrorMessage(playerid, "{FF6347}DynamicObject под таким ID не существует");

    DestroyDynamicObject(peoInfo[peoId][peoObject][slotId]);
    peoInfo[peoId][peoModel][slotId] = 0;

    for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS; i++) peoTexture[playerid][slotId][i] = 0; // Очищаем текстуры

    if(peoInfo[playerid][peoObjectLabelStatus]) DestroyDynamic3DTextLabel(peoInfo[playerid][peoObjectLabel][slotId]);

    peoInfo[playerid][peoQuanUpdates] ++;

    PlayerPlaySound(playerid,6801,0,0,0);
    return 1;
}

stock getFreeObjectSlot(peoId) // Получаем свободный слот для создания объекта
{
    new objid = -1;
    for(new i = 0; i < MAX_OBJECT_INT; i++)
    {
        if(peoInfo[peoId][peoModel][i] == 0)
        {
            objid = i;
            break;
        }
    }
    return objid;
}

forward Call_checkname_loadinterior(playerid, race_check, str_name[]); // Ищем ID аккаунта, если игрок Offline
public Call_checkname_loadinterior(playerid, race_check, str_name[])
{
    new rows;
    cache_get_row_count(rows);
    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);
    if(!rows) return ErrorMessage(playerid, "{FF6347}Аккаунт не найден");

    new userId;
    cache_get_value_name_int(0, "user_id", userId);

    goloadInterior(playerid, userId, str_name);
    return 1;
}

stock goloadInterior(playerid, userId, str_name[]) // Начинаем загрузку интерьера
{
    if(peoInfo[playerid][peoStatusLoad]) return ErrorMessage(playerid, "{FF6347}Ошибка! Вы уже загружаете интерьер\nДождитесь завершения загрузки");

    new playerIdFind = -1;
    foreach(Player,i)
    {
        if(!peoInfo[i][peoLoaded]) continue;
        if(peoInfo[i][peoCreatorId] == userId)
        {
            playerIdFind = i;
            break;
        }
    }

    new string[180];
    if(playerIdFind >= 0) return format(string,sizeof(string),"{FF6347}Интерьер %s уже загружен или загружается на аккаунт %s[%d]", str_name, PlayerInfo[playerIdFind][pName], playerIdFind), ErrorMessage(playerid, string);

    DP[0][playerid] = 1; // Загрузка интерьера
    DialogLoadInterior(playerid);

    peoInfo[playerid][peoStatusLoad] = true;
    peoInfo[playerid][peoCreatorId] = userId;

    format(string,sizeof(string),"SELECT * FROM `pp_peo_information` WHERE `user_id` = '%d'", userId);
	mysql_tquery(pearsq, string, "Call_loadinterior_information", "ddds", playerid, g_MysqlRaceCheck[playerid], userId, str_name);
    return 1;
}

forward Call_loadinterior_information(playerid, race_check, userId, str_name[]);
public Call_loadinterior_information(playerid, race_check, userId, str_name[]) // Грузим инфу о загружаемом интерьере и передаём информацию в базу, что мы начинаем его грузить
{
    new rows;
	cache_get_row_count(rows);
    if(!rows) return ErrorMessage(playerid, "{FF6347}Интерьера не существует"), peoInfo[playerid][peoStatusLoad] = false, peoInfo[playerid][peoCreatorId] = 0;
    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);

    cache_get_value_name_int(0, "newid", peoInfo[playerid][peoNewid]); // ID Интерьера в личном редакторе
    cache_get_value_name(0, "peoName", peoInfo[playerid][peoName], 34);
    cache_get_value_name_int(0, "peoPriceInterior", peoInfo[playerid][peoPriceInterior]); // Получаем прайс интерьера, который устанавливает создатель
    cache_get_value_name_int(0, "peoPublicationStatus", peoInfo[playerid][peoPublicationStatus]); // Получаем статус публикации
    peoInfo[playerid][peoCreatorId] = userId;
    format(peoInfo[playerid][peoCreatorName],24,"%s", str_name);

    // После загрузки информации о интерьере, начинаем грузить его объекты
    new string_mysql[100];
    format(string_mysql,sizeof(string_mysql),"SELECT * FROM `pp_peo_objects` WHERE `user_id` = '%d'", userId);
	mysql_tquery(pearsq, string_mysql, "Call_loadinterior_object", "ddds", playerid, g_MysqlRaceCheck[playerid], userId, str_name);
    return 1;
}

forward Call_loadinterior_object(playerid, race_check, userId, str_name[]);
public Call_loadinterior_object(playerid, race_check, userId, str_name[]) // Грузим объекты интерьера для дома
{
	new rows;
	cache_get_row_count(rows);
    if(!rows) return ErrorMessage(playerid, "{FF6347}В интерьере нет объектов"), peoInfo[playerid][peoStatusLoad] = false, peoInfo[playerid][peoCreatorId] = 0;
    if(g_MysqlRaceCheck[playerid] != race_check) return Kickx(playerid);
    
    new slotId, string[6];
	for(new f; f < rows; ++f) // Цикл для всех найденных объектов игрока
	{
        cache_get_value_name_int(f, "slotId", slotId);
    	cache_get_value_name_int(f, "peoModel", peoInfo[playerid][peoModel][slotId]);
		cache_get_value_name_float(f, "peoX", peoInfo[playerid][peoX][slotId]);
		cache_get_value_name_float(f, "peoY", peoInfo[playerid][peoY][slotId]);
		cache_get_value_name_float(f, "peoZ", peoInfo[playerid][peoZ][slotId]);
		cache_get_value_name_float(f, "peoRX", peoInfo[playerid][peoRX][slotId]);
		cache_get_value_name_float(f, "peoRY", peoInfo[playerid][peoRY][slotId]);
		cache_get_value_name_float(f, "peoRZ", peoInfo[playerid][peoRZ][slotId]);

        if(peoInfo[playerid][peoModel][slotId] >= 1) // Создали объект
        {
            peoInfo[playerid][peoObject][slotId] = CreateDynamicObject(peoInfo[playerid][peoModel][slotId], peoInfo[playerid][peoX][slotId], peoInfo[playerid][peoY][slotId], peoInfo[playerid][peoZ][slotId], peoInfo[playerid][peoRX][slotId], peoInfo[playerid][peoRY][slotId], peoInfo[playerid][peoRZ][slotId], playerid+4000, 90, -1, 100.00, 100.00);
            peoInfo[playerid][peoQuanObjects] ++;
        }

        for(new i = 0; i < MAX_TEXTURES_ON_OBJECTS; i++) // Грузим текстуры
        {
            format(string, sizeof(string), "txt%d", i);
			cache_get_value_name_int(f, string, peoTexture[playerid][slotId][i]);

            if(peoTexture[playerid][slotId][i] >= 1)
			{
				new textureId = peoTexture[playerid][slotId][i];
				SetDynamicObjectMaterial(peoInfo[playerid][peoObject][slotId], i, ObjectTextures[textureId][TModel], ObjectTextures[textureId][TXDName], ObjectTextures[textureId][TextureName], 0x00000000);
			}
        }
    }
    peoInfo[playerid][peoLoaded] = true;
    peoInfo[playerid][peoStatusLoad] = false;
    return 1;
}

CMD:loadinterior(playerid, const params[]) // Загружаем интерьер
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");
    if(peoInfo[playerid][peoLoaded]) return ErrorMessage(playerid, "{FF6347}На ваш аккаунт уже загружен интерьер");

    if(PlayerInfo[playerid][pSoska] >= 1)
    {
        new playerName[24], string[46 + 24];
        if(!sscanf(params, "s[24]",playerName))
	    {
            new giveplayerid = ReturnUser(playerName, 1);
     	    if(IsPlayerConnected(giveplayerid)) goloadInterior(playerid, PlayerInfo[giveplayerid][pID], PlayerInfo[giveplayerid][pName]); // Игрок Online
            else // Игрок Offline
            {
                if(!CheckRP_Nickname(playerName)) return ErrorMessage(playerid, "{FF6347}Вы не правильно указали никнейм\nЕсли вы указали ID, значит игрок Offline");
                DP[0][playerid] = 0; // Поиск игрока
                DialogLoadInterior(playerid);
                format(string,sizeof(string),"SELECT user_id FROM `pp_igroki` WHERE `Name` = '%s'", playerName);
                mysql_tquery(pearsq, string, "Call_checkname_loadinterior", "dds", playerid, g_MysqlRaceCheck[playerid], playerName);
            }
            return 1;
        }
    }

    // Если не админ и ничего не вводили, то просто грузим обственный интерьер
    goloadInterior(playerid, PlayerInfo[playerid][pID], PlayerInfo[playerid][pName]);
    return 1;
}

CMD:unloadinterior(playerid, const params[]) // Выгружаем интерьер
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");
    if(peoInfo[playerid][peoStatusLoad]) return ErrorMessage(playerid, "{FF6347}Дождитесь завершения загрузки интерьера");
    if(gRedakt[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Завершите редактирование объекта");
    if(OnlineInfo[playerid][oShowInterface] == 14) return ErrorMessage(playerid, "{FF6347}Покиньте меню выбора планировки");

    DestroyPeoInterior(playerid);
    ClearPeoInfo(playerid);
    return 1;
}

stock ClearPeoInfo(playerid) // Удаляем информацию о личном редакторе
{
    peoInfo[playerid][peoNewid] = 0;
    peoInfo[playerid][peoLoaded] = false;
    peoInfo[playerid][peoQuanUpdates] = 0;
    peoInfo[playerid][peoQuanObjects] = 0;
    peoInfo[playerid][peoCreatorId] = 0;
    peoInfo[playerid][peoStatusLoad] = false;
    peoInfo[playerid][peoPriceInterior] = 0;
    peoInfo[playerid][peoPublicationStatus] = 0;
    peoInfo[playerid][peoObjectLabelStatus] = false;
    return 1;
}

stock DestroyPeoInterior(playerid) // Удаляем загруженный интерьер (все объекты)
{
    for(new i = 0; i < MAX_OBJECT_INT; i++)
    {
        if(peoInfo[playerid][peoModel][i] > 0) 
        {
            if(IsValidDynamicObject(peoInfo[playerid][peoObject][i])) 
            {
                if(i > 0) DestroyDynamic3DTextLabel(peoInfo[playerid][peoObjectLabel][i]);
                DestroyDynamicObject(peoInfo[playerid][peoObject][i]);
                peoInfo[playerid][peoObject][i] = 0;
            }
            peoInfo[playerid][peoModel][i] = 0;
            for(new t = 0; t < MAX_TEXTURES_ON_OBJECTS; t++) peoTexture[playerid][i][t] = 0;
        }
    }
    return 1;
}

CMD:loadeditor(playerid) // Входим в личный редактор
{
    if(server != 0) return ErrorMessage(playerid, "{FF6347}Доступно только на тестовом сервере");
    if(PlayerInfo[playerid][pSoska] <= 0)
    {
	    // if(!IsPlayerInRangeOfPoint(playerid, 2.0, 228.0, 228.0, 228.0)) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в шоуруме");
        if(PursuitTime[playerid] >= 1) return ErrorMessage(playerid, "{FF6347}Вас преследует полиция");
        if(howstun(playerid) || HealthAC[playerid] <= 0) return ErrorMessage(playerid, "{FF6347}Вашему персонажу плохо");
    }
    if(peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы уже в редакторе");

    if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return ErrorMessage(playerid, "{FF6347}Вы находитесь в наблюдении");
    if(setting_pos_draw[playerid] > 0 || setting_size_draw[playerid] > 0) return ErrorMessage(playerid, "{FF6347}Завершите редактирование текстдравов");

    if(OnlineInfo[playerid][oShowInterface] == 1) CloseFrisk(playerid), CancelSelectTextDraw(playerid); // Закрываем инвентарь
    else if(OnlineInfo[playerid][oShowInterface] == 2) CloseSmartfon(playerid), CancelSelectTextDraw(playerid); // Закрываем смартфон

    // Записываем текущие координаты и инты, чтобы при выходе из редактора вернуть игрока обратно
    GetPlayerPos(playerid, SpX[playerid], SpY[playerid], SpZ[playerid]);
    GetPlayerFacingAngle(playerid, SpA[playerid]);
    SpInt[playerid] = GetPlayerInterior(playerid);
    SpWorld[playerid] = GetPlayerVirtualWorld(playerid);

    S_SetPlayerVirtualWorld(playerid,playerid+4000,90); // Вирт миры 4000 - 4999 (Миры для личного редактора)
	PPSetPlayerInterior(playerid,90); // Инт 90 (поскольку там располагаются все кастомные интерьеры)
    PPSetPlayerPos(playerid,1387.4436,-16.2143,1000.8868); // Позиция входа в дом и бизнес (Они всегда в одной и той-же точке)
    PPSetPlayerFacingAngle(playerid, 0.0); // Угол поворота игрока
    SetCameraBehindPlayer(playerid); // Сбрасываем камеру

    peoInfo[playerid][peoInEditor] = true; // Мы в редакторе

    // Врубаем 3d label по дефолту
    peoInfo[playerid][peoObjectLabelStatus] = true;
    show3dtextLabels(playerid);

    SendClientMessage(playerid, COLOR_GREY, "{A86CFB}[ Editor ]: {cccccc}Команда для управления редактором {A86CFB}/editor");
	return 1;
}

CMD:exiteditor(playerid) // Выходим из личного редактора
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");

    keep(playerid);
    S_SetPlayerVirtualWorld(playerid,SpWorld[playerid],SpInt[playerid]);
	PPSetPlayerInterior(playerid,SpInt[playerid]);
    PPSetPlayerPos(playerid,SpX[playerid], SpY[playerid], SpZ[playerid]);
    PPSetPlayerFacingAngle(playerid, SpA[playerid]);
    SetCameraBehindPlayer(playerid);

    peoInfo[playerid][peoInEditor] = false; // Статус редактора Off
	return 1;
}

CMD:label3d(playerid)
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");

    if(!peoInfo[playerid][peoObjectLabelStatus])
    {
        peoInfo[playerid][peoObjectLabelStatus] = true;
        show3dtextLabels(playerid);
    }
    else
    {
        peoInfo[playerid][peoObjectLabelStatus] = false;
        hide3dtextLabels(playerid);
    }
    showDialogPersonalEditor(playerid, playerid);
    return 1;
}

stock create3dtextLabel(playerid, slotId) // Создаём 3d text
{
    peoInfo[playerid][peoObjectLabel][slotId] = CreateDynamic3DTextLabel("_",0xA9C4E4FF,peoInfo[playerid][peoX][slotId], peoInfo[playerid][peoY][slotId], peoInfo[playerid][peoZ][slotId],100.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,playerid+4000,90, playerid);
    update3dtextLabel(playerid, slotId);
    return 1;
}

stock update3dtextLabel(playerid, slotId) // Обновляем название 3d text
{
    new string[80];
    if(peoInfo[playerid][peoSelObject] == slotId) format(string,sizeof(string),"{cccccc}ID: {A86CFB}%d {cccccc}| Model: {A86CFB}%d", slotId, peoInfo[playerid][peoModel][slotId]);
    else format(string,sizeof(string),"{cccccc}ID: {555555}%d {cccccc}| Model: {555555}%d", slotId, peoInfo[playerid][peoModel][slotId]);
	UpdateDynamic3DTextLabelText(peoInfo[playerid][peoObjectLabel][slotId],0xA9C4E4FF,string);
	Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
    return 1;
}

stock update3dtextLabelPos(playerid, slotId) // Обновляем позицию 3d text
{
    DestroyDynamic3DTextLabel(peoInfo[playerid][peoObjectLabel][slotId]);
    create3dtextLabel(playerid, slotId);
    return 1;
}

stock show3dtextLabels(playerid) // Показываем все 3d text
{
    for(new i = 1; i < MAX_OBJECT_INT; i++)
    {
        if(peoInfo[playerid][peoModel][i] > 0) 
        {
            if(IsValidDynamicObject(peoInfo[playerid][peoObject][i])) create3dtextLabel(playerid, i);
        }
    }
    return 1;
}

stock hide3dtextLabels(playerid) // Убираем все 3d text
{
    for(new i = 1; i < MAX_OBJECT_INT; i++)
    {
        if(peoInfo[playerid][peoModel][i] > 0) 
        {
            if(IsValidDynamicObject(peoInfo[playerid][peoObject][i])) DestroyDynamic3DTextLabel(peoInfo[playerid][peoObjectLabel][i]);
        }
    }
    return 1;
}

stock DialogLoadInterior(playerid)
{
	if(DP[0][playerid] == 0) ShowDialog(playerid,1293,DIALOG_STYLE_MSGBOX,"{ff9000}Pears Project","{ff9000}Поиск аккаунта..","*","");
	else if(DP[0][playerid] == 1) ShowDialog(playerid,1293,DIALOG_STYLE_MSGBOX,"{ff9000}Pears Project","{ff9000}Загрузка интерьера..","*","");
	return 1;
}

CMD:loadmap(playerid)
{
    if(!peoInfo[playerid][peoInEditor]) return ErrorMessage(playerid, "{FF6347}Вы не находитесь в редакторе");
    if(PlayerInfo[playerid][pSoska] < 22) return ErrorMessage(playerid, "{FF6347}Вы не можете использовать эту команду [ Admin 22+ ]");

    ErrorMessage(playerid, "{FF6347}Функция временно недоступна");
    //peoLoadMap(playerid);
    return 1;
}

/*static DBStatement:loadstmt;

enum OBJECTINFO
{
	oID,                                        // Object id
#if defined COMPILE_MANGLE
	oCAID,                                      // ColAndreas index
#endif
	oGroup,                                     // Object group
	oModel,                                     // Object Model
	Text3D:oTextID,                             // Object 3d text label
    oNote[64],                                  // Object note
	Float:oPositionX,                                   // Position Z
	Float:oPositionY,                                   // Position Z
	Float:oPositionZ,                                   // Position Z
	Float:oPositionRX,                                  // Rotation Z
	Float:oPositionRY,                                  // Rotation Z
	Float:oPositionRZ,                                  // Rotation Z
	oTexIndex[MAX_MATERIALS],                   // Texture index ref
	oColorIndex[MAX_MATERIALS],                 // Material List
	ousetext,              						// Use text
	oFontFace,    								// Font face reference
	oFontSize,    								// Font size reference
	oFontBold,    								// Font bold
	oFontColor,   								// Font color
	oBackColor,   								// Font back color
	oAlignment,   								// Font alignment
	oTextFontSize, 							 	// Font text size
	oObjectText[MAX_TEXT_LENGTH],              	// Font text
	oAttachedVehicle,                           // Vehicle object is attached to
    Float:oDD                                   // Draw distance
}

stock const FontSizes[] = {
	OBJECT_MATERIAL_SIZE_32x32,
	OBJECT_MATERIAL_SIZE_64x32,
	OBJECT_MATERIAL_SIZE_64x64,
	OBJECT_MATERIAL_SIZE_128x32,
	OBJECT_MATERIAL_SIZE_128x64,
	OBJECT_MATERIAL_SIZE_128x128,
	OBJECT_MATERIAL_SIZE_256x32,
	OBJECT_MATERIAL_SIZE_256x64,
	OBJECT_MATERIAL_SIZE_256x128,
	OBJECT_MATERIAL_SIZE_256x256,
	OBJECT_MATERIAL_SIZE_512x64,
	OBJECT_MATERIAL_SIZE_512x128,
	OBJECT_MATERIAL_SIZE_512x256,
	OBJECT_MATERIAL_SIZE_512x512
};
stock const FontNames[][] = {
	"Arial",
	"Courier New",
	"Webdings",
	"Wingdings",
	"GTAWEAPON3",
	"Calibri",
	"Engravers MT",
	"Quartz MS",
	"Segoe Keycaps",
	"Fixedsys",
    "Wingdings 2",
    "Wingdings 3",
    "Comic Sans MS",
    "Georgia",
    "Impact",
    "Lucida Console",
    "Lucida Sans Unicode",
    "Palatino Linotype",
    "Tahoma",
    "Times New Roman",
    "Trebuchet MS",
    "Verdana",
    "Symbol",
    "Monotype Corsiva",
    "Mistral",
    "Garamond",
    "Franklin Gothic Medium",
    "Century Gothic",
    "Arial Narrow",
    "Segoe UI",
    "Segoe Script",
    "Palatino Linotype",
    "Arial Black"
};

new DB:EditMap;*/

/*stock peoLoadMap(playerid)
{
    EditMap = db_open_persistent("map_interior.db");
    sqlite_LoadMapObjects(playerid);
	return 1;
}

stock sqlite_LoadMapObjects(playerid)
{
	new tmpobject[OBJECTINFO];
	new i;
	loadstmt = db_prepare(EditMap, "SELECT * FROM `Objects`");

	// Bind our results
    stmt_bind_result_field(loadstmt, 0, DB::TYPE_INT, i);
    stmt_bind_result_field(loadstmt, 1, DB::TYPE_INT, tmpobject[oModel]);
    stmt_bind_result_field(loadstmt, 2, DB::TYPE_FLOAT, tmpobject[oPositionX]);
    stmt_bind_result_field(loadstmt, 3, DB::TYPE_FLOAT, tmpobject[oPositionY]);
    stmt_bind_result_field(loadstmt, 4, DB::TYPE_FLOAT, tmpobject[oPositionZ]);
    stmt_bind_result_field(loadstmt, 5, DB::TYPE_FLOAT, tmpobject[oPositionRX]);
    stmt_bind_result_field(loadstmt, 6, DB::TYPE_FLOAT, tmpobject[oPositionRY]);
    stmt_bind_result_field(loadstmt, 7, DB::TYPE_FLOAT, tmpobject[oPositionRZ]);
    stmt_bind_result_field(loadstmt, 8, DB::TYPE_ARRAY, tmpobject[oTexIndex], MAX_MATERIALS);
    stmt_bind_result_field(loadstmt, 9, DB::TYPE_ARRAY, tmpobject[oColorIndex], MAX_MATERIALS);
    stmt_bind_result_field(loadstmt, 10, DB::TYPE_INT, tmpobject[ousetext]);
    stmt_bind_result_field(loadstmt, 11, DB::TYPE_INT, tmpobject[oFontFace]);
    stmt_bind_result_field(loadstmt, 12, DB::TYPE_INT, tmpobject[oFontSize]);
    stmt_bind_result_field(loadstmt, 13, DB::TYPE_INT, tmpobject[oFontBold]);
    stmt_bind_result_field(loadstmt, 14, DB::TYPE_INT, tmpobject[oFontColor]);
    stmt_bind_result_field(loadstmt, 15, DB::TYPE_INT, tmpobject[oBackColor]);
    stmt_bind_result_field(loadstmt, 16, DB::TYPE_INT, tmpobject[oAlignment]);
    stmt_bind_result_field(loadstmt, 17, DB::TYPE_INT, tmpobject[oTextFontSize]);
    stmt_bind_result_field(loadstmt, 18, DB::TYPE_STRING, tmpobject[oObjectText], MAX_TEXT_LENGTH);
    stmt_bind_result_field(loadstmt, 19, DB::TYPE_INT, tmpobject[oGroup]);
    stmt_bind_result_field(loadstmt, 20, DB::TYPE_STRING, tmpobject[oNote], 64);
    stmt_bind_result_field(loadstmt, 21, DB::TYPE_FLOAT, tmpobject[oDD]);

    new bool:stopLoad;
	// Execute query
    new count;
    if(stmt_execute(loadstmt))
    {
        if(stopLoad == false)
        {
            // Удаляем все объекты, которые были созданы
            for(new ob = 0; ob < MAX_OBJECT_INT; ob++)
            {
                if(peoInfo[playerid][peoModel][ob] > 0) 
                {
                    if(IsValidDynamicObject(peoInfo[playerid][peoObject][ob])) 
                    {
                        DestroyDynamicObject(peoInfo[playerid][peoObject][ob]);
                        peoInfo[playerid][peoObject][ob] = 0;
                        peoInfo[playerid][peoModel][ob] = 0;
                    }
                }
            }

            while(stmt_fetch_row(loadstmt))
            {
                if(i < MAX_OBJECT_INT)
                {
                    peoInfo[playerid][peoModel][i] = tmpobject[oModel];
                    peoInfo[playerid][peoX][i] = tmpobject[oPositionX];
                    peoInfo[playerid][peoY][i] = tmpobject[oPositionY];
                    peoInfo[playerid][peoZ][i] = tmpobject[oPositionZ];
                    peoInfo[playerid][peoRX][i] = tmpobject[oPositionRX];
                    peoInfo[playerid][peoRY][i] = tmpobject[oPositionRY];
                    peoInfo[playerid][peoRZ][i] = tmpobject[oPositionRZ];
                    peoInfo[playerid][peoObject][i] = CreateDynamicObject(peoInfo[playerid][peoModel][i], peoInfo[playerid][peoX][i], peoInfo[playerid][peoY][i], peoInfo[playerid][peoZ][i], peoInfo[playerid][peoRX][i], peoInfo[playerid][peoRY][i], peoInfo[playerid][peoRZ][i], playerid+4000, 90, -1, 100.00, 100.00);
                    peoInfo[playerid][peoQuanObjects] ++;

                    // текст на объекте
                    if(tmpobject[ousetext])
                    {
                        new string[90];
                        format(string,sizeof(string),"%s", tmpobject[oObjectText]);
                        SetDynamicObjectMaterialText(peoInfo[playerid][peoObject][i], 0, string, FontSizes[tmpobject[oFontSize]], FontNames[tmpobject[oFontFace]], tmpobject[oTextFontSize], tmpobject[oFontBold], tmpobject[oFontColor], tmpobject[oBackColor], tmpobject[oAlignment]);
                    }

                    // загрузка текстур
                    for(new m = 0; m < MAX_MATERIALS; m++)
                    {
                        if(tmpobject[oTexIndex][m] > 0) // Натягиваем текстуру
                        {
                            SetDynamicObjectMaterial(peoInfo[playerid][peoObject][i], m, ObjectTextures[tmpobject[oTexIndex][m]][TModel], ObjectTextures[tmpobject[oTexIndex][m]][TXDName], ObjectTextures[tmpobject[oTexIndex][m]][TextureName], tmpobject[oColorIndex][m]);
                        }
                    }
                    count++;
                }
            }
        }
		stmt_close(loadstmt);
        return count;
    }
	stmt_close(loadstmt);

    if(stopLoad == false)
    {
        new string[90];
        format(string,sizeof(string),"{444444}Маппинг с интерьером загружен {A86CFB}[Объектов: %d]", count);
        SuccessMessage(playerid, string);
    }
    return 0;
}*/

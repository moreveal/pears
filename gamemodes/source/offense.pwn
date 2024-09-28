/*
    Система пресечения оскорблений

    Игрок обращается к администрации с помощью [ /report ]
    После этого, сообщения игрока, на которого была направлена жалоба, запоминаются до тех пор, пока их не рассмотрит администратор

    Лог сообщений с одобренных заявок летит в лог оскорблений (целиком, для того, чтобы администраторы не могли вырезать фразы из контекста)
*/

#define MAX_OFFENSE_REQUESTS    50 // Максимальное количество активных заявок на оскорбления
#define MAX_OFFENSE_OUTGOING_MESSAGES MAX_OUTGOING_MESSAGES

// На случай реализации необязательного аргумента у OutgoingMessages_Iterate, для обхода по последним N элементам, а не всем
/* #define MAX_OFFENSE_OUTGOING_MESSAGES 20

#if MAX_OFFENSE_OUTGOING_MESSAGES > MAX_OUTGOING_MESSAGES
     #error "MAX_OUTGOING_MESSAGES should be higher than MAX_OFFENSE_OUTGOING_MESSAGES"
#endif
*/

enum e_Offense {
    oncPID, // ID аккаунта игрока, сообщившего о нарушении
    oncPlayerName[MAX_PLAYER_NAME + 1], // Никнейм игрока
    oncIntruderPID, // ID аккаунта нарушителя
    oncIntruderName[MAX_PLAYER_NAME + 1], // Никнейм нарушителя

    // Дата
    oncUnix,
    oncHours, oncMinutes, oncSeconds,
    oncYear, oncMonth, oncDay
};

new OffenseInfo[MAX_OFFENSE_REQUESTS][e_Offense];
new OffenseMessages[MAX_OFFENSE_REQUESTS][MAX_OFFENSE_OUTGOING_MESSAGES][MAX_OUTGOING_MESSAGE_SIZE];

function Offense_Load()
{
    new rows;
    cache_get_row_count(rows);

    for (new i = 0; i < min(rows, MAX_OFFENSE_REQUESTS); i++)
    {
        new id;
        cache_get_value_name_int(i, "id", id);
        cache_get_value_name_int(i, "user_id", OffenseInfo[id][oncPID]);
        cache_get_value_name(i, "name", OffenseInfo[id][oncPlayerName]);
        cache_get_value_name_int(i, "intruder_user_id", OffenseInfo[id][oncIntruderPID]);
        cache_get_value_name(i, "intruder_name", OffenseInfo[id][oncIntruderName]);

        new date_json[512], messages_json[4096];
        cache_get_value_name(i, "date", date_json);
        cache_get_value_name(i, "messages", messages_json);
        if (!isnull(date_json))
        {
            new JsonNode:node = JSON_INVALID_NODE;
            if (JSON_Parse(date_json, node) == JSON_CALL_NO_ERR)
            {
                JSON_GetInt(node, "unix", OffenseInfo[id][oncUnix]);

                JSON_GetInt(node, "hours", OffenseInfo[id][oncHours]);
                JSON_GetInt(node, "minutes", OffenseInfo[id][oncMinutes]);
                JSON_GetInt(node, "seconds", OffenseInfo[id][oncSeconds]);

                JSON_GetInt(node, "year", OffenseInfo[id][oncYear]);
                JSON_GetInt(node, "month", OffenseInfo[id][oncMonth]);
                JSON_GetInt(node, "day", OffenseInfo[id][oncDay]);
            }
        }
        if (!isnull(messages_json))
        {
            new JsonNode:node = JSON_INVALID_NODE;
            if (JSON_Parse(messages_json, node) == JSON_CALL_NO_ERR)
            {
                new index = -1, JsonNode: currentMessage;
                while (!JSON_ArrayIterate(node, index, currentMessage))
                {
                    if (index >= MAX_OFFENSE_OUTGOING_MESSAGES) break;

                    OffenseMessages[id][index][0] = EOS;
                    JSON_GetNodeString(currentMessage, OffenseMessages[id][index], MAX_OUTGOING_MESSAGE_SIZE);
                }
            }
        }
    }

    return 1;
}

stock CreateJSONOffenseDate(id, &JsonNode: node) {
    if (!Offense_IsExists(id)) {
        node = JSON_INVALID_NODE;
        return 0;
    }

    node = JSON_Object(
        "unix", JSON_Int(OffenseInfo[id][oncUnix]),

        "hours", JSON_Int(OffenseInfo[id][oncHours]),
        "minutes", JSON_Int(OffenseInfo[id][oncMinutes]),
        "seconds", JSON_Int(OffenseInfo[id][oncSeconds]),
        
        "year", JSON_Int(OffenseInfo[id][oncYear]),
        "month", JSON_Int(OffenseInfo[id][oncMonth]),
        "day", JSON_Int(OffenseInfo[id][oncDay])
    );

    return 1;
}

stock CreateJSONOffenseMessages(id, &JsonNode: node)
{
    if (!Offense_IsExists(id)) {
        node = JSON_INVALID_NODE;
        return 0;
    }

    node = JSON_Array();

    for (new i = 0; i < MAX_OFFENSE_OUTGOING_MESSAGES; i++)
    {
        if (isnull(OffenseMessages[id][i])) continue;
        JSON_ArrayAppendEx(node, JSON_String(OffenseMessages[id][i]));
    }
    
    return 1;
}

stock Offense_Save(id = -1) {
    new query_string[1024];

    new minid = (id > -1 ? 0 : id),
        maxid = (id > -1 ? id + 1 : MAX_OFFENSE_REQUESTS);

    for (new i = minid; i < maxid; i++) {
        if (Offense_IsExists(i)) {
            new JsonNode: dateNode, JsonNode: messagesNode;
            CreateJSONOffenseDate(i, dateNode);
            CreateJSONOffenseMessages(i, messagesNode);

            new date_json[512], messages_json[4096];
            if (JSON_Stringify(dateNode, date_json) == JSON_CALL_NO_ERR && JSON_Stringify(messagesNode, messages_json) == JSON_CALL_NO_ERR)
            {
                mysql_format(pearsq, query_string, sizeof(query_string),
                    "REPLACE INTO `offense` (`id`, `user_id`, `name`, `intruder_user_id`, `intruder_name`, `date`, `messages`) \
                    VALUES (%d, %d, '%e', %d, '%e', '%e', '%e')",
                    
                    i,
                    OffenseInfo[i][oncPID], OffenseInfo[i][oncPlayerName],
                    OffenseInfo[i][oncIntruderPID], OffenseInfo[i][oncIntruderName],
                    date_json, messages_json
                );
            }
        } else {
            mysql_format(pearsq, query_string, sizeof(query_string),
                "DELETE FROM `offense` WHERE `id` = %d",
                i
            );
        }
        query_empty(pearsq, query_string);
    }

    return 1;
}

stock Offense_IsExists(id)
{
    if (id < 0 || id > MAX_OFFENSE_REQUESTS) return 0;
    return OffenseInfo[id][oncPID] > 0;
}

stock Offense_Add(playerid, intruderid) {
    if (playerid < 0 || playerid > MAX_REALPLAYERS || intruderid < 0 || intruderid > MAX_REALPLAYERS) return 0;

    for (new i = 0; i < MAX_OFFENSE_REQUESTS; i++)
    {
        if (!OffenseInfo[i][oncPID])
        {
            OffenseInfo[i][oncPID] = PlayerInfo[playerid][pID];
            OffenseInfo[i][oncPlayerName][0] = EOS; strcat(OffenseInfo[i][oncPlayerName], PlayerInfo[playerid][pName]);
            OffenseInfo[i][oncIntruderPID] = PlayerInfo[intruderid][pID];
            OffenseInfo[i][oncIntruderName][0] = EOS; strcat(OffenseInfo[i][oncIntruderName], PlayerInfo[intruderid][pName]);
            OffenseInfo[i][oncUnix] = gettime(OffenseInfo[i][oncHours], OffenseInfo[i][oncMinutes], OffenseInfo[i][oncSeconds]);
            getdate(OffenseInfo[i][oncYear], OffenseInfo[i][oncMonth], OffenseInfo[i][oncDay]);
            
            new index = 0, j = 0;
            while (OutgoingMessages_Iterate(intruderid, index))
            {
                OffenseMessages[i][j][0] = EOS;
                strcat(OffenseMessages[i][j], OutgoingMessages[intruderid][index]);
                j++;
            }

            Offense_Save(i);
            return 1;
        }
    }
    
    return 0;
}

stock Offense_Delete(index) {
    for (new e_Offense: i; i < e_Offense; i++)
    {
        OffenseInfo[index][i] = 0;
    }

    for (new i = 0; i < MAX_OFFENSE_OUTGOING_MESSAGES; i++)
    {
        OffenseMessages[index][i][0] = EOS;
    }

    Offense_Save(index);

    return 1;
}

stock Offense_Dialog_Main(playerid) {
    if (PlayerInfo[playerid][pSoska] < 1) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Я не могу это сделать..");

    new dialog_text[4096] = "{cccccc}Игрок\t{ff6347}Нарушитель\t{ff6347}Дата";
    
    new quan = 0;
    for (new i = 0; i < MAX_OFFENSE_REQUESTS; i++)
    {
        if (!OffenseInfo[i][oncPID]) continue;

        format(dialog_text, sizeof(dialog_text), "%s\n{cccccc}%s\t{ff6347}%s\t{ff6347}%02d.%02d.%04d %02d:%02d:%02d", dialog_text,
            OffenseInfo[i][oncPlayerName], OffenseInfo[i][oncIntruderName],
            OffenseInfo[i][oncDay], OffenseInfo[i][oncMonth], OffenseInfo[i][oncYear],
            OffenseInfo[i][oncHours], OffenseInfo[i][oncMinutes], OffenseInfo[i][oncSeconds]
        );

        List[quan++][playerid] = i;
    }

    if (quan == 0) return SendClientMessage(playerid, COLOR_GREY, "[ Мысли ]: Жалоб на оскорбления: {00cc00}нет");

    return ShowDialog(playerid, OFFENSE_DIALOG_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "{ff6347}Жалобы на оскорбления", dialog_text, "Выбор", "Закрыть");
}

stock Offense_Dialog_Review(playerid, index)
{
    format(ListName[playerid], 64, "{FF6347}Рассмотрение нарушения {cccccc}%s", OffenseInfo[index][oncIntruderName]);
    DP[0][playerid] = index;

    new dialog_text[4096] = "{cccccc}Ниже вам предоставлены "#MAX_OFFENSE_OUTGOING_MESSAGES" последних сообщений отправленных игроком:\n\n";

    strcat(dialog_text, "{ff6347}");
    for (new quan, i = 0; i < MAX_OFFENSE_OUTGOING_MESSAGES; i++)
    {
        if (isnull(OffenseMessages[index][i])) continue;
        format(dialog_text, sizeof(dialog_text), "%s%02d. %s\n", dialog_text, ++quan, OffenseMessages[index][i]);
    }
    strcat(dialog_text, "\n{ff9000}Согласны ли вы с наличием оскорбления в указанных сообщениях?");

    return ShowDialog(playerid, OFFENSE_DIALOG_REVIEW, DIALOG_STYLE_MSGBOX, ListName[playerid], dialog_text, "Вердикт", "Назад");
}

stock Offense_Dialog_Review_Verdict(playerid, index)
{
    if (!OffenseInfo[index][oncPID]) return ErrorMessage(playerid, "{FF6347}Обращение уже кто-то рассмотрел");

    return ShowDialog(playerid, OFFENSE_DIALOG_REVIEW_VERDICT, DIALOG_STYLE_MSGBOX, ListName[playerid],
        "{cccccc}Согласны ли вы с наличием оскорблений в сообщениях игрока?\n\n" \
        \
        "{99ff66}Если вы вынесете положительное решение:\n" \
        "{cccccc}- Сообщения игрока будут отправлены в журнал оскорблений\n" \
        "{cccccc}- Вы должны будете самостоятельно определить и вынести наказание\n\n" \
        \
        "{ff6347}Если вы вынесете отрицательное решение:\n" \
        "{cccccc}- Обращение игрока будет безвозвратно удалено вместе с сообщениями\n\n" \
        \
        "{FF0000}* {FF6347}Ваше решение будет записано в журнал администрации в любом случае\n" \
        "{FF0000}* {FF6347}Будьте внимательны, не делайте поспешных выводов",
        \
        "Да", "Нет"
    );
}

stock dialogCase_Offense(playerid, dialogid, response, listitem) {
    switch (e_DialogId: dialogid)
    {
        case OFFENSE_DIALOG_MAIN:
        {
            if (!response) return 1;

            return Offense_Dialog_Review(playerid, List[listitem][playerid]);
        }
        case OFFENSE_DIALOG_REVIEW:
        {
            if (!response) return Offense_Dialog_Main(playerid);

            new index = DP[0][playerid];
            return Offense_Dialog_Review_Verdict(playerid, index);
        }
        case OFFENSE_DIALOG_REVIEW_VERDICT:
        {
            new index = DP[0][playerid];
            if (!OffenseInfo[index][oncPID]) return ErrorMessage(playerid, "{FF6347}Обращение уже кто-то рассмотрел");

            new id = -1, intruderid = -1;
            foreach (new currentid : Player)
            {
                if (PlayerInfo[currentid][pID] == OffenseInfo[index][oncPID]) {
                    id = currentid;
                } else if (PlayerInfo[currentid][pID] == OffenseInfo[index][oncIntruderPID]) {
                    intruderid = currentid;
                }

                if (id > -1 && intruderid > -1) break;
            }
            new player_ip[16 + 1]; if (id >= 0) strcat(player_ip, PlayerInfo[id][pPlaIP]);
            new intruder_ip[16 + 1]; if (intruderid >= 0) strcat(intruder_ip, PlayerInfo[intruderid][pPlaIP]);

            new dialog_header[64];
            format(dialog_header, sizeof(dialog_header), "{ff6347}Решение по жалобе {cccccc}%s", OffenseInfo[index][oncIntruderName]);

            if (!response) {
                PlayerPlaySound(playerid, 30802);

                new dialog_text[512];
                format(dialog_text, sizeof(dialog_text),
                    "{cccccc}Вы вынесли отрицательное решение по жалобе на оскорбление\n\n" \
                    \
                    "{ff0000}* {ff6347}Ваше решение записано в журнал действий администрации"
                );

                ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, dialog_header, dialog_text, "Закрыть", "");
            } else {
                PlayerPlaySound(playerid, 1149);
                for (new i = 0; i < MAX_OFFENSE_OUTGOING_MESSAGES; i++)
                {
                    if (isnull(OffenseMessages[index][i])) continue;
                    OffenseLog(OffenseInfo[index][oncIntruderPID], OffenseInfo[index][oncIntruderName], intruder_ip, OffenseMessages[index][i]);
                }

                new dialog_text[512];
                format(dialog_text, sizeof(dialog_text),
                    "{cccccc}Вы вынесли положительное решение по жалобе на оскорбление\n" \
                    "{cccccc}Теперь вам необходимо выдать нарушителю соответствующее наказание\n\n" \
                    \
                    "{ff0000}* {ff6347}Все сообщения %s записаны в журнал оскорблений\n" \
                    "{ff0000}* {ff6347}Ваше решение записано в журнал действий администрации",
                    
                    OffenseInfo[index][oncIntruderName]
                );

                ShowDialog(playerid, 1700, DIALOG_STYLE_MSGBOX, dialog_header, dialog_text, "Закрыть", "");
            }

            {
                new string[144];
                format(string, sizeof(string), "Вынес %s решение по жалобе на %s", (response ? "положительное" : "отрицательное"), OffenseInfo[index][oncIntruderName]);
                AdminLog("offense", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], OffenseInfo[index][oncPID], OffenseInfo[index][oncPlayerName], player_ip, response, string); 

                format(string, sizeof(string), " [ ADM ]: %s закрыл жалобу на оскорбление игрока %s [Нарушитель: %s / Решение: %s]", PlayerInfo[playerid][pName], OffenseInfo[index][oncPlayerName], OffenseInfo[index][oncIntruderName], (response ? "Одобрено" : "Отказ")), ABroadCast(COLOR_ADM,string,1);

                if (id > -1)
                {
                    SendClientMessage(id, 0xFF9000FF, "[!] {FFCC66}Ваша жалоба на оскорбление закрыта администратором %s %s", PlayerInfo[playerid][pName], response ? "{99ff66}[ Одобрено ]" : "{ff6347}[ Отказано ]");
                    PlayerPlaySound(id, 1139);
                }
            }
            

            return Offense_Delete(index);
        }
        default: {}
    }
    return 1;
}

CMD:offense(playerid) {
    return Offense_Dialog_Main(playerid);
}
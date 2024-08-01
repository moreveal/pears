/*
    Хранит последние N отправленных игроком сообщений/команд

    * Используется для системы оскорблений
*/

#define MAX_OUTGOING_MESSAGES       10
#define MAX_OUTGOING_MESSAGE_SIZE   144

new OutgoingMessages[MAX_REALPLAYERS][MAX_OUTGOING_MESSAGES][MAX_OUTGOING_MESSAGE_SIZE];
new OutgoingMessagesCurrentIndex[MAX_REALPLAYERS];
new OutgoingMessagesIterateIndex[MAX_REALPLAYERS] = {-1, ...};

stock OutgoingMessages_Add(playerid, const text[]) {
    if (!IsOnline(playerid)) return 0;

    new currentIndex = OutgoingMessagesCurrentIndex[playerid];

    OutgoingMessages[playerid][currentIndex][0] = EOS;
    strcat(OutgoingMessages[playerid][currentIndex], text);

    currentIndex++;
    if (currentIndex >= MAX_OUTGOING_MESSAGES) {
        currentIndex = 0;
    }

    OutgoingMessagesCurrentIndex[playerid] = currentIndex;

    return 1;
}

stock OutgoingMessages_Iterate(playerid, &index) {
    new bool: queue_filled = !isnull(OutgoingMessages[playerid][MAX_OUTGOING_MESSAGES - 1]);

    if (OutgoingMessagesIterateIndex[playerid] == -1) {
        if (queue_filled) {
            OutgoingMessagesIterateIndex[playerid] = OutgoingMessagesCurrentIndex[playerid];
        } else {
            OutgoingMessagesIterateIndex[playerid] = 0;
        }
    } else if (queue_filled ? OutgoingMessagesIterateIndex[playerid] == OutgoingMessagesCurrentIndex[playerid] : isnull(OutgoingMessages[playerid][OutgoingMessagesIterateIndex[playerid]])) {
        OutgoingMessagesIterateIndex[playerid] = -1;
        return 0;
    }

    index = OutgoingMessagesIterateIndex[playerid]++;
    if (index >= MAX_OUTGOING_MESSAGES) {
        index = 0;
    }

    OutgoingMessagesIterateIndex[playerid] %= MAX_OUTGOING_MESSAGES;

    return 1;
}

stock OutgoingMessages_OnPlayerDisconnect(playerid) {
    OutgoingMessagesCurrentIndex[playerid] = 0;
    OutgoingMessagesIterateIndex[playerid] = 0;
    for (new i = 0; i < MAX_OUTGOING_MESSAGES; i++) {
        OutgoingMessages[playerid][i][0] = EOS;
    }
    return 1;
}
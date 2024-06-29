// Минимальная и максимальная сумма для залога
#define COURT_MINIMAL_DEPOSIT       10_000
#define COURT_MAXIMAL_DEPOSIT       1_000_000

// Минимальная и максимальная суммы для отработки
#define COURT_MINIMAL_WORKING_OUT   10_000
#define COURT_MAXIMAL_WORKING_OUT   100_000

// Минимальное и максимальное количество дней, в течение которых подсудимому нельзя совершать правонарушения (или нужно отработать за этот срок)
#define COURT_MINIMAL_PERIOD        1
#define COURT_MAXIMAL_PERIOD        14

#define MAX_COURT_OFFERS 100 // Максимальное количество заявок
#define MAX_COURT_PLAYER_DECISIONS 25 // Максимальное количество закрепленных за игроком активных судебных решений

#define COURT_MINIMAL_JAILTIME 600 // Минимальное количество времени, которое должно оставаться до конца заключения перед вызовом в суд

// Типы заявок на суд
enum e_CourtStatus {
    COURT_STATUS_NONE, // Не существует
    COURT_STATUS_WAITING, // В ожидании
    COURT_STATUS_REVIEW, // Рассматривается
    COURT_STATUS_DONE // Рассмотрено
};

// Типы судебных решений
enum e_CourtDecision {
    COURT_CLASS_NONE = -1, // Не установлено
    COURT_CLASS_DECLINE, // Отклонение заявки
    COURT_CLASS_FREE_PAROLE, // УДО
    COURT_CLASS_PAROLE, // УДО + Залог
    COURT_CLASS_JAIL_REDUCE_PAROLE, // Сокращение срока в два раза + Залог
    COURT_CLASS_WORKING_OUT_PAROLE // УДО + Отработка
};

enum e_CourtInfo
{
    ciPlayerID, // playerid Создателя заявки
    ciTakeUserID, // playerid Судьи
    e_CourtStatus: ciStatus, // Статус заявки
    e_CourtDecision: ciDecision // Решение судебного заседания
}
new CourtInfo[MAX_COURT_OFFERS][e_CourtInfo];

// Судебные решения, закрепленные за игроком
enum e_PlayerCourtDecison {
    pcdSuspectID, // ID аккаунта преступника
    pcdArbiterID, // ID аккаунта судьи
    pcdLawyerID, // ID аккаунта адвоката
    e_CourtDecision: pcdType, // Вынесенное решение
    pcdDeposit, // Залог / Стоимость исправительных работ
    pcdTime, // Время вынесения приговора (UNIX)
    pcdPeriod, // Количество назначенных дней (для запрета правонарушений / отработки долга)
    bool: pcdWantedReturn, // Был ли возвращен розыск по статьям (чтобы не выдавать его несколько раз)
    e_WantedInfo: pcdWantedInfo // Информация о статьях, которые были закреплены за игроком на момент вынесения приговора
};
new PlayerCourtDecision[MAX_REALPLAYERS + MAX_OFFLINEPLAYERS][MAX_COURT_PLAYER_DECISIONS][e_PlayerCourtDecison]; // Информация о судебных решениях
new PlayerCourtDecisionWanted[MAX_REALPLAYERS + MAX_OFFLINEPLAYERS][MAX_COURT_PLAYER_DECISIONS][e_WantedInfo]; // Информация о статьях, прикрепленных к делу
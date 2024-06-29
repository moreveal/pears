enum e_DialogId {
    // Судебная система
    COURT_DIALOG_OFFERS = 3000, // Список заявок в суд
    COURT_DIALOG_OFFER_DONE_INFO, // Информация о выполненной заявке
    COURT_DIALOG_OFFER_WAITING_INFO, // Информация о заявке, ожидающей рассмотрения
    COURT_DIALOG_OFFER_CALL, // Информация о том, что судья вызвал вас на заседание
    COURT_DIALOG_OFFER_REVIEW, // Доступные варианты выбора для рассмотрения дела
    COURT_DIALOG_PROCESS_ACCEPT, // Принять выбранный вариант для рассмотрения дела
    COURT_DIALOG_ENTER_DEPOSIT, // Указание залога для вызволения / суммы для отработки
    COURT_DIALOG_CANCEL_OFFER, // Отмена заявки для подсудимого

    // Сдаться властям
    POLICE_DIALOG_SELF_SURRENDER,

    // Подфракции
    DIVISION_MENU,
    DIVISION_SETTINGS,
    DIVISION_SETNAME,
    DIVISION_ABBREVIATION,
    DIVISION_RANK_AMOUNT,
    DIVISION_RANK_SETNAME,
    DIVISION_RANK_SETNAME_SAVE,
    DIVISION_SPAWN,
    DIVISION_SETCOLOR,
    //DIVISION_SETVEHCOLOR,
    DIVISION_LEAVE,
    DIVISION_MEMBERS,
    DIVISION_INVITE,
    DIVISION_INVITE_SAVE,
    DIVISION_UNINVITE_SAVE,
    DIVISION_MEMBERS_LIST,
    DIVISION_ORDER_WEAPONS,


    // Установка доступных оружий для сотрудников департамента 
    ADMIN_SET_DEPARTWEAPONS_FRACTIONS, // Список фракций
    ADMIN_SET_DEPARTWEAPONS_LIST, // Список оружия
};
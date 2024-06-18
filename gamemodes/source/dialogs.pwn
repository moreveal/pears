enum e_DialogId {
    // Судебная система
    COURT_DIALOG_OFFERS = 3000, // Список заявок в суд
    COURT_DIALOG_OFFER_DONE_INFO, // Информация о выполненной заявке
    COURT_DIALOG_OFFER_WAITING_INFO, // Информация о заявке, ожидающей рассмотрения
    COURT_DIALOG_OFFER_CALL, // Информация о том, что судья вызвал вас на заседание
    COURT_DIALOG_OFFER_REVIEW, // Доступные варианты выбора для рассмотрения дела
    COURT_DIALOG_PROCESS_ACCEPT, // Принять выбранный вариант для рассмотрения дела
    COURT_DIALOG_ENTER_DEPOSIT, // Указание залога для вызволения / суммы для отработки

    POLICE_DIALOG_SELF_SURRENDER // Сдаться властям
};
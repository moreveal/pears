#define MAX_CRIMINAL_CODE_ARTICLE 80 // Максимальный набор статьей в кодексе
#define MAX_CRIMINAL_CODE_SUBENTRY 20 // Максимальное количество статей в наборе

enum criminalInfo
{
    ccID, // newid в базе данных
	ccArticle[8], // Номер статьи (возможность указать плавающую точку, типо 1.1 и т.д.)
    bool:ccStatus, // Существует статья или нет
	ccName[31], // Название статьи
	ccLevel, // Уровень розыска статьи
    ccFine, // Штраф 
	ccText[121], // Описание статьи
    ccUnix, // Дата и время последнего изменения статьи
    ccPlayer[21], // Никнейм игрока, который последний раз изменял статью
    ccUserID // ID аккаунта игрока, который последний раз изменял статью
};
new CriminalCodeInfo[MAX_CRIMINAL_CODE_ARTICLE][MAX_CRIMINAL_CODE_SUBENTRY][criminalInfo];

#define MAX_CRIME_PLAYER 10

enum e_WantedInfo
{
    wanCrime[MAX_CRIME_PLAYER], // id статей
    wanSubentry[MAX_CRIME_PLAYER], // id подстатей
    wanPoliceId[MAX_CRIME_PLAYER], // userid полицейского
    wanUnix[MAX_CRIME_PLAYER], // unix, когда выдали розыск

    wanTicketCrime[MAX_CRIME_PLAYER], // id статей штрафа
    wanTicketSubentry[MAX_CRIME_PLAYER], // id подстатей штрафа
    wanTicketPoliceId[MAX_CRIME_PLAYER], //  userid полицейского
    wanTicketUnix[MAX_CRIME_PLAYER], // unix, когда выдали штраф
    bool: wanLoad // Загрузка розыска из базы
};
new WantedInfo[MAX_REALPLAYERS + MAX_OFFLINEPLAYERS][e_WantedInfo];
new WantedPolice[MAX_REALPLAYERS + MAX_OFFLINEPLAYERS][MAX_CRIME_PLAYER][24]; // имя мента, который выдал розыск
new TicketPolice[MAX_REALPLAYERS + MAX_OFFLINEPLAYERS][MAX_CRIME_PLAYER][24]; // имя мента, который выдал штраф
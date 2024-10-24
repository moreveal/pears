#define CNN_AD_COOLDOWN         10 // Время (в секундах), сколько должно пройти времени между подачей объявлений

#define CNN_AD_EDIT_MAX         50 // Максимальное число объявлений на редактировании
#define CNN_AD_QUEUE_MAX        128 // Максимальное число объявлений в очереди
#define CNN_AD_LIST_MAX         1500 // Максимальное число объявлений в списке

#define CNN_AD_LIST_PAGE_MAX    25 // Максимальное количество объявлений на странице

// На редактировании
enum e_Advertise {
	adsID,
    adsType,
	adsText[128]
};
new Advertise[CNN_AD_EDIT_MAX][e_Advertise];
new TakeAdvertise[CNN_AD_EDIT_MAX] = {-1, ...};

// Очередь перед публикацией
enum e_AdvertiseQueue {
    adsSender[32],
    adsHandler[32],
	adsText[128],
    adsTargetHour, adsTargetMinute
}
new AdvertiseQueue[CNN_AD_QUEUE_MAX][e_AdvertiseQueue];

// Опубликованные
enum e_AdvertiseList {
    cnnAdsType,
    cnnAdsText[128],
    cnnAdsSender[MAX_PLAYER_NAME + 1],
    cnnAdsHandler[MAX_PLAYER_NAME + 1],
    cnnAdsTime[32]
}
new AdvertiseList[CNN_AD_LIST_MAX][e_AdvertiseList];
#define CNN_AD_COOLDOWN     30 // Время (в секундах), сколько должно пройти времени между подачей объявлений

#define CNN_AD_EDIT_MAX     50 // Максимальное число объявлений на редактировании
#define CNN_AD_QUEUE_MAX    128 // Максимальное число объявлений в очереди
#define CNN_AD_LIST_MAX     128 // Максимальное число объявлений в списке

// На редактировании
enum e_Advertise {
	adsID,
    adsType,
	adsText[128]
};
new Advertise[CNN_AD_EDIT_MAX][e_Advertise];
new TakeAdvertise[CNN_AD_EDIT_MAX];

// Очередь перед публикацией
enum e_AdvertiseQueue {
    adsSender[32],
    adsHandler[32],
	adsText[128]
}
new AdvertiseQueue[CNN_AD_QUEUE_MAX][e_AdvertiseQueue];

// Опубликованные
enum e_AdvertiseList {
    adsType,
    cnnAdsText[128],
    cnnAdsSender[32],
    cnnAdsHandler[32],
    cnnAdsTime[32]
}
new AdvertiseList[CNN_AD_LIST_MAX][e_AdvertiseList];
enum e_RadioInterceptorState {
	RADIO_INTERCEPTOR_STATE_SU = 0b0001,
	RADIO_INTERCEPTOR_STATE_PURSUIT = 0b0010,
	RADIO_INTERCEPTOR_STATE_CUFF = 0b0100
};
#define RADIO_INTERCEPTOR_FIND_COOLDOWN		10 // Время (в минутах), сколько нельзя использовать поиск местоположения
#define RADIO_INTERCEPTOR_SOFTWARE_TIME		14 // Время (в днях), сколько будет оставаться работоспособным новый радиоперехватчик
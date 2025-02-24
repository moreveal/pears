/*
    Advanced Dialog API
    -------------------

    Данный API позволяет создавать и обрабатывать расширенные диалоги с динамическим содержимым,
    сохранением контекста и автоматическим прикреплением значений для отдельных элементов.
*/

/*
    Макросы для объявления диалоговых функций
*/

/**
 * DIALOG
 *
 * Объявляет диалоговую функцию без дополнительных параметров.
 *
 * Синтаксис вызова:
 *   DIALOG:имя_диалога(playerid, response, listitem, const inputtext[])
 *
 * Пример:
 *   DIALOG:setorgcontinental(playerid, response, listitem, const inputtext[])
 */
#define dialog:%0(%1,%2,%3,%4) \
    forward dlg_%0(%1,%2,%3,%4); \
    public dlg_%0(%1,%2,%3,%4)

/**
 * DIALOG_ITEMS
 *
 * Объявляет диалоговую функцию с дополнительным параметром (например, идентификатором элемента).
 *
 * Синтаксис вызова:
 *   DIALOG_ITEMS:имя_диалога(playerid, response, listitem, item, const inputtext[])
 *
 * Пример:
 *   DIALOG_ITEMS:setorgcontinental_fraction(playerid, response, listitem, fractionid, const inputtext[])
 */
#define dialog_items:%0(%1,%2,%3,%4,%5) \
    forward dlg_%0(%1,%2,%3,%4,%5); \
    public dlg_%0(%1,%2,%3,%4,%5)

/**
 * DIALOG_GENERATOR
 *
 * Объявляет функцию-генератор диалога, в случае если диалог является динамическим.
 *
 * Синтаксис вызова:
 *   DIALOG_GENERATOR:имя_диалога(playerid)
 *
 * Пример:
 *   DIALOG_GENERATOR:setorgcontinental_fraction(playerid)
 */
#define dialog_generator:%0(%1)  \
    stock cdlg_%0(%1)

/**
 * Макрос ShowAdvancedDialogGen
 *
 * Вызывает сгенерированный диалог.
 *
 * Синтаксис вызова:
 *   ShowAdvancedDialogGen<имя_диалога>(playerid);
 *
 * Пример:
 *   ShowAdvancedDialogGen<setorgcontinental_fraction>(playerid);
 */
#define ShowAdvancedDialogGen<%0>(%1); cdlg_%0(%1);

/*
    Константы и переопределения
*/

#define INVALID_ADVANCED_ID     (-1)
#define DIALOG                  dialog
#define DIALOG_ITEMS            dialog_items
#define DIALOG_GENERATOR        dialog_generator

/*
    Нативные функции для работы с диалогами
*/

/**
 * native bool:ShowAdvancedDialog(playerid, const name[], style, const title[], const text[],
 *                                   const button1[], const button2[], bool: init);
 *
 * Открывает диалог с указанными параметрами.
 *
 * Параметры:
 *   playerid   - идентификатор игрока.
 *   name       - имя диалога (используется для обработки ответа).
 *   style      - стиль диалога (например, табличный список или ввод).
 *   title, text- заголовок и текст диалога.
 *   button1, button2 - подписи кнопок.
 *   init       - флаг инициализации.
 */
native bool:ShowAdvancedDialog(playerid, const name[], style = INVALID_ADVANCED_ID, const title[] = "", const text[] = "", const button1[] = "", const button2[] = "", bool: init = false);

/**
 * native bool:ShowAdvancedDialogEx(playerid, const name[], style, const title[], const text[],
 *                                     const button1[], const button2[], items_per_page, const prevbtn[],
 *                                     const nextbtn[], bool: init);
 *
 * Расширенная версия функции с постраничным отображением элементов.
 */
native bool:ShowAdvancedDialogEx(playerid, const name[], style = INVALID_ADVANCED_ID, const title[] = "", const text[] = "", const button1[] = "", const button2[] = "", items_per_page = 20, const prevbtn[] = "{cccccc}Предыдущая страница", const nextbtn[] = "{cccccc}Следующая страница", bool: init = false);

/**
 * Функции для работы с контекстом диалога.
 *
 * SetDialogContext* - сохраняют значение по ключу.
 * GetDialogContext* - извлекают ранее сохранённое значение.
 * ClearDialogContext - очищает контекст для игрока.
 */
native bool:SetDialogContext(playerid, const key[], const value[]);
native bool:SetDialogContextInt(playerid, const key[], value);
native bool:SetDialogContextFloat(playerid, const key[], Float: value);

native GetDialogContext(playerid, const key[], value[], len = sizeof(value));
native GetDialogContextInt(playerid, const key[]);
native Float:GetDialogContextFloat(playerid, const key[]);
native bool:ClearDialogContext(playerid);

/**
 * AttachAdvancedDialogItemValue
 *
 * Прикрепляет дополнительное значение к элементу диалога.
 * Связанные значения автоматически очищаются после отображения диалога
 *
 * Обработчик должен быть сделан с использованием макроса DIALOG_ITEMS.
 * Желательно использовать с DIALOG_GENERATOR (отображение диалога вновь без генерации - небезопасно из-за очищенных значений).
 */
native bool:AttachAdvancedDialogItemValue(playerid, const name[], value);

/**
 * Дополнительные функции для работы с диалогами.
 */
native bool:GetLastAdvancedDialog(playerid, name[], len = sizeof(name));
native bool:IsAdvancedDialogCached(playerid, const name[]);

/*
    Стоковые функции для работы с логическими и целочисленными значениями в контексте диалога.
*/

stock SetDialogContextBool(playerid, const key[], bool: status)
{
    return SetDialogContextInt(playerid, key, status ? 1 : 0);
}

stock bool:GetDialogContextBool(playerid, const key[])
{
    return GetDialogContextInt(playerid, key) > 0;
}

stock InverseDialogContextBool(playerid, const key[])
{
    return SetDialogContextBool(playerid, key, !GetDialogContextBool(playerid, key));
}

stock ChangeDialogContextInt(playerid, const key[], diff, min = 0, max = 99999999)
{
    new value = GetDialogContextInt(playerid, key) + diff;
    if (value < min) value = max;
    else if (value > max) value = min;

    return SetDialogContextInt(playerid, key, value);
}

/*
    Обработчик ответа на диалог.
    
    Необходим для "сырой" обработки диалогов, в случае если хочется избежать использования макроса
*/
forward OnAdvancedDialogResponse(playerid, response, listitem, const name[], const inputtext[]);

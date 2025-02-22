#define dialog:%0(%1,%2,%3,%4) \
    forward dlg_%0(%1,%2,%3,%4); \
    public dlg_%0(%1,%2,%3,%4)

#define dialog_items:%0(%1,%2,%3,%4,%5) \
    forward dlg_%0(%1,%2,%3,%4,%5); \
    public dlg_%0(%1,%2,%3,%4,%5)

#define DIALOG                  dialog
#define DIALOG_ITEMS            dialog_items

#define INVALID_ADVANCED_ID     (-1)

/*
                                                                           
    888b      88                       88                                      
    8888b     88                ,d     ""                                      
    88 `8b    88                88                                             
    88  `8b   88  ,adPPYYba,  MM88MMM  88  8b       d8   ,adPPYba,  ,adPPYba,  
    88   `8b  88  ""     `Y8    88     88  `8b     d8'  a8P_____88  I8[    ""  
    88    `8b 88  ,adPPPPP88    88     88   `8b   d8'   8PP"""""""   `"Y8ba,   
    88     `8888  88,    ,88    88,    88    `8b,d8'    "8b,   ,aa  aa    ]8I  
    88      `888  `"8bbdP"Y8    "Y888  88      "8"       `"Ybbd8"'  `"YbbdP"'  
                                                                           
                                                                           

*/


native bool:ShowAdvancedDialog(playerid, const name[], style = INVALID_ADVANCED_ID, const title[] = "", const text[] = "", const button1[] = "", const button2[] = "", bool: init = false);
native bool:ShowAdvancedDialogEx(playerid, const name[], style = INVALID_ADVANCED_ID, const title[] = "", const text[] = "", const button1[] = "", const button2[] = "", items_per_page = 20, const prevbtn[] = "{cccccc}Предыдущая страница", const nextbtn[] = "{cccccc}Следующая страница", bool: init = false);
native bool:AttachAdvancedDialogItemValue(playerid, const name[], value);

native bool:SetDialogContext(playerid, const key[], const value[]);
native bool:SetDialogContextInt(playerid, const key[], value);
native bool:SetDialogContextFloat(playerid, const key[], Float: value);

native GetDialogContext(playerid, const key[], value[], len = sizeof(value));
native GetDialogContextInt(playerid, const key[]);
native Float:GetDialogContextFloat(playerid, const key[]);
native bool:ClearDialogContext(playerid);

native bool:GetLastDialogName(playerid, name[], len = sizeof(name));

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

      ,ad8888ba,               88  88  88                                   88
     d8"'    `"8b              88  88  88                                   88
    d8'                        88  88  88                                   88
    88             ,adPPYYba,  88  88  88,dPPYba,   ,adPPYYba,   ,adPPYba,  88   ,d8   ,adPPYba,
    88             ""     `Y8  88  88  88P'    "8a  ""     `Y8  a8"     ""  88 ,a8"    I8[    ""
    Y8,            ,adPPPPP88  88  88  88       d8  ,adPPPPP88  8b          8888[       `"Y8ba,
     Y8a.    .a8P  88,    ,88  88  88  88b,   ,a8"  88,    ,88  "8a,   ,aa  88`"Yba,   aa    ]8I
      `"Y8888Y"'   `"8bbdP"Y8  88  88  8Y"Ybbd8"'   `"8bbdP"Y8   `"Ybbd8"'  88   `Y8a  `"YbbdP"'



*/

forward OnAdvancedDialogResponse(playerid, response, listitem, const name[], const inputtext[]);

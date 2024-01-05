
new browser_id;
new object_browser;
stock CreateCefText(playerid)
{
    cef_create_browser(playerid, browser_id, "https://youtu.be/4Vgg72382BM", false, false);
    object_browser = CreateObject(19477, 1050.424560, 2448.101074, 12.640864, 0.000000, 0.000000, 0.000000);
    cef_append_to_object(playerid, browser_id, object_browser);
    return 1;
}

CMD:cef(playerid)
{
    if(server != 0) return 1;
    CreateCefText(playerid);
    SuccessMessage(playerid, "browser created");
    return 1;
}

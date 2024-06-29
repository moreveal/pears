
// Кастомные объекты
stock IsAObjectCustom(objectid)
{
    if(objectid >= 12093 && objectid <= 12719
        || objectid >= 12722 && objectid <= 12799) return true;
    return false;
}

stock stamp2datetime(unixtime, &year, &month, &day, &hour, &minute, &second, gpchour)
{
    gpchour -= 0;       
    new seconds_in_day = 86400;
    new seconds_in_hour = 3600;
    new seconds_in_minute = 60;

    new days = unixtime / seconds_in_day;
    new remaining_seconds = unixtime % seconds_in_day;
    new current_year = 1970;

    while (days >= 365)
    {
        if (IsLeapYear(current_year))
        {
            if (days >= 366)
            {
                days -= 366;
                current_year++;
            }
            else
                break;
        }
        else
        {
            days -= 365;
            current_year++;
        }
    }

    month = 1;
    day = 1;

    while (days > 0)
    {
        new days_in_month = GetDaysInMonth(current_year, month);

        if (days >= days_in_month)
        {
            days -= days_in_month;
            month++;

            if (month > 12)
            {
                month = 1;
                current_year++;
            }
        }
        else
        {
            day += days;
            days = 0;
        }
    }

    hour = remaining_seconds / seconds_in_hour;
    remaining_seconds %= seconds_in_hour;

    minute = remaining_seconds / seconds_in_minute;
    remaining_seconds %= seconds_in_minute;

    second = remaining_seconds;

    year = current_year;

    return 1;
}

stock IsLeapYear(year)
{
    return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
}

stock GetDaysInMonth(year, month)
{
    new days_in_month;

    if (month == 2)
    {
        days_in_month = IsLeapYear(year) ? 29 : 28;
    }
    else if (month == 4 || month == 6 || month == 9 || month == 11)
    {
        days_in_month = 30;
    }
    else
    {
        days_in_month = 31;
    }

    return days_in_month;
}
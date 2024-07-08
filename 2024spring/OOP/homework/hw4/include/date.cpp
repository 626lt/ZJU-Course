#include "../include/date.h"

void date::set_date(int y, int m, int d)
{
    yyyy = y;
    mm = m;
    dd = d;
}

date date::from_string(const string& dates)
{
    date d;
    d.yyyy = std::stoi(dates.substr(0, 4));
    d.mm = std::stoi(dates.substr(5, 2));
    d.dd = std::stoi(dates.substr(8, 2));
    return d;
}

bool date::operator<(const date& other) const{
    if (yyyy != other.yyyy) return yyyy < other.yyyy;
    if (mm != other.mm) return mm < other.mm;
    return dd < other.dd;
}

bool date::operator<=(const date& other) const{
    if (yyyy != other.yyyy) return yyyy < other.yyyy;
    if (mm != other.mm) return mm < other.mm;
    return dd <= other.dd;
}

bool date::operator==(const date& other) const{
    return yyyy == other.yyyy && mm == other.mm && dd == other.dd;
}
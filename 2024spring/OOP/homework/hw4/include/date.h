#ifndef DATE_H
#define DATE_H
#include <iostream>
#include <string>
using std::string;
struct date
{
    int yyyy, mm, dd;
    void set_date(int y, int m, int d);
    static date from_string(const string& date);
    bool operator<(const date& other) const;
    bool operator<=(const date& other) const;
    bool operator==(const date& other) const;
};

#endif
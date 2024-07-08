#ifndef DIARY_H
#define DIARY_H
#include "date.h"
#include <iostream>
#include <string>
#include <map>
#include <fstream>
#include <sstream>

class Diary{
    public:
        Diary();
        ~Diary();
        void add_diary(const date& d, const std::string& entry);
        void list_all_diary() const;
        void list_diary_between_date(const date& begin, const date& end) const;
        void show_diary(const date& d) const;
        void remove_diary(const date& d);
        void read_from_file();
        void write_to_file();

    private:
        std::map<date, std::string> diary;

};


#endif
#include"../include/diary.h"
int main()
{
    Diary d;
    string input;
    d.read_from_file();
    while (std::getline(std::cin, input)) {
        if(input == ".")break;
        std::istringstream iss(input);
        std::string date_str;
        std::getline(iss, date_str, ':');
        std::string diary_entry;
        std::getline(iss, diary_entry);
        date dt = date::from_string(date_str);
        d.add_diary(dt, diary_entry);
    }
    d.write_to_file();
    return 0;
}
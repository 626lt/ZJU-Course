#include"../include/diary.h"

int main(int argc, char* argv[])
{
    Diary d;
    string input;
    d.read_from_file();
    if(argc == 3)
    {
        std::string date_str1, date_str2;
        date dt1 = date::from_string(argv[1]);
        date dt2 = date::from_string(argv[2]);
        d.list_diary_between_date(dt1, dt2);
    }else{
        d.list_all_diary();
    }
    return 0;
}
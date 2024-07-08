#include"../include/diary.h"

int main(int argc, char* argv[])
{
    Diary d;
    d.read_from_file();
    if(argc == 1)
    {
        date da;
        string input;
        while(std::cin >> input)
        {
            da = date::from_string(input);
            d.show_diary(da);
        }
    }else{
        for(int i = 1;i < argc;i++)
        {
            d.show_diary(date::from_string(argv[i]));
        }
    }
    
    return 0;
}
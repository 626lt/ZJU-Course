#include"../include/diary.h"

int main(int argc, char* argv[])
{
    Diary d;
    d.read_from_file();
    date da;
    std::string input;
    if(argc == 1){
        while(std::cin >> input)
        {   
            if(input == ".") break;
            da = date::from_string(input);
            d.remove_diary(da);
        }
    }else{
        for(int i = 1;i < argc;i++)
        {
            d.remove_diary(date::from_string(argv[i]));
        }
    }
    d.write_to_file();
    return 0;
}

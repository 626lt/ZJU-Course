#include"../include/diary.h"

Diary::Diary()
{
}

Diary::~Diary()
{
}

void Diary::add_diary(const date& d, const std::string& entry)
{
    diary[d] = entry;
}

void Diary::list_all_diary() const
{
    for (auto& d : diary)
    {
        std::cout << d.first.yyyy << "-" << d.first.mm << "-" << d.first.dd << std::endl;
    }
}

void Diary::list_diary_between_date(const date& begin, const date& end) const
{
    for (auto& d : diary)
    {
        if (begin <= d.first && d.first <= end)
        {
            std::cout << d.first.yyyy << "-" << d.first.mm << "-" << d.first.dd  << std::endl;
        }
    }
}

void Diary::show_diary(const date& d) const
{
    auto it = diary.find(d);
    if (it != diary.end())
    {
        std::cout << it->first.yyyy << "-" << it->first.mm << "-" << it->first.dd << " : " << it->second << std::endl;
    }
    else
    {
        std::cout << "No diary entry found for " << d.yyyy << "-" << d.mm << "-" << d.dd << std::endl;
    }
}

void Diary::remove_diary(const date& d)
{
    auto it = diary.find(d);
    if (it != diary.end())
    {
        diary.erase(it);
    }
    else
    {
        std::cout << "No diary entry found for " << d.yyyy << "-" << d.mm << "-" << d.dd << std::endl;
    }
}

void Diary::read_from_file()
{
    std::ifstream ifs("data.txt");
    if (!ifs)
    {
        std::cerr << "Error opening file data.txt" << std::endl;
        return;
    }
    std::string line;
    while (std::getline(ifs, line))
    {
        std::istringstream iss(line);
        std::string date_str;
        std::getline(iss, date_str, ':');
        std::string diary_entry;
        std::getline(iss, diary_entry);
        date dt = date::from_string(date_str);
        add_diary(dt, diary_entry);
    }
}

void Diary::write_to_file()
{
    std::ofstream ofs("data.txt");
    if (!ofs)
    {
        std::cerr << "Error opening file data.txt" << std::endl;
        return;
    }
    for (auto& d : diary)
    {
        ofs << d.first.yyyy << "-" << d.first.mm << "-" << d.first.dd << " : " << d.second << std::endl;
    }
}
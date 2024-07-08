
#ifndef ROOM_H
#define ROOM_H

#include<string>
#include<vector>
#include<map>
using std::string;
using std::vector;
using std::map;
/*This class room is the basic element in adventure*/
class Room{
    public:
        Room(string name, vector<string> directions, bool special = false);
        ~Room();
    private:
        string name;
        map<string, Room*> exits;
        bool princess, monster;
    public:
        bool getprincess();
        bool getmonster();
        bool exitExist(string direction);
        Room* getexit(string direction);
        void setexit(string direction, Room* room);
        void printInfo();
};

#endif
#include"room.h"
#include<iostream>

using std::cout,std::cin,std::endl;
Room::Room(string name, vector<string> directions, bool special){
    this->name = name;
    if(special == false){// if the room is not special, it has no princess and monster
        princess = false;
        monster = false;
    }else{
        if (rand() % 5 == 0) {
            princess = true;
            monster = false;
        }
        if(rand() % 5 == 1) {
            princess = false;
            monster = true;
        }//if the room is special, then it has 20% to have a princess or a monster
    }
    for(auto it = directions.begin(); it != directions.end(); it++){
        if(rand() % 2 == 1){
            exits[*it] = nullptr;
        }
    }//randomly set the exits

}

Room::~Room(){
}

bool Room::getprincess(){
    return princess;
}

bool Room::getmonster(){
    return monster;
}

bool Room::exitExist(string direction){
    return exits.find(direction) != exits.end();//if the direction is in the exits, return true
}

Room* Room::getexit(string direction){
    return exits[direction];
}

void Room::setexit(string direction, Room* room){
    exits[direction] = room;
}

void Room::printInfo(){//print the information of the room
    cout << "Welcome to the "<< name << ". There are " << exits.size() << " exits: ";
    for(auto it = exits.begin(); it != exits.end(); it++){
        cout << it->first << " ";   
    }
    cout << "\nEnter your command:";//waiting for the command
}
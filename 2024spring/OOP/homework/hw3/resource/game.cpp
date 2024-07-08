#include"game.h"
#include<iostream>
using std::cin,std::cout,std::endl;
using std::to_string;
Game::Game()
{
    Room *room = new Room("lobby", directions, false);// initialize the lobby
    rooms.push_back(room);
}

Game::~Game()
{
    for(auto it = rooms.begin(); it != rooms.end(); it++){
        delete *it;
    }
}

Room* Game::addroom(string name)
{
    bool special = false;
    if(rooms.size() > 4){ // limit the turns of game, howerver, when I test, it often comming end soon.
        special = true;
    }else if(rand() % 5 == 1){// randomly set the room to be special
        special = true;
    }   
    Room *room = new Room(name, directions,special);
    rooms.push_back(room);
    return room;
}

void Game::play()
{
    Room *current = rooms[0];
    string go, direction;
    while(1)// the game will continue until the player win or lose
    {
        current->printInfo();//always print the information of the room
        cin >> go >> direction;
        if(!current->exitExist(direction))//if input a illegal direction, print the error message
        {
            cout << "There is no exit in that direction." << endl;
            continue;
        }

        Room *newroom = current->getexit(direction);//get the next room
        if(!newroom){// create the room if the room is not exist
            newroom = addroom("room " + to_string(rooms.size()));
            current->setexit(direction, newroom);
            direction = oppositeDirection(direction);
            newroom->setexit(direction, current);
        }
        current = newroom;
        //check the princess and monster
        if(current->getprincess())
        {
            if(!princess){
                cout << "Congratulation! You found the princess!" << endl;
                cout << "Princess: oh my hero, you saved me! Now let we come back to the lobby! Don't forget the horrible monster!" << endl;
                princess = true;
            }                 
        }
        if(newroom->getmonster())
        {
            cout << "Oh my god! You were eaten by the monster! You fail!!!" << endl;
            return;
        }
        // return to the lobby with the princess
        if(princess && current == rooms[0])
        {
            cout << "You and the princess come back to the lobby. You win!" << endl;
            return;
        }
    }
}

string Game::oppositeDirection(string direction)//get the opposite direction
{
    if(direction == "north")
        return "south";
    else if(direction == "south")
        return "north";
    else if(direction == "east")
        return "west";
    else if(direction == "west")
        return "east";
    else
        return "error";
}
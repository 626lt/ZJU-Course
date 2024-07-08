#ifndef GAME_H
#define GAME_H

#include "room.h"
/*class Game is contain the play method to run the game*/
class Game{
    public:
        Game();
        ~Game();
    private:
        vector<Room*> rooms;
        bool princess = false;
        vector<string> directions = {"north", "south", "east", "west"};
    public:
        Room* addroom(string name);
        void play();
        string oppositeDirection(string direction);
};
#endif
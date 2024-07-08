## Some test cases

The following test is on my machine, with complier Apple clang version 15.0.0 (clang-1500.3.9.4)

### case 1 the success case

```shell
└> ./game
Welcome to the lobby. There are 3 exits: east north south 
Enter your command:go east
Welcome to the room 1. There are 1 exits: west 
Enter your command:go west
Welcome to the lobby. There are 3 exits: east north south 
Enter your command:go south
Welcome to the room 2. There are 2 exits: north south 
Enter your command:go south
Welcome to the room 3. There are 3 exits: east north south 
Enter your command:go east
Welcome to the room 4. There are 4 exits: east north south west 
Enter your command:go south
Congratulation! You found the princess!
Princess: oh my hero, you saved me! Now let we come back to the lobby! Don't forget the horrible monster!
Welcome to the room 5. There are 2 exits: north west 
Enter your command:go north
Welcome to the room 4. There are 4 exits: east north south west 
Enter your command:go west
Welcome to the room 3. There are 3 exits: east north south 
Enter your command:go north
Welcome to the room 2. There are 2 exits: north south 
Enter your command:go north
You and the princess come back to the lobby. You win!
```
![alt text](image-1.png)

### case 2 the fail case

```shell
> ./game
Welcome to the lobby. There are 3 exits: east north south 
Enter your command:go east 
Welcome to the room 1. There are 1 exits: west 
Enter your command:go west
Welcome to the lobby. There are 3 exits: east north south 
Enter your command:go south
Welcome to the room 2. There are 2 exits: north south 
Enter your command:go south
Welcome to the room 3. There are 3 exits: east north south 
Enter your command:go east
Welcome to the room 4. There are 4 exits: east north south west 
Enter your command:go east
Congratulation! You found the princess!
Princess: oh my hero, you saved me! Now let we come back to the lobby! Don't forget the horrible monster!
Welcome to the room 5. There are 2 exits: north west 
Enter your command:go north
Oh my god! You were eaten by the monster! You fail!!!
```
![alt text](image-2.png)

### case 3 type illegal command

```shell
Welcome to the lobby. There are 3 exits: east north south 
Enter your command:go errow
There is no exit in that direction.
Welcome to the lobby. There are 3 exits: east north south 
Enter your command:
```
![alt text](image-3.png)
it turns out that the game will not crash when you type illegal command. It will just show the error message and wait for the next command.
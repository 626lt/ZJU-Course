This is oop course hw3 adventure game.
The folder structure is as follows:

```shell
.
├── readme.md # This file
└── resource # Resource code
    ├── Makefile # Makefile
    ├── game.cpp # Game class implementation
    ├── game.h # Game class header
    ├── main.cpp # Main function
    ├── room.cpp # Room class implementation
    └── room.h # Room class header
```

## How to play

The resource code is in `resource` folder. You can compile it by `make` command.

```shell
$ cd resource
$ make
```

If the `make` work failed, you can use the following command to compile the game.

```shell
g++ -std=c++17 -o game main.cpp game.cpp room.cpp
```

Then you can run the game by `./game` command.Note that you should type the command with `go dict` format. For example, if you want to go east, you should type `go east`.



The directory structure is as follows:
```
.
├── clean.sh
├── include # header files
│   ├── date.cpp
│   ├── date.h
│   ├── diary.cpp
│   └── diary.h
├── makefile 
├── readme.md
├── src # source files
│   ├── pdadd.cpp
│   ├── pdlist.cpp
│   ├── pdremove.cpp
│   └── pdshow.cpp
├── test # test data
│   ├── add.txt
│   └── remove.txt
└── test.sh
```

you can complie by running the following command in the terminal:
```
mkdir target
make
```
Then you can test my program on your own;

you can also test my program by running the following command in the terminal:
```
./test.sh
```
I have test several cases in the test.sh file, you can also add your own test cases in the test.sh file.
The clean.sh file is used to clean the target and result directory.


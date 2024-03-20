#!/bin/bash

clang std.c -o std 
clang test.c -o test

while true; do
    python3 gen.py
    ./std < input.txt > std_out.txt
    ./test < input.txt > test_out.txt
    if diff std_out.txt test_out.txt; then
        echo "pass"
    else
        echo "fail!"
        exit 0
    fi
done
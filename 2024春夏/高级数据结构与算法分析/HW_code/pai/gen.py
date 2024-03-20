import random

n = 15

file = open("input.txt", "w")

file.write(str(n) + "\n")

for i in range(n):
    file.write(str(random.randint(1, n)) + " ")
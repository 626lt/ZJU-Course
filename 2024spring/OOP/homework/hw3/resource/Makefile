# 定义变量
CXX = g++
CXXFLAGS = -std=c++17
SRC = main.cpp game.cpp room.cpp
TARGET = game

# 默认目标
all: $(TARGET)

# 链接目标
$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) -o $@ $^

# 清理目标
clean:
	rm -f $(TARGET)

.PHONY: all clean
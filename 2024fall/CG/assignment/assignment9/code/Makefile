UNAME_S := $(shell uname -s)
# Compiler and flags
CXX := g++

ORBIT := 1
CF := -Wall -Wextra -std=c++11 -Wno-unused-parameter -Wno-unused-const-variable -Iinclude $(shell test $(ORBIT) -eq 1 && echo -DORBIT) 

# Frameworks and libraries

ifeq ($(UNAME_S), Darwin)
	LDFLAGS := -L/System/Library/Frameworks -framework GLUT -framework OpenGL
else ifeq ($(UNAME_S), Linux)
	LDFLAGS := -lGL -lGLU -lglut
else
    $(error Unsupported platform)
endif

# Directories and files
SRC_DIR := source
INCLUDE := -I $(shell pwd)/include
TARGET := demo

CXXFLAGS := $(INCLUDE) $(CF)

# Source and object files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(SRCS:.cpp=.o)

# Build target
$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $@ $(LDFLAGS)

# Compile each source file into an object file
$(SRCDIR)/%.o: $(SRCDIR)/%.cpp $(INCLUDE)/control.h
	$(CXX) $(CXXFLAGS) -c $< -o $@

.PHONY: clean all
# Clean up
clean:
	rm -f $(SRC_DIR)/*.o

# Build all
all: clean $(TARGET)

run: clean $(TARGET)
	./$(TARGET)
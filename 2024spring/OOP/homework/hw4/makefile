CXX = g++
CXXFLAGS = -std=c++11

SRCS = $(wildcard ./src/*.cpp)
EXES = $(patsubst ./src/%.cpp,./target/%,$(SRCS))

.PHONY: all clean

all: $(EXES)

$(EXES): ./target/%: ./src/%.cpp
	$(CXX) $(CXXFLAGS) $< ./include/date.cpp ./include/diary.cpp -o $@

clean:
	rm -f  $(EXES)
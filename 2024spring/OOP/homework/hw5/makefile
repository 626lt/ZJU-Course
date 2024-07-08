CXX = g++
CXXFLAGS = -std=c++17

SRCS = $(wildcard ./src/*.cpp)
EXES = $(patsubst ./src/%.cpp,./%,$(SRCS))

.PHONY: all clean

all: $(EXES)

$(EXES): ./%: ./src/%.cpp
	$(CXX) $(CXXFLAGS) $< ./include/fraction.cpp -o $@

clean:
	rm -f  $(EXES)
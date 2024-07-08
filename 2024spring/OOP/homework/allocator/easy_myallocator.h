#ifndef EASY_MYALLOCATOR_H
#define EASY_MYALLOCATOR_H
#include <cstddef>
#include <iostream>

template <class T>
class easy_MyAllocator
{
public:
    using value_type = T;
    using pointer = T*;
    using const_pointer = const T*;
    using size_type = std::size_t;
    using difference_type = std::ptrdiff_t;
    using reference = T&;
    using const_reference = const T&;
    pointer allocate(size_type n){
        // just return the memory allocated by the global operator new
        return static_cast<pointer>(::operator new(n * sizeof(T)));
    }
    void deallocate(pointer p, size_type n){
        ::operator delete(p);
    }
    size_type max_size() const{
        return std::numeric_limits<size_type>::max() / sizeof(T);
    }
};


#endif
#ifndef MY_ALLOCATOR_H
#define MY_ALLOCATOR_H
#include <cstddef>
#include <iostream>
#include <new>
#include <limits>

// memory alignment
const std::size_t MAX_BYTES = 128;
const std::size_t BOUND = 8;
const std::size_t COUNT_FREE_LISTS = MAX_BYTES / BOUND;
// our allocator
class alloc {
private:
    struct obj {
        obj *free_list_link;
    };
    // free list
    static obj *volatile free_list[COUNT_FREE_LISTS];
    // get the index of free list
    static std::size_t free_list_idx(std::size_t bytes) {
        return ((bytes) + BOUND - 1) / BOUND - 1;
    }
    // ceil up to the multiple of BOUND
    static std::size_t ceil_up(std::size_t bytes) {
        return (((bytes) + BOUND - 1) & ~(BOUND - 1));
    }
    // allocate memory
    static char *chunk_alloc(std::size_t size, int &cnt_obj) {
        char *res = (char *)malloc(size * cnt_obj);
        return res;
    }
    // refill the free list
    static void *refill(std::size_t n) {
        int cnt_obj = 20;
        char *chunk = chunk_alloc(n, cnt_obj);
        if (cnt_obj == 1) return chunk;
        // add to free list
        obj *volatile *my_free_list = free_list + free_list_idx(n);
        *my_free_list = (obj *)(chunk + n);
        // link the free list
        obj *current_obj, *next_obj = *my_free_list;
        for (int i = 1; i < cnt_obj; ++i) {
            current_obj = next_obj;
            next_obj = (obj *)((char *)next_obj + n);
            current_obj->free_list_link = (i == cnt_obj - 1) ? nullptr : next_obj;
        }
        return (void *)chunk;
    }

public:
    // allocate memory
    static void *allocate(std::size_t n) {
        if (n > MAX_BYTES) {
            return malloc(n);
        }
        // get the free list index
        obj *volatile *cur_free_list = free_list + free_list_idx(n);
        obj *res = *cur_free_list;
        // if the free list is empty, refill it
        if (res == nullptr) {
            return refill(ceil_up(n));
        }
        // move the free list
        *cur_free_list = res->free_list_link;
        return (void *)res;
    }

    static void deallocate(void *p, std::size_t n) {
        // if the size is too large, use free
        if (n > MAX_BYTES) {
            free(p);
            return;
        }
        // add to free list
        obj *q = reinterpret_cast<obj *>(p);
        obj *volatile *cur_free_list = free_list + free_list_idx(n);
        // link the free list
        q->free_list_link = *cur_free_list;
        *cur_free_list = q;
    }
};

// initialize the free list
alloc::obj *volatile alloc::free_list[COUNT_FREE_LISTS] = {nullptr};

// interface from pta
template <class T>
class MyAllocator
{
public:
    typedef void _Not_user_specialized;
    typedef T value_type;
    typedef value_type *pointer;
    typedef const value_type *const_pointer;
    typedef value_type &reference;
    typedef const value_type &const_reference;
    typedef std::size_t size_type;
    typedef ptrdiff_t difference_type;
    typedef std::true_type propagate_on_container_move_assignment;
    typedef std::true_type is_always_equal;

    MyAllocator() = default;
    pointer address(reference _Val) const noexcept { return &_Val; }
    const_pointer address(const_reference _Val) const noexcept { return &_Val; }

    // allocate memory
    pointer allocate(size_type _Count) { 
        if (_Count > size_type(-1) / sizeof(value_type)) throw std::bad_alloc();
        if (auto p = static_cast<pointer>(alloc::allocate(_Count * sizeof(value_type))))
            return p;
        throw std::bad_alloc();
    }
    // deallocate memory
    void deallocate(pointer _Ptr, size_type _Count) {
        alloc::deallocate(_Ptr, _Count);
    }

    template <class _Uty>
    void destroy(_Uty *_Ptr) {
        _Ptr->~_Uty();
    }

    template <class _Objty, class... _Types>
    void construct(_Objty *_Ptr, _Types &&... _Args) {
        ::new (const_cast<void *>(static_cast<const volatile void *>(_Ptr)))
            _Objty(std::forward<_Types>(_Args)...);
    }
};


#endif
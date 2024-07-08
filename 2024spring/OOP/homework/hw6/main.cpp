#include "vector.h"
#include <cassert>

int main() {
    // 测试默认构造函数
    Vector<int> v1;
    assert(v1.size() == 0);
    assert(v1.empty());

    // 测试带有大小参数的构造函数
    Vector<int> v2(10);
    assert(v2.size() == 10);
    assert(!v2.empty());

    // 测试拷贝构造函数
    Vector<int> v3(v2);
    assert(v3.size() == 10);
    assert(!v3.empty());

    // 测试 push_back 函数
    v1.push_back(1);
    assert(v1.size() == 1);
    assert(v1[0] == 1);

    // 测试 pop_back 函数
    v1.pop_back();
    assert(v1.size() == 0);

    // 测试 clear 函数
    v2.clear();
    assert(v2.size() == 0);
    assert(v2.empty());

    // 测试 at 函数
    try {
        v1.at(-1);
        assert(false);  // 应该抛出异常，所以如果到达这里，测试失败
    } catch (std::out_of_range const & err) {
        assert(true);  // 正确抛出异常，测试通过
    }

    // 测试扩容功能
    Vector<int> v;
    int initialSize = v.size();
    int initialCapacity = v.capacity();
    for (int i = 0; i < initialCapacity + 5; ++i) {
        v.push_back(i);
    }
    assert(v.size() == initialSize + initialCapacity + 5);
    assert(v.capacity() > initialCapacity);
    for (int i = 0; i < initialCapacity + 5; ++i) {
        assert(v[i] == v.at(i));
        assert(v[i] == i);
    }
    cout << "All tests passed!" << endl;
}
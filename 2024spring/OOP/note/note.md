# Object-Oriented Programming (using c++)

## Week1:

### Buzzwords

+ encapsulation 封装：统一的接口，是统一的整体
+ inheritance 继承
+ polymorphism 多态
+ overriding 重载，覆盖
+ interface 接口
+ cohesion 内聚：里面是完整的
+ coupling 耦合：两个东西互相关联程度 越弱越好
+ collection classes 容器类
+ template 模板
+ responsibility-driven design 责任驱动设计

### The first c++ program:

```cpp
int main(){
    int age
    cin >> age;
    cout << "Hello, World " << age << " Today " << endl;
    return 0;
}
```

`<<` means inserter(插入运算); `cout << "Hello, World!"` 结果就是 `cout` 本身
`>>` means extractor(析取运算); `cin >> age` 结果就是 `cin` 本身

### Format output

Manipulators are special functions that can be included in the I/O statement ot alter the format parameters of a stream.
+ `endl` is one of manipulators, it is used to insert a newline character and flush the stream.
+ `#include <iomanip>` is used to include the manipulators.
+ `setw(int)` is used to set the width of the field.
+ `setprecision(int)` is used to set the precision of the floating point numbers.
+ 上面二者都是用于格式化输出的。并且在使用后，会一直保持这种格式，直到下一次改变。这与c语言中的`printf`不同，`printf`是每次都要设置一次。
  
```cpp
cout << setw(10) << setprecision(2) << 123.456 << endl;
```

### string

字符串类，`#include <string>`

+ `string str; // Define variable`
+ `string str = "Hello!";`
+ `string str("Hello!");`
+ `string str{"Hello!"};` 这种形式是c++11以后才有的。

以上三种方式的初始化是等价的，这种写法不只是在string类里面，对c++11标准的所有类都适用。

#### Object

+ A `string` variable is an object of the `string` class.
+ A variable of any type in C++ is an object.

对象和之前c语言的字符串的不同：c语言字符串的本质还是char数组，这是不可以被直接赋值的，但是对于一个string对象，我们可以 `string s2 = s1` ，可以这样直接赋值。

#### Input and Output

`cin` 只能够读到空格之前的内容，如果想要读取空格之后的内容，可以使用 `getline(cin, str);`
`getline` 可以读到一整行

#### `.` 运算符

`str.length()` 返回字符串的长度，编辑器会列出这个对象可以做的操作。

#### string `+`

`string s1 = "Hello";`
`string s2 = "World";`
`string s3 = s1 + s2;` 这样就可以将两个字符串连接起来。

#### create a string

```cpp
string(const char *cp, int len);
string(const string& str, int pos);
string(const string& str, int pos, int len);
```

#### substr

`substr(int pos, int len)` 返回一个从pos开始，长度为len的字符串。

#### Alter string

```cpp
insert(size_t pos, const string& str);
erase(size_t pos = 0, size_t len = npos);
append(const string& str);
replace(size_t pos, size_t len, const string& str);
```

#### Find

`size_t find(const string& str, size_t pos = 0) const`

#### pointer to object

```cpp
string str = "Hello";
string *p = &str;
```

##### operator with pointer

+ `&` : get address
+ `ps = &str;` : ps is a pointer to str
+ `*` : get the object
  + `(*ps).size();`
+ `->` : call the function
  + `ps->size();`

需要注意的是object和pointer的区别，以及对他们的操作的结果的不同。

## Week2:

### Collection 容器

Collection objects are objects that can store an arbitrary number of other objects.可以存放任意数量的其他对象。
+ capacity 容量
  + extend, flame
+ size 现在实际存放的数量

### What is STL

+ STL: Standard Template Library
+ Part of the ISO C++ Standard Library
+ Datastructures and algorithms for c++

### C++ standard library

Library includes:
+ A pair class
+ Containers
  + vector(expandable array)
  + deque(expandable array,expands at both ends)
  + list(doubly linked)    
  + sets and maps 集合和映射
+ Basic Algorithms
  + sort
  + search
  + copy
  + remove
  + reverse
  + unique
+ Al identifiers in library are in the `std` namespace;

### vector

#### Example using vector class

```cpp
#include <iostream>
#include <vector>
using namespace std;

int main()
{
    vector<int> v;
    for(int i = 0;i < 10;i++)
    {
        v.push_back(i);
    }
    for(int i = 0;i < v.size();i++)
    {
        cout << v[i] << " ";
        cout << v.at(i) << endl;
    }
    vector<int>::iterator it;
    for(it = v.begin();it != v.end();it++)
    {
        cout << *it << " ";
    }
}
```

iterator 迭代器(枚举器)，是一个指针，指向容器中的元素。

#### Generic Classes 泛型

`vector<int> x;`
+ the type of the collection itself (here: vector) and
+ the type of the elements that we plan to store in the collection (here: int)

#### Basic Vector operations

+ Constructor
  + `vector<Elem> c;`
  + `vector<Elem> c1(c2);` 复制产生一个新的vector
+ Simple Methods
  + `v.size()`
  + `v.empty()`
  + `==,!=,<,>,<=,>=`
  + `v.swap(v2)`
+ Iterators
  + `I.begin()` // first position
  + `I.end()` // last position, the next position of end position
+ Element access
  + `v.at(index)`
  + `v[index]`
  + `v.front()` // first item
  + `v.back()` // last item
+ Add/Remove/Find
  + `v.push_back(elem)`
  + `v.pop_back()`
  + `v.insert(pos, elem)` pos实际上是一个迭代器
  + `v.erase(pos)`
  + `v.clear()`
  + `v.find(first, last, elem)` first和last是迭代器，返回值是一个迭代器

### List Class

与`vector`类似，不同的是可以push_front和pop_front

a wrong example:

```cpp
list<int> lst1;
list<int>:: iterator iter1 = lst1. begin ():
list<int>:: iterator iter2 = lst1.end(); while (iter1 < iter2) {

}
```

这里的`iter1`和`iter2`是迭代器，对于`list`作为一个双向链表，不能够使用`<`来比较，应该使用`!=`来比较。链表之间不一定存在大小关系。

### choose between sequential containers

+ use `vector` unless you have a good reason to use `list`
+ Don't use `list` or `forward_list` if your program has lots of small elements and space over matters
+ use `deque` or `vector` if the program requires random access to elements
+ use `list` or `forward_list` if the program needs to insert elements in the middle of the container
+ use `deque` if the program needs to insert elements at the beginning or end of the container,but not in the middle

!!! example

    1. Read a fixed number of words, inserting them in the container alphabetically as they are entered.(list)要求插入的时候已经是有序的，插入时排序就要求可以在中间进行插入，那么list就比较合适。
    2. Read an unknown number of words. Always insert new words at the back. Remove the next value from the front.(vector or deque)要求在后面插入，前面删除，那么vector和deque都可以。vector 更佳更轻巧
    3. Read an unknown number of integers from a file. Sort the numbers and then print them to standard output.(vector)只要求sort那不一定要在插入时就完成。

### maps

+ Maps are associative containers that store elements formed by a combination of a key value and a mapped value, following a specific order.
+ In a map, the key values are generally used to sort and uniquely identify the elements, while the mapped values store the content associated to this key.
+  The mapped values in a map can be accessed directly by their corresponding key using the bracket operator (operator []).
+  Maps are typically implemented as binary search trees.
operator [] 可以完成map的所有操作，包括插入，查找，修改。

example:

```cpp
map<long, int> root; root [4] = 2;
root[1000000] = 1000; long 1;
cin> 1;
if (root.count(l))
    cout<<root[l]
else 
    cout<<"Not perfect square";
```

`.count()` 返回的是一个bool值，如果存在就返回true，否则返回false。

### iterator

有许多种容器，内部的结构不同，但是都有一个共同的操作就是遍历，这就是迭代器的作用。
所有的容器都支持下面的操作：
+ Declaring an iterator
  + `vector<int>::iterator it;`
+ Front of the container
  + `it = v.begin();` 指向第一个元素
+ End of the container
  + `it = v.end();` 指向最后一个元素的下一个位置
+ Can increment and decrement
  + `it++;`
  + `it--;`
+ Can be dereferenced
  + `*it = 10;`
+ Algorithms
  + `List<int> L; Vector<int> V;`
  + `copy(L.begin(), L.end(), V.begin()); `

#### for-each loop

```cpp
for(type var : container)
{
    // do something
}
```

#### pitfalls

+ `if(foo["bob"] == 1)`这样的操作其实隐式地写入了一个元素，这样的操作是不好的不可控的。
+ 为了检查有没有这样的元素，我们可以通过`count()`来检查，如果存在就可以直接使用`[]`来访问，否则就不要访问。

+ 如果要判断`list`是否为空，使用`empty()`，而不要使用`size() == 0`，因为`size()`是一个O(n)的操作，而`empty()`是一个O(1)的操作。

!!! example
    ```cpp
    list<int> L;
    list<int>::iterator it = L.begin();
    L.erase(it);
    ++it; // 这样的操作是错误的，因为`it`已经被删除
    it = L.erase(it); // 这样的操作是正确的，利用返回值
    ```

## Week3:

写头文件的时候一定要按照标准去进行保护，不然会出现多个文件include同一个头文件的时候会出现重复定义的问题。

### struct
把函数放到结构体中：

```cpp
struct Point
{
    int x, y;
    void print();
    void move(int dx, int dy);
};
void Point::print()
{
    cout << x << " " << y << endl;
}
void Point::move(int dx, int dy)
{
    x += dx;
    y += dy;
}
```

### `::`resolver 解析器

用来表达谁是谁的
+ `<Class name>::<function name>`
+ `::<function name>` 表明是全局的，或者自由的

在成员函数里面，变量默认是成员变量，加上`::`可以访问全局变量。默认是离得最近的，如果参数和成员变量同名，那么就会优先访问参数。这时候需要用`this->`来访问成员变量。

### `this`: the hidden parameter

+ `this` is a hidden parameter in all member functions, with the type of a pointer to the class type.


![alt text](image.png)

### Definition of a class

+ In C++, separated `.h` and `.cpp` files are used to define a class.
+ Class declaration and prototypes in that class are in the header file `.h`.
+ All the bodies of the functions are in the `.cpp` file.

+ A `.cpp` file is a compile unit
+ only declarations are allowed to be in the `.h` file
  + extern variables
  + function prototypes
  + class/struct declarations

Tips for header
+ One class declaration per header file
+ Associated with one source file in the same prefix of the file name
+ The contents of a header file is surrounded with `#ifndef` `#define` `#endif` to prevent multiple inclusion

### Initialization and Clean-Up

#### Guaranteed initialization with the constructor

+ 使用构造函数来初始化对象，这样可以保证对象的初始化。构造函数是编译器在创建对象的时候自动调用的，在一切之前调用。
+ 构造函数的名字和类名相同，没有返回值，可以有参数。

!!! example

    ```cpp
      class Point
      {
      public:
          Point(int xx = 0, int yy = 0) : x(xx), y(yy) {}
          void print();
          void move(int dx, int dy);
      private:
          int x, y;
      };
    ```
    对这个类而言，构造函数就是Point(int xx = 0, int yy = 0) : x(xx), y(yy) {}，这个函数在创建对象的时候自动调用。 

+ 初始化还可以通过in place initialization来完成，这样的初始化是在对象创建的时候完成的。注意初始化和赋值是不同的，初始化是在对象创建的时候完成的，赋值是在对象创建之后完成的。在这里，括号里面的是赋值，冒号后面的是初始化。

```cpp
struct Point
{
  int x = 0, y = 0;
};
```

+ 或者通过`initializer list`来完成初始化。

```cpp
struct Point
{
  int x, y;
  Point(int xx, int yy) : x(xx), y(yy) {}
};
```

+ 如果且仅在没有定义构造函数的时候，那么编译器会自动定义一个默认的构造函数，这个构造函数不做任何事情。
+ 如果定义了构造函数，那么就一定要按照构造函数的方式来初始化对象，比如给定参数后，就不能再使用`Point p;`这样的方式来初始化对象了。


#### Clean-up with the destructor

+ 析构函数是在对象被销毁的时候自动调用的，用来清理对象。
+ 析构函数的名字和类名相同，前面加上`~`，没有返回值，没有参数。
+ 对象被销毁涉及到对象的生命周期，在作用域结束的时候，对象就会被销毁。
+ 析构函数调用的唯一证据是围绕对象的作用域的右括号。

“先构造后析构”是c++的一个重要特性，这样可以保证对象的生命周期。因为构造可能存在依赖关系，所以析构的顺序和构造的顺序是相反的。

## Week4: Inside object

### Access Control

+ `public` : accessible to all
+ `private` : accessible only to member functions and friends
+ `protected` : accessible to member functions, friends, and derived classes 子类可以访问

+ `friend` : 友元函数，可以访问类的私有成员，但是不是类的成员函数。可以将全局函数声明为友元，也可以将另一个类的成员函数，甚至整个类声明为友元。
  + 授权别人访问自己

#### Class vs Struct

+ Class 默认是private的，而struct默认是public的。只有这一个区别。这是为了跟c语言兼容。

### Where are the objects?

#### Local objects

+ Local variables are defined inside a method, have a scope limited to the method to which they belong.
+ A local variable of the same name as a field will prevent the field being accessed from within a method.

#### Fields 字段，类中的成员变量

+ Fields are defined outside constructors and methods but inside a class.
+ Fields are used to store data that persists throughout the life of an object. As such, they maintain the current state of an object.They have a lifetime that lasts as long as their object lasts.
+ Fields have class scope: their accessibility extends throughout the whole class, and so they can be used within any of the constructors or methods of the class in which they are defined.

#### Global objects

+ 全局对象的存在使得`main()`之前已经有构造函数被调用，而且这个全局变量构造的顺序由书写的顺序决定（单一编译单元）
+ 如果存在两个编译单元，那么这两个编译单元的全局变量的构造顺序是不确定的。这是由编译时刻的命令行所决定的。
+ 因此，需要避免全局变量之间的依赖关系。我们尽量避免使用全局变量。
+ Put static object definitions in a single file in correct order.

#### Static 

+ In C++, don't use static except inside functions and classes
+ Don't use static to restrict access 
![alt text](image-1.png)
前面两种不再使用，已经过时了
+ `static local variable` : 本地静态变量，意思是具有持久的存储，但是只能在函数内部访问，但并不是函数作用域结束后就会被销毁，而是在整个程序结束后才会被销毁。他的实质是一个全局变量，存储在全局数据区，只是作用域被限制在函数内部。

**Static applied to objects**

+ Value is remembered for entire program
+ Constructor called at-most once 最多一次
+ 但是要注意，这个初始化是在第一次调用的时候，而不是在程序开始的时候。如果函数没有被调用，那么这个变量就不会被初始化。相应的没有构造也就没有析构。

||Scope|life-time|
|---|---|---|
|local |{}|{}|
|global|global|global|
|static local|{}|global|
|member(private)|in-class|object|
|static member|in-class|global|
|malloc|passed in-out|from malloc to free|

声明不产生任何代码，只是告诉编译器有这个东西，但是不会分配内存。
定义才会分配内存。

对于静态成员变量，在使用时除了要在`.h`里面进行声明，还要在对应的`.cpp`文件中进行定义。对于静态成员变量，所有的对象共享一个变量，所以这个变量只会被初始化一次。并且所有的对象访问的都是同一个变量。这与他本质是个全局变量有关。
`int Point::count = 0;`

静态成员函数与非静态成员函数的区别在于
+ 静态成员函数没有this指针，因为他不是针对某个对象的，而是针对整个类的。
+ 静态成员函数不能访问非静态成员变量，因为他没有this指针，所以不能访问对象的成员变量。只能访问静态成员变量。不能调用非静态成员函数，只能调用静态成员函数。
+ 在`.cpp`里面没有`static`关键字。不能被动态绑定。

我们为什么需要这样的函数呢？
+ 因为这样的函数是独立于对象的，可以直接通过类名来调用，而不需要创建对象。
+ 这样的函数可以用来初始化静态成员变量，或者用来进行一些独立于对象的操作。表达一个持久存在的变量，但不是全局变量。

如何使用静态成员？
`<class name>::<static member>`
`<object variable>.<static member>`

#### Reference 引用

改变访问变量的形式，引用就是给变量起别名
```cpp
char c; // a character
char *p = &c; // a pointer to c
char &r = c; // a reference to c
```
+ Local or global variables
  + `type& refname = name`
  + 对ordinary variables, the initial value is required
+ 对参数列表或者成员函数
  + `type& refname`
  + Binding defined by caller or constructor

Reference 就是给一个已经存在的变量起一个名字
```cpp
int x = 47;
int &y = x;
cout << y; // 47
y = 18;
cout << x; // 18
```
一旦一个引用成为一个变量的别名，他就不能够再指向其他变量了，这是不允许的。引用是一个常量指针，一旦指向了一个变量，就不能够再指向其他变量了。

Rules of reference
+ A reference must be initialized when it is declared
+ Initialization establishes the binding
+ In declarations
```cpp
  int x = 3;
  int &y = x;
  const int &z = x;
```
+  As a function arugment
```cpp
  void f(int &x);
  f(y); // initialize when function is called
```
这里引用就是一个别名，所以在函数调用的时候，就是将这个别名传递给函数，这样函数就可以直接操作这个变量了。在函数里面对这个变量的操作就是对原变量的操作。引用的目标一定会有一个地址。

#### Pointer vs Reference

+ Reference
  + cannot be null
  + are dependent on an existing variable, they are an alias for an variable
  + can't change to a new "address" location
+ Pointer
  + can be null
  + pointer is independent of existing objects
  + can change to a new "address" location

+ No Reference to a Reference
+ No pointer to a Reference
+ Reference to a Pointer is ok
+ No arrays of References

#### Left value and Right value

+ Left-value can be simply regarded as value that can be used at the left of assignment:
  + variables, references
  + Results of operator `*`,`[]`,`.` and `->`
+ Right-value are values can be use at the right hand of the assignment
  + Literals
  + expressions
+ A reference parameter can take left-value only —> reference is the alias of a left-value 
+ The passing of an argument is initializing of the parameter

一般引用只能接收左值，因此产生了一个对偶的概念，右值引用

```cpp
int x = 20;
int&& rx = x * 2;
int y = rx + 2;
rx = 100;
// Once a right-value reference is initialized,
// this variable becomes a left-value that can be assigned 
int&& rx = z; // error
// 无法将右值引用绑定到左值
```

如果函数参数是如下形式：
```cpp
void fun(const int &x);
```
这表示这个x不可以被修改，这个时候就可以传递一个右值给这个函数，因为这个右值是一个常量，不会被修改。
为什么要求传递引用的不可以传递一个右值，是因为这个右值无法被修改，但是如果传递一个左值，那么这个左值是可以被修改的。那如果这个引用是const的，那么既然保证不会被修改，那么就可以传递一个右值。

#### Constant

声明就是这个变量不可以被修改，这样可以保证这个变量不会被修改，这样可以保证程序的安全性。

![alt text](image-2.png)
上面这个例子中，编译器在编译下面那段代码时并不知道bufsize的具体值，只知道有这么一个常量变量，在链接的时候就能够从原来那个文件中找到这个变量的值。

![alt text](image-3.png)
但并不是说这个常量一定要事先定义，也可以在使用的时候定义，只要保证这个常量在使用之前就被定义就可以了。

对于指针的情况比较复杂：
```cpp  
char * const p = "hello"; // p is const, p所指向的地址不可以被修改
*p = 'H';  // OK
p++; // error

const char * p = "hello"; // *p is const, p所指向的内容不可以被修改
*p = 'H'; // error
p++; // OK
```

如何判断，根据const跟 * 的位置关系如果const在 * 的左边，那么就是指向的内容不可以被修改，如果在右边，那么就是指向的地址不可以被修改。
![alt text](image-4.png)
const指针指向内容不能被修改的意思是不能够通过这个指针来修改这个内容，但是可以通过其他的方式来修改这个内容。
对于一个返回值const实际上没有什么影响。

为了给函数传递参数，如果传递一整个object的开销是较大的，因此考虑传递地址，但这会导致这个地址被修改，因此可以使用const来保证这个地址不会被修改。当传递地址时应该确保这个地址是const的。

Constant Objects 说明这个对象的成员变量不可以被修改。
那么能修改成员变量的函数是成员函数，如何保证这个函数不会修改成员变量呢？
可以在函数后面加上const，这样就可以保证这个函数不会修改成员变量。这是告诉编译器这个函数不会修改成员变量，这样编译器就会在编译的时候检查这个函数是否真的不会修改成员变量。这个const实际上是加在 *this指针上的，因此不能够被修改。这个const要在声明和定义的地方都加上。否则编译器会认为这是两个不同的函数，这是函数重载的原因。

对于类中的一个const成员变量，只能进行初始化，必须在初始化列表中完成，不能在函数体中进行赋值。

![alt text](image-5.png)

#### new & delete
动态分配内存
+ `new` : 分配内存
  + `new int;`
  + `new int[10];`
+ `delete` : 释放内存
  + `delete p;`
  + `delete[] p;`

申请的时候带`[]`，释放的时候也要带`[]`。

如果使用的是一个类的话，那么初始化这个类的时候一定要调用构造函数，也就是如果不存在默认的构造函数的话，我们需要传递参数给构造函数。如果我们要构造多个对象的话，那么可以通过`{}`来进行值的说明。

```cpp
Point *p = new point[3]{1,2,3};
```

delete 对象是先做析构，然后再检查空间是否正确，然后再释放空间。
带`[]`的会执行所有的析构，但如果不带`[]`的话，只会执行第一个对象的析构。这两者收回的空间是一样多的。因为编译器可以从记录分配空间的地方获取空间的大小，从而知道要收回多少空间。

![alt text](image-6.png)

tips:
![alt text](image-7.png)

## Week5: Inside Class

### Function overloading

函数名一样，但是参数不一样，这样就可以实现函数重载。这样可以实现多态。编译器会根据参数的类型和个数来选择调用哪一个函数。

如果遇到了自动类型转换`auto cast`就会发生error，因为编译器不知道调用哪一个函数。

带const也是可以重载的。相当于
```cpp
int f(const A* this); // f() const
int f(A* this); // f()
```

### Default Arguments

很多构造函数需要多种重载，有些重载可能只有一个参数，有些重载有多个参数。所有成员变量的初始化方法是一样的，所以可以使用代理构造函数(Delegating Ctor)，这样可以减少代码的重复。代理构造函数的使用如下：

```cpp
class class_c
{
public:
  int max;
  int min;
  int middle;
  class_c(int my_max){
    max = my_max > 0 ? my_max : 10;
  }
  class_c(int my_max, int my_min) : class_c(my_max){
    min = my_min > 0 && my_min < max ? my_min : 1;
  }
  class_c(int my_max, int my_min, int my_middle) : class_c(my_max, my_min){
    middle = my_middle > min && my_middle < max ? my_middle : 5;
  }
};
```

这样就可以减少代码的重复，将初始化的工作交给一个函数来完成。实现了代码的重用。

+ 默认参数值
  + 如果调用时没有提供的话，就会使用默认值。
  + 在声明的时候给出默认值，不能放在定义里。在定义的时候就是普通函数，声明的时候可以插入默认值。
  + 一定要从右往左给出默认值。
  + 默认构造函数也可以有默认参数值，但是只能有一个默认构造函数。

### Inline Function 内联函数

+ 函数调用的额外开销 overhead
  + 函数调用的开销是很大的，因为要保存现场，跳转，返回等等。

+ Inline函数作用是将函数内容插入到调用的地方。注意只是插入，因此在编译时候，编译器看到Inline函数的声明不会实际产生代码。而c++是一个cpp一个cpp进行编译的，所以如果在另一个cpp文件中调用这个函数，就会出现链接错误。（如果是把.h和.cpp分开的话）
+ Inline会做类型检查，marco不会做类型检查。
+ Inline不会生成实际的函数调用，只是把函数的内容插入到调用的地方。

An inline function definition may not generate any code in obj file.
在定义和声明的时候都要加上`inline`关键字。
这句话是说，内联函数的定义可能不会生成代码，因此会产生链接错误。

trade-off是代码的大小和速度，内联函数会增加代码的大小，但是会减少函数调用的开销。

即便你声明是inline，但是编译器不一定会将其内联，编译器会根据函数的复杂度（大于二十行）来决定是否内联。比如递归函数就不会被内联，因为递归函数就是不断的开辟栈空间，这样就不适合内联。Inline的本质是替换，如果函数太大，那么替换的开销就会很大。

Any function you define inside a class declaration is automatically an inline.

Inline functions的定义可以放在头文件外面，但是它一定要在它可能被调用的地方之前。

如果一个函数没有修改成员变量，那么就应该将这个函数声明为`const`。

key word:use 代码重用

## Week6: Composition 组合

composition做的事情是把一个类的对象作为另一个类的成员变量，这样就可以实现代码的重用。需要注意的是如果一个成员变量是对象的话，在这个类被初始化时，他的构造函数会自动调用成员变量的构造函数，如果成员变量的构造函数有参数的话，那么就需要在初始化列表中进行初始化。

例：

```cpp
class A{
  int i = 0;
};

class B{
  int j = 1;
};

class C{
  A a;
  B b;
};

int main(){
  A a;
  B b;
  C c;
  C* p = &c;
  int* q = (int*)p;
  cout << *q << " " << *(q+1) <<endl;// 0 1
}
```

初始化列表只是表明哪些东西需要被传入，但不代表插入顺序，插入顺序是由类的定义决定的，仍然是书写的顺序。

一个函数就应该负责一个事情。应当将功能分离，将功能分散到不同的函数中，这样可以提高代码的可读性和可维护性。

## Week7: Inheritance 继承

继承可以提高代码重用率，继承的子类拥有父类的所有成员变量和成员函数，也就是接口。子类可以重写父类的成员函数，也可以增加新的成员变量和成员函数。

继承的写法如下：

```cpp
class CD: public Item{
  ...
};
```

继承是基于已有的类去构造新的类
+ Base class 基类；Derived class 派生类
+ Super class 超类；Sub class 子类
+ Parent class 父类；Child class 子类

在继承中到底发生了什么：子类可以得到父类的一切。在内存里，可以看做子类里面有一个父类的对象，而且会出现在子类对象的最前面

权限控制如下：
![alt text](image-8.png)

初始化列表中可以放：父类的构造函数，成员变量的初始化，代理构造函数

如果在子类的初始化列表中没有对父类的构造函数调用，就表明要调用父类的默认构造函数。

name hiding:子类的成员函数会隐藏父类的同名函数，如果想要调用父类的同名函数，可以使用`::`来调用。需要说明使用范围。如果子类重新定义了其中一个，那么父类中所有的都会被隐藏。

可以用子类的对象构造父类，可以把子类的对象交给父类的引用；因为子类本质上是父类加上子类自己的东西；但是如果用父类的对象去构造子类的对象是不可以的，因为父类的对象里面的东西不足以构造子类的对象

## Week8: Polymorphism 多态

### Subclassess and subtyping

+ Classes define types
+ Subclasses define subtypes
+ Objects of subclasses can be used where objects of supertypes are required.

可以把任何一个子类的指针交给父类的指针；那么这个子类实际上还是他，多的东西并没有被丢掉，如果是用子类来初始化一个父类的对象，那么多的东西就真的被丢掉了。

### casting

casting是类型转换
up-casting是造型：并不改变实质，只是换个类型来看

virtual关键字：告诉编译器，父类中的这个函数将来在子类中会有新的实现，当一个子类的对象被up-casting到父类后，如果没有virtual来限定的话，那么就应该调用父类的函数和成员变量。如果加了virtual后，就说明应当按照子类的实现来调用。

之所以需要这样做是因为许多子类都需要一个共有的函数，这时候应当在父类中声明这个函数然后在子类中重新实现；而对调用的接口而言，我们期待只需要传入一个父类的指针（这时候发生up-casting）即可，此时virtual就可以保证在调用时使用的是子类实现而不是父类的。此时这个父类指针是一个多态变量。

一个多态变量永远有两个类型：
+ 静态类型：是声明时的类型
+ 动态类型：实际指向的类型

决定调用哪个类型叫做binding，绑定；只有满足下面两个条件时才能做动态绑定
+ 指针和引用是多态的 polymorphic var
+ virtual function

通过对象来使用的一定是静态绑定。编译器在编译检查时会根据静态绑定进行检查。

### Virtual function

+ Non-virtual function
  + 非虚函数，静态绑定，编译时就确定了调用的函数- faster
+ virtual function
  + 可以在子类中被重载overridden
  + 对象携带了一组虚函数
  + 编译器检查封装好的虚函数并动态调用正确的函数
  + 如果编译器在编译时刻知道调用的是哪个函数，那么就会使用静态绑定，否则就会使用动态绑定。

一旦一个成员内有一个虚函数，那么这个类就会默认存在一个指针，vptr，指向一个vtable，vtable里面有这个类的所有虚函数指针。所以对象的size应当加上指针的大小。vptr是在构造函数中初始化的，而一个子类在构造时是先调用父类的构造函数。

![alt text](image-10.png)

delete 是一个运算符，后面跟的是算子，`delete a,b,c`是错误的，`,`运算符的结果是`,`右边的，因此这样的写法是错误的。

析构一般都要是虚函数，因为如果不是虚函数，那么就会发生内存泄漏，因为只会调用父类的析构函数，而不会调用子类的析构函数。我们有时会希望用子类的指针来初始化父类的指针（upcast），那么如果不是virtual的话就会导致子类的析构无法调用。

overriding
+ Superclass and subclass define methods with the same signature
+ Each class has access to the fields of its class
+ Superclass satisfies static type check
+ Subclass method is called at runtime - it overrides the superclass version.
+ 我们也可以通过`::`来调用父类的函数

返回类型：
假设 D 是 B 的子类，那么 D::f()的返回值可以是B::f()的返回值的子类，这对指针和引用类型成立

![alt text](image-9.png)

Abstract base classes
+  An abstract base class has pure virtual functions
   +   Only interface defined
   +   No function body given
+    Abstract base classes cannot be instantiated
     +    Must derive a new class (or classes)
     +    Derived classes must implement the pure virtual functions

![alt text](image-11.png)
 
## Week9: Copy and move

不小心发生拷贝，或者说不是主动去做，可以去做的时候

拷贝构造函数 copy constructor
+ Copying is implemented by the copy constructor
+ has unique signature
  + `class_name(const class_name &)`
  + `T::T(const T&)`
+ Call-by-reference is used for the explicit argument
+ C++ builds a copy ctor for you fi you don't provide one!
  +  Copies each member variable
     +   Good for numbers, objects, arrays
         +    Copies each pointer，这是不好的，如果发生修改那么对任何指向这个地方的指针都有危害

拷贝构造函数在何时调用？
+ 在作为函数的输入值被调用时
+ 在初始化的时候
+ 在函数返回的时候

编译器可能会优化这些拷贝构造

构造和赋值：
+ 构造是在对象创建的时候调用的
+ 赋值是在对象已经存在的时候调用的，赋值可以多次调用，而构造只能调用一次
+ 每个对象都应该被析构一次

对于拷贝函数的指导是：
+ In general, be explicit
  + Create your own copy ctor -- don't rely on the default
+ If you don't need one declare a private copy ctor
  + prevents creation of a default copy constructor
  + generates a compiler error fi try to pass-by-value - don't need a defintion

### 函数的参数和返回值的类型

对于类的对象，可以传递对象本身，也可以传指针和引用，前者会导致拷贝构造函数的调用，后者是相对安全和高效的。
对于返回值，如果返回的是对象吗，那么一个新的对象会在返回时被创造；有的时候我们很难去决定一个指针要不要被delete，因为可能在上层的调用中仍然用到这个指针。为此，我们最好不在函数内部new一个指针并且返回这个指针，而是在上层传入一个指针，再把他返回去，这样就可以保证new和delete在同一个层次上。

![alt text](image-12.png)

### 移动拷贝构造

参数为右值引用的拷贝构造函数：做的事情是将新的指针指向原来的对象的位置，然后把原来的指针指向nullptr。实现移动。

对象初始化的形式：

```cpp
// 小括号初始化
string str("hello");

// 等号初始化
string str = "hello";

// 大括号初始化
struct student{
  char *name;
  int age;
};
student s ={"dable.tv",20};
student array[] = {{"dable.tv",20},{"tommy",21}};

// 列表初始化
class Test{
  int a;
  int b;
public:
  Test(int i, int j);
};
Test t{0,0}; // c++11 相当于Test t(0,0);
Test *pT = new Test{0,0}; // c++11 相当于Test *pT = new Test(0,0);
int *a = new int[3]{1,2,3};

// 容器初始化
vector<string> vs={ "first","second","third"};
map<string,int> m = {{"first",1},{"second",2}};
```

![alt text](image-13.png)

+ using function
在子类中using父类的function就可以调用父类的函数

## Week10: Overloaded operator

Overload的条件必须是参数表不一样，要么数量不一样，要么类型不一样，而且类型不会有歧义的。

可以重载的，不可以重载的；

`operator *(...)`

作为成员函数时，存在一个隐式的一个参量，就是这个对象本身，这个对象就是`*this`。

如果是一个全局的操作符，需要在类内进行friend声明，这样就可以访问类的私有成员。

那么什么时候作为成员什么时候作为全局呢？

+ Unary应当作为成员函数（单目）
+ `= () [] -> ->*`应当作为成员函数
+ assignments must be members
+ 所有其他的双目操作符应当作为全局函数

参数传递：

+ 如果 read-only，那么传递`const`引用
+ 对成员函数用`const`如果不会改变类的状态（bool,+,-.etc）
+ for global functions, if the left-hand side changes pass as a reference (assignment operators)

返回值：
+ Select the return type depending on the expected meaning of the operator.返回作是否可写
+ For operator+ you need to generate a new object. Return as a const object so the result cannot be modified as an Ivalue.

Copy and move assignment operators

explicit 只能构造，不能类型转换(赋值)

## Week11: template 模板

+ Function template
+ Class template

用来制造类或制造函数
`template<typename T>`

模板是声明，不调用用到模板的函数时，就不会产生代码

### 类模板

## Week12: Exception 异常

类型检查可以在尽早期检查出错误

throw 抛出对象本身

## Week13：Smart Pointer 智能指针


四种类型转换
+ static_cast
  + 基本类型之间的转换（int转double）
  + 类层次结构中，父类指针/引用和子类指针/引用之间的转换
  + 将void指针转换为目标类型指针
+ dynamic_cast
  + 主要用于多态类型转换，可以在运行时检查类型安全，将父类转换为子类
+ const_cast
  + 可以去除const属性
+ reinterpret_cast
  + 进行低级别的、几乎没有类型检查的转换
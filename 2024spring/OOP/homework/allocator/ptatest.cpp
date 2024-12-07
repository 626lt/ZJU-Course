#include <iostream>
#include <random>
#include <vector>
#include "myallocator.h"
#include "easy_myallocator.h"
// include header of your allocator here
// template<class T>
// using myallocator = std::allocator<T>; // replace the std::allocator with your allocator
// using myallocator = MyAllocator<T>;
using Point2D = std::pair<int, int>;

const int TestSize = 10000;
const int PickSize = 1000;


template <template <class> class myallocator>
class tester
{
  public:
  void main()
  {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(1, TestSize);

    // vector creation
    using IntVec = std::vector<int, myallocator<int>>;
    std::vector<IntVec, myallocator<IntVec>> vecints(TestSize);
    for (int i = 0; i < TestSize; i++)
      vecints[i].resize(dis(gen));

    using PointVec = std::vector<Point2D, myallocator<Point2D>>;
    std::vector<PointVec, myallocator<PointVec>> vecpts(TestSize);
    for (int i = 0; i < TestSize; i++)
      vecpts[i].resize(dis(gen));

    // vector resize
    for (int i = 0; i < PickSize; i++)
    {
      int idx = dis(gen) - 1;
      int size = dis(gen);
      vecints[idx].resize(size);
      vecpts[idx].resize(size);
    }

    // vector element assignment
    {
      int val = 10;
      int idx1 = dis(gen) - 1;
      int idx2 = vecints[idx1].size() / 2;
      vecints[idx1][idx2] = val;
      if (vecints[idx1][idx2] == val)
        std::cout << "correct assignment in vecints: " << idx1 << std::endl;
      else
        std::cout << "incorrect assignment in vecints: " << idx1 << std::endl;
    }
    {
      Point2D val(11, 15);
      int idx1 = dis(gen) - 1;
      int idx2 = vecpts[idx1].size() / 2;
      vecpts[idx1][idx2] = val;
      if (vecpts[idx1][idx2] == val)
        std::cout << "correct assignment in vecpts: " << idx1 << std::endl;
      else
        std::cout << "incorrect assignment in vecpts: " << idx1 << std::endl;
    }
    
  }
};

int main(){
  clock_t start, end;
  tester<std::allocator> test1;
  start = clock();
  test1.main();
  end = clock();
  std::cout << "Time for std::allocator " << (double)(end - start) / CLOCKS_PER_SEC << std::endl;

  tester<easy_MyAllocator> test2;
  start = clock();
  test2.main();
  end = clock();
  std::cout << "Time for Myallocator without memory_pool " << (double)(end - start) / CLOCKS_PER_SEC << std::endl;
  
  tester<MyAllocator> test3;
  start = clock();
  test3.main();
  end = clock();
  std::cout << "Time for MyAllocator: " << (double)(end - start) / CLOCKS_PER_SEC << std::endl;
}
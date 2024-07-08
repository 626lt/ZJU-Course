# 并行算法

## Parallel Randomized Access Machine (PRAM)

所有处理器 shared memory

pardo: 同步执行

解决冲突：

- Exclusive Read Exclusive Write (EREW)
  - 不能在同一个位置读写数据
- Concurrent Read Exclusive Write (CREW)
  - 可以在同一个位置读，但不能写
- Concurrent Read Concurrent Write (CRCW)
- Arbitrary rule 任意规则
- Better: priority rule 优先度规则
- Common rule: check if try to write different data into the same position

Example: The summation problem
Input: A(1),A(2),...,A(n)
Output: B(1) = A(1) + A(2) + ... + A(n)

PRAM model
```
for Pi, 1 <= i <= n pardo
  B(0,i) := A(i)
  for h = 1 to log n do
    for Pi, if(1 <= i <= n/2^h) pardo
      B(h,i) := B(h - 1,2i - 1) + B(h - 1,2i)
      else stay idle
  for i = 1:output B(logn,1);for i > 1: stay idle
```

Work-Depth Presentation
```
for Pi, 1 <= i <= n pardo
  B(0,i) := A(i)
  for h = 1 to log n do
    for Pi, 1 <= i <= n/2^h pardo
      B(h,i) := B(h - 1,2i - 1) + B(h - 1,2i)
  for i = 1:output B(logn,1)
```
对没用到的不设置状态，不用的处理器保持空闲

Measure the performance
+ Work load-total number of operations: W(n)
+ Worst-case running time: T(n)
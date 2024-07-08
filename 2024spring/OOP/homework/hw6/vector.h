#ifndef VECTOR_H
#define VECTOR_H
#include <iostream> 
using namespace std;
template <class T>
class Vector {
public:
  Vector();                      // creates an empty vector
  Vector(int size);              // creates a vector for holding 'size' elements
  Vector(const Vector& r);       // the copy ctor
  ~Vector();                     // destructs the vector 
  T& operator[](int index);      // accesses the specified element without bounds checking
  T& at(int index);              // accesses the specified element, throws an exception of
                                 // type 'std::out_of_range' when index <0 or >=m_nSize
  int size() const;              // return the size of the container
  int capacity() const;          // return the capacity of the container
  void push_back(const T& x);    // adds an element to the end 
  void pop_back();                // drops the last element
  void clear();                  // clears the contents
  bool empty() const;            // checks whether the container is empty 
private:
  void inflate();                // expand the storage of the container to a new capacity,
                                 // e.g. 2*m_nCapacity
  T *m_pElements;                // pointer to the dynamically allocated storage
  int m_nSize;                   // the number of elements in the container
  int m_nCapacity;               // the total number of elements that can be held in the
                                 // allocated storage
};
// creates an empty vector
template <class T>
Vector<T>::Vector() {
  m_pElements = NULL;
  m_nSize = 0;
  m_nCapacity = 0;
}
// creates a vector for holding 'size' elements
template <class T>
Vector<T>::Vector(int size) {
  m_pElements = new T[size];
  m_nSize = size;
  m_nCapacity = size;
}
// the copy ctor
template <class T>
Vector<T>::Vector(const Vector& r) {
  m_pElements = new T[r.m_nCapacity];
  m_nSize = r.m_nSize;
  m_nCapacity = r.m_nCapacity;
  for (int i = 0; i < m_nSize; i++) {
    m_pElements[i] = r.m_pElements[i];
  }
}
// destructs the vector
template <class T>
Vector<T>::~Vector() {
  delete[] m_pElements; 
}
// accesses the specified element without bounds checking
template <class T>
T& Vector<T>::operator[](int index) {
  return m_pElements[index];
}
// accesses the specified element, throws an exception of type 'std::out_of_range' when index <0 or >=m_nSize
template <class T>
T& Vector<T>::at(int index) {
  if(index < 0 || index >= this->m_nSize)
    throw std::out_of_range("Out of range");
  return m_pElements[index];
}
// return the size of the container
template <class T>
int Vector<T>::size() const {
  return m_nSize;
}
// return the capacity of the container
template <class T>
int Vector<T>::capacity() const {
  return m_nCapacity;
}
// adds an element to the end
template <class T>
void Vector<T>::push_back(const T& x) {
  if(m_nSize == m_nCapacity) {
    inflate();
  }
  m_pElements[m_nSize] = x;
  m_nSize++;
}
// drops the last element
template <class T>
void Vector<T>::pop_back() {
  m_nSize--;
}
// clears the contents
template <class T>
void Vector<T>::clear() {
  m_nSize = 0;
}
// checks whether the container is empty
template <class T>
bool Vector<T>::empty() const {
  return m_nSize == 0;
}
// expand the storage of the container to a new capacity, e.g. 2*m_nCapacity
template <class T>
void Vector<T>::inflate() {
  if(m_nCapacity == 0) { // if the capacity is 0, set it to 1
    m_nCapacity = 1;
  }
  T *p = new T[m_nCapacity * 2];// create a new array with double the capacity
  for (int i = 0; i < m_nSize; i++) {
    p[i] = m_pElements[i];
  }
  delete[] m_pElements;
  m_pElements = p;
  m_nCapacity *= 2;
}
#endif
#include "vector.h"

template <class T>
Vector<T>::Vector() {
  m_pElements = NULL;
  m_nSize = 0;
  m_nCapacity = 0;
}

template <class T>
Vector<T>::Vector(int size) {
  m_pElements = new T[size];
  m_nSize = 0;
  m_nCapacity = size;
}

template <class T>
Vector<T>::Vector(const Vector& r) {
  m_pElements = new T[r.m_nCapacity];
  m_nSize = r.m_nSize;
  m_nCapacity = r.m_nCapacity;
  for (int i = 0; i < m_nSize; i++) {
    m_pElements[i] = r.m_pElements[i];
  }
}

template <class T>
Vector<T>::~Vector() {
  delete[] m_pElements; 
}

template <class T>
T& Vector<T>::operator[](int index) {
  return m_pElements[index];
}

template <class T>
T& Vector<T>::at(int index) {
  if(index < 0 || index >= this->m_nSize)
    throw std::out_of_range("Out of range");
  return m_pElements[index];
}
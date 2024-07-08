#include <iostream>
using namespace std;

class Sample{
    friend long fun(Sample s);  
public:
    Sample(long a)
    { 
        x = a;
    }    
private:
    long x; 
};     
long fun(Sample s)
{
    if (s.x < 2) return 1; 
    return s.x * fun(Sample(s.x-1));  
}
int main()
{
    int sum = 0; 
    for(int i=0;i<6;i++)
    {
       sum += fun(Sample(i));
    }
    cout << sum;
    return 0;
}
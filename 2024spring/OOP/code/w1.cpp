#include <iostream>
#include <vector>
using namespace std;

#include <iostream>
using namespace std;
class CAT
{     public:
           CAT();
           CAT(const CAT&);
          ~CAT();
          int GetAge() const { return *itsAge; }
          void SetAge(int age){ *itsAge=age; }
      protected:
          int* itsAge;
};
CAT::CAT()
{    itsAge=new int;
     *itsAge =5;
}
CAT::CAT(const CAT& c)
{
    this->itsAge = new int; 
    *(this->itsAge) = *(c.itsAge); 
}
CAT::~CAT()
{     delete itsAge;   }
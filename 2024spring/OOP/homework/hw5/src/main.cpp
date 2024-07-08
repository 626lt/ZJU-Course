#include "../include/fraction.h"

int main()
{
    Fraction f, f3, f4;
    // test Ctor takes two integers as parameters and copy Ctor
    Fraction f1(1, 5);
    Fraction f2(f1);
    cout << "f1: " << f1 << endl;
    cout << "f2: " << f2 << endl;
    cout << "input f3 = ";
    cin >> f3;
    cout << "input f4 = ";
    cin >> f4;
    // test operator+
    cout << "f3 + f4: " << f3 + f4 << endl;
    // test operator-
    cout << "f3 - f4 : " << f3 - f4 << endl;
    // test operator*
    cout << "f3 * f4 : " << f3 * f4 << endl;
    // test operator/
    cout << "f3 / f4 : " << f3 / f4 << endl;
    // test operator<
    cout << "f3 < f4 : " << (f3 < f4) << endl;
    // test operator<=
    cout << "f3 <= f4 : " << (f3 <= f4) << endl;
    // test operator==
    cout << "f3 == f4 : " << (f3 == f4) << endl;
    // test operator!=
    cout << "f3 != f4 : " << (f3 != f4) << endl;
    // test operator>=
    cout << "f3 >= f4 : " << (f3 >= f4) << endl;
    // test operator>
    cout << "f3 > f4 : " << (f3 > f4) << endl;
    // test operator double
    cout << "f3 as double: " << (double)f3 << endl;
    // test toString
    cout << "f3 as string: " << f3.toString() << endl;
    // test fromDecimalString
    cout << "Fraction from decimal string 3.14: " << Fraction::fromDecimalString("3.14") << endl;
    return 0;
}
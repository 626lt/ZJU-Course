#ifndef FRACTION_H
#define FRACTION_H
#include <iostream>
#include <string>
#include <numeric>
#include <cmath>
using std::cin;
using std::cout;
using std::endl;
class Fraction{
    int numerator; // The top part of the fraction
    int denominator;// The bottom part of the fraction
public:
    Fraction();
    Fraction(int numerator, int denominator);
    Fraction(const Fraction& other);
    
    void simplify();

    Fraction operator+(const Fraction& other) const;
    Fraction operator-(const Fraction& other) const;
    Fraction operator*(const Fraction& other) const;
    Fraction operator/(const Fraction& other) const;

    bool operator<(const Fraction& other) const;
    bool operator<=(const Fraction& other) const;
    bool operator==(const Fraction& other) const;
    bool operator!=(const Fraction& other) const;
    bool operator>=(const Fraction& other) const;
    bool operator>(const Fraction& other) const;

    operator double() const;

    std::string toString() const;

    static Fraction fromDecimalString(const std::string& decimalString);

    friend std::ostream& operator<<(std::ostream& os, const Fraction& fraction);
    friend std::istream& operator>>(std::istream& is, Fraction& fraction);
};
#endif
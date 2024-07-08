#include "../include/fraction.h"

/*
 * Default constructor
 */
Fraction::Fraction() : numerator(0), denominator(1) {}

/*
 * Constructor with numerator and denominator
 */
Fraction::Fraction(int numerator, int denominator) : numerator(numerator), denominator(denominator){
    if(denominator == 0){
        throw std::invalid_argument("Denominator cannot be zero.");
    }
    this->simplify();
}

/*
 * Copy constructor
 * @param other: the fraction to copy
 * @return: a new fraction that is a copy of the other fraction
 */
Fraction::Fraction(const Fraction& other){
    this->numerator = other.numerator;
    this->denominator = other.denominator;
}

/*
 * Simplify the fraction
 * This function simplifies the fraction by dividing the numerator and denominator by their greatest common divisor
 */
void Fraction::simplify(){
    int gcd = std::gcd(this->numerator, this->denominator);
    this->numerator /= gcd;
    this->denominator /= gcd;
    if(this->denominator < 0){
        this->numerator *= -1;
        this->denominator *= -1;
    }
}

/*
 * Overloaded operators+
 * @param other: the fraction to add
 * @return: a new fraction that is the sum of this fraction and the other fraction
 */
Fraction Fraction::operator+(const Fraction& other) const{
    int newNumerator = this->numerator * other.denominator + other.numerator * this->denominator;
    int newDenominator = this->denominator * other.denominator;
    return Fraction(newNumerator, newDenominator);
}

/*
 * Overloaded operator-
 * @param other: the fraction to subtract
 * @return: a new fraction that is the difference of this fraction and the other fraction
 */
Fraction Fraction::operator-(const Fraction& other) const{
    int newNumerator = this->numerator * other.denominator - other.numerator * this->denominator;
    int newDenominator = this->denominator * other.denominator;
    return Fraction(newNumerator, newDenominator);
}

/*
 * Overloaded operator*
 * @param other: the fraction to multiply
 * @return: a new fraction that is the product of this fraction and the other fraction
 */
Fraction Fraction::operator*(const Fraction& other) const{
    int newNumerator = this->numerator * other.numerator;
    int newDenominator = this->denominator * other.denominator;
    return Fraction(newNumerator, newDenominator);
}

/*
 * Overloaded operator/
 * @param other: the fraction to divide
 * @return: a new fraction that is the quotient of this fraction and the other fraction
 */
Fraction Fraction::operator/(const Fraction& other) const{
    int newNumerator = this->numerator * other.denominator;
    int newDenominator = this->denominator * other.numerator;
    return Fraction(newNumerator, newDenominator);
}

/*
 * Overloaded operator<
 * @param other: the fraction to compare
 * @return: true if this fraction is less than the other fraction, false otherwise
 */
bool Fraction::operator<(const Fraction& other) const{
    return this->numerator * other.denominator < other.numerator * this->denominator;
}

/*
 * Overloaded operator<=
 * @param other: the fraction to compare
 * @return: true if this fraction is less than or equal to the other fraction, false otherwise
 */
bool Fraction::operator<=(const Fraction& other) const{
    return this->numerator * other.denominator <= other.numerator * this->denominator;
}

/*
 * Overloaded operator==
 * @param other: the fraction to compare
 * @return: true if this fraction is equal to the other fraction, false otherwise
 */
bool Fraction::operator==(const Fraction& other) const{
    return this->numerator * other.denominator == other.numerator * this->denominator;
}

/*
 * Overloaded operator!=
 * @param other: the fraction to compare
 * @return: true if this fraction is not equal to the other fraction, false otherwise
 */
bool Fraction::operator!=(const Fraction& other) const{
    return this->numerator * other.denominator != other.numerator * this->denominator;
}

/*
 * Overloaded operator>=
 * @param other: the fraction to compare
 * @return: true if this fraction is greater than or equal to the other fraction, false otherwise
 */
bool Fraction::operator>=(const Fraction& other) const{
    return this->numerator * other.denominator >= other.numerator * this->denominator;
}

/*
 * Overloaded operator>
 * @param other: the fraction to compare
 * @return: true if this fraction is greater than the other fraction, false otherwise
 */
bool Fraction::operator>(const Fraction& other) const{
    return this->numerator * other.denominator > other.numerator * this->denominator;
}

/*
 * Conversion operator to double
 * @return: the value of the fraction as a double
 */
Fraction::operator double() const{
    return (double)this->numerator / this->denominator;
}

/*
 * Convert the fraction to a string
 * @return: the fraction as a string in the form "numerator/denominator"
 */
std::string Fraction::toString() const{
    return std::to_string(this->numerator) + "/" + std::to_string(this->denominator);
}

/*
 * Create a fraction from a finite decimal string
 * @param decimalString: the decimal string to convert
 * @return: the fraction that is equivalent to the decimal string
 */
Fraction Fraction::fromDecimalString(const std::string& decimalString){
    size_t pos = decimalString.find('.');
    int whole = 0;
    if (decimalString.substr(0,0) == "-"){
        whole = std::stoi(decimalString.substr(1, pos));
    }
    else{
        whole = std::stoi(decimalString.substr(0, pos));
    }
    // use the size to determine the number of decimal places to keep or it will be out of range
    int size = decimalString.size() - pos - 1 > 8 ? 8 : decimalString.size() - pos - 1;
    int numerator = std::stoi(decimalString.substr(pos + 1,pos + size));
    int denominator = 1;
    for(int i = 0; i < size; i++){
        denominator *= 10;
    }
    numerator += whole * denominator;
    if(decimalString.substr(0,1) == "-"){
        numerator *= -1;
    }
    return Fraction(numerator, denominator);
}

/*
 * Overloaded operator<<
 * @param os: the output stream
 * @param fraction: the fraction to output
 * @return: the output stream
 */
std::ostream& operator<<(std::ostream& os, const Fraction& fraction){
    os << fraction.toString();
    return os;
}

/*
 * Overloaded operator>>
 * @param is: the input stream
 * @param fraction: the fraction to input
 * @return: the input stream
 */
std::istream& operator>>(std::istream& is, Fraction& fraction){
    std::string input;
    is >> input;
    fraction = Fraction::fromDecimalString(input);
    return is;
}


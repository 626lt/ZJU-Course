#include<iostream>
#include<fstream>
#include<string>
#include<iomanip>
using namespace std;
int main() 
{
    string name[10];
    int score1[10], score2[10], score3[10], sum[3]={0}, min[3]={6,6,6}, max[3]={0};
    ifstream fin("data.txt");
    ofstream fout("lab1out.txt");
    fout.setf(ios::left);
    fout << setw(8) << "no" << setw(8) << "name" << setw(8) << "score1" << setw(8) << "score2" << setw(8) << "score3" << setw(8) << "average" << endl;
    for(int i = 0;i < 10;i++)
    {
        fin >> name[i] >> score1[i] >> score2[i] >> score3[i];
        sum[0] += score1[i];
        sum[1] += score2[i];
        sum[2] += score3[i];
        if(score1[i] < min[0]) min[0] = score1[i];
        if(score2[i] < min[1]) min[1] = score2[i];
        if(score3[i] < min[2]) min[2] = score3[i];
        if(score1[i] > max[0]) max[0] = score1[i];
        if(score2[i] > max[1]) max[1] = score2[i];
        if(score3[i] > max[2]) max[2] = score3[i];
        fout << setw(8) << i+1 << setw(8) << name[i] << setw(8) << score1[i] << setw(8) << score2[i] << setw(8) << score3[i] << setw(8) << float(score1[i]+score2[i]+score3[i])/3 << endl;
    }
    fout << setw(8) <<  " " << setw(8) << "average" << setw(8) << float(sum[0])/10 << setw(8) << float(sum[1])/10 << setw(8) << float(sum[2])/10 << endl;
    fout << setw(8) <<  " " << setw(8) << "min" << setw(8) << min[0] << setw(8) << min[1] << setw(8) << min[2] << endl;
    fout << setw(8) <<  " " << setw(8) << "max" << setw(8) << max[0] << setw(8) << max[1] << setw(8) << max[2] << endl;
    return 0;
}

#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <iomanip>
using namespace std;

vector<string> course_name;
vector<int> max_score;
vector<int> min_score;
vector<int> sum;
vector<int> cnt;

class student{
    public:
    int num;//±àºÅ
    string name;
    struct coures{
        string name;
        int score;
    };
    vector<coures> coureses;
    float average;
    void set_num(int n){
        num = n;
    }
    void set_name(string n){
        name = n;
    }
    void set_coures(string n, int s){
        coures c;
        c.name = n;
        c.score = s;
        coureses.push_back(c);
    }
    void get_average(){
        int sum = 0;
        for(int i = 0; i < coureses.size(); i++){
            sum += coureses[i].score;
        }
        average = float(sum) / coureses.size();
    }
};

vector<string> splitString(const string& str, const string& delimiter) {
    size_t start = 0;
    size_t end = str.find(delimiter);
    vector<string> tokens;
    while (end != string::npos) {
        tokens.push_back(str.substr(start, end - start));
        start = end + delimiter.length();
        end = str.find(delimiter, start);
        //printf("%s\n", str.substr(start, end - start).c_str());
    }
    tokens.push_back(str.substr(start, end));
    return tokens;
}

int main()
{

    course_name.push_back("no");
    course_name.push_back("name");
    sum.push_back(0);
    sum.push_back(0);
    max_score.push_back(0);
    max_score.push_back(0);
    min_score.push_back(0);
    min_score.push_back(0);
    cnt.push_back(0);
    cnt.push_back(0);

    int i = 1,k;
    vector<student *> students;
    string str;
    ifstream in("student.txt");
    ofstream fout("lab2out.txt");
    vector<string> tokens;
    while(getline(in, str)){
        // printf("%d : %s\n", i, str.c_str());
        tokens = splitString(str, " ");

        student *s = new student;

        s->set_num(i);
        s->set_name(tokens[0]);

        for(int j = 1; j < tokens.size(); j += 2){
            string name;
            int score;
            name = tokens[j];
            //printf("%s ", tokens[j + 1].c_str());
            score = stoi(tokens[j + 1]);
            s->set_coures(name, score);

            for(k = 0; k < course_name.size(); k++){
                if(course_name[k] == name){
                    sum[k] += score;
                    cnt[k]++;
                    if(score > max_score[k]){
                        max_score[k] = score;
                    }
                    if(score < min_score[k]){
                        min_score[k] = score;
                    }
                    break;
                }
            }
            if(k == course_name.size()){
                course_name.push_back(name);
                max_score.push_back(score);
                min_score.push_back(score);
                sum.push_back(score);
                cnt.push_back(1);
            }
        }
        s->get_average();
        students.push_back(s);
        i++;
    }
    course_name.push_back("average");
    in.close();
    //print
    for(int i = 0;i < course_name.size();i++){
        fout << left << setw(10) << course_name[i]; 
    }
    fout << endl;
    for(int j = 0;j < students.size();j++){
        fout << left << setw(10) << students[j]->num << left << setw(10) << students[j]->name;
        for(int i = 2;i < course_name.size() - 1;i++){
            for(k = 0;k < students[j]->coureses.size();k++){
                if(students[j]->coureses[k].name == course_name[i]){
                    fout << left << setw(10) << students[j]->coureses[k].score;
                    break;
                }
           }
            if(k >= students[j]->coureses.size()){
                fout << left << setw(10) << "NULL";
            }
        }
        fout << left << setprecision(6) <<  students[j]->average;
        fout << endl;
    }

    fout << left << setw(10) << " " << left << setw(10) << "average";
    for(int i = 2;i < course_name.size() - 1;i++){
        fout << left << setw(10) << setprecision(6) << float(sum[i]) / cnt[i];
    }
    fout << endl;

    fout << left << setw(10) << " " << left << setw(10) << "max";
    for(int i = 2;i < course_name.size() - 1;i++){
        fout << left << setw(10) << max_score[i];
    }
    fout << endl;

    fout << left << setw(10) << " " << left << setw(10) << "min";
    for(int i = 2;i < course_name.size() - 1;i++){
        fout << left << setw(10) << min_score[i];
    }
    fout << endl;

    return 0;
}


#include <iostream>
#include <utility>
#include <vector>
#include <algorithm>
#include <random>
#include <string>
#include "stack.hpp"

using namespace std;

void test1(vector<pair<char, char>> const&);
void test2();
void test3();


int main() {

    //You can check if your code works well.

    cout<<__cplusplus<<endl;

    Stack<int> s;

    cout<<boolalpha;
    cout<<s.isEmpty()<<endl;
    cout<<s.isFull()<<endl;
    
    s.push(10);
    cout<<s.isEmpty()<<endl;
    cout<<s.isFull()<<endl;
    cout<<s.pop()<<endl;

    pair<char,char> p = make_pair('(',')');
    vector<pair<char,char>> v;
    v.push_back(p);

    string a = "(3))";
    cout<<checkParentheses(a, v)<<endl;

    /*========================test========================*/
    cout << "=================test=================\n";
    //v.push_back({ '{', '}' });
    //test1(v);
    cout<<"test1finished\n";
    //test2();
    cout<<"test2finished\n";
    test3();


    return 0;

}

void test1(vector<pair<char, char>> const& v) {
    string b = "((4)))))))))))))))";

    cout << checkParentheses(b, v) << endl;
}
void test2() {
    Stack<int> a;
    for (int i = 0; i < 10; i++) {
        a.push(i);
    }
    while (!a.isEmpty()) {
        cout << a.pop() << '\n';
    }
}
void test3() {
    string s1 = "-7*(-3+5)+9";
    string s2 = "7+(0.3+5)*(-8)";
    string s3 = "70+(30+50)*80";

    cout << calculate(s1) << '\n';
    cout << calculate(s2) << '\n';
    //cout << calculate(s3) << '\n';

}

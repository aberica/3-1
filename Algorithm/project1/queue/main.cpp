#include <iostream>
#include <vector>
#include <algorithm>
#include <random>
#include <string>
#include "queue.hpp"

using namespace std;

void test();

int main() {

    //You can check if your code works well.

    cout<<__cplusplus<<endl;

    Queue<int> q;

    cout<<boolalpha;
    cout<<q.isFull()<<endl;

    q.enqueue(1,2);
    q.enqueue(2,3);

    cout<<q.isFull()<<endl;
    cout<<q.top()<<endl;

    q.dequeue();
    cout<<q.top()<<endl;

    test();

    return 0;

}

void test1() {
    Queue<int> q;
    for (int i = 1; i < 30; i++) {
        q.enqueue(i, i * 7 % 10);
    }
    for (int i = 1; i < 30; i++) {
        q.Print();
        cout << "top arr : " << q.top() << ' ';
        cout << "dequeue : " << q.dequeue() << '\n';
        q.Print();
        cout << '\n';
    }
}

void test() {
    /*========================test========================*/
    cout << "=================test=================\n";
    test1();
}
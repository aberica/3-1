#include <iostream>
#include <utility>
#include <vector>
#include <string>

using namespace std;

template <typename T>
class Stack{
    private: 
        int current;
        int size;
        T * array;

    public:
        Stack<T> (int _size = 16)
        {   
            current = -1;
            size = _size;
            array = new T[_size];
        }
        ~Stack()
        {
            delete[] array;
        }    

        bool isEmpty() const;
        bool isFull() const;
        T top() const;
        T pop();
        void push(const T& item);
};

template <typename T>
bool Stack<T>::isEmpty() const{
    //TODO
    if (current < 0) return true;
    else return false;
}

template <typename T>
bool Stack<T>::isFull() const{
    //TODO
    if (current + 1 == size) return true;
    else return false;
}

template <typename T>
T Stack<T>::top() const{
    //TODO
    if (isEmpty()) return NULL;
    else return array[current];
}

template <typename T>
T Stack<T>::pop(){
    //TODO
    if (isEmpty()) return NULL;
    else return array[current--];
}

template <typename T>
void Stack<T>::push(const T& item){
    //TODO
    if (isFull()) {
        T* tmp = new T[size * 2];
        for (int i = 0; i < size; i++) {
            tmp[i] = array[i];
        }
        delete[] array;
        array = tmp;
        size *= 2;
    }
    array[++current] = item;
    return;
}

bool checkParentheses(const string& line, const vector<pair<char,char>>& pairs);
float calculate(const string& line);
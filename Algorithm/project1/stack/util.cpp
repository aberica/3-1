#include <iostream>
#include <utility>
#include <vector>
#include <string>
#include "stack.hpp"

using namespace std;

bool checkParentheses(const string& line, const vector<pair<char, char>>& pairs) {
    //TODO
    Stack<char> parentheses;
    for (int i = 0; i < line.size(); i++) {
        char c = line[i];
        for (int j = 0; j < pairs.size(); j++) {
            if (c == pairs[j].first) {
                parentheses.push(c);
            }
            else if (c == pairs[j].second) {
                if (parentheses.pop() == pairs[j].first) continue;
                else return false;
            }
        }
    }
    
    if(parentheses.isEmpty()) return true;
    else return false;
}

int Rank(char const& c) {
    switch (c) {
    case '*':
    case '/':
        return 3;
    case '+':
    case '-':
        return 2;
    case '(':
    case '{':
        return 1;
    }
}
void Arithmetic(Stack<float>& num, char op) {
    float tmp = num.pop();

    switch (op) {
    case '+':
        tmp = num.pop() + tmp;
        break;
    case '-':
        tmp = num.pop() - tmp;
        break;
    case '*':
        tmp = num.pop() * tmp;
        break;
    case '/':
        tmp = num.pop() / tmp;
        break;
    }
    num.push(tmp);
    return;
}

float calculate(const string& line) {
    //TODO

    Stack<float> numbers;
    Stack<char> operators;

    string num;
    bool inv = false;

    for (int i = 0; i < line.size(); i++) {
        char c = line[i];

        if (isdigit(c) || c == '.') {
            num.push_back(c);
        }

        else {
            if (num.size() != 0) {
                if (inv) {
                    numbers.push(stof(num) * -1);
                    inv = false;
                }
                else {
                    numbers.push(stof(num));
                }
                num.clear();
            }

            switch (c) {
            case '+':
            case '-':
                if (i == 0 || line[i - 1] == '(' || line[i - 1] == '{') {
                    if (c == '-') inv = true;
                    break;
                }
            case '*':
            case '/':
                while (!operators.isEmpty() && Rank(operators.top()) > Rank(c)) {
                    Arithmetic(numbers, operators.pop());
                }
                operators.push(c);
                break;

            case '(':
            case '{':
                operators.push(c);
                break;

            case ')':
                while (1) {
                    char pp = operators.pop();
                    if (pp == '(') break;
                    Arithmetic(numbers, pp);
                }
                break;

            case '}':
                while (1) {
                    char pp = operators.pop();
                    if (pp == '{') break;
                    Arithmetic(numbers, pp);
                }
                break;

            default:
                if (c == ' ') break;
                cout << "Wrong expresion : " << c << " included" << '\n';
                return NULL;
            }

        }
    }

    if (num.size() != 0) {
        if (inv) {
            numbers.push(stof(num) * -1);
            inv = false;
        }
        else {
            numbers.push(stof(num));
        }
        num.clear();
    }
    while (!operators.isEmpty()) {
        char pp = operators.pop();
        Arithmetic(numbers, pp);
    }

    return numbers.top();
}
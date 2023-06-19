#include <iostream>
#include <vector>
#include <stack>
#include <queue>
using namespace std;


int main() {
    int n = 3;
    vector<vector<int>> v1(n, vector<int>(n, 0));
    stack<vector<vector<int>>> q1;
    q1.push(v1);

    v1[0][0] = 1;
    q1.push(v1);

    v1[1][1] = 2;
    q1.push(v1);

    v1[2][2] = 3;
    q1.push(v1);

    v1[0][0] = 0;
    q1.push(v1);

    v1[1][1] = 0;
    q1.push(v1);

    v1[2][2] = 0;
    q1.push(v1);

    while(!q1.empty()) {
        vector<vector<int>> u = q1.top();
        q1.pop();

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                cout << u[i][j]<<' ';
            }
            cout << '\n';
        }
        cout << '\n';
    }
    return 0;
}
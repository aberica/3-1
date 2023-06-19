#include <iostream>
#include <stack>

#define n 3
#define m 4

using namespace std;


void PrintArr(auto arr) {
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < m; j++) {
            printf("%3d", arr[i][j]);
        }
        printf("\n");
    }
    printf("\n");
}

void PLUS(int arr[n][n]) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            arr[i][j]++;
        }
    }
}

int main() {
    int arr[n][n] = {{1,2, 3}, {4, 5, 6}, {7, 8, 9}};
    int arr2[m][m] = {{0, }};

    for (int k = 0, j = 1; k < n; k++) {
        copy(&arr[k][j], &arr[k][j] + (n - j), &arr2[k][j]);
    }

    PrintArr(arr2);
    return 0;
}

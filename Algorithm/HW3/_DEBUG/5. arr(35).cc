#include <iostream>
#include <fstream>
#include <vector>
#include <stack>
#include <time.h>

#define MAX 14

using namespace std;

int n, k;
int board[MAX][MAX] = {{0, }, };
int p_max[MAX] = {0, };

void PrintBoard(int curr_board[MAX][MAX]) {
    for (int i = 0; i < n; i++) {
        for(int j = 0; j < n; j++) {
            if (curr_board[i][j] == -2)
                printf("  O");
            else if (curr_board[i][j] == -1)
                printf("  X");
            //else if (curr_board[i][j] == 0)
            //    printf("  _");
            //else printf("%3d", curr_board[i][j]);
            else
               printf("  -");
        }
        printf("\n");
    }
    cout<<endl;
}
void verifyAnswer(vector<int [MAX][MAX]> answers) {
    int coincide_num = 0;
    for (int t = 0; t < answers.size(); t++) {
        for (int q = t - 1; q >= 0; q--) {
            bool coincide = true;
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    if (answers[t][i][j] != answers[q][i][j]) {
                        coincide = false;
                        break;
                    }
                }
                if (!coincide) break;
            }
            if (coincide) {
                coincide_num++;
                break;
            }
        }
    }
    printf("coincide num : %d\n", coincide_num);
}

void placeQueen(int row, int col) {
    if (row < 0) return;
    board[row][col] = -2;                   // placed queen is makred as -2
    for (int j = col + 1; j < n; j++) {
        if (board[row][j] == -1) break;
        board[row][j]++;
    }
    for (int i = row + 1; i < n; i++) {
        if (board[i][col] == -1) break;
        board[i][col]++;
    }
    for (int i = row + 1, j = col + 1; i < n && j < n; i++, j++) {
        if (board[i][j] == -1) break;
        board[i][j]++;
    }
    
    for (int i = row - 1, j = col + 1; i >= 0 && j < n; i--, j++) {
        if (board[i][j] == -1) break;
        board[i][j]++;
    }
}
void removeQueen(int row, int col) {
    if (row < 0) return;
    board[row][col] = 0;
    for (int j = col + 1; j < n; j++) {
        if (board[row][j] == -1) break;
        board[row][j]--;
    }
    for (int i = row + 1; i < n; i++) {
        if (board[i][col] == -1) break;
        board[i][col]--;
    }
    for (int i = row + 1, j = col + 1; i < n && j < n; i++, j++) {
        if (board[i][j] == -1) break;
        board[i][j]--;
    }
    
    for (int i = row - 1, j = col + 1; i >= 0 && j < n; i--, j++) {
        if (board[i][j] == -1) break;
        board[i][j]--;
    }
}

void recursiveBacktracking(int row, int col, int pq_num, int& count) {
    if (pq_num == n) {
        count++;

        // printf("answer %d :=====================\n", count);
        // PrintBoard(board);

        return;
    }
    if (n - pq_num > p_max[col]) return;
    for (int j = col; j < n; j++) {
        for (int i = 0; i < n; i++) {
            if (j == col && i < row) continue;
            if (board[i][j] ==  0) {
                placeQueen(i, j);
                // PrintBoard(new_board);
                if (i+2 < n) recursiveBacktracking(i+2, j, pq_num+1, count);
                else recursiveBacktracking(0, j+1, pq_num+1, count);
                removeQueen(i, j);
            }
        }
    }
}

class T {
public:    
    T() {
        row = -1;
        col = 0;
        pq_num = 0;
    }
    int row, col, pq_num;    // pq_num : placed queen number
};

int iterativeBacktracking() {
    int count = 0;
    stack<T> Stack;
    stack<pair<int, int>> hist;
    T init, blank;
    Stack.push(init);
    blank.row = n;  
    while (!Stack.empty()) {
        T curr = Stack.top();
        Stack.pop();

        if (curr.pq_num == n) {
            count++;

            // printf("answer %d :=====================\n", count);
            // placeQueen(curr.row, curr.col);
            // PrintBoard(board);
            // removeQueen(curr.row, curr.col);
        }
        else if (curr.row >= n) {   // blank
            removeQueen(hist.top().first, hist.top().second);
            hist.pop();
        }
        else if (n - curr.pq_num <= p_max[curr.col]) {
            placeQueen(curr.row, curr.col);
            hist.push({curr.row, curr.col});

            // printf("curr_board:--------------------\n");
            // PrintBoard(board);
            
            Stack.push(blank);
            for (int j = n - 1; j >= curr.col; j--) {
                for (int i = n - 1; i >= 0; i--) {
                    if (j == curr.col && i < curr.row) break;    // already examed
                    if (board[i][j] != 0) continue;              // can't place here
                    T next;
                    
                    next.row = i;
                    next.col = j;
                    next.pq_num = curr.pq_num + 1;

                    Stack.push(next);
                }
            }
        }
    
    }
    return count;
}


int main(int argc, char* argv[]) {
    ios_base::sync_with_stdio(false);
    cin.tie(0);
    if (argc != 4) {
        cout << "Wrong number of arguments!" << endl;
        return 1;
    }

    int version = atoi(argv[1]);
    string inputFilePath = argv[2];
    string outputFilePath = argv[3];

    ifstream inputFile(inputFilePath);
    ofstream outputFile(outputFilePath);

    inputFile >> n >> k;

    for (int i = 0; i < k; i++) {
        int x, y;
        inputFile >> x >> y;
        board[x-1][y-1] = -1;
        p_max[y-1]++;
    }
    for (int i = n-1; i >= 0; i--) {
        p_max[i] += 1 + p_max[i+1];
    }

    cout << "p_max : ";
    for (int i = 0; i < n; i++) {
        cout << p_max[i] << ' ';
    }
    cout << endl;

    clock_t start, end;
    if (version == 1) {
        start = clock();
        int count = iterativeBacktracking();
        end = clock();
        cout << "time : "<< double(end - start) / double(CLOCKS_PER_SEC) << '\n';
        outputFile << count << endl;
    }
    else if (version == 2) {
        int count = 0;
        start = clock();
        recursiveBacktracking(0, 0, 0, count);
        end = clock();
        cout << "time : "<< double(end - start) / double(CLOCKS_PER_SEC) << '\n';
        outputFile << count << endl;
    }
    else {
        cout << "Wrong version!" << endl;
        return 1;
    }

    inputFile.close();
    outputFile.close();

    return 0;
}

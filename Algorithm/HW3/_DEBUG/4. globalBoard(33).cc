#include <iostream>
#include <fstream>
#include <vector>
#include <stack>

using namespace std;

int n, k;
vector<vector<int>> board;
vector<int> p_max;

void PrintBoard(vector<vector<int>> curr_board) {
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
    printf("\n");
}
void verifyAnswer(vector<vector<vector<int>>> answers) {
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

void placeQueen(int row, int col, vector<vector<int>>& curr_board = board) {
    curr_board[row][col] = -2;
    for (int j = col + 1; j < n; j++) {
        if (curr_board[row][j] == -1) break;
        curr_board[row][j]++;
    }
    for (int i = row + 1; i < n; i++) {
        if (curr_board[i][col] == -1) break;
        curr_board[i][col]++;
    }
    for (int i = row + 1, j = col + 1; i < n && j < n; i++, j++) {
        if (curr_board[i][j] == -1) break;
        curr_board[i][j]++;
    }
    
    for (int i = row - 1, j = col + 1; i >= 0 && j < n; i--, j++) {
        if (curr_board[i][j] == -1) break;
        curr_board[i][j]++;
    }
}

void removeQueen(int row, int col, vector<vector<int>>& curr_board = board) {
    curr_board[row][col] = 0;
    for (int j = col + 1; j < n; j++) {
        if (curr_board[row][j] == -1) break;
        curr_board[row][j]--;
    }
    for (int i = row + 1; i < n; i++) {
        if (curr_board[i][col] == -1) break;
        curr_board[i][col]--;
    }
    for (int i = row + 1, j = col + 1; i < n && j < n; i++, j++) {
        if (curr_board[i][j] == -1) break;
        curr_board[i][j]--;
    }
    
    for (int i = row - 1, j = col + 1; i >= 0 && j < n; i--, j++) {
        if (curr_board[i][j] == -1) break;
        curr_board[i][j]--;
    }
}

void recursiveBacktracking(int row, int col, int p, int& count) {
    if (p == n) {
        count++;
        return;
    }
    if (col >= n || n - p > p_max[col]) return;
    for (int j = col; j < n; j++) {
        for (int i = 0; i < n; i++) {
            if (j == col && i < row) continue;
            if (board[i][j] == 0) {
                placeQueen(i, j);
                // PrintBoard(new_board);
                if (i+2 >= n) recursiveBacktracking(0, j+1, p+1, count);
                else recursiveBacktracking(i+2, j, p+1, count);
                removeQueen(i, j);
            }
        }
    }
}

struct T {
    vector<vector<int>> board;
    int row, col, p;
};

int iterativeBacktracking() {
    int count = 0;
    stack<T> stack;
    stack.push({board, 0, 0, 0});

    //vector<vector<vector<int>>> answers;

    while (!stack.empty()) {
        vector<vector<int>> curr_board = stack.top().board;
        int row = stack.top().row;
        int col = stack.top().col;
        int p = stack.top().p;
        stack.pop();
        if (p == n) {

            //printf("answer:========================\n");
            //PrintBoard(curr_board);
            //answers.push_back(curr_board);
            //printf("answer:========================\n");

            count++;
            continue;
        }
        if (col >= n || n - p > p_max[col]) {
            continue;
        };

        //printf("curr_board:====================\n");
        //PrintBoard(curr_board);

        for (int j = col; j < n; j++) {
            for (int i = 0; i < n; i++) {
                if (j == col && i < row) continue;
                if (curr_board[i][j] == 0) {

                    //printf("place - i: %d, j: %d\n", i, j);
                    //PrintBoard(curr_board);

                    placeQueen(i, j, curr_board);
                    if (i+2 >= n) stack.push({curr_board, 0, j+1, p+1});
                    else stack.push({curr_board, i+2, j, p+1});
                    removeQueen(i, j, curr_board);
                }
            }
        }
    }
    //verifyAnswer(answers);
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

    board.resize(n, vector<int>(n, 0));
    p_max.resize(n, 1);
    // cout << "t0\n";

    for (int i = 0; i < k; i++) {
        int x, y;
        inputFile >> x >> y;
        board[x-1][y-1] = -1;
        p_max[y-1]++;
    }
    for (int i = n-2; i >= 0; i--) {
        p_max[i] += p_max[i+1];
    }

    if (version == 1) {
        int count = iterativeBacktracking();
        outputFile << count << endl;
    }
    else if (version == 2) {
        int count = 0;
        recursiveBacktracking(0, 0, 0, count);
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

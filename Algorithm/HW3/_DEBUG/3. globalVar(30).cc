#include <iostream>
#include <fstream>
#include <vector>
#include <stack>

using namespace std;

struct T {
    vector<vector<int>> board;
    int row, col, p;
};
int n, k;
vector<int> p_max;

void PrintBoard(vector<vector<int>>& board) {
    int n = board.size();
    for (int i = 0; i < n; i++) {
        for(int j = 0; j < n; j++) {
            printf("%3d", board[i][j]);
        }
        printf("\n");
    }
    printf("\n");
}

void placeQueen(vector<vector<int>>& board, int row, int col) {
    for (int j = col + 1; j < n; j++) {
        if (board[row][j] == -1) break;
        board[row][j] = 2;
    }
    for (int i = row + 1; i < n; i++) {
        if (board[i][col] == -1) break;
        board[i][col] = 2;
    }
    for (int i = row + 1, j = col + 1; i < n && j < n; i++, j++) {
        if (board[i][j] == -1) break;
        board[i][j] = 2;
    }
    
    for (int i = row - 1, j = col + 1; i >= 0 && j < n; i--, j++) {
        if (board[i][j] == -1) break;
        board[i][j] = 2;
    }
}

void recursiveBacktracking(vector<vector<int>>& board, int row, int col, int p, int& count) {
    if (p == n) {
        count++;
        return;
    }
    if (col >= n || n - p > p_max[col]) return;
    for (int j = col; j < n; j++) {
        for (int i = 0; i < n; i++) {
            if (j == col && i < row) continue;
            if (board[i][j] == 0) {
                vector<vector<int>> new_board = board;
                new_board[i][j] = 1;
                placeQueen(new_board, i, j);
                // PrintBoard(new_board);
                if (i+2 >= n) recursiveBacktracking(new_board, 0, j+1, p+1, count);
                else recursiveBacktracking(new_board, i+2, j, p+1, count);
            }
        }
    }
}

int iterativeBacktracking(vector<vector<int>>& board) {
    int count = 0;
    stack<T> stack;
    stack.push({board, 0, 0, 0});
    while (!stack.empty()) {
        vector<vector<int>> curr_board = stack.top().board;
        int row = stack.top().row;
        int col = stack.top().col;
        int p = stack.top().p;
        stack.pop();
        // cout << "t2\n";
        if (p == n) {
            // printf("========================\n");
            // PrintBoard(curr_board);
            // printf("========================\n");
            count++;
            continue;
        }
        // if (row >= n || col >= n) return;
        if (col >= n || n - p > p_max[col]) {
            // cout << "p_max operated\n";
            continue;
        };
        for (int j = col; j < n; j++) {
            for (int i = 0; i < n; i++) {
                if (j == col && i < row) continue;
                if (curr_board[i][j] == 0) {
                    vector<vector<int>> new_board = curr_board;
                    new_board[i][j] = 1;
                    placeQueen(new_board, i, j);
                    // PrintBoard(new_board);
                    if (i+2 >= n) stack.push({new_board, 0, j+1, p+1});
                    else stack.push({new_board, i+2, j, p+1});
                }
            }
        }
    }
    return count;
}

int main(int argc, char* argv[]) {
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

    vector<vector<int>> board(n, vector<int>(n, 0));
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
    // cout << "p_max : ";
    // for (int i = 0; i < n; i++) {
        // cout << p_max[i] << ' ';
    // }
    // cout << '\n';

    if (version == 1) {
        // cout << "t1\n";
        int count = iterativeBacktracking(board);
        outputFile << count << endl;
    }
    else if (version == 2) {
        int count = 0;
        recursiveBacktracking(board,  0, 0, 0, count);
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

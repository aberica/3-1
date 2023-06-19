#include <iostream>
#include <fstream>
#include <vector>
#include <stack>

using namespace std;

struct T {
    vector<vector<int>> board;
    int row, col, p;
};

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

bool canPlace(vector<vector<int>>& board, int row, int col) {
    int n = board.size();
    if (row >= n || col >= n) return false;
    if (board[row][col] == -1) return false;
    for (int j = col; j >= 0; j--) {
        if (board[row][j] == -1) break;
        if (board[row][j] == 1) return false;
    }
    for (int i = row; i >= 0; i--) {
        if (board[i][col] == -1) break;
        if (board[i][col] == 1) return false;
    }
    for (int i = row, j = col; i >= 0 && j >= 0; i--, j--) {
        if (board[i][j] == -1) break;
        if (board[i][j] == 1) return false;
    }
    /*for (int i = row, j = col; i < n && j < n; i++, j++) {
        if (board[i][j] == -1) break;
        if (board[i][j] == 1) return false;
    }*/
    for (int i = row, j = col; i < n && j >= 0; i++, j--) {
        if (board[i][j] == -1) break;
        if (board[i][j] == 1) return false;
    }
    /*for (int i = row, j = col; i >= 0 && j < n; i--, j++) {
        if (board[i][j] == -1) break;
        if (board[i][j] == 1) return false;
    }*/
    return true;
}

void placeQueens(vector<vector<int>>& board, vector<int>& p_max, int row, int col, int p, int& count) {
    int n = board.size();
    if (n - p > p_max[col]) return;
    if (p >= n) {
        count++;
        return;
    }
    for (int j = col; j < n; j++) {
        for (int i = 0; i < n; i++) {
            if (j == col && i < row) continue;
            if (canPlace(board, i, j)) {
                vector<vector<int>> new_board = board;
                new_board[i][j] = 1;
                // PrintBoard(new_board);
                if (i+2 >= n) placeQueens(new_board, p_max, 0, j+1, p+1, count);
                else placeQueens(new_board, p_max, i+2, j, p+1, count);
            }
        }
    }
}

int iterativeBacktracking(vector<vector<int>>& board, vector<int>& p_max) {
    int count = 0;
    int n = board.size();
    stack<T> stack;
    stack.push({board, 0, 0, 0});
    while (!stack.empty()) {
        vector<vector<int>> curr_board = stack.top().board;
        int row = stack.top().row;
        int col = stack.top().col;
        int p = stack.top().p;
        stack.pop();
        // cout << "t2\n";
        if (p - n > p_max[col]) continue;

        if (p == n) {
            // printf("========================\n");
            // PrintBoard(curr_board);
            // printf("========================\n");
            count++;
            continue;
        }
        for (int j = col; j < n; j++) {
            for (int i = 0; i < n; i++) {
                if (j == col && i < row) continue;
                if (canPlace(curr_board, i, j)) {
                    vector<vector<int>> new_board = curr_board;
                    new_board[i][j] = 1;
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

    int n, k;
    inputFile >> n >> k;

    vector<vector<int>> board(n, vector<int>(n, 0));
    vector<int> p_max(n, 1);
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
        // cout << "t1\n";
        int count = iterativeBacktracking(board, p_max);
        outputFile << count << endl;
    }
    else if (version == 2) {
        int count = 0;
        placeQueens(board, p_max,  0, 0, 0, count);
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

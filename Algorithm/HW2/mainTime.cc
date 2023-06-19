#include <stack>
#include <vector>
#include <fstream>
#include <algorithm>
#include <time.h>
#include <iostream>

#define MAX_NODES 5000

using namespace std;

int n, m;
int version;

int adjMatrix[MAX_NODES][MAX_NODES], radjMatrix[MAX_NODES][MAX_NODES];
vector<int> adjList[MAX_NODES], radjList[MAX_NODES];
vector<vector<int>> adjArray, radjArray;

stack<int> order;
bool visited[MAX_NODES] = {false};
int component[MAX_NODES];

void dfs1(int node) {
    visited[node] = true;
    switch(version) {
        case 1:
            for (int next = 0; next < n; next++) {
                if (adjMatrix[node][next] == 0) continue;
                if (!visited[next])
                    dfs1(next);
            }
        break;

        case 2:
            for (auto& next : adjList[node]) {
            if (!visited[next])
                dfs1(next);
            }
        break;

        case 3:
            for (auto& next : adjArray[node]) {
                if (!visited[next])
                    dfs1(next);
            }
        break;
    }
    order.push(node);
}

void dfs2(int node, int c) {
    component[node] = c;
    switch(version) {
        case 1:
            for (int next = 0; next < n; next++) {
                if (radjMatrix[node][next] == 0) continue;
                if (component[next] == -1)
                    dfs2(next, c);
            }
        break;

        case 2:
            for (auto& next : radjList[node]) {
                if (component[next] == -1)
                    dfs2(next, c);
            }
        break;

        case 3:
            for (auto& next : radjArray[node]) {
                if (component[next] == -1)
                    dfs2(next, c);
            }
        break;
    }
}

int main(int argc, char* argv[]) {
    version = stoi(argv[1]);
    std::ifstream input(argv[2]);
    std::ofstream output(argv[3]);
    
    input >> n >> m;

    adjArray.resize(n);
    radjArray.resize(n);

    clock_t start, end;

    // Get Input
    for (int i = 0; i < m; i++) {
        int s, t;
        input >> s >> t;
        --s; --t;  // assuming the vertices are 1-indexed in the input file
        switch(stoi(argv[1])){
            case 1:
            adjMatrix[s][t] = 1;
            radjMatrix[t][s] = 1;
            break;

            case 2:
            adjList[s].push_back(t);
            radjList[t].push_back(s);
            break;

            case 3:
            adjArray[s].push_back(t);
            radjArray[t].push_back(s);
            break;
        }
    }

    int c = 0;  // used for identifying same SSC
    std::fill(component, component + n, -1);    // SSC group number

    start = clock();
    // Run DFS and determine order, which stores small finish time first and large finish time last by stack
    for (int i = 0; i < n; i++) {
        if (!visited[i])
            dfs1(i);
    }
    // Run DFS on G(R) and determine component, which gets same number when they are in the same SSC
    while (!order.empty()) {
        int node = order.top();
        order.pop();
        if (component[node] == -1)
            dfs2(node, c++);
    }
    end = clock();

    cout << "time : "<< double(end - start) << '\n';

    // Generate xor_result
    std::vector<int> xor_results(c, 0);
    for (int i = 0; i < n; i++)
        xor_results[component[i]] ^= (i + 1);  // convert back to 1-indexed

    std::sort(xor_results.begin(), xor_results.end());

    // Write Output
    output << c << '\n';
    for (auto& result : xor_results)
        output << result << ' ';

    return 0;
}

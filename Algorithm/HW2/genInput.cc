#include <fstream>
#include <vector>
#include <set>
#include <cstdlib>
#include <ctime>
#include <string>

struct Edge {
    int src, dest;
};

int main(int argc, char* argv[]) {
    std::ofstream file(argv[1]);
    int NUM_NODES = std::stoi(argv[2]);
    int NUM_EDGES = std::stoi(argv[3]);

    std::srand(std::time(0));

    std::vector<Edge> edges;
    std::set<std::pair<int, int>> edgeSet;

    for (int i = 0; i < NUM_EDGES; i++) {
        int src, dest;
        do {
            src = std::rand() % NUM_NODES + 1;
            dest = std::rand() % NUM_NODES + 1;
        } while (src == dest || edgeSet.count({src, dest}) > 0);

        Edge edge = {src, dest};
        edges.push_back(edge);
        edgeSet.insert({src, dest});
    }

    if (file.is_open()) {
        file << NUM_NODES << '\n';
        file << NUM_EDGES << '\n';
        for (Edge &edge : edges) {
            file << edge.src << " " << edge.dest << "\n";
        }
        file.close();
    }

    return 0;
}

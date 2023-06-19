#include <iostream>
#include <queue>
#include <vector>
#include <random>
#include <algorithm>
#include <optional>

#include "fheap.hpp"
#include "dijkstra.hpp"

int main(){

    // Fibonacci Heap

    FibonacciHeap<int> heap(3);

    std::vector<int> inserted;
    inserted.push_back(3);
    int len = 100;
    srand(time(NULL));

    for(int i = 0 ; i < len ; ++i) {
        int temp = rand() % 100;
        heap.insert(temp);
        inserted.push_back(temp);
    }

    std::sort(inserted.begin(), inserted.end());

    bool correct = true;
    for(int i = 0; i<inserted.size(); i++){
        if(inserted[i] != heap.extract_min().value()){
            correct = false;
            break;
        }
    }
    if(correct){
        std::cout<<"1. correct\n";
    }
    else{
        std::cout<<"1. wrong\n";
    }

    //Dijkstra's Algorithm
    
    
    edges_t edges1 = {{0, 1, 20.0f}, {0, 3, 21.0f}, {1, 2, 7.0f}, {1, 3, 13.0f}, {1, 4, 5.0f},
     {2, 4, 1.0f}, {3, 4, 10.0f}, {3, 5, 14.0f}, {4, 5, 22.0f}, {4, 6, 15.0f}, {4, 7, 6.0f}, 
     {5, 6, 4.0f}, {6, 7, 11.0f}, {6, 8, 3.0f}, {6, 9, 19.0f}, {7, 8, 2.0f}, {7, 10, 8.0f}, 
     {7, 11, 9.0f}, {8, 9, 18.0f}, {8, 10, 12.0f}, {9, 10, 17.0f}, {10, 11, 16.0f}};

    Graph g1(12, edges1, GraphType::UNDIRECTED);

    std::unordered_map<vertex_t, std::optional<std::tuple<vertex_t, edge_weight_t>>> result
            = dijkstra_shortest_path(g1, 10);

    // Previous vertex of src are not checked.
    //  std::vector<vertex_t> previous = {2, 0, (vertex_t)-1, 2, 1}; 
    //  std::vector<edge_weight_t> dist = {1.0f, 4.0f, 0.0f, 2.0f, 5.0f};


    // The printed result should be same as above.

    for(size_t i = 0 ; i < 12; ++i) {
        if(result[i] != std::nullopt){
            std::cout<<"[vertex i] ";
            std::cout<<"previous: "<<std::get<0>(result[i].value())<<", ";
            std::cout<<"distance: "<<std::get<1>(result[i].value())<<std::endl;
        }
        
    }

    return 0;
    
}
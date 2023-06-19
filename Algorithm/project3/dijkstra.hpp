#ifndef __DIJKSTRA_H_
#define __DIJKSTRA_H_

#include <vector>
#include <unordered_map>
#include <list>
#include <tuple>
#include <queue>
#include <optional>
#include "fheap.hpp"

// A vertex is typed as `vertex_t`. An edge is typed as `edge_t`.
using vertex_t = std::size_t;
using edge_weight_t = float;
using edge_t = std::tuple<vertex_t, vertex_t, edge_weight_t>;
using edges_t = std::vector<edge_t>;

enum class GraphType {
UNDIRECTED,
DIRECTED
};


class Graph {
    public:
        Graph() = delete;
        Graph(const Graph&) = delete;
        Graph(Graph&&) = delete;

        // We assume that if num_vertices is V, a graph contains n vertices from 0 to V-1.
        Graph(size_t num_vertices, const edges_t& edges, GraphType type)
			: num_vertices(num_vertices), type(type) {
			this->num_vertices = num_vertices;
			graph.resize(num_vertices);

			if(type == GraphType::UNDIRECTED) {
				for(auto &edge : edges) {
					const auto& [ from, to, weight ] = edge;
					graph[from].emplace_back(from, to, weight);
					graph[to].emplace_back(to, from, weight);
				}
			} else {
				for(auto &edge : edges) {
					const auto& [ from, to, weight ] = edge;
					graph[from].emplace_back(from, to, weight);
				}
			}
        }

		size_t get_num_vertices() { return num_vertices; }
		std::vector<edge_t> adj_list(vertex_t v) { return graph[v]; }
		
    private:
		size_t num_vertices;
		std::vector<std::vector<edge_t>> graph;
		GraphType type;
};




std::unordered_map<vertex_t, std::optional<std::tuple<vertex_t, edge_weight_t>>>
dijkstra_shortest_path(Graph& g, vertex_t src) {
	
	std::unordered_map<vertex_t, std::optional<std::tuple<vertex_t, edge_weight_t>>> M;

    // std::nullopt if vertex v is not reacheble from the source.
    for(vertex_t v = 0; v < g.get_num_vertices(); v++) M[v] = std::nullopt;
	std::vector<edge_weight_t> dist(g.get_num_vertices(), 1e10);

    // TODO
	dist[src] = 0.0f;
	M[src] = std::make_tuple((vertex_t)-1, dist[src]);
    FibonacciHeap<edge_weight_t> heap = {};
    std::shared_ptr<FibonacciNode<edge_weight_t>>* nodes = new std::shared_ptr<FibonacciNode<edge_weight_t>>[g.get_num_vertices()];
	for(vertex_t v = 0; v < g.get_num_vertices(); v++) {
		nodes[v] = std::make_shared<FibonacciNode<edge_weight_t>>(dist[v]);
		heap.insert(nodes[v]);
	}

	while(!heap.is_empty()) {
		vertex_t u;
		for(vertex_t i = 0; i < g.get_num_vertices(); i++) {
			if(nodes[i].get() == heap.get_min_node()) {
				u = i;
				heap.extract_min();
				break;
			}
		}

		for(auto &edge : g.adj_list(u)) {
			vertex_t v = std::get<1>(edge);
			edge_weight_t weight = std::get<2>(edge);
			if(dist[u] + weight < dist[v]) {
				dist[v] = dist[u] + weight;
				M[v] = std::make_tuple(u, dist[v]);
				heap.decrease_key(nodes[v], dist[v]);
			}
		}
	}

	delete[] nodes;
	return M;
}

#endif // __DIJKSTRA_H_

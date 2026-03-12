module GraphPerformanceLab

export Edge, target, weight,
       AbstractGraph, num_vertices, num_edges, vertices, edges,
       AdjacencyListGraph, CSRGraph,
       dijkstra, dijkstra_indexed,

       random_sparse_graph, random_dense_graph, grid_graph,
       read_graph

# types
include("types/graphs/edge.jl")
include("types/graphs/graph.jl")
include("types/graphs/adjacency_list.jl")
include("types/graphs/csr_graph.jl")
include("types/heaps/indexed_heap.jl")

# algorithms
include("algorithms/shortest_path/dijkstra.jl")

# utilities
include("utils/infinity.jl")

# graph generators and loaders
include("../graphs/generators.jl")
include("../graphs/loaders.jl")

end
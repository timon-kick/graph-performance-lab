module GraphPerformanceLab

export Edge, target, weight,
       AbstractGraph, num_vertices, num_edges, neighbors,
       AdjacencyListGraph, add_edge!,
       dijkstra

# core types
include("types/graphs/edge.jl")
include("types/graphs/graph.jl")
include("types/graphs/adjacency_list.jl")

# algorithms
include("algorithms/shortest_path/dijkstra.jl")

# utilities
include("utils/infinity.jl")

end
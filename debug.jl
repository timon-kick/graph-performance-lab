using GraphPerformanceLab

g = AdjacencyListGraph{Float64}(5)

add_edge!(g, 1, 2, 2.0)
add_edge!(g, 1, 3, 4.0)
add_edge!(g, 2, 3, 1.0)
add_edge!(g, 2, 4, 7.0)
add_edge!(g, 3, 5, 3.0)
add_edge!(g, 4, 5, 1.0)

distances = dijkstra(g, 1)
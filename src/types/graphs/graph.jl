abstract type AbstractGraph{T} end

num_vertices(g::AbstractGraph) = throw(MethodError(num_vertices, (g,)))

num_edges(g::AbstractGraph) = throw(MethodError(num_edges, (g,)))

vertices(g::AbstractGraph) = 1:num_vertices(g)

"""
neighbors(g, v)

Return an AbstractEdge iterator representing
the outgoing edges of vertex `v`.
"""
edges(g::AbstractGraph, v::Int) = throw(MethodError(edges, (g, v)))
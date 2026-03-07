abstract type AbstractGraph{T} end

num_vertices(g::AbstractGraph) = throw(MethodError(num_vertices, (g,)))

num_edges(g::AbstractGraph) = throw(MethodError(num_edges, (g,)))

"""
neighbors(g, v)

Return an iterable AbstractEdge collection representing
the outgoing edges of vertex `v`.
"""
neighbors(g::AbstractGraph, v::Int) = throw(MethodError(neighbors, (g, v)))

vertices(g::AbstractGraph) = 1:num_vertices(g)
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


abstract type AbstractEdge{T} end

target(e::AbstractEdge) = throw(MethodError(target, (e,)))

weight(e::AbstractEdge) = throw(MethodError(weight, (e,)))


struct Edge{T} <: AbstractEdge{T}
    to::Int
    weight::T
end

target(e::Edge) = e.to

weight(e::Edge) = e.weight

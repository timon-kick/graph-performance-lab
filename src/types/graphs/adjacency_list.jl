mutable struct AdjacencyListGraph{T} <: AbstractGraph{T}
    adj::Vector{Vector{Edge{T}}}
    m::Int
end

function AdjacencyListGraph{T}(n::Int) where T
    return AdjacencyListGraph{T}(fill(Vector{Edge{T}}(), n), 0)
end

num_vertices(g::AdjacencyListGraph) = length(g.adj)

num_edges(g::AdjacencyListGraph) = g.m

neighbors(g::AdjacencyListGraph, u::Int) = g.adj[u]

function add_edge!(g::AdjacencyListGraph{T}, u::Int, v::Int, w::T) where T
    push!(g.adj[u], Edge(v, w))
    g.m += 1
end
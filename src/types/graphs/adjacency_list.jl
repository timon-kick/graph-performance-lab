struct AdjacencyListGraph{T} <: AbstractGraph{T}
    adj::Vector{Vector{Edge{T}}}

    function AdjacencyListGraph(n::Int, edge_list::Vector{Tuple{Int, Int, T}}) where T
        adj = [Vector{Edge{T}}() for _ in 1:n]
        for (u, v, w) in edge_list
            push!(adj[u], Edge(v, w))
        end
        new{T}(adj)
    end
end

num_vertices(g::AdjacencyListGraph) = length(g.adj)

edges(g::AdjacencyListGraph, v::Int) = g.adj[v]
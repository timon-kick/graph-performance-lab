# CSR layout graph. Outgoing edges of vertex v are stored in edges[offsets[v] : offsets[v+1] - 1]
struct CSRGraph{T} <: AbstractGraph{T}
    offsets::Vector{Int}
    edges::Vector{Edge{T}}

    function CSRGraph(n::Int, edge_list::Vector{Tuple{Int, Int, T}}) where T
        m = length(edge_list)

        # count outgoing edges
        offsets = zeros(Int, n + 1)
        for (u, _, _) in edge_list
            offsets[u + 1] += 1
        end

        # compute prefix sums
        offsets[1] = 1
        for i in 2:n+1
            offsets[i] += offsets[i - 1]
        end

        # insert edges
        edges = Vector{Edge{T}}(undef, m)
        next_spot = copy(offsets) # used to track next free insertion spot
        for (u, v, w) in edge_list
            edges[next_spot[u]] = Edge{T}(v, w)
            next_spot[u] += 1
        end
        
        new{T}(offsets, edges)
    end
end

num_vertices(g::CSRGraph) = length(g.offsets) - 1

num_edges(g::CSRGraph) = length(g.edges)

edges(g::CSRGraph{T}, u::Int) where T = CSREdgeIter(g.edges, g.offsets[u], g.offsets[u+1] - 1)

struct CSREdgeIter{T}
    edges::Vector{Edge{T}}
    start::Int
    stop::Int
end

function Base.iterate(it::CSREdgeIter, i=it.start)
    i > it.stop && return nothing
    return (it.edges[i], i + 1)
end
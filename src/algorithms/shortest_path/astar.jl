using DataStructures: BinaryMinHeap

# The heuristic function h(v) estimates the distance from a vertex v to the target
# Using the constant function h(v) = 0 reduces A⁺ to Dijkstra
function A⁺(g::AbstractGraph{T}, source::Int, target::Int, h) where T
    n = num_vertices(g)
    dist = fill(infinity(T), n)
    dist[source] = zero(T)

    pq = BinaryMinHeap{Tuple{T, Int}}()
    push!(pq, (h(source), source))

    while !isempty(pq)
        (d_u, u) = pop!(pq)
        u == target && return d_u

        # skip outdated entries
        d_u > dist[u] && continue

        for e in edges(g, u)
            v = target(e)
            d_v = d_u + weight(e)

            if d_v < dist[v]
                dist[v] = d_v
                push!(pq, (d_v + h(v), v))
            end
        end
    end

    return infinity(T)
end

# Heuristic function for grid graphs
function manhattan(v::Int, target::Int, cols::Int)
    x₁, y₁ = (v-1) ÷ cols + 1, (v-1) % cols + 1
    x₂, y₂ = (target-1) ÷ cols + 1, (target-1) % cols + 1
    return abs(x₁ - x₂) + abs(y₁ - y₂)
end

# Heuristic function for road graphs
function euclidean(v::Int, target::Int, coordinates::Vector{Tuple{Float64, Float64}})
    x₁, y₁ = coordinates[v]
    x₂, y₂ = coordinates[target]
    return sqrt((x₁ - x₂)^2 + (y₁ - y₂)^2)
end
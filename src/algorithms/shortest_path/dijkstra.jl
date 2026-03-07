using DataStructures: BinaryMinHeap

function dijkstra(g::AbstractGraph{T}, source::Int) where T
    n = num_vertices(g)
    dist = fill(infinity(T), n)
    dist[source] = zero(T)

    pq = BinaryMinHeap{Tuple{T, Int}}()
    push!(pq, (zero(T), source))

    while !isempty(pq)
        (d_u, u) = pop!(pq)

        # skip outdated entries
        d_u > dist[u] && continue

        for e in neighbors(g, u)
            v = target(e)
            d_v = d_u + weight(e)

            if d_v < dist[v]
                dist[v] = d_v
                push!(pq, (d_v, v))
            end
        end
    end

    return dist
end
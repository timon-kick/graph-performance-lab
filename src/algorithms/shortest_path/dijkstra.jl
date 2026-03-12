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

        for e in edges(g, u)
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

function dijkstra_indexed(g::AbstractGraph{T}, source::Int) where T
    n = num_vertices(g)
    dist = fill(infinity(T), n)
    dist[source] = zero(T)

    pq = IndexedMinHeap{T}(n)
    push!(pq, source, zero(T))

    while !isempty(pq)
        (u, d_u) = pop!(pq)

        for e in edges(g, u)
            v = target(e)
            d_v = d_u + weight(e)

            if d_v < dist[v]
                dist[v] = d_v
                if v in pq
                    decrease!(pq, v, d_v)
                else
                    push!(pq, v, d_v)
                end
            end
        end
    end

    return dist
end
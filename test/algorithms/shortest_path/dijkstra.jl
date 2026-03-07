function random_graph(n::Int, p::Float64=10/n, weight_type=Float64)
    g = AdjacencyListGraph{weight_type}(n)
    for u in 1:n, v in 1:n
        if u != v && rand() < p
            add_edge!(g, u, v, weight_type(rand(1.0:10.0)))
        end
    end
    return g
end

function triangle_inequality(g::AbstractGraph{T}, dist::Vector{T}) where T
    for u in 1:num_vertices(g)
        for e in neighbors(g, u)
            dist[target(e)] ≤ dist[u] + weight(e) + eps(T) || return false
        end
    end
    return true
end

@testset "Dijkstra" begin

    @testset "basic graph" begin
        g = AdjacencyListGraph{Float64}(5)
        add_edge!(g, 1, 2, 2.0)
        add_edge!(g, 1, 3, 4.0)
        add_edge!(g, 2, 3, 1.0)
        add_edge!(g, 2, 4, 7.0)
        add_edge!(g, 3, 5, 3.0)
        add_edge!(g, 4, 5, 1.0)

        dist = dijkstra(g, 1)
        @test dist ≈ [0.0, 2.0, 3.0, 9.0, 7.0]
    end

    @testset "disconnected graph" begin
        g = AdjacencyListGraph{Float64}(3)
        add_edge!(g, 1, 2, 1.0)

        dist = dijkstra(g, 1)
        @test dist ≈ [0.0, 1.0, Inf]
    end

    @testset "single vertex" begin
        g = AdjacencyListGraph{Float64}(1)
        dist = dijkstra(g, 1)

        @test dist == [0.0]
    end

    @testset "random graphs property checks" begin
        for _ in 1:10
            g = random_graph(100)
            dist = dijkstra(g, 1)
            @test triangle_inequality(g, dist)
        end
    end

end
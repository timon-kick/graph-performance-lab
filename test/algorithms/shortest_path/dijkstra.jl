function triangle_inequality(g::AbstractGraph{T}, dist::Vector{T}) where T
    for u in 1:num_vertices(g), e in edges(g, u)
        dist[target(e)] ≤ dist[u] + weight(e) + eps(T) || return false
    end
    return true
end

@testset "Dijkstra" begin

    @testset "small graph" begin
        edges = [
            (1, 2, 2.0),
            (1, 3, 4.0),
            (2, 3, 1.0),
            (2, 4, 7.0),
            (3, 5, 3.0),
            (4, 5, 1.0)
        ]
        
        for algorithm in [dijkstra, dijkstra_indexed], Graph in [AdjacencyListGraph, CSRGraph]
            g = Graph(5, edges)
            dist = algorithm(g, 1)
            @test dist ≈ [0.0, 2.0, 3.0, 9.0, 6.0]
        end
    end

    @testset "disconnected graph" begin
        for algorithm in [dijkstra, dijkstra_indexed], Graph in [AdjacencyListGraph, CSRGraph]
            g = Graph(3, [(1, 2, 1.0)])
            dist = algorithm(g, 1)
            @test dist ≈ [0.0, 1.0, Inf]
        end
    end

    @testset "single vertex" begin
        for algorithm in [dijkstra, dijkstra_indexed], Graph in [AdjacencyListGraph, CSRGraph]
            g = Graph(1, Vector{Tuple{Int, Int, Int}}())
            dist = dijkstra(g, 1)
            @test dist ≈ [0]
        end
    end

    @testset "random graphs" begin
        n = 100
        for _ in 1:10, graph in [random_sparse_graph, random_dense_graph]
            edges = graph(n)
            for Graph in [AdjacencyListGraph, CSRGraph]
                g = Graph(n, edges)
                dist = dijkstra(g, 1)
                dist_indexed = dijkstra_indexed(g, 1)
                @test dist ≈ dist_indexed
                @test triangle_inequality(g, dist)
            end
        end
    end

    @testset "twitter graph" begin
        n, edges = read_graph("snap/congress-twitter.txt")
        for Graph in [AdjacencyListGraph, CSRGraph]
            g = Graph(n, edges)
            dist = dijkstra(g, 1)
            dist_indexed = dijkstra_indexed(g, 1)
            @test dist ≈ dist_indexed
            @test triangle_inequality(g, dist)
        end
    end

end
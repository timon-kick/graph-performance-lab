using StaticArrays

@testset "KD Tree" begin
    points = [SVector(rand(), rand()) for _ in 1:1_000]
    queries = [SVector(rand(), rand()) for _ in 1:1_000]
    tree = KDTree(points)

    for query in queries
        p = nearest_naive(points, query)
        q = nearest(tree, query)
        @test p == q
    end
end
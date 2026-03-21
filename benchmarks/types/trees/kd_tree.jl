using BenchmarkTools
using GraphPerformanceLab
using StaticArrays

function benchmark()
    num_points, num_queries = 100_000, 10_000
    points = [SVector(rand(), rand()) for _ in 1:num_points]
    queries = [SVector(rand(), rand()) for _ in 1:num_queries]
    tree = KDTree(points) # unfair as we don't measure preprocessing time

    println("Naive:")
    @btime begin
        for query in $queries
            nearest_naive($points, query)
        end
    end

    println("\nKD-tree:")
    @btime begin
        for query in $queries
            nearest($tree, query)
        end
    end
end

function benchmark__build_kdtree()
    
end

function benchmark__nearest()

end
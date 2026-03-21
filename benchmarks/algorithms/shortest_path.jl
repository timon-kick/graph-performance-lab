using BenchmarkTools
using GraphPerformanceLab

function benchmark()
    # n, g = 475, read_graph("congress-twitter.txt")
    n = 20_000
    g = random_dense_graph(n)
    adj = AdjacencyListGraph(n, g)
    csr = CSRGraph(n, g)

    println("Lazy Dijkstra, adjacency list:")
    @btime dijkstra($adj, 1)

    println("\nIndexed Dijkstra, adjacency list:")
    @btime dijkstra_indexed($adj, 1)

    println("\nLazy Dijkstra, CSR:")
    @btime dijkstra($csr, 1)

    println("\nIndexed Dijkstra, CSR:")
    @btime dijkstra_indexed($csr, 1)
end
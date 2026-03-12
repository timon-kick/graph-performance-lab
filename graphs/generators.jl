random_graph(n::Int, m::Int) = [(rand(1:n), rand(1:n), rand()) for _ in 1:m]

random_sparse_graph(n::Int) = random_graph(n, 8n)

random_dense_graph(n::Int) = random_graph(n, n^2 ÷ 32)

function grid_graph(rows::Int, columns::Int)
    n = rows * columns
    edges = Vector{Tuple{Int, Int, Int}}()
    sizehint!(edges, 4n)
    index(r, c) = (r-1) * columns + c

    for row in 1:rows, col in 1:columns
        u = index(row, col)
        for (δr, δc) in ((0,1), (1,0), (0,-1), (-1,0)) # 4 neighbors
            r, c = row + δr, col + δc
            if 1 <= r <= rows && 1 <= c <= columns
                v = index(r, c)
                push!(edges, (u, v, 1))
            end
        end
    end

    return edges
end
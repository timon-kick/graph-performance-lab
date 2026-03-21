function read_graph(filename::String, T=Float64)
    path = joinpath(homedir(), "graph-performance-lab", "graphs", "datasets", filename)

    open(path) do io
        n, m = parse.(Int, split(readline(io)))

        edges = map(eachline(io)) do line
            u, v, w = (split(line)..., one(T))
            (parse(Int, u), parse(Int, v), parse(T, w))
        end

        @assert m == length(edges)

        return n, edges
    end
end

# roadnet-pa is undirected
function read_graph(filename::String)
    line_parser = line -> begin
        parts = split(line)
        (parse(Int, parts[1]), parse(Int, parts[2]), parse(Float64, parts[3]))
    end

    path = joinpath(homedir(), "graph-performance-lab", "graphs", "datasets", filename)
    open(path) do io
        map(line_parser, eachline(io))
    end
end
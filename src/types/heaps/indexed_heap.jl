mutable struct IndexedMinHeap{T}
    vertices::Vector{Int} # todo: benchmark vector of (v, dist) tuples against current version
    distances::Vector{T}
    idx::Vector{Int} # idx[v] := index of vertex v in the heap (i.e., vertices and distances), 0 if not present

    function IndexedMinHeap{T}(n::Int) where T
        vertices = Vector{Int}()
        sizehint!(vertices, n)
        distances = Vector{T}()
        sizehint!(distances, n)
        idx = fill(0, n)
        return new{T}(vertices, distances, idx)
    end
end

Base.isempty(h::IndexedMinHeap) = isempty(h.vertices)

Base.length(h::IndexedMinHeap) = length(h.vertices)

Base.in(v::Int, h::IndexedMinHeap) = h.idx[v] != 0

Base.first(h::IndexedMinHeap) = (h.vertices[1], h.distances[1])

function Base.push!(h::IndexedMinHeap{T}, v::Int, dist::T) where T
    _push_last!(h, v, dist);
    _bubble_up!(h, length(h))
end

function _push_last!(h::IndexedMinHeap{T}, v::Int, dist::T) where T
    push!(h.vertices, v)
    push!(h.distances, dist)
    h.idx[v] = length(h)
end

function Base.pop!(h::IndexedMinHeap)
    _swap!(h, 1, length(h))
    top = _pop_last!(h)
    _bubble_down!(h, 1)
    return top
end

function _pop_last!(h::IndexedMinHeap)
    v = pop!(h.vertices)
    dist = pop!(h.distances)
    h.idx[v] = 0
    return (v, dist)
end

function decrease!(h::IndexedMinHeap{T}, v::Int, dist::T) where T
    i = h.idx[v]
    @assert !iszero(i) && dist < h.distances[i]
    h.distances[i] = dist
    _bubble_up!(h, i)
end

function _bubble_up!(h::IndexedMinHeap, i::Int)
    while i > 1
        parent = i ÷ 2
        if h.distances[i] < h.distances[parent]
            _swap!(h, i, parent)
            i = parent
        else
            break
        end
    end
end

function _bubble_down!(h::IndexedMinHeap, i::Int)
    n = length(h)
    while i ≤ n
        left = 2i
        right = 2i + 1
        min = i

        if left ≤ n && h.distances[left] < h.distances[min]
            min = left
        end
        if right ≤ n && h.distances[right] < h.distances[min]
            min = right
        end

        min == i && break

        _swap!(h, i, min)
        i = min
    end
end

function _swap!(h::IndexedMinHeap, i::Int, j::Int)
    h.vertices[i], h.vertices[j] = h.vertices[j], h.vertices[i]
    h.distances[i], h.distances[j] = h.distances[j], h.distances[i]
    h.idx[h.vertices[i]] = i
    h.idx[h.vertices[j]] = j
end
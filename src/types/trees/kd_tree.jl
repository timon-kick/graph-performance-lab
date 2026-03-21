using StaticArrays

struct KDNode{K, T}
    point::SVector{K, T}
    left::Union{KDNode{K, T}, Nothing}
    right::Union{KDNode{K, T}, Nothing}
    axis::Int # we could compute axis = depth % K + 1 on the fly
end

struct KDTree{K, T}
    root::Union{KDNode{K, T}, Nothing}

    KDTree(points::Vector{SVector{K, T}}) where {K, T} = new{K, T}(_build_kdtree!(copy(points), 1, length(points)))
end

function nearest(tree::KDTree{K, T}, target::SVector{K, T}) where {K, T}
    root = tree.root
    root ≡ nothing && return nothing
    _nearest(root, target, root.point, _sqdist(root.point, target))
end

function _build_kdtree!(points::Vector{SVector{K, T}}, depth::Int=0) where {K, T}
    isempty(points) && return nothing

    axis = (depth % K) + 1
    sort!(points, by = p -> p[axis]) # todo: shave off a log factor by using quick select
    mid = length(points) ÷ 2 + 1

    return KDNode(
        points[mid],
        _build_kdtree!(points[1:mid-1], depth + 1), # todo: use in-place partitioning to avoid allocations
        _build_kdtree!(points[mid+1:end], depth + 1),
        axis
    )
end

function _build_kdtree!(points::Vector{SVector{K, T}}, l::Int, r::Int, depth::Int=0) where {K, T}
    l > r && return nothing

    axis = (depth % K) + 1
    mid = (l + r) ÷ 2
    _quick_select!(points, mid, l, r; by = p -> p[axis])

    return KDNode(
        points[mid],
        _build_kdtree!(points, l, mid-1, depth+1),
        _build_kdtree!(points, mid+1, r, depth+1),
        axis)
end

# todo: pass down and return best_dist to avoid computing the same distance multiple times
function _nearest(root::Union{KDNode{K, T}, Nothing}, target::SVector{K, T}, best::SVector{K, T}) where {K, T}
    root ≡ nothing && return best

    if _sqdist(root.point, target) < _sqdist(best, target)
        best = root.point
    end

    axis = root.axis
    diff = target[axis] - root.point[axis]

    # choose branch
    if diff < 0
        first, second = root.left, root.right
    else
        first, second = root.right, root.left
    end

    best = _nearest(first, target, best)

    # check if we need to explore the other branch too
    if diff^2 < _sqdist(best, target)
        best = _nearest(second, target, best)
    end

    return best
end

function _nearest(root::Union{KDNode{K, T}, Nothing}, target::SVector{K, T}, best::SVector{K, T}, best_dist::T) where {K, T}
    root ≡ nothing && return best, best_dist

    d = _sqdist(root.point, target)
    if d < best_dist
        best = root.point
        best_dist = d
    end

    axis = root.axis
    diff = target[axis] - root.point[axis]

    # choose branch
    if diff < 0
        first, second = root.left, root.right
    else
        first, second = root.right, root.left
    end

    best, best_dist = _nearest(first, target, best, best_dist)

    # check if we need to explore the other branch too
    if diff^2 < best_dist
        best, best_dist = _nearest(second, target, best, best_dist)
    end

    return best, best_dist
end

function nearest_naive(points::Vector{SVector{K, T}}, target::SVector{K, T}) where {K, T}
    best = points[1]
    best_dist = _sqdist(best, target)

    for p in points
        d = _sqdist(p, target)
        if d < best_dist
            best = p
            best_dist = d
        end
    end

    return best
end

_sqdist(p::SVector{K, T}, q::SVector{K, T}) where {K, T} = sum(abs2, pᵢ - qᵢ for (pᵢ, qᵢ) in zip(p, q))

function _quick_select!(a, k::Int, l::Int=1, r::Int=length(a); by=identity)
    @assert l ≤ k ≤ r

    while l < r
        pivot_index = _partition!(a, l, r; by=by)

        if k == pivot_index
            return a[k]
        elseif k < pivot_index
            r = pivot_index - 1
        else
            l = pivot_index + 1
        end
    end

    return a[l]
end

function _partition!(a, l::Int, r::Int; by=identity)
    pivot = a[r]
    pivot_val = by(pivot)

    i = l
    for j in l:r-1
        if by(a[j]) ≤ pivot_val
            a[i], a[j] = a[j], a[i]
            i += 1
        end
    end

    a[i], a[r] = a[r], a[i]
    return i
end
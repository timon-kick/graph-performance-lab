abstract type AbstractEdge{T} end

target(e::AbstractEdge) = throw(MethodError(target, (e,)))

weight(e::AbstractEdge) = throw(MethodError(weight, (e,)))


struct Edge{T} <: AbstractEdge{T}
    to::Int
    weight::T
end

target(e::Edge) = e.to

weight(e::Edge) = e.weight

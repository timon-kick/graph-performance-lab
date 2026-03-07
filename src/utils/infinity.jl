infinity(::Type{T}) where {T<:AbstractFloat} = T(Inf)

infinity() = infinity(Float64)
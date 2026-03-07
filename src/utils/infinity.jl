infinity(::Type{T}) where {T<:AbstractFloat} = T(Inf)

infinity(::Type{T}) where {T<:Integer} = typemax(T)
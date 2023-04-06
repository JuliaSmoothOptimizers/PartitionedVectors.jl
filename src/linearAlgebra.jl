import Base.*
import LinearAlgebra.mul!
import LinearAlgebra: norm, dot

function norm(pv::PartitionedVector, p::Real = 2; kwargs...)
  build!(pv; kwargs...)
  _norm = norm(get_v(pv.epv), p)
  return _norm
end

"""
    dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}; kwargs...) where {T}
    dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}, ::Val{true}, ::Val{false}; kwargs...) where {T}
    dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}, ::Val{false}, ::Val{true}; kwargs...) where {T}
    dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}, ::Val{true}, ::Val{true}; kwargs...) where {T}
    dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}, ::Val{false}, ::Val{false}; kwargs...) where {T}

Compute the dot product between two partitioned vectors.
Methods having `Val{true}` and `Val{false}` as parameters compute dedicated `dot` routines depending the usage of `pv1, pv2`.
See the [tutorial](https://juliasmoothoptimizers.github.io/PartitionedVectors.jl/stable/tutorial/) for more details about the usage of a PartitionedVector.
"""
dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}; kwargs...) where {T} =
  dot(pv1, pv2, Val(pv1.simulate_vector), Val(pv2.simulate_vector); kwargs...)

function dot(
  pv1::PartitionedVector{T},
  pv2::PartitionedVector{T},
  ::Val{true},
  ::Val{false};
  kwargs...,
) where {T}
  N = pv1.epv.N
  acc = 0
  for i = 1:N
    eev1 = pv1[i].vec
    eev2 = pv2[i].vec
    acc += dot(eev1, eev2)
  end
  return acc
end

dot(
  pv1::PartitionedVector{T},
  pv2::PartitionedVector{T},
  ::Val{false},
  ::Val{true};
  kwargs...,
) where {T} = dot(pv2, pv1, Val(true), Val(false))

function dot(
  pv1::PartitionedVector{T},
  pv2::PartitionedVector{T},
  ::Val{true},
  ::Val{true};
  kwargs...,
) where {T}
  build!(pv1; kwargs...)
  build!(pv2; kwargs...)
  dot(get_v(pv1.epv), get_v(pv2.epv))
end

function dot(
  pv1::PartitionedVector{T},
  pv2::PartitionedVector{T},
  ::Val{false},
  ::Val{false};
  kwargs...,
) where {T}
  build!(pv1; kwargs...)
  build!(pv2; kwargs...)
  dot(get_v(pv1.epv), get_v(pv2.epv))
end

mul!(res::PartitionedVector, op::AbstractLinearOperator{T}, v::PartitionedVector, α, β) where {T} =
  op.prod!(res, v, α, β)

*(op::AbstractLinearOperator{T}, pv::PartitionedVector) where {T} = mul!(similar(pv; simulate_vector=false), op, pv)

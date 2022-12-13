import Base.*
import LinearAlgebra.mul!
import LinearAlgebra: norm, dot

function norm(pv::PartitionedVector, p::Real = 2; kwargs...)
  build!(pv; kwargs...)
  _norm = norm(get_v(pv.epv), p)
  return _norm
end

dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}; kwargs...) where {T} = dot(pv1, pv2, Val(pv1.simulate_vector), Val(pv2.simulate_vector); kwargs...)

function dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}, ::Val{true}, ::Val{false}; kwargs...) where {T}
  N = pv1.epv.N
  acc = 0
  for i in 1:N
    eev1 = pv1[i].vec
    eev2 = pv2[i].vec
    acc += dot(eev1, eev2)
  end
  return acc
end

dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}, ::Val{false}, ::Val{true}; kwargs...) where {T} = dot(pv2, pv1)

function dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}, ::Val{true}, ::Val{true}; kwargs...) where {T}
  build!(pv1; kwargs...)
  build!(pv2; kwargs...)
  dot(get_v(pv1.epv), get_v(pv2.epv))
end

function dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}, ::Val{false}, ::Val{false}; kwargs...) where {T}
  build!(pv1; kwargs...)
  build!(pv2; kwargs...)
  dot(get_v(pv1.epv), get_v(pv2.epv))
end

mul!(res::PartitionedVector, op::AbstractLinearOperator{T}, v::PartitionedVector, α, β) where {T} =
  op.prod!(res, v, α, β)

*(op::AbstractLinearOperator{T}, pv::PartitionedVector) where {T} = mul!(similar(pv), op, pv)

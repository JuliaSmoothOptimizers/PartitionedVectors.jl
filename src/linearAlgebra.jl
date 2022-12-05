import Base.*
import LinearAlgebra.mul!
import LinearAlgebra: norm, dot

function norm(pv::PartitionedVector, p::Real = 2; kwargs...)
  build!(pv; kwargs...)
  _norm = norm(get_v(pv.epv), p)
  return _norm
end

function dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}; kwargs...) where {T}
  build!(pv1; kwargs...)
  build!(pv2; kwargs...)
  dot(get_v(pv1.epv), get_v(pv2.epv))
end

mul!(res::PartitionedVector, op::AbstractLinearOperator{T}, v::PartitionedVector, α, β) where {T} =
  op.prod!(res, v, α, β)

*(op::AbstractLinearOperator{T}, pv::PartitionedVector) where {T} = mul!(similar(pv), op, pv)

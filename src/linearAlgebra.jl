import LinearAlgebra: norm, dot

function norm(pv::PartitionedVector, p::Real=2)
  build!(pv)
  _norm = norm(get_v(pv.epv), p)
  return _norm
end

function dot(pv1::PartitionedVector{T}, pv2::PartitionedVector{T}) where T
  build!(pv1)
  build!(pv2)
  dot(get_v(pv1.epv), get_v(pv2.epv))
end

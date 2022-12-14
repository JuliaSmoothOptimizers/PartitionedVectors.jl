"""
    partitionedMulOp!(epm::PS.Part_mat, Hv::PartitionedVector, pv_res::PartitionedVector, pv::PartitionedVector, α, β)

Partitioned matrix-vector product for `PartitionedVector`s: `Hv`, `res` and `v`.
"""
function partitionedMulOp!(
  epm::PS.Part_mat,
  Hv::PartitionedVector,
  pv_res::PartitionedVector,
  pv::PartitionedVector,
  α,
  β,
)
  epv = pv.epv
  epv_hv = Hv.epv
  PS.mul_epm_epv!(epv_hv, epm, epv)
  pv_res .= α .* Hv .+ β .* pv_res
  return pv_res
end

function LinearOperators.LinearOperator(epm::Part_mat{T}) where {T}
  n = PS.get_n(epm)
  Hv = PartitionedVector(epv_from_epm(epm))
  Hv.simulate_vector = false
  B = LinearOperator(
    T,
    n,
    n,
    true,
    true,
    (pv_res, pv, α, β) -> partitionedMulOp!(epm, Hv, pv_res, pv, α, β),
  )
  return B
end

"""
    partitionedMulOpVec!(epm::PS.Part_mat{T}, Hv::Vector{T}, res::Vector{T}, v::Vector{T}, α, β;

Partitioned matrix-vector product for `Vector`s: `Hv`, `res` and `v`.
Made to test `LinearOperators.LinearOperator(epm::Part_mat{T})` (which relies on `PartitionedVector`s).
"""
function partitionedMulOpVec!(
  epm::PS.Part_mat{T},
  Hv::Vector{T},
  res::Vector{T},
  v::Vector{T},
  α,
  β;
  epv = epv_from_epm(epm),
  epv_hv = epv_from_epm(epm),
) where {T}
  epv_from_v!(epv, v)
  PS.mul_epm_epv!(epv_hv, epm, epv)
  build_v!(epv_hv)
  Hv .= epv_hv.v
  res .= α .* Hv .+ β .* res
  return res
end

"""
    lo = LinearOperator_for_Vector(epm::Part_mat{T})

Return the linear-operator `lo` which use a partitioned-matrix and `Vector`s.
"""
function LinearOperator_for_Vector(epm::Part_mat{T}) where {T}
  n = PS.get_n(epm)
  Hv = Vector{T}(undef, n)
  epv = epv_from_epm(epm)
  epv_hv = epv_from_epm(epm)
  B = LinearOperator(
    T,
    n,
    n,
    true,
    true,
    (res, v, α, β) -> partitionedMulOpVec!(epm, Hv, res, v, α, β; epv, epv_hv),
  )
  return B
end

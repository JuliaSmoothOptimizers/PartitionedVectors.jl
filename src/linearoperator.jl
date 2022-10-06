import LinearAlgebra.mul!

function partitionedMulOp!(epm, Hv::PartitionedVector, pv_res::PartitionedVector, pv::PartitionedVector, α, β)
  epv = pv.epv
  epv_hv = Hv.epv
  PS.mul_epm_epv!(epv_hv, epm, epv)
  pv_res .= α .* Hv .+ β .* pv_res
  return pv_res
end

function LinearOperators.LinearOperator(epm::Part_mat{T}) where T
  n = PS.get_n(epm)
  Hv = PartitionedVector(epv_from_epm(epm))
  Hv.simulate_vector = false
  B = LinearOperator(T, n, n, true, true, (pv_res, pv, α, β) -> partitionedMulOp!(epm, Hv, pv_res, pv, α, β))
  return B
end

mul!(res::PartitionedVector, op::AbstractLinearOperator{T}, v::PartitionedVector, α, β) where {T} = op.prod!(res, v, α, β)
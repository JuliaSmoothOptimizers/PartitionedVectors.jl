import LinearAlgebra.mul!

function partitionedMulOp!(epm, pv_res::PartitionedVector, pv::PartitionedVector, α, β)
  epv = pv.epv
  epv_res = pv_res.epv
  PS.mul_epm_epv!(epv_res, epm, epv)
  pv_res.vec .= PartitionedStructures.get_v(epv_res)
  PS.build_v!(epv_res)
  mul!(pv_res.vec, I, PartitionedStructures.get_v(epv_res), α, β)
  return pv_res
end

function LinearOperators.LinearOperator(epm::Part_mat{T}) where T
  n = PS.get_n(epm)
  B = LinearOperator(T, n, n, true, true, (pv_res, pv, α, β) -> partitionedMulOp!(epm, pv_res, pv, α, β))
  return B
end

function mul!(res::PartitionedVector, op::AbstractLinearOperator{T}, v::PartitionedVector, α, β) where {T}
  op.prod!(res, v, α, β)
end

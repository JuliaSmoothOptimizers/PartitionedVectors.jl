@testset "Partitioned linear-operator" begin
  N = 5
  n = 8
  element_variables = [ [1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7], [5, 6, 8], Int[]]

  epv = PS.create_epv(element_variables; n)
  pv = PartitionedVector(element_variables; n)

  epm = PS.epm_from_epv(epv)
  PS.update!(epm, epv, 2. * epv; verbose=false)
  pm_pv = LinearOperators.LinearOperator(epm)
  pm_v = LinearOperator_for_Vector(epm)

  pv .= 1.
  vones = ones(n)

  res = similar(pv; simulate_vector=false)
  res .= 0
  mul!(res, pm_pv, pv)
  vres = similar(vones)
  vres .= 0
  mul!(vres, pm_v, vones)
  @test Vector(res) == vres
end

@testset "Krylov cg" begin
  N = 5
  n = 8
  element_variables = [ [1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7], [5, 6, 8], Int[]]

  epv = PS.create_epv(element_variables; type=Float32, n)
  pv_x = PartitionedVector(element_variables; T=Float32, n)

  pv_gradient = PartitionedVector(element_variables; T=Float32, n)

  epm = PS.epm_from_epv(epv)
  PS.update!(epm, epv, Float32(2.) * epv; verbose=false)
  lo_epm = LinearOperators.LinearOperator(epm)

  solver = Krylov.CgSolver(pv_x)

  pv_gradient = PartitionedVector(element_variables; T=Float32, n)
  # pv_gradient .= Float32(10.) .* pv_gradient
  for i in 1:N
    nie = pv_gradient[i].nie
    pv_gradient[i] = rand(Float32, nie)
  end

  Krylov.solve!(
    solver,
    lo_epm,
    -pv_gradient
  )

  x = Vector(solution(solver))
  g = Vector(pv_gradient)
  A = Matrix(epm)

  @test norm(A*x + g) <= 1e-2 * norm(g)

  grad = Vector(pv_gradient)
  pm_v = LinearOperator_for_Vector(epm)
  solver_vector = Krylov.CgSolver(pm_v, grad)

  Krylov.solve!(
    solver_vector,
    pm_v,
    -grad
  )

  x_vector = solution(solver_vector)

  @test x_vector ≈ x
end
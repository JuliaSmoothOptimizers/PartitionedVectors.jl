@testset "Krylov cg" begin
  N = 5
  n = 8
  element_variables = [ [1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7], [5, 6, 8], Int[]]

  epv = PS.create_epv(element_variables; type=Float32, n)
  pv_x = PartitionedVector(element_variables; T=Float32, n)

  pv_gradient = PartitionedVector(element_variables; T=Float32, n)

  epm = PS.epm_from_epv(epv)
  PS.update!(epm, epv, Float32(2.) * epv)
  lo_epm = LinearOperators.LinearOperator(epm)

  solver = Krylov.CgSolver(pv_x)

  pv_gradient = PartitionedVector(element_variables; T=Float32, n)
  pv_gradient .= Float32(10.) .* pv_gradient

  Krylov.solve!(
    solver,
    lo_epm,
    -pv_gradient
  )

  x = Vector(solution(solver))
  g = Vector(pv_gradient)
  A = Matrix(epm)

  @test norm(A*x + g) <= 1e-2 * norm(g)

end

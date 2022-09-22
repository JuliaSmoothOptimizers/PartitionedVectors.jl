@testset "Krylov cg" begin
  N = 15
  n = 20
  nie = 5
  element_variables =
    vcat(map((i -> sample(1:n, nie, replace = false)), 1:(N -4)), [[1:5;], [6:10;], [11:15;], [16:20;]])
  
  epv = PS.create_epv(element_variables; type=Float32)
  pv_x = PartitionedVector(element_variables; T=Float32)
  
  pv_gradient = PartitionedVector(element_variables; T=Float32)
  
  epm = PS.epm_from_epv(epv)
  PS.update!(epm, epv, Float32(2.) * epv)
  lo_epm = LinearOperators.LinearOperator(epm)
  
  solver = CgSolver(pv_x)
  
  pv_gradient = PartitionedVector(element_variables; T=Float32)
  pv_gradient .= 10 .* pv_gradient
  
  cg!(solver, lo_epm, -pv_gradient; verbose=1)
  
  x = Vector(solution(solver))
  g = Vector(pv_gradient)
  A = Matrix(epm)
  
  @test norm(A*x + g) <= 1e-2 * norm(g)
end

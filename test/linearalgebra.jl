@testset "LinearAlgebra" begin
  N = 5
  n = 8
  element_variables = [[1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7], [5, 6, 8], Int[]]

  pv1 = PartitionedVector(element_variables; simulate_vector = true, n)
  pv2 = PartitionedVector(element_variables; simulate_vector = false, n)

  pv1 .= 1
  pv2 .= 1

  @test norm(pv1) != norm(pv2)

  @test norm(pv1) == norm(Vector(pv1))
  @test norm(pv1) == sqrt(8)

  @test norm(pv2) == norm(Vector(pv2))
  @test norm(pv2) == sqrt(30)

  @test dot(pv1, pv1) ≈ norm(pv1)^2
  @test dot(pv2, pv2) == norm(pv2)^2

  @test dot(pv1, pv2) == dot(Vector(pv1), Vector(pv2))
  @test dot(pv2, pv1) == dot(Vector(pv1), Vector(pv2))
  @test dot(pv1, pv1) == dot(Vector(pv1), Vector(pv1))
  @test dot(pv2, pv2) == dot(Vector(pv2), Vector(pv2))
end

@testset "LinearOperator" begin
  N = 5
  n = 8
  element_variables = [[1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7], [5, 6, 8], Int[]]

  pv = PartitionedVector(element_variables; n)

  epm = PS.identity_epm(element_variables; n)
  lo = LinearOperators.LinearOperator(epm)

  Vector(lo * pv) == Matrix(epm) * Vector(pv)

  res = similar(pv)
  mul!(res, lo, pv)
  @test (@allocated mul!(res, lo, pv)) == 0
end

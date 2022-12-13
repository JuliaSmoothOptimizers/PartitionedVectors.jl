@testset "Base and broadcast" begin
  N = 15
  n = 20
  nie = 5
  element_variables = vcat(
    map((i -> sample(1:n, nie, replace = false)), 1:(N - 4)),
    [[1:5;], [6:10;], [11:15;], [16:20;]],
  )

  epv = PS.create_epv(element_variables; type = Float32)
  _pv32 = PartitionedVector(epv)
  pv32 = PartitionedVector(element_variables; T = Float32)

  pv64 = PartitionedVector(element_variables)

  pv_number = similar(pv32)
  pv_number .= 1

  pv_sim = similar(pv32)
  pv_sim .= 1
  @test pv_sim == pv_number

  pv_sim .= 0
  @test pv_sim != pv_number

  pv_res = copy(pv_sim)

  pv_sim .= pv32 .+ pv32
  pv_res .= 2 .* pv32
  @test pv_sim == pv_res
  @test pv32 .+ pv32 == 2 .* pv32

  pv_sim .= .-pv32
  pv_res .= -1 .* pv32
  @test pv_sim == pv_res

  pv_sim .= pv32 .- pv32
  pv_res .= 0 .* pv32
  @test pv_sim == pv_res

  @test 2 * pv32 == pv32 + pv32
  @test -pv32 == -1 * pv32
  @test pv32 - pv32 == 0 * pv32

  pv32 .= 0
  @test Vector(pv32) == zeros(Float32, n)

  @testset "other methods" begin
    @test firstindex(pv32) == 1
    @test lastindex(pv32) == N

    show(pv32)
  end
end

@testset "set! " begin
  # src/struct.jl
  N = 5
  n = 8
  element_variables = [[1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7], [5, 6, 8], Int[]]

  pv = PartitionedVector(element_variables; simulate_vector = true, n)

  v = rand(n)

  set!(pv, v)
  @test Vector(pv) == v

  pv .= 1
  @test Vector(pv) == ones(n)
end

@testset "warning build" begin
  N = 5
  n = 8
  element_variables = [[1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7], [5, 6, 4], Int[]]

  pv = PartitionedVector(element_variables; simulate_vector = true, n)

  build!(pv)
end

@testset "disabling warning build" begin
  N = 5
  n = 8
  element_variables = [[1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7], [5, 6, 4], Int[]]

  pv = PartitionedVector(element_variables; simulate_vector = true, n)

  build!(pv; warn = false)
  norm(pv; warn = false)
  dot(pv, pv; warn = false)

  pv = PartitionedVector(element_variables; n)

  build!(pv; warn = false)
  norm(pv; warn = false)
  dot(pv, pv; warn = false)
end

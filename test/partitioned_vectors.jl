@testset "Base and broadcast" begin
  N = 15
  n = 20
  nie = 5
  element_variables =
    vcat(map((i -> sample(1:n, nie, replace = false)), 1:(N -4)), [[1:5;], [6:10;], [11:15;], [16:20;]])
  
  epv = PS.create_epv(element_variables; type=Float32)
  _pv32 = PartitionedVector(epv)
  pv32 = PartitionedVector(element_variables; T=Float32)
  
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
  
  pv_sim .= .- pv32
  pv_res .= -1 .* pv32
  @test pv_sim == pv_res

  pv_sim .= pv32 .- pv32
  pv_res .= 0 .* pv32
  @test pv_sim == pv_res

  @test 2 * pv32 == pv32 + pv32
  @test - pv32 == -1 * pv32
end

@testset "Vector interface" begin
  N = 15
  n = 20
  nie = 5
  element_variables =
    vcat(map((i -> sample(1:n, nie, replace = false)), 1:(N -4)), [[1:5;], [6:10;], [11:15;], [16:20;]])

  pv = PartitionedVector(element_variables)
  pv[1] = 1.
  @test (@allocated pv[1] = 1.) == 0
  @test PS.get_vec(pv[1]) == ones(nie)

  pvsim = similar(pv)
  pvsim[2] = pv[2]
  @test (@allocated pvsim[2] = pv[2]) == 0
  @test pvsim[2] == pv[2]

  rand_nie = rand(nie)
  pv[3] = rand_nie
  @test (@allocated pv[3] = rand_nie) == 0
  PS.get_vec(pv[3]) == rand_nie
end
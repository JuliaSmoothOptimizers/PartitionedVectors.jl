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
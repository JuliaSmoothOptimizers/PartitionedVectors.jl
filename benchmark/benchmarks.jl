using BenchmarkTools
using Kylov, LinearAlgebra
using PartitionedVectors

const SUITE = BenchmarkGroup()

N = 5
n = 8
element_variables = [[1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7], [5, 6, 8], Int[]]

epv = PS.create_epv(element_variables; type = Float32, n)
pv_x = PartitionedVector(element_variables; T = Float32, n)

epm = PS.epm_from_epv(epv)
PS.update!(epm, epv, Float32(2.0) * epv; verbose = false)
lo_epm = LinearOperators.LinearOperator(epm)

solver = Krylov.CgSolver(pv_x)

pv_gradient = PartitionedVector(element_variables; T = Float32, n)
for i = 1:N
  nie = pv_gradient[i].nie
  pv_gradient[i] = rand(Float32, nie)
end

res = similar(pv_x)

Krylov.solve!(solver, lo_epm, -pv_gradient)
SUITE["Krylov small PartitionedVectors"] = BenchmarkGroup()
SUITE["Krylov small PartitionedVectors"] = @benchmarkable Krylov.solve!(solver, lo_epm, -pv_gradient)

SUITE["small broadcast"] = BenchmarkGroup()
SUITE["small broadcast"] = @benchmarkable res .= pv_gradient .+ 3 .* pv_gradient


N = 1500
n = 20000
nie = 15
element_variables = map((i -> sample(1:n, nie, replace = false)), 1:N)

epv = PS.create_epv(element_variables; type = Float32, n)
pv_x = PartitionedVector(element_variables; T = Float32, n)

epm = PS.epm_from_epv(epv)
PS.update!(epm, epv, Float32(2.0) * epv; verbose = false)
lo_epm = LinearOperators.LinearOperator(epm)

solver = Krylov.CgSolver(pv_x)

pv_gradient = PartitionedVector(element_variables; T = Float32, n)
for i = 1:N
  nie = pv_gradient[i].nie
  pv_gradient[i] = rand(Float32, nie)
end

res = similar(pv_x)

Krylov.solve!(solver, lo_epm, -pv_gradient)
SUITE["Krylov big PartitionedVectors"] = BenchmarkGroup()
SUITE["Krylov big PartitionedVectors"] = @benchmarkable Krylov.solve!(solver, lo_epm, -pv_gradient)

SUITE["big broadcast"] = BenchmarkGroup()
SUITE["big broadcast"] = @benchmarkable res .= pv_gradient .+ 3 .* pv_gradient

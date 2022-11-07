using Test
using StatsBase, LinearAlgebra
using Krylov, LinearOperators, PartitionedStructures
using PartitionedVectors
const PS = PartitionedStructures

include("base.jl")
include("linearalgebra.jl")
include("partitioned_vectors.jl")
include("krylov.jl")
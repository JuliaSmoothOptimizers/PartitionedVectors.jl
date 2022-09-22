using Test
using StatsBase, LinearAlgebra
using Krylov, LinearOperators, PartitionedStructures
using PartitionedVectors

const PS = PartitionedStructures

include("partitioned_vectors.jl")
include("krylov.jl")
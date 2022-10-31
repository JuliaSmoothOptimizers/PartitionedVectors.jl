module PartitionedVectors

using LinearAlgebra
using Krylov, LinearOperators, PartitionedStructures
const PS = PartitionedStructures

using ..PartitionedStructures: M_elt_vec, M_abstract_element_struct, M_part_v, M_abstract_part_struct, ModElemental_pv, ModElemental_ev, M_part_mat

export PartitionedVector
export build!, set!

export LinearOperator_for_Vector

include("struct.jl")

include("base.jl")
include("broadcast.jl")
include("linearAlgebra.jl")
include("linearoperator.jl")

include("krylov.jl")

end 
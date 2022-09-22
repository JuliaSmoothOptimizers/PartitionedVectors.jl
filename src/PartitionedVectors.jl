module PartitionedVectors

using LinearAlgebra

using PartitionedStructures
const PS = PartitionedStructures

using ..PartitionedStructures: M_elt_vec, M_abstract_element_struct, M_part_v, M_abstract_part_struct, ModElemental_pv, ModElemental_ev

export PartitionedVector
export build!

include("struct.jl")

include("base.jl")
include("broadcast.jl")
include("linearAlgebra.jl")

include("krylov.jl")

end 
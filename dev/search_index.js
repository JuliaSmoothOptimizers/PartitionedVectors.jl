var documenterSearchIndex = {"docs":
[{"location":"reference/#Reference","page":"Reference","title":"Reference","text":"","category":"section"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/#Contents","page":"Reference","title":"Contents","text":"","category":"section"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"Pages = [\"reference.md\"]","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/#Index","page":"Reference","title":"Index","text":"","category":"section"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"Pages = [\"reference.md\"]","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"Modules = [PartitionedVectors]","category":"page"},{"location":"reference/#PartitionedVectors.PartitionedVector","page":"Reference","title":"PartitionedVectors.PartitionedVector","text":"PartitionedVector{T} <: AbstractPartitionedVector{T}\n\nWrap PartitionedStructures.Elemental_pv to define a struct which behave almost as a AbstractVector.\n\n\n\n\n\n","category":"type"},{"location":"reference/#PartitionedVectors.build!-Tuple{PartitionedVector}","page":"Reference","title":"PartitionedVectors.build!","text":"build!(pv::PartitionedVector)\n\nSet in place of pv.epv.v the value of the Vector pv represents.\n\n\n\n\n\n","category":"method"},{"location":"reference/#PartitionedVectors.partitionedMulOp!-Tuple{PartitionedStructures.M_part_mat.Part_mat, PartitionedVector, PartitionedVector, PartitionedVector, Any, Any}","page":"Reference","title":"PartitionedVectors.partitionedMulOp!","text":"partitionedMulOp!(epm::PS.Part_mat, Hv::PartitionedVector, pv_res::PartitionedVector, pv::PartitionedVector, α, β)\n\nPartitioned matrix-vector product for PartitionedVectors: Hv, res and v.\n\n\n\n\n\n","category":"method"},{"location":"reference/#PartitionedVectors.partitionedMulOpVec!-Union{Tuple{T}, Tuple{PartitionedStructures.M_part_mat.Part_mat{T}, Vector{T}, Vector{T}, Vector{T}, Any, Any}} where T","page":"Reference","title":"PartitionedVectors.partitionedMulOpVec!","text":"partitionedMulOpVec!(epm::PS.Part_mat{T}, Hv::Vector{T}, res::Vector{T}, v::Vector{T}, α, β;\n\nPartitioned matrix-vector product for Vectors: Hv, res and v. Test purpose.\n\n\n\n\n\n","category":"method"},{"location":"reference/#PartitionedVectors.set!-Union{Tuple{T}, Tuple{PartitionedVector{T}, Vector{T}}} where T","page":"Reference","title":"PartitionedVectors.set!","text":"set!(pv::PartitionedVector{T}, v::Vector{T})\n\nSet inplace pv such that each element values Uᵢv.\n\n\n\n\n\n","category":"method"},{"location":"#PartitionedVectors.jl","page":"Home","title":"PartitionedVectors.jl","text":"","category":"section"},{"location":"tutorial/#PartitionedVectors.jl-Tutorial","page":"Tutorial","title":"PartitionedVectors.jl Tutorial","text":"","category":"section"}]
}

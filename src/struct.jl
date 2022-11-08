"""
    AbstractPartitionedVector{T} <: DenseVector{T}

Abstract type for `PartitionedVector<:AbstractPartitionedVector{T}`.
Krylov.jl requires `PartitionedVector<:DenseVector{T}`.
"""
abstract type AbstractPartitionedVector{T} <: DenseVector{T} end # for Krylov

"""
    PartitionedVector{T} <: AbstractPartitionedVector{T}

Wrap `PartitionedStructures.Elemental_pv` to behave almost as an `AbstractVector`.
"""
mutable struct PartitionedVector{T} <: AbstractPartitionedVector{T}
  epv::Elemental_pv{T}
  vec::Vector{T}
  simulate_vector::Bool
end

function PartitionedVector(eevar::Vector{Vector{Int}}; T::DataType=Float64, simulate_vector::Bool=false, kwargs...)
  epv = create_epv(eevar; type=T, kwargs...)
  vec = Vector{T}(undef, PS.get_n(epv))
  pv = PartitionedVector{T}(epv, vec, simulate_vector)
  return pv
end 

function PartitionedVector(epv::Elemental_pv{T}; simulate_vector::Bool=false, kwargs...) where T
  vec = Vector{T}(undef, PS.get_n(epv))
  pv = PartitionedVector{T}(epv, vec, simulate_vector)
  return pv
end

"""
    build!(pv::PartitionedVector)
    
Set in place of `pv.epv.v` the `Vector` that `pv` represents.
If `pv.simulate=false`, it aggregates contributions from elemental vectors.
If `pv.simulate=true`, common variables among element vectors value the same.
For each index 1 ≤ `i` ≤ n, , `build!` will take the first element containing `i` and sets `pv.epv.v[i]` to its value.
"""
build!(pv::PartitionedVector) = build!(pv, Val(pv.simulate_vector))

build!(pv::PartitionedVector, ::Val{false}) = build_v!(pv.epv)

function build!(pv::PartitionedVector, ::Val{true}) 
  epv = pv.epv
  vec = epv.v
  component_list = epv.component_list
  for i in 1:length(vec)
    if !isempty(component_list[i])
      index_element = component_list[i][1]
      eev = PS.get_eev_set(epv, index_element)
      val = PS.get_vec_from_indices(eev, i)
      vec[i] = val
    end
  end
  return pv
end

"""
    set!(pv::PartitionedVector{T}, v::Vector{T})

Set inplace `pv` such that each element values Uᵢv.
"""
set!(pv::PartitionedVector{T}, v::Vector{T}) where T = set!(pv, v, Val(pv.simulate_vector))

function set!(pv::PartitionedVector{T}, v::Vector{T}, ::Val{true}) where T
  epv = pv.epv
  epv_from_v!(epv, v)
  return pv
end
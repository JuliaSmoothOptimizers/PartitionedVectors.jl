abstract type AbstractPartitionedVector{T} <: DenseVector{T} end # for Krylov 

mutable struct PartitionedVector{T} <: AbstractPartitionedVector{T}
  epv::Elemental_pv{T}
  vec::Vector{T}
  simulate_vector::Bool
end

function PartitionedVector(eevar::Vector{Vector{Int}}; T::DataType=Float64, simulate_vector::Bool=false)
  epv = create_epv(eevar; type=T)
  vec = Vector{T}(undef, PS.get_n(epv))
  pv = PartitionedVector{T}(epv, vec, simulate_vector)
  return pv
end 

function PartitionedVector(epv::Elemental_pv{T}; simulate_vector::Bool=false) where T
  vec = Vector{T}(undef, PS.get_n(epv))
  pv = PartitionedVector{T}(epv, vec, simulate_vector)
  return pv
end

build!(pv::PartitionedVector) = build!(pv, Val(pv.simulate_vector))

build!(pv::PartitionedVector, ::Val{false}) = build_v!(pv.epv)

function build!(pv::PartitionedVector, ::Val{true}) 
  epv = pv.epv
  vec = epv.v
  component_list = epv.component_list
  for i in 1:length(vec)
    index_element = component_list[i][1]
    eev = PS.get_eev_set(epv, index_element)
    val = PS.get_vec_from_indices(eev, i)
    vec[i] = val
  end
  return pv
end
import Base: +, -, ==, *
import Base: copy, similar
import Base: show, size, length, getindex, setindex!, firstindex, lastindex

length(pv::PartitionedVector) = PS.get_n(pv.epv)
size(pv::PartitionedVector) = (PS.get_N(pv.epv),)

show(pv::PartitionedVector) = show(stdout, pv)
show(io::IO, ::MIME"text/plain", pv::PartitionedVector) = show(io, pv)

function show(io::IO, pv::PartitionedVector)
  println(io, typeof(pv))
  show(io, get_v(pv.epv))
  return nothing
end

"""
    element_vector = getindex(pv::PartitionedVector, i::Int)

Return the `i`-th element of `pv`, e.g. the `i`-th element vector.
"""
getindex(pv::PartitionedVector, inds...) = PS.get_eev_set(pv.epv)[inds...]

"""
    setindex!(pv::PartitionedVector, val::Elemental_elt_vec, index::Int)
    setindex!(pv::PartitionedVector{T}, val::T, index::Int) where T<:Number
    setindex!(pv::PartitionedVector{T}, val::Vector{T}, index::Int) where T<:Number

Set `pv[index]` (e.g. the `index`-th element vector) to `val`.
"""
function setindex!(pv::PartitionedVector, eev::Elemental_elt_vec, index::Int)
  get_eev_value(pv.epv, index) .= PS.get_vec(eev)
  return pv
end

function setindex!(pv::PartitionedVector{T}, val::T, index::Int) where {T <: Number}
  get_eev_value(pv.epv, index) .= val
  return pv
end

function setindex!(pv::PartitionedVector{T}, val::Vector{T}, index::Int) where {T <: Number}
  get_eev_value(pv.epv, index) .= val
  return pv
end

firstindex(pv::PartitionedVector) = PS.get_N(pv.epv) > 0 ? 1 : 0
lastindex(pv::PartitionedVector) = PS.get_N(pv.epv)

function (+)(pv1::PartitionedVector, pv2::PartitionedVector)
  epv1 = pv1.epv
  epv2 = pv2.epv
  _epv = (+)(epv1, epv2)
  simulate_vector = min(pv1.simulate_vector, pv2.simulate_vector)
  return PartitionedVector(_epv; simulate_vector)
end

function (-)(pv1::PartitionedVector, pv2::PartitionedVector)
  epv1 = pv1.epv
  epv2 = pv2.epv
  _epv = (-)(epv1, epv2)
  simulate_vector = min(pv1.simulate_vector, pv2.simulate_vector)
  return PartitionedVector(_epv; simulate_vector)
end

function (-)(pv::PartitionedVector)
  epv = pv.epv
  _epv = (-)(epv)
  simulate_vector = pv.simulate_vector
  return PartitionedVector(_epv; simulate_vector)
end

function (*)(pv::PartitionedVector{Y}, val::T) where {Y <: Number, T <: Number}
  epv = pv.epv
  _epv = (*)(epv, val)
  simulate_vector = pv.simulate_vector
  return PartitionedVector(_epv; simulate_vector)
end

(*)(val::T, pv::PartitionedVector{Y}) where {Y <: Number, T <: Number} = (*)(pv, val)

function (==)(pv1::PartitionedVector, pv2::PartitionedVector)
  epv1 = pv1.epv
  epv2 = pv2.epv
  return (==)(epv1, epv2)
end

copy(pv::PartitionedVector{T}; simulate_vector::Bool = pv.simulate_vector) where {T <: Number} =
  PartitionedVector{T}(copy(pv.epv), simulate_vector)
similar(pv::PartitionedVector{T}; simulate_vector::Bool = pv.simulate_vector) where {T <: Number} =
  PartitionedVector{T}(similar(pv.epv), simulate_vector)

function Base.Vector(pv::PartitionedVector{T}; kwargs...) where {T}
  build!(pv; kwargs...)
  vector = pv.epv.v
  return Vector{T}(copy(vector))
end

Base.broadcastable(pv::PartitionedVector) = pv

struct PartitionedVectorStyle <: Base.Broadcast.BroadcastStyle end

Base.BroadcastStyle(::Type{PartitionedVector{T}}) where {T} = PartitionedVectorStyle()

Base.BroadcastStyle(::PartitionedVectorStyle, ::Base.Broadcast.BroadcastStyle) =
  PartitionedVectorStyle()
Base.BroadcastStyle(::Base.Broadcast.BroadcastStyle, ::PartitionedVectorStyle) =
  PartitionedVectorStyle()


Base.copyto!(
  dest::PartitionedVector{Y},
  bc::Base.Broadcast.Broadcasted{PartitionedVectorStyle},
) where {Y<:Number} = Base.copyto!(dest, bc, Val(dest.simulate_vector))

function Base.copyto!(
  dest::PartitionedVector{Y},
  bc::Base.Broadcast.Broadcasted{PartitionedVectorStyle},
  ::Val{false}
) where {Y<:Number}
  # element wise broacast
  bcf = Base.Broadcast.flatten(bc)
  for i in bcf.axes[1]
    filtered = _filter_element_vector(i, bcf.args)
    dest[i].vec .= bcf.f.(filtered...)
  end

  return dest
end

function Base.copyto!(
  dest::PartitionedVector{Y},
  bc::Base.Broadcast.Broadcasted{PartitionedVectorStyle},
  ::Val{true}
) where {Y<:Number}  
  bcf = Base.Broadcast.flatten(bc)  
  filtered = _filter_vector(bcf.args)
  dest.epv.v .= bcf.f.(filtered...)
  epv_from_v!(dest.epv, dest.epv.v)
  return dest
end

Base.copyto!(
  dest::PartitionedVector{Y},
  bc::Base.Broadcast.Broadcasted{T},
) where {Y<:Number,T<:Base.Broadcast.AbstractArrayStyle{0}} = Base.copyto!(dest, bc, Val(dest.simulate_vector))

function Base.copyto!(
  dest::PartitionedVector{Y},
  bc::Base.Broadcast.Broadcasted{T},
  ::Val{false}
) where {Y<:Number,T<:Base.Broadcast.AbstractArrayStyle{0}}
  # element wise broacast
  bcf = Base.Broadcast.flatten(bc)
  for i in bcf.axes[1]
    filtered = _filter_element_vector(i, bcf.args)
    dest[i].vec .= bcf.f.(filtered...)
  end
  return dest
end

function Base.copyto!(
  dest::PartitionedVector{Y},
  bc::Base.Broadcast.Broadcasted{T},
  ::Val{true}
) where {Y<:Number,T<:Base.Broadcast.AbstractArrayStyle{0}}
  bcf = Base.Broadcast.flatten(bc)    
  filtered = _filter_vector(bcf.args)
  dest.epv.v .= bcf.f.(filtered...)
  epv_from_v!(dest.epv, dest.epv.v)
  return dest
end

# Select the i-th argument if needed in a Tuple of arguments
"""
    _filter_element_vector(i::Int, arg::Tuple{})
    element_vector = _filter_element_vector(i::Int, arg::PartitionedVector)
    _filter_element_vector(i::Int, arg::Any)
    _filter_element_vector(i::Int, args::Tuple)

Pass through a `Tuple` to select the `i`-th element if necessary.
"""
_filter_element_vector(i::Int, arg::Tuple{}) = ()
_filter_element_vector(i::Int, arg::PartitionedVector) = arg[i].vec
_filter_element_vector(i::Int, arg::Any) = arg
_filter_element_vector(i::Int, args::Tuple) = (_filter_element_vector(i, args[1]), _filter_element_vector(i, Base.tail(args))...)

# Select the vector of the i-th PartitionedVector argument if needed in a Tuple of arguments
"""
    _filter_vector(arg::Tuple{})
    vector = _filter_vector(arg::PartitionedVector)
    _filter_vector(arg::Any)
    _filter_vector(args::Tuple)

Pass through a `Tuple` to select the `i`-th element if necessary.
"""
_filter_vector(arg::Tuple{}) = ()
_filter_vector(arg::PartitionedVector) = _filter_vector(arg::PartitionedVector, Val(arg.simulate_vector))
_filter_vector(arg::PartitionedVector, ::Val{true}) = arg.epv.v
_filter_vector(arg::PartitionedVector, ::Val{false}) = begin build!(arg); arg.epv.v end
_filter_vector(arg::Any) = arg
_filter_vector(args::Tuple) = (_filter_vector(args[1]), _filter_vector(Base.tail(args))...)

function Base.similar(
  bc::Base.Broadcast.Broadcasted{PartitionedVectorStyle},
  ::Type{ElType},
) where {ElType}
  pv = find_pv(bc)
  pvres = similar(pv)
  return pvres
end

# Select a PartitionnedVector in a Broadcasted tape
"""
    pv = find_pv(bc::Base.Broadcast.Broadcasted)
    pv = find_pv(x::PartitionedVector)
    pv = find_pv(x::PartitionedVector, a::Any)
    pv = find_pv(x::Any, a::Any)

Pass through a `Broadcasted` tape to retrieve a `PartitionedVector`.
"""
find_pv(bc::Base.Broadcast.Broadcasted) = find_pv(bc.args...)
find_pv(x::PartitionedVector) = x
find_pv(x::PartitionedVector, a::Any) = x
find_pv(x::Any, a::Any) = find_pv(a)

Base.broadcastable(pv::PartitionedVector) = pv

struct PartitionedVectorStyle <: Base.Broadcast.BroadcastStyle end

Base.BroadcastStyle(::Type{PartitionedVector{T}}) where {T} = PartitionedVectorStyle()

Base.BroadcastStyle(::PartitionedVectorStyle, ::Base.Broadcast.BroadcastStyle) =
  PartitionedVectorStyle()
Base.BroadcastStyle(::Base.Broadcast.BroadcastStyle, ::PartitionedVectorStyle) =
  PartitionedVectorStyle()

function Base.copyto!(
  dest::PartitionedVector,
  bc::Base.Broadcast.Broadcasted{PartitionedVectorStyle},
)
  bcf = Base.Broadcast.flatten(bc)
  for i in bcf.axes[1]
    filtered = _filter(i, bcf.args)
    res = bcf.f(filtered...)
    dest[i] = res
  end
  return dest
end

# Select the i-th argument if needed in a Tuple of arguments
"""
    _filter(i::Int, arg::Tuple{})
    element_vector = _filter(i::Int, arg::PartitionedVector)
    _filter(i::Int, arg::Any)
    _filter(i::Int, args::Tuple)

Pass through a `Tuple` to select the `i`-th element if necessary.
"""
_filter(i::Int, arg::Tuple{}) = ()
_filter(i::Int, arg::PartitionedVector) = arg[i]
_filter(i::Int, arg::Any) = arg
_filter(i::Int, args::Tuple) = (_filter(i, args[1]), _filter(i, Base.tail(args))...)

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

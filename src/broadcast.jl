Base.broadcastable(pv::PartitionedVector) = pv

struct PartitionedVectorStyle <: Base.Broadcast.BroadcastStyle end

Base.BroadcastStyle(::Type{PartitionedVector{T}}) where T = PartitionedVectorStyle()

Base.BroadcastStyle(::PartitionedVectorStyle, ::PartitionedVectorStyle) = PartitionedVectorStyle()
Base.BroadcastStyle(::PartitionedVectorStyle, ::Base.Broadcast.BroadcastStyle) = PartitionedVectorStyle()
Base.BroadcastStyle(::Base.Broadcast.BroadcastStyle, ::PartitionedVectorStyle) = PartitionedVectorStyle()

function Base.similar(bc::Base.Broadcast.Broadcasted{PartitionedVectorStyle}, ::Type{ElType}) where ElType
  pv = find_pv(bc)
  pvres = similar(pv)
  return pvres
end

function Base.copy(bc::Base.Broadcast.Broadcasted{PartitionedVectorStyle})
  pv = find_pv(bc)
  pvres = copy(pv)
  return pvres
end

find_pv(bc::Base.Broadcast.Broadcasted) = find_pv(bc.args)
find_pv(args::Tuple) = find_pv(find_pv(args[1]), Base.tail(args))
find_pv(x) = x
find_pv(::Tuple{}) = nothing
find_pv(a::PartitionedVector, rest) = a
find_pv(::Any, rest) = find_pv(rest)

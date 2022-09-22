function axpy!(s::Y, x::PartitionedVector{T}, y::PartitionedVector{T}) where {T<:Number,Y<:Number}
  axpy!(s,x,y,Val(x.simulate_vector), Val(y.simulate_vector))
end

function axpy!(s::Y, x::PartitionedVector{T}, y::PartitionedVector{T}, ::Val{true}, ::Val{false}) where {T<:Number,Y<:Number}
  build!(x)
  build!(y)
  xvector = x.epv.v
  yvector = y.epv.v
  epv_from_v!(y.epv, s .* xvector .+ yvector)
  return y
end

function axpy!(s::Y, x::PartitionedVector{T}, y::PartitionedVector{T}, ::Val{true}, ::Val{true}) where {T<:Number,Y<:Number}
  y .+= s .* x
  return y
end

function axpy!(s::Y, x::PartitionedVector{T}, y::PartitionedVector{T}, ::Val{false}, ::Val{true}) where {T<:Number,Y<:Number}
  build!(x)
  build!(y)
  xvector = x.epv.v
  yvector = y.epv.v
  epv_from_v!(y.epv, s .* xvector .+ yvector)
  return y
end

function axpby!(s::Y1, x::PartitionedVector{T}, t::Y2, y::PartitionedVector{T}) where {T<:Number,Y1<:Number,Y2<:Number}
  axpby!(s, x, t, y, Val(x.simulate_vector), Val(y.simulate_vector))
end

function axpby!(s::Y1, x::PartitionedVector{T}, t::Y2, y::PartitionedVector{T}, ::Val{false}, ::Val{true}) where {T<:Number,Y1<:Number,Y2<:Number}
  build!(x)
  build!(y)
  xvector = x.epv.v
  yvector = y.epv.v
  epv_from_v!(y.epv, s .* xvector .+ yvector .* t)
  return y
end

function axpby!(s::Y1, x::PartitionedVector{T}, t::Y2, y::PartitionedVector{T}, ::Val{false}, ::Val{false}) where {T<:Number,Y1<:Number,Y2<:Number}
  println("test")
  y .= x .* s .+ y .* t
  return y
end

function axpby!(s::Y1, x::PartitionedVector{T}, t::Y2, y::PartitionedVector{T}, ::Val{true}, ::Val{true}) where {T<:Number,Y1<:Number,Y2<:Number}
  y .= x .* s .+ y .* t
end
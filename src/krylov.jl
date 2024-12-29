import LinearAlgebra: axpy!, axpby!
import Krylov.CgSolver
import Base.setproperty!

function axpy!(
  s::Y,
  x::PartitionedVector{T},
  y::PartitionedVector{T},
) where {T <: Number, Y <: Number}
  axpy!(s, x, y, Val(x.simulate_vector), Val(y.simulate_vector))
end

# y .+= s .* x
function axpy!(
  s::Y,
  x::PartitionedVector{T},
  y::PartitionedVector{T},
  ::Val{true},
  ::Val{true},
) where {T <: Number, Y <: Number}
  N = x.epv.N
  for i = 1:N
    yi = y[i].vec
    xi = x[i].vec
    axpy!(s, xi, yi)
  end
  return y
end

# y .+= s .* x
function axpy!(
  s::Y,
  x::PartitionedVector{T},
  y::PartitionedVector{T},
  ::Val{false},
  ::Val{false},
) where {T <: Number, Y <: Number}
  N = x.epv.N
  for i = 1:N
    yi = y[i].vec
    xi = x[i].vec
    axpy!(s, xi, yi)
  end
  return y
end

function axpy!(
  s::Y,
  x::PartitionedVector{T},
  y::PartitionedVector{T},
  ::Val{false},
  ::Val{true},
) where {T <: Number, Y <: Number}
  build!(x)
  build!(y)
  xvector = x.epv.v
  yvector = y.epv.v
  axpy!(s, xvector, yvector)
  epv_from_v!(y.epv, yvector)
  return y
end

function axpby!(
  s::Y1,
  x::PartitionedVector{T},
  t::Y2,
  y::PartitionedVector{T},
) where {T <: Number, Y1 <: Number, Y2 <: Number}
  axpby!(s, x, t, y, Val(x.simulate_vector), Val(y.simulate_vector))
end

# s .* xvector .+ yvector .* t
function axpby!(
  s::Y1,
  x::PartitionedVector{T},
  t::Y2,
  y::PartitionedVector{T},
  ::Val{false},
  ::Val{true};
  kwargs...,
) where {T <: Number, Y1 <: Number, Y2 <: Number}
  build!(x; kwargs...)
  build!(y; kwargs...)
  xvector = x.epv.v
  yvector = y.epv.v
  axpby!(s, xvector, t, yvector)
  epv_from_v!(y.epv, yvector)
  return y
end

# y .= x .* s .+ y .* t
function axpby!(
  s::Y1,
  x::PartitionedVector{T},
  t::Y2,
  y::PartitionedVector{T},
  ::Val{false},
  ::Val{false},
) where {T <: Number, Y1 <: Number, Y2 <: Number}
  N = x.epv.N
  for i = 1:N
    yi = y[i].vec
    xi = x[i].vec
    axpby!(s, xi, t, yi)
  end
  return y
end

# y .= x .* s .+ y .* t
function axpby!(
  s::Y1,
  x::PartitionedVector{T},
  t::Y2,
  y::PartitionedVector{T},
  ::Val{true},
  ::Val{true},
) where {T <: Number, Y1 <: Number, Y2 <: Number}
  N = x.epv.N
  for i = 1:N
    yi = y[i].vec
    xi = x[i].vec
    axpby!(s, xi, t, yi)
  end
  return y
end

function CgSolver(pv::PartitionedVector{T}) where {T}
  n = length(pv)
  Δx = similar(pv; simulate_vector = true)
  Δx .= (T)(0) # by setting Δx .= 0, we ensure that at each iterate the initial point `r` is 0.
  x = similar(pv; simulate_vector = true)
  x .= (T)(0)
  r = similar(pv; simulate_vector = true)
  r .= (T)(0) # will be reset at each cg! call to 0 because of mul!(r,A,Δx)
  p = similar(pv; simulate_vector = true)
  p .= (T)(0)
  Ap = similar(pv; simulate_vector = false) # result of the partitioned matrix vector product
  Ap .= (T)(0)
  z = similar(pv; simulate_vector = true)
  z .= (T)(0)
  stats = Krylov.SimpleStats(0, false, false, T[], T[], T[], 0.0, "unknown")
  solver = Krylov.CgSolver{T, T, PartitionedVector{T}}(n, n, Δx, x, r, p, Ap, z, true, stats)
  return solver
end

# This way, solver.warm_start stays true at all time.
# It prevents the else case where r .= b at the beginning of cg!.
# r is supposed to simulate a vector while b is not supposed to.
function setproperty!(
  solver::CgSolver{T, T, PartitionedVector{T}},
  sym::Symbol,
  val::Bool,
) where {T}
  if sym === :warm_start
    return nothing
  else
    setfield!(solver, sym, val)
  end
end

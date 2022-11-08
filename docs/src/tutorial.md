# PartitionedVectors.jl Tutorial

A `PartitionedVector <: DenseVector <: AbstractVector` wraps a `[PartitionedStructures](https://github.com/JuliaSmoothOptimizers/PartitionedStructures.jl).Elemental_pv`, to make [JuliaSmoothOptimizers](https://github.com/JuliaSmoothOptimizers) modules able to exploit the partially separable structure.
For now, `PartitionedVector` is the keystone to define [PartiallySeparableNLPModel](https://github.com/JuliaSmoothOptimizers/PartiallySeparableNLPModels.jl)s, and then to consequently:
- replace `Vector` in [JSOSolvers.jl](https://github.com/JuliaSmoothOptimizers/JSOSolvers.jl); 
- replace `Vector` in [KrylovSolvers.jl](https://github.com/JuliaSmoothOptimizers/Krylov.jl);
- make `LinearOperator`s relying only on `PartitionedVector`s viable;
- fit the NLPModels interface (ex: `NLPModels.obj(nlp::PartiallySeparableNLPModel, x::PartitionedVector)` see PartiallySeparableNLPModels.jl for more details).

Partitioned vectors usages are related to partially separable problems:
```math
 f(x) = \sum_{i=1}^N f_i (U_i x) , \; f_i : \R^{n_i} \to \R, \; U_i \in \R^{n_i \times n},\; n_i \ll n,
```
whose inherit partitioned derivatives:
```math
 \nabla f(x) = \sum_{i=1}^N U_i^\top \nabla f_i (U_i x) \quad \nabla^2 f(x) = \sum_{i=1}^N U_i^\top \nabla^2 f_i (U_i x) U_i,
```
where the set of $U_i$ gathers all the information related to the partitioned structure.
We consider $U_i$ a linear application selecting the variable that parametrize the $i$-th element function $f_i$, each $U_i$ is defined from a vector of integers.
The partially separable function 
```math
f(x) = f_1(x_1,x_2,x_3,x_4) + f_2(x_3,x_4,x_5,x_6) + f_3(x_5,x_6,x_7) + f_4(x_5,x_6,x_8)
```
get the following $U_i$:
```@example PV
U1 = [1, 2, 3, 4]
U2 = [3, 4, 5, 6]
U3 = [5, 6, 7]
U4 = [5, 6, 8]
Uis = [U1, U2, U3, U4]
```
However, before defining a `PartitionedVector`, you must understand the two usages of PartitionedVectors:
- usage 1: store each element contribution $\hat{v}_i$ independently and aggregate them to form $v = \sum_{i=1}^N U_i^\top \hat{v}_i$
In optimization methods, you use it to store $\nabla f_i (U_i x)$, $y_i = \nabla f_i (U_i x_{k+1}) - \nabla f_i (U_i x_k)$ or the result of a partitioned hessian-vector product which is a partitioned vector:
```math
 \nabla^2 f(x_k) s \approx B_k s = (\sum_{i=1}^N U_i^\top B_{k,i} U_i ) s = \sum_{i=1}^N U_i^\top (B_{k,i} U_i s) .
```
- usage 2: represent simultaneously a vector $x \in \mathbb{R}^n$ and the application of every $U_i$ on to $x$: $U_i x, \forall i$.
By construction, the elements parametrized the same variables (for exemple `U1` and `U3` are parametrized by the third variable) share the same values.
In optimization methods, it allows to store the current point $x_k$ or step $s_k$, which always comes in handy to evaluate $f_i(U_i x), \nabla f_i(U_i x)$ or $B_{k,i} U_i s$.

Any methods exploiting partially separable concepts will have to manipulate both usages at the same time, in particular the solvers from JSOSolvers.jl and Krylov.jl.
By default, you can define a `PartitionedVector` just from `Uis` as
```@example PV
using PartitionedVectors
pv = PartitionedVector(Uis)
```
which will be of usage 1.
If you want a vector for usage 2 you have to set `simulate_vector` optional argument to `true`
```@example PV
pv_vec = PartitionedVector(Uis; simulate_vector=true)
# set each element as a view of rand(length(pv_vec))
set!(pv_vec, rand(length(pv_vec))) 
```

PartitionedVectors.jl specify several methods from various modules.
Warning: you have to be careful when you mix both usages in a single operation, by default, the result will take usage 1.
Base.jl:
- elementary operations `+, -, *, ==` for PartitionedVectors.
```@example PV
pv + pv == 2 * pv
pv - pv == 0 * pv
```
Moreover, it supports the broadcast for the same operations (unfortunately not in place for now).
```@example PV
pv .+ pv == 2 .* pv
pv .- pv == 0 .* pv
```
- supports methods related to `AbstractArray`s such as: 
  - `get_index`, `set_index!` refers to the `i`-th element vector of `pv`
  ```@example PV
  pv[1]
  ```
  ```@example PV
  pv2 = pv - 0.5 * pv
  pv[1] = pv2[1]
  pv[1] == pv[2]
  ```
  - `firstindex`, `lastindex`, `size`, `length`:
  ```@example PV
  firstindex(pv) == 1
  lastindex(pv) == 4  
  size(pv) == (4,)
  length(pv) == 8
  ```
  note that size and length differ, `length` refers to the biggest index (e.g. $n$) while `size` refers to the number of elements $N$.
  - `copy`, `similar`;
  ```@example PV
  pvcopy = copy(pv)
  pvsimilar = similar(pv)
  ```
LinearAlgebra:
```@example PV
using LinearAlgebra
dot(pv,pv) ≈ norm(pv)^2
```

In addition, PartitionedVectors.jl defines a:
- `LinearOperator` from a `PartitionedMatrix` (see PartitionedStructures.jl) relying on `PartitionedVector`s
```julia
using PartitionedStructures
epm = PartitionedStructures.identity_epm(Uis)
lo = LinearOperators.LinearOperator(epm)
lo * pv
```
Note: `Matrix(lo)` will produce an error, since the default implementation assumes a complete `Vector`-like behaviour.
- dedicated `CGSolver` from Krylov.jl to solve a partitioned linear system (from a partitioned `LinearOperator`).
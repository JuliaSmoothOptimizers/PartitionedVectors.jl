# PartitionedVectors.jl

## Compatibility
Julia ≥ 1.6.

## How to install
This module can be installed with the following command:
```julia
pkg> add https://github.com/paraynaud/PartitionedVectors.jl.git
pkg> test PartitionedVectors
```

## Synopsis
A `PartitionedVector <: DenseVector <: AbstractVector` wraps a [PartitionedStructures](https://github.com/JuliaSmoothOptimizers/PartitionedStructures.jl)`.Elemental_pv`, to make [JuliaSmoothOptimizers](https://github.com/JuliaSmoothOptimizers) modules able to exploit the partially separable structure.

## How to use
<!-- Check the [tutorial](https://JuliaSmoothOptimizers.github.io/PartitionedVectors.jl/stable/). -->

Check the [tutorial](https://paraynaud/PartitionedVectors.jl/dev/).

## How to Cite

If you use PartitionedVectors.jl in your work, please cite using the format given in [`CITATION.bib`](https://github.com/JuliaSmoothOptimizers/PartitionedVectors.jl/blob/main/CITATION.bib).

# Bug reports and discussions

If you think you found a bug, feel free to open an [issue](https://github.com/JuliaSmoothOptimizers/PartitionedVectors.jl/issues).
Focused suggestions and requests can also be opened as issues. Before opening a pull request, start an issue or a discussion on the topic, please.

If you want to ask a question not suited for a bug report, feel free to start a discussion [here](https://github.com/JuliaSmoothOptimizers/Organization/discussions). This forum is for general discussion about this repository and the [JuliaSmoothOptimizers](https://github.com/JuliaSmoothOptimizers), so questions about any of our packages are welcome.
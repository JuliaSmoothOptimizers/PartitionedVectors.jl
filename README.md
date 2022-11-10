# PartitionedVectors

| **Documentation** | **Linux/macOS/Windows/FreeBSD** | **Coverage** | **DOI** |
|:-----------------:|:-------------------------------:|:------------:|:-------:|
| [![docs-stable][docs-stable-img]][docs-stable-url] [![docs-dev][docs-dev-img]][docs-dev-url] | [![build-gh][build-gh-img]][build-gh-url] [![build-cirrus][build-cirrus-img]][build-cirrus-url] | [![codecov][codecov-img]][codecov-url] | [![doi][doi-img]][doi-url] |

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://paraynaud.github.io/PartitionedVectors.jl/stable
[docs-dev-img]: https://img.shields.io/badge/docs-dev-purple.svg
[docs-dev-url]: https://paraynaud.github.io/PartitionedVectors.jl/dev
[build-gh-img]: https://github.com/paraynaud/PartitionedVectors.jl/workflows/CI/badge.svg?branch=main
[build-gh-url]: https://github.com/paraynaud/PartitionedVectors.jl/actions
[build-cirrus-img]: https://img.shields.io/cirrus/github/paraynaud/PartitionedVectors.jl?logo=Cirrus%20CI
[build-cirrus-url]: https://cirrus-ci.com/github/paraynaud/PartitionedVectors.jl
[codecov-img]: https://codecov.io/gh/paraynaud/PartitionedVectors.jl/branch/main/graph/badge.svg
[codecov-url]: https://app.codecov.io/gh/paraynaud/PartitionedVectors.jl
[doi-img]: https://img.shields.io/badge/DOI-10.5281%2Fzenodo.822073-blue.svg
[doi-url]: https://doi.org/10.5281/zenodo.822073

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
Check the [tutorial](https://paraynaud.github.io/PartitionedVectors.jl/dev/tutorial/).

## How to Cite

If you use PartitionedVectors.jl in your work, please cite using the format given in [`CITATION.bib`](https://github.com/paraynaud/PartitionedVectors.jl/blob/main/CITATION.bib).

# Bug reports and discussions

If you think you found a bug, feel free to open an [issue](https://github.com/JuliaSmoothOptimizers/PartitionedVectors.jl/issues).
Focused suggestions and requests can also be opened as issues. Before opening a pull request, start an issue or a discussion on the topic, please.

If you want to ask a question not suited for a bug report, feel free to start a discussion [here](https://github.com/JuliaSmoothOptimizers/Organization/discussions). This forum is for general discussion about this repository and the [JuliaSmoothOptimizers](https://github.com/JuliaSmoothOptimizers), so questions about any of our packages are welcome.
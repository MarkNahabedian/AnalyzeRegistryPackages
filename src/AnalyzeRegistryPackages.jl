module AnalyzeRegistryPackages

using Base64
using CSV
using Dates
using GitHub
using HTTP
using PackageAnalyzer
using Plots
using TOML
using URIs

include("fetch.jl")
include("collection_file.jl")
include("collect.jl")
include("metrics.jl")
include("plots.jl")
include("confirm_unreachable.jl")

end

using AnalyzeRegistryPackages
using Documenter

DocMeta.setdocmeta!(AnalyzeRegistryPackages, :DocTestSetup, :(using AnalyzeRegistryPackages); recursive=true)

makedocs(;
    modules=[AnalyzeRegistryPackages],
    authors="MarkNahabedian <naha@mit.edu> and contributors",
    repo="https://github.com/MarkNahabedian/AnalyzeRegistryPackages.jl/blob/{commit}{path}#{line}",
    sitename="AnalyzeRegistryPackages.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MarkNahabedian.github.io/AnalyzeRegistryPackages.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/MarkNahabedian/AnalyzeRegistryPackages.jl",
    devbranch="main",
)

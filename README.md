# AnalyzeRegistryPackages* 

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://MarkNahabedian.github.io/AnalyzeRegistryPackages.jl/stable/) [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://MarkNahabedian.github.io/AnalyzeRegistryPackages.jl/dev/) [![Build Status](https://github.com/MarkNahabedian/AnalyzeRegistryPackages.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/MarkNahabedian/AnalyzeRegistryPackages.jl/actions/workflows/CI.yml?query=branch%3Amain)

Run `PackageAnalyzer.analyze` on every package in a specified registry
and collect the results in a tab separated values file.

For the Julia General registry I collected these results:

* [raw data](https://raw.githubusercontent.com/MarkNahabedian/AnalyzeRegistryPackages.jl/main/data/collected_linecounts.tsv)

* [lines of test code versus lines of source code](https://github.com/MarkNahabedian/AnalyzeRegistryPackages.jl/blob/main/data/graph-src-tests.svg)

* [lines of README file versus lines of source code](https://github.com/MarkNahabedian/AnalyzeRegistryPackages.jl/blob/main/data/graph-src-readme.svg)

* [lines of documentation versus lines of source code](https://github.com/MarkNahabedian/AnalyzeRegistryPackages.jl/blob/main/data/graph-src-docs.svg)

* [lines of README and documentation versus lines of source code](https://github.com/MarkNahabedian/AnalyzeRegistryPackages.jl/blob/main/data/graph-src-docs%2Breadme.svg)


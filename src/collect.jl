export collect_stats_from_registry

EXCEPTION = nothing

function collect_stats_from_registry(registry_repo)
    ensue_collection_file()
    throttle = throttle_for(registry_repo)
    throttle_request(throttle)
    toml = fetch_registry_toml(registry_repo)
    packages = toml["packages"]
    remaining = length(packages)
    done = whats_done()
    remaining -= length(done)
    function do_package(uuid, d)
        name = d["name"]
        if name == get(done, uuid, nothing)
            # Skip a package if it's already been analyzed
            return
        end
        path = d["path"]
        throttle_request(throttle)
        t = TOML.parse(fetch_gh_file_contents(registry_repo, "$path/Package.toml"))
        @assert uuid == t["uuid"]
        stats = get_stats_from_package(t["repo"])
        write_stats(name, uuid, stats...)
        remaining -= 1
        if mod(remaining, 10) == 0
            println("$remaining remaining.")
        end
    end
    println("$remaining remaining.")
    for (uuid, d) in packages
        try
            do_package(uuid, d)
        catch e
            global EXCEPTION = e
            show(e)
            break
            "API rate limit exceeded"
        end
    end
end

function get_stats_from_package(package_url::String)
    println("$(Dates.format(Dates.now(), "HH:MM:SS"))   Analyzing $package_url")
    analysis = PackageAnalyzer.analyze(package_url)
    reach = analysis.reachable
    src = PackageAnalyzer.count_julia_loc(analysis, "src")
    tests = PackageAnalyzer.count_julia_loc(analysis, "test")
    docs = PackageAnalyzer.count_docs(analysis)
    readme = PackageAnalyzer.count_readme(analysis)
    return reach, src, tests, docs, readme
end


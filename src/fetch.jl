
function fetch_gh_file_contents(local_clone::AbstractString, path)
    read(joinpath(local_clone, path), String)
end

function fetch_registry_toml(local_clone::AbstractString)
    TOML.parse(fetch_gh_file_contents(local_clone, "Registry.toml"))
end


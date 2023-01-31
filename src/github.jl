
# Should calculate from rate_limit()["rate"]["limit"]
# Requests per hour?
GITHUB_TIME_BETWEEN_CALLS = Millisecond(65000)

GH_ACCESS_TOKEN = read("ACCESS_TOKEN", String)
GH_AUTH = GitHub.OAuth2(GH_ACCESS_TOKEN)


JULIA_GENERAL_REGISTRY = Repo("JuliaRegistries/General")
JULIA_GENERAL_REGISTRY_LOCAL = "c:/Users/Mark Nahabedian/.julia/registries/General"

# https://github.com/JuliaBinaryWrappers/COSMA_jll.jl.git
url_to_repo(url::AbstractString) =
    url_to_repo(URI(url))

function url_to_repo(url::URI)
    s = split(url.path, '/')
    Repo(join(s[1:2], '/'))
end

GH_REQUEST_COUNT = 0

function fetch_gh_file_contents(repo, path)
    GH_REQUEST_COUNT += 1
    f = GitHub.file(repo, path; auth = GH_AUTH)
    @assert f.typ == "file"
    @assert f.encoding == "base64"
    String(base64decode(f.content))
end

function fetch_registry_toml(repo::GitHub.Repo)
    TOML.parse(fetch_gh_file_contents(repo, "Registry.toml"))
end


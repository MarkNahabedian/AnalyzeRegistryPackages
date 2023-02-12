
export DATA_DIR, COLLECTION_FILE, COLLECTION_FILE_COLUMNS
export REPO_URIS_FILE, REPO_URIS_COLUMNS
export new_file_path, ensure_tsv_file, write_tsv_row

DATA_DIR = abspath(joinpath(@__DIR__, "../data"))
COLLECTION_FILE = joinpath(DATA_DIR, "collected_linecounts.tsv")
REPO_URIS_FILE = joinpath(DATA_DIR, "repo_URIs.tsv")

COLLECTION_FILE_COLUMNS = [
    "Name", "UUID",
    "reachable", "src", "tests", "docs", "readme"
]

REPO_URIS_COLUMNS = [
    "Name", "UUID", "URI"
]

function new_file_path(path)
    s = splitpath(path)
    s[lastindex(s)] = "new-" * s[lastindex(s)]
    joinpath(s)
end

function ensure_tsv_file(path, columns)
    if ispath(path)
        return
    end
    open(path, write=true) do io
        write(io, join(columns, '\t'))
        write(io, "\n")
    end
end

function write_tsv_row(path, row...)
    open(path, append=true) do io
        write(io, join([row...], "\t"))
        write(io, "\n")        
    end
end

function whats_done(collection_file)
    done = Dict{String, String}()
    csvf = CSV.File(collection_file)
    for row in csvf
        done[row.UUID] = row.Name
    end
    done
end

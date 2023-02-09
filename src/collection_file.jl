
export COLLECTION_FILE, ensue_collection_file

COLLECTION_FILE = abspath(joinpath(@__DIR__, "../data/collected_linecounts.tsv"))

COLLECTION_FILE_COLUMNS = [
    "Name", "UUID",
    "reachable", "src", "tests", "docs", "readme"
]

function ensue_collection_file()
    if ispath(COLLECTION_FILE)
        return
    end
    open(COLLECTION_FILE, write=true) do io
        write(io, join(COLLECTION_FILE_COLUMNS, '\t'))
        write(io, "\n")
    end
end

function write_stats(name, uuid, stats...)
    open(COLLECTION_FILE, append=true) do io
        write(io, join([
            "\"$name\"",
            "\"$uuid\"",
            stats...
                ], "\t"))
        write(io, "\n")
    end
end

function whats_done()
    done = Dict{String, String}()
    csvf = CSV.File(COLLECTION_FILE)
    for row in csvf
        done[row.UUID] = row.Name
    end
    done
end

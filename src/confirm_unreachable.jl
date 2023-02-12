# Confirm that the packages reported as unreaqchable in
# COLLECTION_FILE are still unreachable.

using DataFrames
using HTTP

export confirm_unreachable

function confirm_unreachable()
    function request_status(uri::AbstractString)
        (try
             HTTP.request("HEAD", uri).status
         catch e
             if e isa HTTP.Exceptions.StatusError
                 return e.status
             else
                 rethrow()
             end
         end)
    end
    unreachable =
        transform!(
            innerjoin(
                DataFrame(CSV.File(REPO_URIS_FILE)),
                select(filter(DataFrame(CSV.File(COLLECTION_FILE))) do row
                           row.reachable == false
                       end, :Name, :UUID),
                on = [:Name, :UUID]),
            :URI => ByRow(request_status))
    sort!(unreachable, :Name)
    CSV.write(joinpath(DATA_DIR, "unreachable.tsv"),
              unreachable,
              delim = "\t")
    unreachable
end


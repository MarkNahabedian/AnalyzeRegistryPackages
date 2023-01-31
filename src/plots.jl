export plot_collected, svg_collected

function plot_collected(a, b...)
    csvf = CSV.File(COLLECTION_FILE)
    a_data = []
    b_data = []
    for row in csvf
        push!(a_data, getproperty(row, a))
        bsum = 0
        for b1 in b
            bsum += getproperty(row, b1)
        end
        push!(b_data, bsum)
    end
    plot(a_data, b_data,
         xlabel="$a",
         # xscale=:log10,
         ylabel="$(join(b, '+'))",
         # yscale=:log10,
         seriestype=:scatter)
end

function svg_collected(a, b...)
    p = plot_collected(a, b...)
    Plots.svg(p, abspath(joinpath(COLLECTION_FILE,
                                  "../graph-$a-$(join(b, '+')).svg")))
end


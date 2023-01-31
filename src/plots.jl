export plot_collected, svg_collected

is_jll(package_name) = endswith(package_name, "_jll")

function plot_collected(a, b...)
    csvf = CSV.File(COLLECTION_FILE)
    a_data = []
    b_data = []
    color = []
    for row in csvf
        push!(color,
              if is_jll(row.Name)
                  "red"
              else
                  "green"
                  end)
        push!(a_data, getproperty(row, a))
        bsum = 0
        for b1 in b
            bsum += getproperty(row, b1)
        end
        push!(b_data, bsum)
    end
    scatter(a_data, b_data,
            color=color,
            xlabel="$a",
            # xscale=:log10,
            ylabel="$(join(b, '+'))",
            # yscale=:log10,
            )
end

function svg_collected(a, b...)
    p = plot_collected(a, b...)
    Plots.svg(p, abspath(joinpath(COLLECTION_FILE,
                                  "../graph-$a-$(join(b, '+')).svg")))
end


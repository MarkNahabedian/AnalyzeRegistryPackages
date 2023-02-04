export plot_collected, svg_collected
export threshold_satisfaction_plot

using DataStructures: SortedDict

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


# For a given metric, show the number of non-JLL projects that satisfy
# the metric versus the value of the metrc.

function threshold_satisfaction_plot(filename, extractor)
    csvf = CSV.File(COLLECTION_FILE)
    # key is value of the metric, value is count of projects with that
    # value.
    stats = SortedDict()
    total = 0
    for row in csvf
        if !is_jll(row.Name)
            m = extractor(row)
            if !haskey(stats, m)
                stats[m] = 0
            end
            stats[m] += 1
            total += 1
        end
    end
    # Cumulative
    cumulative = SortedDict()
    sum = 0
    for key in keys(stats)
        sum += stats[key]
        cumulative[key] = sum
    end
    @assert sum == total
    # Fraction
    fraction = SortedDict()
    for k in keys(cumulative)
        fraction[k] = 1.0 - cumulative[k] / total
    end
    xincr = 10^(cld(log10(total), 1) - 1)
    xmax = xincr * cld(total, xincr)
    p = plot(collect(keys(fraction)),
             collect(values(fraction)), 
             linewidth = 5,
             xlabel = "number of projects",
             ylabel = "satisfies fraction",
             xticks = Int.(0:xincr:xmax),
             yticks = 0.0:0.1:1.0)
    Plots.svg(p, abspath(joinpath(COLLECTION_FILE, "..", filename)))
end


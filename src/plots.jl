export plot_collected, svg_collected
export threshold_satisfaction_plot

using DataStructures: SortedDict

is_jll(package_name) = endswith(package_name, "_jll")

# Scatter plot of a versus b
function plot_collected(a, b...)
    csvf = CSV.File(COLLECTION_FILE)
    a_data = []
    b_data = []
    color = []
    for row in csvf
        if !row.reachable
            continue
        end
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

function threshold_satisfaction_plot(filename, met::Metric)
    csvf = CSV.File(COLLECTION_FILE)
    # key is value of the metric, value is the count of
    # projects with that metric value.
    stats = SortedDict()
    total = 0
    just_zeros = []
    for row in Base.rest(csvf)      # Skip headings
        if !row.reachable
            continue
        end
        row_ok = false
        for k in COLLECTION_FILE_COLUMNS
            if k in ["reachable", "readme"]
                continue
            end
            v = getproperty(row, Symbol(k))
            if v isa Number && v > 0
                row_ok = true
                break
            end
        end
        if !row_ok
            push!(just_zeros, row.Name)
            continue
        end
        if !is_jll(row.Name)
            m = met.func(row)
            if isnan(m)
                @warn "NaN:", m, met.text, row
                continue
            end
            if !haskey(stats, m)
                stats[m] = 0
            end
            stats[m] += 1
            total += 1
        end
    end
    let
        l = length(just_zeros)
        if l > 0
            @info "There are $l packages whose stats are all zero."
        end
    end
    if !isempty(just_zeros)
        @info length(just_zeros), join(just_zeros, " ")
    end
    # Cumulative: key is a value of the metric, value is the number of
    # projects whose metric value is less than or equal to the key.
    cumulative = SortedDict()
    sum = 0
    for key in keys(stats)
        sum += stats[key]
        cumulative[key] = sum
    end
    @assert sum == total
    xs = collect(keys(cumulative))
    ys = collect(values(cumulative))
    p = plot(xs, ys,
             linewidth = 5,
             xlabel = met.text,
             ylabel = "packages not meeting threshold",
             xticks = axis_ticks(xs),
             yticks = axis_ticks(ys))
    Plots.svg(p, abspath(joinpath(COLLECTION_FILE, "..", filename)))
    p
end

function axis_ticks(data, steps=10, fixed_origin=true)
    min = minimum(data)
    max = maximum(data)
    if fixed_origin
        min = 0
    end
    incr = 10^(cld(log10(max), 1) - 1)
    range = min : incr : max
    println("*** axis_ticks $min - $max     $range",)
    return range
end

export @metric

function metric_to_function(metric::Expr)
    function xf(s::Symbol)
        if s isa Symbol && string(s) in COLLECTION_FILE_COLUMNS
            Expr(:., :row, QuoteNode(s))
        else
            s
        end
    end
    function xf(e::Expr)
        Expr(e.head, map(xf, e.args)...)
    end
    Expr(:->, :row, xf(metric))
end

struct Metric
    text::String
    func::Function
end

macro metric(e)
    Expr(:call, :Metric,
         string(e),
         metric_to_function(e))
end

using Revise
using Random, SpatialIndexing

const SI = SpatialIndexing

Random.seed!(1)
seq_tree = RTree{Float64, 2}(Int, String, leaf_capacity = 20, branch_capacity = 20)
bulk_tree = RTree{Float64, 2}(Int, String, leaf_capacity = 10, branch_capacity = 10)
mbrs = Vector{SI.mbrtype(seq_tree)}()
for i in 1:10000
    t = 10 * rand()
    u, v = (0.1*t)^0.25 * randn(2)
    x = t^1.5 * sin(2*t) + u
    y = t^1.5 * cos(2*t) + v
    rmbr = SI.Rect((x, y), (x, y))
    push!(mbrs, rmbr)
end
for (i, br) in enumerate(mbrs)
    insert!(seq_tree, br, i, string(i))
end
SI.check(seq_tree)

SI.load!(bulk_tree, enumerate(mbrs), convertel -> eltype(bulk_tree)(x[2], x[1], string(x[1])))
SI.check(bulk_tree)

include(joinpath(@__DIR__, "dataframe_utils.jl"))

seq_tree_df = convert(DataFrame, seq_tree)

include(joinpath(@__DIR__, "plot_utils.jl"))

seq_tree_plot = plot(seq_tree);
open(joinpath(@__DIR__, "spiral_rtree_seq.html"), "w") do io
    PlotlyJS.savehtml(io, seq_tree_plot, :embed)
end

using ORCA
savefig(seq_tree_plot, joinpath(@__DIR__, "spiral_rtree_seq.png"), width=1000, height=800)

bulk_tree_plot = plot(bulk_tree);
open(joinpath(@__DIR__, "spiral_rtree_bulk.html"), "w") do io
    PlotlyJS.savehtml(io, bulk_tree_plot, :embed)
end

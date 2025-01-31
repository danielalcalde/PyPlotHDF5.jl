module PyPlotHDF5
import PyPlot
using HDF5

export_variables = [
    :plot,
    :errorbar,
    :axhline,
    :axvline,
    :savefig,
    :scatter,
    :imshow,
]

# Export selected PyPlot functions
names_ = names(PyPlot)
for sym in names_
    if ! occursin("@", String(sym))
        if !(sym in export_variables)
            @eval using PyPlot: $sym
        end
        @eval export $sym
    end
end
export reset_hd5data

# Initialize plot data storage
plot_data_ = Any[]

# Function to reset plot data
function reset_hd5data()
    global plot_data_ = Any[]
end

# Function to add data to plot_data_
function add_data(args...; reset=false, name="", kwargs...)
    global plot_data_
    if reset
        reset_hd5data()
    end
    l = length(args)
    d = Dict()
    if l == 1
        d["y"] = deepcopy(args[1])
    elseif l == 2
        d["x"] = deepcopy(args[1])
        d["y"] = deepcopy(args[2])
    else
        for (i, arg) in enumerate(args)
            d["x$i"] = deepcopy(arg)
        end
    end
    
    if :label in keys(kwargs)
        d["label"] = kwargs[:label]
    end
    if d != Dict()
        d["name"] = name
        push!(plot_data_, d)
    end
end

# Redefine plot function
function plot(args...; reset=false, kwargs...)
    add_data(args...; name="plot_", reset, kwargs...)
    return PyPlot.plot(args...; kwargs...)
end

# Corrected errorbar function
function errorbar(args...; reset=false, kwargs...)
    add_data(args...; name="errorbar_", reset, kwargs...)
    return PyPlot.errorbar(args...; kwargs...)
end

# Define hline function
function axhline(args...; reset=false, kwargs...)
    add_data(args...; name="hline_", reset, kwargs...)
    return PyPlot.axhline(y; kwargs...)
end

# Define vline function
function axvline(args...; reset=false, kwargs...)
    add_data(args...; name="vline_", reset, kwargs...)
    return PyPlot.axvline(args...; kwargs...)
end

# Define scatter function
function scatter(args...; reset=false, kwargs...)
    add_data(args...; name="scatter_", reset, kwargs...)
    return PyPlot.scatter(args...; kwargs...)
end

# Define heatmap function
function imshow(args...; reset=false, kwargs...)
    add_data(args...; name="imshow_", reset, kwargs...)
    return PyPlot.imshow(args...; kwargs...)
end

# Define savefig function
function savefig(filename; kwargs...)
    # Delete old HDF5 file if present
    file_name = string(filename, ".hdf5")
    if isfile(file_name)
        rm(file_name)
    end
    fid = h5open(file_name, "w")
    for (i, data_) in enumerate(plot_data_)
        name = pop!(data_, "name") * string(i)
        g = create_group(fid, name)
        for (k, v) in data_
            if v isa AbstractArray || v isa Number || v isa String
                if eltype(v) === Any
                    v = [vi for vi in v]
                end
                g[k] = v
            end
        end
    end
    close(fid)
    return PyPlot.savefig(filename; kwargs...)
end

end # module PyPlotHDF5

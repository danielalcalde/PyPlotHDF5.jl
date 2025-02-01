
# PyPlotHDF5

A library to automatically save data used to create a plot into a file using HDF5 format. Useful for complying with the FAIR principles. Supported functions are  `plot`, `errorbar`, `axhline`, `axvline`, `savefig`, `scatter`, `imshow`. More functions can be added by request easily.

```jl
using PyPlotHDF5
plot([1,2,3], [2,4,6], reset=true) # reset=true will clear the current saved data or alternatively use reset_hd5data() to clear the data
plot([1,2,3], [2,4,6])
savefig("test.pdf") # Will save an hdf5 file called test.pdf.hdf5
```

## Installation
]add https://github.com/danielalcalde/PyPlotHDF5.jl/tree/main

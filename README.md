
# PyPlotHDF5

A library to automatically save data in generated for PyPlot figures in HDF5 format. Usefull for complying with the FAIR principles. Supported functions are  `plot`, `errorbar`, `axhline`, `axvline`, `savefig`, `scatter`, `imshow`. More functions can be added by request easily.

```jl
using PyPlotHDF5
plot([1,2,3], [2,4,6], reset=true) # reset=true will clear the current saved data
plot([1,2,3], [2,4,6])
savefig("test.pdf") # Will save an hdf5 file called test.pdf.hdf5
```

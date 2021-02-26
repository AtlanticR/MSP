# install.packages('reticulate')

library(reticulate)
# use_python('C:/Python27/ArcGIS10.6/python.exe', required = T) # laptop
use_python('C:/Python27/ArcGIS10.2/python.exe', required = T) # Desktop

reticulate::py_run_file("Rockweed/code/Py_ImportModules.py")

# Start the clock!
startTime <- Sys.time()
print(Sys.time())

reticulate::py_run_file("Rockweed/code/MosaicNDVITiles_20210224.py")

# Stop the clock
ElapsedTime <- Sys.time() - startTime
ElapsedTime


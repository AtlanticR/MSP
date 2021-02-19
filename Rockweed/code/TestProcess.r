install.packages('reticulate')

library(reticulate)
# use_python('C:/Python27/ArcGIS10.6/python.exe', required = T) # laptop
use_python('C:/Python27/ArcGIS10.2/python.exe', required = T) # Desktop

py_run_file("Rockweed/code/Py_ImportModules.py")
py_run_file("Rockweed/code/TestPy_20210210.py")

# Stop the clock
ElapsedTime <- Sys.time() - startTime
ElapsedTime


# Start the clock!
startTime <- Sys.time()
print(Sys.time())

reticulate::import("arcpy")
reticulate::import("os")
reticulate::import("time")
reticulate::import("numpy as np")
reticulate::py_run_string("import numpy as np")
py_run_string
reticulate::py_run_string("import arcpy.sa as sa")

py_run_file("Rockweed/code/TestPySmall_20210210.py")

# Stop the clock
ElapsedTime <- Sys.time() - startTime
ElapsedTime


os <- import("os")
os$listdir(".")


# reticulate::source_python("Rockweed/code/TestPy_20210210.py")
# py_available()
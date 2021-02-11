install.packages('reticulate')

library(reticulate)
use_python('C:/Python27/ArcGIS10.6/python.exe', required = T)
reticulate::source_python("Rockweed/code/TestPy_20210210.py")
py_available()

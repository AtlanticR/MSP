######################################################################################################################
# 
# Mosaic together NDVI tiles into a single raster for the Maritime region
# 
#  - Clip final mosaic to the nearshore (to eliminate the offshore algal blooms)
#		- nearshore in this case is within 1000 m of the coast
#  - convert to polygons (1,0) for all values greater than 0.4
# 
#  - Join the polygons with shoreline classification files (ECCC and BoF classification)
#  - Join polygons with iNaturalist photo points (this in both directions is a possible
#		one to many relationship.
# 
# Final products
# Export large mosaic as .tif (both UTM and WGS84)
# Polygon shapefile of all NDVI returns > 0.4 with the two 
# shoreline classification information attached in the attribute table.
#
# Bring in the iNaturalist/OBIS/GBIF points and join with presence polygons
# Spatial Join, ONE TO MANY, don't keep all features, 30m distance.
# Try 
# 
#
# Philip Greyson
# February 2021
############################################################################################
######################################################################################################################



# Mosaic individual .tif images to new raster
# Raster processing environments set to Snap to Raster
# use Ocean Mask to take out floating algae
# convert to polygons (1,0)
# (explode?) if necessary
# Spatial Join with ECCC classifiction (perhaps convert to centroid, join centroid with closest line segment, table join back to polygon layer)
# What's the process for determining polygons on land?
# Export large mosaic as .tif (both UTM and WGS84)
# 

import arcpy
import os
import time
import numpy as np
import arcpy.sa as sa
# from arcpy import env
# from arcpy.sa import *

arcpy.env.overwriteOutput = True
arcpy.CheckOutExtension("Spatial")
arcpy.env.qualifiedFieldNames = False # Maintains original field names and does not concatenate with the table name


# Create a new geodatabase
# Set local variables
# FolderPath = "C:/BIO/20200306/GIS/Projects/MSP/Rockweed/Imagery/Satellite" 
FolderPath = "N:/MSP/Projects/Rockweed/Imagery/Satellite"
# FolderPath = r"\\dcnsbiona01a\BIODataSVC\IN\MSP\Projects\Rockweed\Imagery\Satellite"

# Using network paths
# https://gis.stackexchange.com/questions/85339/assigning-unc-path-to-arcpy-env-workspace

GDBname = "Processing.gdb"

# CreateFileGDB
print("Creating GDB")
print(str(time.ctime(int(time.time()))))
# arcpy.CreateFileGDB_management(FolderPath, GDBname)
gdbWorkspace = os.path.join(FolderPath, GDBname)

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

import arcpy, os, numpy as np
from arcpy import env
from arcpy.sa import *
arcpy.env.overwriteOutput = True
arcpy.CheckOutExtension("Spatial")
arcpy.env.qualifiedFieldNames = False # Maintains original field names and does not concatenate with the table name


# Create a new geodatabase
# Set local variables
FolderPath = "C:/BIO/20200306/GIS/Projects/MSP/Rockweed/Imagery/Satellite" 
# FolderPath = "N:/MSP/Projects/Rockweed/Imagery/Satellite"
# FolderPath = r"\\dcnsbiona01a\BIODataSVC\IN\MSP\Projects\Rockweed\Imagery\Satellite"

# Using network paths
# https://gis.stackexchange.com/questions/85339/assigning-unc-path-to-arcpy-env-workspace

GDBname = "Processing.gdb"

# CreateFileGDB
# arcpy.CreateFileGDB_management(FolderPath, GDBname)
gdbWorkspace = os.path.join(FolderPath, GDBname)

FolderPath = "C:/BIO/20200306/GIS/Projects/MSP/Rockweed/Imagery/Satellite/NDVI_Tiles" 
# FolderPath = "N:/MSP/Projects/Rockweed/Imagery/Satellite/NDVI_Tiles"
arcpy.env.workspace = FolderPath

# create a list of all .TIF files in the workspace
rasters = arcpy.ListRasters("*", "TIF")

# ###################################################################################
######################################################################################################################

# Export all raster names to a text file
# In Excel make a second list of new names
# Print List of all rasters to text file
# and then create a list of new names for them
# list1 = arcpy.ListRasters("*")

# Get count of elements in the list
fcCount = len(rasters)
print(fcCount)
# export the names of all rasters
with open('c:/Temp/NDVIRastersList.txt', 'w') as f:
    for item in rasters:
        f.write("%s\n" % item)



######################################################################################################################


# ######## Mosaic all tiles into a single raster in the geodatabase  ######## #

newRast = "NDVI_Mosaic"
arcpy.env.workspace = FolderPath

arcpy.MosaicToNewRaster_management(rasters,gdbWorkspace, newRast, "#","32_BIT_FLOAT","#","1","FIRST","FIRST")

# Set workspace to the Geodatabase
arcpy.env.workspace = gdbWorkspace

# Set processing extent environments
arcpy.env.snapRaster = newRast

outMask = "C:/BIO/20200306/GIS/Projects/MSP/Rockweed/Zones/ClippingMask.gdb/MARClippingMask"
# outMask = "N:/MSP/Projects/Rockweed/Zones/ClippingMask.gdb/MARClippingMask"

# using the clipping Mask remove all values that fall under the mask
start2 = time.time() #start timer
outCon = Con(IsNull(outMask),newRast,0)
outName = "NDVI_Final"
outCon.save(outName)
# set all values >= 0.4 to 1, everything else to NULL
outCon2 = SetNull(outCon <0.4, 1)

Poly1 = "NDVI_Poly"
# Poly2 = "NDVI_PolySingle"
#---------------------------------------------------------------------------------#
# Convert the raster to a polygon layer
arcpy.RasterToPolygon_conversion(outCon2, Poly1, "NO_SIMPLIFY","VALUE")

delFlds = "gridcode"
arcpy.DeleteField_management(Poly1,delFlds)

arcpy.Compact_management(gdbWorkspace)

# Shoreline1 = "N:/MSP/Data/NaturalResources/CoastalEnvironment/AtlanticShorelineClassification_FGP/ECCC_Class.shp"
# Shoreline2 = "N:/MSP/Data/NaturalResources/CoastalEnvironment/BoFShorelineClassification/BoFscat_Simp.shp"
Shoreline1 = "C:/BIO/20200306/GIS/Projects/MSP/Rockweed/NaturalResources/CoastalEnvironment/AtlanticShorelineClassification_FGP/ECCC_Class.shp"
Shoreline2 = "C:/BIO/20200306/GIS/Projects/MSP/Rockweed/NaturalResources/CoastalEnvironment/BoFShorelineClassification/BoFscat_Simp.shp"
PolyJoin1 = "NDVI_Poly_ECCCJoin"
PolyJoin2 = "NDVI_Poly_FinalJoin"
arcpy.SpatialJoin_analysis (Poly1, Shoreline1,PolyJoin1,"JOIN_ONE_TO_ONE", "KEEP_ALL", "#", "CLOSEST", "#", "#")
arcpy.SpatialJoin_analysis (PolyJoin1, Shoreline2,PolyJoin2,"JOIN_ONE_TO_ONE", "KEEP_ALL", "#", "CLOSEST", "5000", "#")


arcpy.SpatialJoin_analysis(Polygons.shp, Points.shp, outFeatureClass,
        join_operation = "JOIN_ONE_TO_ONE", join_type = "KEEP_ALL",
        field_mapping = "", match_option = "COMPLETELY_CONTAINS",
        search_radius = "", distance_field_name = "")


 # Clean up interim rasters
rasters = arcpy.ListRasters("*ras", "GRID")
for raster in rasters:
    arcpy.Delete_management(raster,"")

# Delete fields in Polygon file  (perhaps do this in the multipart file (speed up processing)
# This didn't work
# delFlds = "Join_Count;TARGET_FID;OBJECTID_1"
# arcpy.DeleteField_management(Poly2Join,delFlds)

# BoFTable = "N:/MSP/Data/NaturalResources/CoastalEnvironment/BoF.csv"
# ECCCTable = "N:/MSP/Data/NaturalResources/CoastalEnvironment/ECCC.csv"
BoFTable = "C:/BIO/20200306/GIS/Projects/MSP/Rockweed/NaturalResources/CoastalEnvironment/BoF.csv"
ECCCTable = "C:/BIO/20200306/GIS/Projects/MSP/Rockweed/NaturalResources/CoastalEnvironment/ECCC.csv"


# Set local variables    
layerName = "NDVI_layer"
joinField = "ECCC_ID"

# Create a feature layer from the vegtype featureclass
arcpy.MakeFeatureLayer_management (PolyJoin2,  layerName)

# Join the feature layer to a table
arcpy.AddJoin_management(layerName, joinField, ECCCTable, joinField)

# Join to BoF attributes
joinField = "BoFID"

# Join the feature layer to a table
arcpy.AddJoin_management(layerName, joinField, BoFTable, joinField)

outFeature = "NDVI_PolyFinal"
# Copy the layer to a new permanent feature class
arcpy.CopyFeatures_management(layerName, outFeature)

# Export the output rasters and polygon features

# set export compression
arcpy.env.compression = "LZW"
# Check to see what compression type is used.
# arcpy.env['compression']

newRas = "NDVI_Final"
# outTIF = "C:/BIO/20200306/GIS/Projects/MSP/Rockweed/Imagery/Satellite/Outputs/NDVI_UTM.TIF"
outTIF = "N:/MSP/Projects/Rockweed/Outputs/NDVI_UTM.TIF"
arcpy.CopyRaster_management(newRas,outTIF)

# reset export compression to NONE
# arcpy.env.compression = "NONE"

# Project Raster and export

OutCoordSystem = arcpy.SpatialReference(4326)
InCoordSystem = arcpy.SpatialReference(32620)

# Specify the resampling type (bilinear or cubic for continuous data, defaults to nearest)
ReSample = "BILINEAR"

# Define the output cell size (defaults to that of the input raster)
CellSize = "0.00011 0.00011"
outRas = "NDVI_FinalWGS"

# Project Raster doesn't seem to use the Compression environment.  It would be better to
# project a new raster into the Geodatabase and then export it (CopyRaster_management) from there.

arcpy.ProjectRaster_management(newRas, outRas, OutCoordSystem, ReSample, CellSize, "", "", InCoordSystem)

# outTIF = "C:/BIO/20200306/GIS/Projects/MSP/Rockweed/Imagery/Satellite/Outputs/NDVI_WGS84.TIF"
outTIF = "N:/MSP/Projects/Rockweed/Outputs/NDVI_WGS84.TIF"
arcpy.CopyRaster_management(outRas,outTIF)

# Create a new geodatabase
# Set local variables
FolderPath = "N:/MSP/Projects/Rockweed/Outputs" 
GDBname = "NDVI_poly.gdb"

# CreateFileGDB
arcpy.CreateFileGDB_management(FolderPath, GDBname)

# copy the polygon feature class over to the new GDB

outFeatureClass = os.path.join(FolderPath, GDBname, outFeature)
arcpy.CopyFeatures_management(outFeature, outFeatureClass)
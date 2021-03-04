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
# GenerateNearTable creates a table of all points and polygons within
# a specified distance
#
# Philip Greyson
# February 2021
############################################################################################
######################################################################################################################

import arcpy
import os
import numpy as np
import arcpy.sa as sa
import time
# from arcpy import env
# from arcpy.sa import *

arcpy.env.overwriteOutput = True
arcpy.CheckOutExtension("Spatial")
arcpy.env.qualifiedFieldNames = False # Maintains original field names and does not concatenate with the table name


# Create a new geodatabase
# Set local variables
FolderPath = "N:/MSP/Projects/Rockweed/Imagery/Satellite"
# FolderPath = r"\\dcnsbiona01a\BIODataSVC\IN\MSP\Projects\Rockweed\Imagery\Satellite"

# Using network paths
# https://gis.stackexchange.com/questions/85339/assigning-unc-path-to-arcpy-env-workspace

GDBname = "Processing.gdb"

# CreateFileGDB
arcpy.CreateFileGDB_management(FolderPath, GDBname)
gdbWorkspace = os.path.join(FolderPath, GDBname)

FolderPath = "N:/MSP/Projects/Rockweed/Imagery/Satellite/NDVI_Tiles"
arcpy.env.workspace = FolderPath

# create a list of all .TIF files in the workspace
rasters = arcpy.ListRasters("*", "TIF")

######################################################################################################################
# ######## Mosaic all tiles into a single raster in the geodatabase  ######## #

newRast = "NDVI_Mosaic"
arcpy.env.workspace = FolderPath
print("Mosaicing rasters")
arcpy.MosaicToNewRaster_management(rasters,gdbWorkspace, newRast, "#","32_BIT_FLOAT","#","1","FIRST","FIRST")
print(str(time.ctime(int(time.time()))))

# Set workspace to the Geodatabase

arcpy.env.workspace = gdbWorkspace

# Set processing extent environments
arcpy.env.snapRaster = newRast

outMask = "N:/MSP/Projects/Rockweed/Zones/ClippingMask.gdb/MARClippingMask"
# 
# # using the clipping Mask remove all values that fall under the mask
print("Erasing all vegs patches in open ocean using mask")
outCon = arcpy.sa.Con(arcpy.sa.IsNull(outMask),newRast,0) #trying to add sa to the Con Command
outName = "NDVI_Final"
outCon.save(outName)
print(str(time.ctime(int(time.time()))))
# set all values >= 0.4 to 1, everything else to NULL
outCon2 = arcpy.sa.SetNull(outCon <0.4, 1)

Poly1 = "NDVI_Poly"
# #---------------------------------------------------------------------------------#
# # Convert the raster to a polygon layer
print("Converted raster to polygon layer")
arcpy.RasterToPolygon_conversion(outCon2, Poly1, "NO_SIMPLIFY","VALUE")

delFlds = "gridcode"
arcpy.DeleteField_management(Poly1,delFlds)
print("Compacting GDB")
arcpy.Compact_management(gdbWorkspace)

Shoreline1 = "N:/MSP/Data/NaturalResources/CoastalEnvironment/AtlanticShorelineClassification_FGP/ECCC_Class.shp"
Shoreline2 = "N:/MSP/Data/NaturalResources/CoastalEnvironment/BoFShorelineClassification/BoFscat_Simp.shp"

PolyJoin1 = "NDVI_Poly_ECCCJoin"
PolyJoin2 = "NDVI_Poly_FinalJoin"
print("Joining Polys to coastal classification")
print(str(time.ctime(int(time.time()))))
arcpy.SpatialJoin_analysis(Poly1, Shoreline1,PolyJoin1,"JOIN_ONE_TO_ONE", "KEEP_ALL", "#", "CLOSEST", "#", "#")
arcpy.SpatialJoin_analysis(PolyJoin1, Shoreline2,PolyJoin2,"JOIN_ONE_TO_ONE", "KEEP_ALL", "#", "CLOSEST", "5000", "#")

# Clean up interim rasters
rasters = arcpy.ListRasters("*ras", "GRID")
for raster in rasters:
    arcpy.Delete_management(raster,"")

# Delete fields in Polygon file  (perhaps do this in the multipart file (speed up processing)
# This didn't work
# delFlds = "Join_Count;TARGET_FID;OBJECTID_1"
# arcpy.DeleteField_management(Poly2Join,delFlds)

BoFTable = "N:/MSP/Data/NaturalResources/CoastalEnvironment/BoF.csv"
ECCCTable = "N:/MSP/Data/NaturalResources/CoastalEnvironment/ECCC.csv"

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
print("Copying joined layer to FC (NDVI_PolyFinal")
print(str(time.ctime(int(time.time()))))
arcpy.CopyFeatures_management(layerName, outFeature)

# Export the output rasters and polygon features

# set export compression
arcpy.env.compression = "LZW"
# Check to see what compression type is used.
# arcpy.env['compression']

newRas = "NDVI_Final"
outTIF = "N:/MSP/Projects/Rockweed/Outputs/NDVI_UTM.TIF"
print("Exporting NDVI raster to tif")
print(str(time.ctime(int(time.time()))))
arcpy.CopyRaster_management(newRas,outTIF)


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
print("Projecting raster to WGS84")
print(str(time.ctime(int(time.time()))))
arcpy.ProjectRaster_management(newRas, outRas, OutCoordSystem, ReSample, CellSize, "", "", InCoordSystem)

# Export WGS84 version of the NDVI mosaic as .tif
outTIF = "N:/MSP/Projects/Rockweed/Outputs/NDVI_WGS84.TIF"
print("Exporting WGS version as tif")
print(str(time.ctime(int(time.time()))))
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

###########################################################
# Generate table of all points and polygons within 30 m
# of each other (using the iNaturalist locations)
# arcpy GenerateNearTable requires the Advanced
# ArcGIS license

PointObs = "N:/MSP/Projects/Rockweed/NaturalResources/Species/Rockweed/Rockweed_DB.shp"
PointObsUTM = "N:/MSP/Projects/Rockweed/NaturalResources/Species/Rockweed/Rockweed_DB_UTM.shp"

OutCoordSystem = arcpy.SpatialReference(32620)

# Project iNaturalist observations to UTM Zone20
arcpy.Project_management(PointObs, PointObsUTM, OutCoordSystem)

# GenerateNearTable produces only a .DBF or a GDB table.
# This can be opened in Excel or in R
outTable = "N:/MSP/Projects/Rockweed/Outputs/NearTable.dbf"
print("Generate Near Table")
try:
    arcpy.GenerateNearTable_analysis(in_features=outFeatureClass,
                near_features= PointObsUTM,
                out_table= outTable,
                search_radius="30 Meters",
                location="NO_LOCATION",
                angle="NO_ANGLE",
                closest="ALL",
                closest_count="0",
                method="PLANAR")
except:
    print("Generate near table failed")  



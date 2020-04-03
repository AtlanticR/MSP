#ImportantHabitat.py
#Author:   Anna Serdynska
#Date:     December 2012
#Purpose:  To create important habitat layers for various fish species from DFO's RV survey data
#Notes:    Need to defined RV data and Null sets shapefiles, output folders, target species name, and SQL expression to extract data


import arcpy
from arcpy.sa import *

# set Arc to overwrite pre-existing files
arcpy.env.overwriteOutput = True
# Set the extent environment to be the max of all input files
arcpy.env.extent = "MAXOF"
# Check out the ArcGIS Spatial Analyst extension license
arcpy.CheckOutExtension("Spatial")



#set input data here - RV survey and null sets
RV = r"D:\JCopy\MPAs\Marxan2\Analysis\ImportantHabitat\RVSummer_1970-2012_edit.shp"
Null = r"D:\JCopy\MPAs\Marxan2\Analysis\ImportantHabitat\Trials\NullSets.shp"

#############
#set spp name here - this will be the name of the output file
#everything that needs to be changed will be here
SppName = "redfish"
SppNameFull = "RedfishUnit3"
outFolder = r"D:\JCopy\MPAs\Marxan2\Analysis\ImportantHabitat\Fish\Species\Redfish\Unit3"
outFile = outFolder + "\\" + SppName + ".shp"
#this is the layer that goes into Marxan
outDiss = outFolder + "\\" + SppNameFull + "_poly.shp"
#############

#sql query here:

#sppSQL = """ "SPECIES_NA" = 'SEBASTES SP.' """
##4X5YZe:
#sppSQL = """ "SPECIES_NA" = 'SEBASTES SP.' AND ("NAFO" = '4X' OR "NAFO" = '5Y' OR "NAFO" = '5Ze') """
##4VW:
#sppSQL = """ "SPECIES_NA" = 'SEBASTES SP.' AND ("NAFO" = '4Vn' OR "NAFO" = '4Vs' OR "NAFO" = '4W') """
sppSQL = """ "SPECIES_NA" = 'SEBASTES SP.' AND ("Redfish" = 'Unit3') """


#rest of script goes here

#delete existing files
if arcpy.Exists(outFile):
    arcpy.Delete_management(outFile)

print "Creating " + str(SppNameFull) + ".shp..."

#copy nulls to spp name file
arcpy.CopyFeatures_management(Null, outFile)

#select species name from RV data and create temporary layer (sppLyr)
arcpy.MakeFeatureLayer_management(RV, "sppLyr", sppSQL)

#join spplyr to null sets
#add index to speed up the join
#arcpy.AddIndex_management(outFile, "SetID", "", "UNIQUE", "")
arcpy.JoinField_management(outFile, "SetID", "sppLyr", "SetID")


# ***raster creation starts here***

##this is here to test the raster half of the script
##outFile = r"D:\JCopy\MPAs\Marxan2\Analysis\PreferredHabitat\Trials\Output\amplaice.shp"

print "Creating rasters..."

#make point layers for each of the 5 time periods
outRaster1 = outFolder + "\\" + SppName + "7077"
outRaster2 = outFolder + "\\" + SppName + "7885"
outRaster3 = outFolder + "\\" + SppName + "8693"
outRaster4 = outFolder + "\\" + SppName + "9406"
outRaster5 = outFolder + "\\" + SppName + "0712"

arcpy.MakeFeatureLayer_management(outFile, "time1Lyr", """ "YEAR" >= 1970 AND "YEAR" <= 1977 """)
arcpy.MakeFeatureLayer_management(outFile, "time2Lyr", """ "YEAR" >= 1978 AND "YEAR" <= 1985 """)
arcpy.MakeFeatureLayer_management(outFile, "time3Lyr", """ "YEAR" >= 1986 AND "YEAR" <= 1993 """)
arcpy.MakeFeatureLayer_management(outFile, "time4Lyr", """ "YEAR" >= 1994 AND "YEAR" <= 2006 """)
arcpy.MakeFeatureLayer_management(outFile, "time5Lyr", """ "YEAR" >= 2007 AND "YEAR" <= 2012 """)


#IDW the layers from each time period

#IDW variables:
zField = "TOTWGT"
cellSize = 0.026
power = 2
searchRadius = "FIXED 0.15"

idw1 = arcpy.sa.Idw("time1Lyr", zField, cellSize, power, searchRadius)
idw1.save(outRaster1)
idw2 = arcpy.sa.Idw("time2Lyr", zField, cellSize, power, searchRadius)
idw2.save(outRaster2)
idw3 = arcpy.sa.Idw("time3Lyr", zField, cellSize, power, searchRadius)
idw3.save(outRaster3)
idw4 = arcpy.sa.Idw("time4Lyr", zField, cellSize, power, searchRadius)
idw4.save(outRaster4)
idw5 = arcpy.sa.Idw("time5Lyr", zField, cellSize, power, searchRadius)
idw5.save(outRaster5)

#reclassify the rasters for each time period to give a rank of 1-10
#using slice tool - equal area (this is the same as quantiles)
#the "r" on the end of the file name means the raster has been reclassified
outSlice1 = outRaster1 + "r"
outSlice2 = outRaster2 + "r"
outSlice3 = outRaster3 + "r"
outSlice4 = outRaster4 + "r"
outSlice5 = outRaster5 + "r"

slice1 = arcpy.sa.Slice(outRaster1, 10, "EQUAL_AREA")
slice1.save(outSlice1)
slice2 = arcpy.sa.Slice(outRaster2, 10, "EQUAL_AREA")
slice2.save(outSlice2)
slice3 = arcpy.sa.Slice(outRaster3, 10, "EQUAL_AREA")
slice3.save(outSlice3)
slice4 = arcpy.sa.Slice(outRaster4, 10, "EQUAL_AREA")
slice4.save(outSlice4)
slice5 = arcpy.sa.Slice(outRaster5, 10, "EQUAL_AREA")
slice5.save(outSlice5)

#Add the ranked rasters for all the time periods together using Cell Statistics
#this is the final prefhab raster
outPrefHab = outFolder + "\\" + SppName
outCellStats = arcpy.sa.CellStatistics([outSlice1, outSlice2, outSlice3, outSlice4, outSlice5], "SUM", "DATA")
outCellStats.save(outPrefHab)

#prepping layers for Marxan here:
print "Prepping output for Marxan..."

#convert raster to polygon
outPoly = outFolder + "\\" + SppName + "_temp.shp"
arcpy.RasterToPolygon_conversion(outPrefHab, outPoly, "NO_SIMPLIFY", "VALUE")

#dissolve
#outDiss = outFolder + "\\" + SppName + "_poly.shp"
arcpy.MakeFeatureLayer_management(outPoly, "polyLyr", """ "GRIDCODE" > 39 """)
arcpy.Dissolve_management("polyLyr", outDiss)

##arcpy.Delete_management(sppLyr)

print "*** Finished important habitat layers for " + str(SppNameFull) + " ***"
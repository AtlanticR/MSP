###########################################################################################
###########################################################################################
### 
### This code process different raster layers to the same spatial extent and resolution
### so that they can be used as predictor layers within a species distribution model
### 
### Author: Philip Greyson
### Date: June 2020
### 
### 
### Link for code repository
### https://github.com/AtlanticR/MSP/tree/master/SDM_ProcessData/code
### 
###########################################################################################
###########################################################################################


library(rgdal) # to read shapefiles
library(raster) # for the various raster functions
library(sp) # Classes and methods for spatial data

# bring in OceanMask for clipping data and rasters
# Polygon will represent the study area
dsn <- "../data/Boundaries"
# oceanMaskMAR <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone")
oceanMaskMAR <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone_Edit")

prj <- CRS("+init=epsg:4326") # EPSG code for WGS84
prjUTM <- CRS("+init=epsg:26920") # EPSG code for NAD83 UTM Zone 20

bathy <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/bathy.asc'
bath <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/NOAABath.tif'
sst <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/mean_jul_sst_2012_2018.tif'
chl <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/mean_jul_chl_2012_2018.tif'
sal <- 'U:/GIS/Projects/MSP/MSPData/NaturalResources/Climate/Sal_JulyMean_2012_14.tif' 
tem <- 'U:/GIS/Projects/MSP/MSPData/NaturalResources/Climate/Temp_JulyMean_2012_14.tif' 



rastNames <- c('bath','sst','chl','sal','tem')
rastList <- list(bath,sst,chl,sal,tem)
names(rastList) <- rastNames
# turn the .tifs and .asc files into RasterLayers
rastList1 <- lapply(rastList,raster)
# Set initial clipping extent from the smallest raster (bathy)

# See this post on alignning rasters:
# https://gis.stackexchange.com/questions/158159/snapping-raster-grids-in-r

# Set initial clipping extent from the smallest raster (bathy)
# get parameters of the bathymetry raster 
# to use in the resample() function
Resamp <- raster(bathy) 


# resample all rasters to the same extent (bathymetry layer)
# crop and mask to the Scotian Shelf extent
# project to UTM Zone 20, with a resolution of 1000m
Crop_fn <- function(y) {
   crs(y) <- prj
  y <- resample(y,Resamp)
  y <- crop(y,oceanMaskMAR)
  y <- mask(y,oceanMaskMAR)
  y <- projectRaster(y,crs = prjUTM,res = 1000)
}

# apply the Crop_fn() function to each raster in the list
rastList2 <- lapply(rastList1, Crop_fn)

# Round down values in rasters to reduce precision.
# For bathymetry, round to zero decimal places
rastList2[[1]] <- round(rastList2[[1]],0) # this may not needed since I can use the datatype argument
# in writeRaster( , ,datatype = "INT2S")

for(i in 2:5){
  round(rastList2[[i]],1)
}

# Write the rasters to tif files
# The bathymetry tif should be an integer raster so the 
# writeRaster() command uses the datatype = "INT2S" argument
dsn <-  "./SDM_PacificMARCollaboration/DataInput"

tif <- paste(dsn,"/",names(rastList2[1]),"_1.tif",sep = "")
writeRaster(rastList2[[1]],tif,overwrite = TRUE,datatype = "INT2S")

for(i in 2:5){
  tif <- paste(dsn,"/",names(rastList2[i]),"_1.tif",sep = "")
  writeRaster(rastList2[[i]],tif,overwrite = TRUE)
}


# Create a stack of the rasters and export as a single tif file (5 bands)
st <- stack(rastList2)  # works!!!


################################################################################-
# select RV samples for barndoor skate and export as a shapefile

library(dplyr) # all-purpose data manipulation (loaded after raster package since both have a select() function)
library(Mar.datawrangling)


# Load RV data
data.dir <- "./data/mar.wrangling"
get_data('rv', data.dir = data.dir, quiet = TRUE)
# alternate site for the data:
# data.dir <- "//dcnsbiona01a/BIODataSVC/IN/MSP/Projects/Aquaculture/SearchPEZ/inputs/mar.wrangling"


yearb <- 1970
yeare <- 2019
clip_by_poly(db='rv', clip.poly = oceanMaskMAR) # clip data to the extent of the Ocean Mask
GSMISSIONS <- GSMISSIONS[GSMISSIONS$YEAR >= yearb & GSMISSIONS$YEAR < yeare & GSMISSIONS$SEASON=="SUMMER",]
GSXTYPE <- GSXTYPE[GSXTYPE$XTYPE==1,]
self_filter(keep_nullsets = FALSE,quiet = TRUE) # 659 in GSCAT
GSINF2 <- GSINF # make copy of GSINF to use for a full set of samples
GSSPECIES <- GSSPECIES[GSSPECIES$CODE==200,]
self_filter(keep_nullsets = FALSE,quiet = TRUE)
# Create a valid DEPTH field (Depth values are in fathoms)
GSINF2$DEPTH <- round((GSINF2$DMIN*1.8288+GSINF2$DMAX*1.8288)/2,2)
# Keep only the columns necessary
# ("MISSION" "SETNO" "SDATE" "STRAT" "DIST" "DEPTH" "BOTTOM_TEMPERATURE" "BOTTOM_SALINITY" "LATITUDE" "LONGITUDE")
GSINF2 <- dplyr::select(GSINF2,1:3,5,12,24,30:31,33:34)
# rename some fields
names(GSINF2)[7:8] <- c("BTEMP","BSAL")

# use a merge() to combine MISSION,SETNO with all species to create a presence/absence table
SpecOnly <- dplyr::select(GSSPECIES,3)
# rename 'CODE' to 'SPEC'
names(SpecOnly)[1] <- c("SPEC")

# this merge() creates a full set of all MISSION/SETNO and SPECIES combinations
Combined <- merge(GSINF2,SpecOnly)
GSCAT2 <- dplyr::select(GSCAT,1:3,6:7)
# SUM TOTNO and TOTWGT on MISSION and SETNO to get rid of the different size classes
GSCAT2 <- aggregate(GSCAT2[,4:5], by=list(GSCAT2$MISSION, GSCAT2$SETNO, GSCAT2$SPEC), FUN=sum)
# Column names after aggregate() function need to be re-established
names(GSCAT2)[1:3] <- c("MISSION","SETNO","SPEC")

# names(Combined)
# Merge Combined and GSCAT2 on MISSION and SETNO
allCatch <- merge(Combined, GSCAT2, all.x=T, by = c("MISSION", "SETNO", "SPEC"))
# Fill NA records with zero
allCatch$TOTNO[is.na(allCatch$TOTNO)] <- 0
allCatch$TOTWGT[is.na(allCatch$TOTWGT)] <- 0
# Standardize all catch numbers and weights to a distance of 1.75 nm
allCatch$STDNO <- allCatch$TOTNO*1.75/allCatch$DIST
allCatch$STDWGT <- allCatch$TOTWGT*1.75/allCatch$DIST

allCatch$Pres <- allCatch$TOTNO
allCatch$Pres[allCatch$TOTNO > 0] <- 1
summary(allCatch$Pres)
table(allCatch$Pres)
names(allCatch)
# Export the data as CSV
filename <- "Species200_All"
fullpath <- paste(dsn,"/",filename,".csv",sep = "")
write.csv(allCatch, fullpath)

# create spatial object out of allCatch with name of species
# write to shapefile
coordinates(allCatch) <- ~LONGITUDE+LATITUDE
proj4string(allCatch)<- CRS("+init=epsg:4326")
allCatchUTM<-spTransform(allCatch,CRS("+init=epsg:26920"))

# Export the shapefile - NOTE, this was done to compare with ArcGIS processing
# print(paste("Loop ",count, " - exporting shapefile",sep = ""))

writeOGR(allCatchUTM,dsn,"Species200",driver="ESRI Shapefile")


# - ------------------------------END Get Barndoor skate RV data ----------------------


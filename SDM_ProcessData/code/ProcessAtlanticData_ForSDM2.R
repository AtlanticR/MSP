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
##########################################################-
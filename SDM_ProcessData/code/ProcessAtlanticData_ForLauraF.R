library(rgdal) # to read shapefiles
library(raster) # for the various raster functions
library(sp) # Classes and methods for spatial data


wd <- "C:/BIO/20200306/GIT/R/MSP"
setwd(wd)

prj <- CRS("+init=epsg:4326") # EPSG code for WGS84
prjAlbers <- CRS("+init=esri:102001") # ESRI code for Canada Albers Equal Area (NAD83)

# bring in clipping boundary
dsn <- "../data/Projects/LauraFeyrer/Zones"

bound <- readOGR(dsn,"HA_extent_20200708")


# bathy <- '../data/Projects/SDM_Pacific/predictors/bathy.asc'
bath <- '../data/Projects/SDM_Pacific/predictors/NOAABath.tif'
sst <- '../data/Projects/LauraFeyrer/Imagery/Satellite/mean_noaa_sst_MJJA_2010-2019.tif'

chl <- '../data/Projects/LauraFeyrer/Imagery/Satellite/mean_modis_chl_MJJA_2010-2019.tif'
# sal <- 'U:/GIS/Projects/MSP/MSPData/NaturalResources/Climate/Sal_JulyMean_2012_14.tif' 
# tem <- 'U:/GIS/Projects/MSP/MSPData/NaturalResources/Climate/Temp_JulyMean_2012_14.tif' 
# temOld <- 'U:/GIS/Projects/MSP/MSPData/NaturalResources/Climate/Temp_JulyMean_2012_14_Old.tif'


rastNames <- c('bath','sst','chl','sal','tem')
rastList <- list(bath,sst,chl,sal,tem)

rastNames <- c('bath','sst','chl')
rastList <- list(bath,sst,chl)

# apply rastNames to the layers in the list
names(rastList) <- rastNames
# turn the .tifs and .asc files into RasterLayers
rastList1 <- lapply(rastList,raster)
# Set initial clipping extent from the smallest raster (bathy)

# See this post on alignning rasters:
# https://gis.stackexchange.com/questions/158159/snapping-raster-grids-in-r

# get parameters of the bathymetry raster 
# to use in the resample() function

Resamp <- raster(bath) 

# resample all rasters to the same extent (bathymetry layer)
# crop and mask to the same extent
# project to Canada equal area
prjFun <- function(y) {
  crs(y) <- prj
  y <- resample(y,Resamp)
  y <- crop(y,bound)
  y <- mask(y,bound)
  y <- projectRaster(y,crs = prjAlbers,res = 1000)
}

# apply the prjFun() function to each raster in the list
# This resamples all rasters to the same resolution, crops them
# to the extent of the boundary file,
# and projects them to the same Projection/Coordinate system
rastList2 <- lapply(rastList1,prjFun)

# reduce numerical precision of the grids
rastList2[[1]] <- round(rastList2[[1]],0) # this isn't really needed since I can use the datatype argument
# in writeRaster( , ,datatype = "INT2S")

rastList2[[2]] <- round(rastList2[[2]],1)
rastList2[[3]] <- round(rastList2[[3]],1)



plot(rastList2[[1]])
plot(rastList2[[2]])
plot(rastList2[[3]])
# plot(rastList2[[4]])
# plot(rastList2[[5]])

summary(rastList2[[1]])

dsn <- "./SDM_ProcessData/Output"

# Write the rasters to tif files
tif <- paste(dsn,"/",names(rastList2[1]),"_1.tif",sep = "")
writeRaster(rastList2[[1]],tif,overwrite = TRUE,datatype = "INT2S")
tif <- paste(dsn,"/",names(rastList2[2]),"_1.tif",sep = "")
writeRaster(rastList2[[2]],tif,overwrite = TRUE)
tif <- paste(dsn,"/",names(rastList2[3]),"_1.tif",sep = "")
writeRaster(rastList2[[3]],tif,overwrite = TRUE)

# 
# tif <- paste(dsn,"/",names(rastList2[4]),"_1.tif",sep = "")
# writeRaster(rastList2[[4]],tif,overwrite = TRUE)
# tif <- paste(dsn,"/",names(rastList2[5]),"_1.tif",sep = "")
# writeRaster(rastList2[[5]],tif,overwrite = TRUE)



# Create a stack of the rasters and export as a single tif file (5 bands)
st <- stack(rastList2)  # works!!!
tif2=paste(dsn,"/Stack_1.tif",sep = "")
writeRaster(st,tif2)


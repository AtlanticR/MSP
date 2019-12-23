library(rgdal) # to read shapefiles
library(raster) # for the shapefile function (similar to writeOGR)
library(dplyr) # all-purpose data manipulation (loaded after raster package since both have a select() function)
library(gstat) # for IDW function
library(sp) #Classes and methods for spatial data
library(Mar.datawrangling)
library(rgeos) # required for the dissolve argument in rasterToPolygon() according to help file
library(moments) # required for skewness calculation

# Load RV data

wd <- "//ent.dfo-mpo.ca/ATLShares/Science/CESD/HES_MSP/R"
setwd(wd)

data.dir <- "./data/mar.wrangling"
get_data('rv', data.dir = data.dir)
# alternate site for the data:
# data.dir <- "//dcnsbiona01a/BIODataSVC/IN/MSP/Projects/Aquaculture/SearchPEZ/inputs/mar.wrangling"


# bring in OceanMask for clipping data and rasters
dsn <- "./data/Boundaries"
oceanMaskMAR <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone")
oceanMaskATL <- readOGR() # NEED TO CONVERT GDB FC to shapefile
oceanMaskUTM <- spTransform(oceanMaskMAR,CRS("+init=epsg:26920"))

prj <- CRS("+init=epsg:4326")


bath <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/bathy.asc'
sst <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/mean_jul_sst_2012_2018.tif'
chl <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/mean_jul_chl_2012_2018.tif'
sal <- 'U:/GIS/Projects/MSP/MSPData/NaturalResources/Climate/Sal_JulyMean_2012_14.tif' 
tem <- 'U:/GIS/Projects/MSP/MSPData/NaturalResources/Climate/Temp_JulyMean_2012_14.tif' 

rastList <- c(bath,sst,chl,sal,tem)

tem1 <- raster(tem)
new <- prjFun(tem1)
prjFun <- function(x) {
  # raster(x)
  crs(x) <- prj
  x2 <- crop(x,oceanMaskMAR)
  mask(x2,oceanMaskMAR)

  names(s) <- names(x)
}

new1 <- new[new < -2.5] <- NA # this didn't work to make NA all the values below -2.5
s <- calc(new, fun=function(x){ x[x < -2.5] <- NA; return(x)} ) # this doesn't go in function

test <- -2.4
rastList1 <- lapply(rastList,raster)
rastList2 <- lapply(rastList1,prjFun) 
plot(rastList2[[1]])
plot(rastList2[[2]])
plot(rastList2[[3]])
# The cropping and masking isn't working as it should
CRS("+init=epsg:4326")
rastList2 <- lapply(rastList1,crop, oceanMaskATL)

sstR <- raster(sst)

crop_sstR <- crop(sstR,oceanMaskMAR)
mask_sstR <- mask(sstR,oceanMaskMAR)
plot(crop_sstR)
plot(mask_sstR)
# perhaps I want to Crop first (get it down to a small extent)
# and then Mask (create NAs outside of the polygon)

mask2_sstR <- mask(crop_sstR,oceanMaskMAR)
plot(mask2_sstR)

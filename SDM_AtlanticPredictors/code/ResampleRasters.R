library(rgdal) # to read shapefiles
library(raster) # for the various raster functions
library(dplyr) # all-purpose data manipulation (loaded after raster package since both have a select() function)
library(gstat) # for IDW function
library(sp) #Classes and methods for spatial data
library(Mar.datawrangling)
library(rgeos) # required for the dissolve argument in rasterToPolygon() according to help file
library(moments) # required for skewness calculation

# Load RV data

wd <- "//ent.dfo-mpo.ca/ATLShares/Science/CESD/HES_MSP/R"
setwd(wd)

# bring in OceanMask for clipping data and rasters
dsn <- "./data/Boundaries"
oceanMaskMAR <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone")
# oceanMaskATL <- readOGR() # NEED TO CONVERT GDB FC to shapefile
oceanMaskUTM <- spTransform(oceanMaskMAR,CRS("+init=epsg:26920"))

prj <- CRS("+init=epsg:4326") # EPSG code for WGS84
prjUTM <- CRS("+init=epsg:26920") # EPSG code for NAD83 UTM Zone 20

bath <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/bathy.asc'
sst <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/mean_jul_sst_2012_2018.tif'
chl <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/mean_jul_chl_2012_2018.tif'
sal <- 'U:/GIS/Projects/MSP/MSPData/NaturalResources/Climate/Sal_JulyMean_2012_14.tif' 
tem <- 'U:/GIS/Projects/MSP/MSPData/NaturalResources/Climate/Temp_JulyMean_2012_14.tif' 

rastNames <- c('bath','sst','chl','sal','tem')
rastList <- list(bath,sst,chl,sal,tem)
names(rastList) <- rastNames
# turn the .tifs into RasterLayers
rastList1 <- lapply(rastList,raster)
# Set initial clipping extent from the smallest raster (bathy)
names(rastList1)


# See this post on alignning rasters:
# https://gis.stackexchange.com/questions/158159/snapping-raster-grids-in-r

# Load required libraries:
#   
# library(raster)
# library(rgdal)
# Read rasters:
#   
#   r1 = raster("./dir/r1.tif")
# r2 = raster("./dir/r2.tif")
# Resample to same grid:
#   
#   r.new = resample(r1, r2, "bilinear")
# If required (for masking), set extents to match:
#   
#   ex = extent(r1)
# r2 = crop(r2, ex)
# Removed data which falls outside one of the rasters (if you need to):
#   
#   r.new = mask(r.new, r2)
# Your rasters now match.

ext <- extent(rastList1[[1]])
Resamp <- rastList1[[1]]

prjFun <- function(y) {
  crs(y) <- prj
  y <- resample(y,Resamp)
  # y <- crop(y,ext)
  y <- crop(y,oceanMaskMAR)
  y <- mask(y,oceanMaskMAR)
  if (names(y) == "Sal_JulyMean_2012_14") {
    n <- names(y)
    y <- calc(y, fun=function(x){ x[x < 25] <- NA; return(x)} )
    names(y) <- n
    } else if (names(y) == "Temp_JulyMean_2012_14") {
      n <- names(y)
      y <- calc(y, fun=function(x){ x[x < -2.5] <- NA; return(x)} )
      names(y) <- n
    }
  
  y <- projectRaster(y,crs = prjUTM,res = 1000)
  #names(Ry) <- names(y)
}

rastList2 <- lapply(rastList1,prjFun)

# Export these

names(rastList2) <- rastNames
rastList2

dir <- "C:/Temp/"

exportFun <- function(y) {
  tif <- paste(dir,names(y),"4.tif",sep = "")
  writeRaster(y,tif)
  
}

lapply(rastList2,extent)
lapply(rastList2,res)
lapply(rastList2,summary)
st <- stack(rastList2)  # works!!!

lapply(rastList2,exportFun)
names(rastList2[[2]])
names(rastList2)


# -------------------------------excess crud --------------------------------------------------
y <- rastList[[2]]

tem1 <- raster(tem)
new <- prjFun(tem1)


new1 <- new[new < -2.5] <- NA # this didn't work to make NA all the values below -2.5
s <- calc(tem1, fun=function(x){ x[x < -2.5] <- NA; return(x)} ) # this doesn't go in function

test <- -2.4
rastList <- lapply(rastList,raster)

rastList2 <- lapply(rastList,prjFun) 
plot(rastList2[[1]])
plot(rastList2[[2]])
plot(rastList2[[3]])
plot(rastList2[[4]])
plot(rastList2[[5]])

plot(rastList2[[1]])
plot(rastList2[[2]])
plot(rastList2[[3]])
plot(rastList2[[4]])
plot(rastList2[[5]])

plot(new)

y <- rastList1[[4]]
names(y)
summary(y)
y <- calc(y, fun=function(x){ x[x < 30] <- NA; return(x)} )


names(rastList2)

y <- rastList1[[3]]




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


# Get resolution of finest grid (chl - 0.0104)
# Project that to UTM, get resolution
# Then project all others to that resolution and projection (projectRaster)


# get raster resolution of all rasters
lapply(rastList2,res)
# create a blank raster using projectExtent()
# then projectRaster()
extent1 <- extent(rastList1[[1]])
lapply(rastList1,extent)
rastList3 <- lapply(rastList1,crop,extent1)

lapply(rastList1,names)

# -------------------------------END excess crud ----------------------------------------------
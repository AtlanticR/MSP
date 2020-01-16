library(rgdal) # to read shapefiles
library(raster) # for the various raster functions
library(sp) # Classes and methods for spatial data

wd <- "//ent.dfo-mpo.ca/ATLShares/Science/CESD/HES_MSP/R/SDM_PacificMARCollaboration/DataInput"
setwd(wd)

bathy <- "bath_1.tif"
sst <- "sst_1.tif"
chl <- "chl_1.tif"
salinity <- "sal_1.tif"
temperature <- "tem_1.tif"
Species <- "Species200"
Bound <- "Poly1"

rastNames <- c('bathy','sst','chl','salinity','temperature')
rastList <- list(bathy,sst,chl,salinity,temperature)
names(rastList) <- rastNames
# turn the .tifs into RasterLayers
rastList1 <- lapply(rastList,raster)


bound <- readOGR(wd,Bound)
skate <- readOGR(wd,Species)

plot(bound)
points(skate)

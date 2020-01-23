library(rgdal) # to read shapefiles
library(raster) # for the various raster functions
library(sp) # Classes and methods for spatial data


# This is my R drive
wd <- "//ent.dfo-mpo.ca/ATLShares/Science/CESD/HES_MSP/R"
setwd(wd)

# bring in OceanMask for clipping data and rasters
dsn <- "./data/Boundaries"
# oceanMaskMAR <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone")
oceanMaskMAR <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone_Edit")
# oceanMaskATL <- readOGR() # NEED TO CONVERT GDB FC to shapefile
oceanMaskUTM <- spTransform(oceanMaskMAR,CRS("+init=epsg:26920"))

prj <- CRS("+init=epsg:4326") # EPSG code for WGS84
prjUTM <- CRS("+init=epsg:26920") # EPSG code for NAD83 UTM Zone 20

bathy <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/bathy.asc'
bath <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/NOAABath.tif'
sst <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/mean_jul_sst_2012_2018.tif'
chl <- 'R:/Science/CESD/HES_MSP/R/data/Projects/SDM_Pacific/predictors/mean_jul_chl_2012_2018.tif'
sal <- 'U:/GIS/Projects/MSP/MSPData/NaturalResources/Climate/Sal_JulyMean_2012_14.tif' 
tem <- 'U:/GIS/Projects/MSP/MSPData/NaturalResources/Climate/Temp_JulyMean_2012_14.tif' 
temOld <- 'U:/GIS/Projects/MSP/MSPData/NaturalResources/Climate/Temp_JulyMean_2012_14_Old.tif'


rastNames <- c('bath','sst','chl','sal','tem')
rastList <- list(bath,sst,chl,sal,tem)
names(rastList) <- rastNames
# turn the .tifs and .asc files into RasterLayers
rastList1 <- lapply(rastList,raster)
# Set initial clipping extent from the smallest raster (bathy)
names(rastList1)


# See this post on alignning rasters:
# https://gis.stackexchange.com/questions/158159/snapping-raster-grids-in-r

# get parameters of the bathymetry raster 
# to use in the resample() function

Resamp <- raster(bathy) 


# resample all rasters to the same extent (bathymetry layer)
# crop and mask to the Scotian Shelf extent
# project to UTM Zone 20, with a resolution of 1000m
prjFun <- function(y) {
  crs(y) <- prj
  y <- resample(y,Resamp)
  y <- crop(y,oceanMaskMAR)
  y <- mask(y,oceanMaskMAR)
  y <- projectRaster(y,crs = prjUTM,res = 1000)
}

# apply the prjFun() function to each raster in the list
rastList2 <- lapply(rastList1,prjFun)

# name the rasters in the new list
names(rastList2) <- rastNames

rastList2[[1]] <- round(rastList2[[1]],0) # this isn't really needed since I can use the datatype argument
# in writeRaster( , ,datatype = "INT2S")

rastList2[[2]] <- round(rastList2[[2]],1)
rastList2[[3]] <- round(rastList2[[3]],1)
rastList2[[4]] <- round(rastList2[[4]],1)
rastList2[[5]] <- round(rastList2[[5]],1)


plot(rastList2[[1]])
plot(rastList2[[2]])
plot(rastList2[[3]])
plot(rastList2[[4]])
plot(rastList2[[5]])

dsn <-  "//ent.dfo-mpo.ca/ATLShares/Science/CESD/HES_MSP/R/SDM_PacificMARCollaboration/DataInput"

start_time <- Sys.time()
for(i in 1:5){
  rast <- rastList2[[i]] > -9999 # WHAT'S THIS FOR?
  poly <- rasterToPolygons(rast,na.rm = TRUE, dissolve = TRUE)
  writeOGR(poly,dsn,paste("Poly_",names(rastList2[i]),sep = ""),driver="ESRI Shapefile", overwrite_layer = TRUE)
}
end_time <- Sys.time()
end_time - start_time



SumFun <- function(y) {
  table(as.vector(y))
}

# Write the rasters to tif files
tif <- paste(dsn,"/",names(rastList2[1]),"_1.tif",sep = "")
writeRaster(rastList2[[1]],tif,overwrite = TRUE,datatype = "INT2S")
tif <- paste(dsn,"/",names(rastList2[2]),"_1.tif",sep = "")
writeRaster(rastList2[[2]],tif,overwrite = TRUE)
tif <- paste(dsn,"/",names(rastList2[3]),"_1.tif",sep = "")
writeRaster(rastList2[[3]],tif,overwrite = TRUE)
tif <- paste(dsn,"/",names(rastList2[4]),"_1.tif",sep = "")
writeRaster(rastList2[[4]],tif,overwrite = TRUE)
tif <- paste(dsn,"/",names(rastList2[5]),"_1.tif",sep = "")
writeRaster(rastList2[[5]],tif,overwrite = TRUE)


# Create a stack of the rasters and export as a single tif file (5 bands)
st <- stack(rastList2)  # works!!!
tif2="C:/Temp/Stack.tif"
writeRaster(st,tif2)


# select RV samples for barndoor skate and export as a shapefile

library(dplyr) # all-purpose data manipulation (loaded after raster package since both have a select() function)
library(Mar.datawrangling)


# Load RV data
data.dir <- "./data/mar.wrangling"
get_data('rv', data.dir = data.dir, quiet = TRUE)
# alternate site for the data:
# data.dir <- "//dcnsbiona01a/BIODataSVC/IN/MSP/Projects/Aquaculture/SearchPEZ/inputs/mar.wrangling"


yearb <- 2012
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
filename <- "Species200"
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


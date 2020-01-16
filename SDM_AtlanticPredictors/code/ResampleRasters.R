library(rgdal) # to read shapefiles
library(raster) # for the various raster functions
library(sp) # Classes and methods for spatial data



wd <- "//ent.dfo-mpo.ca/ATLShares/Science/CESD/HES_MSP/R"
setwd(wd)

# bring in OceanMask for clipping data and rasters
dsn <- "./data/Boundaries"
oceanMaskMAR <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone")
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
rastList2[[4]] <- round(calc(rastList2[[4]], fun=function(x){ x[x < 25] <- NA; return(x)} ),1)
rastList2[[5]] <- round(calc(rastList2[[5]], fun=function(x){ x[x < -2.5] <- NA; return(x)} ),1)

resampFun <- function(y) {
  y <- y >-9999
  #table(as.vector(y))
  rasterToPolygons(y,na.rm = TRUE, dissolve = TRUE)
  writeOGR(poly,dsn,paste("Poly_",rastList2[[i]],sep = ""),driver="ESRI Shapefile", overwrite_layer = TRUE)
}



start_time <- Sys.time()
for(i in 1:5){
  rast <- rastList2[[i]] > -9999
  poly <- rasterToPolygons(rast,na.rm = TRUE, dissolve = TRUE)
  writeOGR(poly,dsn,paste("Poly_",rastList2[[i]],sep = ""),driver="ESRI Shapefile", overwrite_layer = TRUE)
}
end_time <- Sys.time()
end_time - start_time

writeOGR(poly,"//ent.dfo-mpo.ca/ATLShares/Science/CESD/HES_MSP/R/SDM_PacificMARCollaboration/DataInput","Poly1",driver="ESRI Shapefile", overwrite_layer = TRUE)

plot(poly)
SumFun <- function(y) {
  table(as.vector(y))
}

polyList3 <- lapply(rastList2,resampFun)

bathPoly <- rasterToPolygons(rastList3[[1]], na.rm = TRUE, dissolve = TRUE)

#dir <- "C:/Temp/"
dsn <-  "//ent.dfo-mpo.ca/ATLShares/Science/CESD/HES_MSP/R/SDM_PacificMARCollaboration/DataInput"

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

rastList2[[1]]
as.data.frame(table(as.vector(rastList2[[1]])))


# select RV samples for barndoor skate and export as a shapefile

library(dplyr) # all-purpose data manipulation (loaded after raster package since both have a select() function)
library(sp) #Classes and methods for spatial data
library(Mar.datawrangling)


# Load RV data
data.dir <- "./data/mar.wrangling"
get_data('rv', data.dir = data.dir)
# alternate site for the data:
# data.dir <- "//dcnsbiona01a/BIODataSVC/IN/MSP/Projects/Aquaculture/SearchPEZ/inputs/mar.wrangling"


# Make copies of all the GS tables
tmp_GSCAT <- GSCAT
tmp_GSDET <- GSDET
tmp_GSINF <- GSINF
tmp_GSMISSIONS <- GSMISSIONS
tmp_GSSPECIES <- GSSPECIES
tmp_GSSTRATUM <- GSSTRATUM
tmp_GSXTYPE <- GSXTYPE
tmp_FGP_TOWS_NW2 <- FGP_TOWS_NW2

# Restore original GS tables for filtering
GSCAT <- tmp_GSCAT
GSDET <- tmp_GSDET
GSINF <- tmp_GSINF
GSMISSIONS <- tmp_GSMISSIONS
GSSPECIES <- tmp_GSSPECIES
GSSTRATUM <- tmp_GSSTRATUM
GSXTYPE <- tmp_GSXTYPE
FGP_TOWS_NW2 <- tmp_FGP_TOWS_NW2

yearb <- 2012
yeare <- 2019
clip_by_poly(db='rv', clip.poly = oceanMaskMAR) # clip data to the extent of the Ocean Mask
GSMISSIONS <- GSMISSIONS[GSMISSIONS$YEAR >= yearb & GSMISSIONS$YEAR < yeare,]
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

writeOGR(allCatchUTM,"//ent.dfo-mpo.ca/ATLShares/Science/CESD/HES_MSP/R/SDM_PacificMARCollaboration/DataInput","Species200",driver="ESRI Shapefile")
writeOGR(allCatchUTM,dsn,"Species200",driver="ESRI Shapefile")





# - ---------------------------------- Get Barndoor skate RV data ----------------------
# make grid of all SUMMER samples to get min and max extent
clip_by_poly(db='rv', clip.poly = oceanMaskMAR) # clip data to the extent of the Ocean Mask
GSSPECIES <- GSSPECIES[GSSPECIES$CODE==200,] # barndoor skate
# GSSPECIES <- GSSPECIES[GSSPECIES$CODE==10,] # cod
GSXTYPE <- GSXTYPE[GSXTYPE$XTYPE==1,]
self_filter(keep_nullsets = FALSE,quiet = TRUE)

# Keep only the columns necessary
# ("MISSION" "SETNO" "SDATE" "LATITUDE" "LONGITUDE")
GSINF_all <- dplyr::select(GSINF,1:3,33:34)
# Convert to the Spatial Object
coordinates(GSINF_all) <- ~LONGITUDE+LATITUDE
proj4string(GSINF_all) <- CRS("+init=epsg:4326") # Define coordinate system (WGS84)
GSINF_allUTM <- spTransform(GSINF_all,CRS("+init=epsg:26920")) # Project to UTM










# -------------------------------excess crud --------------------------------------------------


# the export function didn't work as I'd wanted it to:

# Export these

dir <- "C:/Temp/"

exportFun <- function(y) {
  tif <- paste(dir,names(y),"_1.tif",sep = "")
  writeRaster(y,tif,overwrite = TRUE)
  
}


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
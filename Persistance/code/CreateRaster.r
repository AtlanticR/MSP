install.packages("rgeos")
# library(devtools) # needed for Mike's data wrangler? *needed for the install_github() command
library(rgdal) # to read shapefiles
library(raster) # for the shapefile function (similar to wrtieOGR)
library(dplyr) # all-purpose data manipulation (loaded after raster package since both have a select() function)
library(gstat) # for IDW function
library(sp) #Classes and methods for spatial data
library(sf) # package for GIS in R, loading shapefiles, projections, etc
library(tmap) # for simple mapping functions (from the Texas example)
library(rasterVis) # another Raster plotting package
library(Mar.datawrangling)
library(lubridate) # for the year() function
library(rgeos) # required for the dissolve argument in rasterToPolygon()

# Load RV data
data.dir <- "N:/MSP/Projects/Aquaculture/SearchPEZ/inputs/mar.wrangling"  
data.dir <- "U:/Data/Projects/BIO/MarDataWrangling/inputs/mar.wrangling"
"R:/Science/CESD/HES_MSP/R/data/mar.wrangling"

get_data('rv', data.dir = data.dir)

# bring in OceanMask for clipping data and rasters
dsn <- "U:/GIS/Projects/MSP/HotSpotCode/Boundaries"
oceanMask <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone")
oceanMaskUTM <- spTransform(oceanMask,CRS("+init=epsg:26920"))

# Make copies of all the GS tables
tmp_GSCAT <- GSCAT
tmp_GSDET <- GSDET
tmp_GSINF <- GSINF
tmp_GSMISSIONS <- GSMISSIONS
tmp_GSSPECIES <- GSSPECIES
tmp_GSSTRATUM <- GSSTRATUM
tmp_GSXTYPE <- GSXTYPE
tmp_FGP_TOWS_NW2 <- FGP_TOWS_NW2 # original has 146,365 rows
# Restore original GS tables for filtering
GSCAT <- tmp_GSCAT
GSDET <- tmp_GSDET
GSINF <- tmp_GSINF
GSMISSIONS <- tmp_GSMISSIONS
GSSPECIES <- tmp_GSSPECIES
GSSTRATUM <- tmp_GSSTRATUM
GSXTYPE <- tmp_GSXTYPE
FGP_TOWS_NW2 <- tmp_FGP_TOWS_NW2

# - Make oversize grid ----------------------
# make grid of all SUMMER samples to get min and max extent
GSMISSIONS <- GSMISSIONS[GSMISSIONS$SEASON=="SUMMER",]
GSXTYPE <- GSXTYPE[GSXTYPE$XTYPE==1,]
self_filter(keep_nullsets = FALSE,quiet = TRUE)

# Keep only the columns necessary
# ("MISSION" "SETNO" "SDATE" "LATITUDE" "LONGITUDE")
GSINF_all <- dplyr::select(GSINF,1:3,33:34)
# Convert to the Spatial Object
coordinates(GSINF_all) <- ~LONGITUDE+LATITUDE
proj4string(GSINF_all) <- CRS("+init=epsg:4326") # Define coordinate system (WGS84)
GSINF_allUTM <- spTransform(GSINF_all,CRS("+init=epsg:26920")) # Project to UTM


# Create an emtpy grid from the samples, 100,000 cells
# It's necessary to create an empty grid of all samples initially so that the individual
# date range grids have the same extents
# If the extents aren't identical the SUM function won't work
grd <- as.data.frame(spsample(GSINF_allUTM, "regular", n=100000))

names(grd)       <- c("X", "Y")
coordinates(grd) <- c("X", "Y")
gridded(grd)     <- TRUE  # Create SpatialPixel object
fullgrid(grd)    <- TRUE  # Create SpatialGrid object
proj4string(grd) <- proj4string(grd) <- CRS("+init=epsg:26920") # define grd projection (UTM Zone 20)
# - END Make oversize grid ----------------------

# Get list of species from other data table
fish <- read.csv("Spreadsheets/FifteenSpecies.csv", header = TRUE)
speciescode <- unique(fish[,14])
speciesname <- unique(fish[,14:16])

# Reduce number of species for testing processing
speciescode <- speciescode[7:9]
speciescode <- speciescode[7] # Redfish

#------ BEGIN Set year variables -----------------
# Single date range
yearb <- 2012
yeare <- 2015
# All sample years (1970 - 2018)
yearb <- c(1970, 1978, 1986, 1994, 2007, 2012)
yeare <- c(1978, 1986, 1994, 2007, 2012, 2019)
# reduced date range for testing processing
yearb <- c(1970, 1978)
yeare <- c(1977, 1985)
#------ END Set year variables -----------------




# ---------- BEGIN Test Loop 2 ----------------------####
# Restore original GS tables for filtering
GSCAT <- tmp_GSCAT
GSDET <- tmp_GSDET
GSINF <- tmp_GSINF
GSMISSIONS <- tmp_GSMISSIONS
GSSPECIES <- tmp_GSSPECIES
GSSTRATUM <- tmp_GSSTRATUM
GSXTYPE <- tmp_GSXTYPE
FGP_TOWS_NW2 <- tmp_FGP_TOWS_NW2


count <- 1
start_time <- Sys.time()
raster_list2 <- list()
for(i in 1:length(speciescode)) {
  Time <- 1
  raster_list <- list() # Create an empty list
  for (y in 1:length(yearb)) {
    yearb1 <- yearb[y]
    yeare1 <- yeare[y]
    Time1 <- paste("T", Time, "_", sep = "")
    print(paste("Loop ",count, sep = ""))
    # filter data
    clip_by_poly(db='rv', clip.poly = oceanMask) # clip data to the extent of the Ocean Mask
    GSMISSIONS <- GSMISSIONS[GSMISSIONS$YEAR >= yearb1 & GSMISSIONS$YEAR < yeare1 & GSMISSIONS$SEASON=="SUMMER",]
    GSXTYPE <- GSXTYPE[GSXTYPE$XTYPE==1,]
    self_filter(keep_nullsets = FALSE,quiet = TRUE) # 659 in GSCAT
    GSINF2 <- GSINF # make copy of GSINF to use for a full set of samples
    GSSPECIES <- GSSPECIES[GSSPECIES$CODE %in% speciescode[i],] # WORKS
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
    allCatch$STDNO <- allCatch$TOTNO*1.75/allCatch$DIST
    allCatch$STDWGT <- allCatch$TOTWGT*1.75/allCatch$DIST
    
    # create spatial object out of allCatch with name of species
    # write to shapefile
    coordinates(allCatch) <- ~LONGITUDE+LATITUDE
    proj4string(allCatch)<- CRS("+init=epsg:4326")
    allCatchUTM<-spTransform(allCatch,CRS("+init=epsg:26920"))
    
    # Export the shapefile
    print(paste("Loop ",count, " - exporting shapefile",sep = ""))
    writeOGR(allCatchUTM,"U:/GIS/Projects/MSP/HotSpotCode/Output/Test",paste(Time1,"SP_",speciescode[i],"_UTM",sep = ""),driver="ESRI Shapefile")
    
    # Interpolate the sample data (TOTWGT) using the large extent grid
    # Using the same values for Power and Search Radius as Anna's script (idp and maxdist)
    test.idw <- gstat::idw(STDWGT ~ 1, allCatchUTM, newdata=grd, idp=2.0, maxdist = 16668)
    
    # Convert IDW output to raster object then clip to Scotian Shelf
    r       <- raster(test.idw)
    r.m     <- mask(r, oceanMaskUTM)
    # create a quantile table (based on deciles for this particular grid)
    rq <- quantile(r.m,prob = seq(0, 1, length = 10))
    reclass_df =c(0, rq[1], 1,
                  rq[1], rq[2], 2,
                  rq[2], rq[3], 3,
                  rq[3], rq[4], 4,
                  rq[4], rq[5], 5,
                  rq[5], rq[6], 6,
                  rq[6], rq[7], 7,
                  rq[7], rq[8], 8,
                  rq[8], rq[9], 9,
                  rq[9], rq[10], 10)
    reclass_m <- matrix(reclass_df,ncol = 3, byrow = TRUE)
    # using the decile values from this grid, reclassify into 10 levels
    reclass_r <- reclassify(r.m,reclass_m)
    # add the reclassified raster to the raster_list() for later analysis
    raster_list[[y]] <- reclass_r
    
    # Export the raster
    dir <- "U:/GIS/Projects/MSP/HotSpotCode/Output/Test/"
    rtif <- paste(dir,Time1,"SP4_",speciescode[i],"rclass.tif",sep = "")
    tif <- paste(dir,Time1,"SP4_",speciescode[i],".tif",sep = "")
    # writeRaster(r.m,tif)
    # writeRaster(reclass_r,rtif)
    
    cleanup('rv')
    # Restore original GS tables for filtering
    GSCAT <- tmp_GSCAT
    GSDET <- tmp_GSDET
    GSINF <- tmp_GSINF
    GSMISSIONS <- tmp_GSMISSIONS
    GSSPECIES <- tmp_GSSPECIES
    GSSTRATUM <- tmp_GSSTRATUM
    GSXTYPE <- tmp_GSXTYPE
    FGP_TOWS_NW2 <- tmp_FGP_TOWS_NW2
    
    Time <- Time + 1
  }
  s <- sum(raster_list[[1]],raster_list[[2]],raster_list[[3]],raster_list[[4]],raster_list[[5]],raster_list[[6]])
  s2 <- s > 39
  raster_list2[[i]] <- s2
  count <- count + 1
}
end_time <- Sys.time()
end_time - start_time

# Rename each raster in raster_list2
start_time <- Sys.time()
for(i in 1:length(speciescode)){
  names(raster_list2[[i]]) <- paste("SP_",speciescode[i],sep = "")
  tif <- paste(dir,names(raster_list2[[i]]),"_SUM4.tif",sep = "")
  writeRaster(raster_list2[[i]],tif, overwrite = TRUE)
  poly <- rasterToPolygons(raster_list2[[i]], fun=function(x){x==1}, n=4, na.rm=TRUE, digits=12, dissolve=TRUE)
  # writeOGR(poly,"U:/GIS/Projects/MSP/HotSpotCode/Output/Test",paste("TestSP_",speciescode[i],sep = ""),driver="ESRI Shapefile", overwrite_layer = TRUE)
}
end_time <- Sys.time()
end_time - start_time



# ----------END  Test Loop----------------------####


# Links for some of the script parts below

# Gulf of Mexico
https://nceas.github.io/oss-lessons/spatial-data-gis-law/4-tues-spatial-analysis-in-r.html

# California
https://rspatial.org/raster/analysis/4-interpolation.html

# Texas
https://mgimond.github.io/Spatial/interpolation-in-r.html

# Creating a shapefile from DataFrame (easiest way)
https://gis.stackexchange.com/questions/214062/create-a-shapefile-from-dataframe-in-r-keeping-attribute-table

# -------------- working with raster extents---------------------

ext1 <- extent(raster_list[[1]])
ext2 <- extent(raster_list[[2]])
ext3 <- extent(raster_list[[3]])
raster_list[[7]] <- setExtent(raster_list[[2]],ext)
raster_list[[8]] <- setExtent(raster_list[[2]],ext, keepres = TRUE)
raster_list[[9]] <- setExtent(raster_list[[2]],raster_list[[1]], keepres = TRUE)
raster_list[[10]] <- setExtent(raster_list[[2]],raster_list[[1]], keepres = TRUE, snap = TRUE)
raster_list[[11]] <- setExtent(raster_list[[2]],raster_list[[1]], snap = TRUE)

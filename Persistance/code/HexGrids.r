
###########################################################################################
###########################################################################################
### 
### This code is a recreation in R of ImportantHabitat.py by Anna Serdynska from 2012
### Original purpose:
### "To create important habitat layers for various fish species from DFO's RV survey data"
### 
### Author: Philip Greyson
### Date: December 2020
### 
### Using RV survey data clipped to the Scotian Shelf this process interpolates surfaces of
### standardized catch weight (STDWGT) for six time periods, reclassifies the surfaces into
### deciles, sums the six surfaces together and then creates a summary surface for each 
### species out of the top 20 percent (sum > 48 out of possible 60).
### 
### Skewness and presence metrics are calculated for each species.
### The resultant raster, interpreted as a way of categorizing the persistance of a species
### through different management regimes, is exported.
### 
###########################################################################################
###########################################################################################


library(rgdal) # to read shapefiles
library(raster) # for the various raster functions
library(dplyr) # all-purpose data manipulation (loaded after raster package since both have a select() function)
library(gstat) # for IDW function
library(sp) #Classes and methods for spatial data
library(Mar.datawrangling)
library(rgeos) # required for the dissolve argument in rasterToPolygon() according to help file
library(moments) # required for skewness calculation
library(sf)

# Load RV data



wd <- "//ent.dfo-mpo.ca/ATLShares/Science/CESD/HES_MSP/R"
setwd(wd)

data.dir <- "./data/mar.wrangling"
get_data('rv', data.dir = data.dir)

# bring in OceanMask for clipping data and rasters
dsn <- "./data/Boundaries"
oceanMask <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone_Edit")
oceanMaskUTM <- spTransform(oceanMask,CRS("+init=epsg:26920"))



# bring in Hex grid for analysis
gridDSN <- "//dcnsbiona01a/BIODataSVC/IN/MSP/Projects/BaseGISData/Zones"
grid <- "HexGrid_400Mil_UTM_ScotianShelf"
HexGrid <- readOGR(gridDSN,grid)
# prjString <- crs(HexGrid)



# -------- Test with objects created below and the HexGrid ------------####

# allCatchAlbers is the point file
# HexGrid is the polygon

HexGrid2 <- over(HexGrid, allCatchUTM, fn = mean)
HexGrid3 <- over(HexGrid, allCatchAlbers)
summary(HexGrid2)
summary(HexGrid3)
head(HexGrid2)
head(HexGrid)

table(HexGrid2$MISSION)
HexTable <- as.data.frame(table(HexGrid3$STDWGT))

plot(HexGrid)
plot(allCatchAlbers, col = "red", add = TRUE)

crs(HexGrid)
crs(allCatchAlbers)


# Using the join functions in sf
# from https://ryanpeek.github.io/2019-04-29-spatial-joins-in-R/

Hex <- st_as_sf(HexGrid)
Catch <- st_as_sf(allCatchUTM)

points <- st_join(Catch, left = TRUE, Hex["GRID_ID"])
head(points)
plot(points$STDWGT)

# Keep only the columns necessary
# ("SDTWGT",GRID_ID)
points <- dplyr::select(points,13:14)
head(points)

#Add a column to get counts
points$count <- 1

points[,c(1,4)]
plot(points2)

as.data.frame(table(points2$count))
as.data.frame(table(points2$GRID_ID))

head(points2)

dsn <- "R:/Science/CESD/HES_MSP/R/data/Spreadsheets"

BSkate <- readOGR(dsn,"Species200_All")
names(BSkate)

Catch <- st_as_sf(BSkate)
Catch <- dplyr::select(Catch,3,13)
names(BSkate)

Catch <- st_as_sf(BSkate)
names(Catch)

points <- st_join(Catch, left = TRUE, Hex["GRID_ID"])
points$count <- 1

names(points)

# SUM TOTNO and TOTWGT on MISSION and SETNO to get rid of the different size classes
points2 <- stats::aggregate(points[,c(2,5)], by=list(points$GRID_ID), FUN=sum)
names(points2)[1] <- c("GRID_ID")
head(points2)
typeof(points2)


head(points2)
# Column names after aggregate() function need to be re-established
names(points2)[1] <- c("GRID_ID")
plot(points2)
# names(Combined)
# Merge Combined and GSCAT2 on MISSION and SETNO
HexGrid4 <- merge(HexGrid, points2, all.x=T, by = c("GRID_ID"))
plot(HexGrid4$count)


head(HexGrid4)

spplot(HexGrid4, zcol="STDWGT")

Hex <- st_as_sf(HexGrid4)


gridDSN <- "R:/Science/CESD/HES_MSP/R/Persistance/Output/HexGridJoin2.shp"

plot(Hex$STDWGT)
as.data.frame(table(Hex$STDWGT))
plot(as.data.frame(table(Hex$STDWGT)))


st_write(Hex, dsn = gridDSN, driver = "ESRI Shapefile")

# -------- END Test with objects created below and the HexGrid ------------####



# Make copies of all the GS tables
tmp_GSCAT <- GSCAT
tmp_GSDET <- GSDET
tmp_GSINF <- GSINF
tmp_GSMISSIONS <- GSMISSIONS
tmp_GSSPECIES <- GSSPECIES
tmp_GSSTRATUM <- GSSTRATUM
tmp_GSXTYPE <- GSXTYPE
tmp_FGP_TOWS_NW2 <- FGP_TOWS_NW2


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
# fish <- read.csv("./data/Spreadsheets/FifteenSpecies.csv", header = TRUE)
species <- read.csv("./data/Spreadsheets/ThirtyFiveSpecies.csv", header = TRUE)
# filter out snow crab.  snow crab was not recorded until 1981
species <- filter(species, CODE != 2526)
speciescode <- unique(species[,1])

# get names and Scinames of species as well
# speciescode <- unique(fish[,1:3])

# Reduce number of species for testing processing
speciescode <- speciescode[7:9]
speciescode <- speciescode[7] # Redfish
speciescode <- speciescode[1] # Cod


#------ Set year variables -----------------
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


# ---------- BEGIN Loops ----------------------####
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
raster_list2 <- list() # create list to hold rasters
skew_listFinal <- list() # create list to hold skewness values
presence_listFinal <- list() # create a list to hold presence values (row counts)
for(i in 1:length(speciescode)) {
  Time <- 1
  raster_list <- list() # Create an empty list
  skew_list1 <- list() # create list to hold skewness values
  presence_list1 <- list() # create a list to hold presence values (row counts)
  for (y in 1:length(yearb)) {
    yearb1 <- yearb[y]
    yeare1 <- yeare[y]
    Time1 <- paste("T", Time, "_", sep = "")
    print(paste("Loop ",count, "Time ", Time1, sep = ""))
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
    # Standardize all catch numbers and weights to a distance of 1.75 nm
    allCatch$STDNO <- allCatch$TOTNO*1.75/allCatch$DIST
    allCatch$STDWGT <- allCatch$TOTWGT*1.75/allCatch$DIST
    
    countAllSample <- nrow(allCatch)
    countPresence <- nrow(filter(allCatch,STDWGT > 0))
    
    presence <- paste(Time1, speciescode[i],countAllSample,countPresence,sep=":\t")
    presence_list1[[y]] <- presence
    
    # create spatial object out of allCatch with name of species
    # write to shapefile
    
    # make an SF spatial file
    
    coordinates(allCatch) <- ~LONGITUDE+LATITUDE
    proj4string(allCatch)<- CRS("+init=epsg:4326")
    
    allCatchAlbers <- spTransform(allCatch,"+proj=aea +lat_1=50 +lat_2=70 +lat_0=40 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0")
    allCatchUTM<-spTransform(allCatch,CRS("+init=epsg:26920")) # Canada Equal Area Albers Conformal
    
    # Export the shapefile - NOTE, this was done to compare with ArcGIS processing
    # print(paste("Loop ",count, " - exporting shapefile",sep = ""))
    dsn = "U:/GIS/Projects/MSP/Persistance/Output/"
    writeOGR(allCatchUTM,"U:/GIS/Projects/MSP/Persistance/Output",paste(Time1,"SP_",speciescode[i],"_UTM",sep = ""),driver="ESRI Shapefile")
    writeOGR(allCatchAlb,"U:/GIS/Projects/MSP/Persistance/Output",paste(Time1,"SP_",speciescode[i],"_UTM",sep = ""),driver="ESRI Shapefile")
    
    # Interpolate the sample data (STDWGT) using the large extent grid
    # Using the same values for Power and Search Radius as Anna's script (idp and maxdist)
    test.idw <- gstat::idw(STDWGT ~ 1, allCatchUTM, newdata=grd, idp=2.0, maxdist = 16668)
    
    # Convert IDW output to raster object then clip to Scotian Shelf
    r       <- raster(test.idw)
    r.m     <- mask(r, oceanMaskUTM)
    skew1 <- paste(Time1, speciescode[i],round(cellStats(r.m,stat = 'skew'),3),sep=":\t")
    skew_list1[[y]] <- skew1
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
    # dir <- "U:/GIS/Projects/MSP/HotSpotCode/Output/"
    dir <- "./Persistance/Output/"
    rtif <- paste(dir,Time1,"SP4_",speciescode[i],"rclass.tif",sep = "")
    tif <- paste(dir,Time1,"SP4_",speciescode[i],".tif",sep = "")
    writeRaster(r.m,tif)
    writeRaster(reclass_r,rtif)
    
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
  s2 <- s > 48 # Anna's original value was 39 but I've got another time period so increased it to 48 (80%)
  raster_list2[[i]] <- s2
  skew_listFinal[[i]] <- skew_list1
  presence_listFinal[[i]] <- presence_list1
  count <- count + 1
}

write.table(as.data.frame(skew_listFinal),"R:/Science/CESD/HES_MSP/R/Persistance/Output/Skewness.csv",sep=",")
write.table(as.data.frame(presence_listFinal),"R:/Science/CESD/HES_MSP/R/Persistance/Output/Presence.csv",sep=",")
end_time <- Sys.time()
end_time - start_time
# ---------- END Loops ----------------------####

# Rename each raster in raster_list2 and export as a .tif
start_time <- Sys.time()
for(i in 1:length(speciescode)){
  names(raster_list2[[i]]) <- paste("SP_",speciescode[i],sep = "")
  tif <- paste(dir,"/",names(raster_list2[[i]]),"_SUM.tif",sep = "")
  writeRaster(raster_list2[[i]],tif, overwrite = TRUE)
  # poly <- rasterToPolygons(raster_list2[[i]], fun=function(x){x==1}, n=4, na.rm=TRUE, digits=12, dissolve=TRUE)
  # writeOGR(poly,"U:/GIS/Projects/MSP/HotSpotCode/Output",paste("TestSP_",speciescode[i],sep = ""),driver="ESRI Shapefile", overwrite_layer = TRUE)
}
end_time <- Sys.time()
end_time - start_time





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

# home location
wd <- "C:/BIO/20200306/GIT/R/MSP"
setwd(wd)

source("./SpatialDataSynopsis/code/src/fn_MkGrid.r")
source("./SpatialDataSynopsis/code/src/fn_InterpolateRV.r")
source("./SpatialDataSynopsis/code/src/fn_PlotRasters.r")
source("./SpatialDataSynopsis/code/src/fn_PlotAll_Layout.r")
source("./SpatialDataSynopsis/code/src/fn_RestoreTables.r")

# wd <- "C:/Temp/BarndoorSkate"
# wd <- "//ent.dfo-mpo.ca/ATLShares/Science/CESD/HES_MSP/R"
# setwd(wd)

data.dir <- "../data/mar.wrangling"
get_data('rv', data.dir = data.dir)

save_tables('rv')

# bring in OceanMask for clipping data and rasters
dsn <- "../data/Boundaries"
oceanMask <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone_Edit")
oceanMaskUTM <- spTransform(oceanMask,CRS("+init=epsg:26920"))

# this command is superceded by the next command
# land <- readOGR(dsn, "ne_10m_land_Clip")
load("../data/Boundaries/land.RData")



# bring in Hex grid for analysis
gridDSN <- "../data/Zones"
grid <- "HexGrid_400Mil_UTM_ScotianShelf"
HexGrid <- readOGR(gridDSN,grid)
HexGridUTM <- spTransform(HexGrid,CRS("+init=epsg:26920"))
HexGridUTM_sf <- st_as_sf(HexGridUTM)

shpList <- list(c("ClipHexagons100SqKm", "ClipHexagons200SqKm", "ClipHexagons25SqKm", "ClipHexagons300SqKm", 
             "ClipHexagons_Oceans10sqkm", "HexGrid_400Mil_UTM_ScotianShelf"))

spList <- c("Hex100", "Hex200", "Hex25", "Hex300", "Hex10", "Hex400")

For i in 1:length(shpList) {
  tmpshp <- readOGR(gridDSN,shpList[[1]][i])
  # How do I rename tmpshp to have one of the names in spList
  
}

outList=list()
for(i in 1:length(shpList)) {
  # outList[[i]] <- readOGR(gridDSN,shpList[[1]][i])
  assign(spList[i],readOGR(gridDSN,shpList[[1]][i]))
  # How do I rename tmpshp to have one of the names in spList
} 
names(outList)=spList

names(shpList)=spList



# Bring in all grids
HexGrid100 <- readOGR(gridDSN, "ClipHexagons100SqKm")
HexGrid100_sf <- st_as_sf(HexGrid100)
HexGrid200 <- readOGR(gridDSN, "ClipHexagons200SqKm")
HexGrid200_sf <- st_as_sf(HexGrid200)
HexGrid25 <- readOGR(gridDSN, "ClipHexagons25SqKm")
HexGrid25_sf <- st_as_sf(HexGrid25)
HexGrid300 <- readOGR(gridDSN, "ClipHexagons300SqKm")
HexGrid300_sf <- st_as_sf(HexGrid300)
HexGrid10 <- readOGR(gridDSN, "ClipHexagons_Oceans10sqkm")
HexGrid10_sf <- st_as_sf(HexGrid10)
HexGrid400 <- readOGR(gridDSN, "HexGrid_400Mil_UTM_ScotianShelf")
HexGrid400_sf <- st_as_sf(HexGrid400)
HexGrid1000 <- readOGR(gridDSN, "ClipHexagons1000SqKm")
HexGrid1000_sf <- st_as_sf(HexGrid1000)

# prjString <- crs(HexGrid)
# save_tables('rv') # new command within Mar.datawrangler that puts a new set of 
#table in a new environment ('dw')


# Get list of species from other data table
# fish <- read.csv("./data/Spreadsheets/FifteenSpecies.csv", header = TRUE)
species <- read.csv("../data/Spreadsheets/ThirtyFiveSpecies.csv", header = TRUE)
# filter out snow crab.  snow crab was not recorded until 1981
species <- filter(species, CODE != 2526)
speciescode <- unique(species[,1])

# get names and Scinames of species as well
# speciescode <- unique(fish[,1:3])

# Reduce number of species for testing processing
# speciescode <- speciescode[7:9]
# speciescode <- speciescode[7] # Redfish
# speciescode <- speciescode[1] # Cod
# speciescode <- speciescode[c(1,22)] # Barndoor skate and cod
speciescode <- speciescode[22] # Barndoor skate


#------ Set year variables -----------------
# Single date range
yearb <- 2014
yeare <- 2020
# All sample years (1970 - 2018)
yearb <- c(1970, 1978, 1986, 1994, 2007, 2012)
yeare <- c(1978, 1986, 1994, 2007, 2012, 2019)
# reduced date range for testing processing
yearb <- c(1970, 1978)
yeare <- c(1977, 1985)

# All sample years (2000 - 2019)
yearb <- c(2000, 2005, 2009, 2014)
yeare <- c(2005, 2009, 2014, 2020)
#------ END Set year variables -----------------

HexGridUTM_sf <- HexGrid10_sf
HexGridUTM_sf <- HexGrid25_sf
HexGridUTM_sf <- HexGrid100_sf
HexGridUTM_sf <- HexGrid200_sf
HexGridUTM_sf <- HexGrid300_sf
HexGridUTM_sf <- HexGrid1000_sf

# ---------- BEGIN Loops ----------------------####

count <- 1
start_time <- Sys.time()
for(i in 1:length(speciescode)) {
  Time <- 1
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
    GSCAT2 <- dplyr::select(GSCAT,1:3,5:6)
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
    
    allCatch_sf <- st_as_sf(allCatch, coords = c("LONGITUDE","LATITUDE"), crs = 4326)
    allCatchUTM_sf <- st_transform(allCatch_sf, crs = 26920)
    
    countAllSample <- nrow(allCatch)
    countPresence <- nrow(filter(allCatch,STDWGT > 0))
    
    # create spatial object out of allCatch with name of species
    # write to shapefile
    
    # make an SF spatial file
    
    # coordinates(allCatch) <- ~LONGITUDE+LATITUDE
    # proj4string(allCatch)<- CRS("+init=epsg:4326")
    # 
    # allCatchAlbers <- spTransform(allCatch,"+proj=aea +lat_1=50 +lat_2=70 +lat_0=40 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0")
    # allCatchUTM<-spTransform(allCatch,CRS("+init=epsg:26920")) # Canada Equal Area Albers Conformal
    # 
    # HexGrid2 <- sp::over(allCatchUTM,HexGridUTM[,"GRID_ID"], fn = NULL)
    
    allCatchUTM_sf2 <- st_join(allCatchUTM_sf, left = FALSE, HexGridUTM_sf["GRID_ID"])
    
    Join1 <- allCatchUTM_sf2 %>% dplyr::select(STDWGT, GRID_ID)
    Join1$geometry <- NULL
    
  
    
    Join2 <- stats::aggregate(Join1[,c(1)], by=list(Join1$GRID_ID), FUN=sum)
    Join3 <- stats::aggregate(Join1[,c(1)], by=list(Join1$GRID_ID), FUN=mean)
    # Join4 <- stats::aggregate(Join1[,c(1)], by=list(Join1$GRID_ID), FUN=sd)
    Join5 <- count(Join1,GRID_ID)
    colname2 <- paste("T",y,"_WgtTot",sep = "")
    colname3 <- paste("T",y,"_WgtMean",sep = "")
    # colname4 <- paste("T",y,"_WgtSD",sep = "")
    colname5 <- paste("T",y,"_Ct",sep = "")
    # colname6 <- paste("T",y,"_CV",sep = "")
    names(Join2)[1:2] <- c("GRID_ID",colname2)
    names(Join3)[1:2] <- c("GRID_ID",colname3)
    # names(Join4)[1:2] <- c("GRID_ID",colname4)
    names(Join5)[2] <- colname5
    
    HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,Join2, by = "GRID_ID")
    HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,Join3, by = "GRID_ID")
    # HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,Join4, by = "GRID_ID")
    HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,Join5, by = "GRID_ID")
    
    # mutate(HexGridUTM_sf, !!colname6 := !!colname4/!!colname3)
    
    # This doesn't work.  the dplyr::mutate function doesn't recognise the variable column names
    # HexGridUTM_sf <- HexGridUTM_sf %>% mutate(colname6 = colname4/colname3)
    
    restore_tables('rv',clean = FALSE)
    Time <- Time + 1
  }
#  s <- sum(raster_list[[1]],raster_list[[2]],raster_list[[3]],raster_list[[4]],raster_list[[5]],raster_list[[6]])
#  s2 <- s > 48 # Anna's original value was 39 but I've got another time period so increased it to 48 (80%)

  count <- count + 1
  # HexGridUTM_sf$Sum <- sum(c(HexGridUTM_sf$T1_Wgt,HexGridUTM_sf$T2_Wgt,HexGridUTM_sf$T3_Wgt,HexGridUTM_sf$T4_Wgt))

  # this summing of columns is not working

  
  HexGridUTM_sf_TIB <- as_tibble(HexGridUTM_sf)
  HexGridNew <- HexGridUTM_sf_TIB %>% mutate(SumFinal = select(., c(T1_WgtTot,T2_WgtTot,T3_WgtTot,T4_WgtTot)) %>% 
                                                                 rowSums(na.rm = TRUE))
  HexGridUTM_sf <- HexGridNew %>% st_as_sf(crs = 26920)
}

HexGridUTM <- sf:::as_Spatial(HexGridUTM_sf)

# alternate way to convert sf object to SP object and retain attributes
# HexGridUTM <- as(HexGridUTM_sf,"Spatial")

# convert HexGridUTM to a raster on T1Biomass

rfake <- raster(ncol=341, nrow=293)
extent(rfake) <- extent(grd)
proj4string(rfake) <- proj4string(rfake) <- CRS("+init=epsg:26920")

r <- Gridlist$rawRaster

# for some reason the rasterize() function needs a Raster Layer and not a Spatial Grid
grd <- raster(grd)

HexList <- list() # create list to hold rasters
HexList[[1]] <- rasterize(HexGridUTM, grd, 'T1_WgtTot')
HexList[[2]] <- rasterize(HexGridUTM, grd, 'T2_WgtTot')
HexList[[3]] <- rasterize(HexGridUTM, grd, 'T3_WgtTot')
HexList[[4]] <- rasterize(HexGridUTM, grd, 'T4_WgtTot')

stackRas <- stack(HexList[[1]],HexList[[2]],HexList[[3]],HexList[[4]])

names(stackRas) <- c('SP200_hexsum_T1', 'SP200_hexsum_T2', 'SP200_hexsum_T3','SP200_hexsum_T4')
names(stackRas) <- c('SP200_hex400sum_T1', 'SP200_hex400sum_T2', 'SP200_hex400sum_T3','SP200_hex400sum_T4')
myRaster <- writeRaster(stackRas,"./SpatialDataSynopsis/Output/SP200_hex400sum.grd", format="raster")

names(stackRas) <- c('SP200_hex10sum_T1', 'SP200_hex10sum_T2', 'SP200_hex10sum_T3','SP200_hex10sum_T4')
myRaster <- writeRaster(stackRas,"./SpatialDataSynopsis/Output/SP200_hex10sum.grd", format="raster")

names(stackRas) <- c('SP200_hex25sum_T1', 'SP200_hex25sum_T2', 'SP200_hex25sum_T3','SP200_hex25sum_T4')
myRaster <- writeRaster(stackRas,"./SpatialDataSynopsis/Output/SP200_hex25sum.grd", format="raster")

names(stackRas) <- c('SP200_hex100sum_T1', 'SP200_hex100sum_T2', 'SP200_hex100sum_T3','SP200_hex100sum_T4')
myRaster <- writeRaster(stackRas,"./SpatialDataSynopsis/Output/SP200_hex100sum.grd", format="raster")

names(stackRas) <- c('SP200_hex200sum_T1', 'SP200_hex200sum_T2', 'SP200_hex200sum_T3','SP200_hex200sum_T4')
myRaster <- writeRaster(stackRas,"./SpatialDataSynopsis/Output/SP200_hex200sum.grd", format="raster")

names(stackRas) <- c('SP200_hex300sum_T1', 'SP200_hex300sum_T2', 'SP200_hex300sum_T3','SP200_hex300sum_T4')
myRaster <- writeRaster(stackRas,"./SpatialDataSynopsis/Output/SP200_hex300sum.grd", format="raster")

names(stackRas) <- c('SP200_hex1000sum_T1', 'SP200_hex1000sum_T2', 'SP200_hex1000sum_T3','SP200_hex1000sum_T4')
myRaster <- writeRaster(stackRas,"./SpatialDataSynopsis/Output/SP200_hex1000sum.grd", format="raster")


writeRaster(stackRas,"./SpatialDataSynopsis/Output/Multi2.tif",format = "GTiff", bylayer = FALSE)

stackRas <- addLayer(stackRas,HexList[[1]])
stackRas <- addLayer(stackRas,HexList[[2]])
stackRas <- addLayer(stackRas,HexList[[3]])
stackRas <- addLayer(stackRas,HexList[[4]])

stack2 <- stack("./SpatialDataSynopsis/Output/Multi2.tif")
names(stack2) <- c('SP200_hexsum_T1', 'SP200_hexsum_T2', 'SP200_hexsum_T3','SP200_hexsum_T4')
names(stack2)

myRaster <- writeRaster(stackRas,"./SpatialDataSynopsis/Output/Multi3.grd", format="raster")
stack3 <- stack("./SpatialDataSynopsis/Output/Multi3.grd")
names(stack3)



plot(stack3)

tif <- "./SpatialDataSynopsis/Output/SP200_hexsum_T1.tif"
writeRaster(HexList[[1]],tif, overwrite = TRUE)

tif <- "./SpatialDataSynopsis/Output/SP200_hexsum_T2.tif"
writeRaster(HexList[[2]],tif, overwrite = TRUE)

tif <- "./SpatialDataSynopsis/Output/SP200_hexsum_T3.tif"
writeRaster(HexList[[3]],tif, overwrite = TRUE)

tif <- "./SpatialDataSynopsis/Output/SP200_hexsum_T4.tif"
writeRaster(HexList[[4]],tif, overwrite = TRUE)

tif <- "./SpatialDataSynopsis/Output/SP10_hexsum_T1.tif"
writeRaster(HexList[[1]],tif, overwrite = TRUE)

tif <- "./SpatialDataSynopsis/Output/SP10_hexsum_T2.tif"
writeRaster(HexList[[2]],tif, overwrite = TRUE)

tif <- "./SpatialDataSynopsis/Output/SP10_hexsum_T3.tif"
writeRaster(HexList[[3]],tif, overwrite = TRUE)

tif <- "./SpatialDataSynopsis/Output/SP10_hexsum_T4.tif"
writeRaster(HexList[[4]],tif, overwrite = TRUE)


for(i in 1:length(HexList)){
  names(HexList[[i]]) <- paste("T_",i,sep = "")
  tif <- paste(dir,names(HexList[[i]]),".tif",sep = "")
  writeRaster(HexList[[i]],tif, overwrite = TRUE)
  # poly <- rasterToPolygons(raster_list2[[i]], fun=function(x){x==1}, n=4, na.rm=TRUE, digits=12, dissolve=TRUE)
  # writeOGR(poly,"U:/GIS/Projects/MSP/HotSpotCode/Output",paste("TestSP_",speciescode[i],sep = ""),driver="ESRI Shapefile", overwrite_layer = TRUE)
}


# write out the HexGrid, calculate CV in Arc, bring back in:
dir

writeOGR(HexGridUTM,"./SpatialDataSynopsis/Output","HexGridDD_SP200_New",driver = "ESRI Shapefile",overwrite_layer = TRUE)

writeOGR(HexGridUTM,dir,"HexGridDD_SP200_New",driver = "ESRI Shapefile")
write.csv(HexGridUTM_sf,file = "./SpatialDataSynopsis/Hexsf.csv", sep = ",")
HexCV <- read.csv("./SpatialDataSynopsis/Output/HexCV.csv", header = TRUE)

HexGridUTM_sfNew <- filecsv %>% st_as_sf(crs = 26920)
names(filecsv)

HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,HexCV, by = "GRID_ID")

HexGridDD <- spTransform(HexGridUTM,CRS("+init=epsg:4326"))


# Get extents of all rasters
rasterObjects <- c(HexList[[1]],HexList[[2]],HexList[[3]],rfake, r, grd)

SpatialOutputs = c()

for(x in rasterObjects) {
  predname <-  x
  exts <- extent(x)
  SpatialOutputs <-  stack(c(SpatialOutputs, raster(predname)))
  
}

SpatialOutputs


SpatialOutputs <- setMinMax(SpatialOutputs)


# - Export as JPEGs

jpeg(filename = file.path(rasterdir, paste0(prefix, p, ".jpg")),
     width = 1200, height = 960, res = 250)



# send HexGridDD to fn_PlotAll.r
# with the other necessary files.

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

dsn <- "./SpatialDataSynopsis/Output/"

HexGridDD$T1_WgtTot[is.na(HexGridDD$T1_WgtTot)] <- 0


plot(HexGridDD[HexGridDD$T1_WgtTot > 0,], add = TRUE, col = 'red',border = 'red')


writeOGR(HexGridDD,dsn,"HexGridDD_SP200_New",driver = "ESRI Shapefile")
writeOGR(allCatchUTM,"./SpatialDataSynopsis/Output/",paste(Time1,"SP_",speciescode[i],"_UTM",sep = ""),driver="ESRI Shapefile")


# --- Test of summing columns ---------#
a<-as.data.frame(c(2000:2005))
a$Col1<-c(1:6)
a$Col2<-seq(2,12,2)

colnames(a)<-c("year","Col1","Col2")

for (i in 1:2){
  a[[paste("Var_", i, sep="")]]<-i*a[[paste("Col", i, sep="")]]
}
a

# Tidyverse solution
a %>%
  mutate(Total = select(., Var_1:Var_2) %>% rowSums(na.rm = TRUE))

a %>% mutate(a,Total = Var_1+Var_2)

test %>%
  mutate(Total = select(., Var_1:Var_2) %>% rowSums(na.rm = TRUE))
test %>% mutate(SumFinal = select(., TOTWGT:TOTNO) %>% rowSums(na.rm = TRUE))



# -------- Test with objects created below and the HexGrid ------------####

# allCatchAlbers is the point file
# HexGrid is the polygon
# over() is an SP function

HexGrid2 <- sp::over(HexGrid, allCatchUTM, fn = sum)
HexGrid3 <- sp::over(HexGrid, allCatchAlbers)
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

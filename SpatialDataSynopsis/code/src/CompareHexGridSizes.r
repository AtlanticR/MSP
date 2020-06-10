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
source("./SpatialDataSynopsis/code/src/fn_SelectAllRVSpatialExtentMkGrid.r")

data.dir <- "../data/mar.wrangling"
get_data('rv', data.dir = data.dir)

save_tables('rv')

# bring in OceanMask for clipping data and rasters
dsn <- "../data/Boundaries"
oceanMask <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone_Edit")

# bring in Hex grid for analysis
gridDSN <- "../data/Zones"
# grid <- "HexGrid_400Mil_UTM_ScotianShelf"
# HexGrid <- readOGR(gridDSN,grid)
# HexGridUTM <- spTransform(HexGrid,CRS("+init=epsg:26920"))
# HexGridUTM_sf <- st_as_sf(HexGridUTM)

save_tables('rv') # new command within Mar.datawrangler that puts a new set of 
# tables in a new environment ('dw')


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
speciescode <- speciescode[1] # Cod
# speciescode <- speciescode[c(1,22)] # Barndoor skate and cod
# speciescode <- speciescode[22] # Barndoor skate

#------ Import Hex Grid sizes and convert to sf Objects -----------------
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

HexList <- list()

HexList[[1]] <- HexGrid10_sf
HexList[[2]] <- HexGrid25_sf
HexList[[3]] <- HexGrid100_sf
HexList[[4]] <- HexGrid200_sf
HexList[[5]] <- HexGrid300_sf
HexList[[6]] <- HexGrid400_sf
HexList[[7]] <- HexGrid1000_sf


AreaList <- c(10,25,100,200,300,400,1000)


#------ END  -----------------


# ---------- BEGIN Loops ----------------------####
Gridlist <- list() # create list to hold HexGrids
count <- 1
start_time <- Sys.time()
for(i in 1:length(speciescode)) {
  Time <- 1
  for (y in 1:length(HexList)) {
    HexGridUTM_sf <- HexList[[y]]
    HexGridUTM_sf <-  HexGridUTM_sf %>% dplyr::select(GRID_ID, geometry)
    HexGridUTM_sf <- st_transform(HexGridUTM_sf, crs = 26920)
    
    print(paste("Loop ",names(HexGridUTM_sf), sep = ""))
    # filter data
    clip_by_poly(db='rv', clip.poly = oceanMask) # clip data to the extent of the Ocean Mask
    GSMISSIONS <- GSMISSIONS[GSMISSIONS$YEAR >= 2000 & GSMISSIONS$YEAR < 2020 & GSMISSIONS$SEASON=="SUMMER",]
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

    # Join the RV point file to the GRID_ID of the HexGrid.
    allCatchUTM_sf2 <- st_join(allCatchUTM_sf, left = FALSE, HexGridUTM_sf["GRID_ID"])
    # make a table of just the STDWGT and GRID_ID column
    Join1 <- allCatchUTM_sf2 %>% dplyr::select(STDWGT, GRID_ID)
    Join1$geometry <- NULL # I'm not sure this step is needed
    
    # Summarize the data (aggregate() function) to calculate the SUM, MEAN, and COUNT
    # of the points within each grid cell
#    Join2 <- stats::aggregate(Join1[,c(1)], by=list(Join1$GRID_ID), FUN=sum)
    Join3 <- stats::aggregate(Join1[,c(1)], by=list(Join1$GRID_ID), FUN=mean)
#    Join5 <- count(Join1,GRID_ID)
    # Join4 <- stats::aggregate(Join1[,c(1)], by=list(Join1$GRID_ID), FUN=sd)
    
    # Make new column names for these summaries including the time period and species
 #   colname2 <- paste("Sp",i,"_T",y,"_WgtTot",sep = "")
    colname3 <- "WgtMean"
    # colname4 <- paste("T",y,"_WgtSD",sep = "")
#    colname5 <- paste("T",y,"_Ct",sep = "")

 #   names(Join2)[1:2] <- c("GRID_ID",colname2)
    names(Join3)[1:2] <- c("GRID_ID",colname3)
    # names(Join4)[1:2] <- c("GRID_ID",colname4)
 #   names(Join5)[2] <- colname5
    
#    HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,Join2, by = "GRID_ID")
    HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,Join3, by = "GRID_ID")
    # HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,Join4, by = "GRID_ID")
 #   HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,Join5, by = "GRID_ID")
    
    # mutate(HexGridUTM_sf, !!colname6 := !!colname4/!!colname3)
    HexGridUTM_sf_TIB <- as_tibble(HexGridUTM_sf)
    HexGridNew <- HexGridUTM_sf_TIB %>% mutate(AvgPer = WgtMean/AreaList[y]) 
    colname <- paste("WgtMean_",AreaList[y],sep ="")
    names(HexGridNew)[names(HexGridNew) == "WgtMean"] <- colname
    colname <- paste("AvgPer_",AreaList[y],sep ="")
    names(HexGridNew)[names(HexGridNew) == "AvgPer"] <- colname
    
    HexGridUTM_sf <- HexGridNew %>% st_as_sf(crs = 26920)
    
    
    Gridlist[[y]] <- HexGridUTM_sf
    
    #summary(HexGridNew$AvgPer)
    
    restore_tables('rv',clean = FALSE)
    Time <- Time + 1
  }
  #  s <- sum(raster_list[[1]],raster_list[[2]],raster_list[[3]],raster_list[[4]],raster_list[[5]],raster_list[[6]])
  #  s2 <- s > 48 # Anna's original value was 39 but I've got another time period so increased it to 48 (80%)
  
  count <- count + 1



}


# alternate way to convert sf object to SP object and retain attributes
# HexGridUTM <- as(HexGridUTM_sf,"Spatial")

# Create empty grid with the extents of all RV summer samples
# Select RV samples for "summer" and type 1 and create 
# a point spatial object
# RVExtents <- SelectRV_fn("SUMMER", 1)

grd <- SelectRV_MkGrid_fn("SUMMER", 1, 100000)
restore_tables('rv',clean = FALSE)

HexRasList <- list() # create list to hold rasters

# for some reason the rasterize() function needs a Raster Layer and not a Spatial Grid
grd <- raster(grd)
stackRas <- raster(grd)
z=1

# Naming for the AvgPerSqKm
FieldList <- c("AvgPer_10", "AvgPer_25", "AvgPer_100", "AvgPer_200", "AvgPer_300", "AvgPer_400", "AvgPer_1000")
for(i in 1:length(Gridlist)) {
  HexRasList[[i]] <- rasterize(Gridlist[[i]], grd, FieldList[i])
  tmpRas <- rasterize(Gridlist[[i]], grd, FieldList[i])
  names(tmpRas) <- paste("SP",speciescode[z],"_AvgPerKm",AreaList[i],sep = "")
  stackRas <- addLayer(stackRas,tmpRas)
}
names(stackRas)
# Write the entire stack out as a .grd file
writeRaster(stackRas,"./SpatialDataSynopsis/Output/Sp10GridComparisonPerSqKm.grd", format="raster")

stackRas <- raster(grd)
# Naming for the MeanWgt
FieldList <- c("WgtMean_10", "WgtMean_25", "WgtMean_100", "WgtMean_200", "WgtMean_300", "WgtMean_400", "WgtMean_1000")
for(i in 1:length(Gridlist)) {
  HexRasList[[i]] <- rasterize(Gridlist[[i]], grd, FieldList[i])
  tmpRas <- rasterize(Gridlist[[i]], grd, FieldList[i])
  names(tmpRas) <- paste("SP",speciescode[z],"_Avg",AreaList[i],sep = "")
  stackRas <- addLayer(stackRas,tmpRas)
}
names(stackRas)


# Write the entire stack out as a .grd file
writeRaster(stackRas,"./SpatialDataSynopsis/Output/Sp10GridComparisonAvg.grd", format="raster")


# Export HexGrids as tables
for(i in 1:length(Gridlist)) {
  # print(names(Gridlist[[i]]))
  
  FileName <- paste("Grid",AreaList[i],".csv",sep = "")
  write.csv(Gridlist[i],FileName,row.names = FALSE)
}


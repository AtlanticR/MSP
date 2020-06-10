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

source("./SpatialDataSynopsis/code/src/fn_SelectAllRVSpatialExtentMkGrid.r")
# source("./SpatialDataSynopsis/code/src/fn_InterpolateRV.r")
# source("./SpatialDataSynopsis/code/src/fn_PlotRasters.r")
# source("./SpatialDataSynopsis/code/src/fn_PlotAll_Layout.r")
# source("./SpatialDataSynopsis/code/src/fn_RestoreTables.r")

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



# prjString <- crs(HexGrid)
save_tables('rv') # new command within Mar.datawrangler that puts a new set of 
# table in a new environment ('dw')


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
speciescode <- speciescode[c(1,22)] # Barndoor skate and cod
# speciescode <- speciescode[22] # Barndoor skate

# - Make oversize grid ----------------------
grd <- SelectRV_MkGrid_fn("SUMMER", 1, 100000)
restore_tables('rv',clean = FALSE)

# for some reason the rasterize() function needs a Raster Layer and not a Spatial Grid
grd <- raster(grd)
stackRas <- stack(grd)


#------ Set year variables -----------------
# Single date range
# yearb <- 2000
# yeare <- 2020
# # All sample years (1970 - 2018)
# yearb <- c(1970, 1978, 1986, 1994, 2007, 2012)
# yeare <- c(1978, 1986, 1994, 2007, 2012, 2019)
# # reduced date range for testing processing
# yearb <- c(1970, 1978)
# yeare <- c(1977, 1985)

# All sample years (2000 - 2019)
yearb <- c(2000, 2005, 2009, 2014)
yeare <- c(2005, 2009, 2014, 2020)
#------ END Set year variables -----------------


# ---------- BEGIN Loops ----------------------####


Gridlist <- list() # create list to hold HexGrids
count <- 1
start_time <- Sys.time()
for(i in 1:length(speciescode)) {
  Time <- 1
  HexGridUTM_sf <- st_as_sf(HexGridUTM)
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
    
    # Join the RV point file to the GRID_ID of the HexGrid.
    # This creates an sf Object of all the Points with associated GRID_ID.
    allCatchUTM_sf2 <- st_join(allCatchUTM_sf, left = FALSE, HexGridUTM_sf["GRID_ID"])
    # make a table of just the STDWGT and GRID_ID column
    Join1 <- allCatchUTM_sf2 %>% dplyr::select(STDWGT, GRID_ID)
    Join1$geometry <- NULL # I'm not sure this step is needed
    
    # Summarize the data (aggregate() function) to calculate the SUM, MEAN, and COUNT
    # of the points within each grid cell
    Join2 <- stats::aggregate(Join1[,c(1)], by=list(Join1$GRID_ID), FUN=sum)
    Join3 <- stats::aggregate(Join1[,c(1)], by=list(Join1$GRID_ID), FUN=mean)
    Join5 <- count(Join1,GRID_ID)
    # Join4 <- stats::aggregate(Join1[,c(1)], by=list(Join1$GRID_ID), FUN=sd)
    
    # Make new column names for these summaries including the time period and species
    # colname2 <- paste("Sp",i,"_T",y,"_WgtTot",sep = "")
    colname3 <- paste("T",y,"_WgtMean",sep = "")
    # colname4 <- paste("T",y,"_WgtSD",sep = "")
    # colname5 <- paste("T",y,"_Ct",sep = "")

    # names(Join2)[1:2] <- c("GRID_ID",colname2)
    names(Join3)[1:2] <- c("GRID_ID",colname3)
    # names(Join4)[1:2] <- c("GRID_ID",colname4)
    # names(Join5)[2] <- colname5
    
    # HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,Join2, by = "GRID_ID")
    HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,Join3, by = "GRID_ID")
    # HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,Join4, by = "GRID_ID")
    # HexGridUTM_sf <- dplyr::left_join(HexGridUTM_sf,Join5, by = "GRID_ID")

#    HexGridUTM_sf <- HexGridNew %>% st_as_sf(crs = 26920)

    restore_tables('rv',clean = FALSE)
    Time <- Time + 1
  }
  #  s <- sum(raster_list[[1]],raster_list[[2]],raster_list[[3]],raster_list[[4]],raster_list[[5]],raster_list[[6]])
  #  s2 <- s > 48 # Anna's original value was 39 but I've got another time period so increased it to 48 (80%)
  
  count <- count + 1

  HexGridUTM_sf_TIB <- as_tibble(HexGridUTM_sf)
  #HexGridUTM_sf_TIB <- HexGridUTM_sf_TIB %>% mutate(SumAvg = select(., c(T1_WgtMean,T2_WgtMean,T3_WgtMean,T4_WgtMean)) %>% 
   #                                                              rowSums(na.rm = TRUE))
  
 # try
  #HexGridUTM_sf_TIB$Avg <- HexGridUTM_sf_TIB %>% select(c(T1_WgtMean,T2_WgtMean,T3_WgtMean,T4_WgtMean) %>% rowMeans(na.rm = TRUE)
  #WHICH is exactly what is above   
  
  HexGridUTM_sf_TIB <- HexGridUTM_sf_TIB %>% mutate(AvgFinal = select(., c(T1_WgtMean,T2_WgtMean,T3_WgtMean,T4_WgtMean)) %>% 
                                                      rowMeans(na.rm = TRUE))
  # colname <- paste("SP",speciescode[i],"_AvgFinal",sep = "")
  # names(HexGridUTM_sf_TIB)[8] <- colname
  # 
  # colnamesList <- list()
  # sp = speciescode[i]
  # for (i in 1:4) {
  #   colname <- paste("SP",sp,"_T",i,"Avg",sep = "") 
  #   colnamesList[[i]] <- colname
  # }
  # 
  # for(i in 1:length(colnamesList)) {
  #   y <- i+2
  #   names(HexGridUTM_sf_TIB)[y] <- colnamesList[[i]]
  # }
  #
  
  # this next line assumes 4 time periods!
#  HexGridUTM_sf_TIB <- HexGridUTM_sf_TIB %>% mutate(AvgFinal = SumAvg/4) # calculate Average of the averages
#  HexGridUTM_sf_TIB <- HexGridUTM_sf_TIB %>% select(-SumAvg) # remove SumAvg column

# perhaps keep all the field names identical and rename them in the rasterize function  
#  colname <- paste("SP",speciescode[i],"_AvgFinal",sep = "")
#  names(HexGridUTM_sf_TIB)[names(HexGridUTM_sf_TIB) == "AvgFinal"] <- colname

  HexGridUTM_sf <- HexGridUTM_sf_TIB %>% st_as_sf(crs = 26920)
  # Gridlist[[y]] <- HexGridUTM_sf
  # names(Gridlist[[y]]) <- speciescode[i]
  
  # Rasterize the Species-specific means, name them and add to the Stack
  FieldList <- c("T1_WgtMean", "T2_WgtMean", "T3_WgtMean", "T4_WgtMean")
  for(z in 1:length(FieldList)) {
    tmpRas <- rasterize(HexGridUTM_sf, grd, FieldList[z])
    names(tmpRas) <- paste("SP",speciescode[i],"_T",z,"_HEXAVG",sep = "")
    stackRas <- addLayer(stackRas,tmpRas)
  }
  # Rasterize the Species-specific overall Avg, name it and add to the Stack
  tmpRas <- rasterize(HexGridUTM_sf, grd, "AvgFinal")
  names(tmpRas) <- paste("SP",speciescode[i],"TALL_HEXAVG",sep = "")
  stackRas <- addLayer(stackRas,tmpRas)
  
}

names(stackRas)

writeRaster(stackRas,"./SpatialDataSynopsis/Output/HexGridAverages.grd", format="raster")
###########################################################################################
###########################################################################################
### 
### This code is a modifiction in R of ImportantHabitat.py by Anna Serdynska from 2012
### Original purpose:
### "To create important habitat layers for various fish species from DFO's RV survey data"
### 
### Author: Philip Greyson
### Date: June 2020
### 
### Using RV survey data clipped to the Scotian Shelf this process maps the average (or sum)
### of standardized catch weight (STDWGT) for four time periods onto a hexagonal grid
### of 400 sq.km. area.
### 
### 
###########################################################################################
###########################################################################################


library(rgdal) # to read shapefiles
library(dplyr) # all-purpose data manipulation (loaded after raster package since both have a select() function)
library(sp) # Classes and methods for spatial data (reading and writing shapefiles)
library(Mar.datawrangling) # loads and filters RV survey data 
library(sf)


source("./SpatialDataSynopsis/code/tests/Test_fn_CreateSpPresenceObject.R")

data.dir <- "../data/mar.wrangling"
get_data('rv', data.dir = data.dir) # Load RV survey data tables

save_tables('rv') # creates a copy of RV survey tables to new environment ('dw')

# bring in OceanMask for clipping data and rasters
dsn <- "../data/Boundaries"
oceanMask <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone_Edit")
# oceanMaskUTM <- spTransform(oceanMask,CRS("+init=epsg:26920"))


# Get list of species from other data table
# fish <- read.csv("./data/Spreadsheets/FifteenSpecies.csv", header = TRUE)
species <- read.csv("../data/Spreadsheets/SynopsisSpecies.csv", header = TRUE)
# filter out low occurence species
# (NORTHERN WOLFFISH,SPOTTED WOLFFISH,ROUNDNOSE GRENADIER,CUSK,BARNDOOR SKATE,ARGENTINE(ATLANTIC),CAPELIN)
species <- dplyr::filter(species, !CODE %in% c(52,51,414,15,200,160,64))
speciescode <- unique(species[,1])

# Reduce number of species for testing processing
speciescode <- speciescode[1] # Cod


yearb <- c(2000, 2005, 2009, 2014)
yeare <- c(2005, 2009, 2014, 2020)
#------ END Set year variables -----------------
i <- 1
y <- 1
type <- 1
season <- 'SUMMER'
species <- 10
yearb1 <- 2000
yeare1 <- 2005

# ---------- BEGIN Loops ----------------------####



for(i in 1:length(speciescode)) {
  Time <- 1
  HexGridUTM_sf <- st_as_sf(HexGridUTM) # make a clean copy of HexGridUTM_sf for each species
  for (y in 1:length(yearb)) {
# run the function
    yearb1 <- yearb[y]
    yeare1 <- yeare[y]
    # allCatchUTM_sf_new <- CreatePresenceObject_fn(yearb1, yeare1, "SUMMER", 1, speciescode[i])
    TestReturn <- CreatePresenceObject_fn(yearb[y], yeare[y], "SUMMER", 1, speciescode[i])
    Returnlist <-  CreatePresenceObject_fn(yearb[y], yeare[y], "SUMMER", 1, speciescode[i])
    TestReturn2 <- CreatePresenceObject_fn(2000, 2005, "SUMMER", 1, 10)
}

